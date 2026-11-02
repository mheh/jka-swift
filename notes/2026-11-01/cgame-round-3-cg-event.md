# The cgame transcription rounds, round 3, cg_event

The record of the third cgame transcription round on 2026-11-01, one stem, `cg_event`, on the branch `cgame-round-3-cg-event` off master `0563823`.

## The first adoption

The snapshot check showed no difference at the branch head. Draft gate of the stem: 20 of 20 replaced, 225 holes, 0 cascade errors, 0 defects, 140 compile holes over 2 passes. The file was already adopted, so the adoption at 58981f9 carried no header change. 225 Port-notes, 132 of them the DEBUGNAME macro of CG_EntityEvent.

## Rows R19 to R22

Ruled by the coordinator under the user's delegation, each proved at its lines in both trees before the change.

- R19. Raven defines `DEBUGNAME(x)` inside cg_event.c:1489, after the overlay, so the parse expands it and the `if` drafts. The string literal inside the expansion took the source slice of its extent, the macro use text, and did not compile. The STRING_LITERAL arm now reads the literal's own spelling when the extent is not a run of literals and macro names, and the paste gives `CG_Printf("ZEROEVENT\n")`. 132 holes closed, the game drafts did not move. The proposed overlay row was wrong, the overlay cannot reach a macro the file defines after it. Commit c039ba6.
- R20. The text-local rule did not see a store through a C cast, `message = (char *)CG_GetStringEdString(...)`, so `message` and `psStringEDRef` were holes. The rule takes the cast off before its tests. The locals draft as `String?`, the g_client `saber` form, with `message!.isEmpty` for Raven's `!message[0]`. The cg_marks draft moved 16 lines, and the hand file, past its hole round, stays. Commit a489125.
- R21. Raven declares the three FX play traps with `vec3_t org, vec3_t fwd` and no const, and the engine only reads them, FXExport.cpp:18 and :38 through FxScheduler.cpp:727 and :805 to `const vec3_t` parameters. A PARAMS kind `vec3_const` gives a trap vector the `const vec3_t` form, and six rows apply it, so the traps take the vectors by value. 127 call sites in the cgame and 2 in bg reach them. Commit fcfefd2.
- R22. An optional text that is the first variadic argument was bound twice, `message!!`, by the base bind and the format bind. The format test skips a text already bound. Three game drafts moved to their hand form. Commit 197478b.

The regate after the rows: 15 holes, 3 compile holes, 0 cascade errors, 0 defects. The file was reset to its stub and readopted at 1424c0f after R20 and R21, and again at c4eb697 after R19 and R22, because no hole round had touched it. The snapshot moved 6 lines, 3 under R21 in the bg strap and 3 under R22.

## The hole round

Commit fc2513e closed every note. 0 Port-notes and 0 portMissing lines remain. The shapes: the static buffer of CG_PlaceString as a local CharBuf with a String return, the `trap_SP_GetStringTextString` arm as the tuple form, `strstr` on the String with a CharBuf bind for the byte walk, the npcClient memset as `clear()`, four scratch closures where Raven's `break` is the closure return because no statement of the case follows, and `UInt32(bitPattern:)` at CG_TestLine as g_client spells C's int to unsigned. The build and `swift test --no-parallel` pass.

## The rows left open

- The static buffer a function returns, cg_event.c:46, took a local CharBuf by hand. The guide's static ring row, `docs/transcription.md:109`, is the drafter's form for the same shape, and the drafter did not reach this site.
- R17 and R18 of the round 2 record stay open.
