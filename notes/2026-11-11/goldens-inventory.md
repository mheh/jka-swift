# Goldens inventory

Scout report, 2026-11-11. Read only. Nothing was built or edited.

Trees read:

- This repo: `Sources/JKATestSupport/` (goldens under `Oracle/golden/`, fixtures under `Oracle/fixtures/`).
- `jka-rust/` submodule at the repo root, commit `1cb6c525` (branch `last-c-golden-853-g1cb6c525`). Called "submodule" below.
- `../jka-rust` (sibling), branch `rewrite/swift-sync`. Called "sibling" below.

## 0. How a golden is loaded and compared

- Loader: `Sources/JKATestSupport/OracleData.swift:5-14`. `OracleData.golden(name)` reads `Oracle/golden/<name>.txt` as UTF-8 text from `Bundle.module`. `OracleData.fixture(path)` and `fixtureData(path)` read `Oracle/fixtures/<path>`. A missing file throws `OracleDataError.missing`.
- The `huff` goldens sit in `golden/huff/<name>.txt`, and `HuffParityTests.swift:98` loads them with `OracleData.golden("huff/<name>")`.
- Text writer: `Sources/JKATestSupport/GoldenFormat.swift:12-49`. Every float prints as its eight-digit lower-case bit pattern (`bits`, `vector`, `vector4`). A NaN prints as `7fc00000` (rule 19). `hex8` and `hex2` copy the C `%08x` and `%02x`.
- Compare: `GoldenFormat.mismatch(name, got:, golden:)` (`GoldenFormat.swift:54-66`). It is one string equality. The text only names the first differing line. Rust twin: `jka-rust/crates/testkit/src/lib.rs:40`.
- Every golden is plain text. One record is one line. A section starts with a banner line `== name ==` and the file ends with `== end ==`. The two pmove goldens start each scenario with `-- scenario <name> --`.
- Only `OracleDataTests.swift:5-17` loads all ten `.txt` goldens. It checks that the text is not empty and that the first line starts with `== ` or `-- `. It compares nothing.

## 1. Table A: every golden in this repo

Sizes are bytes. "Lines" counts text lines. "Records" counts the data lines the dumper wrote.
All ten `.txt` files plus the three `huff` files make 13 golden files (10 rows plus the `huff` group of 3).
`Oracle/README.md` lists the same four Swift parity tests.

