# Docket 12: the 234 remaining `portMissing(` stubs in Sources/JKAMP_DedLogic

Tree: `/tmp/jka-int-11`, branch `dedicated-integration-11`. Read-only census. Four opus agents read the slices. The coordinator merged the results and checked the main proof chain (cm_terrain.cpp:169-171).

Swift paths are under `Sources/JKAMP_DedLogic/`. Raven paths are under `oracle/codemp/`.

## Main finding

209 of 234 stubs are DEAD. Rule 20 (`docs/porting-rules.md:45`) keeps a dead function as its generated stub with a `TODO: Port` marker. `skeleton.py:1473-1474` shows that a DEAD row only adds the note line, and every file in this list is adopted. So **the goal "zero stubs" conflicts with rule 20**. For 209 stubs, the decision is a rule ruling, not a row or a body:
- **Rule-20-keep:** the dead stubs stay as they are. Only their notes need fixes (listed below). After the BODY wave and the rows, 209 stubs remain.
- **Rule-20-drop:** a new rule form removes the dead function and keeps one marker line, as NOT_PORTED does (`skeleton.py:1440-1443`). That reaches zero stubs, but NOT_PORTED now means "a ruling replaces it", not "it is dead". This needs a ruling, and a hand deletion in each adopted file.

The CRMInstance virtual hierarchy blocks nothing in the dedicated server. The dedicated build never makes a CRandomTerrain, so it never makes a CRMMission:
1. `qcommon/cm_terrain.cpp:169-171`: `mRandomTerrain = 0`, and under `#ifdef DEDICATED`, `imageData = NULL`.
2. `cm_terrain.cpp:178`: the one `CreateRandomTerrain` call is in the `#else` arm.
3. `RMG/RM_Manager.cpp:82` gets `mTerrain = landscape->GetRandomTerrain()`, which is NULL. Then `:110` runs `if (!mTerrain) return false;`, so `new CRMMission` at `:135` never runs.
4. `RM_Mission.cpp:71`: the one `new CRMPathManager` is in the CRMMission constructor.

This proof form is new: the callers link, but no path reaches them because a DEDICATED arm stores 0. The LoadTGA precedent (`rulings.py:1513`) has its caller under `#ifndef DEDICATED`. Rule this proof form once (row **DEAD-BY-DEDICATED-NULL**).

Risk: the CRMMission deinit stub calls `portMissing` with no condition. Release of any CRMMission traps. In the dedicated server no CRMMission exists.

## Count per class

| class | count |
|---|---|
| BODY | 16 |
| ROW-PATTERN | 5 |
| ROW-NEW | 4 |
| DEAD | 209 |
| BLOCKED-BY | 0 |
| **total** | **234** |

---

## GenericParser2.swift (27): all DEAD

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| CleanTextPool | qcommon/GenericParser2.cpp:212 | `CTextPool *` has no type (row C3) | DEAD | Its one caller, CGenericParser2::Clean (:907), drops the call (`GenericParser2.swift:676`) |
| GP_Parse | :928 | no row for `TGenericParser2` return | DEAD | C interface. GP_/GPG_/GPV_ calls exist only in GenericParser2.cpp/.h and code/game/genericparser2.* |
| GP_Clean | :942 | rule 20 note | DEAD | same proof |
| GP_Delete | :952 | rule 20 note | DEAD | same proof |
| GP_GetBaseParseGroup | :963 | no row for `TGPGroup` | DEAD | same proof |
| GPG_GetName (1 arg) | :977 | rule 20 note | DEAD | same proof |
| GPG_GetName (2 args) | :987 | rule 20 note | DEAD | same proof |
| GPG_GetNext | :999 | `TGPGroup` | DEAD | same proof |
| GPG_GetInOrderNext | :1009 | `TGPGroup` | DEAD | same proof |
| GPG_GetInOrderPrevious | :1019 | `TGPGroup` | DEAD | same proof |
| GPG_GetPairs | :1029 | `TGPGroup` | DEAD | same proof |
| GPG_GetInOrderPairs | :1039 | `TGPGroup` | DEAD | same proof |
| GPG_GetSubGroups | :1049 | `TGPGroup` | DEAD | same proof |
| GPG_GetInOrderSubGroups | :1059 | `TGPGroup` | DEAD | same proof |
| GPG_FindSubGroup | :1069 | `TGPGroup` | DEAD | same proof |
| GPG_FindPair | :1079 | `TGPValue` | DEAD | same proof |
| GPG_FindPairValue (3 args) | :1089 | rule 20 note | DEAD | same proof |
| GPG_FindPairValue (4 args) | :1099 | rule 20 note | DEAD | same proof |
| GPV_GetName (1 arg) | :1110 | rule 20 note | DEAD | same proof |
| GPV_GetName (2 args) | :1120 | rule 20 note | DEAD | same proof |
| GPV_GetNext | :1132 | `TGPValue` | DEAD | same proof |
| GPV_GetInOrderNext | :1142 | `TGPValue` | DEAD | same proof |
| GPV_GetInOrderPrevious | :1152 | `TGPValue` | DEAD | same proof |
| GPV_IsList | :1162 | rule 20 note | DEAD | same proof |
| GPV_GetTopValue (1 arg) | :1172 | rule 20 note | DEAD | same proof |
| GPV_GetTopValue (2 args) | :1182 | rule 20 note | DEAD | same proof |
| GPV_GetList | :1195 | `TGPValue` | DEAD | same proof |

