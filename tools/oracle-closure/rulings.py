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
    # The view takes another name than the C struct, because the navigator's C++ class `CNode` of navigator.h:70 keeps Raven's name in the logic target, row C.
    "cNode_t": ("CmNode", "CJKAMP_Ded"),
    "cLeaf_t": ("CLeaf", "CJKAMP_Ded"),
    "cPatch_t": ("CPatch", "CJKAMP_Ded"),
    # The view takes another name than the C struct, because the terrain's C++ class `CArea` of cm_landscape.h:42 keeps Raven's name, the cNode_t form.
    "cArea_t": ("CmArea", "CJKAMP_Ded"),
    # The view takes another name than the C struct, because the view target imports the C struct under its own name.
    "CCMShader": ("CmShader", "CJKAMP_Ded"),
    # The loaders of cm_load.cpp read the BSP file through these disk records of qfiles.h, at `cmod_base + l->fileofs`.
    "dheader_t": ("Dheader", "CJKAMP_Ded"),
    # qfiles.h is a header of the tree, and lump_t is the one disk record of it the merge places in CJKAMP.
    "lump_t": ("Lump", "CJKAMP"),
    # CMod_LoadPatches of cm_load.cpp:523 reads the vertex lump as `drawVert_t`, a disk record of qfiles.h the merge places in CJKAMP.
    "drawVert_t": ("DrawVert", "CJKAMP"),
    "dshader_t": ("Dshader", "CJKAMP_Ded"),
    "dmodel_t": ("Dmodel", "CJKAMP_Ded"),
    "dnode_t": ("Dnode", "CJKAMP_Ded"),
    "dleaf_t": ("Dleaf", "CJKAMP_Ded"),
    "dplane_t": ("Dplane", "CJKAMP_Ded"),
    "dbrush_t": ("Dbrush", "CJKAMP_Ded"),
    "dbrushside_t": ("Dbrushside", "CJKAMP_Ded"),
    "dsurface_t": ("Dsurface", "CJKAMP_Ded"),
    "mapVert_t": ("MapVert", "CJKAMP_Ded"),
    # The sector tree of sv_world.cpp:48, `sv_worldSectors` of :58, and the two stack records of SV_AreaEntities and SV_Trace at :359 and :440.
    # Raven defines the three inside the .cpp file, and ded_types.h carries them into the host target, the cmd_t form.
    "worldSector_t": ("WorldSector", "CJKAMP_Ded"),
    "areaParms_t": ("AreaParms", "CJKAMP_Ded"),
    "moveclip_t": ("Moveclip", "CJKAMP_Ded"),
    # SV_BuildClientSnapshot declares the entity list of sv_snapshot.cpp:246 on its stack, and SV_AddEntToSnapshot fills it.
    "snapshotEntityNumbers_t": ("SnapshotEntityNumbers", "CJKAMP_Ded"),
    # The debug polygons of sv_bot.cpp:8 and :16, the Z_Malloc table of SV_BotInitBotLib.
    "bot_debugpoly_t": ("BotDebugpoly", "CJKAMP_Ded"),
    # `sv_siegePersData` of sv_game.cpp:454 and the waypoint table `gWPArray` of sv_bot.cpp:23 hold the records of q_shared.h the game views.
    "siegePers_t": ("SiegePers", "CJKAMP"),
    "wpobject_t": ("Wpobject", "CJKAMP"),
    # The trace and box records of cm_local.h:230 to :274 and the grid of cm_patch.h:117, which CM_Trace, CM_BoxLeafnums, and CM_GeneratePatchCollide declare on their stacks.
    "traceWork_t": ("TraceWork", "CJKAMP_Ded"),
    "sphere_t": ("Sphere", "CJKAMP_Ded"),
    "leafList_t": ("LeafList", "CJKAMP_Ded"),
    "cGrid_t": ("CGrid", "CJKAMP_Ded"),
    # The renderer records of tr_local.h and the model records of qfiles.h and mdx_format.h, row TR1 of the tr round and rows G3, G2B4, and G2B5 of the Ghoul2 rounds.
    # `tr` of tr_main.cpp:15, `backEnd` and `backEndData` of tr_backend.cpp:20 and :21, and `shader` and `stages` of tr_shader.cpp:100 and :101 hold them.
    "trGlobals_t": ("TrGlobals", "CJKAMP_Ded"),
    "backEndState_t": ("BackEndState", "CJKAMP_Ded"),
    "backEndData_t": ("BackEndData", "CJKAMP_Ded"),
    "model_t": ("Model", "CJKAMP_Ded"),
    "shader_t": ("Shader", "CJKAMP_Ded"),
    "shaderStage_t": ("ShaderStage", "CJKAMP_Ded"),
    "texModInfo_t": ("TexModInfo", "CJKAMP_Ded"),
    "waveForm_t": ("WaveForm", "CJKAMP_Ded"),
    "skin_t": ("Skin", "CJKAMP_Ded"),
    "skinSurface_t": ("SkinSurface", "CJKAMP_Ded"),
    "image_t": ("Image", "CJKAMP_Ded"),
    "trRefEntity_t": ("TrRefEntity", "CJKAMP_Ded"),
    "md3Header_t": ("Md3Header", "CJKAMP_Ded"),
    "md3Tag_t": ("Md3Tag", "CJKAMP_Ded"),
    "md3Frame_t": ("Md3Frame", "CJKAMP_Ded"),
    "mdxmHeader_t": ("MdxmHeader", "CJKAMP_Ded"),
    "mdxaHeader_t": ("MdxaHeader", "CJKAMP_Ded"),
    "mdxmSurface_t": ("MdxmSurface", "CJKAMP_Ded"),
    "mdxmSurfHierarchy_t": ("MdxmSurfHierarchy", "CJKAMP_Ded"),
    "mdxmHierarchyOffsets_t": ("MdxmHierarchyOffsets", "CJKAMP_Ded"),
    "mdxmLOD_t": ("MdxmLOD", "CJKAMP_Ded"),
    # ServerLoadMDXM and R_LoadMDXM step past the offset table of a LOD by `sizeof(mdxmLODSurfOffset_t)`, tr_model.cpp:912 and tr_ghoul2.cpp:4953.
    "mdxmLODSurfOffset_t": ("MdxmLODSurfOffset", "CJKAMP_Ded"),
    "mdxmVertex_t": ("MdxmVertex", "CJKAMP_Ded"),
    "mdxaSkel_t": ("MdxaSkel", "CJKAMP_Ded"),
    "mdxaSkelOffsets_t": ("MdxaSkelOffsets", "CJKAMP_Ded"),
    # The Ghoul2 matrices of tr_ghoul2.cpp:128 to :137 and the ragdoll table of G2_bones.cpp:1216 hold the record of q_shared.h the game views.
    "mdxaBone_t": ("MdxaBone", "CJKAMP"),
    # The game hands these records of q_shared.h to the Ghoul2 API through its traps, G2API_SetBoneIKState, G2API_IKMove, and G2API_AddSkinGore
    # of G2_API.cpp:1613, :1619, and :2569, and G2_SetBoneIKState hands a `sharedRagDollUpdateParams_t` local to G2_InitIK at G2_bones.cpp:4708.
    # The game views stand in JKAMP, the mdxaBone_t row.
    "sharedSetBoneIKStateParams_t": ("SharedSetBoneIKStateParams", "CJKAMP"),
    "sharedIKMoveParams_t": ("SharedIKMoveParams", "CJKAMP"),
    "sharedRagDollUpdateParams_t": ("SharedRagDollUpdateParams", "CJKAMP"),
    "SSkinGoreData": ("SkinGoreData", "CJKAMP"),
    # The collision records of G2API_CollisionDetect and QsortDistance of G2_API.cpp:1993, row G4.
    # The game's view stands in JKAMP_Game, which the host cannot import, so the host has its own, the form of the cgame row.
    "CollisionRecord_t": ("CollisionRecord", "CJKAMP_Ded"),
    # Raven defines these inside a .cpp file, and ded_types.h carries them into the host target, the cmd_t form.
    # `mhHashTable` of tr_model.cpp:36, `ragEffectors` of G2_bones.cpp:1217, the resample records of tr_image.cpp:2338, and `r_vidModes` of tr_init.cpp:465.
    "modelHash_t": ("ModelHash", "CJKAMP_Ded"),
    # The view takes another name than the C struct, because the view target imports the C struct under its own name, the CCMShader form.
    "SRagEffector": ("RagEffector", "CJKAMP_Ded"),
    # `static SVertexTemp GoreVerts[MAX_GORE_VERTS]` of G2_misc.cpp:793, which the gore bodies index, row R10. The SRagEffector form of the name.
    "SVertexTemp": ("VertexTemp", "CJKAMP_Ded"),
    "contrib_t": ("Contrib", "CJKAMP_Ded"),
    "contrib_list_t": ("ContribList", "CJKAMP_Ded"),
    "vidmode_t": ("Vidmode", "CJKAMP_Ded"),
    # The botlib edge of botlib.h:93 to :422, row B1: `be_botlib_export` and `botimport` of be_interface.cpp and `botlib_export` of sv_game.cpp.
    # botlib.h is a header of the game parse, so ded_types.h holds a copy of the records, the form of row W1.
    "botlib_export_t": ("BotlibExport", "CJKAMP_Ded"),
    "botlib_import_t": ("BotlibImport", "CJKAMP_Ded"),
    "bot_input_t": ("BotInput", "CJKAMP_Ded"),
    "bsp_trace_t": ("BspTrace", "CJKAMP_Ded"),
    "bot_entitystate_t": ("BotEntitystate", "CJKAMP_Ded"),
    # The botlib records of its own headers, its .cpp files, and the game headers it reads, rows D1 to D5 of the ninth batch.
    # ded_types.h holds a copy of each, the form of row B1, because the host entry list reads no botlib header, ruling T2.
    # The records of the game headers be_aas.h, be_ai_goal.h, be_ai_move.h, be_ai_chat.h, and be_ai_weap.h.
    "aas_trace_t": ("AasTrace", "CJKAMP_Ded"),
    "aas_entityinfo_t": ("AasEntityinfo", "CJKAMP_Ded"),
    "aas_areainfo_t": ("AasAreainfo", "CJKAMP_Ded"),
    "aas_clientmove_t": ("AasClientmove", "CJKAMP_Ded"),
    "aas_altroutegoal_t": ("AasAltroutegoal", "CJKAMP_Ded"),
    "aas_predictroute_t": ("AasPredictroute", "CJKAMP_Ded"),
    "bot_goal_t": ("BotGoal", "CJKAMP_Ded"),
    "bot_initmove_t": ("BotInitmove", "CJKAMP_Ded"),
    "bot_moveresult_t": ("BotMoveresult", "CJKAMP_Ded"),
    "bot_avoidspot_t": ("BotAvoidspot", "CJKAMP_Ded"),
    "bot_consolemessage_t": ("BotConsolemessage", "CJKAMP_Ded"),
    "bot_matchvariable_t": ("BotMatchvariable", "CJKAMP_Ded"),
    "bot_match_t": ("BotMatch", "CJKAMP_Ded"),
    "projectileinfo_t": ("Projectileinfo", "CJKAMP_Ded"),
    "weaponinfo_t": ("Weaponinfo", "CJKAMP_Ded"),
    # The AAS world of be_aas_def.h:183, `aasworld` of be_aas_main.cpp:30 and `aassettings` of be_aas_move.cpp:29, and the disk records of aasfile.h, row D2.
    "aas_t": ("Aas", "CJKAMP_Ded"),
    "aas_settings_t": ("AasSettings", "CJKAMP_Ded"),
    "aas_header_t": ("AasHeader", "CJKAMP_Ded"),
    "aas_lump_t": ("AasLump", "CJKAMP_Ded"),
    "aas_bbox_t": ("AasBbox", "CJKAMP_Ded"),
    "aas_reachability_t": ("AasReachability", "CJKAMP_Ded"),
    "aas_areasettings_t": ("AasAreasettings", "CJKAMP_Ded"),
    "aas_portal_t": ("AasPortal", "CJKAMP_Ded"),
    "aas_cluster_t": ("AasCluster", "CJKAMP_Ded"),
    "aas_plane_t": ("AasPlane", "CJKAMP_Ded"),
    "aas_edge_t": ("AasEdge", "CJKAMP_Ded"),
    "aas_face_t": ("AasFace", "CJKAMP_Ded"),
    "aas_area_t": ("AasArea", "CJKAMP_Ded"),
    "aas_node_t": ("AasNode", "CJKAMP_Ded"),
    "aas_link_t": ("AasLink", "CJKAMP_Ded"),
    "bsp_link_t": ("BspLink", "CJKAMP_Ded"),
    "bsp_entdata_t": ("BspEntdata", "CJKAMP_Ded"),
    "aas_entity_t": ("AasEntity", "CJKAMP_Ded"),
    "aas_routingcache_t": ("AasRoutingcache", "CJKAMP_Ded"),
    "aas_routingupdate_t": ("AasRoutingupdate", "CJKAMP_Ded"),
    "aas_reversedlink_t": ("AasReversedlink", "CJKAMP_Ded"),
    "aas_reversedreachability_t": ("AasReversedreachability", "CJKAMP_Ded"),
    "aas_reachabilityareas_t": ("AasReachabilityareas", "CJKAMP_Ded"),
    # The script and precompiler records of l_script.h and l_precomp.h, row D5, and the libvar record of l_libvar.h, row D8.
    "punctuation_t": ("Punctuation", "CJKAMP_Ded"),
    "token_t": ("Token", "CJKAMP_Ded"),
    "script_t": ("Script", "CJKAMP_Ded"),
    "define_t": ("Define", "CJKAMP_Ded"),
    "indent_t": ("Indent", "CJKAMP_Ded"),
    "source_t": ("Source", "CJKAMP_Ded"),
    "libvar_t": ("Libvar", "CJKAMP_Ded"),
    # The field tables of l_struct.h, row D19, the weights of be_ai_weight.h, and the globals of be_interface.h, row D9.
    "fielddef_t": ("Fielddef", "CJKAMP_Ded"),
    "structdef_t": ("Structdef", "CJKAMP_Ded"),
    "fuzzyseperator_t": ("Fuzzyseperator", "CJKAMP_Ded"),
    "weight_t": ("Weight", "CJKAMP_Ded"),
    "weightconfig_t": ("Weightconfig", "CJKAMP_Ded"),
    "botlib_globals_t": ("BotlibGlobals", "CJKAMP_Ded"),
    # The records Raven defines inside a botlib .cpp file, row D4, and `bspworld` of be_aas_bspq3.cpp:70 and `logfile` of l_log.cpp:33.
    "bsp_t": ("Bsp", "CJKAMP_Ded"),
    "bsp_entity_t": ("BspEntity", "CJKAMP_Ded"),
    "bsp_epair_t": ("BspEpair", "CJKAMP_Ded"),
    "rgb_t": ("Rgb", "CJKAMP_Ded"),
    "aas_lreachability_t": ("AasLreachability", "CJKAMP_Ded"),
    "aas_tracestack_t": ("AasTracestack", "CJKAMP_Ded"),
    "aas_linkstack_t": ("AasLinkstack", "CJKAMP_Ded"),
    "routecacheheader_t": ("Routecacheheader", "CJKAMP_Ded"),
    "optimized_t": ("Optimized", "CJKAMP_Ded"),
    "midrangearea_t": ("Midrangearea", "CJKAMP_Ded"),
    "bot_characteristic_t": ("BotCharacteristic", "CJKAMP_Ded"),
    "bot_character_t": ("BotCharacter", "CJKAMP_Ded"),
    "bot_chatmessage_t": ("BotChatmessage", "CJKAMP_Ded"),
    "bot_chattype_t": ("BotChattype", "CJKAMP_Ded"),
    "bot_chat_t": ("BotChat", "CJKAMP_Ded"),
    "bot_randomstring_t": ("BotRandomstring", "CJKAMP_Ded"),
    "bot_randomlist_t": ("BotRandomlist", "CJKAMP_Ded"),
    "bot_synonym_t": ("BotSynonym", "CJKAMP_Ded"),
    "bot_synonymlist_t": ("BotSynonymlist", "CJKAMP_Ded"),
    "bot_matchstring_t": ("BotMatchstring", "CJKAMP_Ded"),
    "bot_matchpiece_t": ("BotMatchpiece", "CJKAMP_Ded"),
    "bot_matchtemplate_t": ("BotMatchtemplate", "CJKAMP_Ded"),
    "bot_replychatkey_t": ("BotReplychatkey", "CJKAMP_Ded"),
    "bot_replychat_t": ("BotReplychat", "CJKAMP_Ded"),
    "bot_stringlist_t": ("BotStringlist", "CJKAMP_Ded"),
    "bot_chatstate_t": ("BotChatstate", "CJKAMP_Ded"),
    "bot_ichatdata_t": ("BotIchatdata", "CJKAMP_Ded"),
    "maplocation_t": ("Maplocation", "CJKAMP_Ded"),
    "campspot_t": ("Campspot", "CJKAMP_Ded"),
    "levelitem_t": ("Levelitem", "CJKAMP_Ded"),
    "iteminfo_t": ("Iteminfo", "CJKAMP_Ded"),
    "itemconfig_t": ("Itemconfig", "CJKAMP_Ded"),
    "bot_goalstate_t": ("BotGoalstate", "CJKAMP_Ded"),
    "bot_movestate_t": ("BotMovestate", "CJKAMP_Ded"),
    "weaponconfig_t": ("Weaponconfig", "CJKAMP_Ded"),
    "bot_weaponstate_t": ("BotWeaponstate", "CJKAMP_Ded"),
    "logfile_t": ("Logfile", "CJKAMP_Ded"),
    "operator_t": ("Operator", "CJKAMP_Ded"),
    "value_t": ("Value", "CJKAMP_Ded"),
    # PC_ReadTokenHandle of l_precomp.cpp:3253 fills the record of q_shared.h the game views, row D17, the qtime_t form.
    "pc_token_t": ("PcToken", "CJKAMP"),
    # The model records of mdx_format.h and qfiles.h that the bone path and the bolts read, rows X4, X6, X10, and R6 of docket 10, the mdx rows above.
    # UnCompressBone reads the compressed bone pool at tr_ghoul2.cpp:1160, G2_GetBonePoolIndex reads the index table at :1152,
    # G2_ProcessSurfaceBolt2 reads the triangles of a surface at :2895, and the md3 loader reads the surfaces of an `.md3` model.
    "mdxaCompQuatBone_t": ("MdxaCompQuatBone", "CJKAMP_Ded"),
    "mdxaIndex_t": ("MdxaIndex", "CJKAMP_Ded"),
    "mdxmTriangle_t": ("MdxmTriangle", "CJKAMP_Ded"),
    "md3Surface_t": ("Md3Surface", "CJKAMP_Ded"),
    # The named union of be_ai_char.cpp:39 that `bot_characteristic_t.value` holds, the `qfile_gut` row, row X22 of docket 10.
    "cvalue": ("Cvalue", "CJKAMP_Ded"),
    # GetAutomapSymbol of RM_Manager.cpp:418 returns the record of client.h:143, which ded_types.h copies, row X41 of docket 10.
    "rmAutomapSymbol_t": ("RmAutomapSymbol", "CJKAMP_Ded"),
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
    # Each block of the download window holds MAX_DOWNLOAD_BLKSIZE bytes, the Z_Malloc of sv_client.cpp:1158.
    ("client_t", "downloadBlocks"): "MAX_DOWNLOAD_BLKSIZE",
    # be_ai_char.cpp:57 declares `bot_characteristic_t c[1]` with the comment "variable sized", and BotLoadCharacterFromFile allocates
    # MAX_CHARACTERISTICS of them at :211, row D12 shape 9 of the ninth batch.
    ("bot_character_t", "c"): "MAX_CHARACTERISTICS",
    # be_aas_def.h:146 declares `unsigned short int traveltimes[1]`, and AAS_AllocRoutingCache sizes the block at be_aas_route.cpp:729.
    # No macro bounds it, so the row names no macro and the count is the widest, the form of `areaParms_t.list`, row N7.
    ("aas_routingcache_t", "traveltimes"): None,
    # The mdx records of mdx_format.h:179, :194, :211, :378, and :395 declare `[1]` with the comment "variable sized",
    # and the model file gives the count, `numSurfaces`, `numBones`, or `numChildren`. Row R1 of the second G2_bones round, the `traveltimes` row.
    ("mdxmHierarchyOffsets_t", "offsets"): None,
    ("mdxmSurfHierarchy_t", "childIndexes"): None,
    ("mdxmLODSurfOffset_t", "offsets"): None,
    ("mdxaSkelOffsets_t", "offsets"): None,
    ("mdxaSkel_t", "children"): None,
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
    # The directive tables of l_precomp.cpp:2535 and :2648 hold the address of a parse function in each row, the commandList form, row D11.
    "directives": "[DirectiveRow]",
    "dollardirectives": "[DirectiveRow]",
    "itemParseKeywords": "[KeywordHashRow]",
    "menuParseKeywords": "[KeywordHashRow]",
    "itemParseKeywordHash": "[Int32?]",
    "menuParseKeywordHash": "[Int32?]",
    # A file-scope instance of a C++ class of CXX_CLASSES is a hand property of the state object, and the stub forwards it,
    # the form of `TheStringPackage` at stringed_ingame.swift:124. A table of class pointers and a `std::` container are hand tables, rule 17.
    "theROFFSystem": "CROFFSystem",
    "navigator": "CNavigator",
    "gSequencers": "[CSequencer?]",
    "gTaskManagers": "[CTaskManager?]",
    "iICARUS": "ICARUS_Instance?",
    # The `std::map` globals of GameInterface.cpp:17 and :18, Q3_Registers.cpp:9 to :11, and navigator.cpp:1687, rows 1, 3, and 8 of the icarus round.
    "ICARUS_BufferList": "bufferlist_t",
    "ICARUS_EntList": "entlist_t",
    "varStrings": "[String: String]",
    "varFloats": "[String: Float]",
    "varVectors": "[String: String]",
    "CheckedNodes": "[Int32: JKAShared.byte]",
    # The Ghoul2 statics of G2_API.cpp:44 and :477, G2_bones.cpp:1218 and :1241, and G2_misc.cpp:35, :36, and :125, rows G1, G2, G2B2, and G2B3.
    "g_G2AllocTrack": "[CGhoul2Info_v?]",
    "singleton": "Ghoul2InfoArray?",
    "ragBoneData": "[boneInfo_t?]",
    "rag": "[boneInfo_t?]",
    "GoreRecords": "[Int32: GoreTextureCoordinates]",
    "GoreTagsTemp": "[[Int32]: Int32]",
    "GoreSets": "[Int32: CGoreSet]",
    # `CachedModels_t *CachedModels` of tr_model.cpp:68 is a `map<sstring_t, CachedEndianedModelBinary_t> *`, row TR2.
    "CachedModels": "[String: CachedEndianedModelBinary_t]?",
    # `char **shaderTextHashTable[MAX_SHADERTEXT_HASH]` of tr_shader.cpp:109 holds cursors into `s_shaderText`, row TR7.
    "shaderTextHashTable": "[[TextCursor]]",
    # The heap of the Ghoul2 vertices, tr_init.cpp:1305 and sv_init.cpp:885, row S1 of the sv-core round.
    "G2VertSpaceServer": "CMiniHeap?",
    "CMiniHeap_singleton": "CMiniHeap",
    # The nine cycle timers of tr_ghoul2.cpp:42 to :50, row G2B8 and the Com_Frame timer of common.cpp:1598.
    "G2PerformanceTimer_RenderSurfaces": "timing_c",
    "G2PerformanceTimer_R_AddGHOULSurfaces": "timing_c",
    "G2PerformanceTimer_G2_TransformGhoulBones": "timing_c",
    "G2PerformanceTimer_G2_ProcessGeneratedSurfaceBolts": "timing_c",
    "G2PerformanceTimer_ProcessModelBoltSurfaces": "timing_c",
    "G2PerformanceTimer_G2_ConstructGhoulSkeleton": "timing_c",
    "G2PerformanceTimer_RB_SurfaceGhoul": "timing_c",
    "G2PerformanceTimer_G2_SetupModelPointers": "timing_c",
    "G2PerformanceTimer_PreciseFrame": "timing_c",
    # The ICARUS game table of Q3_Interface.cpp:32, which Interface_Init fills, and the random mission manager of RM_Manager.cpp:16 and :23.
    "interface_export": "interface_export_t",
    "TheRandomMissionManager": "CRMManager?",
    "mCurObjective": "CRMObjective?",
}

