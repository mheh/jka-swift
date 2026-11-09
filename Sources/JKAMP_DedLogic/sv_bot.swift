import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_bot.cpp:16
private var debugpolygons: Slots<BotDebugpoly>? {
    get { world.variables.sv_bot_debugpolygons }
    set { world.variables.sv_bot_debugpolygons = newValue }
}

/// Source: oracle/codemp/server/sv_bot.cpp:17
var bot_maxdebugpolys: Int32 {
    get { world.variables.bot_maxdebugpolys }
    set { world.variables.bot_maxdebugpolys = newValue }
}

/// Source: oracle/codemp/server/sv_bot.cpp:20
var bot_enable: Int32 {
    get { world.variables.bot_enable }
    set { world.variables.bot_enable = newValue }
}

/// Source: oracle/codemp/server/sv_bot.cpp:22
var gWPNum: Int32 {
    get { world.variables.gWPNum }
    set { world.variables.gWPNum = newValue }
}

/// Source: oracle/codemp/server/sv_bot.cpp:23
var gWPArray: Slots<JKAMP.Wpobject?> { world.storage.gWPArray }

/// Source: oracle/codemp/server/sv_bot.cpp:25
private func NotWithinRange(_ base: Int32, _ extent: Int32) -> Int32 {
    if extent > base && base + 5 >= extent {
        return 0
    }

    if extent < base && base - 5 <= extent {
        return 0
    }

    return 1
}

/// Source: oracle/codemp/server/sv_bot.cpp:40
func SV_OrgVisibleBox(_ org1: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ org2: JKAShared.vec3_t, _ ignore: Int32, _ rmg: Int32) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Int32 in

        if rmg != 0 {
            SV_Trace(tr, org1, nil, nil, org2, ignore, MASK_SOLID, 0, 0, 10)
        } else {
            SV_Trace(tr, org1, mins, maxs, org2, ignore, MASK_SOLID, 0, 0, 10)
        }

        if tr.fraction == 1 && tr.startsolid == 0 && tr.allsolid == 0 {
            return 1
        }

        return 0
    }
}

/// Source: oracle/codemp/server/sv_bot.cpp:63
func SV_BotWaypointReception(_ wpnum: Int32, _ wps: Slots<JKAMP.Wpobject?>) {
    // TODO: Port SV_BotWaypointReception
    portMissing("SV_BotWaypointReception", source: "oracle/codemp/server/sv_bot.cpp:63")
}

