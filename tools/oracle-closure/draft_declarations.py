"""draft_declarations.py: the declarations of the drafter, the locals of a body and the copies of its parameters.
It writes the `var` and `let` lines at the top of the body, the array and vector initializers, and the mutable copy of every parameter Raven assigns.
A local that stands for a record Swift holds by value opens a scratch closure, and the rules of that closure live here."""

from __future__ import annotations

import re

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

from overlay import MACROS, written_arguments

import closure as C
from skeleton import BG, target_of
from table import TARGET, swift_name

from draft_classification import INDENT, Hole


def extent_key(cur: ci.Cursor) -> tuple[str, int, int]:
    """One node's identity across two walks of the parse, which hand back new cursor objects."""
    return cur.kind.name, cur.extent.start.offset, cur.extent.end.offset


class Declarations:
    """The declaration half of the drafter."""

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
        record = self.types.record_name(t)
        return vars_[0] if record and record in self.views.views else None

    def scratch(self, decl: ci.Cursor, var: ci.Cursor, rest: list[ci.Cursor], last_line: int, depth: int) -> list[str]:
        """Raven's block from the record local on, as the closure of the view's scratch helper. A return inside the block is
        the closure's value, and the body acts on it after the closure, by "A scratch C struct on the stack"."""
        pad = INDENT * depth
        view = self.views.qualified_view(self.types.record_name(var.type.get_canonical()), TARGET)
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

    def filled_by_address(self, name: str) -> bool:
        """True when any call of the function passes `&name` to an `inout String` parameter."""
        for cur in self.fn.cur.walk_preorder():
            if cur.kind != CursorKind.CALL_EXPR:
                continue
            if self.out_text_stores(cur, {name: []}).get(name) == "text":
                return True
        return False

    def shared_reads(self, body: ci.Cursor) -> dict[tuple[int, int], list[tuple[str, str, ci.Cursor]]]:
        """The view reads Raven names more than once in a body, each keyed by the statement its one local stands before.

        Each value lists Raven's text of the read, the name of the local, and the first use, whose draft is the local's initializer.
        The local stands in the deepest block that holds every use, before the statement that holds the first use.
        A read whose index or entity names a written or addressed variable keeps one call per use.
        A first use that runs only on some paths of its statement, such as the right operand of `||`, also keeps one call per use."""
        uses: dict[str, list[tuple[ci.Cursor, list[ci.Cursor]]]] = {}

        def walk(cur: ci.Cursor, path: list[ci.Cursor]) -> None:
            if cur.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR and self.shared_read(cur):
                uses.setdefault(self.shared_read_key(cur), []).append((cur, path))
                return
            for kid in cur.get_children():
                walk(kid, path + [cur])

        walk(body, [])
        taken = {c.spelling for c in self.fn.cur.walk_preorder() if c.kind in (CursorKind.VAR_DECL, CursorKind.PARM_DECL)}
        taken |= set(self.names.values())
        out: dict[tuple[int, int], list[tuple[str, str, ci.Cursor]]] = {}
        for key, found in uses.items():
            if len(found) < 2:
                continue
            first, first_path = min(found, key=lambda use: use[0].extent.start.offset)
            common = 0
            while all(common < len(path) and extent_key(path[common]) == extent_key(first_path[common]) for _, path in found):
                common += 1
            blocks = [i for i in range(common) if first_path[i].kind == CursorKind.COMPOUND_STMT]
            if not blocks:
                continue
            steps = first_path[blocks[-1] + 1:] + [first]
            if not all(self.runs_first(parent, child) for parent, child in zip(steps, steps[1:])):
                continue
            field = swift_name(self.game_chain(self.strip(list(first.get_children())[0]))[0][-1])
            local, n = field, 2
            while local in taken:
                local, n = f"{field}{n}", n + 1
            taken.add(local)
            out.setdefault(extent_key(steps[0]), []).append((key, local, first))
        return out

    def shared_read(self, cur: ci.Cursor) -> bool:
        """True when the subscript is a view read of the game's records, and no name inside it changes during the body."""
        try:
            if self.indexed_view_read(self.strip(list(cur.get_children())[0])) is None:
                return False
        except Hole:
            return False
        names = {c.spelling for c in cur.walk_preorder() if c.kind == CursorKind.DECL_REF_EXPR}
        return not names & (self.written | self.addressed)

    def shared_read_key(self, cur: ci.Cursor) -> str:
        """Raven's text of a read with its spaces removed, so two uses he spelled the same way share one key."""
        return re.sub(r"\s+", "", self.bytes[cur.extent.start.offset:cur.extent.end.offset].decode("utf-8", "replace"))

    def runs_first(self, parent: ci.Cursor, child: ci.Cursor) -> bool:
        """True when the child runs every time its parent runs, before any other statement of the parent's block."""
        first = extent_key(list(parent.get_children())[0]) == extent_key(child)
        if parent.kind in (CursorKind.IF_STMT, CursorKind.CONDITIONAL_OPERATOR):
            return first
        if parent.kind == CursorKind.BINARY_OPERATOR:
            return first or self.operator_or_none(parent) not in ("&&", "||", None)
        return parent.kind in (CursorKind.RETURN_STMT, CursorKind.DECL_STMT, CursorKind.VAR_DECL, CursorKind.UNEXPOSED_EXPR,
                               CursorKind.PAREN_EXPR, CursorKind.CALL_EXPR, CursorKind.MEMBER_REF_EXPR, CursorKind.ARRAY_SUBSCRIPT_EXPR,
                               CursorKind.UNARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR, CursorKind.CSTYLE_CAST_EXPR)

    def shared_read_lines(self, statement: ci.Cursor, depth: int) -> list[str]:
        """The one local of each shared view read that stands before this statement, and the note Raven's repeat earns."""
        out: list[str] = []
        for key, local, first in self.hoists.get(extent_key(statement), []):
            try:
                read = self.expr(first)
            except Hole:
                continue
            raven = " ".join(self.bytes[first.extent.start.offset:first.extent.end.offset].decode("utf-8", "replace").split())
            out.append(f"{INDENT * depth}// Raven names `{raven}` more than once, and each Swift use calls the channel, so the draft reads it once.")
            out.append(f"{INDENT * depth}let {local} = {read}")
            self.hoisted[key] = local
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
        if var.spelling in self.chosen_locals:
            # The local only names one of the file-scope variables, and the nested function's inout parameter is that name.
            return ""
        name = swift_name(var.spelling)
        t = var.type
        init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
        keyword = self.keyword(var, bool(init))
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t):
            if not init:
                return f"var {name} = JKAShared.vec3_t(0, 0, 0)"
            return f"var {name} = {self.vector_literal(init[0])}"
        # A typedef of an array, `vec2_t` or `G2Trace_t`, has no element type until the canonical type, and a plain array keeps its element's typedef name.
        canonical = t.get_canonical()
        if canonical.kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t.element_type if t.kind == TypeKind.CONSTANTARRAY else canonical.element_type):
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
            if init and self.view_bytes(init[0]):
                self.pending.append(f"// Raven walks the record's bytes through `{name}`, "
                                    "and the raw pointer over the view's slot is that walk, under rule 11.")
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
                return f"var {name} = {self.text_cursor(init[0])}"
            return f"var {name} = JKAShared.TextCursor()"
        if var.spelling in self.offset_cursors:
            # A write cursor is the byte offset of row 47, because a write through a TextCursor would never reach Raven's buffer.
            return f"var {name}: Int32 = {self.cursor_offset(init[0]) if init else '0'}"
        if t.get_canonical().kind == TypeKind.POINTER:
            record = self.types.record_name(t.get_canonical().get_pointee())
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
        swift = self.types.scalar(t, TARGET)
        if swift is None:
            raise Hole(f"A local `{t.spelling} {var.spelling}` the table has no type for.")
        if var.storage_class == ci.StorageClass.STATIC and var.spelling in self.written and not self.written_first(var):
            raise Hole(f"A static local `{var.spelling}` a statement reads before it writes, storage that outlives the call.")
        if init:
            return f"{keyword} {name}: {swift} = {self.converted(init[0], swift)}"
        if self.has_scratch or var.spelling in self.addressed:
            # Swift refuses a closure capture or an inout pass of a local with no value, where C reads whatever the stack held,
            # so the local starts at zero. The zero is the divergence rule 19 allows.
            return f"{keyword} {name}: {swift} = {'false' if swift == 'Bool' else '0'}"
        return f"{keyword} {name}: {swift}"

    def view_bytes(self, cur: ci.Cursor) -> bool:
        """True for Raven's `(byte *)vehWeapon`, the cast that walks one record's bytes through a view the port holds."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.CSTYLE_CAST_EXPR:
            return False
        kids = [k for k in inner.get_children() if k.kind.is_expression()]
        return bool(kids) and self.view_operand(kids[-1])

    def written_first(self, var: ci.Cursor) -> bool:
        """True when the first reference to the local in the body's order is a store into it, Raven's scratch static that every path writes before it reads.
        The store is the left side of an assignment, or an address or a written macro position, `VectorCopy(x, v)`."""
        body = self.fn.cur
        for node in body.walk_preorder():
            kids = list(node.get_children())
            if node.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2 \
                    and self.unwrap(kids[0]).kind == CursorKind.DECL_REF_EXPR and self.unwrap(kids[0]).spelling == var.spelling:
                # The operator scan fails inside a macro expansion, and that site is then no proof of a store.
                try:
                    return self.binary_op(node) == "="
                except Hole:
                    return False
            if node.kind == CursorKind.CALL_EXPR and kids and self.strip(kids[0]).spelling in MACROS:
                for i, arg in enumerate(kids[1:]):
                    inner = self.unwrap(arg)
                    if inner.kind == CursorKind.DECL_REF_EXPR and inner.spelling == var.spelling:
                        return i in written_arguments(self.strip(kids[0]).spelling)
            if node.kind == CursorKind.DECL_REF_EXPR and node.spelling == var.spelling and node.referenced is not None and node.referenced.kind == CursorKind.VAR_DECL:
                return False
        return False

    def narrow_local_names(self, fn: ci.Cursor) -> dict[str, str]:
        """Raven's scalar locals of a type narrower than int, by his name, with the Swift storage of each, `Int16` for a `short`.
        A local is the one place C's truncation is a stored value and not a widened read, so the local keeps the narrow storage."""
        out: dict[str, str] = {}
        for c in fn.walk_preorder():
            if c.kind != CursorKind.VAR_DECL:
                continue
            narrow = self.types.narrow(c.type)
            if narrow is not None and c.type.get_canonical().kind != TypeKind.CONSTANTARRAY:
                out[c.spelling] = narrow
        return out

    def array_declaration(self, var: ci.Cursor, init: list[ci.Cursor]) -> str:
        """A local array of scalars, `static int movementOffsets[8] = { ... }`, as a Swift array. A static array nothing writes is
        a constant table, the same value on every call, and a static array a statement writes is storage that outlives the call."""
        name = swift_name(var.spelling)
        t = var.type.get_canonical()
        element = self.types.scalar(t.element_type, TARGET)
        if element is None:
            raise Hole(f"A local `{var.type.spelling} {var.spelling}` the table has no type for.")
        if self.types.narrow(t.element_type) is not None:
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
