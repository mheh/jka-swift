import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_navnew.c:15
func NAV_CheckNodeFailedForEnt(_ ent: Entity, _ nodeNum: Int32) -> Bool {
    var j: Int32

    //FIXME: must be a better way to do this
    j = 0
    while j < MAX_FAILED_NODES {
        if ent.failedWaypoints[j] == nodeNum + 1 {
            //we failed against this node
            return true
        }
        j += 1
    }
    return false
}

/**
```
-------------------------
NPC_UnBlocked
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:34
func NPC_ClearBlocked(_ `self`: Entity) {
    if `self`.NPC == nil {
        return
    }

    //self->NPC->aiFlags &= ~NPCAI_BLOCKED;
    `self`.NPC!.blockingEntNum = ENTITYNUM_NONE
}

/// Source: oracle/codemp/game/g_navnew.c:43
func NPC_SetBlocked(_ `self`: Entity, _ blocker: Entity) {
    if `self`.NPC == nil {
        return
    }

    //self->NPC->aiFlags |= NPCAI_BLOCKED;
    // The SDK also declares `random`, so the call names the bg module.
    `self`.NPC!.blockedSpeechDebounceTime = Int32(level.time + MIN_BLOCKED_SPEECH_TIME + (JKAMP_BG.random() * 4000))
    `self`.NPC!.blockingEntNum = blocker.s.number
}

/**
```
-------------------------
NAVNEW_ClearPathBetweenPoints
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:58
func NAVNEW_ClearPathBetweenPoints(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ ignore: Int32, _ clipmask: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Int32 in

        //Test if they're even conceivably close to one another
        if !trap_InPVS(start, end) {
            return ENTITYNUM_WORLD
        }

        trap_Trace(trace, start, mins, maxs, end, ignore, clipmask)

        //if( ( ( trace.startsolid == false ) && ( trace.allsolid == false ) ) && ( trace.fraction < 1.0f ) )
        //{//FIXME: check for drops?
        //FIXME: if startsolid or allsolid, then the path isn't clear... but returning ENTITYNUM_NONE indicates to CheckFailedEdge that is is clear...?
        return trace.entityNum
        //}

        //return ENTITYNUM_NONE;
    }
}

/**
```
-------------------------
NAVNEW_PushBlocker
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:84
func NAVNEW_PushBlocker(_ `self`: Entity, _ blocker: Entity, _ right: JKAShared.vec3_t, _ setBlockedInfo: Bool) {
    //try pushing blocker to one side
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in
        var mins = vec3_t()
        var end = vec3_t()
        var rightSucc: Float = 0
        var leftSucc: Float = 0
        var moveamt: Float = 0

        if `self`.NPC!.shoveCount > 30 {
            //don't push for more than 3 seconds;
            return true
        }

        if blocker.s.number == 0 {
            //never push the player
            return true
        }

        if blocker.client == nil || VectorCompare(blocker.client!.pushVec, vec3_origin) == 0 {
            //someone else is pushing him, wait until they give up?
            return true
        }

        mins = blocker.r.mins
        mins[2] += STEPSIZE

        moveamt = Float(Double(`self`.r.maxs[1] + blocker.r.maxs[1]) * 1.2) //yes, magic number

        _VectorMA(blocker.r.currentOrigin, -moveamt, right, &end)
        trap_Trace(tr, blocker.r.currentOrigin, mins, blocker.r.maxs, end, blocker.s.number, blocker.clipmask | CONTENTS_BOTCLIP)
        if tr.startsolid == 0 && tr.allsolid == 0 {
            leftSucc = tr.fraction
        } else {
            leftSucc = 0.0
        }

        if leftSucc >= 1.0 {
            //it's clear, shove him that way
            blocker.client!.pushVec = right * -moveamt
            blocker.client!.pushVecTime = level.time + 2000
        } else {
            _VectorMA(blocker.r.currentOrigin, moveamt, right, &end)
            trap_Trace(tr, blocker.r.currentOrigin, mins, blocker.r.maxs, end, blocker.s.number, blocker.clipmask | CONTENTS_BOTCLIP)
            if tr.startsolid == 0 && tr.allsolid == 0 {
                rightSucc = tr.fraction
            } else {
                rightSucc = 0.0
            }

            if leftSucc == 0.0 && rightSucc == 0.0 {
                //both sides failed
                if d_patched.integer != 0 {
                    //use patch-style navigation
                    blocker.client!.pushVecTime = 0
                }
                return true
            }

            if rightSucc >= 1.0 {
                //it's clear, shove him that way
                blocker.client!.pushVec = right * moveamt
                blocker.client!.pushVecTime = level.time + 2000
            } else if leftSucc >= rightSucc {
                //if neither are enough, we probably can't get around him, but keep trying
                //favor the left, all things being equal
                blocker.client!.pushVec = right * -moveamt
                blocker.client!.pushVecTime = level.time + 2000
            } else {
                blocker.client!.pushVec = right * moveamt
                blocker.client!.pushVecTime = level.time + 2000
            }
        }

        if setBlockedInfo {
            //we tried pushing
            `self`.NPC!.shoveCount += 1
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
NAVNEW_DanceWithBlocker
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:178
func NAVNEW_DanceWithBlocker(_ `self`: Entity, _ blocker: Entity, _ movedir: inout JKAShared.vec3_t, _ right: JKAShared.vec3_t) -> Bool {
    //sees if blocker has any lateral movement
    if blocker.client != nil && VectorCompare(blocker.client!.ps.velocity, vec3_origin) == 0 {
        var blocker_movedir = vec3_t()
        let dot: Float

        blocker_movedir = blocker.client!.ps.velocity
        blocker_movedir[2] = 0 //cancel any vertical motion
        dot = _DotProduct(blocker_movedir, right)
        if dot > 50.0 {
            //he's moving to the right of me at a relatively good speed
            //go to my left
            _VectorMA(movedir, -1, right, &movedir)
            VectorNormalize(&movedir)
            return true
        } else if dot > -50.0 {
            //he's moving to the left of me at a relatively good speed
            //go to my right
            movedir = right + movedir
            VectorNormalize(&movedir)
            return true
        }
        /*
        vec3_t	block_pos;
        trace_t	tr;
        VectorScale( blocker_movedir, -1, blocker_movedir );
        VectorMA( self->r.currentOrigin, blocked_dist, blocker_movedir, block_pos );
        if ( NAVNEW_CheckAhead( self, block_pos, tr, ( self->clipmask & ~CONTENTS_BODY )|CONTENTS_BOTCLIP ) )
        {
        VectorCopy( blocker_movedir, movedir );
        return qtrue;
        }
        */
    }
    return false
}

