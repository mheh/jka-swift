import JKAShared

/// This reads the three floats at a word the C side passes as a `vec3_t`.
public func vector(at handle: OpaquePointer) -> vec3_t {
    Slots(vectors: UnsafeMutableRawPointer(handle), count: 1)[0]
}

/// This reads the four floats at a word the C side passes as a `vec4_t`.
public func vector4(at handle: OpaquePointer) -> vec4_t {
    let floats = Slots<Float>(scalars: UnsafeMutableRawPointer(handle), count: 4)
    return vec4_t(floats[0], floats[1], floats[2], floats[3])
}

/// This reads the text at a word the C side passes as a `const char *`.
public func text(at handle: OpaquePointer) -> String {
    cString(at: UnsafeRawPointer(handle))
}

/// Raven's `va` ring at `q_shared.c:1019`, two buffers of 32000 bytes that the C side reads until the call after next.
private nonisolated(unsafe) let textRing = UnsafeMutableRawPointer.allocate(byteCount: 2 * 32000, alignment: 1)

/// The count of ring copies, Raven's `index` at `q_shared.c:1020`.
private nonisolated(unsafe) var textRingIndex = 0

/// This copies a text into the next buffer of the ring and returns the buffer's address, as Raven's `va` returns `buf`.
/// The bytes go through `CharBuf(_ string:)`, and a text of 32000 bytes or more is cut to 31999 and the NUL.
public func ringText(_ text: String) -> OpaquePointer {
    let buf = textRing + (textRingIndex & 1) * 32000
    textRingIndex += 1
    store(text, at: buf, capacity: 32000)
    return OpaquePointer(buf)
}

// MARK: - The handle forms of the array shapes

extension Slots {
    /// A C array of a scalar at a word the C side passes, such as the `qhandle_t *` of `feederItemText`.
    public init(scalars handle: OpaquePointer, count: Int) {
        self.init(scalars: UnsafeMutableRawPointer(handle), count: count)
    }

    /// A C array of `void *` at a word the C side passes, such as the `char **` of `runScript`.
    public init(opaque handle: OpaquePointer, count: Int) where Element == OpaquePointer? {
        self.init(opaque: UnsafeMutableRawPointer(handle), count: count)
    }
}
