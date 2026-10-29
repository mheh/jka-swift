# The cgame stage 2: the views, the re-exports, the hand header, and the package targets

This record holds stage 2 of the MP cgame work. The cgame now has its C hand header, its re-exports in the view target `JKAMP_CGame`, a generated view for every record its bodies read, and the two Swift targets `JKAMP_CGame` and `JKAMP_CGameLogic`. The change clears blockers 4, 5, and 10 of `notes/2026-10-29/cgame-scout.md`. The tree is the worktree `/tmp/jka-cgame-stage2` on branch `cgame-stage-2`, which holds stage 1 merged with master at 2430078.

## The commits

| Commit | Subject |
|---|---|
| 14284df | The cgame hand header cg_types.h |
| ac9b246 | The cgame re-exports and the header parse of a unit |
| 671817f | The cgame views |
| da2e985 | The cgame logic target and its state files |
| 99849e1 | The cgame hand header in the transcription guide |

## The hand header, blocker 5

`Sources/CJKAMP_CGame/include/cg_types.h` copies Raven's text of the six structs that stand inside cgame `.c` files, each under its Source line, in the form of `g_types.h`: `cvarTable_t` at `oracle/codemp/cgame/cg_main.c:875`, `cgSpawnEnt_t` at `cg_main.c:3373`, `cparticle_t` at `cg_marks.c:300`, `lagometer_t` at `cg_draw.c:4144`, `veh_damage_t` at `cg_draw.c:2418`, and `consoleCommand_t` at `cg_consolecmds.c:260`. It also copies `LAG_SAMPLES` of `cg_draw.c:4141`, which `lagometer_t` needs, as `g_types.h` copies `MAX_TAGS`. The umbrella defines `LAG_SAMPLES` first through `cg_draw_c/constants.h`, and C takes the same text twice.

`HAND_HEADERS` and `HAND_FILES` at `tools/oracle-closure/rulings.py:482-483` name the header for `CJKAMP_CGame`. The umbrella needs the include, as the game's does, because `merge.py` writes the umbrella and keeps a hand file only through these two tables. `extract.py` over the eight modules, `merge.py --out ../../Sources`, `tables.py`, and `check.sh` changed one line under `Sources/`: the `#include "cg_types.h"` at the end of `Sources/CJKAMP_CGame/include/CJKAMP_CGame.h`. The merge also wrote a difference in `CJKASP_UI`, where `uiImport_t.h` moves under `cxx/`. The tools of 2430078 write the same difference, so it is not of this stage, and the commit leaves it out.

## The re-exports, blocker 4

`VIEW_OF` and `DEPS` at `reexport.py:44-45` come from every row of `[targets]`, so `CJKAMP_CGame` re-exports into `JKAMP_CGame` in the shape of `CJKAMP_Game` into `JKAMP_Game`, and `GAME_TARGET` is gone. Three changes keep a game file from a cgame name:

- A target reads only the names of the targets its umbrella reaches, `reexport.py:333`. Before, the game target came last and read no sibling.
- The probe ladder keys each rejected name by its view target, `reexport.py:334`, because the importer can take a name in one target and refuse it in the other.
- The probe reads the second error form of the build system, `error: <path>:<line>:<column> `, at `reexport.py:308`. A syntax error prints in that form, and before, the probe saw no error and stopped with the build broken.

The ladder allows 24 rounds, `reexport.py:329`, because a failed build stops at the first module that fails, and with four targets the run took 13 rounds. The run writes seven files under `Sources/JKAMP_CGame/Generated/`, 490 declarations. The three cast macros `NULL_HANDLE`, `NULL_SOUND`, and `NULL_FX` of `cg_local.h:19-21` climb to the TODO: Port marker, because the expression form keeps Raven's cast.

The header parse of `Parse` at `closure.py:371` reads the umbrella of the unit's C target. `skeleton.py:66`, `spelling.py:23`, `table.py:29`, and `traps.py:45` take that target from `closure.TARGETS`, so a cgame run names the cgame views and re-exports. A game run reads `CJKAMP_Game` in all five places, and `tests/test_unit.py` asserts it.

The game files the run writes are the files the tools of 2430078 write. Both runs give the same three differences from the committed files: `MAX_OSPATH` moves from `JKAMP/Generated/q_shared.swift` to a new `JKAMP/Generated/unknown.swift`, because the platform conditional at `CJKAMP/include/codemp/game/q_shared/constants.h:46-50` leaves the macro with no Source line, and `ulong` of `JKAShared/Generated/q_shared.swift` reads `CUnsignedLong`. These differences stand before this stage, and the commits leave them out.

## The views, blocker 4

`views.py` takes `--unit`, and `ROOTS` at `rulings.py:174` holds one table per unit, `GAME_ROOTS` at `rulings.py:19` and `CGAME_ROOTS` at `rulings.py:99`. `views.py:52-54` read the C target and the roots of the run's unit.

### The cgame roots

The game's roots are its state records, `gentity_t`, `gclient_t`, and `level_locals_t`, then each record a body reads that no root field reaches, grouped by how the body reaches it. The cgame roots follow the same rule:

