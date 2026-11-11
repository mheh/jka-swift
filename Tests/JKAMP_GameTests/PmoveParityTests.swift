import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP
import JKAShared

/// The differential test of the on-foot `Pmove`. It rebuilds `Oracle/golden/pmove.txt` from the ported `Pmove` and compares the whole text.
/// The six scenarios run in a child process, because `bg`, `rng`, and the test world are process globals.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_pmove.c`, token for token.
@Suite("Pmove reproduces the pmove golden")
struct PmoveParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() async throws {
        let stderrPath = ChildStandardError.newPath()
        let result = await #expect(processExitsWith: .success, observing: [\.standardOutputContent]) { [stderrPath = stderrPath as String] in
            ChildStandardError.redirect(to: stderrPath)
            try PmoveHarness.emit(.melee, scenarios: PmoveDump.scenarios, dump: PmoveDump.line)
        }
        let childError = ChildStandardError.take(stderrPath)
        guard let result else {
            Issue.record("The child process did not exit with success. Its standard error:\n\(childError)")
            return
        }
        let got = try PmoveHarness.extract(result.standardOutputContent)

        // This repo's copy carries the float `M_PI`, and the jka-rust copy does not.
        let golden = try OracleData.golden("pmove")
        #expect(GoldenFormat.mismatch("pmove", got: got, golden: golden) == nil)
        #expect(got == golden)
        if got != golden {
            Issue.record("The text differs from the golden. The standard error of the child process:\n\(childError)")
        }
    }
}

// MARK: - The dump

/// This writes the step line of `main_pmove.c` and names the scenarios in the order of `run.sh`.
enum PmoveDump {
    /// The scenarios of the golden, in the order `run.sh` runs them.
    /// Source: jka-rust/tools/jampgame-oracle/run.sh:173
    static let scenarios = ["idle", "walk-fwd", "strafe-turn", "jump-land", "fall-onto-box", "wall-step"]

    /// This writes the 40 fields of one step, with the trace count and `holdrand` as the two tripwires at the end.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove.c:295
    static func line(_ step: Int32, _ pm: JKAMP.Pmove) -> String {
        let ps = pm.ps
        var out = "s=\(step) t=\(ps.commandTime)"
        out += " org=\(Self.bits(ps.origin)) vel=\(Self.bits(ps.velocity)) va=\(Self.bits(ps.viewangles))"
        out += " da=\(ps.delta_angles[0]),\(ps.delta_angles[1]),\(ps.delta_angles[2])"
        out += " gnd=\(ps.groundEntityNum) pmf=\(Self.hex(ps.pm_flags)) pmt=\(ps.pm_time)"
        out += " la=\(ps.legsAnim):\(ps.legsTimer) ta=\(ps.torsoAnim):\(ps.torsoTimer)"
        out += " fl=\(ps.legsFlip ? 1 : 0)\(ps.torsoFlip ? 1 : 0) bob=\(ps.bobCycle)"
        out += " vh=\(ps.viewheight) ef=\(Self.hex(ps.eFlags)) seq=\(ps.eventSequence)"
        out += " ev=\(ps.events[0]):\(ps.eventParms[0]),\(ps.events[1]):\(ps.eventParms[1])"
        out += " wt=\(ps.weaponTime) ws=\(ps.weaponstate) spd=\(GoldenFormat.bits(ps.speed))"
        out += " wl=\(pm.waterlevel) wtp=\(pm.watertype)"
        out += " nt=\(pm.numtouch) mn=\(GoldenFormat.bits(pm.mins[2])) mx=\(GoldenFormat.bits(pm.maxs[2])) xy=\(GoldenFormat.bits(pm.xyspeed))"
        out += " air=\(ps.inAirAnim ? 1 : 0) f2d=\(ps.fallingToDeath) fjz=\(GoldenFormat.bits(ps.fd.forceJumpZStart))"
        out += " ntr=\(PmoveHarness.world.traceCount) rng=\(GoldenFormat.hex8(rng.holdrand))\n"
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
