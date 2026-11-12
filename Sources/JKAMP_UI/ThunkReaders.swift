import JKAShared

/// This reads the four floats at a word the C side passes as a `vec4_t`.
public func vector4(at handle: OpaquePointer) -> vec4_t {
    let floats = Slots<Float>(scalars: UnsafeMutableRawPointer(handle), count: 4)
    return vec4_t(floats[0], floats[1], floats[2], floats[3])
}

/// This reads the text at a word the C side passes as a `const char *`.
public func text(at handle: OpaquePointer) -> String {
    cString(at: UnsafeRawPointer(handle))
}
