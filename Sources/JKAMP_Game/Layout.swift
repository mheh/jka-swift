internal import CJKAMP_Game

/// This namespace reports the sizes Clang gives the game module structs the engine dereferences, from g_public.h.
/// The test target compares them with the numbers jka-rust verified on a 64-bit host.
public enum GameLayout {
    public static let entityShared = MemoryLayout<entityShared_t>.size
    public static let sharedEntity = MemoryLayout<sharedEntity_t>.size
    public static let entity = MemoryLayout<gentity_t>.size
    public static let level = MemoryLayout<level_locals_t>.size
}
