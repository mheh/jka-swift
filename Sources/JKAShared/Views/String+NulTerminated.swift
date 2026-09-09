extension String {
    /// This builds a string from a `[CChar]` buffer, stopping at the first NUL.
    /// It exists because the engine fills fixed buffers that end at the first NUL, not at the buffer's end.
    public init(nulTerminated buffer: [CChar]) {
        let end = buffer.firstIndex(of: 0) ?? buffer.endIndex
        let bytes = buffer[..<end].map { UInt8(bitPattern: $0) }
        self = String(decoding: bytes, as: UTF8.self)
    }
}
