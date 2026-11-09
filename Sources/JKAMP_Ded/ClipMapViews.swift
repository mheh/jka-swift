internal import CJKAMP_Ded
import JKAMP
import JKAShared

/// Source: oracle/codemp/qcommon/cm_local.h:161
/// A view over one `clipMap_t` in C memory, the clip map of the world BSP or of one sub BSP.
/// A copy of a view is a copy of the pointer, and two views of one slot compare equal.
// AI: Raven's `clipMap_t` has no root in the view generator. This hand view gives the fields that the cm_load and cm_shader bodies read, in the generated form.
public struct ClipMap: Hashable, HandleView {
    let raw: UnsafeMutablePointer<clipMap_t>

    init(raw: UnsafeMutablePointer<clipMap_t>) { self.raw = raw }

    /// The slot behind a handle a generated thunk received. Rule 11 confines the handle to generated code.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(clipMap_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: clipMap_t.self) }

    /// Raven's cast from another struct's pointer over the same memory, `(clipMap_t *)other`.
    public init(_ other: some HandleView) { self.raw = UnsafeMutablePointer(other.handle) }

    /// The slot as a handle, for a stored function call and for a view in another module.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes, for a module that allocates its own slot and cannot see the C type.
    public static let byteCount = MemoryLayout<clipMap_t>.size

    /// The distance between two slots of a C array of this type, for a Slots over one.
    public static let stride = MemoryLayout<clipMap_t>.stride

    /// Raven's `memset(&cm, 0, sizeof(cm))`, every byte of the slot to zero.
    public func clear() {
        self.raw.pointee = clipMap_t()
    }

    /// Raven's `clipMap_t cmg` at file scope, one zeroed record that the engine world owns.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:37
    // AI: Raven's `cmg` is a C global. The record is one zeroed allocation, because the generated storage holds no record without a generated view.
    public static func record() -> ClipMap {
        let base = UnsafeMutableRawPointer.allocate(byteCount: ClipMap.byteCount, alignment: 16)
        base.initializeMemory(as: UInt8.self, repeating: 0, count: ClipMap.byteCount)
        return ClipMap(base)
    }

    /// Raven's `clipMap_t SubBSP[MAX_SUB_BSP]` at file scope, one zeroed C array that the engine world owns.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:60
    // AI: Raven's `SubBSP` is a C global array. The table is one zeroed allocation with the stride of the C type, because the generated storage holds no table without a generated view.
    public static func records(count: Int) -> Slots<ClipMap> {
        let base = UnsafeMutableRawPointer.allocate(byteCount: count * ClipMap.stride, alignment: 16)
        base.initializeMemory(as: UInt8.self, repeating: 0, count: count * ClipMap.stride)
        return Slots(views: base, count: count, stride: ClipMap.stride)
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:162
    public var name: String {
        get { cString(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!), capacity: Int(JKAShared.MAX_QPATH)) }
    }

