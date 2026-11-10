import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/server/sv_game.cpp:32
var botlib_export: BotlibExport? {
    get { world.variables.botlib_export }
    set { world.variables.botlib_export = newValue }
}

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
// AI: Raven's function is file-scope. It is public, because the shell installs it as `GameSystemCalls` of the view target.
// AI: Raven returns an `int`, which holds an address only on a 32-bit build. The function returns the pointer-wide word, the form of VM_Call, so each `int` result widens.
public func SV_GameSystemCalls(_ args: Slots<Int32>) -> Int {
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
        // AI: Raven's strncpy writes into the module's buffer. The arm fills a CharBuf of that size and copies all of its bytes into the module's bytes.
        var buffer = CharBuf(args[3])
        strncpy(&buffer, args.VMA(2) as String, args[3])
        Com_Memcpy(args.VMA(1), buffer, args[3])
        // AI: Raven returns the destination pointer of strncpy, the module's buffer. The arm returns the whole word of that address.
        return args.VMA(1)

    case TRAP_SIN:
        return Int(FloatAsInt(sin(args.VMF(1))))

    case TRAP_COS:
        return Int(FloatAsInt(cos(args.VMF(1))))

    case TRAP_ATAN2:
        return Int(FloatAsInt(atan2(args.VMF(1), args.VMF(2))))

    case TRAP_SQRT:
        return Int(FloatAsInt(sqrt(args.VMF(1))))

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
        return Int(FloatAsInt(floor(args.VMF(1))))

    case TRAP_CEIL:
        return Int(FloatAsInt(ceil(args.VMF(1))))

    case TRAP_TESTPRINTINT:
        return 0

    case TRAP_TESTPRINTFLOAT:
        return 0

    case TRAP_ACOS:
        return Int(FloatAsInt(Q_acos(args.VMF(1))))

    case TRAP_ASIN:
        return Int(FloatAsInt(Q_asin(args.VMF(1))))


    case G_PRINT:
        Com_Printf("%s", args.VMA(1) as String)
        return 0

    case G_ERROR:
        Com_Error(ERR_DROP, "%s", args.VMA(1) as String)

    case G_MILLISECONDS:
        return Int(Sys_Milliseconds())

    //rww - precision timer funcs... -ALWAYS- call end after start with supplied ptr, or you'll get a nasty memory leak.
    //not that you should be using these outside of debug anyway.. because you shouldn't be. So don't.
    // Port-note: Row G4. Raven's labels are CG_PRECISIONTIMER_START and CG_PRECISIONTIMER_END of cg_public.h, which the host does not import.
    // Port-note: Row G4. The arms keep a `timing_c` in the module's memory as a word, and the Swift class has no form as a word.
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
        return Int(Cvar_VariableIntegerValue(args.VMA(1)))

    case G_CVAR_VARIABLE_STRING_BUFFER:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buffer = CharBuf(args[3])
        Cvar_VariableStringBuffer(args.VMA(1), &buffer, args[3])
        Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)
        return 0

    case G_ARGC:
        return Int(Cmd_Argc())

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
        return Int(FS_FOpenFileByMode(args.VMA(1), &f[0], args[3]))

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
        return Int(count)


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
        return Int(SV_AreaEntities(args.VMA(1), args.VMA(2), args.VMA(3), args[4]))

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
        return Int(SV_PointContents(args.VMA(1), args[2]))

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
        return Int(SV_BotAllocateClient())

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
        return Int(BotImport_DebugPolygonCreate(args[1], args[2], args.VMA(3)))

    case G_DEBUG_POLYGON_DELETE:
        BotImport_DebugPolygonDelete(args[1])
        return 0

    case G_REAL_TIME:
        return Int(Com_RealTime(args.VMA(1)))

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

    case G_ROFF_CLEAN:
        return (theROFFSystem.Clean(false) ? 1 : 0)

    case G_ROFF_UPDATE_ENTITIES:
        theROFFSystem.UpdateEntities(false)
        return 0

    case G_ROFF_CACHE:
        return Int(theROFFSystem.Cache(args.VMA(1), false))

    case G_ROFF_PLAY:
        return (theROFFSystem.Play(args[1], args[2], args[3] != 0, false) ? 1 : 0)

    case G_ROFF_PURGE_ENT:
        return (theROFFSystem.PurgeEnt(args[1], false) ? 1 : 0)

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
        return Int(ICARUS_RunScript(ConvertedEntity(args.VMA(1)!)!, args.VMA(2)))

    case G_ICARUS_REGISTERSCRIPT:
        return (ICARUS_RegisterScript(args.VMA(1), args[2] != 0) ? 1 : 0)

    case G_ICARUS_INIT:
        ICARUS_Init()
        return 0

    case G_ICARUS_VALIDENT:
        return (ICARUS_ValidEnt(ConvertedEntity(args.VMA(1)!)!) ? 1 : 0)

    case G_ICARUS_ISINITIALIZED:
        do {
            let entID = args[1]

            if gSequencers[entID] == nil || gTaskManagers[entID] == nil {
                return 0
            }
        }
        return 1

    case G_ICARUS_MAINTAINTASKMANAGER:
        do {
            let entID = args[1]

            if let taskManager = gTaskManagers[entID] {
                taskManager.Update()
                return 1
            }
        }
        return 0

    case G_ICARUS_ISRUNNING:
        do {
            let entID = args[1]

            if gTaskManagers[entID] == nil || !gTaskManagers[entID]!.IsRunning() {
                return 0
            }
        }
        return 1

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
        return Int(Q3_VariableDeclared(args.VMA(1)))

    case G_ICARUS_GETFLOATVARIABLE:
        // AI: Raven hands the module's float to the callee by address. The arm hands the slot of the Slots at the word.
        let value: Slots<Float> = args.VMA(2)
        return Int(Q3_GetFloatVariable(args.VMA(1), &value[0]))

    case G_ICARUS_GETSTRINGVARIABLE:
        var rec = TextCursor(CharBuf(args.VMA(2) as String))
        return Int(Q3_GetStringVariable(args.VMA(1), &rec))

    case G_ICARUS_GETVECTORVARIABLE:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let value: Slots<vec3_t> = args.VMA(2)
        return Int(Q3_GetVectorVariable(args.VMA(1), &value[0]))

    //rww - BEGIN NPC NAV TRAPS
    case G_NAV_INIT:
        navigator.Init()
        return 0

    case G_NAV_FREE:
        navigator.Free()
        return 0

    case G_NAV_LOAD:
        return (navigator.Load(args.VMA(1), args[2]) ? 1 : 0)

    case G_NAV_SAVE:
        return (navigator.Save(args.VMA(1), args[2]) ? 1 : 0)

    case G_NAV_ADDRAWPOINT:
        return Int(navigator.AddRawPoint(args.VMA(1), args[2], args[3]))

    case G_NAV_CALCULATEPATHS:
        navigator.CalculatePaths(args[1] != 0)
        return 0

    case G_NAV_HARDCONNECT:
        navigator.HardConnect(args[1], args[2])
        return 0

    case G_NAV_SHOWNODES:
        navigator.ShowNodes()
        return 0

    case G_NAV_SHOWEDGES:
        navigator.ShowEdges()
        return 0

    case G_NAV_SHOWPATH:
        navigator.ShowPath(args[1], args[2])
        return 0

    case G_NAV_GETNEARESTNODE:
        return Int(navigator.GetNearestNode(args.VMA(1), args[2], args[3], args[4]))

    case G_NAV_GETBESTNODE:
        return Int(navigator.GetBestNode(args[1], args[2], args[3]))

    case G_NAV_GETNODEPOSITION:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let out: Slots<vec3_t> = args.VMA(2)
        return Int(navigator.GetNodePosition(args[1], &out[0]))

    case G_NAV_GETNODENUMEDGES:
        return Int(navigator.GetNodeNumEdges(args[1]))

    case G_NAV_GETNODEEDGE:
        return Int(navigator.GetNodeEdge(args[1], args[2]))

    case G_NAV_GETNUMNODES:
        return Int(navigator.GetNumNodes())

    case G_NAV_CONNECTED:
        return (navigator.Connected(args[1], args[2]) ? 1 : 0)

    case G_NAV_GETPATHCOST:
        return Int(navigator.GetPathCost(args[1], args[2]))

    case G_NAV_GETEDGECOST:
        return Int(navigator.GetEdgeCost(args[1], args[2]))

    case G_NAV_GETPROJECTEDNODE:
        return Int(navigator.GetProjectedNode(args.VMA(1), args[2]))

    case G_NAV_CHECKFAILEDNODES:
        navigator.CheckFailedNodes(args.VMA(1))
        return 0

    case G_NAV_ADDFAILEDNODE:
        navigator.AddFailedNode(args.VMA(1), args[2])
        return 0

    case G_NAV_NODEFAILED:
        return (navigator.NodeFailed(args.VMA(1), args[2]) ? 1 : 0)

    case G_NAV_NODESARENEIGHBORS:
        return (navigator.NodesAreNeighbors(args[1], args[2]) ? 1 : 0)

    case G_NAV_CLEARFAILEDEDGE:
        navigator.ClearFailedEdge(args.VMA(1))
        return 0

    case G_NAV_CLEARALLFAILEDEDGES:
        navigator.ClearAllFailedEdges()
        return 0

    case G_NAV_EDGEFAILED:
        return Int(navigator.EdgeFailed(args[1], args[2]))

    case G_NAV_ADDFAILEDEDGE:
        navigator.AddFailedEdge(args[1], args[2], args[3])
        return 0

    case G_NAV_CHECKFAILEDEDGE:
        return (navigator.CheckFailedEdge(args.VMA(1)) ? 1 : 0)

    case G_NAV_CHECKALLFAILEDEDGES:
        navigator.CheckAllFailedEdges()
        return 0

    case G_NAV_ROUTEBLOCKED:
        return (navigator.RouteBlocked(args[1], args[2], args[3], args[4]) ? 1 : 0)

    case G_NAV_GETBESTNODEALTROUTE:
        // AI: Raven hands the module's int to the callee by address. The arm hands the slot of the Slots at the word.
        let pathCost: Slots<Int32> = args.VMA(3)
        return Int(navigator.GetBestNodeAltRoute(args[1], args[2], &pathCost[0], args[4]))

    case G_NAV_GETBESTNODEALT2:
        return Int(navigator.GetBestNodeAltRoute(args[1], args[2], args[3]))

    case G_NAV_GETBESTPATHBETWEENENTS:
        return Int(navigator.GetBestPathBetweenEnts(args.VMA(1), args.VMA(2), args[3]))

    case G_NAV_GETNODERADIUS:
        return Int(navigator.GetNodeRadius(args[1]))

    case G_NAV_CHECKBLOCKEDEDGES:
        navigator.CheckBlockedEdges()
        return 0

    case G_NAV_CLEARCHECKEDNODES:
        navigator.ClearCheckedNodes()
        return 0

    case G_NAV_CHECKEDNODE:
        return Int(navigator.CheckedNode(args[1], args[2]))

    case G_NAV_SETCHECKEDNODE:
        // C converts the `int` value to the `byte` parameter.
        navigator.SetCheckedNode(args[1], args[2], JKAShared.byte(truncatingIfNeeded: args[3]))
        // Raven's case has no return, so it falls through to the next case.
        fallthrough

    case G_NAV_FLAGALLNODES:
        navigator.FlagAllNodes(args[1])
        // Raven's case has no return, so it falls through to the next case.
        fallthrough

    case G_NAV_GETPATHSCALCULATED:
        return (navigator.pathsCalculated ? 1 : 0)

    case G_NAV_SETPATHSCALCULATED:
        navigator.pathsCalculated = args[1] != 0
        return 0
    //rww - END NPC NAV TRAPS

    case G_SET_SHARED_BUFFER:
        // AI: Raven stores the module's buffer address in the `char *` field. The arm stores the bytes at the word in the bytes accessor.
        sv.mSharedMemoryBytes = args.VMA(1)
        return 0
        //====================================

    case BOTLIB_SETUP:
        return Int(SV_BotLibSetup())

    case BOTLIB_SHUTDOWN:
        return Int(SV_BotLibShutdown())

    case BOTLIB_LIBVAR_SET:
        return Int(botlib_export!.runBotLibVarSet(args.VMA(1), args.VMA(2)))

    case BOTLIB_LIBVAR_GET:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var value = CharBuf(args[3])
        let r = botlib_export!.runBotLibVarGet(args.VMA(1), &value, args[3])
        Com_Memcpy(args.VMA(2), value, strlen(value) + 1)
        return Int(r)

    case BOTLIB_PC_ADD_GLOBAL_DEFINE:
        return Int(botlib_export!.runPC_AddGlobalDefine(args.VMA(1)))

    case BOTLIB_PC_LOAD_SOURCE:
        return Int(botlib_export!.runPC_LoadSourceHandle(args.VMA(1)))

    case BOTLIB_PC_FREE_SOURCE:
        return Int(botlib_export!.runPC_FreeSourceHandle(args[1]))

    case BOTLIB_PC_READ_TOKEN:
        return Int(botlib_export!.runPC_ReadTokenHandle(args[1], args.VMA(2)))

    case BOTLIB_PC_SOURCE_FILE_AND_LINE:
        return Int(botlib_export!.runPC_SourceFileAndLine(args[1], args.VMA(2), args.VMA(3)))

    case BOTLIB_START_FRAME:
        return Int(botlib_export!.runBotLibStartFrame(args.VMF(1)))

    case BOTLIB_LOAD_MAP:
        return Int(botlib_export!.runBotLibLoadMap(args.VMA(1)))

    case BOTLIB_UPDATENTITY:
        return Int(botlib_export!.runBotLibUpdateEntity(args[1], args.VMA(2)))

    case BOTLIB_TEST:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let parm2: Slots<vec3_t> = args.VMA(3)
        let parm3: Slots<vec3_t> = args.VMA(4)
        return Int(botlib_export!.runTest(args[1], args.VMA(2), &parm2[0], &parm3[0]))

    case BOTLIB_GET_SNAPSHOT_ENTITY:
        return Int(SV_BotGetSnapshotEntity(args[1], args[2]))

    case BOTLIB_GET_CONSOLE_MESSAGE:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buf = CharBuf(args[3])
        let r = SV_BotGetConsoleMessage(args[1], &buf, args[3])
        Com_Memcpy(args.VMA(2), buf, strlen(buf) + 1)
        return Int(r)

    case BOTLIB_USER_COMMAND:
        SV_ClientThink(svs.clientsSlots[args[1]], args.VMA(2)!)
        return 0

    case BOTLIB_AAS_BBOX_AREAS:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let absmins: Slots<vec3_t> = args.VMA(1)
        let absmaxs: Slots<vec3_t> = args.VMA(2)
        return Int(botlib_export!.aas.runAAS_BBoxAreas(&absmins[0], &absmaxs[0], args.VMA(3), args[4]))

    case BOTLIB_AAS_AREA_INFO:
        return Int(botlib_export!.aas.runAAS_AreaInfo(args[1], args.VMA(2)))

    case BOTLIB_AAS_ALTERNATIVE_ROUTE_GOAL:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let start: Slots<vec3_t> = args.VMA(1)
        let goal: Slots<vec3_t> = args.VMA(3)
        return Int(botlib_export!.aas.runAAS_AlternativeRouteGoals(&start[0], args[2], &goal[0], args[4], args[5], args.VMA(6), args[7], args[8]))

    case BOTLIB_AAS_ENTITY_INFO:
        botlib_export!.aas.runAAS_EntityInfo(args[1], args.VMA(2))
        return 0

    case BOTLIB_AAS_INITIALIZED:
        return Int(botlib_export!.aas.runAAS_Initialized())

    case BOTLIB_AAS_PRESENCE_TYPE_BOUNDING_BOX:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let mins: Slots<vec3_t> = args.VMA(2)
        let maxs: Slots<vec3_t> = args.VMA(3)
        botlib_export!.aas.runAAS_PresenceTypeBoundingBox(args[1], &mins[0], &maxs[0])
        return 0

    case BOTLIB_AAS_TIME:
        return Int(FloatAsInt(botlib_export!.aas.runAAS_Time()))

    case BOTLIB_AAS_POINT_AREA_NUM:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let point: Slots<vec3_t> = args.VMA(1)
        return Int(botlib_export!.aas.runAAS_PointAreaNum(&point[0]))

    case BOTLIB_AAS_POINT_REACHABILITY_AREA_INDEX:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let point: Slots<vec3_t> = args.VMA(1)
        return Int(botlib_export!.aas.runAAS_PointReachabilityAreaIndex(&point[0]))

    case BOTLIB_AAS_TRACE_AREAS:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let start: Slots<vec3_t> = args.VMA(1)
        let end: Slots<vec3_t> = args.VMA(2)
        return Int(botlib_export!.aas.runAAS_TraceAreas(&start[0], &end[0], args.VMA(3), args.VMA(4), args[5]))

    case BOTLIB_AAS_POINT_CONTENTS:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let point: Slots<vec3_t> = args.VMA(1)
        return Int(botlib_export!.aas.runAAS_PointContents(&point[0]))

    case BOTLIB_AAS_NEXT_BSP_ENTITY:
        return Int(botlib_export!.aas.runAAS_NextBSPEntity(args[1]))

    case BOTLIB_AAS_VALUE_FOR_BSP_EPAIR_KEY:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var value = CharBuf(args[4])
        let r = botlib_export!.aas.runAAS_ValueForBSPEpairKey(args[1], args.VMA(2), &value, args[4])
        Com_Memcpy(args.VMA(3), value, strlen(value) + 1)
        return Int(r)

    case BOTLIB_AAS_VECTOR_FOR_BSP_EPAIR_KEY:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let v: Slots<vec3_t> = args.VMA(3)
        return Int(botlib_export!.aas.runAAS_VectorForBSPEpairKey(args[1], args.VMA(2), &v[0]))

    case BOTLIB_AAS_FLOAT_FOR_BSP_EPAIR_KEY:
        // AI: Raven hands the module's float to the callee by address. The arm hands the slot of the Slots at the word.
        let value: Slots<Float> = args.VMA(3)
        return Int(botlib_export!.aas.runAAS_FloatForBSPEpairKey(args[1], args.VMA(2), &value[0]))

    case BOTLIB_AAS_INT_FOR_BSP_EPAIR_KEY:
        return Int(botlib_export!.aas.runAAS_IntForBSPEpairKey(args[1], args.VMA(2), args.VMA(3)))

    case BOTLIB_AAS_AREA_REACHABILITY:
        return Int(botlib_export!.aas.runAAS_AreaReachability(args[1]))

    case BOTLIB_AAS_AREA_TRAVEL_TIME_TO_GOAL_AREA:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(2)
        return Int(botlib_export!.aas.runAAS_AreaTravelTimeToGoalArea(args[1], &origin[0], args[3], args[4]))

    case BOTLIB_AAS_ENABLE_ROUTING_AREA:
        return Int(botlib_export!.aas.runAAS_EnableRoutingArea(args[1], args[2]))

    case BOTLIB_AAS_PREDICT_ROUTE:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(3)
        return Int(botlib_export!.aas.runAAS_PredictRoute(args.VMA(1), args[2], &origin[0], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]))

    case BOTLIB_AAS_SWIMMING:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(1)
        return Int(botlib_export!.aas.runAAS_Swimming(&origin[0]))

    case BOTLIB_AAS_PREDICT_CLIENT_MOVEMENT:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let origin: Slots<vec3_t> = args.VMA(3)
        let velocity: Slots<vec3_t> = args.VMA(6)
        let cmdmove: Slots<vec3_t> = args.VMA(7)
        return Int(botlib_export!.aas.runAAS_PredictClientMovement(args.VMA(1), args[2], &origin[0], args[4], args[5], &velocity[0], &cmdmove[0], args[8], args[9], args.VMF(10), args[11], args[12], args[13]))

    case BOTLIB_EA_SAY:
        botlib_export!.ea.runEA_Say(args[1], args.VMA(2))
        return 0

    case BOTLIB_EA_SAY_TEAM:
        botlib_export!.ea.runEA_SayTeam(args[1], args.VMA(2))
        return 0

    case BOTLIB_EA_COMMAND:
        botlib_export!.ea.runEA_Command(args[1], args.VMA(2))
        return 0

    case BOTLIB_EA_ACTION:
        botlib_export!.ea.runEA_Action(args[1], args[2])
        break

    case BOTLIB_EA_GESTURE:
        botlib_export!.ea.runEA_Gesture(args[1])
        return 0

    case BOTLIB_EA_TALK:
        botlib_export!.ea.runEA_Talk(args[1])
        return 0

    case BOTLIB_EA_ATTACK:
        botlib_export!.ea.runEA_Attack(args[1])
        return 0

    case BOTLIB_EA_ALT_ATTACK:
        botlib_export!.ea.runEA_Alt_Attack(args[1])
        return 0

    case BOTLIB_EA_FORCEPOWER:
        botlib_export!.ea.runEA_ForcePower(args[1])
        return 0

    case BOTLIB_EA_USE:
        botlib_export!.ea.runEA_Use(args[1])
        return 0

    case BOTLIB_EA_RESPAWN:
        botlib_export!.ea.runEA_Respawn(args[1])
        return 0

    case BOTLIB_EA_CROUCH:
        botlib_export!.ea.runEA_Crouch(args[1])
        return 0

    case BOTLIB_EA_MOVE_UP:
        botlib_export!.ea.runEA_MoveUp(args[1])
        return 0

    case BOTLIB_EA_MOVE_DOWN:
        botlib_export!.ea.runEA_MoveDown(args[1])
        return 0

    case BOTLIB_EA_MOVE_FORWARD:
        botlib_export!.ea.runEA_MoveForward(args[1])
        return 0

    case BOTLIB_EA_MOVE_BACK:
        botlib_export!.ea.runEA_MoveBack(args[1])
        return 0

    case BOTLIB_EA_MOVE_LEFT:
        botlib_export!.ea.runEA_MoveLeft(args[1])
        return 0

    case BOTLIB_EA_MOVE_RIGHT:
        botlib_export!.ea.runEA_MoveRight(args[1])
        return 0

    case BOTLIB_EA_SELECT_WEAPON:
        botlib_export!.ea.runEA_SelectWeapon(args[1], args[2])
        return 0

    case BOTLIB_EA_JUMP:
        botlib_export!.ea.runEA_Jump(args[1])
        return 0

    case BOTLIB_EA_DELAYED_JUMP:
        botlib_export!.ea.runEA_DelayedJump(args[1])
        return 0

    case BOTLIB_EA_MOVE:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let dir: Slots<vec3_t> = args.VMA(2)
        botlib_export!.ea.runEA_Move(args[1], &dir[0], args.VMF(3))
        return 0

    case BOTLIB_EA_VIEW:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let viewangles: Slots<vec3_t> = args.VMA(2)
        botlib_export!.ea.runEA_View(args[1], &viewangles[0])
        return 0

    case BOTLIB_EA_END_REGULAR:
        botlib_export!.ea.runEA_EndRegular(args[1], args.VMF(2))
        return 0

    case BOTLIB_EA_GET_INPUT:
        botlib_export!.ea.runEA_GetInput(args[1], args.VMF(2), args.VMA(3))
        return 0

    case BOTLIB_EA_RESET_INPUT:
        botlib_export!.ea.runEA_ResetInput(args[1])
        return 0

    case BOTLIB_AI_LOAD_CHARACTER:
        return Int(botlib_export!.ai.runBotLoadCharacter(args.VMA(1), args.VMF(2)))

    case BOTLIB_AI_FREE_CHARACTER:
        botlib_export!.ai.runBotFreeCharacter(args[1])
        return 0

    case BOTLIB_AI_CHARACTERISTIC_FLOAT:
        return Int(FloatAsInt(botlib_export!.ai.runCharacteristic_Float(args[1], args[2])))

    case BOTLIB_AI_CHARACTERISTIC_BFLOAT:
        return Int(FloatAsInt(botlib_export!.ai.runCharacteristic_BFloat(args[1], args[2], args.VMF(3), args.VMF(4))))

    case BOTLIB_AI_CHARACTERISTIC_INTEGER:
        return Int(botlib_export!.ai.runCharacteristic_Integer(args[1], args[2]))

    case BOTLIB_AI_CHARACTERISTIC_BINTEGER:
        return Int(botlib_export!.ai.runCharacteristic_BInteger(args[1], args[2], args[3], args[4]))

    case BOTLIB_AI_CHARACTERISTIC_STRING:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buf = CharBuf(args[4])
        botlib_export!.ai.runCharacteristic_String(args[1], args[2], &buf, args[4])
        Com_Memcpy(args.VMA(3), buf, strlen(buf) + 1)
        return 0

    case BOTLIB_AI_ALLOC_CHAT_STATE:
        return Int(botlib_export!.ai.runBotAllocChatState())

    case BOTLIB_AI_FREE_CHAT_STATE:
        botlib_export!.ai.runBotFreeChatState(args[1])
        return 0

    case BOTLIB_AI_QUEUE_CONSOLE_MESSAGE:
        botlib_export!.ai.runBotQueueConsoleMessage(args[1], args[2], args.VMA(3))
        return 0

    case BOTLIB_AI_REMOVE_CONSOLE_MESSAGE:
        botlib_export!.ai.runBotRemoveConsoleMessage(args[1], args[2])
        return 0

    case BOTLIB_AI_NEXT_CONSOLE_MESSAGE:
        return Int(botlib_export!.ai.runBotNextConsoleMessage(args[1], args.VMA(2)))

    case BOTLIB_AI_NUM_CONSOLE_MESSAGE:
        return Int(botlib_export!.ai.runBotNumConsoleMessages(args[1]))

    case BOTLIB_AI_INITIAL_CHAT:
        botlib_export!.ai.runBotInitialChat(args[1], args.VMA(2), args[3], args.VMA(4), args.VMA(5), args.VMA(6), args.VMA(7), args.VMA(8), args.VMA(9), args.VMA(10), args.VMA(11))
        return 0

    case BOTLIB_AI_NUM_INITIAL_CHATS:
        return Int(botlib_export!.ai.runBotNumInitialChats(args[1], args.VMA(2)))

    case BOTLIB_AI_REPLY_CHAT:
        return Int(botlib_export!.ai.runBotReplyChat(args[1], args.VMA(2), args[3], args[4], args.VMA(5), args.VMA(6), args.VMA(7), args.VMA(8), args.VMA(9), args.VMA(10), args.VMA(11), args.VMA(12)))

    case BOTLIB_AI_CHAT_LENGTH:
        return Int(botlib_export!.ai.runBotChatLength(args[1]))

    case BOTLIB_AI_ENTER_CHAT:
        botlib_export!.ai.runBotEnterChat(args[1], args[2], args[3])
        return 0

    case BOTLIB_AI_GET_CHAT_MESSAGE:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buf = CharBuf(args[3])
        botlib_export!.ai.runBotGetChatMessage(args[1], &buf, args[3])
        Com_Memcpy(args.VMA(2), buf, strlen(buf) + 1)
        return 0

    case BOTLIB_AI_STRING_CONTAINS:
        return Int(botlib_export!.ai.runStringContains(args.VMA(1), args.VMA(2), args[3]))

    case BOTLIB_AI_FIND_MATCH:
        // AI: Raven passes the int context to the unsigned long parameter, and C converts it. The arm writes the conversion.
        return Int(botlib_export!.ai.runBotFindMatch(args.VMA(1), args.VMA(2), CUnsignedLong(args[3])))

    case BOTLIB_AI_MATCH_VARIABLE:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var buf = CharBuf(args[4])
        botlib_export!.ai.runBotMatchVariable(args.VMA(1), args[2], &buf, args[4])
        Com_Memcpy(args.VMA(3), buf, strlen(buf) + 1)
        return 0

    case BOTLIB_AI_UNIFY_WHITE_SPACES:
        botlib_export!.ai.runUnifyWhiteSpaces(args.VMA(1))
        return 0

    case BOTLIB_AI_REPLACE_SYNONYMS:
        // AI: Raven passes the int context to the unsigned long parameter, and C converts it. The arm writes the conversion.
        botlib_export!.ai.runBotReplaceSynonyms(args.VMA(1), CUnsignedLong(args[2]))
        return 0

    case BOTLIB_AI_LOAD_CHAT_FILE:
        return Int(botlib_export!.ai.runBotLoadChatFile(args[1], args.VMA(2), args.VMA(3)))

    case BOTLIB_AI_SET_CHAT_GENDER:
        botlib_export!.ai.runBotSetChatGender(args[1], args[2])
        return 0

    case BOTLIB_AI_SET_CHAT_NAME:
        botlib_export!.ai.runBotSetChatName(args[1], args.VMA(2), args[3])
        return 0

    case BOTLIB_AI_RESET_GOAL_STATE:
        botlib_export!.ai.runBotResetGoalState(args[1])
        return 0

    case BOTLIB_AI_RESET_AVOID_GOALS:
        botlib_export!.ai.runBotResetAvoidGoals(args[1])
        return 0

    case BOTLIB_AI_REMOVE_FROM_AVOID_GOALS:
        botlib_export!.ai.runBotRemoveFromAvoidGoals(args[1], args[2])
        return 0

    case BOTLIB_AI_PUSH_GOAL:
        botlib_export!.ai.runBotPushGoal(args[1], args.VMA(2))
        return 0

    case BOTLIB_AI_POP_GOAL:
        botlib_export!.ai.runBotPopGoal(args[1])
        return 0

    case BOTLIB_AI_EMPTY_GOAL_STACK:
        botlib_export!.ai.runBotEmptyGoalStack(args[1])
        return 0

    case BOTLIB_AI_DUMP_AVOID_GOALS:
        botlib_export!.ai.runBotDumpAvoidGoals(args[1])
        return 0

    case BOTLIB_AI_DUMP_GOAL_STACK:
        botlib_export!.ai.runBotDumpGoalStack(args[1])
        return 0

    case BOTLIB_AI_GOAL_NAME:
        // AI: Raven's callee writes into the module's buffer. The callee fills a CharBuf, and the arm copies the text into the module's bytes.
        var name = CharBuf(args[3])
        botlib_export!.ai.runBotGoalName(args[1], &name, args[3])
        Com_Memcpy(args.VMA(2), name, strlen(name) + 1)
        return 0

    case BOTLIB_AI_GET_TOP_GOAL:
        return Int(botlib_export!.ai.runBotGetTopGoal(args[1], args.VMA(2)))

    case BOTLIB_AI_GET_SECOND_GOAL:
        return Int(botlib_export!.ai.runBotGetSecondGoal(args[1], args.VMA(2)))

    case BOTLIB_AI_CHOOSE_LTG_ITEM:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(2)
        return Int(botlib_export!.ai.runBotChooseLTGItem(args[1], &origin[0], args.VMA(3), args[4]))

    case BOTLIB_AI_CHOOSE_NBG_ITEM:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(2)
        return Int(botlib_export!.ai.runBotChooseNBGItem(args[1], &origin[0], args.VMA(3), args[4], args.VMA(5), args.VMF(6)))

    case BOTLIB_AI_TOUCHING_GOAL:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(1)
        return Int(botlib_export!.ai.runBotTouchingGoal(&origin[0], args.VMA(2)))

    case BOTLIB_AI_ITEM_GOAL_IN_VIS_BUT_NOT_VISIBLE:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let eye: Slots<vec3_t> = args.VMA(2)
        let viewangles: Slots<vec3_t> = args.VMA(3)
        return Int(botlib_export!.ai.runBotItemGoalInVisButNotVisible(args[1], &eye[0], &viewangles[0], args.VMA(4)))

    case BOTLIB_AI_GET_LEVEL_ITEM_GOAL:
        return Int(botlib_export!.ai.runBotGetLevelItemGoal(args[1], args.VMA(2), args.VMA(3)))

    case BOTLIB_AI_GET_NEXT_CAMP_SPOT_GOAL:
        return Int(botlib_export!.ai.runBotGetNextCampSpotGoal(args[1], args.VMA(2)))

    case BOTLIB_AI_GET_MAP_LOCATION_GOAL:
        return Int(botlib_export!.ai.runBotGetMapLocationGoal(args.VMA(1), args.VMA(2)))

    case BOTLIB_AI_AVOID_GOAL_TIME:
        return Int(FloatAsInt(botlib_export!.ai.runBotAvoidGoalTime(args[1], args[2])))

    case BOTLIB_AI_SET_AVOID_GOAL_TIME:
        botlib_export!.ai.runBotSetAvoidGoalTime(args[1], args[2], args.VMF(3))
        return 0

    case BOTLIB_AI_INIT_LEVEL_ITEMS:
        botlib_export!.ai.runBotInitLevelItems()
        return 0

    case BOTLIB_AI_UPDATE_ENTITY_ITEMS:
        botlib_export!.ai.runBotUpdateEntityItems()
        return 0

    case BOTLIB_AI_LOAD_ITEM_WEIGHTS:
        return Int(botlib_export!.ai.runBotLoadItemWeights(args[1], args.VMA(2)))

    case BOTLIB_AI_FREE_ITEM_WEIGHTS:
        botlib_export!.ai.runBotFreeItemWeights(args[1])
        return 0

    case BOTLIB_AI_INTERBREED_GOAL_FUZZY_LOGIC:
        botlib_export!.ai.runBotInterbreedGoalFuzzyLogic(args[1], args[2], args[3])
        return 0

    case BOTLIB_AI_SAVE_GOAL_FUZZY_LOGIC:
        botlib_export!.ai.runBotSaveGoalFuzzyLogic(args[1], args.VMA(2))
        return 0

    case BOTLIB_AI_MUTATE_GOAL_FUZZY_LOGIC:
        botlib_export!.ai.runBotMutateGoalFuzzyLogic(args[1], args.VMF(2))
        return 0

    case BOTLIB_AI_ALLOC_GOAL_STATE:
        return Int(botlib_export!.ai.runBotAllocGoalState(args[1]))

    case BOTLIB_AI_FREE_GOAL_STATE:
        botlib_export!.ai.runBotFreeGoalState(args[1])
        return 0

    case BOTLIB_AI_RESET_MOVE_STATE:
        botlib_export!.ai.runBotResetMoveState(args[1])
        return 0

    case BOTLIB_AI_ADD_AVOID_SPOT:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(2)
        botlib_export!.ai.runBotAddAvoidSpot(args[1], &origin[0], args.VMF(3), args[4])
        return 0

    case BOTLIB_AI_MOVE_TO_GOAL:
        botlib_export!.ai.runBotMoveToGoal(args.VMA(1), args[2], args.VMA(3), args[4])
        return 0

    case BOTLIB_AI_MOVE_IN_DIRECTION:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let dir: Slots<vec3_t> = args.VMA(2)
        return Int(botlib_export!.ai.runBotMoveInDirection(args[1], &dir[0], args.VMF(3), args[4]))

    case BOTLIB_AI_RESET_AVOID_REACH:
        botlib_export!.ai.runBotResetAvoidReach(args[1])
        return 0

    case BOTLIB_AI_RESET_LAST_AVOID_REACH:
        botlib_export!.ai.runBotResetLastAvoidReach(args[1])
        return 0

    case BOTLIB_AI_REACHABILITY_AREA:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let origin: Slots<vec3_t> = args.VMA(1)
        return Int(botlib_export!.ai.runBotReachabilityArea(&origin[0], args[2]))

    case BOTLIB_AI_MOVEMENT_VIEW_TARGET:
        // AI: Raven hands the module's vector to the callee by address. The arm hands the slot of the Slots at the word.
        let target: Slots<vec3_t> = args.VMA(5)
        return Int(botlib_export!.ai.runBotMovementViewTarget(args[1], args.VMA(2), args[3], args.VMF(4), &target[0]))

    case BOTLIB_AI_PREDICT_VISIBLE_POSITION:
        // AI: Raven hands the module's vectors to the callee by address. The arm hands the slot of the Slots at each word.
        let origin: Slots<vec3_t> = args.VMA(1)
        let target: Slots<vec3_t> = args.VMA(5)
        return Int(botlib_export!.ai.runBotPredictVisiblePosition(&origin[0], args[2], args.VMA(3), args[4], &target[0]))

    case BOTLIB_AI_ALLOC_MOVE_STATE:
        return Int(botlib_export!.ai.runBotAllocMoveState())

    case BOTLIB_AI_FREE_MOVE_STATE:
        botlib_export!.ai.runBotFreeMoveState(args[1])
        return 0

    case BOTLIB_AI_INIT_MOVE_STATE:
        botlib_export!.ai.runBotInitMoveState(args[1], args.VMA(2))
        return 0

    case BOTLIB_AI_CHOOSE_BEST_FIGHT_WEAPON:
        return Int(botlib_export!.ai.runBotChooseBestFightWeapon(args[1], args.VMA(2)))

    case BOTLIB_AI_GET_WEAPON_INFO:
        botlib_export!.ai.runBotGetWeaponInfo(args[1], args[2], args.VMA(3))
        return 0

    case BOTLIB_AI_LOAD_WEAPON_WEIGHTS:
        return Int(botlib_export!.ai.runBotLoadWeaponWeights(args[1], args.VMA(2)))

    case BOTLIB_AI_ALLOC_WEAPON_STATE:
        return Int(botlib_export!.ai.runBotAllocWeaponState())

    case BOTLIB_AI_FREE_WEAPON_STATE:
        botlib_export!.ai.runBotFreeWeaponState(args[1])
        return 0

    case BOTLIB_AI_RESET_WEAPON_STATE:
        botlib_export!.ai.runBotResetWeaponState(args[1])
        return 0

    case BOTLIB_AI_GENETIC_PARENTS_AND_CHILD_SELECTION:
        return Int(botlib_export!.ai.runGeneticParentsAndChildSelection(args[1], args.VMA(2), args.VMA(3), args.VMA(4), args.VMA(5)))

    case G_R_REGISTERSKIN:
        return Int(RE_RegisterServerSkin(args.VMA(1)))

    case G_G2_CLEARATTACHEDINSTANCE:
        G2API_ClearAttachedInstance(args[1])
        return 0

    case G_G2_CLEANENTATTACHMENTS:
        G2API_CleanEntAttachments()
        return 0

    case G_G2_OVERRIDESERVER:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!
        return (G2API_OverrideServerWithClientData(g2[0]) ? 1 : 0)

    case G_G2_GETSURFACENAME:
        do { //Since returning a pointer in such a way to a VM seems to cause MASSIVE FAILURE<tm>, we will shove data into the pointer the vm passes instead
            let modelindex = args[3]

            let g2 = ghoul2Instances.instance(word: args.VMA(1))!

            let local = G2API_GetSurfaceName(g2[modelindex], args[2])
            // Raven tests `local` for NULL. The Swift function returns a String, so the copy always runs.
            // AI: Raven copies the text into the module's buffer with strcpy. The arm copies the bytes of the text and its NUL into the module's bytes.
            Com_Memcpy(args.VMA(4), CharBuf(local), strlen(local) + 1)
        }


        return 0

    // AI: Raven reads `args[x]` of the Ghoul2 arms below as the address of a `CGhoul2Info_v`.
    // Each arm takes the instance that the whole word names in `ghoul2Instances`, and a `CGhoul2Info_v **` arm writes the word of the result back, row Z6 of docket 10.
    case G_G2_LISTBONES:
        // Port-note: Row Z6. Raven reads the module's word as the address of one `CGhoul2Info`, and the word names a `CGhoul2Info_v`.
        // No game file calls the trap.
        // Raven wrote: G2API_ListBones( (CGhoul2Info *) VMA(1), args[2]);
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:1316")

    case G_G2_LISTSURFACES:
        // Port-note: Row Z6. Raven reads the module's word as the address of one `CGhoul2Info`, and the word names a `CGhoul2Info_v`.
        // No game file calls the trap.
        // Raven wrote: G2API_ListSurfaces( (CGhoul2Info *) args[1] );
        portMissing("SV_GameSystemCalls", source: "oracle/codemp/server/sv_game.cpp:1320")

    case G_G2_HAVEWEGHOULMODELS:
        return (G2API_HaveWeGhoul2Models(ghoul2Instances.instance(word: args.VMA(1))!) ? 1 : 0)

    case G_G2_SETMODELS:
        G2API_SetGhoul2ModelIndexes(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), args.VMA(3))
        return 0

    case G_G2_GETBOLT:
        let matrix: MdxaBone? = args.VMA(4)
        return (G2API_GetBoltMatrix(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args[3], matrix!, args.VMA(5), args.VMA(6), args[7], args.VMA(8), args.VMA(9)) ? 1 : 0)

    case G_G2_GETBOLT_NOREC:
        gG2_GBMNoReconstruct = true
        let matrix: MdxaBone? = args.VMA(4)
        return (G2API_GetBoltMatrix(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args[3], matrix!, args.VMA(5), args.VMA(6), args[7], args.VMA(8), args.VMA(9)) ? 1 : 0)

    case G_G2_GETBOLT_NOREC_NOROT:
        gG2_GBMNoReconstruct = true
        gG2_GBMUseSPMethod = true
        let matrix: MdxaBone? = args.VMA(4)
        return (G2API_GetBoltMatrix(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args[3], matrix!, args.VMA(5), args.VMA(6), args[7], args.VMA(8), args.VMA(9)) ? 1 : 0)

    case G_G2_INITGHOUL2MODEL:
        let ghoul2Ptr: Slots<OpaquePointer?> = args.VMA(1)
        var ghoul2: CGhoul2Info_v? = ghoul2Instances.instance(word: ghoul2Ptr[0])
        let r = G2API_InitGhoul2Model(&ghoul2, args.VMA(2), args[3], args[4],
                                      args[5], args[6], args[7])
        ghoul2Ptr[0] = ghoul2Instances.word(of: ghoul2)
        return Int(r)

    case G_G2_SETSKIN:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!
        let modelIndex = args[2]

        return (G2API_SetSkin(g2[modelIndex], args[3], args[4]) ? 1 : 0)

    case G_G2_SIZE:
        return Int(G2API_Ghoul2Size(ghoul2Instances.instance(word: args.VMA(1))!))

    case G_G2_ADDBOLT:
        return Int(G2API_AddBolt(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args.VMA(3)))

    case G_G2_SETBOLTINFO:
        G2API_SetBoltInfo(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args[3])
        return 0

    case G_G2_ANGLEOVERRIDE:
        return (G2API_SetBoneAngles(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args.VMA(3), args.VMA(4), args[5],
                                    args[6], args[7], args[8],
                                    args.VMA(9), args[10], args[11]) ? 1 : 0)

    case G_G2_PLAYANIM:
        return (G2API_SetBoneAnim(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args.VMA(3), args[4], args[5],
                                  args[6], args.VMF(7), args[8], args.VMF(9), args[10]) ? 1 : 0)

    case G_G2_GETBONEANIM:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!
        let modelIndex = args[10]
        // AI: Raven hands the module's float and ints to the callee by address. The arm hands the slot of the Slots at each word.
        let currentFrame: Slots<Float> = args.VMA(4)
        let startFrame: Slots<Int32> = args.VMA(5)
        let endFrame: Slots<Int32> = args.VMA(6)
        let flags: Slots<Int32> = args.VMA(7)
        let animSpeed: Slots<Float> = args.VMA(8)

        return (G2API_GetBoneAnim(g2[modelIndex], args.VMA(2), args[3], &currentFrame[0], &startFrame[0],
                                  &endFrame[0], &flags[0], &animSpeed[0], args.VMA(9)) ? 1 : 0)

    case G_G2_GETGLANAME:
        //return (int)G2API_GetGLAName(*((CGhoul2Info_v *)args[1]), args[2]);
        do { //Since returning a pointer in such a way to a VM seems to cause MASSIVE FAILURE<tm>, we will shove data into the pointer the vm passes instead
            let local = G2API_GetGLAName(ghoul2Instances.instance(word: args.VMA(1))!, args[2])
            if local != nil {
                // AI: Raven copies the text into the module's buffer with strcpy. The arm copies the bytes of the text and its NUL into the module's bytes.
                Com_Memcpy(args.VMA(3), CharBuf(local!), strlen(local!) + 1)
            }
        }

        return 0

    case G_G2_COPYGHOUL2INSTANCE:
        return Int(G2API_CopyGhoul2Instance(ghoul2Instances.instance(word: args.VMA(1))!, ghoul2Instances.instance(word: args.VMA(2))!, args[3]))

    case G_G2_COPYSPECIFICGHOUL2MODEL:
        G2API_CopySpecificG2Model(ghoul2Instances.instance(word: args.VMA(1))!, args[2], ghoul2Instances.instance(word: args.VMA(3))!, args[4])
        return 0

    case G_G2_DUPLICATEGHOUL2INSTANCE:
        let g2To: Slots<OpaquePointer?> = args.VMA(2)
        var to: CGhoul2Info_v? = ghoul2Instances.instance(word: g2To[0])
        G2API_DuplicateGhoul2Instance(ghoul2Instances.instance(word: args.VMA(1))!, &to)
        g2To[0] = ghoul2Instances.word(of: to)
        return 0

    case G_G2_HASGHOUL2MODELONINDEX:
        //return (int)G2API_HasGhoul2ModelOnIndex((CGhoul2Info_v **)args[1], args[2]);
        let ghlRemove: Slots<OpaquePointer?> = args.VMA(1)
        var ghoul2: CGhoul2Info_v? = ghoul2Instances.instance(word: ghlRemove[0])
        let r = G2API_HasGhoul2ModelOnIndex(&ghoul2, args[2])
        ghlRemove[0] = ghoul2Instances.word(of: ghoul2)
        return (r ? 1 : 0)

    case G_G2_REMOVEGHOUL2MODEL:
        //return (int)G2API_RemoveGhoul2Model((CGhoul2Info_v **)args[1], args[2]);
        let ghlRemove: Slots<OpaquePointer?> = args.VMA(1)
        var ghoul2: CGhoul2Info_v? = ghoul2Instances.instance(word: ghlRemove[0])
        let r = G2API_RemoveGhoul2Model(&ghoul2, args[2])
        ghlRemove[0] = ghoul2Instances.word(of: ghoul2)
        return (r ? 1 : 0)

    case G_G2_REMOVEGHOUL2MODELS:
        //return (int)G2API_RemoveGhoul2Models((CGhoul2Info_v **)args[1]);
        let ghlRemove: Slots<OpaquePointer?> = args.VMA(1)
        var ghoul2: CGhoul2Info_v? = ghoul2Instances.instance(word: ghlRemove[0])
        let r = G2API_RemoveGhoul2Models(&ghoul2)
        ghlRemove[0] = ghoul2Instances.word(of: ghoul2)
        return (r ? 1 : 0)

    case G_G2_CLEANMODELS:
        let ghoul2Ptr: Slots<OpaquePointer?> = args.VMA(1)
        var ghoul2: CGhoul2Info_v? = ghoul2Instances.instance(word: ghoul2Ptr[0])
        G2API_CleanGhoul2Models(&ghoul2)
        ghoul2Ptr[0] = ghoul2Instances.word(of: ghoul2)
    //	G2API_CleanGhoul2Models((CGhoul2Info_v **)args[1]);
        return 0

    case G_G2_COLLISIONDETECT:
        G2API_CollisionDetect(args.VMA(1), ghoul2Instances.instance(word: args.VMA(2))!,
                              args.VMA(3),
                              args.VMA(4),
                              args[5],
                              args[6],
                              args.VMA(7),
                              args.VMA(8),
                              args.VMA(9),
                              G2VertSpaceServer,
                              args[10],
                              args[11],
                              args.VMF(12))
        return 0

    case G_G2_COLLISIONDETECTCACHE:
        G2API_CollisionDetectCache(args.VMA(1), ghoul2Instances.instance(word: args.VMA(2))!,
                                   args.VMA(3),
                                   args.VMA(4),
                                   args[5],
                                   args[6],
                                   args.VMA(7),
                                   args.VMA(8),
                                   args.VMA(9),
                                   G2VertSpaceServer,
                                   args[10],
                                   args[11],
                                   args.VMF(12))
        return 0

    case G_G2_SETROOTSURFACE:
        return (G2API_SetRootSurface(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args.VMA(3)) ? 1 : 0)

    case G_G2_SETSURFACEONOFF:
        return (G2API_SetSurfaceOnOff(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), /*(const int)VMA(3)*/args[3]) ? 1 : 0)

    case G_G2_SETNEWORIGIN:
        return (G2API_SetNewOrigin(ghoul2Instances.instance(word: args.VMA(1))!, /*(const int)VMA(2)*/args[2]) ? 1 : 0)

    case G_G2_DOESBONEEXIST:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!
        return (G2API_DoesBoneExist(g2[args[2]], args.VMA(3)) ? 1 : 0)

    case G_G2_GETSURFACERENDERSTATUS:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!

        return Int(G2API_GetSurfaceRenderStatus(g2[args[2]], args.VMA(3)))

    case G_G2_ABSURDSMOOTHING:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!

        G2API_AbsurdSmoothing(g2, args[2] != 0)
        return 0

    case G_G2_SETRAGDOLL:
        //Convert the info in the shared structure over to the class-based version.
        let rdParamst: SharedRagDollParams? = args.VMA(2)
        let rdParams = CRagDollParams()

        if rdParamst == nil {
            G2API_ResetRagDoll(ghoul2Instances.instance(word: args.VMA(1))!)
            return 0
        }

        rdParams.angles = rdParamst!.angles
        rdParams.position = rdParamst!.position
        rdParams.scale = rdParamst!.scale
        rdParams.pelvisAnglesOffset = rdParamst!.pelvisAnglesOffset
        rdParams.pelvisPositionOffset = rdParamst!.pelvisPositionOffset

        rdParams.fImpactStrength = rdParamst!.fImpactStrength
        rdParams.fShotStrength = rdParamst!.fShotStrength
        rdParams.me = rdParamst!.me

        rdParams.startFrame = rdParamst!.startFrame
        rdParams.endFrame = rdParamst!.endFrame

        rdParams.collisionType = rdParamst!.collisionType
        rdParams.CallRagDollBegin = rdParamst!.CallRagDollBegin

        rdParams.RagPhase = rdParamst!.RagPhase
        rdParams.effectorsToTurnOff = rdParamst!.effectorsToTurnOff

        G2API_SetRagDoll(ghoul2Instances.instance(word: args.VMA(1))!, rdParams)
        return 0

    case G_G2_ANIMATEG2MODELS:
        let rduParamst: SharedRagDollUpdateParams? = args.VMA(3)
        let rduParams = CRagDollUpdateParams()

        if rduParamst == nil {
            return 0
        }

        rduParams.angles = rduParamst!.angles
        rduParams.position = rduParamst!.position
        rduParams.scale = rduParamst!.scale
        rduParams.velocity = rduParamst!.velocity

        rduParams.me = rduParamst!.me
        rduParams.settleFrame = rduParamst!.settleFrame

        G2API_AnimateG2Models(ghoul2Instances.instance(word: args.VMA(1))!, args[2], rduParams)
        return 0

    //additional ragdoll options -rww
    case G_G2_RAGPCJCONSTRAINT:
        return (G2API_RagPCJConstraint(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), args.VMA(3), args.VMA(4)) ? 1 : 0)
    case G_G2_RAGPCJGRADIENTSPEED:
        return (G2API_RagPCJGradientSpeed(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), args.VMF(3)) ? 1 : 0)
    case G_G2_RAGEFFECTORGOAL:
        return (G2API_RagEffectorGoal(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), args.VMA(3)) ? 1 : 0)
    case G_G2_GETRAGBONEPOS:
        return (G2API_GetRagBonePos(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), args.VMA(3), args.VMA(4), args.VMA(5), args.VMA(6)) ? 1 : 0)
    case G_G2_RAGEFFECTORKICK:
        return (G2API_RagEffectorKick(ghoul2Instances.instance(word: args.VMA(1))!, args.VMA(2), args.VMA(3)) ? 1 : 0)
    case G_G2_RAGFORCESOLVE:
        return (G2API_RagForceSolve(ghoul2Instances.instance(word: args.VMA(1))!, args[2] != 0) ? 1 : 0)

    case G_G2_SETBONEIKSTATE:
        // AI: Raven hands the bone name as a `const char *` that the module can pass as NULL. The arm reads the text only for a word that is not NULL.
        let boneName: String? = (args.VMA(3) as OpaquePointer?) == nil ? nil : (args.VMA(3) as String)
        return (G2API_SetBoneIKState(ghoul2Instances.instance(word: args.VMA(1))!, args[2], boneName, args[4], args.VMA(5)) ? 1 : 0)
    case G_G2_IKMOVE:
        let params: SharedIKMoveParams? = args.VMA(3)
        return (G2API_IKMove(ghoul2Instances.instance(word: args.VMA(1))!, args[2], params!) ? 1 : 0)

    case G_G2_REMOVEBONE:
        let g2 = ghoul2Instances.instance(word: args.VMA(1))!

        return (G2API_RemoveBone(g2[args[3]], args.VMA(2)) ? 1 : 0)

    case G_G2_ATTACHINSTANCETOENTNUM:
        G2API_AttachInstanceToEntNum(ghoul2Instances.instance(word: args.VMA(1))!, args[2], args[3] != 0)
        return 0

    case G_SET_ACTIVE_SUBBSP:
        SV_SetActiveSubBSP(args[1])
        return 0

    case G_RMG_INIT:
        if com_RMG != nil && com_RMG!.integer != 0 {
            if TheRandomMissionManager == nil {
                TheRandomMissionManager = CRMManager()
            }
            // AI: Raven reads the class pointer `cmg.landScape` of the C record. The world holds the Swift class as `landScape_cmg`, the C field stays unused.
            TheRandomMissionManager!.SetLandScape(landScape_cmg)
            if TheRandomMissionManager!.LoadMission(true) {
                TheRandomMissionManager!.SpawnMission(true)
            }
//			cmg.landScape->UpdatePatches();
        }
        return 0

    case G_CM_REGISTER_TERRAIN:
        return Int(CM_RegisterTerrain(args.VMA(1), true)!.GetTerrainId())

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
    return -1
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
    // AI: Raven passes SV_GameSystemCalls. The call passes the C thunk over it that the view target holds, because VM_Create stores a C function.
    gvm = VM_Create("jampgame", SV_GameSystemCallThunk, Int32(Cvar_VariableValue("vm_game")))
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
