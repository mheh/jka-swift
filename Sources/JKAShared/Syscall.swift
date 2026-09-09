/// A transport carries one trap to an engine and returns the engine's word.
/// The engine conformer is `EngineTransport`, and a test installs a recorder.
public protocol SyscallTransport {
    func call(_ command: Int, _ words: [Int]) -> Int
}

/// This namespace holds the one transport the module talks through.
/// The engine calls the module from one thread, so the static needs no isolation.
public enum Syscall {
    /// The installed transport, set once by `dllEntry` or by a test.
    nonisolated(unsafe) public static var transport: SyscallTransport?

    /// This sends one trap through the transport and returns the engine's word.
    /// A call before `dllEntry` traps, because the module has no engine yet.
    @discardableResult
    public static func call(_ command: Int, _ words: [Int] = []) -> Int {
        guard let transport = self.transport else { fatalError("Syscall.call before dllEntry") }
        return transport.call(command, words)
    }
}
