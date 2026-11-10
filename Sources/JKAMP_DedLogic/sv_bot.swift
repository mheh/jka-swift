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
    var i: Int32 = 0

    gWPNum = wpnum

    while i < gWPNum {
        // AI: Raven maps each pointer through BotVMShift, which gives the same address for a module library. The body copies the pointer.
        gWPArray[i] = wps[i]
        i += 1
    }
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
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 && gWPArray[i]!.neighbornum != 0 {
            while gWPArray[i]!.neighbornum >= 0 {
                gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].num = 0
                gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].forceJumpTo = 0
                gWPArray[i]!.neighbornum -= 1
            }
            gWPArray[i]!.neighbornum = 0
        }

        i += 1
    }

    i = 0

    while i < gWPNum {
        if gWPArray[i] != nil && gWPArray[i]!.inuse != 0 {
            c = 0

            while c < gWPNum {
                if gWPArray[c] != nil && gWPArray[c]!.inuse != 0 && i != c && NotWithinRange(i, c) != 0 {
                    a = gWPArray[i]!.origin - gWPArray[c]!.origin

                    nLDist = VectorLength(a)
                    forceJumpable = 0 //CanForceJumpTo(i, c, nLDist);

                    if (nLDist < maxNeighborDist || forceJumpable != 0) && (Int32(gWPArray[i]!.origin[2]) == Int32(gWPArray[c]!.origin[2]) || forceJumpable != 0) && (SV_OrgVisibleBox(gWPArray[i]!.origin, mins, maxs, gWPArray[c]!.origin, ENTITYNUM_NONE, rmg) != 0 || forceJumpable != 0) {
                        gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].num = c
                        if forceJumpable != 0 && (Int32(gWPArray[i]!.origin[2]) != Int32(gWPArray[c]!.origin[2]) || nLDist < maxNeighborDist) {
                            gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].forceJumpTo = 999 //forceJumpable; //FJSR
                        } else {
                            gWPArray[i]!.neighbors[gWPArray[i]!.neighbornum].forceJumpTo = 0
                        }
                        gWPArray[i]!.neighbornum += 1
                    }

                    if gWPArray[i]!.neighbornum >= MAX_NEIGHBOR_SIZE {
                        break
                    }
                }
                c += 1
            }
        }
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
    // CM_DrawDebugSurface is the one caller, and the dedicated build never draws, so it is dead.
    // TODO: Port BotDrawDebugPolygons
    portMissing("BotDrawDebugPolygons", source: "oracle/codemp/server/sv_bot.cpp:227")
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

    switch type {
    case PRT_MESSAGE:
        Com_Printf("%s", str)

    case PRT_WARNING:
        Com_Printf(S_COLOR_YELLOW + "Warning: %s", str)

    case PRT_ERROR:
        Com_Printf(S_COLOR_RED + "Error: %s", str)

    case PRT_FATAL:
        Com_Printf(S_COLOR_RED + "Fatal: %s", str)

    case PRT_EXIT:
        Com_Error(ERR_DROP, S_COLOR_RED + "Exit: %s", str)

    default:
        Com_Printf("unknown print type\n")
    }
}

