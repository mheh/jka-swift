# The dedicated server referee docket

Row E9 of `dedicated-opening-docket.md` is ratified (`dedicated-opening-docket.md:53-57`, `:103`). The Swift dedicated host carries the fork's referee cvars and its `.rec` format as its one piece that is not Raven. One `.rec` file then drives the C host and the Swift host with the same Swift game module, and a step is green when the two `REF STEP` streams match. This docket designs that port. Section 1 describes the fork's referee, section 2 places each hook in Raven's files, section 3 gives the proof, section 4 gives the order of the port, and section 5 holds the rows for a ruling.

## 1. The fork's referee

### The files

The referee is commit `f6d2875e` on the `referee` branch of the fork. The commit changes eight files: `codemp/CMakeLists.txt`, `codemp/qcommon/vm.cpp`, and the six server files `sv_client.cpp`, `sv_gameapi.cpp`, `sv_init.cpp`, `sv_main.cpp`, `sv_referee.cpp`, and `sv_referee.h` (`git -C openjk show --stat f6d2875e`). The submodule pin is `35e4184f`, one commit after the referee (`git submodule status`). That commit adds debug probes to `cg_predict.c`, `g_active.c`, `g_mover.c`, and `msg.cpp`, and its message says the probes are not part of the referee. Two of its probes print `SEAM` and `RSEAM` lines from `MSG_WriteDeltaPlayerstate` (`openjk/codemp/qcommon/msg.cpp:2120-2121`, `:2540`).

`openjk/codemp/server/sv_referee.h` (36 lines) declares the hooks and names the place of each one in a comment (`sv_referee.h:12-35`). `openjk/codemp/server/sv_referee.cpp` (630 lines) holds all the logic. The CMake list adds both files to the server sources (`openjk/codemp/CMakeLists.txt:332-333`).

### The hook sites in the fork

| Hook | Fork site | What it does |
|---|---|---|
| `SVRef_Init` | `SV_Init`, `openjk/codemp/server/sv_init.cpp:1032` | Registers the five cvars and the three commands (`sv_referee.cpp:620-630`). |
| `SVRef_MapSpawned( server )` | the end of `SV_SpawnServer`, `sv_init.cpp:760` | Resets the frame index and the pending steps, opens the record file or starts the replay, and prints `REF READY` (`sv_referee.cpp:570-611`). |
| `SVRef_ServerShutdown` | `SV_Shutdown` after `SV_FinalMessage`, `sv_init.cpp:1095` | Closes the record file and frees the replay buffer (`sv_referee.cpp:613-618`). |
| `SVRef_FrameGate( &msec )` | `SV_Frame` after the `com_sv_running` test, `openjk/codemp/server/sv_main.cpp:1161-1164` | Returns false when the stepper holds the frame, and forces `msec` when a step is granted (`sv_referee.cpp:430-444`). |
| `SVRef_PreGameFrame` | `SV_Frame`, before `GVM_RunFrame`, `sv_main.cpp:1236` | Resets the trace ring and injects the replayed records of the frame (`sv_referee.cpp:447-453`). |
| `SVRef_PostGameFrame` | `SV_Frame`, after `GVM_RunFrame`, `sv_main.cpp:1239` | Increments the frame index and prints `REF STEP` (`sv_referee.cpp:456-460`). |
| `SVRef_GameSeed( Com_Milliseconds() )` | `SV_InitGameVM`, the `GAME_INIT` call, `openjk/codemp/server/sv_gameapi.cpp:2800` | Replaces the seed of `GAME_INIT` (`sv_referee.cpp:555-568`). |
| `SVRef_ForceLegacy` | `SV_BindGame`, `sv_gameapi.cpp:2811-2813` | Binds the game through `dllEntry` and `vmMain` when a referee feature is on (`sv_referee.cpp:548-553`). |
| `SV_GameSystemCalls_Real` | the renamed syscall switch, `sv_gameapi.cpp:1756` | The fork's `SV_GameSystemCalls` becomes a trace wrapper over it (`sv_referee.cpp:140-159`). |
| `SVRef_TraceVmCall` | `VM_Call`, `openjk/codemp/qcommon/vm.cpp:291` | Records each engine-to-game call on the game VM (`sv_referee.cpp:122-137`). |
| `SVRef_RecordDisconnect( drop )` | `SV_DropClient` after the zombie test, `openjk/codemp/server/sv_client.cpp:378` | Writes a type 3 record (`sv_referee.cpp:224-231`). |
| `SVRef_RecordEnterWorld( client )` | `SV_ClientEnterWorld` after `GVM_ClientBegin`, `sv_client.cpp:586` | Writes a type 2 record (`sv_referee.cpp:203-211`). |
| `SVRef_OnClientThink( cl, cmd )` | the top of `SV_ClientThink`, `sv_client.cpp:1322` | Writes a type 1 record (`sv_referee.cpp:213-222`). |

### The cvars and the commands

`SVRef_Init` registers each cvar with the flags 0 (`sv_referee.cpp:621-625`).

| Cvar | Default | Use |
|---|---|---|
| `sv_stepper` | `0` | Gates `SV_Frame`, and `ref_step` grants frames. It also turns on the `REF STEP` line (`sv_referee.cpp:433`, `:458-459`). |
| `sv_recordInputs` | `""` | The qpath of the record file, opened at map load (`sv_referee.cpp:585-594`). |
| `sv_replayInputs` | `""` | The qpath of the replay file, read at the first `GAME_INIT` (`sv_referee.cpp:558-562`, `:265`). |
| `sv_refSeed` | `0` | A nonzero value replaces the seed of `GAME_INIT` and wins over the replay header (`sv_referee.cpp:563-564`). |
| `sv_refTrace` | `0` | Keeps a ring of the boundary calls of the current frame (`sv_referee.cpp:102-111`). |