1. The game's rows for the records of `JKAMP` that the cgame reads, `vmCvar_t`, `pmove_t`, and eleven more, with the game's view names and targets. They come first, because the first walk to reach a record gives it its target, and the game puts `VmCvar` in `JKAMP` over a type of `CJKAShared`.
2. The cgame's state, Raven's `cg`, `cgs`, and `cg_entities`: `cg_t`, `cgs_t`, and `centity_t`.
3. The records a file-scope table or record of a cgame file names, such as `cg_activeLocalEntities` and `cgDC`, and `gitem_t` of the bg table `bg_itemlist`.
4. The six structs of `cg_types.h`.
5. The records a trap or a stub parameter names, such as `polyVert_t`, `markFragment_t`, and the five FX argument structs of `q_shared.h`.
6. The shared-buffer records of `cg_public.h`, the eight `TCG` records and the four `ragCallback` records.

A root's target is the C target that holds its header, as `find Sources/CJKA* -name <T>.h` gives it, except the rows of group 1.

### The two records of the brief

The cgame `cvarTable_t` of `cg_main.c:875` has four fields, and the game's of `g_main.c:17` has seven. The cgame root at `rulings.py:132` puts its view `CvarTable` in `JKAMP_CGame`. The game's `CvarTable` stands in `JKAMP_Game`. No target imports both modules, so the two names never meet.

`CollisionRecord_t` is a type of `CJKAMP` (`Sources/CJKAMP/include/codemp/game/q_shared/CollisionRecord_t.h`), and the game's root at `rulings.py:63` puts its view in `JKAMP_Game`, which a cgame target cannot import. The cgame root at `rulings.py:156` puts a second view of the same C type in `JKAMP_CGame`, in the shape of the game's. A view in `JKAMP` cannot stand beside the game's, because `JKAMP_GameLogic` imports both `JKAMP` and `JKAMP_Game`, and `w_saber.swift:2007` names `CollisionRecord` with no module. The move of both views to `JKAMP` is one row of each table and one game file that moves, and it waits for a ruling.

### The four shapes the game never met

- A struct or union Raven left unnamed as the type of a field gets a view, `views.py:164-214`. Its record name is the owner's name and the field's, `refEntity_t_data`, as `jka-rust/crates/mp/qshared/src/common/mp/cgame/ref_entity_t.rs:30` names `refEntity_t_uRefEnt`. Its view name is the owner's view and the field with its first letter raised, `RefEntityData`, and the view binds over the type Swift nests in the owner, `refEntity_t.__Unnamed_union_data`. Its Source lines count from the owner's. The cgame reaches 18 of them, under `refEntity_t` and `localEntity_t`, which hold the four unnamed records of the census.
- A field typed through a second typedef takes the view of the struct behind it, `spelling.py:141-146`. `ui_shared.h:119` and `:146` write `typedef rectDef_t Rectangle;` and `typedef windowDef_t Window;`, and no header of the game does this.
- A stored function with no prototype, `void (*clearScene) ();` of `ui_shared.h`, is a callback of no arguments, `views.py:305` and `views.py:65`.
- A char array over 4096 elements has no Swift member, because Swift's importer takes no larger array. `gameState_t.stringData` holds 16000, so its accessor reads its text where `stringOffsets` ends, `views.py:350-362`, which is where C places a char array. `layout_asserts.h` gives offset 6800 on all three ABIs.

`SSkinGoreData` and the eight `TCG` records have no `_t`, so the default view name equals the C name and the view shadows the type. Their rows give the views `SkinGoreData` and `CGTrace` and their kin, which drop Raven's first letter, as the game's `IcarusPlaySound` drops `T_G_ICARUS_`.

### The files of a run

A run writes the view target of its unit whole. In `JKAMP` and `JKAShared` it removes a view only when no struct of its parse has the C name or when the run gives the struct another file, `views.py:787-806`. So a game run keeps the cgame views in `JKAMP`, and a rename by either unit removes the old file. A view of `JKAMP` that no unit reaches any more stays until a person removes it. Before, a game run removed every file of `JKAMP/Generated/Views` and `JKAShared/Generated/Views` and wrote its own.

`views.py --unit mp-cgame` writes 115 files: 54 in `JKAMP_CGame`, 57 in `JKAMP`, 26 of them new, and 4 in `JKAShared`, 1 of them new, `MarkFragment.swift`. It gives 113 views, 87 callback types, and 0 TODO: Port markers. The other 31 files of `JKAMP` and `JKAShared` keep the bytes the game run writes. `views.py` for the game writes 102 files and changes none. All 63 new records of `out/cgame-scout/views_census.txt` in the main tree have a view, and so do the 31 it lists as existing.

## The package, blocker 10

