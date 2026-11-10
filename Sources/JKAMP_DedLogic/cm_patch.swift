import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_patch.cpp:971
private let EN_TOP: Int32 = 0
private let EN_RIGHT: Int32 = 1
private let EN_BOTTOM: Int32 = 2
private let EN_LEFT: Int32 = 3

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
    debugPatchCollide = nil
    debugFacet = nil
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
    var i: Int32
    var j: Int32
    var l: Int32
    var temp = vec3_t()
    var tempWrap: Bool

    if grid.width > grid.height {
        i = 0
        while i < grid.height {
            j = i + 1
            while j < grid.width {
                if j < grid.height {
                    // swap the value
                    temp = grid.points[i][j]
                    grid.points[i][j] = grid.points[j][i]
                    grid.points[j][i] = temp
                } else {
                    // just copy
                    grid.points[i][j] = grid.points[j][i]
                }
                j += 1
            }
            i += 1
        }
    } else {
        i = 0
        while i < grid.width {
            j = i + 1
            while j < grid.height {
                if j < grid.width {
                    // swap the value
                    temp = grid.points[j][i]
                    grid.points[j][i] = grid.points[i][j]
                    grid.points[i][j] = temp
                } else {
                    // just copy
                    grid.points[j][i] = grid.points[i][j]
                }
                j += 1
            }
            i += 1
        }
    }

    l = grid.width
    grid.width = grid.height
    grid.height = l

    tempWrap = grid.wrapWidth
    grid.wrapWidth = grid.wrapHeight
    grid.wrapHeight = tempWrap
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
    var i: Int32
    var j: Int32
    var d: Float

    i = 0
    while i < grid.height {
        j = 0
        while j < 3 {
            d = grid.points[0][i][j] - grid.points[grid.width - 1][i][j]
            if Double(d) < -WRAP_POINT_EPSILON || Double(d) > WRAP_POINT_EPSILON {
                break
            }
            j += 1
        }
        if j != 3 {
            break
        }
        i += 1
    }
    if i == grid.height {
        grid.wrapWidth = true
    } else {
        grid.wrapWidth = false
    }
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
    var i: Int32
    var j: Int32
    var k: Int32

    i = 0
    while i < grid.width - 2 {
        // grid->points[i][x] is an interpolating control point
        // grid->points[i+1][x] is an aproximating control point
        // grid->points[i+2][x] is an interpolating control point

        //
        // first see if we can collapse the aproximating collumn away
        //
        j = 0
        while j < grid.height {
            if CM_NeedsSubdivision(grid.points[i][j], grid.points[i + 1][j], grid.points[i + 2][j]) {
                break
            }
            j += 1
        }
        if j == grid.height {
            // all of the points were close enough to the linear midpoints
            // that we can collapse the entire column away
            j = 0
            while j < grid.height {
                // remove the column
                k = i + 2
                while k < grid.width {
                    grid.points[k - 1][j] = grid.points[k][j]
                    k += 1
                }
                j += 1
            }

            grid.width -= 1

            // go to the next curve segment
            i += 1
            continue
        }

        //
        // we need to subdivide the curve
        //
        j = 0
        while j < grid.height {
            var prev = vec3_t()
            var mid = vec3_t()
            var next = vec3_t()

            // save the control points now
            prev = grid.points[i][j]
            mid = grid.points[i + 1][j]
            next = grid.points[i + 2][j]

            // make room for two additional columns in the grid
            // columns i+1 will be replaced, column i+2 will become i+4
            // i+1, i+2, and i+3 will be generated
            k = grid.width - 1
            while k > i + 1 {
                grid.points[k + 2][j] = grid.points[k][j]
                k -= 1
            }

            // generate the subdivided points
            CM_Subdivide(prev, mid, next, &grid.points[i + 1][j], &grid.points[i + 2][j], &grid.points[i + 3][j])
            j += 1
        }

        grid.width += 2

        // the new aproximating point at i+1 may need to be removed
        // or subdivided farther, so don't advance i
    }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:370