/**
```
==================
BotImport_Trace
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:309
func BotImport_Trace(_ bsptrace: BspTrace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ passent: Int32, _ contentmask: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in

        SV_Trace(trace, start, mins, maxs, end, passent, contentmask, 0, 0, 10)
        //copy the trace information
        bsptrace.allsolid = trace.allsolid != 0
        bsptrace.startsolid = trace.startsolid != 0
        bsptrace.fraction = trace.fraction
        bsptrace.endpos = trace.endpos
        bsptrace.plane.dist = trace.plane.dist
        bsptrace.plane.normal = trace.plane.normal
        bsptrace.plane.signbits = trace.plane.signbits
        bsptrace.plane.type = trace.plane.type
        bsptrace.surface.value = trace.surfaceFlags
        bsptrace.ent = trace.entityNum
        bsptrace.exp_dist = 0
        bsptrace.sidenum = 0
        bsptrace.contents = 0
    }
}

/**
```
==================
BotImport_EntityTrace
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:334
func BotImport_EntityTrace(_ bsptrace: BspTrace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ entnum: Int32, _ contentmask: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in

        SV_ClipToEntity(trace, start, mins, maxs, end, entnum, contentmask, 0)
        //copy the trace information
        bsptrace.allsolid = trace.allsolid != 0
        bsptrace.startsolid = trace.startsolid != 0
        bsptrace.fraction = trace.fraction
        bsptrace.endpos = trace.endpos
        bsptrace.plane.dist = trace.plane.dist
        bsptrace.plane.normal = trace.plane.normal
        bsptrace.plane.signbits = trace.plane.signbits
        bsptrace.plane.type = trace.plane.type
        bsptrace.surface.value = trace.surfaceFlags
        bsptrace.ent = trace.entityNum
        bsptrace.exp_dist = 0
        bsptrace.sidenum = 0
        bsptrace.contents = 0
    }
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
    let ptr = Z_Malloc(size, TAG_BOTGAME, true)

    return ptr
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
    let ptr = Z_Malloc(size, TAG_BOTLIB, true)
    return ptr
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
    if Hunk_CheckMark() {
        Com_Error(ERR_DROP, "SV_Bot_HunkAlloc: Alloc with marks already set\n")
    }
    return Hunk_Alloc(size, h_high)
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
    let poly: BotDebugpoly
    var i: Int32

    if debugpolygons == nil {
        return 0
    }

    i = 1
    while i < bot_maxdebugpolys {
        if debugpolygons![i].inuse == 0 {
            break
        }
        i += 1
    }
    if i >= bot_maxdebugpolys {
        return 0
    }
    poly = debugpolygons![i]
    poly.inuse = 1
    poly.color = color
    poly.numPoints = numPoints
    Com_Memcpy(poly.points, points, numPoints * Int32(vec3_t.byteCount))
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
    let poly: BotDebugpoly

    if debugpolygons == nil {
        return
    }
    poly = debugpolygons![id]
    poly.inuse = 1
    poly.color = color
    poly.numPoints = numPoints
    Com_Memcpy(poly.points, points, numPoints * Int32(vec3_t.byteCount))
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
    if debugpolygons == nil {
        return
    }
    debugpolygons![id].inuse = 0
}

/// Source: oracle/codemp/server/sv_bot.cpp:526
// AI: Raven declares `points` on the stack of BotImport_DebugLineCreate. The function uses one zeroed allocation on the storage class.
var points_BotImport_DebugLineCreate: Slots<JKAShared.vec3_t> { world.storage.sv_bot_points_BotImport_DebugLineCreate }

/**
```
==================
BotImport_DebugLineCreate
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:525
func BotImport_DebugLineCreate() -> Int32 {
    // AI: Raven declares `vec3_t points[1]` on his stack. The body uses the zeroed allocation of the storage class through the `points_BotImport_DebugLineCreate` forward.
    return BotImport_DebugPolygonCreate(0, 0, points_BotImport_DebugLineCreate)
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

/// Source: oracle/codemp/server/sv_bot.cpp:545
// AI: Raven declares `points` on the stack of BotImport_DebugLineShow. The function uses one zeroed allocation on the storage class.
var points_BotImport_DebugLineShow: Slots<JKAShared.vec3_t> { world.storage.sv_bot_points_BotImport_DebugLineShow }

/**
```
==================
BotImport_DebugLineShow
==================
```
*/
/// Source: oracle/codemp/server/sv_bot.cpp:544
func BotImport_DebugLineShow(_ line: Int32, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ color: Int32) {
    // AI: Raven declares `vec3_t points[4]` on his stack. The body uses the zeroed allocation of the storage class through the `points_BotImport_DebugLineShow` forward.
    var dir = vec3_t()
    var cross = vec3_t()
    var up = vec3_t(0, 0, 1)
    let dot: Float

    points_BotImport_DebugLineShow[0] = start
    points_BotImport_DebugLineShow[1] = start
    //points[1][2] -= 2;
    points_BotImport_DebugLineShow[2] = end
    //points[2][2] -= 2;
    points_BotImport_DebugLineShow[3] = end


    dir = end - start
    VectorNormalize(&dir)
    dot = _DotProduct(dir, up)
    if Double(dot) > 0.99 || Double(dot) < -0.99 {
        cross = vec3_t(1, 0, 0)
    } else {
        CrossProduct(dir, up, &cross)
    }

    VectorNormalize(&cross)

    _VectorMA(points_BotImport_DebugLineShow[0], 2, cross, &points_BotImport_DebugLineShow[0])
    _VectorMA(points_BotImport_DebugLineShow[1], -2, cross, &points_BotImport_DebugLineShow[1])
    _VectorMA(points_BotImport_DebugLineShow[2], -2, cross, &points_BotImport_DebugLineShow[2])
    _VectorMA(points_BotImport_DebugLineShow[3], 2, cross, &points_BotImport_DebugLineShow[3])

    BotImport_DebugPolygonShow(line, color, 4, points_BotImport_DebugLineShow)
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

    if botlib_export == nil {
        Com_Printf(S_COLOR_RED + "Error: SV_BotLibSetup without SV_BotInitBotLib\n")
        return -1
    }

    return botlib_export!.runBotLibSetup()
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
    if botlib_export == nil {
        return -1
    }

    return botlib_export!.runBotLibShutdown()
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
    BotlibImport.scratch { botlib_import in
        if debugpolygons != nil {
            Z_Free(debugpolygons![0].handle)
        }
        bot_maxdebugpolys = Cvar_VariableIntegerValue("bot_maxdebugpolys")
        debugpolygons = Slots<BotDebugpoly>(Z_Malloc(Int32(BotDebugpoly.byteCount) * bot_maxdebugpolys, TAG_BOTLIB, true), count: bot_maxdebugpolys)

        botlib_import.Print = BotlibImportThunks.BotImport_Print
        botlib_import.Trace = BotlibImportThunks.BotImport_Trace
        botlib_import.EntityTrace = BotlibImportThunks.BotImport_EntityTrace
        botlib_import.PointContents = BotlibImportThunks.BotImport_PointContents
        botlib_import.inPVS = BotlibImportThunks.BotImport_inPVS
        botlib_import.BSPEntityData = BotlibImportThunks.BotImport_BSPEntityData
        botlib_import.BSPModelMinsMaxsOrigin = BotlibImportThunks.BotImport_BSPModelMinsMaxsOrigin
        botlib_import.BotClientCommand = BotlibImportThunks.BotClientCommand

        //memory management
        botlib_import.GetMemory = BotlibImportThunks.BotImport_GetMemory
        botlib_import.FreeMemory = BotlibImportThunks.BotImport_FreeMemory
        botlib_import.AvailableMemory = BotlibImportThunks.bot_Z_AvailableMemory	//Z_AvailableMemory;
        botlib_import.HunkAlloc = BotlibImportThunks.BotImport_HunkAlloc

        // file system access
        botlib_import.FS_FOpenFile = BotlibImportThunks.FS_FOpenFileByMode
        botlib_import.FS_Read = BotlibImportThunks.FS_Read2
        botlib_import.FS_Write = BotlibImportThunks.FS_Write
        botlib_import.FS_FCloseFile = BotlibImportThunks.FS_FCloseFile
        botlib_import.FS_Seek = BotlibImportThunks.FS_Seek

        //debug lines
        botlib_import.DebugLineCreate = BotlibImportThunks.BotImport_DebugLineCreate
        botlib_import.DebugLineDelete = BotlibImportThunks.BotImport_DebugLineDelete
        botlib_import.DebugLineShow = BotlibImportThunks.BotImport_DebugLineShow

        //debug polygons
        botlib_import.DebugPolygonCreate = BotlibImportThunks.BotImport_DebugPolygonCreate
        botlib_import.DebugPolygonDelete = BotlibImportThunks.BotImport_DebugPolygonDelete

        botlib_export = GetBotLibAPI(BOTLIB_API_VERSION, botlib_import)
        assert(botlib_export != nil) 	// bk001129 - somehow we end up with a zero import.
    }
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

/// One static per function this file stores in a `BotlibImport` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum BotlibImportThunks {
    /// Source: oracle/codemp/server/sv_bot.cpp:577
    static let BotClientCommand: BotlibImportBotClientCommand = { JKAMP_DedLogic.BotClientCommand($0, text(at: $1!)) }

    /// Source: oracle/codemp/server/sv_bot.cpp:378
    // The botlib reads the entity text through the pointer, so the thunk returns the pool's pointer, the one the clip map's field holds.
    static let BotImport_BSPEntityData: BotlibImportBSPEntityData = { OpaquePointer(StringPool.shared.pointer(for: JKAMP_DedLogic.BotImport_BSPEntityData())) }

    /// Source: oracle/codemp/server/sv_bot.cpp:387
    static let BotImport_BSPModelMinsMaxsOrigin: BotlibImportBSPModelMinsMaxsOrigin = { modelnum, angles, outmins, outmaxs, origin in
        var mins = vec3_t()
        var maxs = vec3_t()
        var org = vec3_t()
        JKAMP_DedLogic.BotImport_BSPModelMinsMaxsOrigin(modelnum, vector(at: angles!), &mins, &maxs, &org)
        // Raven tests each output for NULL, so the thunk writes back only to a word that is not nil.
        if outmins != nil {
            let slots = Slots<Float>(scalars: outmins!, count: 3)
            slots[0] = mins[0]
            slots[1] = mins[1]
            slots[2] = mins[2]
        }
        if outmaxs != nil {
            let slots = Slots<Float>(scalars: outmaxs!, count: 3)
            slots[0] = maxs[0]
            slots[1] = maxs[1]
            slots[2] = maxs[2]
        }
        if origin != nil {
            let slots = Slots<Float>(scalars: origin!, count: 3)
            slots[0] = org[0]
            slots[1] = org[1]
            slots[2] = org[2]
        }
    }

    /// Source: oracle/codemp/server/sv_bot.cpp:525
    static let BotImport_DebugLineCreate: BotlibImportDebugLineCreate = { JKAMP_DedLogic.BotImport_DebugLineCreate() }

    /// Source: oracle/codemp/server/sv_bot.cpp:535
    static let BotImport_DebugLineDelete: BotlibImportDebugLineDelete = { JKAMP_DedLogic.BotImport_DebugLineDelete($0) }

    /// Source: oracle/codemp/server/sv_bot.cpp:544
    static let BotImport_DebugLineShow: BotlibImportDebugLineShow = { JKAMP_DedLogic.BotImport_DebugLineShow($0, vector(at: $1!), vector(at: $2!), $3) }

    /// Source: oracle/codemp/server/sv_bot.cpp:471
    static let BotImport_DebugPolygonCreate: BotlibImportDebugPolygonCreate = { color, numPoints, points in
        JKAMP_DedLogic.BotImport_DebugPolygonCreate(color, numPoints, Slots<vec3_t>(vectors: points!, count: Int(numPoints)))
    }

    /// Source: oracle/codemp/server/sv_bot.cpp:514
    static let BotImport_DebugPolygonDelete: BotlibImportDebugPolygonDelete = { JKAMP_DedLogic.BotImport_DebugPolygonDelete($0) }

    /// Source: oracle/codemp/server/sv_bot.cpp:334
    static let BotImport_EntityTrace: BotlibImportEntityTrace = { JKAMP_DedLogic.BotImport_EntityTrace(BspTrace(handle: $0!), vector(at: $1!), vector(at: $2!), vector(at: $3!), vector(at: $4!), $5, $6) }

    /// Source: oracle/codemp/server/sv_bot.cpp:450
    static let BotImport_FreeMemory: BotlibImportFreeMemory = { JKAMP_DedLogic.BotImport_FreeMemory($0) }

    /// Source: oracle/codemp/server/sv_bot.cpp:438
    static let BotImport_GetMemory: BotlibImportGetMemory = { OpaquePointer(JKAMP_DedLogic.BotImport_GetMemory($0)) }

    /// Source: oracle/codemp/server/sv_bot.cpp:459
    static let BotImport_HunkAlloc: BotlibImportHunkAlloc = { OpaquePointer(JKAMP_DedLogic.BotImport_HunkAlloc($0)) }

    /// Source: oracle/codemp/server/sv_bot.cpp:360
    static let BotImport_PointContents: BotlibImportPointContents = { JKAMP_DedLogic.BotImport_PointContents(vector(at: $0!)) }

    /// Source: oracle/codemp/server/sv_bot.cpp:267
    // AI: Raven's botlib passes the format and its arguments. The run method formats them, so the word holds the text, and the thunk passes it as the argument of "%s".
    static let BotImport_Print: BotlibImportPrint = { JKAMP_DedLogic.BotImport_Print($0, "%s", text(at: $1!)) }

    /// Source: oracle/codemp/server/sv_bot.cpp:309
    static let BotImport_Trace: BotlibImportTrace = { JKAMP_DedLogic.BotImport_Trace(BspTrace(handle: $0!), vector(at: $1!), vector(at: $2!), vector(at: $3!), vector(at: $4!), $5, $6) }

    /// Source: oracle/codemp/server/sv_bot.cpp:369
    static let BotImport_inPVS: BotlibImportInPVS = { JKAMP_DedLogic.BotImport_inPVS(vector(at: $0!), vector(at: $1!)) }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:461
    static let FS_FCloseFile: BotlibImportFS_FCloseFile = { JKAMP_DedLogic.FS_FCloseFile($0) }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:3064
    static let FS_FOpenFileByMode: BotlibImportFS_FOpenFile = { qpath, f, mode in
        let slots = Slots<Int32>(scalars: f!, count: 1)
        var value = slots[0]
        let length = JKAMP_DedLogic.FS_FOpenFileByMode(text(at: qpath!), &value, mode)
        slots[0] = value
        return length
    }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:1007
    static let FS_Read2: BotlibImportFS_Read = { JKAMP_DedLogic.FS_Read2(Slots<JKAShared.byte>(scalars: $0!, count: Int($1)), $1, $2) }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:1131
    static let FS_Seek: BotlibImportFS_Seek = { JKAMP_DedLogic.FS_Seek($0, $1, $2) }

    /// Source: oracle/codemp/qcommon/files_pc.cpp:1079
    static let FS_Write: BotlibImportFS_Write = { JKAMP_DedLogic.FS_Write(Slots<JKAShared.byte>(scalars: $0!, count: Int($1)), $1, $2) }

    /// Source: oracle/codemp/server/sv_bot.cpp:673
    static let bot_Z_AvailableMemory: BotlibImportAvailableMemory = { JKAMP_DedLogic.bot_Z_AvailableMemory() }
}
