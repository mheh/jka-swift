internal import CJKAMP_Ded
import JKAMP
import JKAShared

/// Source: oracle/codemp/qcommon/cm_local.h:230
/// A view over one `sphere_t` in C memory, the capsule of an oriented capsule trace.
/// A copy of a view is a copy of the pointer, and two views of one slot compare equal.
// AI: Raven's `sphere_t` has no root in the view generator. This hand view gives the fields and the stack slot that the cm_trace bodies read, in the generated form.
public struct Sphere: Hashable, HandleView {
    let raw: UnsafeMutablePointer<sphere_t>

    init(raw: UnsafeMutablePointer<sphere_t>) { self.raw = raw }

    /// The slot behind a handle a generated thunk received. Rule 11 confines the handle to generated code.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(sphere_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: sphere_t.self) }

    /// Raven's cast from another struct's pointer over the same memory, `(sphere_t *)other`.
    public init(_ other: some HandleView) { self.raw = UnsafeMutablePointer(other.handle) }

    /// The slot as a handle, for a stored function call and for a view in another module.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes, for a module that allocates its own slot and cannot see the C type.
    public static let byteCount = MemoryLayout<sphere_t>.size

    /// The distance between two slots of a C array of this type, for a Slots over one.
    public static let stride = MemoryLayout<sphere_t>.stride

    /// Raven's `sphere_t sphere;` on the stack. The slot is zero at entry, lives for the closure, and the closure's value is the result.
    public static func scratch<Result>(_ body: (Sphere) throws -> Result) rethrows -> Result {
        var slot = sphere_t()
        return try withUnsafeMutablePointer(to: &slot) { try body(Sphere(raw: $0)) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:232
    public var use: Bool {
        get { self.raw.pointee.use != qfalse }
        nonmutating set { self.raw.pointee.use = newValue ? qtrue : qfalse }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:233
    public var radius: Float {
        get { self.raw.pointee.radius }
        nonmutating set { self.raw.pointee.radius = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:234
    public var halfheight: Float {
        get { self.raw.pointee.halfheight }
        nonmutating set { self.raw.pointee.halfheight = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:235
    public var offset: JKAShared.vec3_t {
        get { vec3(of: self.raw.pointee.offset) }
        nonmutating set { self.raw.pointee.offset = tuple(of: newValue) }
    }
}

/// Source: oracle/codemp/qcommon/cm_local.h:99
/// A view over one `cArea_t` in C memory, the flood state of one area of the clip map.
/// A copy of a view is a copy of the pointer, and two views of one slot compare equal.
// AI: Raven's `cArea_t` has no root in the view generator. This hand view gives the fields that the cm_test bodies read, in the generated form.
public struct CArea: Hashable, HandleView {
    let raw: UnsafeMutablePointer<cArea_t>

    init(raw: UnsafeMutablePointer<cArea_t>) { self.raw = raw }

    /// The slot behind a handle a generated thunk received. Rule 11 confines the handle to generated code.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(cArea_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: cArea_t.self) }

    /// Raven's cast from another struct's pointer over the same memory, `(cArea_t *)other`.
    public init(_ other: some HandleView) { self.raw = UnsafeMutablePointer(other.handle) }

    /// The slot as a handle, for a stored function call and for a view in another module.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes, for a module that allocates its own slot and cannot see the C type.
    public static let byteCount = MemoryLayout<cArea_t>.size

    /// The distance between two slots of a C array of this type, for a Slots over one.
    public static let stride = MemoryLayout<cArea_t>.stride

    /// Source: oracle/codemp/qcommon/cm_local.h:100
    public var floodnum: Int32 {
        get { self.raw.pointee.floodnum }
        nonmutating set { self.raw.pointee.floodnum = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:101
    public var floodvalid: Int32 {
        get { self.raw.pointee.floodvalid }
        nonmutating set { self.raw.pointee.floodvalid = newValue }
    }
}

extension ClipMap {
    /// Raven's `areas[i]`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:200
    // AI: Raven's `cArea_t *areas` has no accessor on the hand `ClipMap` view. The accessor gives the records in the generated `<name>Slots` form.
    public var areasSlots: Slots<CArea> {
        get {
            precondition(self.raw.pointee.areas != nil, "areas is NULL")
            return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.areas!), count: Int.max, stride: CArea.stride)
        }
        nonmutating set { self.raw.pointee.areas = newValue.base.assumingMemoryBound(to: cArea_t.self) }
    }

    /// Raven's `int *areaPortals`, the reference counts of the portals between two areas, with the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:201
    // AI: Raven indexes an `int *` field. The accessor spells it as a Slots of the scalar with the widest count, the form of `leafbrushes`.
    public var areaPortals: Slots<Int32>? {
        get { self.raw.pointee.areaPortals.map { Slots(scalars: UnsafeMutableRawPointer($0), count: Int.max) } }
        nonmutating set { self.raw.pointee.areaPortals = newValue?.base.assumingMemoryBound(to: Int32.self) }
    }
}

extension Cbrushside {
    /// Raven's `b->sides[i]` through a `cbrushside_t *` field, the side `i` slots past this one.
    /// Source: oracle/codemp/qcommon/cm_test.cpp:269
    // AI: Raven indexes a `cbrushside_t *` field as an array. The subscript gives the view `i` slots past this one, the form of the `Cplane` subscript.
    public subscript(i: some BinaryInteger) -> Cbrushside {
        Cbrushside(UnsafeMutableRawPointer(self.handle) + Int(i) * Cbrushside.stride)
    }
}

/// Raven's `Com_Memset( buffer, val, count )` over a `byte *` that the port holds as a Slots of bytes.
/// Source: oracle/codemp/qcommon/common.cpp:1820
// AI: Raven fills the bytes from a raw pointer. The overload takes the Slots and stores the low byte of `val` into each of the first `count` bytes, the form of the `CharBuf` overload.
public func Com_Memset(_ dest: Slots<JKAShared.byte>, _ val: Int32, _ count: some BinaryInteger) {
    var index = 0
    while index < Int(count) {
        dest[byte: index] = val
        index += 1
    }
}
