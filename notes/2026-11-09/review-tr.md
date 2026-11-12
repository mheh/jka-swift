# Review of the seven renderer stems (master d6f2dd7)

Scope: `Sources/JKAMP_DedLogic/tr_{shader,model,image,init,main,mesh,backend}.swift` against `oracle/codemp/renderer/tr_*.cpp` under the WinDed defines.

## Part 1. The claim about the shader parsers

### The defines

`oracle/codemp/WinDed.vcproj:32` (Release) and `:91` (Debug) define `DEDICATED`. Neither defines `_USE_MATH_DEFINES` or `FINAL_BUILD`. The project compiles `tr_backend`, `tr_ghoul2`, `tr_image`, `tr_init`, `tr_main`, `tr_mesh`, `tr_model`, and `tr_shader` (`WinDed.vcproj:404` to `:425`). It does not compile `tr_bsp`, `tr_arioche`, `tr_terrain`, `tr_shade`, or any `client/*.cpp`. It compiles `null/null_client.cpp`, which never sets `cl_running`.

### Who fills the shader text

1. `s_shaderText` (tr_shader.cpp:96) gets its only store at tr_shader.cpp:3937, in ScanAndLoadShaderFiles (tr_shader.cpp:3895).
2. `shaderTextHashTable` (tr_shader.cpp:109) gets its only stores at tr_shader.cpp:3968 and :3983, in the same function. KillTheShaderHashTable (tr_shader.cpp:113) only zeroes it.
3. ScanAndLoadShaderFiles sits inside `#ifndef DEDICATED` at tr_shader.cpp:3812 to :4259. Its one call, tr_shader.cpp:4278 in R_InitShaders, sits inside `#ifndef DEDICATED` at tr_shader.cpp:4273 to :4282.
4. The server calls `R_InitShaders(qtrue)` at sv_init.cpp:534, so the server arm is the memset at tr_shader.cpp:4269 and `deferLoad = qfalse` at :4271.

Result: on WinDed, `s_shaderText` stays NULL and every bucket of `shaderTextHashTable` stays NULL for the life of the process. ShaderHashTableExists (tr_shader.cpp:116) always returns qfalse.

### Who reaches R_FindShader

R_FindShader (tr_shader.cpp:3428) is the only caller of FindShaderInShaderText (tr_shader.cpp:3475) and of ParseShader (tr_shader.cpp:3477). Every caller of R_FindShader is cut or unreachable on WinDed:

- tr_model.cpp:233, in RE_RegisterModels_Malloc: inside `#ifndef DEDICATED` at tr_model.cpp:221 to :242.
- tr_model.cpp:305, in RE_RegisterServerModels_Malloc: inside a `/* */` block at tr_model.cpp:295 to :314.
- tr_model.cpp:1574, in R_LoadMD3: inside `#ifndef DEDICATED` at tr_model.cpp:1567 to :1582.
- tr_ghoul2.cpp:4928, in R_LoadMDXM: the `#else` arm of `#ifdef DEDICATED` at tr_ghoul2.cpp:4923.
- tr_image.cpp:3156, in RE_RegisterSkin: inside a `/* */` block.
- tr_image.cpp:3097, in RE_RegisterIndividualSkin: only when `gServerSkinHack` is false. The only callers of RE_RegisterSkin are tr_image.cpp:3309 and :3313, in RE_RegisterServerSkin. The direct call at :3309 needs `com_cl_running->integer` and `ShaderHashTableExists()` (tr_image.cpp:3304 to :3307). On WinDed `cl_running` is "0" (common.cpp:1328, set only by client/cl_main.cpp:2699) and the table is empty. So the server always takes :3312 to :3314, with `gServerSkinHack = true`, and :3093 calls R_FindServerShader.
- tr_shader.cpp:3705, :3739, :3769 (RE_RegisterShaderLightMap, RE_RegisterShader, RE_RegisterShaderNoMip). Their WinDed callers are R_RemapShader (tr_shader.cpp:281, :291), which no WinDed file calls (its callers are tr_bsp.cpp:1934, :1947 and tr_arioche.cpp:29), tr_ghoul2.cpp:3456 (inside `#ifndef DEDICATED` at tr_ghoul2.cpp:3384), and `re.RegisterShaderNoMip` at tr_init.cpp:1478 (inside `#ifndef DEDICATED` at :1473 to :1529).
- tr_shader.cpp:4254 and :4256, in CreateExternalShaders: inside `#ifndef DEDICATED` at :3812 to :4259.

