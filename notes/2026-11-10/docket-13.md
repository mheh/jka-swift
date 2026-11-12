# Docket 13: the plan for the body wave of the remaining `portMissing(` stubs

Tree: `/Users/milohehmsoth/Developer/Milo/jka-swift`, master `03223d0`. This is a read-only census. Five opus agents read five slices. The coordinator read the sixth slice (ICARUS, ROFF, vm, win, sv_game, CNavigator) and merged the results.

Swift paths are under `Sources/JKAMP_DedLogic/`. Raven paths are under `oracle/codemp/`. "Lines" means the Raven body lines, from the first line of the function to its closing brace. For an arm stub, it means only the lines of the arm.

## Scope

- Master has 234 stubs.
- These are skipped, because other work closes them:
  - the 16 stubs of `be_ai_char.swift` (branch `ded-bodies-be-ai-char`);
  - the 3 console-message stubs of `be_ai_chat.swift` (FIELD_NAMES rows FN-consolehandle and FN-chathandle on `dedicated-rulings-batch-12`);
  - `Cvar_FreeString` and `Sys_GetFileTime` (NOT_PORTED rows on the same branch).
- The six dump functions of `be_ai_chat.swift` are in scope. If the parallel batch closes some of them too, remove those from set S3.
- **In scope: 213 stubs.**

Rule change: the user ruled that dead functions get real bodies. So every DEAD row in `rulings.py:1508-1538` that covers one of these stubs goes out in the generator batch (row G21). A NOT_PORTED row is still correct when no body can exist: Raven has no body, or a ratified ruling removed the storage that the body works on.

## Counts per class

| class | stubs |
|---|---|
| BODY | 115 |
| ROW-PATTERN | 52 |
| ROW-NEW | 30 |
| BLOCKED-BY | 16 |
| **total** | **213** |

---

## 1. Per-file tables

### CRMMission.swift (20), CRMManager.swift (1), CRandomTerrain.swift (4)

The three files are adopted, so a signature fix is a hand edit. The table row keeps draftcheck in agreement with that edit.

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| ~CRMMission | RMG/RM_Mission.cpp:85 | 31 | BLOCKED-BY N-RMG | It needs the `mInstances` field, which needs CRMInstance. Then the body is `mInstances.removeAll()`, the form at :113. Until then, every release of a CRMMission traps. |
| Load | :1362 | 62 | BLOCKED-BY N-RMG | `mInstanceFile.Open` (:1400) needs CRMInstanceFile. Com_ParseTextFile, CGenericParser2, and FindPairValue (`String?`) exist. |
| Spawn | :1438 | 153 | BLOCKED-BY N-RMG | It needs the virtuals PreSpawn, Spawn, PostSpawn, and SetMirror. Drop the `#ifndef DEDICATED` arms. Keep the `#ifndef FINAL_BUILD` arm, because WinDed.vcproj:32 does not define FINAL_BUILD. |
| Preview | :1711 | 27 | BLOCKED-BY N-RMG | It needs GetOrigin and the virtual Preview. |
| ParseRandom | :1189 | 34 | ROW-PATTERN H-RMG | It needs a hand `MAX_RANDOM_CHOICES` (RM_Mission.h:10). Precedent: CRMManager.swift:7. Past 100 entries Swift traps where Raven is undefined, so the site needs a rule 19 note. |
| ParseOrigin | :163 | 72 | ROW-PATTERN G12 | Signature marker. The target is `(_ originGroup: CGPGroup?, _ origin: inout vec3_t, _ lookat: inout vec3_t, _ flattenHeight: inout Int32) -> Bool`. The one caller passes `&flattenHeight`, so the two tests are always true and each one needs an AI line. |
| ParseNodes | :248 | 33 | BODY | The body takes a mutable copy of `group` (form at CRMMission.swift:183). |
| ParsePaths | :294 | 33 | BODY | SetPathStyle and GeneratePaths exist. |
| ParseRivers | :340 | 38 | BODY | SetRiverStyle and GenerateRivers exist. |
| PlaceBridges | :379 | 70 | BLOCKED-BY N-RMG | It needs CreateInstance, the instance getters, and `mInstances`. |
| PlaceWallInstance | :450 | 21 | ROW-NEW N-RMG | Signature marker for `CRMInstance* instance`. It needs the Swift type, then a CXX_CLASSES row. |
| ParseDifficulty | :1236 | 112 | BODY | All the callees exist. `atol` maps to `atoi` through LIBC_SPELLINGS (rulings.py:1579). |
| ParseWeapons | :1090 | 44 | BODY | A comment block, `mValidWeapons = true`, and `return true`. |
| ParseAmmo | :1040 | 36 | BODY | The same shape. |
| ParseOutfit | :1147 | 29 | BODY | A nil test, a comment block, and `return true`. |
| ParseObjectives | :1000 | 26 | BODY | `CRMObjective(group)` exists (CRMObjective.swift:39). |
| ParseInstance | :886 | 66 | BLOCKED-BY N-RMG, G12, H-RMG | It needs CRMInstance, the ParseOrigin signature, and SIDE_RED and SIDE_BLUE. |
| ParseInstances | :966 | 21 | BODY | A loop over the ParseInstance stub. |
| ParseInstancesOnPath | :737 | 136 | BLOCKED-BY N-RMG, H-RMG | `CreateArea(origin, …, origin, …)` at :844 is an overlapping access in Swift. A `let` copy is faithful (CRMAreaManager.swift:301, :323) and needs an AI line. |
| ParseWallRect | :485 | 238 | BLOCKED-BY N-RMG | It needs CreateInstance and SetSide. Raven calls `group->FindSubGroup` before its own NULL test, which is a rule 19 site. |
| CRMManager::ProcessAutomapSymbols | RMG/RM_Manager.cpp:442 | 33 | ROW-PATTERN G7, G21 | The whole body is under `#ifndef DEDICATED`, so the dedicated body is empty. Remove the DEAD row (rulings.py:1535). `symbols` becomes `Slots<RmAutomapSymbol>`. |
| CRandomTerrain::CreatePath | qcommon/cm_randomterrain.cpp:605 | 22 | BODY | `CPathInfo.init` matches Raven. |
| GetPathInfo | :628 | 11 | BODY | Add `@discardableResult`, because every caller drops the result. |
| Smooth | :644 | 125 | BODY | Only the `#if 1` arm builds. Use Com_Memcpy over Slots (CString.swift:436). |
| Generate | :770 | 55 | ROW-PATTERN H-RMG | It needs the noise statics of cm_randomterrain.cpp:11-89 as hand file-scope code. The tables are zero, because CM_NoiseInit is under `#if 0`. Precedents: CPathInfo.swift:480 and CRMPathManager.swift:26-28. |

Prerequisite types:
- CRMInstance, plus CRMBSPInstance, CRMGroupInstance, CRMRandomInstance, and CRMVoidInstance (RM_Instance*.cpp, 1543 Raven lines).
- CRMInstanceFile (RM_InstanceFile.h:11).
- The `mInstances` and `mInstanceFile` fields.
- MAX_RANDOM_CHOICES.
- SIDE_NONE, SIDE_BLUE, and SIDE_RED (an anonymous enum at qcommon/cm_terrainmap.h:62).

These exist already: CRMObjective, CRMArea, CRMAreaManager, CRMPathManager, CRandomTerrain, CPathInfo, CArea, and CCMLandScape.

