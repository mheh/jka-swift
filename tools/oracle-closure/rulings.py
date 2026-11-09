"""rulings.py: every mapping the generators apply by name, in one file.

A shape rule, a C type pattern that maps to one Swift spelling for every function, lives in table.py. A name rule, this
struct gets a view, this function returns raw memory, this field is never NULL, lives here. Each entry cites the ruling
in docs/transcription.md by its section, and an entry joins only by a ruling, never by a generator's guess.

The kinds a PARAMS entry may name are the ones table.py knows how to cross. A new kind is a shape rule first.
"""

from __future__ import annotations

from dataclasses import dataclass

# MARK: - Views

# Root struct -> (view name, C target), one table per unit, and ROOTS keys the tables by the unit of a run.
# Every other view takes Raven's typedef name with _t dropped and the first letter raised.
# A view is generated for a root and for every struct a root's field points at. See "The views".
GAME_ROOTS = {
    "gentity_t": ("Entity", "CJKAMP_Game"),
    "gclient_t": ("Client", "CJKAMP_Game"),
    "level_locals_t": ("Level", "CJKAMP_Game"),
    "playerState_t": ("PlayerState", "CJKAMP"),
    # The bg files read pmove_t through the static `pm` and pml_t through `pml`, and no root field points at either.
    "pmove_t": ("Pmove", "CJKAMP"),
    "pml_t": ("Pml", "CJKAMP"),
    # The bg parsers fill these through a pointer parameter or return one, and no root field points at them.
    "siegeClassDesc_t": ("SiegeClassDesc", "CJKAMP"),
    "siegeClass_t": ("SiegeClass", "CJKAMP"),
    "siegeTeam_t": ("SiegeTeam", "CJKAMP"),
    "vehWeaponInfo_t": ("VehWeaponInfo", "CJKAMP"),
    "BG_field_t": ("BgField", "CJKAMP"),
    # The weapon and ammo tables are C storage a body indexes, and the game's cvars are C storage bg reads by view.
    "weaponData_t": ("WeaponData", "CJKAMP"),
    "ammoData_t": ("AmmoData", "CJKAMP"),
    "vmCvar_t": ("VmCvar", "CJKAMP"),
    # A parameter or a return names these, and no root field points at them.
    "mdxaBone_t": ("MdxaBone", "CJKAMP"),
    "sharedRagDollParams_t": ("SharedRagDollParams", "CJKAMP"),
    "sharedRagDollUpdateParams_t": ("SharedRagDollUpdateParams", "CJKAMP"),
    "sharedIKMoveParams_t": ("SharedIKMoveParams", "CJKAMP"),
    "sharedSetBoneIKStateParams_t": ("SharedSetBoneIKStateParams", "CJKAMP"),
    # q_shared.h declares it, so the view lives in the shared module, where the stub of q_shared.c can name it.
    "stringID_table_t": ("StringIDTable", "CJKAShared"),
    # A trap fills these two through a pointer parameter.
    "qtime_t": ("Qtime", "CJKAMP"),
    "pc_token_t": ("PcToken", "CJKAMP"),
    # A stub parameter names this one.
    "bot_input_t": ("BotInput", "CJKAMP_Game"),
    # A file-scope table names these, and no root field points at them.
    "bgLoadedAnim_t": ("BgLoadedAnim", "CJKAMP"),
    # The bg table `bgAllEvents` of the cgame and ui block at bg_panimate.c:2166 names this one, with the cgame's view name and target.
    "bgLoadedEvents_t": ("BgLoadedEvents", "CJKAMP"),
    "saberMoveData_t": ("SaberMoveData", "CJKAMP"),
    "boteventtracker_t": ("Boteventtracker", "CJKAMP_Game"),
    "nodeobject_t": ("Nodeobject", "CJKAMP_Game"),
    "waypointData_t": ("WaypointData", "CJKAMP_Game"),
    "wpobject_t": ("Wpobject", "CJKAMP"),
    "siegePers_t": ("SiegePers", "CJKAMP"),
    "bot_state_t": ("BotState", "CJKAMP_Game"),
    "bot_settings_t": ("BotSettings", "CJKAMP_Game"),
    "navInfo_t": ("NavInfo", "CJKAMP_Game"),
    "reference_tag_t": ("ReferenceTag", "CJKAMP_Game"),
    "failedEdge_t": ("FailedEdge", "CJKAMP"),
    "CollisionRecord_t": ("CollisionRecord", "CJKAMP_Game"),
    # Raven defines these inside a .c file, and g_types.h carries them into the game target.
    "gtimer_t": ("Gtimer", "CJKAMP_Game"),
    "tagOwner_t": ("TagOwner", "CJKAMP_Game"),
    "saberFace_t": ("SaberFace", "CJKAMP_Game"),
    "ipFilter_t": ("IpFilter", "CJKAMP_Game"),
    "cvarTable_t": ("CvarTable", "CJKAMP_Game"),
    "pushed_t": ("Pushed", "CJKAMP_Game"),
    "spawn_t": ("Spawn", "CJKAMP_Game"),
    "botSpawnQueue_t": ("BotSpawnQueue", "CJKAMP_Game"),
    "shaderRemap_t": ("ShaderRemap", "CJKAMP_Game"),
    "shooterClient_t": ("ShooterClient", "CJKAMP_Game"),
    "teamgame_t": ("Teamgame", "CJKAMP_Game"),
    "combatPt_t": ("CombatPt", "CJKAMP_Game"),
    # vmMain reads these ICARUS structs through gSharedBuffer, and no root field points at them.
    "T_G_ICARUS_PLAYSOUND": ("IcarusPlaySound", "CJKAMP"),
    "T_G_ICARUS_SET": ("IcarusSet", "CJKAMP"),
    "T_G_ICARUS_LERP2POS": ("IcarusLerp2Pos", "CJKAMP"),
    "T_G_ICARUS_LERP2ORIGIN": ("IcarusLerp2Origin", "CJKAMP"),
    "T_G_ICARUS_LERP2ANGLES": ("IcarusLerp2Angles", "CJKAMP"),
    "T_G_ICARUS_GETTAG": ("IcarusGetTag", "CJKAMP"),
    "T_G_ICARUS_LERP2START": ("IcarusLerp2Start", "CJKAMP"),
    "T_G_ICARUS_LERP2END": ("IcarusLerp2End", "CJKAMP"),
    "T_G_ICARUS_USE": ("IcarusUse", "CJKAMP"),
    "T_G_ICARUS_KILL": ("IcarusKill", "CJKAMP"),
    "T_G_ICARUS_REMOVE": ("IcarusRemove", "CJKAMP"),
    "T_G_ICARUS_PLAY": ("IcarusPlay", "CJKAMP"),
    "T_G_ICARUS_GETFLOAT": ("IcarusGetFloat", "CJKAMP"),
    "T_G_ICARUS_GETVECTOR": ("IcarusGetVector", "CJKAMP"),
    "T_G_ICARUS_GETSTRING": ("IcarusGetString", "CJKAMP"),
    "T_G_ICARUS_SOUNDINDEX": ("IcarusSoundIndex", "CJKAMP"),
    "T_G_ICARUS_GETSETIDFORSTRING": ("IcarusGetSetIDForString", "CJKAMP"),
    # bg_vehicleLoad.c defines this one, copied into bg_tables.h.
    "vehField_t": ("VehField", "CJKAMP"),
}

