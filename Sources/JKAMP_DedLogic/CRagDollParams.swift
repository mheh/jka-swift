import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's parameters of one ragdoll phase change, the entity's pose, the phase, and the effectors to turn off.
/// `G2_SetRagDoll` reads it and writes the pelvis offsets and `CallRagDollBegin` back.
/// Source: oracle/codemp/ghoul2/G2_gore.h:131
// AI: Raven nests the enums ERagPhase and ERagEffector in the class.
// Each is an Int32 alias with static cases, so a body reads `CRagDollParams.RP_DEATH_COLLISION`.
public final class CRagDollParams {
    public typealias ERagPhase = Int32
    public static let RP_START_DEATH_ANIM: ERagPhase = 0
    public static let RP_END_DEATH_ANIM: ERagPhase = 1
    public static let RP_DEATH_COLLISION: ERagPhase = 2
    public static let RP_CORPSE_SHOT: ERagPhase = 3
    public static let RP_GET_PELVIS_OFFSET: ERagPhase = 4  // this actually does nothing but set the pelvisAnglesOffset, and pelvisPositionOffset
    public static let RP_SET_PELVIS_OFFSET: ERagPhase = 5  // this actually does nothing but set the pelvisAnglesOffset, and pelvisPositionOffset
    public static let RP_DISABLE_EFFECTORS: ERagPhase = 6  // this removes effectors given by the effectorsToTurnOff member

    public var angles = JKAShared.vec3_t()
    public var position = JKAShared.vec3_t()
    public var scale = JKAShared.vec3_t()
    public var pelvisAnglesOffset = JKAShared.vec3_t()    // always set on return, an argument for RP_SET_PELVIS_OFFSET
    public var pelvisPositionOffset = JKAShared.vec3_t() // always set on return, an argument for RP_SET_PELVIS_OFFSET

    public var fImpactStrength: Float = 0 //should be applicable when RagPhase is RP_DEATH_COLLISION
    public var fShotStrength: Float = 0 //should be applicable for setting velocity of corpse on shot (probably only on RP_CORPSE_SHOT)
    //CServerEntity *me;
    public var me: Int32 = 0

    //rww - we have convenient animation/frame access in the game, so just send this info over from there.
    public var startFrame: Int32 = 0
    public var endFrame: Int32 = 0

    public var collisionType: Int32 = 0 // 1 = from a fall, 0 from effectors, this will be going away soon, hence no enum

    public var CallRagDollBegin: Bool = false // a return value, means that we are now begininng ragdoll and the NPC stuff needs to happen

    public var RagPhase: ERagPhase = 0

// effector control, used for RP_DISABLE_EFFECTORS call

    public typealias ERagEffector = Int32
    public static let RE_MODEL_ROOT: ERagEffector = 0x00000001 //"model_root"
    public static let RE_PELVIS: ERagEffector = 0x00000002 //"pelvis"
    public static let RE_LOWER_LUMBAR: ERagEffector = 0x00000004 //"lower_lumbar"
    public static let RE_UPPER_LUMBAR: ERagEffector = 0x00000008 //"upper_lumbar"
    public static let RE_THORACIC: ERagEffector = 0x00000010 //"thoracic"
    public static let RE_CRANIUM: ERagEffector = 0x00000020 //"cranium"
    public static let RE_RHUMEROUS: ERagEffector = 0x00000040 //"rhumerus"
    public static let RE_LHUMEROUS: ERagEffector = 0x00000080 //"lhumerus"
    public static let RE_RRADIUS: ERagEffector = 0x00000100 //"rradius"
    public static let RE_LRADIUS: ERagEffector = 0x00000200 //"lradius"
    public static let RE_RFEMURYZ: ERagEffector = 0x00000400 //"rfemurYZ"
    public static let RE_LFEMURYZ: ERagEffector = 0x00000800 //"lfemurYZ"
    public static let RE_RTIBIA: ERagEffector = 0x00001000 //"rtibia"
    public static let RE_LTIBIA: ERagEffector = 0x00002000 //"ltibia"
    public static let RE_RHAND: ERagEffector = 0x00004000 //"rhand"
    public static let RE_LHAND: ERagEffector = 0x00008000 //"lhand"
    public static let RE_RTARSAL: ERagEffector = 0x00010000 //"rtarsal"
    public static let RE_LTARSAL: ERagEffector = 0x00020000 //"ltarsal"
    public static let RE_RTALUS: ERagEffector = 0x00040000 //"rtalus"
    public static let RE_LTALUS: ERagEffector = 0x00080000 //"ltalus"
    public static let RE_RRADIUSX: ERagEffector = 0x00100000 //"rradiusX"
    public static let RE_LRADIUSX: ERagEffector = 0x00200000 //"lradiusX"
    public static let RE_RFEMURX: ERagEffector = 0x00400000 //"rfemurX"
    public static let RE_LFEMURX: ERagEffector = 0x00800000 //"lfemurX"
    public static let RE_CEYEBROW: ERagEffector = 0x01000000 //"ceyebrow"

    public var effectorsToTurnOff: ERagEffector = 0  // set this to an | of the above flags for a RP_DISABLE_EFFECTORS
}
