import Foundation
import JKAShared
import JKATestSupport
import Testing

/// The differential test of rule 18.
/// It rebuilds the sections of `Oracle/golden/qshared.txt` from the ported functions and compares each section as exact text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_qshared.c`, token for token, and the sections run in the dumper's order.
///
/// The parse line counter of `COM_BeginParseSession` is one global, so the suite runs serialized and every section runs in one test.
/// Two sections are not rebuilt, because the Swift signatures cannot give the values that the dumper prints:
/// - `strhelpers`: `Q_stricmpn` and `Q_PrintStrlen` take no NULL argument, and the dumper prints `stricmpn_null` and `pslen_null`.
/// - `va`: `va` returns a `String` copy and keeps no rotating buffer, and the dumper prints `va1b "third-literal"` through the first pointer.
@Suite("q_shared reproduces the qshared golden", .serialized)
struct QSharedParityTests {
    @Test("the rebuilt sections match the golden")
    func goldenSectionsMatch() throws {
        let golden = try OracleData.golden("qshared")
        let want = QSharedDump.sections(golden)

        // The dumper prints these banners in this order.
        let names = want.map { $0.name }
        #expect(names == ["clamp", "tokens", "compress", "braced", "skipline", "strhelpers", "va", "sprintf", "info", "end"])

        let clamp = QSharedDump.clamp()
        let tokens = try QSharedDump.tokens()
        let compress = try QSharedDump.compress()
        let braced = QSharedDump.braced()
        let skipline = QSharedDump.skipline()
        let sprintf = QSharedDump.sprintf()
        let info = try QSharedDump.info()
        let got: [(name: String, text: String)] = [
            ("clamp", clamp),
            ("tokens", tokens),
            ("compress", compress),
            ("braced", braced),
            ("skipline", skipline),
            ("sprintf", sprintf),
            ("info", info),
        ]

        for section in got {
            let goldenText = want.first { $0.name == section.name }?.text ?? ""
            #expect(GoldenFormat.mismatch("qshared \(section.name)", got: section.text, golden: goldenText) == nil)
            #expect(section.text == goldenText)
        }
    }
}

// MARK: - The dump

/// Each method rebuilds one section of the golden with the dumper's tokens and the dumper's order.
enum QSharedDump {
    /// This splits the golden at its `== name ==` banners, and each text keeps its banner line.
    static func sections(_ golden: String) -> [(name: String, text: String)] {
        var out: [(name: String, text: String)] = []
        for line in golden.split(separator: "\n") {
            if line.hasPrefix("== ") && line.hasSuffix(" ==") {
                out.append((String(line.dropFirst(3).dropLast(3)), ""))
            }
            guard !out.isEmpty else { continue }
            out[out.count - 1].text += String(line) + "\n"
        }
        return out
    }

    /// The dumper's `emit_qstr`: printable ASCII except the quote and the backslash stays, and every other byte prints as `\xHH`.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:39
    static func qstr(_ s: String) -> String {
        var out = "\""
        for scalar in s.unicodeScalars {
            let c = scalar.value
            if c >= 0x20 && c <= 0x7e && c != 0x22 && c != 0x5c {
                out.unicodeScalars.append(scalar)
            } else {
                out += "\\x" + GoldenFormat.hex2(UInt8(truncatingIfNeeded: c))
            }
        }
        out += "\""
        return out
    }

    /// The dumper's `emit_hex`: every byte of the buffer as `%02x`, with one space between two bytes.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:52
    static func hex(_ buf: CharBuf) -> String {
        var words: [String] = []
        for i in 0 ..< buf.count {
            let value: UInt8 = buf[i]
            words.append(GoldenFormat.hex2(value))
        }
        return words.joined(separator: " ")
    }

    /// This builds a buffer of the bytes plus a trailing NUL, the `buf[n] = 0` of the dumper's `slurp`.
    static func nulTerminated(_ bytes: [UInt8]) -> CharBuf {
        CharBuf(bytes: bytes.map { CChar(truncatingIfNeeded: $0) } + [0])
    }

