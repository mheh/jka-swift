# The botlib docket of the ninth generator batch

This docket merges the rows of five survey records of the botlib stems of `Sources/JKAMP_DedLogic`: `bot-precomp` (P1 to P7), `bot-chat` (BC1 to BC11), `bot-aas` (A1 to A7), `bot-move` (BM1 to BM5), and `bot-util` (BU1 to BU9). Each row below gives the question, the proof at Raven's line and at the port's line, the pattern with its own line, the full list of names, and the survey citations that are wrong. Swift paths are relative to the repo root on master `7961ee4`. A line of the batch-8 worktree `/tmp/jka-batch-8` is marked "batch-8", because that tree changes and is not master.

The docket has 20 merged rows, D1 to D20. Appendix A lists every marker of the 28 botlib stems by function, so the batch agent does not search for them again.

## D1, the entry list or a copy in `ded_types.h`

Merges: P1 (the form part), A1 (the last sentence), A4, BM3, BC8, BU6, BU9 (the header part).

Question: to give views to the botlib records, must the host header parse reach `be_aas_def.h`, `aasfile.h`, `l_script.h`, `l_precomp.h`, and `l_libvar.h`, or does a copy in `ded_types.h` fit?

Proof:
- The host entry list reads no botlib header, by ruling T2. `tools/oracle-closure/project.toml:354` says so, and `notes/2026-11-03/dedicated-stage-1-tools.md:192` records why: a trial that derived the list from the glob stopped in `extract.py` with `source_t has 2 layouts across the ilp32 triples`. The cause is `token_t`, which `source_t` holds by value at `oracle/codemp/botlib/l_precomp.h:91`. `token_t` declares `unsigned long int intvalue` and `long double floatvalue` at `l_script.h:147` and `:148`, and both change width across the triples.
- Ledger 7 says the host parse of the unit reads the botlib .cpp files itself (`notes/2026-11-09/dedicated-open-rows-ledger-7.md:249`). The srcglob gives the function definitions. A view needs the record in a C header of `CJKAMP_Ded`, and the entry list gives none of the botlib records.
- `be_aas_def.h` cannot stand as an entry. It has no include guard. `aas_entity_s` holds `aas_entityinfo_t i` by value at `be_aas_def.h:81`, a record of the game header `be_aas.h:132`. So the header parse must read `game/be_aas.h` and `game/botlib.h` first, the order of `be_aas_main.cpp:15` to `:29`. Ledger 7 row B1 (`:137`) says a host parse of `botlib.h` moves its records out of `CJKAMP_Game`.
- `be_aas_def.h:20` to `:31` redefines `MAX_CLIENTS`, `MAX_MODELS`, `MAX_SOUNDS`, `MAX_RADAR_ENTITIES`, `CS_SCORES`, `CS_MODELS`, and `CS_SOUNDS`. `CS_MODELS` and `CS_SOUNDS` have other values in `Sources/CJKAMP/include/codemp/game/bg_public/constants.h:139` and `:145`, see D10.
- A record of a hand header has no layout assert: `Sources/CJKAMP_Ded/layout_asserts.h` names no `cmd_t`, `MD4_CTX`, `worldSector_t`, or `bot_debugpoly_t`. So a copy does not meet the T2 stop.
- Ledger 7 row S4 (`:225`) says a new header in the host entry list moves the merge placement of its names and needs its own gate.
- No record name of the botlib collides with a record of `CJKAMP`, `CJKAShared`, or `CJKAMP_Ded` (a word search over the three include folders found none of the 32 .cpp and botlib-header names).

Verdict of the proof: the copy fits, and the entry list does not.

Pattern: the copy of a record of a .cpp file, `cmd_t` at `Sources/CJKAMP_Ded/include/ded_types.h:5` with `HOST_ROOTS` at `tools/oracle-closure/rulings.py:221` to `:225`, and row W1 at `rulings.py:277` to `:281`. For a record of a game header, the form is row B1 as batch-8 lands it: `ded_types.h` copies `botlib.h:18` to `:422` with its `BSPTRACE` guard (batch-8 `ded_types.h:227` and later), and `HOST_ROOTS` names `botlib_export_t`, `botlib_import_t`, `bot_input_t`, `bsp_trace_t`, and `bot_entitystate_t` with the target `CJKAMP_Ded` (batch-8 `rulings.py`, the lines after the `vidmode_t` row). A record that two C modules hold under one name, where no target imports both, has the precedent of `CollisionRecord_t` at `rulings.py:179` and `:180`. The shape is the same: a C typedef record that a botlib body reads through a pointer or holds by value.

Where each record lives:

- Game headers, which `CJKAMP_Game` owns (`Sources/CJKAMP_Game/include/CJKAMP_Game.h:53` to `:93`):
  - `game/botlib.h`: `bot_input_t`, `bsp_surface_t`, `bsp_trace_t`, `bot_entitystate_t`, `botlib_import_t`, `aas_export_t`, `ea_export_t`, `ai_export_t`, `botlib_export_t`. Batch-8 row B1 copies these.
  - `game/be_aas.h`: `aas_trace_t` (:68), `aas_entityinfo_t` (:107), `aas_areainfo_t` (:135), `aas_clientmove_t` (:162), `aas_altroutegoal_t` (:180), `aas_predictroute_t` (:196), and the enum `solid_t` (:65). `bsp_surface_t` and `bsp_trace_t` of `be_aas.h:78` to `:106` are inside a comment, "Defined in botlib.h".
  - `game/be_ai_goal.h`: `bot_goal_t` (:25).
  - `game/be_ai_move.h`: `bot_initmove_t` (:60), `bot_moveresult_t` (:74), `bot_avoidspot_t` (:89).
  - `game/be_ai_chat.h`: `bot_consolemessage_t` (:29), `bot_matchvariable_t` (:43), `bot_match_t` (:45).
  - `game/be_ai_weap.h`: `projectileinfo_t` (:27), `weaponinfo_t` (:45).
  - `game/be_ai_char.h`, `be_ai_gen.h`, and `be_ea.h` declare no record.
- Botlib headers, which no target holds:
  - `aasfile.h`: `aas_bbox_t` (:97), `aas_reachability_t` (:107), `aas_areasettings_t` (:119), `aas_portal_t` (:132), `aas_portalindex_t` (:141, `int`), `aas_cluster_t` (:144), `aas_vertex_t` (:154, `vec3_t`), `aas_plane_t` (:157), `aas_edge_t` (:165), `aas_edgeindex_t` (:171, `int`), `aas_face_t` (:174), `aas_faceindex_t` (:185, `int`), `aas_area_t` (:188), `aas_node_t` (:200), `aas_lump_t` (:210), `aas_header_t` (:217).
  - `be_aas_def.h`: `aas_stringindex_t` (:43, no .cpp reads it), `aas_link_t` (:50), `bsp_link_t` (:59), `bsp_entdata_t` (:67), `aas_entity_t` (:78), `aas_settings_t` (:88), `aas_routingcache_t` (:133), `aas_routingupdate_t` (:150), `aas_reversedlink_t` (:163), `aas_reversedreachability_t` (:171), `aas_reachabilityareas_t` (:178), `aas_t` (:183).
  - `l_script.h`: `punctuation_t` (:133), `token_t` (:141), `script_t` (:158).
  - `l_precomp.h`: `define_t` (:55), `indent_t` (:71), `source_t` (:80).
  - `l_libvar.h`: `libvar_t` (:16).
  - `l_struct.h`: `fielddef_t` (:31), `structdef_t` (:43).
  - `be_ai_weight.h`: `fuzzyseperator_t` (:19), `weight_t` (:32), `weightconfig_t` (:39).
  - `be_interface.h`: `botlib_globals_t` (:19).
- Botlib .cpp files: see D4.

Change: `ded_types.h` takes the records of the game headers above (the rows that batch-8 B1 does not carry) and the records of the botlib headers, each with a `// Source:` line, and `HOST_ROOTS` names each root with the target `CJKAMP_Ded`. The forward tags of batch-8 B1 (`struct aas_entityinfo_s;` and the ten others) become full records. `token_t` keeps the width of WinDed, D5.

Wrong citations: A4 says "`bsp_trace_t` has no header in `Sources/`". It has one at `Sources/CJKAMP_Game/include/codemp/game/botlib/bsp_trace_t.h`, from `botlib.h:117`. A4 cites `be_aas.h:90` for `bsp_trace_t`, and that line is inside the comment block of `be_aas.h:78` to `:106`. A4 says "the game parse places five of them in `be_aas/`": of the five it names, four are in `be_aas/`, and `bsp_trace_t` is in `botlib/`. BU9 cites `be_ai_weap.h:27` and `:45` without the folder: the file is `oracle/codemp/game/be_ai_weap.h`, a game header, not a botlib header. BU6 asks for `bot_input_t` in `HOST_ROOTS`, which batch-8 B1 already gives.

## D2, `aasworld`, `aassettings`, and the AAS records

Merges: A1, A2, BC1, BC9 (the AAS records), BM2 (`aas_reachability_t`).

Question: `aas_t aasworld` and `aas_settings_t aassettings` have no storage, and 39 signatures name an AAS record.

Proof: `aasworld` at `be_aas_main.cpp:30`, marker at `Sources/JKAMP_DedLogic/be_aas_main.swift:9`. `aassettings` at `be_aas_move.cpp:29`, marker at `be_aas_move.swift:9`. `struct aas_s` at `be_aas_def.h:183`, `aas_settings_s` at `:88`. The record lines of A1 at `aasfile.h:97` to `:200` and `be_aas_def.h:50` to `:178` are correct. BC9's sites are correct: `be_aas_file.cpp:481` and `be_aas_file.swift:78`, `be_aas_routealt.cpp:82` and `be_aas_routealt.swift:43`, `be_aas_debug.cpp:588` and `be_aas_debug.swift:225`.

Pattern: the clip map. `"clipMap_t": ("ClipMap", "CJKAMP_Ded")` and its records at `rulings.py:254` to `:276`, and the storage record `cmg` at `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift:9` to `:11`. The shape is the same: one file-scope record by value whose fields point at arrays of disk records the loaders fill. The records come from the copy of D1, not from the entry list as A1 says.

Names: the globals `aasworld` and `aassettings`. The records are the `aasfile.h` and `be_aas_def.h` lists of D1. The roots are `aas_t`, `aas_settings_t`, `aas_header_t`, `aas_lump_t`, `bsp_entdata_t`, and `aas_reachability_t`. The field walk reaches the rest. The functions whose signatures change are every entry of Appendix A that names an `aasfile.h` or `be_aas_def.h` record.

