extension Bool {
    /// Raven's `(qboolean)x` cast of an `int`, true for any value but 0.
    /// C keeps the integer in the enum, and every reader in the game tests its truth alone, so 16 and 1 both become `true`.
    public init(_ value: Int32) {
        self = value != 0
    }
}
