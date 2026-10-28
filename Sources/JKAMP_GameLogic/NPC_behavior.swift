import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_behavior.c:730
private let APEX_HEIGHT = 200.0 as Float

/// Source: oracle/codemp/game/NPC_behavior.c:731
// Raven wrote: #define PARA_WIDTH ( sqrt ( APEX_HEIGHT ) + sqrt ( APEX_HEIGHT ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/NPC_behavior.c:732
private let JUMP_SPEED = 200.0 as Float

/**
```
 void NPC_BSAdvanceFight (void)

Advance towards your captureGoal and shoot anyone you can along the way.
```
*/
/// Source: oracle/codemp/game/NPC_behavior.c:29
func NPC_BSAdvanceFight() {
    //FIXME: IMPLEMENT
    //Head to Goal if I can

    //Make sure we're still headed where we want to capture
    if NPCInfo!.captureGoal != nil {
        //FIXME: if no captureGoal, what do we do?
        //VectorCopy( NPCInfo->captureGoal->r.currentOrigin, NPCInfo->tempGoal->r.currentOrigin );
        //NPCInfo->goalEntity = NPCInfo->tempGoal;

        NPC_SetMoveGoal(NPC!, NPCInfo!.captureGoal!.r.currentOrigin, 16, true, -1, nil)

        //		NAV_ClearLastRoute(NPC);
        NPCInfo!.goalTime = level.time + 100000
    }

    //	NPC_BSRun();

    NPC_CheckEnemy(true, false, true)

    //FIXME: Need melee code
    if NPC!.enemy != nil {
        //See if we can shoot him
        var delta = vec3_t()
        var forward = vec3_t()
        var angleToEnemy = vec3_t()
        var hitspot = vec3_t()
        var muzzle = vec3_t()
        var diff = vec3_t()
        var enemy_org = vec3_t()
        var enemy_head = vec3_t()
        var distanceToEnemy: Float = 0
        var attack_ok: Bool = false
        var dead_on: Bool = false
        var attack_scale: Float = 1.0
        var aim_off: Float = 0
        let max_aim_off: Float = 64

        //Yaw to enemy
        _VectorMA(NPC!.enemy!.r.absmin, 0.5, NPC!.enemy!.r.maxs, &enemy_org)
        CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)

        delta = enemy_org - muzzle
        vectoangles(delta, &angleToEnemy)
        distanceToEnemy = VectorNormalize(&delta)

        if !NPC_EnemyTooFar(NPC!.enemy!, distanceToEnemy * distanceToEnemy, true) {
            attack_ok = true
        }

        if attack_ok {
            NPC_UpdateShootAngles(angleToEnemy, false, true)

            NPCInfo!.enemyLastVisibility = enemyVisibility
            enemyVisibility = NPC_CheckVisibility(NPC!.enemy!, CHECK_FOV) //CHECK_360|//CHECK_PVS|

            if enemyVisibility == VIS_FOV {
                //He's in our FOV

                attack_ok = true
                CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_head)

                if attack_ok {
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { tr in
                        var traceEnt: Entity?
                        //are we gonna hit him if we shoot at his center?
                        trap_Trace(tr, muzzle, vec3_origin, vec3_origin, enemy_org, NPC!.s.number, MASK_SHOT)
                        traceEnt = g_entities[tr.entityNum]
                        if traceEnt != NPC!.enemy && (traceEnt == nil || traceEnt!.client == nil || NPC!.client!.enemyTeam == 0 || NPC!.client!.enemyTeam != traceEnt!.client!.playerTeam) {
                            //no, so shoot for the head
                            attack_scale = Float(Double(attack_scale) * 0.75)
                            trap_Trace(tr, muzzle, vec3_origin, vec3_origin, enemy_head, NPC!.s.number, MASK_SHOT)
                            traceEnt = g_entities[tr.entityNum]
                        }

                        hitspot = tr.endpos

                        if traceEnt == NPC!.enemy || (traceEnt!.client != nil && NPC!.client!.enemyTeam != 0 && NPC!.client!.enemyTeam == traceEnt!.client!.playerTeam) {
                            dead_on = true
                        } else {
                            attack_scale = Float(Double(attack_scale) * 0.5)
                            if NPC!.client!.playerTeam != 0 {
                                if traceEnt != nil && traceEnt!.client != nil && traceEnt!.client!.playerTeam != 0 {
                                    if NPC!.client!.playerTeam == traceEnt!.client!.playerTeam {
                                        //Don't shoot our own team
                                        attack_ok = false
                                    }
                                }
                            }
                        }
                    }
                }

                if attack_ok {
                    //ok, now adjust pitch aim
                    delta = hitspot - muzzle
                    vectoangles(delta, &angleToEnemy)
                    NPC!.NPC!.desiredPitch = angleToEnemy[PITCH]
                    NPC_UpdateShootAngles(angleToEnemy, true, false)

                    if !dead_on {
                        //We're not going to hit him directly, try a suppressing fire
                        //see if where we're going to shoot is too far from his origin
                        var scratchRight = vec3_t()
                        var scratchUp = vec3_t()
                        // Raven passes NULL for the right and up outputs.
                        AngleVectors(NPCInfo!.shootAngles, &forward, &scratchRight, &scratchUp)
                        _VectorMA(muzzle, distanceToEnemy, forward, &hitspot)
                        diff = hitspot - enemy_org
                        aim_off = VectorLength(diff)
                        // The SDK also declares `random`, so the call names the bg module.
                        if aim_off > JKAMP_BG.random() * max_aim_off {
                            attack_scale = Float(Double(attack_scale) * 0.75)
                            //see if where we're going to shoot is too far from his head
                            diff = hitspot - enemy_head
                            aim_off = VectorLength(diff)
                            // The SDK also declares `random`, so the call names the bg module.
                            if aim_off > JKAMP_BG.random() * max_aim_off {
                                attack_ok = false
                            }
                        }
                        attack_scale *= (max_aim_off - aim_off + 1) / max_aim_off
                    }
                }
            }
        }

        if attack_ok {
            if NPC_CheckAttack(attack_scale) {
                //check aggression to decide if we should shoot
                enemyVisibility = VIS_SHOOT
                WeaponThink(true)
            } else {
                attack_ok = false
            }
        }
        //Don't do this- only for when stationary and trying to shoot an enemy
        //		else
        //			NPC->cantHitEnemyCounter++;
    } else {
        //FIXME:
        NPC_UpdateShootAngles(NPC!.client!.ps.viewangles, true, true)
    }

    if ucmd.forwardmove == 0 && ucmd.rightmove == 0 {
        //We reached our captureGoal
        if trap_ICARUS_IsInitialized(NPC!.s.number) {
            trap_ICARUS_TaskIDComplete(NPC!, TID_BSTATE)
        }
    }
}

/// Source: oracle/codemp/game/NPC_behavior.c:185
func Disappear(_ `self`: Entity) {
    //	ClientDisconnect(self);
    `self`.s.eFlags |= EF_NODRAW
    `self`.think = nil
    `self`.nextthink = -1
}

/// Source: oracle/codemp/game/NPC_behavior.c:194
func BeamOut(_ `self`: Entity) {
    //	gentity_t *tent = G_Spawn();

    /*
    tent->owner = self;
    tent->think = MakeOwnerInvis;
    tent->nextthink = level.time + 1800;
    //G_AddEvent( ent, EV_PLAYER_TELEPORT, 0 );
    tent = G_TempEntity( self->client->pcurrentOrigin, EV_PLAYER_TELEPORT );
    */
    //fixme: doesn't actually go away!
    `self`.nextthink = level.time + 1500
    `self`.think = Think.Disappear
    `self`.client!.squadname = nil
    `self`.s.teamowner = TEAM_FREE
    `self`.client!.playerTeam = `self`.s.teamowner
    //self->r.svFlags |= SVF_BEAMING; //this appears unused in SP as well
}