### GenericParser2.swift (27)

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| CleanTextPool | qcommon/GenericParser2.cpp:212 | 11 | ROW-PATTERN G5 | NOT_PORTED-replaced. Ruling C3 gives CTextPool no Swift type. The row text is drafted at rows-13-bot.md:26. |
| GP_Parse | :928 | 13 | ROW-PATTERN G1, G2, G3 | `dataPtr` takes the `text_cursor` kind. |
| GP_Clean | :942 | 9 | ROW-PATTERN G1, G2 | |
| GP_Delete | :952 | 10 | ROW-PATTERN G1, G2 | `inout CGenericParser2?`. |
| GP_GetBaseParseGroup | :963 | 9 | ROW-PATTERN G1, G2 | |
| GPG_GetName (1 arg) | :977 | 9 | ROW-PATTERN G1, G2 | |
| GPG_GetName (2 args) | :987 | 11 | ROW-PATTERN G1, G2 | |
| GPG_GetNext | :999 | 9 | ROW-PATTERN G1, G2 | A weak `mNext` exists. |
| GPG_GetInOrderNext | :1009 | 9 | ROW-NEW N-GP2 | CGPGroup has no `mInOrderNext`. |
| GPG_GetInOrderPrevious | :1019 | 9 | ROW-NEW N-GP2 | |
| GPG_GetPairs | :1029 | 9 | ROW-NEW N-GP2 | Raven returns a list head. The Swift value is a struct in an array, with no link. |
| GPG_GetInOrderPairs | :1039 | 9 | ROW-NEW N-GP2 | |
| GPG_GetSubGroups | :1049 | 9 | ROW-PATTERN G1, G2 | |
| GPG_GetInOrderSubGroups | :1059 | 9 | ROW-PATTERN G1, G2 | `.first`. |
| GPG_FindSubGroup | :1069 | 9 | ROW-PATTERN G1, G2 | |
| GPG_FindPair | :1079 | 9 | ROW-PATTERN G1, G2 | |
| GPG_FindPairValue (3 args) | :1089 | 9 | ROW-PATTERN G1, G2, G4 | RETURNS `optional_string`. Check the Bool overload. |
| GPG_FindPairValue (4 args) | :1099 | 6 | ROW-PATTERN G1, G2 | Raven's `strcpy` of NULL is a rule 19 site. |
| GPV_GetName (1 arg) | :1110 | 9 | ROW-PATTERN G1 | |
| GPV_GetName (2 args) | :1120 | 11 | ROW-PATTERN G1 | |
| GPV_GetNext | :1132 | 9 | ROW-NEW N-GP2 | |
| GPV_GetInOrderNext | :1142 | 9 | ROW-NEW N-GP2 | |
| GPV_GetInOrderPrevious | :1152 | 9 | ROW-NEW N-GP2 | |
| GPV_IsList | :1162 | 9 | ROW-PATTERN G1 | |
| GPV_GetTopValue (1 arg) | :1172 | 9 | ROW-PATTERN G1, G4 | |
| GPV_GetTopValue (2 args) | :1182 | 12 | ROW-PATTERN G1 | |
| GPV_GetList | :1195 | 9 | ROW-NEW N-GP2 | CGPObject has no Swift type. |

Prerequisite types: TYPES rows for the three handle typedefs, and CGPGroup in CXX_CLASSES.

### CCMLandScape.swift (8), cm_terrain.swift (1), cm_load.swift (1), cm_patch.swift (1), cm_polylib.swift (1), cm_test.swift (2), cvar.swift (1)

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| TerrainPatchIterate | qcommon/cm_terrain.cpp:997 | 11 | ROW-NEW N-USERDATA | The callback takes `void *userdata`, which is a `CRMLandScape *` with no Swift type. |
| GetTerxelLocalCoords | :862 | 34 | BODY | Signature correct. |
| CarveLine | :1133 | 111 | BODY | `CArea()`, Init, irand, GetWorldHeight, and FlattenArea exist. |
| CarveBezierCurve | :1245 | 66 | ROW-PATTERN G7 | Raven writes `ctlPoints`. Change `[vec3_t]` to `Slots<vec3_t>` here and in CM_CarveBezierCurve (cm_terrain.swift:126). |
| FractionBelowLevel | :1379 | 32 | ROW-PATTERN G6 | `ivec3_t info` goes to a `Slots<Int32>` parameter. |
| GetFirstObjectiveArea | :1422 | 19 | BODY | |
| GetPlayerArea | :1442 | 19 | BODY | |
| GetNextObjectiveArea | :1472 | 15 | BODY | |
| CM_TerrainPatchIterate | cm_terrain.cpp:1628 | 4 | BLOCKED-BY N-USERDATA | Also remove its DEAD row (G21). |
| CM_Checksum | qcommon/cm_load.cpp:544 | 16 | ROW-PATTERN G6, G21 | `unsigned checksums[16]` goes to Com_BlockChecksum. |
| CM_DrawDebugSurface | qcommon/cm_patch.cpp:1651 | 156 | ROW-NEW N-CLOSURE | `drawPoly`'s `float *points` is spelled `inout Float`. It also needs G6 for `vec3_t v[3]`, and G21. |
| pw | qcommon/cm_polylib.cpp:17 | 6 | BODY | `SysBackend.printf` form (win_main.swift:169). |
| CM_StoreBrushes | qcommon/cm_test.cpp:80 | 42 | ROW-NEW N-LEAFLIST | It stores a `cbrush_t *` into `int *list`. Also G21. |
| CM_BoxBrushes | cm_test.cpp:194 | 19 | BLOCKED-BY N-LEAFLIST, G8 | `cbrush_t **boxList` is spelled `inout Cbrush?`. Also G21. |
| Cvar_Realloc | qcommon/cvar.cpp:965 | 11 | ROW-PATTERN G5 | NOT_PORTED-replaced in the Cvar_FreeString form. The pool does not exist, Cvar_Defrag is a hand no-op (cvar.swift:957-960), and jka-rust drops it (cvar_fns.rs:12-15). |

