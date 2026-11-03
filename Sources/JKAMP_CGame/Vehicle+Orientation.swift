@preconcurrency internal import CJKAMP_CGame
import JKAMP
import JKAShared

// MARK: - Orientation pointer

extension Vehicle {
    /// Raven's `m_vOrientation = &cent->lerpAngles[0]`, which points the vehicle's orientation at the lerp angles of a centity.
    /// The centity view lives in this target, so this overload stands beside the player state one of `JKAMP`.
    public func pointOrientation(at cent: Centity) {
        let base = UnsafeMutableRawPointer(cent.raw) + MemoryLayout<centity_t>.offset(of: \.lerpAngles)!
        self.m_vOrientation = OpaquePointer(base)
    }
}
