import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_flechette.c:11
public func FX_FlechetteProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.flechetteShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/**
```
-------------------------
FX_FlechetteWeaponHitWall
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_flechette.c:28
public func FX_FlechetteWeaponHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.flechetteWallImpactEffect, origin, normal, -1, -1)
}

/**
```
-------------------------
FX_FlechetteWeaponHitPlayer
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_flechette.c:38
public func FX_FlechetteWeaponHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    //	if ( humanoid )
    //	{
    trap_FX_PlayEffectID(cgs.effects.flechetteFleshImpactEffect, origin, normal, -1, -1)
    //	}
    //	else
    //	{
    //		trap_FX_PlayEffect( "blaster/droid_impact", origin, normal );
    //	}
}

/// Source: oracle/codemp/cgame/fx_flechette.c:57
public func FX_FlechetteAltProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.flechetteAltShotEffect, cent.lerpOrigin, forward, -1, -1)
}
