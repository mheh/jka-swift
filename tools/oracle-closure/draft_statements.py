"""draft_statements.py: the statement half of the drafter, one Swift statement for each of Raven's.
It walks a compound block, keeps his blank lines and his comments in their places, and gives the `if`, `for`, and `switch` forms their Swift shape.
A statement it has no rule for raises a Hole, and the draft keeps Raven's text under a Port-note in its place."""

from __future__ import annotations

import re
from contextlib import contextmanager

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

import closure as C
from rulings import WRAPPING_ARITHMETIC
from skeleton import LOGIC, target_of
from table import ASSIGN_OPS, TARGET, swift_name
from overlay import DROPPED, MACROS, RECORD_CALLS, address_arguments

from draft_classification import ROLE_MARK, TRAILING, Hole, blank, marked, roled
from layout import COMPILE_NOTE, INDENT
from draft_declarations import extent_key
from draft_expressions import IDENTIFIER, NUMBER



def flat_comment(text: str, opens: bool, closes: bool) -> str:
    """One line of Raven's `/* */` comment, with each inner `/*` spelled `/ *` and each inner `*/` spelled `* /`.
    C ends a block comment at the first `*/` and reads an inner `/*` as text, but Swift nests the pair, so an inner opener never closes.
    `opens` keeps the leading `/*` of the line, and `closes` keeps the trailing `*/`."""
    start = 2 if opens else 0
    end = len(text) - 2 if closes else len(text)
    body = text[start:end].replace("/*", "/ *").replace("*/", "* /")
    if closes and body.endswith("/"):
        body += " "
    return text[:start] + body + text[end:]

