#!/usr/bin/env python3
"""extract.py: copy Raven's type declarations out of the oracle into C headers we own, one file per type.

One libclang parse of a module, with the module's define set from project.toml, decides which #if branches are live.
The script keeps struct, union, enum, and typedef declarations plus object-like macros with a value.
It drops function prototypes, extern variables, function-like macros, and inline function bodies.
Each kept declaration is a verbatim slice of the oracle source, so Raven's names and comments survive.
Inactive #if branches inside a slice are removed with the same macro set the parse used.

Output, flat in one directory:
  <TypeName>.h              one file per struct, union, enum, or typedef, named by the typedef where one exists
  constants_<header>.h      the object-like macros of one Raven header, in Raven's order, and of one Raven .c file for the macros and enums it defines for itself
  forward.h                 forward declarations and the typedefs that name a struct tag, so pointer fields never need an include
  all.h                     includes everything
  layout_asserts.h          sizeof and offsetof asserts for every record, the oracle's numbers
  extract.json              the manifest

A type file includes the files of the types it uses by value, the enums it references, and the constants files whose macros appear in it.
The includes come from the AST, not from Raven's include lines, because Raven relied on the .c file to include q_shared.h first.

Usage:
  .venv/bin/python extract.py mp-game                      # writes out/extract/mp-game/
  .venv/bin/python extract.py mp-game --out Sources/CJKAMP/include
  .venv/bin/python extract.py mp-game --check              # only report, write nothing

A file listed in adopted.json next to the output is never overwritten. The script reports its drift instead.
"""
from __future__ import annotations

import argparse
import json
import concurrent.futures
import multiprocessing
import os
import platform
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import closure as C
from rulings import HAND_FILES, HEADER_PRELUDES, PLATFORM_MACROS
from clang.cindex import CursorKind, TypeKind

REPO = C.REPO
ORACLE = C.ORACLE

RECORD_KINDS = {CursorKind.STRUCT_DECL, CursorKind.UNION_DECL, CursorKind.CLASS_DECL, CursorKind.CLASS_TEMPLATE}
BODY_KINDS = RECORD_KINDS | {CursorKind.ENUM_DECL}
KEPT_KINDS = BODY_KINDS | {CursorKind.TYPEDEF_DECL}
ARRAY_KINDS = {TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY, TypeKind.VARIABLEARRAY}

# Macros the parse defines for itself, and the platform switches q_shared.h derives. None belongs in an emitted header.
MACRO_SKIP = {
    "ID_INLINE", "MAC_STATIC", "NDEBUG", "QAGAME", "CGAME", "UI_EXPORTS", "MISSIONPACK", "_JK2", "_IMMERSION",
    "id386", "idppc", "CPUSTRING", "PATH_SEP", "stricmp", "Q_vsnprintf",
}


# ------------------------------------------------------------------ source access

_lines_cache: dict[str, list[str]] = {}


def lines_of(path: str) -> list[str]:
    if path not in _lines_cache:
        _lines_cache[path] = Path(path).read_text(errors="replace").splitlines()
    return _lines_cache[path]


def oracle_relative(path: str) -> str:
    return str(Path(path).resolve().relative_to(REPO.resolve()))


def in_oracle(path: str | None) -> bool:
    return bool(path) and Path(path).resolve().is_relative_to(ORACLE.resolve())


def tag_of(record) -> str | None:
    """The struct or union tag as written in the source, or None for a tagless record.
    libclang 18 gives a tagless record its typedef's name as spelling, so the spelling cannot tell the two apart."""
    tokens = [t.spelling for t in record.get_tokens()][:3]
    if len(tokens) >= 2 and tokens[0] in ("struct", "union", "class", "enum") and re.match(r"^[A-Za-z_]\w*$", tokens[1]):
        return tokens[1]
    return None


def strip_comments(text: str) -> str:
    return re.sub(r"/\*.*?\*/|//[^\n]*", " ", text, flags=re.S)


# ------------------------------------------------------------------ the macro truth

def macro_table(tu) -> dict[str, str | None]:
    """Every macro the parse defined, with its replacement text when it is one token, else None.
    This is the truth the preprocessor used, builtins included, so the #if resolver agrees with the parse."""
    table: dict[str, str | None] = {}
    for cur in tu.cursor.get_children():
        if cur.kind != CursorKind.MACRO_DEFINITION:
            continue
        tokens = [t.spelling for t in cur.get_tokens()]
        table[cur.spelling] = tokens[1] if len(tokens) == 2 else None
    return table


def enumerators_of(cur) -> list[str]:
    """The enumerator names of an enum definition, read from its tokens.
    The unity parse gives a second enum of one name in a later .c file no constants, so the cursor's children do not serve."""
    names: list[str] = []
    braces = 0
    parens = 0
    expect = False
    for token in (t.spelling for t in cur.get_tokens()):
        if token == "{":
            braces += 1
            expect = braces == 1
        elif token == "}":
            braces -= 1
        elif braces == 1 and token in ("(", ")"):
            parens += 1 if token == "(" else -1
        elif braces == 1 and parens == 0 and token == ",":
            expect = True
        elif braces == 1 and expect and re.fullmatch(r"[A-Za-z_]\w*", token):
            names.append(token)
            expect = False
    return names


def enumerator_values(cur) -> list[list[str | None]]:
    """The enumerators of an enum definition with the initializer text of each, None where Raven wrote no initializer."""
    rows: list[list[str | None]] = []
    braces = 0
    parens = 0
    expect = False
    for token in (t.spelling for t in cur.get_tokens()):
        if token == "{":
            braces += 1
            expect = braces == 1
            continue
        if token == "}":
            braces -= 1
            continue
        if braces != 1:
            continue
        if token in ("(", ")"):
            parens += 1 if token == "(" else -1
        if parens == 0 and token == ",":
            expect = True
        elif expect and re.fullmatch(r"[A-Za-z_]\w*", token):
            rows.append([token, None])
            expect = False
        elif rows and token != "=":
            rows[-1][1] = token if rows[-1][1] is None else f"{rows[-1][1]} {token}"
    return rows


def is_function_like(tokens) -> bool:
    """A function-like macro has an open paren glued to its name, with no space between."""
    return len(tokens) > 1 and tokens[1].spelling == "(" and tokens[1].extent.start.offset == tokens[0].extent.end.offset


