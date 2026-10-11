import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:4
private let MIN_DISTANCE = 54 as Int32

/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:5
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:7
private let MAX_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:8
private let MAX_DISTANCE_SQR = (MAX_DISTANCE * MAX_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:10
private let LSTATE_CLEAR = 0 as Int32

/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:11
private let LSTATE_WAITING = 1 as Int32

/**
```
-------------------------
NPC_MineMonster_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:18
func NPC_MineMonster_Precache() {
    var i: Int32

    i = 0
    while i < 4 {
        G_SoundIndex(va("sound/chars/mine/misc/bite%i.wav", i + 1))
        G_SoundIndex(va("sound/chars/mine/misc/miss%i.wav", i + 1))
        i += 1
    }
}

/**
```
-------------------------
MineMonster_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:35
func MineMonster_Idle() {
    if UpdateGoal() != nil {
        ucmd.buttons &= ~BUTTON_WALKING
        NPC_MoveToGoal(true)
    }
}

/**
```
-------------------------
MineMonster_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:50
func MineMonster_Patrol() {
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
        MineMonster_Idle()
        return
    }
}

/**
```
-------------------------
MineMonster_Move
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:90
func MineMonster_Move(_ visible: Bool) {
    if NPCInfo!.localState != LSTATE_WAITING {
        NPCInfo!.goalEntity = NPC!.enemy
        NPC_MoveToGoal(true)
        NPCInfo!.goalRadius = MAX_DISTANCE // just get us within combat range
    }
}

//---------------------------------------------------------
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:101
func MineMonster_TryDamage(_ enemy: Entity, _ damage: Int32) {
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

        if tr.entityNum >= 0 && tr.entityNum < ENTITYNUM_NONE {
            G_Damage(g_entities[tr.entityNum], NPC, NPC, &dir, tr.endpos, damage, DAMAGE_NO_KNOCKBACK, MOD_MELEE)
            G_Sound(NPC!, CHAN_AUTO, G_EffectIndex(va("sound/chars/mine/misc/bite%i.wav", Q_irand(1, 4))))
        } else {
            G_Sound(NPC!, CHAN_AUTO, G_EffectIndex(va("sound/chars/mine/misc/miss%i.wav", Q_irand(1, 4))))
        }
        return false
    }
    if earlyOut {
        return
    }
}

//------------------------------
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:129
func MineMonster_Attack() {
    if !TIMER_Exists(NPC!, "attacking") {
        // usually try and play a jump attack if the player somehow got above them....or just really rarely
        // The SDK also declares `random`, so the call names the bg module.
        if NPC!.enemy != nil && ((NPC!.enemy!.r.currentOrigin[2] - NPC!.r.currentOrigin[2] > 10 && JKAMP_BG.random() > 0.1) || JKAMP_BG.random() > 0.8) {
            // Going to do ATTACK4
            // The SDK also declares `random`, so the call names the bg module.
            TIMER_Set(NPC!, "attacking", Int32(1750 + JKAMP_BG.random() * 200))
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK4, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

            TIMER_Set(NPC!, "attack2_dmg", 950) // level two damage
        } else if JKAMP_BG.random() > 0.5 {
            // The SDK also declares `random`, so the call names the bg module.
            if JKAMP_BG.random() > 0.8 {
                // Going to do ATTACK3, (rare)
                TIMER_Set(NPC!, "attacking", 850)
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK3, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

                TIMER_Set(NPC!, "attack2_dmg", 400) // level two damage
            } else {
                // Going to do ATTACK1
                TIMER_Set(NPC!, "attacking", 850)
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

                TIMER_Set(NPC!, "attack1_dmg", 450) // level one damage
            }
        } else {
            // Going to do ATTACK2
            TIMER_Set(NPC!, "attacking", 1250)
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

            TIMER_Set(NPC!, "attack1_dmg", 700) // level one damage
        }
    } else {
        // Need to do delayed damage since the attack animations encapsulate multiple mini-attacks
        if TIMER_Done2(NPC!, "attack1_dmg", true) {
            MineMonster_TryDamage(NPC!.enemy!, 5)
        } else if TIMER_Done2(NPC!, "attack2_dmg", true) {
            MineMonster_TryDamage(NPC!.enemy!, 10)
        }
    }

    // Just using this to remove the attacking flag at the right time
    TIMER_Done2(NPC!, "attacking", true)
}

//----------------------------------
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:189
func MineMonster_Combat() {
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
            MineMonster_Move(1 != 0)
        }
    } else {
        MineMonster_Attack()
    }
}

/**
```
-------------------------
NPC_MineMonster_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:234
func NPC_MineMonster_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    G_AddEvent(`self`, EV_PAIN, Int32(floor(Float(`self`.health) / `self`.client!.pers.maxHealth * 100.0)))

    if damage >= 10 {
        TIMER_Remove(`self`, "attacking")
        TIMER_Remove(`self`, "attacking1_dmg")
        TIMER_Remove(`self`, "attacking2_dmg")
        TIMER_Set(`self`, "takingPain", 1350)

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
NPC_BSMineMonster_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_MineMonster.c:262
func NPC_BSMineMonster_Default() {
    if NPC!.enemy != nil {
        MineMonster_Combat()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        MineMonster_Patrol()
    } else {
        MineMonster_Idle()
    }

    NPC_UpdateAngles(true, true)
}
