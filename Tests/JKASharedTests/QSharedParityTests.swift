import Foundation
import JKAShared
import JKATestSupport
import Testing

/// The golden records that the Swift signatures cannot produce, which the comparison leaves out by key.
/// Each entry gives the key of the record, Raven's line, and the argument that the Swift form does not take.
private let skippedRecords: [(key: String, raven: String, argument: String)] = [
    ("stricmpn_null", "oracle/codemp/game/q_shared.c:846", "a NULL `s1` or `s2`, which the String form of Q_stricmpn cannot hold"),
    ("pslen_null", "oracle/codemp/game/q_shared.c:944", "a NULL `string`, which the String form of Q_PrintStrlen cannot hold"),
    ("va1b", "oracle/codemp/game/q_shared.c:1019", "the first pointer into the two static buffers, which the String return of va does not keep"),
]

/// The differential test of rule 18.
/// It rebuilds the sections of `Oracle/golden/qshared.txt` from the ported functions and compares each section as exact text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_qshared.c`, token for token, and the sections run in the dumper's order.
///
/// The parse line counter of `COM_BeginParseSession` is one global, so the suite runs serialized and every section runs in one test.
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
        let strhelpers = QSharedDump.strhelpers()
        let va = QSharedDump.va()
        let sprintf = QSharedDump.sprintf()
        let info = try QSharedDump.info()
        let got: [(name: String, text: String)] = [
            ("clamp", clamp),
            ("tokens", tokens),
            ("compress", compress),
            ("braced", braced),
            ("skipline", skipline),
            ("strhelpers", strhelpers),
            ("va", va),
            ("sprintf", sprintf),
            ("info", info),
        ]

        for section in got {
            let lines = (want.first { $0.name == section.name }?.text ?? "").split(separator: "\n", omittingEmptySubsequences: false)
            let kept = lines.filter { line in
                !skippedRecords.contains { line == $0.key || line.hasPrefix($0.key + " ") }
            }
            let goldenText = kept.joined(separator: "\n")
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

    /// The records of `skippedRecords` have no call here.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:188
    static func strhelpers() -> String {
        var out = "== strhelpers ==\n"

        // isXXX predicates over signed-char edges.
        let ic: [Int32] = [-1, 0, 0x1f, 0x20, 0x40, 0x5a, 0x61, 0x7a, 0x7e, 0x7f, 0x80, 0xff]
        for c in ic {
            out += "is \(c) p \(Q_isprint(c)) l \(Q_islower(c)) u \(Q_isupper(c)) a \(Q_isalpha(c))\n"
        }

        // COM_StripExtension.
        let sx = ["", "file", "file.ext", "a.b.c", ".hidden", "no_dot", "path/to/file.tga"]
        for input in sx {
            var stripped = CharBuf(64)
            COM_StripExtension(input, &stripped)
            out += "strip \(Self.qstr(input)) -> \(Self.qstr(String(stripped)))\n"
        }

        // COM_DefaultExtension (non-empty paths; empty path reads path[-1] = UB).
        let dx: [(p: String, e: String)] = [
            ("file", ".tga"),
            ("file.bmp", ".tga"),
            ("path/to/file", ".md3"),
            ("path/to/file.ext", ".md3"),
            ("noext", ".cfg"),
            ("dir.x/name", ".wav"),
        ]
        for entry in dx {
            var path = CharBuf(128)
            strcpy(&path, entry.p)
            COM_DefaultExtension(&path, Int32(path.count), entry.e)
            out += "defext \(Self.qstr(entry.p)) \(Self.qstr(entry.e)) -> \(Self.qstr(String(path)))\n"
        }

        // Q_strncpyz (24-byte window filled with 0xAA to observe zero-padding).
        let ncz = ["", "hi", "exactfit", "longerthanthebuffer.....", "abc"]
        let nsz: [Int32] = [1, 2, 4, 8, 16]
        for (i, src) in ncz.enumerated() {
            for size in nsz {
                var b = CharBuf(bytes: [CChar](repeating: CChar(truncatingIfNeeded: 0xAA), count: 24))
                Q_strncpyz(&b, src, size)
                out += "ncpyz \(i) \(size) \(Self.hex(b))\n"
            }
        }

        // Q_strcat (skip combos the C would Com_Error-abort on: strlen(init) >= size).
        let catI = ["", "foo", "12345"]
        let catS = ["", "bar", "appendmelong"]
        let catSz: [Int32] = [4, 8, 16]
        for (a, initial) in catI.enumerated() {
            for (b, src) in catS.enumerated() {
                for size in catSz {
                    if strlen(initial) >= size {
                        continue
                    }
                    var buf = CharBuf(bytes: [CChar](repeating: CChar(truncatingIfNeeded: 0xAA), count: 24))
                    strcpy(&buf, initial)
                    Q_strcat(&buf, size, src)
                    out += "cat \(a) \(b) \(size) \(Self.hex(buf))\n"
                }
            }
        }

        // Q_stricmp / Q_stricmpn / Q_strncmp over case/prefix/high-bit pairs.
        let cmpA = ["", "a", "a", "abc", "abc", "Hello", "hello", "abc", "ab", "zoo", "Test123", "\u{80}x", "a\u{80}", "MixedCase"]
        let cmpB = ["", "a", "A", "abd", "abc", "hello", "HELLO", "ab", "abc", "zoon", "test123", "\u{80}x", "a\u{7f}", "mixedcase"]
        let cmpN: [Int32] = [0, 1, 2, 3, 5, 99999]
        for i in 0 ..< cmpA.count {
            out += "stricmp \(i) \(Q_stricmp(cmpA[i], cmpB[i]))\n"
            for n in cmpN {
                out += "stricmpn \(i) \(n) \(Q_stricmpn(cmpA[i], cmpB[i], n))\n"
            }
            for n in cmpN {
                out += "strncmp \(i) \(n) \(Q_strncmp(cmpA[i], cmpB[i], n))\n"
            }
        }
        // Q_stricmp / Q_stricmpn NULL handling.
        let none: String? = nil
        out += "stricmp_null \(Q_stricmp(none, "x")) \(Q_stricmp("x", none)) \(Q_stricmp(none, none))\n"

        // Q_strlwr / Q_strupr (ASCII only; libc tolower/toupper on signed high-bit is UB).
        let lu = ["", "Hello World", "ALLCAPS", "already lower", "MiXeD123!@#"]
        for input in lu {
            var lower = CharBuf(64)
            var upper = CharBuf(64)
            strcpy(&lower, input)
            strcpy(&upper, input)
            Q_strlwr(&lower)
            Q_strupr(&upper)
            out += "lwr \(Self.qstr(String(lower))) upr \(Self.qstr(String(upper)))\n"
        }

        // Q_PrintStrlen / Q_CleanStr over color/control-byte strings.
        let col = [
            "",
            "hello",
            "^1red",
            "^1r^2g^3b",
            "^^literal",
            "^8notcolor",
            "trailing^",
            "^",
            "a\u{01}b\u{1f}c\u{7f}d\u{80}e",
            "^7white^0black^",
            "plain text 123",
        ]
        for (i, input) in col.enumerated() {
            out += "pslen \(i) \(Q_PrintStrlen(input))\n"
            var clean = CharBuf(64)
            strcpy(&clean, input)
            Q_CleanStr(&clean)
            out += "clean \(i) \(Self.qstr(String(clean)))\n"
        }

        // Q_strrchr: dump offset of the found char (or -1).
        let rc = ["", "a", "hello", "abracadabra", "a/b/c/d", "trailing/", "^1color"]
        let rcc: [Int32] = [Int32(ascii: "a"), Int32(ascii: "/"), Int32(ascii: "z"), 0, Int32(ascii: "r")]
        for (i, input) in rc.enumerated() {
            for c in rcc {
                let off = Q_strrchr(input, c).map { Int($0) } ?? -1
                out += "rrchr \(i) \(c) \(off)\n"
            }
        }
        return out
    }

    /// The record `va1b` reads the first pointer after the third call, so it has no line here.
    /// Source: jka-rust/tools/jampgame-oracle/main_qshared.c:293
    static func va() -> String {
        var out = "== va ==\n"
        let p1 = JKAShared.va("first-literal")
        let p2 = JKAShared.va("second-literal")
        out += "va1 \(Self.qstr(p1))\n"
        out += "va2 \(Self.qstr(p2))\n"
        let p3 = JKAShared.va("third-literal")
        out += "va2b \(Self.qstr(p2))\n"
        out += "va3 \(Self.qstr(p3))\n"
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