CGAME_ROOTS = {
    # The rows the game holds for a struct of JKAMP, with the game's view name and target, so both units write one view file.
    # They come first, because the first walk to reach a struct gives it its target.
    "vmCvar_t": ("VmCvar", "CJKAMP"),
    "pmove_t": ("Pmove", "CJKAMP"),
    "siegeClass_t": ("SiegeClass", "CJKAMP"),
    "siegeTeam_t": ("SiegeTeam", "CJKAMP"),
    "vehWeaponInfo_t": ("VehWeaponInfo", "CJKAMP"),
    "weaponData_t": ("WeaponData", "CJKAMP"),
    "ammoData_t": ("AmmoData", "CJKAMP"),
    "mdxaBone_t": ("MdxaBone", "CJKAMP"),
    "sharedRagDollParams_t": ("SharedRagDollParams", "CJKAMP"),
    "sharedRagDollUpdateParams_t": ("SharedRagDollUpdateParams", "CJKAMP"),
    "sharedIKMoveParams_t": ("SharedIKMoveParams", "CJKAMP"),
    "sharedSetBoneIKStateParams_t": ("SharedSetBoneIKStateParams", "CJKAMP"),
    "pc_token_t": ("PcToken", "CJKAMP"),
    "qtime_t": ("Qtime", "CJKAMP"),
    "bgLoadedAnim_t": ("BgLoadedAnim", "CJKAMP"),
    "saberMoveData_t": ("SaberMoveData", "CJKAMP"),
    # The C table cg_spawnFields of cg_main.c holds these rows, and BG_ParseField reads them.
    "BG_field_t": ("BgField", "CJKAMP"),
    # The cgame's state: Raven's `cg`, `cgs`, and `cg_entities` of cg_main.c.
    "cg_t": ("Cg", "CJKAMP_CGame"),
    "cgs_t": ("Cgs", "CJKAMP_CGame"),
    "centity_t": ("Centity", "CJKAMP_CGame"),
    # A file-scope table or record of a cgame .c file names these, and no root field points at them.
    "localEntity_t": ("LocalEntity", "CJKAMP_CGame"),
    "markPoly_t": ("MarkPoly", "CJKAMP_CGame"),
    "weaponInfo_t": ("WeaponInfo", "CJKAMP_CGame"),
    "itemInfo_t": ("ItemInfo", "CJKAMP_CGame"),
    "clightstyle_t": ("Clightstyle", "CJKAMP_CGame"),
    "cgscreffects_t": ("Cgscreffects", "CJKAMP_CGame"),
    "siegeExtended_t": ("SiegeExtended", "CJKAMP_CGame"),
    "displayContextDef_t": ("DisplayContextDef", "CJKAMP_CGame"),
    # The bg table bg_itemlist names this one, and no cgame root field points at it.
    "gitem_t": ("Gitem", "CJKAMP"),
    # Raven defines these inside a cgame .c file, and cg_types.h carries them into the cgame target.
    # The cgame's cvarTable_t has other fields than the game's, and the two views live in two modules no target imports together.
    "cvarTable_t": ("CvarTable", "CJKAMP_CGame"),
    "cgSpawnEnt_t": ("CgSpawnEnt", "CJKAMP_CGame"),
    "cparticle_t": ("Cparticle", "CJKAMP_CGame"),
    "lagometer_t": ("Lagometer", "CJKAMP_CGame"),
    "veh_damage_t": ("Veh_damage", "CJKAMP_CGame"),
    "consoleCommand_t": ("ConsoleCommand", "CJKAMP_CGame"),
    # Item_StartCapture of ui_shared.c fills `scrollInfo` and hands its address to the five Scroll functions through `captureData`.
    "scrollInfo_t": ("ScrollInfo", "CJKAMP_CGame"),
    # The C tables g_bindings and itemFlags of ui_shared.c hold these rows.
    "bind_t": ("Bind", "CJKAMP_CGame"),
    "itemFlagsDef_t": ("ItemFlagsDef", "CJKAMP_CGame"),
    # The file-scope table `strHandle` of ui_shared.c holds pointers to these, one hash chain of interned texts per bucket.
    "stringDef_t": ("StringDef", "CJKAMP_CGame"),
    # The file-scope list head `ui_G2PtrTracker` of ui_shared.c points at these, one record per Ghoul2 instance the UI holds.
    "uiG2PtrTracker_t": ("UiG2PtrTracker", "CJKAMP_CGame"),
    # A trap or a stub parameter names these, and no root field points at them.
    "polyVert_t": ("PolyVert", "CJKAMP"),
    "poly_t": ("Poly", "CJKAMP"),
    "markFragment_t": ("MarkFragment", "CJKAShared"),
    "orientation_t": ("Orientation", "CJKAShared"),
    "addpolyArgStruct_t": ("AddpolyArgStruct", "CJKAMP"),
    "addspriteArgStruct_t": ("AddspriteArgStruct", "CJKAMP"),
    "addbezierArgStruct_t": ("AddbezierArgStruct", "CJKAMP"),
    "addElectricityArgStruct_t": ("AddElectricityArgStruct", "CJKAMP"),
    "effectTrailArgStruct_t": ("EffectTrailArgStruct", "CJKAMP"),
    "effectTrailVertStruct_t": ("EffectTrailVertStruct", "CJKAMP"),
    # Raven gave this typedef no _t, so the view drops his leading S and keeps its own name apart from the C type.
    "SSkinGoreData": ("SkinGoreData", "CJKAMP"),
    "animevent_t": ("Animevent", "CJKAMP"),
    "bgLoadedEvents_t": ("BgLoadedEvents", "CJKAMP"),
    "itemDef_t": ("ItemDef", "CJKAMP_CGame"),
    "menuDef_t": ("MenuDef", "CJKAMP_CGame"),
    "cachedAssets_t": ("CachedAssets", "CJKAMP_CGame"),
    # Item_ValidateTypeData of ui_shared.c allocates one of these into the `void *typeData` of an item by its type, and the bodies cast it back.
    # No root field points at them, because the field is a `void *`.
    "listBoxDef_t": ("ListBoxDef", "CJKAMP_CGame"),
    "multiDef_t": ("MultiDef", "CJKAMP_CGame"),
    "textScrollDef_t": ("TextScrollDef", "CJKAMP_CGame"),
    "editFieldDef_t": ("EditFieldDef", "CJKAMP"),
    "modelDef_t": ("ModelDef", "CJKAMP"),
    # The game's view of CollisionRecord_t stands in JKAMP_Game, which a cgame target cannot import, so the cgame has its own.
    "CollisionRecord_t": ("CollisionRecord", "CJKAMP_CGame"),
    # vmMain and the engine's callbacks read these through the shared buffer of cg_public.h, and no root field points at them.
    # Raven gave the TCG typedefs no _t, so each view drops his leading T, as IcarusPlaySound drops T_G_ICARUS_.
    "autoMapInput_t": ("AutoMapInput", "CJKAMP_CGame"),
    "TCGTrace": ("CGTrace", "CJKAMP_CGame"),
    "TCGPointContents": ("CGPointContents", "CJKAMP_CGame"),
    "TCGVectorData": ("CGVectorData", "CJKAMP_CGame"),
    "TCGGetBoltData": ("CGGetBoltData", "CJKAMP_CGame"),
    "TCGImpactMark": ("CGImpactMark", "CJKAMP_CGame"),
    "TCGMiscEnt": ("CGMiscEnt", "CJKAMP_CGame"),
    "TCGG2Mark": ("CGG2Mark", "CJKAMP_CGame"),
    "TCGCameraShake": ("CGCameraShake", "CJKAMP_CGame"),
    "ragCallbackTraceLine_t": ("RagCallbackTraceLine", "CJKAMP_CGame"),
    "ragCallbackDebugLine_t": ("RagCallbackDebugLine", "CJKAMP_CGame"),
    "ragCallbackDebugBox_t": ("RagCallbackDebugBox", "CJKAMP_CGame"),
    "ragCallbackBoneSnap_t": ("RagCallbackBoneSnap", "CJKAMP_CGame"),
}

# The records the dedicated server reads, row E4 of notes/2026-11-03/dedicated-opening-docket.md and row T5 of its stage 1 tools record.
HOST_ROOTS = {
    # The rows the game holds for a struct of JKAMP come first, with the game's view name and target.
    "playerState_t": ("PlayerState", "CJKAMP"),
    "sharedEntity_t": ("SharedEntity", "CJKAMP"),
    "cvar_t": ("Cvar", "CJKAMP"),
    # Cvar_Register and Cvar_Update of cvar.cpp take the module's cvar record, the row GAME_ROOTS and CGAME_ROOTS hold.
    "vmCvar_t": ("VmCvar", "CJKAMP"),
    # The server's own state, Raven's `svs` and `sv` of sv_main.cpp, and the records its signatures take.
    "serverStatic_t": ("ServerStatic", "CJKAMP_Ded"),
    "server_t": ("Server", "CJKAMP_Ded"),
    "client_t": ("Client", "CJKAMP_Ded"),
    "msg_t": ("Msg", "CJKAMP_Ded"),
    "vm_t": ("Vm", "CJKAMP_Ded"),
    # The net_chan.cpp signatures take these two, `netadr_t adr` by value and `netchan_t *chan`.
    "netadr_t": ("Netadr", "CJKAMP_Ded"),
    "netchan_t": ("Netchan", "CJKAMP_Ded"),
    # The cm_polylib.cpp signatures take `winding_t *`. Raven allocates the record larger than its declared `vec3_t p[4]`.
    "winding_t": ("Winding", "CJKAMP_Ded"),
    # Raven's `static huffman_t msgHuff` of msg.cpp:19, and the `huff_t` and `node_t` records the huffman.cpp signatures take.
    "huffman_t": ("Huffman", "CJKAMP_Ded"),
    # VM_PrepareInterpreter of vm_interpreted.cpp:139 takes the QVM header.
    "vmHeader_t": ("VmHeader", "CJKAMP_Ded"),
    # Raven defines these inside a .cpp file, and ded_types.h carries them into the host target.
    "cmd_t": ("Cmd", "CJKAMP_Ded"),
    "MD4_CTX": ("Md4Ctx", "CJKAMP_Ded"),
    "loopmsg_t": ("Loopmsg", "CJKAMP_Ded"),
    "loopback_t": ("Loopback", "CJKAMP_Ded"),
    # The two file-scope lists of msg.cpp:2002, `g_netfBitStorage` and `g_psfBitStorage`, hold these nodes.
    "bitStorage_t": ("BitStorage", "CJKAMP_Ded"),
    # The zone of z_memman_pc.cpp:30 to :72, the header before each block, the tail after it, the counts, and `TheZone` at :77.
    "zoneHeader_t": ("ZoneHeader", "CJKAMP_Ded"),
    "zoneTail_t": ("ZoneTail", "CJKAMP_Ded"),
    "zoneStats_t": ("ZoneStats", "CJKAMP_Ded"),
    "zone_t": ("Zone", "CJKAMP_Ded"),
    # The static blocks of z_memman_pc.cpp:124 and :131, which hold `gZeroMalloc`, `gEmptyString`, and `gNumberString`, and ded_tables.c holds the three as C storage.
    "StaticZeroMem_t": ("StaticZeroMem", "CJKAMP_Ded"),
    "StaticMem_t": ("StaticMem", "CJKAMP_Ded"),
    # The four netField tables of msg.cpp hold these rows, and ded_tables.c holds the tables as C storage.
    "netField_t": ("NetField", "CJKAMP_Ded"),
    # Com_RealTime of common.cpp:713 fills the record, the row GAME_ROOTS and CGAME_ROOTS hold for trap_RealTime.
    "qtime_t": ("Qtime", "CJKAMP"),
    # The event ring of common.cpp:752 and the queue of win_main.cpp:1113 hold these records, and Sys_QueEvent writes one through a pointer.
    "sysEvent_t": ("SysEvent", "CJKAMP_Ded"),
    # The file system of files.h:36 to :100: the handle table `fsh` of files_common.cpp:202, the search path, the paks, the directories, and the hash chains.
    # A `fileHandleData_t` holds `qfile_ut` and `qfile_gut` by value, so the walk reaches both.
    "fileHandleData_t": ("FileHandleData", "CJKAMP_Ded"),
    "searchpath_t": ("Searchpath", "CJKAMP_Ded"),
    "pack_t": ("Pack", "CJKAMP_Ded"),
    "directory_t": ("Directory", "CJKAMP_Ded"),
    "fileInPack_t": ("FileInPack", "CJKAMP_Ded"),
    # A handle holds the pair of the stream and its flag, files.h:78, over the union of the stream and the zip handle, files.h:71.
    "qfile_ut": ("Qfile_u", "CJKAMP_Ded"),
    "qfile_gut": ("Qfile_gu", "CJKAMP_Ded"),
    # The pak arm of FS_FOpenFileRead at files_pc.cpp:828 casts the zip handle to the record of unzip.h.
    "unz_s": ("UnzS", "CJKAMP_Ded"),
    # The clip map of cm_local.h:161, `cmg` of cm_load.cpp:37 and `SubBSP` of :60, and the records its fields point at.
    "clipMap_t": ("ClipMap", "CJKAMP_Ded"),
    "cbrush_t": ("Cbrush", "CJKAMP_Ded"),
    "cbrushside_t": ("Cbrushside", "CJKAMP_Ded"),
    "cNode_t": ("CNode", "CJKAMP_Ded"),
    "cLeaf_t": ("CLeaf", "CJKAMP_Ded"),
    "cPatch_t": ("CPatch", "CJKAMP_Ded"),
    "cArea_t": ("CArea", "CJKAMP_Ded"),
    # The view takes another name than the C struct, because the view target imports the C struct under its own name.
    "CCMShader": ("CmShader", "CJKAMP_Ded"),
    # The loaders of cm_load.cpp read the BSP file through these disk records of qfiles.h, at `cmod_base + l->fileofs`.
    "dheader_t": ("Dheader", "CJKAMP_Ded"),
    # qfiles.h is a header of the tree, and lump_t is the one disk record of it the merge places in CJKAMP.
    "lump_t": ("Lump", "CJKAMP"),
    "dshader_t": ("Dshader", "CJKAMP_Ded"),
    "dmodel_t": ("Dmodel", "CJKAMP_Ded"),
    "dnode_t": ("Dnode", "CJKAMP_Ded"),
    "dleaf_t": ("Dleaf", "CJKAMP_Ded"),
    "dplane_t": ("Dplane", "CJKAMP_Ded"),
    "dbrush_t": ("Dbrush", "CJKAMP_Ded"),
    "dbrushside_t": ("Dbrushside", "CJKAMP_Ded"),
    "dsurface_t": ("Dsurface", "CJKAMP_Ded"),
    "mapVert_t": ("MapVert", "CJKAMP_Ded"),
}