### AAS, be_ea, be_ai_goal, be_ai_chat dumps, be_interface, sv_bot (46)

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| AAS_inPVS | botlib/be_aas_bspq3.cpp:174 | 4 | BODY | `var` copies for `runInPVS(&,&)`. |
| AAS_inPHS | :185 | 4 | BODY | |
| AAS_BoxEntities | :225 | 4 | BODY | |
| AAS_BSPTraceLight | :433 | 4 | BODY | |
| AAS_ClearCluster | botlib/be_aas_cluster.cpp:61 | 12 | BODY | |
| AAS_RemovePortalsClusterReference | :79 | 16 | BODY | |
| AAS_NumberClusterPortals | :271 | 21 | BODY | The form of AAS_NumberClusterAreas. |
| AAS_RemoveAllPortals | :920 | 9 | BODY | |
| AAS_EntityOrigin | botlib/be_aas_entity.cpp:178 | 11 | BODY | |
| AAS_EntitySize | :269 | 16 | BODY | |
| AAS_EntityBSPData | :291 | 12 | BODY | |
| AAS_NearestEntity | :362 | 29 | BODY | |
| AAS_BestReachableEntityArea | :397 | 7 | BODY | |
| AAS_StringFromIndex | botlib/be_aas_main.cpp:56 | 22 | ROW-NEW N-STRSLOTS | `inout ArraySlice<String>` cannot hold Raven's NULL entries. |
| AAS_IndexFromString | :84 | 15 | ROW-NEW N-STRSLOTS | |
| AAS_ModelFromIndex | :105 | 4 | BLOCKED-BY N-STRSLOTS | |
| AAS_IndexFromModel | :115 | 4 | BLOCKED-BY N-STRSLOTS | |
| AAS_UpdateStringIndexes | :125 | 15 | ROW-NEW N-STRSLOTS | |
| AAS_SetMovedir | botlib/be_aas_move.cpp:218 | 15 | BODY | Pass two scratch vectors to AngleVectors. |
| AAS_AirControl | :373 | 6 | BODY | |
| AAS_TestMovementPrediction | :1016 | 18 | BODY | |
| AAS_AreaLiquid | botlib/be_aas_reach.cpp:664 | 5 | BODY | |
| AAS_BarrierJumpTravelTime | :758 | 4 | BODY | Truncate through UInt16. |
| AAS_NearbySolidOrGap | :787 | 25 | BODY | |
| AAS_CreateAllRoutingCache | botlib/be_aas_route.cpp:870 | 19 | BODY | |
| AAS_BridgeWalkable | :1892 | 4 | BODY | |
| DistancePointToLine | :2049 | 8 | BODY | |
| AAS_NearestHideArea | :2063 | 130 | BODY | Write the hand static `hidetraveltimes` in the same commit (EngineWorld.swift:258 and sv_bot.swift:221 form). |
| AAS_BoxOriginDistanceFromPlane | botlib/be_aas_sample.cpp:349 | 34 | BODY | |
| AAS_AreaGroundFace | :1001 | 27 | BODY | |
| AAS_FacePlane | :1035 | 8 | BODY | |
| AAS_TraceEndFace | :1050 | 54 | BODY | |
| EA_Tell, EA_UseItem, EA_DropItem, EA_UseInv, EA_DropInv | botlib/be_ea.cpp:55, :65, :75, :85, :95 | 4 each | BODY | The EA_Say form (be_ea.swift:27). |
| BotFindEntityForLevelItem | botlib/be_ai_goal.cpp:949 | 34 | BODY | |
| BotDumpSynonymList | botlib/be_ai_chat.cpp:553 | 19 | BODY | The Log_Write form, with the l_log.swift:75-77 AI line. |
| BotDumpRandomStringList | :904 | 19 | BODY | |
| BotDumpMatchTemplates | :1060 | 31 | BODY | |
| BotDumpReplyChat | :1619 | 49 | BODY | |
| BotDumpInitialChat | :1971 | 19 | BODY | |
| BotPrintReplyChatKeys | :2556 | 35 | BODY | |
| BotReplaceSynonyms thunk (be_interface.swift:827) | botlib/be_ai_chat.cpp:744 | 14 | ROW-NEW X2 | Also needs `UInt32(truncatingIfNeeded:)` for `context` (be_interface.swift:665). |
| BotDrawDebugPolygons | server/sv_bot.cpp:227 | 34 | ROW-NEW N-CLOSURE, plus G19, G21 | The same closure defect as CM_DrawDebugSurface. `BotLibVarSet` takes `OpaquePointer?` (BotlibExport.swift:118). |

### l_script.swift (14), l_precomp.swift (12), l_struct.swift (4), l_crc.swift (2), l_log.swift (1)

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| PS_ReadLiteral | botlib/l_script.cpp:721 | 41 | BODY | |
| PS_ExpectTokenString | :909 | 17 | BODY | `Token.scratch`. |
| PS_CheckTokenString | :1008 | 11 | BODY | |
| PS_CheckTokenType | :1025 | 16 | BODY | `token.copy(from:)`. |
| PS_SkipUntilString | :1047 | 10 | BODY | |
| PS_UnreadLastToken | :1063 | 4 | BODY | |
| PS_UnreadToken | :1073 | 5 | BODY | |
| PS_NextWhiteSpaceChar | :1085 | 11 | BODY | |
| ReadSignedFloat | :1136 | 17 | BODY | MSVC `long double` is Double. |
| ReadSignedInt | :1159 | 17 | BODY | The bit-pattern form of l_struct.swift:90. |
| GetScriptFlags | :1192 | 4 | BODY | |
| ResetScript | :1202 | 18 | BODY | NULL becomes offset 0. Add a Port-note. |
| NumLinesCrossed | :1237 | 4 | BODY | |
| ScriptSkipTo | :1247 | 20 | BODY | |
| PC_PrintDefineHashTable | botlib/l_precomp.cpp:516 | 15 | BODY | |
| PC_FindDefine | :604 | 10 | BODY | |
| PC_AddBuiltinDefines | :665 | 34 | ROW-NEW N-LOCALTABLE | A local table of records with a `{NULL,0}` end row. |
| PC_DefineFromString | :1323 | 52 | BODY | `Source.scratch`. |
| PC_AddDefine | :1381 | 19 | BODY | |
| PC_RemoveGlobalDefine | :1426 | 14 | BODY | Under DEFINEHASHING the body is `return 0`. |
| PC_CopyDefine | :1479 | 37 | BODY | |
| PC_CheckTokenType | :2955 | 16 | BODY | |
| PC_SkipUntilString | :2977 | 10 | BODY | |
| PC_SetIncludePath | :3013 | 10 | ROW-PATTERN G20 | `PATHSEPERATOR_STR`. |
| PC_SetPunctuations | :3029 | 4 | BODY | |
| LoadSourceMemory | :3080 | 27 | BODY | |
| WriteIndent | botlib/l_struct.cpp:313 | 8 | ROW-PATTERN H-FPRINTF | The return of `fprintf(fp, ...) < 0` is tested. |
| WriteFloat | :327 | 22 | ROW-PATTERN H-FPRINTF | |
| WriteStructWithIndent | :355 | 80 | ROW-PATTERN H-FPRINTF | It reads the record through RawField subscripts, as ReadStructure does. |
| WriteStructure | :441 | 4 | BODY | One line. It goes in set W3 with the rest of the file. |
| CRC_ProcessByte | botlib/l_crc.cpp:85 | 4 | BODY | |
| CRC_ContinueProcessString | :126 | 9 | ROW-PATTERN G11 | `char *data` with `length` is a byte buffer. |
| Log_WriteTimeStamped | botlib/l_log.cpp:113 | 19 | BLOCKED-BY H-E2 | It needs the `%02d` zero pad (rows-13-eng.md E2, Format.swift:156-159). |

