# The q_shared rulings build walk

The walk of the two docket rows in `q_shared-rulings-build.md`, under the ratification-walk skill. The rows are R1 and R2 in the record and S1 and S2 here, because `g_main-rulings-walk.md` of the same day holds a row R1. Both rows were ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| S1 | ratified as proposed, replaces Q1 | Two private constants at the top of `q_shared.c.swift`, `ERR_FATAL` as 0 and `ERR_DROP` as 1, under `/// Source: oracle/codemp/game/q_shared.h:451`. This is the guide's form for an enum that cannot reach its module. Both trees give these two cases the same values. The nine `Com_Error` calls then fill by hand. `private` keeps the names out of the files that import JKAMP. The reexport route of Q1 is closed, because the merge puts `errorParm_t` in CJKAMP alone: the SP tree declares it without `ERR_SERVERDISCONNECT`. |
| S2 | ratified as proposed | The re-splice procedure in `g_main-resplice.md` gains the step: after a draftcheck run, `bodies.py --stem <stem>` lowers the line rows again before `printer.py --compile-holes` prints. |
