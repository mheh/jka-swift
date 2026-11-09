# The cm body round, the clip map of the dedicated host

This record holds the body round of the seven clip map stems of `Sources/JKAMP_DedLogic`: cm_patch, cm_load, cm_test, cm_trace, cm_terrain, cm_shader, and cm_polylib. The stems port Raven's `oracle/codemp/qcommon/cm_*.cpp`. The tree is the worktree `/tmp/jka-cm` on the branch `ded-bodies-cm`, off master at 7961ee4. The code commit is 353f5ea. The round ran no generator, no draftcheck, and no snapshot tool, because one tool pass runs after the six rounds of this wave merge.

## The bodies

The round filled each stub against the signature that exists. A function with a `TODO: Port signature` marker keeps its marker. A statement that needs a signature, a table row, or a C++ class keeps one Port-note, one `Raven wrote:` line, and its `portMissing` call.

| Stem | `portMissing` before | after | Signature markers | Holes | Dead |
|---|---|---|---|---|---|
| cm_patch | 33 | 20 | 3 | 16 | 1 |
| cm_load | 30 | 8 | 1 | 6 | 1 |
| cm_test | 26 | 4 | 0 | 4 | 0 |
| cm_trace | 23 | 12 | 1 | 11 | 0 |
| cm_terrain | 20 | 14 | 14 | 0 | 0 |
| cm_shader | 9 | 2 | 0 | 2 | 0 |
| cm_polylib | 1 | 1 | 0 | 0 | 1 |

- cm_load, whole: the twelve `CMod_Load*` loaders except two, CM_LumpChecksum, CM_LoadMap_Actual, CM_LoadMap, CM_ModelBounds, CM_LoadSubBSP, and CM_ModelContents.
- cm_load, with a hole: CMod_LoadSubmodels, CMod_LoadPatches, CM_Checksum, CM_ClearMap, and CM_ShutdownTerrain. CM_RegisterTerrain keeps its marker.
- cm_shader, whole: CM_LoadShaderFiles, CM_FreeShaderText, SV_ParseSurfaceParm, CM_SetupShaderProperties, and CM_GetShaderInfo by number. With a hole: CM_ParseShader and CM_GetShaderInfo by name.
- cm_terrain: CM_CircularIterate, CM_ForceHeight, CM_GetAverage, CM_Smooth, CM_MakeAverage, and CM_BelowLevel. The 14 other functions take or return `CCMLandScape *` and keep their markers. The stub had the skeleton header, so the code commit removes it.
- cm_trace, whole: CM_Trace, CM_BoxTrace, CM_TransformedBoxTrace, and 17 trace and test functions. With a hole: CM_PositionTest and CM_TraceThroughTerrain. CM_HandlePatchCollision keeps its marker.
- cm_test, whole: CM_PointLeafnum_r, CM_PointLeafnum, CM_StoreLeafs, CM_BoxLeafnums_r, CM_ClusterPVS, CM_FloodArea_r, CM_FloodAreaConnections, and CM_AdjustAreaPortalState. With a hole: CM_StoreBrushes, CM_BoxLeafnums, and CM_PointContents. CM_BoxBrushes stays a stub.
- cm_patch, whole: CM_ClearLevelPatches, CM_TransposeGrid, CM_SetGridWrapWidth, CM_SubdivideGridColumns, CM_PlaneEqual, CM_FindPlane2, CM_FindPlane, CM_PointOnPlaneSide, CM_ValidateFacet, CM_AddFacetBevels, CM_CheckFacetPlane, and CM_PositionTestInPatchCollide. With a hole: CM_RemoveDegenerateColumns, CM_PatchCollideFromGrid, CM_GeneratePatchCollide, CM_TracePointThroughPatchCollide, and CM_TraceThroughPatchCollide. CM_GridPlane, CM_EdgePlaneNum, and CM_SetBorderInward keep their row T7 markers.
- Dead under rule 20: `pw` of cm_polylib, CM_DrawDebugSurface of cm_patch by row T11, and CM_Checksum, which has no caller in either tree.

Forms of note:

