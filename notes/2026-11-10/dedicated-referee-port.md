# The port of the referee into the dedicated server

The record of the port of the fork's `openjk/codemp/server/sv_referee.cpp` (commit `f6d2875e`) into `jampded`, under rows H1 to H14 of `notes/2026-11-03/dedicated-referee-docket.md`. Branch `dedicated-referee-port`, from master `f292db9`.

## What landed per row

- H1, landed. `Sources/JKAMP_DedLogic/sv_referee.swift` holds every function of the fork's file with the fork's names. The 22 file variables are on `EngineWorld` under `MARK: - sv_referee.cpp`, and each has a computed global of its fork name in `sv_referee.swift`. The header comment states that the file is the fork's.
- H2, landed. The stepper, the recorder, the replayer, the seed, the checksum, the dump, and the trace port. The legacy bind of `SV_BindGame` has no site. `SVRef_ForceLegacy` ports as a predicate only, because `SVRef_MapSpawned` reads it to print `REF READY`.
- H3, landed. The `REF STEP` line prints `svs.time`, with one AI line in `SVRef_PostGameFrame`.
- H4, landed. `SVRef_FrameGate` sits after the `com_sv_running` test and before `SV_CheckPaused` in `SV_Frame`. `SV_Frame` takes a mutable copy of `msec`, the form of `Com_Frame`.
- H5, landed. Raven's switch is `SV_GameSystemCalls_Real` in `sv_game.swift`, and the public wrapper `SV_GameSystemCalls` in `sv_referee.swift` keeps the name that `jampded/main.swift` installs.
- H6, landed. `VM_Call` in `vm.swift` calls `SVRef_TraceVmCall` under `vm == gvm`, after the word read and before the arms, so the QVM arms see the trace too.
- H7, landed. The name part was already on master (`DLL_SUFFIX`). `Sys_LoadDll` now looks under `fs_homepath` with `fs_game` first, then `fs_basepath`, then `fs_cdpath`, in the order of the fork's loader.
- H8, landed as a run fact. Raven's defaults stay, and the run line sets the six cvars.
- H9, landed as a run fact. The first comparison has no mismatch, so no OpenJK row opens.
- H10, landed earlier with `tools/host-referee.sh`. The script was not run, because its scratch folder is `/tmp/jka-referee`, the path of this worktree, and it runs `rm -rf` on that folder.
- H11, landed as a run fact. No pin. The single frame matches with the engine seed from the clock.
- H12, landed earlier with the fixture. The new tests use an inline sample and the fixture's header line.
- H13, landed earlier at `docs/porting-rules.md:36`.
- H14, landed as a run fact. The fork binary `.build/openjk/openjkded.arm64` ran as it is.

## The hook sites

Each site carries one AI line: `SVRef_Init` after `SV_BotInitBotLib` in `SV_Init`, `SVRef_MapSpawned(server)` after `Hunk_SetMark` in `SV_SpawnServer`, `SVRef_ServerShutdown` after `SV_FinalMessage` in `SV_Shutdown`, the gate and the two frame hooks in `SV_Frame`, `SVRef_GameSeed(Com_Milliseconds())` in `SV_InitGameVM`, the trace in `VM_Call`, `SVRef_RecordDisconnect` after the zombie test of `SV_DropClient`, `SVRef_RecordEnterWorld` after `GAME_CLIENT_BEGIN` in `SV_ClientEnterWorld`, and `SVRef_OnClientThink` first in `SV_ClientThink`.

## Forms that follow an existing pattern

- The record bytes for the checksum and the dump are `Slots(record: ent.s).bytes`, the form of `common.swift:1088` and `msg.swift:1189`.
- The replay buffer is the `OpaquePointer` form of `FS_ReadFile` and `ZipBackend.bytes`, the form of `SE_LoadFileData`. The record fields read through `p[int: 0]` and `p[ushort: 6]`.
- The 8-byte record header is a `CharBuf` for the `CharBuf` form of `FS_Write`.
- The trace ring is an Array of `refTraceEnt_t`, a final class with the fork's name, so a write to one row does not copy the ring.
- `Ref_SpawnFake` and `Ref_DropFake` call Raven's `VM_Call` of `GAME_CLIENT_CONNECT`, `GAME_CLIENT_BEGIN`, and `GAME_CLIENT_DISCONNECT`, in the form of `SV_DirectConnect`. The fork's `cl->wishSnaps` line drops, because Raven's `client_t` has no such field.
- The help strings of `Cvar_Get` and `Cmd_AddCommand` drop, because Raven's functions take none.
- `Ref_Fnv1a` and `Ref_ReplayAdvance` are internal, so the unit tests reach them, the form of the AI line at `sv_game.swift:407`.
- `Format.swift` gains `%x` with the `0` flag and the `ll` length, the X38 form of the `l` length. The `0` flag stays off `%d` and `%i`, because that row waits for the user (docket 11, row 5). The two ded sites with `%08x` and `%02x` (`files_pc.swift:2684`, `net_chan.swift:457`) no longer trap.

