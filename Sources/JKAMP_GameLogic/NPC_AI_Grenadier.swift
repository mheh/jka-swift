import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:42
private let LSTATE_NONE: Int32 = 0
private let LSTATE_UNDERFIRE: Int32 = 1
private let LSTATE_INVESTIGATE: Int32 = 2

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:18
private let MAX_VIEW_DIST = 1024 as Int32

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:19
private let MAX_VIEW_SPEED = 250 as Int32

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:20
private let MAX_LIGHT_INTENSITY = 255 as Int32

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:21
private let MIN_LIGHT_THRESHOLD = 0.1 as Double

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:23
private let DISTANCE_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:24
private let DISTANCE_THRESHOLD = 0.075 as Float

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:25
private let SPEED_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:26
private let FOV_SCALE = 0.5 as Float

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:27
private let LIGHT_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:29
private let REALIZE_THRESHOLD = 0.6 as Float

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:30
private let CAUTIOUS_THRESHOLD = (REALIZE_THRESHOLD * 0.75)

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:34
var enemyLOS3: Bool {
    get { world.variables.enemyLOS3 }
    set { world.variables.enemyLOS3 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:35
var enemyCS3: Bool {
    get { world.variables.enemyCS3 }
    set { world.variables.enemyCS3 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:36
var faceEnemy3: Bool {
    get { world.variables.faceEnemy3 }
    set { world.variables.faceEnemy3 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:37
var move3: Bool {
    get { world.variables.move3 }
    set { world.variables.move3 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:38
var shoot3: Bool {
    get { world.variables.shoot3 }
    set { world.variables.shoot3 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:39
var enemyDist3: Float {
    get { world.variables.enemyDist3 }
    set { world.variables.enemyDist3 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:49
func Grenadier_ClearTimers(_ ent: Entity) {
    TIMER_Set(ent, "chatter", 0)
    TIMER_Set(ent, "duck", 0)
    TIMER_Set(ent, "stand", 0)
    TIMER_Set(ent, "shuffleTime", 0)
    TIMER_Set(ent, "sleepTime", 0)
    TIMER_Set(ent, "enemyLastVisible", 0)
    TIMER_Set(ent, "roamTime", 0)
    TIMER_Set(ent, "hideTime", 0)
    TIMER_Set(ent, "attackDelay", 0) //FIXME: Slant for difficulty levels
    TIMER_Set(ent, "stick", 0)
    TIMER_Set(ent, "scoutTime", 0)
    TIMER_Set(ent, "flee", 0)
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:65
func NPC_Grenadier_PlayConfusionSound(_ `self`: Entity) {
    //FIXME: make this a custom sound in sound set
    if `self`.health > 0 {
        G_AddVoiceEvent(`self`, Q_irand(EV_CONFUSE1, EV_CONFUSE3), 2000)
    }
    //reset him to be totally unaware again
    TIMER_Set(`self`, "enemyLastVisible", 0)
    TIMER_Set(`self`, "flee", 0)
    `self`.NPC!.squadState = SQUAD_IDLE
    `self`.NPC!.tempBehavior = BS_DEFAULT

    //self->NPC->behaviorState = BS_PATROL;
    G_ClearEnemy(`self`) //FIXME: or just self->enemy = NULL;?

    `self`.NPC!.investigateCount = 0
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:90
func NPC_Grenadier_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    `self`.NPC!.localState = LSTATE_UNDERFIRE

    TIMER_Set(`self`, "duck", -1)
    TIMER_Set(`self`, "stand", 2000)

    NPC_Pain(`self`, attacker, damage)

    if damage == 0 && `self`.health > 0 {
        //FIXME: better way to know I was pushed
        G_AddVoiceEvent(`self`, Q_irand(EV_PUSHED1, EV_PUSHED3), 2000)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:111
private func Grenadier_HoldPosition() {
    NPC_FreeCombatPoint(NPCInfo!.combatPoint, true)
    NPCInfo!.goalEntity = nil

    /*if ( TIMER_Done( NPC, "stand" ) )
    {//FIXME: what if can't shoot from this pos?
    TIMER_Set( NPC, "duck", Q_irand( 2000, 4000 ) );
    }
    */
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:129
private func Grenadier_Move() -> Bool {
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
                Grenadier_HoldPosition()
            }
        }

        //If our move failed, then reset
        if moved == false {
            //couldn't get to enemy
            if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 && NPC!.client!.ps.weapon == WP_THERMAL && NPCInfo!.goalEntity != nil && NPCInfo!.goalEntity == NPC!.enemy {
                //we were running after enemy
                //Try to find a combat point that can hit the enemy
                var cpFlags: Int32 = (CP_CLEAR | CP_HAS_ROUTE)
                var cp: Int32 = 0

                if (NPCInfo!.scriptFlags & SCF_USE_CP_NEAREST) != 0 {
                    cpFlags &= ~(CP_FLANK | CP_APPROACH_ENEMY | CP_CLOSEST)
                    cpFlags |= CP_NEAREST
                }
                cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.r.currentOrigin, cpFlags, 32, -1)
                if cp == -1 && !((NPCInfo!.scriptFlags & SCF_USE_CP_NEAREST) != 0) {
                    //okay, try one by the enemy
                    cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin, CP_CLEAR | CP_HAS_ROUTE | CP_HORZ_DIST_COLL, 32, -1)
                }
                //NOTE: there may be a perfectly valid one, just not one within CP_COLLECT_RADIUS of either me or him...
                if cp != -1 {
                    //found a combat point that has a clear shot to enemy
                    NPC_SetCombatPoint(cp)
                    NPC_SetMoveGoal(NPC!, level.combatPoints[cp].origin, 8, true, cp, nil)
                    return moved
                }
            }
            //just hang here
            Grenadier_HoldPosition()
        }

        return moved
    }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:190
func NPC_BSGrenadier_Patrol() {
    //FIXME: pick up on bodies of dead buddies?
    if NPCInfo!.confusionTime < level.time {
        //Look for any enemies
        if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            if NPC_CheckPlayerTeamStealth() {
                //NPCInfo->behaviorState = BS_HUNT_AND_KILL;//should be automatic now
                //NPC_AngerSound();
                NPC_UpdateAngles(true, true)
                return
            }
        }

        if !((NPCInfo!.scriptFlags & SCF_IGNORE_ALERTS) != 0) {
            //Is there danger nearby
            let alertEvent: Int32 = NPC_CheckAlertEvents(true, true, -1, false, AEL_SUSPICIOUS)
            if NPC_CheckForDanger(alertEvent) {
                NPC_UpdateAngles(true, true)
                return
            } else {
                //check for other alert events
                //There is an event to look at
                if alertEvent >= 0 && level.alertEvents[alertEvent].ID != NPCInfo!.lastAlertID {
                    NPCInfo!.lastAlertID = level.alertEvents[alertEvent].ID
                    if level.alertEvents[alertEvent].level == AEL_DISCOVERED {
                        if level.alertEvents[alertEvent].owner != nil && level.alertEvents[alertEvent].owner!.client != nil && level.alertEvents[alertEvent].owner!.health >= 0 && level.alertEvents[alertEvent].owner!.client!.playerTeam == NPC!.client!.enemyTeam {
                            //an enemy
                            G_SetEnemy(NPC!, level.alertEvents[alertEvent].owner!)
                            //NPCInfo->enemyLastSeenTime = level.time;
                            TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
                        }
                    } else {
                        //FIXME: get more suspicious over time?
                        //Save the position for movement (if necessary)
                        NPCInfo!.investigateGoal = level.alertEvents[alertEvent].position
                        NPCInfo!.investigateDebounceTime = level.time + Q_irand(500, 1000)
                        if level.alertEvents[alertEvent].level == AEL_SUSPICIOUS {
                            //suspicious looks longer
                            NPCInfo!.investigateDebounceTime += Q_irand(500, 2500)
                        }
                    }
                }
            }

            if NPCInfo!.investigateDebounceTime > level.time {
                //FIXME: walk over to it, maybe?  Not if not chase enemies
                //NOTE: stops walking or doing anything else below
                var dir = vec3_t()
                var angles = vec3_t()
                let o_yaw: Float
                let o_pitch: Float

                dir = NPCInfo!.investigateGoal - NPC!.client!.renderInfo.eyePoint
                vectoangles(dir, &angles)

                o_yaw = NPCInfo!.desiredYaw
                o_pitch = NPCInfo!.desiredPitch
                NPCInfo!.desiredYaw = angles[YAW]
                NPCInfo!.desiredPitch = angles[PITCH]

                NPC_UpdateAngles(true, true)

                NPCInfo!.desiredYaw = o_yaw
                NPCInfo!.desiredPitch = o_pitch
                return
            }
        }
    }

    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons |= BUTTON_WALKING
        NPC_MoveToGoal(true)
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:307
private func Grenadier_CheckMoveState() {
    //See if we're a scout
    if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
        if NPCInfo!.goalEntity == NPC!.enemy {
            move3 = false
            return
        }
    } else if NPCInfo!.squadState == SQUAD_RETREAT {
        //See if we're running away
        if TIMER_Done(NPC!, "flee") {
            NPCInfo!.squadState = SQUAD_IDLE
        } else {
            faceEnemy3 = false
        }
    }
    /*
    else if ( NPCInfo->squadState == SQUAD_IDLE )
    {
    if ( !NPCInfo->goalEntity )
    {
    move3 = qfalse;
    return;
    }
    //Should keep moving toward player when we're out of range... right?
    }
    */

    //See if we're moving towards a goal, not the enemy
    if (NPCInfo!.goalEntity != NPC!.enemy) && (NPCInfo!.goalEntity != nil) {
        //Did we make it?
        if NAV_HitNavGoal(NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPCInfo!.goalEntity!.r.currentOrigin, 16, FlyingCreature(NPC!)) || (NPCInfo!.squadState == SQUAD_SCOUT && enemyLOS3 && enemyDist3 <= 10000) {
            var newSquadState: Int32 = SQUAD_STAND_AND_SHOOT
            //we got where we wanted to go, set timers based on why we were running
            switch NPCInfo!.squadState {
            case SQUAD_RETREAT: //was running away
                TIMER_Set(NPC!, "duck", (NPC!.client!.pers.maxHealth - NPC!.health) * 100)
                TIMER_Set(NPC!, "hideTime", Q_irand(3000, 7000))
                newSquadState = SQUAD_COVER

            case SQUAD_TRANSITION: //was heading for a combat point
                TIMER_Set(NPC!, "hideTime", Q_irand(2000, 4000))

            case SQUAD_SCOUT: //was running after player
                break

            default:
                break
            }
            NPC_ReachedGoal()
            //don't attack right away
            TIMER_Set(NPC!, "attackDelay", Q_irand(250, 500)) //FIXME: Slant for difficulty levels
            //don't do something else just yet
            TIMER_Set(NPC!, "roamTime", Q_irand(1000, 4000))
            //stop fleeing
            if NPCInfo!.squadState == SQUAD_RETREAT {
                TIMER_Set(NPC!, "flee", -level.time)
                NPCInfo!.squadState = SQUAD_IDLE
            }
            return
        }

        //keep going, hold of roamTimer until we get there
        TIMER_Set(NPC!, "roamTime", Q_irand(4000, 8000))
    }

    if NPCInfo!.goalEntity == nil {
        if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
            NPCInfo!.goalEntity = NPC!.enemy
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:399
private func Grenadier_CheckFireState() {
    if enemyCS3 {
        //if have a clear shot, always try
        return
    }

    if NPCInfo!.squadState == SQUAD_RETREAT || NPCInfo!.squadState == SQUAD_TRANSITION || NPCInfo!.squadState == SQUAD_SCOUT {
        //runners never try to fire at the last pos
        return
    }

    if VectorCompare(NPC!.client!.ps.velocity, vec3_origin) == 0 {
        //if moving at all, don't do this
        return
    }

    //continue to fire on their last position
    /*
    if ( !Q_irand( 0, 1 ) && NPCInfo->enemyLastSeenTime && level.time - NPCInfo->enemyLastSeenTime < 4000 )
    {
    //Fire on the last known position
    vec3_t	muzzle, dir, angles;

    CalcEntitySpot( NPC, SPOT_WEAPON, muzzle );
    VectorSubtract( NPCInfo->enemyLastSeenLocation, muzzle, dir );

    VectorNormalize( dir );

    vectoangles( dir, angles );

    NPCInfo->desiredYaw		= angles[YAW];
    NPCInfo->desiredPitch	= angles[PITCH];
    //FIXME: they always throw toward enemy, so this will be very odd...
    shoot3 = qtrue;
    faceEnemy3 = qfalse;

    return;
    }
    */
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:441
func Grenadier_EvaluateShot(_ hit: Int32) -> Bool {
    if NPC!.enemy == nil {
        return false
    }

    if hit == NPC!.enemy!.s.number || (g_entities[hit] != nil && (g_entities[hit].r.svFlags & SVF_GLASS_BRUSH) != 0) {
        //can hit enemy or will hit glass, so shoot anyway
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:461
func NPC_BSGrenadier_Attack() {
    //Don't do anything if we're hurt
    if NPC!.painDebounceTime > level.time {
        NPC_UpdateAngles(true, true)
        return
    }

    //NPC_CheckEnemy( qtrue, qfalse );
    //If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        NPC!.enemy = nil
        NPC_BSGrenadier_Patrol() //FIXME: or patrol?
        return
    }

    if TIMER_Done(NPC!, "flee") && NPC_CheckForDanger(NPC_CheckAlertEvents(true, true, -1, false, AEL_DANGER)) {
        //going to run
        NPC_UpdateAngles(true, true)
        return
    }

    if NPC!.enemy == nil {
        //WTF?  somehow we lost our enemy?
        NPC_BSGrenadier_Patrol() //FIXME: or patrol?
        return
    }

    enemyCS3 = false
    enemyLOS3 = enemyCS3
    move3 = true
    faceEnemy3 = false
    shoot3 = false
    enemyDist3 = DistanceSquared(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin)

    //See if we should switch to melee attack
    if enemyDist3 < 16384 && (NPC!.enemy!.client == nil || NPC!.enemy!.client!.ps.weapon != WP_SABER || BG_SabersOff(NPC!.enemy!.client!.ps)) {
        //enemy is close and not using saber
        if NPC!.client!.ps.weapon == WP_THERMAL {
            //grenadier
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { trace in
                trap_Trace(trace, NPC!.r.currentOrigin, NPC!.enemy!.r.mins, NPC!.enemy!.r.maxs, NPC!.enemy!.r.currentOrigin, NPC!.s.number, NPC!.enemy!.clipmask)
                if trace.allsolid == 0 && trace.startsolid == 0 && (Double(trace.fraction) == 1.0 || trace.entityNum == NPC!.enemy!.s.number) {
                    //I can get right to him
                    //reset fire-timing variables
                    NPC_ChangeWeapon(WP_STUN_BATON)
                    if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
                        //FIXME: should we be overriding scriptFlags?
                        NPCInfo!.scriptFlags |= SCF_CHASE_ENEMIES //NPCInfo->behaviorState = BS_HUNT_AND_KILL;
                    }
                }
            }
        }
    } else if enemyDist3 > 65536 || (NPC!.enemy!.client != nil && NPC!.enemy!.client!.ps.weapon == WP_SABER && NPC!.enemy!.client!.ps.saberHolstered == 0) {
        //enemy is far or using saber
        if NPC!.client!.ps.weapon == WP_STUN_BATON && (NPC!.client!.ps.stats[STAT_WEAPONS] & (1 << WP_THERMAL)) != 0 {
            //fisticuffs, make switch to thermal if have it
            //reset fire-timing variables
            NPC_ChangeWeapon(WP_THERMAL)
        }
    }

    //can we see our target?
    if NPC_ClearLOS4(NPC!.enemy!) {
        NPCInfo!.enemyLastSeenTime = level.time
        enemyLOS3 = true

        if NPC!.client!.ps.weapon == WP_STUN_BATON {
            if enemyDist3 <= 4096 && InFOV3(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 90, 45) {
                NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
                enemyCS3 = true
            }
        } else if InFOV3(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 45, 90) {
            //in front of me
            //can we shoot our target?
            //FIXME: how accurate/necessary is this check?
            // Raven passes NULL for the `impactPos` output.
            var scratchImpactPos = vec3_t()
            let hit: Int32 = NPC_ShotEntity(NPC!.enemy!, &scratchImpactPos)
            let hitEnt: Entity? = g_entities[hit]
            if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.enemyTeam) {
                var enemyHorzDist: Float = 0

                NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
                enemyHorzDist = DistanceHorizontalSquared(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin)
                if enemyHorzDist < 1048576 {
                    //within 1024
                    enemyCS3 = true
                    NPC_AimAdjust(2) //adjust aim better longer we have clear shot at enemy
                } else {
                    NPC_AimAdjust(1) //adjust aim better longer we can see enemy
                }
            }
        }
    } else {
        NPC_AimAdjust(-1) //adjust aim worse longer we cannot see enemy
    }
    /*
    else if ( trap_InPVS( NPC->enemy->r.currentOrigin, NPC->r.currentOrigin ) )
    {
    NPCInfo->enemyLastSeenTime = level.time;
    faceEnemy3 = qtrue;
    }
    */

    if enemyLOS3 {
        //FIXME: no need to face enemy if we're moving to some other goal and he's too far away to shoot?
        faceEnemy3 = true
    }

    if enemyCS3 {
        shoot3 = true
        if NPC!.client!.ps.weapon == WP_THERMAL {
            //don't chase and throw
            move3 = false
        } else if NPC!.client!.ps.weapon == WP_STUN_BATON && enemyDist3 < (NPC!.r.maxs[0] + NPC!.enemy!.r.maxs[0] + 16) * (NPC!.r.maxs[0] + NPC!.enemy!.r.maxs[0] + 16) {
            //close enough
            move3 = false
        }
    }

    //Check for movement to take care of
    Grenadier_CheckMoveState()

    //See if we should override shooting decision with any special considerations
    Grenadier_CheckFireState()

    if move3 {
        //move toward goal
        if NPCInfo!.goalEntity != nil {
            move3 = Grenadier_Move()
        } else {
            move3 = false
        }
    }

    if !move3 {
        if !TIMER_Done(NPC!, "duck") {
            ucmd.upmove = -127
        }
        //FIXME: what about leaning?
    } else {
        //stop ducking!
        TIMER_Set(NPC!, "duck", -1)
    }

    if !faceEnemy3 {
        //we want to face in the dir we're running
        if move3 {
            //don't run away and shoot
            NPCInfo!.desiredYaw = NPCInfo!.lastPathAngles[YAW]
            NPCInfo!.desiredPitch = 0
            shoot3 = false
        }
        NPC_UpdateAngles(true, true)
    } else {
        //face the enemy
        NPC_FaceEnemy(true)
    }

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        shoot3 = false
    }

    //FIXME: don't shoot right away!
    if shoot3 {
        //try to shoot if it's time
        if TIMER_Done(NPC!, "attackDelay") {
            if !((NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0) {
                WeaponThink(true)
                TIMER_Set(NPC!, "attackDelay", NPCInfo!.shotTime - level.time)
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Grenadier.c:664
func NPC_BSGrenadier_Default() {
    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    if NPC!.enemy == nil {
        //don't have an enemy, look for one
        NPC_BSGrenadier_Patrol()
    } else {
        //have an enemy
        NPC_BSGrenadier_Attack()
    }
}
