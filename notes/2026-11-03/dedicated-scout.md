# The dedicated server scout

This record holds the scout survey of the next product, the MP dedicated server, OpenJK's `openjkded` binary. The tree is master at d19ede5. The OpenJK submodule `openjk/` is at commit 35e4184f, and `diff -rq ../OpenJK/codemp/server openjk/codemp/server` reports no difference. No file under `Sources/`, `docs/`, `Package.swift`, `tools/`, `openjk/`, `oracle/`, or `jka-rust/` changed. The parse counts in sections 3 and 4 come from libclang runs in memory through `tools/oracle-closure/.venv/bin/python`, and each run wrote no file.

## 1. The source set

### The OpenJK build

`openjk/CMakeLists.txt:40` declares the option `BuildMPDed`, and `openjk/CMakeLists.txt:171` names the binary `openjkded.${Architecture}`. The `BuildMPDed` block at `openjk/codemp/CMakeLists.txt:627-715` starts from the file list that the engine and the dedicated server share (`:630`), adds the defines `_CONSOLE` and `DEDICATED` (`:631`), the dedicated renderer files (`:634-653`), the null files (`:655-662`), and the Unix sys files (`:685-698`), and links the botlib library (`:628`, `:176`).

The shared list is the block at `openjk/codemp/CMakeLists.txt:52-350`. It also takes `SharedCommonFiles` (`:264`), which `openjk/CMakeLists.txt:370-379` defines as `q_color.c`, `q_math.c`, and `q_string.c` with their headers.

The table counts lines with `wc -l` on each file the two blocks name. The dedicated set holds 139 files, 75756 lines of source and 21146 lines of headers, before the botlib library.

| Folder | Source lines | Header lines | Source files and lines | CMake lines |
|---|---:|---:|---|---|
| `codemp/qcommon` | 25839 | 5162 | `files.cpp` 4473, `msg.cpp` 3165, `common.cpp` 2069, `cm_patch.cpp` 1808, `cvar.cpp` 1680, `cm_trace.cpp` 1620, `stringed_ingame.cpp` 1270, `GenericParser2.cpp` 1198, `cm_load.cpp` 1120, `net_ip.cpp` 1085, `RoffSystem.cpp` 1080, `cmd.cpp` 995, `z_memman_pc.cpp` 864, `net_chan.cpp` 681, `cm_test.cpp` 467, `huffman.cpp` 446, `md5.cpp` 354, `matcomp.cpp` 326, `vm.cpp` 297, `cm_polylib.cpp` 283, `stringed_interface.cpp` 232, `md4.cpp` 208, `persistence.cpp` 94, `q_shared.cpp` 24 | `:218-262` |
| `codemp/server` | 12908 | 567 | `sv_gameapi.cpp` 3165, `sv_ccmds.cpp` 2016, `sv_client.cpp` 1557, `sv_main.cpp` 1263, `sv_init.cpp` 1130, `sv_world.cpp` 915, `sv_snapshot.cpp` 892, `sv_bot.cpp` 814, `sv_referee.cpp` 630, `sv_challenge.cpp` 186, `sv_net_chan.cpp` 184, `sv_game.cpp` 156 | `:316-334` |
| `codemp/server/NPCNav` | 2792 | 288 | `navigator.cpp` 2792 | `:317-318` |
| `codemp/rd-dedicated` | 20781 | 1892 | `G2_bones.cpp` 4667, `tr_ghoul2.cpp` 3983, `tr_shader.cpp` 3420, `G2_API.cpp` 2754, `G2_misc.cpp` 1906, `tr_model.cpp` 1756, `G2_surfaces.cpp` 683, `tr_init.cpp` 683, `tr_skin.cpp` 395, `G2_bolts.cpp` 334, `tr_main.cpp` 94, `tr_mesh.cpp` 64, `tr_backend.cpp` 42 | `:634-651` |
| `codemp/ghoul2` | 45 | 969 | `G2_gore.cpp` 45 | `:280-285`, `:635` |
| `codemp/icarus` | 8706 | 2205 | `Sequencer.cpp` 2476, `TaskManager.cpp` 2009, `Q3_Interface.cpp` 1023, `GameInterface.cpp` 747, `BlockStream.cpp` 679, `Instance.cpp` 664, `Sequence.cpp` 578, `Q3_Registers.cpp` 448, `Interface.cpp` 43, `Memory.cpp` 39 | `:289-312` |
| `shared/sys` | 2294 | 337 | `sys_main.cpp` 822, `sys_unix.cpp` 644, `con_tty.cpp` 535, `sys_event.cpp` 150, `con_log.cpp` 78, `snapvector.cpp` 65 | `:345-347`, `:685-695` |
| `shared/qcommon` | 2046 | 888 | `q_math.c` 1433, `q_string.c` 456, `q_color.c` 157 | `openjk/CMakeLists.txt:370-379` |
| `shared/qcommon/safe` | 117 | 134 | `files.cpp` 117 | `:272-276` |
| `codemp/null` | 228 | 0 | `null_client.cpp` 87, `null_snddma.cpp` 71, `null_renderer.cpp` 36, `null_input.cpp` 34 | `:655-660` |
| Headers only | 0 | 8704 | `codemp/game` 5074 (`anims.h`, `bg_public.h`, `bg_weapons.h`, `g_public.h`, `surfaceflags.h`), `codemp/rd-common` 802, `codemp/client` 783, `codemp/ui` 762, `codemp/cgame` 753 (`cg_public.h`), `codemp/botlib/botlib.h` 530 | `:193-214`, `:338-341`, `:636-637` |

`q_shared.cpp` is a wrapper. Its line 24 is `#include "qcommon/q_shared.c"`.

The botlib is a static library that both binaries link (`openjk/codemp/CMakeLists.txt:164`, `:176`). It holds 28 `.cpp` files (`:98-125`) with 32656 lines, and 3781 lines of headers (`cat openjk/codemp/botlib/*.cpp | wc -l`), plus `shared/qcommon/safe/string.cpp` (`:151`).

The full client `BuildMPEngine` (`openjk/codemp/CMakeLists.txt:354-623`) takes the same shared list (`:357`) and adds files the dedicated binary does not take:

- 26 `client/*.cpp` files with 35800 lines (`:428-467`), the cgame and ui hosts, the console, the input, the FX system, and the sound system.
- `mp3code/*.c` with 8319 lines (`:485-516`).
- `shared/sdl/*.cpp` with 2450 lines, `sys_main.cpp`, `sys_event.cpp`, and `con_log.cpp` (`:520-532`).
- The `Ratl` and `Ravl` headers (`:471-483`).
- SDL2, OpenGL, and OpenAL (`:362-414`).

