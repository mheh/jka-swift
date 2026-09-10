import JKAMP

/// All state of the bg files, rule 3. One instance exists behind `bg`, and a test assigns a fresh one.
/// The game module and cgame each link this code with their own instance, so nothing here reaches `world`.
final class BgState {
    // MARK: - State

    // A transcriptor adds each Raven static of a bg_*.c file here, with Raven's name and a /// Source: line.
}

/// The one instance. The engine calls the module from one thread, so this is not isolated.
nonisolated(unsafe) var bg = BgState()
