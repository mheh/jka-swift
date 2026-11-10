import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's parameters of one ragdoll phase change, the entity's pose, the phase, and the effectors to turn off.
/// `G2_SetRagDoll` reads it and writes the pelvis offsets and `CallRagDollBegin` back.
/// Source: oracle/codemp/ghoul2/G2_gore.h:131
// AI: Raven nests the enums ERagPhase and ERagEffector in the class.
// Each is an Int32 alias with static cases, so a body reads `CRagDollParams.RP_DEATH_COLLISION`.
final class CRagDollParams {
    typealias ERagPhase = Int32
    static let RP_START_DEATH_ANIM: ERagPhase = 0
    static let RP_END_DEATH_ANIM: ERagPhase = 1
    static let RP_DEATH_COLLISION: ERagPhase = 2
    static let RP_CORPSE_SHOT: ERagPhase = 3
    static let RP_GET_PELVIS_OFFSET: ERagPhase = 4  // this actually does nothing but set the pelvisAnglesOffset, and pelvisPositionOffset
    static let RP_SET_PELVIS_OFFSET: ERagPhase = 5  // this actually does nothing but set the pelvisAnglesOffset, and pelvisPositionOffset
    static let RP_DISABLE_EFFECTORS: ERagPhase = 6  // this removes effectors given by the effectorsToTurnOff member

    var angles = JKAShared.vec3_t()
    var position = JKAShared.vec3_t()
    var scale = JKAShared.vec3_t()
    var pelvisAnglesOffset = JKAShared.vec3_t()    // always set on return, an argument for RP_SET_PELVIS_OFFSET
    var pelvisPositionOffset = JKAShared.vec3_t() // always set on return, an argument for RP_SET_PELVIS_OFFSET

    var fImpactStrength: Float = 0 //should be applicable when RagPhase is RP_DEATH_COLLISION
    var fShotStrength: Float = 0 //should be applicable for setting velocity of corpse on shot (probably only on RP_CORPSE_SHOT)
    //CServerEntity *me;
    var me: Int32 = 0

    //rww - we have convenient animation/frame access in the game, so just send this info over from there.
    var startFrame: Int32 = 0
    var endFrame: Int32 = 0

    var collisionType: Int32 = 0 // 1 = from a fall, 0 from effectors, this will be going away soon, hence no enum

    var CallRagDollBegin: Bool = false // a return value, means that we are now begininng ragdoll and the NPC stuff needs to happen

    var RagPhase: ERagPhase = 0

// effector control, used for RP_DISABLE_EFFECTORS call

    typealias ERagEffector = Int32
    static let RE_MODEL_ROOT: ERagEffector = 0x00000001 //"model_root"
    static let RE_PELVIS: ERagEffector = 0x00000002 //"pelvis"
    static let RE_LOWER_LUMBAR: ERagEffector = 0x00000004 //"lower_lumbar"
    static let RE_UPPER_LUMBAR: ERagEffector = 0x00000008 //"upper_lumbar"
    static let RE_THORACIC: ERagEffector = 0x00000010 //"thoracic"
    static let RE_CRANIUM: ERagEffector = 0x00000020 //"cranium"
    static let RE_RHUMEROUS: ERagEffector = 0x00000040 //"rhumerus"
    static let RE_LHUMEROUS: ERagEffector = 0x00000080 //"lhumerus"
    static let RE_RRADIUS: ERagEffector = 0x00000100 //"rradius"
    static let RE_LRADIUS: ERagEffector = 0x00000200 //"lradius"
    static let RE_RFEMURYZ: ERagEffector = 0x00000400 //"rfemurYZ"
    static let RE_LFEMURYZ: ERagEffector = 0x00000800 //"lfemurYZ"
    static let RE_RTIBIA: ERagEffector = 0x00001000 //"rtibia"
    static let RE_LTIBIA: ERagEffector = 0x00002000 //"ltibia"
    static let RE_RHAND: ERagEffector = 0x00004000 //"rhand"
    static let RE_LHAND: ERagEffector = 0x00008000 //"lhand"
    static let RE_RTARSAL: ERagEffector = 0x00010000 //"rtarsal"
    static let RE_LTARSAL: ERagEffector = 0x00020000 //"ltarsal"
    static let RE_RTALUS: ERagEffector = 0x00040000 //"rtalus"
    static let RE_LTALUS: ERagEffector = 0x00080000 //"ltalus"
    static let RE_RRADIUSX: ERagEffector = 0x00100000 //"rradiusX"
    static let RE_LRADIUSX: ERagEffector = 0x00200000 //"lradiusX"
    static let RE_RFEMURX: ERagEffector = 0x00400000 //"rfemurX"
    static let RE_LFEMURX: ERagEffector = 0x00800000 //"lfemurX"
    static let RE_CEYEBROW: ERagEffector = 0x01000000 //"ceyebrow"

    var effectorsToTurnOff: ERagEffector = 0  // set this to an | of the above flags for a RP_DISABLE_EFFECTORS
}