- A loader reads a lump as `Slots<Dshader>(cmod_base!.suffix(from: l.fileofs), count: ...)`, the cast of the cm-load row, through the new initializer of `LumpViews.swift`. Raven's `in++` and `out++` walks are the index `i`. An `int *` lump reads the word subscript, `` `in`[int: i * Int32(Int32.byteCount)] ``. `LittleLong` and `LittleFloat` are the value, by row M3 of the msg round.
- Raven's `drawVert_t` of the vertex lump reads as the view `MapVert`, the record of the same layout at `qfiles.h:506` and `:514`, under one AI line.
- CM_LoadMap_Actual keeps the disk image as a `Slots` of bytes over the Z_Malloc block and the `void *` as its handle, the form of FS_ReadFile. The static `last_checksum` is a property of `EngineWorld` with a forward, and the header is `Dheader.scratch`.
- CMod_LoadEntityString keeps the Hunk_Alloc call for the zone count and stores the text through a CharBuf into the string pool, under one AI line.
- CM_LoadShaderFiles and CM_FreeShaderText take the G_Alloc form of row CM5. `svInfoParms` is a constant Array of `InfoParm` rows, the record `infoParm_t` of `cm_shader.cpp:220`.
- `cmShaderTable` stores the slot of the record in `cmg.shaders`, the offset form of row C5.
- A call of CM_ClipHandleToModel with Raven's default NULL hands a local that the body drops, under one AI line, in CM_ModelBounds, CM_TestBoundingBoxInCapsule, and CM_TraceBoundingBoxThroughCapsule.
- CM_Smooth reads `Foundation.M_PI`, the double literal of Raven's macro, because JKAShared's `M_PI` is a `Float`. This is the form of common.swift.

## The hand pieces

Each piece carries one `// AI:` line or a `Source:` line.

| Piece | Raven's counterpart |
|---|---|
| `Slots.init(_ bytes: Slots<byte>, count:)` in the new `Sources/JKAMP_Ded/LumpViews.swift` | the cast `(dshader_t *)(cmod_base + l->fileofs)` of `cm_load.cpp:81` |
| `CGrid.pointsRows` in the new `Sources/JKAMP_Ded/PatchViews.swift` | `vec3_t points[MAX_GRID_SIZE][MAX_GRID_SIZE]` of `cm_patch.h:115` |
| `PatchCollide.facetsSlots` in `PatchViews.swift` | `facet_t *facets` of `cm_patch.h:98` |
| `TraceWork.startout` and `.getout` in `TraceViews.swift` | the `bool` fields of `cm_local.h:258` and `:259` |
| `EngineWorld.last_checksum` and its forward | `static unsigned last_checksum` of `cm_load.cpp:610` |
| `OpaquePointer.byteCount` in `ByteCount.swift` | `sizeof( cm.surfaces[0] )` of `cm_load.cpp:498` |
| the C integer subscript of `vec4_t` in `Int32Indexing.swift` | the `plane[axis]` stores of `cm_patch.cpp`, the form of the `vec3_t` subscript |
| `Square` and `VectorAdvance` in `q_shared.h.swift` | the macros of `q_shared.h:3005` and `:1370` |
| `edgeName_t` and the four `EN_` constants in cm_patch.swift | the enum of `cm_patch.cpp:971` |
| `svInfoParms` and `InfoParm` in cm_shader.swift | `cm_shader.cpp:220` and `:226` |

## The rows

Each row cites Raven's line and the Swift site. Only a row with no precedent goes to the user.

