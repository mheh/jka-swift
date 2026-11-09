# The cm_load and cm_shader round, the clip map loader

This record holds the round of `Sources/JKAMP_DedLogic/cm_load.swift` and `Sources/JKAMP_DedLogic/cm_shader.swift`, the stems of Raven's `oracle/codemp/qcommon/cm_load.cpp` and `cm_shader.cpp`. The tree is the worktree `/tmp/jka-ded-cm` on the branch `dedicated-round-cm-load`, off master at 1cdd22f. The code commit is fa2b965. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The cm_load stub had the skeleton header, so the round adopted it and removed the header in the code commit. The cm_shader stub was already adopted. The drafter gave 15 holes over cm_load and 31 over cm_shader. The hole round filled every body whose signature the skeleton generated. A function with a `TODO: Port signature` marker keeps its marker, because a signature comes only from the generator.

- cm_load, filled: CM_DeleteCachedMap, CM_InlineModel, CM_NumClusters, CM_NumInlineModels, CM_EntityString, CM_SubBSPEntityString, CM_LeafCluster, CM_LeafArea, CM_InitBoxHull, CM_TempBoxModel, CM_FindSubBSP, and CM_GetWorldBounds.
- cm_load, filled with a hole: CM_LoadMap, CM_ClearMap, CM_ModelBounds, CM_ShutdownTerrain, CM_LoadSubBSP, and CM_ModelContents.
- cm_load, signature markers: the twelve `CMod_Load*` loaders, CM_BoundBrush, CM_LumpChecksum, CM_Checksum, CM_LoadMap_Actual, CM_ClipHandleToModel, CM_RegisterTerrain, and CM_ModelContents_Actual.
- cm_shader, filled: CM_CreateShaderTextHash, CM_GetShaderText, CM_LoadShaderText, and CM_ShutdownShaderProperties.
- cm_shader, filled with a hole: CM_FreeShaderText and CM_SetupShaderProperties.
- cm_shader, markers: CM_LoadShaderFiles under a Port-note, SV_ParseSurfaceParm, SV_ParseMaterial, CM_ParseVector, CM_ParseShader, and the two CM_GetShaderInfo overloads.
- Raven's `Com_Memset( &cmg, 0, sizeof( cmg ) )` is `cmg.clear()`, and his `memset(&SubBSP[i], 0, sizeof(SubBSP[0]))` is `SubBSP[i].clear()`, by the memset rule of a whole record.
- Raven's `cmg.name[0] = '\0'` is `cmg.nameBuffer[0] = 0`, the buffer accessor of a `char` array field.
- Raven's `SetPlaneSignbits( p )` over a `cplane_t *` reads the plane out with `p!.plane`, calls the value function of q_math, and writes it back with `p!.apply(plane)`, the bridge of `Sources/JKAShared/Views/Plane.swift`, under one AI line.
- Raven's `char *` returns of CM_EntityString and CM_SubBSPEntityString force unwrap the `String?` field, the rule of a caller that holds an optional where a value is due.
- `shaderTextTable` and `cmShaderTable` take the `Dictionary` form of row C5 of `notes/2026-11-03/dedicated-cxx-docket.md`. The value is `Int32`, the offset type of `TextCursor`, so the body stores `p.offset!` with no conversion. Row C5 wrote `Int`.
- Raven's `if(shaderText)` reads `!shaderText.isEmpty` under an AI line, because the generated variable is a `String`, and a text that CM_LoadShaderFiles builds holds at least one newline.

The two CM_GetShaderInfo stubs each took one Port-note line in the marker body. Without it, draftcheck spliced the draft over both stubs, and the draft drops the parameter, so the mirror gave "invalid redeclaration of 'CM_GetShaderInfo()'". This is the form of row 7 of `notes/2026-11-04/dedicated-open-rows-ledger-2.md`.

## The hand pieces

