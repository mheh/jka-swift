import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Remote.c:10
private let LSTATE_NONE: Int32 = 0

/// Source: oracle/codemp/game/NPC_AI_Remote.c:6
private let VELOCITY_DECAY = 0.85 as Float

/// Source: oracle/codemp/game/NPC_AI_Remote.c:130
let REMOTE_STRAFE_VEL = 256 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:131
let REMOTE_STRAFE_DIS = 200 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:132
let REMOTE_UPWARD_PUSH = 32 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:170
let REMOTE_FORWARD_BASE_SPEED = 10 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:171
let REMOTE_FORWARD_MULTIPLIER = 5 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:279
private let MIN_MELEE_RANGE = 320 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:280
private let MIN_MELEE_RANGE_SQR = (MIN_MELEE_RANGE * MIN_MELEE_RANGE)

/// Source: oracle/codemp/game/NPC_AI_Remote.c:282
private let MIN_DISTANCE = 80 as Int32

/// Source: oracle/codemp/game/NPC_AI_Remote.c:283
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Remote.c:17
func NPC_Remote_Precache() {
    G_SoundIndex("sound/chars/remote/misc/fire.wav")
    G_SoundIndex("sound/chars/remote/misc/hiss.wav")
    G_EffectIndex("env/small_explode")
}

