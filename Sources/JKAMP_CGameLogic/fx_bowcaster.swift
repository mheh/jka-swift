import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_bowcaster.c:11
func FX_BowcasterProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.bowcasterShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_bowcaster.c:29
func FX_BowcasterHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.bowcasterImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_bowcaster.c:40
func FX_BowcasterHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.bowcasterImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_bowcaster.c:51
func FX_BowcasterAltProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.bowcasterShotEffect, cent.lerpOrigin, forward, -1, -1)
}
