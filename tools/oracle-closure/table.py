#!/usr/bin/env python3
"""table.py: the C-to-Swift table of abi-stubs.md row 2, shared by traps.py and skeleton.py.

A parameter or a return maps by its C shape to the Swift type in the signature and the way it crosses the seam.
The table composes the view generator for the scalar, enum, and view names, so one spelling serves every generator.
"""

from __future__ import annotations

import re
from pathlib import Path

import clang.cindex as ci
from clang.cindex import TypeKind

from clang.cindex import CursorKind

from reexport import SCALARS
from rulings import PARAMS, RETURNS, TYPES
from views import Generator

TARGET = "CJKAMP_Game"
BUILTINS = set(SCALARS.values()) | {"Bool", "Float", "Int32"}
INT_KINDS = {TypeKind.INT, TypeKind.UINT, TypeKind.LONG, TypeKind.ULONG, TypeKind.SHORT, TypeKind.USHORT}
# The vector typedefs JKAShared spells as SIMD types, so a parameter of one is the vector itself, never a pointer.
VECTORS = {"vec3_t", "vec4_t"}
# An int beside a char * is its size only when Raven named it so. trap_BotSetChatName's `client` is not a size.
SIZE_NAME = re.compile(r"size|len|max", re.I)
# A Raven parameter name that is a Swift keyword is written in backticks.
KEYWORDS = {"extension", "in", "func", "class", "struct", "enum", "protocol", "default", "operator", "repeat", "where",
            "import", "self", "init", "var", "let", "return", "case", "switch", "if", "else", "for", "while", "do", "is", "as",
            "true", "false", "nil", "super", "throws", "try", "catch", "inout", "static", "public", "private", "internal"}


def swift_name(name: str) -> str:
    return f"`{name}`" if name in KEYWORDS else name


class Param:
    """One parameter as the table maps it. `kind` picks the emission, `swift` is the type in the signature."""

    def __init__(self, name: str, swift: str | None, kind: str, size: str | None = None) -> None:
        self.name = swift_name(name)
        self.swift = swift
        self.kind = kind
        self.size = size

    def word(self) -> str:
        if self.kind == "out_string":
            return f"{self.name.strip('`')}Pointer.baseAddress!"
        if self.kind == "vec3_array":
            return f"{self.name.strip('`')}Flat.baseAddress!"
        if self.kind == "slots":
            return f"{self.name}.base"
        return self.name


def fence(block: list[str]) -> list[str]:
    """Raven's block as a documentation comment with his text in a code fence, so markdown shows it line for line and touches nothing."""
    if len(block) == 1:
        text = block[0]
        return ["/**", "```", text[text.index("/*") + 2 : text.rindex("*/")].strip(), "```", "*/"]
    first = block[0].replace("/*", "/**", 1)
    body = [first[3:].strip()] if first.strip() != "/**" else []
    body += block[1:-1]
    last = block[-1]
    if last.strip() != "*/":
        body.append(last[: last.rindex("*/")].rstrip())
    while body and not body[0].strip():
        body.pop(0)
    while body and not body[-1].strip():
        body.pop()
    return ["/**", "```"] + body + ["```", "*/"]


class SourceFile:
    """One oracle .c file, read once, for the text a cursor's extent names and Raven's comment above a function."""

    def __init__(self, path) -> None:
        self.lines = path.read_text().splitlines()


    def slice(self, extent: ci.SourceRange) -> str:
        start, end = extent.start, extent.end
        if start.line == end.line:
            return self.lines[start.line - 1][start.column - 1:end.column - 1]
        parts = [self.lines[start.line - 1][start.column - 1:]]
        parts += self.lines[start.line:end.line - 1]
        parts.append(self.lines[end.line - 1][:end.column - 1])
        return "\n".join(parts)

    def comment_above(self, cur: ci.Cursor) -> list[str]:
        """Raven's comment lines directly above the function, verbatim, a block as /** */ and line comments as they are."""
        i = cur.extent.start.line - 2
        out: list[str] = []
        while i >= 0:
            line = self.lines[i].rstrip()
            stripped = line.strip()
            if not stripped:
                break
            if stripped.startswith("//"):
                out.insert(0, line)
                i -= 1
                continue
            if stripped.endswith("*/"):
                block = [line]
                while "/*" not in self.lines[i]:
                    i -= 1
                    block.insert(0, self.lines[i].rstrip())
                out = fence(block) + out
                i -= 1
                continue
            break
        return out

    def c_signature(self, cur: ci.Cursor) -> str:
        text = self.slice(cur.extent)
        return " ".join(text[:text.index("{")].split())