/**
```
-------------------------
NPC_Remote_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:29
func NPC_Remote_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    SaveNPCGlobals()
    SetNPCGlobals(`self`)
    Remote_Strafe()
    RestoreNPCGlobals()

    NPC_Pain(`self`, attacker, damage)
}

/**
```
-------------------------
Remote_MaintainHeight
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:44
func Remote_MaintainHeight() {
    var dif: Float

    // Update our angles regardless
    NPC_UpdateAngles(true, true)

    if NPC!.client!.ps.velocity[2] != 0 {
        NPC!.client!.ps.velocity[2] *= VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[2]) < 2 {
            NPC!.client!.ps.velocity[2] = 0
        }
    }
    // If we have an enemy, we should try to hover at or a little below enemy eye level
    if NPC!.enemy != nil {
        if TIMER_Done(NPC!, "heightChange") {
            TIMER_Set(NPC!, "heightChange", Q_irand(1000, 3000))

            // Find the height difference
            dif = (NPC!.enemy!.r.currentOrigin[2] + Q_irand(0, Int32(NPC!.enemy!.r.maxs[2] + 8))) - NPC!.r.currentOrigin[2]

            // cap to prevent dramatic height shifts
            if abs(dif) > 2 {
                if abs(dif) > 24 {
                    dif = Float((dif < 0 ? -24 : 24))
                }
                dif *= 10
                NPC!.client!.ps.velocity[2] = (NPC!.client!.ps.velocity[2] + dif) / 2
                //	NPC->fx_time = level.time;
                G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/remote/misc/hiss.wav"))
            }
        }
    } else {
        var goal: Entity? = nil

        if NPCInfo!.goalEntity != nil {
            goal = NPCInfo!.goalEntity
        } else {
            goal = NPCInfo!.lastGoalEntity
        }
        if goal != nil {
            dif = goal!.r.currentOrigin[2] - NPC!.r.currentOrigin[2]

            if abs(dif) > 24 {
                dif = Float((dif < 0 ? -24 : 24))
                NPC!.client!.ps.velocity[2] = (NPC!.client!.ps.velocity[2] + dif) / 2
            }
        }
    }

    // Apply friction
    if NPC!.client!.ps.velocity[0] != 0 {
        NPC!.client!.ps.velocity[0] *= VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[0]) < 1 {
            NPC!.client!.ps.velocity[0] = 0
        }
    }

    if NPC!.client!.ps.velocity[1] != 0 {
        NPC!.client!.ps.velocity[1] *= VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[1]) < 1 {
            NPC!.client!.ps.velocity[1] = 0
        }
    }
}

/**
```
-------------------------
Remote_Strafe
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:139
func Remote_Strafe() {
    var dir: Int32 = 0
    var end = vec3_t()
    var right = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in

        // Raven passes NULL for the `forward` and `up` outputs.
        var scratchForward = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(NPC!.client!.renderInfo.eyeAngles, &scratchForward, &right, &scratchUp)

        // Pick a random strafe direction, then check to see if doing a strafe would be
        //	reasonable valid
        // The SDK also declares `rand`, so the call names the bg module.
        dir = (JKAMP_BG.rand() & 1) != 0 ? -1 : 1
        _VectorMA(NPC!.r.currentOrigin, Float(REMOTE_STRAFE_DIS * dir), right, &end)

        trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SOLID)

        // Close enough
        if tr.fraction > 0.9 {
            _VectorMA(NPC!.client!.ps.velocity, Float(REMOTE_STRAFE_VEL * dir), right, &NPC!.client!.ps.velocity)

            G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/remote/misc/hiss.wav"))

            // Add a slight upward push
            NPC!.client!.ps.velocity[2] += REMOTE_UPWARD_PUSH

            // Set the strafe start time so we can do a controlled roll
            //	NPC->fx_time = level.time;
            // The SDK also declares `random`, so the call names the bg module.
            NPCInfo!.standTime = Int32(level.time + 3000 + JKAMP_BG.random() * 500)
        }
    }
}

/**
```
-------------------------
Remote_Hunt
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:178
func Remote_Hunt(_ visible: Bool, _ advance: Bool, _ retreat: Bool) {
    var distance: Float = 0
    var speed: Float
    var forward = vec3_t()

    //If we're not supposed to stand still, pursue the player
    if NPCInfo!.standTime < level.time {
        // Only strafe when we can see the player
        if visible {
            Remote_Strafe()
            return
        }
    }

    //If we don't want to advance, stop here
    if advance == false && visible == true {
        return
    }

    //Only try and navigate if the player is visible
    if visible == false {
        // Move towards our goal
        NPCInfo!.goalEntity = NPC!.enemy
        NPCInfo!.goalRadius = 12

        //Get our direction from the navigator if we can't see our target
        if NPC_GetMoveDirection(&forward, &distance) == false {
            return
        }
    } else {
        forward = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
        distance = VectorNormalize(&forward)
    }

    speed = Float(REMOTE_FORWARD_BASE_SPEED + REMOTE_FORWARD_MULTIPLIER * g_spskill.integer)
    if retreat == true {
        speed *= -1
    }
    _VectorMA(NPC!.client!.ps.velocity, speed, forward, &NPC!.client!.ps.velocity)
}

/**
```
-------------------------
Remote_Fire
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:229
func Remote_Fire() {
    var delta1 = vec3_t()
    var enemy_org1 = vec3_t()
    var muzzle1 = vec3_t()
    var angleToEnemy1 = vec3_t()
    var forward = vec3_t()
    var vright = vec3_t()
    var up = vec3_t()
    var muzzle = vec3_t()
    var missile: Entity?

    CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_org1)
    muzzle1 = NPC!.r.currentOrigin

    delta1 = enemy_org1 - muzzle1

    vectoangles(delta1, &angleToEnemy1)
    AngleVectors(angleToEnemy1, &forward, &vright, &up)

    missile = CreateMissile(&NPC!.r.currentOrigin, forward, 1000, 10000, NPC!, false)

    G_PlayEffectID(G_EffectIndex("bryar/muzzle_flash"), NPC!.r.currentOrigin, forward)

    missile!.classname = "briar"
    missile!.s.weapon = WP_BRYAR_PISTOL

    missile!.damage = 10
    missile!.dflags = DAMAGE_DEATH_KNOCKBACK
    missile!.methodOfDeath = MOD_BRYAR_PISTOL
    missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
}

/**
```
-------------------------
Remote_Ranged
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:264
func Remote_Ranged(_ visible: Bool, _ advance: Bool, _ retreat: Bool) {
    if TIMER_Done(NPC!, "attackDelay") {
        TIMER_Set(NPC!, "attackDelay", Q_irand(500, 3000))
        Remote_Fire()
    }

    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        Remote_Hunt(visible, advance, retreat)
    }
}

/**
```
-------------------------
Remote_Attack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:290
func Remote_Attack() {
    let distance: Float
    let visible: Bool
    let idealDist: Float
    let advance: Bool
    let retreat: Bool

    if TIMER_Done(NPC!, "spin") {
        TIMER_Set(NPC!, "spin", Q_irand(250, 1500))
        NPCInfo!.desiredYaw += Q_irand(-200, 200)
    }
    // Always keep a good height off the ground
    Remote_MaintainHeight()

    // If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        Remote_Idle()
        return
    }

    // Rate our distance to the target, and our visibilty
    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    visible = NPC_ClearLOS4(NPC!.enemy!)
    idealDist = MIN_DISTANCE_SQR + (MIN_DISTANCE_SQR * flrand(0, 1))
    advance = Bool((Double(distance) > Double(idealDist) * 1.25))
    retreat = Bool((Double(distance) < Double(idealDist) * 0.75))

    // If we cannot see our target, move to see it
    if visible == false {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            Remote_Hunt(visible, advance, retreat)
            return
        }
    }

    Remote_Ranged(visible, advance, retreat)
}

/**
```
-------------------------
Remote_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:339
func Remote_Idle() {
    Remote_MaintainHeight()

    NPC_BSIdle()
}

/**
```
-------------------------
Remote_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:351
func Remote_Patrol() {
    Remote_MaintainHeight()

    //If we have somewhere to go, then do that
    if NPC!.enemy == nil {
        if UpdateGoal() != nil {
            //start loop sound once we move
            ucmd.buttons |= BUTTON_WALKING
            NPC_MoveToGoal(true)
        }
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
NPC_BSRemote_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Remote.c:375
func NPC_BSRemote_Default() {
    if NPC!.enemy != nil {
        Remote_Attack()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        Remote_Patrol()
    } else {
        Remote_Idle()
    }
}
