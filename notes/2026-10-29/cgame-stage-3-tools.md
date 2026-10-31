# The cgame stage 3, the tools half: the four vehicle files, the stubs, the manifest, the cgame install, and the compile gate

This record holds the tools half of stage 3 of the MP cgame work. The cgame parse now compiles the four vehicle files of the game folder, the cgame stubs and the cgame typed traps compile in `JKAMP_CGameLogic` and `JKAMP_CGame`, the manifest cites the cgame Rust, the bg channel writes the cgame install, and `draftcheck.py --unit mp-cgame` builds the cgame stems. The change clears blockers 3, 7, 8, and 9 of `notes/2026-10-29/cgame-scout.md` and the five generator rows of V10 of `notes/2026-10-29/vehicle-npc-docket.md`. The tree is the worktree `/tmp/jka-stage3` on branch `cgame-stage-3-tools`, off `vehicle-npc-docket`. No file under `Sources/JKAMP_GameLogic`, `Sources/JKAMP_Game`, or `Sources/JKAMP_BG` changed. A second builder edits the bg bodies on `bg-consumer-edits` at the same time.

## The commits

| Commit | Subject |
|---|---|
| ba18dcd | The cgame parse compiles the four vehicle NPC files |
| 8f342a2 | The skeleton writes the cgame copy of the four vehicle files |
| fe4704c | The cgame world and the cgame syscall overload |
| 075f5d3 | The cgame stubs and the cgame typed traps |
| d213c02 | The manifest cites the jka-rust of the cgame copy of the vehicle files |
| bdc096f | The cgame manifests |
| 447c3e0 | The bg channel writes the cgame install |
| d677086 | The cgame install of the bg channel |
| 6512006 | The compile gate of the cgame stems |
| b2030e0 | The cgame manifest of cg_strap after the two CGAME_ROOTS rows |
| c999581 | The project test knows the four vehicle files of the cgame parse |

## The cgame parse, V10 row 1

`srcglob` of `[units.mp-cgame]` in `tools/oracle-closure/project.toml` gains `AnimalNPC.c`, `FighterNPC.c`, `SpeederNPC.c`, and `WalkerNPC.c` of `codemp/game`, Raven's list at `oracle/codemp/cgame/JK2_cgame.vcproj:294-303`. The unity parse sorts its files, so the order of the patterns does not matter.

`extract.py` over the eight modules and `merge.py` into a folder outside the tree, before and after the change, differ in one C target. `CJKAMP_CGame` gains `include/codemp/game/AnimalNPC_c/constants.h`, `FighterNPC_c/constants.h`, and `SpeederNPC_c/constants.h`, and its umbrella includes the three. The merge places the own macros of a `.c` file per module, and the cgame build now compiles these files. `WalkerNPC.c` defines no own macro. The cgame copy of `AnimalNPC_c` also holds `currentAngles` and `currentOrigin` of `AnimalNPC.c:53-54`, because no cgame header declares a field of those names, while the game keeps them in the `.c` file. `reexport.py` skips the macros of a `.c` file, so no re-export changes. `tables.py` and `check.sh` pass, and the merge also writes the `CJKASP_UI` drift that stands before this stage, which the commit leaves out.

## The skeleton's cgame target, blocker 3 and V10 row 2

`[targets.mp-cgame]` names the four files under `borrowed`. `closure.py` reads the list into `BORROWED`, `folder_of`, and `within`. `within(path, *folders)` is true for a file of a folder, and for a borrowed file when the folder of the run's unit is among the folders. The game row borrows no file, so every game check reads as before.

| File | Change |
|---|---|
| `closure.py` | `BORROWED`, `folder_of`, `within` |
| `skeleton.py` | `collect`, `collect_variables`, and `collect_macros` take the borrowed files. The cites, the source reader, `collect_file_enums`, and the signature rows take `folder_of`. `bg_function` and `Function.folder` give the thunk of a store of a bg function. `raw_argument` keeps the marker on a thunk with a bare C pointer |
| `table.py` | the eleven folder tests of the sweeps and `load_base` call `within` |
| `bodies.py` | the bytes of a draft come from `folder_of` |
| `reexport.py` | `swift_expression` writes Raven's `.55` as `0.55` |

