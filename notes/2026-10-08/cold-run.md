# A cold run of the oracle-closure tool, 2026-10-08

This record answers two questions of the user: how do we know where we have holes, and how do we know where we are missing things. An observer agent ran the tool from a fresh store on branch `wave-0` at 2be11c7 and read what each command printed. Every command ran in `tools/oracle-closure/` with `.venv/bin/python`, in one foreground call, with the exit code from `$?` of the command itself. The logs are under `/tmp/cold-run/`, which does not last, so this record carries the counts.

Before the run, the stage-one store of 1 MB moved to `tools/oracle-closure/table.sqlite.stage-one.bak`, md5 `b7ba291142116726de7edb09e543bb48`. No command wrote under `Sources/` or `.claude/manifest/`. The total wall time of the tool commands was about 3,660 s, 61 minutes, and 3,255 s of that was the game draftcheck.

## 1. The cold build

| Command | Wall | Exit |
|---|---|---|
| `bodies.py --stem bg_pmove`, fresh store | 96 s, 84 s user | 0 |
| `bodies.py --stem bg_pmove`, warm | 24 s | 0 |

The cold run prints 8,968 lines to standard output. The warm run prints the same bytes, `cmp` exit 0. Standard error of the cold run holds two libclang warning blocks and three store lines:

```
[warn] 6628 parse errors (layouts may be partial); first:
  .../oracle/codemp/game/q_shared.h:1242: conflicting types for 'powf'
[warn] 5442 parse errors (layouts may be partial); first:
table.py: the store holds no base facts, so the sweep writes them
table.py: the store holds no adoption facts, so the sweep writes them
bodies.py: the store holds no lowered rows, so the drafts write them
```

The warm run prints the two warning blocks alone. The command prints no time for each phase. The difference of the two runs, 71 s, is the base sweep, the adoption sweep, and the lowering of bg_pmove together. The store was 47 MB after the cold run.

The draft starts with the Raven comment, the Source line, and the signature, and it ends with the footer:

```
//rww - Get a pointer to the bgEntity by the index
/// Source: oracle/codemp/game/bg_pmove.c:172
public func PM_BGEntForNum(_ num: Int32) -> JKAMP.BgEntity? {
...
// 54 holes
```

## 2. The whole store

`bodies.py` has no flag for every stem. It takes `--stem` with one stem, or `--only`. The README states no such flag. To lower every stem in one parse, the run used a driver script, `/tmp/cold-run/driver/all_stems.py`, outside the repo. The script calls `Lowering.lines` for each function of each stem of the bg, game, and shared targets, as `snapshot.py` and `bodies.py --stem` do, and prints the footer of each stem.

| Measure | Value |
|---|---|
| Wall, exit | 113 s, 0 |
| Parse, skeleton and warm table load, registry | 1.4 s, 32.3 s, 0.2 s |
| Lowering of 86 stems not yet lowered | 79.3 s |
| Stems, functions | 87, 2,628 |
| `lowered` rows | 60,523 over 2,576 functions |
| `lines` rows | 139,183 |
| Sum of the footers | 1,342 holes: bg 89, game 1,075, shared 178 |

One line per stem, then a total line:

```
bg_pmove: 102 functions, 0.0s, footer // 54 holes
total: 87 stems, 2628 functions, lowering 79.3s
```

The 60,523 lowered rows equal the count of the last record. The store was 80 MB after this step.

## 3. The snapshot

`snapshot.py --check $HOME/.cache/jka-swift/snapshot-stage-two-shared` ran in 27 s with exit 0. It printed one line, `snapshot.py: 353 files, no difference`. The reference folder holds 353 files. The check read the stored lowered rows, so it is also a test of the lowered key of the fresh store.

## 4. The hole counts

`draftcheck.py --all` gates the 10 bg stems. It ran in 134 s with exit 0.

