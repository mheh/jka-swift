import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's record of one ragdoll effector collision, the effector position and the trace that hit.
/// `CRagDollUpdateParams.EffectorCollision` takes one.
/// Source: oracle/codemp/ghoul2/G2_gore.h:81
final class SRagDollEffectorCollision {
    var effectorPosition = JKAShared.vec3_t()
    let tr: Trace
    var useTracePlane: Bool = false

    /// Source: oracle/codemp/ghoul2/G2_gore.h:86
    init(_ effectorPos: JKAShared.vec3_t, _ t: Trace) {
        // TODO: Port SRagDollEffectorCollision::SRagDollEffectorCollision
        portMissing("SRagDollEffectorCollision::SRagDollEffectorCollision", source: "oracle/codemp/ghoul2/G2_gore.h:86")
    }
}

/// Raven's parameters of one ragdoll update, the entity's angles, position, scale, and velocity, with the ragdoll callbacks.
/// The ragdoll update of G2_bones.cpp reads it, and its callbacks do nothing in MP.
/// Source: oracle/codemp/ghoul2/G2_gore.h:94
// AI: Raven declares the four callbacks virtual, and no class derives from this one. They are plain methods.
final class CRagDollUpdateParams {
    var angles = JKAShared.vec3_t()
    var position = JKAShared.vec3_t()
    var scale = JKAShared.vec3_t()
    var velocity = JKAShared.vec3_t()
    //CServerEntity *me;
    var me: Int32 = 0 //index!
    var settleFrame: Int32 = 0

    //at some point I'll want to make VM callbacks in here. For now I am just doing nothing.
    /// Source: oracle/codemp/ghoul2/G2_gore.h:106
    func EffectorCollision(_ data: SRagDollEffectorCollision) {
        // TODO: Port CRagDollUpdateParams::EffectorCollision
        portMissing("CRagDollUpdateParams::EffectorCollision", source: "oracle/codemp/ghoul2/G2_gore.h:106")
    }

    /// Source: oracle/codemp/ghoul2/G2_gore.h:110
    func RagDollBegin() {
        // TODO: Port CRagDollUpdateParams::RagDollBegin
        portMissing("CRagDollUpdateParams::RagDollBegin", source: "oracle/codemp/ghoul2/G2_gore.h:110")
    }

    /// Source: oracle/codemp/ghoul2/G2_gore.h:114
    func RagDollSettled() {
        // TODO: Port CRagDollUpdateParams::RagDollSettled
        portMissing("CRagDollUpdateParams::RagDollSettled", source: "oracle/codemp/ghoul2/G2_gore.h:114")
    }

    /// Source: oracle/codemp/ghoul2/G2_gore.h:119
    func Collision() {
        // TODO: Port CRagDollUpdateParams::Collision
        portMissing("CRagDollUpdateParams::Collision", source: "oracle/codemp/ghoul2/G2_gore.h:119")
    }
}
