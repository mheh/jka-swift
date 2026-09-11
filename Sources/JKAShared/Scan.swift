/// This file holds the `sscanf` subset Raven's game code reads through: `%f`, `%d`, and `%i`, into one float, one integer, or a `vec3_t`.
/// Swift has no variadic `inout`, so each target shape is one overload, and every overload checks with `precondition` that the format is the one it serves.
/// A ported body therefore still spells the call with Raven's format string, and a format the port does not cover traps at once.

// MARK: - Byte access

private extension CharBuf {
    /// This gives the buffer's `count` bytes for a read, for the functions below.
    func withBytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
        self.withUnsafeRawPointer { base in
            body(UnsafeRawBufferPointer(start: base, count: self.count))
        }
    }
}

/// This gives a buffer's bytes up to the first NUL, because the bytes past it are not text.
private func scanBytes(of s: CharBuf) -> [UInt8] {
    s.withBytes { bytes in
        var end = 0
        while end < bytes.count, bytes[end] != 0 {
            end += 1
        }
        return Array(bytes[0..<end])
    }
}

// MARK: - Character tests

/// This reads C's whitespace for a conversion: a space, a tab, a newline, or a carriage return.
private func isScanSpace(_ byte: UInt8) -> Bool {
    byte == UInt8(ascii: " ") || byte == UInt8(ascii: "\t") || byte == UInt8(ascii: "\n") || byte == UInt8(ascii: "\r")
}

