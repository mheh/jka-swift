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
