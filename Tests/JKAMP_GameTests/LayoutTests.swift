import Testing
@testable import JKAMP_Game

// The expected sizes come from the oracle asserts, and jka-rust allocates its entity slab as 976 * 128, 64-bit host.
@Test("the game module boundary structs have the sizes jka-rust verified")
func gameStructSizes() {
    #expect(GameLayout.entityShared == 112)
    #expect(GameLayout.sharedEntity == 976)
    #expect(GameLayout.entity == 1832)
    #expect(GameLayout.level == 47176)
}
