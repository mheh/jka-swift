import Testing
@testable import JKAShared

@Test("a buffer with a NUL in the middle stops at the NUL")
func bufferWithMidNulStopsThere() {
    let buffer: [CChar] = [104, 105, 0, 120, 120, 120] // "hi\0xxx"

    #expect(String(nulTerminated: buffer) == "hi")
}

@Test("a full buffer with no NUL reads to the end")
func fullBufferWithNoNulReadsToEnd() {
    let buffer: [CChar] = [104, 105] // "hi"

    #expect(String(nulTerminated: buffer) == "hi")
}

@Test("an empty buffer reads as an empty string")
func emptyBufferReadsAsEmptyString() {
    let buffer: [CChar] = []

    #expect(String(nulTerminated: buffer) == "")
}
