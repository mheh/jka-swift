import JKAShared
import JKATestSupport
import Testing
@testable import JKAMP_BG

/// The differential test of rule 18 for the `trajectory` section of `Oracle/golden/bgmisc.txt`.
/// It rebuilds the `T` records from the ported `BG_EvaluateTrajectory` and `BG_EvaluateTrajectoryDelta` and compares the section text.
/// The other sections of the golden have no Swift side yet.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_bgmisc.c`, token for token.
@Suite("bg_misc reproduces the trajectory section of the bgmisc golden")
struct BGMiscTrajectoryParityTests {
    @Test("the trajectory section matches")
    func trajectoryMatches() throws {
        let got = try BGMiscDump.trajectorySection()

        let golden = try OracleData.golden("bgmisc")
        let expected = try #require(BGMiscDump.section("trajectory", of: golden))
        #expect(GoldenFormat.mismatch("bgmisc", got: got, golden: expected) == nil)
        #expect(got == expected)
    }
}

// MARK: - The dump

enum BGMiscDump {
    /// This returns one section of a golden, from its banner line to the line before the next banner.
    static func section(_ name: String, of golden: String) -> String? {
        guard let start = golden.range(of: "== \(name) ==\n") else { return nil }
        let rest = golden[start.lowerBound...]
        guard let next = rest.range(of: "\n== ", range: start.upperBound ..< rest.endIndex) else { return String(rest) }
        return String(rest[..<rest.index(after: next.lowerBound)])
    }

    /// A float token is a plain integer as `(float)atol`, or a `0x` bit pattern.
    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:58
    static func pf(_ token: Substring) -> Float {
        if token.hasPrefix("0x") || token.hasPrefix("0X") {
            return Float(bitPattern: UInt32(token.dropFirst(2), radix: 16) ?? 0)
        }
        return Float(Int(token) ?? 0)
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:66
    static func pi(_ token: Substring) -> Int32 {
        if token.hasPrefix("0x") || token.hasPrefix("0X") {
            return Int32(bitPattern: UInt32(token.dropFirst(2), radix: 16) ?? 0)
        }
        return Int32(token) ?? 0
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_bgmisc.c:184
    static func trajectorySection() throws -> String {
        var out = "== trajectory ==\n"
        var idx = 0
        for line in try OracleData.fixture("bgmisc/trajectory.txt").split(separator: "\n") {
            let tok = line.split(separator: " ")
            if tok.isEmpty || tok[0] != "T" {
                continue
            }
            var rp = vec3_t()
            var rd = vec3_t()
            Trajectory.scratch { tr in
                tr.trType = Self.pi(tok[1])
                tr.trTime = Self.pi(tok[2])
                tr.trDuration = Self.pi(tok[3])
                tr.trBase = vec3_t(Self.pf(tok[4]), Self.pf(tok[5]), Self.pf(tok[6]))
                tr.trDelta = vec3_t(Self.pf(tok[7]), Self.pf(tok[8]), Self.pf(tok[9]))
                let atTime = Self.pi(tok[10])
                BG_EvaluateTrajectory(tr, atTime, &rp)
                BG_EvaluateTrajectoryDelta(tr, atTime, &rd)
            }
            out += "T \(idx) et \(GoldenFormat.vector(rp)) ed \(GoldenFormat.vector(rd))\n"
            idx += 1
        }
        return out
    }
}
