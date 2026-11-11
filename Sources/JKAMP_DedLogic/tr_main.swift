import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_main.cpp:15
public var tr: TrGlobals { world.storage.tr }

/// Source: oracle/codemp/renderer/tr_main.cpp:17
// Raven wrote: static float s_flipMatrix[16]
private let s_flipMatrix: [Float] = [
    // convert from our coordinate system (looking down X)
    // to OpenGL's coordinate system (looking down -Z)
    0, 0, -1, 0,
    -1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 0, 1,
]

/**
```
** R_CullLocalPointAndRadius
```
*/
/// Source: oracle/codemp/renderer/tr_main.cpp:109
public func R_CullLocalPointAndRadius(_ pt: JKAShared.vec3_t, _ radius: Float) -> Int32 {
    var transformed = vec3_t()

    R_LocalPointToWorld(pt, &transformed)

    return R_CullPointAndRadius(transformed, radius)
}

/**
```
** R_CullPointAndRadius
```
*/
/// Source: oracle/codemp/renderer/tr_main.cpp:121
public func R_CullPointAndRadius(_ pt: JKAShared.vec3_t, _ radius: Float) -> Int32 {
    var i: Int32
    var dist: Float
    var frust: Cplane
    var mightBeClipped = false

    if r_nocull!.integer == 1 {
        return CULL_CLIP
    }

    // check against frustum planes
    i = 0
    while i < 4 {
        frust = tr.viewParms.frustum[i]

        dist = _DotProduct(pt, frust.normal) - frust.dist
        if dist < -radius {
            return CULL_OUT
        } else if dist <= radius {
            mightBeClipped = true
        }
        i += 1
    }

    if mightBeClipped {
        return CULL_CLIP
    }

    return CULL_IN // completely inside frustum
}

/**
```
=================
R_LocalPointToWorld

=================
```
*/
/// Source: oracle/codemp/renderer/tr_main.cpp:177
public func R_LocalPointToWorld(_ local: JKAShared.vec3_t, _ world: inout JKAShared.vec3_t) {
    world[0] = local[0] * tr.ori.axis[0][0] + local[1] * tr.ori.axis[1][0] + local[2] * tr.ori.axis[2][0] + tr.ori.origin[0]
    world[1] = local[0] * tr.ori.axis[0][1] + local[1] * tr.ori.axis[1][1] + local[2] * tr.ori.axis[2][1] + tr.ori.origin[1]
    world[2] = local[0] * tr.ori.axis[0][2] + local[1] * tr.ori.axis[1][2] + local[2] * tr.ori.axis[2][2] + tr.ori.origin[2]
}
