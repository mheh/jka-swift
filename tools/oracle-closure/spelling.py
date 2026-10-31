#!/usr/bin/env python3
"""spelling.py: the one owner of the Swift type a C type has.

One question lives here: for this C type and this role, what is the Swift spelling, and which conversion crosses into it.
The five roles are the field of a view, the parameter of a function, its return, a local of a body, and an expression in a body.
`Types.answer` is the entry, `Facts` carries what a sweep or a ruling knows that the C type alone does not say, and `Answer` is the reply.
The scalar, the narrow storage, and the record name are the lookups under the roles, and every generator reads them from here.
The module is logic over a clang type. It reads the tables of reexport.py and rulings.py and holds none of its own beyond the shapes it decides.
"""

from __future__ import annotations

import re
from dataclasses import dataclass

import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind

import closure as C
from reexport import NARROW, SCALARS
from rulings import TYPES

TARGET = C.TARGETS["c_target"]
BUILTINS = set(SCALARS.values()) | {"Bool", "Float", "Int32"}
# The Swift storage of a C integer narrower than int, which a local keeps.
NARROW_STORAGE = {SCALARS[k] for k in NARROW}
INT_KINDS = {TypeKind.INT, TypeKind.UINT, TypeKind.LONG, TypeKind.ULONG, TypeKind.SHORT, TypeKind.USHORT}
# The vector typedefs JKAShared spells as SIMD types, so a parameter of one is the vector itself, never a pointer.
VECTORS = {"vec3_t", "vec4_t"}
# An int beside a char * is its size only when Raven named it so. trap_BotSetChatName's `client` is not a size.
SIZE_NAME = re.compile(r"size|len|max", re.I)
# The unsigned Swift spellings. A view widens a byte and a short to Int32, so those two read as signed arithmetic.
# `CUnsignedLong` is C's `unsigned long`, 64 bits on Darwin and Linux and 32 on Windows, so a view keeps the C width on every platform.
UNSIGNED = {"UInt", "CUnsignedLong", "UInt8", "UInt16", "UInt32", "UInt64"}
ROLES = ("field", "parameter", "return", "local", "expression")
# The head of the Swift spelling that stands over a table of records, the one place the word is written.
SLOTS = "Slots<"


@dataclass(frozen=True)
class Answer:
    """One answer of the type question.

    `swift` is the Swift spelling, and it is None where the role has no type, a void return or a parameter the emitter names itself.
    `kind` picks the emission, `crossing` is the conversion that crosses into the spelling, and `size` is the count a buffer takes beside it.
    """

    swift: str | None
    kind: str = "bare"
    crossing: str = ""
    size: str | None = None


def engine_array(t: ci.Type, following: ci.Cursor | None) -> bool:
    """True for a trap's `int *` with a count beside it, an array the engine fills, `trap_EntitiesInBox(mins, maxs, list, maxcount)`."""
    canonical = t.get_canonical()
    if canonical.kind != TypeKind.POINTER or canonical.get_pointee().is_const_qualified():
        return False
    return canonical.get_pointee().get_canonical().kind in INT_KINDS and following is not None \
        and following.type.get_canonical().kind in INT_KINDS and SIZE_NAME.search(following.spelling) is not None


