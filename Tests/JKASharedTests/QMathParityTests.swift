import JKAShared
import JKATestSupport
import Testing

/// The differential test of rule 18. It rebuilds `Oracle/golden/qmath.txt` from the ported functions and compares the whole text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_qmath.c`, token for token.
@Suite("q_math reproduces the qmath golden")
struct QMathParityTests {
    @Test("the rng section matches the golden")
    func rngSectionMatches() throws {
        let golden = try QMathGolden.section("rng", in: OracleData.golden("qmath"))
        let got = QMathDump.rng()
        #expect(GoldenFormat.mismatch("qmath rng", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The golden slices

/// This cuts one `== name ==` section out of the golden, so a lane commit gates on the sections it ported.
enum QMathGolden {
    static func section(_ name: String, in golden: String) throws -> String {
        let opener = "== \(name) ==\n"
        guard let start = golden.range(of: opener) else {
            throw QMathGoldenError.noSection(name)
        }
        let rest = golden[start.upperBound...]
        guard let end = rest.range(of: "\n== ") else {
            throw QMathGoldenError.noSection(name)
        }
        return opener + String(rest[..<end.lowerBound]) + "\n"
    }
}

enum QMathGoldenError: Error {
    case noSection(String)
}

// MARK: - The dump

/// Each method rebuilds one section of the golden with the dumper's tokens and the dumper's order.
enum QMathDump {
    /// Source: jka-rust/tools/jampgame-oracle/main_qmath.c:52
    static func rng() -> String {
        let seeds: [Int32] = [Int32(bitPattern: 0x89ab_cdef), 0, 1, Int32(bitPattern: 0xdead_beef)]
        var out = "== rng ==\n"
        var rng = Rng()
        for seed in seeds {
            out += "seed \(GoldenFormat.hex8(UInt32(bitPattern: seed)))\n"
            rng.Rand_Init(seed)
            for _ in 0 ..< 100 {
                out += "fl \(GoldenFormat.bits(rng.flrand(0.0, 1.0)))\n"
                out += "fl \(GoldenFormat.bits(rng.flrand(-1.0, 1.0)))\n"
                out += "fl \(GoldenFormat.bits(rng.flrand(-100.0, 100.0)))\n"
                out += "qf \(GoldenFormat.bits(rng.Q_flrand(0.0, 1000.0)))\n"
                out += "ir \(rng.irand(0, 1))\n"
                out += "ir \(rng.irand(0, 100))\n"
                out += "ir \(rng.irand(-50, 50))\n"
                out += "qi \(rng.Q_irand(0, 32767))\n"
            }
        }
        return out
    }
}