/**
```
-------------------------
NAVNEW_SidestepBlocker
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:222
func NAVNEW_SidestepBlocker(_ `self`: Entity, _ blocker: Entity, _ blocked_dir: JKAShared.vec3_t, _ blocked_dist: Float, _ movedir: inout JKAShared.vec3_t, _ right: JKAShared.vec3_t) -> Bool {
    //trace to sides of blocker and see if either is clear
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var avoidAngles = vec3_t()
        var avoidRight_dir = vec3_t()
        var avoidLeft_dir = vec3_t()
        var block_pos = vec3_t()
        var mins = vec3_t()
        var rightSucc: Float = 0
        var leftSucc: Float = 0
        var yaw: Float = 0
        var avoidRadius: Float = 0
        var arcAngle: Float = 0

        mins = `self`.r.mins
        mins[2] += STEPSIZE

        //Get the blocked direction
        yaw = vectoyaw(blocked_dir)

        //Get the avoid radius
        avoidRadius = sqrt((blocker.r.maxs[0] * blocker.r.maxs[0]) + (blocker.r.maxs[1] * blocker.r.maxs[1])) + sqrt((`self`.r.maxs[0] * `self`.r.maxs[0]) + (`self`.r.maxs[1] * `self`.r.maxs[1]))

        //See if we're inside our avoidance radius
        arcAngle = (blocked_dist <= avoidRadius) ? 135 : ((avoidRadius / blocked_dist) * 90)

        /*
        float dot = DotProduct( blocked_dir, right );

        //Go right on the first try if that works better
        if ( dot < 0.0f )
        arcAngle *= -1;
        */

        avoidAngles = vec3_t()

        //need to stop it from ping-ponging, so we have a bit of a debounce time on which side you try
        if `self`.NPC!.sideStepHoldTime > level.time {
            if `self`.NPC!.lastSideStepSide == -1 {
                arcAngle *= -1
            }
            avoidAngles[YAW] = AngleNormalize360(yaw + arcAngle)
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("NAVNEW_SidestepBlocker", source: "oracle/codemp/game/g_navnew.c:222")
            var scratchRight = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("NAVNEW_SidestepBlocker", source: "oracle/codemp/game/g_navnew.c:222")
            var scratchUp = vec3_t()
            AngleVectors(avoidAngles, &movedir, &scratchRight, &scratchUp)
            _VectorMA(`self`.r.currentOrigin, blocked_dist, movedir, &block_pos)
            trap_Trace(tr, `self`.r.currentOrigin, mins, `self`.r.maxs, block_pos, `self`.s.number, `self`.clipmask | CONTENTS_BOTCLIP)
            return (Double(tr.fraction) == 1.0 && tr.allsolid == 0 && tr.startsolid == 0)
        }

        //test right
        avoidAngles[YAW] = AngleNormalize360(yaw + arcAngle)
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAVNEW_SidestepBlocker", source: "oracle/codemp/game/g_navnew.c:222")
        var scratchRight2 = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAVNEW_SidestepBlocker", source: "oracle/codemp/game/g_navnew.c:222")
        var scratchUp2 = vec3_t()
        AngleVectors(avoidAngles, &avoidRight_dir, &scratchRight2, &scratchUp2)

        _VectorMA(`self`.r.currentOrigin, blocked_dist, avoidRight_dir, &block_pos)

        trap_Trace(tr, `self`.r.currentOrigin, mins, `self`.r.maxs, block_pos, `self`.s.number, `self`.clipmask | CONTENTS_BOTCLIP)

        if tr.allsolid == 0 && tr.startsolid == 0 {
            if tr.fraction >= 1.0 {
                //all clear, go for it (favor the right if both are equal)
                movedir = avoidRight_dir
                `self`.NPC!.lastSideStepSide = 1
                `self`.NPC!.sideStepHoldTime = level.time + 2000
                return true
            }
            rightSucc = tr.fraction
        } else {
            rightSucc = 0.0
        }

        //now test left
        arcAngle *= -1

        avoidAngles[YAW] = AngleNormalize360(yaw + arcAngle)
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAVNEW_SidestepBlocker", source: "oracle/codemp/game/g_navnew.c:222")
        var scratchRight3 = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAVNEW_SidestepBlocker", source: "oracle/codemp/game/g_navnew.c:222")
        var scratchUp3 = vec3_t()
        AngleVectors(avoidAngles, &avoidLeft_dir, &scratchRight3, &scratchUp3)

        _VectorMA(`self`.r.currentOrigin, blocked_dist, avoidLeft_dir, &block_pos)

        trap_Trace(tr, `self`.r.currentOrigin, mins, `self`.r.maxs, block_pos, `self`.s.number, `self`.clipmask | CONTENTS_BOTCLIP)

        if tr.allsolid == 0 && tr.startsolid == 0 {
            if tr.fraction >= 1.0 {
                //all clear, go for it (right side would have already succeeded if as good as this)
                movedir = avoidLeft_dir
                `self`.NPC!.lastSideStepSide = -1
                `self`.NPC!.sideStepHoldTime = level.time + 2000
                return true
            }
            leftSucc = tr.fraction
        } else {
            leftSucc = 0.0
        }

        if leftSucc == 0.0 && rightSucc == 0.0 {
            //both sides failed
            return false
        }

        if rightSucc * blocked_dist >= avoidRadius || leftSucc * blocked_dist >= avoidRadius {
            //the traces hit something, but got a relatively good distance
            if rightSucc >= leftSucc {
                //favor the right, all things being equal
                movedir = avoidRight_dir
                `self`.NPC!.lastSideStepSide = 1
                `self`.NPC!.sideStepHoldTime = level.time + 2000
            } else {
                movedir = avoidLeft_dir
                `self`.NPC!.lastSideStepSide = -1
                `self`.NPC!.sideStepHoldTime = level.time + 2000
            }
            return true
        }

        //if neither are enough, we probably can't get around him
        return false
    }
}