If R_FindShader ran on WinDed, Raven would read `shaderTextHashTable[hash][0]` through a NULL bucket at tr_shader.cpp:3300 and fault before ParseShader. The Swift port returns nil there (tr_shader.swift:911). No WinDed path reaches either form.

### The live shader path on WinDed

The game reaches FinishShader during every map load:

1. g_main.c:1032 G_InitGame calls G_SpawnEntitiesFromString, which calls SP_worldspawn (g_spawn.c:1438).
2. g_spawn.c:1293 calls `trap_G2API_InitGhoul2Model(&precachedKyle, "models/players/kyle/model.glm", ...)`, and g_spawn.c:1297 calls `trap_R_RegisterSkin("models/players/kyle/model_default.skin")`. g_client.c:1548 and :1650 make the same calls at client spawn.
3. sv_game.cpp:1314 sends the skin trap to RE_RegisterServerSkin (tr_image.cpp:3301).
4. tr_image.cpp:3313 calls RE_RegisterSkin, then :3166 or :3178 calls RE_RegisterIndividualSkin.
5. tr_image.cpp:3093 calls R_FindServerShader for each surface line of the skin file.
6. tr_shader.cpp:3595 calls FinishShader for each new name. FinishShader calls CollapseMultitexture only when `stage > 1` (:3231), and always calls GeneratePermanentShader (:3274), which calls SortNewShader (:2805).

### Verdicts for the eight shader functions

- ParseShader, ParseStage, ParseTexMod, ParseDeform, ParseSurfaceSprites, ParseSurfaceSpritesOptional: they cannot run on a dedicated server. Their only entry is tr_shader.cpp:3477. ParseStage is called only at :2336, ParseDeform only at :2408, and ParseTexMod and the two sprite parsers only at :1799, :1836, and :1868, inside ParseStage. The agent's claim is true for these six.
- RE_RegisterShaderFromImage: it cannot run. It has no caller in the whole oracle tree. tr_local.h:1775 is its only other mention. It is dead under rule 20.
- FinishShader: it CAN run. The claim is false for this function. R_FindServerShader calls it at tr_shader.cpp:3595 on every map load and every client spawn (path above). GeneratePermanentShader and SortNewShader run with it. In the Swift tree, the path stops before it, at the hole of RE_RegisterIndividualSkin (tr_image.swift:352, row TR11) and at the hole of R_FindServerShader (tr_shader.swift:1155, row TR15). FinishShader also reads `stages[].active` and `bundle[0].isLightmap` (tr_shader.cpp:2966), so it needs the `bool` accessors of row TR15. GeneratePermanentShader and SortNewShader need `tr.shaders` and `tr.sortedShaders` of row TR16.

### Verdicts for the six model functions

The server registers Ghoul2 models through RE_RegisterServerModel:

1. sv_game.cpp:1347 sends the init trap to G2API_InitGhoul2Model (G2_API.cpp:601), which calls G2_TestModelPointers at G2_API.cpp:650.
2. G2_API.cpp:2617 to :2619: with `com_dedicated->integer` set, it calls RE_RegisterServerModel (tr_model.cpp:1003).
3. tr_model.cpp:1107 calls ServerLoadMDXM for an MDXM file. ServerLoadMDXM calls RE_RegisterServerModels_Malloc at :841, RE_RegisterModels_StoreShaderRequest at :898, and RE_RegisterServerModel for the `.gla` at :867.
4. That nested call reaches ServerLoadMDXA at tr_model.cpp:1104, which calls RE_RegisterServerModels_Malloc at :718. For `*default.gla`, RE_RegisterModels_GetDiskFile returns the FakeGLAFile at tr_model.cpp:143 to :151.

