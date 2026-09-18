import Testing
@testable import JKAShared

/// The tests allocate their own block, because the subscripts stand over engine-owned C memory the test target cannot reach.
private func withRawBlock(_ count: Int, _ body: (UnsafeMutableRawPointer) -> Void) {
    let block = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 16)
    block.initializeMemory(as: UInt8.self, repeating: 0, count: count)
    defer { block.deallocate() }
    body(block)
}

@Test("the byte slot stores and reads one byte at an offset")
func byteSlotStoresOneByte() {
    withRawBlock(16) { block in
        block[byte: 4] = 65
        let read: Int32 = block[byte: 4]

        #expect(read == 65)
        #expect(block[int: 0] == 0)
    }
}

@Test("the byte slot sign-extends on the way out and truncates on the way in")
func byteSlotSignExtendsAndTruncates() {
    withRawBlock(16) { block in
        block[byte: 0] = 0xFF
        let signed: Int32 = block[byte: 0]
        let unsigned: UInt8 = block[byte: 0]

        #expect(signed == -1)
        #expect(unsigned == 255)
    }
}

@Test("the byte slot writes the terminating NUL of a buffer the engine filled")
func byteSlotWritesTheTerminatingNul() {
    withRawBlock(16) { block in
        strcpy(block, "vehicles")
        block[byte: 4] = 0

        #expect(PooledString(block).string == "vehi")
    }
}

@Test("the pointer slot reads nil for a field the record never set")
func pointerSlotReadsNilForAnUnsetField() {
    withRawBlock(32) { block in
        #expect(block[pointer: 8] == nil)
    }
}

@Test("the pointer slot stores a raw pointer and reads the same one back")
func pointerSlotStoresAndReadsARawPointer() {
    withRawBlock(32) { block in
        let text = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
        defer { text.deallocate() }

        block[pointer: 8] = text
        strcpy(block[pointer: 8]!, "atst")

        #expect(block[pointer: 8] == text)
        #expect(PooledString(text).string == "atst")
    }
}
