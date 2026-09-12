"""rulings.py: every mapping the generators apply by name, in one file.

A shape rule, a C type pattern that maps to one Swift spelling for every function, lives in table.py. A name rule, this
struct gets a view, this function returns raw memory, this field is never NULL, lives here. Each entry cites the ruling
in docs/transcription.md by its section, and an entry joins only by a ruling, never by a generator's guess.

The kinds a PARAMS entry may name are the ones table.py knows how to cross. A new kind is a shape rule first.
"""

from __future__ import annotations

# MARK: - Views

# Root struct -> (view name, C target). Every other view takes Raven's typedef name with _t dropped and the first letter raised.
# A view is generated for a root and for every struct a root's field points at. See "The views".
ROOTS = {
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
    "failedEdge_t": ("FailedEdge", "CJKAMP_Game"),
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
    # bg_vehicleLoad.c defines this one, copied into bg_tables.h.
    "vehField_t": ("VehField", "CJKAMP"),
}

# (struct, field) pairs whose pointer Raven's callers always set. The field is non-optional, and its getter traps with the
# field's name when the pointer is NULL, the one divergence rule 19 allows. See "A pointer field Raven's callers always set".
NEVER_NULL = {
    ("pmove_t", "ps"),
    ("pmove_t", "trace"),
    ("pmove_t", "pointcontents"),
}

# File-scope variables a body reads with no bind, because Raven's callers always set them before any body runs.
# The stub forwards each one non-optional and traps on nil with the variable's name, as a view field in NEVER_NULL does.
NEVER_NULL_VARS = {"pm"}

# File-scope variables whose storage is hand work on the state object, because the generated shape is wrong for them.
# `bg_pool` is the raw allocation of rule 9 that `BG_Alloc` hands pointers into, `bg.pool`, sized by the consumer's `MAX_POOL_SIZE`.
HAND_VARS = {"bg_pool": "bg.pool"}

# .c macros whose value is hand work on the state object. `MAX_POOL_SIZE` is the consumer's value under rule 23, `bg.maxPoolSize`.
HAND_MACROS = {"MAX_POOL_SIZE": "bg.maxPoolSize, the consumer's value under rule 23, which bg_local.swift forwards under Raven's name"}

# MARK: - Types

# C typedef -> the Swift type it is at every surface, where the C definition alone does not say.
# qint64 is Raven's struct of eight bytes from before the compilers had a portable 64-bit integer, and only the byte-swap pair touches it.
TYPES = {
    "qint64": "Int64",
}

# MARK: - Functions

# Function -> the kind of its return, where the C type alone does not say. See "The bg pool" and "C string functions".
#   raw            an UnsafeMutableRawPointer into the pool, the only Swift type a view can bind over
#   pooled_string  a PooledString, the type a `char *` field carries
#   text_cursor    a TextCursor, a pointer into the caller's text that the function returns advanced
#   optional_string  a String?, for a `char *` return Raven sets to NULL on one path
#   in_place       Void, for a function that rewrites its `char *` argument and returns it
#   text_offset    an Int32? byte offset into the argument, or nil, the shape strchr has in CString.swift
#   text_offset_nonnull  an Int32 byte offset into the argument that is never NULL
#   vec3           a JKAShared.vec3_t by value, for a `float *` Raven returns out of a static ring of temporaries
RETURNS = {
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
    "BG_StringAlloc": "pooled_string",
    "G_NewString": "pooled_string",
    "tv": "vec3",
}