The verdicts:

- ServerLoadMDXM, ServerLoadMDXA, RE_RegisterServerModels_Malloc: the server needs all three to load a map. SP_worldspawn registers the kyle model at g_spawn.c:1293 during map load, before any player joins. A player spawn with a Ghoul2 model needs them again (g_client.c:1541). RE_RegisterModels_StoreShaderRequest (row TR20) is on the same path.
- RE_RegisterModels_Malloc: the server does not need it. Its callers are R_LoadMD3 (tr_model.cpp:1467) and the client loaders R_LoadMDXM and R_LoadMDXA (tr_ghoul2.cpp:4859, :5305), which only RE_RegisterModel_Actual reaches (tr_model.cpp:1325 to :1333). On WinDed, G2 code calls RE_RegisterModel (G2_bones.cpp:577, G2_misc.cpp:282, and others) only with names that RE_RegisterServerModel already hashed, so tr_model.cpp:1211 to :1214 returns before a load.
- R_LoadMD3: the server does not need it. RE_RegisterServerModel rejects an MD3 at `default: goto fail` (tr_model.cpp:1109). The MD3 arm at :1333 needs a new name through RE_RegisterModel, and no WinDed path gives one.
- R_LerpTag: the server does not need it. Its only reference is `re.LerpTag` at tr_init.cpp:1488, inside `#ifndef DEDICATED` (:1473 to :1529).

### The current state of the Swift map-load path

If the Swift G2 init path reaches RE_RegisterServerModel, every map load stops at a hole. When the kyle model file exists, the stop is tr_model.swift:535 (row TR13). When it does not exist, the fail arm calls RE_InsertModelIntoHash, which stops at tr_model.swift:393 (row TR12).

### Functions in the brief's "server load path" that WinDed never calls

- R_Init: its only caller is RE_BeginRegistration at tr_model.cpp:1631, inside `#ifndef DEDICATED` (:1625 to :1654).
- R_Register: its only caller is R_Init (tr_init.cpp:1283).
- RE_Shutdown: its only reference is `re.Shutdown` at tr_init.cpp:1472, in GetRefAPI. Only client/cl_main.cpp calls GetRefAPI.
- RE_RegisterMedia_LevelLoadEnd: its only caller is client/cl_cgame.cpp:1942.

The real WinDed path is SV_SpawnServer: RE_RegisterMedia_LevelLoadBegin (sv_init.cpp:481), then Hunk_Clear, which calls R_HunkClearCrap (z_memman_pc.cpp:768), then R_InitSkins (sv_init.cpp:533), R_InitShaders(qtrue) (:534), and R_SVModelInit, which calls R_ModelInit (:578).

Because R_Register never runs on WinDed, `r_modelpoolmegs`, `r_lodbias`, and `r_nocull` stay NULL. RE_RegisterModels_LevelLoadEnd (reached from z_memman_pc.cpp:226), RE_RegisterModel_Actual (tr_model.cpp:1357), and R_CullPointAndRadius (tr_main.cpp:128) read them through NULL in Raven. The Swift `!` traps at the same sites. The behavior is the same.

## Part 2. The bodies against Raven

### The CachedModels comparator

`CachedModels_t` is `map<sstring_t, CachedEndianedModelBinary_t>` (tr_model.cpp:67). `sstring_t` is `sstring<MAX_QPATH>` (sstring.h:115). `std::less` calls `sstring::operator<`, which is `Q_stricmp(a, b) < 0` (sstring.h:97 to :103). The port sorts with `Q_stricmp($0, $1) < 0` (tr_model.swift:141, :192, :228, :248). The walk order is the same. No finding.

