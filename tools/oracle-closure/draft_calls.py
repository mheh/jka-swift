"""draft_calls.py: the call half of the drafter, one Swift call for each of Raven's.
It reads the registry for the parameters of a callee, picks the overload that takes the arguments as they are, and gives an argument its `&` where the Swift signature asks for one.
It also holds the text kind of each argument of the call being drafted, so one overload takes the whole call."""

from __future__ import annotations

import codecs
import re

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

from spelling import INT_KINDS

from skeleton import BG, LOGIC, target_of
from table import Param, swift_name
from overlay import MACROS
from rulings import LIBC_SPELLINGS

from draft_classification import Hole

TEXT_TYPES = {"String", "CharBuf", "JKAShared.CharBuf", "PooledString", "JKAShared.PooledString"}
# The declaration tail of the scratch local each `inout` output a caller skips with NULL takes, by the parameter's Swift spelling.
SCRATCH_ZEROS = {"inout vec3_t": "= vec3_t()", "inout Int32": ": Int32 = 0", "inout Float": ": Float = 0"}
# One C conversion, `%%` or a `%` with its flags, width, precision, length, and conversion letter.
CONVERSION = re.compile(r"%(?:%|[-+ #0]*(\*|\d+)?(?:\.(\*|\d*))?(?:hh|h|ll|l|j|z|t|L|I64|I32|I)?([diouxXeEfFgGaAcspn]))")


def conversions(text: str) -> list[str] | None:
    """The conversion letter each argument after a C format string feeds, in order, with `*` for a width or precision argument.
    A `%` outside the C grammar gives no answer."""
    out: list[str] = []
    at = 0
    while (start := text.find("%", at)) != -1:
        match = CONVERSION.match(text, start)
        if match is None:
            return None
        at = match.end()
        if match.group(0) == "%%":
            continue
        out += ["*"] * [match.group(1), match.group(2)].count("*")
        out.append(match.group(3))
    return out


