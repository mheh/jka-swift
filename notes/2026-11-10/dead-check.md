# Dead check of docket-12 DEAD stubs

Read-only check. Raven paths are under `oracle/codemp/`. Build: `WinDed.vcproj`. Release defines `WIN32,NDEBUG,_CONSOLE,DEDICATED,BOTLIB,_WINDOWS` (:32). Debug adds `_DEBUG,_JK2` (:91). `_XBOX` is not defined. The build links the `null/` files (null_client, null_renderer, null/win_main.cpp), not client/cl_main.cpp, not win32/win_main.cpp, and not icarus/Interpreter.cpp. `_G2_GORE` is defined with no condition (game/q_shared.h:3110). `DEFINEHASHING` is 1 (botlib/l_precomp.cpp:83). `DEBUG`, `DEBUG_AI_WEAP` and `G2EVALRENDER` are never defined.

Checked: 151 stubs. That is 131 from the named files, plus a seeded random sample of 20 from the rest (python `random.seed(12)` over 79 rest rows).

Four opus agents did the traces. The coordinator read the sources again for the two non-DEAD verdicts.

## qcommon/GenericParser2.cpp (27)

| function | Raven | verdict | chain or dead end |
|---|---|---|---|
| CleanTextPool | :212 | **LIVE** | g_spawn.c:530 `{"terrain", SP_terrain}` → g_misc.c:582 trap_CM_RegisterTerrain → g_syscalls.c:1475 → sv_game.cpp:1640-1641 G_CM_REGISTER_TERRAIN → CM_RegisterTerrain → cm_load.cpp:1048 CM_InitTerrain → cm_terrain.cpp:1622 new CCMLandScape → :208 LoadTerrainDef → :42 local CGenericParser2, :48 Com_ParseTextFile → common.cpp:2196 Parse(cleanFirst) → GenericParser2.cpp:883 Clean → :907 CleanTextPool. Also cm_terrain.cpp:109 Com_ParseTextFileDestroy → common.cpp:2206 Clean, and ~CGenericParser2 :868 at scope exit. No #ifdef on the chain. |
| GP_Parse | :928 | DEAD-CONFIRMED | no reference outside GenericParser2.cpp/.h; no syscall arm in game, cgame, ui, or sv_game |
| GP_Clean, GP_Delete, GP_GetBaseParseGroup | :942, :952, :963 | DEAD-CONFIRMED | no reference at all |
| GPG_GetName (1 arg, 2 args) | :977, :987 | DEAD-CONFIRMED | no reference at all |
| GPG_GetNext, GPG_GetInOrderNext, GPG_GetInOrderPrevious | :999, :1009, :1019 | DEAD-CONFIRMED | no reference at all |
| GPG_GetPairs, GPG_GetInOrderPairs, GPG_GetSubGroups, GPG_GetInOrderSubGroups | :1029-:1059 | DEAD-CONFIRMED | no reference at all |
| GPG_FindSubGroup, GPG_FindPair | :1069, :1079 | DEAD-CONFIRMED | no reference at all |
| GPG_FindPairValue (3 args) | :1089 | DEAD-CONFIRMED | only caller is the dead 4-arg overload (:1101) |
| GPG_FindPairValue (4 args) | :1099 | DEAD-CONFIRMED | no reference at all |
| GPV_GetName (1, 2 args), GPV_GetNext, GPV_GetInOrderNext, GPV_GetInOrderPrevious, GPV_IsList, GPV_GetTopValue (1, 2 args), GPV_GetList | :1110-:1195 | DEAD-CONFIRMED | no reference at all |

(26 DEAD-CONFIRMED rows, one per function, grouped here by equal proof.)

## botlib/l_script.cpp (14): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| PS_ReadLiteral | :721 | DEAD-CONFIRMED | only a comment at :870 |
| PS_ExpectTokenString | :909 | DEAD-CONFIRMED | only decl l_script.h:181 |
| PS_CheckTokenString | :1008 | DEAD-CONFIRMED | only decl :187 |
| PS_CheckTokenType | :1025 | DEAD-CONFIRMED | only decl :189 |
| PS_SkipUntilString | :1047 | DEAD-CONFIRMED | only decl :191 |
| PS_UnreadLastToken | :1063 | DEAD-CONFIRMED | only decl :193 |
| PS_UnreadToken | :1073 | DEAD-CONFIRMED | only decl :195 |
| PS_NextWhiteSpaceChar | :1085 | DEAD-CONFIRMED | only decl :197 |
| ReadSignedFloat | :1136 | DEAD-CONFIRMED | only decl :205 |
| ReadSignedInt | :1159 | DEAD-CONFIRMED | only decl :203 |
| GetScriptFlags | :1192 | DEAD-CONFIRMED | only decl :211 |
| ResetScript | :1202 | DEAD-CONFIRMED | only decl :213 |
| NumLinesCrossed | :1237 | DEAD-CONFIRMED | no reference |
| ScriptSkipTo | :1247 | DEAD-CONFIRMED | no reference |