@dataclass(frozen=True)
class Facts:
    """What the sweeps and the rulings know about one cursor, which its C type alone does not say.

    A caller fills the fields its role reads and leaves the rest at the default.
    """

    # The function that owns the parameter, the key a name rule joins on.
    owner: str | None = None
    # The kind a PARAMS row names for this parameter, with the capacity beside it when the row carries one.
    ruled: str | None = None
    capacity: str | None = None
    # True for a parameter of a trap, where the engine fills a buffer the caller hands over.
    traps: bool = True
    # The parameter after this one, which a `char *` reads as its size.
    following: ci.Cursor | None = None
    # The NULL sweep cleared the parameter for nil, the text sweep proved the body only reads the text,
    # the subscript sweep saw an index on it, and the store sweep saw a write through it.
    nullable: bool = False
    readonly_text: bool = False
    indexed: bool = False
    stores_through: bool = False
    # True when the store sweep walked the owner's body, so a parameter outside the written set is proven read-only.
    store_swept: bool = False
    # True when the NULL sweep, at a direct call or one hop on, reaches the parameter. The vector, axis, and out-scalar rules read this one.
    null_reaches: bool = False
    # True when the body tests the pointer for NULL with an arm that does more than skip a write through it.
    null_arm: bool = False
    # True when the body hands the `int *` on to an array a trap fills, so the parameter is that array too.
    fills_array: bool = False
    # The body already spells the expression as a Swift Bool, and the expression is a number Swift types by context.
    is_bool: bool = False
    is_literal: bool = False
    # Raven's digits of a literal expression, `1.0f` or `-500.0f`, which a store into an int reads for its value.
    literal_text: str | None = None
    # The expression is one name, so an unsigned value crosses into Int32 with its bits kept.
    named_leaf: bool = False
    # Swift holds the C `double` expression as a Float, because it is a C library call whose Foundation overload follows its float argument.
    float_valued: bool = False


NO_FACTS = Facts()
# Text the caller reads and nothing else, and the same text where the body hands NULL back at one site.
TEXT_RESULT = Answer("String", crossing="cString(at: UnsafeMutableRawPointer(bitPattern: word)!)")
OPTIONAL_TEXT_RESULT = Answer("String?", crossing="UnsafeMutableRawPointer(bitPattern: word).map { cString(at: $0) }")


