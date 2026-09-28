import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Default.c:18
func NPC_LostEnemyDecideChase() {
    switch NPCInfo!.behaviorState {
    case BS_HUNT_AND_KILL:
        //We were chasing him and lost him, so try to find him
        if NPC!.enemy == NPCInfo!.goalEntity && NPC!.enemy!.lastWaypoint != WAYPOINT_NONE {
            //Remember his last valid Wp, then check it out
            //FIXME: Should we only do this if there's no other enemies or we've got LOCKED_ENEMY on?
            NPC_BSSearchStart(NPC!.enemy!.lastWaypoint, BS_SEARCH)
        }

    default:
        break
    }
    G_ClearEnemy(NPC!)
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:42
func NPC_StandIdle() {
    /*
    //Must be done with any other animations
    if ( NPC->client->ps.legsAnimTimer != 0 )
    return;

    //Not ready to do another one
    if ( TIMER_Done( NPC, "idleAnim" ) == false )
    return;

    int anim = NPC->client->ps.legsAnim;

    if ( anim != BOTH_STAND1 && anim != BOTH_STAND2 )
    return;

    //FIXME: Account for STAND1 or STAND2 here and set the base anim accordingly
    int	baseSeq = ( anim == BOTH_STAND1 ) ? BOTH_STAND1_RANDOM1 : BOTH_STAND2_RANDOM1;

    //Must have at least one random idle animation
    //NOTENOTE: This relies on proper ordering of animations, which SHOULD be okay
    if ( PM_HasAnimation( NPC, baseSeq ) == false )
    return;

    int	newIdle = Q_irand( 0, MAX_IDLE_ANIMS-1 );

    //FIXME: Technically this could never complete.. but that's not really too likely
    while( 1 )
    {
    if ( PM_HasAnimation( NPC, baseSeq + newIdle ) )
    break;

    newIdle = Q_irand( 0, MAX_IDLE_ANIMS );
    }

    //Start that animation going
    NPC_SetAnim( NPC, SETANIM_BOTH, baseSeq + newIdle, SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD );

    int newTime = PM_AnimLength( NPC->client->clientInfo.animFileIndex, (animNumber_t) (baseSeq + newIdle) );

    //Don't do this again for a random amount of time
    TIMER_Set( NPC, "idleAnim", newTime + Q_irand( 2000, 10000 ) );
    */
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:87
func NPC_StandTrackAndShoot(_ NPC: Entity, _ canDuck: Bool) -> Bool {
    var attack_ok: Bool = false
    var duck_ok: Bool = false
    var faced: Bool = false
    let attack_scale: Float = 1.0

    //First see if we're hurt bad- if so, duck
    //FIXME: if even when ducked, we can shoot someone, we should.
    //Maybe is can be shot even when ducked, we should run away to the nearest cover?
    if canDuck {
        if NPC.health < 20 {
            //	if( NPC->svFlags&SVF_HEALING || random() )
            // The SDK also declares `random`, so the call names the bg module.
            if JKAMP_BG.random() != 0 {
                duck_ok = true
            }
        } else if NPC.health < 40 {
            //			if ( NPC->svFlags&SVF_HEALING )
            //			{//Medic is on the way, get down!
            //				duck_ok = qtrue;
            //			}
            // no more borg
            ///			if ( NPC->client->playerTeam!= TEAM_BORG )
            //			{//Borg don't care if they're about to die
            //attack_scale will be a max of .66
            //				attack_scale = NPC->health/60;
            //			}
        }
    }

    //NPC_CheckEnemy( qtrue, qfalse, qtrue );

    if !duck_ok {
        //made this whole part a function call
        attack_ok = NPC_CheckCanAttack(attack_scale, true)
        faced = true
    }

    if canDuck && (duck_ok || (!attack_ok && client!.ps.weaponTime <= 0)) && ucmd.upmove != -127 {
        //if we didn't attack check to duck if we're not already
        if !duck_ok {
            if NPC.enemy!.client != nil {
                if NPC.enemy!.enemy == NPC {
                    if (NPC.enemy!.client!.buttons & BUTTON_ATTACK) != 0 {
                        //FIXME: determine if enemy fire angles would hit me or get close
                        if NPC_CheckDefend(1.0) {
                            duck_ok = true
                        }
                    }
                }
            }
        }

        if duck_ok {
            //duck and don't shoot
            attack_ok = false
            ucmd.upmove = -127
            NPCInfo!.duckDebounceTime = level.time + 1000 //duck for a full second
        }
    }

    return faced
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:161
func NPC_BSIdle() {
    //FIXME if there is no nav data, we need to do something else
    // if we're stuck, try to move around it
    if UpdateGoal() != nil {
        NPC_MoveToGoal(true)
    }

    if (ucmd.forwardmove == 0) && (ucmd.rightmove == 0) && (ucmd.upmove == 0) {
        //		NPC_StandIdle();
    }

    NPC_UpdateAngles(true, true)
    ucmd.buttons |= BUTTON_WALKING
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:179
func NPC_BSRun() {
    //FIXME if there is no nav data, we need to do something else
    // if we're stuck, try to move around it
    if UpdateGoal() != nil {
        NPC_MoveToGoal(true)
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:191
func NPC_BSStandGuard() {
    //FIXME: Use Snapshot info
    if NPC!.enemy == nil {
        //Possible to pick one up by being shot
        // The SDK also declares `random`, so the call names the bg module.
        if JKAMP_BG.random() < 0.5 {
            if NPC!.client!.enemyTeam != 0 {
                let newenemy: Entity? = NPC_PickEnemy(NPC!, NPC!.client!.enemyTeam, (NPC!.cantHitEnemyCounter < 10), (NPC!.client!.enemyTeam == NPCTEAM_PLAYER), true)
                //only checks for vis if couldn't hit last enemy
                if newenemy != nil {
                    G_SetEnemy(NPC!, newenemy!)
                }
            }
        }
    }

    if NPC!.enemy != nil {
        if NPCInfo!.tempBehavior == BS_STAND_GUARD {
            NPCInfo!.tempBehavior = BS_DEFAULT
        }

        if NPCInfo!.behaviorState == BS_STAND_GUARD {
            NPCInfo!.behaviorState = BS_STAND_AND_SHOOT
        }
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:232
func NPC_BSHuntAndKill() {
    var turned: Bool = false
    var vec = vec3_t()
    let enemyDist: Float
    let oEVis: visibility_t
    let curAnim: Int32

    NPC_CheckEnemy(NPCInfo!.tempBehavior != BS_HUNT_AND_KILL, false, true) //don't find new enemy if this is tempbehav

    if NPC!.enemy != nil {
        enemyVisibility = NPC_CheckVisibility(NPC!.enemy!, CHECK_FOV | CHECK_SHOOT) //CHECK_360|//CHECK_PVS|
        oEVis = enemyVisibility //CHECK_360|//CHECK_PVS|
        if enemyVisibility > VIS_PVS {
            if !NPC_EnemyTooFar(NPC!.enemy!, 0, true) {
                //Enemy is close enough to shoot - FIXME: this next func does this also, but need to know here for info on whether ot not to turn later
                NPC_CheckCanAttack(1.0, false)
                turned = true
            }
        }

        curAnim = NPC!.client!.ps.legsAnim
        if curAnim != BOTH_ATTACK1 && curAnim != BOTH_ATTACK2 && curAnim != BOTH_ATTACK3 && curAnim != BOTH_MELEE1 && curAnim != BOTH_MELEE2 {
            //Don't move toward enemy if we're in a full-body attack anim
            //FIXME, use IdealDistance to determin if we need to close distance
            vec = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
            enemyDist = VectorLength(vec)
            if enemyDist > 48 && ((enemyDist * 1.5) * (enemyDist * 1.5) >= NPC_MaxDistSquaredForWeapon() || oEVis != VIS_SHOOT || enemyDist > IdealDistance(NPC!) * 3) {
                //We should close in?
                NPCInfo!.goalEntity = NPC!.enemy

                NPC_MoveToGoal(true)
            } else if enemyDist < IdealDistance(NPC!) {
                //We should back off?
                //if(ucmd.buttons & BUTTON_ATTACK)
                do {
                    NPCInfo!.goalEntity = NPC!.enemy
                    NPCInfo!.goalRadius = 12
                    NPC_MoveToGoal(true)

                    ucmd.forwardmove *= -1
                    ucmd.rightmove *= -1
                    NPC!.client!.ps.moveDir = NPC!.client!.ps.moveDir * -1

                    ucmd.buttons |= BUTTON_WALKING
                }
            }
        }
    } else {
        //ok, stand guard until we find an enemy
        if NPCInfo!.tempBehavior == BS_HUNT_AND_KILL {
            NPCInfo!.tempBehavior = BS_DEFAULT
        } else {
            NPCInfo!.tempBehavior = BS_STAND_GUARD
            NPC_BSStandGuard()
        }
        return
    }

    if !turned {
        NPC_UpdateAngles(true, true)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:306
func NPC_BSStandAndShoot() {
    //FIXME:
    //When our numbers outnumber enemies 3 to 1, or only one of them,
    //go into hunt and kill mode

    //FIXME:
    //When they're all dead, go to some script or wander off to sickbay?

    if NPC!.client!.playerTeam != 0 && NPC!.client!.enemyTeam != 0 {
        //FIXME: don't realize this right away- or else enemies show up and we're standing around
        /*
        if( teamNumbers[NPC->enemyTeam] == 0 )
        {//ok, stand guard until we find another enemy
        //reset our rush counter
        teamCounter[NPC->playerTeam] = 0;
        NPCInfo->tempBehavior = BS_STAND_GUARD;
        NPC_BSStandGuard();
        return;
        }*/
        /*
        //FIXME: whether to do this or not should be settable
        else if( NPC->playerTeam != TEAM_BORG )//Borg don't rush
        {
        //FIXME: In case reinforcements show up, we should wait a few seconds
        //and keep checking before rushing!
        //Also: what if not everyone on our team is going after playerTeam?
        //Also: our team count includes medics!
        if(NPC->health > 25)
        {//Can we rush the enemy?
        if(teamNumbers[NPC->enemyTeam] == 1 ||
        teamNumbers[NPC->playerTeam] >= teamNumbers[NPC->enemyTeam]*3)
        {//Only one of them or we outnumber 3 to 1
        if(teamStrength[NPC->playerTeam] >= 75 ||
        (teamStrength[NPC->playerTeam] >= 50 && teamStrength[NPC->playerTeam] > teamStrength[NPC->enemyTeam]))
        {//Our team is strong enough to rush
        teamCounter[NPC->playerTeam]++;
        if(teamNumbers[NPC->playerTeam] * 17 <= teamCounter[NPC->playerTeam])
        {//ok, we waited 1.7 think cycles on average and everyone is go, let's do it!
        //FIXME: Should we do this to everyone on our team?
        NPCInfo->behaviorState = BS_HUNT_AND_KILL;
        //FIXME: if the tide changes, we should retreat!
        //FIXME: when do we reset the counter?
        NPC_BSHuntAndKill ();
        return;
        }
        }
        else//Oops!  Something's wrong, reset the counter to rush
        teamCounter[NPC->playerTeam] = 0;
        }
        else//Oops!  Something's wrong, reset the counter to rush
        teamCounter[NPC->playerTeam] = 0;
        }
        }
        */
    }

    NPC_CheckEnemy(true, false, true)

    if NPCInfo!.duckDebounceTime > level.time && NPC!.client!.ps.weapon != WP_SABER {
        ucmd.upmove = -127
        if NPC!.enemy != nil {
            NPC_CheckCanAttack(1.0, true)
        }
        return
    }

    if NPC!.enemy != nil {
        if !NPC_StandTrackAndShoot(NPC!, true) {
            //That func didn't update our angles
            NPCInfo!.desiredYaw = NPC!.client!.ps.viewangles[YAW]
            NPCInfo!.desiredPitch = NPC!.client!.ps.viewangles[PITCH]
            NPC_UpdateAngles(true, true)
        }
    } else {
        NPCInfo!.desiredYaw = NPC!.client!.ps.viewangles[YAW]
        NPCInfo!.desiredPitch = NPC!.client!.ps.viewangles[PITCH]
        NPC_UpdateAngles(true, true)
        //		NPC_BSIdle();//only moves if we have a goal
    }
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:394
func NPC_BSRunAndShoot() {
    /*if(NPC->playerTeam && NPC->enemyTeam)
    {
    //FIXME: don't realize this right away- or else enemies show up and we're standing around
    if( teamNumbers[NPC->enemyTeam] == 0 )
    {//ok, stand guard until we find another enemy
    //reset our rush counter
    teamCounter[NPC->playerTeam] = 0;
    NPCInfo->tempBehavior = BS_STAND_GUARD;
    NPC_BSStandGuard();
    return;
    }
    }*/

    //NOTE: are we sure we want ALL run and shoot people to move this way?
    //Shouldn't it check to see if we have an enemy and our enemy is our goal?!
    //Moved that check into NPC_MoveToGoal
    //NPCInfo->combatMove = qtrue;

    NPC_CheckEnemy(true, false, true)

    if NPCInfo!.duckDebounceTime > level.time {
        ucmd.upmove = -127
        if NPC!.enemy != nil {
            NPC_CheckCanAttack(1.0, false)
        }
        return
    }

    if NPC!.enemy != nil {
        let monitor: Int32 = NPC!.cantHitEnemyCounter
        NPC_StandTrackAndShoot(NPC!, false) //(NPCInfo->hidingGoal != NULL) );

        if !((ucmd.buttons & BUTTON_ATTACK) != 0) && ucmd.upmove >= 0 && NPC!.cantHitEnemyCounter > monitor {
            //not crouching and not firing
            var vec = vec3_t()

            vec = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
            vec[2] = 0
            if VectorLength(vec) > 128 || NPC!.cantHitEnemyCounter >= 10 {
                //run at enemy if too far away
                //The cantHitEnemyCounter getting high has other repercussions
                //100 (10 seconds) will make you try to pick a new enemy...
                //But we're chasing, so we clamp it at 50 here
                if NPC!.cantHitEnemyCounter > 60 {
                    NPC!.cantHitEnemyCounter = 60
                }

                if NPC!.cantHitEnemyCounter >= (NPCInfo!.stats.aggression + 1) * 10 {
                    NPC_LostEnemyDecideChase()
                }

                //chase and face
                ucmd.angles[YAW] = 0
                ucmd.angles[PITCH] = 0
                NPCInfo!.goalEntity = NPC!.enemy
                NPCInfo!.goalRadius = 12
                //NAV_ClearLastRoute(NPC);
                NPC_MoveToGoal(true)
                NPC_UpdateAngles(true, true)
            } else {
                //FIXME: this could happen if they're just on the other side
                //of a thin wall or something else blocking out shot.  That
                //would make us just stand there and not go around it...
                //but maybe it's okay- might look like we're waiting for
                //him to come out...?
                //Current solution: runs around if cantHitEnemyCounter gets
                //to 10 (1 second).
            }
        } else {
            //Clear the can't hit enemy counter here
            NPC!.cantHitEnemyCounter = 0
        }
    } else {
        if NPCInfo!.tempBehavior == BS_HUNT_AND_KILL {
            //lost him, go back to what we were doing before
            NPCInfo!.tempBehavior = BS_DEFAULT
            return
        }

        //		NPC_BSRun();//only moves if we have a goal
    }
}

//Simply turn until facing desired angles
/// Source: oracle/codemp/game/NPC_AI_Default.c:490
func NPC_BSFace() {
    //FIXME: once you stop sending turning info, they reset to whatever their delta_angles was last????
    //Once this is over, it snaps back to what it was facing before- WHY???
    if NPC_UpdateAngles(true, true) {
        trap_ICARUS_TaskIDComplete(NPC!, TID_BSTATE)

        NPCInfo!.desiredYaw = client!.ps.viewangles[YAW]
        NPCInfo!.desiredPitch = client!.ps.viewangles[PITCH]

        NPCInfo!.aimTime = 0 //ok to turn normally now
    }
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:505
func NPC_BSPointShoot(_ shoot: Bool) {
    //FIXME: doesn't check for clear shot...
    var muzzle = vec3_t()
    var dir = vec3_t()
    var angles = vec3_t()
    var org = vec3_t()

    finished: do {
        if NPC!.enemy == nil || !NPC!.enemy!.inuse || (NPC!.enemy!.NPC != nil && NPC!.enemy!.health <= 0) {
            //FIXME: should still keep shooting for a second or two after they actually die...
            trap_ICARUS_TaskIDComplete(NPC!, TID_BSTATE)
            break finished
            return
        }

        CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)
        CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &org) //Was spot_org
        //Head is a little high, so let's aim for the chest:
        if NPC!.enemy!.client != nil {
            org[2] -= 12 //NOTE: is this enough?
        }

        dir = org - muzzle
        vectoangles(dir, &angles)

        switch NPC!.client!.ps.weapon {
        //	case WP_TRICORDER:
        case WP_NONE, WP_STUN_BATON, WP_SABER:
            //don't do any pitch change if not holding a firing weapon
            break

        default:
            NPCInfo!.lockedDesiredPitch = AngleNormalize360(angles[PITCH])
            NPCInfo!.desiredPitch = NPCInfo!.lockedDesiredPitch
        }

        NPCInfo!.lockedDesiredYaw = AngleNormalize360(angles[YAW])
        NPCInfo!.desiredYaw = NPCInfo!.lockedDesiredYaw

        if NPC_UpdateAngles(true, true) {
            //FIXME: if angles clamped, this may never work!
            //NPCInfo->shotTime = NPC->attackDebounceTime = 0;

            if shoot {
                //FIXME: needs to hold this down if using a weapon that requires it, like phaser...
                ucmd.buttons |= BUTTON_ATTACK
            }

            //if ( !shoot || !(NPC->svFlags & SVF_LOCKEDENEMY) )
            if 1 != 0 {
                //If locked_enemy is on, dont complete until it is destroyed...
                trap_ICARUS_TaskIDComplete(NPC!, TID_BSTATE)
                break finished
            }
        }
        //else if ( shoot && (NPC->svFlags & SVF_LOCKEDENEMY) )
        if 0 != 0 {
            //shooting them till their dead, not aiming right at them yet...
            /*
            qboolean movingTarget = qfalse;

            if ( NPC->enemy->client )
            {
            if ( VectorLengthSquared( NPC->enemy->client->ps.velocity ) )
            {
            movingTarget = qtrue;
            }
            }
            else if ( VectorLengthSquared( NPC->enemy->s.pos.trDelta ) )
            {
            movingTarget = qtrue;
            }

            if (movingTarget )
            */
            do {
                let dist: Float = VectorLength(dir)
                let yawMiss: Float
                var yawMissAllow: Float = NPC!.enemy!.r.maxs[0]
                let pitchMiss: Float
                var pitchMissAllow: Float = (NPC!.enemy!.r.maxs[2] - NPC!.enemy!.r.mins[2]) / 2

                if yawMissAllow < 8.0 {
                    yawMissAllow = 8.0
                }

                if pitchMissAllow < 8.0 {
                    pitchMissAllow = 8.0
                }

                yawMiss = tan(DEG2RAD(AngleDelta(NPC!.client!.ps.viewangles[YAW], NPCInfo!.desiredYaw))) * dist
                pitchMiss = tan(DEG2RAD(AngleDelta(NPC!.client!.ps.viewangles[PITCH], NPCInfo!.desiredPitch))) * dist

                if yawMissAllow >= yawMiss && pitchMissAllow > pitchMiss {
                    ucmd.buttons |= BUTTON_ATTACK
                }
            }
        }

        return

    }
    NPCInfo!.desiredYaw = client!.ps.viewangles[YAW]
    NPCInfo!.desiredPitch = client!.ps.viewangles[PITCH]

    NPCInfo!.aimTime = 0 //ok to turn normally now
}

/**
```
void NPC_BSMove(void)
Move in a direction, face another
```
*/
/// Source: oracle/codemp/game/NPC_AI_Default.c:616
func NPC_BSMove() {
    var goal: Entity? = nil

    NPC_CheckEnemy(true, false, true)
    if NPC!.enemy != nil {
        NPC_CheckCanAttack(1.0, false)
    } else {
        NPC_UpdateAngles(true, true)
    }

    goal = UpdateGoal()
    if goal != nil {
        //		NPCInfo->moveToGoalMod = 1.0;

        NPC_SlideMoveToGoal()
    }
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:644
func NPC_BSShoot() {
    //	NPC_BSMove();

    enemyVisibility = VIS_SHOOT

    if client!.ps.weaponstate != WEAPON_READY && client!.ps.weaponstate != WEAPON_FIRING {
        client!.ps.weaponstate = WEAPON_READY
    }

    WeaponThink(true)
}

/**
```
void NPC_BSPatrol( void )

  Same as idle, but you look for enemies every "vigilance"
  using your angles, HFOV, VFOV and visrange, and listen for sounds within earshot...
```
*/
/// Source: oracle/codemp/game/NPC_AI_Default.c:664
func NPC_BSPatrol() {
    //int	alertEventNum;

    if level.time > NPCInfo!.enemyCheckDebounceTime {
        NPCInfo!.enemyCheckDebounceTime = Int32(level.time + (NPCInfo!.stats.vigilance * 1000))
        NPC_CheckEnemy(true, false, true)
        if NPC!.enemy != nil {
            //FIXME: do anger script
            NPCInfo!.behaviorState = BS_HUNT_AND_KILL
            //NPC_AngerSound();
            return
        }
    }

    //FIXME: Implement generic sound alerts
    /*
    alertEventNum = NPC_CheckAlertEvents( qtrue, qtrue );
    if( alertEventNum != -1 )
    {//If we heard something, see if we should check it out
    if ( NPC_CheckInvestigate( alertEventNum ) )
    {
    return;
    }
    }
    */

    NPCInfo!.investigateSoundDebounceTime = 0
    //FIXME if there is no nav data, we need to do something else
    // if we're stuck, try to move around it
    if UpdateGoal() != nil {
        NPC_MoveToGoal(true)
    }

    NPC_UpdateAngles(true, true)

    ucmd.buttons |= BUTTON_WALKING
}

/// Source: oracle/codemp/game/NPC_AI_Default.c:712
func NPC_BSDefault() {
    //	vec3_t		enemyDir;
    //	float		enemyDist;
    //	float		shootDist;
    //	qboolean	enemyFOV = qfalse;
    //	qboolean	enemyShotFOV = qfalse;
    //	qboolean	enemyPVS = qfalse;
    //	vec3_t		enemyHead;
    //	vec3_t		muzzle;
    //	qboolean	enemyLOS = qfalse;
    //	qboolean	enemyCS = qfalse;
    var move: Bool = true
    //	qboolean	shoot = qfalse;


    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    if (NPCInfo!.scriptFlags & SCF_FORCED_MARCH) != 0 {
        //being forced to walk
        if NPC!.client!.ps.torsoAnim != TORSO_SURRENDER_START {
            NPC_SetAnim(NPC!, SETANIM_TORSO, TORSO_SURRENDER_START, SETANIM_FLAG_HOLD)
        }
    }
    //look for a new enemy if don't have one and are allowed to look, validate current enemy if have one
    NPC_CheckEnemy((NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0, false, true)
    if NPC!.enemy == nil {
        //still don't have an enemy
        if !((NPCInfo!.scriptFlags & SCF_IGNORE_ALERTS) != 0) {
            //check for alert events
            //FIXME: Check Alert events, see if we should investigate or just look at it
            let alertEvent: Int32 = NPC_CheckAlertEvents(true, true, -1, true, AEL_DISCOVERED)

            //There is an event to look at
            if alertEvent >= 0 && level.alertEvents[alertEvent].ID != NPCInfo!.lastAlertID {
                //heard/saw something
                if level.alertEvents[alertEvent].level >= AEL_DISCOVERED && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
                    //was a big event
                    if level.alertEvents[alertEvent].owner != nil && level.alertEvents[alertEvent].owner!.client != nil && level.alertEvents[alertEvent].owner!.health >= 0 && level.alertEvents[alertEvent].owner!.client!.playerTeam == NPC!.client!.enemyTeam {
                        //an enemy
                        G_SetEnemy(NPC!, level.alertEvents[alertEvent].owner!)
                    }
                } else {
                    //FIXME: investigate lesser events
                }
            }
            //FIXME: also check our allies' condition?
        }
    }

    if NPC!.enemy != nil && !((NPCInfo!.scriptFlags & SCF_FORCED_MARCH) != 0) {
        // just use the stormtrooper attack AI...
        NPC_CheckGetNewWeapon()
        if NPC!.client!.leader != nil && NPCInfo!.goalEntity == NPC!.client!.leader && !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
            NPC_ClearGoal()
        }
        NPC_BSST_Attack()
        return
        /*
        //have an enemy
        //FIXME: if one of these fails, meaning we can't shoot, do we really need to do the rest?
        VectorSubtract( NPC->enemy->r.currentOrigin, NPC->r.currentOrigin, enemyDir );
        enemyDist = VectorNormalize( enemyDir );
        enemyDist *= enemyDist;
        shootDist = NPC_MaxDistSquaredForWeapon();

        enemyFOV = InFOV( NPC->enemy, NPC, NPCInfo->stats.hfov, NPCInfo->stats.vfov );
        enemyShotFOV = InFOV( NPC->enemy, NPC, 20, 20 );
        enemyPVS = gi.inPVS( NPC->enemy->r.currentOrigin, NPC->r.currentOrigin );

        if ( enemyPVS )
        {//in the pvs
        trace_t	tr;

        CalcEntitySpot( NPC->enemy, SPOT_HEAD, enemyHead );
        enemyHead[2] -= Q_flrand( 0.0f, NPC->enemy->maxs[2]*0.5f );
        CalcEntitySpot( NPC, SPOT_WEAPON, muzzle );
        enemyLOS = NPC_ClearLOS( muzzle, enemyHead );

        gi.trace ( &tr, muzzle, vec3_origin, vec3_origin, enemyHead, NPC->s.number, MASK_SHOT );
        enemyCS = NPC_EvaluateShot( tr.entityNum, qtrue );
        }
        else
        {//skip thr 2 traces since they would have to fail
        enemyLOS = qfalse;
        enemyCS = qfalse;
        }

        if ( enemyCS && enemyShotFOV )
        {//can hit enemy if we want
        NPC->cantHitEnemyCounter = 0;
        }
        else
        {//can't hit
        NPC->cantHitEnemyCounter++;
        }

        if ( enemyCS && enemyShotFOV && enemyDist < shootDist )
        {//can shoot
        shoot = qtrue;
        if ( NPCInfo->goalEntity == NPC->enemy )
        {//my goal is my enemy and I have a clear shot, no need to chase right now
        move = qfalse;
        }
        }
        else
        {//don't shoot yet, keep chasing
        shoot = qfalse;
        move = qtrue;
        }

        //shoot decision
        if ( !(NPCInfo->scriptFlags&SCF_DONT_FIRE) )
        {//try to shoot
        if ( NPC->enemy )
        {
        if ( shoot )
        {
        if( !(NPCInfo->scriptFlags & SCF_FIRE_WEAPON) ) // we've already fired, no need to do it again here
        {
        WeaponThink( qtrue );
        }
        }
        }
        }

        //chase decision
        if ( NPCInfo->scriptFlags & SCF_CHASE_ENEMIES )
        {//go after him
        NPCInfo->goalEntity = NPC->enemy;
        //FIXME: don't need to chase when have a clear shot and in range?
        if ( !enemyCS && NPC->cantHitEnemyCounter > 60 )
        {//haven't been able to shoot enemy for about 6 seconds, need to do something
        //FIXME: combat points?  Just chase?
        if ( enemyPVS )
        {//in my PVS, just pick a combat point
        //FIXME: implement
        }
        else
        {//just chase him
        }
        }
        //FIXME: in normal behavior, should we use combat Points?  Do we care?  Is anyone actually going to ever use this AI?
        }
        else if ( NPC->cantHitEnemyCounter > 60 )
        {//pick a new one
        NPC_CheckEnemy( qtrue, qfalse, qtrue );
        }

        if ( enemyPVS && enemyLOS )//&& !enemyShotFOV )
        {//have a clear LOS to him//, but not looking at him
        //Find the desired angles
        vec3_t	angles;

        GetAnglesForDirection( muzzle, enemyHead, angles );

        NPCInfo->desiredYaw		= AngleNormalize180( angles[YAW] );
        NPCInfo->desiredPitch	= AngleNormalize180( angles[PITCH] );
        }
        */
    }

    if UpdateGoal() != nil {
        //have a goal
        if NPC!.enemy == nil && NPC!.client!.leader != nil && NPCInfo!.goalEntity == NPC!.client!.leader && !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
            NPC_BSFollowLeader()
        } else {
            //set angles
            if (NPCInfo!.scriptFlags & SCF_FACE_MOVE_DIR) != 0 || NPCInfo!.goalEntity != NPC!.enemy {
                //face direction of movement, NOTE: default behavior when not chasing enemy
                NPCInfo!.combatMove = false
            } else {
                //face goal.. FIXME: what if have a navgoal but want to face enemy while moving?  Will this do that?
                var dir = vec3_t()
                var angles = vec3_t()

                NPCInfo!.combatMove = false

                dir = NPCInfo!.goalEntity!.r.currentOrigin - NPC!.r.currentOrigin
                vectoangles(dir, &angles)
                NPCInfo!.desiredYaw = angles[YAW]
                if NPCInfo!.goalEntity == NPC!.enemy {
                    NPCInfo!.desiredPitch = angles[PITCH]
                }
            }

            //set movement
            //override default walk/run behavior
            //NOTE: redundant, done in NPC_ApplyScriptFlags
            if (NPCInfo!.scriptFlags & SCF_RUNNING) != 0 {
                ucmd.buttons &= ~BUTTON_WALKING
            } else if (NPCInfo!.scriptFlags & SCF_WALKING) != 0 {
                ucmd.buttons |= BUTTON_WALKING
            } else if NPCInfo!.goalEntity == NPC!.enemy {
                ucmd.buttons &= ~BUTTON_WALKING
            } else {
                ucmd.buttons |= BUTTON_WALKING
            }

            if (NPCInfo!.scriptFlags & SCF_FORCED_MARCH) != 0 {
                //being forced to walk
                //if ( g_crosshairEntNum != NPC->s.number )
                if !NPC_SomeoneLookingAtMe(NPC!) {
                    //don't walk if player isn't aiming at me
                    move = false
                }
            }

            if move {
                //move toward goal
                NPC_MoveToGoal(true)
            }
        }
    } else if NPC!.enemy == nil && NPC!.client!.leader != nil {
        NPC_BSFollowLeader()
    }

    //update angles
    NPC_UpdateAngles(true, true)
}
