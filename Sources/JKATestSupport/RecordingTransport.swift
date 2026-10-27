import JKAShared

/// This transport records every trap and answers each with a scripted word.
/// A test reads `calls` and `texts` after the code under test ran.
/// `JKAShared` does not know `gameImport_t`, so the test names the text commands itself.
public final class RecordingTransport: SyscallTransport {
    /// Every trap in the order the module sent it.
    public private(set) var calls: [(command: Int, words: [Int])] = []

    /// The first word of a text trap, read as a C string.
    public private(set) var texts: [(command: Int, text: String)] = []

    /// The word each command returns. An unlisted command returns 0.
    public var answers: [Int: Int] = [:]

    /// The commands whose first word is a C string, `G_PRINT` and `G_ERROR` first.
    public var textCommands: Set<Int> = []

    public init() {}

    public func call(_ command: Int, _ words: [Int]) -> Int {
        self.calls.append((command: command, words: words))
        if self.textCommands.contains(command), let first = words.first,
           let pointer = UnsafePointer<CChar>(bitPattern: first) {
            self.texts.append((command: command, text: cString(at: pointer)))
        }
        return self.answers[command] ?? 0
    }
}
