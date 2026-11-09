import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/common.cpp:18
private let MAXPRINTMSG = 4096 as Int32

/// Source: oracle/codemp/qcommon/common.cpp:20
let MAX_NUM_ARGVS = 50 as Int32

/// Source: oracle/codemp/qcommon/common.cpp:22
// Raven wrote: int com_argc
let com_argc: Int32 = 0

/// Source: oracle/codemp/qcommon/common.cpp:23
// Raven wrote: char *com_argv[MAX_NUM_ARGVS+1]
let com_argv: [String] = [String](repeating: "", count: 51)

/// Raven's version text, from the arm of a build without FINAL_BUILD and _DEBUG, as WinDed Release is.
/// Source: oracle/codemp/qcommon/game_version.h:11, with VERSION_STRING_DOTTED from oracle/codemp/win32/AutoVersion.h:10
// AI: Raven reads the macro from game_version.h. The re-export of the host target has no such constant, so the stem holds the text.
let Q3_VERSION = "(internal)JAmp: v1.0.1.0"

#if os(macOS)
/// The platform name of the version line.
/// Source: oracle/codemp/game/q_shared.h:197
// AI: Raven reads the macro from q_shared.h. The re-export of the host target has no such constant, so the stem holds the text.
let CPUSTRING = "MacOSX-other"
#elseif os(Linux)
/// The platform name of the version line.
/// Source: oracle/codemp/game/q_shared.h:276
// AI: Raven reads the macro from q_shared.h. The re-export of the host target has no such constant, so the stem holds the text.
let CPUSTRING = "linux-other"
#else
/// The platform name of the version line.
/// Source: oracle/codemp/game/q_shared.h:157
// Port-note: Raven defined no CPUSTRING for a 64-bit Windows build, so the build failed there.
// This is the value of Raven's x86 arm.
let CPUSTRING = "win-x86"
#endif

/// Raven's `__DATE__`, which is `unknown` because Swift has no compile-time date.
let buildDate = "unknown"

/// Source: oracle/codemp/qcommon/common.cpp:32
// TODO: Port global debuglogfile
// Raven wrote: FILE *debuglogfile
// No table row for `FILE *`.
// Raven never reads or writes it, so it is dead under rule 20.

