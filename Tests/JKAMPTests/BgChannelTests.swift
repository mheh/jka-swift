import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP

/// The bg channel of rule 23 routes every bare `strap_` and game function through the closures on `BgState`.
/// `BgState` also carries the consumer's `MAX_POOL_SIZE` and the cvar views a bg body reads.
@Suite("The bg channel reaches the installed closures", .serialized)
struct BgChannelTests {
    @Test("A bare strap call reaches the installed strap closure with its arguments")
    func strapCallReachesClosure() {
        var received: (Int32, String, Int32, Int32, Int32, Float, Int32, Float, Int32)?
        bg.straps.strap_G2API_SetBoneAnim = { _, modelIndex, boneName, startFrame, endFrame, flags, animSpeed, currentTime, setFrame, blendTime in
            received = (modelIndex, boneName, startFrame, endFrame, flags, animSpeed, currentTime, setFrame, blendTime)
            return true
        }

        let answer = strap_G2API_SetBoneAnim(nil, 2, "lower_lumbar", 5, 9, 17, 1.5, 400, 6.5, 150)

        #expect(answer == true)
        #expect(received?.0 == 2)
        #expect(received?.1 == "lower_lumbar")
        #expect(received?.2 == 5)
        #expect(received?.3 == 9)
        #expect(received?.4 == 17)
        #expect(received?.5 == 1.5)
        #expect(received?.6 == 400)
        #expect(received?.7 == 6.5)
        #expect(received?.8 == 150)
        bg = BgState()
    }

    @Test("A bare game call reaches the installed callback with its arguments")
    func callbackCallReachesClosure() {
        let storage = UnsafeMutablePointer<UInt8>.allocate(capacity: 4096)
        defer { storage.deallocate() }
        let entity = JKAMP.BgEntity(handle: OpaquePointer(storage))
        var received: (JKAMP.BgEntity, Int32, Int32)?
        bg.callbacks.G_AddEvent = { ent, event, eventParm in
            received = (ent, event, eventParm)
        }

        G_AddEvent(entity, 34, 7)

        #expect(received?.0 == entity)
        #expect(received?.1 == 34)
        #expect(received?.2 == 7)
        bg = BgState()
    }

    @Test("A read callback that hands back a view reaches the installed closure with both indexes")
    func viewReadCallbackReachesClosure() {
        let storage = UnsafeMutablePointer<UInt8>.allocate(capacity: 4096)
        defer { storage.deallocate() }
        let saber = JKAMP.SaberInfo(handle: OpaquePointer(storage))
        var received: (Int32, Int32)?
        bg.callbacks.bgClientSaber = { entityNum, index in
            received = (entityNum, index)
            return saber
        }

        let answer = bgClientSaber(of: 5, at: 1)

        #expect(answer == saber)
        #expect(received?.0 == 5)
        #expect(received?.1 == 1)
        bg = BgState()
    }

    @Test("A call with nothing installed ends the process")
    func defaultClosureEndsTheProcess() async {
        await #expect(processExitsWith: .failure) {
            bg = BgState()
            _ = strap_G2API_SetBoneAnim(nil, 0, "model_root", 0, 0, 0, 1, 0, 0, 0)
        }
    }

    @Test("MAX_POOL_SIZE and the pool tail follow the size the state was built with")
    func poolSizeFollowsTheState() {
        bg = BgState(consumer: .cgame, maxPoolSize: 2_048_000)

        #expect(MAX_POOL_SIZE == 2_048_000)
        #expect(bg.variables.bg_poolTail == 2_048_000)
        #expect(bg.consumer == .cgame)
        bg = BgState()
    }

    @Test("The fighter alt control cvar reads 0 by default")
    func fighterAltControlReadsZero() {
        #expect(bg_fighterAltControl.integer == 0)
    }
}
