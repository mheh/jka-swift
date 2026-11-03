import Testing
import JKAShared
import JKAMP_CGame
import JKATestSupport
@testable import JKAMP_CGameLogic

/// These tests share `Syscall.transport` and the one world, so they run one after the other.
@Suite(.serialized)
final class SyscallCGameSuite {
    @Test("the transport is empty before dllEntry")
    func transportStartsEmpty() {
        withoutTransport {
            #expect(Syscall.transport == nil)
        }
    }

    @Test("the typed overload sends a cgame import with its text pointer")
    func typedOverloadSendsTextPointer() {
        let recorder = RecordingTransport()
        recorder.textCommands = [Int(CG_PRINT)]

        withTransport(recorder) {
            "jka-swift cgame init\n".withCString { text in
                _ = Syscall.call(CG_PRINT, text)
            }
        }

        #expect(recorder.calls.count == 1)
        #expect(recorder.calls[0].command == Int(CG_PRINT))
        #expect(recorder.texts.count == 1)
        #expect(recorder.texts[0].text == "jka-swift cgame init\n")
    }

    @Test("a fresh world has no last attacker and makes no syscall")
    func freshWorldHasNoLastAttacker() {
        world = CGameWorld()
        let recorder = RecordingTransport()

        let attacker = withTransport(recorder) {
            CG_LastAttacker()
        }

        #expect(attacker == -1)
        #expect(recorder.calls.isEmpty)
    }
}
