# The cgame host gate docket

Stage 5 of the cgame, item 4 of `context.md`. Seven rows, each with the game precedent and a proposed default. Every citation is read at the line. The rows wait for the cgame transcription rounds to end, and for a ratification walk.

## H1, the shell target

The game shell is `Sources/jampgame/jampgame.swift`. `dllEntry` at :11-24 sets the transport, a fresh `GameWorld` with the rule 24 line at :14, `bg = BgState(consumer: .game, maxPoolSize: 3_000_000)` at :17 with Raven's `MAX_POOL_SIZE` cite, the two channel lines at :18-19, `installBgChannel()` at :20, and `sharedChannel` at :22-23. `vmMain` at :27-42 takes twelve `Int` words and switches on the command at :43, one arm per export.

Raven's cgame `vmMain` is `oracle/codemp/cgame/cg_main.c:190-355`, with 32 arms from `CG_INIT` at :193 to `CG_FX_CAMERASHAKE` at :346 and the `CG_Error` default at :355. Some arms carry inline bodies, `CG_MAP_CHANGE` at :307, `CG_AUTOMAP_INPUT` at :314, `CG_FX_CAMERASHAKE` at :346, and the lerp and ghoul2 getters. `BgConsumer` at `Sources/JKAMP_BG/bg_local.swift:10-13` has `cgame`, and the initializer at :339 takes `consumer` and `maxPoolSize`. Raven's cgame pool is `#define MAX_POOL_SIZE 2048000` at `oracle/codemp/game/bg_misc.c:3314`.

Proposed: `Sources/cgame/cgame.swift` mirrors `jampgame.swift`. `dllEntry` sets the transport, `world = CGameWorld()` with the same rule 24 line, `bg = BgState(consumer: .cgame, maxPoolSize: 2_048_000)` with the bg_misc.c:3314 cite, the two channel lines, `installBgChannel()`, and `sharedChannel`. `vmMain` has one arm per cg_main.c case in Raven's order, and an inline body stays in its arm as the game's do.

## H2, the product name and the copy

`.github/workflows/build.yml:9-15` names `jampgamex86_64.so` and `jampgamex86_64.dll`, and :15 records no macOS lane by the user's word of 2026-10-28. :62 and :87 build `--product jampgame`, and :89-93 zip the module from `--show-bin-path`. OpenJK builds the module name as `"%s" ARCH_STRING DLL_EXT` at `../OpenJK/shared/sys/sys_main.cpp:605`, with `ARCH_STRING` `"arm64"` and `DLL_EXT` `".dylib"` in `q_platform.h:111-116`, so the engine loads `cgamearm64.dylib`. SwiftPM writes `libcgame.dylib`.

Proposed: `.library(name: "cgame", type: .dynamic, targets: ["cgame"])` beside `Package.swift:10`. A local step copies the product to `cgamearm64.dylib`. CI gains `--product cgame` lanes for Linux and Windows in the same zip shape, `cgamex86_64.so` and `.dll`, and still no macOS lane. The CI change is its own row by the CI ruling.

## H3, the loader

`Sources/jampsmoke/main.swift` opens the library at :39, reads `dllEntry` and `vmMain` at :44-51, hands over the recorder syscall from `CJKASyscall` at :53-54, and calls `vmMain(39, ...)` at :59, `GAME_GETITEMINDEXBYTAG`, which needs no engine. It links no game module (:56), so it is generic over any library with the two symbols. `CG_INIT` calls renderer and client traps, and the recorder returns zeros.

Proposed: jampsmoke takes a command number and an expected answer as arguments, so one loader serves both modules. The cgame smoke sends one engine-free command after `dllEntry`, `CG_CROSSHAIR_PLAYER` or `CG_LAST_ATTACKER`, which read the fresh world. `CG_INIT` stays out of the smoke until a fake that knows the traps exists.

## H4, the tests

