# The header parse reads the derived entry list of closure.py: each oracle header a cgame, bg, or ui_shared .c file includes, in order of first reach.
# A header that another listed header reaches is left out, so a header with no include guard is parsed once.
SPEC = dict(
    name="mp-cgame",
    lang="c",
    includes=["codemp/cgame", "codemp/game", "codemp/ui"],
    defines=["NDEBUG", "MISSIONPACK", "CGAME", "_JK2"],
    srcglob=["codemp/cgame/*.c", "codemp/game/bg_*.c", "codemp/ui/ui_shared.c"],
)