```
bg_pmove: 101 of 101 hand functions replaced, 54 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes
bg_saga: 20 of 20 hand functions replaced, 6 holes, 0 cascade errors, 0 defects, 6 compile holes over 2 passes
build log: /Users/milohehmsoth/Developer/Milo/jka-swift/.build-draft/build.log
total: 107 holes, 0 cascade errors, 0 defects, 18 compile holes
```

The game stems ran as twelve `--stem` calls, because one call over all 75 stems runs past 600 s. Every call gave exit 0 and 0 defects.

| Call | Stems | Wall | Holes | Compile holes |
|---|---|---|---|---|
| AnimalNPC to NPC_AI_MineMonster | 15 | 344 s | 61 | 12 |
| NPC_AI_Rancor to NPC_AI_Wampa | 8 | 284 s | 40 | 11 |
| NPC_behavior to NPC_sounds | 8 | 269 s | 71 | 8 |
| NPC_spawn to ai_wpnav | 8 | 436 s | 183 | 35 |
| g_ICARUScb to g_bot | 4 | 160 s | 128 | 29 |
| g_client to g_exphysics | 4 | 152 s | 132 | 29 |
| g_items to g_nav | 8 | 252 s | 199 | 39 |
| g_navnew to g_target | 8 | 843 s | 85 | 31 |
| g_team to g_turret | 4 | 151 s | 19 | 2 |
| g_turret_G2 to g_vehicles | 4 | 146 s | 96 | 17 |
| g_weapon, tri_coll_test | 2 | 127 s | 171 | 6 |
| w_force, w_saber | 2 | 91 s | 172 | 5 |
| Sum | 75 | 3,255 s | 1,357 | 224 |

The sum is 1,357 holes, 0 cascade errors, 0 defects, and 224 compile holes over 75 stems. The bg and the game figures equal the references of `docs/oracle-closure.md`, and no per-stem line needs a comment.

The draftcheck hole count is the count of the last pass, so it is not the footer of the first draft plus the compile holes. A compile hole on a declaration makes each later read of that local a hole too. Eight stems differ from that sum, for example g_active, footer 4, 6 compile holes, 60 holes, and NPC_combat, footer 40, 6 compile holes, 52 holes.

The `rejected` table holds 335 rows over 43 files, all under one key, and that key equals `key:lowered` in `meta`. The 335 rows are more than the 242 compile holes of the two runs: bg_saga holds 74 rejected rows and its line names 6 compile holes. The table holds each statement the passes rejected, and a statement nested inside a rejected statement keeps its row when the outer statement becomes the hole.

## 5. The printed form of a hole

`printer.py --stem bg_pmove` ran in 2.5 s with exit 0. It printed 8,968 lines, the same bytes as `bodies.py --stem bg_pmove`, with the footer `// 54 holes`. `printer.py --stem bg_pmove --only PM_AddTouchEnt` ran with exit 0 and printed `// 0 holes`, because that function holds no hole. Of the 54 holes of bg_pmove, 53 are the two-line form and one is the three-line form. `printer.py --stem bg_pmove --only BG_G2PlayerAngles` ran in 1 s with exit 0 and printed 326 lines with the footer `// 1 holes`. The three-line form:

```
// Port-note: A pointer dereference the draft cannot place.
// Raven wrote: *crazySmoothFactor = time + 1000
portMissing("BG_G2PlayerAngles", source: "oracle/codemp/game/bg_pmove.c:9082")
```

The two-line form, which the store calls form `note`, has no Raven line, and the statement drafts under it:

```
// Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
portMissing("PM_AdjustAngleForWallJump", source: "oracle/codemp/game/bg_pmove.c:1607")
var scratchForward = vec3_t()
```

`printer.py --stem bg_pmove --compile-holes` ran in 1 s with exit 0 and printed the same bytes as the plain command, because bg_pmove has no rejected row. On stems with rejected rows the flag applies them, and the key does not stop them. bg_saga prints `// 6 holes`, bg_vehicleLoad `// 12 holes`, and g_main `// 90 holes`, each the hole count of its draftcheck line. No function of the three stems stopped the printer. A compile hole in g_main:

