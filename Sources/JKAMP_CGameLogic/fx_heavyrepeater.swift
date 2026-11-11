import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:11
public func FX_RepeaterProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.repeaterProjectileEffect, cent.lerpOrigin, forward, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:29
public func FX_RepeaterHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.repeaterWallImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:40
public func FX_RepeaterHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.repeaterFleshImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:45
private func CG_DistortionOrb(_ cent: Centity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { ent -> Bool in
        var ang = vec3_t()
        let scale: Float = 0.5
        var vLen: Float = 0

        if cg_renderToTextureFX.integer == 0 {
            return true
        }
        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        ent.origin = cent.lerpOrigin

        ent.axis[0] = ent.origin - cg.refdef.vieworg
        vLen = VectorLength(ent.axis[0])
        if VectorNormalize(&ent.axis[0]) <= 0.1 {
            // Entity is right on vieworg.  quit.
            return true
        }

        //	VectorCopy(cg.refdef.viewaxis[2], ent.axis[2]);
        //	CrossProduct(ent.axis[0], ent.axis[2], ent.axis[1]);
        vectoangles(ent.axis[0], &ang)
        ang[ROLL] = Float(cent.trickAlpha)
        cent.trickAlpha += 16 //spin the half-sphere to give a "screwdriver" effect
        AnglesToAxis(ang, ent.axis)

        //radius must be a power of 2, and is the actual captured texture size
        if vLen < 128 {
            ent.radius = 256
        } else if vLen < 256 {
            ent.radius = 128
        } else if vLen < 512 {
            ent.radius = 64
        } else {
            ent.radius = 32
        }

        ent.axis[0] = ent.axis[0] * scale
        ent.axis[1] = ent.axis[1] * scale
        ent.axis[2] = ent.axis[2] * -scale

        ent.hModel = cgs.media.halfShieldModel
        ent.customShader = 0 //cgs.media.halfShieldShader;

        ent.renderfx = (RF_DISTORTION | RF_RGB_TINT)

        //tint the whole thing a shade of blue
        ent.shaderRGBA[0] = UInt8(truncatingIfNeeded: 200)
        ent.shaderRGBA[1] = UInt8(truncatingIfNeeded: 200)
        ent.shaderRGBA[2] = UInt8(truncatingIfNeeded: 255)

        trap_R_AddRefEntityToScene(ent)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:119
public func FX_RepeaterAltProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    if cg_repeaterOrb.integer != 0 {
        CG_DistortionOrb(cent)
    }
    trap_FX_PlayEffectID(cgs.effects.repeaterAltProjectileEffect, cent.lerpOrigin, forward, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:141
public func FX_RepeaterAltHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.repeaterAltWallImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_heavyrepeater.c:152
public func FX_RepeaterAltHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.repeaterAltWallImpactEffect, origin, normal, -1, -1)
}
