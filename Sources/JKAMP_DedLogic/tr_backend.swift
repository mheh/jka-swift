import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_backend.cpp:20
var backEndData: BackEndData? {
    get { world.variables.backEndData }
    set { world.variables.backEndData = newValue }
}

/// Source: oracle/codemp/renderer/tr_backend.cpp:21
var backEnd: BackEndState { world.storage.backEnd }

/// Source: oracle/codemp/renderer/tr_backend.cpp:23
// Raven wrote: bool tr_stencilled = false
let tr_stencilled: Bool = false

/// Source: oracle/codemp/renderer/tr_backend.cpp:32
// Raven wrote: bool g_bRenderGlowingObjects = false
let g_bRenderGlowingObjects: Bool = false

/// Source: oracle/codemp/renderer/tr_backend.cpp:35
// Raven wrote: bool g_bDynamicGlowSupported = false
let g_bDynamicGlowSupported: Bool = false

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