| # | Name | Path under `Sources/JKATestSupport/Oracle/golden/` | Size | Lines | Records and format | Raven functions covered | Swift test |
|---|------|----------------------------------------------------|------|-------|--------------------|-------------------------|------------|
| 1 | qmath | `qmath.txt` | 73230 | 4645 | 7 sections: rng 3204, qrand 110, scalars 58, n2ll 6, planes 120, vecmath 1140 records. Tagged text lines, floats as bit hex. Example `seed 89abcdef`, `fl 3edf4400`, `b2d 0 bf06964f 00000000 3f59c444`. | `q_math.c`: `Rand_Init`, `flrand`, `Q_flrand`, `irand`, `Q_irand`, `Q_rand`, `Q_random`, `Q_crandom`, `ClampChar`, `ClampShort`, `Q_log2`, `Q_rsqrt`, `Q_fabs`, `powf`, `ByteToDir`, `ColorBytes*`, `NormalizeColor`, `NormalToLatLong`, `SetPlaneSignbits`, `BoxOnPlaneSide`, and the vector, angle, and matrix functions over `fixtures/vectors.txt` (30 vec3). | Full: `Tests/JKASharedTests/QMathParityTests.swift:13-33` (whole text compare). |
| 2 | bglib | `bglib.txt` | 214 | 54 | 1 section `qsort`, 52 lines: `ints 20` and 20 values, then `kv 20` and 20 `key payload` pairs. | `bg_lib.c` `qsort` over `fixtures/ints.txt` and a fixed struct array. The jampgame-oracle README also names `srand`, `rand`, `atoi`, `atof`, `memmove`, but `main_bglib.c` (54 lines) and the golden hold `qsort` only. | Full: `Tests/JKAMPTests/BGLibParityTests.swift:11-23`. |
| 3 | bgmisc | `bgmisc.txt` | 52366 | 2547 | 9 sections: trajectory 84, itemlist 780, findid 65, weapondata 19, ammodata 10, grab 39, ps2es 756, ps2esxp 784. Example `T 0 et <vec3 bits> ed <vec3 bits>`, then multi-line `item N` blocks. | `bg_misc.c`: `BG_EvaluateTrajectory`, `BG_EvaluateTrajectoryDelta`, the `bg_itemlist`, `weaponData`, `ammoData` tables, `BG_FindItem`, `BG_FindItemForPowerup`, `BG_FindItemForHoldable`, `BG_FindItemForWeapon`, `BG_FindItemForAmmo`, `BG_CanItemBeGrabbed`, `BG_PlayerStateToEntityState`, `BG_PlayerStateToEntityStateExtraPolate`. Inputs: `fixtures/bgmisc/{trajectory,grab,ps}.txt`. | Partly: the `trajectory` section only, `Tests/JKAMPTests/BGMiscTrajectoryParityTests.swift:11-23`. The other seven sections have no Swift side. |
| 4 | gcombat | `gcombat.txt` | 1673 | 44 | 3 sections: raysphere 12 (`ray N n .. dir .. i0 .. i1 ..`), hitloc 14 (`h N hl X`), armor 13 (`a N ret X armor Y`). | `g_combat.c`: `RaySphereIntersections`, `G_GetHitLocation`, `CheckArmor`. Inputs `fixtures/gcombat/{raysphere,hitloc,armor}.txt`. | None. Loaded by `OracleDataTests` only. |
| 5 | wsaber | `wsaber.txt` | 15651 | 1013 | 2 sections: lockanim 768 (`la a d t l w result`), knockaway 241 (`kp move result`). Integer only. | `w_saber.c`: `G_SaberLockAnim` (exhaustive 8x8x2x3x2 sweep), `G_KnockawayForParry` (move 0 to 240). Sweep bounds in `fixtures/wsaber/{lockanim,knockaway}.txt`. | None. |
| 6 | qshared | `qshared.txt` | 34002 | 1386 | 9 sections: clamp 559, tokens 83, compress 11, braced 5, skipline 4, strhelpers 321, va 5, sprintf 4, info 384. Tagged text lines, quoted strings, byte hex. | `q_shared.c`: `COM_Parse`, `COM_ParseExt`, `COM_Compress`, `SkipBracedSection`, `SkipRestOfLine`, `COM_StripExtension`, `COM_DefaultExtension`, the `Q_str*` and `Q_is*` helpers, `Q_CleanStr`, `Q_PrintStrlen`, `va`, `Com_sprintf` (literal formats only), the `Info_*` family and `_Big` variants. Inputs `fixtures/qshared/{tokens,compress,infostrings}.txt`. | None. |
| 7 | saberload | `saberload.txt` | 11650 | 534 | 6 saber blocks (`Kyle`, `staff_saber`, `edge_saber`, `broken_saber`, `nonexistent_xyz`, empty name), 532 lines. Each block: `saber "name"`, `ret 0/1`, every `saberInfo_t` field in declaration order (floats as bit hex, strings quoted), then `regskin` and `regsound` lines, then `--`. | `bg_saberLoad.c`: `WP_SaberLoadParms`, `WP_SaberParseParms`. Inputs `fixtures/sabers/*.sab` (4 files). | None. |
| 8 | pmove | `pmove.txt` | 70890 | 244 | 6 scenarios, 226 step lines `s=N t=.. org=.. vel=.. va=.. ... ntr=.. rng=..` (about 40 fields, floats as bit hex). Scenarios: idle, walk-fwd, strafe-turn, jump-land, fall-onto-box, wall-step. | `bg_pmove.c` `Pmove` with weapon `WP_MELEE`, through `PmoveSingle`, `PM_Weapon`, slide move, and the anim restart check. Inputs `fixtures/pmove/{scenario}.txt` plus `animation.cfg` (41500). | None. |
| 9 | pmove_saber | `pmove_saber.txt` | 56541 | 180 | 6 scenarios, 162 step lines. Same line as `pmove` plus `sm sb shl sen sal sac`. Scenarios: saber-idle, saber-walk, saber-attack-stand, saber-attack-run, saber-attack-strafe, saber-jump. | `Pmove` with weapon `WP_SABER`: `PM_WeaponLightsaber`, stance and attack chains in `bg_saber.c`. Inputs `fixtures/pmove_saber/*.txt` plus `animation.cfg`. | None. |
| 10 | pmove_trace | `pmove_trace.txt` | 1967 | 19 | 1 section, 17 records: `reset`, `brush N surf=X`, `sweep N as= ss= frac= end= nrm= pd= pt= psb= sf= ct= en=`. | Not a Raven function. It proves the test world, the axial-brush trace of `pmworld.h`. Input `fixtures/pmove/trace.txt`. | None. |
| 11 | huff/chat | `huff/chat.txt` | 66 | 2 | Header `chat bloc=162 bytes=21`, then hex bytes in 64-digit rows. | `huffman.cpp` adaptive Huffman, a chat string with the `0xB0` byte. Dumper `jka-rust/tools/huff-oracle/main.cpp`. | Full: `Tests/JKAMP_DedLogicTests/HuffParityTests.swift` (loads at line 98). |
| 12 | huff/codes | `huff/codes.txt` | 6534 | 256 | 256 lines `%3d: <bits>  (N bits)`, the code of each symbol. | Same, `Huff_offsetTransmit` over the `MSG_initHuffman` seed. | Full: `HuffParityTests.swift`. `HuffGoldenFormatTests.swift:66` checks the format. |
| 13 | huff/seq | `huff/seq.txt` | 612 | 11 | Header `seq bloc=2308 bytes=289`, then hex rows. | Same, the bitstream of bytes 0x00 to 0xFF. | Full: `HuffParityTests.swift`. |

