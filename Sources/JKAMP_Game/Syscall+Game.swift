import JKAShared

extension Syscall {
    /// This packs typed words for one game import and sends it through the transport.
    /// The variadic list is the trap's arguments in Raven's order.
    @discardableResult
    public static func call(_ command: gameImport_t, _ words: any SyscallWord...) -> Int {
        self.call(Int(command.rawValue), words.map(\.word))
    }
}
