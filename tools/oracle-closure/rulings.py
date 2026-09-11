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
    "stringID_table_t": ("StringIDTable", "CJKAMP"),
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
}

# (struct, field) pairs whose pointer Raven's callers always set. The field is non-optional, and its getter traps with the
# field's name when the pointer is NULL, the one divergence rule 19 allows. See "A pointer field Raven's callers always set".
NEVER_NULL = {
    ("pmove_t", "ps"),
    ("pmove_t", "trace"),
    ("pmove_t", "pointcontents"),
}

# MARK: - Functions

# Function -> the kind of its return, where the C type alone does not say. See "The bg pool" and "C string functions".
#   raw            an UnsafeMutableRawPointer into the pool, the only Swift type a view can bind over
#   pooled_string  a PooledString, the type a `char *` field carries
#   text_cursor    a pointer into the caller's text, the COM_Parse family, which keeps its marker until that row is ruled
#   optional_string  a String?, for a `char *` return Raven sets to NULL on one path
#   in_place       Void, for a function that rewrites its `char *` argument and returns it
#   text_offset    an Int32? byte offset into the argument, or nil, the shape strchr has in CString.swift
#   text_offset_nonnull  an Int32 byte offset into the argument that is never NULL
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
    "BG_StringAlloc": "pooled_string",
    "G_NewString": "pooled_string",
}

# (function, parameter) -> the kind of the parameter, where the C type alone does not say.
#   raw       an UnsafeMutableRawPointer a body writes at a byte offset, see "Typed access at a byte offset"
#   vec3_mut  an inout vec3_t for a `float *` Raven fills as three floats, see "A pointer out-param Raven indexes"
#   pointer_array  a C array of struct pointers a trap reads, a storage table's base, which keeps its marker until that storage is ruled
PARAMS = {
    ("trap_Bot_UpdateWaypoints", "wps"): "pointer_array",
    ("BG_ParseField", "ent"): "raw",
    ("BG_ValidateSkinForTeam", "colors"): "vec3_mut",
}

# MARK: - The bg channel

# Functions bg reaches through hooks of their own, not through the channel. See rule 23.
OWN_HOOKS = {"Com_Error", "Com_Printf"}
# Files whose functions a bg body reaches directly, because they live in the shared module or in bg itself.
SHARED_STEMS = {"q_shared", "q_math", "g_syscalls", "g_strap"}

# MARK: - C storage beside the extracted headers

# Hand-written headers a target's umbrella includes after the extracted ones, one per file of C storage under Sources/<Target>/.
# See "Raven's tables as C storage". merge.py keeps these files across a rewrite of the target.
# g_types.h holds the structs Raven defines inside a .c file, so a view can bind over them. See "A struct Raven defines inside a .c file".
HAND_HEADERS = {"CJKAMP": ["bg_tables.h"], "CJKAMP_Game": ["g_types.h"]}
HAND_FILES = {"CJKAMP": ["bg_tables.c", "include/bg_tables.h"], "CJKAMP_Game": ["include/g_types.h"]}
