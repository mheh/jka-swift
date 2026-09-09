#!/usr/bin/env python3
"""extract.py: copy Raven's type declarations out of the oracle into C headers we own, one file per type.

One libclang parse of a module, with the module's define set from modules/<name>.py, decides which #if branches are live.
The script keeps struct, union, enum, and typedef declarations plus object-like macros with a value.
It drops function prototypes, extern variables, function-like macros, and inline function bodies.
Each kept declaration is a verbatim slice of the oracle source, so Raven's names and comments survive.
Inactive #if branches inside a slice are removed with the same macro set the parse used.

Output, flat in one directory:
  <TypeName>.h              one file per struct, union, enum, or typedef, named by the typedef where one exists
  constants_<header>.h      the object-like macros of one Raven header, in Raven's order
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
import os
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import closure as C
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
                if directive == "ifdef":
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
        self.reldir = str(Path(oracle_relative(self.file)).parent.relative_to("oracle")) + "/" + self.stem
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
        if self.kind == "macro":
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


def slice_text(decl: Decl, resolver: IfResolver | None) -> str:
    lines = lines_of(decl.file)
    first = decl.start.line - 1
    last = decl.end.line - 1
    if decl.kind == "macro":
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


def wrap(filename: str, note: str, includes: list[str], body: list[str]) -> str:
    parts = [note, f"#ifndef {guard(filename)}", f"#define {guard(filename)}", ""]
    parts += [f'#include "{inc}"' for inc in sorted(includes)]
    if includes:
        parts.append("")
    parts += body
    parts += [f"#endif // {guard(filename)}", ""]
    return "\n".join(parts)


def emit(module: str, out_dir: Path, check: bool) -> int:
    tu = C.parse_tu(module, None)
    spec = C.spec(module)
    resolver = IfResolver(macro_table(tu))
    decls = sweep(tu)
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
    entry = spec["entry"][0] if isinstance(spec["entry"], list) else spec["entry"]
    note = HEADER_NOTE.format(tree=entry.split("/")[0], commit=commit)

    adopted_path = out_dir / "adopted.json"
    adopted = set(json.loads(adopted_path.read_text())) if adopted_path.exists() else set()

    files: dict[str, str] = {}
    manifest = {"module": module, "oracle": commit, "files": {}}
    counts: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    not_c: list[str] = []
    assert_lines: list[str] = []

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
            assert_lines += asserts_for(decl)

    # all.h and layout_asserts.h
    # all.h follows Raven's include order, header by header, constants first within a header and then its types in source order.
    # That is the order Raven's translation unit saw, so a macro such as menudef.h's CT_LTBLUE1 lands after q_shared.h's ct_table_t enum.
    ordered = ["forward.h"]
    for path in FILE_ORDER:
        stem_decls = [d for d in decls if d.file == path and not d.forward_only]
        for filename in dict.fromkeys(d.filename for d in stem_decls if d.kind == "macro"):
            ordered.append(filename)
        for filename in dict.fromkeys(d.filename for d in stem_decls if d.kind != "macro"):
            if filename in files and filename not in cxx_files:
                ordered.append(filename)
    files["all.h"] = wrap("all.h", note, ordered, [])
    files["layout_asserts.h"] = wrap("layout_asserts.h", note, [], ["#include <assert.h>", "#include <stddef.h>", '#include "all.h"', ""] + assert_lines + [""])

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
    print(f"{len(assert_lines)} layout asserts")
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
    args = ap.parse_args()
    if args.module not in C.MODULES:
        sys.exit(f"unknown module {args.module}. Known: {', '.join(sorted(C.MODULES))}")
    out_dir = Path(args.out) if args.out else Path(__file__).resolve().parent / "out" / "extract" / args.module
    if not args.check:
        out_dir.mkdir(parents=True, exist_ok=True)
    sys.exit(emit(args.module, out_dir, args.check))


if __name__ == "__main__":
    main()
