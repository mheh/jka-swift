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

## The replay loop

One cause stopped the host, and one commit fixes it.

1. `4b26d54`. The `G_G2_ANGLEOVERRIDE` arm (`sv_game.swift:1699`) passed the module's NULL `modelList` through the `VMA` form that unwraps the word (`GameViews.swift:95-97`). The new optional form `VMA(_:) -> Slots<Int32>?` gives nil for Raven's NULL, in the shape of the optional `vec3_t` form at `GameViews.swift:64-69`. Swift picks it for each `Slots<qhandle_t>?` parameter, so it also covers the `SETMODELS` (words 2 and 3), the three `GETBOLT` arms (word 8), and `GETBONEANIM` (word 9). `sv_game.swift` has no change. Raven passes these words on at `oracle/codemp/server/sv_game.cpp:1370-1372`.

After the fix, the Swift host replays all 2400 frames and prints `REF REPLAY END` in 21 s. The fork takes 3 s.

### The first mismatch: frame 1

`REF STEP n=1 t=425 ck=3cfa876c` on the fork, `ck=3a3c018c` on the Swift host. So 0 frames match. `ref_dump` after frame 1 differs in one byte of each of the four clients: `playerState_t` offset 1212, `ps.fd.forceRank` (`fd` at 804, `forceRank` at 408 of `forcedata_t`), 7 on the fork and 6 on the Swift host. The serverinfo shows the cause: `g_maxForceRank\7` on the fork, `g_maxForceRank\6` on the Swift host. The fork's `SV_Init` registers the cvar with the default 7 (`openjk/codemp/server/sv_init.cpp:943`). Raven's default is 6 (`oracle/codemp/server/sv_init.cpp:816`), and the Swift port keeps it (`sv_init.swift:757`). This is an OpenJK change, so under H9 it is a row of its own. Candidate forms: set `g_maxForceRank 7` on the proof line of both hosts, as H8 does for the other defaults, or keep Raven's 6 and set `g_maxForceRank 6` on the fork's line.

### The second mismatch: frame 27, with `g_maxForceRank 7` on the Swift line

With `+set g_maxForceRank 7` on the Swift line only, frames 1 to 26 match, and frame 27 differs: `ck=bb77844f` on the fork, `ck=f283977f` on the Swift host. `ref_dump` differs in one field of client 1 (Alora): `origin[1]`, in `ps.origin` (offset 24) and `s.origin` (offset 100), 548.10541 (`bf060944`) on the fork and 548.10559 (`c2060944`) on the Swift host, 3 ULP. The velocity is equal. The `ref_trace` of the frame has 287 boundary calls on each side, with the same commands, the same integer arguments, and the same returns.

The cause is the float contraction of the fork's C build. Clang contracts a multiply and an add into one fused instruction on arm64 by default, and the CMake cache sets no `-ffp-contract`. The fused instruction rounds once, where Raven's MSVC x87 build rounds the product and then the sum, and the Swift port rounds as Raven's lines read. A bisection of the fork build at `35e4184f` names two sites in this corpus. With contraction off in `DotProduct` only (`openjk/shared/qcommon/q_math.c:1220`), frame 27 matches, and frames 1410, 1546, and 1566 differ. With contraction off in `DotProduct` and in the endpos line of `CM_Trace` (`openjk/codemp/qcommon/cm_trace.cpp:1447`), all 2400 lines are equal. Contraction off in all of `cm_trace.cpp` without `DotProduct` leaves frame 27 different. So `DotProduct` causes frame 27, and the endpos line causes frame 1410. The H14 binary holds 863 fused scalar instructions and 27 vector `fmla` instructions in 115 functions, and 63 of those functions are in files the server runs each frame: 34 in `q_math`, 22 in the Ghoul2 files, and 7 in the `cm_` files. This is a difference of the C host's build, not of Raven's source.

### Host output

The Swift host prints each `Com_Printf` call of `ref_dump` on its own line, so `REF E <n> ` and each hex chunk are separate lines. The fork prints one line per record. The dump compare joins the lines (`/tmp/referee-out/dumpdiff.py`).

### The gate

`swift test --no-parallel -j 2` passes with 156 tests.

## The green replay against a fork host with no float contraction

### The g_maxForceRank line

The fork changed one default that the game reads: its `SV_Init` registers `g_maxForceRank` with 7 (`openjk/codemp/server/sv_init.cpp:943`), where Raven's registers it with 6 (`oracle/codemp/server/sv_init.cpp:816`). `tools/host-referee.sh` now sets `+set g_maxForceRank 7` on both host lines, the form of the other defaults of row H8 (`81ebedf`). The Swift port keeps Raven's default.

### The second fork binary

The H14 binary `.build/openjk/openjkded.arm64` stays as it is. A second copy of the fork host, from the same source (`openjk` at `35e4184f`, no change in the tree), is the reference host. `tools/build-referee-host.sh` builds it into `.build/openjk-nocontract/openjkded.arm64` with the CMake lines of `notes/2026-10-09/engine-build.md`, only `BuildMPDed=ON`, and `-ffp-contract=off` for C and C++. The disassembly of the second binary holds no fused multiply and add instruction, against 863 in the H14 binary.

### The result

The replay of `corpus-ffa1.rec`, 2400 frames, with `g_maxForceRank 7` on both lines, the second fork binary against the release `jampded`, and one module (shasum `90dafaa2a81cda8d8db817e499ac521353edbd21`) in both homepaths:

- The `REF READY` lines are equal: `REF READY map=mp/ffa1 seed=42 fps=40 es=532 er=112 ps=1552 cmd=28`.
- Both hosts print 2400 `REF STEP` lines, and the diff of the two streams is empty. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=2400 t=60400 ck=1b1716ec`.
- Both hosts print `REF REPLAY END` once.
- Frame 27 now matches, `ck=f283977f` on both hosts, so the contraction of the H14 binary was the cause of the frame 27 mismatch.
- Wall time: 4 s for the fork host, 25 s for the Swift host.

The streams and logs are in `/tmp/referee-run/rank7/`, with `n` for the second fork binary and `s` for the Swift host. No fix of a mismatch was needed after the stop fix of `4b26d54`.

### Rows for a ruling

1. The `g_maxForceRank 7` line on both hosts, an OpenJK default under row H9.
2. The reference binary: the H14 binary fuses multiply and add on arm64, and Raven's x87 build did not. The candidate is the fork host built with `-ffp-contract=off` as the reference of every host step, which changes the binary of row H14.
3. The line form of `ref_dump` on the Swift host: each `Com_Printf` call ends its own line, where the fork prints one line per record.

### The gate

`swift test --no-parallel -j 4` passes with 156 tests.
