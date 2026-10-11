import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_move.c:14
var frameNavInfo: NavInfo { world.storage.frameNavInfo }

/// Source: oracle/codemp/game/NPC_move.c:27
func NPC_ClearPathToGoal(_ dir: JKAShared.vec3_t, _ goal: Entity) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var radius: Float = 0
        var dist: Float = 0
        var tFrac: Float = 0

        //FIXME: What does do about area portals?  THIS IS BROKEN
        //if ( gi.inPVS( NPC->r.currentOrigin, goal->r.currentOrigin ) == qfalse )
        //	return qfalse;

        //Look ahead and see if we're clear to move to our goal position
        if NAV_CheckAhead(NPC!, goal.r.currentOrigin, trace, (NPC!.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP) {
            //VectorSubtract( goal->r.currentOrigin, NPC->r.currentOrigin, dir );
            return true
        }

        if !FlyingCreature(NPC!) {
            //See if we're too far above
            if abs(NPC!.r.currentOrigin[2] - goal.r.currentOrigin[2]) > 48 {
                return false
            }
        }

        //This is a work around
        radius = (NPC!.r.maxs[0] > NPC!.r.maxs[1]) ? NPC!.r.maxs[0] : NPC!.r.maxs[1]
        dist = Distance(NPC!.r.currentOrigin, goal.r.currentOrigin)
        tFrac = 1.0 - (radius / dist)

        if trace.fraction >= tFrac {
            return true
        }

        //See if we're looking for a navgoal
        if (goal.flags & FL_NAVGOAL) != 0 {
            //Okay, didn't get all the way there, let's see if we got close enough:
            if NAV_HitNavGoal(trace.endpos, NPC!.r.mins, NPC!.r.maxs, goal.r.currentOrigin, NPCInfo!.goalRadius, FlyingCreature(NPC!)) {
                //VectorSubtract(goal->r.currentOrigin, NPC->r.currentOrigin, dir);
                return true
            }
        }

        return false
    }
}

/// Source: oracle/codemp/game/NPC_move.c:78
func NPC_CheckCombatMove() -> Bool {
    //return NPCInfo->combatMove;
    if (NPCInfo!.goalEntity != nil && NPC!.enemy != nil && NPCInfo!.goalEntity == NPC!.enemy) || (NPCInfo!.combatMove) {
        return true
    }

    if NPCInfo!.goalEntity != nil && NPCInfo!.watchTarget != nil {
        if NPCInfo!.goalEntity != NPCInfo!.watchTarget {
            return true
        }
    }

    return false
}

/// Source: oracle/codemp/game/NPC_move.c:103
private func NPC_LadderMove(_ dir: JKAShared.vec3_t) {
    //FIXME: this doesn't guarantee we're facing ladder
    //ALSO: Need to be able to get off at top
    //ALSO: Need to play an anim
    //ALSO: Need transitionary anims?

    if (dir[2] > 0) || (dir[2] < 0 && NPC!.client!.ps.groundEntityNum == ENTITYNUM_NONE) {
        //Set our movement direction
        ucmd.upmove = (dir[2] > 0) ? 127 : -127

        //Don't move around on XY
        ucmd.rightmove = 0
        ucmd.forwardmove = ucmd.rightmove
    }
}

/// Source: oracle/codemp/game/NPC_move.c:126
func NPC_GetMoveInformation(_ dir: inout JKAShared.vec3_t, _ distance: inout Float) -> Bool {
    //NOTENOTE: Use path stacks!

    //Make sure we have somewhere to go
    if NPCInfo!.goalEntity == nil {
        return false
    }

    //Get our move info
    dir = NPCInfo!.goalEntity!.r.currentOrigin - NPC!.r.currentOrigin
    distance = VectorNormalize(&dir)

    NPCInfo!.blockedDest = NPCInfo!.goalEntity!.r.currentOrigin

    return true
}

/// Source: oracle/codemp/game/NPC_move.c:149
func NAV_GetLastMove(_ info: NavInfo) {
    info.copy(from: frameNavInfo)
}

