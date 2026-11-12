import JKATestSupport
import Testing
import JKAShared

/// The differential test of the test world. It rebuilds `Oracle/golden/pmove_trace.txt` from `PmoveWorld` and compares the whole text.
/// The golden calls no Raven function, so a match proves the world that the `pmove` and `pmove_saber` goldens stand on.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_trace.c`, token for token.
@Suite("The test world reproduces the pmove_trace golden")
struct PmoveTraceParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() throws {
        let got = try PmoveTraceDump.sweeps(OracleData.fixture("pmove/trace.txt"))

        let golden = try OracleData.golden("pmove_trace")
        #expect(GoldenFormat.mismatch("pmove_trace", got: got, golden: golden) == nil)
        #expect(got == golden)
    }
}

// MARK: - The dump

/// This rebuilds the golden with the dumper's tokens and the dumper's order.
enum PmoveTraceDump {
    /// This runs every row of the trace fixture: `reset` clears the world, `brush` adds a brush, and `sweep` prints one trace.
    /// Source: jka-rust/tools/jampgame-oracle/main_trace.c:53
    static func sweeps(_ fixture: String) throws -> String {
        var world = PmoveWorld()
        var sweepNo = 0
        var out = "== pmove_trace ==\n"

        for line in PmoveFixture.lines(fixture) {
            let tok = PmoveFixture.tokens(line)
            if tok.isEmpty {
                continue
            }

            if tok[0] == "reset" {
                world.reset()
                out += "reset\n"
            } else if tok[0] == "brush" && tok.count >= 7 {
                let brush = PmoveFixture.brush(tok)
                world.add(brush)
                out += "brush \(world.brushes.count - 1) surf=\(Self.hex(brush.surfaceFlags))\n"
            } else if tok[0] == "sweep" && tok.count >= 13 {
                let v = tok.map { PmoveFixture.parseFloat($0) }
                let start = vec3_t(v[1], v[2], v[3])
                let end = vec3_t(v[4], v[5], v[6])
                let mins = vec3_t(v[7], v[8], v[9])
                let maxs = vec3_t(v[10], v[11], v[12])
                let tr = world.trace(start, mins, maxs, end)
                out += "sweep \(sweepNo)"
                out += " as=\(tr.allsolid) ss=\(tr.startsolid) frac=\(GoldenFormat.bits(tr.fraction))"
                out += " end=\(Self.bits(tr.endpos)) nrm=\(Self.bits(tr.normal))"
                out += " pd=\(GoldenFormat.bits(tr.dist)) pt=\(tr.type) psb=\(tr.signbits)"
                out += " sf=\(Self.hex(tr.surfaceFlags)) ct=\(Self.hex(tr.contents)) en=\(tr.entityNum)\n"
                sweepNo += 1
            } else {
                // The dumper ends with an error at a row it does not know.
                throw PmoveFixture.FixtureError.badLine(String(tok[0]))
            }
        }

        out += "== end ==\n"
        return out
    }

    /// This prints an `int` as C `%x` does, the lower-case hex of its bit pattern with no padding.
    static func hex(_ value: Int32) -> String {
        String(UInt32(bitPattern: value), radix: 16)
    }

    /// This prints a vector as three bit patterns with commas, the `%08x,%08x,%08x` of the dumper.
    static func bits(_ v: vec3_t) -> String {
        "\(GoldenFormat.bits(v[0])),\(GoldenFormat.bits(v[1])),\(GoldenFormat.bits(v[2]))"
    }
}
