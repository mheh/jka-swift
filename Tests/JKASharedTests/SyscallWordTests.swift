import Testing
@testable import JKAShared

@Test("a float packs as the sign-extended word PASSFLOAT makes")
func floatPacksAsSignExtendedWord() {
    #expect(Float(1.0).word == 0x3F80_0000)
    #expect(Float(-1.0).word == Int(Int32(bitPattern: 0xBF80_0000)))
    #expect(Float(0.0).word == 0)
}

@Test("a bool packs as 1 or 0")
func boolPacksAsOneOrZero() {
    #expect(true.word == 1)
    #expect(false.word == 0)
}

@Test("a negative int32 packs as a negative word")
func negativeInt32PacksAsNegativeWord() {
    #expect(Int32(-1).word == -1)
    #expect(Int32(-2048).word == -2048)
    #expect(Int32.min.word == -2_147_483_648)
}
