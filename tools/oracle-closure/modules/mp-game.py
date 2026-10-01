# MP tree (codemp/), a plain C module.

# The header parse reads the derived entry list of closure.py: each oracle header a game .c file includes, in order of first reach.
# A header that another listed header reaches is left out, so a header with no include guard is parsed once.
SPEC = dict(
    name="mp-game",
    lang="c",
    includes=["codemp/game"],
    defines=["NDEBUG", "MISSIONPACK", "QAGAME", "_JK2"],
    srcglob=["codemp/game/*.c"],
)