`Package.swift:66-70` has `JKASharedTests`, `JKAMPTests`, `JKAMP_GameTests` on `JKAMP_GameLogic` and `JKATestSupport`, and `jampgameTests` on `CJKAMP_Game` with no link to the dylib. `Tests/jampgameTests/JampgameSmokeTests.swift:8` runs jampsmoke as a process. `Tests/JKAMP_GameTests/SyscallGameTests.swift:7-17` drives `Syscall.transport` and the one world serially through `Sources/JKATestSupport/RecordingTransport.swift`.

Proposed: `JKAMP_CGameTests` on `JKAMP_CGameLogic` and `JKATestSupport` mirrors `JKAMP_GameTests` with one transport test first. `cgameTests` on `CJKAMP_CGame` runs the smoke process. Both run under `--no-parallel`.

## H5, the referee

`docs/porting-rules.md:3`, `:7`, and `:36` make the lockstep referee the proof of a game step. `notes/2026-10-29/cgame-scout.md:270-276` records that the fork's `sv_referee` traces only `VM_GAME`, wraps only `SV_GameSystemCalls`, gates only `SV_Frame`, and runs on `openjkded.arm64` with no client. Item 11 at :316 says the host gate has no referee, and only a listen server run by a person loads a Swift cgame. `jka-rust/tools/cgame-referee/` holds a recorder shim with 233 traps and 32 exports.

A client referee adds a `CL_CgameSystemCalls` wrapper, a `VM_CGAME` trace in `VM_Call`, a client frame gate, and a legacy-ABI force for the cgame.

Proposed: stage 5 ships on build, tests, the smoke run, and one listen-server run by a person (`notes/2026-10-29/human-recordings.md:7`). The client referee becomes its own fork branch and docket, with the jka-rust shim's trace format as its precedent. This row needs the user's ruling, because rule 16 ends a step at a referee-green run.

## H6, the D10 move

`notes/2026-10-31/departures-ledger.md:18`. The generated `Sources/JKAMP_CGameLogic/Generated/BgChannel.swift:10-11` sets `bg.error` and `bg.print` inside `installBgChannel()`, where the game sets them in its shell at `jampgame.swift:18-19`.

Proposed: the shell gains the two lines over `JKAMP_CGameLogic.Com_Error` and `Com_Printf`, and `channel.py` stops writing them for the cgame consumer. The generator change reruns every generator in its own commit before the shell commit.

## H7, the access levels

`world` is public at `cg_local.swift:207`. Internal: `cg`, `cgs`, `cg_entities` at `cg_main.swift:54`, `:57`, `:60`; `CG_Init` :1136, `CG_Shutdown` :1164, `CG_CrosshairPlayer` :652, `CG_LastAttacker` :658, `CG_MiscEnt` :601, `CG_Error` :670, `Com_Error` :676, `Com_Printf` :682; `CG_ConsoleCommand` `cg_consolecmds.swift:150`; `CG_DrawActiveFrame` `cg_view.swift:551`; `CG_MouseEvent`, `CG_EventHandling`, `CG_KeyEvent` `cg_newDraw.swift:102`, `:144`, `:150`; `CG_Trace`, `CG_G2Trace`, `CG_PointContents` `cg_predict.swift:89`, `:102`, `:115`; `CG_CalcEntityLerpPositions`, `CG_ROFF_NotetrackCallback` `cg_ents.swift:377`, `:436`; `CG_ImpactMark` `cg_marks.swift:212`. `CG_RagCallback` is private at `cg_main.swift:589`. The game makes every vmMain-level function public, `G_InitGame` at `g_main.swift:745`.

Proposed: one access-level commit before the shell commit makes every function a vmMain arm calls public, and `cg`, `cgs`, and `cg_entities` with them for the inline arms. `CG_RagCallback` becomes public too. This also serves the public-surface goal the user stated on 2026-10-31 for a fork's mod target.
