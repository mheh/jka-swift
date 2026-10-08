# Stage two, the S7 fix and steps 8 to 10, the gates of 2026-10-08

The fourth builder, an opus agent, built the S7 fix and steps 8, 9, and 10 of S26 on the branch `stage-two` in the worktree `.claude/worktrees/agent-ac60452bfe29cede1`, one commit each, from 2df98a6. The gate reference is the step-4 snapshot at `$HOME/.cache/jka-swift/snapshot-stage-two-step4`, 351 files. Every exit code below comes from `$?` of the command itself. The logs are under `/tmp/step8-10/`, which does not last, so this record carries the counts.

The tool tests went from 47 to 48, 54, 58, and 60 across the four commits, 9 of them under `SLOW=1` from the first commit on.

## The S7 fix, commit 1040291, a nested blank line names its enclosing statement

Every `marked()` call now marks a blank line, and the body call has no `blanks` parameter. A helper `blank()` in `draft_classification.py` strips the statement mark before each blank test: the trims of `block_body` and `choice`, the scratch trim of `draft_declarations.py`, the else-if indentation at the two `nested` sites, the switch arm filters and trim, the comment-only arm test, and `roled()`. A blank row keeps depth 0, so it prints as an empty line.

The new SLOW test is `test_a_nested_blank_row_names_its_enclosing_statement_and_not_the_body` in `tests/test_lowered.py`. On bg_pmove, no blank row whose next text row sits at depth 2 or more names the body, and each such row has depth 0 and empty text. Its first form was red with 514 rows at seq 0. Two of those stayed at seq 0 after the fix, in PM_DoChargedWeapons and PM_VehicleWeaponAnimate, because the labeled path drafts its blocks with no statement mark, and the nested comment lines there name the body too. The test leaves out the functions with a `label` row, and in that form it was red on the old code with 473 rows and green on the new code.

Over the whole store after the fix, 7,675 blank rows are nested by the test's count, and 356 of them still carry seq 0. All 356 sit in labeled functions, the same path as the 225 nested comment rows at seq 0.

| Check | Result |
|---|---|
| The new test on the old code | red, 514 rows, then 473 in its final form |
| `snapshot.py --check`, cold lowering | exit 0 in 90 s, 351 files, stderr named the four changed lowering modules |
| `printer.py --compile-holes` over the 43 stems with rejected rows, old code against new code, rejected rows moved to the current key in a copy | 43 stems, 8 stops each, no difference |
| Full suite under `SLOW=1` | 48 OK in 160 s, after one run that failed on the two labeled functions in 153 s |

## Step 8, commit 27145a0, align.py

`align.py` reads the line rows of a stem from the store with no parse, prints each function with `printer.function_lines`, and aligns it with the hand function of the same `/// Source:` line through `draftcheck.functions`. difflib runs over the stripped lines with `autojunk=False`. `store.py` holds two new tables, `alignments` with the primary key `(path, function, hand_line)` and an index on `(path, function)`, and `aligned_files` with the primary key `path`. `--stem` takes one stem or a comma list, and `--adopted` takes every stem of the `functions` facts whose stub is adopted.

The tests are in `tests/test_align.py`, Seam I, six tests over line rows written by hand into a temporary store. The three named tests and the S19 test each ran red before their code. The S19 test is `test_an_unequal_replace_block_is_hand_and_its_draft_lines_count_as_deleted`. Two more tests ran red before their code too: `test_a_replaced_line_in_a_block_of_equal_length_is_edited_with_its_line_row`, because no named test covers `edited`, and `test_a_hand_function_with_no_draft_function_is_hand` for the forward and the hand function of S20.

| Check | Result |
|---|---|
| Fast tests | each new test red, then green, 6 OK in 0.05 s |
| `snapshot.py --check` | exit 0 in 169 s, stderr named `store.py` as the stale base input |
| `bodies.py --stem q_math` and `--stem q_shared` | exit 0 in 24 s and 23 s, because the snapshot lowers the bg and game stems alone |
| `align.py --adopted`, cold | exit 0 in 1 s, 87 files: 119,739 same, 1,524 edited, 3,462 hand, 607 rewritten |
| Rewritten functions on standard error | 70 |
| Draft lines deleted on standard error | 3,851 over the files |
| `align.py --adopted`, warm | exit 0 in 1 s, 87 files unchanged |
| `align.py --stem bg_pmove` alone | 0.25 s |
| Full suite under `SLOW=1` | 54 OK in 166 s |