## CRMMission.swift (20): all DEAD (DEAD-BY-DEDICATED-NULL or no caller)

"Secondary" is the class if a client build or a fork ports the stub.

| function | Raven | reason | class | detail and secondary |
|---|---|---|---|---|
| ~CRMMission (instance loop in deinit) | RMG/RM_Mission.cpp:85 | no `mInstances` | DEAD | dedicated-null. Secondary: CRMInstance-virtuals |
| Load | :1362 | marker only | DEAD | dedicated-null. Secondary: CRMInstance-virtuals (`mInstanceFile.Open` :1400) |
| Spawn | :1438 | marker only | DEAD | dedicated-null. Secondary: CRMInstance-virtuals (PreSpawn, Spawn, PostSpawn virtual) |
| Preview | :1711 | marker only | DEAD | no caller: CRMManager::Preview (RM_Manager.cpp:374) has none. Secondary: CRMInstance-virtuals |
| ParseRandom | :1189 | marker only | DEAD | dedicated-null. Secondary: ROW-PATTERN hand `let MAX_RANDOM_CHOICES = 100 as Int32` (RM_Mission.h:10), precedent `CRMManager.swift:7`; rule 19 note for the write past index 99 before the assert at :1211 |
| ParseOrigin | :163 | no row for `int* flattenHeight` | DEAD | dedicated-null. Secondary: ROW-PATTERN out_scalar `inout Int32`, precedent `rulings.py:1498`, `spelling.py:603`; AI line at each always-true `if (flattenHeight)` |
| ParseNodes | :248 | marker only | DEAD | dedicated-null. Secondary: BODY |
| ParsePaths | :294 | marker only | DEAD | dedicated-null. Secondary: BODY |
| ParseRivers | :340 | marker only | DEAD | dedicated-null. Secondary: BODY |
| PlaceBridges | :379 | marker only | DEAD | dedicated-null. Secondary: CRMInstance-virtuals |
| PlaceWallInstance | :450 | no row for `CRMInstance*` | DEAD | one caller ParseWallRect, dead. Secondary: CRMInstance-virtuals |
| ParseDifficulty | :1236 | marker only | DEAD | dedicated-null. Secondary: BODY |
| ParseWeapons | :1090 | marker only | DEAD | calls only in comments (:1156, :1288) |
| ParseAmmo | :1040 | marker only | DEAD | calls only in comments (:1166, :1298) |
| ParseOutfit | :1147 | marker only | DEAD | call only in a comment (:1284) |
| ParseObjectives | :1000 | marker only | DEAD | call only in a comment (:1309) |
| ParseInstance | :886 | marker only | DEAD | dedicated-null. Secondary: CRMInstance-virtuals, and ParseOrigin out_scalar |
| ParseInstances | :966 | marker only | DEAD | dedicated-null. Secondary: BODY (loop over ParseInstance) |
| ParseInstancesOnPath | :737 | marker only | DEAD | dedicated-null. Secondary: CRMInstance-virtuals |
| ParseWallRect | :485 | marker only | DEAD | one call commented out at :922. Secondary: CRMInstance-virtuals |

## CCMLandScape.swift (8): all DEAD

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| TerrainPatchIterate | qcommon/cm_terrain.cpp:997 | no row for fn pointer and `void *` | DEAD | one caller CM_TerrainPatchIterate (:1630), DEAD at `rulings.py:1537` |
| GetTerxelLocalCoords | :862 | dead note | DEAD | 3 calls (:948-950) in the comment block :929-969 |
| CarveLine | :1133 | dead note | DEAD | one caller CarveBezierCurve, dead |
| CarveBezierCurve | :1245 | dead note | DEAD | one caller CM_CarveBezierCurve (:1645), no caller |
| FractionBelowLevel | :1379 | dead note | DEAD | one caller CM_FractionBelowLevel (:1655), no caller |
| GetFirstObjectiveArea | :1422 | dead note | DEAD | CM_GetFirstObjectiveArea (:1670), no caller |
| GetPlayerArea | :1442 | dead note | DEAD | CM_GetPlayerArea (:1675), no caller |
| GetNextObjectiveArea | :1472 | dead note | DEAD | CM_GetNextObjectiveArea (:1685), no caller |

## CRandomTerrain.swift (4): all DEAD (dedicated-null)

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| CreatePath | qcommon/cm_randomterrain.cpp:605 | dead note | DEAD | caller CRMPathManager (RM_Path.cpp:327) never exists. Secondary: BODY |
| GetPathInfo | :628 | dead note | DEAD | callers in CRMMission. Secondary: BODY |
| Smooth | :644 | dead note | DEAD | caller CRMMission::Spawn (:1463). Secondary: BODY |
| Generate | :770 | dead note | DEAD | caller CRMMission::Load (:1417). Secondary: blocked by CM_NoiseInit and CM_NoiseGet4f, file statics of the `deferred` cm_randomterrain.cpp (`project.toml:90`) |