private func CM_ComparePoints(_ a: JKAShared.vec3_t, _ b: JKAShared.vec3_t) -> Bool {
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
    var i: Int32
    var j: Int32
    var k: Int32

    i = 0
    while i < grid.width - 1 {
        j = 0
        while j < grid.height {
            if !CM_ComparePoints(grid.points[i][j], grid.points[i + 1][j]) {
                break
            }
            j += 1
        }

        if j != grid.height {
            i += 1
            continue // not degenerate
        }

        j = 0
        while j < grid.height {
            // remove the column
            k = i + 2
            while k < grid.width {
                grid.points[k - 1][j] = grid.points[k][j]
                k += 1
            }
            j += 1
        }
        grid.width -= 1

        // check against the next column
        i -= 1
        i += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:440
private func CM_PlaneEqual(_ p: PatchPlane, _ plane: JKAShared.vec4_t, _ flipped: inout Int32) -> Int32 {
    var invplane = vec4_t()

    if Double(Q_fabs(p.plane[0] - plane[0])) < NORMAL_EPSILON
        && Double(Q_fabs(p.plane[1] - plane[1])) < NORMAL_EPSILON
        && Double(Q_fabs(p.plane[2] - plane[2])) < NORMAL_EPSILON
        && Double(Q_fabs(p.plane[3] - plane[3])) < DIST_EPSILON {
        flipped = 0
        return 1
    }

    invplane[0] = -plane[0]
    invplane[1] = -plane[1]
    invplane[2] = -plane[2]
    invplane[3] = -plane[3]

    if Double(Q_fabs(p.plane[0] - invplane[0])) < NORMAL_EPSILON
        && Double(Q_fabs(p.plane[1] - invplane[1])) < NORMAL_EPSILON
        && Double(Q_fabs(p.plane[2] - invplane[2])) < NORMAL_EPSILON
        && Double(Q_fabs(p.plane[3] - invplane[3])) < DIST_EPSILON {
        flipped = 1
        return 1
    }

    return 0
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
        if CM_PlaneEqual(planes[i], plane, &flipped) != 0 {
            return i
        }
        i += 1
    }

    // add a new plane
    if numPlanes == MAX_PATCH_PLANES {
        Com_Error(ERR_DROP, "MAX_PATCH_PLANES")
    }

    planes[numPlanes].plane[0] = plane[0]
    planes[numPlanes].plane[1] = plane[1]
    planes[numPlanes].plane[2] = plane[2]
    planes[numPlanes].plane[3] = plane[3]
    planes[numPlanes].signbits = CM_SignbitsForNormal(vec3_t(plane[0], plane[1], plane[2]))

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
    var plane = vec4_t()
    var i: Int32
    var d: Float

    if !CM_PlaneFromPoints(&plane, p1, p2, p3) {
        return -1
    }

    // see if the points are close enough to an existing plane
    i = 0
    while i < numPlanes {
        if _DotProduct(vec3_t(plane[0], plane[1], plane[2]), vec3_t(planes[i].plane[0], planes[i].plane[1], planes[i].plane[2])) < 0 {
            i += 1
            continue // allow backwards planes?
        }

        d = _DotProduct(p1, vec3_t(planes[i].plane[0], planes[i].plane[1], planes[i].plane[2])) - planes[i].plane[3]
        if Double(d) < -PLANE_TRI_EPSILON || Double(d) > PLANE_TRI_EPSILON {
            i += 1
            continue
        }

        d = _DotProduct(p2, vec3_t(planes[i].plane[0], planes[i].plane[1], planes[i].plane[2])) - planes[i].plane[3]
        if Double(d) < -PLANE_TRI_EPSILON || Double(d) > PLANE_TRI_EPSILON {
            i += 1
            continue
        }

        d = _DotProduct(p3, vec3_t(planes[i].plane[0], planes[i].plane[1], planes[i].plane[2])) - planes[i].plane[3]
        if Double(d) < -PLANE_TRI_EPSILON || Double(d) > PLANE_TRI_EPSILON {
            i += 1
            continue
        }

        // found it
        return i
    }

    // add a new plane
    if numPlanes == MAX_PATCH_PLANES {
        Com_Error(ERR_DROP, "MAX_PATCH_PLANES")
    }

    planes[numPlanes].plane[0] = plane[0]
    planes[numPlanes].plane[1] = plane[1]
    planes[numPlanes].plane[2] = plane[2]
    planes[numPlanes].plane[3] = plane[3]
    planes[numPlanes].signbits = CM_SignbitsForNormal(vec3_t(plane[0], plane[1], plane[2]))

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
    let plane: Slots<Float>
    let d: Float

    if planeNum == -1 {
        return SIDE_ON
    }
    plane = planes[planeNum].plane

    d = _DotProduct(p, vec3_t(plane[0], plane[1], plane[2])) - plane[3]

    if Double(d) > PLANE_TRI_EPSILON {
        return SIDE_FRONT
    }

    if Double(d) < -PLANE_TRI_EPSILON {
        return SIDE_BACK
    }

    return SIDE_ON
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:592
private func CM_GridPlane(_ gridPlanes: [[[Int32]]], _ i: Int32, _ j: Int32, _ tri: Int32) -> Int32 {
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
private func CM_EdgePlaneNum(_ grid: CGrid, _ gridPlanes: [[[Int32]]], _ i: Int32, _ j: Int32, _ k: Int32) -> Int32 {
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
private func CM_SetBorderInward(_ facet: Facet, _ grid: CGrid, _ gridPlanes: [[[Int32]]], _ i: Int32, _ j: Int32, _ which: Int32) {
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
    var plane = vec4_t()
    var j: Int32
    var w: Winding?
    var bounds = [JKAShared.vec3_t](repeating: vec3_t(), count: 2)

    if facet.surfacePlane == -1 {
        return false
    }

    plane[0] = planes[facet.surfacePlane].plane[0]
    plane[1] = planes[facet.surfacePlane].plane[1]
    plane[2] = planes[facet.surfacePlane].plane[2]
    plane[3] = planes[facet.surfacePlane].plane[3]
    w = BaseWindingForPlane(vec3_t(plane[0], plane[1], plane[2]), plane[3])
    j = 0
    while j < facet.numBorders && w != nil {
        if facet.borderPlanes[j] == -1 {
            FreeWinding(w!)
            return false
        }
        plane[0] = planes[facet.borderPlanes[j]].plane[0]
        plane[1] = planes[facet.borderPlanes[j]].plane[1]
        plane[2] = planes[facet.borderPlanes[j]].plane[2]
        plane[3] = planes[facet.borderPlanes[j]].plane[3]
        if facet.borderInward[j] == 0 {
            plane[0] = vec3_origin[0] - plane[0]
            plane[1] = vec3_origin[1] - plane[1]
            plane[2] = vec3_origin[2] - plane[2]
            plane[3] = -plane[3]
        }
        ChopWindingInPlace(&w, vec3_t(plane[0], plane[1], plane[2]), plane[3], 0.1)
        j += 1
    }

    if w == nil {
        return false // winding was completely chopped away
    }

    // see if the facet is unreasonably large
    // AI: Raven hands both elements of `bounds` to WindingBounds. The two elements go through two locals and store back, because Swift rejects two inout elements of one array in one call.
    var bounds0 = bounds[0]
    var bounds1 = bounds[1]
    WindingBounds(w!, &bounds0, &bounds1)
    bounds[0] = bounds0
    bounds[1] = bounds1
    FreeWinding(w!)

    j = 0
    while j < 3 {
        if bounds[1][j] - bounds[0][j] > MAX_MAP_BOUNDS {
            return false // we must be missing a plane
        }
        if bounds[0][j] >= MAX_MAP_BOUNDS {
            return false
        }
        if bounds[1][j] <= -MAX_MAP_BOUNDS {
            return false
        }
        j += 1
    }
    return true // winding is fine
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

    var i: Int32
    var j: Int32
    var k: Int32
    var l: Int32
    var axis: Int32
    var dir: Int32
    var order: Int32
    var flipped: Int32 = 0
    var plane = vec4_t()
    var d: Float
    var newplane = vec4_t()
    var w: Winding?
    var w2: Winding?
    var mins = vec3_t()
    var maxs = vec3_t()
    var vec = vec3_t()
    var vec2 = vec3_t()

    plane[0] = planes[facet.surfacePlane].plane[0]
    plane[1] = planes[facet.surfacePlane].plane[1]
    plane[2] = planes[facet.surfacePlane].plane[2]
    plane[3] = planes[facet.surfacePlane].plane[3]

    w = BaseWindingForPlane(vec3_t(plane[0], plane[1], plane[2]), plane[3])
    j = 0
    while j < facet.numBorders && w != nil {
        if facet.borderPlanes[j] == facet.surfacePlane {
            j += 1
            continue
        }
        plane[0] = planes[facet.borderPlanes[j]].plane[0]
        plane[1] = planes[facet.borderPlanes[j]].plane[1]
        plane[2] = planes[facet.borderPlanes[j]].plane[2]
        plane[3] = planes[facet.borderPlanes[j]].plane[3]

        if facet.borderInward[j] == 0 {
            plane[0] = vec3_origin[0] - plane[0]
            plane[1] = vec3_origin[1] - plane[1]
            plane[2] = vec3_origin[2] - plane[2]
            plane[3] = -plane[3]
        }

        ChopWindingInPlace(&w, vec3_t(plane[0], plane[1], plane[2]), plane[3], 0.1)
        j += 1
    }
    if w == nil {
        return
    }

    WindingBounds(w!, &mins, &maxs)

    // add the axial planes
    order = 0
    axis = 0
    while axis < 3 {
        dir = -1
        while dir <= 1 {
            plane[0] = 0
            plane[1] = 0
            plane[2] = 0
            plane[axis] = Float(dir)
            if dir == 1 {
                plane[3] = maxs[axis]
            } else {
                plane[3] = -mins[axis]
            }
            //if it's the surface plane
            if CM_PlaneEqual(planes[facet.surfacePlane], plane, &flipped) != 0 {
                dir += 2
                order += 1
                continue
            }
            // see if the plane is allready present
            i = 0
            while i < facet.numBorders {
                if CM_PlaneEqual(planes[facet.borderPlanes[i]], plane, &flipped) != 0 {
                    break
                }
                i += 1
            }

            if i == facet.numBorders {
                if facet.numBorders > 4 + 6 + 16 {
                    Com_Printf("ERROR: too many bevels\n")
                }
                facet.borderPlanes[facet.numBorders] = CM_FindPlane2(plane, &flipped)
                facet.borderNoAdjust[facet.numBorders] = false
                facet.borderInward[facet.numBorders] = flipped
                facet.numBorders += 1
            }
            dir += 2
            order += 1
        }
        axis += 1
    }
    //
    // add the edge bevels
    //
    // test the non-axial plane edges
    j = 0
    while j < w!.numpoints {
        k = (j + 1) % w!.numpoints
        vec = w!.p[j] - w!.p[k]
        //if it's a degenerate edge
        if Double(VectorNormalize(&vec)) < 0.5 {
            j += 1
            continue
        }
        CM_SnapVector(&vec)
        k = 0
        while k < 3 {
            if vec[k] == -1 || vec[k] == 1 {
                break // axial
            }
            k += 1
        }
        if k < 3 {
            j += 1
            continue // only test non-axial edges
        }

        // try the six possible slanted axials from this edge
        axis = 0
        while axis < 3 {
            dir = -1
            while dir <= 1 {
                // construct a plane
                vec2 = vec3_t()
                vec2[axis] = Float(dir)
                // AI: Raven builds the normal in the first three floats of the `vec4_t` and normalizes it in place.
                // The normal goes through a `vec3_t` and back into `plane` before the test, the form of CM_PlaneFromPoints.
                var normal = vec3_t()
                CrossProduct(vec, vec2, &normal)
                let length = VectorNormalize(&normal)
                plane[0] = normal[0]
                plane[1] = normal[1]
                plane[2] = normal[2]
                if Double(length) < 0.5 {
                    dir += 2
                    continue
                }
                plane[3] = _DotProduct(w!.p[j], vec3_t(plane[0], plane[1], plane[2]))

                // if all the points of the facet winding are
                // behind this plane, it is a proper edge bevel
                l = 0
                while l < w!.numpoints {
                    d = _DotProduct(w!.p[l], vec3_t(plane[0], plane[1], plane[2])) - plane[3]
                    if Double(d) > 0.1 {
                        break // point in front
                    }
                    l += 1
                }
                if l < w!.numpoints {
                    dir += 2
                    continue
                }

                //if it's the surface plane
                if CM_PlaneEqual(planes[facet.surfacePlane], plane, &flipped) != 0 {
                    dir += 2
                    continue
                }
                // see if the plane is allready present
                i = 0
                while i < facet.numBorders {
                    if CM_PlaneEqual(planes[facet.borderPlanes[i]], plane, &flipped) != 0 {
                        break
                    }
                    i += 1
                }

                if i == facet.numBorders {
                    if facet.numBorders > 4 + 6 + 16 {
                        Com_Printf("ERROR: too many bevels\n")
                    }
                    facet.borderPlanes[facet.numBorders] = CM_FindPlane2(plane, &flipped)

                    k = 0
                    while k < facet.numBorders {
                        if facet.borderPlanes[facet.numBorders] == facet.borderPlanes[k] {
                            Com_Printf("WARNING: bevel plane already used\n")
                        }
                        k += 1
                    }

                    facet.borderNoAdjust[facet.numBorders] = false
                    facet.borderInward[facet.numBorders] = flipped
                    //
                    w2 = CopyWinding(w!)
                    newplane[0] = planes[facet.borderPlanes[facet.numBorders]].plane[0]
                    newplane[1] = planes[facet.borderPlanes[facet.numBorders]].plane[1]
                    newplane[2] = planes[facet.borderPlanes[facet.numBorders]].plane[2]
                    newplane[3] = planes[facet.borderPlanes[facet.numBorders]].plane[3]
                    if facet.borderInward[facet.numBorders] == 0 {
                        newplane[0] = -newplane[0]
                        newplane[1] = -newplane[1]
                        newplane[2] = -newplane[2]
                        newplane[3] = -newplane[3]
                    } //end if
                    ChopWindingInPlace(&w2, vec3_t(newplane[0], newplane[1], newplane[2]), newplane[3], 0.1)
                    if w2 == nil {
                        Com_DPrintf("WARNING: CM_AddFacetBevels... invalid bevel\n")
                        dir += 2
                        continue
                    } else {
                        FreeWinding(w2!)
                    }
                    //
                    facet.numBorders += 1
                    //already got a bevel
                    //					break;
                }
                dir += 2
            }
            axis += 1
        }
        j += 1
    }
    FreeWinding(w!)

    //add opposite plane
    facet.borderPlanes[facet.numBorders] = facet.surfacePlane
    facet.borderNoAdjust[facet.numBorders] = false
    facet.borderInward[facet.numBorders] = 1
    facet.numBorders += 1

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
    var i: Int32
    var j: Int32
    var p1: JKAShared.vec3_t
    var p2: JKAShared.vec3_t
    var p3: JKAShared.vec3_t
    var gridPlanes = [[[Int32]]](repeating: [[Int32]](repeating: [Int32](repeating: 0, count: 2), count: MAX_GRID_SIZE), count: MAX_GRID_SIZE)
    var facet: Facet
    var borders = [Int32](repeating: 0, count: 4)
    var noAdjust = [Int32](repeating: 0, count: 4)

    var numFacets: Int32
    facets = Slots<Facet>(Z_Malloc(MAX_FACETS * Int32(Facet.byteCount), TAG_TEMP_WORKSPACE, false, 4), count: MAX_FACETS)

    numPlanes = 0
    numFacets = 0

    // find the planes for each triangle of the grid
    i = 0
    while i < grid.width - 1 {
        j = 0
        while j < grid.height - 1 {
            p1 = grid.points[i][j]
            p2 = grid.points[i + 1][j]
            p3 = grid.points[i + 1][j + 1]
            gridPlanes[i][j][0] = CM_FindPlane(p1, p2, p3)

            p1 = grid.points[i + 1][j + 1]
            p2 = grid.points[i][j + 1]
            p3 = grid.points[i][j]
            gridPlanes[i][j][1] = CM_FindPlane(p1, p2, p3)
            j += 1
        }
        i += 1
    }

    // create the borders for each facet
    i = 0
    while i < grid.width - 1 {
        j = 0
        while j < grid.height - 1 {

            borders[EN_TOP] = -1
            if j > 0 {
                borders[EN_TOP] = gridPlanes[i][j - 1][1]
            } else if grid.wrapHeight {
                borders[EN_TOP] = gridPlanes[i][grid.height - 2][1]
            }
            noAdjust[EN_TOP] = (borders[EN_TOP] == gridPlanes[i][j][0]) ? 1 : 0
            if borders[EN_TOP] == -1 || noAdjust[EN_TOP] != 0 {
                borders[EN_TOP] = CM_EdgePlaneNum(grid, gridPlanes, i, j, 0)
            }

            borders[EN_BOTTOM] = -1
            if j < grid.height - 2 {
                borders[EN_BOTTOM] = gridPlanes[i][j + 1][0]
            } else if grid.wrapHeight {
                borders[EN_BOTTOM] = gridPlanes[i][0][0]
            }
            noAdjust[EN_BOTTOM] = (borders[EN_BOTTOM] == gridPlanes[i][j][1]) ? 1 : 0
            if borders[EN_BOTTOM] == -1 || noAdjust[EN_BOTTOM] != 0 {
                borders[EN_BOTTOM] = CM_EdgePlaneNum(grid, gridPlanes, i, j, 2)
            }

            borders[EN_LEFT] = -1
            if i > 0 {
                borders[EN_LEFT] = gridPlanes[i - 1][j][0]
            } else if grid.wrapWidth {
                borders[EN_LEFT] = gridPlanes[grid.width - 2][j][0]
            }
            noAdjust[EN_LEFT] = (borders[EN_LEFT] == gridPlanes[i][j][1]) ? 1 : 0
            if borders[EN_LEFT] == -1 || noAdjust[EN_LEFT] != 0 {
                borders[EN_LEFT] = CM_EdgePlaneNum(grid, gridPlanes, i, j, 3)
            }

            borders[EN_RIGHT] = -1
            if i < grid.width - 2 {
                borders[EN_RIGHT] = gridPlanes[i + 1][j][1]
            } else if grid.wrapWidth {
                borders[EN_RIGHT] = gridPlanes[0][j][1]
            }
            noAdjust[EN_RIGHT] = (borders[EN_RIGHT] == gridPlanes[i][j][0]) ? 1 : 0
            if borders[EN_RIGHT] == -1 || noAdjust[EN_RIGHT] != 0 {
                borders[EN_RIGHT] = CM_EdgePlaneNum(grid, gridPlanes, i, j, 1)
            }

            if numFacets == MAX_FACETS {
                Com_Error(ERR_DROP, "MAX_FACETS")
            }
            facet = facets![numFacets]
            facet.clear()

            if gridPlanes[i][j][0] == gridPlanes[i][j][1] {
                if gridPlanes[i][j][0] == -1 {
                    j += 1
                    continue // degenrate
                }
                facet.surfacePlane = gridPlanes[i][j][0]
                facet.numBorders = 4
                facet.borderPlanes[0] = borders[EN_TOP]
                facet.borderNoAdjust[0] = noAdjust[EN_TOP] != 0
                facet.borderPlanes[1] = borders[EN_RIGHT]
                facet.borderNoAdjust[1] = noAdjust[EN_RIGHT] != 0
                facet.borderPlanes[2] = borders[EN_BOTTOM]
                facet.borderNoAdjust[2] = noAdjust[EN_BOTTOM] != 0
                facet.borderPlanes[3] = borders[EN_LEFT]
                facet.borderNoAdjust[3] = noAdjust[EN_LEFT] != 0
                CM_SetBorderInward(facet, grid, gridPlanes, i, j, -1)
                if CM_ValidateFacet(facet) {
                    CM_AddFacetBevels(facet)
                    numFacets += 1
                }
            } else {
                // two seperate triangles
                facet.surfacePlane = gridPlanes[i][j][0]
                facet.numBorders = 3
                facet.borderPlanes[0] = borders[EN_TOP]
                facet.borderNoAdjust[0] = noAdjust[EN_TOP] != 0
                facet.borderPlanes[1] = borders[EN_RIGHT]
                facet.borderNoAdjust[1] = noAdjust[EN_RIGHT] != 0
                facet.borderPlanes[2] = gridPlanes[i][j][1]
                if facet.borderPlanes[2] == -1 {
                    facet.borderPlanes[2] = borders[EN_BOTTOM]
                    if facet.borderPlanes[2] == -1 {
                        facet.borderPlanes[2] = CM_EdgePlaneNum(grid, gridPlanes, i, j, 4)
                    }
                }
                CM_SetBorderInward(facet, grid, gridPlanes, i, j, 0)
                if CM_ValidateFacet(facet) {
                    CM_AddFacetBevels(facet)
                    numFacets += 1
                }

                if numFacets == MAX_FACETS {
                    Com_Error(ERR_DROP, "MAX_FACETS")
                }
                facet = facets![numFacets]
                facet.clear()

                facet.surfacePlane = gridPlanes[i][j][1]
                facet.numBorders = 3
                facet.borderPlanes[0] = borders[EN_BOTTOM]
                facet.borderNoAdjust[0] = noAdjust[EN_BOTTOM] != 0
                facet.borderPlanes[1] = borders[EN_LEFT]
                facet.borderNoAdjust[1] = noAdjust[EN_LEFT] != 0
                facet.borderPlanes[2] = gridPlanes[i][j][0]
                if facet.borderPlanes[2] == -1 {
                    facet.borderPlanes[2] = borders[EN_TOP]
                    if facet.borderPlanes[2] == -1 {
                        facet.borderPlanes[2] = CM_EdgePlaneNum(grid, gridPlanes, i, j, 5)
                    }
                }
                CM_SetBorderInward(facet, grid, gridPlanes, i, j, 1)
                if CM_ValidateFacet(facet) {
                    CM_AddFacetBevels(facet)
                    numFacets += 1
                }
            }
            j += 1
        }
        i += 1
    }

    // copy the results out
    pf.numPlanes = numPlanes
    pf.numFacets = numFacets
    if numFacets != 0 {
        pf.facets = Facet(Hunk_Alloc(numFacets * Int32(Facet.byteCount), h_high))
        Com_Memcpy(pf.facets!, facets![0], numFacets * Int32(Facet.byteCount))
    } else {
        pf.facets = nil
    }
    pf.planes = PatchPlane(Hunk_Alloc(numPlanes * Int32(PatchPlane.byteCount), h_high))
    Com_Memcpy(pf.planes!, planes[0], numPlanes * Int32(PatchPlane.byteCount))

    Z_Free(facets![0].handle)
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
func CM_GeneratePatchCollide(_ width: Int32, _ height: Int32, _ points: [JKAShared.vec3_t]) -> PatchCollide? {
    return CGrid.scratch { grid -> PatchCollide? in
        let pf: PatchCollide
        var i: Int32
        var j: Int32

        if width <= 2 || height <= 2 {
            // Port-note: The format prints `points` with `%p`, which the format subset does not read, and the port holds no address for `points`.
            // Raven wrote: Com_Error( ERR_DROP, "CM_GeneratePatchFacets: bad parameters: (%i, %i, %p)", width, height, points );
            portMissing("CM_GeneratePatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1163")
        }

        if (width & 1) == 0 || (height & 1) == 0 {
            Com_Error(ERR_DROP, "CM_GeneratePatchFacets: even sizes are invalid for quadratic meshes")
        }

        if width > MAX_GRID_SIZE || height > MAX_GRID_SIZE {
            Com_Error(ERR_DROP, "CM_GeneratePatchFacets: source is > MAX_GRID_SIZE")
        }

        // build a grid
        grid.width = width
        grid.height = height
        grid.wrapWidth = false
        grid.wrapHeight = false
        i = 0
        while i < width {
            j = 0
            while j < height {
                grid.points[i][j] = points[j * width + i]
                j += 1
            }
            i += 1
        }

        // subdivide the grid
        CM_SetGridWrapWidth(grid)
        CM_SubdivideGridColumns(grid)
        CM_RemoveDegenerateColumns(grid)

        CM_TransposeGrid(grid)

        CM_SetGridWrapWidth(grid)
        CM_SubdivideGridColumns(grid)
        CM_RemoveDegenerateColumns(grid)

        // we now have a grid of points exactly on the curve
        // the aproximate surface defined by these points will be
        // collided against
        pf = PatchCollide(Hunk_Alloc(Int32(PatchCollide.byteCount), h_high))
        ClearBounds(&pf.bounds[0], &pf.bounds[1])
        i = 0
        while i < grid.width {
            j = 0
            while j < grid.height {
                AddPointToBounds(grid.points[i][j], &pf.bounds[0], &pf.bounds[1])
                j += 1
            }
            i += 1
        }

        c_totalPatchBlocks += (grid.width - 1) * (grid.height - 1)

        // generate a bsp tree for the surface
        CM_PatchCollideFromGrid(grid, pf)

        // expand by one unit for epsilon purposes
        pf.bounds[0][0] -= 1
        pf.bounds[0][1] -= 1
        pf.bounds[0][2] -= 1

        pf.bounds[1][0] += 1
        pf.bounds[1][1] += 1
        pf.bounds[1][2] += 1

        return pf
    }
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:1256
var cv_CM_TracePointThroughPatchCollide: Cvar? {
    get { world.cv_CM_TracePointThroughPatchCollide }
    set { world.cv_CM_TracePointThroughPatchCollide = newValue }
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
    var frontFacing = [Bool](repeating: false, count: MAX_PATCH_PLANES)
    var intersection = [Float](repeating: 0, count: MAX_PATCH_PLANES)
    var intersect: Float
    var planes: PatchPlane
    var facet: Facet
    var i: Int32
    var j: Int32
    var k: Int32
    var offset: Float
    var d1: Float
    var d2: Float

    if cm_playerCurveClip!.integer == 0 || !tw.isPoint {
        return
    }

    // determine the trace's relationship to all planes
    i = 0
    while i < pc.numPlanes {
        planes = pc.planesSlots[i]
        offset = _DotProduct(tw.offsets[planes.signbits], vec3_t(planes.plane[0], planes.plane[1], planes.plane[2]))
        d1 = _DotProduct(tw.start, vec3_t(planes.plane[0], planes.plane[1], planes.plane[2])) - planes.plane[3] + offset
        d2 = _DotProduct(tw.end, vec3_t(planes.plane[0], planes.plane[1], planes.plane[2])) - planes.plane[3] + offset
        if d1 <= 0 {
            frontFacing[i] = false
        } else {
            frontFacing[i] = true
        }
        if d1 == d2 {
            intersection[i] = 99999
        } else {
            intersection[i] = d1 / (d1 - d2)
            if intersection[i] <= 0 {
                intersection[i] = 99999
            }
        }
        i += 1
    }


    // see if any of the surface planes are intersected
    i = 0
    while i < pc.numFacets {
        facet = pc.facetsSlots[i]
        if !frontFacing[facet.surfacePlane] {
            i += 1
            continue
        }
        intersect = intersection[facet.surfacePlane]
        if intersect < 0 {
            i += 1
            continue // surface is behind the starting point
        }
        if intersect > trace.fraction {
            i += 1
            continue // already hit something closer
        }
        j = 0
        while j < facet.numBorders {
            k = facet.borderPlanes[j]
            if ((frontFacing[k] ? 1 : 0) ^ facet.borderInward[j]) != 0 {
                if intersection[k] > intersect {
                    break
                }
            } else {
                if intersection[k] < intersect {
                    break
                }
            }
            j += 1
        }
        if j == facet.numBorders {
            // we hit this facet
            // Port-note: The static local `cv` has no storage.
            // Raven wrote: if (!cv) { cv = Cvar_Get( "r_debugSurfaceUpdate", "1", 0 ); }
            portMissing("CM_TracePointThroughPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1246")
            // Port-note: The static local `cv` has no storage.
            // Raven wrote: if (cv->integer) { debugPatchCollide = pc; debugFacet = facet; }
            portMissing("CM_TracePointThroughPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1246")
            planes = pc.planesSlots[facet.surfacePlane]

            // calculate intersection with a slight pushoff
            offset = _DotProduct(tw.offsets[planes.signbits], vec3_t(planes.plane[0], planes.plane[1], planes.plane[2]))
            d1 = _DotProduct(tw.start, vec3_t(planes.plane[0], planes.plane[1], planes.plane[2])) - planes.plane[3] + offset
            d2 = _DotProduct(tw.end, vec3_t(planes.plane[0], planes.plane[1], planes.plane[2])) - planes.plane[3] + offset
            trace.fraction = Float((Double(d1) - SURFACE_CLIP_EPSILON) / Double(d1 - d2))

            if trace.fraction < 0 {
                trace.fraction = 0
            }

            trace.plane.normal = vec3_t(planes.plane[0], planes.plane[1], planes.plane[2])
            trace.plane.dist = planes.plane[3]
        }
        i += 1
    }
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

    d1 = _DotProduct(start, vec3_t(plane[0], plane[1], plane[2])) - plane[3]
    d2 = _DotProduct(end, vec3_t(plane[0], plane[1], plane[2])) - plane[3]

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

/// Source: oracle/codemp/qcommon/cm_patch.cpp:1401
var cv_CM_TraceThroughPatchCollide: Cvar? {
    get { world.cv_CM_TraceThroughPatchCollide }
    set { world.cv_CM_TraceThroughPatchCollide = newValue }
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
    var i: Int32
    var j: Int32
    var hit: Int32 = 0
    var hitnum: Int32
    var offset: Float
    var enterFrac: Float
    var leaveFrac: Float
    var t: Float
    var planes: PatchPlane
    var facet: Facet
    var plane = vec4_t()
    var bestplane = vec4_t()
    var startp = vec3_t()
    var endp = vec3_t()

    // I'm not sure if test is strictly correct.  Are all
    // bboxes axis aligned?  Do I care?  It seems to work
    // good enough...
    i = 0
    while i < 3 {
        if tw.bounds[0][i] > pc.bounds[1][i]
            || tw.bounds[1][i] < pc.bounds[0][i] {
            return
        }
        i += 1
    }

    if tw.isPoint {
        CM_TracePointThroughPatchCollide(tw, trace, pc)
        return
    }
    //
    i = 0
    while i < pc.numFacets {
        facet = pc.facetsSlots[i]
        enterFrac = -1.0
        leaveFrac = 1.0
        hitnum = -1
        //
        planes = pc.planesSlots[facet.surfacePlane]
        plane[0] = planes.plane[0]
        plane[1] = planes.plane[1]
        plane[2] = planes.plane[2]
        plane[3] = planes.plane[3]
        if tw.sphere.use {
            // adjust the plane distance apropriately for radius
            plane[3] += tw.sphere.radius

            // find the closest point on the capsule to the plane
            t = _DotProduct(vec3_t(plane[0], plane[1], plane[2]), tw.sphere.offset)
            if t > 0.0 {
                startp = tw.start - tw.sphere.offset
                endp = tw.end - tw.sphere.offset
            } else {
                startp = tw.start + tw.sphere.offset
                endp = tw.end + tw.sphere.offset
            }
        } else {
            offset = _DotProduct(tw.offsets[planes.signbits], vec3_t(plane[0], plane[1], plane[2]))
            plane[3] -= offset
            startp = tw.start
            endp = tw.end
        }
        //
        if CM_CheckFacetPlane(plane, startp, endp, &enterFrac, &leaveFrac, &hit) == 0 {
            i += 1
            continue
        }
        if hit != 0 {
            bestplane = plane
        }
        //
        j = 0
        while j < facet.numBorders {
            planes = pc.planesSlots[facet.borderPlanes[j]]
            if facet.borderInward[j] != 0 {
                plane[0] = -planes.plane[0]
                plane[1] = -planes.plane[1]
                plane[2] = -planes.plane[2]
                plane[3] = -planes.plane[3]
            } else {
                plane[0] = planes.plane[0]
                plane[1] = planes.plane[1]
                plane[2] = planes.plane[2]
                plane[3] = planes.plane[3]
            }
            if tw.sphere.use {
                // adjust the plane distance apropriately for radius
                plane[3] += tw.sphere.radius

                // find the closest point on the capsule to the plane
                t = _DotProduct(vec3_t(plane[0], plane[1], plane[2]), tw.sphere.offset)
                if t > 0.0 {
                    startp = tw.start - tw.sphere.offset
                    endp = tw.end - tw.sphere.offset
                } else {
                    startp = tw.start + tw.sphere.offset
                    endp = tw.end + tw.sphere.offset
                }
            } else {
                // NOTE: this works even though the plane might be flipped because the bbox is centered
                offset = _DotProduct(tw.offsets[planes.signbits], vec3_t(plane[0], plane[1], plane[2]))
                plane[3] = Float(Double(plane[3]) + abs(Double(offset)))
                startp = tw.start
                endp = tw.end
            }
            //
            if CM_CheckFacetPlane(plane, startp, endp, &enterFrac, &leaveFrac, &hit) == 0 {
                break
            }
            if hit != 0 {
                hitnum = j
                bestplane = plane
            }
            j += 1
        }
        if j < facet.numBorders {
            i += 1
            continue
        }
        //never clip against the back side
        if hitnum == facet.numBorders - 1 {
            i += 1
            continue
        }
        //
        if enterFrac < leaveFrac && enterFrac >= 0 {
            if enterFrac < trace.fraction {
                if enterFrac < 0 {
                    enterFrac = 0
                }
                // Port-note: The static local `cv` has no storage.
                // Raven wrote: if (!cv) { cv = Cvar_Get( "r_debugSurfaceUpdate", "1", 0 ); }
                portMissing("CM_TraceThroughPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1392")
                // Port-note: The static local `cv` has no storage.
                // Raven wrote: if (cv && cv->integer) { debugPatchCollide = pc; debugFacet = facet; }
                portMissing("CM_TraceThroughPatchCollide", source: "oracle/codemp/qcommon/cm_patch.cpp:1392")

                trace.fraction = enterFrac
                trace.plane.normal = vec3_t(bestplane[0], bestplane[1], bestplane[2])
                trace.plane.dist = bestplane[3]
            }
        }
        i += 1
    }
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
    var i: Int32
    var j: Int32
    var offset: Float
    var t: Float
    var planes: PatchPlane
    var facet: Facet
    var plane = vec4_t()
    var startp = vec3_t()

    if tw.isPoint {
        return false
    }
    //
    i = 0
    while i < pc.numFacets {
        facet = pc.facetsSlots[i]
        planes = pc.planesSlots[facet.surfacePlane]
        plane[0] = planes.plane[0]
        plane[1] = planes.plane[1]
        plane[2] = planes.plane[2]
        plane[3] = planes.plane[3]
        if tw.sphere.use {
            // adjust the plane distance apropriately for radius
            plane[3] += tw.sphere.radius

            // find the closest point on the capsule to the plane
            t = _DotProduct(vec3_t(plane[0], plane[1], plane[2]), tw.sphere.offset)
            if t > 0 {
                startp = tw.start - tw.sphere.offset
            } else {
                startp = tw.start + tw.sphere.offset
            }
        } else {
            offset = _DotProduct(tw.offsets[planes.signbits], vec3_t(plane[0], plane[1], plane[2]))
            plane[3] -= offset
            startp = tw.start
        }

        if _DotProduct(vec3_t(plane[0], plane[1], plane[2]), startp) - plane[3] > 0.0 {
            i += 1
            continue
        }

        j = 0
        while j < facet.numBorders {
            planes = pc.planesSlots[facet.borderPlanes[j]]
            if facet.borderInward[j] != 0 {
                plane[0] = -planes.plane[0]
                plane[1] = -planes.plane[1]
                plane[2] = -planes.plane[2]
                plane[3] = -planes.plane[3]
            } else {
                plane[0] = planes.plane[0]
                plane[1] = planes.plane[1]
                plane[2] = planes.plane[2]
                plane[3] = planes.plane[3]
            }
            if tw.sphere.use {
                // adjust the plane distance apropriately for radius
                plane[3] += tw.sphere.radius

                // find the closest point on the capsule to the plane
                t = _DotProduct(vec3_t(plane[0], plane[1], plane[2]), tw.sphere.offset)
                if t > 0.0 {
                    startp = tw.start - tw.sphere.offset
                } else {
                    startp = tw.start + tw.sphere.offset
                }
            } else {
                // NOTE: this works even though the plane might be flipped because the bbox is centered
                offset = _DotProduct(tw.offsets[planes.signbits], vec3_t(plane[0], plane[1], plane[2]))
                plane[3] = Float(Double(plane[3]) + abs(Double(offset)))
                startp = tw.start
            }

            if _DotProduct(vec3_t(plane[0], plane[1], plane[2]), startp) - plane[3] > 0.0 {
                break
            }
            j += 1
        }
        if j < facet.numBorders {
            i += 1
            continue

        }
        // inside this patch facet
        return true
    }

    return false
}

/// Source: oracle/codemp/qcommon/cm_patch.cpp:1651
func CM_DrawDebugSurface(_ drawPoly: ((Int32, Int32, inout Float) -> Void)?) {
    // The renderer's R_DebugGraphics is the one caller, and the dedicated build never draws, so it is dead.
    // TODO: Port CM_DrawDebugSurface
    portMissing("CM_DrawDebugSurface", source: "oracle/codemp/qcommon/cm_patch.cpp:1651")
}
