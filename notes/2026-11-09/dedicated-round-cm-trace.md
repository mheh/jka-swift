# The cm_trace, cm_test, and cm_patch round, the clip map collision

This record holds the round of `Sources/JKAMP_DedLogic/cm_trace.swift`, `cm_test.swift`, and `cm_patch.swift`, the stems of Raven's `oracle/codemp/qcommon/cm_trace.cpp`, `cm_test.cpp`, and `cm_patch.cpp`. The tree is the worktree `/tmp/jka-ded-cmtrace` on the branch `dedicated-round-cm-trace`. The round started off master at 1cdd22f with the cm_load branch on a throwaway local merge. That branch landed in master as PR 77 during the round, so the branch took `git merge master` at 5c71cb9, a fast-forward, and the gate ran on that tree. The code commit is 43fd338. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The three stubs had the skeleton header, so the round adopted them and removed the header in the code commit. The drafter gave 16 holes over cm_trace, 35 over cm_test, and 34 over cm_patch, with 26 compile holes among them. The round spliced every draft and then filled each hole that a ruled form or a hand accessor of this round covers. A function with a `TODO: Port signature` marker keeps its marker, because a signature comes only from the generator.

- cm_trace, whole: RotatePoint, TransposeMatrix, CreateRotationMatrix, CM_ProjectPointOntoVector, CM_DistanceFromLineSquared, CM_VectorDistanceSquared, SquareRootFloat, and CM_CullBox.
- cm_trace, filled with a hole: CM_BoxTrace and CM_TransformedBoxTrace, each at the call of CM_Trace.
- cm_test, whole: CM_TransformedPointContents, CM_AreasConnected, and CM_WriteAreaBits.
- cm_test, filled with a hole: CM_PointLeafnum, CM_BoxLeafnums, CM_PointContents, and CM_AdjustAreaPortalState.
- cm_patch, whole: CM_SignbitsForNormal, CM_PlaneFromPoints, CM_NeedsSubdivision, CM_Subdivide, CM_ComparePoints, and CM_SnapVector.
- cm_patch, filled with a hole: CM_ClearLevelPatches, CM_FindPlane2, CM_FindPlane, CM_PointOnPlaneSide, CM_CheckFacetPlane, and CM_DrawDebugSurface.
- The signature markers stay: 21 in cm_trace, 8 in cm_test, and 15 in cm_patch.

Forms of note:

- CM_TransformedBoxTrace opens `Sphere.scratch` around the whole body, because Raven's `sphere_t sphere` is a stack record. Raven's `(qboolean)capsule` reads `capsule != 0`. The NULL guards of `mins` and `maxs` drop, because the signature holds both as values.
- CM_CullBox reads Raven's walk pointer `frust` as the index `i`, through the `Cplane` subscript of `ClipMapViews.swift`.
- SquareRootFloat reads the bits of the float as a 32-bit word under a rule 19 note. Raven's `*(long *)&y` reads 8 bytes on an lp64 host.
- CM_PlaneFromPoints builds the normal in a `vec3_t` and writes it back into the `vec4_t` before either return, the form of `PlaneFromPoints` of q_math, under one AI line.
- CM_PointContents reads `local` as a `ClipMap?`, `b` as a `Cbrush`, and `b->sides[i].plane` as `b.sides![i].plane!`. Raven's `_XBOX` arms drop.
- CM_WriteAreaBits reads `buffer[i>>3] |= 1<<(i&7)` as `buffer[byte: i >> 3] |= 1 << (i & 7)`, the byte store rule of the fifth ledger.

## The hand pieces

`Sources/JKAMP_Ded/TraceViews.swift` is new. Each piece carries one `// AI:` line.

| Piece | Raven's counterpart | Note |
|---|---|---|
| `Sphere`, a view with `use`, `radius`, `halfheight`, `offset`, and `scratch` | `sphere_t` of `cm_local.h:230` | the form of the `Cbrush` hand view |
| `CArea`, a view with `floodnum` and `floodvalid` | `cArea_t` of `cm_local.h:99` | |
| `ClipMap.areasSlots` | `cArea_t *areas` of `cm_local.h:200` | the generated `<name>Slots` form |
| `ClipMap.areaPortals` | `int *areaPortals` of `cm_local.h:201` | a `Slots<Int32>?` of the widest count, the form of `leafbrushes` |
| `Cbrushside[i]` | `b->sides[i]` at `cm_test.cpp:269` | the form of the `Cplane` subscript |
| `Com_Memset(_: Slots<byte>, _: Int32, _: some BinaryInteger)` | `Com_Memset` of `common.cpp:1820` at `cm_test.cpp:559` | the form of the `CharBuf` overload of `CommonViews.swift` |

## Rows for the user

Each row cites the Raven line, the C type, and the callers, and proposes the form of the nearest existing pattern.

