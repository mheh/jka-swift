import Testing
@testable import JKAShared

@Test("a suffix subscript reads the bytes from the offset to the end")
func suffixSubscriptReadsFromOffset() {
    let buf = CharBuf("stormtrooper_red")
    let start = strlen(buf) - 3

    #expect(String(buf[start...]) == "red")
    #expect(Q_strncmp("red", buf[start...], 3) == 0)
}

@Test("strcpy at an offset writes from that byte with the NUL")
func strcpyAtOffsetWritesFromThatByte() {
    var buf = CharBuf(64)
    strcpy(&buf, "models/players/jedi/model.glm")
    let slash: Int32 = strlen(buf) - Int32("model.glm".utf8.count) - 1

    #expect(buf[slash] == Int32(ascii: "/"))
    strcpy(&buf, "/animation.cfg", at: slash)
    #expect(String(buf) == "models/players/jedi/animation.cfg")
}

@Test("strcat appends at the first NUL of the buffer")
func strcatAppendsAtTheFirstNul() {
    var buf = CharBuf(64)
    strcpy(&buf, "ext_data/Siege/Classes/")
    strcat(&buf, "rebel_assault.scl")

    #expect(String(buf) == "ext_data/Siege/Classes/rebel_assault.scl")
}

@Test("strcat at an offset appends at the first NUL from that byte")
func strcatAtOffsetAppendsFromThatByte() {
    var buf = CharBuf(64)
    strcpy(&buf, "first")
    let marker: Int32 = strlen(buf) + 1
    strcpy(&buf, "second", at: marker)
    strcat(&buf, " and more", at: marker)

    #expect(String(buf) == "first")
    #expect(String(buf[marker...]) == "second and more")
}

@Test("strcat takes a buffer as its source")
func strcatTakesABufferSource() {
    var dest = CharBuf(32)
    strcpy(&dest, "saber")
    strcat(&dest, CharBuf("_blue"))

    #expect(String(dest) == "saber_blue")
}

@Test("strcat at an offset takes a buffer as its source")
func strcatAtOffsetTakesABufferSource() {
    var dest = CharBuf(32)
    strcpy(&dest, "head", at: 4)
    strcat(&dest, CharBuf("_tail"), at: 4)

    #expect(String(dest[4...]) == "head_tail")
}

@Test("strcat at an offset takes a raw allocation as its source")
func strcatAtOffsetTakesARawSource() {
    let source = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
    defer { source.deallocate() }
    strcpy(source, "vwp data")

    var dest = CharBuf(32)
    strcpy(&dest, "start ")
    strcat(&dest, source, at: 0)

    #expect(String(dest) == "start vwp data")
}

@Test("strcmp compares two Swift strings")
func strcmpComparesTwoStrings() {
    #expect(strcmp("rebel", "rebel") == 0)
    #expect(strcmp("rebel", "rebem") < 0)
    #expect(strcmp("rebel", "rebe") > 0)
}