The per-stem counts, the same in the step-10 gate:

| Stem | same | edited | hand | rewritten |
|---|---|---|---|---|
| AnimalNPC | 472 | 0 | 42 | 0 |
| FighterNPC | 991 | 9 | 45 | 0 |
| NPC | 1527 | 3 | 6 | 0 |
| NPC_AI_Atst | 199 | 0 | 0 | 0 |
| NPC_AI_Default | 815 | 2 | 0 | 0 |
| NPC_AI_Droid | 392 | 0 | 0 | 0 |
| NPC_AI_GalakMech | 983 | 0 | 11 | 0 |
| NPC_AI_Grenadier | 505 | 0 | 0 | 0 |
| NPC_AI_Howler | 149 | 0 | 0 | 0 |
| NPC_AI_ImperialProbe | 459 | 0 | 16 | 0 |
| NPC_AI_Interrogator | 340 | 0 | 8 | 0 |
| NPC_AI_Jedi | 5053 | 6 | 18 | 0 |
| NPC_AI_Mark1 | 539 | 0 | 4 | 0 |
| NPC_AI_Mark2 | 243 | 0 | 4 | 0 |
| NPC_AI_MineMonster | 196 | 0 | 0 | 0 |
| NPC_AI_Rancor | 770 | 0 | 22 | 0 |
| NPC_AI_Remote | 276 | 0 | 4 | 0 |
| NPC_AI_Seeker | 480 | 0 | 16 | 0 |
| NPC_AI_Sentry | 427 | 0 | 4 | 0 |
| NPC_AI_Sniper | 678 | 0 | 10 | 0 |
| NPC_AI_Stormtrooper | 2244 | 0 | 3 | 0 |
| NPC_AI_Utils | 1000 | 0 | 3 | 0 |
| NPC_AI_Wampa | 489 | 0 | 16 | 0 |
| NPC_behavior | 1533 | 1 | 8 | 0 |
| NPC_combat | 2474 | 8 | 111 | 0 |
| NPC_goal | 212 | 0 | 0 | 0 |
| NPC_misc | 77 | 0 | 0 | 0 |
| NPC_move | 391 | 0 | 0 | 0 |
| NPC_reactions | 849 | 1 | 0 | 0 |
| NPC_senses | 814 | 1 | 34 | 0 |
| NPC_sounds | 57 | 0 | 0 | 0 |
| NPC_spawn | 2625 | 5 | 29 | 0 |
| NPC_stats | 2347 | 1 | 15 | 0 |
| NPC_utils | 1276 | 0 | 0 | 0 |
| SpeederNPC | 398 | 3 | 33 | 0 |
| WalkerNPC | 335 | 3 | 27 | 0 |
| ai_main | 5973 | 5 | 118 | 0 |
| ai_util | 646 | 0 | 6 | 0 |
| ai_wpnav | 2788 | 0 | 74 | 0 |
| bg_g2_utils | 74 | 0 | 6 | 0 |
| bg_lib | 110 | 1 | 153 | 0 |
| bg_misc | 1200 | 69 | 157 | 0 |
| bg_panimate | 1362 | 0 | 24 | 0 |
| bg_pmove | 6864 | 866 | 1025 | 59 |
| bg_saber | 2843 | 49 | 1 | 0 |
| bg_saberLoad | 2321 | 1 | 12 | 0 |
| bg_saga | 1083 | 15 | 9 | 0 |
| bg_slidemove | 780 | 71 | 21 | 0 |
| bg_vehicleLoad | 887 | 30 | 4 | 0 |
| g_ICARUScb | 3780 | 9 | 42 | 0 |
| g_active | 3122 | 23 | 50 | 0 |
| g_arenas | 87 | 0 | 0 | 0 |
| g_bot | 1040 | 9 | 40 | 42 |
| g_client | 3016 | 20 | 96 | 0 |
| g_cmds | 3157 | 25 | 30 | 10 |
| g_combat | 4563 | 14 | 31 | 0 |
| g_exphysics | 202 | 1 | 0 | 0 |
| g_items | 2641 | 0 | 47 | 0 |
| g_log | 1604 | 0 | 30 | 33 |
| g_main | 23 | 0 | 12 | 207 |
| g_mem | 35 | 0 | 0 | 0 |
| g_misc | 2420 | 2 | 42 | 0 |
| g_missile | 804 | 0 | 4 | 0 |
| g_mover | 2385 | 6 | 63 | 0 |
| g_nav | 1434 | 16 | 36 | 0 |
| g_navnew | 774 | 0 | 3 | 0 |
| g_object | 237 | 3 | 0 | 0 |
| g_saga | 1427 | 12 | 15 | 0 |
| g_session | 149 | 0 | 27 | 0 |
| g_spawn | 614 | 0 | 22 | 0 |
| g_strap | 48 | 0 | 0 | 0 |
| g_svcmds | 450 | 0 | 30 | 0 |
| g_target | 712 | 4 | 26 | 0 |
| g_team | 1033 | 0 | 14 | 0 |
| g_timer | 180 | 0 | 0 | 0 |
| g_trigger | 1513 | 4 | 46 | 0 |
| g_turret | 716 | 0 | 8 | 0 |
| g_turret_G2 | 897 | 1 | 4 | 0 |
| g_utils | 1721 | 18 | 9 | 4 |
| g_vehicleTurret | 283 | 0 | 24 | 0 |
| g_vehicles | 2197 | 23 | 41 | 0 |
| g_weapon | 4190 | 6 | 57 | 0 |
| q_math | 624 | 125 | 97 | 108 |
| q_shared | 156 | 24 | 70 | 95 |
| tri_coll_test | 107 | 10 | 150 | 49 |
| w_force | 4505 | 0 | 41 | 0 |
| w_saber | 7347 | 19 | 156 | 0 |

