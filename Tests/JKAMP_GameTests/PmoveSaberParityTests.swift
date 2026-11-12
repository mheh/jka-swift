import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP
import JKAShared

/// The differential test of the saber `Pmove`. It rebuilds `Oracle/golden/pmove_saber.txt` from the ported `Pmove` and compares the whole text.
/// The six scenarios run in a child process, because `bg`, `world`, `rng`, and the test world are process globals.
/// The dumper it copies is `jka-rust/tools/jampgame-oracle/main_pmove_saber.c`, token for token.
@Suite("Pmove reproduces the pmove_saber golden")
struct PmoveSaberParityTests {
    @Test("the whole golden text matches")
    func goldenMatches() async throws {
        let stderrPath = ChildStandardError.newPath()
        let result = await #expect(processExitsWith: .success, observing: [\.standardOutputContent]) { [stderrPath = stderrPath as String] in
            ChildStandardError.redirect(to: stderrPath)
            try PmoveHarness.emit(.saber, scenarios: PmoveSaberDump.scenarios, dump: PmoveSaberDump.line)
        }
        let childError = ChildStandardError.take(stderrPath)
        guard let result else {
            Issue.record("The child process did not exit with success. Its standard error:\n\(childError)")
            return
        }
        let got = try PmoveHarness.extract(result.standardOutputContent)

        let golden = try OracleData.golden("pmove_saber")
        #expect(GoldenFormat.mismatch("pmove_saber", got: got, golden: golden) == nil)
        #expect(got == golden)
        if got != golden {
            Issue.record("The text differs from the golden. The standard error of the child process:\n\(childError)")
        }
    }
}

// MARK: - The dump

/// This writes the step line of `main_pmove_saber.c` and names the scenarios in the order of `run_pmove_saber.sh`.
enum PmoveSaberDump {
    /// The scenarios of the golden, in the order `run_pmove_saber.sh` runs them.
    /// Source: jka-rust/tools/jampgame-oracle/run_pmove_saber.sh:75
    static let scenarios = ["saber-idle", "saber-walk", "saber-attack-stand", "saber-attack-run", "saber-attack-strafe", "saber-jump"]

    /// This writes the step line of the melee dumper, and then the six saber fields before the line end.
    /// Source: jka-rust/tools/jampgame-oracle/main_pmove_saber.c:322
    static func line(_ step: Int32, _ pm: JKAMP.Pmove) -> String {
        let ps = pm.ps
        var out = String(PmoveDump.line(step, pm).dropLast())
        out += " sm=\(ps.saberMove) sb=\(ps.saberBlocked) shl=\(ps.saberHolstered)"
        out += " sen=\(ps.saberEntityNum) sal=\(ps.fd.saberAnimLevel) sac=\(ps.saberAttackChainCount)\n"
        return out
    }
}