/**
```
==================
SV_BotCalculatePaths
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:81
func SV_BotCalculatePaths(_ rmg: Int32) {
    var i: Int32
    var c: Int32
    var forceJumpable: Int32
    var maxNeighborDist: Int32 = MAX_NEIGHBOR_LINK_DISTANCE
    var nLDist: Float
    var a = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()

    if gWPNum == 0 {
        return
    }

    if rmg != 0 {
        maxNeighborDist = Int32(Double(DEFAULT_GRID_SPACING) + (Double(DEFAULT_GRID_SPACING) * 0.5))
    }

    mins[0] = -15
    mins[1] = -15
    mins[2] = -15 //-1
    maxs[0] = 15
    maxs[1] = 15
    maxs[2] = 15 //1

    //now clear out all the neighbor data before we recalculate
    i = 0

    while i < gWPNum {
        // Port-note: The file-scope `wpobject_t *gWPArray[MAX_WPARRAY_SIZE]` has no table row, row B2.
        // Raven wrote: if (gWPArray[i] && gWPArray[i]->inuse && gWPArray[i]->neighbornum) { while (gWPArray[i]->neighbornum >= 0) { gWPArray[i]->neighbors[gWPArray[i]->neighbornum].num = 0; gWPArray[i]->neighbors[gWPArray[i]->neighbornum].forceJumpTo = 0; gWPArray[i]->neighbornum--; } gWPArray[i]->neighbornum = 0; }
        portMissing("SV_BotCalculatePaths", source: "oracle/codemp/server/sv_bot.cpp:81")

        i += 1
    }

    i = 0

    while i < gWPNum {
        // Port-note: The file-scope `wpobject_t *gWPArray[MAX_WPARRAY_SIZE]` has no table row, row B2.
        // Raven wrote: if (gWPArray[i] && gWPArray[i]->inuse) { c = 0; while (c < gWPNum) { if (gWPArray[c] && gWPArray[c]->inuse && i != c && NotWithinRange(i, c)) { VectorSubtract(gWPArray[i]->origin, gWPArray[c]->origin, a); nLDist = VectorLength(a); forceJumpable = qfalse;//CanForceJumpTo(i, c, nLDist); if ((nLDist < maxNeighborDist || forceJumpable) && ((int)gWPArray[i]->origin[2] == (int)gWPArray[c]->origin[2] || forceJumpable) && (SV_OrgVisibleBox(gWPArray[i]->origin, mins, maxs, gWPArray[c]->origin, ENTITYNUM_NONE, rmg) || forceJumpable)) { gWPArray[i]->neighbors[gWPArray[i]->neighbornum].num = c; if (forceJumpable && ((int)gWPArray[i]->origin[2] != (int)gWPArray[c]->origin[2] || nLDist < maxNeighborDist)) { gWPArray[i]->neighbors[gWPArray[i]->neighbornum].forceJumpTo = 999;//forceJumpable; //FJSR } else { gWPArray[i]->neighbors[gWPArray[i]->neighbornum].forceJumpTo = 0; } gWPArray[i]->neighbornum++; } if (gWPArray[i]->neighbornum >= MAX_NEIGHBOR_SIZE) { break; } } c++; } }
        portMissing("SV_BotCalculatePaths", source: "oracle/codemp/server/sv_bot.cpp:81")
        i += 1
    }
}

/**
```
==================
SV_BotAllocateClient
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:178
func SV_BotAllocateClient() -> Int32 {
    var i: Int32
    var cl: Slots<Client>

    // find a client slot
    i = 0
    cl = svs.clientsSlots
    while i < sv_maxclients!.integer {
        if cl[0].state == CS_FREE {
            break
        }
        i += 1
        cl = cl.suffix(from: 1)
    }

    if i == sv_maxclients!.integer {
        return -1
    }

    cl[0].gentity = SV_GentityNum(i)
    cl[0].gentity!.s.number = i
    cl[0].state = CS_ACTIVE
    cl[0].lastPacketTime = svs.time
    cl[0].netchan.remoteAddress.type = NA_BOT
    cl[0].rate = 16384

    return i
}

/**
```
==================
SV_BotFreeClient
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:208
func SV_BotFreeClient(_ clientNum: Int32) {
    var cl: Client?

    if clientNum < 0 || clientNum >= sv_maxclients!.integer {
        Com_Error(ERR_DROP, "SV_BotFreeClient: bad clientNum: %i", clientNum)
    }
    cl = svs.clientsSlots[clientNum]
    cl!.state = CS_FREE
    cl!.name = ""
    if cl!.gentity != nil {
        cl!.gentity!.r.svFlags &= ~SVF_BOT
    }
}

/// Raven's static local of `BotDrawDebugPolygons`.
/// Source: oracle/codemp/server/sv_bot.cpp:228
var bot_debug: Cvar? { get { world.bot_debug } set { world.bot_debug = newValue } }

/// Raven's static local of `BotDrawDebugPolygons`.
/// Source: oracle/codemp/server/sv_bot.cpp:228
var bot_groundonly: Cvar? { get { world.bot_groundonly } set { world.bot_groundonly = newValue } }

/// Raven's static local of `BotDrawDebugPolygons`.
/// Source: oracle/codemp/server/sv_bot.cpp:228
var bot_reachability: Cvar? { get { world.bot_reachability } set { world.bot_reachability = newValue } }

/// Raven's static local of `BotDrawDebugPolygons`.
/// Source: oracle/codemp/server/sv_bot.cpp:228
var bot_highlightarea: Cvar? { get { world.bot_highlightarea } set { world.bot_highlightarea = newValue } }

/**
```
==================
BotDrawDebugPolygons
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:227
func BotDrawDebugPolygons(_ drawPoly: ((Int32, Int32, inout Float) -> Void)?, _ value: Int32) {
    // Raven's `static cvar_t *bot_debug, *bot_groundonly, *bot_reachability, *bot_highlightarea` are the forwards above the function.
    // Port-note: A pointer local `bot_debugpoly_t * poly` with no view, row B3.
    // Raven wrote: bot_debugpoly_t *poly;
    portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
    var i: Int32
    var parm0: Int32

    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: if (!debugpolygons) return
    portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
    //bot debugging
    if bot_debug == nil {
        bot_debug = Cvar_Get("bot_debug", "0", 0)
    }
    //
    if bot_enable != 0 && bot_debug!.integer != 0 {
        //show reachabilities
        if bot_reachability == nil {
            bot_reachability = Cvar_Get("bot_reachability", "0", 0)
        }
        //show ground faces only
        if bot_groundonly == nil {
            bot_groundonly = Cvar_Get("bot_groundonly", "1", 0)
        }
        //get the hightlight area
        if bot_highlightarea == nil {
            bot_highlightarea = Cvar_Get("bot_highlightarea", "0", 0)
        }
        //
        parm0 = 0
        if (svs.clientsSlots[0].lastUsercmd.buttons & BUTTON_ATTACK) != 0 {
            parm0 |= 1
        }
        if bot_reachability!.integer != 0 {
            parm0 |= 2
        }
        if bot_groundonly!.integer != 0 {
            parm0 |= 4
        }
        // Port-note: The host has no form for the botlib export table `botlib_export`, row B1.
        // Raven wrote: botlib_export->BotLibVarSet("bot_highlightarea", bot_highlightarea->string); botlib_export->Test(parm0, NULL, svs.clients[0].gentity->r.currentOrigin, svs.clients[0].gentity->r.currentAngles);
        portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
    } //end if
    //draw all debug polys
    i = 0
    while i < bot_maxdebugpolys {
        // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
        // Raven wrote: poly = &debugpolygons[i]
        portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
        // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
        // Raven wrote: if (!poly->inuse) continue
        portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
        // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
        // Raven wrote: drawPoly(poly->color, poly->numPoints, (float *) poly->points)
        portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
        //Com_Printf("poly %i, numpoints = %d\n", i, poly->numPoints);
        i += 1
    }
}

/**
```
==================
BotImport_Print
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:267
func BotImport_Print(_ type: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...) {
    var str = CharBuf(2048)

    strcpy(&str, JKAShared.format(fmt, args))

    // Port-note: The `PRT_` print types of botlib.h have no host re-export, row B1.
    // Raven wrote: switch(type) { case PRT_MESSAGE: { Com_Printf("%s", str); break; } case PRT_WARNING: { Com_Printf(S_COLOR_YELLOW "Warning: %s", str); break; } case PRT_ERROR: { Com_Printf(S_COLOR_RED "Error: %s", str); break; } case PRT_FATAL: { Com_Printf(S_COLOR_RED "Fatal: %s", str); break; } case PRT_EXIT: { Com_Error(ERR_DROP, S_COLOR_RED "Exit: %s", str); break; } default: { Com_Printf("unknown print type\n"); break; } }
    portMissing("BotImport_Print", source: "oracle/codemp/server/sv_bot.cpp:267")
}

/**
```
==================
BotImport_Trace
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:309
// TODO: Port signature
// Raven wrote: void BotImport_Trace(bsp_trace_t *bsptrace, vec3_t start, vec3_t mins, vec3_t maxs, vec3_t end, int passent, int contentmask)
// No table row for `bsp_trace_t * bsptrace`.
func BotImport_Trace() -> Never {
    // TODO: Port BotImport_Trace
    portMissing("BotImport_Trace", source: "oracle/codemp/server/sv_bot.cpp:309")
}

/**
```
==================
BotImport_EntityTrace
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:334
// TODO: Port signature
// Raven wrote: void BotImport_EntityTrace(bsp_trace_t *bsptrace, vec3_t start, vec3_t mins, vec3_t maxs, vec3_t end, int entnum, int contentmask)
// No table row for `bsp_trace_t * bsptrace`.
func BotImport_EntityTrace() -> Never {
    // TODO: Port BotImport_EntityTrace
    portMissing("BotImport_EntityTrace", source: "oracle/codemp/server/sv_bot.cpp:334")
}

/**
```
==================
BotImport_PointContents
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:360
func BotImport_PointContents(_ point: JKAShared.vec3_t) -> Int32 {
    return SV_PointContents(point, -1)
}

/**
```
==================
BotImport_inPVS
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:369
func BotImport_inPVS(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Int32 {
    return (SV_inPVS(p1, p2) ? 1 : 0)
}

/**
```
==================
BotImport_BSPEntityData
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:378
func BotImport_BSPEntityData() -> String {
    return CM_EntityString()
}

/**
```
==================
BotImport_BSPModelMinsMaxsOrigin
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:387
func BotImport_BSPModelMinsMaxsOrigin(_ modelnum: Int32, _ angles: JKAShared.vec3_t, _ outmins: inout JKAShared.vec3_t, _ outmaxs: inout JKAShared.vec3_t, _ origin: inout JKAShared.vec3_t) {
    let h: clipHandle_t
    var mins = vec3_t()
    var maxs = vec3_t()
    let max: Float
    var i: Int32

    h = CM_InlineModel(modelnum)
    CM_ModelBounds(h, &mins, &maxs)
    //if the model is rotated
    if (angles[0] != 0 || angles[1] != 0 || angles[2] != 0) {
        // expand for rotation

        max = RadiusFromBounds(mins, maxs)
        i = 0
        while i < 3 {
            mins[i] = -max
            maxs[i] = max
            i += 1
        }
    }
    outmins = mins
    outmaxs = maxs
    origin = vec3_t()
}

/// Source: oracle/codemp/server/sv_bot.cpp:416
func Bot_GetMemoryGame(_ size: Int32) -> UnsafeMutableRawPointer {
    // TODO: Port Bot_GetMemoryGame
    portMissing("Bot_GetMemoryGame", source: "oracle/codemp/server/sv_bot.cpp:416")
}

/**
```
==================
BotImport_FreeMemoryGame
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:429
func Bot_FreeMemoryGame(_ ptr: OpaquePointer?) {
    Z_Free(ptr)
}

/**
```
==================
BotImport_GetMemory
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:438
func BotImport_GetMemory(_ size: Int32) -> UnsafeMutableRawPointer {
    // TODO: Port BotImport_GetMemory
    portMissing("BotImport_GetMemory", source: "oracle/codemp/server/sv_bot.cpp:438")
}

/**
```
==================
BotImport_FreeMemory
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:450
func BotImport_FreeMemory(_ ptr: OpaquePointer?) {
    Z_Free(ptr)
}

/**
```
=================
BotImport_HunkAlloc
=================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:459
func BotImport_HunkAlloc(_ size: Int32) -> UnsafeMutableRawPointer {
    // TODO: Port BotImport_HunkAlloc
    portMissing("BotImport_HunkAlloc", source: "oracle/codemp/server/sv_bot.cpp:459")
}

/**
```
==================
BotImport_DebugPolygonCreate
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:471
func BotImport_DebugPolygonCreate(_ color: Int32, _ numPoints: Int32, _ points: Slots<JKAShared.vec3_t>) -> Int32 {
    // Port-note: A pointer local `bot_debugpoly_t * poly` with no view, row B3.
    // Raven wrote: bot_debugpoly_t *poly;
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
    var i: Int32

    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: if (!debugpolygons) return 0
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")

    i = 1
    while i < bot_maxdebugpolys {
        // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
        // Raven wrote: if (!debugpolygons[i].inuse) break
        portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
        i += 1
    }
    if i >= bot_maxdebugpolys {
        return 0
    }
    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: poly = &debugpolygons[i]
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: poly->inuse = qtrue
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: poly->color = color
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: poly->numPoints = numPoints
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: Com_Memcpy(poly->points, points, numPoints * sizeof(vec3_t))
    portMissing("BotImport_DebugPolygonCreate", source: "oracle/codemp/server/sv_bot.cpp:471")
    //
    return i
}

/**
```
==================
BotImport_DebugPolygonShow
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:498
func BotImport_DebugPolygonShow(_ id: Int32, _ color: Int32, _ numPoints: Int32, _ points: Slots<JKAShared.vec3_t>) {
    // Port-note: A pointer local `bot_debugpoly_t * poly` with no view, row B3.
    // Raven wrote: bot_debugpoly_t *poly;
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")

    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: if (!debugpolygons) return
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")
    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: poly = &debugpolygons[id]
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: poly->inuse = qtrue
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: poly->color = color
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: poly->numPoints = numPoints
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")
    // Port-note: A read of `poly`, a local of `bot_debugpoly_t`, which has no view, row B3.
    // Raven wrote: Com_Memcpy(poly->points, points, numPoints * sizeof(vec3_t))
    portMissing("BotImport_DebugPolygonShow", source: "oracle/codemp/server/sv_bot.cpp:498")
}

/**
```
==================
BotImport_DebugPolygonDelete
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:514
func BotImport_DebugPolygonDelete(_ id: Int32) {
    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: if (!debugpolygons) return
    portMissing("BotImport_DebugPolygonDelete", source: "oracle/codemp/server/sv_bot.cpp:514")
    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: debugpolygons[id].inuse = qfalse
    portMissing("BotImport_DebugPolygonDelete", source: "oracle/codemp/server/sv_bot.cpp:514")
}

/**
```
==================
BotImport_DebugLineCreate
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:525
func BotImport_DebugLineCreate() -> Int32 {
    var points = [vec3_t](repeating: vec3_t(), count: 1)
    // Port-note: The `vec3_t *points` parameter with a count beside it is one `inout vec3_t`, and Raven hands it an array, row B4.
    // Raven wrote: return BotImport_DebugPolygonCreate(0, 0, points)
    portMissing("BotImport_DebugLineCreate", source: "oracle/codemp/server/sv_bot.cpp:525")
}

/**
```
==================
BotImport_DebugLineDelete
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:535
func BotImport_DebugLineDelete(_ line: Int32) {
    BotImport_DebugPolygonDelete(line)
}

/**
```
==================
BotImport_DebugLineShow
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:544
func BotImport_DebugLineShow(_ line: Int32, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: Int32) {
    var points = [vec3_t](repeating: vec3_t(), count: 4)
    var dir = vec3_t()
    var cross = vec3_t()
    var up = vec3_t(0, 0, 1)
    let dot: Float

    points[0] = start
    points[1] = start
    //points[1][2] -= 2;
    points[2] = end
    //points[2][2] -= 2;
    points[3] = end


    dir = end - start
    VectorNormalize(&dir)
    dot = _DotProduct(dir, up)
    if Double(dot) > 0.99 || Double(dot) < -0.99 {
        cross = vec3_t(1, 0, 0)
    } else {
        CrossProduct(dir, up, &cross)
    }

    VectorNormalize(&cross)

    _VectorMA(points[0], 2, cross, &points[0])
    _VectorMA(points[1], -2, cross, &points[1])
    _VectorMA(points[2], -2, cross, &points[2])
    _VectorMA(points[3], 2, cross, &points[3])

    // Port-note: The `vec3_t *points` parameter with a count beside it is one `inout vec3_t`, and Raven hands it an array, row B4.
    // Raven wrote: BotImport_DebugPolygonShow(line, color, 4, points)
    portMissing("BotImport_DebugLineShow", source: "oracle/codemp/server/sv_bot.cpp:544")
}

/**
```
==================
SV_BotClientCommand
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:577
func BotClientCommand(_ client: Int32, _ command: String) {
    SV_ExecuteClientCommand(svs.clientsSlots[client], command, true)
}

/**
```
==================
SV_BotFrame
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:586
func SV_BotFrame(_ time: Int32) {
    if bot_enable == 0 {
        return
    }
    //NOTE: maybe the game is already shutdown
    if gvm == nil {
        return
    }
    VM_Call(gvm!, BOTAI_START_FRAME, time)
}

/**
```
===============
SV_BotLibSetup
===============
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:598
func SV_BotLibSetup() -> Int32 {
    if bot_enable == 0 {
        return 0
    }

    // Port-note: The host has no form for the botlib export table `botlib_export`, row B1.
    // Raven wrote: if ( !botlib_export ) { Com_Printf( S_COLOR_RED "Error: SV_BotLibSetup without SV_BotInitBotLib\n" ); return -1; }
    portMissing("SV_BotLibSetup", source: "oracle/codemp/server/sv_bot.cpp:598")

    // Port-note: The host has no form for the botlib export table `botlib_export`, row B1.
    // Raven wrote: return botlib_export->BotLibSetup()
    portMissing("SV_BotLibSetup", source: "oracle/codemp/server/sv_bot.cpp:598")
}

/**
```
===============
SV_ShutdownBotLib

Called when either the entire server is being killed, or
it is changing to a different game directory.
===============
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:619
func SV_BotLibShutdown() -> Int32 {
    // Port-note: The host has no form for the botlib export table `botlib_export`, row B1.
    // Raven wrote: if ( !botlib_export ) { return -1; }
    portMissing("SV_BotLibShutdown", source: "oracle/codemp/server/sv_bot.cpp:619")

    // Port-note: The host has no form for the botlib export table `botlib_export`, row B1.
    // Raven wrote: return botlib_export->BotLibShutdown()
    portMissing("SV_BotLibShutdown", source: "oracle/codemp/server/sv_bot.cpp:619")
}

/**
```
==================
SV_BotInitCvars
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:633
func SV_BotInitCvars() {
    Cvar_Get("bot_enable", "1", 0) //enable the bot
    Cvar_Get("bot_developer", "0", CVAR_CHEAT) //bot developer mode
    Cvar_Get("bot_debug", "0", CVAR_CHEAT) //enable bot debugging
    Cvar_Get("bot_maxdebugpolys", "2", 0) //maximum number of debug polys
    Cvar_Get("bot_groundonly", "1", 0) //only show ground faces of areas
    Cvar_Get("bot_reachability", "0", 0) //show all reachabilities to other areas
    Cvar_Get("bot_visualizejumppads", "0", CVAR_CHEAT) //show jumppads
    Cvar_Get("bot_forceclustering", "0", 0) //force cluster calculations
    Cvar_Get("bot_forcereachability", "0", 0) //force reachability calculations
    Cvar_Get("bot_forcewrite", "0", 0) //force writing aas file
    Cvar_Get("bot_aasoptimize", "0", 0) //no aas file optimisation
    Cvar_Get("bot_saveroutingcache", "0", 0) //save routing cache
    Cvar_Get("bot_thinktime", "100", CVAR_CHEAT) //msec the bots thinks
    Cvar_Get("bot_reloadcharacters", "0", 0) //reload the bot characters each time
    Cvar_Get("bot_testichat", "0", 0) //test ichats
    Cvar_Get("bot_testrchat", "0", 0) //test rchats
    Cvar_Get("bot_testsolid", "0", CVAR_CHEAT) //test for solid areas
    Cvar_Get("bot_testclusters", "0", CVAR_CHEAT) //test the AAS clusters
    Cvar_Get("bot_fastchat", "0", 0) //fast chatting bots
    Cvar_Get("bot_nochat", "0", 0) //disable chats
    Cvar_Get("bot_pause", "0", CVAR_CHEAT) //pause the bots thinking
    Cvar_Get("bot_report", "0", CVAR_CHEAT) //get a full report in ctf
    Cvar_Get("bot_grapple", "0", 0) //enable grapple
    Cvar_Get("bot_rocketjump", "1", 0) //enable rocket jumping
    Cvar_Get("bot_challenge", "0", 0) //challenging bot
    Cvar_Get("bot_minplayers", "0", 0) //minimum players in a team or the game
    Cvar_Get("bot_interbreedchar", "", CVAR_CHEAT) //bot character used for interbreeding
    Cvar_Get("bot_interbreedbots", "10", CVAR_CHEAT) //number of bots used for interbreeding
    Cvar_Get("bot_interbreedcycle", "20", CVAR_CHEAT) //bot interbreeding cycle
    Cvar_Get("bot_interbreedwrite", "", CVAR_CHEAT) //write interbreeded bots to this file
}

// there's no such thing as this now, since the zone is unlimited, but I have to provide something
//	so it doesn't run out of control alloc-wise (since the bot code calls this in a while() loop to free
//	up bot mem until zone has > 1MB available again. So, simulate a reasonable limit...
//
/// Source: oracle/codemp/server/sv_bot.cpp:673
private func bot_Z_AvailableMemory() -> Int32 {
    let iMaxBOTLIBMem: Int32 = 8 * 1024 * 1024
    return iMaxBOTLIBMem - Z_MemSize(TAG_BOTLIB)
}

/**
```
==================
SV_BotInitBotLib
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:684
func SV_BotInitBotLib() {
    // Port-note: A local `botlib_import_t botlib_import`, the import table of the botlib, has no host type, row B1.
    // Raven wrote: botlib_import_t botlib_import;
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: if (debugpolygons) Z_Free(debugpolygons)
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    bot_maxdebugpolys = Cvar_VariableIntegerValue("bot_maxdebugpolys")
    // Port-note: The file-scope `bot_debugpoly_t *debugpolygons` has no table row, row B3.
    // Raven wrote: debugpolygons = (struct bot_debugpoly_s *)Z_Malloc(sizeof(bot_debugpoly_t) * bot_maxdebugpolys, TAG_BOTLIB, qtrue)
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.Print = BotImport_Print
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.Trace = BotImport_Trace
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.EntityTrace = BotImport_EntityTrace
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.PointContents = BotImport_PointContents
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.inPVS = BotImport_inPVS
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.BSPEntityData = BotImport_BSPEntityData
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.BSPModelMinsMaxsOrigin = BotImport_BSPModelMinsMaxsOrigin
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.BotClientCommand = BotClientCommand
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    //memory management
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.GetMemory = BotImport_GetMemory
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.FreeMemory = BotImport_FreeMemory
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.AvailableMemory = bot_Z_AvailableMemory
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.HunkAlloc = BotImport_HunkAlloc
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    // file system access
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.FS_FOpenFile = FS_FOpenFileByMode
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.FS_Read = FS_Read2
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.FS_Write = FS_Write
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.FS_FCloseFile = FS_FCloseFile
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.FS_Seek = FS_Seek
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    //debug lines
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.DebugLineCreate = BotImport_DebugLineCreate
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.DebugLineDelete = BotImport_DebugLineDelete
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.DebugLineShow = BotImport_DebugLineShow
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    //debug polygons
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.DebugPolygonCreate = BotImport_DebugPolygonCreate
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // Port-note: A store into the botlib import table `botlib_import`, row B1.
    // Raven wrote: botlib_import.DebugPolygonDelete = BotImport_DebugPolygonDelete
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")

    // Port-note: The host has no form for the botlib export table `botlib_export` or for `GetBotLibAPI`, row B1.
    // Raven wrote: botlib_export = (botlib_export_t *)GetBotLibAPI( BOTLIB_API_VERSION, &botlib_import )
    portMissing("SV_BotInitBotLib", source: "oracle/codemp/server/sv_bot.cpp:684")
    // bk001129 - somehow we end up with a zero import.
}

/**
```
==================
SV_BotGetConsoleMessage
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:736
func SV_BotGetConsoleMessage(_ client: Int32, _ buf: inout JKAShared.CharBuf, _ size: Int32) -> Int32 {
    var cl: Client?
    let index: Int32

    cl = svs.clientsSlots[client]
    cl!.lastPacketTime = svs.time

    if cl!.reliableAcknowledge == cl!.reliableSequence {
        return 0
    }

    cl!.reliableAcknowledge += 1
    index = cl!.reliableAcknowledge & (MAX_RELIABLE_COMMANDS - 1)

    if cl!.reliableCommands[index].isEmpty {
        return 0
    }

    Q_strncpyz(&buf, cl!.reliableCommands[index], size)
    return 1
}

/**
```
==================
SV_BotGetSnapshotEntity
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:786
func SV_BotGetSnapshotEntity(_ client: Int32, _ sequence: Int32) -> Int32 {
    var cl: Client?
    var frame: ClientSnapshot?

    cl = svs.clientsSlots[client]
    frame = cl!.frames[cl!.netchan.outgoingSequence & PACKET_MASK]
    if sequence < 0 || sequence >= frame!.num_entities {
        return -1
    }
    return svs.snapshotEntitiesSlots[(frame!.first_entity + sequence) % svs.numSnapshotEntities].number
}
