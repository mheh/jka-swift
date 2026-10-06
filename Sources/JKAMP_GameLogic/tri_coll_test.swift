import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/tri_coll_test.c:23
let USE_EPSILON_TEST = 1 as Int32

/// Source: oracle/codemp/game/tri_coll_test.c:24
let EPSILON = 0.000001 as Double

/// This writes the cross product of `v1` and `v2` into `dest`.
/// Source: oracle/codemp/game/tri_coll_test.c:28
private func CROSS(_ dest: inout JKAShared.vec3_t, _ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) {
    dest[0] = v1[1] * v2[2] - v1[2] * v2[1]
    dest[1] = v1[2] * v2[0] - v1[0] * v2[2]
    dest[2] = v1[0] * v2[1] - v1[1] * v2[0]
}

/// This returns the dot product of `v1` and `v2`.
/// Source: oracle/codemp/game/tri_coll_test.c:33
private func DOT(_ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) -> Float {
    return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2]
}

/// This writes `v1` minus `v2` into `dest`.
/// Source: oracle/codemp/game/tri_coll_test.c:35
private func SUB(_ dest: inout JKAShared.vec3_t, _ v1: JKAShared.vec3_t, _ v2: JKAShared.vec3_t) {
    dest[0] = v1[0] - v2[0]
    dest[1] = v1[1] - v2[1]
    dest[2] = v1[2] - v2[2]
}

/// This swaps the two elements of `isect` when the first is greater, so that the first is not greater than the second.
/// Raven's two arguments are the two elements of one array, so the function takes the array.
/// Source: oracle/codemp/game/tri_coll_test.c:41
private func SORT(_ isect: inout [Float]) {
    if isect[0] > isect[1] {
        var c: Float
        c = isect[0]
        isect[0] = isect[1]
        isect[1] = c
    }
}

/// This writes the two ends of the interval where one triangle crosses the line of intersection into the two elements of `isect`.
/// Raven's `isect0` and `isect1` are the two elements of one array, so the function takes the array.
/// Source: oracle/codemp/game/tri_coll_test.c:50
private func ISECT(_ VV0: Float, _ VV1: Float, _ VV2: Float, _ D0: Float, _ D1: Float, _ D2: Float, _ isect: inout [Float]) {
    isect[0] = VV0 + (VV1 - VV0) * D0 / (D0 - D1)
    isect[1] = VV0 + (VV2 - VV0) * D0 / (D0 - D2)
}

/// This writes the interval of one triangle on the line of intersection into the two elements of `isect`, and returns nil after it writes them.
/// When the triangles are coplanar, it returns the result of ``coplanar_tri_tri``, which Raven's macro returns out of the caller.
/// Raven's macro reads `N1`, `V0` to `V2`, and `U0` to `U2` from the caller, so they cross as the last seven parameters.
/// Source: oracle/codemp/game/tri_coll_test.c:55
private func COMPUTE_INTERVALS(_ VV0: Float, _ VV1: Float, _ VV2: Float, _ D0: Float, _ D1: Float, _ D2: Float, _ D0D1: Float, _ D0D2: Float, _ isect: inout [Float], _ N1: JKAShared.vec3_t, _ V0: JKAShared.vec3_t, _ V1: JKAShared.vec3_t, _ V2: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ U2: JKAShared.vec3_t) -> Bool? {
    if D0D1 > 0.0 {
        /* here we know that D0D2<=0.0 */
        /* that is D0, D1 are on the same side, D2 on the other or on the plane */
        ISECT(VV2, VV0, VV1, D2, D0, D1, &isect)
    } else if D0D2 > 0.0 {
        /* here we know that d0d1<=0.0 */
        ISECT(VV1, VV0, VV2, D1, D0, D2, &isect)
    } else if D1 * D2 > 0.0 || D0 != 0.0 {
        /* here we know that d0d1<=0.0 or that D0!=0.0 */
        ISECT(VV0, VV1, VV2, D0, D1, D2, &isect)
    } else if D1 != 0.0 {
        ISECT(VV1, VV0, VV2, D1, D0, D2, &isect)
    } else if D2 != 0.0 {
        ISECT(VV2, VV0, VV1, D2, D0, D1, &isect)
    } else {
        /* triangles are coplanar */
        return coplanar_tri_tri(N1, V0, V1, V2, U0, U1, U2)
    }
    return nil
}