# File-scope character arrays whose address the engine holds, so each one is one zeroed byte allocation on the storage class, not a `CharBuf`.
# `gSharedBuffer` of g_main.c goes to the engine through `trap_SV_RegisterSharedMemory`, and vmMain reads the ICARUS views at its base.
# See "The post-spine walk", row P1, and the zeroed storage rule of docs/transcription.md.
# `cmd_text_buf` of cmd_common.cpp is the buffer `cmd_text.data` points at, cmd_common.cpp:56, so its `byte` elements read as a Slots.
# `sys_packetReceived` of win_main.cpp:1116 is the buffer of the message that Sys_GetEvent hands MSG_Init at win_main.cpp:1198, the cmd_text_buf form.
# `int tempDependents[MAX_BONES_RAG]` of G2_bones.cpp:1219 goes to G2_GetBoneDependents at :4112 and :4355, which fills it and steps it, row R2.
# An `int` array of the ruling is a Slots of Int32, the form of the `int` locals of BYTE_STORAGE_LOCALS.
BYTE_STORAGE_VARS = {"gSharedBuffer", "cmd_text_buf", "sys_packetReceived", "tempDependents"}
# File-scope record pointers whose address a body takes as a slot, a pointer table of one slot on the storage class, row F10 ratified 2026-11-10.
# FS_ReorderPurePaks of files_pc.cpp:2458 walks `searchpath_t **p_insert_index = &fs_searchpaths` and stores through it.
POINTER_SLOT_VARS = {"fs_searchpaths"}
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
    # `byte msgBuffer[MAX_MSGLEN]` of SV_SendClientGameState and SV_SendClientMapChange, and `byte msg_buf[MAX_MSGLEN]` of SV_SendClientSnapshot,
    # go to MSG_Init at sv_client.cpp:705 and :827 and sv_snapshot.cpp:724.
    ("msgBuffer", "SV_SendClientGameState"): ("SV_SendClientGameState",),
    ("msgBuffer", "SV_SendClientMapChange"): ("SV_SendClientMapChange",),
    ("msg_buf", "SV_SendClientSnapshot"): ("SV_SendClientSnapshot",),
    # `int touch[MAX_GENTITIES]` of SV_PointContents and `int leafs[MAX_TOTAL_ENT_LEAFS]` of SV_LinkEntity go to the `int *` lists
    # of SV_AreaEntities and CM_BoxLeafnums at sv_world.cpp:883 and :280.
    ("touch", "SV_PointContents"): ("SV_PointContents",),
    ("leafs", "SV_LinkEntity"): ("SV_LinkEntity",),
    # `static int touchlist[MAX_GENTITIES]` of SV_ClipMoveToEntities goes to SV_AreaEntities at sv_world.cpp:532, row SV2.
    ("touchlist", "SV_ClipMoveToEntities"): ("SV_ClipMoveToEntities",),
    # `int leafs[MAX_POSITION_LEAFS]` of CM_PositionTest goes to the `int *` list of `leafList_t` at cm_trace.cpp:457, row R2.
    ("leafs", "CM_PositionTest"): ("CM_PositionTest",),
    # The botlib locals a caller hands to a list parameter of row D16, the rows `touch` and `leafs` for `int` and `p` for `vec3_t`.
    # AAS_ConnectedAreas hands `connectedareas` to AAS_ConnectedAreas_r at be_aas_cluster.cpp:713,
    # and AAS_CheckAreaForPossiblePortals hands its area lists to AAS_ConnectedAreas and AAS_CanMergeAreas at :861 and :863.
    ("connectedareas", "AAS_ConnectedAreas"): ("AAS_ConnectedAreas",),
    ("areanums", "AAS_CheckAreaForPossiblePortals"): ("AAS_CheckAreaForPossiblePortals",),
    ("frontareanums", "AAS_CheckAreaForPossiblePortals"): ("AAS_CheckAreaForPossiblePortals",),
    ("backareanums", "AAS_CheckAreaForPossiblePortals"): ("AAS_CheckAreaForPossiblePortals",),
    # The `vec3_t points[]` locals of AAS_ShowPolygon at be_aas_debug.cpp:369 and of AAS_TraceAreas, and the edge vertices
    # of AAS_FindFaceReachabilities at be_aas_reach.cpp:3395 to :3401.
    ("points", "AAS_ShowFacePolygon"): ("AAS_ShowFacePolygon",),
    ("points", "AAS_ClientMovementPrediction"): ("AAS_ClientMovementPrediction",),
    ("points", "AAS_Reachability_FuncBobbing"): ("AAS_Reachability_FuncBobbing",),
    ("points", "BotFuzzyPointReachabilityArea"): ("BotFuzzyPointReachabilityArea",),
    ("points", "BotReachabilityArea"): ("BotReachabilityArea",),
    ("start_edgeverts", "AAS_Reachability_FuncBobbing"): ("AAS_Reachability_FuncBobbing",),
    ("end_edgeverts", "AAS_Reachability_FuncBobbing"): ("AAS_Reachability_FuncBobbing",),
    # The `int areas[]` locals of the eleven callers of AAS_TraceAreas, whose `areas` the body indexes, be_aas_sample.cpp:752.
    ("areas", "AAS_ClientMovementPrediction"): ("AAS_ClientMovementPrediction",),
    ("areas", "AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge"): ("AAS_Reachability_Step_Barrier_WaterJump_WalkOffLedge",),
    ("areas", "AAS_Reachability_Jump"): ("AAS_Reachability_Jump",),
    ("areas", "AAS_Reachability_FuncBobbing"): ("AAS_Reachability_FuncBobbing",),
    ("areas", "AAS_Reachability_Grapple"): ("AAS_Reachability_Grapple",),
    ("areas", "AAS_Reachability_WalkOffLedge"): ("AAS_Reachability_WalkOffLedge",),
    ("areas", "AAS_InitReachabilityAreas"): ("AAS_InitReachabilityAreas",),
    ("areas", "BotFuzzyPointReachabilityArea"): ("BotFuzzyPointReachabilityArea",),
    ("areas", "BotReachabilityArea"): ("BotReachabilityArea",),
    ("areas", "BotMoveToGoal"): ("BotMoveToGoal",),
    ("areas", "BotExportTest"): ("BotExportTest",),
    # `int modelList[256]` of G2_ConstructGhoulSkeleton goes to the `int *` list of G2_Sort_Models at tr_ghoul2.cpp:3592, row R8.
    ("modelList", "G2_ConstructGhoulSkeleton"): ("G2_ConstructGhoulSkeleton",),
    # The record each function of RETURNS kind `record` returns, the `ev` rows above, row X17 of docket 10.
    # AAS_Trace returns `bsptrace` at be_aas_bspq3.cpp:142, AAS_TraceClientBBox returns `trace` of be_aas_sample.cpp,
    # and the travel functions of be_ai_move.cpp return `result`.
    ("bsptrace", "AAS_Trace"): ("AAS_Trace",),
    ("trace", "AAS_TraceClientBBox"): ("AAS_TraceClientBBox",),
    ("result", "BotTravel_Walk"): ("BotTravel_Walk",),
    ("result", "BotFinishTravel_Walk"): ("BotFinishTravel_Walk",),
    ("result", "BotTravel_Crouch"): ("BotTravel_Crouch",),
    ("result", "BotTravel_BarrierJump"): ("BotTravel_BarrierJump",),
    ("result", "BotFinishTravel_BarrierJump"): ("BotFinishTravel_BarrierJump",),
    ("result", "BotTravel_Swim"): ("BotTravel_Swim",),
    ("result", "BotTravel_WaterJump"): ("BotTravel_WaterJump",),
    ("result", "BotFinishTravel_WaterJump"): ("BotFinishTravel_WaterJump",),
    ("result", "BotTravel_WalkOffLedge"): ("BotTravel_WalkOffLedge",),
    ("result", "BotFinishTravel_WalkOffLedge"): ("BotFinishTravel_WalkOffLedge",),
    ("result", "BotTravel_Jump"): ("BotTravel_Jump",),
    ("result", "BotFinishTravel_Jump"): ("BotFinishTravel_Jump",),
    ("result", "BotTravel_Ladder"): ("BotTravel_Ladder",),
    ("result", "BotTravel_Teleport"): ("BotTravel_Teleport",),
    ("result", "BotTravel_Elevator"): ("BotTravel_Elevator",),
    ("result", "BotFinishTravel_Elevator"): ("BotFinishTravel_Elevator",),
    ("result", "BotTravel_FuncBobbing"): ("BotTravel_FuncBobbing",),
    ("result", "BotFinishTravel_FuncBobbing"): ("BotFinishTravel_FuncBobbing",),
    ("result", "BotTravel_Grapple"): ("BotTravel_Grapple",),
    ("result", "BotTravel_RocketJump"): ("BotTravel_RocketJump",),
    ("result", "BotTravel_BFGJump"): ("BotTravel_BFGJump",),
    ("result", "BotFinishTravel_WeaponJump"): ("BotFinishTravel_WeaponJump",),
    ("result", "BotTravel_JumpPad"): ("BotTravel_JumpPad",),
    ("result", "BotFinishTravel_JumpPad"): ("BotFinishTravel_JumpPad",),
    ("result", "BotMoveInGoalArea"): ("BotMoveInGoalArea",),
    # The `float` and `unsigned short` locals a body hands to a list parameter, row X20 of docket 10, the `int` rows above.
    # GeneticParentsAndChildSelection hands `rankings` to GeneticSelection at be_ai_gen.cpp:75, and BotPredictVisiblePosition hands
    # its three avoid lists to BotGetReachabilityToGoal at be_ai_move.cpp:899 to :901.
    ("rankings", "GeneticParentsAndChildSelection"): ("GeneticParentsAndChildSelection",),
    ("avoidreach", "BotPredictVisiblePosition"): ("BotPredictVisiblePosition",),
    ("avoidreachtimes", "BotPredictVisiblePosition"): ("BotPredictVisiblePosition",),
    ("avoidreachtries", "BotPredictVisiblePosition"): ("BotPredictVisiblePosition",),
    # AAS_UpdateAreaRoutingCache keeps the address of `startareatraveltimes` in a routing update at be_aas_route.cpp:1275.
    ("startareatraveltimes", "AAS_UpdateAreaRoutingCache"): ("AAS_UpdateAreaRoutingCache",),
    # The Wait arm of CTaskManager hands `&dwtime` to SetData at TaskManager.cpp:1111 and :1129.
    ("dwtime", "Wait"): ("Wait",),
    # BotImport_DebugLineCreate and BotImport_DebugLineShow hand their `vec3_t points[]` locals to the `vec3_t *` table of the polygon calls,
    # sv_bot.cpp:526 and :569, row B4 of the cmsv round, the `hullPoints` rule.
    ("points", "BotImport_DebugLineCreate"): ("BotImport_DebugLineCreate",),
    ("points", "BotImport_DebugLineShow"): ("BotImport_DebugLineShow",),
    # The static record locals of the bone path and the AAS debug code, the `nullSym` row, rows X5 and X36 A6 of docket 10.
    # G2_TransformBone declares `static mdxaBone_t tbone[6]` at tr_ghoul2.cpp:1544, and AAS_ShowReachableAreas `static aas_reachability_t reach`
    # at be_aas_debug.cpp:670. The scalar statics beside them are properties of EngineWorld.
    ("tbone", "G2_TransformBone"): ("G2_TransformBone",),
    ("reach", "AAS_ShowReachableAreas"): ("AAS_ShowReachableAreas",),
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
#   bytes_table  an array of optional Slots of bytes for a fixed array of `byte *` buffers, each Slots bounded by SLOT_BOUNDS
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
    # SV_AreaEntities stores the caller's list at sv_world.cpp:427, and SV_AreaEntities_r writes `ap->list[ap->count]` at :399.
    # CM_BoxLeafnums stores the caller's list at cm_test.cpp:410, and CM_StoreLeafs writes `ll->list[ll->count++]` at :356.
    ("areaParms_t", "list"): "bytes",
    ("leafList_t", "list"): "bytes",
    # SV_WriteDownloadToClient stores a Z_Malloc block of MAX_DOWNLOAD_BLKSIZE bytes in each slot at sv_client.cpp:1158 and reads it at :1243, row G13.
    # A `byte *` array of kind `bytes_table` reads as an array of the Slots over each block or nil, the `bytes` form per slot.
    ("client_t", "downloadBlocks"): "bytes_table",
    # The botlib fields of the ninth batch, rows D6, D15, D20, N1, N4, and N5.
    # A `T **` field that holds an allocated table of record pointers, the `pack_t.hashTable` row. PC_FindHashedDefine indexes
    # `definehash[hash]` at l_precomp.cpp:640, PS_CreatePunctuationTable fills `punctuationtable[*p->p]` at l_script.cpp:175,
    # and be_aas_sample.cpp:175 and be_aas_route.cpp:831 allocate the area entity links and the portal caches.
    ("source_t", "definehash"): "pointer_table",
    ("script_t", "punctuationtable"): "pointer_table",
    ("aas_t", "arealinkedentities"): "pointer_table",
    ("aas_t", "portalcache"): "pointer_table",
    # An `int *` field a body indexes, the `clipMap_t.leafbrushes` row. The AAS loaders store each lump at be_aas_file.cpp:383 to :416,
    # and be_aas_optimize.cpp:205 to :218 allocates the optimized tables.
    ("aas_t", "edgeindex"): "bytes",
    ("aas_t", "faceindex"): "bytes",
    ("aas_t", "portalindex"): "bytes",
    ("aas_t", "areacontentstravelflags"): "bytes",
    ("aas_t", "portalmaxtraveltimes"): "bytes",
    ("aas_t", "reachabilityareaindex"): "bytes",
    ("optimized_t", "edgeindex"): "bytes",
    ("optimized_t", "faceindex"): "bytes",
    ("optimized_t", "vertexoptimizeindex"): "bytes",
    ("optimized_t", "edgeoptimizeindex"): "bytes",
    ("optimized_t", "faceoptimizeindex"): "bytes",
    # An `unsigned char *` and an `unsigned short *` field a body indexes take the same kind, row N5.
    # AAS_UpdateAreaRoutingCache writes `areacache->reachabilities[i]`, and `curupdate->areatraveltimes[i]` reads the times of be_aas_route.cpp:1301.
    ("aas_routingcache_t", "reachabilities"): "bytes",
    ("aas_routingupdate_t", "areatraveltimes"): "bytes",
    # A `vec3_t *` field a body indexes reads as a Slots of vectors, row N4. The AAS loaders store the vertex lump,
    # and AAS_OptimizeEdge indexes `optimized->vertexes[...]` of be_aas_optimize.cpp.
    ("aas_t", "vertexes"): "vectors",
    ("optimized_t", "vertexes"): "vectors",
    # The stream of the bot log, `logfile.fp` of l_log.cpp:29, is the C library's `FILE *`, the `qfile_gut.o` row, row D20.
    ("logfile_t", "fp"): "opaque",
    # The text of a script and the cursors into it, row N1. LoadScriptFile sets `script->buffer` to the bytes after the record at l_script.cpp:1323,
    # and the cursors are byte offsets into that buffer. A token's cursors hold the offsets of the script it came from.
    ("script_t", "buffer"): ("text_buffer", "length"),
    ("script_t", "script_p"): ("text_offset", "buffer"),
    ("script_t", "end_p"): ("text_offset", "buffer"),
    ("script_t", "lastscript_p"): ("text_offset", "buffer"),
    ("script_t", "whitespace_p"): ("text_offset", "buffer"),
    ("script_t", "endwhitespace_p"): ("text_offset", "buffer"),
    ("token_t", "whitespace_p"): ("text_offset", None),
    ("token_t", "endwhitespace_p"): ("text_offset", None),
    # The weight index tables of the weapon and goal states, which WeaponWeightIndex and ItemWeightIndex allocate,
    # and be_ai_weap.cpp:407 and be_ai_goal.cpp:1329 and :1500 index, the `aas_t.edgeindex` row, row X21 of docket 10.
    ("bot_weaponstate_t", "weaponweightindex"): "bytes",
    ("bot_goalstate_t", "itemweightindex"): "bytes",
}

