#!/usr/bin/env python3
"""table.py: the C-to-Swift table of abi-stubs.md row 2, shared by traps.py and skeleton.py.

A parameter or a return maps by its C shape to the Swift type in the signature and the way it crosses the seam.
The table composes the view generator for the scalar, enum, and view names, so one spelling serves every generator.
"""

from __future__ import annotations

import re
from pathlib import Path

import clang.cindex as ci
from clang.cindex import TypeKind

from clang.cindex import CursorKind

import closure as C
from reexport import SCALARS
from rulings import PARAMS, RETURNS, TYPES
from views import Generator

TARGET = "CJKAMP_Game"
BUILTINS = set(SCALARS.values()) | {"Bool", "Float", "Int32"}
INT_KINDS = {TypeKind.INT, TypeKind.UINT, TypeKind.LONG, TypeKind.ULONG, TypeKind.SHORT, TypeKind.USHORT}
# The vector typedefs JKAShared spells as SIMD types, so a parameter of one is the vector itself, never a pointer.
VECTORS = {"vec3_t", "vec4_t"}
# An int beside a char * is its size only when Raven named it so. trap_BotSetChatName's `client` is not a size.
SIZE_NAME = re.compile(r"size|len|max", re.I)
# A Raven parameter name that is a Swift keyword is written in backticks.
KEYWORDS = {"extension", "in", "func", "class", "struct", "enum", "protocol", "default", "operator", "repeat", "where",
            "import", "self", "init", "var", "let", "return", "case", "switch", "if", "else", "for", "while", "do", "is", "as",
            "true", "false", "nil", "super", "throws", "try", "catch", "inout", "static", "public", "private", "internal"}


def swift_name(name: str) -> str:
    return f"`{name}`" if name in KEYWORDS else name


class Param:
    """One parameter as the table maps it. `kind` picks the emission, `swift` is the type in the signature."""

    def __init__(self, name: str, swift: str | None, kind: str, size: str | None = None) -> None:
        self.name = swift_name(name)
        self.swift = swift
        self.kind = kind
        self.size = size

    def word(self) -> str:
        if self.kind == "out_string":
            return f"{self.name.strip('`')}Pointer.baseAddress!"
        if self.kind == "vec3_array":
            return f"{self.name.strip('`')}Flat.baseAddress!"
        if self.kind == "slots":
            return f"{self.name}.base"
        if self.kind == "view_opt":
            return f"{self.name}?.handle"
        return self.name


def fence(block: list[str]) -> list[str]:
    """Raven's block as a documentation comment with his text in a code fence, so markdown shows it line for line and touches nothing."""
    if len(block) == 1:
        text = block[0]
        return ["/**", "```", text[text.index("/*") + 2 : text.rindex("*/")].strip(), "```", "*/"]
    first = block[0].replace("/*", "/**", 1)
    body = [first[3:].strip()] if first.strip() != "/**" else []
    body += block[1:-1]
    last = block[-1]
    if last.strip() != "*/":
        body.append(last[: last.rindex("*/")].rstrip())
    while body and not body[0].strip():
        body.pop(0)
    while body and not body[-1].strip():
        body.pop()
    return ["/**", "```"] + body + ["```", "*/"]


class SourceFile:
    """One oracle .c file, read once, for the text a cursor's extent names and Raven's comment above a function."""

    def __init__(self, path) -> None:
        self.lines = path.read_text().splitlines()


    def slice(self, extent: ci.SourceRange) -> str:
        start, end = extent.start, extent.end
        if start.line == end.line:
            return self.lines[start.line - 1][start.column - 1:end.column - 1]
        parts = [self.lines[start.line - 1][start.column - 1:]]
        parts += self.lines[start.line:end.line - 1]
        parts.append(self.lines[end.line - 1][:end.column - 1])
        return "\n".join(parts)

    def comment_above(self, cur: ci.Cursor) -> list[str]:
        """Raven's comment lines directly above the function, verbatim, a block as /** */ and line comments as they are."""
        i = cur.extent.start.line - 2
        out: list[str] = []
        while i >= 0:
            line = self.lines[i].rstrip()
            stripped = line.strip()
            if not stripped:
                break
            if stripped.startswith("//"):
                out.insert(0, line)
                i -= 1
                continue
            if stripped.endswith("*/"):
                block = [line]
                while "/*" not in self.lines[i]:
                    i -= 1
                    block.insert(0, self.lines[i].rstrip())
                out = fence(block) + out
                i -= 1
                continue
            break
        return out

    def c_signature(self, cur: ci.Cursor) -> str:
        text = self.slice(cur.extent)
        return " ".join(text[:text.index("{")].split())