class Statements:
    """The statement half of the drafter."""

    def block_body(self, block: ci.Cursor, depth: int) -> list[str]:
        """The statements of a compound statement, with Raven's comment and blank lines between them."""
        out = self.opening(block, depth) + self.statements(list(block.get_children()), block.extent.start.line, block.extent.end.line, depth)
        while out and blank(out[0]):
            out.pop(0)
        while out and blank(out[-1]):
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
            out += self.shared_read_lines(child, depth)
            # A record or a choice whose statement the compile gate rejected is a hole, and the statements after it draft at this depth.
            if record is not None and self.compile_message(child) is None:
                self.lowered_as(child, "scratch", depth)
                out += marked(self.scratch(child, record, children[i + 1:], last_line, depth), self.statement_number(child))
                return out
            chosen = self.chosen_choice(child, children[i + 1:])
            if chosen is not None and self.compile_message(child) is None:
                self.lowered_as(child, "choice", depth)
                out += marked(self.choice(chosen, child, children[i + 1:], last_line, depth), self.statement_number(child))
                return out
            out += self.statement(child, depth)
            self.after_com_error = self.is_call(child) and self.callee_name(child) == "Com_Error"
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
        self.lowered_as(label, "label", depth)
        out: list[str] = []
        # A record local before the label lives to the end of Raven's block, so its closure holds the label and every statement after it.
        # A goto before the record would leave the closure, so the record then stays in the labeled block.
        first = next((k for k in range(i) if self.record_local(children[k]) is not None), None)
        if first is not None and (before or after) and not any(g.extent.start.offset < children[first].extent.end.offset for g in before):
            decl = children[first]
            end = children[first - 1].extent.end.line if first else previous_line
            out += self.statements(children[:first], previous_line, end, depth)
            out += self.param_copy_lines(depth)
            out += self.gap(end, decl.extent.start.line, depth)
            out += self.shared_read_lines(decl, depth)
            self.lowered_as(decl, "scratch", depth)
            out += marked(self.scratch(decl, self.record_local(decl), children[first + 1:], last_line, depth), self.statement_number(decl))
            return out
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
            # The frame and the lines inside it take the label's mark, and the statements after the frame keep their own.
            frame = roled([f"{pad}{name}: do {{"], "frame")
            frame += self.statements(region[lead:], region[lead].extent.start.line - 1 if lead < len(region) else label.extent.start.line - 1,
                                     label.extent.start.line, depth + 1)
            frame += roled([f"{pad}}}"], "frame")
            out += marked(frame, self.statement_number(label))
            out += self.statements(rest, label.extent.start.line, last_line, depth)
            return out
        if after and not before:
            if self.escapes(rest):
                raise Hole(f"A break or a continue after Raven's `{name}:` targets a loop outside it, and the transcriptor restructures the flow.")
            self.goto_forms[name] = f"continue {name}"
            out += self.statements(children[:i], previous_line, label.extent.start.line, depth)
            out += self.param_copy_lines(depth)
            # The frame, the lines inside it, and its `break` take the label's mark.
            frame = roled([f"{pad}{name}: while true {{"], "frame")
            frame += self.statements(rest, label.extent.start.line, last_line, depth + 1)
            frame += roled([f"{INDENT * (depth + 1)}break", f"{pad}}}"], "frame")
            out += marked(frame, self.statement_number(label))
            return out
        raise Hole(f"Raven's `{name}:` takes a goto from both sides, and the transcriptor restructures the flow.")

    def choice(self, name: str, chain: ci.Cursor, rest: list[ci.Cursor], last_line: int, depth: int) -> list[str]:
        """Raven's choice between two file-scope variables, with his statements after it as a nested function over the one he chose.

        The nested function takes the chosen variable as an inout parameter, and each arm of his chain calls it with the variable of that arm."""
        pad = INDENT * depth
        record = self.chosen_locals[name]
        self.reachable(record)
        view = self.views.qualified_view(record, TARGET)
        returns = f" -> {self.fn.returns}" if self.fn.returns else ""
        out = [f"{pad}// Raven points `{name}` at one of the file-scope variables, and the statements after his choice run over the one he chose.",
               f"{pad}// The chosen variable crosses as an inout parameter, and each arm of the choice calls the nested function with its own variable.",
               f"{pad}func {self.chosen_helper(name)}(_ {swift_name(name)}: inout {view}?){returns} {{"]
        out = roled(out, "frame")
        body = self.statements(rest, chain.extent.end.line, last_line, depth + 1)
        while body and blank(body[0]):
            body.pop(0)
        while body and blank(body[-1]):
            body.pop()
        out += body
        out += roled([f"{pad}}}"], "frame")
        out += self.statement(chain, depth)
        return out

    def gap(self, after: int, before: int, depth: int) -> list[str]:
        """Raven's comment and blank lines strictly between two statements, re-indented."""
        out: list[str] = []
        block = False
        for line in self.source.lines[after:before - 1]:
            text = line.strip()
            if block:
                # A line inside Raven's `/* */` comment keeps its text, and the first `*/` ends the block, as in C.
                # Raven's code after the close on the same line, `}*/ else`, is syntax the statements already carry.
                closes = "*/" in text
                text = text[:text.index("*/") + 2] if closes else text
                out.append(INDENT * depth + flat_comment(text, False, closes) if text else "")
                block = not closes
            elif not text:
                out.append("")
            elif text.startswith("//"):
                out.append(INDENT * depth + text)
            elif text.startswith("/*"):
                closes = "*/" in text[2:]
                text = text[:text.index("*/", 2) + 2] if closes else text
                out.append(INDENT * depth + flat_comment(text, True, closes))
                block = not closes
        if block:
            # Raven closes the comment on the line of the next statement, `else */if ( cpFlags & CP_FLANK )`, so the close ends the block here.
            line = self.source.lines[before - 1]
            if "*/" in line:
                out.append(INDENT * depth + flat_comment(line[:line.index("*/") + 2].strip(), False, True))
        return roled(out, "comment")

    def opening(self, block: ci.Cursor, depth: int) -> list[str]:
        """Raven's comment on the line of the opening brace, `{ //lost it`, as the first line of the block."""
        line = self.source.lines[block.extent.start.line - 1]
        rest = line[block.extent.start.column:].strip()
        if rest.startswith("//"):
            return roled([INDENT * depth + rest], "comment")
        if rest.startswith("/*") and rest.endswith("*/") and len(rest) >= 4:
            return roled([INDENT * depth + flat_comment(rest, True, True)], "comment")
        return []

    def trailing(self, cur: ci.Cursor) -> str:
        """Raven's comment on the last line of a statement, after the statement's text, behind the mark that prints as one space."""
        rest = self.trailing_comment(cur)
        return f"{TRAILING}{rest}" if rest else ""

    def trailing_comment(self, cur: ci.Cursor) -> str:
        """Raven's comment on the last line of a statement, or the empty text when the line holds none."""
        line = self.source.lines[cur.extent.end.line - 1]
        rest = line[cur.extent.end.column - 1:].strip().lstrip(";").strip()
        return rest if rest.startswith("//") else ""

    def statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        self.lowered_as(cur, None, depth)
        outer = self.pending
        self.pending = []
        lines = self.compile_hole(cur, depth)
        if lines is None:
            try:
                lines = self.statement_lines(cur, depth)
                missed = self.hole_local_use(cur)
                if missed is not None:
                    # A form that spells a name with no read through `reference` still reads the local, `total += previousTimes[i]`.
                    raise Hole(missed)
            except Hole as hole:
                lines = self.hole(cur, depth, str(hole))
        lines = [INDENT * depth + line for line in roled(self.pending, "lifted")] + lines
        self.pending = outer
        return marked(lines, self.statement_number(cur))

    def hole_local_use(self, cur: ci.Cursor) -> str | None:
        """The hole reason of the first use of a hole local in the statement's own expressions, or None when it uses none.
        A nested statement is its own statement and gets its own check, and a declaration checks only the locals it drafted."""
        if not self.local_holes:
            return None
        if cur.kind.is_expression():
            roots = [cur]
        elif cur.kind == CursorKind.DECL_STMT:
            roots = [k for var in cur.get_children() if var.kind == CursorKind.VAR_DECL and var.spelling not in self.local_holes
                     for k in var.get_children() if k.kind.is_expression()]
        else:
            # A body is the nested statement, braced or not, so a loop or a branch checks its condition alone.
            kids = list(cur.get_children())
            if cur.kind in (CursorKind.IF_STMT, CursorKind.WHILE_STMT, CursorKind.SWITCH_STMT, CursorKind.CASE_STMT):
                kids = kids[:1]
            elif cur.kind == CursorKind.DO_STMT:
                kids = kids[-1:]
            elif cur.kind == CursorKind.FOR_STMT:
                kids = kids[:-1]
            elif cur.kind in (CursorKind.LABEL_STMT, CursorKind.DEFAULT_STMT, CursorKind.COMPOUND_STMT):
                kids = []
            roots = [k for k in kids if k.kind.is_expression()]
        for root in roots:
            stores = self.store_targets(root)
            for node in root.walk_preorder():
                if node.kind == CursorKind.DECL_REF_EXPR and node.spelling in self.local_holes \
                        and node.referenced is not None and node.referenced.kind == CursorKind.VAR_DECL:
                    return self.hole_local_reason(node.spelling, extent_key(node) in stores)
        return None

    def store_targets(self, root: ci.Cursor) -> set[tuple[str, int, int]]:
        """The extents of the names a plain `=` stores into, `x = v` or `x[i] = v`, which are stores and not reads."""
        out: set[tuple[str, int, int]] = set()
        for node in root.walk_preorder():
            kids = list(node.get_children())
            if node.kind != CursorKind.BINARY_OPERATOR or len(kids) != 2 or self.operator_or_none(node) != "=":
                continue
            left = self.unwrap(kids[0])
            if left.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
                left = self.strip(list(left.get_children())[0])
            if left.kind == CursorKind.DECL_REF_EXPR:
                out.add(extent_key(left))
        return out

    def statement_key(self, cur: ci.Cursor) -> tuple[str, str, int, int]:
        """One statement's identity across two drafts of the same function, by the function and the statement's extent."""
        return (self.fn.cur.spelling,) + extent_key(cur)

    def statement_number(self, cur: ci.Cursor) -> int:
        """The number of a statement's mark, which the drafter reads back as the statement's key."""
        key = self.statement_key(cur)
        if key not in self.statement_numbers:
            self.statement_numbers[key] = len(self.statement_keys)
            self.statement_keys.append(key)
        return self.statement_numbers[key]

    def lowered_as(self, cur: ci.Cursor, form: str | None, depth: int) -> None:
        """Keep the depth of a statement the draft reaches, and its form when the form does not show in its lines.
        A statement drafted twice, a loop step before a `continue` and at the loop end, keeps the first depth."""
        number = self.statement_number(cur)
        self.drafted.setdefault(number, depth)
        if form is not None:
            self.forms[number] = form

    def compile_message(self, cur: ci.Cursor) -> str | None:
        """The compiler's message for a statement the compile gate rejected on an earlier pass, by its file, its function, and its seq.
        A statement the gate accepted has no message."""
        seq = self.statement_seqs.get(extent_key(cur))
        return None if seq is None else self.compile_due.get((self.fn.stem, self.fn.cur.spelling, seq))

    def compile_hole(self, cur: ci.Cursor, depth: int) -> list[str] | None:
        """The hole of a statement whose draft the compile gate rejected on an earlier pass, or None for a statement it accepted."""
        message = self.compile_message(cur)
        if message is None:
            return None
        self.compile_holes += 1
        return self.hole(cur, depth, COMPILE_NOTE.format(message))

    def tuple_call(self, cur: ci.Cursor) -> tuple[str, str] | None:
        """A call to a trap whose Swift form returns `(Int32, String)` or `(Bool, String)`: the call without Raven's buffer and size arguments,
        and the Swift text of the buffer Raven passed, which takes the returned text."""
        inner = self.strip(cur)
        if not self.is_call(inner):
            return None
        name = self.callee_name(inner)
        returns = self.registry.returns.get(name, "")
        if not name or not any(returns.startswith(f"({first}, {text})") for first in ("Int32", "Bool") for text in ("String", "JKAShared.CharBuf")):
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

    def filled_call(self, cur: ci.Cursor) -> tuple[str, str, bool] | None:
        """A call to a trap whose Swift form drops Raven's buffer and returns its text, `trap_Argv(1, arg, sizeof(arg))`:
        the call without the buffer, the Swift text of the buffer, and True for a list trap, which returns every byte as a CharBuf."""
        inner = self.strip(cur)
        if not self.is_call(inner):
            return None
        name = self.callee_name(inner)
        returns = self.registry.returns.get(name, "") if name else ""
        if returns not in ("String", "JKAShared.CharBuf"):
            return None
        params = self.callee_params(name)
        args = list(inner.get_children())[1:]
        buffer = next((a for a in args if self.is_charbuf(a)), None)
        if buffer is None or len(args) != len(params) + 1:
            return None
        # Only the buffer leaves the call. Raven's size argument stays, because the Swift trap still takes the capacity.
        kept = [a for a in args if a is not buffer]
        words = [self.argument(a, params[i][1].startswith("inout "), params[i], name, i) for i, a in enumerate(kept)]
        return f"{swift_name(name)}({', '.join(words)})", self.expr(buffer), returns == "JKAShared.CharBuf"

    def record_bytes(self, cur: ci.Cursor, depth: int) -> list[str]:
        """Raven's `memset` and `memcpy` over a whole record, as the view's `clear()` and `copy(from:)`. A memset of a record local
        drops, because the scratch slot is zero at entry. A memset of zero over one `char name[N]` field is the buffer accessor's `zero()`,
        and one over a `char buf[N]` local is the CharBuf's `zero()`."""
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
            # Raven's `memset(ent->name, 0, sizeof(ent->name))` over a record's `char name[N]` field, which the view's buffer accessor zero-fills.
            if self.zeroed_field(args):
                return [f"{pad}{self.buffer_expr(args[0])}.zero()" + self.trailing(cur)]
            # Raven's `memset(buf, 0, sizeof(buf))` over a `char buf[N]` local, which is a CharBuf of N bytes.
            local = self.zeroed_local(args)
            if local is not None:
                return [f"{pad}{self.expr(local)}.zero()" + self.trailing(cur)]
            # Raven's memset over a whole array of scalars or vectors is one value into every element, `totalDmg.fill(0)`.
            filled = self.filled_array(args)
            if filled is not None:
                target, value = filled
                return [f"{pad}{target}.fill({value})" + self.trailing(cur)]
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
            raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
            if not self.is_null(args[1]):
                raise Hole(f"Raven's `{raven}` fills the record with a value that is not zero, and a view's clear() writes zero.")
            if not self.whole_record_size(args[2], targets[0]):
                raise Hole(f"Raven's `{raven}` runs over a size that is not the record's own, and a view's clear() takes the whole record.")
            ref = targets[0].referenced if targets[0].kind == CursorKind.DECL_REF_EXPR else None
            scratch = ref is not None and ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None \
                and ref.semantic_parent.kind != CursorKind.TRANSLATION_UNIT and self.is_record(targets[0].type)
            if scratch and not self.loop_steps:
                # The record local itself, not a pointer to one, and outside every loop, so the slot is zero at this point.
                return [f"{pad}// Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call."]
            return [f"{pad}{self.expr(targets[0])}.clear()" + self.trailing(cur)]
        return [f"{pad}{self.expr(targets[0])}.copy(from: {self.expr(targets[1])})" + self.trailing(cur)]

    def filled_array(self, args: list[ci.Cursor]) -> tuple[str, str] | None:
        """The Swift array and the value for Raven's memset over a whole array of scalars or vectors, or None.
        The size is `sizeof` of the array, or `sizeof` of one element times the bound Raven declared, in either order.
        The value is zero for any element, and -1 for an integer element, whose every byte 0xff is -1 again."""
        if len(args) != 3:
            return None
        target = self.strip(args[0])
        if target.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(target)[0] == "&":
            target = self.strip(self.unary_parts(target)[2])
        t = self.unwrap(target).type.get_canonical()
        if t.kind != TypeKind.CONSTANTARRAY:
            return None
        element = t.element_type.get_canonical()
        inner = element
        while inner.kind == TypeKind.CONSTANTARRAY and not self.vector_type(inner):
            inner = inner.element_type.get_canonical()
        value = " ".join(self.source.slice(self.unwrap(args[1]).extent).split())
        if self.vector_type(inner):
            if value != "0":
                return None
            word = "vec3_t()"
        elif inner.kind in (TypeKind.FLOAT, TypeKind.DOUBLE):
            if value != "0":
                return None
            word = "0"
        elif inner.kind == TypeKind.ENUM and "qboolean" in self.unwrap(target).type.spelling:
            if value != "0":
                return None
            word = "false"
        elif inner.kind in (TypeKind.INT, TypeKind.UINT, TypeKind.SHORT, TypeKind.USHORT, TypeKind.ENUM):
            if value not in ("0", "-1"):
                return None
            word = value
        else:
            return None
        if element.kind == TypeKind.CONSTANTARRAY and not self.vector_type(element) and \
                (element.element_type.get_canonical().kind == TypeKind.CONSTANTARRAY):
            # Three dimensions have no fill.
            return None
        name = " ".join(self.source.slice(self.unwrap(target).extent).split()).replace(" ", "")
        size = self.source.slice(self.unwrap(args[2]).extent).replace(" ", "").replace("\t", "")
        ref = self.unwrap(target).referenced
        bound = self.declared_capacity(ref) if ref is not None else ""
        counts = {str(t.element_count)} | ({bound} if bound else set())
        units = {f"sizeof({name}[0])", f"sizeof(*{name})", f"sizeof({element.spelling.replace(' ', '')})"}
        if ref is not None:
            units |= {f"sizeof({ref.type.get_canonical().element_type.spelling.replace(' ', '')})"}
            spelled = [tok.spelling for tok in ref.get_tokens()]
            if spelled:
                units.add(f"sizeof({spelled[0]})")
        wholes = {f"sizeof({name})", f"sizeof{name}"} | {f"{u}*{c}" for u in units for c in counts} | {f"{c}*{u}" for u in units for c in counts}
        if size not in wholes:
            return None
        return self.expr(target), word

    def vector_type(self, t: ci.Type) -> bool:
        """True for Raven's `vec3_t`, an array of three floats."""
        canonical = t.get_canonical()
        return canonical.kind == TypeKind.CONSTANTARRAY and canonical.element_count == 3 \
            and canonical.element_type.get_canonical().kind == TypeKind.FLOAT

    def whole_record_size(self, size: ci.Cursor, target: ci.Cursor) -> bool:
        """True when Raven's size argument is `sizeof` of the record itself, of the pointer's pointee, or of the record's type,
        `sizeof(Vehicle_t)` through a `Vehicle_t *`, which names the pointee's type by any typedef of it."""
        text = " ".join(self.bytes[size.extent.start.offset:size.extent.end.offset].decode("utf-8", "replace").split())
        m = re.fullmatch(r"sizeof\s*\(?\s*(.*?)\s*\)?", text)
        if m is None:
            return False
        t = target.type.get_canonical()
        record_type = t.get_pointee().get_canonical() if t.kind == TypeKind.POINTER else t
        for node in size.walk_preorder():
            if node.kind == CursorKind.TYPE_REF and node.referenced is not None and node.referenced.type.get_canonical() == record_type:
                return True
        inner = m.group(1).replace(" ", "")
        record = " ".join(self.bytes[target.extent.start.offset:target.extent.end.offset].decode("utf-8", "replace").split()).replace(" ", "")
        t = target.type.get_canonical()
        pointee = t.get_pointee() if t.kind == TypeKind.POINTER else None
        names = {record, "*" + record, "(*" + record + ")", target.type.spelling.replace(" ", ""), t.spelling.replace(" ", "")}
        if pointee is not None:
            names |= {pointee.spelling.replace(" ", ""), pointee.get_canonical().spelling.replace(" ", "")}
        return inner in names

    def is_call(self, cur: ci.Cursor) -> bool:
        """A call, which the parse sometimes leaves unexposed: the first child names a function, and the rest are the arguments."""
        if cur.kind == CursorKind.CALL_EXPR:
            return True
        if cur.kind != CursorKind.UNEXPOSED_EXPR:
            return False
        kids = list(cur.get_children())
        if not kids:
            return False
        decays = cur.type.get_canonical().kind == TypeKind.POINTER and cur.type.get_canonical().get_pointee().kind == TypeKind.FUNCTIONPROTO
        if len(kids) == 1 and kids[0].kind == CursorKind.DECL_REF_EXPR and decays:
            # Raven names a function as a value, `ent->think = G_RunObject`, and the node is C's decay to a pointer, not a call.
            return False
        callee = self.strip(kids[0])
        ref = callee.referenced
        return callee.kind == CursorKind.DECL_REF_EXPR and ref is not None and ref.kind == CursorKind.FUNCTION_DECL

    def local_walk(self, ref: ci.Cursor) -> None:
        """A table walk reads its index from a local or from the file-scope index the skeleton gives a file-scope walk pointer, and any other walk is a hole."""
        decl = ref.referenced
        if decl is not None and decl.semantic_parent is not None and decl.semantic_parent.kind == CursorKind.TRANSLATION_UNIT \
                and ref.spelling not in self.sk.table.file_walks:
            raise Hole(f"Raven walks the file-scope pointer `{ref.spelling}` over a table, and the skeleton gives it no file-scope index.")

    def statement_lines(self, cur: ci.Cursor, depth: int) -> list[str]:
        pad = INDENT * depth
        if cur.kind == CursorKind.UNEXPOSED_EXPR and len(list(cur.get_children())) == 1 and not self.is_call(cur):
            return self.statement_lines(list(cur.get_children())[0], depth)
        kind = cur.kind
        if kind == CursorKind.COMPOUND_STMT:
            return roled([f"{pad}do {{"], "frame") + self.block_body(cur, depth + 1) + roled([f"{pad}}}"], "frame")
        if kind == CursorKind.DECL_STMT:
            return [pad + line for line in self.declarations(cur)]
        if kind == CursorKind.RETURN_STMT:
            kids = list(cur.get_children())
            if self.scratch_modes and self.scratch_modes[-1] == "flag":
                return [f"{pad}return true" + self.trailing(cur)]
            if not kids:
                return [f"{pad}return" + self.trailing(cur)]
            if self.fn.returns is None:
                # The table makes the function void, so the return drops Raven's value and keeps any call in it.
                value = self.unwrap(kids[0])
                kept = [] if value.kind in (CursorKind.DECL_REF_EXPR, CursorKind.INTEGER_LITERAL) else self.statement_lines(kids[0], depth)
                return kept + [f"{pad}return" + self.trailing(cur)]
            if self.is_null(kids[0]) and self.fn.returns and self.fn.returns.endswith("?"):
                return [f"{pad}return nil" + self.trailing(cur)]
            if self.is_null(kids[0]) and self.fn.returns and not self.fn.returns.endswith("?") and self.fn.returns not in ("Int32", "Float", "Double", "Bool"):
                if self.after_com_error:
                    return [f"{pad}// Raven writes `return 0` after this call, which `Com_Error` never reaches."]
                raise Hole(f"Raven returns NULL, and the function returns a `{self.fn.returns}`.")
            post = self.unwrap(kids[0])
            if post.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(post)[0] in ("++", "--") and not self.unary_parts(post)[1]:
                # Raven returns the value and then steps it, and `defer` steps it after the return reads it.
                stepped = self.unary_parts(post)[2]
                return [f"{pad}defer {{ {self.expr(stepped)} {self.unary_parts(post)[0][0]}= 1 }}",
                        f"{pad}return {self.converted(stepped, self.fn.returns)}" + self.trailing(cur)]
            if self.fn.returns == "String" and self.is_raw(kids[0]):
                # Raven returns the raw allocation he filled, and the result is the text in it, read through the view decode of JKAShared.
                return [f"{pad}return cString(at: {self.expr(kids[0])})" + self.trailing(cur)]
            value = self.converted(kids[0], self.fn.returns)
            return [f"{pad}return {value}" + self.trailing(cur)]
        if kind == CursorKind.IF_STMT:
            return self.if_statement(cur, depth)
        if kind == CursorKind.WHILE_STMT:
            cond, body = list(cur.get_children())
            if self.holds_store(cond):
                return self.store_while(cond, body, depth)
            return [f"{pad}while {self.condition(cond)} {{"] + self.loop_body(body, None, depth + 1) + roled([f"{pad}}}"], "frame")
        if kind == CursorKind.DO_STMT:
            body, cond = list(cur.get_children())
            lines = self.loop_body(body, None, depth + 1)
            return roled([f"{pad}repeat {{"], "frame") + lines + [f"{pad}}} while {self.blocked_condition(cond)}"]
        if kind == CursorKind.FOR_STMT:
            return self.for_statement(cur, depth)
        if kind == CursorKind.SWITCH_STMT:
            return self.switch_statement(cur, depth)
        if kind == CursorKind.BREAK_STMT:
            return [f"{pad}break" + self.trailing(cur)]
        if kind == CursorKind.CONTINUE_STMT:
            # The rewritten `for` puts its step at the block end, so a continue runs the step first, as Raven's loop does.
            step = self.loop_steps[-1] if self.loop_steps else None
            before = self.statement(step, depth) if step is not None else []
            return before + [f"{pad}continue" + self.trailing(cur)]
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
                walked = self.unwrap(operand)
                if walked.kind == CursorKind.DECL_REF_EXPR and walked.spelling in self.param_walks and not self.walk_live(walked.spelling, cur):
                    # The first step of a walked parameter starts the walk at the slot after the record the caller handed in.
                    param = self.params_by_name[walked.spelling]
                    record = self.names[walked.spelling] + ("!" if param.swift.endswith("?") else "")
                    return [f"{pad}{self.table_cursors[walked.spelling][1]} = {record}.s.number {op[0]} 1" + self.trailing(cur)]
                if self.unwrap(operand).kind == CursorKind.DECL_REF_EXPR and self.unwrap(operand).spelling in self.table_cursors:
                    self.local_walk(self.unwrap(operand))
                    return [f"{pad}{self.table_cursors[self.unwrap(operand).spelling][1]} {op[0]}= 1" + self.trailing(cur)]
                if self.unwrap(operand).kind == CursorKind.DECL_REF_EXPR and self.unwrap(operand).spelling in self.cursor_locals:
                    if op == "--":
                        raise Hole(f"Raven steps the cursor `{self.unwrap(operand).spelling}` back, and the TextCursor has no backward step.")
                    return [f"{pad}{self.expr(operand)}.advance()" + self.trailing(cur)]
                if self.narrow_element(operand) is not None:
                    # The narrow element wraps as C's truncation does.
                    return [f"{pad}{self.narrow_element(operand)} &{op[0]}= 1" + self.trailing(cur)]
                if self.unwrap(operand).kind == CursorKind.DECL_REF_EXPR and self.unwrap(operand).spelling in self.narrow_locals:
                    # The narrow local wraps as C's truncation does.
                    return [f"{pad}{swift_name(self.unwrap(operand).spelling)} &{op[0]}= 1" + self.trailing(cur)]
                return [f"{pad}{self.expr(operand)} {op[0]}= 1" + self.trailing(cur)]
        if kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
            op = self.binary_op(cur)
            if self.fn.name in WRAPPING_ARITHMETIC and op in ("+=", "-=", "*="):
                # The generator's arithmetic wraps at 32 bits, as C's does.
                op = "&" + op
            if op == ",":
                # C's comma operator runs the left side, then the right, which is two Swift statements, `i++, holdChar += len + 1`.
                left, right = list(cur.get_children())
                return self.statement(left, depth) + self.statement(right, depth)
            if op in ASSIGN_OPS:
                left, right = list(cur.get_children())
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.charbuf_allocs \
                        and self.is_null(right):
                    # No read reaches Raven's NULL before the allocation, so the store drops under one comment.
                    raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
                    return roled([f"{pad}// Raven wrote `{raven}` here, and no read reaches it before the allocation."], "comment")
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.charbuf_allocs:
                    # The local is already a CharBuf of the size, so the store keeps only the call, for the pool's count.
                    return [f"{pad}_ = {self.expr(self.uncast(right))}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.store_lets:
                    # The local lives in one loop-body scratch closure, so Raven's store is its declaration.
                    return [f"{pad}let {swift_name(self.unwrap(left).spelling)} = {self.expr(right)}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.game_entities | self.optional_entities:
                    return [f"{pad}{self.expr(left)} = {self.entity_or_nil(right)}" + self.trailing(cur)]
                if self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.chosen_locals:
                    # Raven's choice of the variable is the call of the nested function that holds his statements after the choice.
                    variable = self.chosen_variable(right)
                    if op != "=" or variable is None:
                        raise Hole(f"Raven writes `{self.unwrap(left).spelling}` with something that is not the address of a file-scope variable.")
                    word = "return " if self.fn.returns else ""
                    return [f"{pad}{word}{self.chosen_helper(self.unwrap(left).spelling)}(&{self.expr(variable)})" + self.trailing(cur)]
                chosen = self.chosen_deref(left)
                if chosen is not None:
                    if op != "=":
                        raise Hole(f"Raven writes through `{chosen}` with `{op}`, and the inout parameter has no such step.")
                    return [f"{pad}{chosen} = {self.expr(right)}" + self.trailing(cur)]
                walked = self.cursor_post_step(right) if op == "=" else None
                if walked is not None and self.swift_type_of(left) == "Int32" and not (
                        self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.narrow_locals):
                    # Raven's `c = *p++` reads the byte under the cursor and then steps the cursor, two Swift statements in his order.
                    return [f"{pad}{self.expr(left)} = {walked}.byte" + self.trailing(cur), f"{pad}{walked}.advance()"]
                if self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.cursor_locals:
                    if op == "=":
                        source = "JKAShared.TextCursor()" if self.is_null(right) else self.text_cursor(right)
                        return [f"{pad}{self.expr(left)} = {source}" + self.trailing(cur)]
                    if op == "+=":
                        return [f"{pad}{self.expr(left)}.advance(by: {self.converted(right, 'Int32')})" + self.trailing(cur)]
                    raise Hole(f"Raven steps the cursor `{self.unwrap(left).spelling}` with `{op}`, and the TextCursor has no such step.")
                if self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.offset_cursors:
                    if op == "=" and self.is_null(right):
                        raise Hole(f"Raven stores NULL into `{self.unwrap(left).spelling}`, and a byte offset has no NULL.")
                    value = self.cursor_offset(right) if op == "=" else self.converted(right, "Int32")
                    return [f"{pad}{self.expr(left)} {op} {value}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.UNARY_OPERATOR \
                        and self.operator_or_none_unary(self.unwrap(left)) == "*":
                    # A byte store through a cursor takes the value as an Int32, which the CharBuf setter narrows.
                    slot = self.cursor_deref(self.unary_parts(self.unwrap(left))[2])
                    if slot is not None:
                        return [f"{pad}{slot} = {self.converted(right, 'Int32')}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.text_locals \
                        and (self.is_null(right) or self.field_slot(right) is not None or self.optional_text_call(right)):
                    optional = self.unwrap(left).spelling in self.optional_texts
                    return [f"{pad}{self.expr(left)} = {self.text_value(right, optional)}" + self.trailing(cur)]
                if self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.local_holes:
                    raise Hole(self.hole_local_reason(self.unwrap(left).spelling, True))
                if op == "=" and self.unwrap(left).kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and self.is_raw(list(self.unwrap(left).get_children())[0]):
                    # Raven's `tempReadBuffer[len] = 0` writes one byte of a raw allocation, which the `byte` slot of RawField.swift stores.
                    base, index = list(self.unwrap(left).get_children())
                    return [f"{pad}{self.expr(base)}[byte: {self.converted(index, 'Int32')}] = {self.converted(right, 'Int32')}" + self.trailing(cur)]
                # 4. A byte store into a buffer takes the value as an Int32, which the CharBuf setter narrows.
                if op == "=" and self.unwrap(left).kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and self.is_charbuf(list(self.unwrap(left).get_children())[0]):
                    return [f"{pad}{self.expr(left)} = {self.converted(right, 'Int32')}" + self.trailing(cur)]
                # 5. A trap that fills a buffer returns the count and the text, and the buffer takes the text.
                tuple_call = self.tuple_call(right)
                if op == "=" and tuple_call is not None:
                    call, buffer = tuple_call
                    # A list trap returns the whole buffer as a CharBuf, and the buffer takes it as it is.
                    # Any other trap returns the text to the first NUL, and the copy keeps the buffer's declared size, as the engine's write does.
                    whole = self.registry.returns.get(self.callee_name(self.strip(right)), "").startswith("(Int32, JKAShared.CharBuf)")
                    fill = f"{buffer} = filled.1" if whole else f"strcpy(&{buffer}, filled.1)"
                    return [f"{pad}let filled = {call}", f"{pad}{self.expr(left)} = filled.0", f"{pad}{fill}"]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.table_cursors:
                    self.local_walk(self.unwrap(left))
                    table, index = self.table_cursors[self.unwrap(left).spelling]
                    source = self.unwrap(right)
                    # The source is the table, a slot past its start, or another walk pointer stepped by a count, `p = pushed_p - 1`.
                    position = self.table_position(source)
                    offset = position[1] if position is not None else "0"
                    if position is None and source.kind == CursorKind.BINARY_OPERATOR and self.binary_op(source) == "+":
                        offset = self.converted(list(source.get_children())[1], "Int32")
                    return [f"{pad}{index} = {offset}" + self.trailing(cur)]
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.aliases:
                    # The store that names the alias has no effect of its own, and the comment beside it stays.
                    rest = self.trailing_comment(cur)
                    return roled([f"{pad}{rest}"], "comment") if rest else []
                raw = self.raw_store(left)
                if raw is not None:
                    # Raven's `*(int *)(b+f->ofs) = v` is the labeled subscript of the raw pointer, one per C type, by RawField.swift.
                    label = raw[1]
                    if label == "pointer" and not self.is_raw(right):
                        # Raven's `char *` field takes the pooled text the game hands back, which the `string` slot holds.
                        label = "string"
                    swift = {"int": "Int32", "float": "Float"}.get(label)
                    value = self.converted(right, swift) if swift else self.expr(right)
                    return [f"{pad}{self.raw_slot(raw, label)} {op} {value}" + self.trailing(cur)]
                if self.unwrap(left).kind == CursorKind.MEMBER_REF_EXPR:
                    fields, root, base_cur = self.game_chain(self.unwrap(left))
                    if root is not None and not self.sk.table.own_field(root, fields):
                        write = self.reads.get((root, tuple(fields), True))
                        if write is None or op != "=":
                            raise Hole(f"Raven writes the game's `{'.'.join(fields)}` here, and the channel has no set for it.")
                        head = (self.expr(base_cur) + ("!" if self.optional_base(base_cur) else "") + ", ") if root == "entity" else ""
                        return [f"{pad}{write.name}({head}{self.converted(right, write.swift)})" + self.trailing(cur)]
                field = self.strip(left).type.get_canonical()
                if op == "=" and self.is_null(right) and field.kind == TypeKind.POINTER and field.get_pointee().kind == TypeKind.FUNCTIONPROTO:
                    # Raven clears a callback field with 0 or NULL, and the optional closure field takes nil.
                    return [f"{pad}{self.expr(left)} = nil" + self.trailing(cur)]
                if op == "=" and self.pooled_field(left) and self.text_kind(right) == "CharBuf":
                    # A `char *` field takes a String, and the field's setter interns it, so a buffer crosses as its text.
                    return [f"{pad}{self.expr(left)} = String({self.expr(right)})" + self.trailing(cur)]
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
                        source = self.one_record_slots(right)
                    if source is None:
                        raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                        raise Hole(f"Raven stores `{raven}`, and Swift holds the target as the Slots over the records where the source is one record.")
                    return [f"{pad}{self.expr(left)} = {source}" + self.trailing(cur)]
                if op == "=" and self.slots_expression(right) is not None and self.slots_member(left) is not None:
                    # Raven stores the table back into the field he indexes, and the field's Slots accessor takes it.
                    return [f"{pad}{self.slots_member(left)} = {self.slots_expression(right)}" + self.trailing(cur)]
                if op == "=" and self.view_operand(left) and not self.optional_base(left) and self.optional_base(right):
                    # The target takes a value, and the force unwrap traps where Raven's later read would dereference NULL.
                    source = self.expr(right)
                    source = f"({source})!" if self.unwrap(right).kind == CursorKind.CONDITIONAL_OPERATOR else f"{source}!"
                    return [f"{pad}{self.expr(left)} = {source}" + self.trailing(cur)]
                if op == "=" and self.slots_source(right):
                    raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                    raise Hole(f"Raven stores `{raven}`, and Swift holds the source as a Slots where the target takes one record. A Slots ruling is due.")
                if self.narrow_field_element(left) and self.strip(right).kind != CursorKind.INTEGER_LITERAL and self.types.narrow(self.strip(right).type) is None:
                    # A narrow field of a view, `byte shaderRGBA[4]`, takes the int value truncated, as C's store does.
                    narrow = self.types.narrow(self.unwrap(left).type)
                    slot = self.expr(left)
                    value = self.converted(right, "Int32") if op == "=" else f"Int32({slot}) {op[:-1]} {self.converted(right, 'Int32')}"
                    return [f"{pad}{slot} = {narrow}(truncatingIfNeeded: {value})" + self.trailing(cur)]
                if self.narrow_element(left) is not None:
                    # C computes in int and truncates into the narrow element at the store.
                    slot = self.narrow_element(left)
                    narrow = self.narrow_arrays[self.strip(list(self.unwrap(left).get_children())[0]).spelling]
                    if op == "=":
                        return [f"{pad}{slot} = {self.converted(right, narrow)}" + self.trailing(cur)]
                    return [f"{pad}{slot} = {narrow}(truncatingIfNeeded: Int32({slot}) {op[:-1]} {self.converted(right, 'Int32')})" + self.trailing(cur)]
                if self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).spelling in self.narrow_locals:
                    # C computes in int and truncates into the narrow local at the store.
                    name = swift_name(self.unwrap(left).spelling)
                    narrow = self.narrow_locals[self.unwrap(left).spelling]
                    if op == "=":
                        return [f"{pad}{name} = {self.converted(right, narrow)}" + self.trailing(cur)]
                    return [f"{pad}{name} = {narrow}(truncatingIfNeeded: Int32({name}) {op[:-1]} {self.converted(right, 'Int32')})" + self.trailing(cur)]
                target = self.expr(left)
                inner = self.strip(right)
                if op == "=" and inner.kind == CursorKind.BINARY_OPERATOR and not self.macro_span(inner) and self.binary_op(inner) == "=":
                    # Raven's `a = b = 0` sets b, then a from b, so the draft writes the two stores in that order.
                    lines = self.statement_lines(inner, depth)
                    middle = list(inner.get_children())[0]
                    # The value of `b = 0` is b after its store, and C converts it again into a.
                    outer = self.swift_type_of(left)
                    value = self.converted(middle, outer) if outer in ("Float", "Int32") else self.expr(middle)
                    lines.append(f"{pad}{target} = {value}" + self.trailing(cur))
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
                if op != "=" and lhs_kind in ("Int32", "Float") and self.strip(right).type.get_canonical().kind == TypeKind.DOUBLE \
                        and (self.has_double_literal(right) or self.holds_double(right)):
                    # C computes the double expression and converts once at the store, by "A double literal".
                    return [f"{pad}{target} = {lhs_kind}(Double({target}) {op[:-1]} {self.wrapped(right, 'Double')})" + self.trailing(cur)]
                held_float = self.arith_kind(right) == "Float" or (self.arith_kind(right) == "Double" and not self.holds_double(right)
                                                                    and not self.has_double_literal(right))
                if op != "=" and lhs_kind == "Int32" and held_float:
                    # C computes in float and truncates at the store.
                    # A C library call Swift holds in Float, `floor(x)` for a float `x`, is a float here too.
                    return [f"{pad}{target} = Int32(Float({target}) {op[:-1]} {self.expr(right)})" + self.trailing(cur)]
                if unsigned is not None and not self.is_literal(right):
                    return [f"{pad}{target} {op} {self.wrapped(right, unsigned)}" + self.trailing(cur)]
                if op == "=" and lhs_kind == "Int32" and self.unsigned_of(right) == "UInt32":
                    # C computes in unsigned and stores the bit pattern, `(size + 3) & 0xfffffffc`.
                    return [f"{pad}{target} = Int32(bitPattern: {self.wrapped(right, 'UInt32')})" + self.trailing(cur)]
                if op == "=" and self.text_out_target(left) and self.optional_pooled(right):
                    # A `char *` field is a String?, and the String output takes its text, so the read takes the bind.
                    return [f"{pad}{target} = {self.expr(right)}!" + self.trailing(cur)]
                value = self.converted(right, lhs_kind) if op == "=" else self.expr(right)
                return [f"{pad}{target} {op} {value}" + self.trailing(cur)]
        if self.is_call(cur) and self.callee_name(cur) in RECORD_CALLS:
            return self.record_bytes(cur, depth)
        if self.is_call(cur) and self.callee_name(cur) in DROPPED:
            # `assert` is `((void)0)` under Raven's NDEBUG build, so the body drops it, by "assert".
            rest = self.trailing_comment(cur)
            return roled([f"{pad}{rest}"], "comment") if rest else []
        if self.is_call(cur) and self.filled_call(cur) is not None:
            call, buffer, whole = self.filled_call(cur)
            if whole:
                # A list trap returns the whole buffer, so the buffer takes it as it is.
                return [f"{pad}{buffer} = {call}" + self.trailing(cur)]
            # The trap returns the text the engine wrote, and the copy keeps the buffer's own size, as the engine's write does.
            return [f"{pad}strcpy(&{buffer}, {call})" + self.trailing(cur)]
        if self.is_call(cur) and self.aliased_inouts(cur):
            aliased = self.aliased_inouts(cur)
            with self.aliased_reads(cur, aliased):
                call = self.expr(cur)
            inner_pad = INDENT * (depth + 1)
            note, before = self.aliased_copies(aliased, pad, inner_pad)
            after = [f"{inner_pad}{text} = {local}" for _, text, local, back in aliased if back]
            return roled([note], "lifted") + roled([f"{pad}do {{"], "frame") + roled(before, "lifted") + [f"{inner_pad}{call}" + self.trailing(cur)] \
                + roled(after, "lifted") + roled([f"{pad}}}"], "frame")
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
                return roled([f"{pad}do {{"], "frame") + roled(before, "lifted") + [f"{inner_pad}{call}" + self.trailing(cur)] \
                    + roled(after, "lifted") + roled([f"{pad}}}"], "frame")
            return [f"{pad}{self.expr(cur)}" + self.trailing(cur)]
        if kind.is_expression():
            raise Hole("An expression statement with no effect the draft knows.")
        raise Hole(f"No rule for a {kind.name} statement.")

    def branch(self, cur: ci.Cursor, depth: int) -> list[str]:
        """The body of a control statement as block lines, whether Raven wrote braces or a lone statement."""
        if cur.kind == CursorKind.COMPOUND_STMT:
            return self.block_body(cur, depth)
        return self.statement(cur, depth)

    @contextmanager
    def aliased_reads(self, call: ci.Cursor, aliased: list[tuple[int, str, str, bool]]):
        """The draft of one call with each earlier aliased argument read from the copy that stands in for it.
        The swap keys on the argument's extent and position, so no other call inside this one or beside it reads the copy."""
        args = self.call_children(call)[1:]
        self.aliased_positions = {self.argument_key(args[i], i): local for i, _, local, _ in aliased}
        try:
            yield
        finally:
            self.aliased_positions = {}

    def aliased_copies(self, aliased: list[tuple[int, str, str, bool]], note_pad: str, copy_pad: str) -> tuple[str, list[str]]:
        """The note the repeat earns and the declaration of each copy, each at its own pad."""
        note = f"{note_pad}// Raven passes `{aliased[0][1]}` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy."
        if any(back for _, _, _, back in aliased):
            note += " The last one writes back after the call, because a view's setter keeps the in-copy otherwise."
        return note, [f"{copy_pad}var {local} = {text}" for _, text, local, _ in aliased]

    def aliased_in_test(self, cur: ci.Cursor) -> tuple[ci.Cursor, list[tuple[int, str, str, bool]]] | None:
        """The call under a test that names one variable twice inout, with its earlier aliased arguments, or None when the test holds no such call."""
        for node in cur.walk_preorder():
            if self.is_call(node):
                aliased = self.aliased_inouts(node)
                if any(back for _, _, _, back in aliased):
                    raise Hole("Raven passes one member path twice inout inside a test, and the write-back has no line after the test.")
                if aliased:
                    return node, aliased
        return None

    def filled_test(self, cur: ci.Cursor) -> tuple[str, str, bool, bool] | None:
        """Raven's `if (!trap_GetEntityToken(com_token, sizeof(com_token)))`, a test that is one call to a trap whose Swift form returns
        `(Bool, String)`: the call, the buffer, True for a list trap, and True when Raven negates the call. None for any other test."""
        inner = self.unwrap(cur)
        negated = False
        if inner.kind == CursorKind.UNARY_OPERATOR and self.operator_or_none_unary(inner) == "!":
            negated = True
            inner = self.unwrap(self.unary_parts(inner)[2])
        name = self.callee_name(self.strip(inner)) if self.is_call(self.strip(inner)) else None
        returns = self.registry.returns.get(name, "") if name else ""
        if not (returns.startswith("(Bool, String)") or returns.startswith("(Bool, JKAShared.CharBuf)")):
            return None
        filled = self.tuple_call(inner)
        if filled is None:
            return None
        return filled[0], filled[1], returns.startswith("(Bool, JKAShared.CharBuf)"), negated

    def if_statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        pad = INDENT * depth
        kids = list(cur.get_children())
        cond, then = kids[0], kids[1]
        found = self.aliased_in_test(cond)
        head: list[str] = []
        if found is not None:
            # The test has no line of its own for the copies, so they stand before the `if` and the test reads them.
            call, aliased = found
            note, copies = self.aliased_copies(aliased, pad, pad)
            head = [note] + copies
            with self.aliased_reads(call, aliased):
                test = self.condition(cond)
        elif self.filled_test(cond) is not None:
            # A trap that fills a buffer and returns its Bool stands before the `if`, the buffer takes the text, and the test reads the Bool.
            call, buffer, whole, negated = self.filled_test(cond)
            # A second test of this shape in one body takes a numbered name, so no two lets collide in one scope.
            self.scratch_names["filledTest"] = self.scratch_names.get("filledTest", 0) + 1
            filled = "filledTest" if self.scratch_names["filledTest"] == 1 else f"filledTest{self.scratch_names['filledTest']}"
            fill = f"{buffer} = {filled}.1" if whole else f"strcpy(&{buffer}, {filled}.1)"
            head = roled([f"{pad}let {filled} = {call}", f"{pad}{fill}"], "lifted")
            test = f"!{filled}.0" if negated else f"{filled}.0"
        else:
            # The bind changes the hoists, so the draft asks for it once.
            bind = self.client_bind(cond, then)
            test = bind if bind is not None else self.condition(cond)
        if test == "false":
            # The guard folded away, because the Swift signature holds the value, so its arm has no path and only the else arm stays.
            return self.branch(kids[2], depth) if len(kids) == 3 else []
        if test == "true":
            # The test folded away, so the else arm has no path and only the then arm stays.
            return self.branch(then, depth)
        out = head + [f"{pad}if {test} {{"] + self.branch(then, depth + 1)
        if len(kids) == 3:
            other = kids[2]
            # Raven's comment between the then arm's brace and his `else` has no seat there in Swift, so it opens the else arm.
            between = [line for line in self.gap(then.extent.end.line, other.extent.start.line, depth + 1) if not blank(line)]
            if other.kind == CursorKind.IF_STMT:
                # Raven's else-if is a statement of its own, so the compile gate maps an error in it to it and not to the whole chain.
                outer = self.pending
                self.pending = []
                self.lowered_as(other, None, depth)
                try:
                    nested = self.compile_hole(other, depth)
                    nested = marked(self.if_statement(other, depth) if nested is None else nested, self.statement_number(other))
                    before = self.pending
                finally:
                    self.pending = outer
                if any(not line.lstrip().startswith("//") for line in before):
                    # A store lifted out of the else-if test runs only when the first test fails, so it opens the else block.
                    out += roled([f"{pad}}} else {{"], "frame")
                    out += between + [INDENT * (depth + 1) + line for line in roled(before, "lifted")]
                    out += [line if blank(line) else INDENT + line for line in nested]
                    out += roled([f"{pad}}}"], "frame")
                    return out
                self.pending += before
                if nested and nested[0].strip().startswith("if "):
                    out.append(f"{pad}}} else {nested[0].strip()}")
                    out += between + nested[1:]
                    return out
                # The nested if folded to one arm, so the arm is the else block.
                out += roled([f"{pad}}} else {{"], "frame")
                out += between + [line if blank(line) else INDENT + line for line in nested]
                out += roled([f"{pad}}}"], "frame")
                return out
            out += roled([f"{pad}}} else {{"], "frame")
            out += between + self.branch(other, depth + 1)
        out += roled([f"{pad}}}"], "frame")
        return out

    def commented(self, cur: ci.Cursor) -> list[str]:
        """Raven's text of a statement as comment lines, for an arm the draft leaves out."""
        text = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
        return roled([f"// {line.rstrip()}".rstrip() for line in text.replace("\t", "    ").splitlines()], "text")

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
        test = self.blocked_condition(cond) if cond is not None else "true"
        out.append(f"{pad}while {test} {{")
        inner = self.loop_body(body, step, depth + 1)
        if step is not None and any(re.match(r"continue \w", line.strip()) for line in inner):
            # A goto that became a labeled continue leaves the loop from inside a nested one, and the step does not run for it.
            note = "// Port-note: Raven's loop has a labeled continue, and the step below does not run for it. The transcriptor moves the step."
            out += [INDENT * (depth + 1) + line for line in self.noted_hole(note)]
        out += inner
        if step is not None:
            out += self.statement(step, depth + 1)
        out += roled([f"{pad}}}"], "frame")
        return out

    def blocked_condition(self, cond: ci.Cursor) -> str:
        """A loop test that runs on every pass, where a store inside it has no line of its own before the loop."""
        self.lift_blocked += 1
        try:
            return self.condition(cond)
        finally:
            self.lift_blocked -= 1

    def holds_store(self, cur: ci.Cursor) -> bool:
        """True when Raven's expression holds an assignment, `(spot = G_Find(...)) != NULL`."""
        for node in cur.walk_preorder():
            if node.kind == CursorKind.COMPOUND_ASSIGNMENT_OPERATOR:
                return True
            if node.kind == CursorKind.BINARY_OPERATOR and not self.collapsed(node) and self.operator_or_none(node) == "=":
                return True
        return False

    def store_while(self, cond: ci.Cursor, body: ci.Cursor, depth: int) -> list[str]:
        """Raven's `while` whose test stores a value. An optional value under his NULL test is `while let next = ...`,
        with the store as the first line of the body. Any other test is `while true`, the lifted store, and the test as a break."""
        pad = INDENT * depth
        inner_pad = INDENT * (depth + 1)
        test = self.strip(cond)
        store = None
        if test.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(test) == "!=":
            left, right = list(test.get_children())
            if self.is_null(right):
                store = self.strip(left)
        elif test.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(test) == "=":
            store = test
        if store is not None and store.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(store) == "=":
            target, value = list(store.get_children())
            if self.unwrap(target).kind == CursorKind.DECL_REF_EXPR and self.optional_base(value):
                outer = self.pending
                self.pending = []
                try:
                    source = self.expr(value)
                    before = self.pending
                finally:
                    self.pending = outer
                if all(line.lstrip().startswith("//") for line in before):
                    self.pending += before
                    return [f"{pad}while let next = {source} {{", f"{inner_pad}{self.expr(target)} = next"] \
                        + self.loop_body(body, None, depth + 1) + roled([f"{pad}}}"], "frame")
        outer = self.pending
        self.pending = []
        try:
            check = self.condition(cond)
            lifted = self.pending
        finally:
            self.pending = outer
        return roled([f"{pad}while true {{"], "frame") + [inner_pad + line for line in roled(lifted, "lifted")] + [f"{inner_pad}if !({check}) {{ break }}"] \
            + self.loop_body(body, None, depth + 1) + roled([f"{pad}}}"], "frame")

    def loop_body(self, body: ci.Cursor, step: ci.Cursor | None, depth: int) -> list[str]:
        """The body of a loop, with its step clause on the stack so a `continue` inside it runs the step first."""
        self.loop_steps.append(step)
        try:
            return self.branch(body, depth)
        finally:
            self.loop_steps.pop()

    def switch_statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        """Raven's cases as Swift cases. A case with no break at its end falls through to the next case."""
        pad = INDENT * depth
        subject, body = list(cur.get_children())
        if body.kind != CursorKind.COMPOUND_STMT:
            raise Hole("The switch body is not a block.")
        groups: list[tuple[list[str], list[ci.Cursor], int, list[str]]] = []
        for child in body.get_children():
            labels: list[str] = []
            comments: list[str] = []
            stmt = child
            label_line = child.extent.start.line
            while stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT):
                inner = list(stmt.get_children())
                label_line = stmt.extent.start.line
                if stmt.kind == CursorKind.CASE_STMT:
                    labels.append(self.expr(inner[0]))
                    comments.append(self.label_comment(inner[0].extent.end.offset))
                    stmt = inner[-1]
                else:
                    labels.append("default")
                    comments.append(self.label_comment(stmt.extent.start.offset + len("default")))
                    stmt = inner[0]
            if labels:
                groups.append((labels, [], label_line, comments))
            if not groups:
                raise Hole("A statement before the first case of the switch.")
            if stmt.kind in (CursorKind.CASE_STMT, CursorKind.DEFAULT_STMT) or stmt is child and labels and stmt.kind == CursorKind.NULL_STMT:
                continue
            groups[-1][1].append(stmt)
        out = [f"{pad}switch {self.expr(subject)} {{"]
        if groups:
            # Raven's comment between the switch's brace and his first case, `//case WP_NONE:`, stays above the first case.
            out += [line for line in self.gap(body.extent.start.line, groups[0][2], depth) if not blank(line)]
        # Each group is one arm, so Raven's `default:` before his other cases moves to the end of the switch as a whole arm.
        arms: list[list[str]] = []
        default_at = next((i for i, (labels, _, _, _) in enumerate(groups) if "default" in labels), None)
        for i, (labels, stmts, label_line, comments) in enumerate(groups):
            label = "default" if labels == ["default"] else "case " + ", ".join(l for l in labels if l != "default")
            # Raven's comment after a label stays after it, and an arm that joins labels writes one label per line when any label carries one.
            head = [f"{pad}{label}:" + (f"{TRAILING}{comments[0]}" if comments[0] else "")]
            if "default" in labels and len(labels) > 1:
                label = "default"
                said = [comment for comment in comments if comment]
                head = [f"{pad}default:" + (f"{TRAILING}{said[0]}" if said else "")]
            elif len(labels) > 1 and any(comments):
                head = [f"{pad}case {labels[0]}," + (f"{TRAILING}{comments[0]}" if comments[0] else "")]
                head += [f"{pad}     {joined}{',' if k + 2 < len(labels) else ':'}" + (f"{TRAILING}{comment}" if comment else "")
                         for k, (joined, comment) in enumerate(zip(labels[1:], comments[1:]))]
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
                lines += [line for line in self.gap(label_line, stmts[0].extent.start.line, depth + 1) if not blank(line)]
            while lines and blank(lines[0]):
                lines.pop(0)
            if i + 1 < len(groups):
                # Raven's comment after the case's last statement, or between two labels, stays with the case.
                last = stmts[-1].extent.end.line if stmts else label_line
                lines += [line for line in self.gap(last, groups[i + 1][2], depth + 1) if not blank(line)]
            if not ends_in_break and not ends_in_exit and i + 1 < len(groups):
                lines += roled([f"{INDENT * (depth + 1)}fallthrough"], "frame")
            if not any(not blank(line) and not line.strip().startswith("//") for line in lines):
                # A case with comments alone still needs its break.
                lines += roled([f"{INDENT * (depth + 1)}break"], "frame")
            arms.append(head + lines)
        if default_at is not None and default_at + 1 < len(arms):
            # Swift takes no case after the default block. A fall-through beside the default has no order that keeps it, so it stays a hole.
            neighbors = [arms[default_at]] + ([arms[default_at - 1]] if default_at else [])
            if any(ROLE_MARK.sub("", line).strip() == "fallthrough" for arm in neighbors for line in arm):
                raise Hole("Raven's `default:` comes before his other cases, and a case falls through beside it.")
            arms.append(arms.pop(default_at))
        for i, arm in enumerate(arms):
            out += arm
            if i + 1 < len(arms):
                out.append("")
        if default_at is None:
            out += [""] + roled([f"{pad}default:", f"{INDENT * (depth + 1)}break"], "frame")
        out += roled([f"{pad}}}"], "frame")
        return out

    def label_comment(self, offset: int) -> str:
        """Raven's comment after the colon of a `case` or `default` label whose text ends at `offset`, or the empty text when the line holds none."""
        end = self.bytes.find(b"\n", offset)
        rest = self.bytes[offset:end if end >= 0 else len(self.bytes)].decode("utf-8", "replace")
        colon = rest.find(":")
        rest = rest[colon + 1:].strip() if colon >= 0 else ""
        return rest if rest.startswith("//") else ""

    def client_bind(self, cond: ci.Cursor, then: ci.Cursor) -> str | None:
        """Raven's by-number `ent->client` test as the bind of the record read his then arm shares, or None for any other test.

        Outside a pm function, `ent->client->saber[n]` reads the game by number, and the callback hands back nil where the game's client is NULL.
        So `if (ent->inuse && ent->client)` reads `if bgEntityInuse(of: n), let saber = bgClientSaber(of: n, at: i)`."""
        inner = self.unwrap(cond)
        left = None
        if inner.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(inner) == "&&":
            left, test = list(inner.get_children())
        else:
            test = inner
        test = self.unwrap(test)
        if test.kind != CursorKind.MEMBER_REF_EXPR or then.kind != CursorKind.COMPOUND_STMT:
            return None
        fields, root, base = self.game_chain(test)
        if fields != ["client"] or root != "entities":
            return None
        first = next(iter(then.get_children()), None)
        if first is None:
            return None
        hoists = self.hoists.get(extent_key(first), [])
        for entry in hoists:
            key, local, read = entry
            read_base = self.strip(list(read.get_children())[0])
            read_fields, _, read_root = self.game_chain(read_base)
            if read_fields[:1] != ["client"] or self.entity_index_text(read_root) != self.entity_index_text(base):
                continue
            hoists.remove(entry)
            value = self.expr(read)
            self.hoisted[key] = local
            self.bound_reads.add(key)
            bind = f"let {local} = {value}"
            return bind if left is None else f"{self.condition(left)}, {bind}"
        return None

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

    def has_double_literal(self, cur: ci.Cursor) -> bool:
        """True when Raven's expression holds a floating literal with no f suffix, which C computes in double.
        A macro constant that expands to one, `M_PI` or `ARMOR_PROTECTION`, is a double literal too."""
        for c in cur.walk_preorder():
            if c.kind == CursorKind.FLOATING_LITERAL:
                text = self.bytes[c.extent.start.offset:c.extent.end.offset].decode("utf-8", "replace").strip()
                if NUMBER.fullmatch(text) and not text.endswith(("f", "F")):
                    return True
                if IDENTIFIER.fullmatch(text) and c.type.get_canonical().kind == TypeKind.DOUBLE:
                    return True
        return False

    def overlapping_slots(self, cur: ci.Cursor) -> list[tuple[str, str]]:
        """The `&a[i]` arguments of one call that share an array, each as its Swift text and the copy that stands in for it."""
        kids = list(self.strip(cur).get_children()) if cur.kind == CursorKind.UNEXPOSED_EXPR else list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        if callee is None or callee.kind != CursorKind.DECL_REF_EXPR:
            return []
        name = callee.spelling
        # Two inout slots of one array conflict. A by-value slot beside an inout one does not, because Swift copies it before the call.
        positions = address_arguments(name) if name in MACROS else self.inout_positions(name)
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
