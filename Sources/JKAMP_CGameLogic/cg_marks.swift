import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_marks.c:16
var cg_activeMarkPolys: MarkPoly { world.storage.cg_activeMarkPolys }

/// Source: oracle/codemp/cgame/cg_marks.c:17
var cg_freeMarkPolys: MarkPoly? {
    get { world.variables.cg_freeMarkPolys }
    set { world.variables.cg_freeMarkPolys = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:18
var cg_markPolys: Slots<MarkPoly> { world.storage.cg_markPolys }

/// Source: oracle/codemp/cgame/cg_marks.c:19
var markTotal: Int32 {
    get { world.variables.markTotal }
    set { world.variables.markTotal = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:107
private let MAX_MARK_FRAGMENTS = 128 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:108
private let MAX_MARK_POINTS = 384 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:218
let MARK_TOTAL_TIME = 10000 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:219
let MARK_FADE_TIME = 1000 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:296
let BLOODRED = 2 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:297
let EMISIVEFADE = 3 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:298
let GREY75 = 4 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:360
let MAX_SHADER_ANIMS = 32 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:361
let MAX_SHADER_ANIM_FRAMES = 64 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:363
/// Raven's data table, a hand property of `CGameWorld`.
var shaderAnimNames: [String?] { world.shaderAnimNames }

/// Source: oracle/codemp/cgame/cg_marks.c:367
let shaderAnims: [[JKAShared.qhandle_t]] = [[JKAShared.qhandle_t]](repeating: [JKAShared.qhandle_t](repeating: 0, count: 64), count: 32)

/// Source: oracle/codemp/cgame/cg_marks.c:368
/// Raven's data table, a hand property of `CGameWorld`.
var shaderAnimCounts: [Int32] { world.shaderAnimCounts }

/// Source: oracle/codemp/cgame/cg_marks.c:371
/// Raven's data table, a hand property of `CGameWorld`.
var shaderAnimSTRatio: [Float] { world.shaderAnimSTRatio }

/// Source: oracle/codemp/cgame/cg_marks.c:374
var numShaderAnims: Int32 {
    get { world.variables.numShaderAnims }
    set { world.variables.numShaderAnims = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:377
let PARTICLE_GRAVITY = 40 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:378
let MAX_PARTICLES = 1024 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:380
var active_particles: Cparticle? {
    get { world.variables.active_particles }
    set { world.variables.active_particles = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:380
var free_particles: Cparticle? {
    get { world.variables.free_particles }
    set { world.variables.free_particles = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:381
var particles: Slots<Cparticle> { world.storage.particles }

/// Source: oracle/codemp/cgame/cg_marks.c:382
/// Raven's initialized variable, a hand property of `CGameWorld`.
var cl_numparticles: Int32 { world.cl_numparticles }

/// Source: oracle/codemp/cgame/cg_marks.c:384
var initparticles: Bool {
    get { world.variables.initparticles }
    set { world.variables.initparticles = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:385
var pvforward: JKAShared.vec3_t {
    get { world.variables.pvforward }
    set { world.variables.pvforward = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:385
var pvright: JKAShared.vec3_t {
    get { world.variables.pvright }
    set { world.variables.pvright = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:385
var pvup: JKAShared.vec3_t {
    get { world.variables.pvup }
    set { world.variables.pvup = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:386
var rforward: JKAShared.vec3_t {
    get { world.variables.rforward }
    set { world.variables.rforward = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:386
var rright: JKAShared.vec3_t {
    get { world.variables.rright }
    set { world.variables.rright = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:386
var rup: JKAShared.vec3_t {
    get { world.variables.rup }
    set { world.variables.rup = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:388
var oldtime: Float {
    get { world.variables.oldtime }
    set { world.variables.oldtime = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1074
var roll: Float {
    get { world.variables.roll }
    set { world.variables.roll = newValue }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1904
let EXTRUDE_DIST = 0.5 as Double

/// Source: oracle/codemp/cgame/cg_marks.c:2008
let NORMALSIZE = 16 as Int32

/// Source: oracle/codemp/cgame/cg_marks.c:2009
let LARGESIZE = 32 as Int32

/**
```
===================
CG_InitMarkPolys

This is called at startup and for tournement restarts
===================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:28
func CG_InitMarkPolys() {
    var i: Int32

    cg_markPolys.zero()

    cg_activeMarkPolys.nextMark = cg_activeMarkPolys
    cg_activeMarkPolys.prevMark = cg_activeMarkPolys
    cg_freeMarkPolys = cg_markPolys[0]
    i = 0
    while i < MAX_MARK_POLYS - 1 {
        cg_markPolys[i].nextMark = cg_markPolys[i + 1]
        i += 1
    }
}

/**
```
==================
CG_FreeMarkPoly
==================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:47
func CG_FreeMarkPoly(_ le: MarkPoly) {
    if le.prevMark == nil {
        CG_Error("CG_FreeLocalEntity: not active")
    }

    // remove from the doubly linked active list
    le.prevMark!.nextMark = le.nextMark
    le.nextMark!.prevMark = le.prevMark

    // the free list is only singly linked
    le.nextMark = cg_freeMarkPolys
    cg_freeMarkPolys = le
}

/**
```
===================
CG_AllocMark

Will allways succeed, even if it requires freeing an old active mark
===================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:68
func CG_AllocMark() -> MarkPoly? {
    var le: MarkPoly?
    let time: Int32

    if cg_freeMarkPolys == nil {
        // no free entities, so free the one at the end of the chain
        // remove the oldest active entity
        time = cg_activeMarkPolys.prevMark!.time
        while cg_activeMarkPolys.prevMark != nil && time == cg_activeMarkPolys.prevMark!.time {
            CG_FreeMarkPoly(cg_activeMarkPolys.prevMark!)
        }
    }

    le = cg_freeMarkPolys
    cg_freeMarkPolys = cg_freeMarkPolys!.nextMark

    le!.clear()

    // link into the active list
    le!.nextMark = cg_activeMarkPolys.nextMark
    le!.prevMark = cg_activeMarkPolys
    cg_activeMarkPolys.nextMark!.prevMark = le
    cg_activeMarkPolys.nextMark = le
    return le
}

/// Source: oracle/codemp/cgame/cg_marks.c:110
func CG_ImpactMark(_ markShader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ orientation: Float, _ red: Float, _ green: Float, _ blue: Float, _ alpha: Float, _ alphaFade: Bool, _ radius: Float, _ temporary: Bool) {
    var axis = [vec3_t](repeating: vec3_t(), count: 3)
    var texCoordScale: Float = 0
    var originalPoints = [vec3_t](repeating: vec3_t(), count: 4)
    var colors: [UInt8] = [UInt8](repeating: 0, count: 4)
    var i: Int32 = 0
    var j: Int32 = 0
    var numFragments: Int32 = 0
    var mfIndex: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MarkFragment.scratch(count: 128) { markFragments -> Bool in
        var markPoints = [vec3_t](repeating: vec3_t(), count: 384)
        var projection = vec3_t()


        if cg_addMarks.integer == 0 {
            return true
        } else if cg_addMarks.integer == 2 {
            trap_R_AddDecalToScene(markShader, origin, dir, orientation, red, green, blue, alpha, alphaFade, radius, temporary)
            return true
        }

        if radius <= 0 {
            CG_Error("CG_ImpactMark called with <= 0 radius")
        }

        //if ( markTotal >= MAX_MARK_POLYS ) {
        //	return;
        //}

        // create the texture axis
        VectorNormalize2(dir, &axis[0])
        PerpendicularVector(&axis[1], axis[0])
        RotatePointAroundVector(&axis[2], axis[0], axis[1], orientation)
        CrossProduct(axis[0], axis[2], &axis[1])

        texCoordScale = Float(0.5 * 1.0 / Double(radius))

        // create the full polygon
        i = 0
        while i < 3 {
            originalPoints[0][i] = origin[i] - radius * axis[1][i] - radius * axis[2][i]
            originalPoints[1][i] = origin[i] + radius * axis[1][i] - radius * axis[2][i]
            originalPoints[2][i] = origin[i] + radius * axis[1][i] + radius * axis[2][i]
            originalPoints[3][i] = origin[i] - radius * axis[1][i] + radius * axis[2][i]
            i += 1
        }

        // get the fragments
        projection = dir * -20
        numFragments = trap_CM_MarkFragments(4, originalPoints, projection, MAX_MARK_POINTS, &markPoints, MAX_MARK_FRAGMENTS, markFragments)

        colors[0] = UInt8(truncatingIfNeeded: Int32(red * 255))
        colors[1] = UInt8(truncatingIfNeeded: Int32(green * 255))
        colors[2] = UInt8(truncatingIfNeeded: Int32(blue * 255))
        colors[3] = UInt8(truncatingIfNeeded: Int32(alpha * 255))

        i = 0
        mfIndex = 0
        while i < numFragments {
            PolyVert.scratch(count: Int(MAX_VERTS_ON_POLY)) { verts in
                var vIndex: Int32 = 0
                var mark: MarkPoly?

                // we have an upper limit on the complexity of polygons
                // that we store persistantly
                if markFragments[mfIndex].numPoints > MAX_VERTS_ON_POLY {
                    markFragments[mfIndex].numPoints = MAX_VERTS_ON_POLY
                }
                j = 0
                vIndex = 0
                while j < markFragments[mfIndex].numPoints {
                    var delta = vec3_t()

                    verts[vIndex].xyz = markPoints[markFragments[mfIndex].firstPoint + j]

                    delta = verts[vIndex].xyz - origin
                    verts[vIndex].st[0] = Float(0.5 + Double(_DotProduct(delta, axis[1]) * texCoordScale))
                    verts[vIndex].st[1] = Float(0.5 + Double(_DotProduct(delta, axis[2]) * texCoordScale))
                    // Raven copies the four bytes of `colors` as one int.
                    verts[vIndex].modulate[0] = colors[0]
                    verts[vIndex].modulate[1] = colors[1]
                    verts[vIndex].modulate[2] = colors[2]
                    verts[vIndex].modulate[3] = colors[3]
                    j += 1
                    vIndex += 1
                }

                // if it is a temporary (shadow) mark, add it immediately and forget about it
                if temporary {
                    trap_R_AddPolyToScene(markShader, markFragments[mfIndex].numPoints, verts)
                    return
                }

                // otherwise save it persistantly
                mark = CG_AllocMark()
                mark!.time = cg.time
                mark!.alphaFade = alphaFade
                mark!.markShader = markShader
                mark!.poly.numVerts = markFragments[mfIndex].numPoints
                mark!.color[0] = red
                mark!.color[1] = green
                mark!.color[2] = blue
                mark!.color[3] = alpha
                var k: Int32 = 0
                while k < markFragments[mfIndex].numPoints {
                    mark!.verts[k].copy(from: verts[k])
                    k += 1
                }
                markTotal += 1
            }
            i += 1
            mfIndex += 1
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:221
func CG_AddMarks() {
    var j: Int32
    var mp: MarkPoly?
    var next: MarkPoly?
    var t: Int32
    var fade: Int32

    if cg_addMarks.integer == 0 {
        return
    }

    mp = cg_activeMarkPolys.nextMark
    while mp != cg_activeMarkPolys {
        // grab next now, so if the local entity is freed we
        // still have it
        next = mp!.nextMark

        // see if it is time to completely remove it
        if cg.time > mp!.time + MARK_TOTAL_TIME {
            CG_FreeMarkPoly(mp!)
            mp = next
            continue
        }

        // fade out the energy bursts
        //if ( mp->markShader == cgs.media.energyMarkShader ) {
        if 0 != 0 {
            fade = Int32(450 - 450 * (Double(cg.time - mp!.time) / 3000.0))
            if fade < 255 {
                if fade < 0 {
                    fade = 0
                }
                if mp!.verts[0].modulate[0] != 0 {
                    j = 0
                    while j < mp!.poly.numVerts {
                        mp!.verts[j].modulate[0] = UInt8(truncatingIfNeeded: Int32(mp!.color[0] * fade))
                        mp!.verts[j].modulate[1] = UInt8(truncatingIfNeeded: Int32(mp!.color[1] * fade))
                        mp!.verts[j].modulate[2] = UInt8(truncatingIfNeeded: Int32(mp!.color[2] * fade))
                        j += 1
                    }
                }
            }
        }

        // fade all marks out with time
        t = mp!.time + MARK_TOTAL_TIME - cg.time
        if t < MARK_FADE_TIME {
            fade = 255 * t / MARK_FADE_TIME
            if mp!.alphaFade {
                j = 0
                while j < mp!.poly.numVerts {
                    mp!.verts[j].modulate[3] = UInt8(truncatingIfNeeded: fade)
                    j += 1
                }
            } else {
                let f: Float = Float(t) / MARK_FADE_TIME
                j = 0
                while j < mp!.poly.numVerts {
                    mp!.verts[j].modulate[0] = UInt8(truncatingIfNeeded: Int32(mp!.color[0] * f))
                    mp!.verts[j].modulate[1] = UInt8(truncatingIfNeeded: Int32(mp!.color[1] * f))
                    mp!.verts[j].modulate[2] = UInt8(truncatingIfNeeded: Int32(mp!.color[2] * f))
                    j += 1
                }
            }
        } else {
            j = 0
            while j < mp!.poly.numVerts {
                mp!.verts[j].modulate[0] = UInt8(truncatingIfNeeded: Int32(mp!.color[0]))
                mp!.verts[j].modulate[1] = UInt8(truncatingIfNeeded: Int32(mp!.color[1]))
                mp!.verts[j].modulate[2] = UInt8(truncatingIfNeeded: Int32(mp!.color[2]))
                j += 1
            }
        }

        trap_R_AddPolyToScene(mp!.markShader, mp!.poly.numVerts, mp!.verts)
        mp = next
    }
}

/**
```
===============
CL_ClearParticles
===============
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:395
func CG_ClearParticles() {
    var i: Int32

    particles.zero()

    free_particles = particles[0]
    active_particles = nil

    i = 0
    while i < cl_numparticles {
        particles[i].next = particles[i + 1]
        particles[i].type = 0
        i += 1
    }
    particles[cl_numparticles - 1].next = nil

    oldtime = Float(cg.time)

    /*
    // Ridah, init the shaderAnims
    for (i=0; shaderAnimNames[i]; i++) {
    int j;

    for (j=0; j<shaderAnimCounts[i]; j++) {
    shaderAnims[i][j] = trap_R_RegisterShader( va("%s%i", shaderAnimNames[i], j+1) );
    }
    }
    numShaderAnims = i;
    */
    numShaderAnims = 0
    // done.

    initparticles = true
}

/**
```
=====================
CG_AddParticleToScene
=====================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:436
func CG_AddParticleToScene(_ p: Cparticle, _ org: JKAShared.vec3_t, _ alpha: Float) {
    var point = vec3_t()
    // Raven assigns his own `alpha` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var alpha = alpha
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = PolyVert.scratch(count: 4) { verts -> Bool in
        var width: Float = 0
        var height: Float = 0
        var time: Float = 0
        var time2: Float = 0
        var ratio: Float = 0
        var invratio: Float = 0
        var color = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = PolyVert.scratch(count: 3) { TRIverts -> Bool in
            var rright2 = vec3_t()
            var rup2 = vec3_t()

            if p.type == P_WEATHER || p.type == P_WEATHER_TURBULENT || p.type == P_WEATHER_FLURRY || p.type == P_BUBBLE || p.type == P_BUBBLE_TURBULENT {
                // create a front facing polygon

                if p.type != P_WEATHER_FLURRY {
                    if p.type == P_BUBBLE || p.type == P_BUBBLE_TURBULENT {
                        if org[2] > p.end {
                            p.time = Float(cg.time)
                            p.org = org // Ridah, fixes rare snow flakes that flicker on the ground

                            p.org[2] = Float((Double(p.start) + crandom() * 4))


                            if p.type == P_BUBBLE_TURBULENT {
                                p.vel[0] = Float(crandom() * 4)
                                p.vel[1] = Float(crandom() * 4)
                            }
                        }
                    } else {
                        if org[2] < p.end {
                            p.time = Float(cg.time)
                            p.org = org // Ridah, fixes rare snow flakes that flicker on the ground

                            while p.org[2] < p.end {
                                p.org[2] += (p.start - p.end)
                            }


                            if p.type == P_WEATHER_TURBULENT {
                                p.vel[0] = Float(crandom() * 16)
                                p.vel[1] = Float(crandom() * 16)
                            }
                        }
                    }


                    // Rafael snow pvs check
                    if !p.link {
                        return true
                    }

                    p.alpha = 1
                }

                // Ridah, had to do this or MAX_POLYS is being exceeded in village1.bsp
                if Distance(cg.snap!.ps.origin, org) > 1024 {
                    return true
                }
                // done.

                if p.type == P_BUBBLE || p.type == P_BUBBLE_TURBULENT {
                    _VectorMA(org, -p.height, pvup, &point)
                    _VectorMA(point, -p.width, pvright, &point)
                    verts[0].xyz = point
                    verts[0].st[0] = 0
                    verts[0].st[1] = 0
                    verts[0].modulate[0] = 255
                    verts[0].modulate[1] = 255
                    verts[0].modulate[2] = 255
                    verts[0].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))

                    _VectorMA(org, -p.height, pvup, &point)
                    _VectorMA(point, p.width, pvright, &point)
                    verts[1].xyz = point
                    verts[1].st[0] = 0
                    verts[1].st[1] = 1
                    verts[1].modulate[0] = 255
                    verts[1].modulate[1] = 255
                    verts[1].modulate[2] = 255
                    verts[1].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))

                    _VectorMA(org, p.height, pvup, &point)
                    _VectorMA(point, p.width, pvright, &point)
                    verts[2].xyz = point
                    verts[2].st[0] = 1
                    verts[2].st[1] = 1
                    verts[2].modulate[0] = 255
                    verts[2].modulate[1] = 255
                    verts[2].modulate[2] = 255
                    verts[2].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))

                    _VectorMA(org, p.height, pvup, &point)
                    _VectorMA(point, -p.width, pvright, &point)
                    verts[3].xyz = point
                    verts[3].st[0] = 1
                    verts[3].st[1] = 0
                    verts[3].modulate[0] = 255
                    verts[3].modulate[1] = 255
                    verts[3].modulate[2] = 255
                    verts[3].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))
                } else {
                    _VectorMA(org, -p.height, pvup, &point)
                    _VectorMA(point, -p.width, pvright, &point)
                    TRIverts[0].xyz = point
                    TRIverts[0].st[0] = 1
                    TRIverts[0].st[1] = 0
                    TRIverts[0].modulate[0] = 255
                    TRIverts[0].modulate[1] = 255
                    TRIverts[0].modulate[2] = 255
                    TRIverts[0].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))

                    _VectorMA(org, p.height, pvup, &point)
                    _VectorMA(point, -p.width, pvright, &point)
                    TRIverts[1].xyz = point
                    TRIverts[1].st[0] = 0
                    TRIverts[1].st[1] = 0
                    TRIverts[1].modulate[0] = 255
                    TRIverts[1].modulate[1] = 255
                    TRIverts[1].modulate[2] = 255
                    TRIverts[1].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))

                    _VectorMA(org, p.height, pvup, &point)
                    _VectorMA(point, p.width, pvright, &point)
                    TRIverts[2].xyz = point
                    TRIverts[2].st[0] = 0
                    TRIverts[2].st[1] = 1
                    TRIverts[2].modulate[0] = 255
                    TRIverts[2].modulate[1] = 255
                    TRIverts[2].modulate[2] = 255
                    TRIverts[2].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * p.alpha))
                }
            } else if p.type == P_SPRITE {
                var rr = vec3_t()
                var ru = vec3_t()
                var rotate_ang = vec3_t()

                color = vec3_t(1.0, 1.0, 0.5)
                time = cg.time - p.time
                time2 = p.endtime - p.time
                ratio = time / time2

                width = p.width + (ratio * (p.endwidth - p.width))
                height = p.height + (ratio * (p.endheight - p.height))

                if p.roll != 0 {
                    vectoangles(cg.refdef.viewaxis[0], &rotate_ang)
                    rotate_ang[ROLL] += p.roll
                    // Raven passes NULL for the `forward` output.
                    var scratchForward = vec3_t()
                    AngleVectors(rotate_ang, &scratchForward, &rr, &ru)
                }

                if p.roll != 0 {
                    _VectorMA(org, -height, ru, &point)
                    _VectorMA(point, -width, rr, &point)
                } else {
                    _VectorMA(org, -height, pvup, &point)
                    _VectorMA(point, -width, pvright, &point)
                }
                verts[0].xyz = point
                verts[0].st[0] = 0
                verts[0].st[1] = 0
                verts[0].modulate[0] = 255
                verts[0].modulate[1] = 255
                verts[0].modulate[2] = 255
                verts[0].modulate[3] = 255

                if p.roll != 0 {
                    _VectorMA(point, 2 * height, ru, &point)
                } else {
                    _VectorMA(point, 2 * height, pvup, &point)
                }
                verts[1].xyz = point
                verts[1].st[0] = 0
                verts[1].st[1] = 1
                verts[1].modulate[0] = 255
                verts[1].modulate[1] = 255
                verts[1].modulate[2] = 255
                verts[1].modulate[3] = 255

                if p.roll != 0 {
                    _VectorMA(point, 2 * width, rr, &point)
                } else {
                    _VectorMA(point, 2 * width, pvright, &point)
                }
                verts[2].xyz = point
                verts[2].st[0] = 1
                verts[2].st[1] = 1
                verts[2].modulate[0] = 255
                verts[2].modulate[1] = 255
                verts[2].modulate[2] = 255
                verts[2].modulate[3] = 255

                if p.roll != 0 {
                    _VectorMA(point, -2 * height, ru, &point)
                } else {
                    _VectorMA(point, -2 * height, pvup, &point)
                }
                verts[3].xyz = point
                verts[3].st[0] = 1
                verts[3].st[1] = 0
                verts[3].modulate[0] = 255
                verts[3].modulate[1] = 255
                verts[3].modulate[2] = 255
                verts[3].modulate[3] = 255
            } else if p.type == P_SMOKE || p.type == P_SMOKE_IMPACT {
                // create a front rotating facing polygon

                if p.type == P_SMOKE_IMPACT && Distance(cg.snap!.ps.origin, org) > 1024 {
                    return true
                }

                if p.color == BLOODRED {
                    color = vec3_t(0.22, 0.0, 0.0)
                } else if p.color == GREY75 {
                    var len: Float = 0
                    var greyit: Float = 0
                    var val: Float = 0
                    len = Distance(cg.snap!.ps.origin, org)
                    if len == 0 {
                        len = 1
                    }

                    val = 4096 / len
                    greyit = Float(0.25 * Double(val))
                    if Double(greyit) > 0.5 {
                        greyit = 0.5
                    }

                    color = vec3_t(greyit, greyit, greyit)
                } else {
                    color = vec3_t(1.0, 1.0, 1.0)
                }

                time = cg.time - p.time
                time2 = p.endtime - p.time
                ratio = time / time2

                if cg.time > p.startfade {
                    invratio = 1 - ((cg.time - p.startfade) / (p.endtime - p.startfade))

                    if p.color == EMISIVEFADE {
                        var fval: Float = 0
                        fval = (invratio * invratio)
                        if fval < 0 {
                            fval = 0
                        }
                        color = vec3_t(fval, fval, fval)
                    }
                    invratio *= p.alpha
                } else {
                    invratio = 1 * p.alpha
                }

                if invratio > 1 {
                    invratio = 1
                }

                width = p.width + (ratio * (p.endwidth - p.width))
                height = p.height + (ratio * (p.endheight - p.height))

                if p.type != P_SMOKE_IMPACT {
                    var temp = vec3_t()

                    vectoangles(rforward, &temp)
                    p.accumroll += p.roll
                    temp[ROLL] = Float(Double(temp[ROLL]) + (Double(p.accumroll) * 0.1))
                    // Raven passes NULL for the `forward` output.
                    var scratchForward2 = vec3_t()
                    AngleVectors(temp, &scratchForward2, &rright2, &rup2)
                } else {
                    rright2 = rright
                    rup2 = rup
                }

                if p.rotate {
                    _VectorMA(org, -height, rup2, &point)
                    _VectorMA(point, -width, rright2, &point)
                } else {
                    _VectorMA(org, -p.height, pvup, &point)
                    _VectorMA(point, -p.width, pvright, &point)
                }
                verts[0].xyz = point
                verts[0].st[0] = 0
                verts[0].st[1] = 0
                verts[0].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[0].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[0].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[0].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * invratio))

                if p.rotate {
                    _VectorMA(org, -height, rup2, &point)
                    _VectorMA(point, width, rright2, &point)
                } else {
                    _VectorMA(org, -p.height, pvup, &point)
                    _VectorMA(point, p.width, pvright, &point)
                }
                verts[1].xyz = point
                verts[1].st[0] = 0
                verts[1].st[1] = 1
                verts[1].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[1].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[1].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[1].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * invratio))

                if p.rotate {
                    _VectorMA(org, height, rup2, &point)
                    _VectorMA(point, width, rright2, &point)
                } else {
                    _VectorMA(org, p.height, pvup, &point)
                    _VectorMA(point, p.width, pvright, &point)
                }
                verts[2].xyz = point
                verts[2].st[0] = 1
                verts[2].st[1] = 1
                verts[2].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[2].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[2].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[2].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * invratio))

                if p.rotate {
                    _VectorMA(org, height, rup2, &point)
                    _VectorMA(point, -width, rright2, &point)
                } else {
                    _VectorMA(org, p.height, pvup, &point)
                    _VectorMA(point, -p.width, pvright, &point)
                }
                verts[3].xyz = point
                verts[3].st[0] = 1
                verts[3].st[1] = 0
                verts[3].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[3].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[3].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[3].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * invratio))
            } else if p.type == P_BLEED {
                var rr = vec3_t()
                var ru = vec3_t()
                var rotate_ang = vec3_t()
                var alpha: Float = 0

                alpha = p.alpha

                if p.roll != 0 {
                    vectoangles(cg.refdef.viewaxis[0], &rotate_ang)
                    rotate_ang[ROLL] += p.roll
                    // Raven passes NULL for the `forward` output.
                    var scratchForward3 = vec3_t()
                    AngleVectors(rotate_ang, &scratchForward3, &rr, &ru)
                } else {
                    ru = pvup
                    rr = pvright
                }

                _VectorMA(org, -p.height, ru, &point)
                _VectorMA(point, -p.width, rr, &point)
                verts[0].xyz = point
                verts[0].st[0] = 0
                verts[0].st[1] = 0
                verts[0].modulate[0] = 111
                verts[0].modulate[1] = 19
                verts[0].modulate[2] = 9
                verts[0].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * alpha))

                _VectorMA(org, -p.height, ru, &point)
                _VectorMA(point, p.width, rr, &point)
                verts[1].xyz = point
                verts[1].st[0] = 0
                verts[1].st[1] = 1
                verts[1].modulate[0] = 111
                verts[1].modulate[1] = 19
                verts[1].modulate[2] = 9
                verts[1].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * alpha))

                _VectorMA(org, p.height, ru, &point)
                _VectorMA(point, p.width, rr, &point)
                verts[2].xyz = point
                verts[2].st[0] = 1
                verts[2].st[1] = 1
                verts[2].modulate[0] = 111
                verts[2].modulate[1] = 19
                verts[2].modulate[2] = 9
                verts[2].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * alpha))

                _VectorMA(org, p.height, ru, &point)
                _VectorMA(point, -p.width, rr, &point)
                verts[3].xyz = point
                verts[3].st[0] = 1
                verts[3].st[1] = 0
                verts[3].modulate[0] = 111
                verts[3].modulate[1] = 19
                verts[3].modulate[2] = 9
                verts[3].modulate[3] = UInt8(truncatingIfNeeded: Int32(255 * alpha))
            } else if p.type == P_FLAT_SCALEUP {
                var width: Float = 0
                var height: Float = 0
                var sinR: Float = 0
                var cosR: Float = 0

                if p.color == BLOODRED {
                    color = vec3_t(1, 1, 1)
                } else {
                    color = vec3_t(0.5, 0.5, 0.5)
                }

                time = cg.time - p.time
                time2 = p.endtime - p.time
                ratio = time / time2

                width = p.width + (ratio * (p.endwidth - p.width))
                height = p.height + (ratio * (p.endheight - p.height))

                if width > p.endwidth {
                    width = p.endwidth
                }

                if height > p.endheight {
                    height = p.endheight
                }

                sinR = height * sin(DEG2RAD(Float(p.roll))) * sqrt(2.0)
                cosR = width * cos(DEG2RAD(Float(p.roll))) * sqrt(2.0)

                verts[0].xyz = org
                verts[0].xyz[0] -= sinR
                verts[0].xyz[1] -= cosR
                verts[0].st[0] = 0
                verts[0].st[1] = 0
                verts[0].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[0].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[0].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[0].modulate[3] = 255

                verts[1].xyz = org
                verts[1].xyz[0] -= cosR
                verts[1].xyz[1] += sinR
                verts[1].st[0] = 0
                verts[1].st[1] = 1
                verts[1].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[1].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[1].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[1].modulate[3] = 255

                verts[2].xyz = org
                verts[2].xyz[0] += sinR
                verts[2].xyz[1] += cosR
                verts[2].st[0] = 1
                verts[2].st[1] = 1
                verts[2].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[2].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[2].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[2].modulate[3] = 255

                verts[3].xyz = org
                verts[3].xyz[0] += cosR
                verts[3].xyz[1] -= sinR
                verts[3].st[0] = 1
                verts[3].st[1] = 0
                verts[3].modulate[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                verts[3].modulate[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                verts[3].modulate[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))
                verts[3].modulate[3] = 255
            } else if p.type == P_FLAT {
                verts[0].xyz = org
                verts[0].xyz[0] -= p.height
                verts[0].xyz[1] -= p.width
                verts[0].st[0] = 0
                verts[0].st[1] = 0
                verts[0].modulate[0] = 255
                verts[0].modulate[1] = 255
                verts[0].modulate[2] = 255
                verts[0].modulate[3] = 255

                verts[1].xyz = org
                verts[1].xyz[0] -= p.height
                verts[1].xyz[1] += p.width
                verts[1].st[0] = 0
                verts[1].st[1] = 1
                verts[1].modulate[0] = 255
                verts[1].modulate[1] = 255
                verts[1].modulate[2] = 255
                verts[1].modulate[3] = 255

                verts[2].xyz = org
                verts[2].xyz[0] += p.height
                verts[2].xyz[1] += p.width
                verts[2].st[0] = 1
                verts[2].st[1] = 1
                verts[2].modulate[0] = 255
                verts[2].modulate[1] = 255
                verts[2].modulate[2] = 255
                verts[2].modulate[3] = 255

                verts[3].xyz = org
                verts[3].xyz[0] += p.height
                verts[3].xyz[1] -= p.width
                verts[3].st[0] = 1
                verts[3].st[1] = 0
                verts[3].modulate[0] = 255
                verts[3].modulate[1] = 255
                verts[3].modulate[2] = 255
                verts[3].modulate[3] = 255
            } else if p.type == P_ANIM {
                // Ridah
                var rr = vec3_t()
                var ru = vec3_t()
                var rotate_ang = vec3_t()
                var i: Int32 = 0
                var j: Int32 = 0

                time = cg.time - p.time
                time2 = p.endtime - p.time
                ratio = time / time2
                if ratio >= 1.0 {
                    ratio = 0.9999
                }

                width = p.width + (ratio * (p.endwidth - p.width))
                height = p.height + (ratio * (p.endheight - p.height))

                // if we are "inside" this sprite, don't draw
                if Double(Distance(cg.snap!.ps.origin, org)) < Double(width) / 1.5 {
                    return true
                }

                i = p.shaderAnim
                j = Int32(floor(ratio * shaderAnimCounts[p.shaderAnim]))
                p.pshader = shaderAnims[i][j]

                if p.roll != 0 {
                    vectoangles(cg.refdef.viewaxis[0], &rotate_ang)
                    rotate_ang[ROLL] += p.roll
                    // Raven passes NULL for the `forward` output.
                    var scratchForward4 = vec3_t()
                    AngleVectors(rotate_ang, &scratchForward4, &rr, &ru)
                }

                if p.roll != 0 {
                    _VectorMA(org, -height, ru, &point)
                    _VectorMA(point, -width, rr, &point)
                } else {
                    _VectorMA(org, -height, pvup, &point)
                    _VectorMA(point, -width, pvright, &point)
                }
                verts[0].xyz = point
                verts[0].st[0] = 0
                verts[0].st[1] = 0
                verts[0].modulate[0] = 255
                verts[0].modulate[1] = 255
                verts[0].modulate[2] = 255
                verts[0].modulate[3] = 255

                if p.roll != 0 {
                    _VectorMA(point, 2 * height, ru, &point)
                } else {
                    _VectorMA(point, 2 * height, pvup, &point)
                }
                verts[1].xyz = point
                verts[1].st[0] = 0
                verts[1].st[1] = 1
                verts[1].modulate[0] = 255
                verts[1].modulate[1] = 255
                verts[1].modulate[2] = 255
                verts[1].modulate[3] = 255

                if p.roll != 0 {
                    _VectorMA(point, 2 * width, rr, &point)
                } else {
                    _VectorMA(point, 2 * width, pvright, &point)
                }
                verts[2].xyz = point
                verts[2].st[0] = 1
                verts[2].st[1] = 1
                verts[2].modulate[0] = 255
                verts[2].modulate[1] = 255
                verts[2].modulate[2] = 255
                verts[2].modulate[3] = 255

                if p.roll != 0 {
                    _VectorMA(point, -2 * height, ru, &point)
                } else {
                    _VectorMA(point, -2 * height, pvup, &point)
                }
                verts[3].xyz = point
                verts[3].st[0] = 1
                verts[3].st[1] = 0
                verts[3].modulate[0] = 255
                verts[3].modulate[1] = 255
                verts[3].modulate[2] = 255
                verts[3].modulate[3] = 255
            }
            // done.

            if p.pshader == 0 {
                // (SA) temp commented out for DM
                //		CG_Printf ("CG_AddParticleToScene type %d p->pshader == ZERO\n", p->type);
                return true
            }

            if p.type == P_WEATHER || p.type == P_WEATHER_TURBULENT || p.type == P_WEATHER_FLURRY {
                trap_R_AddPolyToScene(p.pshader, 3, TRIverts)
            } else {
                trap_R_AddPolyToScene(p.pshader, 4, verts)
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===============
CG_AddParticles
===============
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:1081
func CG_AddParticles() {
    var p: Cparticle?
    var next: Cparticle?
    var alpha: Float
    var time: Float
    var time2: Float
    var org = vec3_t()
    var color: Int32
    var active: Cparticle?
    var tail: Cparticle?
    var type: Int32
    var rotate_ang = vec3_t()

    if !initparticles {
        CG_ClearParticles()
    }

    pvforward = cg.refdef.viewaxis[0]
    pvright = cg.refdef.viewaxis[1]
    pvup = cg.refdef.viewaxis[2]

    vectoangles(cg.refdef.viewaxis[0], &rotate_ang)
    roll = Float(Double(roll) + (Double(cg.time - oldtime) * 0.1))
    rotate_ang[ROLL] = Float(Double(rotate_ang[ROLL]) + (Double(roll) * 0.9))
    AngleVectors(rotate_ang, &rforward, &rright, &rup)

    oldtime = Float(cg.time)

    active = nil
    tail = nil

    p = active_particles
    while p != nil {
        next = p!.next

        time = Float(Double(cg.time - p!.time) * 0.001)

        alpha = p!.alpha + time * p!.alphavel
        if alpha <= 0 {
            // faded out
            p!.next = free_particles
            free_particles = p
            p!.type = 0
            p!.color = 0
            p!.alpha = 0
            p = next
            continue
        }

        if p!.type == P_SMOKE || p!.type == P_ANIM || p!.type == P_BLEED || p!.type == P_SMOKE_IMPACT {
            if cg.time > p!.endtime {
                p!.next = free_particles
                free_particles = p
                p!.type = 0
                p!.color = 0
                p!.alpha = 0

                p = next
                continue
            }
        }

        if p!.type == P_WEATHER_FLURRY {
            if cg.time > p!.endtime {
                p!.next = free_particles
                free_particles = p
                p!.type = 0
                p!.color = 0
                p!.alpha = 0

                p = next
                continue
            }
        }


        if p!.type == P_FLAT_SCALEUP_FADE {
            if cg.time > p!.endtime {
                p!.next = free_particles
                free_particles = p
                p!.type = 0
                p!.color = 0
                p!.alpha = 0
                p = next
                continue
            }
        }

        if (p!.type == P_BAT || p!.type == P_SPRITE) && p!.endtime < 0 {
            // temporary sprite
            CG_AddParticleToScene(p!, p!.org, alpha)
            p!.next = free_particles
            free_particles = p
            p!.type = 0
            p!.color = 0
            p!.alpha = 0
            p = next
            continue
        }

        p!.next = nil
        if tail == nil {
            tail = p
            active = tail
        } else {
            tail!.next = p
            tail = p
        }

        if Double(alpha) > 1.0 {
            alpha = 1
        }

        color = p!.color

        time2 = time * time

        org[0] = p!.org[0] + p!.vel[0] * time + p!.accel[0] * time2
        org[1] = p!.org[1] + p!.vel[1] * time + p!.accel[1] * time2
        org[2] = p!.org[2] + p!.vel[2] * time + p!.accel[2] * time2

        type = p!.type

        CG_AddParticleToScene(p!, org, alpha)
        p = next
    }

    active_particles = active
}

/**
```
======================
CG_AddParticles
======================
```
*/
/// Source: oracle/codemp/cgame/cg_marks.c:1215
func CG_ParticleSnowFlurry(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    var p: Cparticle?
    let turb: Bool = true

    if pshader == 0 {
        CG_Printf("CG_ParticleSnowFlurry pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.color = 0
    p!.alpha = 0.90
    p!.alphavel = 0

    p!.start = cent.currentState.origin2[0]
    p!.end = cent.currentState.origin2[1]

    p!.endtime = Float(cg.time + cent.currentState.time)
    p!.startfade = Float(cg.time + cent.currentState.time2)

    p!.pshader = pshader

    // The SDK also declares `rand`, so the call names the bg module.
    if JKAMP_BG.rand() % 100 > 90 {
        p!.height = 32
        p!.width = 32
        p!.alpha = 0.10
    } else {
        p!.height = 1
        p!.width = 1
    }

    p!.vel[2] = -20

    p!.type = P_WEATHER_FLURRY

    if turb {
        p!.vel[2] = -10
    }

    p!.org = cent.currentState.origin

    p!.org[0] = p!.org[0]
    p!.org[1] = p!.org[1]
    p!.org[2] = p!.org[2]

    p!.vel[1] = 0
    p!.vel[0] = p!.vel[1]

    p!.accel[2] = 0
    p!.accel[1] = p!.accel[2]
    p!.accel[0] = p!.accel[1]

    p!.vel[0] = Float(Double(p!.vel[0]) + (Double(cent.currentState.angles[0] * 32) + (crandom() * 16)))
    p!.vel[1] = Float(Double(p!.vel[1]) + (Double(cent.currentState.angles[1] * 32) + (crandom() * 16)))
    p!.vel[2] += cent.currentState.angles[2]

    if turb {
        p!.accel[0] = Float(crandom() * 16)
        p!.accel[1] = Float(crandom() * 16)
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1283
func CG_ParticleSnow(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ origin2: JKAShared.vec3_t, _ turb: Int32, _ range: Float, _ snum: Int32) {
    var p: Cparticle?

    if pshader == 0 {
        CG_Printf("CG_ParticleSnow pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.color = 0
    p!.alpha = 0.40
    p!.alphavel = 0
    p!.start = origin[2]
    p!.end = origin2[2]
    p!.pshader = pshader
    p!.height = 1
    p!.width = 1

    p!.vel[2] = -50

    if turb != 0 {
        p!.type = P_WEATHER_TURBULENT
        p!.vel[2] = Float(-50 * 1.3)
    } else {
        p!.type = P_WEATHER
    }

    p!.org = origin

    p!.org[0] = Float(Double(p!.org[0]) + (crandom() * Double(range)))
    p!.org[1] = Float(Double(p!.org[1]) + (crandom() * Double(range)))
    p!.org[2] = Float(Double(p!.org[2]) + (crandom() * Double(p!.start - p!.end)))

    p!.vel[1] = 0
    p!.vel[0] = p!.vel[1]

    p!.accel[2] = 0
    p!.accel[1] = p!.accel[2]
    p!.accel[0] = p!.accel[1]

    if turb != 0 {
        p!.vel[0] = Float(crandom() * 16)
        p!.vel[1] = Float(crandom() * 16)
    }

    // Rafael snow pvs check
    p!.snum = snum
    p!.link = true
}

/// Source: oracle/codemp/cgame/cg_marks.c:1340
func CG_ParticleBubble(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ origin2: JKAShared.vec3_t, _ turb: Int32, _ range: Float, _ snum: Int32) {
    var p: Cparticle?
    let randsize: Float

    if pshader == 0 {
        CG_Printf("CG_ParticleSnow pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.color = 0
    p!.alpha = 0.40
    p!.alphavel = 0
    p!.start = origin[2]
    p!.end = origin2[2]
    p!.pshader = pshader

    randsize = Float(1 + (crandom() * 0.5))

    p!.height = randsize
    p!.width = randsize

    p!.vel[2] = Float(50 + (crandom() * 10))

    if turb != 0 {
        p!.type = P_BUBBLE_TURBULENT
        p!.vel[2] = Float(50 * 1.3)
    } else {
        p!.type = P_BUBBLE
    }

    p!.org = origin

    p!.org[0] = Float(Double(p!.org[0]) + (crandom() * Double(range)))
    p!.org[1] = Float(Double(p!.org[1]) + (crandom() * Double(range)))
    p!.org[2] = Float(Double(p!.org[2]) + (crandom() * Double(p!.start - p!.end)))

    p!.vel[1] = 0
    p!.vel[0] = p!.vel[1]

    p!.accel[2] = 0
    p!.accel[1] = p!.accel[2]
    p!.accel[0] = p!.accel[1]

    if turb != 0 {
        p!.vel[0] = Float(crandom() * 4)
        p!.vel[1] = Float(crandom() * 4)
    }

    // Rafael snow pvs check
    p!.snum = snum
    p!.link = true
}

/// Source: oracle/codemp/cgame/cg_marks.c:1401
func CG_ParticleSmoke(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    // using cent->density = enttime
    //		 cent->frame = startfade
    var p: Cparticle?

    if pshader == 0 {
        CG_Printf("CG_ParticleSmoke == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)

    p!.endtime = Float(cg.time + cent.currentState.time)
    p!.startfade = Float(cg.time + cent.currentState.time2)

    p!.color = 0
    p!.alpha = 1.0
    p!.alphavel = 0
    p!.start = cent.currentState.origin[2]
    p!.end = cent.currentState.origin2[2]
    p!.pshader = pshader
    p!.rotate = false
    p!.height = 8
    p!.width = 8
    p!.endheight = 32
    p!.endwidth = 32
    p!.type = P_SMOKE

    p!.org = cent.currentState.origin

    p!.vel[1] = 0
    p!.vel[0] = p!.vel[1]
    p!.accel[2] = 0
    p!.accel[1] = p!.accel[2]
    p!.accel[0] = p!.accel[1]

    p!.vel[2] = 5

    if cent.currentState.frame == 1 {
        p!.vel[2] *= -1
    }

    p!.roll = Int32(8 + (crandom() * 4))
}

/// Source: oracle/codemp/cgame/cg_marks.c:1449
func CG_ParticleBulletDebris(_ org: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ duration: Int32) {
    var p: Cparticle?

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)

    p!.endtime = Float(cg.time + duration)
    p!.startfade = Float(cg.time + duration / 2)

    p!.color = EMISIVEFADE
    p!.alpha = 1.0
    p!.alphavel = 0

    p!.height = 0.5
    p!.width = 0.5
    p!.endheight = 0.5
    p!.endwidth = 0.5

    p!.pshader = 0 //cgs.media.tracerShader;

    p!.type = P_SMOKE

    p!.org = org

    p!.vel[0] = vel[0]
    p!.vel[1] = vel[1]
    p!.vel[2] = vel[2]
    p!.accel[2] = 0
    p!.accel[1] = p!.accel[2]
    p!.accel[0] = p!.accel[1]

    p!.accel[2] = -60
    p!.vel[2] += -20
}

/// Source: oracle/codemp/cgame/cg_marks.c:1496
func CG_ParticleExplosion(_ animStr: String, _ origin: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ duration: Int32, _ sizeStart: Int32, _ sizeEnd: Int32) {
    // Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port CG_ParticleExplosion
    portMissing("CG_ParticleExplosion", source: "oracle/codemp/cgame/cg_marks.c:1496")
}

// Rafael Shrapnel
/// Source: oracle/codemp/cgame/cg_marks.c:1550
func CG_AddParticleShrapnel(_ le: LocalEntity) {
    return
}

/// Source: oracle/codemp/cgame/cg_marks.c:1556
func CG_NewParticleArea(_ num: Int32) -> Int32 {
    // const char *str;
    var str = TextCursor()
    var token: String
    let type: Int32
    var origin = vec3_t()
    var origin2 = vec3_t()
    var i: Int32
    var range: Float = 0
    let turb: Int32
    let numparticles: Int32
    let snum: Int32

    str = TextCursor(CharBuf(CG_ConfigString(num)))
    if str[0] == 0 {
        return (0)
    }

    // returns type 128 64 or 32
    token = COM_Parse(&str)
    type = atoi(token)

    if type == 1 {
        range = 128
    } else if type == 2 {
        range = 64
    } else if type == 3 {
        range = 32
    } else if type == 0 {
        range = 256
    } else if type == 4 {
        range = 8
    } else if type == 5 {
        range = 16
    } else if type == 6 {
        range = 32
    } else if type == 7 {
        range = 64
    }


    i = 0
    while i < 3 {
        token = COM_Parse(&str)
        origin[i] = Float(atof(token))
        i += 1
    }

    i = 0
    while i < 3 {
        token = COM_Parse(&str)
        origin2[i] = Float(atof(token))
        i += 1
    }

    token = COM_Parse(&str)
    numparticles = atoi(token)

    token = COM_Parse(&str)
    turb = atoi(token)

    token = COM_Parse(&str)
    snum = atoi(token)

    /*
    for (i=0; i<numparticles; i++)
    {
    if (type >= 4)
    CG_ParticleBubble (cgs.media.waterBubbleShader, origin, origin2, turb, range, snum);
    else
    CG_ParticleSnow (cgs.media.waterBubbleShader, origin, origin2, turb, range, snum);
    }
    */

    return (1)
}

/// Source: oracle/codemp/cgame/cg_marks.c:1629
func CG_SnowLink(_ cent: Centity, _ particleOn: Bool) {
    var p: Cparticle?
    var next: Cparticle?
    let id: Int32

    id = cent.currentState.frame

    p = active_particles
    while p != nil {
        next = p!.next

        if p!.type == P_WEATHER || p!.type == P_WEATHER_TURBULENT {
            if p!.snum == id {
                if particleOn {
                    p!.link = true
                } else {
                    p!.link = false
                }
            }
        }
        p = next
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1654
func CG_ParticleImpactSmokePuff(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t) {
    var p: Cparticle?

    if pshader == 0 {
        CG_Printf("CG_ParticleImpactSmokePuff pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.alpha = 0.25
    p!.alphavel = 0
    p!.roll = Int32(crandom() * 179)

    p!.pshader = pshader

    p!.endtime = Float(cg.time + 1000)
    p!.startfade = Float(cg.time + 100)

    // The SDK also declares `rand`, so the call names the bg module.
    p!.width = Float(JKAMP_BG.rand() % 4 + 8)
    // The SDK also declares `rand`, so the call names the bg module.
    p!.height = Float(JKAMP_BG.rand() % 4 + 8)

    p!.endheight = p!.height * 2
    p!.endwidth = p!.width * 2

    p!.endtime = Float(cg.time + 500)

    p!.type = P_SMOKE_IMPACT

    p!.org = origin
    p!.vel = vec3_t(0, 0, 20)
    p!.accel = vec3_t(0, 0, 20)

    p!.rotate = true
}

/// Source: oracle/codemp/cgame/cg_marks.c:1694
func CG_Particle_Bleed(_ pshader: JKAShared.qhandle_t, _ start: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ fleshEntityNum: Int32, _ duration: Int32) {
    var p: Cparticle?

    if pshader == 0 {
        CG_Printf("CG_Particle_Bleed pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.alpha = 1.0
    p!.alphavel = 0
    p!.roll = 0

    p!.pshader = pshader

    p!.endtime = Float(cg.time + duration)

    if fleshEntityNum != 0 {
        p!.startfade = Float(cg.time)
    } else {
        p!.startfade = Float(cg.time + 100)
    }

    p!.width = 4
    p!.height = 4

    // The SDK also declares `rand`, so the call names the bg module.
    p!.endheight = Float(4 + JKAMP_BG.rand() % 3)
    p!.endwidth = p!.endheight

    p!.type = P_SMOKE

    p!.org = start
    p!.vel[0] = 0
    p!.vel[1] = 0
    p!.vel[2] = -20
    p!.accel = vec3_t()

    p!.rotate = false

    // The SDK also declares `rand`, so the call names the bg module.
    p!.roll = JKAMP_BG.rand() % 179

    p!.color = BLOODRED
    p!.alpha = 0.75
}

/// Source: oracle/codemp/cgame/cg_marks.c:1744
func CG_Particle_OilParticle(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    var p: Cparticle?

    let time: Int32
    let time2: Int32
    let ratio: Float

    let duration: Float = 1500

    time = cg.time
    time2 = cg.time + cent.currentState.time

    ratio = Float(1) - (Float(time) / Float(time2))

    if pshader == 0 {
        CG_Printf("CG_Particle_OilParticle == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.alpha = 1.0
    p!.alphavel = 0
    p!.roll = 0

    p!.pshader = pshader

    p!.endtime = cg.time + duration

    p!.startfade = p!.endtime

    p!.width = 1
    p!.height = 3

    p!.endheight = 3
    p!.endwidth = 1

    p!.type = P_SMOKE

    p!.org = cent.currentState.origin

    p!.vel[0] = (cent.currentState.origin2[0] * (16 * ratio))
    p!.vel[1] = (cent.currentState.origin2[1] * (16 * ratio))
    p!.vel[2] = (cent.currentState.origin2[2])

    p!.snum = 1

    p!.accel = vec3_t()

    p!.accel[2] = -20

    p!.rotate = false

    // The SDK also declares `rand`, so the call names the bg module.
    p!.roll = JKAMP_BG.rand() % 179

    p!.alpha = 0.75
}

/// Source: oracle/codemp/cgame/cg_marks.c:1808
func CG_Particle_OilSlick(_ pshader: JKAShared.qhandle_t, _ cent: Centity) {
    var p: Cparticle?

    if pshader == 0 {
        CG_Printf("CG_Particle_OilSlick == ZERO!\n")
    }

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)

    if cent.currentState.angles2[2] != 0 {
        p!.endtime = cg.time + cent.currentState.angles2[2]
    } else {
        p!.endtime = Float(cg.time + 60000)
    }

    p!.startfade = p!.endtime

    p!.alpha = 1.0
    p!.alphavel = 0
    p!.roll = 0

    p!.pshader = pshader

    if cent.currentState.angles2[0] != 0 || cent.currentState.angles2[1] != 0 {
        p!.width = cent.currentState.angles2[0]
        p!.height = cent.currentState.angles2[0]

        p!.endheight = cent.currentState.angles2[1]
        p!.endwidth = cent.currentState.angles2[1]
    } else {
        p!.width = 8
        p!.height = 8

        p!.endheight = 16
        p!.endwidth = 16
    }

    p!.type = P_FLAT_SCALEUP

    p!.snum = 1

    p!.org = cent.currentState.origin

    p!.org[2] = Float(Double(p!.org[2]) + (0.55 + (crandom() * 0.5)))

    p!.vel[0] = 0
    p!.vel[1] = 0
    p!.vel[2] = 0
    p!.accel = vec3_t()

    p!.rotate = false

    // The SDK also declares `rand`, so the call names the bg module.
    p!.roll = JKAMP_BG.rand() % 179

    p!.alpha = 0.75
}

/// Source: oracle/codemp/cgame/cg_marks.c:1874
func CG_OilSlickRemove(_ cent: Centity) {
    var p: Cparticle?
    var next: Cparticle?
    let id: Int32

    id = 1

    if id == 0 {
        CG_Printf("CG_OilSlickRevove NULL id\n")
    }

    p = active_particles
    while p != nil {
        next = p!.next

        if p!.type == P_FLAT_SCALEUP {
            if p!.snum == id {
                p!.endtime = Float(cg.time + 100)
                p!.startfade = p!.endtime
                p!.type = P_FLAT_SCALEUP_FADE
            }
        }
        p = next
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1902
func ValidBloodPool(_ start: JKAShared.vec3_t) -> Bool {
    var angles = vec3_t()
    var right = vec3_t()
    var up = vec3_t()
    var this_pos = vec3_t()
    var x_pos = vec3_t()
    var center_pos = vec3_t()
    var end_pos = vec3_t()
    var x: Float = 0
    var y: Float = 0
    var fwidth: Float = 0
    var fheight: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var normal = vec3_t()

        fwidth = 16
        fheight = 16

        normal = vec3_t(0, 0, 1)

        vectoangles(normal, &angles)
        // Raven passes NULL for the `forward` output.
        var scratchForward = vec3_t()
        AngleVectors(angles, &scratchForward, &right, &up)

        _VectorMA(start, Float(EXTRUDE_DIST), normal, &center_pos)

        x = -fwidth / 2
        while x < fwidth {
            _VectorMA(center_pos, x, right, &x_pos)

            y = -fheight / 2
            while y < fheight {
                _VectorMA(x_pos, y, up, &this_pos)
                _VectorMA(this_pos, Float(-EXTRUDE_DIST * 2), normal, &end_pos)

                CG_Trace(trace, this_pos, nil, nil, end_pos, -1, CONTENTS_SOLID)


                if trace.entityNum != ENTITYNUM_WORLD {
                    return false
                }

                if !(trace.startsolid == 0 && trace.fraction < 1) {
                    return false
                }
                y += fheight
            }
            x += fwidth
        }

        return true
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:1948
func CG_BloodPool(_ le: LocalEntity, _ pshader: JKAShared.qhandle_t, _ tr: JKAMP.Trace) {
    var p: Cparticle?
    let legit: Bool
    var start = vec3_t()
    let rndSize: Float

    if pshader == 0 {
        CG_Printf("CG_BloodPool pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }

    start = tr.endpos
    legit = ValidBloodPool(start)

    if !legit {
        return
    }

    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)

    p!.endtime = Float(cg.time + 3000)
    p!.startfade = p!.endtime

    p!.alpha = 1.0
    p!.alphavel = 0
    p!.roll = 0

    p!.pshader = pshader

    // The SDK also declares `random`, so the call names the bg module.
    rndSize = Float(0.4 + Double(JKAMP_BG.random()) * 0.6)

    p!.width = 8 * rndSize
    p!.height = 8 * rndSize

    p!.endheight = 16 * rndSize
    p!.endwidth = 16 * rndSize

    p!.type = P_FLAT_SCALEUP

    p!.org = start

    p!.vel[0] = 0
    p!.vel[1] = 0
    p!.vel[2] = 0
    p!.accel = vec3_t()

    p!.rotate = false

    // The SDK also declares `rand`, so the call names the bg module.
    p!.roll = JKAMP_BG.rand() % 179

    p!.alpha = 0.75

    p!.color = BLOODRED
}

/// Source: oracle/codemp/cgame/cg_marks.c:2011
func CG_ParticleBloodCloud(_ cent: Centity, _ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t) {
    let length: Float
    var dist: Float
    let crittersize: Float
    var angles = vec3_t()
    var forward = vec3_t()
    var point = vec3_t()
    var p: Cparticle?
    var i: Int32

    dist = 0

    length = VectorLength(dir)
    vectoangles(dir, &angles)
    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(angles, &forward, &scratchRight, &scratchUp)

    crittersize = Float(LARGESIZE)

    if length != 0 {
        dist = length / crittersize
    }

    if dist < 1 {
        dist = 1
    }

    point = origin

    i = 0
    while i < dist {
        _VectorMA(point, crittersize, forward, &point)

        if free_particles == nil {
            return
        }

        p = free_particles
        free_particles = p!.next
        p!.next = active_particles
        active_particles = p

        p!.time = Float(cg.time)
        p!.alpha = 1.0
        p!.alphavel = 0
        p!.roll = 0

        p!.pshader = 0 //cgs.media.smokePuffShader;

        p!.endtime = Float(Double(cg.time + 350) + (crandom() * 100))

        p!.startfade = Float(cg.time)

        p!.width = Float(LARGESIZE)
        p!.height = Float(LARGESIZE)
        p!.endheight = Float(LARGESIZE)
        p!.endwidth = Float(LARGESIZE)

        p!.type = P_SMOKE

        p!.org = origin

        p!.vel[0] = 0
        p!.vel[1] = 0
        p!.vel[2] = -1

        p!.accel = vec3_t()

        p!.rotate = false

        // The SDK also declares `rand`, so the call names the bg module.
        p!.roll = JKAMP_BG.rand() % 179

        p!.color = BLOODRED

        p!.alpha = 0.75
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:2088
func CG_ParticleSparks(_ org: JKAShared.vec3_t, _ vel: JKAShared.vec3_t, _ duration: Int32, _ x: Float, _ y: Float, _ speed: Float) {
    var p: Cparticle?

    if free_particles == nil {
        return
    }
    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)

    p!.endtime = Float(cg.time + duration)
    p!.startfade = Float(cg.time + duration / 2)

    p!.color = EMISIVEFADE
    p!.alpha = 0.4
    p!.alphavel = 0

    p!.height = 0.5
    p!.width = 0.5
    p!.endheight = 0.5
    p!.endwidth = 0.5

    p!.pshader = 0 //cgs.media.tracerShader;

    p!.type = P_SMOKE

    p!.org = org

    p!.org[0] = Float(Double(p!.org[0]) + (crandom() * Double(x)))
    p!.org[1] = Float(Double(p!.org[1]) + (crandom() * Double(y)))

    p!.vel[0] = vel[0]
    p!.vel[1] = vel[1]
    p!.vel[2] = vel[2]

    p!.accel[2] = 0
    p!.accel[1] = p!.accel[2]
    p!.accel[0] = p!.accel[1]

    p!.vel[0] = Float(Double(p!.vel[0]) + (crandom() * 4))
    p!.vel[1] = Float(Double(p!.vel[1]) + (crandom() * 4))
    p!.vel[2] = Float(Double(p!.vel[2]) + ((20 + (crandom() * 10)) * Double(speed)))

    p!.accel[0] = Float(crandom() * 4)
    p!.accel[1] = Float(crandom() * 4)
}

/// Source: oracle/codemp/cgame/cg_marks.c:2136
func CG_ParticleDust(_ cent: Centity, _ origin: JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t) {
    let length: Float
    var dist: Float
    let crittersize: Float
    var angles = vec3_t()
    var forward = vec3_t()
    var point = vec3_t()
    var p: Cparticle?
    var i: Int32

    dist = 0

    dir = -dir
    length = VectorLength(dir)
    vectoangles(dir, &angles)
    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(angles, &forward, &scratchRight, &scratchUp)

    crittersize = Float(LARGESIZE)

    if length != 0 {
        dist = length / crittersize
    }

    if dist < 1 {
        dist = 1
    }

    point = origin

    i = 0
    while i < dist {
        _VectorMA(point, crittersize, forward, &point)

        if free_particles == nil {
            return
        }

        p = free_particles
        free_particles = p!.next
        p!.next = active_particles
        active_particles = p

        p!.time = Float(cg.time)
        p!.alpha = 5.0
        p!.alphavel = 0
        p!.roll = 0

        p!.pshader = 0 //cgs.media.smokePuffShader;

        // RF, stay around for long enough to expand and dissipate naturally
        if length != 0 {
            p!.endtime = Float(Double(cg.time + 4500) + (crandom() * 3500))
        } else {
            p!.endtime = Float(Double(cg.time + 750) + (crandom() * 500))
        }

        p!.startfade = Float(cg.time)

        p!.width = Float(LARGESIZE)
        p!.height = Float(LARGESIZE)

        // RF, expand while falling
        p!.endheight = Float(Double(LARGESIZE) * 3.0)
        p!.endwidth = Float(Double(LARGESIZE) * 3.0)

        if length == 0 {
            p!.width *= 0.2
            p!.height *= 0.2

            p!.endheight = Float(NORMALSIZE)
            p!.endwidth = Float(NORMALSIZE)
        }

        p!.type = P_SMOKE

        p!.org = point

        p!.vel[0] = Float(crandom() * 6)
        p!.vel[1] = Float(crandom() * 6)
        // The SDK also declares `random`, so the call names the bg module.
        p!.vel[2] = JKAMP_BG.random() * 20

        // RF, add some gravity/randomness
        p!.accel[0] = Float(crandom() * 3)
        p!.accel[1] = Float(crandom() * 3)
        p!.accel[2] = Float(-Double(PARTICLE_GRAVITY) * 0.4)

        p!.accel = vec3_t()

        p!.rotate = false

        // The SDK also declares `rand`, so the call names the bg module.
        p!.roll = JKAMP_BG.rand() % 179

        p!.alpha = 0.75
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_marks.c:2232
func CG_ParticleMisc(_ pshader: JKAShared.qhandle_t, _ origin: JKAShared.vec3_t, _ size: Int32, _ duration: Int32, _ alpha: Float) {
    var p: Cparticle?

    if pshader == 0 {
        CG_Printf("CG_ParticleImpactSmokePuff pshader == ZERO!\n")
    }

    if free_particles == nil {
        return
    }

    p = free_particles
    free_particles = p!.next
    p!.next = active_particles
    active_particles = p
    p!.time = Float(cg.time)
    p!.alpha = 1.0
    p!.alphavel = 0
    // The SDK also declares `rand`, so the call names the bg module.
    p!.roll = JKAMP_BG.rand() % 179

    p!.pshader = pshader

    if duration > 0 {
        p!.endtime = Float(cg.time + duration)
    } else {
        p!.endtime = Float(duration)
    }

    p!.startfade = Float(cg.time)

    p!.width = Float(size)
    p!.height = Float(size)

    p!.endheight = Float(size)
    p!.endwidth = Float(size)

    p!.type = P_SPRITE

    p!.org = origin

    p!.rotate = false
}
