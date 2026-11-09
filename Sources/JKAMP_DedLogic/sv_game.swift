import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_game.cpp:32
// TODO: Port global botlib_export
// Raven wrote: botlib_export_t *botlib_export
// No table row for `botlib_export_t *`.

/// Source: oracle/codemp/server/sv_game.cpp:420
var gLocalModifier: JKAMP.SharedEntity { world.storage.gLocalModifier }

/// Source: oracle/codemp/server/sv_game.cpp:454
var sv_siegePersData: JKAMP.SiegePers { world.storage.sv_siegePersData }

/// Source: oracle/codemp/server/sv_game.cpp:36
func SV_GameError(_ string: String) -> Never {
    Com_Error(ERR_DROP, "%s", string)
}

/// Source: oracle/codemp/server/sv_game.cpp:40
func SV_GamePrint(_ string: String) {
    Com_Printf("%s", string)
}

// these functions must be used instead of pointer arithmetic, because
// the game allocates gentities with private information after the server shared part
/// Source: oracle/codemp/server/sv_game.cpp:46
func SV_NumForGentity(_ ent: JKAMP.SharedEntity) -> Int32 {
    let num: Int32

    // AI: Raven divides the byte distance from sv.gentities by sv.gentitySize. The body takes the index in the Slots of that stride.
    num = sv.gentitiesSlots.index(of: ent)

    return num
}

/// Source: oracle/codemp/server/sv_game.cpp:54
func SV_GentityNum(_ num: Int32) -> JKAMP.SharedEntity? {
    var ent: SharedEntity?

    // AI: Raven steps a byte pointer from sv.gentities by sv.gentitySize. The body indexes the Slots of that stride.
    ent = sv.gentitiesSlots[num]

    return ent
}

/// Source: oracle/codemp/server/sv_game.cpp:62
func SV_GameClientNum(_ num: Int32) -> JKAMP.PlayerState? {
    var ps: PlayerState?

    // AI: Raven steps a byte pointer from sv.gameClients by sv.gameClientSize. The body indexes the Slots of that stride.
    ps = sv.gameClientsSlots[num]

    return ps
}

/// Source: oracle/codemp/server/sv_game.cpp:70
func SV_SvEntityForGentity(_ gEnt: JKAMP.SharedEntity) -> SvEntity? {
    if gEnt.s.number < 0 || gEnt.s.number >= MAX_GENTITIES {
        Com_Error(ERR_DROP, "SV_SvEntityForGentity: bad gEnt")
    }
    return sv.svEntities[gEnt.s.number]
}

/// Source: oracle/codemp/server/sv_game.cpp:77
func SV_GEntityForSvEntity(_ svEnt: SvEntity) -> JKAMP.SharedEntity? {
    let num: Int32

    num = sv.svEntities.index(of: svEnt)
    return SV_GentityNum(num)
}