/// Source: oracle/codemp/qcommon/common.cpp:33
var logfile: JKAShared.fileHandle_t {
    get { world.variables.common_logfile }
    set { world.variables.common_logfile = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:34
var com_journalFile: JKAShared.fileHandle_t {
    get { world.variables.com_journalFile }
    set { world.variables.com_journalFile = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:35
var com_journalDataFile: JKAShared.fileHandle_t {
    get { world.variables.com_journalDataFile }
    set { world.variables.com_journalDataFile = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:37
public var com_viewlog: JKAMP.Cvar? {
    get { world.variables.com_viewlog }
    set { world.variables.com_viewlog = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:38
var com_speeds: JKAMP.Cvar? {
    get { world.variables.com_speeds }
    set { world.variables.com_speeds = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:39
var com_developer: JKAMP.Cvar? {
    get { world.variables.com_developer }
    set { world.variables.com_developer = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:40
var com_vmdebug: JKAMP.Cvar? {
    get { world.variables.com_vmdebug }
    set { world.variables.com_vmdebug = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:41
public var com_dedicated: JKAMP.Cvar? {
    get { world.variables.com_dedicated }
    set { world.variables.com_dedicated = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:42
var com_timescale: JKAMP.Cvar? {
    get { world.variables.com_timescale }
    set { world.variables.com_timescale = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:43
var com_fixedtime: JKAMP.Cvar? {
    get { world.variables.com_fixedtime }
    set { world.variables.com_fixedtime = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:44
var com_dropsim: JKAMP.Cvar? {
    get { world.variables.com_dropsim }
    set { world.variables.com_dropsim = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:45
var com_journal: JKAMP.Cvar? {
    get { world.variables.com_journal }
    set { world.variables.com_journal = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:46
var com_maxfps: JKAMP.Cvar? {
    get { world.variables.com_maxfps }
    set { world.variables.com_maxfps = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:47
var com_timedemo: JKAMP.Cvar? {
    get { world.variables.com_timedemo }
    set { world.variables.com_timedemo = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:48
var com_sv_running: JKAMP.Cvar? {
    get { world.variables.com_sv_running }
    set { world.variables.com_sv_running = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:49
var com_cl_running: JKAMP.Cvar? {
    get { world.variables.com_cl_running }
    set { world.variables.com_cl_running = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:50
var com_logfile: JKAMP.Cvar? {
    get { world.variables.com_logfile }
    set { world.variables.com_logfile = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:51
var com_showtrace: JKAMP.Cvar? {
    get { world.variables.com_showtrace }
    set { world.variables.com_showtrace = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:53
var com_optvehtrace: JKAMP.Cvar? {
    get { world.variables.com_optvehtrace }
    set { world.variables.com_optvehtrace = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:56
var com_G2Report: JKAMP.Cvar? {
    get { world.variables.com_G2Report }
    set { world.variables.com_G2Report = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:59
var com_terrainPhysics: JKAMP.Cvar? {
    get { world.variables.com_terrainPhysics }
    set { world.variables.com_terrainPhysics = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:61
var com_version: JKAMP.Cvar? {
    get { world.variables.com_version }
    set { world.variables.com_version = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:62
var com_blood: JKAMP.Cvar? {
    get { world.variables.com_blood }
    set { world.variables.com_blood = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:63
var com_buildScript: JKAMP.Cvar? {
    get { world.variables.com_buildScript }
    set { world.variables.com_buildScript = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:64
var com_introPlayed: JKAMP.Cvar? {
    get { world.variables.com_introPlayed }
    set { world.variables.com_introPlayed = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:65
var cl_paused: JKAMP.Cvar? {
    get { world.variables.cl_paused }
    set { world.variables.cl_paused = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:66
var sv_paused: JKAMP.Cvar? {
    get { world.variables.sv_paused }
    set { world.variables.sv_paused = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:67
var com_cameraMode: JKAMP.Cvar? {
    get { world.variables.com_cameraMode }
    set { world.variables.com_cameraMode = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:72
var com_RMG: JKAMP.Cvar? {
    get { world.variables.com_RMG }
    set { world.variables.com_RMG = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:75
var time_game: Int32 {
    get { world.variables.time_game }
    set { world.variables.time_game = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:76
// Raven wrote: int time_frontend
let time_frontend: Int32 = 0

/// Source: oracle/codemp/qcommon/common.cpp:77
// Raven wrote: int time_backend
let time_backend: Int32 = 0

/// Source: oracle/codemp/qcommon/common.cpp:79
var com_frameTime: Int32 {
    get { world.variables.com_frameTime }
    set { world.variables.com_frameTime = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:80
var com_frameMsec: Int32 {
    get { world.variables.com_frameMsec }
    set { world.variables.com_frameMsec = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:81
var com_frameNumber: Int32 {
    get { world.variables.com_frameNumber }
    set { world.variables.com_frameNumber = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:83
var com_errorEntered: Bool {
    get { world.variables.com_errorEntered }
    set { world.variables.com_errorEntered = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:84
var com_fullyInitialized: Bool {
    get { world.variables.com_fullyInitialized }
    set { world.variables.com_fullyInitialized = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:86
var com_errorMessage: JKAShared.CharBuf {
    get { world.variables.com_errorMessage }
    set { world.variables.com_errorMessage = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:92
var rd_buffer: String {
    get { world.variables.rd_buffer }
    set { world.variables.rd_buffer = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:93
var rd_buffersize: Int32 {
    get { world.variables.rd_buffersize }
    set { world.variables.rd_buffersize = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:94
// AI: Raven stores a C function pointer. The port stores the Swift closure that Com_BeginRedirect takes, on the world.
var rd_flush: ((inout JKAShared.CharBuf) -> Void)? {
    get { world.rd_flush }
    set { world.rd_flush = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:386
let MAX_CONSOLE_LINES = 32 as Int32

/// Source: oracle/codemp/qcommon/common.cpp:387
var com_numConsoleLines: Int32 {
    get { world.variables.com_numConsoleLines }
    set { world.variables.com_numConsoleLines = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:388
var com_consoleLines: [String] {
    get { world.variables.com_consoleLines }
    set { world.variables.com_consoleLines = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:747
let MAX_PUSHED_EVENTS = 1024 as Int32

/// Source: oracle/codemp/qcommon/common.cpp:749
var com_pushedEventsHead: Int32 {
    get { world.variables.com_pushedEventsHead }
    set { world.variables.com_pushedEventsHead = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:750
var com_pushedEventsTail: Int32 {
    get { world.variables.com_pushedEventsTail }
    set { world.variables.com_pushedEventsTail = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:752
var com_pushedEvents: Slots<SysEvent> { world.storage.com_pushedEvents }

/// Source: oracle/codemp/qcommon/common.cpp:791
// AI: Raven declares `ev` on the stack of Com_GetRealEvent. The function uses one zeroed allocation on the storage class.
private var ev_Com_GetRealEvent: SysEvent { world.storage.common_ev_Com_GetRealEvent }

/// Source: oracle/codemp/qcommon/common.cpp:924
// AI: Raven declares `bufData` on the stack of Com_EventLoop. The function uses one zeroed allocation on the storage class.
var bufData_Com_EventLoop: Slots<JKAShared.byte> { world.storage.bufData_Com_EventLoop }


/// Source: oracle/codemp/qcommon/common.cpp:96
func Com_BeginRedirect(_ buffer: inout JKAShared.CharBuf, _ buffersize: Int32, _ flush: ((inout JKAShared.CharBuf) -> Void)?) {
    if buffersize == 0 || flush == nil {
        return
    }
    // AI: Raven keeps the address of the caller's buffer in rd_buffer. The port keeps the text in rd_buffer, and each flush hands it on in a buffer of rd_buffersize bytes.
    rd_buffer = String(buffer)
    rd_buffersize = buffersize
    rd_flush = flush

    // AI: Raven writes the NUL through rd_buffer into the caller's buffer. The port writes it there and empties the text.
    buffer[0] = 0
    rd_buffer = ""
}

/// Source: oracle/codemp/qcommon/common.cpp:107
func Com_EndRedirect() {
    if rd_flush != nil {
        // AI: Raven hands rd_buffer to the flush. The flush takes a buffer of rd_buffersize bytes that holds the text of rd_buffer.
        var flushBuffer = CharBuf(rd_buffersize)
        strcpy(&flushBuffer, rd_buffer)
        rd_flush!(&flushBuffer)
    }

    // AI: Raven sets rd_buffer to NULL. The text is a String, so it takes the empty text.
    rd_buffer = ""
    rd_buffersize = 0
    rd_flush = nil
}

/**
```
=============
Com_Printf

Both client and server can use this, and it will output
to the apropriate place.

A raw string should NEVER be passed as fmt, because of "%f" type crashers.
=============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:128
public func Com_Printf(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    var msg = CharBuf(MAXPRINTMSG)
    var silent: Bool

    strcpy(&msg, JKAShared.format(fmt, args))

    // AI: Raven tests the rd_buffer pointer. The text is a String, so the test reads rd_buffersize, which Com_BeginRedirect and Com_EndRedirect set with it.
    if rd_buffersize != 0 {
        if (strlen(msg) + strlen(rd_buffer)) > (rd_buffersize - 1) {
            // AI: Raven hands rd_buffer to the flush. The flush takes a buffer of rd_buffersize bytes that holds the text of rd_buffer.
            var flushBuffer = CharBuf(rd_buffersize)
            strcpy(&flushBuffer, rd_buffer)
            rd_flush!(&flushBuffer)
            rd_buffer = ""
        }
        // AI: Raven appends msg to rd_buffer and hands it to the flush. The append writes a buffer of rd_buffersize bytes, which the flush takes.
        var flushBuffer = CharBuf(rd_buffersize)
        strcpy(&flushBuffer, rd_buffer)
        Q_strcat(&flushBuffer, rd_buffersize, String(msg))
        rd_flush!(&flushBuffer)
        rd_buffer = ""
        return
    }

    // * means dont draw this console message on the player screen
    // but put it on the console
    silent = false
    if msg[0] == Int32(ascii: "*") {
        // Raven passes `msg` twice, so the tail is a copy before the call.
        let msgTail = msg[1...]
        strcpy(&msg, msgTail)

        if msg[1] != Int32(ascii: "*") {
            silent = true
        }
    }

    // echo to console if we're not a dedicated server
    if com_dedicated != nil && com_dedicated!.integer == 0 {
        CL_ConsolePrint(String(msg), silent)
    }

    // echo to dedicated console and early console
    Sys_Print(String(msg))

    // logfile
    if com_logfile != nil && com_logfile!.integer != 0 {
        if logfile == 0 && FS_Initialized() {
            var aclock: time_t = 0

            _ = time(&aclock)
            // AI: Raven reads the local time through the struct tm pointer of localtime. CommonBackend.asctime reads it in the view target and gives the text of asctime.
            let newtime = CommonBackend.asctime(aclock)

            logfile = FS_FOpenFileWrite("qconsole.log")
            Com_Printf("logfile opened on %s\n", newtime)
            if com_logfile!.integer > 1 {
                // force it to not buffer so we get valid
                // data even if we are crashing
                FS_ForceFlush(logfile)
            }
        }
        if logfile != 0 && FS_Initialized() {
            _ = FS_Write(msg, strlen(msg), logfile)
        }
    }
}

/**
```
================
Com_DPrintf

A Com_Printf that only shows up if the "developer" cvar is set
================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:210
func Com_DPrintf(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    var msg = CharBuf(MAXPRINTMSG)

    if com_developer == nil || com_developer!.integer == 0 {
        return // don't confuse non-developers with techie stuff...
    }

    strcpy(&msg, JKAShared.format(fmt, args))

    Com_Printf("%s", msg)
}

// Outputs to the VC / Windows Debug window (only in debug compile)
/// Source: oracle/codemp/qcommon/common.cpp:226
func Com_OPrintf(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    var msg = CharBuf(MAXPRINTMSG)

    strcpy(&msg, JKAShared.format(fmt, args))
    // AI: Raven called the Win32 OutputDebugString for the debugger window. A POSIX host has no such window, so the call drops.
}

/// Source: oracle/codemp/qcommon/common.cpp:251
var lastErrorTime: Int32 {
    get { world.lastErrorTime }
    set { world.lastErrorTime = newValue }
}

/// Source: oracle/codemp/qcommon/common.cpp:252
var errorCount: Int32 {
    get { world.errorCount }
    set { world.errorCount = newValue }
}

/**
```
=============
Com_Error

Both client and server can use this, and it will
do the apropriate things.
=============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:249
public func Com_Error(_ code: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...) -> Never {
    let currentTime: Int32
    // Raven assigns his own `code` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var code = code

    // when we are running automated scripts, make sure we
    // know if anything failed
    if com_buildScript != nil && com_buildScript!.integer != 0 {
        code = ERR_FATAL
    }

    // make sure we can get at our local stuff
    FS_PureServerSetLoadedPaks("", "")

    // if we are getting a solid stream of ERR_DROP, do an ERR_FATAL
    currentTime = Sys_Milliseconds()
    if currentTime - lastErrorTime < 100 {
        errorCount += 1
        if errorCount > 3 {
            code = ERR_FATAL
        }
    } else {
        errorCount = 0
    }
    lastErrorTime = currentTime

    if com_errorEntered {
        Sys_Error("recursive error after: %s", com_errorMessage)
    }
    com_errorEntered = true

    strcpy(&com_errorMessage, JKAShared.format(fmt, args))

    if code != ERR_DISCONNECT {
        _ = Cvar_Get("com_errorMessage", "", CVAR_ROM) //give com_errorMessage a default so it won't come back to life after a resetDefaults
        Cvar_Set("com_errorMessage", String(com_errorMessage))
    }

    if code == ERR_SERVERDISCONNECT {
        CL_Disconnect(true)
        CL_FlushMemory()
        com_errorEntered = false

        // AI: Raven threw to the catch in Com_Frame, which printed the reason and returned to the loop. Swift cannot unwind here, so the process ends with the reason printed.
        Com_Printf("DISCONNECTED\n")
        exit(1)
    } else if code == ERR_DROP || code == ERR_DISCONNECT {
        Com_Printf("********************\nERROR: %s\n********************\n", com_errorMessage)
        SV_Shutdown(va("Server crashed: %s\n", com_errorMessage))
        CL_Disconnect(true)
        CL_FlushMemory()
        com_errorEntered = false

        // AI: Raven threw to the catch in Com_Frame, which printed the reason and returned to the loop. Swift cannot unwind here, so the process ends with the reason printed.
        Com_Printf("DROPPED\n")
        exit(1)
    } else if code == ERR_NEED_CD {
        SV_Shutdown("Server didn't have CD\n")
        if com_cl_running != nil && com_cl_running!.integer != 0 {
            CL_Disconnect(true)
            CL_FlushMemory()
            com_errorEntered = false
        } else {
            Com_Printf("Server didn't have CD\n")
        }
        // AI: Raven threw to the catch in Com_Frame, which printed the reason and returned to the loop. Swift cannot unwind here, so the process ends with the reason printed.
        Com_Printf("NEED CD\n")
        exit(1)
    } else {
        CL_Shutdown()
        SV_Shutdown(va("Server fatal crashed: %s\n", com_errorMessage))
    }

    Com_Shutdown()

    Sys_Error("%s", com_errorMessage)
    // AI: Raven's Sys_Error exits the process. Its Swift signature returns, so a trap after the call keeps Com_Error from returning.
    fatalError("Sys_Error returned: \(String(com_errorMessage))")
}

/**
```
=============
Com_Quit_f

Both client and server can use this, and it will
do the apropriate things.
=============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:356
func Com_Quit_f() {
    // don't try to shutdown if we are in a recursive error
    if !com_errorEntered {
        SV_Shutdown("Server quit\n")
        CL_Shutdown()
        Com_Shutdown()
        FS_Shutdown(true)
    }
    Sys_Quit()
}

/**
```
==================
Com_ParseCommandLine

Break it up into multiple console lines
==================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:397
func Com_ParseCommandLine(_ commandLine: inout JKAShared.CharBuf) {
    // AI: Raven points each com_consoleLines entry at its line in commandLine. Each entry is the text of its line, read out of commandLine at the NUL that ends the line.
    var commandLineIndex: Int32 = 0
    var lineStart: Int32 = 0
    com_numConsoleLines = 1

    while commandLine[commandLineIndex] != 0 {
        // look for a + seperating character
        // if commandLine came from a file, we might have real line seperators
        if commandLine[commandLineIndex] == Int32(ascii: "+") || commandLine[commandLineIndex] == Int32(ascii: "\n") {
            if com_numConsoleLines == MAX_CONSOLE_LINES {
                com_consoleLines[com_numConsoleLines - 1] = JKAShared.TextCursor(commandLine, at: lineStart).text
                return
            }
            commandLine[commandLineIndex] = 0
            com_consoleLines[com_numConsoleLines - 1] = JKAShared.TextCursor(commandLine, at: lineStart).text
            lineStart = commandLineIndex + 1
            com_numConsoleLines += 1
        }
        commandLineIndex += 1
    }
    com_consoleLines[com_numConsoleLines - 1] = JKAShared.TextCursor(commandLine, at: lineStart).text
}

/**
```
===================
Com_SafeMode

Check for "safe" on the command line, which will
skip loading of jampconfig.cfg
===================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:425
func Com_SafeMode() -> Bool {
    var i: Int32

    i = 0
    while i < com_numConsoleLines {
        Cmd_TokenizeString(com_consoleLines[i])
        if Q_stricmp(Cmd_Argv(0), "safe") == 0 || Q_stricmp(Cmd_Argv(0), "cvar_restart") == 0 {
            // AI: Raven writes a NUL into the first byte of the line. The line is a String, so it takes the empty text.
            com_consoleLines[i] = ""
            return true
        }
        i += 1
    }
    return false
}

/**
```
===============
Com_StartupVariable

Searches for command line parameters that are set commands.
If match is not NULL, only that cvar will be looked for.
That is necessary because cddir and basedir need to be set
before the filesystem is started, but all other sets shouls
be after execing the config and default.
===============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:451
func Com_StartupVariable(_ match: String?) {
    var i: Int32
    var s: String
    var cv: Cvar?

    i = 0
    while i < com_numConsoleLines {
        Cmd_TokenizeString(com_consoleLines[i])
        if strcmp(Cmd_Argv(0), "set") != 0 {
            i += 1
            continue
        }

        s = Cmd_Argv(1)
        if match == nil || strcmp(s, match!) == 0 {
            Cvar_Set(s, Cmd_Argv(2))
            cv = Cvar_Get(s, "", 0)
            cv!.flags |= CVAR_USER_CREATED
            //			com_consoleLines[i] = 0;
        }
        i += 1
    }
}

/**
```
=================
Com_AddStartupCommands

Adds command line parameters as script statements
Commands are seperated by + signs

Returns qtrue if any late commands were added, which
will keep the demoloop from immediately starting
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:484
func Com_AddStartupCommands() -> Bool {
    var i: Int32
    var added: Bool

    added = false
    // quote every token, so args with semicolons can work
    i = 0
    while i < com_numConsoleLines {
        // Raven tests `!com_consoleLines[i]`.
        // Raven tests `!com_consoleLines[i][0]`.
        if com_consoleLines[i].isEmpty {
            i += 1
            continue
        }

        // set commands won't override menu startup
        if Q_stricmpn(com_consoleLines[i], "set", 3) != 0 {
            added = true
        }
        Cbuf_AddText(com_consoleLines[i])
        Cbuf_AddText("\n")
        i += 1
    }

    return added
}

/// Source: oracle/codemp/qcommon/common.cpp:509
func Info_Print(_ s: String) {
    var key = CharBuf(512)
    var value = CharBuf(512)
    var o: Int32
    var l: Int32
    // Raven steps his own `s` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var s = TextCursor(CharBuf(s))

    if s.byte == Int32(ascii: "\\") {
        s.advance()
    }
    while s.byte != 0 {
        o = 0
        while s.byte != 0 && s.byte != Int32(ascii: "\\") {
            key[o] = s.byte
            o += 1
            s.advance()
        }

        l = o
        if l < 20 {
            Com_Memset(&key, Int32(ascii: " "), 20 - l, at: o)
            key[20] = 0
        } else {
            key[o] = 0
        }
        Com_Printf("%s", key)

        if s.byte == 0 {
            Com_Printf("MISSING VALUE\n")
            return
        }

        o = 0
        s.advance()
        while s.byte != 0 && s.byte != Int32(ascii: "\\") {
            value[o] = s.byte
            o += 1
            s.advance()
        }
        value[o] = 0

        if s.byte != 0 {
            s.advance()
        }
        Com_Printf("%s\n", value)
    }
}

/**
```
============
Com_StringContains
============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:556
func Com_StringContains(_ str1: inout JKAShared.CharBuf, _ str2: String, _ casesensitive: Int32) -> String? {
    let len: Int32
    var i: Int32
    var j: Int32
    var str1Index: Int32 = 0
    let str2 = CharBuf(str2)

    len = strlen(str1) - strlen(str2)
    i = 0
    while i <= len {
        j = 0
        while str2[j] != 0 {
            if casesensitive != 0 {
                if str1[str1Index + j] != str2[j] {
                    break
                }
            } else {
                // Foundation also declares toupper, so the qualifier picks the C-locale form of JKAShared.
                if JKAShared.toupper(str1[str1Index + j]) != JKAShared.toupper(str2[j]) {
                    break
                }
            }
            j += 1
        }
        if str2[j] == 0 {
            // AI: Raven returns the pointer into str1 at the match. The return is the text from the match.
            return String(str1[str1Index...])
        }
        i += 1
        str1Index += 1
    }
    return nil
}

/**
```
============
Com_Filter
============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:585
func Com_Filter(_ filter: inout JKAShared.CharBuf, _ name: inout JKAShared.CharBuf, _ casesensitive: Int32) -> Int32 {
    var buf = CharBuf(MAX_TOKEN_CHARS)
    var ptr: String? = nil
    var i: Int32
    var found: Bool
    var filterIndex: Int32 = 0
    var nameIndex: Int32 = 0

    while filter[filterIndex] != 0 {
        if filter[filterIndex] == Int32(ascii: "*") {
            filterIndex += 1
            i = 0
            while filter[filterIndex] != 0 {
                if filter[filterIndex] == Int32(ascii: "*") || filter[filterIndex] == Int32(ascii: "?") {
                    break
                }
                buf[i] = filter[filterIndex]
                filterIndex += 1
                i += 1
            }
            buf[i] = 0
            if strlen(buf) != 0 {
                // Raven hands `name` at its cursor, so the call takes a copy of the suffix.
                var nameSuffix = name[nameIndex...]
                ptr = Com_StringContains(&nameSuffix, String(buf), casesensitive)
                if ptr == nil {
                    return 0
                }
                // AI: Raven steps name to the pointer that Com_StringContains returns, plus the length of buf. The return is the text from the match, so the match starts at the length of name less the length of that text.
                nameIndex = strlen(name) - strlen(ptr!) + strlen(buf)
            }
        } else if filter[filterIndex] == Int32(ascii: "?") {
            filterIndex += 1
            nameIndex += 1
        } else if filter[filterIndex] == Int32(ascii: "[") && filter[filterIndex + 1] == Int32(ascii: "[") {
            filterIndex += 1
        } else if filter[filterIndex] == Int32(ascii: "[") {
            filterIndex += 1
            found = false
            while filter[filterIndex] != 0 && !found {
                if filter[filterIndex] == Int32(ascii: "]") && filter[filterIndex + 1] != Int32(ascii: "]") {
                    break
                }
                if filter[filterIndex + 1] == Int32(ascii: "-") && filter[filterIndex + 2] != 0 && (filter[filterIndex + 2] != Int32(ascii: "]") || filter[filterIndex + 3] == Int32(ascii: "]")) {
                    if casesensitive != 0 {
                        if name[nameIndex] >= filter[filterIndex] && name[nameIndex] <= filter[filterIndex + 2] {
                            found = true
                        }
                    } else {
                        // Foundation also declares toupper, so the qualifier picks the C-locale form of JKAShared.
                        if JKAShared.toupper(name[nameIndex]) >= JKAShared.toupper(filter[filterIndex]) && JKAShared.toupper(name[nameIndex]) <= JKAShared.toupper(filter[filterIndex + 2]) {
                            found = true
                        }
                    }
                    filterIndex += 3
                } else {
                    if casesensitive != 0 {
                        if filter[filterIndex] == name[nameIndex] {
                            found = true
                        }
                    } else {
                        // Foundation also declares toupper, so the qualifier picks the C-locale form of JKAShared.
                        if JKAShared.toupper(filter[filterIndex]) == JKAShared.toupper(name[nameIndex]) {
                            found = true
                        }
                    }
                    filterIndex += 1
                }
            }
            if !found {
                return 0
            }
            while filter[filterIndex] != 0 {
                if filter[filterIndex] == Int32(ascii: "]") && filter[filterIndex + 1] != Int32(ascii: "]") {
                    break
                }
                filterIndex += 1
            }
            filterIndex += 1
            nameIndex += 1
        } else {
            if casesensitive != 0 {
                if filter[filterIndex] != name[nameIndex] {
                    return 0
                }
            } else {
                // Foundation also declares toupper, so the qualifier picks the C-locale form of JKAShared.
                if JKAShared.toupper(filter[filterIndex]) != JKAShared.toupper(name[nameIndex]) {
                    return 0
                }
            }
            filterIndex += 1
            nameIndex += 1
        }
    }
    return 1
}

/**
```
============
Com_FilterPath
============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:665
func Com_FilterPath(_ filter: String?, _ name: String, _ casesensitive: Int32) -> Int32 {
    var i: Int32
    var new_filter = CharBuf(MAX_QPATH)
    var new_name = CharBuf(MAX_QPATH)
    let filter = CharBuf(filter!)
    let name = CharBuf(name)

    i = 0
    while i < MAX_QPATH - 1 && filter[i] != 0 {
        if filter[i] == Int32(ascii: "\\") || filter[i] == Int32(ascii: ":") {
            new_filter[i] = Int32(ascii: "/")
        } else {
            new_filter[i] = filter[i]
        }
        i += 1
    }
    new_filter[i] = 0
    i = 0
    while i < MAX_QPATH - 1 && name[i] != 0 {
        if name[i] == Int32(ascii: "\\") || name[i] == Int32(ascii: ":") {
            new_name[i] = Int32(ascii: "/")
        } else {
            new_name[i] = name[i]
        }
        i += 1
    }
    new_name[i] = 0
    return Com_Filter(&new_filter, &new_name, casesensitive)
}

/**
```
============
Com_HashKey
============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:697
func Com_HashKey(_ string: String, _ maxlen: Int32) -> Int32 {
    var hash: Int32
    var i: Int32
    let string = CharBuf(string)

    hash = 0
    i = 0
    while i < maxlen && string[i] != 0 {
        hash += string[i] * (119 + i)
        i += 1
    }
    hash = (hash ^ (hash >> 10) ^ (hash >> 20))
    return hash
}

/**
```
================
Com_RealTime
================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:713
func Com_RealTime(_ qtime: JKAMP.Qtime?) -> Int32 {
    let t: time_t

    t = time(nil)
    if qtime == nil {
        // C narrows the `time_t` to the `int` return.
        return Int32(truncatingIfNeeded: t)
    }
    // AI: Raven reads `tms = localtime(&t)` and copies its fields when it is not NULL. The backend does the read and the copy into the view.
    CommonBackend.localtime(t, qtime!)
    return Int32(truncatingIfNeeded: t)
}

/**
```
=================
Com_InitJournaling
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:759
func Com_InitJournaling() {
    Com_StartupVariable("journal")
    com_journal = Cvar_Get("journal", "0", CVAR_INIT)
    if com_journal!.integer == 0 {
        return
    }

    if com_journal!.integer == 1 {
        Com_Printf("Journaling events\n")
        com_journalFile = FS_FOpenFileWrite("journal.dat")
        com_journalDataFile = FS_FOpenFileWrite("journaldata.dat")
    } else if com_journal!.integer == 2 {
        Com_Printf("Replaying journaled events\n")
        _ = FS_FOpenFileRead("journal.dat", &com_journalFile, true)
        _ = FS_FOpenFileRead("journaldata.dat", &com_journalDataFile, true)
    }

    if com_journalFile == 0 || com_journalDataFile == 0 {
        Cvar_Set("com_journal", "0")
        com_journalFile = 0
        com_journalDataFile = 0
        Com_Printf("Couldn't open journal files\n")
    }
}

/**
```
=================
Com_GetRealEvent
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:789
func Com_GetRealEvent() -> SysEvent {
    var r: Int32
    let ev = ev_Com_GetRealEvent

    // either get an event from the system or the journal file
    if com_journal!.integer == 2 {
        r = FS_Read(Slots(record: ev).bytes, Int32(SysEvent.byteCount), com_journalFile)
        if r != Int32(SysEvent.byteCount) {
            Com_Error(ERR_FATAL, "Error reading from journal file")
        }
        if ev.evPtrLength != 0 {
            let block = Z_Malloc(ev.evPtrLength, TAG_EVENT, true)
            ev.evPtr = block
            r = FS_Read(Slots(scalars: block, count: Int(ev.evPtrLength)), ev.evPtrLength, com_journalFile)
            if r != ev.evPtrLength {
                Com_Error(ERR_FATAL, "Error reading from journal file")
            }
        }
    } else {
        ev.copy(from: Sys_GetEvent())

        // write the journal value out if needed
        if com_journal!.integer == 1 {
            r = FS_Write(Slots(record: ev).bytes, Int32(SysEvent.byteCount), com_journalFile)
            if r != Int32(SysEvent.byteCount) {
                Com_Error(ERR_FATAL, "Error writing to journal file")
            }
            if ev.evPtrLength != 0 {
                // Port-note: Raven writes the bytes of the `void *` field `ev.evPtr`, and FS_Write takes a Slots of bytes, which a handle field does not give.
                // Raven wrote: r = FS_Write( ev.evPtr, ev.evPtrLength, com_journalFile ), and its test of `r`
                portMissing("Com_GetRealEvent", source: "oracle/codemp/qcommon/common.cpp:789")
            }
        }
    }

    return ev
}

/**
```
=================
Com_InitPushEvent
=================
```
*/
// bk001129 - added
/// Source: oracle/codemp/qcommon/common.cpp:834
func Com_InitPushEvent() {
    // clear the static buffer array
    // this requires SE_NONE to be accepted as a valid but NOP event
    com_pushedEvents.zero()
    // reset counters while we are at it
    // beware: GetEvent might still return an SE_NONE from the buffer
    com_pushedEventsHead = 0
    com_pushedEventsTail = 0
}

/**
```
=================
Com_PushEvent
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:850
func Com_PushEvent(_ event: SysEvent) {
    let ev: SysEvent

    ev = com_pushedEvents[com_pushedEventsHead & (MAX_PUSHED_EVENTS - 1)]

    if com_pushedEventsHead - com_pushedEventsTail >= MAX_PUSHED_EVENTS {
        // don't print the warning constantly, or it can give time for more...
        if printedWarning == 0 {
            printedWarning = 1
            Com_Printf("WARNING: Com_PushEvent overflow\n")
        }

        if ev.evPtr != nil {
            // AI: Raven frees the `void *` field. Z_Free takes the handle of the block.
            Z_Free(OpaquePointer(ev.evPtr))
        }
        com_pushedEventsTail += 1
    } else {
        printedWarning = 0
    }

    ev.copy(from: event)
    com_pushedEventsHead += 1
}

/// Source: oracle/codemp/qcommon/common.cpp:852
var printedWarning: Int32 {
    get { world.printedWarning }
    set { world.printedWarning = newValue }
}

/**
```
=================
Com_GetEvent
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:881
func Com_GetEvent() -> SysEvent {
    if com_pushedEventsHead > com_pushedEventsTail {
        com_pushedEventsTail += 1
        return com_pushedEvents[(com_pushedEventsTail - 1) & (MAX_PUSHED_EVENTS - 1)]
    }
    return Com_GetRealEvent()
}

/**
```
=================
Com_RunAndTimeServerPacket
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:894
func Com_RunAndTimeServerPacket(_ evFrom: Netadr, _ buf: Msg) {
    var t1: Int32
    let t2: Int32
    let msec: Int32

    t1 = 0

    if com_speeds!.integer != 0 {
        t1 = Sys_Milliseconds()
    }

    SV_PacketEvent(evFrom, buf)

    if com_speeds!.integer != 0 {
        t2 = Sys_Milliseconds()
        msec = t2 - t1
        if com_speeds!.integer == 3 {
            Com_Printf("SV_PacketEvent time: %i\n", msec)
        }
    }
}

/**
```
=================
Com_EventLoop

Returns last event time
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:921
func Com_EventLoop() -> Int32 {
    return SysEvent.scratch { ev -> Int32 in
        Netadr.scratch { evFrom -> Int32 in
            Msg.scratch { buf -> Int32 in
                MSG_Init(buf, bufData_Com_EventLoop, Int32(bufData_Com_EventLoop.count))

                while true {
                    ev.copy(from: Com_GetEvent())

                    // if no more events are available
                    if ev.evType == SE_NONE {
                        // manually send packet events for the loopback channel
                        while NET_GetLoopPacket(NS_CLIENT, evFrom, buf) {
                            CL_PacketEvent(evFrom, buf)
                        }

                        while NET_GetLoopPacket(NS_SERVER, evFrom, buf) {
                            // if the server just shut down, flush the events
                            if com_sv_running!.integer != 0 {
                                Com_RunAndTimeServerPacket(evFrom, buf)
                            }
                        }

                        return ev.evTime
                    }

                    switch ev.evType {
                    case SE_NONE:
                        break
                    case SE_KEY:
                        // C converts the `int` time to the `unsigned` parameter.
                        CL_KeyEvent(ev.evValue, ev.evValue2 != 0, UInt32(bitPattern: ev.evTime))
                    case SE_CHAR:
                        CL_CharEvent(ev.evValue)
                    case SE_MOUSE:
                        CL_MouseEvent(ev.evValue, ev.evValue2, ev.evTime)
                    case SE_JOYSTICK_AXIS:
                        CL_JoystickEvent(ev.evValue, ev.evValue2, ev.evTime)
                    case SE_CONSOLE:
                        // AI: Raven reads the text at `(char *)ev.evPtr`. The body reads the text of the raw block of the event.
                        let text = cString(at: ev.evPtr!)
                        if text.hasPrefix("\\") || text.hasPrefix("/") {
                            Cbuf_AddText(String(text.dropFirst()))
                        } else {
                            Cbuf_AddText(text)
                        }
                        Cbuf_AddText("\n")
                    case SE_PACKET:
                        // this cvar allows simulation of connections that
                        // drop a lot of packets.  Note that loopback connections
                        // don't go through here at all.
                        if com_dropsim!.value > 0 {
                            if Q_random(&seed_Com_EventLoop) < com_dropsim!.value {
                                break // drop this packet
                            }
                        }

                        evFrom.copy(from: Netadr(ev.evPtr!))
                        buf.cursize = ev.evPtrLength - Int32(Netadr.byteCount)

                        // we must copy the contents of the message out, because
                        // the event buffers are only large enough to hold the
                        // exact payload, but channel messages need to be large
                        // enough to hold fragment reassembly
                        if UInt32(bitPattern: buf.cursize) > UInt32(bitPattern: buf.maxsize) {
                            Com_Printf("Com_EventLoop: oversize packet\n")
                            continue
                        }
                        // AI: Raven copies from `(netadr_t *)ev.evPtr + 1`. The copy reads the tail of the block from the byte offset of one record.
                        Com_Memcpy(buf.data!, Slots<JKAShared.byte>(scalars: ev.evPtr!, count: Int(ev.evPtrLength)).suffix(from: Netadr.byteCount), buf.cursize)
                        if com_sv_running!.integer != 0 {
                            Com_RunAndTimeServerPacket(evFrom, buf)
                        } else {
                            CL_PacketEvent(evFrom, buf)
                        }
                    default:
                        // bk001129 - was ev.evTime
                        Com_Error(ERR_FATAL, "Com_EventLoop: bad event type %i", ev.evType)
                    }

                    // free any block data
                    if ev.evPtr != nil {
                        // AI: Raven frees the `void *` field. Z_Free takes the handle of the block.
                        Z_Free(OpaquePointer(ev.evPtr))
                    }
                }
            }
        }
    }
}

/// Source: oracle/codemp/qcommon/common.cpp:986
var seed_Com_EventLoop: Int32 {
    get { world.seed_Com_EventLoop }
    set { world.seed_Com_EventLoop = newValue }
}

/**
```
================
Com_Milliseconds

Can be used for profiling, but will be journaled accurately
================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1028
func Com_Milliseconds() -> Int32 {
    return SysEvent.scratch { ev -> Int32 in
        // get events and push them until we get a null event with the current time
        repeat {
            ev.copy(from: Com_GetRealEvent())
            if ev.evType != SE_NONE {
                Com_PushEvent(ev)
            }
        } while ev.evType != SE_NONE

        return ev.evTime
    }
}

/**
```
=============
Com_Error_f

Just throw a fatal error to
test error shutdown procedures
=============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1053
private func Com_Error_f() {
    if Cmd_Argc() > 1 {
        Com_Error(ERR_DROP, "Testing drop error")
    } else {
        Com_Error(ERR_FATAL, "Testing fatal error")
    }
}

/**
```
=============
Com_Freeze_f

Just freeze in place for a given number of seconds to test
error recovery
=============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1070
private func Com_Freeze_f() {
    let s: Float
    let start: Int32
    var now: Int32

    if Cmd_Argc() != 2 {
        Com_Printf("freeze <seconds>\n")
        return
    }
    s = Float(atof(Cmd_Argv(1)))

    start = Com_Milliseconds()

    while true {
        now = Com_Milliseconds()
        if Double(now - start) * 0.001 > Double(s) {
            break
        }
    }
}

/**
```
=================
Com_Crash_f

A way to force a bus error for development reasons
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1097
private func Com_Crash_f() {
    // Port-note: Raven stores 0x12345678 through a NULL `int *` to force a bus error, which C leaves undefined.
    // The port traps at the same line, the one defined form of the crash.
    fatalError("Com_Crash_f")
}

/**
```
=================
Com_Init
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1216
public func Com_Init(_ commandLine: inout JKAShared.CharBuf) {
    let s: String

    Com_Printf("%s %s %s\n", Q3_VERSION, CPUSTRING, buildDate)

    // Port-note: Raven wraps the rest in a try, and the catch hands the text a Com_Error throws to Sys_Error.
    // Row C1: the three throw sites of Com_Error print the text and end the process, so no throw reaches this function.

    // bk001129 - do this before anything else decides to push events
    Com_InitPushEvent()

    Cvar_Init()

    // prepare enough of the subsystems to handle
    // cvar and command buffer management
    Com_ParseCommandLine(&commandLine)

    //	Swap_Init ();
    Cbuf_Init()

    Com_InitZoneMemory()

    Cmd_Init()

    // override anything from the config files with command line args
    Com_StartupVariable(nil)

    // Seed the random number generator
    Rand_Init(Sys_Milliseconds(true))

    // get the developer cvar set as early as possible
    Com_StartupVariable("developer")

    // done early so bind command exists
    CL_InitKeyCommands()

    FS_InitFilesystem()

    Com_InitJournaling()

    Cbuf_AddText("exec mpdefault.cfg\n")

    // skip the jampconfig.cfg if "safe" is on the command line
    if !Com_SafeMode() {
        Cbuf_AddText("exec jampserver.cfg\n")
    }

    Cbuf_AddText("exec autoexec.cfg\n")

    Cbuf_Execute()

    // override anything from the config files with command line args
    Com_StartupVariable(nil)

    // get dedicated here for proper hunk megs initialization
    com_dedicated = Cvar_Get("dedicated", "2", CVAR_ROM)
    // allocate the stack based hunk allocator
    Com_InitHunkMemory()

    // if any archived cvars are modified after this, we will trigger a writing
    // of the config file
    cvar_modifiedFlags &= ~CVAR_ARCHIVE

    //
    // init commands and vars
    //
    com_maxfps = Cvar_Get("com_maxfps", "85", CVAR_ARCHIVE)
    com_blood = Cvar_Get("com_blood", "1", CVAR_ARCHIVE)

    com_developer = Cvar_Get("developer", "0", CVAR_TEMP)
    com_vmdebug = Cvar_Get("vmdebug", "0", CVAR_TEMP)
    com_logfile = Cvar_Get("logfile", "0", CVAR_TEMP)

    com_timescale = Cvar_Get("timescale", "1", CVAR_CHEAT | CVAR_SYSTEMINFO)
    com_fixedtime = Cvar_Get("fixedtime", "0", CVAR_CHEAT)
    com_showtrace = Cvar_Get("com_showtrace", "0", CVAR_CHEAT)

    com_terrainPhysics = Cvar_Get("com_terrainPhysics", "1", CVAR_CHEAT)

    com_dropsim = Cvar_Get("com_dropsim", "0", CVAR_CHEAT)
    com_viewlog = Cvar_Get("viewlog", "0", CVAR_CHEAT)
    com_speeds = Cvar_Get("com_speeds", "0", 0)
    com_timedemo = Cvar_Get("timedemo", "0", 0)
    com_cameraMode = Cvar_Get("com_cameraMode", "0", CVAR_CHEAT)

    com_optvehtrace = Cvar_Get("com_optvehtrace", "0", 0)

    cl_paused = Cvar_Get("cl_paused", "0", CVAR_ROM)
    sv_paused = Cvar_Get("sv_paused", "0", CVAR_ROM)
    com_sv_running = Cvar_Get("sv_running", "0", CVAR_ROM)
    com_cl_running = Cvar_Get("cl_running", "0", CVAR_ROM)
    com_buildScript = Cvar_Get("com_buildScript", "0", 0)

    com_G2Report = Cvar_Get("com_G2Report", "0", 0)

    com_RMG = Cvar_Get("RMG", "0", 0)

    _ = Cvar_Get("RMG_seed", "0", 0)
    _ = Cvar_Get("RMG_time", "day", 0)
    _ = Cvar_Get("RMG_soundset", "", 0)

    _ = Cvar_Get("RMG_textseed", "0", CVAR_SYSTEMINFO | CVAR_ARCHIVE)
    _ = Cvar_Get("RMG_map", "small", CVAR_ARCHIVE | CVAR_SYSTEMINFO)
    _ = Cvar_Get("RMG_timefile", "day", CVAR_ARCHIVE)
    _ = Cvar_Get("RMG_terrain", "grassyhills", CVAR_ARCHIVE)

    _ = Cvar_Get("RMG_sky", "", CVAR_SYSTEMINFO)
    _ = Cvar_Get("RMG_fog", "", CVAR_SYSTEMINFO)
    _ = Cvar_Get("RMG_weather", "", CVAR_SYSTEMINFO | CVAR_SERVERINFO | CVAR_CHEAT)
    _ = Cvar_Get("RMG_instances", "colombia", CVAR_SYSTEMINFO)
    _ = Cvar_Get("RMG_miscents", "deciduous", 0)
    _ = Cvar_Get("RMG_music", "music/dm_kam1", 0)
    _ = Cvar_Get("RMG_mission", "ctf", CVAR_SYSTEMINFO)
    _ = Cvar_Get("RMG_course", "standard", CVAR_SYSTEMINFO)
    _ = Cvar_Get("RMG_distancecull", "5000", CVAR_CHEAT)

    com_introPlayed = Cvar_Get("com_introplayed", "0", CVAR_ARCHIVE)

    if com_dedicated!.integer != 0 {
        if com_viewlog!.integer == 0 {
            Cvar_Set("viewlog", "1")
        }
    }

    if com_developer != nil && com_developer!.integer != 0 {
        Cmd_AddCommand("error", Com_Error_f)
        Cmd_AddCommand("crash", Com_Crash_f)
        Cmd_AddCommand("freeze", Com_Freeze_f)
    }
    Cmd_AddCommand("quit", Com_Quit_f)
    Cmd_AddCommand("changeVectors", MSG_ReportChangeVectors_f)
    Cmd_AddCommand("writeconfig", Com_WriteConfig_f)

    s = va("%s %s %s", Q3_VERSION, CPUSTRING, buildDate)
    com_version = Cvar_Get("version", s, CVAR_ROM | CVAR_SERVERINFO)

    SE_Init()

    Sys_Init()
    Netchan_Init(Com_Milliseconds() & 0xffff) // pick a port value that should be nice and random
    VM_Init()
    SV_Init()

    com_dedicated!.modified = false
    if com_dedicated!.integer == 0 {
        CL_Init()
        Sys_ShowConsole(com_viewlog!.integer, false)
    }

    // set com_frameTime so that if a map is started on the
    // command line it will still be able to count on com_frameTime
    // being random enough for a serverid
    com_frameTime = Com_Milliseconds()

    // add + commands from command line
    if !Com_AddStartupCommands() {
        // if the user didn't give any commands, run default action
        if com_dedicated!.integer == 0 {
            Cbuf_AddText("cinematic openinglogos.roq\n")
            // intro.roq is iD's.
            //				if( !com_introPlayed->integer ) {
            //					Cvar_Set( com_introPlayed->name, "1" );
            //					Cvar_Set( "nextmap", "cinematic intro.RoQ" );
            //				}
        }
    }

    // start in full screen ui mode
    Cvar_Set("r_uiFullScreen", "1")

    CL_StartHunkUsers()

    // make sure single player is off by default
    Cvar_Set("ui_singlePlayerActive", "0")

    com_fullyInitialized = true
    Com_Printf("--- Common Initialization Complete ---\n")
}

/// Source: oracle/codemp/qcommon/common.cpp:1446
func Com_WriteConfigToFile(_ filename: String) {
    let f: fileHandle_t

    f = FS_FOpenFileWrite(filename)
    if f == 0 {
        Com_Printf("Couldn't write %s.\n", filename)
        return
    }

    FS_Printf(f, "// generated by Star Wars Jedi Academy MP, do not modify\n")
    Key_WriteBindings(f)
    Cvar_WriteVariables(f)
    FS_FCloseFile(f)
}

/**
```
===============
Com_WriteConfiguration

Writes key bindings and archived cvars to config file if modified
===============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1471
func Com_WriteConfiguration() {
    // if we are quiting without fully initializing, make sure
    // we don't write out anything
    if !com_fullyInitialized {
        return
    }

    if (cvar_modifiedFlags & CVAR_ARCHIVE) == 0 {
        return
    }
    cvar_modifiedFlags &= ~CVAR_ARCHIVE

    Com_WriteConfigToFile("jampserver.cfg")

    // bk001119 - tentative "not needed for dedicated"
}

/**
```
===============
Com_WriteConfig_f

Write the config file to a specific name
===============
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1515
func Com_WriteConfig_f() {
    var filename = CharBuf(MAX_QPATH)

    if Cmd_Argc() != 2 {
        Com_Printf("Usage: writeconfig <filename>\n")
        return
    }

    Q_strncpyz(&filename, Cmd_Argv(1), Int32(filename.count))
    COM_DefaultExtension(&filename, Int32(filename.count), ".cfg")
    Com_Printf("Writing %s.\n", filename)
    Com_WriteConfigToFile(String(filename))
}

/**
```
================
Com_ModifyMsec
================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1534
func Com_ModifyMsec(_ msec: Int32) -> Int32 {
    var clampTime: Int32
    // Raven assigns his own `msec` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var msec = msec

    //
    // modify time for debugging values
    //
    if com_fixedtime!.integer != 0 {
        msec = com_fixedtime!.integer
    } else if com_timescale!.value != 0 {
        msec = Int32(msec * com_timescale!.value)
    } else if com_cameraMode!.integer != 0 {
        msec = Int32(msec * com_timescale!.value)
    }

    // don't let it scale below 1 msec
    if msec < 1 && com_timescale!.value != 0 {
        msec = 1
    }

    if com_dedicated!.integer != 0 {
        // dedicated servers don't want to clamp for a much longer
        // period, because it would mess up all the client's views
        // of time.
        if msec > 500 {
            Com_Printf("Hitch warning: %i msec frame time\n", msec)
        }
        clampTime = 5000
    } else if com_sv_running!.integer == 0 {
        // clients of remote servers do not want to clamp time, because
        // it would skew their view of the server's time temporarily
        clampTime = 5000
    } else {
        // for local single player gaming
        // we may want to clamp the time to prevent players from
        // flying off edges when something hitches.
        clampTime = 200
    }

    if msec > clampTime {
        msec = clampTime
    }

    return msec
}

/// Source: oracle/codemp/qcommon/common.cpp:1601
var lastTime: Int32 {
    get { world.lastTime }
    set { world.lastTime = newValue }
}

/**
```
=================
Com_Frame
=================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:1593
public func Com_Frame() {
    // Port-note: Raven wraps the frame in a try, and the catch prints the text a Com_Error throws for an ERR_DROP and returns.
    // Row C1: the three throw sites of Com_Error print the text and end the process, so no throw reaches this function.

    // Port-note: Row G1. Raven starts the C++ timer G2PerformanceTimer_PreciseFrame, a `timing_c` of the C++ track that stage E5 gives no storage.
    // Raven wrote: G2PerformanceTimer_PreciseFrame.Start();
    portMissing("Com_Frame", source: "oracle/codemp/qcommon/common.cpp:1593")
    var msec: Int32
    let minMsec: Int32
    var key: Int32

    var timeBeforeFirstEvents: Int32
    var timeBeforeServer: Int32
    var timeBeforeEvents: Int32
    var timeBeforeClient: Int32
    var timeAfter: Int32

    // bk001204 - init to zero.
    //  also:  might be clobbered by `longjmp' or `vfork'
    timeBeforeFirstEvents = 0
    timeBeforeServer = 0
    timeBeforeEvents = 0
    timeBeforeClient = 0
    timeAfter = 0

    // old net chan encryption key
    // Raven wrote 0x87243987, which an int holds as this negative value.
    key = -2027669113

    // write config file if anything changed
    Com_WriteConfiguration()

    // if "viewlog" has been modified, show or hide the log console
    if com_viewlog!.modified {
        if com_dedicated!.value == 0 {
            Sys_ShowConsole(com_viewlog!.integer, false)
        }
        com_viewlog!.modified = false
    }

    //
    // main event loop
    //
    if com_speeds!.integer != 0 {
        timeBeforeFirstEvents = Sys_Milliseconds()
    }

    // we may want to spin here if things are going too fast
    if com_dedicated!.integer == 0 && com_maxfps!.integer > 0 && com_timedemo!.integer == 0 {
        minMsec = 1000 / com_maxfps!.integer
    } else {
        minMsec = 1
    }
    repeat {
        com_frameTime = Com_EventLoop()
        if lastTime > com_frameTime {
            lastTime = com_frameTime // possible on first frame
        }
        msec = com_frameTime - lastTime
    } while msec < minMsec
    Cbuf_Execute()

    lastTime = com_frameTime

    // mess with msec if needed
    com_frameMsec = msec
    msec = Com_ModifyMsec(msec)

    //
    // server side
    //
    if com_speeds!.integer != 0 {
        timeBeforeServer = Sys_Milliseconds()
    }

    SV_Frame(msec)

    // if "dedicated" has been modified, start up
    // or shut down the client system.
    // Do this after the server may have started,
    // but before the client tries to auto-connect
    if com_dedicated!.modified {
        // get the latched value
        _ = Cvar_Get("dedicated", "0", 0)
        com_dedicated!.modified = false
        if com_dedicated!.integer == 0 {
            CL_Init()
            Sys_ShowConsole(com_viewlog!.integer, false)
            CL_StartHunkUsers() //fire up the UI!
        } else {
            CL_Shutdown()
            Sys_ShowConsole(1, true)
        }
    }

    //
    // client system
    //
    if com_dedicated!.integer == 0 {
        //
        // run event loop a second time to get server to client packets
        // without a frame of latency
        //
        if com_speeds!.integer != 0 {
            timeBeforeEvents = Sys_Milliseconds()
        }
        _ = Com_EventLoop()
        Cbuf_Execute()

        //
        // client side
        //
        if com_speeds!.integer != 0 {
            timeBeforeClient = Sys_Milliseconds()
        }

        CL_Frame(msec)

        if com_speeds!.integer != 0 {
            timeAfter = Sys_Milliseconds()
        }
    }

    //
    // report timing information
    //
    if com_speeds!.integer != 0 {
        let all: Int32
        var sv: Int32
        let ev: Int32
        var cl: Int32

        all = timeAfter - timeBeforeServer
        sv = timeBeforeEvents - timeBeforeServer
        ev = timeBeforeServer - timeBeforeFirstEvents + timeBeforeClient - timeBeforeEvents
        cl = timeAfter - timeBeforeClient
        sv -= time_game
        cl -= time_frontend + time_backend

        Com_Printf("frame:%i all:%3i sv:%3i ev:%3i cl:%3i gm:%3i rf:%3i bk:%3i\n", com_frameNumber, all, sv, ev, cl, time_game, time_frontend, time_backend)
    }

    //
    // trace optimization tracking
    //
    if com_showtrace!.integer != 0 {
        Com_Printf("%4i traces  (%ib %ip) %4i points\n", c_traces, c_brush_traces, c_patch_traces, c_pointcontents)
        c_traces = 0
        c_brush_traces = 0
        c_patch_traces = 0
        c_pointcontents = 0
    }

    // old net chan encryption key
    // Raven multiplies by the unsigned 0x87243987, which wraps, and the wrapping multiply of the int holds the same bits.
    key = lastTime &* -2027669113

    com_frameNumber += 1

    // Port-note: Row G1. Raven adds the end of the C++ timer G2PerformanceTimer_PreciseFrame, a `timing_c` of the C++ track that stage E5 gives no storage.
    // Raven wrote: G2Time_PreciseFrame += G2PerformanceTimer_PreciseFrame.End();
    portMissing("Com_Frame", source: "oracle/codemp/qcommon/common.cpp:1593")

    if com_G2Report != nil && com_G2Report!.integer != 0 {
        G2Time_ReportTimers()
    }
    G2Time_ResetTimers()
}

/// Source: oracle/codemp/qcommon/common.cpp:1785
func Com_Shutdown() {
    CM_ClearMap()

    if logfile != 0 {
        FS_FCloseFile(logfile)
        logfile = 0
        com_logfile!.integer = 0 //don't open up the log file again!!
    }

    if com_journalFile != 0 {
        FS_FCloseFile(com_journalFile)
        com_journalFile = 0
    }

    MSG_shutdownHuffman()
    /*
    	// Only used for testing changes to huffman frequency table when tuning.
    	{
    		extern float Huff_GetCR(void);
    		char mess[256];
    		sprintf(mess,"Eff. CR = %f\n",Huff_GetCR());
    		OutputDebugString(mess);
    	}
    */
}

/// Source: oracle/codemp/qcommon/common.cpp:1815
func Com_Memcpy(_ dest: OpaquePointer?, _ src: OpaquePointer?, _ count: CUnsignedLong) {
    // AI: Raven calls memcpy on raw pointers. CommonBackend.memcpy makes the call in the view target.
    CommonBackend.memcpy(dest, src, count)
}

/// Source: oracle/codemp/qcommon/common.cpp:1820
func Com_Memset(_ dest: OpaquePointer?, _ val: Int32, _ count: CUnsignedLong) {
    // AI: Raven calls memset on raw pointers. CommonBackend.memset makes the call in the view target.
    CommonBackend.memset(dest, val, count)
}

/**
```
=====================
Q_acos

the msvc acos doesn't always return a value between -PI and PI:

int i;
i = 1065353246;
acos(*(float*) &i) == -1.#IND0

	This should go in q_math but it is too late to add new traps
	to game and ui
=====================
```
*/
/// Source: oracle/codemp/qcommon/common.cpp:2143
func Q_acos(_ c: Float) -> Float {
    let angle: Float

    angle = acos(c)

    // JKAShared declares M_PI as a Float too, so the qualifier picks the double of the C library, the type of Raven's macro.
    if Double(angle) > Foundation.M_PI {
        return Float(Foundation.M_PI)
    }
    if Double(angle) < -Foundation.M_PI {
        return Float(Foundation.M_PI)
    }
    return angle
}

/// Source: oracle/codemp/qcommon/common.cpp:2157
func Q_asin(_ c: Float) -> Float {
    let angle: Float

    angle = asin(c)

    // JKAShared declares M_PI as a Float too, so the qualifier picks the double of the C library, the type of Raven's macro.
    if Double(angle) > Foundation.M_PI {
        return Float(Foundation.M_PI)
    }
    if Double(angle) < -Foundation.M_PI {
        return Float(Foundation.M_PI)
    }
    return angle
}

/// Source: oracle/codemp/qcommon/common.cpp:2179
func Com_ParseTextFile(_ file: String, _ parser: CGenericParser2, _ cleanFirst: Bool = true) -> Bool {
    // TODO: Port Com_ParseTextFile
    portMissing("Com_ParseTextFile", source: "oracle/codemp/qcommon/common.cpp:2179")
}

/// Source: oracle/codemp/qcommon/common.cpp:2204
func Com_ParseTextFileDestroy(_ parser: CGenericParser2) {
    // TODO: Port Com_ParseTextFileDestroy
    portMissing("Com_ParseTextFileDestroy", source: "oracle/codemp/qcommon/common.cpp:2204")
}

/// Source: oracle/codemp/qcommon/common.cpp:2209
func Com_ParseTextFile(_ file: String, _ cleanFirst: Bool, _ writeable: Bool) -> CGenericParser2? {
    // TODO: Port Com_ParseTextFile
    portMissing("Com_ParseTextFile", source: "oracle/codemp/qcommon/common.cpp:2209")
}

// MARK: - The C library rand

/// The seed of the C library `rand`, on the world.
/// Source: oracle/codemp/server/sv_init.cpp:625
var holdrand: UInt32 {
    get { world.holdrand }
    set { world.holdrand = newValue }
}

/// The C library `srand` of the MSVC runtime, which sets the seed.
/// Source: oracle/codemp/server/sv_init.cpp:625
// AI: Raven calls the C library srand of the MSVC runtime. The host has no such function, so this is its body over `holdrand`, the form of Sources/JKAMP_BG/bg_lib.swift.
func srand(_ seed: UInt32) {
    holdrand = seed
}

/// Source: oracle/codemp/server/sv_init.cpp:625
/// This overload is the guide's form for an `int` argument to an `unsigned` parameter, and it converts the value once.
func srand(_ seed: Int32) {
    srand(UInt32(bitPattern: seed))
}

/// The C library `rand` of the MSVC runtime, a value from 0 to 0x7fff.
/// Source: oracle/codemp/server/sv_init.cpp:626
// AI: Raven calls the C library rand of the MSVC runtime. The host has no such function, so this is its body over `holdrand`, the form of Sources/JKAMP_BG/bg_lib.swift.
func rand() -> Int32 {
    holdrand = holdrand &* 214013 &+ 2531011
    return Int32((holdrand >> 16) & 0x7fff)
}

/// Source: oracle/codemp/game/q_shared.h:1591
func random() -> Float {
    Float(rand() & 0x7fff) / Float(0x7fff)
}
