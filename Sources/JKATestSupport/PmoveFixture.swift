import JKAShared

/// This type reads the fixture grammar of the pmove dumpers, `main_trace.c`, `main_pmove.c`, and `main_pmove_saber.c`.
/// The number parsers copy the C library calls the dumpers make, so a token gives the same value on both sides.
///
/// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:207
public enum PmoveFixture {
    /// This is the error of a fixture line that the dumper rejects.
    ///
    /// - `badLine`: the line starts with this word, which is not a row the dumper knows, or it has too few tokens.
    public enum FixtureError: Error, Equatable {
        case badLine(String)
    }

    /// This is one `cmd` row: a user command, a repeat count, and a yaw step for each repeat.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:382
    public struct Command: Equatable, Sendable {
        public var dt: Int32
        public var forward: Int32
        public var right: Int32
        public var up: Int32
        public var buttons: Int32
        public var yaw: Int32
        public var pitch: Int32
        public var roll: Int32
        public var repeats: Int32
        public var yawStep: Int32
    }

    /// This is one row of a scenario fixture, in file order.
    ///
    /// - `brush`: a box brush of the world.
    /// - `ps`: a `playerState_t` override, the field name and its value tokens after the word `ps`.
    /// - `start`: the end of the setup, which dumps step 0.
    /// - `cmd`: one user command, which runs `Pmove` once for each repeat.
    public enum Row: Equatable, Sendable {
        case brush(PmoveBrush)
        case ps([String])
        case start
        case cmd(Command)
    }
}

// MARK: - The tokens

extension PmoveFixture {
    /// This splits one fixture line into its tokens, after it cuts the line at the first `#`.
    /// The separators are the characters of C `isspace`.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:217
    public static func tokens(_ line: Substring) -> [Substring] {
        var text = line
        if let hash = text.firstIndex(of: "#") {
            text = text[..<hash]
        }
        return text.split(whereSeparator: { " \t\n\r\u{0B}\u{0C}".contains($0) })
    }

    /// This splits a fixture text into lines, as `fgets` does.
    public static func lines(_ text: String) -> [Substring] {
        text.split(separator: "\n", omittingEmptySubsequences: false)
    }

    /// A float token is a `0x` bit pattern, or a decimal integer that `(float)atol` converts.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:207
    public static func parseFloat(_ token: Substring) -> Float {
        if token.hasPrefix("0x") || token.hasPrefix("0X") {
            return Float(bitPattern: UInt32(truncatingIfNeeded: Self.strtol(token, base: 16)))
        }
        return Float(Self.strtol(token, base: 10))
    }

    /// An integer token is what `(int)strtol(tok, NULL, 0)` reads: a hex, an octal, or a decimal value.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:215
    public static func parseInt(_ token: Substring) -> Int32 {
        Int32(truncatingIfNeeded: Self.strtol(token, base: 0))
    }

    /// A `surf=<value>` token gives its value with `strtol` base 0, and a token with no `=` gives 0.
    /// Source: jka-rust/tools/jampgame-oracle/main_trace.c:47
    public static func parseSurf(_ token: Substring) -> Int32 {
        guard let equals = token.firstIndex(of: "=") else { return 0 }
        return Int32(truncatingIfNeeded: Self.strtol(token[token.index(after: equals)...], base: 0))
    }

    /// This is C `atoi`, a decimal value with an optional sign.
    public static func atoi(_ token: Substring) -> Int32 {
        Int32(truncatingIfNeeded: Self.strtol(token, base: 10))
    }

