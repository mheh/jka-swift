"""draft_declarations.py: the declarations of the drafter, the locals of a body and the copies of its parameters.
It writes the `var` and `let` lines at the top of the body, the array and vector initializers, and the mutable copy of every parameter Raven assigns.
A local that stands for a record Swift holds by value opens a scratch closure, and the rules of that closure live here."""

from __future__ import annotations

import re

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

from overlay import MACROS, written_arguments
from rulings import BYTE_STORAGE_VARS

import closure as C
from skeleton import BG, target_of
from table import TARGET, swift_name

from draft_classification import Hole, blank, roled
from layout import INDENT, port_note


def extent_key(cur: ci.Cursor) -> tuple[str, int, int]:
    """One node's identity across two walks of the parse, which hand back new cursor objects."""
    return cur.kind.name, cur.extent.start.offset, cur.extent.end.offset


class Declarations:
    """The declaration half of the drafter."""

    def param_copy_lines(self, depth: int) -> list[str]:
        """The mutable copy of each parameter Raven assigns, at the head of the function's own block.
        A deeper block gives no seat, because a copy there hides the parameter from the statements outside it."""
        if depth != 1 or not (self.param_copies or self.param_walk_heads or self.buffer_cursor_heads):
            return []
        out: list[str] = []
        for index in self.buffer_cursor_heads:
            out.append(f"{INDENT}var {index}: Int32 = 0")
        self.buffer_cursor_heads = []
        for raven in self.param_walk_heads:
            table, index = self.table_cursors[raven]
            out.append(f"{INDENT}// Raven walks his own `{raven}` parameter over `{table}`, so the body walks the index of its slot, as for a walked local.")
            out.append(f"{INDENT}var {index}: Int32 = 0")
        self.param_walk_heads = []
        for name in self.param_copies:
            if name in self.cursor_params:
                out.append(f"{INDENT}// Raven steps his own `{name}` parameter through its bytes, so the body walks a TextCursor over a copy of them.")
                out.append(f"{INDENT}var {name} = JKAShared.TextCursor(JKAShared.CharBuf({name}))")
                continue
            out.append(f"{INDENT}// Raven assigns his own `{name}` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.")
            out.append(f"{INDENT}var {name} = {name}")
        self.param_copies = []
        return roled(out, "copy")

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
        out = roled(out, "frame")
        self.scratch_modes.append(mode)
        try:
            body = self.statements(rest, decl.extent.end.line, last_line, depth + 1)
        finally:
            self.scratch_modes.pop()
        while body and blank(body[-1]):
            body.pop()
        out += body
        tail: list[str] = []
        if mode == "flag":
            tail.append(f"{INDENT * (depth + 1)}return false")
        elif mode == "value":
            tail.append(f"{INDENT * (depth + 1)}return nil")
        tail.append(f"{pad}}}")
        if mode == "flag":
            # Inside an enclosing flag closure, Raven's return from the function is that closure's true, at every depth.
            leave = "return true" if self.scratch_modes and self.scratch_modes[-1] == "flag" else "return"
            tail += [f"{pad}if {result} {{", f"{INDENT * (depth + 1)}{leave}", f"{pad}}}"]
        elif mode == "value":
            tail += [f"{pad}if let {result} {{", f"{INDENT * (depth + 1)}return {result}", f"{pad}}}"]
        return out + roled(tail, "frame")

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
        return roled(out, "hoist")

    def declarations(self, cur: ci.Cursor) -> list[str]:
        out: list[str] = []
        for var in cur.get_children():
            if var.kind != CursorKind.VAR_DECL:
                raise Hole(f"A {var.kind.name} inside a declaration.")
            try:
                line = self.declaration(var)
                if line:
                    # A declaration that keeps Raven's call on the page beside it gives two lines.
                    out += line.split("\n")
            except Hole as hole:
                self.holes += 1
                self.hole_names.add(var.spelling)
                self.local_holes.add(var.spelling)
                raven = " ".join(self.bytes[var.extent.start.offset:var.extent.end.offset].decode("utf-8", "replace").split())
                out += roled([port_note(str(hole))], "note") + roled([f"// Raven wrote: {raven};"], "raven") \
                    + roled([f'portMissing("{self.fn.name}", source: "{self.fn.cite}")'], "marker")
        return out

    def declaration(self, var: ci.Cursor) -> str:
        if var.spelling in self.chosen_locals:
            # The local only names one of the file-scope variables, and the nested function's inout parameter is that name.
            return ""
        storage = self.static_storage(var)
        if storage is not None:
            raise Hole(storage)
        name = swift_name(var.spelling)
        t = var.type
        init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
        keyword = self.keyword(var, bool(init))
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t):
            if not init:
                return f"var {name} = vec3_t()"
            return f"var {name} = {self.vector_literal(init[0])}"
        if t.get_canonical().kind == TypeKind.CONSTANTARRAY and self.views.is_vec4(t):
            # Raven's `vec4_t color` is one vector of four floats, and his element stores `color[1] = 0.4` keep their form.
            if not init:
                return f"var {name} = vec4_t()"
            return f"var {name} = {self.vector_literal(init[0], 4)}"
        # A typedef of an array, `vec2_t` or `G2Trace_t`, has no element type until the canonical type, and a plain array keeps its element's typedef name.
        canonical = t.get_canonical()
        if canonical.kind == TypeKind.CONSTANTARRAY and self.views.is_vec3(t.element_type if t.kind == TypeKind.CONSTANTARRAY else canonical.element_type):
            # `vec3_t axis[3]` is an array of vectors, each at zero.
            count = t.get_canonical().element_count
            if init:
                raise Hole("An array of vectors with an initializer.")
            return f"var {name} = [vec3_t](repeating: vec3_t(), count: {count})"
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
        if var.spelling in self.charbuf_allocs:
            # Raven's `char *buf = (char *)B_TempAlloc(1024)` is a CharBuf of the size he asks for.
            # The call stays on the page with its result dropped, so the pool keeps his count for the free that follows.
            declared = f"var {name} = JKAShared.CharBuf({self.expr(self.charbuf_allocs[var.spelling])})"
            if init and self.is_null(init[0]):
                # Raven's NULL initializer is no allocation, and no read reaches it before the allocator store, so it drops under one comment.
                null = " ".join(self.bytes[init[0].extent.start.offset:init[0].extent.end.offset].decode("utf-8", "replace").split())
                size = self.charbuf_allocs[var.spelling].extent
                alloc = next(c for c in self.fn.cur.walk_preorder() if c.kind == CursorKind.CALL_EXPR
                             and any(a.extent == size for a in list(c.get_children())[1:]))
                comment = f"// Raven wrote `{var.spelling} = {null}` before the `{self.callee_name(alloc)}` store, so the store is the first value."
                return declared + "\n" + roled([comment], "comment")[0]
            return declared + (f"\n_ = {self.expr(self.uncast(init[0]))}{self.trailing(var)}" if init else "")
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
                if self.entity_slot(source) is not None and not self.sk.table.names_pm(self.fn.cur):
                    # The body never names `pm`, so no Pmove stands behind it, and the local is the number Raven indexed.
                    # Every read through the local takes that number, and the local drops.
                    parents, refs = self.slot_refs(var)
                    if any(self.slot_parent(parents, ref)[0] is None or self.slot_parent(parents, ref)[0].kind != CursorKind.MEMBER_REF_EXPR
                           for ref in refs):
                        raise Hole("Outside a pm function, Raven uses an entity of `g_entities` as a whole, and the channel reads it only by field.")
                    return ""
                self.game_entities.add(var.spelling)
                return f"{keyword} {name}: JKAMP.BgEntity = {self.game_entity(init[0])}"
            if record and record in self.views.views:
                self.reachable(record)
                view = self.views.qualified_view(record, TARGET)
                if init and self.byte_storage_cast(init[0]):
                    # Raven's `T *sharedMem = (T *)gSharedBuffer` reads a view at the base of a byte allocation the storage class owns.
                    return f"{keyword} {name} = {view}(handle: OpaquePointer({self.uncast(init[0]).spelling}))"
                if var.spelling in self.slots_locals:
                    # Every store into the local holds a table of records, so the local is the Slots over it.
                    if init:
                        return f"{keyword} {name}: Slots<{view}> = {self.slots_expression(init[0])}"
                    return f"var {name}: Slots<{view}>"
                if init and record in ("gentity_t", "gclient_t") and self.plain_entity(var, init[0]):
                    # Every store is the address of a table slot, and no statement stores or tests NULL, so the local is never nil.
                    self.plain_entities.add(var.spelling)
                    return f"{keyword} {name} = {self.expr(init[0])}"
                if not init and record in ("gentity_t", "gclient_t") and self.plain_entity(var, None):
                    place = self.slot_store_place(var)
                    if place == "closure":
                        # Raven stores and reads the local only inside one loop body, which the port wraps in a scratch closure,
                        # so the local is a `let` at its store there, and this declaration drops.
                        self.plain_entities.add(var.spelling)
                        self.store_lets.add(var.spelling)
                        return ""
                    if place is not None:
                        # Every store is a slot address, and the first comes before every read in straight-line code, so the local is plain.
                        self.plain_entities.add(var.spelling)
                        return f"{place} {name}: {view}"
                if init:
                    return f"{keyword} {name}: {view}? = {self.expr(init[0])}"
                return f"var {name}: {view}?"
            raise Hole(f"A pointer local `{t.spelling} {var.spelling}` with no view.")
        swift = self.types.scalar(t, TARGET)
        if swift is None:
            raise Hole(f"A local `{t.spelling} {var.spelling}` the table has no type for.")
        if init and swift in ("CChar", "Int8", "UInt8", "Int16", "UInt16") and self.wider_parameter(init[0], t):
            # Raven's `char cc = c` from an int parameter truncates at the store, as C does.
            return f"{keyword} {name}: {swift} = {swift}(truncatingIfNeeded: {self.expr(init[0])})"
        if init:
            return f"{keyword} {name}: {swift} = {self.converted(init[0], swift)}"
        if self.has_scratch or var.spelling in self.addressed:
            # Swift refuses a closure capture or an inout pass of a local with no value, where C reads whatever the stack held,
            # so the local starts at zero. The zero is the divergence rule 19 allows.
            return f"{keyword} {name}: {swift} = {'false' if swift == 'Bool' else '0'}"
        return f"{keyword} {name}: {swift}"

    def slot_address(self, cur: ci.Cursor) -> bool:
        """True for Raven's `&g_entities[n]`, the address of one slot of a file-scope table of records,
        and for `&level.clients[i]`, one slot of the records a pointer field holds, which the view reads through its `<name>Slots` accessor."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.UNARY_OPERATOR or self.operator_or_none_unary(inner) != "&":
            return False
        operand = self.unwrap(self.unary_parts(inner)[2])
        if operand.kind != CursorKind.ARRAY_SUBSCRIPT_EXPR:
            return False
        base = self.strip(list(operand.get_children())[0])
        if self.slots_member(base) is not None:
            return True
        ref = base.referenced if base.kind == CursorKind.DECL_REF_EXPR else None
        return ref is not None and ref.kind == CursorKind.VAR_DECL and ref.semantic_parent is not None \
            and ref.semantic_parent.kind == CursorKind.TRANSLATION_UNIT and ref.type.get_canonical().kind == TypeKind.CONSTANTARRAY

    def slot_refs(self, var: ci.Cursor) -> tuple[dict[ci.Cursor, ci.Cursor], list[ci.Cursor]]:
        """The parent of every node of the function, keyed by the cursor, and every reference to the local, in the body's order."""
        parents: dict[ci.Cursor, ci.Cursor] = {}
        refs: list[ci.Cursor] = []
        for node in self.fn.cur.walk_preorder():
            for kid in node.get_children():
                parents[kid] = node
            if node.kind == CursorKind.DECL_REF_EXPR and node.referenced is not None and node.referenced == var:
                refs.append(node)
        return parents, refs

    def slot_parent(self, parents: dict[ci.Cursor, ci.Cursor], cur: ci.Cursor) -> tuple[ci.Cursor | None, ci.Cursor]:
        """The first parent of a node that is not a cast or a parenthesis, and the child under it."""
        child = cur
        up = parents.get(cur)
        while up is not None and up.kind in (CursorKind.UNEXPOSED_EXPR, CursorKind.PAREN_EXPR):
            child = up
            up = parents.get(up)
        return up, child

    def slot_store_place(self, var: ci.Cursor) -> str | None:
        """The keyword of a slot-address local with no initializer, by ruling V35 and W14, or None when the local stays optional.

        `let` or `var` is a local of the body's straight-line code whose first store comes before every read, `let` for one store and `var` for more.
        `closure` is a local with one store and every read inside one loop body that the port wraps in a scratch closure, with the store first."""
        parents, refs = self.slot_refs(var)
        stores: list[ci.Cursor] = []
        reads: list[ci.Cursor] = []
        for ref in refs:
            up, child = self.slot_parent(parents, ref)
            if up is not None and up.kind == CursorKind.BINARY_OPERATOR and self.operator_or_none(up) == "=" \
                    and list(up.get_children())[0].extent.start.offset == child.extent.start.offset:
                stores.append(up)
            else:
                reads.append(ref)
        if not stores:
            return None
        for store in stores:
            try:
                self.expr(list(store.get_children())[1])
            except Hole:
                # A store the draft cannot write leaves the local unset before the reads, so the local stays optional.
                return None
        first = min(store.extent.start.offset for store in stores)
        first_end = min(stores, key=lambda store: store.extent.start.offset).extent.end.offset
        if any(read.extent.start.offset < first_end for read in reads):
            return None
        blocks = [parents.get(store) for store in stores]
        if any(block is None or block.kind != CursorKind.COMPOUND_STMT for block in blocks):
            return None
        body = [c for c in self.fn.cur.get_children() if c.kind == CursorKind.COMPOUND_STMT][-1]

        def opens_scratch(block: ci.Cursor, before: int) -> bool:
            return any(self.record_local(c) is not None and c.extent.start.offset < before for c in block.get_children())

        if all(block.extent.start.offset == body.extent.start.offset for block in blocks):
            # A scratch closure that opens before the first store would hold the store, and Swift refuses a store into a captured `let`.
            return None if opens_scratch(body, first) else ("let" if len(stores) == 1 else "var")
        block = blocks[0]
        loop = parents.get(block)
        if len(stores) != 1 or loop is None or loop.kind not in (CursorKind.FOR_STMT, CursorKind.WHILE_STMT, CursorKind.DO_STMT):
            return None
        if any(not (block.extent.start.offset <= ref.extent.start.offset < block.extent.end.offset) for ref in refs):
            return None
        return "closure" if opens_scratch(block, first) else None

    def plain_entity(self, var: ci.Cursor, init: ci.Cursor | None) -> bool:
        """True for a `gentity_t *` or `gclient_t *` local whose every store is a table slot address, with no NULL store and no NULL test.

        A read of the local is a member access, a call argument, a store into another name, or a compare with a non-NULL value.
        Any other read, `!ent`, `if (ent)`, `ent && ...`, or `&ent`, counts as a NULL test.
        A local with no initializer passes on its stores alone."""
        if init is not None and not self.slot_address(init):
            return False
        parents, refs = self.slot_refs(var)
        for ref in refs:
            up, child = self.slot_parent(parents, ref)
            if up is None:
                return False
            if up.kind in (CursorKind.MEMBER_REF_EXPR, CursorKind.CALL_EXPR, CursorKind.RETURN_STMT, CursorKind.VAR_DECL):
                continue
            if up.kind == CursorKind.BINARY_OPERATOR:
                left, right = list(up.get_children())
                op = self.operator_or_none(up)
                if op == "=" and self.unwrap(left).kind == CursorKind.DECL_REF_EXPR and self.unwrap(left).referenced == var:
                    if not self.slot_address(right):
                        return False
                    continue
                if op == "=":
                    continue
                if op in ("==", "!=") and not self.is_null(left) and not self.is_null(right):
                    continue
            return False
        return True

    def byte_storage_cast(self, cur: ci.Cursor) -> bool:
        """True for a cast of a file-scope byte allocation in BYTE_STORAGE_VARS, the `(T *)gSharedBuffer` of vmMain."""
        if self.unwrap(cur).kind != CursorKind.CSTYLE_CAST_EXPR:
            return False
        source = self.uncast(cur)
        return source.kind == CursorKind.DECL_REF_EXPR and source.spelling in BYTE_STORAGE_VARS

    def byte_storage_view(self, var: ci.Cursor) -> bool:
        """True for a local the draft declared as a view at the base of a BYTE_STORAGE_VARS allocation, which is never optional."""
        if var.kind != CursorKind.VAR_DECL or var.location.file is None or var.location.file.name != self.fn.cur.location.file.name:
            return False
        init = [c for c in var.get_children() if c.kind.is_expression() and b"=" in self.bytes[var.extent.start.offset:c.extent.start.offset]]
        return bool(init) and self.byte_storage_cast(init[0])

    def wider_parameter(self, cur: ci.Cursor, t: ci.Type) -> bool:
        """True for a parameter of a C integer type wider than the local's type `t`."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.DECL_REF_EXPR or inner.spelling not in self.params_by_name:
            return False
        have = inner.type.get_canonical()
        return have.kind in (TypeKind.INT, TypeKind.UINT, TypeKind.LONG, TypeKind.ULONG) and have.get_size() > t.get_canonical().get_size()

    def view_bytes(self, cur: ci.Cursor) -> bool:
        """True for Raven's `(byte *)vehWeapon`, the cast that walks one record's bytes through a view the port holds."""
        inner = self.unwrap(cur)
        if inner.kind != CursorKind.CSTYLE_CAST_EXPR:
            return False
        kids = [k for k in inner.get_children() if k.kind.is_expression()]
        return bool(kids) and self.view_operand(kids[-1])

    def static_storage(self, var: ci.Cursor) -> str | None:
        """The reason a static local is storage that outlives the call, or None for a local of the body.

        A static that a statement reads before one writes it keeps its value from the call before.
        A static the function returns hands the caller its storage.
        Either one is a hole until a storage rule names its home, and any other static is Raven's scratch habit."""
        if var.storage_class != ci.StorageClass.STATIC:
            return None
        if var.spelling in self.written and not self.written_first(var):
            return f"A static local `{var.spelling}` a statement reads before it writes, storage that outlives the call."
        for node in self.fn.cur.walk_preorder():
            if node.kind != CursorKind.RETURN_STMT:
                continue
            kids = [k for k in node.get_children() if k.kind.is_expression()]
            if kids and self.unwrap(kids[0]).kind == CursorKind.DECL_REF_EXPR and self.unwrap(kids[0]).referenced == var:
                return f"A static local `{var.spelling}` the function returns, storage that outlives the call."
        return None

    def written_first(self, var: ci.Cursor) -> bool:
        """True when the first reference to the local in the body's order is a store into it, Raven's scratch static that every path writes before it reads.
        The store is the left side of an assignment, an element of it there, `velPos[0] = x`, or a written macro position, `VectorCopy(x, v)`."""
        body = self.fn.cur
        for node in body.walk_preorder():
            kids = list(node.get_children())
            left = self.unwrap(kids[0]) if kids else None
            if left is not None and left.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
                left = self.unwrap(list(left.get_children())[0])
            if node.kind == CursorKind.BINARY_OPERATOR and len(kids) == 2 \
                    and left.kind == CursorKind.DECL_REF_EXPR and left.spelling == var.spelling:
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
            if node.kind == CursorKind.CALL_EXPR and kids and self.out_argument(node, var):
                # An address passed to an out parameter is a store, `G_SpawnInt("noBasicSounds", "0", &garbage)`.
                return True
            if node.kind == CursorKind.DECL_REF_EXPR and node.spelling == var.spelling and node.referenced is not None and node.referenced.kind == CursorKind.VAR_DECL:
                return False
        return False

    def out_argument(self, call: ci.Cursor, var: ci.Cursor) -> bool:
        """True when the call passes `&var` to a parameter the table maps as an out scalar, which the callee writes."""
        kids = list(call.get_children())
        callee = self.sk.by_name.get(self.strip(kids[0]).spelling)
        if callee is None or not callee.mapped:
            return False
        for i, arg in enumerate(kids[1:]):
            inner = self.unwrap(arg)
            if inner.kind != CursorKind.UNARY_OPERATOR or self.operator_or_none_unary(inner) != "&":
                continue
            target = self.unwrap(self.unary_parts(inner)[2])
            if target.kind == CursorKind.DECL_REF_EXPR and target.spelling == var.spelling:
                return i < len(callee.params) and callee.params[i].kind == "out_scalar"
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

    def narrow_array_names(self, fn: ci.Cursor) -> dict[str, str]:
        """Raven's local arrays of a type narrower than int, `byte m[4]`, by his name, with the Swift storage of each element.
        The array keeps the narrow element, so a store truncates as C's does and a read widens to Int32."""
        out: dict[str, str] = {}
        for c in fn.walk_preorder():
            if c.kind != CursorKind.VAR_DECL or c.type.get_canonical().kind != TypeKind.CONSTANTARRAY:
                continue
            narrow = self.types.narrow(c.type.get_canonical().element_type)
            if narrow is not None:
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
            # The array keeps Raven's narrow element, `[UInt8]` for `byte`, and each store truncates.
            element = self.types.narrow(t.element_type)
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