/// Source: oracle/codemp/game/NPC_behavior.c:213
func NPC_BSCinematic() {
    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    if UpdateGoal() != nil {
        //have a goalEntity
        //move toward goal, should also face that goal
        NPC_MoveToGoal(true)
    }

    if NPCInfo!.watchTarget != nil {
        //have an entity which we want to keep facing
        //NOTE: this will override any angles set by NPC_MoveToGoal
        var eyes = vec3_t()
        var viewSpot = vec3_t()
        var viewvec = vec3_t()
        var viewangles = vec3_t()

        CalcEntitySpot(NPC!, SPOT_HEAD_LEAN, &eyes)
        CalcEntitySpot(NPCInfo!.watchTarget!, SPOT_HEAD_LEAN, &viewSpot)

        viewvec = viewSpot - eyes

        vectoangles(viewvec, &viewangles)

        NPCInfo!.desiredYaw = viewangles[YAW]
        NPCInfo!.lockedDesiredYaw = NPCInfo!.desiredYaw
        NPCInfo!.desiredPitch = viewangles[PITCH]
        NPCInfo!.lockedDesiredPitch = NPCInfo!.desiredPitch
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_behavior.c:246
func NPC_BSWait() {
    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_behavior.c:252
func NPC_BSInvestigate() {
    /*
    //FIXME: maybe allow this to be set as a tempBState in a script?  Just specify the
    //investigateGoal, investigateDebounceTime and investigateCount? (Needs a macro)
    vec3_t		invDir, invAngles, spot;
    gentity_t	*saveGoal;
    //BS_INVESTIGATE would turn toward goal, maybe take a couple steps towards it,
    //look for enemies, then turn away after your investigate counter was down-
    //investigate counter goes up every time you set it...

    if(level.time > NPCInfo->enemyCheckDebounceTime)
    {
    NPCInfo->enemyCheckDebounceTime = level.time + (NPCInfo->stats.vigilance * 1000);
    NPC_CheckEnemy(qtrue, qfalse);
    if(NPC->enemy)
    {//FIXME: do anger script
    NPCInfo->goalEntity = NPC->enemy;
    //			NAV_ClearLastRoute(NPC);
    NPCInfo->behaviorState = BS_RUN_AND_SHOOT;
    NPCInfo->tempBehavior = BS_DEFAULT;
    NPC_AngerSound();
    return;
    }
    }

    NPC_SetAnim( NPC, SETANIM_TORSO, TORSO_WEAPONREADY3, SETANIM_FLAG_NORMAL );

    if(NPCInfo->stats.vigilance <= 1.0 && NPCInfo->eventOwner)
    {
    VectorCopy(NPCInfo->eventOwner->r.currentOrigin, NPCInfo->investigateGoal);
    }

    saveGoal = NPCInfo->goalEntity;
    if(	level.time > NPCInfo->walkDebounceTime )
    {
    vec3_t	vec;

    VectorSubtract(NPCInfo->investigateGoal, NPC->r.currentOrigin, vec);
    vec[2] = 0;
    if(VectorLength(vec) > 64)
    {
    if(Q_irand(0, 100) < NPCInfo->investigateCount)
    {//take a full step
    //NPCInfo->walkDebounceTime = level.time + 1400;
    //actually finds length of my BOTH_WALK anim
    NPCInfo->walkDebounceTime = PM_AnimLength( NPC->client->clientInfo.animFileIndex, BOTH_WALK1 );
    }
    }
    }

    if(	level.time < NPCInfo->walkDebounceTime )
    {//walk toward investigateGoal

    / *
    NPCInfo->goalEntity = NPCInfo->tempGoal;
    //		NAV_ClearLastRoute(NPC);
    VectorCopy(NPCInfo->investigateGoal, NPCInfo->tempGoal->r.currentOrigin);
    */

    /*		NPC_SetMoveGoal( NPC, NPCInfo->investigateGoal, 16, qtrue );

    NPC_MoveToGoal( qtrue );

    //FIXME: walk2?
    NPC_SetAnim(NPC,SETANIM_LEGS,BOTH_WALK1,SETANIM_FLAG_NORMAL);

    ucmd.buttons |= BUTTON_WALKING;
    }
    else
    {

    NPC_SetAnim(NPC,SETANIM_LEGS,BOTH_STAND1,SETANIM_FLAG_NORMAL);

    if(NPCInfo->hlookCount > 30)
    {
    if(Q_irand(0, 10) > 7)
    {
    NPCInfo->hlookCount = 0;
    }
    }
    else if(NPCInfo->hlookCount < -30)
    {
    if(Q_irand(0, 10) > 7)
    {
    NPCInfo->hlookCount = 0;
    }
    }
    else if(NPCInfo->hlookCount == 0)
    {
    NPCInfo->hlookCount = Q_irand(-1, 1);
    }
    else if(Q_irand(0, 10) > 7)
    {
    if(NPCInfo->hlookCount > 0)
    {
    NPCInfo->hlookCount++;
    }
    else//lookCount < 0
    {
    NPCInfo->hlookCount--;
    }
    }

    if(NPCInfo->vlookCount >= 15)
    {
    if(Q_irand(0, 10) > 7)
    {
    NPCInfo->vlookCount = 0;
    }
    }
    else if(NPCInfo->vlookCount <= -15)
    {
    if(Q_irand(0, 10) > 7)
    {
    NPCInfo->vlookCount = 0;
    }
    }
    else if(NPCInfo->vlookCount == 0)
    {
    NPCInfo->vlookCount = Q_irand(-1, 1);
    }
    else if(Q_irand(0, 10) > 8)
    {
    if(NPCInfo->vlookCount > 0)
    {
    NPCInfo->vlookCount++;
    }
    else//lookCount < 0
    {
    NPCInfo->vlookCount--;
    }
    }

    //turn toward investigateGoal
    CalcEntitySpot( NPC, SPOT_HEAD, spot );
    VectorSubtract(NPCInfo->investigateGoal, spot, invDir);
    VectorNormalize(invDir);
    vectoangles(invDir, invAngles);
    NPCInfo->desiredYaw = AngleNormalize360(invAngles[YAW] + NPCInfo->hlookCount);
    NPCInfo->desiredPitch = AngleNormalize360(invAngles[PITCH] + NPCInfo->hlookCount);
    }

    NPC_UpdateAngles(qtrue, qtrue);

    NPCInfo->goalEntity = saveGoal;
    //	NAV_ClearLastRoute(NPC);

    if(level.time > NPCInfo->investigateDebounceTime)
    {
    NPCInfo->tempBehavior = BS_DEFAULT;
    }

    NPC_CheckSoundEvents();
    */
}

/// Source: oracle/codemp/game/NPC_behavior.c:409
func NPC_CheckInvestigate(_ alertEventNum: Int32) -> Bool {
    let owner: Entity? = level.alertEvents[alertEventNum].owner
    let invAdd: Int32 = level.alertEvents[alertEventNum].level
    var soundPos = vec3_t()
    let soundRad: Float = level.alertEvents[alertEventNum].radius
    let earshot: Float = NPCInfo!.stats.earshot

    soundPos = level.alertEvents[alertEventNum].position

    //NOTE: Trying to preserve previous investigation behavior
    if owner == nil {
        return false
    }

    if owner!.s.eType != ET_PLAYER && owner!.s.eType != ET_NPC && owner == NPCInfo!.goalEntity {
        return false
    }

    if (owner!.s.eFlags & EF_NODRAW) != 0 {
        return false
    }

    if (owner!.flags & FL_NOTARGET) != 0 {
        return false
    }

    if soundRad < earshot {
        return false
    }

    //if(!trap_InPVSIgnorePortals(ent->r.currentOrigin, NPC->r.currentOrigin))//should we be able to hear through areaportals?
    if !trap_InPVS(soundPos, NPC!.r.currentOrigin) {
        //can hear through doors?
        return false
    }

    if owner!.client != nil && owner!.client!.playerTeam != 0 && NPC!.client!.playerTeam != 0 && owner!.client!.playerTeam != NPC!.client!.playerTeam {
        if Float(NPCInfo!.investigateCount) >= (NPCInfo!.stats.vigilance * 200) && owner != nil {
            //If investigateCount == 10, just take it as enemy and go
            if ValidEnemy(owner!) {
                //FIXME: run angerscript
                G_SetEnemy(NPC!, owner!)
                NPCInfo!.goalEntity = NPC!.enemy
                NPCInfo!.goalRadius = 12
                NPCInfo!.behaviorState = BS_HUNT_AND_KILL
                return true
            }
        } else {
            NPCInfo!.investigateCount += invAdd
        }
        //run awakescript
        G_ActivateBehavior(NPC!, BSET_AWAKE)

        /*
        if ( Q_irand(0, 10) > 7 )
        {
        NPC_AngerSound();
        }
        */

        //NPCInfo->hlookCount = NPCInfo->vlookCount = 0;
        NPCInfo!.eventOwner = owner
        NPCInfo!.investigateGoal = soundPos
        if NPCInfo!.investigateCount > 20 {
            NPCInfo!.investigateDebounceTime = level.time + 10000
        } else {
            NPCInfo!.investigateDebounceTime = level.time + (NPCInfo!.investigateCount * 500)
        }
        NPCInfo!.tempBehavior = BS_INVESTIGATE
        return true
    }

    return false
}

/**
```
void NPC_BSSleep( void )
```
*/
/// Source: oracle/codemp/game/NPC_behavior.c:500
func NPC_BSSleep() {
    let alertEvent: Int32 = NPC_CheckAlertEvents(true, false, -1, false, AEL_MINOR)

    //There is an event to look at
    if alertEvent >= 0 {
        G_ActivateBehavior(NPC!, BSET_AWAKE)
        return
    }

    /*
    if ( level.time > NPCInfo->enemyCheckDebounceTime )
    {
    if ( NPC_CheckSoundEvents() != -1 )
    {//only 1 alert per second per 0.1 of vigilance
    NPCInfo->enemyCheckDebounceTime = level.time + (NPCInfo->stats.vigilance * 10000);
    G_ActivateBehavior(NPC, BSET_AWAKE);
    }
    }
    */
}

/// Source: oracle/codemp/game/NPC_behavior.c:524
func NPC_BSFollowLeader() {
    var vec = vec3_t()
    let leaderDist: Float
    let leaderVis: visibility_t
    let curAnim: Int32

    if NPC!.client!.leader == nil {
        //ok, stand guard until we find an enemy
        if NPCInfo!.tempBehavior == BS_HUNT_AND_KILL {
            NPCInfo!.tempBehavior = BS_DEFAULT
        } else {
            NPCInfo!.tempBehavior = BS_STAND_GUARD
            NPC_BSStandGuard()
        }
        return
    }

    if NPC!.enemy == nil {
        //no enemy, find one
        NPC_CheckEnemy(NPCInfo!.confusionTime < level.time, false, true) //don't find new enemy if this is tempbehav
        if NPC!.enemy != nil {
            //just found one
            NPCInfo!.enemyCheckDebounceTime = level.time + Q_irand(3000, 10000)
        } else {
            if !((NPCInfo!.scriptFlags & SCF_IGNORE_ALERTS) != 0) {
                let eventID: Int32 = NPC_CheckAlertEvents(true, true, -1, false, AEL_MINOR)
                if level.alertEvents[eventID].level >= AEL_SUSPICIOUS && (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
                    NPCInfo!.lastAlertID = level.alertEvents[eventID].ID
                    if level.alertEvents[eventID].owner == nil || level.alertEvents[eventID].owner!.client == nil || level.alertEvents[eventID].owner!.health <= 0 || level.alertEvents[eventID].owner!.client!.playerTeam != NPC!.client!.enemyTeam {
                        //not an enemy
                    } else {
                        //FIXME: what if can't actually see enemy, don't know where he is... should we make them just become very alert and start looking for him?  Or just let combat AI handle this... (act as if you lost him)
                        G_SetEnemy(NPC!, level.alertEvents[eventID].owner!)
                        NPCInfo!.enemyCheckDebounceTime = level.time + Q_irand(3000, 10000)
                        NPCInfo!.enemyLastSeenTime = level.time
                        TIMER_Set(NPC!, "attackDelay", Q_irand(500, 1000))
                    }
                }
            }
        }
        if NPC!.enemy == nil {
            if NPC!.client!.leader != nil && NPC!.client!.leader!.enemy != nil && NPC!.client!.leader!.enemy != NPC && ((NPC!.client!.leader!.enemy!.client != nil && NPC!.client!.leader!.enemy!.client!.playerTeam == NPC!.client!.enemyTeam) || (0 != 0 && NPC!.client!.leader!.enemy!.alliedTeam == NPC!.client!.enemyTeam)) && NPC!.client!.leader!.enemy!.health > 0 {
                //rwwFIXMEFIXME: use SVF_NONNPC_ENEMY?
                G_SetEnemy(NPC!, NPC!.client!.leader!.enemy!)
                NPCInfo!.enemyCheckDebounceTime = level.time + Q_irand(3000, 10000)
                NPCInfo!.enemyLastSeenTime = level.time
            }
        }
    } else {
        if NPC!.enemy!.health <= 0 || (NPC!.enemy!.flags & FL_NOTARGET) != 0 {
            G_ClearEnemy(NPC!)
            if NPCInfo!.enemyCheckDebounceTime > level.time + 1000 {
                NPCInfo!.enemyCheckDebounceTime = level.time + Q_irand(1000, 2000)
            }
        } else if NPC!.client!.ps.weapon != 0 && NPCInfo!.enemyCheckDebounceTime < level.time {
            NPC_CheckEnemy((NPCInfo!.confusionTime < level.time || NPCInfo!.tempBehavior != BS_FOLLOW_LEADER), false, true) //don't find new enemy if this is tempbehav
        }
    }

    if NPC!.enemy != nil && NPC!.client!.ps.weapon != 0 {
        //If have an enemy, face him and fire
        if NPC!.client!.ps.weapon == WP_SABER {
            //lightsaber user or charmed enemy
            if NPCInfo!.tempBehavior != BS_FOLLOW_LEADER {
                //not already in a temp bState
                //go after the guy
                NPCInfo!.tempBehavior = BS_HUNT_AND_KILL
                NPC_UpdateAngles(true, true)
                return
            }
        }

        enemyVisibility = NPC_CheckVisibility(NPC!.enemy!, CHECK_FOV | CHECK_SHOOT) //CHECK_360|CHECK_PVS|
        if enemyVisibility > VIS_PVS {
            //face
            var enemy_org = vec3_t()
            var muzzle = vec3_t()
            var delta = vec3_t()
            var angleToEnemy = vec3_t()
            let distanceToEnemy: Float

            CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_org)
            NPC_AimWiggle(&enemy_org)

            CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)

            delta = enemy_org - muzzle
            vectoangles(delta, &angleToEnemy)
            distanceToEnemy = VectorNormalize(&delta)

            NPCInfo!.desiredYaw = angleToEnemy[YAW]
            NPCInfo!.desiredPitch = angleToEnemy[PITCH]
            NPC_UpdateFiringAngles(true, true)

            if enemyVisibility >= VIS_SHOOT {
                //shoot
                NPC_AimAdjust(2)
                if NPC_GetHFOVPercentage(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, Float(NPCInfo!.stats.hfov)) > 0.6 && NPC_GetHFOVPercentage(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, Float(NPCInfo!.stats.vfov)) > 0.5 {
                    //actually withing our front cone
                    WeaponThink(true)
                }
            } else {
                NPC_AimAdjust(1)
            }

            //NPC_CheckCanAttack(1.0, qfalse);
        } else {
            NPC_AimAdjust(-1)
        }
    } else {
        //FIXME: combine with vector calc below
        var head = vec3_t()
        var leaderHead = vec3_t()
        var delta = vec3_t()
        var angleToLeader = vec3_t()

        CalcEntitySpot(NPC!.client!.leader!, SPOT_HEAD, &leaderHead)
        CalcEntitySpot(NPC!, SPOT_HEAD, &head)
        delta = leaderHead - head
        vectoangles(delta, &angleToLeader)
        VectorNormalize(&delta)
        NPC!.NPC!.desiredYaw = angleToLeader[YAW]
        NPC!.NPC!.desiredPitch = angleToLeader[PITCH]

        NPC_UpdateAngles(true, true)
    }

    //leader visible?
    leaderVis = NPC_CheckVisibility(NPC!.client!.leader!, CHECK_PVS | CHECK_360 | CHECK_SHOOT) //			ent->e_UseFunc = useF_NULL;


    //Follow leader, stay within visibility and a certain distance, maintain a distance from.
    curAnim = NPC!.client!.ps.legsAnim
    if curAnim != BOTH_ATTACK1 && curAnim != BOTH_ATTACK2 && curAnim != BOTH_ATTACK3 && curAnim != BOTH_MELEE1 && curAnim != BOTH_MELEE2 {
        //Don't move toward leader if we're in a full-body attack anim
        //FIXME, use IdealDistance to determine if we need to close distance
        var followDist: Float = 96.0
        let backupdist: Float
        let walkdist: Float
        let minrundist: Float
        let leaderHDist: Float

        if NPCInfo!.followDist != 0 {
            followDist = NPCInfo!.followDist
        }
        backupdist = followDist / 2.0
        walkdist = Float(Double(followDist) * 0.83)
        minrundist = Float(Double(followDist) * 1.33)

        vec = NPC!.client!.leader!.r.currentOrigin - NPC!.r.currentOrigin
        leaderDist = VectorLength(vec) //FIXME: make this just nav distance?
        //never get within their radius horizontally
        vec[2] = 0
        leaderHDist = VectorLength(vec)
        if leaderHDist > backupdist && (leaderVis != VIS_SHOOT || leaderDist > walkdist) {
            //We should close in?
            NPCInfo!.goalEntity = NPC!.client!.leader

            NPC_SlideMoveToGoal()
            if leaderVis == VIS_SHOOT && leaderDist < minrundist {
                ucmd.buttons |= BUTTON_WALKING
            }
        } else if leaderDist < backupdist {
            //We should back off?
            NPCInfo!.goalEntity = NPC!.client!.leader
            NPC_SlideMoveToGoal()

            //reversing direction
            ucmd.forwardmove = -ucmd.forwardmove
            ucmd.rightmove = -ucmd.rightmove
            NPC!.client!.ps.moveDir = NPC!.client!.ps.moveDir * -1
        }
        //check for do not enter and stop if there's one there...
        if ucmd.forwardmove != 0 || ucmd.rightmove != 0 || VectorCompare(vec3_origin, NPC!.client!.ps.moveDir) != 0 {
            NPC_MoveDirClear(ucmd.forwardmove, ucmd.rightmove, true)
        }
    }
}

/// Source: oracle/codemp/game/NPC_behavior.c:733
func NPC_BSJump() {
    var dir = vec3_t()
    var angles = vec3_t()
    var p1 = vec3_t()
    var p2 = vec3_t()
    var apex = vec3_t()
    let time: Float
    let height: Float
    let forward: Float
    var z: Float
    var xy: Float
    let dist: Float
    let yawError: Float
    let apexHeight: Float

    if NPCInfo!.goalEntity == nil {
        //Should have task completed the navgoal
        return
    }

    if NPCInfo!.jumpState != JS_JUMPING && NPCInfo!.jumpState != JS_LANDING {
        //Face navgoal
        dir = NPCInfo!.goalEntity!.r.currentOrigin - NPC!.r.currentOrigin
        vectoangles(dir, &angles)
        NPCInfo!.lockedDesiredPitch = AngleNormalize360(angles[PITCH])
        NPCInfo!.desiredPitch = NPCInfo!.lockedDesiredPitch
        NPCInfo!.lockedDesiredYaw = AngleNormalize360(angles[YAW])
        NPCInfo!.desiredYaw = NPCInfo!.lockedDesiredYaw
    }

    NPC_UpdateAngles(true, true)
    yawError = AngleDelta(NPC!.client!.ps.viewangles[YAW], NPCInfo!.desiredYaw)
    //We don't really care about pitch here

    switch NPCInfo!.jumpState {
    case JS_FACING:
        if yawError < MIN_ANGLE_ERROR {
            //Facing it, Start crouching
            NPC_SetAnim(NPC!, SETANIM_LEGS, BOTH_CROUCH1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            NPCInfo!.jumpState = JS_CROUCHING
        }

    case JS_CROUCHING:
        if NPC!.client!.ps.legsTimer > 0 {
            //Still playing crouching anim
            return
        }

        //Create a parabola

        if NPC!.r.currentOrigin[2] > NPCInfo!.goalEntity!.r.currentOrigin[2] {
            p1 = NPC!.r.currentOrigin
            p2 = NPCInfo!.goalEntity!.r.currentOrigin
        } else if NPC!.r.currentOrigin[2] < NPCInfo!.goalEntity!.r.currentOrigin[2] {
            p1 = NPCInfo!.goalEntity!.r.currentOrigin
            p2 = NPC!.r.currentOrigin
        } else {
            p1 = NPC!.r.currentOrigin
            p2 = NPCInfo!.goalEntity!.r.currentOrigin
        }

        //z = xy*xy
        dir = p2 - p1
        dir[2] = 0

        //Get xy and z diffs
        xy = VectorNormalize(&dir)
        z = p1[2] - p2[2]

        apexHeight = APEX_HEIGHT / 2
        /*
        //Determine most desirable apex height
        apexHeight = (APEX_HEIGHT * PARA_WIDTH/xy) + (APEX_HEIGHT * z/128);
        if ( apexHeight < APEX_HEIGHT * 0.5 )
        {
        apexHeight = APEX_HEIGHT*0.5;
        }
        else if ( apexHeight > APEX_HEIGHT * 2 )
        {
        apexHeight = APEX_HEIGHT*2;
        }
        */

        //FIXME: length of xy will change curve of parabola, need to account for this
        //somewhere... PARA_WIDTH

        z = (sqrt(apexHeight + z) - sqrt(apexHeight))


        //		Com_Printf("apex is %4.2f percent from p1: ", (xy-z)*0.5/xy*100.0f);

        xy -= z
        xy = Float(Double(xy) * 0.5)


        _VectorMA(p1, xy, dir, &apex)
        apex[2] += apexHeight

        NPC!.pos1 = apex

        //Now we have the apex, aim for it
        height = apex[2] - NPC!.r.currentOrigin[2]
        time = Float(sqrt(Double(height) / (0.5 * Double(NPC!.client!.ps.gravity))))
        if time == 0 {
            //			Com_Printf("ERROR no time in jump\n");
            return
        }

        // set s.origin2 to the push velocity
        NPC!.client!.ps.velocity = apex - NPC!.r.currentOrigin
        NPC!.client!.ps.velocity[2] = 0
        dist = VectorNormalize(&NPC!.client!.ps.velocity)

        forward = dist / time
        NPC!.client!.ps.velocity = NPC!.client!.ps.velocity * forward

        NPC!.client!.ps.velocity[2] = time * NPC!.client!.ps.gravity

        //		Com_Printf( "%s jumping %s, gravity at %4.0f percent\n", NPC->targetname, vtos(NPC->client->ps.velocity), NPC->client->ps.gravity/8.0f );

        NPC!.flags |= FL_NO_KNOCKBACK
        NPCInfo!.jumpState = JS_JUMPING

    case JS_JUMPING:
        if showBBoxes {
            p1 = NPC!.r.mins + NPC!.pos1
            p2 = NPC!.r.maxs + NPC!.pos1
            G_Cube(p1, p2, NPCDEBUG_BLUE, 0.5)
        }

        if NPC!.s.groundEntityNum != ENTITYNUM_NONE {
            //Landed, start landing anim
            //FIXME: if the
            NPC!.client!.ps.velocity = vec3_t()
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_LAND1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            NPCInfo!.jumpState = JS_LANDING
            //FIXME: landsound?
        } else if NPC!.client!.ps.legsTimer > 0 {
            //Still playing jumping anim
            //FIXME: apply jump velocity here, a couple frames after start, not right away
            return
        } else {
            //still in air, but done with jump anim, play inair anim
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_INAIR1, SETANIM_FLAG_OVERRIDE)
        }

    case JS_LANDING:
        if NPC!.client!.ps.legsTimer > 0 {
            //Still playing landing anim
            return
        } else {
            NPCInfo!.jumpState = JS_WAITING


            //task complete no matter what...
            NPC_ClearGoal()
            NPCInfo!.goalTime = level.time
            NPCInfo!.aiFlags &= ~NPCAI_MOVING
            ucmd.forwardmove = 0
            NPC!.flags &= ~FL_NO_KNOCKBACK
            //Return that the goal was reached
            trap_ICARUS_TaskIDComplete(NPC!, TID_MOVE_NAV)

            //Or should we keep jumping until reached goal?

            /*
            NPCInfo->goalEntity = UpdateGoal();
            if ( !NPCInfo->goalEntity )
            {
            NPC->flags &= ~FL_NO_KNOCKBACK;
            Q3_TaskIDComplete( NPC, TID_MOVE_NAV );
            }
            */
        }

    default:
        NPCInfo!.jumpState = JS_FACING
    }
}

/// Source: oracle/codemp/game/NPC_behavior.c:921
func NPC_BSRemove() {
    NPC_UpdateAngles(true, true)
    if !trap_InPVS(NPC!.r.currentOrigin, g_entities[0].r.currentOrigin) {
        //rwwFIXMEFIXME: Care about all clients instead of just 0?
        G_UseTargets2(NPC, NPC, NPC!.target3)
        NPC!.s.eFlags |= EF_NODRAW
        NPC!.s.eType = ET_INVISIBLE
        NPC!.r.contents = 0
        NPC!.health = 0
        NPC!.targetname = nil

        //Disappear in half a second
        NPC!.think = Think.G_FreeEntity
        NPC!.nextthink = level.time + FRAMETIME
    }
}

/// Source: oracle/codemp/game/NPC_behavior.c:939
func NPC_BSSearch() {
    NPC_CheckEnemy(true, false, true)
    //Look for enemies, if find one:
    if NPC!.enemy != nil {
        if NPCInfo!.tempBehavior == BS_SEARCH {
            //if tempbehavior, set tempbehavior to default
            NPCInfo!.tempBehavior = BS_DEFAULT
        } else {
            //if bState, change to run and shoot
            NPCInfo!.behaviorState = BS_HUNT_AND_KILL
            NPC_BSRunAndShoot()
        }
        return
    }

    //FIXME: what if our goalEntity is not NULL and NOT our tempGoal - they must
    //want us to do something else?  If tempBehavior, just default, else set
    //to run and shoot...?

    //FIXME: Reimplement

    if NPCInfo!.investigateDebounceTime == 0 {
        //On our way to a tempGoal
        var minGoalReachedDistSquared: Float = Float(32 * 32)
        var vec = vec3_t()

        //Keep moving toward our tempGoal
        NPCInfo!.goalEntity = NPCInfo!.tempGoal

        vec = NPCInfo!.tempGoal!.r.currentOrigin - NPC!.r.currentOrigin
        if vec[2] < 24 {
            vec[2] = 0
        }

        if NPCInfo!.tempGoal!.waypoint != WAYPOINT_NONE {
            /*
            //FIXME: can't get the radius...
            float	wpRadSq = waypoints[NPCInfo->tempGoal->waypoint].radius * waypoints[NPCInfo->tempGoal->waypoint].radius;
            if ( minGoalReachedDistSquared > wpRadSq )
            {
            minGoalReachedDistSquared = wpRadSq;
            }
            */

            minGoalReachedDistSquared = Float(32 * 32) //12*12;
        }

        if VectorLengthSquared(vec) < minGoalReachedDistSquared {
            //Close enough, just got there
            NPC!.waypoint = NAV_FindClosestWaypointForEnt(NPC!, WAYPOINT_NONE)

            if (NPCInfo!.homeWp == WAYPOINT_NONE) || (NPC!.waypoint == WAYPOINT_NONE) {
                //Heading for or at an invalid waypoint, get out of this bState
                if NPCInfo!.tempBehavior == BS_SEARCH {
                    //if tempbehavior, set tempbehavior to default
                    NPCInfo!.tempBehavior = BS_DEFAULT
                } else {
                    //if bState, change to stand guard
                    NPCInfo!.behaviorState = BS_STAND_GUARD
                    NPC_BSRunAndShoot()
                }
                return
            }

            if NPC!.waypoint == NPCInfo!.homeWp {
                //Just Reached our homeWp, if this is the first time, run your lostenemyscript
                if (NPCInfo!.aiFlags & NPCAI_ENROUTE_TO_HOMEWP) != 0 {
                    NPCInfo!.aiFlags &= ~NPCAI_ENROUTE_TO_HOMEWP
                    G_ActivateBehavior(NPC!, BSET_LOSTENEMY)
                }
            }

            //Com_Printf("Got there.\n");
            //Com_Printf("Looking...");
            if Q_irand(0, 1) == 0 {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_GUARD_LOOKAROUND1, SETANIM_FLAG_NORMAL)
            } else {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_GUARD_IDLE1, SETANIM_FLAG_NORMAL)
            }
            NPCInfo!.investigateDebounceTime = level.time + Q_irand(3000, 10000)
        } else {
            NPC_MoveToGoal(true)
        }
    } else {
        //We're there
        if NPCInfo!.investigateDebounceTime > level.time {
            //Still waiting around for a bit
            //Turn angles every now and then to look around
            if NPCInfo!.tempGoal!.waypoint != WAYPOINT_NONE {
                if Q_irand(0, 30) == 0 {
                    let numEdges: Int32 = trap_Nav_GetNodeNumEdges(NPCInfo!.tempGoal!.waypoint)

                    if numEdges != WAYPOINT_NONE {
                        let branchNum: Int32 = Q_irand(0, numEdges - 1)

                        var branchPos = vec3_t()
                        var lookDir = vec3_t()

                        let nextWp: Int32 = trap_Nav_GetNodeEdge(NPCInfo!.tempGoal!.waypoint, branchNum)
                        trap_Nav_GetNodePosition(nextWp, &branchPos)

                        lookDir = branchPos - NPCInfo!.tempGoal!.r.currentOrigin
                        NPCInfo!.desiredYaw = AngleNormalize360(vectoyaw(lookDir) + flrand(-45, 45))
                    }

                    //pick an angle +-45 degrees off of the dir of a random branch
                    //from NPCInfo->tempGoal->waypoint
                    //int branch = Q_irand( 0, (waypoints[NPCInfo->tempGoal->waypoint].numNeighbors - 1) );
                    //int	nextWp = waypoints[NPCInfo->tempGoal->waypoint].nextWaypoint[branch][NPC->client->moveType];
                    //vec3_t	lookDir;

                    //VectorSubtract( waypoints[nextWp].origin, NPCInfo->tempGoal->r.currentOrigin, lookDir );
                    //Look in that direction +- 45 degrees
                    //NPCInfo->desiredYaw = AngleNormalize360( vectoyaw( lookDir ) + Q_flrand( -45, 45 ) );
                }
            }
            //Com_Printf(".");
        } else {
            //Just finished waiting
            NPC!.waypoint = NAV_FindClosestWaypointForEnt(NPC!, WAYPOINT_NONE)

            if NPC!.waypoint == NPCInfo!.homeWp {
                let numEdges: Int32 = trap_Nav_GetNodeNumEdges(NPCInfo!.tempGoal!.waypoint)

                if numEdges != WAYPOINT_NONE {
                    let branchNum: Int32 = Q_irand(0, numEdges - 1)

                    let nextWp: Int32 = trap_Nav_GetNodeEdge(NPCInfo!.homeWp, branchNum)
                    trap_Nav_GetNodePosition(nextWp, &NPCInfo!.tempGoal!.r.currentOrigin)
                    NPCInfo!.tempGoal!.waypoint = nextWp
                }

                /*
                //Pick a random branch
                int branch = Q_irand( 0, (waypoints[NPCInfo->homeWp].numNeighbors - 1) );
                int	nextWp = waypoints[NPCInfo->homeWp].nextWaypoint[branch][NPC->client->moveType];

                VectorCopy( waypoints[nextWp].origin, NPCInfo->tempGoal->r.currentOrigin );
                NPCInfo->tempGoal->waypoint = nextWp;
                //Com_Printf("\nHeading for wp %d...\n", waypoints[NPCInfo->homeWp].nextWaypoint[branch][NPC->client->moveType]);
                */
            } else {
                //At a branch, so return home
                trap_Nav_GetNodePosition(NPCInfo!.homeWp, &NPCInfo!.tempGoal!.r.currentOrigin)
                NPCInfo!.tempGoal!.waypoint = NPCInfo!.homeWp
                /*
                VectorCopy( waypoints[NPCInfo->homeWp].origin, NPCInfo->tempGoal->r.currentOrigin );
                NPCInfo->tempGoal->waypoint = NPCInfo->homeWp;
                //Com_Printf("\nHeading for wp %d...\n", NPCInfo->homeWp);
                */
            }

            NPCInfo!.investigateDebounceTime = 0
            //Start moving toward our tempGoal
            NPCInfo!.goalEntity = NPCInfo!.tempGoal
            NPC_MoveToGoal(true)
        }
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_behavior.c:1132
func NPC_BSSearchStart(_ homeWp: Int32, _ bState: bState_t) {
    // Raven assigns his own `homeWp` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var homeWp = homeWp
    //FIXME: Reimplement
    if homeWp == WAYPOINT_NONE {
        homeWp = NAV_FindClosestWaypointForEnt(NPC!, WAYPOINT_NONE)
        if NPC!.waypoint == WAYPOINT_NONE {
            NPC!.waypoint = homeWp
        }
    }
    NPCInfo!.homeWp = homeWp
    NPCInfo!.tempBehavior = bState
    NPCInfo!.aiFlags |= NPCAI_ENROUTE_TO_HOMEWP
    NPCInfo!.investigateDebounceTime = 0
    trap_Nav_GetNodePosition(homeWp, &NPCInfo!.tempGoal!.r.currentOrigin)
    NPCInfo!.tempGoal!.waypoint = homeWp
    //Com_Printf("\nHeading for wp %d...\n", NPCInfo->homeWp);
}

/// Source: oracle/codemp/game/NPC_behavior.c:1160
func NPC_BSNoClip() {
    if UpdateGoal() != nil {
        var dir = vec3_t()
        var forward = vec3_t()
        var right = vec3_t()
        var angles = vec3_t()
        var up = vec3_t(0, 0, 1)
        let fDot: Float
        let rDot: Float
        let uDot: Float

        dir = NPCInfo!.goalEntity!.r.currentOrigin - NPC!.r.currentOrigin

        vectoangles(dir, &angles)
        NPCInfo!.desiredYaw = angles[YAW]

        var scratchUp = vec3_t()
        // Raven passes NULL for the up output.
        AngleVectors(NPC!.r.currentAngles, &forward, &right, &scratchUp)

        VectorNormalize(&dir)

        fDot = _DotProduct(forward, dir) * 127
        rDot = _DotProduct(right, dir) * 127
        uDot = _DotProduct(up, dir) * 127

        ucmd.forwardmove = Int32(floor(fDot))
        ucmd.rightmove = Int32(floor(rDot))
        ucmd.upmove = Int32(floor(uDot))
    } else {
        //Cut velocity?
        NPC!.client!.ps.velocity = vec3_t()
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_behavior.c:1193
func NPC_BSWander() {
    //FIXME: don't actually go all the way to the next waypoint, just move in fits and jerks...?
    if NPCInfo!.investigateDebounceTime == 0 {
        //Starting out
        var minGoalReachedDistSquared: Float = 64
        var vec = vec3_t()

        //Keep moving toward our tempGoal
        NPCInfo!.goalEntity = NPCInfo!.tempGoal

        vec = NPCInfo!.tempGoal!.r.currentOrigin - NPC!.r.currentOrigin

        if NPCInfo!.tempGoal!.waypoint != WAYPOINT_NONE {
            minGoalReachedDistSquared = 64
        }

        if VectorLengthSquared(vec) < minGoalReachedDistSquared {
            //Close enough, just got there
            NPC!.waypoint = NAV_FindClosestWaypointForEnt(NPC!, WAYPOINT_NONE)

            if Q_irand(0, 1) == 0 {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_GUARD_LOOKAROUND1, SETANIM_FLAG_NORMAL)
            } else {
                NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_GUARD_IDLE1, SETANIM_FLAG_NORMAL)
            }
            //Just got here, so Look around for a while
            NPCInfo!.investigateDebounceTime = level.time + Q_irand(3000, 10000)
        } else {
            //Keep moving toward goal
            NPC_MoveToGoal(true)
        }
    } else {
        //We're there
        if NPCInfo!.investigateDebounceTime > level.time {
            //Still waiting around for a bit
            //Turn angles every now and then to look around
            if NPCInfo!.tempGoal!.waypoint != WAYPOINT_NONE {
                if Q_irand(0, 30) == 0 {
                    let numEdges: Int32 = trap_Nav_GetNodeNumEdges(NPCInfo!.tempGoal!.waypoint)

                    if numEdges != WAYPOINT_NONE {
                        let branchNum: Int32 = Q_irand(0, numEdges - 1)

                        var branchPos = vec3_t()
                        var lookDir = vec3_t()

                        let nextWp: Int32 = trap_Nav_GetNodeEdge(NPCInfo!.tempGoal!.waypoint, branchNum)
                        trap_Nav_GetNodePosition(nextWp, &branchPos)

                        lookDir = branchPos - NPCInfo!.tempGoal!.r.currentOrigin
                        NPCInfo!.desiredYaw = AngleNormalize360(vectoyaw(lookDir) + flrand(-45, 45))
                    }
                }
            }
        } else {
            //Just finished waiting
            NPC!.waypoint = NAV_FindClosestWaypointForEnt(NPC!, WAYPOINT_NONE)

            if NPC!.waypoint != WAYPOINT_NONE {
                let numEdges: Int32 = trap_Nav_GetNodeNumEdges(NPC!.waypoint)

                if numEdges != WAYPOINT_NONE {
                    let branchNum: Int32 = Q_irand(0, numEdges - 1)

                    let nextWp: Int32 = trap_Nav_GetNodeEdge(NPC!.waypoint, branchNum)
                    trap_Nav_GetNodePosition(nextWp, &NPCInfo!.tempGoal!.r.currentOrigin)
                    NPCInfo!.tempGoal!.waypoint = nextWp
                }

                NPCInfo!.investigateDebounceTime = 0
                //Start moving toward our tempGoal
                NPCInfo!.goalEntity = NPCInfo!.tempGoal
                NPC_MoveToGoal(true)
            }
        }
    }

    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_behavior.c:1317
func NPC_Surrender() {
    //FIXME: say "don't shoot!" if we weren't already surrendering
    if NPC!.client!.ps.weaponTime != 0 || PM_InKnockDown(NPC!.client!.ps) {
        return
    }
    if NPC!.s.weapon != WP_NONE && NPC!.s.weapon != WP_STUN_BATON && NPC!.s.weapon != WP_SABER {
        //WP_DropWeapon( NPC, NULL ); //rwwFIXMEFIXME: Do this (gonna need a system for notifying client of removal)
    }
    if NPCInfo!.surrenderTime < level.time - 5000 {
        //haven't surrendered for at least 6 seconds, tell them what you're doing
        //FIXME: need real dialogue EV_SURRENDER
        NPCInfo!.blockedSpeechDebounceTime = 0 //make sure we say this
        G_AddVoiceEvent(NPC!, Q_irand(EV_PUSHED1, EV_PUSHED3), 3000)
    }
    //	NPC_SetAnim( NPC, SETANIM_TORSO, TORSO_SURRENDER_START, SETANIM_FLAG_HOLD|SETANIM_FLAG_OVERRIDE );
    //	NPC->client->ps.torsoTimer = 1000;
    NPCInfo!.surrenderTime = level.time + 1000 //stay surrendered for at least 1 second
    //FIXME: while surrendering, make a big sight/sound alert? Or G_AlertTeam?
}

/// Source: oracle/codemp/game/NPC_behavior.c:1341
func NPC_CheckSurrender() -> Bool {
    if !trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) && NPC!.client!.ps.groundEntityNum != ENTITYNUM_NONE && NPC!.client!.ps.weaponTime == 0 && !PM_InKnockDown(NPC!.client!.ps) && NPC!.enemy != nil && NPC!.enemy!.client != nil && NPC!.enemy!.enemy == NPC && NPC!.enemy!.s.weapon != WP_NONE && NPC!.enemy!.s.weapon != WP_STUN_BATON && NPC!.enemy!.health > 20 && NPC!.enemy!.painDebounceTime < level.time - 3000 && NPC!.enemy!.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] < level.time - 1000 {
        //don't surrender if scripted to run somewhere or if we're in the air or if we're busy or if we don't have an enemy or if the enemy is not mad at me or is hurt or not a threat or busy being attacked
        //FIXME: even if not in a group, don't surrender if there are other enemies in the PVS and within a certain range?
        if NPC!.s.weapon != WP_ROCKET_LAUNCHER && NPC!.s.weapon != WP_REPEATER && NPC!.s.weapon != WP_FLECHETTE && NPC!.s.weapon != WP_SABER {
            //jedi and heavy weapons guys never surrender
            //FIXME: rework all this logic into some orderly fashion!!!
            if NPC!.s.weapon != WP_NONE {
                //they have a weapon so they'd have to drop it to surrender
                //don't give up unless low on health
                if NPC!.health > 25 {
                    //rwwFIXMEFIXME: Keep max health not a ps state?
                    return false
                }
                //if ( g_crosshairEntNum == NPC->s.number && NPC->painDebounceTime > level.time )
                if NPC_SomeoneLookingAtMe(NPC!) && NPC!.painDebounceTime > level.time {
                    //if he just shot me, always give up
                    //fall through
                } else {
                    //don't give up unless facing enemy and he's very close
                    if !InFOV(NPC!.enemy!, NPC!, 60, 30) {
                        //I'm not looking at them
                        return false
                    } else if DistanceSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin) < 65536 {
                        //they're not close
                        return false
                    } else if !trap_InPVS(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin) {
                        //they're not in the same room
                        return false
                    }
                }
            }
            //fixme: this logic keeps making npc's randomly surrender
            /*
            if ( NPCInfo->group && NPCInfo->group->numGroup <= 1 )
            {//I'm alone but I was in a group//FIXME: surrender anyway if just melee or no weap?
            if ( NPC->s.weapon == WP_NONE
            //NPC has a weapon
            || (NPC->enemy && NPC->enemy->s.number < MAX_CLIENTS)
            || (NPC->enemy->s.weapon == WP_SABER&&NPC->enemy->client&&!NPC->enemy->client->ps.saberHolstered)
            || (NPC->enemy->NPC && NPC->enemy->NPC->group && NPC->enemy->NPC->group->numGroup > 2) )
            {//surrender only if have no weapon or fighting a player or jedi or if we are outnumbered at least 3 to 1
            if ( (NPC->enemy && NPC->enemy->s.number < MAX_CLIENTS) )
            {//player is the guy I'm running from
            //if ( g_crosshairEntNum == NPC->s.number )
            if (NPC_SomeoneLookingAtMe(NPC))
            {//give up if player is aiming at me
            NPC_Surrender();
            NPC_UpdateAngles( qtrue, qtrue );
            return qtrue;
            }
            else if ( NPC->enemy->s.weapon == WP_SABER )
            {//player is using saber
            if ( InFOV( NPC, NPC->enemy, 60, 30 ) )
            {//they're looking at me
            if ( DistanceSquared( NPC->r.currentOrigin, NPC->enemy->r.currentOrigin ) < 16384 )
            {//they're close
            if ( trap_InPVS( NPC->r.currentOrigin, NPC->enemy->r.currentOrigin ) )
            {//they're in the same room
            NPC_Surrender();
            NPC_UpdateAngles( qtrue, qtrue );
            return qtrue;
            }
            }
            }
            }
            }
            else if ( NPC->enemy )
            {//???
            //should NPC's surrender to others?
            if ( InFOV( NPC, NPC->enemy, 30, 30 ) )
            {//they're looking at me
            if ( DistanceSquared( NPC->r.currentOrigin, NPC->enemy->r.currentOrigin ) < 4096 )
            {//they're close
            if ( trap_InPVS( NPC->r.currentOrigin, NPC->enemy->r.currentOrigin ) )
            {//they're in the same room
            //FIXME: should player-team NPCs not fire on surrendered NPCs?
            NPC_Surrender();
            NPC_UpdateAngles( qtrue, qtrue );
            return qtrue;
            }
            }
            }
            }
            }
            }
            */
        }
    }
    return false
}

