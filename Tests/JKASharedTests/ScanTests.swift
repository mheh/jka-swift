import Testing
import JKAShared

@Test("three floats read into a vector")
func threeFloatsReadIntoAVector() {
    var v = vec3_t(0, 0, 0)

    #expect(sscanf("1 2.5 -3e2", "%f %f %f", &v) == 3)
    #expect(v.x == 1)
    #expect(v.y == 2.5)
    #expect(v.z == -300)
}

@Test("two numbers leave the third axis alone")
func twoNumbersLeaveTheThirdAxisAlone() {
    var v = vec3_t(0, 0, 99)

    #expect(sscanf("10 20", "%f %f %f", &v) == 2)
    #expect(v.x == 10)
    #expect(v.y == 20)
    #expect(v.z == 99)
}

@Test("an empty string reads nothing")
func anEmptyStringReadsNothing() {
    var v = vec3_t(1, 2, 3)

    #expect(sscanf("", "%f %f %f", &v) == 0)
    #expect(v == vec3_t(1, 2, 3))
}

@Test("tabs and several spaces separate the numbers")
func tabsAndSeveralSpacesSeparateTheNumbers() {
    var v = vec3_t(0, 0, 0)

    #expect(sscanf("  4\t\t5   -6  ", "%f %f %f", &v) == 3)
    #expect(v == vec3_t(4, 5, -6))
}

@Test("a newline also separates the numbers")
func aNewlineAlsoSeparatesTheNumbers() {
    var v = vec3_t(0, 0, 0)

    #expect(sscanf("7\n8\r\n9", "%f %f %f", &v) == 3)
    #expect(v == vec3_t(7, 8, 9))
}

@Test("a single percent f reads one float past the leading spaces")
func aSinglePercentFReadsOneFloat() {
    var f: Float = 0

    #expect(sscanf("  -0.75", "%f", &f) == 1)
    #expect(f == -0.75)
}

@Test("a percent d reads one integer")
func aPercentDReadsOneInteger() {
    var n: Int32 = 0

    #expect(sscanf("42", "%d", &n) == 1)
    #expect(n == 42)
}

@Test("a percent d stops at the text after the number")
func aPercentDStopsAtTheTextAfterTheNumber() {
    var n: Int32 = 0

    #expect(sscanf("-7 junk", "%d", &n) == 1)
    #expect(n == -7)
}

@Test("a percent i reads the same as a percent d")
func aPercentIReadsTheSameAsAPercentD() {
    var n: Int32 = 0

    #expect(sscanf("123", "%i", &n) == 1)
    #expect(n == 123)
}

@Test("text with no number leaves the target alone")
func textWithNoNumberLeavesTheTargetAlone() {
    var f: Float = 5
    var n: Int32 = 5

    #expect(sscanf("kyle", "%f", &f) == 0)
    #expect(f == 5)
    #expect(sscanf("kyle", "%d", &n) == 0)
    #expect(n == 5)
}

@Test("a buffer holds the text the scan reads")
func aBufferHoldsTheTextTheScanReads() {
    let origin: CharBuf = "64 -128 24.5"
    var v = vec3_t(0, 0, 0)
    var n: Int32 = 0
    var f: Float = 0

    #expect(sscanf(origin, "%f %f %f", &v) == 3)
    #expect(v == vec3_t(64, -128, 24.5))
    #expect(sscanf(CharBuf("300"), "%d", &n) == 1)
    #expect(n == 300)
    #expect(sscanf(CharBuf("  1.5"), "%f", &f) == 1)
    #expect(f == 1.5)
}