The client renderer is a separate library, `codemp/rd-vanilla`, with 33 `.cpp` files and 48638 lines (`openjk/codemp/CMakeLists.txt:41-44`). The dedicated binary compiles `rd-dedicated` into itself in its place (`:633-653`).

### Raven's build

Raven's dedicated project is `oracle/codemp/WinDed.vcproj`. Its Release configuration defines `WIN32,NDEBUG,_CONSOLE,DEDICATED,BOTLIB,_WINDOWS` (`WinDed.vcproj:32`). The file list runs from `:138` to `:894`. The table counts lines with `wc -l` on each `RelativePath` the project names, with the path matched without case. The set holds 130977 lines of source and 32017 lines of headers. Raven compiles the botlib into the binary, with no library.

| Folder | Source lines | Header lines | Source files | vcproj lines |
|---|---:|---:|---|---|
| `qcommon` | 32305 | 4510 | 30 files, among them `files_pc.cpp` 3130, `msg.cpp` 3318, `common.cpp` 2240, `cm_trace.cpp` 1992, `cm_patch.cpp` 1809, `cm_terrain.cpp` 1720, `cm_draw.cpp` 1490, `unzip.cpp` 1337, `vm_x86.cpp` 1166, `cm_randomterrain.cpp` 1091, `vm.cpp` 954, `vm_interpreted.cpp` 905 | `:138-294` |
| `botlib` | 32144 | 1802 | 28 `.cpp` files | `:455-611` |
| `renderer` | 21210 | 6776 | `tr_ghoul2.cpp` 5509, `tr_shader.cpp` 4283, `tr_image.cpp` 3373, `tr_backend.cpp` 2328, `tr_model.cpp` 1838, `tr_main.cpp` 1631, `tr_init.cpp` 1532, `tr_mesh.cpp` 423, `matcomp.c` 293 | `:401-425` |
| `ghoul2` | 10649 | 945 | `G2_bones.cpp` 4908, `G2_API.cpp` 2783, `G2_misc.cpp` 1950, `G2_surfaces.cpp` 677, `G2_bolts.cpp` 331 | `:301-325` |
| `server` | 9281 | 438 | the nine `sv_*.cpp` files, `sv_client.cpp` 1855 and `sv_game.cpp` 1773 the largest | `:332-359` |
| `icarus` | 8604 | 2056 | ten `.cpp` files | `:727-793` |
| `RMG` | 5531 | 1033 | twelve `RM_*.cpp` files | `:800-872` |
| `zlib32` | 4034 | 571 | `deflate.cpp`, `inflate.cpp`, `zipcommon.cpp` | `:879-894` |
| `server/NPCNav` | 2832 | 280 | `navigator.cpp` 2783, `gameCallbacks.cpp` 49 | `:365-371` |
| `win32` | 1874 | 84 | `win_net.cpp` 1222, `win_shared.cpp` 547 | `:442-448` |
| `null` | 1730 | 0 | `win_main.cpp` 1504, `null_glimp.cpp`, `null_client.cpp`, `null_snddma.cpp`, `null_renderer.cpp`, `null_input.cpp` | `:379-394` |
| `png` | 783 | 73 | `png.cpp` | `:431-434` |

`qcommon/q_math.cpp` and `qcommon/q_shared.cpp` are wrappers of 4 lines each. They include `../game/q_math.c` (1670 lines) and `../game/q_shared.c` (1370 lines).

### What one tree has and the other lacks

OpenJK has these, and Raven's dedicated project has no file of the name:

- `server/sv_gameapi.cpp`, `sv_gameapi.h`, `sv_challenge.cpp`, `sv_referee.cpp`, and `sv_referee.h` (`openjk/codemp/CMakeLists.txt:322`, `:330-333`).
- `qcommon/net_ip.cpp`, `md5.cpp`, `persistence.cpp`, and `matcomp.cpp` (`:239-248`).
- `qcommon/files.cpp` and `cmd.cpp` (`:230`, `:234`). Raven splits these as `files_common.cpp` with `files_pc.cpp` and `cmd_common.cpp` with `cmd_pc.cpp` (`WinDed.vcproj:204-222`).
- `shared/qcommon/q_color.c`, `q_string.c`, and `safe/files.cpp`.
- The `shared/sys` files and `con_tty.cpp`. Raven's entry and system layer is `null/win_main.cpp` with `win32/win_net.cpp` and `win32/win_shared.cpp`.
- `rd-dedicated/*`. It holds OpenJK's server copies of the ghoul2 files and a part of the renderer. Raven compiles `ghoul2/*.cpp` and `renderer/*.cpp` under `DEDICATED` instead.
- The botlib as a library, and minizip and zlib from `lib/` (`:185-191`).

Raven's dedicated project has these, and the OpenJK dedicated set does not:

- `qcommon/cm_draw.cpp`, `cm_randomterrain.cpp`, `cm_shader.cpp`, `cm_terrain.cpp`, `unzip.cpp`, `vm_interpreted.cpp`, and `vm_x86.cpp` (`WinDed.vcproj:153-294`).
- The twelve `RMG/*.cpp` files (`:839-872`).
- `renderer/tr_image.cpp` and `renderer/matcomp.c` (`:401`, `:410`). OpenJK has `qcommon/matcomp.cpp`.
- `png/png.cpp`, `zlib32/*`, and `server/NPCNav/gameCallbacks.cpp`.
- `null/null_glimp.cpp` and `null/win_main.cpp`.

### The botlib

The botlib is in both builds. The game module reaches it through the `BOTLIB_*` syscall arms, 132 case labels at `oracle/codemp/server/sv_game.cpp:944-1310`, which call `botlib_export->` 134 times in the switch. The game also has six `G_BOT_*` arms that the engine's `sv_bot.cpp` answers, for example `G_BOT_UPDATEWAYPOINTS` at `:1643-1645`.

The Swift game calls 38 distinct traps of the botlib families (`grep -rhoE` over `Sources/JKAMP_GameLogic` and `Sources/JKAMP_BG`). They are the `trap_EA_*` elementary actions, the goal, move, and weapon state allocations, `trap_BotLibSetup` (`Sources/JKAMP_GameLogic/ai_main.swift:6628`), `trap_BotUserCommand` (`:6584`), `trap_EA_GetInput` (`:715`), `trap_BotAllocGoalState` (`:963`), `trap_AAS_PointReachabilityAreaIndex` (`Sources/JKAMP_GameLogic/g_cmds.swift:2395`), and `trap_Bot_UpdateWaypoints` with `trap_Bot_CalculatePaths`. In Raven's game, the files that call a botlib trap are `ai_main.c`, `ai_util.c`, `ai_wpnav.c`, `g_bot.c`, `g_active.c`, `g_cmds.c`, and `g_client.c`.

