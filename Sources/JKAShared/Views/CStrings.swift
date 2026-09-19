/// This reads the NUL-terminated C string at an address.
public func cString(at address: UnsafeMutableRawPointer) -> String {
    String(cString: address.assumingMemoryBound(to: CChar.self))
}

/// This writes a Swift string into a C `char[capacity]` field.
/// At most `capacity - 1` UTF-8 bytes are copied, and the NUL follows, which is what Raven's `Q_strncpyz` did.
public func store(_ string: String, at address: UnsafeMutableRawPointer, capacity: Int) {
    precondition(capacity > 0, "a char array field has no room for the NUL")
    let length = min(string.utf8.count, capacity - 1)
    UnsafeMutableRawBufferPointer(start: address, count: length).copyBytes(from: string.utf8.prefix(length))
    address.storeBytes(of: 0, toByteOffset: length, as: CChar.self)
}

/// This reads a C `char[capacity]` field as the buffer a callee writes into.
/// The buffer holds the field's bytes as they are, NUL and all, because a callee reads and rewrites them the way C does.
public func charBuf(at address: UnsafeMutableRawPointer, capacity: Int) -> CharBuf {
    precondition(capacity > 0, "a char array field has no room for the NUL")
    var buf = CharBuf(capacity)
    buf.withUnsafeMutableRawPointer { $0.copyMemory(from: address, byteCount: capacity) }
    return buf
}

/// This writes a buffer back into a C `char[capacity]` field, the setter half of the read above.
/// At most `capacity` bytes are copied, so a shorter buffer leaves the bytes past its end as they were, as a C write does.
public func store(_ buf: CharBuf, at address: UnsafeMutableRawPointer, capacity: Int) {
    precondition(capacity > 0, "a char array field has no room for the NUL")
    let count = min(buf.count, capacity)
    buf.withUnsafeRawPointer { address.copyMemory(from: $0, byteCount: count) }
}