Each piece carries one `// AI:` line. `Sources/JKAMP_Ded/ClipMapViews.swift` is new, and `Sources/JKAMP_DedLogic/EngineWorld.swift` holds the storage.

| Piece | Raven's counterpart | Note |
|---|---|---|
| `ClipMap`, a view with the counts, `name` and `nameBuffer`, `brushsidesSlots`, `planesSlots`, `leafsSlots`, `leafbrushes`, `cmodelsSlots`, `brushesSlots`, `vised`, `entityString`, `landScape`, and `clear()` | `clipMap_t` of `cm_local.h:161` | `leafbrushes` is a `Slots<Int32>?` of the widest count, the form of a `bytes` field. `landScape` is an `OpaquePointer?`, because `CCMLandScape` stays C++. |
| `ClipMap.record()` and `ClipMap.records(count:)` | `clipMap_t cmg` at `cm_load.cpp:37` and `clipMap_t SubBSP[MAX_SUB_BSP]` at `:60` | one zeroed allocation each, the form of the removed `Zone.record()` |
| `Cbrush`, a view with `shaderNum`, `contents`, `bounds`, `sides`, `numsides`, and `checkcount` | `cbrush_t` of `cm_local.h:68` | |
| `Cbrushside`, a view with `plane` and `shaderNum` | `cbrushside_t` of `cm_local.h:61` | |
| `Cplane[i]` | `box_planes[i]` and `&box_planes[i]` at `cm_load.cpp:962` to `:1007` | the generated `box_planes` variable holds one `Cplane?` |
| `EngineWorld.cmg`, `.SubBSP`, and `.box_brush` | `cm_load.cpp:37`, `:60`, `:52` | |
| `EngineWorld.shaderTextTable` and `.cmShaderTable` | `cm_shader.cpp:29` and `:30` | row C5 |

The world never frees the two clip map allocations, so a test that swaps the world leaks them.

## Rows for the user