# The fields of bgEntity_t, the head of gentity_t and centity_t alike, which a bg body reads through its own view.
BG_FIELDS = {"s", "playerState", "m_pVehicle", "ghoul2", "localAnimIndex", "modelScale"}
ASSIGN_OPS = {"=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>="}
# The read set of the text sweep: every use of a non-const `char *` parameter the sweep knows to be a read, and the whole of it.
# A parameter whose every use is one of these crosses as a String, and any other use keeps it the `inout CharBuf` of rule 11,
# because a use the sweep cannot read is a use that may write the bytes.
#   1. A pass to a callee position the callee declared `const`, which no callee writes through.
#   2. A pass to a function of TEXT_READERS, and a pass past the last declared parameter, which is a format argument.
#   3. A pass to another function's own non-const `char *`, which the sweep follows to that parameter and back.
#   4. An operand of one of TEXT_TESTS, and an operand of `!`, which are Raven's NULL tests and his comparisons.
#   5. The whole condition of an `if`, a `while`, a `do`, or a `?:`, which is a NULL test again.
# A read at an index, a dereference, a cast, an address-of, pointer arithmetic, `++`, a store into the parameter,
# a return of it, and a pass to a function with no body are none of these, so each one keeps the CharBuf.
TEXT_READERS = {"Q_stricmp", "Q_stricmpn", "Q_strncmp", "strlen", "strcmp", "strncmp", "atoi", "atof", "Com_Printf"}
TEXT_TESTS = {"==", "!=", "<", ">", "<=", ">=", "&&", "||"}
# The Swift return of a `char *` the caller reads and nothing else, and of one Raven sets to NULL on a path.
TEXT_RESULT = ("String", "cString(at: UnsafeMutableRawPointer(bitPattern: word)!)")
OPTIONAL_TEXT_RESULT = ("String?", "UnsafeMutableRawPointer(bitPattern: word).map { cString(at: $0) }")


def capitalized(word: str) -> str:
    return word[:1].upper() + word[1:]


class Read:
    """One game field a bg body reaches: the root kind, the field path, the Swift type, and whether the body writes it.
    The channel writes one callback per read, and the draft calls it, by the hole walk's row 1."""

    def __init__(self, root: str, path: tuple[str, ...], swift: str, write: bool, cite: str) -> None:
        self.root = root
        self.path = path
        self.swift = swift
        self.write = write
        self.cite = cite
        self.name = self.short_name()

    @property
    def key(self) -> tuple[str, tuple[str, ...], bool]:
        return (self.root, self.path, self.write)

    @property
    def entity(self) -> bool:
        return self.root == "entity"

    def short_name(self) -> str:
        if self.root == "entity":
            stem = ("Client" if self.path[0] == "client" else "Entity") + capitalized(self.path[-1])
        elif self.root == "level":
            stem = "Level" + capitalized(self.path[-1])
        else:
            stem = capitalized(self.root.removeprefix("cvar:").removeprefix("g_")) + capitalized(self.path[-1])
        return ("bgSet" if self.write else "bg") + stem

    def long_name(self) -> str:
        head = {"entity": "Entity", "level": "Level"}.get(self.root, capitalized(self.root.removeprefix("cvar:").removeprefix("g_")))
        return ("bgSet" if self.write else "bg") + head + "".join(capitalized(f) for f in self.path)

    @property
    def install(self) -> str:
        """The game's expression for the read, over its own views, which the install closure runs."""
        if self.root == "entity":
            text = "Entity(handle: ent.handle)." + ".".join("client!" if f == "client" else f for f in self.path)
        elif self.root == "level":
            text = "level." + ".".join(self.path)
        else:
            text = self.root.removeprefix("cvar:") + "." + ".".join(self.path)
        return f"{text} = value" if self.write else text


