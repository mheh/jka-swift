/// This file holds the libc names Raven calls: `atoi`, `atof`, `strlen`, `strcpy`, `strncpy`, `strcat`, `strcmp`, `strchr`, `strstr`, `memset`, `tolower`, and `toupper`.
/// A ported body spells the call as Raven wrote it, over `CharBuf`, `String`, or `PooledString`.
/// Each function works over raw bytes, with C semantics, and a `String` argument reaches its bytes through `CharBuf(_ string:)`.
/// `atof` returns `Double` as C's does, and the rest narrow to `Int32` once inside.

// MARK: - Byte access

private extension CharBuf {
    /// This gives the buffer's `count` bytes for a read, for the functions below.
    func withBytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
        self.withUnsafeRawPointer { base in
            body(UnsafeRawBufferPointer(start: base, count: self.count))
        }
    }

    /// This gives the buffer's `count` bytes for a write, for the functions below.
    mutating func withMutableBytes<R>(_ body: (UnsafeMutableRawBufferPointer) -> R) -> R {
        let count = self.count
        return self.withUnsafeMutableRawPointer { base in
            body(UnsafeMutableRawBufferPointer(start: base, count: count))
        }
    }
}

private func cLength(of raw: UnsafeMutablePointer<CChar>) -> Int {
    var index = 0
    while raw[index] != 0 {
        index += 1
    }
    return index
}

// MARK: - atoi