```
// Port-note: The draft of this statement did not compile, and the compiler wrote "no exact matches in call to initializer".
// Raven wrote: return (int)ClientConnect( arg0, arg1, arg2 )
portMissing("vmMain", source: "oracle/codemp/game/g_main.c:515")
```

## 6. The store's view of holes

The `lowered` rows by form:

| Form | Rows |
|---|---|
| statement | 53,475 |
| declaration | 5,260 |
| hole | 808 |
| dropped | 327 |
| scratch | 285 |
| note | 228 |
| block | 101 |
| label | 37 |
| choice | 2 |

The 808 `hole` rows print 913 `note` lines and 913 `raven` lines, because one declaration row can hold the note of each variable. The 228 `note` rows print 429 `note` lines and no `raven` line. Together the two forms print 1,342 `note` lines and 1,342 `marker` lines, the sum of the footers of step 2. Only the `hole` and `note` rows carry a reason, 269 distinct reasons in all. The top ten reasons, cut at 90 characters:

| Rows | Reason |
|---|---|
| 152 | Raven passes NULL for the `right` output. The ported function takes it by reference, so th |
| 83 | A pointer dereference the draft cannot place. |
| 41 | Raven passes NULL for the `forward` output. The ported function takes it by reference, so |
| 35 | A read of `argptr`, a local the draft left as a hole. |
| 31 | A read of `faces`, a local the draft left as a hole. |
| 22 | Raven passes NULL for the `up` output. The ported function takes it by reference, so the b |
| 21 | No operator between the operands, the text there is ``. |
| 17 | A store into `func`, a local the draft left as a hole. |
| 17 | A ++ inside an expression. |
| 16 | A store into `nameptr`, a local the draft left as a hole. |

The `lines` rows with role `note`, the top ten stems: q_shared 143, w_saber 138, tri_coll_test 128, g_main 72, bg_pmove 54, g_client 47, ai_main 43, NPC_combat 40, g_combat 37, NPC_spawn 36.

## 7. The Port-notes in the tree

`grep -rn "Port-note:" Sources/` gives 919 lines with exit 0: 903 in `JKAMP_GameLogic`, 12 in `JKAMP_BG`, and 4 in `JKAShared`. The game and bg figures equal the references. No Port-note stands under a `Generated/` folder. The top ten files: NPC_spawn 48, g_log 45, w_force 44, g_items 40, w_saber 39, ai_wpnav 37, g_bot 36, g_ICARUScb 35, NPC_AI_Jedi 34, g_nav 31. The most common text is the compile hole, 163 lines that start "The draft of this statement did not compile", then the NULL outputs, 75 for `up` and 55 for `right`.

Three kinds, a compile hole, an expression the drafter has no form for, and a hand doubt with no marker:

```
NPC_senses.swift:680  // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'AlertEvent' to expected argument type 'UnsafeMutableRawPointer'".
NPC_AI_Wampa.swift:380  // Port-note: An assignment inside an expression.
q_shared.c.swift:354  // Port-note: Raven returns 0, -1, or 1 here for a NULL s1 or a NULL s2. A `String` is non-optional, so the guard has no Swift form.
```

Each of the 903 game Port-notes has a `portMissing` call within three lines. Of the 12 bg Port-notes, 2 do, and none of the 4 shared Port-notes does.

## 8. What is missing

`align.py --adopted` ran cold in 1 s with exit 0. It printed one line per stem and a total line, and standard error named the deleted draft lines of each file and each rewritten function.

```
g_main: 0 same, 0 edited, 0 hand, 17 rewritten, 225 stub
q_shared: 38 same, 8 edited, 31 hand, 5 rewritten, 263 stub
total: 87 files, 119598 same, 1508 edited, 3411 hand, 327 rewritten, 488 stub
align.py: Sources/JKAMP_BG/bg_pmove.swift: 779 draft lines deleted
align.py: G_Printf is rewritten, ratio 0.26
```