class IfResolver:
    """This removes the inactive branches of the conditionals inside one slice of source text.
    It understands defined(), !, &&, ||, integer compares, and macro names with integer values.
    An expression it cannot evaluate keeps its text and is reported."""

    def __init__(self, macros: dict[str, str | None]):
        self.macros = macros
        self.unresolved: list[str] = []

    def platform(self, expr: str) -> bool:
        """True for a conditional that names a platform macro, which stays as text so each platform build takes its own arm."""
        return any(re.search(rf"\b{name}\b", expr) for name in PLATFORM_MACROS)

    def value(self, name: str) -> int:
        text = self.macros.get(name)
        if text is None:
            return 0
        try:
            return int(text.rstrip("uUlL"), 0)
        except ValueError:
            return 0

    def evaluate(self, expr: str) -> bool | None:
        expr = expr.strip()
        if self.platform(expr):
            return None
        expr = re.sub(r"defined\s*\(\s*(\w+)\s*\)", lambda m: "1" if m.group(1) in self.macros else "0", expr)
        expr = re.sub(r"defined\s+(\w+)", lambda m: "1" if m.group(1) in self.macros else "0", expr)
        expr = re.sub(r"\b([A-Za-z_]\w*)\b", lambda m: str(self.value(m.group(1))), expr)
        expr = expr.replace("&&", " and ").replace("||", " or ").replace("!", " not ")
        expr = expr.replace(" not =", " !=")
        try:
            return bool(eval(expr, {"__builtins__": {}}, {}))
        except Exception:
            return None

    def resolve(self, text_lines: list[str]) -> list[str]:
        out: list[str] = []
        # Each stack entry: [parent_active, this_branch_active, some_branch_taken, unresolved]
        stack: list[list] = []

        def active() -> bool:
            return all(entry[0] and entry[1] for entry in stack)

        for line in text_lines:
            stripped = line.strip()
            m = re.match(r"#\s*(ifdef|ifndef|if|elif|else|endif)\b(.*)", stripped)
            if not m:
                if active():
                    out.append(line)
                continue
            directive, rest = m.group(1), m.group(2).strip()
            if directive in ("ifdef", "ifndef", "if"):
                parent = active()
                if self.platform(rest):
                    result = None
                elif directive == "ifdef":
                    result = rest.split()[0] in self.macros
                elif directive == "ifndef":
                    result = rest.split()[0] not in self.macros
                else:
                    result = self.evaluate(rest)
                if result is None:
                    self.unresolved.append(stripped)
                    stack.append([parent, True, True, True])
                    out.append(line)
                else:
                    stack.append([parent, result, result, False])
            elif directive in ("elif", "else", "endif") and not stack:
                # The opener sits outside this slice, so the parse already resolved it. The line is not part of the declaration.
                continue
            elif directive == "elif":
                entry = stack[-1]
                if entry[3]:
                    out.append(line)
                    continue
                result = False if entry[2] else self.evaluate(rest)
                if result is None:
                    self.unresolved.append(stripped)
                    result = False
                entry[1] = result
                entry[2] = entry[2] or result
            elif directive == "else":
                entry = stack[-1]
                if entry[3]:
                    out.append(line)
                    continue
                entry[1] = not entry[2]
                entry[2] = True
            elif directive == "endif":
                entry = stack.pop()
                if entry[3]:
                    out.append(line)
        return out


# ------------------------------------------------------------------ the sweep

class Decl:
    def __init__(self, cur, kind: str, name: str):
        self.cur = cur
        self.kind = kind
        self.name = name
        self.file = cur.location.file.name
        self.stem = Path(self.file).stem
        # The output path mirrors the oracle path, so codemp/game/q_shared.h becomes codemp/game/q_shared/.
        # A .c file's own macros take a _c suffix, because bg_saga.c and bg_saga.h share a stem.
        suffix = "_c" if self.file.endswith(".c") else ""
        self.reldir = str(Path(oracle_relative(self.file)).parent.relative_to("oracle")) + "/" + self.stem + suffix
        self.start = cur.extent.start
        self.end = cur.extent.end
        self.includes: set[str] = set()
        self.forward_only = False
        self.override: str | None = None
        self.strip_defaults = False
        self.system: set[str] = set()

    @property
    def cite(self) -> str:
        return f"{oracle_relative(self.file)}:{self.start.line}"

    @property
    def filename(self) -> str:
        # A .c file's own enum stands beside its own macros, in the constants file of that .c file.
        if self.kind in ("macro", "c_enum"):
            return f"{self.reldir}/constants.h"
        if self.name:
            return f"{self.reldir}/{self.name}.h"
        # Raven writes `enum { FP_FIRST, ... };` and then `typedef int forcePowers_t;`, so an anonymous enum is a constant group.
        # Its file takes the first enumerator's name. An anonymous record with no typedef takes its line.
        if self.kind == "enum":
            first = next((c.spelling for c in self.cur.get_children() if c.kind == CursorKind.ENUM_CONSTANT_DECL), None)
            if first:
                return f"{self.reldir}/enum_{first}.h"
        return f"{self.reldir}/anonymous_{self.start.line}.h"

    def record(self):
        """The record or enum cursor behind this declaration, or None."""
        if self.kind == "typedef":
            target = self.cur.underlying_typedef_type.get_declaration()
            return target if target.kind in BODY_KINDS and target.is_definition() else None
        return self.cur


FILE_ORDER: list[str] = []
SYSTEM_INCLUDES: dict[str, list[str]] = defaultdict(list)
OUTSIDE_FILE_INCLUDE: dict[str, str] = {}
ALIAS: dict[str, str] = {}
DROPPED: list[str] = []
NOTES: list[str] = []


def map_outside_files(tu) -> None:
    """For every file outside the oracle, the include spelling an oracle header used to reach it, inherited down nested includes."""
    spelling_at: dict[tuple[str, int], str] = {}

    def collect(cur):
        for child in cur.get_children():
            if child.kind == CursorKind.INCLUSION_DIRECTIVE and child.location.file and in_oracle(child.location.file.name):
                spelling_at[(child.location.file.name, child.location.line)] = child.spelling
            elif child.kind in (CursorKind.NAMESPACE, CursorKind.LINKAGE_SPEC):
                collect(child)

    collect(tu.cursor)
    for inclusion in tu.get_includes():
        source = inclusion.source.name if inclusion.source else None
        target = inclusion.include.name
        if source is None or in_oracle(target):
            continue
        if in_oracle(source):
            spelling = spelling_at.get((source, inclusion.location.line))
            if spelling:
                OUTSIDE_FILE_INCLUDE[target] = spelling
        elif source in OUTSIDE_FILE_INCLUDE:
            OUTSIDE_FILE_INCLUDE.setdefault(target, OUTSIDE_FILE_INCLUDE[source])