    /// Raven's `name` as the buffer a callee writes into, for a `char *` parameter the port spells `inout CharBuf`.
    public var nameBuffer: JKAShared.CharBuf {
        get { charBuf(at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!), capacity: Int(JKAShared.MAX_QPATH)) }
        nonmutating set { store(newValue, at: UnsafeMutableRawPointer(self.raw.pointer(to: \.name)!), capacity: Int(JKAShared.MAX_QPATH)) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:164
    public var numShaders: Int32 {
        get { self.raw.pointee.numShaders }
        nonmutating set { self.raw.pointee.numShaders = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:167
    public var numBrushSides: Int32 {
        get { self.raw.pointee.numBrushSides }
        nonmutating set { self.raw.pointee.numBrushSides = newValue }
    }

    /// Raven's `brushsides[i]`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:168
    public var brushsidesSlots: Slots<Cbrushside> {
        get {
            precondition(self.raw.pointee.brushsides != nil, "brushsides is NULL")
            return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.brushsides!), count: Int.max, stride: Cbrushside.stride)
        }
        nonmutating set { self.raw.pointee.brushsides = newValue.base.assumingMemoryBound(to: cbrushside_t.self) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:170
    public var numPlanes: Int32 {
        get { self.raw.pointee.numPlanes }
        nonmutating set { self.raw.pointee.numPlanes = newValue }
    }

    /// Raven's `planes[i]`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:171
    public var planesSlots: Slots<Cplane> {
        get {
            precondition(self.raw.pointee.planes != nil, "planes is NULL")
            return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.planes!), count: Int.max, stride: Cplane.stride)
        }
        nonmutating set { self.raw.pointee.planes = newValue.base.assumingMemoryBound(to: cplane_t.self) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:173
    public var numNodes: Int32 {
        get { self.raw.pointee.numNodes }
        nonmutating set { self.raw.pointee.numNodes = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:176
    public var numLeafs: Int32 {
        get { self.raw.pointee.numLeafs }
        nonmutating set { self.raw.pointee.numLeafs = newValue }
    }

    /// Raven's `leafs[i]`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:177
    public var leafsSlots: Slots<CLeaf> {
        get {
            precondition(self.raw.pointee.leafs != nil, "leafs is NULL")
            return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.leafs!), count: Int.max, stride: CLeaf.stride)
        }
        nonmutating set { self.raw.pointee.leafs = newValue.base.assumingMemoryBound(to: cLeaf_t.self) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:179
    public var numLeafBrushes: Int32 {
        get { self.raw.pointee.numLeafBrushes }
        nonmutating set { self.raw.pointee.numLeafBrushes = newValue }
    }

    /// Raven's `int *leafbrushes`, the brush numbers of every leaf, with the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:180
    // AI: Raven indexes an `int *` field. The accessor spells it as a Slots of the scalar with the widest count, the form of a `bytes` field.
    public var leafbrushes: Slots<Int32>? {
        get { self.raw.pointee.leafbrushes.map { Slots(scalars: UnsafeMutableRawPointer($0), count: Int.max) } }
        nonmutating set { self.raw.pointee.leafbrushes = newValue?.base.assumingMemoryBound(to: Int32.self) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:182
    public var numLeafSurfaces: Int32 {
        get { self.raw.pointee.numLeafSurfaces }
        nonmutating set { self.raw.pointee.numLeafSurfaces = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:185
    public var numSubModels: Int32 {
        get { self.raw.pointee.numSubModels }
        nonmutating set { self.raw.pointee.numSubModels = newValue }
    }

    /// Raven's `cmodels[i]`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:186
    public var cmodelsSlots: Slots<Cmodel> {
        get {
            precondition(self.raw.pointee.cmodels != nil, "cmodels is NULL")
            return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.cmodels!), count: Int.max, stride: Cmodel.stride)
        }
        nonmutating set { self.raw.pointee.cmodels = newValue.base.assumingMemoryBound(to: cmodel_t.self) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:188
    public var numBrushes: Int32 {
        get { self.raw.pointee.numBrushes }
        nonmutating set { self.raw.pointee.numBrushes = newValue }
    }

    /// Raven's `brushes[i]`, the records the pointer holds. A NULL pointer traps with the field's name.
    /// C gives the pointer no bound, so the Slots takes the widest count.
    /// Source: oracle/codemp/qcommon/cm_local.h:189
    public var brushesSlots: Slots<Cbrush> {
        get {
            precondition(self.raw.pointee.brushes != nil, "brushes is NULL")
            return Slots(views: UnsafeMutableRawPointer(self.raw.pointee.brushes!), count: Int.max, stride: Cbrush.stride)
        }
        nonmutating set { self.raw.pointee.brushes = newValue.base.assumingMemoryBound(to: cbrush_t.self) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:191
    public var numClusters: Int32 {
        get { self.raw.pointee.numClusters }
        nonmutating set { self.raw.pointee.numClusters = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:192
    public var clusterBytes: Int32 {
        get { self.raw.pointee.clusterBytes }
        nonmutating set { self.raw.pointee.clusterBytes = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:194
    public var vised: Bool {
        get { self.raw.pointee.vised != qfalse }
        nonmutating set { self.raw.pointee.vised = newValue ? qtrue : qfalse }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:196
    public var numEntityChars: Int32 {
        get { self.raw.pointee.numEntityChars }
        nonmutating set { self.raw.pointee.numEntityChars = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:197
    public var entityString: String? {
        get { self.raw.pointee.entityString.map { cString(at: $0) } }
        nonmutating set { self.raw.pointee.entityString = StringPool.shared.pointer(for: newValue) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:199
    public var numAreas: Int32 {
        get { self.raw.pointee.numAreas }
        nonmutating set { self.raw.pointee.numAreas = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:203
    public var numSurfaces: Int32 {
        get { self.raw.pointee.numSurfaces }
        nonmutating set { self.raw.pointee.numSurfaces = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:206
    public var floodvalid: Int32 {
        get { self.raw.pointee.floodvalid }
        nonmutating set { self.raw.pointee.floodvalid = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:207
    public var checkcount: Int32 {
        get { self.raw.pointee.checkcount }
        nonmutating set { self.raw.pointee.checkcount = newValue }
    }

    /// Raven's `CCMLandScape *landScape`, a handle to the terrain class that row E5 links as C++.
    /// Source: oracle/codemp/qcommon/cm_local.h:210
    public var landScape: OpaquePointer? {
        get { self.raw.pointee.landScape }
        nonmutating set { self.raw.pointee.landScape = newValue }
    }
}

/// Source: oracle/codemp/qcommon/cm_local.h:68
/// A view over one `cbrush_t` in C memory.
/// A copy of a view is a copy of the pointer, and two views of one slot compare equal.
// AI: Raven's `cbrush_t` has no root in the view generator. This hand view gives the fields that the cm_load bodies read, in the generated form.
public struct Cbrush: Hashable, HandleView {
    let raw: UnsafeMutablePointer<cbrush_t>

    init(raw: UnsafeMutablePointer<cbrush_t>) { self.raw = raw }

    /// The slot behind a handle a generated thunk received. Rule 11 confines the handle to generated code.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(cbrush_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: cbrush_t.self) }

    /// Raven's cast from another struct's pointer over the same memory, `(cbrush_t *)other`.
    public init(_ other: some HandleView) { self.raw = UnsafeMutablePointer(other.handle) }

    /// The slot as a handle, for a stored function call and for a view in another module.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes, for a module that allocates its own slot and cannot see the C type.
    public static let byteCount = MemoryLayout<cbrush_t>.size

    /// The distance between two slots of a C array of this type, for a Slots over one.
    public static let stride = MemoryLayout<cbrush_t>.stride

    /// Source: oracle/codemp/qcommon/cm_local.h:69
    public var shaderNum: Int32 {
        get { self.raw.pointee.shaderNum }
        nonmutating set { self.raw.pointee.shaderNum = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:70
    public var contents: Int32 {
        get { self.raw.pointee.contents }
        nonmutating set { self.raw.pointee.contents = newValue }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:71
    public var bounds: Slots<JKAShared.vec3_t> { Slots(vectors: UnsafeMutableRawPointer(self.raw.pointer(to: \.bounds)!), count: 2) }

    /// Source: oracle/codemp/qcommon/cm_local.h:72
    public var sides: Cbrushside? {
        get { self.raw.pointee.sides.map { Cbrushside(handle: OpaquePointer($0)) } }
        nonmutating set { self.raw.pointee.sides = UnsafeMutablePointer(newValue?.handle) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:73
    public var numsides: Int32 {
        get { Int32(self.raw.pointee.numsides) }
        nonmutating set { self.raw.pointee.numsides = UInt16(truncatingIfNeeded: newValue) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:74
    public var checkcount: Int32 {
        get { Int32(self.raw.pointee.checkcount) }
        nonmutating set { self.raw.pointee.checkcount = UInt16(truncatingIfNeeded: newValue) }
    }
}

/// Source: oracle/codemp/qcommon/cm_local.h:61
/// A view over one `cbrushside_t` in C memory.
/// A copy of a view is a copy of the pointer, and two views of one slot compare equal.
// AI: Raven's `cbrushside_t` has no root in the view generator. This hand view gives the fields that the cm_load bodies read, in the generated form.
public struct Cbrushside: Hashable, HandleView {
    let raw: UnsafeMutablePointer<cbrushside_t>

    init(raw: UnsafeMutablePointer<cbrushside_t>) { self.raw = raw }

    /// The slot behind a handle a generated thunk received. Rule 11 confines the handle to generated code.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutablePointer(handle) }

    /// Raven's cast from a raw pointer, `(cbrushside_t *)p`. A body writes this where and only where Raven wrote the cast.
    public init(_ raw: UnsafeMutableRawPointer) { self.raw = raw.assumingMemoryBound(to: cbrushside_t.self) }

    /// Raven's cast from another struct's pointer over the same memory, `(cbrushside_t *)other`.
    public init(_ other: some HandleView) { self.raw = UnsafeMutablePointer(other.handle) }

    /// The slot as a handle, for a stored function call and for a view in another module.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The size of one slot in bytes, for a module that allocates its own slot and cannot see the C type.
    public static let byteCount = MemoryLayout<cbrushside_t>.size

    /// The distance between two slots of a C array of this type, for a Slots over one.
    public static let stride = MemoryLayout<cbrushside_t>.stride

    /// Source: oracle/codemp/qcommon/cm_local.h:62
    public var plane: Cplane? {
        get { self.raw.pointee.plane.map { Cplane(handle: OpaquePointer($0)) } }
        nonmutating set { self.raw.pointee.plane = UnsafeMutablePointer(newValue?.handle) }
    }

    /// Source: oracle/codemp/qcommon/cm_local.h:63
    public var shaderNum: Int32 {
        get { self.raw.pointee.shaderNum }
        nonmutating set { self.raw.pointee.shaderNum = newValue }
    }
}

extension Cplane {
    /// Raven's `box_planes[i]` and `&box_planes[i]` through a `cplane_t *` variable, the plane `i` slots past this one.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:962
    // AI: Raven indexes a `cplane_t *` variable as an array. The subscript gives the view `i` slots past this one, because the generated variable holds one view.
    public subscript(i: some BinaryInteger) -> Cplane {
        Cplane(UnsafeMutableRawPointer(self.handle) + Int(i) * Cplane.stride)
    }
}