/**
```
-------------------------
NAVNEW_Bypass
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:347
func NAVNEW_Bypass(_ `self`: Entity, _ blocker: Entity, _ blocked_dir: JKAShared.vec3_t, _ blocked_dist: Float, _ movedir: inout JKAShared.vec3_t, _ setBlockedInfo: Bool) -> Bool {
    var moveangles = vec3_t()
    var right = vec3_t()

    //Draw debug info if requested
    if NAVDEBUG_showCollision {
        G_DrawEdge(`self`.r.currentOrigin, blocker.r.currentOrigin, EDGE_NORMAL)
    }

    vectoangles(movedir, &moveangles)
    moveangles[2] = 0
    // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("NAVNEW_Bypass", source: "oracle/codemp/game/g_navnew.c:347")
    var scratchForward = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("NAVNEW_Bypass", source: "oracle/codemp/game/g_navnew.c:347")
    var scratchUp = vec3_t()
    AngleVectors(moveangles, &scratchForward, &right, &scratchUp)

    //Check to see what dir the other guy is moving in (if any) and pick the opposite dir
    if NAVNEW_DanceWithBlocker(`self`, blocker, &movedir, right) {
        return true
    }

    //Okay, so he's not moving to my side, see which side of him is most clear
    if NAVNEW_SidestepBlocker(`self`, blocker, blocked_dir, blocked_dist, &movedir, right) {
        return true
    }

    //Neither side is clear, tell him to step aside
    NAVNEW_PushBlocker(`self`, blocker, right, setBlockedInfo)

    return false
}

/**
```
-------------------------
NAVNEW_CheckDoubleBlock
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:384
func NAVNEW_CheckDoubleBlock(_ `self`: Entity, _ blocker: Entity, _ blocked_dir: JKAShared.vec3_t) -> Bool {
    //Stop double waiting
    if blocker.NPC != nil && (blocker.NPC!.blockingEntNum == `self`.s.number) {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/g_navnew.c:399
func NAVNEW_ResolveEntityCollision(_ `self`: Entity, _ blocker: Entity, _ movedir: inout JKAShared.vec3_t, _ pathDir: JKAShared.vec3_t, _ setBlockedInfo: Bool) -> Bool {
    var blocked_dir = vec3_t()
    let blocked_dist: Float

    //Doors are ignored
    if Q_stricmp(blocker.classname!, "func_door") == 0 {
        var center = vec3_t()
        CalcTeamDoorCenter(blocker, &center)
        if DistanceSquared(`self`.r.currentOrigin, center) > MIN_DOOR_BLOCK_DIST_SQR {
            return true
        }
    }

    blocked_dir = blocker.r.currentOrigin - `self`.r.currentOrigin
    blocked_dist = VectorNormalize(&blocked_dir)

    //Make sure an actual collision is going to happen
    //	if ( NAVNEW_PredictCollision( self, blocker, movedir, blocked_dir ) == qfalse )
    //		return qtrue;

    //First, attempt to walk around the blocker or shove him out of the way
    if NAVNEW_Bypass(`self`, blocker, blocked_dir, blocked_dist, &movedir, setBlockedInfo) {
        return true
    }

    //Can't get around him... see if I'm blocking him too... if so, I need to just keep moving?
    if NAVNEW_CheckDoubleBlock(`self`, blocker, blocked_dir) {
        return true
    }

    if setBlockedInfo {
        //Complain about it if we can
        NPC_SetBlocked(`self`, blocker)
    }

    return false
}

/**
```
-------------------------
NAVNEW_AvoidCollision
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:442
func NAVNEW_AvoidCollision(_ `self`: Entity, _ goal: Entity, _ info: NavInfo, _ setBlockedInfo: Bool, _ blockedMovesLimit: Int32) -> Bool {
    var movedir = vec3_t()
    var movepos = vec3_t()

    //Cap our distance
    if info.distance > MAX_COLL_AVOID_DIST {
        info.distance = Float(MAX_COLL_AVOID_DIST)
    }

    //Get an end position
    _VectorMA(`self`.r.currentOrigin, info.distance, info.direction, &movepos)
    movedir = info.direction

    //Now test against entities
    if NAV_CheckAhead(`self`, movepos, info.trace, CONTENTS_BODY) == false {
        //Get the blocker
        info.blocker = g_entities[info.trace.entityNum]
        info.flags |= NIF_COLLISION

        //Ok to hit our goal entity
        if goal == info.blocker {
            return true
        }

        if setBlockedInfo {
            if `self`.NPC!.consecutiveBlockedMoves > blockedMovesLimit {
                if d_patched.integer != 0 {
                    //use patch-style navigation
                    `self`.NPC!.consecutiveBlockedMoves += 1
                }
                NPC_SetBlocked(`self`, info.blocker!)
                return false
            }
            `self`.NPC!.consecutiveBlockedMoves += 1
        }
        //See if we're moving along with them
        //if ( NAVNEW_TrueCollision( self, info->blocker, movedir, info->direction ) == qfalse )
        //	return qtrue;

        //Test for blocking by standing on goal
        if NAV_TestForBlocked(`self`, goal, info.blocker!, info.distance, &info.flags) == true {
            return false
        }

        //If the above function said we're blocked, don't do the extra checks
        /*
        if ( info->flags & NIF_BLOCKED )
        return qtrue;
        */

        //See if we can get that entity to move out of our way
        if NAVNEW_ResolveEntityCollision(`self`, info.blocker!, &movedir, info.pathDirection, setBlockedInfo) == false {
            return false
        }

        info.direction = movedir

        return true
    } else {
        if setBlockedInfo {
            `self`.NPC!.consecutiveBlockedMoves = 0
        }
    }

    //Our path is clear, just move there
    if NAVDEBUG_showCollision {
        G_DrawEdge(`self`.r.currentOrigin, movepos, EDGE_MOVEDIR)
    }

    return true
}