    /// This splits a fixture into its NUL-separated records, with the dumper's `strlen` walk, so a last NUL makes no empty record.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:126
    static func records(_ bytes: [UInt8]) -> [[UInt8]] {
        var out: [[UInt8]] = []
        var off = 0
        while off < bytes.count {
            var end = off
            while end < bytes.count && bytes[end] != 0 {
                end += 1
            }
            out.append(Array(bytes[off ..< end]))
            off = end + 1
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:67
    static func clamp() -> String {
        var out = "== clamp ==\n"
        let iv: [Int32] = [-100, -1, 0, 1, 5, 50, 100]
        for a in iv {
            for b in iv {
                for c in iv {
                    out += "ci \(Com_Clampi(a, b, c))\n"
                }
            }
        }

        // floats as IEEE-754 bit-hex
        let cv: [Float] = [-100.0, -1.5, 0.0, 1.5, 5.25, 100.0]
        for a in cv {
            for b in cv {
                for c in cv {
                    out += "cf \(GoldenFormat.bits(Com_Clamp(a, b, c)))\n"
                }
            }
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:89
    static func tokens() throws -> String {
        var out = "== tokens ==\n"
        let buf = Self.nulTerminated([UInt8](try OracleData.fixtureData("qshared/tokens.txt")))

        // pass 1: allowLineBreaks = qtrue
        COM_BeginParseSession("tokens")
        var p = TextCursor(buf)
        for _ in 0 ..< 200 {
            let tok = COM_ParseExt(&p, true)
            let eof = p.isNull
            out += "qt \(Self.qstr(tok)) line \(COM_GetCurrentParseLine()) nul \(eof ? 1 : 0)\n"
            if tok.isEmpty && eof {
                break
            }
        }

        // pass 2: allowLineBreaks = qfalse (empty token returned at line breaks)
        COM_BeginParseSession("tokens")
        p = TextCursor(buf)
        for _ in 0 ..< 200 {
            let tok = COM_ParseExt(&p, false)
            let eof = p.isNull
            out += "qf \(Self.qstr(tok)) line \(COM_GetCurrentParseLine()) nul \(eof ? 1 : 0)\n"
            if eof {
                break
            }
        }
        return out
    }

    /// The dumper copies each record into a scratch of 512 bytes, because `COM_Compress` writes in place.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:120
    static func compress() throws -> String {
        var out = "== compress ==\n"
        let bytes = [UInt8](try OracleData.fixtureData("qshared/compress.txt"))
        for (idx, rec) in Self.records(bytes).enumerated() {
            var tmp = CharBuf(512)
            strcpy(&tmp, Self.nulTerminated(rec))
            let r = COM_Compress(&tmp)
            out += "cz \(idx) len \(r) \(Self.qstr(String(tmp)))\n"
        }
        return out
    }

    /// The dumper prints the byte offset of the cursor from the start of the text, and -1 for a NULL cursor.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:140
    static func braced() -> String {
        var out = "== braced ==\n"
        let cases = [
            "{ a { b } c } after",
            "{ } trailing",
            "{nested{deeper{x}}} end",
            "{ unterminated { block ",
            "noBrace token here",
        ]
        for (i, input) in cases.enumerated() {
            COM_BeginParseSession("braced")
            var p = TextCursor(CharBuf(input))
            SkipBracedSection(&p)
            let off = p.offset.map { Int($0) } ?? -1
            let rest = p.isNull ? "" : COM_ParseExt(&p, true)
            out += "br \(i) off \(off) line \(COM_GetCurrentParseLine()) rest \(Self.qstr(rest))\n"
        }
        return out
    }

    /// Raven's `SkipRestOfLine` steps one byte past the NUL when the text has no newline.
    /// The dumper prints only that offset and the line counter.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:163
    static func skipline() -> String {
        var out = "== skipline ==\n"
        let cases = [
            "rest of line\nnext line",
            "no newline here",
            "\nimmediate",
            "a\nb\nc",
        ]
        for (i, input) in cases.enumerated() {
            COM_BeginParseSession("skipline")
            var p = TextCursor(CharBuf(input))
            SkipRestOfLine(&p)
            let off = p.offset.map { Int($0) } ?? -1
            out += "sl \(i) off \(off) line \(COM_GetCurrentParseLine())\n"
        }
        return out
    }

    /// The dumper fills a window of 24 bytes with `0xAA` before each call, so the hex shows what the call wrote.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:306
    static func sprintf() -> String {
        var out = "== sprintf ==\n"
        let cases: [(tag: String, size: Int32, literal: String)] = [
            ("sp1", 24, "hello world"),
            ("sp2", 8, "truncate me please"),
            ("sp3", 24, ""),
            ("sp4", 1, "anything"),
        ]
        for entry in cases {
            var b = CharBuf(bytes: [CChar](repeating: CChar(truncatingIfNeeded: 0xAA), count: 24))
            Com_sprintf(&b, entry.size, entry.literal)
            out += "\(entry.tag) \(Self.hex(b))\n"
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:319
    static let vkeys = ["name", "team", "key2", "empty", "onlykey", "desc", "missing", "Name", ""]

    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:320
    static let rkeys = ["name", "team", "key1", "desc", "onlykey", "missing", "quote", "semi"]

    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:321
    static let skv: [(key: String, value: String)] = [
        ("name", "alice"),
        ("new", "val"),
        ("team", ""),
        ("x", "y"),
        ("quote", "a\"b"),
    ]

    /// The dumper copies the record into a zeroed scratch of 1100 bytes, or of 9000 bytes for a `_Big` call, before each call that writes.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:325
    static func infoRecord(_ idx: Int, _ s: String) -> String {
        var out = "rec \(idx) \(Self.qstr(s))\n"
        out += "val \(Info_Validate(s) ? 1 : 0)\n"

        for key in Self.vkeys {
            out += "vfk \(Self.qstr(key)) \(Self.qstr(Info_ValueForKey(s, key)))\n"
        }

        for key in Self.rkeys {
            var tmp = CharBuf(1100)
            strcpy(&tmp, s)
            Info_RemoveKey(&tmp, key)
            out += "rk \(Self.qstr(key)) \(Self.qstr(String(tmp)))\n"
        }
        for key in Self.rkeys {
            var tmp = CharBuf(9000)
            strcpy(&tmp, s)
            Info_RemoveKey_Big(&tmp, key)
            out += "rkb \(Self.qstr(key)) \(Self.qstr(String(tmp)))\n"
        }
        for pair in Self.skv {
            var tmp = CharBuf(1100)
            strcpy(&tmp, s)
            Info_SetValueForKey(&tmp, pair.key, pair.value)
            out += "svk \(Self.qstr(pair.key)) \(Self.qstr(pair.value)) \(Self.qstr(String(tmp)))\n"
        }
        for pair in Self.skv {
            var tmp = CharBuf(9000)
            strcpy(&tmp, s)
            Info_SetValueForKey_Big(&tmp, pair.key, pair.value)
            out += "svkb \(Self.qstr(pair.key)) \(Self.qstr(pair.value)) \(Self.qstr(String(tmp)))\n"
        }
        out += "--\n"
        return out
    }

    /// The last records use an infostring longer than `MAX_INFO_STRING` and shorter than `BIG_INFO_STRING`, for the guard of `Info_ValueForKey`.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:359
    static func info() throws -> String {
        var out = "== info ==\n"
        let bytes = [UInt8](try OracleData.fixtureData("qshared/infostrings.txt"))
        for (idx, rec) in Self.records(bytes).enumerated() {
            out += Self.infoRecord(idx, String(Self.nulTerminated(rec)))
        }

        var big = ""
        var i = 0
        while big.utf8.count < 1100 {
            big += "\\k\(i)\\v\(i)"
            i += 1
        }
        out += "big len \(big.utf8.count)\n"
        out += "big val \(Info_Validate(big) ? 1 : 0)\n"
        out += "big vfk k50 \(Self.qstr(Info_ValueForKey(big, "k50")))\n"
        out += "big vfk missing \(Self.qstr(Info_ValueForKey(big, "missing")))\n"
        return out
    }
}
