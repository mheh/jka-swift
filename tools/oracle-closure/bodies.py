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

from reexport import SOURCES
from rulings import HAND_VARS, NEVER_NULL_VARS
import closure as C
from skeleton import ORACLE_DIR, Function, Skeleton
from table import TARGET, swift_name

INDENT = "    "
COMPARISONS = {"==", "!=", "<", ">", "<=", ">="}
LOGICAL = {"&&", "||"}
ASSIGNS = {"=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>="}
BINARY_OPS = COMPARISONS | LOGICAL | ASSIGNS | {"+", "-", "*", "/", "%", "&", "|", "^", "<<", ">>", ","}
UNARY_PREFIX = {"-", "+", "!", "~", "*", "&", "++", "--"}
WRAPPERS = {CursorKind.UNEXPOSED_EXPR, CursorKind.PAREN_EXPR}
COMMENT = re.compile(r"//[^\n]*|/\*.*?\*/", re.S)
IDENTIFIER = re.compile(r"[A-Za-z_]\w*")
MACRO_USE = re.compile(r"([A-Za-z_]\w*)\s*\((.*)\)\s*;?", re.S)
# Raven's vector macros by the table of docs/transcription.md, "Vectors and the vector macros".
# The parse expands a macro and keeps no extent for its arguments, so each entry holds the shape of the expansion's first
# component with Raven's parameter names as placeholders, and the draft matches the shape to find the argument nodes.
# In a shape, `bin` is a binary operator, `sub` an array subscript with the base as its one child, `neg` a unary minus,
# and `_` any node. A comma chain of three components reads `components[0..2]`, and the shape names the component it matches.
VECTOR_MACROS = {
    "VectorAdd": (("a", "b", "c"), 3, [(0, ("bin", ("sub", "c"), ("bin", ("sub", "a"), ("sub", "b"))))], "{c} = {a} + {b}"),
    "VectorSubtract": (("a", "b", "c"), 3, [(0, ("bin", ("sub", "c"), ("bin", ("sub", "a"), ("sub", "b"))))], "{c} = {a} - {b}"),
    "VectorScale": (("v", "s", "o"), 3, [(0, ("bin", ("sub", "o"), ("bin", ("sub", "v"), "s")))], "{o} = {v} * {s}"),
    "VectorCopy": (("a", "b"), 3, [(0, ("bin", ("sub", "b"), ("sub", "a")))], "{b} = {a}"),
    "VectorMA": (("v", "s", "b", "o"), 3, [(0, ("bin", ("sub", "o"), ("bin", ("sub", "v"), ("bin", ("sub", "b"), "s"))))], "_VectorMA({v}, {s}, {b}, &{o})"),
    "VectorNegate": (("a", "b"), 3, [(0, ("bin", ("sub", "b"), ("neg", ("sub", "a"))))], "{b} = -{a}"),
    "VectorClear": (("a",), 1, [(0, ("bin", ("sub", "a"), "_"))], "{a} = JKAShared.vec3_t(0, 0, 0)"),
    "VectorSet": (("v", "x", "y", "z"), 3, [(0, ("bin", ("sub", "v"), "x")), (1, ("bin", "_", "y")), (2, ("bin", "_", "z"))], "{v} = JKAShared.vec3_t({x}, {y}, {z})"),
    "DotProduct": (("x", "y"), 3, [(0, ("bin", ("sub", "x"), ("sub", "y")))], "_DotProduct({x}, {y})"),
}
# Macros q_math.swift and q_shared.h.swift port as functions, so a use is a call, in the same shape table.
# `cast` is a C cast with the operand as its one child, `call` a call with the arguments as its children after the callee,
# and `block` a compound statement whose first statement the shape matches, the SnapVector form.
VECTOR_MACROS.update({
    "Q_fabs": (("x",), 1, [(0, ("call", "x"))], "Q_fabs({x})"),
    "DEG2RAD": (("a",), 1, [(0, ("bin", ("bin", "a", "_"), "_"))], "DEG2RAD({a})"),
    "RAD2DEG": (("a",), 1, [(0, ("bin", ("bin", "a", "_"), "_"))], "RAD2DEG({a})"),
    "ANGLE2SHORT": (("x",), 1, [(0, ("bin", ("cast", ("bin", ("bin", "x", "_"), "_")), "_"))], "ANGLE2SHORT({x})"),
    "SHORT2ANGLE": (("x",), 1, [(0, ("bin", "x", "_"))], "SHORT2ANGLE({x})"),
    "SnapVector": (("v",), 1, [(0, ("block", ("bin", ("sub", "v"), "_")))], "SnapVector(&{v})"),
})
# A macro argument that is a path with plain subscripts, `pm->ps->velocity[2]`, so the index texts pair with the subscript nodes.
PATH_ARG = re.compile(r"&?\s*[A-Za-z_]\w*(\s*(->|\.)\s*[A-Za-z_]\w*|\s*\[[^\[\]]*\])*")
SIMPLE_ARG = re.compile(r"-?\s*(\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?[fF]?|[A-Za-z_]\w*")
FUNC_LINE = re.compile(r"func\s+`?(\w+)`?\s*\((.*)\)")


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
        self.inout: dict[str, set[int]] = {}
        for path in SOURCES.rglob("*.swift"):
            for line in path.read_text().splitlines():
                m = FUNC_LINE.search(line)
                if m is None or "func " not in line.split("//")[0]:
                    continue
                positions = {i for i, p in enumerate(split_params(m.group(2))) if p.split(":", 1)[-1].strip().startswith("inout ")}
                self.inout.setdefault(m.group(1), positions)