def sweep(tu) -> list[Decl]:
    """Every kept top-level declaration in the oracle tree, in source order.
    FILE_ORDER records the oracle files in the order the translation unit reached them, which is Raven's include order."""
    map_outside_files(tu)
    decls: list[Decl] = []

    def visit(cur):
        for child in cur.get_children():
            loc = child.location.file
            if child.kind in (CursorKind.NAMESPACE, CursorKind.LINKAGE_SPEC):
                visit(child)
                continue
            if not in_oracle(loc and loc.name):
                continue
            if loc.name not in FILE_ORDER:
                FILE_ORDER.append(loc.name)
            if child.kind == CursorKind.INCLUSION_DIRECTIVE:
                # cindex asserts on an include that did not resolve, such as a Windows header.
                try:
                    target = child.get_included_file()
                except AssertionError:
                    target = None
                if target is not None and not in_oracle(target.name):
                    if child.spelling not in SYSTEM_INCLUDES[loc.name]:
                        SYSTEM_INCLUDES[loc.name].append(child.spelling)
                continue
            if child.kind == CursorKind.MACRO_DEFINITION:
                if child.spelling in MACRO_SKIP or child.spelling.startswith("__"):
                    continue
                tokens = list(child.get_tokens())
                if not tokens:
                    continue
                decls.append(Decl(child, "macro", child.spelling))
            elif child.kind == CursorKind.VAR_DECL and child.type.is_const_qualified() and any(c.kind != CursorKind.TYPE_REF for c in child.get_children()):
                # `const int MAX_SET_NAME_LENGTH = 64;` in snd_ambient.h sizes an array, which C cannot do with a variable.
                decls.append(Decl(child, "var", child.spelling))
            elif child.kind in KEPT_KINDS:
                if child.kind != CursorKind.TYPEDEF_DECL and not child.is_definition():
                    continue
                name = "" if child.kind != CursorKind.TYPEDEF_DECL and (child.is_anonymous() or "(" in child.spelling) else child.spelling
                kind = "class" if child.kind == CursorKind.CLASS_TEMPLATE else child.kind.name.replace("_DECL", "").lower()
                decls.append(Decl(child, kind, name))

    visit(tu.cursor)
    decls.sort(key=lambda d: (d.file, d.start.offset))

    # A typedef around a record or enum body and that body are one declaration. The typedef survives, because it carries the name.
    wrapped: set[int] = set()
    for decl in decls:
        if decl.kind == "typedef":
            target = decl.cur.underlying_typedef_type.get_declaration()
            if target.kind in BODY_KINDS and target.is_definition() and target.location.file and target.location.file.name == decl.file \
                    and decl.start.offset <= target.extent.start.offset <= decl.end.offset:
                wrapped.add(target.canonical.hash)
                # The typedef's extent must cover the body, or the slice loses it.
                if target.extent.end.offset > decl.end.offset:
                    decl.end = target.extent.end
    kept = [d for d in decls if d.kind == "macro" or d.cur.canonical.hash not in wrapped]

    # A declaration the parse could not read is dropped, because its copy would be wrong.
    errors = defaultdict(dict)
    for diag in tu.diagnostics:
        if diag.severity >= diag.Error and diag.location.file:
            errors[diag.location.file.name][diag.location.line] = diag.spelling
    clean = []
    for d in kept:
        hit = {line: text for line, text in errors.get(d.file, {}).items() if d.start.line <= line <= d.end.line}
        if hit and d.kind != "macro":
            if all("default argument" in text for text in hit.values()):
                # SP's pmove_t and game_import_t give function pointer parameters default arguments, which MSVC took. The text loses them.
                d.strip_defaults = True
                clean.append(d)
                continue
            DROPPED.append(f"{d.cite} {d.kind} {d.name or '(anonymous)'}: parse error at line {min(hit)}, {hit[min(hit)]}")
        else:
            clean.append(d)
    # A declaration that names a name of a dropped one is dropped too, because its copy would name something no header declares.
    # interpreter.h opens its ID_* enum at NUM_USER_TOKENS, an enumerator of the enum the parse could not read.
    gone = {d.name for d in kept if d not in clean and d.name}
    gone |= {c.spelling for d in kept if d not in clean for c in d.cur.get_children() if c.kind == CursorKind.ENUM_CONSTANT_DECL}
    changed = True
    while changed:
        changed = False
        for d in list(clean):
            if d.kind == "macro":
                continue
            used = {t.spelling for t in d.cur.get_tokens()} & gone
            if used:
                clean.remove(d)
                DROPPED.append(f"{d.cite} {d.kind} {d.name or '(anonymous)'}: names {', '.join(sorted(used))} of a dropped declaration")
                gone |= {d.name} if d.name else set()
                gone |= {c.spelling for c in d.cur.get_children() if c.kind == CursorKind.ENUM_CONSTANT_DECL}
                changed = True
    kept = clean

    # `typedef struct X {...} X, *LPX;` declares two names in one statement. The first keeps the file, and the second aliases to it.
    by_extent: dict[tuple, Decl] = {}
    unique = []
    for d in kept:
        key = (d.file, d.start.offset)
        if d.kind != "macro" and key in by_extent:
            ALIAS[d] = by_extent[key]
            continue
        by_extent[key] = d
        unique.append(d)
    kept = unique

    # A typedef that only names a struct tag, `typedef struct gentity_s gentity_t;`, belongs in forward.h.
    for decl in kept:
        if decl.kind == "typedef":
            target = decl.cur.underlying_typedef_type.get_declaration()
            if target.kind in RECORD_KINDS and tag_of(target):
                # The record is defined elsewhere when its body does not sit inside this typedef's extent.
                inside = (target.location.file and target.location.file.name == decl.file
                          and decl.start.offset <= target.extent.start.offset <= decl.end.offset)
                decl.forward_only = not inside
    return kept


def name_records(decls: list[Decl]) -> None:
    """A named struct with a typedef takes the typedef's name for its file, so `gentity_t.h` holds `struct gentity_s`."""
    typedef_for: dict[int, str] = {}
    for decl in decls:
        if decl.kind == "typedef" and decl.forward_only:
            typedef_for[decl.cur.underlying_typedef_type.get_declaration().canonical.hash] = decl.name
    for decl in decls:
        if decl.kind in ("struct", "union", "class", "enum") and decl.cur.canonical.hash in typedef_for:
            decl.name = typedef_for[decl.cur.canonical.hash]


