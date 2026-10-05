import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/tri_coll_test.c:23
let USE_EPSILON_TEST = 1 as Int32

/// Source: oracle/codemp/game/tri_coll_test.c:24
let EPSILON = 0.000001 as Double

/// Source: oracle/codemp/game/tri_coll_test.c:149
func coplanar_tri_tri(_ N: JKAShared.vec3_t, _ V0: JKAShared.vec3_t, _ V1: JKAShared.vec3_t, _ V2: JKAShared.vec3_t, _ U0: JKAShared.vec3_t, _ U1: JKAShared.vec3_t, _ U2: JKAShared.vec3_t) -> Bool {
    var A = vec3_t()
    var i0: Int16
    var i1: Int16
    // Raven assigns his own `V0` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var V0 = V0
    // Raven assigns his own `V1` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var V1 = V1
    // Raven assigns his own `V2` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var V2 = V2
    // Raven assigns his own `U0` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var U0 = U0
    // Raven assigns his own `U1` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var U1 = U1
    // Raven assigns his own `U2` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var U2 = U2
    /* first project onto an axis-aligned plane, that maximizes the area */
    /* of the triangles, compute indices: i0,i1. */
    A[0] = abs(N[0])
    A[1] = abs(N[1])
    A[2] = abs(N[2])
    if A[0] > A[1] {
        if A[0] > A[2] {
            i0 = 1
            i1 = 2
        } else {
            i0 = 0
            i1 = 1
        }
    } else {
        if A[2] > A[1] {
            i0 = 0
            i1 = 1
        } else {
            i0 = 0
            i1 = 2
        }
    }

    /* test all edges of triangle 1 against the edges of triangle 2 */
    do {
        var Ax: Float
        var Ay: Float
        var Bx: Float
        var By: Float
        var Cx: Float
        var Cy: Float
        var e: Float
        var d: Float
        var f: Float
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V0,V1,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
    }
    do {
        var Ax: Float
        var Ay: Float
        var Bx: Float
        var By: Float
        var Cx: Float
        var Cy: Float
        var e: Float
        var d: Float
        var f: Float
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V1,V2,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
    }
    do {
        var Ax: Float
        var Ay: Float
        var Bx: Float
        var By: Float
        var Cx: Float
        var Cy: Float
        var e: Float
        var d: Float
        var f: Float
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: EDGE_AGAINST_TRI_EDGES(V2,V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
    }

    /* finally, test if tri1 is totally contained in tri2 or vice versa */
    do {
        var a: Float
        var b: Float
        var c: Float
        var d0: Float
        var d1: Float
        var d2: Float
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(V0,U0,U1,U2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
    }
    do {
        var a: Float
        var b: Float
        var c: Float
        var d0: Float
        var d1: Float
        var d2: Float
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: POINT_IN_TRI(U0,V0,V1,V2)
        portMissing("coplanar_tri_tri", source: "oracle/codemp/game/tri_coll_test.c:149")
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
    // Raven assigns his own `V1` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var V1 = V1
    // Raven assigns his own `V2` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var V2 = V2
    // Raven assigns his own `U1` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var U1 = U1
    // Raven assigns his own `U2` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var U2 = U2

    /* compute plane equation of triangle(V0,V1,V2) */
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E1,V1,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E1,V1,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E1,V1,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E2,V2,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E2,V2,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E2,V2,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(N1,E1,E2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(N1,E1,E2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(N1,E1,E2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: d1=-DOT(N1,V0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    /* plane equation 1: N1.X+d1=0 */

    /* put U0,U1,U2 into plane equation 1 to compute signed distances to the plane*/
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: du0=DOT(N1,U0)+d1
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: du1=DOT(N1,U1)+d1
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: du2=DOT(N1,U2)+d1
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")

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

    if du0du1 > 0.0 && du0du2 > 0.0 {
        return 0 != 0
    }

    /* compute plane of triangle (U0,U1,U2) */
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E1,U1,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E1,U1,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E1,U1,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E2,U2,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E2,U2,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SUB(E2,U2,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(N2,E1,E2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(N2,E1,E2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(N2,E1,E2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: d2=-DOT(N2,U0)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    /* plane equation 2: N2.X+d2=0 */

    /* put V0,V1,V2 into plane equation 2 */
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: dv0=DOT(N2,V0)+d2
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: dv1=DOT(N2,V1)+d2
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: dv2=DOT(N2,V2)+d2
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")

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

    if dv0dv1 > 0.0 && dv0dv2 > 0.0 {
        return 0 != 0
    }

    /* compute direction of intersection line */
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(D,N1,N2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(D,N1,N2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: CROSS(D,N1,N2)
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")

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
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: COMPUTE_INTERVALS(vp0,vp1,vp2,dv0,dv1,dv2,dv0dv1,dv0dv2,isect1[0],isect1[1])
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")

    /* compute interval for triangle 2 */
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: COMPUTE_INTERVALS(up0,up1,up2,du0,du1,du2,du0du1,du0du2,isect2[0],isect2[1])
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")

    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SORT(isect1[0],isect1[1])
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")
    // Port-note: No operator between the operands, the text there is ``.
    // Raven wrote: SORT(isect2[0],isect2[1])
    portMissing("tri_tri_intersect", source: "oracle/codemp/game/tri_coll_test.c:198")

    if isect1[1] < isect2[0] || isect2[1] < isect1[0] {
        return true
    }
    return false
}
