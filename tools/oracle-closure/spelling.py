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
from rulings import CXX_CLASSES, TYPES

TARGET = C.TARGETS["c_target"]
BUILTINS = set(SCALARS.values()) | {"Bool", "Float", "Int32", "Int"}
# The Swift storage of a C integer narrower than int, which a local keeps.
NARROW_STORAGE = {SCALARS[k] for k in NARROW}
INT_KINDS = {TypeKind.INT, TypeKind.UINT, TypeKind.LONG, TypeKind.ULONG, TypeKind.SHORT, TypeKind.USHORT}
# The vector typedefs JKAShared spells as SIMD types, so a parameter of one is the vector itself, never a pointer.
VECTORS = {"vec2_t", "vec3_t", "vec4_t"}
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
    # The parameter before this one, which a buffer the engine fills reads as its count.
    preceding: ci.Cursor | None = None
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
    # True when the body reads the pointer only through a dereference or a cast, so the pointer holds one scalar.
    reinterprets: bool = False
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
        if role == "local":
            return self.record_array(t, target) or self.value(t, facts)
        if role == "expression":
            return self.value(t, facts)
        raise ValueError(f"spelling.py: {role} is no role of {ROLES}")

    # MARK: - The lookups

    def record_name(self, t: ci.Type) -> str | None:
        """The typedef name of a struct type, or its tag when Raven gave it no typedef, or None for a non-struct."""
        decl = t.get_canonical().get_declaration()
        if decl.kind == CursorKind.UNION_DECL:
            # A named union takes a view only where a root row names its typedef, `qfile_gut` of files.h:71.
            named = t.get_named_type() if t.kind == TypeKind.ELABORATED else t
            if named.kind == TypeKind.TYPEDEF and named.spelling in self.views.records and self.views.records[named.spelling].kind == CursorKind.UNION_DECL:
                return named.spelling
            # A union Raven named by its tag alone, `union cvalue` of be_ai_char.cpp:39, takes a view where a root row names the tag, row X22.
            if decl.spelling in self.views.records and self.views.records[decl.spelling] == decl.get_definition():
                return decl.spelling
            return None
        if decl.kind == CursorKind.CLASS_DECL and decl.spelling in self.views.views:
            # A C++ class that C_STRUCT_CLASSES copies as a struct, `CCMShader` of cm_local.h:77, takes its view in the C++ parse of a body too.
            return decl.spelling
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
            if name == "ptrdiff_t":
                # Swift imports the C `ptrdiff_t` as Int on every triple, the width of the WIDENED_FIELDS rows, row X46 of docket 10.
                return "Int"
            if name in self.views.enums or name in self.views.declared and self.views.declared[name] and name != "vec_t":
                return self.views.qualified(name, target)
            return self.scalar(t.get_declaration().underlying_typedef_type, target)
        if t.kind == TypeKind.ENUM:
            name = t.spelling.replace("enum ", "")
            return "Bool" if name == "qboolean" else self.views.qualified(name, target)
        return SCALARS.get(t.kind)

    def fixed(self, t: ci.Type) -> str | None:
        """The TYPES spelling of a typedef the canonical type loses, `UINT4` behind a pointer or an array, or None."""
        name = (t.get_named_type() if t.kind == TypeKind.ELABORATED else t).spelling.replace("const ", "")
        return TYPES.get(name)

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
            # A row of vectors, `vec3_t points[MAX_GRID_SIZE][MAX_GRID_SIZE]` of cm_patch.h:115, is a row like any other, and the accessor
            # asks for its `vec3_t` element in turn, row P4.
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
        if facts.ruled == "opaque":
            # The body stores the `byte *` into a `byte *` field or hands it on as a `void *`, so it takes the field's spelling.
            return Answer("OpaquePointer?", "bare")
        if facts.ruled == "slot" and canonical.kind == TypeKind.POINTER and canonical.get_pointee().get_canonical().kind == TypeKind.POINTER:
            # The address of one record pointer slot, `node_t **ppnode` of free_ppnode, is the Slots of one optional view over the slot.
            record = self.record_name(canonical.get_pointee().get_canonical().get_pointee())
            if record and record in self.views.views:
                return Answer(f"Slots<{self.views.qualified_view(record, TARGET)}?>", "bare")
        if facts.ruled == "vec3_mut":
            return Answer("inout JKAShared.vec3_t", "vec3_mut")
        if facts.ruled == "vec3_const":
            return Answer("JKAShared.vec3_t", "vec3_const")
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
        if facts.ruled == "view":
            # Every caller fills the `void *` with one record or NULL, so the parameter is that record's optional view.
            return Answer(f"{self.views.qualified_view(facts.capacity, TARGET)}?", "view_opt")
        if facts.ruled in ("keyword_buckets", "keyword_buckets_mut"):
            # The buckets hold row indices, and the row table crosses as the next parameter of the signature, form A of R53.
            inout = "inout " if facts.ruled == "keyword_buckets_mut" else ""
            return Answer(f"{inout}[Int32?], _ rows: {inout}[KeywordHashRow]", "bare")
        if facts.ruled == "row_index":
            return Answer("Int32", "bare")
        if facts.ruled == "word":
            # The module hands back a pointer-wide word, which VM_Call returns whole, so the parameter takes the same word.
            return Answer("Int", "bare")
        if facts.ruled == "callback" and canonical.kind == TypeKind.POINTER and canonical.get_pointee().get_canonical().kind == TypeKind.FUNCTIONPROTO:
            # The body stores the function pointer into a view's stored function, so it is that field's callback type, optional,
            # the form a function-pointer return has. A row that names the field picks that field's alias among aliases of one signature.
            alias = self.views.callback_alias(canonical.get_pointee().get_canonical(), TARGET, facts.capacity)
            if alias:
                return Answer(f"{alias}?", "bare")
        if facts.ruled == "bytes" and canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee().get_canonical()
            if pointee.kind == TypeKind.POINTER and pointee.get_pointee().get_canonical().kind in (TypeKind.VOID, TypeKind.UCHAR, TypeKind.CHAR_S):
                # A `void **` the body sets to a byte buffer, `ppvBuffer` of RE_RegisterModels_GetDiskFile, is the caller's optional Slots of bytes,
                # inout, the shape a `void **` handle has, row TR13. A `byte **`, `pic` of LoadTGA at tr_image.cpp:1421, is the same, row G11 of docket 13.
                # A `char **`, `buffer` of G2_SaveGhoul2Models at G2_misc.cpp:1719, is the same, because the body sets it to a Z_Malloc block, row S1.
                return Answer("inout Slots<JKAShared.byte>?", "out_opaque")
            if canonical.get_pointee().get_canonical().kind == TypeKind.INT:
                # An `int *` list the body fills, `int *entityList` of SV_AreaEntities, is the caller's Slots of Int32, the rule of the field kind.
                return Answer("Slots<Int32>", "slots")
            # The body hands the pointer on as bytes, `MD4Update(&ctx, (unsigned char *)buffer, length)`, so the caller's Slots over the bytes
            # crosses, the row a host `byte *` has.
            return Answer("Slots<JKAShared.byte>", "slots")
        if facts.ruled == "string_list":
            # A `char **` list of zone texts the body reads or frees is the caller's array of texts, the return twin.
            return Answer("[String]", "bare")
        if facts.ruled == "string_list_mut":
            # The body reorders the caller's list in place, FS_SortFileList.
            return Answer("inout [String]", "bare")
        if facts.ruled == "string_slice":
            # The body fills the caller's list by index, `psList[*numfiles] = CopyString(...)`, the `char *infos[]` row.
            return Answer("inout ArraySlice<String>", "string_slice")
        slot = canonical.get_pointee() if canonical.kind == TypeKind.POINTER else \
            canonical.element_type if canonical.kind in (TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY) else None
        if facts.ruled == "string_slots" and slot is not None and slot.get_canonical().kind == TypeKind.POINTER \
                and slot.get_canonical().get_pointee().get_canonical().kind == TypeKind.CHAR_S:
            # A `char *x[]` table whose slots can hold NULL, `stringindex` of AAS_StringFromIndex at be_aas_main.cpp:68, is the caller's Slots
            # of optional texts, the type of the `configstrings` field it comes from, the text twin of pointer_table, row G22 of docket 13.
            return Answer("Slots<String?>", "slots")
        if facts.ruled == "string_value":
            # A qsort comparator reads its `const void *` as `*(char **)`, so the text crosses, the text twin of int_value.
            return Answer("String", "bare")
        if facts.ruled == "std_string" and canonical.kind == TypeKind.LVALUEREFERENCE:
            # A C++ `std::string &` the body writes is the caller's String, the reference twin of out_string.
            return Answer("inout String", "out_string_ref")
        if facts.ruled == "vec4_const":
            # The body reads the four floats of a plane and writes none, the form a `vec4_t` parameter has.
            return Answer("JKAShared.vec4_t", "bare")
        if facts.ruled == "vec3_array" and canonical.kind == TypeKind.POINTER and t.get_pointee().spelling.replace("const ", "") in VECTORS:
            # The body reads the caller's array of vectors with a count beside it, the form a trap's `vec3_t *` array has.
            return Answer(f"[JKAShared.{t.get_pointee().spelling.replace('const ', '')}]", "vec3_array")
        if facts.ruled == "table" and canonical.kind == TypeKind.POINTER and t.get_pointee().spelling.replace("const ", "") in VECTORS:
            # Raven indexes the vectors through the pointer with a count beside it, so the Slots over them crosses, the row of a record table.
            if facts.nullable:
                # A caller hands NULL, `AAS_TraceAreas(start, end, areas, NULL, 10)` of be_aas_reach.cpp:1542, so the Slots is optional,
                # the form of the `modelList` row.
                return Answer("Slots<JKAShared.vec3_t>?", "slots_opt")
            return Answer("Slots<JKAShared.vec3_t>", "slots")
        if facts.ruled == "table" and canonical.kind == TypeKind.POINTER and canonical.get_pointee().get_canonical().kind == TypeKind.FLOAT:
            # A `float *` that a row rules as a table holds three floats for each vector, `points` of the `drawPoly` closure of CM_DrawDebugSurface
            # at cm_patch.cpp:1651, which R_DebugPolygon reads as `points + i * 3` at tr_main.cpp:1550. So the Slots of vectors crosses, row S4.
            return Answer("Slots<JKAShared.vec3_t>", "slots")
        if canonical.kind in (TypeKind.LVALUEREFERENCE, TypeKind.POINTER) and not facts.traps:
            # A C++ class of CXX_CLASSES is the hand Swift class of the same name, a reference by itself and a pointer optional, rule 17.
            declaration = canonical.get_pointee().get_canonical().get_declaration()
            if declaration is not None and declaration.spelling in CXX_CLASSES:
                swift = CXX_CLASSES[declaration.spelling]
                return Answer(swift if canonical.kind == TypeKind.LVALUEREFERENCE else f"{swift}?", "bare")
            if canonical.kind == TypeKind.POINTER and canonical.get_pointee().get_canonical().kind == TypeKind.POINTER:
                # A pointer to a class pointer, `CGhoul2Info_v **ghlRemove`, is the caller's optional class, inout,
                # the shape a `void **` handle has.
                declaration = canonical.get_pointee().get_canonical().get_pointee().get_canonical().get_declaration()
                if declaration is not None and declaration.spelling in CXX_CLASSES:
                    return Answer(f"inout {CXX_CLASSES[declaration.spelling]}?", "out_opaque")
            if canonical.kind == TypeKind.POINTER and t.kind == TypeKind.POINTER:
                # A pointer to a handle typedef of TYPES, `TGenericParser2 *GP2` of GP_Delete at GenericParser2.cpp:952, is the caller's optional
                # handle, inout, the form of the class pointer above, row G1 of docket 13.
                handle = t.get_pointee()
                named = (handle.get_named_type() if handle.kind == TypeKind.ELABORATED else handle).spelling
                if named in TYPES and TYPES[named].endswith("?") and not handle.is_const_qualified():
                    return Answer(f"inout {TYPES[named]}", "out_opaque")
            # A C++ reference to a record pointer, `mdxaBone_t *&retBasepose` of G2_GetBoneBasepose at tr_ghoul2.cpp:656, is the caller's
            # optional view, inout, the form of a pointer to a struct pointer, row X14 G1c of docket 10.
            if canonical.kind == TypeKind.LVALUEREFERENCE and canonical.get_pointee().get_canonical().kind == TypeKind.POINTER \
                    and not canonical.get_pointee().is_const_qualified():
                record = self.record_name(canonical.get_pointee().get_canonical().get_pointee())
                if record and record in self.views.views:
                    return Answer(f"inout {self.views.qualified_view(record, TARGET)}?", "out_view")
            # A C++ reference to a typedef of TYPES, `boneInfo_v &blist`, is the TYPES spelling, inout unless the reference is const.
            # The canonical type loses the name, so the rule reads the pointee as Raven spelled it.
            if canonical.kind == TypeKind.LVALUEREFERENCE and t.kind == TypeKind.LVALUEREFERENCE:
                pointee = t.get_pointee()
                named = (pointee.get_named_type() if pointee.kind == TypeKind.ELABORATED else pointee).spelling.replace("const ", "")
                if named in TYPES:
                    const = pointee.is_const_qualified()
                    return Answer(TYPES[named] if const else f"inout {TYPES[named]}", "bare" if const else "out_string_ref")
            # A C++ reference to a scalar the body writes, `qboolean &bAlreadyCached` of ServerLoadMDXA, is the caller's scalar, inout,
            # the form a pointer to one scalar has below. The tr round names it for its loaders, tr_model.cpp:683, :799, and :1427.
            scalar = canonical.get_pointee().get_canonical() if canonical.kind == TypeKind.LVALUEREFERENCE else None
            if scalar is not None and not scalar.is_const_qualified() and (scalar.kind in INT_KINDS or scalar.kind in (TypeKind.FLOAT, TypeKind.ENUM, TypeKind.BOOL)):
                swift = "Bool" if scalar.kind == TypeKind.BOOL else self.scalar(t.get_pointee() if t.kind == TypeKind.LVALUEREFERENCE else canonical.get_pointee(), TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"inout {swift}", "bare")
        if facts.ruled == "int_array_mut":
            # The body writes the caller's `int` array by index, so the array crosses inout, the `int` twin of float_array.
            return Answer("inout [Int32]", "bare")
        if facts.ruled == "int_array":
            # The body only reads the values, and Raven's callers pass NULL with a count of zero, so the array crosses by value as an optional.
            return Answer("[Int32]?", "int_array")
        if facts.ruled == "byte_offset":
            # A pointer into a byte buffer the body subtracts the base from is its byte offset, the pointer-into-a-buffer rule, row TR20.
            return Answer("Int32", "bare")
        if facts.ruled == "byte_array":
            # The body only reads the bytes, and every caller passes a byte table that is a Swift array, so the array crosses by value.
            return Answer("[JKAShared.byte]", "bare")
        if t.spelling.replace("const ", "") in TYPES:
            return Answer(TYPES[t.spelling.replace("const ", "")], "bare")
        # A trap's buffer with a maximum count before it is an array the engine fills up to that count,
        # `trap_CM_MarkFragments(..., maxPoints, pointBuffer, maxFragments, fragmentBuffer)`.
        # A `sizeof` before a pointer is a byte stride and not a count, `trap_LocateGameData(..., sizeofGEntity_t, clients, ...)`.
        filled = facts.traps and facts.preceding is not None and facts.preceding.type.get_canonical().kind in INT_KINDS \
            and facts.preceding.spelling.startswith("max")
        if t.spelling.split()[-1] == "vec3pair_t" and not facts.traps:
            # `typedef vec3_t vec3pair_t[2]` is a pair of bounds, the caller's array of two vectors, the form of the axis.
            return Answer("[JKAShared.vec3_t]", "bare") if "const" in t.spelling else Answer("inout [JKAShared.vec3_t]", "vec3_axis")
        # A vector parameter is the array type itself, and Clang keeps the typedef name on the parameter.
        if t.spelling.split()[-1] in VECTORS:
            if filled and "const" not in t.spelling:
                # Raven hands the first of the caller's vectors, so the caller's array crosses and the trap packs it flat, see traps.py.
                return Answer(f"inout [JKAShared.{t.spelling.split()[-1]}]", "vec3_axis")
            if facts.null_reaches and not facts.stores_through and not facts.traps:
                # A caller passes NULL and the body only reads, so the vector crosses as an optional value and the NULL test keeps its form.
                return Answer(f"JKAShared.{t.spelling.split()[-1]}?", "vec3_opt")
            if facts.null_reaches and facts.stores_through and facts.null_arm and not facts.traps and facts.ruled is None and "const" not in t.spelling:
                # A caller passes NULL, the body writes the vector, and a NULL arm does more than skip that write,
                # so the vector crosses as an optional inout, and the NULL test keeps its form.
                # The skeleton writes a forward with the plain inout vector beside the function, for the callers that pass one.
                return Answer(f"inout JKAShared.{t.spelling.split()[-1]}?", "vec3_mut_opt")
            if facts.null_reaches and facts.traps:
                # A caller hands the trap NULL, `trap_S_StartSound(NULL, ...)`.
                # The engine reads NULL as no vector, and this sound then plays at the entity.
                # The vector crosses as an optional value, and the trap sends the zero word for nil, see traps.py.
                # Raven's trap declares some such vectors without const, and the engine only reads each one, `S_StartSound(const vec3_t origin, ...)`.
                return Answer(f"JKAShared.{t.spelling.split()[-1]}?", "vec3_const_opt")
            if "const" in t.spelling:
                return Answer(f"JKAShared.{t.spelling.split()[-1]}", "vec3_const")
            if facts.store_swept and not facts.stores_through and not facts.traps:
                # The body never writes the vector, so it crosses by value as a const one does, and a caller passes a `let` vector as it is.
                return Answer(f"JKAShared.{t.spelling.split()[-1]}", "vec3_const")
            return Answer(f"inout JKAShared.{t.spelling.split()[-1]}", "vec3_mut")
        if canonical.kind == TypeKind.POINTER:
            pointee = canonical.get_pointee()
            if t.get_pointee().spelling.replace("const ", "") in VECTORS and facts.traps:
                # An array of vectors the engine reads, with a count beside it. The trap packs it flat, see traps.py.
                return Answer(f"[JKAShared.{t.get_pointee().spelling.replace('const ', '')}]", "vec3_array")
            if t.get_pointee().spelling in VECTORS:
                if facts.traps:
                    # An array of vectors the engine reads, with a count beside it. The trap packs it flat, see traps.py.
                    return Answer(f"[JKAShared.{t.get_pointee().spelling}]", "vec3_array")
                # A pointer to one vector the caller owns, which Raven writes as `(*c)[i]`.
                return Answer(f"inout JKAShared.{t.get_pointee().spelling}", "vec3_mut")
            if pointee.is_const_qualified() and pointee.kind == TypeKind.FLOAT and not facts.reinterprets:
                # Raven's `const float *` is a color of four floats, `trap_R_SetColor(rgba)` and `CG_FillRect(..., color)`.
                # A caller can pass NULL, so the color is optional.
                # A body that reads the pointer only through `*f` or a cast holds one float, `FloatSwap(const float *f)`.
                # That pointer takes the scalar arm below.
                # The vector crosses as an optional value, and a trap packs it for the word, see traps.py.
                return Answer("JKAShared.vec4_t?", "vec4_opt")
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
                if facts.store_swept and not facts.stores_through and not facts.null_reaches:
                    # The body never writes the axis, so it crosses by value as a read-only vector does, `AxisCopy(in, out)`.
                    return Answer("[JKAShared.vec3_t]", "bare")
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
                if facts.ruled == "out_scalar":
                    # A `char *` that holds one character the body writes, `ch` of PS_ReadEscapeCharacter at l_script.cpp:344,
                    # is the caller's scalar, inout, the rule of a pointer to one scalar, row X32.
                    return Answer("inout CChar", "out_scalar")
                if facts.ruled == "text" or (facts.ruled is None and facts.readonly_text):
                    # The body only reads the text, so the parameter is a String, the spelling a `const char *` already has.
                    # A PARAMS row names the kind itself, so it wins over the sweep.
                    # A row of kind `text` names a read that the sweep cannot see, the form of a stored function's missing `const`.
                    # A NULL the sweep reaches at a call or one hop on makes it a String?, the way the vector rules read the same sets.
                    return Answer("String?" if facts.null_reaches else "String", "cstring_opt" if facts.null_reaches else "cstring")
                # A body reads and rewrites the caller's buffer in place, so the caller's CharBuf crosses with `&`.
                return Answer("inout JKAShared.CharBuf", "inout_charbuf")
            record = self.record_name(pointee)
            if record and record in self.views.views:
                if filled and not pointee.is_const_qualified():
                    # Raven hands the first of the caller's records, so the Slots over them crosses, and its base is the word.
                    return Answer(f"Slots<{self.views.qualified_view(record, TARGET)}>", "slots")
                if facts.ruled == "table":
                    # Raven indexes the table through the pointer, so the Slots over it crosses, and its base is the word.
                    # A caller that hands NULL makes the Slots optional, the form of the vector table of AAS_TraceAreas,
                    # `avoidspots` of BotGetReachabilityToGoal at be_ai_move.cpp:731, row X19.
                    if facts.nullable:
                        return Answer(f"Slots<{self.views.qualified_view(record, TARGET)}>?", "slots_opt")
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
                if facts.ruled == "text_cursor":
                    # A `void **` that the body casts to `char **` for a text cursor, Q3_ReadScript of Q3_Interface.cpp:45.
                    return Answer("inout JKAShared.TextCursor", "text_cursor")
                # The address of a `void *` the engine fills or clears, one word up from the handle it holds.
                return Answer("inout OpaquePointer?", "out_opaque")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                # A `const char **` is Raven's cursor into a text buffer, which the COM_Parse family advances. A parameter the
                # function sets to the token instead has a PARAMS entry, and a non-const `char **` takes that entry the same way.
                if facts.ruled == "out_string":
                    return Answer("inout String", "out_string_ref")
                if facts.ruled == "out_optional_string":
                    # The function stores a text or NULL, and a caller passes the address of a `char *` field, which a view holds as a String?.
                    return Answer("inout String?", "out_string_ref")
            if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S:
                # A `char **` the function walks is the same cursor whether or not Raven wrote `const`, `Float_Parse(char **p, ...)`.
                return None if facts.traps else Answer("inout JKAShared.TextCursor", "text_cursor")
            if inner.kind == TypeKind.POINTER and not pointee.is_const_qualified():
                # The address of a struct pointer the body sets, an out-param, `inout View?`. A pointer table into a trap has a PARAMS entry.
                record = self.record_name(inner.get_pointee())
                if facts.ruled == "pointer_table" and record and record in self.views.views:
                    # The table's base crosses to the engine, and the body holds the Slots over the C storage.
                    return Answer(f"Slots<{self.views.qualified_view(record, TARGET)}?>", "slots")
                if facts.ruled == "view_array" and record and record in self.views.views:
                    # The caller's C array of struct pointers that the function fills, `token_t *parms[MAX_DEFINEPARMS]` of PC_ExpandDefine,
                    # is the caller's array of optional views, the rule of a `T *name[N]` parameter, row X31.
                    return Answer(f"inout [{self.views.qualified_view(record, TARGET)}?]", "view_array")
                if record and record in self.views.views and not facts.traps:
                    return Answer(f"inout {self.views.qualified_view(record, TARGET)}?", "out_view")
            # The engine reads an array of model handles. The caller passes the view over `cgs.gameModels`, or nil.
            # The trap wrapper hands the engine the base of the view.
            # Raven declares two bone traps with `int *modelList`, and a PARAMS row names that array of model handles the same way.
            if t.get_pointee().spelling.replace("const ", "") == "qhandle_t" or facts.ruled == "model_list":
                return Answer("Slots<qhandle_t>?", "slots_opt")
            if (facts.traps and engine_array(t, facts.following)) or (not facts.traps and facts.fills_array):
                # An `int *` with a count beside it is an array the engine fills, `trap_EntitiesInBox(mins, maxs, list, maxcount)`.
                # A function that hands its own `int *` on to that array takes the caller's array the same way.
                swift = self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"inout [{swift}]", "out_array" if facts.traps else "bare")
            if facts.traps and not pointee.is_const_qualified() and inner.kind == TypeKind.UCHAR:
                # A trap's `byte *` with no count beside it is a byte array the engine reads, `trap_R_inPVS(p1, p2, mask)`.
                # Raven's caller hands it a byte array field, so the caller's Slots over the bytes crosses, and its base is the word.
                swift = self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"Slots<{swift}>", "slots")
            if C.HOST and not facts.traps and inner.kind == TypeKind.UCHAR:
                # A `byte *` of a host function that is not a trap is the caller's byte array, `MD4Update(&ctx, input, len)`, so the caller's
                # Slots over the bytes crosses, the row a trap's `byte *` has. A game function with this shape keeps its marker.
                swift = self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"Slots<{swift}>", "slots")
            if C.HOST and not facts.traps and facts.indexed and (inner.kind in INT_KINDS or inner.kind in (TypeKind.FLOAT, TypeKind.ENUM)):
                # A scalar pointer a host body indexes is the caller's array, `input[i]` of Encode, so the caller's Slots over it crosses.
                # The game keeps the `inout` scalar below, because its subscript sweep reads record pointers alone.
                swift = self.fixed(t.get_pointee()) or self.scalar(pointee, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"Slots<{swift}>", "slots")
            # A pointer to one scalar is an out-param, `inout`. A body that finds Raven walks it as an array writes a Port-note.
            # A `double *` takes the rule of an `int *`, `floatvalue` of PC_Evaluate at l_precomp.cpp:2185, row D5 of the ninth batch.
            if not pointee.is_const_qualified() and (inner.kind in INT_KINDS or inner.kind in (TypeKind.FLOAT, TypeKind.DOUBLE, TypeKind.ENUM)):
                swift = self.fixed(t.get_pointee()) or self.scalar(pointee, TARGET)
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
                # The trap packs the axis flat for the engine and writes the flat floats back, see traps.py.
                return Answer("inout [JKAShared.vec3_t]", "vec3_axis")
            if facts.null_reaches and facts.stores_through and facts.null_arm:
                # A written axis a caller skips with NULL is an optional inout, with the same forward as a written vector.
                return Answer("inout [JKAShared.vec3_t]?", "axis_mut_opt")
            if facts.store_swept and not facts.stores_through and not facts.null_reaches:
                # The body never writes the axis, so it crosses by value as a read-only vector does.
                return Answer("[JKAShared.vec3_t]", "bare")
            return Answer("inout [JKAShared.vec3_t]", "vec3_axis")
        if canonical.kind == TypeKind.CONSTANTARRAY and "vec2_t" in t.spelling and not facts.traps:
            # `vec2_t uv[4]` is the caller's array of texture coordinates, so it crosses as the axis does, `CG_CalcBiLerp(..., uv)`.
            return Answer("inout [JKAShared.vec2_t]", "vec3_axis")
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
            if C.HOST and element.kind == TypeKind.UCHAR:
                # A C array of bytes, `unsigned char digest[16]` of MD4Final, decays to the `byte *` above, so it takes the same Slots.
                swift = self.scalar(canonical.element_type if t.kind != TypeKind.CONSTANTARRAY else t.element_type, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"Slots<{swift}>", "slots")
            if canonical.kind == TypeKind.CONSTANTARRAY and (element.kind in INT_KINDS or element.kind == TypeKind.FLOAT):
                # A fixed C array of a scalar the body reads, `int delta_angles[3]`, is the values by value, copied at the call.
                # A host body that writes it, `state[0] += a` of MD4Transform, writes the caller's array, so the caller's Slots crosses.
                # No game body writes such an array.
                swift = (self.fixed(t.element_type) if t.kind == TypeKind.CONSTANTARRAY else None) or self.scalar(canonical.element_type, TARGET)
                if swift is not None and self.known(swift) and C.HOST and facts.stores_through:
                    return Answer(f"Slots<{swift}>", "slots")
                if swift is not None and self.known(swift):
                    return Answer(f"[{swift}]", "bare")
            if C.HOST and canonical.kind == TypeKind.CONSTANTARRAY and element.kind == TypeKind.CONSTANTARRAY and not facts.stores_through:
                # A host array of arrays of a scalar the body reads, `int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2]` of cm_patch.cpp:592,
                # nests the rule above, one Swift Array per index, the form of the caller's local in CM_PatchCollideFromGrid, row T7.
                depth, scalar = 1, element
                while scalar.kind == TypeKind.CONSTANTARRAY:
                    depth, scalar = depth + 1, scalar.element_type.get_canonical()
                swift = self.scalar(scalar, TARGET) if scalar.kind in INT_KINDS or scalar.kind == TypeKind.FLOAT else None
                if swift is not None and self.known(swift):
                    return Answer("[" * depth + swift + "]" * depth, "bare")
        if canonical.kind == TypeKind.CONSTANTARRAY and facts.traps:
            # A fixed C array of a scalar into a trap is an array the engine fills, `trap_R_GetLightStyle(style, color)` with Raven's
            # `typedef byte color4ub_t[4]`, so the caller's array crosses `inout`, as an `int *` with a count beside it does.
            element = canonical.element_type.get_canonical()
            if element.kind in INT_KINDS or element.kind in (TypeKind.FLOAT, TypeKind.UCHAR):
                swift = self.scalar(element, TARGET)
                if swift is not None and self.known(swift):
                    return Answer(f"inout [{swift}]", "out_array")
        if canonical.kind == TypeKind.LVALUEREFERENCE and not facts.traps:
            # A C++ reference to a record, `clipMap_t &cm` of CM_LoadMap_Actual, is the caller's record, so it crosses as its view,
            # the shape a record pointer has.
            record = self.record_name(canonical.get_pointee())
            if record and record in self.views.views:
                return Answer(self.views.qualified_view(record, TARGET), "view")
        if canonical.kind == TypeKind.RECORD and not facts.traps:
            # A record Raven passes by value, `netadr_t adr` of NET_SendPacket, crosses as its view, the shape a record pointer has.
            # The view aliases the caller's record, so a body that writes such a parameter takes a scratch copy.
            record = self.record_name(t)
            if record and record in self.views.views:
                return Answer(self.views.qualified_view(record, TARGET), "view")
        if canonical.kind in (TypeKind.RECORD, TypeKind.CONSTANTARRAY, TypeKind.INCOMPLETEARRAY):
            return None
        if canonical.kind == TypeKind.BOOL:
            # The C++ `bool` of the host files is `Bool` at the surface, the spelling `qboolean` has.
            return Answer("Bool", "bare")
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
        if canonical.kind == TypeKind.BOOL:
            # The C++ `bool` of the host files is `Bool` at the surface, the spelling `qboolean` has.
            return Answer("Bool", crossing="word != 0")
        if canonical.kind == TypeKind.FLOAT:
            return Answer("Float", crossing="Float(bitPattern: UInt32(truncatingIfNeeded: word))")
        if canonical.kind in (TypeKind.LVALUEREFERENCE, TypeKind.POINTER):
            # A C++ class of CXX_CLASSES is the hand Swift class, a returned reference by itself and a returned pointer optional,
            # the return twin of the parameter rule, rule 17.
            declaration = canonical.get_pointee().get_canonical().get_declaration()
            if declaration is not None and declaration.spelling in CXX_CLASSES:
                swift = CXX_CLASSES[declaration.spelling]
                return Answer(swift if canonical.kind == TypeKind.LVALUEREFERENCE else f"{swift}?")
        if canonical.kind == TypeKind.LVALUEREFERENCE:
            # A returned C++ reference to a record, `const mdxaBone_t &` of EvalBoneCache at tr_ghoul2.cpp:585, is the record's view,
            # the parameter rule of a record reference, row X14 G1b of docket 10.
            record = self.record_name(canonical.get_pointee())
            if record and record in self.views.views:
                return Answer(self.views.qualified_view(record, target))
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

    def record_array(self, t: ci.Type, target: str) -> Answer | None:
        """The Slots over Raven's local array of records a view covers, `polyVert_t verts[4]`, with the count of the scratch that holds it."""
        canonical = t.get_canonical()
        if canonical.kind != TypeKind.CONSTANTARRAY:
            return None
        record = self.record_name(canonical.element_type)
        if not record or record not in self.views.views:
            return None
        return Answer(SLOTS + self.views.qualified_view(record, target) + ">", "record_array", size=str(canonical.element_count))

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
        # The pointer-wide word of RETURNS kind `word` folds a Bool the same way, `CM_AreasConnected` of SV_GameSystemCalls at sv_game.cpp:628.
        if want in ("Float", "Int32", "Int") and facts.is_bool:
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
        if want in NARROW_STORAGE and have in ("Float", "Double") and not facts.is_literal:
            # C converts the float to int and truncates the int into the narrow slot, `colors[0] = red * 255`.
            return Answer(want, "convert", crossing=want + "(truncatingIfNeeded: Int32({text}))")
        if want in NARROW_STORAGE and have is not None and not facts.is_literal:
            # C truncates the int it computed into the narrow local at the store.
            return Answer(want, "convert", crossing=want + "(truncatingIfNeeded: {text})")
        if want == "Int32" and facts.named_leaf and self.unsigned(t) is not None:
            # C passes an unsigned int where an int is due, and the bits stay the same.
            bits = "bitPattern" if self.unsigned(t) == "UInt32" else "truncatingIfNeeded"
            return Answer(want, "convert", crossing="Int32(" + bits + ": {text})")
        return Answer(want, "coerce")