## botlib/l_precomp.cpp (12): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| PC_PrintDefineHashTable | :516 | DEAD-CONFIRMED | only a comment at :3122 |
| PC_FindDefine | :604 | DEAD-CONFIRMED | every call in a `#else` arm (:1202, :1219, :1578, :1790, :2231, :2336, :2822) or `#if !DEFINEHASHING` (:1431) |
| PC_AddBuiltinDefines | :665 | DEAD-CONFIRMED | only decl l_precomp.h:126 |
| PC_DefineFromString | :1323 | DEAD-CONFIRMED | callers: dead PC_AddDefine (:1390), and :1412 in `#if !DEFINEHASHING` (:1409-1416) of the botlib export PC_AddGlobalDefine, which is empty under DEFINEHASHING=1 |
| PC_AddDefine | :1381 | DEAD-CONFIRMED | only decl :118 |
| PC_RemoveGlobalDefine | :1426 | DEAD-CONFIRMED | only decl :122; body also in `#if !DEFINEHASHING` |
| PC_CopyDefine | :1479 | DEAD-CONFIRMED | one call :1543 in `#else` (:1539-1550) |
| PC_CheckTokenType | :2955 | DEAD-CONFIRMED | only decl :106 |
| PC_SkipUntilString | :2977 | DEAD-CONFIRMED | only decl :108 |
| PC_SetIncludePath | :3013 | DEAD-CONFIRMED | only decl :128 |
| PC_SetPunctuations | :3029 | DEAD-CONFIRMED | only decl :130 |
| LoadSourceMemory | :3080 | DEAD-CONFIRMED | only decl :136; handle exports use LoadSourceFile |

## botlib/l_struct.cpp (4): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| WriteIndent | :313 | DEAD-CONFIRMED | WriteStructWithIndent (dead) and be_ai_weight.cpp:456-525 in `#if 0` :421-533 |
| WriteFloat | :327 | DEAD-CONFIRMED | WriteStructWithIndent :398 and be_ai_weight.cpp:433-443 in `#if 0` |
| WriteStructWithIndent | :355 | DEAD-CONFIRMED | itself (:410) and dead WriteStructure (:443) |
| WriteStructure | :441 | DEAD-CONFIRMED | be_ai_weap.cpp:165, :170 in `#ifdef DEBUG_AI_WEAP` :155-174 (never defined) |

## botlib/be_ai_chat.cpp (6): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| BotDumpSynonymList | :553 | DEAD-CONFIRMED | only a comment at :733 |
| BotDumpRandomStringList | :904 | DEAD-CONFIRMED | only a comment at :1020, also in `#ifdef DEBUG` :1018-1021 |
| BotDumpMatchTemplates | :1060 | DEAD-CONFIRMED | only a comment at :1330 |
| BotDumpReplyChat | :1619 | DEAD-CONFIRMED | only a comment at :1955 |
| BotDumpInitialChat | :1971 | DEAD-CONFIRMED | only a comment at :2151 |
| BotPrintReplyChatKeys | :2556 | DEAD-CONFIRMED | no reference |

## botlib/be_ea.cpp (5): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| EA_Tell, EA_UseItem, EA_DropItem, EA_UseInv, EA_DropInv | :55, :65, :75, :85, :95 | DEAD-CONFIRMED | no reference; `ea_export_t` has no slot; Init_EA_Export (be_interface.cpp:696-723) does not store them |

## botlib/be_aas_main.cpp (5): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| AAS_StringFromIndex | :56 | DEAD-CONFIRMED | one caller, dead AAS_ModelFromIndex (:107) |
| AAS_IndexFromString | :84 | DEAD-CONFIRMED | one caller, dead AAS_IndexFromModel (:117) |
| AAS_ModelFromIndex | :105 | DEAD-CONFIRMED | decl be_aas_main.h:38 only; no aas slot |
| AAS_IndexFromModel | :115 | DEAD-CONFIRMED | decl :40; be_ai_goal.cpp:548 is a comment |
| AAS_UpdateStringIndexes | :125 | DEAD-CONFIRMED | no reference |

## botlib/be_aas_entity.cpp (5): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| AAS_EntityOrigin | :178 | DEAD-CONFIRMED | decl be_aas_entity.h:41 only; not in Init_AAS_Export (be_interface.cpp:643-685) |
| AAS_EntitySize | :269 | DEAD-CONFIRMED | decl :29 only |
| AAS_EntityBSPData | :291 | DEAD-CONFIRMED | decl :25 only |
| AAS_NearestEntity | :362 | DEAD-CONFIRMED | no reference |
| AAS_BestReachableEntityArea | :397 | DEAD-CONFIRMED | decl :35 only |

## botlib/be_aas_route.cpp (4): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| AAS_CreateAllRoutingCache | :870 | DEAD-CONFIRMED | be_aas_main.cpp:172 is a comment, also in `#ifdef DEBUG` :170-175 |
| AAS_BridgeWalkable | :1892 | DEAD-CONFIRMED | no reference |
| DistancePointToLine | :2049 | DEAD-CONFIRMED | no reference |
| AAS_NearestHideArea | :2063 | DEAD-CONFIRMED | no reference; not in BotLibTest or any export slot |

