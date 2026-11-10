# Dedicated body round: bot-chat

Branch `ded-bodies-bot-chat`, off master at `7961ee4`, in the worktree `/tmp/jka-bot-chat`. The stems are be_ai_chat, be_aas_main, be_aas_entity, be_aas_file, be_aas_optimize, be_aas_routealt, and be_aas_debug of `oracle/codemp/botlib/`. The round ran no generator, no draftcheck, and no snapshot tool.

## Result

The survey found every stem blocked: in each stem, more than half of the stubs carry a `TODO: Port signature` marker or read a global or record that has no view. So the round wrote no body, removed no skeleton header, and ran no build and no test. This record is the only commit.

A stub counts as blocked when its signature carries the marker, or when Raven's body reads one of these names: `aasworld`, `botimport`, `saveroutingcache`, a chat list global of `be_ai_chat.cpp:181` to `:194`, `midrangeareas`, `clusterareas`, a `source_t` or `token_t` of the precompiler, a record pointer with no view, or one of GetMemory, GetClearedMemory, and GetClearedHunkMemory, which have no signature.

| Stem | `portMissing` before | Signature markers | Blocked | Free | `portMissing` after |
|---|---|---|---|---|---|
| be_ai_chat | 60 | 31 | 54 | 6 | 60 |
| be_aas_main | 17 | 0 | 16 | 1 | 17 |
| be_aas_entity | 15 | 3 | 15 | 0 | 15 |
| be_aas_file | 7 | 1 | 6 | 1 | 7 |
| be_aas_optimize | 8 | 7 | 8 | 0 | 8 |
| be_aas_routealt | 4 | 1 | 4 | 0 | 4 |
| be_aas_debug | 19 | 1 | 17 | 2 | 19 |

The free stubs read no blocked name. A later round can fill them in Raven's form when the rows below land:

- be_ai_chat: IsWhiteSpace, BotRemoveTildes, UnifyWhiteSpaces, StringContains, StringContainsWord, and StringReplaceWords.
- be_aas_main: AAS_ProjectPointOntoVector.
- be_aas_file: AAS_DData.
- be_aas_debug: AAS_DrawCross and AAS_DrawArrow. They call AAS_DebugLine, which stays a stub.

## Rows

### BC1, `aasworld`

Raven defines `aas_t aasworld` at `oracle/codemp/botlib/be_aas_main.cpp:30`, and the record `aas_s` at `be_aas_def.h:183` to `:276`. The Swift tree has the marker "No view for `aas_s` of `be_aas_def.h`" at `Sources/JKAMP_DedLogic/be_aas_main.swift:9`, and no Swift file reads the global. The global blocks 15 stubs of be_aas_main, all 15 of be_aas_entity, 4 of be_aas_file, all 8 of be_aas_optimize, all 4 of be_aas_routealt, and 7 of be_aas_debug. The record also holds `aas_entity_t *entities` of `be_aas_def.h:78`, which AAS_Setup allocates. Pattern: row W1 of the seventh ledger, a copy of the record in `ded_types.h` under HOST_ROOTS, and the global as a record on EngineStorage, the form of `sv_siegePersData` of row G7.

### BC2, `botimport`

Raven defines `botlib_import_t botimport` at `oracle/codemp/botlib/be_interface.cpp:42`. The Swift marker is at `Sources/JKAMP_DedLogic/be_interface.swift:19`, "No view for `botlib_import_s` of `botlib.h`". Every `botimport.Print` and every debug line or polygon call reads it, for example AAS_Error at `be_aas_main.cpp:40` and AAS_DebugLine at `be_aas_debug.cpp:116` and `:122`. This row is row B1 of the seventh ledger, which stays open with no precedent in the host. The bodies follow the B1 ruling.

### BC3, `saveroutingcache`

Raven defines `libvar_t *saveroutingcache` at `be_aas_main.cpp:32` and sets it from LibVar in AAS_Setup. The Swift marker "No table row for `libvar_t *`" is at `be_aas_main.swift:14`, and LibVar has no signature at `Sources/JKAMP_DedLogic/l_libvar.swift:116`. The record `libvar_s` is at `oracle/codemp/botlib/l_libvar.h:16`. Pattern: the `cvar_t *` globals of the host, for example `cl_shownet` that CL_Init sets from Cvar_Get, with `libvar_t` as a record view under HOST_ROOTS.

### BC4, the chat list globals

Raven defines eight list globals at `be_ai_chat.cpp:181` to `:194`: `ichatdata`, `botchatstates`, `consolemessageheap`, `freeconsolemessages`, `matchtemplates`, `synonyms`, `randomstrings`, and `replychats`. The Swift markers are at `be_ai_chat.swift:48` to `:83`, each "No table row" for a record pointer or a record pointer array. The records are at `be_ai_chat.cpp:84` to `:176`, and `bot_consolemessage_s` and `bot_match_s` at `oracle/codemp/game/be_ai_chat.h:29` and `:45`. Pattern: the records join `ded_types.h` under HOST_ROOTS by row W1, the arrays `botchatstates` and `ichatdata` take a `Slots<Record?>` on EngineStorage by row G11 (`gWPArray`), and the linked lists take the form that row W1 gave `worldSector`.

### BC5, the chat signatures

