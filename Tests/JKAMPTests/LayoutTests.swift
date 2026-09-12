import Testing
@testable import JKAMP

// The expected sizes are the oracle's, and they hold on every ABI, because these five types carry no pointer and no long.
// layout_asserts.h in CJKAMP and CJKAShared shows the same number for each in its ilp32, llp64, and lp64 blocks.
@Test("the MP tree boundary structs have the oracle's sizes")
func boundaryStructSizes() {
    #expect(Layout.entityState == 532)
    #expect(Layout.playerState == 1552)
    #expect(Layout.usercmd == 28)
    #expect(Layout.trace == 48)
    #expect(Layout.gameState == 22804)
}