### tr_ghoul2.swift (14), G2_misc.swift (5), G2_bones.swift (3), CBoneCache.swift (2), CRenderableSurface.swift (2), matcomp.swift (2), tr_shader.swift (7), tr_model.swift (1), tr_image.swift (1), tr_init.swift (1)

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| G2_Find_Bone_ByNum | renderer/tr_ghoul2.cpp:112 | 15 | BODY | |
| G2_GetBoneNameFromSkel | :678 | 17 | BODY | |
| G2_GetParentBoneMatrixLow | :780 | 24 | BODY | Write the signature by hand in the G2_GetBoneMatrixLow form (tr_ghoul2.swift:427), with `inout MdxaBone?` for the two `mdxaBone_t *&`. |
| AllocRS | :869 | 8 | ROW-PATTERN G17 | It needs the storage `RSStorage`. |
| R_GCullModel | :896 | 35 | BODY | |
| R_GComputeFogNum | :939 | 26 | BODY | |
| G2_ComputeLOD | :967 | 75 | BODY | Under DEDICATED, `myftol` is `(int)`. |
| G2_CreateQuaterion | :1048 | 48 | BODY | |
| G2_CreateMatrixFromQuaterion | :1097 | 29 | BODY | |
| G2_SetUpBolts | :2053 | 16 | BODY | |
| G2_ProcessSurfaceBolt | :2246 | 246 | BODY | The twin of G2_ProcessSurfaceBolt2 (tr_ghoul2.swift:1605). |
| G2_ProcessGeneratedSurfaceBolts | :2495 | 24 | BODY | |
| ProcessModelBoltSurfaces | :2739 | 54 | BODY | |
| bInShadowRange | :3369 | 8 | BODY | |
| G2_GetGoreRecord | ghoul2/G2_misc.cpp:113 | 4 | ROW-NEW N-GORE | A `void *` return over a hand class. |
| G2_GorePolys | :804 | 270 | BODY | Every part exists. Keep Raven's over-allocation. |
| G2_SaveGhoul2Models | :1719 | 91 | ROW-NEW N-G2SAVE | It memcpys raw class bytes. The `char **buffer` parameter is spelled wrong. |
| G2_LoadGhoul2Model | :1841 | 70 | ROW-NEW N-G2SAVE | The same, in reverse. |
| G2_LerpAngles | :1912 | 39 | BODY | `matrix[z / 4][z % 4]` (transcription.md:501). |
| G2_Animate_Bone_List (3 args) | ghoul2/G2_bones.cpp:1065 | 79 | BODY | |
| G2_SetRagDollBullet | :2040 | 110 | BODY | Drop the `#if 0` block. |
| G2_Get_Bone_Name | :2580 | 26 | BODY | |
| CBoneCache::SetRenderMatrix | renderer/tr_ghoul2.cpp:208 | 27 | BODY | The whole body is under `#ifdef _XBOX`, so the WinDed body is empty. |
| CBoneCache::SmoothLow | :267 | 85 | BODY | |
| CRenderableSurface::operator= | renderer/tr_local.h:2067 | 10 | BODY | |
| CRenderableSurface::Init | :2092 | 8 | BODY | |
| MC_Compress | renderer/matcomp.c:50 | 112 | ROW-PATTERN G13, G6 | `mat: [[Float]]` is the wrong kind. `comp` needs byte storage. |
| MC_UnCompress | :163 | 55 | ROW-PATTERN G13 | Raven writes `mat`, and a value parameter loses every write. |
| ParseTexMod | renderer/tr_shader.cpp:572 | 223 | BODY | |
| ParseSurfaceSprites | :808 | 135 | BODY | |
| ParseSurfaceSpritesOptional | :970 | 302 | BODY | |
| ParseStage | :1279 | 642 | ROW-PATTERN G14, G15 | Take the DEDICATED arms. The `image_t *images[32]` local has a count of 0 under DEDICATED. Write it as a local `[Image?]` with an AI line (G6 has no row with a pointer element). |
| ParseDeform | :1936 | 141 | BODY | |
| ParseShader | :2300 | 255 | ROW-PATTERN G14 | |
| RE_RegisterShaderFromImage | :3598 | 85 | BODY | Every form exists in R_FindShader. |
| R_LerpTag | renderer/tr_model.cpp:1768 | 36 | ROW-PATTERN G16 | `orientation_t` is not in the host unit. |
| LoadTGA | renderer/tr_image.cpp:1421 | 323 | ROW-PATTERN G11, G16 | `byte **pic`, and TGAHeader_t (`#pragma pack(1)`) goes into ded_types.h. |
| GetRefAPI | renderer/tr_init.cpp:1459 | 73 (DEDICATED arm about 15) | ROW-PATTERN G16 | `refexport_t` HOST_ROOTS row, the static `re`, and REF_API_VERSION. Precedent: GetBotLibAPI (be_interface.swift:466). |

### ICARUS_Instance.swift (8), CBlockStream.swift (4), CBlockMember.swift (1), CSequence.swift (1), CTaskManager.swift (1), CROFFSystem.swift (3), CNavigator.swift (1), vm.swift (4), win_main.swift (2), win_shared.swift (2), sv_game.swift (2)

| function | Raven | lines | class | detail |
|---|---|---|---|---|
| ICARUS_Instance::SaveSequenceIDTable | icarus/Instance.cpp:312 | 27 | ROW-PATTERN G9 | `I_WriteSaveData` takes `OpaquePointer?` (interface_export_t.swift:59, :61), and no body can pass the address of a local. With kind `bytes`, the body writes a CharBuf of the value bytes. That is the form of CNode.Save (CNode.swift:337-342), with the four-character constant as hex (CNode.swift:341). |
| SaveSequencers | :367 | 15 | ROW-PATTERN G9 | |
| SaveSignals | :389 | 26 | ROW-PATTERN G9 | |
| Save | :422 | 22 | ROW-PATTERN G9 | `ICARUS_VERSION` is in JKAMP (Generated/interpreter.swift:7). |
| LoadSignals | :451 | 25 | ROW-PATTERN G9 | `char buffer[1024]` becomes a CharBuf. |
| LoadSequences | :503 | 37 | ROW-PATTERN G9 | AllocateSequences takes `[Int32]` (ICARUS_Instance.swift:208). |
| LoadSequencers | :547 | 21 | ROW-PATTERN G9 | Raven reads `sizeof(&numSequencers)`, which is 4 on WinDed. |
| Load | :575 | 41 | ROW-PATTERN G9 | Free and I_DPrintf exist. |
| CBlockStream::GetUnsignedInteger | icarus/BlockStream.cpp:420 | 9 | BODY | `[int:]` plus `UInt32(bitPattern:)` under a "C converts" comment (ledger 10, X39 P17b). |
| CBlockStream::GetLong | :452 | 9 | BODY | MSVC `long` is Int32 (MSVC_WIDTH_FOLDERS has icarus). |
| CBlockStream::Create | :525 | 26 | BODY | `m_fileHandle` is `OpaquePointer?`. FileBackend.fopen and fwrite (l_log.swift:29, :77). StripExtension exists. |
| CBlockStream::WriteBlock | :577 | 21 | BLOCKED-BY G10 | It calls WriteMember with `m_fileHandle`. |
| CBlockMember::WriteMember | :133 | 8 | ROW-PATTERN G10 | The signature has lost its `FILE *` parameter ("No table row for `FILE *`", CBlockMember.swift:148). |
| CSequence::SaveCommand | icarus/Sequence.cpp:320 | 36 | BLOCKED-BY G9 | `bm.GetData()` is already `Slots<byte>?`. |
| CTaskManager::SaveCommand | icarus/TaskManager.cpp:1620 | 36 | BLOCKED-BY G9 | |
| CROFFSystem::ApplyROFF, client arm | qcommon/RoffSystem.cpp:820 (arm :838-848) | 11 | ROW-NEW N-ROFFCLIENT | Under DEDICATED the arm is empty, and then Raven reads uninitialized trajectories. |
| CROFFSystem::ProcessNote, game arm | :927 (call :957) | 1 | ROW-NEW N-ROFFNOTE | Known. rows-13-bot.md B2. |
| CROFFSystem::ClearLerp, client arm | :973 (arm :981-991) | 11 | ROW-NEW N-ROFFCLIENT | |
| CNavigator::GetNodeLeadDistance | server/NPCNav/navigator.h:182 | 0 | ROW-PATTERN G5 | Raven declares the method and defines no body, so no body exists to port. Use NOT_PORTED in the Cvar_FreeString form. |
| VM_VM2C | qcommon/vm.cpp:37 | 3 | ROW-PATTERN G18 | RETURNS `opaque`. The body is `OpaquePointer(bitPattern: Int(p))` with an AI line. jka-rust does the same: vm_fns.rs:44. |
| VM_SymbolToValue | :148 | 10 | BODY | The `symbols` and `next` views exist (Generated/Views/Vm.swift:177). |
| VM_SymbolForCompiledPointer | :165 | 24 | BODY | Compare the addresses with `UInt(bitPattern:)` under a "C converts" comment (X39 P17b). VM_ValueToSymbol exists (vm.swift:117). jka-rust: vm_fns.rs:327-353. |
| VM_LogSyscalls | :934 | 11 | ROW-PATTERN H-VMLOG | It needs the function statics `callnum` and `f` in the static-local form (transcription.md:480). It also needs `args - dataBase` as an Int32 offset: a `Slots<Int32>` twin of `Slots<byte>.offset(of:)` (MiniHeapViews.swift:10). jka-rust: vm_fns.rs:302. |
| Sys_FunctionCmp | null/win_main.cpp:59 | 63 | ROW-NEW N-X86 | It scans x86 opcodes at a function address. |
| Sys_FunctionCheckSum | :128 | 37 | ROW-NEW N-X86 | |
| Sys_GetCPUSpeedOld | win32/win_shared.cpp:338 | 60 | ROW-NEW N-X86 | `rdtsc` and the Win32 thread priority. |
| Sys_GetCPUSpeed | :399 | 147 | ROW-NEW N-X86 | `rdtsc` and QueryPerformanceCounter. |
| SV_GameSystemCalls G_G2_LISTBONES | server/sv_game.cpp:1316 | 2 | ROW-NEW Z6-LIST | Known. rows-13-g2.md G2. |
| SV_GameSystemCalls G_G2_LISTSURFACES | :1320 | 2 | ROW-NEW Z6-LIST | Known. |

