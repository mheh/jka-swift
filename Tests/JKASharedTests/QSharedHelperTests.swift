import Testing
@testable import JKAShared

@Test("strncpy at an offset copies n bytes from that byte and pads with NUL")
func strncpyAtOffsetPadsWithNul() {
    var buf = CharBuf(16)
    strcpy(&buf, "abcdefghijklmno")
    strncpy(&buf, "xy", 4, at: 3)

    #expect(String(buf) == "abcxy")
    #expect(buf[5] == Int32(0))
    #expect(buf[6] == Int32(0))
    #expect(buf[7] == Int32(ascii: "h"))
}

@Test("strncpy at an offset writes no NUL when the source is n bytes or longer")
func strncpyAtOffsetWritesNoNulForALongSource() {
    var buf = CharBuf(16)
    strcpy(&buf, "abcdefgh")
    strncpy(&buf, "WXYZ", 2, at: 1)

    #expect(String(buf) == "aWXdefgh")
}

@Test("tolower and toupper map only the ASCII letters")
func toLowerAndToUpperMapOnlyLetters() {
    #expect(tolower(Int32(ascii: "Q")) == Int32(ascii: "q"))
    #expect(tolower(Int32(ascii: "q")) == Int32(ascii: "q"))
    #expect(tolower(Int32(ascii: "[")) == Int32(ascii: "["))
    #expect(toupper(Int32(ascii: "z")) == Int32(ascii: "Z"))
    #expect(toupper(Int32(ascii: "{")) == Int32(ascii: "{"))
    #expect(toupper(-61) == -61)
}

@Test("an Int32 range subscript reads and writes a row of an array")
func int32RangeSubscriptReadsAndWritesARow() {
    let x: Int32 = 3
    let i: Int32 = 1
    var m = [Float](repeating: 0, count: x * 2)
    let row: [Float] = [1, 2, 3]
    m[i * x ..< i * x + x] = row[...]

    #expect(m == [0, 0, 0, 1, 2, 3])
    #expect(Array(m[i * x ..< i * x + x]) == row)
}

@Test("an Int32 count makes an array of that many elements")
func int32CountMakesAnArray() {
    let count: Int32 = 4
    let a = [Int32](repeating: 7, count: count)

    #expect(a == [7, 7, 7, 7])
}

@Test("Q_IsColorString takes an Int32 byte offset")
func colorStringTakesAnInt32Offset() {
    let buf = CharBuf("ab^3c")
    let p: Int32 = 2

    #expect(Q_IsColorString(buf, at: p) == true)
    #expect(Q_IsColorString(buf, at: p + 1) == false)
}