## CRMManager.swift (1)

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| ProcessAutomapSymbols | RMG/RM_Manager.cpp:442 | no row for `rmAutomapSymbol_t *` | DEAD | `rulings.py:1535`. Body and callers under `#ifndef DEDICATED` |

## be_ai_char.swift (16): all BODY

The stub reason "row P2" is stale. Row X22 landed (`rulings.py:464`), and the view has `Cvalue.integer`, `_float`, and `string: String?` with an interning setter (`Sources/JKAMP_Ded/Generated/Views/Cvalue.swift:66-80`). Each string store or free needs a rule 24 `// AI:` line, because Raven's `GetMemory`/`strcpy`/`FreeMemory` becomes an interned `String?`. None of these traps has a game caller, but the functions are linked.

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| BotDumpCharacter | botlib/be_ai_char.cpp:88 | P2 (stale) | BODY | switch with 3 `Log_Write` calls |
| BotFreeCharacterStrings | :112 | P2 | BODY | the free drops under an AI line (precedent ledger 7 row CM5) |
| BotDefaultCharacteristics, float arm | :163 | P2 | BODY | `._float` copy |
| BotDefaultCharacteristics, int arm | :163 | P2 | BODY | `.integer` copy |
| BotDefaultCharacteristics, string arm | :163 | P2 | BODY | one `.string` store, AI line |
| BotLoadCharacterFromFile, float arm | :195 | P2 | BODY | `Float(token.floatvalue)` (form at be_ai_chat.swift:581) |
| BotLoadCharacterFromFile, int arm | :195 | P2 | BODY | `Int32(bitPattern: token.intvalue)` (form at be_ai_char.swift:211) |
| BotLoadCharacterFromFile, string arm | :195 | P2 | BODY | `.string = token.string`, AI line |
| BotInterpolateCharacters, float arm | :499 | P2 | BODY | lerp on `._float` |
| BotInterpolateCharacters, int arm | :499 | P2 | BODY | `.integer` copy |
| BotInterpolateCharacters, string arm | :499 | P2 | BODY | `.string` store, AI line |
| Characteristic_Float, int arm | :624 | P2 | BODY | `Float(.value.integer)` |
| Characteristic_Float, float arm | :624 | P2 | BODY | `.value._float` |
| Characteristic_Integer, int arm | :679 | P2 | BODY | `.value.integer` |
| Characteristic_Integer, float arm | :679 | P2 | BODY | `Int32(.value._float)` |
| Characteristic_String | :733 | P2 | BODY | `strncpy(&buf, …, size - 1)` (JKAShared/CString.swift:340); `size` bounds the write |

## l_script.swift (14): all DEAD

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| PS_ReadLiteral | botlib/l_script.cpp:721 | dead | DEAD | only call in a comment at :870 |
| PS_ExpectTokenString | :909 | dead | DEAD | only the decl l_script.h:181 |
| PS_CheckTokenString | :1008 | dead | DEAD | only the decl :187 |
| PS_CheckTokenType | :1025 | dead | DEAD | only the decl :189 |
| PS_SkipUntilString | :1047 | dead | DEAD | only the decl :191 |
| PS_UnreadLastToken | :1063 | dead | DEAD | only the decl :193 |
| PS_UnreadToken | :1073 | dead | DEAD | only the decl :195 |
| PS_NextWhiteSpaceChar | :1085 | dead | DEAD | only the decl :197 |
| ReadSignedFloat | :1136 | dead | DEAD | only the decl :205 |
| ReadSignedInt | :1159 | dead | DEAD | only the decl :203 |
| GetScriptFlags | :1192 | dead | DEAD | only the decl :211 |
| ResetScript | :1202 | dead | DEAD | only the decl :213 |
| NumLinesCrossed | :1237 | dead | DEAD | no reference |
| ScriptSkipTo | :1247 | dead | DEAD | no reference |

## l_precomp.swift (12): all DEAD

`DEFINEHASHING` is 1 at l_precomp.cpp:83.

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| PC_PrintDefineHashTable | botlib/l_precomp.cpp:516 | dead | DEAD | only call in a comment at :3122 |
| PC_FindDefine | :604 | DEFINEHASHING arm | DEAD | every call in a `#else` or `#if !DEFINEHASHING` arm (:1202, :1219, :1578, :1790, :2231, :2336, :1431). No DEAD row yet |
| PC_AddBuiltinDefines | :665 | dead | DEAD | only the decl l_precomp.h:126 |
| PC_DefineFromString | :1323 | dead | DEAD | callers: dead PC_AddDefine and a `#if !DEFINEHASHING` arm. No DEAD row yet |
| PC_AddDefine | :1381 | dead | DEAD | only the decl :118 |
| PC_RemoveGlobalDefine | :1426 | dead | DEAD | only the decl :122 |
| PC_CopyDefine | :1479 | DEFINEHASHING arm | DEAD | one call at :1543 in the `#else` arm. No DEAD row yet |
| PC_CheckTokenType | :2955 | dead | DEAD | only the decl :106 |
| PC_SkipUntilString | :2977 | dead | DEAD | only the decl :108 |
| PC_SetIncludePath | :3013 | dead | DEAD | only the decl :128 |
| PC_SetPunctuations | :3029 | dead | DEAD | only the decl :130 |
| LoadSourceMemory | :3080 | dead | DEAD | only the decl :136 |

