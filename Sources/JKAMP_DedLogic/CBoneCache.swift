import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's final matrix of one bone in a bone cache, with the touch counts that mark it current.
/// `CBoneCache.mFinalBones` and `CBoneCache.mSmoothBones` hold one per bone.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:166
final class CTransformBone {
    // AI: Raven holds `boneMatrix` by value. The instance owns one allocation of the record, and the field is the view of the slot.
    // A store is `copy(from:)`, Raven's `=`. Raven leaves the record unset, and the allocation zeroes it.
    private let mdxaBones: Slots<MdxaBone> = {
        let mdxaBones = Slots<MdxaBone>.new(count: 1)
        mdxaBones.zero(count: 1)
        return mdxaBones
    }()

    var touch: Int32 = 0 // for minimal recalculation
    //rww - RAGDOLL_BEGIN
    var touchRender: Int32 = 0
    //rww - RAGDOLL_END
    var boneMatrix: MdxaBone { self.mdxaBones[0] } //final matrix
    var parent: Int32 = 0 // only set once

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:182
    init() {
        self.touch = 0
        //rww - RAGDOLL_BEGIN
        self.touchRender = 0
        //rww - RAGDOLL_END
    }

    deinit {
        self.mdxaBones.delete()
    }
}

/// Raven's animation frame state of one bone in a bone cache, the frames and the lerp and blend values.
/// `CBoneCache.mBones` holds one per bone.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:192
// AI: Raven declares a plain struct, and the bodies bind `SBoneCalc &` to an element and write through it. The record is a final class.
final class SBoneCalc {
    var newFrame: Int32 = 0
    var currentFrame: Int32 = 0
    var backlerp: Float = 0
    var blendFrame: Float = 0
    var blendOldFrame: Int32 = 0
    var blendMode: Bool = false
    var blendLerp: Float = 0
}

/// Raven's bone cache of one Ghoul2 model, the frame state and the final and smoothed matrices of every bone.
/// `CGhoul2Info.mBoneCache` holds one, and `G2_TransformGhoulBones` fills it each frame.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:206
final class CBoneCache {
    var frameSize: Int32 = 0
    var header: MdxaHeader? = nil
    var mod: Model? = nil

    // these are split for better cpu cache behavior
    var mBones: [SBoneCalc] = []
    var mFinalBones: [CTransformBone] = []

    var mSmoothBones: [CTransformBone] = [] // for render smoothing
    //vector<mdxaSkel_t *>   mSkels;

    // AI: Raven points at the caller's `boneInfo_v`. The field holds the array, and its elements are the caller's bone objects.
    var rootBoneList: [boneInfo_t]? = nil
    // AI: Raven holds `rootMatrix` by value. The instance owns one zeroed allocation of the record, and the field is the view of the slot.
    // A store is `copy(from:)`, Raven's `=`, and the deinit frees the allocation.
    private let mdxaBones: Slots<MdxaBone> = {
        let mdxaBones = Slots<MdxaBone>.new(count: 1)
        mdxaBones.zero(count: 1)
        return mdxaBones
    }()
    var rootMatrix: MdxaBone { self.mdxaBones[0] }
    var incomingTime: Int32 = 0

    var mCurrentTouch: Int32 = 0
    //rww - RAGDOLL_BEGIN
    var mCurrentTouchRender: Int32 = 0
    var mLastTouch: Int32 = 0
    var mLastLastTouch: Int32 = 0
    //rww - RAGDOLL_END

    // for render smoothing
    var mSmoothingActive: Bool = false
    var mUnsquash: Bool = false
    var mSmoothFactor: Float = 0

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:208
    private func SetRenderMatrix(_ bone: CTransformBone?) {
        // TODO: Port CBoneCache::SetRenderMatrix
        portMissing("CBoneCache::SetRenderMatrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:208")
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:236
    private func EvalLow(_ index: Int32) {
        // TODO: Port CBoneCache::EvalLow
        portMissing("CBoneCache::EvalLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:236")
    }

//rww - RAGDOLL_BEGIN
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:267
    private func SmoothLow(_ index: Int32) {
        // TODO: Port CBoneCache::SmoothLow
        portMissing("CBoneCache::SmoothLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:267")
    }
//rww - RAGDOLL_END

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:390
    init(_ amod: Model?, _ aheader: MdxaHeader?) {
        // TODO: Port CBoneCache::CBoneCache
        portMissing("CBoneCache::CBoneCache", source: "oracle/codemp/renderer/tr_ghoul2.cpp:390")
    }

    deinit {
        self.mdxaBones.delete()
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:441
    func Root() -> SBoneCalc {
        // TODO: Port CBoneCache::Root
        portMissing("CBoneCache::Root", source: "oracle/codemp/renderer/tr_ghoul2.cpp:441")
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:446
    func EvalUnsmooth(_ index: Int32) -> MdxaBone {
        // TODO: Port CBoneCache::EvalUnsmooth
        portMissing("CBoneCache::EvalUnsmooth", source: "oracle/codemp/renderer/tr_ghoul2.cpp:446")
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:455
    func Eval(_ index: Int32) -> MdxaBone {
        // TODO: Port CBoneCache::Eval
        portMissing("CBoneCache::Eval", source: "oracle/codemp/renderer/tr_ghoul2.cpp:455")
    }

    //rww - RAGDOLL_BEGIN
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:520
    func EvalRender(_ index: Int32) -> MdxaBone {
        // TODO: Port CBoneCache::EvalRender
        portMissing("CBoneCache::EvalRender", source: "oracle/codemp/renderer/tr_ghoul2.cpp:520")
    }
    //rww - RAGDOLL_END
    //rww - RAGDOLL_BEGIN
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:540
    func WasRendered(_ index: Int32) -> Bool {
        // TODO: Port CBoneCache::WasRendered
        portMissing("CBoneCache::WasRendered", source: "oracle/codemp/renderer/tr_ghoul2.cpp:540")
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:545
    func GetParent(_ index: Int32) -> Int32 {
        // TODO: Port CBoneCache::GetParent
        portMissing("CBoneCache::GetParent", source: "oracle/codemp/renderer/tr_ghoul2.cpp:545")
    }
    //rww - RAGDOLL_END
}