/// This scans past leading spaces, tabs, and newlines, an optional sign, then digits.
/// The result wraps with `Int32(truncatingIfNeeded:)` on overflow, because C's overflow is undefined and the wrap is the divergence rule 19 allows.
private func atoiCore<C: RandomAccessCollection>(_ bytes: C) -> Int32 where C.Element == UInt8, C.Index == Int {
    var i = bytes.startIndex
    let end = bytes.endIndex
    while i < end, bytes[i] == UInt8(ascii: " ") || bytes[i] == UInt8(ascii: "\t") || bytes[i] == UInt8(ascii: "\n") {
        i += 1
    }
    var negative = false
    if i < end, bytes[i] == UInt8(ascii: "+") || bytes[i] == UInt8(ascii: "-") {
        negative = bytes[i] == UInt8(ascii: "-")
        i += 1
    }
    var value = 0
    var sawDigit = false
    while i < end, (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(bytes[i]) {
        sawDigit = true
        value = value * 10 + Int(bytes[i] - UInt8(ascii: "0"))
        i += 1
    }
    guard sawDigit else { return 0 }
    return Int32(truncatingIfNeeded: negative ? -value : value)
}

/// This parses Raven's `atoi(s)`.
public func atoi(_ s: CharBuf) -> Int32 {
    s.withBytes { atoiCore($0) }
}

/// This parses Raven's `atoi(s)` over a Swift string.
public func atoi(_ s: String) -> Int32 {
    atoi(CharBuf(s))
}

// MARK: - atof

/// This scans the decimal forms Raven writes: a sign, digits, one point, digits, and an optional exponent.
/// The digits parse as `Double`, the C return type, so a store into a `float` narrows once at the site.
private func atofCore<C: RandomAccessCollection>(_ bytes: C) -> Double where C.Element == UInt8, C.Index == Int {
    var i = bytes.startIndex
    let end = bytes.endIndex
    while i < end, bytes[i] == UInt8(ascii: " ") || bytes[i] == UInt8(ascii: "\t") || bytes[i] == UInt8(ascii: "\n") {
        i += 1
    }
    var text = ""
    if i < end, bytes[i] == UInt8(ascii: "+") || bytes[i] == UInt8(ascii: "-") {
        text.append(Character(UnicodeScalar(bytes[i])))
        i += 1
    }
    var sawDigit = false
    while i < end, (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(bytes[i]) {
        sawDigit = true
        text.append(Character(UnicodeScalar(bytes[i])))
        i += 1
    }
    if i < end, bytes[i] == UInt8(ascii: ".") {
        text.append(".")
        i += 1
        while i < end, (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(bytes[i]) {
            sawDigit = true
            text.append(Character(UnicodeScalar(bytes[i])))
            i += 1
        }
    }
    guard sawDigit else { return 0 }
    if i < end, bytes[i] == UInt8(ascii: "e") || bytes[i] == UInt8(ascii: "E") {
        var exponentText = String(Character(UnicodeScalar(bytes[i])))
        var j = i + 1
        if j < end, bytes[j] == UInt8(ascii: "+") || bytes[j] == UInt8(ascii: "-") {
            exponentText.append(Character(UnicodeScalar(bytes[j])))
            j += 1
        }
        var sawExponentDigit = false
        while j < end, (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(bytes[j]) {
            sawExponentDigit = true
            exponentText.append(Character(UnicodeScalar(bytes[j])))
            j += 1
        }
        if sawExponentDigit {
            text += exponentText
        }
    }
    return Double(text) ?? 0
}

/// This parses Raven's `atof(s)`.
public func atof(_ s: CharBuf) -> Double {
    s.withBytes { atofCore($0) }
}

/// This parses Raven's `atof(s)` over a Swift string.
public func atof(_ s: String) -> Double {
    atof(CharBuf(s))
}

// MARK: - strlen

/// This counts the bytes up to the first NUL, Raven's `strlen(s)`, narrowed to `Int32` once inside.
public func strlen(_ s: CharBuf) -> Int32 {
    s.withBytes { bytes in
        var i = 0
        while i < bytes.count, bytes[i] != 0 {
            i += 1
        }
        return Int32(i)
    }
}

/// This counts a Swift string's bytes up to the first NUL, Raven's `strlen(s)` over the same text.
public func strlen(_ s: String) -> Int32 {
    strlen(CharBuf(s))
}

/// This counts the bytes up to the first NUL past a `PooledString`'s pointer, Raven's `strlen(s)`.
public func strlen(_ s: PooledString) -> Int32 {
    Int32(cLength(of: s.raw))
}

// MARK: - strcpy

/// This copies the bytes up to and including the NUL, Raven's `strcpy(dest, source)`.
/// It traps when the source does not fit in `dest`, C overruns there and that is the one divergence.
public func strcpy(_ dest: inout CharBuf, _ source: CharBuf) {
    let length = Int(strlen(source))
    precondition(length + 1 <= dest.count, "strcpy: source does not fit in dest")
    dest.withMutableBytes { destBytes in
        source.withBytes { sourceBytes in
            for i in 0...length {
                destBytes[i] = sourceBytes[i]
            }
        }
    }
}

/// This copies a Swift string's bytes plus a trailing NUL, Raven's `strcpy(dest, source)`.
/// It traps when the source does not fit in `dest`, C overruns there and that is the one divergence.
public func strcpy(_ dest: inout CharBuf, _ source: String) {
    strcpy(&dest, CharBuf(source))
}

/// This copies a Swift string's bytes plus a trailing NUL from byte `offset` on, Raven's `strcpy(slash, source)` through a pointer into the buffer.
/// It traps when the source does not fit from that offset, C overruns there and that is the one divergence.
public func strcpy(_ dest: inout CharBuf, _ source: String, at offset: some BinaryInteger) {
    let source = CharBuf(source)
    let length = Int(strlen(source))
    let start = Int(offset)
    precondition(start >= 0 && start + length + 1 <= dest.count, "strcpy: source does not fit in dest from the offset")
    dest.withMutableBytes { destBytes in
        source.withBytes { sourceBytes in
            for i in 0...length {
                destBytes[start + i] = sourceBytes[i]
            }
        }
    }
}

/// This copies a `PooledString`'s bytes up to and including the NUL, Raven's `strcpy(dest, source)`.
/// It traps when the source does not fit in `dest`, C overruns there and that is the one divergence.
public func strcpy(_ dest: inout CharBuf, _ source: PooledString) {
    let length = Int(strlen(source))
    precondition(length + 1 <= dest.count, "strcpy: source does not fit in dest")
    dest.withMutableBytes { destBytes in
        for i in 0...length {
            destBytes[i] = UInt8(bitPattern: source.raw[i])
        }
    }
}

/// This copies a Swift string's bytes plus a trailing NUL into raw memory, for `BG_StringAlloc`.
/// The caller owns the memory and answers for its size, so there is no fit check here.
public func strcpy(_ dest: UnsafeMutableRawPointer, _ source: String) {
    strcpy(dest, CharBuf(source))
}

/// This copies a `CharBuf`'s bytes up to and including the NUL into raw memory, for `BG_StringAlloc`.
/// The caller owns the memory and answers for its size, so there is no fit check here.
public func strcpy(_ dest: UnsafeMutableRawPointer, _ source: CharBuf) {
    let length = Int(strlen(source))
    source.withBytes { sourceBytes in
        for i in 0...length {
            dest.storeBytes(of: sourceBytes[i], toByteOffset: i, as: UInt8.self)
        }
    }
}

/// This copies a `PooledString`'s bytes up to and including the NUL into raw memory, for `BG_StringAlloc`.
/// The caller owns the memory and answers for its size, so there is no fit check here.
public func strcpy(_ dest: UnsafeMutableRawPointer, _ source: PooledString) {
    let length = Int(strlen(source))
    for i in 0...length {
        dest.storeBytes(of: UInt8(bitPattern: source.raw[i]), toByteOffset: i, as: UInt8.self)
    }
}

// MARK: - strcat

/// This appends `bytes` and a NUL at the first NUL of `dest` from `start` on, which is the whole of C's `strcat`.
/// It traps when the result does not fit in `dest`, C overruns there and that is the one divergence.
private func strcatBytes(_ dest: inout CharBuf, _ bytes: [UInt8], from start: Int) {
    precondition(start >= 0 && start <= dest.count, "strcat: the offset is past the end of dest")
    var end = start
    dest.withBytes { destBytes in
        while end < destBytes.count, destBytes[end] != 0 {
            end += 1
        }
    }
    precondition(end + bytes.count + 1 <= dest.count, "strcat: source does not fit in dest")
    dest.withMutableBytes { destBytes in
        for i in 0..<bytes.count {
            destBytes[end + i] = bytes[i]
        }
        destBytes[end + bytes.count] = 0
    }
}

/// This reads a buffer's bytes up to its first NUL, for the `strcat` source.
private func sourceBytes(_ source: CharBuf) -> [UInt8] {
    let length = Int(strlen(source))
    return source.withBytes { bytes in (0..<length).map { bytes[$0] } }
}

/// This reads a raw C string's bytes up to its NUL, for the `strcat` source the engine filled.
private func rawBytes(_ source: UnsafeMutableRawPointer) -> [UInt8] {
    let raw = source.assumingMemoryBound(to: CChar.self)
    return (0..<cLength(of: raw)).map { UInt8(bitPattern: raw[$0]) }
}

/// This appends a Swift string's bytes plus a trailing NUL at the first NUL of `dest`, Raven's `strcat(dest, source)`.
public func strcat(_ dest: inout CharBuf, _ source: String) {
    strcat(&dest, CharBuf(source))
}

/// This appends a Swift string's bytes at the first NUL from byte `offset` on, Raven's `strcat(marker, source)` through a pointer into the buffer.
public func strcat(_ dest: inout CharBuf, _ source: String, at offset: some BinaryInteger) {
    strcat(&dest, CharBuf(source), at: offset)
}

/// This appends a buffer's bytes up to its NUL, plus a trailing NUL, at the first NUL of `dest`, Raven's `strcat(dest, source)`.
public func strcat(_ dest: inout CharBuf, _ source: CharBuf) {
    strcatBytes(&dest, sourceBytes(source), from: 0)
}

/// This appends a buffer's bytes at the first NUL from byte `offset` on, Raven's `strcat(marker, source)`.
public func strcat(_ dest: inout CharBuf, _ source: CharBuf, at offset: some BinaryInteger) {
    strcatBytes(&dest, sourceBytes(source), from: Int(offset))
}

/// This appends a raw allocation's bytes at the first NUL from byte `offset` on, Raven's `strcat(marker, tempReadBuffer)`.
/// The caller owns the allocation and answers for its NUL, which is the pool's contract.
public func strcat(_ dest: inout CharBuf, _ source: UnsafeMutableRawPointer, at offset: some BinaryInteger) {
    strcatBytes(&dest, rawBytes(source), from: Int(offset))
}

// MARK: - strncpy

/// This copies at most `n` bytes from `source` and pads with NUL up to `n` when `source` is shorter.
/// It writes no NUL when `source` is `n` bytes or longer, Raven's `strncpy(dest, source, n)`.
public func strncpy(_ dest: inout CharBuf, _ source: CharBuf, _ n: some BinaryInteger) {
    let limit = Int(n)
    let sourceLength = Int(strlen(source))
    let copyCount = min(limit, sourceLength)
    dest.withMutableBytes { destBytes in
        source.withBytes { sourceBytes in
            for i in 0..<copyCount {
                destBytes[i] = sourceBytes[i]
            }
        }
        if copyCount < limit {
            for i in copyCount..<limit {
                destBytes[i] = 0
            }
        }
    }
}

/// This copies at most `n` bytes from a Swift string and pads with NUL up to `n` when `source` is shorter.
/// It writes no NUL when `source` is `n` bytes or longer, Raven's `strncpy(dest, source, n)`.
public func strncpy(_ dest: inout CharBuf, _ source: String, _ n: some BinaryInteger) {
    strncpy(&dest, CharBuf(source), n)
}

/// This copies at most `n` bytes of a Swift string from byte `offset` on, Raven's `strncpy(dest + offset, source, n)` through a pointer into the buffer.
/// It pads with NUL up to `n` when `source` is shorter, and it writes no NUL when `source` is `n` bytes or longer.
public func strncpy(_ dest: inout CharBuf, _ source: String, _ n: some BinaryInteger, at offset: some BinaryInteger) {
    let limit = Int(n)
    let start = Int(offset)
    let source = CharBuf(source)
    let copyCount = min(limit, Int(strlen(source)))
    precondition(start >= 0 && start + limit <= dest.count, "strncpy: n bytes do not fit in dest from the offset")
    dest.withMutableBytes { destBytes in
        source.withBytes { sourceBytes in
            for i in 0..<copyCount {
                destBytes[start + i] = sourceBytes[i]
            }
        }
        if copyCount < limit {
            for i in copyCount..<limit {
                destBytes[start + i] = 0
            }
        }
    }
}

// MARK: - memset

/// This sets the first `count` bytes of `buf` to `value`, truncated to one byte, Raven's `memset(buf, value, count)`.
/// The bytes past `count` keep their values, and a `count` past the end traps, because C overruns there and that is the one divergence.
public func memset(_ buf: inout CharBuf, _ value: Int32, _ count: Int32) {
    precondition(count >= 0 && Int(count) <= buf.count, "memset: count past the end of the buffer")
    buf.withMutableBytes { bytes in
        for i in 0..<Int(count) {
            bytes[i] = UInt8(truncatingIfNeeded: value)
        }
    }
}

// MARK: - strcmp

/// This compares two buffers byte for byte as unsigned char, Raven's `strcmp(a, b)`.
/// The result is the sign of the first differing byte, or 0 when the buffers hold the same text.
public func strcmp(_ a: CharBuf, _ b: CharBuf) -> Int32 {
    a.withBytes { aBytes in
        b.withBytes { bBytes in
            var i = 0
            while true {
                let aByte = i < aBytes.count ? aBytes[i] : 0
                let bByte = i < bBytes.count ? bBytes[i] : 0
                if aByte != bByte || aByte == 0 {
                    return Int32(aByte) - Int32(bByte)
                }
                i += 1
            }
        }
    }
}

/// This compares a buffer against a Swift string's text, Raven's `strcmp(a, b)`.
public func strcmp(_ a: CharBuf, _ b: String) -> Int32 {
    strcmp(a, CharBuf(b))
}

/// This compares a Swift string's text against a buffer, Raven's `strcmp(a, b)`.
public func strcmp(_ a: String, _ b: CharBuf) -> Int32 {
    strcmp(CharBuf(a), b)
}

/// This compares two Swift strings' text, Raven's `strcmp(a, b)`.
public func strcmp(_ a: String, _ b: String) -> Int32 {
    strcmp(CharBuf(a), CharBuf(b))
}

// MARK: - strchr

/// This finds the first byte equal to `c`, and returns its offset, or `nil` when there is no match.
/// A match against 0 finds the terminating NUL, the same as Raven's `strchr(s, c)`.
public func strchr(_ s: CharBuf, _ c: Int32) -> Int32? {
    let target = UInt8(truncatingIfNeeded: c)
    return s.withBytes { bytes in
        for i in 0..<bytes.count {
            if bytes[i] == target {
                return Int32(i)
            }
            if bytes[i] == 0 {
                break
            }
        }
        return nil
    }
}

/// This is the same call as `strchr(_:_: Int32)`, for a character literal, `strchr(s, '|')`.
public func strchr(_ s: CharBuf, _ c: Unicode.Scalar) -> Int32? {
    strchr(s, Int32(c.value))
}

/// This finds the first byte equal to `c` in a Swift string's text, Raven's `strchr(s, c)`.
public func strchr(_ s: String, _ c: Int32) -> Int32? {
    strchr(CharBuf(s), c)
}

/// This is the same call as `strchr(_:_: Int32)`, for a character literal, `strchr(s, '|')`.
public func strchr(_ s: String, _ c: Unicode.Scalar) -> Int32? {
    strchr(CharBuf(s), c)
}

// MARK: - strstr

/// This finds the first occurrence of `needle` in `s`, and returns its offset, or `nil` when there is no match.
/// An empty `needle` matches at offset 0, the same as Raven's `strstr(s, needle)`.
public func strstr(_ s: CharBuf, _ needle: CharBuf) -> Int32? {
    let sLength = Int(strlen(s))
    let needleLength = Int(strlen(needle))
    if needleLength == 0 {
        return 0
    }
    guard needleLength <= sLength else { return nil }
    return s.withBytes { sBytes in
        needle.withBytes { needleBytes in
            for start in 0...(sLength - needleLength) {
                var matched = true
                for j in 0..<needleLength {
                    if sBytes[start + j] != needleBytes[j] {
                        matched = false
                        break
                    }
                }
                if matched {
                    return Int32(start)
                }
            }
            return nil
        }
    }
}

/// This finds the first occurrence of `needle` in `s`, Raven's `strstr(s, needle)`.
public func strstr(_ s: CharBuf, _ needle: String) -> Int32? {
    strstr(s, CharBuf(needle))
}

/// This finds the first occurrence of `needle` in a Swift string's text, Raven's `strstr(s, needle)`.
public func strstr(_ s: String, _ needle: String) -> Int32? {
    strstr(CharBuf(s), CharBuf(needle))
}

// MARK: - tolower and toupper

/// This maps `A` to `Z` onto `a` to `z` and gives every other value back, Raven's `tolower(c)` in the C locale.
public func tolower(_ c: Int32) -> Int32 {
    if c >= Int32(UInt8(ascii: "A")) && c <= Int32(UInt8(ascii: "Z")) {
        return c + (Int32(UInt8(ascii: "a")) - Int32(UInt8(ascii: "A")))
    }
    return c
}

/// This maps `a` to `z` onto `A` to `Z` and gives every other value back, Raven's `toupper(c)` in the C locale.
public func toupper(_ c: Int32) -> Int32 {
    if c >= Int32(UInt8(ascii: "a")) && c <= Int32(UInt8(ascii: "z")) {
        return c + (Int32(UInt8(ascii: "A")) - Int32(UInt8(ascii: "a")))
    }
    return c
}

// MARK: - withCString

/// This runs the body over the C string of an optional Swift string, and over NULL when the string is nil.
/// Every trap calls it for a `const char *` parameter, and a nil string reaches the engine as NULL.
public func withCString<R>(_ string: String?, _ body: (UnsafePointer<CChar>?) -> R) -> R {
    guard let string else { return body(nil) }
    return CharBuf(string).withUnsafeRawPointer { body($0.assumingMemoryBound(to: CChar.self)) }
}
