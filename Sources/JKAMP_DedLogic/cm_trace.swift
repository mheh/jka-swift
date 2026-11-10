import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_trace.cpp:447
let MAX_POSITION_LEAFS = 1024 as Int32

/// Source: oracle/codemp/qcommon/cm_trace.cpp:449
// AI: Raven declares `leafs` on the stack of CM_PositionTest. The function uses one zeroed allocation on the storage class.
private var leafs_CM_PositionTest: Slots<Int32> { world.storage.cm_trace_leafs_CM_PositionTest }

/// Source: oracle/codemp/qcommon/cm_trace.cpp:1049
let RADIUS_EPSILON = 1.0 as Float

/**
```
================
RotatePoint
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:43
func RotatePoint(_ point: inout JKAShared.vec3_t, _ matrix: inout [JKAShared.vec3_t]) {
    // bk: FIXME
    var tvec = vec3_t()

    tvec = point
    point[0] = _DotProduct(matrix[0], tvec)
    point[1] = _DotProduct(matrix[1], tvec)
    point[2] = _DotProduct(matrix[2], tvec)
}

/**
```
================
TransposeMatrix
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:57
func TransposeMatrix(_ matrix: inout [JKAShared.vec3_t], _ transpose: inout [JKAShared.vec3_t]) {
    // bk: FIXME
    var i: Int32
    var j: Int32
    i = 0
    while i < 3 {
        j = 0
        while j < 3 {
            transpose[i][j] = matrix[j][i]
            j += 1
        }
        i += 1
    }
}

/**
```
================
CreateRotationMatrix
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:71
func CreateRotationMatrix(_ angles: JKAShared.vec3_t, _ matrix: inout [JKAShared.vec3_t]) {
    do {
        var matrix0 = matrix[0]
        var matrix1 = matrix[1]
        var matrix2 = matrix[2]
        AngleVectors(angles, &matrix0, &matrix1, &matrix2)
        matrix[0] = matrix0
        matrix[1] = matrix1
        matrix[2] = matrix2
    }
    VectorInverse(&matrix[1])
}

/**
```
================
CM_ProjectPointOntoVector
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:81
func CM_ProjectPointOntoVector(_ point: JKAShared.vec3_t, _ vStart: JKAShared.vec3_t, _ vDir: JKAShared.vec3_t, _ vProj: inout JKAShared.vec3_t) {
    var pVec = vec3_t()

    pVec = point - vStart
    // project onto the directional vector for this segment
    _VectorMA(vStart, _DotProduct(pVec, vDir), vDir, &vProj)
}

/**
```
================
CM_DistanceFromLineSquared
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:95
func CM_DistanceFromLineSquared(_ p: JKAShared.vec3_t, _ lp1: JKAShared.vec3_t, _ lp2: JKAShared.vec3_t, _ dir: JKAShared.vec3_t) -> Float {
    var proj = vec3_t()
    var t = vec3_t()
    var j: Int32

    CM_ProjectPointOntoVector(p, lp1, dir, &proj)
    j = 0
    while j < 3 {
        if (proj[j] > lp1[j] && proj[j] > lp2[j]) || (proj[j] < lp1[j] && proj[j] < lp2[j]) {
            break
        }
        j += 1
    }
    if j < 3 {
        if abs(proj[j] - lp1[j]) < abs(proj[j] - lp2[j]) {
            t = p - lp1
        } else {
            t = p - lp2
        }
        return VectorLengthSquared(t)
    }
    t = p - proj
    return VectorLengthSquared(t)
}

/**
```
================
CM_VectorDistanceSquared
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:120
func CM_VectorDistanceSquared(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Float {
    var dir = vec3_t()

    dir = p2 - p1
    return VectorLengthSquared(dir)
}

/**
```
================
SquareRootFloat
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:132
func SquareRootFloat(_ number: Float) -> Float {
    var i: CLong
    let x: Float
    var y: Float
    let f: Float = 1.5

    x = number * 0.5
    y = number
    // Port-note: Raven reads the four bytes of a float through a `long *`, which reads 8 bytes on an lp64 host.
    // The body reads the 32-bit pattern as Raven's 32-bit `long` does, and stores the low 32 bits back.
    i = CLong(Int32(bitPattern: y.bitPattern))
    i = 0x5f3759df - (i >> 1)
    y = Float(bitPattern: UInt32(truncatingIfNeeded: i))
    y = y * (f - (x * y * y))
    y = y * (f - (x * y * y))
    return number * y
}

/**
```
================
CM_TestBoxInBrush
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:161
func CM_TestBoxInBrush(_ tw: TraceWork, _ trace: JKAMP.Trace, _ brush: Cbrush) {
    var i: Int32
    var plane: JKAShared.Cplane
    var dist: Float
    var d1: Float
    var side: Cbrushside
    var t: Float
    var startp = vec3_t()

    if brush.numsides == 0 {
        return
    }

    // special test for axial
    if tw.bounds[0][0] > brush.bounds[1][0]
        || tw.bounds[0][1] > brush.bounds[1][1]
        || tw.bounds[0][2] > brush.bounds[1][2]
        || tw.bounds[1][0] < brush.bounds[0][0]
        || tw.bounds[1][1] < brush.bounds[0][1]
        || tw.bounds[1][2] < brush.bounds[0][2] {
        return
    }

    if tw.sphere.use {
        // the first six planes are the axial planes, so we only
        // need to test the remainder
        i = 6
        while i < brush.numsides {
            side = brush.sidesSlots[i]

            plane = side.plane!

            // adjust the plane distance apropriately for radius
            dist = plane.dist + tw.sphere.radius
            // find the closest point on the capsule to the plane
            t = _DotProduct(plane.normal, tw.sphere.offset)
            if t > 0 {
                startp = tw.start - tw.sphere.offset
            } else {
                startp = tw.start + tw.sphere.offset
            }
            d1 = _DotProduct(startp, plane.normal) - dist
            // if completely in front of face, no intersection
            if d1 > 0 {
                return
            }
            i += 1
        }
    } else {
        // the first six planes are the axial planes, so we only
        // need to test the remainder
        i = 6
        while i < brush.numsides {
            side = brush.sidesSlots[i]

            plane = side.plane!

            // adjust the plane distance apropriately for mins/maxs
            dist = plane.dist - _DotProduct(tw.offsets[plane.signbits], plane.normal)

            d1 = _DotProduct(tw.start, plane.normal) - dist

            // if completely in front of face, no intersection
            if d1 > 0 {
                return
            }
            i += 1
        }
    }

    // inside this brush
    trace.allsolid = 1
    trace.startsolid = trace.allsolid
    trace.fraction = 0
    trace.contents = brush.contents
}

/**
```
================
CM_TestInLeaf
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:262
func CM_TestInLeaf(_ tw: TraceWork, _ trace: JKAMP.Trace, _ leaf: CLeaf, _ local: ClipMap) {
    var k: Int32
    var brushnum: Int32
    var b: Cbrush
    var patch: CPatch?

    // test box position against all brushes in the leaf
    k = 0
    while k < leaf.numLeafBrushes {
        // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
        brushnum = local.leafbrush(at: leaf.firstLeafBrush + k)
        b = local.brushesSlots[brushnum]
        if b.checkcount == local.checkcount {
            k += 1
            continue // already checked this brush in another leaf
        }
        b.checkcount = local.checkcount

        if (b.contents & tw.contents) == 0 {
            k += 1
            continue
        }

        if com_terrainPhysics!.integer != 0 && cmg.landScape != nil && (b.contents & CONTENTS_TERRAIN) != 0 {
            // Invalidate the checkcount for terrain as the terrain brush has to be processed
            // many times.
            b.checkcount -= 1

            CM_TraceThroughTerrain(tw, trace, b)
            // If inside a terrain brush don't bother with regular brush collision
            k += 1
            continue
        }
        CM_TestBoxInBrush(tw, trace, b)
        if trace.allsolid != 0 {
            return
        }
        k += 1
    }

    // test against all patches
    if cm_noCurves!.integer == 0 {
        k = 0
        while k < leaf.numLeafSurfaces {
            //#ifdef _XBOX
            //			int index = CM_GetSurfaceIndex(leaf->firstLeafSurface + k);
            //			patch = local->surfaces[ index ];
            //#else
            // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
            patch = local.surfaces![local.leafsurface(at: leaf.firstLeafSurface + k)]
            //#endif
            if patch == nil {
                k += 1
                continue
            }
            if patch!.checkcount == local.checkcount {
                k += 1
                continue // already checked this brush in another leaf
            }
            patch!.checkcount = local.checkcount

            if (patch!.contents & tw.contents) == 0 {
                k += 1
                continue
            }

            if CM_PositionTestInPatchCollide(tw, patch!.pc!) {
                trace.allsolid = 1
                trace.startsolid = trace.allsolid
                trace.fraction = 0
                trace.contents = patch!.contents
                return
            }
            k += 1
        }
    }
}

/**
```
==================
CM_TestCapsuleInCapsule

capsule inside capsule check
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:342
func CM_TestCapsuleInCapsule(_ tw: TraceWork, _ trace: JKAMP.Trace, _ model: JKAShared.clipHandle_t) {
    var i: Int32
    var mins = vec3_t()
    var maxs = vec3_t()
    var top = vec3_t()
    var bottom = vec3_t()
    var p1 = vec3_t()
    var p2 = vec3_t()
    var tmp = vec3_t()
    var offset = vec3_t()
    var symetricSize = [vec3_t](repeating: vec3_t(), count: 2)
    let radius: Float
    let halfwidth: Float
    let halfheight: Float
    let offs: Float
    let r: Float

    CM_ModelBounds(model, &mins, &maxs)

    top = tw.start + tw.sphere.offset
    bottom = tw.start - tw.sphere.offset
    i = 0
    while i < 3 {
        offset[i] = Float(Double(mins[i] + maxs[i]) * 0.5)
        symetricSize[0][i] = mins[i] - offset[i]
        symetricSize[1][i] = maxs[i] - offset[i]
        i += 1
    }
    halfwidth = symetricSize[1][0]
    halfheight = symetricSize[1][2]
    radius = (halfwidth > halfheight) ? halfheight : halfwidth
    offs = halfheight - radius

    r = Square(tw.sphere.radius + radius)
    // check if any of the spheres overlap
    p1 = offset
    p1[2] += offs
    tmp = p1 - top
    if VectorLengthSquared(tmp) < r {
        trace.allsolid = 1
        trace.startsolid = trace.allsolid
        trace.fraction = 0
    }
    tmp = p1 - bottom
    if VectorLengthSquared(tmp) < r {
        trace.allsolid = 1
        trace.startsolid = trace.allsolid
        trace.fraction = 0
    }
    p2 = offset
    p2[2] -= offs
    tmp = p2 - top
    if VectorLengthSquared(tmp) < r {
        trace.allsolid = 1
        trace.startsolid = trace.allsolid
        trace.fraction = 0
    }
    tmp = p2 - bottom
    if VectorLengthSquared(tmp) < r {
        trace.allsolid = 1
        trace.startsolid = trace.allsolid
        trace.fraction = 0
    }
    // if between cylinder up and lower bounds
    if (top[2] >= p1[2] && top[2] <= p2[2]) || (bottom[2] >= p1[2] && bottom[2] <= p2[2]) {
        // 2d coordinates
        p1[2] = 0
        top[2] = p1[2]
        // if the cylinders overlap
        tmp = top - p1
        if VectorLengthSquared(tmp) < r {
            trace.allsolid = 1
            trace.startsolid = trace.allsolid
            trace.fraction = 0
        }
    }
}

/**
```
==================
CM_TestBoundingBoxInCapsule

bounding box inside capsule check
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:411
func CM_TestBoundingBoxInCapsule(_ tw: TraceWork, _ trace: JKAMP.Trace, _ model: JKAShared.clipHandle_t) {
    var mins = vec3_t()
    var maxs = vec3_t()
    var offset = vec3_t()
    var size = [vec3_t](repeating: vec3_t(), count: 2)
    let h: JKAShared.clipHandle_t
    var cmod: Cmodel?
    var i: Int32

    // mins maxs of the capsule
    CM_ModelBounds(model, &mins, &maxs)

    // offset for capsule center
    i = 0
    while i < 3 {
        offset[i] = Float(Double(mins[i] + maxs[i]) * 0.5)
        size[0][i] = mins[i] - offset[i]
        size[1][i] = maxs[i] - offset[i]
        tw.start[i] -= offset[i]
        tw.end[i] -= offset[i]
        i += 1
    }

    // replace the bounding box with the capsule
    tw.sphere.use = true
    tw.sphere.radius = (size[1][0] > size[1][2]) ? size[1][2] : size[1][0]
    tw.sphere.halfheight = size[1][2]
    tw.sphere.offset = vec3_t(0, 0, size[1][2] - tw.sphere.radius)

    // replace the capsule with the bounding box
    h = CM_TempBoxModel(tw.size[0], tw.size[1], 0)
    // calculate collision
    // AI: Raven passes no `clipMap`, the default NULL of the declaration. The call hands a local that the body drops, because the parameter has no default.
    var clipMap: ClipMap? = nil
    cmod = CM_ClipHandleToModel(h, &clipMap)
    CM_TestInLeaf(tw, trace, cmod!.leaf, cmg)
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:448
func CM_PositionTest(_ tw: TraceWork, _ trace: JKAMP.Trace) {
    // Port-note: The local `int leafs[MAX_POSITION_LEAFS]` has no BYTE_STORAGE_LOCALS entry.
    // Raven wrote: int leafs[MAX_POSITION_LEAFS];
    portMissing("CM_PositionTest", source: "oracle/codemp/qcommon/cm_trace.cpp:448")
    LeafList.scratch { ll in
        var i: Int32

        // identify the leafs we are touching
        ll.bounds[0] = tw.start + tw.size[0]
        ll.bounds[1] = tw.start + tw.size[1]

        i = 0
        while i < 3 {
            ll.bounds[0][i] -= 1
            ll.bounds[1][i] += 1
            i += 1
        }

        ll.count = 0
        ll.maxcount = MAX_POSITION_LEAFS
        // Port-note: A read of `leafs`, a local with no storage.
        // Raven wrote: ll.list = leafs;
        portMissing("CM_PositionTest", source: "oracle/codemp/qcommon/cm_trace.cpp:448")
        ll.storeLeafs = LeafListThunks.CM_StoreLeafs
        ll.lastLeaf = 0
        ll.overflowed = false

        cmg.checkcount += 1

        CM_BoxLeafnums_r(ll, 0)

        cmg.checkcount += 1

        // test the contents of the leafs
        i = 0
        while i < ll.count {
            // Port-note: A read of `leafs`, a local with no storage.
            // Raven wrote: CM_TestInLeaf( tw, trace, &cmg.leafs[leafs[i]], &cmg );
            portMissing("CM_PositionTest", source: "oracle/codemp/qcommon/cm_trace.cpp:448")
            if trace.allsolid != 0 {
                break
            }
            i += 1
        }
    }
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:500
func CM_TraceThroughPatch(_ tw: TraceWork, _ trace: JKAMP.Trace, _ patch: CPatch) {
    let oldFrac: Float

    c_patch_traces += 1

    oldFrac = trace.fraction

    CM_TraceThroughPatchCollide(tw, trace, patch.pc!)

    if trace.fraction < oldFrac {
        trace.surfaceFlags = patch.surfaceFlags
        trace.contents = patch.contents
    }
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:523
func CM_PlaneCollision(_ tw: TraceWork, _ side: Cbrushside) -> Bool {
    let dist: Float
    var f: Float
    let d1: Float
    let d2: Float

    let plane: JKAShared.Cplane = side.plane!

    // adjust the plane distance apropriately for mins/maxs
    dist = plane.dist - _DotProduct(tw.offsets[plane.signbits], plane.normal)

    d1 = _DotProduct(tw.start, plane.normal) - dist
    d2 = _DotProduct(tw.end, plane.normal) - dist

    if d2 > 0.0 {
        // endpoint is not in solid
        tw.getout = true
    }
    if d1 > 0.0 {
        // startpoint is not in solid
        tw.startout = true
    }

    // if completely in front of face, no intersection with the entire brush
    if (d1 > 0.0) && ((Double(d2) >= SURFACE_CLIP_EPSILON) || (d2 >= d1)) {
        return false
    }

    // if it doesn't cross the plane, the plane isn't relevent
    if (d1 <= 0.0) && (d2 <= 0.0) {
        return true
    }
    // crosses face
    if d1 > d2 {
        // enter
        f = Float(Double(d1) - SURFACE_CLIP_EPSILON)
        if f < 0.0 {
            f = 0.0
            if f > tw.enterFrac {
                tw.enterFrac = f
                tw.clipplane = plane
                tw.leadside = side
            }
        } else if f > tw.enterFrac * (d1 - d2) {
            tw.enterFrac = f / (d1 - d2)
            tw.clipplane = plane
            tw.leadside = side
        }
    } else {
        // leave
        f = Float(Double(d1) + SURFACE_CLIP_EPSILON)
        if f < (d1 - d2) {
            f = 1.0
            if f < tw.leaveFrac {
                tw.leaveFrac = f
            }
        } else if f > tw.leaveFrac * (d1 - d2) {
            tw.leaveFrac = f / (d1 - d2)
        }
    }
    return true
}

/**
```
================
CM_TraceThroughBrush
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:607
func CM_TraceThroughBrush(_ tw: TraceWork, _ trace: JKAMP.Trace, _ brush: Cbrush, _ infoOnly: Bool) {
    var i: Int32
    var side: Cbrushside

    tw.enterFrac = -1.0
    tw.leaveFrac = 1.0
    tw.clipplane = nil

    if brush.numsides == 0 {
        return
    }

    // I'm not sure if test is strictly correct.  Are all
    // bboxes axis aligned?  Do I care?  It seems to work
    // good enough...
    if tw.bounds[0][0] > brush.bounds[1][0]
        || tw.bounds[0][1] > brush.bounds[1][1]
        || tw.bounds[0][2] > brush.bounds[1][2]
        || tw.bounds[1][0] < brush.bounds[0][0]
        || tw.bounds[1][1] < brush.bounds[0][1]
        || tw.bounds[1][2] < brush.bounds[0][2] {
        return
    }

    tw.getout = false
    tw.startout = false
    tw.leadside = nil

    //
    // compare the trace against all planes of the brush
    // find the latest time the trace crosses a plane towards the interior
    // and the earliest time the trace crosses a plane towards the exterior
    //
    i = 0
    while i < brush.numsides {
        side = brush.sidesSlots[i]

        if !CM_PlaneCollision(tw, side) {
            return
        }
        i += 1
    }

    //
    // all planes have been checked, and the trace was not
    // completely outside the brush
    //
    if !tw.startout {
        if !infoOnly {
            // original point was inside brush
            trace.startsolid = 1
            if !tw.getout {
                trace.allsolid = 1
                trace.fraction = 0.0
            }
        }
        tw.enterFrac = 0.0
        return
    }

    if tw.enterFrac < tw.leaveFrac {
        if (tw.enterFrac > -1.0) && (tw.enterFrac < trace.fraction) {
            if tw.enterFrac < 0.0 {
                tw.enterFrac = 0.0
            }
            if !infoOnly {
                trace.fraction = tw.enterFrac
                trace.plane = tw.clipplane!
                trace.surfaceFlags = cmg.shadersSlots[tw.leadside!.shaderNum].surfaceFlags
                trace.contents = brush.contents
            }
        }
    }
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:703
func CM_TraceThroughTerrain(_ tw: TraceWork, _ trace: JKAMP.Trace, _ brush: Cbrush) {
    let landscape: OpaquePointer?
    var tBegin = vec3_t()
    var tEnd = vec3_t()
    var tDistance = vec3_t()
    var tStep = vec3_t()
    var baseStart = vec3_t()
    var baseEnd = vec3_t()
    var count: Int32
    var i: Int32
    var fraction: Float

    // At this point we know we may be colliding with a terrain brush (and we know we have a valid terrain structure)
    landscape = cmg.landScape

    // Check for absolutely no connection
    // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
    // The view gives `tw->bounds` as a Slots of rows, and CM_GenericBoxCollide takes `[vec3_t]`.
    // Raven wrote: if(!CM_GenericBoxCollide(tw->bounds, landscape->GetBounds())) { return; }
    portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")
    // Now we know that at least some part of the trace needs to collide with the terrain
    // The regular brush collision is handled elsewhere, so advance the ray to an edge in the terrain brush
    CM_TraceThroughBrush(tw, trace, brush, true)

    // Remember the base entering and leaving fractions
    tw.baseEnterFrac = tw.enterFrac
    tw.baseLeaveFrac = tw.leaveFrac
    // Reset to full spread within the brush
    tw.enterFrac = -1.0
    tw.leaveFrac = 1.0

    // Work out the corners of the AABB when the trace first hits the terrain brush and when it leaves
    VectorAdvance(tw.start, tw.baseEnterFrac, tw.end, &tBegin)
    VectorAdvance(tw.start, tw.baseLeaveFrac, tw.end, &tEnd)
    tDistance = tEnd - tBegin

    // Calculate number of iterations to process
    // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
    // Raven wrote: count = ceilf(VectorLength(tDistance) / (landscape->GetPatchScalarSize() * TERRAIN_STEP_MAGIC));
    portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")
    count = 1
    fraction = trace.fraction
    _VectorScale(tDistance, 1.0 / count, &tStep)

    // Save the base start and end vectors
    baseStart = tw.start
    baseEnd = tw.end

    // Use the terrain vectors.  Start both at the beginning since the
    // step will be added to the end as the first step of the loop
    tw.start = tBegin
    tw.end = tBegin

    // Step thru terrain patches moving on about 1 patch at a time
    i = 0
    while i < count {
        // Add the step to the end
        tw.end = tw.end + tStep

        // Port-note: The view gives `tw->localBounds` as a Slots of rows, and CM_CalcExtents takes `inout [vec3_t]`.
        // Raven wrote: CM_CalcExtents(tBegin, tw->end, tw, tw->localBounds);
        portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")

        // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
        // Raven wrote: landscape->PatchCollide(tw, trace, tw->start, tw->end, brush->checkcount);
        portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")

        // If collision with something closer than water then just stop here
        if trace.fraction < fraction {
            // Convert the fraction of this sub tract into the full trace's fraction
            trace.fraction = i * (1.0 / count) + (1.0 / count) * trace.fraction
            break
        }

        // Move the end to the start so the next trace starts
        // where this one left off
        tw.start = tw.end
        i += 1
    }

    // Put the original start and end back
    tw.start = baseStart
    tw.end = baseEnd

    // Convert to global fraction only if something was hit along the way
    if Double(trace.fraction) != 1.0 {
        trace.fraction = tw.baseEnterFrac + ((tw.baseLeaveFrac - tw.baseEnterFrac) * trace.fraction)
        trace.contents = brush.contents
    }

    // Collide with any water
    if (tw.contents & CONTENTS_WATER) != 0 {
        // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
        // Raven wrote: fraction = landscape->WaterCollide(tw->start, tw->end, trace.fraction);
        portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")
        if fraction < trace.fraction {
            trace.plane.normal = vec3_t(0.0, 0.0, 1.0)
            // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
            // Raven wrote: trace.contents = landscape->GetWaterContents();
            portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")
            trace.fraction = fraction
            // Port-note: The methods of CCMLandScape have no Swift name, row CM6 of the cm_load round.
            // Raven wrote: trace.surfaceFlags = landscape->GetWaterSurfaceFlags();
            portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")
        }
    }
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:914
// TODO: Port signature
// Raven wrote: void CM_HandlePatchCollision(struct traceWork_s *tw, trace_t &trace, const vec3_t tStart, const vec3_t tEnd, CCMPatch *patch, int checkcount)
// No table row for `CCMPatch * patch`.
func CM_HandlePatchCollision() -> Never {
    // TODO: Port CM_HandlePatchCollision
    portMissing("CM_HandlePatchCollision", source: "oracle/codemp/qcommon/cm_trace.cpp:914")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:952
func CM_GenericBoxCollide(_ abounds: [JKAShared.vec3_t], _ bbounds: [JKAShared.vec3_t]) -> Bool {
    var i: Int32

    // Check for completely no intersection
    i = 0
    while i < 3 {
        if abounds[1][i] < bbounds[0][i] {
            return false
        }
        if abounds[0][i] > bbounds[1][i] {
            return false
        }
        i += 1
    }
    return true
}

/**
```
================
CM_TraceThroughLeaf
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:976
func CM_TraceThroughLeaf(_ tw: TraceWork, _ trace: JKAMP.Trace, _ local: ClipMap, _ leaf: CLeaf) {
    var k: Int32
    var brushnum: Int32
    var b: Cbrush
    var patch: CPatch?

    // trace line against all brushes in the leaf
    k = 0
    while k < leaf.numLeafBrushes {
        // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
        brushnum = local.leafbrush(at: leaf.firstLeafBrush + k)

        b = local.brushesSlots[brushnum]
        if b.checkcount == local.checkcount {
            k += 1
            continue // already checked this brush in another leaf
        }
        b.checkcount = local.checkcount

        if (b.contents & tw.contents) == 0 {
            k += 1
            continue
        }

        if com_terrainPhysics!.integer != 0 && cmg.landScape != nil && (b.contents & CONTENTS_TERRAIN) != 0 {
            // Invalidate the checkcount for terrain as the terrain brush has to be processed
            // many times.
            b.checkcount -= 1

            CM_TraceThroughTerrain(tw, trace, b)
        } else {
            CM_TraceThroughBrush(tw, trace, b, false)
        }

        if trace.fraction == 0 {
            return
        }
        k += 1
    }

    // trace line against all patches in the leaf
    if cm_noCurves!.integer == 0 {
        k = 0
        while k < leaf.numLeafSurfaces {
            //#ifdef _XBOX
            //			int index = CM_GetSurfaceIndex(leaf->firstLeafSurface + k);
            //			patch = local->surfaces[ index ];
            //#else
            // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
            patch = local.surfaces![local.leafsurface(at: leaf.firstLeafSurface + k)]
            //#endif
            if patch == nil {
                k += 1
                continue
            }
            if patch!.checkcount == local.checkcount {
                k += 1
                continue // already checked this patch in another leaf
            }
            patch!.checkcount = local.checkcount

            if (patch!.contents & tw.contents) == 0 {
                k += 1
                continue
            }

            CM_TraceThroughPatch(tw, trace, patch!)
            if trace.fraction == 0 {
                return
            }
            k += 1
        }
    }
}

/**
```
================
CM_TraceThroughSphere

get the first intersection of the ray with the sphere
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1058
func CM_TraceThroughSphere(_ tw: TraceWork, _ trace: JKAMP.Trace, _ origin: JKAShared.vec3_t, _ radius: Float, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    var l1: Float
    let l2: Float
    let length: Float
    let scale: Float
    var fraction: Float
    let a: Float
    let b: Float
    let c: Float
    let d: Float
    let sqrtd: Float
    var v1 = vec3_t()
    var dir = vec3_t()
    var intersection = vec3_t()

    // if inside the sphere
    dir = start - origin
    l1 = VectorLengthSquared(dir)
    if l1 < Square(radius) {
        trace.fraction = 0
        trace.startsolid = 1
        // test for allsolid
        dir = end - origin
        l1 = VectorLengthSquared(dir)
        if l1 < Square(radius) {
            trace.allsolid = 1
        }
        return
    }
    //
    dir = end - start
    length = VectorNormalize(&dir)
    //
    l1 = CM_DistanceFromLineSquared(origin, start, end, dir)
    v1 = end - origin
    l2 = VectorLengthSquared(v1)
    // if no intersection with the sphere and the end point is at least an epsilon away
    if l1 >= Square(radius) && Double(l2) > Square(Double(radius) + SURFACE_CLIP_EPSILON) {
        return
    }
    //
    //	| origin - (start + t * dir) | = radius
    //	a = dir[0]^2 + dir[1]^2 + dir[2]^2;
    //	b = 2 * (dir[0] * (start[0] - origin[0]) + dir[1] * (start[1] - origin[1]) + dir[2] * (start[2] - origin[2]));
    //	c = (start[0] - origin[0])^2 + (start[1] - origin[1])^2 + (start[2] - origin[2])^2 - radius^2;
    //
    v1 = start - origin
    // dir is normalized so a = 1
    a = 1.0 //dir[0] * dir[0] + dir[1] * dir[1] + dir[2] * dir[2];
    b = 2.0 * (dir[0] * v1[0] + dir[1] * v1[1] + dir[2] * v1[2])
    c = v1[0] * v1[0] + v1[1] * v1[1] + v1[2] * v1[2] - (radius + RADIUS_EPSILON) * (radius + RADIUS_EPSILON)

    d = b * b - 4.0 * c // * a;
    if d > 0 {
        sqrtd = SquareRootFloat(d)
        // = (- b + sqrtd) * 0.5f; // / (2.0f * a);
        fraction = (-b - sqrtd) * 0.5 // / (2.0f * a);
        //
        if fraction < 0 {
            fraction = 0
        } else {
            fraction /= length
        }
        if fraction < trace.fraction {
            trace.fraction = fraction
            dir = end - start
            _VectorMA(start, fraction, dir, &intersection)
            dir = intersection - origin
            scale = 1 / (radius + RADIUS_EPSILON)
            dir = dir * scale
            trace.plane.normal = dir
            intersection = tw.modelOrigin + intersection
            trace.plane.dist = _DotProduct(trace.plane.normal, intersection)
            trace.contents = CONTENTS_BODY
        }
    } else if d == 0 {
        //t1 = (- b ) / 2;
        // slide along the sphere
    }
    // no intersection at all
}

/**
```
================
CM_TraceThroughVerticalCylinder

get the first intersection of the ray with the cylinder
the cylinder extends halfheight above and below the origin
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1146
func CM_TraceThroughVerticalCylinder(_ tw: TraceWork, _ trace: JKAMP.Trace, _ origin: JKAShared.vec3_t, _ radius: Float, _ halfheight: Float, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    let length: Float
    let scale: Float
    var fraction: Float
    var l1: Float
    let l2: Float
    let a: Float
    let b: Float
    let c: Float
    let d: Float
    let sqrtd: Float
    var v1 = vec3_t()
    var dir = vec3_t()
    let start2d: JKAShared.vec3_t
    let end2d: JKAShared.vec3_t
    let org2d: JKAShared.vec3_t
    var intersection = vec3_t()

    // 2d coordinates
    start2d = vec3_t(start[0], start[1], 0)
    end2d = vec3_t(end[0], end[1], 0)
    org2d = vec3_t(origin[0], origin[1], 0)
    // if between lower and upper cylinder bounds
    if start[2] <= origin[2] + halfheight &&
        start[2] >= origin[2] - halfheight {
        // if inside the cylinder
        dir = start2d - org2d
        l1 = VectorLengthSquared(dir)
        if l1 < Square(radius) {
            trace.fraction = 0
            trace.startsolid = 1
            dir = end2d - org2d
            l1 = VectorLengthSquared(dir)
            if l1 < Square(radius) {
                trace.allsolid = 1
            }
            return
        }
    }
    //
    dir = end2d - start2d
    length = VectorNormalize(&dir)
    //
    l1 = CM_DistanceFromLineSquared(org2d, start2d, end2d, dir)
    v1 = end2d - org2d
    l2 = VectorLengthSquared(v1)
    // if no intersection with the cylinder and the end point is at least an epsilon away
    if l1 >= Square(radius) && Double(l2) > Square(Double(radius) + SURFACE_CLIP_EPSILON) {
        return
    }
    //
    //
    // (start[0] - origin[0] - t * dir[0]) ^ 2 + (start[1] - origin[1] - t * dir[1]) ^ 2 = radius ^ 2
    // (v1[0] + t * dir[0]) ^ 2 + (v1[1] + t * dir[1]) ^ 2 = radius ^ 2;
    // v1[0] ^ 2 + 2 * v1[0] * t * dir[0] + (t * dir[0]) ^ 2 +
    //						v1[1] ^ 2 + 2 * v1[1] * t * dir[1] + (t * dir[1]) ^ 2 = radius ^ 2
    // t ^ 2 * (dir[0] ^ 2 + dir[1] ^ 2) + t * (2 * v1[0] * dir[0] + 2 * v1[1] * dir[1]) +
    //						v1[0] ^ 2 + v1[1] ^ 2 - radius ^ 2 = 0
    //
    v1 = start - origin
    // dir is normalized so we can use a = 1
    a = 1.0 // * (dir[0] * dir[0] + dir[1] * dir[1]);
    b = 2.0 * (v1[0] * dir[0] + v1[1] * dir[1])
    c = v1[0] * v1[0] + v1[1] * v1[1] - (radius + RADIUS_EPSILON) * (radius + RADIUS_EPSILON)

    d = b * b - 4.0 * c // * a;
    if d > 0 {
        sqrtd = SquareRootFloat(d)
        // = (- b + sqrtd) * 0.5f;// / (2.0f * a);
        fraction = (-b - sqrtd) * 0.5 // / (2.0f * a);
        //
        if fraction < 0 {
            fraction = 0
        } else {
            fraction /= length
        }
        if fraction < trace.fraction {
            dir = end - start
            _VectorMA(start, fraction, dir, &intersection)
            // if the intersection is between the cylinder lower and upper bound
            if intersection[2] <= origin[2] + halfheight &&
                intersection[2] >= origin[2] - halfheight {
                //
                trace.fraction = fraction
                dir = intersection - origin
                dir[2] = 0
                scale = 1 / (radius + RADIUS_EPSILON)
                dir = dir * scale
                trace.plane.normal = dir
                intersection = tw.modelOrigin + intersection
                trace.plane.dist = _DotProduct(trace.plane.normal, intersection)
                trace.contents = CONTENTS_BODY
            }
        }
    } else if d == 0 {
        //t[0] = (- b ) / 2 * a;
        // slide along the cylinder
    }
    // no intersection at all
}

/**
```
================
CM_TraceCapsuleThroughCapsule

capsule vs. capsule collision (not rotated)
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1249
func CM_TraceCapsuleThroughCapsule(_ tw: TraceWork, _ trace: JKAMP.Trace, _ model: JKAShared.clipHandle_t) {
    var i: Int32
    var mins = vec3_t()
    var maxs = vec3_t()
    var top = vec3_t()
    var bottom = vec3_t()
    let starttop: JKAShared.vec3_t
    let startbottom: JKAShared.vec3_t
    let endtop: JKAShared.vec3_t
    let endbottom: JKAShared.vec3_t
    var offset = vec3_t()
    var symetricSize = [vec3_t](repeating: vec3_t(), count: 2)
    var radius: Float
    let halfwidth: Float
    let halfheight: Float
    let offs: Float
    let h: Float

    CM_ModelBounds(model, &mins, &maxs)
    // test trace bounds vs. capsule bounds
    if tw.bounds[0][0] > maxs[0] + RADIUS_EPSILON
        || tw.bounds[0][1] > maxs[1] + RADIUS_EPSILON
        || tw.bounds[0][2] > maxs[2] + RADIUS_EPSILON
        || tw.bounds[1][0] < mins[0] - RADIUS_EPSILON
        || tw.bounds[1][1] < mins[1] - RADIUS_EPSILON
        || tw.bounds[1][2] < mins[2] - RADIUS_EPSILON {
        return
    }
    // top origin and bottom origin of each sphere at start and end of trace
    starttop = tw.start + tw.sphere.offset
    startbottom = tw.start - tw.sphere.offset
    endtop = tw.end + tw.sphere.offset
    endbottom = tw.end - tw.sphere.offset

    // calculate top and bottom of the capsule spheres to collide with
    i = 0
    while i < 3 {
        offset[i] = Float(Double(mins[i] + maxs[i]) * 0.5)
        symetricSize[0][i] = mins[i] - offset[i]
        symetricSize[1][i] = maxs[i] - offset[i]
        i += 1
    }
    halfwidth = symetricSize[1][0]
    halfheight = symetricSize[1][2]
    radius = (halfwidth > halfheight) ? halfheight : halfwidth
    offs = halfheight - radius
    top = offset
    top[2] += offs
    bottom = offset
    bottom[2] -= offs
    // expand radius of spheres
    radius += tw.sphere.radius
    // if there is horizontal movement
    if tw.start[0] != tw.end[0] || tw.start[1] != tw.end[1] {
        // height of the expanded cylinder is the height of both cylinders minus the radius of both spheres
        h = halfheight + tw.sphere.halfheight - radius
        // if the cylinder has a height
        if h > 0 {
            // test for collisions between the cylinders
            CM_TraceThroughVerticalCylinder(tw, trace, offset, radius, h, tw.start, tw.end)
        }
    }
    // test for collision between the spheres
    CM_TraceThroughSphere(tw, trace, top, radius, startbottom, endbottom)
    CM_TraceThroughSphere(tw, trace, bottom, radius, starttop, endtop)
}

/**
```
================
CM_TraceBoundingBoxThroughCapsule

bounding box vs. capsule collision
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1311
func CM_TraceBoundingBoxThroughCapsule(_ tw: TraceWork, _ trace: JKAMP.Trace, _ model: JKAShared.clipHandle_t) {
    var mins = vec3_t()
    var maxs = vec3_t()
    var offset = vec3_t()
    var size = [vec3_t](repeating: vec3_t(), count: 2)
    let h: JKAShared.clipHandle_t
    var cmod: Cmodel?
    var i: Int32

    // mins maxs of the capsule
    CM_ModelBounds(model, &mins, &maxs)

    // offset for capsule center
    i = 0
    while i < 3 {
        offset[i] = Float(Double(mins[i] + maxs[i]) * 0.5)
        size[0][i] = mins[i] - offset[i]
        size[1][i] = maxs[i] - offset[i]
        tw.start[i] -= offset[i]
        tw.end[i] -= offset[i]
        i += 1
    }

    // replace the bounding box with the capsule
    tw.sphere.use = true
    tw.sphere.radius = (size[1][0] > size[1][2]) ? size[1][2] : size[1][0]
    tw.sphere.halfheight = size[1][2]
    tw.sphere.offset = vec3_t(0, 0, size[1][2] - tw.sphere.radius)

    // replace the capsule with the bounding box
    h = CM_TempBoxModel(tw.size[0], tw.size[1], 0)
    // calculate collision
    // AI: Raven passes no `clipMap`, the default NULL of the declaration. The call hands a local that the body drops, because the parameter has no default.
    var clipMap: ClipMap? = nil
    cmod = CM_ClipHandleToModel(h, &clipMap)
    CM_TraceThroughLeaf(tw, trace, cmg, cmod!.leaf)
}

/**
```
================
CM_TraceToLeaf
================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1349
func CM_TraceToLeaf(_ tw: TraceWork, _ trace: JKAMP.Trace, _ leaf: CLeaf, _ local: ClipMap) {
    var k: Int32
    var brushnum: Int32
    var b: Cbrush
    var patch: CPatch?

    // trace line against all brushes in the leaf
    k = 0
    while k < leaf.numLeafBrushes {
        // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
        brushnum = local.leafbrush(at: leaf.firstLeafBrush + k)

        b = local.brushesSlots[brushnum]
        if b.checkcount == local.checkcount {
            k += 1
            continue // already checked this brush in another leaf
        }
        b.checkcount = local.checkcount

        if (b.contents & tw.contents) == 0 {
            k += 1
            continue
        }

        if com_terrainPhysics!.integer != 0 && cmg.landScape != nil && (b.contents & CONTENTS_TERRAIN) != 0 {
            // Invalidate the checkcount for terrain as the terrain brush has to be processed
            // many times.
            b.checkcount -= 1

            CM_TraceThroughTerrain(tw, trace, b)
            // If inside a terrain brush don't bother with regular brush collision
            k += 1
            continue
        }

        CM_TraceThroughBrush(tw, trace, b, false)
        if trace.fraction == 0 {
            return
        }
        k += 1
    }

    // trace line against all patches in the leaf
    if cm_noCurves!.integer == 0 {
        k = 0
        while k < leaf.numLeafSurfaces {
            // AI: Raven indexes the table with no bound, and a submodel leaf points into another hunk block. The view reads the word as C does.
            patch = local.surfaces![local.leafsurface(at: leaf.firstLeafSurface + k)]
            if patch == nil {
                k += 1
                continue
            }
            if patch!.checkcount == local.checkcount {
                k += 1
                continue // already checked this patch in another leaf
            }
            patch!.checkcount = local.checkcount

            if (patch!.contents & tw.contents) == 0 {
                k += 1
                continue
            }

            CM_TraceThroughPatch(tw, trace, patch!)
            if trace.fraction == 0 {
                return
            }
            k += 1
        }
    }
}

/**
```
==================
CM_TraceThroughTree

Traverse all the contacted leafs from the start to the end position.
If the trace is a point, they will be exactly in order, but for larger
trace volumes it is possible to hit something in a later leaf with
a smaller intercept fraction.
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1431
func CM_TraceThroughTree(_ tw: TraceWork, _ trace: JKAMP.Trace, _ local: ClipMap, _ num: Int32, _ p1f: Float, _ p2f: Float, _ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) {
    let node: CmNode
    let plane: JKAShared.Cplane
    let t1: Float
    let t2: Float
    let offset: Float
    var frac: Float
    var frac2: Float
    let idist: Float
    var mid = vec3_t()
    let side: Int32
    var midf: Float

    if trace.fraction <= p1f {
        return // already hit something nearer
    }

    // if < 0, we are in a leaf node
    if num < 0 {
        CM_TraceThroughLeaf(tw, trace, local, local.leafsSlots[-1 - num])
        return
    }

    //
    // find the point distances to the seperating plane
    // and the offset for the size of the box
    //
    node = local.nodesSlots[num]
    plane = node.plane!

    // adjust the plane distance apropriately for mins/maxs
    if plane.type < 3 {
        t1 = p1[plane.type] - plane.dist
        t2 = p2[plane.type] - plane.dist
        offset = tw.extents[plane.type]
    } else {
        t1 = _DotProduct(plane.normal, p1) - plane.dist
        t2 = _DotProduct(plane.normal, p2) - plane.dist
        if tw.isPoint {
            offset = 0
        } else {
            // this is silly
            offset = 2048
        }
    }

    // see which sides we need to consider
    if t1 >= offset + 1 && t2 >= offset + 1 {
        CM_TraceThroughTree(tw, trace, local, node.children[0], p1f, p2f, p1, p2)
        return
    }
    if t1 < -offset - 1 && t2 < -offset - 1 {
        CM_TraceThroughTree(tw, trace, local, node.children[1], p1f, p2f, p1, p2)
        return
    }

    // put the crosspoint SURFACE_CLIP_EPSILON pixels on the near side
    if t1 < t2 {
        idist = Float(1.0 / Double(t1 - t2))
        side = 1
        frac2 = Float((Double(t1 + offset) + SURFACE_CLIP_EPSILON) * Double(idist))
        frac = Float((Double(t1 - offset) + SURFACE_CLIP_EPSILON) * Double(idist))
    } else if t1 > t2 {
        idist = Float(1.0 / Double(t1 - t2))
        side = 0
        frac2 = Float((Double(t1 - offset) - SURFACE_CLIP_EPSILON) * Double(idist))
        frac = Float((Double(t1 + offset) + SURFACE_CLIP_EPSILON) * Double(idist))
    } else {
        side = 0
        frac = 1
        frac2 = 0
    }

    // move up to the node
    if frac < 0 {
        frac = 0
    }
    if frac > 1 {
        frac = 1
    }

    midf = p1f + (p2f - p1f) * frac

    mid[0] = p1[0] + frac * (p2[0] - p1[0])
    mid[1] = p1[1] + frac * (p2[1] - p1[1])
    mid[2] = p1[2] + frac * (p2[2] - p1[2])

    CM_TraceThroughTree(tw, trace, local, node.children[side], p1f, midf, p1, mid)

    // go past the node
    if frac2 < 0 {
        frac2 = 0
    }
    if frac2 > 1 {
        frac2 = 1
    }

    midf = p1f + (p2f - p1f) * frac2

    mid[0] = p1[0] + frac2 * (p2[0] - p1[0])
    mid[1] = p1[1] + frac2 * (p2[1] - p1[1])
    mid[2] = p1[2] + frac2 * (p2[2] - p1[2])

    CM_TraceThroughTree(tw, trace, local, node.children[side ^ 1], midf, p2f, mid, p2)
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:1550
func CM_CalcExtents(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ tw: TraceWork, _ bounds: inout [JKAShared.vec3_t]) {
    var i: Int32

    i = 0
    while i < 3 {
        if start[i] < end[i] {
            bounds[0][i] = start[i] + tw.size[0][i]
            bounds[1][i] = end[i] + tw.size[1][i]
        } else {
            bounds[0][i] = end[i] + tw.size[0][i]
            bounds[1][i] = start[i] + tw.size[1][i]
        }
        i += 1
    }
}

/**
```
==================
CM_Trace
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1577
func CM_Trace(_ trace: JKAMP.Trace, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ model: JKAShared.clipHandle_t, _ origin: JKAShared.vec3_t, _ brushmask: Int32, _ capsule: Int32, _ sphere: Sphere?) {
    // Raven assigns his own `mins` and `maxs` parameters. A Swift parameter is immutable, so the body takes a mutable copy of each.
    var mins = mins
    var maxs = maxs
    TraceWork.scratch { tw in
        var i: Int32
        var offset = vec3_t()
        let cmod: Cmodel?
        var local: ClipMap? = nil

        cmod = CM_ClipHandleToModel(model, &local)

        local!.checkcount += 1 // for multi-check avoidance

        c_traces += 1 // for statistics, may be zeroed

        // fill in a default trace
        tw.clear()
        trace.clear()
        trace.fraction = 1 // assume it goes the entire distance until shown otherwise
        tw.modelOrigin = origin

        if local!.numNodes == 0 {
            return // map not loaded, shouldn't happen
        }

        // allow NULL to be passed in for 0,0,0
        if mins == nil {
            mins = vec3_origin
        }
        if maxs == nil {
            maxs = vec3_origin
        }

        // set basic parms
        tw.contents = brushmask

        // adjust so that mins and maxs are always symetric, which
        // avoids some complications with plane expanding of rotated
        // bmodels
        i = 0
        while i < 3 {
            offset[i] = Float(Double(mins![i] + maxs![i]) * 0.5)
            tw.size[0][i] = mins![i] - offset[i]
            tw.size[1][i] = maxs![i] - offset[i]
            tw.start[i] = start[i] + offset[i]
            tw.end[i] = end[i] + offset[i]
            i += 1
        }

        // if a sphere is already specified
        if let sphere {
            tw.sphere = sphere
        } else {
            tw.sphere.use = capsule != 0
            tw.sphere.radius = (tw.size[1][0] > tw.size[1][2]) ? tw.size[1][2] : tw.size[1][0]
            tw.sphere.halfheight = tw.size[1][2]
            tw.sphere.offset = vec3_t(0, 0, tw.size[1][2] - tw.sphere.radius)
        }

        tw.maxOffset = tw.size[1][0] + tw.size[1][1] + tw.size[1][2]

        // tw.offsets[signbits] = vector to apropriate corner from origin
        tw.offsets[0][0] = tw.size[0][0]
        tw.offsets[0][1] = tw.size[0][1]
        tw.offsets[0][2] = tw.size[0][2]

        tw.offsets[1][0] = tw.size[1][0]
        tw.offsets[1][1] = tw.size[0][1]
        tw.offsets[1][2] = tw.size[0][2]

        tw.offsets[2][0] = tw.size[0][0]
        tw.offsets[2][1] = tw.size[1][1]
        tw.offsets[2][2] = tw.size[0][2]

        tw.offsets[3][0] = tw.size[1][0]
        tw.offsets[3][1] = tw.size[1][1]
        tw.offsets[3][2] = tw.size[0][2]

        tw.offsets[4][0] = tw.size[0][0]
        tw.offsets[4][1] = tw.size[0][1]
        tw.offsets[4][2] = tw.size[1][2]

        tw.offsets[5][0] = tw.size[1][0]
        tw.offsets[5][1] = tw.size[0][1]
        tw.offsets[5][2] = tw.size[1][2]

        tw.offsets[6][0] = tw.size[0][0]
        tw.offsets[6][1] = tw.size[1][1]
        tw.offsets[6][2] = tw.size[1][2]

        tw.offsets[7][0] = tw.size[1][0]
        tw.offsets[7][1] = tw.size[1][1]
        tw.offsets[7][2] = tw.size[1][2]

        //
        // calculate bounds
        //
        if tw.sphere.use {
            i = 0
            while i < 3 {
                if tw.start[i] < tw.end[i] {
                    tw.bounds[0][i] = tw.start[i] - abs(tw.sphere.offset[i]) - tw.sphere.radius
                    tw.bounds[1][i] = tw.end[i] + abs(tw.sphere.offset[i]) + tw.sphere.radius
                } else {
                    tw.bounds[0][i] = tw.end[i] - abs(tw.sphere.offset[i]) - tw.sphere.radius
                    tw.bounds[1][i] = tw.start[i] + abs(tw.sphere.offset[i]) + tw.sphere.radius
                }
                i += 1
            }
        } else {
            i = 0
            while i < 3 {
                if tw.start[i] < tw.end[i] {
                    tw.bounds[0][i] = tw.start[i] + tw.size[0][i]
                    tw.bounds[1][i] = tw.end[i] + tw.size[1][i]
                } else {
                    tw.bounds[0][i] = tw.end[i] + tw.size[0][i]
                    tw.bounds[1][i] = tw.start[i] + tw.size[1][i]
                }
                i += 1
            }
        }

        //
        // check for position test special case
        //
        if start[0] == end[0] && start[1] == end[1] && start[2] == end[2] &&
            tw.size[0][0] == 0 && tw.size[0][1] == 0 && tw.size[0][2] == 0 {
            if model != 0 && cmod!.firstNode == -1 {
                if model == CAPSULE_MODEL_HANDLE {
                    if tw.sphere.use {
                        CM_TestCapsuleInCapsule(tw, trace, model)
                    } else {
                        CM_TestBoundingBoxInCapsule(tw, trace, model)
                    }
                } else {
                    CM_TestInLeaf(tw, trace, cmod!.leaf, local!)
                }
            } else if cmod!.firstNode == -1 {
                CM_PositionTest(tw, trace)
            } else {
                CM_TraceThroughTree(tw, trace, local!, cmod!.firstNode, 0, 1, tw.start, tw.end)
            }
        } else {
            //
            // check for point special case
            //
            if tw.size[0][0] == 0 && tw.size[0][1] == 0 && tw.size[0][2] == 0 {
                tw.isPoint = true
                tw.extents = vec3_t()
            } else {
                tw.isPoint = false
                tw.extents[0] = tw.size[1][0]
                tw.extents[1] = tw.size[1][1]
                tw.extents[2] = tw.size[1][2]
            }

            //
            // general sweeping through world
            //
            if model != 0 && cmod!.firstNode == -1 {
                if model == CAPSULE_MODEL_HANDLE {
                    if tw.sphere.use {
                        CM_TraceCapsuleThroughCapsule(tw, trace, model)
                    } else {
                        CM_TraceBoundingBoxThroughCapsule(tw, trace, model)
                    }
                } else {
                    CM_TraceThroughLeaf(tw, trace, local!, cmod!.leaf)
                }
            } else {
                CM_TraceThroughTree(tw, trace, local!, cmod!.firstNode, 0, 1, tw.start, tw.end)
            }
        }

        // generate endpos from the original, unmodified start/end
        if trace.fraction == 1 {
            trace.endpos = end
        } else {
            i = 0
            while i < 3 {
                trace.endpos[i] = start[i] + trace.fraction * (end[i] - start[i])
                i += 1
            }
        }

        // If allsolid is set (was entirely inside something solid), the plane is not valid.
        // If fraction == 1.0, we never hit anything, and thus the plane is not valid.
        // Otherwise, the normal on the plane should have unit length
    }
}

/**
```
==================
CM_BoxTrace
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1836
func CM_BoxTrace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ model: JKAShared.clipHandle_t, _ brushmask: Int32, _ capsule: Int32) {
    CM_Trace(results, start, end, mins, maxs, model, vec3_origin, brushmask, capsule, nil)
}

/**
```
==================
CM_TransformedBoxTrace

Handles offseting and rotation of the end points for moving and
rotating entities
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_trace.cpp:1850
func CM_TransformedBoxTrace(_ trace: JKAMP.Trace, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ model: JKAShared.clipHandle_t, _ brushmask: Int32, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t, _ capsule: Int32) {
    Sphere.scratch { sphere in
        var start_l = vec3_t()
        var end_l = vec3_t()
        let rotated: Bool
        var offset = vec3_t()
        var symetricSize = [vec3_t](repeating: vec3_t(), count: 2)
        var matrix = [vec3_t](repeating: vec3_t(), count: 3)
        var transpose = [vec3_t](repeating: vec3_t(), count: 3)
        var i: Int32
        let halfwidth: Float
        let halfheight: Float
        let t: Float

        // adjust so that mins and maxs are always symetric, which
        // avoids some complications with plane expanding of rotated
        // bmodels
        i = 0
        while i < 3 {
            offset[i] = Float(Double(mins[i] + maxs[i]) * 0.5)
            symetricSize[0][i] = mins[i] - offset[i]
            symetricSize[1][i] = maxs[i] - offset[i]
            start_l[i] = start[i] + offset[i]
            end_l[i] = end[i] + offset[i]
            i += 1
        }

        // subtract origin offset
        start_l = start_l - origin
        end_l = end_l - origin

        // rotate start and end into the models frame of reference
        if model != BOX_MODEL_HANDLE && (angles[0] != 0 || angles[1] != 0 || angles[2] != 0) {
            rotated = true
        } else {
            rotated = false
        }

        halfwidth = symetricSize[1][0]
        halfheight = symetricSize[1][2]

        sphere.use = capsule != 0
        sphere.radius = (halfwidth > halfheight) ? halfheight : halfwidth
        sphere.halfheight = halfheight
        t = halfheight - sphere.radius

        if rotated {
            // rotation on trace line (start-end) instead of rotating the bmodel
            // NOTE: This is still incorrect for bounding boxes because the actual bounding
            //		 box that is swept through the model is not rotated. We cannot rotate
            //		 the bounding box or the bmodel because that would make all the brush
            //		 bevels invalid.
            //		 However this is correct for capsules since a capsule itself is rotated too.
            CreateRotationMatrix(angles, &matrix)
            RotatePoint(&start_l, &matrix)
            RotatePoint(&end_l, &matrix)
            // rotated sphere offset for capsule
            sphere.offset[0] = matrix[0][2] * t
            sphere.offset[1] = -matrix[1][2] * t
            sphere.offset[2] = matrix[2][2] * t
        } else {
            sphere.offset = vec3_t(0, 0, t)
        }

        // sweep the box through the model
        CM_Trace(trace, start_l, end_l, symetricSize[0], symetricSize[1], model, origin, brushmask, capsule, sphere)

        // if the bmodel was rotated and there was a collision
        if rotated && Double(trace.fraction) != 1.0 {
            // rotation of bmodel collision plane
            TransposeMatrix(&matrix, &transpose)
            RotatePoint(&trace.plane.normal, &transpose)
        }

        // re-calculate the end position of the trace because the trace.endpos
        // calculated by CM_Trace could be rotated and have an offset
        trace.endpos[0] = start[0] + trace.fraction * (end[0] - start[0])
        trace.endpos[1] = start[1] + trace.fraction * (end[1] - start[1])
        trace.endpos[2] = start[2] + trace.fraction * (end[2] - start[2])
    }
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:1947
func CM_CullBox(_ frustum: JKAShared.Cplane, _ transformed: inout [JKAShared.vec3_t]) -> Bool {
    var i: Int32
    var j: Int32

    // check against frustum planes
    i = 0
    while i < 4 {
        j = 0
        while j < 8 {
            if _DotProduct(transformed[j], frustum[i].normal) > frustum[i].dist {
                // a point is in front
                break
            }
            j += 1
        }

        if j == 8 {
            // all points were behind one of the planes
            return true
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:1979
func CM_CullWorldBox(_ frustum: JKAShared.Cplane, _ bounds: [JKAShared.vec3_t]) -> Bool {
    var i: Int32
    var transformed = [vec3_t](repeating: vec3_t(), count: 8)

    i = 0
    while i < 8 {
        transformed[i][0] = bounds[i & 1][0]
        transformed[i][1] = bounds[(i >> 1) & 1][1]
        transformed[i][2] = bounds[(i >> 2) & 1][2]
        i += 1
    }

    return (CM_CullBox(frustum, &transformed))
}

/// One static per function this file stores in a `LeafList` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum LeafListThunks {
    /// Source: oracle/codemp/qcommon/cm_test.cpp:63
    static let CM_StoreLeafs: LeafListStoreLeafs = { JKAMP_DedLogic.CM_StoreLeafs(LeafList(handle: $0!), $1) }
}
