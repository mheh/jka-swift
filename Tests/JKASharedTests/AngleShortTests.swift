import Testing
@testable import JKAShared

@Test("ANGLE2SHORT converts a degree angle to Raven's short encoding")
func angle2ShortConvertsDegrees() {
    #expect(ANGLE2SHORT(0) == 0)
    #expect(ANGLE2SHORT(90) == 16384)
    #expect(ANGLE2SHORT(360) == 0)
    #expect(ANGLE2SHORT(-90) == 49152)
}

@Test("SHORT2ANGLE converts Raven's short encoding back to degrees")
func short2AngleConvertsBack() {
    #expect(SHORT2ANGLE(16384) == 90)
}

@Test("a round trip through both functions returns the original angle")
func roundTripReturnsOriginalAngle() {
    #expect(SHORT2ANGLE(ANGLE2SHORT(45)) == 45)
}
