import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:10
private let LSTATE_NONE: Int32 = 0
private let LSTATE_BACKINGUP: Int32 = 1
private let LSTATE_SPINNING: Int32 = 2
private let LSTATE_PAIN: Int32 = 3
private let LSTATE_DROP: Int32 = 4

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:47
private let VELOCITY_DECAY = 0.85 as Float

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:178
private let HUNTER_STRAFE_VEL = 256 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:179
private let HUNTER_STRAFE_DIS = 200 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:180
private let HUNTER_UPWARD_PUSH = 32 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:217
private let HUNTER_FORWARD_BASE_SPEED = 10 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:218
private let HUNTER_FORWARD_MULTIPLIER = 5 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:371
private let MIN_MELEE_RANGE = 320 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:372
private let MIN_MELEE_RANGE_SQR = (MIN_MELEE_RANGE * MIN_MELEE_RANGE)

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:374
private let MIN_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:375
private let MIN_DISTANCE_SQR = (MIN_DISTANCE * MIN_DISTANCE)

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:21
func NPC_Probe_Precache() {
    var i: Int32

    i = 1
    while i < 4 {
        G_SoundIndex(va("sound/chars/probe/misc/probetalk%d", i))
        i += 1
    }
    G_SoundIndex("sound/chars/probe/misc/probedroidloop")
    G_SoundIndex("sound/chars/probe/misc/anger1")
    G_SoundIndex("sound/chars/probe/misc/fire")

    G_EffectIndex("chunks/probehead")
    G_EffectIndex("env/med_explode2")
    G_EffectIndex("explosions/probeexplosion1")
    G_EffectIndex("bryar/muzzle_flash")

    RegisterItem(BG_FindItemForAmmo(AMMO_BLASTER)!)
    RegisterItem(BG_FindItemForWeapon(WP_BRYAR_PISTOL)!)
}

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:49
func ImperialProbe_MaintainHeight() {
    var dif: Float
    //	vec3_t	endPos;
    //	trace_t	trace;

    // Update our angles regardless
    NPC_UpdateAngles(true, true)

    // If we have an enemy, we should try to hover at about enemy eye level
    if NPC!.enemy != nil {
        // Find the height difference
        dif = NPC!.enemy!.r.currentOrigin[2] - NPC!.r.currentOrigin[2]

        // cap to prevent dramatic height shifts
        if abs(dif) > 8 {
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

        // Stay at a given height until we take on an enemy
        /*		VectorSet( endPos, NPC->r.currentOrigin[0], NPC->r.currentOrigin[1], NPC->r.currentOrigin[2] - 512 );
        trap_Trace( &trace, NPC->r.currentOrigin, NULL, NULL, endPos, NPC->s.number, MASK_SOLID );

        if ( trace.fraction != 1.0f )
        {
        float	length = ( trace.fraction * 512 );

        if ( length < 80 )
        {
        ucmd.upmove = 32;
        }
        else if ( length > 120 )
        {
        ucmd.upmove = -32;
        }
        else
        {
        if ( NPC->client->ps.velocity[2] )
        {
        NPC->client->ps.velocity[2] *= VELOCITY_DECAY;

        if ( fabs( NPC->client->ps.velocity[2] ) < 1 )
        {
        NPC->client->ps.velocity[2] = 0;
        }
        }
        }
        } */
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

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:182
func ImperialProbe_Strafe() {
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
        _VectorMA(NPC!.r.currentOrigin, Float(HUNTER_STRAFE_DIS * dir), right, &end)

        trap_Trace(tr, NPC!.r.currentOrigin, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SOLID)

        // Close enough
        if tr.fraction > 0.9 {
            _VectorMA(NPC!.client!.ps.velocity, Float(HUNTER_STRAFE_VEL * dir), right, &NPC!.client!.ps.velocity)

            // Add a slight upward push
            NPC!.client!.ps.velocity[2] += HUNTER_UPWARD_PUSH

            // Set the strafe start time so we can do a controlled roll
            //NPC->fx_time = level.time;
            // The SDK also declares `random`, so the call names the bg module.
            NPCInfo!.standTime = Int32(level.time + 3000 + JKAMP_BG.random() * 500)
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:220
func ImperialProbe_Hunt(_ visible: Bool, _ advance: Bool) {
    var distance: Float = 0
    let speed: Float
    var forward = vec3_t()

    NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

    //If we're not supposed to stand still, pursue the player
    if NPCInfo!.standTime < level.time {
        // Only strafe when we can see the player
        if visible {
            ImperialProbe_Strafe()
            return
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
ImperialProbe_FireBlaster
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:268
func ImperialProbe_FireBlaster() {
    var muzzle1 = vec3_t()
    var enemy_org1 = vec3_t()
    var delta1 = vec3_t()
    var angleToEnemy1 = vec3_t()
    var forward = vec3_t()
    var vright = vec3_t()
    var up = vec3_t()
    var muzzle = vec3_t()
    var genBolt1: Int32 = 0
    var missile: Entity?
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in

        genBolt1 = trap_G2API_AddBolt(NPC!.ghoul2, 0, "*flash")

        //FIXME: use {0, NPC->client->ps.legsYaw, 0}
        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, genBolt1, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &muzzle1)

        G_PlayEffectID(G_EffectIndex("bryar/muzzle_flash"), muzzle1, vec3_origin)

        G_Sound(NPC!, CHAN_AUTO, G_SoundIndex("sound/chars/probe/misc/fire"))

        if NPC!.health != 0 {
            CalcEntitySpot(NPC!.enemy!, SPOT_CHEST, &enemy_org1)
            enemy_org1[0] += Q_irand(0, 10)
            enemy_org1[1] += Q_irand(0, 10)
            delta1 = enemy_org1 - muzzle1
            vectoangles(delta1, &angleToEnemy1)
            AngleVectors(angleToEnemy1, &forward, &vright, &up)
        } else {
            AngleVectors(NPC!.r.currentAngles, &forward, &vright, &up)
        }

        missile = CreateMissile(&muzzle1, forward, 1600, 10000, NPC!, false)

        missile!.classname = "bryar_proj"
        missile!.s.weapon = WP_BRYAR_PISTOL

        if g_spskill.integer <= 1 {
            missile!.damage = 5
        } else {
            missile!.damage = 10
        }


        missile!.dflags = DAMAGE_DEATH_KNOCKBACK
        missile!.methodOfDeath = MOD_UNKNOWN
        missile!.clipmask = MASK_SHOT | CONTENTS_LIGHTSABER
    }
}

/**
```
-------------------------
ImperialProbe_Ranged
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:331
func ImperialProbe_Ranged(_ visible: Bool, _ advance: Bool) {
    var delay_min: Int32
    var delay_max: Int32

    if TIMER_Done(NPC!, "attackDelay") {
        if g_spskill.integer == 0 {
            delay_min = 500
            delay_max = 3000
        } else if g_spskill.integer > 1 {
            delay_min = 500
            delay_max = 2000
        } else {
            delay_min = 300
            delay_max = 1500
        }

        TIMER_Set(NPC!, "attackDelay", Q_irand(500, 3000))
        ImperialProbe_FireBlaster()
        //		ucmd.buttons |= BUTTON_ATTACK;
    }

    if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
        ImperialProbe_Hunt(visible, advance)
    }
}

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:377
func ImperialProbe_AttackDecision() {
    let distance: Float
    let visible: Bool
    let advance: Bool

    // Always keep a good height off the ground
    ImperialProbe_MaintainHeight()

    //randomly talk
    if TIMER_Done(NPC!, "patrolNoise") {
        if TIMER_Done(NPC!, "angerNoise") {
            G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/probe/misc/probetalk%d", Q_irand(1, 3)))

            TIMER_Set(NPC!, "patrolNoise", Q_irand(4000, 10000))
        }
    }

    // If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        ImperialProbe_Idle()
        return
    }

    NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1, SETANIM_FLAG_NORMAL)

    // Rate our distance to the target, and our visibilty
    distance = Float(Int32(DistanceHorizontalSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)))
    visible = NPC_ClearLOS4(NPC!.enemy!)
    advance = Bool((distance > MIN_DISTANCE_SQR))

    // If we cannot see our target, move to see it
    if visible == false {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            ImperialProbe_Hunt(visible, advance)
            return
        }
    }

    // Sometimes I have problems with facing the enemy I'm attacking, so force the issue so I don't look dumb
    NPC_FaceEnemy(true)

    // Decide what type of attack to do
    ImperialProbe_Ranged(visible, advance)
}

/**
```
-------------------------
NPC_BSDroid_Pain
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:433
func NPC_Probe_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var pain_chance: Float = 0
    let other: Entity? = attacker
    let mod: Int32 = gPainMOD

    `self`.s.angles = `self`.NPC!.lastPathAngles

    if `self`.health < 30 || mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT {
        var endPos = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        Trace.scratch { trace in

            endPos = vec3_t(`self`.r.currentOrigin[0], `self`.r.currentOrigin[1], `self`.r.currentOrigin[2] - 128)
            trap_Trace(trace, `self`.r.currentOrigin, vec3_origin, vec3_origin, endPos, `self`.s.number, MASK_SOLID)

            if trace.fraction == 1.0 || mod == MOD_DEMP2 {
                /*
                if (self->client->clientInfo.headModel != 0)
                {
                vec3_t origin;

                VectorCopy(self->r.currentOrigin,origin);
                origin[2] +=50;
                //				G_PlayEffect( "small_chunks", origin );
                G_PlayEffect( "chunks/probehead", origin );
                G_PlayEffect( "env/med_explode2", origin );
                self->client->clientInfo.headModel = 0;
                self->client->moveType = MT_RUNJUMP;
                self->client->ps.gravity = g_gravity->value*.1;
                }
                */

                if (mod == MOD_DEMP2 || mod == MOD_DEMP2_ALT) && other != nil {
                    var dir = vec3_t()

                    NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)

                    dir = `self`.r.currentOrigin - other!.r.currentOrigin
                    VectorNormalize(&dir)

                    _VectorMA(`self`.client!.ps.velocity, 550, dir, &`self`.client!.ps.velocity)
                    `self`.client!.ps.velocity[2] -= 127
                }

                //self->s.powerups |= ( 1 << PW_SHOCKED );
                //self->client->ps.powerups[PW_SHOCKED] = level.time + 3000;
                `self`.client!.ps.electrifyTime = level.time + 3000

                `self`.NPC!.localState = LSTATE_DROP
            }
        }
    } else {
        pain_chance = NPC_GetPainChance(`self`, damage)

        // The SDK also declares `random`, so the call names the bg module.
        if JKAMP_BG.random() < pain_chance {
            NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_PAIN1, SETANIM_FLAG_OVERRIDE)
        }
    }

    NPC_Pain(`self`, attacker, damage)
}