/// This tests the edge from `V0` along `Ax` and `Ay` against the edge from `U0` to `U1`, on the axes `i0` and `i1`.
/// It returns true where Raven's macro returns 1 out of the caller.
/// Source: oracle/codemp/game/tri_coll_test.c:91
private func EDGE_EDGE_TEST(_ V0: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ i0: Int32, _ i1: Int32, _ Ax: Float, _ Ay: Float) -> Bool {
    // Raven declares these in EDGE_AGAINST_TRI_EDGES, and each test sets them before it reads them.
    let Bx: Float
    let By: Float
    let Cx: Float
    let Cy: Float
    let e: Float
    let d: Float
    let f: Float
    Bx = U0[i0] - U1[i0]
    By = U0[i1] - U1[i1]
    Cx = V0[i0] - U0[i0]
    Cy = V0[i1] - U0[i1]
    f = Ay * Bx - Ax * By
    d = By * Cx - Bx * Cy
    if (f > 0 && d >= 0 && d <= f) || (f < 0 && d <= 0 && d >= f) {
        e = Ax * Cy - Ay * Cx
        if f > 0 {
            if e >= 0 && e <= f {
                return true
            }
        } else {
            if e <= 0 && e >= f {
                return true
            }
        }
    }
    return false
}

/// This tests the edge from `V0` to `V1` against the three edges of the triangle `U0`, `U1`, `U2`, on the axes `i0` and `i1`.
/// It returns true where an ``EDGE_EDGE_TEST`` returns true, because Raven's macro returns 1 out of the caller there.
/// Source: oracle/codemp/game/tri_coll_test.c:111
private func EDGE_AGAINST_TRI_EDGES(_ V0: JKAShared.vec3_t, _ V1: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ U2: JKAShared.vec3_t, _ i0: Int32, _ i1: Int32) -> Bool {
    var Ax: Float
    var Ay: Float
    Ax = V1[i0] - V0[i0]
    Ay = V1[i1] - V0[i1]
    /* test edge U0,U1 against V0,V1 */
    if EDGE_EDGE_TEST(V0, U0, U1, i0, i1, Ax, Ay) {
        return true
    }
    /* test edge U1,U2 against V0,V1 */
    if EDGE_EDGE_TEST(V0, U1, U2, i0, i1, Ax, Ay) {
        return true
    }
    /* test edge U2,U1 against V0,V1 */
    if EDGE_EDGE_TEST(V0, U2, U0, i0, i1, Ax, Ay) {
        return true
    }
    return false
}

