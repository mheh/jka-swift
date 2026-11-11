import JKATestSupport
import Testing
@testable import JKAMP_GameLogic

/// The differential test of rule 18. It rebuilds `Oracle/golden/wsaber.txt` from the ported `G_SaberLockAnim` and `G_KnockawayForParry` and compares the whole text.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_wsaber.c`, token for token.
@Suite("w_saber reproduces the wsaber golden")
struct WSaberParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() throws {
        var got = "== wsaber ==\n"
        got += try WSaberDump.lockanim()
        got += try WSaberDump.knockaway()
        got += "== end ==\n"

        let golden = try OracleData.golden("wsaber")
        #expect(GoldenFormat.mismatch("wsaber", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The dump

/// Each method rebuilds one section of the golden with the dumper's tokens and the dumper's order.
enum WSaberDump {
    /// This is the error of a fixture with no `sweep` line, or with too few bounds on it.
    ///
    /// - `noSweep`: the fixture at this path has no usable `sweep` line.
    enum SweepError: Error {
        case noSweep(String)
    }

    /// An integer token is a plain decimal, or a `0x` bit pattern.
    /// Source: jka-rust/crates/testkit/src/lib.rs:88
    static func pi(_ token: Substring) -> Int32 {
        if token.hasPrefix("0x") || token.hasPrefix("0X") {
            return Int32(truncatingIfNeeded: Int64(token.dropFirst(2), radix: 16) ?? 0)
        }
        return Int32(truncatingIfNeeded: Int64(token) ?? 0)
    }

    /// This returns the bounds of the first `sweep` line of a `wsaber` fixture.
    /// The loader skips blank lines and `#` comment lines.
    /// Source: jka-rust/tools/jampgame-oracle/main_wsaber.c:73
    static func readSweep(_ name: String, count: Int) throws -> [Int32] {
        let path = "wsaber/\(name)"
        for line in try OracleData.fixture(path).split(separator: "\n") {
            let tok = line.split(whereSeparator: { $0 == " " || $0 == "\t" || $0 == "\r" })
            if tok.isEmpty || tok[0].hasPrefix("#") || tok[0] != "sweep" {
                continue
            }
            let bounds = tok.dropFirst().map { Self.pi($0) }
            guard bounds.count >= count else { throw SweepError.noSweep(path) }
            return bounds
        }
        throw SweepError.noSweep(path)
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_wsaber.c:94
    static func lockanim() throws -> String {
        var out = "== lockanim ==\n"
        let b = try Self.readSweep("lockanim.txt", count: 8)
        for a in b[0] ... b[1] {
            for d in b[0] ... b[1] {
                for t in b[2] ... b[3] {
                    for l in b[4] ... b[5] {
                        for w in b[6] ... b[7] {
                            let r = G_SaberLockAnim(a, d, t, l, w)
                            out += "la \(a) \(d) \(t) \(l) \(w) \(r)\n"
                        }
                    }
                }
            }
        }
        return out
    }

    /// Source: jka-rust/tools/jampgame-oracle/main_wsaber.c:116
    static func knockaway() throws -> String {
        var out = "== knockaway ==\n"
        let b = try Self.readSweep("knockaway.txt", count: 2)
        for m in b[0] ... b[1] {
            let r = G_KnockawayForParry(m)
            out += "kp \(m) \(r)\n"
        }
        return out
    }
}
