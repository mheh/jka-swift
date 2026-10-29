#!/usr/bin/env python3
"""table.py: the C-to-Swift table of abi-stubs.md row 2, shared by traps.py and skeleton.py.

A parameter or a return maps by its C shape to the Swift type in the signature and the way it crosses the seam.
spelling.py owns that mapping. The table gathers the sweep facts and the rulings of a cursor, hands them over, and wraps the
answer into the `Param` its callers read.
"""

from __future__ import annotations

import functools
import re
import sys
from pathlib import Path

import clang.cindex as ci
from clang.cindex import TypeKind

from clang.cindex import CursorKind

import closure as C
import store as S
from reexport import GAME_TARGET
from fnsweep import ASSIGN_OPS
from overlay import DECLARED, DROPPED, MACROS, written_arguments
from rulings import HAND_MACROS, NULLABLE, PARAMS, RETURNS
from views import Generator
from spelling import Facts, OPTIONAL_TEXT_RESULT, engine_array

TARGET = GAME_TARGET
HERE = Path(__file__).resolve().parent
# The store file of the sweeps, and the output folders whose files the key reads, from the project file.
STORE = C.REPO / C.TARGETS["store"]
OUTPUT = C.REPO / C.PROJECT["output"]["root"]
# True when a generator runs with --rebuild, so the next sweep of the run resweeps every generation and writes it again.
REBUILD = False
# The fact stores of each generation, by their attribute names.
# The store sweep reads the adoption of the bg stubs, so its facts stand under the adoption key, and so do the local facts that read them.
# The swept part of `nullable` stands beside the rows of NULLABLE it started from, which the `rulings` kind holds.
BASE_FACTS = ("nullable", "hopped", "called", "readonly_text", "null_returns", "indexed_params", "indexed_fields", "handoffs",
              "cursors", "alias_writes", "buffer_traps", "text_traps", "reads", "file_walks", "array_handoffs",
              "null_arms")
ADOPTION_FACTS = ("stores_through", "store_swept")
# A Raven parameter name that is a Swift keyword is written in backticks.
KEYWORDS = {"extension", "in", "func", "class", "struct", "enum", "protocol", "default", "operator", "repeat", "where",
            "import", "self", "init", "var", "let", "return", "case", "switch", "if", "else", "for", "while", "do", "is", "as",
            "true", "false", "nil", "super", "throws", "try", "catch", "inout", "static", "public", "private", "internal"}


def swift_name(name: str) -> str:
    return f"`{name}`" if name in KEYWORDS else name


class Param:
    """One parameter as the table maps it. `kind` picks the emission, `swift` is the type in the signature."""

    def __init__(self, name: str, swift: str | None, kind: str, size: str | None = None, label: str | None = None) -> None:
        self.name = swift_name(name)
        self.swift = swift
        self.kind = kind
        self.size = size
        # The argument label a generated signature writes before the name. A parameter with none takes Raven's bare call shape.
        self.label = label

    def word(self) -> str:
        if self.kind in ("out_string", "out_array"):
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
        try:
            self.lines = path.read_text().splitlines()
        except UnicodeDecodeError:
            # cg_effects.c:401 holds the Latin-1 byte 0xD7, the multiplication sign, in a comment.
            # Latin-1 reads each byte as one character, so every column of clang's extent stays where it was.
            self.lines = path.read_text(encoding="latin-1").splitlines()


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


# MARK: - The syntax rows

# The functions the overlay declares in place of Raven's function-like macros, so a use of one parses as a call and not as a macro.
OVERLAY_CALLS = set(MACROS) | DROPPED | DECLARED


def statement_children(cur: ci.Cursor, data: bytes) -> list[ci.Cursor]:
    """The children of a statement that stand in a statement place, in source order.
    The test of an `if`, a loop, or a `switch` and the case value are expressions and stand in no statement place.
    The init and the step of a `for` do, and so do the two sides of C's comma operator in a statement place, because the drafter writes each as a statement."""
    kids = list(cur.get_children())
    kind = cur.kind
    if kind == CursorKind.COMPOUND_STMT:
        return kids
    if kind == CursorKind.IF_STMT:
        return kids[1:]
    if kind in (CursorKind.WHILE_STMT, CursorKind.SWITCH_STMT, CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT, CursorKind.LABEL_STMT):
        return kids[-1:]
    if kind == CursorKind.DO_STMT:
        return kids[:1]
    if kind == CursorKind.FOR_STMT:
        body = kids[-1]
        semis: list[int] = []
        depth = 0
        for token in cur.get_tokens():
            if token.extent.start.offset >= body.extent.start.offset:
                break
            if token.spelling == "(":
                depth += 1
            elif token.spelling == ")":
                depth -= 1
            elif token.spelling == ";" and depth == 1:
                semis.append(token.extent.start.offset)
        if len(semis) != 2:
            return [body]
        # The test stands between the two semicolons of the head, and the init and the step stand outside them.
        return [k for k in kids[:-1] if not semis[0] <= k.extent.start.offset < semis[1]] + [body]
    inner = cur
    while inner.kind == CursorKind.UNEXPOSED_EXPR and len(list(inner.get_children())) == 1:
        inner = next(inner.get_children())
    if inner.kind == CursorKind.BINARY_OPERATOR:
        parts = list(inner.get_children())
        if len(parts) == 2:
            between = data[parts[0].extent.end.offset:parts[1].extent.start.offset].decode("utf-8", "replace")
            if COMMENT.sub("", between).strip() == ",":
                return parts
    return []


def between_lines(source: SourceFile, after: int, before: int) -> list[tuple[int, str]]:
    """Raven's comment and blank lines strictly between two source lines, each as its line number and its stripped text.
    A blank line has empty text, and a line of code or of the preprocessor has no row."""
    out: list[tuple[int, str]] = []
    block = False
    for number in range(after + 1, before):
        text = source.lines[number - 1].strip()
        if block:
            out.append((number, text))
            block = "*/" not in text
        elif not text or text.startswith("//"):
            out.append((number, text))
        elif text.startswith("/*"):
            out.append((number, text))
            block = "*/" not in text[2:]
    return out


def syntax_rows(stem: str, fn: ci.Cursor, source: SourceFile, data: bytes,
                uses: list[ci.Cursor]) -> tuple[list[tuple], list[tuple], list[tuple]]:
    """The statement rows, the comment rows, and the macro rows of one function body, in the column order of the store.

    Every statement node of the body is one row, numbered in preorder from the body itself, and an expression has no row.
    A comment line between two statements is `above` the next statement when no blank line stands between them, and `gap` otherwise.
    A blank line is a `gap` row with empty text, and the lines after the last statement of a block are `gap` rows of the block.
    A comment after the brace of a block is `opening`, and a comment after the last text of a statement is `trailing`.
    `uses` are the macro uses of the file, and a call of the overlay counts as the use of a function-like macro."""
    body = [c for c in fn.get_children() if c.kind == CursorKind.COMPOUND_STMT][-1]
    nodes: list[tuple[ci.Cursor, int | None]] = []

    def visit(cur: ci.Cursor, parent: int | None) -> None:
        seq = len(nodes)
        nodes.append((cur, parent))
        for child in statement_children(cur, data):
            visit(child, seq)

    visit(body, None)
    function = fn.spelling
    statements = []
    for seq, (cur, parent) in enumerate(nodes):
        start, end = cur.extent.start, cur.extent.end
        statements.append((stem, function, seq, parent, cur.kind.name, start.line, start.column, end.line, end.column,
                           start.offset, end.offset, source.slice(cur.extent)))
    comments: dict[tuple[int, int], tuple] = {}
    seq_of = {(cur.kind.name, cur.extent.start.offset, cur.extent.end.offset): seq for seq, (cur, _) in enumerate(nodes)}
    for seq, (cur, _) in enumerate(nodes):
        if cur.kind != CursorKind.COMPOUND_STMT:
            continue
        rest = source.lines[cur.extent.start.line - 1][cur.extent.start.column:].strip()
        if rest.startswith("//") or (rest.startswith("/*") and rest.endswith("*/") and len(rest) >= 4):
            comments[(seq, cur.extent.start.line)] = (stem, function, seq, cur.extent.start.line, "opening", rest)
        previous = cur.extent.start.line
        for child in cur.get_children():
            run = between_lines(source, previous, child.extent.start.line)
            child_seq = seq_of[(child.kind.name, child.extent.start.offset, child.extent.end.offset)]
            # The comment lines that touch the statement, with no blank line between, stand above it.
            touching, expected = len(run), child.extent.start.line - 1
            while touching > 0 and run[touching - 1][1] and run[touching - 1][0] == expected:
                touching, expected = touching - 1, expected - 1
            for i, (line, text) in enumerate(run):
                comments[(child_seq, line)] = (stem, function, child_seq, line, "above" if i >= touching else "gap", text)
            previous = child.extent.end.line
        for line, text in between_lines(source, previous, cur.extent.end.line):
            comments[(seq, line)] = (stem, function, seq, line, "gap", text)
    # A trailing comment belongs to the statement that ends last before it on its line, and the innermost one of equal end.
    trailing: dict[int, tuple[int, int, str]] = {}
    for seq, (cur, _) in enumerate(nodes):
        end = cur.extent.end
        rest = source.lines[end.line - 1][end.column - 1:].strip().lstrip(";").strip()
        if rest.startswith("//") and (end.line not in trailing or (end.offset, seq) > trailing[end.line][:2]):
            trailing[end.line] = (end.offset, seq, rest)
    for line, (_, seq, text) in trailing.items():
        comments[(seq, line)] = (stem, function, seq, line, "trailing", text)

    def innermost(offset: int) -> int:
        return max(seq for seq, (cur, _) in enumerate(nodes) if cur.extent.start.offset <= offset < cur.extent.end.offset)

    macros: dict[tuple[int, int], tuple] = {}
    low, high = body.extent.start.offset, body.extent.end.offset
    for use in uses:
        offset = use.extent.start.offset
        if not low <= offset < high:
            continue
        text = source.slice(use.extent)
        kind = "hand" if use.spelling in HAND_MACROS else ("function" if text.strip() != use.spelling else "object")
        seq = innermost(offset)
        macros[(seq, offset)] = (stem, function, seq, offset, use.extent.end.offset, use.spelling, text, kind)
    taken = {offset for _, offset in macros}
    for node in body.walk_preorder():
        if node.kind == CursorKind.CALL_EXPR and node.spelling in OVERLAY_CALLS and node.extent.start.offset not in taken:
            offset = node.extent.start.offset
            seq = innermost(offset)
            macros[(seq, offset)] = (stem, function, seq, offset, node.extent.end.offset, node.spelling, source.slice(node.extent), "function")
    return statements, sorted(comments.values(), key=lambda row: (row[2], row[3])), sorted(macros.values(), key=lambda row: (row[2], row[3]))


