import JKAShared

// MARK: - The sector tree of sv_world.cpp

/// Source: oracle/codemp/server/sv_world.cpp:48
/// A view over one `worldSector_t` in C memory, one node of the sector tree that `SV_LinkEntity` walks.
/// Raven's record is `int axis`, `float dist`, `struct worldSector_s *children[2]`, and `svEntity_t *entities`, so every field sits at its natural offset with no padding.
// AI: Raven defines worldSector_t inside sv_world.cpp. A C definition would change the generated `SvEntity.worldSector` field, so the hand view reads Raven's layout by offset.
public struct WorldSector: Hashable, HandleView {
    let raw: UnsafeMutableRawPointer

    /// The slot behind a handle. Rule 11 confines the handle to the view target.
    public init(handle: OpaquePointer) { self.raw = UnsafeMutableRawPointer(handle) }

    /// The slot as a handle, for a view in another module.
    public var handle: OpaquePointer { OpaquePointer(self.raw) }

    /// The offset of `children`, after the 4-byte `axis` and the 4-byte `dist`, which a pointer of 4 or 8 bytes needs no padding for.
    static let childrenOffset = MemoryLayout<Int32>.size + MemoryLayout<Float>.size

    /// The offset of `entities`, after the two pointers of `children`.
    static let entitiesOffset = WorldSector.childrenOffset + 2 * MemoryLayout<OpaquePointer?>.size

    /// The size of one slot in bytes, the size of Raven's `worldSector_t`.
    public static let byteCount = WorldSector.entitiesOffset + MemoryLayout<OpaquePointer?>.size

    /// The distance between two slots of a C array of this type.
    public static let stride = WorldSector.byteCount

    /// Source: oracle/codemp/server/sv_world.cpp:49
    public var axis: Int32 {
        get { self.raw.load(as: Int32.self) }
        nonmutating set { self.raw.storeBytes(of: newValue, as: Int32.self) }
    }

    /// Source: oracle/codemp/server/sv_world.cpp:50
    public var dist: Float {
        get { self.raw.load(fromByteOffset: MemoryLayout<Int32>.size, as: Float.self) }
        nonmutating set { self.raw.storeBytes(of: newValue, toByteOffset: MemoryLayout<Int32>.size, as: Float.self) }
    }

    /// Source: oracle/codemp/server/sv_world.cpp:51
    public var children: Slots<WorldSector?> {
        Slots(pointers: self.raw + WorldSector.childrenOffset, count: 2)
    }

    /// Source: oracle/codemp/server/sv_world.cpp:52
    public var entities: SvEntity? {
        get { self.raw.load(fromByteOffset: WorldSector.entitiesOffset, as: OpaquePointer?.self).map { SvEntity(handle: $0) } }
        nonmutating set { self.raw.storeBytes(of: newValue?.handle, toByteOffset: WorldSector.entitiesOffset, as: OpaquePointer?.self) }
    }

    /// Raven's `worldSector_t sv_worldSectors[AREA_NODES]`, one zeroed allocation of `count` nodes.
    /// The allocation lives as long as the process, as Raven's file-scope array does.
    /// Source: oracle/codemp/server/sv_world.cpp:58
    // AI: Raven holds the array as a file-scope global. The world owns one zeroed allocation in its place.
    public static func table(count: some BinaryInteger) -> Slots<WorldSector> {
        let base = UnsafeMutableRawPointer.allocate(byteCount: Int(count) * WorldSector.stride, alignment: MemoryLayout<OpaquePointer?>.alignment)
        base.initializeMemory(as: UInt8.self, repeating: 0, count: Int(count) * WorldSector.stride)
        return Slots(views: base, count: Int(count), stride: WorldSector.stride)
    }
}

extension SvEntity {
    /// Raven's `ent->worldSector`, the node of the sector tree that holds the entity, as a view.
    /// Source: oracle/codemp/server/server.h:28
    // AI: The generated field is an `OpaquePointer?`, because no view covers worldSector_t. The accessor reads and writes the same field as a WorldSector view.
    public var worldSectorNode: WorldSector? {
        get { self.worldSector.map { WorldSector(handle: $0) } }
        nonmutating set { self.worldSector = newValue?.handle }
    }
}
