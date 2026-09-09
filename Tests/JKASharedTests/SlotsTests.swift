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