# (struct, field) -> the accessor name of a field whose C name is a member of every view, `handle` or `raw`, where a body reads the field.
# Raven writes `vmCvar->handle` at cvar.cpp:896 and reads it at :913 and :917.
FIELD_NAMES = {
    ("vmCvar_t", "handle"): "cvarHandle",
    # Raven stores the zip handle at files_pc.cpp:1460 and reads it at :774, :1001, and :1058.
    ("pack_t", "handle"): "packHandle",
    # Raven stores the model handle at tr_model.cpp:664 and reads it at :1040, :1213, and :1241, row TR12.
    ("modelHash_t", "handle"): "modelHandle",
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
    # Raven declares `byte *cmod_base` at cm_load.cpp:64, the BSP file that CM_LoadMap_Actual reads, and each loader reads a lump at `cmod_base + l->fileofs`.
    "cmod_base": "Slots<JKAShared.byte>?",
    # Raven declares `static facet_t *facets` at cm_patch.cpp:435, and CM_PatchCollideFromGrid indexes `facets[numFacets]` at :1149.
    "facets": "Slots<Facet>?",
    # Raven declares `static bot_debugpoly_t *debugpolygons` at sv_bot.cpp:16, the Z_Malloc table of SV_BotInitBotLib, and indexes it by polygon id.
    # be_aas_debug.cpp declares an `int debugpolygons[MAX_DEBUGPOLYGONS]` of its own, so the key names the file.
    "sv_bot:debugpolygons": "Slots<BotDebugpoly>?",
    # The C++ `bool` globals of the host, the row of `g_nOverrideChecked`, rows TR3 and G2B2.
    "gServerSkinHack": "Bool",
    "tr_stencilled": "Bool",
    "g_bRenderGlowingObjects": "Bool",
    "g_bDynamicGlowSupported": "Bool",
    "HackadelicOnClient": "Bool",
    "g_G2AllocTrackInit": "Bool",
    "haveDesiredPelvisOffset": "Bool",
    # The vectors of ghoul2_shared.h:223 to :226 are Swift arrays of their records, rule 17.
    # A non-const reference to one is inout, so `boneInfo_v &blist` is `inout [boneInfo_t]`.
    "surfaceInfo_v": "[surfaceInfo_t]",
    "boneInfo_v": "[boneInfo_t]",
    "boltInfo_v": "[boltInfo_t]",
    "mdxaBone_v": "[(Int32, MdxaBone)]",
    # The maps of Q3_Registers.h:16 and :17 are Swift dictionaries by name, the twin of the vectors above, ratified 2026-11-10.
    # A non-const reference to one is inout, so `varFloat_m &fmap` of Q3_Registers.cpp:267 is `inout [String: Float]`.
    "varString_m": "[String: String]",
    "varFloat_m": "[String: Float]",
    # A file-scope `T **` that holds an allocated table of record pointers is a Slots of optional views or nil, row N3 of the ninth batch.
    # `define_t **globaldefines` of l_precomp.cpp:105 takes DEFINEHASHSIZE pointers at :3049, and `areareachability` of be_aas_reach.cpp:85 one per area at :4521.
    "globaldefines": "Slots<Define?>?",
    "areareachability": "Slots<AasLreachability?>?",
    # A file-scope record pointer a body indexes is the Slots over its table, the `facets` row, row D14.
    # be_aas_reach.cpp:447, be_ai_chat.cpp:232, be_ai_goal.cpp:362, be_aas_routealt.cpp:203, and be_ea.cpp:505 allocate and index them.
    "reachabilityheap": "Slots<AasLreachability>?",
    "consolemessageheap": "Slots<BotConsolemessage>?",
    "levelitemheap": "Slots<Levelitem>?",
    "midrangeareas": "Slots<Midrangearea>?",
    "botinputs": "Slots<BotInput>?",
    # `int *clusterareas` of be_aas_routealt.cpp:40 is the table of be_aas_routealt.cpp:205, the `cmod_base` row.
    "clusterareas": "Slots<Int32>?",
}