/// This tests if the point `V0` is inside the triangle `U0`, `U1`, `U2`, on the axes `i0` and `i1`.
/// It returns true where Raven's macro returns 1 out of the caller.
/// Source: oracle/codemp/game/tri_coll_test.c:124
private func POINT_IN_TRI(_ V0: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ U2: JKAShared.vec3_t, _ i0: Int32, _ i1: Int32) -> Bool {
    var a: Float
    var b: Float
    var c: Float
    let d0: Float
    let d1: Float
    let d2: Float
    /* is T1 completly inside T2? */
    /* check if V0 is inside tri(U0,U1,U2) */
    a = U1[i1] - U0[i1]
    b = -(U1[i0] - U0[i0])
    c = -a * U0[i0] - b * U0[i1]
    d0 = a * V0[i0] + b * V0[i1] + c

    a = U2[i1] - U1[i1]
    b = -(U2[i0] - U1[i0])
    c = -a * U1[i0] - b * U1[i1]
    d1 = a * V0[i0] + b * V0[i1] + c

    a = U0[i1] - U2[i1]
    b = -(U0[i0] - U2[i0])
    c = -a * U2[i0] - b * U2[i1]
    d2 = a * V0[i0] + b * V0[i1] + c
    if Double(d0 * d1) > 0.0 {
        if Double(d0 * d2) > 0.0 {
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/tri_coll_test.c:149
func coplanar_tri_tri(_ N: JKAShared.vec3_t, _ V0: JKAShared.vec3_t, _ V1: JKAShared.vec3_t, _ V2: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ U2: JKAShared.vec3_t) -> Bool {
    var A = vec3_t()
    var i0: Int16
    var i1: Int16
    /* first project onto an axis-aligned plane, that maximizes the area */
    /* of the triangles, compute indices: i0,i1. */
    A[0] = abs(N[0])
    A[1] = abs(N[1])
    A[2] = abs(N[2])
    if A[0] > A[1] {
        if A[0] > A[2] {
            i0 = 1 /* A[0] is greatest */
            i1 = 2
        } else {
            i0 = 0 /* A[2] is greatest */
            i1 = 1
        }
    } else { /* A[0]<=A[1] */
        if A[2] > A[1] {
            i0 = 0 /* A[2] is greatest */
            i1 = 1
        } else {
            i0 = 0 /* A[1] is greatest */
            i1 = 2
        }
    }

    /* test all edges of triangle 1 against the edges of triangle 2 */
    if EDGE_AGAINST_TRI_EDGES(V0, V1, U0, U1, U2, Int32(i0), Int32(i1)) {
        return 1 != 0
    }
    if EDGE_AGAINST_TRI_EDGES(V1, V2, U0, U1, U2, Int32(i0), Int32(i1)) {
        return 1 != 0
    }
    if EDGE_AGAINST_TRI_EDGES(V2, V0, U0, U1, U2, Int32(i0), Int32(i1)) {
        return 1 != 0
    }

    /* finally, test if tri1 is totally contained in tri2 or vice versa */
    if POINT_IN_TRI(V0, U0, U1, U2, Int32(i0), Int32(i1)) {
        return 1 != 0
    }
    if POINT_IN_TRI(U0, V0, V1, V2, Int32(i0), Int32(i1)) {
        return 1 != 0
    }

    return false
}

/// Source: oracle/codemp/game/tri_coll_test.c:198
func tri_tri_intersect(_ V0: JKAShared.vec3_t, _ V1: JKAShared.vec3_t, _ V2: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ U2: JKAShared.vec3_t) -> Bool {
    var E1 = vec3_t()
    var E2 = vec3_t()
    var N1 = vec3_t()
    var N2 = vec3_t()
    let d1: Float
    let d2: Float
    var du0: Float
    var du1: Float
    var du2: Float
    var dv0: Float
    var dv1: Float
    var dv2: Float
    var D = vec3_t()
    var isect1: [Float] = [Float](repeating: 0, count: 2)
    var isect2: [Float] = [Float](repeating: 0, count: 2)
    var du0du1: Float
    var du0du2: Float
    var dv0dv1: Float
    var dv0dv2: Float
    var index: Int16
    var vp0: Float
    var vp1: Float
    var vp2: Float
    var up0: Float
    var up1: Float
    var up2: Float
    let b: Float
    var c: Float
    var max: Float

    /* compute plane equation of triangle(V0,V1,V2) */
    SUB(&E1, V1, V0)
    SUB(&E2, V2, V0)
    CROSS(&N1, E1, E2)
    d1 = -DOT(N1, V0)
    /* plane equation 1: N1.X+d1=0 */

    /* put U0,U1,U2 into plane equation 1 to compute signed distances to the plane*/
    du0 = DOT(N1, U0) + d1
    du1 = DOT(N1, U1) + d1
    du2 = DOT(N1, U2) + d1

    /* coplanarity robustness check */
    if abs(Double(du0)) < EPSILON {
        du0 = 0.0
    }
    if abs(Double(du1)) < EPSILON {
        du1 = 0.0
    }
    if abs(Double(du2)) < EPSILON {
        du2 = 0.0
    }
    du0du1 = du0 * du1
    du0du2 = du0 * du2

    if du0du1 > 0.0 && du0du2 > 0.0 { /* same sign on all of them + not equal 0 ? */
        return 0 != 0 /* no intersection occurs */
    }

    /* compute plane of triangle (U0,U1,U2) */
    SUB(&E1, U1, U0)
    SUB(&E2, U2, U0)
    CROSS(&N2, E1, E2)
    d2 = -DOT(N2, U0)
    /* plane equation 2: N2.X+d2=0 */

    /* put V0,V1,V2 into plane equation 2 */
    dv0 = DOT(N2, V0) + d2
    dv1 = DOT(N2, V1) + d2
    dv2 = DOT(N2, V2) + d2

    if abs(Double(dv0)) < EPSILON {
        dv0 = 0.0
    }
    if abs(Double(dv1)) < EPSILON {
        dv1 = 0.0
    }
    if abs(Double(dv2)) < EPSILON {
        dv2 = 0.0
    }

    dv0dv1 = dv0 * dv1
    dv0dv2 = dv0 * dv2

    if dv0dv1 > 0.0 && dv0dv2 > 0.0 { /* same sign on all of them + not equal 0 ? */
        return 0 != 0 /* no intersection occurs */
    }

    /* compute direction of intersection line */
    CROSS(&D, N1, N2)

    /* compute and index to the largest component of D */
    max = abs(D[0])
    index = 0
    b = abs(D[1])
    c = abs(D[2])
    if b > max {
        max = b
        index = 1
    }
    if c > max {
        max = c
        index = 2
    }

    /* this is the simplified projection onto L*/
    vp0 = V0[Int32(index)]
    vp1 = V1[Int32(index)]
    vp2 = V2[Int32(index)]

    up0 = U0[Int32(index)]
    up1 = U1[Int32(index)]
    up2 = U2[Int32(index)]

    /* compute interval for triangle 1 */
    if let r = COMPUTE_INTERVALS(vp0, vp1, vp2, dv0, dv1, dv2, dv0dv1, dv0dv2, &isect1, N1, V0, V1, V2, U0, U1, U2) {
        return r
    }

    /* compute interval for triangle 2 */
    if let r = COMPUTE_INTERVALS(up0, up1, up2, du0, du1, du2, du0du1, du0du2, &isect2, N1, V0, V1, V2, U0, U1, U2) {
        return r
    }

    SORT(&isect1)
    SORT(&isect2)

    if isect1[1] < isect2[0] || isect2[1] < isect1[0] {
        return true
    }
    return false
}