/// Source: oracle/codemp/game/g_navnew.c:520
func NAVNEW_TestNodeConnectionBlocked(_ wp1: Int32, _ wp2: Int32, _ ignoreEnt: Entity, _ goalEntNum: Int32, _ checkWorld: Bool, _ checkEnts: Bool) -> Bool {
    //see if the direct path between 2 nodes is blocked by architecture or an ent
    var pos1 = vec3_t()
    var pos2 = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var clipmask: Int32 = MASK_NPCSOLID | CONTENTS_BOTCLIP
        var ignoreEntNum: Int32 = 0
        var playerMins = vec3_t()
        var playerMaxs = vec3_t()

        if !checkWorld && !checkEnts {
            //duh, nothing to trace against
            return false
        }
        playerMins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
        playerMaxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))

        trap_Nav_GetNodePosition(wp1, &pos1)
        trap_Nav_GetNodePosition(wp2, &pos2)

        if !checkWorld {
            clipmask &= ~(CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP)
        }
        if !checkEnts {
            clipmask &= ~CONTENTS_BODY
        }
        mins = ignoreEnt.r.mins
        maxs = ignoreEnt.r.maxs
        ignoreEntNum = ignoreEnt.s.number
        mins[2] += STEPSIZE
        //don't let box get inverted
        if mins[2] > maxs[2] {
            mins[2] = maxs[2]
        }

        trap_Trace(trace, pos1, mins, maxs, pos2, ignoreEntNum, clipmask)
        if trace.fraction >= 1.0 || trace.entityNum == goalEntNum {
            //clear or hit goal
            return false
        }
        //hit something we weren't supposed to
        return true
    }
}

