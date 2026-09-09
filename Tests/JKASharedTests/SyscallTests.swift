import Testing
@testable import JKAShared

@Test("the syscall entry is empty before dllEntry")
func syscallEntryStartsEmpty() {
    #expect(Syscall.entry == nil)
}