ROOTS = {"mp-game": GAME_ROOTS, "mp-cgame": CGAME_ROOTS, "mp-engine-ded": HOST_ROOTS}

# (struct, field) pairs whose pointer Raven's callers always set. The field is non-optional, and its getter traps with the
# field's name when the pointer is NULL, the one divergence rule 19 allows. See "A pointer field Raven's callers always set".
NEVER_NULL = {
    ("pmove_t", "ps"),
    ("pmove_t", "trace"),
    ("pmove_t", "pointcontents"),
}

# (struct, field) pairs whose pointer a body indexes, with the C macro that bounds the records behind the pointer.
# C gives a pointer no bound, and this names Raven's own, which the view spells as the module exports it.
# A fixed array field that Raven declares short and allocates past takes the macro as its count too, `vec3_t p[4]` of winding_t.
# A field the rule does not name keeps the widest count, because no ruling has given it a bound.
# See docket row 8 of the bg walk of 2026-09-18.
SLOT_BOUNDS = {
    ("bgLoadedAnim_t", "anims"): "MAX_TOTALANIMATIONS",
    ("pmove_t", "animations"): "MAX_TOTALANIMATIONS",
    ("level_locals_t", "clients"): "MAX_CLIENTS",
    # cm_polylib.h:7 declares `p[4]` with the comment "variable sized", and cm_polylib.cpp:387 caps a clipped winding at MAX_POINTS_ON_WINDING.
    ("winding_t", "p"): "MAX_POINTS_ON_WINDING",
    # vm_local.h:107 declares `char symName[1]`, and VM_LoadSymbols allocates `sizeof( *sym ) + chars` for a token of COM_Parse at vm.cpp:300.
    ("vmSymbol_t", "symName"): "MAX_TOKEN_CHARS",
}

# File-scope variables a body reads with no bind, because Raven's callers always set them before any body runs.
# The stub forwards each one non-optional and traps on nil with the variable's name, as a view field in NEVER_NULL does.
NEVER_NULL_VARS = {"pm"}

# File-scope variables whose storage is hand work on the state object, because the generated shape is wrong for them.
# The value is the Swift spelling of the storage, and `None` means the variable has no storage.
# `bg_pool` has no storage, because `BG_Alloc` and `BG_TempAlloc` return one block per call.
# The entry stays, so the stub does not declare a `CharBuf` of `MAX_POOL_SIZE` bytes, and a body that reads `bg_pool` drafts a `portMissing` hole.
# `memoryPool` has no storage, because `G_Alloc` returns one block per call.
# The entry stays, so the stub does not declare a `CharBuf` of `POOLSIZE` bytes, and a body that reads `memoryPool` drafts a `portMissing` hole.
# `cg_strPool` has no storage, because `CG_StrPool_Alloc` returns one block per call, in the `G_Alloc` form.
# The entry stays, so the stub does not declare the pool of `MAX_CGSTRPOOL_SIZE` bytes, and a body that reads `cg_strPool` drafts a `portMissing` hole.
# A value that is a Swift array type names a hand table on the state object, and the stub forwards it under Raven's name.
# The keyword tables of ui_shared.c hold the address of a parse function in each row, so each is a hand array of rows on CGameWorld,
# and each hash table holds the index of the first row of a bucket. `commandList` holds the address of a script function the same way.
HAND_VARS = {
    "bg_pool": None, "memoryPool": None, "cg_strPool": None,
    "commandList": "[CommandDefRow]",
    "itemParseKeywords": "[KeywordHashRow]",
    "menuParseKeywords": "[KeywordHashRow]",
    "itemParseKeywordHash": "[Int32?]",
    "menuParseKeywordHash": "[Int32?]",
}

