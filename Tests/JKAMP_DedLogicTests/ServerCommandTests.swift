import JKAMP_Ded
import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the slot write of `SV_AddServerCommand` in a fresh world.
/// `SV_Netchan_Decode` reads the slot past its first zero, so the write must leave zeros after the text, as Raven's `Q_strncpyz` does.
@Suite(.serialized)
struct ServerCommandSuite {
    @Test("an empty command over a longer old command leaves only zeros in the slot")
    func emptyCommandClearsTheSlot() {
        // given
        world = EngineWorld()

        // A client_t does not fit on the stack of a test task, so the record is the heap form of the scratch.
        Client.scratch(count: 1) { clients in
            let client = clients[0]
            SV_AddServerCommand(client, String(repeating: "x", count: 100))
            let old = charBuf(at: client.reliableCommands.slot(at: 1).base, capacity: Int(MAX_STRING_CHARS))
            #expect(old[1] as UInt8 == UInt8(ascii: "x"))
            client.reliableSequence = 0

            // when
            SV_AddServerCommand(client, "")

            // then
            let slot = charBuf(at: client.reliableCommands.slot(at: 1).base, capacity: Int(MAX_STRING_CHARS))
            var nonzero: Int32 = 0
            var i: Int32 = 0
            while i < MAX_STRING_CHARS {
                if slot[i] as UInt8 != 0 {
                    nonzero += 1
                }
                i += 1
            }
            #expect(client.reliableSequence == 1)
            #expect(nonzero == 0)
        }
    }
}