/// Source: oracle/codemp/game/NPC_behavior.c:1444
func NPC_BSFlee() {
    //FIXME: keep checking for danger
    var goal: Entity?

    if TIMER_Done(NPC!, "flee") && NPCInfo!.tempBehavior == BS_FLEE {
        NPCInfo!.tempBehavior = BS_DEFAULT
        NPCInfo!.squadState = SQUAD_IDLE
        //FIXME: should we set some timer to make him stay in this spot for a bit,
        //so he doesn't just suddenly turn around and come back at the enemy?
        //OR, just stop running toward goal for last second or so of flee?
    }
    if NPC_CheckSurrender() {
        return
    }
    goal = NPCInfo!.goalEntity
    if goal == nil {
        goal = NPCInfo!.lastGoalEntity
        if goal == nil {
            //???!!!
            goal = NPCInfo!.tempGoal
        }
    }

    if goal != nil {
        let moved: Bool
        var reverseCourse: Bool = true

        //FIXME: if no weapon, find one and run to pick it up?

        //Let's try to find a waypoint that gets me away from this thing
        if NPC!.waypoint == WAYPOINT_NONE {
            NPC!.waypoint = NAV_GetNearestNode(NPC!, NPC!.lastWaypoint)
        }
        if NPC!.waypoint != WAYPOINT_NONE {
            let numEdges: Int32 = trap_Nav_GetNodeNumEdges(NPC!.waypoint)

            if numEdges != WAYPOINT_NONE {
                var dangerDir = vec3_t()
                var nextWp: Int32
                var branchNum: Int32

                dangerDir = NPCInfo!.investigateGoal - NPC!.r.currentOrigin
                VectorNormalize(&dangerDir)

                branchNum = 0
                while branchNum < numEdges {
                    var branchPos = vec3_t()
                    var runDir = vec3_t()

                    nextWp = trap_Nav_GetNodeEdge(NPC!.waypoint, branchNum)
                    trap_Nav_GetNodePosition(nextWp, &branchPos)

                    runDir = branchPos - NPC!.r.currentOrigin
                    VectorNormalize(&runDir)
                    if _DotProduct(runDir, dangerDir) > flrand(0, 0.5) {
                        //don't run toward danger
                        branchNum += 1
                        continue
                    }
                    //FIXME: don't want to ping-pong back and forth
                    NPC_SetMoveGoal(NPC!, branchPos, 0, true, -1, nil)
                    reverseCourse = false
                    break
                    branchNum += 1
                }
            }
        }

        moved = NPC_MoveToGoal(false) //qtrue? (do try to move straight to (away from) goal)

        if NPC!.s.weapon == WP_NONE && (moved == false || reverseCourse) {
            //No weapon and no escape route... Just cower?  Need anim.
            NPC_Surrender()
            NPC_UpdateAngles(true, true)
            return
        }
        //If our move failed, then just run straight away from our goal
        //FIXME: We really shouldn't do this.
        if moved == false {
            var dir = vec3_t()
            let dist: Float
            if reverseCourse {
                dir = NPC!.r.currentOrigin - goal!.r.currentOrigin
            } else {
                dir = goal!.r.currentOrigin - NPC!.r.currentOrigin
            }
            dist = VectorNormalize(&dir)
            NPCInfo!.distToGoal = dist
            NPCInfo!.desiredYaw = vectoyaw(dir)
            NPCInfo!.desiredPitch = 0
            ucmd.forwardmove = 127
        } else if reverseCourse {
            //ucmd.forwardmove *= -1;
            //ucmd.rightmove *= -1;
            //VectorScale( NPC->client->ps.moveDir, -1, NPC->client->ps.moveDir );
            NPCInfo!.desiredYaw *= -1
        }
        //FIXME: can stop after a safe distance?
        //ucmd.upmove = 0;
        ucmd.buttons &= ~BUTTON_WALKING
        //FIXME: what do we do once we've gotten to our goal?
    }
    NPC_UpdateAngles(true, true)

    NPC_CheckGetNewWeapon()
}