/**
```
===============
SV_GameSendServerCommand

Sends a command string to a client
===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:91
func SV_GameSendServerCommand(_ clientNum: Int32, _ text: String) {
    if clientNum == -1 {
        SV_SendServerCommand(nil, "%s", text)
    } else {
        if clientNum < 0 || clientNum >= sv_maxclients!.integer {
            return
        }
        SV_SendServerCommand(svs.clientsSlots[clientNum], "%s", text)
    }
}

/**
```
===============
SV_GameDropClient

Disconnects the client with a message
===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:110
func SV_GameDropClient(_ clientNum: Int32, _ reason: String) {
    if clientNum < 0 || clientNum >= sv_maxclients!.integer {
        return
    }
    SV_DropClient(svs.clientsSlots[clientNum], reason)
}

/**
```
=================
SV_SetBrushModel

sets mins and maxs for inline bmodels
=================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:128
func SV_SetBrushModel(_ ent: JKAMP.SharedEntity, _ name: String) {
    let name = CharBuf(name)
    var h: clipHandle_t
    var mins = vec3_t()
    var maxs = vec3_t()


    if name[0] == Int32(ascii: "*") {
        ent.s.modelindex = atoi(name[1...])

        if sv.mLocalSubBSPIndex != -1 {
            ent.s.modelindex += sv.mLocalSubBSPModelOffset
        }

        h = CM_InlineModel(ent.s.modelindex)

        CM_ModelBounds(h, &mins, &maxs)

        ent.r.mins = mins
        ent.r.maxs = maxs
        ent.r.bmodel = true

        if com_RMG != nil && com_RMG!.integer != 0 {
            ent.r.contents = CM_ModelContents(h, sv.mLocalSubBSPIndex)
        } else {
            ent.r.contents = CM_ModelContents(h, -1)
        }
    } else if name[0] == Int32(ascii: "#") {
        ent.s.modelindex = CM_LoadSubBSP(va("maps/%s.bsp", String(name[1...])), false)
        CM_ModelBounds(ent.s.modelindex, &mins, &maxs)

        ent.r.mins = mins
        ent.r.maxs = maxs
        ent.r.bmodel = true

        //rwwNOTE: We don't ever want to set contents -1, it includes CONTENTS_LIGHTSABER.
        //Lots of stuff will explode if there's a brush with CONTENTS_LIGHTSABER that isn't attached to a client owner.
        //ent->contents = -1;		// we don't know exactly what is in the brushes
        h = CM_InlineModel(ent.s.modelindex)
        ent.r.contents = CM_ModelContents(h, CM_FindSubBSP(ent.s.modelindex))
    } else {
        Com_Error(ERR_DROP, "SV_SetBrushModel: %s isn't a brush model", String(name))
    }
}

/// Source: oracle/codemp/server/sv_game.cpp:185
func SV_SetActiveSubBSP(_ index: Int32) -> String? {
    if index >= 0 {
        sv.mLocalSubBSPIndex = CM_FindSubBSP(index)
        sv.mLocalSubBSPModelOffset = index
        sv.mLocalSubBSPEntityParsePoint = CM_SubBSPEntityString(sv.mLocalSubBSPIndex)
        return sv.mLocalSubBSPEntityParsePoint
    } else {
        sv.mLocalSubBSPIndex = -1
    }

    return nil
}

/**
```
=================
SV_inPVS

Also checks portalareas so that doors block sight
=================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:209
func SV_inPVS(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Bool {
    var leafnum: Int32
    var cluster: Int32
    let area1: Int32
    let area2: Int32
    let mask: Slots<byte>

    leafnum = CM_PointLeafnum(p1)
    cluster = CM_LeafCluster(leafnum)
    area1 = CM_LeafArea(leafnum)
    mask = CM_ClusterPVS(cluster)

    leafnum = CM_PointLeafnum(p2)
    cluster = CM_LeafCluster(leafnum)
    area2 = CM_LeafArea(leafnum)
    if (Int32(mask[cluster >> 3]) & (1 << (cluster & 7))) == 0 {
        return false
    }
    if !CM_AreasConnected(area1, area2) {
        return false // a door blocks sight
    }
    return true
}

/**
```
=================
SV_inPVSIgnorePortals

Does NOT check portalareas
=================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:243
func SV_inPVSIgnorePortals(_ p1: JKAShared.vec3_t, _ p2: JKAShared.vec3_t) -> Bool {
    var leafnum: Int32
    var cluster: Int32
    let area1: Int32
    let area2: Int32
    let mask: Slots<byte>

    leafnum = CM_PointLeafnum(p1)
    cluster = CM_LeafCluster(leafnum)
    area1 = CM_LeafArea(leafnum)
    mask = CM_ClusterPVS(cluster)

    leafnum = CM_PointLeafnum(p2)
    cluster = CM_LeafCluster(leafnum)
    area2 = CM_LeafArea(leafnum)

    if (Int32(mask[cluster >> 3]) & (1 << (cluster & 7))) == 0 {
        return false
    }

    return true
}

/**
```
========================
SV_AdjustAreaPortalState
========================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:275
func SV_AdjustAreaPortalState(_ ent: JKAMP.SharedEntity, _ open: Bool) {
    var svEnt: SvEntity?

    svEnt = SV_SvEntityForGentity(ent)
    if svEnt!.areanum2 == -1 {
        return
    }
    CM_AdjustAreaPortalState(svEnt!.areanum, svEnt!.areanum2, open)
}

/**
```
==================
SV_GameAreaEntities
==================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:291
func SV_EntityContact(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ gEnt: JKAMP.SharedEntity, _ capsule: Int32) -> Bool {
    var ch: clipHandle_t = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in

        // check for exact collision

        ch = SV_ClipHandleForEntity(gEnt)
        CM_TransformedBoxTrace(trace, vec3_origin, vec3_origin, mins, maxs, ch, -1, gEnt.r.currentOrigin, gEnt.r.currentAngles, capsule)

        return trace.startsolid != 0
    }
}

/**
```
===============
SV_GetServerinfo

===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:314
func SV_GetServerinfo(_ buffer: inout JKAShared.CharBuf, _ bufferSize: Int32) {
    if bufferSize < 1 {
        Com_Error(ERR_DROP, "SV_GetServerinfo: bufferSize == %i", bufferSize)
    }
    Q_strncpyz(&buffer, Cvar_InfoString(CVAR_SERVERINFO), bufferSize)
}

/**
```
===============
SV_LocateGameData

===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:327
func SV_LocateGameData(_ gEnts: JKAMP.SharedEntity, _ numGEntities: Int32, _ sizeofGEntity_t: Int32, _ clients: JKAMP.PlayerState, _ sizeofGameClient: Int32) {
    sv.gentities = gEnts
    sv.gentitySize = sizeofGEntity_t
    sv.num_entities = numGEntities

    sv.gameClients = clients
    sv.gameClientSize = sizeofGameClient
}

/// Source: oracle/codemp/server/sv_game.cpp:337
func SV_GetEntityToken(_ buffer: inout JKAShared.CharBuf, _ bufferSize: Int32) -> Bool {
    let s: String

    if sv.mLocalSubBSPIndex == -1 {
        // AI: Raven hands COM_Parse the address of the `char *` field. The body hands the cursor accessor of the field, which moves the pointer.
        s = COM_Parse(&sv.entityParsePointCursor)
        Q_strncpyz(&buffer, s, bufferSize)
        if sv.entityParsePoint == nil && s.isEmpty {
            return false
        } else {
            return true
        }
    } else {
        // AI: Raven hands COM_Parse the address of the `char *` field. The body hands the cursor accessor of the field, which moves the pointer.
        s = COM_Parse(&sv.mLocalSubBSPEntityParsePointCursor)
        Q_strncpyz(&buffer, s, bufferSize)
        if sv.mLocalSubBSPEntityParsePoint == nil && s.isEmpty {
            return false
        } else {
            return true
        }
    }
}

/**
```
===============
SV_GetUsercmd

===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:375
func SV_GetUsercmd(_ clientNum: Int32, _ cmd: JKAMP.Usercmd) {
    if clientNum < 0 || clientNum >= sv_maxclients!.integer {
        Com_Error(ERR_DROP, "SV_GetUsercmd: bad clientNum:%i", clientNum)
    }
    cmd.copy(from: svs.clientsSlots[clientNum].lastUsercmd)
}

/// Source: oracle/codemp/server/sv_game.cpp:384
private func FloatAsInt(_ f: Float) -> Int32 {
    var temp: Int32 = 0

    temp = Int32(bitPattern: f.bitPattern)

    return temp
}

/// Source: oracle/codemp/server/sv_game.cpp:422
func ConvertedEntity(_ ent: JKAMP.SharedEntity) -> JKAMP.SharedEntity? {
    //Return an entity with the memory shifted around to allow reading/modifying VM memory
    var i: Int32 = 0


    gLocalModifier.s = ent.s
    gLocalModifier.r = ent.r
    while i < NUM_TIDS {
        gLocalModifier.taskID[i] = ent.taskID[i]
        i += 1
    }
    i = 0
    // AI: Raven maps each pointer field through VM_ArgPtr, which gives the same address for a module library. The body copies the fields.
    gLocalModifier.parms = ent.parms
    while i < NUM_BSETS {
        gLocalModifier.behaviorSet[i] = ent.behaviorSet[i]
        i += 1
    }
    i = 0
    gLocalModifier.script_targetname = ent.script_targetname
    gLocalModifier.delayScriptTime = ent.delayScriptTime
    gLocalModifier.fullName = ent.fullName
    gLocalModifier.targetname = ent.targetname
    gLocalModifier.classname = ent.classname

    gLocalModifier.ghoul2 = ent.ghoul2

    return gLocalModifier
}

/// Source: oracle/codemp/server/sv_game.cpp:458
func SV_GameSystemCalls(_ args: Slots<Int32>) -> Int32 {
    // AI: Raven's VMA and VMF macros read the local `args`. Each macro is a method of `args` in the view target, `args.VMA(1)` and `args.VMF(1)`.
    switch args[0] {
    //rww - alright, DO NOT EVER add a GAME/CGAME/UI generic call without adding a trap to match, and
    //all of these traps must be shared and have cases in sv_game, cl_cgame, and cl_ui. They must also
    //all be in the same order, and start at 100.
    case TRAP_MEMSET:
        // AI: Raven passes the int count to the unsigned long parameter, and C converts it. The arm writes the conversion.
        Com_Memset(args.VMA(1), args[2], CUnsignedLong(args[3]))
        return 0

    case TRAP_MEMCPY:
        // AI: Raven passes the int count to the unsigned long parameter, and C converts it. The arm writes the conversion.
        Com_Memcpy(args.VMA(1), args.VMA(2), CUnsignedLong(args[3]))
        return 0

    case TRAP_STRNCPY:
        // Port-note: Raven returns the destination pointer as an int, which drops the high half of an address on a 64-bit host.
        // Port-note: No module reads the value, so the arm returns 0.
        // AI: Raven's strncpy writes into the module's buffer. The arm fills a CharBuf of that size and copies all of its bytes into the module's bytes.
        var buffer = CharBuf(args[3])
        strncpy(&buffer, args.VMA(2) as String, args[3])
        Com_Memcpy(args.VMA(1), buffer, args[3])
        return 0

    case TRAP_SIN:
        return FloatAsInt(Float(sin(Double(args.VMF(1)))))

    case TRAP_COS:
        return FloatAsInt(Float(cos(Double(args.VMF(1)))))

    case TRAP_ATAN2:
        return FloatAsInt(Float(atan2(Double(args.VMF(1)), Double(args.VMF(2)))))

    case TRAP_SQRT:
        return FloatAsInt(Float(sqrt(Double(args.VMF(1)))))

    case TRAP_MATRIXMULTIPLY:
        let in1: Slots<vec3_t> = args.VMA(1)
        let in2: Slots<vec3_t> = args.VMA(2)
        MatrixMultiply([in1[0], in1[1], in1[2]], [in2[0], in2[1], in2[2]], args.VMA(3))
        return 0

    case TRAP_ANGLEVECTORS:
        // AI: Raven hands the three module vectors to AngleVectors, which writes them. The arm writes each vector back to the module after the call.
        let forward: Slots<vec3_t> = args.VMA(2)
        let right: Slots<vec3_t> = args.VMA(3)
        let up: Slots<vec3_t> = args.VMA(4)
        AngleVectors(args.VMA(1), &forward[0], &right[0], &up[0])
        return 0

    case TRAP_PERPENDICULARVECTOR:
        let dst: Slots<vec3_t> = args.VMA(1)
        PerpendicularVector(&dst[0], args.VMA(2))
        return 0

    case TRAP_FLOOR:
        return FloatAsInt(Float(floor(Double(args.VMF(1)))))

    case TRAP_CEIL:
        return FloatAsInt(Float(ceil(Double(args.VMF(1)))))

    case TRAP_TESTPRINTINT:
        return 0

    case TRAP_TESTPRINTFLOAT:
        return 0

    case TRAP_ACOS:
        return FloatAsInt(Q_acos(args.VMF(1)))

    case TRAP_ASIN:
        return FloatAsInt(Q_asin(args.VMF(1)))


    case G_PRINT:
        Com_Printf("%s", args.VMA(1) as String)
        return 0

    case G_ERROR:
        Com_Error(ERR_DROP, "%s", args.VMA(1) as String)

    case G_MILLISECONDS:
        return Sys_Milliseconds()

    //rww - precision timer funcs... -ALWAYS- call end after start with supplied ptr, or you'll get a nasty memory leak.
    //not that you should be using these outside of debug anyway.. because you shouldn't be. So don't.
    // Port-note: Row G4. Raven's labels are CG_PRECISIONTIMER_START and CG_PRECISIONTIMER_END of cg_public.h, which the host does not import.
    // Port-note: Row G4. The C++ class timing_c of timing.h has no port.
    // Raven wrote: case CG_PRECISIONTIMER_START: ... newTimer->Start(); ... case CG_PRECISIONTIMER_END: ... r = timer->End(); delete timer; return r;
    // A game number that matches no label reaches the default arm, as in Raven's switch.

    case G_CVAR_REGISTER:
        Cvar_Register(args.VMA(1), args.VMA(2), args.VMA(3), args[4])
        return 0

    case G_CVAR_UPDATE:
        Cvar_Update(args.VMA(1)!)
        return 0

    case G_CVAR_SET:
        Cvar_Set(args.VMA(1), args.VMA(2))
        return 0

    case G_CVAR_VARIABLE_INTEGER_VALUE:
        return Cvar_VariableIntegerValue(args.VMA(1))

    case G_CVAR_VARIABLE_STRING_BUFFER:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[3])
        Cvar_VariableStringBuffer(args.VMA(1), &buffer, args[3])
        Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
        return 0

    case G_ARGC:
        return Cmd_Argc()

    case G_ARGV:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[3])
        Cmd_ArgvBuffer(args[1], &buffer, args[3])
        Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
        return 0

    case G_SEND_CONSOLE_COMMAND:
        Cbuf_ExecuteText(args[1], args.VMA(2))
        return 0


    case G_FS_FOPEN_FILE:
        // AI: Raven hands the module's int to the callee by address. The arm hands the slot of the Slots at the word.
        let f: Slots<Int32> = args.VMA(2)
        return FS_FOpenFileByMode(args.VMA(1), &f[0], args[3])

    case G_FS_READ:
        FS_Read2(args.VMA(1), args[2], args[3])
        return 0

    case G_FS_WRITE:
        FS_Write(args.VMA(1), args[2], args[3])
        return 0

    case G_FS_FCLOSE_FILE:
        FS_FCloseFile(args[1])
        return 0

    case G_FS_GETFILELIST:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the whole list into the module's bytes.
        var listbuf = CharBuf(args[4])
        let count = FS_GetFileList(args.VMA(1), args.VMA(2), &listbuf, args[4])
        Com_Memcpy(args.VMA(3), listbuf, args[4])
        return count


    case G_LOCATE_GAME_DATA:
        SV_LocateGameData(args.VMA(1)!, args[2], args[3], args.VMA(4)!, args[5])
        return 0

    case G_DROP_CLIENT:
        SV_GameDropClient(args[1], args.VMA(2))
        return 0

    case G_SEND_SERVER_COMMAND:
        SV_GameSendServerCommand(args[1], args.VMA(2))
        return 0

    case G_LINKENTITY:
        SV_LinkEntity(args.VMA(1)!)
        return 0

    case G_UNLINKENTITY:
        SV_UnlinkEntity(args.VMA(1)!)
        return 0

    case G_ENTITIES_IN_BOX:
        return SV_AreaEntities(args.VMA(1), args.VMA(2), args.VMA(3), args[4])

    case G_ENTITY_CONTACT:
        return (SV_EntityContact(args.VMA(1), args.VMA(2), args.VMA(3)!, /*int capsule*/ 0) ? 1 : 0)

    case G_ENTITY_CONTACTCAPSULE:
        return (SV_EntityContact(args.VMA(1), args.VMA(2), args.VMA(3)!, /*int capsule*/ 1) ? 1 : 0)

    case G_TRACE:
        SV_Trace(args.VMA(1)!, args.VMA(2), args.VMA(3), args.VMA(4), args.VMA(5), args[6], args[7], /*int capsule*/ 0, /*args[8]*/0, args[9])
        return 0

    case G_G2TRACE:
        SV_Trace(args.VMA(1)!, args.VMA(2), args.VMA(3), args.VMA(4), args.VMA(5), args[6], args[7], /*int capsule*/ 0, args[8], args[9])
        return 0

    case G_TRACECAPSULE:
        SV_Trace(args.VMA(1)!, args.VMA(2), args.VMA(3), args.VMA(4), args.VMA(5), args[6], args[7], /*int capsule*/ 1, args[8], args[9])
        return 0

    case G_POINT_CONTENTS:
        return SV_PointContents(args.VMA(1), args[2])

    case G_SET_SERVER_CULL:
        g_svCullDist = args.VMF(1)
        return 0

    case G_SET_BRUSH_MODEL:
        SV_SetBrushModel(args.VMA(1)!, args.VMA(2))
        return 0

    case G_IN_PVS:
        return (SV_inPVS(args.VMA(1), args.VMA(2)) ? 1 : 0)

    case G_IN_PVS_IGNORE_PORTALS:
        return (SV_inPVSIgnorePortals(args.VMA(1), args.VMA(2)) ? 1 : 0)


    case G_SET_CONFIGSTRING:
        SV_SetConfigstring(args[1], args.VMA(2))
        return 0

    case G_GET_CONFIGSTRING:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[3])
        SV_GetConfigstring(args[1], &buffer, args[3])
        Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
        return 0

    case G_SET_USERINFO:
        SV_SetUserinfo(args[1], args.VMA(2))
        return 0

    case G_GET_USERINFO:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[3])
        SV_GetUserinfo(args[1], &buffer, args[3])
        Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
        return 0

    case G_GET_SERVERINFO:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[2])
        SV_GetServerinfo(&buffer, args[2])
        Com_Memcpy(args.VMA(1), buffer, strlen(buffer) + 1)
        return 0

    case G_ADJUST_AREA_PORTAL_STATE:
        SV_AdjustAreaPortalState(args.VMA(1)!, args[2] != 0)
        return 0

    case G_AREAS_CONNECTED:
        return (CM_AreasConnected(args[1], args[2]) ? 1 : 0)


    case G_BOT_ALLOCATE_CLIENT:
        return SV_BotAllocateClient()

    case G_BOT_FREE_CLIENT:
        SV_BotFreeClient(args[1])
        return 0


    case G_GET_USERCMD:
        SV_GetUsercmd(args[1], args.VMA(2)!)
        return 0


    case G_SIEGEPERSSET:
        sv_siegePersData.copy(from: args.VMA(1)!)
        return 0

    case G_SIEGEPERSGET:
        let siegePers: SiegePers? = args.VMA(1)
        siegePers!.copy(from: sv_siegePersData)
        return 0

        //rwwRMG - see below
        /*
    case G_GET_ENTITY_TOKEN:
        {
            const char	*s;

            s = COM_Parse( (const char **) &sv.entityParsePoint );
            Q_strncpyz( (char *)VMA(1), s, args[2] );
            if ( !sv.entityParsePoint && !s[0] ) {
                return qfalse;
            } else {
                return qtrue;
            }
        }
        */

        /*
    case G_BOT_GET_MEMORY:
        void *ptr;
        ptr = Bot_GetMemoryGame(args[1]);
        return (int)ptr;
    case G_BOT_FREE_MEMORY:
        Bot_FreeMemoryGame((void *)VMA(1));
        return 0;
        */
    case G_DEBUG_POLYGON_CREATE:
        return BotImport_DebugPolygonCreate(args[1], args[2], args.VMA(3))

    case G_DEBUG_POLYGON_DELETE:
        BotImport_DebugPolygonDelete(args[1])
        return 0

    case G_REAL_TIME:
        return Com_RealTime(args.VMA(1))

    case G_SNAPVECTOR:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let v: Slots<vec3_t> = args.VMA(1)
        Sys_SnapVector(&v[0])
        return 0