`Package.swift` declares `JKAMP_CGame` over `JKAMP` and `CJKAMP_CGame`, and `JKAMP_CGameLogic` over `JKAMP_CGame` and `JKAMP_BG`, beside the game's lines. With `Sources/JKAMP_CGameLogic` present, `closure.STAGED` is false for the cgame, and `skeleton.py --unit mp-cgame` writes in place: `CGameVariables.swift` and `CGameStorage.swift` under `Sources/JKAMP_CGame/Generated/Storage/`, and `Callbacks.swift` under `Sources/JKAMP_CGameLogic/Generated/`. The run also wrote the 33 cgame stubs, and the commit leaves them out. The logic target compiles with `Callbacks.swift` alone, because its seven namespaces are empty for the cgame. The view target holds no hand file. The game's `JKAMP_Game.swift` re-exports `JKAMP`, and the cgame needs that line only when a logic file imports `JKAMP_CGame` without `JKAMP`.

| Skeleton count | Stage 1 | Stage 2 |
|---|---|---|
| Stubs | 459 | 650 |
| TODO: Port signature markers | 213 | 22 |
| Variable markers | 54 | 8 |
| Storage | 260 | 294 |

## The files changed

| File | Change |
|---|---|
| `Sources/CJKAMP_CGame/include/cg_types.h` | new, the six structs and `LAG_SAMPLES` |
| `Sources/CJKAMP_CGame/include/CJKAMP_CGame.h` | the include of `cg_types.h`, written by `merge.py` |
| `Sources/JKAMP_CGame/Generated/*.swift` | new, seven re-export files |
| `Sources/JKAMP_CGame/Generated/Views/*.swift` | new, 53 views and `Callbacks.swift` |
| `Sources/JKAMP/Generated/Views/*.swift` | 26 new views |
| `Sources/JKAShared/Generated/Views/MarkFragment.swift` | new |
| `Sources/JKAMP_CGame/Generated/Storage/*.swift` | new, the two state files |
| `Sources/JKAMP_CGameLogic/Generated/Callbacks.swift` | new |
| `Package.swift` | the two targets |
| `tools/oracle-closure/reexport.py` | the unit rows, the sibling names, the ladder key, the second error form, and 24 rounds |
| `tools/oracle-closure/closure.py:371` | the umbrella of the unit |
| `tools/oracle-closure/skeleton.py`, `spelling.py`, `table.py`, `traps.py` | the C target of the unit |
| `tools/oracle-closure/spelling.py:141-146` | the second typedef |
| `tools/oracle-closure/views.py` | `--unit`, the unit's roots and names, the unnamed records, the callback with no prototype, the long char array, and the files of a run |
| `tools/oracle-closure/rulings.py` | `GAME_ROOTS`, `CGAME_ROOTS`, `ROOTS`, `HAND_HEADERS`, and `HAND_FILES` |
| `tools/oracle-closure/tests/test_unit.py` | the C target of the five modules, the unit rows, and the game roots |
| `tools/oracle-closure/README.md` | `views.py` takes `--unit`, the header parse of the unit, and the view shapes |
| `docs/transcription.md:88` | `cg_types.h` beside `g_types.h` |

## The gate counts

Each check ran in the worktree, in the foreground, one after the other, after the last code commit.

1. `swift build`: 0 errors. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all passed.
2. `.venv/bin/python -m unittest discover -s tests`, the form of the README: 93 tests, OK, 14 skipped. The new test is `test_the_roots_are_the_game_roots`, so the merged tree held 92 before this stage.
3. `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared`: exit 0, `370 files, no difference`, in 2 minutes 59 seconds. The snapshot holds the game unit alone, so it reports no cgame file.
4. `draftcheck.py --every`: 1283 holes, 0 cascade errors, 0 defects, 2 compile holes, 3 passes, exit 0, in 7 minutes 19 seconds. These are the counts of stage 1.
5. `views.py --unit mp-cgame` twice: each run reports 115 files, 113 views, 87 callback types, and 0 TODO: Port markers, and `git status` after each shows no changed file under `Sources/`.
6. `views.py` for the game: 102 files, 100 views, 33 callback types, 0 markers, and no changed file.

## What stays for stage 3 and later

- Blocker 8: the bg channel has one consumer, as stage 1 states.
- Blocker 3 and the stubs: a cgame run of `skeleton.py` now writes its 33 stubs into `Sources/JKAMP_CGameLogic`, because the target exists. They do not compile until the state object `CGameWorld`, the global `world`, and the trap overload exist, so a stage 4 run adopts them with those files.
- `traps.py --unit mp-cgame` writes `Sources/JKAMP_CGame/Generated/cg_syscalls.swift` in place now. Its calls need a `Syscall.call` overload over `cgameImport_t`, as `Sources/JKAMP_Game/Syscall+Game.swift` gives the game, so this stage does not run it.
- `draftcheck.py --unit mp-cgame` no longer takes the staged path of `draftcheck.py:347-368`, because the logic target exists. Its gate of the cgame stems in a mirror of a cgame product waits for the shell target `cgame`.
- `CollisionRecord_t` has two views, one in `JKAMP_Game` and one in `JKAMP_CGame`, until a ruling moves both to `JKAMP`.
- The three cast macros of `cg_local.h:19-21` keep the TODO: Port marker.
- The re-export drift of `MAX_OSPATH` and `ulong`, and the `CJKASP_UI` drift of the merge, stand before this stage and are not committed.
