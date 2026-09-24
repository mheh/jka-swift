# Drafter analysis of 2026-09-23

This note records a review of the drafter in tools/oracle-closure at commit 13c30a4. The question was where the Swift the drafter emits behaves differently from Raven's C at run time, and where the drafter's own control flow makes output a reader does not expect. Six review agents each read one slice of the drafter against a full dump of all 87 stems. Every line number below is at 13c30a4. The C line numbers point into oracle/codemp/game.

Nothing here is built. Each finding waits for a ruling. The section "Proposed rows" at the end lists the rows a docket walk would take.

## Method and evidence

The corpus is a dump of every stem's draft, every Port-note, and every crash. The scripts sit in notes/drafter-analysis-2026-09-23/ and expect the corpus under /tmp/jka-analysis.

To regenerate the corpus, run from tools/oracle-closure:

```
mkdir -p /tmp/jka-analysis/drafts
.venv/bin/python ../../notes/drafter-analysis-2026-09-23/dump.py 2>/tmp/jka-analysis/stderr.txt
```

The dump writes drafts/<stem>.swift for each stem, holes.tsv with one row per Port-note (stem, function, note text, next line), crashes.txt, and summary.tsv (stem, function count, hole count). At 13c30a4 the dump gives 87 stems, 1626 Port-note rows, 1265 counted holes, and 3 crashes.

The other scripts:

- analyze.py groups the Port-notes by reason and joins each cascade to its origin hole.
- cascades.py, false_casc.py, and protos.py measure the cascade cost and the prototype-name gap over the corpus.
- q1.py and q1b.py list the parse diagnostics and count function bodies per file against the C text.
- q2.py checks the never-null proof against the literal, local, and passed-on NULL sources.
- q3.py finds the facts keyed by a bare name that collide.
- q4.py lists the NULL-fold notes in the gate stems.
- inout-probe.swift and inout-writeback.swift are the two compiled probes that show the twice-inout loss. Build each with `swiftc -O` and run it.

## The control flow of the tool