The three commands are `ref_step [n]`, `ref_dump`, and `ref_trace` (`sv_referee.cpp:627-629`). `ref_step` adds `n` to the pending steps, with 1 as the default and the minimum, and warns when `sv_stepper` is 0 (`sv_referee.cpp:468-475`). `ref_dump` prints each linked or nonzero entity as `REF E <num> <hex s><hex r>` and each connected client as `REF P <num> <hex ps>` between `REF DUMP BEGIN` and `REF DUMP END` (`sv_referee.cpp:495-520`). `ref_trace` prints each ring entry as `REF T <i> IN <cmd> <a0..a3>` or `REF T <i> OUT <cmd> <a0..a7> ret=<r>`, then `REF T OVERFLOW` when the ring of 65536 entries filled, then `REF TRACE END` (`sv_referee.cpp:89`, `:522-540`).

### The `.rec` format

The file starts with one text line, `REFREC v1 map=<mapname> seed=<seed> fps=<sv_fps>` and a newline (`sv_referee.cpp:166-170`, `:590`). The seed is the value that `GAME_INIT` received (`sv_referee.cpp:566`). Binary records follow the line, each one an 8-byte header and a payload, all little-endian (`sv_referee.cpp:179-190`).

| Byte | Field | Value |
|---|---|---|
| 0-3 | `frameIndex` | `ref_frameIndex` when the event occurred, the count of game frames since map load. |
| 4 | `type` | 1, 2, or 3. |
| 5 | `clientNum` | The client slot. |
| 6-7 | `lenOrPad` | The payload length for type 2, else 0. |

| Type | Event | Payload |
|---|---|---|
| 1 | A usercmd, from `SV_ClientThink` | `usercmd_t` at the engine's `sizeof`, 28 bytes (`sv_referee.cpp:220-221`, `tools/reflog2rec.py:21-23`). |
| 2 | The enter-world, from `SV_ClientEnterWorld` or the first usercmd of a bot | The userinfo bytes with no terminator (`sv_referee.cpp:207-209`, `:218-219`). |
| 3 | The disconnect, from `SV_DropClient` | None (`sv_referee.cpp:224-231`). |

The recorder writes the usercmds of bots too, because a bot enters through `G_AddBot` and not `SV_ClientEnterWorld`, so its first usercmd writes its type 2 record (`sv_referee.cpp:200-202`, `:216-219`). The replayer reads only the `seed=` key of the header (`sv_referee.cpp:285-287`). It does not read `map=` or `fps=`, so the command line must set the map and `sv_fps` to the values of the header.

### The `REF STEP` line and the checksum

`SVRef_PostGameFrame` prints `REF STEP n=%d t=%d ck=%08x` after each game frame when `sv_stepper` is on (`sv_referee.cpp:456-460`). `n` is the frame index after the increment, so the first granted frame prints `n=1`. `t` is `sv.time`, the time the fork passed to `GVM_RunFrame` (`sv_main.cpp:1234-1238`). `ck` is `Ref_Checksum()`.

`Ref_Checksum` is FNV-1a 32 with the offset basis 2166136261 and the prime 16777619 (`sv_referee.cpp:38-45`, `:59`). It folds, in this order:

1. For each entity from 0 to `sv.num_entities - 1`, the bytes of `ent->s` (`entityState_t`) and then `ent->r` (`entityShared_t`). It skips an entity when both are all zero (`sv_referee.cpp:62-72`).
2. For each client slot from 0 to `sv_maxclients - 1` in state `CS_CONNECTED` or above, the bytes of its `playerState_t` from `SV_GameClientNum` (`sv_referee.cpp:73-79`).

The bytes are the game module's memory at the base that `SV_LocateGameData` gave. `entityState_t`, `entityShared_t`, and `playerState_t` hold no pointer field (`oracle/codemp/game/q_shared.h:2169-2435`, `:2670-2832`, `oracle/codemp/game/g_public.h:60-95`), so the checksum holds no host address. The fork prints the sizes once per map in `REF READY ... es=532 er=112 ps=1552 cmd=28` (`sv_referee.cpp:605-610`, `~/Developer/jka/seam-test/referee/logs/record.log:43`).

### The record mode

`sv_recordInputs` names the file. `SVRef_MapSpawned` closes any open file, opens the new one with `FS_FOpenFileWrite`, and writes the header line (`sv_referee.cpp:579-594`). The record mode does not need the stepper. The hooks in `sv_client.cpp` write the records as the events occur, each tagged with the current frame index. `SV_Shutdown` closes the file and prints `REF RECORD END` (`sv_referee.cpp:192-198`). When `sv_replayInputs` is also set, the recorder stays off and prints a warning (`sv_referee.cpp:581-584`).

### The replay mode

`SVRef_GameSeed` loads the file at the first `GAME_INIT`, so the header seed reaches the game (`sv_referee.cpp:257-293`, `:558-562`). `SVRef_MapSpawned` sets the cursor to the first record and turns the replay on (`sv_referee.cpp:597-603`). Before each game frame, `Ref_ReplayAdvance` runs every record whose frame index is at or below the current index (`sv_referee.cpp:355-376`):