The rewritten functions with their ratios: BG_InSlopeAnim 0.26, G_GetMapTypeBits 0.27, SanitizeString 0.29, G_LogWeaponInit 0.13, vmMain 0.03, G_Printf 0.26, G_Error 0.26, G_FindTeams 0.07, G_RegisterCvars 0.16, G_InitGame 0.03, G_ShutdownGame 0.08, Com_Error 0.25, Com_Printf 0.26, AddTournamentPlayer 0.10, RemoveTournamentLoser 0.27, G_PowerDuelCount 0.26, AddPowerDuelPlayers 0.07, RemovePowerDuelLosers 0.13, RemoveDuelDrawLoser 0.17, RemoveTournamentWinner 0.27, AdjustTournamentScores 0.09, SortRanks 0.11, G_CanResetDuelists 0.26, G_ResetDuelists 0.22, CalculateRanks 0.04, MoveClientToIntermission 0.19, FindIntermissionPoint 0.14, BeginIntermission 0.10, DuelLimitHit 0.23, DuelResetWinsLosses 0.26, ExitLevel 0.09, G_LogPrintf 0.18, LogExit 0.09, CheckIntermissionExit 0.03, ScoreIsTied 0.26, CheckExitRules 0.02, CheckTournament 0.03, G_KickAllBots 0.21, CheckVote 0.08, SetLeader 0.18, CheckTeamLeader 0.13, CheckTeamVote 0.14, G_RunThink 0.20, NAV_CheckCalcPaths 0.17, G_RunFrame 0.01, G_GetStringEdString 0.29, tv 0.19, RotatePointAroundVector 0.25, MatrixMultiply 0.14, NormalToLatLong 0.11, GetStringForID 0.21, COM_DefaultExtension 0.22, ShortSwap 0.27, Long64Swap 0.20, COM_Compress 0.20, COM_ParseExt 0.08, COM_MatchToken 0.29, SkipBracedSection 0.27, Q_strrchr 0.25, Q_strncpyz 0.27, Q_strcat 0.27, Com_sprintf 0.27, va 0.15, Info_ValueForKey 0.11, Info_NextPair 0.16, Info_RemoveKey 0.08, Info_RemoveKey_Big 0.08, Info_SetValueForKey 0.09, Info_SetValueForKey_Big 0.10, coplanar_tri_tri 0.16.

62 of the 70 rewritten functions hold 4 or 5 hand lines. 42 are in g_main, where most bodies are still the marker pair, for example AddPowerDuelPlayers at ratio 0.07. 19 are in q_shared.c and 3 in q_math, where the hand wrote a Swift form of Raven's text helpers.

## Step 9, commit a4073ee, compare.py

