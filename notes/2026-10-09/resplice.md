# The q_shared re-splice

## The gate

The builder ran `draftcheck.py --stem q_shared,g_main` in the worktree `spine` on the branch `resplice`, level with `c0afb19`. The wall time was 190 seconds over 5 passes and 5 builds.

- q_shared: 50 of 56 hand functions replaced, 6 kept, 151 holes, 0 cascade errors, 0 defects, 14 compile holes over 2 passes.
- g_main: 45 of 49 hand functions replaced, 4 kept, 90 holes, 0 cascade errors, 0 defects, 18 compile holes over 4 passes.

The references at `cd9460c` were 152 holes and 15 compile holes for q_shared, and 90 holes and 18 compile holes for g_main. R4 lowered q_shared by 1 hole and 1 compile hole.

Finding: the gate kept 6 functions of q_shared, not 4. The four hand functions are `Q_stricmpn`, `Q_strncmp`, `Q_stricmp`, and `va`. The gate also kept `Q_strncpyz` and `Info_NextPair`, because `align.py` marks the bodies of the previous splice `edited` against the new drafts. So the gate did not build the new drafts of these two functions.

## The print

The stem print stopped because the lowered rows were stale. `bodies.py --stem q_shared --compile-holes` reset the rows, and then `printer.py --only <name> --compile-holes` printed each function. The printer stopped on 11 functions, because `bodies.py` keeps the rows of a function with a compile hole in memory only. These 11 came from `bodies.py --only <name> --compile-holes`: `COM_ParseExt`, `COM_MatchToken`, `Parse2DMatrix`, `Parse3DMatrix`, `Q_strcat`, `Com_sprintf`, `Info_ValueForKey`, `Info_RemoveKey`, `Info_RemoveKey_Big`, `Info_SetValueForKey`, and `Info_SetValueForKey_Big`.

A script keyed on the `/// Source:` lines spliced the 52 drafted functions and kept the four hand functions and every signature line.

## The hand conversions

Two statements of `Q_strncpyz` did not compile, and each is now a compile hole in the `COMPILE_NOTE` form. The first is `Com_Error(ERR_FATAL, ...)`, and the compiler wrote "cannot find 'ERR_FATAL' in scope". The second is `strncpy(&dest, src, destsize - 1, at: destIndex)`, and the compiler wrote "extra argument 'at' in call". The new draft of `Info_NextPair` compiled with no change.

## The counts

Before the re-splice, the file held 159 Port-notes and 155 lines that start with `portMissing(`. After it, the file holds 145 Port-notes and 141 such lines.

The align run gave these lines, with 0 stub rows in both stems:

- q_shared: 1065 same, 8 edited, 79 hand, 5 rewritten, 0 stub
- g_main: 3065 same, 0 edited, 54 hand, 17 rewritten, 0 stub

The align run needed the line rows in the store first, so the builder ran `bodies.py --stem q_shared` and `bodies.py --stem g_main` without `--compile-holes`.

`swift build` gives 0 errors. `swift test --no-parallel` passes 106 tests in four binaries: 78, 14, 13, and 1.

The re-splice is commit `9a7e849`.