The fields of `aas_t` need kinds, D15.

## D3, the records of the game headers in the botlib signatures

Merges: A4 (the `be_aas.h` part), BC8, BM3, BC4 (`bot_consolemessage_t`, `bot_match_t`), BU9 (`weaponinfo_t`, `projectileinfo_t`).

Question: the signatures name records that only `CJKAMP_Game` holds.

Proof: `AAS_UpdateEntity(int entnum, bot_entitystate_t *state)` at `be_aas_entity.cpp:46`, marker at `be_aas_entity.swift:18`. `AAS_EntityInfo` at `be_aas_entity.cpp:154`, marker at `be_aas_entity.swift:33`. `AAS_Trace` marker at `be_aas_bspq3.swift:29`. `AAS_ClientMovementPrediction` marker at `be_aas_move.swift:230`. `bot_goal_t` at `game/be_ai_goal.h:25`, the move records at `game/be_ai_move.h:60`, `:74`, and `:89`, and `CJKAMP_Game.h:76` and `:79` include `bot_goal_t.h` and `bot_initmove_t.h`. `CJKAMP_forward.h:38` to `:42` holds only forward tags.

Pattern: D1, the batch-8 B1 copy.

Names: `aas_trace_t`, `aas_entityinfo_t`, `aas_areainfo_t`, `aas_clientmove_t`, `aas_altroutegoal_t`, `aas_predictroute_t`, `solid_t`, `bot_goal_t`, `bot_initmove_t`, `bot_moveresult_t`, `bot_avoidspot_t`, `bot_consolemessage_t`, `bot_matchvariable_t`, `bot_match_t`, `projectileinfo_t`, and `weaponinfo_t`. `bot_entitystate_t` and `bsp_trace_t` close with batch-8 B1. The functions are the Appendix A entries that name these records, among them 15 of be_ai_goal, 3 of be_ai_move (`bot_initmove_t`, `bot_moveresult_t`, `bot_goal_t`), 4 of be_ai_chat, 5 of be_aas_move and be_aas_sample, `AAS_PredictRoute`, `AAS_AlternativeRouteGoals`, `AAS_AreaInfo`, and `BotGetWeaponInfo`.

## D4, the records of the botlib .cpp files

Merges: A3, A4 (the `aas_lreachability_t` part), A6 (the record), BC4 (the chat records), BC9 (`optimized_t`), BC10 (`midrangearea_t`), BM1, BU4 (`logfile_t`), BU7, BU9 (`weaponconfig_t`, `bot_weaponstate_t`).

Question: Raven defines these records inside a .cpp file, and no view exists.

Proof, each start line confirmed:
- `be_aas_bspq3.cpp`: `rgb_t` :35, `bsp_epair_t` :43, `bsp_entity_t` :51, `bsp_t` :57, `cname_t` :74. `bspworld` at :70, marker at `be_aas_bspq3.swift:15`.
- `be_aas_reach.cpp`: `aas_lreachability_t` :70.
- `be_aas_sample.cpp`: `aas_tracestack_t` :40, `aas_linkstack_t` :1201.
- `be_aas_route.cpp`: `routecacheheader_t` :899.
- `be_aas_optimize.cpp`: `optimized_t` :29.
- `be_aas_routealt.cpp`: `midrangearea_t` :32.
- `be_ai_char.cpp`: `bot_characteristic_t` :46, `bot_character_t` :53.
- `be_ai_chat.cpp`: `bot_chatmessage_t` :57, `bot_chattype_t` :64, `bot_chat_t` :72, `bot_randomstring_t` :78, `bot_randomlist_t` :84, `bot_synonym_t` :93, `bot_synonymlist_t` :100, `bot_matchstring_t` :109, `bot_matchpiece_t` :116, `bot_matchtemplate_t` :124, `bot_replychatkey_t` :134, `bot_replychat_t` :142, `bot_stringlist_t` :152, `bot_chatstate_t` :159, `bot_ichatdata_t` :175.
- `be_ai_goal.cpp`: `maplocation_t` :53, `campspot_t` :62, `levelitem_t` :93, `iteminfo_t` :107, `itemconfig_t` :141, `bot_goalstate_t` :148.
- `be_ai_move.cpp`: `bot_movestate_t` :42.
- `be_ai_weap.cpp`: `weaponconfig_t` :96, `bot_weaponstate_t` :105.
- `l_log.cpp`: `logfile_t` :26, `logfile` :33, marker at `l_log.swift:11` to `:13`.
- `l_precomp.cpp`: `directive_t` :86 is D11, and `operator_t` :1652 and `value_t` :1660 are the stack records of PC_EvaluateTokens.
- `l_memory.cpp`: `memoryblock_t` :32 sits under `MEMORYMANEGER`, which `l_memory.cpp:21` leaves undefined, so it is out.

Pattern: `cmd_t` and row W1 (`rulings.py:221` and `:277` to `:281`), the copy in `ded_types.h` with a `HOST_ROOTS` row. A record that a body declares on its stack, `aas_tracestack_t`, `aas_linkstack_t`, `operator_t`, and `value_t`, has the precedent of `areaParms_t` and `moveclip_t` of `sv_world.cpp:359` and `:440`, the same row W1.

Names: every record above, the global `bspworld` and `logfile` as records on `EngineStorage` (the `cmg` form of D2), and the functions of Appendix A that name them.

Wrong citations: BC4 cites the chat records at `be_ai_chat.cpp:84` to `:176`. They span `:57` to `:179`.

## D5, the script and precompiler records and the width of `token_t`

Merges: P1 (the records), P6, BC6.

Question: the records of `l_script.h` and `l_precomp.h` have no view, and `token_t` holds two fields whose width changes across the triples.

Proof: the records at `l_script.h:133`, `:141`, and `:158`, and `l_precomp.h:55`, `:71`, and `:80`. `NumberValue(char *string, int subtype, unsigned long int *intvalue, long double *floatvalue)` at `l_script.cpp:541` and `:542`, stub at `l_script.swift:172`. `value_t` holds `signed long int intvalue` and `double floatvalue` at `l_precomp.cpp:1662` and `:1663`. PC_EvaluateTokens, PC_Evaluate, and PC_DollarEvaluate take `signed long int *intvalue` (`l_precomp.cpp:1730`, `:2184`, `:2283`). The chat loaders read `source_t` (BC6), and the marker "No table row for `source_t *[64]`" sits at `l_precomp.swift:57` and `:59`.

Pattern: D1 for the six records. For the width, the copy of `UINT4`: `ded_types.h:12` to `:14` declares `unsigned int` under one AI line, and `TYPES` gives `"UINT4": "UInt32"` at `rulings.py:505` to `:507`. The shape is the same: a C integer type whose width differs between WinDed and an lp64 host, in a record that never crosses the engine edge. So the copy declares `token_t.intvalue` as `unsigned int` and `token_t.floatvalue` as `double`, each with an AI line, the MSVC widths. A `long double *` parameter is then `inout Double`, and an `unsigned long int *` or `signed long int *` parameter is `inout UInt32` or `inout Int32`, the `int *` form that row G6 confirms for a scalar out-parameter.

Names: the records `punctuation_t`, `token_t`, `script_t`, `define_t`, `indent_t`, and `source_t`. The width sites: `token_t.intvalue`, `token_t.floatvalue`, `value_t.intvalue`, NumberValue, PC_EvaluateTokens, PC_Evaluate, and PC_DollarEvaluate. The functions: every l_script and l_precomp entry of Appendix A (71 and 36), the nine l_struct entries, BotLoadChatMessage, BotLoadMatchPieces, BotCheckValidReplyChatKeySet, ReadValue, ReadFuzzyWeight, and ReadFuzzySeperators_r.

The `char *` cursor fields of `script_t` and `token_t` are D7.

## D6, the precompiler and script globals and pointer-to-pointer forms

Merges: P3, P4, A6 (the pointer table part).

Question: `globaldefines`, `sourceFiles`, `areareachability`, and the `define_t **definehash` parameters and field have no form.

Proof: `define_t **globaldefines` at `l_precomp.cpp:105`, marker at `l_precomp.swift:27`, allocated at `l_precomp.cpp:3049` as `DEFINEHASHSIZE` pointers. `source_t *sourceFiles[MAX_SOURCEFILES]` at `l_precomp.cpp:3187`, marker at `l_precomp.swift:57`. `aas_lreachability_t **areareachability` at `be_aas_reach.cpp:85`, allocated at `:4521`. PC_PrintDefineHashTable and PC_FindHashedDefine take `define_t **definehash` (stubs at `l_precomp.swift:263` and `:299`). `source_t.definehash` at `l_precomp.h:88`.

Pattern:
- A file-scope array of record pointers needs no table row. `skeleton.py:715` to `:727` gives it `Slots<View?>` with the reason `pointer_table` once the record has a view, the form of `cg_solidEntities` at `Sources/JKAMP_CGameLogic/cg_predict.swift:17`. This fits `sourceFiles` and every handle table of D13. P4's `[Source?]` TYPES row, the `opnames` form, is not needed.
- A `T **` field that holds an allocated table of record pointers takes the FIELDS kind `pointer_table`, the row of `pack_t.hashTable` at `rulings.py:458`. `files_pc.cpp:1474` allocates `hashTable` and `:743` indexes it, the shape of `source_t.definehash`. The same kind fits `script_t.punctuationtable`, `aas_t.arealinkedentities`, and `aas_t.portalcache` of D15.
- A `T **` parameter takes the PARAMS kind `pointer_table`, the row of `trap_Bot_UpdateWaypoints` at `rulings.py:698` and `SV_BotWaypointReception` at `:857`. This fits `definehash` of PC_PrintDefineHashTable and PC_FindHashedDefine.
- A `T **` file-scope pointer that holds an allocated table, `globaldefines` and `areareachability`, has no TYPES row of that shape. The nearest rows are `TYPES` `facets` and `sv_bot:debugpolygons` at `rulings.py:527` and `:530`, `Slots<View>?` over a table of records, not of record pointers. The form `Slots<View?>?` joins the two forms. See the list of rows with no existing pattern.

Names: `globaldefines`, `sourceFiles`, `areareachability`, `source_t.definehash`, PC_PrintDefineHashTable, and PC_FindHashedDefine.

Wrong citations: A6 gives `reachabilityheap` the FIELDS kind `pointer_table`. `reachabilityheap` is `aas_lreachability_t *` with one star (`be_aas_reach.cpp:83`), a heap of records, D14. `pointer_table` fits `areareachability` at `:85`.