# The folders whose `long`, `unsigned long`, and `long double` are the widths of WinDed, 32, 32, and 64 bits, row D5 of the ninth batch.
# A parameter, a pointer parameter, and a return of a function of the folder take Int32, UInt32, and Double, the copy of `token_t` in ded_types.h.
# NumberValue of l_script.cpp:541 fills `token->intvalue` and `token->floatvalue` through its two pointers. The pattern is the UINT4 row above.
# CNavigator::GetLong of navigator.cpp:557 and the CNode Save and Load of navigator.cpp:385 and :426 read and write a 4-byte `long` in a `.nav` file.
MSVC_WIDTH_FOLDERS = {"botlib", "icarus", "NPCNav"}

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
#   bytes          a Slots<byte>, for a `byte *` Raven returns into a byte buffer the caller indexes, the return twin of the PARAMS kind
#   optional_bytes  a Slots<byte>?, the same for a function that returns NULL on one path
#   optional_raw   an UnsafeMutableRawPointer?, the `raw` return of a function that returns NULL on one path
#   string_list    a [String], for a `char **` list of zone texts with its count beside it, the file lists of files_pc.cpp and win_main.cpp
#   class_ref      the Swift class of a C++ class of CXX_CLASSES, optional, for a pointer to an instance Raven returns or NULL
#   int32          an Int32, for an `unsigned` mask Raven returns into an `int` of every caller
# A key `record.field` names the stored function of a view field, and its run method takes the kind, `botlib_import_t.GetMemory`.
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
    # VM_ArgPtr and BotVMShift return NULL for a zero word at vm.cpp:642 and :661, row FC3, the optional twin of `raw`.
    "VM_ArgPtr": "optional_raw",
    "BotVMShift": "optional_raw",
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
    # CM_ClusterPVS returns a row of `cmg.visibility` at cm_test.cpp:351, and SV_inPVS and the snapshot index it by cluster.
    "CM_ClusterPVS": "bytes",
    # SE_LoadFileData returns the FS_ReadFile buffer or NULL at stringed_interface.cpp:41.
    "SE_LoadFileData": "optional_bytes",
    # Raven returns `char **` lists of CopyString texts with `int *numfiles` beside them, files_pc.cpp:1587, :1724, :1818, and win_main.cpp:502.
    "Sys_ListFiles": "string_list",
    "FS_ListFilteredFiles": "string_list",
    "FS_ListFiles": "string_list",
    "Sys_ConcatenateFileLists": "string_list",
    # Bot_GetMemoryGame, BotImport_GetMemory, and BotImport_HunkAlloc of sv_bot.cpp return the block of one Z_Malloc or Hunk_Alloc call, the S_Malloc row.
    "Bot_GetMemoryGame": "raw",
    "BotImport_GetMemory": "raw",
    "BotImport_HunkAlloc": "raw",
    # unzOpen and unzReOpen return the `unzFile` handle, a `void *` over the zone block of `unz_s`, unzip.cpp:388 and :413.
    "unzOpen": "opaque",
    "unzReOpen": "opaque",
    # SE_GetFoundFile returns NULL at the end of the list, stringed_ingame.cpp:875, and SE_Load_Actual, SE_Load, and SE_LoadLanguage return NULL for success.
    "SE_GetFoundFile": "optional_string",
    "SE_Load_Actual": "optional_string",
    "SE_Load": "optional_string",
    "SE_LoadLanguage": "optional_string",
    # Com_ParseTextFile of common.cpp:2209 returns a `new CGenericParser2` or NULL.
    "Com_ParseTextFile": "class_ref",
    # ICARUS_Malloc of icarus/Memory.cpp:8 returns the Z_Malloc block, the row of S_Malloc and row B5, row FC4.
    "ICARUS_Malloc": "raw",
    # The botlib allocators of l_memory.cpp, row D12. GetMemory and GetHunkMemory return NULL when the import does, :332 and :374,
    # and GetClearedMemory and GetClearedHunkMemory hand that NULL to Com_Memset, so they never return it. The rows of S_Malloc and FC3.
    "GetMemory": "optional_raw",
    "GetHunkMemory": "optional_raw",
    "GetClearedMemory": "raw",
    "GetClearedHunkMemory": "raw",
    # Log_FilePointer of l_log.cpp:138 returns the `FILE *` of the bot log, the FS_FileForHandle row, row D20.
    "Log_FilePointer": "opaque",
    # G2_FindSurface of G2_misc.cpp:1689 returns a `void *` that every caller casts to `mdxmSurface_t *`, G2_surfaces.cpp:123 and G2_API.cpp:2385, row G2A5.
    "G2_FindSurface": ("view", "mdxmSurface_t"),
    # RE_RegisterModels_Malloc and RE_RegisterServerModels_Malloc return `ModelBin.pModelDiskImage`, the disk image of the model, tr_model.cpp:250 and :318,
    # which the loaders cast to their header at :718, :841, and :1467. The `pModelDiskImage` field is a Slots of bytes.
    "RE_RegisterModels_Malloc": "bytes",
    "RE_RegisterServerModels_Malloc": "bytes",
    # NameToAFunc of tr_shader.cpp:358 returns `unsigned`, and ParseStage stores it into `int atestBits` at :1502. GLS_ATEST_GE_C0 is the unsigned 0x80000000,
    # so the body spells it as the Int32 complement, the form of CONTENTS_TRANSLUCENT in cm_shader.swift, row TR18.
    "NameToAFunc": "int32",
    # The stored functions of the botlib import return the block of BotImport_GetMemory and BotImport_HunkAlloc, sv_bot.cpp:438 and :459,
    # the rows above, so the run methods return the block, row X1 of docket 10.
    "botlib_import_t.GetMemory": "raw",
    "botlib_import_t.HunkAlloc": "raw",
    # G2_FindSurface_BC of tr_ghoul2.cpp:2952 returns a `void *` that every caller casts to `mdxmSurface_t *`, the G2_FindSurface row, row X14 G1d.
    "G2_FindSurface_BC": ("view", "mdxmSurface_t"),
    # Raven returns a record by value, the Com_GetRealEvent rows, row X17 of docket 10. AAS_Trace of be_aas_bspq3.cpp:130 returns a `bsp_trace_t`,
    # AAS_TraceClientBBox of be_aas_sample.cpp:432 an `aas_trace_t`, and the travel functions of be_ai_move.cpp:1328 to :2981 a `bot_moveresult_t`.
    "AAS_Trace": "record",
    "AAS_TraceClientBBox": "record",
    "BotTravel_Walk": "record",
    "BotFinishTravel_Walk": "record",
    "BotTravel_Crouch": "record",
    "BotTravel_BarrierJump": "record",
    "BotFinishTravel_BarrierJump": "record",
    "BotTravel_Swim": "record",
    "BotTravel_WaterJump": "record",
    "BotFinishTravel_WaterJump": "record",
    "BotTravel_WalkOffLedge": "record",
    "BotFinishTravel_WalkOffLedge": "record",
    "BotTravel_Jump": "record",
    "BotFinishTravel_Jump": "record",
    "BotTravel_Ladder": "record",
    "BotTravel_Teleport": "record",
    "BotTravel_Elevator": "record",
    "BotFinishTravel_Elevator": "record",
    "BotTravel_FuncBobbing": "record",
    "BotFinishTravel_FuncBobbing": "record",
    "BotTravel_Grapple": "record",
    "BotTravel_RocketJump": "record",
    "BotTravel_BFGJump": "record",
    "BotFinishTravel_WeaponJump": "record",
    "BotTravel_JumpPad": "record",
    "BotFinishTravel_JumpPad": "record",
    "BotMoveInGoalArea": "record",
    # WeaponWeightIndex of be_ai_weap.cpp and ItemWeightIndex of be_ai_goal.cpp return the `int *` table that the state field holds, row X21 of docket 10.
    "WeaponWeightIndex": "bytes",
    "ItemWeightIndex": "bytes",
    # StringContainsWord of be_ai_chat.cpp:478 returns a pointer into `str1`, which StringReplaceWords steps at :534 to :544, the Q_strrchr row, row X24 P15.
    "StringContainsWord": "text_offset",
    # AAS_LoadAASLump of be_aas_file.cpp:273 returns the block of the lump or NULL on a failed read, the GetMemory row, row X36 A3.
    "AAS_LoadAASLump": "optional_raw",
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
#                A `void **` of kind `text_cursor` is an inout TextCursor, which the body hands on as a `char **`
#   fill_buffer  a `char *` a trap fills with no size beside it, given as ("fill_buffer", capacity) with the capacity Raven's
#                callers declare for the buffer, and the trap returns the String the same way a sized buffer does
#   float_array  an inout [Float] for a `float *` a body fills as a matrix of the counts beside it, or as a fixed count of floats
#   int_array  an [Int32]? by value for a read-only `int *` with a count beside it, and a caller's NULL is nil
#   int_array_mut  an inout [Int32] for an `int *` the body writes by index, the `int` twin of float_array
#   byte_array  a [byte] by value for a read-only `const byte *` table every caller passes as a Swift array, the byte twin of int_array
#   byte_offset  an Int32 byte offset for a pointer into a byte buffer the body turns into an offset from the buffer base
#   pointer_table  a Slots<View?> over a file-scope array of struct pointers, whose base a trap hands to the engine
#   key_path  a KeyPath<Entity, String?> for an `int` field offset Raven takes from `FOFS(field)`, which a call site spells `\.field`
#   int_value  an Int32 by value for a `const void *` a qsort comparator reads as `*(int *)`, so the comparator is `(Int32, Int32) -> Int32`
#   model_list  a Slots<qhandle_t>? for an `int *modelList` the engine reads as the array of model handles, the form a `qhandle_t *` has
#   out_opaque  an inout OpaquePointer? for a `void *` Raven's callers pass the address of a handle field to, the shape a `void **` already has
#   view      the optional view of the record named beside the kind, ("view", record), for a `void *` every caller fills with that record or NULL
#   float_mut  an inout Float for a `float *` of a stored function that the function reads and writes as one float, keyed by "record.field",
#             and an inout Int32 for an `int *` of the same use, the `fileHandle_t *` of `botlib_import_t.FS_FOpenFile`
#   view_array  an inout [View?] for a `T **` that is the caller's C array of struct pointers the function fills, the rule of a `T *name[N]` parameter
#   out_scalar  an inout CChar for a `char *` that holds one character the body writes, the rule of a pointer to one scalar
#   keyword_buckets  the bucket table of row indices and the row table beside it, form A of R53, for `keywordHash_t *table[]`
#   keyword_buckets_mut  the same pair inout, for the function that links a row into the buckets
#   row_index  an Int32 row index for a `keywordHash_t *` row pointer, form A of R53
#   opaque    an OpaquePointer? for a `byte *` buffer the body stores into a `byte *` field or hands on as a `void *`, the spelling of the field
#   bytes     a Slots<byte> for a `void *` or `byte *` of a host function that the body hands on as bytes, the row a host `byte *` has
#             A `void **` of kind `bytes` is the caller's `inout Slots<byte>?`, which the body sets to a byte buffer
#   word      an Int for an `int` that takes the pointer-wide word VM_Call returns
#   callback  the optional callback typealias of a view field for a function pointer the body stores into that field, the form of a function-pointer return,
#             given as ("callback", "record.field") with that field when another field has the same C signature
#   string_list  a [String] by value, for a `char **` list of zone texts the body reads or frees, the parameter twin of the RETURNS kind
#   string_list_mut  an inout [String], for a `char **` list the body reorders in place, FS_SortFileList
#   string_slice  an inout ArraySlice<String>, for a `char **` the body fills by index from a caller's `&array[i]`, the `char *infos[]` row
#   string_value  a String by value for a `const void *` a qsort comparator reads as `*(char **)`, the text twin of int_value
#   std_string  an inout String, for a C++ `std::string &` the body writes, the reference twin of out_string
#   vec4_const  a vec4_t by value for a `float plane[4]` or a `float *` plane the body only reads, the form a `vec4_t` parameter has
#   vec3_array  a [vec3_t] by value for a `vec3_t *` array the body reads with a count beside it, the form a trap's vector array has
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
    # Q3_ReadScript of Q3_Interface.cpp:45 hands `(char**)buf` to ICARUS_GetScript, whose `char **buf` is an inout TextCursor, row 6 of the icarus round.
    ("Q3_ReadScript", "buf"): "text_cursor",
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
    # The row names that field, because `AAS_PointAreaNum` of aas_export_t has the same C signature.
    ("VM_Create", "systemCalls"): ("callback", "vm_t.systemCall"),
    # Sys_LoadDll of win_main.cpp:784 stores the module's vmMain through `entryPoint`, the address of `vm->entryPoint`,
    # and hands `systemcalls` to the module's dllEntry. The shell loads the library through jka_load_dll of CJKAHost.
    ("Sys_LoadDll", "entryPoint"): "raw",
    ("Sys_LoadDll", "systemcalls"): "opaque",
    # The file lists of files_pc.cpp and win_main.cpp, the RETURNS kind `string_list` and its parameters.
    ("Sys_ListFilteredFiles", "psList"): "string_slice",
    ("Sys_FreeFileList", "psList"): "string_list",
    ("FS_FreeFileList", "fileList"): "string_list",
    ("Sys_CountFileList", "list"): "string_list",
    ("Sys_ConcatenateFileLists", "list0"): "string_list",
    ("Sys_ConcatenateFileLists", "list1"): "string_list",
    ("Sys_ConcatenateFileLists", "list2"): "string_list",
    ("FS_SortFileList", "filelist"): "string_list_mut",
    # paksort of files_pc.cpp:2194 reads `*(char **)a`, and FS_AddGameDirectory sorts the pak names with it at :2261.
    ("paksort", "a"): "string_value",
    ("paksort", "b"): "string_value",
    # VM_VmProfile_f sorts a table of `vmSymbol_t *` with VM_ProfileSort at vm.cpp:892, and the comparator reads `*(vmSymbol_t **)a` at :837.
    ("VM_ProfileSort", "a"): ("view", "vmSymbol_t"),
    ("VM_ProfileSort", "b"): ("view", "vmSymbol_t"),
    # SV_BuildClientSnapshot sorts the entity numbers with SV_QsortEntityNumbers at sv_snapshot.cpp:588, which reads `*(int *)a`.
    ("SV_QsortEntityNumbers", "a"): "int_value",
    ("SV_QsortEntityNumbers", "b"): "int_value",
    # SV_AreaEntities and CM_BoxLeafnums fill the caller's `int` list, and the G_ENTITIES_IN_BOX arm hands the module's array, sv_game.cpp:581.
    # An `int *` of kind `bytes` is a Slots of Int32, the rule of the field kind.
    ("SV_AreaEntities", "entityList"): "bytes",
    ("CM_BoxLeafnums", "boxList"): "bytes",
    # The debug polygon calls read `numPoints` vectors at sv_bot.cpp:527 and :569, and the G_DEBUG_POLYGON_CREATE arm hands the module's array.
    ("BotImport_DebugPolygonCreate", "points"): "table",
    ("BotImport_DebugPolygonShow", "points"): "table",
    # SV_BotWaypointReception copies the module's table of waypoint pointers at sv_bot.cpp:41, the trap_Bot_UpdateWaypoints row.
    ("SV_BotWaypointReception", "wps"): "pointer_table",
    # unzlocal_getShort, unzlocal_getLong, and unzlocal_SearchCentralDir read the `ZIP_FILE *` stream of unzip.h:3, the stream of FileBackend.
    ("unzlocal_getShort", "fin"): "opaque",
    ("unzlocal_getLong", "fin"): "opaque",
    ("unzlocal_SearchCentralDir", "fin"): "opaque",
    # SE_GetFoundFile, SE_R_ListFiles, and SE_BuildFileList write the caller's `string &` at stringed_ingame.cpp:875 and stringed_interface.cpp:132 and :192.
    ("SE_GetFoundFile", "strResult"): "std_string",
    ("SE_R_ListFiles", "strResults"): "std_string",
    ("SE_BuildFileList", "strResults"): "std_string",
    # CM_FindPlane and CM_PointOnPlaneSide hand `float *` points to DotProduct and VectorSubtract at cm_patch.cpp:520 and :577, and read nothing past the third float.
    ("CM_FindPlane", "p1"): "vec3_const",
    ("CM_FindPlane", "p2"): "vec3_const",
    ("CM_FindPlane", "p3"): "vec3_const",
    ("CM_PointOnPlaneSide", "p"): "vec3_const",
    # CM_PlaneEqual, CM_FindPlane2, and CM_CheckFacetPlane read the four floats of a plane, cm_patch.cpp:440, :489, and :1346.
    ("CM_PlaneEqual", "plane"): "vec4_const",
    ("CM_FindPlane2", "plane"): "vec4_const",
    ("CM_CheckFacetPlane", "plane"): "vec4_const",
    # Q3_GetVectorVariable writes the three floats of `value` through sscanf at Q3_Registers.cpp:179, row SV4.
    ("Q3_GetVectorVariable", "value"): "vec3_mut",
    # CM_ComparePoints reads the three floats of each grid point at cm_patch.cpp:373 to :384, row P1, the row of CM_FindPlane.
    ("CM_ComparePoints", "a"): "vec3_const",
    ("CM_ComparePoints", "b"): "vec3_const",
    # CM_GeneratePatchCollide reads `width * height` points of the caller's `vec3_t points[MAX_PATCH_VERTS]` at cm_patch.cpp:1163, row P2,
    # so the caller's array of vectors crosses, the row a trap's `vec3_t *` array has.
    ("CM_GeneratePatchCollide", "points"): "vec3_array",
    # CM_ParseVector fills three floats of the one caller's `vec3_t fogColor` at cm_shader.cpp:435, row S2, the row of BG_ValidateSkinForTeam.
    ("CM_ParseVector", "v"): "vec3_mut",
    # The lightmap index lists of tr_shader.cpp are the four tables of :124 to :149 or a surface's list, read and never written, row TR8.
    ("R_CreateExtendedName", "lightmapIndex"): "int_array",
    ("IsShader", "lightmapIndex"): "int_array",
    ("R_FindShader", "lightmapIndex"): "int_array",
    ("R_FindServerShader", "lightmapIndex"): "int_array",
    ("RE_RegisterShaderFromImage", "lightmapIndex"): "int_array",
    ("RE_RegisterShaderLightMap", "lightmapIndex"): "int_array",
    # The style lists of the same six functions are `stylesDefault` of tr_shader.cpp:157, a Swift array, or a surface's list, read and never written.
    # Raven hands `stylesDefault` at tr_shader.cpp:281, :291, :3739, and :3769, and tr_image.cpp:3093 and :3097, row TR11.
    ("R_CreateExtendedName", "styles"): "byte_array",
    ("IsShader", "styles"): "byte_array",
    ("R_FindShader", "styles"): "byte_array",
    ("R_FindServerShader", "styles"): "byte_array",
    ("RE_RegisterShaderFromImage", "styles"): "byte_array",
    ("RE_RegisterShaderLightMap", "styles"): "byte_array",
    # RE_RegisterModels_GetDiskFile sets `*ppvBuffer` to the disk image of a model, tr_model.cpp:125, and its callers read `*(unsigned *)buf`
    # and hand `buf` to the loaders at :1094 and :1313. A `void **` of kind `bytes` is the caller's `inout Slots<byte>?`, the type of `pModelDiskImage`, row TR13.
    ("RE_RegisterModels_GetDiskFile", "ppvBuffer"): "bytes",
    # The Malloc pair stores the disk image into `ModelBin.pModelDiskImage` at tr_model.cpp:207 and :274, and the loaders read the file through `buffer`
    # and hand it to the Malloc pair at :718, :841, and :1467. Each caller passes the buffer of RE_RegisterModels_GetDiskFile.
    ("RE_RegisterModels_Malloc", "pvDiskBufferIfJustLoaded"): "bytes",
    ("RE_RegisterServerModels_Malloc", "pvDiskBufferIfJustLoaded"): "bytes",
    ("ServerLoadMDXA", "buffer"): "bytes",
    ("ServerLoadMDXM", "buffer"): "bytes",
    ("R_LoadMD3", "buffer"): "bytes",
    # RE_RegisterModels_StoreShaderRequest subtracts the disk image base from both pointers at tr_model.cpp:87 and :88 and stores the offsets, row TR20.
    # The callers at tr_model.cpp:898 and :1580 and tr_ghoul2.cpp:4939 pass field addresses inside that image.
    ("RE_RegisterModels_StoreShaderRequest", "psShaderName"): "byte_offset",
    ("RE_RegisterModels_StoreShaderRequest", "piShaderIndexPoke"): "byte_offset",
    # R_LoadMDXA and R_LoadMDXM of tr_ghoul2.cpp:5256 and :4816 take the same buffer from RE_RegisterModel_Actual at tr_model.cpp:1325 and :1329.
    ("R_LoadMDXA", "buffer"): "bytes",
    ("R_LoadMDXM", "buffer"): "bytes",
    # G2_IsSurfaceLegal and G2_FindSurface cast `void *mod` to `model_t *` on their first line, G2_surfaces.cpp:69 and G2_misc.cpp:1692,
    # and every caller passes a `model_t *`, rows G2A3 and G2A5, the QsortDistance row.
    ("G2_IsSurfaceLegal", "mod"): ("view", "model_t"),
    ("G2_FindSurface", "mod_t"): ("view", "model_t"),
    # G2API_GetBoneAnim hands the caller's model list to G2_Get_Bone_Anim, row G2A6, the trap_G2API_GetBoneAnim row.
    ("G2API_GetBoneAnim", "modelList"): "model_list",
    # G2_GetBoneDependents fills `*tempDependents` and steps the pointer at tr_ghoul2.cpp:624 to :633, and G2_bones.cpp:4112 and :4355 hand it
    # the file-scope table of BYTE_STORAGE_VARS, row R2. An `int *` of kind `bytes` is a Slots of Int32, the SV_AreaEntities row.
    ("G2_GetBoneDependents", "tempDependents"): "bytes",
    # R_TransformEachSurface fills the caller's table of one word per surface at G2_misc.cpp:417, G2_TransformSurfaces hands it on at :542 and :554,
    # and G2_TransformModel hands them `g.mTransformedVertsArray` at :651, the field of kind `bytes` on an `int *`, row R7.
    ("R_TransformEachSurface", "TransformedVertsArray"): "bytes",
    ("G2_TransformSurfaces", "TransformedVertArray"): "bytes",
    # Every caller of the three passes a `vec3_t`, G2_API.cpp:1293 and :1333 and G2_bones.cpp:471, :506, and :525, rows G2A7 and R6, the CM_FindPlane row.
    ("G2_Set_Bone_Angles_Index", "angles"): "vec3_const",
    ("G2_Set_Bone_Angles", "angles"): "vec3_const",
    ("G2_Generate_Matrix", "angles"): "vec3_const",
    # Create_Matrix hands `angle` to AnglesToAxis at G2_misc.cpp:1635, and every caller passes a `vec3_t`, G2_bones.cpp:312 and G2_misc.cpp:1680 among them.
    ("Create_Matrix", "angle"): "vec3_const",
    # QsortDistance of G2_API.cpp:1993 reads `(CollisionRecord_t *)a` and `b`, and the two collision functions sort the table with it, row G4.
    ("QsortDistance", "a"): ("view", "CollisionRecord_t"),
    ("QsortDistance", "b"): ("view", "CollisionRecord_t"),
    # The collision functions fill and sort the caller's table of MAX_G2_COLLISIONS records by index, G2_misc.cpp:1114 and :1346, row G4.
    ("G2API_CollisionDetectCache", "collRecMap"): "table",
    ("G2API_CollisionDetect", "collRecMap"): "table",
    ("G2_TraceModels", "collRecMap"): "table",
    # The botlib lists of the ninth batch, row D16. An `int *` list the body hands on or fills is the caller's Slots of Int32, the SV_AreaEntities row.
    # AAS_ConnectedAreas hands `areanums` to AAS_ConnectedAreas_r at be_aas_cluster.cpp:713, the goal and weapon choosers hand `inventory`
    # to FuzzyWeight at be_ai_goal.cpp:1334, :1505, and be_ai_weap.cpp:409, and AAS_BoxEntities of be_aas_bspq3.cpp:225 takes a list by its shape.
    ("AAS_ConnectedAreas", "areanums"): "bytes",
    ("BotChooseLTGItem", "inventory"): "bytes",
    ("BotChooseNBGItem", "inventory"): "bytes",
    ("BotChooseBestFightWeapon", "inventory"): "bytes",
    ("AAS_BoxEntities", "list"): "bytes",
    # A `vec3_t *` list the body indexes or hands on is the Slots of vectors, the BotImport_DebugPolygonCreate row.
    # AAS_TraceAreas writes `points[numareas]` at be_aas_sample.cpp:757, and nine callers hand NULL, so NULLABLE names it too.
    ("AAS_ShowPolygon", "points"): "table",
    ("AAS_TraceAreas", "points"): "table",
    ("AAS_FindFaceReachabilities", "facepoints"): "table",
    # The record that l_struct.cpp reads and writes at a field offset, `void *p` and `char *structure`, the BG_ParseField row, row D19.
    ("ReadNumber", "p"): "raw",
    ("ReadChar", "p"): "raw",
    ("ReadString", "p"): "raw",
    ("ReadStructure", "structure"): "raw",
    ("WriteStructWithIndent", "structure"): "raw",
    ("WriteStructure", "structure"): "raw",
    # The `FILE *` stream of the l_struct.cpp writers, the unzlocal_getShort row.
    ("WriteIndent", "fp"): "opaque",
    ("WriteFloat", "fp"): "opaque",
    ("WriteStructWithIndent", "fp"): "opaque",
    ("WriteStructure", "fp"): "opaque",
    # The stored functions of the botlib import, keyed by "record.field", row X1 of docket 10. FS_FOpenFile writes the handle through `file`,
    # the FS_FOpenFileByMode of files_pc.cpp that sv_bot.cpp:702 stores. FS_Read and FS_Write move the bytes of `buffer`, the FS_Read2 and FS_Write rows,
    # and DebugPolygonCreate reads `numPoints` vectors, the BotImport_DebugPolygonCreate row.
    ("botlib_import_t.FS_FOpenFile", "file"): "float_mut",
    ("botlib_import_t.FS_Read", "buffer"): "bytes",
    ("botlib_import_t.FS_Write", "buffer"): "bytes",
    ("botlib_import_t.DebugPolygonCreate", "points"): "table",
    # Every caller of UnCompressBone hands the `matrix` of an `mdxaBone_t`, tr_ghoul2.cpp:1464 and :1707 to :1748, so the parameter is that view, row X4.
    ("UnCompressBone", "mat"): ("view", "mdxaBone_t"),
    # AAS_BSPModelMinsMaxsOrigin hands its three vectors to botimport.BSPModelMinsMaxsOrigin at be_aas_bspq3.cpp:195, which writes them, row X18.
    ("AAS_BSPModelMinsMaxsOrigin", "mins"): "vec3_mut",
    ("AAS_BSPModelMinsMaxsOrigin", "maxs"): "vec3_mut",
    ("AAS_BSPModelMinsMaxsOrigin", "origin"): "vec3_mut",
    # BotGetReachabilityToGoal reads the table `ms->avoidspots` that be_ai_move.cpp:3279 and :3401 hand it, row X19 P11.
    ("BotGetReachabilityToGoal", "avoidspots"): "table",
    # FuzzyWeight and FuzzyWeightUndecided hand `inventory` to FuzzyWeight_r, which indexes it, be_ai_weight.cpp:627 and :658, row X21 P4.
    ("FuzzyWeight", "inventory"): "bytes",
    ("FuzzyWeightUndecided", "inventory"): "bytes",
    # The hash table of define pointers, `source->definehash` or `globaldefines`, l_precomp.cpp:516, :559, and :585, row X29, the D6 row of the ninth batch.
    ("PC_PrintDefineHashTable", "definehash"): "pointer_table",
    ("PC_AddDefineToHash", "definehash"): "pointer_table",
    ("PC_FindHashedDefine", "definehash"): "pointer_table",
    # PC_ReadDefineParms fills the caller's `token_t *parms[MAX_DEFINEPARMS]` at l_precomp.cpp:351, row X31.
    ("PC_ReadDefineParms", "parms"): "view_array",
    # PS_ReadEscapeCharacter writes one character through `ch`, l_script.cpp:344, and the callers pass `&token->string[len]` at :446 and :735, row X32.
    ("PS_ReadEscapeCharacter", "ch"): "out_scalar",
    # CM_CircularIterate hands the caller's `ivec3_t` or `int` to each callback as `int *user`, cm_terrain.cpp:1067 to :1114, the `int *` list rule, row X42 R5.
    ("CM_CircularIterate", "user"): "bytes",
    ("CM_ForceHeight", "user"): "bytes",
    ("CM_GetAverage", "user"): "bytes",
    ("CM_Smooth", "user"): "bytes",
    ("CM_MakeAverage", "user"): "bytes",
}