## qcommon/vm.cpp (4): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| VM_VM2C | :37 | DEAD-CONFIRMED | no reference |
| VM_SymbolToValue | :148 | DEAD-CONFIRMED | decl vm_local.h:179 only; vminfo/vmprofile (:57-58) do not call it |
| VM_SymbolForCompiledPointer | :165 | DEAD-CONFIRMED | no reference |
| VM_LogSyscalls | :934 | DEAD-CONFIRMED | comments only: vm_interpreted.cpp:521, vm_x86.cpp:134, :163 |

## be_interface.swift, sv_game.swift

The report classes no stub in these two files as DEAD (the thunk and the two G2 list arms are ROW-NEW). No function in this check appears in `be_interface.cpp` export tables or in a `sv_game.cpp` syscall arm, except through the chains given in this report.

## renderer/tr_ghoul2.cpp, renderer/tr_local.h (18): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| G2_Find_Bone_ByNum | :112 | DEAD-CONFIRMED | only call :285 in `#if 0` :274-312 |
| G2_GetBoneNameFromSkel | :678 | DEAD-CONFIRMED | only decl G2_bones.cpp:2607 |
| G2_GetParentBoneMatrixLow | :780 | DEAD-CONFIRMED | decl G2_bones.cpp:1160; call :1339 commented out |
| AllocRS | :869 | DEAD-CONFIRMED | only call :2660 in `#ifndef DEDICATED` :2520-2736 |
| R_GCullModel | :896 | DEAD-CONFIRMED | only call :3420 in `#ifndef DEDICATED` :3384-3537 |
| R_GComputeFogNum | :939 | DEAD-CONFIRMED | only call :3447, same region |
| G2_ComputeLOD | :967 | DEAD-CONFIRMED | only call :3507, same region; collision uses G2_DecideTraceLod |
| G2_CreateQuaterion | :1048 | DEAD-CONFIRMED | no reference |
| G2_CreateMatrixFromQuaterion | :1097 | DEAD-CONFIRMED | no reference |
| G2_SetUpBolts | :2053 | DEAD-CONFIRMED | no reference |
| G2_ProcessSurfaceBolt | :2246 | DEAD-CONFIRMED | callers :2511, :2773 in dead functions |
| G2_ProcessGeneratedSurfaceBolts | :2495 | DEAD-CONFIRMED | no call |
| ProcessModelBoltSurfaces | :2739 | DEAD-CONFIRMED | only itself (:2786) |
| bInShadowRange | :3369 | DEAD-CONFIRMED | only call :3525 in `#ifndef DEDICATED` :3384-3537 |
| CBoneCache::SetRenderMatrix | :208 | DEAD-CONFIRMED | :261, :339 in `#ifdef _XBOX` |
| CBoneCache::SmoothLow | :267 | DEAD-CONFIRMED | only call :532 in EvalRender; EvalRender calls are in `_XBOX`, `G2EVALRENDER`, `#if 0` :4260-4304, or RB_SurfaceGhoul in `#ifndef DEDICATED` :3626-4452 |
| CRenderableSurface operator= | tr_local.h:2067 | DEAD-CONFIRMED | only use tr_ghoul2.cpp:2661 in `#ifndef DEDICATED` |
| CRenderableSurface::Init | tr_local.h:2092 | DEAD-CONFIRMED | only call tr_ghoul2.cpp:872 in dead AllocRS |

## renderer/tr_shader.cpp (7): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| ParseTexMod | :572 | DEAD-CONFIRMED | static, only ParseStage :1799 |
| ParseSurfaceSprites | :808 | DEAD-CONFIRMED | only ParseStage :1836 |
| ParseSurfaceSpritesOptional | :970 | DEAD-CONFIRMED | only ParseStage :1868 |
| ParseStage | :1279 | DEAD-CONFIRMED | only ParseShader :2336 |
| ParseDeform | :1936 | DEAD-CONFIRMED | only ParseShader :2408 |
| ParseShader | :2300 | DEAD-CONFIRMED | only R_FindShader :3477; no dedicated path reaches R_FindShader (see note) |
| RE_RegisterShaderFromImage | :3598 | DEAD-CONFIRMED | only decl tr_local.h:1775 |

Note on ParseShader. GetRefAPI (tr_init.cpp:1459) has one caller, client/cl_main.cpp:2483, not linked, so `re.*` stays empty. R_Init is called only from tr_model.cpp:1631 in `#ifndef DEDICATED`. Each R_FindShader call site is in `#ifndef DEDICATED`, a comment, an unlinked file, or a `re.*` entry, except tr_image.cpp:3097 in RE_RegisterIndividualSkin. That call runs only when `gServerSkinHack` is false. The only server entry, G_R_REGISTERSKIN (sv_game.cpp:1314) → RE_RegisterServerSkin (tr_image.cpp:3301), clears the hack only when ShaderHashTableExists() (tr_shader.cpp:116-123) is true. The table writers (:3937, :3968, :3983) are all in ScanAndLoadShaderFiles, inside `#ifndef DEDICATED` :3812-4259, and its call :4278 is inside `#ifndef DEDICATED` :4273-4282. So the null state is unconditional. The report's text "FindShaderInShaderText reads an empty table" is wrong: with a NULL table, the loop at :3300 would dereference NULL. The true dead end is that no path reaches R_FindShader.