# File-scope character arrays whose address the engine holds, so each one is one zeroed byte allocation on the storage class, not a `CharBuf`.
# `gSharedBuffer` of g_main.c goes to the engine through `trap_SV_RegisterSharedMemory`, and vmMain reads the ICARUS views at its base.
# See "The post-spine walk", row P1, and the zeroed storage rule of docs/transcription.md.
# `cmd_text_buf` of cmd_common.cpp is the buffer `cmd_text.data` points at, cmd_common.cpp:56, so its `byte` elements read as a Slots.
# `sys_packetReceived` of win_main.cpp:1116 is the buffer of the message that Sys_GetEvent hands MSG_Init at win_main.cpp:1198, the cmd_text_buf form.
BYTE_STORAGE_VARS = {"gSharedBuffer", "cmd_text_buf", "sys_packetReceived"}
# Function locals that a ruling moves to the storage class as one zeroed byte allocation, each with the functions that declare it, first one first.
# `byte seq[65536]` of Huff_Decompress and Huff_Compress goes to the `byte *` of Huff_transmit and to Com_Memcpy, so a body needs its base.
# The two functions never run at once, and add_bit zeroes each byte before it writes, so one allocation serves both. Row R-A of the huffman round.
# `int digest[4]` of Com_BlockChecksum and Com_BlockChecksumKey goes to MD4Final as bytes at md4.cpp:275 and :291, so it is a Slots of Int32.
# Com_BlockChecksumKey hands `&key` of its `int key` parameter to MD4Update at md4.cpp:289, so the parameter has one Int32 of storage too.
# A parameter's storage takes the function name as a suffix, `key_Com_BlockChecksumKey`, because the parameter keeps Raven's name.
# `UINT4 x[16]` of MD4Transform goes to Decode at md4.cpp:175, and `unsigned char bits[8]` of MD4Final goes to Encode and MD4Update at :152 and :160.
# `unsigned regs[4]` of each CPUID caller of win_shared.cpp goes to CPUID, and each function keeps its own, so the key names the local and its function.
# A key of a local and its function gives the storage the function name as a suffix, `regs_IsKNI`, the rule of two static locals of one name.
# `vec3_t p[MAX_POINTS_ON_WINDING]` of RemoveColinearPoints goes to Com_Memcpy at cm_polylib.cpp:92,
# and `hullPoints` and `newHullPoints` of AddWindingToConvexHull go to Com_Memcpy at :644, :703, and :710, so each is a Slots of vec3_t.
# `byte send_buf[MAX_PACKETLEN]` of Netchan_TransmitNextFragment and of Netchan_Transmit goes to MSG_InitOOB at net_chan.cpp:94 and :172.
# `byte string[MAX_MSGLEN*2]` of NET_OutOfBandData is the store of `mbuf.data` at net_chan.cpp:600.
# Each of the three functions keeps its own allocation, so the key names the local and its function, `send_buf_Netchan_Transmit`.
BYTE_STORAGE_LOCALS = {
    "seq": ("Huff_Decompress", "Huff_Compress"),
    "digest": ("Com_BlockChecksum", "Com_BlockChecksumKey"),
    "key": ("Com_BlockChecksumKey",),
    "x": ("MD4Transform",),
    "bits": ("MD4Final",),
    ("regs", "Is3DNOW"): ("Is3DNOW",),
    ("regs", "IsKNI"): ("IsKNI",),
    ("regs", "IsWIL"): ("IsWIL",),
    ("regs", "IsMMX"): ("IsMMX",),
    "p": ("RemoveColinearPoints",),
    "hullPoints": ("AddWindingToConvexHull",),
    "newHullPoints": ("AddWindingToConvexHull",),
    ("send_buf", "Netchan_TransmitNextFragment"): ("Netchan_TransmitNextFragment",),
    ("send_buf", "Netchan_Transmit"): ("Netchan_Transmit",),
    ("string", "NET_OutOfBandData"): ("NET_OutOfBandData",),
    # `byte bufData[MAX_MSGLEN]` of Com_EventLoop goes to MSG_Init at common.cpp:927.
    ("bufData", "Com_EventLoop"): ("Com_EventLoop",),
    # `sysEvent_t ev` of Com_GetRealEvent and of Sys_GetEvent is the record each function returns, common.cpp:791 and win_main.cpp:1161.
    ("ev", "Com_GetRealEvent"): ("Com_GetRealEvent",),
    ("ev", "Sys_GetEvent"): ("Sys_GetEvent",),
    # FS_ReadFile reads and writes `int len` through `&len` in its journal arms, files_pc.cpp:1283, :1330, :1339, and :1367.
    ("len", "FS_ReadFile"): ("FS_ReadFile",),
    # VM_ValueToFunctionSymbol returns `&nullSym`, its `static vmSymbol_t nullSym`, at vm.cpp:125.
    ("nullSym", "VM_ValueToFunctionSymbol"): ("VM_ValueToFunctionSymbol",),
}
# A scalar data table Raven initializes at file scope that tables.py copies into C storage, which the view target reads as a Slots of its scalar.
# `static unsigned char PADDING[64]` of md4.cpp goes to MD4Update at md4.cpp:157, whose `input` is a Slots of bytes.
SCALAR_DATA_TABLES = {"PADDING"}
# The field twin of BYTE_STORAGE_VARS: a character array field whose address the engine holds, which the view reads as the field's address.
# `cg.sharedBuffer` of cg_local.h goes to the engine through `trap_CG_RegisterSharedMemory`, and the engine callbacks of cg_main.c read records at its base.
BYTE_STORAGE_FIELDS = {("cg_t", "sharedBuffer")}
# (struct, field) -> the kind of a pointer field, where the C type alone does not say. The field twin of PARAMS, with four of its kinds and one of its own:
#   raw   an UnsafeMutableRawPointer? for a `void *` that holds one of several records, which Raven casts back by another field
#   opaque  an OpaquePointer? for a pointer to a record of the C library, `FILE *`, which no view covers
#   view  the optional view of the record named beside the kind, ("view", record), for a `void *` every store fills with that record or NULL
#   bytes a Slots of bytes for a `byte *` that holds the base of a byte buffer a body indexes, and a Slots of Int32 for an `int *`
#   slot  a Slots of one optional view for a pointer to a record pointer, over the slot the field points at, so `*node->head` reads `node.head![0]`.
#         On a record pointer field it adds the accessor `<field>Slot`, the slot of the field itself, for Raven's `&sym->next`
#   pointer_table  a Slots of optional views with the widest count for a `T **` field that holds an array of record pointers
# Item_ValidateTypeData allocates one of five records into `typeData` by `item->type`, ui_shared.c:7279, and the bodies cast it back.
FIELDS = {
    ("itemDef_t", "typeData"): "raw",
    # Every store is a menu, `item->parent = menu` at ui_shared.c:1530, :4428, :4613, :4669, and :9697, and every read casts it to `menuDef_t *`.
    ("itemDef_t", "parent"): ("view", "menuDef_t"),
    # cg_newDraw.c:855 stores the menu of Display_CaptureItem, and cg_newDraw.c:776 hands it to Display_MouseMove.
    ("cgs_t", "capturedItem"): ("view", "menuDef_t"),
    # cmd_common.cpp:56 stores `cmd_text_buf`, a BYTE_STORAGE_VARS buffer, and the bodies index `cmd_text.data[i]` at :78, :103, and :110.
    ("cmd_t", "data"): "bytes",
    # MSG_Init and MSG_InitOOB store the caller's buffer at msg.cpp:66 and :89, and the bodies index `msg->data[i]` at :171 to :254.
    ("msg_t", "data"): "bytes",
    # A `node_t **` field holds the address of one `node_t *` slot, and huffman.cpp:150 shares one slot between the nodes of a block.
    ("node_t", "head"): "slot",
    ("huff_t", "freelist"): "slot",
    # The loaders of cm_load.cpp store an allocation in each, and cm_test.cpp and cm_trace.cpp index them, `cmg.leafbrushes[leaf->firstLeafBrush + k]`.
    # An `int *` field of kind `bytes` is a Slots of Int32, the same rule.
    ("clipMap_t", "leafbrushes"): "bytes",
    ("clipMap_t", "leafsurfaces"): "bytes",
    ("clipMap_t", "areaPortals"): "bytes",
    ("clipMap_t", "visibility"): "bytes",
    # VM_Restart and VM_Create clear and copy the QVM data at vm.cpp:416 and :564, and VM_LoadSymbols reads `vm->instructionPointers[value]` at :307.
    ("vm_t", "dataBase"): "bytes",
    ("vm_t", "instructionPointers"): "bytes",
    # A record pointer field of kind `slot` also reads as the slot of the field, because a body takes its address.
    # VM_LoadSymbols writes `prev = &vm->symbols` and `prev = &sym->next` at vm.cpp:268 and :302, and FS_ReorderPurePaks writes `&s->next` at files_pc.cpp:2470.
    ("vm_t", "symbols"): "slot",
    ("vmSymbol_s", "next"): "slot",
    ("vmSymbol_t", "next"): "slot",
    ("searchpath_t", "next"): "slot",
    # The stream of a file handle, files.h:72, is the C library's `FILE *`, which the backend hands to each stream call as it is.
    ("qfile_gut", "o"): "opaque",
    # The zip records of unzip.h:80 and :90 hold the same stream as `ZIP_FILE *`, the `FILE` of unzip.h:3.
    ("unz_s", "file"): "opaque",
    # `evPtr` of qcommon.h:939 holds the text of an SE_CONSOLE event or a `netadr_t` with the packet after it for SE_PACKET, by `evType`,
    # and Com_EventLoop casts it back at common.cpp:977 and :998.
    ("sysEvent_t", "evPtr"): "raw",
    ("file_in_zip_read_info_s", "file"): "opaque",
    # unzOpenCurrentFile allocates the read buffer at unzip.cpp:988, and unzReadCurrentFile hands it to ZIP_fread and to the stream at :1093 and :1100.
    ("file_in_zip_read_info_s", "read_buffer"): "opaque",
    # unzReadCurrentFile stores the caller's buffer and the read buffer at unzip.cpp:1070 and :1100, and steps them at :1124 and :1125.
    ("z_stream", "next_in"): "bytes",
    ("z_stream", "next_out"): "bytes",
    # A `T **` field of kind `pointer_table` holds the base of an array of record pointers a body indexes, with the widest count,
    # the field twin of the PARAMS kind. FS_LoadZipFile fills `pack->hashTable[hash]` at files_pc.cpp:1477, and cm_trace.cpp reads `cmg.surfaces[i]`.
    ("pack_t", "hashTable"): "pointer_table",
    ("clipMap_t", "surfaces"): "pointer_table",
}

# (struct, field) -> the accessor name of a field whose C name is a member of every view, `handle` or `raw`, where a body reads the field.
# Raven writes `vmCvar->handle` at cvar.cpp:896 and reads it at :913 and :917.
FIELD_NAMES = {
    ("vmCvar_t", "handle"): "cvarHandle",
    # Raven stores the zip handle at files_pc.cpp:1460 and reads it at :774, :1001, and :1058.
    ("pack_t", "handle"): "packHandle",
}

@dataclass(frozen=True)
class HandMacro:
    """One macro whose value is hand work: the Swift spelling a body writes, and the reason the stub carries.
    `swift` is the Swift type of the spelling, "Bool" for a test, so the drafter adds no `!= 0`, and None means the C type."""
    spelling: str
    reason: str
    swift: str | None = None


# Macros whose value is hand work.
# `MAX_POOL_SIZE` is the consumer's value under rule 23, `bg.maxPoolSize`.
# `__DATE__` is the compiler's build date, and Swift has no compile-time date, so a body writes the hand constant `buildDate` of JKAMP_GameLogic.
# See row 5 of the game globals walk.
# `SABERINVALID` is Raven's validity test in w_saber.c, and a body writes the hand function `saberInvalid` of JKAMP_GameLogic.
# See row 2a of the walk of 2026-09-29.
HAND_MACROS = {
    "MAX_POOL_SIZE": HandMacro("MAX_POOL_SIZE", "bg.maxPoolSize, the consumer's value under rule 23, which bg_local.swift forwards under Raven's name"),
    "__DATE__": HandMacro("buildDate", "buildDate, a hand string constant of JKAMP_GameLogic, because Swift has no compile-time date"),
    "SABERINVALID": HandMacro(
        "saberInvalid(saberent, saberOwner, other)",
        "saberInvalid, a hand Bool function of JKAMP_GameLogic, because the macro reads three parameters of its four callers and is not a constant",
        swift="Bool",
    ),
}

# MARK: - Types

# C typedef or file-scope variable -> the Swift type it is at every surface, where the C definition alone does not say.
# qint64 is Raven's struct of eight bytes from before the compilers had a portable 64-bit integer, and only the byte-swap pair touches it.
TYPES = {
    "qint64": "Int64",
    # AI: Raven typed UINT4 as unsigned long int. The port fixes it at 32 bits so the checksum matches on an lp64 host.
    # ded_types.h declares it `unsigned int`, so the views and this table agree, md4.cpp:17.
    "UINT4": "UInt32",
    # Raven declares `qboolean gSiegeRoundWinningTeam` at g_saga.c:38 and in the extern at g_main.c:1978,
    # and he stores and compares a team number through it, 0, SIEGETEAM_TEAM1, or SIEGETEAM_TEAM2.
    # Ruling A2 of 2026-10-11.
    "gSiegeRoundWinningTeam": "Int32",
    # Raven declares `char *fatalErrorPointer = NULL` at g_nav.c:1616, a write cursor into `fatalErrorString`,
    # so it is the byte offset of guide line 648, and `nil` is his NULL.
    "fatalErrorPointer": "Int32?",
    # Raven declares `static void *captureData = NULL` at ui_shared.c:100, and every store is `&scrollInfo` or NULL, :4039 to :4182.
    "captureData": "ScrollInfo?",
    # Raven declares `static void (*captureFunc) (void *p) = 0` at ui_shared.c:99, and he stores one of the five Scroll functions or 0.
    # C never sees the pointer, so it is a stored Swift function with nil for his 0.
    "captureFunc": "((ScrollInfo?) -> Void)?",
    # Raven declares `static char *opnames[256]` at vm_interpreted.cpp:9 with 60 names, and C leaves the other 196 slots NULL.
    "opnames": "[String?]",
    # Raven declares the C++ `bool g_nOverrideChecked = false` at msg.cpp:40.
    "g_nOverrideChecked": "Bool",
}

