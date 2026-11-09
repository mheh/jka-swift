import JKAShared

/// This finds the last byte equal to `c`, and returns its offset, or `nil` when there is no match.
/// A match against 0 finds the terminating NUL, the same as Raven's `strrchr(s, c)` of the C library.
/// Source: oracle/codemp/qcommon/stringed_ingame.cpp:168
// AI: Raven calls the C library's strrchr on a `char` array. The function returns the offset of the byte in the CharBuf, the form of strchr in CString.swift.
public func strrchr(_ s: CharBuf, _ c: Int32) -> Int32? {
    let target: Int32 = Int32(UInt8(truncatingIfNeeded: c))
    var found: Int32? = nil
    var i: Int32 = 0
    while i < Int32(s.count) {
        let byte: UInt8 = s[i]
        if Int32(byte) == target {
            found = i
        }
        if byte == 0 {
            break
        }
        i += 1
    }
    return found
}