/**
```
-------------------------
NAVNEW_MoveToGoal
-------------------------
```
*/
/// Source: oracle/codemp/game/g_navnew.c:578
func NAVNEW_MoveToGoal(_ `self`: Entity, _ info: NavInfo) -> Int32 {
    var bestNode: Int32 = WAYPOINT_NONE
    var foundClearPath: Bool = false
    var origin = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return NavInfo.scratch { tempInfo -> Int32 in
        var setBlockedInfo: Bool = true
        var inBestWP: Bool = false
        var inGoalWP: Bool = false
        var goalWPFailed: Bool = false
        var numTries: Int32 = 0

        failed: do {
            tempInfo.copy(from: info)

            //Must have a goal entity to move there
            if `self`.NPC!.goalEntity == nil {
                return WAYPOINT_NONE
            }

            if `self`.waypoint == WAYPOINT_NONE && `self`.noWaypointTime > level.time {
                //didn't have a valid one in about the past second, don't look again just yet
                return WAYPOINT_NONE
            }
            if `self`.NPC!.goalEntity!.waypoint == WAYPOINT_NONE && `self`.NPC!.goalEntity!.noWaypointTime > level.time {
                //didn't have a valid one in about the past second, don't look again just yet
                return WAYPOINT_NONE
            }
            // Port-note: An assignment inside an expression.
            // Raven wrote: if ( self->noWaypointTime > level.time && self->NPC->goalEntity->noWaypointTime > level.time ) {//just use current waypoints bestNode = trap_Nav_GetBestNodeAltRoute2( self->waypoint, self->NPC->goalEntity->waypoint, bestNode ); } //FIXME!!!!: this is making them wiggle back and forth between waypoints else if ( (bestNode = trap_Nav_GetBestPathBetweenEnts( self, self->NPC->goalEntity, NF_CLEAR_PATH )) == NODE_NONE )//!NAVNEW_GetWaypoints( self, qtrue ) ) {//one of us didn't have a valid waypoint! if ( self->waypoint == NODE_NONE ) {//don't even try to find one again for a bit self->noWaypointTime = level.time + Q_irand( 500, 1500 ); } if ( self->NPC->goalEntity->waypoint == NODE_NONE ) {//don't even try to find one again for a bit self->NPC->goalEntity->noWaypointTime = level.time + Q_irand( 500, 1500 ); } return WAYPOINT_NONE; } else { if ( self->NPC->goalEntity->noWaypointTime < level.time ) { self->NPC->goalEntity->noWaypointTime = level.time + Q_irand( 500, 1500 ); } }
            portMissing("NAVNEW_MoveToGoal", source: "oracle/codemp/game/g_navnew.c:578")

            while !foundClearPath {
                inGoalWP = false
                inBestWP = inGoalWP
                /*
                bestNode = trap_Nav_GetBestNodeAltRoute( self->waypoint, self->NPC->goalEntity->waypoint, bestNode );
                */

                if bestNode == WAYPOINT_NONE {
                    break failed
                }

                //see if we can get directly to the next node off bestNode en route to goal's node...
                //NOTE: shouldn't be necc. now
                /*
                int oldBestNode = bestNode;
                bestNode = NAV_TestBestNode( self, self->waypoint, bestNode, qtrue );//, self->NPC->goalEntity->waypoint );//
                //NOTE: Guaranteed to return something
                if ( bestNode != oldBestNode )
                {//we were blocked somehow
                if ( setBlockedInfo )
                {
                self->NPC->aiFlags |= NPCAI_BLOCKED;
                trap_Nav_GetNodePosition( oldBestNode, NPCInfo->blockedDest );
                }
                }
                */
                trap_Nav_GetNodePosition(bestNode, &origin)
                /*
                if ( !goalWPFailed )
                {//we haven't already tried to go straight to goal or goal's wp
                if ( bestNode == self->NPC->goalEntity->waypoint )
                {//our bestNode is the goal's wp
                if ( NAV_HitNavGoal( self->r.currentOrigin, self->r.mins, self->r.maxs, origin, trap_Nav_GetNodeRadius( bestNode ), FlyingCreature( self ) ) )
                {//we're in the goal's wp
                inGoalWP = qtrue;
                //we're in the goalEntity's waypoint already
                //so head for the goalEntity since we know it's clear of architecture
                //FIXME: this is pretty stupid because the NPCs try to go straight
                //		towards their goal before then even try macro_nav...
                VectorCopy( self->NPC->goalEntity->r.currentOrigin, origin );
                }
                }
                }
                */
                if !inGoalWP {
                    //not heading straight for goal
                    if bestNode == `self`.waypoint {
                        //we know it's clear or architecture
                        //trap_Nav_GetNodePosition( self->waypoint, origin );
                        /*
                        if ( NAV_HitNavGoal( self->r.currentOrigin, self->r.mins, self->r.maxs, origin, trap_Nav_GetNodeRadius( bestNode ), FlyingCreature( self ) ) )
                        {//we're in the wp we're heading for already
                        inBestWP = qtrue;
                        }
                        */
                    } else {
                        //heading to an edge off our confirmed clear waypoint... make sure it's clear
                        //it it's not, bestNode will fall back to our waypoint
                        let oldBestNode: Int32 = bestNode
                        bestNode = NAV_TestBestNode(`self`, `self`.waypoint, bestNode, true)
                        if bestNode == `self`.waypoint {
                            //we fell back to our waypoint, reset the origin
                            `self`.NPC!.aiFlags |= NPCAI_BLOCKED
                            trap_Nav_GetNodePosition(oldBestNode, &NPCInfo!.blockedDest)
                            trap_Nav_GetNodePosition(bestNode, &origin)
                        }
                    }
                }
                //Com_Printf( "goalwp = %d, mywp = %d, node = %d, origin = %s\n", self->NPC->goalEntity->waypoint, self->waypoint, bestNode, vtos(origin) );

                tempInfo.copy(from: info)
                tempInfo.direction = origin - `self`.r.currentOrigin
                VectorNormalize(&tempInfo.direction)

                //NOTE: One very important thing NAVNEW_AvoidCollision does is
                //		it actually CHANGES the value of "direction" - it changes it to
                //		whatever dir you need to go in to avoid the obstacle...
                foundClearPath = NAVNEW_AvoidCollision(`self`, `self`.NPC!.goalEntity!, tempInfo, setBlockedInfo, 5)

                if !foundClearPath {
                    //blocked by an ent
                    if inGoalWP {
                        //we were heading straight for the goal, head for the goal's wp instead
                        trap_Nav_GetNodePosition(bestNode, &origin)
                        foundClearPath = NAVNEW_AvoidCollision(`self`, `self`.NPC!.goalEntity!, tempInfo, setBlockedInfo, 5)
                    }
                }

                if foundClearPath {
                    //clear!
                    //If we got set to blocked, clear it
                    NPC_ClearBlocked(`self`)
                    //Take the dir
                    info.copy(from: tempInfo)
                    if `self`.s.weapon == WP_SABER {
                        //jedi
                        if info.direction[2] * info.distance > 64 {
                            `self`.NPC!.aiFlags |= NPCAI_BLOCKED
                            NPCInfo!.blockedDest = origin
                            break failed
                        }
                    }
                } else {
                    //blocked by ent!
                    if setBlockedInfo {
                        `self`.NPC!.aiFlags |= NPCAI_BLOCKED
                        trap_Nav_GetNodePosition(bestNode, &NPCInfo!.blockedDest)
                    }
                    //Only set blocked info first time
                    setBlockedInfo = false

                    if inGoalWP {
                        //we headed for our goal and failed and our goal's WP and failed
                        if `self`.waypoint == `self`.NPC!.goalEntity!.waypoint {
                            //our waypoint is our goal's waypoint, nothing we can do
                            //remember that this node is blocked
                            trap_Nav_AddFailedNode(`self`, `self`.waypoint)
                            break failed
                        } else {
                            //try going for our waypoint this time
                            goalWPFailed = true
                            inGoalWP = false
                        }
                    } else if bestNode != `self`.waypoint {
                        //we headed toward our next waypoint (instead of our waypoint) and failed
                        if d_altRoutes.integer != 0 {
                            //mark this edge failed and try our waypoint
                            //NOTE: don't assume there is something blocking the direct path
                            //			between my waypoint and the bestNode... I could be off
                            //			that path because of collision avoidance...
                            if d_patched.integer != 0 && (!trap_Nav_NodesAreNeighbors(`self`.waypoint, bestNode) || NAVNEW_TestNodeConnectionBlocked(`self`.waypoint, bestNode, `self`, `self`.NPC!.goalEntity!.s.number, false, true)) {
                                //the direct path between these 2 nodes is blocked by an ent
                                trap_Nav_AddFailedEdge(`self`.s.number, `self`.waypoint, bestNode)
                            }
                            bestNode = `self`.waypoint
                        } else {
                            //we should stop
                            break failed
                        }
                    } else {
                        //we headed for *our* waypoint and couldn't get to it
                        if d_altRoutes.integer != 0 {
                            //remember that this node is blocked
                            trap_Nav_AddFailedNode(`self`, `self`.waypoint)
                            //Now we should get our waypoints again
                            //FIXME: cache the trace-data for subsequent calls as only the route info would have changed
                            //if ( (bestNode = trap_Nav_GetBestPathBetweenEnts( self, self->NPC->goalEntity, NF_CLEAR_PATH )) == NODE_NONE )//!NAVNEW_GetWaypoints( self, qfalse ) )
                            do {
                                //one of our waypoints is WAYPOINT_NONE now
                                break failed
                            }
                        } else {
                            //we should stop
                            break failed
                        }
                    }

                    // Port-note: A ++ inside an expression.
                    // Raven wrote: if ( ++numTries >= 10 ) { goto failed; }
                    portMissing("NAVNEW_MoveToGoal", source: "oracle/codemp/game/g_navnew.c:578")
                }
            }

            //finish:
            //Draw any debug info, if requested
            if NAVDEBUG_showEnemyPath {
                var dest = vec3_t()
                var start = vec3_t()

                //Get the positions
                trap_Nav_GetNodePosition(`self`.NPC!.goalEntity!.waypoint, &dest)
                trap_Nav_GetNodePosition(bestNode, &start)

                //Draw the route
                G_DrawNode(start, NODE_START)
                if bestNode != `self`.waypoint {
                    var wpPos = vec3_t()
                    trap_Nav_GetNodePosition(`self`.waypoint, &wpPos)
                    G_DrawNode(wpPos, NODE_NAVGOAL)
                }
                G_DrawNode(dest, NODE_GOAL)
                G_DrawEdge(dest, `self`.NPC!.goalEntity!.r.currentOrigin, EDGE_PATH)
                G_DrawNode(`self`.NPC!.goalEntity!.r.currentOrigin, NODE_GOAL)
                trap_Nav_ShowPath(bestNode, `self`.NPC!.goalEntity!.waypoint)
            }

            `self`.NPC!.shoveCount = 0

            //let me keep this waypoint for a while
            if `self`.noWaypointTime < level.time {
                `self`.noWaypointTime = level.time + Q_irand(500, 1500)
            }
            return bestNode

        }
        //FIXME: What we should really do here is have a list of the goal's and our
        //		closest clearpath waypoints, ranked.  If the first set fails, try the rest
        //		until there are no alternatives.

        trap_Nav_GetNodePosition(`self`.waypoint, &origin)

        //do this to avoid ping-ponging?
        return WAYPOINT_NONE
        /*
        //this was causing ping-ponging
        if ( DistanceSquared( origin, self->r.currentOrigin ) < 16 )//woo, magic number
        {//We're right up on our waypoint, so that won't help, return none
        //Or maybe find the nextbest here?
        return WAYPOINT_NONE;
        }
        else
        {//Try going to our waypoint
        bestNode = self->waypoint;

        VectorSubtract( origin, self->r.currentOrigin, info.direction );
        VectorNormalize( info.direction );
        }

        goto finish;
        */
    }
}