# A typedef Raven gives a narrow C type whose values are the enumerators of an anonymous enum, which reexport.py writes as the Int32 alias of a C enum.
# q_shared.h:3107 declares `typedef char memtag_t` after the enum of the TAG_ names, and Z_Malloc takes the tag, so `Z_Malloc(s, TAG_BSP, qtrue)` needs no cast.
ENUM_TYPEDEFS = {"memtag_t"}

# MARK: - Functions

# Function -> the kind of its return, where the C type alone does not say. See "The bg pool" and "C string functions".
#   raw            an UnsafeMutableRawPointer into the pool, the only Swift type a view can bind over
#   pooled_string  a String, the text a `char *` field takes, which the field's setter interns in the pool
#   text_cursor    a TextCursor, a pointer into the caller's text that the function returns advanced
#   optional_string  a String?, for a `char *` return Raven sets to NULL on one path
#   in_place       Void, for a function that rewrites its `char *` argument and returns it
#   text_offset    an Int32? byte offset into the argument, or nil, the shape strchr has in CString.swift
#   text_offset_nonnull  an Int32 byte offset into the argument that is never NULL
#   vec3           a JKAShared.vec3_t by value, for a `float *` Raven returns out of a static ring of temporaries
#   vec4           a JKAShared.vec4_t? by value, for a `float *` Raven returns out of a static `vec4_t` or NULL
#   table          a Slots over the records a field holds, for a function that returns the pointer of a field with a bound in SLOT_BOUNDS
#   view           the optional view of the record named beside the kind, ("view", record), for a `void *` return of that record or NULL
#   opaque         an OpaquePointer?, for a `void *` handle Raven returns that is not an allocation, the spelling the Ghoul2 traps take
#   row_index      an Int32? row index, for a `keywordHash_t *` row Raven returns or NULL, form A of R53
#   slot           a Slots of one optional view over a pointer slot, for a `node_t **` Raven returns, the form of a `node_t **` field
#   word           an Int, the pointer-wide word of the module's vmMain, which VM_Call returns whole
#   record         the view of a record Raven returns by value, which the body takes from a storage record or a table slot and the caller copies
RETURNS = {
    # get_ppnode of huffman.cpp:48 returns the address of a `node_t *` slot of `nodePtrs` or of the free list.
    "get_ppnode": "slot",
    "SkipWhitespace": "text_cursor",
    "ClientConnect": "optional_string",
    "G_GetBotInfoByName": "optional_string",
    "G_GetBotInfoByNumber": "optional_string",
    "Q3_GetAnimBoth": "optional_string",
    "Q3_GetAnimLower": "optional_string",
    "Q3_GetAnimUpper": "optional_string",
    "Q_strlwr": "in_place",
    "Q_strupr": "in_place",
    "Q_CleanStr": "in_place",
    "Q_strrchr": "text_offset",
    "COM_SkipPath": "text_offset_nonnull",
    "BG_Alloc": "raw",
    "BG_AllocUnaligned": "raw",
    "BG_TempAlloc": "raw",
    "B_Alloc": "raw",
    "B_TempAlloc": "raw",
    "G_Alloc": "raw",
    "CG_StrPool_Alloc": "raw",
    # UI_Alloc of ui_shared.c:209 takes the G_Alloc form, one block per call, and `memoryPool` has no storage.
    "UI_Alloc": "raw",
    "BG_StringAlloc": "pooled_string",
    "G_NewString": "pooled_string",
    "CG_NewString": "pooled_string",
    "tv": "vec3",
    # CG_FadeColor returns its static `vec4_t color` or NULL at cg_drawtools.c:387, and its callers test the NULL.
    "CG_FadeColor": "vec4",
    # BG_AnimsetAlloc returns `bgAllAnims[bgNumAllAnims].anims` at bg_panimate.c:1734, the table the parser indexes. Row X10 of 2026-10-27.
    "BG_AnimsetAlloc": "table",
    # Display_CaptureItem returns `&Menus[i]` or NULL at ui_shared.c:9858, and both callers cast it to `menuDef_t *`.
    "Display_CaptureItem": ("view", "menuDef_t"),
    # CG_G2WeaponInstance returns a Ghoul2 instance of `g2WeaponInstances` or NULL at cg_weapons.c:2373.
    "CG_G2WeaponInstance": "opaque",
    "KeywordHash_Find": "row_index",
    # Hunk_Alloc of z_memman_pc.cpp:791 and Z_Malloc of z_memman_pc.cpp:157 return one block per call, the G_Alloc form.
    "Hunk_Alloc": "raw",
    "Z_Malloc": "raw",
    # S_Malloc of z_memman_pc.cpp:480 and Hunk_AllocateTempMemory of :804 return the block of one Z_Malloc call, so each takes its row.
    "S_Malloc": "raw",
    "Hunk_AllocateTempMemory": "raw",
    # VM_Alloc of vm.cpp:227 returns the block of one Hunk_Alloc call, and VM_ArgPtr of :640 and BotVMShift of :657 return an address in the module's data.
    "VM_Alloc": "raw",
    "VM_ArgPtr": "raw",
    "BotVMShift": "raw",
    # Every caller of VM_ExplicitArgPtr of vm.cpp:742 casts the return to `char *`, the denial text of GAME_CLIENT_CONNECT, and the body returns NULL for a zero word.
    "VM_ExplicitArgPtr": "optional_string",
    # FS_ShiftedStrStr of files_pc.cpp:649 returns `strstr(string, buf)`, the text from the match or NULL.
    "FS_ShiftedStrStr": "optional_string",
    # FS_FileForHandle of files_pc.cpp:85 returns the stdio stream of a handle, a handle that is not an allocation.
    "FS_FileForHandle": "opaque",
    # Sys_GetBotAIAPI of win_main.cpp:30 returns NULL, and Sys_LoadDll of :784 returns the library handle, the `void *` that `vm->dllHandle` holds.
    "Sys_GetBotAIAPI": "opaque",
    "Sys_LoadDll": "opaque",
    # The module's vmMain returns a pointer-wide word, and GAME_CLIENT_CONNECT returns the address of the denial text, so VM_Call returns the whole word.
    "VM_Call": "word",
    # Raven returns a sysEvent_t by value at common.cpp:789 and :881 and win_main.cpp:1160.
    # The body returns the view of a record that lives past the call, the storage record of its local `ev` or a slot of the ring.
    "Com_GetRealEvent": "record",
    "Com_GetEvent": "record",
    "Sys_GetEvent": "record",
}

# Allocators whose `char *` result a body holds as a CharBuf of the constant size Raven asks for, when every store into the local is that call.
# The allocation call and its free stay on the page, so the pool keeps Raven's count. See row 1 of the walk of 2026-10-01.
# BG_TempAlloc holds the saberName locals of NPC_ParseParms and the tempReadBuffer locals of bg_vehicleLoad.
CHARBUF_ALLOCS = {"B_TempAlloc", "BG_TempAlloc"}