## be_ai_chat.swift (9)

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| BotRemoveConsoleMessage | botlib/be_ai_chat.cpp:279 | `bot_consolemessage_t.handle` has no accessor | ROW-PATTERN | FN-consolehandle |
| BotQueueConsoleMessage | :309 | both `handle` fields | ROW-PATTERN | FN-consolehandle and FN-chathandle |
| BotNextConsoleMessage | :350 | `bot_consolemessage_t.handle` | ROW-PATTERN | FN-consolehandle |
| BotDumpSynonymList | :553 | dead | DEAD | only call in a comment at :733 |
| BotDumpRandomStringList | :904 | dead | DEAD | only call in a comment at :1020 |
| BotDumpMatchTemplates | :1060 | dead | DEAD | only call in a comment at :1330 |
| BotDumpReplyChat | :1619 | dead | DEAD | only call in a comment at :1955 |
| BotDumpInitialChat | :1971 | dead | DEAD | only call in a comment at :2151 |
| BotPrintReplyChatKeys | :2556 | dead | DEAD | no reference |

The generated views say "No module body reads it" at `Generated/Views/BotConsolemessage.swift:64` and `BotChatstate.swift:100`. This is false: be_ai_chat.cpp reads and writes these fields at :279-300, :309 and :350.

## l_struct.swift (4), l_crc.swift (2), l_log.swift (1): all DEAD

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| WriteIndent | botlib/l_struct.cpp:313 | DEBUG_AI_WEAP | DEAD | `rulings.py:1532`. The row text says WriteStructWithIndent is the one caller; be_ai_weight.cpp:433-526 also calls it, under `#if 0` (:421-533) |
| WriteFloat | :327 | DEBUG_AI_WEAP | DEAD | `rulings.py:1533`, same text issue |
| WriteStructWithIndent | :355 | dead | DEAD | callers: itself (:410) and WriteStructure |
| WriteStructure | :441 | dead | DEAD | callers be_ai_weap.cpp:165, :170 under `#ifdef DEBUG_AI_WEAP` |
| CRC_ProcessByte | botlib/l_crc.cpp:85 | dead | DEAD | only the decl l_crc.h:13 |
| CRC_ContinueProcessString | :126 | dead | DEAD | only the decl l_crc.h:16 |
| Log_WriteTimeStamped | botlib/l_log.cpp:113 | "no `0` flag" (stale: `JKAShared/Format.swift:100-105`, `:226-235` pad with zeros) | DEAD | only the decl l_log.h:24. Replace the stale note with a rule 20 note |

