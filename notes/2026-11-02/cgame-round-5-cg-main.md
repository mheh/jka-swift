# The cgame transcription rounds, round 5, cg_main

The record of the fifth cgame transcription round on 2026-11-02, one stem, `cg_main`, on the branch `cgame-round-5-cg-main` off master `e2db1a5`.

## The first adoption

Draft gate of the stem: 81 of 81 replaced, 228 holes, 0 cascade errors, 0 defects, 78 compile holes over 6 passes. Adopted at 8328060 with 228 Port-notes. The docket holds tool rows R31 to R43, the storage row R44, the scope row R45, and the hand groups H1 to H10.

Three hand commits come before the tools. 752277e computes the bg_pmove pitch product in float, as Raven's `0.75f` product does, and closes R18 of the round 2 record. 1cc9dad gives `AnglesToAxis`, `AxisClear`, `AxisCopy`, and `MatrixMultiply` a forward under Raven's name that takes the output as `Slots<vec3_t>`, so the eight `AnglesToAxis` sites of cg_players drop their copies and the CG_GetTagWorldPosition note closes. 1346999 closes the cg_players notes of shapes A, B, C, E, G, H, and K, and the hand parts of I and J. The ledger at 10f2832, `notes/2026-11-02/open-rows-ledger.md`, records the proof, the ruling, and the commit of each open row of the round records.

## Rows R17 and R30 to R45

Ruled by the coordinator under the user's delegation on 2026-11-02, each proved by an investigator at its lines before the change. Each row commit gives the cg_main gate over the stub, holes and compile holes.

- R17. A `DEAD` table in `rulings.py` names CG_ParticleExplosion, and the skeleton and the drafter write the dead note line above the marker pair, so the gate counts no hole. The cg_marks gate: 25 of 28 replaced, 3 kept, 8 holes, 0 compile holes. Commit 0b2065d.
- R36. A static `char[N]` that the function returns, or that a fill writes first, drafts as a local CharBuf of Raven's bound. Gate 210 holes, 79 compile holes. Commit e61abcb.
- R30. Raven's `if (!p) continue`, `break`, or `return` over an optional offset local drafts as `guard var p` or `guard let p`, in a block inside the block that declares the local. Gate 210 holes, 79 compile holes. Commit 48247c4.
- Shape D. The text sweep's clause 8 follows a local set from `Q_strrchr` or `strchr` of the parameter, so CG_HandleAppendedSkin takes `inout CharBuf`, both callers pass `&modelName`, and its three notes close. The cg_players gate: 55 of 85 replaced, 30 kept, 68 holes, 0 compile holes. Commit f76f43a.
- Shapes I and J. The re-export spells a shift of a literal as `Int32`, and the record size test takes a `sizeof` of a sibling field of the same type, so Raven's memset of `pe.torso` drafts as `clear()`. Gate 210 holes, 79 compile holes. Commit a7f58af.
- R31. A BYTE_STORAGE_FIELDS row names `cg_t.sharedBuffer`, and the PARAMS row of `trap_CG_RegisterSharedMemory` gives the trap the raw address, so the engine no longer reads a freed copy. Gate 179 holes, 67 compile holes. Commit 4e67634.
- R32. The callee lookup of the drafter reads the signature and the return in the run's view target first, so a cgame body takes the cgame trap. Gate 151 holes, 67 compile holes. Commit c2594cf.
- R33. The R24 arm compares the Slots element of the parameter with the Swift spelling of the field's element too, so `cg.snap->areamask` passes as `Slots<UInt8>`. Gate 151 holes, 67 compile holes. Commit 21d94e5.
- R34. A `float *` local whose every store points into one file-scope float array is an index into that array. Gate 131 holes, 67 compile holes. Commit d7fae8b.
- R35. The overlay maps `VectorScaleVector(a, b, c)` to `c = a * b`. Gate 127 holes, 67 compile holes. Commit d2826c6.
- R37. A byte index on a `String` parameter, a row of a `[String]` table, or a `char name[N]` field reads through CharBuf or the field's Buffer accessor. Gate 124 holes, 61 compile holes. Commit c5b546e.
- R38. A cast to `const char **` of a cursor passes the cursor, and the cursor sweep reads through that cast. Gate 120 holes, 61 compile holes. Commit 3dafa55.
- R39. A PARAMS kind `view` gives CG_SetScoreSelection its `void *p` as `MenuDef?`. Gate 118 holes, 60 compile holes. Commit c4be309.
- R40. `tables.py` writes `cg_spawnFields` to `Sources/CJKAMP_CGame/cg_tables.c`, and the cgame view target reaches it as a `Slots<BgField>`. Gate 117 holes, 60 compile holes. Commit ef92161.
- R41. A run method of a view spells a `const char *` parameter as `String` in a `withCString` scope, and a `vec4_t` parameter as `vec4_t`. The row also covers a `const float *` that is not a `vec3_t`. Gate 113 holes, 56 compile holes. Commit ae8a3e5.
- R42. A NIL_OVERLOADS row on the buffer of `trap_GetEntityToken` gives the trap a second overload, so `trap_GetEntityToken(nil, -1)` rewinds the entity string. Gate 112 holes, 55 compile holes. Commit ce4bc41.
- R45. The cgame row of `project.toml` borrows `codemp/ui/ui_shared.c` with the jka-rust path `uishared/src`. The generator sequence wrote the stub `Sources/JKAMP_CGameLogic/ui_shared.swift`, 316 functions with 40 signature markers, and its manifest with 310 jka-rust matches. The stub stays a stub. Commit 6ea8bf2.
- The README sentence. The `draftcheck.py` entry says that a row gate runs over the stub of the stem, and that the readoption count is the stub count. Commit 0878612.

