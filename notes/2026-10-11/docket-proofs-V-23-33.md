# Docket proofs for rows V23 to V33

This record proves rows V23 to V31 of Part C of `phase-2-plan.md` and two rows from the notes on Part A, V32 (note 3) and V33 (note 5). The evidence is the tree of `wave-0` at a1b6196 and the working tree while the phase 2 wave runs, Raven's C under `oracle/codemp/game/`, the jka-rust range in the submodule `jka-rust/`, `tools/oracle-closure/lookup.py`, and `docs/transcription.md`. A Swift line that the wave has already changed shows both texts. The guide line numbers are those of the working tree.

### V23. Does the H3 and R4 row accessor go on every `char[M][N]` field or on a named list?

Source. `rulings-build-generators.md:87`, Unruled: "the accessor is written for every `char[M][N]` field, two today, and not for a named list." The change is generator item 2 at `rulings-build-generators.md:18`.

Sites. `tools/oracle-closure/views.py:279-284` tests the row type of a `CONSTANTARRAY` field for `CHAR_S` and adds `row_buffers`, and `views.py:360-373` writes `public var <name>Buffers: Slots<JKAShared.CharBuf>` with the row bound as Raven spelled it. The two generated accessors are `Sources/JKAMP_Game/Generated/Views/Parms.swift:68`, `parmBuffers`, and `Sources/JKAMP_Game/Generated/Views/Level.swift:294`, `teamVoteStringBuffers`. The one-row form beside it, `views.py:268-272`, writes `<name>Buffer` on every `char[N]` field with no list.

Raven. A grep of every header under `oracle/codemp` for a `char name[M][N]` field gives two game fields, `g_public.h:670` `char parm[MAX_PARMS][MAX_PARM_STRING_LENGTH]` and `g_local.h:875` `char teamVoteString[2][MAX_STRING_CHARS]`. The other hits are in `ui_local.h`, `tr_local.h`, `server.h`, `client.h`, `cg_local.h`, and `tr_types.h`, and no view of the game targets covers them. Raven writes a row through a `char *` callee at `g_cmds.c:2326` and `:2330` (`Com_sprintf( level.teamVoteString[cs_offset], ... )`) and at `g_ICARUScb.c:3677` and `:3682` (`Com_sprintf` and `strncpy` into `ent->parms->parm[parmNum]`). He reads rows as text at `g_main.c:3429`, `:3434`, `g_cmds.c:2360`, `g_ICARUScb.c:1226`, `:1604`, `:1681`, and `NPC_spawn.c:1679-1681`.

jka-rust. `level_locals.rs:87` holds `teamVoteString: [String; 2]`, an owned type, and `g_cmds.rs:2636-2641` stores `strncpyz_string(...)` into it. `qcommon/parms.rs:18` keeps `parm: [[c_char; MAX_PARM_STRING_LENGTH]; MAX_PARMS]` and writes a row with `write_cstr_field`. jka-rust has no generated accessor, so it gives no form for the list question.

Types. `lookup.py parms_t parm` gives `parm: Slots<String>` and `lookup.py level_locals_t teamVoteString` gives `teamVoteString: Slots<String>`. Neither answer names the `Buffers` accessor, and `lookup.py parms_t parmBuffers` answers "parms_t has no field parmBuffers". A `char[N]` field shows both accessors, `lookup.py clientPersistant_t netname` gives `netname: String`, `netnameBuffer: JKAShared.CharBuf`. The cause is that the generator run of phase 1 did not run `rosetta.py`, which writes the stones under `.claude/rosetta/` that `lookup.py` reads. `rosetta.py:38-64` reads every accessor line that `views.py` gives, so a run lists the new accessor. The same stale stones still give `Slots<Slots<Float>>` for the five vector fields that generator item 3 moved to `Slots<JKAShared.vec3_t>`, for example `.claude/rosetta/gNPC_t.md:104` `enemyLaggedPos` and `.claude/rosetta/Vehicle_t.md:33` `m_vMuzzlePos`.

