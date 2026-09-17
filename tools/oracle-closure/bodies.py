#!/usr/bin/env python3
"""bodies.py: a first Swift draft of each function body, translated statement by statement from Raven's AST.

The draft encodes the rules of docs/transcription.md that a machine can apply without judgment: views for `->`, `true`
and `false` for qtrue and qfalse, `!= 0` and `!= nil` where C tests a number or a pointer, `i = 0; while ...; i += 1`
for a `for` loop, `+= 1` for a `++` statement, `&` on an argument a Swift `inout` parameter takes, and Raven's comments
and blank lines in their places. A statement the draft cannot translate keeps its C text in a `// Raven wrote:` line
under a Port-note, and a `portMissing` call marks the place, so the draft compiles as far as it goes and a transcriptor
finds every hole by one grep.

The draft goes to stdout, never into Sources/. The stub header comes from skeleton.py, so the signature is the table's.

Usage:
  .venv/bin/python bodies.py --only PM_AddTouchEnt,BG_SabersOff   # prints the drafts of the named functions
  .venv/bin/python bodies.py --stem bg_pmove                       # prints every draft of one file
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

from table import INT_KINDS

from reexport import SOURCES
from rulings import HAND_VARS, NEVER_NULL_VARS
import closure as C
from skeleton import BG, LOGIC, ORACLE_DIR, Function, Skeleton, target_of

# The Swift targets a bg body never sees, by the bg/game boundary.
GAME_SIDE = {LOGIC, "JKAMP_Game"}
from table import Param, TARGET, swift_name

INDENT = "    "
COMPARISONS = {"==", "!=", "<", ">", "<=", ">="}
LOGICAL = {"&&", "||"}
ASSIGNS = {"=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>="}
BINARY_OPS = COMPARISONS | LOGICAL | ASSIGNS | {"+", "-", "*", "/", "%", "&", "|", "^", "<<", ">>", ","}
UNARY_PREFIX = {"-", "+", "!", "~", "*", "&", "++", "--"}
WRAPPERS = {CursorKind.UNEXPOSED_EXPR, CursorKind.PAREN_EXPR}
TEXT_TYPES = {"String", "CharBuf", "JKAShared.CharBuf", "PooledString", "JKAShared.PooledString"}
# The declaration tail of the scratch local each `inout` output a caller skips with NULL takes, by the parameter's Swift spelling.
SCRATCH_ZEROS = {"inout vec3_t": "= JKAShared.vec3_t(0, 0, 0)", "inout Int32": ": Int32 = 0", "inout Float": ": Float = 0"}
COMMENT = re.compile(r"//[^\n]*|/\*.*?\*/", re.S)
NUMBER = re.compile(r"-?\s*((\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?[fFuUlL]*|0[xX][0-9a-fA-F]+[uUlL]*)")
IDENTIFIER = re.compile(r"[A-Za-z_]\w*")
from overlay import DROPPED, MACROS, MACRO_RETURNS, OVERLAY, RECORD_CALLS, UNDEFINED

FUNC_LINE = re.compile(r"func\s+`?(\w+)`?\s*\((.*)\)")
FUNC_HEAD = re.compile(r"func\s+`?(\w+)`?\s*\(")
# A file-scope `var`, `let`, or `func` of a Swift file: at column 0, after its modifiers. A method sits indented under its type.
MODIFIERS = r"(?:(?:public|package|internal|private|fileprivate|nonisolated\(unsafe\)|@\w+(?:\([^)]*\))?)\s+)*"
VAR_LINE = re.compile(MODIFIERS + r"(?:var|let)\s+`?(\w+)`?")
# The type annotation of a file-scope variable, up to its initializer or its computed body.
VAR_TYPE = re.compile(r"\s*:\s*([^={]+)")
FILE_FUNC = re.compile(MODIFIERS + r"func\s")


def split_params(text: str) -> list[str]:
    """The parameter list of one Swift `func` line, split at the commas outside brackets."""
    out: list[str] = []
    depth = 0
    start = 0
    for i, ch in enumerate(text):
        if ch in "([<":
            depth += 1
        elif ch in ")]>":
            depth -= 1
        elif ch == "," and depth == 0:
            out.append(text[start:i].strip())
            start = i + 1
    tail = text[start:].strip()
    if tail:
        out.append(tail)
    return out


class Registry:
    """The `inout` positions of every hand and generated Swift function under Sources/, so a call to a trap or a q_shared function
    takes `&` where the Swift signature asks for it."""

    def __init__(self) -> None:
        self.params: dict[str, list[tuple[str, str]]] = {}
        # The Swift return type of each function, so a call to one that returns a value takes no bind.
        self.returns: dict[str, str] = {}
        # Every overload's parameters, so an argument converts only when no overload takes it as it is.
        self.overloads: dict[str, list[list[tuple[str, str]]]] = {}
        # The Swift targets that hold each file-scope function and variable, so a bg body that reaches a game-only name keeps a hole.
        self.homes: dict[str, set[str]] = {}
        # The Swift type of each file-scope variable that spells one, so a store reads whether the source is a Slots.
        self.var_types: dict[str, str] = {}
        for path in SOURCES.rglob("*.swift"):
            target = path.relative_to(SOURCES).parts[0]
            for line in path.read_text().splitlines():
                v = VAR_LINE.match(line)
                if v is not None:
                    self.homes.setdefault(v.group(1), set()).add(target)
                    spelled = VAR_TYPE.match(line[v.end():])
                    if spelled is not None:
                        self.var_types.setdefault(v.group(1), spelled.group(1).strip())
                m = FUNC_HEAD.search(line)
                if m is None or "func " not in line.split("//")[0]:
                    continue
                # The parameter list ends at the parenthesis that balances the first, so a tuple return stays outside it.
                depth = 0
                end = None
                for i in range(m.end() - 1, len(line)):
                    if line[i] == "(":
                        depth += 1
                    elif line[i] == ")":
                        depth -= 1
                        if depth == 0:
                            end = i
                            break
                if end is None:
                    continue
                name = m.group(1)
                params = []
                for p in split_params(line[m.end():end]):
                    label, _, swift = p.partition(":")
                    params.append((label.split()[-1].strip("`"), swift.strip()))
                self.params.setdefault(name, params)
                self.overloads.setdefault(name, []).append(params)
                r = re.search(r"->\s*(.+?)\s*\{?\s*$", line[end + 1:])
                self.returns.setdefault(name, r.group(1) if r else "Void")
                if FILE_FUNC.match(line):
                    self.homes.setdefault(name, set()).add(target)


class Hole(Exception):
    """A construct the draft has no rule for. The message is the reason the Port-note carries."""


class Drafter:
    def __init__(self, sk: Skeleton, registry: Registry) -> None:
        self.sk = sk
        self.views = sk.table.views
        self.registry = registry
        self.holes = 0
        # The locals a hole declares, so a later error on one of them counts as a cascade of the hole, not a new defect.
        self.hole_names: set[str] = set()
        # The same names of the function being drafted alone, because another function is free to hold a local of that name.
        self.local_holes: set[str] = set()
        # Lines an expression asks to go above its statement: a Port-note, or a scratch local for a NULL output argument.
        self.pending: list[str] = []
        # The parameters and the local declarations of the function being drafted, by name, for the let and the guard rules.
        self.params_by_name: dict[str, Param] = {}
        self.lets: set[str] = set()
        # A conversion every numeric leaf of the expression being drafted takes: "Double" under a double literal, or an unsigned type.
        self.leaf_wrap: str | None = None
        # The scratch closures open around the statement being drafted, innermost last: None, "flag", or "value".
        self.scratch_modes: list[str | None] = []
        # The game fields a bg body reaches, by root kind, field path, and write, each with the callback the channel carries.
        self.reads = {r.key: r for r in sk.table.sweep_reads(sk.tu, (C.ORACLE / ORACLE_DIR).resolve())}
        # The locals of the function being drafted that Raven typed `gentity_t *` and the draft holds as `JKAMP.BgEntity`.
        self.game_entities: set[str] = set()
        # The text kind of each argument of the call being drafted, by position, so one overload takes the whole call.
        self.call_kinds: dict[int, str] = {}

    # MARK: - One function

    def draft(self, fn: Function) -> list[str]:
        header = self.sk.stub(fn)
        if not fn.mapped or not header[-1].startswith("}"):
            return header
        self.fn = fn
        self.source = self.sk.source(fn.stem)
        self.bytes = C.parsed_bytes(C.ORACLE / ORACLE_DIR / f"{fn.stem}.c")
        self.names = {c.spelling: p.name for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.params_by_name = {c.spelling: p for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.scratch_names: dict[str, int] = {}
        # The Swift statement each of Raven's labels gives its gotos, `break rest` or `continue backAgain`.
        self.goto_forms: dict[str, str] = {}
        # The vector each pointer-to-float local of the function stands for, by Raven's name.
        self.aliases: dict[str, ci.Cursor] = {}
        self.game_entities = set()
        self.local_holes = set()
        self.optional_entities: set[str] = set()
        self.after_com_error = False
        self.charbuf_locals: set[str] = set()
        # Raven's `byte *b` and `char *dest` locals that only ever hold a raw allocation, which Swift holds as UnsafeMutableRawPointer.
        self.raw_locals = self.raw_local_names(fn.cur)
        # Raven's `const char *token` that only holds parsed text is a String, and his `char *p` over a buffer is a TextCursor.
        self.text_locals, self.optional_texts, self.cursor_locals = self.text_local_names(fn.cur)
        # Raven's `for (it = table + 1; it->name; it++)` walks a table by pointer, and the draft walks it by index, `table[itIndex]`.
        self.table_cursors = self.table_cursor_names(fn.cur)
        # The slot text each copy stands for inside the one call being drafted, `fxAxis[2]` for `fxAxis2`.
        self.slot_copies: dict[str, str] = {}
        self.aliased_positions: dict[int, str] = {}
        # Raven's `animation_t *animations` local that only ever holds a table of records, which Swift holds as the Slots over it.
        self.slots_locals = self.slots_local_names(fn.cur)
        self.lets = self.single_writes(fn.cur)
        if any(self.record_local(c) is not None for c in fn.cur.walk_preorder()):
            # A closure cannot initialize a let of the enclosing body, so a body with a scratch record keeps every local a var.
            self.lets = set()
        self.written = self.written_names(fn.cur)
        self.addressed = self.addressed_names(fn.cur)
        self.has_scratch = any(self.record_local(c) is not None for c in fn.cur.walk_preorder())
        self.inout_locals = {c.spelling for c, p in zip(fn.cur.get_arguments(), fn.params) if (p.swift or "").startswith("inout ")}
        # Raven assigns a parameter of his own. A Swift parameter is immutable, so the body opens with a mutable copy, after the declarations.
        self.param_copies = [p.name for c, p in zip(fn.cur.get_arguments(), fn.params) if c.spelling in self.written and c.spelling not in self.inout_locals]
        body = [c for c in fn.cur.get_children() if c.kind == CursorKind.COMPOUND_STMT][-1]
        lines = header[:-3]
        lines += self.block_body(body, 1)
        lines.append("}")
        return lines

    # MARK: - Statements

    def block_body(self, block: ci.Cursor, depth: int) -> list[str]:
        """The statements of a compound statement, with Raven's comment and blank lines between them."""
        out = self.opening(block, depth) + self.statements(list(block.get_children()), block.extent.start.line, block.extent.end.line, depth)
        while out and not out[0].strip():
            out.pop(0)
        while out and not out[-1].strip():
            out.pop()
        return out

    def statements(self, children: list[ci.Cursor], first_line: int, last_line: int, depth: int) -> list[str]:
        """A run of statements. A record local, `trace_t trace;`, opens a scratch closure, and the rest of the run is its body."""
        out: list[str] = []
        previous_line = first_line
        labels = [i for i, c in enumerate(children) if c.kind == CursorKind.LABEL_STMT]
        if labels:
            return self.labeled(children, labels[0], first_line, last_line, depth)
        for i, child in enumerate(children):
            record = self.record_local(child)
            if child.kind != CursorKind.DECL_STMT or record is not None:
                out += self.param_copy_lines(depth)
            out += self.gap(previous_line, child.extent.start.line, depth)
            if record is not None:
                out += self.scratch(child, record, children[i + 1:], last_line, depth)
                return out
            out += self.statement(child, depth)
            self.after_com_error = self.is_call(child) and self.callee_name(child) == "Com_Error"
            previous_line = child.extent.end.line
        out += self.gap(previous_line, last_line, depth)
        return out

    def param_copy_lines(self, depth: int) -> list[str]:
        """The mutable copy of each parameter Raven assigns, at the head of the function's own block.
        A deeper block gives no seat, because a copy there hides the parameter from the statements outside it."""
        if depth != 1 or not self.param_copies:
            return []
        out: list[str] = []
        for name in self.param_copies:
            out.append(f"{INDENT}// Raven assigns his own `{name}` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.")
            out.append(f"{INDENT}var {name} = {name}")
        self.param_copies = []
        return out

    def labeled(self, children: list[ci.Cursor], i: int, previous_line: int, last_line: int, depth: int) -> list[str]:
        """Raven's label as a labeled Swift block. Every goto before the label is `break` out of a `do` around the statements before it,
        and every goto after the label is `continue` of a `while true` around the statements from it, by "goto"."""
        pad = INDENT * depth
        label = children[i]
        name = label.spelling
        gotos = [c for c in self.fn.cur.walk_preorder() if c.kind == CursorKind.GOTO_STMT and any(k.spelling == name for k in c.get_children())]
        before = [g for g in gotos if g.extent.start.offset < label.extent.start.offset]
        after = [g for g in gotos if g.extent.start.offset > label.extent.start.offset]
        inner = list(label.get_children())
        rest = inner + children[i + 1:]
        out: list[str] = []
        if before and not after:
            region = children[:i]
            if any(g.extent.start.offset < region[0].extent.start.offset for g in before) if region else before:
                raise Hole(f"Raven's `goto {name}` jumps into a block from outside it, and the transcriptor restructures the flow.")
            # The block cannot hide a local from the statements after the label, so the leading declarations stay outside it.
            lead = 0
            while lead < len(region) and region[lead].kind == CursorKind.DECL_STMT and self.record_local(region[lead]) is None:
                lead += 1
            self.goto_forms[name] = f"break {name}"
            out += self.statements(region[:lead], previous_line, region[lead].extent.start.line if lead < len(region) else label.extent.start.line, depth)
            out += self.param_copy_lines(depth)
            out.append(f"{pad}{name}: do {{")
            out += self.statements(region[lead:], region[lead].extent.start.line - 1 if lead < len(region) else label.extent.start.line - 1, label.extent.start.line, depth + 1)
            out.append(f"{pad}}}")
            out += self.statements(rest, label.extent.start.line, last_line, depth)
            return out
        if after and not before:
            if self.escapes(rest):
                raise Hole(f"A break or a continue after Raven's `{name}:` targets a loop outside it, and the transcriptor restructures the flow.")
            self.goto_forms[name] = f"continue {name}"
            out += self.statements(children[:i], previous_line, label.extent.start.line, depth)
            out += self.param_copy_lines(depth)
            out.append(f"{pad}{name}: while true {{")
            out += self.statements(rest, label.extent.start.line, last_line, depth + 1)
            out.append(f"{INDENT * (depth + 1)}break")
            out.append(f"{pad}}}")
            return out
        raise Hole(f"Raven's `{name}:` takes a goto from both sides, and the transcriptor restructures the flow.")

    def record_local(self, cur: ci.Cursor) -> ci.Cursor | None:
        """The one variable of a declaration that is a C struct with a view, or None."""
        if cur.kind != CursorKind.DECL_STMT:
            return None
        vars_ = [v for v in cur.get_children() if v.kind == CursorKind.VAR_DECL]
        if len(vars_) != 1:
            return None
        t = vars_[0].type.get_canonical()
        if t.kind != TypeKind.RECORD:
            return None
        record = self.views.record_name(t)
        return vars_[0] if record and record in self.views.views else None

    def scratch(self, decl: ci.Cursor, var: ci.Cursor, rest: list[ci.Cursor], last_line: int, depth: int) -> list[str]:
        """Raven's block from the record local on, as the closure of the view's scratch helper. A return inside the block is
        the closure's value, and the body acts on it after the closure, by "A scratch C struct on the stack"."""
        pad = INDENT * depth
        view = self.views.qualified_view(self.views.record_name(var.type.get_canonical()), TARGET)
        name = swift_name(var.spelling)
        init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
        if not init and rest and self.record_store(rest[0], var):
            # Raven fills the record from another right after declaring it, `cmd = pm->cmd;`, which is the copying form.
            init = [list(self.strip(rest[0]).get_children())[1]]
            rest = rest[1:]
        opener = f"{view}.scratch(copying: {self.expr(init[0])})" if init else f"{view}.scratch"
        returns = any(c.kind == CursorKind.RETURN_STMT for r in rest for c in r.walk_preorder())
        if self.escapes(rest):
            raise Hole("Raven's block leaves a loop outside the record's scope, and the closure cannot.")
        mode = None
        if returns and self.fn.returns is not None and self.always_returns(rest):
            mode = "direct"
        elif returns:
            mode = "flag" if self.fn.returns is None else "value"
        result = "earlyOut" if not self.scratch_modes else f"earlyOut{len(self.scratch_modes) + 1}"
        out = [f"{pad}// Raven's record lives to the end of his block, so the block is the closure."]
        if mode == "direct":
            out.append(f"{pad}// Every path of Raven's block returns, so the closure's value is the function's.")
            out.append(f"{pad}return {opener} {{ {name} -> {self.fn.returns} in")
        elif mode == "flag":
            out.append(f"{pad}// The closure gives true where Raven returns from the function.")
            out.append(f"{pad}let {result} = {opener} {{ {name} -> Bool in")
        elif mode == "value":
            out.append(f"{pad}// The closure gives nil where Raven's block falls through to its end.")
            out.append(f"{pad}let {result} = {opener} {{ {name} -> {self.fn.returns}? in")
        else:
            out.append(f"{pad}{opener} {{ {name} in")
        self.scratch_modes.append(mode)
        try:
            body = self.statements(rest, decl.extent.end.line, last_line, depth + 1)
        finally:
            self.scratch_modes.pop()
        while body and not body[-1].strip():
            body.pop()
        out += body
        if mode == "flag":
            out.append(f"{INDENT * (depth + 1)}return false")
        elif mode == "value":
            out.append(f"{INDENT * (depth + 1)}return nil")
        out.append(f"{pad}}}")
        if mode == "flag":
            out += [f"{pad}if {result} {{", f"{INDENT * (depth + 1)}return", f"{pad}}}"]
        elif mode == "value":
            out += [f"{pad}if let {result} {{", f"{INDENT * (depth + 1)}return {result}", f"{pad}}}"]
        return out

    def always_returns(self, stmts: list[ci.Cursor]) -> bool:
        """True when no path through the statements reaches their end: the last is a return, an if whose arms both do, or a
        switch with a default whose every case ends in a return."""
        if not stmts:
            return False
        last = stmts[-1]
        if last.kind == CursorKind.RETURN_STMT:
            return True
        if last.kind == CursorKind.COMPOUND_STMT:
            return self.always_returns(list(last.get_children()))
        if last.kind == CursorKind.IF_STMT:
            kids = list(last.get_children())
            return len(kids) == 3 and self.always_returns([kids[1]]) and self.always_returns([kids[2]])
        if last.kind == CursorKind.SWITCH_STMT:
            body = list(last.get_children())[-1]
            groups: list[list[ci.Cursor]] = []
            default = False
            for child in body.get_children():
                stmt = child
                labelled = False
                while stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT):
                    labelled = True
                    default = default or stmt.kind == CursorKind.DEFAULT_STMT
                    stmt = list(stmt.get_children())[-1]
                if labelled:
                    groups.append([])
                if groups and stmt.kind not in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT):
                    groups[-1].append(stmt)
            return default and all(self.always_returns(g) for g in groups)
        return False

    def record_store(self, cur: ci.Cursor, var: ci.Cursor) -> bool:
        """True when the statement stores a whole record into the named local, `cmd = pm->cmd;`."""
        cur = self.strip(cur)
        if cur.kind != CursorKind.BINARY_OPERATOR or self.collapsed(cur):
            return False
        kids = list(cur.get_children())
        if len(kids) != 2 or self.binary_op(cur) != "=":
            return False
        left = self.unwrap(kids[0])
        return left.kind == CursorKind.DECL_REF_EXPR and left.referenced is not None and left.referenced == var

    def escapes(self, rest: list[ci.Cursor]) -> bool:
        """True when a break or a continue in the run targets a loop or a switch outside it."""
        loops = {CursorKind.FOR_STMT, CursorKind.WHILE_STMT, CursorKind.DO_STMT}

        def walk(cur: ci.Cursor, loop: bool, switch: bool) -> bool:
            if cur.kind == CursorKind.BREAK_STMT and not loop and not switch:
                return True
            if cur.kind == CursorKind.CONTINUE_STMT and not loop:
                return True
            return any(walk(k, loop or cur.kind in loops, switch or cur.kind == CursorKind.SWITCH_STMT) for k in cur.get_children())

        return any(walk(r, False, False) for r in rest)

    def gap(self, after: int, before: int, depth: int) -> list[str]:
        """Raven's comment and blank lines strictly between two statements, re-indented."""
        out: list[str] = []
        block = False
        for line in self.source.lines[after:before - 1]:
            text = line.strip()
            if block:
                # A line inside Raven's `/* */` comment keeps its text, and the closing line ends the block.
                out.append(INDENT * depth + text if text else "")
                block = not text.endswith("*/")
            elif not text:
                out.append("")
            elif text.startswith("//") or (text.startswith("/*") and text.endswith("*/")):
                out.append(INDENT * depth + text)
            elif text.startswith("/*"):
                out.append(INDENT * depth + text)
                block = True
        return out

    def opening(self, block: ci.Cursor, depth: int) -> list[str]:
        """Raven's comment on the line of the opening brace, `{ //lost it`, as the first line of the block."""
        line = self.source.lines[block.extent.start.line - 1]
        rest = line[block.extent.start.column:].strip()
        return [INDENT * depth + rest] if rest.startswith("//") or (rest.startswith("/*") and rest.endswith("*/")) else []

    def trailing(self, cur: ci.Cursor) -> str:
        """Raven's comment on the last line of a statement, after the statement's text."""
        line = self.source.lines[cur.extent.end.line - 1]
        rest = line[cur.extent.end.column - 1:].strip().lstrip(";").strip()
        return f" {rest}" if rest.startswith("//") else ""

    def statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        outer = self.pending
        self.pending = []
        try:
            lines = self.statement_lines(cur, depth)
        except Hole as hole:
            lines = self.hole(cur, depth, str(hole))
        lines = [INDENT * depth + line for line in self.pending] + lines
        self.pending = outer
        return lines

    def single_writes(self, fn: ci.Cursor) -> set[str]:
        """The locals Swift can hold in a `let`: written once outside a loop, or once in each arm of one if, and never by `&`."""
        writes: dict[str, list[tuple[bool, tuple[ci.Cursor, int] | None]]] = {}
        loops = {CursorKind.FOR_STMT, CursorKind.WHILE_STMT, CursorKind.DO_STMT}

        def root(cur: ci.Cursor) -> str | None:
            cur = self.unwrap(cur)
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
                between = self.bytes[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace")
                if COMMENT.sub("", between).strip() in ASSIGNS or kids[0].extent.start.offset == kids[1].extent.start.offset:
                    name = root(kids[0])
                    if name is not None:
                        writes.setdefault(name, []).append((in_loop, arm))
            if cur.kind == CursorKind.UNARY_OPERATOR and kids:
                before = self.bytes[cur.extent.start.offset:kids[0].extent.start.offset].decode("utf-8", "replace").strip()
                after = self.bytes[kids[0].extent.end.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()
                name = root(kids[0])
                if name is not None and (before in ("++", "--", "&") or after in ("++", "--")):
                    writes.setdefault(name, []).append((True, None))
            if cur.kind == CursorKind.IF_STMT and len(kids) == 3:
                walk(kids[0], in_loop, arm)
                walk(kids[1], in_loop, (cur, 1))
                walk(kids[2], in_loop, (cur, 2))
                return
            for k in kids:
                walk(k, in_loop or cur.kind in loops, arm)

        walk(fn, False, None)
        out = set()
        for name, sites in writes.items():
            if len(sites) == 1 and not sites[0][0]:
                out.add(name)
            if len(sites) == 2 and not sites[0][0] and not sites[1][0] and sites[0][1] is not None and sites[1][1] is not None \
                    and sites[0][1][0] == sites[1][1][0] and sites[0][1][1] != sites[1][1][1]:
                out.add(name)
        return out

    def written_names(self, fn: ci.Cursor) -> set[str]:
        """Every local a statement writes after its declaration, by any operator."""
        out: set[str] = set()
        for cur in fn.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) and len(kids) == 2:
                between = COMMENT.sub("", self.bytes[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace")).strip()
                if between in ASSIGNS or kids[0].extent.start.offset == kids[1].extent.start.offset:
                    out.add(self.written_root(kids[0]))
            if cur.kind == CursorKind.UNARY_OPERATOR and kids:
                before = self.bytes[cur.extent.start.offset:kids[0].extent.start.offset].decode("utf-8", "replace").strip()
                after = self.bytes[kids[0].extent.end.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()
                if before in ("++", "--", "&") or after in ("++", "--"):
                    out.add(self.written_root(kids[0]))
        return out

    def tuple_call(self, cur: ci.Cursor) -> tuple[str, str] | None:
        """A call to a trap whose Swift form returns `(Int32, String)`: the call without Raven's buffer and size arguments,
        and the Swift text of the buffer Raven passed, which takes the returned text."""
        inner = self.strip(cur)
        if not self.is_call(inner):
            return None
        name = self.callee_name(inner)
        if not name or not self.registry.returns.get(name, "").startswith("(Int32, String)"):
            return None
        params = self.callee_params(name)
        args = list(inner.get_children())[1:]
        buffer = next((a for a in args if self.is_charbuf(a)), None)
        if buffer is None:
            return None
        # Only the buffer leaves the call. Raven's size argument stays, because the Swift trap still takes the capacity.
        kept = [a for a in args if a is not buffer][:len(params)]
        words = [self.argument(a, params[i][1].startswith("inout "), params[i], name, i) for i, a in enumerate(kept)]
        return f"{swift_name(name)}({', '.join(words)})", self.expr(buffer)

    def sizeof(self, cur: ci.Cursor) -> str:
        """Raven's `sizeof`: a buffer's count, a record view's byte count, or a scalar's layout size."""
        kids = list(cur.get_children())
        operand = next((k for k in kids if k.kind.is_expression()), None)
        if operand is not None and self.is_charbuf(operand):
            return f"Int32({self.expr(operand)}.count)"
        t = operand.type if operand is not None else None
        if t is None:
            text = self.source.slice(cur.extent).strip()
            m = re.fullmatch(r"sizeof\s*\(\s*(.+?)\s*\)", text)
            if m is None:
                raise Hole("A sizeof the draft cannot size.")
            spelled = m.group(1)
            t = next((k.type for k in kids if k.kind == CursorKind.TYPE_REF), None)
            if t is None:
                record = spelled.replace("struct ", "").strip()
                if record in self.views.views:
                    return f"Int32({self.views.qualified_view(record, TARGET)}.byteCount)"
                raise Hole(f"A sizeof of `{spelled}` the draft cannot size.")
        canonical = t.get_canonical()
        if canonical.kind == TypeKind.CONSTANTARRAY and canonical.element_type.get_canonical().kind == TypeKind.CHAR_S:
            return str(canonical.element_count)
        record = self.views.record_name(canonical)
        if record and record in self.views.views:
            return f"Int32({self.views.qualified_view(record, TARGET)}.byteCount)"
        swift = self.views.scalar(t, TARGET)
        if swift is not None:
            return f"Int32(MemoryLayout<{swift}>.size)"
        raise Hole(f"A sizeof of `{t.spelling}` the draft cannot size.")

    def is_sizeof(self, cur: ci.Cursor) -> bool:
        """True for Raven's `sizeof`, which C types unsigned and the draft reads as an Int32."""
        return self.unwrap(cur).kind == CursorKind.CXX_UNARY_EXPR

    def vector_member(self, cur: ci.Cursor) -> str | None:
        """The Swift name of the vector under Raven's `&v[i]`, or None."""
        inner = self.strip(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            inner = self.unwrap(self.unary_parts(inner)[2])
        if inner.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return None
        base = list(inner.get_children())[0]
        return self.expr(base) if self.views.is_vec3(self.unwrap(base).type) else None

    def raw_store(self, cur: ci.Cursor) -> tuple[str, str, str, str | None] | None:
        """Raven's `*(T *)(b + ofs)` or `((T *)(b + ofs))[i]` over a raw pointer: the base, the label of T, the offset, and the index."""
        inner = self.unwrap(cur)
        index = None
        if inner.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            base, idx = list(inner.get_children())
            cast = self.unwrap(base)
            index = self.converted(idx, "Int32")
        elif inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "*":
            cast = self.unwrap(self.unary_parts(inner)[2])
        else:
            return None
        if cast.kind != CursorKind.CSTYLE_CAST_EXPR:
            return None
        pointee = cast.type.get_canonical().get_pointee().get_canonical()
        if pointee.kind in INT_KINDS and pointee.kind not in (TypeKind.CHAR_S, TypeKind.UCHAR):
            label = "int"
        elif pointee.kind == TypeKind.FLOAT:
            label = "float"
        elif pointee.kind == TypeKind.POINTER and pointee.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
            label = "string"
        else:
            return None
        sum_ = self.unwrap([k for k in cast.get_children() if k.kind.is_expression()][-1])
        if sum_.kind != CursorKind.BINARY_OPERATOR or self.operator_or_none(sum_) != "+":
            return None
        base, ofs = list(sum_.get_children())
        if not self.is_raw(base):
            return None
        return self.expr(base), label, self.converted(ofs, "Int32"), index

    def record_walk(self, cur: ci.Cursor) -> bool:
        """True for a parameter or a local Raven walks as an array of records, `animations[anim]`.
        The view over it holds one record, so the walk has no Swift form."""
        if cur.kind != CursorKind.DECL_REF_EXPR or self.is_raw(cur):
            return False
        ref = cur.referenced
        if ref is None or ref.kind not in (CursorKind.PARM_DECL, CursorKind.VAR_DECL):
            return False
        if ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
            return False
        t = cur.type.get_canonical()
        if t.kind != TypeKind.POINTER:
            return False
        record = self.views.record_name(t.get_pointee())
        return bool(record) and record in self.views.views

    def view_operand(self, cur: ci.Cursor) -> bool:
        """True when the expression is a pointer to a record the views cover."""
        t = self.unwrap(cur).type.get_canonical()
        return t.kind == TypeKind.POINTER and self.is_record(t.get_pointee())

    def is_raw(self, cur: ci.Cursor) -> bool:
        """True for an expression Swift holds as UnsafeMutableRawPointer: a raw parameter, a raw local, a call that returns one,
        or a view cast to bytes."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.CSTYLE_CAST_EXPR:
            operand = [k for k in inner.get_children() if k.kind.is_expression()][-1]
            pointee = inner.type.get_canonical().get_pointee().get_canonical() if inner.type.get_canonical().kind == TypeKind.POINTER else None
            if pointee is not None and pointee.kind in (TypeKind.CHAR_S, TypeKind.UCHAR, TypeKind.CHAR_U, TypeKind.SCHAR) and self.view_operand(operand):
                return True
            return self.is_raw(operand)
        if inner.kind == CursorKind.DECL_REF_EXPR:
            param = self.params_by_name.get(inner.spelling)
            if param is not None:
                return param.swift == "UnsafeMutableRawPointer"
            return inner.spelling in self.raw_locals
        if inner.kind == CursorKind.CALL_EXPR:
            return self.registry.returns.get(self.callee_name(inner) or "") == "UnsafeMutableRawPointer"
        return False

    def text_local_names(self, fn: ci.Cursor) -> tuple[set[str], set[str], dict[str, str]]:
        """The char pointer locals of the function by their stores: every store a String-returning call or a `char name[N]` field
        names a text local, and every store a buffer names a cursor local, with the Swift text of the buffer it walks.
        The second set holds the text locals Raven also stores his NULL into, which Swift holds as a `String?`."""
        stores: dict[str, list[str]] = {}
        buffers: dict[str, str] = {}
        for var in fn.walk_preorder():
            if var.kind != CursorKind.VAR_DECL:
                continue
            t = var.type.get_canonical()
            if t.kind != TypeKind.POINTER or t.get_pointee().get_canonical().kind != TypeKind.CHAR_S:
                continue
            init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
            stores.setdefault(var.spelling, [])
            if init:
                stores[var.spelling].append(self.text_store_kind(init[0], var.spelling, buffers))
        for cur in fn.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind == CursorKind.COMPOUND_ASSIGNMENT_OPERATOR and kids and self.unwrap(kids[0]).kind == CursorKind.DECL_REF_EXPR \
                    and self.unwrap(kids[0]).spelling in stores:
                stores[self.unwrap(kids[0]).spelling].append("other")
            if cur.kind == CursorKind.UNARY_OPERATOR and kids and self.unwrap(kids[0]).kind == CursorKind.DECL_REF_EXPR \
                    and self.unwrap(kids[0]).spelling in stores and self.unary_parts(cur)[0] in ("++", "--"):
                stores[self.unwrap(kids[0]).spelling].append("other")
            if cur.kind == CursorKind.CALL_EXPR:
                # Raven's `&value` to an `inout String` parameter, `COM_ParseString(&p, &value)`, fills the local with text.
                for position, kind in self.out_text_stores(cur, stores).items():
                    stores[position].append(kind)
            if cur.kind != CursorKind.BINARY_OPERATOR or len(kids) != 2 or self.collapsed(cur) or self.operator_or_none(cur) != "=":
                continue
            left = self.unwrap(kids[0])
            if left.kind == CursorKind.DECL_REF_EXPR and left.spelling in stores:
                stores[left.spelling].append(self.text_store_kind(kids[1], left.spelling, buffers))
        texts = {name for name, kinds in stores.items() if "text" in kinds and all(k in ("text", "null") for k in kinds)}
        # Raven stores his NULL into some of them, and Swift holds that local as an optional text.
        optionals = {name for name in texts if "null" in stores[name]}
        cursors = {name: buffers[name] for name, kinds in stores.items() if "buffer" in kinds and all(k in ("buffer", "null") for k in kinds)}
        return texts, optionals, cursors

    def filled_by_address(self, name: str) -> bool:
        """True when any call of the function passes `&name` to an `inout String` parameter."""
        for cur in self.fn.cur.walk_preorder():
            if cur.kind != CursorKind.CALL_EXPR:
                continue
            if self.out_text_stores(cur, {name: []}).get(name) == "text":
                return True
        return False

    def out_text_stores(self, call: ci.Cursor, stores: dict[str, list[str]]) -> dict[str, str]:
        """The char pointer locals a call fills by address, by the callee's `inout String` parameters, as name to store kind."""
        kids = list(call.get_children())
        name = self.callee_name(call)
        if name is None:
            return {}
        params = self.callee_params(name)
        out: dict[str, str] = {}
        for i, arg in enumerate(kids[1:]):
            inner = self.unwrap(arg)
            if inner.kind != CursorKind.UNARY_OPERATOR or self.operator_or_none_unary(inner) != "&":
                continue
            target = self.unwrap(self.unary_parts(inner)[2])
            if target.kind != CursorKind.DECL_REF_EXPR or target.spelling not in stores or i >= len(params):
                continue
            swift = params[i][1].replace("JKAShared.", "")
            if swift == "inout TextCursor":
                # The callee steps the cursor and stores no new base, so the local stays a cursor.
                continue
            out[target.spelling] = "text" if swift == "inout String" else "other"
        return out

    def operator_or_none_unary(self, cur: ci.Cursor) -> str | None:
        """The prefix operator of a unary node, or None when a macro holds it."""
        try:
            return self.unary_parts(cur)[0]
        except Hole:
            return None

    def text_store_kind(self, cur: ci.Cursor, name: str, buffers: dict[str, str]) -> str:
        inner = self.unwrap(cur)
        if self.is_null(inner):
            return "null"
        if inner.kind == CursorKind.CALL_EXPR and self.registry.returns.get(self.callee_name(inner) or "") in ("String", "String?"):
            return "text"
        if inner.kind == CursorKind.STRING_LITERAL:
            return "text"
        if self.field_slot(inner) is not None:
            return "text"
        if inner.kind == CursorKind.DECL_REF_EXPR:
            t = inner.type.get_canonical()
            if t.kind == TypeKind.CONSTANTARRAY and t.element_type.get_canonical().kind == TypeKind.CHAR_S:
                buffers[name] = self.expr_name(inner.spelling)
                return "buffer"
        return "other"

    def raw_local_names(self, fn: ci.Cursor) -> set[str]:
        """Every pointer-to-byte local whose every store is a raw pointer, by the stores of the function."""
        stores: dict[str, list[bool]] = {}
        for cur in fn.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind != CursorKind.BINARY_OPERATOR or len(kids) != 2 or self.collapsed(cur) or self.operator_or_none(cur) != "=":
                continue
            left = self.unwrap(kids[0])
            if left.kind != CursorKind.DECL_REF_EXPR or left.referenced is None or left.referenced.kind != CursorKind.VAR_DECL:
                continue
            t = left.type.get_canonical()
            if t.kind != TypeKind.POINTER or t.get_pointee().get_canonical().kind not in (TypeKind.CHAR_S, TypeKind.UCHAR, TypeKind.CHAR_U, TypeKind.SCHAR):
                continue
            self.raw_locals = set()
            stores.setdefault(left.spelling, []).append(self.is_raw(kids[1]))
        return {name for name, raws in stores.items() if raws and all(raws)}

    def table_cursor_names(self, fn: ci.Cursor) -> dict[str, tuple[str, str]]:
        """Every pointer local a statement sets to a file-scope table or a slot past its start, `it = bg_itemlist + 1`,
        with the table's Swift name and the index local that stands in for the pointer."""
        out: dict[str, tuple[str, str]] = {}
        for cur in fn.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind != CursorKind.BINARY_OPERATOR or len(kids) != 2 or self.collapsed(cur) or self.operator_or_none(cur) != "=":
                continue
            left, right = self.unwrap(kids[0]), self.unwrap(kids[1])
            if left.kind != CursorKind.DECL_REF_EXPR or left.referenced is None or left.referenced.kind != CursorKind.VAR_DECL:
                continue
            table = right
            if right.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(right) == "+":
                table = self.unwrap(list(right.get_children())[0])
            if table.kind != CursorKind.DECL_REF_EXPR or table.referenced is None:
                continue
            ref = table.referenced
            if ref.kind == CursorKind.VAR_DECL and ref.type.get_canonical().kind == TypeKind.CONSTANTARRAY \
                    and ref.type.get_canonical().element_type.get_canonical().kind == TypeKind.RECORD \
                    and ref.semantic_parent is not None and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
                out[left.spelling] = (swift_name(table.spelling), f"{swift_name(left.spelling)}Index")
            elif ref.kind == CursorKind.PARM_DECL and table.spelling in self.params_by_name and (self.params_by_name[table.spelling].swift or "").startswith("Slots<"):
                # A table parameter is a Slots, and the cursor walks it by index the same way.
                out[left.spelling] = (self.params_by_name[table.spelling].name, f"{swift_name(left.spelling)}Index")
        return out

    def operator_or_none(self, cur: ci.Cursor) -> str | None:
        """The operator of a binary node, or None where its text is not readable, for a pre-scan that must not raise."""
        try:
            return self.binary_op(cur)
        except Hole:
            return None

    def addressed_names(self, fn: ci.Cursor) -> set[str]:
        """Every local a statement takes the address of, an output a callee fills."""
        out: set[str] = set()
        for cur in fn.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind == CursorKind.UNARY_OPERATOR and kids:
                before = self.bytes[cur.extent.start.offset:kids[0].extent.start.offset].decode("utf-8", "replace").strip()
                if before == "&":
                    out.add(self.written_root(kids[0]))
        return out

    def written_root(self, cur: ci.Cursor) -> str:
        cur = self.unwrap(cur)
        while cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            cur = self.unwrap(list(cur.get_children())[0])
        return cur.spelling if cur.kind == CursorKind.DECL_REF_EXPR else ""

    def keyword(self, var: ci.Cursor, init: bool) -> str:
        name = var.spelling
        if init:
            return "let" if name not in self.single_writes_cache() else "var"
        return "let" if name in self.lets else "var"

    def single_writes_cache(self) -> set[str]:
        return self.written


    def hole(self, cur: ci.Cursor, depth: int, reason: str) -> list[str]:
        self.holes += 1
        self.hole_names |= {c.spelling for c in cur.walk_preorder() if c.kind == CursorKind.VAR_DECL}
        self.local_holes |= {c.spelling for c in cur.walk_preorder() if c.kind == CursorKind.VAR_DECL}
        pad = INDENT * depth
        raven = " ".join(self.source.slice(cur.extent).split())
        return [
            f"{pad}// Port-note: {reason}",
            f"{pad}// Raven wrote: {raven}",
            f'{pad}portMissing("{self.fn.name}", source: "{self.fn.cite}")',
        ]

    def record_bytes(self, cur: ci.Cursor, depth: int) -> list[str]:
        """Raven's `memset` and `memcpy` over a whole record, as the view's `clear()` and `copy(from:)`. A memset of a record local
        drops, because the scratch slot is zero at entry."""
        pad = INDENT * depth
        name = self.callee_name(cur)
        args = [self.strip(a) for a in list(cur.get_children())[1:]]
        if name == "memset":
            # Raven's `memset(&table, 0, sizeof(table))` over a whole storage table, which Swift holds as the Slots over it.
            whole = args[0]
            if whole.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(whole)[0] == "&":
                whole = self.strip(self.unary_parts(whole)[2])
            if self.slots_source(whole):
                return [f"{pad}{self.expr(whole)}.zero()" + self.trailing(cur)]
        targets = []
        for arg in args[: 2 if name == "memcpy" else 1]:
            if arg.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(arg)[0] == "&":
                arg = self.strip(self.unary_parts(arg)[2])
            pointee = arg.type.get_canonical().get_pointee() if arg.type.get_canonical().kind == TypeKind.POINTER else None
            if not self.is_record(arg.type) and not (pointee is not None and self.is_record(pointee)):
                raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                raise Hole(f"Raven's `{raven}` runs over bytes that are not one record with a view.")
            targets.append(arg)
        if name == "memset":
            ref = targets[0].referenced if targets[0].kind == CursorKind.DECL_REF_EXPR else None
            if ref is not None and ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None and ref.semantic_parent.kind != CursorKind.TRANSLATION_UNIT:
                return [f"{pad}// Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call."]
            return [f"{pad}{self.expr(targets[0])}.clear()" + self.trailing(cur)]
        return [f"{pad}{self.expr(targets[0])}.copy(from: {self.expr(targets[1])})" + self.trailing(cur)]

    def is_record(self, t: ci.Type) -> bool:
        """True for a C struct the views cover."""
        canonical = t.get_canonical()
        if canonical.kind != TypeKind.RECORD:
            return False
        record = self.views.record_name(canonical)
        return bool(record) and record in self.views.views

    def is_call(self, cur: ci.Cursor) -> bool:
        """A call, which the parse sometimes leaves unexposed: the first child names a function, and the rest are the arguments."""
        if cur.kind == CursorKind.CALL_EXPR:
            return True
        if cur.kind != CursorKind.UNEXPOSED_EXPR:
            return False
        kids = list(cur.get_children())
        if not kids:
            return False
        callee = self.strip(kids[0])
        ref = callee.referenced
        return callee.kind == CursorKind.DECL_REF_EXPR and ref is not None and ref.kind == CursorKind.FUNCTION_DECL

    def callee_name(self, cur: ci.Cursor) -> str | None:
        kids = list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        return callee.spelling if callee is not None and callee.kind == CursorKind.DECL_REF_EXPR else None

    def collapsed(self, cur: ci.Cursor) -> bool:
        """True when a child spans the same bytes as the node, the mark of a macro expansion, whose nodes keep no text of their own."""
        return any(k.extent.start.offset == cur.extent.start.offset and k.extent.end.offset == cur.extent.end.offset for k in cur.get_children())

    def macro_span(self, cur: ci.Cursor) -> bool:
        """True when the node's whole text is one name, so the node is a macro use and its children keep no text of their own."""
        return IDENTIFIER.fullmatch(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()) is not None

    def statement_lines(self, cur: ci.Cursor, depth: int) -> list[str]:
        pad = INDENT * depth
        if cur.kind == CursorKind.UNEXPOSED_EXPR and len(list(cur.get_children())) == 1 and not self.is_call(cur):
            return self.statement_lines(list(cur.get_children())[0], depth)
        kind = cur.kind
        if kind == CursorKind.COMPOUND_STMT:
            return [f"{pad}do {{"] + self.block_body(cur, depth + 1) + [f"{pad}}}"]
        if kind == CursorKind.DECL_STMT:
            return [pad + line for line in self.declarations(cur)]
        if kind == CursorKind.RETURN_STMT:
            kids = list(cur.get_children())
            if self.scratch_modes and self.scratch_modes[-1] == "flag":
                return [f"{pad}return true" + self.trailing(cur)]
            if not kids:
                return [f"{pad}return" + self.trailing(cur)]
            if self.is_null(kids[0]) and self.fn.returns and self.fn.returns.endswith("?"):
                return [f"{pad}return nil" + self.trailing(cur)]
            if self.is_null(kids[0]) and self.fn.returns and not self.fn.returns.endswith("?") and self.fn.returns not in ("Int32", "Float", "Bool"):
                if self.after_com_error:
                    return [f"{pad}// Raven writes `return 0` after this call, which `Com_Error` never reaches."]
                raise Hole(f"Raven returns NULL, and the function returns a `{self.fn.returns}`.")
            post = self.unwrap(kids[0])
            if post.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(post)[0] in ("++", "--") and not self.unary_parts(post)[1]:
                # Raven returns the value and then steps it, and `defer` steps it after the return reads it.
                stepped = self.unary_parts(post)[2]
                return [f"{pad}defer {{ {self.expr(stepped)} {self.unary_parts(post)[0][0]}= 1 }}",
                        f"{pad}return {self.converted(stepped, self.fn.returns)}" + self.trailing(cur)]
            if self.fn.returns == "PooledString" and self.is_raw(kids[0]):
                # Raven returns the raw allocation he filled, and the pool string is the view over it.
                return [f"{pad}return PooledString({self.expr(kids[0])})" + self.trailing(cur)]
            value = self.converted(kids[0], self.fn.returns)
            return [f"{pad}return {value}" + self.trailing(cur)]
        if kind == CursorKind.IF_STMT:
            return self.if_statement(cur, depth)
        if kind == CursorKind.WHILE_STMT:
            cond, body = list(cur.get_children())
            return [f"{pad}while {self.condition(cond)} {{"] + self.branch(body, depth + 1) + [f"{pad}}}"]
        if kind == CursorKind.DO_STMT:
            body, cond = list(cur.get_children())
            return [f"{pad}repeat {{"] + self.branch(body, depth + 1) + [f"{pad}}} while {self.condition(cond)}"]
        if kind == CursorKind.FOR_STMT:
            return self.for_statement(cur, depth)
        if kind == CursorKind.SWITCH_STMT:
            return self.switch_statement(cur, depth)
        if kind == CursorKind.BREAK_STMT:
            return [f"{pad}break" + self.trailing(cur)]
        if kind == CursorKind.CONTINUE_STMT:
            return [f"{pad}continue" + self.trailing(cur)]
        if kind == CursorKind.NULL_STMT:
            return []
        if kind == CursorKind.GOTO_STMT:
            name = next((k.spelling for k in cur.get_children()), "")
            if name in self.goto_forms:
                return [f"{pad}{self.goto_forms[name]}" + self.trailing(cur)]
            raise Hole("Raven's goto has no Swift form, and the transcriptor restructures the flow.")
        if kind == CursorKind.LABEL_STMT:
            raise Hole("Raven's label is not a statement of a block, and the transcriptor restructures the flow.")
        if kind == CursorKind.UNARY_OPERATOR:
            op, prefix, operand = self.unary_parts(cur)
            if op in ("++", "--"):
                if self.unwrap(operand).kind == CursorKind.DECL_REF_EXPR and self.unwrap(operand).spelling in self.table_cursors:
                    return [f"{pad}{self.table_cursors[self.unwrap(operand).spelling][1]} {op[0]}= 1" + self.trailing(cur)]
                return [f"{pad}{self.expr(operand)} {op[0]}= 1" + self.trailing(cur)]
        if kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
            op = self.binary_op(cur)
            if op in ASSIGNS:
                left, right = list(cur.get_children())
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.game_entities | self.optional_entities:
                    return [f"{pad}{self.expr(left)} = {self.entity_or_nil(right)}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.cursor_locals:
                    source = "JKAShared.TextCursor()" if self.is_null(right) else f"JKAShared.TextCursor({self.expr(right)})"
                    return [f"{pad}{self.expr(left)} = {source}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.text_locals \
                        and (self.is_null(right) or self.field_slot(right) is not None or self.optional_text_call(right)):
                    optional = self.unwrap(left).spelling in self.optional_texts
                    return [f"{pad}{self.expr(left)} = {self.text_value(right, optional)}" + self.trailing(cur)]
                if self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.local_holes:
                    raise Hole(f"A store into `{self.unwrap(left).spelling}`, a local the draft left as a hole.")
                if op == "=" and self.unwrap(left).kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and self.is_raw(list(self.unwrap(left).get_children())[0]):
                    raise Hole("A byte store through a raw allocation, which RawField.swift has no subscript for.")
                # 4. A byte store into a buffer takes the value as an Int32, which the CharBuf setter narrows.
                if op == "=" and self.unwrap(left).kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and self.is_charbuf(list(self.unwrap(left).get_children())[0]):
                    return [f"{pad}{self.expr(left)} = {self.converted(right, 'Int32')}" + self.trailing(cur)]
                # 5. A trap that fills a buffer returns the count and the text, and the buffer takes the text.
                tuple_call = self.tuple_call(right)
                if op == "=" and tuple_call is not None:
                    call, buffer = tuple_call
                    return [f"{pad}let filled = {call}", f"{pad}{self.expr(left)} = filled.0", f"{pad}{buffer} = JKAShared.CharBuf(filled.1)"]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.table_cursors:
                    table, index = self.table_cursors[self.unwrap(left).spelling]
                    source = self.unwrap(right)
                    offset = "0"
                    if source.kind == CursorKind.BINARY_OPERATOR and self.binary_op(source) == "+":
                        offset = self.converted(list(source.get_children())[1], "Int32")
                    return [f"{pad}{index} = {offset}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.aliases:
                    # The store that names the alias has no effect of its own, and the comment beside it stays.
                    rest = self.trailing(cur).strip()
                    return [f"{pad}{rest}"] if rest else []
                raw = self.raw_store(left)
                if raw is not None:
                    # Raven's `*(int *)(b+f->ofs) = v` is the labeled subscript of the raw pointer, one per C type, by RawField.swift.
                    base_text, label, ofs, index = raw
                    swift = {"int": "Int32", "float": "Float"}.get(label)
                    value = self.converted(right, swift) if swift else self.expr(right)
                    slot = f"{base_text}[{label}: {ofs}, {index}]" if index is not None else f"{base_text}[{label}: {ofs}]"
                    return [f"{pad}{slot} {op} {value}" + self.trailing(cur)]
                if self.unwrap(left).kind == CursorKind.MEMBER_REF_EXPR:
                    fields, root, base_cur = self.game_chain(self.unwrap(left))
                    if root is not None and not self.sk.table.own_field(root, fields):
                        write = self.reads.get((root, tuple(fields), True))
                        if write is None or op != "=":
                            raise Hole(f"Raven writes the game's `{'.'.join(fields)}` here, and the channel has no set for it.")
                        head = (self.expr(base_cur) + ("!" if self.optional_base(base_cur) else "") + ", ") if root == "entity" else ""
                        return [f"{pad}{write.name}({head}{self.converted(right, write.swift)})" + self.trailing(cur)]
                if self.float_field(self.strip(left)) and self.is_pointer(right):
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven stores a pointer into the `float *` field with `{raven}`, and rule 11 keeps a pointer out of a logic target.")
                buffer = self.char_buffer(left)
                if buffer is not None:
                    # Raven's `name[0] = 0` empties a character buffer the view holds as a String.
                    if op == "=" and self.is_null(right) and self.is_null(list(self.strip(left).get_children())[1]):
                        return [f"{pad}{self.member(buffer)} = \"\"" + self.trailing(cur)]
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven writes `{raven}` into a character buffer the view holds as a String.")
                if op == "=" and self.slots_target(left):
                    source = self.slots_expression(right)
                    if source is None:
                        raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                        raise Hole(f"Raven stores `{raven}`, and Swift holds the target as the Slots over the records where the source is one record.")
                    return [f"{pad}{self.expr(left)} = {source}" + self.trailing(cur)]
                if op == "=" and self.slots_expression(right) is not None and self.slots_member(left) is not None:
                    # Raven stores the table back into the field he indexes, and the field's Slots accessor takes it.
                    return [f"{pad}{self.slots_member(left)} = {self.slots_expression(right)}" + self.trailing(cur)]
                if op == "=" and self.view_operand(left) and not self.optional_base(left) and self.optional_base(right):
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven stores `{raven}`, and the view holds the source as an optional where the target takes a value. A never-null ruling is due.")
                if op == "=" and self.slots_source(right):
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven stores `{raven}`, and Swift holds the source as a Slots where the target takes one record. A Slots ruling is due.")
                target = self.expr(left)
                inner = self.strip(right)
                if op == "=" and inner.kind == CursorKind.BINARY_OPERATOR and not self.macro_span(inner) and self.binary_op(inner) == "=":
                    # Raven's `a = b = 0` sets b, then a from b, so the draft writes the two stores in that order.
                    lines = self.statement_lines(inner, depth)
                    lines.append(f"{pad}{target} = {self.expr(list(inner.get_children())[0])}" + self.trailing(cur))
                    return lines
                if self.strip(left).type.get_canonical().kind == TypeKind.RECORD:
                    if op == "=" and self.is_record(left.type) and self.is_record(right.type):
                        # Raven's `a = b` on two records is a byte copy, and the view's `copy(from:)` is that copy. His `*p` is the view p holds.
                        source = self.unwrap(right)
                        if source.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(source)[0] == "*":
                            source = self.unary_parts(source)[2]
                        return [f"{pad}{self.expr(left)}.copy(from: {self.base(source)})" + self.trailing(cur)]
                    raise Hole("A whole-record store, which a view has no operator for.")
                lhs_kind = self.swift_type_of(left)
                unsigned = self.unsigned_of(left)
                if op == "=" and lhs_kind == "Int32" and self.has_double_literal(right):
                    # C computes the double expression and truncates at the store, by "A double literal".
                    return [f"{pad}{target} = Int32({self.wrapped(right, 'Double')})" + self.trailing(cur)]
                if op != "=" and lhs_kind == "Int32" and self.has_double_literal(right):
                    return [f"{pad}{target} = Int32(Double({target}) {op[:-1]} {self.wrapped(right, 'Double')})" + self.trailing(cur)]
                if op != "=" and lhs_kind == "Int32" and self.number_kind(self.strip(right).type) == "Float":
                    # C computes in float and truncates at the store.
                    return [f"{pad}{target} = Int32(Float({target}) {op[:-1]} {self.expr(right)})" + self.trailing(cur)]
                if unsigned is not None and not self.is_literal(right):
                    return [f"{pad}{target} {op} {self.wrapped(right, unsigned)}" + self.trailing(cur)]
                if op == "=" and lhs_kind == "Int32" and self.unsigned_of(right) == "UInt32":
                    # C computes in unsigned and stores the bit pattern, `(size + 3) & 0xfffffffc`.
                    return [f"{pad}{target} = Int32(bitPattern: {self.wrapped(right, 'UInt32')})" + self.trailing(cur)]
                value = self.converted(right, lhs_kind) if op == "=" else self.expr(right)
                return [f"{pad}{target} {op} {value}" + self.trailing(cur)]
        if self.is_call(cur) and self.callee_name(cur) in RECORD_CALLS:
            return self.record_bytes(cur, depth)
        if self.is_call(cur) and self.callee_name(cur) in DROPPED:
            # `assert` is `((void)0)` under Raven's NDEBUG build, so the body drops it, by "assert".
            rest = self.trailing(cur).strip()
            return [f"{pad}{rest}"] if rest else []
        if self.is_call(cur) and self.aliased_inouts(cur):
            aliased = self.aliased_inouts(cur)
            self.slot_copies = {f"{i}:{text}": local for i, text, local in aliased}
            self.aliased_positions = {i: local for i, _, local in aliased}
            try:
                call = self.expr(cur)
            finally:
                self.slot_copies = {}
                self.aliased_positions = {}
            inner_pad = INDENT * (depth + 1)
            note = f"{pad}// Raven passes `{aliased[0][1]}` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy."
            before = [f"{inner_pad}var {local} = {text}" for _, text, local in aliased]
            return [note, f"{pad}do {{"] + before + [f"{inner_pad}{call}" + self.trailing(cur), f"{pad}}}"]
        if self.is_call(cur):
            copies = self.overlapping_slots(cur)
            if copies:
                # Swift refuses two inout slots of one array in one call, so each slot goes through a copy and comes back after.
                self.slot_copies = {text: local for text, local in copies}
                try:
                    call = self.expr(cur)
                finally:
                    self.slot_copies = {}
                inner_pad = INDENT * (depth + 1)
                before = [f"{inner_pad}var {local} = {text}" for text, local in copies]
                after = [f"{inner_pad}{text} = {local}" for text, local in copies]
                return [f"{pad}do {{"] + before + [f"{inner_pad}{call}" + self.trailing(cur)] + after + [f"{pad}}}"]
            return [f"{pad}{self.expr(cur)}" + self.trailing(cur)]
        if kind.is_expression():
            raise Hole("An expression statement with no effect the draft knows.")
        raise Hole(f"No rule for a {kind.name} statement.")

    def branch(self, cur: ci.Cursor, depth: int) -> list[str]:
        """The body of a control statement as block lines, whether Raven wrote braces or a lone statement."""
        if cur.kind == CursorKind.COMPOUND_STMT:
            return self.block_body(cur, depth)
        return self.statement(cur, depth)

    def if_statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        pad = INDENT * depth
        kids = list(cur.get_children())
        cond, then = kids[0], kids[1]
        test = self.condition(cond)
        if test == "false":
            # The guard folded away, so its arm never runs, and only the else arm stays.
            self.pending.append("// Raven's arm under the guard has no path, and its text stays here:")
            self.pending += self.commented(then)
            return self.branch(kids[2], depth) if len(kids) == 3 else []
        if test == "true":
            if len(kids) == 3:
                self.pending.append("// Raven's else arm has no path, and its text stays here:")
                self.pending += self.commented(kids[2])
            return self.branch(then, depth)
        out = [f"{pad}if {test} {{"] + self.branch(then, depth + 1)
        if len(kids) == 3:
            other = kids[2]
            # Raven's comment between the then arm's brace and his `else` has no seat there in Swift, so it opens the else arm.
            between = [line for line in self.gap(then.extent.end.line, other.extent.start.line, depth + 1) if line.strip()]
            if other.kind == CursorKind.IF_STMT:
                nested = self.if_statement(other, depth)
                if nested and nested[0].strip().startswith("if "):
                    out.append(f"{pad}}} else {nested[0].strip()}")
                    out += between + nested[1:]
                    return out
                # The nested if folded to one arm, so the arm is the else block.
                out.append(f"{pad}}} else {{")
                out += between + [INDENT + line if line.strip() else line for line in nested]
                out.append(f"{pad}}}")
                return out
            out.append(f"{pad}}} else {{")
            out += between + self.branch(other, depth + 1)
        out.append(f"{pad}}}")
        return out

    def commented(self, cur: ci.Cursor) -> list[str]:
        """Raven's text of a statement as comment lines, for an arm the draft leaves out."""
        text = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
        return [f"// {line.rstrip()}".rstrip() for line in text.replace("\t", "    ").splitlines()]

    def for_statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        """Raven's three clauses by their place between the two semicolons of the head, then `init; while cond { body; step }`."""
        pad = INDENT * depth
        kids = list(cur.get_children())
        body = kids[-1]
        head = [t for t in cur.get_tokens() if t.extent.start.offset < body.extent.start.offset]
        semis = []
        depth_parens = 0
        for t in head:
            if t.spelling == "(":
                depth_parens += 1
            elif t.spelling == ")":
                depth_parens -= 1
            elif t.spelling == ";" and depth_parens == 1:
                semis.append(t.extent.start.offset)
        if len(semis) != 2:
            raise Hole("The for head has no two semicolons the draft can find.")
        init = cond = step = None
        for k in kids[:-1]:
            start = k.extent.start.offset
            if start < semis[0]:
                init = k
            elif start < semis[1]:
                cond = k
            else:
                step = k
        out: list[str] = []
        if init is not None:
            out += self.statement(init, depth)
        test = self.condition(cond) if cond is not None else "true"
        out.append(f"{pad}while {test} {{")
        inner = self.branch(body, depth + 1)
        if any(line.strip() == "continue" or line.strip().startswith("continue ") for line in inner):
            out.append(f"{INDENT * (depth + 1)}// Port-note: Raven's loop has a continue, and the step below does not run for it. The transcriptor moves the step.")
        out += inner
        if step is not None:
            out += self.statement(step, depth + 1)
        out.append(f"{pad}}}")
        return out

    def switch_statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        """Raven's cases as Swift cases. A case with no break at its end falls through to the next case."""
        pad = INDENT * depth
        subject, body = list(cur.get_children())
        if body.kind != CursorKind.COMPOUND_STMT:
            raise Hole("The switch body is not a block.")
        groups: list[tuple[list[str], list[ci.Cursor], int]] = []
        for child in body.get_children():
            labels: list[str] = []
            stmt = child
            label_line = child.extent.start.line
            while stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT):
                inner = list(stmt.get_children())
                label_line = stmt.extent.start.line
                if stmt.kind == CursorKind.CASE_STMT:
                    labels.append(self.expr(inner[0]))
                    stmt = inner[-1]
                else:
                    labels.append("default")
                    stmt = inner[0]
            if labels:
                groups.append((labels, [], label_line))
            if not groups:
                raise Hole("A statement before the first case of the switch.")
            if stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT) or stmt is child and labels and stmt.kind == CursorKind.NULL_STMT:
                continue
            groups[-1][1].append(stmt)
        out = [f"{pad}switch {self.expr(subject)} {{"]
        if groups:
            # Raven's comment between the switch's brace and his first case, `//case WP_NONE:`, stays above the first case.
            out += [line for line in self.gap(body.extent.start.line, groups[0][2], depth) if line.strip()]
        # Each group is one arm, so Raven's `default:` before his other cases moves to the end of the switch as a whole arm.
        arms: list[list[str]] = []
        default_at = next((i for i, (labels, _, _) in enumerate(groups) if "default" in labels), None)
        for i, (labels, stmts, label_line) in enumerate(groups):
            label = "default" if labels == ["default"] else "case " + ", ".join(l for l in labels if l != "default")
            if "default" in labels and len(labels) > 1:
                label = "default"
            ends_in_break = bool(stmts) and stmts[-1].kind == CursorKind.BREAK_STMT
            ends_in_exit = bool(stmts) and stmts[-1].kind in (CursorKind.RETURN_STMT, CursorKind.CONTINUE_STMT)
            inner_stmts = stmts[:-1] if ends_in_break else stmts
            lines: list[str] = []
            previous_line = label_line
            for s in inner_stmts:
                lines += self.gap(previous_line, s.extent.start.line, depth + 1)
                lines += self.statement(s, depth + 1)
                previous_line = s.extent.end.line
            if not inner_stmts and stmts:
                # The case holds only its break, and Raven's comment above the break stays.
                lines += [line for line in self.gap(label_line, stmts[0].extent.start.line, depth + 1) if line.strip()]
            while lines and not lines[0].strip():
                lines.pop(0)
            if i + 1 < len(groups):
                # Raven's comment after the case's last statement, or between two labels, stays with the case.
                last = stmts[-1].extent.end.line if stmts else label_line
                lines += [line for line in self.gap(last, groups[i + 1][2], depth + 1) if line.strip()]
            if not ends_in_break and not ends_in_exit and i + 1 < len(groups):
                lines.append(f"{INDENT * (depth + 1)}fallthrough")
            if not any(line.strip() and not line.strip().startswith("//") for line in lines):
                # A case with comments alone still needs its break.
                lines.append(f"{INDENT * (depth + 1)}break")
            arms.append([f"{pad}{label}:"] + lines)
        if default_at is not None and default_at + 1 < len(arms):
            # Swift takes no case after the default block. A fall-through beside the default has no order that keeps it, so it stays a hole.
            neighbors = [arms[default_at]] + ([arms[default_at - 1]] if default_at else [])
            if any(line.strip() == "fallthrough" for arm in neighbors for line in arm):
                raise Hole("Raven's `default:` comes before his other cases, and a case falls through beside it.")
            arms.append(arms.pop(default_at))
        for i, arm in enumerate(arms):
            out += arm
            if i + 1 < len(arms):
                out.append("")
        if default_at is None:
            out += ["", f"{pad}default:", f"{INDENT * (depth + 1)}break"]
        out.append(f"{pad}}}")
        return out

    def declarations(self, cur: ci.Cursor) -> list[str]:
        out: list[str] = []
        for var in cur.get_children():
            if var.kind != CursorKind.VAR_DECL:
                raise Hole(f"A {var.kind.name} inside a declaration.")
            try:
                line = self.declaration(var)
                if line:
                    out.append(line)
            except Hole as hole:
                self.holes += 1
                self.hole_names.add(var.spelling)
                self.local_holes.add(var.spelling)
                raven = " ".join(self.bytes[var.extent.start.offset:var.extent.end.offset].decode("utf-8", "replace").split())
                out += [f"// Port-note: {hole}", f"// Raven wrote: {raven};", f'portMissing("{self.fn.name}", source: "{self.fn.cite}")']
        return out

    def declaration(self, var: ci.Cursor) -> str:
        name = swift_name(var.spelling)
        t = var.type
        init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
        keyword = self.keyword(var, bool(init))
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t):
            if not init:
                return f"var {name} = JKAShared.vec3_t(0, 0, 0)"
            return f"var {name} = {self.vector_literal(init[0])}"
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t.element_type):
            # `vec3_t axis[3]` is an array of vectors, each at zero.
            count = t.get_canonical().element_count
            if init:
                raise Hole("An array of vectors with an initializer.")
            return f"var {name}: [JKAShared.vec3_t] = [{', '.join(['JKAShared.vec3_t(0, 0, 0)'] * count)}]"
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY and t.get_canonical().element_type.get_canonical().kind == TypeKind.CHAR_S:
            # Raven's `char name[N]` is a CharBuf of N bytes, and his string initializer fills it.
            count = t.get_canonical().element_count
            if init and self.unwrap(init[0]).kind == CursorKind.STRING_LITERAL:
                return f"var {name} = JKAShared.CharBuf({self.literal(self.unwrap(init[0]))})"
            if init and self.unwrap(init[0]).kind == CursorKind.INIT_LIST_EXPR and all(self.is_null(k) for k in self.unwrap(init[0]).get_children()):
                # Raven's `{ 0 }` zeroes the buffer, which a fresh CharBuf is.
                return f"var {name} = JKAShared.CharBuf({count})"
            if init:
                raise Hole("A char array local with an initializer that is not a string.")
            return f"var {name} = JKAShared.CharBuf({count})"
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY:
            return self.array_declaration(var, init)
        if t.get_canonical().kind == TypeKind.POINTER and t.get_canonical().get_pointee().get_canonical().kind == TypeKind.CHAR_S and init:
            source = self.unwrap(init[0])
            if source.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(source)[0] == "&":
                slot = self.unwrap(self.unary_parts(source)[2])
                if slot.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and self.is_charbuf(list(slot.get_children())[0]):
                    # Raven's `char *start = &buf[i]` is the tail of the buffer from that byte.
                    base, index = list(slot.get_children())
                    self.charbuf_locals.add(var.spelling)
                    return f"{keyword} {name}: JKAShared.CharBuf = {self.expr(base)}[({self.converted(index, 'Int32')})...]"
            if source.kind == CursorKind.STRING_LITERAL:
                return f"{keyword} {name}: String = {self.literal(source)}"
        if t.get_canonical().kind == TypeKind.POINTER and t.get_canonical().get_pointee().get_canonical().kind == TypeKind.VOID:
            # Raven's `void *` local is an opaque handle the engine fills.
            return f"var {name}: OpaquePointer? = {self.expr(init[0]) if init else 'nil'}"
        if t.get_canonical().kind == TypeKind.POINTER and self.alias_target(var) is not None:
            # Raven's `float *vel = pm->ps->velocity` names a vector, so every read of `vel` goes to the vector and the local drops.
            self.aliases[var.spelling] = self.alias_target(var)
            return ""
        if var.spelling in self.table_cursors:
            table, index = self.table_cursors[var.spelling]
            return f"var {index}: Int32 = 0"
        if var.spelling in self.raw_locals:
            return f"{keyword} {name}: UnsafeMutableRawPointer" + (f" = {self.expr(init[0])}" if init else "")
        if var.spelling in self.text_locals:
            # A text local Raven stores his NULL into is an optional text, and `nil` is that NULL.
            # His NULL into any other one is the empty text, because the parser never hands NULL back.
            optional = var.spelling in self.optional_texts
            value = self.text_value(init[0], optional) if init else ("nil" if optional else None)
            if value is None and self.filled_by_address(var.spelling):
                # Raven leaves the pointer unset until a parser fills it by address, and an inout pass needs a first value.
                value = '""'
            swift = "String?" if optional else "String"
            keyword = "var" if optional else keyword
            return f"{keyword} {name}: {swift}" + (f" = {value}" if value is not None else "")
        if var.spelling in self.cursor_locals:
            # A cursor starts NULL until a store points it at a buffer, so the buffer's own declaration can come later.
            if init and not self.is_null(init[0]):
                return f"var {name} = JKAShared.TextCursor({self.expr(self.unwrap(init[0]))})"
            return f"var {name} = JKAShared.TextCursor()"
        if t.get_canonical().kind == TypeKind.POINTER:
            record = self.views.record_name(t.get_canonical().get_pointee())
            if record == "gentity_t" and target_of(self.fn.stem) == BG:
                # Raven's `gentity_t *` local in a bg file is the bg entity it came from, and the game's fields go through the channel.
                if not init:
                    self.optional_entities.add(var.spelling)
                    return f"var {name}: JKAMP.BgEntity?"
                source = self.unwrap(init[0])
                if source.kind == CursorKind.CONDITIONAL_OPERATOR:
                    # Raven's `t ? &g_entities[n] : NULL` is an optional entity.
                    test, yes, no = list(source.get_children())
                    self.optional_entities.add(var.spelling)
                    return f"{keyword} {name}: JKAMP.BgEntity? = {self.condition(test)} ? {self.entity_or_nil(yes)} : {self.entity_or_nil(no)}"
                if self.is_null(source):
                    self.optional_entities.add(var.spelling)
                    return f"var {name}: JKAMP.BgEntity? = nil"
                self.game_entities.add(var.spelling)
                return f"{keyword} {name}: JKAMP.BgEntity = {self.game_entity(init[0])}"
            if record and record in self.views.views:
                self.reachable(record)
                view = self.views.qualified_view(record, TARGET)
                if var.spelling in self.slots_locals:
                    # Every store into the local holds a table of records, so the local is the Slots over it.
                    if init:
                        return f"{keyword} {name}: Slots<{view}> = {self.slots_expression(init[0])}"
                    return f"var {name}: Slots<{view}>"
                if init:
                    return f"{keyword} {name}: {view}? = {self.expr(init[0])}"
                return f"var {name}: {view}?"
            raise Hole(f"A pointer local `{t.spelling} {var.spelling}` with no view.")
        swift = self.views.scalar(t, TARGET)
        if swift is None:
            raise Hole(f"A local `{t.spelling} {var.spelling}` the table has no type for.")
        if self.views.narrow(t) is not None:
            swift = "Int32"
        if init:
            return f"{keyword} {name}: {swift} = {self.converted(init[0], swift)}"
        if self.has_scratch or var.spelling in self.addressed:
            # Swift refuses a closure capture or an inout pass of a local with no value, where C reads whatever the stack held,
            # so the local starts at zero. The zero is the divergence rule 19 allows.
            return f"{keyword} {name}: {swift} = {'false' if swift == 'Bool' else '0'}"
        return f"{keyword} {name}: {swift}"

    def field_slot(self, cur: ci.Cursor) -> tuple[ci.Cursor, ci.Cursor | None] | None:
        """Raven's `x->name` or his `&x->name[n]` on a `char name[N]` field, as the field and the byte its text starts at, or None."""
        inner = self.unwrap(cur)
        if self.string_field(inner):
            return inner, None
        if inner.kind != CursorKind.UNARY_OPERATOR or self.unary_parts(inner)[0] != "&":
            return None
        slot = self.unwrap(self.unary_parts(inner)[2])
        if slot.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return None
        base, index = list(slot.get_children())
        base = self.unwrap(base)
        return (base, index) if self.string_field(base) else None

    def optional_text_call(self, cur: ci.Cursor) -> bool:
        """True when the expression is a call that hands an optional text back, the shape of a `char *` return Raven sets to NULL."""
        inner = self.strip(cur)
        if not self.is_call(inner):
            return False
        return self.registry.returns.get(self.callee_name(inner) or "") == "String?"

    def text_value(self, cur: ci.Cursor, optional: bool) -> str:
        """Raven's source for a String local: his NULL, the text of a `char name[N]` field, or the expression as it is."""
        inner = self.unwrap(cur)
        if self.is_null(inner):
            return "nil" if optional else '""'
        if not optional and self.optional_text_call(inner):
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven stores `{raven}`, and the callee hands an optional text back where the target takes a value. "
                       "A never-null ruling is due.")
        slot = self.field_slot(inner)
        if slot is None:
            return self.expr(inner)
        field, index = slot
        if index is None or self.is_null(index):
            return self.expr(field)
        return f"String({self.expr(field)}.dropFirst(Int({self.converted(index, 'Int32')})))"

    def text_tail(self, cur: ci.Cursor) -> str | None:
        """Raven's `&token[n]` on a String, the text from the nth byte, or None."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.UNARY_OPERATOR or self.unary_parts(inner)[0] != "&":
            return None
        slot = self.unwrap(self.unary_parts(inner)[2])
        if slot.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return None
        base, index = list(slot.get_children())
        base = self.unwrap(base)
        if base.kind != CursorKind.DECL_REF_EXPR:
            return None
        param = self.params_by_name.get(base.spelling)
        if base.spelling in self.text_locals or (param is not None and param.kind == "cstring"):
            return f"String({self.expr(base)}.dropFirst(Int({self.converted(index, 'Int32')})))"
        return None

    def entity_or_nil(self, cur: ci.Cursor) -> str:
        return "nil" if self.is_null(cur) else self.game_entity(cur)

    def entity_slot(self, cur: ci.Cursor) -> str | None:
        """Raven's `&g_entities[num]` as the pmove's stride walk, or None."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            slot = self.unwrap(self.unary_parts(inner)[2])
            if slot.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
                base, index = list(slot.get_children())
                if self.unwrap(base).spelling == "g_entities":
                    return f"pm.entity(at: {self.converted(index, 'Int32')})"
        return None

    def game_entity(self, cur: ci.Cursor) -> str:
        """The bg entity behind Raven's `(gentity_t *)bgEnt` or his `&g_entities[num]`, by the hole walk's row 1."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.CSTYLE_CAST_EXPR:
            operand = [k for k in inner.get_children() if k.kind.is_expression()][-1]
            return self.expr(operand) + ("!" if self.optional_base(operand) else "")
        slot = self.entity_slot(inner)
        if slot is not None:
            # The game's entity table at an index is the pmove's stride walk, the same slot.
            return slot
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.game_entities | self.optional_entities:
            return self.expr(inner) + ("!" if inner.spelling in self.optional_entities else "")
        raise Hole("A game entity from an expression that is not a cast of a bg entity or a slot of `g_entities`.")

    def game_chain(self, cur: ci.Cursor) -> tuple[list[str], str | None, ci.Cursor]:
        """The field path of a member chain in a bg body, its root kind when the root is the game's, and the root expression."""
        fields, root = self.sk.table.chain(cur, set())
        base = cur
        while base.kind == CursorKind.MEMBER_REF_EXPR:
            base = self.unwrap(list(base.get_children())[0])
        return fields, root if target_of(self.fn.stem) == BG else None, base

    def game_read(self, cur: ci.Cursor, fields: list[str], root: str, base: ci.Cursor) -> str:
        """A read of a game field from a bg body: the bg view's own field, or the channel's callback for it."""
        kids = list(cur.get_children())
        if root == "entity":
            head = self.expr(base) + ("!" if self.optional_base(base) else "")
            if base.kind == CursorKind.DECL_REF_EXPR and base.spelling in self.optional_entities:
                head = self.expr(base) + "!"
            if fields[0] in self.sk.table.own_fields():
                return f"{self.base(kids[0])}.{swift_name(cur.spelling)}"
            if fields == ["client"]:
                # Raven's `client` on a bg entity is the player state the bg view holds, set for every client.
                return f"{head}.playerState"
            if fields == ["client", "ps"]:
                return f"{head}.playerState!"
            if fields[:2] == ["client", "ps"]:
                return f"{self.base(kids[0])}.{swift_name(cur.spelling)}"
            args = head
        else:
            args = ""
        read = self.reads.get((root, tuple(fields), False))
        if read is None:
            raise Hole(f"Raven reaches the game's `{'.'.join(fields)}` here, and the channel has no read for it.")
        return f"{read.name}({args})"

    def array_declaration(self, var: ci.Cursor, init: list[ci.Cursor]) -> str:
        """A local array of scalars, `static int movementOffsets[8] = { ... }`, as a Swift array. A static array nothing writes is
        a constant table, the same value on every call, and a static array a statement writes is storage that outlives the call."""
        name = swift_name(var.spelling)
        t = var.type.get_canonical()
        element = self.views.scalar(t.element_type, TARGET)
        if element is None:
            raise Hole(f"A local `{var.type.spelling} {var.spelling}` the table has no type for.")
        if self.views.narrow(t.element_type) is not None:
            element = "Int32"
        written = var.spelling in self.written
        if var.storage_class == ci.StorageClass.STATIC and written:
            raise Hole(f"A static local `{var.spelling}` a statement writes, storage that outlives the call.")
        keyword = "var" if written else "let"
        if not init:
            zero = "false" if element == "Bool" else "0"
            return f"var {name}: [{element}] = [{element}](repeating: {zero}, count: {t.element_count})"
        inner = self.unwrap(init[0])
        if inner.kind != CursorKind.INIT_LIST_EXPR:
            raise Hole("An array local with an initializer that is not a list.")
        words = [self.converted(k, element) for k in inner.get_children()]
        words += ["0"] * (t.element_count - len(words))
        return f"{keyword} {name}: [{element}] = [{', '.join(words)}]"

    def alias_target(self, var: ci.Cursor) -> ci.Cursor | None:
        """The one vector a pointer-to-float local stands for: its only store is a `vec3_t`, and no statement takes its address."""
        t = var.type.get_canonical()
        if t.kind != TypeKind.POINTER or t.get_pointee().get_canonical().kind != TypeKind.FLOAT:
            return None
        init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
        stores = [self.unwrap(init[0])] if init else []
        for cur in self.fn.cur.walk_preorder():
            kids = list(cur.get_children())
            if cur.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2 and not self.collapsed(cur) and self.operator_or_none(cur) == "=":
                left = self.unwrap(kids[0])
                if left.kind == CursorKind.DECL_REF_EXPR and left.referenced is not None and left.referenced == var:
                    stores.append(self.unwrap(kids[1]))
            if cur.kind == CursorKind.UNARY_OPERATOR and kids and self.unary_parts(cur)[0] == "&":
                inner = self.unwrap(kids[0])
                if inner.kind == CursorKind.DECL_REF_EXPR and inner.referenced is not None and inner.referenced == var:
                    return None
        if len(stores) != 1 or not self.views.is_vec3(stores[0].type):
            return None
        return stores[0]

    def vector_literal(self, cur: ci.Cursor) -> str:
        """Raven's `{ 0, 0, 0 }` or `{0}` as the vector, with the members he left out at zero."""
        cur = self.unwrap(cur)
        if cur.kind != CursorKind.INIT_LIST_EXPR:
            raise Hole("A vector local with an initializer that is not a list.")
        words = [self.expr(k) for k in cur.get_children()]
        if len(words) > 3:
            raise Hole("A vector initializer with more than three members.")
        words += ["0"] * (3 - len(words))
        return f"JKAShared.vec3_t({', '.join(words)})"

    # MARK: - Expressions

    def strip(self, cur: ci.Cursor) -> ci.Cursor:
        """The expression under the implicit casts Clang wraps around it."""
        while cur.kind == CursorKind.UNEXPOSED_EXPR:
            kids = list(cur.get_children())
            if len(kids) != 1:
                break
            cur = kids[0]
        return cur

    def swift_type_of(self, cur: ci.Cursor) -> str | None:
        """`Bool` for a qboolean, `Float` or `Int32` for a number, so a store converts its right side as C does."""
        if self.is_bool(cur):
            return "Bool"
        return self.number_kind(self.strip(cur).type)

    def number_kind(self, t: ci.Type) -> str | None:
        kind = t.get_canonical().kind
        if kind in (TypeKind.FLOAT, TypeKind.DOUBLE):
            return "Float"
        if kind in INT_KINDS or kind in (TypeKind.ENUM, TypeKind.CHAR_S, TypeKind.SCHAR, TypeKind.UCHAR, TypeKind.CHAR_U):
            return "Int32"
        return None

    def is_literal(self, cur: ci.Cursor) -> bool:
        """A number Raven spelled as digits, which Swift types by context. A macro name is a typed constant, not a literal."""
        inner = self.unwrap(cur)
        text = self.bytes[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace").strip()
        return NUMBER.fullmatch(text) is not None

    def converted(self, cur: ci.Cursor, swift: str) -> str:
        """An expression stored where Swift wants `swift`: `Float(x)` for an integer into a float, `Int32(x)` the other way,
        and a literal or a matching kind as it is."""
        have = self.number_kind(self.strip(cur).type)
        if swift in ("Float", "Int32") and self.is_bool(cur):
            text = self.expr(cur)
            if text in ("true", "false"):
                return "1" if text == "true" else "0"
            return f"({text} ? 1 : 0)"
        if swift in ("Float", "Int32") and have is not None and have != swift and not self.is_literal(cur):
            return f"{swift}({self.expr(cur)})"
        if swift == "Int32" and self.unsigned_of(cur) is not None and self.unwrap(cur).kind in self.NAMED_LEAVES:
            # C passes an unsigned int where an int is due, and the bits stay the same.
            return f"Int32(bitPattern: {self.expr(cur)})" if self.unsigned_of(cur) == "UInt32" else f"Int32(truncatingIfNeeded: {self.expr(cur)})"
        return self.coerced(cur, swift)

    def empty_test(self, cur: ci.Cursor) -> str | None:
        """The Swift name of a String parameter under Raven's `s[0]`, or None."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return None
        base, index = list(inner.get_children())
        base = self.unwrap(base)
        if not self.is_null(index):
            return None
        if base.kind == CursorKind.MEMBER_REF_EXPR and self.pooled_field(base):
            return f"{self.expr(base)}!.string"
        if base.kind == CursorKind.MEMBER_REF_EXPR and self.string_field(base):
            return self.expr(base)
        if base.kind != CursorKind.DECL_REF_EXPR:
            return None
        if base.spelling in self.text_locals:
            return self.expr(base) + ("!" if base.spelling in self.optional_texts else "")
        param = self.params_by_name.get(base.spelling)
        if param is None:
            return None
        if param.kind == "cstring":
            return self.names[base.spelling]
        if param.kind != "cstring_opt":
            return None
        # An optional text reads its bytes under the NULL test Raven wrote beside this one.
        return self.names[base.spelling] + "!"

    def is_charbuf(self, cur: ci.Cursor) -> bool:
        """True for a local or parameter Swift holds as a CharBuf: Raven's `char name[N]` or a `char *` he rewrites in place."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        param = self.params_by_name.get(inner.spelling)
        if param is not None:
            return param.kind == "inout_charbuf"
        if inner.spelling in self.charbuf_locals:
            return True
        t = inner.type.get_canonical()
        return t.kind == TypeKind.CONSTANTARRAY and t.element_type.get_canonical().kind == TypeKind.CHAR_S

    def is_bool(self, cur: ci.Cursor) -> bool:
        """True when the expression already is a Swift Bool: a comparison, a logical operator, a `!`, qtrue, qfalse, or a qboolean."""
        cur = self.strip(cur)
        if self.collapsed(cur):
            return cur.type.spelling.replace("const ", "") == "qboolean"
        if cur.kind == CursorKind.PAREN_EXPR:
            return self.is_bool(list(cur.get_children())[0])
        if cur.kind == CursorKind.BINARY_OPERATOR:
            return self.binary_op(cur) in COMPARISONS | LOGICAL
        if cur.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(cur)[0] == "!":
            return True
        if cur.kind == CursorKind.DECL_REF_EXPR and cur.spelling in ("qtrue", "qfalse"):
            return True
        if cur.kind == CursorKind.CALL_EXPR and self.registry.returns.get(self.callee_name(cur) or "") == "Bool":
            return True
        return cur.type.spelling.replace("const ", "") == "qboolean"

    def is_pointer(self, cur: ci.Cursor) -> bool:
        return self.strip(cur).type.get_canonical().kind == TypeKind.POINTER

    def condition(self, cur: ci.Cursor) -> str:
        """A C truth test as a Swift Bool: a Bool as it is, a pointer against nil, a number against 0."""
        if self.empty_test(cur) is not None:
            return f"!{self.empty_test(cur)}.isEmpty"
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.cursor_locals:
            return f"!{self.expr(inner)}.isNull"
        if self.string_field(inner):
            # Raven's truth test on a char array is a test on its first byte, and the String's emptiness is that test.
            return f"!{self.expr(inner)}.isEmpty"
        return self.coerced(cur, "Bool")

    def always_set(self, cur: ci.Cursor) -> str | None:
        """Raven's name for a pointer Swift holds as a value, when a truth test on it has no Swift form."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            return self.bytes[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace")
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.text_locals and inner.spelling not in self.optional_texts:
            return inner.spelling
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.params_by_name:
            kind = self.params_by_name[inner.spelling].kind
            swift = self.params_by_name[inner.spelling].swift or ""
            if swift.startswith("inout ") or kind in ("view", "vec3_const", "cstring", "slots"):
                return inner.spelling
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in NEVER_NULL_VARS:
            return inner.spelling
        return None

    def proven_never_null(self, cur: ci.Cursor) -> bool:
        """True when the sweeps prove the name under Raven's NULL test is never NULL, so the fold needs no Port-note.

        The two proved shapes are a text local the text-local rule already made non-optional, and a parameter the NULL sweep cleared.
        Any other shape is unknown, and the fold keeps its Port-note."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        if inner.spelling in self.text_locals:
            return inner.spelling not in self.optional_texts
        if inner.spelling in self.params_by_name:
            return self.sk.table.never_null(self.fn.cur.spelling, inner.spelling)
        return False

    def null_fold_note(self, cur: ci.Cursor, name: str, port_note: str) -> str:
        """The line the fold of a NULL test leaves above the statement.

        A name the sweeps prove takes a plain comment, because the fold is then the whole answer and no transcriptor has work here.
        A name they cannot prove keeps the Port-note the caller hands over, so the hole stands until a caller of the function is read."""
        if self.proven_never_null(cur):
            return f"// Raven's NULL test on {name} has no form here, and the arm it guards is gone."
        return port_note

    def coerced(self, cur: ci.Cursor, swift: str | None) -> str:
        if swift != "Bool":
            return self.expr(cur)
        if self.is_bool(cur):
            return self.expr(cur)
        inner = self.strip(cur)
        if inner.kind == CursorKind.PAREN_EXPR:
            return self.coerced(list(inner.get_children())[0], "Bool")
        name = self.always_set(cur)
        if name is not None:
            note = f"// Port-note: Raven tests `{name}` for NULL here. Swift holds it as a value, so the test has no form and reads true."
            self.pending.append(self.null_fold_note(cur, name, note))
            return "true"
        if self.is_pointer(cur):
            return f"{self.expr(cur)} != nil"
        return f"{self.operand(cur)} != 0"

    def operand(self, cur: ci.Cursor) -> str:
        """An expression as one operand of a wider one, in parentheses when it is a binary operator Raven left bare."""
        inner = self.strip(cur)
        text = self.expr(cur)
        if inner.kind in (CursorKind.BINARY_OPERATOR, CursorKind.CONDITIONAL_OPERATOR):
            return f"({text})"
        return text

    UNSIGNED = {"UInt", "UInt8", "UInt16", "UInt32", "UInt64"}
    NAMED_LEAVES = (CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR, CursorKind.ARRAY_SUBSCRIPT_EXPR)

    def has_double_literal(self, cur: ci.Cursor) -> bool:
        """True when Raven's expression holds a floating literal with no f suffix, which C computes in double."""
        for c in cur.walk_preorder():
            if c.kind == CursorKind.FLOATING_LITERAL:
                text = self.bytes[c.extent.start.offset:c.extent.end.offset].decode("utf-8", "replace").strip()
                if NUMBER.fullmatch(text) and not text.endswith(("f", "F")):
                    return True
        return False

    def unsigned_of(self, cur: ci.Cursor) -> str | None:
        """The unsigned Swift type of the expression, when the views spell its C type unsigned.
        A view widens a byte or a short to Int32, so a narrow unsigned reads as signed arithmetic, as C's promotion does."""
        swift = self.views.scalar(self.strip(cur).type, TARGET)
        return swift if swift in self.UNSIGNED and swift not in ("UInt8", "UInt16") else None

    def wrapped(self, cur: ci.Cursor, wrap: str) -> str:
        """The expression with `wrap(...)` on each numeric leaf that is not a literal."""
        outer = self.leaf_wrap
        self.leaf_wrap = wrap
        try:
            return self.expr(cur)
        finally:
            self.leaf_wrap = outer

    def leaf(self, cur: ci.Cursor, text: str) -> str:
        """A leaf of an expression, wrapped when a conversion is open and the leaf is a number Swift types on its own."""
        if self.leaf_wrap is None or self.number_kind(cur.type) is None:
            return text
        if self.leaf_wrap in self.UNSIGNED and self.unsigned_of(cur) is not None:
            return text
        if self.leaf_wrap in self.UNSIGNED and not self.is_literal(cur):
            # A signed value into unsigned arithmetic keeps its bits, as C's conversion does.
            return f"{self.leaf_wrap}(bitPattern: Int({text}))" if self.leaf_wrap == "UInt" else f"{self.leaf_wrap}(bitPattern: {text})"
        return f"{self.leaf_wrap}({text})"

    def expr(self, cur: ci.Cursor) -> str:
        kind = cur.kind
        if self.strip(cur).kind not in (CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR):
            # A node whose whole text is one name is a macro use, `ENTITYNUM_WORLD`, and the name is what Raven wrote.
            text = self.source.slice(cur.extent).strip()
            if IDENTIFIER.fullmatch(text):
                if text == "NULL":
                    return "nil"
                self.reach(text, "macro")
                return self.leaf(cur, swift_name(text))
        if kind == CursorKind.UNEXPOSED_EXPR:
            if self.is_call(cur):
                return self.call(cur)
            kids = list(cur.get_children())
            if len(kids) == 1:
                return self.expr(kids[0])
            raise Hole(f"An unexposed expression with {len(kids)} children.")
        if kind == CursorKind.PAREN_EXPR:
            return f"({self.expr(list(cur.get_children())[0])})"
        if kind in (CursorKind.INTEGER_LITERAL, CursorKind.FLOATING_LITERAL):
            return self.literal(cur)
        if kind == CursorKind.CHARACTER_LITERAL:
            text = self.source.slice(cur.extent)
            escapes = {"'\\n'": '"\\n"', "'\\t'": '"\\t"', "'\\r'": '"\\r"', "'\\\\'": '"\\\\"', "'\\''": '"\'"', "'\\\"'": '"\\""'}
            if text == "'\\0'":
                return self.leaf(cur, "0")
            if text in escapes:
                return self.leaf(cur, f"Int32(ascii: {escapes[text]})")
            if len(text) != 3:
                raise Hole("A character literal with an escape.")
            return f"Int32(ascii: {text.replace(chr(39), chr(34))})"
        if kind == CursorKind.STRING_LITERAL:
            return self.joined_literal(self.source.slice(cur.extent))
        if kind == CursorKind.DECL_REF_EXPR:
            word = self.reference(cur)
            return word if word in ("true", "false", "nil") else self.leaf(cur, word)
        if kind == CursorKind.MEMBER_REF_EXPR:
            return self.leaf(cur, self.member(cur))
        if kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            base, index = list(cur.get_children())
            inner_base = self.strip(base)
            # Raven's index over a table of records reads through the Slots the sweep gave the field, the parameter, or the local.
            slots = self.slots_expression(base)
            if slots is None:
                if inner_base.kind == CursorKind.MEMBER_REF_EXPR and inner_base.type.get_canonical().kind == TypeKind.POINTER and not self.float_field(inner_base):
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven reads `{raven}` through a `{inner_base.type.spelling}` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.")
                if self.record_walk(inner_base):
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven walks `{raven}` as an array through a `{inner_base.type.spelling}` parameter, and the view holds one record. A Slots ruling is due.")
            base_text = slots if slots is not None else self.base(base)
            outer = self.leaf_wrap
            self.leaf_wrap = None
            try:
                index_text = self.expr(index)
            finally:
                self.leaf_wrap = outer
            text = f"{base_text}[{index_text}]"
            if text in self.slot_copies:
                return self.leaf(cur, self.slot_copies[text])
            return self.leaf(cur, text)
        if kind == CursorKind.CALL_EXPR:
            outer = self.leaf_wrap
            self.leaf_wrap = None
            try:
                text = self.call(cur)
            finally:
                self.leaf_wrap = outer
            return self.leaf(cur, text)
        if kind == CursorKind.UNARY_OPERATOR:
            op, prefix, operand = self.unary_parts(cur)
            if op == "!":
                inner = self.strip(operand)
                name = self.always_set(operand)
                if name is not None:
                    note = f"// Port-note: Raven guards a NULL `{name}` here. Swift holds it as a value, so the guard has no form and reads false."
                    self.pending.append(self.null_fold_note(operand, name, note))
                    return "false"
                if self.is_bool(operand):
                    return f"!{self.operand(operand)}"
                if self.empty_test(operand) is not None:
                    return f"{self.empty_test(operand)}.isEmpty"
                if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.cursor_locals:
                    return f"{self.expr(inner)}.isNull"
                if self.string_field(inner):
                    return f"{self.expr(inner)}.isEmpty"
                if inner.kind == CursorKind.PAREN_EXPR:
                    return f"!({self.condition(inner)})"
                if self.is_pointer(operand):
                    return f"{self.expr(operand)} == nil"
                return f"{self.operand(operand)} == 0"
            if op in ("-", "+", "~"):
                return f"{op}{self.operand(operand)}"
            if op == "&":
                if target_of(self.fn.stem) == BG and self.entity_slot(cur) is not None:
                    return self.entity_slot(cur)
                slot = self.unwrap(operand)
                if slot.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
                    base, index = list(slot.get_children())
                    if self.unwrap(base).spelling in HAND_VARS:
                        # `&bg_pool[i]` is a pointer into the raw allocation, and the raw pointer advances by the offset.
                        return f"{HAND_VARS[self.unwrap(base).spelling]} + ({self.converted(index, 'Int32')})"
                # The address of a value is the value in Swift, and the call site adds `&` where a parameter is inout.
                return self.expr(operand)
            if op == "*":
                inner = self.strip(operand)
                if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.inout_locals:
                    # A Swift inout parameter is the value Raven reaches through the pointer.
                    return self.names[inner.spelling]
                raise Hole("A pointer dereference the draft cannot place.")
            raise Hole(f"A {op} inside an expression.")
        if kind == CursorKind.BINARY_OPERATOR:
            op = self.binary_op(cur)
            left, right = list(cur.get_children())
            if op in LOGICAL:
                a, b = self.condition(left), self.condition(right)
                # A folded guard drops out of the operator it sat in.
                if op == "||" and a == "false":
                    return b
                if op == "||" and b == "false":
                    return a
                if op == "&&" and a == "true":
                    return b
                if op == "&&" and b == "true":
                    return a
                return f"{a} {op} {b}"
            if op in ASSIGNS:
                raise Hole("An assignment inside an expression.")
            if op not in COMPARISONS | LOGICAL and (self.is_bool(left) or self.is_bool(right)):
                # Raven's `!x & mask` is arithmetic on the 0 or 1 of the test, so the Bool converts as C does.
                return f"{self.converted(left, 'Int32')} {op} {self.converted(right, 'Int32')}"
            if op not in COMPARISONS | LOGICAL and self.leaf_wrap is None and not self.is_sizeof(left) and not self.is_sizeof(right):
                lu, ru = self.unsigned_of(left), self.unsigned_of(right)
                if lu is not None and ru is None and not self.is_literal(right):
                    return f"{self.expr(left)} {op} {self.wrapped(right, lu)}"
                if ru is not None and lu is None and not self.is_literal(left):
                    return f"{self.wrapped(left, ru)} {op} {self.expr(right)}"
            if op in ("==", "!=") and self.string_field(left) and self.is_null(right):
                return f"{self.expr(left)}.isEmpty" if op == "==" else f"!{self.expr(left)}.isEmpty"
            if op in ("==", "!=") and self.empty_test(left) is not None and self.is_literal(right) and self.is_null(right):
                # Raven's `s[0]` on a C string is its first byte, and `s[0] == 0` is the empty string.
                return f"{self.empty_test(left)}.isEmpty" if op == "==" else f"!{self.empty_test(left)}.isEmpty"
            if op in ("==", "!=") and self.is_bool(left) and self.is_literal(right):
                # Raven compares a qboolean with 0 or 1, and Swift reads the Bool itself.
                zero = self.bytes[self.unwrap(right).extent.start.offset:self.unwrap(right).extent.end.offset].decode().strip() == "0"
                return f"!{self.operand(left)}" if zero == (op == "==") else self.operand(left)
            return f"{self.expr(left)} {op} {self.expr(right)}"
        if kind == CursorKind.CONDITIONAL_OPERATOR:
            test, yes, no = list(cur.get_children())
            return f"{self.condition(test)} ? {self.expr(yes)} : {self.expr(no)}"
        if kind == CursorKind.CSTYLE_CAST_EXPR:
            return self.cast(cur)
        if kind == CursorKind.CXX_UNARY_EXPR:
            return self.sizeof(cur)
        raise Hole(f"No rule for a {kind.name} expression.")

    def unwrap(self, cur: ci.Cursor) -> ci.Cursor:
        while cur.kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            kids = list(cur.get_children())
            if len(kids) != 1:
                break
            cur = kids[0]
        return cur

    def joined_literal(self, text: str) -> str:
        """Raven's `S_COLOR_RED"text"` and `"a" "b"`, which C concatenates, as a Swift `+` chain."""
        parts = re.findall(r'"(?:[^"\\]|\\.)*"|[A-Za-z_]\w*', text)
        return " + ".join(parts) if len(parts) > 1 else text

    def literal(self, cur: ci.Cursor) -> str:
        """Raven's spelling, which keeps a macro name where he wrote one, with the C suffixes dropped."""
        text = self.source.slice(cur.extent).strip()
        if cur.kind == CursorKind.FLOATING_LITERAL:
            return re.sub(r"[fF]$", "", text)
        return re.sub(r"[uUlL]+$", "", text)

    def reference(self, cur: ci.Cursor) -> str:
        name = cur.spelling
        ref = cur.referenced
        if name == "qtrue":
            return "true"
        if name == "qfalse":
            return "false"
        if name == "NULL":
            return "nil"
        if name in self.names:
            return self.names[name]
        if name in self.local_holes and ref is not None and ref.kind == CursorKind.VAR_DECL:
            # The declaration is a hole, so the local has no Swift name, and a read of it is the same hole one statement later.
            raise Hole(f"A read of `{name}`, a local the draft left as a hole.")
        if name in self.aliases and ref is not None and ref.kind == CursorKind.VAR_DECL:
            return self.expr(self.aliases[name])
        if name in self.table_cursors and ref is not None and ref.kind == CursorKind.VAR_DECL:
            table, index = self.table_cursors[name]
            return f"{table}[{index}]"
        if ref is not None and ref.kind == CursorKind.ENUM_CONSTANT_DECL:
            return name
        if name in HAND_VARS:
            return HAND_VARS[name]
        if ref is not None and ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
            self.reach(name, "variable")
        return swift_name(name)

    def oracle_declares(self, decl: ci.Cursor | None) -> bool:
        """True when Raven's own headers or files declare the function. A libc function comes from the SDK, and Foundation holds it."""
        if decl is None or decl.location.file is None:
            return False
        return Path(decl.location.file.name).resolve().is_relative_to(C.ORACLE.resolve())

    def reach(self, name: str, what: str, decl: ci.Cursor | None = None) -> None:
        """A bg body sees JKAShared and JKAMP, and not the game module. A game function or variable reached from a bg body keeps a hole,
        and so does a file-scope variable that has no Swift home yet."""
        if target_of(self.fn.stem) != BG:
            return
        homes = self.registry.homes.get(swift_name(name), set())
        if homes and homes <= GAME_SIDE:
            raise Hole(f"Raven reaches the game's `{name}` here, and the bg module has no view of it.")
        if not homes and what == "variable":
            raise Hole(f"Raven reaches `{name}` here, and no Swift file holds it yet.")
        if not homes and what == "function" and name != self.fn.name and name not in MACROS and self.oracle_declares(decl):
            raise Hole(f"Raven calls `{name}` here, and no Swift file holds it yet.")

    def optional_base(self, cur: ci.Cursor) -> bool:
        """True when the expression is a pointer a Swift view holds as optional, so a member read through it takes `!`."""
        inner = self.strip(cur)
        if inner.kind == CursorKind.PAREN_EXPR:
            return self.optional_base(list(inner.get_children())[0])
        if inner.kind == CursorKind.CSTYLE_CAST_EXPR:
            kids = [k for k in inner.get_children() if k.kind.is_expression()]
            return bool(kids) and self.optional_base(kids[-1])
        if not self.is_pointer(inner):
            return False
        if inner.kind == CursorKind.DECL_REF_EXPR:
            ref = inner.referenced
            if inner.spelling in self.optional_entities:
                return True
            if self.optional_text_name(inner):
                # A caller passes NULL for the text, so a read of it takes the bind under Raven's own NULL test.
                return True
            if inner.spelling in self.names or inner.spelling in NEVER_NULL_VARS or inner.spelling in self.game_entities:
                return False
            if inner.spelling in self.charbuf_locals or inner.spelling in self.table_cursors or inner.spelling in self.raw_locals:
                return False
            if inner.spelling in self.optional_texts:
                return True
            if inner.spelling in self.text_locals or inner.spelling in self.cursor_locals:
                return False
            if inner.spelling in self.aliases and ref is not None and ref.kind == CursorKind.VAR_DECL:
                return self.optional_base(self.aliases[inner.spelling])
            return ref is not None and ref.kind == CursorKind.VAR_DECL
        if inner.kind == CursorKind.MEMBER_REF_EXPR:
            if self.float_field(inner):
                # The vector accessor traps on NULL itself, so the read takes no bind.
                return False
            field = inner.referenced
            return field is not None and not self.views.never_null(field)
        if inner.kind == CursorKind.CONDITIONAL_OPERATOR:
            test, yes, no = list(inner.get_children())
            return self.is_null(yes) or self.is_null(no) or self.optional_base(yes) or self.optional_base(no)
        if inner.kind == CursorKind.CALL_EXPR:
            name = self.callee_name(inner)
            returns = self.registry.returns.get(name or "")
            return returns is None or returns.endswith("?")
        if inner.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            # A slot of an array of struct pointers is a `Slots<View?>` element, so it is optional.
            return self.views.record_name(inner.type.get_canonical().get_pointee()) is not None
        return False

    def base(self, cur: ci.Cursor) -> str:
        text = self.expr(cur)
        if self.slots_source(cur) and self.unwrap(cur).kind == CursorKind.DECL_REF_EXPR:
            # Raven reads one record through a pointer Swift holds as the Slots over the records, so the read takes the first slot.
            return f"{text}![0]" if self.optional_slots_name(cur) else f"{text}[0]"
        return f"{text}!" if self.optional_base(cur) else text

    def member(self, cur: ci.Cursor) -> str:
        kids = list(cur.get_children())
        if not kids:
            raise Hole("A member reference with no base.")
        field = cur.referenced
        fields, root, base_cur = self.game_chain(cur)
        if root is not None and not (root == "entity" and fields[0] in self.sk.table.own_fields()):
            return self.game_read(cur, fields, root, base_cur)
        if self.float_field(cur):
            # Raven reads a `float *` field as the vector it points at, and the view's vector accessor is that read, by the hole walk's row 2.
            return f"{self.base(kids[0])}.{swift_name(cur.spelling)}Vector"
        if field is not None and field.kind == CursorKind.FIELD_DECL:
            t = field.type.get_canonical()
            if t.kind == TypeKind.POINTER and self.views.scalar(t.get_pointee(), TARGET) is not None and t.get_pointee().get_canonical().kind != TypeKind.CHAR_S:
                text = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                raise Hole(f"Raven reads `{text}`, a `{field.type.spelling}` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.")
        return f"{self.base(kids[0])}.{swift_name(cur.spelling)}"

    def string_field(self, cur: ci.Cursor) -> bool:
        """True for a member reference to a `char name[N]` field, which the view holds as a String."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.MEMBER_REF_EXPR:
            return False
        t = inner.type.get_canonical()
        return t.kind == TypeKind.CONSTANTARRAY and t.element_type.get_canonical().kind == TypeKind.CHAR_S

    def pooled_field(self, cur: ci.Cursor) -> bool:
        """True for a member reference to a `char *` field, which the view holds as a PooledString?."""
        inner = self.unwrap(cur)
        field = inner.referenced if inner.kind == CursorKind.MEMBER_REF_EXPR else None
        if field is None or field.kind != CursorKind.FIELD_DECL:
            return False
        t = field.type.get_canonical()
        return t.kind == TypeKind.POINTER and t.get_pointee().get_canonical().kind == TypeKind.CHAR_S

    def float_field(self, cur: ci.Cursor) -> bool:
        """True for a member reference to a `float *` field, which the view also holds as a vector."""
        field = cur.referenced
        if field is None or field.kind != CursorKind.FIELD_DECL:
            return False
        t = field.type.get_canonical()
        return t.kind == TypeKind.POINTER and t.get_pointee().get_canonical().kind == TypeKind.FLOAT

    def call(self, cur: ci.Cursor) -> str:
        kids = list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        args = kids[1:]
        if callee is not None and callee.kind == CursorKind.DECL_REF_EXPR and callee.referenced is not None and callee.referenced.kind == CursorKind.FUNCTION_DECL:
            name = callee.spelling
            if name in MACROS:
                return self.macro_call(name, args)
            if name == "sscanf" and len(args) == 5:
                roots = [self.vector_member(a) for a in args[2:]]
                if roots[0] is not None and all(r == roots[0] for r in roots):
                    # Raven scans three floats into the three members of one vector, and the port's sscanf takes the vector.
                    return f"sscanf({self.argument(args[0], False, ('s', 'String'), name, 0)}, {self.expr(args[1])}, &{roots[0]})"
            self.reach(name, "function", callee.referenced)
            aliased = self.aliased_inouts(cur)
            if aliased and not self.aliased_positions:
                # The statement rule copies the earlier ones into locals, and a call inside a test has no line of its own for them.
                raise Hole(f"Raven passes `{aliased[0][1]}` more than once to `{name}` inside a test, and Swift refuses one variable twice inout.")
            params = self.callee_params(name)
            outer = self.call_kinds
            self.call_kinds = self.argument_kinds(args)
            try:
                words = [self.argument(a, i < len(params) and params[i][1].startswith("inout "), params[i] if i < len(params) else None, name, i) for i, a in enumerate(args)]
            finally:
                self.call_kinds = outer
            return f"{swift_name(name)}({', '.join(words)})"
        if callee is not None and callee.kind == CursorKind.MEMBER_REF_EXPR:
            # A stored function on a view runs through the view's method, `pm.runTrace(...)`, which views.py writes per field.
            kids_ = list(callee.get_children())
            field = callee.spelling
            method = f"run{field[0].upper()}{field[1:]}"
            params = self.registry.params.get(method, [])
            outer = self.call_kinds
            self.call_kinds = self.argument_kinds(args)
            try:
                words = [self.argument(a, i < len(params) and params[i][1].startswith("inout "), params[i] if i < len(params) else None, method, i) for i, a in enumerate(args)]
            finally:
                self.call_kinds = outer
            return f"{self.base(kids_[0])}.{method}({', '.join(words)})"
        if callee is not None:
            words = [self.argument(a, False) for a in args]
            if callee.kind == CursorKind.DECL_REF_EXPR and (self.params_by_name.get(callee.spelling, Param("", None, "")).swift or "").endswith(")?"):
                # A callback parameter is an optional closure, and Raven calls it under his `if (localTrace)` guard.
                return f"{self.expr(callee)}?({', '.join(words)})"
            return f"{self.expr(callee)}({', '.join(words)})"
        raise Hole("A call with no callee.")

    def overlapping_slots(self, cur: ci.Cursor) -> list[tuple[str, str]]:
        """The `&a[i]` arguments of one call that share an array, each as its Swift text and the copy that stands in for it."""
        kids = list(self.strip(cur).get_children()) if cur.kind == CursorKind.UNEXPOSED_EXPR else list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        if callee is None or callee.kind != CursorKind.DECL_REF_EXPR:
            return []
        name = callee.spelling
        # Two inout slots of one array conflict. A by-value slot beside an inout one does not, because Swift copies it before the call.
        positions = {i for i in range(len(kids) - 1) if f"&{{{i}}}" in MACROS[name][0]} if name in MACROS else self.inout_positions(name)
        slots: list[tuple[str, str, str]] = []
        for i, arg in enumerate(kids[1:]):
            inner = self.strip(arg)
            if i not in positions:
                continue
            # Raven writes `&a[i]` for a scalar slot and a bare `axis[i]` for a vector slot, which decays to its address.
            if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
                inner = self.unary_parts(inner)[2]
            slot = self.unwrap(inner)
            if slot.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
                continue
            base, index = list(slot.get_children())
            root = self.unwrap(base)
            if root.kind != CursorKind.DECL_REF_EXPR:
                continue
            slots.append((root.spelling, self.expr(slot), f"{swift_name(root.spelling)}{self.expr(index)}"))
        shared = {root for root in (r for r, _, _ in slots) if sum(1 for r, _, _ in slots if r == root) > 1}
        return [(text, local) for root, text, local in slots if root in shared]

    def aliased_inouts(self, cur: ci.Cursor) -> list[tuple[int, str, str]]:
        """The inout arguments that name one plain variable more than once, all but the last, each as its position, its text,
        and the copy that stands in for it. Raven's callee reads the earlier ones and writes the last, `PM_ClipVelocity(v, n, v)`."""
        kids = list(self.strip(cur).get_children()) if cur.kind == CursorKind.UNEXPOSED_EXPR else list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        if callee is None or callee.kind != CursorKind.DECL_REF_EXPR or callee.spelling in MACROS:
            return []
        positions = self.inout_positions(callee.spelling)
        names: list[tuple[int, str]] = []
        for i, arg in enumerate(kids[1:]):
            inner = self.strip(arg)
            if i not in positions:
                continue
            if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
                inner = self.unary_parts(inner)[2]
            inner = self.unwrap(inner)
            if inner.kind == CursorKind.DECL_REF_EXPR:
                names.append((i, inner.spelling))
        out = []
        for i, name in names:
            later = [j for j, other in names if other == name and j > i]
            if later:
                out.append((i, self.expr_name(name), f"{swift_name(name)}In{i}"))
        return out

    def expr_name(self, name: str) -> str:
        return self.names.get(name, swift_name(name))

    def macro_call(self, name: str, args: list[ci.Cursor]) -> str:
        """Raven's `VectorCopy(a, b)` as the table's Swift, each argument a node of the overlay's call."""
        template, floats = MACROS[name]
        if template.count("{") != len(args):
            raise Hole(f"{name} takes {template.count('{')} arguments, and Raven gave {len(args)}.")
        words = []
        for i, arg in enumerate(args):
            inner = self.strip(arg)
            if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
                inner = self.unary_parts(inner)[2]
            words.append(self.converted(inner, "Float") if i in floats else self.expr(inner))
        return template.format(*words)

    def callee_params(self, name: str) -> list[tuple[str, str]]:
        """The callee's Swift parameters: the signature under Sources/ when one exists, because a hand port of q_math takes a
        vector by value where the table would say inout, and the table's row for a function not yet written."""
        if name in self.registry.params:
            return self.registry.params[name]
        fn = self.sk.by_name.get(name)
        if fn is not None and fn.mapped:
            return [(p.name.strip("`"), p.swift or "") for p in fn.params]
        return []

    def inout_positions(self, name: str) -> set[int]:
        return {i for i, (_, swift) in enumerate(self.callee_params(name)) if swift.startswith("inout ")}

    def argument(self, cur: ci.Cursor, inout: bool, param: tuple[str, str] | None = None, callee: str | None = None, position: int = 0) -> str:
        inner = self.strip(cur)
        if position in self.aliased_positions and callee is not None:
            return f"&{self.aliased_positions[position]}"
        if self.text_tail(inner) is not None:
            return self.text_tail(inner)
        if target_of(self.fn.stem) == BG and self.entity_slot(inner) is not None:
            return self.entity_slot(inner)
        addressed = inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&"
        if addressed:
            inner = self.unary_parts(inner)[2]
        if param is not None and param[1].startswith("Slots<"):
            # The parameter takes the Slots over the records, and the caller hands the table it holds.
            slots = self.slots_expression(inner)
            if slots is not None:
                return slots
        if self.is_raw(inner) and self.overload_takes(callee, position, "UnsafeMutableRawPointer"):
            # A raw pointer passes as it is to the overload that takes one, `strcpy(dest, source)`.
            return self.expr(inner)
        if inout and self.is_null(inner):
            tail = SCRATCH_ZEROS.get(param[1].replace("JKAShared.", "")) if param is not None else None
            if param is None or tail is None:
                raise Hole("NULL for an inout parameter the draft has no scratch shape for.")
            scratch = f"scratch{param[0][0].upper()}{param[0][1:]}"
            self.scratch_names[scratch] = self.scratch_names.get(scratch, 0) + 1
            if self.scratch_names[scratch] > 1:
                scratch += str(self.scratch_names[scratch])
            self.pending.append(f"// Raven passes NULL for the `{param[0]}` output. The ported function takes it by reference, so the body passes a scratch local it never reads.")
            self.pending.append(f"var {scratch} {tail}")
            return f"&{scratch}"
        if param is not None and param[1] in ("Float", "Int32", "Bool"):
            return self.converted(inner, param[1])
        if param is not None and param[1].endswith("?") and self.is_null(inner):
            return "nil"
        if param is not None and param[1].replace("JKAShared.", "") == "vec3_t" and self.is_null(inner):
            self.pending.append(f"// Port-note: Raven passes NULL for `{param[0]}`, and the callee reads NULL as the zero vector.")
            return "JKAShared.vec3_origin"
        if param is not None and not param[1].endswith("?") and self.is_null(inner) and inner.type.get_canonical().kind not in INT_KINDS:
            raise Hole(f"NULL for `{param[0]}`, a {param[1]} parameter.")
        if param is not None and "->" in param[1] and inner.kind == CursorKind.MEMBER_REF_EXPR and self.is_callback(inner):
            # A stored function on a view goes where the callee takes a closure as the view's run method, bound to the view.
            field = inner.spelling
            return f"{self.base(list(inner.get_children())[0])}.run{field[0].upper()}{field[1:]}"
        if param is not None and param[1].replace("JKAShared.", "") == "inout CharBuf" and callee in self.sk.by_name and self.immutable_text(inner):
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes `{raven}` to `{callee}`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.")
        text = self.expr(inner)
        if param is not None and param[1].startswith("Slots<"):
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes `{raven}` to `{callee}`, whose `{param[0]}` parameter takes the Slots over the records, "
                       "and Swift holds one record here. A Slots over one record has no form yet.")
        if param is not None and self.view_parameter(param[1]) and self.slots_expression(inner) is not None:
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes `{raven}` to `{callee}`, whose `{param[0]}` parameter takes one record, "
                       "and Swift holds the argument as the Slots over the records.")
        if param is not None and param[1] in TEXT_TYPES and inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.cursor_locals:
            raise Hole(f"Raven passes the cursor `{inner.spelling}` as text, and the TextCursor has no text form yet.")
        if param is not None and param[1] == "OpaquePointer?" and self.is_raw(inner):
            # The engine takes the raw allocation as a handle.
            return f"OpaquePointer({self.expr(inner)})"
        if param is not None and param[1] == "OpaquePointer?" and self.is_charbuf(inner):
            raise Hole(f"Raven passes the buffer `{text}` to the engine as a handle, and the trap takes an OpaquePointer.")
        if param is not None and param[1] in TEXT_TYPES and self.is_charbuf(inner) and not self.overload_takes(callee, position, "CharBuf"):
            # A buffer into a String parameter crosses as the text it holds.
            return f"String({text})"
        if param is not None and param[1] in TEXT_TYPES and self.pooled_field(inner) and not self.overload_takes(callee, position, "PooledString"):
            # A `char *` field is a PooledString?, and its text goes into a String parameter. Raven's callers never pass a NULL one here.
            return f"{text}!.string"
        if param is not None and not param[1].endswith("?") and not inout \
                and not self.optional_base(inner) and self.optional_view_name(inner):
            raise Hole(f"Raven passes the optional `{inner.spelling}` to `{callee}`, whose `{param[0]}` parameter takes a value. A never-null ruling is due.")
        if param is not None and not param[1].endswith("?") and not inout and self.optional_base(inner):
            # A bind on a conditional binds the whole choice, so the choice takes parentheses first.
            text = f"({text})!" if self.unwrap(inner).kind == CursorKind.CONDITIONAL_OPERATOR else f"{text}!"
        if param is not None and param[1].startswith("UnsafeMutablePointer<"):
            # A wrapper takes a skipped output as the pointer itself, and Swift passes a local's address as `&x` for the call.
            # A pointer parameter of the caller passes on as it is.
            own = self.params_by_name.get(inner.spelling) if inner.kind == CursorKind.DECL_REF_EXPR else None
            if own is not None and (own.swift or "").startswith("UnsafeMutablePointer<"):
                return text
            return f"&{text}"
        if (param is None or param[1].endswith("...")) and not inout and self.optional_text_name(inner):
            # Raven's format argument list takes the text itself, and an optional text takes the bind under his own NULL test.
            return f"{text}!"
        if (param is None or param[1].endswith("...")) and not inout and not addressed and self.is_record(inner.type):
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes the record `{raven}` in a format argument list, and a view is no FormatArg.")
        return f"&{text}" if inout else text

    def slots_source(self, cur: ci.Cursor) -> bool:
        """True when Swift holds the name as a `Slots<...>`: a file-scope table of records, a parameter the table gave that kind,
        or a local whose every store holds a table."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        if inner.spelling in self.slots_locals:
            return True
        param = self.params_by_name.get(inner.spelling)
        if param is not None:
            return (param.swift or "").startswith("Slots<")
        return self.registry.var_types.get(swift_name(inner.spelling), "").startswith("Slots<")

    def optional_slots_name(self, cur: ci.Cursor) -> bool:
        """True for a read of a parameter the NULL sweep made an optional Slots, which takes the bind at every use."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        param = self.params_by_name.get(inner.spelling)
        return param is not None and param.kind == "slots_opt"

    def slots_member(self, cur: ci.Cursor) -> str | None:
        """The `<name>Slots` accessor of a struct pointer field a body indexes, `pm->animations`, or None for any other expression."""
        inner = self.strip(cur)
        if inner.kind != CursorKind.MEMBER_REF_EXPR or inner.referenced is None:
            return None
        field = inner.referenced
        if field.kind != CursorKind.FIELD_DECL or not self.sk.table.indexed_field(field):
            return None
        return f"{self.base(list(inner.get_children())[0])}.{swift_name(inner.spelling)}Slots"

    def slots_expression(self, cur: ci.Cursor) -> str | None:
        """The Slots spelling of a read Swift holds as one: the second accessor of an indexed field, or a name of that kind."""
        member = self.slots_member(cur)
        if member is not None:
            return member
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.DECL_REF_EXPR and self.slots_source(inner):
            return self.expr(inner) + ("!" if self.optional_slots_name(inner) else "")
        return None

    def slots_target(self, cur: ci.Cursor) -> bool:
        """True for the left side of a store Swift holds as a Slots: a parameter of that kind, or a local of that kind."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        if inner.spelling in self.slots_locals:
            return True
        param = self.params_by_name.get(inner.spelling)
        return param is not None and (param.swift or "").startswith("Slots<")

    def view_parameter(self, swift: str) -> bool:
        """True for a Swift parameter that takes one view, the shape a Slots does not fit."""
        base = swift.removeprefix("inout ").removesuffix("?").split(".")[-1]
        return base in {view for view, _ in self.views.views.values()}

    def slots_local_names(self, fn: ci.Cursor) -> set[str]:
        """Raven's pointer locals every store fills with a table of records, which Swift holds as the Slots over it.

        A local with no such store keeps the one-record spelling, because a pointer the scan cannot read is one record."""
        sources: dict[str, list[bool]] = {}
        for cur in fn.walk_preorder():
            if cur.kind == CursorKind.VAR_DECL and self.record_pointer_local(cur):
                sources.setdefault(cur.spelling, [])
                init = [c for c in cur.get_children() if c.kind.is_expression()]
                if init:
                    sources[cur.spelling].append(self.table_expression(init[0]))
            if cur.kind != CursorKind.BINARY_OPERATOR or self.operator_or_none(cur) != "=":
                continue
            kids = list(cur.get_children())
            if len(kids) != 2:
                continue
            left = self.unwrap(kids[0])
            if left.kind != CursorKind.DECL_REF_EXPR or left.referenced is None or left.referenced.kind != CursorKind.VAR_DECL:
                continue
            if not self.record_pointer_local(left.referenced):
                continue
            sources.setdefault(left.spelling, []).append(self.table_expression(kids[1]))
        # A cursor Raven walks with `f++` already reads the table by index, so it keeps its own form.
        return {name for name, kinds in sources.items() if kinds and all(kinds) and name not in self.table_cursors}

    def record_pointer_local(self, var: ci.Cursor) -> bool:
        """True for a local Raven typed as a pointer to a struct a view covers."""
        if var.semantic_parent is not None and var.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
            return False
        t = var.type.get_canonical()
        if t.kind != TypeKind.POINTER:
            return False
        record = self.views.record_name(t.get_pointee())
        return bool(record) and record in self.views.views

    def table_expression(self, cur: ci.Cursor) -> bool:
        """True for a source Swift holds as a table of records: an indexed field, or a name of that kind.
        The scan reads the C alone, because it runs before the draft of any statement."""
        inner = self.strip(cur)
        if inner.kind == CursorKind.MEMBER_REF_EXPR and inner.referenced is not None \
                and inner.referenced.kind == CursorKind.FIELD_DECL and self.sk.table.indexed_field(inner.referenced):
            return True
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        param = self.params_by_name.get(inner.spelling)
        if param is not None:
            return (param.swift or "").startswith("Slots<")
        return self.registry.var_types.get(swift_name(inner.spelling), "").startswith("Slots<")

    def optional_view_name(self, cur: ci.Cursor) -> bool:
        """True for a read of a parameter the NULL sweep made an optional view, which no bind of the draft's own covers."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        param = self.params_by_name.get(inner.spelling)
        return param is not None and param.kind == "view_opt"

    def optional_text_name(self, cur: ci.Cursor) -> bool:
        """True for a read of a name Swift holds as an optional text.
        A parameter a caller passes NULL for and a local Raven stores his NULL into are both of that kind."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        param = self.params_by_name.get(inner.spelling)
        if param is not None:
            return param.kind == "cstring_opt"
        return inner.spelling in self.optional_texts

    def immutable_text(self, cur: ci.Cursor) -> bool:
        """True for text Swift holds as a value the callee cannot write into.
        Raven's literal, a String local, a String parameter, and a `char name[N]` field are all of that kind."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.CSTYLE_CAST_EXPR and self.char_pointer_cast(inner):
            # Raven's `(char *)value` casts the const away, and the text under it is the same text.
            inner = self.unwrap([k for k in inner.get_children() if k.kind.is_expression()][-1])
        if inner.kind == CursorKind.STRING_LITERAL:
            return True
        if self.string_field(inner):
            return True
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        param = self.params_by_name.get(inner.spelling)
        if param is not None:
            return param.kind in ("cstring", "cstring_opt")
        return inner.spelling in self.text_locals

    def char_pointer_cast(self, cur: ci.Cursor) -> bool:
        """True when a C-style cast targets a char pointer."""
        t = cur.type.get_canonical()
        if t.kind != TypeKind.POINTER:
            return False
        return t.get_pointee().get_canonical().kind in (TypeKind.CHAR_S, TypeKind.UCHAR, TypeKind.CHAR_U, TypeKind.SCHAR)

    def is_callback(self, cur: ci.Cursor) -> bool:
        """True for a member reference to a field that stores a function pointer."""
        t = cur.type.get_canonical()
        return t.kind == TypeKind.POINTER and t.get_pointee().kind == TypeKind.FUNCTIONPROTO

    def char_buffer(self, cur: ci.Cursor) -> ci.Cursor | None:
        """The member reference under a subscript into a `char[]` field, which the view holds as a String, or None."""
        inner = self.strip(cur)
        if inner.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return None
        base = self.strip(list(inner.get_children())[0])
        if base.kind != CursorKind.MEMBER_REF_EXPR:
            return None
        t = base.type.get_canonical()
        if t.kind == TypeKind.CONSTANTARRAY and t.element_type.get_canonical().kind == TypeKind.CHAR_S:
            return base
        return None

    def overload_takes(self, callee: str | None, position: int, swift: str) -> bool:
        """True when some Swift overload of the callee takes the named type at the position and every other text argument as it is.
        Swift picks one overload for the whole call, so an overload that takes this argument and rejects a later one is no match."""
        if callee is None:
            return False
        for params in self.registry.overloads.get(callee, []):
            if position < len(params) and self.param_type(params, position) == swift and self.overload_fits(params, position):
                return True
        return False

    def param_type(self, params: list[tuple[str, str]], position: int) -> str:
        """The Swift type of one parameter, without its module and without its `inout`."""
        return params[position][1].replace("JKAShared.", "").replace("inout ", "")

    def overload_fits(self, params: list[tuple[str, str]], position: int) -> bool:
        """True when the overload takes every other text argument of the call as it is.
        An argument the draft has no text kind for fits any overload, and so does a parameter that is not text."""
        for i, kind in self.call_kinds.items():
            if i == position or i >= len(params):
                continue
            swift = self.param_type(params, i)
            if swift in TEXT_TYPES and swift != kind:
                return False
        return True

    def text_kind(self, cur: ci.Cursor) -> str | None:
        """The Swift text type the draft passes an argument as: String, CharBuf, or PooledString, and None for the rest."""
        inner = self.strip(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            inner = self.unwrap(self.unary_parts(inner)[2])
        if inner.kind == CursorKind.STRING_LITERAL:
            # A literal fits a String parameter and a CharBuf one alike, so it holds no overload back.
            return None
        if self.string_field(inner):
            return "String"
        if self.pooled_field(inner):
            return "PooledString"
        if self.is_charbuf(inner):
            return "CharBuf"
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return None
        param = self.params_by_name.get(inner.spelling)
        if param is not None:
            return "String" if param.kind == "cstring" else None
        return "String" if inner.spelling in self.text_locals else None

    def argument_kinds(self, args: list[ci.Cursor]) -> dict[int, str]:
        """The text kind of each argument of one call, by position, for the overload choice."""
        out: dict[int, str] = {}
        for i, arg in enumerate(args):
            try:
                kind = self.text_kind(arg)
            except Hole:
                kind = None
            if kind is not None:
                out[i] = kind
        return out

    def is_null(self, cur: ci.Cursor) -> bool:
        inner = self.unwrap(cur)
        text = self.bytes[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace").strip()
        return text in ("NULL", "0")

    def optional_local(self, cur: ci.Cursor) -> bool:
        """A local the draft declared as an optional view, `var pVeh: Vehicle?`."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR or inner.spelling in self.names:
            return False
        ref = inner.referenced
        if ref is None or ref.kind != CursorKind.VAR_DECL or ref.semantic_parent is None or ref.semantic_parent.kind != CursorKind.FUNCTION_DECL and ref.semantic_parent.kind != CursorKind.COMPOUND_STMT:
            return False
        t = ref.type.get_canonical()
        if t.kind != TypeKind.POINTER:
            return False
        record = self.views.record_name(t.get_pointee())
        return bool(record) and record in self.views.views

    def reachable(self, record: str) -> None:
        """A view of the game target has no name in a bg file, so a bg body that reaches for one keeps a hole."""
        if target_of(self.fn.stem) == BG and self.views.views[record][1] == "CJKAMP_Game":
            raise Hole(f"Raven reaches the game's `{record}` here, and the bg module has no view of it.")

    def cast(self, cur: ci.Cursor) -> str:
        kids = [k for k in cur.get_children() if k.kind.is_expression()]
        if not kids:
            raise Hole("A cast with no operand.")
        operand = kids[-1]
        target = cur.type
        canonical = target.get_canonical()
        if canonical.kind == TypeKind.POINTER:
            stride = self.stride_walk(operand)
            if stride is not None:
                return stride
            if target_of(self.fn.stem) == BG and self.views.record_name(canonical.get_pointee()) == "gentity_t":
                # The game converts by handle at the channel, so the cast to the game's entity drops, by the hole walk's row 1.
                if self.is_raw(operand):
                    # A raw allocation cast to the entity is the bg view over those bytes, the head every entity shares.
                    return f"JKAMP.BgEntity({self.expr(operand)})"
                return self.expr(operand)
            if canonical.get_pointee().get_canonical().kind in (TypeKind.CHAR_S, TypeKind.UCHAR, TypeKind.CHAR_U, TypeKind.SCHAR):
                if self.view_operand(operand):
                    # Raven's `(byte *)vehicle` walks the record's bytes, and the raw pointer over the view's slot is that walk.
                    return f"UnsafeMutableRawPointer({self.base(operand)}.handle)"
                # A cast to a byte or character pointer changes nothing Swift can see: a String stays a String, a raw pointer stays raw.
                return self.expr(operand)
            record = self.views.record_name(canonical.get_pointee())
            if record and record in self.views.views:
                self.reachable(record)
                if self.views.record_name(self.strip(operand).type.get_canonical().get_pointee()) == record:
                    # A cast to the type the operand already has is Raven's habit, and the view is the same view.
                    return self.expr(operand)
                return f"{self.views.qualified_view(record, TARGET)}({self.expr(operand)})"
            raise Hole(f"A cast to `{target.spelling}` the draft has no view for.")
        swift = self.views.scalar(target, TARGET)
        if swift is None:
            raise Hole(f"A cast to `{target.spelling}` the table has no type for.")
        if self.views.narrow(target) is not None:
            swift = "Int32"
        if swift in ("Int32", "Float") and self.is_bool(operand):
            # Raven's `(int)` on a qboolean is the Bool as a number.
            return self.converted(operand, swift)
        return f"{swift}({self.expr(operand)})"

    def stride_walk(self, operand: ci.Cursor) -> str | None:
        """Raven's `(byte *)pm->baseEnt + pm->entSize*(num)` as the pmove view's `entity(at:)`, by the hole walk's row 4. Any other
        byte walk is None, and the cast that holds it stays a hole."""
        inner = self.unwrap(operand)
        if inner.kind != CursorKind.BINARY_OPERATOR or self.collapsed(inner) or self.binary_op(inner) != "+":
            return None
        left, right = list(inner.get_children())
        base = self.unwrap(left)
        if base.kind != CursorKind.CSTYLE_CAST_EXPR:
            return None
        base = self.unwrap([k for k in base.get_children() if k.kind.is_expression()][-1])
        step = self.unwrap(right)
        if base.kind != CursorKind.MEMBER_REF_EXPR or base.spelling != "baseEnt" or step.kind != CursorKind.BINARY_OPERATOR or self.binary_op(step) != "*":
            return None
        size, count = [self.unwrap(k) for k in step.get_children()]
        if size.kind != CursorKind.MEMBER_REF_EXPR or size.spelling != "entSize":
            return None
        owner = self.base(list(base.get_children())[0])
        if owner != self.base(list(size.get_children())[0]):
            return None
        return f"{owner}.entity(at: {self.converted(count, 'Int32')})"

    # MARK: - Operators from tokens

    def binary_op(self, cur: ci.Cursor) -> str:
        """The operator between the two operands, read from the bytes between them. The binding exposes no operator on the
        cursor, and the tokens are empty when the range starts inside a macro expansion, so the source text carries it."""
        left, right = list(cur.get_children())
        text = self.bytes[left.extent.end.offset:right.extent.start.offset].decode("utf-8", "replace")
        # A comment Raven wrote between two operands of a condition that spans lines is dropped from the draft.
        text = COMMENT.sub("", text).strip()
        if text in BINARY_OPS:
            return text
        raise Hole(f"No operator between the operands, the text there is `{text}`.")

    def unary_parts(self, cur: ci.Cursor) -> tuple[str, bool, ci.Cursor]:
        operand = list(cur.get_children())[0]
        before = self.bytes[cur.extent.start.offset:operand.extent.start.offset].decode("utf-8", "replace").strip()
        after = self.bytes[operand.extent.end.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()
        if before in UNARY_PREFIX:
            return before, True, operand
        if after in ("++", "--"):
            return after, False, operand
        if not before and not after and self.macro_span(cur):
            # The operator sits inside a macro, `DEFAULT_MINS_2` for `-24`, and the name is what the draft writes.
            return "", True, cur
        raise Hole(f"No operator beside the operand, the text there is `{before or after}`.")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", help="comma-separated function names to print")
    parser.add_argument("--stem", help="print every draft of one .c file")
    args = parser.parse_args()
    sk = Skeleton(overlay=OVERLAY)
    drafter = Drafter(sk, Registry())
    if args.only:
        fns = [sk.by_name[n] for n in args.only.split(",")]
    elif args.stem:
        fns = sk.files[args.stem]
    else:
        parser.error("give --only or --stem")
    for fn in fns:
        print("\n".join(drafter.draft(fn)))
        print()
    print(f"// {drafter.holes} holes", flush=True)


if __name__ == "__main__":
    main()
