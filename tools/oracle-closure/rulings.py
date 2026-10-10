"""rulings.py: every mapping the generators apply by name, in one file.

A shape rule, a C type pattern that maps to one Swift spelling for every function, lives in table.py. A name rule, this
struct gets a view, this function returns raw memory, this field is never NULL, lives here. Each entry cites the ruling
in docs/transcription.md by its section, and an entry joins only by a ruling, never by a generator's guess.

The kinds a PARAMS entry may name are the ones table.py knows how to cross. A new kind is a shape rule first.
"""

from __future__ import annotations

from dataclasses import dataclass

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
    # vmMain reads these ICARUS structs through gSharedBuffer, and no root field points at them.
    "T_G_ICARUS_PLAYSOUND": ("IcarusPlaySound", "CJKAMP_Game"),
    "T_G_ICARUS_SET": ("IcarusSet", "CJKAMP_Game"),
    "T_G_ICARUS_LERP2POS": ("IcarusLerp2Pos", "CJKAMP_Game"),
    "T_G_ICARUS_LERP2ORIGIN": ("IcarusLerp2Origin", "CJKAMP_Game"),
    "T_G_ICARUS_LERP2ANGLES": ("IcarusLerp2Angles", "CJKAMP_Game"),
    "T_G_ICARUS_GETTAG": ("IcarusGetTag", "CJKAMP_Game"),
    "T_G_ICARUS_LERP2START": ("IcarusLerp2Start", "CJKAMP_Game"),
    "T_G_ICARUS_LERP2END": ("IcarusLerp2End", "CJKAMP_Game"),
    "T_G_ICARUS_USE": ("IcarusUse", "CJKAMP_Game"),
    "T_G_ICARUS_KILL": ("IcarusKill", "CJKAMP_Game"),
    "T_G_ICARUS_REMOVE": ("IcarusRemove", "CJKAMP_Game"),
    "T_G_ICARUS_PLAY": ("IcarusPlay", "CJKAMP_Game"),
    "T_G_ICARUS_GETFLOAT": ("IcarusGetFloat", "CJKAMP_Game"),
    "T_G_ICARUS_GETVECTOR": ("IcarusGetVector", "CJKAMP_Game"),
    "T_G_ICARUS_GETSTRING": ("IcarusGetString", "CJKAMP_Game"),
    "T_G_ICARUS_SOUNDINDEX": ("IcarusSoundIndex", "CJKAMP_Game"),
    "T_G_ICARUS_GETSETIDFORSTRING": ("IcarusGetSetIDForString", "CJKAMP_Game"),
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

# (struct, field) pairs whose pointer a body indexes, with the C macro that bounds the records behind the pointer.
# C gives a pointer no bound, and this names Raven's own, which the view spells as the module exports it.
# A field the rule does not name keeps the widest count, because no ruling has given it a bound.
# See docket row 8 of the bg walk of 2026-09-18.
SLOT_BOUNDS = {
    ("bgLoadedAnim_t", "anims"): "MAX_ANIMATIONS",
    ("pmove_t", "animations"): "MAX_ANIMATIONS",
    ("level_locals_t", "clients"): "MAX_CLIENTS",
}

# File-scope variables a body reads with no bind, because Raven's callers always set them before any body runs.
# The stub forwards each one non-optional and traps on nil with the variable's name, as a view field in NEVER_NULL does.
NEVER_NULL_VARS = {"pm"}

# File-scope variables whose storage is hand work on the state object, because the generated shape is wrong for them.
# `bg_pool` is the raw allocation of rule 9 that `BG_Alloc` hands pointers into, `bg.pool`, sized by the consumer's `MAX_POOL_SIZE`.
# `memoryPool` is the raw allocation of rule 9 that `G_Alloc` hands pointers into, `world.memoryPool`, of `POOLSIZE` bytes the world owns.
HAND_VARS = {"bg_pool": "bg.pool", "memoryPool": "world.memoryPool"}

# File-scope character arrays whose address the engine holds, so each one is one zeroed byte allocation on the storage class, not a `CharBuf`.
# `gSharedBuffer` of g_main.c goes to the engine through `trap_SV_RegisterSharedMemory`, and vmMain reads the ICARUS views at its base.
# See "The post-spine walk", row P1, and the zeroed storage rule of docs/transcription.md.
BYTE_STORAGE_VARS = {"gSharedBuffer"}

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

# C typedef -> the Swift type it is at every surface, where the C definition alone does not say.
# qint64 is Raven's struct of eight bytes from before the compilers had a portable 64-bit integer, and only the byte-swap pair touches it.
TYPES = {
    "qint64": "Int64",
}

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

