/// A fixed-size byte buffer, the Swift form of Raven's `char buf[N]`, spelled `var readBuf = CharBuf(128)`.
/// The subscript sign-extends a byte on read and truncates on write, and it widens to the destination's type.
public struct CharBuf: ExpressibleByStringLiteral {
    private var bytes: [UInt8]

    /// The buffer's fixed byte count, Raven's `N` in `char buf[N]`.
    public let count: Int

    /// This builds a zero-filled buffer of `count` bytes, Raven's `char buf[N] = {0}`.
    public init(_ count: some BinaryInteger) {
        self.count = Int(count)
        self.bytes = [UInt8](repeating: 0, count: self.count)
    }

    /// This builds a buffer from a string's bytes plus a trailing NUL, Raven's `char buf[] = "text"`.
    /// This initializer and `String(_ buf:)` are the one Latin-1 codec between `String` and engine bytes, so engine text keeps every byte.
    public init(_ string: String) {
        // One byte for each scalar, the scalar value truncated to 8 bits.
        var bytes = string.unicodeScalars.map { UInt8(truncatingIfNeeded: $0.value) }
        bytes.append(0)
        self.count = bytes.count
        self.bytes = bytes
    }

    /// A string literal converts where Raven assigns one to a `char *` or a `char[]`.
    public init(stringLiteral literal: String) {
        self.init(literal)
    }

    /// This keeps every byte of a buffer the engine filled, so a NUL-separated list stays whole.
    public init(bytes: [CChar]) {
        self.count = bytes.count
        self.bytes = bytes.map { UInt8(bitPattern: $0) }
    }

    /// This reads the byte at `index`, sign-extended as C does for a signed `char`.
    private func signedByte(at index: Int) -> Int8 {
        precondition(index >= 0 && index < self.count, "CharBuf read past the end")
        return Int8(bitPattern: self.bytes[index])
    }

    /// This writes `value` at `index`, truncated down to one byte, Raven's implicit narrowing on assignment to a `char`.
    private mutating func setByte(_ value: some BinaryInteger, at index: Int) {
        precondition(index >= 0 && index < self.count, "CharBuf write past the end")
        self.bytes[index] = UInt8(truncatingIfNeeded: value)
    }

    /// The getter sign-extends the byte as C does for a signed `char`, so byte `0xFF` reads as `Int32(-1)` and as `UInt8(255)`.
    /// The setter truncates the stored value down to one byte, Raven's implicit narrowing on assignment to a `char`.
    @_disfavoredOverload
    public subscript<I: BinaryInteger, T: BinaryInteger>(i: I) -> T {
        get { T(truncatingIfNeeded: self.signedByte(at: Int(i))) }
        set { self.setByte(newValue, at: Int(i)) }
    }

    /// This concrete overload resolves a byte move between two `CharBuf` values, `readBuf[c] = powerBuf[i]`.
    public subscript<I: BinaryInteger>(i: I) -> Int8 {
        get { self.signedByte(at: Int(i)) }
        set { self.setByte(newValue, at: Int(i)) }
    }

    /// Raven's `&buf[start]`, a pointer into the buffer, as the bytes from that offset to the end.
    /// A read through the pointer reads this copy, `Q_strncmp("red", skinName[start...], 3)`.
    public subscript<I: BinaryInteger>(range: PartialRangeFrom<I>) -> CharBuf {
        let start = Int(range.lowerBound)
        precondition(start >= 0 && start <= self.count, "CharBuf offset past the end")
        var suffix = CharBuf(self.count - start)
        suffix.bytes = Array(self.bytes[start...])
        return suffix
    }

    /// Raven's `memset(buf, 0, sizeof(buf))`, every byte of the buffer to zero.
    public mutating func zero() {
        self.bytes = [UInt8](repeating: 0, count: self.count)
    }

    /// The body gets a raw pointer into the buffer to copy bytes in, for `CString.swift`'s `strcpy` and the rest.
    public mutating func withUnsafeMutableRawPointer<R>(_ body: (UnsafeMutableRawPointer) throws -> R) rethrows -> R {
        try self.bytes.withUnsafeMutableBytes { rawBuffer in
            try body(rawBuffer.baseAddress!)
        }
    }

    /// The body gets a raw pointer into the buffer to read bytes out, for `CString.swift`'s `strlen` and the rest.
    public func withUnsafeRawPointer<R>(_ body: (UnsafeRawPointer) throws -> R) rethrows -> R {
        try self.bytes.withUnsafeBytes { rawBuffer in
            try body(rawBuffer.baseAddress!)
        }
    }
}

// MARK: - String conversion

extension String {
    /// This reads a `CharBuf` up to its first NUL, or the whole buffer when it holds no NUL.
    /// It is the decode half of the codec of `CharBuf(_ string:)`, so every byte comes back unchanged.
    public init(_ buf: CharBuf) {
        // One scalar for each byte, U+0000 to U+00FF.
        var scalars = String.UnicodeScalarView()
        var index = 0
        while index < buf.count {
            let byte: UInt8 = buf[index]
            if byte == 0 { break }
            scalars.append(Unicode.Scalar(byte))
            index += 1
        }
        self = String(scalars)
    }
}
