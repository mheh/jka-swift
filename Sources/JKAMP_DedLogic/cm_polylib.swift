import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:12
var c_active_windings: Int32 {
    get { world.variables.c_active_windings }
    set { world.variables.c_active_windings = newValue }
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:13
var c_peak_windings: Int32 {
    get { world.variables.c_peak_windings }
    set { world.variables.c_peak_windings = newValue }
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:14
var c_winding_allocs: Int32 {
    get { world.variables.c_winding_allocs }
    set { world.variables.c_winding_allocs = newValue }
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:15
var c_winding_points: Int32 {
    get { world.variables.c_winding_points }
    set { world.variables.c_winding_points = newValue }
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:62
var c_removed: Int32 {
    get { world.variables.c_removed }
    set { world.variables.c_removed = newValue }
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:625
let MAX_HULL_POINTS = 128 as Int32

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:17
func pw(_ w: Winding) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port pw
    portMissing("pw", source: "oracle/codemp/qcommon/cm_polylib.cpp:17")
}

/**
```
=============
AllocWinding
=============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:30
func AllocWinding(_ points: Int32) -> Winding? {
    var w: Winding?
    let s: Int32

    c_winding_allocs += 1
    c_winding_points += points
    c_active_windings += 1
    if c_active_windings > c_peak_windings {
        c_peak_windings = c_active_windings
    }

    // Port-note: No guide row gives the size of a `vec_t` or an `int` in a host body, and a body never writes `MemoryLayout`.
    // Raven wrote: s = sizeof(vec_t)*3*points + sizeof(int)
    portMissing("AllocWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:30")
    w = Winding(Z_Malloc(s, TAG_BSP, true))
    //	Com_Memset (w, 0, s); // qtrue param in Z_Malloc does this
    return w
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:47
func FreeWinding(_ w: Winding) {
    if w.numpoints == Int32(bitPattern: 0xdeaddead) {
        Com_Error(ERR_FATAL, "FreeWinding: freed a freed winding")
    }
    w.numpoints = Int32(bitPattern: 0xdeaddead)

    c_active_windings -= 1
    // AI: Raven hands the record pointer to Z_Free. The call hands the handle of the view, because Z_Free takes the raw address.
    Z_Free(w.handle)
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:64
func RemoveColinearPoints(_ w: Winding) {
    var i: Int32
    var j: Int32
    var k: Int32
    var v1 = vec3_t()
    var v2 = vec3_t()
    var nump: Int32
    var p = [vec3_t](repeating: vec3_t(), count: 64)

    nump = 0
    i = 0
    while i < w.numpoints {
        j = (i + 1) % w.numpoints
        k = (i + w.numpoints - 1) % w.numpoints
        v1 = w.p[j] - w.p[i]
        v2 = w.p[i] - w.p[k]
        VectorNormalize2(v1, &v1)
        VectorNormalize2(v2, &v2)
        if Double(_DotProduct(v1, v2)) < 0.999 {
            p[nump] = w.p[i]
            nump += 1
        }
        i += 1
    }

    if nump == w.numpoints {
        return
    }

    c_removed += w.numpoints - nump
    w.numpoints = nump
    // Port-note: `Com_Memcpy` takes two `Slots`, and the local `p` is a Swift array, so the copy has no form.
    // No guide row gives the size of a `vec3_t` either.
    // Raven wrote: Com_Memcpy (w->p, p, nump*sizeof(p[0]))
    portMissing("RemoveColinearPoints", source: "oracle/codemp/qcommon/cm_polylib.cpp:64")
}

/**
```
============
WindingPlane
============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:100
func WindingPlane(_ w: Winding, _ normal: inout JKAShared.vec3_t, _ dist: inout Float) {
    var v1 = vec3_t()
    var v2 = vec3_t()

    v1 = w.p[1] - w.p[0]
    v2 = w.p[2] - w.p[0]
    CrossProduct(v2, v1, &normal)
    VectorNormalize2(normal, &normal)
    dist = _DotProduct(w.p[0], normal)
}

/**
```
=============
WindingArea
=============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:117
func WindingArea(_ w: Winding) -> Float {
    var i: Int32
    var d1 = vec3_t()
    var d2 = vec3_t()
    var cross = vec3_t()
    var total: Float

    total = 0
    i = 2
    while i < w.numpoints {
        d1 = w.p[i - 1] - w.p[0]
        d2 = w.p[i] - w.p[0]
        CrossProduct(d1, d2, &cross)
        total = Float(Double(total) + (0.5 * Double(VectorLength(cross))))
        i += 1
    }
    return total
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:134
func WindingBounds(_ w: Winding, _ mins: inout JKAShared.vec3_t, _ maxs: inout JKAShared.vec3_t) {
    var v: Float
    var i: Int32
    var j: Int32

    mins[2] = Float(MAX_MAP_BOUNDS)
    mins[1] = mins[2]
    mins[0] = mins[1]
    maxs[2] = Float(-MAX_MAP_BOUNDS)
    maxs[1] = maxs[2]
    maxs[0] = maxs[1]

    i = 0
    while i < w.numpoints {
        j = 0
        while j < 3 {
            v = w.p[i][j]
            if v < mins[j] {
                mins[j] = v
            }
            if v > maxs[j] {
                maxs[j] = v
            }
            j += 1
        }
        i += 1
    }
}

/**
```
=============
WindingCenter
=============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:160
func WindingCenter(_ w: Winding, _ center: inout JKAShared.vec3_t) {
    var i: Int32
    let scale: Float

    center = vec3_origin
    i = 0
    while i < w.numpoints {
        center = w.p[i] + center
        i += 1
    }

    scale = Float(1.0 / Double(w.numpoints))
    center = center * scale
}

/**
```
=================
BaseWindingForPlane
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:178
func BaseWindingForPlane(_ normal: JKAShared.vec3_t, _ dist: Float) -> Winding? {
    var i: Int32
    var x: Int32
    var max: Float
    var v: Float
    var org = vec3_t()
    var vright = vec3_t()
    var vup = vec3_t()
    var w: Winding?

    // find the major axis

    max = Float(-MAX_MAP_BOUNDS)
    x = -1
    i = 0
    while i < 3 {
        v = abs(normal[i])
        if v > max {
            x = i
            max = v
        }
        i += 1
    }
    if x == -1 {
        Com_Error(ERR_DROP, "BaseWindingForPlane: no axis found")
    }

    vup = vec3_origin
    switch x {
    case 0, 1:
        vup[2] = 1

    case 2:
        vup[0] = 1

    default:
        break
    }

    v = _DotProduct(vup, normal)
    _VectorMA(vup, -v, normal, &vup)
    VectorNormalize2(vup, &vup)

    org = normal * dist

    CrossProduct(vup, normal, &vright)

    vup = vup * Float(MAX_MAP_BOUNDS)
    vright = vright * Float(MAX_MAP_BOUNDS)

    // project a really big	axis aligned box onto the plane
    w = AllocWinding(4)

    w!.p[0] = org - vright
    w!.p[0] = w!.p[0] + vup

    w!.p[1] = org + vright
    w!.p[1] = w!.p[1] + vup

    w!.p[2] = org + vright
    w!.p[2] = w!.p[2] - vup

    w!.p[3] = org - vright
    w!.p[3] = w!.p[3] - vup

    w!.numpoints = 4

    return w
}

/**
```
==================
CopyWinding
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:249
func CopyWinding(_ w: Winding) -> Winding? {
    var size: Int32
    var c: Winding?

    c = AllocWinding(w.numpoints)
    // Port-note: Raven sizes the record by the offset of `p[numpoints]`, and no guide row gives an offset into a record.
    // Raven wrote: size = (int)((winding_t *)0)->p[w->numpoints]
    portMissing("CopyWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:249")
    // Port-note: No `Com_Memcpy` overload copies a byte count between two views.
    // Raven wrote: Com_Memcpy (c, w, size)
    portMissing("CopyWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:249")
    return c
}

/**
```
==================
ReverseWinding
==================
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:265
func ReverseWinding(_ w: Winding) -> Winding? {
    var i: Int32
    var c: Winding?

    c = AllocWinding(w.numpoints)
    i = 0
    while i < w.numpoints {
        c!.p[i] = w.p[w.numpoints - 1 - i]
        i += 1
    }
    c!.numpoints = w.numpoints
    return c
}

/**
```
=============
ClipWindingEpsilon
=============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:285
func ClipWindingEpsilon(_ `in`: Winding, _ normal: JKAShared.vec3_t, _ dist: Float, _ epsilon: Float, _ front: inout Winding?, _ back: inout Winding?) {
    var dists: [Float] = [Float](repeating: 0, count: 68)
    var sides: [Int32] = [Int32](repeating: 0, count: 68)
    var counts: [Int32] = [Int32](repeating: 0, count: 3)
    var dot: Float
    var i: Int32
    var j: Int32
    var mid = vec3_t()
    var f: Winding?
    var b: Winding?
    let maxpts: Int32

    counts[2] = 0
    counts[1] = counts[2]
    counts[0] = counts[1]

    // determine sides for each point
    i = 0
    while i < `in`.numpoints {
        dot = _DotProduct(`in`.p[i], normal)
        dot -= dist
        dists[i] = dot
        if dot > epsilon {
            sides[i] = SIDE_FRONT
        } else if dot < -epsilon {
            sides[i] = SIDE_BACK
        } else {
            sides[i] = SIDE_ON
        }
        counts[sides[i]] += 1
        i += 1
    }
    sides[i] = sides[0]
    dists[i] = dists[0]

    back = nil
    front = back

    if counts[0] == 0 {
        back = CopyWinding(`in`)
        return
    }
    if counts[1] == 0 {
        front = CopyWinding(`in`)
        return
    }

    maxpts = `in`.numpoints + 4 // cant use counts[0]+2 because
    // of fp grouping errors

    f = AllocWinding(maxpts)
    front = f
    b = AllocWinding(maxpts)
    back = b

    i = 0
    while i < `in`.numpoints {
        if sides[i] == SIDE_ON {
            f!.p[f!.numpoints] = `in`.p[i]
            f!.numpoints += 1
            b!.p[b!.numpoints] = `in`.p[i]
            b!.numpoints += 1
            i += 1
            continue
        }

        if sides[i] == SIDE_FRONT {
            f!.p[f!.numpoints] = `in`.p[i]
            f!.numpoints += 1
        }
        if sides[i] == SIDE_BACK {
            b!.p[b!.numpoints] = `in`.p[i]
            b!.numpoints += 1
        }

        if sides[i + 1] == SIDE_ON || sides[i + 1] == sides[i] {
            i += 1
            continue
        }

        // generate a split point

        dot = dists[i] / (dists[i] - dists[i + 1])
        j = 0
        while j < 3 {
            // avoid round off error when possible
            if normal[j] == 1 {
                mid[j] = dist
            } else if normal[j] == -1 {
                mid[j] = -dist
            } else {
                mid[j] = `in`.p[i][j] + dot * (`in`.p[(i + 1) % `in`.numpoints][j] - `in`.p[i][j])
            }
            j += 1
        }

        f!.p[f!.numpoints] = mid
        f!.numpoints += 1
        b!.p[b!.numpoints] = mid
        b!.numpoints += 1
        i += 1
    }

    if f!.numpoints > maxpts || b!.numpoints > maxpts {
        Com_Error(ERR_DROP, "ClipWinding: points exceeded estimate")
    }
    if f!.numpoints > MAX_POINTS_ON_WINDING || b!.numpoints > MAX_POINTS_ON_WINDING {
        Com_Error(ERR_DROP, "ClipWinding: MAX_POINTS_ON_WINDING")
    }
}

/**
```
=============
ChopWindingInPlace
=============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:397
func ChopWindingInPlace(_ `inout`: inout Winding?, _ normal: JKAShared.vec3_t, _ dist: Float, _ epsilon: Float) {
    var `in`: Winding?
    var dists: [Float] = [Float](repeating: 0, count: 68)
    var sides: [Int32] = [Int32](repeating: 0, count: 68)
    var counts: [Int32] = [Int32](repeating: 0, count: 3)
    var dot: Float
    var i: Int32
    var j: Int32
    var mid = vec3_t()
    var f: Winding?
    let maxpts: Int32

    `in` = `inout`
    counts[2] = 0
    counts[1] = counts[2]
    counts[0] = counts[1]

    // determine sides for each point
    i = 0
    while i < `in`!.numpoints {
        dot = _DotProduct(`in`!.p[i], normal)
        dot -= dist
        dists[i] = dot
        if dot > epsilon {
            sides[i] = SIDE_FRONT
        } else if dot < -epsilon {
            sides[i] = SIDE_BACK
        } else {
            sides[i] = SIDE_ON
        }
        counts[sides[i]] += 1
        i += 1
    }
    sides[i] = sides[0]
    dists[i] = dists[0]

    if counts[0] == 0 {
        FreeWinding(`in`!)
        `inout` = nil
        return
    }
    if counts[1] == 0 {
        return // inout stays the same
    }

    maxpts = `in`!.numpoints + 4 // cant use counts[0]+2 because
    // of fp grouping errors

    f = AllocWinding(maxpts)

    i = 0
    while i < `in`!.numpoints {
        if sides[i] == SIDE_ON {
            f!.p[f!.numpoints] = `in`!.p[i]
            f!.numpoints += 1
            i += 1
            continue
        }

        if sides[i] == SIDE_FRONT {
            f!.p[f!.numpoints] = `in`!.p[i]
            f!.numpoints += 1
        }

        if sides[i + 1] == SIDE_ON || sides[i + 1] == sides[i] {
            i += 1
            continue
        }

        // generate a split point

        dot = dists[i] / (dists[i] - dists[i + 1])
        j = 0
        while j < 3 {
            // avoid round off error when possible
            if normal[j] == 1 {
                mid[j] = dist
            } else if normal[j] == -1 {
                mid[j] = -dist
            } else {
                mid[j] = `in`!.p[i][j] + dot * (`in`!.p[(i + 1) % `in`!.numpoints][j] - `in`!.p[i][j])
            }
            j += 1
        }

        f!.p[f!.numpoints] = mid
        f!.numpoints += 1
        i += 1
    }

    if f!.numpoints > maxpts {
        Com_Error(ERR_DROP, "ClipWinding: points exceeded estimate")
    }
    if f!.numpoints > MAX_POINTS_ON_WINDING {
        Com_Error(ERR_DROP, "ClipWinding: MAX_POINTS_ON_WINDING")
    }

    FreeWinding(`in`!)
    `inout` = f!
}

/**
```
=================
ChopWinding

Returns the fragment of in that is on the front side
of the cliping plane.  The original is freed.
=================
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:502
func ChopWinding(_ `in`: Winding, _ normal: JKAShared.vec3_t, _ dist: Float) -> Winding? {
    var f: Winding?
    var b: Winding?

    ClipWindingEpsilon(`in`, normal, dist, ON_EPSILON, &f, &b)
    FreeWinding(`in`)
    if b != nil {
        FreeWinding(b!)
    }
    return f
}

/**
```
=================
CheckWinding

=================
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:520
func CheckWinding(_ w: Winding) {
    var i: Int32
    var j: Int32
    var d: Float
    var edgedist: Float
    var dir = vec3_t()
    var edgenormal = vec3_t()
    var facenormal = vec3_t()
    let area: Float
    var facedist: Float = 0

    if w.numpoints < 3 {
        Com_Error(ERR_DROP, "CheckWinding: %i points", w.numpoints)
    }

    area = WindingArea(w)
    if area < 1 {
        Com_Error(ERR_DROP, "CheckWinding: %f area", area)
    }

    WindingPlane(w, &facenormal, &facedist)

    i = 0
    while i < w.numpoints {
        j = 0
        while j < 3 {
            if w.p[i][j] > MAX_MAP_BOUNDS || w.p[i][j] < -MAX_MAP_BOUNDS {
                Com_Error(ERR_DROP, "CheckFace: BUGUS_RANGE: %f", w.p[i][j])
            }
            j += 1
        }

        j = i + 1 == w.numpoints ? 0 : i + 1

        // check the point is on the face plane
        d = _DotProduct(w.p[i], facenormal) - facedist
        if d < -ON_EPSILON || d > ON_EPSILON {
            Com_Error(ERR_DROP, "CheckWinding: point off plane")
        }

        // check the edge isnt degenerate
        dir = w.p[j] - w.p[i]

        if VectorLength(dir) < ON_EPSILON {
            Com_Error(ERR_DROP, "CheckWinding: degenerate edge")
        }

        CrossProduct(facenormal, dir, &edgenormal)
        VectorNormalize2(edgenormal, &edgenormal)
        edgedist = _DotProduct(w.p[i], edgenormal)
        edgedist += ON_EPSILON

        // all other points must be on front side
        j = 0
        while j < w.numpoints {
            if j == i {
                j += 1
                continue
            }
            d = _DotProduct(w.p[j], edgenormal)
            if d > edgedist {
                Com_Error(ERR_DROP, "CheckWinding: non-convex")
            }
            j += 1
        }
        i += 1
    }
}

/**
```
============
WindingOnPlaneSide
============
```
*/
/// Source: oracle/codemp/qcommon/cm_polylib.cpp:583
func WindingOnPlaneSide(_ w: Winding, _ normal: JKAShared.vec3_t, _ dist: Float) -> Int32 {
    var front: Bool
    var back: Bool
    var i: Int32
    var d: Float

    front = false
    back = false
    i = 0
    while i < w.numpoints {
        d = _DotProduct(w.p[i], normal) - dist
        if d < -ON_EPSILON {
            if front {
                return SIDE_CROSS
            }
            back = true
            i += 1
            continue
        }
        if d > ON_EPSILON {
            if back {
                return SIDE_CROSS
            }
            front = true
            i += 1
            continue
        }
        i += 1
    }

    if back {
        return SIDE_BACK
    }
    if front {
        return SIDE_FRONT
    }
    return SIDE_ON
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:626
func AddWindingToConvexHull(_ w: Winding, _ hull: inout Winding?, _ normal: JKAShared.vec3_t) {
    var i: Int32
    var j: Int32
    var k: Int32
    var dir = vec3_t()
    var d: Float
    var numHullPoints: Int32
    var numNew: Int32
    var hullPoints = [vec3_t](repeating: vec3_t(), count: 128)
    var newHullPoints = [vec3_t](repeating: vec3_t(), count: 128)
    var hullDirs = [vec3_t](repeating: vec3_t(), count: 128)
    var hullSide: [Bool] = [Bool](repeating: false, count: 128)
    var outside: Bool
    // Raven assigns his own `w` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var w = w

    if hull == nil {
        hull = CopyWinding(w)
        return
    }

    numHullPoints = hull!.numpoints
    // Port-note: `Com_Memcpy` takes two `Slots`, and the local `hullPoints` is a Swift array, so the copy has no form.
    // No guide row gives the size of a `vec3_t` either.
    // Raven wrote: Com_Memcpy( hullPoints, (*hull)->p, numHullPoints * sizeof(vec3_t) )
    portMissing("AddWindingToConvexHull", source: "oracle/codemp/qcommon/cm_polylib.cpp:626")

    i = 0
    while i < w.numpoints {
        // calculate hull side vectors
        j = 0
        while j < numHullPoints {
            k = (j + 1) % numHullPoints

            dir = hullPoints[k] - hullPoints[j]
            VectorNormalize2(dir, &dir)
            CrossProduct(normal, dir, &hullDirs[j])
            j += 1
        }

        outside = false
        j = 0
        while j < numHullPoints {
            dir = w.p[i] - hullPoints[j]
            d = _DotProduct(dir, hullDirs[j])
            if d >= ON_EPSILON {
                outside = true
            }
            if d >= -ON_EPSILON {
                hullSide[j] = true
            } else {
                hullSide[j] = false
            }
            j += 1
        }

        // if the point is effectively inside, do nothing
        if !outside {
            i += 1
            continue
        }

        // find the back side to front side transition
        j = 0
        while j < numHullPoints {
            if !hullSide[j % numHullPoints] && hullSide[(j + 1) % numHullPoints] {
                break
            }
            j += 1
        }
        if j == numHullPoints {
            i += 1
            continue
        }

        // insert the point here
        newHullPoints[0] = w.p[i]
        numNew = 1

        // copy over all points that aren't double fronts
        j = (j + 1) % numHullPoints
        k = 0
        while k < numHullPoints {
            if hullSide[(j + k) % numHullPoints] && hullSide[(j + k + 1) % numHullPoints] {
                k += 1
                continue
            }
            newHullPoints[numNew] = hullPoints[(j + k + 1) % numHullPoints]
            numNew += 1
            k += 1
        }

        numHullPoints = numNew
        // Port-note: `Com_Memcpy` takes two `Slots`, and the locals `hullPoints` and `newHullPoints` are Swift arrays, so the copy has no form.
        // No guide row gives the size of a `vec3_t` either.
        // Raven wrote: Com_Memcpy( hullPoints, newHullPoints, numHullPoints * sizeof(vec3_t) )
        portMissing("AddWindingToConvexHull", source: "oracle/codemp/qcommon/cm_polylib.cpp:626")
        i += 1
    }

    FreeWinding(hull!)
    w = AllocWinding(numHullPoints)!
    w.numpoints = numHullPoints
    hull = w
    // Port-note: `Com_Memcpy` takes two `Slots`, and the local `hullPoints` is a Swift array, so the copy has no form.
    // No guide row gives the size of a `vec3_t` either.
    // Raven wrote: Com_Memcpy( w->p, hullPoints, numHullPoints * sizeof(vec3_t) )
    portMissing("AddWindingToConvexHull", source: "oracle/codemp/qcommon/cm_polylib.cpp:626")
}
