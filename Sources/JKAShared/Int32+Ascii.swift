extension Int32 {
    /// Raven's C character literal, `'a'`, spelled `Int32(ascii: "a")`, one call for one literal.
    /// The scalar must be ASCII, so the value is the byte a signed `char` holds for it.
    public init(ascii scalar: Unicode.Scalar) {
        precondition(scalar.isASCII, "Int32(ascii:) takes an ASCII scalar")
        self = Int32(scalar.value)
    }
}