/// This reads one ASCII digit.
private func isScanDigit(_ byte: UInt8) -> Bool {
    (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(byte)
}

/// This moves the cursor past a run of whitespace, which is what the literal space between two specifiers matches.
/// A run of no whitespace at all is a match too, so `"1-2"` reads as two numbers.
private func skipScanSpace(_ bytes: [UInt8], _ i: inout Int) {
    while i < bytes.count, isScanSpace(bytes[i]) {
        i += 1
    }
}

// MARK: - Conversions

/// This reads one `%f` at the cursor, `strtod`'s form: an optional sign, digits, an optional fraction, and an optional exponent.
/// It gives `nil` and leaves the cursor alone when there is no number there, which is how a conversion fails.
private func readScanFloat(_ bytes: [UInt8], _ i: inout Int) -> Float? {
    var j = i
    skipScanSpace(bytes, &j)

    var text = ""
    if j < bytes.count, bytes[j] == UInt8(ascii: "+") || bytes[j] == UInt8(ascii: "-") {
        text.append(Character(UnicodeScalar(bytes[j])))
        j += 1
    }

    var sawDigit = false
    while j < bytes.count, isScanDigit(bytes[j]) {
        sawDigit = true
        text.append(Character(UnicodeScalar(bytes[j])))
        j += 1
    }
    if j < bytes.count, bytes[j] == UInt8(ascii: ".") {
        text.append(".")
        j += 1
        while j < bytes.count, isScanDigit(bytes[j]) {
            sawDigit = true
            text.append(Character(UnicodeScalar(bytes[j])))
            j += 1
        }
    }
    guard sawDigit else { return nil }

    // An `e` with no digit after it belongs to the text that follows, so the cursor stops before it.
    if j < bytes.count, bytes[j] == UInt8(ascii: "e") || bytes[j] == UInt8(ascii: "E") {
        var exponentText = String(Character(UnicodeScalar(bytes[j])))
        var k = j + 1
        if k < bytes.count, bytes[k] == UInt8(ascii: "+") || bytes[k] == UInt8(ascii: "-") {
            exponentText.append(Character(UnicodeScalar(bytes[k])))
            k += 1
        }
        var sawExponentDigit = false
        while k < bytes.count, isScanDigit(bytes[k]) {
            sawExponentDigit = true
            exponentText.append(Character(UnicodeScalar(bytes[k])))
            k += 1
        }
        if sawExponentDigit {
            text += exponentText
            j = k
        }
    }

    i = j
    return Float(Double(text) ?? 0)
}

/// This reads one `%d` at the cursor, `strtol` base 10: an optional sign and digits.
/// It gives `nil` and leaves the cursor alone when there is no number there, which is how a conversion fails.
private func readScanInt(_ bytes: [UInt8], _ i: inout Int) -> Int32? {
    var j = i
    skipScanSpace(bytes, &j)

    var negative = false
    if j < bytes.count, bytes[j] == UInt8(ascii: "+") || bytes[j] == UInt8(ascii: "-") {
        negative = bytes[j] == UInt8(ascii: "-")
        j += 1
    }

    var value = 0
    var sawDigit = false
    while j < bytes.count, isScanDigit(bytes[j]) {
        sawDigit = true
        value = value * 10 + Int(bytes[j] - UInt8(ascii: "0"))
        j += 1
    }
    guard sawDigit else { return nil }

    i = j
    return Int32(truncatingIfNeeded: negative ? -value : value)
}

// MARK: - Cores

/// This reads up to three floats into `v`, and gives the count it read.
/// An axis past the last number keeps the value it held before the call.
private func scanVector(_ bytes: [UInt8], _ v: inout vec3_t) -> Int32 {
    var i = 0
    var read: Int32 = 0
    for axis in 0..<3 {
        guard let value = readScanFloat(bytes, &i) else { break }
        v[axis] = value
        read += 1
    }
    return read
}

/// This reads one float into `f`, and gives 1 for a number and 0 for text with no number.
private func scanFloat(_ bytes: [UInt8], _ f: inout Float) -> Int32 {
    var i = 0
    guard let value = readScanFloat(bytes, &i) else { return 0 }
    f = value
    return 1
}

/// This reads one integer into `n`, and gives 1 for a number and 0 for text with no number.
private func scanInt(_ bytes: [UInt8], _ n: inout Int32) -> Int32 {
    var i = 0
    guard let value = readScanInt(bytes, &i) else { return 0 }
    n = value
    return 1
}

// MARK: - sscanf

/// This reads three floats into `v`, Raven's `sscanf(s, "%f %f %f", &v[0], &v[1], &v[2])`.
/// The result is the count of numbers it read, and an axis past the last number keeps its old value.
@discardableResult
public func sscanf(_ s: String, _ fmt: String, _ v: inout vec3_t) -> Int32 {
    precondition(fmt == "%f %f %f", "sscanf: the vector overload serves \"%f %f %f\" alone, and the format was \"\(fmt)\"")
    return scanVector(Array(s.utf8), &v)
}

/// This reads three floats out of a `char` buffer, Raven's `sscanf(buf, "%f %f %f", &v[0], &v[1], &v[2])`.
/// The result is the count of numbers it read, and an axis past the last number keeps its old value.
@discardableResult
public func sscanf(_ s: CharBuf, _ fmt: String, _ v: inout vec3_t) -> Int32 {
    precondition(fmt == "%f %f %f", "sscanf: the vector overload serves \"%f %f %f\" alone, and the format was \"\(fmt)\"")
    return scanVector(scanBytes(of: s), &v)
}

/// This reads one float into `f`, Raven's `sscanf(s, "%f", &f)`.
/// The result is 1 for a number and 0 for text with no number, and `f` keeps its old value on a 0.
@discardableResult
public func sscanf(_ s: String, _ fmt: String, _ f: inout Float) -> Int32 {
    precondition(fmt == "%f", "sscanf: the float overload serves \"%f\" alone, and the format was \"\(fmt)\"")
    return scanFloat(Array(s.utf8), &f)
}

/// This reads one float out of a `char` buffer, Raven's `sscanf(buf, "%f", &f)`.
/// The result is 1 for a number and 0 for text with no number, and `f` keeps its old value on a 0.
@discardableResult
public func sscanf(_ s: CharBuf, _ fmt: String, _ f: inout Float) -> Int32 {
    precondition(fmt == "%f", "sscanf: the float overload serves \"%f\" alone, and the format was \"\(fmt)\"")
    return scanFloat(scanBytes(of: s), &f)
}

/// This reads one integer into `n`, Raven's `sscanf(s, "%d", &n)`.
/// C's `%i` also takes `0x` hexadecimal and a leading `0` for octal, and Raven passes plain decimals alone, so this port reads `%i` as `%d`.
@discardableResult
public func sscanf(_ s: String, _ fmt: String, _ n: inout Int32) -> Int32 {
    precondition(fmt == "%d" || fmt == "%i", "sscanf: the integer overload serves \"%d\" and \"%i\" alone, and the format was \"\(fmt)\"")
    return scanInt(Array(s.utf8), &n)
}

/// This reads one integer out of a `char` buffer, Raven's `sscanf(buf, "%d", &n)`.
/// C's `%i` also takes `0x` hexadecimal and a leading `0` for octal, and Raven passes plain decimals alone, so this port reads `%i` as `%d`.
@discardableResult
public func sscanf(_ s: CharBuf, _ fmt: String, _ n: inout Int32) -> Int32 {
    precondition(fmt == "%d" || fmt == "%i", "sscanf: the integer overload serves \"%d\" and \"%i\" alone, and the format was \"\(fmt)\"")
    return scanInt(scanBytes(of: s), &n)
}