The totals equal the last record byte for byte. Standard error names 14 rewritten functions and 3,514 draft lines deleted over the files. The `alignments` table gives the functions by state: 97 `stub`, 14 `rewritten`, 248 with an `edited` line, and 465 with a `hand` line. 29 hand functions hold `hand` lines alone, 355 lines in all, for example `qsortSpan` in bg_lib with 91 lines and the macro helpers of tri_coll_test. These are the hand helpers outside the map.

`compare.py --stem g_main --counts` ran in under 1 s with exit 1. It printed 49 lines, one per function, and no total line:

```
vmMain: 0 same, 0 edited, 0 hand, 0 rewritten, 5 stub
G_Printf: 0 same, 0 edited, 0 hand, 4 rewritten, 0 stub
```

`compare.py --stem g_main` ran in 1 s with exit 1 and printed 49 lines, 45 that end in `stub` and 4 that end in `rewritten`. The line shape is `g_main.c:515 vmMain stub`. The rewritten functions of g_main are G_Printf, G_Error, Com_Error, and Com_Printf. The 45 stub functions are vmMain, G_FindTeams, G_RemapTeamShaders, G_RegisterCvars, G_UpdateCvars, G_InitGame, G_ShutdownGame, AddTournamentPlayer, RemoveTournamentLoser, G_PowerDuelCount, AddPowerDuelPlayers, RemovePowerDuelLosers, RemoveDuelDrawLoser, RemoveTournamentWinner, AdjustTournamentScores, SortRanks, G_CanResetDuelists, G_ResetDuelists, CalculateRanks, SendScoreboardMessageToAllClients, MoveClientToIntermission, FindIntermissionPoint, BeginIntermission, DuelLimitHit, DuelResetWinsLosses, ExitLevel, G_LogPrintf, LogExit, CheckIntermissionExit, ScoreIsTied, CheckExitRules, G_RemoveDuelist, CheckTournament, G_KickAllBots, CheckVote, PrintTeam, SetLeader, CheckTeamLeader, CheckTeamVote, CheckCvars, G_RunThink, NAV_CheckCalcPaths, BG_GetTime, G_RunFrame, and G_GetStringEdString.

g_main holds no `edited` or `hand` line, so the two shapes come from `compare.py --stem q_shared`, exit 1, 170 lines. The head line names Raven's file and line, the function, and the role of the draft line for an `edited` line, or `hand` for a `hand` line:

```
q_shared.c:842 Q_stricmpn header
    draft: public func Q_stricmpn(_ s1: String, _ s2: String, _ n: Int32) -> Int32 {
    hand: public func Q_stricmpn(_ s1: CharBuf, _ s2: CharBuf, _ n: Int32) -> Int32 {
q_shared.c:842 Q_stricmpn hand
    draft:
    hand: var i1 = 0
```

The Swift tree:

| Count | Total | By folder |
|---|---|---|
| `portMissing(` | 1,140 | JKAMP_GameLogic 962, JKAMP_BG 86, JKAShared 53, jampgame 39 |
| `TODO: Port` | 166 | JKAShared 57, JKAMP_GameLogic 51, jampgame 39, JKAMP_BG 17, JKAMP_Game 2 |

The 166 `TODO: Port` lines split into 140 function markers, 25 `TODO: Port global` lines, and 1 `TODO: Port initializer` line. Of the 140 function markers, 45 stand in g_main.swift and 52 in q_shared.c.swift, which are the 97 stub functions of align. 39 stand in `Sources/jampgame/jampgame.swift`, one per case of the `vmMain` dispatch, for example `GAME_CLIENT_CONNECT` over `portMissing("ClientConnect", ...)`. align and the store do not see that file, because it is no Raven stem. The other 4 are the `NAV_HEADER_ID` and `NODE_HEADER_ID` macros of `JKAMP_Game/Generated/g_nav.swift` and two in `PortMissing.swift`, the doc line and the `fatalError` text of the definition.

