// MARK: - Native byte order

extension UInt32 {
    /// Raven's `*(unsigned *)b` over a `byte b[4]`, the four bytes read as one `unsigned` in the native byte order.
    /// The array must hold four bytes, or this traps.
    public init(nativeBytes bytes: [UInt8]) {
        precondition(bytes.count == 4, "UInt32(nativeBytes:) takes four bytes")
        var value: UInt32 = 0
        withUnsafeMutableBytes(of: &value) { raw in
            raw.copyBytes(from: bytes)
        }
        self = value
    }
}

/// Raven's `*(unsigned *)b = value` into a `byte b[4]`, the four bytes of `value` in the native byte order.
public func nativeBytes(of value: UInt32) -> [UInt8] {
    withUnsafeBytes(of: value) { raw in
        Array(raw)
    }
}
