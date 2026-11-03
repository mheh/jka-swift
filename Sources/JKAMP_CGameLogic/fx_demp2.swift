import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_demp2.c:11
func FX_DEMP2_ProjectileThink(_ cent: Centity, _ weapon: WeaponInfo) {
    var forward = vec3_t()

    if VectorNormalize2(cent.currentState.pos.trDelta, &forward) == 0.0 {
        forward[2] = 1.0
    }

    trap_FX_PlayEffectID(cgs.effects.demp2ProjectileEffect, cent.lerpOrigin, forward, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_demp2.c:29
func FX_DEMP2_HitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.demp2WallImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_demp2.c:40
func FX_DEMP2_HitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.demp2FleshImpactEffect, origin, normal, -1, -1)
}

/**
```
---------------------------
FX_DEMP2_AltBeam
---------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_demp2.c:50
func FX_DEMP2_AltBeam(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ targ1: JKAShared.vec3_t, _ targ2: JKAShared.vec3_t) {
    //NOTENOTE Fix this after trap calls for all primitives are created.
    /*
    vec3_t	dir, chaos,
    c1, c2,
    v1, v2;
    float	len,
    s1, s2, s3;

    VectorSubtract( end, start, dir );
    len = VectorNormalize( dir );

    // Get the base control points, we'll work from there
    VectorMA( start, 0.3333f * len, dir, c1 );
    VectorMA( start, 0.6666f * len, dir, c2 );

    // get some chaos values that really aren't very chaotic :)
    s1 = sin( cg.time * 0.005f ) * 2 + crandom() * 0.2f;
    s2 = sin( cg.time * 0.001f );
    s3 = sin( cg.time * 0.011f );

    VectorSet( chaos, len * 0.01f * s1,
    len * 0.02f * s2,
    len * 0.04f * (s1 + s2 + s3));

    VectorAdd( c1, chaos, c1 );
    VectorScale( chaos, 4.0f, v1 );

    VectorSet( chaos, -len * 0.02f * s3,
    len * 0.01f * (s1 * s2),
    -len * 0.02f * (s1 + s2 * s3));

    VectorAdd( c2, chaos, c2 );
    VectorScale( chaos, 2.0f, v2 );

    VectorSet( chaos, 1.0f, 1.0f, 1.0f );

    FX_AddBezier( start, targ1,
    c1, v1, c2, v2,
    5.0f + s1 * 2, 8.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );

    FX_AddBezier( start, targ1,
    c2, v2, c1, v1,
    3.0f + s3, 3.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );

    s1 = sin( cg.time * 0.0005f ) + crandom() * 0.1f;
    s2 = sin( cg.time * 0.0025f );
    float cc2 = cos( cg.time * 0.0025f );
    s3 = sin( cg.time * 0.01f ) + crandom() * 0.1f;

    VectorSet( chaos, len * 0.08f * s2,
    len * 0.04f * cc2,//s1 * -s3,
    len * 0.06f * s3 );

    VectorAdd( c1, chaos, c1 );
    VectorScale( chaos, 4.0f, v1 );

    VectorSet( chaos, len * 0.02f * s1 * s3,
    len * 0.04f * s2,
    len * 0.03f * s1 * s2 );

    VectorAdd( c2, chaos, c2 );
    VectorScale( chaos, 3.0f, v2 );

    VectorSet( chaos, 1.0f, 1.0f, 1.0f );

    FX_AddBezier( start, targ1,
    c1, v1, c2, v2,
    4.0f + s3, 8.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );

    FX_AddBezier( start, targ1,
    c2, v1, c1, v2,
    5.0f + s1 * 2, 8.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );


    VectorMA( start, 14.0f, dir, c1 );

    FX_AddSprite( c1, NULL, NULL, 12.0f + crandom() * 4, 0.0f, 1.0f, 1.0f, random() * 360, 0.0f, 1.0f,
    trap_R_RegisterShader( "gfx/misc/lightningFlash" ));
    FX_AddSprite( c1, NULL, NULL, 6.0f + crandom() * 2, 0.0f, 1.0f, 1.0f, random() * 360, 0.0f, 1.0f,
    trap_R_RegisterShader( "gfx/misc/lightningFlash" ));

    FX_AddSprite( targ1, NULL, NULL, 4.0f + crandom(), 0.0f, 1.0f, 0.0f, chaos, chaos, random() * 360, 0.0f, 10,
    trap_R_RegisterShader( "gfx/misc/lightningFlash" ));
    FX_AddSprite( targ1, NULL, NULL, 8.0f + crandom() * 2, 0.0f, 1.0f, 0.0f, chaos, chaos, random() * 360, 0.0f, 10,
    trap_R_RegisterShader( "gfx/misc/lightningFlash" ));


    //--------------------------------------------

    VectorSubtract( targ2, targ1, dir );
    len = VectorNormalize( dir );

    // Get the base control points, we'll work from there
    VectorMA( targ1, 0.3333f * len, dir, c1 );
    VectorMA( targ1, 0.6666f * len, dir, c2 );

    // get some chaos values that really aren't very chaotic :)
    s1 = sin( cg.time * 0.005f ) * 2 + crandom() * 0.2f;
    s2 = sin( cg.time * 0.001f );
    s3 = sin( cg.time * 0.011f );

    VectorSet( chaos, len * 0.01f * s1,
    len * 0.02f * s2,
    len * 0.04f * (s1 + s2 + s3));

    VectorAdd( c1, chaos, c1 );
    VectorScale( chaos, 4.0f, v1 );

    VectorSet( chaos, -len * 0.02f * s3,
    len * 0.01f * (s1 * s2),
    -len * 0.02f * (s1 + s2 * s3));

    VectorAdd( c2, chaos, c2 );
    VectorScale( chaos, 2.0f, v2 );

    VectorSet( chaos, 1.0f, 1.0f, 1.0f );

    FX_AddBezier( targ1, targ2,
    c1, v1, c2, v2,
    5.0f + s1 * 2, 8.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );

    FX_AddBezier( targ1, targ2,
    c2, v2, c1, v1,
    3.0f + s3, 3.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );

    s1 = sin( cg.time * 0.0005f ) + crandom() * 0.1f;
    s2 = sin( cg.time * 0.0025f );
    cc2 = cos( cg.time * 0.0025f );
    s3 = sin( cg.time * 0.01f ) + crandom() * 0.1f;

    VectorSet( chaos, len * 0.08f * s2,
    len * 0.04f * cc2,//s1 * -s3,
    len * 0.06f * s3 );

    VectorAdd( c1, chaos, c1 );
    VectorScale( chaos, 4.0f, v1 );

    VectorSet( chaos, len * 0.02f * s1 * s3,
    len * 0.04f * s2,
    len * 0.03f * s1 * s2 );

    VectorAdd( c2, chaos, c2 );
    VectorScale( chaos, 3.0f, v2 );

    VectorSet( chaos, 1.0f, 1.0f, 1.0f );

    FX_AddBezier( targ1, targ2,
    c1, v1, c2, v2,
    4.0f + s3, 8.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );

    FX_AddBezier( targ1, targ2,
    c2, v1, c1, v2,
    5.0f + s1 * 2, 8.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    chaos, chaos, 0.0f,
    1.0f, trap_R_RegisterShader( "gfx/misc/electric2" ), FX_ALPHA_LINEAR );


    FX_AddSprite( targ2, NULL, NULL, 4.0f + crandom(), 0.0f, 1.0f, 0.0f, chaos, chaos, random() * 360, 0.0f, 10,
    trap_R_RegisterShader( "gfx/misc/lightningFlash" ));
    FX_AddSprite( targ2, NULL, NULL, 8.0f + crandom() * 2, 0.0f, 1.0f, 0.0f, chaos, chaos, random() * 360, 0.0f, 10,
    trap_R_RegisterShader( "gfx/misc/lightningFlash" ));
    */
}

//---------------------------------------------
/// Source: oracle/codemp/cgame/fx_demp2.c:240
func FX_DEMP2_AltDetonate(_ org: JKAShared.vec3_t, _ size: Float) {
    var ex: LocalEntity?

    ex = CG_AllocLocalEntity()
    ex!.leType = LE_FADE_SCALE_MODEL
    ex!.refEntity.clear()

    ex!.refEntity.renderfx |= RF_VOLUMETRIC

    ex!.startTime = cg.time
    ex!.endTime = ex!.startTime + 800 //1600;

    ex!.radius = size
    ex!.refEntity.customShader = cgs.media.demp2ShellShader
    ex!.refEntity.hModel = cgs.media.demp2Shell
    ex!.refEntity.origin = org

    ex!.color[2] = 255.0
    ex!.color[1] = ex!.color[2]
    ex!.color[0] = ex!.color[1]
}
