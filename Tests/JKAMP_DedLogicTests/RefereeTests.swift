import JKAMP
import JKAMP_Ded
import JKAShared
import Testing
@testable import JKAMP_DedLogic

/// This suite checks the pure parts of the port of the fork's `sv_referee.cpp`: the hash, the record decode, the line forms, and the record sizes.
/// Each test makes a fresh world, because the referee state lives on the world.
@Suite(.serialized)
struct RefereeSuite {
    @Test("Ref_Fnv1a gives the FNV-1a 32 values of the fork's algorithm", arguments: [
        ("", UInt32(0x811c_9dc5)),
        ("a", UInt32(0xe40c_292c)),
        ("foobar", UInt32(0xbf9c_f968)),
        ("REFREC v1 ", UInt32(0x3063_5837)),
    ])
    func fnv1aMatchesTheVector(text: String, expected: UInt32) {
        world = EngineWorld()
        var bytes = Array(text.utf8) + [0]
        let hash = bytes.withUnsafeMutableBytes { raw in
            Ref_Fnv1a(
                Slots<JKAShared.byte>(scalars: raw.baseAddress!, count: raw.count),
                Int32(text.utf8.count),
                2_166_136_261
            )
        }
        #expect(hash == expected)
    }

    @Test("Ref_Fnv1a over two parts in a row equals the hash of the whole")
    func fnv1aChains() {
        world = EngineWorld()
        var bytes = Array("foobar".utf8)
        let hash = bytes.withUnsafeMutableBytes { raw in
            let slots = Slots<JKAShared.byte>(scalars: raw.baseAddress!, count: raw.count)
            let first = Ref_Fnv1a(slots, 3, 2_166_136_261)
            return Ref_Fnv1a(slots.suffix(from: 3), 3, first)
        }
        #expect(hash == 0xbf9c_f968)
    }

    @Test("the hashed records have the sizes of the fork's REF READY line")
    func recordSizesMatchTheCLayout() {
        // The fork prints `es=532 er=112 ps=1552 cmd=28`, sv_referee.cpp:605-610.
        #expect(EntityState.byteCount == 532)
        #expect(EntityShared.byteCount == 112)
        #expect(PlayerState.byteCount == 1552)
        #expect(Usercmd.byteCount == 28)
    }

    @Test("the REF STEP and REF READY lines print in the fork's form")
    func lineForms() {
        world = EngineWorld()
        #expect(va("REF STEP n=%d t=%d ck=%08x\n", Int32(1), Int32(425), UInt32(0x3cfa_876c)) == "REF STEP n=1 t=425 ck=3cfa876c\n")
        #expect(va("REF STEP n=%d t=%d ck=%08x\n", Int32(4000), Int32(100_400), UInt32(0xab)) == "REF STEP n=4000 t=100400 ck=000000ab\n")
        #expect(
            va(
                "REF READY map=%s seed=%d fps=%d es=%d er=%d ps=%d cmd=%d\n",
                "mp/ffa1",
                Int32(42),
                Int32(40),
                Int32(EntityState.byteCount),
                Int32(EntityShared.byteCount),
                Int32(PlayerState.byteCount),
                Int32(Usercmd.byteCount)
            ) == "REF READY map=mp/ffa1 seed=42 fps=40 es=532 er=112 ps=1552 cmd=28\n"
        )
        #expect(va("REF T %d IN %d %lld %lld\n", Int32(0), Int32(1), Int(-1), Int(1) << 40) == "REF T 0 IN 1 -1 1099511627776\n")
    }

    @Test("the header line of the record writer matches the committed fixture")
    func headerLineMatchesTheFixture() {
        world = EngineWorld()
        // reflog-real-duel1-idle.rec starts with this line, and the fork writes it with the format of sv_referee.cpp:590.
        #expect(va("REFREC v1 map=%s seed=%d fps=%d\n", "mp/duel1", Int32(4001), Int32(20)) == "REFREC v1 map=mp/duel1 seed=4001 fps=20\n")
    }

    @Test("Ref_ReplayAdvance decodes the record headers and stops at the first record of a later frame")
    func replayAdvanceDecodesRecords() {
        world = EngineWorld()
        sv_maxclients = Cvar_Get("sv_maxclients", "8", 0)

        // given a header line and four usercmd records of frames 0, 1, 3, and 100 for clients that are not fake
        let header = Array("REFREC v1 map=mp/ffa1 seed=42 fps=40\n".utf8)
        var file = header
        for (frame, client) in [(UInt32(0), UInt8(2)), (1, 2), (3, 3), (100, 3)] {
            file += [UInt8(frame & 0xff), UInt8((frame >> 8) & 0xff), UInt8((frame >> 16) & 0xff), UInt8(frame >> 24)]
            file += [1, client, 0, 0]
            file += [UInt8](repeating: 0x5a, count: 28)
        }
        let record = Int32(8 + 28)
        let body = Int32(header.count)

        file.withUnsafeMutableBytes { raw in
            ref_rpBuf = Slots<JKAShared.byte>(scalars: raw.baseAddress!, count: raw.count)
            ref_rpLen = Int32(raw.count)
            ref_rpBodyOfs = body
            ref_rpCursor = body
            ref_rpActive = true

            // when frame 0 runs, then the one record of frame 0 runs
            ref_frameIndex = 0
            Ref_ReplayAdvance()
            #expect(ref_rpCursor == body + record)

            // when frame 1 runs, then the record of frame 1 runs
            ref_frameIndex = 1
            Ref_ReplayAdvance()
            #expect(ref_rpCursor == body + 2 * record)

            // when frame 2 runs, then no record runs
            ref_frameIndex = 2
            Ref_ReplayAdvance()
            #expect(ref_rpCursor == body + 2 * record)

            // when frame 50 runs, then the record of frame 3 runs and the record of frame 100 waits
            ref_frameIndex = 50
            Ref_ReplayAdvance()
            #expect(ref_rpCursor == body + 3 * record)
            #expect(ref_rpActive)

            ref_rpBuf = nil
        }
    }
}