The manifests under `.claude/manifest/` give a third count: 2,628 functions, 137 in state `marker`. The manifest calls a function `marker` when its body holds any `portMissing` call, so the 137 are the 97 stub functions and 40 ported functions with a hole marker inside.

## 9. The lookup

The README and the usage text of `lookup.py` give the forms `lookup.py <type>`, `lookup.py <type> <field>`, `lookup.py fn <name>`, and `lookup.py sig <name>`. Every call ran in 1 s or less.

```
$ lookup.py fn PM_AddTouchEnt          exit 0
bg_pmove.c  `PM_AddTouchEnt`  oracle `oracle/codemp/game/bg_pmove.c:924-944`  swift `JKAMP_BG/bg_pmove.swift:807`  ported
  `func PM_AddTouchEnt(_ entityNum: Int32)`
$ lookup.py sig PM_AddTouchEnt         exit 0
bg_pmove.c  `func PM_AddTouchEnt(_ entityNum: Int32)`
$ lookup.py fn G_RunFrame              exit 0
g_main.c  `G_RunFrame`  oracle `oracle/codemp/game/g_main.c:3582-4102`  swift `JKAMP_GameLogic/g_main.swift:1023`  marker
$ lookup.py gentity_t health           exit 0
Swift view `JKAMP_Game.Entity`, over one `gentity_t` in C memory. Source: oracle/codemp/game/g_local.h:133.
  `int health`  ->  `health: Int32`
```

`lookup.py fn NoSuchFunction` exits 1 with no text, and `lookup.py` with no question exits 2. The fresh store holds 0 `signatures` rows, because only `skeleton.py` and `manifest.py` write them. So every `fn` and `sig` answer above came from the committed manifests, and the command printed nothing on standard error about it.

## 10. The end state

`git status --short` shows the two entries of the start and this record:

```
 M notes/2026-10-08/stage-two-walk-changes.md
?? HANDOFF.md
?? notes/2026-10-08/cold-run.md
```

The new store is 110 MB, against 1 MB for the stage-one store. The md5 before and after `printer.py --stem g_main` is `e79200dc3a8ef6b4961e19f6c4661038` both times, so the reader open kept the bytes. The stage-one store stays at `tools/oracle-closure/table.sqlite.stage-one.bak`.

## Where we have holes

A hole is one mark in three places: the draft, the store, and the Swift tree.

1. To see the holes of one Raven file, run `printer.py --stem <stem>`. A hole prints as a `// Port-note:` line, then a `// Raven wrote:` line, then a `portMissing` call. A NULL-output note prints the Port-note and the marker alone, and the statement drafts under them. The footer `// N holes` counts the Port-note lines.
2. To count them for every file, read the store: `lowered` rows with form `hole` or `note`, 808 and 228, and their `reason` column. `lines` rows with role `note` per file give the footer of each stem. The sum is 1,342 over 87 stems: bg 89, game 1,075, shared 178.
3. To count the holes that compile, run `draftcheck.py --all` and `draftcheck.py --stem <list>` over the game stems. Its holes are those of the last pass, which adds the compile holes and the reads of a local a compile hole swallowed: 107 bg holes with 18 compile holes, and 1,357 game holes with 224 compile holes. `rejected` keeps the statements the passes rejected, 335 rows, and `--compile-holes` on `printer.py` or `bodies.py` prints them in place.
4. To see the holes still in the port, run `grep -rn "Port-note:" Sources/`. This is the docket of a round: 903 in the game target, 12 in bg, and 4 in shared.

The footer sum, the `note` lines, and the `hole` plus `note` rows count the same thing, the first draft, in three units: 1,342 lines, 1,342 lines, and 1,036 statements. draftcheck counts the draft after the compiler has read it, so 1,357 game holes is a larger number of the same kind. The Port-notes in the tree count a different thing: what the hand port still lacks. The hand rounds closed many draft holes, so the game target holds 903 Port-notes against 1,357 draft holes, and a hand file can also hold a Port-note that no draft has, as the 4 shared notes show. A person who plans a round reads the grep first. A person who changes the drafter reads the draftcheck lines.

