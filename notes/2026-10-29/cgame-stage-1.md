# The cgame stage 1: the generators take a unit

This record holds stage 1 of the MP cgame work. Every generator now takes the unit as one argument, `--unit mp-game` or `--unit mp-cgame`, and `mp-game` is the default, so every game command line runs as before. The change clears blockers 1, 2, 3, 6, 7, and 9 of `notes/2026-10-29/cgame-scout.md`. The tree is the worktree `/tmp/jka-cgame-gen` on branch `cgame-generators`, off master at 8cde4f3. Only files under `tools/` changed, and nothing is committed.

## The unit table

`[targets]` of `tools/oracle-closure/project.toml:22-42` holds one row per unit. `[sweep] unit` at `project.toml:12` names the default. No other file spells a fact of a row: `reexport.py:42-47` reads the game row for the header parse, and `lookup.py:35` reads the store of the default row.

| Key | `mp-game` | `mp-cgame` | Reader |
|---|---|---|---|
| `other` | `mp-cgame` | `mp-game` | `closure.py:330-333`, the folder of the other unit comes from its own row |
| `folder` | `codemp/game` | `codemp/cgame` | `closure.GAME_DIR`, every sweep and cite |
| `traps` | `g_syscalls.c` | `cg_syscalls.c` | `skeleton.SKIP` at `skeleton.py:60`, `traps.py:49-50`, `:393` |
| `logic` | `JKAMP_GameLogic` | `JKAMP_CGameLogic` | `skeleton.LOGIC` at `skeleton.py:62`, the stub folder of the table key at `table.py:1869` |
| `views` | `JKAMP_Game` | `JKAMP_CGame` | `skeleton.VIEWS` at `skeleton.py:63`, `traps.VIEW`, `draft_calls.py:237`, `draft_expressions.py:25`, `{views}` of `[output] declarations` |
| `c_target` | `CJKAMP_Game` | `CJKAMP_CGame` | the import of the traps at `traps.py:48` and `:370`, and `reexport.GAME_TARGET` from the game row |
| `state` | `Game` | `CGame` | `<state>Variables`, `<state>Storage`, and `<state>World` at `skeleton.py:803`, `:1318`, `:1345` |
| `rust` | `game` | `cgame` | `RustIndex` at `skeleton.py:204` |
| `store` | `tools/oracle-closure/table.sqlite` | `tools/oracle-closure/out/mp-cgame/table.sqlite` | `table.STORE` at `table.py:33` |

The cgame names `CGame`, `JKAMP_CGame`, and `JKAMP_CGameLogic` follow the mirror table of section 8 of the scout. The state object of both units is the global `world`, because each logic target is its own module. These names stand until a ruling of stage 2 changes them.

## How a run selects the unit

`closure.unit_of` at `closure.py:310` reads the word after `--unit` from the command line at import, because every generator module reads the row at import. `closure.unit_argument` at `closure.py:321` gives each generator the `--unit` option with the units as choices, so the help names them. `skeleton.py`, `manifest.py`, `traps.py`, `channel.py`, `bodies.py`, and `draftcheck.py` take it. `Parse` at `closure.py:367-369` parses the unit of the run and the other unit.

`closure.STAGED` at `closure.py:338` is true when `Sources/` holds no logic target of the unit. `closure.written` at `closure.py:343` then moves each path a run writes under `tools/oracle-closure/out/<unit>/` at the same relative path, and the run says so in one line on standard error. For the game, `written` returns the path as it stands. The readers of the run's own output use the same path: `skeleton.stub_path` at `skeleton.py:80`, the stub glob of the table key at `table.py:1869-1870`, `module_lets`, and the registry of `bodies.py:98`.

## The files changed

| File | Change |
|---|---|
| `project.toml:10-62` | `[sweep] unit`, the `[targets]` rows, `[output] stubs` without the logic target, `{views}` in `[output] declarations`, and no `[store] path` |
| `closure.py:309-356`, `:367-369` | `unit_of`, `unit_argument`, `UNIT`, `TARGETS`, `OTHER_UNIT`, `GAME_DIR`, `CGAME_DIR`, `STAGED`, `written`, and the two parses |
| `reexport.py:39-47` | `GAME_TARGET`, `VIEW_OF`, and `DEPS` from the game row. The header parse stays on the game target for a run of any unit |
| `table.py:33` | the store of the unit |
| `table.py:98-105` | blocker 2: `SourceFile` reads strict UTF-8 first, and Latin-1 when the read fails, with a comment that names `cg_effects.c:401` and the byte 0xD7 |
| `table.py:1790-1791`, `:1869-1874` | the folder of the store, the stub folders with the logic target of the unit, and the `{views}` globs |
| `skeleton.py:51-82` | `SKIP`, `LOGIC`, `VIEWS`, `STATE` from the row, and `stub_file` beside `stub_path` |
| `skeleton.py:204`, `:399` | the jka-rust crate of the unit and the `extract.json` of the unit |
| `skeleton.py:491-495`, `:980`, `:1143`, `:1203` | the view target of the unit in place of `JKAMP_Game` |
| `skeleton.py:501`, `:544`, `:581`, `:606`, `:654`, `:1188-1190`, `:1358` | `reexport.GAME_TARGET` in place of the literal `CJKAMP_Game` |
| `skeleton.py:1256`, `:1301`, `:1308-1350` | the destination cell from `stub_file`, `Callbacks.swift` through `written`, and `homes`, which keeps the state files of the targets that hold a stem of the run, so a cgame run leaves the bg state files alone |
| `traps.py:47-50`, `:370`, `:393-394` | the view target, the C target import, the trap file, the note, and the output name of the unit |
| `channel.py:419-424` | the three files through `written` and the logic target of the unit |
| `channel.py:442-445` | a run of a unit other than the game writes nothing and says so in one line, blocker 8 |
| `manifest.py:26` | the manifest folder through `written` |
| `draftcheck.py:55` | the Source line pattern of the unit's folder |
| `draftcheck.py:347-368`, `:391-393` | blocker 9: a staged unit drafts every stem to `out/<unit>/.build-draft/drafts/`, counts the holes, and builds nothing |
| `bodies.py:98-100` | the registry reads the staged stubs too |
| `draft_calls.py:15`, `:237`, `draft_expressions.py:18`, `:25`, `:885` | the view target of the unit and the header target |
| `lookup.py:32-35` | the store of the default row |
| `README.md:9` | one paragraph about `[targets]` and `--unit` |
| `tests/test_unit.py` | 12 tests: the default unit, and one test per fact of the row that the game value is unchanged |