## D7, the `char *` cursor fields of `script_t` and `token_t`

Merges: P1 (the cursor part).

Question: `script_t` has six `char *` fields that point into its own text buffer, and `token_t` has two. The bodies compare and subtract them.

Proof: `script_t.buffer`, `script_p`, `end_p`, `lastscript_p`, `whitespace_p`, and `endwhitespace_p` at `l_script.h:161` to `:166`, and `token_t.whitespace_p` and `endwhitespace_p` at `:150` and `:151`. LoadScriptFile sets `script->buffer = (char *) buffer + sizeof(script_t)` at `l_script.cpp:1323`.

Pattern: none. P1 proposes the FIELDS kind `bytes` of `z_stream.next_in` (`rulings.py:454`), but that kind reads a `byte *` or an `int *`, and ledger 7 rows G1 and G2 (`dedicated-open-rows-ledger-7.md:53`) keep `mSharedMemory` a hand accessor because the field is a `char *`. The text cursor kinds exist only for a parameter and a return (`text_cursor` at `rulings.py:542` and `:659`), not for a field.

Names: the eight fields, and the 36 l_script functions of Appendix A that read them.

## D8, `libvar_t` and its globals

Merges: BC3, BM2 (the `libvar_t` part), BU3.

Question: `libvar_t` has no view, and twelve globals hold a `libvar_t *`. BU3 names two patterns: a rule 9 Swift struct, or the `ded_types.h` copy.

Proof: `libvar_t` at `l_libvar.h:16`, `libvarlist` at `l_libvar.cpp:20` with its marker at `l_libvar.swift:9`. The record functions at `l_libvar.cpp:66`, `:85`, `:113`, and `:172`, markers at `l_libvar.swift:32`, `:47`, `:74`, and `:113`. The globals: `saveroutingcache` at `be_aas_main.cpp:32` (marker `be_aas_main.swift:14`), `sv_maxstep`, `sv_maxbarrier`, `sv_gravity`, `weapindex_rocketlauncher`, `weapindex_bfg10k`, `weapindex_grapple`, `entitytypemissile`, `offhandgrapple`, `cmd_grappleoff`, and `cmd_grappleon` at `be_ai_move.cpp:89` to `:98` (markers `be_ai_move.swift:39` to `:86`), and `droppedweight` at `be_ai_goal.cpp:178` (marker `be_ai_goal.swift:95`).

Which pattern fits Raven's use: the `ded_types.h` copy. The twelve globals hold the pointer that LibVar returns (`l_libvar.cpp:172`) and read `->value` and `->string` later, for example `sv_gravity->value` of BotAirControl. LibVarSet finds the same record with LibVarGet at `l_libvar.cpp:225` and writes its fields, so each holder must see the change. A view over C memory has that reference meaning. The rule 9 form, `CmdFunctionRow` of `Sources/JKAMP_DedLogic/cmd_pc.swift:10`, fits a record that no other code holds by pointer: `cmd_functions` is an Array, and no global holds a `cmd_function_t *` (`notes/2026-11-09/dedicated-round-stringed.md:19`). It also fits a record with a function pointer field, which `libvar_t` does not have. So the Swift struct does not fit `libvar_t`.

Pattern: the copy of D1, and each `libvar_t *` global as the optional view, the form of `var sv_fps: JKAMP.Cvar?` at `Sources/JKAMP_DedLogic/sv_main.swift:18`. LibVarAlloc allocates the record with its name after it, `l_libvar.cpp:70` to `:73`, the record-plus-text shape of D12.

Names: `libvar_t`, `libvarlist`, the twelve globals above, LibVarAlloc, LibVarDeAlloc, LibVarGet, and LibVar.

Wrong citations: BM1 and BM2 place the ten `libvar_t *` globals of be_ai_move at `be_ai_move.cpp:60` to `:69`. Those lines are fields of `bot_movestate_t`. The globals are at `:89` to `:98`. BU3 places the markers at `l_libvar.swift:31`, `:46`, and `:73`. Those are the `Source:` lines, and the markers are one line lower.

## D9, `botimport`, `be_botlib_export`, and `botlibglobals`

Merges: BC2, A5, BU1.

Question: every Print, trace, file, and debug call goes through `botimport`, and `botlibglobals` has no view.

Proof: `botlib_import_t botimport` at `be_interface.cpp:42`, marker at `be_interface.swift:19`. `botlib_globals_t botlibglobals` at `be_interface.cpp:39`, marker at `be_interface.swift:9`. `be_botlib_export` marker at `be_interface.swift:14`. `botlib_globals_t` at `be_interface.h:19`, with `debug`, `goalareanum`, `goalorigin`, and `runai` under `#ifdef DEBUG` at `:25` to `:30`. Sample sites: AAS_Error at `be_aas_main.cpp:40`, `be_aas_debug.cpp:116` and `:122`, `l_memory.cpp:331`, `:373`, `:414`, and `:425`.

Pattern: row B1 as batch-8 lands it, the copy of `botlib.h` and the tables on `EngineStorage`. `botlib_globals_t` is a record of a botlib header, the D1 copy, with the arm that WinDed Release takes (no `DEBUG`), the form of "The arm Raven's `#ifndef _XBOX` build takes" at `ded_types.h:26` and `:57`.

Names: `botimport`, `be_botlib_export`, `botlibglobals`, `botlib_globals_t`, Export_BotLibUpdateEntity, Init_AAS_Export, Init_EA_Export, Init_AI_Export, and GetBotLibAPI.

## D10, the macro groups

Merges: P2, and the macro part of D1.

Question: the bodies read macros of the botlib headers and of the game headers, and no host target holds them.

Proof: PC_ConvertPath reads `PATHSEPERATOR_CHAR` (`l_precomp.cpp:940`, `l_precomp.h:28`), and PC_OperatorPriority reads the `P_` operators (`l_precomp.cpp:1668`, `l_script.h:66` to `:127`). The game-header macros (`TFL_`, `PRESENCE_`, `SE_`, `MOVE_`, `MFL_`, `GFL_`, `CHAT_`, `ACTION_`, `BLERR_`, `BOTFILESBASEFOLDER`) are only in `Sources/CJKAMP_Game/include/codemp/game/*/constants.h`. No file of `Sources/JKAMP_Ded`, `JKAMP_DedLogic`, `JKAMP`, or `CJKAMP_Ded` names `TFL_DEFAULT`, `BLERR_NOERROR`, `ACTION_ATTACK`, `MOVE_WALK`, `GFL_ITEM`, or `CHAT_ALL`.

Pattern: the macros that `ded_types.h` copies with their records, `MAX_LOOPBACK`, `MAX_PACKETLEN`, and `MAX_SNAPSHOT_ENTITIES` at `ded_types.h:24`, `:28`, and `:168`, which the reexport gives as Swift constants (`Sources/JKAMP_Ded/Generated/net_chan.swift:8`, `sv_snapshot.swift:8`). Batch-8 B1 copies the `PRT_` group the same way (batch-8 `Sources/JKAMP_Ded/Generated/botlib.swift:8`). A macro that `CJKAMP` already defines with the same value stays out of the copy, the merge rule of rule 20 (`docs/porting-rules.md:45`). For `PATHSEPERATOR_CHAR`, two forms fit: the WinDed arm `'\\'`, the form of the `PATH_SEP='\\\\'` define at `project.toml:411`, or the hand `PATH_SEP` of `NOT_PORTED_MACROS` at `rulings.py:955` and `:956`. The second fits PC_ConvertPath, because the converted path goes to the file system of the platform that builds, as FS_ReplaceSeparators does.

Names:
- `aasfile.h`: all `#define` lines of the file (`TRAVEL_`, `TRAVELTYPE_MASK`, `TRAVELFLAG_`, `FACE_`, `AREA_`, `AREACONTENTS_`, `PRESENCE_` as the file declares them, `MAX_TRAVELTYPES`, `AAS_LUMPS`, `AASID`, `AASVERSION`, and the lump numbers).
- `be_aas_def.h`: `CACHETYPE_PORTAL`, `CACHETYPE_AREA`, `MAX_PATH`, and the `DF_` function macros at `:33` to `:36`, which a body spells as an expression. Leave out `MAX_CLIENTS`, `MAX_MODELS`, `MAX_SOUNDS`, and `MAX_RADAR_ENTITIES` (same values in `CJKAMP`). `CS_SCORES`, `CS_MODELS`, and `CS_SOUNDS` are a row with no pattern, below.
- `l_script.h`: the `SCFL_`, `TT_` subtypes from `TT_DECIMAL` on, and `P_` groups, and `MAX_TOKEN`. Leave out `TT_STRING`, `TT_LITERAL`, `TT_NUMBER`, `TT_NAME`, `TT_PUNCTUATION`, and `QDECL` (same values in `CJKAMP`).
- `l_precomp.h`: `DEFINE_`, `BUILTIN_`, `INDENT_`, and the separator macros by the choice above. `MAX_TOKENLENGTH` and the second `pc_token_t` stand under `#ifdef BSPC` at `:144` and stay out.
- `l_struct.h`, `l_libvar.h`, `be_ai_weight.h`, `be_interface.h`: every `#define` of the four files.
- The game headers: the macro groups of `botlib.h` beyond `PRT_`, `be_aas.h`, `be_ai_goal.h`, `be_ai_move.h`, `be_ai_chat.h`, `be_ai_weap.h`, `be_ai_char.h`, `be_ea.h`, and `be_ai_gen.h`.

Row with no pattern: `be_aas_def.h:29` to `:31` defines `CS_SCORES 32`, `CS_MODELS (CS_SCORES+MAX_CLIENTS)`, and `CS_SOUNDS (CS_MODELS+MAX_MODELS)`. `be_aas_main.cpp:107` and `:117` read `aasworld.configstrings[CS_MODELS]` with that value, 64. `CJKAMP` defines `CS_MODELS` as `(CS_SIEGE_ICONS+1)` and `CS_SOUNDS` as `(CS_SKYBOXORG+1)` (`bg_public/constants.h:139` and `:145`). No table holds a macro whose botlib value differs from the value of a module the host imports.

## D11, the directive tables and `default_punctuations`

Merges: P1 (the `directive_t` and global part).

Question: `directives[20]` and `dollardirectives[20]` are file-scope tables of `{ name, function }` rows, and `default_punctuations` is a file-scope table of `{ text, number, next }` rows that PS_CreatePunctuationTable links.