Fixtures (also carried, not goldens): `Oracle/fixtures/{ints,strings,vectors}.txt`, `bgmisc/`, `gcombat/`, `pmove/`, `pmove_saber/`, `qshared/`, `sabers/`, `wsaber/`, plus `qvm/` and `referee/` (this repo only, used by `QVMFixtureTests`, `QVMInterpreterTests`, `RefereeFixtureTests`). `strings.txt` has no Swift reader (it feeds the `atoi` and `atof` sections that `main_bglib.c` no longer writes).

Seven of the ten `.txt` goldens have no comparing test: gcombat, wsaber, qshared, saberload, pmove, pmove_saber, pmove_trace. With the seven non-trajectory sections of bgmisc, these are the eight untested goldens of point 4.

## 2. Table B: goldens, dumpers, and tests in `jka-rust/`

Compare method in every row below is exact text equality unless the row says otherwise. Floats print as bit hex, so a float compare is a bit compare. The `testkit::compare` helper does it (`crates/testkit/src/lib.rs:40`).

Submodule against sibling: every golden file under `tools/*-oracle/golden*` is byte-identical. The sibling differs in layout and in tests (see section 3, point D). The `qmath`, `pmove`, and `bgmisc` goldens are identical in submodule and sibling, and both carry the double `M_PI`.

18 rows. 143 golden files.