1. **Parse.** closure.py:232-248 parses three units one time each: a unity unit of codemp/game/*.c, a unity unit of codemp/cgame/*.c, and a headers unit the views read. The overlay (overlay.py:56-58) sits after q_shared.h, declares the 17 vector macros as functions, and undefines memset, memcpy, strcpy, and strcat. parsed_bytes (closure.py:123) gives the bytes the cursor offsets index.
2. **Skeleton.** skeleton.py:161-186 builds the Table, runs Table.sweep, and then collect (193-204) walks the game unit only. It owns files, by_name (the first stem wins, line 204), shared_names, and sources. map (206) shapes each parameter through Table.param, which reads nullable (table.py:1191).
3. **Sweeps, in this order.** Table.sweep (table.py:1137-1165) runs the game unit over the game folder for sweep_nulls (443), sweep_subscripts (974), sweep_handoffs (1004), and sweep_buffer_traps (1074). It runs the cgame unit over the game and cgame folders for nulls, subscripts, and handoffs, then resolve_handoffs (1048), then the cgame buffer traps. It runs the game unit over the game folder only for sweep_stores (478), sweep_text (607), sweep_cursors (655), sweep_returns (1114), and sweep_reads (300, bg stems only). locals_of (819) runs sweep_locals (831) lazily on the first draft of each function and sets written, addressed, and single_writes, keyed by (stem, function) with bare local names as values. Only the NULL, subscript, handoff, and buffer facts see the cgame callers.
4. **Registry.** bodies.py:72-121 scans Sources/*.swift with regexes and keys params, returns, overloads, homes, and var_types by the bare Swift name. The first file in rglob order wins.
5. **Drafter state.** bodies.py:128-159 holds the per-drafter fields that never reset: holes, hole_names, logical_tails, and reads. draft (163-215) resets the per-function fields and runs the pre-scans for raw locals, text locals, cursors, Slots locals, and chosen locals. pending resets per statement (draft_statements.py:154-161). call_kinds and call_format save and restore per call. leaf_wrap saves and restores per expression. aliased_positions and slot_copies reset to empty after each call, not to the outer value.
6. **The walk.** block_body (draft_statements.py:24) calls statements (33). For each child it writes the parameter copies, Raven's gap lines, and the hoisted reads, then opens scratch (draft_declarations.py:52), choice (100), or labeled (59), or it calls statement. A scratch or a choice takes the rest of the block as its body, so the walker returns early.
7. **The hole boundary.** statement (draft_statements.py:153-162) saves pending, calls statement_lines, catches a Hole, puts pending first, and restores the outer pending. statement_lines (233-475) dispatches on the cursor kind. expr (draft_expressions.py:267-456) dispatches on the expression kind. The call path is call (draft_calls.py:65), then macro_call (160) or the reach and alias checks (78-83), then callee_params, then argument (186) per argument. The declaration path is declarations (draft_declarations.py:248), which catches a Hole per VAR_DECL (257), then declaration (265) and array_declaration (392).
8. **Raise and catch.** The five modules have 77 raise sites. Two places catch a Hole: draft_statements.py:158 and draft_declarations.py:257. Seven pre-scans swallow a Hole as "no answer": draft_classification.py:159, 226, 280, draft_calls.py:404, draft_declarations.py:214, 240, and draft_expressions.py:653. Only draft_declarations.py:258-262 and draft_classification.py:291-299 count a hole and add a local to local_holes. Five sites write a Port-note with no hole: draft_calls.py:220, 228, 290, draft_statements.py:592, and draft_expressions.py:226 and 359.

The judgement of that structure:

- The hole boundary at the statement is too coarse. One Hole inside a leaf discards the whole statement with its nested blocks and else arms, and hole() (draft_classification.py:292-293) adds every VAR_DECL of the subtree to local_holes by bare name. Every later read (draft_expressions.py:489-491) or store (draft_statements.py:344-345) of that name is then a cascade. 197 holes cover compound statements that hold 1065 of Raven's statements.
- The notes that count no hole are the dangerous class. 374 of the 1626 notes count nothing, and 226 of them change behaviour: the loop step note (142) and the NULL folds (84). The gate's zero rests on this.
- The operator token scan (binary_op at draft_expressions.py:627, unary_parts at 659-660) reads the bytes between the child extents. Inside a macro expansion both children map to the expansion site, so the text between them is empty. macro_span (97-99) accepts only a node whose text is one identifier, so random() and FOFS(x) never match. This is the whole source of the 261 operator notes.
- The never-null proof (table.py:466-469) marks a parameter nullable only when an argument's bytes are NULL or 0 at a direct call. The value-typed vector, axis, and out-scalar rules (spelling.py:236, 244, 256, 325) do not read nullable at all. Proof and rule are not joined.
- Facts keyed by bare names hold today with no drafted line changed: 16 functions redeclare a name (table.py:819-853, 907-949 merge the counts), 9 static function names across the vehicle files merge their facts (table.py:461-468, 503-504), and pm matches by spelling (draft_classification.py:456, 514).
- hole_names (draft_classification.py:292, draft_declarations.py:259) is never cleared across functions. draftcheck.py:119 reads it, so a real "cannot find" error in one function counts as a cascade when any other function of the stem holed the same name. This changes the gate count, not the draft.

## Findings, ranked

Each finding gives the rule, one site with Raven's C and the drafted Swift, the run-time difference, and the count over the corpus.

### 1. A `continue` in a rewritten `for` loop skips the step, and the loop hangs

Rule: draft_statements.py:591-596 writes the step after the body and a note, not a hole.

Site: bg_saberLoad BG_SI_SetLengthGradual, bg_saberLoad.c:2289. C: `for (i = 0; i < saber->numBlades; i++) { ... if (saber->blade[i].length == dLen) { continue; } ... }`. Draft: `while i < saber.numBlades { ... if saber.blade[i].length == dLen { continue } ... i += 1 }`.

Run time: `i` does not advance, so the same pass repeats forever. A `continue` inside a switch inside such a loop drifts the same way, and a comma step is skipped the same way.

Count: 142 notes. About 135 have a bare `continue` that targets that loop, and 133 of those have a unit step. 7 belong to a nested loop. Gate sites, 6 in 3 stems: PM_SetVehicleAngles (bg_pmove.c:391) hangs on every call at `i == YAW`; PM_SlideMove (bg_slidemove.c:487, 571, 591, 630) hangs on the first surface contact, when `into >= 0.1` continues past the velocity plane; BG_SI_SetLengthGradual.

Fix clause: make the site a hole, or emit the step before each `continue` of that loop.

### 2. A member path passed twice by `&` loses the callee's write

Rule: draft_calls.py:137-141. aliased_inouts matches only a DECL_REF_EXPR, so the copy form at draft_statements.py:452-458 never fires for `pm->ps->velocity`. Swift accepts the call because the view setters are nonmutating.

Site: bg_slidemove PM_StepSlideMove. C: `PM_ClipVelocity( pm->ps->velocity, trace.plane.normal, pm->ps->velocity, OVERCLIP );`. Draft: `PM_ClipVelocity(&pm.ps.velocity, &trace.plane.normal, &pm.ps.velocity, OVERCLIP)`.

Run time: Swift reads each inout into its own temporary and writes them back last in, first out. The unchanged in-copy is written last, so the clip is lost. Both probes in the notes folder show the velocity unchanged with `-O` and `-Onone`. The hand port at Sources/JKAMP_BG/bg_pmove.swift:2460 and 2797-2801 copies through explicit in and out locals.

Count: 8, all in gate stems. bg_pmove.c:2548, 2839, 2911, 2912, 3017 (PM_WaterMove, PM_AirMove, PM_WalkMove, with pml.forward and pml.right). bg_slidemove.c:462, 812, 824. The corpus has no other call that passes one path twice by `&`.

Fix clause: extend aliased_inouts to member paths, with in and out copies and a write-back.

### 3. A narrow C integer local loses its truncation

Rule: draft_declarations.py:374-375 and 400-401 spell a `short` or `byte` local and a narrow array local as Int32, and their stores do not truncate. The same at draft_expressions.py:592-593 (a narrow cast), spelling.py:351-353 (a parameter), and the return after spelling.py:389-391. docs/transcription.md covers only view fields, parameters, and returns.

Site: bg_pmove PM_UpdateViewAngles, bg_pmove.c:7814 and 7827. C: `short temp; temp = cmd->angles[i] + ps->delta_angles[i];`. Draft: `var temp: Int32` with the same sum. The hand port at Sources/JKAMP_BG/bg_pmove.swift:5570 and 5585 uses `Int16(truncatingIfNeeded:)`.

Run time: a command pitch of 63716 with a delta of 0 wraps to -1820 in C and does not clamp. The draft keeps 63716, passes `temp > 16000`, and sets the pitch to about 88 degrees down. Any upward look snaps the view down.

Count: 11 narrow scalar declaration lines and 7 narrow arrays in the C. The value changes at 3 live sites: this one, ai_main BotInputToUserCommand (ai_main.c:539, the same sum), and g_svcmds StringToFilter (`byte b[4]; b[i] = atoi(num)`, where "256" gives 0 in C and 256 in the draft). q_shared ShortSwap returns 32768 where C returns -32768.

### 4. The file-list tuple call keeps only the first file

Rule: draft_statements.py:164-181 and 354-357, with the trap's `String(nulTerminated:)` at Sources/JKAShared/Views/String+NulTerminated.swift:4.

Site: bg_vehicleLoad BG_VehWeaponLoadParms. C: `fileCnt = trap_FS_GetFileList(..., vehWeaponExtensionListBuf, sizeof(...))`. Draft: `let filled = ...`, `fileCnt = filled.0`, `vehWeaponExtensionListBuf = JKAShared.CharBuf(filled.1)`.

Run time: the list is NUL-separated. The String stops at the first NUL, and CharBuf(String) has a count of the length plus one. For files 2 to N the cursor `.text` past the end reads an empty string, so FS_FOpenFile fails with "error reading file". Only the first .veh, .vwp, .sab, .npc, .scl, .team, .arena, or .bot file loads.

Count: 8 sites. 5 in gate stems (bg_vehicleLoad x2, bg_saberLoad, bg_saga x2), then g_bot x2 and NPC_stats.

### 5. A scratch for a NULL output argument is not NULL

Rule: draft_calls.py:212-222. The note says "a scratch local it never reads", which is false for these callees. spelling.py:236, 244, 256, and 325 give a value type to a vec3, axis, or out-scalar parameter with no read of nullable, so the callee's NULL test folds to a comment even where the sweep proved NULL arrives.

Site: bg_slidemove PM_VehicleImpact. C: `G_Damage(pEnt, hitEnt, killer..., NULL, pm->ps->origin, ...)`. Draft: `var scratchDir = JKAShared.vec3_t(0, 0, 0)`, then `G_Damage(..., &scratchDir, &pm.ps.origin, ...)`.

Run time in G_Damage (g_combat.c): `if (!dir) dflags |= DAMAGE_NO_KNOCKBACK` never fires. The target gets pm_time and PMF_TIME_KNOCKBACK, damage_from becomes the zero vector, and DirToByte of zero goes into the event. A NULL point runs `targ->pos1 = point`. In the draft of G_Damage the arm stands as a "reads false" note at g_combat.swift:3836 of the corpus.

Second gate site: bg_pmove.c:865 `PM_SetVehicleAngles(NULL)` gets `&scratchNormal`. C takes the `else` branch with the view pitch and slower banking. The draft runs PM_pitch_roll_for_slope with a zero normal. Third: bg_g2_utils BG_AttachToRancor, where all 3 callers pass NULL for out_axis and the only arm they use is gone.

Count: 56 G_Damage calls (56 NULL dirs, 26 NULL points), 2 in gate stems, plus PM_SetVehicleAngles and BG_AttachToRancor. 23 (function, parameter) pairs are proven nullable and still value typed. AngleVectors, BG_ValidateSkinForTeam, NPC_ShotEntity, and G_KickTrace only skip a write, so their scratches are safe.

Fix clause: give nullable to each vec3, axis, and out-scalar rule.

### 6. An unsuffixed double literal computes in Float

Rule: draft_statements.py:431-435 widens to Double only when the target is Int32. draft_expressions.py:471-476 drops the `f` suffix only, so Swift types `0.001` as Float beside a Float. draft_expressions.py:346-351 clears the wrap inside call arguments. docs/transcription.md:410-412 states the Double rule for every float store, and the drafter does not follow it.

Site: bg_misc BG_EvaluateTrajectory, bg_misc.c:2363. C: `deltaTime = ( atTime - tr->trTime ) * 0.001;`. Draft: `deltaTime = (atTime - tr.trTime) * 0.001`.

Run time: C rounds the double product once. The draft multiplies by `0.001f`. The result differs on 2825 of the first 5000 millisecond values. With the TR_GRAVITY term at bg_misc.c:2400 and a base z of 100, z differs on 770 of 2000 values. A cgame that predicts with Raven's bg code disagrees with the server by these bits. NPC_spawn SP_NPC_Vehicle (NPC_spawn.c:2217) drafts `ceil(dropTime*1000.0)` as `Int32(Double(ceil(dropTime * 1000.0)))` with the product still Float, so dropTime 0.3 gives 300 where C gives 301. Swift also picks the Float `cos` at bg_misc draft line 907 where C calls the double one.

Count: about 490 C lines hold an unsuffixed floating literal in arithmetic or a comparison. The drafter widens 39, all Int32 stores. In bg_pmove and bg_misc the hand port widens 51 lines and the draft widens 4. The doc's own example, `drop += Float(Double(speed) * 0.1 * Double(pml.frametime))` at Sources/JKAMP_BG/bg_pmove.swift:670, drafts as `drop += speed * 0.1 * pml.frametime`.

### 7. No arithmetic in a draft wraps on overflow

Rule: draft_expressions.py:448 and draft_statements.py:444-445 write Swift's trapping `+`, `-`, and `*`, never `&+`, `&-`, or `&*`.

Site: q_math Q_rand, q_math.c:127. C: `*seed = (69069 * *seed + 1);`. Draft: `seed = (69069 * seed + 1)`. The hand port at Sources/JKAShared/q_math.swift:142 uses `&*` and `&+`.

Run time: C wraps. The draft traps for any seed of 31092 or more. PM_irand_timesync (bg_saber.c:14) seeds with `pm->cmd.serverTime`, so after 31 seconds of server time its first call traps.

Count: 4 functions. bg_lib rand (bg_lib.c:770) traps on its third call from seed 0, and Sources/JKAMP_BG/bg_lib.swift:161 is still a portMissing stub. flrand and irand (q_math.c:1445, 1465) spell holdrand as UInt because reexport.py:47-51 maps `unsigned long` to 64 bits where Rng.swift:20-23 rules 32, so the flrand draft traps on its second draw. The game C has no hash or checksum loop.

### 8. `%c` reaches a formatter that traps on it

Rule: draft_calls.py:297-320 builds the conversion map, but only the record `%s` branch (285-292) reads it. Format.swift preconditions on `%c`.

Site: bg_g2_utils BG_GetRootSurfNameWithVariant. C: `Com_sprintf(returnSurfName, returnSize, "%s%c", rootSurfName, 'a'+i)`. Draft passes `Int32(ascii: "a") + i`.

Run time: the call compiles in a gate stem and traps when it runs.

Count: 16 sites, 1 in a gate stem. No `%x`, `%u`, `%g`, length modifier, or zero-pad flag appears in the format calls.

### 9. A char array truth test as `.isEmpty`

Rule: draft_expressions.py:367-371 (the `!X` forms), draft_statements.py:682-684 (condition), and draft_expressions.py:439-440 (`== NULL`).

Site: bg_saga BG_SiegeFindTeamForTheme, bg_saga.c:1461. C: `bgSiegeTeams[i].name && !Q_stricmp(...)`, where the array test is always true. Draft: `!bgSiegeTeams[i].name.isEmpty && Q_stricmp(...) == 0`.

Run time: when both names are empty, C returns the team and the draft skips it. The negative form was known before this review; the positive form is the new evidence.

### 10. A `char *` field forced open into a callee that accepts NULL

Rule: draft_calls.py:266-268 states "Raven's callers never pass a NULL one here" and writes `!.string`. The never-null sweep (table.py:443-472) sees a literal NULL at a direct call only.

Site: g_mover Reached_BinaryMover, g_mover.c:677. C: `G_UseTargets2(ent, ent->activator, ent->opentarget)`. Draft: `G_UseTargets2(ent, ent.activator!, ent.opentarget!.string)`. The callee returns on `!string` in C, and its draft carries "Raven's NULL test on string has no form here, and the arm it guards is gone."

Run time: every door without an opentarget traps, and every trigger without a target traps in G_PickTarget.

Count: 7 G_UseTargets2 sites and 8 G_PickTarget sites. 336 `!.string` sites overall, and the other callees are not audited. Beyond fields, 261 parameter folds carry no Port-note and rest on the literal-only proof. The sweep misses a nullable parameter passed on to another call (30 pairs), a local that holds NULL (71 pairs, an upper bound), and pointer dispatch such as g_utils.c:1831. 297 plain folds exist, 42 on those pairs.

Gate site: w_saber G_G2PlayerAngles passes `emplaced!` where the C local is NULL for every client not on an emplaced gun (corpus w_saber.swift:802), and the callee BG_G2PlayerAngles folds the test (corpus bg_pmove.swift:7524). cg_players.c:4231-4254 has the same local.

Fix clause: follow parameters and locals that pass NULL along before a pair counts as proven.

### 11. A memset through a local pointer is dropped as a scratch clear

Rule: draft_statements.py:214-216 asks only for a function-level VAR_DECL and does not check that the local is the record and not a pointer to one.

Site: g_client ClientSpawn. C: `memset (client, 0, sizeof(*client));`. Draft: `// Raven clears the record with memset here. The scratch slot is zero at entry, so the body drops the call.`

Run time: the client record is not cleared on respawn. Every field Raven does not restore keeps its value from the last life.

Count: 4 of the 15 drop notes: ClientConnect, ClientSpawn, New_NPC_t, BotAIShutdownClient. 2 more drop a per-pass clear inside a loop, G_TouchTriggers and G_MoverTouchPushTriggers, where a touch callback sees the last hit's trace.

### 12. record_bytes reads neither the fill value nor the size

Rule: draft_statements.py:204-218 reads args[0], and args[1] for memcpy, never the size.

Site: ai_wpnav RemoveWP. C: `memset( gWPArray[gWPNum], 0, sizeof(gWPArray[gWPNum]) );`, a pointer-sized clear of origin[0] on the retail build. Draft: `gWPArray[gWPNum].clear()`.

Run time: the draft clears the whole wpobject_t: index, flags, neighbornum, neighbors.

Count: 3 (RemoveWP, RemoveWP_InTrail x2). The -1 fills in g_vehicles become holes because their target is not a record.

### 13. A static local gets new storage on each call

Rule: draft_declarations.py:265-382 does not read storage_class. Only array_declaration (403) reads it, and the vec3 array branch (277-282) comes first.

Site: g_main CheckCvars. C: `static int lastMod = -1; if ( g_password.modificationCount != lastMod ) {`. Draft: `var lastMod: Int32 = -1`.

Run time: the password block runs on every call, so trap_Cvar_Set runs every frame.

Count: 72 static local lines in the game C. One silent site. BotAIStartFrame, G_CheckMinimumPlayers, and the index in g_utils tv fail to compile as a `let` read before set. The BG_G2PlayerAngles statics in the gate stem are written before they are read. This is the new evidence for the BuildShaderStateConfig item.

### 14. A vector macro evaluates its scale once where C evaluates it per component

Rule: draft_calls.py:160-171 with overlay.py:14 (`_VectorMA({0}, {1}, {2}, &{3})`).

Site: NPC_AI_Sniper Sniper_FaceEnemy. C: `VectorMA(target, NPC->enemy->r.maxs[2]*flrand(1.5, 4), right, target)`. Draft: `_VectorMA(target, ... * flrand(1.5, 4), right, &target)`.

Run time: under `#if 1`, q_shared.h:1364 expands the scale three times. C draws three random numbers and scales each axis differently. The draft draws one, and the random stream is two draws behind from then on.

Count: 5 drafted sites (Sniper x4, Jedi_FaceEnemy) and 1 inside a hole in NPC_AI_Seeker.

### 15. The aliased copy changes a result that depends on the aliasing

Rule: draft_calls.py:125-148, the copies for the earlier positions (ce55f31).

Site: NPC_AI_Jedi Jedi_SaberBlock. C: `ShortestLineSegBewteen2LineSegs(saberPoint, hitloc, bottom, top, saberHitPoint, hitloc)`. Draft: `ShortestLineSegBewteen2LineSegs(&saberPoint, &hitlocIn1, ..., &hitloc)`.

Run time: the callee in g_utils.c writes close_pnt2 and then reads end1 in `Distance(end1, start2)`. C sees the new point. The draft sees the old one.

Count: 1 of the 10 aliased sites. PM_ClipVelocity, BG_SiegeGetValueGroup, WP_TraceSetStart, and G_GetHitLocFromSurfName give the same result through the copy.

### 16. A table cursor has no NULL value

Rule: draft_declarations.py:314-316 drops the initializer, and draft_statements.py:358-364 turns `= NULL` into offset 0.

Site: g_team Team_FragBonuses. C: `carrier = NULL;` then `if (carrier && carrier != attacker)`. Draft: `carrierIndex = 0` and `if g_entities[carrierIndex] != nil && ...`.

Run time: with no flag carrier, the draft treats client 0 as the carrier and can award the carrier-protect bonus.

Count: 1 silent site. The 13 g_log `player = NULL` initializers are set again before any read.

### 17. A float-to-int conversion traps where C gives a value

Rule: spelling.py:411-412 (the convert crossing) and draft_expressions.py:597 (an explicit `(int)` cast) write `Int32(x)`.

Site: bg_pmove PM_Footsteps, bg_pmove.c:5645. C: `pm->ps->bobCycle = (int)( old + bobmove * pml.msec ) & 255;`. Draft: `pm.ps.bobCycle = Int32((old + bobmove * pml.msec)) & 255`.

Run time: a NaN, an infinity, or a value outside Int32 gives INT_MIN on x86-64 and saturates on arm64 in C. The draft traps. This needs a bad input.

Count: 93 explicit `(int)` casts plus every implicit float-to-int store.

### 18. The alias reads its target text again after a later write changes a name in it

Rule: draft_declarations.py:416-435, with draft_statements.py:365-368 dropping the store that sets the alias.

Site: g_utils tv. C: `v = vecs[index]; index = (index + 1)&7; v[0] = x;`. Draft: `index = (index + 1) & 7` then `vecs[index][0] = x`.

Run time: the write goes to the next slot. Hidden today because `let index` fails to compile.

Count: 1 of 2 alias sites. PM_Friction is safe.

### 19. The GLAName fill_buffer ruling is broken

Rule: rulings.py:173 rules fill_buffer 1024 for GLAName.

Site: g_client.c:1526 declares `char GLAName[MAX_QPATH]` (64) for the calls at 1671, 1732, and 1766. Only NPC_spawn.c:2128 declares 1024. The draft at corpus g_client.swift:1398 writes `CharBuf(64)`.

Run time: C overflows the 64-byte buffer on a long name. The draft copies up to 1023 bytes into a 64-byte CharBuf and traps with "CharBuf write past the end" or cuts the name. The hitSurface part of the ruling holds: g_combat.c:4268, 4378, 5150, 5589 all use MAX_QPATH.

The other two claims hold. rulings.py:78 (NEVER_NULL pmove_t ps, trace, pointcontents): g_active.c:698-702, g_active.c:2894-2906, cg_predict.c:1008-1010, and cg_predict.c:1343 with 1385-1386 set all three before Pmove, no body stores into them, and ui calls no Pmove. rulings.py:96 (NEVER_NULL_VARS pm): each function that reads pm is reachable from Pmove or has no active caller; the vehicle callbacks at g_vehicles.c:2149 and AnimalNPC.c:350 run inside PmoveSingle (bg_pmove.c:10920, 10945). Two limits: the game call graph lacks the 64 PM_SetAnim recovery calls (finding 24), and after Pmove returns, pm points at a dead stack pmove_t (g_active.c:1941), which no nil trap can catch.

### 20. Rules with no live site that drift when one comes

- draft_expressions.py:444-447: `q == N` on a qboolean with a literal N other than 0 drafts as `q`, and `q != N` as `!q`. C gives false and true.
- draft_expressions.py:256-265: the Double wrap converts every numeric leaf, so `i / j` of two ints becomes a float division. C promotes one operator at a time. None of the 39 sites has the shape.
- draft_expressions.py:433-438 and draft_statements.py:439-440: the unsigned wrap converts each signed leaf before the operator where C converts the result after. `-` traps when a < b, and `/` and `>>` differ for a negative operand. Comparisons skip the wrap.
- draft_expressions.py:62-64: `sizeof(qboolean)` gives 1 where C gives 4, and `sizeof(vec3_t)` gives 16 where C gives 12. draft_expressions.py:41-42: sizeof of an inout CharBuf parameter gives the buffer count where C gives 8.
- draft_declarations.py:80-82 with draft_statements.py:248: the value mode of a scratch closure for a function that returns an optional would type the closure `T??`, so `return nil` would fall through. No `?? in` closure in the corpus.
- The aliased copy in an `if` test is taken before the whole test, so a left operand of `&&` that writes the variable is not seen. while, for, and do-while conditions and the right side of a return or assignment get no copy. 0 sites today; bg_saga.c:1279 is correct.
- draft_declarations.py:89 pops scratch_modes, and lines 98-99 then write a bare `return` whatever the enclosing closure's mode. 4 sites (g_client ClientSpawn x2, NPC_AI_Jedi Jedi_CheckJumps, w_saber G_GrabSomeMofos) fail to compile.
- draft_expressions.py:589-597: cast drafts its operand while leaf_wrap is open, so `Float(Double(...))` meets a Double. 3 sites fail to compile, w_force WP_ForcePowersUpdate and NPC_reactions NPC_ChoosePainAnimation among them.
- draft_statements.py:160 puts pending first on the Hole path too, and if_statement (539) drafts a nested else-if with no new pending scope, so notes collect above the chain head. 2 notes stand above a Hole (g_main CheckVote, g_bot G_AddBot), and 9 chains hold 20 notes above the first `if`.

### 21. The three crashes

Rule: draft_declarations.py:277 reads `t.element_type` on the declared, sugared type after testing the canonical kind. libclang gives element_type only on an array kind, so a typedef whose canonical type is an array raises, except vec3_t, which line 273 takes first.

Sites: ai_wpnav.c:2622 G_RecursiveConnection and ai_wpnav.c:2987 G_BackwardAttachment, `vec2_t givenXY;` (q_shared.h:531). w_saber.c:2338 G_G2TraceCollide, `G2Trace_t G2Trace;` (q_shared.h:1888). `vec3_t axis[3]` does not crash because its declared type is already CONSTANTARRAY.

Fix clause: read `t.get_canonical().element_type`. givenXY then drafts as a 2-element array, and G2Trace gets a "no type for" hole.

## The hole economy

At 13c30a4: 1626 Port-note rows, 1265 counted holes, 34 distinct reasons. Counts with every backticked span replaced by X.

| Count | Reason |
|---|---|
| 325 | A read of X, a local the draft left as a hole. |
| 226 | No operator between the operands, the text there is X. |
| 146 | Raven passes NULL for X, and the callee reads NULL as the zero vector. |
| 142 | Raven's loop has a continue, and the step below does not run for it. |
| 122 | A store into X, a local the draft left as a hole. |
| 113 | A pointer local X with no view. |
| 111 | Raven passes X to X, whose X parameter the stub holds as an inout CharBuf. Docket row 5 is due. |
| 92 | A pointer dereference the draft cannot place. |
| 54 | Raven tests X for NULL here. Swift holds it as a value, so the test has no form and reads true. |
| 49 | An assignment inside an expression. |
| 41 | Raven's X runs over bytes that are not one record with a view. |
| 35 | A local X the table has no type for. |
| 35 | No operator beside the operand, the text there is X. |
| 30 | Raven guards a NULL X here. Swift holds it as a value, so the guard has no form and reads false. |
| 19 | A Slots over one record has no form yet. |
| 16 | Raven passes the optional X to X, whose X parameter takes a value. A never-null ruling is due. |
| 14 | A ++ inside an expression. |

The 17 reasons below 10 each sum to 56.

**Cascades.** The read and store cascades are 447 rows. Joined to their origin (the nearest earlier note in the same function that names the local), the origins are:

| Origin reason | Origins | Cascades | Mean |
|---|---|---|---|
| A pointer local with no view | 92 | 222 | 2.4 |
| A local the table has no type for | 24 | 104 | 4.3 |
| No operator between the operands | 14 | 35 | 2.5 |
| A pointer dereference the draft cannot place | 15 | 18 | 1.2 |
| No operator beside the operand | 9 | 17 | 1.9 |
| Bytes that are not one record | 3 | 13 | 4.3 |
| An assignment inside an expression | 7 | 13 | 1.9 |

18 cascades have no origin: two locals (advance in Wampa_Combat, pdist in NPC_FindCombatPoint) assigned on the same line as a read of a holed local. The functions with the most cascades: G_BuildSaberFaces 45 (from `static saberFace_t faces[12];`), G_LogWeaponOutput 24, RotatePointAroundVector 23, WP_CreateFlechetteBouncyThing 21 (one `random()` removes all 22 statements), NPC_FindCombatPoint 19, NPC_PainFunc 17, qsort 17, vmMain 17. The largest single hole is w_force ForceThrow, where one read of push_list in `if (push_list[x]->client) {...}` removes 91 statements.

**The five root causes with the most reach**, origins plus cascades: a pointer local with no view 335; the operator scan under a macro 261 plus 52 cascades; the NULL vector note 146; the continue step note 142; a local with no type 139.

**The operator notes by macro**: the tri_coll_test macros 128, random and crandom 68, the fortify vsprintf and strncpy 14, the bg_lib macros 9, VALIDSTRING, Q_IsColorString, and ColorIndex 7; beside: FOFS 33, memmove 2. bg_lib.c:60 defines min again after the overlay's undef, so `r = min(...)` in qsort records "Raven wrote: r =" (2 sites). The table also counts any collapsed binary node as a store (table.py:876, 924) and `&p[i]` as a write of p (868), so 9 of the 84 parameter copies have no store in Raven's body, `var es = es` in qsort among them.

**Notes that count no hole**: 374 rows in five reasons: the NULL vector 146, the continue step 142, the NULL test reads true 54, the NULL guard reads false 30, the record `%s` 2. The gap to the counted total is 361; the 13 missing are in bg_lib (56 counted, 50 portMissing emitted), g_svcmds (16 vs 15), w_saber (71 vs 70, the crash counted a hole and lost the text), and one Port-note in g_vehicles the dump did not capture.

**The nine gate stems carry 18 note-only rows**: bg_pmove 7 (PM_BGEntForNum pm, PM_pitch_roll_for_slope `&trace.plane`, PM_SetVehicleAngles normal and one continue, PM_RocketLock mins and maxs, BG_G2PlayerAngles crazySmoothFactor), bg_misc 2 (BG_ValidateSkinForTeam colors), bg_slidemove 4 (PM_SlideMove continue x4), bg_panimate 2 (PM_DebugLegsAnim `%s`), bg_g2_utils 1 (BG_AttachToRancor out_axis), bg_saberLoad 2 (WP_SaberSetColor sabers, BG_SI_SetLengthGradual continue). bg_saber, bg_saga, bg_vehicleLoad have none. Across all 84 NULL-fold notes: 58 have no parsed caller, 16 contradict a sweep proof, 6 are address tests, 2 rest on PARAMS, 1 on NEVER_NULL_VARS, 1 is a local.

## Parse and proof soundness

**The parse errors** are 3764 in the game unit and 3881 in cgame, all severity Error, no fatal. By message in game: 2440 enumerator redefinitions, 865 typedef redefinitions, 318 tag, variable, or function redefinitions, 87 argument-count errors, 23 conflicting types, 18 from the overlay's `void Name(...)` declarations, 8 asm or declarator errors. By file: g_local.h 2904, bg_saga.h 340, w_saber.h 153, ai_main.h 145, the .c files 157, q_shared.h 7. In cgame: cg_local.h 3708. The cause is closure.py:205, which puts every .c file in one unit, and g_local.h and cg_local.h have no include guard.

**No body is dropped.** The AST definitions per .c file match a text count over the active preprocessor arms: game 2943 and 2943, and each cgame member file matches. The one exception is bg_lib.c memmove, which parses as `__builtin___memmove_chk` because overlay.py UNDEFINED lacks memmove; NOT_PORTED covers it. 27 definitions are invalid declarations that keep their body: 16 vehicle static redefinitions, 6 conflicting types, powf, memmove.

**No view record is partial.** The views read parse.headers, which has 0 errors, and reexport.py:68-70 exits on any error. The game unit's 83 view records have the same field names and sizes as the headers parse. The 1328 bad record cursors are redefinition copies.

**87 calls parse as recovery nodes.** Stale externs sort first in the unity source: AnimalNPC.c:82 `PM_SetAnim(pmove_t *pm, ...)`, AnimalNPC.c:93 G_Knockdown (5 params), NPC_AI_Jedi.c:57 WP_ForcePowerUsable (3 params), NPC_AI_Jedi.c:42 `NPC_CheckEnemyStealth(void)`. libclang gives `UNEXPOSED_EXPR <dependent type>` for their calls, and every CALL_EXPR walk (table.py:459, 1019) skips them. Counts: PM_SetAnim 64 (bg_pmove, bg_saber), WP_ForcePowerUsable 18, G_Knockdown 4, NPC_CheckEnemyStealth 1. None passes NULL, so no nullable fact is wrong today. The game-only sweeps do not see them. w_force ForceHeal drafts `if WP_ForcePowerUsable(\`self\`, FP_HEAL) == 0` against a Bool return, which does not compile; 18 such sites.

**The ui scope costs nothing today.** A parse of the ui unit finds 0 literal NULLs from ui code or ui_shared.c into a game pair outside nullable. Prototype-name keying (table.py:461-465) loses 1 pair, cgame only. 41 prototype parameter names differ from the definition's; BG_ParseAnimationFile's NULL from NPC_stats.c goes under animSet where the body tests animset, and the fact is correct only because g_client.c:1743 also passes NULL after the definition.

**A `let` from single_writes fails closed.** The merged counts only grow, so a wrong `let` needs a write the counter misses, and Swift then does not compile.

**Cross-unit facts.** The cgame pass (table.py:1159) adds calls to cgame's own definitions of 97 names the game also defines (trap_*, strap_*, Com_Error, Com_Printf, BG_GetTime, PASSFLOAT) under the same key. No drafted body tests those parameters. 16 cgame definitions share a game name with the same parameter names, and none gives a game function its only called entry.

## Proposed rows

The rows a docket walk would take, in the order that pays most:

1. Every note-only kind counts as a hole: the continue step, the NULL folds, the NULL vector scratch. The gate then reports what it hides.
2. The continue step: emit the step before each `continue` of the rewritten loop, or hole the site.
3. The twice-inout member path: in and out copies with a write-back, the shape the hand port already uses.
4. Narrow locals: `Int16` and `UInt8` with truncating stores, the shape the hand port already uses.
5. The file-list tuple call: a form that keeps the NUL-separated list.
6. nullable read by the value-typed vec3, axis, and out-scalar rules; the proof follows NULL through locals and passed-on parameters.
7. The double literal: the doc's Double rule for every float store, not only Int32 stores.
8. Wrapping arithmetic where the C is a generator or a hash: Q_rand, rand, flrand, irand, and holdrand at 32 bits.
9. `%c` in the conversion map.
10. The overlay declares random, crandom, FOFS, the tri_coll_test macros, and the fortify names as functions, and adds memmove to UNDEFINED.
11. record_bytes checks that the target is a record local and not a pointer, reads the size, and does not drop a clear inside a loop.
12. Static locals become a hole until a storage rule exists.
13. The crash line reads the canonical element type.
14. rulings.py:173: GLAName at MAX_QPATH for g_client, 1024 for NPC_spawn.
15. The stale externs in AnimalNPC.c and NPC_AI_Jedi.c: an overlay undef or a parse fix so the 87 calls resolve.