class Table:
    def __init__(self) -> None:
        self.views = Generator(None)


    def marker_reason(self, cur: ci.Cursor, owner: str | None = None) -> str:
        """The marker line for a parameter the table cannot shape: a PARAMS hold names its kind and the ruling it waits on,
        and any other parameter has no row yet."""
        spelled = f"`{' '.join(cur.type.spelling.split())} {cur.spelling}`"
        ruled = PARAMS.get((owner, cur.spelling))
        if isinstance(ruled, tuple):
            ruled = ruled[0]
        if ruled is not None:
            return f"Held by PARAMS as `{ruled}`, {spelled}, until a ruling gives the kind a shape."
        return f"No table row for {spelled}."

    def param(self, cur: ci.Cursor, following: ci.Cursor | None, traps: bool = True, owner: str | None = None) -> Param | None:
        """The table row of one parameter. A `char *` out-buffer is a returned String only in a trap, where the engine fills it."""
        name = cur.spelling
        t = cur.type
        canonical = t.get_canonical()
        ruled = PARAMS.get((owner, name))
        capacity = None
        if isinstance(ruled, tuple):
            ruled, capacity = ruled
        if ruled == "raw":
            return Param(name, "UnsafeMutableRawPointer", "bare")
        if ruled == "vec3_mut":
            return Param(name, "inout JKAShared.vec3_t", "vec3_mut")
        if ruled == "float_array":
            return Param(name, "inout [Float]", "bare")
        if t.spelling.replace("const ", "") in TYPES:
            return Param(name, TYPES[t.spelling.replace("const ", "")], "bare")
        # A vector parameter is the array type itself, and Clang keeps the typedef name on the parameter.
        if t.spelling.split()[-1] in VECTORS:
            if "const" in t.spelling:
                return Param(name, f"JKAShared.{t.spelling.split()[-1]}", "vec3_const")
            return Param(name, f"inout JKAShared.{t.spelling.split()[-1]}", "vec3_mut")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if t.get_pointee().spelling in VECTORS:
                if traps:
                    # An array of vectors the engine reads, with a count beside it. The trap packs it flat, see traps.py.
                    return Param(name, f"[JKAShared.{t.get_pointee().spelling}]", "vec3_array")
                # A pointer to one vector the caller owns, which Raven writes as `(*c)[i]`.
                return Param(name, f"inout JKAShared.{t.get_pointee().spelling}", "vec3_mut")
            if pointee.is_const_qualified() and pointee.kind in INT_KINDS | {TypeKind.FLOAT}:
                # Raven takes the address of a const scalar to reinterpret its bytes, so the scalar crosses by value.
                swift = self.views.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Param(name, swift, "bare")
            inner = pointee.get_canonical()
            if inner.kind == TypeKind.FUNCTIONPROTO:
                return None if traps else self.closure(cur, name)
            if "vec3_t" in t.spelling:
                # `vec3_t name[3]` is an axis, the type the ported q_math axis functions take.
                return None if traps else Param(name, "inout [JKAShared.vec3_t]", "vec3_axis")
            if inner.kind == TypeKind.CHAR_S:
                if pointee.is_const_qualified():
                    if PARAMS.get((owner, name)) == "text_cursor":
                        # A cursor Raven passes by value and returns advanced, the SkipWhitespace shape.
                        return Param(name, "JKAShared.TextCursor", "text_cursor")
                    return Param(name, "String", "cstring")
                if traps and following is not None and following.type.get_canonical().kind in INT_KINDS and SIZE_NAME.search(following.spelling):
                    return Param(name, None, "out_string", size=following.spelling)
                if traps and ruled == "fill_buffer":
                    # A buffer the engine fills with no size beside it takes the capacity Raven's callers declare, and the trap returns the String.
                    return Param(name, None, "out_string", size=capacity)
                if traps:
                    # A `char *` Raven wrote without `const` into a trap is an input the engine reads, a String like `const char *`.
                    return Param(name, "String", "cstring")
                # A body reads and rewrites the caller's buffer in place, so the caller's CharBuf crosses with `&`.
                return Param(name, "inout JKAShared.CharBuf", "inout_charbuf")
            record = self.views.record_name(pointee)
            if record and record in self.views.views:
                if ruled == "table":
                    # Raven indexes the table through the pointer, so the Slots over it crosses, and its base is the word.
                    return Param(name, f"Slots<{self.views.qualified_view(record, TARGET)}>", "slots")
                if owner == "BG_ParseField":
                    return Param(name, f"Slots<{self.views.qualified_view(record, TARGET)}>", "bare")
                return Param(name, self.views.qualified_view(record, TARGET), "view")
            if inner.kind == TypeKind.VOID:
                return Param(name, "OpaquePointer?", "bare")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.VOID:
                # The address of a `void *` the engine fills or clears, one word up from the handle it holds.
                return Param(name, "inout OpaquePointer?", "out_opaque")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                # A `const char **` is Raven's cursor into a text buffer, which the COM_Parse family advances. A parameter the
                # function sets to the token instead has a PARAMS entry, and a non-const `char **` takes that entry the same way.
                if PARAMS.get((owner, name)) == "out_string":
                    return Param(name, "inout String", "out_string_ref")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S and inner.get_pointee().is_const_qualified():
                return None if traps else Param(name, "inout JKAShared.TextCursor", "text_cursor")
            if inner.kind == TypeKind.POINTER and not pointee.is_const_qualified():
                # The address of a struct pointer the body sets, an out-param, `inout View?`. A pointer table into a trap has a PARAMS entry.
                record = self.views.record_name(inner.get_pointee())
                if ruled == "pointer_table" and record and record in self.views.views:
                    # The table's base crosses to the engine, and the body holds the Slots over the C storage.
                    return Param(name, f"Slots<{self.views.qualified_view(record, TARGET)}?>", "slots")
                if record and record in self.views.views and not traps:
                    return Param(name, f"inout {self.views.qualified_view(record, TARGET)}?", "out_view")
            # An array of model handles the engine reads, and every caller passes NULL. The pointer stays in generated code.
            if t.get_pointee().spelling.replace("const ", "") == "qhandle_t":
                return Param(name, "UnsafeMutablePointer<Int32>?", "bare")
            # A pointer to one scalar is an out-param, `inout`. A body that finds Raven walks it as an array writes a Port-note.
            if not pointee.is_const_qualified() and (inner.kind in INT_KINDS or inner.kind in (TypeKind.FLOAT, TypeKind.ENUM)):
                swift = self.views.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Param(name, f"inout {swift}", "out_scalar")
            return None
        if canonical.kind == TypeKind.CONSTANTARRAY and "vec3_t" in t.spelling:
            # `vec3_t name[3]` is an axis, the type the ported q_math axis functions take.
            return None if traps else Param(name, "inout [JKAShared.vec3_t]", "vec3_axis")
        if canonical.kind in (TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY) and not traps:
            # A C array of struct pointers the function fills, `gentity_t *ent_list[MAX_GENTITIES]`, is the caller's array of optional views.
            element = canonical.element_type.get_canonical()
            if element.kind == TypeKind.POINTER:
                record = self.views.record_name(element.get_pointee())
                if record and record in self.views.views:
                    return Param(name, f"inout [{self.views.qualified_view(record, TARGET)}?]", "view_array")
                if element.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                    # A C array of strings the function fills from a caller's `&array[i]`, `char *infos[]`, is the caller's slice from `i` on.
                    return Param(name, "inout ArraySlice<String>", "string_slice")
            if canonical.kind == TypeKind.CONSTANTARRAY and (element.kind in INT_KINDS or element.kind == TypeKind.FLOAT):
                # A fixed C array of a scalar the body reads, `int delta_angles[3]`, is the values by value, copied at the call.
                # A body that writes through it would take `inout`, and none does.
                swift = self.views.scalar(canonical.element_type, TARGET)
                if swift is not None and self.known(swift):
                    return Param(name, f"[{swift}]", "bare")
        if canonical.kind in (TypeKind.RECORD, TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY):
            return None
        swift = self.views.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        # A C enum is an Int32 alias, so it travels as a bare word.
        return Param(name, swift, "bare")

    def closure(self, cur: ci.Cursor, name: str) -> Param | None:
        """A function-pointer parameter as an optional Swift closure, each prototype parameter through the same rows."""
        protos = [c for c in cur.get_children() if c.kind == CursorKind.PARM_DECL]
        types: list[str] = []
        for i, p in enumerate(protos):
            following = protos[i + 1] if i + 1 < len(protos) else None
            m = self.param(p, following, traps=False)
            if m is None or m.swift is None:
                return None
            types.append(m.swift)
        result = self.result_type(cur.type.get_canonical().get_pointee().get_result())
        if result is None:
            return None
        returns = result[0] or "Void"
        return Param(name, f"(({', '.join(types)}) -> {returns})?", "bare")

    def known(self, swift: str) -> bool:
        """A Swift spelling the logic target can see: a builtin, or a name a view target re-exports. An enum a .c file defines is neither."""
        return swift in BUILTINS or swift.split(".")[-1] in self.views.declared

    def result(self, cur: ci.Cursor) -> tuple[str | None, str] | None:
        """The Swift return type and the expression that maps the word into it, or None for an unmappable return."""
        ruled = RETURNS.get(cur.spelling)
        if ruled == "text_cursor":
            # A pointer into the caller's text, returned as the cursor it is.
            return ("JKAShared.TextCursor", "")
        if ruled == "raw":
            return ("UnsafeMutableRawPointer", "")
        if ruled == "pooled_string":
            return ("PooledString", "")
        if ruled == "optional_string":
            return ("String?", "UnsafeMutableRawPointer(bitPattern: word).map { cString(at: $0) }")
        if ruled == "in_place":
            # Raven returns the argument it rewrote in place, which the caller already holds.
            return (None, "")
        if ruled == "text_offset":
            return ("Int32?", "")
        if ruled == "text_offset_nonnull":
            return ("Int32", "")
        if ruled == "vec3":
            return ("JKAShared.vec3_t", "")
        return self.result_type(cur.result_type)

    def result_type(self, t: ci.Type) -> tuple[str | None, str] | None:
        canonical = t.get_canonical()
        if t.spelling in TYPES:
            return (TYPES[t.spelling], f"{TYPES[t.spelling]}(word)")
        if canonical.kind == TypeKind.VOID:
            return (None, "")
        if canonical.kind == TypeKind.FLOAT:
            return ("Float", "Float(bitPattern: UInt32(truncatingIfNeeded: word))")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if pointee.get_canonical().kind == TypeKind.FUNCTIONPROTO:
                # A returned function pointer goes into a view's stored function, so it is that field's callback type, optional.
                alias = self.views.callback_alias(pointee.get_canonical(), TARGET)
                return (f"{alias}?", "") if alias else None
            if pointee.get_canonical().kind == TypeKind.CHAR_S:
                # Text the caller reads and nothing else, so it crosses as a String. A function that returns NULL, rewrites its
                # argument in place, or returns a pointer into its argument has a RETURNS entry instead.
                return ("String", "cString(at: UnsafeMutableRawPointer(bitPattern: word)!)")
            # Raven returns NULL for no entity, so a returned view is optional.
            record = self.views.record_name(pointee)
            if record and record in self.views.views:
                view = self.views.qualified_view(record, TARGET)
                return (f"{view}?", f"OpaquePointer(bitPattern: word).map {{ {view}(handle: $0) }}")
            return None
        swift = self.views.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        if swift == "Bool":
            return ("Bool", "word != 0")
        return (swift, f"{swift}(truncatingIfNeeded: word)")
