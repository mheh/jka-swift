# The tr round

This record holds the body round of the seven renderer stems of the host target that build under `DEDICATED`: `tr_shader`, `tr_model`, `tr_image`, `tr_init`, `tr_main`, `tr_mesh`, and `tr_backend`, all under `Sources/JKAMP_DedLogic`. The tree is the worktree `/tmp/jka-tr` on the branch `ded-bodies-tr`, off master at 7961ee4. The round ran no generator, no draftcheck, and no snapshot tool. The seven stubs had the skeleton header, so the code commit removes the header from each.

## The bodies

The host target has no C header and no view for any record of `tr_local.h`. So `tr`, `backEnd`, `shader`, `stages`, the skins, the models, and the images have no Swift name, and most bodies of the seven stems read one of them. The round fills each stub whose body reads none of them, and it writes Raven's body with a hole where one line reads such a record.

| Stem | `portMissing` before | after | Filled |
|---|---|---|---|
| tr_shader | 42 | 37 | `g_strGlowVShaderARB`, `g_strGlowPShaderARB`, `lightmapsVertex`, `lightmapsFullBright`, generateHashValue |
| tr_model | 30 | 25 | GetModelDataAllocSize, RE_RegisterMedia_GetLevel, RE_RegisterMedia_LevelLoadEnd, generateHashValue, RE_RegisterModel, R_SVModelInit |
| tr_image | 11 | 7 | R_InvertImage, Lanczos3, RE_SplitSkins, CommaParse |
| tr_init | 8 | 6 | AssertCvarRange, R_Register |
| tr_main | 4 | 2 | `s_flipMatrix`, R_CullLocalPointAndRadius |
| tr_mesh | 1 | 1 | none |
| tr_backend | 1 | 0 | `s_flipMatrix` |

The total goes from 97 to 78. The round filled 20 stubs, and RE_RegisterMedia_LevelLoadBegin has two holes where its stub had one marker.

- The two glow shader texts are Raven's string literals as hex character codes, after the C line splices of the CRLF file, with the NUL. The vertex text has 1048 bytes and the pixel text has 524.
- The two hash functions take the form of `FS_HashFileName` of files_pc.swift. The tr_shader one keeps the `PATH_SEP` test and the fold of `hash >> 10` and `hash >> 20`, and the tr_model one has neither, as Raven wrote them.
- CommaParse walks the `TextCursor` in the form of `COM_ParseExt` of q_shared.c.swift. Raven's `static char com_token[MAX_TOKEN_CHARS]` is a local `CharBuf`, because the function returns a `String` and Raven clears the buffer at entry. The comment at the declaration says this.
- RE_SplitSkins walks `name` with byte offsets. Each `strchr` from a pointer into the buffer searches the suffix and adds the offset back, and `strcat` takes the suffix `CharBuf`. Raven's `assert` drops.
- R_InvertImage takes the zone block of `Z_Malloc` as a `Slots<UInt8>` over its bytes, the form of FS_ReadFile, and the walks of `newData` and `oldData` are byte offsets. Raven's `memcpy` is `Com_Memcpy` over the two `Slots`.
- Lanczos3 writes `M_PI_OVER_3` as its expansion with one comment at the site, and the products run in `Double`, because Raven's `M_PI` is the double of math.h. The Darwin `M_PI` that the double context picks gives a deprecation warning, as it does in g_misc.swift.
- R_Register is Raven's text under the WinDed defines: the `#else` arms of `__linux__`, `_XBOX`, and `__MACOS__`, and no `_DEBUG` line. The `#ifndef DEDICATED` commands drop.
- RE_Shutdown removes Raven's twelve commands, then holds a hole at `tr.registered = qfalse`.
- RE_RegisterMedia_LevelLoadBegin holds a hole at `tr.numBSPModels = 0` and a hole at the static local `sPrevMapName`. R_HunkClearCrap calls KillTheShaderHashTable, then holds one hole for the four stores into `tr` and `mhHashTable`. R_InitShaders holds a hole at the memset of `hashTable`, then stores `deferLoad`.

## The rule 24 sites

- R_Register (tr_init.cpp:1150, :1151): Raven formats `MAX_POLYS` and `MAX_POLYVERTS` of tr_local.h:2256 and :2257, which have no re-export in the host target. The calls format the values 600 and 3000. This is the form of the sixth ledger for `lightmapsNone` and `lightmaps2d`.
- `lightmapsVertex` and `lightmapsFullBright` (tr_shader.cpp:141, :149): the tables hold -3 and -2, the values of `LIGHTMAP_BY_VERTEX` and `LIGHTMAP_WHITEIMAGE` of tr_local.h:432 and :433, in the same form.
- R_InvertImage (tr_image.cpp:2318 to :2330): the `byte *` walks are byte offsets into the Slots, each `memcpy` is `Com_Memcpy` over Slots, and `Z_Free` takes the handle of the block.

## Rows for the user

