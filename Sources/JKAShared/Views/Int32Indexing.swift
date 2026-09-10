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