---

## 2. Rows for one generator batch

Each row names its table, a precedent, and the stubs it unblocks. A generator change runs the full sequence once, at the end.

| # | table | row | precedent | unblocks |
|---|---|---|---|---|
| G1 | TYPES | `"TGenericParser2": "CGenericParser2?"`, `"TGPGroup": "CGPGroup?"`, `"TGPValue": "CGPValue?"` | `"captureData": "ScrollInfo?"`, rulings.py:896 | 18 GP_/GPG_/GPV_ stubs |
| G2 | CXX_CLASSES | `"CGPGroup": "CGPGroup"` | `"CGenericParser2"`, rulings.py:1620 | same as G1 |
| G3 | PARAMS | `("GP_Parse", "dataPtr"): "text_cursor"` | `("Q3_ReadScript", "buf")`, rulings.py:1192 | GP_Parse |
| G4 | RETURNS | `"GPG_FindPairValue"` and `"GPV_GetTopValue"`: `"optional_string"` (check the overloads) | rulings.py:984-989 | GPG_FindPairValue (3 args), GPV_GetTopValue (1 arg) |
| G5 | NOT_PORTED | `CleanTextPool` (C3 text pool), `Cvar_Realloc` (pool and Cvar_Defrag no-op), `GetNodeLeadDistance` (Raven has no body) | `Cvar_FreeString` on `dedicated-rulings-batch-12`; skeleton.py:1440-1443 | 3 |
| G6 | BYTE_STORAGE_LOCALS | `checksums`/CM_Checksum, `info`/FractionBelowLevel, `v`/CM_DrawDebugSurface, `comp`/MC_Compress (byte element) | `("info", "FlattenArea")` rulings.py:727; `"seq"` :605 | CM_Checksum, FractionBelowLevel, MC_Compress, part of CM_DrawDebugSurface |
| G7 | PARAMS `table` | `("CM_CarveBezierCurve", "ctls")` plus a hand method signature, and `("ProcessAutomapSymbols", "symbols")` | `("BotImport_DebugPolygonCreate", "points")` :1350; CCMLandScape.swift:589 | CarveBezierCurve, ProcessAutomapSymbols |
| G8 | PARAMS `pointer_table` | `("CM_BoxBrushes", "boxList")` | `("trap_Bot_UpdateWaypoints", "wps")` :1193 | part of CM_BoxBrushes |
| G9 | PARAMS `bytes` | `("AppendToSaveGame", "data")`, `("ReadFromSaveGame", "pvAddress")`, `("interface_export_t.I_WriteSaveData", "data")`, `("interface_export_t.I_ReadSaveData", "address")`, plus the two hand field types at interface_export_t.swift:59, :61 | `("FS_Write", "buffer")` :1309-1312; `("botlib_import_t.FS_Write", "buffer")` :1468-1469 | 8 ICARUS_Instance stubs, CSequence and CTaskManager SaveCommand |
| G10 | PARAMS `opaque` | `(<owner of CBlockMember::WriteMember>, "m_fileHandle")`. Check the owner key that table.py:2036 builds for a C++ method. | `("WriteIndent", "fp")` :1460-1462 | WriteMember, WriteBlock |
| G11 | PARAMS `bytes` | `("CRC_ContinueProcessString", "data")`, `("LoadTGA", "pic")` | `("Com_BlockChecksum", "buffer")` :1287; `("RE_RegisterModels_GetDiskFile", "ppvBuffer")` :1398 | CRC_ContinueProcessString, LoadTGA |
| G12 | PARAMS `out_scalar` | `("ParseOrigin", "flattenHeight")` | rulings.py:1498; spelling.py:596-603 | ParseOrigin, part of ParseInstance |
| G13 | PARAMS view | `("MC_Compress", "mat")`, `("MC_UnCompress", "mat")`: `("view", "mdxaBone_t")` | `("MC_UnCompressQuat", "mat")` :1481 | MC_Compress, MC_UnCompress |
| G14 | PARAMS `vec3_mut` | `("ParseVector", "v")` (the ported ParseVector body changes too) | `("CM_ParseVector", "v")` :1380 | ParseStage, ParseShader |
| G15 | FIELDS `vectors` | `("textureBundle_t", "tcGenVectors")` | `("aas_t", "vertexes")` :824 | ParseStage |
| G16 | HOST_ROOTS (and ded_types.h) | `orientation_t` (CJKAShared), `refexport_t` (CJKAMP_Ded), and `TGAHeader_t` with a `#pragma pack(1)` copy in ded_types.h | :44, :158; `botlib_export_t` :350; `StaticZeroMem_t` :221-234 | R_LerpTag, GetRefAPI, LoadTGA |
| G17 | HAND_VARS | `"RSStorage": "[CRenderableSurface]"` | `"gSequencers"` :538; `ragBoneData` :551 | AllocRS |
| G18 | RETURNS `opaque` | `"VM_VM2C"` | `Sys_GetBotAIAPI` :1034 | VM_VM2C |
| G19 | PARAMS `text` | `("botlib_export_t.BotLibVarSet", "var_name")` and `"value"` | `("botlib_import_t.BotClientCommand", "command")` :1477 | part of BotDrawDebugPolygons |
| G20 | HAND_MACROS | `PATHSEPERATOR_STR`, a hand string beside `PATH_SEP` | `__DATE__` :871; FileBackend.swift:16-23 | PC_SetIncludePath |
| G21 | DEAD (remove) | Every DEAD row that covers an in-scope stub, among them CM_DrawDebugSurface :1511, CM_BoxBrushes :1518, CM_StoreBrushes :1519, CM_Checksum :1527, BotDrawDebugPolygons :1529, ProcessAutomapSymbols :1535, CM_TerrainPatchIterate :1537, and WriteIndent and WriteFloat. The notes go to the body commit. | the user's ruling that dead functions get bodies | all of them; a note change only |