Helpers and guide. `docs/transcription.md:166-169` gives the `nameBuffer` form for every `char name[N]` field that Raven passes to a non-const `char *` parameter, with no list. No guide line names the row form `nameBuffers`.

Verdict: Premise true. Choice confirmed. The `char[N]` accessor has no list, the two game fields are the only two, and both have a Raven write through a `char *` callee, so a list would hold the same two names. Two amendments go with the ruling. First, the guide gains one sentence after line 168: "A record's `char name[M][N]` field gets a `nameBuffers` accessor, a `Slots<CharBuf>` with one buffer per row, so a body writes `Com_sprintf(&level.teamVoteStringBuffers[cs_offset], MAX_STRING_CHARS, "clientkick %s", arg2)`." Second, the coordinator runs `rosetta.py` once, so `lookup.py` shows `parmBuffers`, `teamVoteStringBuffers`, and the five `vec3_t` retypes to the transcriptors. One more fact for the coordinator: the R4 hand change at `g_cmds.swift:2233-2240`, the two `CharBuf(1024)` locals that the R4 verdict let stand "until H3 lands", is in no unit of Part A. H3 has landed, so the change is due.

### V24. What does the R7 drafter rule need before a `gentity_t *` local drafts as a plain `Entity`?

Source. `rulings-build-generators.md:88`, Unruled: the rule needs an initializer that is a slot address, a local with no initializer stays `Entity?`, and a compare with a non-NULL value and a return count as non-NULL reads. The change is drafter item 2 at `rulings-build-generators.md:27`.

