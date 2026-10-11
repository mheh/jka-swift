import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:19
let MELEE_DIST_SQUARED = 6400 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:20
let MIN_LOB_DIST_SQUARED = 65536 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:21
let MAX_LOB_DIST_SQUARED = 200704 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:22
private let REPEATER_ALT_SIZE = 3 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:23
let GENERATOR_HEALTH = 25 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:24
private let TURN_ON = 0x00000000 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:25
private let TURN_OFF = 0x00000100 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:26
let GALAK_SHIELD_HEALTH = 500 as Int32

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:28
/// Raven's data table, a hand property of `GameWorld`.
var shieldMins: JKAShared.vec3_t {
    get { world.shieldMins }
    set { world.shieldMins = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:29
/// Raven's data table, a hand property of `GameWorld`.
var shieldMaxs: JKAShared.vec3_t {
    get { world.shieldMaxs }
    set { world.shieldMaxs = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:33
var enemyLOS4: Bool {
    get { world.variables.enemyLOS4 }
    set { world.variables.enemyLOS4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:34
var enemyCS4: Bool {
    get { world.variables.enemyCS4 }
    set { world.variables.enemyCS4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:35
var hitAlly4: Bool {
    get { world.variables.hitAlly4 }
    set { world.variables.hitAlly4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:36
var faceEnemy4: Bool {
    get { world.variables.faceEnemy4 }
    set { world.variables.faceEnemy4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:37
var move4: Bool {
    get { world.variables.move4 }
    set { world.variables.move4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:38
var shoot4: Bool {
    get { world.variables.shoot4 }
    set { world.variables.shoot4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:39
var enemyDist4: Float {
    get { world.variables.enemyDist4 }
    set { world.variables.enemyDist4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:40
var impactPos4: JKAShared.vec3_t {
    get { world.variables.impactPos4 }
    set { world.variables.impactPos4 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:42
func NPC_GalakMech_Precache() {
    G_SoundIndex("sound/weapons/galak/skewerhit.wav")
    G_SoundIndex("sound/weapons/galak/lasercharge.wav")
    G_SoundIndex("sound/weapons/galak/lasercutting.wav")
    G_SoundIndex("sound/weapons/galak/laserdamage.wav")

    G_EffectIndex("galak/trace_beam")
    G_EffectIndex("galak/beam_warmup")
    //	G_EffectIndex( "small_chunks");
    G_EffectIndex("env/med_explode2")
    G_EffectIndex("env/small_explode2")
    G_EffectIndex("galak/explode")
    G_EffectIndex("blaster/smoke_bolton")
    //	G_EffectIndex( "env/exp_trail_comp");
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:59
func NPC_GalakMech_Init(_ ent: Entity) {
    if ent.NPC!.behaviorState != BS_CINEMATIC {
        ent.client!.ps.stats[STAT_ARMOR] = GALAK_SHIELD_HEALTH
        ent.NPC!.investigateDebounceTime = 0
        ent.NPC!.investigateCount = ent.NPC!.investigateDebounceTime
        ent.flags |= FL_SHIELDED //reflect normal shots
        //rwwFIXMEFIXME: Support PW_GALAK_SHIELD
        //ent->client->ps.powerups[PW_GALAK_SHIELD] = Q3_INFINITE;//temp, for effect
        //ent->fx_time = level.time;
        ent.r.mins = vec3_t(-60, -60, -24)
        ent.r.maxs = vec3_t(60, 60, 80)
        ent.flags |= FL_NO_KNOCKBACK //don't get pushed
        TIMER_Set(ent, "attackDelay", 0) //FIXME: Slant for difficulty levels
        TIMER_Set(ent, "flee", 0)
        TIMER_Set(ent, "smackTime", 0)
        TIMER_Set(ent, "beamDelay", 0)
        TIMER_Set(ent, "noLob", 0)
        TIMER_Set(ent, "noRapid", 0)
        TIMER_Set(ent, "talkDebounce", 0)

        NPC_SetSurfaceOnOff(ent, "torso_shield", TURN_ON)
        NPC_SetSurfaceOnOff(ent, "torso_galakface", TURN_OFF)
        NPC_SetSurfaceOnOff(ent, "torso_galakhead", TURN_OFF)
        NPC_SetSurfaceOnOff(ent, "torso_eyes_mouth", TURN_OFF)
        NPC_SetSurfaceOnOff(ent, "torso_collar", TURN_OFF)
        NPC_SetSurfaceOnOff(ent, "torso_galaktorso", TURN_OFF)
    } else {
        //		NPC_SetSurfaceOnOff( ent, "helmet", TURN_OFF );
        NPC_SetSurfaceOnOff(ent, "torso_shield", TURN_OFF)
        NPC_SetSurfaceOnOff(ent, "torso_galakface", TURN_ON)
        NPC_SetSurfaceOnOff(ent, "torso_galakhead", TURN_ON)
        NPC_SetSurfaceOnOff(ent, "torso_eyes_mouth", TURN_ON)
        NPC_SetSurfaceOnOff(ent, "torso_collar", TURN_ON)
        NPC_SetSurfaceOnOff(ent, "torso_galaktorso", TURN_ON)
    }
}

//-----------------------------------------------------------------
/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:101
private func GM_CreateExplosion(_ `self`: Entity, _ boltID: Int32, _ doSmall: Bool) {
    if boltID >= 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var org = vec3_t()
            var dir = vec3_t()

            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, boltID, boltMatrix, `self`.r.currentAngles, `self`.r.currentOrigin, level.time, nil, &`self`.modelScale)

            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &org)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &dir)

            if doSmall {
                G_PlayEffectID(G_EffectIndex("env/small_explode2"), org, dir)
            } else {
                G_PlayEffectID(G_EffectIndex("env/med_explode2"), org, dir)
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:133
func GM_Dying(_ `self`: Entity) {
    if level.time - `self`.s.time < 4000 {
        //FIXME: need a real effect
        //self->s.powerups |= ( 1 << PW_SHOCKED );
        //self->client->ps.powerups[PW_SHOCKED] = level.time + 1000;
        `self`.client!.ps.electrifyTime = level.time + 1000
        if TIMER_Done(`self`, "dyingExplosion") {
            var newBolt: Int32
            switch Q_irand(1, 14) {
            // Find place to generate explosion
            case 1:
                if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "r_hand") == 0 {
                    //r_hand still there
                    GM_CreateExplosion(`self`, trap_G2API_AddBolt(`self`.ghoul2, 0, "*flasha"), true)
                    NPC_SetSurfaceOnOff(`self`, "r_hand", TURN_OFF)
                } else if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "r_arm_middle") == 0 {
                    //r_arm_middle still there
                    newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_arm_elbow")
                    NPC_SetSurfaceOnOff(`self`, "r_arm_middle", TURN_OFF)
                }

            case 2:
                //FIXME: do only once?
                if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "l_hand") == 0 {
                    //l_hand still there
                    GM_CreateExplosion(`self`, trap_G2API_AddBolt(`self`.ghoul2, 0, "*flashc"), false)
                    NPC_SetSurfaceOnOff(`self`, "l_hand", TURN_OFF)
                } else if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "l_arm_wrist") == 0 {
                    //l_arm_wrist still there
                    newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_arm_cap_l_hand")
                    NPC_SetSurfaceOnOff(`self`, "l_arm_wrist", TURN_OFF)
                } else if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "l_arm_middle") == 0 {
                    //l_arm_middle still there
                    newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_arm_cap_l_hand")
                    NPC_SetSurfaceOnOff(`self`, "l_arm_middle", TURN_OFF)
                } else if trap_G2API_GetSurfaceRenderStatus(`self`.ghoul2, 0, "l_arm_augment") == 0 {
                    //l_arm_augment still there
                    newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_arm_elbow")
                    NPC_SetSurfaceOnOff(`self`, "l_arm_augment", TURN_OFF)
                }

            case 3, 4:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*hip_fr")
                GM_CreateExplosion(`self`, newBolt, false)

            case 5, 6:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*shldr_l")
                GM_CreateExplosion(`self`, newBolt, false)

            case 7, 8:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*uchest_r")
                GM_CreateExplosion(`self`, newBolt, false)

            case 9, 10:
                GM_CreateExplosion(`self`, `self`.client!.renderInfo.headBolt, false)

            case 11:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_leg_knee")
                GM_CreateExplosion(`self`, newBolt, true)

            case 12:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_leg_knee")
                GM_CreateExplosion(`self`, newBolt, true)

            case 13:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*l_leg_foot")
                GM_CreateExplosion(`self`, newBolt, true)

            case 14:
                newBolt = trap_G2API_AddBolt(`self`.ghoul2, 0, "*r_leg_foot")
                GM_CreateExplosion(`self`, newBolt, true)

            default:
                break
            }

            TIMER_Set(`self`, "dyingExplosion", Q_irand(300, 1100))
        }
    } else {
        //one final, huge explosion
        G_PlayEffectID(G_EffectIndex("galak/explode"), `self`.r.currentOrigin, vec3_origin)
        //		G_PlayEffect( "small_chunks", self->r.currentOrigin );
        //		G_PlayEffect( "env/exp_trail_comp", self->r.currentOrigin, self->currentAngles );
        `self`.nextthink = level.time + FRAMETIME
        `self`.think = Think.G_FreeEntity
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:238
func NPC_GM_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    var point = vec3_t()
    let inflictor: Entity? = attacker
    let hitLoc: Int32 = 1
    let mod: Int32 = gPainMOD

    point = gPainPoint

    //if ( self->client->ps.powerups[PW_GALAK_SHIELD] == 0 )
    if 0 != 0 {
        //shield is currently down
        //FIXME: allow for radius damage?
        /*
        if ( (hitLoc==HL_GENERIC1) && (self->locationDamage[HL_GENERIC1] > GENERATOR_HEALTH) )
        {
        int newBolt = gi.G2API_AddBolt( &self->ghoul2[self->playerModel], "*antenna_base" );
        if ( newBolt != -1 )
        {
        GM_CreateExplosion( self, newBolt, qfalse );
        }

        NPC_SetSurfaceOnOff( self, "torso_shield", TURN_OFF );
        NPC_SetSurfaceOnOff( self, "torso_antenna", TURN_OFF );
        NPC_SetSurfaceOnOff( self, "torso_antenna_base_cap", TURN_ON );
        self->client->ps.powerups[PW_GALAK_SHIELD] = 0;//temp, for effect
        self->client->ps.stats[STAT_ARMOR] = 0;//no more armor
        self->NPC->investigateDebounceTime = 0;//stop recharging

        NPC_SetAnim( self, SETANIM_BOTH, BOTH_ALERT1, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD );
        TIMER_Set( self, "attackDelay", self->client->ps.torsoTimer );
        G_AddEvent( self, Q_irand( EV_DEATH1, EV_DEATH3 ), self->health );
        }
        */
    } else {
        //store the point for shield impact
        //	VectorCopy( point, self->pos4 );
        //	self->client->poisonTime = level.time;
        //rwwFIXMEFIXME: ..do this is as well.
    }

    if `self`.lockCount == 0 && `self`.client!.ps.torsoTimer <= 0 {
        //don't interrupt laser sweep attack or other special attacks/moves
        if `self`.count < 4 && `self`.health > 100 && hitLoc != HL_GENERIC1 {
            if `self`.delay < level.time {
                var speech: Int32
                switch `self`.count {
                case 1:
                    speech = EV_PUSHED2

                case 2:
                    speech = EV_PUSHED3

                case 3:
                    speech = EV_DETECTED1

                default:
                    speech = EV_PUSHED1
                }
                `self`.count += 1
                `self`.NPC!.blockedSpeechDebounceTime = 0
                G_AddVoiceEvent(`self`, speech, Q_irand(3000, 5000))
                `self`.delay = level.time + Q_irand(5000, 7000)
            }
        } else {
            NPC_Pain(`self`, attacker, damage)
        }
    } else if hitLoc == HL_GENERIC1 {
        NPC_SetPainEvent(`self`)
        //self->s.powerups |= ( 1 << PW_SHOCKED );
        //self->client->ps.powerups[PW_SHOCKED] = level.time + Q_irand( 500, 2500 );
        `self`.client!.ps.electrifyTime = level.time + Q_irand(500, 2500)
    }

    if inflictor != nil && inflictor!.lastEnemy == `self` {
        //He force-pushed my own lobfires back at me
        if mod == MOD_REPEATER_ALT && Q_irand(0, 2) == 0 {
            if TIMER_Done(`self`, "noRapid") {
                `self`.NPC!.scriptFlags &= ~SCF_ALT_FIRE
                `self`.alt_fire = false
                TIMER_Set(`self`, "noLob", Q_irand(2000, 6000))
            } else {
                //hopefully this will make us fire the laser
                TIMER_Set(`self`, "noLob", Q_irand(1000, 2000))
            }
        } else if mod == MOD_REPEATER && Q_irand(0, 5) == 0 {
            if TIMER_Done(`self`, "noLob") {
                `self`.NPC!.scriptFlags |= SCF_ALT_FIRE
                `self`.alt_fire = true
                TIMER_Set(`self`, "noRapid", Q_irand(2000, 6000))
            } else {
                //hopefully this will make us fire the laser
                TIMER_Set(`self`, "noRapid", Q_irand(1000, 2000))
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:362
private func GM_HoldPosition() {
    NPC_FreeCombatPoint(NPCInfo!.combatPoint, true)
    if !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
        //don't have a script waiting for me to get to my point, okay to stop trying and stand
        NPCInfo!.goalEntity = nil
    }
}

/**
```
-------------------------
GM_Move
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:376
private func GM_Move() -> Bool {
    var moved: Bool = false
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return NavInfo.scratch { info -> Bool in

        NPCInfo!.combatMove = true //always move straight toward our goal

        moved = NPC_MoveToGoal(true)

        //Get the move info
        NAV_GetLastMove(info)

        //FIXME: if we bump into another one of our guys and can't get around him, just stop!
        //If we hit our target, then stop and fire!
        if (info.flags & NIF_COLLISION) != 0 {
            if info.blocker == NPC!.enemy {
                GM_HoldPosition()
            }
        }

        //If our move failed, then reset
        if moved == false {
            //FIXME: if we're going to a combat point, need to pick a different one
            if !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
                //can't transfer movegoal or stop when a script we're running is waiting to complete
                GM_HoldPosition()
            }
        }

        return moved
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:416
func NPC_BSGM_Patrol() {
    if NPC_CheckPlayerTeamStealth() {
        NPC_UpdateAngles(true, true)
        return
    }

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons |= BUTTON_WALKING
        NPC_MoveToGoal(true)
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:440
private func GM_CheckMoveState() {
    if trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
        //moving toward a goal that a script is waiting on, so don't stop for anything!
        move4 = true
    }

    //See if we're moving towards a goal, not the enemy
    if (NPCInfo!.goalEntity != NPC!.enemy) && (NPCInfo!.goalEntity != nil) {
        //Did we make it?
        if NAV_HitNavGoal(NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPCInfo!.goalEntity!.r.currentOrigin, 16, false) || (!trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) && enemyLOS4 && enemyDist4 <= 10000) {
            //either hit our navgoal or our navgoal was not a crucial (scripted) one (maybe a combat point) and we're scouting and found our enemy
            NPC_ReachedGoal()
            //don't attack right away
            TIMER_Set(NPC!, "attackDelay", Q_irand(250, 500)) //FIXME: Slant for difficulty levels
            return
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:468
private func GM_CheckFireState() {
    if enemyCS4 {
        //if have a clear shot, always try
        return
    }

    if VectorCompare(NPC!.client!.ps.velocity, vec3_origin) == 0 {
        //if moving at all, don't do this
        return
    }

    //See if we should continue to fire on their last position
    if !hitAlly4 && NPCInfo!.enemyLastSeenTime > 0 {
        if level.time - NPCInfo!.enemyLastSeenTime < 10000 {
            if Q_irand(0, 10) == 0 {
                //Fire on the last known position
                var muzzle = vec3_t()
                var dir = vec3_t()
                var angles = vec3_t()
                var tooClose: Bool = false
                var tooFar: Bool = false
                var distThreshold: Float = 0
                var dist: Float = 0

                CalcEntitySpot(NPC!, SPOT_HEAD, &muzzle)
                if VectorCompare(impactPos4, vec3_origin) != 0 {
                    //never checked ShotEntity this frame, so must do a trace...
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in
                        //vec3_t	mins = {-2,-2,-2}, maxs = {2,2,2};
                        var forward = vec3_t()
                        var end = vec3_t()
                        // Raven passes NULL for the `right` and `up` outputs.
                        var scratchRight = vec3_t()
                        var scratchUp = vec3_t()
                        AngleVectors(NPC!.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
                        _VectorMA(muzzle, 8192, forward, &end)
                        trap_Trace(tr, muzzle, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SHOT)
                        impactPos4 = tr.endpos
                    }
                }

                //see if impact would be too close to me
                distThreshold = 16384
                if NPC!.s.weapon == WP_REPEATER {
                    if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                        distThreshold = 65536
                    }
                }

                dist = DistanceSquared(impactPos4, muzzle)

                if dist < distThreshold {
                    //impact would be too close to me
                    tooClose = true
                } else if level.time - NPCInfo!.enemyLastSeenTime > 5000 {
                    //we've haven't seen them in the last 5 seconds
                    //see if it's too far from where he is
                    distThreshold = 65536
                    if NPC!.s.weapon == WP_REPEATER {
                        if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                            distThreshold = 262144
                        }
                    }
                    dist = DistanceSquared(impactPos4, NPCInfo!.enemyLastSeenLocation)
                    if dist > distThreshold {
                        //impact would be too far from enemy
                        tooFar = true
                    }
                }

                if !tooClose && !tooFar {
                    //okay too shoot at last pos
                    dir = NPCInfo!.enemyLastSeenLocation - muzzle
                    VectorNormalize(&dir)
                    vectoangles(dir, &angles)

                    NPCInfo!.desiredYaw = angles[YAW]
                    NPCInfo!.desiredPitch = angles[PITCH]

                    shoot4 = true
                    faceEnemy4 = false
                    return
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:558
func NPC_GM_StartLaser() {
    if NPC!.lockCount == 0 {
        //haven't already started a laser attack
        //warm up for the beam attack
        TIMER_Set(NPC!, "beamDelay", NPC!.client!.ps.torsoTimer)
        TIMER_Set(NPC!, "attackDelay", NPC!.client!.ps.torsoTimer + 3000)
        NPC!.lockCount = 1
        //turn on warmup effect
        G_PlayEffectID(G_EffectIndex("galak/beam_warmup"), NPC!.r.currentOrigin, vec3_origin)
        G_SoundOnEnt(NPC!, CHAN_AUTO, "sound/weapons/galak/lasercharge.wav")
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:575
func GM_StartGloat() {
    NPC!.wait = 0
    NPC_SetSurfaceOnOff(NPC!, "torso_galakface", TURN_ON)
    NPC_SetSurfaceOnOff(NPC!, "torso_galakhead", TURN_ON)
    NPC_SetSurfaceOnOff(NPC!, "torso_eyes_mouth", TURN_ON)
    NPC_SetSurfaceOnOff(NPC!, "torso_collar", TURN_ON)
    NPC_SetSurfaceOnOff(NPC!, "torso_galaktorso", TURN_ON)

    NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_STAND2TO1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    NPC!.client!.ps.legsTimer += 500
    NPC!.client!.ps.torsoTimer += 500
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:594
func NPC_BSGM_Attack() {
    //Don't do anything if we're hurt
    if NPC!.painDebounceTime > level.time {
        NPC_UpdateAngles(true, true)
        return
    }

    //FIXME: if killed enemy, use victory anim

    //If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false || NPC!.enemy == nil {
        NPC!.enemy = nil
        NPC_BSGM_Patrol()
        return
    }

    enemyCS4 = false
    enemyLOS4 = enemyCS4
    move4 = true
    faceEnemy4 = false
    shoot4 = false
    hitAlly4 = false
    impactPos4 = vec3_t()
    enemyDist4 = DistanceSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)

    //if ( NPC->client->ps.torsoAnim == BOTH_ATTACK4 ||
    //	NPC->client->ps.torsoAnim == BOTH_ATTACK5 )
    if 0 != 0 {
        shoot4 = false
        if TIMER_Done(NPC!, "smackTime") && NPCInfo!.blockedDebounceTime == 0 {
            //time to smack
            //recheck enemyDist4 and InFront
            if enemyDist4 < MELEE_DIST_SQUARED && InFront(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 0.3) {
                var smackDir = vec3_t()
                smackDir = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
                smackDir[2] += 30
                VectorNormalize(&smackDir)
                //hurt them
                G_Sound(NPC!.enemy!, CHAN_AUTO, G_SoundIndex("sound/weapons/galak/skewerhit.wav"))
                G_Damage(NPC!.enemy!, NPC, NPC, &smackDir, NPC!.r.currentOrigin, (g_spskill.integer + 1) * Q_irand(5, 10), DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK, MOD_CRUSH)
                if NPC!.client!.ps.torsoAnim == BOTH_ATTACK4 {
                    //smackdown
                    var knockAnim: Int32 = BOTH_KNOCKDOWN1
                    if BG_CrouchAnim(NPC!.enemy!.client!.ps.legsAnim) {
                        //knockdown from crouch
                        knockAnim = BOTH_KNOCKDOWN4
                    }
                    //throw them
                    smackDir[2] = 1
                    VectorNormalize(&smackDir)
                    G_Throw(NPC!.enemy!, smackDir, 50)
                    NPC_SetAnim(NPC!.enemy!, SETANIM_BOTH, knockAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                } else {
                    //uppercut
                    //throw them
                    G_Throw(NPC!.enemy!, smackDir, 100)
                    //make them backflip
                    NPC_SetAnim(NPC!.enemy!, SETANIM_BOTH, BOTH_KNOCKDOWN5, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                }
                //done with the damage
                NPCInfo!.blockedDebounceTime = 1
            }
        }
    } else if NPC!.lockCount != 0 {
        //sometimes use the laser beam attack, but only after he's taken down our generator
        shoot4 = false
        if NPC!.lockCount == 1 {
            //charging up
            if TIMER_Done(NPC!, "beamDelay") {
                //time to start the beam
                var laserAnim: Int32 = 0
                //if ( Q_irand( 0, 1 ) )
                if 1 != 0 {
                    laserAnim = BOTH_ATTACK2
                }
                /*
                else
                {
                laserAnim = BOTH_ATTACK7;
                }
                */
                NPC_SetAnim(NPC!, SETANIM_BOTH, laserAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                TIMER_Set(NPC!, "attackDelay", NPC!.client!.ps.torsoTimer + Q_irand(1000, 3000))
                //turn on beam effect
                NPC!.lockCount = 2
                G_PlayEffectID(G_EffectIndex("galak/trace_beam"), NPC!.r.currentOrigin, vec3_origin)
                NPC!.s.loopSound = G_SoundIndex("sound/weapons/galak/lasercutting.wav")
                if NPCInfo!.coverTarg == nil {
                    //for moving looping sound at end of trace
                    NPCInfo!.coverTarg = G_Spawn()
                    if NPCInfo!.coverTarg != nil {
                        G_SetOrigin(NPCInfo!.coverTarg!, &NPC!.client!.renderInfo.muzzlePoint)
                        NPCInfo!.coverTarg!.r.svFlags |= SVF_BROADCAST
                        NPCInfo!.coverTarg!.s.loopSound = G_SoundIndex("sound/weapons/galak/lasercutting.wav")
                    }
                }
            }
        } else {
            //in the actual attack now
            if NPC!.client!.ps.torsoTimer <= 0 {
                //attack done!
                NPC!.lockCount = 0
                G_FreeEntity(NPCInfo!.coverTarg!)
                NPC!.s.loopSound = 0
                TIMER_Set(NPC!, "attackDelay", NPC!.client!.ps.torsoTimer)
            } else {
                //attack still going
                //do the trace and damage
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { trace in
                    var end = vec3_t()
                    var mins = vec3_t(-3, -3, -3)
                    var maxs = vec3_t(3, 3, 3)
                    _VectorMA(NPC!.client!.renderInfo.muzzlePoint, 1024, NPC!.client!.renderInfo.muzzleDir, &end)
                    trap_Trace(trace, NPC!.client!.renderInfo.muzzlePoint, mins, maxs, end, NPC!.s.number, MASK_SHOT)
                    if trace.allsolid != 0 || trace.startsolid != 0 {
                        //oops, in a wall
                        if NPCInfo!.coverTarg != nil {
                            G_SetOrigin(NPCInfo!.coverTarg!, &NPC!.client!.renderInfo.muzzlePoint)
                        }
                    } else {
                        //clear
                        if trace.fraction < 1.0 {
                            //hit something
                            let traceEnt: Entity? = g_entities[trace.entityNum]
                            if traceEnt != nil && traceEnt!.takedamage {
                                //damage it
                                G_SoundAtLoc(trace.endpos, CHAN_AUTO, G_SoundIndex("sound/weapons/galak/laserdamage.wav"))
                                G_Damage(traceEnt!, NPC, NPC, &NPC!.client!.renderInfo.muzzleDir, trace.endpos, 10, 0, MOD_UNKNOWN)
                            }
                        }
                        if NPCInfo!.coverTarg != nil {
                            G_SetOrigin(NPCInfo!.coverTarg!, &trace.endpos)
                        }
                        if Q_irand(0, 5) == 0 {
                            G_SoundAtLoc(trace.endpos, CHAN_AUTO, G_SoundIndex("sound/weapons/galak/laserdamage.wav"))
                        }
                    }
                }
            }
        }
    } else {
        //Okay, we're not in a special attack, see if we should switch weapons or start a special attack
        /*
        if ( NPC->s.weapon == WP_REPEATER
        && !(NPCInfo->scriptFlags & SCF_ALT_FIRE)//using rapid-fire
        && NPC->enemy->s.weapon == WP_SABER //enemy using saber
        && NPC->client && (NPC->client->ps.saberEventFlags&SEF_DEFLECTED)
        && !Q_irand( 0, 50 ) )
        {//he's deflecting my shots, switch to the laser or the lob fire for a while
        TIMER_Set( NPC, "noRapid", Q_irand( 2000, 6000 ) );
        NPCInfo->scriptFlags |= SCF_ALT_FIRE;
        NPC->alt_fire = qtrue;
        if ( NPC->locationDamage[HL_GENERIC1] > GENERATOR_HEALTH && (Q_irand( 0, 1 )||enemyDist4 < MAX_LOB_DIST_SQUARED) )
        {//shield down, use laser
        NPC_GM_StartLaser();
        }
        }
        else*/
        if 1 != 0 && enemyDist4 < MELEE_DIST_SQUARED && InFront(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 0.3) && NPC!.enemy!.localAnimIndex <= 1 {
            //our shield is down, and enemy within 80, if very close, use melee attack to slap away
            if TIMER_Done(NPC!, "attackDelay") {
                //animate me
                let swingAnim: Int32 = BOTH_ATTACK1
                //FIXME: swing sound
                NPC_SetAnim(NPC!, SETANIM_BOTH, swingAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                TIMER_Set(NPC!, "attackDelay", NPC!.client!.ps.torsoTimer + Q_irand(1000, 3000))
                //delay the hurt until the proper point in the anim
                TIMER_Set(NPC!, "smackTime", 600)
                NPCInfo!.blockedDebounceTime = 0
                //FIXME: say something?
            }
        } else if NPC!.lockCount == 0 && NPC!.locationDamage[HL_GENERIC1] > GENERATOR_HEALTH && TIMER_Done(NPC!, "attackDelay") && InFront(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 0.3) && ((Q_irand(0, 10 * (2 - g_spskill.integer)) == 0 && enemyDist4 > MIN_LOB_DIST_SQUARED && enemyDist4 < MAX_LOB_DIST_SQUARED) || (!TIMER_Done(NPC!, "noLob") && !TIMER_Done(NPC!, "noRapid"))) && NPC!.enemy!.s.weapon != WP_TURRET {
            //sometimes use the laser beam attack, but only after he's taken down our generator
            shoot4 = false
            NPC_GM_StartLaser()
        } else if enemyDist4 < MIN_LOB_DIST_SQUARED && (NPC!.enemy!.s.weapon != WP_TURRET || Q_stricmp("PAS", NPC!.enemy!.classname!) != 0) && TIMER_Done(NPC!, "noRapid") {
            //enemy within 256
            if (NPC!.client!.ps.weapon == WP_REPEATER) && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                //shooting an explosive, but enemy too close, switch to primary fire
                NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
                NPC!.alt_fire = false
                //FIXME: use weap raise & lower anims
                NPC_ChangeWeapon(WP_REPEATER)
            }
        } else if (enemyDist4 > MAX_LOB_DIST_SQUARED || (NPC!.enemy!.s.weapon == WP_TURRET && Q_stricmp("PAS", NPC!.enemy!.classname!) == 0)) && TIMER_Done(NPC!, "noLob") {
            //enemy more than 448 away and we are ready to try lob fire again
            if (NPC!.client!.ps.weapon == WP_REPEATER) && !((NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0) {
                //enemy far enough away to use lobby explosives
                NPCInfo!.scriptFlags |= SCF_ALT_FIRE
                NPC!.alt_fire = true
                //FIXME: use weap raise & lower anims
                NPC_ChangeWeapon(WP_REPEATER)
            }
        }
    }

    //can we see our target?
    if NPC_ClearLOS4(NPC!.enemy!) {
        NPCInfo!.enemyLastSeenTime = level.time //used here for aim debouncing, not always a clear LOS
        enemyLOS4 = true

        if NPC!.client!.ps.weapon == WP_NONE {
            enemyCS4 = false //not true, but should stop us from firing
            NPC_AimAdjust(-1) //adjust aim worse longer we have no weapon
        } else {
            //can we shoot our target?
            if ((NPC!.client!.ps.weapon == WP_REPEATER && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0)) && enemyDist4 < MIN_LOB_DIST_SQUARED {
                enemyCS4 = false //not true, but should stop us from firing
                hitAlly4 = true //us!
                //FIXME: if too close, run away!
            } else {
                var hit: Int32 = NPC_ShotEntity(NPC!.enemy!, &impactPos4)
                var hitEnt: Entity? = g_entities[hit]
                if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.enemyTeam) || (hitEnt != nil && hitEnt!.takedamage) {
                    //can hit enemy or will hit glass or other breakable, so shoot anyway
                    enemyCS4 = true
                    NPC_AimAdjust(2) //adjust aim better longer we have clear shot at enemy
                    NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
                } else {
                    //Hmm, have to get around this bastard
                    NPC_AimAdjust(1) //adjust aim better longer we can see enemy
                    if hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.playerTeam {
                        //would hit an ally, don't fire!!!
                        hitAlly4 = true
                    } else {
                        //Check and see where our shot *would* hit... if it's not close to the enemy (within 256?), then don't fire
                    }
                }
            }
        }
    } else if trap_InPVS(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) {
        var hit: Int32 = 0
        var hitEnt: Entity?

        if TIMER_Done(NPC!, "talkDebounce") && Q_irand(0, 10) == 0 {
            if NPCInfo!.enemyCheckDebounceTime < 8 {
                var speech: Int32 = -1
                switch NPCInfo!.enemyCheckDebounceTime {
                case 0, 1, 2:
                    speech = EV_CHASE1 + NPCInfo!.enemyCheckDebounceTime

                case 3, 4, 5:
                    speech = EV_COVER1 + NPCInfo!.enemyCheckDebounceTime - 3

                case 6, 7:
                    speech = EV_ESCAPING1 + NPCInfo!.enemyCheckDebounceTime - 6

                default:
                    break
                }
                NPCInfo!.enemyCheckDebounceTime += 1
                if speech != -1 {
                    G_AddVoiceEvent(NPC!, speech, Q_irand(3000, 5000))
                    TIMER_Set(NPC!, "talkDebounce", Q_irand(5000, 7000))
                }
            }
        }

        NPCInfo!.enemyLastSeenTime = level.time

        hit = NPC_ShotEntity(NPC!.enemy!, &impactPos4)
        hitEnt = g_entities[hit]
        if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.enemyTeam) || (hitEnt != nil && hitEnt!.takedamage) {
            //can hit enemy or will hit glass or other breakable, so shoot anyway
            enemyCS4 = true
        } else {
            faceEnemy4 = true
            NPC_AimAdjust(-1) //adjust aim worse longer we cannot see enemy
        }
    }

    if enemyLOS4 {
        faceEnemy4 = true
    } else {
        if NPCInfo!.goalEntity == nil {
            NPCInfo!.goalEntity = NPC!.enemy
        }
        if NPCInfo!.goalEntity == NPC!.enemy {
            //for now, always chase the enemy
            move4 = true
        }
    }
    if enemyCS4 {
        shoot4 = true
        //NPCInfo->enemyCheckDebounceTime = level.time;//actually used here as a last actual LOS
    } else {
        if NPCInfo!.goalEntity == nil {
            NPCInfo!.goalEntity = NPC!.enemy
        }
        if NPCInfo!.goalEntity == NPC!.enemy {
            //for now, always chase the enemy
            move4 = true
        }
    }

    //Check for movement to take care of
    GM_CheckMoveState()

    //See if we should override shooting decision with any special considerations
    GM_CheckFireState()

    if NPC!.client!.ps.weapon == WP_REPEATER && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 && shoot4 && TIMER_Done(NPC!, "attackDelay") {
        var muzzle = vec3_t()
        var angles = vec3_t()
        var target = vec3_t()
        var velocity = vec3_t(0, 0, 0)
        var mins = vec3_t(Float(-REPEATER_ALT_SIZE), Float(-REPEATER_ALT_SIZE), Float(-REPEATER_ALT_SIZE))
        var maxs = vec3_t(Float(REPEATER_ALT_SIZE), Float(REPEATER_ALT_SIZE), Float(REPEATER_ALT_SIZE))
        var clearshot: Bool = false

        CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)

        target = NPC!.enemy!.r.currentOrigin

        target[0] += flrand(-5, 5) + (crandom() * (6 - NPCInfo!.currentAim) * 2)
        target[1] += flrand(-5, 5) + (crandom() * (6 - NPCInfo!.currentAim) * 2)
        target[2] += flrand(-5, 5) + (crandom() * (6 - NPCInfo!.currentAim) * 2)

        //Find the desired angles
        clearshot = WP_LobFire(NPC!, muzzle, target, mins, maxs, MASK_SHOT | CONTENTS_LIGHTSABER, &velocity, true, NPC!.s.number, NPC!.enemy!.s.number, 300, 1100, 1500, true)
        if VectorCompare(vec3_origin, velocity) != 0 || (!clearshot && enemyLOS4 && enemyCS4) {
            //no clear lob shot and no lob shot that will hit something breakable
            if enemyLOS4 && enemyCS4 && TIMER_Done(NPC!, "noRapid") {
                //have a clear straight shot, so switch to primary
                NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
                NPC!.alt_fire = false
                NPC_ChangeWeapon(WP_REPEATER)
                //keep this weap for a bit
                TIMER_Set(NPC!, "noLob", Q_irand(500, 1000))
            } else {
                shoot4 = false
            }
        } else {
            vectoangles(velocity, &angles)

            NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
            NPCInfo!.desiredPitch = AngleNormalize360(angles[PITCH])

            NPC!.client!.hiddenDir = velocity
            NPC!.client!.hiddenDist = VectorNormalize(&NPC!.client!.hiddenDir)
        }
    } else if faceEnemy4 {
        //face the enemy
        NPC_FaceEnemy(true)
    }

    if !TIMER_Done(NPC!, "standTime") {
        move4 = false
    }
    if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
        //not supposed to chase my enemies
        if NPCInfo!.goalEntity == NPC!.enemy {
            //goal is my entity, so don't move
            move4 = false
        }
    }

    if move4 && NPC!.lockCount == 0 {
        //move toward goal
        if NPCInfo!.goalEntity != nil {
            move4 = GM_Move()
        } else {
            move4 = false
        }
    }

    if !TIMER_Done(NPC!, "flee") {
        //running away
        faceEnemy4 = false
    }

    //FIXME: check scf_face_move_dir here?

    if !faceEnemy4 {
        //we want to face in the dir we're running
        if !move4 {
            //if we haven't moved, we should look in the direction we last looked?
            NPCInfo!.lastPathAngles = NPC!.client!.ps.viewangles
        }
        if move4 {
            //don't run away and shoot
            NPCInfo!.desiredYaw = NPCInfo!.lastPathAngles[YAW]
            NPCInfo!.desiredPitch = 0
            shoot4 = false
        }
    }
    NPC_UpdateAngles(true, true)

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        shoot4 = false
    }

    if NPC!.enemy != nil && NPC!.enemy!.enemy != nil {
        if NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.enemy!.s.weapon == WP_SABER {
            //don't shoot at an enemy jedi who is fighting another jedi, for fear of injuring one or causing rogue blaster deflections (a la Obi Wan/Vader duel at end of ANH)
            shoot4 = false
        }
    }
    //FIXME: don't shoot right away!
    if shoot4 {
        //try to shoot if it's time
        if TIMER_Done(NPC!, "attackDelay") {
            if !((NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0) {
                WeaponThink(true)
            }
        }
    }

    //also:
    if NPC!.enemy!.s.weapon == WP_TURRET && Q_stricmp("PAS", NPC!.enemy!.classname!) == 0 {
        //crush turrets
        if G_BoundsOverlap(NPC!.r.absmin, NPC!.r.absmax, NPC!.enemy!.r.absmin, NPC!.enemy!.r.absmax) {
            //have to do this test because placed turrets are not solid to NPCs (so they don't obstruct navigation)
            //if ( NPC->client->ps.powerups[PW_GALAK_SHIELD] > 0 )
            if 0 != 0 {
                NPC!.client!.ps.powerups[PW_BATTLESUIT] = level.time + ARMOR_EFFECT_TIME
                var dir: vec3_t? = nil
                G_Damage(NPC!.enemy!, NPC, NPC, &dir, NPC!.r.currentOrigin, 100, DAMAGE_NO_KNOCKBACK, MOD_UNKNOWN)
            } else {
                var dir: vec3_t? = nil
                G_Damage(NPC!.enemy!, NPC, NPC, &dir, NPC!.r.currentOrigin, 100, DAMAGE_NO_KNOCKBACK, MOD_CRUSH)
            }
        }
    } else if NPCInfo!.touchedByPlayer != nil && NPCInfo!.touchedByPlayer == NPC!.enemy {
        //touched enemy
        //if ( NPC->client->ps.powerups[PW_GALAK_SHIELD] > 0 )
        if 0 != 0 {
            //zap him!
            var smackDir = vec3_t()

            //animate me
            TIMER_Set(NPC!, "attackDelay", NPC!.client!.ps.torsoTimer)
            TIMER_Set(NPC!, "standTime", NPC!.client!.ps.legsTimer)
            //FIXME: debounce this?
            NPCInfo!.touchedByPlayer = nil
            //FIXME: some shield effect?
            NPC!.client!.ps.powerups[PW_BATTLESUIT] = level.time + ARMOR_EFFECT_TIME

            smackDir = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
            smackDir[2] += 30
            VectorNormalize(&smackDir)
            G_Damage(NPC!.enemy!, NPC, NPC, &smackDir, NPC!.r.currentOrigin, (g_spskill.integer + 1) * Q_irand(5, 10), DAMAGE_NO_KNOCKBACK, MOD_UNKNOWN)
            //throw them
            G_Throw(NPC!.enemy!, smackDir, 100)
            //NPC->enemy->s.powerups |= ( 1 << PW_SHOCKED );
            if NPC!.enemy!.client != nil {
                //	NPC->enemy->client->ps.powerups[PW_SHOCKED] = level.time + 1000;
                NPC!.enemy!.client!.ps.electrifyTime = level.time + 1000
            }
            //stop any attacks
            ucmd.buttons = 0
        }
    }

    if NPCInfo!.movementSpeech < 3 && NPCInfo!.blockedSpeechDebounceTime <= level.time {
        if NPC!.enemy != nil && NPC!.enemy!.health > 0 && NPC!.enemy!.painDebounceTime > level.time {
            if NPC!.enemy!.health < 50 && NPCInfo!.movementSpeech == 2 {
                G_AddVoiceEvent(NPC!, EV_ANGER2, Q_irand(2000, 4000))
                NPCInfo!.movementSpeech = 3
            } else if NPC!.enemy!.health < 75 && NPCInfo!.movementSpeech == 1 {
                G_AddVoiceEvent(NPC!, EV_ANGER1, Q_irand(2000, 4000))
                NPCInfo!.movementSpeech = 2
            } else if NPC!.enemy!.health < 100 && NPCInfo!.movementSpeech == 0 {
                G_AddVoiceEvent(NPC!, EV_ANGER3, Q_irand(2000, 4000))
                NPCInfo!.movementSpeech = 1
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_GalakMech.c:1231
func NPC_BSGM_Default() {
    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    if NPC!.client!.ps.stats[STAT_ARMOR] <= 0 {
        //armor gone
        //	if ( !NPCInfo->investigateDebounceTime )
        if 0 != 0 {
            //start regenerating the armor
            NPC_SetSurfaceOnOff(NPC!, "torso_shield", TURN_OFF)
            NPC!.flags &= ~FL_SHIELDED //no more reflections
            NPC!.r.mins = vec3_t(-20, -20, -24)
            NPC!.r.maxs = vec3_t(20, 20, 64)
            NPC!.client!.ps.standheight = 64
            NPC!.client!.ps.crouchheight = NPC!.client!.ps.standheight
            if NPC!.locationDamage[HL_GENERIC1] < GENERATOR_HEALTH {
                //still have the generator bolt-on
                if NPCInfo!.investigateCount < 12 {
                    NPCInfo!.investigateCount += 1
                }
                NPCInfo!.investigateDebounceTime = level.time + (NPCInfo!.investigateCount * 5000)
            }
        } else if NPCInfo!.investigateDebounceTime < level.time {
            //armor regenerated, turn shield back on
            //do a trace and make sure we can turn this back on?
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in
                trap_Trace(tr, NPC!.r.currentOrigin, shieldMins, shieldMaxs, NPC!.r.currentOrigin, NPC!.s.number, NPC!.clipmask)
                if tr.startsolid == 0 {
                    NPC!.r.mins = shieldMins
                    NPC!.r.maxs = shieldMaxs
                    NPC!.client!.ps.standheight = Int32(shieldMaxs[2])
                    NPC!.client!.ps.crouchheight = NPC!.client!.ps.standheight
                    NPC!.client!.ps.stats[STAT_ARMOR] = GALAK_SHIELD_HEALTH
                    NPCInfo!.investigateDebounceTime = 0
                    NPC!.flags |= FL_SHIELDED //reflect normal shots
                    //	NPC->fx_time = level.time;
                    NPC_SetSurfaceOnOff(NPC!, "torso_shield", TURN_ON)
                }
            }
        }
    }
    /*
    if ( NPC->client->ps.stats[STAT_ARMOR] > 0 )
    {//armor present
    NPC->client->ps.powerups[PW_GALAK_SHIELD] = Q3_INFINITE;//temp, for effect
    NPC_SetSurfaceOnOff( NPC, "torso_shield", TURN_ON );
    }
    else
    {
    NPC_SetSurfaceOnOff( NPC, "torso_shield", TURN_OFF );
    }
    */
    //rwwFIXMEFIXME: Allow this stuff, and again, going to have to let the client know about it.
    //Maybe a surface-off bitflag of some sort in the entity state?

    if NPC!.enemy == nil {
        //don't have an enemy, look for one
        NPC_BSGM_Patrol()
    } else {
        //have an enemy
        NPC_BSGM_Attack()
    }
}
