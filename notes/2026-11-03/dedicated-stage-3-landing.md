# The dedicated server stage 3, the host landing: the merge rules, the host targets, and the first build stop

This record holds the landing of the MP dedicated server targets under `Sources/`. The tree is the worktree `/tmp/jka-ded-land` on the branch `dedicated-stage-3-landing`, off master at feb6641. The pass stopped at the time cap before the first full build. This record is the resume point.

## The rows of this stage and their rulings

The first try at the landing stopped before any commit. The host merge of the staged output moved the `g_public.h` and `interpreter.h` types of the game into `CJKAMP`, and the host forward lines went to `CJKAMP_forward.h`. The coordinator ruled four rows by the codebase patterns:

- L1, the host and tree placement: ratified. The host takes no part in tree placement. A type the host shares with one module stays in that module's target, and `CJKAMP_Ded` depends on `CJKAMP_Game`, `CJKAMP`, and `CJKAShared` for the `g_public.h` and `interpreter.h` types, as `CJKAHost` depends on `CJKASyscall`. Row T3 is amended to this: the host joins the default merge list, and a host unit never moves a type into a tree target.
- L2, the host forward lines: ratified. The forward lines of a host module go to `CJKAMP_Ded_forward.h`, the pattern of row S8.
- L3, the shared qcommon constants: ratified. `shared/qcommon/qcommon/constants.h` lands in `CJKAShared` with the `JKAShared` re-exports, and the two `CJKASP_UI` header changes land with it.
- L4, the landing gate: ratified. The merge with the host in the default list leaves every game, cgame, ui, and SP file byte-equal to master, apart from the placement of row L3, and the game and cgame snapshots prove it.

## What landed

| Commit | Subject |
|---|---|
| 3d7a45b | The host in the default merge, outside tree placement |
| 7c06bfc | CJKAMP_Ded, the merge output |
| d66b051 | The host targets in the package and the host view tools |
| 2bcf179 | The host views, re-exports, stubs, and world |

- `merge.py:44-52`: `mp-engine-ded` is in `MP_MODULES`, and `HOST_TARGET` names `CJKAMP_Ded`. `TARGET_DEPS` gives `CJKAMP_Ded` the deps `CJKAMP_Game`, `CJKAMP`, and `CJKAShared`.
- `merge.py`, `load_tree`: the forward lines of the host go to `FORWARD["CJKAMP_Ded"]`, and the forward header of the host writes them, row L2.
- `merge.py`, `partition_tree`: the modules place every type with the host left out. A type only the host emits lands in `CJKAMP_Ded`, and a type the host reads with another text keeps a host copy there, row L1.
- `merge.py`, `partition_shared`: the host copies decide no shared macro.
- `merge.py`, the umbrella: the host umbrella includes no module umbrella.
- `check.sh`: the host takes `-I CJKAMP_Game/include`.
- `reexport.py:40-47`: `DEPS` of a host lists the C target of its `other` module first.
- `views.py`: `TARGETS` is the C target and its `DEPS`, and a record of the other module's C target has its view in the host's view target.
- `rulings.py`: the `sharedEntity_t` host root names `CJKAMP_Ded`.
- `Package.swift`: `CJKAMP_Ded` depends on `CJKAMP_Game` and `CJKAMP`, `JKAMP_Ded` on `JKAMP` and `CJKAMP_Ded`, `JKAMP_DedLogic` on `JKAMP_Ded`, and `jampded` on `JKAMP_DedLogic`, `CJKAHost`, and `CJKAZlib`.
- `Sources/JKAMP_Ded`: 18 re-export files, 17 view files under `Generated/Views`, and `EngineVariables.swift` and `EngineStorage.swift` under `Generated/Storage`.
- `Sources/JKAMP_DedLogic`: the 40 generated stubs, unedited with their skeleton headers, and the hand file `EngineWorld.swift` in the shape of `CGameWorld` of `cg_local.swift:7`.
- `Sources/JKAMP/Generated/Views/Cvar.swift`: the one host view of `JKAMP`. The other host views of `cvar_t`, `playerState_t`, and the rest exist in `JKAMP` already or now stand in `JKAMP_Ded`.

