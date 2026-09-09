import Testing
@testable import JKAShared

@Test("a literal pooled string reads back as its text")
func literalPooledStringReadsBack() {
    let classname: PooledString = "noclass"

    #expect(classname.string == "noclass")
    #expect(classname == "noclass")
    #expect(classname != "func_door")
}

@Test("the pool interns one text once and hands out the same pointer")
func poolInternsEachTextOnce() {
    let pool = StringPool()

    let first = pool.intern("bodyque")
    let second = pool.intern("bodyque")
    let other = pool.intern("noclass")

    #expect(first.raw == second.raw)
    #expect(first == second)
    #expect(first.raw != other.raw)
    #expect(first.string == "bodyque")
    #expect(other == "noclass")
}

@Test("a null char pointer is nil")
func nullPointerIsNil() {
    #expect(PooledString(raw: nil) == nil)
}