- Type 2 calls `Ref_SpawnFake`. It clears the slot, sets the address type to `NA_BOT`, calls `GVM_ClientConnect( num, qtrue, qfalse )` so the game runs the human path, sets the client fields, and calls `GVM_ClientBegin` (`sv_referee.cpp:295-338`).
- Type 1 calls `SV_ClientThink` with the recorded usercmd when the slot is a fake client in `CS_ACTIVE`. A flag stops the recorder from a second write (`sv_referee.cpp:379-386`).
- Type 3 calls `Ref_DropFake`, which calls `GVM_ClientDisconnect` and frees the slot (`sv_referee.cpp:340-352`).

At the end of the file, the replayer drops every fake client and prints `REF REPLAY END`. On each frame it sets `lastPacketTime` of each fake client to `svs.time`, so no fake client times out (`sv_referee.cpp:406-418`).

### How the stepper gates `SV_Frame`

`SVRef_FrameGate` returns true at once when `sv_stepper` is 0 (`sv_referee.cpp:433-434`). When the stepper is on and no step is pending, it returns false, and `SV_Frame` returns before `SV_CheckPaused` (`sv_referee.cpp:436-437`, `sv_main.cpp:1162-1164`). When `n` steps are pending, it sets `msec` to `n * (1000 / sv_fps)`, clears the pending count, and sets `sv.timeResidual` to 0 (`sv_referee.cpp:439-443`). The chunk loop of `SV_Frame` then runs exactly `n` game frames inside one call of `SV_Frame` (`sv_main.cpp:1231-1240`). `SV_CalcPings`, `SV_BotFrame`, `SV_CheckTimeouts`, and `SV_SendClientMessages` run once for the batch, not once per frame (`sv_main.cpp:1226-1228`, `:1251-1254`). `SVRef_MapSpawned` clears the pending steps, so a `ref_step` before the map load has no effect (`sv_referee.cpp:575`).

### The precedent of a port in jka-rust

jka-rust ported a referee, but not this format. `jka-rust/crates/mp/engine/server/src/sv_referee.rs` (1788 lines) calls itself new engine tooling and not a Raven port (`sv_referee.rs:1-11`). Its tape is text: an `H <map> <sv_fps> <sv_maxclients> <seed>` header and `C`, `B`, `X`, `T`, `D`, `P`, `F`, `S`, `V`, and `E` records, with each payload in hex (`sv_referee.rs:105-152`). Its digest is FNV-1a 64 (`sv_referee.rs:78-87`). It folds each entity's `entityState_t` prefix with no zero skip and no `entityShared_t`, and each connected slot's `playerState_t` (`sv_referee.rs:328-368`). It also keeps a digest of the ordered syscall numbers of the frame (`sv_referee.rs:776-781`). Its cvars are `ref_record`, `ref_replay`, `ref_follow`, `ref_state`, `ref_haltOnDiverge`, `ref_calls`, `ref_seed`, and `ref_snaps` (`jka-rust/crates/mp/engine/server/src/sv_init.rs:1159-1175`). Its seed pin sits inside `Com_Milliseconds` and fires once (`jka-rust/crates/mp/engine/qcommon/src/common_fns.rs:540-558`). Its replay forces the msec of each frame from the tape instead of a step grant (`sv_referee.rs:5-10`).

jka-rust places its hooks at the sites the fork chose, in its ports of Raven's functions: `SV_Frame` at `jka-rust/crates/mp/engine/server/src/sv_main.rs:1028`, `:1109`, and `:1133`, `SV_SpawnServer` at `sv_init.rs:692`, `SV_Shutdown` at `sv_init.rs:1233`, the client hooks at `sv_client.rs:259`, `:509`, and `:1742`, and the syscall tap at `sv_game.rs:794`. It adds taps the fork does not have: client commands (`sv_client.rs:438`), connects (`sv_client.rs:1027`), pings (`sv_main.rs:909`), and snapshots (`sv_snapshot.rs:245`).

`jka-rust/tools/lockstep-referee/run.sh` boots two `mp_app` engines (`run.sh:4-10`, `:40`). The primary records the tape with `ref_record` (`run.sh:73-76`). The secondary follows the tape with `ref_replay` and `ref_follow 1` and prints `REF DIVERGE` (`run.sh:90-94`, `:111`). Both engines are jka-rust's own engine. The precedent shows that one engine port can hold the referee in its own `SV_Frame`, `SV_SpawnServer`, and client functions. It does not give a format the Swift host can share with the fork, because a `.rec` file cannot drive `mp_app` and a jka-rust tape cannot drive `openjkded`. `tools/reflog2rec.py` converts a jka-rust harness log into a `.rec` (`tools/reflog2rec.py:1-12`), but no tool converts a tape.

The fork's own A/B driver is `~/Developer/jka/seam-test/referee/referee.py`, outside both repos. It starts two copies of one `openjkded` binary with two game modules (`run-ab.sh:21-37`), sends `ref_step n` to both on stdin, and compares `n` and `ck` of each pair of `REF STEP` lines (`referee.py:600-633`). A difference in `t` alone prints a note and is not a divergence (`referee.py:633-635`). It waits for `REF READY` on both sides before the first step and warns when the two lines differ (`referee.py:638-652`). It sets `bot_enable 0` (`referee.py:561`).

## 2. The sites in Raven's files

The Swift host ports Raven's files, so each hook lands in Raven's function at the place below. Each site carries one `// AI:` line under rule 24 (`docs/porting-rules.md:71`).