/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:506
func ImperialProbe_Idle() {
    ImperialProbe_MaintainHeight()

    NPC_BSIdle()
}

/**
```
-------------------------
NPC_BSImperialProbe_Patrol
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:518
func ImperialProbe_Patrol() {
    ImperialProbe_MaintainHeight()

    if NPC_CheckPlayerTeamStealth() {
        NPC_UpdateAngles(true, true)
        return
    }

    //If we have somewhere to go, then do that
    if NPC!.enemy == nil {
        NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_RUN1, SETANIM_FLAG_NORMAL)

        if UpdateGoal() != nil {
            //start loop sound once we move
            NPC!.s.loopSound = G_SoundIndex("sound/chars/probe/misc/probedroidloop")
            ucmd.buttons |= BUTTON_WALKING
            NPC_MoveToGoal(true)
        }
        //randomly talk
        if TIMER_Done(NPC!, "patrolNoise") {
            G_SoundOnEnt(NPC!, CHAN_AUTO, va("sound/chars/probe/misc/probetalk%d", Q_irand(1, 3)))

            TIMER_Set(NPC!, "patrolNoise", Q_irand(2000, 4000))
        }
    } else {
        G_SoundOnEnt(NPC!, CHAN_AUTO, "sound/chars/probe/misc/anger1")
        TIMER_Set(NPC!, "angerNoise", Q_irand(2000, 4000))
        //NPCInfo->behaviorState = BS_HUNT_AND_KILL;
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
ImperialProbe_Wait
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:563
func ImperialProbe_Wait() {
    if NPCInfo!.localState == LSTATE_DROP {
        var endPos = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        Trace.scratch { trace in

            NPCInfo!.desiredYaw = AngleNormalize360(NPCInfo!.desiredYaw + 25)

            endPos = vec3_t(NPC!.r.currentOrigin[0], NPC!.r.currentOrigin[1], NPC!.r.currentOrigin[2] - 32)
            trap_Trace(trace, NPC!.r.currentOrigin, vec3_origin, vec3_origin, endPos, NPC!.s.number, MASK_SOLID)

            if trace.fraction != 1.0 {
                var dir: vec3_t? = nil
                G_Damage(NPC!, NPC!.enemy, NPC!.enemy, &dir, nil, 2000, 0, MOD_UNKNOWN)
            }
        }
    }

    NPC_UpdateAngles(true, true)
}

/**
```
-------------------------
NPC_BSImperialProbe_Default
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_ImperialProbe.c:589
func NPC_BSImperialProbe_Default() {
    if NPC!.enemy != nil {
        NPCInfo!.goalEntity = NPC!.enemy
        ImperialProbe_AttackDecision()
    } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
        ImperialProbe_Patrol()
    } else if NPCInfo!.localState == LSTATE_DROP {
        ImperialProbe_Wait()
    } else {
        ImperialProbe_Idle()
    }
}
