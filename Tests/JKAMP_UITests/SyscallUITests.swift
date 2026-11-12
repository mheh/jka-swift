import Testing
import JKAShared
import JKAMP
import JKAMP_UI
import JKATestSupport
@testable import JKAMP_UILogic

/// These tests share `Syscall.transport`, so they run one after the other.
@Suite(.serialized)
final class SyscallUISuite {
    @Test("the transport is empty before dllEntry")
    func transportStartsEmpty() {
        withoutTransport {
            #expect(Syscall.transport == nil)
        }
    }

    @Test("the typed overload sends a ui import with its text pointer")
    func typedOverloadSendsTextPointer() {
        let recorder = RecordingTransport()
        recorder.textCommands = [Int(UI_PRINT)]

        withTransport(recorder) {
            "jka-swift ui init\n".withCString { text in
                _ = Syscall.call(UI_PRINT, text)
            }
        }

        #expect(recorder.calls.count == 1)
        #expect(recorder.calls[0].command == Int(UI_PRINT))
        #expect(recorder.texts.count == 1)
        #expect(recorder.texts[0].text == "jka-swift ui init\n")
    }
}
