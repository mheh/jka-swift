"""The overlay every draft parse takes in front of a module's unity source: Raven's function-like macros as declared functions,
so each use parses as a call with real argument nodes, and the SDK's fortify macros undefined. bodies.py and channel.py share it,
so both read one parse shape."""

# Raven's function-like macros the draft maps, by the table of docs/transcription.md, "Vectors and the vector macros".
# The parse sees each one as a call, because the overlay below undefines the macro and declares a function under its name,
# so every argument is a node with its text, its type, and its tokens. The template writes the Swift form, `{0}` the first
# argument. `floats` names the argument positions that are one float, where an integer argument converts as C does.
MACROS = {
    "VectorAdd": ("{2} = {0} + {1}", ()),
    "VectorSubtract": ("{2} = {0} - {1}", ()),
    "VectorScale": ("{2} = {0} * {1}", (1,)),
    "VectorCopy": ("{1} = {0}", ()),
    "VectorMA": ("_VectorMA({0}, {1}, {2}, &{3})", (1,)),
    "VectorNegate": ("{1} = -{0}", ()),
    "VectorClear": ("{0} = JKAShared.vec3_t(0, 0, 0)", ()),
    "VectorSet": ("{0} = JKAShared.vec3_t({1}, {2}, {3})", (1, 2, 3)),
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
# The C return type each function takes in the overlay, so the use keeps the type Raven's expression had.
MACRO_RETURNS = {"DotProduct": "float", "Q_fabs": "float", "DEG2RAD": "float", "RAD2DEG": "float", "ANGLE2SHORT": "int",
                 "SHORT2ANGLE": "float", "min": "float", "max": "float"}
# `assert` is `((void)0)` under Raven's NDEBUG build, and the overlay makes it a call the draft drops by name.
DROPPED = {"assert"}
# The SDK's fortify macros rename `memset` and `memcpy` to builtins with an extra argument, so the overlay undefines them and string.h's prototypes serve.
UNDEFINED = ("memset", "memcpy", "strcpy", "strcat")
RECORD_CALLS = ("memset", "memcpy")
OVERLAY = "".join(f"#undef {name}\n{MACRO_RETURNS.get(name, 'void')} {name}(...);\n" for name in list(MACROS) + sorted(DROPPED)) + "".join(f"#undef {name}\n" for name in UNDEFINED)
