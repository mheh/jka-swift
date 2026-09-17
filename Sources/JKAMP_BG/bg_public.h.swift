// bg_public.h -- the header's inline functions as functions, the way q_shared.h.swift holds that header's function-like macros.

import JKAMP
import JKAShared

/// Raven defines this inline in the header, and the copy in bg_misc.c sits under a guard the port never takes.
/// The flag names one axis of the bolt matrix, or its origin, and the vector takes that column.
/// Source: oracle/codemp/game/bg_public.h:1524
func BG_GiveMeVectorFromMatrix(_ boltMatrix: JKAMP.MdxaBone, _ flags: Int32, _ vec: inout JKAShared.vec3_t) {
    switch flags {
    case ORIGIN:
        vec[0] = boltMatrix.matrix[0][3]
        vec[1] = boltMatrix.matrix[1][3]
        vec[2] = boltMatrix.matrix[2][3]

    case POSITIVE_Y:
        vec[0] = boltMatrix.matrix[0][1]
        vec[1] = boltMatrix.matrix[1][1]
        vec[2] = boltMatrix.matrix[2][1]

    case POSITIVE_X:
        vec[0] = boltMatrix.matrix[0][0]
        vec[1] = boltMatrix.matrix[1][0]
        vec[2] = boltMatrix.matrix[2][0]

    case POSITIVE_Z:
        vec[0] = boltMatrix.matrix[0][2]
        vec[1] = boltMatrix.matrix[1][2]
        vec[2] = boltMatrix.matrix[2][2]

    case NEGATIVE_Y:
        vec[0] = -boltMatrix.matrix[0][1]
        vec[1] = -boltMatrix.matrix[1][1]
        vec[2] = -boltMatrix.matrix[2][1]

    case NEGATIVE_X:
        vec[0] = -boltMatrix.matrix[0][0]
        vec[1] = -boltMatrix.matrix[1][0]
        vec[2] = -boltMatrix.matrix[2][0]

    case NEGATIVE_Z:
        vec[0] = -boltMatrix.matrix[0][2]
        vec[1] = -boltMatrix.matrix[1][2]
        vec[2] = -boltMatrix.matrix[2][2]

    default:
        break
    }
}
