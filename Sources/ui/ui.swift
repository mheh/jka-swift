import JKAShared
import JKAMP
import JKAMP_UI
import JKAMP_UILogic
import JKAMP_BG

/// This target holds the ui module's two ABI entry points, `dllEntry` and `vmMain`, and the 13-arm command decode.
/// It is the dynamic library the engine loads.
/// Each arm decodes the words into typed arguments, calls the bare function, and encodes the return, rule 11.

/// Source: oracle/codemp/ui/ui_syscalls.c:11
@_cdecl("dllEntry")
public func dllEntry(_ syscallptr: OpaquePointer) {
    Syscall.transport = EngineTransport(entry: syscallptr)
    // AI: Raven relied on the engine reload of the image to zero every static at a map load. The image stays resident here, so a fresh world gives the same result.
    world = UIWorld()
    // The ui installs the bg channel here, rule 23, with Raven's `MAX_POOL_SIZE` of 512000 for the ui at oracle/codemp/game/bg_misc.c:3316.
    bg = BgState(consumer: .ui, maxPoolSize: 512_000)
    bg.error = { level, text in JKAMP_UILogic.Com_Error(level, text) }
    bg.print = { text in JKAMP_UILogic.Com_Printf(text) }
    installBgChannel()
    // The ui installs the shared channel here too, in the same shape.
    sharedChannel.error = { level, text in JKAMP_UILogic.Com_Error(level, text) }
    sharedChannel.print = { text in JKAMP_UILogic.Com_Printf(text) }
}

/// Source: oracle/codemp/ui/ui_main.c:579
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
    case UI_GETAPIVERSION:
        return Int(UI_API_VERSION)

    case UI_INIT:
        _UI_Init(arg0 != 0)
        return 0

    case UI_SHUTDOWN:
        _UI_Shutdown()
        return 0

    case UI_KEY_EVENT:
        _UI_KeyEvent(int32(arg0), arg1 != 0)
        return 0

    case UI_MOUSE_EVENT:
        _UI_MouseEvent(int32(arg0), int32(arg1))
        return 0

    case UI_REFRESH:
        _UI_Refresh(int32(arg0))
        return 0

    case UI_IS_FULLSCREEN:
        return _UI_IsFullscreen() ? 1 : 0

    case UI_SET_ACTIVE_MENU:
        _UI_SetActiveMenu(int32(arg0))
        return 0

    case UI_CONSOLE_COMMAND:
        return UI_ConsoleCommand(int32(arg0)) ? 1 : 0

    case UI_DRAW_CONNECT_SCREEN:
        UI_DrawConnectScreen(arg0 != 0)
        return 0

    case UI_HASUNIQUECDKEY: // mod authors need to observe this
        return 1 // bk010117 - change this to qfalse for mods!

    case UI_MENU_RESET:
        Menu_Reset()
        return 0

    default:
        return -1
    }
}

// MARK: - The decode of a word

/// This reads a word as Raven's `int` argument.
private func int32(_ word: Int) -> Int32 {
    Int32(truncatingIfNeeded: word)
}
