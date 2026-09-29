# bg_* compiles into game/cgame/ui; parse it through the game TU. Alias
# so tier-named callers (crate mp_bg) resolve without knowing that.

# The header parse reads the derived entry list of closure.py: each oracle header a bg .c file includes, in order of first reach.
# A header that another listed header reaches is left out, and a header the exclude list names is left out too.
SPEC = dict(
    name="mp-bg",
    lang="c",
    includes=["codemp/game"],
    defines=["NDEBUG", "MISSIONPACK", "QAGAME", "_JK2"],
    srcglob=["codemp/game/bg_*.c"],
    # The bg .c files include g_local.h under QAGAME, and merge.py keeps game types out of the bg tree target, so the derived list drops it.
    exclude=["codemp/game/g_local.h"],
)