/// Source: oracle/codemp/game/NPC_move.c:160
func NPC_GetMoveDirection(_ out: inout JKAShared.vec3_t, _ distance: inout Float) -> Bool {
    var angles = vec3_t()

    //Clear the struct
    frameNavInfo.clear()

    //Get our movement, if any
    if NPC_GetMoveInformation(&frameNavInfo.direction, &frameNavInfo.distance) == false {
        return false
    }

    //Setup the return value
    distance = frameNavInfo.distance

    //For starters
    frameNavInfo.pathDirection = frameNavInfo.direction

    //If on a ladder, move appropriately
    if (NPC!.watertype & CONTENTS_LADDER) != 0 {
        NPC_LadderMove(frameNavInfo.direction)
        return true
    }

    //Attempt a straight move to goal
    if NPC_ClearPathToGoal(frameNavInfo.direction, NPCInfo!.goalEntity!) == false {
        //See if we're just stuck
        if NAV_MoveToGoal(NPC!, frameNavInfo) == WAYPOINT_NONE {
            //Can't reach goal, just face
            vectoangles(frameNavInfo.direction, &angles)
            NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
            out = frameNavInfo.direction
            distance = frameNavInfo.distance
            return false
        }

        frameNavInfo.flags |= NIF_MACRO_NAV
    }

    //Avoid any collisions on the way
    if NAV_AvoidCollision(NPC!, NPCInfo!.goalEntity!, frameNavInfo) == false {
        //FIXME: Emit a warning, this is a worst case scenario
        //FIXME: if we have a clear path to our goal (exluding bodies), but then this
        //			check (against bodies only) fails, shouldn't we fall back
        //			to macro navigation?  Like so:
        if !((frameNavInfo.flags & NIF_MACRO_NAV) != 0) {
            //we had a clear path to goal and didn't try macro nav, but can't avoid collision so try macro nav here
            //See if we're just stuck
            if NAV_MoveToGoal(NPC!, frameNavInfo) == WAYPOINT_NONE {
                //Can't reach goal, just face
                vectoangles(frameNavInfo.direction, &angles)
                NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
                out = frameNavInfo.direction
                distance = frameNavInfo.distance
                return false
            }

            frameNavInfo.flags |= NIF_MACRO_NAV
        }
    }

    //Setup the return values
    out = frameNavInfo.direction
    distance = frameNavInfo.distance

    return true
}

/// Source: oracle/codemp/game/NPC_move.c:239
func NPC_GetMoveDirectionAltRoute(_ out: inout JKAShared.vec3_t, _ distance: inout Float, _ tryStraight: Bool) -> Bool {
    var angles = vec3_t()

    NPCInfo!.aiFlags &= ~NPCAI_BLOCKED

    //Clear the struct
    frameNavInfo.clear()

    //Get our movement, if any
    if NPC_GetMoveInformation(&frameNavInfo.direction, &frameNavInfo.distance) == false {
        return false
    }

    //Setup the return value
    distance = frameNavInfo.distance

    //For starters
    frameNavInfo.pathDirection = frameNavInfo.direction

    //If on a ladder, move appropriately
    if (NPC!.watertype & CONTENTS_LADDER) != 0 {
        NPC_LadderMove(frameNavInfo.direction)
        return true
    }

    //Attempt a straight move to goal
    if !tryStraight || NPC_ClearPathToGoal(frameNavInfo.direction, NPCInfo!.goalEntity!) == false {
        //blocked
        //Can't get straight to goal, use macro nav
        if NAVNEW_MoveToGoal(NPC!, frameNavInfo) == WAYPOINT_NONE {
            //Can't reach goal, just face
            vectoangles(frameNavInfo.direction, &angles)
            NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
            out = frameNavInfo.direction
            distance = frameNavInfo.distance
            return false
        }
        //else we are on our way
        frameNavInfo.flags |= NIF_MACRO_NAV
    } else {
        //we have no architectural problems, see if there are ents inthe way and try to go around them
        //not blocked
        if d_altRoutes.integer != 0 {
            //try macro nav
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives nil where Raven's block falls through to its end.
            let earlyOut = NavInfo.scratch { tempInfo -> Bool? in
                tempInfo.copy(from: frameNavInfo)
                if NAVNEW_AvoidCollision(NPC!, NPCInfo!.goalEntity!, tempInfo, true, 5) == false {
                    //revert to macro nav
                    //Can't get straight to goal, dump tempInfo and use macro nav
                    if NAVNEW_MoveToGoal(NPC!, frameNavInfo) == WAYPOINT_NONE {
                        //Can't reach goal, just face
                        vectoangles(frameNavInfo.direction, &angles)
                        NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
                        out = frameNavInfo.direction
                        distance = frameNavInfo.distance
                        return false
                    }
                    //else we are on our way
                    frameNavInfo.flags |= NIF_MACRO_NAV
                } else {
                    //otherwise, either clear or can avoid
                    frameNavInfo.copy(from: tempInfo)
                }
                return nil
            }
            if let earlyOut {
                return earlyOut
            }
        } else {
            //OR: just give up
            if NAVNEW_AvoidCollision(NPC!, NPCInfo!.goalEntity!, frameNavInfo, true, 30) == false {
                //give up
                return false
            }
        }
    }

    //Setup the return values
    out = frameNavInfo.direction
    distance = frameNavInfo.distance

    return true
}