- Row CM1, the clip map views. Question: `ClipMapViews.swift` holds hand views of three records that `cm_local.h` declares. Proposal: `clipMap_t`, `cbrush_t`, `cbrushside_t`, `cNode_t`, `cPatch_t`, `cArea_t`, and `CCMShader` join `HOST_ROOTS`, the form of row Z1 of the fifth ledger. `int *leafbrushes`, `int *leafsurfaces`, and `int *areaPortals` take a `FIELDS` row that spells an indexed `int *` as `Slots<Int32>?`. `cmg` becomes an `EngineStorage` record and `SubBSP` an `EngineStorage` table. The hand views, `record()`, `records(count:)`, and the three `EngineWorld` properties go in that commit. The `Cplane` subscript stays, unless `box_planes` takes a `Slots<Cplane>` row.
- Row CM2, the lump parameters. Question: the twelve loaders, CM_LumpChecksum, and CM_Checksum take `lump_t *` or `dheader_t *`, which have no table row. Raven reads each lump at `cmod_base + l->fileofs`. Callers: CM_LoadMap_Actual (`cm_load.cpp:605`). Proposal: `lump_t` and `dheader_t` take views, and `byte *cmod_base` takes the `Slots<byte>` of `FS_ReadFile`, so a loader reads a disk struct as the typed view at `cmod_base.suffix(from: l.fileofs)`, the form of "Typed access at a byte offset". The disk records `dshader_t`, `dmodel_t`, `dnode_t`, `dleaf_t`, `dplane_t`, `dbrush_t`, `dbrushside_t`, `dsurface_t`, and `mapVert_t` join `HOST_ROOTS` for those views.
- Row CM3, the `clipMap_t` parameters. Question: CM_LoadMap_Actual takes `clipMap_t &cm`, CM_ModelContents_Actual takes `clipMap_t *cm`, and CM_ClipHandleToModel takes `clipMap_t **clipMap` and returns `cmodel_t *`. Callers: CM_LoadMap (`:779`), CM_LoadSubBSP (`:1104`), CM_ModelContents (`:1180`, `:1183`), CM_ModelBounds (`:1023`), and the cm_trace and cm_test stems. Proposal: with row CM1, `clipMap_t &` and `clipMap_t *` are `ClipMap` and `ClipMap?` by the record parameter rule, `clipMap_t **` is `inout ClipMap?` with a NULL test as in the row of a pointer to a struct pointer, and the return is `Cmodel`.
- Row CM4, `cbrush_t *` and `CCMShader *`. Question: CM_BoundBrush takes `cbrush_t *b`, and SV_ParseSurfaceParm, SV_ParseMaterial, CM_ParseVector, CM_ParseShader, and CM_GetShaderInfo take or return `CCMShader *`. Proposal: with row CM1, each is the view of its record. `cmShaderTable` keeps the offset of row C5, so CM_GetShaderInfo by name reads the record through a view at that offset.
- Row CM5, the storage of `shaderText`. Question: `char *shaderText` is a generated `String`, so the `Z_Malloc` of CM_LoadShaderFiles (`cm_shader.cpp:135`) and the `Z_Free` of CM_FreeShaderText (`:181`) have no form. CM_LoadShaderFiles also needs FS_ListFiles, whose `char **` return carries a signature marker in files_pc. Proposal: the `G_Alloc` form of `docs/transcription.md`, `_ = Z_Malloc(...)` and a `String` built by the `strcat` lines, with the `Z_Free` dropped under an AI line. The zone count then keeps the block that Raven frees, so the alternative is a `HAND_VARS` entry that keeps the block beside the text.
- Row CM6, the RMG and terrain names. Question: `TheRandomMissionManager` and the methods and destructor of `CCMLandScape` have no Swift name, because row E5 links the RMG and the terrain as C++. Proposal: no change in this round, the precedent of row Z6. The stage that links those files fills the holes.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| CM_LoadMap | `cm_load.swift:384` | the call of CM_LoadMap_Actual | CM3 |
| CM_ClearMap | `:405` | `TheRandomMissionManager` | CM6 |
| CM_ClearMap | `:410` | `delete cmg.landScape` | CM6 |
| CM_ModelBounds | `:603` | the call of CM_ClipHandleToModel | CM3 |
| CM_ShutdownTerrain | `:624` | the `CCMLandScape` methods | CM6 |
| CM_LoadSubBSP | `:649` | the call of CM_LoadMap_Actual | CM3 |
| CM_ModelContents | `:696` | the calls of CM_ModelContents_Actual | CM3 |
| CM_FreeShaderText | `cm_shader.swift:93` | `Z_Free(shaderText)` | CM5 |
| CM_SetupShaderProperties | `:180` | `cmShaderTable.insert(CM_GetShaderInfo(i))` | CM4 |
| CM_SetupShaderProperties | `:188` | CM_GetShaderInfo and CM_ParseShader | CM4 |

CM_ClearMap stops at its RMG hole on every call, the shape of the Hunk_Clear hole of row Z6. CM_LoadMap stops at its hole, so the jampded executable cannot load a map before rows CM1 to CM3 land. The server loop of `SV_SpawnServer` needs that load.

`portMissing` counts: cm_load.swift 26, from 37, which are 19 signature markers and 7 holes. cm_shader.swift 10, from 13, which are 7 markers and 3 holes. `grep -c Unsafe` gives 0 on both files.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The two stems give 7 "will never be executed" warnings, at the statements after the holes. |
| `swift test --no-parallel -j 2` | exit 0, 142 passed, 1 skipped, the interpreter test, 0 failed |
| `draftcheck.py --unit mp-engine-ded --stem cm_load` | exit 0, 27 of 37 hand functions replaced, 10 kept, 15 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem cm_shader` | exit 0, 5 of 13 hand functions replaced, 8 kept, 31 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The holes of the draftcheck lines are in the drafter's output, not in the working tree.