## Where we are missing things

A missing thing is a function or a piece of the port that nobody wrote, which no hole count shows.

1. Run `align.py --adopted` and read the `stub` column. A `stub` function still has the skeleton's TODO line and `portMissing` body: 488 rows over 97 functions, 45 in g_main and 52 in q_shared. This is the first number to read.
2. Read the `rewritten` column of the same line: 327 rows over 14 functions. Their hand body differs too much from the draft for a line map, so a person compares them by eye with `compare.py --stem <stem>`.
3. Read the `hand` rows: 3,411 lines over 465 functions, and 29 functions of `hand` lines alone, 355 lines. These are hand helpers and forwards that no Raven function holds, so no draft checks them.
4. Run `grep -rn "TODO: Port" Sources/` and `grep -rn "portMissing(" Sources/`. They give 140 function markers and 1,140 marker calls. 39 function markers stand in `jampgame.swift`, the `vmMain` dispatch, and 25 `TODO: Port global` lines stand beside them. align counts neither, because neither stands in a Raven stem.
5. The docket table of `notes/2026-10-05/game-round-2.md` lists families of hand Port-notes, which the grep counts. Its "Found outside the diffs" list holds what no count holds: the read past the NUL in `BG_SiegeGetPairedValue`, the jka-rust ranges of three g_vehicles rows in the manifest, and the NULL sweep that does not follow a caller's optional local.

The `stub` count of align is the number a person reads first, because it names whole functions that nobody started. Then the `TODO: Port` grep, because the `vmMain` dispatch of `jampgame.swift` is outside the store. The manifest `marker` state, 137 functions, mixes the 97 stubs with 40 ported functions that hold a hole.

## Findings

1. `bodies.py` has no flag for every stem, and the README states none. `snapshot.py` lowers every stem as a side effect, and this run used a driver script outside the repo.
2. `bodies.py` prints no time for the sweep or for the lowering. The cold and warm runs give 71 s for both sweeps and one stem together.
3. Every parse prints two libclang warning blocks of 6,628 and 5,442 parse errors. `NOTES.md` calls them benign, and neither doc says so.
4. The draftcheck call over g_navnew to g_target, eight stems, ran 843 s, past the limit of 600 s for one call. The harness moved it to the background, and its output came back complete with exit 0. The other eight-stem calls ran 252 s to 436 s. The cause is not known. A later run can split that group again.
5. The `rejected` table holds 335 rows, and the draftcheck lines name 242 compile holes. bg_saga holds 74 rows for 6 compile holes. The docs say that the table holds the compile holes of the last pass, and do not say that it keeps the nested statements too.
6. The printer footer reads `// 1 holes` for one hole.
7. `printer.py --compile-holes` did not stop on any function of bg_saga, bg_vehicleLoad, or g_main, and gave the draftcheck hole count each time.
8. `compare.py --counts` prints no total line and exits 1 when a function is `stub` or `rewritten`.
9. A fresh store holds no `signatures` rows, so `lookup.py fn` and `sig` answer from the committed manifests and say nothing about it on standard error.
10. The committed manifest `.claude/manifest/ai_main.md` differs from the text the generator gives now. Three rows, BotAIStartFrame, BotAISetup, and BotAIShutdown, name Swift lines 6473, 6564, and 6608, and the generator gives 6479, 6570, and 6614. `snapshot.py --check` passes, because it compares the generator with the snapshot and not with the committed file.
11. `sqlite3 -readonly` failed with "unable to open database file" after the store had no WAL file. A plain `sqlite3` query works.
12. No count differs from a reference. The bg holes, the game holes, the defects, the compile holes, the Port-notes, the lowered rows, the snapshot files, and the align totals all equal the references.
