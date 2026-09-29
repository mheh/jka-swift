# MP tree (codemp/), a plain C module.

# The header parse reads the derived entry list of closure.py: each oracle header a game .c file includes, in order of first reach.
# A header that another listed header reaches is left out, so a header with no include guard is parsed once.
SPEC = dict(
    name="mp-game",
    lang="c",
    includes=["codemp/game"],
    defines=["NDEBUG", "MISSIONPACK", "QAGAME", "_JK2"],
    srcglob=["codemp/game/*.c"],
    # menudef.h defines CT_LTBLUE1 and three more names that q_shared.h's ct_table_t enum declares.
    # A second module that emits it moves it to CJKAMP, where the umbrella puts every constants file before every type, and the enum breaks.
    exclude=["ui/menudef.h"],
)