## The gate counts

1. `.venv/bin/python -m unittest discover -s tests`: 94 tests, OK, 16 skipped. Before the change the tree gave 82 tests, OK, 16 skipped, so the brief's 14 skipped is 16 in this tree. The 12 new tests are `tests/test_unit.py`.
2. `draftcheck.py --every`: 1283 holes, 0 cascade errors, 0 defects, 2 compile holes, 3 passes, exit 0, in 8 minutes 10 seconds on a cold store.
3. `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared`: exit 1, 370 files, two files differ, `manifest/ai_main.md` and `manifest/ai_wpnav.md`. Each difference is the Swift line of a stub row, for example `ai_main.swift:3575` against `:3577`. The snapshot was written at 12:02, and f23866e at 12:39 and 7adf706 at 12:49 added hand lines to `ai_main.swift` and `ai_wpnav.swift`. The unchanged tools of 8cde4f3 give the same two differences: `snapshot.py --out /tmp/jka-cgame-gen-baseline` from the tools of 8cde4f3, then `diff -rq` against the cached snapshot. `snapshot.py --check /tmp/jka-cgame-gen-baseline` with the change gives exit 0, `370 files, no difference`, before and after the last edit of `channel.py`. The cached snapshot is not refreshed.
4. `swift build`: 0 errors. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all passed.
5. `git status`: changes under `tools/oracle-closure/` only, and this record.

## The cgame counts

Each command ran in `tools/oracle-closure` with `--unit mp-cgame` and wrote under `tools/oracle-closure/out/mp-cgame/`. The store sweep ran first in the skeleton run and passed `cg_effects.c:401`. Both units needed `extract.py mp-game` and `extract.py mp-cgame` first, for the `file_enums` rows of `extract.json`.

| Generator | Count | Scout |
|---|---|---|
| `skeleton.py --unit mp-cgame`, 47 seconds | 33 files, 459 stubs, 213 TODO: Port signature markers, 2 thunks in 7 namespaces. Macros: 135 in the stubs. Variables: 34 let, 224 state, 58 data by hand, 260 storage, 2 data tables, 54 markers | the same |
| the state files | `JKAMP_CGame/Generated/Storage/CGameVariables.swift` and `CGameStorage.swift`, and `JKAMP_CGameLogic/Generated/Callbacks.swift`. No bg state file | the scout wrote over the game's files |
| `manifest.py --unit mp-cgame`, 12 seconds | 33 manifests, 673 functions, 673 with a jka-rust match, every one under `crates/mp/cgame/` | 14 false matches in the game crate |
| `traps.py --unit mp-cgame`, 1 second | 195 traps, 22 TODO: Port signature markers, `JKAMP_CGame/Generated/cg_syscalls.swift` with `internal import CJKAMP_CGame` | 195 and 22 |
| `draftcheck.py --unit mp-cgame --game`, 47 seconds | 33 stems, 673 functions, 460 bodies drafted, 213 signature markers, 1903 holes, no build | 460 bodies and 1900 holes |
| `channel.py --unit mp-cgame` | writes nothing, one line, exit 0 | not run |

The holes differ by 3: `cg_marks` gives 246 against 244, and `cg_players` gives 259 against 258. The registry reads the cgame stubs under `JKAMP_CGameLogic`, and the scout put them in `JKAMP_GameLogic`.

## What stays for stages 2 and 3

- Blocker 4: the header parse, the views, and the re-exports read the game target for a run of any unit, `reexport.py:39-47`. `views.py` takes no `--unit`.
- Blocker 5: `HAND_HEADERS` of `rulings.py:403` has no `CJKAMP_CGame` entry.
- Blocker 8: the bg channel has one consumer. `channel.py --unit mp-cgame` stops before the parse, because `collect_callbacks` stops with `KeyError: 'G_NewString'` on the cgame parse.
- Blocker 10: `Package.swift` has no cgame Swift target, so every cgame run writes under `out/mp-cgame/`. When `Sources/JKAMP_CGameLogic` exists, the cgame runs write into `Sources/` with no change to the tools.
- The lowered key of a cgame run reads the declaration lines under `Sources/` alone, and not the staged stubs. A cgame stub signature changes only when `skeleton.py` changes, and `skeleton.py` is a lowering module, so the key still drops on that change.
- `merge.py:50`, `tables.py:127`, and `rosetta.py:120` spell `CJKAMP_Game` by module, and they take no unit.
