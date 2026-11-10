import JKAShared

// MARK: - Record arrays of the server files

extension Slots where Element: HandleView {
    /// Raven's cast of an allocation to a record pointer that a body indexes, `(client_t *)Hunk_AllocateTempMemory( count * sizeof(client_t) )`.
    /// Source: oracle/codemp/server/sv_init.cpp:323
    // AI: Raven indexes the cast pointer as a C array. The initializer gives the Slots over the `count` records, the cast form of a view.
    public init(_ raw: UnsafeMutableRawPointer, count: some BinaryInteger) {
        self.init(views: raw, count: Int(count), stride: Element.stride)
    }

    /// Raven's C++ `new T[count]` of a record array, `new entityState_s[svs.numSnapshotEntities]`.
    /// The records are not zeroed, as the C++ `new` of a C struct leaves them, and `delete()` frees them.
    /// Source: oracle/codemp/server/sv_init.cpp:594
    // AI: Raven allocates the array with the C++ `new`. The Swift allocator gives the records in the view target.
    public static func new(count: some BinaryInteger) -> Slots<Element> {
        let base = UnsafeMutableRawPointer.allocate(byteCount: Int(count) * Element.stride, alignment: 16)
        return Slots(views: base, count: Int(count), stride: Element.stride)
    }

    /// Raven's C++ `delete[]` of a record array that `new(count:)` gave, `delete[] svs.snapshotEntities`.
    /// Source: oracle/codemp/server/sv_init.cpp:495
    // AI: Raven frees the array with the C++ `delete[]`. The Swift allocator frees the records in the view target.
    public func delete() {
        self.base.deallocate()
    }

    /// Raven's `memset( base, 0, sizeof(T) * count )` over the first `count` records of a pointer with no bound.
    /// Source: oracle/codemp/server/sv_init.cpp:596
    // AI: Raven zeroes `count` records from the address of a pointer field. The Slots of that field has no bound, so the call takes Raven's count.
    public func zero(count: some BinaryInteger) {
        precondition(Int(count) >= 0 && Int(count) <= self.count, "Slots zero count \(count) is out of the range 0...\(self.count)")
        self.base.initializeMemory(as: UInt8.self, repeating: 0, count: Int(count) * self.stride)
    }
}

extension Slots where Element == byte {
    /// Raven's C library `malloc( size )` of a byte block, the heap of `CMiniHeap`.
    /// The bytes are not zeroed, as `malloc` leaves them, and `free()` frees them.
    /// Source: oracle/codemp/qcommon/MiniHeap.h:22
    // AI: Raven allocates the heap with the C library malloc. The Swift allocator gives the bytes in the view target.
    public static func malloc(_ size: some BinaryInteger) -> Slots<byte> {
        let base = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 16)
        return Slots(scalars: base, count: Int(size))
    }

    /// Raven's C library `free( mHeap )` of a byte block that `malloc(_:)` gave.
    /// Source: oracle/codemp/qcommon/MiniHeap.h:35
    // AI: Raven frees the heap with the C library free. The Swift allocator frees the bytes in the view target.
    public func free() {
        self.base.deallocate()
    }
}
