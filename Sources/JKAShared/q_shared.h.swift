// q_shared.h -- the header's function-like macros as functions, the way q_shared.c.swift holds the file's functions.

/// Source: oracle/codemp/game/q_shared.h:548
public let M_PI: Float = 3.14159265358979323846

/// Source: oracle/codemp/game/q_shared.h:1174
public func DEG2RAD(_ a: Float) -> Float {
    (a * M_PI) / 180.0
}

/// Source: oracle/codemp/game/q_shared.h:1175
public func RAD2DEG(_ a: Float) -> Float {
    (a * 180.0) / M_PI
}

/// Source: oracle/codemp/game/q_shared.h:30
public func VALIDSTRING(_ a: String) -> Bool {
    !a.isEmpty
}

/// Raven's macro tests the pointer and the first byte, so a null `char *` is false here too.
/// Source: oracle/codemp/game/q_shared.h:30
public func VALIDSTRING(_ a: PooledString?) -> Bool {
    a?.string.isEmpty == false
}

/// Raven wrote `Q_IsColorString(&text[i])`, so the buffer and the offset come in as two arguments.
/// Source: oracle/codemp/game/q_shared.h:1147
public func Q_IsColorString(_ buf: CharBuf, at i: Int) -> Bool {
    let escape: Int32 = buf[i]
    guard escape == Q_COLOR_ESCAPE else { return false }

    let next: Int32 = buf[i + 1]
    return next != 0 && next != Q_COLOR_ESCAPE && next <= Int32(UInt8(ascii: "7")) && next >= Int32(UInt8(ascii: "0"))
}

/// Source: oracle/codemp/game/q_shared.h:1158
public func ColorIndex(_ c: CChar) -> Int32 {
    (Int32(c) - Int32(UInt8(ascii: "0"))) & 7
}