def link(decls: list[Decl], macro_names: dict[str, Decl]) -> None:
    """This fills each declaration's include set from the AST: by-value types, referenced enums, and the macros in its text."""
    by_hash: dict[int, Decl] = {}
    for decl in decls:
        if decl.kind == "macro":
            continue
        by_hash[decl.cur.canonical.hash] = decl
        record = decl.record()
        if record is not None:
            by_hash[record.canonical.hash] = decl

    for second, first in ALIAS.items():
        by_hash[second.cur.canonical.hash] = first
        record = second.record()
        if record is not None:
            by_hash[record.canonical.hash] = first

    def owner(cur) -> Decl | None:
        if cur is None or cur.kind == CursorKind.NO_DECL_FOUND:
            return None
        definition = cur.get_definition() or cur
        return by_hash.get(definition.canonical.hash) or by_hash.get(cur.canonical.hash)

    def add_type(decl: Decl, t, through_pointer: bool) -> None:
        while t.kind in ARRAY_KINDS:
            t = t.element_type
        if t.kind == TypeKind.POINTER:
            add_type(decl, t.get_pointee(), True)
            return
        if t.kind == TypeKind.FUNCTIONPROTO:
            add_type(decl, t.get_result(), True)
            for arg in t.argument_types():
                add_type(decl, arg, True)
            return
        target = t.get_declaration()
        if target is not None and target.location.file and not in_oracle(target.location.file.name):
            spelling = OUTSIDE_FILE_INCLUDE.get(target.location.file.name)
            if spelling:
                decl.system.add(spelling)
            return
        dep = owner(target)
        if dep is None or dep is decl:
            # A typedef of a typedef, such as vec3_t over float, still names the inner typedef's declaration.
            if t.kind == TypeKind.TYPEDEF:
                dep = owner(t.get_declaration())
            if dep is None or dep is decl:
                return
        # A pointer to a record with a tag is satisfied by forward.h, so no include, and no include cycle.
        if through_pointer:
            record = dep.record()
            is_class = record is not None and record.kind in (CursorKind.CLASS_DECL, CursorKind.CLASS_TEMPLATE)
            if not is_class and (dep.forward_only or (record is not None and record.kind in RECORD_KINDS and tag_of(record))):
                return
        if os.environ.get("EXTRACT_DEBUG") == decl.name:
            record = dep.record()
            print(f"debug {decl.name}: {t.spelling!r} pointer={through_pointer} dep={dep.name} kind={dep.kind} forward_only={dep.forward_only} "
                  f"record={record.kind.name if record is not None else None} tag={tag_of(record) if record is not None else None} file={dep.filename}")
        decl.includes.add(dep.filename)

    overridden = {d.name: d for d in decls if d.override is not None}
    for decl in decls:
        if decl.kind == "macro" or decl.forward_only:
            continue
        record = decl.record()
        if decl.kind == "typedef" and record is None:
            add_type(decl, decl.cur.underlying_typedef_type, False)
        elif record is not None:
            # The cursors under a field, by hash, because lexical_parent is empty on a reference inside a function pointer parameter.
            under_field = {c.hash for f in record.walk_preorder() if f.kind == CursorKind.FIELD_DECL for c in f.walk_preorder() if c.hash != f.hash}
            for field in record.walk_preorder():
                if field.kind == CursorKind.FIELD_DECL:
                    add_type(decl, field.type, False)
                elif field.kind == CursorKind.CXX_BASE_SPECIFIER:
                    add_type(decl, field.type, False)
                elif field.kind in (CursorKind.TEMPLATE_REF, CursorKind.TYPE_REF):
                    # A template argument, a base class, or a nested typedef names the type by value.
                    # A reference inside a field is handled by add_type, which knows about pointers.
                    dep = owner(field.referenced)
                    inside_field = field.hash in under_field
                    if dep is not None and dep is not decl and not dep.forward_only and not inside_field:
                        if os.environ.get("EXTRACT_DEBUG") == decl.name:
                            print(f"debug typeref {decl.name}: " + str(dep.filename))
                        decl.includes.add(dep.filename)
                elif field.kind == CursorKind.DECL_REF_EXPR and field.referenced is not None:
                    # An enum constant in an array size or an enumerator value, or a const variable.
                    referenced = field.referenced
                    dep = owner(referenced) if referenced.kind == CursorKind.VAR_DECL else owner(referenced.semantic_parent)
                    if dep is not None and dep is not decl:
                        if os.environ.get("EXTRACT_DEBUG") == decl.name:
                            print(f"debug declref {decl.name}: " + str(dep.filename))
                        decl.includes.add(dep.filename)
        # Macros used in the text. The names the declaration defines itself are not uses.
        # menudef.h defines CT_LTBLUE1 as a macro while q_shared.h's ct_table_t names an enumerator the same way.
        own = {decl.name}
        if record is not None:
            own |= {c.spelling for c in record.walk_preorder() if c.kind in (CursorKind.ENUM_CONSTANT_DECL, CursorKind.FIELD_DECL)}
        text = strip_comments(slice_text(decl, None))
        idents = set(re.findall(r"\b[A-Za-z_]\w*\b", text)) - own
        # A name the parse read as a macro, such as SP's qboolean, is now a typedef. The text is the only trace of the use.
        for ident in idents & set(overridden):
            if overridden[ident] is not decl:
                if os.environ.get("EXTRACT_DEBUG") == decl.name:
                    print(f"debug override {decl.name}: " + str(overridden[ident].filename))
                decl.includes.add(overridden[ident].filename)
        pending = list(idents)
        seen_macros: set[str] = set()
        while pending:
            ident = pending.pop()
            macro = macro_names.get(ident)
            if macro is None or ident in seen_macros:
                continue
            seen_macros.add(ident)
            if macro.filename != decl.filename:
                if os.environ.get("EXTRACT_DEBUG") == decl.name:
                    print(f"debug macro {decl.name}: " + str(macro.filename))
                decl.includes.add(macro.filename)
            # g_public.h defines MAX_PARM_STRING_LENGTH as MAX_QPATH, which q_shared.h defines.
            pending += [t.spelling for t in macro.cur.get_tokens()][1:]
        decl.includes.discard(decl.filename)


# ------------------------------------------------------------------ the slices

_pack_cache: dict[str, list[str | None]] = {}


def pack_at(path: str, line: int) -> str | None:
    """The `#pragma pack` argument in force at a line of the file, or None when the default packing applies."""
    if path not in _pack_cache:
        states: list[str | None] = []
        stack: list[str | None] = []
        current: str | None = None
        for text in lines_of(path):
            m = re.match(r"\s*#\s*pragma\s+pack\s*\((.*)\)", text)
            if m:
                args = [a.strip() for a in m.group(1).split(",")]
                if args[0] == "push":
                    stack.append(current)
                    current = args[1] if len(args) > 1 else current
                elif args[0] == "pop":
                    current = stack.pop() if stack else None
                else:
                    current = args[0] or None
            states.append(current)
        _pack_cache[path] = states
    return _pack_cache[path][line - 1]


def platform_block(lines: list[str], first: int) -> list[str] | None:
    """Raven's conditional around the macro at `first`, when that conditional names a platform macro, or None.
    The parse keeps one arm, and the extracted header keeps both, so each platform build takes its own."""
    directive = re.compile(r"\s*#\s*(ifdef|ifndef|if|elif|else|endif)\b(.*)")
    depth = 0
    i = first - 1
    while i >= 0:
        m = directive.match(lines[i])
        if m:
            if m.group(1) == "endif":
                depth += 1
            elif m.group(1) in ("ifdef", "ifndef", "if"):
                if depth == 0:
                    break
                depth -= 1
        i -= 1
    if i < 0:
        return None
    m = directive.match(lines[i])
    if not any(re.search(rf"\b{name}\b", m.group(2)) for name in PLATFORM_MACROS):
        return None
    depth = 0
    for j in range(i, len(lines)):
        d = directive.match(lines[j])
        if d and d.group(1) in ("ifdef", "ifndef", "if"):
            depth += 1
        elif d and d.group(1) == "endif":
            depth -= 1
            if depth == 0:
                return lines[i:j + 1]
    return None


