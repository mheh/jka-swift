import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_main.cpp:15
var tr: TrGlobals { world.storage.tr }

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
func R_CullLocalPointAndRadius(_ pt: JKAShared.vec3_t, _ radius: Float) -> Int32 {
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
func R_CullPointAndRadius(_ pt: JKAShared.vec3_t, _ radius: Float) -> Int32 {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_CullPointAndRadius
    portMissing("R_CullPointAndRadius", source: "oracle/codemp/renderer/tr_main.cpp:121")
}

/**
```
=================
R_LocalPointToWorld

=================
```
*/
/// Source: oracle/codemp/renderer/tr_main.cpp:177
func R_LocalPointToWorld(_ local: JKAShared.vec3_t, _ world: inout JKAShared.vec3_t) {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_LocalPointToWorld
    portMissing("R_LocalPointToWorld", source: "oracle/codemp/renderer/tr_main.cpp:177")
}