| # | Tool, goldens (count) | Golden path | Dumper | Rust test and feed | Domain |
|---|-----------------------|-------------|--------|--------------------|--------|
| 1 | jampgame-oracle: qmath, bglib (2) | `crates/mp/game/tests/oracle/golden/` (sibling: `tools/jampgame-oracle/goldens/golden/`) | `tools/jampgame-oracle/main_qmath.c`, `main_bglib.c`, `run.sh` | `crates/mp/game/tests/jampgame_parity.rs`: `qmath_parity` (line 525, compare line 536), `bglib_parity` (603, 608). Reads `fixtures/{vectors,ints,strings}.txt`, calls the ported function, rebuilds the text, `testkit::compare`. | MP game: q_math, bg_lib |
| 2 | jampgame-oracle: saberload (1) | same folder | `main_saberload.c` | `jampgame_parity.rs` `mod saberload` (lines 613-1210, compare 1210). Fixture-backed `TestTraps: BgTraps` serves `fixtures/sabers/`; `cs_syscall` configstring mock engine through `arm_game_slot`; `saber_snd_tape_*` records sound names. | MP bg |
| 3 | jampgame-oracle: bgmisc (1) | same | `main_bgmisc.c`, `run_bgmisc.sh` | `bgmisc_parity.rs`: `bgmisc_parity` (508-520), seven section fns, `ps_set` and `es_set` read `fixtures/bgmisc/*.txt`. No globals, no world. | MP bg |
| 4 | jampgame-oracle: gcombat (1) | same | `main_gcombat.c`, `stubs_gcombat.c`, `run_gcombat.sh` | `gcombat_parity.rs`: `gcombat_parity` (lines 182-191). Builds `GameWorld::zeroed()` and a never-invoked `Engine`, runs on a 32 MiB stack thread, resets `gentity_t` slot 0 per record. | MP game |
| 5 | jampgame-oracle: wsaber (1) | same | `main_wsaber.c`, `stubs_wsaber.c`, `run_wsaber.sh` | `wsaber_parity.rs`: `wsaber_parity` (lines 68-75). Reads the `sweep` line of two fixtures, loops, no state. | MP game |
| 6 | jampgame-oracle: qshared (1) | same | `main_qshared.c`, `run_qshared.sh` | `qshared_parity.rs`: `qshared_parity` (631-644), ten `dump_*` fns, `QSharedScratch`, one test, sections in dumper order because of parse and `va` statics. | shared (q_shared) |
| 7 | jampgame-oracle: pmove, pmove_trace (2) | same | `main_pmove.c`, `main_trace.c`, `pmworld.h`, `gen_animcfg.py`, `pmove-spec.md`, `run.sh` | `pmove_parity.rs`: `pmove_parity` (lines 366-389) runs `run_trace` and six `run_scenario` calls. Feed: `support/mod.rs` `TestTraps: BgTraps` (axial-brush `trace_world`, `point_in_brushes`, `rintf` snap), `TestCallbacks: GameCallbacks` (anim mirror), `BgState::new()`, `BG_ParseAnimationFile` over `fixtures/pmove/animation.cfg`, `pmove_t` and `playerState_t` zeroed, `bgEntity_t` arena of 8. | MP bg (pmove) |
| 8 | jampgame-oracle: pmove_saber (1) | same | `main_pmove_saber.c`, `run_pmove_saber.sh`, `build-pmove-saber/` | `pmove_saber_parity.rs`: `pmove_saber_parity` (lines 308-323). Same `support` world and callbacks, saber baseline `ps`. | MP bg (saber pmove) |
| 9 | huff-oracle (3) | `tools/huff-oracle/goldens/{chat,codes,seq}.txt` | `main.cpp`, `build.sh`, `extract_table.py` | `crates/mp/engine/qcommon/tests/huff_golden.rs`. `include_str!` of the goldens, `seed()` as `MSG_initHuffman`, rebuilds, string equality. (`huff_roundtrip.rs` is a Rust-only test.) | engine (qcommon) |
| 10 | roff-oracle (2) | `tools/roff-oracle/goldens/{cache,play}.txt` | `dump_cache.cpp`, `dump_play.cpp`, `roffgen.cpp` | `engine/qcommon/tests/roff_parity.rs` (3 tests: cache ids, playback, purge). Feed: fixture `.rof` files through `mp_host_interface::mock::MockHost`. | engine (qcommon) |
| 11 | stringed-oracle (3) | `tools/stringed-oracle/goldens/{parse_lookup,reference_stability,filelist_scan}.txt` | `dump.cpp`, `host.cpp` | `engine/qcommon/tests/stringed_parity.rs` (3 tests). | engine (qcommon) |
| 12 | gp2-oracle (16: 8 scenarios, `.mp` and `.sp`) | `tools/gp2-oracle/golden/*.{mp,sp}.txt` | `main.cpp`, `run.sh` | `engine/qcommon/tests/gp2_parity.rs` (`matches_oracle_goldens`, MP) and `crates/sp/qshared/tests/gp2_parity.rs` (SP). | engine (qcommon) and SP |
| 13 | terrainmap-oracle (2) | `tools/terrainmap-oracle/golden/{draw,terrainmap}.txt` | `main.cpp`, `fixtures/gen_fixtures.py` | `engine/qcommon/tests/terrainmap_parity.rs` (2 tests). | engine (qcommon, cm) |
| 14 | icarus-oracle (6) | `tools/icarus-oracle/goldens/{blockstream_*,endtoend_e2e,q3_registers}.txt` | `dump_blockstream.cpp`, `dump_registers.cpp`, `dump_endtoend.cpp`, `mockhost.cpp` | `engine/icarus/tests/icarus_parity.rs` (3 tests), `MockHost`. | engine (ICARUS) |
| 15 | ghoul2-server-oracle (3) | `tools/ghoul2-server-oracle/goldens/{arena,bolts,surfaces}.txt` | `dump_arena.cpp`, `dump_bolts.cpp`, `dump_surfaces.cpp` | `engine/ghoul2/tests/ghoul2_server_parity.rs` (3 tests). | engine (ghoul2 server) |
| 16 | trmodel-oracle (5) | `tools/trmodel-oracle/goldens/{load,matcomp,cache_hitmiss,cache_evict,cache_dumpnonpure}.txt` | `dump_load.cpp`, `dump_cache.cpp`, `dump_matcomp.cpp`, `modelgen.cpp` | `engine/ghoul2/tests/matcomp_parity.rs` (floats as hex bits plus `%.6f`), `renderer/tests/tr_model_parity.rs` (4 tests). | engine/renderer |
| 17 | npcnav-oracle (4, plus `.nav` fixtures) | `tools/npcnav-oracle/goldens/{diamond,grid9,line3,star6}.txt` | `main.cpp` | `engine/server/tests/npcnav_parity.rs` (3 tests: goldens, saved `.nav` bytes, load round trip), `MockHost`. | engine (server, NPC nav) |
| 18 | rmg-oracle (2) | `tools/rmg-oracle/golden/{seed,dedicated}.txt` | `main.cpp` | `engine/rmg/tests/rmg_terrain_parity.rs`: `seed_matches_oracle_golden` (176). `dedicated.txt` has no reproducing test (note at line 193). | engine (RMG) |
| 19 | cin-oracle (9) | `tools/cin-oracle/golden/*.txt` (codebook, quadinfo, rll, sound, vq) | `main.cpp`, `host.cpp`, `gen_fixtures.py` | `engine/client/tests/cin_oracle_goldens.rs`: `cin_decode_core_matches_oracle_goldens` (774), `assert_matches_golden` (747). | engine (client, cinematic) |
| 20 | snd-oracle (28: 14 scenarios, `.txt` plus 65536-byte `.bin` ring) | `tools/snd-oracle/golden/*.{txt,bin}` | `main.cpp`, `gen_fixtures.py` | `engine/core/tests/snd_oracle_parity.rs` (`every_scenario_reproduces_its_goldens`, 717): text line by line and ring bytes exact. `engine/client/tests/snd_oracle_goldens.rs` checks golden shape only. | engine (sound) |
| 21 | fx-oracle (18) | `tools/fx-oracle/golden/*.txt` | `main.cpp`, `host.cpp`, `scenarios/` | `engine/client/tests/fx_oracle_parity.rs` (`matches_oracle_goldens`, 731), scenario scripts through `FxHarness`. | engine (client FX) |
| 22 | ui-oracle (4) | `tools/ui-oracle/golden/*.txt` | `main.cpp`, `pc_bridge.cpp`, `stubs.c` | `crates/mp/uishared/tests/menu_parse_goldens.rs` (`matches_oracle_goldens`, 949). | UI |
| 23 | renderer-oracle (3) | `tools/renderer-oracle/golden/{edge_cases,general_keywords,stage_keywords}.txt` | `main.cpp`, `run.sh` | No Rust test reads them. The README says the Rust frontend is not written yet. | renderer (shader parse) |
| 24 | cgame-referee journals (4) | `tools/cgame-referee/goldens/{ffa1,sabers1,spectator,swoop1}.journal.gz` | recorder cdylib `shim/`, `record-golden.sh` (records real cgame, not a C dumper) | `engine/core/tests/demo_referee.rs`: `demos_match_the_oracle_goldens` (461), `goldens_are_well_formed_and_skip_no_snapshot` (370). Diffs trap brackets with `journal_diff.rs`. Needs retail demos and assets. | cgame seam, engine |
| 25 | renderer-gpu image goldens (21: 20 PNG, 1 `.bin`) | `crates/mp/renderer-gpu/tests/goldens/` (sibling: `tools/renderer-oracle/gpu-goldens/`) | None from C. The Rust renderer writes them (`JKA_GOLDEN_BLESS=1`). | `renderer-gpu/tests/{scene,hud,entity,world}_golden.rs`, `ghoul2_vertex_golden.rs`. Pixel compare, `CHANNEL_TOLERANCE = 0` (exact). The world, entity, and ghoul2 tests are `#[ignore]` and need retail assets and a GPU. | renderer |