# (function, parameter) -> the kind of the parameter, where the C type alone does not say.
#   raw       an UnsafeMutableRawPointer a body writes at a byte offset, see "Typed access at a byte offset"
#   vec3_mut  an inout vec3_t for a `float *` Raven fills as three floats, see "A pointer out-param Raven indexes"
#   vec3_const  a vec3_t by value for a `vec3_t` Raven declares without const and the engine only reads, the form a `const vec3_t` has
#   out_string  an inout String, for a `const char **` the function sets to the token instead of walking
#   out_optional_string  an inout String?, for a `const char **` the function sets to a text or NULL, which a caller passes as a `char *` field
#   text_cursor  a TextCursor by value, for a `const char *` Raven passes as a cursor and returns advanced
#   fill_buffer  a `char *` a trap fills with no size beside it, given as ("fill_buffer", capacity) with the capacity Raven's
#                callers declare for the buffer, and the trap returns the String the same way a sized buffer does
#   float_array  an inout [Float] for a `float *` a body fills as a matrix of the counts beside it, or as a fixed count of floats
#   int_array  an [Int32]? by value for a read-only `int *` with a count beside it, and a caller's NULL is nil
#   int_array_mut  an inout [Int32] for an `int *` the body writes by index, the `int` twin of float_array
#   pointer_table  a Slots<View?> over a file-scope array of struct pointers, whose base a trap hands to the engine
#   key_path  a KeyPath<Entity, String?> for an `int` field offset Raven takes from `FOFS(field)`, which a call site spells `\.field`
#   int_value  an Int32 by value for a `const void *` a qsort comparator reads as `*(int *)`, so the comparator is `(Int32, Int32) -> Int32`
#   model_list  a Slots<qhandle_t>? for an `int *modelList` the engine reads as the array of model handles, the form a `qhandle_t *` has
#   out_opaque  an inout OpaquePointer? for a `void *` Raven's callers pass the address of a handle field to, the shape a `void **` already has
#   view      the optional view of the record named beside the kind, ("view", record), for a `void *` every caller fills with that record or NULL
#   float_mut  an inout Float for a `float *` of a stored function that the function reads and writes as one float, keyed by "record.field"
#   keyword_buckets  the bucket table of row indices and the row table beside it, form A of R53, for `keywordHash_t *table[]`
#   keyword_buckets_mut  the same pair inout, for the function that links a row into the buckets
#   row_index  an Int32 row index for a `keywordHash_t *` row pointer, form A of R53
#   opaque    an OpaquePointer? for a `byte *` buffer the body stores into a `byte *` field or hands on as a `void *`, the spelling of the field
#   bytes     a Slots<byte> for a `void *` or `byte *` of a host function that the body hands on as bytes, the row a host `byte *` has
#   word      an Int for an `int` that takes the pointer-wide word VM_Call returns
#   callback  the optional callback typealias of a view field for a function pointer the body stores into that field, the form of a function-pointer return
PARAMS = {
    # free_ppnode of huffman.cpp:59 takes the slot address that get_ppnode returned, the form of a `node_t **` field.
    ("free_ppnode", "ppnode"): "slot",
    ("COM_ParseString", "s"): "out_string",
    # String_Parse of ui_shared.c:607 sets `*out` to the token and never walks it.
    ("String_Parse", "out"): "out_string",
    # Both set `*out` to the String_Alloc text, which is NULL when the pool is full, and the callers pass the address of a `char *` field.
    ("PC_String_Parse", "out"): "out_optional_string",
    ("PC_Script_Parse", "out"): "out_optional_string",
    # A `char **` the function sets once to a string it owns, never walked, the same shape as the const one.
    ("G_SpawnString", "out"): "out_string",
    ("Q3_GetString", "value"): "out_string",
    ("SkipWhitespace", "data"): "text_cursor",
    ("trap_Bot_UpdateWaypoints", "wps"): "pointer_table",
    ("BG_ParseField", "ent"): "raw",
    ("BG_ValidateSkinForTeam", "colors"): "vec3_mut",
    ("G_SpawnVector", "out"): "vec3_mut",
    ("trap_SnapVector", "v"): "vec3_mut",
    # Sys_SnapVector of win_shared.cpp:41 steps `float *v` over the three floats of the vector that the G_SNAPVECTOR arm of sv_game.cpp hands it.
    ("Sys_SnapVector", "v"): "vec3_mut",
    # These bodies never write the vector, and an adopted file passes `&` there, so the parameter keeps inout.
    # g_exphysics.swift passes `&tr.endpos` to G_SetOrigin, and g_object.swift passes `&oldOrg` to G_MoverTouchPushTriggers.
    ("G_SetOrigin", "origin"): "vec3_mut",
    ("G_MoverTouchPushTriggers", "oldOrg"): "vec3_mut",
    # g_strap.swift is a hand file, and its three bolt-matrix wrappers take the scale inout.
    ("strap_G2API_GetBoltMatrix", "scale"): "vec3_mut",
    ("strap_G2API_GetBoltMatrix_NoReconstruct", "scale"): "vec3_mut",
    ("strap_G2API_GetBoltMatrix_NoRecNoRot", "scale"): "vec3_mut",
    ("Parse1DMatrix", "m"): "float_array",
    ("Parse2DMatrix", "m"): "float_array",
    ("Parse3DMatrix", "m"): "float_array",
    # Raven passes the four floats of the plane equation, `static float planeEq[4]` of G_SaberFaceCollisionCheck, ruled 2026-10-05.
    ("G_SabCol_CalcPlaneEq", "planeEq"): "float_array",
    ("G_SabCol_PointRelativeToPlane", "planeEq"): "float_array",
    ("G_RunExPhys", "g2Bolts"): "int_array",
    # Raven writes `twokeys[0] = twokeys[1] = -1` and `twokeys[count] = j` at ui_shared.c:5302, and his callers pass `int twokeys[2]`.
    ("Controls_GetKeyAssignment", "twokeys"): "int_array_mut",
    ("trap_SV_RegisterSharedMemory", "memory"): "raw",
    # Raven's callers declare `char GLAName[MAX_QPATH]` in g_client.c and `char GLAName[1024]` in NPC_spawn.c, and the trap takes the larger.
    # `char hitSurface[MAX_QPATH]` is the one size for the surface name.
    ("trap_G2API_GetGLAName", "fillBuf"): ("fill_buffer", "1024"),
    ("trap_G2API_GetSurfaceName", "fillBuf"): ("fill_buffer", "JKAShared.MAX_QPATH"),
    # PC_SourceWarning and PC_SourceError of ui_shared.c:385 and :407 declare `char filename[128]`, and the engine writes the file name into it.
    ("trap_PC_SourceFileAndLine", "filename"): ("fill_buffer", "128"),
    # A pointer to a table of records the body indexes, `table[i]`, crosses as the Slots over the table.
    ("GetIDForString", "table"): "table",
    ("GetStringForID", "table"): "table",
    ("BG_SiegeTranslateGenericTable", "table"): "table",
    # Raven's callers pass a `polyVert_t` array, `verts` of CG_AddMarks and `TRIverts` of CG_AddParticleToScene, and the engine reads numVerts records.
    ("trap_R_AddPolyToScene", "verts"): "table",
    ("trap_R_AddPolysToScene", "verts"): "table",
    # Raven declares `vec3_t org, vec3_t fwd` without const at cg_syscalls.c:626, :637, and :642.
    # The engine only reads both, FX_PlayEffect and FX_PlayEffectID at FXExport.cpp:18 and :38 hand them to CFxScheduler::PlayEffect.
    # cg_syscalls.c:874 and :880 declare `int *modelList`, and the engine reads it as the model list, G2_local.h:117.
    ("trap_G2API_GetBoneAnim", "modelList"): "model_list",
    ("trap_G2API_GetBoneFrame", "modelList"): "model_list",
    # bg_strap.h:23 forwards the same array to the game and the cgame trap.
    ("strap_G2API_GetBoneAnim", "modelList"): "model_list",
    ("trap_FX_PlayEffect", "org"): "vec3_const",
    ("trap_FX_PlayEffect", "fwd"): "vec3_const",
    ("trap_FX_PlayEffectID", "org"): "vec3_const",
    ("trap_FX_PlayEffectID", "fwd"): "vec3_const",
    ("trap_FX_PlayPortalEffectID", "org"): "vec3_const",
    ("trap_FX_PlayPortalEffectID", "fwd"): "vec3_const",
    # Raven's callers pass `FOFS(classname)`, `FOFS(targetname)`, `FOFS(target)`, and `FOFS(script_targetname)`, each a `char *` field.
    ("G_Find", "fieldofs"): "key_path",
    # Raven's two qsort comparators over an `int` array, `SortClients` at g_team.c:1089 and `SortRanks` at g_main.c:1624.
    # The hand qsort of bg_lib.swift takes `(Int32, Int32) -> Int32`.
    # Rulings A1 and D6 of 2026-10-11.
    ("SortClients", "a"): "int_value",
    ("SortClients", "b"): "int_value",
    ("SortRanks", "a"): "int_value",
    ("SortRanks", "b"): "int_value",
    # Raven declares `void *ghlInfo`, w_saber.c:6593 and g_turret_G2.c:135 pass `&ent->ghoul2`, and the engine casts the word to `CGhoul2Info_v **` at sv_gameapi.cpp:1590.
    # Raven hands the engine the address of `cg.sharedBuffer`, cg_main.c:3713, the BYTE_STORAGE_FIELDS row, as the game hands `gSharedBuffer`.
    ("trap_CG_RegisterSharedMemory", "memory"): "raw",
    # Raven casts `void *p` to `menuDef_t *` at cg_main.c:2858, and his callers pass `menuScoreboard` at cg_draw.c:6780 and NULL at cg_servercmds.c:68.
    ("CG_SetScoreSelection", "p"): ("view", "menuDef_t"),
    # The keyword hash of ui_shared.c:7347 and :7360 links rows by index, form A of R53, so the row table crosses beside the buckets.
    ("KeywordHash_Add", "table"): "keyword_buckets_mut",
    ("KeywordHash_Add", "key"): "row_index",
    ("KeywordHash_Find", "table"): "keyword_buckets",
    # Raven casts `void *p` to `menuDef_t *` at ui_shared.c:9881, and cg_newDraw.c:776 and :778 pass `cgs.capturedItem` or NULL.
    ("Display_MouseMove", "p"): ("view", "menuDef_t"),
    # Raven casts `void *p` to `scrollInfo_t *` at ui_shared.c:3833 and the four siblings, and the one caller passes `captureData`, which holds `&scrollInfo`.
    ("Scroll_TextScroll_AutoFunc", "p"): ("view", "scrollInfo_t"),
    ("Scroll_TextScroll_ThumbFunc", "p"): ("view", "scrollInfo_t"),
    ("Scroll_ListBox_AutoFunc", "p"): ("view", "scrollInfo_t"),
    ("Scroll_ListBox_ThumbFunc", "p"): ("view", "scrollInfo_t"),
    ("Scroll_Slider_ThumbFunc", "p"): ("view", "scrollInfo_t"),
    # Raven passes `&item->special`, one float, at ui_shared.c:2655, and CG_OwnerDrawHandleKey of cg_newDraw.c reads one float.
    ("displayContextDef_t.ownerDrawHandleKey", "special"): "float_mut",
    ("trap_G2API_RemoveGhoul2Models", "ghlInfo"): "out_opaque",
    ("trap_G2API_RemoveGhoul2Model", "ghlInfo"): "out_opaque",
    ("trap_G2API_HasGhoul2ModelOnIndex", "ghlInfo"): "out_opaque",
    # The bit buffer of huffman.cpp, the `byte *` the bodies index by `bloc >> 3`, is a Slots of bytes.
    # msg.cpp:193, :203, :248, and :254 pass `msg->data`, and Huff_Compress and Huff_Decompress pass a tail of `mbuf->data` or the `seq` local.
    ("Huff_putBit", "fout"): "bytes",
    ("Huff_getBit", "fin"): "bytes",
    ("add_bit", "fout"): "bytes",
    ("get_bit", "fin"): "bytes",
    ("Huff_Receive", "fin"): "bytes",
    ("Huff_offsetReceive", "fin"): "bytes",
    ("send", "fout"): "bytes",
    # Huff_Compress hands its `byte seq[65536]` local to Huff_transmit at huffman.cpp:387, and `seq` is a Slots of the storage class.
    ("Huff_transmit", "fout"): "bytes",
    # Com_BlockChecksum and Com_BlockChecksumKey hand `(unsigned char *)buffer` to MD4Update at md4.cpp:274 and :290.
    ("Com_BlockChecksum", "buffer"): "bytes",
    ("Com_BlockChecksumKey", "buffer"): "bytes",
    ("Huff_offsetTransmit", "fout"): "bytes",
    # VM_CallInterpreted of vm_interpreted.cpp:296 reads ten words through `int *args` and never writes them.
    ("VM_CallInterpreted", "args"): "int_array",
    # MSG_Init and MSG_InitOOB store `data` into the `byte *data` field of msg_t, msg.cpp:66 and :89, which the view spells as a Slots of bytes.
    ("MSG_Init", "data"): "bytes",
    ("MSG_InitOOB", "data"): "bytes",
    # MSG_WriteData reads the caller's bytes through `(byte *)data` at msg.cpp:301, and MSG_ReadData writes them at :552.
    ("MSG_WriteData", "data"): "bytes",
    ("MSG_ReadData", "data"): "bytes",
    # Netchan_Transmit hands `data` to MSG_WriteData as its `const void *` at net_chan.cpp:182, so it takes the same Slots of bytes.
    ("Netchan_Transmit", "data"): "bytes",
    # NET_OutOfBandData copies `format` into its message byte by byte at net_chan.cpp:597.
    ("NET_OutOfBandData", "format"): "bytes",
    # NET_SendPacket reads the first word of `data` at net_chan.cpp:534 and hands `data` on to NET_SendLoopPacket and Sys_SendPacket.
    # NET_SendLoopPacket copies `data` into the loopback message at net_chan.cpp:524, and Sys_SendPacket sends it at win_net.cpp:393.
    ("NET_SendPacket", "data"): "bytes",
    ("NET_SendLoopPacket", "data"): "bytes",
    ("Sys_SendPacket", "data"): "bytes",
    # FS_Read, FS_Read2, FS_Write, and FS_WriteFile of files_pc.cpp:1007 to :1079 and files_common.cpp:401 walk `byte *buf = (byte *)buffer`.
    # The CharBuf overloads beside them forward a `char` buffer through `withSlots`, the NET_SendPacket form.
    ("FS_Read", "buffer"): "bytes",
    ("FS_Read2", "buffer"): "bytes",
    ("FS_Write", "buffer"): "bytes",
    ("FS_WriteFile", "buffer"): "bytes",
    # Sys_StreamedRead of win_main.cpp:861 hands `buffer` to FS_Read, and FS_Read hands it to unzReadCurrentFile at files_pc.cpp:1068.
    ("Sys_StreamedRead", "buffer"): "bytes",
    # Sys_QueEvent stores `ptr` into `ev->evPtr` at win_main.cpp:1150, the field of kind `raw`.
    ("Sys_QueEvent", "ptr"): "raw",
    ("unzReadCurrentFile", "buf"): "bytes",
    # VM_ExplicitArgPtr takes the word VM_Call returns, sv_init.cpp:700 and sv_ccmds.cpp:326.
    ("VM_ExplicitArgPtr", "intValue"): "word",
    # VM_Create stores `systemCalls` into `vm->systemCall` at vm.cpp:506, and VM_Restart passes that field back at :408.
    ("VM_Create", "systemCalls"): "callback",
    # Sys_LoadDll of win_main.cpp:784 stores the module's vmMain through `entryPoint`, the address of `vm->entryPoint`,
    # and hands `systemcalls` to the module's dllEntry. The shell loads the library through jka_load_dll of CJKAHost.
    ("Sys_LoadDll", "entryPoint"): "raw",
    ("Sys_LoadDll", "systemcalls"): "opaque",
}

