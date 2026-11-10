import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_localents.c:9
let MAX_LOCAL_ENTITIES = 512 as Int32

/// Source: oracle/codemp/cgame/cg_localents.c:10
var cg_localEntities: Slots<LocalEntity> { world.storage.cg_localEntities }

/// Source: oracle/codemp/cgame/cg_localents.c:11
var cg_activeLocalEntities: LocalEntity { world.storage.cg_activeLocalEntities }

/// Source: oracle/codemp/cgame/cg_localents.c:12
var cg_freeLocalEntities: LocalEntity? {
    get { world.variables.cg_freeLocalEntities }
    set { world.variables.cg_freeLocalEntities = newValue }
}

/// Source: oracle/codemp/cgame/cg_localents.c:637
let NUMBER_SIZE = 8 as Int32

/**
```
===================
CG_InitLocalEntities

This is called at startup and for tournement restarts
===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:21
func CG_InitLocalEntities() {
    var i: Int32

    cg_localEntities.zero()
    cg_activeLocalEntities.next = cg_activeLocalEntities
    cg_activeLocalEntities.prev = cg_activeLocalEntities
    cg_freeLocalEntities = cg_localEntities[0]
    i = 0
    while i < MAX_LOCAL_ENTITIES - 1 {
        cg_localEntities[i].next = cg_localEntities[i + 1]
        i += 1
    }
}

/**
```
==================
CG_FreeLocalEntity
==================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:39
func CG_FreeLocalEntity(_ le: LocalEntity) {
    if le.prev == nil {
        CG_Error("CG_FreeLocalEntity: not active")
    }

    // remove from the doubly linked active list
    le.prev!.next = le.next
    le.next!.prev = le.prev

    // the free list is only singly linked
    le.next = cg_freeLocalEntities
    cg_freeLocalEntities = le
}

/**
```
===================
CG_AllocLocalEntity

Will allways succeed, even if it requires freeing an old active entity
===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:60
func CG_AllocLocalEntity() -> LocalEntity? {
    var le: LocalEntity?

    if cg_freeLocalEntities == nil {
        // no free entities, so free the one at the end of the chain
        // remove the oldest active entity
        CG_FreeLocalEntity(cg_activeLocalEntities.prev!)
    }

    le = cg_freeLocalEntities
    cg_freeLocalEntities = cg_freeLocalEntities!.next

    le!.clear()

    // link into the active list
    le!.next = cg_activeLocalEntities.next
    le!.prev = cg_activeLocalEntities
    cg_activeLocalEntities.next!.prev = le
    cg_activeLocalEntities.next = le
    return le
}

/**
```
================
CG_BloodTrail

Leave expanding blood puffs behind gibs
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:101
func CG_BloodTrail(_ le: LocalEntity) {
    var t: Int32
    let t2: Int32
    let step: Int32
    var newOrigin = vec3_t()
    var blood: LocalEntity?

    step = 150
    t = step * ((cg.time - cg.frametime + step) / step)
    t2 = step * (cg.time / step)

    while t <= t2 {
        BG_EvaluateTrajectory(le.pos, t, &newOrigin)

        blood = CG_SmokePuff(newOrigin, vec3_origin, 20, 1, 1, 1, 1, 2000, t, 0, 0, 0)
        // use the optimized version
        blood!.leType = LE_FALL_SCALE_FADE
        // drop a total of 40 units over its lifetime
        blood!.pos.trDelta[2] = 40
        t += step
    }
}

/**
```
================
CG_FragmentBounceMark
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:136
func CG_FragmentBounceMark(_ le: LocalEntity, _ trace: JKAMP.Trace) {
    let radius: Int32

    if le.leMarkType == LEMT_BLOOD {
        // The SDK also declares `rand`, so the call names the bg module.
        radius = 16 + (JKAMP_BG.rand() & 31)
        //		CG_ImpactMark( cgs.media.bloodMarkShader, trace->endpos, trace->plane.normal, random()*360,
        //			1,1,1,1, qtrue, radius, qfalse );
    } else if le.leMarkType == LEMT_BURN {
        // The SDK also declares `rand`, so the call names the bg module.
        radius = 8 + (JKAMP_BG.rand() & 15)
        //		CG_ImpactMark( cgs.media.burnMarkShader, trace->endpos, trace->plane.normal, random()*360,
        //			1,1,1,1, qtrue, radius, qfalse );
    }


    // don't allow a fragment to make multiple marks, or they
    // pile up while settling
    le.leMarkType = LEMT_NONE
}

/**
```
================
CG_FragmentBounceSound
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:162
func CG_FragmentBounceSound(_ le: LocalEntity, _ trace: JKAMP.Trace) {
    // half the fragments will make a bounce sounds
    // The SDK also declares `rand`, so the call names the bg module.
    // The SDK also declares `rand`, so the call names the bg module.
    if (JKAMP_BG.rand() & 1) != 0 {
        var s: sfxHandle_t = 0

        switch le.leBounceSoundType {
        case LEBS_ROCK:
            s = cgs.media.rockBounceSound[Q_irand(0, 1)]

        case LEBS_METAL:
            s = cgs.media.metalBounceSound[Q_irand(0, 1)] // FIXME: make sure that this sound is registered properly...might still be rock bounce sound....

        default:
            return
        }

        if s != 0 {
            trap_S_StartSound(trace.endpos, ENTITYNUM_WORLD, CHAN_AUTO, s)
        }

        // bouncers only make the sound once...
        // FIXME: arbitrary...change if it bugs you
        le.leBounceSoundType = LEBS_NONE
    } else if (JKAMP_BG.rand() & 1) != 0 {
        // we may end up bouncing again, but each bounce reduces the chance of playing the sound again or they may make a lot of noise when they settle
        // FIXME: maybe just always do this??
        le.leBounceSoundType = LEBS_NONE
    }
}

/**
```
================
CG_ReflectVelocity
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:203
func CG_ReflectVelocity(_ le: LocalEntity, _ trace: JKAMP.Trace) {
    var velocity = vec3_t()
    let dot: Float
    let hitTime: Int32

    // reflect the velocity on the trace plane
    hitTime = Int32(cg.time - cg.frametime + cg.frametime * trace.fraction)
    BG_EvaluateTrajectoryDelta(le.pos, hitTime, &velocity)
    dot = _DotProduct(velocity, trace.plane.normal)
    _VectorMA(velocity, -2 * dot, trace.plane.normal, &le.pos.trDelta)

    le.pos.trDelta = le.pos.trDelta * le.bounceFactor

    le.pos.trBase = trace.endpos
    le.pos.trTime = cg.time

    // check for stop, making sure that even on low FPS systems it doesn't bobble
    if trace.allsolid != 0 || (trace.plane.normal[2] > 0 && (le.pos.trDelta[2] < 40 || le.pos.trDelta[2] < -cg.frametime * le.pos.trDelta[2])) {
        le.pos.trType = TR_STATIONARY
    } else {
    }
}

/**
```
================
CG_AddFragment
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:234
func CG_AddFragment(_ le: LocalEntity) {
    var newOrigin = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in

        if le.forceAlpha != 0 {
            le.refEntity.renderfx |= RF_FORCE_ENT_ALPHA
            le.refEntity.shaderRGBA[3] = UInt8(truncatingIfNeeded: le.forceAlpha)
        }

        if le.pos.trType == TR_STATIONARY {
            // sink into the ground if near the removal time
            var t: Int32 = 0
            var t_e: Float = 0

            t = le.endTime - cg.time
            if t < (SINK_TIME * 2) {
                le.refEntity.renderfx |= RF_FORCE_ENT_ALPHA
                t_e = Float((Float((le.endTime - cg.time)) / (SINK_TIME * 2)))
                t_e = Float(Int32(((t_e) * 255)))

                if t_e > 255 {
                    t_e = 255
                }
                if t_e < 1 {
                    t_e = 1
                }

                if le.refEntity.shaderRGBA[3] != 0 && t_e > Float(le.refEntity.shaderRGBA[3]) {
                    t_e = Float(le.refEntity.shaderRGBA[3])
                }

                le.refEntity.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(t_e))

                trap_R_AddRefEntityToScene(le.refEntity)
            } else {
                trap_R_AddRefEntityToScene(le.refEntity)
            }

            return true
        }

        // calculate new position
        BG_EvaluateTrajectory(le.pos, cg.time, &newOrigin)

        // trace a line from previous position to new position
        CG_Trace(trace, le.refEntity.origin, nil, nil, newOrigin, -1, CONTENTS_SOLID)
        if Double(trace.fraction) == 1.0 {
            // still in free fall
            le.refEntity.origin = newOrigin

            if (le.leFlags & LEF_TUMBLE) != 0 {
                var angles = vec3_t()

                BG_EvaluateTrajectory(le.angles, cg.time, &angles)
                AnglesToAxis(angles, le.refEntity.axis)
                ScaleModelAxis(le.refEntity)
            }

            trap_R_AddRefEntityToScene(le.refEntity)

            // add a blood trail
            if le.leBounceSoundType == LEBS_BLOOD {
                CG_BloodTrail(le)
            }

            return true
        }

        // if it is in a nodrop zone, remove it
        // this keeps gibs from waiting at the bottom of pits of death
        // and floating levels
        if (trap_CM_PointContents(trace.endpos, 0) & CONTENTS_NODROP) != 0 {
            CG_FreeLocalEntity(le)
            return true
        }

        if trace.startsolid == 0 {
            // leave a mark
            CG_FragmentBounceMark(le, trace)

            // do a bouncy sound
            CG_FragmentBounceSound(le, trace)

            if le.bounceSound != 0 {
                //specified bounce sound (debris)
                trap_S_StartSound(le.pos.trBase, ENTITYNUM_WORLD, CHAN_AUTO, le.bounceSound)
            }

            // reflect the velocity on the trace plane
            CG_ReflectVelocity(le, trace)

            trap_R_AddRefEntityToScene(le.refEntity)
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
====================
CG_AddFadeRGB
====================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:348
func CG_AddFadeRGB(_ le: LocalEntity) {
    var re: RefEntity?
    var c: Float

    re = le.refEntity

    c = (le.endTime - cg.time) * le.lifeRate
    c *= 0xff

    re!.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(le.color[0] * c))
    re!.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(le.color[1] * c))
    re!.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(le.color[2] * c))
    re!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(le.color[3] * c))

    trap_R_AddRefEntityToScene(re!)
}

/// Source: oracle/codemp/cgame/cg_localents.c:365
private func CG_AddFadeScaleModel(_ le: LocalEntity) {
    let ent: RefEntity? = le.refEntity

    var frac: Float = (cg.time - le.startTime) / (Float((le.endTime - le.startTime)))

    frac *= frac * frac // yes, this is completely ridiculous...but it causes the shell to grow slowly then "explode" at the end

    ent!.nonNormalizedAxes = true

    AxisCopy(axisDefault, ent!.axis)

    ent!.axis[0] = ent!.axis[0] * (le.radius * frac)
    ent!.axis[1] = ent!.axis[1] * (le.radius * frac)
    ent!.axis[2] = ent!.axis[2] * (le.radius * 0.5 * frac)

    frac = 1.0 - frac

    ent!.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(le.color[0] * frac))
    ent!.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(le.color[1] * frac))
    ent!.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(le.color[2] * frac))
    ent!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(le.color[3] * frac))

    // add the entity
    trap_R_AddRefEntityToScene(ent!)
}

/**
```
==================
CG_AddMoveScaleFade
==================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:397
private func CG_AddMoveScaleFade(_ le: LocalEntity) {
    var re: RefEntity?
    let c: Float
    var delta = vec3_t()
    let len: Float

    re = le.refEntity

    if le.fadeInTime > le.startTime && cg.time < le.fadeInTime {
        // fade / grow time
        c = Float(1.0 - Double(Float((le.fadeInTime - cg.time)) / (le.fadeInTime - le.startTime)))
    } else {
        // fade / grow time
        c = (le.endTime - cg.time) * le.lifeRate
    }

    re!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(0xff * c * le.color[3]))

    if !((le.leFlags & LEF_PUFF_DONT_SCALE) != 0) {
        re!.radius = Float(Double(le.radius) * (1.0 - Double(c)) + 8)
    }

    BG_EvaluateTrajectory(le.pos, cg.time, &re!.origin)

    // if the view would be "inside" the sprite, kill the sprite
    // so it doesn't add too much overdraw
    delta = re!.origin - cg.refdef.vieworg
    len = VectorLength(delta)
    if len < le.radius {
        CG_FreeLocalEntity(le)
        return
    }

    trap_R_AddRefEntityToScene(re!)
}

/**
```
==================
CG_AddPuff
==================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:439
private func CG_AddPuff(_ le: LocalEntity) {
    var re: RefEntity?
    let c: Float
    var delta = vec3_t()
    let len: Float

    re = le.refEntity

    // fade / grow time
    c = (le.endTime - cg.time) / Float((le.endTime - le.startTime))

    re!.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(le.color[0] * c))
    re!.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(le.color[1] * c))
    re!.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(le.color[2] * c))

    if !((le.leFlags & LEF_PUFF_DONT_SCALE) != 0) {
        re!.radius = Float(Double(le.radius) * (1.0 - Double(c)) + 8)
    }

    BG_EvaluateTrajectory(le.pos, cg.time, &re!.origin)

    // if the view would be "inside" the sprite, kill the sprite
    // so it doesn't add too much overdraw
    delta = re!.origin - cg.refdef.vieworg
    len = VectorLength(delta)
    if len < le.radius {
        CG_FreeLocalEntity(le)
        return
    }

    trap_R_AddRefEntityToScene(re!)
}

/**
```
===================
CG_AddScaleFade

For rocket smokes that hang in place, fade out, and are
removed if the view passes through them.
There are often many of these, so it needs to be simple.
===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:481
private func CG_AddScaleFade(_ le: LocalEntity) {
    var re: RefEntity?
    let c: Float
    var delta = vec3_t()
    let len: Float

    re = le.refEntity

    // fade / grow time
    c = (le.endTime - cg.time) * le.lifeRate

    re!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(0xff * c * le.color[3]))
    re!.radius = Float(Double(le.radius) * (1.0 - Double(c)) + 8)

    // if the view would be "inside" the sprite, kill the sprite
    // so it doesn't add too much overdraw
    delta = re!.origin - cg.refdef.vieworg
    len = VectorLength(delta)
    if len < le.radius {
        CG_FreeLocalEntity(le)
        return
    }

    trap_R_AddRefEntityToScene(re!)
}

/**
```
=================
CG_AddFallScaleFade

This is just an optimized CG_AddMoveScaleFade
For blood mists that drift down, fade out, and are
removed if the view passes through them.
There are often 100+ of these, so it needs to be simple.
=================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:518
private func CG_AddFallScaleFade(_ le: LocalEntity) {
    var re: RefEntity?
    let c: Float
    var delta = vec3_t()
    let len: Float

    re = le.refEntity

    // fade time
    c = (le.endTime - cg.time) * le.lifeRate

    re!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(0xff * c * le.color[3]))

    re!.origin[2] = Float(Double(le.pos.trBase[2]) - (1.0 - Double(c)) * Double(le.pos.trDelta[2]))

    re!.radius = Float(Double(le.radius) * (1.0 - Double(c)) + 16)

    // if the view would be "inside" the sprite, kill the sprite
    // so it doesn't add too much overdraw
    delta = re!.origin - cg.refdef.vieworg
    len = VectorLength(delta)
    if len < le.radius {
        CG_FreeLocalEntity(le)
        return
    }

    trap_R_AddRefEntityToScene(re!)
}

/**
```
================
CG_AddExplosion
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:554
private func CG_AddExplosion(_ ex: LocalEntity) {
    var ent: RefEntity?

    ent = ex.refEntity

    // add the entity
    trap_R_AddRefEntityToScene(ent!)

    // add the dlight
    if ex.light != 0 {
        var light: Float

        light = Float((cg.time - ex.startTime)) / (ex.endTime - ex.startTime)
        if Double(light) < 0.5 {
            light = 1.0
        } else {
            light = Float(1.0 - (Double(light) - 0.5) * 2)
        }
        light = ex.light * light
        trap_R_AddLightToScene(ent!.origin, light, ex.lightColor[0], ex.lightColor[1], ex.lightColor[2])
    }
}

/**
```
================
CG_AddSpriteExplosion
================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:582
private func CG_AddSpriteExplosion(_ le: LocalEntity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    RefEntity.scratch { re in
        var c: Float = 0

        re.copy(from: le.refEntity)

        c = (le.endTime - cg.time) / Float((le.endTime - le.startTime))
        if c > 1 {
            c = 1.0 // can happen during connection problems
        }

        re.shaderRGBA[0] = 0xff
        re.shaderRGBA[1] = 0xff
        re.shaderRGBA[2] = 0xff
        re.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(Double(0xff * c) * 0.33))

        re.reType = RT_SPRITE
        re.radius = Float(42 * (1.0 - Double(c)) + 30)

        trap_R_AddRefEntityToScene(re)

        // add the dlight
        if le.light != 0 {
            var light: Float = 0

            light = Float((cg.time - le.startTime)) / (le.endTime - le.startTime)
            if Double(light) < 0.5 {
                light = 1.0
            } else {
                light = Float(1.0 - (Double(light) - 0.5) * 2)
            }
            light = le.light * light
            trap_R_AddLightToScene(re.origin, light, le.lightColor[0], le.lightColor[1], le.lightColor[2])
        }
    }
}

/**
```
===================
CG_AddRefEntity
===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:624
func CG_AddRefEntity(_ le: LocalEntity) {
    if le.endTime < cg.time {
        CG_FreeLocalEntity(le)
        return
    }
    trap_R_AddRefEntityToScene(le.refEntity)
}

/// Source: oracle/codemp/cgame/cg_localents.c:639
func CG_AddScorePlum(_ le: LocalEntity) {
    var re: RefEntity?
    var origin = vec3_t()
    var delta = vec3_t()
    var dir = vec3_t()
    var vec = vec3_t()
    var up = vec3_t(0, 0, 1)
    let c: Float
    let len: Float
    var i: Int32
    var score: Int32
    var digits: [Int32] = [Int32](repeating: 0, count: 10)
    var numdigits: Int32
    var negative: Int32

    re = le.refEntity

    c = (le.endTime - cg.time) * le.lifeRate

    score = Int32(le.radius)
    if score < 0 {
        re!.shaderRGBA[0] = 0xff
        re!.shaderRGBA[1] = 0x11
        re!.shaderRGBA[2] = 0x11
    } else {
        re!.shaderRGBA[0] = 0xff
        re!.shaderRGBA[1] = 0xff
        re!.shaderRGBA[2] = 0xff
        if score >= 50 {
            re!.shaderRGBA[1] = 0
        } else if score >= 20 {
            re!.shaderRGBA[1] = 0
            re!.shaderRGBA[0] = re!.shaderRGBA[1]
        } else if score >= 10 {
            re!.shaderRGBA[2] = 0
        } else if score >= 2 {
            re!.shaderRGBA[2] = 0
            re!.shaderRGBA[0] = re!.shaderRGBA[2]
        }
    }
    if Double(c) < 0.25 {
        re!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(0xff * 4 * c))
    } else {
        re!.shaderRGBA[3] = 0xff
    }

    re!.radius = Float(NUMBER_SIZE / 2)

    origin = le.pos.trBase
    origin[2] += 110 - c * 100

    dir = cg.refdef.vieworg - origin
    CrossProduct(dir, up, &vec)
    VectorNormalize(&vec)

    _VectorMA(origin, Float(-10 + 20 * sin(Double(c * 2 * JKAShared.M_PI))), vec, &origin)

    // if the view would be "inside" the sprite, kill the sprite
    // so it doesn't add too much overdraw
    delta = origin - cg.refdef.vieworg
    len = VectorLength(delta)
    if len < 20 {
        CG_FreeLocalEntity(le)
        return
    }

    negative = 0
    if score < 0 {
        negative = 1
        score = -score
    }

    numdigits = 0
    while !(numdigits != 0 && score == 0) {
        digits[numdigits] = score % 10
        score = score / 10
        numdigits += 1
    }

    if negative != 0 {
        digits[numdigits] = 10
        numdigits += 1
    }

    i = 0
    while i < numdigits {
        _VectorMA(origin, Float(((Float(numdigits) / 2) - i)) * NUMBER_SIZE, vec, &re!.origin)
        re!.customShader = cgs.media.numberShaders[digits[numdigits - 1 - i]]
        trap_R_AddRefEntityToScene(re!)
        i += 1
    }
}

/**
```
===================
CG_AddOLine

For forcefields/other rectangular things
===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:725
func CG_AddOLine(_ le: LocalEntity) {
    var re: RefEntity?
    var frac: Float
    let alpha: Float

    re = le.refEntity

    frac = (cg.time - le.startTime) / Float((le.endTime - le.startTime))
    if frac > 1 {
        frac = 1.0 // can happen during connection problems
    } else if frac < 0 {
        frac = 0.0
    }

    // Use the liferate to set the scale over time.
    re!.data.line.width = le.data.line.width + (le.data.line.dwidth * frac)
    if re!.data.line.width <= 0 {
        CG_FreeLocalEntity(le)
        return
    }

    // We will assume here that we want additive transparency effects.
    alpha = le.alpha + (le.dalpha * frac)
    re!.shaderRGBA[0] = UInt8(truncatingIfNeeded: Int32(0xff * alpha))
    re!.shaderRGBA[1] = UInt8(truncatingIfNeeded: Int32(0xff * alpha))
    re!.shaderRGBA[2] = UInt8(truncatingIfNeeded: Int32(0xff * alpha))
    re!.shaderRGBA[3] = UInt8(truncatingIfNeeded: Int32(0xff * alpha)) // Yes, we could apply c to this too, but fading the color is better for lines.

    re!.shaderTexCoord[0] = 1
    re!.shaderTexCoord[1] = 1

    re!.rotation = 90

    re!.reType = RT_ORIENTEDLINE

    trap_R_AddRefEntityToScene(re!)
}

/**
```
===================
CG_AddLine

for beams and the like.
===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:770
func CG_AddLine(_ le: LocalEntity) {
    var re: RefEntity?

    re = le.refEntity

    re!.reType = RT_LINE

    trap_R_AddRefEntityToScene(re!)
}

/**
```
===================
CG_AddLocalEntities

===================
```
*/
/// Source: oracle/codemp/cgame/cg_localents.c:789
func CG_AddLocalEntities() {
    var le: LocalEntity?
    var next: LocalEntity?

    // walk the list backwards, so any new local entities generated
    // (trails, marks, etc) will be present this frame
    le = cg_activeLocalEntities.prev
    while le != cg_activeLocalEntities {
        // grab next now, so if the local entity is freed we
        // still have it
        next = le!.prev

        if cg.time >= le!.endTime {
            CG_FreeLocalEntity(le!)
            le = next
            continue
        }
        switch le!.leType {
        case LE_MARK:
            break

        case LE_SPRITE_EXPLOSION:
            CG_AddSpriteExplosion(le!)

        case LE_EXPLOSION:
            CG_AddExplosion(le!)

        case LE_FADE_SCALE_MODEL:
            CG_AddFadeScaleModel(le!)

        case LE_FRAGMENT: // gibs and brass
            CG_AddFragment(le!)

        case LE_PUFF:
            CG_AddPuff(le!)

        case LE_MOVE_SCALE_FADE: // water bubbles
            CG_AddMoveScaleFade(le!)

        case LE_FADE_RGB: // teleporters, railtrails
            CG_AddFadeRGB(le!)

        case LE_FALL_SCALE_FADE: // gib blood trails
            CG_AddFallScaleFade(le!)

        case LE_SCALE_FADE: // rocket trails
            CG_AddScaleFade(le!)

        case LE_SCOREPLUM:
            CG_AddScorePlum(le!)

        case LE_OLINE:
            CG_AddOLine(le!)

        case LE_SHOWREFENTITY:
            CG_AddRefEntity(le!)

        case LE_LINE: // oriented lines for FX
            CG_AddLine(le!)

        default:
            CG_Error("Bad leType: %i", le!.leType)
        }
        le = next
    }
}