Rows 1 to 8 are the jampgame-oracle tool (10 goldens). Rows 9 to 25 are the others. Also in the tree and not goldens: `tools/cgame-oracle/smoke.c`, `tools/referee-oracle/`, `tools/lockstep-referee/run.sh` (a lockstep run), `docs/audits/2026-08-04-ghoul2-golden-null-re-slot.md` (a note).

## 3. The difference: jka-rust goldens this repo does not carry

This repo carries the ten jampgame-oracle `.txt` goldens (rows 1 to 8) and the three `huff` goldens (row 9), with fixtures. It carries none of the following.

| Golden group (files) | Domain |
|----------------------|--------|
| roff (2) | engine, qcommon |
| stringed (3) | engine, qcommon |
| gp2 (16) | engine, qcommon, and SP |
| terrainmap (2) | engine, qcommon cm |
| icarus (6) | engine, ICARUS |
| ghoul2-server (3) | engine, ghoul2 |
| trmodel (5) | engine and renderer |
| npcnav (4, plus `.nav`) | engine, server |
| rmg (2) | engine, RMG |
| cin (9) | engine, client |
| snd (28) | engine, sound |
| fx (18) | engine, client FX |
| ui-oracle (4) | UI module |
| renderer-oracle (3) | renderer |
| cgame-referee journals (4) | cgame seam |
| renderer-gpu images (21) | renderer |

None of these belongs to the MP game module, `bg`, or `qshared`. These are all in this repo already.

- Engine code: roff, stringed, gp2, terrainmap, icarus, ghoul2-server, trmodel, npcnav, rmg, cin, snd, fx, huff (huff is already here).
- Cgame code: only the four cgame-referee journals. They record the real cgame module against the engine and need retail demos. No C dumper writes them.
- UI code: ui-oracle.
- Renderer code: renderer-oracle, renderer-gpu images, trmodel.
- No MP game or `bg` golden is missing. No `bg` golden is outside this repo.

Other differences:

- A. Fixtures: this repo adds `fixtures/qvm/` and `fixtures/referee/` that jka-rust does not have under the oracle data.
- B. `float-mpi.patch` goldens: three of the ten differ from jka-rust (section 5).
- C. Layout: the submodule keeps the jampgame goldens in `crates/mp/game/tests/oracle/{golden,fixtures}`. The sibling moved them to `tools/jampgame-oracle/goldens/{golden,fixtures}`. This repo keeps them in `Sources/JKATestSupport/Oracle/`.
- D. Sibling: no Rust test reads a golden. `grep golden` over `../jka-rust/crates` finds no `.rs` file. The sibling crates are `gen`, `module`, `native`, `port`. The sibling has extra tools `oracle-closure` and `oracle-closure-swift`. The submodule has the Rust parity tests, so use the submodule as the reference for test behavior.
- E. Dumper gap: jampgame-oracle has no dumper for `bg_slidemove`, `bg_panimate` (only as a pmove input), `bg_saber` alone, `g_*` beyond `g_combat`, `w_saber` beyond two functions, or any NPC code.

## 4. The eight untested goldens

All Rust tests are in `jka-rust/crates/mp/game/tests/`. All compare by `testkit::compare`, which is exact text equality. Swift function names are the names in `Sources/`.

