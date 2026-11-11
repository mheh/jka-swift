import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_effects.c:254
var offX: [[Float]] {
    get { world.variables.offX }
    set { world.variables.offX = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:255
var offZ: [[Float]] {
    get { world.variables.offZ }
    set { world.variables.offZ = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:257
let FX_ALPHA_NONLINEAR = 0x00000004 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:258
let FX_APPLY_PHYSICS = 0x02000000 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:259
private let FX_USE_ALPHA = 0x08000000 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:452
let TIME_DECAY_SLOW = 0.1 as Float

/// Source: oracle/codemp/cgame/cg_effects.c:453
let TIME_DECAY_MED = 0.04 as Float

/// Source: oracle/codemp/cgame/cg_effects.c:454
let TIME_DECAY_FAST = 0.009 as Float

/// Source: oracle/codemp/cgame/cg_effects.c:756
let DEBRIS_SPECIALCASE_ROCK = -1 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:757
let DEBRIS_SPECIALCASE_CHUNKS = -2 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:758
let DEBRIS_SPECIALCASE_WOOD = -3 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:759
let DEBRIS_SPECIALCASE_GLASS = -4 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:761
let NUM_DEBRIS_MODELS_GLASS = 8 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:762
let NUM_DEBRIS_MODELS_WOOD = 8 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:763
let NUM_DEBRIS_MODELS_CHUNKS = 3 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:764
let NUM_DEBRIS_MODELS_ROCKS = 4 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:766
var dbModels_Glass: [Int32] {
    get { world.variables.dbModels_Glass }
    set { world.variables.dbModels_Glass = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:767
var dbModels_Wood: [Int32] {
    get { world.variables.dbModels_Wood }
    set { world.variables.dbModels_Wood = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:768
var dbModels_Chunks: [Int32] {
    get { world.variables.dbModels_Chunks }
    set { world.variables.dbModels_Chunks = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:769
var dbModels_Rocks: [Int32] {
    get { world.variables.dbModels_Rocks }
    set { world.variables.dbModels_Rocks = newValue }
}

/// Source: oracle/codemp/cgame/cg_effects.c:1384
let NUM_SPARKS = 12 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:1385
let NUM_PUFFS = 1 as Int32

/// Source: oracle/codemp/cgame/cg_effects.c:1386
let NUM_EXPLOSIONS = 4 as Int32

/**
```
==================
CG_BubbleTrail

Bullets shot underwater
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:15
func CG_BubbleTrail(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ spacing: Float) {
    var move = vec3_t()
    var vec = vec3_t()
    let len: Float
    var i: Int32

    if cg_noProjectileTrail.integer != 0 {
        return
    }

    move = start
    vec = end - start
    len = VectorNormalize(&vec)

    // advance a random amount first
    // The SDK also declares `rand`, so the call names the bg module.
    i = JKAMP_BG.rand() % Int32(spacing)
    _VectorMA(move, Float(i), vec, &move)

    vec = vec * spacing

    while i < len {
        var le: LocalEntity?
        var re: RefEntity?

        le = CG_AllocLocalEntity()
        le!.leFlags = LEF_PUFF_DONT_SCALE
        le!.leType = LE_MOVE_SCALE_FADE
        le!.startTime = cg.time
        // The SDK also declares `random`, so the call names the bg module.
        le!.endTime = Int32(cg.time + 1000 + JKAMP_BG.random() * 250)
        le!.lifeRate = Float(1.0 / Double(le!.endTime - le!.startTime))

        re = le!.refEntity
        re!.shaderTime = cg.time / 1000.0

        re!.reType = RT_SPRITE
        re!.rotation = 0
        re!.radius = 3
        re!.customShader = 0 //cgs.media.waterBubbleShader;
        re!.shaderRGBA[0] = 0xff
        re!.shaderRGBA[1] = 0xff
        re!.shaderRGBA[2] = 0xff
        re!.shaderRGBA[3] = 0xff

        le!.color[3] = 1.0

        le!.pos.trType = TR_LINEAR
        le!.pos.trTime = cg.time
        le!.pos.trBase = move
        le!.pos.trDelta[0] = Float(crandom() * 5)
        le!.pos.trDelta[1] = Float(crandom() * 5)
        le!.pos.trDelta[2] = Float(crandom() * 5 + 6)

        move = move + vec
        i = Int32(Float(i) + spacing)
    }
}

/// Raven's `static int seed` of `CG_SmokePuff`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_effects.c:86
var seed: Int32 {
    get { world.seed }
    set { world.seed = newValue }
}

/**
```
=====================
CG_SmokePuff

Adds a smoke puff or blood trail localEntity.
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:78
func CG_SmokePuff(_ p: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ radius: Float, _ r: Float, _ g: Float, _ b: Float, _ a: Float, _ duration: Float, _ startTime: Int32, _ fadeInTime: Int32, _ leFlags: Int32, _ hShader: JKAShared.qhandle_t) -> LocalEntity? {
    var le: LocalEntity?
    var re: RefEntity?
    //	int fadeInTime = startTime + duration / 2;

    le = CG_AllocLocalEntity()
    le!.leFlags = leFlags
    le!.radius = radius

    re = le!.refEntity
    re!.rotation = Q_random(&seed) * 360
    re!.radius = radius
    re!.shaderTime = startTime / 1000.0

    le!.leType = LE_MOVE_SCALE_FADE
    le!.startTime = startTime
    le!.fadeInTime = fadeInTime
    le!.endTime = Int32(startTime + duration)
    if fadeInTime > startTime {
        le!.lifeRate = Float(1.0 / Double(le!.endTime - le!.fadeInTime))
    } else {
        le!.lifeRate = Float(1.0 / Double(le!.endTime - le!.startTime))
    }
    le!.color[0] = r
    le!.color[1] = g
    le!.color[2] = b
    le!.color[3] = a


    le!.pos.trType = TR_LINEAR
    le!.pos.trTime = startTime
    le!.pos.trDelta = vel
    le!.pos.trBase = p

    re!.origin = p
    re!.customShader = hShader

    re!.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(le!.color[0] * 0xff))
    re!.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(le!.color[1] * 0xff))
    re!.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(le!.color[2] * 0xff))
    re!.shaderRGBA[3] = 0xff

    re!.reType = RT_SPRITE
    re!.radius = le!.radius

    return le
}

/// Source: oracle/codemp/cgame/cg_effects.c:135
func CGDEBUG_SaberColor(_ saberColor: Int32) -> Int32 {
    switch Int32((saberColor)) {
    case SABER_RED:
        return 0x000000ff

    case SABER_ORANGE:
        return 0x000088ff

    case SABER_YELLOW:
        return 0x0000ffff

    case SABER_GREEN:
        return 0x0000ff00

    case SABER_BLUE:
        return 0x00ff0000

    case SABER_PURPLE:
        return 0x00ff00ff

    default:
        return saberColor
    }
}

/// Source: oracle/codemp/cgame/cg_effects.c:163
func CG_TestLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ time: Int32, _ color: UInt32, _ radius: Int32) {
    var le: LocalEntity?
    var re: RefEntity?
    // Raven assigns his own `color` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var color = color

    le = CG_AllocLocalEntity()
    le!.leType = LE_LINE
    le!.startTime = cg.time
    le!.endTime = cg.time + time
    le!.lifeRate = Float(1.0 / Double(le!.endTime - le!.startTime))

    re = le!.refEntity
    re!.origin = start
    re!.oldorigin = end
    re!.shaderTime = cg.time / 1000.0

    re!.reType = RT_LINE
    re!.radius = Float(0.5 * Double(radius))
    re!.customShader = cgs.media.whiteShader //trap_R_RegisterShaderNoMip("textures/colombia/canvas_doublesided");

    re!.shaderTexCoord[1] = 1.0
    re!.shaderTexCoord[0] = re!.shaderTexCoord[1]

    if color == 0 {
        re!.shaderRGBA[3] = 0xff
        re!.shaderRGBA[2] = re!.shaderRGBA[3]
        re!.shaderRGBA[1] = re!.shaderRGBA[2]
        re!.shaderRGBA[0] = re!.shaderRGBA[1]
    } else {
        color = UInt32(bitPattern: CGDEBUG_SaberColor(Int32(bitPattern: color)))
        re!.shaderRGBA[0] = UInt8(truncatingIfNeeded: color & 0xff)
        color >>= 8
        re!.shaderRGBA[1] = UInt8(truncatingIfNeeded: color & 0xff)
        color >>= 8
        re!.shaderRGBA[2] = UInt8(truncatingIfNeeded: color & 0xff)
        //		color >>= 8;
        //		re->shaderRGBA[3] = color & 0xff;
        re!.shaderRGBA[3] = 0xff
    }

    le!.color[3] = 1.0

    //re->renderfx |= RF_DEPTHHACK;
}

/**
```
==================
CG_ThrowChunk
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:211
func CG_ThrowChunk(_ origin: JKAShared.vec3_t, _ velocity: JKAShared.vec3_t, _ hModel: JKAShared.qhandle_t, _ optionalSound: Int32, _ startalpha: Int32) {
    var le: LocalEntity?
    var re: RefEntity?

    le = CG_AllocLocalEntity()
    re = le!.refEntity

    le!.leType = LE_FRAGMENT
    le!.startTime = cg.time
    // The SDK also declares `random`, so the call names the bg module.
    le!.endTime = Int32(le!.startTime + 5000 + JKAMP_BG.random() * 3000)

    re!.origin = origin
    AxisCopy(axisDefault, re!.axis)
    re!.hModel = hModel

    le!.pos.trType = TR_GRAVITY
    le!.angles.trType = TR_GRAVITY
    le!.pos.trBase = origin
    le!.pos.trDelta = velocity
    le!.angles.trBase = vec3_t(20, 20, 20)
    le!.angles.trDelta = velocity
    le!.pos.trTime = cg.time
    le!.angles.trTime = cg.time

    le!.leFlags = LEF_TUMBLE

    le!.angles.trBase[YAW] = 180

    le!.bounceFactor = 0.3
    le!.bounceSound = optionalSound

    le!.forceAlpha = startalpha
}

/// Source: oracle/codemp/cgame/cg_effects.c:261
private func CG_DoGlassQuad(_ p: [JKAShared.vec3_t], _ uv: inout [JKAShared.vec2_t], _ stick: Bool, _ time: Int32, _ dmgDir: JKAShared.vec3_t) {
    var bounce: Float = 0
    var rotDelta = vec3_t()
    var vel = vec3_t()
    var accel = vec3_t()
    var rgb1 = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    AddpolyArgStruct.scratch { apArgs in
        var i: Int32 = 0
        var i_2: Int32 = 0

        vel = vec3_t(Float(crandom() * 12), Float(crandom() * 12), -1)

        if !stick {
            // We aren't a motion delayed chunk, so let us move quickly
            _VectorMA(vel, 0.3, dmgDir, &vel)
        }

        // Set up acceleration due to gravity, 800 is standard QuakeIII gravity, so let's use something close
        // The SDK also declares `random`, so the call names the bg module.
        accel = vec3_t(0.0, 0.0, -(600.0 + JKAMP_BG.random() * 100.0))

        // We are using an additive shader, so let's set the RGB low so we look more like transparent glass
        //	VectorSet( rgb1, 0.1f, 0.1f, 0.1f );
        rgb1 = vec3_t(1.0, 1.0, 1.0)

        // Being glass, we don't want to bounce much
        // The SDK also declares `random`, so the call names the bg module.
        bounce = JKAMP_BG.random() * 0.2 + 0.15

        // Set up our random rotate, we only do PITCH and YAW, not ROLL.  This is something like degrees per second
        rotDelta = vec3_t(Float(crandom() * 40.0), Float(crandom() * 40.0), 0.0)

        //In an ideal world, this might actually work.
        /*
        CPoly *pol = FX_AddPoly(p, uv, 4,			// verts, ST, vertCount
        vel, accel,				// motion
        0.15f, 0.0f, 85.0f,		// alpha start, alpha end, alpha parm ( begin alpha fade when 85% of life is complete )
        rgb1, rgb1, 0.0f,		// rgb start, rgb end, rgb parm ( not used )
        rotDelta, bounce, time,	// rotation amount, bounce, and time to delay motion for ( zero if no delay );
        6000,					// life
        cgi_R_RegisterShader( "gfx/misc/test_crackle" ),
        FX_APPLY_PHYSICS | FX_ALPHA_NONLINEAR | FX_USE_ALPHA );

        if ( random() > 0.95f && pol )
        {
        pol->AddFlags( FX_IMPACT_RUNS_FX | FX_KILL_ON_IMPACT );
        pol->SetImpactFxID( theFxScheduler.RegisterEffect( "glass_impact" ));
        }
        */

        //rww - this is dirty.

        i = 0
        i_2 = 0

        while i < 4 {
            while i_2 < 3 {
                apArgs.p[i][i_2] = p[i][i_2]

                i_2 += 1
            }

            i_2 = 0
            i += 1
        }

        i = 0
        i_2 = 0

        while i < 4 {
            while i_2 < 2 {
                apArgs.ev[i][Int(i_2)] = uv[i][Int(i_2)]

                i_2 += 1
            }

            i_2 = 0
            i += 1
        }

        apArgs.numVerts = 4
        apArgs.vel = vel
        apArgs.accel = accel

        apArgs.alpha1 = 0.15
        apArgs.alpha2 = 0.0
        apArgs.alphaParm = 85.0

        apArgs.rgb1 = rgb1
        apArgs.rgb2 = rgb1

        apArgs.rgbParm = 0.0

        apArgs.rotationDelta = rotDelta

        apArgs.bounce = bounce
        apArgs.motionDelay = time
        apArgs.killTime = 6000
        apArgs.shader = cgs.media.glassShardShader
        apArgs.flags = (FX_APPLY_PHYSICS | FX_ALPHA_NONLINEAR | FX_USE_ALPHA)

        trap_FX_AddPoly(apArgs)
    }
}

/// Source: oracle/codemp/cgame/cg_effects.c:367
private func CG_CalcBiLerp(_ verts: [JKAShared.vec3_t], _ subVerts: inout [JKAShared.vec3_t], _ uv: inout [JKAShared.vec2_t]) {
    var temp = vec3_t()

    // Nasty crap
    subVerts[0] = verts[0] * (1.0 - uv[0][0])
    _VectorMA(subVerts[0], uv[0][0], verts[1], &subVerts[0])
    temp = subVerts[0] * (1.0 - uv[0][1])
    subVerts[0] = verts[3] * (1.0 - uv[0][0])
    _VectorMA(subVerts[0], uv[0][0], verts[2], &subVerts[0])
    _VectorMA(temp, uv[0][1], subVerts[0], &subVerts[0])

    subVerts[1] = verts[0] * (1.0 - uv[1][0])
    _VectorMA(subVerts[1], uv[1][0], verts[1], &subVerts[1])
    temp = subVerts[1] * (1.0 - uv[1][1])
    subVerts[1] = verts[3] * (1.0 - uv[1][0])
    _VectorMA(subVerts[1], uv[1][0], verts[2], &subVerts[1])
    _VectorMA(temp, uv[1][1], subVerts[1], &subVerts[1])

    subVerts[2] = verts[0] * (1.0 - uv[2][0])
    _VectorMA(subVerts[2], uv[2][0], verts[1], &subVerts[2])
    temp = subVerts[2] * (1.0 - uv[2][1])
    subVerts[2] = verts[3] * (1.0 - uv[2][0])
    _VectorMA(subVerts[2], uv[2][0], verts[2], &subVerts[2])
    _VectorMA(temp, uv[2][1], subVerts[2], &subVerts[2])

    subVerts[3] = verts[0] * (1.0 - uv[3][0])
    _VectorMA(subVerts[3], uv[3][0], verts[1], &subVerts[3])
    temp = subVerts[3] * (1.0 - uv[3][1])
    subVerts[3] = verts[3] * (1.0 - uv[3][0])
    _VectorMA(subVerts[3], uv[3][0], verts[2], &subVerts[3])
    _VectorMA(temp, uv[3][1], subVerts[3], &subVerts[3])
}

/// Source: oracle/codemp/cgame/cg_effects.c:404
private func CG_CalcHeightWidth(_ verts: [JKAShared.vec3_t], _ height: inout Float, _ width: inout Float) {
    var dir1 = vec3_t()
    var dir2 = vec3_t()
    var cross = vec3_t()

    dir1 = verts[3] - verts[0] // v
    dir2 = verts[1] - verts[0] // p-a
    CrossProduct(dir1, dir2, &cross)
    width = VectorNormalize(&cross) / VectorNormalize(&dir1) // v
    dir2 = verts[2] - verts[0] // p-a
    CrossProduct(dir1, dir2, &cross)
    width += VectorNormalize(&cross) / VectorNormalize(&dir1) // v
    width *= 0.5

    dir1 = verts[1] - verts[0] // v
    dir2 = verts[2] - verts[0] // p-a
    CrossProduct(dir1, dir2, &cross)
    height = VectorNormalize(&cross) / VectorNormalize(&dir1) // v
    dir2 = verts[3] - verts[0] // p-a
    CrossProduct(dir1, dir2, &cross)
    height += VectorNormalize(&cross) / VectorNormalize(&dir1) // v
    height *= 0.5
}

/// Source: oracle/codemp/cgame/cg_effects.c:430
func CG_InitGlass() {
    var i: Int32
    var t: Int32

    // Build a table first, so that we can do a more unpredictable crack scheme
    //	do it once, up front to save a bit of time.
    i = 0
    while i < 20 {
        t = 0
        while t < 20 {
            offX[t][i] = Float(crandom() * 0.03)
            offZ[i][t] = Float(crandom() * 0.03)
            t += 1
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_effects.c:446
func Vector2Set(_ a: inout JKAShared.vec2_t, _ b: Float, _ c: Float) {
    a[0] = b
    a[1] = c
}

/// Source: oracle/codemp/cgame/cg_effects.c:456
func CG_DoGlass(_ verts: [JKAShared.vec3_t], _ normal: JKAShared.vec3_t, _ dmgPt: JKAShared.vec3_t, _ dmgDir: JKAShared.vec3_t, _ dmgRadius: Float, _ maxShards: Int32) {
    var i: Int32
    var t: Int32
    var mxHeight: Int32
    var mxWidth: Int32
    var height: Float = 0
    var width: Float = 0
    var stepWidth: Float
    var stepHeight: Float
    var timeDecay: Float
    var x: Float
    var z: Float
    var xx: Float
    var zz: Float
    var dif: Float
    var time: Int32 = 0
    var glassShards: Int32 = 0
    var stick: Bool = true
    var subVerts = [vec3_t](repeating: vec3_t(), count: 4)
    var biPoints = [vec2_t](repeating: vec2_t(), count: 4)

    // To do a smarter tesselation, we should figure out the relative height and width of the brush face,
    //	then use this to pick a lod value from 1-3 in each axis.  This will give us 1-9 lod levels, which will
    //	hopefully be sufficient.
    CG_CalcHeightWidth(verts, &height, &width)

    trap_S_StartSound(dmgPt, -1, CHAN_AUTO, trap_S_RegisterSound("sound/effects/glassbreak1.wav"))

    // Pick "LOD" for height
    if height < 100 {
        stepHeight = 0.2
        mxHeight = 5
        timeDecay = TIME_DECAY_SLOW
    } else if height > 220 {
        stepHeight = 0.05
        mxHeight = 20
        timeDecay = TIME_DECAY_FAST
    } else {
        stepHeight = 0.1
        mxHeight = 10
        timeDecay = TIME_DECAY_MED
    }

    // Pick "LOD" for width
    /*
    if ( width < 100 )
    {
    stepWidth = 0.2f;
    mxWidth = 5;
    timeDecay = ( timeDecay + TIME_DECAY_SLOW ) * 0.5f;
    }
    else if ( width > 220 )
    {
    stepWidth = 0.05f;
    mxWidth = 20;
    timeDecay = ( timeDecay + TIME_DECAY_FAST ) * 0.5f;
    }
    else
    {
    stepWidth = 0.1f;
    mxWidth = 10;
    timeDecay = ( timeDecay + TIME_DECAY_MED ) * 0.5f;
    }
    */

    //Attempt to scale the glass directly to the size of the window

    stepWidth = Float((0.25 - (Double(width) * 0.0002))) //(width*0.0005));
    mxWidth = Int32(Double(width) * 0.2)
    timeDecay = (timeDecay + TIME_DECAY_FAST) * 0.5

    if stepWidth < 0.01 {
        stepWidth = 0.01
    }
    if mxWidth < 5 {
        mxWidth = 5
    }

    z = 0.0
    i = 0
    while z < 1.0 {
        x = 0.0
        t = 0
        while x < 1.0 {
            // This is nasty..
            if t > 0 && t < mxWidth {
                xx = x - offX[i][t]
            } else {
                xx = x
            }

            if i > 0 && i < mxHeight {
                zz = z - offZ[t][i]
            } else {
                zz = z
            }

            Vector2Set(&biPoints[0], xx, zz)

            if t + 1 > 0 && t + 1 < mxWidth {
                xx = x - offX[i][t + 1]
            } else {
                xx = x
            }

            if i > 0 && i < mxHeight {
                zz = z - offZ[t + 1][i]
            } else {
                zz = z
            }

            Vector2Set(&biPoints[1], xx + stepWidth, zz)

            if t + 1 > 0 && t + 1 < mxWidth {
                xx = x - offX[i + 1][t + 1]
            } else {
                xx = x
            }

            if i + 1 > 0 && i + 1 < mxHeight {
                zz = z - offZ[t + 1][i + 1]
            } else {
                zz = z
            }

            Vector2Set(&biPoints[2], xx + stepWidth, zz + stepHeight)

            if t > 0 && t < mxWidth {
                xx = x - offX[i + 1][t]
            } else {
                xx = x
            }

            if i + 1 > 0 && i + 1 < mxHeight {
                zz = z - offZ[t][i + 1]
            } else {
                zz = z
            }

            Vector2Set(&biPoints[3], xx, zz + stepHeight)

            CG_CalcBiLerp(verts, &subVerts, &biPoints)

            // The SDK also declares `random`, so the call names the bg module.
            dif = DistanceSquared(subVerts[0], dmgPt) * timeDecay - JKAMP_BG.random() * 32

            // If we decrease dif, we are increasing the impact area, making it more likely to blow out large holes
            dif -= dmgRadius * dmgRadius

            if dif > 1 {
                stick = true
                // The SDK also declares `random`, so the call names the bg module.
                time = Int32(dif + JKAMP_BG.random() * 200)
            } else {
                stick = false
                time = 0
            }

            CG_DoGlassQuad(subVerts, &biPoints, stick, time, dmgDir)
            glassShards += 1

            if maxShards != 0 && glassShards >= maxShards {
                return
            }
            x += stepWidth
            t += 1
        }
        z += stepHeight
        i += 1
    }
}

/**
```
==================
CG_GlassShatter
Break glass with fancy method
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:656
func CG_GlassShatter(_ entnum: Int32, _ dmgPt: JKAShared.vec3_t, _ dmgDir: JKAShared.vec3_t, _ dmgRadius: Float, _ maxShards: Int32) {
    var verts = [vec3_t](repeating: vec3_t(), count: 4)
    var normal = vec3_t()

    if cgs.inlineDrawModel[cg_entities[entnum].currentState.modelindex] != 0 {
        trap_R_GetBModelVerts(cgs.inlineDrawModel[cg_entities[entnum].currentState.modelindex], verts, &normal)
        CG_DoGlass(verts, normal, dmgPt, dmgDir, dmgRadius, maxShards)
    }
    //otherwise something awful has happened.
}

/**
```
==================
CG_GlassShatter_Old
Throws glass shards from within a given bounding box in the world
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:674
func CG_GlassShatter_Old(_ entnum: Int32, _ org: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t) {
    var velocity = vec3_t()
    var a = vec3_t()
    var shardorg = vec3_t()
    var dif = vec3_t()
    var difx = vec3_t()
    let windowmass: Float
    var shardsthrow: Float = 0
    var chunkname = CharBuf(256)

    trap_S_StartSound(org, entnum, CHAN_BODY, trap_S_RegisterSound("sound/effects/glassbreak1.wav"))

    a = maxs - mins

    windowmass = VectorLength(a) //should give us some idea of how big the chunk of glass is

    while shardsthrow < windowmass {
        velocity[0] = Float(crandom() * 150)
        velocity[1] = Float(crandom() * 150)
        velocity[2] = Float(150 + crandom() * 75)

        Com_sprintf(&chunkname, Int32((chunkname).count), "models/chunks/glass/glchunks_%i.md3", Q_irand(1, 6))
        shardorg = org

        dif[0] = (maxs[0] - mins[0]) / 2
        dif[1] = (maxs[1] - mins[1]) / 2
        dif[2] = (maxs[2] - mins[2]) / 2

        if dif[0] < 2 {
            dif[0] = 2
        }
        if dif[1] < 2 {
            dif[1] = 2
        }
        if dif[2] < 2 {
            dif[2] = 2
        }

        difx[0] = Float(Q_irand(1, Int32((Double(dif[0]) * 0.9) * 2)))
        difx[1] = Float(Q_irand(1, Int32((Double(dif[1]) * 0.9) * 2)))
        difx[2] = Float(Q_irand(1, Int32((Double(dif[2]) * 0.9) * 2)))

        if difx[0] > dif[0] {
            shardorg[0] += difx[0] - (dif[0])
        } else {
            shardorg[0] -= difx[0]
        }
        if difx[1] > dif[1] {
            shardorg[1] += difx[1] - (dif[1])
        } else {
            shardorg[1] -= difx[1]
        }
        if difx[2] > dif[2] {
            shardorg[2] += difx[2] - (dif[2])
        } else {
            shardorg[2] -= difx[2]
        }

        //CG_TestLine(org, shardorg, 5000, 0x0000ff, 3);

        CG_ThrowChunk(shardorg, velocity, trap_R_RegisterModel(String(chunkname)), 0, 254)

        shardsthrow += 10
    }
}

/// Source: oracle/codemp/cgame/cg_effects.c:771
func CG_CreateDebris(_ entnum: Int32, _ org: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ debrissound: Int32, _ debrismodel: Int32) {
    var velocity = vec3_t()
    var a = vec3_t()
    var shardorg = vec3_t()
    var dif = vec3_t()
    var difx = vec3_t()
    let windowmass: Float
    var shardsthrow: Float = 0
    let omodel: Int32 = debrismodel
    // Raven assigns his own `debrismodel` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var debrismodel = debrismodel

    if omodel == DEBRIS_SPECIALCASE_GLASS && dbModels_Glass[0] == 0 {
        //glass no longer exists, using it for metal.
        dbModels_Glass[0] = trap_R_RegisterModel("models/chunks/metal/metal1_1.md3")
        dbModels_Glass[1] = trap_R_RegisterModel("models/chunks/metal/metal1_2.md3")
        dbModels_Glass[2] = trap_R_RegisterModel("models/chunks/metal/metal1_3.md3")
        dbModels_Glass[3] = trap_R_RegisterModel("models/chunks/metal/metal1_4.md3")
        dbModels_Glass[4] = trap_R_RegisterModel("models/chunks/metal/metal2_1.md3")
        dbModels_Glass[5] = trap_R_RegisterModel("models/chunks/metal/metal2_2.md3")
        dbModels_Glass[6] = trap_R_RegisterModel("models/chunks/metal/metal2_3.md3")
        dbModels_Glass[7] = trap_R_RegisterModel("models/chunks/metal/metal2_4.md3")
    }
    if omodel == DEBRIS_SPECIALCASE_WOOD && dbModels_Wood[0] == 0 {
        dbModels_Wood[0] = trap_R_RegisterModel("models/chunks/crate/crate1_1.md3")
        dbModels_Wood[1] = trap_R_RegisterModel("models/chunks/crate/crate1_2.md3")
        dbModels_Wood[2] = trap_R_RegisterModel("models/chunks/crate/crate1_3.md3")
        dbModels_Wood[3] = trap_R_RegisterModel("models/chunks/crate/crate1_4.md3")
        dbModels_Wood[4] = trap_R_RegisterModel("models/chunks/crate/crate2_1.md3")
        dbModels_Wood[5] = trap_R_RegisterModel("models/chunks/crate/crate2_2.md3")
        dbModels_Wood[6] = trap_R_RegisterModel("models/chunks/crate/crate2_3.md3")
        dbModels_Wood[7] = trap_R_RegisterModel("models/chunks/crate/crate2_4.md3")
    }
    if omodel == DEBRIS_SPECIALCASE_CHUNKS && dbModels_Chunks[0] == 0 {
        dbModels_Chunks[0] = trap_R_RegisterModel("models/chunks/generic/chunks_1.md3")
        dbModels_Chunks[1] = trap_R_RegisterModel("models/chunks/generic/chunks_2.md3")
    }
    if omodel == DEBRIS_SPECIALCASE_ROCK && dbModels_Rocks[0] == 0 {
        dbModels_Rocks[0] = trap_R_RegisterModel("models/chunks/rock/rock1_1.md3")
        dbModels_Rocks[1] = trap_R_RegisterModel("models/chunks/rock/rock1_2.md3")
        dbModels_Rocks[2] = trap_R_RegisterModel("models/chunks/rock/rock1_3.md3")
        dbModels_Rocks[3] = trap_R_RegisterModel("models/chunks/rock/rock1_4.md3")
        /*
        dbModels_Rocks[4] = trap_R_RegisterModel("models/chunks/rock/rock2_1.md3");
        dbModels_Rocks[5] = trap_R_RegisterModel("models/chunks/rock/rock2_2.md3");
        dbModels_Rocks[6] = trap_R_RegisterModel("models/chunks/rock/rock2_3.md3");
        dbModels_Rocks[7] = trap_R_RegisterModel("models/chunks/rock/rock2_4.md3");
        dbModels_Rocks[8] = trap_R_RegisterModel("models/chunks/rock/rock3_1.md3");
        dbModels_Rocks[9] = trap_R_RegisterModel("models/chunks/rock/rock3_2.md3");
        dbModels_Rocks[10] = trap_R_RegisterModel("models/chunks/rock/rock3_3.md3");
        dbModels_Rocks[11] = trap_R_RegisterModel("models/chunks/rock/rock3_4.md3");
        */
    }

    a = maxs - mins

    windowmass = VectorLength(a) //should give us some idea of how big the chunk of glass is

    while shardsthrow < windowmass {
        velocity[0] = Float(crandom() * 150)
        velocity[1] = Float(crandom() * 150)
        velocity[2] = Float(150 + crandom() * 75)

        if omodel == DEBRIS_SPECIALCASE_GLASS {
            debrismodel = dbModels_Glass[Q_irand(0, NUM_DEBRIS_MODELS_GLASS - 1)]
        } else if omodel == DEBRIS_SPECIALCASE_WOOD {
            debrismodel = dbModels_Wood[Q_irand(0, NUM_DEBRIS_MODELS_WOOD - 1)]
        } else if omodel == DEBRIS_SPECIALCASE_CHUNKS {
            debrismodel = dbModels_Chunks[Q_irand(0, NUM_DEBRIS_MODELS_CHUNKS - 1)]
        } else if omodel == DEBRIS_SPECIALCASE_ROCK {
            debrismodel = dbModels_Rocks[Q_irand(0, NUM_DEBRIS_MODELS_ROCKS - 1)]
        }

        shardorg = org

        dif[0] = (maxs[0] - mins[0]) / 2
        dif[1] = (maxs[1] - mins[1]) / 2
        dif[2] = (maxs[2] - mins[2]) / 2

        if dif[0] < 2 {
            dif[0] = 2
        }
        if dif[1] < 2 {
            dif[1] = 2
        }
        if dif[2] < 2 {
            dif[2] = 2
        }

        difx[0] = Float(Q_irand(1, Int32((Double(dif[0]) * 0.9) * 2)))
        difx[1] = Float(Q_irand(1, Int32((Double(dif[1]) * 0.9) * 2)))
        difx[2] = Float(Q_irand(1, Int32((Double(dif[2]) * 0.9) * 2)))

        if difx[0] > dif[0] {
            shardorg[0] += difx[0] - (dif[0])
        } else {
            shardorg[0] -= difx[0]
        }
        if difx[1] > dif[1] {
            shardorg[1] += difx[1] - (dif[1])
        } else {
            shardorg[1] -= difx[1]
        }
        if difx[2] > dif[2] {
            shardorg[2] += difx[2] - (dif[2])
        } else {
            shardorg[2] -= difx[2]
        }

        //CG_TestLine(org, shardorg, 5000, 0x0000ff, 3);

        CG_ThrowChunk(shardorg, velocity, debrismodel, debrissound, 0)

        shardsthrow += 10
    }
}

/// Source: oracle/codemp/cgame/cg_effects.c:919
func CG_ExplosionEffects(_ origin: JKAShared.vec3_t, _ intensity: Float, _ radius: Int32, _ time: Int32) {
    //FIXME: When exactly is the vieworg calculated in relation to the rest of the frame?s

    var dir = vec3_t()
    let dist: Float
    let intensityScale: Float
    let realIntensity: Float

    dir = cg.refdef.vieworg - origin
    dist = VectorNormalize(&dir)

    //Use the dir to add kick to the explosion

    if dist > radius {
        return
    }

    intensityScale = 1 - (dist / Float(radius))
    realIntensity = intensity * intensityScale

    CGCam_Shake(realIntensity, time)
}

/// Source: oracle/codemp/cgame/cg_effects.c:949
func CG_MiscModelExplosion(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ size: Int32, _ chunkType: JKAMP.material_t) {
    var ct: Int32 = 13
    var r: Float
    var org = vec3_t()
    var mid = vec3_t()
    var dir = vec3_t()
    var effect: String? = nil
    var effect2: String? = nil
    let eID1: Int32
    var eID2: Int32 = 0
    var i: Int32

    mid = mins + maxs
    mid = mid * 0.5

    switch chunkType {
    case MAT_GLASS:
        effect = "chunks/glassbreak"
        ct = 5

    case MAT_GLASS_METAL:
        effect = "chunks/glassbreak"
        effect2 = "chunks/metalexplode"
        ct = 5

    case MAT_ELECTRICAL, MAT_ELEC_METAL:
        effect = "chunks/sparkexplode"
        ct = 5

    case MAT_METAL, MAT_METAL2, MAT_METAL3, MAT_CRATE1, MAT_CRATE2:
        effect = "chunks/metalexplode"
        ct = 2

    case MAT_GRATE1:
        effect = "chunks/grateexplode"
        ct = 8

    case MAT_ROPE:
        ct = 20
        effect = "chunks/ropebreak"

    case MAT_WHITE_METAL, //not sure what this crap is really supposed to be..
         MAT_DRK_STONE,
         MAT_LT_STONE,
         MAT_GREY_STONE,
         MAT_SNOWY_ROCK:
        switch size {
        case 2:
            effect = "chunks/rockbreaklg"

        default:
            effect = "chunks/rockbreakmed"
        }

    default:
        break
    }

    if effect == nil {
        return
    }

    ct += 7 * size

    // FIXME: real precache .. VERify that these need to be here...don't think they would because the effects should be registered in g_breakable
    //rww - No they don't.. indexed effects gameside get precached on load clientside, as server objects are setup before client asset load time.
    //However, we need to index them, so..
    eID1 = trap_FX_RegisterEffect(effect!)

    if effect2 != nil && !effect2!.isEmpty {
        // FIXME: real precache
        eID2 = trap_FX_RegisterEffect(effect2!)
    }

    // spawn chunk roughly in the bbox of the thing..
    i = 0
    while i < ct {
        var j: Int32
        j = 0
        while j < 3 {
            // The SDK also declares `random`, so the call names the bg module.
            r = JKAMP_BG.random() * 0.8 + 0.1
            org[j] = (r * mins[j] + (1 - r) * maxs[j])
            j += 1
        }

        // shoot effect away from center
        dir = org - mid
        VectorNormalize(&dir)

        // The SDK also declares `rand`, so the call names the bg module.
        if effect2 != nil && !effect2!.isEmpty && (JKAMP_BG.rand() & 1) != 0 {
            trap_FX_PlayEffectID(eID2, org, dir, -1, -1)
        } else {
            trap_FX_PlayEffectID(eID1, org, dir, -1, -1)
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_effects.c:1061
func CG_Chunks(_ owner: Int32, _ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ speed: Float, _ numChunks: Int32, _ chunkType: JKAMP.material_t, _ customChunk: Int32, _ baseScale: Float) {
    var le: LocalEntity?
    var re: RefEntity?
    var dir = vec3_t()
    var i: Int32
    var j: Int32
    var k: Int32
    var chunkModel: Int32 = 0
    var bounce: leBounceSoundType_t = LEBS_NONE
    var r: Float
    var speedMod: Float = 1.0
    var chunk: Bool = false
    // Raven assigns his own `baseScale` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var baseScale = baseScale

    if chunkType == MAT_NONE {
        // Well, we should do nothing
        return
    }

    // Set up our chunk sound info...breaking sounds are done here so they are done once on breaking..some return instantly because the chunks are done with effects instead of models
    switch chunkType {
    case MAT_GLASS:
        trap_S_StartSound(nil, owner, CHAN_BODY, cgs.media.glassChunkSound)
        return

    case MAT_GRATE1:
        trap_S_StartSound(nil, owner, CHAN_BODY, cgs.media.grateSound)
        return

    case MAT_ELECTRICAL: // (sparks)
        trap_S_StartSound(nil, owner, CHAN_BODY, trap_S_RegisterSound(va("sound/ambience/spark%d.wav", Q_irand(1, 6))))
        return

    case MAT_DRK_STONE,
         MAT_LT_STONE,
         MAT_GREY_STONE,
         MAT_WHITE_METAL, // not quite sure what this stuff is supposed to be...it's for Stu
         MAT_SNOWY_ROCK:
        trap_S_StartSound(nil, owner, CHAN_BODY, cgs.media.rockBreakSound)
        bounce = LEBS_ROCK
        speedMod = 0.5 // rock blows up less

    case MAT_GLASS_METAL:
        trap_S_StartSound(nil, owner, CHAN_BODY, cgs.media.glassChunkSound) // FIXME: should probably have a custom sound
        bounce = LEBS_METAL

    case MAT_CRATE1, MAT_CRATE2:
        trap_S_StartSound(nil, owner, CHAN_BODY, cgs.media.crateBreakSound[Q_irand(0, 1)])

    case MAT_METAL,
         MAT_METAL2,
         MAT_METAL3,
         MAT_ELEC_METAL: // FIXME: maybe have its own sound?
        trap_S_StartSound(nil, owner, CHAN_BODY, cgs.media.chunkSound)
        bounce = LEBS_METAL
        speedMod = 0.8 // metal blows up a bit more

    case MAT_ROPE:
        //		trap_S_StartSound( NULL, owner, CHAN_BODY, cgi_S_RegisterSound( "" ));  FIXME:  needs a sound
        return

    default:
        break
    }

    if baseScale <= 0.0 {
        baseScale = 1.0
    }

    // Chunks
    i = 0
    while i < numChunks {
        if customChunk > 0 {
            // Try to use a custom chunk.
            if cgs.gameModels[customChunk] != 0 {
                chunk = true
                chunkModel = cgs.gameModels[customChunk]
            }
        }

        if !chunk {
            // No custom chunk.  Pick a random chunk type at run-time so we don't get the same chunks
            switch chunkType {
            case MAT_METAL2: //bluegrey
                chunkModel = cgs.media.chunkModels[CHUNK_METAL2][Q_irand(0, 3)]

            case MAT_GREY_STONE: //gray
                chunkModel = cgs.media.chunkModels[CHUNK_ROCK1][Q_irand(0, 3)]

            case MAT_LT_STONE: //tan
                chunkModel = cgs.media.chunkModels[CHUNK_ROCK2][Q_irand(0, 3)]

            case MAT_DRK_STONE: //brown
                chunkModel = cgs.media.chunkModels[CHUNK_ROCK3][Q_irand(0, 3)]

            case MAT_SNOWY_ROCK: //gray & brown
                if Q_irand(0, 1) != 0 {
                    chunkModel = cgs.media.chunkModels[CHUNK_ROCK1][Q_irand(0, 3)]
                } else {
                    chunkModel = cgs.media.chunkModels[CHUNK_ROCK3][Q_irand(0, 3)]
                }

            case MAT_WHITE_METAL:
                chunkModel = cgs.media.chunkModels[CHUNK_WHITE_METAL][Q_irand(0, 3)]

            case MAT_CRATE1: //yellow multi-colored crate chunks
                chunkModel = cgs.media.chunkModels[CHUNK_CRATE1][Q_irand(0, 3)]

            case MAT_CRATE2: //red multi-colored crate chunks
                chunkModel = cgs.media.chunkModels[CHUNK_CRATE2][Q_irand(0, 3)]

            case MAT_ELEC_METAL,
                 MAT_GLASS_METAL,
                 MAT_METAL: //grey
                chunkModel = cgs.media.chunkModels[CHUNK_METAL1][Q_irand(0, 3)]

            case MAT_METAL3:
                // The SDK also declares `rand`, so the call names the bg module.
                if (JKAMP_BG.rand() & 1) != 0 {
                    chunkModel = cgs.media.chunkModels[CHUNK_METAL1][Q_irand(0, 3)]
                } else {
                    chunkModel = cgs.media.chunkModels[CHUNK_METAL2][Q_irand(0, 3)]
                }

            default:
                break
            }
        }

        // It wouldn't look good to throw a bunch of RGB axis models...so make sure we have something to work with.
        if chunkModel != 0 {
            le = CG_AllocLocalEntity()
            re = le!.refEntity

            re!.hModel = chunkModel
            le!.leType = LE_FRAGMENT
            // The SDK also declares `random`, so the call names the bg module.
            le!.endTime = Int32(cg.time + 1300 + JKAMP_BG.random() * 900)

            // spawn chunk roughly in the bbox of the thing...bias towards center in case thing blowing up doesn't complete fill its bbox.
            j = 0
            while j < 3 {
                // The SDK also declares `random`, so the call names the bg module.
                r = JKAMP_BG.random() * 0.8 + 0.1
                re!.origin[j] = (r * mins[j] + (1 - r) * maxs[j])
                j += 1
            }
            le!.pos.trBase = re!.origin

            // Move out from center of thing, otherwise you can end up things moving across the brush in an undesirable direction.  Visually looks wrong
            dir = re!.origin - origin
            VectorNormalize(&dir)
            le!.pos.trDelta = dir * (flrand(speed * 0.5, speed * 1.25) * speedMod)

            // Angular Velocity
            // The SDK also declares `random`, so the call names the bg module.
            le!.angles.trBase = vec3_t(JKAMP_BG.random() * 360, JKAMP_BG.random() * 360, JKAMP_BG.random() * 360)

            le!.angles.trDelta[0] = Float(crandom())
            le!.angles.trDelta[1] = Float(crandom())
            le!.angles.trDelta[2] = 0 // don't do roll

            // The SDK also declares `random`, so the call names the bg module.
            le!.angles.trDelta = le!.angles.trDelta * (JKAMP_BG.random() * 600.0 + 200.0)

            le!.pos.trType = TR_GRAVITY
            le!.angles.trType = TR_LINEAR
            le!.angles.trTime = cg.time
            le!.pos.trTime = le!.angles.trTime
            // The SDK also declares `random`, so the call names the bg module.
            le!.bounceFactor = 0.2 + JKAMP_BG.random() * 0.2
            le!.leFlags |= LEF_TUMBLE
            //le->ownerGentNum = owner;
            le!.leBounceSoundType = bounce

            // Make sure that we have the desired start size set
            le!.radius = flrand(baseScale * 0.75, baseScale * 1.25)
            re!.nonNormalizedAxes = true
            AxisCopy(axisDefault, re!.axis)
            k = 0
            while k < 3 {
                re!.modelScale[k] = le!.radius
                k += 1
            }
            ScaleModelAxis(re!)
            /*
            for( k = 0; k < 3; k++ )
            {
            VectorScale( re->axis[k], le->radius, re->axis[k] );
            }
            */
        }
        i += 1
    }
}

/**
```
==================
CG_ScorePlum
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1261
func CG_ScorePlum(_ client: Int32, _ org: JKAShared.vec3_t, _ score: Int32) {
    var le: LocalEntity?
    var re: RefEntity?
    var angles = vec3_t()
    var lastPos = vec3_t()

    // only visualize for the client that scored
    if client != cg.predictedPlayerState.clientNum || cg_scorePlum.integer == 0 {
        return
    }

    le = CG_AllocLocalEntity()
    le!.leFlags = 0
    le!.leType = LE_SCOREPLUM
    le!.startTime = cg.time
    le!.endTime = cg.time + 4000
    le!.lifeRate = Float(1.0 / Double(le!.endTime - le!.startTime))


    le!.color[3] = 1.0
    le!.color[2] = le!.color[3]
    le!.color[1] = le!.color[2]
    le!.color[0] = le!.color[1]
    le!.radius = Float(score)

    le!.pos.trBase = org
    if org[2] >= lastPos[2] - 20 && org[2] <= lastPos[2] + 20 {
        le!.pos.trBase[2] -= 20
    }

    //CG_Printf( "Plum origin %i %i %i -- %i\n", (int)org[0], (int)org[1], (int)org[2], (int)Distance(org, lastPos));
    lastPos = org


    re = le!.refEntity

    re!.reType = RT_SPRITE
    re!.radius = 16

    angles = vec3_t()
    AnglesToAxis(angles, re!.axis)
}

/**
```
====================
CG_MakeExplosion
====================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1306
func CG_MakeExplosion(_ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ hModel: JKAShared.qhandle_t, _ numFrames: Int32, _ shader: JKAShared.qhandle_t, _ msec: Int32, _ isSprite: Bool, _ scale: Float, _ flags: Int32) -> LocalEntity? {
    var ang: Float = 0
    var ex: LocalEntity?
    let offset: Int32
    var tmpVec = vec3_t()
    var newOrigin = vec3_t()

    if msec <= 0 {
        CG_Error("CG_MakeExplosion: msec = %i", msec)
    }

    // skew the time a bit so they aren't all in sync
    // The SDK also declares `rand`, so the call names the bg module.
    offset = JKAMP_BG.rand() & 63

    ex = CG_AllocLocalEntity()
    if isSprite {
        ex!.leType = LE_SPRITE_EXPLOSION
        // The SDK also declares `rand`, so the call names the bg module.
        ex!.refEntity.rotation = Float(JKAMP_BG.rand() % 360)
        ex!.radius = scale
        tmpVec = dir * 16
        newOrigin = tmpVec + origin
    } else {
        ex!.leType = LE_EXPLOSION
        newOrigin = origin

        // set axis with random rotate when necessary
        if !((flags & LEF_NO_RANDOM_ROTATE) != 0) {
            // The SDK also declares `rand`, so the call names the bg module.
            ang = Float(JKAMP_BG.rand() % 360)
        }
        ex!.refEntity.axis[0] = dir
        // RotateAroundDirection takes an array, and the view holds `axis` as a Slots, so the call fills a copy that stores back.
        var axisCopy = [ex!.refEntity.axis[0], ex!.refEntity.axis[1], ex!.refEntity.axis[2]]
        RotateAroundDirection(&axisCopy, ang)
        ex!.refEntity.axis[0] = axisCopy[0]
        ex!.refEntity.axis[1] = axisCopy[1]
        ex!.refEntity.axis[2] = axisCopy[2]
    }

    ex!.startTime = cg.time - offset
    ex!.endTime = ex!.startTime + msec

    // bias the time so all shader effects start correctly
    ex!.refEntity.shaderTime = ex!.startTime / 1000.0

    ex!.refEntity.hModel = hModel
    ex!.refEntity.customShader = shader
    ex!.lifeRate = Float(numFrames) / msec
    ex!.leFlags = flags

    //Scale the explosion
    if scale != 1 {
        ex!.refEntity.nonNormalizedAxes = true

        ex!.refEntity.axis[0] = ex!.refEntity.axis[0] * scale
        ex!.refEntity.axis[1] = ex!.refEntity.axis[1] * scale
        ex!.refEntity.axis[2] = ex!.refEntity.axis[2] * scale
    }
    // set origin
    ex!.refEntity.origin = newOrigin
    ex!.refEntity.oldorigin = newOrigin

    ex!.color[2] = 1.0
    ex!.color[1] = ex!.color[2]
    ex!.color[0] = ex!.color[1]

    return ex
}

/// Source: oracle/codemp/cgame/cg_effects.c:1388
func CG_SurfaceExplosion(_ origin: JKAShared.vec3_t, _ normal: JKAShared.vec3_t, _ radius: Float, _ shake_speed: Float, _ smoke: Bool) {
    var le: LocalEntity?
    //FXTrail			*particle;
    var direction = vec3_t()
    var new_org = vec3_t()
    var velocity = vec3_t(0, 0, 0)
    var temp_org = vec3_t()
    var temp_vel = vec3_t()
    var scale: Float
    var dscale: Float
    var i: Int32
    let numSparks: Int32

    //Sparks
    // The SDK also declares `random`, so the call names the bg module.
    numSparks = Int32(16 + (JKAMP_BG.random() * 16.0))

    i = 0
    while i < numSparks {
        // The SDK also declares `random`, so the call names the bg module.
        scale = 0.25 + (JKAMP_BG.random() * 2.0)
        dscale = Float(-Double(scale) * 0.5)

        /*		particle = FX_AddTrail( origin,
        NULL,
        NULL,
        32.0f,
        -64.0f,
        scale,
        -scale,
        1.0f,
        0.0f,
        0.25f,
        4000.0f,
        cgs.media.sparkShader,
        rand() & FXF_BOUNCE);
        if ( particle == NULL )
        return;

        FXE_Spray( normal, 500, 150, 1.0f, 768 + (rand() & 255), (FXPrimitive *) particle );*/
        i += 1
    }

    //Smoke
    //Move this out a little from the impact surface
    _VectorMA(origin, 4, normal, &new_org)
    velocity = vec3_t(0.0, 0.0, 16.0)

    i = 0
    while i < 4 {
        // The SDK also declares `random`, so the call names the bg module.
        temp_org = vec3_t(Float(Double(new_org[0]) + (crandom() * 16.0)), Float(Double(new_org[1]) + (crandom() * 16.0)), new_org[2] + (JKAMP_BG.random() * 4.0))
        temp_vel = vec3_t(Float(Double(velocity[0]) + (crandom() * 8.0)), Float(Double(velocity[1]) + (crandom() * 8.0)), Float(Double(velocity[2]) + (crandom() * 8.0)))

        /*		FX_AddSprite(	temp_org,
        temp_vel,
        NULL,
        64.0f + (random() * 32.0f),
        16.0f,
        1.0f,
        0.0f,
        20.0f + (crandom() * 90.0f),
        0.5f,
        1500.0f,
        cgs.media.smokeShader, FXF_USE_ALPHA_CHAN );*/
        i += 1
    }

    //Core of the explosion

    //Orient the explosions to face the camera
    direction = cg.refdef.vieworg - origin
    VectorNormalize(&direction)

    //Tag the last one with a light
    // The SDK also declares `random`, so the call names the bg module.
    le = CG_MakeExplosion(origin, direction, cgs.media.explosionModel, 6, cgs.media.surfaceExplosionShader, 500, false, radius * 0.02 + (JKAMP_BG.random() * 0.3), 0)
    le!.light = 150
    le!.lightColor = vec3_t(0.9, 0.8, 0.5)

    i = 0
    while i < NUM_EXPLOSIONS - 1 {
        new_org = vec3_t(Float((Double(origin[0]) + (16 + (crandom() * 8)) * crandom())), Float((Double(origin[1]) + (16 + (crandom() * 8)) * crandom())), Float((Double(origin[2]) + (16 + (crandom() * 8)) * crandom())))
        // The SDK also declares `rand`, so the call names the bg module.
        le = CG_MakeExplosion(new_org, direction, cgs.media.explosionModel, 6, cgs.media.surfaceExplosionShader, 300 + (JKAMP_BG.rand() & 99), false, Float(Double(radius * 0.05) + (crandom() * 0.3)), 0)
        i += 1
    }

    //Shake the camera
    CG_ExplosionEffects(origin, shake_speed, 350, 750)

    // The level designers wanted to be able to turn the smoke spawners off.  The rationale is that they
    //	want to blow up catwalks and such that fall down...when that happens, it shouldn't really leave a mark
    //	and a smoke spewer at the explosion point...
    if smoke {
        _VectorMA(origin, -8, normal, &temp_org)
        //		FX_AddSpawner( temp_org, normal, NULL, NULL, 100, random()*25.0f, 5000.0f, (void *) CG_SmokeSpawn );

        //Impact mark
        //FIXME: Replace mark
        //CG_ImpactMark( cgs.media.burnMarkShader, origin, normal, random()*360, 1,1,1,1, qfalse, 8, qfalse );
    }
}

/**
```
=================
CG_Bleed

This is the spurt of blood when a character gets hit
=================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1489
func CG_Bleed(_ origin: JKAShared.vec3_t, _ entityNum: Int32) {
    var ex: LocalEntity?

    if cg_blood.integer == 0 {
        return
    }

    ex = CG_AllocLocalEntity()
    ex!.leType = LE_EXPLOSION

    ex!.startTime = cg.time
    ex!.endTime = ex!.startTime + 500

    ex!.refEntity.origin = origin
    ex!.refEntity.reType = RT_SPRITE
    // The SDK also declares `rand`, so the call names the bg module.
    ex!.refEntity.rotation = Float(JKAMP_BG.rand() % 360)
    ex!.refEntity.radius = 24

    ex!.refEntity.customShader = 0 //cgs.media.bloodExplosionShader;

    // don't show player's own blood in view
    if entityNum == cg.snap!.ps.clientNum {
        ex!.refEntity.renderfx |= RF_THIRD_PERSON
    }
}

/**
```
==================
CG_LaunchGib
==================
```
*/
/// Source: oracle/codemp/cgame/cg_effects.c:1522
func CG_LaunchGib(_ origin: JKAShared.vec3_t, _ velocity: JKAShared.vec3_t, _ hModel: JKAShared.qhandle_t) {
    var le: LocalEntity?
    var re: RefEntity?

    le = CG_AllocLocalEntity()
    re = le!.refEntity

    le!.leType = LE_FRAGMENT
    le!.startTime = cg.time
    // The SDK also declares `random`, so the call names the bg module.
    le!.endTime = Int32(le!.startTime + 5000 + JKAMP_BG.random() * 3000)

    re!.origin = origin
    AxisCopy(axisDefault, re!.axis)
    re!.hModel = hModel

    le!.pos.trType = TR_GRAVITY
    le!.pos.trBase = origin
    le!.pos.trDelta = velocity
    le!.pos.trTime = cg.time

    le!.bounceFactor = 0.6

    le!.leBounceSoundType = LEBS_BLOOD
    le!.leMarkType = LEMT_BLOOD
}