`compare.py --stem` reads the alignment, the line rows, and the statement rows, and prints each `edited` or `hand` line as S23 shows. `--counts` prints the count of each state per function. `--against <folder>` reads `bodies/<stem>.swift` under the folder, the form of `snapshot.py`, or `<stem>.swift` beside it, the form of `.build-draft/drafts`. It compares that file with the text of the stored line rows through difflib and prints each differing line with its C line. A missing input raises `Missing`, and the command turns it into exit 2.

The tests are in `tests/test_compare.py`, Seam J. The two named tests were written together and both ran red, with no module, before the code. Two more tests came after the code and passed on their first run: `test_a_snapshot_line_that_differs_prints_its_c_line_and_both_texts_and_exits_one` and `test_a_hand_file_with_no_alignment_is_missing`.

| Check | Result |
|---|---|
| Fast tests | the two named tests red, then green, 4 OK |
| `compare.py --stem bg_pmove` | exit 1 in 0.22 s, the hand lines of bg_pmove |
| `compare.py --stem bg_pmove --counts` | exit 1 |
| `snapshot.py --check`, warm | exit 0 in 27 s |
| `align.py --adopted`, warm | exit 0 in under 1 s, 87 files unchanged |
| `compare.py --stem bg_pmove --against` the step-4 snapshot | exit 0 in 0.32 s |
| `--against` over the 86 stems of the step-4 snapshot | 85 exit 0, bg_weapons exit 2 with no function, fixed in step 10 |
| `--against /tmp/nowhere` | exit 2 |
| Full suite under `SLOW=1` | 58 OK in 159 s |

## Step 10, commit 1eca315, the docs and the carried findings

The README of `tools/oracle-closure` and `docs/oracle-closure.md` describe the three generations, the lowered rows and the line rows, the printer and its key check, `rejected` and the compile-holes flag with its stop, `align.py` and `compare.py`, the exit codes, and the snapshot gate with the warning on a warm check. `docs/oracle-closure.md` carries the draftcheck reference, 1357 holes, 0 defects, and 224 compile holes over the 75 game stems, and 107 holes and 0 defects over the bg stems. No document under `docs/` or the README held the old figure, so the reference stands as a new sentence in the compile-gate item. I did not run draftcheck. The new section 5 holds the rest. The README lost its one date, "taken on 2026-09-08", under the rule of no dates.

| Check | Result |
|---|---|
| Fast tests | 60 OK, 9 skipped |
| `snapshot.py --check` | exit 0 in 168 s, stderr named `project.toml` and `store.py` as stale base inputs and six changed lowering files |
| `bodies.py --stem q_math` and `--stem q_shared` | exit 0 |
| `align.py --adopted` | exit 0 in 2 s, 87 files, the per-stem counts of step 8 byte for byte |
| md5 of `table.sqlite` across `printer.py --stem bg_pmove`, `printer.py --only PM_AddTouchEnt`, `compare.py --counts`, and `lookup.py fn Pmove` | `a1dffdc3` before and after |
| `printer.py --stem bg_pmove` and `--stem bg_weapons` against the snapshot | equal byte for byte, both exit 0 |
| `compare.py --stem bg_weapons --against` the snapshot | exit 0 |
| `printer.py --stem nosuch` | one line on standard error, exit 1 |
| Full suite under `SLOW=1` | 60 OK in 156 s |
| `swift build` | exit 0 in 30 s, 0 errors |
| `swift test --no-parallel` | exit 0 in 6 s, 106 tests in four binaries, 78, 14, 13, and 1 |

## Departures from the ruled text