class Types:
    """The type question over one parse and one view generator. It reads the parse the run already holds and parses nothing."""

    def __init__(self, parse: C.Parse, views) -> None:
        # The run's one parse, the source of every cursor an answer reads.
        self.parse = parse
        # The view generator, which holds the record set, the enum set, and the names each target re-exports.
        self.views = views

    def answer(self, role: str, t: ci.Type, facts: Facts = NO_FACTS, target: str = TARGET) -> Answer | None:
        """The Swift spelling of one C type in one role, with the conversion that crosses into it, or None when no row fits the shape."""
        if role == "parameter":
            return self.parameter(t, facts)
        if role == "return":
            return self.returned(t, target)
        if role == "field":
            return self.field(t, target)
        if role in ("local", "expression"):
            return self.value(t, facts)
        raise ValueError(f"spelling.py: {role} is no role of {ROLES}")

    # MARK: - The lookups

    def record_name(self, t: ci.Type) -> str | None:
        """The typedef name of a struct type, or its tag when Raven gave it no typedef, or None for a non-struct."""
        decl = t.get_canonical().get_declaration()
        if decl.kind != CursorKind.STRUCT_DECL:
            return None
        if t.kind == TypeKind.ELABORATED:
            t = t.get_named_type()
        if t.kind == TypeKind.TYPEDEF:
            # ui_shared.h names a struct through a second typedef, `typedef windowDef_t Window;`, and the view takes the first name.
            under = t.get_declaration().underlying_typedef_type
            if under.kind == TypeKind.ELABORATED:
                under = under.get_named_type()
            if under.kind == TypeKind.TYPEDEF:
                return self.record_name(under)
            return t.spelling
        return self.views.typedef_of.get(decl.spelling, decl.spelling)

    def scalar(self, t: ci.Type, target: str) -> str | None:
        """The Swift type of a scalar: the re-exported typealias, the enum alias, or the builtin."""
        if t.kind == TypeKind.ELABORATED:
            t = t.get_named_type()
        if t.kind == TypeKind.TYPEDEF:
            name = t.spelling
            if name == "qboolean":
                return "Bool"
            if name in self.views.enums or name in self.views.declared and self.views.declared[name] and name != "vec_t":
                return self.views.qualified(name, target)
            return self.scalar(t.get_declaration().underlying_typedef_type, target)
        if t.kind == TypeKind.ENUM:
            name = t.spelling.replace("enum ", "")
            return "Bool" if name == "qboolean" else self.views.qualified(name, target)
        return SCALARS.get(t.kind)

    def narrow(self, t: ci.Type) -> str | None:
        """The storage type of a C integer narrower than int, `Int16` for a `short`, or None for any other type."""
        canonical = t.get_canonical()
        return SCALARS[canonical.kind] if canonical.kind in NARROW else None

    def known(self, swift: str) -> bool:
        """A Swift spelling the logic target can see: a builtin, or a name a view target re-exports. An enum a .c file defines is neither."""
        return swift in BUILTINS or swift.split(".")[-1] in self.views.declared

    def storage(self, t: ci.Type, target: str) -> str:
        """The Swift spelling of a C element's storage, for a MemoryLayout stride, so a row stride is right on every triple."""
        canonical = t.get_canonical()
        if canonical.kind == TypeKind.POINTER:
            return "UnsafeRawPointer?"
        if canonical.kind == TypeKind.RECORD:
            return self.record_name(t) or canonical.spelling
        if canonical.kind == TypeKind.ENUM:
            return "Int32"
        return SCALARS.get(canonical.kind, "Int32") if self.scalar(t, target) != "Bool" else "UInt32"

    def number_kind(self, t: ci.Type) -> str | None:
        """`Float`, `Double`, or `Int32` for a C number, and None for every other type.
        Raven's `double` is a Swift `Double`, so C's arithmetic in double stays in double until a store narrows it."""
        kind = t.get_canonical().kind
        if kind == TypeKind.FLOAT:
            return "Float"
        if kind == TypeKind.DOUBLE:
            return "Double"
        if kind in INT_KINDS or kind in (TypeKind.ENUM, TypeKind.CHAR_S, TypeKind.SCHAR, TypeKind.UCHAR, TypeKind.CHAR_U):
            return "Int32"
        return None

    def unsigned(self, t: ci.Type, target: str = TARGET) -> str | None:
        """The unsigned Swift type of a C type, when the views spell it unsigned.
        A view widens a byte or a short to Int32, so a narrow unsigned reads as signed arithmetic, as C's promotion does."""
        swift = self.scalar(t, target)
        return swift if swift in UNSIGNED and swift not in ("UInt8", "UInt16") else None

    def is_pointer(self, t: ci.Type) -> bool:
        return t.get_canonical().kind == TypeKind.POINTER

    def is_slots(self, swift: str | None) -> bool:
        """True for a Swift spelling that stands over a table of records, which a body reads by index.
        The optional Slots of an unproven parameter answers True too, because the table behind it is the same table."""
        return (swift or "").startswith(SLOTS)

    def is_char_array(self, t: ci.Type) -> bool:
        """True for Raven's `char name[N]`, the array Swift holds as a CharBuf."""
        canonical = t.get_canonical()
        return canonical.kind == TypeKind.CONSTANTARRAY and canonical.element_type.get_canonical().kind == TypeKind.CHAR_S

    # MARK: - The field role

    def field(self, t: ci.Type, target: str) -> Answer | None:
        """The Swift element type of one field, with the kind that names the Slots or the accessor the view writes over it."""
        canonical = t.get_canonical()
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if pointee.get_canonical().kind == TypeKind.CHAR_S:
                return Answer("String?", "strings")
            name = self.record_name(pointee)
            if name and name in self.views.views:
                return Answer(f"{self.views.qualified_view(name, target)}?", "pointers")
            return Answer("OpaquePointer?", "opaque")
        if canonical.kind == TypeKind.RECORD:
            name = self.record_name(t)
            if name and name in self.views.views:
                return Answer(self.views.qualified_view(name, target), "views")
            return None
        # A `vec3_t` element is one vector, so the test stands above the array arm, which sees only the canonical `float[3]`.
        if self.views.is_vec3(t):
            return Answer("JKAShared.vec3_t", "vectors")
        if canonical.kind == TypeKind.CONSTANTARRAY:
            inner = self.views.element_type(t)
            if inner.get_canonical().kind == TypeKind.CHAR_S:
                return Answer("String", "cstrings")
            if self.views.is_vec3(inner):
                return Answer("JKAShared.vec3_t", "vectors")
            # A row of the outer array, whose own element type the accessor asks for in turn.
            return Answer(None, "rows")
        swift = self.scalar(t, target)
        if swift is None:
            return None
        if swift == "Bool":
            return Answer("Bool", "flags")
        return Answer(swift, "scalars")

    # MARK: - The parameter role

    def parameter(self, t: ci.Type, facts: Facts) -> Answer | None:
        """The table row of one parameter. A `char *` out-buffer is a returned String only in a trap, where the engine fills it."""
        canonical = t.get_canonical()
        if facts.ruled == "raw":
            return Answer("UnsafeMutableRawPointer", "bare")
        if facts.ruled == "vec3_mut":
            return Answer("inout JKAShared.vec3_t", "vec3_mut")
        if facts.ruled == "float_array":
            return Answer("inout [Float]", "bare")
        if facts.ruled == "key_path":
            # Raven's field offset, `FOFS(classname)`, is the key path to the entity's text field, `\.classname`.
            return Answer(f"KeyPath<{self.views.qualified_view('gentity_t', TARGET)}, String?>", "bare")
        if facts.ruled == "int_value":
            # A qsort comparator reads its `const void *` as `*(int *)`, so the value crosses, and the hand qsort hands it over.
            return Answer("Int32", "bare")
        if facts.ruled == "out_opaque":
            # Raven declares `void *` and his callers pass the address of a handle field, the `void **` shape below.
            return Answer("inout OpaquePointer?", "out_opaque")
        if facts.ruled == "int_array":
            # The body only reads the values, and Raven's callers pass NULL with a count of zero, so the array crosses by value as an optional.
            return Answer("[Int32]?", "int_array")
        if t.spelling.replace("const ", "") in TYPES:
            return Answer(TYPES[t.spelling.replace("const ", "")], "bare")
        # A vector parameter is the array type itself, and Clang keeps the typedef name on the parameter.
        if t.spelling.split()[-1] in VECTORS:
            if facts.null_reaches and not facts.stores_through and not facts.traps:
                # A caller passes NULL and the body only reads, so the vector crosses as an optional value and the NULL test keeps its form.
                return Answer(f"JKAShared.{t.spelling.split()[-1]}?", "vec3_opt")
            if facts.null_reaches and facts.stores_through and facts.null_arm and not facts.traps and facts.ruled is None and "const" not in t.spelling:
                # A caller passes NULL, the body writes the vector, and a NULL arm does more than skip that write,
                # so the vector crosses as an optional inout, and the NULL test keeps its form.
                # The skeleton writes a forward with the plain inout vector beside the function, for the callers that pass one.
                return Answer(f"inout JKAShared.{t.spelling.split()[-1]}?", "vec3_mut_opt")
            if "const" in t.spelling:
                return Answer(f"JKAShared.{t.spelling.split()[-1]}", "vec3_const")
            if facts.store_swept and not facts.stores_through and not facts.traps:
                # The body never writes the vector, so it crosses by value as a const one does, and a caller passes a `let` vector as it is.
                return Answer(f"JKAShared.{t.spelling.split()[-1]}", "vec3_const")
            return Answer(f"inout JKAShared.{t.spelling.split()[-1]}", "vec3_mut")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if t.get_pointee().spelling in VECTORS:
                if facts.traps:
                    # An array of vectors the engine reads, with a count beside it. The trap packs it flat, see traps.py.
                    return Answer(f"[JKAShared.{t.get_pointee().spelling}]", "vec3_array")
                # A pointer to one vector the caller owns, which Raven writes as `(*c)[i]`.
                return Answer(f"inout JKAShared.{t.get_pointee().spelling}", "vec3_mut")
            if pointee.is_const_qualified() and pointee.kind in INT_KINDS | {TypeKind.FLOAT}:
                # Raven takes the address of a const scalar to reinterpret its bytes, so the scalar crosses by value.
                swift = self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(swift, "bare")
            inner = pointee.get_canonical()
            if inner.kind == TypeKind.FUNCTIONPROTO:
                # A function pointer, whose own parameters cross by these rows in turn. The caller shapes the closure.
                return None if facts.traps else Answer(None, "closure")
            if "vec3_t" in t.spelling:
                # `vec3_t name[3]` is an axis, the type the ported q_math axis functions take.
                if facts.traps:
                    return None
                if facts.null_reaches and not facts.stores_through:
                    return Answer("[JKAShared.vec3_t]?", "axis_opt")
                if facts.null_reaches and facts.stores_through and facts.null_arm:
                    # A written axis a caller skips with NULL is an optional inout, with the same forward as a written vector.
                    return Answer("inout [JKAShared.vec3_t]?", "axis_mut_opt")
                return Answer("inout [JKAShared.vec3_t]", "vec3_axis")
            if inner.kind == TypeKind.CHAR_S:
                if pointee.is_const_qualified():
                    if facts.ruled == "text_cursor":
                        # A cursor Raven passes by value and returns advanced, the SkipWhitespace shape.
                        return Answer("JKAShared.TextCursor", "text_cursor")
                    if facts.nullable:
                        return Answer("String?", "cstring_opt")
                    return Answer("String", "cstring")
                if facts.traps and facts.following is not None and facts.following.type.get_canonical().kind in INT_KINDS \
                        and SIZE_NAME.search(facts.following.spelling):
                    return Answer(None, "out_string", size=facts.following.spelling)
                if facts.traps and facts.ruled == "fill_buffer":
                    # A buffer the engine fills with no size beside it takes the capacity Raven's callers declare, and the trap returns the String.
                    return Answer(None, "out_string", size=facts.capacity)
                if facts.traps:
                    # A `char *` Raven wrote without `const` into a trap is an input the engine reads, a String like `const char *`.
                    return Answer("String", "cstring")
                if facts.ruled is None and facts.readonly_text:
                    # The body only reads the text, so the parameter is a String, the spelling a `const char *` already has.
                    # A PARAMS row names the kind itself, so it wins over the sweep.
                    # A NULL the sweep reaches at a call or one hop on makes it a String?, the way the vector rules read the same sets.
                    return Answer("String?" if facts.null_reaches else "String", "cstring_opt" if facts.null_reaches else "cstring")
                # A body reads and rewrites the caller's buffer in place, so the caller's CharBuf crosses with `&`.
                return Answer("inout JKAShared.CharBuf", "inout_charbuf")
            record = self.record_name(pointee)
            if record and record in self.views.views:
                if facts.ruled == "table":
                    # Raven indexes the table through the pointer, so the Slots over it crosses, and its base is the word.
                    return Answer(f"Slots<{self.views.qualified_view(record, TARGET)}>", "slots")
                if facts.indexed:
                    # Raven indexes the parameter, `animations[anim]`, so the Slots over the records crosses, and a one-record read spells `[0]`.
                    view = self.views.qualified_view(record, TARGET)
                    if facts.nullable:
                        return Answer(f"Slots<{view}>?", "slots_opt")
                    return Answer(f"Slots<{view}>", "slots")
                if facts.nullable:
                    return Answer(f"{self.views.qualified_view(record, TARGET)}?", "view_opt")
                return Answer(self.views.qualified_view(record, TARGET), "view")
            if inner.kind == TypeKind.VOID:
                return Answer("OpaquePointer?", "bare")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.VOID:
                # The address of a `void *` the engine fills or clears, one word up from the handle it holds.
                return Answer("inout OpaquePointer?", "out_opaque")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                # A `const char **` is Raven's cursor into a text buffer, which the COM_Parse family advances. A parameter the
                # function sets to the token instead has a PARAMS entry, and a non-const `char **` takes that entry the same way.
                if facts.ruled == "out_string":
                    return Answer("inout String", "out_string_ref")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S and inner.get_pointee().is_const_qualified():
                return None if facts.traps else Answer("inout JKAShared.TextCursor", "text_cursor")
            if inner.kind == TypeKind.POINTER and not pointee.is_const_qualified():
                # The address of a struct pointer the body sets, an out-param, `inout View?`. A pointer table into a trap has a PARAMS entry.
                record = self.record_name(inner.get_pointee())
                if facts.ruled == "pointer_table" and record and record in self.views.views:
                    # The table's base crosses to the engine, and the body holds the Slots over the C storage.
                    return Answer(f"Slots<{self.views.qualified_view(record, TARGET)}?>", "slots")
                if record and record in self.views.views and not facts.traps:
                    return Answer(f"inout {self.views.qualified_view(record, TARGET)}?", "out_view")
            # The engine reads an array of model handles. The caller passes the view over `cgs.gameModels`, or nil.
            # The trap wrapper hands the engine the base of the view.
            if t.get_pointee().spelling.replace("const ", "") == "qhandle_t":
                return Answer("Slots<qhandle_t>?", "slots_opt")
            if (facts.traps and engine_array(t, facts.following)) or (not facts.traps and facts.fills_array):
                # An `int *` with a count beside it is an array the engine fills, `trap_EntitiesInBox(mins, maxs, list, maxcount)`.
                # A function that hands its own `int *` on to that array takes the caller's array the same way.
                swift = self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"inout [{swift}]", "out_array" if facts.traps else "bare")
            # A pointer to one scalar is an out-param, `inout`. A body that finds Raven walks it as an array writes a Port-note.
            if not pointee.is_const_qualified() and (inner.kind in INT_KINDS or inner.kind in (TypeKind.FLOAT, TypeKind.ENUM)):
                swift = self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift) and facts.null_reaches:
                    # An output a caller skips with NULL, at a direct call or one hop on, crosses as the pointer itself, so `nil` has a seat.
                    # A body that writes through it keeps Raven's NULL test, `crazySmoothFactor` of BG_G2PlayerAngles.
                    return Answer(f"UnsafeMutablePointer<{swift}>?", "bare")
                if swift is not None and self.known(swift):
                    return Answer(f"inout {swift}", "out_scalar")
            return None
        if canonical.kind == TypeKind.CONSTANTARRAY and "vec3_t" in t.spelling:
            # `vec3_t name[3]` is an axis, the type the ported q_math axis functions take.
            if facts.traps:
                return None
            if facts.null_reaches and facts.stores_through and facts.null_arm:
                # A written axis a caller skips with NULL is an optional inout, with the same forward as a written vector.
                return Answer("inout [JKAShared.vec3_t]?", "axis_mut_opt")
            return Answer("inout [JKAShared.vec3_t]", "vec3_axis")
        if canonical.kind in (TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY) and not facts.traps:
            # A C array of struct pointers the function fills, `gentity_t *ent_list[MAX_GENTITIES]`, is the caller's array of optional views.
            element = canonical.element_type.get_canonical()
            if element.kind == TypeKind.POINTER:
                record = self.record_name(element.get_pointee())
                if record and record in self.views.views:
                    return Answer(f"inout [{self.views.qualified_view(record, TARGET)}?]", "view_array")
                if element.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                    # A C array of strings the function fills from a caller's `&array[i]`, `char *infos[]`, is the caller's slice from `i` on.
                    return Answer("inout ArraySlice<String>", "string_slice")
            if canonical.kind == TypeKind.CONSTANTARRAY and (element.kind in INT_KINDS or element.kind == TypeKind.FLOAT):
                # A fixed C array of a scalar the body reads, `int delta_angles[3]`, is the values by value, copied at the call.
                # A body that writes through it would take `inout`, and none does.
                swift = self.scalar(canonical.element_type, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"[{swift}]", "bare")
        if canonical.kind in (TypeKind.RECORD, TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY):
            return None
        swift = self.scalar(t, TARGET)
        if swift is None or not self.known(swift):
            return None
        if self.narrow(t) is not None:
            # C widens a short or a char argument to int at the call, so the parameter is Int32.
            swift = "Int32"
        # A C enum is an Int32 alias, so it travels as a bare word.
        return Answer(swift, "bare")

    # MARK: - The return role

    def returned(self, t: ci.Type, target: str = TARGET) -> Answer | None:
        """The Swift return type and the expression that maps the syscall word into it, or None for an unmappable return."""
        canonical = t.get_canonical()
        if t.spelling in TYPES:
            return Answer(TYPES[t.spelling], crossing=f"{TYPES[t.spelling]}(word)")
        if canonical.kind == TypeKind.VOID:
            return Answer(None)
        if canonical.kind == TypeKind.FLOAT:
            return Answer("Float", crossing="Float(bitPattern: UInt32(truncatingIfNeeded: word))")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if pointee.get_canonical().kind == TypeKind.FUNCTIONPROTO:
                # A returned function pointer goes into a view's stored function, so it is that field's callback type, optional.
                alias = self.views.callback_alias(pointee.get_canonical(), target)
                return Answer(f"{alias}?") if alias else None
            if pointee.get_canonical().kind == TypeKind.CHAR_S:
                # Text the caller reads and nothing else, so it crosses as a String. A function that returns NULL, rewrites its
                # argument in place, or returns a pointer into its argument has a RETURNS entry instead.
                return TEXT_RESULT
            # Raven returns NULL for no entity, so a returned view is optional.
            record = self.record_name(pointee)
            if record and record in self.views.views:
                view = self.views.qualified_view(record, target)
                return Answer(f"{view}?", crossing=f"OpaquePointer(bitPattern: word).map {{ {view}(handle: $0) }}")
            return None
        swift = self.scalar(t, target)
        if swift is None or not self.known(swift):
            return None
        if swift == "Bool":
            return Answer("Bool", crossing="word != 0")
        if self.narrow(t) is not None:
            # C widens a short or a char return to int at the caller, so the return is Int32.
            return Answer("Int32", crossing="Int32(truncatingIfNeeded: word)")
        return Answer(swift, crossing=f"{swift}(truncatingIfNeeded: word)")

    # MARK: - The local and expression roles

    def value(self, t: ci.Type, facts: Facts) -> Answer | None:
        """`Bool` for a test the body already spells as one, `Float`, `Double`, or `Int32` for a number, so a store converts its right side as C does."""
        if facts.is_bool:
            return Answer("Bool", "bool")
        kind = self.number_kind(t)
        return None if kind is None else Answer(kind, "number")

    def crossing(self, t: ci.Type, want: str, facts: Facts) -> Answer:
        """The conversion that carries an expression of type `t` into `want`, with `{text}` in the crossing for the expression's own words.

        The kind names what the emitter does with it: `bool_to_number` folds a Bool, `coerce` hands the expression back to the caller's own
        coercion, and `convert` writes the crossing around the text."""
        have = self.number_kind(t)
        if have == "Double" and facts.float_valued:
            have = "Float"
        if want in ("Float", "Int32") and facts.is_bool:
            return Answer(want, "bool_to_number")
        if want in ("Float", "Int32", "Double") and have is not None and have != want and not facts.is_literal:
            return Answer(want, "convert", crossing=want + "({text})")
        if want == "Int32" and have in ("Float", "Double") and facts.is_literal:
            # A float literal with an integral value is the integer literal, so Raven's `gravity = 1.0f` reads `gravity = 1`.
            # Any other float literal converts at the store, where C truncates, the mirror of `Float(x)`.
            value = float("".join((facts.literal_text or "").split()).rstrip("fFlL") or "nan")
            if value.is_integer():
                return Answer(want, "convert", crossing=str(int(value)))
            return Answer(want, "convert", crossing="Int32({text})")
        if want in NARROW_STORAGE and have is not None and not facts.is_literal:
            # C truncates the int it computed into the narrow local at the store.
            return Answer(want, "convert", crossing=want + "(truncatingIfNeeded: {text})")
        if want == "Int32" and facts.named_leaf and self.unsigned(t) is not None:
            # C passes an unsigned int where an int is due, and the bits stay the same.
            bits = "bitPattern" if self.unsigned(t) == "UInt32" else "truncatingIfNeeded"
            return Answer(want, "convert", crossing="Int32(" + bits + ": {text})")
        return Answer(want, "coerce")
