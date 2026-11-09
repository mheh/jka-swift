# The common round, the qcommon core of the dedicated host

This record holds the round of `Sources/JKAMP_DedLogic/common.swift`, the stem of `oracle/codemp/qcommon/common.cpp` in unit mp-engine-ded. The tree is the worktree `/tmp/jka-ded-common` on the branch `dedicated-round-common`, off master at 1cdd22f. The code commit is 2b65181. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The stub had no skeleton header on master, because commit 1c34a68 adopted it with the host access words and data tables. So the round removed no header. The stub held 42 functions with a `portMissing` body. The drafter gave 45 holes over the stem, and the hole round filled each hole that a ruled form or a hand piece of this round covers.

- Filled, 31 of 42 functions: Com_BeginRedirect, Com_EndRedirect, Com_Printf, Com_DPrintf, Com_Error, Com_Quit_f, Com_ParseCommandLine, Com_SafeMode, Com_StartupVariable, Com_AddStartupCommands, Info_Print, Com_StringContains, Com_Filter, Com_FilterPath, Com_HashKey, Com_InitJournaling, Com_RunAndTimeServerPacket, Com_Error_f, Com_Freeze_f, Com_Crash_f, Com_Init, Com_WriteConfigToFile, Com_WriteConfiguration, Com_WriteConfig_f, Com_ModifyMsec, Com_Frame, Com_Shutdown, Com_Memcpy, Com_Memset, Q_acos, and Q_asin. Com_Printf, Com_Error, and Com_Frame still hold the holes of the table below.
- Stubs with a signature marker, 7: Com_RealTime, Com_GetRealEvent, Com_PushEvent, Com_GetEvent, the two Com_ParseTextFile functions, and Com_ParseTextFileDestroy. Each has a Port-note that names its row.
- Bodies that stop at their first line, 4: Com_OPrintf, Com_InitPushEvent, Com_EventLoop, and Com_Milliseconds.
- The `#ifdef _XBOX`, `_DEBUG`, `USE_CD_KEY`, and `MEM_DEBUG` arms drop, because WinDed Release defines none of them. The `DEDICATED` arms stay, `jampserver.cfg` and `dedicated` at "2". The `G2_PERFORMANCE_ANALYSIS` arms stay, by row C7 of `notes/2026-11-03/dedicated-cxx-docket.md`, so `com_G2Report` registers and the frame timers are holes.
- The `try` of Com_Init and Com_Frame has no Swift form. A Port-note at each site says that the throw sites of Com_Error hold the markers of row C1, so no throw reaches the catch.
- The static locals `lastErrorTime` and `errorCount` of Com_Error and `lastTime` of Com_Frame are stored properties of `EngineWorld`, each with a forward under Raven's name, the static local form of `docs/transcription.md`. The file-scope `rd_flush` takes the same form.
- `Q3_VERSION`, `CPUSTRING`, and `buildDate` are hand constants at the top of the stem, the text the shell held before commit 560b1b6 and the `buildDate` form of `HAND_MACROS`. Each has a rule 24 line or the Port-note of the Windows arm.
- Com_Crash_f traps with `fatalError` under a rule 19 note, because Raven's store through a NULL `int *` is undefined.
- The calls to the client functions go to the stubs of `null_client.swift`, Raven's null client of the dedicated build: CL_ConsolePrint, CL_Disconnect, CL_FlushMemory, CL_Shutdown, CL_Init, CL_InitKeyCommands, CL_StartHunkUsers, CL_Frame, CL_PacketEvent, and Key_WriteBindings. The renderer timers of `tr_ghoul2.cpp` have no Swift stub, so they take the hole form of row Z6 of `notes/2026-11-08/dedicated-round-z-memman-pc.md`.
- `toupper` and `M_PI` take a module qualifier with a one-line comment, the precedent of `JKAShared.tolower` in `cvar.swift`. `M_PI` is the double of the C library, because JKAShared declares a `Float` of the same name and Raven's macro is a double literal.
- The third Com_ParseTextFile holds its Port-note inside the body, the form of row 7 of `notes/2026-11-04/dedicated-open-rows-ledger-2.md`. The drafter gives that overload the signature of the first one, and the note keeps the hand function, so the gate builds no redeclaration.

## The rule 24 sites

- The redirect, at Com_BeginRedirect, Com_EndRedirect, and the two flushes of Com_Printf. Raven keeps the address of the caller's buffer, and the port keeps the text and hands each flush a buffer of `rd_buffersize` bytes. The test of the `rd_buffer` pointer reads `rd_buffersize`.
- Com_ParseCommandLine. Each console line is the text of its line, read out of the command line at the NUL that ends it, the form of `cmd_argv` in Cmd_TokenizeString.
- Com_SafeMode. Raven's NUL into the first byte of the line is the empty text.
- Com_StringContains returns the text from the match, and Com_Filter steps its name cursor to the length of the name less the length of that text.
- Com_Error. A trap follows Sys_Error, because the Swift signature of Sys_Error returns, the form of `trap_Error`.
- Com_Printf. The local time text comes from `CommonBackend.asctime`.
- Com_Memcpy and Com_Memset call `CommonBackend.memcpy` and `CommonBackend.memset`.
- The `rd_flush` forward and the `EngineWorld` property hold a Swift closure in place of a C function pointer.