Proof: `directive_t` at `l_precomp.cpp:86` with `int (*func)(source_t *source)`, the tables at `:2535` and `:2648`, markers at `l_precomp.swift:44` and `:49`. The bodies scan by name and call the function at `l_precomp.cpp:2576` to `:2580`, `:2677` to `:2681`, and `:2731` to `:2733`. `default_punctuations` at `l_script.cpp:69`, marker at `l_script.swift:9`.

Pattern:
- The directive tables take the hand row table of `HAND_VARS`, `commandList` at `rulings.py:338` with `CommandDefRow` at `Sources/JKAMP_CGameLogic/cg_local.swift:974`. `commandDef_t commandList[]` at `ui_shared.c:2196` holds `{ name, handler }` rows, and `ui_shared.c:2337` and `:2340` scan by name and call the handler, the same declaration and the same use. P1's `captureFunc` form of `TYPES` (`rulings.py:519`) is one stored function, not a table of rows, so it does not fit.
- `default_punctuations` takes C storage beside the hand headers, the form of the four netField tables of `ded_tables.c` (`rulings.py:236` and `:237`, `HAND_HEADERS` at `:1073`). A `netField_t` row holds a `char *` name and integers, and `msg.cpp` reads the rows in place, the same shape.

Names: `directives`, `dollardirectives`, `directive_t` (not copied to `ded_types.h`), `default_punctuations`, and `punctuation_t` of D5.

## D12, the botlib allocators

Merges: BC7, BU2.

Question: GetMemory, GetClearedMemory, GetHunkMemory, and GetClearedHunkMemory have no signature, and FreeMemory reads the word before the block. BU2 names two patterns: a `raw` return or a Swift form.

Proof: the four functions at `l_memory.cpp:325`, `:346`, `:367`, and `:388`, stubs at `l_memory.swift:30`, `:39`, `:48`, and `:57`, each "No table row for the return `void *`". FreeMemory at `l_memory.cpp:406`, stub at `l_memory.swift:69` with `OpaquePointer?`. GetMemory and GetHunkMemory write `MEM_ID` or `HUNK_ID` into an `unsigned long` before the block and return the address after it (`l_memory.cpp:331` to `:335` and `:373` to `:377`), and return NULL when the import returns NULL (`:332`, `:374`). FreeMemory frees only a `MEM_ID` block (`:412` to `:415`), so a hunk block is never freed. `MEMORYMANEGER` is undefined (`:21`), so `allocatedmemory`, `totalmemorysize`, and `numblocks` of `:26` to `:28` have no live reader. The size parameter is `unsigned long`, `CUnsignedLong` in the table (`spelling.py:33`).

Which pattern fits Raven's use: both fit, at different sites. The block of the import is a zone block, `BotImport_GetMemory` and `BotImport_HunkAlloc` of `sv_bot.cpp` with the RETURNS kind `raw` (`rulings.py:632` to `:635`). Where the block holds a C record or a table of records, a view must bind over C memory, so `raw` fits, the row of S_Malloc of row Z3 (`rulings.py:600` to `:602`). Where the block holds text that a `char *` field takes, the Swift form fits: the CopyString form of row Z3 (`notes/2026-11-09/dedicated-open-rows-ledger-5.md:29`), where the call stays for the zone count and the field takes the `String`. GetMemory and GetHunkMemory return NULL on one path, the shape of the batch-8 RETURNS kind `optional_raw` (batch-8 `rulings.py:663`, row FC3). GetClearedMemory and GetClearedHunkMemory pass that NULL to Com_Memset, so Raven never returns NULL from them.

FreeMemory reads the word before the block, the shape of `ZoneHeader(block:)` at `Sources/JKAMP_Ded/ZoneBlocks.swift:19`, a hand initializer in the view target with one AI line. BU2's claim holds at that line.

The 95 live call sites, comments and the `MEMORYMANEGER` arm removed, by shape:

1. One record. `be_aas_bspq3.cpp:394` (`bsp_epair_t`), `be_ai_weight.cpp:156`, `:243`, `:363` (`fuzzyseperator_t`), `:311` (`weightconfig_t`), `be_ai_move.cpp:118` (`bot_movestate_t`), `be_ai_goal.cpp:477` (`maplocation_t`), `:488` (`campspot_t`), `:1723` (`bot_goalstate_t`), `be_ai_weap.cpp:453` (`bot_weaponstate_t`), `be_ai_chat.cpp:1154`, `:1165` (`bot_matchpiece_t`), `:1284` (`bot_matchtemplate_t`), `:1841` (`bot_replychat_t`), `:1849` (`bot_replychatkey_t`), `:2227` (`bot_ichatdata_t`), `:2886` (`bot_chatstate_t`), `l_precomp.cpp:169` (`indent_t`), `:256` (`token_t`), `:3058`, `:3091` (`source_t`). Host form: `Searchpath(Z_Malloc(Int32(Searchpath.byteCount), TAG_FILESYS, true))` at `Sources/JKAMP_DedLogic/files_pc.swift:1905`, also `msg.swift:1446` and `unzip.swift:430`.
2. A table of records. `be_aas_main.cpp:374` (`aas_entity_t`), `be_aas_reach.cpp:443` (`aas_lreachability_t`), `:4298` (`aas_reachability_t`), `be_aas_cluster.cpp:1470` (`aas_portal_t`), `:1476` (`aas_cluster_t`), `be_aas_optimize.cpp:205` (`aas_edge_t`), `:209` (`aas_face_t`), `:213` (`aas_area_t`), `be_aas_sample.cpp:94` (`aas_link_t`), `be_aas_route.cpp:856`, `:861` (`aas_routingupdate_t`), `:1139` (`aas_reachabilityareas_t`), `be_aas_routealt.cpp:203` (`midrangearea_t`), `be_ai_goal.cpp:362` (`levelitem_t`), `be_ai_chat.cpp:230` (`bot_consolemessage_t`), `be_ea.cpp:505` (`bot_input_t`). Host form: `svs.clients = Client(Z_Malloc(Int32(Client.byteCount) * sv_maxclients!.integer, TAG_CLIENTS, true))` at `sv_init.swift:268` for a field, and `Slots<Client>(Hunk_AllocateTempMemory(...), count: count)` at `sv_init.swift:324` for a local or a global.
3. A table of `vec3_t`. `be_aas_optimize.cpp:203` (`aas_vertex_t`). No host body allocates a table of vectors, D15.
4. A table of scalars. `be_aas_debug.cpp:756`, `be_aas_cluster.cpp:1473`, `be_aas_optimize.cpp:207`, `:211`, `:216`, `:217`, `:218`, `be_aas_route.cpp:390`, `:589`, `:1141`, `be_aas_routealt.cpp:205`, `be_ai_goal.cpp:337`, `be_ai_weap.cpp:318` (`int` or an `int` typedef), and `be_aas_route.cpp:2077` (`unsigned short`). Host form: `Slots(scalars: buf, count: Int(len) + 1)` over the Z_Malloc block of FS_ReadFile at `files_pc.swift:1280` and `:1288`.
5. A table of record pointers. `be_aas_reach.cpp:4521`, `be_aas_sample.cpp:175`, `be_aas_route.cpp:831`, `l_script.cpp:167`, `l_precomp.cpp:1339`, `:3049`, `:3069`, `:3102`. No master body allocates one. Batch-8 `files_pc.swift:1682` writes `Slots(pointers: packBlock + Pack.byteCount, count:)`, which lands only with batch-8.
6. Text for a `char *` field. `be_aas_bspq3.cpp:405`, `:414`, `be_aas_main.cpp:134`, `be_ai_char.cpp:184`, `:288`, `:539`, `be_ai_weight.cpp:331`, `be_ai_chat.cpp:1895`, `:1908`, `l_libvar.cpp:180`, `:235`. Host form: CopyString, `_ = S_Malloc(strlen(in) + 1)` at `z_memman_pc.swift:404`, and the `String` setter at `cvar.swift:267`.
7. A byte buffer. `be_aas_bspq3.cpp:465` (the entity text), `be_aas_file.cpp:280` and `:295` (AAS_LoadAASLump, whose callers cast the bytes to a table of disk records), `be_aas_route.cpp:1020` (a routing cache read whole from the file). Host form: `files_pc.swift:1280`. A buffer that a caller then reads as records has the form of `cmod_base` (`rulings.py:524` and `:525`, ledger 7 `:239`).
8. A record with its text after it, which a `char *` field points at. `l_libvar.cpp:70`, `l_precomp.cpp:684`, `:1223`, `:1484`, `be_ai_chat.cpp:1189`, `:1538`, `:1942`. Host form: the size of Raven's block with the name through the setter, `VmSymbol(VM_Alloc(Int32(VmSymbol.byteCount) + chars))` at `vm.swift:331` and `sym.symName = token` at `:343`. Batch-8 `files_pc.swift:1664` and `:1665` give the same form one AI line for the unused bytes.
9. A record with a variable-sized array field after it. `be_ai_char.cpp:211`, `:515` (`bot_characteristic_t c[1]` of `be_ai_char.cpp:57`, bound `MAX_CHARACTERISTICS`), and `be_aas_route.cpp:729` (`unsigned short traveltimes[1]` of `be_aas_def.h:146`). Host form: `SLOT_BOUNDS` of `winding_t.p` and `vmSymbol_t.symName` at `rulings.py:315` to `:318`, and `Winding(Z_Malloc(s, TAG_BSP, true))` at `cm_polylib.swift:77` and `:78`. `traveltimes` has no Raven macro for its bound.
10. A record with a table of another record after it, which a pointer field of the record points at. `be_ai_goal.cpp:276` to `:278` (`itemconfig_t` and `iteminfo_t`), `be_ai_weap.cpp:214` to `:219` (`weaponconfig_t`, `weaponinfo_t`, `projectileinfo_t`), `be_aas_route.cpp:729` and `:730` (`reachabilities` after `traveltimes`), and `l_script.cpp:1319` and `:1367` (`script_t` and its text, D7). No master body has this form. Batch-8 `files_pc.swift:1679` to `:1682` steps a raw pointer in a logic body, which lands only with batch-8.
11. One block cut into many records and texts. `be_aas_route.cpp:417` (`aas_reversedreachability_t` and `aas_reversedlink_t`), `:510` (`unsigned short ***areatraveltimes`), `:785` (`aas_routingcache_t ***clusterareacache`), `be_ai_chat.cpp:596` (synonym lists), `:949` (random lists), `:2018` (initial chats). No pattern.