    /// This is the C `strtol` of a 64-bit `long` for base 0, 10, or 16.
    /// Base 0 reads `0x` as hex and a leading `0` as octal.
    /// The value stops at the first character that is not a digit of the base, and it clamps at the range of `long`.
    static func strtol(_ token: Substring, base: Int) -> Int64 {
        var chars = Array(token.utf8)[...]
        var negative = false
        if let first = chars.first, first == UInt8(ascii: "+") || first == UInt8(ascii: "-") {
            negative = first == UInt8(ascii: "-")
            chars = chars.dropFirst()
        }

        var radix = base
        let hasHexPrefix = chars.count >= 3
            && chars[chars.startIndex] == UInt8(ascii: "0")
            && (chars[chars.startIndex + 1] == UInt8(ascii: "x") || chars[chars.startIndex + 1] == UInt8(ascii: "X"))
            && Self.digit(chars[chars.startIndex + 2], radix: 16) != nil
        if (radix == 0 || radix == 16) && hasHexPrefix {
            radix = 16
            chars = chars.dropFirst(2)
        } else if radix == 0 {
            radix = chars.first == UInt8(ascii: "0") ? 8 : 10
        }

        var magnitude: UInt64 = 0
        var overflow = false
        for c in chars {
            guard let d = Self.digit(c, radix: radix) else { break }
            let (times, o1) = magnitude.multipliedReportingOverflow(by: UInt64(radix))
            let (sum, o2) = times.addingReportingOverflow(UInt64(d))
            overflow = overflow || o1 || o2
            magnitude = sum
        }

        if negative {
            if overflow || magnitude > UInt64(Int64.max) + 1 {
                return Int64.min
            }
            return magnitude == UInt64(Int64.max) + 1 ? Int64.min : -Int64(magnitude)
        }
        if overflow || magnitude > UInt64(Int64.max) {
            return Int64.max
        }
        return Int64(magnitude)
    }

    private static func digit(_ c: UInt8, radix: Int) -> Int? {
        let value: Int
        switch c {
        case UInt8(ascii: "0") ... UInt8(ascii: "9"):
            value = Int(c - UInt8(ascii: "0"))

        case UInt8(ascii: "a") ... UInt8(ascii: "z"):
            value = Int(c - UInt8(ascii: "a")) + 10

        case UInt8(ascii: "A") ... UInt8(ascii: "Z"):
            value = Int(c - UInt8(ascii: "A")) + 10

        default:
            return nil
        }
        return value < radix ? value : nil
    }
}

// MARK: - The scenario rows

extension PmoveFixture {
    /// This reads the six numbers and the optional `surf=` token of a `brush` row.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:366
    public static func brush(_ tok: [Substring]) -> PmoveBrush {
        let surf = tok.count >= 8 ? Self.parseSurf(tok[7]) : 0
        return PmoveBrush(
            mins: vec3_t(Self.parseFloat(tok[1]), Self.parseFloat(tok[2]), Self.parseFloat(tok[3])),
            maxs: vec3_t(Self.parseFloat(tok[4]), Self.parseFloat(tok[5]), Self.parseFloat(tok[6])),
            surfaceFlags: surf
        )
    }

    /// This reads a scenario fixture into its rows, in file order.
    /// Blank lines and `#` comments give no row.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:358
    public static func rows(_ text: String) throws -> [Row] {
        var rows: [Row] = []
        for line in Self.lines(text) {
            let tok = Self.tokens(line)
            if tok.isEmpty {
                continue
            }

            if tok[0] == "brush" && tok.count >= 7 {
                rows.append(.brush(Self.brush(tok)))
            } else if tok[0] == "ps" && tok.count >= 3 {
                rows.append(.ps(tok.dropFirst().map(String.init)))
            } else if tok[0] == "start" {
                rows.append(.start)
            } else if tok[0] == "cmd" && tok.count >= 9 {
                // A tenth token `xN` repeats the row N times, and an eleventh token steps the yaw on each repeat.
                let repeats = tok.count >= 10 && tok[9].hasPrefix("x") ? Self.atoi(tok[9].dropFirst()) : 1
                let yawStep = tok.count >= 11 ? Self.parseInt(tok[10]) : 0
                let command = Command(
                    dt: Self.parseInt(tok[1]),
                    forward: Self.parseInt(tok[2]),
                    right: Self.parseInt(tok[3]),
                    up: Self.parseInt(tok[4]),
                    buttons: Self.parseInt(tok[5]),
                    yaw: Self.parseInt(tok[6]),
                    pitch: Self.parseInt(tok[7]),
                    roll: Self.parseInt(tok[8]),
                    repeats: repeats,
                    yawStep: yawStep
                )
                rows.append(.cmd(command))
            } else {
                throw FixtureError.badLine(String(tok[0]))
            }
        }
        return rows
    }
}
