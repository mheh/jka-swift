import JKAShared

extension Slots where Element == Node? {
    /// Raven's `(node_t **)*tppnode` and `*ppnode = (node_t *)huff->freelist`, the first slot read and written as the address of another slot.
    /// The free list of huff_t chains its free slots this way.
    /// Source: oracle/codemp/qcommon/huffman.cpp:54
    // AI: Raven casts a `node_t *` slot to `node_t **` to chain the free slots. The accessor reads and writes the slot as a slot address.
    public var slotAddress: Slots<Node?>? {
        get { self.base.load(as: UnsafeMutableRawPointer?.self).map { Slots(pointers: $0, count: 1) } }
        nonmutating set { self.base.storeBytes(of: newValue?.base, as: UnsafeMutableRawPointer?.self) }
    }
}