Three facts of the cgame needed a tool change beyond the brief:

- The cgame copy of each vehicle setter stores `AttachRidersGeneric` of `bg_vehicleLoad.c` in the `AttachRiders` slot, row V7. The cgame run collects no bg stem, so `collect_record_stores` found no function for the store. `bg_function` finds the bg definition through the store's reference, and the thunk is `VehicleInfoThunks.AttachRidersGeneric`, which calls `JKAMP_BG.AttachRidersGeneric`. Row V7 names the thunk `AttachRiders`. The skeleton names every thunk as the function it calls, rule 3, so the thunk takes the function's name.
- The cgame stores `CG_Trace` and `CG_PointContents` in `pmove_t` and five functions in `displayContextDef_t` whose callback passes a vector, a text, or a scalar output as a bare C pointer. Only a view target may read through such a pointer, rule 11, so each of these nine thunks keeps `// TODO: Port signature` and a `portMissing` body. The game stores no such function.
- The macros of `cg_scoreboard.c:39-41` write `.55`, `.70`, and `.85`, which Swift does not take. No game macro has such a literal, because every committed game file compiles.

The stubs need the state object and the trap overload, in the shape the game has:

- `Sources/JKAMP_CGameLogic/cg_local.swift` holds `CGameWorld` with `storage`, `variables`, and `strings`, `public nonisolated(unsafe) var world = CGameWorld()`, and `var strings`, after `Sources/JKAMP_GameLogic/g_local.swift:822` and row N2 of `notes/2026-10-29/cgame-stage-2-names.md`.
- The skeleton forwards 30 of Raven's cgame data tables to hand properties of `CGameWorld`, for example `cvarTable` at `cg_main.c:882` and `colorTable` at `cg_main.c:27`. Each one is a `lazy var` with the `TODO: Port` marker and a `portMissing` initializer, so the first read traps with its subject until a transcriptor writes Raven's data. `ConsoleCommandRow` and `CvarTableRow` are the rows of `commands` and `cvarTable`, in the shape of `SpawnRow` and `CvarTableRow` of the game.
- `Sources/JKAMP_CGame/Syscall+CGame.swift` is `Syscall.call` over `cgameImport_t`, after `Sources/JKAMP_Game/Syscall+Game.swift`. Both import types are `Int32` aliases, and no target imports both view targets, so the two overloads never meet.

`skeleton.py --unit mp-cgame` reads `trap_Error -> Never` of `cg_syscalls.swift` as a seed of the never sweep. The first stub run came before `traps.py`, so `CG_Error` of `cg_main.swift` took `-> Never` in the second run, which d677086 commits.

## The manifest, blocker 7 and V10 row 3

`RustIndex` already read the crate of the unit's `rust` key beside `bg` and `qshared`, from stage 1. The cgame row now names `borrowed_rust`, `bg/src/vehicles` and `cgame/src/vehicle_npc.rs` under `jka-rust/crates/mp`. `RustIndex.span(name, stem)` reads those files first for a borrowed stem, and the file of the stem's snake name wins, so `ProcessMoveCommands` of `AnimalNPC.c` cites `animal_npc.rs:19-116` and not the first of four files. A unit other than the default writes its manifests into `.claude/manifest/mp-cgame/`, because the cgame copy of a vehicle file has the stem of the game file, and the first cgame run wrote over the four game manifests.

