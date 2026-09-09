internal import CJKACore

/// This namespace holds the one syscall pointer the engine hands over at `dllEntry`.
/// The engine calls the module from one thread, so the static needs no isolation.
public enum Syscall {
    /// The engine's variadic entry point, set once by `dllEntry`.
    /// Swift imports a C variadic function pointer as `OpaquePointer`, so this is the C type under its Swift name.
    nonisolated(unsafe) public static var entry: OpaquePointer?

    /// This sends one trap to the engine and returns the engine's word.
    /// A call before `dllEntry` traps, because the module has no engine yet.
    public static func call(_ command: Int, _ args: [Int] = []) -> Int {
        guard let entry = self.entry else { fatalError("Syscall.call before dllEntry") }
        return args.withUnsafeBufferPointer { buffer in
            let words = UnsafeRawPointer(buffer.baseAddress!).assumingMemoryBound(to: intptr_t.self)
            return Int(jka_syscall(entry, intptr_t(command), Int32(args.count), words))
        }
    }
}
