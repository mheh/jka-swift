import JKAShared
import JKAMP_Game
import JKAMP_GameLogic
import JKAMP_BG

/// This target holds the module's two ABI entry points, `dllEntry` and `vmMain`, and the 40-arm command decode.
/// It is the dynamic library the engine loads.
/// Each arm decodes the words into typed arguments, calls the bare function, and encodes the return, rule 11.

/// Source: oracle/codemp/game/g_syscalls.c:14
@_cdecl("dllEntry")
public func dllEntry(_ syscallptr: OpaquePointer) {
    Syscall.transport = EngineTransport(entry: syscallptr)
    // AI: Raven relied on the engine reload of the image to zero every static at a map load. The image stays resident here, so a fresh world gives the same result.
    world = GameWorld()
    // The game installs the bg channel here, rule 23, with Raven's `MAX_POOL_SIZE` of 3000000 for the game at oracle/codemp/game/bg_misc.c:3312.
    bg = BgState(consumer: .game, maxPoolSize: 3_000_000)
    bg.error = { level, text in JKAMP_GameLogic.Com_Error(level, text) }
    bg.print = { text in JKAMP_GameLogic.Com_Printf(text) }
    installBgChannel()
    // The game installs the shared channel here too, in the same shape.
    sharedChannel.error = { level, text in JKAMP_GameLogic.Com_Error(level, text) }
    sharedChannel.print = { text in JKAMP_GameLogic.Com_Printf(text) }
}

