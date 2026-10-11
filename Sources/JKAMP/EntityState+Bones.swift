internal import CJKAMP
import JKAShared

// MARK: - Bone fields by slot

extension EntityState {
    /// Raven's `boneIndex1` to `boneIndex4` as one array, slot 0 for `boneIndex1`.
    /// The four `int` fields are adjacent in `entityState_t`, so a pointer local over them is a slot index.
    public var boneIndexSlots: Slots<Int32> {
        let base = UnsafeMutableRawPointer(self.raw) + MemoryLayout<entityState_t>.offset(of: \.boneIndex1)!
        return Slots(scalars: base, count: 4)
    }

    /// Raven's `boneAngles1` to `boneAngles4` as one array, slot 0 for `boneAngles1`.
    public var boneAnglesSlots: Slots<JKAShared.vec3_t> {
        let base = UnsafeMutableRawPointer(self.raw) + MemoryLayout<entityState_t>.offset(of: \.boneAngles1)!
        return Slots(vectors: base, count: 4)
    }
}