These hand items go in the same batch. Each one has a precedent and no table row:
- **H-E2:** `zeroPad: zeroPad` in `Format.swift:156-159` (rows-13-eng.md E2). Unblocks Log_WriteTimeStamped.
- **H-FPRINTF:** `FileBackend.fprintf(stream, fmt, args...) -> Int32`, a C counterpart beside `fopen` and `fwrite` (FileBackend.swift:105-122). Unblocks WriteIndent, WriteFloat, and WriteStructWithIndent. jka-rust calls `libc::fprintf` (l_struct_fns.rs:70).
- **H-RMG:**
  - MAX_RANDOM_CHOICES (precedent CRMManager.swift:7);
  - SIDE_NONE, SIDE_BLUE, and SIDE_RED (precedent AT_FLAT, Generated/cm_landscape.swift:28);
  - the cm_randomterrain noise statics (precedent CPathInfo.swift:480).
  
  Unblocks ParseRandom and Generate, and part of ParseInstance and ParseInstancesOnPath.
- **H-VMLOG:** the two static locals of VM_LogSyscalls, and a `Slots<Int32>` offset twin of MiniHeapViews.swift:10. Unblocks VM_LogSyscalls.

**Count for the generator batch: 21 table rows (G1 to G21) and 4 hand items.**

---

## 3. ROW-NEW: the rows for the user

| row | stubs | what is new | candidates and costs | jka-rust |
|---|---|---|---|---|
| **N-RMG**: CRMInstance hierarchy | PlaceWallInstance, plus the 8 BLOCKED-BY in CRMMission | Base CRMInstance with about 15 virtuals and the BSP, Group, Random, and Void subclasses (RM_Instance*.cpp, 1543 lines), plus CRMInstanceFile. No class with a subclass is ported yet. | A: a non-final class with `override`. It looks like Raven, but rule 17 does not list it, and it needs a base-class column in CXX_CLASSES. B: an enum with a switch (rule 17, the form of rows-13-bot.md B5). Each virtual becomes a switch, and the Group and Random payloads hold instances. C: a protocol with one class for each Raven class. The base fields repeat, and an extension method dispatches statically. | Dropped under RMG-D1 (crates/mp/engine/rmg/src/lib.rs:3-9) |
| **Z6-LIST**: G_G2_LISTBONES and G_G2_LISTSURFACES | 2 | Raven casts a `CGhoul2Info_v *` word to `CGhoul2Info *`, which is undefined. | A: `instance(word:)![0]` (recommended in rows-13-g2.md G2). B: pass nil. C: a new dead-arm form. | Raw reinterpret, sv_game.rs:3023-3037 |
| **N-ROFFNOTE**: ProcessNote game arm | 1 | Text as a VM_Call word | A hand `withTextWord` beside `withVectorWords` (VmEntry.swift:75-82), rows-13-bot.md B2. Cost: one hand view helper. | `CString` kept for the call, roff_system.rs:781-791 |
| **N-ROFFCLIENT**: ApplyROFF and ClearLerp client arms | 2 | Under DEDICATED the arm is empty, and Raven then reads uninitialized trajectories. | A: `return false` in the arm, with a rule 19 line. B: `Com_Error`. C: keep the arm empty and give the `let`s a value: this is not possible in Swift. | Arm dropped as §20 (roff_system.rs:651, :842) |
| **X2**: BotReplaceSynonyms thunk | 1 | An in-place `char *` with no bound | A: capacity MAX_MESSAGE_SIZE with an AI line. B: strlen+1, which traps on any growth (rows-13-bot.md B1). | Raw pointer, no bound, be_ai_chat_fns.rs:586 |
| **N-STRSLOTS**: a `char *x[]` table that can hold NULL | 3, plus 2 BLOCKED-BY in be_aas_main | No PARAMS kind gives `Slots<String?>` | A: a new kind `string_slots`, near `pointer_table` (:1193). B: copy into `ArraySlice<String>` with nil changed to "". This loses Raven's NULL arm. | Raw `*mut *mut c_char`, be_aas_main.rs:76, :192 |
| **N-CLOSURE**: a parameter of a closure parameter | BotDrawDebugPolygons, CM_DrawDebugSurface | `table.closure` (table.py:2129) passes no owner, so no row reaches `points` of `drawPoly` | A: an owner key `"<fn>.drawPoly"` and kind `table`, which gives `Slots<vec3_t>` (one lookup branch). B: `[vec3_t]` or `[Float]`, with a copy at each call. | Not ported (cm_patch_fns.rs:15-21) |
| **N-GP2**: GP2 sibling and in-order links | 8 GP2 stubs | Ruling C3 replaced the links with arrays, and CGPValue is a struct | A: reopen C3 in part. CGPValue becomes a class with weak links, and CGPGroup gets in-order links. B: find the neighbour through the parent's arrays (this fails for values). C: NOT_PORTED-replaced (this goes against the new ruling). | Handle API not ported (gp2/mod.rs:12-15) |
| **N-USERDATA**: TerrainPatchIterate `void *userdata` | 1, plus 1 BLOCKED-BY (CM_TerrainPatchIterate) | A callback with an untyped userdata, and the real userdata is a `CRMLandScape *` | A: drop `userdata`, and the closure captures it. B: `AnyObject?`, with a downcast. C: a typed CRMLandScape (it needs the RM_Terrain port). | Not ported (cm_terrain.rs:59-60) |
| **N-LEAFLIST**: `leafList_t.list` holds brush pointers | CM_StoreBrushes, plus CM_BoxBrushes BLOCKED-BY | One field read as two element types | A: a second accessor `listBrushes: Slots<Cbrush?>?`. B: FIELDS `raw`, and every user moves to byte offsets. | Casts, cm_test.rs:123, :257 |
| **N-G2SAVE**: Ghoul2 save and load layout | G2_SaveGhoul2Models, G2_LoadGhoul2Model | Raw memcpy of hand classes with no C layout (a 116-byte CGhoul2Info band, and the boneInfo_t, surfaceInfo_t, and boltInfo_t records) | A: write each field at Raven's 32-bit offset with a hand offset list. The pointer fields cannot round-trip. B: a Swift field order (not byte-compatible, and it adds new helpers). Both need the `bytes` signature rows on G2_/G2API_ Save, Load, and FreeSaveBuffer. | Form B, misc.rs:1553-1760 |
| **N-GORE**: G2_GetGoreRecord `void *` return over a hand class | 1 | No RETURNS tuple for a class | A: RETURNS `("class_ref", "GoreTextureCoordinates")`. B: a hand signature `-> GoreTextureCoordinates?` with a rule 24 line. | Dropped (api_gore.rs:16) |
| **N-LOCALTABLE**: a local table of records | PC_AddBuiltinDefines | A non-static local `struct builtin[]` with a `{NULL,0}` end row | A: a local array of labeled tuples with a nil end row (no new type). B: a local struct. | Local tuple array, l_precomp_fns.rs:374-392 |
| **N-X86**: x86 machine facts | Sys_FunctionCmp, Sys_FunctionCheckSum, Sys_GetCPUSpeedOld, Sys_GetCPUSpeed | Opcode scans at function addresses, `rdtsc`, Win32 thread priority, and QueryPerformanceCounter | A: SysBackend members that read a cycle counter and a performance counter (precedent SysBackend.GetFileTime, SysBackend.swift:547). The opcode scans have no meaning on arm64. B: NOT_PORTED with the platform reason, the VM_DllSyscall form. | Not in jka-rust (the unix link set) |

