import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_bryarpistol.c:219
/// Raven's data table, a hand property of `CGameWorld`.
private var WHITE: JKAShared.vec3_t {
    get { world.fx_bryarpistol_WHITE }
    set { world.fx_bryarpistol_WHITE = newValue }
}

/// Source: oracle/codemp/cgame/fx_bryarpistol.c:220
/// Raven's data table, a hand property of `CGameWorld`.
var BRIGHT: JKAShared.vec3_t {
    get { world.BRIGHT }
    set { world.BRIGHT = newValue }
}

/**
```
-------------------------

	MAIN FIRE

-------------------------
FX_BryarProjectileThink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:15
func FX_BryarProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.bryarShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/**
```
-------------------------
FX_BryarHitWall
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:32
func FX_BryarHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.bryarWallImpactEffect, origin, normal, -1, -1)
}

/**
```
-------------------------
FX_BryarHitPlayer
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:42
func FX_BryarHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    if humanoid {
        trap_FX_PlayEffectID(cgs.effects.bryarFleshImpactEffect, origin, normal, -1, -1)
    } else {
        trap_FX_PlayEffectID(cgs.effects.bryarDroidImpactEffect, origin, normal, -1, -1)
    }
}

/**
```
-------------------------

	ALT FIRE

-------------------------
FX_BryarAltProjectileThink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:64
func FX_BryarAltProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()
    var t: Int32

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    // see if we have some sort of extra charge going on
    t = 1
    while t < cent.currentState.generic1 {
        // just add ourselves over, and over, and over when we are charged
        trap_FX_PlayEffectID(cgs.effects.bryarPowerupShotEffect, cent.lerpOrigin, forward, -1, -1)
        t += 1
    }

    //	for ( int t = 1; t < cent->gent->count; t++ )	// The single player stores the charge in count, which isn't accessible on the client

    trap_FX_PlayEffectID(cgs.effects.bryarShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/**
```
-------------------------
FX_BryarAltHitWall
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:91
func FX_BryarAltHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ power: Int32) {
    switch power {
    case 4, 5:
        trap_FX_PlayEffectID(cgs.effects.bryarWallImpactEffect3, origin, normal, -1, -1)

    case 2, 3:
        trap_FX_PlayEffectID(cgs.effects.bryarWallImpactEffect2, origin, normal, -1, -1)

    default:
        trap_FX_PlayEffectID(cgs.effects.bryarWallImpactEffect, origin, normal, -1, -1)
    }
}

/**
```
-------------------------
FX_BryarAltHitPlayer
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:116
func FX_BryarAltHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    if humanoid {
        trap_FX_PlayEffectID(cgs.effects.bryarFleshImpactEffect, origin, normal, -1, -1)
    } else {
        trap_FX_PlayEffectID(cgs.effects.bryarDroidImpactEffect, origin, normal, -1, -1)
    }
}

//TURRET
/**
```
-------------------------
FX_TurretProjectileThink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:135
func FX_TurretProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.turretShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/**
```
-------------------------
FX_TurretHitWall
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:152
func FX_TurretHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.bryarWallImpactEffect, origin, normal, -1, -1)
}

/**
```
-------------------------
FX_TurretHitPlayer
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:162
func FX_TurretHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    if humanoid {
        trap_FX_PlayEffectID(cgs.effects.bryarFleshImpactEffect, origin, normal, -1, -1)
    } else {
        trap_FX_PlayEffectID(cgs.effects.bryarDroidImpactEffect, origin, normal, -1, -1)
    }
}

//CONCUSSION (yeah, should probably make a new file for this.. or maybe just move all these stupid semi-redundant fx_ functions into one file)
/**
```
-------------------------
FX_ConcussionHitWall
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:182
func FX_ConcussionHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.concussionImpactEffect, origin, normal, -1, -1)
}

/**
```
-------------------------
FX_ConcussionHitPlayer
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:192
func FX_ConcussionHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.concussionImpactEffect, origin, normal, -1, -1)
}

/**
```
-------------------------
FX_ConcussionProjectileThink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_bryarpistol.c:202
func FX_ConcussionProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.concussionShotEffect, cent.lerpOrigin, forward, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_bryarpistol.c:222
func FX_ConcAltShot(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    //"concussion/beam"
    trap_FX_AddLine(start, end, 0.1, 10.0, 0.0, 1.0, 0.0, 0.0, WHITE, WHITE, 0.0, 175, trap_R_RegisterShader("gfx/effects/blueLine"), FX_SIZE_LINEAR | FX_ALPHA_LINEAR)

    // add some beef
    trap_FX_AddLine(start, end, 0.1, 7.0, 0.0, 1.0, 0.0, 0.0, BRIGHT, BRIGHT, 0.0, 150, trap_R_RegisterShader("gfx/misc/whiteline2"), FX_SIZE_LINEAR | FX_ALPHA_LINEAR)
}
