internal import CJKAMP
import JKAShared

// MARK: - Orientation pointer

extension Vehicle {
    /// Raven's `m_vOrientation = &ps->vehOrientation[0]`, which points the vehicle's orientation at the vector of a player state.
    /// The address stays in this target under rule 11, and every `m_vOrientationVector` read before this call traps.
    public func pointOrientation(at ps: PlayerState) {
        let base = UnsafeMutableRawPointer(ps.raw) + MemoryLayout<playerState_t>.offset(of: \.vehOrientation)!
        self.raw.pointee.m_vOrientation = base.assumingMemoryBound(to: Float.self)
    }
}