**14 ROW-NEW rows, which cover 30 stubs directly and 14 BLOCKED-BY stubs.**

---

## 4. Body sets

These rules apply to every set:
- Two sets that run at the same time never edit the same file.
- A file that has sets in two waves is edited in order.
- Line counts are Raven body lines.

### Can start now (all BODY): 8 sets, 109 functions, 3906 lines

| set | files | functions (Raven file:line) | n | lines |
|---|---|---|---|---|
| S1 | be_aas_bspq3, be_aas_cluster, be_aas_entity, be_aas_move, be_aas_reach | AAS_inPVS :174, AAS_inPHS :185, AAS_BoxEntities :225, AAS_BSPTraceLight :433 (be_aas_bspq3.cpp); AAS_ClearCluster :61, AAS_RemovePortalsClusterReference :79, AAS_NumberClusterPortals :271, AAS_RemoveAllPortals :920 (be_aas_cluster.cpp); AAS_EntityOrigin :178, AAS_EntitySize :269, AAS_EntityBSPData :291, AAS_NearestEntity :362, AAS_BestReachableEntityArea :397 (be_aas_entity.cpp); AAS_SetMovedir :218, AAS_AirControl :373, AAS_TestMovementPrediction :1016 (be_aas_move.cpp); AAS_AreaLiquid :664, AAS_BarrierJumpTravelTime :758, AAS_NearbySolidOrGap :787 (be_aas_reach.cpp) | 19 | 222 |
| S2 | be_aas_route, be_aas_sample, be_ea, be_ai_goal, CBlockStream, vm, EngineWorld (the hidetraveltimes static only) | AAS_CreateAllRoutingCache :870, AAS_BridgeWalkable :1892, DistancePointToLine :2049, AAS_NearestHideArea :2063 (be_aas_route.cpp); AAS_BoxOriginDistanceFromPlane :349, AAS_AreaGroundFace :1001, AAS_FacePlane :1035, AAS_TraceEndFace :1050 (be_aas_sample.cpp); EA_Tell :55, EA_UseItem :65, EA_DropItem :75, EA_UseInv :85, EA_DropInv :95 (be_ea.cpp); BotFindEntityForLevelItem be_ai_goal.cpp:949; CBlockStream GetUnsignedInteger :420, GetLong :452, Create :525 (BlockStream.cpp); VM_SymbolToValue vm.cpp:148, VM_SymbolForCompiledPointer :165 | 19 | 416 |
| S3 | be_ai_chat, l_script | BotDumpSynonymList :553, BotDumpRandomStringList :904, BotDumpMatchTemplates :1060, BotDumpReplyChat :1619, BotDumpInitialChat :1971, BotPrintReplyChatKeys :2556 (be_ai_chat.cpp); PS_ReadLiteral :721, PS_ExpectTokenString :909, PS_CheckTokenString :1008, PS_CheckTokenType :1025, PS_SkipUntilString :1047, PS_UnreadLastToken :1063, PS_UnreadToken :1073, PS_NextWhiteSpaceChar :1085, ReadSignedFloat :1136, ReadSignedInt :1159, GetScriptFlags :1192, ResetScript :1202, NumLinesCrossed :1237, ScriptSkipTo :1247 (l_script.cpp) | 20 | 367 |
| S4 | l_precomp, l_crc, cm_polylib | PC_PrintDefineHashTable :516, PC_FindDefine :604, PC_DefineFromString :1323, PC_AddDefine :1381, PC_RemoveGlobalDefine :1426, PC_CopyDefine :1479, PC_CheckTokenType :2955, PC_SkipUntilString :2977, PC_SetPunctuations :3029, LoadSourceMemory :3080 (l_precomp.cpp); CRC_ProcessByte l_crc.cpp:85; pw cm_polylib.cpp:17 | 12 | 214 |
| S5 | tr_ghoul2, CRenderableSurface | G2_Find_Bone_ByNum :112, G2_GetBoneNameFromSkel :678, G2_GetParentBoneMatrixLow :780, R_GCullModel :896, R_GComputeFogNum :939, G2_ComputeLOD :967, G2_CreateQuaterion :1048, G2_CreateMatrixFromQuaterion :1097, G2_SetUpBolts :2053, G2_ProcessSurfaceBolt :2246, G2_ProcessGeneratedSurfaceBolts :2495, ProcessModelBoltSurfaces :2739, bInShadowRange :3369 (tr_ghoul2.cpp); CRenderableSurface operator= tr_local.h:2067, Init :2092 | 15 | 635 |
| S6 | G2_misc, G2_bones, CBoneCache | G2_GorePolys G2_misc.cpp:804, G2_LerpAngles :1912; G2_Animate_Bone_List G2_bones.cpp:1065, G2_SetRagDollBullet :2040, G2_Get_Bone_Name :2580; CBoneCache SetRenderMatrix tr_ghoul2.cpp:208, SmoothLow :267 | 7 | 636 |
| S7 | tr_shader | ParseTexMod :572, ParseSurfaceSprites :808, ParseSurfaceSpritesOptional :970, ParseDeform :1936, RE_RegisterShaderFromImage :3598 (tr_shader.cpp) | 5 | 886 |
| S8 | CRMMission, CRandomTerrain | ParseNodes :248, ParsePaths :294, ParseRivers :340, ParseObjectives :1000, ParseAmmo :1040, ParseWeapons :1090, ParseOutfit :1147, ParseInstances :966, ParseDifficulty :1236 (RM_Mission.cpp); CreatePath :605, GetPathInfo :628, Smooth :644 (cm_randomterrain.cpp) | 12 | 530 |

### Wait on the generator batch: 6 sets, 81 functions, 2663 lines

