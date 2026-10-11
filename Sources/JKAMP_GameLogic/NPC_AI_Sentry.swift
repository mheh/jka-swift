import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:22
private let LSTATE_NONE: Int32 = 0
private let LSTATE_ASLEEP: Int32 = 1
private let LSTATE_WAKEUP: Int32 = 2
private let LSTATE_ACTIVE: Int32 = 3
private let LSTATE_POWERING_UP: Int32 = 4
private let LSTATE_ATTACKING: Int32 = 5

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:9
private let MIN_DISTANCE = 256 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:10
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:12
let SENTRY_FORWARD_BASE_SPEED = 10 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:13
let SENTRY_FORWARD_MULTIPLIER = 5 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:15
let SENTRY_VELOCITY_DECAY = 0.85 as Float

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:16
let SENTRY_STRAFE_VEL = 256 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:17
let SENTRY_STRAFE_DIS = 200 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:18
let SENTRY_UPWARD_PUSH = 32 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sentry.c:19
let SENTRY_HOVER_HEIGHT = 24 as Int32

/**
```
-------------------------
NPC_Sentry_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:37
func NPC_Sentry_Precache() {
    var i: Int32

    G_SoundIndex("sound/chars/sentry/misc/sentry_explo")
    G_SoundIndex("sound/chars/sentry/misc/sentry_pain")
    G_SoundIndex("sound/chars/sentry/misc/sentry_shield_open")
    G_SoundIndex("sound/chars/sentry/misc/sentry_shield_close")
    G_SoundIndex("sound/chars/sentry/misc/sentry_hover_1_lp")
    G_SoundIndex("sound/chars/sentry/misc/sentry_hover_2_lp")

    i = 1
    while i < 4 {
        G_SoundIndex(va("sound/chars/sentry/misc/talk%d", i))
        i += 1
    }

    G_EffectIndex("bryar/muzzle_flash")
    G_EffectIndex("env/med_explode")

    RegisterItem(BG_FindItemForAmmo(AMMO_BLASTER)!)
}

/**
```
================
sentry_use
================
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:64
func sentry_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(`self`, BSET_USE)

    `self`.flags &= ~FL_SHIELDED
    NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_POWERUP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    //	self->NPC->localState = LSTATE_WAKEUP;
    `self`.NPC!.localState = LSTATE_ACTIVE
}

/**
```
-------------------------
NPC_Sentry_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:79
func NPC_Sentry_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    let mod: Int32 = gPainMOD

    NPC_Pain(`self`, attacker, damage)

    if mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT {
        `self`.NPC!.burstCount = 0
        TIMER_Set(`self`, "attackDelay", Q_irand(9000, 12000))
        `self`.flags |= FL_SHIELDED
        NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_FLY_SHIELDED, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/chars/sentry/misc/sentry_pain"))

        `self`.NPC!.localState = LSTATE_ACTIVE
    }

    // You got hit, go after the enemy
    //	if (self->NPC->localState == LSTATE_ASLEEP)
    //	{
    //		G_Sound( self, G_SoundIndex("sound/chars/sentry/misc/shieldsopen.wav"));
    //
    //		self->flags &= ~FL_SHIELDED;
    //		NPC_SetAnim( self, SETANIM_BOTH, BOTH_POWERUP1, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD );
    //		self->NPC->localState = LSTATE_WAKEUP;
    //	}
}

/**
```
-------------------------
Sentry_Fire
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:112
func Sentry_Fire() {
    var muzzle = vec3_t()
    var forward = vec3_t()
    var vright = vec3_t()
    var up = vec3_t()
    var missile: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var bolt: Int32 = 0
        var which: Int32 = 0

        NPC!.flags &= ~FL_SHIELDED

        if NPCInfo!.localState == LSTATE_POWERING_UP {
            if TIMER_Done(NPC!, "powerup") {
                NPCInfo!.localState = LSTATE_ATTACKING
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_ATTACK1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            } else {
                // can't do anything right now
                return true
            }
        } else if NPCInfo!.localState == LSTATE_ACTIVE {
            NPCInfo!.localState = LSTATE_POWERING_UP

            G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/sentry/misc/sentry_shield_open"))
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_POWERUP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            TIMER_Set(NPC!, "powerup", 250)
            return true
        } else if NPCInfo!.localState != LSTATE_ATTACKING {
            // bad because we are uninitialized
            NPCInfo!.localState = LSTATE_ACTIVE
            return true
        }

        // Which muzzle to fire from?
        which = NPCInfo!.burstCount % 3
        switch which {
        case 0:
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash1")

        case 1:
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash2")

        default:
            bolt = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash03")
        }

        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, bolt, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzle)

        AngleVectors(NPC!.r.currentAngles, &forward, &vright, &up)
        //	G_Sound( NPC, G_SoundIndex("sound/chars/sentry/misc/shoot.wav"));

        G_PlayEffectID(G_EffectIndex("bryar/muzzle_flash"), muzzle, forward)

        missile = CreateMissile(&muzzle, forward, 1600, 10000, NPC!, false)

        missile!.classname = "bryar_proj"
        missile!.s.weapon = WP_BRYAR_PISTOL

        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_BRYAR_PISTOL
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER

        NPCInfo!.burstCount += 1
        NPC!.attackDebounceTime = level.time + 50
        missile!.damage = 5

        // now scale for difficulty
        if g_spskill.integer == 0 {
            NPC!.attackDebounceTime += 200
            missile!.damage = 1
        } else if g_spskill.integer == 1 {
            NPC!.attackDebounceTime += 100
            missile!.damage = 3
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
-------------------------
Sentry_MaintainHeight
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:210
func Sentry_MaintainHeight() {
    var dif: Float

    NPC!.s.loopSound = G_SoundIndex("sound/chars/sentry/misc/sentry_hover_1_lp")

    // Update our angles regardless
    NPC_UpdateAngles(true, true)

    // If we have an enemy, we should try to hover at about enemy eye level
    if NPC!.enemy != nil {
        // Find the height difference
        dif = (NPC!.enemy!.r.currentOrigin[2] + NPC!.enemy!.r.maxs[2]) - NPC!.r.currentOrigin[2]

        // cap to prevent dramatic height shifts
        if abs(dif) > 8 {
            if abs(dif) > SENTRY_HOVER_HEIGHT {
                dif = Float((dif < 0 ? -24 : 24))
            }

            NPC!.client!.ps.velocity[2] = (NPC!.client!.ps.velocity[2] + dif) / 2
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

            if abs(dif) > SENTRY_HOVER_HEIGHT {
                ucmd.upmove = (ucmd.upmove < 0 ? -4 : 4)
            } else {
                if NPC!.client!.ps.velocity[2] != 0 {
                    NPC!.client!.ps.velocity[2] *= SENTRY_VELOCITY_DECAY

                    if abs(NPC!.client!.ps.velocity[2]) < 2 {
                        NPC!.client!.ps.velocity[2] = 0
                    }
                }
            }
        } else if NPC!.client!.ps.velocity[2] != 0 {
            // Apply friction to Z
            NPC!.client!.ps.velocity[2] *= SENTRY_VELOCITY_DECAY

            if abs(NPC!.client!.ps.velocity[2]) < 1 {
                NPC!.client!.ps.velocity[2] = 0
            }
        }
    }

    // Apply friction
    if NPC!.client!.ps.velocity[0] != 0 {
        NPC!.client!.ps.velocity[0] *= SENTRY_VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[0]) < 1 {
            NPC!.client!.ps.velocity[0] = 0
        }
    }

    if NPC!.client!.ps.velocity[1] != 0 {
        NPC!.client!.ps.velocity[1] *= SENTRY_VELOCITY_DECAY

        if abs(NPC!.client!.ps.velocity[1]) < 1 {
            NPC!.client!.ps.velocity[1] = 0
        }
    }

    NPC_FaceEnemy(true)
}

/**
```
-------------------------
Sentry_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:311
func Sentry_Idle() {
    Sentry_MaintainHeight()

    // Is he waking up?
    if NPCInfo!.localState == LSTATE_WAKEUP {
        if NPC!.client!.ps.torsoTimer <= 0 {
            NPCInfo!.scriptFlags |= SCF_LOOK_FOR_ENEMIES
            NPCInfo!.burstCount = 0
        }
    } else {
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_SLEEP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        NPC!.flags |= FL_SHIELDED

        NPC_BSIdle()
    }
}

/**
```
-------------------------
Sentry_Strafe
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:338
func Sentry_Strafe() {
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
        _VectorMA(NPC!.r.currentOrigin, Float(SENTRY_STRAFE_DIS * dir), right, &end)

        trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SOLID)

        // Close enough
        if tr.fraction > 0.9 {
            _VectorMA(NPC!.client!.ps.velocity, Float(SENTRY_STRAFE_VEL * dir), right, &NPC!.client!.ps.velocity)

            // Add a slight upward push
            NPC!.client!.ps.velocity[2] += SENTRY_UPWARD_PUSH

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
Sentry_Hunt
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:372
func Sentry_Hunt(_ visible: Bool, _ advance: Bool) {
    var distance: Float = 0
    let speed: Float
    var forward = vec3_t()

    //If we're not supposed to stand still, pursue the player
    if NPCInfo!.standTime < level.time {
        // Only strafe when we can see the player
        if visible {
            Sentry_Strafe()
            return
        }
    }

    //If we don't want to advance, stop here
    if !advance && visible {
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

    speed = Float(SENTRY_FORWARD_BASE_SPEED + SENTRY_FORWARD_MULTIPLIER * g_spskill.integer)
    _VectorMA(NPC!.client!.ps.velocity, speed, forward, &NPC!.client!.ps.velocity)
}

/**
```
-------------------------
Sentry_RangedAttack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:418
func Sentry_RangedAttack(_ visible: Bool, _ advance: Bool) {
    if TIMER_Done(NPC!, "attackDelay") && NPC!.attackDebounceTime < level.time && visible {
        if NPCInfo!.burstCount > 6 {
            if NPC!.fly_sound_debounce_time == 0 {
                //delay closing down to give the player an opening
                NPC!.fly_sound_debounce_time = level.time + Q_irand(500, 2000)
            } else if NPC!.fly_sound_debounce_time < level.time {
                NPCInfo!.localState = LSTATE_ACTIVE
                NPCInfo!.burstCount = 0
                NPC!.fly_sound_debounce_time = NPCInfo!.burstCount
                TIMER_Set(NPC!, "attackDelay", Q_irand(2000, 3500))
                NPC!.flags |= FL_SHIELDED
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_FLY_SHIELDED, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                G_SoundOnEnt(NPC!, CHAN_AUTO, "sound/chars/sentry/misc/sentry_shield_close")
            }
        } else {
            Sentry_Fire()
        }
    }

    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        Sentry_Hunt(visible, advance)
    }
}

/**
```
-------------------------
Sentry_AttackDecision
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:455
func Sentry_AttackDecision() {
    let distance: Float
    let visible: Bool
    let advance: Bool

    // Always keep a good height off the ground
    Sentry_MaintainHeight()

    NPC!.s.loopSound = G_SoundIndex("sound/chars/sentry/misc/sentry_hover_2_lp")

    //randomly talk
    if TIMER_Done(NPC!, "patrolNoise") {
        if TIMER_Done(NPC!, "angerNoise") {
            G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/sentry/misc/talk%d", Q_irand(1, 3)))

            TIMER_Set(NPC!, "patrolNoise", Q_irand(4000, 10000))
        }
    }

    // He's dead.
    if NPC!.enemy!.health < 1 {
        NPC!.enemy = nil
        Sentry_Idle()
        return
    }

    // If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        Sentry_Idle()
        return
    }

    // Rate our distance to the target and visibilty
    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE_SQR))

    // If we cannot see our target, move to see it
    if visible == false {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            Sentry_Hunt(visible, advance)
            return
        }
    }

    NPC_FaceEnemy(true)

    Sentry_RangedAttack(visible, advance)
}

/**
```
-------------------------
NPC_Sentry_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:519
func NPC_Sentry_Patrol() {
    Sentry_MaintainHeight()

    //If we have somewhere to go, then do that
    if NPC!.enemy == nil {
        if NPC_CheckPlayerTeamStealth() {
            //NPC_AngerSound();
            NPC_UpdateAngles(true, true)
            return
        }

        if UpdateGoal() != nil {
            //start loop sound once we move
            ucmd.buttons |= BUTTON_WALKING
            NPC_MoveToGoal(true)
        }

        //randomly talk
        if TIMER_Done(NPC!, "patrolNoise") {
            G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/sentry/misc/talk%d", Q_irand(1, 3)))

            TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
        }
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
NPC_BSSentry_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Sentry.c:557
func NPC_BSSentry_Default() {
    if NPC!.targetname != nil {
        NPC!.use = Use.sentry_use
    }

    if NPC!.enemy != nil && (NPCInfo!.localState != LSTATE_WAKEUP) {
        // Don't attack if waking up or if no enemy
        Sentry_AttackDecision()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        NPC_Sentry_Patrol()
    } else {
        Sentry_Idle()
    }
}
