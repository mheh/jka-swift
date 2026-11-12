import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's final matrix of one bone in a bone cache, with the touch counts that mark it current.
/// `CBoneCache.mFinalBones` and `CBoneCache.mSmoothBones` hold one per bone.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:166
public final class CTransformBone {
    // AI: Raven holds `boneMatrix` by value. The instance owns one allocation of the record, and the field is the view of the slot.
    // A store is `copy(from:)`, Raven's `=`. Raven leaves the record unset, and the allocation zeroes it.
    private let mdxaBones: Slots<MdxaBone> = {
        let mdxaBones = Slots<MdxaBone>.new(count: 1)
        mdxaBones.zero(count: 1)
        return mdxaBones
    }()

    public var touch: Int32 = 0 // for minimal recalculation
    //rww - RAGDOLL_BEGIN
    public var touchRender: Int32 = 0
    //rww - RAGDOLL_END
    public var boneMatrix: MdxaBone { self.mdxaBones[0] } //final matrix
    public var parent: Int32 = 0 // only set once

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:182
    public init() {
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
public final class SBoneCalc {
    public var newFrame: Int32 = 0
    public var currentFrame: Int32 = 0
    public var backlerp: Float = 0
    public var blendFrame: Float = 0
    public var blendOldFrame: Int32 = 0
    public var blendMode: Bool = false
    public var blendLerp: Float = 0
}

/// Raven's bone cache of one Ghoul2 model, the frame state and the final and smoothed matrices of every bone.
/// `CGhoul2Info.mBoneCache` holds one, and `G2_TransformGhoulBones` fills it each frame.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:206
public final class CBoneCache {
    public var frameSize: Int32 = 0
    public var header: MdxaHeader? = nil
    public var mod: Model? = nil

    // these are split for better cpu cache behavior
    public var mBones: [SBoneCalc] = []
    public var mFinalBones: [CTransformBone] = []

    public var mSmoothBones: [CTransformBone] = [] // for render smoothing
    //vector<mdxaSkel_t *>   mSkels;

    // AI: Raven points at the caller's `boneInfo_v`. The field holds the model that owns the list, and `rootBoneList` reads and writes its `mBlist`.
    weak var rootBoneListOwner: CGhoul2Info? = nil
    public var rootBoneList: [boneInfo_t] {
        get { self.rootBoneListOwner!.mBlist }
        set { self.rootBoneListOwner!.mBlist = newValue }
    }
    // AI: Raven holds `rootMatrix` by value. The instance owns one zeroed allocation of the record, and the field is the view of the slot.
    // A store is `copy(from:)`, Raven's `=`, and the deinit frees the allocation.
    private let mdxaBones: Slots<MdxaBone> = {
        let mdxaBones = Slots<MdxaBone>.new(count: 1)
        mdxaBones.zero(count: 1)
        return mdxaBones
    }()
    public var rootMatrix: MdxaBone { self.mdxaBones[0] }
    public var incomingTime: Int32 = 0

    public var mCurrentTouch: Int32 = 0
    //rww - RAGDOLL_BEGIN
    public var mCurrentTouchRender: Int32 = 0
    public var mLastTouch: Int32 = 0
    public var mLastLastTouch: Int32 = 0
    //rww - RAGDOLL_END

    // for render smoothing
    public var mSmoothingActive: Bool = false
    public var mUnsquash: Bool = false
    public var mSmoothFactor: Float = 0

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:208
    private func SetRenderMatrix(_ bone: CTransformBone?) {
        // Raven's body and both calls stand under `#ifdef _XBOX`, the calls at tr_ghoul2.cpp:261 and :339, so the method is dead in the dedicated build.
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:236
    private func EvalLow(_ index: Int32) {
        if self.mFinalBones[index].touch != self.mCurrentTouch {
            // need to evaluate the bone
            if self.mFinalBones[index].parent >= 0 {
                self.EvalLow(self.mFinalBones[index].parent) // make sure parent is evaluated
                let par = self.mBones[self.mFinalBones[index].parent]
                self.mBones[index].newFrame = par.newFrame
                self.mBones[index].currentFrame = par.currentFrame
                self.mBones[index].backlerp = par.backlerp
                self.mBones[index].blendFrame = par.blendFrame
                self.mBones[index].blendOldFrame = par.blendOldFrame
                self.mBones[index].blendMode = par.blendMode
                self.mBones[index].blendLerp = par.blendLerp
            }
            G2_TransformBone(index, self)
            self.mFinalBones[index].touch = self.mCurrentTouch
        }
    }

//rww - RAGDOLL_BEGIN
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:267
    private func SmoothLow(_ index: Int32) {
        // Raven calls this method only from EvalRender, and each call of EvalRender stands under the undefined G2EVALRENDER, `#if 0`, `_XBOX`, or `#ifndef DEDICATED`.
        // The calls stand at tr_ghoul2.cpp:3033, :3063, :3093, :3184, :4272, :4287, and :559, and in RB_SurfaceGhoul at :4314 to :4368, so the method is dead in the dedicated build.
        if self.mSmoothBones[index].touch == self.mLastTouch {
            var i: Int32
            let oldM = self.mSmoothBones[index].boneMatrix.matrix
            let newM = self.mFinalBones[index].boneMatrix.matrix
            i = 0
            while i < 12 {
                oldM[i / 4][i % 4] = self.mSmoothFactor * (oldM[i / 4][i % 4] - newM[i / 4][i % 4]) + newM[i / 4][i % 4]
                i += 1
            }
        } else {
            self.mSmoothBones[index].boneMatrix.copy(from: self.mFinalBones[index].boneMatrix)
        }
        let offsets = MdxaSkelOffsets(self.header!, byteOffset: MdxaHeader.byteCount)
        let skel = MdxaSkel(self.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[index])
        MdxaBone.scratch { tempMatrix in
            Multiply_3x4Matrix(tempMatrix, self.mSmoothBones[index].boneMatrix, skel.BasePoseMat)
            var maxl: Float
            maxl = VectorLength(skel.BasePoseMat.matrix[0].vector)
            _ = VectorNormalize(&tempMatrix.matrix[0].vector)
            _ = VectorNormalize(&tempMatrix.matrix[1].vector)
            _ = VectorNormalize(&tempMatrix.matrix[2].vector)

            tempMatrix.matrix[0].vector = tempMatrix.matrix[0].vector * maxl
            tempMatrix.matrix[1].vector = tempMatrix.matrix[1].vector * maxl
            tempMatrix.matrix[2].vector = tempMatrix.matrix[2].vector * maxl
            Multiply_3x4Matrix(self.mSmoothBones[index].boneMatrix, tempMatrix, skel.BasePoseMatInv)
        }
        self.mSmoothBones[index].touch = self.mCurrentTouch
    }
//rww - RAGDOLL_END

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:390
    public init(_ amod: Model?, _ aheader: MdxaHeader?) {
        self.mod = amod
        self.header = aheader
        assert(amod != nil)
        assert(aheader != nil)
        self.mSmoothingActive = false
        self.mUnsquash = false
        self.mSmoothFactor = 0.0

        let numBones = self.header!.numBones
        // Raven's `resize` constructs each new element.
        while self.mBones.count < numBones {
            self.mBones.append(SBoneCalc())
        }
        while self.mFinalBones.count < numBones {
            self.mFinalBones.append(CTransformBone())
        }
        while self.mSmoothBones.count < numBones {
            self.mSmoothBones.append(CTransformBone())
        }
//		mSkels.resize(numBones);
        //rww - removed mSkels
        let offsets: MdxaSkelOffsets
        var skel: MdxaSkel
        offsets = MdxaSkelOffsets(self.header!, byteOffset: MdxaHeader.byteCount)

        var i: Int32
        i = 0
        while i < numBones {
            skel = MdxaSkel(self.header!, byteOffset: Int32(MdxaHeader.byteCount) + offsets.offsets[i])
            //mSkels[i]=skel;
            //ditto
            self.mFinalBones[i].parent = skel.parent
            i += 1
        }
        self.mCurrentTouch = 3
//rww - RAGDOLL_BEGIN
        self.mLastTouch = 2
        self.mLastLastTouch = 1
//rww - RAGDOLL_END
    }

    deinit {
        self.mdxaBones.delete()
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:441
    public func Root() -> SBoneCalc {
        return self.mBones[0]
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:446
    public func EvalUnsmooth(_ index: Int32) -> MdxaBone {
        self.EvalLow(index)
        if self.mSmoothingActive && self.mSmoothBones[index].touch != 0 {
            return self.mSmoothBones[index].boneMatrix
        }
        return self.mFinalBones[index].boneMatrix
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:455
    public func Eval(_ index: Int32) -> MdxaBone {
        /*
        bool wasEval=EvalLow(index);
        if (mSmoothingActive)
        {
            if (mSmoothBones[index].touch!=incomingTime||wasEval)
            {
                float dif=float(incomingTime)-float(mSmoothBones[index].touch);
                if (mSmoothBones[index].touch&&dif<300.0f)
                {

                    if (dif<16.0f)  // 60 fps
                    {
                        dif=16.0f;
                    }
                    if (dif>100.0f) // 10 fps
                    {
                        dif=100.0f;
                    }
                    float f=1.0f-pow(1.0f-mSmoothFactor,16.0f/dif);

                    int i;
                    float *oldM=&mSmoothBones[index].boneMatrix.matrix[0][0];
                    float *newM=&mFinalBones[index].boneMatrix.matrix[0][0];
                    for (i=0;i<12;i++,oldM++,newM++)
                    {
                        *oldM=f*(*oldM-*newM)+*newM;
                    }
                    if (mUnsquash)
                    {
                        mdxaBone_t tempMatrix;
                        Multiply_3x4Matrix(&tempMatrix,&mSmoothBones[index].boneMatrix, &mSkels[index]->BasePoseMat);
                        float maxl;
                        maxl=VectorLength(&mSkels[index]->BasePoseMat.matrix[0][0]);
                        VectorNormalize(&tempMatrix.matrix[0][0]);
                        VectorNormalize(&tempMatrix.matrix[1][0]);
                        VectorNormalize(&tempMatrix.matrix[2][0]);

                        VectorScale(&tempMatrix.matrix[0][0],maxl,&tempMatrix.matrix[0][0]);
                        VectorScale(&tempMatrix.matrix[1][0],maxl,&tempMatrix.matrix[1][0]);
                        VectorScale(&tempMatrix.matrix[2][0],maxl,&tempMatrix.matrix[2][0]);
                        Multiply_3x4Matrix(&mSmoothBones[index].boneMatrix,&tempMatrix,&mSkels[index]->BasePoseMatInv);
                    }
                }
                else
                {
                    memcpy(&mSmoothBones[index].boneMatrix,&mFinalBones[index].boneMatrix,sizeof(mdxaBone_t));
                }
                mSmoothBones[index].touch=incomingTime;
            }
            return mSmoothBones[index].boneMatrix;
        }
        return mFinalBones[index].boneMatrix;
        */

        //Hey, this is what sof2 does. Let's try it out.
        if self.mFinalBones[index].touch != self.mCurrentTouch {
            self.EvalLow(index)
        }
        return self.mFinalBones[index].boneMatrix
    }

    //rww - RAGDOLL_BEGIN
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:520
    public func EvalRender(_ index: Int32) -> MdxaBone {
        if self.mFinalBones[index].touch != self.mCurrentTouch {
            self.mFinalBones[index].touchRender = self.mCurrentTouchRender
            self.EvalLow(index)
        }
        if self.mSmoothingActive {
            if self.mSmoothBones[index].touch != self.mCurrentTouch {
                self.SmoothLow(index)
            }
            return self.mSmoothBones[index].boneMatrix
        }
        return self.mFinalBones[index].boneMatrix
    }
    //rww - RAGDOLL_END
    //rww - RAGDOLL_BEGIN
    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:540
    public func WasRendered(_ index: Int32) -> Bool {
        return self.mFinalBones[index].touchRender == self.mCurrentTouchRender
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:545
    public func GetParent(_ index: Int32) -> Int32 {
        if index == 0 {
            return -1
        }
        return self.mFinalBones[index].parent
    }
    //rww - RAGDOLL_END
}
