import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's final matrix of one bone in a bone cache, with the touch counts that mark it current.
/// `CBoneCache.mFinalBones` and `CBoneCache.mSmoothBones` hold one per bone.
/// Source: oracle/codemp/renderer/tr_ghoul2.cpp:166
final class CTransformBone {
    var touch: Int32 = 0 // for minimal recalculation
    //rww - RAGDOLL_BEGIN
    var touchRender: Int32 = 0
    //rww - RAGDOLL_END
    var boneMatrix: MdxaBone //final matrix
    var parent: Int32 = 0 // only set once

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:182
    // AI: Raven holds `boneMatrix` by value. The field is the `MdxaBone` view over a slot the instance owns, so the constructor sets the slot.
    init() {
        // TODO: Port CTransformBone::CTransformBone
        portMissing("CTransformBone::CTransformBone", source: "oracle/codemp/renderer/tr_ghoul2.cpp:182")
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
    var rootMatrix: MdxaBone
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
        // Raven's body and both calls stand under `#ifdef _XBOX`, the calls at tr_ghoul2.cpp:261 and :339, so the method is dead in the dedicated build.
        // TODO: Port CBoneCache::SetRenderMatrix
        portMissing("CBoneCache::SetRenderMatrix", source: "oracle/codemp/renderer/tr_ghoul2.cpp:208")
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
        // Port-note: Raven casts a record at a byte offset of `header`, and the view target has no accessor for a view at a byte offset.
        // TODO: Port CBoneCache::SmoothLow
        portMissing("CBoneCache::SmoothLow", source: "oracle/codemp/renderer/tr_ghoul2.cpp:267")
    }
//rww - RAGDOLL_END

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:390
    init(_ amod: Model?, _ aheader: MdxaHeader?) {
        // Port-note: Raven casts a record at a byte offset of `header`, and the view target has no accessor for a view at a byte offset.
        // TODO: Port CBoneCache::CBoneCache
        portMissing("CBoneCache::CBoneCache", source: "oracle/codemp/renderer/tr_ghoul2.cpp:390")
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:441
    func Root() -> SBoneCalc {
        return self.mBones[0]
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:446
    func EvalUnsmooth(_ index: Int32) -> MdxaBone {
        self.EvalLow(index)
        if self.mSmoothingActive && self.mSmoothBones[index].touch != 0 {
            return self.mSmoothBones[index].boneMatrix
        }
        return self.mFinalBones[index].boneMatrix
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:455
    func Eval(_ index: Int32) -> MdxaBone {
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
    func EvalRender(_ index: Int32) -> MdxaBone {
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
    func WasRendered(_ index: Int32) -> Bool {
        return self.mFinalBones[index].touchRender == self.mCurrentTouchRender
    }

    /// Source: oracle/codemp/renderer/tr_ghoul2.cpp:545
    func GetParent(_ index: Int32) -> Int32 {
        if index == 0 {
            return -1
        }
        return self.mFinalBones[index].parent
    }
    //rww - RAGDOLL_END
}
