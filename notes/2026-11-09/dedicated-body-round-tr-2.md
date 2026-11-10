# The second tr round

This record holds the second body round of the seven renderer stems of the host target: `tr_shader`, `tr_model`, `tr_image`, `tr_init`, `tr_main`, `tr_mesh`, and `tr_backend`, all under `Sources/JKAMP_DedLogic`. The tree is the worktree `/tmp/jka-tr-2` on the branch `ded-bodies-tr-2`, off master at 837bc43. The round ran no generator, no draftcheck, and no snapshot tool. The seven stems had no skeleton header. PR 84 gave no hand class file for `tr_model.cpp` other than `CachedEndianedModelBinary_t.swift`, and that file needed no edit.

## The bodies

The bodies follow Raven's text under the `DEDICATED` define. The counts are the `portMissing(` lines of each file, so a body with a hole counts once for each hole.

| Stem | before | after | Filled with no hole |
|---|---|---|---|
| tr_shader | 37 | 24 | KillTheShaderHashTable, ShaderHashTableExists, R_CreateExtendedName, ParseVector, NameToSrcBlendMode, NameToDstBlendMode, NameToGenFunc, ParseWaveForm, ParseSkyParms, ParseSort, ParseMaterial, CollapseMultitexture, FindShaderInShaderText, R_FindShaderByName, R_InitShaders |
| tr_model | 25 | 15 | RE_RegisterModels_GetDiskFile, RE_RegisterModels_LevelLoadEnd, RE_RegisterModels_DumpNonPure, RE_RegisterModels_Info_f, RE_RegisterModels_DeleteAll, RE_RegisterMedia_LevelLoadBegin, R_GetModelByHandle, R_AllocModel, R_ModelInit, R_HunkClearCrap, R_ModelFree, R_Modellist_f |
| tr_image | 7 | 2 | R_Resample, RE_RegisterSkin, RE_RegisterServerSkin, R_InitSkins, R_GetSkinByHandle |
| tr_init | 6 | 1 | `s_numVidModes`, R_GetModeInfo, R_ModeList_f, R_Init, RE_Shutdown |
| tr_main | 2 | 0 | R_CullPointAndRadius, R_LocalPointToWorld |
| tr_mesh | 1 | 0 | ProjectRadius |
| tr_backend | 3 | 0 | `tr_stencilled`, `g_bRenderGlowingObjects`, `g_bDynamicGlowSupported` |

The total goes from 81 to 42. The server load path that the brief names, RE_Shutdown, RE_RegisterMedia_LevelLoadBegin, R_HunkClearCrap, R_InitShaders, R_Init, and R_ModelInit, has no hole.

These bodies have a real body and a hole where a row blocks one line: ClearGlobalShader, R_RemapShader, IsShader, R_FindShader, R_FindServerShader, RE_RegisterShaderLightMap, RE_RegisterShader, RE_RegisterShaderNoMip, RE_ShaderNameFromIndex, R_GetShaderByHandle, RE_InsertModelIntoHash, RE_RegisterServerModel, RE_RegisterModel_Actual, R_ModelBounds, and RE_RegisterIndividualSkin.

- The walks of `CachedModels` sort the keys with `Q_stricmp`, because Raven's `std::map` of `sstring_t` keys walks in that order, and RE_RegisterModels_LevelLoadEnd stops when the pool falls under its limit. The `bEraseOccured` step drops. Raven's `(*CachedModels)[name]` inserts a default entry, so the body inserts one before the read.
- RE_RegisterModels_GetDiskFile copies `FakeGLAFile` into its zone block with a loop, because the table is a Swift array.
- R_Init allocates `backEndData` with Raven's `Hunk_Alloc` and sets `polys` and `polyVerts` at Raven's byte offsets through the cast form of each view.
- R_Resample reads a byte of the source as `Float(raster[i])`, the promotion C does for `byte * float`, because `Promotion.swift` has no operator for `UInt8`. It stores each pixel through the `[byte:]` subscript.
- RE_RegisterSkin and RE_RegisterIndividualSkin read a slice at `strlen - 5` and `strlen - 4`. Raven reads before the buffer for a shorter name, and the slice traps there. Each site carries a rule 19 note.
- FindShaderInShaderText reads `s_shaderText`, the `let ""` the skeleton gives. The dedicated build never sets the text, so the empty String stands for Raven's NULL under a rule 24 line.
- ShaderHashTableExists tests whether the list of hash 0 holds a cursor. Raven tests the pointer of hash 0. In the dedicated build no function fills the table, so both forms give false.
- RE_RegisterServerModel and RE_RegisterModel_Actual write Raven's `goto fail` as a flag `failed` that skips the success arm after the loop, under a Port-note.
- The stale `Row TR1` Port-notes above the stubs that stay are gone. A stub that a new row blocks carries the note of that row.

