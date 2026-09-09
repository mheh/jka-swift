internal import CJKAMP
import JKAShared

/// This namespace reports the sizes Clang gives the MP tree structs that cross the engine boundary.
/// The test target compares them with the numbers jka-rust verified on a 64-bit host.
public enum Layout {
    public static let entityState = MemoryLayout<entityState_t>.size
    public static let playerState = MemoryLayout<playerState_t>.size
    public static let usercmd = MemoryLayout<usercmd_t>.size
    public static let trace = MemoryLayout<trace_t>.size
    public static let gameState = MemoryLayout<gameState_t>.size
}