## The hand pieces

The view target holds one new file, `Sources/JKAMP_Ded/CommonViews.swift`. Each piece carries one `// AI:` line. The file imports the C library module of its platform under `#if canImport`, the form of `ZoneBlocks.swift`.

| Piece | Raven's counterpart | What it does |
|---|---|---|
| `Com_Memset(_:_:_:at:)` over a `CharBuf` | `Com_Memset (o, ' ', 20-l)` at common.cpp:526 | fills bytes from a byte offset of the buffer, for the write cursor `o` of Info_Print |
| `CommonBackend.memcpy` | `memcpy(dest, src, count)` at common.cpp:1817 | the C library copy over the two `OpaquePointer?` arguments of Com_Memcpy |
| `CommonBackend.memset` | `memset(dest, val, count)` at common.cpp:1822 | the C library fill over the `OpaquePointer?` of Com_Memset, which Cvar_Restart_f calls |
| `CommonBackend.asctime` | `localtime( &aclock )` and `asctime( newtime )` at common.cpp:177 and :180 | the text of the local time, read through the `struct tm` pointer in the view target |

`EngineWorld.swift` gains one section, `// MARK: - common.cpp`, before the section of net_chan.cpp, with `rd_flush`, `lastErrorTime`, `errorCount`, and `lastTime`. A wave branch that adds its own section elsewhere merges clean.

## Rows for the user