## The rule 24 sites

- KillTheShaderHashTable, ShaderHashTableExists, and FindShaderInShaderText (tr_shader.cpp:113, :118, :3300): the table is the `[[TextCursor]]` of row TR7.
- R_CreateExtendedName (tr_shader.cpp:187 to :199): the address compares are value compares, by row TR8.
- FindShaderInShaderText (tr_shader.cpp:3308): the empty `s_shaderText` stands for NULL.
- R_FindShader and R_FindServerShader (tr_shader.cpp:3469, :3591): the `memcpy` of `lightmapIndex` is a loop over the Swift array.
- RE_RegisterModels_GetDiskFile (tr_model.cpp:148): the `memcpy` of `FakeGLAFile` is a loop.
- The four `CachedModels` walks and the three `operator[]` reads of tr_model.cpp.

## Rows for the user

- Row TR11, the `styles` lists. R_CreateExtendedName, IsShader, R_FindShader, and R_FindServerShader take `styles` as `Slots<UInt8>` (tr_shader.swift:1043 in this tree), and `stylesDefault` is `[JKAShared.byte]` (tr_shader.swift:186). Raven hands `stylesDefault` at tr_shader.cpp:281, :291, :3739, and :3769, and tr_image.cpp:3093 and :3097. Proposal: a PARAMS kind `byte_array`, `[JKAShared.byte]`, for `styles` of the six functions of row TR8, the byte twin of `int_array` at rulings.py:996 to :998. Holes: RE_RegisterIndividualSkin, R_RemapShader (two), RE_RegisterShader, RE_RegisterShaderNoMip.
- Row TR12, `modelHash_t.handle`. The view's own `handle` hides the field (ModelHash.swift:76 and :77, tr_model.cpp:30). Raven stores it at tr_model.cpp:664 and reads it at :1040, :1213, and :1241. Proposal: a FIELD_NAMES row `("modelHash_t", "handle"): "modelHandle"`, the form of the `pack_t` row at rulings.py:562. Holes: RE_InsertModelIntoHash, RE_RegisterServerModel, RE_RegisterModel_Actual (two).
- Row TR13, the model disk buffer. RE_RegisterModels_GetDiskFile hands `ppvBuffer` as `inout OpaquePointer?` (tr_model.swift:51), and Raven reads `*(unsigned *)buf` at tr_model.cpp:1094 and :1313 and hands `buf` to the loaders. Proposal: PARAMS kind `bytes`, `Slots<JKAShared.byte>?`, for `ppvBuffer`, the type `pModelDiskImage` of `CachedEndianedModelBinary_t` already has, with a `Slots` form of FS_ReadFile beside the `CharBuf` forms of files_pc.swift:1415 and :1548. Holes: RE_RegisterServerModel, RE_RegisterModel_Actual.
- Row TR14, a record at a byte offset of another record. `md3Frame_t` stands at `ofsFrames` from `md3Header_t` (tr_model.cpp:1832), and the tags at `ofsTags` (tr_model.cpp:1753). Proposal: an initializer of the record Slots at a byte offset of a view, the form of `(dshader_t *)(cmod_base + l->fileofs)` at LumpViews.swift:11. Holes: R_ModelBounds, R_GetTag.
- Row TR15, the C++ `bool` fields of the C_STRUCT_CLASSES records. `shader_t.defaultShader` and seven more of `shader_t`, `shaderStage_t.active`, `glow`, and `isDetail`, four of `textureBundle_t`, and two of `image_t` have no accessor (Shader.swift:113, ShaderStage.swift:65, tr_local.h:472). Proposal: views.py reads a `_Bool` field as `Bool`, the form of the TYPES `Bool` rows of row TR3. Holes: IsShader, R_FindShader (two), R_FindServerShader, RE_RegisterShaderLightMap.
- Row TR16, `tr.shaders` and `tr.sortedShaders`. `shader_t *shaders[MAX_SHADERS]` and `sortedShaders` (tr_local.h:1406, :1407) have no accessor (TrGlobals.swift:365, :369). Proposal: `Slots<Shader?>` of MAX_SHADERS, the form of `models` at TrGlobals.swift:341. Holes and stubs: RE_ShaderNameFromIndex, R_GetShaderByHandle, SortNewShader, GeneratePermanentShader.
- Row TR17, the `texMods` storage. Raven's `texModInfo_t texMods[MAX_SHADER_STAGES][TR_MAX_TEXMODS]` (tr_shader.cpp:102) holds MAX_SHADER_STAGES rows, and the storage holds MAX_SHADER_STAGES records (EngineStorage.swift:323). ClearGlobalShader stores row `i` into `stages[i].bundle[0].texMods` at tr_shader.cpp:241. Proposal: the storage takes MAX_SHADER_STAGES times TR_MAX_TEXMODS records, and a row reads `texMods.suffix(from: i * TR_MAX_TEXMODS)`, the form of the flat two-dimensional tables. Hole: ClearGlobalShader.
- Row TR18, NameToAFunc. The function returns `unsigned` (tr_shader.cpp:358), and GLS_ATEST_GT_0, GLS_ATEST_LT_80, and GLS_ATEST_GE_80 import as `Int32` while GLS_ATEST_GE_C0 imports as `UInt32` (tr_local.h:1676 to :1679). Proposal: a RETURNS row that gives NameToAFunc `Int32`, with `GLS_ATEST_GE_C0` spelled as the complement form of the unsigned hex mask rule. Stub: NameToAFunc.
- Row TR19, `infoParms`. `infoParm_t` is a struct of tr_shader.cpp:2221 to :2225 with Raven's 30 rows at :2228 to :2266, and the stub has the marker "No view for `infoParm_t`". Proposal: the struct goes to `ded_types.h`, and `tables.py` copies the rows into `ded_tables.c`, the form of `r_vidModes` of row TR4. Stub: ParseSurfaceParm.
- Row TR20, RE_RegisterModels_StoreShaderRequest (tr_model.cpp:70). Raven subtracts the disk image address from `psShaderName` and `piShaderIndexPoke` at :87 and :88, and the stub takes a `String` and an `inout Int32`. Proposal: both parameters cross as `Int32` byte offsets into `pModelDiskImage`, the pointer-into-a-buffer rule of the transcription doc. Stub: RE_RegisterModels_StoreShaderRequest.