class Table:
    def __init__(self, views: Generator | None = None) -> None:
        self.views = views if views is not None else Generator(None)
        # The (function, parameter) pairs a bg body passes NULL or 0 to, so the wrapper takes the parameter as optional.
        self.nullable: set[tuple[str, str]] = set()
        # The functions the NULL sweep saw a call to, so a parameter outside `nullable` is proven never NULL only for these.
        self.called: set[str] = set()
        # The (function, parameter) pairs whose body writes through the pointer, so the output keeps its `inout` spelling.
        self.stores_through: set[tuple[str, str]] = set()
        # The (function, parameter) pairs whose body never writes through the `char *`, so the parameter is a String.
        self.readonly_text: set[tuple[str, str]] = set()
        # The functions that hand NULL back from a `char *` return, so the return is a String?.
        self.null_returns: set[str] = set()
        # The (function, parameter) pairs a body indexes, `animations[anim]`, so the parameter crosses as the Slots over the records.
        self.indexed_params: set[tuple[str, str]] = set()
        # The (struct, field) pairs a body indexes through the pointer, `pm->animations[anim]`, so the view gets the second accessor.
        self.indexed_fields: set[tuple[str, str]] = set()

    def sweep_reads(self, tu: ci.TranslationUnit, folder: Path) -> list[Read]:
        """Every game field a bg body reaches through a gentity_t, the level, or a cvar, as the reads the channel carries.
        A bgEntity_t field, the bare `client` pointer, and `client->ps` are the bg view's own, so they are not reads."""
        reads: dict[tuple[str, tuple[str, ...], bool], Read] = {}
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or not path.stem.startswith("bg_"):
                continue
            data = C.parsed_bytes(path)
            consumed: set[tuple[int, int]] = set()
            writes: set[tuple[int, int]] = set()
            for node in cur.walk_preorder():
                kids = list(node.get_children())
                if node.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) and len(kids) == 2:
                    between = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
                    if between in ASSIGN_OPS:
                        left = self.unwrapped(kids[0])
                        writes.add((left.extent.start.offset, left.extent.end.offset))
                if node.kind != CursorKind.MEMBER_REF_EXPR:
                    continue
                span = (node.extent.start.offset, node.extent.end.offset)
                if span in consumed:
                    continue
                fields, root = self.chain(node, consumed)
                if root is None or self.own_field(root, fields):
                    continue
                swift = self.views.scalar(node.type, TARGET)
                if swift is None and self.views.is_vec3(node.type):
                    swift = "JKAShared.vec3_t"
                elif swift is None and node.type.get_canonical().kind == TypeKind.POINTER \
                        and node.type.get_canonical().get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                    swift = "JKAShared.PooledString?"
                elif swift is None:
                    # A record the views cover crosses as its view, `&client->pers.cmd` as the Usercmd over the game's memory.
                    record = self.views.record_name(node.type.get_canonical())
                    if not record or record not in self.views.views:
                        continue
                    swift = self.views.qualified_view(record, TARGET)
                write = span in writes
                key = (root, tuple(fields), write)
                if key not in reads:
                    reads[key] = Read(root, tuple(fields), swift, write, f"oracle/codemp/game/{path.stem}.c:{node.location.line}")
        # Two reads with one short name take their long names, so each callback names one path.
        by_name: dict[str, list[Read]] = {}
        for read in reads.values():
            by_name.setdefault(read.name, []).append(read)
        for group in by_name.values():
            if len(group) > 1:
                for read in group:
                    read.name = read.long_name()
        return sorted(reads.values(), key=lambda r: r.name)

    @staticmethod
    def unwrapped(cur: ci.Cursor) -> ci.Cursor:
        while cur.kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            kids = list(cur.get_children())
            if len(kids) != 1:
                break
            cur = kids[0]
        return cur

    def chain(self, node: ci.Cursor, consumed: set[tuple[int, int]]) -> tuple[list[str], str | None]:
        """The field path of a member chain, outermost last, and the kind of its root: an entity, the level, a cvar, or None."""
        fields: list[str] = []
        cur = node
        while cur.kind == CursorKind.MEMBER_REF_EXPR:
            fields.insert(0, cur.spelling)
            base = self.unwrapped(list(cur.get_children())[0])
            if base.kind == CursorKind.MEMBER_REF_EXPR:
                consumed.add((base.extent.start.offset, base.extent.end.offset))
            cur = base
        t = cur.type.get_canonical()
        if t.kind == TypeKind.POINTER:
            t = t.get_pointee().get_canonical()
        record = self.views.record_name(t)
        if record == "gentity_t":
            return fields, "entity"
        if cur.kind == CursorKind.DECL_REF_EXPR and cur.referenced is not None and cur.referenced.semantic_parent is not None \
                and cur.referenced.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
            if record == "level_locals_t":
                return fields, "level"
            if record == "vmCvar_t":
                return fields, f"cvar:{cur.spelling}"
        return fields, None

    @staticmethod
    def own_fields() -> set[str]:
        return BG_FIELDS

    @staticmethod
    def own_field(root: str, fields: list[str]) -> bool:
        return root == "entity" and (fields[0] in BG_FIELDS or fields == ["client"] or fields[:2] == ["client", "ps"])

    def sweep_nulls(self, tu: ci.TranslationUnit, *folders: Path) -> None:
        """The NULL sweep of the hole walk's row 2: every pointer parameter a body of the folders passes NULL or 0 to, by the callee's name.
        A `strap_` callee names its `trap_` twin too, because the game's strap forwards the argument to the trap as it is.

        The sweep walks every `.c` file of the folders, not the bg files alone, because one NULL at any call site makes the parameter optional.
        `called` holds the callees it reached, and a parameter of a function in that set and outside `nullable` is proven never NULL.
        The proof covers the game module and the cgame module, which are the two units the port parses.
        The ui module has no parse yet, so a ui call site is outside the proof.
        A function only ui reaches is a known gap, and it stays one until the ui module parse lands."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent not in folders or path.suffix != ".c":
                continue
            data = C.parsed_bytes(path)
            for node in cur.walk_preorder():
                if node.kind != CursorKind.CALL_EXPR or node.referenced is None or node.referenced.kind != CursorKind.FUNCTION_DECL:
                    continue
                params = list(node.referenced.get_arguments())
                self.called.add(node.referenced.spelling)
                if node.referenced.spelling.startswith("strap_"):
                    self.called.add("trap_" + node.referenced.spelling[len("strap_"):])
                for i, arg in enumerate(list(node.get_children())[1:]):
                    text = data[arg.extent.start.offset:arg.extent.end.offset].decode("utf-8", "replace").strip()
                    if text in ("NULL", "0") and i < len(params) and self.takes_null(params[i].type):
                        callee = node.referenced.spelling
                        self.nullable.add((callee, params[i].spelling))
                        if callee.startswith("strap_"):
                            self.nullable.add(("trap_" + callee[len("strap_"):], params[i].spelling))

    @staticmethod
    def takes_null(t: ci.Type) -> bool:
        """True for a parameter type NULL fits: a pointer, and an array too, because C decays an array parameter to a pointer."""
        return t.get_canonical().kind in (TypeKind.POINTER, TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY)

    def sweep_stores(self, tu: ci.TranslationUnit, folder: Path) -> None:
        """Every pointer parameter a body of the folder writes through, `*p = x` or `p[i] = x`, by the function's name.

        The table reads it beside `nullable`: a scalar output the body always writes keeps the `inout` spelling, and the caller's NULL
        takes a scratch local at the call site instead. A parameter the body only reads has no such seat, so a NULL there stays optional."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or path.suffix != ".c":
                continue
            data = C.parsed_bytes(path)
            names = {p.spelling for p in cur.get_arguments()}
            if not names:
                continue
            for node in cur.walk_preorder():
                if node.kind not in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
                    continue
                kids = list(node.get_children())
                if len(kids) != 2:
                    continue
                between = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
                if between not in ASSIGN_OPS:
                    continue
                target = self.store_target(self.unwrapped(kids[0]), data)
                if target in names:
                    self.stores_through.add((cur.spelling, target))

    def store_target(self, cur: ci.Cursor, data: bytes) -> str | None:
        """The parameter name a store writes through, for `*p` and for `p[i]`, or None for any other left side."""
        if cur.kind == CursorKind.UNARY_OPERATOR:
            kids = list(cur.get_children())
            if not kids:
                return None
            prefix = data[cur.extent.start.offset:kids[0].extent.start.offset].decode("utf-8", "replace")
            if "*" not in prefix:
                return None
            inner = self.unwrapped(kids[0])
            if inner.kind == CursorKind.DECL_REF_EXPR and inner.referenced is not None \
                    and inner.referenced.kind == CursorKind.PARM_DECL:
                return inner.spelling
            return None
        if cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            base = self.unwrapped(list(cur.get_children())[0])
            if base.kind == CursorKind.DECL_REF_EXPR and base.referenced is not None \
                    and base.referenced.kind == CursorKind.PARM_DECL:
                return base.spelling
        return None

    def never_null(self, owner: str | None, name: str) -> bool:
        """True when the NULL sweep proves this parameter is never NULL: the sweep read a call to the function, and no call passed NULL.

        A function no call reached is unknown, because the port has read no caller of it yet, and unknown is not a proof."""
        return owner is not None and owner in self.called and (owner, name) not in self.nullable

    # MARK: - The text sweep

    @staticmethod
    def mutable_text(t: ci.Type) -> bool:
        """True for a `char *` Raven wrote without `const`."""
        canonical = t.get_canonical()
        if canonical.kind != TypeKind.POINTER:
            return False
        pointee = canonical.get_pointee()
        return pointee.get_canonical().kind == TypeKind.CHAR_S and not pointee.is_const_qualified()

    def text_uses(self, cur: ci.Cursor, targets: set[str]) -> list[tuple[ci.Cursor, list[ci.Cursor]]]:
        """Every reference to one of the named parameters in the body, each with the nodes above it, innermost first."""
        out: list[tuple[ci.Cursor, list[ci.Cursor]]] = []
        stack: list[tuple[ci.Cursor, list[ci.Cursor]]] = [(cur, [])]
        while stack:
            node, chain = stack.pop()
            if node.kind == CursorKind.DECL_REF_EXPR and node.spelling in targets \
                    and node.referenced is not None and node.referenced.kind == CursorKind.PARM_DECL:
                out.append((node, chain))
            for kid in node.get_children():
                stack.append((kid, [node] + chain))
        return out

    def text_use(self, node: ci.Cursor, chain: list[ci.Cursor], data: bytes) -> tuple[str, tuple[str, int] | None]:
        """One use of a `char *` parameter as the sweep reads it: "read", "pass" with the callee and the position, or "unknown"."""
        inner = node
        depth = 0
        while depth < len(chain) and chain[depth].kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            inner = chain[depth]
            depth += 1
        if depth >= len(chain):
            return ("unknown", None)
        parent = chain[depth]
        kids = list(parent.get_children())
        if parent.kind == CursorKind.CALL_EXPR:
            return self.text_argument(parent, inner, kids)
        if parent.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2:
            between = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
            return ("read", None) if between in TEXT_TESTS else ("unknown", None)
        if parent.kind == CursorKind.UNARY_OPERATOR and data[parent.extent.start.offset:parent.extent.start.offset + 1] == b"!":
            return ("read", None)
        if parent.kind in (CursorKind.IF_STMT, CursorKind.WHILE_STMT, CursorKind.DO_STMT):
            # Raven's `if (p)` and `while (p)` are NULL tests.
            return ("read", None)
        if parent.kind == CursorKind.CONDITIONAL_OPERATOR and kids and self.same_extent(kids[0], inner):
            return ("read", None)
        return ("unknown", None)

    @staticmethod
    def same_extent(one: ci.Cursor, other: ci.Cursor) -> bool:
        return one.extent.start.offset == other.extent.start.offset and one.extent.end.offset == other.extent.end.offset

    def text_argument(self, call: ci.Cursor, inner: ci.Cursor, kids: list[ci.Cursor]) -> tuple[str, tuple[str, int] | None]:
        """One `char *` parameter as an argument of a call: a read, a pass the sweep follows, or an unknown use."""
        args = kids[1:]
        position = next((i for i, a in enumerate(args) if self.same_extent(a, inner)), None)
        callee = call.referenced
        if position is None or callee is None or callee.kind != CursorKind.FUNCTION_DECL:
            return ("unknown", None)
        name = callee.spelling
        params = list(callee.get_arguments())
        if name in TEXT_READERS or position >= len(params):
            # A format argument list and the compare and length functions read the bytes and write none of them.
            return ("read", None)
        t = params[position].type.get_canonical()
        if t.kind != TypeKind.POINTER:
            return ("unknown", None)
        if t.get_pointee().is_const_qualified():
            return ("read", None)
        if t.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
            return ("pass", (name, position))
        return ("unknown", None)

    def sweep_text(self, tu: ci.TranslationUnit, folder: Path) -> None:
        """The text sweep of the stop walk's row 2: a non-const `char *` parameter crosses as a String when every use of it reads.

        The default is the `inout CharBuf` of rule 11, because a pointer the port cannot read is a pointer Raven may write through.
        A parameter joins the String set only when the sweep knows every one of its uses, and TEXT_READS names the uses it knows.
        A pass to another function's own non-const `char *` follows that parameter, and the set iterates to a fixpoint."""
        candidates: set[tuple[str, str]] = set()
        forwards: dict[tuple[str, str], set[tuple[str, int]]] = {}
        # The name of each swept `char *` parameter by its function and its position, so a pass finds the callee's row.
        by_position: dict[tuple[str, int], str] = {}
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or path.suffix != ".c":
                continue
            owner = cur.spelling
            params = list(cur.get_arguments())
            targets = {p.spelling for p in params if self.mutable_text(p.type)}
            for i, p in enumerate(params):
                if p.spelling in targets:
                    by_position[(owner, i)] = p.spelling
            if not targets:
                continue
            data = C.parsed_bytes(path)
            uses: dict[str, list[tuple[str, tuple[str, int] | None]]] = {name: [] for name in targets}
            for node, chain in self.text_uses(cur, targets):
                uses[node.spelling].append(self.text_use(node, chain, data))
            for name, kinds in uses.items():
                if any(kind == "unknown" for kind, _ in kinds):
                    continue
                candidates.add((owner, name))
                forwards[(owner, name)] = {site for kind, site in kinds if kind == "pass" and site is not None}
        changed = True
        while changed:
            changed = False
            for pair in list(candidates):
                for callee, position in forwards.get(pair, set()):
                    name = by_position.get((callee, position))
                    if name is None or (callee, name) not in candidates:
                        # The callee has no body here, or its own parameter takes the bytes, so this one takes them too.
                        candidates.discard(pair)
                        changed = True
                        break
        self.readonly_text |= candidates

    # MARK: - The subscript sweep

    def record_pointer(self, t: ci.Type) -> bool:
        """True for a pointer to a struct a view covers, which is the shape a `Slots` stands over."""
        canonical = t.get_canonical()
        if canonical.kind != TypeKind.POINTER:
            return False
        record = self.views.record_name(canonical.get_pointee())
        return bool(record) and record in self.views.views

    def sweep_subscripts(self, tu: ci.TranslationUnit, *folders: Path) -> None:
        """The subscript sweep of the stop walk's row 1: every struct pointer a body indexes, `animations[anim]`.

        A parameter any site of its body indexes crosses as the `Slots` over the records, and a one-record read of it spells `[0]`.
        A field any site indexes gets the `<name>Slots` accessor on its view, beside the pointer the field already gives.
        The sweep reads the game unit and the cgame unit, which are the two units the port parses, because one bg body stands in
        both with a different arm. A shape the sweep does not read keeps the one-record spelling it has today."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent not in folders or path.suffix != ".c":
                continue
            for node in cur.walk_preorder():
                if node.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
                    continue
                kids = list(node.get_children())
                if not kids:
                    continue
                base = self.unwrapped(kids[0])
                if not self.record_pointer(base.type):
                    continue
                if base.kind == CursorKind.DECL_REF_EXPR and base.referenced is not None \
                        and base.referenced.kind == CursorKind.PARM_DECL:
                    self.indexed_params.add((cur.spelling, base.spelling))
                elif base.kind == CursorKind.MEMBER_REF_EXPR and base.referenced is not None \
                        and base.referenced.semantic_parent is not None:
                    owner = base.referenced.semantic_parent
                    self.indexed_fields.add((self.record_name_of(owner), base.spelling))

    def record_name_of(self, owner: ci.Cursor) -> str:
        """The name a NEVER_NULL row and an indexed field row key on: Raven's typedef name, or the tag where he gave none."""
        return self.views.record_name(owner.type) or owner.spelling

    def indexed_field(self, field: ci.Cursor) -> bool:
        """True when the subscript sweep read a body that indexes this field through its pointer."""
        if field is None or field.semantic_parent is None:
            return False
        return (self.record_name_of(field.semantic_parent), field.spelling) in self.indexed_fields

    def sweep_returns(self, tu: ci.TranslationUnit, folder: Path) -> None:
        """The NULL sweep over returns: a function that returns `char *` and hands NULL back at any site returns a String?."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or path.suffix != ".c":
                continue
            result = cur.result_type.get_canonical()
            if result.kind != TypeKind.POINTER or result.get_pointee().get_canonical().kind != TypeKind.CHAR_S:
                continue
            data = C.parsed_bytes(path)
            for node in cur.walk_preorder():
                if node.kind != CursorKind.RETURN_STMT:
                    continue
                kids = list(node.get_children())
                if not kids:
                    continue
                value = self.unwrapped(kids[0])
                text = data[value.extent.start.offset:value.extent.end.offset].decode("utf-8", "replace").strip()
                if text in ("NULL", "0"):
                    self.null_returns.add(cur.spelling)

    def sweep(self, tu: ci.TranslationUnit, folder: Path, other: ci.TranslationUnit | None = None,
              other_folder: Path | None = None) -> None:
        """Every sweep a signature of the module needs, in the order the table reads them.

        The NULL sweep walks every .c file of the folder, because a proof that a parameter is never NULL needs every caller the port parses.
        It walks the second unit over both folders when the caller hands one over, so a call on Raven's cgame arm of a bg file counts,
        and so does a call from the cgame's own .c files.
        The store sweep, the text sweep, and the return sweep walk every .c file of the folder, because the body of the callee decides all three.
        The subscript sweep walks both units the same way the NULL sweep does, because a body has one arm in each of them."""
        self.sweep_nulls(tu, folder)
        self.sweep_subscripts(tu, folder)
        if other is not None:
            self.sweep_nulls(other, folder, *([other_folder] if other_folder is not None else []))
            self.sweep_subscripts(other, folder, *([other_folder] if other_folder is not None else []))
        self.sweep_stores(tu, folder)
        self.sweep_text(tu, folder)
        self.sweep_returns(tu, folder)

    def marker_reason(self, cur: ci.Cursor, owner: str | None = None) -> str:
        """The marker line for a parameter the table cannot shape: a PARAMS hold names its kind and the ruling it waits on,
        and any other parameter has no row yet."""
        spelled = f"`{' '.join(cur.type.spelling.split())} {cur.spelling}`"
        ruled = PARAMS.get((owner, cur.spelling))
        if isinstance(ruled, tuple):
            ruled = ruled[0]
        if ruled is not None:
            return f"Held by PARAMS as `{ruled}`, {spelled}, until a ruling gives the kind a shape."
        return f"No table row for {spelled}."

    def param(self, cur: ci.Cursor, following: ci.Cursor | None, traps: bool = True, owner: str | None = None) -> Param | None:
        """The table row of one parameter. A `char *` out-buffer is a returned String only in a trap, where the engine fills it."""
        name = cur.spelling
        t = cur.type
        canonical = t.get_canonical()
        ruled = PARAMS.get((owner, name))
        capacity = None
        if isinstance(ruled, tuple):
            ruled, capacity = ruled
        if ruled == "raw":
            return Param(name, "UnsafeMutableRawPointer", "bare")
        if ruled == "vec3_mut":
            return Param(name, "inout JKAShared.vec3_t", "vec3_mut")
        if ruled == "float_array":
            return Param(name, "inout [Float]", "bare")
        if t.spelling.replace("const ", "") in TYPES:
            return Param(name, TYPES[t.spelling.replace("const ", "")], "bare")
        # A vector parameter is the array type itself, and Clang keeps the typedef name on the parameter.
        if t.spelling.split()[-1] in VECTORS:
            if "const" in t.spelling:
                return Param(name, f"JKAShared.{t.spelling.split()[-1]}", "vec3_const")
            return Param(name, f"inout JKAShared.{t.spelling.split()[-1]}", "vec3_mut")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if t.get_pointee().spelling in VECTORS:
                if traps:
                    # An array of vectors the engine reads, with a count beside it. The trap packs it flat, see traps.py.
                    return Param(name, f"[JKAShared.{t.get_pointee().spelling}]", "vec3_array")
                # A pointer to one vector the caller owns, which Raven writes as `(*c)[i]`.
                return Param(name, f"inout JKAShared.{t.get_pointee().spelling}", "vec3_mut")
            if pointee.is_const_qualified() and pointee.kind in INT_KINDS | {TypeKind.FLOAT}:
                # Raven takes the address of a const scalar to reinterpret its bytes, so the scalar crosses by value.
                swift = self.views.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Param(name, swift, "bare")
            inner = pointee.get_canonical()
            if inner.kind == TypeKind.FUNCTIONPROTO:
                return None if traps else self.closure(cur, name)
            if "vec3_t" in t.spelling:
                # `vec3_t name[3]` is an axis, the type the ported q_math axis functions take.
                return None if traps else Param(name, "inout [JKAShared.vec3_t]", "vec3_axis")
            if inner.kind == TypeKind.CHAR_S:
                if pointee.is_const_qualified():
                    if PARAMS.get((owner, name)) == "text_cursor":
                        # A cursor Raven passes by value and returns advanced, the SkipWhitespace shape.
                        return Param(name, "JKAShared.TextCursor", "text_cursor")
                    if (owner, name) in self.nullable:
                        return Param(name, "String?", "cstring_opt")
                    return Param(name, "String", "cstring")
                if traps and following is not None and following.type.get_canonical().kind in INT_KINDS and SIZE_NAME.search(following.spelling):
                    return Param(name, None, "out_string", size=following.spelling)
                if traps and ruled == "fill_buffer":
                    # A buffer the engine fills with no size beside it takes the capacity Raven's callers declare, and the trap returns the String.
                    return Param(name, None, "out_string", size=capacity)
                if traps:
                    # A `char *` Raven wrote without `const` into a trap is an input the engine reads, a String like `const char *`.
                    return Param(name, "String", "cstring")
                if ruled is None and (owner, name) in self.readonly_text:
                    # The body only reads the text, so the parameter is a String, the spelling a `const char *` already has.
                    # A PARAMS row names the kind itself, so it wins over the sweep.
                    return Param(name, "String?" if (owner, name) in self.nullable else "String",
                                 "cstring_opt" if (owner, name) in self.nullable else "cstring")
                # A body reads and rewrites the caller's buffer in place, so the caller's CharBuf crosses with `&`.
                return Param(name, "inout JKAShared.CharBuf", "inout_charbuf")
            record = self.views.record_name(pointee)
            if record and record in self.views.views:
                if ruled == "table":
                    # Raven indexes the table through the pointer, so the Slots over it crosses, and its base is the word.
                    return Param(name, f"Slots<{self.views.qualified_view(record, TARGET)}>", "slots")
                if (owner, name) in self.indexed_params:
                    # Raven indexes the parameter, `animations[anim]`, so the Slots over the records crosses, and a one-record read spells `[0]`.
                    view = self.views.qualified_view(record, TARGET)
                    if (owner, name) in self.nullable:
                        return Param(name, f"Slots<{view}>?", "slots_opt")
                    return Param(name, f"Slots<{view}>", "slots")
                if owner == "BG_ParseField":
                    return Param(name, f"Slots<{self.views.qualified_view(record, TARGET)}>", "bare")
                if (owner, name) in self.nullable:
                    return Param(name, f"{self.views.qualified_view(record, TARGET)}?", "view_opt")
                return Param(name, self.views.qualified_view(record, TARGET), "view")
            if inner.kind == TypeKind.VOID:
                return Param(name, "OpaquePointer?", "bare")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.VOID:
                # The address of a `void *` the engine fills or clears, one word up from the handle it holds.
                return Param(name, "inout OpaquePointer?", "out_opaque")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                # A `const char **` is Raven's cursor into a text buffer, which the COM_Parse family advances. A parameter the
                # function sets to the token instead has a PARAMS entry, and a non-const `char **` takes that entry the same way.
                if PARAMS.get((owner, name)) == "out_string":
                    return Param(name, "inout String", "out_string_ref")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S and inner.get_pointee().is_const_qualified():
                return None if traps else Param(name, "inout JKAShared.TextCursor", "text_cursor")
            if inner.kind == TypeKind.POINTER and not pointee.is_const_qualified():
                # The address of a struct pointer the body sets, an out-param, `inout View?`. A pointer table into a trap has a PARAMS entry.
                record = self.views.record_name(inner.get_pointee())
                if ruled == "pointer_table" and record and record in self.views.views:
                    # The table's base crosses to the engine, and the body holds the Slots over the C storage.
                    return Param(name, f"Slots<{self.views.qualified_view(record, TARGET)}?>", "slots")
                if record and record in self.views.views and not traps:
                    return Param(name, f"inout {self.views.qualified_view(record, TARGET)}?", "out_view")
            # An array of model handles the engine reads, and every caller passes NULL. The pointer stays in generated code.
            if t.get_pointee().spelling.replace("const ", "") == "qhandle_t":
                return Param(name, "UnsafeMutablePointer<Int32>?", "bare")
            # A pointer to one scalar is an out-param, `inout`. A body that finds Raven walks it as an array writes a Port-note.
            if not pointee.is_const_qualified() and (inner.kind in INT_KINDS or inner.kind in (TypeKind.FLOAT, TypeKind.ENUM)):
                swift = self.views.scalar(pointee, TARGET)
                if swift is not None and self.known(swift) and (owner, name) in self.nullable \
                        and (owner, name) not in self.stores_through:
                    # An output a caller skips with NULL crosses as the pointer itself, in the wrapper alone, so `nil` has a seat.
                    # A body that writes through the pointer keeps the `inout` spelling, and the caller's NULL takes a scratch local.
                    return Param(name, f"UnsafeMutablePointer<{swift}>?", "bare")
                if swift is not None and self.known(swift):
                    return Param(name, f"inout {swift}", "out_scalar")
            return None
        if canonical.kind == TypeKind.CONSTANTARRAY and "vec3_t" in t.spelling:
            # `vec3_t name[3]` is an axis, the type the ported q_math axis functions take.
            return None if traps else Param(name, "inout [JKAShared.vec3_t]", "vec3_axis")
        if canonical.kind in (TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY) and not traps:
            # A C array of struct pointers the function fills, `gentity_t *ent_list[MAX_GENTITIES]`, is the caller's array of optional views.
            element = canonical.element_type.get_canonical()
            if element.kind == TypeKind.POINTER:
                record = self.views.record_name(element.get_pointee())
                if record and record in self.views.views:
                    return Param(name, f"inout [{self.views.qualified_view(record, TARGET)}?]", "view_array")
                if element.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                    # A C array of strings the function fills from a caller's `&array[i]`, `char *infos[]`, is the caller's slice from `i` on.
                    return Param(name, "inout ArraySlice<String>", "string_slice")
            if canonical.kind == TypeKind.CONSTANTARRAY and (element.kind in INT_KINDS or element.kind == TypeKind.FLOAT):
                # A fixed C array of a scalar the body reads, `int delta_angles[3]`, is the values by value, copied at the call.
                # A body that writes through it would take `inout`, and none does.
                swift = self.views.scalar(canonical.element_type, TARGET)
                if swift is not None and self.known(swift):
                    return Param(name, f"[{swift}]", "bare")
        if canonical.kind in (TypeKind.RECORD, TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY):
            return None
        swift = self.views.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        if self.views.narrow(t) is not None:
            # C widens a short or a char argument to int at the call, so the parameter is Int32.
            swift = "Int32"
        # A C enum is an Int32 alias, so it travels as a bare word.
        return Param(name, swift, "bare")

    def closure(self, cur: ci.Cursor, name: str) -> Param | None:
        """A function-pointer parameter as an optional Swift closure, each prototype parameter through the same rows."""
        protos = [c for c in cur.get_children() if c.kind == CursorKind.PARM_DECL]
        types: list[str] = []
        for i, p in enumerate(protos):
            following = protos[i + 1] if i + 1 < len(protos) else None
            m = self.param(p, following, traps=False)
            if m is None or m.swift is None:
                return None
            types.append(m.swift)
        result = self.result_type(cur.type.get_canonical().get_pointee().get_result())
        if result is None:
            return None
        returns = result[0] or "Void"
        return Param(name, f"(({', '.join(types)}) -> {returns})?", "bare")

    def known(self, swift: str) -> bool:
        """A Swift spelling the logic target can see: a builtin, or a name a view target re-exports. An enum a .c file defines is neither."""
        return swift in BUILTINS or swift.split(".")[-1] in self.views.declared

    def result(self, cur: ci.Cursor) -> tuple[str | None, str] | None:
        """The Swift return type and the expression that maps the word into it, or None for an unmappable return."""
        ruled = RETURNS.get(cur.spelling)
        if ruled == "text_cursor":
            # A pointer into the caller's text, returned as the cursor it is.
            return ("JKAShared.TextCursor", "")
        if ruled == "raw":
            return ("UnsafeMutableRawPointer", "")
        if ruled == "pooled_string":
            return ("PooledString", "")
        if ruled == "optional_string":
            return OPTIONAL_TEXT_RESULT
        if ruled == "in_place":
            # Raven returns the argument it rewrote in place, which the caller already holds.
            return (None, "")
        if ruled == "text_offset":
            return ("Int32?", "")
        if ruled == "text_offset_nonnull":
            return ("Int32", "")
        if ruled == "vec3":
            return ("JKAShared.vec3_t", "")
        result = self.result_type(cur.result_type)
        if result is not None and result[0] == "String" and cur.spelling in self.null_returns:
            # The body hands NULL back at one site, so the text is optional and `return nil` is that site.
            return OPTIONAL_TEXT_RESULT
        return result

    def result_type(self, t: ci.Type) -> tuple[str | None, str] | None:
        canonical = t.get_canonical()
        if t.spelling in TYPES:
            return (TYPES[t.spelling], f"{TYPES[t.spelling]}(word)")
        if canonical.kind == TypeKind.VOID:
            return (None, "")
        if canonical.kind == TypeKind.FLOAT:
            return ("Float", "Float(bitPattern: UInt32(truncatingIfNeeded: word))")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if pointee.get_canonical().kind == TypeKind.FUNCTIONPROTO:
                # A returned function pointer goes into a view's stored function, so it is that field's callback type, optional.
                alias = self.views.callback_alias(pointee.get_canonical(), TARGET)
                return (f"{alias}?", "") if alias else None
            if pointee.get_canonical().kind == TypeKind.CHAR_S:
                # Text the caller reads and nothing else, so it crosses as a String. A function that returns NULL, rewrites its
                # argument in place, or returns a pointer into its argument has a RETURNS entry instead.
                return TEXT_RESULT
            # Raven returns NULL for no entity, so a returned view is optional.
            record = self.views.record_name(pointee)
            if record and record in self.views.views:
                view = self.views.qualified_view(record, TARGET)
                return (f"{view}?", f"OpaquePointer(bitPattern: word).map {{ {view}(handle: $0) }}")
            return None
        swift = self.views.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        if swift == "Bool":
            return ("Bool", "word != 0")
        if self.views.narrow(t) is not None:
            # C widens a short or a char return to int at the caller, so the return is Int32.
            return ("Int32", "Int32(truncatingIfNeeded: word)")
        return (swift, f"{swift}(truncatingIfNeeded: word)")