## ghoul2/G2_misc.cpp (5)

| function | Raven | verdict | chain or dead end |
|---|---|---|---|
| G2_GetGoreRecord | :113 | DEAD-CONFIRMED | no reference |
| G2_GorePolys | :804 | **REACHABLE-NEVER-CALLED** | trap_G2API_CollisionDetect with collRecMap 0 → sv_game.cpp:1441-1453 G_G2_COLLISIONDETECT passes VMA(1) → vm.cpp:640-642 VM_ArgPtr(0) returns NULL → G2API_CollisionDetect (G2_API.cpp:2162) G2_TraceModels → G2_TraceSurfaces → G2_misc.cpp:1458-1496 `if (TS.collRecMap) ... else G2_GorePolys(...)` under `_G2_GORE` (defined, q_shared.h:3110). Same through G_G2_COLLISIONDETECTCACHE (sv_game.cpp:1457). Stock MP game never passes NULL: w_saber.c:2396, :2400 pass G2Trace; sv_world.cpp:667, :744 pass maps. After the trace, G2_API.cpp:2166 reads `collRecMap[i]` and crashes on NULL, but G2_GorePolys runs first. |
| G2_SaveGhoul2Models | :1719 | DEAD-CONFIRMED | only caller G2API_SaveGhoul2Models (G2_API.cpp:2474), no caller, no syscall arm |
| G2_LoadGhoul2Model | :1841 | DEAD-CONFIRMED | only caller G2API_LoadGhoul2Models (G2_API.cpp:2479), no caller, no syscall arm |
| G2_LerpAngles | :1912 | DEAD-CONFIRMED | no reference |

## icarus/Instance.cpp (8): all DEAD-CONFIRMED

All eight are `virtual` (instance.h:36-55). No class derives from ICARUS_Instance. `iICARUS->` calls only Delete, DeleteSequencer, GetSequencer (GameInterface.cpp:204, 252, 660). No G_ICARUS_* arm (sv_game.cpp:739-832) saves or loads. Q3_Interface.cpp:1006-1007 stores only game-side save functions.

| function | Raven | verdict | dead end |
|---|---|---|---|
| SaveSequenceIDTable | :312 | DEAD-CONFIRMED | SaveSequences :349 ← Save, dead |
| SaveSequencers | :367 | DEAD-CONFIRMED | Save :437, dead |
| SaveSignals | :389 | DEAD-CONFIRMED | Save :429, dead |
| Save | :422 | DEAD-CONFIRMED | no call site, no virtual call site |
| LoadSignals | :451 | DEAD-CONFIRMED | Load :592, dead |
| LoadSequences | :503 | DEAD-CONFIRMED | Load :599, dead |
| LoadSequencers | :547 | DEAD-CONFIRMED | Load :606, dead |
| Load | :575 | DEAD-CONFIRMED | no call site, no virtual call site |

## icarus/BlockStream.cpp, TaskManager.cpp, Sequence.cpp (7): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| CBlockStream::GetUnsignedInteger | BlockStream.cpp:420 | DEAD-CONFIRMED | no reference |
| CBlockStream::GetLong | :452 | DEAD-CONFIRMED | no reference (CNavigator::GetLong is a different class) |
| CBlockStream::Create(filename) | :525 | DEAD-CONFIRMED | no reference; Interpreter.cpp calls CBlock::Create |
| CBlockStream::WriteBlock | :577 | DEAD-CONFIRMED | callers only in Interpreter.cpp, not linked |
| CBlockMember::WriteMember | :133 | DEAD-CONFIRMED | only WriteBlock :591 |
| CTaskManager::SaveCommand | TaskManager.cpp:1620 | DEAD-CONFIRMED | :1696 in `#if 0` :1665-1781 |
| CSequence::SaveCommand | Sequence.cpp:320 | DEAD-CONFIRMED | :400 in `#if 0` :365-404 |

## Random sample of 20 from the rest