## AAS files (32): all DEAD

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| EA_Tell | botlib/be_ea.cpp:55 | no caller | DEAD | only the definition |
| EA_UseItem | be_ea.cpp:65 | no caller | DEAD | same |
| EA_DropItem | be_ea.cpp:75 | no caller | DEAD | same |
| EA_UseInv | be_ea.cpp:85 | no caller | DEAD | same |
| EA_DropInv | be_ea.cpp:95 | no caller | DEAD | same |
| AAS_StringFromIndex | be_aas_main.cpp:56 | note "no caller" (wrong) | DEAD | one caller AAS_ModelFromIndex (:107), dead; note needs dead-by-chain text |
| AAS_IndexFromString | be_aas_main.cpp:84 | note "no caller" (wrong) | DEAD | one caller AAS_IndexFromModel (:117), dead |
| AAS_ModelFromIndex | be_aas_main.cpp:105 | no caller | DEAD | only the definition |
| AAS_IndexFromModel | be_aas_main.cpp:115 | no caller | DEAD | be_ai_goal.cpp:548 is a comment |
| AAS_UpdateStringIndexes | be_aas_main.cpp:125 | no caller | DEAD | only the definition |
| AAS_EntityOrigin | be_aas_entity.cpp:178 | no caller | DEAD | only the definition |
| AAS_EntitySize | be_aas_entity.cpp:269 | no caller | DEAD | same |
| AAS_EntityBSPData | be_aas_entity.cpp:291 | no caller | DEAD | same |
| AAS_NearestEntity | be_aas_entity.cpp:362 | no caller | DEAD | same |
| AAS_BestReachableEntityArea | be_aas_entity.cpp:397 | no caller | DEAD | same |
| AAS_BoxOriginDistanceFromPlane | be_aas_sample.cpp:349 | no caller | DEAD | same |
| AAS_AreaGroundFace | be_aas_sample.cpp:1001 | no caller | DEAD | be_interface.cpp:480 is in a `/*` block |
| AAS_FacePlane | be_aas_sample.cpp:1035 | no caller | DEAD | only the definition |
| AAS_TraceEndFace | be_aas_sample.cpp:1050 | DEBUG only | DEAD | be_interface.cpp:597 under `#ifdef DEBUG` and `#if 0` |
| AAS_CreateAllRoutingCache | be_aas_route.cpp:870 | no caller | DEAD | be_aas_main.cpp:172 is a comment |
| AAS_BridgeWalkable | be_aas_route.cpp:1892 | no caller | DEAD | only the definition |
| DistancePointToLine | be_aas_route.cpp:2049 | no caller | DEAD | same |
| AAS_NearestHideArea | be_aas_route.cpp:2063 | no caller | DEAD | same |
| AAS_ClearCluster | be_aas_cluster.cpp:61 | no caller | DEAD | same |
| AAS_RemovePortalsClusterReference | be_aas_cluster.cpp:79 | no caller | DEAD | same |
| AAS_NumberClusterPortals | be_aas_cluster.cpp:271 | no caller | DEAD | :409 is a comment |
| AAS_RemoveAllPortals | be_aas_cluster.cpp:920 | no caller | DEAD | only the definition |
| AAS_inPVS | be_aas_bspq3.cpp:174 | no caller | DEAD | no export table stores it |
| AAS_inPHS | be_aas_bspq3.cpp:185 | no caller | DEAD | only the definition |
| AAS_BoxEntities | be_aas_bspq3.cpp:225 | no caller | DEAD | same |
| AAS_BSPTraceLight | be_aas_bspq3.cpp:433 | no caller | DEAD | same |
| AAS_AreaLiquid | be_aas_reach.cpp:664 | no caller | DEAD | same |
| AAS_BarrierJumpTravelTime | be_aas_reach.cpp:758 | no caller | DEAD | :1471 is a comment |
| AAS_NearbySolidOrGap | be_aas_reach.cpp:787 | note "no caller" (imprecise) | DEAD | calls at :1022, :1366 in `/* */`, :978 a comment; note should say "only from comments" |
| AAS_SetMovedir | be_aas_move.cpp:218 | no caller | DEAD | be_aas_reach.cpp:3516 is a comment |
| AAS_AirControl | be_aas_move.cpp:373 | no caller | DEAD | only the definition |
| AAS_TestMovementPrediction | be_aas_move.cpp:1016 | comment caller | DEAD | be_interface.cpp:555 is a comment |

(The table holds 37 rows: be_ea 5, be_aas_main 5, be_aas_entity 5, be_aas_sample 4, be_aas_route 4, be_aas_cluster 4, be_aas_bspq3 4, be_aas_reach 3, be_aas_move 3.)

## Engine files (16)

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| BotReplaceSynonyms thunk (be_interface.swift:827) | botlib/be_ai_chat.cpp:744, arm sv_game.cpp:1175 | row X2: in-place `char *` with no size | ROW-NEW | BotReplaceSynonyms-bound. Only a mod reaches the thunk; be_ai_chat.cpp:2293 calls the Swift function directly |
| BotFindEntityForLevelItem (be_ai_goal) | be_ai_goal.cpp:949 | dead under rule 20 | DEAD | one call in `/* */` at :1151-1158 |
| BotDrawDebugPolygons (sv_bot) | server/sv_bot.cpp:227 | dedicated never draws | DEAD | `rulings.py:1529` |
| SV_GameSystemCalls arm G_G2_LISTBONES | server/sv_game.cpp:1316 | row Z6: CGhoul2Info_v word cast to `CGhoul2Info *` (undefined) | ROW-NEW | Z6-LIST. trap has no game caller (g_syscalls.c:1185). Callees exist (`G2_API.swift:1280`) |
| SV_GameSystemCalls arm G_G2_LISTSURFACES | sv_game.cpp:1320 | same | ROW-NEW | Z6-LIST. g_syscalls.c:1190, no game caller. Callee `G2_API.swift:1273` |
| VM_VM2C | qcommon/vm.cpp:37 | no RETURNS row for `void *` | DEAD | no caller. Do not add a RETURNS row; needs a dead note |
| VM_SymbolToValue | vm.cpp:148 | no caller | DEAD | only the definition |
| VM_SymbolForCompiledPointer | vm.cpp:165 | no caller | DEAD | same |
| VM_LogSyscalls | vm.cpp:934 | comment callers | DEAD | vm_interpreted.cpp:521, vm_x86.cpp:134, :163 are comments |
| Cvar_FreeString | qcommon/cvar.cpp:26 | the string pool drops the free | ROW-PATTERN | NOT_PORTED-replaced. Raven callers are live, the ruling dropped each free; no Swift caller remains |
| Cvar_Realloc | cvar.cpp:965 | no row for `int &memPoolUsed` | DEAD | caller Cvar_Defrag, whose caller is client/cl_main.cpp:715. Needs a dead note, no PARAMS row |
| Sys_GetCPUSpeedOld | win32/win_shared.cpp:338 | rdtsc | DEAD | one caller Sys_GetCPUSpeed, dead. Note lacks "dead" |
| Sys_GetCPUSpeed | win_shared.cpp:399 | rdtsc | DEAD | one caller win32/win_main.cpp:1469; WinDed links null/win_main.cpp |
| Sys_FunctionCmp | null/win_main.cpp:59 | no caller | DEAD | no tree calls any copy |
| Sys_FunctionCheckSum | null/win_main.cpp:128 | no caller | DEAD | same |
| Sys_GetFileTime (files_pc) | qcommon/files_pc.cpp:568 | no row for `FILETIME &ft` | ROW-PATTERN | NOT_PORTED-replaced. Swift Sys_FileOutOfDate (`files_pc.swift:632`, `:648`) calls `SysBackend.GetFileTime` (`Sources/JKAMP_Ded/SysBackend.swift:547`) under an AI line |

