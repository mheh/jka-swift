internal import CJKAMP_Ded
import JKAMP
import JKAShared

extension Cbrushside {
    /// Raven's `b->sides[i]` through a `cbrushside_t *` field, the side `i` slots past this one.
    /// Source: oracle/codemp/qcommon/cm_test.cpp:269
    // AI: Raven indexes a `cbrushside_t *` field as an array. The subscript gives the view `i` slots past this one, the form of the `Cplane` subscript.
    public subscript(i: some BinaryInteger) -> Cbrushside {
        Cbrushside(UnsafeMutableRawPointer(self.handle) + Int(i) * Cbrushside.stride)
    }
}

extension LeafList {
    /// Raven's `(cbrush_t **)ll->list`, the `int *list` field read and written as a table of brush pointers.
    /// Source: oracle/codemp/qcommon/cm_test.cpp:117
    // AI: Raven casts the `int *` field to `cbrush_t **` to store brush pointers. The accessor reads and writes the same word as a Slots of brush views, row N-LEAFLIST.
    public var listBrushes: Slots<Cbrush?>? {
        get { self.raw.pointee.list.map { Slots(pointers: UnsafeMutableRawPointer($0), count: Int.max) } }
        nonmutating set { self.raw.pointee.list = newValue?.base.assumingMemoryBound(to: Int32.self) }
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