# Rule 20: a function with no caller in either tree stays as its stub, and the stub carries one note line that it is dead.
DEAD = {
    "CG_ParticleExplosion": "Raven calls this function from no file of either tree",
}

# Functions of the oracle the port leaves out. The stub carries the cite, Raven's line, and the reason, and no function.
NOT_PORTED = {
    "memmove": "the C library's, which no body of the module calls, and a Swift body moves bytes through CharBuf and a view's setter",
    "atof": "the VM's, which computes in float, and the DLL build links the C library's `atof`, which `JKAShared` holds",
    "vmMain": "the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5",
    "BotEntityInfo": "no caller in the module, and the botlib record it forwards belongs to the engine, which the module reaches through trap_AAS_EntityInfo alone. "
                     "A view over aas_entityinfo_t of be_aas.h is the fallback if a ported body calls it",
    # A trap no file of the module calls gets its shape when a module that calls it is generated.
    "trap_UnifyWhiteSpaces": "no caller in the game module, and its `char *` rewritten in place is shaped when a module that calls it is generated",
    "trap_AAS_TraceAreas": "no caller in the game module, and its arrays the engine fills are shaped when a module that calls it is generated",
    # bg_lib's qsort group, by the oracle names. The hand helpers `insertion` and `qsortSpan` hold parts of Raven's qsort body and have no oracle function.
    "swapfunc": "Raven's byte-swap qsort has no view form, and the hand port is generic over the element type",
    "med3": "Raven's byte-swap qsort has no view form, and the hand port is generic over the element type",
    "qsort": "Raven's byte-swap qsort has no view form, and the hand port is generic over the element type",
    # The module calls the C VM_DllSyscall of Sources/CJKAHost/jka_host.c, which hands the words to the host.
    "VM_DllSyscall": "the C function of Sources/CJKAHost/jka_host.c, because Swift cannot write a C variadic callee, and the module reaches it through dllEntry",
}

# Game functions and globals the shell's `vmMain` names, which cross the module line, so each is public. Rule 11 and ruling E1.
# The shell decodes the words of a command and calls the bare function, so the callee is public in its own logic file.
PUBLIC_NAMES = {
    # The commands of Raven's vmMain at g_main.c:515, in the order of the switch.
    "G_InitGame", "G_ShutdownGame", "ClientConnect", "ClientThink", "ClientUserinfoChanged", "ClientDisconnect", "ClientBegin",
    "ClientCommand", "G_RunFrame", "ConsoleCommand", "BotAIStartFrame", "G_ROFF_NotetrackCallback", "G_ParseSpawnVars",
    "G_SpawnGEntityFromSpawnVars", "Q3_PlaySound", "Q3_Set", "Q3_Lerp2Pos", "Q3_Lerp2Origin", "Q3_Lerp2Angles", "Q3_GetTag",
    "Q3_Lerp2Start", "Q3_Lerp2End", "Q3_Use", "Q3_Kill", "Q3_Remove", "Q3_Play", "Q3_GetFloat", "Q3_GetVector", "Q3_GetString",
    "G_SoundIndex", "GetIDForString", "NAV_ClearPathToPoint", "NPC_ClearLOS2", "NAVNEW_ClearPathBetweenPoints",
    "NAV_CheckNodeFailedForEnt", "G_EntIsUnlockedDoor", "G_EntIsDoor", "G_EntIsBreakable", "G_EntIsRemovableUsable",
    "CP_FindCombatPointWaypoints", "BG_GetItemIndexByTag",
    # The globals the decode reads: the entity table and the ICARUS shared buffer. `world` is hand code in g_local.swift.
    "g_entities", "gSharedBuffer",
}

# C library functions a .c file aliases, `#define sqrtf sqrt`, with the Swift signature the forwarder takes.
LIBC_FUNCTIONS = {"sqrt": ([("x", "Float")], "Float", "x.squareRoot()")}

# The Swift name of a C library function whose Foundation name Swift deprecates, so a body writes `abs` where Raven wrote `fabs`.
# Raven's `stricmp` is the platform's `strcasecmp`, and `Q_stricmp` gives the same zero test over ASCII, `CG_DrawVote` of cg_draw.c.
LIBC_SPELLINGS = {"fabs": "abs", "fabsf": "abs", "stricmp": "Q_stricmp"}

# Macros a platform defines or not, so a conditional that names one stays as Raven wrote it in the extracted header, and each platform build takes its own arm.
# PATH_MAX picks the arm of MAX_OSPATH at q_shared.h:394, and Windows has no PATH_MAX.
PLATFORM_MACROS = {"PATH_MAX"}

# Classes of the oracle that a C target names as a struct, because a C struct points at them and rule 12 keeps the copied header.
# A `fields` class is a C struct of its fields, and a `tag` class is a bare struct tag in forward.h, for a class C names behind a pointer alone.
# `clipMap_t.shaders` at cm_local.h:165 points at `CCMShader`, whose four methods are inline accessors, so the C struct leaves them out.
# `clipMap_t.landScape` at cm_local.h:210 points at the terrain class `CCMLandScape`, which C never reads, row S6.
C_STRUCT_CLASSES = {
    "CCMShader": ("fields", "oracle/codemp/qcommon/cm_local.h:77"),
    "CCMLandScape": ("tag", "oracle/codemp/qcommon/cm_landscape.h:135"),
    # `traceWork_t` is a C struct but for its two C++ `bool` fields, which C spells `_Bool`, row S7.
    "traceWork_t": ("fields", "oracle/codemp/qcommon/cm_local.h:238"),
}

# C targets whose copied headers include a C library header, as CJKASyscall includes <stdint.h>.
# `qfile_gut` of files.h:71 holds a `FILE *`, so CJKAMP_Ded includes <stdio.h>, and its parses take the include path of the SDK, row S3.
SDK_TARGETS = {"CJKAMP_Ded"}

# Header macros the port leaves out, with the reason the reexport carries instead of a marker.
NOT_PORTED_MACROS = {
    "MATERIALS": "a list of material names no body of the module names",
    "NAV_HEADER_ID": "a four-character constant no .c file of the module reads",
    "NODE_HEADER_ID": "a four-character constant no .c file of the module reads",
    # The host parse takes WinDed's PATH_SEP so the store of FS_ReplaceSeparators parses, and the body reads the hand constant of the platform that builds.
    "PATH_SEP": "the hand PATH_SEP of Sources/JKAMP_Ded/FileBackend.swift, the separator of the platform that builds",
}

# MARK: - The bg channel

