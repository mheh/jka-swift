"""draft_expressions.py: the expression half of the drafter, one Swift expression for each of Raven's.
It reads a literal, a name, a member, a cast, a `sizeof`, and an operator taken from the tokens between the operands.
It asks spelling.py what Swift type an expression has, and the conversions that cross into that type live here beside the readers that need them."""

from __future__ import annotations

import re
from pathlib import Path

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

from spelling import Facts, UNSIGNED

from rulings import HAND_MACROS, HAND_VARS, WRAPPING_ARITHMETIC
import closure as C
from skeleton import BG, LOGIC, target_of
from table import ASSIGN_OPS, COMMENT, TARGET, swift_name
from overlay import MACROS

from draft_classification import Hole

# The Swift targets a bg body never sees, by the bg/game boundary.
GAME_SIDE = {LOGIC, "JKAMP_Game"}

COMPARISONS = {"==", "!=", "<", ">", "<=", ">="}
LOGICAL = {"&&", "||"}
BINARY_OPS = COMPARISONS | LOGICAL | ASSIGN_OPS | {"+", "-", "*", "/", "%", "&", "|", "^", "<<", ">>", ","}
UNARY_PREFIX = {"-", "+", "!", "~", "*", "&", "++", "--"}
NUMBER = re.compile(r"-?\s*((\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?[fFuUlL]*|0[xX][0-9a-fA-F]+[uUlL]*)")
IDENTIFIER = re.compile(r"[A-Za-z_]\w*")


