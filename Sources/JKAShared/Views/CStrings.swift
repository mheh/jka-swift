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
