# The open rows ledger

The rows the round records of 2026-11-01 and 2026-11-02 left open, proven at their lines by an investigator and ruled by the coordinator under the user's delegation of 2026-11-02, "investigate all the open rows and prove them and rule as proposed". Each row names its proof, its ruling, and the commit that lands it on the branch `cgame-round-5-cg-main`.

## R17, a dead-function stub form for the generators

Proof. No tool writes the dead note. `NOT_PORTED` of `rulings.py` removes a function, but rule 20 keeps the stub. The note at `cg_marks.swift:1551` is a hand line.

Ruling. A `DEAD` table in `rulings.py` in the `NOT_PORTED` shape, and `skeleton.stub` writes the dead note line as it writes the `in_place` note. The drafter prints the same stub, so the gate counts no hole. The cg_marks stub is the first row. Commit 0b2065d.

## R18, the bg_pmove float product kept in double

Proof. `bg_pmove.swift:440` computed the product in double where Raven's `0.75f` at `bg_pmove.c:526` rounds it to float. The drafter already prints `Double((a - b) * 0.75)`.

Ruling. The hand line takes the drafter's form, as `g_utils.swift:394` does under R11. No AI line, because the change restores Raven's product. Commit 752277e.

## The cg_draw hand file and the R15 grouping defect

Proof. Three of the 127 compound stores of `cg_draw.c` have a compound right side, at `:4461`, `:5969`, and `:7135`. All three stand as Swift `+=` in the hand file, so their grouping is correct. The 14 expanded stores are safe, and the cg_drawtools candidates sit inside a Raven comment.

Ruling. No site to fix. The row is closed by the proof.

## The static buffer a function returns

Proof. The CG_PlaceString hand form is the guide's rule at `docs/transcription.md:420`, as `vtos` in `g_utils.swift:627` spells it. The drafter made the buffer a hole at `draft_declarations.py:660`. CG_Argv, CG_GetStringEdString, and CG_GetLocationString of cg_main waited for the form.

Ruling. A static `char[N]` that the function returns, or that a fill writes first, drafts as a local `CharBuf`. This is R36 of the cg_main docket as well. Commit e61abcb.

## The gate base finding of round 4

Proof. The `splices` table of the store keeps one hash per function. From R24 on, every function an earlier row changed was kept as its e31f30d text, so its draft never reached the build and its compile errors never showed, while its other holes still counted. A probe over 85 functions kept 20, CG_Player among them, and CG_Player's 43 compile notes are the 43 by which the count fell at R24.

Ruling. A row gate runs over the stub of the stem, as the readoptions of rounds 1 to 4 did, and the readoption count is the stub count. The gate line is quoted whole, with the replaced and kept fields. The README says so under `draftcheck.py`. The alternative, a `splices` key of path, function, and hash, is not taken, because it needs a store schema bump. Commit 0878612.

## R30, the negated null test on an optional offset

Proof. `g_svcmds.swift:204` spells Raven's `if (!s) break` at `g_svcmds.c:209` as `guard let found = strchr(...) else { break }`, and `bg_pmove.swift:8405` is a second site.

Ruling. The R28 arm of `draft_statements.py` also drafts `if (!p) continue`, `break`, or `return` with no else as `guard var p else { ... }`, only in a block nested inside the block that declares the local. The BotAI draft of ai_main moved. A side finding stays open: the R3 tuple form of `trap_BotGetServerCommand` does not reach a `while` test. Commit 48247c4.

## The `Slots<vec3_t>` to `inout [vec3_t]` shape

Proof. The game passes a Slots into an array parameter three ways. `Array(slots)` for a by-value parameter at `ai_main.swift:723`. A forward under Raven's name that takes the Slots and writes back, `G_RadiusList` at `g_utils.swift:370`. A copy and store-back at the call site, `docs/transcription.md:193`. About 56 cgame calls hand a view's axis to `AnglesToAxis`, `AxisClear`, `AxisCopy`, or `MatrixMultiply`, and every caller of `MatrixMultiply` outside q_math passes `vec3_t[3]`.

Ruling. An input passes `Array(...)`. Each output position gets a `Slots<vec3_t>` forward under Raven's name in `q_math.swift`, in the `G_RadiusList` shape, and `MatrixMultiply` takes `[vec3_t]`. The forward is an overload of a Raven function, so it is not helper litter. The nine cg_players sites call the forward, and the copy comments are gone. The `CG_G2PlayerAngles` copy site stays, because its callee is not one of the four. Commit 1cc9dad.

## The 21 cg_players notes

Proof and ruling by shape, the forms from the game bodies. Commit 1346999 closes A, B, C, E, G, H, I, J, and K. Shape D lands with the tools at f76f43a.

- A. The two memsets sized by a pointer in CG_ParseSurfsFile take `memset(&surfOff, 0, 8)` under the comment form of `ai_wpnav.swift:498`.
- B. The six memcpy of scalar sound arrays take the index loop of `NPC_senses.swift:655`, the form round 2 ruled.
- C. `ci - cgs.clientinfo` takes `Int32(cgs.clientinfo.firstIndex(of: ci) ?? -1)` as `g_items.swift:2819`, with a rule 19 comment and no Port-note.
- D. The NUL writes of CG_HandleAppendedSkin are a behavior gap, because Raven truncates the caller's model name and the caller loads the model with it, `cg_players.c:7078`. The text sweep's clause 8 also follows a local set from `Q_strrchr` or `strchr` of the parameter, so the parameter is `inout CharBuf`, both callers pass `&modelName`, and the body takes the R28 form.
- E. `colorOverride` copies the three floats into a `vec3_t`, calls, and stores back, as `bg_pmove.swift:2756`.
- F. MatrixMultiply, the row above.
- G. `m_vOrientation` reads through `pointOrientation(at:)` as `NPC_spawn.swift:1244`.
- H. `++iter` inside the if test is `iter += 1` then `if iter == 20 { break }`, as `g_team.swift:975`.
- I. `RARMBIT` and siblings take `as Int32`, as `NPC_senses.swift:8`, and `reexport.py` spells a shift with a literal left operand as `Int32`. Commit a7f58af carries the tool part.
- J. The memset sized by the sibling field is `cent.pe.torso.clear()`, because `legs` and `torso` share one record type, and `whole_record_size` tests the type. Commit a7f58af carries the tool part.
- K. The NUL write into `stringData` is `animEvent.stringData = ""`, the `g_client.swift:2188` form through the setter of `bg_panimate.swift:1692`, under one AI line.