## Renderer, Ghoul2, ICARUS, cm (63): 62 DEAD, 1 ROW-NEW

| function | Raven | reason | class | detail |
|---|---|---|---|---|
| G2_Find_Bone_ByNum | renderer/tr_ghoul2.cpp:112 | call at :285 | DEAD | in `#if 0` :274-312 |
| G2_GetBoneNameFromSkel | tr_ghoul2.cpp:678 | no caller | DEAD | only a decl G2_bones.cpp:2607 |
| G2_GetParentBoneMatrixLow | tr_ghoul2.cpp:780 | comment caller | DEAD | G2_bones.cpp:1339 commented out |
| AllocRS | tr_ghoul2.cpp:869 | RenderSurfaces only | DEAD | call :2660 in `#ifndef DEDICATED` :2520-2736 |
| R_GCullModel | tr_ghoul2.cpp:896 | R_AddGhoulSurfaces | DEAD | `#ifndef DEDICATED` :3384-3537 |
| R_GComputeFogNum | tr_ghoul2.cpp:939 | same | DEAD | same |
| G2_ComputeLOD | tr_ghoul2.cpp:967 | same | DEAD | same |
| G2_CreateQuaterion | tr_ghoul2.cpp:1048 | no caller | DEAD | only the definition |
| G2_CreateMatrixFromQuaterion | tr_ghoul2.cpp:1097 | no caller | DEAD | same |
| G2_SetUpBolts | tr_ghoul2.cpp:2053 | no caller | DEAD | same |
| G2_ProcessSurfaceBolt | tr_ghoul2.cpp:2246 | callers dead | DEAD | :2511, :2773 in dead functions; live path is G2_ProcessSurfaceBolt2 |
| G2_ProcessGeneratedSurfaceBolts | tr_ghoul2.cpp:2495 | no caller | DEAD | only timer names |
| ProcessModelBoltSurfaces | tr_ghoul2.cpp:2739 | self only | DEAD | :2786 |
| bInShadowRange | tr_ghoul2.cpp:3369 | R_AddGhoulSurfaces | DEAD | `rulings.py:1516` |
| SaveSequenceIDTable | icarus/Instance.cpp:312 | via Save | DEAD | Save has no caller |
| SaveSequencers | Instance.cpp:367 | via Save | DEAD | same |
| SaveSignals | Instance.cpp:389 | via Save | DEAD | same |
| Save | Instance.cpp:422 | no caller | DEAD | no file calls it |
| LoadSignals | Instance.cpp:451 | via Load | DEAD | Load has no caller |
| LoadSequences | Instance.cpp:503 | via Load | DEAD | same |
| LoadSequencers | Instance.cpp:547 | via Load | DEAD | same |
| Load | Instance.cpp:575 | no caller | DEAD | no file calls it |
| ParseTexMod | renderer/tr_shader.cpp:572 | ParseStage only | DEAD | ParseStage dead |
| ParseSurfaceSprites | tr_shader.cpp:808 | ParseStage only | DEAD | same |
| ParseSurfaceSpritesOptional | tr_shader.cpp:970 | ParseStage only | DEAD | same |
| ParseStage | tr_shader.cpp:1279 | ParseShader only | DEAD | ParseShader dead |
| ParseDeform | tr_shader.cpp:1936 | ParseShader only (:2408) | DEAD | same |
| ParseShader | tr_shader.cpp:2300 | call never runs | DEAD | dedicated-null form: FindShaderInShaderText reads an empty table, ScanAndLoadShaderFiles (:4278) is in `#ifndef DEDICATED` :4273-4282 |
| RE_RegisterShaderFromImage | tr_shader.cpp:3598 | no caller | DEAD | only a decl tr_local.h:1775 |
| G2_GetGoreRecord | ghoul2/G2_misc.cpp:113 | no caller | DEAD | only the definition |
| G2_GorePolys | G2_misc.cpp:804 | gore only | DEAD | only G2API_AddSkinGore starts it, callers client only; ledger-10:149 |
| G2_SaveGhoul2Models | G2_misc.cpp:1719 | no MP caller | DEAD | `rulings.py:1524` |
| G2_LoadGhoul2Model | G2_misc.cpp:1841 | no MP caller | DEAD | `rulings.py:1525` |
| G2_LerpAngles | G2_misc.cpp:1912 | no caller | DEAD | only the definition |
| GetUnsignedInteger | icarus/BlockStream.cpp:420 | no caller | DEAD | same |
| GetLong | BlockStream.cpp:452 | no caller | DEAD | same |
| Create(filename) | BlockStream.cpp:525 | note cites Interpreter.cpp (wrong) | DEAD | nothing calls CBlockStream::Create; fix note at CBlockStream.swift:173 |
| WriteBlock | BlockStream.cpp:577 | Interpreter.cpp only | DEAD | WinDed does not link Interpreter.cpp |
| G2_Animate_Bone_List (3 args) | ghoul2/G2_bones.cpp:1065 | other overload used | DEAD | G2_API.cpp:1450 calls the 4-arg one |
| G2_SetRagDollBullet | G2_bones.cpp:2040 | no caller | DEAD | only the definition |
| G2_Get_Bone_Name | G2_bones.cpp:2580 | debug and client arms | DEAD | :2625, :3851 under `_DEBUG_BONE_NAMES`; :3964 in the `#else` of `#ifdef DEDICATED` |
| ApplyROFF client arm | qcommon/RoffSystem.cpp:820 | `mIsClient` arm | DEAD | only cl_cgame.cpp:1276, :1279 set it true; WinDed does not link it |
| ProcessNote game arm | RoffSystem.cpp:927 (call :957) | `VM_Call(gvm, GAME_ROFF_NOTETRACK_CALLBACK, mEntID, temp)` needs a text address as a word | ROW-NEW | VMCALL-TEXT-WORD. Live: a server ROFF with notes reaches it |
| ClearLerp client arm | RoffSystem.cpp:973 | `mIsClient` arm | DEAD | same as ApplyROFF |
| MC_Compress | renderer/matcomp.c:50 | no caller | DEAD | only matcomp.h:22. Stub has no dead note (matcomp.swift:122) |
| MC_UnCompress | matcomp.c:163 | comment callers | DEAD | tr_ghoul2.cpp:1705-1746 commented out. No dead note (:128) |
| CRenderableSurface operator= | renderer/tr_local.h:2067 | one use | DEAD | tr_ghoul2.cpp:2661 in `#ifndef DEDICATED` |
| CRenderableSurface.Init | tr_local.h:2092 | AllocRS only | DEAD | AllocRS dead |
| CBoneCache.SetRenderMatrix | tr_ghoul2.cpp:208 | Xbox only | DEAD | :261, :339 under `#ifdef _XBOX` |
| CBoneCache.SmoothLow | tr_ghoul2.cpp:267 | EvalRender only | DEAD | EvalRender callers under G2EVALRENDER, `_XBOX`, and RB_SurfaceGhoul (`#ifndef DEDICATED` :3626-4452); note misses the last |
| CM_StoreBrushes (hole) | qcommon/cm_test.cpp:80 | `cbrush_t **` store | DEAD | only CM_BoxBrushes stores it; `rulings.py:1519` |
| CM_BoxBrushes | cm_test.cpp:194 | no caller | DEAD | `rulings.py:1518` |
| R_LerpTag | renderer/tr_model.cpp:1768 | GetRefAPI only | DEAD | `rulings.py:1521` |
| GetRefAPI | tr_init.cpp:1459 | client only | DEAD | `rulings.py:1514` |
| LoadTGA | tr_image.cpp:1421 | `#ifndef DEDICATED` callers | DEAD | `rulings.py:1513` |
| CTaskManager.SaveCommand | icarus/TaskManager.cpp:1620 | one call | DEAD | :1696 in `#if 0` :1665 |
| CSequence.SaveCommand | icarus/Sequence.cpp:320 | one call | DEAD | :400 in `#if 0` :365-404 |
| CBlockMember.WriteMember | icarus/BlockStream.cpp:133 | WriteBlock only | DEAD | WriteBlock dead |
| CNavigator.GetNodeLeadDistance | server/NPCNav/navigator.h:182 | decl, no body | DEAD | no caller |
| CM_TerrainPatchIterate | qcommon/cm_terrain.cpp:1628 | renderer and client | DEAD | `rulings.py:1537` |
| pw | qcommon/cm_polylib.cpp:17 | no caller | DEAD | only a decl cm_polylib.h:47 |
| CM_DrawDebugSurface | qcommon/cm_patch.cpp:1651 | R_DebugGraphics only | DEAD | `rulings.py:1511` |
| CM_Checksum | qcommon/cm_load.cpp:544 | no caller | DEAD | `rulings.py:1527` |

