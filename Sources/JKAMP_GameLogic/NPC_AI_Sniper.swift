import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:37
private let LSTATE_NONE: Int32 = 0
private let LSTATE_UNDERFIRE: Int32 = 1
private let LSTATE_INVESTIGATE: Int32 = 2

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:11
let SPF_NO_HIDE = 2 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:13
private let MAX_VIEW_DIST = 1024 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:14
private let MAX_VIEW_SPEED = 250 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:15
private let MAX_LIGHT_INTENSITY = 255 as Int32

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:16
private let MIN_LIGHT_THRESHOLD = 0.1 as Double

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:18
private let DISTANCE_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:19
private let DISTANCE_THRESHOLD = 0.075 as Float

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:20
private let SPEED_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:21
private let FOV_SCALE = 0.5 as Float

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:22
private let LIGHT_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:24
private let REALIZE_THRESHOLD = 0.6 as Float

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:25
private let CAUTIOUS_THRESHOLD = (REALIZE_THRESHOLD * 0.75)

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:29
var enemyLOS2: Bool {
    get { world.variables.enemyLOS2 }
    set { world.variables.enemyLOS2 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:30
var enemyCS2: Bool {
    get { world.variables.enemyCS2 }
    set { world.variables.enemyCS2 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:31
var faceEnemy2: Bool {
    get { world.variables.faceEnemy2 }
    set { world.variables.faceEnemy2 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:32
var move2: Bool {
    get { world.variables.move2 }
    set { world.variables.move2 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:33
var shoot2: Bool {
    get { world.variables.shoot2 }
    set { world.variables.shoot2 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:34
var enemyDist2: Float {
    get { world.variables.enemyDist2 }
    set { world.variables.enemyDist2 = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:44
func Sniper_ClearTimers(_ ent: Entity) {
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

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:60
func NPC_Sniper_PlayConfusionSound(_ `self`: Entity) {
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

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:85
func NPC_Sniper_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    `self`.NPC!.localState = LSTATE_UNDERFIRE

    TIMER_Set(`self`, "duck", -1)
    TIMER_Set(`self`, "stand", 2000)

    NPC_Pain(`self`, attacker, damage)

    if damage == 0 && `self`.health > 0 {
        //FIXME: better way to know I was pushed
        G_AddVoiceEvent(`self`, Q_irand(EV_PUSHED1, EV_PUSHED3), 2000)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:106
private func Sniper_HoldPosition() {
    NPC_FreeCombatPoint(NPCInfo!.combatPoint, true)
    NPCInfo!.goalEntity = nil

    /*if ( TIMER_Done( NPC, "stand" ) )
    {//FIXME: what if can't shoot from this pos?
    TIMER_Set( NPC, "duck", Q_irand( 2000, 4000 ) );
    }
    */
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:124
private func Sniper_Move() -> Bool {
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
                Sniper_HoldPosition()
            }
        }

        //If our move failed, then reset
        if moved == false {
            //couldn't get to enemy
            if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 && NPCInfo!.goalEntity != nil && NPCInfo!.goalEntity == NPC!.enemy {
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
            Sniper_HoldPosition()
        }

        return moved
    }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:185
func NPC_BSSniper_Patrol() {
    //FIXME: pick up on bodies of dead buddies?
    NPC!.count = 0

    if NPCInfo!.confusionTime < level.time {
        //Look for any enemies
        if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            if NPC_CheckPlayerTeamStealth() {
                //NPCInfo->behaviorState = BS_HUNT_AND_KILL;//Should be auto now
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
                            TIMER_Set(NPC!, "attackDelay", Q_irand((6 - NPCInfo!.stats.aim) * 100, (6 - NPCInfo!.stats.aim) * 500))
                        }
                    } else {
                        //FIXME: get more suspicious over time?
                        //Save the position for movement (if necessary)
                        //FIXME: sound?
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
                //FIXME: walk over to it, maybe?  Not if not chase enemies flag
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

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:308
private func Sniper_CheckMoveState() {
    //See if we're a scout
    if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
        if NPCInfo!.goalEntity == NPC!.enemy {
            move2 = false
            return
        }
    } else if NPCInfo!.squadState == SQUAD_RETREAT {
        //See if we're running away
        if TIMER_Done(NPC!, "flee") {
            NPCInfo!.squadState = SQUAD_IDLE
        } else {
            faceEnemy2 = false
        }
    } else if NPCInfo!.squadState == SQUAD_IDLE {
        if NPCInfo!.goalEntity == nil {
            move2 = false
            return
        }
    }

    //See if we're moving towards a goal, not the enemy
    if (NPCInfo!.goalEntity != NPC!.enemy) && (NPCInfo!.goalEntity != nil) {
        //Did we make it?
        if NAV_HitNavGoal(NPC!.r.currentOrigin, NPC!.r.mins, NPC!.r.maxs, NPCInfo!.goalEntity!.r.currentOrigin, 16, FlyingCreature(NPC!)) || (NPCInfo!.squadState == SQUAD_SCOUT && enemyLOS2 && enemyDist2 <= 10000) {
            var newSquadState: Int32 = SQUAD_STAND_AND_SHOOT
            //we got where we wanted to go, set timers based on why we were running
            switch NPCInfo!.squadState {
            case SQUAD_RETREAT:
                TIMER_Set(NPC!, "duck", (NPC!.client!.pers.maxHealth - NPC!.health) * 100)
                TIMER_Set(NPC!, "hideTime", Q_irand(3000, 7000))
                newSquadState = SQUAD_COVER

            case SQUAD_TRANSITION:
                TIMER_Set(NPC!, "hideTime", Q_irand(2000, 4000))

            case SQUAD_SCOUT:
                break

            default:
                break
            }
            NPC_ReachedGoal()
            //don't attack right away
            TIMER_Set(NPC!, "attackDelay", Q_irand((6 - NPCInfo!.stats.aim) * 50, (6 - NPCInfo!.stats.aim) * 100)) //FIXME: Slant for difficulty levels, too?
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
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:383
private func Sniper_ResolveBlockedShot() {
    if TIMER_Done(NPC!, "duck") {
        //we're not ducking
        if TIMER_Done(NPC!, "roamTime") {
            //not roaming
            //FIXME: try to find another spot from which to hit the enemy
            if (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 && (NPCInfo!.goalEntity == nil || NPCInfo!.goalEntity == NPC!.enemy) {
                //we were running after enemy
                //Try to find a combat point that can hit the enemy
                var cpFlags: Int32 = (CP_CLEAR | CP_HAS_ROUTE)
                var cp: Int32

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
                    TIMER_Set(NPC!, "duck", -1)
                    TIMER_Set(NPC!, "attackDelay", Q_irand(1000, 3000))
                    return
                }
            }
        }
    }
    /*
    else
    {//maybe we should stand
    if ( TIMER_Done( NPC, "stand" ) )
    {//stand for as long as we'll be here
    TIMER_Set( NPC, "stand", Q_irand( 500, 2000 ) );
    return;
    }
    }
    //Hmm, can't resolve this by telling them to duck or telling me to stand
    //We need to move!
    TIMER_Set( NPC, "roamTime", -1 );
    TIMER_Set( NPC, "stick", -1 );
    TIMER_Set( NPC, "duck", -1 );
    TIMER_Set( NPC, "attackDelay", Q_irand( 1000, 3000 ) );
    */
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:442
private func Sniper_CheckFireState() {
    if enemyCS2 {
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
    if Q_irand(0, 1) == 0 && NPCInfo!.enemyLastSeenTime != 0 && level.time - NPCInfo!.enemyLastSeenTime < ((5 - NPCInfo!.stats.aim) * 1000) {
        if VectorCompare(vec3_origin, NPCInfo!.enemyLastSeenLocation) == 0 {
            //Fire on the last known position
            var muzzle = vec3_t()
            var dir = vec3_t()
            var angles = vec3_t()

            CalcEntitySpot(NPC!, SPOT_WEAPON, &muzzle)
            dir = NPCInfo!.enemyLastSeenLocation - muzzle

            VectorNormalize(&dir)

            vectoangles(dir, &angles)

            NPCInfo!.desiredYaw = angles[YAW]
            NPCInfo!.desiredPitch = angles[PITCH]

            shoot2 = true
            //faceEnemy2 = qfalse;
        }
        return
    } else if level.time - NPCInfo!.enemyLastSeenTime > 10000 {
        //next time we see him, we'll miss few times first
        NPC!.count = 0
    }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:488
func Sniper_EvaluateShot(_ hit: Int32) -> Bool {
    var hitEnt: Entity?

    if NPC!.enemy == nil {
        return false
    }

    hitEnt = g_entities[hit]
    if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.enemyTeam) || (hitEnt != nil && hitEnt!.takedamage && ((hitEnt!.r.svFlags & SVF_GLASS_BRUSH) != 0 || hitEnt!.health < 40 || NPC!.s.weapon == WP_EMPLACED_GUN)) || (hitEnt != nil && (hitEnt!.r.svFlags & SVF_GLASS_BRUSH) != 0) {
        //can hit enemy or will hit glass, so shoot anyway
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:508
func Sniper_FaceEnemy() {
    //FIXME: the ones behind kill holes are facing some arbitrary direction and not firing
    //FIXME: If actually trying to hit enemy, don't fire unless enemy is at least in front of me?
    //FIXME: need to give designers option to make them not miss first few shots
    if NPC!.enemy != nil {
        var muzzle = vec3_t()
        var target = vec3_t()
        var angles = vec3_t()
        var forward = vec3_t()
        var right = vec3_t()
        var up = vec3_t()
        //Get the positions
        AngleVectors(NPC!.client!.ps.viewangles, &forward, &right, &up)
        CalcMuzzlePoint(NPC!, forward, right, up, &muzzle)
        //CalcEntitySpot( NPC, SPOT_WEAPON, muzzle );
        CalcEntitySpot(NPC!.enemy!, SPOT_ORIGIN, &target)

        if enemyDist2 > 65536 && NPCInfo!.stats.aim < 5 {
            if NPC!.count < (5 - NPCInfo!.stats.aim) {
                //miss a few times first
                if shoot2 && TIMER_Done(NPC!, "attackDelay") && level.time >= NPCInfo!.shotTime {
                    //ready to fire again
                    var aimError: Bool = false
                    var hit: Bool = true
                    var tryMissCount: Int32 = 0
                    // Raven's record lives to the end of his block, so the block is the closure.
                    Trace.scratch { trace in

                        GetAnglesForDirection(muzzle, target, &angles)
                        AngleVectors(angles, &forward, &right, &up)

                        while hit && tryMissCount < 10 {
                            tryMissCount += 1
                            if Q_irand(0, 1) == 0 {
                                aimError = true
                                if Q_irand(0, 1) == 0 {
                                    _VectorMA(target, NPC!.enemy!.r.maxs[2] * flrand(1.5, 4), right, &target)
                                } else {
                                    _VectorMA(target, NPC!.enemy!.r.mins[2] * flrand(1.5, 4), right, &target)
                                }
                            }
                            if !aimError || Q_irand(0, 1) == 0 {
                                if Q_irand(0, 1) == 0 {
                                    _VectorMA(target, NPC!.enemy!.r.maxs[2] * flrand(1.5, 4), up, &target)
                                } else {
                                    _VectorMA(target, NPC!.enemy!.r.mins[2] * flrand(1.5, 4), up, &target)
                                }
                            }
                            trap_Trace(trace, muzzle, vec3_origin, vec3_origin, target, NPC!.s.number, MASK_SHOT)
                            hit = Sniper_EvaluateShot(trace.entityNum)
                        }
                        NPC!.count += 1
                    }
                } else {
                    if !enemyLOS2 {
                        NPC_UpdateAngles(true, true)
                        return
                    }
                }
            } else {
                //based on distance, aim value, difficulty and enemy movement, miss
                //FIXME: incorporate distance as a factor?
                var missFactor: Int32 = 8 - (NPCInfo!.stats.aim + g_spskill.integer) * 3
                if missFactor > ENEMY_POS_LAG_STEPS {
                    missFactor = ENEMY_POS_LAG_STEPS
                } else if missFactor < 0 {
                    //???
                    missFactor = 0
                }
                target = NPCInfo!.enemyLaggedPos[missFactor]
            }
            GetAnglesForDirection(muzzle, target, &angles)
        } else {
            target[2] += flrand(0, NPC!.enemy!.r.maxs[2])
            //CalcEntitySpot( NPC->enemy, SPOT_HEAD_LEAN, target );
            GetAnglesForDirection(muzzle, target, &angles)
        }

        NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
        NPCInfo!.desiredPitch = AngleNormalize360(angles[PITCH])
    }
    NPC_UpdateAngles(true, true)
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:605
func Sniper_UpdateEnemyPos() {
    var index: Int32
    var i: Int32

    i = MAX_ENEMY_POS_LAG - ENEMY_POS_LAG_INTERVAL
    while i >= 0 {
        index = i / ENEMY_POS_LAG_INTERVAL
        if index == 0 {
            CalcEntitySpot(NPC!.enemy!, SPOT_HEAD_LEAN, &NPCInfo!.enemyLaggedPos[index])
            NPCInfo!.enemyLaggedPos[index][2] -= flrand(2, 16)
        } else {
            NPCInfo!.enemyLaggedPos[index] = NPCInfo!.enemyLaggedPos[index - 1]
        }
        i -= ENEMY_POS_LAG_INTERVAL
    }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:631
func Sniper_StartHide() {
    let duckTime: Int32 = Q_irand(2000, 5000)

    TIMER_Set(NPC!, "duck", duckTime)
    TIMER_Set(NPC!, "watch", 500)
    TIMER_Set(NPC!, "attackDelay", duckTime + Q_irand(500, 2000))
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:640
func NPC_BSSniper_Attack() {
    //Don't do anything if we're hurt
    if NPC!.painDebounceTime > level.time {
        NPC_UpdateAngles(true, true)
        return
    }

    //NPC_CheckEnemy( qtrue, qfalse );
    //If we don't have an enemy, just idle
    if NPC_CheckEnemyExt(false) == false {
        NPC!.enemy = nil
        NPC_BSSniper_Patrol() //FIXME: or patrol?
        return
    }

    if TIMER_Done(NPC!, "flee") && NPC_CheckForDanger(NPC_CheckAlertEvents(true, true, -1, false, AEL_DANGER)) {
        //going to run
        NPC_UpdateAngles(true, true)
        return
    }

    if NPC!.enemy == nil {
        //WTF?  somehow we lost our enemy?
        NPC_BSSniper_Patrol() //FIXME: or patrol?
        return
    }

    enemyCS2 = false
    enemyLOS2 = enemyCS2
    move2 = true
    faceEnemy2 = false
    shoot2 = false
    enemyDist2 = DistanceSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)
    if enemyDist2 < 16384 {
        //too close, so switch to primary fire
        if NPC!.client!.ps.weapon == WP_DISRUPTOR {
            //sniping... should be assumed
            if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                //use primary fire
                // Raven's record lives to the end of his block, so the block is the closure.
                // The closure gives true where Raven returns from the function.
                let earlyOut = Trace.scratch { trace -> Bool in
                    trap_Trace(trace, NPC!.enemy!.r.currentOrigin, NPC!.enemy!.r.mins, NPC!.enemy!.r.maxs, NPC!.r.currentOrigin, NPC!.enemy!.s.number, NPC!.enemy!.clipmask)
                    if trace.allsolid == 0 && trace.startsolid == 0 && (Double(trace.fraction) == 1.0 || trace.entityNum == NPC!.s.number) {
                        //he can get right to me
                        NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
                        //reset fire-timing variables
                        NPC_ChangeWeapon(WP_DISRUPTOR)
                        NPC_UpdateAngles(true, true)
                        return true
                    }
                    return false
                }
                if earlyOut {
                    return
                }
            }
            //FIXME: switch back if he gets far away again?
        }
    } else if enemyDist2 > 65536 {
        if NPC!.client!.ps.weapon == WP_DISRUPTOR {
            //sniping... should be assumed
            if !((NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0) {
                //use primary fire
                NPCInfo!.scriptFlags |= SCF_ALT_FIRE
                //reset fire-timing variables
                NPC_ChangeWeapon(WP_DISRUPTOR)
                NPC_UpdateAngles(true, true)
                return
            }
        }
    }

    Sniper_UpdateEnemyPos()
    //can we see our target?
    if NPC_ClearLOS4(NPC!.enemy!) {
        var maxShootDist: Float = 0

        NPCInfo!.enemyLastSeenTime = level.time
        NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
        enemyLOS2 = true
        maxShootDist = NPC_MaxDistSquaredForWeapon()
        if enemyDist2 < maxShootDist {
            var fwd = vec3_t()
            var right = vec3_t()
            var up = vec3_t()
            var muzzle = vec3_t()
            var end = vec3_t()
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in
                var hit: Int32 = 0

                AngleVectors(NPC!.client!.ps.viewangles, &fwd, &right, &up)
                CalcMuzzlePoint(NPC!, fwd, right, up, &muzzle)
                _VectorMA(muzzle, 8192, fwd, &end)
                trap_Trace(tr, muzzle, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SHOT)

                hit = tr.entityNum
                //can we shoot our target?
                if Sniper_EvaluateShot(hit) {
                    enemyCS2 = true
                }
            }
        }
    }
    /*
    else if ( gi.inPVS( NPC->enemy->currentOrigin, NPC->currentOrigin ) )
    {
    NPCInfo->enemyLastSeenTime = level.time;
    faceEnemy2 = qtrue;
    }
    */

    if enemyLOS2 {
        //FIXME: no need to face enemy if we're moving to some other goal and he's too far away to shoot?
        faceEnemy2 = true
    }
    if enemyCS2 {
        shoot2 = true
    } else if level.time - NPCInfo!.enemyLastSeenTime > 3000 {
        //Hmm, have to get around this bastard... FIXME: this NPCInfo->enemyLastSeenTime builds up when ducked seems to make them want to run when they uncrouch
        Sniper_ResolveBlockedShot()
    }

    //Check for movement to take care of
    Sniper_CheckMoveState()

    //See if we should override shooting decision with any special considerations
    Sniper_CheckFireState()

    if move2 {
        //move toward goal
        if NPCInfo!.goalEntity != nil {
            move2 = Sniper_Move()
        } else {
            move2 = false
        }
    }

    if !move2 {
        if !TIMER_Done(NPC!, "duck") {
            if TIMER_Done(NPC!, "watch") {
                //not while watching
                ucmd.upmove = -127
            }
        }
        //FIXME: what about leaning?
        //FIXME: also, when stop ducking, start looking, if enemy can see me, chance of ducking back down again
    } else {
        //stop ducking!
        TIMER_Set(NPC!, "duck", -1)
    }

    if TIMER_Done(NPC!, "duck") && TIMER_Done(NPC!, "watch") && (TIMER_Get(NPC!, "attackDelay") - level.time) > 1000 && NPC!.attackDebounceTime < level.time {
        if enemyLOS2 && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
            if NPC!.fly_sound_debounce_time < level.time {
                NPC!.fly_sound_debounce_time = level.time + 2000
            }
        }
    }

    if !faceEnemy2 {
        //we want to face in the dir we're running
        if move2 {
            //don't run away and shoot
            NPCInfo!.desiredYaw = NPCInfo!.lastPathAngles[YAW]
            NPCInfo!.desiredPitch = 0
            shoot2 = false
        }
        NPC_UpdateAngles(true, true)
    } else {
        //face the enemy
        Sniper_FaceEnemy()
    }

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        shoot2 = false
    }

    //FIXME: don't shoot right away!
    if shoot2 {
        //try to shoot if it's time
        if TIMER_Done(NPC!, "attackDelay") {
            WeaponThink(true)
            if (ucmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0 {
                G_SoundOnEnt(NPC!, CHAN_WEAPON, "sound/null.wav")
            }

            //took a shot, now hide
            if !((NPC!.spawnflags & SPF_NO_HIDE) != 0) && Q_irand(0, 1) == 0 {
                //FIXME: do this if in combat point and combat point has duck-type cover... also handle lean-type cover
                Sniper_StartHide()
            } else {
                TIMER_Set(NPC!, "attackDelay", NPCInfo!.shotTime - level.time)
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Sniper.c:854
func NPC_BSSniper_Default() {
    if NPC!.enemy == nil {
        //don't have an enemy, look for one
        NPC_BSSniper_Patrol()
    } else {
        //have an enemy
        NPC_BSSniper_Attack()
    }
}