# The fields of bgEntity_t, the head of gentity_t and centity_t alike, which a bg body reads through its own view.
BG_FIELDS = {"s", "playerState", "m_pVehicle", "ghoul2", "localAnimIndex", "modelScale"}
# The read set of the text sweep: every use of a non-const `char *` parameter the sweep knows to be a read, and the whole of it.
# A parameter whose every use is one of these crosses as a String, and any other use keeps it the `inout CharBuf` of rule 11,
# because a use the sweep cannot read is a use that may write the bytes.
#   1. A pass to a callee position the callee declared `const`, which no callee writes through.
#   2. A pass to a function of TEXT_READERS, which read the bytes and write none of them.
#   3. A pass past the last declared parameter, which is a format argument.
#   4. A pass to a function whose body the sweep has and whose matching parameter the sweep reads as a String,
#      which the sweep follows to that parameter and back.
#   5. An operand of one of TEXT_TESTS, and an operand of `!`, which are Raven's NULL tests and his comparisons.
#   6. The whole condition of an `if`, a `while`, a `do`, or a `?:`, which is a NULL test again.
#   7. An indexed read, `saberName[0]`, or a dereference, `*from`, used as a value and not as a store target.
#   8. The value of a pointer local, `p = from`, whose own uses are all reads of these forms.
#      A step of that local, `p++`, moves the local and writes no byte, so it counts as a read of the local.
# A cast, an address-of, pointer arithmetic, `++` on the parameter, a store into the parameter or through it,
# a return of it, and a pass to a function with no body are none of these, so each one keeps the CharBuf.
TEXT_READERS = {"Q_stricmp", "Q_stricmpn", "Q_strncmp", "strlen", "strcmp", "strncmp", "atoi", "atof", "Com_Printf"}
TEXT_TESTS = {"==", "!=", "<", ">", "<=", ">=", "&&", "||"}
# A C comment of either form, which a reader of the source text between two nodes drops before it reads the operator there.
COMMENT = re.compile(r"//[^\n]*|/\*.*?\*/", re.S)
# The loop statements, under which a write is one of many, so the name it writes cannot be a Swift `let`.
LOOPS = {CursorKind.FOR_STMT, CursorKind.WHILE_STMT, CursorKind.DO_STMT}


def capitalized(word: str) -> str:
    return word[:1].upper() + word[1:]


def collapsed(cur: ci.Cursor) -> bool:
    """True when a child spans the same bytes as the node, the mark of a macro expansion, whose nodes keep no text of their own."""
    return any(k.extent.start.offset == cur.extent.start.offset and k.extent.end.offset == cur.extent.end.offset for k in cur.get_children())


def between(data: bytes, left: ci.Cursor, right: ci.Cursor) -> str:
    """The source text between two nodes, with any comment Raven wrote there dropped, which carries the operator of a binary node."""
    return COMMENT.sub("", data[left.extent.end.offset:right.extent.start.offset].decode("utf-8", "replace")).strip()


class Read:
    """One game field a bg body reaches: the root kind, the field path, the Swift type, and whether the body writes it.
    The channel writes one callback per read, and the draft calls it, by the hole walk's row 1."""

    def __init__(self, root: str, path: tuple[str, ...], swift: str, write: bool, cite: str, at: bool = False) -> None:
        self.root = root
        self.path = path
        self.swift = swift
        self.write = write
        self.cite = cite
        # True when the field is an array of records and the read hands back the one record at a second index.
        self.at = at
        self.name = self.short_name()

    @property
    def key(self) -> tuple[str, tuple[str, ...], bool]:
        return (self.root, self.path, self.write)

    @property
    def entity(self) -> bool:
        return self.root == "entity"

    @property
    def indexed(self) -> bool:
        """True when the root is the game's entity table at an index, so the callback takes that index and no view."""
        return self.root == "entities"

    def short_name(self) -> str:
        if self.root in ("entity", "entities"):
            stem = ("Client" if self.path[0] == "client" else "Entity") + capitalized(self.path[-1])
        elif self.root == "level":
            stem = "Level" + capitalized(self.path[-1])
        else:
            stem = capitalized(self.root.removeprefix("cvar:").removeprefix("g_")) + capitalized(self.path[-1])
        return ("bgSet" if self.write else "bg") + stem

    def long_name(self) -> str:
        head = {"entity": "Entity", "entities": "EntityAt", "level": "Level"}.get(
            self.root, capitalized(self.root.removeprefix("cvar:").removeprefix("g_")))
        return ("bgSet" if self.write else "bg") + head + "".join(capitalized(f) for f in self.path)

    @property
    def install(self) -> str:
        """The game's expression for the read, over its own views, which the install closure runs."""
        if self.root == "entity":
            text = "Entity(handle: ent.handle)." + ".".join("client!" if f == "client" else f for f in self.path)
        elif self.root == "entities" and self.at and self.path[0] == "client":
            # The game's client is NULL on an entity that holds no player, so the record at the index comes back optional.
            return f"g_entities[Int(entityNum)].client.map {{ $0.{'.'.join(self.path[1:])}[Int(index)] }}"
        elif self.root == "entities" and self.at:
            text = f"g_entities[Int(entityNum)].{'.'.join(self.path)}[Int(index)]"
        elif self.root == "entities":
            text = "g_entities[Int(entityNum)]." + ".".join("client!" if f == "client" else f for f in self.path)
        elif self.root == "level":
            text = "level." + ".".join(self.path)
        else:
            text = self.root.removeprefix("cvar:") + "." + ".".join(self.path)
        return f"{text} = value" if self.write else text


class Cursor:
    """One `char *` local that walks a named buffer, as the cursor sweep reads it.

    `kind` is `read` for a local no use writes through, which Swift holds as a `TextCursor`, and `write` for one a use does write
    through, which Swift holds as the byte offset of row 47. `buffer` is Raven's name for the buffer, and `is_global` says the
    buffer is a file-scope one, so a body reaches it under the module's own rules."""

    def __init__(self, kind: str, buffer: str, is_global: bool) -> None:
        self.kind = kind
        self.buffer = buffer
        self.is_global = is_global

    @property
    def write(self) -> bool:
        return self.kind == "write"


class Local:
    """One local of a function the local sweep gives a shape, so a reader takes the facts of that local in one lookup.

    `cursor` is the cursor sweep's row for a `char *` local that walks a named buffer, and None for a local of any other shape.
    `table` names a pointer local Raven walks over a table of records, `it = bg_itemlist + 1`, as the table's Swift name and the index local that stands for the pointer."""

    def __init__(self, cursor: Cursor | None = None, table: tuple[str, str] | None = None) -> None:
        self.cursor = cursor
        self.table = table


class LocalFacts:
    """Every fact about the locals of one function, as the local read of the table hands them over in one value.

    `rows` gives the shape of each local the sweep names, under Raven's own name.
    `written`, `single_writes`, and `addressed` hold the names the body writes, the names one write covers, and the names the body takes the address of."""

    def __init__(self, rows: dict[str, Local], written: set[str], single_writes: set[str], addressed: set[str]) -> None:
        self.rows = rows
        self.written = written
        self.single_writes = single_writes
        self.addressed = addressed