## 2. The host surface

### The load

OpenJK's game load starts at `SV_InitGameProgs` (`openjk/codemp/server/sv_game.cpp:129-140`), which calls `SV_BindGame` (`:137`) and `SV_InitGame` (`:139`). `SV_BindGame` is at `openjk/codemp/server/sv_gameapi.cpp:2803-3145`:

1. When the referee is on, it calls `VM_CreateLegacy( VM_GAME, SV_GameSystemCalls )` and returns (`:2811-2813`).
2. Else it calls `VM_Create( VM_GAME )` (`:2815`). `VM_Create` at `openjk/codemp/qcommon/vm.cpp:155-192` calls `Sys_LoadGameDll` (`:178`), which looks for the export `GetModuleAPI` (`openjk/shared/sys/sys_main.cpp:600-673`, the lookup at `:665`).
3. On success, it fills the `gameImport_t` struct `gi` with 309 assignments (`sv_gameapi.cpp:2817-3125`) and calls `GetGameAPI( GAME_API_VERSION, &gi )` (`:3127-3134`). OpenJK's `GAME_API_VERSION` is 1 (`openjk/codemp/game/g_public.h:32`).
4. Else it falls back to `VM_CreateLegacy( VM_GAME, SV_GameSystemCalls )` (`:3139-3144`). `VM_CreateLegacy` at `vm.cpp:115-153` calls `Sys_LoadLegacyGameDll` (`:139`), which looks for `dllEntry` and `vmMain` (`sys_main.cpp:534-535`) and calls `dllEntry( systemcalls )` with `VM_DllSyscall` (`:544`, `vm.cpp:139`).

The module name is `jampgame` (`vm.cpp:33-37`), and the file name is `name ARCH_STRING DLL_EXT` (`sys_main.cpp:472`, `:605`).

Raven's load is one path. `SV_InitGameProgs` at `oracle/codemp/server/sv_game.cpp:1731` calls `VM_Create( "jampgame", SV_GameSystemCalls, (vmInterpret_t)(int)Cvar_VariableValue( "vm_game" ) )` (`:1750`). `VM_Create` at `oracle/codemp/qcommon/vm.cpp:471` loads a native library through `Sys_LoadDll` (`:518`) or else a QVM. `Sys_LoadDll` at `oracle/codemp/null/win_main.cpp:784` reads `dllEntry` and `vmMain` with `GetProcAddress` (`:827-828`). `SV_InitGameVM` at `sv_game.cpp:1682` sends `GAME_INIT` (`:1690`). Raven has no `GetGameAPI` path in MP, and Raven's `GAME_API_VERSION` is 8 (`oracle/codemp/game/g_public.h:11`).

The name `game_import_t` is SP. `oracle/code/server/sv_game.cpp:478-535` fills a `game_import_t` struct. The MP header of each tree has no `game_import_t`.

### The calls

OpenJK's `VM_Call` at `openjk/codemp/qcommon/vm.cpp:285-297` takes twelve `intptr_t` words and calls `vm->legacy.main` (`:295`). The fork traces the call when `vm->slot == VM_GAME` (`:291`). OpenJK's `VM_DllSyscall` at `:83-100` copies 16 `intptr_t` words out of its `va_list` and calls `currentVM->legacy.syscall( args )` (`:96`).

Raven's `VM_Call` at `oracle/codemp/qcommon/vm.cpp:787` is `int QDECL VM_Call( vm_t *vm, int callnum, ... )`, and `VM_DllSyscall` at `:363` is `int QDECL VM_DllSyscall( int arg, ... )`. Raven's `SV_GameSystemCalls` at `oracle/codemp/server/sv_game.cpp:458` takes `int *args`. The Swift game's syscall word is `intptr_t` (`Sources/CJKASyscall/include/jka_syscall.h:8`).

### The syscall arms

| | Raven | OpenJK |
|---|---|---|
| Dispatcher | `SV_GameSystemCalls( int *args )`, `oracle/codemp/server/sv_game.cpp:458` | `SV_GameSystemCalls_Real( intptr_t *args )`, `openjk/codemp/server/sv_gameapi.cpp:1756`, with the fork's tracing wrapper `SV_GameSystemCalls` at `openjk/codemp/server/sv_referee.cpp:140` |
| `case` labels | 332, `:464` to `:1650`, `default` at `:1653` | 332, `:1762` to `:2782`, `default` at `:2785` |
| Import enum | `gameImport_t`, 329 enumerators, `g_public.h:102-581` | `gameImportLegacy_t`, 329 enumerators, `openjk/codemp/game/g_public.h:378-715` |
| Export enum | `gameExport_t`, 40 enumerators, `g_public.h:734-799` | `gameExportLegacy_t`, `:717-758`, and the struct `gameExport_t` at `:1098-1139` |
| Import struct | none | `gameImport_t`, `:760-1096` |

Raven's arms by family, from the case labels of `sv_game.cpp:464-1650`:

| Family | Case labels | Lines | What answers |
|---|---:|---|---|
| `BOTLIB_*` | 132 | `:944-1310` | `botlib_export->` |
| `G_G2_*` and `G_R_REGISTERSKIN` | 48 | `:1313-1602` | `G2API_*`, 53 calls |
| `G_NAV_*` | 42 | `:837-934` | `navigator.` |
| `G_ICARUS_*` | 19 | `:739-832` | ICARUS |
| `TRAP_*` math and memory | 16 | `:464-499` | libc and `q_math` |
| `G_ROFF_*` | 5 | `:714-727` | `theROFFSystem` |
| `G_FS_*` | 5 | `:552-564` | `FS_*` |
| `G_CVAR_*` | 5 | `:529-540` | `Cvar_*` |
| The world, the configstrings, the clients, and the rest | the remainder | `:503-686`, `:1620-1650` | `SV_*`, `CM_*`, `Cbuf_*`, `Cmd_*` |

The subsystems each arm reaches:

