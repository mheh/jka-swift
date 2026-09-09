SPEC = dict(
    name="sp-bg",
    lang="c++", entry=["code/game/q_shared.h", "code/game/bg_public.h", "code/game/bg_local.h"],
    includes=["code/game", "code"],
    defines=["NDEBUG", "_IMMERSION"],
    srcglob=["code/game/bg_*.cpp"],
)