Swift test targets: `JKAMPTests` depends on `JKAMP`, `JKAMP_BG`, `JKATestSupport`. `JKAMP_GameTests` depends on `JKAMP_GameLogic`, `JKATestSupport`. `JKASharedTests` depends on `JKAShared`, `JKATestSupport`. A `@testable import` reaches internal functions.

### Simple: pure functions, no harness

1. wsaber.
   - Rust: `wsaber_parity.rs`, `wsaber_parity` with `sec_lockanim`, `sec_knockaway`, `read_sweep`.
   - Swift calls: `G_SaberLockAnim(_:_:_:_:_:) -> Int32` (`Sources/JKAMP_GameLogic/w_saber.swift:1066`), `G_KnockawayForParry(_:) -> Int32` (`w_saber.swift:1900`). Both are internal, so the test needs `@testable import JKAMP_GameLogic`, as `Tests/JKAMP_GameTests/` does.
   - Setup: none. No state, no RNG, no floats. Read two `sweep` lines from `fixtures/wsaber/*.txt` with `OracleData.fixture`. The Swift counterpart of the row parser is the `pi`/`pf` pair in `BGMiscDump` (`BGMiscTrajectoryParityTests.swift:36-52`).
   - Verdict: simplest. Integer text only.

2. bgmisc, the seven remaining sections.
   - Rust: `bgmisc_parity.rs`, `bgmisc_parity` (508) with `sec_itemlist` (202), `sec_findid` (273), `sec_weapondata` (321), `sec_grab` (350), `sec_ps2es` (448), `sec_ps2esxp` (483), setters `ps_set` (39) and `es_set` (120).
   - Swift calls: `bg_itemlist`, `bg_numItems`, `weaponData`, `ammoData` (read through views, see `Tests/JKAMPTests/BgTablesTests.swift`), `BG_FindItem(String)`, `BG_FindItemForPowerup`, `BG_FindItemForHoldable`, `BG_FindItemForWeapon`, `BG_FindItemForAmmo` (`Sources/JKAMP_BG/bg_misc.swift:624-718`), `BG_CanItemBeGrabbed(gametype, ent, ps)` (943), `BG_PlayerStateToEntityState(ps, s, snap)` (1395), `BG_PlayerStateToEntityStateExtraPolate(ps, s, time, snap)` (1545).
   - Setup: no globals, no trace. The test builds a `PlayerState` and an `EntityState` view over zeroed C memory (the pattern of `BgConsumerTests.swift:21-26`) and fills them from `fixtures/bgmisc/{ps,grab}.txt` with a Swift `ps_set` and `es_set`. The existing `BGMiscDump.section`, `pf`, `pi` helpers in `BGMiscTrajectoryParityTests.swift` carry over, and the same `section` helper lets each new test compare one section. The `snap=1` case is excluded in the golden. `trap_SnapVector` is needed only if a fixture sets `snap`; `BgConsumerTests.swift:19` shows how to install it.
   - Verdict: simple, but wide. It has 7 sections and a long field-name table.

3. qshared.
   - Rust: `qshared_parity.rs`, `qshared_parity` (631) with `dump_clamp`, `dump_tokens`, `dump_compress`, `dump_braced`, `dump_skipline`, `dump_strhelpers`, `dump_va`, `dump_sprintf`, `dump_info`.
   - Swift calls (all public, `Sources/JKAShared/q_shared.c.swift`): `ClampChar`, `ClampShort`, `COM_BeginParseSession` (196), `COM_ParseExt` (346), `COM_Parse` (207), `COM_Compress` (266), `SkipBracedSection` (550), `SkipRestOfLine` (575), `COM_StripExtension` (97), `COM_DefaultExtension` (117), `Q_strncpyz`, `Q_strcat`, `Q_stricmp`, `Q_stricmpn`, `Q_strncmp`, `Q_strlwr`, `Q_strupr`, `Q_strrchr`, `Q_isprint`, `Q_islower`, `Q_isupper`, `Q_isalpha`, `Q_CleanStr`, `Q_PrintStrlen`, `va` (983), `Com_sprintf` (955), `Info_ValueForKey`, `Info_SetValueForKey` and `_Big`, `Info_RemoveKey`, `Info_Validate`.
   - Setup: no world. Two global states: the parse line counter (`COM_BeginParseSession`) and the `va` rotating buffer. Run all sections in one test in dumper order. Inputs are `TextCursor` and `CharBuf` values. The dumper prints byte offsets (`off 13`) and the `nul` flag, so the test needs `TextCursor` offset access. `CharBufOffsetTests` and `QSharedHelperTests` show existing patterns.
   - Verdict: pure functions, no harness. The work is the many Swift `CharBuf` and `TextCursor` shapes against the C pointer prints. Check Raven print order in `main_qshared.c` (402 lines) first.

