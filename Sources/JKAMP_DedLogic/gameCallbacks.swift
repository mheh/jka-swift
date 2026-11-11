import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:6
public func GNavCallback_NAV_ClearPathToPoint(_ `self`: JKAMP.SharedEntity, _ pmins: JKAShared.vec3_t, _ pmaxs: JKAShared.vec3_t, _ point: JKAShared.vec3_t, _ clipmask: Int32, _ okToHitEntNum: Int32) -> Bool {
    // AI: Raven passes the addresses of the caller's vectors. The words hold the addresses of copies that live for the call, and the module only reads them.
    return withVectorWords(pmins, pmaxs, point) { vectors in
        VM_Call(gvm!, GAME_NAV_CLEARPATHTOPOINT, `self`.s.number, vectors[0], vectors[1], vectors[2], clipmask, okToHitEntNum) != 0
    }
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:11
public func GNavCallback_NPC_ClearLOS(_ ent: JKAMP.SharedEntity, _ end: JKAShared.vec3_t) -> Bool {
    // AI: Raven passes the address of the caller's vector. The word holds the address of a copy that lives for the call, and the module only reads it.
    return withVectorWords(end) { vectors in
        VM_Call(gvm!, GAME_NAV_CLEARLOS, ent.s.number, vectors[0]) != 0
    }
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:16
public func GNavCallback_NAVNEW_ClearPathBetweenPoints(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ ignore: Int32, _ clipmask: Int32) -> Int32 {
    // AI: Raven passes the addresses of the caller's vectors. The words hold the addresses of copies that live for the call, and the module only reads them.
    // AI: Raven's VM_Call returns an `int`. It returns the pointer-wide word of the module, so the body narrows it to the `int` of the callback.
    return withVectorWords(start, end, mins, maxs) { vectors in
        Int32(truncatingIfNeeded: VM_Call(gvm!, GAME_NAV_CLEARPATHBETWEENPOINTS, vectors[0], vectors[1], vectors[2], vectors[3], ignore, clipmask))
    }
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:21
public func GNavCallback_NAV_CheckNodeFailedForEnt(_ ent: JKAMP.SharedEntity, _ nodeNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_CHECKNODEFAILEDFORENT, ent.s.number, nodeNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:26
public func GNavCallback_G_EntIsUnlockedDoor(_ entityNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISUNLOCKEDDOOR, entityNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:31
public func GNavCallback_G_EntIsDoor(_ entityNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISDOOR, entityNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:36
public func GNavCallback_G_EntIsBreakable(_ entityNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISBREAKABLE, entityNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:41
public func GNavCallback_G_EntIsRemovableUsable(_ entNum: Int32) -> Bool {
    return VM_Call(gvm!, GAME_NAV_ENTISREMOVABLEUSABLE, entNum) != 0
}

/// Source: oracle/codemp/server/NPCNav/gameCallbacks.cpp:46
public func GNavCallback_CP_FindCombatPointWaypoints() {
    VM_Call(gvm!, GAME_NAV_FINDCOMBATPOINTWAYPOINTS)
}