- Row T1, `traceWork_t`. Question: 19 functions take `traceWork_t *tw`, `const traceWork_t *tw`, or `struct traceWork_s *tw` (`cm_local.h:238`), and CM_Trace declares the record on its stack. Callers: CM_Trace (`cm_trace.cpp:1577`) and the trace and test functions of cm_trace.cpp, cm_patch.cpp, and cm_terrain.cpp. Proposal: `traceWork_t` joins `HOST_ROOTS`, so the view `TraceWork` is generated, a parameter is that view, and the local of CM_Trace is `TraceWork.scratch`. `trace_t &trace` is the `Trace` view by the record parameter rule. `cbrush_t *`, `cLeaf_t *`, and `cbrushside_t *` are their views by row CM1 of the cm_load round.
- Row T2, `sphere_t *` of CM_Trace (`cm_trace.cpp:1577`). Callers: CM_BoxTrace (`:1839`) passes NULL, and CM_TransformedBoxTrace (`:1923`) passes `&sphere`. Proposal: `sphere_t` joins `HOST_ROOTS`, the hand view `Sphere` goes in that commit, and the parameter is `Sphere?` by the NULL sweep. CM_BoxTrace and CM_TransformedBoxTrace then fill their one hole each.
- Row T3, `vec3pair_t`. Question: CM_GenericBoxCollide, CM_CullWorldBox, and CM_CalcExtents take `vec3pair_t`, `typedef vec3_t vec3pair_t[2]`. Callers: CM_TraceThroughBrush and CM_TraceThroughLeaf of cm_trace.cpp. CM_CullWorldBox has no caller in the dedicated unit. Proposal: a `const vec3pair_t` is `[vec3_t]` by value, and a written one, `bounds` of CM_CalcExtents, is `inout [vec3_t]`, the row of a `vec3_t name[3]` parameter.
- Row T4, `leafList_t` and the box lists. Question: CM_StoreLeafs, CM_StoreBrushes, and CM_BoxLeafnums_r take `leafList_t *ll` (`cm_local.h:266`), CM_BoxLeafnums and CM_BoxBrushes declare it on the stack, and its `int *list` holds the caller's array. CM_BoxLeafnums takes `int *boxList` as one `inout Int32`, and CM_BoxBrushes takes `cbrush_t **boxList`. Callers: SV_LinkEntity (`sv_world.cpp:280`) for CM_BoxLeafnums, and none in the dedicated unit for CM_BoxBrushes. Proposal: `leafList_t` joins `HOST_ROOTS` with a `FIELDS` row that spells `list` as `Slots<Int32>?` and `storeLeafs` as a callback field. `int *boxList` takes the `Slots<Int32>` of a host scalar pointer that a body indexes, and the `int leafs[MAX_TOTAL_ENT_LEAFS]` local of SV_LinkEntity takes a `BYTE_STORAGE_LOCALS` home.
- Row T5, the `byte *` return of CM_ClusterPVS (`cm_test.cpp:351`). Callers: `sv_snapshot.cpp:334` and `:493`, and `sv_game.cpp:223` and `:257`. Proposal: `byte *visibility` of `clipMap_t` takes the `FIELDS` kind `bytes`, and the return is `Slots<byte>`, so the body reads `cmg.visibility!.suffix(from: cluster * cmg.clusterBytes)`.
- Row T6, the `clipMap_t` parameters of cm_test and cm_trace. Question: CM_PointLeafnum_r takes `clipMap_t *local`, CM_FloodArea_r and CM_FloodAreaConnections take `clipMap_t &cm`, and CM_TestInLeaf, CM_TraceThroughLeaf, CM_TraceToLeaf, and CM_TraceThroughTree take `clipMap_t *local`. Callers: CM_PointLeafnum (`cm_test.cpp:50`), CM_PointContents (`:244`, `:255`), CM_AdjustAreaPortalState (`:499`), and CM_LoadMap_Actual (`cm_load.cpp:764`). Proposal: the `ClipMap` view by row CM3 of the cm_load round.
- Row T7, `cGrid_t`. Question: CM_TransposeGrid, CM_SetGridWrapWidth, CM_SubdivideGridColumns, CM_RemoveDegenerateColumns, CM_EdgePlaneNum, CM_SetBorderInward, and CM_PatchCollideFromGrid take `cGrid_t *grid` (`cm_patch.h`), and CM_GeneratePatchCollide declares it on the stack. CM_GridPlane, CM_EdgePlaneNum, and CM_SetBorderInward take `int gridPlanes[MAX_GRID_SIZE][MAX_GRID_SIZE][2]`. Callers: CM_GeneratePatchCollide and CM_PatchCollideFromGrid of cm_patch.cpp. Proposal: `cGrid_t` joins `HOST_ROOTS`, the local is `CGrid.scratch`, and `gridPlanes` takes a `BYTE_STORAGE_LOCALS` home of `Slots<Int32>` with a three-index subscript on the view target.
- Row T8, the patch collide records and their storage. Question: `static patchPlane_t planes[MAX_PATCH_PLANES]` (`cm_patch.cpp:431`), `static facet_t *facets` (`:435`), `debugPatchCollide` (`:89`), and `debugFacet` (`:90`) have no storage, and CM_GeneratePatchCollide returns `struct patchCollide_s *` from the hunk. Callers: CMod_LoadPatches (`cm_load.cpp:534`) stores the return in `cPatch_t.pc`. Proposal: `patchPlane_t`, `facet_t`, `patchCollide_t`, and `cPatch_t` join `HOST_ROOTS`, `planes` is an `EngineStorage` table, `facets` a `Slots<Facet>?` variable, the two debug pointers `PatchCollide?` and `Facet?` variables, and the return a `PatchCollide` view over a `Hunk_Alloc` block.
- Row T9, the `float *` and `float[4]` parameters of cm_patch. Question: the table gives `float *p1`, `*p2`, `*p3` of CM_FindPlane (`cm_patch.cpp:517`) and `float *p` of CM_PointOnPlaneSide (`:570`) as one `inout Float`, `float plane[4]` of CM_FindPlane2 (`:489`) as `[Float]`, and `float plane[4]` of CM_CheckFacetPlane (`:1346`) as `Slots<Float>`, and each body hands the pointer to DotProduct as a vector. CM_PlaneEqual (`:440`) carries a marker for `patchPlane_t *p`. Callers: CM_PatchCollideFromGrid, CM_SetBorderInward, CM_ValidateFacet, CM_AddFacetBevels, and CM_TraceThroughPatchCollide. Proposal: a read-only `float *` that a body hands to a vector macro is `vec3_t` by value, the row of a `const vec3_t`, and a `float[4]` plane is `vec4_t`, the type CM_PlaneFromPoints already takes.
- Row T10, a Com_Memset of a value over a Slots of bytes. Filled by the hand overload of the table above. Proposal: keep it, or move it to `CString.swift` beside the `Com_Memcpy` overloads of row 1 of the second ledger.
- Row T11, CM_DrawDebugSurface (`cm_patch.cpp:1651`). Question: its static `cvar_t *cv` and `*cv2` have no storage, `drawPoly` takes an `inout Float` where Raven passes `float *points`, and BotDrawDebugPolygons has no Swift name. Callers: R_DebugGraphics of the renderer (`tr_main.cpp:1583`) alone, so the dedicated unit never calls it. Proposal: the dead-function note of rule 20 for the dedicated unit, and no storage.
- Rows CM3 and CM6 of the cm_load round also hold holes here: CM_ClipHandleToModel in CM_PointContents, and the methods of `CCMLandScape` in CM_PointContents and CM_TraceThroughTerrain.