| Hook | Raven function | Raven site |
|---|---|---|
| `SVRef_Init` | `SV_Init`, `oracle/codemp/server/sv_init.cpp:803` | After `SV_BotInitBotLib` at `:878` and before the Ghoul2 heap line at `:883-885`, the same place as the fork's line before its heap comment. |
| `SVRef_MapSpawned( server )` | `SV_SpawnServer`, `sv_init.cpp:472` | After `Hunk_SetMark` at `:782`, the last statement before the close at `:791`. |
| `SVRef_ServerShutdown` | `SV_Shutdown`, `sv_init.cpp:929` | After `SV_FinalMessage` at `:938-940` and before `SV_RemoveOperatorCommands` at `:942`. |
| `SVRef_FrameGate( &msec )` | `SV_Frame`, `oracle/codemp/server/sv_main.cpp:826` | After the `com_sv_running` test at `:837-839` and before `SV_CheckPaused` at `:842`. |
| `SVRef_PreGameFrame` | `SV_Frame` | Inside the chunk loop, after `svs.time += frameMsec` at `:911` and before `VM_Call( gvm, GAME_RUN_FRAME, svs.time )` at `:914`. |
| `SVRef_PostGameFrame` | `SV_Frame` | After the `VM_Call` at `:914`, inside the loop. |
| `SVRef_GameSeed` | `SV_InitGameVM`, `oracle/codemp/server/sv_game.cpp:1682` | The seed argument `Com_Milliseconds()` of `VM_Call( gvm, GAME_INIT, ... )` at `:1690`. |
| Syscall trace | `SV_GameSystemCalls`, `sv_game.cpp:458` | The entry and the return of the switch. Row H5 rules the form. |
| `SVRef_TraceVmCall` | `VM_Call`, `oracle/codemp/qcommon/vm.cpp:787` | After the argument read at `:810-814` and before the `entryPoint` call at `:816`, under `vm == gvm`. |
| `SVRef_RecordDisconnect( drop )` | `SV_DropClient`, `oracle/codemp/server/sv_client.cpp:580` | After the zombie test at `:584-586`. |
| `SVRef_RecordEnterWorld( client )` | `SV_ClientEnterWorld`, `sv_client.cpp:943` | After `VM_Call( gvm, GAME_CLIENT_BEGIN, ... )` at `:969`. |
| `SVRef_OnClientThink( cl, cmd )` | `SV_ClientThink`, `sv_client.cpp:1652` | The first statement, before `cl->lastUsercmd = *cmd` at `:1653`. |
| `SVRef_ForceLegacy` | none | Raven binds the game only through `dllEntry` and `vmMain` (`oracle/codemp/null/win_main.cpp:827-833`, `oracle/codemp/qcommon/vm.cpp:518`), so the hook has no site. |

Raven differs from the fork at five of these sites:

- Raven has no `sv.time`. Raven's `SV_Frame` passes `svs.time` to `GAME_RUN_FRAME` (`sv_main.cpp:911-914`), and `server.h` holds only the `svs.time` that increases across level changes (`oracle/codemp/server/server.h:211`). The fork passes `sv.time`, which `sv` clears at each map (`openjk/codemp/server/server.h:80`, `sv_main.cpp:1234-1238`). Both trees add 100 four times in `SV_SpawnServer` (`oracle/codemp/server/sv_init.cpp:668-674`, `:731-733`, `openjk/codemp/server/sv_init.cpp:630-633`, `:690-693`), and neither sets either time elsewhere. So the two values are equal for the first map of a fresh process and differ after a map change. The fork's log shows `REF STEP n=1 t=425` at `sv_fps 40` (`~/Developer/jka/seam-test/referee/logs/c.log:88`). Row H3 rules the `t` field.
- Raven's `VM_Call` has no `vm->slot`, and it reads its arguments from a `va_list` (`oracle/codemp/qcommon/vm.cpp:787-819`). The trace site tests `vm == gvm` and reads the words after the `va_list` read.
- Raven's `SV_Frame` returns through `NET_Sleep` on a dedicated server when the residual is short of a frame (`sv_main.cpp:856-861`). A gate return before that line skips the sleep, and Raven's `Com_Frame` then loops on `Com_EventLoop` with `minMsec` 1 (`oracle/codemp/qcommon/common.cpp:1642-1653`). Row H4 rules the place.
- Raven's `Ref_SpawnFake` counterpart calls `VM_Call( gvm, GAME_CLIENT_CONNECT, num, qtrue, qfalse )` and casts the result, as `SV_DirectConnect` does (`oracle/codemp/server/sv_client.cpp:520`). Raven's `client_t` has no `wishSnaps` (`oracle/codemp/server/server.h:140-195`), so the fork's line `cl->wishSnaps = sv_fps->integer` (`sv_referee.cpp:328`) has no target. `SV_SetUserinfo` is at `oracle/codemp/server/sv_init.cpp:168`.
- Raven's `Cvar_Get` and `Cmd_AddCommand` take no help string (`oracle/codemp/server/sv_init.cpp:828`, `oracle/codemp/server/sv_ccmds.cpp:980`), so the fork's help strings (`sv_referee.cpp:621-629`) drop.

The file I/O that the referee calls is in Raven's `files_pc.cpp`: `FS_FCloseFile` at `:461`, `FS_FOpenFileWrite` at `:491`, `FS_Write` at `:1079`, `FS_ReadFile` at `:1259`, and `FS_FreeFile` at `:1379` (`oracle/codemp/qcommon/files_pc.cpp`). WinDed compiles `files_pc.cpp` and `files_common.cpp` (`oracle/codemp/WinDed.vcproj:219-222`).

