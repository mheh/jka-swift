# The build of the rulings entries, the generator changes, and the drafter rules of the frame-path walk

This record lists the twelve changes that the sections "Entries in `rulings.py`", "Generator changes", and "Drafter rules" of `frame-path-walk.md` order, the generator runs, and the gates. Generator item 3 is the `spelling.py` check swap alone, as the conflict 3 verdict settles, and no `<name>Vectors` accessor is written. No commit was made. The builder stopped at a failed build, and the coordinator then changed two lines in `g_saga.swift`. After that change the build and all tests passed, as the section "After the builder" states.

## The changes

Line numbers are those of the working tree after the change.

### Entries in `rulings.py`

1. `tools/oracle-closure/rulings.py:157-164`: `TYPES` now keys a file-scope variable as well as a typedef, and `"gSiegeRoundWinningTeam": "Int32"` stands under a comment that names Raven's `qboolean` at g_saga.c:38 and g_main.c:1978 and the team numbers 0, `SIEGETEAM_TEAM1`, and `SIEGETEAM_TEAM2` (A2). `tools/oracle-closure/skeleton.py:51` and `:507-510` read the entry in `map_variable`, so `GameVariables.swift` gives `public var gSiegeRoundWinningTeam: Int32 = 0`.
2. `tools/oracle-closure/rulings.py:329-331`: `("G_Find", "match")` in `NULLABLE`, so the table gives `_ match: String?` (R9).
3. `tools/oracle-closure/rulings.py:216` and `:254-259`: a new `PARAMS` kind `int_value` and four rows for the `a` and `b` parameters of `SortClients` and `SortRanks`. `tools/oracle-closure/spelling.py:258-260` gives the kind `Int32`, so the table gives `private func SortClients(_ a: Int32, _ b: Int32) -> Int32` (A1, D6).

### Generator changes

1. `tools/oracle-closure/views.py:663` and `:683-686`: each generated `==` of a callback type gets a `!=` beside it, `!(lhs == rhs)` (A3). `Sources/JKAMP_Game/Generated/Views/Callbacks.swift` gains 3 and `Sources/JKAMP/Generated/Views/Callbacks.swift` gains 9.
2. `tools/oracle-closure/views.py:279-284` and `:360-373`: a `char[M][N]` field gets a second accessor `<name>Buffers: Slots<JKAShared.CharBuf>`, one `CharBuf` per row through `charBuf(at:capacity:)` and `store(_:at:capacity:)`, with the row bound as Raven spelled it (H3, R4). The two such fields are `Parms.parmBuffers` (`Parms.swift:68`) and `Level.teamVoteStringBuffers` (`Level.swift:294`).
3. `tools/oracle-closure/spelling.py:226-229`: `field()` tests `is_vec3(t)` above the `CONSTANTARRAY` arm (M2, S2, U1, D8 as amended). Five fields move from `Slots<Slots<Float>>` to `Slots<JKAShared.vec3_t>`: `GNPC.enemyLaggedPos`, `Vehicle.m_vMuzzlePos`, `Vehicle.m_vMuzzleDir`, `SaberTrail.oldPos`, and `SaberTrail.oldNormal`.
4. `tools/oracle-closure/skeleton.py:807-856`: `collect_stores` also reads a store into a function-pointer local whose type fits exactly one `gentity_t` callback field (J1). `Sources/JKAMP_GameLogic/Generated/Callbacks.swift` gains 13 `Pain` thunks and `Touch.NPC_Touch`, 215 thunks against 201.
5. The skeleton run refreshed the `G_SpawnVector` sig row (L3). `lookup.py sig G_SpawnVector` and `.claude/manifest/g_spawn.md:13` now give `_ out: inout JKAShared.vec3_t`. No code changed for this item.
6. `tools/oracle-closure/traps.py:198` and `:289-356`: `record_overload` writes a second overload for a `void /* struct name */ *` parameter when the struct has a view and every game-unit caller passes the address of that struct (O4). The one trap that fits is `trap_EA_GetInput(_ client: Int32, _ thinktime: Float, _ input: BotInput)`, at `Sources/JKAMP_Game/Generated/g_syscalls.swift:1376`, which calls the first overload with `input.handle`.

### Drafter rules

1. `tools/oracle-closure/draft_declarations.py:584-595` and `:605-607`, `draft_expressions.py:125-137` and `:442-444`, `draft_statements.py:538-540` and `:691-697`, and `bodies.py:258-259`: a local array of a narrow type keeps the narrow element, `[UInt8]` for `byte`. A read widens with `Int32(...)`, a store truncates through `converted`, a compound store is `UInt8(truncatingIfNeeded: Int32(m[i]) op x)`, and a step is `&+= 1` (R3, L1). The draft of `StringToFilter` reads `var b: [UInt8] = ...` and `b[i] = UInt8(truncatingIfNeeded: atoi(num))`.
2. `tools/oracle-closure/draft_declarations.py:403-406` and `:425-480`, `draft_classification.py:690-691`, and `bodies.py:168` and `:243`: a `gentity_t *` local with an initializer is a plain `Entity` when every store is `&table[i]` of a file-scope array, and every other read is a member access, a call argument, a store into another name, a return, or a compare with a non-NULL value (R7). The draft of `ForceGrip` reads `let vehEnt = g_entities[...]` and `vehEnt.inuse`.
3. `tools/oracle-closure/draft_classification.py:363-410`, `draft_statements.py:556-560`, and `draft_declarations.py:327-328`: a NULL store before the first allocator store fits the `CHARBUF_ALLOCS` form when no read of the local stands between the two. The NULL store drops under one comment line (O2). The draft of `SavePathData` reads `var fileString = CharBuf(524288)` and ``// Raven wrote `fileString = NULL` here, and no read reaches it before the allocation.``

