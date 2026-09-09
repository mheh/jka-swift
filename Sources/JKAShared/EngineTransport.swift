internal import CJKASyscall

/// This transport calls the engine's variadic entry point through the C shim.
/// The shim has one arm per word count, 0 through 13, and aborts on a wider call.
public struct EngineTransport: SyscallTransport {
    /// The engine's variadic entry point, as `dllEntry` handed it over.
    /// Swift imports a C variadic function pointer as `OpaquePointer`, so this is the C type under its Swift name.
    let entry: OpaquePointer

    public init(entry: OpaquePointer) {
        self.entry = entry
    }

    public func call(_ command: Int, _ words: [Int]) -> Int {
        // An empty array has no base address, so a wordless trap sends a null pointer the shim never reads.
        guard !words.isEmpty else {
            return Int(
                jka_syscall(
                    self.entry,
                    intptr_t(command),
                    0,
                    nil
                )
            )
        }
        return words.withUnsafeBufferPointer { buffer in
            let base = UnsafeRawPointer(buffer.baseAddress!).assumingMemoryBound(to: intptr_t.self)
            return Int(
                jka_syscall(
                    self.entry,
                    intptr_t(command),
                    Int32(words.count),
                    base
                )
            )
        }
    }
}