## The open holes

| Function | Hole | Row |
|---|---|---|
| CM_BoxTrace | the call of CM_Trace | T2 |
| CM_TransformedBoxTrace | the call of CM_Trace | T2 |
| CM_PointLeafnum | the call of CM_PointLeafnum_r | T6 |
| CM_BoxLeafnums | `leafList_t ll` and its 11 statements | T4 |
| CM_PointContents | CM_ClipHandleToModel, CM_PointLeafnum_r twice, and `GetWaterHeight` | CM3, T6, CM6 |
| CM_AdjustAreaPortalState | the call of CM_FloodAreaConnections | T6 |
| CM_ClearLevelPatches | `debugPatchCollide` and `debugFacet` | T8 |
| CM_FindPlane2 | CM_PlaneEqual, and the store into `planes` | T8, T9 |
| CM_FindPlane | CM_PlaneFromPoints, the reads of `planes`, and the store into `planes` | T8, T9 |
| CM_PointOnPlaneSide | `float *plane` into `planes` | T8 |
| CM_CheckFacetPlane | the two DotProduct reads of `plane` | T9 |
| CM_DrawDebugSurface | the statics, the facet walk, and `drawPoly` | T8, T11 |

The goal of the wave stays open. No trace reaches the brush tree before rows T1, T2, and T6 land, and no patch collides before rows T7 to T9 land. `SV_LinkEntity` stops at row T4 and the snapshot at row T5.

`portMissing` counts: cm_trace.swift 23, from 31, which are 21 signature markers and 2 holes. cm_test.swift 26, from 15, which are 8 markers and 18 holes. cm_patch.swift 44, from 27, which are 15 markers and 29 holes. The count rises in cm_test and cm_patch, because the drafter puts one hole on each statement it cannot place, where the stub had one marker per function. `grep -c Unsafe` gives 0 on all three files.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The three stems give the "will never be executed" warnings after the holes and the unused-local warnings of CM_DrawDebugSurface. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests, 0 failures |
| `draftcheck.py --unit mp-engine-ded --stem cm_trace` | exit 0, 27 of 31 hand functions replaced, 4 kept, 12 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem cm_test` | exit 0, 9 of 15 hand functions replaced, 6 kept, 31 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem cm_patch` | exit 0, 20 of 27 hand functions replaced, 7 kept, 16 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The holes of the draftcheck lines are in the drafter's output, not in the working tree.
