/// A view over one C array in memory the world owns, at a base address with Raven's stride.
/// An element reads and writes in place through the two closures, so `client.ps.stats[STAT_HEALTH] = 100` reads as Raven wrote it.
/// A copy of a `Slots` is a copy of the base pointer, not of the array.
public struct Slots<Element>: RandomAccessCollection {
    // MARK: - State

    public let base: UnsafeMutableRawPointer
    public let count: Int
    public let stride: Int
    public let read: (UnsafeMutableRawPointer) -> Element
    public let write: (UnsafeMutableRawPointer, Element) -> Void

    public var startIndex: Int { 0 }
    public var endIndex: Int { self.count }

    public init(
        base: UnsafeMutableRawPointer,
        count: Int,
        stride: Int,
        read: @escaping (UnsafeMutableRawPointer) -> Element,
        write: @escaping (UnsafeMutableRawPointer, Element) -> Void
    ) {
        self.base = base
        self.count = count
        self.stride = stride
        self.read = read
        self.write = write
    }

    public subscript(i: Int) -> Element {
        get {
            precondition(i >= 0 && i < self.count, "Slots index \(i) is out of the range 0..<\(self.count)")
            return self.read(self.base + i * self.stride)
        }
        nonmutating set {
            precondition(i >= 0 && i < self.count, "Slots index \(i) is out of the range 0..<\(self.count)")
            self.write(self.base + i * self.stride, newValue)
        }
    }

    /// Raven's `memset(table, 0, sizeof(table))`, every byte of every slot to zero.
    public func zero() {
        self.base.initializeMemory(as: UInt8.self, repeating: 0, count: self.count * self.stride)
    }
}

// MARK: - The array shapes of the conversion table

extension Slots {
    /// A C array of a scalar, loaded and stored directly.
    public init(scalars base: UnsafeMutableRawPointer, count: Int) {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<Element>.stride,
            read: { $0.load(as: Element.self) },
            write: { $0.storeBytes(of: $1, as: Element.self) }
        )
    }

    /// A C array of a struct, one view per slot. The write copies `stride` bytes, which is C struct assignment.
    public init(views base: UnsafeMutableRawPointer, count: Int, stride: Int) where Element: HandleView {
        self.init(
            base: base,
            count: count,
            stride: stride,
            read: { Element(handle: OpaquePointer($0)) },
            write: { $0.copyMemory(from: UnsafeRawPointer($1.handle), byteCount: stride) }
        )
    }

    /// One C record where the port holds a table, the Slots of one record over it.
    /// Raven hands one record to a pointer his callee walks, and the record is the first element of this `Slots`.
    public init(record: Element) where Element: HandleView {
        self.init(views: UnsafeMutableRawPointer(record.handle), count: 1, stride: Element.stride)
    }

    /// A C array of a pointer to a copied struct, one optional view per slot.
    public init<V: HandleView>(pointers base: UnsafeMutableRawPointer, count: Int) where Element == V? {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<OpaquePointer?>.stride,
            read: { $0.load(as: OpaquePointer?.self).map { V(handle: $0) } },
            write: { $0.storeBytes(of: $1?.handle, as: OpaquePointer?.self) }
        )
    }

    /// A C array of `void *`.
    public init(opaque base: UnsafeMutableRawPointer, count: Int) where Element == OpaquePointer? {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<OpaquePointer?>.stride,
            read: { $0.load(as: OpaquePointer?.self) },
            write: { $0.storeBytes(of: $1, as: OpaquePointer?.self) }
        )
    }

    /// A C array of `qboolean`, a 4-byte C enum. Rule 7 converts it at the field.
    public init(flags base: UnsafeMutableRawPointer, count: Int) where Element == Bool {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<UInt32>.stride,
            read: { $0.load(as: UInt32.self) != 0 },
            write: { $0.storeBytes(of: $1 ? 1 : 0, as: UInt32.self) }
        )
    }

    /// A C array of `char *`, one text per slot. A store interns the text in the shared pool.
    public init(strings base: UnsafeMutableRawPointer, count: Int) where Element == String? {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<UnsafeMutablePointer<CChar>?>.stride,
            read: { $0.load(as: UnsafeMutablePointer<CChar>?.self).map { String(cString: $0) } },
            write: { $0.storeBytes(of: StringPool.shared.pointer(for: $1), as: UnsafeMutablePointer<CChar>?.self) }
        )
    }

    /// A C array of `char[capacity]`, one string per slot, with Raven's `Q_strncpyz` bound on the write.
    public init(cStrings base: UnsafeMutableRawPointer, count: Int, capacity: Int) where Element == String {
        self.init(
            base: base,
            count: count,
            stride: capacity,
            read: { cString(at: $0) },
            write: { store($1, at: $0, capacity: capacity) }
        )
    }

    /// A C array of `vec3_t`, which the importer gives as a tuple of three floats.
    public init(vectors base: UnsafeMutableRawPointer, count: Int) where Element == vec3_t {
        self.init(
            base: base,
            count: count,
            stride: MemoryLayout<(Float, Float, Float)>.stride,
            read: { vec3(of: $0.load(as: (Float, Float, Float).self)) },
            write: { $0.storeBytes(of: tuple(of: $1), as: (Float, Float, Float).self) }
        )
    }

    /// A two-dimensional C array, one inner `Slots` per row.
    /// A write traps, because Raven never assigns a whole row, it writes the elements of one.
    public init<Inner>(
        rows base: UnsafeMutableRawPointer,
        count: Int,
        stride: Int,
        make: @escaping (UnsafeMutableRawPointer) -> Slots<Inner>
    ) where Element == Slots<Inner> {
        self.init(
            base: base,
            count: count,
            stride: stride,
            read: { make($0) },
            write: { _, _ in fatalError("Raven never assigns a whole row, so write the elements of the row instead") }
        )
    }
}

// MARK: - The slot index

extension Slots where Element: HandleView {
    /// Raven's `client - level.clients`, the slot number of a record in this table, from the distance between the two addresses.
    /// A record outside the table traps, where Raven's subtraction gives a number past the end.
    public func index(of record: Element) -> Int32 {
        let offset = self.base.distance(to: UnsafeMutableRawPointer(record.handle))
        precondition(
            offset >= 0 && offset % self.stride == 0 && offset / self.stride < self.count,
            "The record at byte offset \(offset) is not a slot of this table"
        )
        return Int32(offset / self.stride)
    }
}

// MARK: - The fill of a whole array

extension Slots {
    /// Raven's `memset(pVeh->m_iExhaustTag, -1, sizeof(int) * MAX_VEHICLE_EXHAUSTS)` over the whole array, one value into every slot.
    public func fill(_ value: Element) {
        for i in 0..<self.count {
            self[i] = value
        }
    }
}

extension Array {
    /// Raven's `memset(totalDmg, 0, sizeof(totalDmg))` over a whole local or file-scope array, one value into every element.
    public mutating func fill(_ value: Element) {
        for i in self.indices {
            self[i] = value
        }
    }

    /// Raven's memset over a whole two-dimensional array, `memset(G_WeaponLogPickups, 0, sizeof(G_WeaponLogPickups))`, one value into every element of every row.
    public mutating func fill<Inner>(_ value: Inner) where Element == [Inner] {
        for i in self.indices {
            self[i].fill(value)
        }
    }
}
