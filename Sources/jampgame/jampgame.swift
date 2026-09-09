import JKAShared
import JKAMP_Game
import JKAMP_GameLogic

/// This target holds the module's two ABI entry points, `dllEntry` and `vmMain`, and the 40-arm command decode.
/// It is the dynamic library the engine loads.
/// Only `GAME_INIT` is answered today, and every other arm traps with its Raven subject.

/// Source: oracle/codemp/game/g_syscalls.c:14
@_cdecl("dllEntry")
public func dllEntry(_ syscallptr: OpaquePointer) {
    Syscall.transport = EngineTransport(entry: syscallptr)
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
    switch gameExport_t(rawValue: Int32(truncatingIfNeeded: command)) {
    case .GAME_INIT:
        trap_Printf("jka-swift jampgame init\n")
        return 0

    case .GAME_SHUTDOWN:
        // TODO: Port G_ShutdownGame
        portMissing("G_ShutdownGame", source: "oracle/codemp/game/g_main.c:520")

    case .GAME_CLIENT_CONNECT:
        // TODO: Port ClientConnect
        portMissing("ClientConnect", source: "oracle/codemp/game/g_main.c:523")

    case .GAME_CLIENT_THINK:
        // TODO: Port ClientThink
        portMissing("ClientThink", source: "oracle/codemp/game/g_main.c:525")

    case .GAME_CLIENT_USERINFO_CHANGED:
        // TODO: Port ClientUserinfoChanged
        portMissing("ClientUserinfoChanged", source: "oracle/codemp/game/g_main.c:528")

    case .GAME_CLIENT_DISCONNECT:
        // TODO: Port ClientDisconnect
        portMissing("ClientDisconnect", source: "oracle/codemp/game/g_main.c:531")

    case .GAME_CLIENT_BEGIN:
        // TODO: Port ClientBegin
        portMissing("ClientBegin", source: "oracle/codemp/game/g_main.c:534")

    case .GAME_CLIENT_COMMAND:
        // TODO: Port ClientCommand
        portMissing("ClientCommand", source: "oracle/codemp/game/g_main.c:537")

    case .GAME_RUN_FRAME:
        // TODO: Port G_RunFrame
        portMissing("G_RunFrame", source: "oracle/codemp/game/g_main.c:540")

    case .GAME_CONSOLE_COMMAND:
        // TODO: Port ConsoleCommand
        portMissing("ConsoleCommand", source: "oracle/codemp/game/g_main.c:543")

    case .BOTAI_START_FRAME:
        // TODO: Port BotAIStartFrame
        portMissing("BotAIStartFrame", source: "oracle/codemp/game/g_main.c:545")

    case .GAME_ROFF_NOTETRACK_CALLBACK:
        // TODO: Port G_ROFF_NotetrackCallback
        portMissing("G_ROFF_NotetrackCallback", source: "oracle/codemp/game/g_main.c:547")

    case .GAME_SPAWN_RMG_ENTITY:
        // TODO: Port G_ParseSpawnVars
        portMissing("G_ParseSpawnVars", source: "oracle/codemp/game/g_main.c:550")

    case .GAME_ICARUS_PLAYSOUND:
        // TODO: Port Q3_PlaySound
        portMissing("Q3_PlaySound", source: "oracle/codemp/game/g_main.c:558")

    case .GAME_ICARUS_SET:
        // TODO: Port Q3_Set
        portMissing("Q3_Set", source: "oracle/codemp/game/g_main.c:563")

    case .GAME_ICARUS_LERP2POS:
        // TODO: Port Q3_Lerp2Pos
        portMissing("Q3_Lerp2Pos", source: "oracle/codemp/game/g_main.c:568")

    case .GAME_ICARUS_LERP2ORIGIN:
        // TODO: Port Q3_Lerp2Origin
        portMissing("Q3_Lerp2Origin", source: "oracle/codemp/game/g_main.c:581")

    case .GAME_ICARUS_LERP2ANGLES:
        // TODO: Port Q3_Lerp2Angles
        portMissing("Q3_Lerp2Angles", source: "oracle/codemp/game/g_main.c:587")

    case .GAME_ICARUS_GETTAG:
        // TODO: Port Q3_GetTag
        portMissing("Q3_GetTag", source: "oracle/codemp/game/g_main.c:593")

    case .GAME_ICARUS_LERP2START:
        // TODO: Port Q3_Lerp2Start
        portMissing("Q3_Lerp2Start", source: "oracle/codemp/game/g_main.c:598")

    case .GAME_ICARUS_LERP2END:
        // TODO: Port Q3_Lerp2End
        portMissing("Q3_Lerp2End", source: "oracle/codemp/game/g_main.c:604")

    case .GAME_ICARUS_USE:
        // TODO: Port Q3_Use
        portMissing("Q3_Use", source: "oracle/codemp/game/g_main.c:610")

    case .GAME_ICARUS_KILL:
        // TODO: Port Q3_Kill
        portMissing("Q3_Kill", source: "oracle/codemp/game/g_main.c:616")

    case .GAME_ICARUS_REMOVE:
        // TODO: Port Q3_Remove
        portMissing("Q3_Remove", source: "oracle/codemp/game/g_main.c:622")

    case .GAME_ICARUS_PLAY:
        // TODO: Port Q3_Play
        portMissing("Q3_Play", source: "oracle/codemp/game/g_main.c:628")

    case .GAME_ICARUS_GETFLOAT:
        // TODO: Port Q3_GetFloat
        portMissing("Q3_GetFloat", source: "oracle/codemp/game/g_main.c:634")

    case .GAME_ICARUS_GETVECTOR:
        // TODO: Port Q3_GetVector
        portMissing("Q3_GetVector", source: "oracle/codemp/game/g_main.c:639")

    case .GAME_ICARUS_GETSTRING:
        // TODO: Port Q3_GetString
        portMissing("Q3_GetString", source: "oracle/codemp/game/g_main.c:644")

    case .GAME_ICARUS_SOUNDINDEX:
        // TODO: Port G_SoundIndex
        portMissing("G_SoundIndex", source: "oracle/codemp/game/g_main.c:659")

    case .GAME_ICARUS_GETSETIDFORSTRING:
        // TODO: Port GetIDForString
        portMissing("GetIDForString", source: "oracle/codemp/game/g_main.c:665")

    case .GAME_NAV_CLEARPATHTOPOINT:
        // TODO: Port NAV_ClearPathToPoint
        portMissing("NAV_ClearPathToPoint", source: "oracle/codemp/game/g_main.c:672")

    case .GAME_NAV_CLEARLOS:
        // TODO: Port NPC_ClearLOS2
        portMissing("NPC_ClearLOS2", source: "oracle/codemp/game/g_main.c:674")

    case .GAME_NAV_CLEARPATHBETWEENPOINTS:
        // TODO: Port NAVNEW_ClearPathBetweenPoints
        portMissing("NAVNEW_ClearPathBetweenPoints", source: "oracle/codemp/game/g_main.c:676")

    case .GAME_NAV_CHECKNODEFAILEDFORENT:
        // TODO: Port NAV_CheckNodeFailedForEnt
        portMissing("NAV_CheckNodeFailedForEnt", source: "oracle/codemp/game/g_main.c:678")

    case .GAME_NAV_ENTISUNLOCKEDDOOR:
        // TODO: Port G_EntIsUnlockedDoor
        portMissing("G_EntIsUnlockedDoor", source: "oracle/codemp/game/g_main.c:680")

    case .GAME_NAV_ENTISDOOR:
        // TODO: Port G_EntIsDoor
        portMissing("G_EntIsDoor", source: "oracle/codemp/game/g_main.c:682")

    case .GAME_NAV_ENTISBREAKABLE:
        // TODO: Port G_EntIsBreakable
        portMissing("G_EntIsBreakable", source: "oracle/codemp/game/g_main.c:684")

    case .GAME_NAV_ENTISREMOVABLEUSABLE:
        // TODO: Port G_EntIsRemovableUsable
        portMissing("G_EntIsRemovableUsable", source: "oracle/codemp/game/g_main.c:686")

    case .GAME_NAV_FINDCOMBATPOINTWAYPOINTS:
        // TODO: Port CP_FindCombatPointWaypoints
        portMissing("CP_FindCombatPointWaypoints", source: "oracle/codemp/game/g_main.c:688")

    case .GAME_GETITEMINDEXBYTAG:
        // TODO: Port BG_GetItemIndexByTag
        portMissing("BG_GetItemIndexByTag", source: "oracle/codemp/game/g_main.c:691")

    // The wire enum is a struct with statics, so Swift needs this arm. It is Raven's fall-through return at g_main.c:695.
    default:
        return -1
    }
}
