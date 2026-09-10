import JKAMP

/// All state of the bg files, rule 3. One instance exists behind `bg`, and a test assigns a fresh one.
/// The game module and cgame each link this code with their own instance, so nothing here reaches `world`.
final class BgState {
    // MARK: - State

    // A transcriptor adds each Raven static of a bg_*.c file here, with Raven's name and a /// Source: line.

    // MARK: - bg_misc.c

    // Port-note: Raven sizes `bg_pool` from `MAX_POOL_SIZE`, which `#ifdef`s to 3000000 for QAGAME, 2048000 for
    // CGAME, and 512000 for the UI. `JKAMP_BG` is one Swift module shared by every consumer, with no build flag
    // yet to pick a branch, so this keeps the QAGAME value until that design lands.

    /// Raven's `static int bg_poolSize` of `bg_misc.c`.
    /// Source: oracle/codemp/game/bg_misc.c:3325
    var poolSize: Int32 = 0

    /// Raven's `static int bg_poolTail` of `bg_misc.c`, initialized to `MAX_POOL_SIZE`.
    /// Source: oracle/codemp/game/bg_misc.c:3326
    var poolTail: Int32 = 3_000_000

    // MARK: - bg_pmove.c

    /// Source: oracle/codemp/game/bg_pmove.c:161
    var forceJumpStrength: [Float] = [
        Float(JUMP_VELOCITY), //normal jump
        420,
        590,
        840,
    ]
}

/// The one instance. The engine calls the module from one thread, so this is not isolated.
nonisolated(unsafe) var bg = BgState()
