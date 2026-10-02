# The walk of 2026-10-01

This walk closed rows 3, 4, and 5 of the walk of 2026-09-29, and the round for rows 1 and 3 landed at f6218f1. The game gate at b592573 is tabled in game-gate.md beside this file. The rows below opened from that round.

## Ledger

| Row | Question | Verdict |
|---|---|---|
| 1 | The raw pointer to CharBuf sub-shape, 68 lines. 67 are a `char *` local from `B_TempAlloc` at a constant size, passed to `GetValueGroup` or `GetPairedValue`, which take an inout CharBuf, in ai_util and ai_wpnav. Proposed: a name rule `CHARBUF_ALLOCS = {"B_TempAlloc"}` in rulings.py, an allocator whose `char *` result a body holds as a CharBuf of the constant size Raven asks for. The allocation call and its free stay on the page, so the pool keeps Raven's count. The other choice is raw parameters on the two callees, which also take CharBufs from the chat buffer table | ratified as proposed |
| 2 | The g_main gate count is a floor when the jampgame target fails first. The drafted g_main writes `Com_Error` and `Com_Printf` without `public`, so jampgame.swift fails, and that failure cancels the GameLogic compile. g_main read 2 defects at b592573 and reads 48 on equal terms. draftcheck also names every error after the stem's file, so a jampgame.swift error reads as g_main.swift. Two parts: the drafted definitions are public, and the gate keeps the file name of the error | ratified as proposed |
| 3 | Rule 5 shrinks a buffer. For a `(Int32, String)` trap it writes `buf = CharBuf(filled.1)`, so the buffer is the text length, and a later `sizeof(buf)` passes the smaller size. The new filled_call rule copies with `strcpy` and keeps the size. Proposed: rule 5 takes the strcpy form too | ratified as proposed |
| 4 | Entity to Int, 19 lines in g_utils and g_main, from entity parameter walks such as `from++` over `g_entities`. A rule 5 question | ratified 2026-10-01: a walked entity parameter keeps its Entity? signature, and the body takes an index local `<name>Index` at the top, 0 for nil and `s.number + 1` for a stepped parameter, and every read of the parameter in the walk is the table at the index. The same text the walk sweep writes for a walked local |

## The round at f6218f1

Row 1 of 2026-09-29 built: the file-scope walk index. Row 3 built for CharBuf to Int32 (89 to 1), [Int32] to Int32 (30 to 0), String to CharBuf (7 to 1), and the (Bool, String) trap test (3 to 0). The class reads 162 lines. "Extra argument in call" reads 2, from 98.

Gate: build 0 errors, 106 tests in four binaries, bg 97 holes with 0 defects, game 1578 holes with 0 cascade errors and 986 defects.

## The round at 476626c

Row 2 built: a game function that a Swift file of another source target calls is public, and a defect line names the file the compiler names. The drafted g_main also needed a Never rule, since jampgame.swift expects Never from Com_Error. g_main reads 48 defects on equal terms. Row 3 built: rule 5 takes the strcpy form, and no drafted site uses the text form today, so no count moves. Row 1 built: the raw pointer to CharBuf lines go from 67 to 0, ai_util defects from 136 to 3, ai_wpnav from 28 to 7. The fileString site in SavePathData stays a hole, because Raven stores NULL into it before the allocation. Row 4 built for parameter walks with an Int32 index, since s.number is Int32 and the Slots subscript takes any integer type. Entity to Int lines go from 19 to 15. G_Find and target_location_linkup take the form.

The round fixed a shadowed loop variable in the row 2 draftcheck edit, so the restore step copies the mirror back after every stem. The rosetta stones match the views again.

Gate: build 0 errors, 106 tests in four binaries, bg 97 holes with 0 defects, game 1576 holes with 0 cascade errors and 824 defects.

### Rulings on the round

| Row | Question | Verdict |
|---|---|---|
| R1 | The Never rule. A void function with no return statement whose last statement calls a Never function also returns Never. It catches G_Error and Com_Error and matches the hand port. Not in the ratified text of row 2 | ratified as proposed |
| R2 | The 15 Entity to Int lines row 4 does not reach are local walks that start at a slot address, `&g_entities[N]`: e in G_Spawn and G_EntitiesFree, ent in G_RunFrame. The walk sweep reads a bare table and a table plus an offset as a walk start, not a slot address. Proposed: a local that starts at `&table[n]` and that the body steps is a walk over that table | ratified as a docketed open row, not built |
| R3 | The rosetta stones were stale since 03c875d. The generator run brought 22 stones and the index up to date and added 18 stones. Proposed: the catch-up goes in this commit | ratified as proposed |
| R4 | The composition of the next round, from the class table at 476626c in game-gate-476626c.md. Proposed: row 5a first, then R2, then 5b, then 5c. Row 5a targets the two optional unwrapping classes, 231 lines. R2 targets the 15 Entity to Int lines in g_utils and g_main | ratified as proposed |

