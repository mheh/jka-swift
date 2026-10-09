import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP

/// `Com_Error` and `Com_Printf` of `bg_local.swift` forward to the hooks on `BgState`, per the ruling of 2026-09-09.
@Suite("Com_Error and Com_Printf reach the installed hooks")
struct ComErrorTests {
    @Test("Com_Printf reaches the installed print hook")
    func printReachesHook() {
        var lines: [String] = []
        bg.print = { text in lines.append(text) }

        JKAMP_BG.Com_Printf("hello")

        #expect(lines == ["hello"])
        bg = BgState()
    }

    @Test("Com_Error records the level and text, then ends the process")
    func errorRecordsAndExits() async {
        await #expect(processExitsWith: .failure) {
            JKAMP_BG.Com_Error(ERR_DROP, "no item")
        }
    }
}
