import Testing
@testable import JKAShared

@Test("DEG2RAD converts 180 degrees to pi radians")
func deg2RadConvertsHalfTurn() {
    #expect(DEG2RAD(180) == M_PI)
}

@Test("RAD2DEG converts pi radians to 180 degrees")
func rad2DegConvertsHalfTurn() {
    #expect(RAD2DEG(M_PI) == 180)
}

@Test("a round trip through both functions returns the original angle")
func degreeRoundTripReturnsOriginalAngle() {
    #expect(abs(RAD2DEG(DEG2RAD(45)) - 45) < 0.001)
}

@Test("VALIDSTRING is false for an empty string and true for text")
func validStringTestsTheFirstByte() {
    #expect(VALIDSTRING("") == false)
    #expect(VALIDSTRING("red") == true)
}

@Test("VALIDSTRING is false for a null pooled string")
func validStringTestsThePooledPointer() {
    let none: PooledString? = nil
    #expect(VALIDSTRING(none) == false)
    #expect(VALIDSTRING(PooledString("")) == false)
    #expect(VALIDSTRING(PooledString("red")) == true)
}

@Test("Q_IsColorString accepts a color escape and a digit")
func colorStringAcceptsADigit() {
    #expect(Q_IsColorString("^1x", at: 0) == true)
    #expect(Q_IsColorString("x^1", at: 1) == true)
}

@Test("Q_IsColorString rejects a doubled escape and a digit above seven")
func colorStringRejectsTheOtherForms() {
    #expect(Q_IsColorString("^^", at: 0) == false)
    #expect(Q_IsColorString("^8", at: 0) == false)
}

@Test("ColorIndex maps a digit to its color slot")
func colorIndexMapsADigit() {
    #expect(ColorIndex(CChar(UInt8(ascii: "3"))) == 3)
    #expect(ColorIndex(CChar(UInt8(ascii: ";"))) == 3)
}

@Test("PlaneTypeForNormal names the axis a normal points along")
func planeTypeNamesTheAxis() {
    #expect(PlaneTypeForNormal(vec3_t(1, 0, 0)) == PLANE_X)
    #expect(PlaneTypeForNormal(vec3_t(0, 1, 0)) == PLANE_Y)
    #expect(PlaneTypeForNormal(vec3_t(0, 0, 1)) == PLANE_Z)
    #expect(PlaneTypeForNormal(vec3_t(0.7071, 0.7071, 0)) == PLANE_NON_AXIAL)
}