## 3. The proof shape

### The fork binary

The C host is `.build/openjk/openjkded.arm64`. The file exists, dated from the Release build of the submodule tree (`.build/openjk/CMakeCache.txt:75`, `:469`). Its strings hold `REF STEP n=%d t=%d ck=%08x`, the `REFREC v1` header, and the `SEAM` probe, so it holds the referee commit and the probe commit. `notes/2026-10-09/engine-build.md:18-26` gives its CMake lines, with `BuildMPDed=ON` (`.build/openjk/CMakeCache.txt:30`). A second build, `../OpenJK/build-referee/openjkded.arm64`, also exists and is the binary of `run-ab.sh` (`~/Developer/jka/seam-test/referee/run-ab.sh:20`). The proof needs only the first binary and no rebuild.

### The game module

One `swift build` gives `.build/debug/libjampgame.dylib`. The proof copies the same file into the mod folder of each homepath as `jampgamearm64.dylib`, as `tools/load-test.sh:26-28` does, and checks that the two copies have one `shasum`. Raven's `Sys_LoadDll` forms the name `<module>x86.dll` (`oracle/codemp/null/win_main.cpp:795`), so the Swift host loads the shared name only after row H7.

### The corpus

The proof takes one `.rec` from `~/Developer/jka/seam-test/referee/`. `corpus-ffa1.rec` has the header `REFREC v1 map=mp/ffa1 seed=42 fps=40`. The proof copies it into the mod folder of each homepath, because the replayer reads it through `FS_ReadFile` as a qpath (`sv_referee.cpp:265`), the way `notes/2026-10-29/human-recordings.md:7-9` ran its replays.

### The command lines

The two lines set every cvar whose default differs between the trees. Raven's `sv_fps` default is 20 and the fork's is 40 (`oracle/codemp/server/sv_init.cpp:852`, `openjk/codemp/server/sv_init.cpp:986`). Raven's `sv_pure` default is 1 (`oracle/codemp/server/sv_init.cpp:840`). Both trees default `sv_maxclients` to 8 (`oracle/codemp/server/sv_init.cpp:828`, `openjk/codemp/server/sv_init.cpp:956`), and a corpus can hold a client slot above 7 (`notes/2026-10-29/human-recordings.md:15`), so both lines set 32. `bot_enable 0` keeps the botlib frame off, because `SV_BotFrame` returns at once (`oracle/codemp/server/sv_bot.cpp:586-587`), and the replay drives recorded bots as fake human clients. Raven's dedicated build forces `dedicated` to 2 as a read-only cvar (`oracle/codemp/qcommon/common.cpp:1289-1290`), so the Swift line does not set it. The fork accepts 1 or 2 (`openjk/codemp/qcommon/common.cpp:1223-1225`). `ttycon` is the fork's cvar and Raven has none.

```sh
BASE="$HOME/Library/Application Support/Steam/steamapps/common/Jedi Academy/SWJKJA.app/Contents"
N=4000

.build/openjk/openjkded.arm64 \
    +set fs_homepath /tmp/jka-ref/c +set fs_basepath "$BASE" +set fs_game swift \
    +set dedicated 1 +set ttycon 0 +set sv_pure 0 +set vm_game 0 \
    +set sv_fps 40 +set sv_maxclients 32 +set g_gametype 0 +set bot_enable 0 \
    +set sv_stepper 1 +set sv_replayInputs corpus-ffa1.rec \
    +map mp/ffa1 +ref_step $N +wait 5 +quit > /tmp/jka-ref/c.log 2>&1

.build/debug/jampded \
    +set fs_homepath /tmp/jka-ref/swift +set fs_basepath "$BASE" +set fs_game swift \
    +set sv_pure 0 +set vm_game 0 \
    +set sv_fps 40 +set sv_maxclients 32 +set g_gametype 0 +set bot_enable 0 \
    +set sv_stepper 1 +set sv_replayInputs corpus-ffa1.rec \
    +map mp/ffa1 +ref_step $N +wait 5 +quit > /tmp/jka-ref/swift.log 2>&1

grep -o 'REF READY.*' /tmp/jka-ref/c.log     > /tmp/jka-ref/c.ready
grep -o 'REF READY.*' /tmp/jka-ref/swift.log > /tmp/jka-ref/swift.ready
grep -o 'REF STEP.*'  /tmp/jka-ref/c.log     > /tmp/jka-ref/c.steps
grep -o 'REF STEP.*'  /tmp/jka-ref/swift.log > /tmp/jka-ref/swift.steps
diff /tmp/jka-ref/c.ready /tmp/jka-ref/swift.ready
diff /tmp/jka-ref/c.steps /tmp/jka-ref/swift.steps
```

The `map` command loads the map, `SVRef_MapSpawned` clears the pending count, and then `ref_step N` grants all `N` frames to the next `SV_Frame`. The human recordings ran their replays in this form (`notes/2026-10-29/human-recordings.md:9`). `grep -o` removes a timestamp prefix, which the fork can print (`~/Developer/jka/seam-test/referee/logs/record.log:43`).

### What counts as green

A step is green when all of these are true:

1. The two `REF READY` lines are equal. This proves one map, one seed, one `sv_fps`, and equal sizes of `entityState_t`, `entityShared_t`, `playerState_t`, and `usercmd_t`.
2. Each side prints `N` `REF STEP` lines, and `diff` of the two streams is empty, so `n`, `t`, and `ck` match on every line.
3. When `N` passes the last record of the file, each side prints `REF REPLAY END`.

