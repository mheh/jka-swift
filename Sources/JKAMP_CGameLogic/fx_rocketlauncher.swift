import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_rocketlauncher.c:11
public func FX_RocketProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.rocketShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_rocketlauncher.c:29
public func FX_RocketHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.rocketExplosionEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_rocketlauncher.c:40
public func FX_RocketHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.rocketExplosionEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_rocketlauncher.c:51
public func FX_RocketAltProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.rocketShotEffect, cent.lerpOrigin, forward, -1, -1)
}