`manifest.py --unit mp-cgame`: 37 manifests, 706 functions, 699 with a jka-rust match. The four vehicle files match 26 of their 33 functions. The 7 others have no counterpart in the files the manifest reads. `AnimalProcessOri`, `FighterPitchClamp`, and the speeder's `AnimateRiders` stand in the jka-rust game crate (`jka-rust/crates/mp/game/src/AnimalNPC.rs:43`, `FighterNPC.rs:161`, `SpeederNPC.rs:49`). The four `G_Set*VehicleFunctions` have no jka-rust form, because jka-rust dispatches by vehicle type.

## The cgame install, blocker 8, V9, and V10 row 4

`channel.py --unit mp-cgame` writes `Sources/JKAMP_CGameLogic/Generated/BgChannel.swift`. The bg side of the channel is one text for every consumer, and the game run writes it. A trial run that built the hooks over the cgame table gave another bg side than the committed one: the cgame table maps no `Entity` and lacked two strap records then, so 11 callbacks and 2 straps fell to a signature marker. So `ConsumerInstall` reads the closures of `BgStraps` and `BgCallbacks` from `Sources/JKAMP_BG/Generated/bg_strap.swift` and `bg_callbacks.swift`, and maps no hook. It points each closure at the cgame function of the same name where the cgame build defines one, the cgame folder and the four borrowed files, as Raven's link of the cgame build resolves the bg call. A closure with no cgame function keeps its trapping default. The run never calls `collect_callbacks`, so the `KeyError: 'G_NewString'` cannot occur.

The install holds:

- `bg.error` and `bg.print` over the cgame `Com_Error` and `Com_Printf` of `cg_main.swift:676` and `:682`. The game sets these in its shell at `Sources/jampgame/jampgame.swift:18-19`, and the cgame has no shell yet.
- `bg.fighterAltControl = bg_fighterAltControl`, the cgame cvar of `cg_main.c:770`.
- 12 straps of `cg_strap.c` and 17 traps of `cg_syscalls.c`.
- 9 callbacks: `BG_GetTime`, `CG_GetVehicleCamPos`, `CG_NewString`, and the six vehicle closures of row V9 over the cgame copy, `BG_FighterUpdate`, `FighterIsLanded`, and the four `G_Set*VehicleFunctions`.
- every closure with an entry in `CGAME_READS` of `rulings.py`, by the entry's expression, the read callbacks of row C5. The other builder adds the table on `bg-consumer-edits`, and the run reads it through `getattr` while it is absent. A trial with that branch's `CGAME_READS` and `bg_callbacks.swift` gave the five read callbacks of `BG_MySaber`, and `swift build` passed. The trial files were restored.

44 closures keep the trapping default: `trap_Trace`, `G_SetSharedVehicleFunctions`, the game callbacks of the C3 table, the two arm hooks, `PM_CrashLandEffect`, and the 23 game read callbacks.

`CGAME_ROOTS` gains `sharedIKMoveParams_t` and `sharedSetBoneIKStateParams_t`, the game's rows for two records of `JKAMP` that `cg_strap.c` takes. Without them the cgame stubs of `strap_G2API_SetBoneIKState` and `strap_G2API_IKMove` carried a signature marker, and the install could not reach them. `views.py --unit mp-cgame` writes the same bytes for both views.

## The compile gate, blocker 9 and V10 row 5

`draftcheck.py --unit mp-cgame` gates every stem of `JKAMP_CGameLogic` when the command line names no stem choice. The cgame has no shell target, so its run builds `--target JKAMP_CGameLogic` in the mirror, and the game run builds `--product jampgame` as before. The Source line pattern takes the folder of a borrowed stem, so the splice finds the functions of the cgame copy of the vehicle files.

## The counts

| Count | Stage 2 | Stage 3 |
|---|---|---|
| cgame stub files | 33, not committed | 37, committed |
| Mapped stubs | 650 | 685 |
| TODO: Port signature markers in the stubs | 22 | 20 |
| Variable markers | 8 | 8 |
| Thunks | 2 | 19, and 9 over an unmapped signature |
| Typed traps in `cg_syscalls.swift` | not run | 208, 9 TODO: Port signature markers |
| `TODO: Port` lines under `JKAMP_CGameLogic` | | 768, 30 of them in `cg_local.swift` |
| `portMissing(` calls under `JKAMP_CGameLogic` | | 757 |
| Manifest matches | 673 of 673 | 699 of 706 |