| function | Raven | verdict | dead end |
|---|---|---|---|
| ~CRMMission instance loop | RMG/RM_Mission.cpp:85 | DEAD-CONFIRMED | `delete mMission` (RM_Manager.cpp:63, :130); mMission set only at :135, never runs (dedicated null) |
| CRMMission::Load | RM_Mission.cpp:1362 | DEAD-CONFIRMED | only RM_Manager.cpp:140, after the unreached `new` at :135 |
| ParseInstancesOnPath | RM_Mission.cpp:737 | DEAD-CONFIRMED | ParseInstance ← ParseInstances ← ParseDifficulty ← Load; no CRMMission |
| PlaceWallInstance | RM_Mission.cpp:450 | DEAD-CONFIRMED | 8 calls, all in ParseWallRect, whose only call is a comment at :922 |
| ParseAmmo | RM_Mission.cpp:1040 | DEAD-CONFIRMED | calls :1166, :1298 inside block comments |
| CRandomTerrain::GetPathInfo | cm_randomterrain.cpp:628 | DEAD-CONFIRMED | callers in CRMMission only; one `new CRandomTerrain` (cm_terrain.cpp:1700), reached only from the `#else` arm :178 |
| CCMLandScape::GetTerxelLocalCoords | cm_terrain.cpp:862 | DEAD-CONFIRMED | calls :948-950 in block comment :929-969 |
| CM_StoreBrushes | cm_test.cpp:80 | DEAD-CONFIRMED | only stored at :205 in dead CM_BoxBrushes |
| Cvar_Realloc | cvar.cpp:965 | DEAD-CONFIRMED | Cvar_Defrag ← client/cl_main.cpp:715, not linked |
| Sys_GetCPUSpeedOld | win32/win_shared.cpp:338 | DEAD-CONFIRMED | only Sys_GetCPUSpeed :425 |
| Sys_GetCPUSpeed | win_shared.cpp:399 | DEAD-CONFIRMED | only win32/win_main.cpp:1469, not linked |
| Sys_FunctionCheckSum | null/win_main.cpp:128 | DEAD-CONFIRMED | no call; only decl qcommon.h:1033 |
| CNavigator::GetNodeLeadDistance | server/NPCNav/navigator.h:182 | DEAD-CONFIRMED | decl only, no body, no call |
| AAS_inPVS | botlib/be_aas_bspq3.cpp:174 | DEAD-CONFIRMED | decl be_aas_bsp.h:53 only |
| AAS_BSPTraceLight | be_aas_bspq3.cpp:433 | DEAD-CONFIRMED | no reference |
| AAS_AreaLiquid | be_aas_reach.cpp:664 | DEAD-CONFIRMED | decl be_aas_reach.h:39 only |
| CRC_ContinueProcessString | botlib/l_crc.cpp:126 | DEAD-CONFIRMED | decl l_crc.h:16 only |
| Log_WriteTimeStamped | botlib/l_log.cpp:113 | DEAD-CONFIRMED | decl l_log.h:24 only |
| G2_Animate_Bone_List (3 args) | ghoul2/G2_bones.cpp:1065 | DEAD-CONFIRMED | G2_API.cpp:1450 calls the 4-arg overload |
| LoadTGA | renderer/tr_image.cpp:1421 | DEAD-CONFIRMED | calls :2252, :2295 in `#ifndef DEDICATED` :1745-2308 |

(CM_BoxBrushes, cm_test.cpp:194, was checked with CM_StoreBrushes: DEAD-CONFIRMED, decl cm_local.h:277 only. It is not counted in the sample.)

## DEAD-BY-DEDICATED-NULL proof form

Two places use it. Both 0 stores are unconditional in the dedicated build.

- CRMMission and CRandomTerrain: `mRandomTerrain = 0` (cm_terrain.cpp:169) comes before `#ifdef DEDICATED` (:170) in the only constructor; the other branch is Com_Error(ERR_FATAL). CreateRandomTerrain's only call is :178 in the `#else` arm. Nothing else sets mRandomTerrain. TheRandomMissionManager is created only at sv_game.cpp:1629 (G_RMG_INIT), and LoadMission returns false at RM_Manager.cpp:110 before `new CRMMission` at :135. `new CRMPathManager` exists only at RM_Mission.cpp:71. Side note: G_RMG_INIT with `RMG 1` and no terrain entity calls SetLandScape(NULL) and dereferences NULL; the stock game avoids it.
- ParseShader: the shader text table stays NULL (writers only in `#ifndef DEDICATED`), so the one compiled R_FindShader call (tr_image.cpp:3097) is blocked by ShaderHashTableExists(). The report states the mechanism wrong (see the note above), but the 0 state is unconditional.

## Totals of the first pass (151 checked; the all-209 totals are at the end)

| verdict | count |
|---|---|
| DEAD-CONFIRMED | 149 |
| REACHABLE-NEVER-CALLED | 1 |
| LIVE | 1 |

## Verdicts that differ from the report

1. **CleanTextPool** (qcommon/GenericParser2.cpp:212): report DEAD, check LIVE. The report's own row names the caller CGenericParser2::Clean (:907) and calls the stub dead only because the Swift port drops the call (GenericParser2.swift:676, AI line). That is a port decision, not a Raven fact. Missed path: the terrain entity chain above, through the stock game's SP_terrain (g_misc.c:582) and G_CM_REGISTER_TERRAIN. The class that fits is the NOT_PORTED-replaced form, as for Cvar_FreeString.
2. **G2_GorePolys** (ghoul2/G2_misc.cpp:804): report DEAD ("only G2API_AddSkinGore starts it"), check REACHABLE-NEVER-CALLED. Missed path: G_G2_COLLISIONDETECT or G_G2_COLLISIONDETECTCACHE with a NULL collRecMap reaches the `else G2_GorePolys` arm at G2_misc.cpp:1490-1495. Raven then crashes at G2_API.cpp:2166.