class Calls:
    """The call and argument half of the drafter."""

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
        if base.spelling in self.text_locals or (param is not None and param.kind == "cstring" and base.spelling not in self.cursor_locals):
            return f"String({self.expr(base)}.dropFirst(Int({self.converted(index, 'Int32')})))"
        return None

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
            if any(self.argument_key(args[i], i) not in self.aliased_positions for i, _, _, _ in aliased):
                # The statement rule and the if rule copy the earlier ones into locals.
                # A call they do not reach, such as one in a loop test, has no line of its own for the copies.
                raise Hole(f"Raven passes `{aliased[0][1]}` more than once to `{name}` inside a test, and Swift refuses one variable twice inout.")
            params = self.callee_params(name)
            at = self.copy_target(args, params)
            outer = self.call_kinds, self.call_format
            self.call_kinds = self.argument_kinds(args)
            self.call_format = self.format_conversions(callee.referenced.type, args)
            try:
                words = [f"&{at[1]}" if at is not None and i == at[0]
                         else self.argument(a, i < len(params) and params[i][1].startswith("inout "), params[i] if i < len(params) else None, name, i)
                         for i, a in enumerate(args)]
            finally:
                self.call_kinds, self.call_format = outer
            if at is not None:
                words.append(f"at: {at[2]}")
            return f"{self.qualifier(name)}{LIBC_SPELLINGS.get(name, swift_name(name))}({', '.join(words)})"
        if callee is not None and callee.kind == CursorKind.MEMBER_REF_EXPR:
            # A stored function on a view runs through the view's method, `pm.runTrace(...)`, which views.py writes per field.
            kids_ = list(callee.get_children())
            field = callee.spelling
            method = f"run{field[0].upper()}{field[1:]}"
            params = self.registry.params.get(method, [])
            if self.owner_first(callee) and args:
                # The run method passes its own slot first, as views.py writes it, so Raven's first argument drops when it is the owner.
                if self.expr(args[0]) != self.expr(kids_[0]):
                    raise Hole(f"Raven passes another record first to the stored `{field}`, and the view's run method passes its own slot.")
                args = args[1:]
            outer = self.call_kinds, self.call_format
            self.call_kinds = self.argument_kinds(args)
            self.call_format = self.format_conversions(callee.type, args)
            try:
                words = [self.argument(a, i < len(params) and params[i][1].startswith("inout "), params[i] if i < len(params) else None, method, i) for i, a in enumerate(args)]
            finally:
                self.call_kinds, self.call_format = outer
            return f"{self.base(kids_[0])}.{method}({', '.join(words)})"
        if callee is not None:
            outer_format = self.call_format
            self.call_format = self.format_conversions(callee.type, args)
            try:
                words = [self.argument(a, False, None, None, i) for i, a in enumerate(args)]
            finally:
                self.call_format = outer_format
            if callee.kind == CursorKind.DECL_REF_EXPR and (self.params_by_name.get(callee.spelling, Param("", None, "")).swift or "").endswith(")?"):
                # A callback parameter is an optional closure, and Raven calls it under his `if (localTrace)` guard.
                return f"{self.expr(callee)}?({', '.join(words)})"
            return f"{self.expr(callee)}({', '.join(words)})"
        raise Hole("A call with no callee.")

    def aliased_inouts(self, cur: ci.Cursor) -> list[tuple[int, str, str, bool]]:
        """The inout arguments that name one variable or one member path more than once, each as its position, its text,
        the copy that stands in for it, and whether the copy writes back after the call.
        Raven's callee reads the earlier ones and writes the last, `PM_ClipVelocity(v, n, v)`.
        A plain variable passes as itself in the last place. A member path such as `pm->ps->velocity` goes through a view's setter,
        and Swift writes the unchanged in-copy back last, so the last place takes an out copy that writes back after the call."""
        kids = self.call_children(cur)
        callee = self.strip(kids[0]) if kids else None
        if callee is None or callee.kind != CursorKind.DECL_REF_EXPR or callee.spelling in MACROS:
            return []
        positions = self.inout_positions(callee.spelling)
        names: list[tuple[int, str, str, ci.Cursor]] = []
        for i, arg in enumerate(kids[1:]):
            inner = self.strip(arg)
            if i not in positions:
                continue
            if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
                inner = self.unary_parts(inner)[2]
            inner = self.unwrap(inner)
            if inner.kind == CursorKind.DECL_REF_EXPR:
                names.append((i, inner.spelling, inner.spelling, inner))
            elif self.member_path_root(inner) is not None:
                key = " ".join(self.bytes[inner.extent.start.offset:inner.extent.end.offset].decode("utf-8", "replace").split())
                names.append((i, key, inner.spelling, inner))
        out = []
        for i, key, leaf, node in names:
            later = [j for j, other, _, _ in names if other == key and j > i]
            earlier = [j for j, other, _, _ in names if other == key and j < i]
            text = self.expr_name(leaf) if node.kind == CursorKind.DECL_REF_EXPR else self.expr(node)
            if later:
                out.append((i, text, f"{swift_name(leaf)}In{i}", False))
            elif earlier and node.kind != CursorKind.DECL_REF_EXPR:
                out.append((i, text, f"{swift_name(leaf)}Out{i}", True))
        return out

    def member_path_root(self, cur: ci.Cursor) -> ci.Cursor | None:
        """The variable at the root of a member path, `pm` for `pm->ps->velocity`, or None when the expression is not one."""
        node = cur
        while node.kind == CursorKind.MEMBER_REF_EXPR:
            kids = list(node.get_children())
            if not kids:
                return None
            node = self.unwrap(self.strip(kids[0]))
        return node if node.kind == CursorKind.DECL_REF_EXPR and node is not cur else None

    def call_children(self, cur: ci.Cursor) -> list[ci.Cursor]:
        """The callee and the arguments of one call, through the implicit cast Raven's call can stand under."""
        return list(self.strip(cur).get_children()) if cur.kind == CursorKind.UNEXPOSED_EXPR else list(cur.get_children())

    def argument_key(self, arg: ci.Cursor, position: int) -> tuple[int, int, int]:
        """The identity of one argument: its extent in Raven's file and its position in the call.
        The copy swaps in for this argument alone, so a different argument at the same position in a nested or sibling call keeps its text."""
        inner = self.strip(arg)
        return inner.extent.start.offset, inner.extent.end.offset, position

    def macro_call(self, name: str, args: list[ci.Cursor]) -> str:
        """Raven's `VectorCopy(a, b)` as the table's Swift, each argument a node of the overlay's call."""
        template, floats = MACROS[name]
        if template.count("{") != len(args):
            raise Hole(f"{name} takes {template.count('{')} arguments, and Raven gave {len(args)}.")
        if template.startswith(f"{name}("):
            template = self.qualifier(name) + template
        words = []
        for i, arg in enumerate(args):
            inner = self.strip(arg)
            if inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&":
                inner = self.unary_parts(inner)[2]
            word = self.converted(inner, "Float") if i in floats else self.expr(inner)
            if self.strip(inner).kind in (CursorKind.BINARY_OPERATOR, CursorKind.CONDITIONAL_OPERATOR) \
                    and re.search(rf"[-+*/]\s*\{{{i}\}}|\{{{i}\}}\s*[-+*/]", template):
                # The C macro binds its argument whole, so Raven's `1.0f-mass` stays one operand of the template's operator.
                word = f"({word})"
            words.append(word)
        return template.format(*words)

    def qualifier(self, name: str) -> str:
        """`JKAMP_BG.` for a game body's call to a bg function whose name the SDK also declares, `rand` and `random`, and nothing for any other call.
        Foundation's declaration shadows the bg one in a game file, so the module name breaks the tie, and one comment line above says so."""
        if target_of(self.fn.stem) == BG or name not in self.sdk_functions():
            return ""
        homes = self.registry.homes.get(swift_name(name), set())
        if BG not in homes or homes & {LOGIC, "JKAMP_Game", "JKAShared"}:
            return ""
        note = f"// The SDK also declares `{name}`, so the call names the bg module."
        if note not in self.pending:
            self.pending.append(note)
        return f"{BG}."

    def sdk_functions(self) -> set[str]:
        """The names of every function a header outside the oracle declares in the parse, the libc names Swift imports through Foundation."""
        if not hasattr(self, "_sdk_functions"):
            self._sdk_functions = {c.spelling for c in self.fn.cur.translation_unit.cursor.get_children()
                                   if c.kind == CursorKind.FUNCTION_DECL and not self.oracle_declares(c)}
        return self._sdk_functions

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
        if self.argument_key(cur, position) in self.aliased_positions:
            return f"&{self.aliased_positions[self.argument_key(cur, position)]}"
        if self.text_tail(inner) is not None:
            return self.text_tail(inner)
        if target_of(self.fn.stem) == BG and self.entity_slot(inner) is not None:
            return self.entity_slot(inner)
        addressed = inner.kind == CursorKind.UNARY_OPERATOR and self.unary_parts(inner)[0] == "&"
        if addressed:
            inner = self.unary_parts(inner)[2]
        if self.unwrap(inner).kind == CursorKind.DECL_REF_EXPR and self.unwrap(inner).spelling in self.offset_cursors:
            raise Hole(f"Raven passes the write cursor `{self.unwrap(inner).spelling}` where the callee takes no buffer beside it, "
                       "and a byte offset has no form there.")
        if param is not None and self.types.is_slots(param[1]):
            # The parameter takes the Slots over the records, and the caller hands the table it holds.
            slots = self.slots_expression(inner)
            if slots is not None:
                return slots
        if self.is_raw(inner) and self.overload_takes(callee, position, "UnsafeMutableRawPointer"):
            # A raw pointer passes as it is to the overload that takes one, `strcpy(dest, source)`.
            slot = self.raw_store(inner)
            if slot is not None and slot[1] == "pointer":
                # The slot at the byte offset is an optional raw pointer, and Raven's guard above it proved it is set.
                return f"{self.raw_slot(slot)}!"
            return self.expr(inner)
        if inout and self.is_null(inner):
            tail = SCRATCH_ZEROS.get(param[1].replace("JKAShared.", "")) if param is not None else None
            if param is None or tail is None:
                raise Hole("NULL for an inout parameter the draft has no scratch shape for.")
            scratch = f"scratch{param[0][0].upper()}{param[0][1:]}"
            self.scratch_names[scratch] = self.scratch_names.get(scratch, 0) + 1
            if self.scratch_names[scratch] > 1:
                scratch += str(self.scratch_names[scratch])
            self.pending += self.noted_hole(f"// Port-note: Raven passes NULL for the `{param[0]}` output. "
                                            "The ported function takes it by reference, so the body passes a scratch local it never reads.")
            self.pending.append(f"var {scratch} {tail}")
            return f"&{scratch}"
        if param is not None and param[1] in ("Float", "Int32", "Double", "Bool"):
            return self.converted(inner, param[1])
        if param is not None and param[1].endswith("?") and self.is_null(inner):
            return "nil"
        if param is not None and param[1].endswith("?") and inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.optional_vectors:
            # The optional vector passes on as it is, NULL and all.
            return self.names[inner.spelling]
        if param is not None and param[1].replace("JKAShared.", "") == "vec3_t" and self.is_null(inner):
            self.pending += self.noted_hole(f"// Port-note: Raven passes NULL for `{param[0]}`, and the callee reads NULL as the zero vector.")
            return "JKAShared.vec3_origin"
        if param is not None and not param[1].endswith("?") and self.is_null(inner) and inner.type.get_canonical().kind not in INT_KINDS:
            raise Hole(f"NULL for `{param[0]}`, a {param[1]} parameter.")
        if param is not None and "->" in param[1] and inner.kind == CursorKind.MEMBER_REF_EXPR and self.is_callback(inner):
            # A stored function on a view goes where the callee takes a closure as the view's run method, bound to the view.
            field = inner.spelling
            return f"{self.base(list(inner.get_children())[0])}.run{field[0].upper()}{field[1:]}"
        if inout and param is not None and param[1].replace("JKAShared.", "") == "inout CharBuf" and self.string_field(inner):
            # The record's `char name[N]` field is a write target here, and the view's `nameBuffer` accessor beside it is the CharBuf the callee writes.
            return f"&{self.buffer_expr(inner)}"
        if param is not None and param[1].replace("JKAShared.", "") == "inout CharBuf" and callee in self.sk.by_name and self.immutable_text(inner):
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes `{raven}` to `{callee}`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.")
        text = self.expr(inner)
        if param is not None and self.types.is_slots(param[1]):
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes `{raven}` to `{callee}`, whose `{param[0]}` parameter takes the Slots over the records, "
                       "and Swift holds one record here. A Slots over one record has no form yet.")
        if param is not None and self.view_parameter(param[1]) and self.slots_expression(inner) is not None:
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes `{raven}` to `{callee}`, whose `{param[0]}` parameter takes one record, "
                       "and Swift holds the argument as the Slots over the records.")
        if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling in self.cursor_locals and not addressed \
                and (param is None or param[1] in TEXT_TYPES or param[1].endswith("...")):
            # Raven passes the cursor where the callee reads text, and the cursor's text is the bytes from it to the NUL.
            return f"{self.expr(inner)}.text"
        if param is not None and param[1] == "OpaquePointer?" and self.is_raw(inner):
            # The engine takes the raw allocation as a handle.
            return f"OpaquePointer({self.expr(inner)})"
        if param is not None and param[1] == "OpaquePointer?" and self.is_charbuf(inner):
            if self.overload_takes(callee, position, "CharBuf"):
                # The buffer goes to the overload of docket row 7, which hands the engine its base inside one unsafe scope.
                return f"&{text}"
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
            first = self.first_text_field(inner.type)
            fed = self.call_format.get(position)
            if first is not None and fed is not None and fed[0] == cur and fed[1] == "s":
                # Raven passes the record's address, and the `%s` reads the text at that address, which is the record's first field. Rule 19.
                self.pending.append("// Port-note: Raven passes the record's address to a `%s`, and the format reads the text at that address.")
                self.pending.append("// Those bytes are the record's first field, and the port names that field.")
                return f"{text}.{first[0]}!" if first[1] else f"{text}.{first[0]}"
            raven = " ".join(self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace").split())
            raise Hole(f"Raven passes the record `{raven}` in a format argument list, and a view is no FormatArg.")
        return f"&{text}" if inout else text

    def format_conversions(self, callee: ci.Type, args: list[ci.Cursor]) -> dict[int, tuple[ci.Cursor, str]]:
        """The conversion letter each argument after a variadic callee's format string feeds, by position, with the argument itself.
        The format string is the last fixed argument, and only a string literal there gives an answer."""
        t = callee.get_canonical()
        if t.kind == TypeKind.POINTER:
            t = t.get_pointee().get_canonical()
        if t.kind != TypeKind.FUNCTIONPROTO or not t.is_function_variadic():
            return {}
        fixed = len(list(t.argument_types()))
        if fixed == 0 or len(args) <= fixed:
            return {}
        literal = self.unwrap(args[fixed - 1])
        if literal.kind != CursorKind.STRING_LITERAL:
            return {}
        # Clang spells the literal as C joins it, macro text included, and the C escapes decode before the count.
        body = literal.spelling[literal.spelling.find('"') + 1:-1]
        try:
            body = codecs.decode(body, "unicode_escape")
        except UnicodeError:
            pass
        letters = conversions(body)
        if letters is None:
            return {}
        return {fixed + i: (args[fixed + i], letter) for i, letter in enumerate(letters) if fixed + i < len(args)}

    def view_parameter(self, swift: str) -> bool:
        """True for a Swift parameter that takes one view, the shape a Slots does not fit."""
        base = swift.removeprefix("inout ").removesuffix("?").split(".")[-1]
        return base in {view for view, _ in self.views.views.values()}

    def owner_first(self, callee: ci.Cursor) -> bool:
        """True when the stored function's first parameter points at the record that holds the field, Raven's `ent->think(ent)`."""
        field = callee.referenced
        if field is None or field.kind != CursorKind.FIELD_DECL:
            return False
        proto = field.type.get_canonical().get_pointee()
        arg_types = list(proto.argument_types()) if proto.kind == TypeKind.FUNCTIONPROTO else []
        if not arg_types or arg_types[0].get_canonical().kind != TypeKind.POINTER:
            return False
        owner = self.types.record_name(field.semantic_parent.type) or field.semantic_parent.spelling
        return self.types.record_name(arg_types[0].get_canonical().get_pointee()) == owner

    def is_callback(self, cur: ci.Cursor) -> bool:
        """True for a member reference to a field that stores a function pointer."""
        t = cur.type.get_canonical()
        return t.kind == TypeKind.POINTER and t.get_pointee().kind == TypeKind.FUNCTIONPROTO

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

    def copy_target(self, args: list[ci.Cursor], params: list[tuple[str, str]]) -> tuple[int, str, str] | None:
        """The write cursor a call copies into, as its position, the buffer it walks, and the offset into that buffer.

        Raven's `Q_strcat(marker, size, text)` copies at the cursor, and the port hands the buffer over with the offset beside it,
        `Q_strcat(&SaberParms, size, text, at: marker)`, by row 47."""
        for i, arg in enumerate(args):
            inner = self.unwrap(arg)
            if inner.kind != CursorKind.DECL_REF_EXPR or inner.spelling not in self.offset_cursors:
                continue
            if i >= len(params) or params[i][1].replace("JKAShared.", "") != "inout CharBuf":
                continue
            return (i, self.cursor_buffer(inner.spelling), self.expr(inner))
        return None

    def text_kind(self, cur: ci.Cursor) -> str | None:
        """The Swift text type the draft passes an argument as: String, CharBuf, or PooledString, and None for the rest."""
        if self.cursor_address(cur):
            # Raven hands the cursor's address over, and the callee takes the cursor itself, which is no text argument.
            return None
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
        if inner.spelling in self.cursor_locals:
            # A read cursor crosses as its text, so an overload that takes a String at this position is the match.
            return "String"
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