The skeleton run prints `37 files, 685 stubs, 20 TODO: Port signature markers, 19 thunks in 7 namespaces, 9 thunks over an unmapped signature`, `macros: 162 in the stubs, 20 spelled at the site, 8 field aliases, 4 function aliases`, and `variables: 34 let, 228 state, 60 data by hand, 0 initializers by hand, 294 storage, 2 data tables from tables.py, 8 markers`.

## The gate

Each check ran in the worktree, one after the other, after the last code commit. The harness moved the two draftcheck runs to the background after 180 seconds, and nothing else ran until each one finished.

1. `swift build`: 0 errors. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all passed.
2. `.venv/bin/python -m unittest discover -s tests`: 96 tests, OK, 14 skipped. The three new tests are in `tests/test_unit.py`. `tests/test_project.py` pins each unit's parse profile to the module files of 95fb8c0, so c999581 adds the four files of row V10 to the old patterns of `mp-cgame`.
3. `draftcheck.py --every`: 1283 holes, 0 cascade errors, 0 defects, 2 compile holes, 3 passes, exit 0. These are the counts of stage 2.
4. `draftcheck.py --unit mp-cgame`: 37 stems, 1662 holes, 0 cascade errors, 7 defects, 645 compile holes, 24 passes, exit 1, in 5 minutes 25 seconds. The cap of 24 passes stops at `cg_ents`. The 7 defects are drafts of `cg_ents.swift`: a `Slots<qhandle_t>` passed where the callee takes a pointer, at `:578`, a store of an `Int32` into a `byte` subscript, at `:885`, and an axis field passed as `inout [vec3_t]`, at `:1888` and `:2377`. The four vehicle stems give 2, 6, 5, and 2 holes and no defect.
5. `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared`: exit 0, `370 files, no difference`.
6. `git diff --stat master -- Sources/JKAMP_GameLogic Sources/JKAMP_Game Sources/JKAMP_BG`: empty.

## What stays for stage 4, the drafter rounds

- The 7 defects of `cg_ents` and the cap of 24 passes. The drafter needs the `Slots` hand-off of `gameModels` to a trap's `qhandle_t *`, the `byte` store, and the axis field of a view passed where the callee takes `inout [vec3_t]`.
- The 30 data tables on `CGameWorld`, each with its marker, and the rows of `commands` and `cvarTable`.
- The 20 signature markers of the stubs and the 9 of `cg_syscalls.swift`, the record pointers the scout lists in section 3.
- The 9 thunks over a bare C pointer. Each needs a ruling on how a cgame callback reads a vector, a text, or a scalar output, which only a view target may read.
- The cgame copy of the vehicle files takes the cgame arms of rows V5 to V8 from the cgame parse, in its own draft. The test of row V11 waits for the cgame test target.
- `CGAME_READS` arrives with the merge of `bg-consumer-edits`. The `getattr` read of `channel.py` can then become a plain import.
- `docs/transcription.md:9` names `.claude/manifest/<stem>.md`. A cgame transcriptor reads `.claude/manifest/mp-cgame/<stem>.md`, and the guide needs one sentence for it.

## What stays for stage 5, the host gate

- The shell target `cgame` with `dllEntry` and `vmMain`, which builds `BgState(consumer: .cgame, maxPoolSize: 2_048_000)`, resets `world`, and calls `installBgChannel()`. When the shell exists, `bg.error` and `bg.print` can move there to match the game.
- The product `cgamearm64.dylib`, the smoke loader, the listen server run of `notes/2026-10-29/human-recordings.md:7`, and the referee gaps of section 7 of the scout.
- `draftcheck.py --unit mp-cgame` then builds the cgame product in place of the logic target.
