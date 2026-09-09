import Testing
@testable import JKAMP

// The expected sizes come from the const asserts in jka-rust/crates/mp/qshared, 64-bit host.
@Test("the MP tree boundary structs have the sizes jka-rust verified")
func boundaryStructSizes() {
    #expect(Layout.entityState == 532)
    #expect(Layout.playerState == 1552)
    #expect(Layout.usercmd == 28)
    #expect(Layout.trace == 48)
    #expect(Layout.gameState == 22804)
}