4. gcombat.
   - Rust: `gcombat_parity.rs`, `gcombat_parity` (182) spawning `run` (172) with `sec_raysphere`, `sec_hitloc`, `sec_armor`.
   - Swift calls: `RaySphereIntersections(origin, radius, point, &dir, &intersections) -> Int32` (`Sources/JKAMP_GameLogic/g_combat.swift:2546`), `G_GetHitLocation(target: Entity, ppoint) -> Int32` (70), `CheckArmor(ent, damage, dflags) -> Int32` (2443).
   - Setup: `raysphere` is pure. `hitloc` and `armor` need a world. Rust builds `GameWorld::zeroed()`, resets entity 0, points `client` at a zeroed `gclient_t`, sets `currentAngles[YAW]`, `absmin`, `absmax`, `mins`, `maxs`, `STAT_ARMOR`, `NPC_class`, `electrifyTime`, `m_pVehicle`, and `level.time`. Swift counterpart: `world = GameWorld()`, `g_entities[n]`, `level.time` (`Tests/JKAMP_GameTests/GameWorldTests.swift:7-30`, `g_main.swift:7,28`). The suite is `.serialized` (rule 3). The test must also seat a `Client` on entity 0. The Rust comment says `CheckArmor` reads `level.time` besides its arguments. The Swift port is not checked for other reads. The test must also give `m_pVehicle` a dummy non-nil value for the armor records with `hasVehicle 1`.
   - Verdict: `raysphere` simple, `hitloc` and `armor` need a small world fixture that already exists in `GameWorldTests`. Medium.

### Need a harness

5. pmove_trace.
   - Rust: `pmove_parity.rs`, `run_trace` (lines 261-343) feeding `support/mod.rs` `trace_world` (162), `clip_box_to_brush` (55), `brush_plane` (41), `zero_trace` (33). It does not call a Raven function. It proves the test world, so it is a golden of test code.
   - Swift: no Raven function to call. The test needs a Swift transcription of `pmworld.h` (`pm_trace_impl`, `pmw_clip_box_to_brush`, `pm_pointcontents`) that uses only `+ - * /` and compares in `Float`, no libm. A Swift test that rebuilds `pmove_trace.txt` calls that transcription over `fixtures/pmove/trace.txt`.
   - Setup: none beyond the transcription. This is a prerequisite of the next two rows, so build it first. The transcription goes in `JKATestSupport` (it has none today).
   - Verdict: simple to run, but it is new test code of about 150 lines.

6. pmove.
   - Rust: `pmove_parity.rs`, `pmove_parity` (366-389), `run_scenario` (190-259), `ps_baseline` (35), `apply_ps_override`, `dump_step`, `support/mod.rs` `parse_scenario` (787).
   - Swift calls: `Pmove(_ pmove: JKAMP.Pmove)` (`Sources/JKAMP_BG/bg_pmove.swift:9436`), `BG_ParseAnimationFile(filename, animset, isHumanoid) -> Int32` (`bg_panimate.swift:1942`).
   - Setup the Rust test does: (a) `BgState::new()` with `bgHumanoidAnimations` sized to `MAX_TOTALANIMATIONS`; (b) a `TestTraps` for `trace`, `pointcontents`, `snap_vector`, FS reads of `animation.cfg`, `com_printf`, `com_error` (panics); (c) `TestCallbacks` for the anim restart check `entity_legs_anim` and `entity_torso_anim`, served from a mirror updated after each step; every other callback is unreachable; (d) a zeroed `pmove_t` with `tracemask`, `animations`, `gametype`, `entSize`, `baseEnt`; (e) the 32-bit `rng` tripwire `bg.rng.holdrand()`.
   - Swift counterparts: (a) `bg = BgState(consumer:maxPoolSize:)` and `bgHumanoidAnimations` (`BgConsumerTests.swift:17`, `bg_panimate.swift:12`). (b) `bg.straps.trap_SnapVector`, `trap_FS_FOpenFile`, `trap_FS_Read`, `trap_FS_FCloseFile` closures (`Generated/bg_strap.swift:49,94,171-195`); `move.trace` and `move.pointcontents` closures on the `Pmove` view (`BgConsumerTests.swift:34-52`, view props at `Sources/JKAMP/Generated/Views/Pmove.swift:247,270`). (c) `bg.callbacks.bgEntityLegsAnim` and a torso twin (`Generated/bg_callbacks.swift:133`). (d) the zeroed-memory view construction in `BgConsumerTests.swift:21-33`. (e) global `rng` (`JKAShared/q_math.swift:1144`).
   - Missing: the axial-brush world (row 5), a `ps_baseline`/override table, the 40-field dump line, the scenario row parser, a Swift FS stub serving `animation.cfg` by path, and any `PlayerState` fields the dump reads. No ready harness. The nearest is `BgConsumerTests` (one move over a floor).
   - Verdict: needs a harness. About 600 lines of Swift test support. Run `.serialized`, because `bg` is a global (rule 3, no task-local). `BgConsumerTests` runs in a child process (`processExitsWith`), but a parity test can run in-process.