- Row TR1, the renderer records. Question: `tr_local.h` declares `trGlobals_t`, `shader_t`, `shaderStage_t`, `texModInfo_t`, `waveForm_t`, `skin_t`, `skinSurface_t`, `model_t`, `image_t`, `backEndState_t`, and `backEndData_t`, and `qfiles.h` declares `md3Header_t`, `md3Tag_t`, and `md3Frame_t`. No header under `Sources/CJKAMP_Ded/include` holds them, and `Sources/JKAMP_Ded/Generated/Views` has no view of them. The globals are `tr` (tr_main.cpp:15), `backEnd` and `backEndData` (tr_backend.cpp:20, :21), `shader`, `stages`, and `texMods` (tr_shader.cpp:100 to :102), and the pointer tables `hashTable` (tr_shader.cpp:106) and `mhHashTable` (tr_model.cpp:36). `modelHash_t` is a struct of tr_model.cpp:27. Proposal: the host extract takes `tr_local.h`, the records join `HOST_ROOTS`, the four record globals become records on `EngineStorage`, the two pointer tables become `Slots` of optional views, and `modelHash_t` goes to `ded_types.h`. Stubs: 75 of the 78, every Port-note of row TR1.
- Row TR2, `CachedModels` (tr_model.cpp:68). C type: `map<sstring_t, CachedEndianedModelBinary_t> *`. Proposal: a hand Swift class of the C++ track under rule 17, a `Dictionary` from the model name to a record of the five fields of tr_model.cpp:50 to :54. Stubs: the nine RE_RegisterModels functions and R_ModelFree.
- Row TR3, the `bool` globals. `gServerSkinHack` (tr_image.cpp:2967), `tr_stencilled`, `g_bRenderGlowingObjects`, and `g_bDynamicGlowSupported` (tr_backend.cpp:23, :32, :35) have the skeleton line "No table row for `bool`". Proposal: a TYPES row that reads C++ `bool` as `Bool`, the form of `qboolean`, so each one is an `EngineVariables` property. Stubs: RE_RegisterServerSkin.
- Row TR4, `r_vidModes` (tr_init.cpp:465). `vidmode_t` is a struct of tr_init.cpp:459. Proposal: the struct goes to `ded_types.h` and the table becomes C storage in `ded_tables.c` with Raven's 13 rows, the form of `bg_itemlist`, and `s_numVidModes` reads its count. Stubs: R_GetModeInfo, R_ModeList_f, and `s_numVidModes`.
- Row TR5, `contrib_t` and `contrib_list_t` (tr_image.cpp:2338 to :2348). Proposal: both structs go to `ded_types.h` and join `HOST_ROOTS`. Stubs: R_Resample.
- Row TR6, the static local `sPrevMapName` of RE_RegisterMedia_LevelLoadBegin (tr_model.cpp:560). Its text outlives the call. Proposal: a `CharBuf` property of `EngineWorld` of `MAX_QPATH` bytes and a forward in tr_model.swift, the form of a static local in the transcription doc.
- Row TR7, `shaderTextHashTable` (tr_shader.cpp:109). C type: `char **[MAX_SHADERTEXT_HASH]`. Proposal: an `[[TextCursor]]` property of `EngineWorld`, one list of cursors into `s_shaderText` per hash, because the table holds pointers into the one shader text. Stubs: KillTheShaderHashTable, ShaderHashTableExists, and FindShaderInShaderText.
- Row TR8, R_CreateExtendedName (tr_shader.cpp:177). The stub takes `Int32` for `const int *lightmapIndex`, and Raven indexes it at :207 and compares its address with the four lightmap tables at :187 to :199. Proposal: a PARAMS row that makes it the table `[Int32]` with a NULL case, and the address compare reads a compare of the tables. The same parameter of RE_RegisterShaderLightMap (tr_shader.cpp:3696) takes the same row.
- Row TR9, LoadTGA (tr_image.cpp:1421) and GetRefAPI (tr_init.cpp:1459). Their only callers are at tr_image.cpp:2252 and :2295 under `#ifndef DEDICATED`, and at `client/cl_main.cpp`, so no caller builds in the host. Proposal: rule 20, both stay stubs as dead in the host.
- Row TR10, the `tr_local.h` macros. `MAX_POLYS`, `MAX_POLYVERTS`, `LIGHTMAP_BY_VERTEX`, `LIGHTMAP_WHITEIMAGE`, the `GLS_` names, the `CULL_` names, `FUNCTABLE_SIZE`, `MAX_SKINS`, and `MAX_MOD_KNOWN` have no re-export in `JKAMP_Ded`. Proposal: the re-export of the host takes the macros of `tr_local.h` with row TR1, and the four rule 24 sites of this round read the names.

Row S1 of `notes/2026-11-09/dedicated-round-sv-core.md`, the `CMiniHeap` of `G2VertSpaceServer`, also blocks R_Init at tr_init.cpp:1315, beside row TR1.

## The open holes

| Function | Raven line | Hole | Row |
|---|---|---|---|
| RE_Shutdown | tr_init.cpp:1406 | `tr.registered = qfalse` | TR1 |
| RE_RegisterMedia_LevelLoadBegin | tr_model.cpp:541 | `tr.numBSPModels = 0` | TR1 |
| RE_RegisterMedia_LevelLoadBegin | tr_model.cpp:560 | `sPrevMapName` | TR6 |
| R_HunkClearCrap | tr_model.cpp:1686 | the stores into `tr` and `mhHashTable` | TR1 |
| R_InitShaders | tr_shader.cpp:4269 | the memset of `hashTable` | TR1 |

## The checks

`swift build -j 2` exited 0 on the first run. The seven stems give 7 warnings: four deprecation warnings of the Darwin `M_PI` in Lanczos3, two "will never be executed" warnings after a hole, and the unused result of RE_RegisterModels_LevelLoadEnd in RE_RegisterMedia_LevelLoadEnd, which is Raven's line. `swift test --no-parallel -j 2` exited 0: 147 tests in 18 runs passed, and 0 failed.