The 112 FreeMemory sites fall into two groups. A free of a block of shapes 1 to 5 and 7 to 11 is `Z_Free` on the view handle, the form of `unzip.swift:745` and `files_common.swift:410` to `:416`, through FreeMemory. A free of a text of shape 6 (`be_aas_bspq3.cpp:349`, `:350`, `be_ai_char.cpp:120`, `be_ai_weight.cpp:115`, `be_ai_chat.cpp:1687`, `l_libvar.cpp:87`, `:228`) drops under an AI line, the CopyString free of ledger 7 row CM5 (`dedicated-open-rows-ledger-7.md:35`).

Names: GetMemory, GetClearedMemory, GetHunkMemory, GetClearedHunkMemory (RETURNS `raw`, or `optional_raw` for the first and third if batch-8 lands it), FreeMemory, and the hand initializer for the word before the block.

## D13, the handle tables and the tables of record pointers

Merges: BC4 (the arrays), BC5, BM5, BU7, BU8, BU9 (`botweaponstates`).

Question: the handle tables hold record pointers, and the `FromHandle` functions return one.

Proof: `botmovestates` at `be_ai_move.cpp:102` (marker `be_ai_move.swift:95`), `botgoalstates` at `be_ai_goal.cpp:163` (marker `be_ai_goal.swift:46`), `botchatstates` and `ichatdata` at `be_ai_chat.cpp:181` and `:183` (markers from `be_ai_chat.swift:48`), `botcharacters` at `be_ai_char.cpp:60` (marker `be_ai_char.swift:23` to `:26`), `botweaponstates` at `be_ai_weap.cpp:111` (marker `be_ai_weap.swift:30`), `weightFileList` at `be_ai_weight.cpp:34` (marker `be_ai_weight.swift:15`). BotChatStateFromHandle marker at `be_ai_chat.swift:94`, BotMoveStateFromHandle at `be_ai_move.swift:133`, BotGoalStateFromHandle at `be_ai_goal.swift:110`.

Pattern: `skeleton.py:715` to `:727` gives a file-scope array of record pointers `Slots<View?>` once the record has a view, the form of `cg_solidEntities` at `Sources/JKAMP_CGameLogic/cg_predict.swift:17` and of `gWPArray` of row G11. No table row is needed beyond the views of D3 and D4. A record pointer parameter takes the optional view, the NULL sweep, and a `FromHandle` function returns the optional view.

Names: `botmovestates`, `botgoalstates`, `botchatstates`, `ichatdata`, `botcharacters`, `botweaponstates`, `weightFileList`, `sourceFiles` (D6), BotMoveStateFromHandle, BotGoalStateFromHandle, BotChatStateFromHandle, BotCharacterFromHandle, and BotWeaponStateFromHandle.

## D14, the file-scope record pointers that hold a heap or a list

Merges: A6 (the heap), BC4 (the list heads), BC10, BU6 (`botinputs`), BU9 (`weaponconfig`).

Question: file-scope `T *` globals hold either one record or a table of records that a body indexes.

Proof: `reachabilityheap` and `nextreachability` at `be_aas_reach.cpp:83` and `:84` (marker `be_aas_reach.swift:142`), freed at `:461` by AAS_ShutDownReachabilityHeap of `:459`. `midrangeareas` and `clusterareas` at `be_aas_routealt.cpp:39` and `:40` (markers `be_aas_routealt.swift:9` and `:14`). `botinputs` at `be_ea.cpp:27` (marker `be_ea.swift:17` to `:20`). The chat heads at `be_ai_chat.cpp:185` to `:194`. The goal heads at `be_ai_goal.cpp:165` to `:178`. `weaponconfig` at `be_ai_weap.cpp:112`.

Pattern: two forms, by use.
- A global that a body indexes takes `TYPES` `Slots<View>?`, the rows `facets` and `sv_bot:debugpolygons` at `rulings.py:526` to `:530`. This fits `reachabilityheap` (`reachabilityheap[i].next` at `be_aas_reach.cpp:447`), `consolemessageheap` (`be_ai_chat.cpp:232` to `:236`), `levelitemheap`, `midrangeareas`, and `botinputs`. An `int *` global that a body indexes takes `TYPES` `Slots<Int32>?`, the row `cmod_base` at `rulings.py:525`, which fits `clusterareas`. BC10 cites rows G6, W2, and T4 for it, which are parameter and field rows.
- A global that holds one record or a list head takes the optional view the generator gives a `T *` global, the `sv_fps` form of D8. This fits `nextreachability`, `freeconsolemessages`, `matchtemplates`, `synonyms`, `randomstrings`, `replychats`, `itemconfig`, `freelevelitems`, `levelitems`, `maplocations`, `campspots`, `weaponconfig`, and `libvarlist`. BC4 cites the `worldSector` form of W1 for the lists, which is a table on `EngineStorage`, not a list head.

Names: every global named above.

## D15, the field kinds of `aas_t` and the other AAS records

Merges: A1 (the fields), BC1 (`entities`), BC9 (`optimized_t` fields).

Question: the generated view of `aas_t` needs a kind for each pointer field that the C type alone does not decide.

Proof: the fields at `be_aas_def.h:185` to `:275`, `optimized_t` at `be_aas_optimize.cpp:29` to `:53`, and `aas_routingcache_t` and `aas_routingupdate_t` at `be_aas_def.h:133` to `:160`.

Pattern, by field:
- A record pointer field that a body indexes gets `<field>Slots` from the subscript sweep (`table.py:1708` to `:1741`), the form of `clientsSlots` at `Sources/JKAMP_Ded/Generated/Views/ServerStatic.swift:90`. No row is needed: `bboxes`, `planes`, `edges`, `faces`, `areas`, `areasettings`, `reachability`, `nodes`, `portals`, `clusters`, `linkheap`, `entities`, `areaupdate`, `portalupdate`, `reversedreachability`, `reachabilityareas`, and the `optimized_t` fields `edges`, `faces`, `areas`.
- An `int *` field takes the FIELDS kind `bytes`, the row `("clipMap_t", "leafbrushes")` at `rulings.py:430`: `aas_t.edgeindex`, `faceindex`, `portalindex`, `areacontentstravelflags`, `portalmaxtraveltimes`, `reachabilityareaindex`, and `optimized_t.edgeindex`, `faceindex`, `vertexoptimizeindex`, `edgeoptimizeindex`, `faceoptimizeindex`. An `unsigned char *` field takes the same kind: `aas_routingcache_t.reachabilities`.
- A `T **` field takes the FIELDS kind `pointer_table`, D6: `aas_t.arealinkedentities`, `aas_t.portalcache`, `script_t.punctuationtable`, `source_t.definehash`.
- `char *configstrings[MAX_CONFIGSTRINGS]` gets `Slots<String?>`, the form of `server_t.configstrings` at `Sources/JKAMP_Ded/Generated/Views/Server.swift:116`.
- No pattern: `aas_vertex_t *vertexes` of `aas_t` and `optimized_t` (a `vec3_t *` field. FIELDS `bytes` reads a `byte *` or an `int *`, and `Slots(vectors:)` exists only for an array field, `BotDebugpoly.swift:83`). `unsigned short *areatraveltimes` of `aas_routingupdate_t` at `be_aas_def.h:156` (`unsigned short` is outside the `bytes` comment at `rulings.py:410`). `unsigned short ***areatraveltimes` and `aas_routingcache_t ***clusterareacache` of `aas_t` at `be_aas_def.h:264` and `:266` (three stars). `aas_routingcache_t.traveltimes[1]` at `:146` (variable sized, and no Raven macro bounds it, D12 shape 9).

Names: every field above.

## D16, the array parameters that became one `inout` value

Merges: A7, BM4, BC11.

Question: a C array parameter became one `inout` scalar or vector. Which botlib functions have this defect?

Proof of the cause: the subscript sweep gives a host `int *` or `float *` parameter a `Slots` only when its own body indexes it (`table.py:1727` to `:1731`). The hand-off sweep follows only record pointers (`table.py:1786`). A `vec3_t *` parameter is neither a scalar pointer nor a record pointer (`table.py:1700` to `:1706`), so it is `inout vec3_t` unless a PARAMS row names it. The rows G8 and B4 extended the PARAMS kind `table` to a `vec3_t *` (`rulings.py:853` to `:855`).

The complete list, from a scan of every botlib definition with a scalar or `vec3_t *` parameter (comments removed) against its Swift stub:
- `AAS_ConnectedAreas(int *areanums, int numareas)`, `be_aas_cluster.cpp:706`, Swift `inout Int32` at `be_aas_cluster.swift:386`. The body hands `areanums` to AAS_ConnectedAreas_r at `:713`, whose parameter is `Slots<Int32>` (`be_aas_cluster.swift:374`). Callers hand the locals `frontareanums` and `backareanums` of AAS_CheckAreaForPossiblePortals (`be_aas_cluster.cpp:783`, `:861`, `:863`).
- `AAS_TraceAreas(..., int *areas, vec3_t *points, int maxareas)`, `be_aas_sample.cpp:709`, Swift `inout JKAShared.vec3_t` at `be_aas_sample.swift:236`. The body writes `points[numareas]` at `:757`. Nine callers pass NULL (`be_interface.cpp:413`, `be_aas_reach.cpp:1542`, `:2297`, `:3884`, `:4244`, `be_aas_route.cpp:1154`, `:1159`, `:1162`, `be_ai_move.cpp:3391`). Five pass a local array: `points[10]` of AAS_Reachability_FuncBobbing (`be_aas_reach.cpp:3276`, call `:3433`), `points[20]` of AAS_ClientMovementPrediction (`be_aas_move.cpp:506`, call `:648`), and `points[10]` of BotFuzzyPointReachabilityArea (`be_ai_move.cpp:229`, calls `:240`, `:257`) and of BotReachabilityArea (call `be_ai_move.cpp:394`).
- `AAS_ShowPolygon(int color, int numpoints, vec3_t *points)`, `be_aas_debug.cpp:67`, Swift `inout JKAShared.vec3_t` at `be_aas_debug.swift:57`. The body hands `points` to `botimport.DebugPolygonCreate` at `:75`, whose host function takes `Slots<JKAShared.vec3_t>` (`sv_bot.swift:454`). The caller is AAS_ShowFacePolygon with the local `points[128]` (`be_aas_debug.cpp:335`, call `:369`).
- `BotChooseLTGItem(int goalstate, vec3_t origin, int *inventory, int travelflags)`, `be_ai_goal.cpp:1268`, Swift `inout Int32` at `be_ai_goal.swift:532`. The body hands `inventory` to FuzzyWeight and FuzzyWeightUndecided at `:1334` and `:1336`, which index it at `be_ai_weight.cpp:638` and `:669`. The game reaches it through `ai->BotChooseLTGItem` (`be_interface.cpp:780`) with the module's inventory array.
- `BotChooseBestFightWeapon(int weaponstate, int *inventory)`, `be_ai_weap.cpp:387`, Swift `inout Int32` at `be_ai_weap.swift:141`. Same hand-off at `:409`, export at `be_interface.cpp:816`.
- `AAS_BoxEntities(vec3_t absmins, vec3_t absmaxs, int *list, int maxcount)`, `be_aas_bspq3.cpp:225`, Swift `inout Int32` at `be_aas_bspq3.swift:139`. The body returns 0 and reads nothing, and no .cpp calls it. The C shape is a list.
- These carry a signature marker now and get the same defect when the marker clears: `BotChooseNBGItem(..., int *inventory, ...)` at `be_ai_goal.cpp:1435` (hand-off at `:1505`, `:1507`), and `AAS_FindFaceReachabilities(vec3_t *facepoints, ...)` at `be_aas_reach.cpp:3145` (indexes `facepoints[l]` at `:3188`, callers pass `start_edgeverts[4]` and `end_edgeverts[4]` of `:3275` at `:3395` to `:3401`).

