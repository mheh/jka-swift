import JKATestSupport
import Testing
@testable import JKAMP_BG
import JKAMP
import JKAShared

/// A cgame consumer builds its own `BgState` and installs no game closure, under rule 23.
/// The rule 23 tests keep every game arm of a bg body off a cgame path, so a cgame `Pmove` reaches no game closure.
@Suite("A cgame consumer runs Pmove with no game closure", .serialized)
struct BgConsumerTests {
    @Test("Pmove of a standing player under a cgame state reaches no game closure")
    func cgamePmoveReachesNoGameClosure() async {
        await #expect(processExitsWith: .success) {
            // given a cgame state with two cgame closures and no game closure, and one player on a floor in slot 0
            bg = BgState(consumer: .cgame, maxPoolSize: 2_048_000)
            // The cgame installs its own reads, and the player's clientinfo is not valid yet.
            bg.callbacks.bgClientInfoInfoValid = { _ in false }
            // The cgame's own trap rounds each component to the nearest integer, as the engine does.
            bg.straps.trap_SnapVector = { v in v = v.rounded(.toNearestOrEven) }
            let move = JKAMP.Pmove(handle: OpaquePointer(Self.zeroed(JKAMP.Pmove.byteCount)))
            let ps = JKAMP.PlayerState(handle: OpaquePointer(Self.zeroed(JKAMP.PlayerState.byteCount)))
            let entities = Self.zeroed(JKAMP.BgEntity.byteCount * 2)
            let player = JKAMP.BgEntity(handle: OpaquePointer(entities))
            player.s.number = 0
            player.playerState = ps

            ps.clientNum = 0
            ps.pm_type = PM_NORMAL
            ps.gravity = 800
            ps.speed = 250
            ps.commandTime = 0
            move.ps = ps
            move.cmd.serverTime = 50
            move.tracemask = MASK_PLAYERSOLID
            move.animations = bgHumanoidAnimations[0]
            move.baseEnt = player
            move.entSize = Int32(JKAMP.BgEntity.byteCount)
            move.trace = { results, start, _, _, end, _, _ in
                // The test world is a floor under the player, so a trace that goes down stops at its start, and any other trace runs its full length.
                let trace = JKAMP.Trace(handle: results!)
                let from = UnsafePointer<Float>(start!)
                let to = UnsafePointer<Float>(end!)
                trace.clear()
                if to[2] < from[2] {
                    trace.fraction = 0
                    trace.endpos = JKAShared.vec3_t(from[0], from[1], from[2])
                    trace.plane.normal = JKAShared.vec3_t(0, 0, 1)
                    trace.entityNum = ENTITYNUM_WORLD
                } else {
                    trace.fraction = 1
                    trace.endpos = JKAShared.vec3_t(to[0], to[1], to[2])
                    trace.entityNum = ENTITYNUM_NONE
                }
            }
            move.pointcontents = { _, _ in 0 }

            // when the cgame state runs one move
            Pmove(move)

            // then the move ends without a trap, and the player's command time reaches the command
            precondition(ps.commandTime == 50, "the move did not run")
        }
    }

    /// This allocates one zeroed C block of `count` bytes, which the child process of the exit test never frees.
    private static func zeroed(_ count: Int) -> UnsafeMutableRawPointer {
        let base = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 16)
        base.initializeMemory(as: UInt8.self, repeating: 0, count: count)
        return base
    }
}