//	case SP_REGISTER_SERVER_CMD:
//		return SP_RegisterServer( (const char *)VMA(1) );
    case SP_GETSTRINGTEXTSTRING:
        //return (int)SP_GetStringTextString((char *)VMA(1));
        let text: String

//		if (args[0] == CG_SP_GETSTRINGTEXT)
//		{
//			text = SP_GetStringText( args[1] );
//		}
//		else
        do {
            text = SE_GetString(args.VMA(1) as String)
        }

        // AI: Raven's Q_strncpyz writes into the module's buffer. The arm fills a CharBuf of that size and copies the text into the module's bytes.
        var buffer = CharBuf(args[3])
        if !text.isEmpty {
            Q_strncpyz(&buffer, text, args[3])
            Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
            return 1
        } else {
            Q_strncpyz(&buffer, "??", args[3])
            Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
            return 0
        }

    case G_ROFF_CLEAN, G_ROFF_UPDATE_ENTITIES, G_ROFF_CACHE, G_ROFF_PLAY, G_ROFF_PURGE_ENT:
        // Port-note: Row C. `theROFFSystem` is an instance of the C++ class CROFFSystem, which has no port, so its 5 arms are one hole.
        // Raven wrote: the theROFFSystem calls of sv_game.cpp:714 to :728.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    //rww - dynamic vm memory allocation!
    case G_TRUEMALLOC:
        // AI: Raven hands the module's pointer slot to the callee by address. The arm hands the slot of the Slots at the word.
        let ptr: Slots<OpaquePointer?> = args.VMA(1)
        VM_Shifted_Alloc(&ptr[0], args[2])
        return 0

    case G_TRUEFREE:
        // AI: Raven hands the module's pointer slot to the callee by address. The arm hands the slot of the Slots at the word.
        let ptr: Slots<OpaquePointer?> = args.VMA(1)
        VM_Shifted_Free(&ptr[0])
        return 0

    //rww - icarus traps
    case G_ICARUS_RUNSCRIPT:
        return ICARUS_RunScript(ConvertedEntity(args.VMA(1)!)!, args.VMA(2))

    case G_ICARUS_REGISTERSCRIPT:
        return (ICARUS_RegisterScript(args.VMA(1), args[2] != 0) ? 1 : 0)

    case G_ICARUS_INIT:
        ICARUS_Init()
        return 0

    case G_ICARUS_VALIDENT:
        return (ICARUS_ValidEnt(ConvertedEntity(args.VMA(1)!)!) ? 1 : 0)

    case G_ICARUS_ISINITIALIZED, G_ICARUS_MAINTAINTASKMANAGER, G_ICARUS_ISRUNNING:
        // Port-note: Row C. `gSequencers` and `gTaskManagers` hold instances of the C++ classes CSequencer and CTaskManager, which have no port.
        // Raven wrote: the gSequencers and gTaskManagers tests of sv_game.cpp:752 to :782.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    case G_ICARUS_TASKIDPENDING:
        return (Q3_TaskIDPending(args.VMA(1)!, args[2]) ? 1 : 0)

    case G_ICARUS_INITENT:
        ICARUS_InitEnt(ConvertedEntity(args.VMA(1)!)!)
        return 0

    case G_ICARUS_FREEENT:
        ICARUS_FreeEnt(ConvertedEntity(args.VMA(1)!)!)
        return 0

    case G_ICARUS_ASSOCIATEENT:
        ICARUS_AssociateEnt(ConvertedEntity(args.VMA(1)!)!)
        return 0

    case G_ICARUS_SHUTDOWN:
        ICARUS_Shutdown()
        return 0

    case G_ICARUS_TASKIDSET:
        //rww - note that we are passing in the true entity here.
        //This is because we allow modification of certain non-pointer values,
        //which is valid.
        Q3_TaskIDSet(args.VMA(1)!, args[2], args[3])
        return 0

    case G_ICARUS_TASKIDCOMPLETE:
        //same as above.
        Q3_TaskIDComplete(args.VMA(1)!, args[2])
        return 0

    case G_ICARUS_SETVAR:
        Q3_SetVar(args[1], args[2], args.VMA(3), args.VMA(4))
        return 0

    case G_ICARUS_VARIABLEDECLARED:
        return Q3_VariableDeclared(args.VMA(1))

    case G_ICARUS_GETFLOATVARIABLE:
        // AI: Raven hands the module's float to the callee by address. The arm hands the slot of the Slots at the word.
        let value: Slots<Float> = args.VMA(2)
        return Q3_GetFloatVariable(args.VMA(1), &value[0])

    case G_ICARUS_GETSTRINGVARIABLE:
        var rec = TextCursor(CharBuf(args.VMA(2) as String))
        return Q3_GetStringVariable(args.VMA(1), &rec)

    case G_ICARUS_GETVECTORVARIABLE:
        // Port-note: Q3_GetVectorVariable takes `value` by value, and Raven's sscanf writes the three floats through it, so the module gets no vector.
        // Raven wrote: return Q3_GetVectorVariable((const char *)VMA(1), (float *)VMA(2));
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    //rww - BEGIN NPC NAV TRAPS
    case G_NAV_INIT, G_NAV_FREE, G_NAV_LOAD, G_NAV_SAVE, G_NAV_ADDRAWPOINT, G_NAV_CALCULATEPATHS, G_NAV_HARDCONNECT,
         G_NAV_SHOWNODES, G_NAV_SHOWEDGES, G_NAV_SHOWPATH, G_NAV_GETNEARESTNODE, G_NAV_GETBESTNODE, G_NAV_GETNODEPOSITION,
         G_NAV_GETNODENUMEDGES, G_NAV_GETNODEEDGE, G_NAV_GETNUMNODES, G_NAV_CONNECTED, G_NAV_GETPATHCOST, G_NAV_GETEDGECOST,
         G_NAV_GETPROJECTEDNODE, G_NAV_CHECKFAILEDNODES, G_NAV_ADDFAILEDNODE, G_NAV_NODEFAILED, G_NAV_NODESARENEIGHBORS,
         G_NAV_CLEARFAILEDEDGE, G_NAV_CLEARALLFAILEDEDGES, G_NAV_EDGEFAILED, G_NAV_ADDFAILEDEDGE, G_NAV_CHECKFAILEDEDGE,
         G_NAV_CHECKALLFAILEDEDGES, G_NAV_ROUTEBLOCKED, G_NAV_GETBESTNODEALTROUTE, G_NAV_GETBESTNODEALT2,
         G_NAV_GETBESTPATHBETWEENENTS, G_NAV_GETNODERADIUS, G_NAV_CHECKBLOCKEDEDGES, G_NAV_CLEARCHECKEDNODES,
         G_NAV_CHECKEDNODE, G_NAV_SETCHECKEDNODE, G_NAV_FLAGALLNODES, G_NAV_GETPATHSCALCULATED, G_NAV_SETPATHSCALCULATED:
        // Port-note: Row C. `navigator` is an instance of the C++ class CNavigator, which has no port, so its 42 arms are one hole.
        // Raven wrote: the navigator calls of sv_game.cpp:837 to :935.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")
    //rww - END NPC NAV TRAPS

    case G_SET_SHARED_BUFFER:
        // AI: Raven stores the module's buffer address in the `char *` field. The arm stores the bytes at the word in the bytes accessor.
        sv.mSharedMemoryBytes = args.VMA(1)
        return 0
        //====================================

    case BOTLIB_SETUP:
        return SV_BotLibSetup()

    case BOTLIB_SHUTDOWN:
        return SV_BotLibShutdown()

    case BOTLIB_LIBVAR_SET, BOTLIB_LIBVAR_GET, BOTLIB_PC_ADD_GLOBAL_DEFINE, BOTLIB_PC_LOAD_SOURCE, BOTLIB_PC_FREE_SOURCE,
         BOTLIB_PC_READ_TOKEN, BOTLIB_PC_SOURCE_FILE_AND_LINE, BOTLIB_START_FRAME, BOTLIB_LOAD_MAP, BOTLIB_UPDATENTITY,
         BOTLIB_TEST:
        // Port-note: Row B1. `botlib_export_t` has no host form, and `botlib_export` has no storage, so these 11 arms are one hole.
        // Raven wrote: the botlib_export calls of sv_game.cpp:948 to :971.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    case BOTLIB_GET_SNAPSHOT_ENTITY:
        return SV_BotGetSnapshotEntity(args[1], args[2])

    case BOTLIB_GET_CONSOLE_MESSAGE:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buf = CharBuf(args[3])
        let r = SV_BotGetConsoleMessage(args[1], &buf, args[3])
        Com_Memcpy(args.VMA(2), buf, strlen(buf) + 1)
        return r

    case BOTLIB_USER_COMMAND:
        SV_ClientThink(svs.clientsSlots[args[1]], args.VMA(2)!)
        return 0

    case BOTLIB_AAS_BBOX_AREAS, BOTLIB_AAS_AREA_INFO, BOTLIB_AAS_ALTERNATIVE_ROUTE_GOAL, BOTLIB_AAS_ENTITY_INFO,
         BOTLIB_AAS_INITIALIZED, BOTLIB_AAS_PRESENCE_TYPE_BOUNDING_BOX, BOTLIB_AAS_TIME, BOTLIB_AAS_POINT_AREA_NUM,
         BOTLIB_AAS_POINT_REACHABILITY_AREA_INDEX, BOTLIB_AAS_TRACE_AREAS, BOTLIB_AAS_POINT_CONTENTS,
         BOTLIB_AAS_NEXT_BSP_ENTITY, BOTLIB_AAS_VALUE_FOR_BSP_EPAIR_KEY, BOTLIB_AAS_VECTOR_FOR_BSP_EPAIR_KEY,
         BOTLIB_AAS_FLOAT_FOR_BSP_EPAIR_KEY, BOTLIB_AAS_INT_FOR_BSP_EPAIR_KEY, BOTLIB_AAS_AREA_REACHABILITY,
         BOTLIB_AAS_AREA_TRAVEL_TIME_TO_GOAL_AREA, BOTLIB_AAS_ENABLE_ROUTING_AREA, BOTLIB_AAS_PREDICT_ROUTE,
         BOTLIB_AAS_SWIMMING, BOTLIB_AAS_PREDICT_CLIENT_MOVEMENT,
         BOTLIB_EA_SAY, BOTLIB_EA_SAY_TEAM, BOTLIB_EA_COMMAND, BOTLIB_EA_ACTION, BOTLIB_EA_GESTURE, BOTLIB_EA_TALK,
         BOTLIB_EA_ATTACK, BOTLIB_EA_ALT_ATTACK, BOTLIB_EA_FORCEPOWER, BOTLIB_EA_USE, BOTLIB_EA_RESPAWN, BOTLIB_EA_CROUCH,
         BOTLIB_EA_MOVE_UP, BOTLIB_EA_MOVE_DOWN, BOTLIB_EA_MOVE_FORWARD, BOTLIB_EA_MOVE_BACK, BOTLIB_EA_MOVE_LEFT,
         BOTLIB_EA_MOVE_RIGHT, BOTLIB_EA_SELECT_WEAPON, BOTLIB_EA_JUMP, BOTLIB_EA_DELAYED_JUMP, BOTLIB_EA_MOVE,
         BOTLIB_EA_VIEW, BOTLIB_EA_END_REGULAR, BOTLIB_EA_GET_INPUT, BOTLIB_EA_RESET_INPUT,
         BOTLIB_AI_LOAD_CHARACTER, BOTLIB_AI_FREE_CHARACTER, BOTLIB_AI_CHARACTERISTIC_FLOAT, BOTLIB_AI_CHARACTERISTIC_BFLOAT,
         BOTLIB_AI_CHARACTERISTIC_INTEGER, BOTLIB_AI_CHARACTERISTIC_BINTEGER, BOTLIB_AI_CHARACTERISTIC_STRING,
         BOTLIB_AI_ALLOC_CHAT_STATE, BOTLIB_AI_FREE_CHAT_STATE, BOTLIB_AI_QUEUE_CONSOLE_MESSAGE,
         BOTLIB_AI_REMOVE_CONSOLE_MESSAGE, BOTLIB_AI_NEXT_CONSOLE_MESSAGE, BOTLIB_AI_NUM_CONSOLE_MESSAGE,
         BOTLIB_AI_INITIAL_CHAT, BOTLIB_AI_NUM_INITIAL_CHATS, BOTLIB_AI_REPLY_CHAT, BOTLIB_AI_CHAT_LENGTH,
         BOTLIB_AI_ENTER_CHAT, BOTLIB_AI_GET_CHAT_MESSAGE, BOTLIB_AI_STRING_CONTAINS, BOTLIB_AI_FIND_MATCH,
         BOTLIB_AI_MATCH_VARIABLE, BOTLIB_AI_UNIFY_WHITE_SPACES, BOTLIB_AI_REPLACE_SYNONYMS, BOTLIB_AI_LOAD_CHAT_FILE,
         BOTLIB_AI_SET_CHAT_GENDER, BOTLIB_AI_SET_CHAT_NAME,
         BOTLIB_AI_RESET_GOAL_STATE, BOTLIB_AI_RESET_AVOID_GOALS, BOTLIB_AI_REMOVE_FROM_AVOID_GOALS, BOTLIB_AI_PUSH_GOAL,
         BOTLIB_AI_POP_GOAL, BOTLIB_AI_EMPTY_GOAL_STACK, BOTLIB_AI_DUMP_AVOID_GOALS, BOTLIB_AI_DUMP_GOAL_STACK,
         BOTLIB_AI_GOAL_NAME, BOTLIB_AI_GET_TOP_GOAL, BOTLIB_AI_GET_SECOND_GOAL, BOTLIB_AI_CHOOSE_LTG_ITEM,
         BOTLIB_AI_CHOOSE_NBG_ITEM, BOTLIB_AI_TOUCHING_GOAL, BOTLIB_AI_ITEM_GOAL_IN_VIS_BUT_NOT_VISIBLE,
         BOTLIB_AI_GET_LEVEL_ITEM_GOAL, BOTLIB_AI_GET_NEXT_CAMP_SPOT_GOAL, BOTLIB_AI_GET_MAP_LOCATION_GOAL,
         BOTLIB_AI_AVOID_GOAL_TIME, BOTLIB_AI_SET_AVOID_GOAL_TIME, BOTLIB_AI_INIT_LEVEL_ITEMS,
         BOTLIB_AI_UPDATE_ENTITY_ITEMS, BOTLIB_AI_LOAD_ITEM_WEIGHTS, BOTLIB_AI_FREE_ITEM_WEIGHTS,
         BOTLIB_AI_INTERBREED_GOAL_FUZZY_LOGIC, BOTLIB_AI_SAVE_GOAL_FUZZY_LOGIC, BOTLIB_AI_MUTATE_GOAL_FUZZY_LOGIC,
         BOTLIB_AI_ALLOC_GOAL_STATE, BOTLIB_AI_FREE_GOAL_STATE,
         BOTLIB_AI_RESET_MOVE_STATE, BOTLIB_AI_ADD_AVOID_SPOT, BOTLIB_AI_MOVE_TO_GOAL, BOTLIB_AI_MOVE_IN_DIRECTION,
         BOTLIB_AI_RESET_AVOID_REACH, BOTLIB_AI_RESET_LAST_AVOID_REACH, BOTLIB_AI_REACHABILITY_AREA,
         BOTLIB_AI_MOVEMENT_VIEW_TARGET, BOTLIB_AI_PREDICT_VISIBLE_POSITION, BOTLIB_AI_ALLOC_MOVE_STATE,
         BOTLIB_AI_FREE_MOVE_STATE, BOTLIB_AI_INIT_MOVE_STATE,
         BOTLIB_AI_CHOOSE_BEST_FIGHT_WEAPON, BOTLIB_AI_GET_WEAPON_INFO, BOTLIB_AI_LOAD_WEAPON_WEIGHTS,
         BOTLIB_AI_ALLOC_WEAPON_STATE, BOTLIB_AI_FREE_WEAPON_STATE, BOTLIB_AI_RESET_WEAPON_STATE,
         BOTLIB_AI_GENETIC_PARENTS_AND_CHILD_SELECTION:
        // Port-note: Row B1. `botlib_export_t` has no host form, and `botlib_export` has no storage, so these 123 arms are one hole.
        // Raven wrote: the botlib_export calls of sv_game.cpp:981 to :1311.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    case G_R_REGISTERSKIN,
         G_G2_LISTBONES, G_G2_LISTSURFACES, G_G2_HAVEWEGHOULMODELS, G_G2_SETMODELS, G_G2_GETBOLT, G_G2_GETBOLT_NOREC,
         G_G2_GETBOLT_NOREC_NOROT, G_G2_INITGHOUL2MODEL, G_G2_SETSKIN, G_G2_SIZE, G_G2_ADDBOLT, G_G2_SETBOLTINFO,
         G_G2_ANGLEOVERRIDE, G_G2_PLAYANIM, G_G2_GETBONEANIM, G_G2_GETGLANAME, G_G2_COPYGHOUL2INSTANCE,
         G_G2_COPYSPECIFICGHOUL2MODEL, G_G2_DUPLICATEGHOUL2INSTANCE, G_G2_HASGHOUL2MODELONINDEX, G_G2_REMOVEGHOUL2MODEL,
         G_G2_REMOVEGHOUL2MODELS, G_G2_CLEANMODELS, G_G2_COLLISIONDETECT, G_G2_COLLISIONDETECTCACHE,
         G_G2_SETROOTSURFACE, G_G2_SETSURFACEONOFF, G_G2_SETNEWORIGIN, G_G2_DOESBONEEXIST, G_G2_GETSURFACERENDERSTATUS,
         G_G2_ABSURDSMOOTHING, G_G2_SETRAGDOLL, G_G2_ANIMATEG2MODELS, G_G2_RAGPCJCONSTRAINT, G_G2_RAGPCJGRADIENTSPEED,
         G_G2_RAGEFFECTORGOAL, G_G2_GETRAGBONEPOS, G_G2_RAGEFFECTORKICK, G_G2_RAGFORCESOLVE, G_G2_SETBONEIKSTATE,
         G_G2_IKMOVE, G_G2_REMOVEBONE, G_G2_ATTACHINSTANCETOENTNUM, G_G2_CLEARATTACHEDINSTANCE, G_G2_CLEANENTATTACHMENTS,
         G_G2_OVERRIDESERVER, G_G2_GETSURFACENAME:
        // Port-note: Row Z6. The G2API_ stubs of G2_API.swift carry signature markers, so the arms have no callee to call.
        // Port-note: Row Z6. These 48 arms are one hole.
        // Raven wrote: the RE_RegisterServerSkin and G2API_ calls of sv_game.cpp:1313 to :1617.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    case G_SET_ACTIVE_SUBBSP:
        SV_SetActiveSubBSP(args[1])
        return 0

    case G_RMG_INIT, G_CM_REGISTER_TERRAIN:
        // Port-note: Row C. TheRandomMissionManager and the return of CM_RegisterTerrain are C++ class instances with no port, so their 2 arms are one hole.
        // Raven wrote: the TheRandomMissionManager and CM_RegisterTerrain calls of sv_game.cpp:1624 to :1641.
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:458")

    case G_BOT_UPDATEWAYPOINTS:
        SV_BotWaypointReception(args[1], args.VMA(2))
        return 0

    case G_BOT_CALCULATEPATHS:
        SV_BotCalculatePaths(args[1])
        return 0


    case G_GET_ENTITY_TOKEN:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[2])
        let r = SV_GetEntityToken(&buffer, args[2])
        Com_Memcpy(args.VMA(1), buffer, strlen(buffer) + 1)
        return (r ? 1 : 0)

    default:
        Com_Error(ERR_DROP, "Bad game system trap: %i", args[0])
    }
}

