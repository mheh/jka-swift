/// A value that packs into one syscall word, as Raven's `int` argument did.
/// The typed trap layer maps each argument through `word` before it calls the transport.
public protocol SyscallWord {
    var word: Int { get }
}

extension Int: SyscallWord {
    public var word: Int { self }
}

extension Int32: SyscallWord {
    public var word: Int { Int(self) }
}

extension Bool: SyscallWord {
    public var word: Int { self ? 1 : 0 }
}

extension Float: SyscallWord {
    /// This is the sign-extended word Raven's `PASSFLOAT` macro makes.
    /// Source: oracle/codemp/game/g_syscalls.c:21
    public var word: Int { Int(Int32(bitPattern: self.bitPattern)) }
}

extension OpaquePointer: SyscallWord {
    public var word: Int { Int(bitPattern: self) }
}

extension UnsafePointer: SyscallWord {
    public var word: Int { Int(bitPattern: self) }
}

extension UnsafeMutablePointer: SyscallWord {
    public var word: Int { Int(bitPattern: self) }
}

extension UnsafeRawPointer: SyscallWord {
    public var word: Int { Int(bitPattern: self) }
}

extension UnsafeMutableRawPointer: SyscallWord {
    public var word: Int { Int(bitPattern: self) }
}

extension Optional: SyscallWord where Wrapped: SyscallWord {
    /// A nil pointer is the zero word, as Raven's `NULL` argument was.
    public var word: Int { self?.word ?? 0 }
}

extension UInt32: SyscallWord {
    public var word: Int { Int(self) }
}

extension UInt: SyscallWord {
    public var word: Int { Int(bitPattern: self) }
}