- **Ghoul2.** The `G_G2_*` arms call `G2API_*` directly, for example `G2API_GetBoltMatrix` at `:1331-1341` and `G2API_CollisionDetect` at `:1441-1454`. A trace also reaches Ghoul2: `SV_Trace` calls `G2API_CollisionDetect` and `G2API_CollisionDetectCache` for an entity with a model (`oracle/codemp/server/sv_world.cpp:667`, `:744-748`).
- **The collision model.** `G_TRACE`, `G_G2TRACE`, and `G_TRACECAPSULE` call `SV_Trace` (`sv_game.cpp:587-595`), which calls `CM_BoxTrace` (`sv_world.cpp:803`, `:820`) and `CM_TransformedBoxTrace` (`:496`, `:609`). `G_POINT_CONTENTS` (`:596`), `G_IN_PVS` (`:604`), `G_AREAS_CONNECTED` (`:627`), and `G_CM_REGISTER_TERRAIN` (`:1640-1641`) reach it too.
- **The shared memory.** `G_LOCATE_GAME_DATA` (`:566-568`) calls `SV_LocateGameData` (`:327`), which gives the engine the module's entity table and client table. The engine reads that memory each frame.
- **The message codec, the Huffman code, and the net layer.** No arm in `sv_game.cpp:458-1657` names `MSG_`, `Huff_`, `NET_`, or `Netchan` (`grep -c` gives 0). The game reaches them only through the frame. `G_SEND_SERVER_COMMAND` (`:572-574`) queues a command through `SV_GameSendServerCommand` (`:91`). `SV_SendClientSnapshot` (`oracle/codemp/server/sv_snapshot.cpp:719`) calls `SV_WriteSnapshotToClient` (`:103`), which encodes with `MSG_WriteDeltaEntity` (`:72-87`) and `MSG_WriteDeltaPlayerstate` (`:166-192`). `SV_SendMessageToClient` (`:652`) sends through `SV_Netchan_Transmit` (`oracle/codemp/server/sv_net_chan.cpp:138`) and `NET_SendPacket` (`oracle/codemp/qcommon/net_chan.cpp:531`), which calls `Sys_SendPacket` (`:549`). The Huffman code is `msgHuff` in `msg.cpp:19`, used at `:193-254` and set up by `Huff_Init` at `:3227`, and `net_chan.cpp:602` calls `Huff_Compress`.
- **The terrain and RMG.** Raven's `G_RMG_INIT` builds a `CRMManager` (`sv_game.cpp:1624-1638`). OpenJK's `G_RMG_INIT` and `G_CM_REGISTER_TERRAIN` return 0 (`openjk/codemp/server/sv_gameapi.cpp:2769-2773`).

## 3. The entry and the frame

### The entry

OpenJK's `main` is `openjk/shared/sys/sys_main.cpp:743-822`. It calls `Sys_PlatformInit` and `CON_Init` (`:748-749`), joins the arguments into one command line (`:764-776`), calls `Com_Init( commandLine )` (`:778`), and then calls `Com_Frame()` in a loop (`:792-818`). The SDL lines stand under `#ifndef DEDICATED` (`:780-789`). The console input is `Sys_ConsoleInput` (`:128`) over `con_tty.cpp`.

Raven's dedicated `main` is `oracle/codemp/null/win_main.cpp:1410`. It calls `Com_Init( cmdline )` (`:1457`) and `Com_Frame()` (`:1493`). The console input is `Sys_ConsoleInput` at `:200`.

### Com_Init

OpenJK's `Com_Init` is `openjk/codemp/qcommon/common.cpp:1155`. In order, it calls `Cvar_Init` (`:1169`), `navigator.Init` (`:1171`), `Cbuf_Init` (`:1178`), `Cmd_Init` (`:1184`), `NET_Init` (`:1198`), `FS_InitFilesystem` (`:1200`), and `Com_ExecuteCfg` (`:1217`). Under `DEDICATED` it sets the cvar `dedicated` to 2 (`:1223-1225`). It then calls `VM_Init` (`:1290`) and `SV_Init` (`:1291`), and it calls `CL_Init` only when `com_dedicated` is 0 (`:1294-1295`). Raven's `Com_Init` is `oracle/codemp/qcommon/common.cpp:1216`.

### Com_Frame and SV_Frame

OpenJK's `Com_Frame` is `openjk/codemp/qcommon/common.cpp:1494`. It sleeps in `NET_Sleep` (`:1555-1558`), runs `Com_EventLoop` (`:1562`) and `Cbuf_Execute` (`:1566`), and calls `SV_Frame( msec )` (`:1578`). The client half runs only when `com_dedicated` is 0 (`:1599-1623`). Raven's `Com_Frame` is `oracle/codemp/qcommon/common.cpp:1593`, with `SV_Frame( msec )` at `:1669`.

OpenJK's `SV_Frame` is `openjk/codemp/server/sv_main.cpp:1146-1260`:

1. The fork's `SVRef_FrameGate` (`:1162`).
2. The frame length from `sv_fps` (`:1172-1181`).
3. `SV_CalcPings` (`:1226`) and, on a dedicated server, `SV_BotFrame( sv.time )` (`:1228`).
4. The game frames in chunks, `GVM_RunFrame( sv.time )` between the fork's `SVRef_PreGameFrame` and `SVRef_PostGameFrame` (`:1231-1240`).
5. `re->G2API_SetTime` (`:1243`).
6. `SV_CheckTimeouts` (`:1251`), `SV_SendClientMessages` (`:1254`), `SV_CheckCvars` (`:1256`), and `SV_MasterHeartbeat` (`:1259`).

Raven's `SV_Frame` is `oracle/codemp/server/sv_main.cpp:826`, with `VM_Call( gvm, GAME_RUN_FRAME, svs.time )` at `:914`. 21 lines of Raven's `server/*.cpp` name `VM_Call`.

### The commands, the cvars, and the files

Raven's command dispatch is `Cmd_ExecuteString` at `oracle/codemp/qcommon/cmd_pc.cpp:91`. It tries the command table (`:103`), then `Cvar_Command` (`:122`), then `CL_GameCommand` (`:127`), then `SV_GameCommand` (`:132`), and last `CL_ForwardCommandToServer` (`:144`). `Cbuf_Execute` is `oracle/codemp/qcommon/cmd_common.cpp:148`. `Cvar_Get` is `oracle/codemp/qcommon/cvar.cpp:188`, and `Cvar_Command` is `:476`.

Raven's filesystem starts at `FS_InitFilesystem` (`oracle/codemp/qcommon/files_common.cpp:480`). A pk3 opens in `FS_LoadZipFile` (`oracle/codemp/qcommon/files_pc.cpp:1423`) through `unzOpen` (`:1440`), and a file read goes through `FS_FOpenFileRead` (`:672`) and `unzOpenCurrentFile` (`:838`). The zip code is Raven's `qcommon/unzip.cpp` over `zlib32`. OpenJK's is minizip and zlib (`openjk/codemp/CMakeLists.txt:185-191`).

