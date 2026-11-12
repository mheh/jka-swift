# Referee scout, 2026-11-10

Repo: /Users/milohehmsoth/Developer/Milo/jka-swift, master f292db9. Read-only scout.

## 1. What the referee is

- The server referee is the OpenJK fork's tooling, commit `f6d2875e` on the fork's `referee` branch: `openjk/codemp/server/sv_referee.cpp` (630 lines) and `sv_referee.h` (notes/2026-11-03/dedicated-referee-docket.md:9-11). It is not Raven code.
- It compares one line per granted game frame: `REF STEP n=%d t=%d ck=%08x` (docket :66). `ck` is FNV-1a 32 over each nonzero entity's `entityState_t` + `entityShared_t` bytes, then each connected client's `playerState_t` (docket :68-73). It also compares the `REF READY map= seed= fps= es=532 er=112 ps=1552 cmd=28` line (docket :73, :183).
- The two sides for a host step: the fork's C host `.build/openjk/openjkded.arm64` versus the Swift `.build/debug/jampded`, both with the SAME Swift `libjampgame.dylib` (docs/porting-rules.md:36, docket :3, :151-175). The boundary is the game module's memory at `SV_LocateGameData`, sampled after each `GAME_RUN_FRAME` (docket :22, :114).
- Debug aids: `ref_dump` (per-entity and per-client hex) and `ref_trace` (a ring of engine-to-game `IN` and syscall `OUT` calls) (docket :43).
- The jka-rust referee is a different text-tape format with FNV-1a 64. It cannot drive `openjkded` (docket :95-99).

## 2. corpus-ffa1.rec

- Path: `/Users/milohehmsoth/Developer/jka/seam-test/referee/corpus-ffa1.rec`, shasum `9c08017178ab1cd2f720242c457fbc566d584f6e` (verified now; matches notes/2026-11-03/dedicated-referee-harness.md:15). It is not in the repo or in ~/.cache. Only the 866-byte `reflog-real-duel1-idle.rec` is in the repo, at `Sources/JKATestSupport/Oracle/fixtures/referee/` (harness :9).
- Header `REFREC v1 map=mp/ffa1 seed=42 fps=40`. 9604 records: 4 enter-world records and 9600 usercmds, last record at frame 2399 (harness :15).
- Format: one text header line, then little-endian records with an 8-byte header (frameIndex u32, type u8, clientNum u8, lenOrPad u16). Type 1 is a 28-byte `usercmd_t`, type 2 is the userinfo bytes (enter-world), type 3 is a disconnect (docket :45-62).
- Recording: a fork `openjkded` with `sv_stepper 1` and `sv_recordInputs`. `record_corpus.py` adds four bots (Desann, Alora, Tavion, Reelo) and grants one frame at a time (~/Developer/jka/seam-test/referee/record_corpus.py:1-35; README.md section 1). The recorder writes bot usercmds too, so the replay drives the bots as fake human clients (docket :62, :83). The corpus holds 2 kills and 4 pickups (notes/2026-10-27/unattended-replays.md:19).

## 3. Earlier runs

