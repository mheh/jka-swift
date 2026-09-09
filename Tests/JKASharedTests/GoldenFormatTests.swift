import JKAShared
import JKATestSupport
import Testing

@Suite("GoldenFormat writes the tokens the Oracle dumpers print")
struct GoldenFormatTests {
    @Test(
        "a float prints as its eight-digit bit pattern",
        arguments: [
            (Float(1.0), "3f800000"),
            (Float(0.0), "00000000"),
            (Float(-0.0), "80000000"),
            (Float(-2.0), "c0000000"),
            (Float(100.0), "42c80000"),
            (Float.infinity, "7f800000"),
        ]
    )
    func floatPrintsAsBits(value: Float, expected: String) {
        #expect(GoldenFormat.bits(value) == expected)
    }

    @Test("a NaN of either sign normalizes to the positive quiet NaN")
    func nanNormalizes() {
        #expect(GoldenFormat.bits(Float(bitPattern: 0xffc0_0000)) == "7fc00000")
        #expect(GoldenFormat.bits(Float(bitPattern: 0x7f80_0001)) == "7fc00000")
    }

    @Test("a vector prints as space-separated patterns")
    func vectorPrints() {
        #expect(GoldenFormat.vector(vec3_t(1, 0, -2)) == "3f800000 00000000 c0000000")
        #expect(GoldenFormat.vector4(vec4_t(1, 0, -2, 100)) == "3f800000 00000000 c0000000 42c80000")
    }

    @Test("a byte prints as two hex digits")
    func bytePrints() {
        #expect(GoldenFormat.hex2(0) == "00")
        #expect(GoldenFormat.hex2(128) == "80")
        #expect(GoldenFormat.hex2(255) == "ff")
    }

    @Test("a match reports nothing and a mismatch names the first differing line")
    func mismatchReports() {
        #expect(GoldenFormat.mismatch("t", got: "a\nb\n", golden: "a\nb\n") == nil)
        let message = GoldenFormat.mismatch("t", got: "a\nc\n", golden: "a\nb\n")
        #expect(message?.contains("line 2") == true)
    }
}