# Rule 20: a function with no caller in either tree stays as its stub, and the stub carries one note line that it is dead.
DEAD = {
    "CG_ParticleExplosion": "Raven calls this function from no file of either tree",
    # R_DebugGraphics of tr_main.cpp:1583 is the one caller, and the dedicated build never draws.
    "CM_DrawDebugSurface": "The renderer's R_DebugGraphics is the one caller, and the dedicated build never draws",
    # tr_image.cpp:2252 and :2295 call LoadTGA under `#ifndef DEDICATED`, and client/cl_main.cpp:2483 calls GetRefAPI, row TR9.
    "LoadTGA": "Its two callers in tr_image.cpp stand under `#ifndef DEDICATED`, so no caller builds in the dedicated host",
    "GetRefAPI": "The client's cl_main.cpp is the one caller, and the dedicated host does not link it",
    # R_AddGhoulSurfaces of tr_ghoul2.cpp:3384 is the one caller, under `#ifndef DEDICATED`, row G2B7.
    "bInShadowRange": "R_AddGhoulSurfaces is the one caller, under `#ifndef DEDICATED`, so no caller builds in the dedicated host",
    # CM_BoxBrushes of cm_test.cpp:194 has no caller in either tree, and it is the one function that stores CM_StoreBrushes, row R4.
    "CM_BoxBrushes": "Raven calls this function from no file of either tree",
    "CM_StoreBrushes": "CM_BoxBrushes is the one function that stores it, and no file of either tree calls CM_BoxBrushes",
    # GetRefAPI stores R_LerpTag into `re.LerpTag` at tr_init.cpp:1488, and the client's trap_R_LerpTag reaches it. GetRefAPI is dead under row TR9.
    "R_LerpTag": "GetRefAPI is the one function that stores it, and the dedicated host does not link the client that calls GetRefAPI",
    # G2API_SaveGhoul2Models and G2API_LoadGhoul2Models of G2_API.cpp:2472 and :2477 are the one caller of each, and no file of the MP tree calls them.
    # The SP calls of code/game/g_savegame.cpp:856 and :1058 reach the SP tree's own G2_API.cpp, row R9.
    "G2_SaveGhoul2Models": "G2API_SaveGhoul2Models is the one caller, and no file of the MP tree calls it",
    "G2_LoadGhoul2Model": "G2API_LoadGhoul2Models is the one caller, and no file of the MP tree calls it",
    # CM_Checksum of cm_load.cpp:544 has no caller in either tree, row X45 of docket 10.
    "CM_Checksum": "Raven calls this function from no file of either tree",
    # CM_DrawDebugSurface of cm_patch.cpp:1674 is the one caller of BotDrawDebugPolygons of sv_bot.cpp:227, and it is dead above, row X45 B6.
    "BotDrawDebugPolygons": "CM_DrawDebugSurface is the one caller, and the dedicated build never draws",
    # WriteStructWithIndent of l_struct.cpp:355 is the one caller of each, and WriteStructure, its one caller, is called only by DumpWeaponConfig
    # of be_ai_weap.cpp:156 under DEBUG_AI_WEAP, which the build does not define, row X34 of docket 10.
    "WriteIndent": "WriteStructWithIndent is the one caller, and its one caller WriteStructure stands only under DEBUG_AI_WEAP, which the build does not define",
    "WriteFloat": "WriteStructWithIndent is the one caller, and its one caller WriteStructure stands only under DEBUG_AI_WEAP, which the build does not define",
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
# Raven's `atol` reads a 32-bit `long` in MSVC, so it is `atoi`, cm_terrain.cpp:74, :93, and :134 to :136, row X45 R1 of docket 10.
LIBC_SPELLINGS = {"fabs": "abs", "fabsf": "abs", "stricmp": "Q_stricmp", "atol": "atoi"}

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
    # The renderer records of tr_local.h hold C++ `bool` fields, and `tr` of tr_main.cpp:15 holds them by value and by pointer, row TR1.
    "image_t": ("fields", "oracle/codemp/renderer/tr_local.h:136"),
    "textureBundle_t": ("fields", "oracle/codemp/renderer/tr_local.h:372"),
    "shaderStage_t": ("fields", "oracle/codemp/renderer/tr_local.h:394"),
    "shader_t": ("fields", "oracle/codemp/renderer/tr_local.h:459"),
    # `tr.landScape` holds the record by value, and its `class CTRLandScape *` field points at the renderer's terrain class, which C never reads.
    "srfTerrain_t": ("fields", "oracle/codemp/renderer/tr_local.h:744"),
    "CTRLandScape": ("tag", "oracle/codemp/renderer/tr_local.h:747"),
    # The compressed bone of mdx_format.h:119 is a C struct but for its `operator <`, which C leaves out, the CCMShader row, row X4 of docket 10.
    "mdxaCompQuatBone_t": ("fields", "oracle/codemp/renderer/mdx_format.h:119"),
}