class Table:
    def __init__(self, parse: C.Parse, views: Generator | None = None, store: Path | None = None) -> None:
        self.parse = parse
        # The store file the sweep loads its facts from and writes them to.
        self.store_path = store if store is not None else STORE
        self.store: S.Store | None = None
        self.keys: S.Keys | None = None
        # The generations the last sweep computed again, because the store held no facts under their keys.
        self.swept: set[str] = set()
        self.views = views if views is not None else Generator(parse, None)
        # The one owner of the type question, which the view generator holds.
        self.types = self.views.types
        # The (function, parameter) pairs a bg body passes NULL or 0 to, so the wrapper takes the parameter as optional.
        # The ruled pairs of NULLABLE seed it, for a NULL the sweep cannot see.
        self.nullable: set[tuple[str, str]] = set(NULLABLE)
        # The pairs the NULL sweep reaches one hop on, through a local or a passed-on parameter, which the vector rules read.
        self.hopped: set[tuple[str, str]] = set()
        # The functions the NULL sweep saw a call to, so a parameter outside `nullable` is proven never NULL only for these.
        self.called: set[str] = set()
        # The (function, parameter) pairs whose body writes through the pointer, so the output keeps its `inout` spelling.
        self.stores_through: set[tuple[str, str]] = set()
        # The (function, parameter) pairs whose body tests the pointer for NULL with an arm that does more than skip a write through it.
        self.null_arms: set[tuple[str, str]] = set()
        # The functions whose bodies the store sweep walked, so a parameter outside `stores_through` is proven read-only only for these.
        self.store_swept: set[str] = set()
        # The (function, parameter) pairs whose body never writes through the `char *`, so the parameter is a String.
        self.readonly_text: set[tuple[str, str]] = set()
        # The functions that hand NULL back from a `char *` return, so the return is a String?.
        self.null_returns: set[str] = set()
        # The (function, parameter) pairs a body indexes, `animations[anim]`, so the parameter crosses as the Slots over the records.
        self.indexed_params: set[tuple[str, str]] = set()
        # The (struct, field) pairs a body indexes through the pointer, `pm->animations[anim]`, so the view gets the second accessor.
        self.indexed_fields: set[tuple[str, str]] = set()
        # Every call that hands a table of records to a parameter, as the callee, the parameter, and the table the caller held.
        self.handoffs: list[tuple[str, str, bool | tuple[str, str]]] = []
        # The `char *` locals that walk a named buffer, by file stem, function, and name, each as its kind and the buffer it walks.
        self.cursors: dict[tuple[str, str, str], Cursor] = {}
        # The file-scope buffers a write cursor points into, so the write sweep of the skeleton sees the write through the alias.
        self.alias_writes: set[str] = set()
        # The (trap, parameter) pairs a caller fills with a `char[N]` buffer through Raven's `void *`, so the wrapper gets a
        # second overload that takes the buffer itself.
        self.buffer_traps: set[tuple[str, str]] = set()
        # The (trap, parameter) pairs of a `const void *` a caller hands a `char *` text, so the wrapper gets an overload that takes the String.
        self.text_traps: set[tuple[str, str]] = set()
        # The game fields a bg body reaches, by the key of each read, which the channel carries and the draft calls.
        self.reads: dict[tuple[str, tuple[str, ...], bool], Read] = {}
        # The body of each function of the game unit, by file stem and name, which the cursor sweep fills so a local read reaches its body.
        self.functions: dict[tuple[str, str], ci.Cursor] = {}
        # Every local the local sweep gives a shape, by file stem, function, and name, the key the cursor sweep uses.
        self.locals: dict[tuple[str, str, str], Local] = {}
        # The names each body writes after their declaration, by file stem and function.
        self.written_names: dict[tuple[str, str], set[str]] = {}
        # The names one write outside a loop covers, or one write in each arm of one `if`, which Swift holds in a `let`.
        self.single_writes: dict[tuple[str, str], set[str]] = {}
        # The names a body takes the address of, each one an output a callee fills.
        self.addressed_names: dict[tuple[str, str], set[str]] = {}
        # The file-scope pointers a body sets to a file-scope table of records, `pushed_p = pushed`, each as the table's Swift name
        # and the file-scope index that stands for the pointer in every body that names it.
        self.file_walks: dict[str, tuple[str, str]] = {}
        # The (function, parameter) pairs of an `int *` the body hands on to an array a trap fills, so the parameter is that array.
        self.array_handoffs: set[tuple[str, str]] = set()

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
            by_number = not self.names_pm(cur)
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
                fields, root = self.chain(node, consumed, by_number)
                if root is None or self.own_field(root, fields):
                    continue
                at = False
                swift = self.types.scalar(node.type, TARGET)
                if swift is None and self.views.is_vec3(node.type):
                    swift = "JKAShared.vec3_t"
                elif swift is None and node.type.get_canonical().kind == TypeKind.POINTER \
                        and node.type.get_canonical().get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                    swift = "String?"
                elif swift is None and node.type.get_canonical().kind == TypeKind.CONSTANTARRAY:
                    # Raven reads one record of an array of records, `ent->client->saber[n]`, so the read takes that index too and
                    # hands back the view over the game's record. Such a read reaches the entity by Raven's own index, because the
                    # bg side holds no entity of its own for the record, and the game's client is NULL, so the view is optional.
                    record = self.types.record_name(node.type.get_canonical().get_array_element_type().get_canonical())
                    if not record or record not in self.views.views:
                        continue
                    if root == "entity" and self.entity_index(self.root_of(node)) is None:
                        continue
                    root = "entities"
                    swift = self.views.qualified_view(record, TARGET) + "?"
                    at = True
                elif swift is None:
                    # A record the views cover crosses as its view, `&client->pers.cmd` as the Usercmd over the game's memory.
                    record = self.types.record_name(node.type.get_canonical())
                    if not record or record not in self.views.views:
                        continue
                    swift = self.views.qualified_view(record, TARGET)
                write = span in writes
                key = (root, tuple(fields), write)
                if key not in reads:
                    reads[key] = Read(root, tuple(fields), swift, write, f"oracle/codemp/game/{path.stem}.c:{node.location.line}", at=at)
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

    @classmethod
    def entity_slot_index(cls, cur: ci.Cursor) -> ci.Cursor | None:
        """The index expression of `g_entities[n]`, the game's entity table at a slot, or None for any other expression."""
        if cur.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return None
        kids = list(cur.get_children())
        return kids[1] if len(kids) == 2 and cls.unwrapped(kids[0]).spelling == "g_entities" else None

    @classmethod
    def entity_index(cls, cur: ci.Cursor) -> ci.Cursor | None:
        """The index of `g_entities[n]` behind an expression: the slot itself, or a local Raven set to `&g_entities[n]`."""
        slot = cls.entity_slot_index(cur)
        if slot is not None:
            return slot
        if cur.kind != CursorKind.DECL_REF_EXPR or cur.referenced is None or cur.referenced.kind != CursorKind.VAR_DECL:
            return None
        init = [k for k in cur.referenced.get_children() if k.kind.is_expression()]
        if not init:
            return None
        address = cls.unwrapped(init[-1])
        if address.kind != CursorKind.UNARY_OPERATOR:
            return None
        operand = list(address.get_children())
        return cls.entity_index(cls.unwrapped(operand[0])) if len(operand) == 1 else None

    @staticmethod
    def names_pm(fn: ci.Cursor) -> bool:
        """True when the body names the file-scope `pm`, so a slot of `g_entities` there is the pmove's stride walk.
        Raven's `PM_BGEntForNum` asserts outside a pm function, so a body that never names `pm` reads the game by number."""
        return any(n.kind == CursorKind.DECL_REF_EXPR and n.spelling == "pm" for n in fn.walk_preorder())

    @classmethod
    def root_of(cls, node: ci.Cursor) -> ci.Cursor:
        """The expression a member chain stands on, `g_entities[n]` under `g_entities[n].s.legsAnim`."""
        while node.kind == CursorKind.MEMBER_REF_EXPR:
            node = cls.unwrapped(list(node.get_children())[0])
        return node

    def chain(self, node: ci.Cursor, consumed: set[tuple[int, int]], by_number: bool = False) -> tuple[list[str], str | None]:
        """The field path of a member chain, outermost last, and the kind of its root: an entity, the level, a cvar, or None.

        A slot of the file-scope `g_entities` is the `entities` root, the second root of the read sweep, and its callback
        takes Raven's index. Any other entity expression is the `entity` root, whose callback takes the bg entity itself.
        With `by_number`, the body never names `pm`, so a local Raven set to `&g_entities[n]` is the `entities` root too."""
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
        record = self.types.record_name(t)
        if record == "gentity_t":
            slot = self.entity_slot_index(cur) if not by_number else self.entity_index(cur)
            return fields, "entities" if slot is not None else "entity"
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
        No ui parse exists, so a ui call site is outside the proof, and a function only ui reaches is a known gap."""
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

    def sweep_null_hops(self, tu: ci.TranslationUnit, *folders: Path) -> None:
        """The NULL sweep one hop on: a callee's parameter that takes a local the caller sets to NULL, or a parameter of the caller
        the sweep already marked nullable. The passed-on edges close to a fixed point, so NULL follows a parameter down a chain of calls."""
        edges: list[tuple[tuple[str, str], tuple[str, str]]] = []
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent not in folders or path.suffix != ".c":
                continue
            data = C.parsed_bytes(path)
            null_locals: set[str] = set()
            for node in cur.walk_preorder():
                if node.kind == CursorKind.VAR_DECL and self.takes_null(node.type):
                    kids = [k for k in node.get_children() if k.kind.is_expression()]
                    if kids and data[kids[-1].extent.start.offset:kids[-1].extent.end.offset].decode("utf-8", "replace").strip() in ("NULL", "0"):
                        null_locals.add(node.spelling)
                if node.kind == CursorKind.BINARY_OPERATOR:
                    kids = list(node.get_children())
                    if len(kids) == 2 and self.unwrapped(kids[0]).kind == CursorKind.DECL_REF_EXPR \
                            and data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip() == "=" \
                            and data[kids[1].extent.start.offset:kids[1].extent.end.offset].decode("utf-8", "replace").strip() in ("NULL", "0") \
                            and self.takes_null(kids[0].type):
                        null_locals.add(self.unwrapped(kids[0]).spelling)
            for node in cur.walk_preorder():
                if node.kind != CursorKind.CALL_EXPR or node.referenced is None or node.referenced.kind != CursorKind.FUNCTION_DECL:
                    continue
                params = list(node.referenced.get_arguments())
                callee = node.referenced.spelling
                for i, arg in enumerate(list(node.get_children())[1:]):
                    inner = self.unwrapped(arg)
                    if inner.kind != CursorKind.DECL_REF_EXPR or i >= len(params) or not self.takes_null(params[i].type) or inner.referenced is None:
                        continue
                    pair = (callee, params[i].spelling)
                    if inner.referenced.kind == CursorKind.VAR_DECL and inner.spelling in null_locals:
                        self.hopped.add(pair)
                    elif inner.referenced.kind == CursorKind.PARM_DECL:
                        edges.append(((cur.spelling, inner.spelling), pair))
        changed = True
        while changed:
            changed = False
            for source, target in edges:
                if (source in self.nullable or source in self.hopped) and target not in self.nullable and target not in self.hopped:
                    self.hopped.add(target)
                    changed = True

    @staticmethod
    def takes_null(t: ci.Type) -> bool:
        """True for a parameter type NULL fits: a pointer, and an array too, because C decays an array parameter to a pointer."""
        return t.get_canonical().kind in (TypeKind.POINTER, TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY)

    def sweep_stores(self, tu: ci.TranslationUnit, folder: Path) -> None:
        """Every pointer parameter a body of the folder writes through, `*p = x` or `p[i] = x`, by the function's name.
        A vector parameter handed to a vector macro's written position is written too, and one handed to a callee's non-const vector
        parameter is written when the callee writes its own parameter, which the sweep closes to a fixed point over the folder.
        A callee outside the folder writes every non-const vector it takes, because no proof of it exists.

        The table reads it beside `nullable`: a scalar output the body always writes keeps the `inout` spelling, and the caller's NULL
        takes a scratch local at the call site instead. A parameter the body only reads has no such seat, so a NULL there stays optional."""
        edges: list[tuple[tuple[str, str], tuple[str, str]]] = []
        defined: set[str] = set()
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or path.suffix != ".c":
                continue
            defined.add(cur.spelling)
            for p in cur.get_arguments():
                spelled = p.type.spelling
                held = PARAMS.get((cur.spelling, p.spelling)) == "vec3_mut"
                reached = (cur.spelling, p.spelling) in self.nullable or (cur.spelling, p.spelling) in self.hopped
                bg_hand = path.stem.startswith("bg_") and self.adopted(path.stem)
                if held or ("const" not in spelled and spelled.split()[-1] in ("vec3_t", "vec4_t") and not reached and bg_hand):
                    # A PARAMS hold and an adopted bg stub take the vector inout, so the vector counts as written,
                    # and a caller's own vector stays inout too.
                    # An adopted game stub keeps the drafter's signature, which takes a vector the body never writes by value.
                    # A vector a caller passes NULL to is an optional value in the adopted stub, and the NULL rule keeps it.
                    self.stores_through.add((cur.spelling, p.spelling))
            data = C.parsed_bytes(path)
            names = {p.spelling for p in cur.get_arguments()}
            if not names:
                continue
            for node in cur.walk_preorder():
                if node.kind == CursorKind.CALL_EXPR and node.referenced is not None and node.referenced.kind == CursorKind.FUNCTION_DECL:
                    callee = node.referenced.spelling
                    params = list(node.referenced.get_arguments())
                    for i, arg in enumerate(list(node.get_children())[1:]):
                        root = self.argument_root(self.unwrapped(arg))
                        if root is None or root not in names:
                            continue
                        if callee in MACROS:
                            if i in written_arguments(callee):
                                self.stores_through.add((cur.spelling, root))
                        elif i < len(params):
                            spelled = params[i].type.spelling
                            if "const" not in spelled and ("vec3_t" in spelled or "vec4_t" in spelled):
                                edges.append(((cur.spelling, root), (callee, params[i].spelling)))
                    continue
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
        changed = True
        while changed:
            changed = False
            for source, target in edges:
                if source in self.stores_through:
                    continue
                if target[0] not in defined or target in self.stores_through:
                    self.stores_through.add(source)
                    changed = True
        self.store_swept = defined

    def sweep_null_arms(self, tu: ci.TranslationUnit, folder: Path) -> None:
        """Every pointer parameter whose body tests it for NULL with an arm that does more than skip a write through it.
        `if (forward) { forward[0] = x; }` of AngleVectors only skips the write, so a caller's NULL takes a scratch local.
        `if (!dir)` of G_Damage changes what the body does, so the parameter keeps Raven's NULL and crosses as an optional."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or path.suffix != ".c":
                continue
            names = {p.spelling for p in cur.get_arguments() if self.takes_null(p.type)}
            if not names:
                continue
            data = C.parsed_bytes(path)
            for node, chain in self.text_uses(cur, names):
                pair = (cur.spelling, node.spelling)
                if pair in self.null_arms:
                    continue
                test = self.null_test(node, chain, data)
                if isinstance(test, str):
                    self.null_arms.add(pair)
                elif test is not None and not self.skips_write(test, node.spelling, data):
                    self.null_arms.add(pair)

    def null_test(self, node: ci.Cursor, chain: list[ci.Cursor], data: bytes) -> ci.Cursor | str | None:
        """The `if` statement of a test `if (p)` or `if (p != NULL)` with no else, "arm" for any other NULL test of the parameter,
        or None for a use that tests nothing."""
        inner = node
        depth = 0
        while depth < len(chain) and chain[depth].kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            inner = chain[depth]
            depth += 1
        if depth >= len(chain):
            return None
        parent = chain[depth]
        kids = list(parent.get_children())
        test = None
        if parent.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2:
            op = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
            other = kids[1] if self.same_extent(kids[0], inner) else kids[0]
            text = data[other.extent.start.offset:other.extent.end.offset].decode("utf-8", "replace").strip()
            if op in ("==", "!=") and text in ("NULL", "0"):
                if op == "==":
                    return "arm"
                test = parent
            elif op in ("&&", "||"):
                return "arm"
            else:
                return None
        elif parent.kind == CursorKind.UNARY_OPERATOR and data[parent.extent.start.offset:parent.extent.start.offset + 1] == b"!":
            return "arm"
        elif parent.kind == CursorKind.CONDITIONAL_OPERATOR and kids and self.same_extent(kids[0], inner):
            return "arm"
        elif parent.kind in (CursorKind.IF_STMT, CursorKind.WHILE_STMT, CursorKind.DO_STMT) and kids and self.same_extent(kids[0], inner):
            return parent if parent.kind == CursorKind.IF_STMT else "arm"
        else:
            return None
        # Raven's `p != NULL` stands as the whole test of an `if`.
        rest = chain[depth + 1:]
        d = 0
        while d < len(rest) and rest[d].kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            d += 1
        if d < len(rest) and rest[d].kind == CursorKind.IF_STMT and self.same_extent(list(rest[d].get_children())[0], rest[d - 1] if d else test):
            return rest[d]
        return "arm"

    def skips_write(self, statement: ci.Cursor, name: str, data: bytes) -> bool:
        """True when an `if` with no else writes only through the parameter in its arm, so its NULL skips that write and nothing else."""
        kids = list(statement.get_children())
        if len(kids) != 2:
            return False
        body = kids[1]
        lines = list(body.get_children()) if body.kind == CursorKind.COMPOUND_STMT else [body]
        for line in lines:
            line = self.unwrapped(line)
            parts = list(line.get_children())
            if line.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) and len(parts) == 2 \
                    and data[parts[0].extent.end.offset:parts[1].extent.start.offset].decode("utf-8", "replace").strip() in ASSIGN_OPS \
                    and self.argument_root(self.unwrapped(parts[0])) == name:
                continue
            if line.kind == CursorKind.CALL_EXPR and line.referenced is not None and line.referenced.kind == CursorKind.FUNCTION_DECL:
                callee = line.referenced.spelling
                args = parts[1:]
                if callee in MACROS:
                    written = written_arguments(callee)
                else:
                    params = list(line.referenced.get_arguments())
                    written = {i for i, p in enumerate(params) if p.type.get_canonical().kind in (TypeKind.POINTER, TypeKind.CONSTANTARRAY)
                               and not p.type.get_canonical().get_pointee().is_const_qualified() and "const" not in p.type.spelling}
                if written and all(i < len(args) and self.argument_root(self.unwrapped(args[i])) == name for i in written):
                    continue
            return False
        return True

    @staticmethod
    @functools.cache
    def adopted(stem: str) -> bool:
        """True when the stub of a Raven .c file is adopted, so its hand signature stands and the skeleton writes it no more."""
        from skeleton import NOTE, stub_path
        out = stub_path(stem)
        return out.exists() and out.read_text().split("\n", 1)[0] != NOTE.format(stem=stem)

    def argument_root(self, cur: ci.Cursor) -> str | None:
        """The name at the root of a call argument, `axis` for `axis`, `axis[0]`, and `&axis[0]`, or None for any other argument."""
        node = cur
        while True:
            if node.kind == CursorKind.UNARY_OPERATOR:
                kids = list(node.get_children())
                if len(kids) != 1:
                    return None
                node = self.unwrapped(kids[0])
            elif node.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
                node = self.unwrapped(list(node.get_children())[0])
            elif node.kind == CursorKind.DECL_REF_EXPR:
                return node.spelling
            else:
                return None

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
        A NULL one hop on counts too: a local the caller sets to NULL, or a parameter of the caller that NULL reaches, passed on.

        A function no call reached is unknown, because the port has read no caller of it yet, and unknown is not a proof."""
        return owner is not None and owner in self.called and (owner, name) not in self.nullable and (owner, name) not in self.hopped

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

    def text_use(self, node: ci.Cursor, chain: list[ci.Cursor], data: bytes) -> tuple[str, object]:
        """One use of a `char *` parameter as the sweep reads it: "read", "pass" with the callee and the position,
        "local" with the pointer local the use sets, or "unknown"."""
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
        if parent.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and kids and self.same_extent(kids[0], inner):
            # Raven's `saberName[0]` reads one byte, and the read is a read where nothing stores into it or takes its address.
            return ("read", None) if self.value_use(chain[depth + 1:], parent, data) else ("unknown", None)
        if parent.kind == CursorKind.UNARY_OPERATOR and data[parent.extent.start.offset:parent.extent.start.offset + 1] == b"*":
            return ("read", None) if self.value_use(chain[depth + 1:], parent, data) else ("unknown", None)
        if parent.kind == CursorKind.VAR_DECL and parent.semantic_parent is not None \
                and parent.semantic_parent.kind != CursorKind.TRANSLATION_UNIT and self.char_pointer(parent.type):
            # Raven's `char *p = from;` hands the bytes to a local, which the sweep reads in turn.
            return ("local", parent)
        if parent.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2 and self.same_extent(kids[1], inner) \
                and data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip() == "=":
            target = self.unwrapped(kids[0])
            ref = target.referenced if target.kind == CursorKind.DECL_REF_EXPR else None
            if ref is not None and ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None \
                    and ref.semantic_parent.kind != CursorKind.TRANSLATION_UNIT and self.char_pointer(ref.type):
                return ("local", ref)
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
    def value_use(rest: list[ci.Cursor], expr: ci.Cursor, data: bytes) -> bool:
        """True when a byte read, `p[i]` or `*p`, is a value: no store writes into it, no `&` takes its address, and no `++` steps it."""
        inner = expr
        depth = 0
        while depth < len(rest) and rest[depth].kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            inner = rest[depth]
            depth += 1
        if depth >= len(rest):
            return True
        outer = rest[depth]
        kids = list(outer.get_children())
        if outer.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) and len(kids) == 2 \
                and Table.same_extent(kids[0], inner):
            return data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip() not in ASSIGN_OPS
        if outer.kind == CursorKind.UNARY_OPERATOR:
            text = data[outer.extent.start.offset:outer.extent.end.offset].decode("utf-8", "replace").strip()
            return not (text.startswith(("&", "++", "--")) or text.endswith(("++", "--")))
        return True

    def local_reads(self, fn: ci.Cursor, local: ci.Cursor, data: bytes, seen: set[int]) -> list[tuple[str, object]] | None:
        """The uses of a pointer local set from the parameter, each as the sweep reads it, or None when one use is not a read.
        A step of the local and a store into the local itself move the pointer and write no byte, so both read."""
        key = local.extent.start.offset
        if key in seen:
            return []
        seen.add(key)
        out: list[tuple[str, object]] = []
        stack: list[tuple[ci.Cursor, list[ci.Cursor]]] = [(fn, [])]
        while stack:
            node, chain = stack.pop()
            for kid in node.get_children():
                stack.append((kid, [node] + chain))
            ref = node.referenced if node.kind == CursorKind.DECL_REF_EXPR else None
            if ref is None or ref.kind != CursorKind.VAR_DECL or ref.extent.start.offset != key or ref.spelling != local.spelling:
                continue
            inner = node
            depth = 0
            while depth < len(chain) and chain[depth].kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
                inner = chain[depth]
                depth += 1
            parent = chain[depth] if depth < len(chain) else None
            kids = list(parent.get_children()) if parent is not None else []
            if parent is not None and parent.kind == CursorKind.UNARY_OPERATOR:
                text = data[parent.extent.start.offset:parent.extent.end.offset].decode("utf-8", "replace").strip()
                if text.startswith(("++", "--")) or text.endswith(("++", "--")):
                    # A step moves the local, and a byte read through the step, `*p++`, reads where no store writes into it.
                    deref = self.deref_parent(chain[depth + 1:], data)
                    if deref is None or self.value_use(chain[depth + 1:][deref + 1:], chain[depth + 1:][deref], data):
                        continue
                    return None
            if parent is not None and parent.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) \
                    and len(kids) == 2 and self.same_extent(kids[0], inner) \
                    and data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip() in ASSIGN_OPS:
                continue
            use = self.text_use(node, chain, data)
            if use[0] == "local":
                deeper = self.local_reads(fn, use[1], data, seen)
                if deeper is None:
                    return None
                out += deeper
                continue
            if use[0] == "unknown":
                return None
            out.append(use)
        return out

    @staticmethod
    def deref_parent(rest: list[ci.Cursor], data: bytes) -> int | None:
        """The place in `rest` of a dereference above a step, `*p++`, whose value is a byte read or a byte write, or None."""
        depth = 0
        while depth < len(rest) and rest[depth].kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            depth += 1
        if depth >= len(rest):
            return None
        outer = rest[depth]
        if outer.kind == CursorKind.UNARY_OPERATOR and data[outer.extent.start.offset:outer.extent.start.offset + 1] == b"*":
            return depth
        return None

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
            uses: dict[str, list[tuple[str, object]]] = {name: [] for name in targets}
            for node, chain in self.text_uses(cur, targets):
                use = self.text_use(node, chain, data)
                if use[0] == "local":
                    # The pointer local reads in turn, and one use of it that is not a read keeps the parameter a CharBuf.
                    reads = self.local_reads(cur, use[1], data, set())
                    uses[node.spelling] += reads if reads is not None else [("unknown", None)]
                    continue
                uses[node.spelling].append(use)
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

    # MARK: - The cursor sweep

    def sweep_cursors(self, tu: ci.TranslationUnit, folder: Path) -> None:
        """Every `char *` local that walks a named buffer, with the kind that picks its Swift shape.

        A read cursor is the `TextCursor` over the buffer, because no use of the local writes bytes through it.
        A write cursor is the byte offset of row 47, because a `TextCursor` holds a copy-on-write value and a write through it
        would never reach Raven's own buffer.
        Every store into the local must be the buffer or the buffer plus an offset. A local with a store of any other shape has
        no row here, and the draft keeps the hole it carries today.
        The sweep also names the file-scope buffers a write cursor points into, which is Raven's write through an alias.
        It holds the body of every function it walks, which the local read of one function walks again on its first read."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent != folder or path.suffix != ".c":
                continue
            self.functions[(path.stem, cur.spelling)] = cur
            data = C.parsed_bytes(path)
            buffers = self.cursor_buffers(cur, data)
            if not buffers:
                continue
            written = self.cursor_writes(cur, data, set(buffers))
            for name, (buffer, is_global) in buffers.items():
                kind = "write" if name in written else "read"
                self.cursors[(path.stem, cur.spelling, name)] = Cursor(kind, buffer, is_global)
                if kind == "write" and is_global:
                    self.alias_writes.add(buffer)

    def cursor_buffers(self, fn: ci.Cursor, data: bytes) -> dict[str, tuple[str, bool]]:
        """The named buffer each `char *` local of the body walks, by the stores into it, with True for a file-scope buffer.

        A local with no store of a buffer has no entry, and neither has one Raven points at two buffers or at anything else."""
        stores: dict[str, list[tuple[str, bool] | None]] = {}
        for node in fn.walk_preorder():
            if node.kind == CursorKind.VAR_DECL:
                if not self.char_pointer(node.type):
                    continue
                init = [k for k in node.get_children() if k.kind.is_expression()
                        and b"=" in data[node.extent.start.offset:k.extent.start.offset]]
                stores.setdefault(node.spelling, [])
                if init:
                    stores[node.spelling].append(self.cursor_store(init[0], data))
                continue
            if node.kind not in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
                continue
            kids = list(node.get_children())
            if len(kids) != 2:
                continue
            between = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
            if between != "=":
                continue
            left = self.unwrapped(kids[0])
            if left.kind != CursorKind.DECL_REF_EXPR or left.referenced is None or left.referenced.kind != CursorKind.VAR_DECL:
                continue
            if not self.char_pointer(left.type):
                continue
            stores.setdefault(left.spelling, []).append(self.cursor_store(kids[1], data))
        out: dict[str, tuple[str, bool]] = {}
        for name, seen in stores.items():
            if not seen or any(s is None for s in seen):
                continue
            named = {s for s in seen if s != "null"}
            if len(named) != 1:
                continue
            out[name] = next(iter(named))
        return out

    def cursor_store(self, cur: ci.Cursor, data: bytes) -> tuple[str, bool] | str | None:
        """The buffer a store points a `char *` local at, as Raven's name and whether it is file-scope.

        The three shapes are `p = buf`, `p = buf + offset`, and Raven's NULL, which names no buffer of its own.
        Any other store gives None, and the local then has no cursor row."""
        inner = self.unwrapped(cur)
        if data[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace").strip() in ("NULL", "0"):
            return "null"
        if inner.kind == CursorKind.BINARY_OPERATOR:
            kids = list(inner.get_children())
            if len(kids) != 2:
                return None
            between = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
            if between != "+":
                return None
            inner = self.unwrapped(kids[0])
        if inner.kind != CursorKind.DECL_REF_EXPR or inner.referenced is None:
            return None
        ref = inner.referenced
        t = ref.type.get_canonical()
        if ref.kind != CursorKind.VAR_DECL or t.kind != TypeKind.CONSTANTARRAY \
                or t.element_type.get_canonical().kind != TypeKind.CHAR_S:
            return None
        # A local buffer has no linkage, and Raven's file-scope buffer has internal or external linkage under his `static`.
        return (inner.spelling, ref.linkage != ci.LinkageKind.NO_LINKAGE)

    def cursor_writes(self, fn: ci.Cursor, data: bytes, names: set[str]) -> set[str]:
        """The named locals the body writes bytes through: a store at the pointer, and a pass to a parameter the callee writes.

        A step, `p++` and `p += n`, moves the pointer and writes nothing. A pass to a `const char *` parameter, to a variadic
        argument, and to a parameter the text sweep proved read-only is a read. Any other pass is a write, which is the default
        of rule 11, and a callee the parse cannot name is a write too."""
        out: set[str] = set()
        for node in fn.walk_preorder():
            if node.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
                kids = list(node.get_children())
                if len(kids) != 2:
                    continue
                between = data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip()
                if between not in ASSIGN_OPS:
                    continue
                target = self.local_store_target(self.unwrapped(kids[0]))
                if target in names:
                    out.add(target)
            elif node.kind == CursorKind.CALL_EXPR:
                out |= self.written_arguments(node, names)
        return out

    def local_store_target(self, cur: ci.Cursor) -> str | None:
        """The local name a store writes bytes through, for `*p` and for `p[i]`, or None for any other left side."""
        if cur.kind == CursorKind.UNARY_OPERATOR:
            kids = list(cur.get_children())
            inner = self.unwrapped(kids[0]) if kids else None
        elif cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            inner = self.unwrapped(list(cur.get_children())[0])
        else:
            return None
        if inner is None or inner.kind != CursorKind.DECL_REF_EXPR or inner.referenced is None:
            return None
        return inner.spelling if inner.referenced.kind == CursorKind.VAR_DECL else None

    def written_arguments(self, call: ci.Cursor, names: set[str]) -> set[str]:
        """The named locals one call writes bytes through, by the callee's own parameter at each position."""
        kids = list(call.get_children())
        if not kids:
            return set()
        callee = self.unwrapped(kids[0])
        passed = {i: self.unwrapped(a).spelling for i, a in enumerate(kids[1:])
                  if self.unwrapped(a).kind == CursorKind.DECL_REF_EXPR and self.unwrapped(a).spelling in names}
        if not passed:
            return set()
        decl = callee.referenced if callee.kind == CursorKind.DECL_REF_EXPR else None
        if decl is None or decl.kind != CursorKind.FUNCTION_DECL:
            # The parse cannot name the callee, so every pass may write, which is the default of rule 11.
            return set(passed.values())
        params = list(decl.get_arguments())
        out: set[str] = set()
        for i, name in passed.items():
            if i >= len(params):
                # A variadic argument is the text a format reads.
                continue
            t = params[i].type.get_canonical()
            if t.kind != TypeKind.POINTER or t.get_pointee().is_const_qualified():
                continue
            if (decl.spelling, params[i].spelling) in self.readonly_text:
                continue
            out.add(name)
        return out

    @staticmethod
    def char_pointer(t: ci.Type) -> bool:
        """True for Raven's `char *`, with or without his `const`."""
        canonical = t.get_canonical()
        return canonical.kind == TypeKind.POINTER and canonical.get_pointee().get_canonical().kind == TypeKind.CHAR_S

    # MARK: - The local sweep

    def locals_of(self, stem: str, function: str) -> LocalFacts:
        """The facts about the locals of one function, which a drafter reads instead of a walk of its own.

        The first read of a function computes them, and every later read takes them from the four stores of the table.
        A generator that reads no body pays nothing, and a drafter of one stem pays for the functions of that stem alone.
        A function outside the game unit has no body here, and its facts are empty."""
        key = (stem, function)
        if key not in self.written_names:
            loaded = self.store.load_locals(self.keys.adoption, stem, function) if self.store is not None else None
            if loaded is not None:
                for name, row in loaded.rows.items():
                    self.locals[(stem, function, name)] = row
                self.written_names[key] = loaded.written
                self.single_writes[key] = loaded.single_writes
                self.addressed_names[key] = loaded.addressed
            else:
                self.sweep_locals(key)
                if self.store is not None:
                    rows = {name: row for (owner_stem, owner, name), row in self.locals.items() if (owner_stem, owner) == key}
                    self.store.save_locals(self.keys.adoption, stem, function,
                                           LocalFacts(rows, self.written_names[key], self.single_writes[key], self.addressed_names[key]))
        rows = {name: row for (owner_stem, owner, name), row in self.locals.items() if (owner_stem, owner) == key}
        return LocalFacts(rows, self.written_names[key], self.single_writes[key], self.addressed_names[key])

    def sweep_locals(self, key: tuple[str, str]) -> None:
        """The one walk that fills the four stores of the table for one function, which the local read calls once per function.

        A `char *` local over a named buffer keeps the row the cursor sweep already wrote, so no walk reads those stores twice.
        A pointer local Raven sets to a file-scope table of records, or to a parameter spelled as a `Slots`, walks that table,
        and a reader of the fact walks it by index instead.
        The three name sets hold every name the body writes, every name one write covers, and every name the body takes the address of."""
        self.written_names[key] = set()
        self.addressed_names[key] = set()
        self.single_writes[key] = set()
        cur = self.functions.get(key)
        if cur is None:
            return
        data = C.parsed_bytes(Path(cur.location.file.name).resolve())
        rows = {name: Local(cursor=cursor) for (stem, owner, name), cursor in self.cursors.items() if (stem, owner) == key}
        walks, written, addressed = self.body_walk(cur, data)
        for name, walk in walks.items():
            rows.setdefault(name, Local()).table = walk
        # A file-scope walk pointer is a walk in every body that names it, and the file-scope index stands for it there.
        named = {node.spelling for node in cur.walk_preorder() if node.kind == CursorKind.DECL_REF_EXPR}
        for name, walk in self.file_walks.items():
            if name in named:
                rows.setdefault(name, Local()).table = walk
        for name, row in rows.items():
            self.locals[(key[0], key[1], name)] = row
        self.written_names[key] = written
        self.addressed_names[key] = addressed
        self.single_writes[key] = self.single_written(cur, data)

    @staticmethod
    def record_table(ref: ci.Cursor) -> bool:
        """True for a file-scope array of records, the table a pointer walk steps over."""
        return ref.kind == CursorKind.VAR_DECL and ref.type.get_canonical().kind == TypeKind.CONSTANTARRAY \
            and ref.type.get_canonical().element_type.get_canonical().kind == TypeKind.RECORD \
            and ref.semantic_parent is not None and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT

    def sweep_array_handoffs(self) -> None:
        """Every `int *` parameter a body passes as it is to a trap's array the engine fills, `trap_EntitiesInBox(mins, maxs, radiusEnts, 128)`.

        The cursor sweep fills the bodies first."""
        for (_, owner), fn in self.functions.items():
            for node in fn.walk_preorder():
                if node.kind != CursorKind.CALL_EXPR or not node.spelling.startswith("trap_") or node.referenced is None:
                    continue
                params = list(node.referenced.get_arguments())
                for i, arg in enumerate(list(node.get_children())[1:]):
                    arg = self.unwrapped(arg)
                    if i >= len(params) or arg.kind != CursorKind.DECL_REF_EXPR or arg.referenced is None \
                            or arg.referenced.kind != CursorKind.PARM_DECL:
                        continue
                    if engine_array(params[i].type, params[i + 1] if i + 1 < len(params) else None):
                        self.array_handoffs.add((owner, arg.spelling))

    def sweep_file_walks(self) -> None:
        """Every file-scope pointer a body sets to a file-scope table of records, `pushed_p = pushed`, or a slot past its start.

        The pointer has no local to hold its index, so the skeleton gives it a file-scope index, and every body that names the pointer reads that index.
        The cursor sweep fills the bodies first."""
        for fn in self.functions.values():
            data = None
            for cur in fn.walk_preorder():
                if cur.kind != CursorKind.BINARY_OPERATOR or collapsed(cur):
                    continue
                kids = list(cur.get_children())
                if len(kids) != 2:
                    continue
                left, right = self.unwrapped(kids[0]), self.unwrapped(kids[1])
                ref = left.referenced if left.kind == CursorKind.DECL_REF_EXPR else None
                if ref is None or ref.kind != CursorKind.VAR_DECL or ref.semantic_parent is None \
                        or ref.semantic_parent.kind != CursorKind.TRANSLATION_UNIT or ref.type.get_canonical().kind != TypeKind.POINTER:
                    continue
                if data is None:
                    data = C.parsed_bytes(Path(fn.location.file.name).resolve())
                if between(data, kids[0], kids[1]) != "=":
                    continue
                table = right
                if right.kind == CursorKind.BINARY_OPERATOR and len(list(right.get_children())) == 2 and not collapsed(right) \
                        and between(data, *list(right.get_children())) == "+":
                    table = self.unwrapped(list(right.get_children())[0])
                if table.kind == CursorKind.DECL_REF_EXPR and table.referenced is not None and self.record_table(table.referenced):
                    self.file_walks[left.spelling] = (swift_name(table.spelling), f"{swift_name(left.spelling)}Index")

    def body_walk(self, fn: ci.Cursor, data: bytes) -> tuple[dict[str, tuple[str, str]], set[str], set[str]]:
        """One walk of the body for the three facts each node carries: the table walks, the written names, and the addressed names.

        A table walk is a pointer local a statement sets to a file-scope table or a slot past its start, `it = bg_itemlist + 1`,
        given as the table's Swift name and the index local that stands in for the pointer.
        A record pointer parameter the body sets to a slot of such a table and steps, `from = g_entities` and `from++` of G_Find, walks the table too.
        A record pointer local the body sets only to slots of one table, `e = &g_entities[MAX_CLIENTS]`, and steps walks that table too.
        A written name is any name a statement writes after its declaration, and an addressed name is any name a statement takes the address of."""
        params = {p.spelling: p for p in fn.get_arguments()}
        out: dict[str, tuple[str, str]] = {}
        written: set[str] = set()
        addressed: set[str] = set()
        stepped: set[str] = set()
        parameter_walks: dict[str, tuple[str, str]] = {}
        slot_walks: dict[str, tuple[str, str]] = {}
        other_stores: set[str] = set()
        for cur in fn.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind == CursorKind.UNARY_OPERATOR and kids:
                if self.steps_or_addresses(cur, kids[0], data):
                    written.add(self.written_root(kids[0]))
                    stepped.add(self.written_root(kids[0]))
                if data[cur.extent.start.offset:kids[0].extent.start.offset].decode("utf-8", "replace").strip() == "&":
                    addressed.add(self.written_root(kids[0]))
                continue
            if cur.kind not in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) or len(kids) != 2:
                continue
            operator = between(data, kids[0], kids[1])
            if operator in ASSIGN_OPS or kids[0].extent.start.offset == kids[1].extent.start.offset:
                written.add(self.written_root(kids[0]))
            if operator in ("+=", "-="):
                stepped.add(self.written_root(kids[0]))
            if cur.kind != CursorKind.BINARY_OPERATOR or collapsed(cur) or operator != "=":
                continue
            left, right = self.unwrapped(kids[0]), self.unwrapped(kids[1])
            if left.kind == CursorKind.DECL_REF_EXPR and left.referenced is not None and left.referenced.kind == CursorKind.PARM_DECL \
                    and self.record_pointer(left.referenced.type):
                slot = self.table_slot(right, data)
                if slot is not None:
                    parameter_walks[left.spelling] = (slot, f"{swift_name(left.spelling)}Index")
                continue
            if left.kind != CursorKind.DECL_REF_EXPR or left.referenced is None or left.referenced.kind != CursorKind.VAR_DECL:
                continue
            if self.record_pointer(left.referenced.type) and left.referenced.semantic_parent is not None \
                    and left.referenced.semantic_parent.kind != CursorKind.TRANSLATION_UNIT:
                slot = self.table_slot(right, data)
                if slot is not None and slot_walks.get(left.spelling, (slot,))[0] == slot:
                    slot_walks[left.spelling] = (slot, f"{swift_name(left.spelling)}Index")
                else:
                    other_stores.add(left.spelling)
            table = right
            if right.kind == CursorKind.BINARY_OPERATOR and len(list(right.get_children())) == 2 and not collapsed(right) \
                    and between(data, *list(right.get_children())) in ("+", "-"):
                table = self.unwrapped(list(right.get_children())[0])
            if table.kind != CursorKind.DECL_REF_EXPR or table.referenced is None:
                continue
            ref = table.referenced
            # A pointer set from another walk pointer, `p = pushed_p - 1`, walks the same table.
            walked = out.get(table.spelling) or self.file_walks.get(table.spelling)
            if ref.kind == CursorKind.VAR_DECL and walked is not None:
                out[left.spelling] = (walked[0], f"{swift_name(left.spelling)}Index")
            elif self.record_table(ref):
                out[left.spelling] = (swift_name(table.spelling), f"{swift_name(left.spelling)}Index")
            elif ref.kind == CursorKind.PARM_DECL and table.spelling in params and self.slots_parameter(fn, params[table.spelling]):
                # A table parameter is a Slots, and the walk reads it by index the same way.
                out[left.spelling] = (swift_name(table.spelling), f"{swift_name(left.spelling)}Index")
        # A parameter that is set to a slot and never stepped only names one record, `attacker = &g_entities[ENTITYNUM_WORLD]` of G_Damage.
        out |= {name: walk for name, walk in parameter_walks.items() if name in stepped}
        # A local that starts at a slot, `e = &g_entities[MAX_CLIENTS]`, and that the body steps walks the table from there.
        # Every store into it must point into the one table, and no statement takes its address.
        # A local the body never steps only names one record.
        out |= {name: walk for name, walk in slot_walks.items() if name in stepped and name not in addressed and name not in other_stores and name not in out}
        return out, written, addressed

    def table_slot(self, cur: ci.Cursor, data: bytes) -> str | None:
        """The Swift name of the file-scope table of records that Raven's `g_entities`, `g_entities + n`, or `&g_entities[n]` points into, or None."""
        cur = self.unwrapped(cur)
        if cur.kind == CursorKind.BINARY_OPERATOR and len(list(cur.get_children())) == 2 and not collapsed(cur) \
                and between(data, *list(cur.get_children())) in ("+", "-"):
            cur = self.unwrapped(list(cur.get_children())[0])
        elif cur.kind == CursorKind.UNARY_OPERATOR and data[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").lstrip().startswith("&"):
            slot = self.unwrapped(list(cur.get_children())[0])
            if slot.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
                return None
            cur = self.unwrapped(list(slot.get_children())[0])
        if cur.kind == CursorKind.DECL_REF_EXPR and cur.referenced is not None and self.record_table(cur.referenced):
            return swift_name(cur.spelling)
        return None

    def slots_parameter(self, fn: ci.Cursor, cur: ci.Cursor) -> bool:
        """True when the table spells this parameter as a `Slots` over a table of records. spelling.py owns the spelling and the test."""
        params = list(fn.get_arguments())
        position = [p.spelling for p in params].index(cur.spelling)
        following = params[position + 1] if position + 1 < len(params) else None
        param = self.param(cur, following, traps=False, owner=fn.spelling)
        return param is not None and self.types.is_slots(param.swift)

    def single_written(self, fn: ci.Cursor, data: bytes) -> set[str]:
        """The locals Swift can hold in a `let`: written once outside a loop, or once in each arm of one `if`, and never by `&`."""
        writes: dict[str, list[tuple[bool, tuple[ci.Cursor, int] | None]]] = {}

        def root(cur: ci.Cursor) -> str | None:
            cur = self.unwrapped(cur)
            if cur.kind == CursorKind.DECL_REF_EXPR:
                ref = cur.referenced
                return cur.spelling if ref is not None and ref.kind == CursorKind.VAR_DECL else None
            if cur.kind in (CursorKind.ARRAY_SUBSCRIPT_EXPR, CursorKind.MEMBER_REF_EXPR):
                kids = list(cur.get_children())
                return root(kids[0]) if kids and cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR else None
            return None

        def walk(cur: ci.Cursor, in_loop: bool, arm: tuple[ci.Cursor, int] | None) -> None:
            kids = list(cur.get_children())
            if cur.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) and len(kids) == 2:
                if between(data, kids[0], kids[1]) in ASSIGN_OPS or kids[0].extent.start.offset == kids[1].extent.start.offset:
                    name = root(kids[0])
                    if name is not None:
                        writes.setdefault(name, []).append((in_loop, arm))
            if cur.kind == CursorKind.UNARY_OPERATOR and kids:
                name = root(kids[0])
                if name is not None and self.steps_or_addresses(cur, kids[0], data):
                    writes.setdefault(name, []).append((True, None))
            if cur.kind == CursorKind.IF_STMT and len(kids) == 3:
                walk(kids[0], in_loop, arm)
                walk(kids[1], in_loop, (cur, 1))
                walk(kids[2], in_loop, (cur, 2))
                return
            for k in kids:
                walk(k, in_loop or cur.kind in LOOPS, arm)

        walk(fn, False, None)
        out = set()
        for name, sites in writes.items():
            if len(sites) == 1 and not sites[0][0]:
                out.add(name)
            if len(sites) == 2 and not sites[0][0] and not sites[1][0] and sites[0][1] is not None and sites[1][1] is not None \
                    and sites[0][1][0] == sites[1][1][0] and sites[0][1][1] != sites[1][1][1]:
                out.add(name)
        return out

    @staticmethod
    def steps_or_addresses(cur: ci.Cursor, operand: ci.Cursor, data: bytes) -> bool:
        """True for Raven's `++`, his `--`, and his `&` on the operand, the three unary forms that write the name or hand it over."""
        before = data[cur.extent.start.offset:operand.extent.start.offset].decode("utf-8", "replace").strip()
        after = data[operand.extent.end.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()
        return before in ("++", "--", "&") or after in ("++", "--")

    def written_root(self, cur: ci.Cursor) -> str:
        """The name a store writes into, through any number of index steps, and the empty name for a left side that is no name."""
        cur = self.unwrapped(cur)
        while cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            cur = self.unwrapped(list(cur.get_children())[0])
        return cur.spelling if cur.kind == CursorKind.DECL_REF_EXPR else ""

    # MARK: - The subscript sweep

    def record_pointer(self, t: ci.Type) -> bool:
        """True for a pointer to a struct a view covers, which is the shape a `Slots` stands over."""
        canonical = t.get_canonical()
        if canonical.kind != TypeKind.POINTER:
            return False
        record = self.types.record_name(canonical.get_pointee())
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

    def sweep_handoffs(self, tu: ci.TranslationUnit, *folders: Path) -> None:
        """The hand-off sweep of the Slots ruling: every call that hands a table of records to a parameter of the callee.

        A caller holds a table in three shapes: a field with the Slots accessor, a file-scope array of records, and a parameter the subscript sweep read.
        The callee of such a call takes the Slots over the same records, and a one-record read of that parameter in the callee spells `[0]`.
        The sweep keeps the parameter shape as an edge, because the caller's own parameter can become a table in a later pass.
        It reads the game unit and the cgame unit, the two units the port parses, the same way the NULL sweep does.
        A hand-off of any other shape leaves the parameter with the one-record spelling it has today."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent not in folders or path.suffix != ".c":
                continue
            for node in cur.walk_preorder():
                if node.kind != CursorKind.CALL_EXPR or node.referenced is None or node.referenced.kind != CursorKind.FUNCTION_DECL:
                    continue
                # The parameter names come from the definition, because a prototype of the header can name the same parameter differently.
                callee = node.referenced.get_definition() or node.referenced
                params = list(callee.get_arguments())
                for i, arg in enumerate(list(node.get_children())[1:]):
                    if i >= len(params) or not self.record_pointer(params[i].type):
                        continue
                    table = self.table_argument(self.unwrapped(arg), cur.spelling)
                    if table is not None:
                        self.handoffs.append((node.referenced.spelling, params[i].spelling, table))

    def table_argument(self, arg: ci.Cursor, caller: str) -> bool | tuple[str, str] | None:
        """The table one call argument holds: True for a table of its own, the caller's (function, parameter) pair for a parameter,
        and None for every other argument."""
        if arg.kind == CursorKind.MEMBER_REF_EXPR and arg.referenced is not None and self.indexed_field(arg.referenced):
            return True
        if arg.kind != CursorKind.DECL_REF_EXPR or arg.referenced is None:
            return None
        ref = arg.referenced
        if ref.kind == CursorKind.PARM_DECL:
            return (caller, arg.spelling)
        if ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None \
                and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT \
                and ref.type.get_canonical().kind == TypeKind.CONSTANTARRAY \
                and ref.type.get_canonical().element_type.get_canonical().kind == TypeKind.RECORD:
            return True
        return None

    def resolve_handoffs(self) -> None:
        """The hand-off edges as the parameters that take the Slots, read again until the set does not grow.
        A parameter that takes a table hands the same table on, so one pass over the edges is not enough."""
        while True:
            grew = False
            for callee, param, table in self.handoffs:
                if (callee, param) in self.indexed_params:
                    continue
                if table is True or table in self.indexed_params:
                    self.indexed_params.add((callee, param))
                    grew = True
            if not grew:
                return

    def record_name_of(self, owner: ci.Cursor) -> str:
        """The name a NEVER_NULL row and an indexed field row key on: Raven's typedef name, or the tag where he gave none."""
        return self.types.record_name(owner.type) or owner.spelling

    def indexed_field(self, field: ci.Cursor) -> bool:
        """True when the subscript sweep read a body that indexes this field through its pointer."""
        if field is None or field.semantic_parent is None:
            return False
        return (self.record_name_of(field.semantic_parent), field.spelling) in self.indexed_fields

    # MARK: - The buffer sweep

    def sweep_buffer_traps(self, tu: ci.TranslationUnit, *folders: Path) -> None:
        """The call-site sweep of docket row 7: every trap parameter Raven declared `void *` that a caller fills with a `char[N]` buffer.

        The wrapper keeps its `OpaquePointer?` parameter, because a raw caller passes a raw allocation there. It gains a second
        overload that takes the buffer, so a body writes `trap_FS_Read(&BGPAFtext, len, f)` and no `Unsafe` type reaches a logic target.
        The sweep reads the game unit and the cgame unit, the two units the port parses, because one bg body stands in both with
        a different arm. A parameter no caller fills that way keeps the one spelling it has today.
        A `const void *` parameter a caller hands a `char *` text, `trap_FS_Write(str, strlen(str), fh)`, gets an overload that takes the String."""
        for cur in tu.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent not in folders or path.suffix != ".c":
                continue
            for node in cur.walk_preorder():
                if node.kind != CursorKind.CALL_EXPR:
                    continue
                callee = node.referenced
                if callee is None or not callee.spelling.startswith("trap_"):
                    continue
                params = list(callee.get_arguments())
                for i, arg in enumerate(node.get_arguments()):
                    if i >= len(params):
                        break
                    declared = params[i].type.get_canonical()
                    if declared.kind != TypeKind.POINTER or declared.get_pointee().get_canonical().kind != TypeKind.VOID:
                        continue
                    if self.char_buffer_argument(arg):
                        self.buffer_traps.add((callee.spelling, params[i].spelling))
                    elif declared.get_pointee().is_const_qualified() and self.char_pointer(self.unwrapped(arg).type):
                        self.text_traps.add((callee.spelling, params[i].spelling))

    def char_buffer_argument(self, cur: ci.Cursor) -> bool:
        """True for Raven's `char buf[N]` passed bare, the argument Swift holds as a `CharBuf`."""
        element = self.unwrapped(cur).type.get_canonical()
        if element.kind != TypeKind.CONSTANTARRAY:
            return False
        return element.element_type.get_canonical().kind in (TypeKind.CHAR_S, TypeKind.UCHAR, TypeKind.CHAR_U, TypeKind.SCHAR)

    def fills_buffer(self, owner: str, name: str) -> bool:
        """True when the buffer sweep saw a `char[N]` buffer go into this `void *` trap parameter."""
        return (owner, name) in self.buffer_traps

    def reads_text(self, owner: str, name: str) -> bool:
        """True when the buffer sweep saw a `char *` text go into this `const void *` trap parameter."""
        return (owner, name) in self.text_traps

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

    def sweep(self) -> None:
        """Every sweep a signature of the module needs, in the order the table reads them, over the one parse of the run.

        The NULL sweep walks every .c file of the game folder, because a proof that a parameter is never NULL needs every caller the port parses.
        It walks the cgame unit over both folders, so a call on Raven's cgame arm of a bg file counts,
        and so does a call from the cgame's own .c files.
        The store sweep, the text sweep, and the return sweep walk every .c file of the game folder, because the body of the callee decides all three.
        The cursor sweep follows the text sweep, because a local's kind reads which callee writes through its own `char *` parameter.
        The file walk sweep and the array sweep follow the cursor sweep, because they read the bodies the cursor sweep leaves behind.
        The local facts are not swept here. The cursor sweep leaves the body of every function behind, and the first read of a function computes its locals from that body.
        The subscript sweep and the buffer sweep walk both units the same way the NULL sweep does, because a body has one arm in each of them.
        The hand-off sweep follows the subscript sweep over both units, and its edges are read once both units are in.
        A caller of one unit can hand the table to a callee the other unit indexes.
        The read sweep closes the walk, and every generator that carries a game field reads its result from the table.

        The facts stand in the store under the key of their generation, and a sweep loads the facts whose key matches.
        It runs only the sweeps of a generation the store holds no facts for, and writes their facts in one transaction.
        The store sweep reads none of the other facts' results back, so it runs after them in its own generation."""
        global REBUILD
        self.keys = self.input_keys()
        # The store of a unit other than the game stands under out/<unit>/, which a fresh tree does not hold yet.
        Path(self.store_path).parent.mkdir(parents=True, exist_ok=True)
        self.store = S.Store(self.store_path)
        self.swept = set()
        base = None if REBUILD else self.store.load("base", self.keys.base)
        if base is None or not self.load_base(base):
            self.stale("base", self.keys.files)
            self.sweep_base()
            self.store.save("base", self.keys.base, self.keys.files, self.base_facts(), tables=self.sweep_syntax())
            self.swept.add("base")
        adoption = None if REBUILD else self.store.load("adoption", self.keys.adoption)
        if adoption is None:
            self.stale("adoption", self.keys.stubs)
            self.sweep_stores(self.parse.game, self.parse.game_folder)
            self.store.save("adoption", self.keys.adoption, self.keys.stubs, {name: getattr(self, name) for name in ADOPTION_FACTS})
            self.store.drop_locals()
            self.swept.add("adoption")
        else:
            for name in ADOPTION_FACTS:
                setattr(self, name, adoption[name])
        REBUILD = False

    def sweep_base(self) -> None:
        """Every sweep of the base generation, in the order the table reads them."""
        tu, folder = self.parse.game, self.parse.game_folder
        other, other_folder = self.parse.cgame, self.parse.cgame_folder
        self.sweep_nulls(tu, folder)
        self.sweep_subscripts(tu, folder)
        self.sweep_handoffs(tu, folder)
        self.sweep_buffer_traps(tu, folder)
        self.sweep_nulls(other, folder, other_folder)
        self.sweep_null_hops(tu, folder)
        self.sweep_null_hops(other, folder, other_folder)
        self.sweep_subscripts(other, folder, other_folder)
        self.sweep_handoffs(other, folder, other_folder)
        self.resolve_handoffs()
        self.sweep_buffer_traps(other, folder, other_folder)
        self.sweep_null_arms(tu, folder)
        self.sweep_text(tu, folder)
        self.sweep_cursors(tu, folder)
        self.sweep_file_walks()
        self.sweep_array_handoffs()
        self.sweep_returns(tu, folder)
        self.reads = {read.key: read for read in self.sweep_reads(tu, folder)}

    def sweep_syntax(self) -> dict[str, list[tuple]]:
        """The statement, comment, and macro rows of every function body of the swept unit, by table, which the base generation saves.
        It reads the macro uses of the parse once and gives each body the uses of its own file."""
        uses: dict[str, list[ci.Cursor]] = {}
        for cur in self.parse.game.cursor.get_children():
            if cur.kind == CursorKind.MACRO_INSTANTIATION and cur.location.file:
                uses.setdefault(str(Path(cur.location.file.name).resolve()), []).append(cur)
        tables: dict[str, list[tuple]] = {"statements": [], "comments": [], "macros": []}
        sources: dict[Path, tuple[SourceFile, bytes]] = {}
        for (stem, _), cur in self.functions.items():
            path = Path(cur.location.file.name).resolve()
            if path not in sources:
                sources[path] = (SourceFile(path), C.parsed_bytes(path))
            rows = syntax_rows(stem, cur, *sources[path], uses.get(str(path), []))
            for table, part in zip(tables, rows):
                tables[table] += part
        return tables

    # MARK: - The store

    def input_keys(self) -> S.Keys:
        """The keys of this run's inputs: every file the three parses read, the names and callback signatures of the generated declarations,
        the tool modules of the project file, and the first line of every stub, salted with the line of a generated stub."""
        from skeleton import NOTE

        from views import declaration_heads

        inputs: set[Path] = set()
        for tu in (self.parse.game, self.parse.cgame, self.parse.headers):
            # The main file of a unity parse is text in memory, and the header umbrella is a file on disk.
            if Path(tu.spelling).exists():
                inputs.add(Path(tu.spelling))
            inputs |= {Path(inc.include.name) for inc in tu.get_includes()}
        tools = [HERE / name for name in C.PROJECT["store"]["modules"]]
        folders = C.PROJECT["output"]["stubs"] + [C.TARGETS["logic"]]
        stubs = sorted(path for folder in folders for path in C.written(OUTPUT / folder).glob("*.swift"))
        # The sweeps read which records have a view, and a view generator of one root has fewer of them, so the view set is an input too.
        values = {"(the view set)": "\n".join(sorted(self.views.views))}
        # The views read the declared names and the callback signatures of the generated declarations, so the key covers those parts alone.
        patterns = [pattern.format(views=C.TARGETS["views"]) for pattern in C.PROJECT["output"]["declarations"]]
        declarations = {path for pattern in patterns for path in OUTPUT.glob(pattern)}
        values |= {S.named(path, C.REPO): declaration_heads(path.read_text()) for path in sorted(declarations)}
        return S.keys(sorted(inputs), tools, stubs, C.REPO, salt=NOTE, values=values)

    def stale(self, generation: str, files: dict[str, str]) -> None:
        """Say on standard error which files made a generation stale, so a slow run names its cause."""
        if REBUILD:
            print(f"table.py: --rebuild, the {generation} facts are swept again", file=sys.stderr)
            return
        if self.store.key(generation) is None:
            print(f"table.py: the store holds no {generation} facts, so the sweep writes them", file=sys.stderr)
            return
        changed = self.store.changed(generation, files)
        shown = ", ".join(changed[:5]) + (f", and {len(changed) - 5} more" if len(changed) > 5 else "")
        print(f"table.py: the {generation} facts are stale, {len(changed)} files changed: {shown}", file=sys.stderr)

    def base_facts(self) -> dict:
        facts = {name: getattr(self, name) for name in BASE_FACTS}
        facts["nullable"] = self.nullable - NULLABLE
        facts["rulings"] = {("NULLABLE", function, parameter) for function, parameter in NULLABLE}
        facts["functions"] = list(self.functions)
        return facts

    def load_base(self, facts: dict) -> bool:
        """Take the base facts from the store, and the body of each function from this run's parse.
        False when the parse has another set of bodies than the store, and then no fact is taken, so the caller sweeps again."""
        bodies: dict[tuple[str, str], ci.Cursor] = {}
        for cur in self.parse.game.cursor.get_children():
            if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
                continue
            path = Path(cur.location.file.name).resolve()
            if path.parent == self.parse.game_folder and path.suffix == ".c":
                bodies[(path.stem, cur.spelling)] = cur
        if list(bodies) != facts["functions"]:
            return False
        self.functions = bodies
        for name in BASE_FACTS:
            setattr(self, name, facts[name])
        self.nullable = facts["nullable"] | {(function, parameter) for _, function, parameter in facts["rulings"]}
        return True

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
        """The table row of one parameter. The sweeps and the rulings of this cursor go to spelling.py, which owns the shape."""
        name = cur.spelling
        ruled = PARAMS.get((owner, name))
        capacity = None
        if isinstance(ruled, tuple):
            ruled, capacity = ruled
        facts = Facts(
            owner=owner,
            ruled=ruled,
            capacity=capacity,
            traps=traps,
            following=following,
            nullable=(owner, name) in self.nullable,
            null_reaches=(owner, name) in self.nullable or (owner, name) in self.hopped,
            readonly_text=(owner, name) in self.readonly_text,
            indexed=(owner, name) in self.indexed_params,
            stores_through=(owner, name) in self.stores_through,
            null_arm=(owner, name) in self.null_arms,
            store_swept=owner in self.store_swept,
            fills_array=(owner, name) in self.array_handoffs,
        )
        answer = self.types.answer("parameter", cur.type, facts)
        if answer is None:
            return None
        if answer.kind == "closure":
            # A function-pointer parameter, whose own prototype parameters cross by these rows in turn.
            return self.closure(cur, name)
        return Param(name, answer.swift, answer.kind, size=answer.size)

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
        """A Swift spelling the logic target can see, for skeleton.py, which reaches the answer through the table. spelling.py owns it."""
        return self.types.known(swift)

    def result(self, cur: ci.Cursor) -> tuple[str | None, str] | None:
        """The Swift return type and the expression that maps the word into it, or None for an unmappable return."""
        ruled = RETURNS.get(cur.spelling)
        if ruled == "text_cursor":
            # A pointer into the caller's text, returned as the cursor it is.
            return ("JKAShared.TextCursor", "")
        if ruled == "raw":
            return ("UnsafeMutableRawPointer", "")
        if ruled == "pooled_string":
            return ("String", "")
        if ruled == "optional_string":
            return (OPTIONAL_TEXT_RESULT.swift, OPTIONAL_TEXT_RESULT.crossing)
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
            return (OPTIONAL_TEXT_RESULT.swift, OPTIONAL_TEXT_RESULT.crossing)
        return result

    def result_type(self, t: ci.Type) -> tuple[str | None, str] | None:
        """The Swift return type and the expression that maps the syscall word into it, as spelling.py answers the return role."""
        answer = self.types.answer("return", t)
        return None if answer is None else (answer.swift, answer.crossing)
