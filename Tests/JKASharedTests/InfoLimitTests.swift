import Testing
@testable import JKAShared

@Test("Info_SetValueForKey does not change the string for a sum of exactly MAX_INFO_STRING")
func infoSetValueForKeyStopsAtTheLimit() {
    // given
    let old = "\\a\\" + String(repeating: "x", count: Int(MAX_INFO_STRING) - 7)
    var s = CharBuf(1100)
    strcpy(&s, old)
    #expect(strlen(s) + 4 == MAX_INFO_STRING)

    // when
    Info_SetValueForKey(&s, "k", "v")

    // then
    #expect(String(s) == old)
}

@Test("Info_SetValueForKey_Big does not change the string for a sum of exactly BIG_INFO_STRING")
func infoSetValueForKeyBigStopsAtTheLimit() {
    // given
    let old = "\\a\\" + String(repeating: "x", count: Int(BIG_INFO_STRING) - 7)
    var s = CharBuf(9000)
    strcpy(&s, old)
    #expect(strlen(s) + 4 == BIG_INFO_STRING)

    // when
    Info_SetValueForKey_Big(&s, "k", "v")

    // then
    #expect(String(s) == old)
}