Sites. `tools/oracle-closure/draft_declarations.py:409-412` writes `let <name> = <init>` when `init and record == "gentity_t" and self.plain_entity(var, init[0])`. `plain_entity` at `:440-480` returns false unless the initializer is a slot address (`slot_address`, `:425-438`, Raven's `&table[n]` of a file-scope `CONSTANTARRAY`). It then walks every reference of the local. A member access, a call argument, a `return`, and the initializer of another local pass. A store `local = x` passes only when `x` is a slot address. A store `other = local` passes. A compare `==` or `!=` passes when neither side is NULL. Every other parent, `!ent`, `if (ent)`, `ent && ...`, `&ent`, or a step, fails the rule. `draft_classification.py:690-691` then treats the name as never nil, and `bodies.py:168` and `:243` hold the set.

Raven. The R7 proof (`docket-proofs-R.md:94-102`) measured 136 sites of the form `let <name>: Entity? = g_entities[...]`, and each one has an initializer, for example `w_force.c:3636` `gentity_t *vehEnt = &g_entities[...]` and `w_force.c:1572`. A grep today gives 142 lines of `(let|var) <name>: Entity? = g_entities[` in `Sources/JKAMP_GameLogic`, and 166 lines of `gentity_t *x = &g_entities[` in Raven's game files. Raven also writes 200 statement stores of the form `x = &g_entities[...]`, for example `ai_wpnav.c:1745` `ent = &g_entities[i];` inside a loop, into locals with no initializer. Many of those locals also take a NULL store or a NULL test, and the rest are outside the rule.

jka-rust. `w_force.rs` reads a raw pointer with no test at the R7 site, as the R7 proof records. jka-rust has no drafter and gives no form for the initializer question.

Types. `g_entities` is `Slots<Entity>` (`g_main.swift:28`), so the subscript never gives nil. The current text of the proof's site is `w_force.swift:1220`, `let vehEnt: Entity? = g_entities[g_entities[tr.entityNum].client!.ps.m_iVehicleNum]`, with `vehEnt!` reads at `:1221-1224`.

Helpers and guide. No guide line gives the plain `Entity` local. Guide lines 434-436 give an `Int32` index local for a record pointer that the body steps over a table, which covers the walked loop locals. Swift's definite-initialization check refuses a read of a `var x: Entity` that a path can reach before a store, for example a read after a `for` loop whose body holds the only store, and a plain `let` that a loop stores twice.

Verdict: Premise true. Choice confirmed. The ruling text is "a local whose every store is a table slot address, with no NULL store and no NULL test", and every one of the 136 proven sites has a slot-address initializer, so the initializer test loses no proven site. A local with no initializer needs a dominance test before a plain `Entity` is safe from the definite-initialization error, and the drafter has no such test. The return and the non-NULL compare are reads that cannot see NULL, so they belong in the pass list. The locals with no initializer stay `Entity?`, and their unwraps cannot trap, because each store is a slot. A later row can extend the rule to them.

### V25. How does the O2 drafter rule test that no read reaches a NULL store before the allocator store?

Source. `rulings-build-generators.md:89`, Unruled: the test is by source offset. Every NULL store comes before the first allocator store, no read of the local stands between a NULL store and that allocator store, and a NULL initializer on the declaration fits the same way.

Sites. `tools/oracle-closure/draft_classification.py:361-410`, `charbuf_alloc_names`, collects the NULL stores, the allocator stores, and the reads of each `char *` local by extent offset. It drops a local when `null > first` or when a read stands at an offset between a NULL store and the first allocator store. `draft_statements.py:556-560` writes the comment for a NULL statement store, and `draft_declarations.py:327-334` writes the comment for a NULL initializer.

Raven. `CHARBUF_ALLOCS` at `rulings.py:204` holds `B_TempAlloc` alone. Raven stores a `B_TempAlloc` result into a `char *` local at 11 lines of `ai_util.c` and `ai_wpnav.c` (`ai_util.c:362`, `:621`, `:654`, `:655`, and `ai_wpnav.c:30`, `:2021`, `:2041`, `:2042`, `:2391`, `:2415`, `:2416`). A grep for a NULL or 0 store into any of those locals gives one line, `ai_wpnav.c:2382` `fileString = NULL;` in `SavePathData`. That function is straight-line code from the NULL store at `:2382` to the allocation at `:2415`, with two early returns between them and no loop, no `goto`, and no read of `fileString`.

jka-rust. `ai_wpnav.rs:2349` onward, `SavePathData`, has no NULL store. It builds `file_string` with `format!` at its first value and keeps the `B_TempAlloc` call for the pool count.

Types. The Swift site `ai_wpnav.swift:2125-2140` is still the hole at `:2127-2129` (`// Port-note: A pointer local `char * fileString` with no view.`) and `:2138-2140` (`// Port-note: A store into `fileString`, ...`). The hole round of Part B fills it with the draft that `bodies.py --stem ai_wpnav --only SavePathData` prints, `var fileString = CharBuf(524288)` and the comment line.

Helpers and guide. Guide line 709 gives the `CHARBUF_ALLOCS` form, and the O2 ruling at `frame-path-walk.md:60` gives the drop of the NULL store under one comment.

Verdict: Premise true. Choice confirmed. A source offset is the control order only in code with no loop and no backward jump between the NULL store and the allocation. The one site that the rule matches today meets that condition, and the allocator list holds one name. The test does not prove the order for a loop or a branch. A later `CHARBUF_ALLOCS` entry whose local takes a NULL store inside a loop needs a new row before the drafter takes it.

### V26. Do the drafter changes need a `draftcheck.py` run and a `snapshot.py --check` before they count as done?

Source. `rulings-build-generators.md:90`, Unruled: no `snapshot.py --check` and no `draftcheck.py` ran, because the brief named neither. `review-rulings-build-1.md:92`, unruled 7, repeats it.

Sites. The three drafter rules of `rulings-build-generators.md:26-28` (R3, R7, O2) change the draft of every stem with a narrow local array, a slot-address `gentity_t *` local, or a NULL `char *` store. The R7 rule alone moves the drafts of the 136 sites of its proof.

Guide and tools. `tools/oracle-closure/README.md:43`: "A change to a tool module runs `snapshot.py --check` against a snapshot of the code before the change, and the change moves no printed byte unless it means to." `docs/oracle-closure.md:16` names `draftcheck.py` as the compile gate of the drafts, with the reference "1357 holes, 0 defects, and 224 compile holes over the 75 game stems". `docs/oracle-closure.md:90` gives the snapshot gate. The ruling of 2026-10-08 (the builder gates once at the end) puts the full draftcheck and the snapshot check once after the last item, as separate foreground calls, with the counts in the record. `HANDOFF.md:37` lists the snapshot refresh and the full `draftcheck.py --game` reference as housekeeping the user has not asked for.

State. The reference snapshot at `$HOME/.cache/jka-swift/snapshot-stage-two-shared` was written at c82143f (`notes/2026-10-09/snapshot-refresh.md`). Six commits since then touch `tools/oracle-closure`: b2f2b40, 3a10ea1, 303824b, 34e7f5b, 0f8d191, 4117a09, and then 7728fd9. So a check against that folder mixes the moves of phase 1 with the moves of the six earlier commits.

Raven and jka-rust. Not applicable.

Verdict: Premise true. Choice amended. The README rule orders the snapshot check for every tool module change, so "the brief named neither" does not excuse the run. The wave of Part B fills holes whose drafts these three rules moved, so the runs go before that wave. The form is two steps, each one foreground call, with the counts written into `notes/2026-10-11/`. Step 1 is `draftcheck.py` over the game stems as five `--stem` calls of 15 stems, against the reference of 1357 holes, 0 defects, and 224 compile holes. Step 2 is `snapshot.py --check $HOME/.cache/jka-swift/snapshot-stage-two-shared`, and the record sorts each moved file into the three rules of phase 1 or the six earlier commits, then refreshes the folder by `snapshot-refresh.md`. A defect that step 1 finds is recorded as a row, not fixed in the same round.

### V27. Does the change of row X1 in `notes/2026-10-09/load-test-walk.md:73` from "open" to "ratified as proposed" stand?

Source. `review-rulings-build-1.md:72`, finding 4: "No row of the frame-path docket orders it, and no record of 2026-10-11 names the ruling. The line belongs to the records commit, not to the code commit of phase 1."

Sites. `notes/2026-10-09/load-test-walk.md:73`, `| X1 | ratified as proposed | The `FRAMES` knob of `tools/load-test.sh`, ... |`. The change landed in the records commit a1b6196, and its body says "The row X1 is closed in notes/2026-10-09/load-test-walk.md." The knob itself landed at 9ac7d31, `tools/load-test.sh:6`, `:16`, `:18`, and `:41`. `notes/2026-10-09/load-test.md:538` raised X1 as a docket row.

The ruling. The session transcript `e9b8bbbb-e306-4836-9af3-205103490dfd.jsonl` holds the coordinator message of 2026-10-11 14:08:46 UTC that ends with "X1. The `FRAMES` knob of `tools/load-test.sh`. ... The proposed form is the one in the script: an environment variable, default 0, ..." and "Row 1 of 69 open.". The user typed "ratified" at 14:10:51 UTC. The next message reads "X1 is closed as ratified as proposed, recorded in the load-test walk." The ledger of 14:31:52 UTC lists "X1 | ratified as proposed | 2026-10-11". A grep of `frame-path-walk.md` and `frame-path-round.md` finds no X1 line.

Raven and jka-rust. Not applicable.

Verdict: Premise partly true. The user ruled X1 on 2026-10-11 by a typed "ratified", so the verdict text is right. The finding is true that no dated record of 2026-10-11 names the ruling. Choice confirmed: the line stands, and it is already in the records commit, not in the code commit. One amendment: the walk record of this docket names the X1 ruling and its date in one row, so the ledger of 2026-10-11 holds it.

### V28. Do the sig table and the compiled code disagree until phase 2 for `SortRanks`, `SortClients`, and `G_Find`?

Source. `review-rulings-build-1.md:87` (unruled 2) and `:88` (unruled 3).

Sites at a1b6196. `g_main.swift:1648` `func SortRanks(_ a: OpaquePointer?, _ b: OpaquePointer?) -> Int32 {`, `g_team.swift:1065` `private func SortClients(_ a: OpaquePointer?, _ b: OpaquePointer?) -> Int32 {`, and `g_utils.swift:270` `func G_Find(_ from: Entity?, _ fieldofs: KeyPath<Entity, String?>, _ match: String) -> Entity? {`. The table at the same commit gives `func SortRanks(_ a: Int32, _ b: Int32) -> Int32` (`.claude/manifest/g_main.md:29`), `private func SortClients(_ a: Int32, _ b: Int32) -> Int32` (`.claude/manifest/g_team.md:39`), and `_ match: String?` for `G_Find` (`rulings.py:329-331`).

Sites now. The wave has changed all three. `g_main.swift:1648` reads `func SortRanks(_ a: Int32, _ b: Int32) -> Int32 {`, `g_team.swift:1065` reads `private func SortClients(_ a: Int32, _ b: Int32) -> Int32 {`, and `g_utils.swift:270` reads `func G_Find(_ from: Entity?, _ fieldofs: KeyPath<Entity, String?>, _ match: String?) -> Entity? {` with `if Q_stricmp(s, match) == 0 {` at `:291`. `lookup.py sig` gives the same three signatures, with a staleness warning for 25 changed stubs.

Raven and jka-rust. Not applicable to the question. The rulings A1, D6, and R9 give the forms.

Verdict: Premise true. Choice confirmed. The table and the code disagreed from 7728fd9 to the phase 2 wave, and units A-29, A-38, and A-40 close the gap. The working tree now agrees with the table on all three signatures. The coordinator runs `skeleton.py` and `manifest.py` with the gate of the wave, which clears the staleness warning of `lookup.py`.

### V29. Does the phase 1 commit carry the manifest changes from earlier commits?

Source. `review-rulings-build-1.md:89`, unruled 4.

Sites. `git show --stat 7728fd9` lists 64 files under `.claude/manifest/`. The diff holds `public` markers that 303824b put on the hand code, for example `public func CP_FindCombatPointWaypoints()` and `public func BotAIStartFrame(_ time: Int32) -> Int32`, and shifted Swift lines, for example `srand` from `bg_lib.swift:155` to `:171`. The last manifest commit before phase 1 is f5bef7e. The body of 303824b names its hand edits and does not name a manifest run.

Guide and tools. `docs/oracle-closure.md:14` says that `manifest.py` writes the tables, and every manifest file says "Generated by tools/oracle-closure/manifest.py ... Do not edit." A generated file is the plain output of its generator, so a run writes every change since the last run.

Raven and jka-rust. Not applicable.

Verdict: Premise true. Choice confirmed. The commit is made, and the manifests are the plain output of one run of `manifest.py`. A partial commit of the output would leave the table false for the files that 303824b and the later commits changed. The body of 7728fd9 says "the manifest run moved 64 manifest files", and the review record names the carried changes, so no further record is due.

### V30. Does `HANDOFF.md` stay untracked at the root until phase 2 is committed and reviewed?

Source. `review-rulings-build-1.md:90`, unruled 5: "`HANDOFF.md` at the root is untracked and is not part of phase 1."

Sites. `git ls-files HANDOFF.md` lists the file. `git show --stat a1b6196` adds it, 53 lines, in the records commit of phase 1, and the body of a1b6196 says "HANDOFF.md at the root is the resume plan." The code commit 7728fd9 does not hold it. `HANDOFF.md:3` reads "Delete it when the rulings build of the frame-path docket is committed and reviewed, after task 2 below." Its working copy is dated 10:14 and the commit is dated 10:36.

Raven and jka-rust. Not applicable.

Verdict: Premise false. The file is tracked since a1b6196, so it does not stay untracked. The proposed answer is true only in its first half: the file stays out of the phase 1 code commit. Choice amended: `HANDOFF.md` stays tracked at the root as the resume plan, and the session removes it with `git rm HANDOFF.md` in the records commit of phase 2, after the review of phase 2, as its line 3 says. Tasks 3 to 5 of the file then have no plan at the root until the user asks for a new handoff.

### V31. Does the R3 drafter rule take every local array of `short`, `unsigned short`, `signed char`, or `unsigned char`, or only `byte`?

Source. `review-rulings-build-1.md:91`, unruled 6: "`narrow_array_names` takes every local array of `short`, `unsigned short`, `signed char`, or `unsigned char`, not only `byte`."

Sites. `tools/oracle-closure/draft_declarations.py:591-601`, `narrow_array_names`, keys a local `CONSTANTARRAY` whose element type passes `types.narrow`. `spelling.py:157-160` reads `NARROW` from `reexport.py:55`, `{TypeKind.SHORT, TypeKind.USHORT, TypeKind.SCHAR, TypeKind.UCHAR}`, with the storage names of `reexport.py:47-51`, `Int16`, `UInt16`, `Int8`, and `UInt8`. `byte` is a typedef of `unsigned char`, so it is `UCHAR` in this set. The scalar form `narrow_local_names` at `:579-589` and the view setters read the same set. Plain `char` (`CHAR_S`) is not in the set, so a `char` array stays a `CharBuf`.

Raven. A grep of the game files for a local array of `short`, `unsigned short`, `signed char`, `unsigned char`, or `byte` gives only `byte` arrays: `g_svcmds.c:66`, `:67`, `:111`, `:136`, `:280`, `:304`, `ai_wpnav.c:1009` `extendednodes`, and `q_shared.c:243` `swaptest`. So today the wider set drafts no array that the `byte` set would not draft.

jka-rust. `g_svcmds.rs:46-47` declares `let mut b = [0u8; 4];` and `let mut m = [0u8; 4];`, the narrow element.

Helpers and guide. `docs/transcription.md:528` names the four narrow types, `short`, `unsigned short`, `signed char`, and `unsigned char`, and line 530 says "A fixed array of a narrow type keeps its element type." Lines 531-532 give the store truncation and the read widening.

Verdict: Premise true. Choice confirmed. The guide line 530 rule covers every narrow type, and the drafter reads the one `NARROW` set that the view setters and the scalar locals read. A `byte`-only list would be a second set for one concept. The proof names `byte` because the only Raven sites are `byte` arrays, and the wider rule moves no draft today.

### V32. Which form does `attDelay += floor( ... )` at `NPC_combat.c:134` take, and what is the exact Swift line?

Source. `phase-2-plan.md`, Part A note 3, for unit A-24.

Sites. `Sources/JKAMP_GameLogic/NPC_combat.swift:130` in `G_AttackDelay`, at a1b6196 and now: `attDelay = Int32(Float(attDelay) + floor((_DotProduct(fwd, dir) + 1.0) * 2000.0)) //add up to 4000ms delay if they're facing away`.

Raven. `NPC_combat.c:122` declares `int attDelay;`, and `:134` reads `attDelay += floor( (DotProduct( fwd, dir )+1.0f) * 2000.0f );//add up to 4000ms delay if they're facing away`. `DotProduct` is float math (`q_shared.h:1358`, `:1376`), and `1.0f` and `2000.0f` are float literals, so the argument is a `float`. `floor` is `double floor( double x )` (`bg_lib.h:61`, `bg_lib.c:305`, and the libc of the DLL build). So C widens the argument to `double`, computes `(double)attDelay + floor(...)` in double, and truncates once at the store. The dot product of two unit vectors is in -1 to 1, so the floor value is an integer from 0 to 4000, and `attDelay` is an integer from 1000 to 2000 before the add. Every value is exact in `Float` and in `Double`, so the present line and the C line store the same integer.

jka-rust. `NPC_combat.rs:226`: `attDelay += ((dot + 1.0) * 2000.0).floor() as c_int;`, an `f32` floor, a cast to `c_int`, and an integer add. That is a third form with the same result in this range.

Types. `lookup.py sig G_AttackDelay` gives `func G_AttackDelay(_ `self`: Entity, _ enemy: Entity)`. `_DotProduct` returns `vec_t`, a `Float` (`q_math.swift:899`). `Sources/JKAShared/Promotion.swift` defines `Int32` and `Float` operators and no `Int32` and `Double` operator.

Helpers and guide. Line 554 (N1): "A compound store into an `int` from a `float` is `x = Int32(x op f)` over the `Promotion.swift` operator, with no `Float(x)`". The right side here is a `double`, not a `float`, so the N1 sentence does not name this site. Line 548: "a body writes `Double(...)` on each operand at the operator where it meets the double operand". Line 550: "A C library call that takes and returns `double` inside that expression takes its arguments in `Double` too, `Int32(ceil(Double(dropTime) * 1000.0))`". Line 551 says that this is the one place a body writes a conversion Raven did not write. Two sites in the tree already take the line 550 form, `g_combat.swift:2418` `save = Int32(ceil(Double(damage) * ARMOR_PROTECTION))` and `NPC_spawn.swift:1774`.

Verdict: Premise true. The present line takes neither form: it writes a `Float(attDelay)` that N1 forbids, and it calls the `Float` overload of `floor` where C calls the `double` one. The behavior is the same in this range, so the change is one of form. Form amended: the double rule governs, inside the N1 shape `x = Int32(x op f)`. The `int` operand meets a `double` operand, so it widens to `Double` by line 548, and the float argument of `floor` widens by line 550. The line reads:

```swift
attDelay = Int32(Double(attDelay) + floor(Double((_DotProduct(fwd, dir) + 1.0) * 2000.0))) //add up to 4000ms delay if they're facing away
```

N1 needs no new sentence, because its "no `Float(x)`" names the float case and line 551 allows the `Double` conversion.

### V33. Do the eight `G_Find` callers that force-unwrap another `String?` field take the R9 form or keep the `!`?

Source. `phase-2-plan.md`, Part A note 5. The R9 verdict (`docket-proofs-R.md:126`, ruled at `frame-path-walk.md:83`) names the `x.target!` callers and makes `match` a `String?`.

Sites. A grep of `Sources/JKAMP_GameLogic` for `G_Find(` with a `!)` argument now gives these eight lines and no other. The `.target!` and `.target2!` callers are already changed by the wave.

1. `g_client.swift:700`, `SelectRandomFurthestSpawnPoint`: `while let next = G_Find(spot, \.classname, classname!) {`. Raven `g_client.c:679`: `while ((spot = G_Find (spot, FOFS(classname), classname)) != NULL) {`.
2. `g_saga.swift:1497`, `SiegeItemUse`: `let targ = G_Find(nil, \.targetname, ent.paintarget!)`. Raven `g_saga.c:1615`.
3. `ai_wpnav.swift:1565`, `GetObjectThatTargets`: `next = G_Find(next, \.target, ent.targetname!)`. Raven `ai_wpnav.c:1724`.
4. `g_mover.swift:1261`, `G_FindDoorTrigger`: `while let next = G_Find(owner, \.target, door!.targetname!) {`. Raven `g_mover.c:1253`.
5. `g_mover.swift:1268`, `G_FindDoorTrigger`: `while let next = G_Find(owner, \.target2, door!.targetname!) {`. Raven `g_mover.c:1261`.
6. `g_mover.swift:1306`, `G_EntIsUnlockedDoor`: `while let next = G_Find(owner, \.target, ent!.targetname!) {`. Raven `g_mover.c:1304`.
7. `g_mover.swift:1316`, `G_EntIsUnlockedDoor`: `while let next = G_Find(owner, \.target2, ent!.targetname!) {`. Raven `g_mover.c:1315`.
8. `g_utils.swift:563`, `G_UseTargets2`: `while let next = G_Find(t, \.targetname, string!) {`. Raven `g_utils.c:584`.

NULL at each site. At none of the eight sites can the text be NULL in Raven's code. Site 1: `g_client.c:670-678` declares `char *classname = NULL;` and stores a string literal on both arms of `if ( team == TEAM_RED )` before the loop. Site 2: `g_saga.c:1613` tests `if (ent->paintarget && ent->paintarget[0])`. Site 3: `ai_wpnav.c:1719` returns on `if (!ent->targetname)`. Sites 4 and 5: `g_mover.c:1250` tests `if ( door->targetname )`, and nothing between the test and the loops stores the field. Sites 6 and 7: `g_mover.c:1300` tests `if ( ent->targetname )` the same way. Site 8: `g_utils.c:579` returns on `if ( !string || !string[0] )`. So no `!` of the eight can trap, and Raven's `G_Find` never sees a NULL `match` from them.

jka-rust. `G_Find` at `g_utils.rs:262-267` takes `r#match: &str`, never an `Option`. Each caller binds the text under Raven's own test. Sites 4 and 5: `g_mover.rs:1610`, `if let Some(door_targetname) = (*door).targetname_str()`. Sites 6 and 7: `g_mover.rs:1676`, `if let Some(ent_targetname) = ...`. Site 2: `g_saga.rs:2032`, `if let Some(paintarget) = paintarget.as_deref().filter(|s| !s.is_empty())`. Site 3: `ai_wpnav.rs:1742`, `let Some(targetname) = ctx.entity(ent).targetname_str() else { ... }`. Site 1: `g_client.rs` passes a `&str` literal. Site 8: `g_utils.rs:715` passes the `string` that the early return has bound. jka-rust unwraps at every site, through the bind that Raven's test gives.

Types. `lookup.py gentity_t targetname`, `paintarget`, and `classname` each give `String?`, "Optional, nil for a NULL pointer". `lookup.py sig G_UseTargets2` gives `_ string: String?`. `lookup.py sig G_Find` gives `_ match: String?`. None of these fields is in the `NEVER_NULL` table of guide lines 333-335, so the fields stay optional.

Helpers and guide. Line 338 writes the force unwrap only where "a caller that holds an optional and passes it where a value is due", and the parameter is now a `String?`, so no value is due. Line 341 says that a later read of an optional text local unwraps it, which is a read that needs a value. The nil-safe `Q_stricmp(_ s1: String?, _ s2: String?)` in JKAShared, which the R9 ruling ordered, takes the `match` with no unwrap. Line 343 makes a guard that Raven wrote the only source of a bind, so the jka-rust bind is legal Swift too, but it would add a nesting level that the R9 form does not need.

Verdict: Premise true: the eight sites exist at the lines above, and each passes a force-unwrapped `String?` to the `String?` parameter. Choice amended: the eight take the R9 form and drop the `!`, because line 338 orders the unwrap only where a value is due, and the R9 site already reads the same way. The behavior does not change, because Raven's test above each call keeps the text non-NULL. The lines read:

```swift
while let next = G_Find(spot, \.classname, classname) {
let targ = G_Find(nil, \.targetname, ent.paintarget)
next = G_Find(next, \.target, ent.targetname)
while let next = G_Find(owner, \.target, door!.targetname) {
while let next = G_Find(owner, \.target2, door!.targetname) {
while let next = G_Find(owner, \.target, ent!.targetname) {
while let next = G_Find(owner, \.target2, ent!.targetname) {
while let next = G_Find(t, \.targetname, string) {
```

The `door!` and `ent!` unwraps stay, because they read a view where a value is due. Line 338 gains one sentence so the next caller of an optional parameter takes the same form: "A caller passes an optional to a parameter that takes the optional as it holds it, with no force unwrap, ``G_Find(t, \.targetname, `self`.target)``." The g_mover, g_utils, and g_client sites are in the files of the find transcriptor and of Part B, and `g_saga.swift` and `ai_wpnav.swift` belong to the bot-items transcriptor, so the coordinator gives the change to those owners or to one unit after the wave.
