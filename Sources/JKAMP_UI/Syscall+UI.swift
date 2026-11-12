import JKAShared
import JKAMP

extension Syscall {
    /// This packs typed words for one ui import and sends it through the transport.
    /// The variadic list is the trap's arguments in Raven's order.
    @discardableResult
    public static func call(_ command: uiImport_t, _ words: any SyscallWord...) -> Int {
        self.call(Int(command), words.map(\.word))
    }
}
