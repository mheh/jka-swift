import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_backend.cpp:20
// TODO: Port global backEndData
// Raven wrote: backEndData_t *backEndData
// No table row for `backEndData_t *`.

/// Source: oracle/codemp/renderer/tr_backend.cpp:21
// TODO: Port global backEnd
// Raven wrote: backEndState_t backEnd
// No view for `backEndState_t` of `tr_local.h`.

/// Source: oracle/codemp/renderer/tr_backend.cpp:23
// TODO: Port global tr_stencilled
// Raven wrote: bool tr_stencilled = false
// No table row for `bool`.

/// Source: oracle/codemp/renderer/tr_backend.cpp:32
// TODO: Port global g_bRenderGlowingObjects
// Raven wrote: bool g_bRenderGlowingObjects = false
// No table row for `bool`.

/// Source: oracle/codemp/renderer/tr_backend.cpp:35
// TODO: Port global g_bDynamicGlowSupported
// Raven wrote: bool g_bDynamicGlowSupported = false
// No table row for `bool`.

/// Source: oracle/codemp/renderer/tr_backend.cpp:40
// Raven wrote: static const float s_flipMatrix[16]
private let s_flipMatrix: [Float] = [
    // convert from our coordinate system (looking down X)
    // to OpenGL's coordinate system (looking down -Z)
    0, 0, -1, 0,
    -1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 0, 1,
]