def slice_text(decl: Decl, resolver: IfResolver | None) -> str:
    lines = lines_of(decl.file)
    first = decl.start.line - 1
    last = decl.end.line - 1
    if decl.kind == "macro":
        block = platform_block(lines, first)
        if block is not None:
            return "\n".join(block)
        return "\n".join(lines[first:last + 1])
    if decl.override is not None:
        return decl.override
    pack = pack_at(decl.file, decl.start.line)
    text = lines[first:last + 1]
    # Raven builds one enum by including tags.h inside the body. The included file's lines take the directive's place.
    expanded: list[str] = []
    for line in text:
        m = re.match(r'\s*#\s*include\s*"([^"]+)"', line)
        included = (Path(decl.file).parent / m.group(1).replace("\\", "/")) if m else None
        if included is not None and included.exists():
            expanded.append(f"// Inlined from {oracle_relative(str(included))}")
            expanded += lines_of(str(included))
        else:
            expanded.append(line)
    resolved = resolver.resolve(expanded) if resolver else expanded
    body = "\n".join(resolved)
    body = re.sub(r"__declspec\s*\((?:[^()]|\([^()]*\))*\)\s*", "", body)
    if decl.strip_defaults:
        body = re.sub(r"\s*=\s*(?:\([^()]*\)\s*)?[A-Za-z0-9_.\-]+(?=\s*[,)])", "", body)
    leading = decl.cur.raw_comment
    if leading and leading.strip() not in body:
        body = leading.rstrip() + "\n" + body
    record = decl.record()
    if pack is not None and record is not None and record.kind in RECORD_KINDS and record.type.get_align() <= int(pack):
        body = f"#pragma pack(push, {pack})\n{body}\n#pragma pack(pop)"
    return body


def record_spelling(decl: Decl) -> str | None:
    """The spelling C code uses for the record in sizeof, or None when there is none."""
    cur = decl.cur
    if decl.kind == "typedef":
        return decl.name if decl.record() is not None and decl.record().kind in RECORD_KINDS else None
    if decl.kind in ("struct", "union", "class"):
        tag = tag_of(cur)
        if tag and decl.name == tag:
            return f"{decl.kind} {tag}"
        return decl.name or None
    return None


def asserts_for(decl: Decl) -> list[str]:
    name = record_spelling(decl)
    if not name:
        return []
    cur = decl.record()
    size = cur.type.get_size()
    if size <= 0:
        return []
    if decl.cur.kind == CursorKind.CLASS_TEMPLATE or cur.kind == CursorKind.CLASS_TEMPLATE:
        return []
    out = [f'_Static_assert(sizeof({name}) == {size}, "{name}");']
    # offsetof is defined for standard-layout types only, and a private member is not reachable from outside the class.
    if not cur.type.is_pod():
        return out
    for field in cur.get_children():
        if field.kind != CursorKind.FIELD_DECL or not field.spelling or field.is_bitfield() or field.is_anonymous():
            continue
        if str(field.access_specifier).split(".")[-1] not in ("PUBLIC", "INVALID"):
            continue
        bits = field.get_field_offsetof()
        if bits < 0 or bits % 8:
            continue
        out.append(f'_Static_assert(offsetof({name}, {field.spelling}) == {bits // 8}, "{name}.{field.spelling}");')
    return out


C_ONLY_MARKS = re.compile(
    r"\bclass\b|\bpublic:|\bprivate:|\bprotected:|\bvirtual\b|\btemplate\b|::|\bbool\b|\boperator\b|&\s*\w*\s*[,)]"
    r"|\b[A-Za-z_]\w*\s*<\s*[A-Za-z_]"
    r"|\b[A-Za-z_]\w*\s*\([^()]*\)\s*(?:const\s*)?[{;:]"
)


def looks_like_c(text: str) -> bool:
    return not C_ONLY_MARKS.search(strip_comments(text))


def is_c(decl: Decl, text: str) -> bool:
    return decl.kind != "var" and looks_like_c(text)


# ------------------------------------------------------------------ the emit

HEADER_NOTE = "// Generated by tools/oracle-closure/extract.py from {tree} at {commit}. Raven's text, one declaration per file. Do not edit until adopted.\n"


def oracle_commit() -> str:
    return subprocess.run(["git", "-C", str(ORACLE), "rev-parse", "--short", "HEAD"], capture_output=True, text=True).stdout.strip()


def guard(filename: str) -> str:
    return "JKA_" + re.sub(r"\W", "_", filename).upper()


def wrap(filename: str, note: str, includes: list[str], body: list[str], ordered: bool = False) -> str:
    """One emitted header: the note, the guard, the includes, and the body.
    The includes are sorted, and an `ordered` file such as all.h keeps them in the order the caller gives."""
    parts = [note, f"#ifndef {guard(filename)}", f"#define {guard(filename)}", ""]
    parts += [f'#include "{inc}"' for inc in (includes if ordered else sorted(includes))]
    if includes:
        parts.append("")
    parts += body
    parts += [f"#endif // {guard(filename)}", ""]
    return "\n".join(parts)


# The three ABIs the layouts depend on, and the predicate that selects each block of layout_asserts.h.
# Clang defines both widths on every target, so a block is chosen by the ABI and not by the operating system or the instruction set.
ABIS = {
    "ilp32": "__SIZEOF_POINTER__ == 4",
    "llp64": "__SIZEOF_POINTER__ == 8 && __SIZEOF_LONG__ == 4",
    "lp64": "__SIZEOF_POINTER__ == 8 && __SIZEOF_LONG__ == 8",
}

# The target triples of the layout check, packet row 6, and the ABI each one follows.
# Every triple of one ABI must give the same asserts, and the writer exits when two of them do not.
TRIPLES = {
    "i686-pc-windows-msvc": "ilp32",
    "i686-pc-linux-gnu": "ilp32",
    "armv7-linux-gnueabihf": "ilp32",
    "arm64_32-apple-watchos": "ilp32",
    "x86_64-pc-windows-msvc": "llp64",
    "aarch64-pc-windows-msvc": "llp64",
    "x86_64-pc-linux-gnu": "lp64",
    "aarch64-linux-gnu": "lp64",
    "x86_64-apple-macosx": "lp64",
    "arm64-apple-macosx": "lp64",
}


def abi_blocks(tables: dict[str, list[str]], triples: list[str]) -> list[str]:
    """The #if chain of layout_asserts.h: one block per ABI in ABIS order, each headed by its predicate and the triples it covers."""
    lines: list[str] = []
    for i, (abi, predicate) in enumerate((abi, predicate) for abi, predicate in ABIS.items() if abi in tables):
        covered = ", ".join(t for t in triples if TRIPLES[t] == abi)
        lines.append(f"{'#if' if i == 0 else '#elif'} {predicate} // {abi}: {covered}")
        lines += tables[abi]
    lines += ["#else", '#error "layout_asserts.h has no block for this target"', "#endif"]
    return lines


def host_triple() -> str:
    return "arm64-apple-macosx" if platform.machine() == "arm64" else "x86_64-apple-macosx"


def triple_asserts(module: str, triple: str, entries: list[str] | None = None) -> dict[str, list[str]]:
    """The asserts of every record in one module's parse for one triple, by record spelling. Runs in its own process."""
    tu = C.parse_tu(module, None, target=triple, entries=entries)
    decls = sweep(tu)
    name_records(decls)
    out: dict[str, list[str]] = {}
    for decl in decls:
        if decl.kind == "macro":
            continue
        name = record_spelling(decl)
        if name and name not in out:
            lines = asserts_for(decl)
            if lines:
                out[name] = lines
    return out