The map's key equivalence is case-insensitive, but the Dictionary key is case-sensitive. Every insert lowercases the key first: tr_model.cpp:132, :186, :260, and :77, and tr_model.swift:55. So the two key sets are the same. A future insert path that skips `Q_strlwr` would split one Raven key into two Swift keys.

### Findings, most severe first

#### 1. SUSPECT. RE_RegisterIndividualSkin traps on a surface name shorter than 4 bytes

- Swift tr_image.swift:336: `if strcmp(surfName[(strlen(surfName) - 4)...], "_off") == 0 {`
- Raven tr_image.cpp:3074: `if ( !strcmp( &surfName[strlen(surfName)-4], "_off") )`

Raven reads up to 3 stack bytes before `surfName`, the compare fails, and the parse continues. The Swift slice traps and stops the server. The trap is on the map-load path (g_spawn.c:1297) and on every player skin, and its input comes from `.skin` file data. Rule 19 allows the trap, but here a data-driven no-op in Raven becomes a crash. Decide with a run over the retail `.skin` files.

#### 2. SUSPECT. RE_RegisterSkin traps on a skin name shorter than 5 bytes, where Raven's test has an empty body

- Swift tr_image.swift:410: `if strcmp(CharBuf(name)[(strlen(name) - 5)...], ".skin") != 0 {`
- Raven tr_image.cpp:3153: `if ( strcmp( name + strlen( name ) - 5, ".skin" ) ) {`

The body of the test is a comment in both trees, so Raven's result has no effect. The Swift slice traps for a 1 to 4 byte name, for example a short `customSkin` value of a `.sab` file (bg_saberLoad.c:750). Raven would continue and return 0.

#### 3. SUSPECT. The two M_PI sites disagree on the type of M_PI

- Swift tr_init.swift:1048: `tr.sinTable[i] = sin(DEG2RAD(i * 360.0 / (Float(FUNCTABLE_SIZE - 1))))`
- Raven tr_init.cpp:1257: `tr.sinTable[i] = sin( DEG2RAD( i * 360.0f / ( ( float ) ( FUNCTABLE_SIZE - 1 ) ) ) );`
- Swift tr_image.swift:66 does the Lanczos3 products in `Double`. Raven is tr_image.cpp:2361 with `M_PI_OVER_3` at :2336.

R_Init uses the `Float` DEG2RAD of q_shared.h.swift:7 and `sin(Float)`. Lanczos3 uses the double `M_PI`, as transcription.md:634 states. Under the transcription ruling, the sine table differs from Raven in its last bits. Under the header text, q_shared.h:548 defines `M_PI` as `3.14159265358979323846f`. MSVC's math.h defines `M_PI` only with `_USE_MATH_DEFINES`, and the oracle never defines that, so Raven's `M_PI` is a float, and Lanczos3 is the site that differs. One of the two sites is wrong. R_Init has no WinDed caller, and R_Resample is not on a WinDed path that this review found.

#### 4. DEFECT (no WinDed caller). R_RemapShader drops Raven's NULL test of `timeOffset`

- Swift tr_shader.swift:372: `sh2!.timeOffset = Float(atof(timeOffset))`
- Raven tr_shader.cpp:313 to :315: `if (timeOffset) { sh2->timeOffset = atof(timeOffset); }`

Raven keeps the old `timeOffset` when a caller passes NULL, as tr_arioche.cpp:29 does. The Swift `String` parameter cannot carry NULL, so the store always runs. No WinDed file calls R_RemapShader.

#### 5. RULE. Three mutable Raven globals are Swift `let` constants

- Swift tr_backend.swift:24, :28, :32: `let tr_stencilled: Bool = false`, `let g_bRenderGlowingObjects: Bool = false`, `let g_bDynamicGlowSupported: Bool = false`
- Raven tr_backend.cpp:23, :32, :35: `bool tr_stencilled = false;` and the two other `bool` globals.

