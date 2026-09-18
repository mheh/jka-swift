import Testing
@testable import JKAShared

@Test("a cursor at an offset stands at that byte of the buffer")
func cursorAtOffsetStandsAtThatByte() {
    var buf = CharBuf(64)
    strcpy(&buf, "rebel_assault")
    let cursor = TextCursor(buf, at: 6)

    #expect(cursor.byte == Int32(ascii: "a"))
    #expect(!cursor.isNull)
}

@Test("the text of a cursor is the bytes from it to the first NUL")
func cursorTextReadsToTheFirstNul() {
    var buf = CharBuf(64)
    strcpy(&buf, "saber_single_1")
    strcpy(&buf, "saber_staff", at: 15)

    #expect(TextCursor(buf).text == "saber_single_1")
    #expect(TextCursor(buf, at: 15).text == "saber_staff")
    #expect(TextCursor().text == "")
}

@Test("advance by a count steps the cursor that many bytes")
func advanceByCountStepsTheCursor() {
    var buf = CharBuf(64)
    strcpy(&buf, "one")
    strcpy(&buf, "two", at: 4)

    var cursor = TextCursor(buf)
    cursor.advance(by: strlen(cursor.text) + 1)
    #expect(cursor.text == "two")

    var null = TextCursor()
    null.advance(by: 3)
    #expect(null.isNull)
}

@Test("the subscript reads the byte at a relative offset")
func subscriptReadsAtARelativeOffset() {
    var buf = CharBuf(8)
    strcpy(&buf, "abc")
    let cursor = TextCursor(buf, at: 1)

    #expect(cursor[0] == Int32(ascii: "b"))
    #expect(cursor[1] == Int32(ascii: "c"))
    #expect(cursor[-1] == Int32(ascii: "a"))
    #expect(cursor[99] == 0)
    #expect(TextCursor()[0] == 0)
}
