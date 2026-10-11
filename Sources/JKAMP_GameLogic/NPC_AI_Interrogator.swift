import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:129
private let VELOCITY_DECAY = 0.85 as Float

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:130
private let HUNTER_UPWARD_PUSH = 2 as Int32

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:231
private let HUNTER_STRAFE_VEL = 32 as Int32

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:232
private let HUNTER_STRAFE_DIS = 200 as Int32

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:287
private let HUNTER_FORWARD_BASE_SPEED = 10 as Int32

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:288
private let HUNTER_FORWARD_MULTIPLIER = 2 as Int32

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:338
private let MIN_DISTANCE = 64 as Int32

/**
```
-------------------------
NPC_Interrogator_Precache
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:20
func NPC_Interrogator_Precache(_ `self`: Entity?) {
    G_SoundIndex("sound/chars/interrogator/misc/torture_droid_lp")
    G_SoundIndex("sound/chars/mark1/misc/anger.wav")
    G_SoundIndex("sound/chars/probe/misc/talk")
    G_SoundIndex("sound/chars/interrogator/misc/torture_droid_inject")
    G_SoundIndex("sound/chars/interrogator/misc/int_droid_explo")
    G_EffectIndex("explosions/droidexplosion1")
}

/**
```
-------------------------
Interrogator_die
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:34
func Interrogator_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32, _ dFlags: Int32, _ hitLoc: Int32) {
    `self`.client!.ps.velocity[2] = -100
    /*
    self->locationDamage[HL_NONE] += damage;
    if (self->locationDamage[HL_NONE] > 40)
    {
    DeathFX(self);
    self->client->ps.eFlags |= EF_NODRAW;
    self->contents = CONTENTS_CORPSE;
    }
    else
    */
    do {
        `self`.client!.ps.eFlags2 &= ~EF2_FLYING //moveType = MT_WALK;
        `self`.client!.ps.velocity[0] = Float(Q_irand(-10, -20))
        `self`.client!.ps.velocity[1] = Float(Q_irand(-10, -20))
        `self`.client!.ps.velocity[2] = -100
    }
    //self->takedamage = qfalse;
    //self->client->ps.eFlags |= EF_NODRAW;
    //self->contents = 0;
    return
}