On a mismatch, the reader runs both hosts again to the frame before the first differing line, then sends `ref_dump` and `ref_trace` to both. `referee.py` already maps a dump byte offset to a field name (`~/Developer/jka/seam-test/referee/referee.py:413-472`). A trace argument that holds a pointer differs between hosts by its value, so a trace diff compares the command numbers and the integer arguments only.

## 4. The order of the port

### The smallest comparable frame

The smallest frame that prints a comparable checksum has no replay and no client: `+set sv_stepper 1 +set sv_refSeed 42 +map mp/ffa1 +ref_step 1`. The checksum then covers the entities alone, after `GAME_INIT`, the four spawn frames, and one granted frame. The seed comes from `sv_refSeed`, so the C host gives the same value on each run.

The files on that path, by call:

- `oracle/codemp/null/win_main.cpp`: `main` calls `Com_Init`, `NET_Init`, and `Com_Frame` (`:1410`, `:1457`, `:1459`, `:1493`), and `Sys_LoadDll` loads the game (`:784-833`).
- `oracle/codemp/qcommon/common.cpp`: `Com_Init` calls `Cvar_Init`, `Cbuf_Init`, `Com_InitZoneMemory`, `Cmd_Init`, `FS_InitFilesystem`, `Com_InitHunkMemory`, `SE_Init`, `Sys_Init`, `Netchan_Init`, `VM_Init`, and `SV_Init` (`:1226-1385`). `Com_Frame` calls `SV_Frame` (`:1669`).
- `cvar.cpp`, `cmd_common.cpp`, `cmd_pc.cpp`, and `z_memman_pc.cpp` for the cvars, the command buffer, `wait` (`oracle/codemp/qcommon/cmd_common.cpp:506`), and the memory.
- `files_pc.cpp`, `files_common.cpp`, and `unzip.cpp` with the zlib C target of row E14, to read the pk3 files and the `.rec`.
- `cm_load.cpp`, `cm_test.cpp`, `cm_trace.cpp`, `cm_patch.cpp`, `cm_polylib.cpp`, and `cm_shader.cpp` for the map, and `md4.cpp` for `Com_BlockChecksum` in `CM_LoadMap` (`oracle/codemp/qcommon/cm_load.cpp:541`, `:558`, `:695`).
- `stringed_ingame.cpp` and `stringed_interface.cpp` for `SE_Init`.
- `win_shared.cpp` and `win_net.cpp` for the clock, `NET_Init`, and `NET_Sleep`, and `net_chan.cpp` for `Netchan_Init`.
- `vm.cpp` for `VM_Init`, the dll arm of `VM_Create` (`oracle/codemp/qcommon/vm.cpp:515-521`), and `VM_Call`.
- `sv_init.cpp`, `sv_ccmds.cpp` for `map` (`oracle/codemp/server/sv_ccmds.cpp:980`), `sv_game.cpp` for `SV_LocateGameData`, `SV_GentityNum`, `SV_GameClientNum`, and every syscall arm the game calls on this path (`oracle/codemp/server/sv_game.cpp:54-68`, `:327-335`), `sv_world.cpp` for the links and the traces, `sv_main.cpp` for `SV_Frame`, and `sv_bot.cpp` for `SV_BotInitBotLib` (`oracle/codemp/server/sv_init.cpp:878`).
- `sv_snapshot.cpp` and `sv_client.cpp` for `SV_SendClientMessages` and `SV_CheckTimeouts`, which `SV_Frame` calls on each frame (`oracle/codemp/server/sv_main.cpp:926-929`). With no client, their loops do no work.
- The C++ subsystems of row E5, linked behind their headers, and the referee file itself.

The fork measures the syscall arms this path needs. The trace ring resets only in `SVRef_PreGameFrame` (`sv_referee.cpp:447-452`), and the spawn frames call `GVM_RunFrame` directly (`openjk/codemp/server/sv_init.cpp:630`, `:690`). So `+set sv_refTrace 1 +set sv_stepper 1 +map mp/ffa1 +ref_trace` on the C host prints every syscall of `GAME_INIT` and the four spawn frames. A second `+ref_step 1 +ref_trace` prints the calls of the first granted frame. The `OUT` command numbers are the arms the first step ports in Swift, and the rest of `sv_game.cpp` can stay as stubs.

### The first frame with a client

The next step replays a corpus. A fake client adds `SV_ClientThink`, `SV_DropClient`, and `SV_SetUserinfo` (`oracle/codemp/server/sv_client.cpp:580`, `:1652`, `oracle/codemp/server/sv_init.cpp:168`). It also adds the snapshot path, because `SV_SendClientMessages` builds a snapshot for each client with a state (`oracle/codemp/server/sv_snapshot.cpp:812-826`), and only `NET_SendPacket` drops the packet of an `NA_BOT` address (`oracle/codemp/qcommon/net_chan.cpp:542-544`). So `msg.cpp`, `huffman.cpp`, `sv_snapshot.cpp`, and `sv_net_chan.cpp` must run before the first replay step. The snapshot does not write game memory, so a fault there stops the run but does not change the checksum.

Engine-side random numbers are a risk for later corpora. Both trees seed the engine's `holdrand` from the clock in `Com_Init` (`oracle/codemp/qcommon/common.cpp:1248`, `openjk/codemp/qcommon/common.cpp:1187`). Raven's engine calls `irand` and `flrand` in `server/NPCNav/navigator.cpp` and in the terrain files (`grep -rln irand oracle/codemp/server oracle/codemp/qcommon`). Row H11 rules it.

