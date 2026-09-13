// This is the VC libc version of rand() without multiple seeds per thread or 12 levels
// of subroutine calls.
// Both calls have been designed to minimise the inherent number of float <--> int
// conversions and the additional math required to get the desired value.
// eg the typical tint = (rand() * 255) / 32768
// becomes tint = irand(0, 255)

/// One `holdrand` state and the five draws Raven built on it.
/// Raven compiles `q_math.c` once per target, so game, cgame, ui, and the engine each hold a private seed.
/// The `rng` global of `q_math.swift` is the product's one instance, and the five bare functions there draw from it.
///
/// Source: oracle/codemp/game/q_math.c:1432
public struct Rng: Hashable, Sendable {
    /// Raven's compile-time seed.
    /// Source: oracle/codemp/game/q_math.c:1432
    public static let initialSeed: UInt32 = 0x89ab_cdef

    /// Raven writes `static unsigned long holdrand`, which is 32 bits on win32 and 64 bits on an LP64 host.
    /// The width is 32 bits, because at 64 bits `holdrand >> 17` spans the whole register and `irand(1,2)` returns values near plus or minus 32000.
    /// jka-rust ruled the same width on 2026-07-17 and records it as quirk Q-3, at jka-rust/docs/audits/quirk-ledger.md:21.
    ///
    /// Source: oracle/codemp/game/q_math.c:1432
    public private(set) var holdrand: UInt32 = Rng.initialSeed

    public init() {}
}

// MARK: - The draws

extension Rng {
    /// Source: oracle/codemp/game/q_math.c:1434
    public mutating func Rand_Init(_ seed: Int32) {
        self.holdrand = UInt32(bitPattern: seed)
    }

    // Returns a float min <= x < max (exclusive; will get max - 0.00001; but never max)

    /// Source: oracle/codemp/game/q_math.c:1441
    public mutating func flrand(_ min: Float, _ max: Float) -> Float {
        var result: Float

        self.holdrand = (self.holdrand &* 214013) &+ 2531011
        result = Float(self.holdrand >> 17)                     // 0 - 32767 range
        result = ((result * (max - min)) / 32768.0) + min

        return result
    }

    /// Source: oracle/codemp/game/q_math.c:1451
    public mutating func Q_flrand(_ min: Float, _ max: Float) -> Float {
        self.flrand(min, max)
    }

    // Returns an integer min <= x <= max (ie inclusive)

    /// Source: oracle/codemp/game/q_math.c:1458
    public mutating func irand(_ min: Int32, _ max: Int32) -> Int32 {
        var result: Int32

        assert((max - min) < 32768)

        let max = max &+ 1
        self.holdrand = (self.holdrand &* 214013) &+ 2531011
        result = Int32(bitPattern: self.holdrand >> 17)
        result = ((result &* (max &- min)) >> 15) &+ min
        return result
    }

    /// Source: oracle/codemp/game/q_math.c:1471
    public mutating func Q_irand(_ value1: Int32, _ value2: Int32) -> Int32 {
        self.irand(value1, value2)
    }
}
