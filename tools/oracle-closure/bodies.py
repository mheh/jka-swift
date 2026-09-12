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
from table import Param, TARGET, swift_name

INDENT = "    "
COMPARISONS = {"==", "!=", "<", ">", "<=", ">="}
LOGICAL = {"&&", "||"}
ASSIGNS = {"=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>="}
BINARY_OPS = COMPARISONS | LOGICAL | ASSIGNS | {"+", "-", "*", "/", "%", "&", "|", "^", "<<", ">>", ","}
UNARY_PREFIX = {"-", "+", "!", "~", "*", "&", "++", "--"}
WRAPPERS = {CursorKind.UNEXPOSED_EXPR, CursorKind.PAREN_EXPR}
COMMENT = re.compile(r"//[^\n]*|/\*.*?\*/", re.S)
NUMBER = re.compile(r"-?\s*((\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?[fFuUlL]*|0[xX][0-9a-fA-F]+[uUlL]*)")
IDENTIFIER = re.compile(r"[A-Za-z_]\w*")
# Raven's function-like macros the draft maps, by the table of docs/transcription.md, "Vectors and the vector macros".
# The parse sees each one as a call, because the overlay below undefines the macro and declares a function under its name,
# so every argument is a node with its text, its type, and its tokens. The template writes the Swift form, `{0}` the first
# argument. `floats` names the argument positions that are one float, where an integer argument converts as C does.
MACROS = {
    "VectorAdd": ("{2} = {0} + {1}", ()),
    "VectorSubtract": ("{2} = {0} - {1}", ()),
    "VectorScale": ("{2} = {0} * {1}", (1,)),
    "VectorCopy": ("{1} = {0}", ()),
    "VectorMA": ("_VectorMA({0}, {1}, {2}, &{3})", (1,)),
    "VectorNegate": ("{1} = -{0}", ()),
    "VectorClear": ("{0} = JKAShared.vec3_t(0, 0, 0)", ()),
    "VectorSet": ("{0} = JKAShared.vec3_t({1}, {2}, {3})", (1, 2, 3)),
    "DotProduct": ("_DotProduct({0}, {1})", ()),
    "Q_fabs": ("Q_fabs({0})", (0,)),
    "DEG2RAD": ("DEG2RAD({0})", (0,)),
    "RAD2DEG": ("RAD2DEG({0})", (0,)),
    "ANGLE2SHORT": ("ANGLE2SHORT({0})", (0,)),
    "SHORT2ANGLE": ("SHORT2ANGLE({0})", ()),
    "SnapVector": ("SnapVector(&{0})", ()),
    "min": ("min({0}, {1})", ()),
    "max": ("max({0}, {1})", ()),
}
# The C return type each function takes in the overlay, so the use keeps the type Raven's expression had.
MACRO_RETURNS = {"DotProduct": "float", "Q_fabs": "float", "DEG2RAD": "float", "RAD2DEG": "float", "ANGLE2SHORT": "int",
                 "SHORT2ANGLE": "float", "min": "float", "max": "float"}
