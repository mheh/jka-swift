import Testing
import JKAShared

@Test("a percent i prints the integer")
func percentIPrintsTheInteger() {
    #expect(format("%i", [Int32(42)]) == "42")
    #expect(format("client %i entered", [Int32(3)]) == "client 3 entered")
}

@Test("a percent d prints the integer")
func percentDPrintsTheInteger() {
    #expect(format("%d", [Int32(-7)]) == "-7")
    #expect(format("%d of %d", [Int(1), Int(16)]) == "1 of 16")
}

@Test("a percent s prints the text")
func percentSPrintsTheText() {
    #expect(format("%s", ["kyle"]) == "kyle")
    #expect(format("*%s*", ["saber"]) == "*saber*")
}

@Test("a percent f prints six places")
func percentFPrintsSixPlaces() {
    #expect(format("%f", [Float(1.5)]) == "1.500000")
    #expect(format("%f", [Double(0)]) == "0.000000")
    #expect(format("%f", [Double(-2.25)]) == "-2.250000")
}

@Test("a percent point two f prints two places")
func percentPointTwoFPrintsTwoPlaces() {
    #expect(format("%.2f", [Float(3.5)]) == "3.50")
    #expect(format("%.2f", [Double(-1.5)]) == "-1.50")
    #expect(format("%.2f", [Double(0.126)]) == "0.13")
}

@Test("a percent four i pads a negative integer on the left")
func percentFourIPadsOnTheLeft() {
    #expect(format("%4i", [Int32(-42)]) == " -42")
    #expect(format("%4i", [Int32(7)]) == "   7")
    #expect(format("%4i", [Int32(-12345)]) == "-12345")
}

@Test("a percent minus twenty s pads the text to exactly twenty")
func percentMinusTwentySPadsToWidth() {
    let padded = format("%-20s", ["kyle"])

    #expect(padded == "kyle                ")
    #expect(padded.count == 20)
}

@Test("a percent minus sixteen s pads the text on the right")
func percentMinusSixteenSPadsOnTheRight() {
    let padded = format("%-16s|", ["reborn"])

    #expect(padded == "reborn          |")
    #expect(format("%-16s", ["a_very_long_model_name"]) == "a_very_long_model_name")
}

@Test("a percent five point two f pads the number on the left")
func percentFivePointTwoFPadsOnTheLeft() {
    #expect(format("%5.2f", [Float(3.14159)]) == " 3.14")
    #expect(format("%5.2f", [Float(-3.14159)]) == "-3.14")
}

@Test("a percent one point two f keeps both places under its width")
func percentOnePointTwoFKeepsBothPlaces() {
    #expect(format("%1.2f", [Float(0.5)]) == "0.50")
}

@Test("a percent point one f prints one place")
func percentPointOneFPrintsOnePlace() {
    #expect(format("%.1f", [Float(3.46)]) == "3.5")
    #expect(format("%.1f", [Double(-0.75)]) == "-0.8")
}

@Test("a doubled percent prints one percent")
func doubledPercentPrintsOnePercent() {
    #expect(format("100%%", []) == "100%")
    #expect(format("%i%% health", [Int32(85)]) == "85% health")
}

@Test("a mixed format takes a string and a buffer")
func mixedFormatTakesStringAndBuffer() {
    let model: CharBuf = "jedi_tf"

    #expect(format("models/players/%s/model_%s.skin", ["kyle", model]) == "models/players/kyle/model_jedi_tf.skin")
}

@Test("a pooled string prints under percent s")
func pooledStringPrintsUnderPercentS() {
    let classname: PooledString = "func_door"

    #expect(format("%s touched", [classname]) == "func_door touched")
}

@Test("a value that sits under the halfway point rounds down")
func valueUnderHalfRoundsDown() {
    // 2.675 and 1.005 are both a little under their decimal text, so C prints 2.67 and 1.00.
    #expect(format("%.2f", [Double(2.675)]) == "2.67")
    #expect(format("%.2f", [Double(1.005)]) == "1.00")
}

@Test("a percent s precision truncates the text")
func percentSPrecisionTruncates() {
    #expect(format("%.3s", ["kyle"]) == "kyl")
}