Rule 3 makes a Raven global a computed property over `world`, and the TR3 proposal names `EngineVariables` properties. Raven writes these globals only at tr_shade.cpp:2180 and tr_backend.cpp:505, :1657, and :1659, and WinDed does not compile those lines. So the behavior is the same.

### Notes with no finding

- ShaderHashTableExists (tr_shader.swift:215, AI line): the code does what the line says. Raven sets every bucket pointer, even for an empty bucket (tr_shader.cpp:3968). So the two forms would differ for a filled table with an empty bucket 0. WinDed never fills the table.
- R_CreateExtendedName (tr_shader.swift:241 to :247, AI line, row TR8): the code compares values as the line says. A caller array with the same values as a table, but at a different address, gets the short suffix in Swift and the `_style(...)` form in Raven. WinDed has no caller.
- The `goto fail` flag of RE_RegisterServerModel and RE_RegisterModel_Actual (tr_model.swift:503, :712): the loop, the `continue` decrements, and the tail loop give Raven's `lod` values and Raven's fail cases.
- Data checked byte for byte: `FakeGLAFile` (294 bytes), `g_strGlowVShaderARB` (1048), `g_strGlowPShaderARB` (524), `lightmapsNone`, `lightmaps2d`, `lightmapsVertex`, `lightmapsFullBright`, and `stylesDefault`.

## Coverage

These functions were compared in full, statement by statement:

- tr_model: RE_RegisterModels_GetDiskFile, GetModelDataAllocSize, RE_RegisterModels_LevelLoadEnd, RE_RegisterModels_DumpNonPure, RE_RegisterModels_Info_f, RE_RegisterModels_DeleteAll, RE_RegisterMedia_LevelLoadBegin, RE_RegisterMedia_GetLevel, RE_RegisterMedia_LevelLoadEnd, R_GetModelByHandle, R_AllocModel, generateHashValue, RE_InsertModelIntoHash, RE_RegisterServerModel, RE_RegisterModel_Actual, RE_RegisterModel, R_SVModelInit, R_ModelInit, R_HunkClearCrap, R_ModelFree, R_Modellist_f, R_ModelBounds.
- tr_shader: KillTheShaderHashTable, ShaderHashTableExists, R_CreateExtendedName, ClearGlobalShader, generateHashValue, R_RemapShader, ParseVector, NameToSrcBlendMode, NameToDstBlendMode, NameToGenFunc, ParseWaveForm, ParseSkyParms, ParseSort, ParseMaterial, CollapseMultitexture, FindShaderInShaderText, R_FindShaderByName, IsShader, R_FindShader, R_FindServerShader, RE_RegisterShaderLightMap, RE_RegisterShader, RE_RegisterShaderNoMip, RE_ShaderNameFromIndex, R_GetShaderByHandle, R_InitShaders.
- tr_image: R_InvertImage, Lanczos3, R_Resample, RE_SplitSkins, RE_RegisterIndividualSkin, RE_RegisterSkin, CommaParse, RE_RegisterServerSkin, R_InitSkins, R_GetSkinByHandle.
- tr_init: AssertCvarRange, R_GetModeInfo, R_ModeList_f, R_Register (each cvar line read against Raven by eye), R_Init, RE_Shutdown.
- tr_main: R_CullLocalPointAndRadius, R_CullPointAndRadius, R_LocalPointToWorld. tr_mesh: ProjectRadius. tr_backend: the globals and `s_flipMatrix`.

Not reached:

- The rows of `r_vidModes` in the C table, and the contents of `materialNames` (it aliases `svMaterialNames`) against the `MATERIALS` macro.
- The semantics of the helpers that the bodies call, for example `Q_strrchr`, the `CharBuf` slice, `Slots.fill`, `Com_Clamp`, and the `CharBuf` form of `FS_ReadFile`. They were taken as their doc comments state.
- The `portMissing` stubs, which have no body to compare.