## The counts

| Count | Value |
|---|---:|
| `CJKAMP_Ded` types | 119 |
| `CJKAMP_Ded` C++ only declarations | 40 |
| `CJKAMP_Ded` constants files | 19 |
| `CJKAMP_Ded` asserts per ABI | 441 |
| `check.sh` errors of every target, with the host's include path | 0 |
| `CJKAMP_Ded` asserts under `check.sh` | 1313 |
| Committed C files other than `CJKAMP_Ded` that the merge changes | 0 |
| Host views | 31, in 33 files |
| Host stubs | 608, 222 signature markers, 47 variable markers |
| Errors of `swift build --target JKAMP_DedLogic` | 12 in `CJKAMP_Ded.c`, the build stops there |

Row L3 did not come about. With the host out of placement, no MP module carries the qcommon constants, so the MP and SP texts never meet, and `shared/qcommon/qcommon/constants.h` stays a host constants file in `CJKAMP_Ded`. `CJKAShared` and `CJKASP_UI` are byte-equal to master. The merge is byte-equal to master for every file but `CJKAMP_Ded`, which is stricter than the gate of row L4.

The steps not reached: the `jampded` shell wiring, the build fixes of the Swift targets, the first run, the snapshots of the game and the cgame after the merge change, and the gate of `swift build` and `swift test --no-parallel`. The re-exports of `JKAMP_Ded` are the first rung, because `reexport.py --probe` did not run. The host run of `views.py` rewrote `JKAMP/Generated/Views/Callbacks.swift` with 28 lines fewer, and the landing kept master's file.

## The first build stop

`swift build --target JKAMP_DedLogic` stops in `Sources/CJKAMP_Ded/CJKAMP_Ded.c` with 12 errors:

- 11 times "redefinition of enumerator" at `CJKAMP_Ded/include/codemp/icarus/tokenizer/enum_TK_EOF.h:11-21`, `TK_EOF` to `TK_USERDEF`. The game's copy of the same enum is `CJKAMP_Game/include/codemp/game/g_ICARUScb_c/constants.h:9`, the prelude of `HEADER_PRELUDES` for `interpreter.h`.
- 1 "expected identifier" at `CJKAMP_Ded/include/codemp/qcommon/qcommon/sysEventType_t.h:11`, `SE_NONE`. The game's macro `SE_NONE` of `CJKAMP_Game/include/codemp/game/be_aas/constants.h:101` rewrites the enumerator.

`check.sh` passes, because it compiles the umbrella as text and the host umbrella includes no module umbrella. SwiftPM compiles with Clang modules, and the include of one header of `CJKAMP_Game` imports the whole `CJKAMP_Game` module. So every game-only name reaches the host, which Raven's server never saw: the server does not include `be_aas.h` or `g_ICARUScb.c`.

## Rows

The `CJKAMP_Game` dependency of row L1 brings the whole game module into the host under Clang modules, `Package.swift` and `Sources/CJKAMP_Ded/CJKAMP_Ded.c`. Two names clash: `TK_*` of the prelude of `tools/oracle-closure/rulings.py` `HEADER_PRELUDES`, and the macro `SE_NONE` of `oracle/codemp/game/be_aas.h`. The proposal is a small C target for the module ABI that the game and the host share, `g_public.h` and its `interpreter.h` types, on which both `CJKAMP_Game` and `CJKAMP_Ded` depend, in the place of the host's dependency on the game's target. The other choice is a host copy of each shared type in `CJKAMP_Ded`, which row L1 rules out.

`check.sh` compiles a target's umbrella as text (`tools/oracle-closure/check.sh:29`), and SwiftPM compiles it with Clang modules. The two differ for a target that includes a header of a module target. The proposal is that `check.sh` compiles with `-fmodules` and the module maps of the deps, so the check sees the build's errors.

The host run of `views.py` writes `JKAMP/Generated/Views/Callbacks.swift` with only the callback types the host reaches, 28 lines fewer than master (`tools/oracle-closure/views.py:887`, `write`). The removal rule spares the views of the other units in `JKAMP` and `JKAShared` but not their callback types. The proposal is that a run writes the union of its callback types and the ones the file holds for the other units, as it does for the views.