class Expressions:
    """The expression half of the drafter."""

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
        record = self.types.record_name(canonical)
        if record and record in self.views.views:
            return f"Int32({self.views.qualified_view(record, TARGET)}.byteCount)"
        swift = self.types.scalar(t, TARGET)
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
        record = self.types.record_name(t.get_pointee())
        return bool(record) and record in self.views.views

    def macro_span(self, cur: ci.Cursor) -> bool:
        """True when the node's whole text is one name, so the node is a macro use and its children keep no text of their own."""
        return IDENTIFIER.fullmatch(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").strip()) is not None

    def indexed_view_read(self, base: ci.Cursor) -> object | None:
        """The read behind Raven's index into a game field of records, `ent->client->saber[n]`, or None for any other base."""
        if base.kind != CursorKind.MEMBER_REF_EXPR:
            return None
        fields, root, _ = self.game_chain(base)
        if root not in ("entity", "entities"):
            return None
        # The sweep roots a view-returning read at the entity index, whatever the entity expression Raven wrote.
        read = self.reads.get(("entities", tuple(fields), False))
        return read if read is not None and read.at else None

    def vector_literal(self, cur: ci.Cursor) -> str:
        """Raven's `{ 0, 0, 0 }` or `{0}` as the vector, with the members he left out at zero."""
        cur = self.unwrap(cur)
        if cur.kind != CursorKind.INIT_LIST_EXPR:
            raise Hole("A vector local with an initializer that is not a list.")
        words = [self.expr(k) for k in cur.get_children()]
        if len(words) > 3:
            raise Hole("A vector initializer with more than three members.")
        words += ["0"] * (3 - len(words))
        return f"vec3_t({', '.join(words)})"

    def strip(self, cur: ci.Cursor) -> ci.Cursor:
        """The expression under the implicit casts Clang wraps around it."""
        while cur.kind == CursorKind.UNEXPOSED_EXPR:
            kids = list(cur.get_children())
            if len(kids) != 1:
                break
            cur = kids[0]
        return cur

    def swift_type_of(self, cur: ci.Cursor) -> str | None:
        """The Swift type of an expression, as spelling.py answers the expression role over the kind the body already knows."""
        answer = self.types.answer("expression", self.strip(cur).type, Facts(is_bool=self.is_bool(cur)))
        return None if answer is None else answer.swift

    def holds_double(self, cur: ci.Cursor) -> bool:
        """True when Swift holds the expression, or an operand inside it, as a Double: a `double` name, field, or cast,
        or a call to a port function that returns Raven's `double`.
        A C library call is not one, because Foundation's overload follows its float argument, `tan(x)` for a float `x`."""
        inner = self.unwrap(cur)
        if inner.kind in (CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR, CursorKind.ARRAY_SUBSCRIPT_EXPR, CursorKind.CSTYLE_CAST_EXPR):
            return self.types.number_kind(inner.type) == "Double"
        if inner.kind == CursorKind.CALL_EXPR or self.is_call(inner):
            kids = self.call_children(inner)
            callee = self.strip(kids[0]) if kids else None
            if callee is None or self.types.number_kind(inner.type) != "Double" or not self.oracle_declares(callee.referenced):
                return False
            # A body reaches a C library name Raven redefined, `atof`, through the shared module's port, which answers in Float.
            return "JKAShared" not in self.registry.homes.get(swift_name(callee.spelling), set())
        if inner.kind in (CursorKind.BINARY_OPERATOR, CursorKind.UNARY_OPERATOR, CursorKind.CONDITIONAL_OPERATOR, CursorKind.PAREN_EXPR):
            return any(self.holds_double(k) for k in inner.get_children())
        return False

    def is_literal(self, cur: ci.Cursor) -> bool:
        """A number Raven spelled as digits, which Swift types by context. A macro name is a typed constant, not a literal."""
        inner = self.unwrap(cur)
        text = self.bytes[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace").strip()
        return NUMBER.fullmatch(text) is not None

    def converted(self, cur: ci.Cursor, swift: str) -> str:
        """An expression stored where Swift wants `swift`. spelling.py names the crossing, and the words under it are Raven's own."""
        double = self.leaf_wrap is None and not self.is_literal(cur) and (self.has_double_literal(cur) or self.holds_double(cur))
        if swift in ("Float", "Int32") and double:
            # C computes the expression in double and converts once at the store, by "A double literal".
            return f"{swift}({self.wrapped(cur, 'Double')})"
        if swift == "Double" and double:
            # A store into Raven's `double` keeps C's double arithmetic, and each float operand widens as C widens it.
            return self.wrapped(cur, "Double")
        answer = self.types.crossing(self.strip(cur).type, swift,
                                     Facts(is_bool=self.is_bool(cur), is_literal=self.is_literal(cur),
                                           named_leaf=self.unwrap(cur).kind in self.NAMED_LEAVES,
                                           float_valued=not self.holds_double(cur)))
        if answer.kind == "bool_to_number":
            text = self.expr(cur)
            if text in ("true", "false"):
                return "1" if text == "true" else "0"
            return f"({text} ? 1 : 0)"
        if answer.kind == "coerce":
            return self.coerced(cur, swift)
        return answer.crossing.format(text=self.expr(cur))

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
        if param is None or base.spelling in self.cursor_locals:
            # A parameter the body walks is a read cursor, and its subscript reads the byte.
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
        return self.types.is_char_array(inner.type)

    def is_bool(self, cur: ci.Cursor) -> bool:
        """True when the expression already is a Swift Bool: a comparison, a logical operator, a `!`, qtrue, qfalse, or a qboolean."""
        cur = self.strip(cur)
        text = self.source.slice(cur.extent).strip()
        entry = HAND_MACROS.get(text) if IDENTIFIER.fullmatch(text) else None
        if entry is not None and entry.swift == "Bool":
            # A hand macro whose ruling gives a Bool spelling is a test already, `saberInvalid(...)` for Raven's `SABERINVALID`.
            return True
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
        return self.types.is_pointer(self.strip(cur).type)

    def coerced(self, cur: ci.Cursor, swift: str | None) -> str:
        if swift != "Bool":
            return self.expr(cur)
        if self.is_bool(cur):
            return self.expr(cur)
        inner = self.strip(cur)
        if inner.kind == CursorKind.PAREN_EXPR:
            return self.coerced(list(inner.get_children())[0], "Bool")
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.optional_vectors:
            return f"{self.names[inner.spelling]} != nil"
        name = self.always_set(cur)
        if name is not None:
            note = f"// Port-note: Raven tests `{name}` for NULL here. Swift holds it as a value, so the test has no form and reads true."
            self.pending += self.null_fold_note(cur, name, note)
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

    NAMED_LEAVES = (CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR, CursorKind.ARRAY_SUBSCRIPT_EXPR)

    def unsigned_of(self, cur: ci.Cursor) -> str | None:
        """The unsigned Swift type of the expression, as spelling.py spells its C type."""
        return self.types.unsigned(self.strip(cur).type, TARGET)

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
        if self.leaf_wrap is None or self.types.number_kind(cur.type) is None:
            return text
        if self.leaf_wrap == "Double" and self.holds_double(cur):
            # Raven's `double` operand is already a Double, so it takes no conversion.
            return text
        if self.leaf_wrap in UNSIGNED and self.unsigned_of(cur) is not None:
            return text
        if self.leaf_wrap in UNSIGNED and not self.is_literal(cur):
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
                if text in HAND_MACROS:
                    # A hand macro has the Swift spelling its ruling gives, `buildDate` for Raven's `__DATE__`.
                    return self.leaf(cur, HAND_MACROS[text].spelling)
                return self.leaf(cur, swift_name(text))
        chosen = self.chosen_deref(cur)
        if chosen is not None:
            # Raven's `(*teamPtr)` is the file-scope variable the caller chose, which crosses as the inout parameter.
            return self.leaf(cur, chosen)
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
            if cur.spelling in self.narrow_locals and cur.referenced is not None and cur.referenced.kind == CursorKind.VAR_DECL:
                # C widens the narrow local to int at every read.
                word = f"Int32({word})"
            return word if word in ("true", "false", "nil") else self.leaf(cur, word)
        if kind == CursorKind.MEMBER_REF_EXPR:
            return self.leaf(cur, self.member(cur))
        if kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            base, index = list(cur.get_children())
            inner_base = self.strip(base)
            indexed = self.indexed_view_read(inner_base)
            if indexed is not None and self.shared_read_key(cur) in self.hoisted:
                return self.leaf(cur, self.hoisted[self.shared_read_key(cur)])
            if indexed is not None:
                # Raven's `ent->client->saber[n]` is one record of the game's table, and the callback takes both indexes.
                args = f"of: {self.entity_index_text(self.game_chain(inner_base)[2])}, at: {self.converted(index, 'Int32')}"
                return self.leaf(cur, f"{indexed.name}({args})")
            if inner_base.kind == CursorKind.DECL_REF_EXPR and inner_base.spelling in self.offset_cursors:
                # A write cursor is a byte offset, so Raven's `p[i]` is the buffer's byte that far past it.
                slot = f"{self.cursor_buffer(inner_base.spelling)}[{self.expr(inner_base)} + {self.converted(index, 'Int32')}]"
                return self.leaf(cur, slot)
            if inner_base.kind == CursorKind.DECL_REF_EXPR and inner_base.spelling in self.cursor_locals:
                return self.leaf(cur, f"{self.expr(inner_base)}[{self.converted(index, 'Int32')}]")
            pointer = self.params_by_name.get(inner_base.spelling) if inner_base.kind == CursorKind.DECL_REF_EXPR else None
            if pointer is not None and pointer.kind == "int_array":
                # The parameter is an optional array, and Raven's NULL guard stands above every index, so the read unwraps it.
                return self.leaf(cur, f"{self.expr(inner_base)}![{self.expr(index)}]")
            if pointer is not None and (pointer.swift or "").startswith("UnsafeMutablePointer<"):
                # Rule 11 keeps the pointer out of a logic target, so an index through it has no form until a ruling gives the parameter a shape.
                raven = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                raise Hole(f"Raven indexes `{raven}` through the `{inner_base.type.spelling}` parameter, which crosses as a raw pointer under rule 11. A shape ruling is due.")
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
                if self.unwrap(operand).kind == CursorKind.DECL_REF_EXPR and self.unwrap(operand).spelling in self.optional_vectors:
                    return f"{self.names[self.unwrap(operand).spelling]} == nil"
                name = self.always_set(operand)
                if name is not None:
                    note = f"// Port-note: Raven guards a NULL `{name}` here. Swift holds it as a value, so the guard has no form and reads false."
                    self.pending += self.null_fold_note(operand, name, note)
                    return "false"
                if self.chosen_deref(operand) is not None:
                    # Raven's `!(*teamPtr)` guards the chosen variable, which the inout parameter holds as an optional view.
                    return f"{self.chosen_deref(operand)} == nil"
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
                through_cursor = self.cursor_deref(operand)
                if through_cursor is not None:
                    return through_cursor
                raw = self.raw_store(cur)
                if raw is not None:
                    # Raven's `*(char **)(b+ofs)` reads the slot at that byte offset, the same subscript his store writes.
                    return self.raw_slot(raw)
                raise Hole("A pointer dereference the draft cannot place.")
            raise Hole(f"A {op} inside an expression.")
        if kind == CursorKind.BINARY_OPERATOR:
            op = self.binary_op(cur)
            if self.fn.name in WRAPPING_ARITHMETIC and op in ("+", "-", "*"):
                # The generator's arithmetic wraps at 32 bits, as C's does.
                op = "&" + op
            left, right = list(cur.get_children())
            if op in LOGICAL:
                a, b = self.condition(left), self.condition(right)
                span = (self.fn.stem, cur.extent.start.offset, cur.extent.end.offset)
                # A folded guard drops out of the operator it sat in.
                if (op == "||" and a == "false") or (op == "&&" and a == "true"):
                    self.logical_tails[span] = (b, right)
                    return b
                if (op == "||" and b == "false") or (op == "&&" and b == "true"):
                    self.logical_tails[span] = self.logical_tail(left, op, a)
                    return a
                tail, tail_cur = self.logical_tail(left, op, a)
                if tail == b and self.pure_read(tail_cur) and self.pure_read(right):
                    # Two reads side by side in one chain give one value, so the draft writes the test once.
                    raven = [" ".join(self.source.slice(self.strip(c).extent).split()) for c in (tail_cur, right)]
                    self.pending.append(f"// Raven tests `{raven[0]}` and `{raven[1]}`.")
                    self.pending.append("// Both read as the same Swift test, so the draft writes it once.")
                    self.logical_tails[span] = (tail, tail_cur)
                    return a
                self.logical_tails[span] = (b, right)
                return f"{a} {op} {b}"
            if op in ASSIGN_OPS:
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
            # Swift needs a digit on both sides of the point, so Raven's `.5` reads `0.5` and his `5.` reads `5.0`.
            text = re.sub(r"[fF]$", "", text)
            text = re.sub(r"^\.(?=\d)", "0.", text)
            return re.sub(r"^(\d+)\.(?=[eE]|$)", r"\1.0", text)
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
            # A read of an optional vector parameter is the force unwrap, where C read through the pointer with no guard.
            return self.names[name] + ("!" if name in self.optional_vectors else "")
        if name in self.local_holes and ref is not None and ref.kind == CursorKind.VAR_DECL:
            # The declaration is a hole, so the local has no Swift name, and a read of it is the same hole one statement later.
            raise Hole(f"A read of `{name}`, a local the draft left as a hole.")
        if name in self.aliases and ref is not None and ref.kind == CursorKind.VAR_DECL:
            return self.expr(self.aliases[name])
        if name in self.table_cursors and ref is not None and ref.kind == CursorKind.VAR_DECL:
            table, index = self.table_cursors[name]
            if any(v.name == table and v.reason == "hand_table" for vs in self.sk.variables.values() for v in vs):
                # The hand table is a Swift array of rows with no view, so the view fields and the C pointer walk have no Swift twin.
                raise Hole(f"Raven walks `{table}` by pointer, and the hand table is a Swift array of rows with no view. A walk over it has no form yet.")
            if ref.semantic_parent is not None and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
                raise Hole(f"Raven walks the file-scope pointer `{name}` over a table, and a file-scope walk has no index local yet.")
            return f"{table}[{index}]"
        if ref is not None and ref.kind == CursorKind.ENUM_CONSTANT_DECL:
            return name
        if ref is not None and ref.kind == CursorKind.FUNCTION_DECL and target_of(self.fn.stem) != BG:
            # Raven names a stored function as a value, and the thunk of its field's namespace is that value, by rule 3.
            fields = [field for field, pairs in self.sk.stores.items() if any(stored == name for stored, _ in pairs)]
            if len(fields) == 1:
                return f"{fields[0][0].upper()}{fields[0][1:]}.{swift_name(name)}"
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
            if t.kind == TypeKind.POINTER and self.types.scalar(t.get_pointee(), TARGET) is not None and t.get_pointee().get_canonical().kind != TypeKind.CHAR_S:
                text = self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace")
                raise Hole(f"Raven reads `{text}`, a `{field.type.spelling}` field. The generated field is an `OpaquePointer?`, and rule 11 keeps a pointer out of a logic target.")
        return f"{self.base(kids[0])}.{swift_name(cur.spelling)}"

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
            if target_of(self.fn.stem) == BG and self.types.record_name(canonical.get_pointee()) == "gentity_t":
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
            if self.cursor_address(operand) and canonical.get_pointee().get_canonical().kind == TypeKind.POINTER \
                    and canonical.get_pointee().get_canonical().get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                # Raven's `(const char **)&p` is the address of a cursor, which the plain `&p` shape already passes.
                return self.expr(self.unwrap(operand))
            record = self.types.record_name(canonical.get_pointee())
            if record and record in self.views.views:
                self.reachable(record)
                if self.types.record_name(self.strip(operand).type.get_canonical().get_pointee()) == record:
                    # A cast to the type the operand already has is Raven's habit, and the view is the same view.
                    return self.expr(operand)
                return f"{self.views.qualified_view(record, TARGET)}({self.expr(operand)})"
            raise Hole(f"A cast to `{target.spelling}` the draft has no view for.")
        swift = self.types.scalar(target, TARGET)
        if swift is None:
            raise Hole(f"A cast to `{target.spelling}` the table has no type for.")
        if self.types.narrow(target) is not None:
            swift = "Int32"
        if swift in ("Int32", "Float") and self.is_bool(operand):
            # Raven's `(int)` on a qboolean is the Bool as a number.
            return self.converted(operand, swift)
        if swift in ("Int32", "Float") and self.leaf_wrap == "Double":
            # Raven's cast inside a double expression, `(float)pm->ps->speed * max / (127.0 * total)`, converts and then widens as C does.
            outer = self.leaf_wrap
            self.leaf_wrap = None
            try:
                inner = self.expr(operand)
            finally:
                self.leaf_wrap = outer
            return f"Double({swift}({inner}))"
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

    def logical_tail(self, cur: ci.Cursor, op: str, text: str) -> tuple[str, ci.Cursor]:
        """The last test of a chain of one logical operator, as its Swift text and Raven's operand.
        C groups `a && b && c` from the left, so the last test of the left operand stands next to the right operand."""
        inner = self.strip(cur)
        span = (self.fn.stem, inner.extent.start.offset, inner.extent.end.offset)
        if inner.kind == CursorKind.BINARY_OPERATOR and span in self.logical_tails and self.binary_op(inner) == op:
            return self.logical_tails[span]
        return text, cur

    def pure_read(self, cur: ci.Cursor) -> bool:
        """True when Raven's operand calls no function and stores nothing, so a second read of it gives the value of the first."""
        for c in cur.walk_preorder():
            if c.kind in (CursorKind.CALL_EXPR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR):
                return False
            try:
                if c.kind == CursorKind.BINARY_OPERATOR and self.binary_op(c) == "=":
                    return False
                if c.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(c)[0] in ("++", "--"):
                    return False
            except Hole:
                return False
        return True

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
