import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_patch.cpp:85
var c_totalPatchBlocks: Int32 {
    get { world.variables.c_totalPatchBlocks }
    set { world.variables.c_totalPatchBlocks = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:86
// Raven wrote: int c_totalPatchSurfaces
let c_totalPatchSurfaces: Int32 = 0

/// Source: oracle/codemp/qcommon/cm_patch.cpp:87
// Raven wrote: int c_totalPatchEdges
let c_totalPatchEdges: Int32 = 0

/// Source: oracle/codemp/qcommon/cm_patch.cpp:89
var debugPatchCollide: PatchCollide? {
    get { world.variables.debugPatchCollide }
    set { world.variables.debugPatchCollide = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:90
var debugFacet: Facet? {
    get { world.variables.debugFacet }
    set { world.variables.debugFacet = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:91
var debugBlock: Bool {
    get { world.variables.debugBlock }
    set { world.variables.debugBlock = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:92
var debugBlockPoints: [JKAShared.vec3_t] {
    get { world.variables.debugBlockPoints }
    set { world.variables.debugBlockPoints = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:369
let POINT_EPSILON = 0.1 as Double

/// Source: oracle/codemp/qcommon/cm_patch.cpp:430
var numPlanes: Int32 {
    get { world.variables.numPlanes }
    set { world.variables.numPlanes = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:431
var planes: Slots<PatchPlane> { world.storage.planes }

/// Source: oracle/codemp/qcommon/cm_patch.cpp:435
var facets: Slots<Facet>? {
    get { world.variables.facets }
    set { world.variables.facets = newValue }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:437
let NORMAL_EPSILON = 0.0001 as Double

/// Source: oracle/codemp/qcommon/cm_patch.cpp:438
let DIST_EPSILON = 0.02 as Double

/**
```
=================
CM_ClearLevelPatches
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:108
func CM_ClearLevelPatches() {
    // Port-note: `debugPatchCollide` has no storage, row T8.
    // Raven wrote: debugPatchCollide = NULL
    portMissing("CM_ClearLevelPatches", source: "oracle/codemp/qcommon/cm_patch.cpp:108")
    // Port-note: `debugFacet` has no storage, row T8.
    // Raven wrote: debugFacet = NULL
    portMissing("CM_ClearLevelPatches", source: "oracle/codemp/qcommon/cm_patch.cpp:108")
}

/**
```
=================
CM_SignbitsForNormal
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:118
private func CM_SignbitsForNormal(_ normal: JKAShared.vec3_t) -> Int32 {
    var bits: Int32
    var j: Int32

    bits = 0
    j = 0
    while j < 3 {
        if normal[j] < 0 {
            bits |= 1 << j
        }
        j += 1
    }
    return bits
}

/**
```
=====================
CM_PlaneFromPoints

Returns false if the triangle is degenrate.
The normal will point out of the clock for clockwise ordered points
=====================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:138
private func CM_PlaneFromPoints(_ plane: inout JKAShared.vec4_t, _ a: JKAShared.vec3_t, _ b: JKAShared.vec3_t, _ c: JKAShared.vec3_t) -> Bool {
    var d1 = vec3_t()
    var d2 = vec3_t()
    // AI: Raven builds the normal in the first three floats of the `vec4_t` and normalizes it in place.
    // The normal goes through a `vec3_t` and back into `plane` before either return, the form of `PlaneFromPoints` of q_math.
    var normal = vec3_t()

    d1 = b - a
    d2 = c - a
    CrossProduct(d2, d1, &normal)
    let length = VectorNormalize(&normal)
    plane[0] = normal[0]
    plane[1] = normal[1]
    plane[2] = normal[2]
    if length == 0 {
        return false
    }

    plane[3] = _DotProduct(a, normal)
    return true
}

/**
```
=================
CM_NeedsSubdivision

Returns true if the given quadratic curve is not flat enough for our
collision detection purposes
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:169
private func CM_NeedsSubdivision(_ a: JKAShared.vec3_t, _ b: JKAShared.vec3_t, _ c: JKAShared.vec3_t) -> Bool {
    var cmid = vec3_t()
    var lmid = vec3_t()
    var delta = vec3_t()
    let dist: Float
    var i: Int32

    // calculate the linear midpoint
    i = 0
    while i < 3 {
        lmid[i] = Float(0.5 * Double(a[i] + c[i]))
        i += 1
    }

    // calculate the exact curve midpoint
    i = 0
    while i < 3 {
        cmid[i] = Float(0.5 * (0.5 * Double(a[i] + b[i]) + 0.5 * Double(b[i] + c[i])))
        i += 1
    }

    // see if the curve is far enough away from the linear mid
    delta = cmid - lmid
    dist = VectorLengthSquared(delta)

    return Bool((dist >= SUBDIVIDE_DISTANCE * SUBDIVIDE_DISTANCE))
}

/**
```
===============
CM_Subdivide

a, b, and c are control points.
the subdivided sequence will be: a, out1, out2, out3, c
===============
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:201
private func CM_Subdivide(_ a: JKAShared.vec3_t, _ b: JKAShared.vec3_t, _ c: JKAShared.vec3_t, _ out1: inout JKAShared.vec3_t, _ out2: inout JKAShared.vec3_t, _ out3: inout JKAShared.vec3_t) {
    var i: Int32

    i = 0
    while i < 3 {
        out1[i] = Float(0.5 * Double(a[i] + b[i]))
        out3[i] = Float(0.5 * Double(b[i] + c[i]))
        out2[i] = Float(0.5 * Double(out1[i] + out3[i]))
        i += 1
    }
}

/**
```
=================
CM_TransposeGrid

Swaps the rows and columns in place
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:218
private func CM_TransposeGrid(_ grid: CGrid) {
    // TODO: Port CM_TransposeGrid
    portMissing("CM_TransposeGrid", source: "oracle/codemp/qcommon/cm_patch.cpp:218")
}

/**
```
===================
CM_SetGridWrapWidth

If the left and right columns are exactly equal, set grid->wrapWidth qtrue
===================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:269
private func CM_SetGridWrapWidth(_ grid: CGrid) {
    // TODO: Port CM_SetGridWrapWidth
    portMissing("CM_SetGridWrapWidth", source: "oracle/codemp/qcommon/cm_patch.cpp:269")
}

/**
```
=================
CM_SubdivideGridColumns

Adds columns as necessary to the grid until
all the aproximating points are within SUBDIVIDE_DISTANCE
from the true curve
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:301
private func CM_SubdivideGridColumns(_ grid: CGrid) {
    // TODO: Port CM_SubdivideGridColumns
    portMissing("CM_SubdivideGridColumns", source: "oracle/codemp/qcommon/cm_patch.cpp:301")
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:370
private func CM_ComparePoints(_ a: Slots<Float>, _ b: Slots<Float>) -> Bool {
    var d: Float

    d = a[0] - b[0]
    if Double(d) < -POINT_EPSILON || Double(d) > POINT_EPSILON {
        return false
    }
    d = a[1] - b[1]
    if Double(d) < -POINT_EPSILON || Double(d) > POINT_EPSILON {
        return false
    }
    d = a[2] - b[2]
    if Double(d) < -POINT_EPSILON || Double(d) > POINT_EPSILON {
        return false
    }
    return true
}

/**
```
=================
CM_RemoveDegenerateColumns

If there are any identical columns, remove them
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:395
private func CM_RemoveDegenerateColumns(_ grid: CGrid) {
    // TODO: Port CM_RemoveDegenerateColumns
    portMissing("CM_RemoveDegenerateColumns", source: "oracle/codemp/qcommon/cm_patch.cpp:395")
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:440
private func CM_PlaneEqual(_ p: PatchPlane, _ plane: JKAShared.vec4_t, _ flipped: inout Int32) -> Int32 {
    // TODO: Port CM_PlaneEqual
    portMissing("CM_PlaneEqual", source: "oracle/codemp/qcommon/cm_patch.cpp:440")
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:469
private func CM_SnapVector(_ normal: inout JKAShared.vec3_t) {
    var i: Int32

    i = 0
    while i < 3 {
        if Double(Q_fabs(normal[i] - 1)) < NORMAL_EPSILON {
            normal = vec3_t()
            normal[i] = 1
            break
        }
        if Double(Q_fabs(normal[i] - -1)) < NORMAL_EPSILON {
            normal = vec3_t()
            normal[i] = -1
            break
        }
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:489
private func CM_FindPlane2(_ plane: JKAShared.vec4_t, _ flipped: inout Int32) -> Int32 {
    var i: Int32

    // see if the points are close enough to an existing plane
    i = 0
    while i < numPlanes {
        // Port-note: CM_PlaneEqual carries a signature marker, and `planes` has no storage, rows T8 and T9.
        // Raven wrote: if (CM_PlaneEqual(&planes[i], plane, flipped)) return i
        portMissing("CM_FindPlane2", source: "oracle/codemp/qcommon/cm_patch.cpp:489")
        i += 1
    }

    // add a new plane
    if numPlanes == MAX_PATCH_PLANES {
        Com_Error(ERR_DROP, "MAX_PATCH_PLANES")
    }

    // Port-note: `planes` has no storage, row T8.
    // Raven wrote: Vector4Copy( plane, planes[numPlanes].plane )
    portMissing("CM_FindPlane2", source: "oracle/codemp/qcommon/cm_patch.cpp:489")
    // Port-note: `planes` has no storage, and `plane` is a `[Float]` where CM_SignbitsForNormal takes a `vec3_t`, rows T8 and T9.
    // Raven wrote: planes[numPlanes].signbits = CM_SignbitsForNormal( plane )
    portMissing("CM_FindPlane2", source: "oracle/codemp/qcommon/cm_patch.cpp:489")

    numPlanes += 1

    flipped = 0

    return numPlanes - 1
}

/**
```
==================
CM_FindPlane
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:517
private func CM_FindPlane(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t, _ p3: JKAShared.vec3_t) -> Int32 {
    var plane: [Float] = [Float](repeating: 0, count: 4)
    var i: Int32
    var d: Float

    // Port-note: `plane` is a `[Float]` and `p1` an `inout Float` where CM_PlaneFromPoints takes a `vec4_t` and a `vec3_t`, row T9.
    // Raven wrote: if ( !CM_PlaneFromPoints( plane, p1, p2, p3 ) ) { return -1; }
    portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")

    // see if the points are close enough to an existing plane
    i = 0
    while i < numPlanes {
        // Port-note: `planes` has no storage, and `plane` is a `[Float]`, rows T8 and T9.
        // Raven wrote: if ( DotProduct( plane, planes[i].plane ) < 0 ) { continue; // allow backwards planes? }
        portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")

        // Port-note: `planes` has no storage, and `p1` is an `inout Float`, rows T8 and T9.
        // Raven wrote: d = DotProduct( p1, planes[i].plane ) - planes[i].plane[3]
        portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")
        if Double(d) < -PLANE_TRI_EPSILON || Double(d) > PLANE_TRI_EPSILON {
            i += 1
            continue
        }

        // Port-note: `planes` has no storage, and `p2` is an `inout Float`, rows T8 and T9.
        // Raven wrote: d = DotProduct( p2, planes[i].plane ) - planes[i].plane[3]
        portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")
        if Double(d) < -PLANE_TRI_EPSILON || Double(d) > PLANE_TRI_EPSILON {
            i += 1
            continue
        }

        // Port-note: `planes` has no storage, and `p3` is an `inout Float`, rows T8 and T9.
        // Raven wrote: d = DotProduct( p3, planes[i].plane ) - planes[i].plane[3]
        portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")
        if Double(d) < -PLANE_TRI_EPSILON || Double(d) > PLANE_TRI_EPSILON {
            i += 1
            continue
        }

        // found it
        return i
        i += 1
    }

    // add a new plane
    if numPlanes == MAX_PATCH_PLANES {
        Com_Error(ERR_DROP, "MAX_PATCH_PLANES")
    }

    // Port-note: `planes` has no storage, row T8.
    // Raven wrote: Vector4Copy( plane, planes[numPlanes].plane )
    portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")
    // Port-note: `planes` has no storage, and `plane` is a `[Float]` where CM_SignbitsForNormal takes a `vec3_t`, rows T8 and T9.
    // Raven wrote: planes[numPlanes].signbits = CM_SignbitsForNormal( plane )
    portMissing("CM_FindPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:517")

    numPlanes += 1

    return numPlanes - 1
}

/**
```
==================
CM_PointOnPlaneSide
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:570
private func CM_PointOnPlaneSide(_ p: JKAShared.vec3_t, _ planeNum: Int32) -> Int32 {
    // Port-note: A `float *` local into `planes`, which has no storage, row T8.
    // Raven wrote: float *plane;
    portMissing("CM_PointOnPlaneSide", source: "oracle/codemp/qcommon/cm_patch.cpp:570")
    let d: Float

    if planeNum == -1 {
        return SIDE_ON
    }
    // Port-note: A store into `plane`, a local the draft left as a hole.
    // Raven wrote: plane = planes[ planeNum ].plane
    portMissing("CM_PointOnPlaneSide", source: "oracle/codemp/qcommon/cm_patch.cpp:570")

    // Port-note: A read of `plane`, a local the draft left as a hole.
    // Raven wrote: d = DotProduct( p, plane ) - plane[3]
    portMissing("CM_PointOnPlaneSide", source: "oracle/codemp/qcommon/cm_patch.cpp:570")

    if Double(d) > PLANE_TRI_EPSILON {
        return SIDE_FRONT
    }

    if Double(d) < -PLANE_TRI_EPSILON {
        return SIDE_BACK
    }

    return SIDE_ON
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:592
// TODO: Port signature
// Raven wrote: static inline int CM_GridPlane( int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2], int i, int j, int tri )
// No table row for `int[129][129][2] gridPlanes`.
private func CM_GridPlane() -> Never {
    // TODO: Port CM_GridPlane
    portMissing("CM_GridPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:592")
}

/**
```
==================
CM_EdgePlaneNum
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:615
// TODO: Port signature
// Raven wrote: static inline int CM_EdgePlaneNum( cGrid_t *grid, int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2], int i, int j, int k )
// No table row for `cGrid_t * grid`.
private func CM_EdgePlaneNum() -> Never {
    // TODO: Port CM_EdgePlaneNum
    portMissing("CM_EdgePlaneNum", source: "oracle/codemp/qcommon/cm_patch.cpp:615")
}

/**
```
===================
CM_SetBorderInward
===================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:675
// TODO: Port signature
// Raven wrote: static inline void CM_SetBorderInward( facet_t *facet, cGrid_t *grid, int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2], int i, int j, int which )
// No table row for `cGrid_t * grid`.
private func CM_SetBorderInward() -> Never {
    // TODO: Port CM_SetBorderInward
    portMissing("CM_SetBorderInward", source: "oracle/codemp/qcommon/cm_patch.cpp:675")
}

/**
```
==================
CM_ValidateFacet

If the facet isn't bounded by its borders, we screwed up.
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:755
private func CM_ValidateFacet(_ facet: Facet) -> Bool {
    // TODO: Port CM_ValidateFacet
    portMissing("CM_ValidateFacet", source: "oracle/codemp/qcommon/cm_patch.cpp:755")
}

/**
```
==================
CM_AddFacetBevels
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:807
private func CM_AddFacetBevels(_ facet: Facet) {
    // TODO: Port CM_AddFacetBevels
    portMissing("CM_AddFacetBevels", source: "oracle/codemp/qcommon/cm_patch.cpp:807")
}

/**
```
==================
CM_PatchCollideFromGrid
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:983
private func CM_PatchCollideFromGrid(_ grid: CGrid, _ pf: PatchCollide) {
    // TODO: Port CM_PatchCollideFromGrid
    portMissing("CM_PatchCollideFromGrid", source: "oracle/codemp/qcommon/cm_patch.cpp:983")
}

/**
```
===================
CM_GeneratePatchCollide

Creates an internal structure that will be used to perform
collision detection with a patch mesh.

Points is packed as concatenated rows.
===================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:1163
func CM_GeneratePatchCollide(_ width: Int32, _ height: Int32, _ points: inout JKAShared.vec3_t) -> PatchCollide? {
    // TODO: Port CM_GeneratePatchCollide
    portMissing("CM_GeneratePatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1163")
}

/**
```
====================
CM_TracePointThroughPatchCollide

  special case for point traces because the patch collide "brushes" have no volume
====================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:1246
private func CM_TracePointThroughPatchCollide(_ tw: TraceWork, _ trace: JKAMP.Trace, _ pc: PatchCollide) {
    // TODO: Port CM_TracePointThroughPatchCollide
    portMissing("CM_TracePointThroughPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1246")
}

/**
```
====================
CM_CheckFacetPlane
====================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:1346
private func CM_CheckFacetPlane(_ plane: JKAShared.vec4_t, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ enterFrac: inout Float, _ leaveFrac: inout Float, _ hit: inout Int32) -> Int32 {
    let d1: Float
    let d2: Float
    var f: Float

    hit = 0

    // Port-note: `plane` is a `Slots<Float>`, and DotProduct takes a `vec3_t`, row T9.
    // Raven wrote: d1 = DotProduct( start, plane ) - plane[3]
    portMissing("CM_CheckFacetPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:1346")
    // Port-note: `plane` is a `Slots<Float>`, and DotProduct takes a `vec3_t`, row T9.
    // Raven wrote: d2 = DotProduct( end, plane ) - plane[3]
    portMissing("CM_CheckFacetPlane", source: "oracle/codemp/qcommon/cm_patch.cpp:1346")

    // if completely in front of face, no intersection with the entire facet
    if d1 > 0 && (Double(d2) >= SURFACE_CLIP_EPSILON || d2 >= d1) {
        return 0
    }

    // if it doesn't cross the plane, the plane isn't relevent
    if d1 <= 0 && d2 <= 0 {
        return 1
    }

    // crosses face
    if d1 > d2 {
        // enter
        f = Float((Double(d1) - SURFACE_CLIP_EPSILON) / Double(d1 - d2))
        if f < 0 {
            f = 0
        }
        //always favor previous plane hits and thus also the surface plane hit
        if f > enterFrac {
            enterFrac = f
            hit = 1
        }
    } else {
        // leave
        f = Float((Double(d1) + SURFACE_CLIP_EPSILON) / Double(d1 - d2))
        if f > 1 {
            f = 1
        }
        if f < leaveFrac {
            leaveFrac = f
        }
    }
    return 1
}

/**
```
====================
CM_TraceThroughPatchCollide
====================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:1392
func CM_TraceThroughPatchCollide(_ tw: TraceWork, _ trace: JKAMP.Trace, _ pc: PatchCollide) {
    // TODO: Port CM_TraceThroughPatchCollide
    portMissing("CM_TraceThroughPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1392")
}

/**
```
====================
CM_PositionTestInPatchCollide

Modifies tr->tr if any of the facets effect the trace
====================
```
*/
/// Source: oracle/codemp/qcommon/cm_patch.cpp:1545
func CM_PositionTestInPatchCollide(_ tw: TraceWork, _ pc: PatchCollide) -> Bool {
    // TODO: Port CM_PositionTestInPatchCollide
    portMissing("CM_PositionTestInPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1545")
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:1651
func CM_DrawDebugSurface(_ drawPoly: ((Int32, Int32, inout Float) -> Void)?) {
    // The renderer's R_DebugGraphics is the one caller, and the dedicated build never draws, so it is dead.
    // TODO: Port CM_DrawDebugSurface
    portMissing("CM_DrawDebugSurface", source: "oracle/codemp/qcommon/cm_patch.cpp:1651")
}
