"""The overlay every draft parse takes in front of a module's unity source: Raven's function-like macros as declared functions,
so each use parses as a call with real argument nodes, and the SDK's fortify macros undefined. bodies.py and channel.py share it,
so both read one parse shape."""

# Raven's function-like macros the draft maps, by the table of docs/transcription.md, "Vectors and the vector macros".
# The parse sees each one as a call, because the overlay below undefines the macro and declares a function under its name,
# so every argument is a node with its text, its type, and its tokens. The template writes the Swift form, `{0}` the first
# argument. `floats` names the argument positions that are one float, where an integer argument converts as C does.
MACROS = {
    # Raven's zero-argument draws, hand functions in bg_lib.swift.
    "random": ("random()", ()),
    "crandom": ("crandom()", ()),
    "VectorAdd": ("{2} = {0} + {1}", ()),
    "VectorSubtract": ("{2} = {0} - {1}", ()),
    "VectorScale": ("{2} = {0} * {1}", (1,)),
    "VectorCopy": ("{1} = {0}", ()),
    "VectorMA": ("_VectorMA({0}, {1}, {2}, &{3})", (1,)),
    "VectorNegate": ("{1} = -{0}", ()),
    "VectorClear": ("{0} = vec3_t()", ()),
    "VectorSet": ("{0} = vec3_t({1}, {2}, {3})", (1, 2, 3)),
    "DotProduct": ("_DotProduct({0}, {1})", ()),
    "Q_fabs": ("Q_fabs({0})", (0,)),
    "DEG2RAD": ("DEG2RAD({0})", (0,)),
    "RAD2DEG": ("RAD2DEG({0})", (0,)),
    "ANGLE2SHORT": ("ANGLE2SHORT({0})", (0,)),
    "SHORT2ANGLE": ("SHORT2ANGLE({0})", ()),
    "SnapVector": ("SnapVector(&{0})", ()),
    "min": ("min({0}, {1})", ()),
    "max": ("max({0}, {1})", ()),
}


def address_arguments(name: str) -> set[int]:
    """The argument positions the Swift form of a macro takes by address, the `&{3}` of `VectorMA`.
    Two such positions over one array conflict, because Swift holds both as `inout`."""
    template = MACROS[name][0]
    return {i for i in range(template.count("{")) if f"&{{{i}}}" in template}


def written_arguments(name: str) -> set[int]:
    """The argument positions a macro writes: the destination of its assignment, and every position it takes by address.
    `VectorCopy` is `{1} = {0}`, so it writes argument 1 and reads argument 0.
    A caller that sees a write in any argument of a call reads this set first, so a source argument of a macro is not a write."""
    template = MACROS[name][0]
    written = address_arguments(name)
    head, assignment, _ = template.partition("=")
    destination = head.strip()
    if assignment and destination.startswith("{") and destination.endswith("}"):
        written.add(int(destination[1:-1]))
    return written


# The C return type each function takes in the overlay, so the use keeps the type Raven's expression had.
MACRO_RETURNS = {"DotProduct": "float", "Q_fabs": "float", "DEG2RAD": "float", "RAD2DEG": "float", "ANGLE2SHORT": "int",
                 "SHORT2ANGLE": "float", "min": "float", "max": "float", "random": "float", "crandom": "double",
                 "FOFS": "int", "DOT": "float"}
# Function-like macros with no Swift form, declared so a use parses as a call with argument nodes, and the call is a hole by name.
# FOFS is g_local.h's field offset. The rest are tri_coll_test.c's, which that file defines after the overlay, so the unity source repeats the overlay after each file.
DECLARED = {"FOFS", "CROSS", "DOT", "SUB", "SORT", "ISECT", "COMPUTE_INTERVALS", "EDGE_EDGE_TEST", "EDGE_AGAINST_TRI_EDGES", "POINT_IN_TRI"}
# `assert` is `((void)0)` under Raven's NDEBUG build, and the overlay makes it a call the draft drops by name.
DROPPED = {"assert"}
# The SDK's fortify macros rename `memset` and `memcpy` to builtins with an extra argument, so the overlay undefines them and string.h's prototypes serve.
UNDEFINED = ("memset", "memcpy", "memmove", "strcpy", "strcat", "strncpy", "vsprintf")
RECORD_CALLS = ("memset", "memcpy")
# The prototypes of four functions that a stale `extern` in AnimalNPC.c or NPC_AI_Jedi.c declares with the wrong parameters before
# the definition. The first declaration wins in the parse, so these stand first and every call resolves to the definition's shape.
PROTOTYPES = """typedef struct gentity_s gentity_t;
void PM_SetAnim(int setAnimParts, int anim, int setAnimFlags, int blendTime);
void G_Knockdown(gentity_t *victim);
qboolean WP_ForcePowerUsable(gentity_t *self, forcePowers_t forcePower);
qboolean NPC_CheckEnemyStealth(gentity_t *target);
"""
OVERLAY = PROTOTYPES + "".join(f"#undef {name}\n{MACRO_RETURNS.get(name, 'void')} {name}(...);\n" for name in list(MACROS) + sorted(DROPPED) + sorted(DECLARED)) + "".join(f"#undef {name}\n" for name in UNDEFINED)
