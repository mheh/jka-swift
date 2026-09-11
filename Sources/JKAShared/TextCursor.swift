/// Raven's `const char *p` into a text buffer, which the `COM_Parse` family advances and sets to NULL at the end.
/// The cursor holds the buffer it walks and a byte offset, and `nil` is Raven's NULL, so `while (p)` reads `while !p.isNull`.
public struct TextCursor {
    /// The text the cursor walks, a copy-on-write value, so a parser's reads cost nothing.
    public var buf: CharBuf

    /// The byte offset of the next character, or `nil` for Raven's NULL cursor.
    public var offset: Int32?

    /// Raven's `p = buf`, a cursor at the start of the text.
    public init(_ buf: CharBuf) {
        self.buf = buf
        self.offset = 0
    }

    /// Raven's `p = NULL`.
    public init() {
        self.buf = CharBuf(1)
        self.offset = nil
    }

    /// Raven's `!p`.
    public var isNull: Bool { self.offset == nil }

    /// The byte under the cursor, widened as a `CharBuf` read is, and 0 past the end or on a NULL cursor.
    public var byte: Int32 {
        guard let offset = self.offset, offset < Int32(self.buf.count) else { return 0 }
        return self.buf[offset]
    }

    /// Raven's `p++`.
    public mutating func advance() {
        if let offset = self.offset { self.offset = offset + 1 }
    }
}