| set | files | functions | n | lines | waits on |
|---|---|---|---|---|---|
| W1 | GenericParser2 | CleanTextPool :212 (marker only), GP_Parse :928, GP_Clean :942, GP_Delete :952, GP_GetBaseParseGroup :963, GPG_GetName :977 and :987, GPG_GetNext :999, GPG_GetSubGroups :1049, GPG_GetInOrderSubGroups :1059, GPG_FindSubGroup :1069, GPG_FindPair :1079, GPG_FindPairValue :1089 and :1099, GPV_GetName :1110 and :1120, GPV_IsList :1162, GPV_GetTopValue :1172 and :1182 (GenericParser2.cpp) | 19 | 171 | G1 to G5 |
| W2 | CCMLandScape, cm_load, vm, CNavigator | GetTerxelLocalCoords :862, CarveLine :1133, CarveBezierCurve :1245, FractionBelowLevel :1379, GetFirstObjectiveArea :1422, GetPlayerArea :1442, GetNextObjectiveArea :1472 (cm_terrain.cpp); CM_Checksum cm_load.cpp:544; VM_VM2C vm.cpp:37, VM_LogSyscalls :934; GetNodeLeadDistance navigator.h:182 (marker only) | 11 | 326 | G5, G6, G7, G18, H-VMLOG |
| W3 | CRMMission, CRMManager, CRandomTerrain, l_crc, l_struct, l_log, cvar | ParseRandom RM_Mission.cpp:1189, ParseOrigin :163; ProcessAutomapSymbols RM_Manager.cpp:442; Generate cm_randomterrain.cpp:770; CRC_ContinueProcessString l_crc.cpp:126; WriteIndent l_struct.cpp:313, WriteFloat :327, WriteStructWithIndent :355, WriteStructure :441; Log_WriteTimeStamped l_log.cpp:113; Cvar_Realloc cvar.cpp:965 (marker only) | 11 | 347 | G5, G7, G11, G12, H-RMG, H-FPRINTF, H-E2 |
| W4 | tr_ghoul2, matcomp, tr_model, tr_image, tr_init | AllocRS tr_ghoul2.cpp:869; MC_Compress matcomp.c:50, MC_UnCompress :163; R_LerpTag tr_model.cpp:1768; LoadTGA tr_image.cpp:1421; GetRefAPI tr_init.cpp:1459 | 6 | 607 | G6, G11, G13, G16, G17 |
| W5 | tr_shader | ParseStage :1279, ParseShader :2300 (tr_shader.cpp) | 2 | 897 | G14, G15 |
| W6 | ICARUS_Instance, CBlockMember, CBlockStream, CSequence, CTaskManager | SaveSequenceIDTable :312, SaveSequencers :367, SaveSignals :389, Save :422, LoadSignals :451, LoadSequences :503, LoadSequencers :547, Load :575 (Instance.cpp); WriteMember BlockStream.cpp:133, WriteBlock :577; CSequence SaveCommand Sequence.cpp:320; CTaskManager SaveCommand TaskManager.cpp:1620 | 12 | 315 | G9, G10 |

### Wait on the user's ROW-NEW rulings: 6 sets, 23 stub functions, 1759 stub lines, plus 1543 lines of RMG classes

| set | files | functions | n | lines | waits on |
|---|---|---|---|---|---|
| R1a | new RM_Instance files, CRMInstanceFile | the CRMInstance base, CRMBSPInstance, CRMVoidInstance, CRMInstanceFile (RM_Instance.cpp, RM_InstanceFile.cpp) | classes | about 800 | N-RMG |
| R1b | new RM_Instance files | CRMGroupInstance, CRMRandomInstance (RM_GroupInstance.cpp, RM_RandomInstance.cpp) | classes | about 740 | R1a |
| R1c | CRMMission | ~CRMMission :85, Load :1362, Spawn :1438, Preview :1711, PlaceBridges :379, PlaceWallInstance :450, ParseInstance :886, ParseInstancesOnPath :737, ParseWallRect :485 (RM_Mission.cpp) | 9 | 804 | R1b, G12, H-RMG |
| R2 | GenericParser2, CCMLandScape, cm_terrain, cm_test, cm_patch, sv_bot | GPG_GetInOrderNext :1009, GPG_GetInOrderPrevious :1019, GPG_GetPairs :1029, GPG_GetInOrderPairs :1039, GPV_GetNext :1132, GPV_GetInOrderNext :1142, GPV_GetInOrderPrevious :1152, GPV_GetList :1195 (GenericParser2.cpp); TerrainPatchIterate cm_terrain.cpp:997, CM_TerrainPatchIterate :1628; CM_StoreBrushes cm_test.cpp:80, CM_BoxBrushes :194; CM_DrawDebugSurface cm_patch.cpp:1651; BotDrawDebugPolygons sv_bot.cpp:227 | 14 | 338 | N-GP2, N-USERDATA, N-LEAFLIST, N-CLOSURE, G6, G8, G19 |
| R3 | be_aas_main, be_interface, l_precomp, sv_game, CROFFSystem, G2_misc | AAS_StringFromIndex :56, AAS_IndexFromString :84, AAS_ModelFromIndex :105, AAS_IndexFromModel :115, AAS_UpdateStringIndexes :125 (be_aas_main.cpp); BotReplaceSynonyms thunk be_ai_chat.cpp:744; PC_AddBuiltinDefines l_precomp.cpp:665, PC_SetIncludePath :3013; G_G2_LISTBONES sv_game.cpp:1316, G_G2_LISTSURFACES :1320; ApplyROFF RoffSystem.cpp:820, ProcessNote :927, ClearLerp :973 (arms); G2_GetGoreRecord G2_misc.cpp:113, G2_SaveGhoul2Models :1719, G2_LoadGhoul2Model :1841 | 16 | 310 | N-STRSLOTS, X2, N-LOCALTABLE, G20, Z6-LIST, N-ROFFNOTE, N-ROFFCLIENT, N-GORE, N-G2SAVE |
| R4 | win_main, win_shared | Sys_FunctionCmp null/win_main.cpp:59, Sys_FunctionCheckSum :128; Sys_GetCPUSpeedOld win32/win_shared.cpp:338, Sys_GetCPUSpeed :399 | 4 | 307 | N-X86 |

R1a and R1b have no stubs. They are the prerequisite classes. Their split follows the RM_Instance*.cpp files, and the line counts are approximate.

### Waves of six (no file conflict inside a wave)

1. **Wave 1, now:** S7, S5, S6, S8, S2, S3.
2. **Wave 2, after the generator batch:** S1, S4, W1, W2, W4, W5. S1 and S4 can start now too if a slot is free.
3. **Wave 3, after the rulings:** W3, W6, R1a, R2, R3, R4.
4. **Wave 4:** R1b.
5. **Wave 5:** R1c.

R2 and R3 can move up to wave 2 or wave 3 when the user rules their rows. Do not run them beside W1 or W2 (GenericParser2, CCMLandScape), or beside S4 (l_precomp), or beside S6 (G2_misc).

## 5. Total estimate

- **Sets:** 20. That is 8 that start now, 6 that wait on the generator batch, and 6 that wait on the ROW-NEW rulings. Of the last 6, 2 are prerequisite RMG class sets.
- **Raven lines:**
  - 8,328 in the 213 stub bodies (3,906 start now, 2,663 after the batch, 1,759 after the rulings);
  - 1,543 in the RMG instance classes;
  - **about 9,870 in total.**
- **The largest single bodies:** ParseStage (642), ParseSurfaceSpritesOptional (302), LoadTGA (323), G2_GorePolys (270), ParseShader (255), and G2_ProcessSurfaceBolt (246).
- **Proof gaps:**
  - The owner key of a PARAMS row for a C++ method (G10) is not proved. Check table.py:2036 and the skeleton caller.
  - The be_ai_chat scope: the parallel batch is said to close "about 5" there, but its branch closes only the 3 console stubs.