def assert_blocks(module: str, host: list[tuple[str, list[str]]], triples: list[str], entries: list[str] | None = None) -> list[str]:
    """layout_asserts.h's body: one block per ABI, from the host's parse and a parse per foreign triple, after every triple of the ABI agrees."""
    foreign = [t for t in triples if t != host_triple()]
    by_triple: dict[str, dict[str, list[str]]] = {host_triple(): dict(host)}
    if foreign:
        with concurrent.futures.ProcessPoolExecutor(max_workers=len(foreign), mp_context=multiprocessing.get_context("spawn")) as pool:
            for triple, result in zip(foreign, pool.map(triple_asserts, [module] * len(foreign), foreign, [entries] * len(foreign))):
                by_triple[triple] = result
    tables: dict[str, list[str]] = {}
    for abi in ABIS:
        members = [t for t in triples if TRIPLES[t] == abi]
        if not members:
            continue
        lines: list[str] = []
        missing: dict[str, list[str]] = defaultdict(list)
        for name, _ in host:
            got = {t: by_triple[t].get(name) for t in members}
            present = {t: g for t, g in got.items() if g is not None}
            for t in members:
                if t not in present:
                    missing[t].append(name)
            if not present:
                lines.append(f"// {name} did not parse for {abi}, so it has no asserts here.")
                continue
            distinct = {tuple(g) for g in present.values()}
            if len(distinct) > 1:
                sys.exit(f"extract.py: {name} has {len(distinct)} layouts across the {abi} triples {', '.join(present)}, and one block cannot hold them")
            lines += next(iter(present.values()))
        for t, names in missing.items():
            NOTES.append(f"{len(names)} records have no asserts for {t}")
        tables[abi] = lines
    return abi_blocks(tables, triples)