The `TODO: Port signature` stubs stay as the generator left them: RE_RegisterModels_Malloc (tr_model.cpp:179), RE_RegisterServerModels_Malloc (:253), ServerLoadMDXA (:683), ServerLoadMDXM (:799), and R_LoadMD3 (:1427) for `qboolean &` and the `void *` return, and R_LerpTag (:1768) for `orientation_t *`. RE_RegisterServerModel and RE_RegisterModel_Actual call the loaders inside the hole of row TR13. LoadTGA and GetRefAPI stay dead under row TR9.

## Not ported in this round

ParseTexMod, ParseSurfaceSprites, ParseSurfaceSpritesOptional, ParseStage, ParseDeform, ParseShader, FinishShader, and RE_RegisterShaderFromImage keep their stubs. The round did not read them line by line. In the dedicated build, ParseShader and the parsers run only when FindShaderInShaderText finds a text, and no function of the build fills that text.

## The checks

`swift build -j 2` exited 0 on the first run and on the second run, after three more parser bodies. The seven stems give 16 warnings: four deprecation warnings of the Darwin `M_PI` in Lanczos3 from the first round, seven "will never be executed" warnings after a hole, two `loaded` never mutated, because the store sits in a hole, one `header` never read in R_ModelBounds, and the unused results of RE_RegisterModels_LevelLoadEnd and FS_ReadFile, which are Raven's lines. `swift test --no-parallel -j 2` exited 0: 150 tests in 9 runs passed, and 0 failed.