# (function, parameter) -> the kind of the parameter, where the C type alone does not say.
#   raw       an UnsafeMutableRawPointer a body writes at a byte offset, see "Typed access at a byte offset"
#   vec3_mut  an inout vec3_t for a `float *` Raven fills as three floats, see "A pointer out-param Raven indexes"
#   out_string  an inout String, for a `const char **` the function sets to the token instead of walking
#   text_cursor  a TextCursor by value, for a `const char *` Raven passes as a cursor and returns advanced
#   fill_buffer  a `char *` a trap fills with no size beside it, which keeps its marker until that shape is ruled
#   in_place  a `char *` a trap rewrites in place, which keeps its marker until that shape is ruled
#   out_array  an array the engine fills, sized by a count beside it, which keeps its marker until a caller needs that shape
#   float_array  an inout [Float] for a `float *` a body fills as a matrix of the counts beside it
#   pointer_table  a Slots<View?> over a file-scope array of struct pointers, whose base a trap hands to the engine
PARAMS = {
    ("COM_ParseString", "s"): "out_string",
    # A `char **` the function sets once to a string it owns, never walked, the same shape as the const one.
    ("G_SpawnString", "out"): "out_string",
    ("Q3_GetString", "value"): "out_string",
    ("SkipWhitespace", "data"): "text_cursor",
    ("trap_Bot_UpdateWaypoints", "wps"): "pointer_table",
    ("BG_ParseField", "ent"): "raw",
    ("BG_ValidateSkinForTeam", "colors"): "vec3_mut",
    ("trap_SnapVector", "v"): "vec3_mut",
    ("Parse1DMatrix", "m"): "float_array",
    ("Parse2DMatrix", "m"): "float_array",
    ("Parse3DMatrix", "m"): "float_array",
    ("trap_SV_RegisterSharedMemory", "memory"): "raw",
    ("trap_G2API_GetGLAName", "fillBuf"): "fill_buffer",
    ("trap_G2API_GetSurfaceName", "fillBuf"): "fill_buffer",
    ("trap_UnifyWhiteSpaces", "string"): "in_place",
    ("trap_AAS_TraceAreas", "areas"): "out_array",
    ("trap_AAS_TraceAreas", "points"): "out_array",
    # A pointer to a table of records the body indexes, `table[i]`, crosses as the Slots over the table.
    ("GetIDForString", "table"): "table",
    ("GetStringForID", "table"): "table",
}

# Functions of the oracle the port leaves out. The stub carries the cite, Raven's line, and the reason, and no function.
NOT_PORTED = {
    "memmove": "the C library's, which no body of the module calls, and a Swift body moves bytes through CharBuf and a view's setter",
    "BotEntityInfo": "no caller in the module, and the botlib record it forwards belongs to the engine, which the module reaches through trap_AAS_EntityInfo alone. "
                     "A view over aas_entityinfo_t of be_aas.h is the fallback if a ported body calls it",
}

# C library functions a .c file aliases, `#define sqrtf sqrt`, with the Swift signature the forwarder takes.
LIBC_FUNCTIONS = {"sqrt": ([("x", "Float")], "Float", "x.squareRoot()")}

# Header macros the port leaves out, with the reason the reexport carries instead of a marker.
NOT_PORTED_MACROS = {
    "MATERIALS": "a list of material names no body of the module names",
}

# MARK: - The bg channel

# Functions bg reaches through hooks of their own, not through the channel. See rule 23.
OWN_HOOKS = {"Com_Error", "Com_Printf"}
# A function bg calls that another consumer defines, so no game definition can shape it. The entry names the game function whose
# signature it shares and the definition's cite. The game consumer installs nothing, so the trapping default names it at the first call.
EXTRA_HOOKS = {"CG_NewString": ("G_NewString", "oracle/codemp/cgame/cg_main.c:3344")}
# Files whose functions a bg body reaches directly, because they live in the shared module or in bg itself.
SHARED_STEMS = {"q_shared", "q_math", "g_syscalls", "g_strap"}

# MARK: - C storage beside the extracted headers

# Hand-written headers a target's umbrella includes after the extracted ones, one per file of C storage under Sources/<Target>/.
# See "Raven's tables as C storage". merge.py keeps these files across a rewrite of the target.
# g_types.h holds the structs Raven defines inside a .c file, so a view can bind over them. See "A struct Raven defines inside a .c file".
HAND_HEADERS = {"CJKAMP": ["bg_tables.h"], "CJKAMP_Game": ["g_types.h"]}
HAND_FILES = {"CJKAMP": ["bg_tables.c", "include/bg_tables.h"], "CJKAMP_Game": ["include/g_types.h"]}
