import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_timer.c:8
let MAX_GTIMERS = 16384 as Int32

/// Source: oracle/codemp/game/g_timer.c:17
var g_timerPool: Slots<Gtimer> { world.storage.g_timerPool }

/// Source: oracle/codemp/game/g_timer.c:18
var g_timers: Slots<Gtimer?> { world.storage.g_timers }

/// Source: oracle/codemp/game/g_timer.c:19
var g_timerFreeList: Gtimer? {
    get { world.variables.g_timerFreeList }
    set { world.variables.g_timerFreeList = newValue }
}

/// Source: oracle/codemp/game/g_timer.c:27
func TIMER_Clear() {
    var i: Int32
    i = 0
    while i < MAX_GENTITIES {
        g_timers[i] = nil
        i += 1
    }

    i = 0
    while i < MAX_GTIMERS - 1 {
        g_timerPool[i].next = g_timerPool[i + 1]
        i += 1
    }
    g_timerPool[MAX_GTIMERS - 1].next = nil
    g_timerFreeList = g_timerPool[0]
}

/// Source: oracle/codemp/game/g_timer.c:49
func TIMER_Clear2(_ ent: Entity) {
    // rudimentary safety checks, might be other things to check?
    // Raven's NULL test on ent has no form here, and the arm it guards is gone.
    if ent.s.number > 0 && ent.s.number < MAX_GENTITIES {
        var p: Gtimer? = g_timers[ent.s.number]

        // No timers at all -> do nothing
        if p == nil {
            return
        }

        // Find the end of this ents timer list
        while p!.next != nil {
            p = p!.next
        }

        // Splice the lists
        p!.next = g_timerFreeList
        g_timerFreeList = g_timers[ent.s.number]
        g_timers[ent.s.number] = nil
        return
    }
}

//New C "lookup" func.
//Returns existing timer in array if
/// Source: oracle/codemp/game/g_timer.c:79
func TIMER_GetNew(_ num: Int32, _ identifier: String) -> Gtimer? {
    var p: Gtimer? = g_timers[num]

    // Search for an existing timer with this name
    while p != nil {
        if Q_stricmp(p!.name!, identifier) == 0 {
            // Found it
            return p
        }

        p = p!.next
    }

    // No existing timer with this name was found, so grab one from the free list
    if g_timerFreeList == nil {
        return nil
    }

    p = g_timerFreeList
    g_timerFreeList = g_timerFreeList!.next
    p!.next = g_timers[num]
    g_timers[num] = p
    return p
}

//don't return the first free if it doesn't already exist, return null.
/// Source: oracle/codemp/game/g_timer.c:106
func TIMER_GetExisting(_ num: Int32, _ identifier: String) -> Gtimer? {
    var p: Gtimer? = g_timers[num]

    while p != nil {
        if Q_stricmp(p!.name!, identifier) == 0 {
            // Found it
            return p
        }

        p = p!.next
    }

    return nil
}

/// Source: oracle/codemp/game/g_timer.c:129
func TIMER_Set(_ ent: Entity, _ identifier: String, _ duration: Int32) {
    let timer: Gtimer? = TIMER_GetNew(ent.s.number, identifier)

    if timer == nil {
        return
    }
    timer!.name = identifier
    timer!.time = level.time + duration
}

/// Source: oracle/codemp/game/g_timer.c:147
func TIMER_Get(_ ent: Entity, _ identifier: String) -> Int32 {
    let timer: Gtimer? = TIMER_GetExisting(ent.s.number, identifier)

    if timer == nil {
        return -1
    }

    return timer!.time
}

/// Source: oracle/codemp/game/g_timer.c:165
func TIMER_Done(_ ent: Entity, _ identifier: String) -> Bool {
    let timer: Gtimer? = TIMER_GetExisting(ent.s.number, identifier)

    if timer == nil {
        return true
    }

    return (timer!.time < level.time)
}

/**
```
-------------------------
TIMER_RemoveHelper

Scans an entities timer list to remove a given
timer from the list and put it on the free list

Doesn't do much error checking, only called below
-------------------------
```
*/
/// Source: oracle/codemp/game/g_timer.c:187
func TIMER_RemoveHelper(_ num: Int32, _ timer: Gtimer) {
    var p: Gtimer? = g_timers[num]

    // Special case: first timer in list
    if p == timer {
        g_timers[num] = g_timers[num]!.next
        p!.next = g_timerFreeList
        g_timerFreeList = p
        return
    }

    // Find the predecessor
    while p!.next != timer {
        p = p!.next
    }

    // Rewire
    p!.next = p!.next!.next
    timer.next = g_timerFreeList
    g_timerFreeList = timer
    return
}

/// Source: oracle/codemp/game/g_timer.c:223
func TIMER_Done2(_ ent: Entity, _ identifier: String, _ remove: Bool) -> Bool {
    let timer: Gtimer? = TIMER_GetExisting(ent.s.number, identifier)
    let res: Bool

    if timer == nil {
        return false
    }

    res = (timer!.time < level.time)

    if res && remove {
        // Put it back on the free list
        TIMER_RemoveHelper(ent.s.number, timer!)
    }

    return res
}

/**
```
-------------------------
TIMER_Exists
-------------------------
```
*/
/// Source: oracle/codemp/game/g_timer.c:249
func TIMER_Exists(_ ent: Entity, _ identifier: String) -> Bool {
    let timer: Gtimer? = TIMER_GetExisting(ent.s.number, identifier)

    if timer == nil {
        return false
    }

    return true
}

/**
```
-------------------------
TIMER_Remove
Utility to get rid of any timer
-------------------------
```
*/
/// Source: oracle/codemp/game/g_timer.c:267
func TIMER_Remove(_ ent: Entity, _ identifier: String) {
    let timer: Gtimer? = TIMER_GetExisting(ent.s.number, identifier)

    if timer == nil {
        return
    }

    // Put it back on the free list
    TIMER_RemoveHelper(ent.s.number, timer!)
}

/// Source: oracle/codemp/game/g_timer.c:286
func TIMER_Start(_ `self`: Entity, _ identifier: String, _ duration: Int32) -> Bool {
    if TIMER_Done(`self`, identifier) {
        TIMER_Set(`self`, identifier, duration)
        return true
    }
    return false
}