## Proofs that are wrong or incomplete, verdict holds

- ParseShader: mechanism wrong (NULL table, not empty); the compiled call at tr_image.cpp:3097 is not cited.
- PC_FindDefine: the caller list misses :2822 (also in a `#else` arm).
- PC_DefineFromString: PC_AddGlobalDefine is a botlib export; it is dead only because its body is empty under DEFINEHASHING.
- ICARUS_Instance Save and Load: "no file calls it" is not sufficient for virtual methods; the full proof is no subclass and no virtual call site.
- PlaceWallInstance: 8 call sites, and ParseWallRect is dead on its own (only call is a comment at :922).
- GenericParser2 C interface: "code/game/genericparser2.*" is the SP tree; in codemp the names occur only in GenericParser2.cpp/.h.
- Several "only the definition" rows also have a header declaration (AAS_ModelFromIndex, AAS_EntityOrigin, AAS_EntitySize, AAS_EntityBSPData, AAS_BestReachableEntityArea, VM_SymbolToValue). A declaration is not a caller.
- CBoneCache::SmoothLow: the report's RB_SurfaceGhoul addition is right and needed.
- bInShadowRange: the report cites only rulings.py:1516; the line proof is tr_ghoul2.cpp:3525 in `#ifndef DEDICATED` :3384-3537.

# Second pass: the 57 remaining DEAD rows

The docket holds 209 DEAD rows. The first pass covered 152 of them (the 151 plus CM_BoxBrushes). These are the other 57. Three opus agents did the traces. The coordinator read the source again for G2_Get_Bone_Name.

## RMG/RM_Mission.cpp (15): all DEAD-CONFIRMED

Gate (dedicated-null): G_RMG_INIT (sv_game.cpp:1624-1635) → SetLandScape (RM_Manager.cpp:82, mTerrain = 0 from cm_terrain.cpp:169) → LoadMission returns false at RM_Manager.cpp:112 (the docket says :110) before `new CRMMission` at :135. No `virtual` in cm_landscape.h, cm_randomterrain.h or RM_Mission.h.

| function | Raven | verdict | dead end |
|---|---|---|---|
| Spawn | :1438 | DEAD-CONFIRMED | only caller SpawnMission (RM_Manager.cpp:394) ← sv_game.cpp:1634, which needs LoadMission true; dedicated-null |
| Preview | :1711 | DEAD-CONFIRMED | only call RM_Manager.cpp:374 is in `/* */` :367-377; CRMManager::Preview has no caller |
| ParseRandom | :1189 | DEAD-CONFIRMED | live callers only in ParseDifficulty (:1259, :1265, :1271, :1338); others in comments |
| ParseOrigin | :163 | DEAD-CONFIRMED | only ParseInstance (:925) |
| ParseNodes | :248 | DEAD-CONFIRMED | only ParseDifficulty (:1259) |
| ParsePaths | :294 | DEAD-CONFIRMED | only ParseDifficulty (:1265) |
| ParseRivers | :340 | DEAD-CONFIRMED | only ParseDifficulty (:1271) |
| PlaceBridges | :379 | DEAD-CONFIRMED | only Spawn (:1466) |
| ParseDifficulty | :1236 | DEAD-CONFIRMED | Load (:1411) and itself; Load only from RM_Manager.cpp:140, after :135; dedicated-null |
| ParseWeapons | :1090 | DEAD-CONFIRMED | :1156, :1288 in comments |
| ParseOutfit | :1147 | DEAD-CONFIRMED | :1284 in comment :1282-1316 |
| ParseObjectives | :1000 | DEAD-CONFIRMED | :1309 in comment :1282-1316 |
| ParseInstance | :886 | DEAD-CONFIRMED | only ParseInstances (:981) |
| ParseInstances | :966 | DEAD-CONFIRMED | only ParseDifficulty (:1338) |
| ParseWallRect | :485 | DEAD-CONFIRMED | only call :922 is a `//` comment |

## qcommon/cm_terrain.cpp (8): all DEAD-CONFIRMED

A CCMLandScape exists in dedicated, so the proof is at the CM_* wrappers.

| function | Raven | verdict | dead end |
|---|---|---|---|
| TerrainPatchIterate | :997 | DEAD-CONFIRMED | only CM_TerrainPatchIterate (:1630) |
| CarveLine | :1133 | DEAD-CONFIRMED | only CarveBezierCurve (:1303) |
| CarveBezierCurve | :1245 | DEAD-CONFIRMED | only CM_CarveBezierCurve (:1645), no caller in the tree |
| FractionBelowLevel | :1379 | DEAD-CONFIRMED | only CM_FractionBelowLevel (:1655), no caller |
| GetFirstObjectiveArea | :1422 | DEAD-CONFIRMED | only CM_GetFirstObjectiveArea (:1670), no caller |
| GetPlayerArea | :1442 | DEAD-CONFIRMED | only CM_GetPlayerArea (:1675), no caller |
| GetNextObjectiveArea | :1472 | DEAD-CONFIRMED | only CM_GetNextObjectiveArea (:1685), no caller |
| CM_TerrainPatchIterate | :1628 | DEAD-CONFIRMED | renderer/tr_terrain.cpp:923 (file not linked); RMG/RM_Terrain.cpp:493 in RM_CreateRandomModels (linked), whose only caller is client/cl_cgame.cpp:1707 (not linked) |