/// Source: oracle/codemp/game/g_main.c:515
@_cdecl("vmMain")
public func vmMain(
    _ command: Int,
    _ arg0: Int,
    _ arg1: Int,
    _ arg2: Int,
    _ arg3: Int,
    _ arg4: Int,
    _ arg5: Int,
    _ arg6: Int,
    _ arg7: Int,
    _ arg8: Int,
    _ arg9: Int,
    _ arg10: Int,
    _ arg11: Int
) -> Int {
    switch Int32(truncatingIfNeeded: command) {
    case GAME_INIT:
        G_InitGame(int32(arg0), int32(arg1), int32(arg2))
        return 0

    case GAME_SHUTDOWN:
        G_ShutdownGame(int32(arg0))
        return 0

    // The engine reads the denial text through the pointer, so the text goes through the string pool.
    case GAME_CLIENT_CONNECT:
        let denial = ClientConnect(int32(arg0), arg1 != 0, arg2 != 0)
        return Int(bitPattern: StringPool.shared.pointer(for: denial))

    case GAME_CLIENT_THINK:
        ClientThink(int32(arg0), nil)
        return 0

    case GAME_CLIENT_USERINFO_CHANGED:
        ClientUserinfoChanged(int32(arg0))
        return 0

    case GAME_CLIENT_DISCONNECT:
        ClientDisconnect(int32(arg0))
        return 0

    case GAME_CLIENT_BEGIN:
        ClientBegin(int32(arg0), true)
        return 0

    case GAME_CLIENT_COMMAND:
        ClientCommand(int32(arg0))
        return 0

    case GAME_RUN_FRAME:
        G_RunFrame(int32(arg0))
        return 0

    case GAME_CONSOLE_COMMAND:
        return ConsoleCommand() ? 1 : 0

    case BOTAI_START_FRAME:
        return Int(BotAIStartFrame(int32(arg0)))

    case GAME_ROFF_NOTETRACK_CALLBACK:
        G_ROFF_NotetrackCallback(g_entities[arg0], text(at: arg1))
        return 0

    case GAME_SPAWN_RMG_ENTITY:
        if G_ParseSpawnVars(false) {
            G_SpawnGEntityFromSpawnVars(false)
        }
        return 0

    // The ICARUS arms read their arguments from the shared buffer, one record type per command.
    case GAME_ICARUS_PLAYSOUND:
        let sharedMem = IcarusPlaySound(gSharedBuffer)
        return Int(Q3_PlaySound(sharedMem.taskID, sharedMem.entID, sharedMem.name, sharedMem.channel))

    case GAME_ICARUS_SET:
        let sharedMem = IcarusSet(gSharedBuffer)
        return Q3_Set(sharedMem.taskID, sharedMem.entID, sharedMem.type_name, sharedMem.data) ? 1 : 0

    case GAME_ICARUS_LERP2POS:
        let sharedMem = IcarusLerp2Pos(gSharedBuffer)
        let angles: vec3_t? = sharedMem.nullAngles ? nil : sharedMem.angles
        Q3_Lerp2Pos(sharedMem.taskID, sharedMem.entID, sharedMem.origin, angles, sharedMem.duration)
        return 0

    case GAME_ICARUS_LERP2ORIGIN:
        let sharedMem = IcarusLerp2Origin(gSharedBuffer)
        Q3_Lerp2Origin(sharedMem.taskID, sharedMem.entID, sharedMem.origin, sharedMem.duration)
        return 0

    case GAME_ICARUS_LERP2ANGLES:
        let sharedMem = IcarusLerp2Angles(gSharedBuffer)
        Q3_Lerp2Angles(sharedMem.taskID, sharedMem.entID, sharedMem.angles, sharedMem.duration)
        return 0

    case GAME_ICARUS_GETTAG:
        let sharedMem = IcarusGetTag(gSharedBuffer)
        return Int(Q3_GetTag(sharedMem.entID, sharedMem.name, sharedMem.lookup, &sharedMem.info))

    case GAME_ICARUS_LERP2START:
        let sharedMem = IcarusLerp2Start(gSharedBuffer)
        Q3_Lerp2Start(sharedMem.entID, sharedMem.taskID, sharedMem.duration)
        return 0

    case GAME_ICARUS_LERP2END:
        let sharedMem = IcarusLerp2End(gSharedBuffer)
        Q3_Lerp2End(sharedMem.entID, sharedMem.taskID, sharedMem.duration)
        return 0

    case GAME_ICARUS_USE:
        let sharedMem = IcarusUse(gSharedBuffer)
        Q3_Use(sharedMem.entID, sharedMem.target)
        return 0

    case GAME_ICARUS_KILL:
        let sharedMem = IcarusKill(gSharedBuffer)
        Q3_Kill(sharedMem.entID, sharedMem.name)
        return 0

    case GAME_ICARUS_REMOVE:
        let sharedMem = IcarusRemove(gSharedBuffer)
        Q3_Remove(sharedMem.entID, sharedMem.name)
        return 0

    case GAME_ICARUS_PLAY:
        let sharedMem = IcarusPlay(gSharedBuffer)
        Q3_Play(sharedMem.taskID, sharedMem.entID, sharedMem.type, sharedMem.name)
        return 0

    case GAME_ICARUS_GETFLOAT:
        let sharedMem = IcarusGetFloat(gSharedBuffer)
        return Int(Q3_GetFloat(sharedMem.entID, sharedMem.type, sharedMem.name, &sharedMem.value))

    case GAME_ICARUS_GETVECTOR:
        let sharedMem = IcarusGetVector(gSharedBuffer)
        return Int(Q3_GetVector(sharedMem.entID, sharedMem.type, sharedMem.name, &sharedMem.value))

    // Raven copies the text into the buffer only when the call sets it.
    // The value starts as the buffer's own text, so a call that sets nothing writes the same text back.
    case GAME_ICARUS_GETSTRING:
        let sharedMem = IcarusGetString(gSharedBuffer)
        var value = sharedMem.value
        let r = Q3_GetString(sharedMem.entID, sharedMem.type, sharedMem.name, &value)
        sharedMem.value = value
        return Int(r)

    case GAME_ICARUS_SOUNDINDEX:
        let sharedMem = IcarusSoundIndex(gSharedBuffer)
        _ = G_SoundIndex(sharedMem.filename)
        return 0

    case GAME_ICARUS_GETSETIDFORSTRING:
        let sharedMem = IcarusGetSetIDForString(gSharedBuffer)
        return Int(GetIDForString(setTable, sharedMem.string))

    // The navigation arms receive vectors as `float *` words.
    case GAME_NAV_CLEARPATHTOPOINT:
        let clear = NAV_ClearPathToPoint(
            g_entities[arg0],
            vector(at: arg1),
            vector(at: arg2),
            vector(at: arg3),
            int32(arg4),
            int32(arg5)
        )
        return clear ? 1 : 0

    case GAME_NAV_CLEARLOS:
        return NPC_ClearLOS2(g_entities[arg0], vector(at: arg1)) ? 1 : 0

    case GAME_NAV_CLEARPATHBETWEENPOINTS:
        let trace = NAVNEW_ClearPathBetweenPoints(
            vector(at: arg0),
            vector(at: arg1),
            vector(at: arg2),
            vector(at: arg3),
            int32(arg4),
            int32(arg5)
        )
        return Int(trace)

    case GAME_NAV_CHECKNODEFAILEDFORENT:
        return NAV_CheckNodeFailedForEnt(g_entities[arg0], int32(arg1)) ? 1 : 0

    case GAME_NAV_ENTISUNLOCKEDDOOR:
        return G_EntIsUnlockedDoor(int32(arg0)) ? 1 : 0

    case GAME_NAV_ENTISDOOR:
        return G_EntIsDoor(int32(arg0)) ? 1 : 0

    case GAME_NAV_ENTISBREAKABLE:
        return G_EntIsBreakable(int32(arg0)) ? 1 : 0

    case GAME_NAV_ENTISREMOVABLEUSABLE:
        return G_EntIsRemovableUsable(int32(arg0)) ? 1 : 0

    case GAME_NAV_FINDCOMBATPOINTWAYPOINTS:
        CP_FindCombatPointWaypoints()
        return 0

    case GAME_GETITEMINDEXBYTAG:
        return Int(BG_GetItemIndexByTag(int32(arg0), int32(arg1)))

    // The wire enum is a struct with statics, so Swift needs this arm. It is Raven's fall-through return at g_main.c:695.
    default:
        return -1
    }
}

// MARK: - The decode of a word

/// This reads a word as Raven's `int` argument.
private func int32(_ word: Int) -> Int32 {
    Int32(truncatingIfNeeded: word)
}

/// This reads the text at a word the engine passes as a `const char *`.
private func text(at word: Int) -> String {
    cString(at: UnsafeMutableRawPointer(bitPattern: word)!)
}

/// This reads the three floats at a word the engine passes as a `float *`.
private func vector(at word: Int) -> vec3_t {
    Slots(vectors: UnsafeMutableRawPointer(bitPattern: word)!, count: 1)[0]
}
