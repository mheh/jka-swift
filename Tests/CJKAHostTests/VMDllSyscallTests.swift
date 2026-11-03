#if canImport(Glibc)
import Glibc
#else
import Darwin
#endif
@preconcurrency import CJKAHost
import CJKASyscall
import Testing

/// The words of the last call that reached the recording system call.
nonisolated(unsafe) private var recordedWords: [Int] = []

/// The stand-in for the Swift host's system call. It stores every word it gets and returns the command.
private let recordingSystemCall: jka_systemcall_fn = { parms in
    recordedWords = Array(UnsafeBufferPointer(start: parms, count: 15))
    return parms![0]
}

/// These tests call VM_DllSyscall as a module does, through the variadic shim of the module side.
/// Swift cannot name a C variadic function, so the test finds VM_DllSyscall with dlsym in its own process.
@Suite(.serialized)
struct VMDllSyscallSuite {
    @Test("a call with no words gives the command and a count of 15")
    func noWords() throws {
        let words: [Int] = []
        let answer = try Self.callThroughShim(command: 7, words: words)

        #expect(answer == 7)
        #expect(recordedWords.count == 15)
        #expect(recordedWords.first == 7)
    }

    @Test("a call with one word gives the command and that word")
    func oneWord() throws {
        let words = [-3]
        let answer = try Self.callThroughShim(command: 12, words: words)

        #expect(answer == 12)
        #expect(recordedWords.count == 15)
        #expect(Array(recordedWords.prefix(2)) == [12, -3])
    }

    @Test("a call with 14 words gives the command and all 14 words in order")
    func fourteenWords() throws {
        let words = (1...14).map { $0 * 1_000 }
        let answer = try Self.callThroughShim(command: 330, words: words)

        #expect(answer == 330)
        #expect(recordedWords == [330] + words)
    }

    @Test("a pointer word arrives whole")
    func pointerWord() throws {
        let text = strdup("jampded")!
        defer { free(text) }
        let address = Int(bitPattern: text)
        _ = try Self.callThroughShim(command: 1, words: [address])

        #expect(recordedWords[1] == address)
        #expect(String(cString: UnsafePointer<CChar>(bitPattern: recordedWords[1])!) == "jampded")
    }

    /// This installs the recording system call and sends the words through jka_syscall to VM_DllSyscall.
    private static func callThroughShim(command: Int, words: [Int]) throws -> Int {
        let process = try #require(dlopen(nil, RTLD_NOW))
        let callee = try #require(dlsym(process, "VM_DllSyscall"))

        recordedWords = []
        jka_systemCall = recordingSystemCall
        let answer = words.withUnsafeBufferPointer { buffer in
            jka_syscall(
                OpaquePointer(callee),
                command,
                Int32(words.count),
                buffer.baseAddress
            )
        }
        return answer
    }
}