### What a step before the first frame proves

Before the host runs a frame, two proofs stand alone:

- The huff golden of row E10. It proves `huffman.cpp` against `jka-rust/tools/huff-oracle/goldens/codes.txt`, `chat.txt`, and `seq.txt`, the per-symbol codes and two bitstreams of `msgHuff` (`notes/2026-11-03/dedicated-scout.md:330`). It does not prove `msg.cpp` beyond the Huffman calls.
- Swift unit tests of the referee's pure parts. FNV-1a 32 over known vectors proves `Ref_Fnv1a`. A parse of a small `.rec` proves the header and record decode, with the record count that `tools/reflog2rec.py` wrote. `reflog-real-duel1-idle.rec` is 866 bytes. A byte test of the header line proves the record writer's text against the fork's format string (`sv_referee.cpp:590`). A size test proves `MemoryLayout` sizes of 532, 112, 1552, and 28 for the four records, the values of the fork's `REF READY` line.

These tests prove the format and the hash. They do not prove a frame, because no frame runs without the files of the list above.

## 5. Rows

### H1, the referee file

The fork's logic lives in one file outside Raven's set (`openjk/codemp/server/sv_referee.cpp`). Proposed: the Swift host holds one file `sv_referee.swift` in its logic target, ported function by function from the fork's file, with the fork's names, including `Ref_Checksum`, `Ref_ReplayAdvance`, and `SVRef_*`. Its 22 file-scope variables go into `EngineWorld` under a `MARK: - sv_referee`, as row E4 sets for every file (`sv_referee.cpp:22-30`, `:98-100`, `:175-177`, `:239-246`). The file's header comment states that the file is the fork's, so the file carries no `// AI:` line per function. The hook sites in Raven's files carry the `// AI:` lines.

### H2, the parts that port

The fork has seven parts: the stepper, the recorder, the replayer, the seed, the checksum, the dump, and the trace, plus the legacy bind (`notes/2026-11-03/dedicated-scout.md:303-312`). Proposed: all seven port, so that `ref_dump` and `ref_trace` work on both hosts when a step fails. `SVRef_ForceLegacy` does not port, because Raven binds the game only through `dllEntry` and `vmMain`, and the hook has no site.

### H3, the time in the `REF STEP` line

The fork prints `sv.time`, and Raven has only `svs.time` (section 2). The two values are equal for the first map of a fresh process. Proposed: the Swift line prints `svs.time`, the time Raven passes to `GAME_RUN_FRAME`, with one `// AI:` line. Every proof runs one map per process, with no `map_restart` and no map change. A corpus that needs a second map waits for its own row.

### H4, the gate and Raven's sleep

The fork places the gate after the `com_sv_running` test (`openjk/codemp/server/sv_main.cpp:1161-1164`). At that place in Raven, a held frame skips the `NET_Sleep` of `oracle/codemp/server/sv_main.cpp:856-861`, and the process spins in `Com_Frame` while it waits for a `ref_step`. Proposed: the gate takes the fork's place, before `SV_CheckPaused` at `:842`. A stepper run is a test run, and the command-line form grants all frames in the first `SV_Frame` after the map load, so the spin is short. A later row can add a sleep if a stdin driver holds the host for long.

### H5, the syscall trace

The fork renames its switch to `SV_GameSystemCalls_Real` and puts the trace in a wrapper with the old name (`openjk/codemp/server/sv_gameapi.cpp:1756`, `sv_referee.cpp:140-159`). Raven's switch is `SV_GameSystemCalls` (`oracle/codemp/server/sv_game.cpp:458`), and row E3 makes the Swift `SV_GameSystemCalls(words)` the one function that `CJKAHost` calls. Proposed: the Swift host takes the fork's form. Raven's switch becomes `SV_GameSystemCalls_Real` with one `// AI:` line, and `sv_referee.swift` holds the wrapper `SV_GameSystemCalls`. Both names have a fork counterpart, so the change adds no helper without a counterpart.

### H6, the `VM_Call` trace site

Raven's `VM_Call` has no `slot` field and reads its words from a `va_list` (`oracle/codemp/qcommon/vm.cpp:787-819`). Proposed: the trace line tests `vm == gvm` and sits after the word read at `:810-814`, before the `entryPoint` call at `:816`, with one `// AI:` line. The interpreter arm at `:820-824` calls the same trace, because row E13 keeps the QVM.

### H7, the name of the game library

Raven forms `<module>x86.dll` and looks first in the working directory and then under `fs_basepath` and `fs_cdpath` with `fs_game` (`oracle/codemp/null/win_main.cpp:795-822`). It first copies the file out of a pk3 through `Sys_UnpackDLL` (`:735-775`, `:797`). The fork and `tools/load-test.sh` use `jampgamearm64.dylib` in the mod folder of the homepath (`tools/load-test.sh:26-28`). Proposed: the Swift `Sys_LoadDll` forms the name from the host's architecture and library suffix, `jampgamearm64.dylib` on this Mac, and also looks under `fs_homepath` with `fs_game`, with one `// AI:` line. The same mod folder then serves both hosts. `Sys_UnpackDLL` keeps Raven's form.

### H8, the cvar defaults on the proof line

