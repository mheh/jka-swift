@preconcurrency internal import CJKAMP_Ded
import JKAShared

// MARK: - Record arrays in a byte buffer

extension Slots where Element: HandleView {
    /// Raven's cast of a byte pointer to a record pointer that a body indexes, `(dshader_t *)(cmod_base + l->fileofs)`.
    /// The records must fit in the bytes, or the initializer traps where C reads past the buffer.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:81
    // AI: Raven casts the bytes of a lump to a record pointer. The initializer gives the Slots over the `count` records at the base of the byte Slots, the cast form of a view.
    public init(_ bytes: Slots<byte>, count: some BinaryInteger) {
        precondition(Int(count) >= 0 && Int(count) * Element.stride <= bytes.count, "The \(count) records run past the \(bytes.count) bytes of the buffer")
        self.init(views: bytes.base, count: Int(count), stride: Element.stride)
    }
}

// MARK: - A record at a byte offset of another record

extension HandleView {
    /// Raven's cast of a record address plus a byte offset to a record pointer, `(mdxaSkel_t *)((byte *)mdxa + sizeof(mdxaHeader_t) + offsets->offsets[i])`.
    /// The model files hold their records at byte offsets from a header, and an offset can be negative, as `ofsHeader` of a surface is.
    /// Source: oracle/codemp/ghoul2/G2_bones.cpp:46
    // AI: Raven adds a byte offset to the address of a record and casts the result. The initializer does the step in the view target.
    public init(_ record: some HandleView, byteOffset: some BinaryInteger) {
        self.init(handle: OpaquePointer(UnsafeMutableRawPointer(record.handle) + Int(byteOffset)))
    }
}

extension MdxmSurfHierarchy {
    /// Raven's `(int)( &((mdxmSurfHierarchy_t *)0)->childIndexes[ n ] )`, the size of a hierarchy record with `n` children.
    /// The walks of the hierarchy step to the next record by this size.
    /// Source: oracle/codemp/ghoul2/G2_surfaces.cpp:80
    // AI: Raven takes the address of child n of a null record pointer. The static gives the byte offset of child n, the form of `Winding.byteCount(points:)`.
    public static func byteCount(childIndexes n: some BinaryInteger) -> Int {
        MemoryLayout<mdxmSurfHierarchy_t>.offset(of: \mdxmSurfHierarchy_t.childIndexes)! + Int(n) * Int32.byteCount
    }
}

extension MdxaSkel {
    /// Raven's `(int)( &((mdxaSkel_t *)0)->children[ n ] )`, the size of a skeleton record with `n` children.
    /// Source: oracle/codemp/renderer/tr_model.cpp:769
    // AI: Raven takes the address of child n of a null record pointer. The static gives the byte offset of child n, the form of `Winding.byteCount(points:)`.
    public static func byteCount(children n: some BinaryInteger) -> Int {
        MemoryLayout<mdxaSkel_t>.offset(of: \mdxaSkel_t.children)! + Int(n) * Int32.byteCount
    }
}

// MARK: - The leaf index blocks of a clip map

extension ClipMap {
    /// Raven's `indexes - cm.leafbrushes`, the distance in words from the base of the table to a hunk block of brush indexes.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:154
    // AI: Raven subtracts two pointers into separate hunk blocks. The view gives the word distance, which can be negative, so the leaf keeps his number.
    public func leafbrushes(_ indexes: Slots<Int32>) -> Int32 {
        Int32(UnsafeMutableRawPointer(self.raw.pointee.leafbrushes!).distance(to: indexes.base) / MemoryLayout<Int32>.stride)
    }

    /// Raven's `indexes - cm.leafsurfaces`, the distance in words from the base of the table to a hunk block of surface indexes.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:161
    // AI: Raven subtracts two pointers into separate hunk blocks. The view gives the word distance, which can be negative, so the leaf keeps his number.
    public func leafsurfaces(_ indexes: Slots<Int32>) -> Int32 {
        Int32(UnsafeMutableRawPointer(self.raw.pointee.leafsurfaces!).distance(to: indexes.base) / MemoryLayout<Int32>.stride)
    }

    /// Raven's `cm.leafbrushes[index]`, the word at the index with no bound, which can reach a hunk block outside the table.
    /// Source: oracle/codemp/qcommon/cm_test.cpp:92
    // AI: Raven reads the word past the table when the leaf points into another block. The accessor reads at the base plus the index, as C does.
    public func leafbrush(at index: Int32) -> Int32 {
        self.raw.pointee.leafbrushes![Int(index)]
    }

    /// Raven's `cm.leafsurfaces[index]`, the word at the index with no bound, which can reach a hunk block outside the table.
    /// Source: oracle/codemp/qcommon/cm_trace.cpp:311
    // AI: Raven reads the word past the table when the leaf points into another block. The accessor reads at the base plus the index, as C does.
    public func leafsurface(at index: Int32) -> Int32 {
        self.raw.pointee.leafsurfaces![Int(index)]
    }
}
