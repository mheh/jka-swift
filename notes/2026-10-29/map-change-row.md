# The map change row

This record holds the proof of the map-change trap and the M1 row. The server is `.build/openjk/openjkded.arm64` on master at aa024e0, with the copy of `.build/debug/libjampgame.dylib` as `/tmp/jka-load/home-m1/swift/jampgamearm64.dylib`, `net_port 29075`, `bot_minplayers 4`, and `+map mp/ffa1 +wait 600 +map mp/duel1 +wait 1200 +quit`. The lldb log is `/tmp/jka-load/m1-lldb.log`.

## The mechanism

The hypothesis holds, with one change in the last step. The nil entry does not come from a search. It comes from a neighbor index of the route file.

1. Raven's `LoadPathData` at `ai_wpnav.c:2007-2249` reads the `.wnt` file and calls `CreateNewWP_FromObject` once per line. It never writes `gWPNum`. `CreateNewWP_FromObject` at `ai_wpnav.c:403-454` writes the new waypoint at `gWPArray[gWPNum]`, sets its `index` to `gWPNum`, and increments `gWPNum`. It copies `neighbors[i].num` as the file states it, a file index from 0.
2. The only writes of `gWPNum` in Raven are the increments in `CreateNewWP` and `CreateNewWP_FromObject`, the decrements in `RemoveWP` and `RemoveWP_InTrail`, the clamp at `ai_wpnav.c:1508`, and the zero declaration at `ai_wpnav.c:13`. `RemoveAllWP` at `ai_wpnav.c:484-489` brings it to 0, and its only callers are the `_XBOX` arm at `g_main.c:902-907` and the Xbox `CL_ClearLastLevel` at `client/cl_main.cpp:701-722`. The Swift `ai_wpnav.swift` has the same writes at `:435`, `:481`, `:490`, `:578`, `:638`, `:706`, and `:1374`, and no write of 0.
3. The Swift `G_InitGame` at `g_main.swift:745-955` resets `gWPArray` through `B_InitAlloc` at `:762` (`ai_util.swift:37-39`, Raven's `ai_util.c:133-140`), `allocPoint` through `G_InitMemory`, `level` through `level.clear()`, `g_entities` and `g_clients` through `zero()`, the timers through `TIMER_Clear`, and the items through `ClearRegisteredItems`. It does not reset `gWPNum`.
4. So on duel1, `gWPNum` starts at ffa1's count, and duel1's waypoints land after it. The slots below stay nil, because `B_InitAlloc` zeroed them.
5. `GetNearestVisibleWP` and the other `i < gWPNum` loops skip the nil slots, so a bot first takes a real waypoint. When the bot touches it, `WPTouchRoutine` at `ai_main.swift:1499` calls `CheckForShorterRoutes` at `:1348`, which sets `bs.wpCurrent = gWPArray[bestindex]` at `:1406`, Raven's `ai_main.c:1332`. `bestindex` is a `neighbors[i].num`, a duel1 file index from 0 to 42, and that slot is nil. Back in `StandardBotAI`, the read of `bs.wpCurrent!.index` at `:5948` or `:5950` traps.

The counts prove it. `botroutes/mp/ffa1.wnt` in `assets0.pk3` holds 415 waypoints, 0 to 414. `botroutes/mp/duel1.wnt` holds 43, 0 to 42. At the trap, lldb reads `world.variables.gWPNum` as 458, which is 415 plus 43. The duel1 waypoints sit at slots 415 to 457, and slots 0 to 414 are nil.

## The backtrace head

```
JKAMP_GameLogic/ai_main.swift:5950: Fatal error: Unexpectedly found nil while unwrapping an Optional value
frame #4: jampgamearm64.dylib`StandardBotAI(bs=JKAMP_Game.BotState @ 0x000000016fdfb228, thinktime=0.0250000004) at ai_main.swift:5950:44
frame #5: jampgamearm64.dylib`BotAI(client=1, thinktime=0.0250000004) at ai_main.swift:850:5
frame #6: jampgamearm64.dylib`BotAIStartFrame(time=23725) at ai_main.swift:6563:17
frame #7: jampgamearm64.dylib`vmMain(command=10, arg0=23725, ...) at jampgame.swift:83:20
frame #9: openjkded.arm64`VM_Call(...)
frame #10: openjkded.arm64`GVM_BotAIStartFrame(int) + 80
frame #11: openjkded.arm64`SV_Frame(int) + 1668
(lldb) expr -l swift -- JKAMP_GameLogic.world.variables.gWPNum
(Int32) $R0 = 458
```

The bot is client 1 at origin (520.95, 790.15, 152.13) on duel1, 37 seconds after the duel1 `Game Initialization` line.

## Raven's two answers

On the PC, Raven relies on the reload. The engine frees the game image at every map change and loads it again, so every file-scope variable starts from its initializer. His own comment at `g_main.c:2305` states this: `qboolean gDidDuelStuff = qfalse; //gets reset on game reinit`.

On the Xbox, the image never unloads, which is the macOS case here. Raven's answer is the `_XBOX` arm. `CL_ClearLastLevel` at `client/cl_main.cpp:701-722` frees `TAG_BG_ALLOC` and calls `G_ClPtrClear`, `NPC_NPCPtrsClear`, `RemoveAllWP`, `BG_ClearVehicleParseParms`, and `NAV_ClearStoredWaypoints`. His comment at `:685-687` says this "probably violates DLL boundaries, so it's done on Xbox only". The `_XBOX` arm of `G_InitGame` at `g_main.c:902-907` calls `BG_ClearVehicleParseParms` and `RemoveAllWP` on a restart. The arm covers five of the stale states below, not all of them.

## The stale-state table

The table lists each state on `world` that a map change leaves stale on macOS. "PC" says what Raven's PC build does. A sonnet audit of every property of `GameStorage.swift` and `GameVariables.swift` against the oracle gave the rows after `gWPNum`. I checked `gSiegeRoundEnded`, the vehicle pool, and `gDidDuelStuff` against the source.

| State | Raven | Effect of a stale value | PC |
|---|---|---|---|
| `gWPNum` | `ai_wpnav.c:13` | duel1 waypoints land after the old count, the trap above | reload, `RemoveAllWP` on Xbox |
| `gClPtrs` | `g_utils.c:428` | `G_CreateFakeClient` returns the old record without a clear | reload, `G_ClPtrClear` on Xbox |
| `gNPCPtrs` | `NPC_spawn.c:1276` | the old record returns, and `New_NPC_t` clears it on reuse | reload, `NPC_NPCPtrsClear` on Xbox |
| `numStoredWaypoints`, `tempWaypointList` | `g_nav.c:1658` | `NAV_StoreWaypoint` appends to the old list | reload, `NAV_ClearStoredWaypoints` on Xbox |
| `g_vehiclePool`, `g_vehiclePoolOccupied` | `g_utils.c:385-387` | slots stay occupied, then `ERR_DROP` "Ran out of vehicle pool slots" at `:408` | reload |
| `gSiegeRoundEnded`, `gSiegeRoundBegun` | `g_saga.c:36-37` | the next siege map starts with the round ended | reload |
| `eFlagRed`, `eFlagBlue` | `ai_main.c:91,93` | `LoadPath_ThisLevel` sets them only when nil, so they keep old entity slots | reload |
| `flagRed`, `flagBlue`, `oFlagRed`, `oFlagBlue` | `ai_main.c:86-89` | CTF bots read old waypoint objects | reload |
| `droppedRedFlag`, `droppedBlueFlag` | `ai_main.c:92,94` | an old entity reads as a dropped flag | reload |
| `numbots` | `ai_main.c:48` | the count drifts up and changes `botthink_residual` | reload |
| `gLevelFlags` | `ai_wpnav.c:23` | a map with no route file keeps the old flags | reload |
| `gDeactivated` | `ai_wpnav.c:7` | after a waypoint edit, bots stop on the next map | reload |
| `remapCount`, `remappedShaders` | `g_utils.c:17-18` | the old remaps stay in `CS_SHADERSTATE` | reload |
| `gDidDuelStuff` | `g_main.c:2305` | the next duel intermission skips the queue work | reload, by his comment |
| the 11 lazy loop sounds | `g_items.c:101-105`, `w_force.c:24-34` | the old map's sound index plays another sound | reload |
| the siege parse values | `g_saga.c:22-41` | a `.siege` file without a key keeps the old value | reload |
| `botSpawnQueue` | `g_bot.c:27` | a pending entry begins an old client number | reload |
| `gEscaping`, `gEscapeTime` | `g_misc.c:2540` | a map change during an escape keeps the flag | reload |

The count is 18 rows over about 40 variables. One row traps, one ends in `ERR_DROP`, and the rest change behavior.

These states are not stale. `level`, `g_entities`, `g_clients`, `gWPArray`, `allocPoint`, the timers, `itemRegistered`, `teamgame`, `refTagOwnerMap`, `g_numBots`, `g_numArenas`, `nodetable`, `nodenum`, the NPC parms, and the two siege goal counters have resets in `G_InitGame` or `G_ShutdownGame`. `botstates` is zeroed by `BotAISetup` at `ai_main.c:7603-7608` when `restart` is 0. The ICARUS state lives in the engine, which `trap_ICARUS_Init` and `trap_ICARUS_Shutdown` reset, and `numNewICARUSEnts` only names script targets. The vehicle parse data, `g_vehicleInfo`, and the animation sets live on `bg`, which `dllEntry` builds again, and `BG_InitAnimsets` clears them too. The vmCvar records are registered again by `G_RegisterCvars`.

## The engine pointers across the change

A new `world` frees the old storage in `GameWorld.deinit` and `GameStorage.deinit`. The engine holds no pointer into it after `dllEntry`:

1. `SV_SpawnServer` at `sv_init.cpp:466` calls `SV_ShutdownGameProgs`, which runs `GVM_ShutdownGame` and then `VM_Free` at `sv_gameapi.cpp:3147-3150`. `G_ShutdownGame` runs on the old world.
2. `SV_ClearServer` at `sv_init.cpp:577` calls `SV_InitSV`, which runs `memset(&sv, 0, sizeof(sv))` at `:301`, so `sv.gentities` and `sv.gameClients` are cleared.
3. `SV_InitGameProgs` at `:620` calls `SV_BindGame`, `VM_Create`, and so `dllEntry`. `SV_InitGame` at `sv_gameapi.cpp:2790-2801` sets every `cl->gentity` to NULL and then calls `GVM_InitGame`.
4. The Swift `G_InitGame` announces the tables again: `trap_SV_RegisterSharedMemory(gSharedBuffer)` at `g_main.swift:764` and `trap_LocateGameData` at `:841`. `SV_LocateGameData` at `sv_gameapi.cpp:430-437` stores both pointers.
5. `map_restart` goes through `SV_RestartGame` at `sv_gameapi.cpp:3153`, and `VM_Restart` at `qcommon/vm.cpp:104-113` is `VM_Free` and `VM_Create`, so `dllEntry` runs on that path too.

The syscalls before `trap_LocateGameData` in `G_InitGame` do not read `sv.gentities`. `G2API_CleanEntAttachments` at `rd-vanilla/G2_API.cpp:218-229` clears an engine table. `StringPool.shared` is not part of the rebuild, and the engine copies every configstring.

## M1. The game state survives a map change

Ratified as proposed on 2026-10-29.

Raven: the PC build relies on the image reload for every file-scope static, as `g_main.c:2305` states. The Xbox build clears five of them in `CL_ClearLastLevel` at `client/cl_main.cpp:701-722` and two in the `_XBOX` arm of `G_InitGame` at `g_main.c:902-907`. `LoadPathData` at `ai_wpnav.c:2007` appends at `gWPNum` and never zeroes it.

OpenJK: `codemp/game/ai_wpnav.c:35` declares `int gWPNum = 0;`, and OpenJK adds no reset, so it relies on the reload the same way. `gClPtrs` at `g_utils.c:449` and `gNPCPtrs` at `NPC_spawn.c:1270` keep Raven's form. The engine reloads the image at every map change and every `map_restart`, through `SV_UnbindGame` and `VM_Restart`.

Swift: `dllEntry` at `jampgame.swift:12-22` builds a new `bg` but keeps `world`, and the macOS loader keeps the image, so every state in the table above carries over. `ai_main.swift:5948` and `:5950` trap on duel1 after ffa1 in two runs of two, and in the lldb run.

Form (a): `dllEntry` assigns `world = GameWorld()` beside `bg = BgState(...)`. This matches the engine's intent, a fresh image at every `VM_Create`, and Raven's zeroed statics on the PC. It resets all 18 rows and any state a later port adds. It needs no new name, because `world` and `GameWorld()` exist and rule 4 already assigns `world` in tests. It is not a rule 19 case, because Raven's behavior is defined. It reproduces the PC behavior, so it changes no Raven form and carries a one-line comment like the `bg` line. The cost is one allocation of the world per map load, and the free of the old one. Rule 3 text says `let world`, and the code already has `var`. The place is `dllEntry` and not `G_InitGame`, because `dllEntry` is the shell's image-load point, and an edit of `G_InitGame` would add a line to Raven's body.

Form (b): add Raven's Xbox clears at his sites, `G_ClPtrClear`, `NPC_NPCPtrsClear`, `RemoveAllWP`, `BG_ClearVehicleParseParms`, and `NAV_ClearStoredWaypoints`. The no-new-names rule allows it, because each one is a Raven function. It resets 4 of the 18 rows, because `BG_ClearVehicleParseParms` clears `bg` state that `dllEntry` already rebuilds. The vehicle pool, siege flags, flag pointers, and the rest stay stale. Raven's caller is the client's `CL_ClearLastLevel`, and no game-side site exists for the first two on a normal map change, so each call needs a site Raven did not choose and an `AI:` comment under rule 24. `RemoveAllWP` also reads the old waypoints, which point into the old `bg` pool.

Form (c): set `gWPNum = 0` or call `RemoveAllWP()` before `B_InitAlloc`. It is the smallest change and stops the trap, but it leaves the vehicle pool `ERR_DROP` and the 16 other rows. It matches neither the PC nor the Xbox build.

Proposed: form (a), one line in `dllEntry`, `world = GameWorld()`, after the `bg` line, with the comment that the engine loads the image again at every map change and the macOS loader keeps it.

The Linux and Windows loaders are untested. glibc can keep a library that has unique symbols, and Windows `FreeLibrary` unloads when the count reaches 0. Form (a) resets the state whether the loader unloads or not, so it is safe on all three platforms.

A side finding: `BgState` has no `deinit`, so each `dllEntry` leaks the old 3,000,000-byte pool. `GameWorld` frees its storage in `deinit`, so form (a) adds no leak.

## The gate on the branch

The branch `map-change-reset` holds the one line in `dllEntry` with its rule 24 comment, and a public initializer on `GameWorld` so the module entry can build it. `swift build` has 0 errors, and `swift test --no-parallel` passes 112 tests in four runs. `tools/load-test.sh` exits 0. The map change run, `+map mp/ffa1 +wait 600 +map mp/duel1 +wait 1600 +map_restart 0 +wait 1200 +map mp/ffa1 +wait 1200` with four bots, ran four game inits, ffa1, duel1, the restart of duel1, and ffa1 again, with 8 kills and no trap, where the same run without the line trapped on duel1 in two runs out of two. No generator, rule, or signature changed, so the draftcheck and snapshot checks are not due.
