import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_nav.c:1597
var navCalculatePaths: Bool {
    get { world.variables.navCalculatePaths }
    set { world.variables.navCalculatePaths = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1599
var NAVDEBUG_showNodes: Bool {
    get { world.variables.NAVDEBUG_showNodes }
    set { world.variables.NAVDEBUG_showNodes = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1600
var NAVDEBUG_showRadius: Bool {
    get { world.variables.NAVDEBUG_showRadius }
    set { world.variables.NAVDEBUG_showRadius = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1601
var NAVDEBUG_showEdges: Bool {
    get { world.variables.NAVDEBUG_showEdges }
    set { world.variables.NAVDEBUG_showEdges = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1602
var NAVDEBUG_showTestPath: Bool {
    get { world.variables.NAVDEBUG_showTestPath }
    set { world.variables.NAVDEBUG_showTestPath = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1603
var NAVDEBUG_showEnemyPath: Bool {
    get { world.variables.NAVDEBUG_showEnemyPath }
    set { world.variables.NAVDEBUG_showEnemyPath = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1604
var NAVDEBUG_showCombatPoints: Bool {
    get { world.variables.NAVDEBUG_showCombatPoints }
    set { world.variables.NAVDEBUG_showCombatPoints = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1605
var NAVDEBUG_showNavGoals: Bool {
    get { world.variables.NAVDEBUG_showNavGoals }
    set { world.variables.NAVDEBUG_showNavGoals = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1606
var NAVDEBUG_showCollision: Bool {
    get { world.variables.NAVDEBUG_showCollision }
    set { world.variables.NAVDEBUG_showCollision = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1607
var NAVDEBUG_curGoal: Int32 {
    get { world.variables.NAVDEBUG_curGoal }
    set { world.variables.NAVDEBUG_curGoal = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1615
var fatalErrors: Int32 {
    get { world.variables.fatalErrors }
    set { world.variables.fatalErrors = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1616
var fatalErrorPointer: String {
    get { world.variables.fatalErrorPointer }
    set { world.variables.fatalErrorPointer = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1617
var fatalErrorString: JKAShared.CharBuf {
    get { world.variables.fatalErrorString }
    set { world.variables.fatalErrorString = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1658
var numStoredWaypoints: Int32 {
    get { world.variables.numStoredWaypoints }
    set { world.variables.numStoredWaypoints = newValue }
}

/// Source: oracle/codemp/game/g_nav.c:1660
var tempWaypointList: Slots<WaypointData> { world.storage.tempWaypointList }

//For debug graphics
//rwwFIXMEFIXME: Write these at some point for the sake of being able to debug visually
/// Source: oracle/codemp/game/g_nav.c:11
func G_Line(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: JKAShared.vec3_t, _ alpha: Float) {
}

/// Source: oracle/codemp/game/g_nav.c:16
func G_Cube(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ color: JKAShared.vec3_t, _ alpha: Float) {
}

/// Source: oracle/codemp/game/g_nav.c:21
func G_CubeOutline(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ time: Int32, _ color: UInt32, _ alpha: Float) {
}

/// Source: oracle/codemp/game/g_nav.c:26
func G_DrawEdge(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ type: Int32) {
}

/// Source: oracle/codemp/game/g_nav.c:31
func G_DrawNode(_ origin: JKAShared.vec3_t, _ type: Int32) {
}

/// Source: oracle/codemp/game/g_nav.c:36
func G_DrawCombatPoint(_ origin: JKAShared.vec3_t, _ type: Int32) {
}

/// Source: oracle/codemp/game/g_nav.c:41
func TAG_ShowTags(_ flags: Int32) {
}

/// Source: oracle/codemp/game/g_nav.c:46
func FlyingCreature(_ ent: Entity) -> Bool {
    if ent.client != nil && ent.client!.ps.gravity <= 0 {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_nav.c:68
func NPC_Blocked(_ `self`: Entity, _ blocker: Entity) {
    if `self`.NPC == nil {
        return
    }

    //Don't do this too often
    if `self`.NPC!.blockedSpeechDebounceTime > level.time {
        return
    }

    //Attempt to run any blocked scripts
    if G_ActivateBehavior(`self`, BSET_BLOCKED) {
        return
    }

    //If this is one of our enemies, then just attack him
    if blocker.client != nil && (blocker.client!.playerTeam == `self`.client!.enemyTeam) {
        G_SetEnemy(`self`, blocker)
        return
    }

    //Debug_Printf( debugNPCAI, DEBUG_LEVEL_WARNING, "%s: Excuse me, %s %s!\n", self->targetname, blocker->classname, blocker->targetname );

    //If we're being blocked by the player, say something to them
    if (blocker.s.number == 0) && ((blocker.client!.playerTeam == `self`.client!.playerTeam)) {
        //guys in formation are not trying to get to a critical point,
        //don't make them yell at the player (unless they have an enemy and
        //are in combat because BP thinks it sounds cool during battle)
        //NOTE: only imperials, misc crewmen and hazard team have these wav files now
        //G_AddVoiceEvent( self, Q_irand(EV_BLOCKED1, EV_BLOCKED3), 0 );
    }

    // The SDK also declares `random`, so the call names the bg module.
    `self`.NPC!.blockedSpeechDebounceTime = Int32(level.time + MIN_BLOCKED_SPEECH_TIME + (JKAMP_BG.random() * 4000))
    `self`.NPC!.blockingEntNum = blocker.s.number
}

/// Source: oracle/codemp/game/g_nav.c:112
func NPC_SetMoveGoal(_ ent: Entity, _ point: JKAShared.vec3_t, _ radius: Int32, _ isNavGoal: Bool, _ combatPoint: Int32, _ targetEnt: Entity?) {
    //Must be an NPC
    if ent.NPC == nil {
        return
    }

    if ent.NPC!.tempGoal == nil {
        //must still have a goal
        return
    }

    //Copy the origin
    //VectorCopy( point, ent->NPC->goalPoint );	//FIXME: Make it use this, and this alone!
    ent.NPC!.tempGoal!.r.currentOrigin = point

    //Copy the mins and maxs to the tempGoal
    ent.NPC!.tempGoal!.r.mins = ent.r.mins
    ent.NPC!.tempGoal!.r.maxs = ent.r.mins

    ent.NPC!.tempGoal!.target = nil
    ent.NPC!.tempGoal!.clipmask = ent.clipmask
    ent.NPC!.tempGoal!.flags &= ~FL_NAVGOAL
    if targetEnt != nil && targetEnt!.waypoint >= 0 {
        ent.NPC!.tempGoal!.waypoint = targetEnt!.waypoint
    } else {
        ent.NPC!.tempGoal!.waypoint = WAYPOINT_NONE
    }
    ent.NPC!.tempGoal!.noWaypointTime = 0

    if isNavGoal {
        ent.NPC!.tempGoal!.flags |= FL_NAVGOAL
    }

    ent.NPC!.tempGoal!.combatPoint = combatPoint
    ent.NPC!.tempGoal!.enemy = targetEnt

    ent.NPC!.goalEntity = ent.NPC!.tempGoal
    ent.NPC!.goalRadius = radius

    trap_LinkEntity(ent.NPC!.goalEntity!)
}

/// Source: oracle/codemp/game/g_nav.c:167
func NAV_HitNavGoal(_ point: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ dest: JKAShared.vec3_t, _ radius: Int32, _ flying: Bool) -> Bool {
    var dmins = vec3_t()
    var dmaxs = vec3_t()
    var pmins = vec3_t()
    var pmaxs = vec3_t()
    // Raven assigns his own `radius` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var radius = radius

    if (radius & NAVGOAL_USE_RADIUS) != 0 {
        radius &= ~NAVGOAL_USE_RADIUS
        //NOTE:  This needs to do a DistanceSquared on navgoals that had
        //			a radius manually set! We can't do the smaller navgoals against
        //			walls to get around this because player-sized traces to them
        //			from angles will not work... - MCG
        if !flying {
            //Allow for a little z difference
            var diff = vec3_t()
            diff = point - dest
            if abs(diff[2]) <= 24 {
                diff[2] = 0
            }
            return (VectorLengthSquared(diff) <= (radius * radius))
        } else {
            //must hit exactly
            return (DistanceSquared(dest, point) <= (radius * radius))
        }
        //There is probably a better way to do this, either by preserving the original
        //		mins and maxs of the navgoal and doing this check ONLY if the radius
        //		is non-zero (like the original implementation) or some boolean to
        //		tell us to do this check rather than the fake bbox overlap check...
    } else {
        //Construct a dummy bounding box from our radius value
        dmins = vec3_t(Float(-radius), Float(-radius), Float(-radius))
        dmaxs = vec3_t(Float(radius), Float(radius), Float(radius))

        //Translate it
        dmins = dmins + dest
        dmaxs = dmaxs + dest

        //Translate the starting box
        pmins = point + mins
        pmaxs = point + maxs

        //See if they overlap
        return G_BoundsOverlap(pmins, pmaxs, dmins, dmaxs)
    }
}

/// Source: oracle/codemp/game/g_nav.c:222
func NAV_ClearPathToPoint(_ `self`: Entity, _ pmins: JKAShared.vec3_t, _ pmaxs: JKAShared.vec3_t, _ point: JKAShared.vec3_t, _ clipmask: Int32, _ okToHitEntNum: Int32) -> Bool {
    //	trace_t	trace;
    //	return NAV_CheckAhead( self, point, trace, clipmask|CONTENTS_BOTCLIP );

    var mins = vec3_t()
    var maxs = vec3_t()
    // Raven assigns his own `clipmask` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var clipmask = clipmask
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in

        //Test if they're even conceivably close to one another
        if !trap_InPVS(`self`.r.currentOrigin, point) {
            return false
        }

        if (`self`.flags & FL_NAVGOAL) != 0 {
            if `self`.parent == nil {
                //SHOULD NEVER HAPPEN!!!
                return false
            }
            mins = `self`.parent!.r.mins
            maxs = `self`.parent!.r.maxs
        } else {
            mins = pmins
            maxs = pmaxs
        }

        if `self`.client != nil || (`self`.flags & FL_NAVGOAL) != 0 {
            //Clients can step up things, or if this is a navgoal check, a client will be using this info
            mins[2] += STEPSIZE

            //don't let box get inverted
            if mins[2] > maxs[2] {
                mins[2] = maxs[2]
            }
        }

        if (`self`.flags & FL_NAVGOAL) != 0 {
            //Trace from point to navgoal
            trap_Trace(trace, point, mins, maxs, `self`.r.currentOrigin, `self`.parent!.s.number, (clipmask | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP) & ~CONTENTS_BODY)
            if trace.startsolid != 0 && (trace.contents & CONTENTS_BOTCLIP) != 0 {
                //started inside do not enter, so ignore them
                clipmask &= ~CONTENTS_BOTCLIP
                trap_Trace(trace, point, mins, maxs, `self`.r.currentOrigin, `self`.parent!.s.number, (clipmask | CONTENTS_MONSTERCLIP) & ~CONTENTS_BODY)
            }

            if trace.startsolid != 0 || trace.allsolid != 0 {
                return false
            }

            //Made it
            if Double(trace.fraction) == 1.0 {
                return true
            }

            if okToHitEntNum != ENTITYNUM_NONE && trace.entityNum == okToHitEntNum {
                return true
            }

            //Okay, didn't get all the way there, let's see if we got close enough:
            if NAV_HitNavGoal(`self`.r.currentOrigin, `self`.parent!.r.mins, `self`.parent!.r.maxs, trace.endpos, NPCInfo!.goalRadius, FlyingCreature(`self`.parent!)) {
                return true
            } else {
                if NAVDEBUG_showCollision {
                    if trace.entityNum < ENTITYNUM_WORLD && (g_entities[trace.entityNum] != nil) && g_entities[trace.entityNum].s.eType != ET_MOVER {
                        var p1 = vec3_t()
                        var p2 = vec3_t()
                        G_DrawEdge(point, trace.endpos, EDGE_PATH)
                        p1 = g_entities[trace.entityNum].r.mins + g_entities[trace.entityNum].r.currentOrigin
                        p2 = g_entities[trace.entityNum].r.maxs + g_entities[trace.entityNum].r.currentOrigin
                        G_CubeOutline(p1, p2, FRAMETIME, 0x0000ff, 0.5)
                    }
                    //FIXME: if it is a bmodel, light up the surf?
                }
            }
        } else {
            trap_Trace(trace, `self`.r.currentOrigin, mins, maxs, point, `self`.s.number, clipmask | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP)
            if trace.startsolid != 0 && (trace.contents & CONTENTS_BOTCLIP) != 0 {
                //started inside do not enter, so ignore them
                clipmask &= ~CONTENTS_BOTCLIP
                trap_Trace(trace, `self`.r.currentOrigin, mins, maxs, point, `self`.s.number, clipmask | CONTENTS_MONSTERCLIP)
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
            // Raven wrote: if( ( ( trace.startsolid == qfalse ) && ( trace.allsolid == qfalse ) ) && ( trace.fraction == 1.0f ) ) {//FIXME: check for drops return qtrue; }
            portMissing("NAV_ClearPathToPoint", source: "oracle/codemp/game/g_nav.c:222")

            if okToHitEntNum != ENTITYNUM_NONE && trace.entityNum == okToHitEntNum {
                return true
            }

            if NAVDEBUG_showCollision {
                if trace.entityNum < ENTITYNUM_WORLD && (g_entities[trace.entityNum] != nil) && g_entities[trace.entityNum].s.eType != ET_MOVER {
                    var p1 = vec3_t()
                    var p2 = vec3_t()
                    G_DrawEdge(`self`.r.currentOrigin, trace.endpos, EDGE_PATH)
                    p1 = g_entities[trace.entityNum].r.mins + g_entities[trace.entityNum].r.currentOrigin
                    p2 = g_entities[trace.entityNum].r.maxs + g_entities[trace.entityNum].r.currentOrigin
                    G_CubeOutline(p1, p2, FRAMETIME, 0x0000ff, 0.5)
                }
                //FIXME: if it is a bmodel, light up the surf?
            }
        }

        return false
    }
}

/// Source: oracle/codemp/game/g_nav.c:352
func NAV_FindClosestWaypointForEnt(_ ent: Entity, _ targWp: Int32) -> Int32 {
    //FIXME: Take the target into account
    return trap_Nav_GetNearestNode(ent, ent.waypoint, NF_CLEAR_PATH, targWp)
}

/// Source: oracle/codemp/game/g_nav.c:358
func NAV_FindClosestWaypointForPoint(_ ent: Entity, _ point: inout JKAShared.vec3_t) -> Int32 {
    let bestWP: Int32
    //FIXME: can we make this a static ent?
    let marker: Entity? = G_Spawn()

    if marker == nil {
        return WAYPOINT_NONE
    }

    G_SetOrigin(marker!, &point)

    marker!.r.mins = ent.r.mins //stepsize?
    marker!.r.maxs = ent.r.mins //crouching?

    marker!.clipmask = ent.clipmask
    marker!.waypoint = WAYPOINT_NONE

    bestWP = trap_Nav_GetNearestNode(marker!, marker!.waypoint, NF_CLEAR_PATH, WAYPOINT_NONE)

    G_FreeEntity(marker!)

    return bestWP
}

/// Source: oracle/codemp/game/g_nav.c:384
func NAV_FindClosestWaypointForPoint2(_ point: inout JKAShared.vec3_t) -> Int32 {
    let bestWP: Int32
    //FIXME: can we make this a static ent?
    let marker: Entity? = G_Spawn()

    if marker == nil {
        return WAYPOINT_NONE
    }

    G_SetOrigin(marker!, &point)

    marker!.r.mins = vec3_t(-16, -16, -6) //includes stepsize
    marker!.r.maxs = vec3_t(16, 16, 32)

    marker!.clipmask = MASK_NPCSOLID
    marker!.waypoint = WAYPOINT_NONE

    bestWP = trap_Nav_GetNearestNode(marker!, marker!.waypoint, NF_CLEAR_PATH, WAYPOINT_NONE)

    G_FreeEntity(marker!)

    return bestWP
}

/// Source: oracle/codemp/game/g_nav.c:416
func NAV_ClearBlockedInfo(_ `self`: Entity) {
    `self`.NPC!.aiFlags &= ~NPCAI_BLOCKED
    `self`.NPC!.blockingEntNum = ENTITYNUM_WORLD
}

/// Source: oracle/codemp/game/g_nav.c:428
func NAV_SetBlockedInfo(_ `self`: Entity, _ entId: Int32) {
    `self`.NPC!.aiFlags |= NPCAI_BLOCKED
    `self`.NPC!.blockingEntNum = entId
}

/// Source: oracle/codemp/game/g_nav.c:440
func NAV_Steer(_ `self`: Entity, _ dir: JKAShared.vec3_t, _ distance: Float) -> Int32 {
    var right_test = vec3_t()
    var left_test = vec3_t()
    var deviation = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in
        var right_push: Float = 0
        var left_push: Float = 0
        let right_ang: Float = dir[YAW] + 45
        let left_ang: Float = dir[YAW] - 45

        //Get the steering angles
        deviation = dir
        deviation[YAW] = right_ang

        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAV_Steer", source: "oracle/codemp/game/g_nav.c:440")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAV_Steer", source: "oracle/codemp/game/g_nav.c:440")
        var scratchUp = vec3_t()
        AngleVectors(deviation, &right_test, &scratchRight, &scratchUp)

        deviation[YAW] = left_ang

        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAV_Steer", source: "oracle/codemp/game/g_nav.c:440")
        var scratchRight2 = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAV_Steer", source: "oracle/codemp/game/g_nav.c:440")
        var scratchUp2 = vec3_t()
        AngleVectors(deviation, &left_test, &scratchRight2, &scratchUp2)

        //Find the end positions
        _VectorMA(`self`.r.currentOrigin, distance, right_test, &right_test)
        _VectorMA(`self`.r.currentOrigin, distance, left_test, &left_test)

        //Draw for debug purposes
        if NAVDEBUG_showCollision {
            G_DrawEdge(`self`.r.currentOrigin, right_test, EDGE_PATH)
            G_DrawEdge(`self`.r.currentOrigin, left_test, EDGE_PATH)
        }

        //Find the right influence
        NAV_CheckAhead(`self`, right_test, tr, `self`.clipmask | CONTENTS_BOTCLIP)

        right_push = -45 * (1.0 - tr.fraction)

        //Find the left influence
        NAV_CheckAhead(`self`, left_test, tr, `self`.clipmask | CONTENTS_BOTCLIP)

        left_push = 45 * (1.0 - tr.fraction)

        //Influence the mover to respond to the steering
        deviation = dir
        deviation[YAW] += (left_push + right_push)

        return Int32(deviation[YAW])
    }
}

/// Source: oracle/codemp/game/g_nav.c:494
func NAV_CheckAhead(_ `self`: Entity, _ end: JKAShared.vec3_t, _ trace: JKAMP.Trace, _ clipmask: Int32) -> Bool {
    var mins = vec3_t()
    let radius: Float
    let dist: Float
    let tFrac: Float
    // Raven assigns his own `clipmask` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var clipmask = clipmask

    //Offset the step height
    mins = vec3_t(`self`.r.mins[0], `self`.r.mins[1], `self`.r.mins[2] + STEPSIZE)

    trap_Trace(trace, `self`.r.currentOrigin, mins, `self`.r.maxs, end, `self`.s.number, clipmask)

    if trace.startsolid != 0 && (trace.contents & CONTENTS_BOTCLIP) != 0 {
        //started inside do not enter, so ignore them
        clipmask &= ~CONTENTS_BOTCLIP
        trap_Trace(trace, `self`.r.currentOrigin, mins, `self`.r.maxs, end, `self`.s.number, clipmask)
    }
    //Do a simple check
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
    // Raven wrote: if ( ( trace->allsolid == qfalse ) && ( trace->startsolid == qfalse ) && ( trace->fraction == 1.0f ) ) return qtrue
    portMissing("NAV_CheckAhead", source: "oracle/codemp/game/g_nav.c:494")

    //See if we're too far above
    if abs(`self`.r.currentOrigin[2] - end[2]) > 48 {
        return false
    }

    //This is a work around
    radius = (`self`.r.maxs[0] > `self`.r.maxs[1]) ? `self`.r.maxs[0] : `self`.r.maxs[1]
    dist = Distance(`self`.r.currentOrigin, end)
    tFrac = 1.0 - (radius / dist)

    if trace.fraction >= tFrac {
        return true
    }

    //Do a special check for doors
    if trace.entityNum < ENTITYNUM_WORLD {
        let blocker: Entity? = g_entities[trace.entityNum]

        // Port-note: No operator between the operands, the text there is ``.
        // Raven wrote: if VALIDSTRING( blocker->classname ) { if ( G_EntIsUnlockedDoor( blocker->s.number ) ) //if ( Q_stricmp( blocker->classname, "func_door" ) == 0 ) { //We're too close, try and avoid the door (most likely stuck on a lip) if ( DistanceSquared( self->r.currentOrigin, trace->endpos ) < MIN_DOOR_BLOCK_DIST_SQR ) return qfalse; return qtrue; } }
        portMissing("NAV_CheckAhead", source: "oracle/codemp/game/g_nav.c:494")
    }

    return false
}

/// Source: oracle/codemp/game/g_nav.c:555
private func NAV_TestBypass(_ `self`: Entity, _ yaw: Float, _ blocked_dist: Float, _ movedir: inout JKAShared.vec3_t) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var avoidAngles = vec3_t()
        var block_test = vec3_t()
        var block_pos = vec3_t()

        avoidAngles = vec3_t()
        avoidAngles[YAW] = yaw

        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAV_TestBypass", source: "oracle/codemp/game/g_nav.c:555")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NAV_TestBypass", source: "oracle/codemp/game/g_nav.c:555")
        var scratchUp = vec3_t()
        AngleVectors(avoidAngles, &block_test, &scratchRight, &scratchUp)
        _VectorMA(`self`.r.currentOrigin, blocked_dist, block_test, &block_pos)

        if NAVDEBUG_showCollision {
            G_DrawEdge(`self`.r.currentOrigin, block_pos, EDGE_BLOCKED)
        }

        //See if we're clear to move in that direction
        if NAV_CheckAhead(`self`, block_pos, tr, (`self`.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP) {
            movedir = block_test

            return true
        }

        return false
    }
}

/// Source: oracle/codemp/game/g_nav.c:589
func NAV_Bypass(_ `self`: Entity, _ blocker: Entity, _ blocked_dir: JKAShared.vec3_t, _ blocked_dist: Float, _ movedir: inout JKAShared.vec3_t) -> Bool {
    var dot: Float = 0
    var yaw: Float = 0
    var avoidRadius: Float = 0
    var arcAngle: Float = 0
    var right = vec3_t()

    //Draw debug info if requested
    if NAVDEBUG_showCollision {
        G_DrawEdge(`self`.r.currentOrigin, blocker.r.currentOrigin, EDGE_NORMAL)
    }

    // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("NAV_Bypass", source: "oracle/codemp/game/g_nav.c:589")
    var scratchForward = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("NAV_Bypass", source: "oracle/codemp/game/g_nav.c:589")
    var scratchUp = vec3_t()
    AngleVectors(`self`.r.currentAngles, &scratchForward, &right, &scratchUp)

    //Get the blocked direction
    yaw = vectoyaw(blocked_dir)

    //Get the avoid radius
    avoidRadius = sqrt((blocker.r.maxs[0] * blocker.r.maxs[0]) + (blocker.r.maxs[1] * blocker.r.maxs[1])) + sqrt((`self`.r.maxs[0] * `self`.r.maxs[0]) + (`self`.r.maxs[1] * `self`.r.maxs[1]))

    //See if we're inside our avoidance radius
    arcAngle = (blocked_dist <= avoidRadius) ? 135 : ((avoidRadius / blocked_dist) * 90)

    //FIXME: Although the below code will cause the NPC to take the "better" route, it can cause NPCs to become stuck on
    //		 one another in certain situations where both decide to take the same direction.

    //Check to see what dir the other guy is moving in (if any) and pick the opposite dir
    if blocker.client != nil && VectorCompare(blocker.client!.ps.velocity, vec3_origin) == 0 {
        var blocker_movedir = vec3_t()
        VectorNormalize2(blocker.client!.ps.velocity, &blocker_movedir)
        dot = _DotProduct(blocker_movedir, blocked_dir)
        if dot < 0.35 && dot > -0.35 {
            //he's moving to the side of me
            var block_pos = vec3_t()
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives nil where Raven's block falls through to its end.
            let earlyOut = Trace.scratch { tr -> Bool? in
                blocker_movedir = blocker_movedir * -1
                _VectorMA(`self`.r.currentOrigin, blocked_dist, blocker_movedir, &block_pos)
                if NAV_CheckAhead(`self`, block_pos, tr, (`self`.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP) {
                    movedir = blocker_movedir
                    return true
                }
                return nil
            }
            if let earlyOut {
                return earlyOut
            }
        }
    }

    //FIXME: this makes NPCs stack up and ping-pong like crazy.
    //			Need to keep track of this and stop trying after a while
    dot = _DotProduct(blocked_dir, right)

    //Go right on the first try if that works better
    if dot < 0.0 {
        arcAngle *= -1
    }

    //Test full, best position first
    if NAV_TestBypass(`self`, AngleNormalize360(yaw + arcAngle), blocked_dist, &movedir) {
        return true
    }

    //Try a smaller arc
    if NAV_TestBypass(`self`, AngleNormalize360(yaw + (arcAngle * 0.5)), blocked_dist, &movedir) {
        return true
    }

    //Try the other direction
    if NAV_TestBypass(`self`, AngleNormalize360(yaw + (arcAngle * -1)), blocked_dist, &movedir) {
        return true
    }

    //Try the other direction more precisely
    if NAV_TestBypass(`self`, AngleNormalize360(yaw + ((arcAngle * -1) * 0.5)), blocked_dist, &movedir) {
        return true
    }

    //Unable to go around
    return false
}

/// Source: oracle/codemp/game/g_nav.c:669
func NAV_MoveBlocker(_ `self`: Entity, _ shove_dir: JKAShared.vec3_t) -> Bool {
    //FIXME: This is a temporary method for making blockers move

    //FIXME: This will, of course, push blockers off of cliffs, into walls and all over the place

    var temp_dir = vec3_t()
    var forward = vec3_t()

    vectoangles(shove_dir, &temp_dir)

    temp_dir[YAW] += 45
    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("NAV_MoveBlocker", source: "oracle/codemp/game/g_nav.c:669")
    var scratchRight = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("NAV_MoveBlocker", source: "oracle/codemp/game/g_nav.c:669")
    var scratchUp = vec3_t()
    AngleVectors(temp_dir, &forward, &scratchRight, &scratchUp)

    `self`.client!.ps.velocity = forward * Float(SHOVE_SPEED)
    `self`.client!.ps.velocity[2] += SHOVE_LIFT

    //self->NPC->shoveDebounce = level.time + 100;

    return true
}

/// Source: oracle/codemp/game/g_nav.c:696
func NAV_ResolveBlock(_ `self`: Entity, _ blocker: Entity, _ blocked_dir: JKAShared.vec3_t) -> Bool {
    //Stop double waiting
    if blocker.NPC != nil && (blocker.NPC!.blockingEntNum == `self`.s.number) {
        return true
    }

    //For now, just complain about it
    NPC_Blocked(`self`, blocker)
    NPC_FaceEntity(blocker, true)

    return false
}

/// Source: oracle/codemp/game/g_nav.c:715
func NAV_TrueCollision(_ `self`: Entity, _ blocker: Entity, _ movedir: JKAShared.vec3_t, _ blocked_dir: inout JKAShared.vec3_t) -> Bool {
    var velocityDir = vec3_t()
    let speed: Float
    let dot: Float
    var testPos = vec3_t()
    var ptmins = vec3_t()
    var ptmaxs = vec3_t()
    var tmins = vec3_t()
    var tmaxs = vec3_t()

    //TODO: Handle all ents
    if blocker.client == nil {
        return false
    }

    //Get the player's move direction and speed
    speed = VectorNormalize2(`self`.client!.ps.velocity, &velocityDir)

    //See if it's even feasible
    dot = _DotProduct(movedir, velocityDir)

    if Double(dot) < 0.85 {
        return false
    }

    _VectorMA(`self`.r.currentOrigin, speed * FRAMETIME, velocityDir, &testPos)

    tmins = blocker.r.currentOrigin + blocker.r.mins
    tmaxs = blocker.r.currentOrigin + blocker.r.maxs

    ptmins = testPos + `self`.r.mins
    ptmaxs = testPos + `self`.r.maxs

    if G_BoundsOverlap(ptmins, ptmaxs, tmins, tmaxs) {
        blocked_dir = velocityDir
        return true
    }

    return false
}

/// Source: oracle/codemp/game/g_nav.c:758
func NAV_StackedCanyon(_ `self`: Entity, _ blocker: Entity, _ pathDir: JKAShared.vec3_t) -> Bool {
    var perp = vec3_t()
    var cross = vec3_t()
    var test = vec3_t()
    var avoidRadius: Float = 0
    var extraClip: Int32 = CONTENTS_BOTCLIP
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in

        PerpendicularVector(&perp, pathDir)
        CrossProduct(pathDir, perp, &cross)

        avoidRadius = sqrt((blocker.r.maxs[0] * blocker.r.maxs[0]) + (blocker.r.maxs[1] * blocker.r.maxs[1])) + sqrt((`self`.r.maxs[0] * `self`.r.maxs[0]) + (`self`.r.maxs[1] * `self`.r.maxs[1]))

        _VectorMA(blocker.r.currentOrigin, avoidRadius, cross, &test)

        trap_Trace(tr, test, `self`.r.mins, `self`.r.maxs, test, `self`.s.number, `self`.clipmask | extraClip)
        if tr.startsolid != 0 && (tr.contents & CONTENTS_BOTCLIP) != 0 {
            //started inside do not enter, so ignore them
            extraClip &= ~CONTENTS_BOTCLIP
            trap_Trace(tr, test, `self`.r.mins, `self`.r.maxs, test, `self`.s.number, `self`.clipmask | extraClip)
        }

        if NAVDEBUG_showCollision {
            var mins = vec3_t()
            var maxs = vec3_t()
            var RED = vec3_t(1.0, 0.0, 0.0)

            mins = test + `self`.r.mins
            maxs = test + `self`.r.maxs
            G_Cube(mins, maxs, RED, 0.25)
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
        // Raven wrote: if ( tr.startsolid == qfalse && tr.allsolid == qfalse ) return qfalse
        portMissing("NAV_StackedCanyon", source: "oracle/codemp/game/g_nav.c:758")

        _VectorMA(blocker.r.currentOrigin, -avoidRadius, cross, &test)

        trap_Trace(tr, test, `self`.r.mins, `self`.r.maxs, test, `self`.s.number, `self`.clipmask | extraClip)
        if tr.startsolid != 0 && (tr.contents & CONTENTS_BOTCLIP) != 0 {
            //started inside do not enter, so ignore them
            extraClip &= ~CONTENTS_BOTCLIP
            trap_Trace(tr, test, `self`.r.mins, `self`.r.maxs, test, `self`.s.number, `self`.clipmask | extraClip)
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
        // Raven wrote: if ( tr.startsolid == qfalse && tr.allsolid == qfalse ) return qfalse
        portMissing("NAV_StackedCanyon", source: "oracle/codemp/game/g_nav.c:758")

        if NAVDEBUG_showCollision {
            var mins = vec3_t()
            var maxs = vec3_t()
            var RED = vec3_t(1.0, 0.0, 0.0)

            mins = test + `self`.r.mins
            maxs = test + `self`.r.maxs
            G_Cube(mins, maxs, RED, 0.25)
        }

        return true
    }
}

/// Source: oracle/codemp/game/g_nav.c:824
func NAV_ResolveEntityCollision(_ `self`: Entity, _ blocker: Entity, _ movedir: inout JKAShared.vec3_t, _ pathDir: JKAShared.vec3_t) -> Bool {
    var blocked_dir = vec3_t()
    let blocked_dist: Float

    //Doors are ignored
    if G_EntIsUnlockedDoor(blocker.s.number) {
        if DistanceSquared(`self`.r.currentOrigin, blocker.r.currentOrigin) > MIN_DOOR_BLOCK_DIST_SQR {
            return true
        }
    }

    blocked_dir = blocker.r.currentOrigin - `self`.r.currentOrigin
    blocked_dist = VectorNormalize(&blocked_dir)

    //Make sure an actual collision is going to happen
    //	if ( NAV_PredictCollision( self, blocker, movedir, blocked_dir ) == qfalse )
    //		return qtrue;

    //See if we can get around the blocker at all (only for player!)
    if blocker.s.number == 0 {
        if NAV_StackedCanyon(`self`, blocker, pathDir) {
            NPC_Blocked(`self`, blocker)
            NPC_FaceEntity(blocker, true)

            return false
        }
    }

    //First, attempt to walk around the blocker
    if NAV_Bypass(`self`, blocker, blocked_dir, blocked_dist, &movedir) {
        return true
    }

    //Second, attempt to calculate a good move position for the blocker
    if NAV_ResolveBlock(`self`, blocker, blocked_dir) {
        return true
    }

    return false
}

/// Source: oracle/codemp/game/g_nav.c:873
func NAV_TestForBlocked(_ `self`: Entity, _ goal: Entity, _ blocker: Entity, _ distance: Float, _ flags: inout Int32) -> Bool {
    if goal == nil {
        return false
    }

    if blocker.s.eType == ET_ITEM {
        return false
    }

    if NAV_HitNavGoal(blocker.r.currentOrigin, blocker.r.mins, blocker.r.maxs, goal.r.currentOrigin, 12, false) {
        flags |= NIF_BLOCKED

        if distance <= MIN_STOP_DIST {
            NPC_Blocked(`self`, blocker)
            NPC_FaceEntity(blocker, true)
            return true
        }
    }

    return false
}

/// Source: oracle/codemp/game/g_nav.c:902
func NAV_AvoidCollision(_ `self`: Entity, _ goal: Entity, _ info: NavInfo) -> Bool {
    var movedir = vec3_t()
    var movepos = vec3_t()

    //Clear our block info for this frame
    NAV_ClearBlockedInfo(NPC!)

    //Cap our distance
    if info.distance > MAX_COLL_AVOID_DIST {
        info.distance = Float(MAX_COLL_AVOID_DIST)
    }

    //Get an end position
    _VectorMA(`self`.r.currentOrigin, info.distance, info.direction, &movepos)
    movedir = info.direction

    if `self`.NPC != nil && (`self`.NPC!.aiFlags & NPCAI_NO_COLL_AVOID) != 0 {
        //pretend there's no-one in the way
        return true
    }
    //Now test against entities
    if NAV_CheckAhead(`self`, movepos, info.trace, CONTENTS_BODY) == false {
        //Get the blocker
        info.blocker = g_entities[info.trace.entityNum]
        info.flags |= NIF_COLLISION

        //Ok to hit our goal entity
        if goal == info.blocker {
            return true
        }

        //See if we're moving along with them
        //if ( NAV_TrueCollision( self, info.blocker, movedir, info.direction ) == qfalse )
        //	return qtrue;

        //Test for blocking by standing on goal
        if NAV_TestForBlocked(`self`, goal, info.blocker!, info.distance, &info.flags) == true {
            return false
        }

        //If the above function said we're blocked, don't do the extra checks
        if (info.flags & NIF_BLOCKED) != 0 {
            return true
        }

        //See if we can get that entity to move out of our way
        if NAV_ResolveEntityCollision(`self`, info.blocker!, &movedir, info.pathDirection) == false {
            return false
        }

        info.direction = movedir

        return true
    }

    //Our path is clear, just move there
    if NAVDEBUG_showCollision {
        G_DrawEdge(`self`.r.currentOrigin, movepos, EDGE_PATH)
    }

    return true
}

/// Source: oracle/codemp/game/g_nav.c:971
func NAV_TestBestNode(_ `self`: Entity, _ startID: Int32, _ endID: Int32, _ failEdge: Bool) -> Int32 {
    //check only against architectrure
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Int32 in
        var mins = vec3_t()
        var clipmask: Int32 = (NPC!.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP

        //get the position for the test choice
        trap_Nav_GetNodePosition(endID, &end)

        //Offset the step height
        mins = vec3_t(`self`.r.mins[0], `self`.r.mins[1], `self`.r.mins[2] + STEPSIZE)

        trap_Trace(trace, `self`.r.currentOrigin, mins, `self`.r.maxs, end, `self`.s.number, clipmask)

        if trace.startsolid != 0 && (trace.contents & CONTENTS_BOTCLIP) != 0 {
            //started inside do not enter, so ignore them
            clipmask &= ~CONTENTS_BOTCLIP
            trap_Trace(trace, `self`.r.currentOrigin, mins, `self`.r.maxs, end, `self`.s.number, clipmask)
        }
        //Do a simple check
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Int32' and 'Bool'".
        // Raven wrote: if ( ( trace.allsolid == qfalse ) && ( trace.startsolid == qfalse ) && ( trace.fraction == 1.0f ) ) {//it's clear return endID; }
        portMissing("NAV_TestBestNode", source: "oracle/codemp/game/g_nav.c:971")

        //See if we're too far above
        if `self`.s.weapon != WP_SABER && abs(`self`.r.currentOrigin[2] - end[2]) > 48 {
        } else {
            //This is a work around
            let radius: Float = (`self`.r.maxs[0] > `self`.r.maxs[1]) ? `self`.r.maxs[0] : `self`.r.maxs[1]
            let dist: Float = Distance(`self`.r.currentOrigin, end)
            let tFrac: Float = 1.0 - (radius / dist)

            if trace.fraction >= tFrac {
                //it's clear
                return endID
            }
        }

        //Do a special check for doors
        if trace.entityNum < ENTITYNUM_WORLD {
            let blocker: Entity? = g_entities[trace.entityNum]

            // Port-note: No operator between the operands, the text there is ``.
            // Raven wrote: if VALIDSTRING( blocker->classname ) {//special case: doors are architecture, but are dynamic, like entitites if ( G_EntIsUnlockedDoor( blocker->s.number ) ) //if ( Q_stricmp( blocker->classname, "func_door" ) == 0 ) {//it's unlocked, go for it //We're too close, try and avoid the door (most likely stuck on a lip) if ( DistanceSquared( self->r.currentOrigin, trace.endpos ) < MIN_DOOR_BLOCK_DIST_SQR ) { return startID; } //we can keep heading to the door, it should open if ( self->s.weapon != WP_SABER && fabs( self->r.currentOrigin[2] - end[2] ) > 48 ) {//too far above } else { return endID; } } else if ( G_EntIsDoor( blocker->s.number ) ) {//a locked door! //path is blocked by a locked door, mark it as such if instructed to do so if ( failEdge ) { trap_Nav_AddFailedEdge( self->s.number, startID, endID ); } } else if ( G_EntIsBreakable( blocker->s.number ) ) {//do same for breakable brushes/models/glass? //path is blocked by a breakable, mark it as such if instructed to do so if ( failEdge ) { trap_Nav_AddFailedEdge( self->s.number, startID, endID ); } } else if ( G_EntIsRemovableUsable( blocker->s.number ) ) {//and removable usables //path is blocked by a removable usable, mark it as such if instructed to do so if ( failEdge ) { trap_Nav_AddFailedEdge( self->s.number, startID, endID ); } } else if ( blocker->targetname && blocker->s.solid == SOLID_BMODEL && ((blocker->r.contents&CONTENTS_MONSTERCLIP)|| (blocker->r.contents&CONTENTS_BOTCLIP)) ) {//some other kind of do not enter entity brush that will probably be removed //path is blocked by a removable brushent, mark it as such if instructed to do so if ( failEdge ) { trap_Nav_AddFailedEdge( self->s.number, startID, endID ); } } }
            portMissing("NAV_TestBestNode", source: "oracle/codemp/game/g_nav.c:971")
        }
        //path is blocked
        //use the fallback choice
        return startID
    }
}

/// Source: oracle/codemp/game/g_nav.c:1083
func NAV_GetNearestNode(_ `self`: Entity, _ lastNode: Int32) -> Int32 {
    return trap_Nav_GetNearestNode(`self`, lastNode, NF_CLEAR_PATH, WAYPOINT_NONE)
}

/// Source: oracle/codemp/game/g_nav.c:1094
func NAV_MicroError(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) -> Bool {
    if VectorCompare(start, end) != 0 {
        if DistanceSquared(NPC!.r.currentOrigin, start) < (8 * 8) {
            return true
        }
    }

    return false
}

/// Source: oracle/codemp/game/g_nav.c:1113
func NAV_MoveToGoal(_ `self`: Entity, _ info: NavInfo) -> Int32 {
    var bestNode: Int32
    var origin = vec3_t()
    var end = vec3_t()

    //Must have a goal entity to move there
    if `self`.NPC!.goalEntity == nil {
        return WAYPOINT_NONE
    }

    //Check special player optimizations
    if `self`.NPC!.goalEntity!.s.number == 0 {
        //If we couldn't find the point, then we won't be able to this turn
        if `self`.NPC!.goalEntity!.waypoint == WAYPOINT_NONE {
            return WAYPOINT_NONE
        }

        //NOTENOTE: Otherwise trust this waypoint for the whole frame (reduce all unnecessary calculations)
    } else {
        //Find the target's waypoint
        // Port-note: An assignment inside an expression.
        // Raven wrote: if ( ( self->NPC->goalEntity->waypoint = NAV_GetNearestNode( self->NPC->goalEntity, self->NPC->goalEntity->waypoint ) ) == WAYPOINT_NONE ) return WAYPOINT_NONE
        portMissing("NAV_MoveToGoal", source: "oracle/codemp/game/g_nav.c:1113")
    }

    //Find our waypoint
    // Port-note: An assignment inside an expression.
    // Raven wrote: if ( ( self->waypoint = NAV_GetNearestNode( self, self->lastWaypoint ) ) == WAYPOINT_NONE ) return WAYPOINT_NONE
    portMissing("NAV_MoveToGoal", source: "oracle/codemp/game/g_nav.c:1113")

    bestNode = trap_Nav_GetBestNode(`self`.waypoint, `self`.NPC!.goalEntity!.waypoint, NODE_NONE)

    if bestNode == WAYPOINT_NONE {
        if NAVDEBUG_showEnemyPath {
            var origin = vec3_t()
            var torigin = vec3_t()

            trap_Nav_GetNodePosition(`self`.NPC!.goalEntity!.waypoint, &torigin)
            trap_Nav_GetNodePosition(`self`.waypoint, &origin)

            G_DrawNode(torigin, NODE_GOAL)
            G_DrawNode(origin, NODE_GOAL)
            G_DrawNode(`self`.NPC!.goalEntity!.r.currentOrigin, NODE_START)
        }

        return WAYPOINT_NONE
    }

    //Check this node
    bestNode = NAV_TestBestNode(`self`, bestNode, `self`.NPC!.goalEntity!.waypoint, false)

    //trace_t	trace;

    //Get this position
    trap_Nav_GetNodePosition(bestNode, &origin)
    trap_Nav_GetNodePosition(`self`.waypoint, &end)

    //Basically, see if the path we have isn't helping
    //if ( NAV_MicroError( origin, end ) )
    //	return WAYPOINT_NONE;

    //Test the path connection from our current position to the best node
    if NAV_CheckAhead(`self`, origin, info.trace, (`self`.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP) == false {
        //First attempt to move to the closest point on the line between the waypoints
        G_FindClosestPointOnLineSegment(origin, end, `self`.r.currentOrigin, &origin)

        //See if we can go there
        if NAV_CheckAhead(`self`, origin, info.trace, (`self`.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP) == false {
            //Just move towards our current waypoint
            bestNode = `self`.waypoint
            trap_Nav_GetNodePosition(bestNode, &origin)
        }
    }

    //Setup our new move information
    info.direction = origin - `self`.r.currentOrigin
    info.distance = VectorNormalize(&info.direction)

    info.pathDirection = end - origin
    VectorNormalize(&info.pathDirection)

    //Draw any debug info, if requested
    if NAVDEBUG_showEnemyPath {
        var dest = vec3_t()
        var start = vec3_t()

        //Get the positions
        trap_Nav_GetNodePosition(`self`.NPC!.goalEntity!.waypoint, &dest)
        trap_Nav_GetNodePosition(bestNode, &start)

        //Draw the route
        G_DrawNode(start, NODE_START)
        G_DrawNode(dest, NODE_GOAL)
        trap_Nav_ShowPath(`self`.waypoint, `self`.NPC!.goalEntity!.waypoint)
    }

    return bestNode
}

/// Source: oracle/codemp/game/g_nav.c:1220
func waypoint_testDirection(_ origin: JKAShared.vec3_t, _ yaw: Float, _ minDist: UInt32) -> UInt32 {
    var trace_dir = vec3_t()
    var test_pos = vec3_t()
    var maxs = vec3_t()
    var mins = vec3_t()
    var angles = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> UInt32 in

        //Setup the mins and max
        maxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))
        mins = vec3_t(-15, -15, Float(DEFAULT_MINS_2 + STEPSIZE))

        //Get our test direction
        angles = vec3_t(0, yaw, 0)
        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("waypoint_testDirection", source: "oracle/codemp/game/g_nav.c:1220")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("waypoint_testDirection", source: "oracle/codemp/game/g_nav.c:1220")
        var scratchUp = vec3_t()
        AngleVectors(angles, &trace_dir, &scratchRight, &scratchUp)

        //Move ahead
        //	VectorMA( origin, MAX_RADIUS_CHECK, trace_dir, test_pos );
        _VectorMA(origin, Float(minDist), trace_dir, &test_pos)

        trap_Trace(tr, origin, mins, maxs, test_pos, ENTITYNUM_NONE, (CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP))

        //return (unsigned int) ( (float) MAX_RADIUS_CHECK * tr.fraction );
        return UInt32((Float(minDist) * tr.fraction))
    }
}

/// Source: oracle/codemp/game/g_nav.c:1251
func waypoint_getRadius(_ ent: Entity) -> UInt32 {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to specified type 'UInt32'".
    // Raven wrote: unsigned int minDist = MAX_RADIUS_CHECK + 1;
    portMissing("waypoint_getRadius", source: "oracle/codemp/game/g_nav.c:1251")
    var dist: UInt32
    var i: Int32

    i = 0
    while i < YAW_ITERATIONS {
        // Port-note: A read of `minDist`, a local the draft left as a hole.
        // Raven wrote: dist = waypoint_testDirection( ent->r.currentOrigin, ((360.0f/YAW_ITERATIONS) * i), minDist )
        portMissing("waypoint_getRadius", source: "oracle/codemp/game/g_nav.c:1251")

        // Port-note: A read of `minDist`, a local the draft left as a hole.
        // Raven wrote: if ( dist < minDist ) minDist = dist
        portMissing("waypoint_getRadius", source: "oracle/codemp/game/g_nav.c:1251")
        i += 1
    }

    // Port-note: A read of `minDist`, a local the draft left as a hole.
    // Raven wrote: return minDist
    portMissing("waypoint_getRadius", source: "oracle/codemp/game/g_nav.c:1251")
}

/**
```
QUAKED waypoint  (0.7 0.7 0) (-16 -16 -24) (16 16 32) SOLID_OK
a place to go.

SOLID_OK - only use if placing inside solid is unavoidable in map, but may be clear in-game (ie: at the bottom of a tall, solid lift that starts at the top position)

radius is automatically calculated in-world.
```
*/
/// Source: oracle/codemp/game/g_nav.c:1275
func SP_waypoint(_ ent: Entity) {
    if navCalculatePaths {
        let radius: UInt32

        ent.r.mins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
        ent.r.maxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))

        ent.r.contents = CONTENTS_TRIGGER
        ent.clipmask = MASK_DEADSOLID

        trap_LinkEntity(ent)

        ent.count = -1
        ent.classname = "waypoint"

        if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, true) {
            //if not SOLID_OK, and in solid
            ent.r.maxs[2] = Float(CROUCH_MAXS_2)
            if G_CheckInSolid(ent, true) {
                Com_Printf(S_COLOR_RED + "ERROR: Waypoint %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
                G_FreeEntity(ent)
                return
            }
        }

        radius = waypoint_getRadius(ent)

        ent.health = trap_Nav_AddRawPoint(&ent.r.currentOrigin, ent.spawnflags, Int32(bitPattern: radius))
        NAV_StoreWaypoint(ent)
        G_FreeEntity(ent)
        return
    }

    G_FreeEntity(ent)
}

/**
```
QUAKED waypoint_small  (0.7 0.7 0) (-2 -2 -24) (2 2 32) SOLID_OK
SOLID_OK - only use if placing inside solid is unavoidable in map, but may be clear in-game (ie: at the bottom of a tall, solid lift that starts at the top position)
```
*/
/// Source: oracle/codemp/game/g_nav.c:1318
func SP_waypoint_small(_ ent: Entity) {
    if navCalculatePaths {
        ent.r.mins = vec3_t(-2, -2, Float(DEFAULT_MINS_2))
        ent.r.maxs = vec3_t(2, 2, Float(DEFAULT_MAXS_2))

        ent.r.contents = CONTENTS_TRIGGER
        ent.clipmask = MASK_DEADSOLID

        trap_LinkEntity(ent)

        ent.count = -1
        ent.classname = "waypoint"

        if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, true) {
            ent.r.maxs[2] = Float(CROUCH_MAXS_2)
            if G_CheckInSolid(ent, true) {
                Com_Printf(S_COLOR_RED + "ERROR: Waypoint_small %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
                G_FreeEntity(ent)
                return
            }
        }

        ent.health = trap_Nav_AddRawPoint(&ent.r.currentOrigin, ent.spawnflags, 2)
        NAV_StoreWaypoint(ent)
        G_FreeEntity(ent)
        return
    }

    G_FreeEntity(ent)
}

/// Source: oracle/codemp/game/g_nav.c:1370
func SP_waypoint_navgoal(_ ent: Entity) {
    let radius: Int32 = ent.radius != 0 ? ((Int32(ent.radius)) | NAVGOAL_USE_RADIUS) : 12

    ent.r.mins = vec3_t(-16, -16, -24)
    ent.r.maxs = vec3_t(16, 16, 32)
    ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.125)
    if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, false) {
        Com_Printf(S_COLOR_RED + "ERROR: Waypoint_navgoal %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
    }
    TAG_Add(ent.targetname!, nil, ent.s.origin, ent.s.angles, radius, RTF_NAVGOAL)

    ent.classname = "navgoal"
    G_FreeEntity(ent) //can't do this, they need to be found later by some functions, though those could be fixed, maybe?
}

/**
```
QUAKED waypoint_navgoal_8 (0.3 1 0.3) (-8 -8 -24) (8 8 32) SOLID_OK
A waypoint for script navgoals, 8 x 8 size
Not included in navigation data

SOLID_OK - only use if placing inside solid is unavoidable in map, but may be clear in-game (ie: at the bottom of a tall, solid lift that starts at the top position)

targetname - name you would use in script when setting a navgoal (like so:)

  For example: if you give this waypoint a targetname of "console", make an NPC go to it in a script like so:

  set ("navgoal", "console");

You CANNOT set a radius on these navgoals, they are touch-reach ONLY
```
*/
/// Source: oracle/codemp/game/g_nav.c:1402
func SP_waypoint_navgoal_8(_ ent: Entity) {
    ent.r.mins = vec3_t(-8, -8, -24)
    ent.r.maxs = vec3_t(8, 8, 32)
    ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.125)
    if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, false) {
        Com_Printf(S_COLOR_RED + "ERROR: Waypoint_navgoal_8 %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
    }

    TAG_Add(ent.targetname!, nil, ent.s.origin, ent.s.angles, 8, RTF_NAVGOAL)

    ent.classname = "navgoal"
    G_FreeEntity(ent) //can't do this, they need to be found later by some functions, though those could be fixed, maybe?
}

/**
```
QUAKED waypoint_navgoal_4 (0.3 1 0.3) (-4 -4 -24) (4 4 32) SOLID_OK
A waypoint for script navgoals, 4 x 4 size
Not included in navigation data

SOLID_OK - only use if placing inside solid is unavoidable in map, but may be clear in-game (ie: at the bottom of a tall, solid lift that starts at the top position)

targetname - name you would use in script when setting a navgoal (like so:)

  For example: if you give this waypoint a targetname of "console", make an NPC go to it in a script like so:

  set ("navgoal", "console");

You CANNOT set a radius on these navgoals, they are touch-reach ONLY
```
*/
/// Source: oracle/codemp/game/g_nav.c:1433
func SP_waypoint_navgoal_4(_ ent: Entity) {
    ent.r.mins = vec3_t(-4, -4, -24)
    ent.r.maxs = vec3_t(4, 4, 32)
    ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.125)
    if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, false) {
        Com_Printf(S_COLOR_RED + "ERROR: Waypoint_navgoal_4 %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
    }

    TAG_Add(ent.targetname!, nil, ent.s.origin, ent.s.angles, 4, RTF_NAVGOAL)

    ent.classname = "navgoal"
    G_FreeEntity(ent) //can't do this, they need to be found later by some functions, though those could be fixed, maybe?
}

/**
```
QUAKED waypoint_navgoal_2 (0.3 1 0.3) (-2 -2 -24) (2 2 32) SOLID_OK
A waypoint for script navgoals, 2 x 2 size
Not included in navigation data

SOLID_OK - only use if placing inside solid is unavoidable in map, but may be clear in-game (ie: at the bottom of a tall, solid lift that starts at the top position)

targetname - name you would use in script when setting a navgoal (like so:)

  For example: if you give this waypoint a targetname of "console", make an NPC go to it in a script like so:

  set ("navgoal", "console");

You CANNOT set a radius on these navgoals, they are touch-reach ONLY
```
*/
/// Source: oracle/codemp/game/g_nav.c:1464
func SP_waypoint_navgoal_2(_ ent: Entity) {
    ent.r.mins = vec3_t(-2, -2, -24)
    ent.r.maxs = vec3_t(2, 2, 32)
    ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.125)
    if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, false) {
        Com_Printf(S_COLOR_RED + "ERROR: Waypoint_navgoal_2 %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
    }

    TAG_Add(ent.targetname!, nil, ent.s.origin, ent.s.angles, 2, RTF_NAVGOAL)

    ent.classname = "navgoal"
    G_FreeEntity(ent) //can't do this, they need to be found later by some functions, though those could be fixed, maybe?
}

/**
```
QUAKED waypoint_navgoal_1 (0.3 1 0.3) (-1 -1 -24) (1 1 32) SOLID_OK
A waypoint for script navgoals, 1 x 1 size
Not included in navigation data

SOLID_OK - only use if placing inside solid is unavoidable in map, but may be clear in-game (ie: at the bottom of a tall, solid lift that starts at the top position)

targetname - name you would use in script when setting a navgoal (like so:)

  For example: if you give this waypoint a targetname of "console", make an NPC go to it in a script like so:

  set ("navgoal", "console");

You CANNOT set a radius on these navgoals, they are touch-reach ONLY
```
*/
/// Source: oracle/codemp/game/g_nav.c:1495
func SP_waypoint_navgoal_1(_ ent: Entity) {
    ent.r.mins = vec3_t(-1, -1, -24)
    ent.r.maxs = vec3_t(1, 1, 32)
    ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.125)
    if !((ent.spawnflags & 1) != 0) && G_CheckInSolid(ent, false) {
        Com_Printf(S_COLOR_RED + "ERROR: Waypoint_navgoal_1 %s at %s in solid!\n", ent.targetname!, vtos(ent.r.currentOrigin))
    }

    TAG_Add(ent.targetname!, nil, ent.s.origin, ent.s.angles, 1, RTF_NAVGOAL)

    ent.classname = "navgoal"
    G_FreeEntity(ent) //can't do this, they need to be found later by some functions, though those could be fixed, maybe?
}

/// Source: oracle/codemp/game/g_nav.c:1518
func Svcmd_Nav_f() {
    var cmd = CharBuf(1024)
    strcpy(&cmd, trap_Argv(1, 1024))

    if Q_stricmp(cmd, "show") == 0 {
        strcpy(&cmd, trap_Argv(2, 1024))

        if Q_stricmp(cmd, "all") == 0 {
            NAVDEBUG_showNodes = !NAVDEBUG_showNodes

            //NOTENOTE: This causes the two states to sync up if they aren't already
            NAVDEBUG_showRadius = NAVDEBUG_showNodes
            NAVDEBUG_showEdges = NAVDEBUG_showRadius
            NAVDEBUG_showEnemyPath = NAVDEBUG_showEdges
            NAVDEBUG_showCombatPoints = NAVDEBUG_showEnemyPath
            NAVDEBUG_showNavGoals = NAVDEBUG_showCombatPoints
            NAVDEBUG_showCollision = NAVDEBUG_showNavGoals
        } else if Q_stricmp(cmd, "nodes") == 0 {
            NAVDEBUG_showNodes = !NAVDEBUG_showNodes
        } else if Q_stricmp(cmd, "radius") == 0 {
            NAVDEBUG_showRadius = !NAVDEBUG_showRadius
        } else if Q_stricmp(cmd, "edges") == 0 {
            NAVDEBUG_showEdges = !NAVDEBUG_showEdges
        } else if Q_stricmp(cmd, "testpath") == 0 {
            NAVDEBUG_showTestPath = !NAVDEBUG_showTestPath
        } else if Q_stricmp(cmd, "enemypath") == 0 {
            NAVDEBUG_showEnemyPath = !NAVDEBUG_showEnemyPath
        } else if Q_stricmp(cmd, "combatpoints") == 0 {
            NAVDEBUG_showCombatPoints = !NAVDEBUG_showCombatPoints
        } else if Q_stricmp(cmd, "navgoals") == 0 {
            NAVDEBUG_showNavGoals = !NAVDEBUG_showNavGoals
        } else if Q_stricmp(cmd, "collision") == 0 {
            NAVDEBUG_showCollision = !NAVDEBUG_showCollision
        }
    } else if Q_stricmp(cmd, "set") == 0 {
        strcpy(&cmd, trap_Argv(2, 1024))

        if Q_stricmp(cmd, "testgoal") == 0 {
            NAVDEBUG_curGoal = trap_Nav_GetNearestNode(g_entities[0], g_entities[0].waypoint, NF_CLEAR_PATH, WAYPOINT_NONE)
        }
    } else if Q_stricmp(cmd, "totals") == 0 {
        Com_Printf("Navigation Totals:\n")
        Com_Printf("------------------\n")
        Com_Printf("Total Nodes:         %d\n", trap_Nav_GetNumNodes())
        Com_Printf("Total Combat Points: %d\n", level.numCombatPoints)
    } else {
        //Print the available commands
        Com_Printf("nav - valid commands\n---\n")
        Com_Printf("show\n - nodes\n - edges\n - testpath\n - enemypath\n - combatpoints\n - navgoals\n---\n")
        Com_Printf("set\n - testgoal\n---\n")
    }
}

/// Source: oracle/codemp/game/g_nav.c:1618
func NAV_WaypointsTooFar(_ wp1: Entity, _ wp2: Entity) -> Bool {
    if Distance(wp1.r.currentOrigin, wp2.r.currentOrigin) > 1024 {
        var temp = CharBuf(1024)
        let len: Int32
        fatalErrors += 1
        if wp1.targetname == nil && wp2.targetname == nil {
            Com_sprintf(&temp, Int32((temp).count), S_COLOR_RED + "Waypoint conn %s->%s > 1024\n", vtos(wp1.r.currentOrigin), vtos(wp2.r.currentOrigin))
        } else if wp1.targetname == nil {
            Com_sprintf(&temp, Int32((temp).count), S_COLOR_RED + "Waypoint conn %s->%s > 1024\n", vtos(wp1.r.currentOrigin), wp2.targetname!)
        } else if wp2.targetname == nil {
            Com_sprintf(&temp, Int32((temp).count), S_COLOR_RED + "Waypoint conn %s->%s > 1024\n", wp1.targetname!, vtos(wp2.r.currentOrigin))
        } else {
            //they both have valid targetnames
            Com_sprintf(&temp, Int32((temp).count), S_COLOR_RED + "Waypoint conn %s->%s > 1024\n", wp1.targetname!, wp2.targetname!)
        }
        len = strlen(temp)
        // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '-' on 'SIMD' requires that 'CharBuf' conform to 'SIMD'".
        // Raven wrote: if ( (fatalErrorPointer-fatalErrorString)+len >= sizeof( fatalErrorString ) ) { Com_Error( ERR_DROP, "%s%s%dTOO MANY FATAL NAV ERRORS!!!\n", fatalErrorString, temp, fatalErrors ); return qtrue; }
        portMissing("NAV_WaypointsTooFar", source: "oracle/codemp/game/g_nav.c:1618")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String' to expected argument type 'CharBuf'".
        // Raven wrote: strcat( fatalErrorPointer, temp )
        portMissing("NAV_WaypointsTooFar", source: "oracle/codemp/game/g_nav.c:1618")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'String'".
        // Raven wrote: fatalErrorPointer += len
        portMissing("NAV_WaypointsTooFar", source: "oracle/codemp/game/g_nav.c:1618")
        return true
    } else {
        return false
    }
}

/// Source: oracle/codemp/game/g_nav.c:1663
func NAV_ClearStoredWaypoints() {
    numStoredWaypoints = 0
}

/// Source: oracle/codemp/game/g_nav.c:1669
func NAV_StoreWaypoint(_ ent: Entity) {
    /*
    if ( !tempWaypointList )
    {
    //tempWaypointList = (waypointData_t *) gi.Malloc(sizeof(waypointData_t)*MAX_STORED_WAYPOINTS, TAG_TEMP_WORKSPACE, qtrue);

    int size = sizeof(waypointData_t)*MAX_STORED_WAYPOINTS;
    trap_TrueMalloc((void **)&tempWaypointList, size);
    memset(tempWaypointList, 0, size);
    }
    */

    if numStoredWaypoints >= MAX_STORED_WAYPOINTS {
        //G_Error( "Too many waypoints!  (%d > %d)\n", numStoredWaypoints, MAX_STORED_WAYPOINTS );
        //rwwFIXMEFIXME: commented this out so I can load some of the SP levels.
        return
    }
    if ent.targetname != nil {
        Q_strncpyz(&tempWaypointList[numStoredWaypoints].targetnameBuffer, ent.targetname!, MAX_QPATH)
    }
    if ent.target != nil {
        Q_strncpyz(&tempWaypointList[numStoredWaypoints].targetBuffer, ent.target!, MAX_QPATH)
    }
    if ent.target2 != nil {
        Q_strncpyz(&tempWaypointList[numStoredWaypoints].target2Buffer, ent.target2!, MAX_QPATH)
    }
    if ent.target3 != nil {
        Q_strncpyz(&tempWaypointList[numStoredWaypoints].target3Buffer, ent.target3!, MAX_QPATH)
    }
    if ent.target4 != nil {
        Q_strncpyz(&tempWaypointList[numStoredWaypoints].target4Buffer, ent.target4!, MAX_QPATH)
    }
    tempWaypointList[numStoredWaypoints].nodeID = ent.health

    numStoredWaypoints += 1
}

/// Source: oracle/codemp/game/g_nav.c:1713
func NAV_GetStoredWaypoint(_ targetname: String) -> Int32 {
    var i: Int32

    if targetname.isEmpty {
        return -1
    }
    i = 0
    while i < numStoredWaypoints {
        if !tempWaypointList[i].targetname.isEmpty {
            if Q_stricmp(targetname, tempWaypointList[i].targetname) == 0 {
                return i
            }
        }
        i += 1
    }
    return -1
}

/// Source: oracle/codemp/game/g_nav.c:1734
func NAV_CalculatePaths(_ filename: String, _ checksum: Int32) {
    var target: Int32 = -1
    var i: Int32

    // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '==' on 'BinaryInteger' requires that 'Slots<WaypointData>' conform to 'BinaryInteger'".
    // Raven wrote: if ( !tempWaypointList ) { return; }
    portMissing("NAV_CalculatePaths", source: "oracle/codemp/game/g_nav.c:1734")
    fatalErrors = 0
    // Port-note: Raven's `memset( fatalErrorString, 0, sizeof( fatalErrorString ) )` runs over bytes that are not one record with a view.
    // Raven wrote: memset( fatalErrorString, 0, sizeof( fatalErrorString ) )
    portMissing("NAV_CalculatePaths", source: "oracle/codemp/game/g_nav.c:1734")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int8' to type 'String'".
    // Raven wrote: fatalErrorPointer = &fatalErrorString[0]
    portMissing("NAV_CalculatePaths", source: "oracle/codemp/game/g_nav.c:1734")

    //Find all connections and hard connect them
    i = 0
    while i < numStoredWaypoints {
        //Find the first connection
        target = NAV_GetStoredWaypoint(tempWaypointList[i].target)

        if target != -1 {
            //			if ( !NAV_WaypointsTooFar( ent, target ) )
            do {
                trap_Nav_HardConnect(tempWaypointList[i].nodeID, tempWaypointList[target].nodeID)
            }
        }

        //Find a possible second connection
        target = NAV_GetStoredWaypoint(tempWaypointList[i].target2)

        if target != -1 {
            //			if ( !NAV_WaypointsTooFar( ent, target ) )
            do {
                trap_Nav_HardConnect(tempWaypointList[i].nodeID, tempWaypointList[target].nodeID)
            }
        }

        //Find a possible third connection
        target = NAV_GetStoredWaypoint(tempWaypointList[i].target3)

        if target != -1 {
            //			if ( !NAV_WaypointsTooFar( ent, target ) )
            do {
                trap_Nav_HardConnect(tempWaypointList[i].nodeID, tempWaypointList[target].nodeID)
            }
        }

        //Find a possible fourth connection
        target = NAV_GetStoredWaypoint(tempWaypointList[i].target4)

        if target != -1 {
            //			if ( !NAV_WaypointsTooFar( ent, target ) )
            do {
                trap_Nav_HardConnect(tempWaypointList[i].nodeID, tempWaypointList[target].nodeID)
            }
        }
        i += 1
    }


    //Remove all waypoints now that they're done
    //gi.Free(tempWaypointList);
    /*
    trap_TrueFree((void **)&tempWaypointList);
    tempWaypointList=0;
    */

    //Now check all blocked edges, mark failed ones
    trap_Nav_CheckBlockedEdges()

    trap_Nav_SetPathsCalculated(false)
    //navigator.pathsCalculated = qfalse;

    //Calculate the paths based on the supplied waypoints
    //trap_Nav_CalculatePaths();

    //Save the resulting information
    /*
    if ( trap_Nav_Save( filename, checksum ) == qfalse )
    {
    Com_Printf("Unable to save navigations data for map \"%s\" (checksum:%d)\n", filename, checksum );
    }
    */
    if fatalErrors != 0 {
        //Com_Error( ERR_DROP, "%s%d FATAL NAV ERRORS\n", fatalErrorString, fatalErrors );
        Com_Printf("%s%d FATAL NAV ERRORS\n", fatalErrorString, fatalErrors)
    }
}

/// Source: oracle/codemp/game/g_nav.c:1846
func NAV_Shutdown() {
    trap_Nav_Free()
}

/// Source: oracle/codemp/game/g_nav.c:1857
func NAV_ShowDebugInfo() {
    var i: Int32

    if NAVDEBUG_showNodes {
        trap_Nav_ShowNodes()
    }

    if NAVDEBUG_showEdges {
        trap_Nav_ShowEdges()
    }

    if NAVDEBUG_showTestPath {
        //Get the nearest node to the player
        var nearestNode: Int32 = trap_Nav_GetNearestNode(g_entities[0], g_entities[0].waypoint, NF_ANY, WAYPOINT_NONE)
        let testNode: Int32 = trap_Nav_GetBestNode(nearestNode, NAVDEBUG_curGoal, NODE_NONE)
        var dest = vec3_t()
        var start = vec3_t()

        nearestNode = NAV_TestBestNode(g_entities[0], nearestNode, testNode, false)

        //Show the connection

        //Get the positions
        trap_Nav_GetNodePosition(NAVDEBUG_curGoal, &dest)
        trap_Nav_GetNodePosition(nearestNode, &start)

        G_DrawNode(start, NODE_START)
        G_DrawNode(dest, NODE_GOAL)
        trap_Nav_ShowPath(nearestNode, NAVDEBUG_curGoal)
    }

    if NAVDEBUG_showCombatPoints {
        i = 0
        while i < level.numCombatPoints {
            G_DrawCombatPoint(level.combatPoints[i].origin, 0)
            i += 1
        }
    }

    if NAVDEBUG_showNavGoals {
        TAG_ShowTags(RTF_NAVGOAL)
    }
}

/// Source: oracle/codemp/game/g_nav.c:1911
func NAV_FindPlayerWaypoint(_ clNum: Int32) {
    g_entities[clNum].waypoint = trap_Nav_GetNearestNode(g_entities[clNum], g_entities[clNum].lastWaypoint, NF_CLEAR_PATH, WAYPOINT_NONE)
}