## qcommon/cm_randomterrain.cpp (3), RMG/RM_Manager.cpp (1): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| CreatePath | cm_randomterrain.cpp:605 | DEAD-CONFIRMED | RM_Path.cpp:327, :416, :564, all in CRMPathManager, which never exists; cm_terrain.cpp:1705-1707 in `/* */` |
| Smooth | :644 | DEAD-CONFIRMED | only CRMMission::Spawn (RM_Mission.cpp:1463), dead |
| Generate | :770 | DEAD-CONFIRMED | only CRMMission::Load (RM_Mission.cpp:1417), dead |
| CRMManager::ProcessAutomapSymbols | RM_Manager.cpp:442 | DEAD-CONFIRMED | callers RM_Mission.cpp:1508, :1512 in `#ifndef DEDICATED` inside dead Spawn; body starts with `#ifndef DEDICATED` (:444) |

## botlib (17) and server/sv_bot.cpp (1): all DEAD-CONFIRMED

| function | Raven | verdict | dead end |
|---|---|---|---|
| CRC_ProcessByte | l_crc.cpp:85 | DEAD-CONFIRMED | decl l_crc.h:13 only |
| AAS_BoxOriginDistanceFromPlane | be_aas_sample.cpp:349 | DEAD-CONFIRMED | definition only |
| AAS_AreaGroundFace | be_aas_sample.cpp:1001 | DEAD-CONFIRMED | be_interface.cpp:480 in `/* */` :480-484, also in `#ifdef DEBUG` :307-629 of BotExportTest |
| AAS_FacePlane | be_aas_sample.cpp:1035 | DEAD-CONFIRMED | decl be_aas_sample.h:51 only |
| AAS_TraceEndFace | be_aas_sample.cpp:1050 | DEAD-CONFIRMED | be_interface.cpp:597 in `#if 0` :589-628 inside `#ifdef DEBUG` |
| AAS_ClearCluster | be_aas_cluster.cpp:61 | DEAD-CONFIRMED | definition only |
| AAS_RemovePortalsClusterReference | be_aas_cluster.cpp:79 | DEAD-CONFIRMED | definition only |
| AAS_NumberClusterPortals | be_aas_cluster.cpp:271 | DEAD-CONFIRMED | only a `//` comment at :409 |
| AAS_RemoveAllPortals | be_aas_cluster.cpp:920 | DEAD-CONFIRMED | definition only |
| AAS_inPHS | be_aas_bspq3.cpp:185 | DEAD-CONFIRMED | decl be_aas_bsp.h:55 only, not exported |
| AAS_BoxEntities | be_aas_bspq3.cpp:225 | DEAD-CONFIRMED | decl be_aas_bsp.h:59 only |
| AAS_BarrierJumpTravelTime | be_aas_reach.cpp:758 | DEAD-CONFIRMED | only a `//` comment at :1471 |
| AAS_NearbySolidOrGap | be_aas_reach.cpp:787 | DEAD-CONFIRMED | `//` at :978, `/* */` :1020-1025 and :1365-1370 |
| AAS_SetMovedir | be_aas_move.cpp:218 | DEAD-CONFIRMED | only a `//` comment at be_aas_reach.cpp:3516 |
| AAS_AirControl | be_aas_move.cpp:373 | DEAD-CONFIRMED | definition only |
| AAS_TestMovementPrediction | be_aas_move.cpp:1016 | DEAD-CONFIRMED | `//` comment at be_interface.cpp:555, inside `#ifdef DEBUG` |
| BotFindEntityForLevelItem | be_ai_goal.cpp:949 | DEAD-CONFIRMED | :1156 in `/* */` :1151-1158 |
| BotDrawDebugPolygons | server/sv_bot.cpp:227 | DEAD-CONFIRMED | only caller CM_DrawDebugSurface (cm_patch.cpp:1674) ← R_DebugGraphics (tr_main.cpp:1583) ← R_RenderView, all inside `#ifndef DEDICATED` tr_main.cpp:183-1630; tr_scene.cpp is not linked |

## Engine and renderer (12)

