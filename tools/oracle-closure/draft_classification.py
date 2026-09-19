"""draft_classification.py: the questions the drafter asks about a cursor, the view, the Slots, the entity, and the text.
It answers which member is a slot of a view, which name stands for a Slots, which pointer is a game entity, and which local holds text, a cursor, or raw bytes.
It holds the Hole exception and the Port-note line the drafter writes where a construct has no rule, so every other concern reads them from here."""

from __future__ import annotations

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

from spelling import INT_KINDS

from rulings import NEVER_NULL_VARS
import closure as C
from skeleton import BG, Function, target_of
from table import Cursor, swift_name

INDENT = "    "


class Hole(Exception):
    """A construct the draft has no rule for. The message is the reason the Port-note carries."""


class Classification:
    """The view, Slots, entity, and text questions of the drafter."""

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
        # Raven's `qboolean` and his `vehicleType_t` are enums of four bytes, which Swift holds as the Int32 the `int` slot stores.
        if pointee.kind == TypeKind.ENUM or (pointee.kind in INT_KINDS and pointee.kind not in (TypeKind.CHAR_S, TypeKind.UCHAR)):
            label = "int"
        elif pointee.kind == TypeKind.FLOAT:
            label = "float"
        elif pointee.kind == TypeKind.POINTER and pointee.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
            label = "pointer"
        else:
            return None
        sum_ = self.unwrap([k for k in cast.get_children() if k.kind.is_expression()][-1])
        if sum_.kind != CursorKind.BINARY_OPERATOR or self.operator_or_none(sum_) != "+":
            return None
        base, ofs = list(sum_.get_children())
        if not self.is_raw(base):
            return None
        return self.expr(base), label, self.converted(ofs, "Int32"), index

    def raw_slot(self, raw: tuple[str, str, str, str | None], label: str | None = None) -> str:
        """The labeled subscript of `RawField.swift` a raw store or a raw read spells, `b[int: f.ofs]` and `b[float: f.ofs, 1]`."""
        base_text, own, ofs, index = raw
        label = label or own
        return f"{base_text}[{label}: {ofs}, {index}]" if index is not None else f"{base_text}[{label}: {ofs}]"

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
        if inner.kind == CursorKind.UNARY_OPERATOR and self.operator_or_none_unary(inner) == "*":
            # Raven's `*(char **)(b+ofs)` is the raw pointer the slot at that byte offset holds.
            raw = self.raw_store(inner)
            return raw is not None and raw[1] == "pointer"
        return False

    def local_facts(self, fn: Function) -> tuple[dict[str, Cursor], dict[str, Cursor], dict[str, tuple[str, str]]]:
        """The read cursors, the write cursors, and the table walks of one body, by the local read of the table, each under Raven's own name."""
        reads: dict[str, Cursor] = {}
        writes: dict[str, Cursor] = {}
        walks: dict[str, tuple[str, str]] = {}
        for name, row in self.sk.table.locals_of(fn.stem, fn.cur.spelling).rows.items():
            if row.cursor is not None:
                (writes if row.cursor.write else reads)[name] = row.cursor
            if row.table is not None:
                walks[name] = row.table
        return reads, writes, walks

    def cursor_buffer(self, name: str) -> str:
        """The Swift text of the buffer a cursor local walks. A file-scope buffer goes through the module's own reach rule."""
        cursor = self.cursor_locals.get(name) or self.offset_cursors[name]
        if cursor.is_global:
            self.reach(cursor.buffer, "variable")
        return self.expr_name(cursor.buffer)

    def text_cursor(self, cur: ci.Cursor) -> str:
        """Raven's `p = buf` and his `p = buf + offset` as the TextCursor over that buffer."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(inner) == "+":
            base, offset = list(inner.get_children())
            return f"JKAShared.TextCursor({self.expr(base)}, at: {self.converted(offset, 'Int32')})"
        return f"JKAShared.TextCursor({self.expr(inner)})"

    def cursor_offset(self, cur: ci.Cursor) -> str:
        """The byte offset a store gives a write cursor: the offset Raven added to the buffer, and 0 for the buffer itself."""
        inner = self.unwrap(cur)
        if inner.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(inner) == "+":
            return self.converted(list(inner.get_children())[1], "Int32")
        return "0"

    def cursor_deref(self, cur: ci.Cursor) -> str | None:
        """Raven's `*p` and `*(p + n)` through a cursor local, or None when the expression is neither.

        A read cursor gives the byte under it and the byte at a relative offset. A write cursor is an offset into the buffer,
        so the read is the buffer's own byte at that index."""
        inner = self.unwrap(cur)
        step = op = None
        if inner.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(inner) in ("+", "-"):
            base, offset = list(inner.get_children())
            if self.unwrap(base).kind != CursorKind.DECL_REF_EXPR:
                return None
            op = self.operator_or_none(inner)
            step = self.converted(offset, "Int32")
            inner = self.unwrap(base)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return None
        name = inner.spelling
        if name in self.offset_cursors:
            index = self.expr(inner) if step is None else f"{self.expr(inner)} {op} {step}"
            return f"{self.cursor_buffer(name)}[{index}]"
        if name in self.cursor_locals:
            if step is None:
                return f"{self.expr(inner)}.byte"
            if op == "+":
                return f"{self.expr(inner)}[{step}]"
        return None

    def text_local_names(self, fn: ci.Cursor) -> tuple[set[str], set[str]]:
        """The char pointer locals of the function by their stores: a local every store fills from a String-returning call or from a
        `char name[N]` field is a text local.
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
        return texts, optionals

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
        """Every pointer-to-byte local whose every store is a raw pointer, by the stores of the function.

        A declaration's own initializer is a store, so Raven's `byte *b = (byte *)vehWeapon` names the record's bytes."""
        stores: dict[str, list[bool]] = {}
        for var in fn.walk_preorder():
            if var.kind != CursorKind.VAR_DECL:
                continue
            t = var.type.get_canonical()
            if t.kind != TypeKind.POINTER or t.get_pointee().get_canonical().kind not in (TypeKind.CHAR_S, TypeKind.UCHAR, TypeKind.CHAR_U, TypeKind.SCHAR):
                continue
            init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
            if not init:
                continue
            self.raw_locals = set()
            stores.setdefault(var.spelling, []).append(self.is_raw(init[0]))
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

    def operator_or_none(self, cur: ci.Cursor) -> str | None:
        """The operator of a binary node, or None where its text is not readable, for a pre-scan that must not raise."""
        try:
            return self.binary_op(cur)
        except Hole:
            return None

    def keyword(self, var: ci.Cursor, init: bool) -> str:
        """The Swift keyword a declaration takes. A declaration with an initializer reads the write set, and one without it reads the single-write set."""
        name = var.spelling
        if init:
            return "let" if name not in self.written else "var"
        return "let" if name in self.lets else "var"

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

    def is_record(self, t: ci.Type) -> bool:
        """True for a C struct the views cover."""
        canonical = t.get_canonical()
        if canonical.kind != TypeKind.RECORD:
            return False
        record = self.types.record_name(canonical)
        return bool(record) and record in self.views.views

    def first_text_field(self, t: ci.Type) -> tuple[str, bool] | None:
        """The first field of a record when it holds text, as the Swift name the view gives it and whether the view holds it as an optional.
        A record whose first field holds no text has no answer."""
        record = t.get_canonical().get_declaration()
        fields = [f for f in record.get_children() if f.kind == CursorKind.FIELD_DECL]
        if not fields:
            return None
        first = fields[0].type.get_canonical()
        if first.kind == TypeKind.CONSTANTARRAY and first.element_type.get_canonical().kind == TypeKind.CHAR_S:
            # A `char name[N]` field is a String on the view.
            return swift_name(fields[0].spelling), False
        if first.kind == TypeKind.POINTER and first.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
            # A `char *` field is a PooledString? on the view.
            return swift_name(fields[0].spelling), True
        return None

    def callee_name(self, cur: ci.Cursor) -> str | None:
        kids = list(cur.get_children())
        callee = self.strip(kids[0]) if kids else None
        return callee.spelling if callee is not None and callee.kind == CursorKind.DECL_REF_EXPR else None

    def collapsed(self, cur: ci.Cursor) -> bool:
        """True when a child spans the same bytes as the node, the mark of a macro expansion, whose nodes keep no text of their own."""
        return any(k.extent.start.offset == cur.extent.start.offset and k.extent.end.offset == cur.extent.end.offset for k in cur.get_children())

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
        elif root == "entities":
            args = f"of: {self.entity_index_text(base)}"
        else:
            args = ""
        read = self.reads.get((root, tuple(fields), False))
        if read is None:
            raise Hole(f"Raven reaches the game's `{'.'.join(fields)}` here, and the channel has no read for it.")
        if read.at:
            raise Hole(f"Raven reaches the game's `{'.'.join(fields)}` here outside the index the read takes.")
        return f"{read.name}({args})"

    def entity_index_text(self, base: ci.Cursor) -> str:
        """Raven's index into `g_entities`, at the slot or through the local he set to it, as the callback's `of:` argument."""
        index = self.sk.table.entity_index(base)
        if index is None:
            raise Hole("Raven reaches the game's entity table here, and the draft cannot spell the index.")
        return self.converted(index, "Int32")

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

    def optional_base(self, cur: ci.Cursor) -> bool:
        """True when the expression is a pointer a Swift view holds as optional, so a member read through it takes `!`."""
        inner = self.strip(cur)
        if inner.kind == CursorKind.PAREN_EXPR:
            return self.optional_base(list(inner.get_children())[0])
        if inner.kind == CursorKind.CSTYLE_CAST_EXPR:
            kids = [k for k in inner.get_children() if k.kind.is_expression()]
            return bool(kids) and self.optional_base(kids[-1])
        if inner.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
            kids = list(inner.get_children())
            if kids and self.indexed_view_read(self.strip(kids[0])) is not None:
                # The callback hands back the game's record, and the game's client is NULL on an entity that holds no player.
                return True
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
            if inner.spelling in self.offset_cursors:
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
            return self.types.record_name(inner.type.get_canonical().get_pointee()) is not None
        return False

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

    def expr_name(self, name: str) -> str:
        return self.names.get(name, swift_name(name))

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
            return self.types.is_slots(param.swift)
        return self.types.is_slots(self.registry.var_types.get(swift_name(inner.spelling), ""))

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

    def one_record_slots(self, cur: ci.Cursor) -> str | None:
        """The Slots of one record over a read Swift holds as one record, or None for every other read.

        A store into a Slots target takes this shape: the record is the first element, and the count is one, because C gives one record no bound.
        An optional record keeps Raven's own NULL test, so the map hands the Slots on and a NULL record leaves the target nil."""
        inner = self.unwrap(cur)
        if self.is_null(inner) or not self.view_operand(inner) or self.is_raw(inner):
            return None
        record = self.expr(cur)
        if self.optional_base(inner):
            return f"{record}.map {{ Slots(record: $0) }}"
        return f"Slots(record: {record})"

    def slots_target(self, cur: ci.Cursor) -> bool:
        """True for the left side of a store Swift holds as a Slots: a parameter of that kind, or a local of that kind."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR:
            return False
        if inner.spelling in self.slots_locals:
            return True
        param = self.params_by_name.get(inner.spelling)
        return param is not None and self.types.is_slots(param.swift)

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
        record = self.types.record_name(t.get_pointee())
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
            return self.types.is_slots(param.swift)
        return self.types.is_slots(self.registry.var_types.get(swift_name(inner.spelling), ""))

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

    def cursor_address(self, cur: ci.Cursor) -> bool:
        """True for Raven's `&p` on a read cursor, the address the COM_Parse family steps."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.UNARY_OPERATOR or self.operator_or_none_unary(inner) != "&":
            return False
        target = self.unwrap(self.unary_parts(inner)[2])
        return target.kind == CursorKind.DECL_REF_EXPR and target.spelling in self.cursor_locals

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
        record = self.types.record_name(t.get_pointee())
        return bool(record) and record in self.views.views