/**
```
===============
SV_ShutdownGameProgs

Called every time a map changes
===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:1666
func SV_ShutdownGameProgs() {
    if gvm == nil {
        return
    }
    VM_Call(gvm!, GAME_SHUTDOWN, false)
    VM_Free(gvm!)
    gvm = nil
}

/**
```
==================
SV_InitGameVM

Called for both a full init and a restart
==================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:1682
private func SV_InitGameVM(_ restart: Bool) {
    var i: Int32

    // start the entity parsing at the beginning
    sv.entityParsePoint = CM_EntityString()

    // use the current msec count for a random seed
    // init for this gamestate
    VM_Call(gvm!, GAME_INIT, svs.time, Com_Milliseconds(), restart)

    // clear all gentity pointers that might still be set from
    // a previous level
    i = 0
    while i < sv_maxclients!.integer {
        svs.clientsSlots[i].gentity = nil
        i += 1
    }
}

/**
```
===================
SV_RestartGameProgs

Called on a map_restart, but not on a normal map change
===================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:1708
func SV_RestartGameProgs() {
    if gvm == nil {
        return
    }
    VM_Call(gvm!, GAME_SHUTDOWN, true)

    // do a restart instead of a free
    gvm = VM_Restart(gvm!)
    if gvm == nil {
        // bk001212 - as done below
        Com_Error(ERR_FATAL, "VM_Restart on game failed")
    }

    SV_InitGameVM(true)
}

/**
```
===============
SV_InitGameProgs

Called on a normal map change, not on a map_restart
===============
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:1731
func SV_InitGameProgs() {
    var `var`: Cvar?
    //FIXME these are temp while I make bots run in vm

    `var` = Cvar_Get("bot_enable", "1", CVAR_LATCH)
    if `var` != nil {
        bot_enable = `var`!.integer
    } else {
        bot_enable = 0
    }

    if Cvar_VariableValue("fs_restrict") == 0 && com_dedicated!.integer == 0 && !Sys_CheckCD() {
        Com_Error(ERR_NEED_CD, SE_GetString("CON_TEXT_NEED_CD")) //"Game CD not in drive" );
    }

    // load the dll or bytecode
    // Port-note: Row V2. VM_Create takes `VmSystemCall?`, a C function over the words, and SV_GameSystemCalls takes a `Slots<Int32>`.
    // Port-note: Row V2. No C thunk over SV_GameSystemCalls exists, and the shell does not set `jka_systemCall` of CJKAHost.
    // Raven wrote: gvm = VM_Create( "jampgame", SV_GameSystemCalls, (vmInterpret_t)(int)Cvar_VariableValue( "vm_game" ) )
    portMissing("SV_InitGameProgs", source: "oracle/codemp/server/sv_game.cpp:1731")
    if gvm == nil {
        Com_Error(ERR_FATAL, "VM_Create on game failed")
    }

    SV_InitGameVM(false)
}

/**
```
====================
SV_GameCommand

See if the current console command is claimed by the game
====================
```
*/
/// Source: oracle/codemp/server/sv_game.cpp:1766
func SV_GameCommand() -> Bool {
    if sv.state != SS_GAME {
        return false
    }

    return VM_Call(gvm!, GAME_CONSOLE_COMMAND) != 0
}