class Hole(Exception):
    """A construct the draft has no rule for. The message is the reason the Port-note carries."""


class Drafter:
    def __init__(self, sk: Skeleton, registry: Registry) -> None:
        self.sk = sk
        self.views = sk.table.views
        self.registry = registry
        self.holes = 0
        self.in_macro = False
        self.macro_indexes: list[str] = []

    # MARK: - One function

    def draft(self, fn: Function) -> list[str]:
        header = self.sk.stub(fn)
        if not fn.mapped or not header[-1].startswith("}"):
            return header
        self.fn = fn
        self.source = self.sk.source(fn.stem)
        self.bytes = (C.ORACLE / ORACLE_DIR / f"{fn.stem}.c").read_bytes()
        self.names = {c.spelling: p.name for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.inout_locals = {c.spelling for c, p in zip(fn.cur.get_arguments(), fn.params) if (p.swift or "").startswith("inout ")}
        body = [c for c in fn.cur.get_children() if c.kind == CursorKind.COMPOUND_STMT][-1]
        lines = header[:-3]
        lines += self.block_body(body, 1)
        lines.append("}")
        return lines

    # MARK: - Statements

    def block_body(self, block: ci.Cursor, depth: int) -> list[str]:
        """The statements of a compound statement, with Raven's comment and blank lines between them."""
        out: list[str] = []
        children = list(block.get_children())
        previous_line = block.extent.start.line
        for child in children:
            out += self.gap(previous_line, child.extent.start.line, depth)
            out += self.statement(child, depth)
            previous_line = child.extent.end.line
        out += self.gap(previous_line, block.extent.end.line, depth)
        while out and not out[0].strip():
            out.pop(0)
        while out and not out[-1].strip():
            out.pop()
        return out

    def gap(self, after: int, before: int, depth: int) -> list[str]:
        """Raven's comment and blank lines strictly between two statements, re-indented."""
        out: list[str] = []
        for line in self.source.lines[after:before - 1]:
            text = line.strip()
            if not text:
                out.append("")
            elif text.startswith("//") or (text.startswith("/*") and text.endswith("*/")):
                out.append(INDENT * depth + text)
        return out

    def trailing(self, cur: ci.Cursor) -> str:
        """Raven's comment on the last line of a statement, after the statement's text."""
        line = self.source.lines[cur.extent.end.line - 1]
        rest = line[cur.extent.end.column - 1:].strip().lstrip(";").strip()
        return f" {rest}" if rest.startswith("//") else ""

    def statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        try:
            return self.statement_lines(cur, depth)
        except Hole as hole:
            return self.hole(cur, depth, str(hole))

    def hole(self, cur: ci.Cursor, depth: int, reason: str) -> list[str]:
        self.holes += 1
        pad = INDENT * depth
        raven = " ".join(self.source.slice(cur.extent).split())
        return [
            f"{pad}// Port-note: {reason}",
            f"{pad}// Raven wrote: {raven}",
            f'{pad}portMissing("{self.fn.name}", source: "{self.fn.cite}")',
        ]

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

    def macro_span(self, cur: ci.Cursor) -> bool:
        """True when the node's whole text is one name, so the node is a macro use and its children keep no text of their own."""
        return IDENTIFIER.fullmatch(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()) is not None

    def statement_lines(self, cur: ci.Cursor, depth: int) -> list[str]:
        pad = INDENT * depth
        if cur.kind == CursorKind.UNEXPOSED_EXPR and len(list(cur.get_children())) == 1 and not self.is_call(cur):
            return self.statement_lines(list(cur.get_children())[0], depth)
        kind = cur.kind
        if kind == CursorKind.COMPOUND_STMT:
            macro = self.macro_use(cur)
            if macro is not None:
                return [f"{pad}{macro}" + self.trailing(cur)]
            return [f"{pad}do {{"] + self.block_body(cur, depth + 1) + [f"{pad}}}"]
        if kind == CursorKind.DECL_STMT:
            return [pad + line for line in self.declarations(cur)]
        if kind == CursorKind.RETURN_STMT:
            kids = list(cur.get_children())
            if not kids:
                return [f"{pad}return" + self.trailing(cur)]
            value = self.coerced(kids[0], self.fn.returns)
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
        if kind in (CursorKind.GOTO_STMT, CursorKind.LABEL_STMT):
            raise Hole("Raven's goto has no Swift form, and the transcriptor restructures the flow.")
        if kind == CursorKind.UNARY_OPERATOR:
            op, prefix, operand = self.unary_parts(cur)
            if op in ("++", "--"):
                return [f"{pad}{self.expr(operand)} {op[0]}= 1" + self.trailing(cur)]
        if kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
            op = self.binary_op(cur)
            if op in ASSIGNS:
                left, right = list(cur.get_children())
                target = self.expr(left)
                inner = self.strip(right)
                if op == "=" and inner.kind == CursorKind.BINARY_OPERATOR and not self.macro_span(inner) and self.binary_op(inner) == "=":
                    # Raven's `a = b = 0` sets b, then a from b, so the draft writes the two stores in that order.
                    lines = self.statement_lines(inner, depth)
                    lines.append(f"{pad}{target} = {self.expr(list(inner.get_children())[0])}" + self.trailing(cur))
                    return lines
                value = self.coerced(right, self.swift_type_of(left)) if op == "=" else self.expr(right)
                return [f"{pad}{target} {op} {value}" + self.trailing(cur)]
        if self.is_call(cur):
            return [f"{pad}{self.expr(cur)}" + self.trailing(cur)]
        if kind.is_expression():
            macro = self.macro_use(cur)
            if macro is not None:
                return [f"{pad}{macro}" + self.trailing(cur)]
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
        out = [f"{pad}if {self.condition(cond)} {{"] + self.branch(then, depth + 1)
        if len(kids) == 3:
            other = kids[2]
            if other.kind == CursorKind.IF_STMT:
                nested = self.if_statement(other, depth)
                out.append(f"{pad}}} else {nested[0].strip()}")
                out += nested[1:]
                return out
            out.append(f"{pad}}} else {{")
            out += self.branch(other, depth + 1)
        out.append(f"{pad}}}")
        return out

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
        groups: list[tuple[list[str], list[ci.Cursor]]] = []
        for child in body.get_children():
            labels: list[str] = []
            stmt = child
            while stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT):
                inner = list(stmt.get_children())
                if stmt.kind == CursorKind.CASE_STMT:
                    labels.append(self.expr(inner[0]))
                    stmt = inner[-1]
                else:
                    labels.append("default")
                    stmt = inner[0]
            if labels:
                groups.append((labels, []))
            if not groups:
                raise Hole("A statement before the first case of the switch.")
            if stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT) or stmt is child and labels and stmt.kind == CursorKind.NULL_STMT:
                continue
            groups[-1][1].append(stmt)
        out = [f"{pad}switch {self.expr(subject)} {{"]
        for i, (labels, stmts) in enumerate(groups):
            label = "default" if labels == ["default"] else "case " + ", ".join(l for l in labels if l != "default")
            if "default" in labels and len(labels) > 1:
                label = "default"
            out.append(f"{pad}{label}:")
            ends_in_break = bool(stmts) and stmts[-1].kind == CursorKind.BREAK_STMT
            ends_in_exit = bool(stmts) and stmts[-1].kind in (CursorKind.RETURN_STMT, CursorKind.CONTINUE_STMT)
            inner_stmts = stmts[:-1] if ends_in_break else stmts
            lines: list[str] = []
            previous_line = None
            for s in inner_stmts:
                if previous_line is not None:
                    lines += self.gap(previous_line, s.extent.start.line, depth + 1)
                lines += self.statement(s, depth + 1)
                previous_line = s.extent.end.line
            if not ends_in_break and not ends_in_exit and i + 1 < len(groups):
                lines.append(f"{INDENT * (depth + 1)}fallthrough")
            if not lines:
                lines.append(f"{INDENT * (depth + 1)}break")
            out += lines
            if i + 1 < len(groups):
                out.append("")
        out.append(f"{pad}}}")
        return out

    def declarations(self, cur: ci.Cursor) -> list[str]:
        out: list[str] = []
        for var in cur.get_children():
            if var.kind != CursorKind.VAR_DECL:
                raise Hole(f"A {var.kind.name} inside a declaration.")
            name = swift_name(var.spelling)
            t = var.type
            init = [c for c in var.get_children() if c.kind.is_expression()]
            if t.get_canonical().kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t):
                if init:
                    raise Hole("A vector local with an initializer.")
                out.append(f"var {name} = JKAShared.vec3_t(0, 0, 0)")
                continue
            if t.get_canonical().kind == TypeKind.POINTER:
                record = self.views.record_name(t.get_canonical().get_pointee())
                if record and record in self.views.views:
                    view = self.views.qualified_view(record, TARGET)
                    if init:
                        out.append(f"var {name}: {view}? = {self.expr(init[0])}")
                    else:
                        out.append(f"var {name}: {view}?")
                    continue
                raise Hole(f"A pointer local `{t.spelling} {var.spelling}` with no view.")
            swift = self.views.scalar(t, TARGET)
            if swift is None:
                raise Hole(f"A local `{t.spelling} {var.spelling}` the table has no type for.")
            if self.views.narrow(t) is not None:
                swift = "Int32"
            if init:
                out.append(f"var {name}: {swift} = {self.coerced(init[0], swift)}")
            else:
                out.append(f"var {name}: {swift}")
        return out

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
        """`Bool` for a qboolean-typed expression, so an assignment coerces its right side. Anything else takes the value as written."""
        return "Bool" if self.is_bool(cur) else None

    def is_bool(self, cur: ci.Cursor) -> bool:
        """True when the expression already is a Swift Bool: a comparison, a logical operator, a `!`, qtrue, qfalse, or a qboolean."""
        cur = self.strip(cur)
        if cur.kind == CursorKind.PAREN_EXPR:
            return self.is_bool(list(cur.get_children())[0])
        if cur.kind == CursorKind.BINARY_OPERATOR:
            return self.binary_op(cur) in COMPARISONS | LOGICAL
        if cur.kind == CursorKind.UNARY_OPERATOR:
            return self.unary_parts(cur)[0] == "!"
        if cur.kind == CursorKind.DECL_REF_EXPR and cur.spelling in ("qtrue", "qfalse"):
            return True
        return cur.type.spelling.replace("const ", "") == "qboolean"

    def is_pointer(self, cur: ci.Cursor) -> bool:
        return self.strip(cur).type.get_canonical().kind == TypeKind.POINTER

    def condition(self, cur: ci.Cursor) -> str:
        """A C truth test as a Swift Bool: a Bool as it is, a pointer against nil, a number against 0."""
        return self.coerced(cur, "Bool")

    def coerced(self, cur: ci.Cursor, swift: str | None) -> str:
        if swift != "Bool":
            return self.expr(cur)
        if self.is_bool(cur):
            return self.expr(cur)
        inner = self.strip(cur)
        if inner.kind == CursorKind.PAREN_EXPR:
            return self.coerced(list(inner.get_children())[0], "Bool")
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

    def expr(self, cur: ci.Cursor) -> str:
        kind = cur.kind
        if self.strip(cur).kind not in (CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR) and not self.in_macro:
            # A node whose whole text is one name is a macro use, `ENTITYNUM_WORLD`, and the name is what Raven wrote.
            text = self.source.slice(cur.extent).strip()
            if IDENTIFIER.fullmatch(text):
                return swift_name(text)
            macro = self.macro_use(cur)
            if macro is not None:
                return macro
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
            return f"Int32(ascii: {text.replace(chr(39), chr(34))})" if len(text) == 3 else self.hole_text(cur, "A character literal with an escape.")
        if kind == CursorKind.STRING_LITERAL:
            return self.source.slice(cur.extent)
        if kind == CursorKind.DECL_REF_EXPR:
            return self.reference(cur)
        if kind == CursorKind.MEMBER_REF_EXPR:
            return self.member(cur)
        if kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            base, index = list(cur.get_children())
            if self.in_macro and self.macro_indexes:
                # The outermost subscript is the last one in Raven's text.
                word = self.simple_argument(self.macro_indexes.pop().strip())
                if word is None:
                    raise Hole("A subscript inside a macro argument that is more than a name or a number.")
                return f"{self.base(base)}[{word}]"
            return f"{self.base(base)}[{self.expr(index)}]"
        if kind == CursorKind.CALL_EXPR:
            return self.call(cur)
        if kind == CursorKind.UNARY_OPERATOR:
            op, prefix, operand = self.unary_parts(cur)
            if op == "!":
                inner = self.strip(operand)
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
                return f"{self.condition(left)} {op} {self.condition(right)}"
            if op in ASSIGNS:
                raise Hole("An assignment inside an expression.")
            return f"{self.expr(left)} {op} {self.expr(right)}"
        if kind == CursorKind.CONDITIONAL_OPERATOR:
            test, yes, no = list(cur.get_children())
            return f"{self.condition(test)} ? {self.expr(yes)} : {self.expr(no)}"
        if kind == CursorKind.CSTYLE_CAST_EXPR:
            return self.cast(cur)
        if kind == CursorKind.CXX_UNARY_EXPR:
            raise Hole("A sizeof the draft cannot size.")
        raise Hole(f"No rule for a {kind.name} expression.")

    def macro_use(self, cur: ci.Cursor) -> str | None:
        """Raven's `VectorCopy(a, b)` as the table's Swift. The name and the argument texts come from Raven's line, and an
        argument that is more than a name or a number comes from the node the shape of the expansion puts in its place."""
        if self.in_macro:
            return None
        start, end = cur.extent.start.offset, cur.extent.end.offset
        text = self.bytes[start:end].decode("utf-8", "replace")
        m = MACRO_USE.fullmatch(text.strip())
        if m is None:
            return None
        name = m.group(1)
        if name not in VECTOR_MACROS:
            return None
        if cur.kind == CursorKind.CALL_EXPR and cur.spelling == name:
            return None
        texts = self.argument_texts(text[text.index("(") + 1:])
        params, count, shapes, template = VECTOR_MACROS[name]
        if len(texts) != len(params):
            raise Hole(f"{name} takes {len(params)} arguments, and Raven gave {len(texts)}.")
        components = self.components(cur, count)
        found: dict[str, ci.Cursor] = {}
        for index, shape in shapes:
            if not self.match(components[index], shape, found):
                raise Hole(f"The expansion of {name} does not have the shape the draft knows.")
        words: dict[str, str] = {}
        self.in_macro = True
        try:
            for param, t in zip(params, texts):
                simple = self.simple_argument(t)
                words[param] = simple if simple is not None else self.path_argument(found[param], t)
        finally:
            self.in_macro = False
        return template.format(**words)

    def path_argument(self, node: ci.Cursor, text: str) -> str:
        """A macro argument from its node, with the subscript indexes taken from Raven's text, because the nodes keep no number."""
        if PATH_ARG.fullmatch(text) is not None:
            self.macro_indexes = re.findall(r"\[([^\[\]]*)\]", text)
        else:
            self.macro_indexes = []
        try:
            return self.expr(node)
        finally:
            self.macro_indexes = []

    def argument_texts(self, text: str) -> list[str]:
        """The argument texts of a macro use, split at the commas outside brackets, up to the closing parenthesis."""
        out: list[str] = []
        depth = 0
        start = 0
        for i, ch in enumerate(text):
            if ch in "([":
                depth += 1
            elif ch in ")]":
                if depth == 0:
                    out.append(text[start:i].strip())
                    return out
                depth -= 1
            elif ch == "," and depth == 0:
                out.append(text[start:i].strip())
                start = i + 1
        raise Hole("A macro use with no closing parenthesis.")

    def simple_argument(self, text: str) -> str | None:
        """A name or a number as Raven wrote it, or None for an argument the AST must translate."""
        if SIMPLE_ARG.fullmatch(text) is None:
            return None
        if text[0] == "-" or text[0].isdigit() or text[0] == ".":
            return re.sub(r"[fF]$", "", text.replace(" ", ""))
        if text == "qtrue":
            return "true"
        if text == "qfalse":
            return "false"
        if text in self.names:
            return self.names[text]
        if text in HAND_VARS:
            return HAND_VARS[text]
        return swift_name(text)

    def components(self, cur: ci.Cursor, count: int) -> list[ci.Cursor]:
        """The components of a left-leaning comma chain, or the one node when the macro has one component."""
        node = self.unwrap(cur)
        if count == 1:
            return [node]
        out = [node]
        for _ in range(count - 1):
            left, right = list(out[0].get_children())
            out[0:1] = [self.unwrap(left), self.unwrap(right)]
        return out

    def unwrap(self, cur: ci.Cursor) -> ci.Cursor:
        while cur.kind in (CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR):
            kids = list(cur.get_children())
            if len(kids) != 1:
                break
            cur = kids[0]
        return cur

    def match(self, cur: ci.Cursor, shape, found: dict[str, ci.Cursor]) -> bool:
        cur = self.unwrap(cur)
        if isinstance(shape, str):
            if shape != "_":
                found[shape] = cur
            return True
        head, *parts = shape
        kids = list(cur.get_children())
        if head == "bin":
            return cur.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2 and all(self.match(k, p, found) for k, p in zip(kids, parts))
        if head == "sub":
            return cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and len(kids) == 2 and self.match(kids[0], parts[0], found)
        if head == "neg":
            return cur.kind == CursorKind.UNARY_OPERATOR and len(kids) == 1 and self.match(kids[0], parts[0], found)
        if head == "cast":
            return cur.kind == CursorKind.CSTYLE_CAST_EXPR and bool(kids) and self.match(kids[-1], parts[0], found)
        if head == "call":
            return cur.kind == CursorKind.CALL_EXPR and len(kids) == len(parts) + 1 and all(self.match(k, p, found) for k, p in zip(kids[1:], parts))
        if head == "block":
            return cur.kind == CursorKind.COMPOUND_STMT and bool(kids) and self.match(kids[0], parts[0], found)
        return False

    def hole_text(self, cur: ci.Cursor, reason: str) -> str:
        raise Hole(reason)

    def literal(self, cur: ci.Cursor) -> str:
        """Raven's spelling, which keeps a macro name where he wrote one, with the C suffixes dropped."""
        if self.in_macro:
            raise Hole("A number inside a macro argument, which the expansion keeps no text for.")
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
        return swift_name(name)

    def optional_base(self, cur: ci.Cursor) -> bool:
        """True when the expression is a pointer a Swift view holds as optional, so a member read through it takes `!`."""
        inner = self.strip(cur)
        if inner.kind == CursorKind.PAREN_EXPR:
            return self.optional_base(list(inner.get_children())[0])
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
        return f"{self.base(kids[0])}.{swift_name(cur.spelling)}"

    def call(self, cur: ci.Cursor) -> str:
        kids = list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        args = kids[1:]
        if callee is not None and callee.kind == CursorKind.DECL_REF_EXPR and callee.referenced is not None and callee.referenced.kind == CursorKind.FUNCTION_DECL:
            name = callee.spelling
            inout = self.inout_positions(name)
            words = [self.argument(a, i in inout) for i, a in enumerate(args)]
            return f"{swift_name(name)}({', '.join(words)})"
        if callee is not None:
            words = [self.argument(a, False) for a in args]
            return f"{self.expr(callee)}({', '.join(words)})"
        raise Hole("A call with no callee.")

    def inout_positions(self, name: str) -> set[int]:
        fn = self.sk.by_name.get(name)
        if fn is not None and fn.mapped:
            return {i for i, p in enumerate(fn.params) if (p.swift or "").startswith("inout ")}
        return self.registry.inout.get(name, set())

    def argument(self, cur: ci.Cursor, inout: bool) -> str:
        inner = self.strip(cur)
        if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
            inner = self.unary_parts(inner)[2]
        text = self.expr(inner)
        return f"&{text}" if inout else text

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
        if self.in_macro and left.extent.end.offset == right.extent.start.offset:
            raise Hole("Arithmetic inside a macro argument, which the expansion keeps no text for.")
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
        raise Hole(f"No operator beside the operand, the text there is `{before or after}`.")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", help="comma-separated function names to print")
    parser.add_argument("--stem", help="print every draft of one .c file")
    args = parser.parse_args()
    sk = Skeleton()
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
