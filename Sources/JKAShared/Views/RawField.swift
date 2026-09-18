/// Raven writes `*(int *)(b+f->ofs) = atoi(value)` in `BG_ParseField`, one cast per C type at a byte offset.
/// This extension gives one labeled subscript per type, so a ported body reads `b[int: f.ofs] = atoi(value)`.
/// A body never writes `storeBytes` or `MemoryLayout` itself, under rule 11.
extension UnsafeMutableRawPointer {
    /// The `Int32` at a byte offset, Raven's `*(int *)(b+ofs)`.
    public subscript<I: BinaryInteger>(int ofs: I) -> Int32 {
        get {
            (self + ofs).loadUnaligned(as: Int32.self)
        }
        nonmutating set {
            (self + ofs).storeBytes(of: newValue, as: Int32.self)
        }
    }

    /// The `Float` at a byte offset, Raven's `*(float *)(b+ofs)`.
    public subscript<I: BinaryInteger>(float ofs: I) -> Float {
        get {
            (self + ofs).loadUnaligned(as: Float.self)
        }
        nonmutating set {
            (self + ofs).storeBytes(of: newValue, as: Float.self)
        }
    }

    /// The Nth `Float` after a byte offset, Raven's `((float *)(b+ofs))[index]`.
    public subscript<I: BinaryInteger, J: BinaryInteger>(float ofs: I, _ index: J) -> Float {
        get {
            (self + ofs + Int(index) * MemoryLayout<Float>.stride).loadUnaligned(as: Float.self)
        }
        nonmutating set {
            (self + ofs + Int(index) * MemoryLayout<Float>.stride).storeBytes(of: newValue, as: Float.self)
        }
    }

    /// One byte at a byte offset, Raven's `b[i]` through a `char *` the pool or the engine owns.
    /// The getter sign-extends the byte as C does for a signed `char`, and the setter truncates, as `CharBuf` does.
    public subscript<I: BinaryInteger, T: BinaryInteger>(byte ofs: I) -> T {
        get { T(truncatingIfNeeded: (self + ofs).loadUnaligned(as: Int8.self)) }
        nonmutating set { (self + ofs).storeBytes(of: UInt8(truncatingIfNeeded: newValue), as: UInt8.self) }
    }

    /// The raw pointer a `char *` field holds at a byte offset, Raven's `*(char **)(b+ofs)`, and `nil` for a null field.
    public subscript<I: BinaryInteger>(pointer ofs: I) -> UnsafeMutableRawPointer? {
        get {
            (self + ofs).loadUnaligned(as: UnsafeMutableRawPointer?.self)
        }
        nonmutating set {
            (self + ofs).storeBytes(of: newValue, as: UnsafeMutableRawPointer?.self)
        }
    }

    /// The `PooledString` a `char *` field holds at a byte offset, `nil` for a null field.
    public subscript<I: BinaryInteger>(string ofs: I) -> PooledString? {
        get {
            PooledString(raw: (self + ofs).loadUnaligned(as: UnsafeMutablePointer<CChar>?.self))
        }
        nonmutating set {
            (self + ofs).storeBytes(of: newValue?.raw, as: UnsafeMutablePointer<CChar>?.self)
        }
    }
}

// MARK: - Pointer arithmetic with any integer

/// The standard library gives `+` and `-` for `Int`, so these stay generic to avoid an ambiguous overload against a plain `Int`.
extension UnsafeMutableRawPointer {
    public static func + <I: BinaryInteger>(lhs: UnsafeMutableRawPointer, rhs: I) -> UnsafeMutableRawPointer {
        lhs.advanced(by: Int(rhs))
    }

    public static func - <I: BinaryInteger>(lhs: UnsafeMutableRawPointer, rhs: I) -> UnsafeMutableRawPointer {
        lhs.advanced(by: -Int(rhs))
    }
}
