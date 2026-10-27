extension String {
    /// This builds a string from an engine buffer up to the first NUL, through `String(_ buf:)`, so every byte comes back unchanged.
    /// It exists because the engine fills fixed buffers that end at the first NUL, not at the buffer's end.
    public init(nulTerminated buffer: [CChar]) {
        self.init(CharBuf(bytes: buffer))
    }
}