# Allocators whose `char *` result a body holds as a CharBuf of the constant size Raven asks for, when every store into the local is that call.
# The allocation call and its free stay on the page, so the pool keeps Raven's count. See row 1 of the walk of 2026-10-01.
CHARBUF_ALLOCS = {"B_TempAlloc"}

# (function, parameter) -> the kind of the parameter, where the C type alone does not say.
#   raw       an UnsafeMutableRawPointer a body writes at a byte offset, see "Typed access at a byte offset"
#   vec3_mut  an inout vec3_t for a `float *` Raven fills as three floats, see "A pointer out-param Raven indexes"
#   out_string  an inout String, for a `const char **` the function sets to the token instead of walking
#   text_cursor  a TextCursor by value, for a `const char *` Raven passes as a cursor and returns advanced
#   fill_buffer  a `char *` a trap fills with no size beside it, given as ("fill_buffer", capacity) with the capacity Raven's
#                callers declare for the buffer, and the trap returns the String the same way a sized buffer does
#   float_array  an inout [Float] for a `float *` a body fills as a matrix of the counts beside it, or as a fixed count of floats
#   int_array  an [Int32]? by value for a read-only `int *` with a count beside it, and a caller's NULL is nil
#   pointer_table  a Slots<View?> over a file-scope array of struct pointers, whose base a trap hands to the engine
#   key_path  a KeyPath<Entity, String?> for an `int` field offset Raven takes from `FOFS(field)`, which a call site spells `\.field`
PARAMS = {
    ("COM_ParseString", "s"): "out_string",
    # A `char **` the function sets once to a string it owns, never walked, the same shape as the const one.
    ("G_SpawnString", "out"): "out_string",
    ("Q3_GetString", "value"): "out_string",
    ("SkipWhitespace", "data"): "text_cursor",
    ("trap_Bot_UpdateWaypoints", "wps"): "pointer_table",
    ("BG_ParseField", "ent"): "raw",
    ("BG_ValidateSkinForTeam", "colors"): "vec3_mut",
    ("G_SpawnVector", "out"): "vec3_mut",
    ("trap_SnapVector", "v"): "vec3_mut",
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
    ("trap_SV_RegisterSharedMemory", "memory"): "raw",
    # Raven's callers declare `char GLAName[MAX_QPATH]` in g_client.c and `char GLAName[1024]` in NPC_spawn.c, and the trap takes the larger.
    # `char hitSurface[MAX_QPATH]` is the one size for the surface name.
    ("trap_G2API_GetGLAName", "fillBuf"): ("fill_buffer", "1024"),
    ("trap_G2API_GetSurfaceName", "fillBuf"): ("fill_buffer", "JKAShared.MAX_QPATH"),
    # A pointer to a table of records the body indexes, `table[i]`, crosses as the Slots over the table.
    ("GetIDForString", "table"): "table",
    ("GetStringForID", "table"): "table",
    ("BG_SiegeTranslateGenericTable", "table"): "table",
    # Raven's callers pass `FOFS(classname)`, `FOFS(targetname)`, `FOFS(target)`, and `FOFS(script_targetname)`, each a `char *` field.
    ("G_Find", "fieldofs"): "key_path",
}