# C++ classes of the oracle that a hand Swift class of the same name ports, by the C++ track of rule 17.
# A reference or a pointer parameter of the class is the Swift class, optional for a pointer, and a RETURNS kind `class_ref` returns it optional.
# CGenericParser2 is the final class of GenericParser2.swift, row C3 of notes/2026-11-03/dedicated-cxx-docket.md and row G1 of the unzip round.
CXX_CLASSES = {
    "CGenericParser2": "CGenericParser2",
    # Row C of notes/2026-11-09/dedicated-open-rows-ledger-7.md: one final class per Raven class of ICARUS, the navigator, and ROFF.
    "CBlockMember": "CBlockMember", "CBlock": "CBlock", "CBlockStream": "CBlockStream",
    "CSequence": "CSequence", "CSequencer": "CSequencer",
    "CTask": "CTask", "CTaskGroup": "CTaskGroup", "CTaskManager": "CTaskManager",
    "ICARUS_Instance": "ICARUS_Instance",
    "CNavigator": "CNavigator", "CNode": "CNode", "CEdge": "CEdge", "CPriorityQueue": "CPriorityQueue",
    "CROFFSystem": "CROFFSystem",
    # The Ghoul2 classes of ghoul2_shared.h:38 to :457, G2_gore.h, and tr_ghoul2.cpp, and the renderer classes of tr_local.h:2047 and MiniHeap.h:5.
    "surfaceInfo_t": "surfaceInfo_t", "boneInfo_t": "boneInfo_t", "boltInfo_t": "boltInfo_t",
    "CGhoul2Info": "CGhoul2Info", "CGhoul2Info_v": "CGhoul2Info_v",
    # IGhoul2InfoArray of ghoul2_shared.h:316 is an interface with one implementation, so it is the class it hides, rule 17.
    "IGhoul2InfoArray": "Ghoul2InfoArray", "Ghoul2InfoArray": "Ghoul2InfoArray",
    "CBoneCache": "CBoneCache", "CRagDollUpdateParams": "CRagDollUpdateParams", "CRagDollParams": "CRagDollParams",
    "CGoreSet": "CGoreSet", "GoreTextureCoordinates": "GoreTextureCoordinates", "CTraceSurface": "CTraceSurface",
    "CConstructBoneList": "CConstructBoneList", "CRenderableSurface": "CRenderableSurface", "CMiniHeap": "CMiniHeap",
    "CachedEndianedModelBinary_t": "CachedEndianedModelBinary_t",
    # The cycle timer of timing.h:2, which Com_Frame and the Ghoul2 timers of tr_ghoul2.cpp:42 to :50 hold under G2_PERFORMANCE_ANALYSIS of q_shared.h:46.
    "timing_c": "timing_c",
    # The heap order of CPriorityQueue at navigator.cpp:2693, and the ICARUS game table of interface.h:17, whose canonical record is `interface_export_s`.
    "NodeTotalGreater": "NodeTotalGreater", "interface_export_s": "interface_export_t",
    # The terrain classes of cm_landscape.h:42 to :135 and the random mission classes of RM_Manager.h:9 and RM_Objective.h:9, rows S1 and CM6.
    "CArea": "CArea", "CCMHeightDetails": "CCMHeightDetails", "CCMPatch": "CCMPatch", "CCMLandScape": "CCMLandScape",
    "CRMManager": "CRMManager", "CRMObjective": "CRMObjective",
    # The random terrain class of cm_randomterrain.h and the mission class of RM_Mission.h, which CCMLandScape and CRMManager hold, row X41 of docket 10.
    "CRandomTerrain": "CRandomTerrain", "CRMMission": "CRMMission",
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
    # SV_WriteSnapshotToClient passes a NULL `oldframe` on a retransmit or a first snapshot, sv_snapshot.cpp:115 to :131, and the body tests `!from` at :43.
    ("SV_EmitPacketEntities", "from"),
    # unzGoToFirstFile and the three callers of unzip.cpp pass NULL for the info and the two text buffers, :737 to :827, and the body tests each one.
    ("unzlocal_GetCurrentFileInfoInternal", "pfile_info"),
    ("unzlocal_GetCurrentFileInfoInternal", "pfile_info_internal"),
    ("unzlocal_GetCurrentFileInfoInternal", "szFileName"),
    ("unzlocal_GetCurrentFileInfoInternal", "szComment"),
    ("unzGetCurrentFileInfo", "pfile_info"),
    ("unzGetCurrentFileInfo", "szFileName"),
    ("unzGetCurrentFileInfo", "szComment"),
    # Nine callers of AAS_TraceAreas hand NULL for `points`, be_interface.cpp:413 and be_aas_reach.cpp:1542 among them, row D16.
    ("AAS_TraceAreas", "points"),
    # cg_players.c:3876 to :3880 hand NULL through trap_G2API_RagEffectorGoal, and the game trap of the same shape reaches sv_game.cpp:1565.
    # The body tests `!pos` at G2_API.cpp:1552.
    ("G2API_RagEffectorGoal", "pos"),
    # G2_Set_Bone_Angles_Rag and G2_Set_Bone_Angles_IK default both to `0` and test `angleMin&&angleMax` at G2_bones.cpp:1411 and :4563,
    # and G2_SetRagDoll and G2_InitIK leave both out, :1981 to :1994 and :4648 to :4660, row R4.
    ("G2_Set_Bone_Angles_Rag", "angleMin"),
    ("G2_Set_Bone_Angles_Rag", "angleMax"),
    ("G2_Set_Bone_Angles_IK", "angleMin"),
    ("G2_Set_Bone_Angles_IK", "angleMax"),
    # bg_pmove.c:8624, :8713, and :8726 hand NULL for the bone name or the parameters through strap_G2API_SetBoneIKState,
    # and G2_SetBoneIKState tests both at G2_bones.cpp:4674, :4698, and :4748.
    ("G2API_SetBoneIKState", "boneName"),
    ("G2API_SetBoneIKState", "params"),
    ("G2_SetBoneIKState", "boneName"),
    ("G2_SetBoneIKState", "params"),
    # G2_SetBoneIKState hands the result of G2_GetModA to G2_InitIK at G2_bones.cpp:4708 with no test, and neither body reads it.
    ("G2_InitIK", "mod_a"),
    ("G2_Set_Bone_Angles_IK", "mod_a"),
    # G2API_AddSkinGore passes `0` for the collision table at G2_API.cpp:2601, and the two collision functions pass `0` for the gore at :2110 and :2162.
    ("G2_TraceModels", "collRecMap"),
    ("G2_TraceModels", "gore"),
    # tr_arioche.cpp:29 passes NULL for `timeOffset`, and R_RemapShader tests it at tr_shader.cpp:313 before the store.
    ("R_RemapShader", "timeOffset"),
    # G2_GetBoltMatrixLow passes NULL for the surface at tr_ghoul2.cpp:3316 to :3324, row X14 G1e of docket 10.
    ("G2_ProcessSurfaceBolt2", "surface"),
    # The botlib frees and walks of a list that starts NULL, row X19 of docket 10. be_ai_chat.cpp:1142, :1205, :1264, :1273, :1836, :1958, and :1578
    # hand a local that starts NULL, and each body tests or walks it.
    ("BotFreeMatchPieces", "matchpieces"),
    ("BotFreeMatchTemplates", "mt"),
    ("BotFreeReplyChat", "replychat"),
    ("BotCheckReplyChatIntegrety", "replychat"),
    ("BotCheckChatMessageIntegrety", "stringlist"),
    ("BotFindStringInList", "list"),
    # AAS_UnlinkFromAreas, AAS_UnlinkFromBSPLeaves, and AAS_BestReachableLinkArea walk a link list that a caller hands as NULL,
    # be_aas_sample.cpp:1175, be_aas_bspq3.cpp:206, and be_aas_reach.cpp:168.
    ("AAS_UnlinkFromAreas", "areas"),
    ("AAS_UnlinkFromBSPLeaves", "leaves"),
    ("AAS_BestReachableLinkArea", "areas"),
    # PC_ExpandDefine hands `parms[parmnum]`, NULL for an empty argument, to PC_StringizeTokens at l_precomp.cpp:848.
    ("PC_StringizeTokens", "tokens"),
    # FreeFuzzySeperators_r tests `!fs` at be_ai_weight.cpp:97, and ReadFuzzySeperators_r hands it a NULL `firstfs`.
    ("FreeFuzzySeperators_r", "fs"),
    ("BotGetReachabilityToGoal", "avoidspots"),
    # The module hands NULL for an unused variable through the export, and the bodies test `if (var0)` at be_ai_chat.cpp:2499 and :2682, row X24 P19.
    ("BotInitialChat", "var0"), ("BotInitialChat", "var1"), ("BotInitialChat", "var2"), ("BotInitialChat", "var3"),
    ("BotInitialChat", "var4"), ("BotInitialChat", "var5"), ("BotInitialChat", "var6"), ("BotInitialChat", "var7"),
    ("BotReplyChat", "var0"), ("BotReplyChat", "var1"), ("BotReplyChat", "var2"), ("BotReplyChat", "var3"),
    ("BotReplyChat", "var4"), ("BotReplyChat", "var5"), ("BotReplyChat", "var6"), ("BotReplyChat", "var7"),
}
# (struct, field) pairs of a record pointer field a body indexes through a local copy or a `++` walk, which the subscript sweep cannot see.
# The view gives the field its `<field>Slots` accessor, as the sweep does for a field a body indexes in place.
# FS_LoadZipFile copies `pak->buildBuffer` into a local and indexes it at files_pc.cpp:1635 to :1641, row FC1.
# CM_TracePointThroughPatchCollide walks `pc->facets` with `facet++` at cm_patch.cpp:1288, row P5.
INDEXED_FIELDS = {
    ("pack_t", "buildBuffer"),
    ("patchCollide_t", "facets"),
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