- Row L1, the leaf index blocks of CMod_LoadSubmodels. Raven stores `indexes - cm.leafbrushes` and `indexes - cm.leafsurfaces`, the distance between two hunk blocks, at `cm_load.cpp:154` and `:161`, and later reads the new block through `cm.leafbrushes`. The port's Hunk_Alloc is Z_Malloc, so the distance can be negative, and the Slots of `leafbrushes` takes no negative index. Swift: the two holes at `cm_load.swift:221` and `:226`. Every map with an inline model stops here, so no map loads before this row closes. A form needs a ruling, for example one hunk block per clip map that holds the lists, or a FIELDS form that allows the pointer difference.
- Row P2, the `points` of CM_GeneratePatchCollide. Raven passes `vec3_t points[MAX_PATCH_VERTS]` at `cm_load.cpp:534` to `vec3_t *points` of `cm_patch.cpp:1163`. The signature at `cm_patch.swift:1209` takes one `inout vec3_t`. Proposal: `[JKAShared.vec3_t]`, the row T3 form. Swift: the holes at `cm_load.swift:647`, `cm_patch.swift:1218`, and `:1240`.
- Row P1, CM_ComparePoints. `float *a, *b` of `cm_patch.cpp:370` is a `Slots<Float>`, and the grid point is a `vec3_t`. Proposal: the PARAMS kind `vec3_const` of row T9. Swift: `cm_patch.swift:429`.
- Row T7, still open. The `gridPlanes` parameters of CM_GridPlane, CM_EdgePlaneNum, and CM_SetBorderInward (`cm_patch.cpp:592`, `:615`, `:675`) keep their markers. The local is a nested `[[[Int32]]]` under one AI line. Swift: the markers at `cm_patch.swift:635`, `:651`, `:667`, and the nine holes of CM_PatchCollideFromGrid at `:1052` to `:1170`. No patch collides before this row closes.
- Row P3, the static `cvar_t *cv` of `cm_patch.cpp:1256` and `:1401`, which has no storage. Swift: `cm_patch.swift:1376`, `:1379`, `:1594`, and `:1597`.
- Row P4, the CGrid view. The generated `points` at `Generated/Views/CGrid.swift:89` holds one row of 129 points. Proposal: views.py gives the two-index form, and `pointsRows` goes.
- Row P5, `facets`. Proposal: the subscript sweep gives `PatchCollide.facetsSlots`, and the hand piece goes.
- Row P6, `edgeName_t`. The skeleton gives no entry for the enum of `cm_patch.cpp:971`, so the hand lines go when the generator writes it.
- Row R1, the `storeLeafs` thunk. Raven stores `CM_StoreLeafs` into `ll.storeLeafs` at `cm_test.cpp:179` and `cm_trace.cpp:465`, and `Generated/Callbacks.swift:8` declares the type with no thunk. Swift: `cm_test.swift:179` and `cm_trace.swift:495`. SV_LinkEntity stays blocked.
- Row R2, the `int leafs[MAX_POSITION_LEAFS]` local of CM_PositionTest at `cm_trace.cpp:449`. Proposal: a BYTE_STORAGE_LOCALS entry, the form of `("leafs", "SV_LinkEntity")`. Swift: `cm_trace.swift:473`, `:492`, and `:510`.
- Row R3, the `vec3pair_t` fields. `bounds` and `localBounds` of `traceWork_t` are `Slots<Slots<Float>>` at `Generated/Views/TraceWork.swift:119` and `:122`, and CM_GenericBoxCollide and CM_CalcExtents take `[vec3_t]` by row T3, so the calls at `cm_trace.cpp:717` and `:758` cannot pass them. Swift: `cm_trace.swift:702` and `:744`.
- Row R4, `cbrush_t **`. CM_BoxBrushes takes `cbrush_t **boxList` at `cm_test.cpp:194` as one `inout Cbrush?`, and CM_StoreBrushes writes through `(cbrush_t **)ll->list` at `cm_test.cpp:110`, where `list` is `Slots<Int32>?`. No caller in the dedicated unit. Swift: `cm_test.swift:111` and `:200`.
- Row S1, the records of CM_GetShaderInfo by name. Raven inserts a Hunk_Alloc record into `cmShaderTable` at `cm_shader.cpp:522`, and the offset form of row C5 has no value for a record outside `cmg.shaders`. Only `CCMLandScape` calls the function (`cm_terrain.cpp:80` and `:98`). Swift: `cm_shader.swift:451`.
- Row S2, the `fogColor` of CM_ParseShader. Raven passes the local `vec3_t` at `cm_shader.cpp:435` to CM_ParseVector, which takes `Slots<Float>` at `cm_shader.swift:265`. Swift: `cm_shader.swift:373`. A shader with `fogParms` stops here.
- Row CM6, still open. The holes that name `TheRandomMissionManager` or a `CCMLandScape` method: `cm_load.swift:892`, `:897`, `:1142`, `cm_test.swift:266`, and `cm_trace.swift:702`, `:722`, `:748`, `:777`, `:782`, and `:786`. CM_ClearMap stops at its RMG hole on every map load.
- The markers CM_RegisterTerrain (`cm_load.cpp:1036`), CM_HandlePatchCollision (`cm_trace.cpp:914`), and the 14 terrain functions of `cm_terrain.cpp:1618` to `:1688` wait on row C, the C++ classes.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | 4 runs. Run 1 stopped at the unsigned `CONTENTS_TRANSLUCENT` in `svInfoParms`, run 2 at a C integer index of a `vec4_t`, run 3 at a loop counter that the scratch closure captured before its store. Run 4 passed, exit 0. The seven stems give 38 warnings, most of them "will never be executed" after a hole. |
| `swift test --no-parallel -j 2` | exit 0, 150 tests in nine runs, 0 failures |

`grep -c Unsafe` gives 0 on the seven stems.
