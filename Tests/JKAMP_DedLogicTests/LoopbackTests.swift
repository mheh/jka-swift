import JKAMP_Ded
import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the loopback queue of `net_chan.cpp` in a fresh world.
/// A packet that the server sends goes into the loopback of the client, and the client reads the same bytes back.
@Suite(.serialized)
struct LoopbackSuite {
    @Test("a loopback packet comes back with the same bytes and length")
    func loopbackPacketRoundTrips() {
        // given
        world = EngineWorld()
        let sent: [UInt8] = [0xff, 0xff, 0xff, 0xff, 0x63, 0x6f, 0x6e, 0x6e, 0x65, 0x63, 0x74]
        var source = sent
        var received = [UInt8](repeating: 0, count: 64)

        source.withUnsafeMutableBytes { sourceRaw in
            received.withUnsafeMutableBytes { receivedRaw in
                let data = Slots<JKAShared.byte>(scalars: sourceRaw.baseAddress!, count: sourceRaw.count)
                let buffer = Slots<JKAShared.byte>(scalars: receivedRaw.baseAddress!, count: receivedRaw.count)

                Netadr.scratch { to in
                    to.type = NA_LOOPBACK

                    // when
                    NET_SendLoopPacket(NS_SERVER, Int32(sent.count), data, to)
                }

                Netadr.scratch { from in
                    Msg.scratch { message in
                        message.data = buffer
                        message.maxsize = Int32(buffer.count)
                        let got = NET_GetLoopPacket(NS_CLIENT, from, message)

                        // then
                        #expect(got)
                        #expect(message.cursize == Int32(sent.count))
                        #expect(from.type == NA_LOOPBACK)
                        #expect(NET_GetLoopPacket(NS_CLIENT, from, message) == false)
                    }
                }
            }
        }

        #expect(Array(received.prefix(sent.count)) == sent)
    }
}