The other scalar pointer parameters are out-parameters of one value and keep `inout`: AAS_FloatForBSPEpairKey, AAS_IntForBSPEpairKey, AAS_BSPTraceLight, AAS_LoadAASLump, AAS_HorizontalVelocityForJump, AAS_AreaRouteToGoalArea, AAS_RandomGoalArea, AAS_FacePlane, GeneticParentsAndChildSelection, BotAddToTarget, BotAirControl, CRC_Init, CRC_ProcessByte, CRC_ContinueProcessString, PC_SourceFileAndLine, PC_PopIndent, and the D5 width sites. The list parameters that a body indexes already have `Slots`: AAS_ConnectedAreas_r, AAS_GetAdjacentAreasWithLessPresenceTypes_r, AAS_BBoxAreas, AAS_FloodAreas_r, GeneticSelection, AAS_DData, CRC_ProcessString, and the `areas` of AAS_TraceAreas.

Pattern:
- An `int *` list: the PARAMS kind `bytes`, the rows `SV_AreaEntities` and `CM_BoxLeafnums` at `rulings.py:849` to `:852`. Fits AAS_ConnectedAreas, BotChooseLTGItem, BotChooseNBGItem, BotChooseBestFightWeapon, and AAS_BoxEntities.
- A `vec3_t *` list: the PARAMS kind `table`, the rows `BotImport_DebugPolygonCreate` and `BotImport_DebugPolygonShow` at `rulings.py:853` to `:855`. Fits AAS_ShowPolygon, AAS_TraceAreas, and AAS_FindFaceReachabilities. AAS_TraceAreas also needs `NULLABLE` (`rulings.py:992`). An optional Slots parameter exists, `modelList: Slots<qhandle_t>?` (`rulings.py:668`) and `animset: Slots<JKAMP.Animation>?` at `Sources/JKAMP_BG/bg_panimate.swift:1942`.
- A local array that a caller hands on joins `BYTE_STORAGE_LOCALS`, the rows `touch` and `leafs` at `rulings.py:395` to `:398` for `int`, and `p`, `hullPoints`, and `newHullPoints` at `:360`, `:361`, `:375` to `:377` for `vec3_t`. The locals: `points` of AAS_Reachability_FuncBobbing, AAS_ClientMovementPrediction, BotFuzzyPointReachabilityArea, BotReachabilityArea, and AAS_ShowFacePolygon, `start_edgeverts` and `end_edgeverts` of AAS_Reachability_FuncBobbing, `frontareanums` and `backareanums` of AAS_CheckAreaForPossiblePortals, `connectedareas` of AAS_ConnectedAreas, `areanums` of `be_aas_cluster.cpp:779`, and the `areas` locals of the eleven AAS_TraceAreas callers (`be_aas_reach.cpp:1044`, `:2095`, `:3271`, `:3778`, `:4111`, `be_aas_route.cpp:1128`, `be_aas_move.cpp:505`, `be_ai_move.cpp:227`, `:3385`, and BotReachabilityArea and BotExportTest), which `Slots<Int32>` already needs on master.

Wrong citations: BC11 says the static `int debugpolygons[MAX_DEBUGPOLYGONS]` "has no Swift global and no marker in be_aas_debug.swift". The forward is at `be_aas_debug.swift:32` to `:36`, over `be_aas_debug_debugpolygons` at `Sources/JKAMP_Ded/Generated/Storage/EngineVariables.swift:133`, by the `stem:name` fix of ledger 7 (`:295`).

## D17, `pc_token_t` in the host

Merges: P5.

Proof: PC_ReadTokenHandle at `l_precomp.cpp:3253`, marker at `l_precomp.swift:1145`. `pc_token_t` of `q_shared.h:1661` has the view `Sources/JKAMP/Generated/Views/PcToken.swift`, and `GAME_ROOTS` and `CGAME_ROOTS` name it at `rulings.py:47` and `:116`. `HOST_ROOTS` does not, on master and on batch-8.

Pattern: the shared view row of the host, `qtime_t` at `rulings.py:239` and `vmCvar_t` at `:205`, the same record of `q_shared.h` that the game views. Names: `pc_token_t`, PC_ReadTokenHandle.

## D18, the varargs error functions

Merges: P7.

Proof: SourceError and SourceWarning at `l_precomp.cpp:117` and `:141`, ScriptError and ScriptWarning at `l_script.cpp:216` and `:242`, each `char *str, ...`. AAS_Error at `be_aas_main.cpp:40` has the same form, `char *fmt, ...`, and so does Log_Write and Log_WriteTimeStamped of `l_log.cpp`.

Pattern: `func Com_Printf(_ text: String, _ args: any JKAShared.FormatArg...)` at `Sources/JKAMP_BG/bg_local.swift:368`. Names: SourceError, SourceWarning, ScriptError, ScriptWarning, AAS_Error, and the varargs functions of `l_log.cpp`. The print calls wait for D9.

## D19, l_struct and the field tables

Merges: BU5, BU9 (the field tables).

Question: the nine l_struct functions take `fielddef_t *`, `structdef_t *`, `source_t *`, `FILE *`, and a record as `void *p` or `char *structure`.

Proof: the records at `l_struct.h:31` and `:43`, the functions at `l_struct.cpp:43` to `:441`, markers at `l_struct.swift:15` to `:137`. The tables `weaponinfo_fields`, `projectileinfo_fields`, `weaponinfo_struct`, and `projectileinfo_struct` at `be_ai_weap.cpp:38`, `:66`, `:86`, and `:90`, and `iteminfo_fields` and `iteminfo_struct` of be_ai_goal (markers in Appendix A). The rows of the field tables take `offsetof` of `weaponinfo_t`, `projectileinfo_t`, and `iteminfo_t`, so the C storage needs those records in `CJKAMP_Ded`, D3 and D4.

Pattern:
- The record as `void *p` or `char *structure`: the PARAMS kind `raw`, `("BG_ParseField", "ent")` at `rulings.py:699`, with the typed subscripts of `Sources/JKAShared/Views/RawField.swift:6` to `:85`. BG_ParseField writes a record at a field offset, the same use.
- `FILE *fp`: the PARAMS kind `opaque`, the rows of `unzlocal_getShort` at `rulings.py:859` to `:861`.
- The field tables: C storage beside the hand headers, the netField form of D11.

Names: FindField, ReadNumber, ReadChar, ReadString, ReadStructure, WriteIndent, WriteFloat, WriteStructWithIndent, WriteStructure, `fielddef_t`, `structdef_t`, and the six tables.

Wrong citations: BU5 ends the marker range at `l_struct.swift:141`, a closing brace. The last marker is at `:136`.

## D20, `logfile` and the `FILE *` of l_log

Merges: BU4.

Proof: `logfile_t` at `l_log.cpp:26`, `static logfile_t logfile` at `:33` (marker `l_log.swift:11` to `:13`), `FILE *Log_FilePointer(void)` at `:138` (marker `l_log.swift:84` and `:85`). `logfile_t` holds a `FILE *fp`.

Pattern: the record by D4 and the storage record by D2. The field `fp` takes the FIELDS kind `opaque`, `("qfile_gut", "o")` at `rulings.py:444`. The return of Log_FilePointer takes the RETURNS kind `opaque`, `FS_FileForHandle` at `rulings.py:612`. The same `FILE *` and the same use. Ledger 7 (`:296`) already names the storage `common_logfile` for the `logfile` of `common.cpp`.

Names: `logfile_t`, `logfile`, `logfile_t.fp`, Log_FilePointer.

## The rows with no existing pattern

- D7: the `char *` cursor fields of `script_t` (`l_script.h:161` to `:166`) and `token_t` (`:150`, `:151`). FIELDS `bytes` reads only `byte *` and `int *`, ledger 7 `:53`.
- D10: `CS_SCORES`, `CS_MODELS`, and `CS_SOUNDS` of `be_aas_def.h:29` to `:31`, read at `be_aas_main.cpp:107` and `:117`, collide with other values in `Sources/CJKAMP/include/codemp/game/bg_public/constants.h:139` and `:145`.
- D6: a file-scope `T **` table of record pointers, `globaldefines` (`l_precomp.cpp:105`) and `areareachability` (`be_aas_reach.cpp:85`). `TYPES` has `Slots<View>?` (`rulings.py:527`, `:530`) and no `Slots<View?>?`.
- D15: a `vec3_t *` field, `aas_t.vertexes` and `optimized_t.vertexes` (`be_aas_def.h:200`, `be_aas_optimize.cpp:33`). An `unsigned short *` field, `aas_routingupdate_t.areatraveltimes` (`be_aas_def.h:156`). The three-star fields `aas_t.areatraveltimes` and `aas_t.clusterareacache` (`be_aas_def.h:264` and `:266`). The variable-sized `aas_routingcache_t.traveltimes[1]` with no Raven bound (`be_aas_def.h:146`).
- D12 shape 10: a record with another table after it in one block, which a pointer field points at (`be_ai_goal.cpp:276` to `:278`, `be_ai_weap.cpp:214` to `:219`, `be_aas_route.cpp:729` and `:730`, `l_script.cpp:1319` and `:1367`). Batch-8 `files_pc.swift:1679` to `:1682` is a form only after batch-8 lands.
- D12 shape 11: one block cut into many records and texts (`be_aas_route.cpp:417`, `:510`, `:785`, `be_ai_chat.cpp:596`, `:949`, `:2018`).
- D12 shape 5 on master: an allocated table of record pointers (`be_aas_reach.cpp:4521`, `be_aas_sample.cpp:175`, `be_aas_route.cpp:831`, `l_script.cpp:167`, `l_precomp.cpp:1339`, `:3049`, `:3069`, `:3102`). Batch-8 `files_pc.swift:1682` is a form only after batch-8 lands.

