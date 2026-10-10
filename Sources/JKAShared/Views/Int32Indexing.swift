/// A C integer index converts to `Int` and never fails, so these subscripts forward without a bounds check of their own.
/// The `Int` subscript underneath still runs its own range check, so a body reads `ps.stats[STAT_HEALTH]` exactly as Raven wrote it.

extension Slots {
    public subscript<I: BinaryInteger>(i: I) -> Element {
        get {
            self[Int(i)]
        }
        nonmutating set {
            self[Int(i)] = newValue
        }
    }
}

extension SIMD3 where Scalar == Float {
    public subscript<I: BinaryInteger>(i: I) -> Scalar {
        get {
            self[Int(i)]
        }
        set {
            self[Int(i)] = newValue
        }
    }
}

extension Array {
    public subscript<I: BinaryInteger>(i: I) -> Element {
        get {
            self[Int(i)]
        }
        set {
            self[Int(i)] = newValue
        }
    }
}

extension Array {
    /// This reads and writes the elements of a C integer range, so a body copies a row into `m[i * x ..< i * x + x]`.
    public subscript<I: BinaryInteger>(r: Range<I>) -> ArraySlice<Element> {
        get {
            self[Int(r.lowerBound) ..< Int(r.upperBound)]
        }
        set {
            self[Int(r.lowerBound) ..< Int(r.upperBound)] = newValue
        }
    }

    /// This makes an array of a C integer count, so a body declares `[Float](repeating: 0, count: x)` for Raven's `float row[x]`.
    public init<I: BinaryInteger>(repeating repeatedValue: Element, count: I) {
        self.init(repeating: repeatedValue, count: Int(count))
    }
}

/// This adds a C integer to a slice's start index, so a body writes `infos[infos.startIndex + count]` for Raven's `infos[count]`.
/// A slice keeps the parent's indices, and the sum is an `Int` that the slice's own subscript takes.
@_disfavoredOverload public func + <I: BinaryInteger>(lhs: Int, rhs: I) -> Int { lhs + Int(rhs) }