`reexport.py` with no `--probe` rewrites every view target to the first rung (`tools/oracle-closure/reexport.py:383`), so a run for one new target changed 12 committed files of `JKAMP`, `JKAMP_CGame`, `JKAMP_Game`, and `JKAShared`. The landing kept master's files. The proposal is a `--target` option that writes one view target, and a `--probe` run of `JKAMP_Ded` at the first build.

## The resume point

1. Rule the first row above, then change `Package.swift`, `merge.py`, and the deps of `reexport.py` and `views.py` by it, and merge again.
2. Run `swift build --target JKAMP_DedLogic`, fix the generated stubs with the smallest faithful forms, and record each fix with file:line.
3. Wire `Sources/jampded/main.swift` to Raven's dedicated entry of `oracle/codemp/null/win_main.cpp`, with `world = EngineWorld()` and the transport install in the shape of `dllEntry` of `Sources/cgame/cgame.swift:12`.
4. Make the first run as the brief gives it, and record the exit.
5. Run the gate: the game and cgame snapshots, the tool tests, `swift build`, and `swift test --no-parallel`.

## The landing

The branch `dedicated-stage-3-landing` merged to master as PR 53 at `e7d59dc`, head `560b1b6`. These four commits close the resume point above.

| Commit | Subject |
|---|---|
| 0edb904 | The module ABI types in the tree target |
| 4cff70a | The host views of a big byte array and an opaque record pointer |
| 1c34a68 | The host stub signatures, access words, and data tables for the shell |
| 560b1b6 | The jampded shell on Raven's main |

Commit `0edb904` holds row 1 of the ledger below and the three tool rows 2 to 4, in one generator run.

| Count | Value |
|---|---:|
| Errors of `swift build` | 0 |
| C errors of `CJKAMP_Ded.c` after the type move, with no local patch | 0 |
| `check.sh` errors of every target | 0 |
| `CJKAMP_Ded` asserts under `check.sh` | 1301 |
| Tests of `swift test --no-parallel` that pass | 130 |
| Tool unit tests that pass | 97, with 14 skipped |

`CJKAShared`, `CJKAMP_CGame`, `CJKAMP_UI`, every SP target, `JKAShared`, and `JKAMP_CGame` are byte-equal to master. The ledger move changes three pairs. `CJKAMP` and `JKAMP` get the `g_public.h` and `interpreter.h` types and 21 views. `CJKAMP_Game` and `JKAMP_Game` lose them. The `JKAMP_Ded` files lose `import JKAMP_Game`.

The first run is this command:

```
.build/debug/jampded +set fs_homepath /tmp/jka-client/home +set fs_basepath <Steam>/Jedi Academy/SWJKJA.app/Contents +set fs_game swift +set dedicated 1 +set sv_pure 0 +set vm_game 0 +map mp/ffa1
```

The run exits 133. The first trap is `Sys_Milliseconds` at `Sources/JKAMP_DedLogic/win_shared.swift:24`, called from `Sources/jampded/main.swift:27`. So the first hole round after the table batch is `win_shared`, then `common`.

The C++ `bool` has no row in the signature table, so many host stubs fall back to `-> Never`. Only `Sys_Milliseconds` and `Com_ParseTextFile` have a hand fix. A `bool` row goes in the table batch.

## The ledger

The coordinator ruled the four rows at the session's end on 2026-11-03 under the standing delegation, by the placement rule of `tools/oracle-closure/README.md`.

- Row 1, the `CJKAMP_Game` dependency: replaced. The placement rule already names the shape: a declaration every module of a tree agrees on lives in the tree target. `g_public.h` and `interpreter.h` are the module ABI the game and the host both include, so their types move to `CJKAMP`, their views and `GAME_ROOTS` rows move to `JKAMP` in the same commit, and the re-exports are written once in `JKAMP`. This amends the first landing row: the host takes part in tree placement for the module ABI headers the server includes, `g_public.h` and `interpreter.h`, and for no other header. No third C target.
- Row 2, `check.sh` with modules: ratified as proposed.
- Row 3, the callback types union: ratified as proposed.
- Row 4, `reexport.py --target`: ratified as proposed.

