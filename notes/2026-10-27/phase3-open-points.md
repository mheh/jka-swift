# Phase 3, the seven open points: rulings

The user delegated the seven open points of `HANDOFF.md` to the coordinator with the words "autorule based on what you think i want from previous rulings and the architecture documents. then resume the plan order." This record is the ledger of those rulings. Each ruling rests on a ruled row, a proof, or a doc, and the record names it.

| Point | Ruling | Basis |
|---|---|---|
| 1. The four accessor types at `g_nav.swift:74` and `g_ICARUScb.swift:19`, `:25`, `:31` | Ratified as built. No new row. The hand changes are the W6 and W9 items of the hand-site group, which group 2 pulled forward because the build needed the types. | `phase-2-walk.md`, hand sites, W6: "the accessor at `g_nav.swift:74` takes `Int32?`". W9: "The accessors at `g_ICARUScb.swift:19-33` take `JKAShared.vec4_t`". |
| 2. The V35 `slot_refs` parent walk patch in `draft_declarations.py` | The patch stays. The review leg of group 2 reads it against the V35 proof and the drafter test, and a defect it finds is a row, not a hand fix. | The standing rule: a defect of a drafter rule goes to the drafter rule by a row. The tool tests passed, 78 OK. |
| 3. The 17 `T_G_ICARUS_*` stones under `.claude/rosetta/` | Ratified. The stones stay. `rosetta.py` is the generator of the stones, and a generated file is never hand-edited, so a stone the generator writes is the truth of the tree. No row. | `docs/oracle-closure.md` item 8: `rosetta.py` writes the type stones. The views already held the 17 types. |
| 4. The W9 rule and the 13 `q_math` color globals in the skeleton text | Ratified. The rule is general by its proof, a scalar `vec4_t` global is `JKAShared.vec4_t`. `q_math.swift` is a hand file that already writes the colors as `vec4_t`, so no Sources line moves. No row. | The W9 proof, `docket-proofs-W.md:361`: "`q_math.c` holds the other `vec4_t` globals, which `Sources/JKAShared/q_math.swift:13` writes by hand as `public let colorBlack = vec4_t(0, 0, 0, 1)`". |
| 5. The draftcheck drop, 1357 to 1025 holes and 224 to 6 compile holes | Accepted as an improvement, not a defect, because the defect count is 0 on both sides. The reference of 1357 and 224 was written at 1eca315 before 27 drafter and gate commits, the three generator rules of phase 1, and the group 2 rules. Group 5 writes the explanation as one paragraph in `phase3-generators.md` under V26, from the commit list, and `docs/oracle-closure.md` item 10 takes the current reference, 1025 holes, 0 defects, and 6 compile holes. | `git log 1eca315..b72fe3b -- tools/oracle-closure/` gives 27 commits. Docs state what is, by the docs rule. |
| 6. The `memset` half of open point 2 | Ratified. The half is void. `overlay.py` `UNDEFINED` lists the fortify macros for the C parse and does not name Swift functions. Group 5 corrects open point 2 of `phase3-helpers.md` to say so. | `phase3-generators.md`, "Open point 2": the revert and its reason. |
| 7. `Double(0.2 as Float)` at `g_weapon.swift:1106` | Ratified as a guide line. Group 3 adds to line 548, after the W18 example: "A `float` literal that meets the `Double` keeps its single-precision value, `Double(0.2 as Float)`, because C promotes the rounded `float` and not the decimal." | The W18 row: C widens each `float` operand to double and narrows once. Raven's `0.2f` is the rounded float, and `0.2` as a `Double` literal is a different value. |

## The order after the rulings

The plan order of `phase-2-walk.md` stands: the owed review leg for groups 1 and 2, then groups 3, 4, and 5. Groups 3, 4, and 5 touch disjoint files, `docs/transcription.md`, `Sources/`, and `notes/` with `docs/oracle-closure.md`, so they run at the same time with the review leg. Each group commits on its own after its gate, code then records, because the user asked for the build in one session.

V30 is void. The `HANDOFF.md` of phase 2 is gone, and the `HANDOFF.md` of 2026-10-27 goes when phase 3 is committed and reviewed, by its own text.

## The review findings of groups 1 and 2

`review-phase3-groups-1-2.md` gives 11 findings, and five need a ruling. The coordinator ruled them under the same delegation.

| Finding | Ruling | Basis |
|---|---|---|
| R1. `String(cString:)` at `RecordingTransport.swift:25` and `jampsmoke/main.swift:25` and `:69` | W19 covers every target of the package. The three sites read `cString(at:)`, the same form as `g_spawn.swift:231`. | The amended W19: the codec lives in the two `CharBuf` initializers alone, with no exception named. A test that decodes engine bytes by another codec tests a different value than the game reads. |
| R2. The V35 parent map key `(start, end, kind)` | Ratified as a drafter row, V35a. `slot_refs` keys the map by the cursor itself, `slot_parent` reads it by the cursor, and the wrapper test goes. | The review proof: the key is not unique inside a macro expansion, and `Cursor` hashes through `clang_hashCursor`. A defect of a drafter rule goes to the drafter rule. |
| R3. The first-store test at `draft_declarations.py:506-507` | Ratified as part of V35a. The test compares a read with the end offset of the first store. | The V35 verdict wants every read after the first store, and a read inside the store's right side comes before it. |
| R4. No tool test reaches the V35 and W14 rule | Ratified as part of V35a. One test in `tests/test_store.py` with four cases: the `SortRanks` shape, the `Pickup_Powerup` closure shape, a read before the first store, and a stacked implicit cast over a read. | A test file is not a Swift name, so the no-new-names rule does not reach it. The tool tests are the gate of a drafter rule. |
| R5. A `default` arm that joins labels keeps the first label comment alone | Ratified as built. The loss is part of W15, and the V37 record says so. No drafter change. | W15: "the `case` labels that share its arm drop, and the other arms keep Raven's order with no comment". A label that drops takes its comment with it. |

The six findings that need no ruling are fixes of the forms the review gives: `g_spawn.swift:231` in group 4, the `phase3-helpers.md:105` sentence, the `withCString` doc at `CString.swift:480`, the `CStrings.swift:12` doc, the `memset` line numbers in `phase3-helpers.md`, and the docstring line at `draft_declarations.py:532`.
