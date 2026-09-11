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
