import Testing
@testable import JKAShared

@Test("a scalar Slots reads and writes the C array in place")
func scalarSlotsReadsAndWrites() {
    let buffer = UnsafeMutableRawPointer.allocate(byteCount: 4 * MemoryLayout<Int32>.stride, alignment: 16)
    defer { buffer.deallocate() }
    let slots = Slots<Int32>(scalars: buffer, count: 4)

    for i in slots.indices {
        slots[i] = Int32(i * 10)
    }

    #expect(slots.count == 4)
    #expect(Array(slots) == [0, 10, 20, 30])
    #expect(buffer.load(fromByteOffset: 2 * MemoryLayout<Int32>.stride, as: Int32.self) == 20)
}

@Test("a flags Slots converts Raven's four-byte qboolean")
func flagSlotsConvertQboolean() {
    let buffer = UnsafeMutableRawPointer.allocate(byteCount: 2 * MemoryLayout<UInt32>.stride, alignment: 16)
    defer { buffer.deallocate() }
    let slots = Slots<Bool>(flags: buffer, count: 2)

    slots[0] = true
    slots[1] = false

    #expect(buffer.load(as: UInt32.self) == 1)
    #expect(slots[0])
    #expect(!slots[1])
}

@Test("a cStrings Slots writes at most capacity minus one byte and the NUL")
func cStringSlotsTruncateToCapacity() {
    let capacity = 8
    let buffer = UnsafeMutableRawPointer.allocate(byteCount: 2 * capacity, alignment: 16)
    defer { buffer.deallocate() }
    let slots = Slots<String>(cStrings: buffer, count: 2, capacity: capacity)

    slots[0] = "short"
    slots[1] = "far too long for the slot"

    #expect(slots[0] == "short")
    #expect(slots[1] == "far too")
}

@Test("a vectors Slots reads and writes Raven's float triple")
func vectorSlotsReadAndWriteTriples() {
    let buffer = UnsafeMutableRawPointer.allocate(byteCount: 2 * MemoryLayout<(Float, Float, Float)>.stride, alignment: 16)
    defer { buffer.deallocate() }
    let slots = Slots<vec3_t>(vectors: buffer, count: 2)

    slots[1] = vec3_t(1, 2, 3)

    #expect(slots[1] == vec3_t(1, 2, 3))
    #expect(buffer.load(fromByteOffset: MemoryLayout<(Float, Float, Float)>.stride, as: Float.self) == 1)
}

@Test("slot, suffix, and bytes give Slots over the same C memory")
func slotsAddressForms() {
    let buffer = UnsafeMutableRawPointer.allocate(byteCount: 4 * MemoryLayout<Int32>.stride, alignment: 16)
    defer { buffer.deallocate() }
    let slots = Slots<Int32>(scalars: buffer, count: 4)
    slots.fill(0)

    // when
    slots.slot(at: Int32(2))[0] = 7
    let tail = slots.suffix(from: 1)
    tail[0] = 5

    // then
    #expect(Array(slots) == [0, 5, 7, 0])
    #expect(tail.count == 3)
    #expect(slots.bytes.count == 4 * MemoryLayout<Int32>.stride)
    #expect(slots.bytes[MemoryLayout<Int32>.stride] == 5)
}

@Test("Com_Memcpy and memmove copy bytes between Slots and CharBuf as C does")
func slotsByteCopies() {
    let buffer = UnsafeMutableRawPointer.allocate(byteCount: 8, alignment: 16)
    defer { buffer.deallocate() }
    let bytes = Slots<byte>(scalars: buffer, count: 8)
    bytes.zero()

    // when
    Com_Memcpy(bytes.suffix(from: 2), CharBuf("abc"), 3)
    var line = CharBuf(4)
    Com_Memcpy(&line, bytes.suffix(from: 2), 3)
    memmove(bytes, bytes.suffix(from: 2), 3)

    // then
    #expect(String(line) == "abc")
    #expect(Array(bytes) == [97, 98, 99, 98, 99, 0, 0, 0])
}

@Test("Com_Memcpy over two Slots of one element type copies the count in bytes")
func slotsRecordCopy() {
    let source = UnsafeMutableRawPointer.allocate(byteCount: 3 * MemoryLayout<Int32>.stride, alignment: 16)
    let dest = UnsafeMutableRawPointer.allocate(byteCount: 3 * MemoryLayout<Int32>.stride, alignment: 16)
    defer {
        source.deallocate()
        dest.deallocate()
    }
    let from = Slots<Int32>(scalars: source, count: 3)
    let to = Slots<Int32>(scalars: dest, count: 3)
    to.fill(0)
    from[0] = 1
    from[1] = 2
    from[2] = 3

    // when
    Com_Memcpy(to, from, Int32(2 * MemoryLayout<Int32>.stride))

    // then
    #expect(Array(to) == [1, 2, 0])
}