R43 and R44 took no tool change. The hole round wrote their thunks and properties by hand.

Two more commits support the rows. fe3c903 names ui_shared.c in the cgame row test of `test_unit.py`. 25e9abb is the rule 15 signature commit, which gives CG_SetScoreSelection `MenuDef?` and the cg_spawnFields stub its C storage note.

The snapshot against the cache of master moves these files. R36 moved ai_wpnav, g_client, g_main, g_utils, and q_shared toward the hand text. R30 moved BotAI of ai_main. R33 moved CalculateRanks of g_main, which now passes `level.sortedClients` to qsort. R37 moved 105 lines in ai_util, bg_saga, g_cmds, g_session, g_spawn, g_svcmds, g_trigger, and g_utils. R42 moved the 9 lines of the new overload in the game traps. R45 gave `CGameStorage.swift` and `CGameVariables.swift` the ui_shared variables.

The cg_main stub was readopted at d45785a with the signature of 25e9abb. The draft gate reported `cg_main: 81 of 81 hand functions replaced, 0 kept, 96 holes, 0 cascade errors, 0 defects, 39 compile holes over 3 passes`, and the file took 96 Port-notes, so 96 is the count the hole round starts from. The build and the tests pass at the readoption.

The findings of the rows:

- The gate base. The `splices` table keeps one hash per function, so a row gate over an adopted file keeps the earlier text of a function that an earlier row changed. The ledger records the proof.
- R42's row keys on the trap name, so the game trap `trap_GetEntityToken` took the same overload.
- One generator sequence failed, because the probe build ran over a broken file and reset `be_aas.swift`. We restored the file and ran the sequence again on a tree that builds.
- R41 extends past the docket to a `const float *` that is not a `vec3_t`.
- R30's side finding. The R3 tuple form of `trap_BotGetServerCommand` does not reach a `while` test, as in BotAI.

## The hole round

Commit d77d7e6 closed 84 of the 96 notes by the hand forms of the docket. The four prints keep Raven's 1024-byte buffer with `strcpy` and `JKAShared.format`. The `cvarTable` walks read `cvarTable[cvIndex]` in the game form, and `cvarTableSize` is the count of the hand array. `drawTeamOverlayModificationCount`, `sb_nums`, `sb_t_nums`, `sb_c_nums`, and `HolocronIcons` are five properties of CGameWorld with forwards in cg_main.swift. The item sound walks use a TextCursor with `Int32` offsets and `strncpy`. The MiscEnts and cg_permanents stores write the store and then the step. The axis calls use the Slots forward of `AnglesToAxis`. CG_ConfigString and CG_AddSpawnVarToken read the buffer at the offset. The handle outputs store element 0 of the Slots. DisplayContextDefThunks holds 24 new thunks in the c7012d1 form. The commit adds no AI line.

The commits 40adfda to 69804dd closed the last 12 notes:

- 40adfda, 4345dff, and 8eab685 take the H5 rows. CG_StrPool_Alloc returns raw, CG_NewString returns pooled_string, and `cg_strPool` is a HAND_VARS entry. The bodies take the G_Alloc and G_NewString form, with the rule 24 line on the allocation and the AI line of memoryPool on the forward.
- 3c5b109 gives PC_String_Parse the PARAMS kind out_string, so the ui_shared stub takes `inout String`. cf696d1 passes a String local for cursorStr.
- 7f91f5b fills a `vec4_t` copy of shadowColor for PC_Color_Parse and stores the four floats back before the test.
- a6ca4c9 adds the getCVarString thunk, which copies the trap's String into the caller's C buffer with `store(_:at:capacity:)`.
- 2eec39c writes Raven's initializer 0 into the `cgWeatherOverride` let, because no cgame body assigns it.
- 69804dd names `cg_strPool` in the HAND_VARS doc line.

cg_main.swift holds 0 Port-notes and 0 `portMissing` lines. The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

A finding of the follow-up: when the ui_shared body of PC_String_Parse is ported, it must unwrap the `String?` of `String_Alloc` into the `inout String`.

## The rows left open

- The R3 tuple form does not reach a `while` test. The BotAI draft of ai_main shows it.
- The `CG_G2PlayerAngles` copy site stays a copy and store-back, because its callee is not one of the four axis forwards.
- ui_shared is the next stem. Its stub holds 316 functions, and its rounds take one PR per part.
