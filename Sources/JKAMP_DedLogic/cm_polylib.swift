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
    // Port-note: `Z_Malloc` takes its tag as a `memtag_t`, which is `CChar`, and `TAG_BSP` is an `Int32`.
    // The signature also has no default for `bZeroit` and `iAlign`, so `Z_Malloc (s, TAG_BSP, qtrue)` does not compile.
    // The `Z_Malloc` signature row of the `z_memman_pc` round owns the fix.
    // TODO: Port AllocWinding
    portMissing("AllocWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:30")
}

/// Source: oracle/codemp/qcommon/cm_polylib.cpp:47
func FreeWinding(_ w: Winding) {
    // Port-note: `Z_Free` takes an `OpaquePointer?`, and rule 11 keeps the handle of a view in generated code.
    // So `Z_Free (w)` has no form in a body, and the `z_memman_pc` round owns the `Z_Free` signature.
    // TODO: Port FreeWinding
    portMissing("FreeWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:47")
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
    // Port-note: The copy of `nump` points from the local array into `w.p` has no guide row, and `Com_Memcpy` takes `OpaquePointer?`.
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
    // Port-note: This body allocates through `AllocWinding`, so it waits on the `Z_Malloc` signature row with it.
    // TODO: Port BaseWindingForPlane
    portMissing("BaseWindingForPlane", source: "oracle/codemp/qcommon/cm_polylib.cpp:178")
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
    // Port-note: This body allocates through `AllocWinding`, so it waits on the `Z_Malloc` signature row with it.
    // TODO: Port CopyWinding
    portMissing("CopyWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:249")
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
    // Port-note: This body allocates through `AllocWinding`, so it waits on the `Z_Malloc` signature row with it.
    // TODO: Port ReverseWinding
    portMissing("ReverseWinding", source: "oracle/codemp/qcommon/cm_polylib.cpp:265")
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
    // Port-note: This body allocates through `AllocWinding`, so it waits on the `Z_Malloc` signature row with it.
    // TODO: Port ClipWindingEpsilon
    portMissing("ClipWindingEpsilon", source: "oracle/codemp/qcommon/cm_polylib.cpp:285")
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
    // Port-note: This body allocates through `AllocWinding`, so it waits on the `Z_Malloc` signature row with it.
    // TODO: Port ChopWindingInPlace
    portMissing("ChopWindingInPlace", source: "oracle/codemp/qcommon/cm_polylib.cpp:397")
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
    // Port-note: This body allocates through `AllocWinding`, so it waits on the `Z_Malloc` signature row with it.
    // TODO: Port AddWindingToConvexHull
    portMissing("AddWindingToConvexHull", source: "oracle/codemp/qcommon/cm_polylib.cpp:626")
}