Raven and the fork differ on the defaults of `sv_fps` and `sv_pure` (section 3). Proposed: the Swift host keeps Raven's defaults, and the proof line sets `sv_fps`, `sv_pure`, `sv_maxclients`, `g_gametype`, `bot_enable`, and `vm_game` on both hosts. The `fps=` field of the `.rec` header sets the value of `sv_fps` on the line, because the replayer does not read it (`sv_referee.cpp:285-287`).

### H9, what green means against an OpenJK host

The C host is OpenJK's engine, not Raven's, and retail `jampded` cannot load a 64-bit module (`docs/porting-rules.md:36`). A mismatch can come from a Swift port fault or from an OpenJK change to Raven's engine. Proposed: green is the three tests of section 3, with no allowance. When `ref_dump` and `ref_trace` trace a mismatch to an OpenJK change with a citation in both trees, the Swift host keeps Raven's form. The mismatch becomes a row of its own, and the step claims the frames before the first mismatch. A step never claims a frame with a mismatch.

### H10, the A/B tool

`referee.py` steps two copies of one binary and lives outside both repos (`~/Developer/jka/seam-test/referee/run-ab.sh:21-37`). The command-line form of section 3 needs only `grep` and `diff`. Proposed: the first proof uses a shell script `tools/host-referee.sh` in the shape of `tools/load-test.sh`. The script builds the module, sets up the two homepaths, runs both hosts, and prints the two `diff` results and the frame count. Stepwise A/B with `referee.py` on stdin waits until the Swift host reads its console, and it then needs a second engine path in `referee.py`, which is outside the repo.

### H11, the engine's random seed

Both trees seed the engine's `holdrand` from the clock (`oracle/codemp/qcommon/common.cpp:1248`, `openjk/codemp/qcommon/common.cpp:1187`). jka-rust pins its engine's random services in both engines (`jka-rust/docs/plans/2026-07-13-engine-lockstep-referee.md:57-61`). The fork does not pin them. Its A/B runs passed `corpus-ffa1` and `corpus-ffa1-combat` with zero divergence, in the words of the commit message (`git -C openjk show f6d2875e`), and the commit says nothing about the seeds of the two processes. Proposed: no pin. The first corpora are `mp/ffa1` with no NPC and no live bot, so NPCNav and the terrain do not run. A mismatch that traces to `irand` or `flrand` in the engine opens a row for a pin through `sv_refSeed` on both hosts.

### H12, the corpus and the test fixture

The `.rec` files live in `~/Developer/jka/seam-test/referee/`, outside both repos. Proposed: the first claimed corpus is `corpus-ffa1.rec`, at seed 42 and `fps=40`. The repo commits one file, `reflog-real-duel1-idle.rec` (866 bytes), into `JKATestSupport` as the fixture of the parser test of section 4. Each larger corpus stays outside the repo, and the step record names its path and its `shasum`.

### H13, the sentence for rule 16

Row E9 says rule 16 gains one sentence for the host (`dedicated-opening-docket.md:57`). Proposed text, after the sentence on a game module step: "The proof of a host step is one `.rec` file that the fork's `openjkded` and the Swift `jampded` replay with the same Swift game module, green when the two `REF READY` lines are equal and the two `REF STEP` streams match across the frames the step claims."

### H14, the probe commit in the fork binary

`.build/openjk/openjkded.arm64` holds the probe commit `35e4184f`, which prints `SEAM` and `RSEAM` lines on each player state delta (`openjk/codemp/qcommon/msg.cpp:2120-2121`, `:2540`). The probes print only and do not change state, and the `grep -o` filter drops their lines. Proposed: the proof uses the binary as it is, and the submodule pin does not move. A rebuild at `f6d2875e` waits until the probes cost time in a long replay.

## The ledger

The user delegated the rows on 2026-11-03 with the words "remember to prove the rows and auto rule. match existing codebase patterns in reference to the rows". A proving agent opened every citation, the coordinator read the failures and the sources below, and each ruling takes the form the game and cgame already use for the same shape.

- H1, ratified as proposed. One `sv_referee.swift` from the fork's file, its 22 variables on `EngineWorld` under a MARK, as rule 3 places every file's state.
- H2, ratified as proposed. All seven parts port, and `SVRef_ForceLegacy` does not.
- H3, ratified as proposed. The line prints `svs.time` with one `// AI:` line, and every proof runs one map per process.
- H4, ratified as proposed. The gate takes the fork's place before `SV_CheckPaused`.
- H5, ratified as proposed. Raven's switch becomes `SV_GameSystemCalls_Real`, and the wrapper keeps the name `CJKAHost` calls.
- H6, ratified as proposed.
- H7, ratified as proposed. The name comes from the host's architecture and suffix, `jampgamearm64.dylib` here, the name the engine already loads for the cgame, and the lookup adds `fs_homepath` with `fs_game`.
- H8, ratified as proposed. Raven's defaults stay, and the proof line sets the six cvars on both hosts.
- H9, ratified as proposed. Green has no allowance, and a mismatch traced to an OpenJK change becomes its own row.
- H10, ratified as proposed. `tools/host-referee.sh` in the shape of `tools/load-test.sh`.
- H11, ratified as amended. No pin. The sentence on the fork's A/B runs now states the commit's words alone, because the commit says nothing about the seeds of the two processes.
- H12, ratified as proposed. The 866-byte fixture lands in `JKATestSupport`, where every committed golden lives under rule 18.
- H13, ratified as proposed. The sentence lands in `docs/porting-rules.md` in the PR of the first referee commit, in the timeless form the docs keep.
- H14, ratified as proposed. The binary serves as it is, and the pin does not move.