| function | Raven | verdict | chain or dead end |
|---|---|---|---|
| Sys_FunctionCmp | null/win_main.cpp:59 | DEAD-CONFIRMED | decl qcommon.h:1032; no copy is called |
| G2_SetRagDollBullet | ghoul2/G2_bones.cpp:2040 | DEAD-CONFIRMED | definition only; no G2_API wrapper, no syscall arm |
| G2_Get_Bone_Name | G2_bones.cpp:2580 | **DEBUG-BUILD-ONLY** | Release WinDed: dead (`_DEBUG` not defined). Debug WinDed (vcproj:91 defines `_DEBUG`): G2_bones.cpp:2576-2578 defines `_DEBUG_BONE_NAMES`, so the assert call at :2625 in G2_RagDollCurrentPosition compiles. Chain: G_G2_ANIMATEG2MODELS (sv_game.cpp:1554) → G2_API.cpp:1450 G2_Animate_Bone_List → G2_bones.cpp:4527 G2_DoIK → :4483/:4493 G2_RagDollCurrentPosition → :2625. The stock game reaches it through the grapple IK (bg_pmove.c:8701). :3851 is gated by a NULL `broadsword` (:2406, :1628); :3964 is in the `#else` of `#ifdef DEDICATED`. |
| ApplyROFF client arm | qcommon/RoffSystem.cpp:820 (arm :833) | DEAD-CONFIRMED | the only writer of mIsClient is :617 in Play; linked Play callers pass qfalse (sv_game.cpp:725); the qtrue caller cl_cgame.cpp:1279 is not linked |
| ClearLerp client arm | RoffSystem.cpp:973 (arm :979) | DEAD-CONFIRMED | same proof |
| MC_Compress | renderer/matcomp.c:50 | DEAD-CONFIRMED | decl matcomp.h:22 only |
| MC_UnCompress | matcomp.c:163 | DEAD-CONFIRMED | only commented lines tr_ghoul2.cpp:1705, :1706, :1722, :1745, :1746 |
| R_LerpTag | renderer/tr_model.cpp:1768 | DEAD-CONFIRMED | only `re.LerpTag` at tr_init.cpp:1488 in dead GetRefAPI; no sv_game arm |
| GetRefAPI | tr_init.cpp:1459 | DEAD-CONFIRMED | only client/cl_main.cpp:2483, not linked |
| pw | qcommon/cm_polylib.cpp:17 | DEAD-CONFIRMED | decl cm_polylib.h:47 only |
| CM_DrawDebugSurface | qcommon/cm_patch.cpp:1651 | DEAD-CONFIRMED | only R_DebugGraphics (tr_main.cpp:1583), in `#ifndef DEDICATED` :183-1630 |
| CM_Checksum | qcommon/cm_load.cpp:544 | DEAD-CONFIRMED | no reference |

## Port-dropped-caller check over all 209

Method: every verdict in this file rests on Raven's callers in `oracle/codemp/` under the WinDed conditions, not on the Swift. A stub can be PORT-DROPPED-CALLER only if Raven has a reachable caller. Only three of the 209 have one:

| function | Raven call | Swift site | note at the Swift site |
|---|---|---|---|
| CleanTextPool | GenericParser2.cpp:907 in Clean, reached through the terrain entity chain | GenericParser2.swift:673-677, Clean omits the call | yes: `// AI: Raven frees the CTextPool chain with CleanTextPool. The text pool has no Swift type, so the call drops.` |
| G2_GorePolys | G2_misc.cpp:1494 | G2_misc.swift:1029 keeps the call | not dropped. A NULL collRecMap reaches the stub and traps |
| G2_Get_Bone_Name | G2_bones.cpp:2625 (Debug build only) | Swift G2_RagDollCurrentPosition (G2_bones.swift, about :1795) omits it | no AI line at the site; the stub note (G2_bones.swift:1788-1791) says the callers are under `_DEBUG_BONE_NAMES` and dead, which is true for Release only |

So CleanTextPool moves from LIVE to PORT-DROPPED-CALLER. No other stub has this form.

## More report proofs that are wrong, verdict holds

- LoadMission's `!mTerrain` return is at RM_Manager.cpp:112, not :110.
- CM_TerrainPatchIterate: the RM_Terrain.cpp:493 caller is linked; it is dead because RM_CreateRandomModels has only a client caller.
- Preview: RM_Manager.cpp:374 is inside `/* */` :367-377.
- CreatePath: two more CRMPathManager callers (RM_Path.cpp:416, :564) and commented calls at cm_terrain.cpp:1705-1707.
- BotDrawDebugPolygons and CM_DrawDebugSurface: the dead end at the line is tr_main.cpp:183 `#ifndef DEDICATED`; the docket cites only rulings.py.
- AAS_AreaGroundFace, AAS_TestMovementPrediction: also inside `#ifdef DEBUG` :307-629 of BotExportTest, which is live as `be_botlib_export.Test` (be_interface.cpp:866).
- ApplyROFF client arm: only cl_cgame.cpp:1279 (Play) writes mIsClient; :1276 is Cache and does not.
- G2_Get_Bone_Name: the docket and the stub note leave out that `_DEBUG` turns on `_DEBUG_BONE_NAMES`.

# Totals over all 209 DEAD rows

| verdict | count |
|---|---|
| DEAD-CONFIRMED | 206 |
| PORT-DROPPED-CALLER | 1 (CleanTextPool) |
| REACHABLE-NEVER-CALLED | 1 (G2_GorePolys) |
| DEBUG-BUILD-ONLY | 1 (G2_Get_Bone_Name: dead in Release, reachable in Debug WinDed) |
| LIVE (other) | 0 |
| UNDECIDED | 0 |
