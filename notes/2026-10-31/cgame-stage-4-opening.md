# The cgame stage 4 opening

The record of the walk that opened stage 4, the cgame drafter rounds, on 2026-10-31. The gate log is `cgame-draftcheck-mp-cgame.log` and the pass 24 draft of the one stem with defects is `cg_players-draft-pass24.swift`, both in this folder.

## The gate

`draftcheck.py --unit mp-cgame` ran once on master at 8492b07 with the snapshot cache refreshed from master. It gave 37 stems, 1655 holes, 0 cascade errors, 3 defects, 643 compile holes, 24 passes, in 355 seconds. The run of 2026-10-29 in `../2026-10-29/cgame-stage-3-tools.md` gave 1662 holes, 7 defects, and 645 compile holes, with the cap at `cg_ents`.

`cg_ents` is clean now: 40 of 40 functions replaced, 16 holes, 0 defects, 0 compile holes, 1 pass. The stage 3 tools of PR 20 took its defects. The 3 defects stand in `cg_players`, which ran 7 passes and held the cap. The axis shape of the earlier docket, a view field passed as `inout [vec3_t]`, did not appear in this run.

## The rows

### V1, the venv link

Commit 8f342a2 tracked `tools/oracle-closure/.venv` as a link to its own absolute path. Ratified: untrack the link, add an ignore line for it, and add one README sentence. Landed as PR 23 at 715c95f.

### V2, the order inside stage 4

Ratified as listed in the handoff: the 30 hand data tables on `CGameWorld`, then the 20 stub and 9 trap signature markers under the D8 reading of rule 11, then the D16 constants.

### C1, a Slots passed to a pointer parameter

Raven, `oracle/codemp/cgame/cg_players.c:3699`: `CG_G2SetBoneAngles(cent->ghoul2, 0, "cervical", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, cgs.gameModels, 0, cg.time);`

Draft, `cg_players-draft-pass24.swift:2698`: the same call with `&cgs.gameModels`. swiftc rejects the pointee type and the address of a get-only property. The drafter's argument arm at `tools/oracle-closure/draft_calls.py:400-406` writes `&text` for every parameter whose type starts with `UnsafeMutablePointer<`. The generated trap at `Sources/JKAMP_CGame/Generated/cg_syscalls.swift:1365` takes `_ modelList: UnsafeMutablePointer<Int32>?`. Raven passes `cgs.gameModels` at 85 sites in the cgame, 47 in `cg_players`.

Ratified: the generated trap wrappers with a `qhandle_t *modelList` parameter take `Slots<qhandle_t>?` and pass `modelList?.base` to the engine. The call sites then read as Raven wrote them, with no `&`. The game side keeps `nil`. This is a generator signature change in its own commit, and it reruns the generator sequence. No `// AI:` line, because every call keeps Raven's form.

#### The C1 amendment

The parameter spelling is one rule in `tools/oracle-closure/spelling.py:379-381`: every `qhandle_t *` parameter becomes `UnsafeMutablePointer<Int32>?`, and the rule has no trap guard. Raven's passthroughs carry the same parameter: the four `strap_G2API_*` wrappers in `g_strap.c`, `BG_AttachToRancor` in `bg_g2_utils.c`, and `CG_G2SetBoneAngles` with the four `cg_strap` wrappers in the cgame. The defect at `cg_players.c:3699` passes `cgs.gameModels` into `CG_G2SetBoneAngles`, not into a trap.

Ratified as amended: the rule changes for every function. Every `qhandle_t *` parameter becomes `Slots<qhandle_t>?`. The trap wrappers pass `modelList?.base` to the engine, and the passthroughs pass `modelList` through as Raven wrote them. The game call sites keep `nil`. The six finished game and bg signatures change, so the generator sequence reruns and the five passthrough bodies take hand updates. No `// AI:` line at any site.

### C2, an Int32 stored into a byte slot

Raven, `oracle/codemp/cgame/cg_players.c:8996`: `legs.shaderRGBA[0] = ci->colorOverride[0]*255.0f;`, with the same store for indexes 1 and 2. `shaderRGBA` is `byte shaderRGBA[4]` in `tr_types.h`.

Draft, `cg_players-draft-pass24.swift:7248-7250`: `legs.shaderRGBA[0] = Int32(ci!.colorOverride[0] * 255.0)`. swiftc rejects an `Int32` into a `Slots<byte>` subscript. `narrow_element` at `tools/oracle-closure/draft_expressions.py:125-136` accepts only a subscript over a `VAR_DECL` local array, so a view field falls through to the plain store. The game precedent is `Sources/JKAMP_GameLogic/g_svcmds.swift:57`, `b[i] = UInt8(truncatingIfNeeded: atoi(num))`, for Raven's `g_svcmds.c:89`.

Ratified: a drafter rule change. `narrow_element` also accepts a subscript over a member expression whose element type the type table reports as narrow, and the store takes the `UInt8(truncatingIfNeeded:)` arm. The tool change runs the snapshot check before its commit. No `// AI:` line.

### C3, the pass cap

`tools/oracle-closure/draftcheck.py:73` sets `PASSES = 24`, and the loop counts passes across the unit. The stems settle at different speeds, 1 or 2 passes for most, 5 for `cg_main` and `cg_localents`, 7 for `cg_weapons` and `cg_players`. `cg_players` was the one stem pending when the count reached 24. Nothing cycles.

Ratified: no change to the cap. C1 and C2 remove the two shapes of the residue. The next gate run shows whether `cg_players` settles inside the budget. If the cap still hits, a one-line raise of `PASSES` comes back as a new row.

## The ledger

| Row | Verdict |
|---|---|
| V1 | ratified as proposed, PR 23 |
| V2 | ratified as listed |
| C1 | ratified as proposed |
| C2 | ratified as proposed |
| C3 | ratified as proposed, no change |