The registrations per Raven folder (`grep -c` over the folder's `.cpp` files):

| Folder | `Cmd_AddCommand` lines | `Cvar_Get (` lines |
|---|---:|---:|
| `server` | 21 | 90 |
| `qcommon` | 44 | 104 |
| `renderer` | 12 | 141 |
| `null` | 2 | 4 |
| `ghoul2` | 0 | 2 |
| `botlib` | 0 | 0 |

### The file-scope state

The counts come from one libclang parse per Raven file with `-x c++ -DDEDICATED -DBOTLIB -D_CONSOLE -DNDEBUG -I oracle/codemp -fms-extensions`. A row counts each `VAR_DECL` at file scope in that file and not `extern`. "Static" is a `static` declaration, and "global" is every other definition. Static locals inside a function are not counted.

| File | Static | Global | The globals |
|---|---:|---:|---|
| `server/sv_main.cpp` | 1 | 28 | `svs`, `sv`, `gvm`, and the `sv_*` cvars |
| `server/sv_game.cpp` | 0 | 3 | `botlib_export`, `gLocalModifier`, `sv_siegePersData` |
| `server/sv_bot.cpp` | 3 | 2 | `bot_maxdebugpolys`, `bot_enable` |
| `server/sv_world.cpp` | 0 | 2 | `sv_worldSectors`, `sv_numworldSectors` |
| `server/sv_snapshot.cpp` | 0 | 1 | `g_svCullDist` |
| `server/sv_ccmds.cpp`, `sv_client.cpp` | 1 each | 0 | |
| `server/NPCNav/navigator.cpp` | 6 | 3 | `navigator`, `d_altRoutes`, `d_patched` |
| `qcommon/common.cpp` | 6 | 43 | `com_argc`, `com_argv`, the journal files, and the `com_*` cvars |
| `qcommon/files_common.cpp` | 0 | 27 | `fs_searchpaths`, the `fs_*` cvars, the counters |
| `qcommon/cm_load.cpp` | 0 | 18 | `cmg`, the trace counters, `box_model`, `box_planes`, `box_brush`, `SubBSP`, `NumSubBSP` |
| `qcommon/msg.cpp` | 5 | 10 | `entityStateFields`, `playerStateFields`, `pilotPlayerStateFields`, `vehPlayerStateFields`, `msg_hData`, `kbitmask`, `overflows`, `oldsize` |
| `qcommon/vm.cpp` | 0 | 6 | `vmTable`, `currentVM`, `lastVM`, `g_vmMap`, `g_symbolMap`, `vm_debugLevel` |
| `qcommon/z_memman_pc.cpp` | 2 | 6 | `TheZone`, `gZeroMalloc`, `gEmptyString`, `gNumberString` |
| `qcommon/cvar.cpp` | 3 | 5 | `cvar_vars`, `cvar_indexes`, `cvar_numIndexes`, `cvar_modifiedFlags`, `cvar_cheats` |
| `qcommon/net_chan.cpp` | 1 | 5 | `loopbacks`, `qport`, `showpackets`, `showdrop` |
| `qcommon/cm_polylib.cpp` | 0 | 5 | the winding counters |
| `qcommon/cmd_common.cpp` | 3 | 3 | `cmd_text`, `cmd_text_buf`, `cmd_wait` |
| `qcommon/cm_patch.cpp` | 7 | 3 | the patch counters |
| `qcommon/files_pc.cpp`, `huffman.cpp`, `cmd_pc.cpp` | 2, 1, 1 | 0 | |
| `qcommon/cm_test.cpp`, `cm_trace.cpp`, `sv_init.cpp`, `sv_net_chan.cpp` | 0 | 0 | |
| `null/win_main.cpp` | 7 | 3 | `cls`, `eventQue`, `sys_packetReceived` |
| `null/null_client.cpp` | 0 | 2 | `cl_cdkey`, `cl_shownet` |
| `win32/win_net.cpp` | 19 | 1 | `recvfromCount` |
| The server, qcommon, null, and win32 rows | 69 | 176 | |

The other folders, with the same command:

| Folder | Static | Global | The largest |
|---|---:|---:|---|
| `renderer`, eight files | 16 | 171 | `tr_init.cpp` 129, mostly the `r_*` cvars, `tr_ghoul2.cpp` 24 |
| `botlib`, 28 files | 13 | 93 | `be_aas_reach.cpp` 24, `be_ai_goal.cpp` 12, `be_ai_move.cpp` 12, `aasworld` in `be_aas_main.cpp` |
| `ghoul2`, five files | 34 | 7 | `G2_bones.cpp` 19 static, `G2_misc.cpp` 11 static, `g_Ghoul2Allocations` and `gG2_GBMNoReconstruct` in `G2_API.cpp` |
| `icarus`, ten files | 0 | 12 | `iICARUS`, `gSequencers`, `gTaskManagers`, `varStrings`, `varFloats`, `varVectors` |
| `qcommon` other: `RoffSystem.cpp`, `GenericParser2.cpp`, `stringed_*.cpp`, `md4.cpp`, `unzip.cpp`, `cm_draw.cpp`, `cm_randomterrain.cpp`, `cm_shader.cpp`, `cm_terrain.cpp`, `vm_interpreted.cpp`, `vm_x86.cpp` | 35 | 23 | `theROFFSystem`, `TheStringPackage`, `vm_x86.cpp` 20 static, `cm_draw.cpp` 11 |

## 4. The closure and the parse

### The closure tool

`closure.py` takes a module and a symbol, a type name or `fn:Name`, with `--file` for one `.c` or `.cpp` file in place of the entry header (`tools/oracle-closure/closure.py:747-751`). The modules are the `[units.*]` rows of `tools/oracle-closure/project.toml`. Three engine units exist: `mp-engine-ded` (`:312`), `mp-engine` (`:376`), and `mp-client` (`:223`), each with `lang = "c++"`.

`mp-engine-ded` mirrors WinDed Release less the Windows defines (`project.toml:293-302`). Its entry is `codemp/qcommon/qcommon.h` (`:315`), its defines are `NDEBUG`, `DEDICATED`, `BOTLIB`, and Windows type stand-ins (`:329-349`), and its `srcglob` is `codemp/qcommon/*.cpp`, `codemp/server/*.cpp`, `codemp/ghoul2/*.cpp`, `codemp/botlib/*.cpp`, `codemp/icarus/*.cpp`, `codemp/RMG/*.cpp`, eight renderer files, and `renderer/matcomp.c` (`:354-369`). The comment at `:307-308` excludes the null files.

The glob does not match the WinDed list:

- `codemp/qcommon/*.cpp` takes twelve files WinDed does not compile: `cm_patch_xbox.cpp`, `cmd_console.cpp`, `hstring.cpp`, `z_memman_console.cpp`, `cm_load_xbox.cpp`, `vm_console.cpp`, `exe_headers.cpp`, `files.cpp`, `cm_terrainmap.cpp`, `CNetProfile.cpp`, `vm_ppc.cpp`, and `files_console.cpp`.
- `codemp/icarus/*.cpp` takes `Interpreter.cpp` and `Tokenizer.cpp`, which WinDed does not compile.
- `codemp/server/*.cpp` does not reach `server/NPCNav/navigator.cpp` or `gameCallbacks.cpp`, which WinDed compiles (`WinDed.vcproj:365-371`).
- `win32/win_net.cpp`, `win32/win_shared.cpp`, `null/*`, and `png/png.cpp` are out.

`closure.py mp-engine-ded serverStatic_t --layout` stops with `'serverStatic_t' not found in mp-engine-ded TU`, because the entry header `qcommon.h` does not reach `server.h`. With `--file codemp/server/sv_main.cpp`, the parse reports 70 errors and prints `serverStatic_t` at 41048 bytes, `server.h:208`, with `challenges` as `challenge_t[1024]` at offset 44.

### The unity parse

`closure.parse_tu('mp-engine-ded', None, unity=True)` runs in 3.5 seconds and reports 1313 errors:

| Error class | Count |
|---|---:|
| redefinition | 1051 |
| use of an undeclared identifier | 93 |
| cast from a pointer to a smaller type `int` | 69 |
| an `expected` token error, first at the MSVC inline assembly of `q_shared.h:1414-1415` | 63 |
| a member reference on `fileHandle_t` | 25 |
| other | 12, among them `'direct.h' file not found` and two `static_assert` failures in the libc++ headers |

The definitions the unity parse holds, by oracle folder of the definition:

| Folder | `FUNCTION_DECL` | `CXX_METHOD` | Constructors and destructors |
|---|---:|---:|---:|
| `qcommon` | 877 | 142 | 28 |
| `botlib` | 697 | 0 | 0 |
| `ghoul2` | 213 | 6 | 5 |
| `server` | 168 | 0 | 0 |
| `renderer` | 135 | 9 | 4 |
| `game` | 115 | 0 | 0 |
| `icarus` | 77 | 394 | 69 |
| `RMG` | 5 | 86 | 22 |

The `game` row is `q_math.c` and `q_shared.c` through the two wrappers. No row holds a `navigator.cpp` method, because the glob does not reach `server/NPCNav`.

An earlier extract stands at `tools/oracle-closure/out/extract/mp-engine-ded`, dated September 8 and 9, with 154 headers under `codemp/game` and `codemp/qcommon` only.

### Where the module assumption lives

Every generator after the closure reads a `[targets.*]` row, and only `mp-game` and `mp-cgame` have one (`project.toml:24-58`). The row fields assume a module with a trap table: `folder`, `traps`, `logic`, `views`, `c_target`, `state`, `rust`, and `other` (`:14-23`).

| Script and lines | The assumption |
|---|---|
| `closure.py:331-335` | The run reads `TARGETS = PROJECT["targets"][UNIT]`, `OTHER_UNIT = TARGETS["other"]`, and `GAME_DIR = TARGETS["folder"]`. |
| `closure.py:385-389` | `Parse` makes one unity parse of the unit and one of the other unit, and it parses the umbrella of the unit's C target through `reexport.parse`. |
| `skeleton.py:60` | `SKIP = {C.TARGETS["traps"]}`, the trap file of the unit. |
| `skeleton.py:87-91` | `target_of` knows `JKAShared`, `JKAMP_BG`, and the unit's logic target. |
| `skeleton.py:303`, `:351` | A function or a file-scope variable is a stub only when its file has the suffix `.c`, so every `.cpp` definition is skipped. |
| `skeleton.py:299-300` | Only a `FUNCTION_DECL` definition is collected, so a `CXX_METHOD` is not. |
| `skeleton.py:782`, `:1131` | The public rule names the shell's `vmMain`. |
| `traps.py:49-51` | The source is `GAME_DIR/traps`, and every function whose body is one `syscall(...)` call is a trap. An engine answers syscalls and has no such file. |
| `merge.py:44-50` | `MP_MODULES` is `mp-game`, `mp-bg`, `mp-cgame`, and `mp-ui`, and `TARGET_OF_MODULE` maps those four to the C targets. No engine module reaches a C target. |
| `extract.py:861`, `:981` | The unity parse and the macro resolver of the `.c` constants run when `lang == "c"`. |
| `rulings.py:19`, `:101` | The view roots are `GAME_ROOTS` and `CGAME_ROOTS`. |

`fnsweep.py:30` names `CursorKind.NAMESPACE`, and `draft_expressions.py:72` and `:698` read `CXX_UNARY_EXPR`. No drafter module names `CXX_METHOD`, `CLASS_DECL`, or a constructor (`grep -n` over `bodies.py`, `draft_*.py`, and `table.py`).

## 5. The oracle

### The fork's referee

`sv_referee` is commit f6d2875e of the fork, `openjk/codemp/server/sv_referee.cpp` (630 lines) and `sv_referee.h` (36 lines). It is in both OpenJK trees, and `../OpenJK/build-referee/openjkded.arm64` is a built binary.

| Part | What it does | Lines |
|---|---|---|
| Stepper | `sv_stepper` gates `SV_Frame`, and `ref_step [n]` grants frames | `sv_referee.cpp:4`, `:430`, `:468`, `sv_main.cpp:1162` |
| Recorder | `sv_recordInputs` writes every client usercmd, the enter-world, and the disconnect to a file at map load | `sv_referee.cpp:5`, `:203-224`, `:570-592` |
| Replayer | `sv_replayInputs` reads the file and drives fake clients | `:6`, `:258-411` |
| Seed | `sv_refSeed` replaces the seed of `GAME_INIT` | `:7`, `:555`, `sv_gameapi.cpp:2800` |
| Checksum | FNV-1a over each entity's `entityState_t` and `entityShared_t` and each connected client's `playerState_t`, printed as `REF STEP n=%d t=%d ck=%08x` after each game frame | `:56-80`, `:456-459` |
| Dump | `ref_dump` prints the entity and player bytes in hex | `:495-519` |
| Trace | `sv_refTrace` keeps a ring of every `VM_Call` and syscall with four words in and eight words out, printed by `ref_trace` | `:8`, `:122`, `:140`, `:522-539` |
| Legacy bind | `SVRef_ForceLegacy` binds the game through `dllEntry` and `vmMain` when a referee feature is on | `sv_referee.h:35-36`, `:548`, `sv_gameapi.cpp:2812` |

It compares nothing itself. Two runs of the stepper with one input file and one seed print two `REF STEP` streams, and a reader compares the checksums line by line. `notes/2026-10-29/human-recordings.md:9` runs such replays on `openjkded.arm64` with the Swift game. The hooks are OpenJK functions in OpenJK's `SV_Frame`, `VM_Call`, and `SV_BindGame`, and Raven's engine has none of them.

### jka-rust's lockstep referee

`jka-rust/tools/lockstep-referee/run.sh` boots two `mp_app` engines, jka-rust's Rust engine (`:4-10`, `:40`). The primary loads jka-rust's `jampgame` and writes the event tape with `ref_record` (`:49`, `:73-76`). The secondary loads Raven's game module from `tools/referee-oracle`, follows the tape with `ref_replay` and `ref_follow 1`, and prints `REF DIVERGE` lines from per-frame state digests (`:41`, `:56-59`, `:90-94`, `:111`). Both engines are `mp_app`. The plan states the diff as every entity state and player state pair plus the ordered syscall digest of each module (`jka-rust/docs/plans/2026-07-13-engine-lockstep-referee.md:24-36`), and the engine RNG pinned in both engines (`:57-61`). The plan says CI never ran the rig (`:5`). The Rust referee is `jka-rust/crates/mp/engine/server/src/sv_referee.rs`.

`jka-rust/tools/referee-oracle` builds Raven's unmodified game module, all 89 `codemp/game/*.c` files, as `build/liboraclejampgame.dylib` with Homebrew GCC (`README.md:3-5`, `:18-25`, `:47-54`). The flags `-fno-fast-math -ffp-contract=off -O2` define the float parity (`:65-77`). The one change to the copy is `#define qboolean int` (`:83-93`). The smoke drive loads it through a mock engine (`:105-118`). The lockstep plan adds a width patch for `vmMain` on 64-bit (`2026-07-13-engine-lockstep-referee.md:62-67`).

Both referees compare game modules under one engine. Neither one runs two engines of different source against one game module.

### The engine oracles

Each harness compiles unmodified Raven files on their own, against stub headers, and commits goldens that a Rust test reads.

| Tool | What it records | Compared against | Lines |
|---|---|---|---|
| `huff-oracle` | The per-symbol prefix codes and two bitstreams of `msgHuff`, seeded as `MSG_initHuffman` seeds it, emitted through `Huff_offsetTransmit` | `crates/mp/engine/qcommon/src/qcommon/huff.rs` through `tests/huff_golden.rs` | `main.cpp:1-11`, `:28-37`, goldens `chat.txt`, `codes.txt`, `seq.txt` |
| `ghoul2-server-oracle` | The `Ghoul2InfoArray` handle arena, the bolt list, and the generated-surface list, with `-DDEDICATED -DNDEBUG -D_M_IX86 -D_G2_GORE` | `mp_engine_ghoul2`, `tests/ghoul2_parity.rs` | `README.md:3-20`, `:29-37`, `:41-59` |
| `npcnav-oracle` | The nav graph of `server/NPCNav/navigator.cpp` | the Rust `Navigator` | `README.md:1-8` |
| `icarus-oracle` | The ICARUS sequencer | `mp_engine_icarus` | `README.md:1-7` |
| `roff-oracle` | `qcommon/RoffSystem.cpp` | the `mp_engine_qcommon` roff port | `README.md:1-8` |
| `trmodel-oracle` | The `tr_model.cpp` loader and cache and `matcomp.c` | `mp_renderer` and `mp_engine_ghoul2` | `README.md:1-8` |
| `stringed-oracle` | The StringEd files | `mp_engine_qcommon::stringed` | `README.md:1-8` |
| `gp2-oracle` | `qcommon/GenericParser2.cpp` over fixtures | `crates/mp/engine/qcommon/src/gp2/` | `README.md:1-7` |
| `rmg-oracle` | `cm_terrain.cpp`, `cm_randomterrain.cpp`, `RMG/RM_Manager.cpp` | `crates/mp/engine/rmg/` and `mp_engine_qcommon` | `README.md:1-8` |
| `terrainmap-oracle` | `cm_draw.cpp` and `cm_terrainmap.cpp` | `crates/mp/engine/qcommon/src/cm/` | `README.md:1-8` |

The ghoul2 harness covers three islands. The bone transform, the bolt matrix, the collision, the ragdoll, and the gore are not standalone yet (`ghoul2-server-oracle/README.md:14-20`). The other folders under `jka-rust/tools/` are `abi`, `cgame-oracle`, `cgame-referee`, `cin-oracle`, `closure-prototype`, `fx-oracle`, `jampgame-oracle`, `live-soak`, `renderer-oracle`, `snd-oracle`, and `ui-oracle` (`ls jka-rust/tools`).

These goldens are unit proofs of subsystems. None of them runs a frame of a server.

### jka-rust's engine

jka-rust holds a Rust port of Raven's MP engine under `jka-rust/crates/mp/engine`, in the crates `botlib` (37218 lines of Rust), `client` (45241), `core` (2131), `ghoul2` (18392), `icarus` (8517), `qcommon` (41913), `rmg` (465), and `server` (19957) (`find ... -name '*.rs' | xargs cat | wc -l`). Its `VM_Create` cites `oracle/codemp/qcommon/vm.cpp:471-597` (`jka-rust/crates/mp/engine/qcommon/src/vm_fns.rs:701-707`). Its engine state is the `EngineHostView` struct over `Common`, the collision world, the server, the client, the sound, the botlib, the models, the renderer, the RMG, Ghoul2, and FX (`jka-rust/crates/mp/engine/qcommon/src/common/engine_host_view.rs:77-103`). Porting rule 16 names jka-rust's `mp_app` as the engine for the proof (`docs/porting-rules.md:36`).

## 6. The package

The package has two products, both `.library(type: .dynamic)`, `jampgame` and `cgame` (`Package.swift:9-12`). The one executable target is `jampsmoke`, the dlopen loader (`:56`).

The module precedent, per role:

| Role | Game | cgame | Lines |
|---|---|---|---|
| The variadic shim | `CJKASyscall` | the same | `:16` |
| C headers | `CJKAMP_Game` | `CJKAMP_CGame` | `:24-25` |
| Views and typed traps | `JKAMP_Game` | `JKAMP_CGame` | `:39`, `:41` |
| Logic | `JKAMP_GameLogic` | `JKAMP_CGameLogic` | `:47`, `:49` |
| Shell | `jampgame` | `cgame` | `:53-54` |
| Tests | `JKAMP_GameTests`, `jampgameTests` | `JKAMP_CGameTests`, `cgameTests` | `:70-75` |

The shim is the module side of the variadic call. Its header says "Swift cannot call a C variadic" and "Swift cannot write a C variadic callee" (`Sources/CJKASyscall/include/jka_syscall.h:10`, `:14`). The engine hands the module `VM_DllSyscall`, a C variadic callee (`openjk/codemp/qcommon/vm.cpp:83`, `oracle/codemp/qcommon/vm.cpp:363`).

The CI workflow `.github/workflows/build.yml` runs on a push to master (`:3`, `:28`). It holds a test job on Linux (`:45-67`) and one release build job per product and platform: `jampgame` on Linux (`:70-112`) and Windows (`:115-160`), and `cgame` on Linux (`:163-205`) and Windows (`:208-253`), then the rolling release (`:256`). The build names the product alone, because `jampsmoke` imports Darwin (`:20`). No macOS lane runs (`:17`). Each zip keeps the arch-suffixed module name the engine loads (`:9-15`).

## 7. What blocks the first stage

1. Which engine is the oracle source? Raven's `WinDed.vcproj` is the port's oracle, but OpenJK's `openjkded` is the binary that runs today, and the two sets differ (section 1). Raven loads the game only through `dllEntry` and `vmMain` (`oracle/codemp/null/win_main.cpp:827-828`), and OpenJK tries `GetModuleAPI` first (`openjk/codemp/server/sv_gameapi.cpp:2815`). Which file set does stage 1 port?
2. What is the word width of the host ABI? Raven's `VM_Call`, `VM_DllSyscall`, and `SV_GameSystemCalls` take `int` (`oracle/codemp/qcommon/vm.cpp:363`, `:787`, `oracle/codemp/server/sv_game.cpp:458`). The Swift game uses `intptr_t` (`Sources/CJKASyscall/include/jka_syscall.h:8`), and OpenJK uses `intptr_t` (`openjk/codemp/qcommon/vm.cpp:83`, `:285`). Rule 19 or a ruling?
3. Where does the engine's variadic callee live? Swift cannot write a C variadic callee (`jka_syscall.h:14`), and the module calls `VM_DllSyscall( int arg, ... )`. Does a C shim target hold the callee, in the shape of `CJKASyscall`?
4. How do rules 3, 6, and 11 apply to a host? They describe one module world and one `Syscall.transport` (`docs/porting-rules.md:12`, `:15`, `:28`). The host reads module memory through `SV_LocateGameData` (`oracle/codemp/server/sv_game.cpp:327`) and keeps its own statics, 245 file-scope variables in the server, qcommon, null, and win32 files alone (section 3). Is there one `EngineWorld`, and where do the views over `sharedEntity_t` live?
5. Which subsystems are in stage 1? The game's syscalls reach the botlib (132 arms), Ghoul2 (48 arms and the trace), NPCNav (42), ICARUS (19), ROFF (5), and the RMG and terrain (`sv_game.cpp:1620-1641`). The Swift game calls 38 botlib traps, `trap_BotLibSetup` among them (`Sources/JKAMP_GameLogic/ai_main.swift:6628`). Does a first stage hold a C-linked part of Raven's engine, the way the game first stood on stubs?
6. What new unit kind does the pipeline take? The `[targets]` row assumes a trap file and a vmMain shell (`project.toml:14-23`, `traps.py:49-51`, `skeleton.py:782`, `:1131`). The skeleton skips every `.cpp` file and every C++ method (`skeleton.py:299-303`, `:351`). The merge has no engine module (`merge.py:44-50`). Is the host a third `[targets]` row, or a new kind of row?
7. What is the C++ track's scope for the host? Rule 17 asks for a measured list of classes (`docs/porting-rules.md:42`). The unity parse holds 637 `CXX_METHOD` definitions and 128 constructors and destructors, 394 and 69 of them in ICARUS (section 4), and the drafter reads no method. Which classes come first?
8. Does the `mp-engine-ded` unit get the WinDed list? Its glob takes 14 files WinDed does not compile and misses `server/NPCNav` (`project.toml:354-369`, `WinDed.vcproj:365-371`), and the unity parse reports 1051 redefinition errors.
9. What is the proof of a host step? Rule 16 names jka-rust's `mp_app` and the lockstep referee (`docs/porting-rules.md:36`), and the lockstep referee compares two game modules under one `mp_app` engine (`jka-rust/tools/lockstep-referee/run.sh:4-10`). The fork's stepper compares `REF STEP` checksums of one engine across modules (`sv_referee.cpp:456-459`). Does the Swift host port the fork's referee cvars and the record format, so one `.rec` file drives the C host and the Swift host with the same Swift game and the two `REF STEP` streams compare? That instrumentation is OpenJK's and is not in Raven (`sv_main.cpp:1162`, `vm.cpp:291`).
10. Which golden sets port first? The huff, ghoul2-server, npcnav, icarus, roff, trmodel, stringed, gp2, rmg, and terrainmap harnesses already hold goldens (section 5). Rule 18 says a Swift test reads the committed goldens (`docs/porting-rules.md:43`). Does stage 1 copy them into `JKATestSupport`?
11. Does the manifest cite jka-rust's engine? `[targets]` names one crate under `jka-rust/crates/mp` (`project.toml:19`), and the engine is eight crates under `jka-rust/crates/mp/engine` (section 5).
12. What is the product? The package has no executable product (`Package.swift:9-12`), and `jampsmoke` imports Darwin, so CI names products alone (`.github/workflows/build.yml:20`). Does the host become an executable product named `openjkded` with CI lanes per platform?
13. Is the QVM in? Raven's `VM_Create` falls back to a QVM through `vm_interpreted.cpp` and `vm_x86.cpp` (`oracle/codemp/qcommon/vm.cpp:471`, `:518`, `WinDed.vcproj:285-291`), and OpenJK dropped both.
14. Is the zip code ported or linked? Raven reads a pk3 through its own `unzip.cpp` over `zlib32` (`oracle/codemp/qcommon/files_pc.cpp:1440`, `WinDed.vcproj:276`, `:879-894`). OpenJK links minizip and zlib (`openjk/codemp/CMakeLists.txt:185-191`).
