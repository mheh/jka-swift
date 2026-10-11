import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Howler.c:4
private let MIN_DISTANCE = 54 as Int32

/// Source: oracle/codemp/game/NPC_AI_Howler.c:5
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Howler.c:7
private let MAX_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_Howler.c:8
private let MAX_DISTANCE_SQR = (MAX_DISTANCE * MAX_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Howler.c:10
private let LSTATE_CLEAR = 0 as Int32

/// Source: oracle/codemp/game/NPC_AI_Howler.c:11
private let LSTATE_WAITING = 1 as Int32

/**
```
-------------------------
NPC_Howler_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Howler.c:18
func NPC_Howler_Precache() {
}

/**
```
-------------------------
Howler_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Howler.c:28
func Howler_Idle() {
}

/**
```
-------------------------
Howler_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Howler.c:38
func Howler_Patrol() {
    var dif = vec3_t()

    NPCInfo!.localState = LSTATE_CLEAR

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons &= ~BUTTON_WALKING
        NPC_MoveToGoal(true)
    } else {
        if TIMER_Done(NPC!, "patrolTime") {
            TIMER_Set(NPC!, "patrolTime", Int32(crandom() * 5000 + 5000))
        }
    }

    //rwwFIXMEFIXME: Care about all clients, not just client 0
    dif = g_entities[0].r.currentOrigin - NPC!.r.currentOrigin

    if VectorLengthSquared(dif) < 256 * 256 {
        G_SetEnemy(NPC!, g_entities[0])
    }

    if NPC_CheckEnemyExt(true) == false {
        Howler_Idle()
        return
    }
}

/**
```
-------------------------
Howler_Move
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Howler.c:78
func Howler_Move(_ visible: Bool) {
    if NPCInfo!.localState != LSTATE_WAITING {
        NPCInfo!.goalEntity = NPC!.enemy
        NPC_MoveToGoal(true)
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/NPC_AI_Howler.c:89
func Howler_TryDamage(_ enemy: Entity, _ damage: Int32) {
    var end = vec3_t()
    var dir = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in


        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(NPC!.client!.ps.viewangles, &dir, &scratchRight, &scratchUp)
        _VectorMA(NPC!.r.currentOrigin, Float(MIN_DISTANCE), dir, &end)

        // Should probably trace from the mouth, but, ah well.
        trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SHOT)

        if tr.entityNum != ENTITYNUM_WORLD {
            G_Damage(g_entities[tr.entityNum], NPC, NPC, &dir, tr.endpos, damage, DAMAGE_NO_KNOCKBACK, MOD_MELEE)
        }
        return false
    }
    if earlyOut {
        return
    }
}

//------------------------------
/// Source: oracle/codemp/game/NPC_AI_Howler.c:112
func Howler_Attack() {
    if !TIMER_Exists(NPC!, "attacking") {
        // Going to do ATTACK1
        // The SDK also declares `random`, so the call names the bg module.
        TIMER_Set(NPC!, "attacking", Int32(1700 + JKAMP_BG.random() * 200))
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

        TIMER_Set(NPC!, "attack_dmg", 200) // level two damage
    }

    // Need to do delayed damage since the attack animations encapsulate multiple mini-attacks
    if TIMER_Done2(NPC!, "attack_dmg", true) {
        Howler_TryDamage(NPC!.enemy!, 5)
    }

    // Just using this to remove the attacking flag at the right time
    TIMER_Done2(NPC!, "attacking", true)
}

//----------------------------------
/// Source: oracle/codemp/game/NPC_AI_Howler.c:134
func Howler_Combat() {
    let distance: Float
    let advance: Bool

    // If we cannot see our target or we have somewhere to go, then do that
    if !NPC_ClearLOS4(NPC!.enemy!) || UpdateGoal() != nil {
        NPCInfo!.combatMove = true
        NPCInfo!.goalEntity = NPC!.enemy
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range

        NPC_MoveToGoal(true)
        return
    }

    // Sometimes I have problems with facing the enemy I'm attacking, so force the issue so I don't look dumb
    NPC_FaceEnemy(true)

    distance = DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)
    advance = Bool((distance > MIN_DISTANCE_SQR ? true : false))

    if (advance || NPCInfo!.localState == LSTATE_WAITING) && TIMER_Done(NPC!, "attacking") {
        if TIMER_Done2(NPC!, "takingPain", true) {
            NPCInfo!.localState = LSTATE_CLEAR
        } else {
            Howler_Move(1 != 0)
        }
    } else {
        Howler_Attack()
    }
}

/**
```
-------------------------
NPC_Howler_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Howler.c:178
func NPC_Howler_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    if damage >= 10 {
        TIMER_Remove(`self`, "attacking")
        TIMER_Set(`self`, "takingPain", 2900)

        `self`.s.angles = `self`.NPC!.lastPathAngles

        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

        if `self`.NPC != nil {
            `self`.NPC!.localState = LSTATE_WAITING
        }
    }
}

/**
```
-------------------------
NPC_BSHowler_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Howler.c:202
func NPC_BSHowler_Default() {
    if NPC!.enemy != nil {
        Howler_Combat()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        Howler_Patrol()
    } else {
        Howler_Idle()
    }

    NPC_UpdateAngles(true, true)
}
