import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// we save the whole structure here.
/// Raven's bone override of one Ghoul2 model, an angle override, an animation, or a ragdoll bone.
/// `CGhoul2Info.mBlist` holds one per overridden bone.
/// Source: oracle/codemp/ghoul2/ghoul2_shared.h:63
public final class boneInfo_t {
    // AI: Raven holds eight `mdxaBone_t` records by value. The instance owns one allocation of the eight, and each record field is the view of one slot.
    // A store is `copy(from:)`, Raven's `=`. Raven leaves seven of the records unset, and the allocation zeroes them.
    private let mdxaBones: Slots<MdxaBone> = {
        let mdxaBones = Slots<MdxaBone>.new(count: 8)
        mdxaBones.zero(count: 8)
        return mdxaBones
    }()

    var boneNumber: Int32 = -1		// what bone are we overriding?
    var matrix: MdxaBone { self.mdxaBones[0] }			// details of bone angle overrides - some are pre-done on the server, some in ghoul2
    var flags: Int32 = 0			// flags for override
    var startFrame: Int32 = 0		// start frame for animation
    var endFrame: Int32 = 0		// end frame for animation NOTE anim actually ends on endFrame+1
    var startTime: Int32 = 0		// time we started this animation
    var pauseTime: Int32 = 0		// time we paused this animation - 0 if not paused
    var animSpeed: Float = 0		// speed at which this anim runs. 1.0f means full speed of animation incoming - ie if anim is 20hrtz, we run at 20hrts. If 5hrts, we run at 5 hrts
    var blendFrame: Float = 0		// frame PLUS LERP value to blend from
    var blendLerpFrame: Int32 = 0	// frame to lerp the blend frame with.
    var blendTime: Int32 = 0		// Duration time for blending - used to calc amount each frame of new anim is blended with last frame of the last anim
    var blendStart: Int32 = 0		// Time when blending starts - not necessarily the same as startTime since we might start half way through an anim
    var boneBlendTime: Int32 = 0	// time for duration of bone angle blend with normal animation
    var boneBlendStart: Int32 = 0	// time bone angle blend with normal animation began
    var lastTime: Int32 = 0		// this does not go across the network
    var newMatrix: MdxaBone { self.mdxaBones[1] }		// This is the lerped matrix that Ghoul2 uses on the client side - does not go across the network

    //rww - RAGDOLL_BEGIN
    var lastTimeUpdated: Int32 = 0  // if non-zero this is all intialized
    var lastContents: Int32 = 0
    var lastPosition = JKAShared.vec3_t()
    var velocityEffector = JKAShared.vec3_t()
    var lastAngles = JKAShared.vec3_t()
    var minAngles = JKAShared.vec3_t()
    var maxAngles = JKAShared.vec3_t()
    var currentAngles = JKAShared.vec3_t()
    var anglesOffset = JKAShared.vec3_t()
    var positionOffset = JKAShared.vec3_t()
    var radius: Float = 0
    var weight: Float = 0   // current radius cubed
    var ragIndex: Int32 = 0
    var velocityRoot = JKAShared.vec3_t()		// I am really tired of recomiling the whole game to add a param here
    var ragStartTime: Int32 = 0
    var firstTime: Int32 = 0
    var firstCollisionTime: Int32 = 0
    var restTime: Int32 = 0
    var RagFlags: Int32 = 0
    var DependentRagIndexMask: Int32 = 0
    var originalTrueBoneMatrix: MdxaBone { self.mdxaBones[2] }
    var parentTrueBoneMatrix: MdxaBone { self.mdxaBones[3] }			// figure I will need this sooner or later
    var parentOriginalTrueBoneMatrix: MdxaBone { self.mdxaBones[4] }	// figure I will need this sooner or later
    var originalOrigin = JKAShared.vec3_t()
    var originalAngles = JKAShared.vec3_t()
    var lastShotDir = JKAShared.vec3_t()
    var basepose: MdxaBone? = nil
    var baseposeInv: MdxaBone? = nil
    var baseposeParent: MdxaBone? = nil
    var baseposeInvParent: MdxaBone? = nil
    var parentRawBoneIndex: Int32 = 0
    var ragOverrideMatrix: MdxaBone { self.mdxaBones[5] }	// figure I will need this sooner or later

    var extraMatrix: MdxaBone { self.mdxaBones[6] }	// figure I will need this sooner or later
    var extraVec1 = JKAShared.vec3_t()		// I am really tired of recomiling the whole game to add a param here
    var extraFloat1: Float = 0
    var extraInt1: Int32 = 0

    var ikPosition = JKAShared.vec3_t()
    var ikSpeed: Float = 0