1. S20 and S18. A rewritten function's rows carry the state `rewritten`, with no line row, no statement, and no role. S20 says each hand line of it gets a `hand` row. I read the state set of S18, which names `rewritten`, as the state of those rows, so `--counts` can count them apart.
2. S19. A `hand` row carries no statement and no role, as it carries no line row. S22 asks compare for the C line of each printed line, so compare cites the statement of the nearest row above in the same function, or the function's Source line.
3. S22 and S23. compare prints one line for each rewritten function, `g_main.c:1346 AddPowerDuelPlayers rewritten`, with no texts, and a rewritten function makes the exit code 1. `--against` labels its two lines `stored:` and `snapshot:`, and it keeps the indentation, because the comparison is byte for byte.
4. S20. A hand helper with no `/// Source:` line gets no row, because the Source line is the one match key. A forward, and a hand function whose Source line no draft holds, gets `hand` rows from its Source line to its brace.
5. S27 and the brief. `align.py --adopted` covers 87 stems, not 91 files. The 91 are the files under `Sources/JKAMP_BG` and `Sources/JKAMP_GameLogic` without the generated header. Six of them have no Raven `.c` file, for example `JKAMP_BG.swift` and `g_local.swift`, and `q_math` and `q_shared` are adopted stems in `JKAShared`.
6. The S7 fix. The labeled path keeps its 356 nested blank rows at seq 0, as its 225 nested comment rows, and the test leaves labeled functions out. The amended S7 names the `marked()` calls, and the labeled path makes none.
7. S3a and S7a. `alignments` has no `language` column, because S18 lists its columns and S7a names `lowered`, `lines`, and `rejected` alone.
8. Carried finding 5 went one step further than the three names. The lowered key, the declaration-line test, and the language moved from `bodies.py` to `lowering_key.py`, because `printer.lowered_key` imported `bodies` at the call for them. Both new modules are in the `lowering` list, because the registry of `bodies.py` reads the regexes of `lowering_key.py`.

## The carried findings

1. The printer and a stem with no function. `printer.py --stem bg_weapons` prints the footer alone, `// 0 holes`, byte for byte with the snapshot, when the store lists the stem's stub under `adoption`. A stem with no stub and no function still stops with exit 1. `compare.py --against` takes the same rule. For the next walk under S15, a clarification: "A stem whose stub the store lists and that holds no function prints the footer alone, as `bodies.py` prints it."
2. The reader open. `Store(path, reader=True)` skips the schema write when the stored version matches. `printer.py`, `lookup.py`, and `compare.py` use it. A fast test in `tests/test_store.py` shows the file keeps its bytes, and the same steps with a writer open move them. The md5 of the working store did not move across four reader commands.
3. One map of statement seqs. `Drafter.draft` builds `statement_seqs` once, and `rows()` reads it with no argument. The three callers in `bodies.py` and `draftcheck.py` no longer read the statement rows a second time.
4. The draftcheck keys. `draftcheck.py` asserts after each function that its keys and its printed lines have one length, and the message names the function and the stem.
5. The layout names. `layout.py` holds `INDENT`, `COMPILE_NOTE`, and `port_note`, and `lowering_key.py` holds the key, see departure 8. `printer.py` loads no drafter module, which a check of `sys.modules` after `import printer` shows, and loads no libclang.
6. One key in `rejected`. `save_rejected` deletes the rows of every file under another key. A fast test shows it, and it fails on the old `store.py`. The working store still holds the rows of the last draftcheck run under an older key until the next run, because this brief runs no draftcheck.
7. The reason of a two-variable declaration hole. `rows()` joins every note of the statement, one after the other. The store holds 6 such `DECL_STMT` holes, and each reason names every note. No printed byte moved.
8. The stored last pass of S16. Not built. The docs state the printer's stop under `--compile-holes`. The open form: `draftcheck.py` stores, beside the rejected rows under the same key, the last-pass line rows of each function the printer stops on, or a digest of their printed lines. Then the printer prints the last pass with no parse, or checks `holed()` against the digest and stops only on a true difference.

## Open findings for the user

1. 62 of the 70 rewritten functions are bodies of 4 or 5 lines, most of them the marker pair of a function no one has transcribed, 42 of them in g_main. The ratio rule counts an untranscribed function as rewritten. A state for a hand body that is still the marker pair would tell the two apart.
2. The labeled path writes its nested lines under the body's seq, 356 blank rows and 225 comment rows. Finding 25 of the step-4 review carries it, and the S7 rule of the innermost statement does not reach it yet.
3. `snapshot.py` lowers the bg and game stems alone, so after a key change `align.py --adopted` stops on q_math until `bodies.py --stem q_math` and `--stem q_shared` run.
4. The S23 note of the walk says `lookup.py` exits 2 on a missing input. The code exits 2 on no question or a question of the wrong form, and 1 when it finds no answer. The docs state what the code does.
5. A reader open of a store of another schema version still deletes the store and makes it again, as a writer does.
6. `HANDOFF.md` at the repo root and the S27 text of the seams docket still carry 1342 holes over 72 stems.
