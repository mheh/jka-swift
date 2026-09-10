/// The text behind one of Raven's `char *` fields, as a pointer the engine can read.
/// A field holds a string literal, a pointer from the world's `StringPool`, a pointer copied from another field, or `nil`.
/// Raven's `char *` carries no length, so this type carries none either, and it has no mutating API.
public struct PooledString: Hashable, ExpressibleByStringLiteral {
    /// The C pointer itself. A generated setter in another module writes it into the field, so it is public.
    public let raw: UnsafeMutablePointer<CChar>

    /// The text as a Swift string, read to the NUL.
    public var string: String { String(cString: self.raw) }

    /// The pointer a `char *` field holds, or `nil` for a null field.
    public init?(raw: UnsafeMutablePointer<CChar>?) {
        guard let raw else { return nil }
        self.raw = raw
    }

    /// The pointer for memory a body just wrote a string into, Raven's `(char *)` cast on the allocator's pointer.
    public init(_ raw: UnsafeMutableRawPointer) {
        self.raw = raw.assumingMemoryBound(to: CChar.self)
    }

    /// A literal points into the binary's read-only data, NUL-terminated and alive for the process, exactly as Raven's C literals were.
    public init(stringLiteral literal: StaticString) {
        precondition(literal.hasPointerRepresentation, "a PooledString literal must have UTF-8 storage")
        self.raw = UnsafeMutableRawPointer(mutating: literal.utf8Start).assumingMemoryBound(to: CChar.self)
    }

    /// Two pooled strings are the same string when they are the same pointer, as Raven's `==` on a `char *` was.
    public static func == (lhs: PooledString, rhs: PooledString) -> Bool {
        lhs.raw == rhs.raw
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.raw)
    }
}

// MARK: - Text compare

/// The text compares read as Raven's `strcmp` did, so `ent.classname == "noclass"` says what the C said.
public func == (lhs: PooledString?, rhs: String) -> Bool {
    lhs?.string == rhs
}

public func == (lhs: String, rhs: PooledString?) -> Bool {
    lhs == rhs?.string
}

public func != (lhs: PooledString?, rhs: String) -> Bool {
    !(lhs == rhs)
}

public func != (lhs: String, rhs: PooledString?) -> Bool {
    !(lhs == rhs)
}
