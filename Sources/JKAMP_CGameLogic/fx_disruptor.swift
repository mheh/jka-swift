import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/fx_disruptor.c:11
/// Raven's data table, a hand property of `CGameWorld`.
private var WHITE: JKAShared.vec3_t {
    get { world.fx_disruptor_WHITE }
    set { world.fx_disruptor_WHITE = newValue }
}

/// Source: oracle/codemp/cgame/fx_disruptor.c:68
let FX_ALPHA_WAVE = 0x00000008 as Int32

/// Source: oracle/codemp/cgame/fx_disruptor.c:13
func FX_DisruptorMainShot(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    //	vec3_t	dir;
    //	float	len;

    trap_FX_AddLine(start, end, 0.1, 6.0, 0.0, 1.0, 0.0, 0.0, WHITE, WHITE, 0.0, 150, trap_R_RegisterShader("gfx/effects/redLine"), FX_SIZE_LINEAR | FX_ALPHA_LINEAR)

    //	VectorSubtract( end, start, dir );
    //	len = VectorNormalize( dir );

    //	FX_AddCylinder( start, dir, 5.0f, 5.0f, 0.0f,
    //								5.0f, 5.0f, 0.0f,
    //								len, len, 0.0f,
    //								1.0f, 1.0f, 0.0f,
    //								WHITE, WHITE, 0.0f,
    //								400, cgi_R_RegisterShader( "gfx/effects/spiral" ), 0 );
}

/**
```
---------------------------
FX_DisruptorAltShot
---------------------------
```
*/
/// Source: oracle/codemp/cgame/fx_disruptor.c:41
func FX_DisruptorAltShot(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ fullCharge: Bool) {
    trap_FX_AddLine(start, end, 0.1, 10.0, 0.0, 1.0, 0.0, 0.0, WHITE, WHITE, 0.0, 175, trap_R_RegisterShader("gfx/effects/redLine"), FX_SIZE_LINEAR | FX_ALPHA_LINEAR)

    if fullCharge {
        var YELLER = vec3_t(0.8, 0.7, 0.0)

        // add some beef
        trap_FX_AddLine(start, end, 0.1, 7.0, 0.0, 1.0, 0.0, 0.0, YELLER, YELLER, 0.0, 150, trap_R_RegisterShader("gfx/misc/whiteline2"), FX_SIZE_LINEAR | FX_ALPHA_LINEAR)
    }
}

/// Source: oracle/codemp/cgame/fx_disruptor.c:70
func FX_DisruptorAltMiss(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    var pos = vec3_t()
    var c1 = vec3_t()
    var c2 = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    AddbezierArgStruct.scratch { b in

        _VectorMA(origin, 4.0, normal, &c1)
        c2 = c1
        c1[2] += 4
        c2[2] += 12

        pos = origin + normal
        pos[2] += 28

        /*
        FX_AddBezier( origin, pos, c1, vec3_origin, c2, vec3_origin, 6.0f, 6.0f, 0.0f, 0.0f, 0.2f, 0.5f,
        WHITE, WHITE, 0.0f, 4000, trap_R_RegisterShader( "gfx/effects/smokeTrail" ), FX_ALPHA_WAVE );
        */

        b.start = origin
        b.end = pos
        b.control1 = c1
        b.control1Vel = vec3_origin
        b.control2 = c2
        b.control2Vel = vec3_origin

        b.size1 = 6.0
        b.size2 = 6.0
        b.sizeParm = 0.0
        b.alpha1 = 0.0
        b.alpha2 = 0.2
        b.alphaParm = 0.5

        b.sRGB = WHITE
        b.eRGB = WHITE

        b.rgbParm = 0.0
        b.killTime = 4000
        b.shader = trap_R_RegisterShader("gfx/effects/smokeTrail")
        b.flags = FX_ALPHA_WAVE

        trap_FX_AddBezier(b)

        trap_FX_PlayEffectID(cgs.effects.disruptorAltMissEffect, origin, normal, -1, -1)
    }
}

/// Source: oracle/codemp/cgame/fx_disruptor.c:121
func FX_DisruptorAltHit(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.disruptorAltHitEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_disruptor.c:134
func FX_DisruptorHitWall(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    trap_FX_PlayEffectID(cgs.effects.disruptorWallImpactEffect, origin, normal, -1, -1)
}

/// Source: oracle/codemp/cgame/fx_disruptor.c:145
func FX_DisruptorHitPlayer(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ humanoid: Bool) {
    trap_FX_PlayEffectID(cgs.effects.disruptorFleshImpactEffect, origin, normal, -1, -1)
}