/// Source: oracle/codemp/game/NPC_behavior.c:1560
func NPC_StartFlee(_ enemy: Entity, _ dangerPoint: JKAShared.vec3_t, _ dangerLevel: Int32, _ fleeTimeMin: Int32, _ fleeTimeMax: Int32) {
    var cp: Int32 = -1

    if trap_ICARUS_TaskIDPending(NPC!, TID_MOVE_NAV) {
        //running somewhere that a script requires us to go, don't interrupt that!
        return
    }

    //if have a fleescript, run that instead
    if G_ActivateBehavior(NPC!, BSET_FLEE) {
        return
    }
    //FIXME: play a flee sound?  Appropriate to situation?
    G_SetEnemy(NPC!, enemy)

    //FIXME: if don't have a weapon, find nearest one we have a route to and run for it?
    if dangerLevel > AEL_DANGER || NPC!.s.weapon == WP_NONE || ((NPCInfo!.group == nil || NPCInfo!.group!.numGroup <= 1) && NPC!.health <= 10) {
        //IF either great danger OR I have no weapon OR I'm alone and low on health, THEN try to find a combat point out of PVS
        cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, dangerPoint, CP_COVER | CP_AVOID | CP_HAS_ROUTE | CP_NO_PVS, 128, -1)
    }
    //FIXME: still happens too often...
    if cp == -1 {
        //okay give up on the no PVS thing
        cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, dangerPoint, CP_COVER | CP_AVOID | CP_HAS_ROUTE, 128, -1)
        if cp == -1 {
            //okay give up on the avoid
            cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, dangerPoint, CP_COVER | CP_HAS_ROUTE, 128, -1)
            if cp == -1 {
                //okay give up on the cover
                cp = NPC_FindCombatPoint(NPC!.r.currentOrigin, NPC!.r.currentOrigin, dangerPoint, CP_HAS_ROUTE, 128, -1)
            }
        }
    }

    //see if we got a valid one
    if cp != -1 {
        //found a combat point
        NPC_SetCombatPoint(cp)
        NPC_SetMoveGoal(NPC!, level.combatPoints[cp].origin, 8, true, cp, nil)
        NPCInfo!.behaviorState = BS_HUNT_AND_KILL
        NPCInfo!.tempBehavior = BS_DEFAULT
    } else {
        //need to just run like hell!
        if NPC!.s.weapon != WP_NONE {
            return //let's just not flee?
        } else {
            //FIXME: other evasion AI?  Duck?  Strafe?  Dodge?
            NPCInfo!.tempBehavior = BS_FLEE
            //Run straight away from here... FIXME: really want to find farthest waypoint/navgoal from this pos... maybe based on alert event radius?
            NPC_SetMoveGoal(NPC!, dangerPoint, 0, true, -1, nil)
            //store the danger point
            NPCInfo!.investigateGoal = dangerPoint //FIXME: make a new field for this?
        }
    }
    //FIXME: localize this Timer?
    TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
    //FIXME: is this always applicable?
    NPCInfo!.squadState = SQUAD_RETREAT
    TIMER_Set(NPC!, "flee", Q_irand(fleeTimeMin, fleeTimeMax))
    TIMER_Set(NPC!, "panic", Q_irand(1000, 4000)) //how long to wait before trying to nav to a dropped weapon

    if NPC!.client!.NPC_class != CLASS_PROTOCOL {
        TIMER_Set(NPC!, "duck", 0)
    }
}