---

## Distinct ROW-PATTERN rows

| row | table and form | precedent | unblocks |
|---|---|---|---|
| FN-consolehandle | FIELD_NAMES `("bot_consolemessage_t", "handle")` to a name such as `messageHandle` | `rulings.py:847-851` (cvarHandle, packHandle, modelHandle); ledger 9 row TR12 | BotRemoveConsoleMessage, BotQueueConsoleMessage, BotNextConsoleMessage |
| FN-chathandle | FIELD_NAMES `("bot_chatstate_t", "handle")` to a name such as `chatHandle` | same | BotQueueConsoleMessage (needs both rows) |
| NOT_PORTED-replaced | NOT_PORTED row with the replacing reason, plus a hand deletion in the adopted file | memmove `rulings.py:1542`, VM_DllSyscall `rulings.py:1555`; form `skeleton.py:1440-1443` | Cvar_FreeString, Sys_GetFileTime |

Alternative for Sys_GetFileTime: keep Raven's function as a body that forwards to `SysBackend.GetFileTime`, like Sys_LowPhysicalMemory (`win_main.swift:108-110`). That needs a parse prelude typedef for FILETIME, which has no precedent (the one HEADER_PRELUDES entry is `rulings.py:1852-1853`).

Secondary rows only for a client or fork port of CRMMission: out_scalar `inout Int32` for ParseOrigin (`rulings.py:1498`), hand `let MAX_RANDOM_CHOICES` for ParseRandom (`CRMManager.swift:7`).