# `assert` is `((void)0)` under Raven's NDEBUG build, and the overlay makes it a call the draft drops by name.
DROPPED = {"assert"}
# The SDK's fortify macros rename `memset` and `memcpy` to builtins with an extra argument, so the overlay undefines them and string.h's prototypes serve.
UNDEFINED = ("memset", "memcpy")
OVERLAY = "".join(f"#undef {name}\n{MACRO_RETURNS.get(name, 'void')} {name}(...);\n" for name in list(MACROS) + sorted(DROPPED)) + "".join(f"#undef {name}\n" for name in UNDEFINED)
FUNC_LINE = re.compile(r"func\s+`?(\w+)`?\s*\((.*)\)")
# A file-scope `var`, `let`, or `func` of a Swift file: at column 0, after its modifiers. A method sits indented under its type.
MODIFIERS = r"(?:(?:public|package|internal|private|fileprivate|nonisolated\(unsafe\)|@\w+(?:\([^)]*\))?)\s+)*"
VAR_LINE = re.compile(MODIFIERS + r"(?:var|let)\s+`?(\w+)`?")
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
        # The Swift targets that hold each file-scope function and variable, so a bg body that reaches a game-only name keeps a hole.
        self.homes: dict[str, set[str]] = {}
        for path in SOURCES.rglob("*.swift"):
            target = path.relative_to(SOURCES).parts[0]
            for line in path.read_text().splitlines():
                v = VAR_LINE.match(line)
                if v is not None:
                    self.homes.setdefault(v.group(1), set()).add(target)
                m = FUNC_LINE.search(line)
                if m is None or "func " not in line.split("//")[0]:
                    continue
                params = []
                for p in split_params(m.group(2)):
                    label, _, swift = p.partition(":")
                    params.append((label.split()[-1].strip("`"), swift.strip()))
                self.params.setdefault(m.group(1), params)
                if FILE_FUNC.match(line):
                    self.homes.setdefault(m.group(1), set()).add(target)


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
        # Lines an expression asks to go above its statement: a Port-note, or a scratch local for a NULL output argument.
        self.pending: list[str] = []
        # The parameters and the local declarations of the function being drafted, by name, for the let and the guard rules.
        self.params_by_name: dict[str, Param] = {}
        self.lets: set[str] = set()
        # A conversion every numeric leaf of the expression being drafted takes: "Double" under a double literal, or an unsigned type.
        self.leaf_wrap: str | None = None
        # The scratch closures open around the statement being drafted, innermost last: None, "flag", or "value".
        self.scratch_modes: list[str | None] = []

    # MARK: - One function

    def draft(self, fn: Function) -> list[str]:
        header = self.sk.stub(fn)
        if not fn.mapped or not header[-1].startswith("}"):
            return header
        self.fn = fn
        self.source = self.sk.source(fn.stem)
        self.bytes = (C.ORACLE / ORACLE_DIR / f"{fn.stem}.c").read_bytes()
        self.names = {c.spelling: p.name for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.params_by_name = {c.spelling: p for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.scratch_names: dict[str, int] = {}
        # The Swift statement each of Raven's labels gives its gotos, `break rest` or `continue backAgain`.
        self.goto_forms: dict[str, str] = {}
        self.lets = self.single_writes(fn.cur)
        if any(self.record_local(c) is not None for c in fn.cur.walk_preorder()):
            # A closure cannot initialize a let of the enclosing body, so a body with a scratch record keeps every local a var.
            self.lets = set()
        self.written = self.written_names(fn.cur)
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
            if depth == 1 and self.param_copies and (child.kind != CursorKind.DECL_STMT or record is not None):
                for name in self.param_copies:
                    out.append(f"{INDENT}// Raven assigns his own `{name}` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.")
                    out.append(f"{INDENT}var {name} = {name}")
                self.param_copies = []
            out += self.gap(previous_line, child.extent.start.line, depth)
            if record is not None:
                out += self.scratch(child, record, children[i + 1:], last_line, depth)
                return out
            out += self.statement(child, depth)
            previous_line = child.extent.end.line
        out += self.gap(previous_line, last_line, depth)
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
        if returns:
            mode = "flag" if self.fn.returns is None else "value"
        result = "earlyOut" if not self.scratch_modes else f"earlyOut{len(self.scratch_modes) + 1}"
        out = [f"{pad}// Raven's record lives to the end of his block, so the block is the closure."]
        if mode == "flag":
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
        targets = []
        for arg in args[: 2 if name == "memcpy" else 1]:
            if arg.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(arg)[0] == "&":
                arg = self.strip(self.unary_parts(arg)[2])
            if not self.is_record(arg.type):
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
                return [f"{pad}{self.expr(operand)} {op[0]}= 1" + self.trailing(cur)]
        if kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
            op = self.binary_op(cur)
            if op in ASSIGNS:
                left, right = list(cur.get_children())
                buffer = self.char_buffer(left)
                if buffer is not None:
                    # Raven's `name[0] = 0` empties a character buffer the view holds as a String.
                    if op == "=" and self.is_null(right) and self.is_null(list(self.strip(left).get_children())[1]):
                        return [f"{pad}{self.member(buffer)} = \"\"" + self.trailing(cur)]
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven writes `{raven}` into a character buffer the view holds as a String.")
                target = self.expr(left)
                inner = self.strip(right)
                if op == "=" and inner.kind == CursorKind.BINARY_OPERATOR and not self.macro_span(inner) and self.binary_op(inner) == "=":
                    # Raven's `a = b = 0` sets b, then a from b, so the draft writes the two stores in that order.
                    lines = self.statement_lines(inner, depth)
                    lines.append(f"{pad}{target} = {self.expr(list(inner.get_children())[0])}" + self.trailing(cur))
                    return lines
                if self.strip(left).type.get_canonical().kind == TypeKind.RECORD:
                    if op == "=" and self.is_record(left.type) and self.is_record(right.type):
                        # Raven's `a = b` on two records is a byte copy, and the view's `copy(from:)` is that copy.
                        return [f"{pad}{self.expr(left)}.copy(from: {self.expr(right)})" + self.trailing(cur)]
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
                value = self.converted(right, lhs_kind) if op == "=" else self.expr(right)
                return [f"{pad}{target} {op} {value}" + self.trailing(cur)]
        if self.is_call(cur) and self.callee_name(cur) in UNDEFINED:
            return self.record_bytes(cur, depth)
        if self.is_call(cur) and self.callee_name(cur) in DROPPED:
            # `assert` is `((void)0)` under Raven's NDEBUG build, so the body drops it, by "assert".
            rest = self.trailing(cur).strip()
            return [f"{pad}{rest}"] if rest else []
        if self.is_call(cur):
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
        for i, (labels, stmts, label_line) in enumerate(groups):
            label = "default" if labels == ["default"] else "case " + ", ".join(l for l in labels if l != "default")
            if "default" in labels and len(labels) > 1:
                label = "default"
            out.append(f"{pad}{label}:")
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
            out += lines
            if i + 1 < len(groups):
                out.append("")
        if not any("default" in labels for labels, _, _ in groups):
            out += ["", f"{pad}default:", f"{INDENT * (depth + 1)}break"]
        out.append(f"{pad}}}")
        return out

    def declarations(self, cur: ci.Cursor) -> list[str]:
        out: list[str] = []
        for var in cur.get_children():
            if var.kind != CursorKind.VAR_DECL:
                raise Hole(f"A {var.kind.name} inside a declaration.")
            try:
                out.append(self.declaration(var))
            except Hole as hole:
                self.holes += 1
                self.hole_names.add(var.spelling)
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
        if t.get_canonical().kind == TypeKind.POINTER:
            record = self.views.record_name(t.get_canonical().get_pointee())
            if record and record in self.views.views:
                self.reachable(record)
                view = self.views.qualified_view(record, TARGET)
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
        return f"{keyword} {name}: {swift}"

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
        return self.coerced(cur, swift)

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
        return cur.type.spelling.replace("const ", "") == "qboolean"

    def is_pointer(self, cur: ci.Cursor) -> bool:
        return self.strip(cur).type.get_canonical().kind == TypeKind.POINTER

    def condition(self, cur: ci.Cursor) -> str:
        """A C truth test as a Swift Bool: a Bool as it is, a pointer against nil, a number against 0."""
        return self.coerced(cur, "Bool")

    def always_set(self, cur: ci.Cursor) -> str | None:
        """Raven's name for a pointer Swift holds as a value, when a truth test on it has no Swift form."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            return self.bytes[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace")
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.params_by_name:
            kind = self.params_by_name[inner.spelling].kind
            swift = self.params_by_name[inner.spelling].swift or ""
            if swift.startswith("inout ") or kind in ("view", "vec3_const", "cstring", "slots"):
                return inner.spelling
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in NEVER_NULL_VARS:
            return inner.spelling
        return None

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
            self.pending.append(f"// Port-note: Raven tests `{name}` for NULL here. Swift holds it as a value, so the test has no form and reads true.")
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

    def has_double_literal(self, cur: ci.Cursor) -> bool:
        """True when Raven's expression holds a floating literal with no f suffix, which C computes in double."""
        for c in cur.walk_preorder():
            if c.kind == CursorKind.FLOATING_LITERAL:
                text = self.bytes[c.extent.start.offset:c.extent.end.offset].decode("utf-8", "replace").strip()
                if NUMBER.fullmatch(text) and not text.endswith(("f", "F")):
                    return True
        return False

    def unsigned_of(self, cur: ci.Cursor) -> str | None:
        """The unsigned Swift type of the expression, when the views spell its C type unsigned."""
        swift = self.views.scalar(self.strip(cur).type, TARGET)
        return swift if swift in self.UNSIGNED else None

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
        return f"{self.leaf_wrap}({text})"

    def expr(self, cur: ci.Cursor) -> str:
        kind = cur.kind
        if self.strip(cur).kind not in (CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR):
            # A node whose whole text is one name is a macro use, `ENTITYNUM_WORLD`, and the name is what Raven wrote.
            text = self.source.slice(cur.extent).strip()
            if IDENTIFIER.fullmatch(text):
                return "nil" if text == "NULL" else self.leaf(cur, swift_name(text))
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
            if len(text) != 3:
                raise Hole("A character literal with an escape.")
            return f"Int32(ascii: {text.replace(chr(39), chr(34))})"
        if kind == CursorKind.STRING_LITERAL:
            return self.source.slice(cur.extent)
        if kind == CursorKind.DECL_REF_EXPR:
            word = self.reference(cur)
            return word if word in ("true", "false", "nil") else self.leaf(cur, word)
        if kind == CursorKind.MEMBER_REF_EXPR:
            return self.leaf(cur, self.member(cur))
        if kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            base, index = list(cur.get_children())
            inner_base = self.strip(base)
            if inner_base.kind == CursorKind.MEMBER_REF_EXPR and inner_base.type.get_canonical().kind == TypeKind.POINTER:
                raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                raise Hole(f"Raven reads `{raven}` through a `{inner_base.type.spelling}` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.")
            base_text = self.base(base)
            outer = self.leaf_wrap
            self.leaf_wrap = None
            try:
                index_text = self.expr(index)
            finally:
                self.leaf_wrap = outer
            return self.leaf(cur, f"{base_text}[{index_text}]")
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
                    self.pending.append(f"// Port-note: Raven guards a NULL `{name}` here. Swift holds it as a value, so the guard has no form and reads false.")
                    return "false"
                if self.is_bool(operand):
                    return f"!{self.operand(operand)}"
                if inner.kind == CursorKind.PAREN_EXPR:
                    return f"!({self.condition(inner)})"
                if self.is_pointer(operand):
                    return f"{self.expr(operand)} == nil"
                return f"{self.operand(operand)} == 0"
            if op in ("-", "+", "~"):
                return f"{op}{self.operand(operand)}"
            if op == "&":
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
            if op not in COMPARISONS | LOGICAL and self.leaf_wrap is None:
                lu, ru = self.unsigned_of(left), self.unsigned_of(right)
                if lu is not None and ru is None and not self.is_literal(right):
                    return f"{self.expr(left)} {op} {self.wrapped(right, lu)}"
                if ru is not None and lu is None and not self.is_literal(left):
                    return f"{self.wrapped(left, ru)} {op} {self.expr(right)}"
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
            raise Hole("A sizeof the draft cannot size.")
        raise Hole(f"No rule for a {kind.name} expression.")

    def unwrap(self, cur: ci.Cursor) -> ci.Cursor:
        while cur.kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            kids = list(cur.get_children())
            if len(kids) != 1:
                break
            cur = kids[0]
        return cur

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
        if ref is not None and ref.kind == CursorKind.ENUM_CONSTANT_DECL:
            return name
        if name in HAND_VARS:
            return HAND_VARS[name]
        if ref is not None and ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
            self.reach(name, "variable")
        return swift_name(name)

    def reach(self, name: str, what: str) -> None:
        """A bg body sees JKAShared and JKAMP, and not the game module. A game function or variable reached from a bg body keeps a hole,
        and so does a file-scope variable that has no Swift home yet."""
        if target_of(self.fn.stem) != BG:
            return
        homes = self.registry.homes.get(swift_name(name), set())
        if homes == {LOGIC}:
            raise Hole(f"Raven reaches the game's `{name}` here, and the bg module has no view of it.")
        if not homes and what == "variable":
            raise Hole(f"Raven reaches `{name}` here, and no Swift file holds it yet.")

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
            if inner.spelling in self.names or inner.spelling in NEVER_NULL_VARS:
                return False
            return ref is not None and ref.kind == CursorKind.VAR_DECL
        if inner.kind == CursorKind.MEMBER_REF_EXPR:
            field = inner.referenced
            return field is not None and not self.views.never_null(field)
        if inner.kind == CursorKind.CALL_EXPR:
            return True
        return False

    def base(self, cur: ci.Cursor) -> str:
        text = self.expr(cur)
        return f"{text}!" if self.optional_base(cur) else text

    def member(self, cur: ci.Cursor) -> str:
        kids = list(cur.get_children())
        if not kids:
            raise Hole("A member reference with no base.")
        field = cur.referenced
        if field is not None and field.kind == CursorKind.FIELD_DECL:
            t = field.type.get_canonical()
            if t.kind == TypeKind.POINTER and self.views.scalar(t.get_pointee(), TARGET) is not None:
                text = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                raise Hole(f"Raven reads `{text}`, a `{field.type.spelling}` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.")
        return f"{self.base(kids[0])}.{swift_name(cur.spelling)}"

    def call(self, cur: ci.Cursor) -> str:
        kids = list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        args = kids[1:]
        if callee is not None and callee.kind == CursorKind.DECL_REF_EXPR and callee.referenced is not None and callee.referenced.kind == CursorKind.FUNCTION_DECL:
            name = callee.spelling
            if name in MACROS:
                return self.macro_call(name, args)
            self.reach(name, "function")
            params = self.callee_params(name)
            words = [self.argument(a, i < len(params) and params[i][1].startswith("inout "), params[i] if i < len(params) else None) for i, a in enumerate(args)]
            return f"{swift_name(name)}({', '.join(words)})"
        if callee is not None and callee.kind == CursorKind.MEMBER_REF_EXPR:
            # A stored function on a view runs through the view's method, `pm.runTrace(...)`, which views.py writes per field.
            kids_ = list(callee.get_children())
            field = callee.spelling
            method = f"run{field[0].upper()}{field[1:]}"
            params = self.registry.params.get(method, [])
            words = [self.argument(a, i < len(params) and params[i][1].startswith("inout "), params[i] if i < len(params) else None) for i, a in enumerate(args)]
            return f"{self.base(kids_[0])}.{method}({', '.join(words)})"
        if callee is not None:
            words = [self.argument(a, False) for a in args]
            if callee.kind == CursorKind.DECL_REF_EXPR and (self.params_by_name.get(callee.spelling, Param("", None, "")).swift or "").endswith(")?"):
                # A callback parameter is an optional closure, and Raven calls it under his `if (localTrace)` guard.
                return f"{self.expr(callee)}?({', '.join(words)})"
            return f"{self.expr(callee)}({', '.join(words)})"
        raise Hole("A call with no callee.")

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

    def argument(self, cur: ci.Cursor, inout: bool, param: tuple[str, str] | None = None) -> str:
        inner = self.strip(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            inner = self.unary_parts(inner)[2]
        if inout and self.is_null(inner):
            if param is None or param[1].replace("JKAShared.", "") != "inout vec3_t":
                raise Hole("NULL for an inout parameter that is not a vector.")
            scratch = f"scratch{param[0][0].upper()}{param[0][1:]}"
            self.scratch_names[scratch] = self.scratch_names.get(scratch, 0) + 1
            if self.scratch_names[scratch] > 1:
                scratch += str(self.scratch_names[scratch])
            self.pending.append(f"// Raven passes NULL for the `{param[0]}` output. The ported function takes it by reference, so the body passes a scratch vector it never reads.")
            self.pending.append(f"var {scratch} = JKAShared.vec3_t(0, 0, 0)")
            return f"&{scratch}"
        if param is not None and param[1] in ("Float", "Int32", "Bool"):
            return self.converted(inner, param[1])
        if param is not None and param[1].endswith("?") and self.is_null(inner):
            return "nil"
        if param is not None and param[1].replace("JKAShared.", "") == "vec3_t" and self.is_null(inner):
            self.pending.append(f"// Port-note: Raven passes NULL for `{param[0]}`, and the callee reads NULL as the zero vector.")
            return "JKAShared.vec3_origin"
        if param is not None and not param[1].endswith("?") and self.is_null(inner):
            raise Hole(f"NULL for `{param[0]}`, a {param[1]} parameter.")
        if param is not None and "->" in param[1] and inner.kind == CursorKind.MEMBER_REF_EXPR and self.is_callback(inner):
            # A stored function on a view goes where the callee takes a closure as the view's run method, bound to the view.
            field = inner.spelling
            return f"{self.base(list(inner.get_children())[0])}.run{field[0].upper()}{field[1:]}"
        text = self.expr(inner)
        if param is not None and not param[1].endswith("?") and not inout and self.optional_base(inner):
            text += "!"
        return f"&{text}" if inout else text

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
        return f"{swift}({self.expr(operand)})"

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
