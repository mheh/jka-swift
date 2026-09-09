import Testing
import JKAShared
import JKAMP_Game
import JKATestSupport
@testable import JKAMP_GameLogic

/// These tests share `Syscall.transport` and the one world, so they run one after the other.
@Suite(.serialized)
final class SyscallGameSuite {
    @Test("the transport is empty before dllEntry")
    func transportStartsEmpty() {
        withoutTransport {
            #expect(Syscall.transport == nil)
        }
    }

    @Test("a call records its command and its words on the installed transport")
    func callRecordsCommandAndWords() {
        let recorder = RecordingTransport()
        withTransport(recorder) {
            Syscall.call(3, [11, 22, 33])
            Syscall.call(7)
        }

        #expect(recorder.calls.count == 2)
        #expect(recorder.calls[0].command == 3)
        #expect(recorder.calls[0].words == [11, 22, 33])
        #expect(recorder.calls[1].command == 7)
        #expect(recorder.calls[1].words == [])
    }

    @Test("the scripted answers give the return word, and an unlisted command returns 0")
    func answersScriptTheReturnWord() {
        let recorder = RecordingTransport()
        recorder.answers[5] = 42

        let (first, second) = withTransport(recorder) {
            (Syscall.call(5), Syscall.call(6))
        }

        #expect(first == 42)
        #expect(second == 0)
    }

    @Test("the typed overload sends a game import with its text pointer")
    func typedOverloadSendsTextPointer() {
        let recorder = RecordingTransport()
        recorder.textCommands = [Int(gameImport_t.G_PRINT.rawValue)]

        withTransport(recorder) {
            "jka-swift jampgame init\n".withCString { text in
                Syscall.call(.G_PRINT, text)
            }
        }

        #expect(recorder.calls.count == 1)
        #expect(recorder.calls[0].command == Int(gameImport_t.G_PRINT.rawValue))
        #expect(recorder.texts.count == 1)
        #expect(recorder.texts[0].text == "jka-swift jampgame init\n")
    }

    @Test("the typed overload sends an entity as its handle word")
    func typedOverloadSendsEntityHandle() {
        world = GameWorld()
        let recorder = RecordingTransport()

        let ent = g_entities[3]
        withTransport(recorder) {
            Syscall.call(.G_LINKENTITY, ent)
        }

        #expect(recorder.calls.count == 1)
        #expect(recorder.calls[0].command == Int(gameImport_t.G_LINKENTITY.rawValue))
        #expect(recorder.calls[0].words == [Int(bitPattern: ent.handle)])
    }
}