# Functions bg reaches through hooks of their own, not through the channel. See rule 23.
OWN_HOOKS = {"Com_Error", "Com_Printf"}
# A function bg calls that another consumer defines, so no game definition can shape it. The entry names the game function whose
# signature it shares and the definition's cite. The game consumer installs nothing, so the trapping default names it at the first call.
EXTRA_HOOKS = {"CG_NewString": ("G_NewString", "oracle/codemp/cgame/cg_main.c:3344")}
# A game arm of a bg body under `#ifdef QAGAME` that reads the game's tables is one callback, R30 of the walk of 2026-10-05.
# The game defines the function by hand in Sources/JKAMP_GameLogic/bg_pmove_game.swift, and installBgChannel points the closure at it.
# name -> (the cite of Raven's arm, the parameters as (name, Swift type) pairs)
ARM_HOOKS = {
    "bgLandOnVehicle": ("oracle/codemp/game/bg_pmove.c:4234", [("entityNum", "Int32")]),
    "bgSetSolidHack": ("oracle/codemp/game/bg_pmove.c:4448", [("clientNum", "Int32")]),
}
# A cgame arm of a bg body that reads a cgame table reads it through one read callback per field, row C5 of the bg consumer docket.
# The game's install skips it, and the cgame install reads the field through the cgame's own views by the expression of the entry.
# name -> (the cite of Raven's read, the parameters as (name, Swift type, label) triples, the Swift return, the cgame install expression)
CGAME_READS = {
    "bgClientInfoInfoValid": ("oracle/codemp/game/bg_saber.c:4129", [("entityNum", "Int32", "of")], "Bool",
                              "cgs.clientinfo[Int(entityNum)].infoValid"),
    "bgClientInfoSaber": ("oracle/codemp/game/bg_saber.c:4131", [("entityNum", "Int32", "of"), ("index", "Int32", "at")], "JKAMP.SaberInfo",
                          "cgs.clientinfo[Int(entityNum)].saber[Int(index)]"),
    "bgCentNpcClient": ("oracle/codemp/game/bg_saber.c:4123", [("entityNum", "Int32", "of")], "Bool",
                        "cg_entities[Int(entityNum)].npcClient != nil"),
    "bgNpcClientInfoValid": ("oracle/codemp/game/bg_saber.c:4129", [("entityNum", "Int32", "of")], "Bool",
                             "cg_entities[Int(entityNum)].npcClient!.infoValid"),
    "bgNpcClientSaber": ("oracle/codemp/game/bg_saber.c:4131", [("entityNum", "Int32", "of"), ("index", "Int32", "at")], "JKAMP.SaberInfo",
                         "cg_entities[Int(entityNum)].npcClient!.saber[Int(index)]"),
}
# A function Raven compiles only under `#ifdef QAGAME` is a game function, R31. The game defines it by hand beside the arm hooks,
# and the bg body reaches it through the channel. name -> the cite of Raven's definition
QAGAME_ONLY = {"PM_CrashLandEffect": "oracle/codemp/game/bg_pmove.c:3684"}
# (function, parameter) pairs a ruling makes optional, because a caller passes a NULL the sweep cannot see. R33.
NULLABLE = {
    # Cvar_Register of cvar.cpp:889 tests `!vmCvar` at :893, because a module registers a cvar with no handle, the NULL rows of gameCvarTable.
    ("Cvar_Register", "vmCvar"),
    ("BG_UnrestrainedPitchRoll", "pVeh"),
    # G_UseTargets passes its optional activator, which g_mover.c:1752 passes as NULL, and `ent->target`, which Raven tests with `!string || !string[0]`.
    ("G_UseTargets2", "activator"),
    ("G_UseTargets2", "string"),
    # G_UseTargets2 passes its optional activator, and GlobalUse passes it on to the use callback, whose runUse helper takes an optional.
    ("GlobalUse", "activator"),
    # G_G2PlayerAngles of w_saber.c sets emplaced only when ps.emplacedIndex is non-zero and passes NULL otherwise, and the body tests it at bg_pmove.c:9235 and 9354.
    ("BG_G2PlayerAngles", "emplaced"),
    # target_random_use passes `self->target`, which SP_target_random does not require, and Q_stricmp returns -1 for a NULL at q_shared.c:901.
    # Ruling R9 of 2026-10-11.
    ("G_Find", "match"),
    # SiegeItemThink passes NULL to SiegeItemRespawnOnOriginalSpot at g_saga.c:1435, which passes it on, and the body tests it at g_saga.c:1344.
    ("SiegeItemRemoveOwner", "carrier"),
    # ClientSpawn passes the NULL of SelectSpectatorSpawnPoint at g_client.c:3727, and both bodies test it at g_utils.c:569 and :611.
    ("G_UseTargets2", "ent"),
    ("G_UseTargets", "ent"),
    # SP_waypoint_navgoal passes NULL as the owner at g_nav.c:1382, TAG_Add passes it on at g_misc.c:3042, and the body tests it at g_misc.c:2980.
    ("TAG_Find", "owner"),
    # PM_Weapon passes a NULL veh for every entity that is not a vehicle at bg_pmove.c:7362, and the body tests it at bg_pmove.c:5990.
    ("PM_DoChargedWeapons", "veh"),
    # NPC_FindEnemy passes the NULL of NPC_PickEnemyExt at NPC_utils.c:1454, and the body tests it at NPC_utils.c:1100.
    ("NPC_ValidEnemy", "ent"),
    # Q3_GetTag passes `ent->ownername` as it is at g_ICARUScb.c:961, and each body passes it on to TAG_Find, which tests it at g_misc.c:2980.
    ("TAG_GetOrigin", "owner"),
    ("TAG_GetAngles", "owner"),
    ("TAG_GetFlags", "owner"),
    # NPC_BSST_Attack passes `NPCInfo->group` as it is at NPC_AI_Stormtrooper.c:2531, and each body tests it, NPC_AI_Utils.c:701, :711, :722, and :986.
    ("AI_GroupUpdateEnemyLastSeen", "group"),
    ("AI_GroupUpdateClearShotTime", "group"),
    ("AI_GroupUpdateSquadstates", "group"),
    ("AI_GroupContainsEntNum", "group"),
    # G_RunFrame clears the NPC global at g_main.c:4001, G_AlertTeam passes it through NPC_ClearLOS2 at g_combat.c:1848, and the trace at NPC_senses.c:745 never reads it.
    ("G_ClearLOS2", "self"),
    ("G_ClearLOS", "self"),
    # The stored function of a view field takes the field's name after the record. Raven calls `DC->setColor(NULL)` at ui_shared.c:705, :782, :813, :870, and :877.
    ("displayContextDef_t.setColor", "v"),
    # Huff_addRef passes `tnode2->parent` at huffman.cpp:229, which is NULL when the new node is the root, and the body tests it at huffman.cpp:131.
    ("increment", "node"),
    # Com_RealTime tests `if (qtime)` at common.cpp:718, and the G_REAL_TIME arm of sv_game.cpp:679 passes the module's record.
    ("Com_RealTime", "qtime"),
}
# Files whose functions a bg body reaches directly, because they live in the shared module or in bg itself.
# The functions whose integer arithmetic is a generator or a hash, where C wraps at 32 bits and Swift's plain operators trap.
WRAPPING_ARITHMETIC = {"Q_rand", "Q_random", "Q_crandom", "rand", "srand", "irand", "flrand", "Q_irand", "Q_flrand", "Rand_Init", "Q_HashKey"}

# (trap, parameter) pairs of a view parameter that gets a second overload of the trap, which takes the view as optional.
# Raven hands the trap a NULL through a table row, which the NULL sweep cannot see at the call site.
# See row 4a of the game globals walk.
NIL_OVERLOADS = {
    ("trap_Cvar_Register", "cvar"): "the three rows of gameCvarTable in g_main.c with a NULL handle, gamename, gamedate, and sv_mapname",
    # The engine reads a size of -1 as the rewind of the entity string and returns before it touches the buffer, tr_bsp.cpp:1981.
    ("trap_GetEntityToken", "buffer"): "CG_ParseEntitiesFromString in cg_main.c, the call `trap_GetEntityToken(NULL, -1)` that rewinds the entity string",
}

# The traps whose buffer holds a NUL-separated list, which a caller walks past the first NUL, so the trap returns every byte as a CharBuf.
LIST_TRAPS = {"trap_FS_GetFileList"}

SHARED_STEMS = {"q_shared", "q_math", "g_syscalls", "g_strap"}

# MARK: - C storage beside the extracted headers

# Hand-written headers a target's umbrella includes after the extracted ones, one per file of C storage under Sources/<Target>/.
# See "Raven's tables as C storage". merge.py keeps these files across a rewrite of the target.
# `bg_tables.c` and `g_tables.c` are not among them: tables.py writes them, and it runs after the merge.
# g_types.h holds the structs Raven defines inside a .c file, so a view can bind over them. See "A struct Raven defines inside a .c file".
# cg_types.h holds the six of the cgame the same way.
# g_tables.h declares the six game tables of g_tables.c, ruling E2.
# ded_types.h holds the structs the host defines inside a .cpp file, and ded_tables.h declares the four netField tables of ded_tables.c.
HAND_HEADERS = {"CJKAMP": ["bg_tables.h"], "CJKAMP_Game": ["g_types.h", "g_tables.h"], "CJKAMP_CGame": ["cg_types.h", "cg_tables.h"],
                "CJKAMP_Ded": ["ded_types.h", "ded_tables.h"]}
HAND_FILES = {"CJKAMP": ["include/bg_tables.h"], "CJKAMP_Game": ["include/g_types.h", "include/g_tables.h"],
              "CJKAMP_CGame": ["include/cg_types.h", "include/cg_tables.h"],
              "CJKAMP_Ded": ["include/ded_types.h", "include/ded_tables.h"]}

# MARK: - Header preludes

# Oracle header -> (the .c file, first line, last line) of the text a header needs before it, which the .c file writes before its include.
# The header parse writes that slice into its synthetic translation unit before the header's include.
# The .c enum test then keeps the enum of the slice in the constants file of its .c file.
# interpreter.h opens its token enum at `TK_USERDEF`, which only the enum at g_ICARUScb.c:31-44 declares, as Raven's comment at interpreter.h:13 says.
# The slice starts at the enum and not at the comment on line 20, because the `#ifndef` pair around the enum closes on lines 45 and 46.
HEADER_PRELUDES = {
    "codemp/icarus/interpreter.h": ("codemp/game/g_ICARUScb.c", 31, 44),
}
