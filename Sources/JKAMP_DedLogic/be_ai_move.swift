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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "move state handle %d out of range\n", handle);
        portMissing("BotFreeMoveState", source: "oracle/codemp/botlib/be_ai_move.cpp:130")
        return
    }
    if botmovestates[handle] == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "invalid move state %d\n", handle);
        portMissing("BotFreeMoveState", source: "oracle/codemp/botlib/be_ai_move.cpp:130")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "move state handle %d out of range\n", handle);
        portMissing("BotMoveStateFromHandle", source: "oracle/codemp/botlib/be_ai_move.cpp:151")
        return nil
    }
    if botmovestates[handle] == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "invalid move state %d\n", handle);
        portMissing("BotMoveStateFromHandle", source: "oracle/codemp/botlib/be_ai_move.cpp:151")
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
                // Port-note: AAS_Trace returns a `bsp_trace_t` record with no signature, row P13 of the bot-ai round.
                // Raven wrote: bsptrace = AAS_Trace(origin, mins, maxs, end, client, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
                portMissing("BotReachabilityArea", source: "oracle/codemp/botlib/be_ai_move.cpp:284")
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
                    // Port-note: AAS_TraceClientBBox returns an `aas_trace_t` record with no signature, row P13 of the bot-ai round.
                    // Raven wrote: trace = AAS_TraceClientBBox(org, end, PRESENCE_CROUCH, -1);
                    portMissing("BotReachabilityArea", source: "oracle/codemp/botlib/be_ai_move.cpp:284")
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
        // Port-note: AAS_BSPModelMinsMaxsOrigin writes `mins` and `maxs`, and its signature takes them by value, row P10 of the bot-ai round.
        // Raven wrote: AAS_BSPModelMinsMaxsOrigin(modelnum, angles, mins, maxs, NULL);
        portMissing("BotOnMover", source: "oracle/codemp/botlib/be_ai_move.cpp:425")
        //
        if AAS_OriginOfMoverWithModelNum(modelnum, &modelorigin) == 0 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "no entity with model %d\n", modelnum);
            portMissing("BotOnMover", source: "oracle/codemp/botlib/be_ai_move.cpp:425")
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
        // Port-note: AAS_Trace returns a `bsp_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_Trace(org, boxmins, boxmaxs, end, entnum, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
        portMissing("BotOnMover", source: "oracle/codemp/botlib/be_ai_move.cpp:425")
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
    // Port-note: AAS_BSPModelMinsMaxsOrigin writes `mins`, `maxs`, and `origin`, and its signature takes them by value, row P10 of the bot-ai round.
    // Raven wrote: AAS_BSPModelMinsMaxsOrigin(modelnum, angles, mins, maxs, origin);
    portMissing("MoverDown", source: "oracle/codemp/botlib/be_ai_move.cpp:471")
    //
    if AAS_OriginOfMoverWithModelNum(modelnum, &origin) == 0 {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "no entity with model %d\n", modelnum);
        portMissing("MoverDown", source: "oracle/codemp/botlib/be_ai_move.cpp:471")
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
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "entity %s model number out of range\n", classname);
            portMissing("BotSetBrushModelTypes", source: "oracle/codemp/botlib/be_ai_move.cpp:496")
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
        // Port-note: AAS_Trace returns a `bsp_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_Trace(ms->origin, mins, maxs, end, ms->entitynum, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
        portMissing("BotOnTopOfEntity", source: "oracle/codemp/botlib/be_ai_move.cpp:532")
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
func BotGetReachabilityToGoal(_ origin: JKAShared.vec3_t, _ areanum: Int32, _ lastgoalareanum: Int32, _ lastareanum: Int32, _ avoidreach: Slots<Int32>, _ avoidreachtimes: Slots<Float>, _ avoidreachtries: Slots<Int32>, _ goal: BotGoal, _ travelflags: Int32, _ movetravelflags: Int32, _ avoidspots: BotAvoidspot?, _ numavoidspots: Int32, _ flags: UnsafeMutablePointer<Int32>?) -> Int32 {
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
            // Port-note: The `avoidspots` parameter is one `BotAvoidspot?`, and BotAvoidSpots takes a table, row P11 of the bot-ai round.
            // Raven wrote: if (BotAvoidSpots(origin, &reach, avoidspots, numavoidspots)) { if (flags) { *flags |= MOVERESULT_BLOCKEDBYAVOIDSPOT; } continue; }
            portMissing("BotGetReachabilityToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:727")
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
        // Port-note: AAS_Trace returns a `bsp_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_Trace(eye, NULL, NULL, target, ent, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
        portMissing("BotVisible", source: "oracle/codemp/botlib/be_ai_move.cpp:881")
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

        // Port-note: The local arrays `avoidreach`, `avoidreachtimes`, and `avoidreachtries` have no Slots storage, row P12 of the bot-ai round.
        // Raven wrote: Com_Memset(avoidreach, 0, MAX_AVOIDREACH * sizeof(int));
        portMissing("BotPredictVisiblePosition", source: "oracle/codemp/botlib/be_ai_move.cpp:895")
        lastgoalareanum = goal.areanum
        lastareanum = areanum
        end = origin
        //only do 20 hops
        i = 0
        while i < 20 && (areanum != goal.areanum) {
            //
            // Port-note: The local arrays `avoidreach`, `avoidreachtimes`, and `avoidreachtries` have no Slots storage, row P12 of the bot-ai round.
            // Raven wrote: reachnum = BotGetReachabilityToGoal(end, areanum, lastgoalareanum, lastareanum, avoidreach, avoidreachtimes, avoidreachtries, goal, travelflags, travelflags, NULL, 0, NULL);
            portMissing("BotPredictVisiblePosition", source: "oracle/codemp/botlib/be_ai_move.cpp:895")
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
    // Port-note: AAS_BSPModelMinsMaxsOrigin writes `mins`, `maxs`, and `origin`, and its signature takes them by value, row P10 of the bot-ai round.
    // Raven wrote: AAS_BSPModelMinsMaxsOrigin(modelnum, angles, mins, maxs, origin);
    portMissing("MoverBottomCenter", source: "oracle/codemp/botlib/be_ai_move.cpp:958")
    //
    if AAS_OriginOfMoverWithModelNum(modelnum, &origin) == 0 {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "no entity with model %d\n", modelnum);
        portMissing("MoverBottomCenter", source: "oracle/codemp/botlib/be_ai_move.cpp:958")
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
            // Port-note: AAS_TraceClientBBox returns an `aas_trace_t` record with no signature, row P13 of the bot-ai round.
            // Raven wrote: trace = AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, entnum);
            portMissing("BotGapDistance", source: "oracle/codemp/botlib/be_ai_move.cpp:983")
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
            // Port-note: AAS_TraceClientBBox returns an `aas_trace_t` record with no signature, row P13 of the bot-ai round.
            // Raven wrote: trace = AAS_TraceClientBBox(start, end, PRESENCE_CROUCH, entnum);
            portMissing("BotGapDistance", source: "oracle/codemp/botlib/be_ai_move.cpp:983")
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
        // Port-note: AAS_TraceClientBBox returns an `aas_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_TraceClientBBox(ms->origin, end, PRESENCE_NORMAL, ms->entitynum);
        portMissing("BotCheckBarrierJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1032")
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
        // Port-note: AAS_TraceClientBBox returns an `aas_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, ms->entitynum);
        portMissing("BotCheckBarrierJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1032")
        //again this shouldn't happen
        if trace.startsolid { return 0 }
        //
        start = trace.endpos
        end = trace.endpos
        end[2] = ms.origin[2]
        //trace down from the previous trace end pos
        // Port-note: AAS_TraceClientBBox returns an `aas_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_TraceClientBBox(start, end, PRESENCE_NORMAL, ms->entitynum);
        portMissing("BotCheckBarrierJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1032")
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
        // Port-note: AAS_Trace returns a `bsp_trace_t` record with no signature, row P13 of the bot-ai round.
        // Raven wrote: trace = AAS_Trace(ms->origin, mins, maxs, end, ms->entitynum, CONTENTS_SOLID|CONTENTS_PLAYERCLIP|CONTENTS_BODY);
        portMissing("BotCheckBlocked", source: "oracle/codemp/botlib/be_ai_move.cpp:1265")
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
            // Port-note: AAS_Trace returns a `bsp_trace_t` record with no signature, row P13 of the bot-ai round.
            // Raven wrote: trace = AAS_Trace(ms->origin, mins, maxs, end, ms->entitynum, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
            portMissing("BotCheckBlocked", source: "oracle/codemp/botlib/be_ai_move.cpp:1265")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Walk(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Walk() -> Never {
    // TODO: Port BotTravel_Walk
    portMissing("BotTravel_Walk", source: "oracle/codemp/botlib/be_ai_move.cpp:1328")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1383
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_Walk(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_Walk() -> Never {
    // TODO: Port BotFinishTravel_Walk
    portMissing("BotFinishTravel_Walk", source: "oracle/codemp/botlib/be_ai_move.cpp:1383")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1421
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Crouch(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Crouch() -> Never {
    // TODO: Port BotTravel_Crouch
    portMissing("BotTravel_Crouch", source: "oracle/codemp/botlib/be_ai_move.cpp:1421")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1451
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_BarrierJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_BarrierJump() -> Never {
    // TODO: Port BotTravel_BarrierJump
    portMissing("BotTravel_BarrierJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1451")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1486
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_BarrierJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_BarrierJump() -> Never {
    // TODO: Port BotFinishTravel_BarrierJump
    portMissing("BotFinishTravel_BarrierJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1486")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1515
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Swim(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Swim() -> Never {
    // TODO: Port BotTravel_Swim
    portMissing("BotTravel_Swim", source: "oracle/codemp/botlib/be_ai_move.cpp:1515")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1541
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_WaterJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_WaterJump() -> Never {
    // TODO: Port BotTravel_WaterJump
    portMissing("BotTravel_WaterJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1541")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1575
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_WaterJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_WaterJump() -> Never {
    // TODO: Port BotFinishTravel_WaterJump
    portMissing("BotFinishTravel_WaterJump", source: "oracle/codemp/botlib/be_ai_move.cpp:1575")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1612
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_WalkOffLedge(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_WalkOffLedge() -> Never {
    // TODO: Port BotTravel_WalkOffLedge
    portMissing("BotTravel_WalkOffLedge", source: "oracle/codemp/botlib/be_ai_move.cpp:1612")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_WalkOffLedge(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_WalkOffLedge() -> Never {
    // TODO: Port BotFinishTravel_WalkOffLedge
    portMissing("BotFinishTravel_WalkOffLedge", source: "oracle/codemp/botlib/be_ai_move.cpp:1712")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Jump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Jump() -> Never {
    // TODO: Port BotTravel_Jump
    portMissing("BotTravel_Jump", source: "oracle/codemp/botlib/be_ai_move.cpp:1872")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_Jump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_Jump() -> Never {
    // TODO: Port BotFinishTravel_Jump
    portMissing("BotFinishTravel_Jump", source: "oracle/codemp/botlib/be_ai_move.cpp:1943")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:1978
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Ladder(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Ladder() -> Never {
    // TODO: Port BotTravel_Ladder
    portMissing("BotTravel_Ladder", source: "oracle/codemp/botlib/be_ai_move.cpp:1978")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2034
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Teleport(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Teleport() -> Never {
    // TODO: Port BotTravel_Teleport
    portMissing("BotTravel_Teleport", source: "oracle/codemp/botlib/be_ai_move.cpp:2034")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2065
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Elevator(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Elevator() -> Never {
    // TODO: Port BotTravel_Elevator
    portMissing("BotTravel_Elevator", source: "oracle/codemp/botlib/be_ai_move.cpp:2065")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2216
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_Elevator(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_Elevator() -> Never {
    // TODO: Port BotFinishTravel_Elevator
    portMissing("BotFinishTravel_Elevator", source: "oracle/codemp/botlib/be_ai_move.cpp:2216")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "BotFuncBobStartEnd: no entity with model %d\n", modelnum);
        portMissing("BotFuncBobStartEnd", source: "oracle/codemp/botlib/be_ai_move.cpp:2246")
        start = vec3_t(0, 0, 0)
        end = vec3_t(0, 0, 0)
        return
    }
    // Port-note: AAS_BSPModelMinsMaxsOrigin writes `mins` and `maxs`, and its signature takes them by value, row P10 of the bot-ai round.
    // Raven wrote: AAS_BSPModelMinsMaxsOrigin(modelnum, angles, mins, maxs, NULL);
    portMissing("BotFuncBobStartEnd", source: "oracle/codemp/botlib/be_ai_move.cpp:2246")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_FuncBobbing(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_FuncBobbing() -> Never {
    // TODO: Port BotTravel_FuncBobbing
    portMissing("BotTravel_FuncBobbing", source: "oracle/codemp/botlib/be_ai_move.cpp:2304")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2462
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_FuncBobbing(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_FuncBobbing() -> Never {
    // TODO: Port BotFinishTravel_FuncBobbing
    portMissing("BotFinishTravel_FuncBobbing", source: "oracle/codemp/botlib/be_ai_move.cpp:2462")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_Grapple(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_Grapple() -> Never {
    // TODO: Port BotTravel_Grapple
    portMissing("BotTravel_Grapple", source: "oracle/codemp/botlib/be_ai_move.cpp:2573")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:			-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2727
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_RocketJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_RocketJump() -> Never {
    // TODO: Port BotTravel_RocketJump
    portMissing("BotTravel_RocketJump", source: "oracle/codemp/botlib/be_ai_move.cpp:2727")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2792
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_BFGJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_BFGJump() -> Never {
    // TODO: Port BotTravel_BFGJump
    portMissing("BotTravel_BFGJump", source: "oracle/codemp/botlib/be_ai_move.cpp:2792")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2853
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_WeaponJump(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_WeaponJump() -> Never {
    // TODO: Port BotFinishTravel_WeaponJump
    portMissing("BotFinishTravel_WeaponJump", source: "oracle/codemp/botlib/be_ai_move.cpp:2853")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2893
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotTravel_JumpPad(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotTravel_JumpPad() -> Never {
    // TODO: Port BotTravel_JumpPad
    portMissing("BotTravel_JumpPad", source: "oracle/codemp/botlib/be_ai_move.cpp:2893")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_move.cpp:2920
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotFinishTravel_JumpPad(bot_movestate_t *ms, aas_reachability_t *reach)
// No table row for the return `bot_moveresult_t`.
func BotFinishTravel_JumpPad() -> Never {
    // TODO: Port BotFinishTravel_JumpPad
    portMissing("BotFinishTravel_JumpPad", source: "oracle/codemp/botlib/be_ai_move.cpp:2920")
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
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "travel type %d not implemented yet\n", reach->traveltype);
        portMissing("BotReachabilityTime", source: "oracle/codemp/botlib/be_ai_move.cpp:2949")
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
// TODO: Port signature
// Raven wrote: bot_moveresult_t BotMoveInGoalArea(bot_movestate_t *ms, bot_goal_t *goal)
// No table row for the return `bot_moveresult_t`.
func BotMoveInGoalArea() -> Never {
    // TODO: Port BotMoveInGoalArea
    portMissing("BotMoveInGoalArea", source: "oracle/codemp/botlib/be_ai_move.cpp:2981")
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
                                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                                        // Raven wrote: botimport.Print(PRT_MESSAGE, "client %d: on func_plat without reachability\n", ms->client);
                                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                                        // Raven wrote: botimport.Print(PRT_MESSAGE, "client %d: on func_bobbing without reachability\n", ms->client);
                                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                    // Port-note: BotMoveInGoalArea returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                    // Raven wrote: *result = BotMoveInGoalArea(ms, goal);
                    portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                    // Port-note: Raven hands the table `ms->avoidspots` to one `BotAvoidspot?`, row P11 of the bot-ai round.
                    // Raven wrote: reachnum = BotGetReachabilityToGoal(ms->origin, ms->areanum, ms->lastgoalareanum, ms->lastareanum, ms->avoidreach, ms->avoidreachtimes, ms->avoidreachtries, goal, travelflags, travelflags, ms->avoidspots, ms->numavoidspots, &resultflags);
                    portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                        // Port-note: BotTravel_Walk returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Walk(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_CROUCH:
                        // Port-note: BotTravel_Crouch returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Crouch(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_BARRIERJUMP:
                        // Port-note: BotTravel_BarrierJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_BarrierJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_LADDER:
                        // Port-note: BotTravel_Ladder returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Ladder(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_WALKOFFLEDGE:
                        // Port-note: BotTravel_WalkOffLedge returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_WalkOffLedge(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_JUMP:
                        // Port-note: BotTravel_Jump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Jump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_SWIM:
                        // Port-note: BotTravel_Swim returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Swim(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_WATERJUMP:
                        // Port-note: BotTravel_WaterJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_WaterJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_TELEPORT:
                        // Port-note: BotTravel_Teleport returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Teleport(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_ELEVATOR:
                        // Port-note: BotTravel_Elevator returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Elevator(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_GRAPPLEHOOK:
                        // Port-note: BotTravel_Grapple returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Grapple(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_ROCKETJUMP:
                        // Port-note: BotTravel_RocketJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_RocketJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_BFGJUMP:
                        // Port-note: BotTravel_BFGJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_BFGJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_JUMPPAD:
                        // Port-note: BotTravel_JumpPad returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_JumpPad(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_FUNCBOB:
                        // Port-note: BotTravel_FuncBobbing returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_FuncBobbing(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    default:
                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                        // Raven wrote: botimport.Print(PRT_FATAL, "travel type %d not implemented yet\n", (reach.traveltype & TRAVELTYPE_MASK));
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                        // Port-note: Raven hands the table `ms->avoidspots` to one `BotAvoidspot?`, row P11 of the bot-ai round.
                        // Raven wrote: lastreachnum = BotGetReachabilityToGoal(end, areas[i], ms->lastgoalareanum, ms->lastareanum, ms->avoidreach, ms->avoidreachtimes, ms->avoidreachtries, goal, travelflags, TFL_JUMPPAD, ms->avoidspots, ms->numavoidspots, NULL);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                        // Raven wrote: botimport.Print(PRT_MESSAGE, "client %d didn't find jumppad reachability\n", ms->client);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
                        // Port-note: BotTravel_Walk returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Walk(ms, &reach); break;//BotFinishTravel_Walk(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_CROUCH: /*do nothing*/ break
                    case TRAVEL_BARRIERJUMP:
                        // Port-note: BotFinishTravel_BarrierJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_BarrierJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_LADDER:
                        // Port-note: BotTravel_Ladder returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Ladder(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_WALKOFFLEDGE:
                        // Port-note: BotFinishTravel_WalkOffLedge returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_WalkOffLedge(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_JUMP:
                        // Port-note: BotFinishTravel_Jump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_Jump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_SWIM:
                        // Port-note: BotTravel_Swim returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Swim(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_WATERJUMP:
                        // Port-note: BotFinishTravel_WaterJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_WaterJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_TELEPORT: /*do nothing*/ break
                    case TRAVEL_ELEVATOR:
                        // Port-note: BotFinishTravel_Elevator returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_Elevator(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_GRAPPLEHOOK:
                        // Port-note: BotTravel_Grapple returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotTravel_Grapple(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_ROCKETJUMP:
                        fallthrough
                    case TRAVEL_BFGJUMP:
                        // Port-note: BotFinishTravel_WeaponJump returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_WeaponJump(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_JUMPPAD:
                        // Port-note: BotFinishTravel_JumpPad returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_JumpPad(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    case TRAVEL_FUNCBOB:
                        // Port-note: BotFinishTravel_FuncBobbing returns a `bot_moveresult_t` record with no signature, row P13 of the bot-ai round.
                        // Raven wrote: *result = BotFinishTravel_FuncBobbing(ms, &reach);
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
                    default:
                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                        // Raven wrote: botimport.Print(PRT_FATAL, "(last) travel type %d not implemented yet\n", (reach.traveltype & TRAVELTYPE_MASK));
                        portMissing("BotMoveToGoal", source: "oracle/codemp/botlib/be_ai_move.cpp:3038")
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