## The generator runs

The order was `views.py`, `skeleton.py`, `traps.py`, `channel.py`, then `manifest.py`, each with exit 0. `merge.py` did not run, so no run deleted `g_tables.c` or `bg_tables.c`, and `tables.py` did not run. The first `skeleton.py` run wrote no new thunk, because `views.records` holds `gentity_s` twice and the field map counted each field two times. A set fixed the map, and the second run wrote the 14 thunks.

`views.py`: 102 files, 100 views, 33 callback types, 0 `TODO: Port` markers.
`skeleton.py`: 1 file, 0 stubs, 215 thunks in 7 namespaces, 0 thunks over an unmapped signature.
`channel.py`: 30 straps and 51 callbacks, 81 hooks, 0 markers.
`manifest.py`: 88 manifests, 2628 functions, 2539 with a jka-rust match.

The "adopted, left alone" list of `skeleton.py`, 87 files:

- `JKAMP_GameLogic` (75): AnimalNPC, FighterNPC, NPC, NPC_AI_Atst, NPC_AI_Default, NPC_AI_Droid, NPC_AI_GalakMech, NPC_AI_Grenadier, NPC_AI_Howler, NPC_AI_ImperialProbe, NPC_AI_Interrogator, NPC_AI_Jedi, NPC_AI_Mark1, NPC_AI_Mark2, NPC_AI_MineMonster, NPC_AI_Rancor, NPC_AI_Remote, NPC_AI_Seeker, NPC_AI_Sentry, NPC_AI_Sniper, NPC_AI_Stormtrooper, NPC_AI_Utils, NPC_AI_Wampa, NPC_behavior, NPC_combat, NPC_goal, NPC_misc, NPC_move, NPC_reactions, NPC_senses, NPC_sounds, NPC_spawn, NPC_stats, NPC_utils, SpeederNPC, WalkerNPC, ai_main, ai_util, ai_wpnav, g_ICARUScb, g_active, g_arenas, g_bot, g_client, g_cmds, g_combat, g_exphysics, g_items, g_log, g_main, g_mem, g_misc, g_missile, g_mover, g_nav, g_navnew, g_object, g_saga, g_session, g_spawn, g_strap, g_svcmds, g_target, g_team, g_timer, g_trigger, g_turret, g_turret_G2, g_utils, g_vehicleTurret, g_vehicles, g_weapon, tri_coll_test, w_force, w_saber.
- `JKAMP_BG` (10): bg_g2_utils, bg_lib, bg_misc, bg_panimate, bg_pmove, bg_saber, bg_saberLoad, bg_saga, bg_slidemove, bg_vehicleLoad.
- `JKAShared` (2): q_math, q_shared.c.

No stub file was overwritten. The files the runs moved, by `git status`:

- `.claude/manifest/`: 64 files, stale Swift line numbers and the refreshed sig rows.
- `Sources/JKAMP/Generated/Views/`: 3 files, `Callbacks.swift`, `SaberTrail.swift`, `Vehicle.swift`.
- `Sources/JKAMP_Game/Generated/Views/`: 4 files, `Callbacks.swift`, `GNPC.swift`, `Level.swift`, `Parms.swift`.
- `Sources/JKAMP_Game/Generated/Storage/`: 1 file, `GameVariables.swift`.
- `Sources/JKAMP_Game/Generated/`: 1 file, `g_syscalls.swift`.
- `Sources/JKAMP_GameLogic/Generated/`: 1 file, `Callbacks.swift`.

An untracked `HANDOFF.md` at the root showed in `git status` after the runs. No run of this build wrote it.

## The build

This section and the next one report the state when the builder stopped. The section "After the builder" gives the fix and the passing gate.

`swift build` exited 1 with two errors, both in `Sources/JKAMP_GameLogic/g_saga.swift`, an adopted hand file that this build did not change:

- `g_saga.swift:99:27: error: type 'Int32' cannot be used as a boolean; test for '!= 0' instead`
- `g_saga.swift:100:52: error: cannot assign value of type 'Bool' to type 'Int32'`

Lines 98-100 are the forward `var gSiegeRoundWinningTeam: Bool { get { world.variables.gSiegeRoundWinningTeam } set { ... } }`, which still says `Bool` over the `Int32` storage that the A2 entry gives. The store at `g_saga.swift:678`, `gSiegeRoundWinningTeam = winningteam != 0`, and the two compares that g_main holds as a hole at `g_main.swift:1997` wait on the same forward. The A2 ruling makes these Raven's lines, which is transcription work, so this build left them. No error stands in a file this build changed, in a generated file, or in a helper file.

