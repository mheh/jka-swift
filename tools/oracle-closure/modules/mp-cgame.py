# The bg .c files include ghoul2/G2.h, which no module header reaches, so the entry lists it too.
SPEC = dict(
    name="mp-cgame",
    lang="c", entry=["codemp/cgame/cg_local.h", "codemp/cgame/cg_lights.h", "codemp/ghoul2/G2.h"],
    includes=["codemp/cgame", "codemp/game", "codemp/ui"],
    defines=["NDEBUG", "MISSIONPACK", "CGAME", "_JK2"],
    srcglob=["codemp/cgame/*.c", "codemp/game/bg_*.c", "codemp/ui/ui_shared.c"],
)
