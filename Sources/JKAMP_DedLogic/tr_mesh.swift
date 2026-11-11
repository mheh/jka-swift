import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_mesh.cpp:12
public func ProjectRadius(_ r: Float, _ location: JKAShared.vec3_t) -> Float {
    var pr: Float
    var dist: Float
    var c: Float
    var p = vec3_t()
    var width: Float
    var depth: Float

    c = _DotProduct(tr.viewParms.ori.axis[0], tr.viewParms.ori.origin)
    dist = _DotProduct(tr.viewParms.ori.axis[0], location) - c

    if dist <= 0 {
        return 0
    }

    p[0] = 0
    p[1] = Q_fabs(r)
    p[2] = -dist

    width = p[0] * tr.viewParms.projectionMatrix[1] +
        p[1] * tr.viewParms.projectionMatrix[5] +
        p[2] * tr.viewParms.projectionMatrix[9] +
        tr.viewParms.projectionMatrix[13]

    depth = p[0] * tr.viewParms.projectionMatrix[3] +
        p[1] * tr.viewParms.projectionMatrix[7] +
        p[2] * tr.viewParms.projectionMatrix[11] +
        tr.viewParms.projectionMatrix[15]

    pr = width / depth

    if pr > 1.0 {
        pr = 1.0
    }

    return pr
}