The error stops the build of `JKAMP_GameLogic`, so the targets above it did not compile.

## The tests

- `swift test --no-parallel`: exit 1. The build stops on the same two `g_saga.swift` errors, so no test binary ran and no count exists.
- `tools/load-test.sh`: exit 1. The release build stops on the same two errors. No `Fatal error` line, because the game did not run.
- The tool tests, `.venv/bin/python -m unittest discover -s tests` in `tools/oracle-closure/`: 78 tests, OK, 16 skipped.

## After the builder

The coordinator changed two lines in `g_saga.swift` under row A2 of `notes/2026-10-11/frame-path-walk.md`. The forward at line 98 became `var gSiegeRoundWinningTeam: Int32 {` over the new Int32 storage. The store at line 678 in `SiegeRoundComplete` became `gSiegeRoundWinningTeam = winningteam`, which is Raven's line at `oracle/codemp/game/g_saga.c:688`. The A2 ruling names that store as Raven's line. The hole in `g_main.swift` at line 1997, the two compares in `FindIntermissionPoint`, stays a Port-note for phase 2.

The gate then passed. `swift build` exited 0. `swift test --no-parallel` ran 112 tests in four binaries (84, 14, 13, and 1), and all passed. `tools/load-test.sh` exited 0 with `InitGame` and `ShutdownGame` lines and no `Fatal error` line. The tool tests are as the builder reported: 78 OK, 16 skipped.

## Unruled

- A2: `TYPES` held typedef names only. The entry keys the variable name in the same table, and `map_variable` reads it before every other shape. A typedef and a file-scope variable of one name do not occur in the oracle.
- A1 and D6: the sig ruling is a new `PARAMS` kind `int_value` with one row per parameter, four rows, and not a set of comparator names.
- J1: a function-pointer local whose type fits more than one callback field, such as `think` and `reached`, names no field and gets no thunk.
- O4: the overload forwards to the first overload with `input.handle`, and it does not copy the syscall body. The rule reads Raven's comment from the parameter text and checks the game unit's callers only.
- H3 and R4: the accessor is written for every `char[M][N]` field, two today, and not for a named list.
- R7: the rule needs an initializer that is a slot address. A local with no initializer stays `Entity?`, because Swift's definite-initialization check can refuse a plain `let` assigned in branches. A compare with a non-NULL value and a return count as non-NULL reads.
- O2: the test of "no read reaches" is by source offset. Every NULL store must come before the first allocator store, and no read of the local may stand between a NULL store and that allocator store. A NULL initializer on the declaration fits the same way.
- The drafter changes move the printed drafts of other stems, for example the 136 `Entity?` locals of R7. No `snapshot.py --check` and no `draftcheck.py` ran, because the brief named neither.

## The fixes after review

These fixes close findings 1, 2, and 5 to 8 of `review-rulings-build-1.md`. Findings 3 and 4 stay as they are. No commit was made.

1. Finding 1 (A5), `docs/transcription.md:552-554`. The gloss "the size of one slot" is gone, and three lines now read: "Raven's `sizeof(T)` stored into an `int` is `Int32(View.byteCount)`, so `pm->entSize = sizeof(gentity_t)` is `pm.entSize = Int32(Entity.byteCount)`." Then "`byteCount` is `MemoryLayout<T>.size`, and C's `sizeof` is Swift's `stride`, so the form holds only where the size and the stride of `T` are equal." Then "For `gentity_t` the two are 1832."
2. Finding 2 (O2), `tools/oracle-closure/draft_declarations.py:327-334`. A `char *` local of the `CHARBUF_ALLOCS` form with a NULL initializer now drafts the `CharBuf` line and one comment line with the `comment` role, through `roled` as `draft_statements.py:560` does. The comment reads ``// Raven wrote `<name> = NULL` before the `<allocator>` store, so the store is the first value.``, with Raven's local name, his initializer text, and the callee of the allocator call that holds the size. No Raven site declares a `CHARBUF_ALLOCS` local with a NULL initializer, so no draft shows this line. The one site of the proof, `SavePathData`, stores the NULL in a statement. `bodies.py --stem ai_wpnav --only SavePathData` prints `var fileString = CharBuf(524288)` and ``// Raven wrote `fileString = NULL` here, and no read reaches it before the allocation.``, as before.
3. Findings 5 to 8, `tools/oracle-closure/rulings.py:162-163` and `:256-257`, `traps.py:293-294`, and `skeleton.py:809-810`. Each line with two sentences is now two lines, one sentence on each. All four are Python comments or docstrings, and no generator emits them into a Swift file, so no generator ran again.

The gates: `swift build` reads "Build complete! (0.69 sec)". `swift test --no-parallel` reads four runs: 1 test in 1 suite, 84 tests in 3 suites, 13 tests in 2 suites, and 14 tests in 4 suites, all passed. `tools/load-test.sh` exits 0. The tool tests, `.venv/bin/python -m unittest discover -s tests` in `tools/oracle-closure/`, ran 78 tests, OK, 16 skipped.