def emit(module: str, out_dir: Path, check: bool, triples: list[str]) -> int:
    spec = C.spec(module)
    # The unity parse runs once, and both the derived entry list and the constants of the .c files read it.
    unity = C.parse_tu(module, None, unity=True) if spec.get("srcglob") and (spec["lang"] == "c" or "entry" not in spec) else None
    # The entry list comes once, so the triple parses in the pool do not each derive it again from a unity parse.
    if "entry" in spec:
        entries, reached = C.entry_list(module), []
    else:
        entries, reached = C.derived_entries(module, unity)
    tu = C.parse_tu(module, None, entries=entries)
    resolver = IfResolver(macro_table(tu))
    decls = sweep(tu)
    # The root filter leaves a header to the header that reaches it, so the header parse must reach every header of the unfiltered list.
    # A header a .c file reaches only under a define of its own, as g_ICARUScb.c does for interpreter.h, fails this check.
    # The check reads the includes of the parse beside FILE_ORDER, because a header with no declaration under C, such as g_headers.h, has no cursor.
    parsed = {Path(path).resolve() for path in FILE_ORDER} | {Path(inc.include.name).resolve() for inc in tu.get_includes()}
    missing = [header for header in reached if (C.SRC_ROOT / header).resolve() not in parsed]
    if missing:
        sys.exit(f"extract.py: the header parse of {module} does not reach {', '.join(missing)}, which its .c files include")
    name_records(decls)
    type_names = {d.name for d in decls if d.kind != "macro" and d.name}
    shadowing = [d for d in decls if d.kind == "macro" and d.name in type_names]
    for d in shadowing:
        body_tokens = [t.spelling for t in d.cur.get_tokens()][1:]
        for typed in decls:
            if typed.kind == "typedef" and typed.name == d.name:
                typed.override = f"// Raven redefines {d.name} as `{' '.join(body_tokens)}` at {d.cite}, so that is the type.\ntypedef {' '.join(body_tokens)} {d.name};"
        NOTES.append(f"{d.cite} macro {d.name} renames the typedef {d.name}, which now reads: typedef {' '.join(body_tokens)} {d.name}")
    decls = [d for d in decls if d not in shadowing]
    macro_names = {d.name: d for d in decls if d.kind == "macro"}
    link(decls, macro_names)
    commit = oracle_commit()
    entry = entries[0]
    note = HEADER_NOTE.format(tree=entry.split("/")[0], commit=commit)

    adopted_path = out_dir / "adopted.json"
    adopted = set(json.loads(adopted_path.read_text())) if adopted_path.exists() else set()

    files: dict[str, str] = {}
    manifest = {"module": module, "oracle": commit, "files": {}, "file_enums": []}
    counts: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    not_c: list[str] = []
    asserted: list[tuple[str, list[str]]] = []

    # The C closure. A declaration that is not C, or that includes one, is emitted for reference and kept out of all.h and the asserts.
    cxx_files: set[str] = set()
    for decl in decls:
        if decl.kind not in ("macro",) and not decl.forward_only and not is_c(decl, slice_text(decl, resolver)):
            cxx_files.add(decl.filename)
    by_file = {d.filename: d for d in decls if d.kind != "macro" and not d.forward_only}
    changed = True
    while changed:
        changed = False
        for filename, decl in by_file.items():
            if filename not in cxx_files and decl.includes & cxx_files:
                cxx_files.add(filename)
                changed = True

    # forward.h
    forward: list[str] = []
    for decl in decls:
        record = decl.record() if decl.kind != "macro" else None
        tag = tag_of(record) if record is not None and record.kind in RECORD_KINDS else None
        # A C++ struct still gets its tag and typedef lines, because a C struct may point at it, and a pointer needs only the name.
        # A class does not, because `class X;` is not C.
        if tag is None or (decl.filename in cxx_files and record.kind != CursorKind.STRUCT_DECL and record.kind != CursorKind.UNION_DECL):
            continue
        keyword = record.kind.name.replace("_DECL", "").lower()
        forward.append(f"{keyword} {tag};")
        if decl.kind == "typedef":
            forward.append(f"typedef {keyword} {tag} {decl.name};")
    # A tag a body names only behind a pointer, such as `struct bot_goal_s *` in ai_export_t, gets a bare declaration too.
    # Without it, C scopes the tag to the prototype and Clang warns that the declaration is not visible outside the function.
    declared = set(forward)
    for decl in decls:
        if decl.kind == "macro" or decl.forward_only or decl.filename in cxx_files:
            continue
        for m in re.finditer(r"\b(struct|union|enum)\s+(\w+)\b(?!\s*\{)", strip_comments(slice_text(decl, resolver))):
            line = f"{m.group(1)} {m.group(2)};"
            if line not in declared:
                declared.add(line)
                forward.append(line)
    forward_seen: set[str] = set()
    for decl in decls:
        if decl.forward_only:
            # The line is built from the AST, because Raven writes `typedef shaderCommands_s shaderCommands_t;` without the keyword, which C++ allows.
            target = decl.cur.underlying_typedef_type.get_declaration()
            keyword = target.kind.name.replace("_DECL", "").lower()
            text = f"typedef {keyword} {tag_of(target)} {decl.name};"
            if text.strip() in forward_seen:
                continue
            forward_seen.add(text.strip())
            forward.append(f"// Source: {decl.cite}")
            forward.append(text)
            counts[decl.stem]["typedef"] += 1
    files["forward.h"] = wrap("forward.h", note, ["platform.h"], forward + [""])
    platform = ["// The spellings the module's parse supplied for the platform section Raven never wrote for this host."]
    for define in spec["defines"]:
        if "=" in define:
            name, value = define.split("=", 1)
            platform.append(f"#define {name} {value}")
    files["platform.h"] = wrap("platform.h", note, [], platform + [""])

    # constants_<header>.h
    by_stem: dict[str, list[Decl]] = defaultdict(list)
    for decl in decls:
        if decl.kind == "macro":
            by_stem[decl.stem].append(decl)
    for stem, macros in by_stem.items():
        body: list[str] = []
        for decl in macros:
            body += [f"// Source: {decl.cite}", slice_text(decl, resolver), ""]
            counts[stem]["macro"] += 1
        filename = macros[0].filename
        files[filename] = wrap(filename, note, [], body)
        manifest["files"][filename] = {"source": oracle_relative(macros[0].file), "declarations": [d.name for d in macros]}

    # The constants file of each .c file, by the .c file's resolved path, which all.h places.
    c_constants: dict[Path, str] = {}

    # constants.h of a .c file: the object-like macros a source file defines for itself, such as MOVER_LOCKED in g_mover.c.
    # struct-views.md row 2: a spawn flag OptionSet reads the re-exported C macro, so the macro must reach a header.
    # The parse is the module's unity build, so a macro one .c file defines is visible to the next, as the function closure already accepts.
    if spec.get("srcglob") and spec["lang"] == "c":
        unity_resolver = IfResolver(macro_table(unity))
        # A macro whose name is an identifier in a header would rewrite that header once the umbrella defines it, as Raven's
        # `#define currentOrigin r.currentOrigin` in the vehicle files would rewrite entityShared_t, so it stays in its .c file.
        header_identifiers: set[str] = set()
        for decl in decls:
            if decl.kind != "macro":
                header_identifiers |= set(re.findall(r"\b[A-Za-z_]\w*\b", slice_text(decl, resolver)))
        c_macros: dict[str, list[Decl]] = defaultdict(list)
        c_enums: list[Decl] = []
        for cur in unity.cursor.get_children():
            loc = cur.location.file
            if not in_oracle(loc and loc.name) or not loc.name.endswith(".c"):
                continue
            if cur.kind == CursorKind.ENUM_DECL and cur.is_definition():
                names = enumerators_of(cur)
                if names:
                    tag = "" if cur.is_anonymous() or "(" in cur.spelling else cur.spelling
                    c_enums.append(Decl(cur, "c_enum", tag or f"enum {names[0]}"))
                continue
            if cur.kind != CursorKind.MACRO_DEFINITION:
                continue
            tokens = list(cur.get_tokens())
            if cur.spelling in MACRO_SKIP or cur.spelling.startswith("__") or len(tokens) < 2 or is_function_like(tokens) or cur.spelling in macro_names:
                continue
            if cur.spelling in header_identifiers:
                NOTES.append(f"{oracle_relative(loc.name)}:{cur.location.line} macro {cur.spelling} stays in its .c file, because a header uses the name")
                continue
            c_macros[loc.name].append(Decl(cur, "macro", cur.spelling))
        # A name two .c files define with different bodies has a value per file, which one header cannot carry, so it stays in
        # its .c files. A name two files define alike is copied once.
        bodies: dict[str, set[str]] = defaultdict(set)
        for macros in c_macros.values():
            for decl in macros:
                bodies[decl.name].add(" ".join(t.spelling for t in decl.cur.get_tokens())[len(decl.name):].strip())
        copied: set[str] = set()
        for file, macros in list(c_macros.items()):
            kept: list[Decl] = []
            for decl in macros:
                if len(bodies[decl.name]) > 1:
                    NOTES.append(f"{decl.cite} macro {decl.name} stays in its .c file, because another .c file defines it differently")
                elif decl.name not in copied:
                    copied.add(decl.name)
                    kept.append(decl)
            if kept:
                c_macros[file] = kept
            else:
                del c_macros[file]
        # An enum a .c file declares for itself, such as TAUNT_* in g_active.c, joins that file's macros, placed the same way.
        # It stays in its .c file when a header or a hand header of a C target names one of its names, or when a .c macro has one,
        # because the umbrella would then declare the name twice. The same holds for a name two .c files declare in two different
        # enums, as the NPC_AI files do with LSTATE_NONE. An enum two files declare alike is copied once.
        hand_identifiers: set[str] = set()
        for target, paths in HAND_FILES.items():
            for rel in paths:
                path = C.REPO / "Sources" / target / rel
                if path.exists():
                    hand_identifiers |= set(re.findall(r"\b[A-Za-z_]\w*\b", strip_comments(path.read_text())))
        kept_macro_names = {decl.name for macros in c_macros.values() for decl in macros}
        enum_names = {id(decl): enumerators_of(decl.cur) + ([decl.name] if not decl.name.startswith("enum ") else []) for decl in c_enums}
        enum_texts: dict[str, set[str]] = defaultdict(set)
        for decl in c_enums:
            text = " ".join(t.spelling for t in decl.cur.get_tokens())
            for name in enum_names[id(decl)]:
                enum_texts[name].add(text)
        # A header names the enumerators of its prelude, and the header parse reads them from the prelude, so they still go to the constants file.
        prelude_names: set[str] = set()
        for source, first, last in HEADER_PRELUDES.values():
            for decl in c_enums:
                if Path(decl.file).resolve() == (ORACLE / source).resolve() and first <= decl.start.line and decl.end.line <= last:
                    prelude_names |= set(enum_names[id(decl)])
        copied_enums: set[str] = set()
        for decl in c_enums:
            names = enum_names[id(decl)]
            text = " ".join(t.spelling for t in decl.cur.get_tokens())
            named = sorted(n for n in names if (n in header_identifiers or n in macro_names) and n not in prelude_names)
            handed = sorted(n for n in names if n in hand_identifiers)
            clashing = sorted(n for n in names if n in kept_macro_names or len(enum_texts[n]) > 1)
            if named:
                NOTES.append(f"{decl.cite} {decl.name if decl.name.startswith('enum ') else 'enum ' + decl.name} stays in its .c file, because a header names {', '.join(named)}")
            elif handed:
                NOTES.append(f"{decl.cite} {decl.name if decl.name.startswith('enum ') else 'enum ' + decl.name} stays in its .c file, because a hand header names {', '.join(handed)}")
            elif clashing:
                NOTES.append(f"{decl.cite} {decl.name if decl.name.startswith('enum ') else 'enum ' + decl.name} stays in its .c file, because another .c file declares {', '.join(clashing)} differently")
                # skeleton.py reads this list and writes the enumerators as private constants at the top of the file's stub.
                manifest["file_enums"].append({"source": decl.cite, "enumerators": enumerator_values(decl.cur)})
            elif text not in copied_enums:
                copied_enums.add(text)
                c_macros[decl.file].append(decl)
        for macros in c_macros.values():
            macros.sort(key=lambda decl: decl.start.line)
            body: list[str] = []
            for decl in macros:
                body += [f"// Source: {decl.cite}", slice_text(decl, unity_resolver), ""]
                counts[decl.stem]["enum" if decl.kind == "c_enum" else "macro"] += 1
            filename = macros[0].filename
            files[filename] = wrap(filename, note, [], body)
            manifest["files"][filename] = {"source": oracle_relative(macros[0].file), "declarations": [d.name for d in macros]}
            c_constants[Path(macros[0].file).resolve()] = filename

    # A name declared twice, such as `byte` in q_shared.h and in the icarus tokenizer, keeps its first file. Includes follow it.
    alias: dict[str, str] = {}
    first_by_name: dict[str, str] = {}
    for decl in decls:
        if decl.kind == "macro" or decl.forward_only or not decl.name:
            continue
        if decl.name in first_by_name and first_by_name[decl.name] != decl.filename:
            alias[decl.filename] = first_by_name[decl.name]
        else:
            first_by_name.setdefault(decl.name, decl.filename)

    # <Type>.h
    for decl in decls:
        if decl.kind == "macro" or decl.forward_only:
            continue
        text = slice_text(decl, resolver)
        if decl.filename in cxx_files:
            not_c.append(f"{decl.cite} {decl.kind} {decl.name}" + ("" if not is_c(decl, text) else " (depends on a C++ type)"))
        includes = sorted(decl.includes | {"forward.h"})
        record = decl.record()
        if decl.kind in ("struct", "union", "enum") and record is not None and tag_of(record) and tag_of(record) not in type_names - {decl.name}:
            keyword = record.kind.name.replace("_DECL", "").lower()
            text += f"\n// C++ names the tag without its keyword, and this typedef lets C do the same.\ntypedef {keyword} {tag_of(record)} {tag_of(record)};"
        # A C declaration carries only the system headers its own types came from. A C++ declaration also repeats its header's includes,
        # because a class body reaches std:: names the type scan does not see.
        cxx = decl.filename in cxx_files
        system = [f"#include <{inc}>" for inc in sorted(decl.system)]
        if cxx:
            system += [f"#include <{inc}>" for inc in SYSTEM_INCLUDES.get(decl.file, []) if f"#include <{inc}>" not in system]
        body = system + ([""] if system else []) + [f"// Source: {decl.cite}", text, ""]
        if decl.filename in files:
            print(f"[warn] two declarations named {decl.name}, second at {decl.cite} skipped", file=sys.stderr)
            continue
        includes = [alias.get(inc, inc) for inc in includes]
        files[decl.filename] = wrap(decl.filename, note, includes, body)
        counts[decl.stem][decl.kind] += 1
        manifest["files"][decl.filename] = {"kind": decl.kind, "source": decl.cite, "includes": includes, "c": decl.filename not in cxx_files}
        if decl.filename not in cxx_files:
            lines = asserts_for(decl)
            if lines:
                asserted.append((record_spelling(decl), lines))

    # all.h and layout_asserts.h
    # all.h follows Raven's include order, header by header, constants first within a header and then its types in source order.
    # That is the order Raven's translation unit saw, so a macro such as menudef.h's CT_LTBLUE1 lands after q_shared.h's ct_table_t enum.
    # merge.py orders each target's umbrella by the headers of this file, so the order holds in the package too.
    # The constants file of a .c file that a prelude slices stands before the header of that prelude, as the .c file puts it.
    # Every other .c constants file stands after the headers, because its .c file includes them first.
    prelude_of = {(ORACLE / header).resolve(): (ORACLE / source).resolve() for header, (source, _, _) in HEADER_PRELUDES.items()}
    ordered = ["forward.h"]
    for path in FILE_ORDER:
        source = prelude_of.get(Path(path).resolve())
        if source in c_constants and c_constants[source] not in ordered:
            ordered.append(c_constants[source])
        stem_decls = [d for d in decls if d.file == path and not d.forward_only]
        for filename in dict.fromkeys(d.filename for d in stem_decls if d.kind == "macro"):
            ordered.append(filename)
        for filename in dict.fromkeys(d.filename for d in stem_decls if d.kind != "macro"):
            if filename in files and filename not in cxx_files:
                ordered.append(filename)
    ordered += [filename for filename in c_constants.values() if filename not in ordered]
    files["all.h"] = wrap("all.h", note, ordered, [], ordered=True)
    files["layout_asserts.h"] = wrap("layout_asserts.h", note, [], ["#include <stddef.h>", '#include "all.h"', ""] + assert_blocks(module, asserted, triples, entries) + [""])

    written = 0
    for filename, content in files.items():
        target = out_dir / filename
        target.parent.mkdir(parents=True, exist_ok=True)
        if filename in adopted:
            if target.exists() and target.read_text() != content:
                print(f"[drift] {filename} is adopted and differs from the oracle", file=sys.stderr)
            continue
        if not check:
            target.write_text(content)
            written += 1
    if not check:
        (out_dir / "extract.json").write_text(json.dumps(manifest, indent=1))
        (out_dir / "cxx_only.txt").write_text("\n".join(not_c) + ("\n" if not_c else ""))
        # Stale files from an earlier run go away, so the directory is always one run's output.
        for stale in out_dir.rglob("*.h"):
            name = str(stale.relative_to(out_dir))
            if name not in files and name not in adopted:
                stale.unlink()

    print(f"module {module}, oracle {commit}, {len(files)} files, {written} written to {out_dir}")
    print(f"{'raven header':20} {'struct':>6} {'union':>6} {'enum':>6} {'typedef':>8} {'macro':>6}")
    for stem in sorted(counts):
        c = counts[stem]
        print(f"{stem:20} {c['struct']:6} {c['union']:6} {c['enum']:6} {c['typedef']:8} {c['macro']:6}")
    print(f"{sum(len(lines) for _, lines in asserted)} layout asserts per triple, {len(triples)} triples")
    if resolver.unresolved:
        print(f"{len(set(resolver.unresolved))} conditionals kept as text because the expression did not evaluate:")
        for line in sorted(set(resolver.unresolved)):
            print(f"  {line}")
    if not_c:
        print(f"{len(not_c)} declarations are C++ or depend on one, listed in cxx_only.txt and left out of all.h")
    if DROPPED:
        print(f"{len(DROPPED)} declarations dropped because the parse could not read them:")
        for line in DROPPED:
            print(f"  {line}")
    if NOTES:
        print(f"{len(NOTES)} declarations rewritten to what Raven's macros made of them:")
        for line in NOTES:
            print(f"  {line}")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("module")
    ap.add_argument("--out", help="output directory, default out/extract/<module>")
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    ap.add_argument("--host-only", action="store_true", help="asserts for the host triple only, for a quick run")
    args = ap.parse_args()
    triples = [host_triple()] if args.host_only else list(TRIPLES)
    if args.module not in C.MODULES:
        sys.exit(f"unknown module {args.module}. Known: {', '.join(sorted(C.MODULES))}")
    out_dir = Path(args.out) if args.out else Path(__file__).resolve().parent / "out" / "extract" / args.module
    if not args.check:
        out_dir.mkdir(parents=True, exist_ok=True)
    sys.exit(emit(args.module, out_dir, args.check, triples))


if __name__ == "__main__":
    main()