## Distinct ROW-NEW rows

| row | stubs | candidates |
|---|---|---|
| BotReplaceSynonyms-bound (X2) | 1: BotReplaceSynonyms thunk (be_interface.swift:827) | A: copy back with capacity `MAX_MESSAGE_SIZE` (256, the botlib chat bound at be_ai_chat.cpp:328, :1422) and an AI line; cost: a bound Raven does not write. B: write back `strlen + 1` bytes; cost: faithful, but a longer result writes past the module's text |
| Z6-LIST | 2: G_G2_LISTBONES and G_G2_LISTSURFACES arms (sv_game.swift:1640, :1646) | A: rule 19, use the first model, `G2API_ListBones(ghoul2Instances.instance(word: args.VMA(1))![0], args[2])` with a Port-note; cost: a chosen behavior, an empty instance traps. B: a new "dead arm" form (arm twin of rule 20); cost: a new convention, and a fork's mod that calls the trap stops |
| VMCALL-TEXT-WORD | 1: CROFFSystem ProcessNote game arm (RoffSystem.cpp:957) | A: a `withTextWord(_ text: CharBuf, body: (Int) -> R) -> R` view helper beside `withVectorWords` (`Sources/JKAMP_Ded/VmEntry.swift:78`), over `CharBuf.withUnsafeRawPointer` (`JKAShared/CharBuf.swift:85`); cost: one hand helper with no Raven counterpart, same standing as withVectorWords. B: a mixed text-and-vector helper; cost: larger than the need. Both are right for the dll arm only, as withVectorWords is |
| DEAD-BY-DEDICATED-NULL (proof form) | 0 stubs change class; it names the proof for 13 CRMMission and 4 CRandomTerrain stubs, and ParseShader | A: accept "linked caller, no path reaches it, because a DEDICATED arm stores 0" as a rule 20 proof, one note line at each stub. B: treat the stubs as live and port them, which needs CRMInstance-virtuals |
| Rule-20-drop (rule ruling) | 209 DEAD stubs, if the goal is zero stubs | A: keep rule 20, 209 stubs stay. B: a dead function becomes one marker line, NOT_PORTED style; cost: a rule change and hand deletions in each adopted file |
| CRMInstance-virtuals (known, client or fork only) | 0 in the dedicated server; 9 CRMMission stubs secondary (deinit, Load, Spawn, PlaceBridges, ParseInstance, ParseInstancesOnPath, Preview, PlaceWallInstance, ParseWallRect) | enum with a switch (rule 17), protocol with one class per Raven class, class inheritance with `override` |

The four ROW-NEW stubs in the count are BotReplaceSynonyms (1), Z6-LIST (2), and VMCALL-TEXT-WORD (1).

## Note fixes (no class change)

- AAS_StringFromIndex, AAS_IndexFromString: dead by chain.
- AAS_NearbySolidOrGap: callers only in comments.
- VM_VM2C, Cvar_Realloc, Sys_GetCPUSpeed, Sys_GetCPUSpeedOld, MC_Compress, MC_UnCompress, the 20 CRMMission stubs: add a rule 20 dead line.
- Log_WriteTimeStamped: the "no `0` flag" note is stale.
- CBlockStream.Create (CBlockStream.swift:173): the note cites a caller that does not exist.
- CBoneCache.SmoothLow: the note misses the RB_SurfaceGhoul callers.
- WriteIndent, WriteFloat DEAD row text (`rulings.py:1532-1533`): also name the `#if 0` callers in be_ai_weight.cpp.
- PC_FindDefine, PC_DefineFromString, PC_CopyDefine: no DEAD row; only hand notes.
- Generated views BotConsolemessage.swift:64 and BotChatstate.swift:100 say no body reads `handle`; this is false.

## BODY sets for parallel body agents

All 16 BODY stubs are in one file, `be_ai_char.swift`, and they share one form (the X22 Cvalue union with interned strings). One file takes one agent:

| agent | file | stubs |
|---|---|---|
| 1 | be_ai_char.swift | 16 (BotDumpCharacter, BotFreeCharacterStrings, BotDefaultCharacteristics x3, BotLoadCharacterFromFile x3, BotInterpolateCharacters x3, Characteristic_Float x2, Characteristic_Integer x2, Characteristic_String) |

After FN-consolehandle and FN-chathandle land, the 3 be_ai_chat stubs become BODY for a second agent (be_ai_chat.swift).
