/// Raven's `cplane_t` as a Swift value.
/// The two plane functions of `q_math.c` take this type, because a logic target holds no pointer under rule 11.
/// `Cplane` is the pointer-backed twin over C memory, and the two convert through `plane` and `apply`.
///
/// Source: oracle/codemp/game/q_shared.h:1860
public struct Plane: Hashable {
    /// Source: oracle/codemp/game/q_shared.h:1861
    public var normal: vec3_t

    /// Source: oracle/codemp/game/q_shared.h:1862
    public var dist: Float

    /// for fast side tests: 0,1,2 = axial, 3 = nonaxial
    /// Source: oracle/codemp/game/q_shared.h:1863
    public var type: Int32

    /// signx + (signy<<1) + (signz<<2), used as lookup during collision
    /// Source: oracle/codemp/game/q_shared.h:1864
    public var signbits: Int32

    public init(normal: vec3_t = .zero, dist: Float = 0, type: Int32 = 0, signbits: Int32 = 0) {
        self.normal = normal
        self.dist = dist
        self.type = type
        self.signbits = signbits
    }
}

// MARK: - The view bridge

extension Cplane {
    /// The slot read out as a value, for a call into `q_math`.
    /// Raven's `pad[2]` is not carried, because no Raven code reads it.
    public var plane: Plane {
        Plane(normal: self.normal, dist: self.dist, type: self.type, signbits: self.signbits)
    }

    /// This writes a value back into the slot the view holds.
    /// The write leaves `pad[2]` as the engine left it.
    public func apply(_ plane: Plane) {
        self.normal = plane.normal
        self.dist = plane.dist
        self.type = plane.type
        self.signbits = plane.signbits
    }
}