7. pmove_saber.
   - Rust: `pmove_saber_parity.rs`, `pmove_saber_parity` (308-323), `ps_baseline` (48, saber pins), `apply_ps_override` (73), `dump_step` (125, adds `sm sb shl sen sal sac`), `run_scenario` (191).
   - Swift calls: the same `Pmove` and `BG_ParseAnimationFile`.
   - Setup: row 6 plus saber baseline (`fd.saberAnimLevel`, `fd.saberAnimLevelBase` = `SS_MEDIUM`, `saberEntityNum = 1`, `saberHolstered = 0`, `saberMove = 0`). The zeroed `g_entities` makes `BG_MySaber` NULL on both sides. The Swift entity arena must be zeroed too. `bgEntity*` closures for `BG_MySaber` must return nil.
   - Verdict: needs the pmove harness. Adds only a baseline and a dump variant once row 6 exists.

8. saberload.
   - Rust: `jampgame_parity.rs`, `mod saberload` (613-1210) with `TestTraps` (FS and skin), `cs_syscall` (configstring mock engine), `NAMES`.
   - Swift calls: `WP_SaberLoadParms()` (`Sources/JKAMP_BG/bg_saberLoad.swift:2254`), `WP_SaberParseParms(name, saber) -> Bool` (467), then reads every `SaberInfo` field through its view.
   - Setup the Rust test does: a sorted file list from `fixtures/sabers/`, `FOpenFile`/`Read`/`FCloseFile`, `trap_R_RegisterSkin` that counts from 1 per saber and logs names, a configstring registry for `G_SoundIndex` (dedup by name, mints 1, 2, 3, 0 for empty), and a sound-name tape.
   - Swift counterparts: closures `bg.straps.trap_FS_GetFileList`, `trap_FS_FOpenFile`, `trap_FS_Read`, `trap_FS_FCloseFile`, `trap_R_RegisterSkin` (`Generated/bg_strap.swift:49-260`) and `bg.callbacks.G_SoundIndex` (`Generated/bg_callbacks.swift:76`). Swift needs no syscall trampoline, so the closure is a plain dedup map and it also records the tape. No Swift test installs these closures yet. `fixtures/sabers/*.sab` are carried.
   - Verdict: needs a smaller harness than pmove, but it needs the `SaberInfo` field dump of about 180 lines (declaration order, per the dumper `main_saberload.c`).

Order of work, cheapest first: wsaber, bgmisc rest, qshared, gcombat (`raysphere`, then `hitloc` and `armor`), saberload, pmove_trace transcription, pmove, pmove_saber.

## 5. The `float-mpi.patch` and which goldens it changes

- File: `Sources/JKATestSupport/Oracle/float-mpi.patch` (2040 bytes), `Oracle/README.md` paragraphs 2 and 3.
- Reason: `q_shared.h:547-548` has `#ifndef M_PI` then `#define M_PI 3.14159265358979323846f` (a float), the value of Raven's Windows build. On the dumper host, `<math.h>` defines the double `M_PI` first, so the `#ifndef` never applies and C code that uses `M_PI` computes in double. `docs/transcription.md` rules the float.
- Change: one line `#undef M_PI` after `#include <math.h>` in the force-included `shim.h` that each run script writes. It touches six scripts: `run.sh`, `run_bgmisc.sh`, `run_gcombat.sh`, `run_pmove_saber.sh`, `run_qshared.sh`, `run_wsaber.sh`. After the patch, Raven's own `#define` supplies the float.
- Not touched: `huff-oracle` has no math shim, so the patch does not apply. The `run_pmove.sh` does not exist, `run.sh` builds `main_qmath.c`, `main_bglib.c`, `main_pmove.c`, `main_trace.c`, and `main_saberload.c` (`run.sh:192` runs `pmove_trace`).
- Goldens that differ from jka-rust (checked with `diff`):
  - `qmath.txt`: 17 changed lines (34 diff lines). Example line 3724: `gclose 1 00000000 bf423df9 be77081c` here, `bf423dfb be770814` in jka-rust. Line 3849 is a `va` line.
  - `pmove.txt`: 18 changed records (36 diff lines).
  - `bgmisc.txt`: 8 changed records (16 diff lines). Example `T 31 et 42d79b73 c28336e7 420da4b4 ...` here, `c28336e6 420da4b3` in jka-rust (trajectory section).
- Identical to jka-rust: `bglib`, `gcombat`, `pmove_saber`, `pmove_trace`, `qshared`, `saberload`, `wsaber`, and the `huff` folder. The README says so, and `diff` agrees.
- Both the submodule and the sibling hold the double-`M_PI` copy of `qmath`, `pmove`, and `bgmisc` (`cmp` finds them byte-equal). A Swift test for those three must read this repo's copy through `OracleData.golden`, as the existing `QMathParityTests` and `BGMiscTrajectoryParityTests` do. A Swift test must never read the jka-rust copy for them. For the other seven jampgame goldens either copy gives the same text, but use this repo's copy for one source of truth.
- Resync steps: `Oracle/README.md`, "To resync" (apply the patch with `patch -p1`, run `sh run.sh --regen` and each `sh run_<name>.sh --regen`, copy `golden` and `fixtures` back).