be_ai_chat has 31 `TODO: Port signature` markers, at `be_ai_chat.swift:94` to `:765`. Each names a record pointer parameter or return: `bot_chatstate_t`, `bot_consolemessage_t`, `bot_synonymlist_t`, `bot_randomlist_t`, `bot_matchtemplate_t`, `bot_matchpiece_t`, `bot_match_t`, `bot_stringlist_t`, `bot_chat_t`, `bot_replychat_t`, and `source_t`. BotChatStateFromHandle at `be_ai_chat.swift:94` is one of them, and 13 unmarked stubs call it, for example BotNumConsoleMessages and BotChatLength. Pattern: the record views of BC4, then the PARAMS kind `pointer_table` of row G11 for a record pointer parameter.

### BC6, `source_t` and `token_t`

The chat loaders BotLoadSynonyms, BotLoadRandomStrings, BotLoadMatchPieces, BotLoadMatchTemplates, BotLoadReplyChat, BotLoadInitialChat, BotLoadChatMessage, and BotCheckValidReplyChatKeySet read a `source_t` of `oracle/codemp/botlib/l_precomp.h:80`. The precompiler has the marker "No table row for `source_t *[64]`" at `Sources/JKAMP_DedLogic/l_precomp.swift:58`. Pattern: the row of the precompiler stem, which owns the record. The chat loaders wait for it.

### BC7, the botlib allocators

GetMemory, GetClearedMemory, and GetClearedHunkMemory return `Never` with no signature at `Sources/JKAMP_DedLogic/l_memory.swift:30`, `:39`, and `:57`. FreeMemory takes an `OpaquePointer?` at `:69`. AAS_UpdateStringIndexes, AAS_Setup, InitConsoleMessageHeap, BotAllocChatState, AAS_InitAlternativeRouting, and the chat loaders allocate through them. Pattern: row B5 of the seventh ledger gives a `void *` return the RETURNS kind `raw`. A body with no `Unsafe` cannot use a raw pointer, so each site allocates the Swift record or table of BC1, BC4, or BC9 in place of the call. A site that differs from Raven that way takes one `// AI:` line by rule 24.

### BC8, the entity records

be_aas_entity has three signature markers: `bot_entitystate_t *state` of AAS_UpdateEntity at `be_aas_entity.cpp:46` and `be_aas_entity.swift:18`, `aas_entityinfo_t *info` of AAS_EntityInfo at `be_aas_entity.cpp:154` and `be_aas_entity.swift:33`, and `bsp_entdata_t *entdata` of AAS_EntityBSPData at `be_aas_entity.cpp:291` and `be_aas_entity.swift:120`. Pattern: `bot_entitystate_t` and `aas_entityinfo_t` are records of the game headers, so they follow row B1 and row W1, a copy under HOST_ROOTS. The PARAMS kind for a record pointer parameter then applies.

### BC9, `optimized_t` and the AAS record parameters

be_aas_optimize has seven signature markers at `be_aas_optimize.swift:15` to `:105`: `aas_edge_t *` of AAS_KeepEdge, `aas_face_t *` of AAS_KeepFace, and `optimized_t *` of the five others. The record `optimized_s` is at `be_aas_optimize.cpp:29`. The other AAS record parameters have the same form: `aas_header_t *h` of AAS_WriteAASLump at `be_aas_file.cpp:481` and `be_aas_file.swift:78`, `aas_altroutegoal_t *altroutegoals` of AAS_AlternativeRouteGoals at `be_aas_routealt.cpp:82` and `be_aas_routealt.swift:43`, and `aas_reachability_t *reach` of AAS_ShowReachability at `be_aas_debug.cpp:588` and `be_aas_debug.swift:225`. Pattern: the AAS records join HOST_ROOTS with `aas_s` of BC1, the row W1 form, and `optimized_t` as a local record of the stem, the form of `moveclip_t` of row W1.

### BC10, the alternative routing lists

Raven defines `midrangearea_t *midrangeareas` and `int *clusterareas` at `be_aas_routealt.cpp:39` and `:40`. The Swift markers are at `be_aas_routealt.swift:9` and `:14`. The record `midrangearea_s` is at `be_aas_routealt.cpp:32`. Pattern: `clusterareas` takes `Slots<Int32>` by rows G6, W2, and T4 of the seventh ledger, and `midrangeareas` takes a table of the record on EngineStorage, the form of `debugpolygons` of row B3.

### BC11, AAS_ShowPolygon and `debugpolygons`

Raven declares `void AAS_ShowPolygon(int color, int numpoints, vec3_t *points)` at `be_aas_debug.cpp:67`, and the Swift signature at `be_aas_debug.swift:57` takes `_ points: inout JKAShared.vec3_t`, one vector and not a list. The static `int debugpolygons[MAX_DEBUGPOLYGONS]` at `be_aas_debug.cpp:35` has no Swift global and no marker in be_aas_debug.swift. Pattern: rows G8 and B4 of the seventh ledger give a `vec3_t *points` beside `numPoints` the form `Slots<vec3_t>`, and the static array takes the form of `debuglines`, which be_aas_debug.swift already has at `:15`.

## Bodies not read line by line

The round wrote no body, so no body was read line by line against Raven. The survey read every Raven body of the seven stems for the blocked names only. The free list above comes from that scan, not from a line-by-line read.

## Gate

- `swift build -j 2`: not run, because every stem is blocked and the round changed no Swift file.
- `swift test --no-parallel -j 2`: not run, for the same reason.
