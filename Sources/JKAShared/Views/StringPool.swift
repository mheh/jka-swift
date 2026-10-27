/// The module's string pool, the only source of a runtime pointer for a `char *` field. Rule 9.
/// The pool copies each distinct text once and keeps it for the life of the module, because the engine reads the pointer at any time.
/// A view's `String?` setter over a `char *` field interns through `shared`, so a body stores plain text and the engine reads a pointer.
public final class StringPool {
    // MARK: - State

    /// The one pool of the process. The world holds it too, and a fresh world for a test keeps the same pool, because the pool never frees.
    nonisolated(unsafe) public static let shared = StringPool()

    private var pointers: [String: UnsafeMutablePointer<CChar>] = [:]

    public init() {}

    /// This returns the pool's pointer for a text, or `nil` for no text, the value a `char *` field setter stores.
    public func pointer(for string: String?) -> UnsafeMutablePointer<CChar>? {
        string.map { self.intern($0).raw }
    }

    /// This returns the pool's pointer for a text, and copies the text in on first use.
    /// The memory is never freed, so a returned pointer stays valid.
    public func intern(_ string: String) -> PooledString {
        if let pointer = self.pointers[string] {
            return PooledString(raw: pointer)!
        }
        let pointer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(strlen(string)) + 1)
        strcpy(UnsafeMutableRawPointer(pointer), string)
        self.pointers[string] = pointer
        return PooledString(raw: pointer)!
    }
}
