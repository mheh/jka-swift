import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ai_move.cpp:75
let AVOIDREACH_TIME = 6 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:76
let AVOIDREACH_TRIES = 4 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:78
let PREDICTIONTIME_JUMP = 3 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:79
let PREDICTIONTIME_MOVE = 2 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:81
let WEAPONINDEX_ROCKET_LAUNCHER = 5 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:82
let WEAPONINDEX_BFG = 9 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:84
let MODELTYPE_FUNC_PLAT = 1 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:85
let MODELTYPE_FUNC_BOB = 2 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:86
let MODELTYPE_FUNC_DOOR = 3 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:87
let MODELTYPE_FUNC_STATIC = 4 as Int32

/// Source: oracle/codemp/botlib/be_ai_move.cpp:89
var sv_maxstep: Libvar? {
    get { world.variables.sv_maxstep }
    set { world.variables.sv_maxstep = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:90
var sv_maxbarrier: Libvar? {
    get { world.variables.sv_maxbarrier }
    set { world.variables.sv_maxbarrier = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:91
var sv_gravity: Libvar? {
    get { world.variables.sv_gravity }
    set { world.variables.sv_gravity = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:92
var weapindex_rocketlauncher: Libvar? {
    get { world.variables.weapindex_rocketlauncher }
    set { world.variables.weapindex_rocketlauncher = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:93
var weapindex_bfg10k: Libvar? {
    get { world.variables.weapindex_bfg10k }
    set { world.variables.weapindex_bfg10k = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:94
var weapindex_grapple: Libvar? {
    get { world.variables.weapindex_grapple }
    set { world.variables.weapindex_grapple = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:95
var entitytypemissile: Libvar? {
    get { world.variables.entitytypemissile }
    set { world.variables.entitytypemissile = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:96
var offhandgrapple: Libvar? {
    get { world.variables.offhandgrapple }
    set { world.variables.offhandgrapple = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:97
var cmd_grappleoff: Libvar? {
    get { world.variables.cmd_grappleoff }
    set { world.variables.cmd_grappleoff = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:98
var cmd_grappleon: Libvar? {
    get { world.variables.cmd_grappleon }
    set { world.variables.cmd_grappleon = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:100
var modeltypes: [Int32] {
    get { world.variables.modeltypes }
    set { world.variables.modeltypes = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:102
var botmovestates: Slots<BotMovestate?> { world.storage.botmovestates }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:227
// AI: Raven declares `areas` on the stack of BotFuzzyPointReachabilityArea. The function uses one zeroed allocation on the storage class.
private var areas_BotFuzzyPointReachabilityArea: Slots<Int32> { world.storage.be_ai_move_areas_BotFuzzyPointReachabilityArea }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:229
// AI: Raven declares `points` on the stack of BotFuzzyPointReachabilityArea. The function uses one zeroed allocation on the storage class.
private var points_BotFuzzyPointReachabilityArea: Slots<JKAShared.vec3_t> { world.storage.be_ai_move_points_BotFuzzyPointReachabilityArea }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:3385
// AI: Raven declares `areas` on the stack of BotMoveToGoal. The function uses one zeroed allocation on the storage class.
private var areas_BotMoveToGoal: Slots<Int32> { world.storage.be_ai_move_areas_BotMoveToGoal }

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:110
func BotAllocMoveState() -> Int32 {
    var i: Int32

    i = 1
    while i <= MAX_CLIENTS {
        if botmovestates[i] == nil {
            botmovestates[i] = BotMovestate(GetClearedMemory(UInt32(BotMovestate.byteCount)))
            return i
        }
        i += 1
    }
    return 0
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:130
func BotFreeMoveState(_ handle: Int32) {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "move state handle %d out of range\n", handle)
        return
    }
    if botmovestates[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid move state %d\n", handle)
        return
    }
    FreeMemory(botmovestates[handle]!.handle)
    botmovestates[handle] = nil
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:151
func BotMoveStateFromHandle(_ handle: Int32) -> BotMovestate? {
    if handle <= 0 || handle > MAX_CLIENTS {
        botimport.runPrint(PRT_FATAL, "move state handle %d out of range\n", handle)
        return nil
    }
    if botmovestates[handle] == nil {
        botimport.runPrint(PRT_FATAL, "invalid move state %d\n", handle)
        return nil
    }
    return botmovestates[handle]
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:171
func BotInitMoveState(_ handle: Int32, _ initmove: BotInitmove) {
    guard let ms = BotMoveStateFromHandle(handle) else { return }
    ms.origin = initmove.origin
    ms.velocity = initmove.velocity
    ms.viewoffset = initmove.viewoffset
    ms.entitynum = initmove.entitynum
    ms.client = initmove.client
    ms.thinktime = initmove.thinktime
    ms.presencetype = initmove.presencetype
    ms.viewangles = initmove.viewangles
    //
    ms.moveflags &= ~MFL_ONGROUND
    if (initmove.or_moveflags & MFL_ONGROUND) != 0 { ms.moveflags |= MFL_ONGROUND }
    ms.moveflags &= ~MFL_TELEPORTED
    if (initmove.or_moveflags & MFL_TELEPORTED) != 0 { ms.moveflags |= MFL_TELEPORTED }
    ms.moveflags &= ~MFL_WATERJUMP
    if (initmove.or_moveflags & MFL_WATERJUMP) != 0 { ms.moveflags |= MFL_WATERJUMP }
    ms.moveflags &= ~MFL_WALK
    if (initmove.or_moveflags & MFL_WALK) != 0 { ms.moveflags |= MFL_WALK }
    ms.moveflags &= ~MFL_GRAPPLEPULL
    if (initmove.or_moveflags & MFL_GRAPPLEPULL) != 0 { ms.moveflags |= MFL_GRAPPLEPULL }
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:203
func AngleDiff(_ ang1: Float, _ ang2: Float) -> Float {
    var diff: Float

    diff = ang1 - ang2
    if ang1 > ang2 {
        if Double(diff) > 180.0 { diff = Float(Double(diff) - 360.0) }
    } else {
        if Double(diff) < -180.0 { diff = Float(Double(diff) + 360.0) }
    }
    return diff
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:224
func BotFuzzyPointReachabilityArea(_ origin: JKAShared.vec3_t) -> Int32 {
    var firstareanum: Int32, j: Int32, x: Int32, y: Int32, z: Int32
    // AI: Raven declares `int areas[10]` and `vec3_t points[10]` on the stack.
    // The body reads the forwards `areas_BotFuzzyPointReachabilityArea` and `points_BotFuzzyPointReachabilityArea`.
    var numareas: Int32, areanum: Int32, bestareanum: Int32
    var dist: Float, bestdist: Float
    var v = vec3_t(), end = vec3_t()

    firstareanum = 0
    areanum = AAS_PointAreaNum(origin)
    if areanum != 0 {
        firstareanum = areanum
        if AAS_AreaReachability(areanum) != 0 { return areanum }
    }
    end = origin
    end[2] += 4
    numareas = AAS_TraceAreas(origin, end, areas_BotFuzzyPointReachabilityArea, points_BotFuzzyPointReachabilityArea, 10)
    j = 0
    while j < numareas {
        if AAS_AreaReachability(areas_BotFuzzyPointReachabilityArea[j]) != 0 { return areas_BotFuzzyPointReachabilityArea[j] }
        j += 1
    }
    bestdist = 999999
    bestareanum = 0
    z = 1
    while z >= -1 {
        x = 1
        while x >= -1 {
            y = 1
            while y >= -1 {
                end = origin
                end[0] += x * 8
                end[1] += y * 8
                end[2] += z * 12
                numareas = AAS_TraceAreas(origin, end, areas_BotFuzzyPointReachabilityArea, points_BotFuzzyPointReachabilityArea, 10)
                j = 0
                while j < numareas {
                    if AAS_AreaReachability(areas_BotFuzzyPointReachabilityArea[j]) != 0 {
                        v = points_BotFuzzyPointReachabilityArea[j] - origin
                        dist = VectorLength(v)
                        if dist < bestdist {
                            bestareanum = areas_BotFuzzyPointReachabilityArea[j]
                            bestdist = dist
                        }
                    }
                    if firstareanum == 0 { firstareanum = areas_BotFuzzyPointReachabilityArea[j] }
                    j += 1
                }
                y -= 1
            }
            x -= 1
        }
        if bestareanum != 0 { return bestareanum }
        z -= 1
    }
    return firstareanum
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:284
func BotReachabilityArea(_ origin: JKAShared.vec3_t, _ client: Int32) -> Int32 {
    var org = vec3_t(), end = vec3_t(), mins = vec3_t(), maxs = vec3_t()
    let up = vec3_t(0, 0, 1)

    return AasReachability.scratch { reach -> Int32 in
        BspTrace.scratch { bsptrace -> Int32 in
            AasTrace.scratch { trace -> Int32 in
                var modelnum: Int32, modeltype: Int32, reachnum: Int32, areanum: Int32
                //check if the bot is standing on something
                AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, &mins, &maxs)
                _VectorMA(origin, -3, up, &end)
                bsptrace.copy(from: AAS_Trace(origin, mins, maxs, end, client, CONTENTS_SOLID | CONTENTS_PLAYERCLIP))
                if !bsptrace.startsolid && bsptrace.fraction < 1 && bsptrace.ent != ENTITYNUM_NONE {
                    //if standing on the world the bot should be in a valid area
                    if bsptrace.ent == ENTITYNUM_WORLD {
                        return BotFuzzyPointReachabilityArea(origin)
                    }

                    modelnum = AAS_EntityModelindex(bsptrace.ent)
                    modeltype = modeltypes[modelnum]

                    //if standing on a func_plat or func_bobbing then the bot is assumed to be
                    //in the area the reachability points to
                    if modeltype == MODELTYPE_FUNC_PLAT || modeltype == MODELTYPE_FUNC_BOB {
                        reachnum = AAS_NextModelReachability(0, modelnum)
                        if reachnum != 0 {
                            AAS_ReachabilityFromNum(reachnum, reach)
                            return reach.areanum
                        }
                    }

                    //if the bot is swimming the bot should be in a valid area
                    if AAS_Swimming(origin) != 0 {
                        return BotFuzzyPointReachabilityArea(origin)
                    }
                    //
                    areanum = BotFuzzyPointReachabilityArea(origin)
                    //if the bot is in an area with reachabilities
                    if areanum != 0 && AAS_AreaReachability(areanum) != 0 { return areanum }
                    //trace down till the ground is hit because the bot is standing on some other entity
                    org = origin
                    end = org
                    end[2] -= 800
                    trace.copy(from: AAS_TraceClientBBox(org, end, PRESENCE_CROUCH, -1))
                    if !trace.startsolid {
                        org = trace.endpos
                    }
                    //
                    return BotFuzzyPointReachabilityArea(org)
                }
                //
                return BotFuzzyPointReachabilityArea(origin)
            }
        }
    }
}

//===========================================================================
// returns the reachability area the bot is in
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/**
```
int BotReachabilityArea(vec3_t origin, int testground)
{
	int firstareanum, i, j, x, y, z;
	int areas[10], numareas, areanum, bestareanum;
	float dist, bestdist;
	vec3_t org, end, points[10], v;
	aas_trace_t trace;

	firstareanum = 0;
	for (i = 0; i < 2; i++)
	{
		VectorCopy(origin, org);
		//if test at the ground (used when bot is standing on an entity)
		if (i > 0)
		{
			VectorCopy(origin, end);
			end[2] -= 800;
			trace = AAS_TraceClientBBox(origin, end, PRESENCE_CROUCH, -1);
			if (!trace.startsolid)
			{
				VectorCopy(trace.endpos, org);
			} //end if
		} //end if

		firstareanum = 0;
		areanum = AAS_PointAreaNum(org);
		if (areanum)
		{
			firstareanum = areanum;
			if (AAS_AreaReachability(areanum)) return areanum;
		} //end if
		bestdist = 999999;
		bestareanum = 0;
		for (z = 1; z >= -1; z -= 1)
		{
			for (x = 1; x >= -1; x -= 1)
			{
				for (y = 1; y >= -1; y -= 1)
				{
					VectorCopy(org, end);
					end[0] += x * 8;
					end[1] += y * 8;
					end[2] += z * 12;
					numareas = AAS_TraceAreas(org, end, areas, points, 10);
					for (j = 0; j < numareas; j++)
					{
						if (AAS_AreaReachability(areas[j]))
						{
							VectorSubtract(points[j], org, v);
							dist = VectorLength(v);
							if (dist < bestdist)
							{
								bestareanum = areas[j];
								bestdist = dist;
							} //end if
						} //end if
					} //end for
				} //end for
			} //end for
			if (bestareanum) return bestareanum;
		} //end for
		if (!testground) break;
	} //end for
//#ifdef DEBUG
	//botimport.Print(PRT_MESSAGE, "no reachability area\n");
//#endif //DEBUG
	return firstareanum;
} //end of the function BotReachabilityArea
```
*/
//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:425
func BotOnMover(_ origin: JKAShared.vec3_t, _ entnum: Int32, _ reach: AasReachability) -> Int32 {
    var mins = vec3_t(), maxs = vec3_t(), modelorigin = vec3_t(), org = vec3_t(), end = vec3_t()
    let angles = vec3_t(0, 0, 0)
    let boxmins = vec3_t(-16, -16, -8), boxmaxs = vec3_t(16, 16, 8)

    return BspTrace.scratch { trace -> Int32 in
        var i: Int32, modelnum: Int32
        modelnum = reach.facenum & 0x0000FFFF
        //get some bsp model info
        // Raven passes NULL for the `origin` output, and the scratch local takes the write.
        var scratchOrigin = vec3_t()
        AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &mins, &maxs, &scratchOrigin)
        //
        if AAS_OriginOfMoverWithModelNum(modelnum, &modelorigin) == 0 {
            botimport.runPrint(PRT_MESSAGE, "no entity with model %d\n", modelnum)
            return 0
        }
        //
        i = 0
        while i < 2 {
            if origin[i] > modelorigin[i] + maxs[i] + 16 { return 0 }
            if origin[i] < modelorigin[i] + mins[i] - 16 { return 0 }
            i += 1
        }
        //
        org = origin
        org[2] += 24
        end = origin
        end[2] -= 48
        //
        trace.copy(from: AAS_Trace(org, boxmins, boxmaxs, end, entnum, CONTENTS_SOLID | CONTENTS_PLAYERCLIP))
        if !trace.startsolid && !trace.allsolid {
            //NOTE: the reachability face number is the model number of the elevator
            if trace.ent != ENTITYNUM_NONE && AAS_EntityModelNum(trace.ent) == modelnum {
                return 1
            }
        }
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:471
func MoverDown(_ reach: AasReachability) -> Int32 {
    var modelnum: Int32
    var mins = vec3_t(), maxs = vec3_t(), origin = vec3_t()
    let angles = vec3_t(0, 0, 0)

    modelnum = reach.facenum & 0x0000FFFF
    //get some bsp model info
    AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &mins, &maxs, &origin)
    //
    if AAS_OriginOfMoverWithModelNum(modelnum, &origin) == 0 {
        botimport.runPrint(PRT_MESSAGE, "no entity with model %d\n", modelnum)
        return 0
    }
    //if the top of the plat is below the reachability start point
    if origin[2] + maxs[2] < reach.start[2] { return 1 }
    return 0
}

//========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:496
func BotSetBrushModelTypes() {
    var ent: Int32, modelnum: Int32
    var classname = CharBuf(MAX_EPAIRKEY), model = CharBuf(MAX_EPAIRKEY)

    modeltypes.fill(0)
    //
    ent = AAS_NextBSPEntity(0)
    while ent != 0 {
        if AAS_ValueForBSPEpairKey(ent, "classname", &classname, MAX_EPAIRKEY) == 0 {
            ent = AAS_NextBSPEntity(ent)
            continue
        }
        if AAS_ValueForBSPEpairKey(ent, "model", &model, MAX_EPAIRKEY) == 0 {
            ent = AAS_NextBSPEntity(ent)
            continue
        }
        if model[0] != 0 {
            modelnum = atoi(model[1...])
        } else {
            modelnum = 0
        }

        if modelnum < 0 || modelnum > MAX_MODELS {
            botimport.runPrint(PRT_MESSAGE, "entity %s model number out of range\n", String(classname))
            ent = AAS_NextBSPEntity(ent)
            continue
        }

        // Port-note: Raven writes `modeltypes[MAX_MODELS]`, one past the end, when `modelnum` is MAX_MODELS.
        // The Swift index traps there, rule 19.
        if Q_stricmp(classname, "func_bobbing") == 0 {
            modeltypes[modelnum] = MODELTYPE_FUNC_BOB
        } else if Q_stricmp(classname, "func_plat") == 0 {
            modeltypes[modelnum] = MODELTYPE_FUNC_PLAT
        } else if Q_stricmp(classname, "func_door") == 0 {
            modeltypes[modelnum] = MODELTYPE_FUNC_DOOR
        } else if Q_stricmp(classname, "func_static") == 0 {
            modeltypes[modelnum] = MODELTYPE_FUNC_STATIC
        }
        ent = AAS_NextBSPEntity(ent)
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:532
func BotOnTopOfEntity(_ ms: BotMovestate) -> Int32 {
    var mins = vec3_t(), maxs = vec3_t(), end = vec3_t()
    let up = vec3_t(0, 0, 1)

    return BspTrace.scratch { trace -> Int32 in
        AAS_PresenceTypeBoundingBox(ms.presencetype, &mins, &maxs)
        _VectorMA(ms.origin, -3, up, &end)
        trace.copy(from: AAS_Trace(ms.origin, mins, maxs, end, ms.entitynum, CONTENTS_SOLID | CONTENTS_PLAYERCLIP))
        if !trace.startsolid && (trace.ent != ENTITYNUM_WORLD && trace.ent != ENTITYNUM_NONE) {
            return trace.ent
        }
        return -1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:552
func BotValidTravel(_ origin: JKAShared.vec3_t, _ reach: AasReachability, _ travelflags: Int32) -> Int32 {
    //if the reachability uses an unwanted travel type
    if (AAS_TravelFlagForType(reach.traveltype) & ~travelflags) != 0 { return 0 }
    //don't go into areas with bad travel types
    if (AAS_AreaContentsTravelFlags(reach.areanum) & ~travelflags) != 0 { return 0 }
    return 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:566
func BotAddToAvoidReach(_ ms: BotMovestate, _ number: Int32, _ avoidtime: Float) {
    var i: Int32

    i = 0
    while i < MAX_AVOIDREACH {
        if ms.avoidreach[i] == number {
            if ms.avoidreachtimes[i] > AAS_Time() {
                ms.avoidreachtries[i] += 1
            } else {
                ms.avoidreachtries[i] = 1
            }
            ms.avoidreachtimes[i] = AAS_Time() + avoidtime
            return
        }
        i += 1
    }
    //add the reachability to the reachabilities to avoid for a while
    i = 0
    while i < MAX_AVOIDREACH {
        if ms.avoidreachtimes[i] < AAS_Time() {
            ms.avoidreach[i] = number
            ms.avoidreachtimes[i] = AAS_Time() + avoidtime
            ms.avoidreachtries[i] = 1
            return
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:598
func DistanceFromLineSquared(_ p: JKAShared.vec3_t, _ lp1: JKAShared.vec3_t, _ lp2: JKAShared.vec3_t) -> Float {
    var proj = vec3_t(), dir = vec3_t()
    var j: Int32

    AAS_ProjectPointOntoVector(p, lp1, lp2, &proj)
    j = 0
    while j < 3 {
        if (proj[j] > lp1[j] && proj[j] > lp2[j]) ||
            (proj[j] < lp1[j] && proj[j] < lp2[j]) {
            break
        }
        j += 1
    }
    if j < 3 {
        if abs(proj[j] - lp1[j]) < abs(proj[j] - lp2[j]) {
            dir = p - lp1
        } else {
            dir = p - lp2
        }
        return VectorLengthSquared(dir)
    }
    dir = p - proj
    return VectorLengthSquared(dir)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:624
func VectorDistanceSquared(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Float {
    var dir = vec3_t()
    dir = p2 - p1
    return VectorLengthSquared(dir)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:636
func BotAvoidSpots(_ origin: JKAShared.vec3_t, _ reach: AasReachability, _ avoidspots: Slots<BotAvoidspot>, _ numavoidspots: Int32) -> Int32 {
    var checkbetween: Int32, i: Int32, type: Int32
    var squareddist: Float, squaredradius: Float

    switch reach.traveltype & TRAVELTYPE_MASK {
    case TRAVEL_WALK: checkbetween = 1
    case TRAVEL_CROUCH: checkbetween = 1
    case TRAVEL_BARRIERJUMP: checkbetween = 1
    case TRAVEL_LADDER: checkbetween = 1
    case TRAVEL_WALKOFFLEDGE: checkbetween = 0
    case TRAVEL_JUMP: checkbetween = 0
    case TRAVEL_SWIM: checkbetween = 1
    case TRAVEL_WATERJUMP: checkbetween = 1
    case TRAVEL_TELEPORT: checkbetween = 0
    case TRAVEL_ELEVATOR: checkbetween = 0
    case TRAVEL_GRAPPLEHOOK: checkbetween = 0
    case TRAVEL_ROCKETJUMP: checkbetween = 0
    case TRAVEL_BFGJUMP: checkbetween = 0
    case TRAVEL_JUMPPAD: checkbetween = 0
    case TRAVEL_FUNCBOB: checkbetween = 0
    default: checkbetween = 1
    }

    type = AVOID_CLEAR
    i = 0
    while i < numavoidspots {
        squaredradius = Square(avoidspots[i].radius)
        squareddist = DistanceFromLineSquared(avoidspots[i].origin, origin, reach.start)
        // if moving towards the avoid spot
        if squareddist < squaredradius &&
            VectorDistanceSquared(avoidspots[i].origin, origin) > squareddist {
            type = avoidspots[i].type
        } else if checkbetween != 0 {
            squareddist = DistanceFromLineSquared(avoidspots[i].origin, reach.start, reach.end)
            // if moving towards the avoid spot
            if squareddist < squaredradius &&
                VectorDistanceSquared(avoidspots[i].origin, reach.start) > squareddist {
                type = avoidspots[i].type
            }
        } else {
            _ = VectorDistanceSquared(avoidspots[i].origin, reach.end)
            // if the reachability leads closer to the avoid spot
            if squareddist < squaredradius &&
                VectorDistanceSquared(avoidspots[i].origin, reach.start) > squareddist {
                type = avoidspots[i].type
            }
        }
        if type == AVOID_ALWAYS {
            return type
        }
        i += 1
    }
    return type
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:702
func BotAddAvoidSpot(_ movestate: Int32, _ origin: JKAShared.vec3_t, _ radius: Float, _ type: Int32) {
    guard let ms = BotMoveStateFromHandle(movestate) else { return }
    if type == AVOID_CLEAR {
        ms.numavoidspots = 0
        return
    }

    if ms.numavoidspots >= MAX_AVOIDSPOTS {
        return
    }
    ms.avoidspots[ms.numavoidspots].origin = origin
    ms.avoidspots[ms.numavoidspots].radius = radius
    ms.avoidspots[ms.numavoidspots].type = type
    ms.numavoidspots += 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:727
func BotGetReachabilityToGoal(_ origin: JKAShared.vec3_t, _ areanum: Int32, _ lastgoalareanum: Int32, _ lastareanum: Int32, _ avoidreach: Slots<Int32>, _ avoidreachtimes: Slots<Float>, _ avoidreachtries: Slots<Int32>, _ goal: BotGoal, _ travelflags: Int32, _ movetravelflags: Int32, _ avoidspots: Slots<BotAvoidspot>?, _ numavoidspots: Int32, _ flags: UnsafeMutablePointer<Int32>?) -> Int32 {
    // Raven assigns his own `travelflags` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var travelflags = travelflags
    // Raven assigns his own `movetravelflags` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var movetravelflags = movetravelflags

    return AasReachability.scratch { reach -> Int32 in
        var i: Int32, t: Int32, besttime: Int32, bestreachnum: Int32, reachnum: Int32
        //if not in a valid area
        if areanum == 0 { return 0 }
        //
        if AAS_AreaDoNotEnter(areanum) != 0 || AAS_AreaDoNotEnter(goal.areanum) != 0 {
            travelflags |= TFL_DONOTENTER
            movetravelflags |= TFL_DONOTENTER
        }
        //use the routing to find the next area to go to
        besttime = 0
        bestreachnum = 0
        //
        reachnum = AAS_NextAreaReachability(areanum, 0)
        while reachnum != 0 {
            //check if it isn't an reachability to avoid
            i = 0
            while i < MAX_AVOIDREACH {
                if avoidreach[i] == reachnum && avoidreachtimes[i] >= AAS_Time() { break }
                i += 1
            }
            if i != MAX_AVOIDREACH && avoidreachtries[i] > AVOIDREACH_TRIES {
                reachnum = AAS_NextAreaReachability(areanum, reachnum)
                continue
            }
            //get the reachability from the number
            AAS_ReachabilityFromNum(reachnum, reach)
            //NOTE: do not go back to the previous area if the goal didn't change
            //NOTE: is this actually avoidance of local routing minima between two areas???
            if lastgoalareanum == goal.areanum && reach.areanum == lastareanum {
                reachnum = AAS_NextAreaReachability(areanum, reachnum)
                continue
            }
            //if (AAS_AreaContentsTravelFlags(reach.areanum) & ~travelflags) continue;
            //if the travel isn't valid
            if BotValidTravel(origin, reach, movetravelflags) == 0 {
                reachnum = AAS_NextAreaReachability(areanum, reachnum)
                continue
            }
            //get the travel time
            t = AAS_AreaTravelTimeToGoalArea(reach.areanum, reach.end, goal.areanum, travelflags)
            //if the goal area isn't reachable from the reachable area
            if t == 0 {
                reachnum = AAS_NextAreaReachability(areanum, reachnum)
                continue
            }
            //if the bot should not use this reachability to avoid bad spots
            if BotAvoidSpots(origin, reach, avoidspots!, numavoidspots) != 0 {
                if flags != nil {
                    flags!.pointee |= MOVERESULT_BLOCKEDBYAVOIDSPOT
                }
                reachnum = AAS_NextAreaReachability(areanum, reachnum)
                continue
            }
            //add the travel time towards the area
            t += reach.traveltime// + AAS_AreaTravelTime(areanum, origin, reach.start);
            //if the travel time is better than the ones already found
            if besttime == 0 || t < besttime {
                besttime = t
                bestreachnum = reachnum
            }
            reachnum = AAS_NextAreaReachability(areanum, reachnum)
        }
        //
        return bestreachnum
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:805
func BotAddToTarget(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ maxdist: Float, _ dist: inout Float, _ target: inout JKAShared.vec3_t) -> Int32 {
    var dir = vec3_t()
    var curdist: Float

    dir = end - start
    curdist = VectorNormalize(&dir)
    if dist + curdist < maxdist {
        target = end
        dist += curdist
        return 0
    } else {
        _VectorMA(start, maxdist - dist, dir, &target)
        dist = maxdist
        return 1
    }
}

/// Source: oracle/codemp/botlib/be_ai_move.cpp:826
func BotMovementViewTarget(_ movestate: Int32, _ goal: BotGoal, _ travelflags: Int32, _ lookahead: Float, _ target: inout JKAShared.vec3_t) -> Int32 {
    var end = vec3_t()

    return AasReachability.scratch { reach -> Int32 in
        var reachnum: Int32, lastareanum: Int32
        var dist: Float
        guard let ms = BotMoveStateFromHandle(movestate) else { return 0 }
        reachnum = 0
        //if the bot has no goal or no last reachability
        if ms.lastreachnum == 0 { return 0 }

        reachnum = ms.lastreachnum
        end = ms.origin
        lastareanum = ms.lastareanum
        dist = 0
        while reachnum != 0 && dist < lookahead {
            AAS_ReachabilityFromNum(reachnum, reach)
            if BotAddToTarget(end, reach.start, lookahead, &dist, &target) != 0 { return 1 }
            //never look beyond teleporters
            if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_TELEPORT { return 1 }
            //never look beyond the weapon jump point
            if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_ROCKETJUMP { return 1 }
            if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_BFGJUMP { return 1 }
            //don't add jump pad distances
            if (reach.traveltype & TRAVELTYPE_MASK) != TRAVEL_JUMPPAD &&
                (reach.traveltype & TRAVELTYPE_MASK) != TRAVEL_ELEVATOR &&
                (reach.traveltype & TRAVELTYPE_MASK) != TRAVEL_FUNCBOB {
                if BotAddToTarget(reach.start, reach.end, lookahead, &dist, &target) != 0 { return 1 }
            }
            reachnum = BotGetReachabilityToGoal(reach.end, reach.areanum,
                                                ms.lastgoalareanum, lastareanum,
                                                ms.avoidreach, ms.avoidreachtimes, ms.avoidreachtries,
                                                goal, travelflags, travelflags, nil, 0, nil)
            end = reach.end
            lastareanum = reach.areanum
            if lastareanum == goal.areanum {
                _ = BotAddToTarget(reach.end, goal.origin, lookahead, &dist, &target)
                return 1
            }
        }
        //
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:881
func BotVisible(_ ent: Int32, _ eye: JKAShared.vec3_t, _ target: JKAShared.vec3_t) -> Int32 {
    return BspTrace.scratch { trace -> Int32 in
        trace.copy(from: AAS_Trace(eye, nil, nil, target, ent, CONTENTS_SOLID | CONTENTS_PLAYERCLIP))
        if trace.fraction >= 1 { return 1 }
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:899
// AI: Raven declares `avoidreach` on the stack of BotPredictVisiblePosition. The function uses one zeroed allocation on the storage class.
var avoidreach_BotPredictVisiblePosition: Slots<Int32> { world.storage.avoidreach_BotPredictVisiblePosition }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:900
// AI: Raven declares `avoidreachtimes` on the stack of BotPredictVisiblePosition. The function uses one zeroed allocation on the storage class.
var avoidreachtimes_BotPredictVisiblePosition: Slots<Float> { world.storage.avoidreachtimes_BotPredictVisiblePosition }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:901
// AI: Raven declares `avoidreachtries` on the stack of BotPredictVisiblePosition. The function uses one zeroed allocation on the storage class.
var avoidreachtries_BotPredictVisiblePosition: Slots<Int32> { world.storage.avoidreachtries_BotPredictVisiblePosition }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:895
func BotPredictVisiblePosition(_ origin: JKAShared.vec3_t, _ areanum: Int32, _ goal: BotGoal, _ travelflags: Int32, _ target: inout JKAShared.vec3_t) -> Int32 {
    var end = vec3_t()
    // Raven assigns his own `areanum` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var areanum = areanum

    return AasReachability.scratch { reach -> Int32 in
        var reachnum: Int32, lastgoalareanum: Int32, lastareanum: Int32, i: Int32
        //if the areanum is not valid
        if areanum == 0 { return 0 }
        //if the goal areanum is not valid
        if goal.areanum == 0 { return 0 }

        avoidreach_BotPredictVisiblePosition.zero()
        lastgoalareanum = goal.areanum
        lastareanum = areanum
        end = origin
        //only do 20 hops
        i = 0
        while i < 20 && (areanum != goal.areanum) {
            //
            reachnum = BotGetReachabilityToGoal(end, areanum, lastgoalareanum, lastareanum, avoidreach_BotPredictVisiblePosition, avoidreachtimes_BotPredictVisiblePosition, avoidreachtries_BotPredictVisiblePosition, goal, travelflags, travelflags, nil, 0, nil)
            if reachnum == 0 { return 0 }
            AAS_ReachabilityFromNum(reachnum, reach)
            //
            if BotVisible(goal.entitynum, goal.origin, reach.start) != 0 {
                target = reach.start
                return 1
            }
            //
            if BotVisible(goal.entitynum, goal.origin, reach.end) != 0 {
                target = reach.end
                return 1
            }
            //
            if reach.areanum == goal.areanum {
                target = reach.end
                return 1
            }
            //
            lastareanum = areanum
            areanum = reach.areanum
            end = reach.end
            //
            i += 1
        }
        //
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:958
func MoverBottomCenter(_ reach: AasReachability, _ bottomcenter: inout JKAShared.vec3_t) {
    var modelnum: Int32
    var mins = vec3_t(), maxs = vec3_t(), origin = vec3_t(), mids = vec3_t()
    let angles = vec3_t(0, 0, 0)

    modelnum = reach.facenum & 0x0000FFFF
    //get some bsp model info
    AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &mins, &maxs, &origin)
    //
    if AAS_OriginOfMoverWithModelNum(modelnum, &origin) == 0 {
        botimport.runPrint(PRT_MESSAGE, "no entity with model %d\n", modelnum)
    }
    //get a point just above the plat in the bottom position
    mids = mins + maxs
    bottomcenter[0] = Float(Double(origin[0]) + Double(mids[0]) * 0.5)
    bottomcenter[1] = Float(Double(origin[1]) + Double(mids[1]) * 0.5)
    bottomcenter[2] = Float(Double(origin[2]) + Double(mids[2]) * 0.5)
    bottomcenter[2] = reach.start[2]
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:983
func BotGapDistance(_ origin: JKAShared.vec3_t, _ hordir: JKAShared.vec3_t, _ entnum: Int32) -> Float {
    var start = vec3_t(), end = vec3_t()

    return AasTrace.scratch { trace -> Float in
        var dist: Float, startz: Float
        //do gap checking
        startz = origin[2]
        //this enables walking down stairs more fluidly
        do {
            start = origin
            end = origin
            end[2] -= 60
            trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, entnum))
            if trace.fraction >= 1 { return 1 }
            startz = trace.endpos[2] + 1
        }
        //
        dist = 8
        while dist <= 100 {
            _VectorMA(origin, dist, hordir, &start)
            start[2] = startz + 24
            end = start
            end[2] -= 48 + sv_maxbarrier!.value
            trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, entnum))
            //if solid is found the bot can't walk any further and fall into a gap
            if !trace.startsolid {
                //if it is a gap
                if trace.endpos[2] < startz - sv_maxstep!.value - 8 {
                    end = trace.endpos
                    end[2] -= 20
                    if (AAS_PointContents(end) & CONTENTS_WATER) != 0 { break }
                    //if a gap is found slow down
                    //botimport.Print(PRT_MESSAGE, "gap at %f\n", dist);
                    return dist
                }
                startz = trace.endpos[2]
            }
            dist += 8
        }
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1032
func BotCheckBarrierJump(_ ms: BotMovestate, _ dir: JKAShared.vec3_t, _ speed: Float) -> Int32 {
    var start = vec3_t(), hordir = vec3_t(), end = vec3_t()

    return AasTrace.scratch { trace -> Int32 in
        end = ms.origin
        end[2] += sv_maxbarrier!.value
        //trace right up
        trace.copy(from: AAS_TraceClientBBox(ms.origin, end, PRESENCE_NORMAL, ms.entitynum))
        //this shouldn't happen... but we check anyway
        if trace.startsolid { return 0 }
        //if very low ceiling it isn't possible to jump up to a barrier
        if trace.endpos[2] - ms.origin[2] < sv_maxstep!.value { return 0 }
        //
        hordir[0] = dir[0]
        hordir[1] = dir[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        end[0] = Float(Double(ms.origin[0]) + Double(hordir[0]) * (Double(ms.thinktime * speed) * 0.5))
        end[1] = Float(Double(ms.origin[1]) + Double(hordir[1]) * (Double(ms.thinktime * speed) * 0.5))
        end[2] = Float(Double(ms.origin[2]) + Double(hordir[2]) * (Double(ms.thinktime * speed) * 0.5))
        start = trace.endpos
        end[2] = trace.endpos[2]
        //trace from previous trace end pos horizontally in the move direction
        trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, ms.entitynum))
        //again this shouldn't happen
        if trace.startsolid { return 0 }
        //
        start = trace.endpos
        end = trace.endpos
        end[2] = ms.origin[2]
        //trace down from the previous trace end pos
        trace.copy(from: AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, ms.entitynum))
        //if solid
        if trace.startsolid { return 0 }
        //if no obstacle at all
        if trace.fraction >= 1.0 { return 0 }
        //if less than the maximum step height
        if trace.endpos[2] - ms.origin[2] < sv_maxstep!.value { return 0 }
        //
        EA_Jump(ms.client)
        EA_Move(ms.client, hordir, speed)
        ms.moveflags |= MFL_BARRIERJUMP
        //there is a barrier
        return 1
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1082
func BotSwimInDirection(_ ms: BotMovestate, _ dir: JKAShared.vec3_t, _ speed: Float, _ type: Int32) -> Int32 {
    var normdir = vec3_t()

    normdir = dir
    _ = VectorNormalize(&normdir)
    EA_Move(ms.client, normdir, speed)
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1097
func BotWalkInDirection(_ ms: BotMovestate, _ dir: JKAShared.vec3_t, _ speed: Float, _ type: Int32) -> Int32 {
    var hordir = vec3_t(), cmdmove = vec3_t(), velocity = vec3_t(), tmpdir = vec3_t(), origin = vec3_t()
    // Raven assigns his own `type` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var type = type

    return AasClientmove.scratch { move -> Int32 in
        var presencetype: Int32, maxframes: Int32, cmdframes: Int32, stopevent: Int32
        var dist: Float
        if AAS_OnGround(ms.origin, ms.presencetype, ms.entitynum) != 0 { ms.moveflags |= MFL_ONGROUND }
        //if the bot is on the ground
        if (ms.moveflags & MFL_ONGROUND) != 0 {
            //if there is a barrier the bot can jump on
            if BotCheckBarrierJump(ms, dir, speed) != 0 { return 1 }
            //remove barrier jump flag
            ms.moveflags &= ~MFL_BARRIERJUMP
            //get the presence type for the movement
            if (type & MOVE_CROUCH) != 0 && (type & MOVE_JUMP) == 0 {
                presencetype = PRESENCE_CROUCH
            } else {
                presencetype = PRESENCE_NORMAL
            }
            //horizontal direction
            hordir[0] = dir[0]
            hordir[1] = dir[1]
            hordir[2] = 0
            _ = VectorNormalize(&hordir)
            //if the bot is not supposed to jump
            if (type & MOVE_JUMP) == 0 {
                //if there is a gap, try to jump over it
                if BotGapDistance(ms.origin, hordir, ms.entitynum) > 0 { type |= MOVE_JUMP }
            }
            //get command movement
            cmdmove = hordir * speed
            velocity = ms.velocity
            //
            if (type & MOVE_JUMP) != 0 {
                //botimport.Print(PRT_MESSAGE, "trying jump\n");
                cmdmove[2] = 400
                maxframes = Int32(Double(PREDICTIONTIME_JUMP) / 0.1)
                cmdframes = 1
                stopevent = SE_HITGROUND | SE_HITGROUNDDAMAGE |
                    SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA
            } else {
                maxframes = 2
                cmdframes = 2
                stopevent = SE_HITGROUNDDAMAGE |
                    SE_ENTERWATER | SE_ENTERSLIME | SE_ENTERLAVA
            }
            //AAS_ClearShownDebugLines();
            //
            origin = ms.origin
            origin[2] = Float(Double(origin[2]) + 0.5)
            _ = AAS_PredictClientMovement(move, ms.entitynum, origin, presencetype, 1,
                                          velocity, cmdmove, cmdframes, maxframes, 0.1,
                                          stopevent, 0, 0)//qtrue);
            //if prediction time wasn't enough to fully predict the movement
            if move.frames >= maxframes && (type & MOVE_JUMP) != 0 {
                //botimport.Print(PRT_MESSAGE, "client %d: max prediction frames\n", ms->client);
                return 0
            }
            //don't enter slime or lava and don't fall from too high
            if (move.stopevent & (SE_ENTERSLIME | SE_ENTERLAVA | SE_HITGROUNDDAMAGE)) != 0 {
                //botimport.Print(PRT_MESSAGE, "client %d: would be hurt ", ms->client);
                //if (move.stopevent & SE_ENTERSLIME) botimport.Print(PRT_MESSAGE, "slime\n");
                //if (move.stopevent & SE_ENTERLAVA) botimport.Print(PRT_MESSAGE, "lava\n");
                //if (move.stopevent & SE_HITGROUNDDAMAGE) botimport.Print(PRT_MESSAGE, "hitground\n");
                return 0
            }
            //if ground was hit
            if (move.stopevent & SE_HITGROUND) != 0 {
                //check for nearby gap
                _ = VectorNormalize2(move.velocity, &tmpdir)
                dist = BotGapDistance(move.endpos, tmpdir, ms.entitynum)
                if dist > 0 { return 0 }
                //
                dist = BotGapDistance(move.endpos, hordir, ms.entitynum)
                if dist > 0 { return 0 }
            }
            //get horizontal movement
            tmpdir[0] = move.endpos[0] - ms.origin[0]
            tmpdir[1] = move.endpos[1] - ms.origin[1]
            tmpdir[2] = 0
            //
            //AAS_DrawCross(move.endpos, 4, LINECOLOR_BLUE);
            //the bot is blocked by something
            if Double(VectorLength(tmpdir)) < Double(speed * ms.thinktime) * 0.5 { return 0 }
            //perform the movement
            if (type & MOVE_JUMP) != 0 { EA_Jump(ms.client) }
            if (type & MOVE_CROUCH) != 0 { EA_Crouch(ms.client) }
            EA_Move(ms.client, hordir, speed)
            //movement was succesfull
            return 1
        } else {
            if (ms.moveflags & MFL_BARRIERJUMP) != 0 {
                //if near the top or going down
                if ms.velocity[2] < 50 {
                    EA_Move(ms.client, dir, speed)
                }
            }
            //FIXME: do air control to avoid hazards
            return 1
        }
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1214
func BotMoveInDirection(_ movestate: Int32, _ dir: JKAShared.vec3_t, _ speed: Float, _ type: Int32) -> Int32 {
    guard let ms = BotMoveStateFromHandle(movestate) else { return 0 }
    //if swimming
    if AAS_Swimming(ms.origin) != 0 {
        return BotSwimInDirection(ms, dir, speed, type)
    } else {
        return BotWalkInDirection(ms, dir, speed, type)
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1236
func Intersection(_ p1: JKAShared.vec2_t, _ p2: JKAShared.vec2_t, _ p3: JKAShared.vec2_t, _ p4: JKAShared.vec2_t, _ out: inout JKAShared.vec2_t) -> Int32 {
    var x1: Float, dx1: Float, dy1: Float, x2: Float, dx2: Float, dy2: Float, d: Float

    dx1 = p2[0] - p1[0]
    dy1 = p2[1] - p1[1]
    dx2 = p4[0] - p3[0]
    dy2 = p4[1] - p3[1]

    d = dy1 * dx2 - dx1 * dy2
    if d != 0 {
        x1 = p1[1] * dx1 - p1[0] * dy1
        x2 = p3[1] * dx2 - p3[0] * dy2
        out[0] = Float(Int32((dx1 * x2 - dx2 * x1) / d))
        out[1] = Float(Int32((dy1 * x2 - dy2 * x1) / d))
        return 1
    } else {
        return 0
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1265
func BotCheckBlocked(_ ms: BotMovestate, _ dir: JKAShared.vec3_t, _ checkbottom: Int32, _ result: BotMoveresult) {
    var mins = vec3_t(), maxs = vec3_t(), end = vec3_t()
    let up = vec3_t(0, 0, 1)

    BspTrace.scratch { trace in
        //test for entities obstructing the bot's path
        AAS_PresenceTypeBoundingBox(ms.presencetype, &mins, &maxs)
        //
        if abs(Double(_DotProduct(dir, up))) < 0.7 {
            mins[2] += sv_maxstep!.value //if the bot can step on
            maxs[2] -= 10 //a little lower to avoid low ceiling
        }
        _VectorMA(ms.origin, 3, dir, &end)
        trace.copy(from: AAS_Trace(ms.origin, mins, maxs, end, ms.entitynum, CONTENTS_SOLID | CONTENTS_PLAYERCLIP | CONTENTS_BODY))
        //if not started in solid and not hitting the world entity
        if !trace.startsolid && (trace.ent != ENTITYNUM_WORLD && trace.ent != ENTITYNUM_NONE) {
            result.blocked = 1
            result.blockentity = trace.ent
        }
        //if not in an area with reachability
        else if checkbottom != 0 && AAS_AreaReachability(ms.areanum) == 0 {
            //check if the bot is standing on something
            AAS_PresenceTypeBoundingBox(ms.presencetype, &mins, &maxs)
            _VectorMA(ms.origin, -3, up, &end)
            trace.copy(from: AAS_Trace(ms.origin, mins, maxs, end, ms.entitynum, CONTENTS_SOLID | CONTENTS_PLAYERCLIP))
            if !trace.startsolid && (trace.ent != ENTITYNUM_WORLD && trace.ent != ENTITYNUM_NONE) {
                result.blocked = 1
                result.blockentity = trace.ent
                result.flags |= MOVERESULT_ONTOPOFOBSTACLE
            }
        }
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1313
func BotClearMoveResult(_ moveresult: BotMoveresult) {
    moveresult.failure = 0
    moveresult.type = 0
    moveresult.blocked = 0
    moveresult.blockentity = 0
    moveresult.traveltype = 0
    moveresult.flags = 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1328
// AI: Raven declares `result` on the stack of BotTravel_Walk. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Walk: BotMoveresult { world.storage.result_BotTravel_Walk }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1328
func BotTravel_Walk(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dist: Float, speed: Float
    var hordir = vec3_t()
    let result = result_BotTravel_Walk

    BotClearMoveResult(result)
    //first walk straight to the reachability start
    hordir[0] = reach.start[0] - ms.origin[0]
    hordir[1] = reach.start[1] - ms.origin[1]
    hordir[2] = 0
    dist = VectorNormalize(&hordir)
    //
    BotCheckBlocked(ms, hordir, 1, result)
    //
    if dist < 10 {
        //walk straight to the reachability end
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        dist = VectorNormalize(&hordir)
    } //end if
    //if going towards a crouch area
    if (AAS_AreaPresenceType(reach.areanum) & PRESENCE_NORMAL) == 0 {
        //if pretty close to the reachable area
        if dist < 20 { EA_Crouch(ms.client) }
    } //end if
    //
    dist = BotGapDistance(ms.origin, hordir, ms.entitynum)
    //
    if (ms.moveflags & MFL_WALK) != 0 {
        if dist > 0 {
            speed = 200 - (180 - 1 * dist)
        } else {
            speed = 200
        }
        EA_Walk(ms.client)
    } //end if
    else {
        if dist > 0 {
            speed = 400 - (360 - 2 * dist)
        } else {
            speed = 400
        }
    } //end else
    //elemantary action move in direction
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1383
// AI: Raven declares `result` on the stack of BotFinishTravel_Walk. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_Walk: BotMoveresult { world.storage.result_BotFinishTravel_Walk }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1383
func BotFinishTravel_Walk(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t()
    var dist: Float, speed: Float
    let result = result_BotFinishTravel_Walk

    BotClearMoveResult(result)
    //if not on the ground and changed areas... don't walk back!!
    //(doesn't seem to help)
    //go straight to the reachability end
    hordir[0] = reach.end[0] - ms.origin[0]
    hordir[1] = reach.end[1] - ms.origin[1]
    hordir[2] = 0
    dist = VectorNormalize(&hordir)
    //
    if dist > 100 { dist = 100 }
    speed = 400 - (400 - 3 * dist)
    //
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1421
// AI: Raven declares `result` on the stack of BotTravel_Crouch. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Crouch: BotMoveresult { world.storage.result_BotTravel_Crouch }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1421
func BotTravel_Crouch(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    let speed: Float
    var hordir = vec3_t()
    let result = result_BotTravel_Crouch

    BotClearMoveResult(result)
    //
    speed = 400
    //walk straight to reachability end
    hordir[0] = reach.end[0] - ms.origin[0]
    hordir[1] = reach.end[1] - ms.origin[1]
    hordir[2] = 0
    _ = VectorNormalize(&hordir)
    //
    BotCheckBlocked(ms, hordir, 1, result)
    //elemantary actions
    EA_Crouch(ms.client)
    EA_Move(ms.client, hordir, speed)
    //
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1451
// AI: Raven declares `result` on the stack of BotTravel_BarrierJump. The function uses one zeroed allocation on the storage class.
var result_BotTravel_BarrierJump: BotMoveresult { world.storage.result_BotTravel_BarrierJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1451
func BotTravel_BarrierJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dist: Float, speed: Float
    var hordir = vec3_t()
    let result = result_BotTravel_BarrierJump

    BotClearMoveResult(result)
    //walk straight to reachability start
    hordir[0] = reach.start[0] - ms.origin[0]
    hordir[1] = reach.start[1] - ms.origin[1]
    hordir[2] = 0
    dist = VectorNormalize(&hordir)
    //
    BotCheckBlocked(ms, hordir, 1, result)
    //if pretty close to the barrier
    if dist < 9 {
        EA_Jump(ms.client)
    } //end if
    else {
        if dist > 60 { dist = 60 }
        speed = 360 - (360 - 6 * dist)
        EA_Move(ms.client, hordir, speed)
    } //end else
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1486
// AI: Raven declares `result` on the stack of BotFinishTravel_BarrierJump. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_BarrierJump: BotMoveresult { world.storage.result_BotFinishTravel_BarrierJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1486
func BotFinishTravel_BarrierJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t()
    let result = result_BotFinishTravel_BarrierJump

    BotClearMoveResult(result)
    //if near the top or going down
    if ms.velocity[2] < 250 {
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        //
        BotCheckBlocked(ms, hordir, 1, result)
        //
        EA_Move(ms.client, hordir, 400)
        result.movedir = hordir
    } //end if
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1515
// AI: Raven declares `result` on the stack of BotTravel_Swim. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Swim: BotMoveresult { world.storage.result_BotTravel_Swim }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1515
func BotTravel_Swim(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dir = vec3_t()
    let result = result_BotTravel_Swim

    BotClearMoveResult(result)
    //swim straight to reachability end
    dir = reach.start - ms.origin
    _ = VectorNormalize(&dir)
    //
    BotCheckBlocked(ms, dir, 1, result)
    //elemantary actions
    EA_Move(ms.client, dir, 400)
    //
    result.movedir = dir
    vectoangles(dir, &result.ideal_viewangles)
    result.flags |= MOVERESULT_SWIMVIEW
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1541
// AI: Raven declares `result` on the stack of BotTravel_WaterJump. The function uses one zeroed allocation on the storage class.
var result_BotTravel_WaterJump: BotMoveresult { world.storage.result_BotTravel_WaterJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1541
func BotTravel_WaterJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dir = vec3_t(), hordir = vec3_t()
    let dist: Float
    let result = result_BotTravel_WaterJump

    BotClearMoveResult(result)
    //swim straight to reachability end
    dir = reach.end - ms.origin
    hordir = dir
    hordir[2] = 0
    dir[2] = Float(Double(dir[2]) + 15 + crandom() * 40)
    //botimport.Print(PRT_MESSAGE, "BotTravel_WaterJump: dir[2] = %f\n", dir[2]);
    _ = VectorNormalize(&dir)
    dist = VectorNormalize(&hordir)
    //elemantary actions
    //EA_Move(ms->client, dir, 400);
    EA_MoveForward(ms.client)
    //move up if close to the actual out of water jump spot
    if dist < 40 { EA_MoveUp(ms.client) }
    //set the ideal view angles
    vectoangles(dir, &result.ideal_viewangles)
    result.flags |= MOVERESULT_MOVEMENTVIEW
    //
    result.movedir = dir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1575
// AI: Raven declares `result` on the stack of BotFinishTravel_WaterJump. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_WaterJump: BotMoveresult { world.storage.result_BotFinishTravel_WaterJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1575
func BotFinishTravel_WaterJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dir = vec3_t(), pnt = vec3_t()
    let result = result_BotFinishTravel_WaterJump

    //botimport.Print(PRT_MESSAGE, "BotFinishTravel_WaterJump\n");
    BotClearMoveResult(result)
    //if waterjumping there's nothing to do
    if (ms.moveflags & MFL_WATERJUMP) != 0 { return result }
    //if not touching any water anymore don't do anything
    //otherwise the bot sometimes keeps jumping?
    pnt = ms.origin
    pnt[2] -= 32	//extra for q2dm4 near red armor/mega health
    if (AAS_PointContents(pnt) & (CONTENTS_LAVA | CONTENTS_SLIME | CONTENTS_WATER)) == 0 { return result }
    //swim straight to reachability end
    dir = reach.end - ms.origin
    dir[0] = Float(Double(dir[0]) + crandom() * 10)
    dir[1] = Float(Double(dir[1]) + crandom() * 10)
    dir[2] = Float(Double(dir[2]) + 70 + crandom() * 10)
    _ = VectorNormalize(&dir)
    //elemantary actions
    EA_Move(ms.client, dir, 400)
    //set the ideal view angles
    vectoangles(dir, &result.ideal_viewangles)
    result.flags |= MOVERESULT_MOVEMENTVIEW
    //
    result.movedir = dir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1612
// AI: Raven declares `result` on the stack of BotTravel_WalkOffLedge. The function uses one zeroed allocation on the storage class.
var result_BotTravel_WalkOffLedge: BotMoveresult { world.storage.result_BotTravel_WalkOffLedge }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1612
func BotTravel_WalkOffLedge(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t(), dir = vec3_t()
    var dist: Float, speed: Float = 0
    let reachhordist: Float
    let result = result_BotTravel_WalkOffLedge

    BotClearMoveResult(result)
    //check if the bot is blocked by anything
    dir = reach.start - ms.origin
    _ = VectorNormalize(&dir)
    BotCheckBlocked(ms, dir, 1, result)
    //if the reachability start and end are practially above each other
    dir = reach.end - reach.start
    dir[2] = 0
    reachhordist = VectorLength(dir)
    //walk straight to the reachability start
    hordir[0] = reach.start[0] - ms.origin[0]
    hordir[1] = reach.start[1] - ms.origin[1]
    hordir[2] = 0
    dist = VectorNormalize(&hordir)
    //if pretty close to the start focus on the reachability end
    if dist < 48 {
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        //
        if reachhordist < 20 {
            speed = 100
        } //end if
        else if AAS_HorizontalVelocityForJump(0, reach.start, reach.end, &speed) == 0 {
            speed = 400
        } //end if
    } //end if
    else {
        if reachhordist < 20 {
            if dist > 64 { dist = 64 }
            speed = 400 - (256 - 4 * dist)
        } //end if
        else {
            speed = 400
        } //end else
    } //end else
    //
    BotCheckBlocked(ms, hordir, 1, result)
    //elemantary action
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1675
func BotAirControl(_ origin: JKAShared.vec3_t, _ velocity: JKAShared.vec3_t, _ goal: JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t, _ speed: inout Float) -> Int32 {
    var org = vec3_t(), vel = vec3_t()
    var dist: Float
    var i: Int32

    org = origin
    vel[0] = Float(Double(velocity[0]) * 0.1)
    vel[1] = Float(Double(velocity[1]) * 0.1)
    vel[2] = Float(Double(velocity[2]) * 0.1)
    i = 0
    while i < 50 {
        vel[2] = Float(Double(vel[2]) - Double(sv_gravity!.value) * 0.01)
        //if going down and next position would be below the goal
        if vel[2] < 0 && org[2] + vel[2] < goal[2] {
            vel = vel * ((goal[2] - org[2]) / vel[2])
            org = org + vel
            dir = goal - org
            dist = VectorNormalize(&dir)
            if dist > 32 { dist = 32 }
            speed = 400 - (400 - 13 * dist)
            return 1
        } else {
            org = org + vel
        }
        i += 1
    }
    dir = vec3_t(0, 0, 0)
    speed = 400
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1712
// AI: Raven declares `result` on the stack of BotFinishTravel_WalkOffLedge. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_WalkOffLedge: BotMoveresult { world.storage.result_BotFinishTravel_WalkOffLedge }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1712
func BotFinishTravel_WalkOffLedge(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dir = vec3_t(), hordir = vec3_t(), end = vec3_t(), v = vec3_t()
    let dist: Float
    var speed: Float = 0
    let result = result_BotFinishTravel_WalkOffLedge

    BotClearMoveResult(result)
    //
    dir = reach.end - ms.origin
    BotCheckBlocked(ms, dir, 1, result)
    //
    v = reach.end - ms.origin
    v[2] = 0
    dist = VectorNormalize(&v)
    if dist > 16 {
        _VectorMA(reach.end, 16, v, &end)
    } else {
        end = reach.end
    }
    //
    if BotAirControl(ms.origin, ms.velocity, end, &hordir, &speed) == 0 {
        //go straight to the reachability end
        hordir = dir
        hordir[2] = 0
        //
        _ = VectorNormalize(&hordir)
        speed = 400
    } //end if
    //
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/**
```
bot_moveresult_t BotTravel_Jump(bot_movestate_t *ms, aas_reachability_t *reach)
{
	vec3_t hordir;
	float dist, gapdist, speed, horspeed, sv_jumpvel;
	bot_moveresult_t result;

	BotClearMoveResult(&result);
	//
	sv_jumpvel = botlibglobals.sv_jumpvel->value;
	//walk straight to the reachability start
	hordir[0] = reach->start[0] - ms->origin[0];
	hordir[1] = reach->start[1] - ms->origin[1];
	hordir[2] = 0;
	dist = VectorNormalize(hordir);
	//
	speed = 350;
	//
	gapdist = BotGapDistance(ms, hordir, ms->entitynum);
	//if pretty close to the start focus on the reachability end
	if (dist < 50 || (gapdist && gapdist < 50))
	{
		//NOTE: using max speed (400) works best
		//if (AAS_HorizontalVelocityForJump(sv_jumpvel, ms->origin, reach->end, &horspeed))
		//{
		//	speed = horspeed * 400 / botlibglobals.sv_maxwalkvelocity->value;
		//} //end if
		hordir[0] = reach->end[0] - ms->origin[0];
		hordir[1] = reach->end[1] - ms->origin[1];
		VectorNormalize(hordir);
		//elemantary action jump
		EA_Jump(ms->client);
		//
		ms->jumpreach = ms->lastreachnum;
		speed = 600;
	} //end if
	else
	{
		if (AAS_HorizontalVelocityForJump(sv_jumpvel, reach->start, reach->end, &horspeed))
		{
			speed = horspeed * 400 / botlibglobals.sv_maxwalkvelocity->value;
		} //end if
	} //end else
	//elemantary action
	EA_Move(ms->client, hordir, speed);
	VectorCopy(hordir, result.movedir);
	//
	return result;
} //end of the function BotTravel_Jump
```
*/
/**
```
bot_moveresult_t BotTravel_Jump(bot_movestate_t *ms, aas_reachability_t *reach)
{
	vec3_t hordir, dir1, dir2, mins, maxs, start, end;
	float dist1, dist2, speed;
	bot_moveresult_t result;
	bsp_trace_t trace;

	BotClearMoveResult(&result);
	//
	hordir[0] = reach->start[0] - reach->end[0];
	hordir[1] = reach->start[1] - reach->end[1];
	hordir[2] = 0;
	VectorNormalize(hordir);
	//
	VectorCopy(reach->start, start);
	start[2] += 1;
	//minus back the bouding box size plus 16
	VectorMA(reach->start, 80, hordir, end);
	//
	AAS_PresenceTypeBoundingBox(PRESENCE_NORMAL, mins, maxs);
	//check for solids
	trace = AAS_Trace(start, mins, maxs, end, ms->entitynum, MASK_PLAYERSOLID);
	if (trace.startsolid) VectorCopy(start, trace.endpos);
	//check for a gap
	for (dist1 = 0; dist1 < 80; dist1 += 10)
	{
		VectorMA(start, dist1+10, hordir, end);
		end[2] += 1;
		if (AAS_PointAreaNum(end) != ms->reachareanum) break;
	} //end for
	if (dist1 < 80) VectorMA(reach->start, dist1, hordir, trace.endpos);
//	dist1 = BotGapDistance(start, hordir, ms->entitynum);
//	if (dist1 && dist1 <= trace.fraction * 80) VectorMA(reach->start, dist1-20, hordir, trace.endpos);
	//
	VectorSubtract(ms->origin, reach->start, dir1);
	dir1[2] = 0;
	dist1 = VectorNormalize(dir1);
	VectorSubtract(ms->origin, trace.endpos, dir2);
	dir2[2] = 0;
	dist2 = VectorNormalize(dir2);
	//if just before the reachability start
	if (DotProduct(dir1, dir2) < -0.8 || dist2 < 5)
	{
		//botimport.Print(PRT_MESSAGE, "between jump start and run to point\n");
		hordir[0] = reach->end[0] - ms->origin[0];
		hordir[1] = reach->end[1] - ms->origin[1];
		hordir[2] = 0;
		VectorNormalize(hordir);
		//elemantary action jump
		if (dist1 < 24) EA_Jump(ms->client);
		else if (dist1 < 32) EA_DelayedJump(ms->client);
		EA_Move(ms->client, hordir, 600);
		//
		ms->jumpreach = ms->lastreachnum;
	} //end if
	else
	{
		//botimport.Print(PRT_MESSAGE, "going towards run to point\n");
		hordir[0] = trace.endpos[0] - ms->origin[0];
		hordir[1] = trace.endpos[1] - ms->origin[1];
		hordir[2] = 0;
		VectorNormalize(hordir);
		//
		if (dist2 > 80) dist2 = 80;
		speed = 400 - (400 - 5 * dist2);
		EA_Move(ms->client, hordir, speed);
	} //end else
	VectorCopy(hordir, result.movedir);
	//
	return result;
} //end of the function BotTravel_Jump
```
*/
//*
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1872
// AI: Raven declares `result` on the stack of BotTravel_Jump. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Jump: BotMoveresult { world.storage.result_BotTravel_Jump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1872
func BotTravel_Jump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t(), dir1 = vec3_t(), dir2 = vec3_t(), start = vec3_t(), end = vec3_t(), runstart = vec3_t()
    //	vec3_t runstart, dir1, dir2, hordir;
    var dist1: Float, dist2: Float, speed: Float
    let result = result_BotTravel_Jump

    BotClearMoveResult(result)
    //
    AAS_JumpReachRunStart(reach, &runstart)
    //*
    hordir[0] = runstart[0] - reach.start[0]
    hordir[1] = runstart[1] - reach.start[1]
    hordir[2] = 0
    _ = VectorNormalize(&hordir)
    //
    start = reach.start
    start[2] += 1
    _VectorMA(reach.start, 80, hordir, &runstart)
    //check for a gap
    dist1 = 0
    while dist1 < 80 {
        _VectorMA(start, dist1 + 10, hordir, &end)
        end[2] += 1
        if AAS_PointAreaNum(end) != ms.reachareanum { break }
        dist1 += 10
    } //end for
    if dist1 < 80 { _VectorMA(reach.start, dist1, hordir, &runstart) }
    //
    dir1 = ms.origin - reach.start
    dir1[2] = 0
    dist1 = VectorNormalize(&dir1)
    dir2 = ms.origin - runstart
    dir2[2] = 0
    dist2 = VectorNormalize(&dir2)
    //if just before the reachability start
    if Double(_DotProduct(dir1, dir2)) < -0.8 || dist2 < 5 {
        //		botimport.Print(PRT_MESSAGE, "between jump start and run start point\n");
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        //elemantary action jump
        if dist1 < 24 {
            EA_Jump(ms.client)
        } else if dist1 < 32 {
            EA_DelayedJump(ms.client)
        }
        EA_Move(ms.client, hordir, 600)
        //
        ms.jumpreach = ms.lastreachnum
    } //end if
    else {
        //		botimport.Print(PRT_MESSAGE, "going towards run start point\n");
        hordir[0] = runstart[0] - ms.origin[0]
        hordir[1] = runstart[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        //
        if dist2 > 80 { dist2 = 80 }
        speed = 400 - (400 - 5 * dist2)
        EA_Move(ms.client, hordir, speed)
    } //end else
    result.movedir = hordir
    //
    return result
}

/**
```
**
	hordir[0] = runstart[0] - reach->start[0];
	hordir[1] = runstart[1] - reach->start[1];
	hordir[2] = 0;
	VectorNormalize(hordir);
	//
	VectorCopy(reach->start, start);
	start[2] += 1;
	VectorMA(reach->start, 80, hordir, runstart);
	//check for a gap
	for (dist1 = 0; dist1 < 80; dist1 += 10)
	{
		VectorMA(start, dist1+10, hordir, end);
		end[2] += 1;
		if (AAS_PointAreaNum(end) != ms->reachareanum) break;
	} //end for
	if (dist1 < 80) VectorMA(reach->start, dist1, hordir, runstart);
	//
	VectorSubtract(ms->origin, reach->start, dir1);
	dir1[2] = 0;
	dist1 = VectorNormalize(dir1);
	VectorSubtract(ms->origin, runstart, dir2);
	dir2[2] = 0;
	dist2 = VectorNormalize(dir2);
	//if just before the reachability start
	if (DotProduct(dir1, dir2) < -0.8 || dist2 < 5)
	{
//		botimport.Print(PRT_MESSAGE, "between jump start and run start point\n");
		hordir[0] = reach->end[0] - ms->origin[0];
		hordir[1] = reach->end[1] - ms->origin[1];
		hordir[2] = 0;
		VectorNormalize(hordir);
		//elemantary action jump
		if (dist1 < 24) EA_Jump(ms->client);
		else if (dist1 < 32) EA_DelayedJump(ms->client);
		EA_Move(ms->client, hordir, 600);
		//
		ms->jumpreach = ms->lastreachnum;
	} //end if
	else
	{
//		botimport.Print(PRT_MESSAGE, "going towards run start point\n");
		hordir[0] = runstart[0] - ms->origin[0];
		hordir[1] = runstart[1] - ms->origin[1];
		hordir[2] = 0;
		VectorNormalize(hordir);
		//
		if (dist2 > 80) dist2 = 80;
		speed = 400 - (400 - 5 * dist2);
		EA_Move(ms->client, hordir, speed);
	} //end else
	VectorCopy(hordir, result.movedir);
	//
	return result;
} //end of the function BotTravel_Jump
```
*/
//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1943
// AI: Raven declares `result` on the stack of BotFinishTravel_Jump. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_Jump: BotMoveresult { world.storage.result_BotFinishTravel_Jump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1943
func BotFinishTravel_Jump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t(), hordir2 = vec3_t()
    let speed: Float, dist: Float
    let result = result_BotFinishTravel_Jump

    BotClearMoveResult(result)
    //if not jumped yet
    if ms.jumpreach == 0 { return result }
    //go straight to the reachability end
    hordir[0] = reach.end[0] - ms.origin[0]
    hordir[1] = reach.end[1] - ms.origin[1]
    hordir[2] = 0
    dist = VectorNormalize(&hordir)
    //
    hordir2[0] = reach.end[0] - reach.start[0]
    hordir2[1] = reach.end[1] - reach.start[1]
    hordir2[2] = 0
    _ = VectorNormalize(&hordir2)
    //
    if Double(_DotProduct(hordir, hordir2)) < -0.5 && dist < 24 { return result }
    //always use max speed when traveling through the air
    speed = 800
    //
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1978
// AI: Raven declares `result` on the stack of BotTravel_Ladder. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Ladder: BotMoveresult { world.storage.result_BotTravel_Ladder }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:1978
func BotTravel_Ladder(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    //float dist, speed;
    var dir = vec3_t(), viewdir = vec3_t() //, hordir;
    let origin = vec3_t(0, 0, 0)
    //	vec3_t up = {0, 0, 1};
    let result = result_BotTravel_Ladder

    BotClearMoveResult(result)
    //
    //	if ((ms->moveflags & MFL_AGAINSTLADDER))
    //NOTE: not a good idea for ladders starting in water
    // || !(ms->moveflags & MFL_ONGROUND))
    do {
        //botimport.Print(PRT_MESSAGE, "against ladder or not on ground\n");
        dir = reach.end - ms.origin
        _ = VectorNormalize(&dir)
        //set the ideal view angles, facing the ladder up or down
        viewdir[0] = dir[0]
        viewdir[1] = dir[1]
        viewdir[2] = 3 * dir[2]
        vectoangles(viewdir, &result.ideal_viewangles)
        //elemantary action
        EA_Move(ms.client, origin, 0)
        EA_MoveForward(ms.client)
        //set movement view flag so the AI can see the view is focussed
        result.flags |= MOVERESULT_MOVEMENTVIEW
    } //end if
    //save the movement direction
    result.movedir = dir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2034
// AI: Raven declares `result` on the stack of BotTravel_Teleport. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Teleport: BotMoveresult { world.storage.result_BotTravel_Teleport }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2034
func BotTravel_Teleport(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t()
    let dist: Float
    let result = result_BotTravel_Teleport

    BotClearMoveResult(result)
    //if the bot is being teleported
    if (ms.moveflags & MFL_TELEPORTED) != 0 { return result }

    //walk straight to center of the teleporter
    hordir = reach.start - ms.origin
    if (ms.moveflags & MFL_SWIMMING) == 0 { hordir[2] = 0 }
    dist = VectorNormalize(&hordir)
    //
    BotCheckBlocked(ms, hordir, 1, result)

    if dist < 30 {
        EA_Move(ms.client, hordir, 200)
    } else {
        EA_Move(ms.client, hordir, 400)
    }

    if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }

    result.movedir = hordir
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2065
// AI: Raven declares `result` on the stack of BotTravel_Elevator. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Elevator: BotMoveresult { world.storage.result_BotTravel_Elevator }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2065
func BotTravel_Elevator(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dir = vec3_t(), dir1 = vec3_t(), dir2 = vec3_t(), hordir = vec3_t(), bottomcenter = vec3_t()
    var dist: Float, dist1: Float, dist2: Float, speed: Float
    let result = result_BotTravel_Elevator

    BotClearMoveResult(result)
    //if standing on the plat
    if BotOnMover(ms.origin, ms.entitynum, reach) != 0 {
        //if vertically not too far from the end point
        // The C++ build of be_ai_move.cpp takes the `float` overload of abs, which keeps the fraction.
        if abs(ms.origin[2] - reach.end[2]) < sv_maxbarrier!.value {
            //move to the end point
            hordir = reach.end - ms.origin
            hordir[2] = 0
            _ = VectorNormalize(&hordir)
            if BotCheckBarrierJump(ms, hordir, 100) == 0 {
                EA_Move(ms.client, hordir, 400)
            } //end if
            result.movedir = hordir
        } //end else
        //if not really close to the center of the elevator
        else {
            MoverBottomCenter(reach, &bottomcenter)
            hordir = bottomcenter - ms.origin
            hordir[2] = 0
            dist = VectorNormalize(&hordir)
            //
            if dist > 10 {
                //move to the center of the plat
                if dist > 100 { dist = 100 }
                speed = 400 - (400 - 4 * dist)
                //
                EA_Move(ms.client, hordir, speed)
                result.movedir = hordir
            } //end if
        } //end else
    } //end if
    else {
        //if very near the reachability end
        dir = reach.end - ms.origin
        dist = VectorLength(dir)
        if dist < 64 {
            if dist > 60 { dist = 60 }
            speed = 360 - (360 - 6 * dist)
            //
            if (ms.moveflags & MFL_SWIMMING) != 0 || BotCheckBarrierJump(ms, dir, 50) == 0 {
                if speed > 5 { EA_Move(ms.client, dir, speed) }
            } //end if
            result.movedir = dir
            //
            if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
            //stop using this reachability
            ms.reachability_time = 0
            return result
        } //end if
        //get direction and distance to reachability start
        dir1 = reach.start - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { dir1[2] = 0 }
        dist1 = VectorNormalize(&dir1)
        //if the elevator isn't down
        if MoverDown(reach) == 0 {
            dist = dist1
            dir = dir1
            //
            BotCheckBlocked(ms, dir, 0, result)
            //
            if dist > 60 { dist = 60 }
            speed = 360 - (360 - 6 * dist)
            //
            if (ms.moveflags & MFL_SWIMMING) == 0 && BotCheckBarrierJump(ms, dir, 50) == 0 {
                if speed > 5 { EA_Move(ms.client, dir, speed) }
            } //end if
            result.movedir = dir
            //
            if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
            //this isn't a failure... just wait till the elevator comes down
            result.type = RESULTTYPE_ELEVATORUP
            result.flags |= MOVERESULT_WAITING
            return result
        } //end if
        //get direction and distance to elevator bottom center
        MoverBottomCenter(reach, &bottomcenter)
        dir2 = bottomcenter - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { dir2[2] = 0 }
        dist2 = VectorNormalize(&dir2)
        //if very close to the reachability start or
        //closer to the elevator center or
        //between reachability start and elevator center
        if dist1 < 20 || dist2 < dist1 || _DotProduct(dir1, dir2) < 0 {
            dist = dist2
            dir = dir2
        } //end if
        else { //closer to the reachability start
            dist = dist1
            dir = dir1
        } //end else
        //
        BotCheckBlocked(ms, dir, 0, result)
        //
        if dist > 60 { dist = 60 }
        speed = 400 - (400 - 6 * dist)
        //
        if (ms.moveflags & MFL_SWIMMING) == 0 && BotCheckBarrierJump(ms, dir, 50) == 0 {
            EA_Move(ms.client, dir, speed)
        } //end if
        result.movedir = dir
        //
        if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
    } //end else
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2216
// AI: Raven declares `result` on the stack of BotFinishTravel_Elevator. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_Elevator: BotMoveresult { world.storage.result_BotFinishTravel_Elevator }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2216
func BotFinishTravel_Elevator(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var bottomcenter = vec3_t(), bottomdir = vec3_t(), topdir = vec3_t()
    let result = result_BotFinishTravel_Elevator

    BotClearMoveResult(result)
    //
    MoverBottomCenter(reach, &bottomcenter)
    bottomdir = bottomcenter - ms.origin
    //
    topdir = reach.end - ms.origin
    //
    if abs(bottomdir[2]) < abs(topdir[2]) {
        _ = VectorNormalize(&bottomdir)
        EA_Move(ms.client, bottomdir, 300)
    } //end if
    else {
        _ = VectorNormalize(&topdir)
        EA_Move(ms.client, topdir, 300)
    } //end else
    return result
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2246
func BotFuncBobStartEnd(_ reach: AasReachability, _ start: inout JKAShared.vec3_t, _ end: inout JKAShared.vec3_t, _ origin: inout JKAShared.vec3_t) {
    var spawnflags: Int32, modelnum: Int32
    var mins = vec3_t(), maxs = vec3_t(), mid = vec3_t()
    let angles = vec3_t(0, 0, 0)
    var num0: Int32, num1: Int32

    modelnum = reach.facenum & 0x0000FFFF
    if AAS_OriginOfMoverWithModelNum(modelnum, &origin) == 0 {
        botimport.runPrint(PRT_MESSAGE, "BotFuncBobStartEnd: no entity with model %d\n", modelnum)
        start = vec3_t(0, 0, 0)
        end = vec3_t(0, 0, 0)
        return
    }
    // Raven passes NULL for the `origin` output, and the scratch local takes the write.
    var scratchOrigin = vec3_t()
    AAS_BSPModelMinsMaxsOrigin(modelnum, angles, &mins, &maxs, &scratchOrigin)
    mid = mins + maxs
    mid[0] = Float(Double(mid[0]) * 0.5)
    mid[1] = Float(Double(mid[1]) * 0.5)
    mid[2] = Float(Double(mid[2]) * 0.5)
    start = mid
    end = mid
    spawnflags = reach.facenum >> 16
    num0 = reach.edgenum >> 16
    // Raven wrote `0xFFFF0000`, the same bit pattern as `~0x0000_FFFF` on an `Int32`.
    if num0 > 0x00007FFF { num0 |= ~0x0000_FFFF }
    num1 = reach.edgenum & 0x0000FFFF
    // Raven wrote `0xFFFF0000`, the same bit pattern as `~0x0000_FFFF` on an `Int32`.
    if num1 > 0x00007FFF { num1 |= ~0x0000_FFFF }
    if (spawnflags & 1) != 0 {
        start[0] = Float(num0)
        end[0] = Float(num1)
        //
        origin[0] += mid[0]
        origin[1] = mid[1]
        origin[2] = mid[2]
    } else if (spawnflags & 2) != 0 {
        start[1] = Float(num0)
        end[1] = Float(num1)
        //
        origin[0] = mid[0]
        origin[1] += mid[1]
        origin[2] = mid[2]
    } else {
        start[2] = Float(num0)
        end[2] = Float(num1)
        //
        origin[0] = mid[0]
        origin[1] = mid[1]
        origin[2] += mid[2]
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2304
// AI: Raven declares `result` on the stack of BotTravel_FuncBobbing. The function uses one zeroed allocation on the storage class.
var result_BotTravel_FuncBobbing: BotMoveresult { world.storage.result_BotTravel_FuncBobbing }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2304
func BotTravel_FuncBobbing(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var dir = vec3_t(), dir1 = vec3_t(), dir2 = vec3_t(), hordir = vec3_t(), bottomcenter = vec3_t(), bob_start = vec3_t(), bob_end = vec3_t(), bob_origin = vec3_t()
    var dist: Float, dist1: Float, dist2: Float, speed: Float
    let result = result_BotTravel_FuncBobbing

    BotClearMoveResult(result)
    //
    BotFuncBobStartEnd(reach, &bob_start, &bob_end, &bob_origin)
    //if standing ontop of the func_bobbing
    if BotOnMover(ms.origin, ms.entitynum, reach) != 0 {
        //if near end point of reachability
        dir = bob_origin - bob_end
        if VectorLength(dir) < 24 {
            //move to the end point
            hordir = reach.end - ms.origin
            hordir[2] = 0
            _ = VectorNormalize(&hordir)
            if BotCheckBarrierJump(ms, hordir, 100) == 0 {
                EA_Move(ms.client, hordir, 400)
            } //end if
            result.movedir = hordir
        } //end else
        //if not really close to the center of the elevator
        else {
            MoverBottomCenter(reach, &bottomcenter)
            hordir = bottomcenter - ms.origin
            hordir[2] = 0
            dist = VectorNormalize(&hordir)
            //
            if dist > 10 {
                //move to the center of the plat
                if dist > 100 { dist = 100 }
                speed = 400 - (400 - 4 * dist)
                //
                EA_Move(ms.client, hordir, speed)
                result.movedir = hordir
            } //end if
        } //end else
    } //end if
    else {
        //if very near the reachability end
        dir = reach.end - ms.origin
        dist = VectorLength(dir)
        if dist < 64 {
            if dist > 60 { dist = 60 }
            speed = 360 - (360 - 6 * dist)
            //if swimming or no barrier jump
            if (ms.moveflags & MFL_SWIMMING) != 0 || BotCheckBarrierJump(ms, dir, 50) == 0 {
                if speed > 5 { EA_Move(ms.client, dir, speed) }
            } //end if
            result.movedir = dir
            //
            if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
            //stop using this reachability
            ms.reachability_time = 0
            return result
        } //end if
        //get direction and distance to reachability start
        dir1 = reach.start - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { dir1[2] = 0 }
        dist1 = VectorNormalize(&dir1)
        //if func_bobbing is Not it's start position
        dir = bob_origin - bob_start
        if VectorLength(dir) > 16 {
            dist = dist1
            dir = dir1
            //
            BotCheckBlocked(ms, dir, 0, result)
            //
            if dist > 60 { dist = 60 }
            speed = 360 - (360 - 6 * dist)
            //
            if (ms.moveflags & MFL_SWIMMING) == 0 && BotCheckBarrierJump(ms, dir, 50) == 0 {
                if speed > 5 { EA_Move(ms.client, dir, speed) }
            } //end if
            result.movedir = dir
            //
            if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
            //this isn't a failure... just wait till the func_bobbing arrives
            result.type = RESULTTYPE_WAITFORFUNCBOBBING
            result.flags |= MOVERESULT_WAITING
            return result
        } //end if
        //get direction and distance to func_bob bottom center
        MoverBottomCenter(reach, &bottomcenter)
        dir2 = bottomcenter - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { dir2[2] = 0 }
        dist2 = VectorNormalize(&dir2)
        //if very close to the reachability start or
        //closer to the elevator center or
        //between reachability start and func_bobbing center
        if dist1 < 20 || dist2 < dist1 || _DotProduct(dir1, dir2) < 0 {
            dist = dist2
            dir = dir2
        } //end if
        else { //closer to the reachability start
            dist = dist1
            dir = dir1
        } //end else
        //
        BotCheckBlocked(ms, dir, 0, result)
        //
        if dist > 60 { dist = 60 }
        speed = 400 - (400 - 6 * dist)
        //
        if (ms.moveflags & MFL_SWIMMING) == 0 && BotCheckBarrierJump(ms, dir, 50) == 0 {
            EA_Move(ms.client, dir, speed)
        } //end if
        result.movedir = dir
        //
        if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
    } //end else
    return result
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2462
// AI: Raven declares `result` on the stack of BotFinishTravel_FuncBobbing. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_FuncBobbing: BotMoveresult { world.storage.result_BotFinishTravel_FuncBobbing }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2462
func BotFinishTravel_FuncBobbing(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var bob_origin = vec3_t(), bob_start = vec3_t(), bob_end = vec3_t(), dir = vec3_t(), hordir = vec3_t(), bottomcenter = vec3_t()
    let result = result_BotFinishTravel_FuncBobbing
    var dist: Float, speed: Float

    BotClearMoveResult(result)
    //
    BotFuncBobStartEnd(reach, &bob_start, &bob_end, &bob_origin)
    //
    dir = bob_origin - bob_end
    dist = VectorLength(dir)
    //if the func_bobbing is near the end
    if dist < 16 {
        hordir = reach.end - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { hordir[2] = 0 }
        dist = VectorNormalize(&hordir)
        //
        if dist > 60 { dist = 60 }
        speed = 360 - (360 - 6 * dist)
        //
        if speed > 5 { EA_Move(ms.client, dir, speed) }
        result.movedir = dir
        //
        if (ms.moveflags & MFL_SWIMMING) != 0 { result.flags |= MOVERESULT_SWIMVIEW }
    } //end if
    else {
        MoverBottomCenter(reach, &bottomcenter)
        hordir = bottomcenter - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { hordir[2] = 0 }
        dist = VectorNormalize(&hordir)
        //
        if dist > 5 {
            //move to the center of the plat
            if dist > 100 { dist = 100 }
            speed = 400 - (400 - 4 * dist)
            //
            EA_Move(ms.client, hordir, speed)
            result.movedir = hordir
        } //end if
    } //end else
    return result
}

//===========================================================================
// 0  no valid grapple hook visible
// 1  the grapple hook is still flying
// 2  the grapple hooked into a wall
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2517
func GrappleState(_ ms: BotMovestate, _ reach: AasReachability) -> Int32 {
    return AasEntityinfo.scratch { entinfo -> Int32 in
        var i: Int32

        //if the grapple hook is pulling
        if (ms.moveflags & MFL_GRAPPLEPULL) != 0 {
            return 2
        }
        //check for a visible grapple missile entity
        //or visible grapple entity
        i = AAS_NextEntity(0)
        while i != 0 {
            if AAS_EntityType(i) == Int32(entitytypemissile!.value) {
                AAS_EntityInfo(i, entinfo)
                if entinfo.weapon == Int32(weapindex_grapple!.value) {
                    return 1
                }
            }
            i = AAS_NextEntity(i)
        }
        //no valid grapple at all
        return 0
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2547
func BotResetGrapple(_ ms: BotMovestate) {
    AasReachability.scratch { reach in
        AAS_ReachabilityFromNum(ms.lastreachnum, reach)
        //if not using the grapple hook reachability anymore
        if (reach.traveltype & TRAVELTYPE_MASK) != TRAVEL_GRAPPLEHOOK {
            if (ms.moveflags & MFL_ACTIVEGRAPPLE) != 0 || ms.grapplevisible_time != 0 {
                if offhandgrapple!.value != 0 {
                    var buf = CharBuf(cmd_grappleoff!.string!)
                    EA_Command(ms.client, &buf)
                }
                ms.moveflags &= ~MFL_ACTIVEGRAPPLE
                ms.grapplevisible_time = 0
            }
        }
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2573
// AI: Raven declares `result` on the stack of BotTravel_Grapple. The function uses one zeroed allocation on the storage class.
var result_BotTravel_Grapple: BotMoveresult { world.storage.result_BotTravel_Grapple }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2573
func BotTravel_Grapple(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    let result = result_BotTravel_Grapple
    var dist: Float, speed: Float
    var dir = vec3_t(), viewdir = vec3_t(), org = vec3_t()
    var state: Int32, areanum: Int32

    BotClearMoveResult(result)
    //
    if (ms.moveflags & MFL_GRAPPLERESET) != 0 {
        if offhandgrapple!.value != 0 {
            var command = CharBuf(cmd_grappleoff!.string!)
            EA_Command(ms.client, &command)
        }
        ms.moveflags &= ~MFL_ACTIVEGRAPPLE
        return result
    } //end if
    //
    if Int32(offhandgrapple!.value) == 0 {
        result.weapon = Int32(weapindex_grapple!.value)
        result.flags |= MOVERESULT_MOVEMENTWEAPON
    } //end if
    //
    if (ms.moveflags & MFL_ACTIVEGRAPPLE) != 0 {
        //
        state = GrappleState(ms, reach)
        //
        dir = reach.end - ms.origin
        dir[2] = 0
        dist = VectorLength(dir)
        //if very close to the grapple end or the grappled is hooked and
        //the bot doesn't get any closer
        if state != 0 && dist < 48 {
            if ms.lastgrappledist - dist < 1 {
                if offhandgrapple!.value != 0 {
                    var command = CharBuf(cmd_grappleoff!.string!)
                    EA_Command(ms.client, &command)
                }
                ms.moveflags &= ~MFL_ACTIVEGRAPPLE
                ms.moveflags |= MFL_GRAPPLERESET
                ms.reachability_time = 0	//end the reachability
                return result
            } //end if
        } //end if
        //if no valid grapple at all, or the grapple hooked and the bot
        //isn't moving anymore
        else if state == 0 || (state == 2 && dist > ms.lastgrappledist - 2) {
            if Double(ms.grapplevisible_time) < Double(AAS_Time()) - 0.4 {
                if offhandgrapple!.value != 0 {
                    var command = CharBuf(cmd_grappleoff!.string!)
                    EA_Command(ms.client, &command)
                }
                ms.moveflags &= ~MFL_ACTIVEGRAPPLE
                ms.moveflags |= MFL_GRAPPLERESET
                ms.reachability_time = 0	//end the reachability
                return result
            } //end if
        } //end if
        else {
            ms.grapplevisible_time = AAS_Time()
        } //end else
        //
        if Int32(offhandgrapple!.value) == 0 {
            EA_Attack(ms.client)
        } //end if
        //remember the current grapple distance
        ms.lastgrappledist = dist
    } //end if
    else {
        //
        ms.grapplevisible_time = AAS_Time()
        //
        dir = reach.start - ms.origin
        if (ms.moveflags & MFL_SWIMMING) == 0 { dir[2] = 0 }
        org = ms.origin + ms.viewoffset
        viewdir = reach.end - org
        //
        dist = VectorNormalize(&dir)
        vectoangles(viewdir, &result.ideal_viewangles)
        result.flags |= MOVERESULT_MOVEMENTVIEW
        //
        if dist < 5 &&
            abs(AngleDiff(result.ideal_viewangles[0], ms.viewangles[0])) < 2 &&
            abs(AngleDiff(result.ideal_viewangles[1], ms.viewangles[1])) < 2 {
            //check if the grapple missile path is clear
            org = ms.origin + ms.viewoffset
            // Raven's record `trace` serves only this arm, so the scratch covers the arm.
            let blocked = BspTrace.scratch { trace -> Bool in
                trace.copy(from: AAS_Trace(org, nil, nil, reach.end, ms.entitynum, CONTENTS_SOLID))
                dir = reach.end - trace.endpos
                return VectorLength(dir) > 16
            }
            if blocked {
                result.failure = 1
                return result
            } //end if
            //activate the grapple
            if offhandgrapple!.value != 0 {
                var command = CharBuf(cmd_grappleon!.string!)
                EA_Command(ms.client, &command)
            } //end if
            else {
                EA_Attack(ms.client)
            } //end else
            ms.moveflags |= MFL_ACTIVEGRAPPLE
            ms.lastgrappledist = 999999
        } //end if
        else {
            if dist < 70 {
                speed = 300 - (300 - 4 * dist)
            } else {
                speed = 400
            }
            //
            BotCheckBlocked(ms, dir, 1, result)
            //elemantary action move in direction
            EA_Move(ms.client, dir, speed)
            result.movedir = dir
        } //end else
        //if in another area before actually grappling
        areanum = AAS_PointAreaNum(ms.origin)
        if areanum != 0 && areanum != ms.reachareanum { ms.reachability_time = 0 }
    } //end else
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:			-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2727
// AI: Raven declares `result` on the stack of BotTravel_RocketJump. The function uses one zeroed allocation on the storage class.
var result_BotTravel_RocketJump: BotMoveresult { world.storage.result_BotTravel_RocketJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2727
func BotTravel_RocketJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t()
    var dist: Float, speed: Float
    let result = result_BotTravel_RocketJump

    //botimport.Print(PRT_MESSAGE, "BotTravel_RocketJump: bah\n");
    BotClearMoveResult(result)
    //
    hordir[0] = reach.start[0] - ms.origin[0]
    hordir[1] = reach.start[1] - ms.origin[1]
    hordir[2] = 0
    //
    dist = VectorNormalize(&hordir)
    //look in the movement direction
    vectoangles(hordir, &result.ideal_viewangles)
    //look straight down
    result.ideal_viewangles[PITCH] = 90
    //
    if dist < 5 &&
        abs(AngleDiff(result.ideal_viewangles[0], ms.viewangles[0])) < 5 &&
        abs(AngleDiff(result.ideal_viewangles[1], ms.viewangles[1])) < 5 {
        //botimport.Print(PRT_MESSAGE, "between jump start and run start point\n");
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        //elemantary action jump
        EA_Jump(ms.client)
        EA_Attack(ms.client)
        EA_Move(ms.client, hordir, 800)
        //
        ms.jumpreach = ms.lastreachnum
    } //end if
    else {
        if dist > 80 { dist = 80 }
        speed = 400 - (400 - 5 * dist)
        EA_Move(ms.client, hordir, speed)
    } //end else
    //look in the movement direction
    vectoangles(hordir, &result.ideal_viewangles)
    //look straight down
    result.ideal_viewangles[PITCH] = 90
    //set the view angles directly
    EA_View(ms.client, result.ideal_viewangles)
    //view is important for the movment
    result.flags |= MOVERESULT_MOVEMENTVIEWSET
    //select the rocket launcher
    EA_SelectWeapon(ms.client, Int32(weapindex_rocketlauncher!.value))
    //weapon is used for movement
    result.weapon = Int32(weapindex_rocketlauncher!.value)
    result.flags |= MOVERESULT_MOVEMENTWEAPON
    //
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2792
// AI: Raven declares `result` on the stack of BotTravel_BFGJump. The function uses one zeroed allocation on the storage class.
var result_BotTravel_BFGJump: BotMoveresult { world.storage.result_BotTravel_BFGJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2792
func BotTravel_BFGJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t()
    var dist: Float, speed: Float
    let result = result_BotTravel_BFGJump

    //botimport.Print(PRT_MESSAGE, "BotTravel_BFGJump: bah\n");
    BotClearMoveResult(result)
    //
    hordir[0] = reach.start[0] - ms.origin[0]
    hordir[1] = reach.start[1] - ms.origin[1]
    hordir[2] = 0
    //
    dist = VectorNormalize(&hordir)
    //
    if dist < 5 &&
        abs(AngleDiff(result.ideal_viewangles[0], ms.viewangles[0])) < 5 &&
        abs(AngleDiff(result.ideal_viewangles[1], ms.viewangles[1])) < 5 {
        //botimport.Print(PRT_MESSAGE, "between jump start and run start point\n");
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        //elemantary action jump
        EA_Jump(ms.client)
        EA_Attack(ms.client)
        EA_Move(ms.client, hordir, 800)
        //
        ms.jumpreach = ms.lastreachnum
    } //end if
    else {
        if dist > 80 { dist = 80 }
        speed = 400 - (400 - 5 * dist)
        EA_Move(ms.client, hordir, speed)
    } //end else
    //look in the movement direction
    vectoangles(hordir, &result.ideal_viewangles)
    //look straight down
    result.ideal_viewangles[PITCH] = 90
    //set the view angles directly
    EA_View(ms.client, result.ideal_viewangles)
    //view is important for the movment
    result.flags |= MOVERESULT_MOVEMENTVIEWSET
    //select the rocket launcher
    EA_SelectWeapon(ms.client, Int32(weapindex_bfg10k!.value))
    //weapon is used for movement
    result.weapon = Int32(weapindex_bfg10k!.value)
    result.flags |= MOVERESULT_MOVEMENTWEAPON
    //
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2853
// AI: Raven declares `result` on the stack of BotFinishTravel_WeaponJump. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_WeaponJump: BotMoveresult { world.storage.result_BotFinishTravel_WeaponJump }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2853
func BotFinishTravel_WeaponJump(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var hordir = vec3_t()
    var speed: Float = 0
    let result = result_BotFinishTravel_WeaponJump

    BotClearMoveResult(result)
    //if not jumped yet
    if ms.jumpreach == 0 { return result }
    //
    if BotAirControl(ms.origin, ms.velocity, reach.end, &hordir, &speed) == 0 {
        //go straight to the reachability end
        hordir = reach.end - ms.origin
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        speed = 400
    } //end if
    //
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2893
// AI: Raven declares `result` on the stack of BotTravel_JumpPad. The function uses one zeroed allocation on the storage class.
var result_BotTravel_JumpPad: BotMoveresult { world.storage.result_BotTravel_JumpPad }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2893
func BotTravel_JumpPad(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    let speed: Float
    var hordir = vec3_t()
    let result = result_BotTravel_JumpPad

    BotClearMoveResult(result)
    //first walk straight to the reachability start
    hordir[0] = reach.start[0] - ms.origin[0]
    hordir[1] = reach.start[1] - ms.origin[1]
    hordir[2] = 0
    _ = VectorNormalize(&hordir)
    //
    BotCheckBlocked(ms, hordir, 1, result)
    speed = 400
    //elemantary action move in direction
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2920
// AI: Raven declares `result` on the stack of BotFinishTravel_JumpPad. The function uses one zeroed allocation on the storage class.
var result_BotFinishTravel_JumpPad: BotMoveresult { world.storage.result_BotFinishTravel_JumpPad }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2920
func BotFinishTravel_JumpPad(_ ms: BotMovestate, _ reach: AasReachability) -> BotMoveresult {
    var speed: Float = 0
    var hordir = vec3_t()
    let result = result_BotFinishTravel_JumpPad

    BotClearMoveResult(result)
    if BotAirControl(ms.origin, ms.velocity, reach.end, &hordir, &speed) == 0 {
        hordir[0] = reach.end[0] - ms.origin[0]
        hordir[1] = reach.end[1] - ms.origin[1]
        hordir[2] = 0
        _ = VectorNormalize(&hordir)
        speed = 400
    } //end if
    BotCheckBlocked(ms, hordir, 1, result)
    //elemantary action move in direction
    EA_Move(ms.client, hordir, speed)
    result.movedir = hordir
    //
    return result
}

//===========================================================================
// time before the reachability times out
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2949
func BotReachabilityTime(_ reach: AasReachability) -> Int32 {
    switch reach.traveltype & TRAVELTYPE_MASK {
    case TRAVEL_WALK: return 5
    case TRAVEL_CROUCH: return 5
    case TRAVEL_BARRIERJUMP: return 5
    case TRAVEL_LADDER: return 6
    case TRAVEL_WALKOFFLEDGE: return 5
    case TRAVEL_JUMP: return 5
    case TRAVEL_SWIM: return 5
    case TRAVEL_WATERJUMP: return 5
    case TRAVEL_TELEPORT: return 5
    case TRAVEL_ELEVATOR: return 10
    case TRAVEL_GRAPPLEHOOK: return 8
    case TRAVEL_ROCKETJUMP: return 6
    case TRAVEL_BFGJUMP: return 6
    case TRAVEL_JUMPPAD: return 10
    case TRAVEL_FUNCBOB: return 10
    default:
        botimport.runPrint(PRT_ERROR, "travel type %d not implemented yet\n", reach.traveltype)
        return 8
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2981
// AI: Raven declares `result` on the stack of BotMoveInGoalArea. The function uses one zeroed allocation on the storage class.
var result_BotMoveInGoalArea: BotMoveresult { world.storage.result_BotMoveInGoalArea }

/// Source: oracle/codemp/botlib/be_ai_move.cpp:2981
func BotMoveInGoalArea(_ ms: BotMovestate, _ goal: BotGoal) -> BotMoveresult {
    let result = result_BotMoveInGoalArea
    var dir = vec3_t()
    var dist: Float, speed: Float

    BotClearMoveResult(result)
    //walk straight to the goal origin
    dir[0] = goal.origin[0] - ms.origin[0]
    dir[1] = goal.origin[1] - ms.origin[1]
    if (ms.moveflags & MFL_SWIMMING) != 0 {
        dir[2] = goal.origin[2] - ms.origin[2]
        result.traveltype = TRAVEL_SWIM
    } //end if
    else {
        dir[2] = 0
        result.traveltype = TRAVEL_WALK
    } //endif
    //
    dist = VectorNormalize(&dir)
    if dist > 100 { dist = 100 }
    speed = 400 - (400 - 4 * dist)
    if speed < 10 { speed = 0 }
    //
    BotCheckBlocked(ms, dir, 1, result)
    //elemantary action move in direction
    EA_Move(ms.client, dir, speed)
    result.movedir = dir
    //
    if (ms.moveflags & MFL_SWIMMING) != 0 {
        vectoangles(dir, &result.ideal_viewangles)
        result.flags |= MOVERESULT_SWIMVIEW
    } //end if
    //if (!debugline) debugline = botimport.DebugLineCreate();
    //botimport.DebugLineShow(debugline, ms->origin, goal->origin, LINECOLOR_BLUE);
    //
    ms.lastreachnum = 0
    ms.lastareanum = 0
    ms.lastgoalareanum = goal.areanum
    ms.lastorigin = ms.origin
    //
    return result
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:3038
func BotMoveToGoal(_ result: BotMoveresult, _ movestate: Int32, _ goal: BotGoal, _ travelflags: Int32) {
    AasReachability.scratch { reach in
        AasReachability.scratch { lastreach in
            var reachnum: Int32, lastreachnum: Int32, foundjumppad: Int32, ent: Int32, resultflags: Int32
            //vec3_t mins, maxs, up = {0, 0, 1};
            //bsp_trace_t trace;
            //static int debugline;


            BotClearMoveResult(result)
            //
            guard let ms = BotMoveStateFromHandle(movestate) else { return }
            //reset the grapple before testing if the bot has a valid goal
            //because the bot could loose all it's goals when stuck to a wall
            BotResetGrapple(ms)
            //
            //botimport.Print(PRT_MESSAGE, "numavoidreach = %d\n", ms->numavoidreach);
            //remove some of the move flags
            ms.moveflags &= ~(MFL_SWIMMING | MFL_AGAINSTLADDER)
            //set some of the move flags
            //NOTE: the MFL_ONGROUND flag is also set in the higher AI
            if AAS_OnGround(ms.origin, ms.presencetype, ms.entitynum) != 0 { ms.moveflags |= MFL_ONGROUND }
            //
            if (ms.moveflags & MFL_ONGROUND) != 0 {
                var modeltype: Int32, modelnum: Int32

                ent = BotOnTopOfEntity(ms)

                if ent != -1 {
                    modelnum = AAS_EntityModelindex(ent)
                    if modelnum >= 0 && modelnum < MAX_MODELS {
                        modeltype = modeltypes[modelnum]

                        if modeltype == MODELTYPE_FUNC_PLAT {
                            AAS_ReachabilityFromNum(ms.lastreachnum, reach)
                            //if the bot is Not using the elevator
                            if (reach.traveltype & TRAVELTYPE_MASK) != TRAVEL_ELEVATOR ||
                                //NOTE: the face number is the plat model number
                                (reach.facenum & 0x0000FFFF) != modelnum {
                                reachnum = AAS_NextModelReachability(0, modelnum)
                                if reachnum != 0 {
                                    //botimport.Print(PRT_MESSAGE, "client %d: accidentally ended up on func_plat\n", ms->client);
                                    AAS_ReachabilityFromNum(reachnum, reach)
                                    ms.lastreachnum = reachnum
                                    ms.reachability_time = AAS_Time() + BotReachabilityTime(reach)
                                } else {
                                    if bot_developer != 0 {
                                        botimport.runPrint(PRT_MESSAGE, "client %d: on func_plat without reachability\n", ms.client)
                                    }
                                    result.blocked = 1
                                    result.blockentity = ent
                                    result.flags |= MOVERESULT_ONTOPOFOBSTACLE
                                    return
                                }
                            }
                            result.flags |= MOVERESULT_ONTOPOF_ELEVATOR
                        } else if modeltype == MODELTYPE_FUNC_BOB {
                            AAS_ReachabilityFromNum(ms.lastreachnum, reach)
                            //if the bot is Not using the func bobbing
                            if (reach.traveltype & TRAVELTYPE_MASK) != TRAVEL_FUNCBOB ||
                                //NOTE: the face number is the func_bobbing model number
                                (reach.facenum & 0x0000FFFF) != modelnum {
                                reachnum = AAS_NextModelReachability(0, modelnum)
                                if reachnum != 0 {
                                    //botimport.Print(PRT_MESSAGE, "client %d: accidentally ended up on func_bobbing\n", ms->client);
                                    AAS_ReachabilityFromNum(reachnum, reach)
                                    ms.lastreachnum = reachnum
                                    ms.reachability_time = AAS_Time() + BotReachabilityTime(reach)
                                } else {
                                    if bot_developer != 0 {
                                        botimport.runPrint(PRT_MESSAGE, "client %d: on func_bobbing without reachability\n", ms.client)
                                    }
                                    result.blocked = 1
                                    result.blockentity = ent
                                    result.flags |= MOVERESULT_ONTOPOFOBSTACLE
                                    return
                                }
                            }
                            result.flags |= MOVERESULT_ONTOPOF_FUNCBOB
                        } else if modeltype == MODELTYPE_FUNC_STATIC || modeltype == MODELTYPE_FUNC_DOOR {
                            // check if ontop of a door bridge ?
                            ms.areanum = BotFuzzyPointReachabilityArea(ms.origin)
                            // if not in a reachability area
                            if AAS_AreaReachability(ms.areanum) == 0 {
                                result.blocked = 1
                                result.blockentity = ent
                                result.flags |= MOVERESULT_ONTOPOFOBSTACLE
                                return
                            }
                        } else {
                            result.blocked = 1
                            result.blockentity = ent
                            result.flags |= MOVERESULT_ONTOPOFOBSTACLE
                            return
                        }
                    }
                }
            }
            //if swimming
            if AAS_Swimming(ms.origin) != 0 { ms.moveflags |= MFL_SWIMMING }
            //if against a ladder
            if AAS_AgainstLadder(ms.origin) != 0 { ms.moveflags |= MFL_AGAINSTLADDER }
            //if the bot is on the ground, swimming or against a ladder
            if (ms.moveflags & (MFL_ONGROUND | MFL_SWIMMING | MFL_AGAINSTLADDER)) != 0 {
                //botimport.Print(PRT_MESSAGE, "%s: onground, swimming or against ladder\n", ClientName(ms->entitynum-1));
                //
                AAS_ReachabilityFromNum(ms.lastreachnum, lastreach)
                //reachability area the bot is in
                //ms->areanum = BotReachabilityArea(ms->origin, ((lastreach.traveltype & TRAVELTYPE_MASK) != TRAVEL_ELEVATOR));
                ms.areanum = BotFuzzyPointReachabilityArea(ms.origin)
                //
                if ms.areanum == 0 {
                    result.failure = 1
                    result.blocked = 1
                    result.blockentity = 0
                    result.type = RESULTTYPE_INSOLIDAREA
                    return
                }
                //if the bot is in the goal area
                if ms.areanum == goal.areanum {
                    result.copy(from: BotMoveInGoalArea(ms, goal))
                    return
                }
                //assume we can use the reachability from the last frame
                reachnum = ms.lastreachnum
                //if there is a last reachability
                if reachnum != 0 {
                    AAS_ReachabilityFromNum(reachnum, reach)
                    //check if the reachability is still valid
                    if (AAS_TravelFlagForType(reach.traveltype) & travelflags) == 0 {
                        reachnum = 0
                    }
                    //special grapple hook case
                    else if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_GRAPPLEHOOK {
                        if ms.reachability_time < AAS_Time() ||
                            (ms.moveflags & MFL_GRAPPLERESET) != 0 {
                            reachnum = 0
                        }
                    }
                    //special elevator case
                    else if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_ELEVATOR ||
                        (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_FUNCBOB {
                        // Raven tests `result->flags & MOVERESULT_ONTOPOF_FUNCBOB` on both sides of the `||`.
                        // Both read as the same Swift test, so the draft writes it once.
                        if (result.flags & MOVERESULT_ONTOPOF_FUNCBOB) != 0 {
                            ms.reachability_time = AAS_Time() + 5
                        }
                        //if the bot was going for an elevator and reached the reachability area
                        if ms.areanum == reach.areanum ||
                            ms.reachability_time < AAS_Time() {
                            reachnum = 0
                        }
                    } else {
                        //if the goal area changed or the reachability timed out
                        //or the area changed
                        if ms.lastgoalareanum != goal.areanum ||
                            ms.reachability_time < AAS_Time() ||
                            ms.lastareanum != ms.areanum {
                            reachnum = 0
                            //botimport.Print(PRT_MESSAGE, "area change or timeout\n");
                        }
                    }
                }
                resultflags = 0
                //if the bot needs a new reachability
                if reachnum == 0 {
                    //if the area has no reachability links
                    if AAS_AreaReachability(ms.areanum) == 0 {
                    }
                    //get a new reachability leading towards the goal
                    reachnum = BotGetReachabilityToGoal(ms.origin, ms.areanum, ms.lastgoalareanum, ms.lastareanum, ms.avoidreach, ms.avoidreachtimes, ms.avoidreachtries, goal, travelflags, travelflags, ms.avoidspots, ms.numavoidspots, &resultflags)
                    //the area number the reachability starts in
                    ms.reachareanum = ms.areanum
                    //reset some state variables
                    ms.jumpreach = 0						//for TRAVEL_JUMP
                    ms.moveflags &= ~MFL_GRAPPLERESET	//for TRAVEL_GRAPPLEHOOK
                    //if there is a reachability to the goal
                    if reachnum != 0 {
                        AAS_ReachabilityFromNum(reachnum, reach)
                        //set a timeout for this reachability
                        ms.reachability_time = AAS_Time() + BotReachabilityTime(reach)
                        //
                        //add the reachability to the reachabilities to avoid for a while
                        BotAddToAvoidReach(ms, reachnum, Float(AVOIDREACH_TIME))
                    }
                }
                //
                ms.lastreachnum = reachnum
                ms.lastgoalareanum = goal.areanum
                ms.lastareanum = ms.areanum
                //if the bot has a reachability
                if reachnum != 0 {
                    //get the reachability from the number
                    AAS_ReachabilityFromNum(reachnum, reach)
                    result.traveltype = reach.traveltype
                    //
                    //
                    switch reach.traveltype & TRAVELTYPE_MASK {
                    case TRAVEL_WALK:
                        result.copy(from: BotTravel_Walk(ms, reach))
                    case TRAVEL_CROUCH:
                        result.copy(from: BotTravel_Crouch(ms, reach))
                    case TRAVEL_BARRIERJUMP:
                        result.copy(from: BotTravel_BarrierJump(ms, reach))
                    case TRAVEL_LADDER:
                        result.copy(from: BotTravel_Ladder(ms, reach))
                    case TRAVEL_WALKOFFLEDGE:
                        result.copy(from: BotTravel_WalkOffLedge(ms, reach))
                    case TRAVEL_JUMP:
                        result.copy(from: BotTravel_Jump(ms, reach))
                    case TRAVEL_SWIM:
                        result.copy(from: BotTravel_Swim(ms, reach))
                    case TRAVEL_WATERJUMP:
                        result.copy(from: BotTravel_WaterJump(ms, reach))
                    case TRAVEL_TELEPORT:
                        result.copy(from: BotTravel_Teleport(ms, reach))
                    case TRAVEL_ELEVATOR:
                        result.copy(from: BotTravel_Elevator(ms, reach))
                    case TRAVEL_GRAPPLEHOOK:
                        result.copy(from: BotTravel_Grapple(ms, reach))
                    case TRAVEL_ROCKETJUMP:
                        result.copy(from: BotTravel_RocketJump(ms, reach))
                    case TRAVEL_BFGJUMP:
                        result.copy(from: BotTravel_BFGJump(ms, reach))
                    case TRAVEL_JUMPPAD:
                        result.copy(from: BotTravel_JumpPad(ms, reach))
                    case TRAVEL_FUNCBOB:
                        result.copy(from: BotTravel_FuncBobbing(ms, reach))
                    default:
                        botimport.runPrint(PRT_FATAL, "travel type %d not implemented yet\n", reach.traveltype & TRAVELTYPE_MASK)
                    }
                    result.traveltype = reach.traveltype
                    result.flags |= resultflags
                } else {
                    result.failure = 1
                    result.flags |= resultflags
                }
            } else {
                var i: Int32, numareas: Int32
                // AI: Raven declares `int areas[16]` on the stack. The body reads the forward `areas_BotMoveToGoal`.
                var end = vec3_t()

                //special handling of jump pads when the bot uses a jump pad without knowing it
                foundjumppad = 0
                _VectorMA(ms.origin, -2 * ms.thinktime, ms.velocity, &end)
                numareas = AAS_TraceAreas(ms.origin, end, areas_BotMoveToGoal, nil, 16)
                i = numareas - 1
                while i >= 0 {
                    if AAS_AreaJumpPad(areas_BotMoveToGoal[i]) != 0 {
                        //botimport.Print(PRT_MESSAGE, "client %d used a jumppad without knowing, area %d\n", ms->client, areas[i]);
                        foundjumppad = 1
                        lastreachnum = BotGetReachabilityToGoal(end, areas_BotMoveToGoal[i], ms.lastgoalareanum, ms.lastareanum, ms.avoidreach, ms.avoidreachtimes, ms.avoidreachtries, goal, travelflags, TFL_JUMPPAD, ms.avoidspots, ms.numavoidspots, nil)
                        if lastreachnum != 0 {
                            ms.lastreachnum = lastreachnum
                            ms.lastareanum = areas_BotMoveToGoal[i]
                            //botimport.Print(PRT_MESSAGE, "found jumppad reachability\n");
                            break
                        } else {
                            lastreachnum = AAS_NextAreaReachability(areas_BotMoveToGoal[i], 0)
                            while lastreachnum != 0 {
                                //get the reachability from the number
                                AAS_ReachabilityFromNum(lastreachnum, reach)
                                if (reach.traveltype & TRAVELTYPE_MASK) == TRAVEL_JUMPPAD {
                                    ms.lastreachnum = lastreachnum
                                    ms.lastareanum = areas_BotMoveToGoal[i]
                                    //botimport.Print(PRT_MESSAGE, "found jumppad reachability hard!!\n");
                                    break
                                }
                                lastreachnum = AAS_NextAreaReachability(areas_BotMoveToGoal[i], lastreachnum)
                            }
                            if lastreachnum != 0 { break }
                        }
                    }
                    i -= 1
                }
                if bot_developer != 0 {
                    //if a jumppad is found with the trace but no reachability is found
                    if foundjumppad != 0 && ms.lastreachnum == 0 {
                        botimport.runPrint(PRT_MESSAGE, "client %d didn't find jumppad reachability\n", ms.client)
                    }
                }
                //
                if ms.lastreachnum != 0 {
                    //botimport.Print(PRT_MESSAGE, "%s: NOT onground, swimming or against ladder\n", ClientName(ms->entitynum-1));
                    AAS_ReachabilityFromNum(ms.lastreachnum, reach)
                    result.traveltype = reach.traveltype
                    //
                    switch reach.traveltype & TRAVELTYPE_MASK {
                    case TRAVEL_WALK:
                        result.copy(from: BotTravel_Walk(ms, reach)) //BotFinishTravel_Walk(ms, &reach);
                    case TRAVEL_CROUCH: /*do nothing*/ break
                    case TRAVEL_BARRIERJUMP:
                        result.copy(from: BotFinishTravel_BarrierJump(ms, reach))
                    case TRAVEL_LADDER:
                        result.copy(from: BotTravel_Ladder(ms, reach))
                    case TRAVEL_WALKOFFLEDGE:
                        result.copy(from: BotFinishTravel_WalkOffLedge(ms, reach))
                    case TRAVEL_JUMP:
                        result.copy(from: BotFinishTravel_Jump(ms, reach))
                    case TRAVEL_SWIM:
                        result.copy(from: BotTravel_Swim(ms, reach))
                    case TRAVEL_WATERJUMP:
                        result.copy(from: BotFinishTravel_WaterJump(ms, reach))
                    case TRAVEL_TELEPORT: /*do nothing*/ break
                    case TRAVEL_ELEVATOR:
                        result.copy(from: BotFinishTravel_Elevator(ms, reach))
                    case TRAVEL_GRAPPLEHOOK:
                        result.copy(from: BotTravel_Grapple(ms, reach))
                    case TRAVEL_ROCKETJUMP:
                        fallthrough
                    case TRAVEL_BFGJUMP:
                        result.copy(from: BotFinishTravel_WeaponJump(ms, reach))
                    case TRAVEL_JUMPPAD:
                        result.copy(from: BotFinishTravel_JumpPad(ms, reach))
                    case TRAVEL_FUNCBOB:
                        result.copy(from: BotFinishTravel_FuncBobbing(ms, reach))
                    default:
                        botimport.runPrint(PRT_FATAL, "(last) travel type %d not implemented yet\n", reach.traveltype & TRAVELTYPE_MASK)
                    }
                    result.traveltype = reach.traveltype
                }
            }
            //FIXME: is it right to do this here?
            if result.blocked != 0 { ms.reachability_time -= 10 * ms.thinktime }
            //copy the last origin
            ms.lastorigin = ms.origin
            //return the movement result
            return
        }
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:3498
func BotResetAvoidReach(_ movestate: Int32) {
    guard let ms = BotMoveStateFromHandle(movestate) else { return }
    ms.avoidreach.fill(0)
    ms.avoidreachtimes.fill(0)
    ms.avoidreachtries.fill(0)
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:3514
func BotResetLastAvoidReach(_ movestate: Int32) {
    var i: Int32, latest: Int32
    var latesttime: Float

    guard let ms = BotMoveStateFromHandle(movestate) else { return }
    latesttime = 0
    latest = 0
    i = 0
    while i < MAX_AVOIDREACH {
        if ms.avoidreachtimes[i] > latesttime {
            latesttime = ms.avoidreachtimes[i]
            latest = i
        }
        i += 1
    }
    if latesttime != 0 {
        ms.avoidreachtimes[latest] = 0
        // Port-note: Raven reads `avoidreachtries[i]` with `i` equal to MAX_AVOIDREACH, one past the end, the int bits of `avoidspots[0].origin[0]`.
        // The Swift index traps there, rule 19.
        if ms.avoidreachtries[i] > 0 { ms.avoidreachtries[latest] -= 1 }
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:3544
func BotResetMoveState(_ movestate: Int32) {
    guard let ms = BotMoveStateFromHandle(movestate) else { return }
    ms.clear()
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:3558
func BotSetupMoveAI() -> Int32 {
    BotSetBrushModelTypes()
    sv_maxstep = LibVar("sv_step", "18")
    sv_maxbarrier = LibVar("sv_maxbarrier", "32")
    sv_gravity = LibVar("sv_gravity", "800")
    weapindex_rocketlauncher = LibVar("weapindex_rocketlauncher", "5")
    weapindex_bfg10k = LibVar("weapindex_bfg10k", "9")
    weapindex_grapple = LibVar("weapindex_grapple", "10")
    entitytypemissile = LibVar("entitytypemissile", "3")
    offhandgrapple = LibVar("offhandgrapple", "0")
    cmd_grappleon = LibVar("cmd_grappleon", "grappleon")
    cmd_grappleoff = LibVar("cmd_grappleoff", "grappleoff")
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:3579
func BotShutdownMoveAI() {
    var i: Int32

    i = 1
    while i <= MAX_CLIENTS {
        if botmovestates[i] != nil {
            FreeMemory(botmovestates[i]!.handle)
            botmovestates[i] = nil
        }
        i += 1
    }
}