    var epVelocity = JKAShared.vec3_t() //velocity factor, can be set, and is also maintained by physics based on gravity, mass, etc.
    var epGravFactor: Float = 0 //gravity factor maintained by bone physics
    var solidCount: Int32 = 0 //incremented every time we try to move and are in solid - if we get out of solid, it is reset to 0
    var physicsSettled: Bool = false //true when the bone is on ground and finished bouncing, etc. but may still be pushed into solid by other bones
    var snapped: Bool = false //the bone is broken out of standard constraints

    var parentBoneIndex: Int32 = 0

    var offsetRotation: Float = 0

    //user api overrides
    var overGradSpeed: Float = 0

    var overGoalSpot = JKAShared.vec3_t()
    var hasOverGoal: Bool = false

    var animFrameMatrix: MdxaBone { self.mdxaBones[7] } //matrix for the bone in the desired settling pose -rww
    var hasAnimFrameMatrix: Int32 = 0

    var airTime: Int32 = 0 //base is in air, be more quick and sensitive about collisions
    //rww - RAGDOLL_END

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:146
    init() {
        // AI: Raven sets the 12 floats of `matrix` to 0 in one chain. The call clears the record, which holds the 12 floats alone.
        self.matrix.clear()
    }

    /// Source: oracle/codemp/ghoul2/ghoul2_shared.h:63
    // AI: Raven copies the struct by value with the compiler's `operator=`. The method is `copy`, a memberwise assign in Raven's member order.
    func copy(_ other: boneInfo_t) {
        self.boneNumber = other.boneNumber
        self.matrix.copy(from: other.matrix)
        self.flags = other.flags
        self.startFrame = other.startFrame
        self.endFrame = other.endFrame
        self.startTime = other.startTime
        self.pauseTime = other.pauseTime
        self.animSpeed = other.animSpeed
        self.blendFrame = other.blendFrame
        self.blendLerpFrame = other.blendLerpFrame
        self.blendTime = other.blendTime
        self.blendStart = other.blendStart
        self.boneBlendTime = other.boneBlendTime
        self.boneBlendStart = other.boneBlendStart
        self.lastTime = other.lastTime
        self.newMatrix.copy(from: other.newMatrix)

        self.lastTimeUpdated = other.lastTimeUpdated
        self.lastContents = other.lastContents
        self.lastPosition = other.lastPosition
        self.velocityEffector = other.velocityEffector
        self.lastAngles = other.lastAngles
        self.minAngles = other.minAngles
        self.maxAngles = other.maxAngles
        self.currentAngles = other.currentAngles
        self.anglesOffset = other.anglesOffset
        self.positionOffset = other.positionOffset
        self.radius = other.radius
        self.weight = other.weight
        self.ragIndex = other.ragIndex
        self.velocityRoot = other.velocityRoot
        self.ragStartTime = other.ragStartTime
        self.firstTime = other.firstTime
        self.firstCollisionTime = other.firstCollisionTime
        self.restTime = other.restTime
        self.RagFlags = other.RagFlags
        self.DependentRagIndexMask = other.DependentRagIndexMask
        self.originalTrueBoneMatrix.copy(from: other.originalTrueBoneMatrix)
        self.parentTrueBoneMatrix.copy(from: other.parentTrueBoneMatrix)
        self.parentOriginalTrueBoneMatrix.copy(from: other.parentOriginalTrueBoneMatrix)
        self.originalOrigin = other.originalOrigin
        self.originalAngles = other.originalAngles
        self.lastShotDir = other.lastShotDir
        self.basepose = other.basepose
        self.baseposeInv = other.baseposeInv
        self.baseposeParent = other.baseposeParent
        self.baseposeInvParent = other.baseposeInvParent
        self.parentRawBoneIndex = other.parentRawBoneIndex
        self.ragOverrideMatrix.copy(from: other.ragOverrideMatrix)

        self.extraMatrix.copy(from: other.extraMatrix)
        self.extraVec1 = other.extraVec1
        self.extraFloat1 = other.extraFloat1
        self.extraInt1 = other.extraInt1

        self.ikPosition = other.ikPosition
        self.ikSpeed = other.ikSpeed

        self.epVelocity = other.epVelocity
        self.epGravFactor = other.epGravFactor
        self.solidCount = other.solidCount
        self.physicsSettled = other.physicsSettled
        self.snapped = other.snapped

        self.parentBoneIndex = other.parentBoneIndex

        self.offsetRotation = other.offsetRotation

        self.overGradSpeed = other.overGradSpeed

        self.overGoalSpot = other.overGoalSpot
        self.hasOverGoal = other.hasOverGoal

        self.animFrameMatrix.copy(from: other.animFrameMatrix)
        self.hasAnimFrameMatrix = other.hasAnimFrameMatrix

        self.airTime = other.airTime
    }

    deinit {
        self.mdxaBones.delete()
    }
}