The coordinator ruled the ten rows below by the game and cgame patterns under the standing delegation.

- Row 5, the token enums: ruled by pattern. The token enum of `interpreter.h` and the two enums after it stay one copy per module, because each module declares `TK_USERDEF` for itself, the game in `g_ICARUScb.c` and the server in `tokenizer.h` (`tools/oracle-closure/merge.py:446-450`). Precedent: a type that two modules define differently keeps one copy per module, such as `lerpFrame_t` (`tools/oracle-closure/merge.py:443`).
- Row 6, the host's copy of the `bg_public.h` constants: ruled by pattern. The host drops its own copy and reads the tree's file, because the tree carries the union of the macros and the host reads a subset with the same text (`tools/oracle-closure/merge.py:379-383`). So no header path stands in two module maps. Precedent: a declaration every module of a tree agrees on lives in the tree target (`tools/oracle-closure/README.md:34`).
- Row 7, the includes of a tree type: ruled by pattern. A tree type never includes a file of the host's target, so the host's includes stay out of the tree copy (`tools/oracle-closure/merge.py:435`). Precedent: row L1, a tree target depends on no module or host target.
- Row 8, the system root of `check.sh`: ruled by pattern. `check.sh` passes `-isysroot` on an Apple triple only, and another triple reads the SDK headers as text with `-isystem` (`tools/oracle-closure/check.sh:31-39`). Precedent: SwiftPM passes the SDK as the system root on an Apple triple, and the SDK module maps build only there.
- Row 9, the two `views.py` fixes: ruled by pattern. A byte array of more than 4096 elements starts where the field before it ends (`tools/oracle-closure/views.py:388`), and a pointer to a record that no header completes is an `OpaquePointer?` (`tools/oracle-closure/views.py:337-338`). Precedent: the char array rule of the same function, and the type that Swift imports for an incomplete record.
- Row 10, the C++ overload stubs: ruled by pattern. Each stub of an overload pair takes the parameters the table maps, so no two stubs share a signature (`Sources/JKAMP_DedLogic/cm_shader.swift:145`, `Sources/JKAMP_DedLogic/cm_shader.swift:154`, `Sources/JKAMP_DedLogic/common.swift:818`, `Sources/JKAMP_DedLogic/common.swift:836`). Precedent: a Swift function keeps Raven's name, and Swift tells overloads apart by their parameter types.
- Row 11, the `Sys_Milliseconds` signature: ruled by pattern. The stub is `Sys_Milliseconds(_ baseTime: Bool = false) -> Int32` (`Sources/JKAMP_DedLogic/win_shared.swift:22`). Precedent: Raven's declaration `bool baseTime = false` at `oracle/codemp/qcommon/qcommon.h:978`.
- Row 12, Raven's `main`: ruled by pattern. Raven's `main` goes to the shell `Sources/jampded/main.swift`, as `vmMain` does in `Sources/jampgame/jampgame.swift:28` and `Sources/cgame/cgame.swift:29` under rule 11. `Sources/JKAMP_DedLogic/win_main.swift:498` holds a "Not ported" marker, and the shell has one `// AI:` line at `SetErrorMode` (`Sources/jampded/main.swift:24`).
- Row 13, Raven's data tables: ruled by pattern. Six Raven tables stand on `EngineWorld`: `svMaterialNames`, `PADDING`, `netsrcString`, `forceToggleNamePrints`, `opnames`, and `psTagStrings` (`Sources/JKAMP_DedLogic/EngineWorld.swift:13`). Precedent: the world type `CGameWorld` of `cg_local.swift:7`.
- Row 14, the smoke test: ruled by pattern. The smoke test expects the first `portMissing` trap, a nonzero exit and the text `TODO: Port ` (`Tests/jampdedTests/JampdedSmokeTests.swift`). The version line of rows 10 to 12 of stage 2 moves to the port of `Com_Init` (`oracle/codemp/qcommon/common.cpp:1219`).