- The fork against itself: `tools/host-referee.sh corpus-ffa1.rec openjkded.arm64 openjkded.arm64`. Result: 4000 `REF STEP` lines on each side, no diff, `REF REPLAY END` on both sides, green. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=4000 t=100400 ck=c24e9a6b`. Wall time 85 s (harness :13-25). This proves no Swift host (harness :35).
- Game-module A/B: `referee.py` / `run-ab.sh` under ~/Developer/jka/seam-test/referee/ ran two fork servers, one with the C module and one with the Rust module (README.md :1-15). Stepper replays with the Swift module ran on `openjkded` (notes/2026-10-29/human-recordings.md:7-9).
- cgame: the client referee was deferred to a later fork branch (notes/2026-11-02/cgame-stage-5-host-gate.md:47).

## 4. What a Swift-host run needs that does not exist yet

- `sv_referee.swift` does not exist. No `SVRef_*`, `Ref_Checksum`, `sv_stepper`, `sv_replayInputs`, or `ref_step` symbol is in Sources/ (grep returns no match; harness :3). Rows H1-H14 are all ratified (docket :288-301). The port includes:
  - the 5 cvars and 3 commands (SVRef_Init in SV_Init),
  - SVRef_MapSpawned at the end of SV_SpawnServer,
  - SVRef_FrameGate before SV_CheckPaused (sv_main.swift:1028),
  - Pre/PostGameFrame around `VM_Call(gvm!, GAME_RUN_FRAME, svs.time)` (sv_main.swift:1104),
  - SVRef_GameSeed at `VM_Call(gvm!, GAME_INIT, svs.time, Com_Milliseconds(), restart)` (sv_game.swift:1992),
  - the replayer (Ref_SpawnFake / ClientThink / DropFake),
  - the H5 wrapper SV_GameSystemCalls -> SV_GameSystemCalls_Real,
  - the H6 VM_Call trace (docket :107-121).
- The harness exists: `tools/host-referee.sh` takes host A and host B (tools/host-referee.sh:3, :72-102). One gap: H7's `fs_homepath` lookup is not in `Sys_LoadDll`. Only basepath and cdpath are searched (win_main.swift:735-736), and the probe needed `+set fs_cdpath <home>` (notes/2026-11-10/dedicated-body-round-path.md:18). So either the Swift run passes `fs_cdpath "$SCRATCH/b"` as an extra argument, or the H7 fs_homepath arm gets ported (it is already ratified).
- The fake-client path is not proven on jampded. The replay needs `SV_ClientThink`, `SV_DropClient`, `SV_SetUserinfo`, and `SV_SendClientMessages` -> `sv_snapshot`, `msg`, and `huffman` per frame (docket :211-213). These files have 0 `portMissing` holes, but no client has run through them. The debug build spends minutes in `MSG_initHuffman` (HANDOFF.md:25). 265 holes stay in the logic target, of which 4 are in sv_game, all botlib or unused G2 arms (sv_game.swift:1164, :1604, :1642, :1648).
- Input playback and the time base come from the referee itself: the stepper forces msec = n*1000/sv_fps and clears timeResidual (docket :91). The seed comes from the header seed (42). No separate control is needed.

## 5. Nondeterminism

- The GAME_INIT seed `Com_Milliseconds()` (sv_game.swift:1992). The replay header seed replaces it (docket :81). Without the port, it differs per run.
- The engine `holdrand` seeds from the clock: `Rand_Init(Sys_Milliseconds(true))` (common.swift:1443). Row H11 says no pin, because mp/ffa1 with bot_enable 0 runs no NPCNav or terrain `irand` (docket :270). irand/flrand sit in CNavigator, CRandomTerrain, CCMLandScape, CRMMission, Q3_Interface, and G2_bones under JKAMP_DedLogic. G2_bones is a risk if the ffa1 entities use Ghoul2 bone code.
- The hitch on the first frame: `ev.evTime = SysBackend.timeGetTime()` (win_main.swift:892) gives a ~1884-million msec first frame (HANDOFF.md:15). Under the stepper, FrameGate overrides msec and clears timeResidual, so the first granted frame is not affected. But the spawn frames and the msec that Com_Frame computes before the gate pass through it. Check whether `svs.time` or `sv.timeResidual` absorb it before SVRef_MapSpawned. That is the t= field. Fork t=425 on n=1 (harness :20).
- Time across maps: the Swift line prints `svs.time` and the fork prints `sv.time`. They are equal only on the first map of a fresh process (docket :125, H3).
- Hash and address order: the checksum folds only module memory with no pointer fields (docket :73). Risks: the Swift module's string pool or C allocations, if a pointer lands in s/r/ps (none by layout). Two JKAShared copies (`SharedChannel` and `StringPool` duplicated in jampded and the module) (dedicated-body-round-path.md:43 row 6). A trace diff must ignore pointer arguments (docket :187).
- OpenJK differs from Raven. Any mismatch traced to an OpenJK change becomes its own row (H9, docket :262).

## 6. Plan

1. Port `sv_referee.swift` from the fork's file per H1/H2, with its 22 vars on EngineWorld, plus the hook lines at the Raven sites of docket section 2 (H3-H6 `// AI:` lines). A pattern exists; no ruling is needed.
2. Unit tests of the pure parts: FNV-1a vectors, the .rec parse against the fixture, the MemoryLayout sizes 532/112/1552/28 (docket :222). No ruling is needed.
3. Smallest frame: `jampded +set sv_stepper 1 +set sv_refSeed 42 +map mp/ffa1 +ref_step 1` against openjkded. This compares entities only, with no client (docket :193).
4. Make the module load from the homepath: port the H7 fs_homepath arm (ratified), or pass `fs_cdpath` as an extra argument to host-referee.sh. Choosing the stopgap is a small ruling.
5. Run `FRAMES=4000 tools/host-referee.sh ~/Developer/jka/seam-test/referee/corpus-ffa1.rec .build/openjk/openjkded.arm64 .build/debug/jampded`. This first exercises the fake-client snapshot path. Expect faults and slow Huffman init in debug.
6. On a mismatch, use ref_dump/ref_trace to bisect. Each OpenJK-versus-Raven cause becomes a row (H9). These need user rulings when no pattern covers them. Also possibly rulings on the first-frame hitch (a HANDOFF open row), a pin of the engine random seed if a G2_bones irand shows up (H11 says no pin until a mismatch), and a release build if debug is too slow.

Rows that need a user ruling now: the hitch row (HANDOFF.md:15). Everything else in steps 1-5 is already ratified (H1-H14).