# Functions of the oracle the port leaves out. The stub carries the cite, Raven's line, and the reason, and no function.
NOT_PORTED = {
    "memmove": "the C library's, which no body of the module calls, and a Swift body moves bytes through CharBuf and a view's setter",
    "BotEntityInfo": "no caller in the module, and the botlib record it forwards belongs to the engine, which the module reaches through trap_AAS_EntityInfo alone. "
                     "A view over aas_entityinfo_t of be_aas.h is the fallback if a ported body calls it",
    # A trap no file of the module calls gets its shape when a module that calls it is generated.
    "trap_UnifyWhiteSpaces": "no caller in the game module, and its `char *` rewritten in place is shaped when a module that calls it is generated",
    "trap_AAS_TraceAreas": "no caller in the game module, and its arrays the engine fills are shaped when a module that calls it is generated",
    # bg_lib's qsort group, by the oracle names. The hand helpers `insertion` and `qsortSpan` hold parts of Raven's qsort body and have no oracle function.
    "swapfunc": "Raven's byte-swap qsort has no view form, and the hand port is generic over the element type",
    "med3": "Raven's byte-swap qsort has no view form, and the hand port is generic over the element type",
    "qsort": "Raven's byte-swap qsort has no view form, and the hand port is generic over the element type",
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
LIBC_SPELLINGS = {"fabs": "abs", "fabsf": "abs"}

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
# A game arm of a bg body under `#ifdef QAGAME` that reads the game's tables is one callback, R30 of the walk of 2026-10-05.
# The game defines the function by hand in Sources/JKAMP_GameLogic/bg_pmove_game.swift, and installBgChannel points the closure at it.
# name -> (the cite of Raven's arm, the parameters as (name, Swift type) pairs)
ARM_HOOKS = {
    "bgLandOnVehicle": ("oracle/codemp/game/bg_pmove.c:4234", [("entityNum", "Int32")]),
    "bgSetSolidHack": ("oracle/codemp/game/bg_pmove.c:4448", [("clientNum", "Int32")]),
}
# A function Raven compiles only under `#ifdef QAGAME` is a game function, R31. The game defines it by hand beside the arm hooks,
# and the bg body reaches it through the channel. name -> the cite of Raven's definition
QAGAME_ONLY = {"PM_CrashLandEffect": "oracle/codemp/game/bg_pmove.c:3684"}
# (function, parameter) pairs a ruling makes optional, because a caller passes a NULL the sweep cannot see. R33.
NULLABLE = {
    ("BG_UnrestrainedPitchRoll", "pVeh"),
    # G_UseTargets passes its optional activator, which g_mover.c:1752 passes as NULL, and `ent->target`, which Raven tests with `!string || !string[0]`.
    ("G_UseTargets2", "activator"),
    ("G_UseTargets2", "string"),
    # G_UseTargets2 passes its optional activator, and GlobalUse passes it on to the use callback, whose runUse helper takes an optional.
    ("GlobalUse", "activator"),
    # G_G2PlayerAngles of w_saber.c sets emplaced only when ps.emplacedIndex is non-zero and passes NULL otherwise, and the body tests it at bg_pmove.c:9235 and 9354.
    ("BG_G2PlayerAngles", "emplaced"),
}
# Files whose functions a bg body reaches directly, because they live in the shared module or in bg itself.
# The functions whose integer arithmetic is a generator or a hash, where C wraps at 32 bits and Swift's plain operators trap.
WRAPPING_ARITHMETIC = {"Q_rand", "Q_random", "Q_crandom", "rand", "srand", "irand", "flrand", "Q_irand", "Q_flrand", "Rand_Init", "Q_HashKey"}

# (trap, parameter) pairs of a view parameter that gets a second overload of the trap, which takes the view as optional.
# Raven hands the trap a NULL through a table row, which the NULL sweep cannot see at the call site.
# See row 4a of the game globals walk.
NIL_OVERLOADS = {
    ("trap_Cvar_Register", "cvar"): "the three rows of gameCvarTable in g_main.c with a NULL handle, gamename, gamedate, and sv_mapname",
}

# The traps whose buffer holds a NUL-separated list, which a caller walks past the first NUL, so the trap returns every byte as a CharBuf.
LIST_TRAPS = {"trap_FS_GetFileList"}

SHARED_STEMS = {"q_shared", "q_math", "g_syscalls", "g_strap"}

# MARK: - C storage beside the extracted headers

# Hand-written headers a target's umbrella includes after the extracted ones, one per file of C storage under Sources/<Target>/.
# See "Raven's tables as C storage". merge.py keeps these files across a rewrite of the target.
# `bg_tables.c` and `g_tables.c` are not among them: tables.py writes them, and it runs after the merge.
# g_types.h holds the structs Raven defines inside a .c file, so a view can bind over them. See "A struct Raven defines inside a .c file".
# g_tables.h declares the six game tables of g_tables.c, ruling E2.
HAND_HEADERS = {"CJKAMP": ["bg_tables.h"], "CJKAMP_Game": ["g_types.h", "g_tables.h"]}
HAND_FILES = {"CJKAMP": ["include/bg_tables.h"], "CJKAMP_Game": ["include/g_types.h", "include/g_tables.h"]}

# MARK: - Header preludes

# Oracle header -> (the .c file, first line, last line) of the text a header needs before it, which the .c file writes before its include.
# The header parse writes that slice into its synthetic translation unit before the header's include.
# The .c enum test then keeps the enum of the slice in the constants file of its .c file.
# interpreter.h opens its token enum at `TK_USERDEF`, which only the enum at g_ICARUScb.c:31-44 declares, as Raven's comment at interpreter.h:13 says.
# The slice starts at the enum and not at the comment on line 20, because the `#ifndef` pair around the enum closes on lines 45 and 46.
HEADER_PRELUDES = {
    "codemp/icarus/interpreter.h": ("codemp/game/g_ICARUScb.c", 31, 44),
}