## Appendix A, the markers of the botlib stems by function

Each entry gives the function, or `global` and the variable, and the first C type that the marker names. The count follows the stem. be_aas_cluster, be_ai_gen, and l_crc have none.

- be_aas_bspq3 (5): global bspworld [`bsp_s`, a struct of a .c file], AAS_Trace [bsp_trace_t], AAS_EntityCollision [bsp_trace_t * trace], AAS_UnlinkFromBSPLeaves [bsp_link_t * leaves], AAS_BSPLinkEntity [bsp_link_t *]
- be_aas_debug (1): AAS_ShowReachability [aas_reachability_t * reach]
- be_aas_entity (3): AAS_UpdateEntity [bot_entitystate_t * state], AAS_EntityInfo [aas_entityinfo_t * info], AAS_EntityBSPData [bsp_entdata_t * entdata]
- be_aas_file (1): AAS_WriteAASLump [aas_header_t * h]
- be_aas_main (2): global aasworld [`aas_s`], global saveroutingcache [libvar_t *]
- be_aas_move (6): global aassettings [`aas_settings_s`], AAS_JumpReachRunStart [aas_reachability_t * reach], AAS_ClipToBBox [aas_trace_t * trace], AAS_ClientMovementPrediction [struct aas_clientmove_s * move], AAS_PredictClientMovement [struct aas_clientmove_s * move], AAS_ClientMovementHitBBox [struct aas_clientmove_s * move]
- be_aas_optimize (7): AAS_KeepEdge [aas_edge_t * edge], AAS_OptimizeEdge [optimized_t * optimized], AAS_KeepFace [aas_face_t * face], AAS_OptimizeFace [optimized_t * optimized], AAS_OptimizeArea [optimized_t * optimized], AAS_OptimizeAlloc [optimized_t * optimized], AAS_OptimizeStore [optimized_t * optimized]
- be_aas_reach (9): global reachabilityheap [aas_lreachability_t *], global nextreachability [aas_lreachability_t *], global areareachability [aas_lreachability_t **], AAS_FaceArea [aas_face_t * face], AAS_BestReachableLinkArea [aas_link_t * areas], AAS_AllocReachability [aas_lreachability_t *], AAS_FreeReachability [aas_lreachability_t * lreach], AAS_ClosestEdgePoints [aas_plane_t * plane1], AAS_FindFaceReachabilities [aas_plane_t * plane]
- be_aas_route (11): AAS_UnlinkCache [aas_routingcache_t * cache], AAS_LinkCache [aas_routingcache_t * cache], AAS_FreeRoutingCache [aas_routingcache_t * cache], AAS_AllocRoutingCache [aas_routingcache_t *], AAS_ReadCache [aas_routingcache_t *], AAS_UpdateAreaRoutingCache [aas_routingcache_t * areacache], AAS_GetAreaRoutingCache [aas_routingcache_t *], AAS_UpdatePortalRoutingCache [aas_routingcache_t * portalcache], AAS_GetPortalRoutingCache [aas_routingcache_t *], AAS_PredictRoute [struct aas_predictroute_s * route], AAS_ReachabilityFromNum [struct aas_reachability_s * reach]
- be_aas_routealt (3): global midrangeareas [midrangearea_t *], global clusterareas [int *], AAS_AlternativeRouteGoals [aas_altroutegoal_t * altroutegoals]
- be_aas_sample (13): AAS_AllocAASLink [aas_link_t *], AAS_DeAllocAASLink [aas_link_t * link], AAS_AreaEntityCollision [aas_trace_t * trace], AAS_TraceClientBBox [aas_trace_t], AAS_InsideFace [aas_face_t * face], AAS_AreaGroundFace [aas_face_t *], AAS_TraceEndFace [aas_trace_t * trace], AAS_BoxOnPlaneSide2 [aas_plane_t * p], AAS_UnlinkFromAreas [aas_link_t * areas], AAS_AASLinkEntity [aas_link_t *], AAS_LinkEntityClientBBox [aas_link_t *], AAS_AreaInfo [aas_areainfo_t * info], AAS_PlaneFromNum [aas_plane_t *]
- be_ai_char (6): global botcharacters [bot_character_t *[33]], BotCharacterFromHandle [bot_character_t *], BotDumpCharacter [bot_character_t * ch], BotFreeCharacterStrings [bot_character_t * ch], BotDefaultCharacteristics [bot_character_t * ch], BotLoadCharacterFromFile [bot_character_t *]
- be_ai_chat (39): global ichatdata [bot_ichatdata_t *[32]], global botchatstates [bot_chatstate_t *[33]], global consolemessageheap [bot_consolemessage_t *], global freeconsolemessages [bot_consolemessage_t *], global matchtemplates [bot_matchtemplate_t *], global synonyms [bot_synonymlist_t *], global randomstrings [bot_randomlist_t *], global replychats [bot_replychat_t *], BotChatStateFromHandle [bot_chatstate_t *], AllocConsoleMessage [bot_consolemessage_t *], FreeConsoleMessage [bot_consolemessage_t * message], BotNextConsoleMessage [bot_consolemessage_t * cm], BotDumpSynonymList [bot_synonymlist_t * synlist], BotLoadSynonyms [bot_synonymlist_t *], BotLoadChatMessage [source_t * source], BotDumpRandomStringList [bot_randomlist_t * randomlist], BotLoadRandomStrings [bot_randomlist_t *], BotDumpMatchTemplates [bot_matchtemplate_t * matches], BotFreeMatchPieces [bot_matchpiece_t * matchpieces], BotLoadMatchPieces [source_t * source], BotFreeMatchTemplates [bot_matchtemplate_t * mt], BotLoadMatchTemplates [bot_matchtemplate_t *], StringsMatch [bot_matchpiece_t * pieces], BotFindMatch [bot_match_t * match], BotMatchVariable [bot_match_t * match], BotFindStringInList [bot_stringlist_t * list], BotCheckChatMessageIntegrety [bot_stringlist_t * stringlist], BotCheckInitialChatIntegrety [bot_chat_t * chat], BotCheckReplyChatIntegrety [bot_replychat_t * replychat], BotDumpReplyChat [bot_replychat_t * replychat], BotFreeReplyChat [bot_replychat_t * replychat], BotCheckValidReplyChatKeySet [source_t * source], BotLoadReplyChat [bot_replychat_t *], BotDumpInitialChat [bot_chat_t * chat], BotLoadInitialChat [bot_chat_t *], BotExpandChatMessage [bot_match_t * match], BotConstructChatMessage [bot_chatstate_t * chatstate], BotChooseInitialChatMessage [bot_chatstate_t * cs], BotPrintReplyChatKeys [bot_replychat_t * replychat]
- be_ai_goal (28): global iteminfo_fields [`fielddef_s`], global iteminfo_struct [`structdef_s`], global botgoalstates [bot_goalstate_t *[33]], global itemconfig [itemconfig_t *], global levelitemheap [levelitem_t *], global freelevelitems [levelitem_t *], global levelitems [levelitem_t *], global maplocations [maplocation_t *], global campspots [campspot_t *], global droppedweight [libvar_t *], BotGoalStateFromHandle [bot_goalstate_t *], LoadItemConfig [itemconfig_t *], ItemWeightIndex [weightconfig_t * iwc], AllocLevelItem [levelitem_t *], FreeLevelItem [levelitem_t * li], AddLevelItemToList [levelitem_t * li], RemoveLevelItemFromList [levelitem_t * li], BotAddToAvoidGoals [bot_goalstate_t * gs], BotGetLevelItemGoal [bot_goal_t * goal], BotGetMapLocationGoal [bot_goal_t * goal], BotGetNextCampSpotGoal [bot_goal_t * goal], BotFindEntityForLevelItem [levelitem_t * li], BotPushGoal [bot_goal_t * goal], BotGetTopGoal [bot_goal_t * goal], BotGetSecondGoal [bot_goal_t * goal], BotChooseNBGItem [bot_goal_t * ltg], BotTouchingGoal [bot_goal_t * goal], BotItemGoalInVisButNotVisible [bot_goal_t * goal]
- be_ai_move (58): global sv_maxstep, sv_maxbarrier, sv_gravity, weapindex_rocketlauncher, weapindex_bfg10k, weapindex_grapple, entitytypemissile, offhandgrapple, cmd_grappleoff, cmd_grappleon [libvar_t *], global botmovestates [bot_movestate_t *[33]], BotMoveStateFromHandle [bot_movestate_t *], BotInitMoveState [bot_initmove_t * initmove], BotOnMover [aas_reachability_t * reach], MoverDown [aas_reachability_t * reach], BotOnTopOfEntity [bot_movestate_t * ms], BotValidTravel [aas_reachability_t * reach], BotAddToAvoidReach [bot_movestate_t * ms], BotAvoidSpots [aas_reachability_t * reach], BotGetReachabilityToGoal [bot_goal_t * goal], BotMovementViewTarget [bot_goal_t * goal], BotPredictVisiblePosition [bot_goal_t * goal], MoverBottomCenter [aas_reachability_t * reach], BotCheckBarrierJump [bot_movestate_t * ms], BotSwimInDirection [bot_movestate_t * ms], BotWalkInDirection [bot_movestate_t * ms], BotCheckBlocked [bot_movestate_t * ms], BotClearMoveResult [bot_moveresult_t * moveresult], BotTravel_Walk, BotFinishTravel_Walk, BotTravel_Crouch, BotTravel_BarrierJump, BotFinishTravel_BarrierJump, BotTravel_Swim, BotTravel_WaterJump, BotFinishTravel_WaterJump, BotTravel_WalkOffLedge, BotFinishTravel_WalkOffLedge, BotTravel_Jump, BotFinishTravel_Jump, BotTravel_Ladder, BotTravel_Teleport, BotTravel_Elevator, BotFinishTravel_Elevator [bot_movestate_t * ms], BotFuncBobStartEnd [aas_reachability_t * reach], BotTravel_FuncBobbing, BotFinishTravel_FuncBobbing, GrappleState, BotResetGrapple, BotTravel_Grapple, BotTravel_RocketJump, BotTravel_BFGJump, BotFinishTravel_WeaponJump, BotTravel_JumpPad, BotFinishTravel_JumpPad [bot_movestate_t * ms], BotReachabilityTime [aas_reachability_t * reach], BotMoveInGoalArea [bot_movestate_t * ms], BotMoveToGoal [bot_moveresult_t * result]
- be_ai_weap (10): global weaponinfo_fields, projectileinfo_fields [`fielddef_s`], global weaponinfo_struct, projectileinfo_struct [`structdef_s`], global botweaponstates [bot_weaponstate_t *[33]], global weaponconfig [weaponconfig_t *], BotWeaponStateFromHandle [bot_weaponstate_t *], LoadWeaponConfig [weaponconfig_t *], WeaponWeightIndex [weightconfig_t * wwc], BotGetWeaponInfo [weaponinfo_t * weaponinfo]
- be_ai_weight (21): global weightFileList [weightconfig_t *[128]], ReadValue [source_t * source], ReadFuzzyWeight [source_t * source], FreeFuzzySeperators_r [fuzzyseperator_t * fs], FreeWeightConfig2 [weightconfig_t * config], FreeWeightConfig [weightconfig_t * config], ReadFuzzySeperators_r [source_t * source], ReadWeightConfig [weightconfig_t *], FindFuzzyWeight [weightconfig_t * wc], FuzzyWeight_r [fuzzyseperator_t * fs], FuzzyWeightUndecided_r [fuzzyseperator_t * fs], FuzzyWeight [weightconfig_t * wc], FuzzyWeightUndecided [weightconfig_t * wc], EvolveFuzzySeperator_r [fuzzyseperator_t * fs], EvolveWeightConfig [weightconfig_t * config], ScaleFuzzySeperator_r [fuzzyseperator_t * fs], ScaleWeight [weightconfig_t * config], ScaleFuzzySeperatorBalanceRange_r [fuzzyseperator_t * fs], ScaleFuzzyBalanceRange [weightconfig_t * config], InterbreedFuzzySeperator_r [fuzzyseperator_t * fs1], InterbreedWeightConfigs [weightconfig_t * config1]
- be_ea (2): global botinputs [bot_input_t *], EA_GetInput [bot_input_t * input]
- be_interface (8): global botlibglobals [`botlib_globals_s`], global be_botlib_export [`botlib_export_s`], global botimport [`botlib_import_s`], Export_BotLibUpdateEntity [bot_entitystate_t * state], Init_AAS_Export [aas_export_t * aas], Init_EA_Export [ea_export_t * ea], Init_AI_Export [ai_export_t * ai], GetBotLibAPI [botlib_import_t * import]
- l_libvar (5): global libvarlist [libvar_t *], LibVarAlloc [libvar_t *], LibVarDeAlloc [libvar_t * v], LibVarGet [libvar_t *], LibVar [libvar_t *]
- l_log (2): global logfile [`logfile_s`], Log_FilePointer [FILE *]
- l_memory (4): GetMemory, GetClearedMemory, GetHunkMemory, GetClearedHunkMemory [void *]
- l_precomp (71): global globaldefines [define_t **], global directives, dollardirectives [`directive_s`], global sourceFiles [source_t *[64]], SourceError, SourceWarning, PC_PushIndent, PC_PopIndent, PC_PushScript [source_t * source], PC_CopyToken, PC_FreeToken [token_t * token], PC_ReadSourceToken, PC_UnreadSourceToken, PC_ReadDefineParms [source_t * source], PC_StringizeTokens [token_t * tokens], PC_MergeTokens [token_t * t1], PC_PrintDefineHashTable [define_t ** definehash], PC_AddDefineToHash [define_t * define], PC_FindHashedDefine [define_t ** definehash], PC_FindDefine [define_t * defines], PC_FindDefineParm, PC_FreeDefine [define_t * define], PC_AddBuiltinDefines, PC_ExpandBuiltinDefine, PC_ExpandDefine, PC_ExpandDefineIntoSource, PC_Directive_include, PC_ReadLine [source_t * source], PC_WhiteSpaceBeforeToken, PC_ClearTokenWhiteSpace [token_t * token], PC_Directive_undef, PC_Directive_define [source_t * source], PC_DefineFromString [define_t *], PC_AddDefine, PC_CopyDefine, PC_AddGlobalDefinesToSource, PC_Directive_if_def, PC_Directive_ifdef, PC_Directive_ifndef, PC_Directive_else, PC_Directive_endif, PC_EvaluateTokens, PC_Evaluate, PC_DollarEvaluate, PC_Directive_elif, PC_Directive_if, PC_Directive_line, PC_Directive_error, PC_Directive_pragma, UnreadSignToken, PC_Directive_eval, PC_Directive_evalfloat, PC_ReadDirective, PC_DollarDirective_evalint, PC_DollarDirective_evalfloat, PC_ReadDollarDirective, PC_ReadToken, PC_ExpectTokenString, PC_ExpectTokenType, PC_ExpectAnyToken, PC_CheckTokenString, PC_CheckTokenType, PC_SkipUntilString, PC_UnreadLastToken, PC_UnreadToken, PC_SetIncludePath, PC_SetPunctuations [source_t * source], LoadSourceFile, LoadSourceMemory [source_t *], FreeSource [source_t * source], PC_ReadTokenHandle [pc_token_t * pc_token]
- l_script (36): global default_punctuations [`punctuation_s`], PS_CreatePunctuationTable, PunctuationFromNum, ScriptError, ScriptWarning, SetScriptPunctuations, PS_ReadWhiteSpace, PS_ReadEscapeCharacter, PS_ReadString, PS_ReadName [script_t * script], NumberValue [long double * floatvalue], PS_ReadNumber, PS_ReadLiteral, PS_ReadPunctuation, PS_ReadPrimitive, PS_ReadToken, PS_ExpectTokenString, PS_ExpectTokenType, PS_ExpectAnyToken, PS_CheckTokenString, PS_CheckTokenType, PS_SkipUntilString, PS_UnreadLastToken, PS_UnreadToken, PS_NextWhiteSpaceChar, ReadSignedFloat, ReadSignedInt, SetScriptFlags, GetScriptFlags, ResetScript, EndOfScript, NumLinesCrossed, ScriptSkipTo [script_t * script], LoadScriptFile, LoadScriptMemory [script_t *], FreeScript [script_t * script]
- l_struct (9): FindField [fielddef_t * defs], ReadNumber, ReadChar, ReadString, ReadStructure [source_t * source], WriteIndent, WriteFloat, WriteStructWithIndent, WriteStructure [FILE * fp]

