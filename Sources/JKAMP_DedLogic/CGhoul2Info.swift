import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// NOTE order in here matters. We save out from mModelindex to mFlags, but not the STL vectors that are at the top or the bottom.
/// Raven's one Ghoul2 model of an instance: its surface, bolt, and bone lists, its handles, and the model pointers the renderer sets.
/// A `CGhoul2Info_v` handle names one array of these in `Ghoul2InfoArray`.
/// Source: oracle/codemp/ghoul2/ghoul2_shared.h:240
public final class CGhoul2Info {
    var mSlist: [surfaceInfo_t] = []
    var mBltlist: [boltInfo_t] = []
    var mBlist: [boneInfo_t] = []
// save from here
    var mModelindex: Int32 = -1
    var mCustomShader: JKAShared.qhandle_t = 0
    var mCustomSkin: JKAShared.qhandle_t = 0
    var mModelBoltLink: Int32 = 0
    var mSurfaceRoot: Int32 = 0
    var mLodBias: Int32 = 0
    var mNewOrigin: Int32 = -1	// this contains the bolt index of the new origin for this model
    var mGoreSetTag: Int32 = 0
    var mModel: JKAShared.qhandle_t = 0		// this and the next entries do NOT go across the network. They are for gameside access ONLY
    var mFileName = CharBuf(MAX_QPATH)
    var mAnimFrameDefault: Int32 = 0
    var mSkelFrameNum: Int32 = -1
    var mMeshFrameNum: Int32 = -1
    var mFlags: Int32 = 0	// used for determining whether to do full collision detection against this object
// to here
    var mTransformedVertsArray: Slots<Int32>? = nil	// used to create an array of pointers to transformed verts per surface for collision detection
    var mBoneCache: CBoneCache? = nil
    var mSkin: Int32 = 0

    // these occasionally are not valid (like after a vid_restart)
    // call the questionably efficient G2_SetupModelPointers(this) to insure validity
    var mValid: Bool = false // all the below are proper and valid
    var currentModel: Model? = nil
    var currentModelSize: Int32 = 0
    var animModel: Model? = nil
    var currentAnimModelSize: Int32 = 0
    var aHeader: MdxaHeader? = nil

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:281
    init() {
        self.mModelindex = -1
        self.mCustomShader = 0
        self.mCustomSkin = 0
        self.mModelBoltLink = 0
        self.mModel = 0
        self.mSurfaceRoot = 0
        self.mAnimFrameDefault = 0
        self.mSkelFrameNum = -1
        self.mMeshFrameNum = -1
        self.mFlags = 0
        self.mTransformedVertsArray = nil
        self.mLodBias = 0
        self.mSkin = 0
        self.mNewOrigin = -1
        self.mGoreSetTag = 0
        self.mBoneCache = nil
        self.currentModel = nil
        self.currentModelSize = 0
        self.animModel = nil
        self.currentAnimModelSize = 0
        self.aHeader = nil
        self.mValid = false
        self.mFileName[0] = 0
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:240
    // AI: Raven copies the class by value with the compiler's `operator=`. The method is `copy`, a memberwise assign in Raven's member order, and each list copies into new objects.
    func copy(_ other: CGhoul2Info) {
        self.mSlist = other.mSlist.map { surface in
            let copy = surfaceInfo_t()
            copy.copy(surface)
            return copy
        }
        self.mBltlist = other.mBltlist.map { bolt in
            let copy = boltInfo_t()
            copy.copy(bolt)
            return copy
        }
        self.mBlist = other.mBlist.map { bone in
            let copy = boneInfo_t()
            copy.copy(bone)
            return copy
        }
        self.mModelindex = other.mModelindex
        self.mCustomShader = other.mCustomShader
        self.mCustomSkin = other.mCustomSkin
        self.mModelBoltLink = other.mModelBoltLink
        self.mSurfaceRoot = other.mSurfaceRoot
        self.mLodBias = other.mLodBias
        self.mNewOrigin = other.mNewOrigin
        self.mGoreSetTag = other.mGoreSetTag
        self.mModel = other.mModel
        self.mFileName = other.mFileName
        self.mAnimFrameDefault = other.mAnimFrameDefault
        self.mSkelFrameNum = other.mSkelFrameNum
        self.mMeshFrameNum = other.mMeshFrameNum
        self.mFlags = other.mFlags
        self.mTransformedVertsArray = other.mTransformedVertsArray
        self.mBoneCache = other.mBoneCache
        self.mSkin = other.mSkin

        self.mValid = other.mValid
        self.currentModel = other.currentModel
        self.currentModelSize = other.currentModelSize
        self.animModel = other.animModel
        self.currentAnimModelSize = other.currentAnimModelSize
        self.aHeader = other.aHeader
    }
}
