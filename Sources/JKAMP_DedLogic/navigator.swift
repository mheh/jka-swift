import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:32
/// Raven's instance, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var navigator: CNavigator { world.navigator }

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:36
public var d_altRoutes: JKAMP.Cvar? {
    get { world.variables.d_altRoutes }
    set { world.variables.d_altRoutes = newValue }
}

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:37
public var d_patched: JKAMP.Cvar? {
    get { world.variables.d_patched }
    set { world.variables.d_patched = newValue }
}

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:50
// Raven wrote: static vec3_t wpMaxs = { 16, 16, 32 }
let wpMaxs: JKAShared.vec3_t = vec3_t(16, 16, 32)

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:51
// Raven wrote: static vec3_t wpMins = { -16, -16, -24+STEPSIZE }
//WTF:  was 16??!!!
let wpMins: JKAShared.vec3_t = vec3_t(-16, -16, Float(-24 + STEPSIZE))

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:54
// Raven wrote: static byte CHECKED_NO = 0
let CHECKED_NO: JKAShared.byte = 0

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:55
// Raven wrote: static byte CHECKED_FAILED = 1
let CHECKED_FAILED: JKAShared.byte = 1

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:56
// Raven wrote: static byte CHECKED_PASSED = 2
let CHECKED_PASSED: JKAShared.byte = 2

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1245
let NODE_COLLECT_MAX = 16 as Int32

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1246
let NODE_COLLECT_RADIUS = 512 as Int32

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1247
let NODE_COLLECT_RADIUS_SQR = (NODE_COLLECT_RADIUS * NODE_COLLECT_RADIUS)

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1326
let MAX_Z_DELTA = 18 as Int32

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1687
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var CheckedNodes: [Int32: JKAShared.byte] {
    get { world.CheckedNodes }
    set { world.CheckedNodes = newValue }
}

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1721
let CHECK_FAILED_EDGE_INTERVAL = 1000 as Int32

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:1722
let CHECK_FAILED_EDGE_INTITIAL = 5000 as Int32

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:39
public func NAV_CvarInit() {
    d_altRoutes = Cvar_Get("d_altRoutes", "0", CVAR_CHEAT)
    d_patched = Cvar_Get("d_patched", "0", CVAR_CHEAT)
}

/// Source: oracle/codemp/server/NPCNav/navigator.cpp:45
public func NAV_Free() {
    navigator.Free()
}
