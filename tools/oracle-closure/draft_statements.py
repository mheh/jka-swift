"""draft_statements.py: the statement half of the drafter, one Swift statement for each of Raven's.
It walks a compound block, keeps his blank lines and his comments in their places, and gives the `if`, `for`, and `switch` forms their Swift shape.
A statement it has no rule for raises a Hole, and the draft keeps Raven's text under a Port-note in its place."""

from __future__ import annotations

import re
from contextlib import contextmanager

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

import closure as C
from table import ASSIGN_OPS, TARGET, swift_name
from overlay import DROPPED, MACROS, RECORD_CALLS, address_arguments

from draft_classification import INDENT, Hole
from draft_expressions import NUMBER


class Statements:
    """The statement half of the drafter."""

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
            out += self.shared_read_lines(child, depth)
            if record is not None:
                out += self.scratch(child, record, children[i + 1:], last_line, depth)
                return out
            chosen = self.chosen_choice(child, children[i + 1:])
            if chosen is not None:
                out += self.choice(chosen, child, children[i + 1:], last_line, depth)
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
        body = self.statements(rest, chain.extent.end.line, last_line, depth + 1)
        while body and not body[0].strip():
            body.pop(0)
        while body and not body[-1].strip():
            body.pop()
        out += body
        out.append(f"{pad}}}")
        out += self.statement(chain, depth)
        return out

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

    def record_bytes(self, cur: ci.Cursor, depth: int) -> list[str]:
        """Raven's `memset` and `memcpy` over a whole record, as the view's `clear()` and `copy(from:)`. A memset of a record local
        drops, because the scratch slot is zero at entry. A memset of zero over one `char name[N]` field is the buffer accessor's `zero()`."""
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
                if self.unwrap(operand).kind == CursorKind.DECL_REF_EXPR and self.unwrap(operand).spelling in self.cursor_locals:
                    if op == "--":
                        raise Hole(f"Raven steps the cursor `{self.unwrap(operand).spelling}` back, and the TextCursor has no backward step.")
                    return [f"{pad}{self.expr(operand)}.advance()" + self.trailing(cur)]
                return [f"{pad}{self.expr(operand)} {op[0]}= 1" + self.trailing(cur)]
        if kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
            op = self.binary_op(cur)
            if op == ",":
                # C's comma operator runs the left side, then the right, which is two Swift statements, `i++, holdChar += len + 1`.
                left, right = list(cur.get_children())
                return self.statement(left, depth) + self.statement(right, depth)
            if op in ASSIGN_OPS:
                left, right = list(cur.get_children())
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
                    raise Hole(f"A store into `{self.unwrap(left).spelling}`, a local the draft left as a hole.")
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
                if op != "=" and lhs_kind == "Int32" and self.types.number_kind(self.strip(right).type) == "Float":
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
            with self.aliased_reads(aliased):
                call = self.expr(cur)
            inner_pad = INDENT * (depth + 1)
            note, before = self.aliased_copies(aliased, pad, inner_pad)
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

    @contextmanager
    def aliased_reads(self, aliased: list[tuple[int, str, str]]):
        """The draft of one call with each earlier aliased argument read from the copy that stands in for it."""
        self.slot_copies = {f"{i}:{text}": local for i, text, local in aliased}
        self.aliased_positions = {i: local for i, _, local in aliased}
        try:
            yield
        finally:
            self.slot_copies = {}
            self.aliased_positions = {}

    def aliased_copies(self, aliased: list[tuple[int, str, str]], note_pad: str, copy_pad: str) -> tuple[str, list[str]]:
        """The note the repeat earns and the declaration of each copy, each at its own pad."""
        note = f"{note_pad}// Raven passes `{aliased[0][1]}` more than once, and Swift refuses one variable twice inout, so the earlier ones read a copy."
        return note, [f"{copy_pad}var {local} = {text}" for _, text, local in aliased]

    def aliased_in_test(self, cur: ci.Cursor) -> list[tuple[int, str, str]]:
        """The earlier aliased arguments of the call under a test, empty when the test holds no call that names one variable twice inout."""
        for node in cur.walk_preorder():
            if self.is_call(node):
                aliased = self.aliased_inouts(node)
                if aliased:
                    return aliased
        return []

    def if_statement(self, cur: ci.Cursor, depth: int) -> list[str]:
        pad = INDENT * depth
        kids = list(cur.get_children())
        cond, then = kids[0], kids[1]
        aliased = self.aliased_in_test(cond)
        head: list[str] = []
        if aliased:
            # The test has no line of its own for the copies, so they stand before the `if` and the test reads them.
            note, copies = self.aliased_copies(aliased, pad, pad)
            head = [note] + copies
            with self.aliased_reads(aliased):
                test = self.condition(cond)
        else:
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
        out = head + [f"{pad}if {test} {{"] + self.branch(then, depth + 1)
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
        """True when Raven's expression holds a floating literal with no f suffix, which C computes in double."""
        for c in cur.walk_preorder():
            if c.kind == CursorKind.FLOATING_LITERAL:
                text = self.bytes[c.extent.start.offset:c.extent.end.offset].decode("utf-8", "replace").strip()
                if NUMBER.fullmatch(text) and not text.endswith(("f", "F")):
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
