import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's record of one ragdoll effector collision, the effector position and the trace that hit.
/// `CRagDollUpdateParams.EffectorCollision` takes one.
/// Source: oracle/codemp/ghoul2/G2_gore.h:81
public final class SRagDollEffectorCollision {
    public var effectorPosition = JKAShared.vec3_t()
    public let tr: Trace
    public var useTracePlane: Bool = false

    /// Source: oracle/codemp/ghoul2/G2_gore.h:86
    public init(_ effectorPos: JKAShared.vec3_t, _ t: Trace) {
        self.tr = t
        self.useTracePlane = false
        self.effectorPosition = effectorPos
    }
}

/// Raven's parameters of one ragdoll update, the entity's angles, position, scale, and velocity, with the ragdoll callbacks.
/// The ragdoll update of G2_bones.cpp reads it, and its callbacks do nothing in MP.
/// Source: oracle/codemp/ghoul2/G2_gore.h:94
// AI: Raven declares the four callbacks virtual, and no class derives from this one. They are plain methods.
public final class CRagDollUpdateParams {
    public var angles = JKAShared.vec3_t()
    public var position = JKAShared.vec3_t()
    public var scale = JKAShared.vec3_t()
    public var velocity = JKAShared.vec3_t()
    //CServerEntity *me;
    public var me: Int32 = 0 //index!
    public var settleFrame: Int32 = 0

    //at some point I'll want to make VM callbacks in here. For now I am just doing nothing.
    /// Source: oracle/codemp/ghoul2/G2_gore.h:106
    public func EffectorCollision(_ data: SRagDollEffectorCollision) {
    //	assert(0); // you probably meant to override this
    }

    /// Source: oracle/codemp/ghoul2/G2_gore.h:110
    public func RagDollBegin() {
    //	assert(0); // you probably meant to override this
    }

    /// Source: oracle/codemp/ghoul2/G2_gore.h:114
    public func RagDollSettled() {
    //	assert(0); // you probably meant to override this
    }

    /// Source: oracle/codemp/ghoul2/G2_gore.h:119
    public func Collision() {
    //	assert(0); // you probably meant to override this
        // we had a collision, uhh I guess call SetRagDoll RP_DEATH_COLLISION
    }
}