/// Source: oracle/codemp/game/NPC_move.c:324
func G_UcmdMoveForDir(_ `self`: Entity, _ cmd: JKAMP.Usercmd, _ dir: inout JKAShared.vec3_t) {
    var forward = vec3_t()
    var right = vec3_t()
    var fDot: Float
    var rDot: Float

    var scratchUp = vec3_t()
    // Raven passes NULL for the up output.
    AngleVectors(`self`.r.currentAngles, &forward, &right, &scratchUp)

    dir[2] = 0
    VectorNormalize(&dir)
    //NPCs cheat and store this directly because converting movement into a ucmd loses precision
    `self`.client!.ps.moveDir = dir

    fDot = _DotProduct(forward, dir) * 127.0
    rDot = _DotProduct(right, dir) * 127.0
    //Must clamp this because DotProduct is not guaranteed to return a number within -1 to 1, and that would be bad when we're shoving this into a signed byte
    if fDot > 127.0 {
        fDot = 127.0
    }
    if fDot < -127.0 {
        fDot = -127.0
    }
    if rDot > 127.0 {
        rDot = 127.0
    }
    if rDot < -127.0 {
        rDot = -127.0
    }
    cmd.forwardmove = Int32(floor(fDot))
    cmd.rightmove = Int32(floor(rDot))

    /*
    vec3_t	wishvel;
    for ( int i = 0 ; i < 3 ; i++ )
    {
    wishvel[i] = forward[i]*cmd->forwardmove + right[i]*cmd->rightmove;
    }
    VectorNormalize( wishvel );
    if ( !VectorCompare( wishvel, dir ) )
    {
    Com_Printf( "PRECISION LOSS: %s != %s\n", vtos(wishvel), vtos(dir) );
    }
    */
}

/// Source: oracle/codemp/game/NPC_move.c:382
func NPC_MoveToGoal(_ tryStraight: Bool) -> Bool {
    var distance: Float = 0
    var dir = vec3_t()

    //If taking full body pain, don't move
    if PM_InKnockDown(NPC!.client!.ps) || ((NPC!.s.legsAnim >= BOTH_PAIN1) && (NPC!.s.legsAnim <= BOTH_PAIN18)) {
        return true
    }

    /*
    if( NPC->s.eFlags & EF_LOCKED_TO_WEAPON )
    {//If in an emplaced gun, never try to navigate!
    return qtrue;
    }
    */
    //rwwFIXMEFIXME: emplaced support

    //FIXME: if can't get to goal & goal is a target (enemy), try to find a waypoint that has line of sight to target, at least?
    //Get our movement direction
    if NPC_GetMoveDirectionAltRoute(&dir, &distance, tryStraight) == false {
        return false
    }

    NPCInfo!.distToGoal = distance

    //Convert the move to angles
    vectoangles(dir, &NPCInfo!.lastPathAngles)
    if (ucmd.buttons & BUTTON_WALKING) != 0 {
        NPC!.client!.ps.speed = Float(NPCInfo!.stats.walkSpeed)
    } else {
        NPC!.client!.ps.speed = Float(NPCInfo!.stats.runSpeed)
    }

    //FIXME: still getting ping-ponging in certain cases... !!!  Nav/avoidance error?  WTF???!!!
    //If in combat move, then move directly towards our goal
    if NPC_CheckCombatMove() {
        //keep current facing
        G_UcmdMoveForDir(NPC!, ucmd, &dir)
    } else {
        //face our goal
        //FIXME: strafe instead of turn if change in dir is small and temporary
        NPCInfo!.desiredPitch = 0.0
        NPCInfo!.desiredYaw = AngleNormalize360(NPCInfo!.lastPathAngles[YAW])

        //Pitch towards the goal and also update if flying or swimming
        if (NPC!.client!.ps.eFlags2 & EF2_FLYING) != 0 {
            NPCInfo!.desiredPitch = AngleNormalize360(NPCInfo!.lastPathAngles[PITCH])

            if dir[2] != 0 {
                var scale: Float = (dir[2] * distance)
                if scale > 64 {
                    scale = 64
                } else if scale < -64 {
                    scale = -64
                }
                NPC!.client!.ps.velocity[2] = scale
                //NPC->client->ps.velocity[2] = (dir[2] > 0) ? 64 : -64;
            }
        }

        //Set any final info
        ucmd.forwardmove = 127
    }

    return true
}

/**
```
-------------------------
void NPC_SlideMoveToGoal( void )

  Now assumes goal is goalEntity, if want to use tempGoal, you set that before calling the func
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_move.c:476
func NPC_SlideMoveToGoal() -> Bool {
    let saveYaw: Float = NPC!.client!.ps.viewangles[YAW]
    let ret: Bool

    NPCInfo!.combatMove = true

    ret = NPC_MoveToGoal(true)

    NPCInfo!.desiredYaw = saveYaw

    return ret
}

/// Source: oracle/codemp/game/NPC_move.c:497
func NPC_ApplyRoff() {
    BG_PlayerStateToEntityState(NPC!.client!.ps, NPC!.s, false)
    //VectorCopy ( NPC->r.currentOrigin, NPC->lastOrigin );
    //rwwFIXMEFIXME: Any significance to this?

    // use the precise origin for linking
    trap_LinkEntity(NPC!)
}
