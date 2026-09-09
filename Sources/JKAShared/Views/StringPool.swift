/// The world's string pool, the only source of a runtime pointer for a `char *` field. Rule 9.
/// The pool copies each distinct text once and keeps it for the life of the module, because the engine reads the pointer at any time.
public final class StringPool {
    // MARK: - State

    private var pointers: [String: UnsafeMutablePointer<CChar>] = [:]

    public init() {}

    /// This returns the pool's pointer for a text, and copies the text in on first use.
    /// The memory is never freed, so a returned pointer stays valid.
    public func intern(_ string: String) -> PooledString {
        if let pointer = self.pointers[string] {
            return PooledString(raw: pointer)!
        }
        let bytes = Array(string.utf8)
        let pointer = UnsafeMutablePointer<CChar>.allocate(capacity: bytes.count + 1)
        for (index, byte) in bytes.enumerated() {
            pointer[index] = CChar(bitPattern: byte)
        }
        pointer[bytes.count] = 0
        self.pointers[string] = pointer
        return PooledString(raw: pointer)!
    }
}
