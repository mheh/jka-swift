import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_trace.cpp:447
let MAX_POSITION_LEAFS = 1024 as Int32

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
    // TODO: Port CM_TestBoxInBrush
    portMissing("CM_TestBoxInBrush", source: "oracle/codemp/qcommon/cm_trace.cpp:161")
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
    // TODO: Port CM_TestInLeaf
    portMissing("CM_TestInLeaf", source: "oracle/codemp/qcommon/cm_trace.cpp:262")
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
    // TODO: Port CM_TestCapsuleInCapsule
    portMissing("CM_TestCapsuleInCapsule", source: "oracle/codemp/qcommon/cm_trace.cpp:342")
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
    // TODO: Port CM_TestBoundingBoxInCapsule
    portMissing("CM_TestBoundingBoxInCapsule", source: "oracle/codemp/qcommon/cm_trace.cpp:411")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:448
func CM_PositionTest(_ tw: TraceWork, _ trace: JKAMP.Trace) {
    // TODO: Port CM_PositionTest
    portMissing("CM_PositionTest", source: "oracle/codemp/qcommon/cm_trace.cpp:448")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:500
func CM_TraceThroughPatch(_ tw: TraceWork, _ trace: JKAMP.Trace, _ patch: CPatch) {
    // TODO: Port CM_TraceThroughPatch
    portMissing("CM_TraceThroughPatch", source: "oracle/codemp/qcommon/cm_trace.cpp:500")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:523
func CM_PlaneCollision(_ tw: TraceWork, _ side: Cbrushside) -> Bool {
    // TODO: Port CM_PlaneCollision
    portMissing("CM_PlaneCollision", source: "oracle/codemp/qcommon/cm_trace.cpp:523")
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
    // TODO: Port CM_TraceThroughBrush
    portMissing("CM_TraceThroughBrush", source: "oracle/codemp/qcommon/cm_trace.cpp:607")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:703
func CM_TraceThroughTerrain(_ tw: TraceWork, _ trace: JKAMP.Trace, _ brush: Cbrush) {
    // TODO: Port CM_TraceThroughTerrain
    portMissing("CM_TraceThroughTerrain", source: "oracle/codemp/qcommon/cm_trace.cpp:703")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:914
// TODO: Port signature
// Raven wrote: void CM_HandlePatchCollision(struct traceWork_s *tw, trace_t &trace, const vec3_t tStart, const vec3_t tEnd, CCMPatch *patch, int checkcount)
// No table row for `struct traceWork_s * tw`.
func CM_HandlePatchCollision() -> Never {
    // TODO: Port CM_HandlePatchCollision
    portMissing("CM_HandlePatchCollision", source: "oracle/codemp/qcommon/cm_trace.cpp:914")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:952
func CM_GenericBoxCollide(_ abounds: [JKAShared.vec3_t], _ bbounds: [JKAShared.vec3_t]) -> Bool {
    // TODO: Port CM_GenericBoxCollide
    portMissing("CM_GenericBoxCollide", source: "oracle/codemp/qcommon/cm_trace.cpp:952")
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
    // TODO: Port CM_TraceThroughLeaf
    portMissing("CM_TraceThroughLeaf", source: "oracle/codemp/qcommon/cm_trace.cpp:976")
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
    // TODO: Port CM_TraceThroughSphere
    portMissing("CM_TraceThroughSphere", source: "oracle/codemp/qcommon/cm_trace.cpp:1058")
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
    // TODO: Port CM_TraceThroughVerticalCylinder
    portMissing("CM_TraceThroughVerticalCylinder", source: "oracle/codemp/qcommon/cm_trace.cpp:1146")
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
    // TODO: Port CM_TraceCapsuleThroughCapsule
    portMissing("CM_TraceCapsuleThroughCapsule", source: "oracle/codemp/qcommon/cm_trace.cpp:1249")
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
    // TODO: Port CM_TraceBoundingBoxThroughCapsule
    portMissing("CM_TraceBoundingBoxThroughCapsule", source: "oracle/codemp/qcommon/cm_trace.cpp:1311")
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
    // TODO: Port CM_TraceToLeaf
    portMissing("CM_TraceToLeaf", source: "oracle/codemp/qcommon/cm_trace.cpp:1349")
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
    // TODO: Port CM_TraceThroughTree
    portMissing("CM_TraceThroughTree", source: "oracle/codemp/qcommon/cm_trace.cpp:1431")
}

/// Source: oracle/codemp/qcommon/cm_trace.cpp:1550
func CM_CalcExtents(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ tw: TraceWork, _ bounds: inout [JKAShared.vec3_t]) {
    // TODO: Port CM_CalcExtents
    portMissing("CM_CalcExtents", source: "oracle/codemp/qcommon/cm_trace.cpp:1550")
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
    // TODO: Port CM_Trace
    portMissing("CM_Trace", source: "oracle/codemp/qcommon/cm_trace.cpp:1577")
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
    // Port-note: CM_Trace carries a signature marker, row T2.
    // Raven wrote: CM_Trace( results, start, end, mins, maxs, model, vec3_origin, brushmask, capsule, NULL )
    portMissing("CM_BoxTrace", source: "oracle/codemp/qcommon/cm_trace.cpp:1836")
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
        // Port-note: CM_Trace carries a signature marker, row T2.
        // Raven wrote: CM_Trace( trace, start_l, end_l, symetricSize[0], symetricSize[1], model, origin, brushmask, capsule, &sphere )
        portMissing("CM_TransformedBoxTrace", source: "oracle/codemp/qcommon/cm_trace.cpp:1850")

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
    // TODO: Port CM_CullWorldBox
    portMissing("CM_CullWorldBox", source: "oracle/codemp/qcommon/cm_trace.cpp:1979")
}