## The round at ddd42e8

Row 5a built: the never-null proof and the out-scalar rule read the one-hop reach. The two optional unwrapping classes go from 231 lines to 78, g_combat from 61 to 1 and g_vehicles from 62 to 10. Two added shape rules cleared most of them, ruled R5 below. The reach adds 50 game holes and 6 bg holes. The 78 lines left are a pooled string field as a format argument, 31, the Bool? callback helpers, 19, and a tail of optional views. Row R2 built: the Entity to Int lines go from 15 to 3, g_main from 48 to 38 defects. G_Spawn keeps 3 lines, because Raven writes NULL into the local before the walk. Row 5b built: four static buffer returns become holes, in g_utils, g_cmds, g_client, and g_main, 12 more holes with their reads and stores. Row 5c built: a C library call inside a widened expression takes Double, 13 draft lines move and no defect moves.

Gate: build 0 errors, 106 tests in four binaries, bg 103 holes with 0 defects, game 1638 holes with 0 cascade errors and 625 defects. No defect class grew in any stem. The generators wrote no change.

### Rulings on the round

| Row | Question | Verdict |
|---|---|---|
| R5 | Two shape rules for row 5a not in the ratified text. A member read through an optional view parameter takes the bind, `attacker!.client`, about 50 lines. Raven's cast between views over a pointer that can be NULL maps over the optional, `pVeh.m_pPilot.map { Entity($0) }`, about 75 lines | ratified as proposed |
| R6 | A rule for row 5b beyond the read-before-write wording. A static that the function returns is also a hole. Without it the four static buffer defects stay defects | ratified as proposed |
| R7 | 19 Bool? lines are calls through the function pointer fields of vehicleInfo_t, `pVeh.m_pVehicleInfo!.runEject(...)`. Clearing them needs a never-null fact about those fields, a name rule in rulings.py | ratified as a docketed open row |
| R8 | A false hole from row 5b. `garbage` of SP_NPC_spawner is scratch. Its first use passes its address to G_SpawnInt, and the written-first test does not count an address pass as a store. Proposed: an address passed to an out parameter counts as a store | ratified as a docketed open row |
| R9 | Two gaps in the Double rule. The rule widens every float leaf, so `(150 + pml.frametime) * 0.003` adds in double where C adds in float. A double macro constant such as `M_PI` does not trigger the rule, because the test reads the literal's own text. Proposed: widen at the operator that meets the double operand, and read a macro constant as a double literal | ratified as a docketed open row |
| R10 | The composition of the next round, from the class table at ddd42e8 in game-gate-ddd42e8.md. Proposed: row A, a pointer minus its own table is the slot index, 52 lines. Row B, a game function assigned to a callback field reads the thunk in the generated Callbacks.swift, 85 lines. Then R9, then R8. R7 stays open as a name rule | ratified as proposed |

## The round at 649163e

Row A built: a pointer minus its own table is the slot index. The 50 Entity and 2 Gitem lines go to 0. Six holes stay, four g_items sites that need an Int32 from the Int collection search and two stores of an entity's own number, ruled R11 below. Row B built: a callback store reads its thunk, and the 85 lines go to 5, with the 5 left outside the shape. 39 lines were a clear of the callback to 0, ruled R12. The vehicle info thunks live in a per-stub enum, ruled R13. Five vehicle stubs gained the enum. Row R9 built: the 8 Float against Double lines go to 0 and 217 drafted lines change, ruled R14. Row R8 built: the scratch local in SP_NPC_spawner and two in w_saber are no longer holes.

Gate: build 0 errors, 106 tests in four binaries, bg 103 holes with 0 defects, game 1638 holes with 0 cascade errors and 467 defects. One defect in g_client became visible when row A removed the error that hid it.

### Rulings on the round

| Row | Question | Verdict |
|---|---|---|
| R11 | Slots has no index form of its own. The collection search returns Int, so four g_items sites that need an Int32 and two stores of an entity's own number stay holes. Proposed: a Slots index form that returns Int32 in Sources/JKAShared, a hand change to the views | ratified as a docketed open row |
| R12 | A rule for row B not in the ratified text. A 0 or NULL store into a callback field writes nil. 39 of the 85 lines | ratified as proposed |
| R13 | The vehicle info thunks cannot live in Callbacks.swift, because five vehicle files define private functions of the same name. The skeleton writes a private enum VehicleInfoThunks at the end of each vehicle stub, the view name plus Thunks, derived from the stores in the stem | ratified as proposed |
| R14 | The reading of "the operator that meets the double operand". The wide reading covers comparisons and explicit casts as well as arithmetic, and limits the store conversion to expressions whose C type is double. About 167 comparison lines that compiled before now compare in Double, as C does | ratified as proposed |
