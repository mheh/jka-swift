import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:6
func GNavCallback_NAV_ClearPathToPoint(_ `self`: JKAMP.SharedEntity, _ pmins: JKAShared.vec3_t, _ pmaxs: JKAShared.vec3_t, _ point: JKAShared.vec3_t, _ clipmask: Int32, _ okToHitEntNum: Int32) -> Bool {
    // Port-note: Row SV3. VM_Call reads only integer arguments, so it cannot pass the address of a vector to the module.
    // Raven wrote: return (qboolean)VM_Call(gvm, GAME_NAV_CLEARPATHTOPOINT, self->s.number, pmins, pmaxs, point, clipmask, okToHitEntNum);
    portMissing("GNavCallback_NAV_ClearPathToPoint", source: "oracle/codemp/server/NPCNav/gameCallbacks.cpp:6")
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:11
func GNavCallback_NPC_ClearLOS(_ ent: JKAMP.SharedEntity, _ end: JKAShared.vec3_t) -> Bool {
    // Port-note: Row SV3. VM_Call reads only integer arguments, so it cannot pass the address of a vector to the module.
    // Raven wrote: return (qboolean)VM_Call(gvm, GAME_NAV_CLEARLOS, ent->s.number, end);
    portMissing("GNavCallback_NPC_ClearLOS", source: "oracle/codemp/server/NPCNav/gameCallbacks.cpp:11")
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:16
func GNavCallback_NAVNEW_ClearPathBetweenPoints(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ ignore: Int32, _ clipmask: Int32) -> Int32 {
    // Port-note: Row SV3. VM_Call reads only integer arguments, so it cannot pass the address of a vector to the module.
    // Raven wrote: return VM_Call(gvm, GAME_NAV_CLEARPATHBETWEENPOINTS, start, end, mins, maxs, ignore, clipmask);
    portMissing("GNavCallback_NAVNEW_ClearPathBetweenPoints", source: "oracle/codemp/server/NPCNav/gameCallbacks.cpp:16")
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:21
func GNavCallback_NAV_CheckNodeFailedForEnt(_ ent: JKAMP.SharedEntity, _ nodeNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_CHECKNODEFAILEDFORENT, ent.s.number, nodeNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:26
func GNavCallback_G_EntIsUnlockedDoor(_ entityNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISUNLOCKEDDOOR, entityNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:31
func GNavCallback_G_EntIsDoor(_ entityNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISDOOR, entityNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:36
func GNavCallback_G_EntIsBreakable(_ entityNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISBREAKABLE, entityNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:41
func GNavCallback_G_EntIsRemovableUsable(_ entNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISREMOVABLEUSABLE, entNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:46
func GNavCallback_CP_FindCombatPointWaypoints() {
    VM_Call(gvm!, GAME_NAV_FINDCOMBATPOINTWAYPOINTS)
}
