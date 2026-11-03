import JKAShared
import JKAMP
import JKAMP_CGame
import JKAMP_CGameLogic
import JKAMP_BG

/// This target holds the cgame module's two ABI entry points, `dllEntry` and `vmMain`, and the 32-arm command decode.
/// It is the dynamic library the engine loads.
/// Each arm decodes the words into typed arguments, calls the bare function, and encodes the return, rule 11.

/// Source: oracle/codemp/cgame/cg_syscalls.c:10
@_cdecl("dllEntry")
public func dllEntry(_ syscallptr: OpaquePointer) {
    Syscall.transport = EngineTransport(entry: syscallptr)
    // AI: Raven relied on the engine reload of the image to zero every static at a map load. The image stays resident here, so a fresh world gives the same result.
    world = CGameWorld()
    // The cgame installs the bg channel here, rule 23, with Raven's `MAX_POOL_SIZE` of 2048000 for the cgame at oracle/codemp/game/bg_misc.c:3314.
    bg = BgState(consumer: .cgame, maxPoolSize: 2_048_000)
    bg.error = { level, text in JKAMP_CGameLogic.Com_Error(level, text) }
    bg.print = { text in JKAMP_CGameLogic.Com_Printf(text) }
    installBgChannel()
    // The cgame installs the shared channel here too, in the same shape.
    sharedChannel.error = { level, text in JKAMP_CGameLogic.Com_Error(level, text) }
    sharedChannel.print = { text in JKAMP_CGameLogic.Com_Printf(text) }
}

/// Source: oracle/codemp/cgame/cg_main.c:190
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
    case CG_INIT:
        CG_Init(int32(arg0), int32(arg1), int32(arg2))
        return 0

    case CG_SHUTDOWN:
        CG_Shutdown()
        return 0

    case CG_CONSOLE_COMMAND:
        return CG_ConsoleCommand() ? 1 : 0

    case CG_DRAW_ACTIVE_FRAME:
        CG_DrawActiveFrame(int32(arg0), int32(arg1), arg2 != 0)
        return 0

    case CG_CROSSHAIR_PLAYER:
        return Int(CG_CrosshairPlayer())

    case CG_LAST_ATTACKER:
        return Int(CG_LastAttacker())

    case CG_KEY_EVENT:
        CG_KeyEvent(int32(arg0), arg1 != 0)
        return 0

    case CG_MOUSE_EVENT:
        cgDC.cursorx = cgs.cursorX
        cgDC.cursory = cgs.cursorY
        CG_MouseEvent(int32(arg0), int32(arg1))
        return 0

    case CG_EVENT_HANDLING:
        CG_EventHandling(int32(arg0))
        return 0

    case CG_POINT_CONTENTS:
        return Int(C_PointContents())

    case CG_GET_LERP_ORIGIN:
        C_GetLerpOrigin()
        return 0

    case CG_GET_LERP_DATA:
        C_GetLerpData()
        return 0

    // NOTE: This is used by the effect bolting which is actually not used at all.
    // I'm fairly sure if you try to use it with vm's it will just give you total garbage.
    // In other words, use at your own risk.
    case CG_GET_GHOUL2:
        return Int(bitPattern: cg_entities[arg0].ghoul2)

    case CG_GET_MODEL_LIST:
        return Int(bitPattern: cgs.gameModels.base)

    case CG_CALC_LERP_POSITIONS:
        CG_CalcEntityLerpPositions(cg_entities[arg0])
        return 0

    case CG_TRACE:
        C_Trace()
        return 0

    case CG_GET_SORTED_FORCE_POWER:
        return Int(forcePowerSorted[arg0])

    case CG_G2TRACE:
        C_G2Trace()
        return 0

    case CG_G2MARK:
        C_G2Mark()
        return 0

    case CG_RAG_CALLBACK:
        return Int(CG_RagCallback(int32(arg0)))

    // rww - let mod authors filter client console messages so they can cut them off if they want.
    // return 1 if the command is ok. Otherwise, you can set char 0 on the command str to 0 and return 0 to not execute anything,
    // or you can fill conCommand in with something valid and return 0 in order to have that string executed in place.
    // Raven's example code stands under `#if 0` at cg_main.c:264-279.
    case CG_INCOMING_CONSOLE_COMMAND:
        return 1

    case CG_GET_USEABLE_FORCE:
        return CG_NoUseableForce() ? 1 : 0

    // The engine passes the out vector as a `float *` word.
    case CG_GET_ORIGIN:
        Slots(vectors: UnsafeMutableRawPointer(bitPattern: arg1)!, count: 1)[0] = cg_entities[arg0].currentState.pos.trBase
        return 0

    case CG_GET_ANGLES:
        Slots(vectors: UnsafeMutableRawPointer(bitPattern: arg1)!, count: 1)[0] = cg_entities[arg0].currentState.apos.trBase
        return 0

    case CG_GET_ORIGIN_TRAJECTORY:
        return Int(bitPattern: cg_entities[arg0].nextState.pos.handle)

    case CG_GET_ANGLE_TRAJECTORY:
        return Int(bitPattern: cg_entities[arg0].nextState.apos.handle)

    case CG_ROFF_NOTETRACK_CALLBACK:
        CG_ROFF_NotetrackCallback(cg_entities[arg0], text(at: arg1))
        return 0

    case CG_IMPACT_MARK:
        C_ImpactMark()
        return 0

    // this trap map be called more than once for a given map change, as the
    // server is going to attempt to send out multiple broadcasts in hopes that
    // the client will receive one of them
    case CG_MAP_CHANGE:
        cg.mMapChange = true
        return 0

    // special input during automap mode -rww
    case CG_AUTOMAP_INPUT:
        let autoInput = AutoMapInput(cg.sharedBuffer)

        cg_autoMapInput.copy(from: autoInput)

        if arg0 == 0 {
            // if this is non-0, it's actually a one-frame mouse event
            cg_autoMapInputTime = cg.time + 1000
        } else {
            if cg_autoMapInput.yaw != 0 {
                cg_autoMapAngle[YAW] += cg_autoMapInput.yaw
            }

            if cg_autoMapInput.pitch != 0 {
                cg_autoMapAngle[PITCH] += cg_autoMapInput.pitch
            }
            cg_autoMapInput.yaw = 0.0
            cg_autoMapInput.pitch = 0.0
        }
        return 0

    case CG_MISC_ENT:
        CG_MiscEnt()
        return 0

    case CG_FX_CAMERASHAKE:
        let data = CGCameraShake(cg.sharedBuffer)

        CG_DoCameraShake(data.mOrigin, data.mIntensity, data.mRadius, data.mTime)
        return 0

    default:
        CG_Error("vmMain: unknown command %i", int32(command))
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