/// Source: oracle/codemp/game/NPC_behavior.c:1636
func G_StartFlee(_ `self`: Entity, _ enemy: Entity, _ dangerPoint: JKAShared.vec3_t, _ dangerLevel: Int32, _ fleeTimeMin: Int32, _ fleeTimeMax: Int32) {
    if `self`.NPC == nil {
        //player
        return
    }
    SaveNPCGlobals()
    SetNPCGlobals(`self`)

    NPC_StartFlee(enemy, dangerPoint, dangerLevel, fleeTimeMin, fleeTimeMax)

    RestoreNPCGlobals()
}

/// Source: oracle/codemp/game/NPC_behavior.c:1650
func NPC_BSEmplaced() {
    var enemyLOS: Bool = false
    var enemyCS: Bool = false
    var faceEnemy: Bool = false
    var shoot: Bool = false
    var impactPos = vec3_t()

    //Don't do anything if we're hurt
    if NPC!.painDebounceTime > level.time {
        NPC_UpdateAngles(true, true)
        return
    }

    if (NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0 {
        WeaponThink(true)
    }

    //If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        if Q_irand(0, 30) == 0 {
            NPCInfo!.desiredYaw = NPC!.s.angles[1] + Q_irand(-90, 90)
        }
        if Q_irand(0, 30) == 0 {
            NPCInfo!.desiredPitch = Float(Q_irand(-20, 20))
        }
        NPC_UpdateAngles(true, true)
        return
    }

    if NPC_ClearLOS4(NPC!.enemy!) {
        let hit: Int32
        var hitEnt: Entity?

        enemyLOS = true

        hit = NPC_ShotEntity(NPC!.enemy!, &impactPos)
        hitEnt = g_entities[hit]

        if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.takedamage) {
            //can hit enemy or will hit glass or other minor breakable (or in emplaced gun), so shoot anyway
            enemyCS = true
            NPC_AimAdjust(2) //adjust aim better longer we have clear shot at enemy
            NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
        }
    }
    /*
    else if ( trap_InPVS( NPC->enemy->r.currentOrigin, NPC->r.currentOrigin ) )
    {
    NPCInfo->enemyLastSeenTime = level.time;
    faceEnemy = qtrue;
    NPC_AimAdjust( -1 );//adjust aim worse longer we cannot see enemy
    }
    */

    if enemyLOS {
        //FIXME: no need to face enemy if we're moving to some other goal and he's too far away to shoot?
        faceEnemy = true
    }
    if enemyCS {
        shoot = true
    }

    if faceEnemy {
        //face the enemy
        NPC_FaceEnemy(true)
    } else {
        //we want to face in the dir we're running
        NPC_UpdateAngles(true, true)
    }

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        shoot = false
    }

    if NPC!.enemy != nil && NPC!.enemy!.enemy != nil {
        if NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.enemy!.s.weapon == WP_SABER {
            //don't shoot at an enemy jedi who is fighting another jedi, for fear of injuring one or causing rogue blaster deflections (a la Obi Wan/Vader duel at end of ANH)
            shoot = false
        }
    }
    if shoot {
        //try to shoot if it's time
        if !((NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0) {
            WeaponThink(true)
        }
    }
}