/**
```
-------------------------
Interrogator_PartsMove
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:64
func Interrogator_PartsMove() {
    // Syringe
    if TIMER_Done(NPC!, "syringeDelay") {
        NPC!.pos1[1] = AngleNormalize360(NPC!.pos1[1])

        if (NPC!.pos1[1] < 60) || (NPC!.pos1[1] > 300) {
            NPC!.pos1[1] += Q_irand(-20, 20) // Pitch
        } else if NPC!.pos1[1] > 180 {
            NPC!.pos1[1] = Float(Q_irand(300, 360)) // Pitch
        } else {
            NPC!.pos1[1] = Float(Q_irand(0, 60)) // Pitch
        }

        //	gi.G2API_SetBoneAnglesIndex( &NPC->ghoul2[NPC->playerModel], NPC->genericBone1, NPC->pos1, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, NULL );
        NPC_SetBoneAngles(NPC!, "left_arm", NPC!.pos1)

        TIMER_Set(NPC!, "syringeDelay", Q_irand(100, 1000))
    }

    // Scalpel
    if TIMER_Done(NPC!, "scalpelDelay") {
        // Change pitch
        if NPCInfo!.localState == LSTATE_BLADEDOWN {
            NPC!.pos2[0] -= 30
            if NPC!.pos2[0] < 180 {
                NPC!.pos2[0] = 180
                NPCInfo!.localState = LSTATE_BLADEUP // Make it move up
            }
        } else {
            NPC!.pos2[0] += 30
            if NPC!.pos2[0] >= 360 {
                NPC!.pos2[0] = 360
                NPCInfo!.localState = LSTATE_BLADEDOWN // Make it move down
                TIMER_Set(NPC!, "scalpelDelay", Q_irand(100, 1000))
            }
        }

        NPC!.pos2[0] = AngleNormalize360(NPC!.pos2[0])
        //	gi.G2API_SetBoneAnglesIndex( &NPC->ghoul2[NPC->playerModel], NPC->genericBone2, NPC->pos2, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, NULL );

        NPC_SetBoneAngles(NPC!, "right_arm", NPC!.pos2)
    }

    // Claw
    NPC!.pos3[1] += Q_irand(10, 30)
    NPC!.pos3[1] = AngleNormalize360(NPC!.pos3[1])
    //gi.G2API_SetBoneAnglesIndex( &NPC->ghoul2[NPC->playerModel], NPC->genericBone3, NPC->pos3, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, NULL );

    NPC_SetBoneAngles(NPC!, "claw", NPC!.pos3)
}

/**
```
-------------------------
Interrogator_MaintainHeight
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:137
func Interrogator_MaintainHeight() {
    var dif: Float
    //	vec3_t	endPos;
    //	trace_t	trace;

    NPC!.s.loopSound = G_SoundIndex("sound/chars/interrogator/misc/torture_droid_lp")
    // Update our angles regardless
    NPC_UpdateAngles(true, true)

    // If we have an enemy, we should try to hover at about enemy eye level
    if NPC!.enemy != nil {
        // Find the height difference
        dif = (NPC!.enemy!.r.currentOrigin[2] + NPC!.enemy!.r.maxs[2]) - NPC!.r.currentOrigin[2]

        // cap to prevent dramatic height shifts
        if abs(dif) > 2 {
            if abs(dif) > 16 {
                dif = Float((dif < 0 ? -16 : 16))
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

            if abs(dif) > 24 {
                ucmd.upmove = (ucmd.upmove < 0 ? -4 : 4)
            } else {
                if NPC!.client!.ps.velocity[2] != 0 {
                    NPC!.client!.ps.velocity[2] *= VELOCITY_DECAY

                    if abs(NPC!.client!.ps.velocity[2]) < 2 {
                        NPC!.client!.ps.velocity[2] = 0
                    }
                }
            }
        } else if NPC!.client!.ps.velocity[2] != 0 {
            // Apply friction
            NPC!.client!.ps.velocity[2] *= VELOCITY_DECAY

            if abs(NPC!.client!.ps.velocity[2]) < 1 {
                NPC!.client!.ps.velocity[2] = 0
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
Interrogator_Strafe
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:238
func Interrogator_Strafe() {
    var dir: Int32 = 0
    var end = vec3_t()
    var right = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var dif: Float = 0

        // Raven passes NULL for the `forward` and `up` outputs.
        var scratchForward = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(NPC!.client!.renderInfo.eyeAngles, &scratchForward, &right, &scratchUp)

        // Pick a random strafe direction, then check to see if doing a strafe would be
        //	reasonable valid
        // The SDK also declares `rand`, so the call names the bg module.
        dir = (JKAMP_BG.rand() & 1) != 0 ? -1 : 1
        _VectorMA(NPC!.r.currentOrigin, Float(HUNTER_STRAFE_DIS * dir), right, &end)

        trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SOLID)

        // Close enough
        if tr.fraction > 0.9 {
            _VectorMA(NPC!.client!.ps.velocity, Float(HUNTER_STRAFE_VEL * dir), right, &NPC!.client!.ps.velocity)

            // Add a slight upward push
            if NPC!.enemy != nil {
                // Find the height difference
                dif = (NPC!.enemy!.r.currentOrigin[2] + 32) - NPC!.r.currentOrigin[2]

                // cap to prevent dramatic height shifts
                if abs(dif) > 8 {
                    dif = Float((dif < 0 ? -HUNTER_UPWARD_PUSH : HUNTER_UPWARD_PUSH))
                }

                NPC!.client!.ps.velocity[2] += dif
            }

            // Set the strafe start time
            //NPC->fx_time = level.time;
            // The SDK also declares `random`, so the call names the bg module.
            NPCInfo!.standTime = Int32(level.time + 3000 + JKAMP_BG.random() * 500)
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:290
func Interrogator_Hunt(_ visible: Bool, _ advance: Bool) {
    var distance: Float = 0
    let speed: Float
    var forward = vec3_t()

    Interrogator_PartsMove()

    NPC_FaceEnemy(false)

    //If we're not supposed to stand still, pursue the player
    if NPCInfo!.standTime < level.time {
        // Only strafe when we can see the player
        if visible {
            Interrogator_Strafe()
            if NPCInfo!.standTime > level.time {
                //successfully strafed
                return
            }
        }
    }

    //If we don't want to advance, stop here
    if advance == false {
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

    speed = Float(HUNTER_FORWARD_BASE_SPEED + HUNTER_FORWARD_MULTIPLIER * g_spskill.integer)
    _VectorMA(NPC!.client!.ps.velocity, speed, forward, &NPC!.client!.ps.velocity)
}

/**
```
-------------------------
Interrogator_Melee
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:345
func Interrogator_Melee(_ visible: Bool, _ advance: Bool) {
    if TIMER_Done(NPC!, "attackDelay") {
        // Make sure that we are within the height range before we allow any damage to happen
        if NPC!.r.currentOrigin[2] >= NPC!.enemy!.r.currentOrigin[2] + NPC!.enemy!.r.mins[2] && NPC!.r.currentOrigin[2] + NPC!.r.mins[2] + 8 < NPC!.enemy!.r.currentOrigin[2] + NPC!.enemy!.r.maxs[2] {
            //gentity_t *tent;

            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 3000))
            var dir: vec3_t? = nil
            G_Damage(NPC!.enemy!, NPC, NPC, &dir, nil, 2, DAMAGE_NO_KNOCKBACK, MOD_MELEE)

            //	NPC->enemy->client->poisonDamage = 18;
            //	NPC->enemy->client->poisonTime = level.time + 1000;

            // Drug our enemy up and do the wonky vision thing
            //			tent = G_TempEntity( NPC->enemy->r.currentOrigin, EV_DRUGGED );
            //			tent->owner = NPC->enemy;

            //rwwFIXMEFIXME: poison damage

            G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/interrogator/misc/torture_droid_inject.mp3"))
        }
    }

    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        Interrogator_Hunt(visible, advance)
    }
}

/**
```
-------------------------
Interrogator_Attack
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:381
func Interrogator_Attack() {
    let distance: Float
    let visible: Bool
    var advance: Bool

    // Always keep a good height off the ground
    Interrogator_MaintainHeight()

    //randomly talk
    if TIMER_Done(NPC!, "patrolNoise") {
        if TIMER_Done(NPC!, "angerNoise") {
            G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/probe/misc/talk.wav", Q_irand(1, 3)))

            TIMER_Set(NPC!, "patrolNoise", Q_irand(4000, 10000))
        }
    }

    // If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        Interrogator_Idle()
        return
    }

    // Rate our distance to the target, and our visibilty
    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE * MIN_DISTANCE))

    if !visible {
        advance = true
    }
    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        Interrogator_Hunt(visible, advance)
    }

    NPC_FaceEnemy(true)

    if !advance {
        Interrogator_Melee(visible, advance)
    }
}

/**
```
-------------------------
Interrogator_Idle
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:435
func Interrogator_Idle() {
    if NPC_CheckPlayerTeamStealth() {
        G_SoundOnEnt(NPC!, CHAN_AUTO, "sound/chars/mark1/misc/anger.wav")
        NPC_UpdateAngles(true, true)
        return
    }

    Interrogator_MaintainHeight()

    NPC_BSIdle()
}

/**
```
-------------------------
NPC_BSInterrogator_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Interrogator.c:454
func NPC_BSInterrogator_Default() {
    //NPC->e_DieFunc = dieF_Interrogator_die;

    if NPC!.enemy != nil {
        Interrogator_Attack()
    } else {
        Interrogator_Idle()
    }
}
