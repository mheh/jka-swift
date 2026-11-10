import JKAShared

// MARK: - The transformed vertices of a Ghoul2 trace

extension Slots where Element == byte {
    /// Raven's `(int)TransformedVerts`, the address of a block of this heap stored in an `int` slot of `TransformedVertsArray`.
    /// The slot holds the byte offset of the block from the base of the heap, which fits in 32 bits.
    /// Source: oracle/codemp/ghoul2/G2_misc.cpp:417
    // AI: Raven stores the pointer in an `int`. The slot holds the byte offset of the block in the heap, so the `int` keeps its width.
    public func offset(of block: Slots<byte>) -> Int32 {
        Int32(self.base.distance(to: block.base))
    }

    /// Raven's `(float *)TS.TransformedVertsArray[i]`, the floats of the block at a byte offset of this heap.
    /// Source: oracle/codemp/ghoul2/G2_misc.cpp:1097
    // AI: Raven casts the `int` back to a float pointer. The reader gives the floats from that byte offset to the end of the heap.
    public func floats(at offset: some BinaryInteger) -> Slots<Float> {
        let start = Int(offset)
        precondition(start >= 0 && start <= self.count, "Heap offset \(start) is out of the range 0...\(self.count)")
        return Slots<Float>(scalars: self.base + start, count: (self.count - start) / MemoryLayout<Float>.size)
    }
}