## Holes

No `portMissing` hole is in the new code.

## The gate

- `swift build -j 2` passes.
- `swift test --no-parallel -j 2` passes with 156 tests: the 150 of master and 6 new tests in `RefereeSuite`.

## The first comparison

One granted frame, no client, `sv_refSeed 42`, `sv_fps 40`, `sv_maxclients 32`, `g_gametype 0`, `bot_enable 0`, `fs_game swift`, `sv_pure 0`, `vm_game 0`, on `mp/ffa1`, with the release `libjampgame.dylib` of this branch in each homepath under `/tmp/referee-run`. The fork host also took `dedicated 1` and `ttycon 0`.

| Host | REF READY | REF STEP |
|---|---|---|
| `openjkded.arm64` | `map=mp/ffa1 seed=42 fps=40 es=532 er=112 ps=1552 cmd=28` | `n=1 t=425 ck=ae89b5ba` |
| release `jampded` | `map=mp/ffa1 seed=42 fps=40 es=532 er=112 ps=1552 cmd=28` | `n=1 t=425 ck=ae89b5ba` |

The two streams are equal. The Swift host printed the hitch warning of the first frame (`1893219200 msec`) and one more of 4431 msec, and the `t=` field is equal anyway, because the gate forces `msec` and clears `timeResidual`. The corpus replay with clients was not run.

## The corpus replay

The replay of `corpus-ffa1.rec` (shasum `9c08017178ab1cd2f720242c457fbc566d584f6e`, read from `~/Developer/jka/seam-test/referee/`, copied into each homepath) used 2400 granted frames, the release module of this branch, and the cvars of the first comparison with `sv_replayInputs corpus-ffa1.rec` in place of `sv_refSeed`. The runner is `/tmp/referee-out/run-corpus.sh`, and the logs and streams are in `/tmp/referee-run/corpus/`. `tools/host-referee.sh` now takes its scratch folder from `SCRATCH`, with `/tmp/referee-scratch` as the default.

- The fork host: 2400 `REF STEP` lines, `REF REPLAY END` once, 3 s. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=2400 t=60400 ck=c24e9a6b`.
- The Swift host: `REF READY` is equal to the fork's line, and `REF REPLAY LOADED file=corpus-ffa1.rec bytes=346883 seed=42` prints. The host stops with SIGTRAP after 14 s, before the first `REF STEP` line. So 0 steps match, and no step differs.

The stop: `Swift runtime failure: Unexpectedly found nil while unwrapping an Optional value`. The stack is `Ref_SpawnFake` (client 0, Desann) to `VM_Call` of `GAME_CLIENT_BEGIN`, then `ClientBegin` (`g_client.swift:2353`), `SetupGameGhoul2Model` (`g_client.swift:1779`), and `trap_G2API_SetBoneAngles` with `modelList` nil, into `SV_GameSystemCalls_Real` at the `G_G2_ANGLEOVERRIDE` arm, `sv_game.swift:1699:42`, `args.VMA(9)`. The parameter is `Slots<qhandle_t>?`, and no optional `Slots<Int32>` form of `VMA` exists, so the call takes the form at `Sources/JKAMP_Ded/GameViews.swift:95-97`, which unwraps the word with `!`. Raven passes the NULL word on as `(qhandle_t *)VMA(9)`, `oracle/codemp/server/sv_game.cpp:1370-1372`. The fault is in the host's syscall arm, not in the referee, and it is on the path of every client that enters the game.

The same 2400 frames with no client and `sv_refSeed 42` (`/tmp/referee-run/noclient/`) match on every line: equal `REF READY`, 2400 equal `REF STEP` lines on each side. The fork took 2 s and the Swift host 20 s.
