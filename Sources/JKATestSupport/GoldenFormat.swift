import JKAShared

/// This type writes the tokens the Oracle dumpers print, so a parity suite rebuilds a golden byte for byte.
/// Every float prints as its IEEE-754 bit pattern, because a decimal float would round.
///
/// Source: jka-rust/tools/jampgame-oracle/dumpcommon.h:15
public enum GoldenFormat {
    /// This prints a float as its eight-digit lower-case bit pattern, the `f2b` of `dumpcommon.h`.
    /// A NaN normalizes to `7fc00000`, because x86 and ARM make different NaN payloads. Rule 19.
    public static func bits(_ value: Float) -> String {
        let raw = value.bitPattern
        if (raw & 0x7f80_0000) == 0x7f80_0000 && (raw & 0x007f_ffff) != 0 {
            return self.hex8(0x7fc0_0000)
        }
        return self.hex8(raw)
    }

    /// This prints a `vec3_t` as three space-separated bit patterns, the `PV3` of `dumpcommon.h`.
    public static func vector(_ value: vec3_t) -> String {
        "\(self.bits(value.x)) \(self.bits(value.y)) \(self.bits(value.z))"
    }

    /// This prints a `vec4_t` as four space-separated bit patterns, the `PV4` of `dumpcommon.h`.
    public static func vector4(_ value: vec4_t) -> String {
        "\(self.bits(value.x)) \(self.bits(value.y)) \(self.bits(value.z)) \(self.bits(value.w))"
    }

    /// This prints an unsigned word as eight lower-case hex digits, the C `%08x`.
    public static func hex8(_ value: UInt32) -> String {
        let text = String(value, radix: 16)
        return String(repeating: "0", count: 8 - text.count) + text
    }

    /// This prints a byte as two lower-case hex digits, the C `%02x`.
    public static func hex2(_ value: UInt8) -> String {
        let text = String(value, radix: 16)
        return String(repeating: "0", count: 2 - text.count) + text
    }
}

// MARK: - The comparison

extension GoldenFormat {
    /// This reports the first line where the rebuilt text and the golden differ, and nothing when they match.
    /// The comparison itself is one string equality, so this text is only the message of a failed check.
    ///
    /// Source: jka-rust/crates/testkit/src/lib.rs:40
    public static func mismatch(_ name: String, got: String, golden: String) -> String? {
        if got == golden {
            return nil
        }
        let goldenLines = golden.split(separator: "\n", omittingEmptySubsequences: false)
        let gotLines = got.split(separator: "\n", omittingEmptySubsequences: false)
        for (index, pair) in zip(goldenLines, gotLines).enumerated() where pair.0 != pair.1 {
            return "\(name) parity mismatch at line \(index + 1) (oracle vs port):\n  oracle: \(pair.0)\n  port:   \(pair.1)"
        }
        return "\(name) parity length mismatch: oracle \(goldenLines.count) lines, port \(gotLines.count) lines"
    }
}
