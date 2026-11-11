import Foundation
import CJKAHost
import JKAShared
import JKAMP_Ded
import JKAMP_DedLogic

// The entry point of the dedicated server, Raven's WinDed binary.
// It builds the world, installs the shared channel, and runs Raven's main: the command line, Com_Init, and the frame loop.

/**
==================
WinMain

==================
*/
/// Source: oracle/codemp/null/win_main.cpp:1410
world = EngineWorld()
// The host installs the shared channel here, in the shape of the cgame's dllEntry.
sharedChannel.error = { level, text in JKAMP_DedLogic.Com_Error(level, text) }
sharedChannel.print = { text in JKAMP_DedLogic.Com_Printf(text) }
// The host installs the module loader of Sys_LoadDll here, over jka_load_library and jka_dll_entry of CJKAHost, which the logic target cannot import.
LoadLibrary = { path in
    jka_load_library(path).map { OpaquePointer($0) }
}
GetProcAddress = { libHandle, entryPoint in
    jka_dll_entry(UnsafeMutableRawPointer(libHandle), entryPoint.assumingMemoryBound(to: jka_vmmain_fn?.self)) != 0
}
// The host installs SV_GameSystemCalls here for the thunk of the view target, which cannot see the logic target.
GameSystemCalls = SV_GameSystemCalls
// The host installs the callee of VM_DllSyscall of CJKAHost here, Raven's `currentVM->systemCall( args )` at oracle/codemp/qcommon/vm.cpp:376.
// AI: Raven calls the systemCall of currentVM. The dedicated host loads one module, the game, so the callee is SV_GameSystemCalls.
// AI: Raven's callee returns an `int`. The callee gives the whole word to the module, so an address stays whole on a 64-bit host.
jka_systemCall = { parms in GameSystemCalls!(Slots(syscallWords: UnsafeMutableRawPointer(mutating: parms!), count: 16)) }

// merge the command line, this is kinda silly
var cmdline = CharBuf(CommandLine.arguments.dropFirst().joined(separator: " "))

// no abort/retry/fail errors
// AI: Raven called the Win32 SetErrorMode( SEM_FAILCRITICALERRORS ) here. The other platforms have no such mode, so the shell makes no call.

// get the initial time base
Sys_Milliseconds()

Sys_InitStreamThread()

Com_Init(&cmdline)

NET_Init()

// JKAShared declares a Com_Printf too, so the qualifier picks the engine's.
JKAMP_DedLogic.Com_Printf("Working directory: %s\n", FileManager.default.currentDirectoryPath)

// hide the early console since we've reached the point where we
// have a working graphics subsystems
if com_dedicated!.integer == 0 && com_viewlog!.integer == 0 {
    Sys_ShowConsole(0, false)
}

// main game loop
while true {
    // if not running as a game client, sleep a bit
    usleep(5_000)

    // make sure mouse and joystick are only called once a frame
    IN_Frame()

    // run the game
    Com_Frame()
}
