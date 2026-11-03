import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_blaster.c:11
func FX_BlasterProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.blasterShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/**
```
-------------------------
FX_BlasterAltFireThink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_blaster.c:28
func FX_BlasterAltFireThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.blasterShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/**
```
-------------------------
FX_BlasterWeaponHitWall
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_blaster.c:45
func FX_BlasterWeaponHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.blasterWallImpactEffect, origin, normal, -1, -1)
}

/**
```
-------------------------
FX_BlasterWeaponHitPlayer
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_blaster.c:55
func FX_BlasterWeaponHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    if humanoid {
        trap_FX_PlayEffectID(cgs.effects.blasterFleshImpactEffect, origin, normal, -1, -1)
    } else {
        trap_FX_PlayEffectID(cgs.effects.blasterDroidImpactEffect, origin, normal, -1, -1)
    }
}