- Row S1, the event ring and its signatures. Raven: `static sysEvent_t com_pushedEvents[MAX_PUSHED_EVENTS]` at common.cpp:752, `sysEvent_t Com_GetRealEvent( void )` at :789, `void Com_PushEvent( sysEvent_t *event )` at :850, `sysEvent_t Com_GetEvent( void )` at :881, and `sysEvent_t Sys_GetEvent( void )` at oracle/codemp/null/win_main.cpp:1160. C type: `sysEvent_t` of qcommon.h, a record by value and by pointer. Callers: Com_InitPushEvent (:837), Com_EventLoop (:921), and Com_Milliseconds (:1028), which Com_Init calls at :1383 and :1402, Com_Freeze_f at :1080, and the server at sv_main.cpp:240 and :498, sv_init.cpp:625, and sv_game.cpp:1690. Com_Frame calls Com_EventLoop at :1648. Proposed: `sysEvent_t` joins `HOST_ROOTS`, the form of `bitStorage_t` in row 14 of the first ledger, so the view `SysEvent` and the ring of 1024 records on `EngineStorage` come out of the run. The `sysEvent_t *` parameter is the view, row 1 of the first ledger. A `sysEvent_t` return takes a new RETURNS kind `record`, the view over one zeroed record per function on `EngineStorage`, the per-function allocation of BYTE_STORAGE_LOCALS. The caller's `ev` is a `SysEvent.scratch` slot, and Raven's `ev = Com_GetEvent()` reads `ev.copy(from: Com_GetEvent())`, the record copy of `docs/transcription.md`. This row blocks Com_Init at its first call and Com_Frame at its event loop.
- Row S2, `bufData` of Com_EventLoop. Raven: `byte bufData[MAX_MSGLEN]` at common.cpp:924, which `MSG_Init( &buf, bufData, sizeof( bufData ) )` takes at :927. C type: a `byte` array on the stack. Caller: Com_EventLoop alone. Proposed: a BYTE_STORAGE_LOCALS key `("bufData", "Com_EventLoop")`, a `Slots<JKAShared.byte>` of `MAX_MSGLEN` named `bufData_Com_EventLoop`, the form of `send_buf_Netchan_Transmit` in row 2 of the fourth ledger.
- Row C1, the throw of Com_Error. Raven: `throw ("DISCONNECTED\n")` at common.cpp:312, `throw ("DROPPED\n")` at :326, and `throw ("NEED CD\n")` at :336, caught at :1439 in Com_Init and at :1762 in Com_Frame. C type: `const char *`, a C++ exception. Callers: every Com_Error with ERR_DROP, ERR_DISCONNECT, ERR_SERVERDISCONNECT, or ERR_NEED_CD. Rule 22 makes Com_Error return `Never`, and a Swift function that returns Never cannot throw. No precedent exists. Proposed: the shell holds the frame loop, and Com_Error ends an ERR_DROP by a call into a `Never` loop entry in the shell that prints the text and runs the next Com_Frame, the form rule 22 names for the longjmp of the game. The stack of each dropped frame stays, so the row also needs a ruling on that growth.
- Row G1, the Ghoul2 frame timers. Raven: `G2PerformanceTimer_PreciseFrame.Start()` at common.cpp:1598, and `G2Time_PreciseFrame += G2PerformanceTimer_PreciseFrame.End()`, `G2Time_ReportTimers()`, and `G2Time_ResetTimers()` at :1768 to :1775. C type: the C++ class `timing_c` of timing.h and an `int` and two functions of renderer/tr_ghoul2.cpp. Caller: Com_Frame alone. Proposed: no change in this round, the form of row Z6. The Ghoul2 stage of row E5 gives the timer and the two functions, and row C7 puts the `timing_c` on `EngineWorld`. Until then each frame stops at its first line, so the row also asks whether the two holes can wait behind a ruled no-op for a profile path that changes no game state.
- Row F1, FS_Write of a `char` buffer. Raven: `FS_Write(msg, strlen(msg), logfile)` at common.cpp:188. C type: `const void *buffer` of FS_Write at files_pc.cpp, which the stub spells `OpaquePointer?`. Callers in this stem: Com_Printf when `logfile` is set. Proposed: an `inout CharBuf` overload of FS_Write after the original in `files_pc.swift`, the form of the FS_Read overload of row 7 of the second ledger, with a body through `withSlots` of `CharBuf.swift`, the form of row 6 of the fifth ledger. The overload belongs to the files_pc round.
- Row O1, OutputDebugString. Raven: `OutputDebugString(msg)` at common.cpp:235 under `#ifndef __linux__`. C type: a Windows function that no header of the parse declares. Callers: Com_OPrintf, which chash.h:57 calls. Proposed: the rule of row 7 of the fifth ledger keeps the hole. A later row can rule Sys_Print, the stream of the dedicated console, as the form.
- Row R1, the qtime_t signature. Raven: `int Com_RealTime(qtime_t *qtime)` at common.cpp:713. C type: `qtime_t *`, which `JKAMP.Qtime` views. Caller: the `G_REAL_TIME` arm at sv_game.cpp:679. Proposed: a host PARAMS row that gives the parameter `JKAMP.Qtime?`, the view of `trap_RealTime` at `Sources/JKAMP_Game/Generated/g_syscalls.swift:433`, optional because Raven tests NULL at :718. The body then needs a `CommonBackend.localtime` that fills the view.
- Row C3, the three CGenericParser2 functions. Raven: common.cpp:2179, :2204, and :2209. Row C3 of `notes/2026-11-03/dedicated-cxx-docket.md` ports GP2 with the RMG stage, so no change in this round.
- Row V1, the version constants. `Q3_VERSION` of game_version.h and `CPUSTRING` of q_shared.h have no re-export in the host target, so the stem holds their text. Proposed: the reexport of `JKAMP_Ded` reads game_version.h, and `CPUSTRING` keeps a hand value per platform, because Raven's arms test compiler macros.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| Com_Printf | :188 | `FS_Write(msg, strlen(msg), logfile)` | F1 |
| Com_OPrintf | :235 | `OutputDebugString(msg)` | O1 |
| Com_Error | :312 | `throw ("DISCONNECTED\n")` | C1 |
| Com_Error | :326 | `throw ("DROPPED\n")` | C1 |
| Com_Error | :336 | `throw ("NEED CD\n")` | C1 |
| Com_InitPushEvent | :837 | `memset( com_pushedEvents, 0, sizeof(com_pushedEvents) )` | S1 |
| Com_EventLoop | :921 | the whole body, `ev` and `bufData` | S1, S2 |
| Com_Milliseconds | :1028 | the whole body, `ev` | S1 |
| Com_Frame | :1598 | `G2PerformanceTimer_PreciseFrame.Start()` | G1 |
| Com_Frame | :1768 | the end, report, and reset of the Ghoul2 timers | G1 |

The seven signature markers of the bodies section hold one `portMissing` each. The file holds 17 `portMissing` calls in all. `grep -c Unsafe` gives 0 on common.swift and on EngineWorld.swift.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The changed files give 11 warnings: 2 "will never be executed" after the holes of Com_EventLoop and Com_Frame, 1 "written to, but never read" for Raven's dead `key` of Com_Frame, and 8 deprecation warnings for the `M_PI` of the C library, which the game files also give. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests, 145 pass, 1 skipped, the interpreter test. The jampded smoke test passes, and its first trap is now the Sys_Print stub that the version line of Com_Init reaches. |
| `draftcheck.py --unit mp-engine-ded --stem common` | exit 0, 11 of 42 hand functions replaced, 31 kept, 47 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass. |

The first draftcheck run gave exit 1 with 1 defect, `invalid redeclaration of 'Com_ParseTextFile()'`, which the move of the Port-note into the third body fixed. The build and the tests ran again after that move. The 47 holes are in the drafter's output, not in the working tree.