## Rulings, 2026-11-09

The user delegated every row of this docket on 2026-11-09: prove each row, then rule it by an existing pattern. The coordinator read the cited lines of the eight rows below. Rows D1 to D20 with a named pattern are ratified as the docket states them. Where the docket names two patterns, each applies at the sites the docket gives.

- N1 (D7), the `char *` cursor fields of `script_t` and `token_t` (`l_script.h:150`, `:151`, `:161` to `:166`). Ratified, delegated. A FIELDS kind `text_offset`, the field twin of the RETURNS kind `text_offset_nonnull` (`rulings.py:546`). `buffer` is a byte Slots of `length + 1` bytes. Each of the other seven fields is an `Int32` byte offset into `buffer`. The view converts between the offset and the C pointer at each get and set, so the C record keeps Raven's pointers.
- N2 (D10), `CS_SCORES`, `CS_MODELS`, `CS_SOUNDS` of `be_aas_def.h:29` to `:31`. Ratified, delegated. The botlib keeps Raven's values (32, 64, 64 + MAX_MODELS), because `be_aas_main.cpp:107` and `:117` index `aasworld.configstrings` with them, and Raven's comment at `:28` shows he knew of the second definition. They do not go into `ded_types.h`, where the names collide with `CJKAMP`. They take the form the skeleton already gives a `#define` of a .cpp file, in `be_aas_main.swift`, with Raven's names and one AI line. If the skeleton has no such form, they are file-scope `private let` constants there.
- N3 (D6), a file-scope `T **` that holds an allocated table of record pointers: `globaldefines` (`l_precomp.cpp:105`), `areareachability` (`be_aas_reach.cpp:85`). Ratified, delegated. TYPES `Slots<View?>?`, which joins `Slots<View>?` of `rulings.py:527` and `:530` with the `Slots<View?>` of the `pointer_table` kind.
- N4 (D15), the `vec3_t *` fields `aas_t.vertexes` (`be_aas_def.h:200`) and `optimized_t.vertexes`. Ratified, delegated. The field gives `Slots<vec3_t>` through the existing `Slots(vectors:)` initializer, the form the array field of `BotDebugpoly.swift:83` has, with the count the subscript sweep gives its sibling record fields.
- N5 (D15), the `unsigned short *` field `aas_routingupdate_t.areatraveltimes` (`be_aas_def.h:156`). Ratified, delegated. The FIELDS kind `bytes` reads an `unsigned short *` as `Slots<UInt16>` through `Slots(scalars:)`, the form it has for `int *`. The narrow-local rule of `docs/transcription.md` holds at each read and store.
- N6 (D15), the three-star fields `aas_t.areatraveltimes` and `clusterareacache` (`be_aas_def.h:264`, `:266`). Ratified, delegated, by the form the user ratified for row L1 today: keep Raven's memory and Raven's numbers, and put the unchecked step in hand accessors of the view target. For `areatraveltimes`: one accessor that gives the `Slots<UInt16>` row at `[i][l]`, and the stores of the two pointer levels that `be_aas_route.cpp:521` and `:526` make. For `clusterareacache`: a get and a set of the optional cache view at `[i][j]`, and the store of the level that `:785` makes. Each changed site carries one AI line. No nested Slots kind is added.
- N7 (D15), `aas_routingcache_t.traveltimes[1]` (`be_aas_def.h:146`). Ratified, delegated. A SLOT_BOUNDS row with no bound, the `count: Int.max` form the generator gives `areaParms_t.list` (`Generated/Views/AreaParms.swift`), because Raven sizes the block at the allocation and no macro bounds it.
- N8 (D12 shapes 5, 10, and 11), a block that holds a table of record pointers, a record with another table after it, or many records and texts. Ratified, delegated. Each site takes the form the eighth batch landed at `files_pc.swift:1679` to `:1682`: the `raw` block of the allocator, Raven's sizes, and each piece bound as a view or a Slots at its byte offset in the block. Read that form on master before you write a site. If it is not on master, or it does not fit a site, leave that site open with the proof.
