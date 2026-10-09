# The six spine changes

The builder did the six code changes of `notes/2026-10-08/spine-review-walk.md` on branch `spine`, one commit for each item. Every `swift build` gave 0 errors, and every `swift test --no-parallel` ran 106 tests in four binaries, 78, 14, 13, and 1, with no failure.

## Item 1, the table signatures (R1)

`ShortSwap` and `ShortNoSwap` take and return `Int32`, and `COM_MatchToken` takes `match` as `String`. The `ShortSwap` body is the printed draft at `/tmp/spine/spine-q_shared.swift` lines 132-140. The order named lines 133-139, but the function spans lines 132-140 in that file, which is the span the R1 proof gives. Commit `8bebf79`.

## Item 2, the shared channel (R2)

The new file `Sources/JKAShared/Channel.swift` holds the class `SharedChannel` with the closures `error` and `print`, a default that traps with the text, the instance `sharedChannel`, and the public functions `Com_Error` and `Com_Printf` that forward through `format`. `dllEntry` in `Sources/jampgame/jampgame.swift` installs the two closures after `installBgChannel()`. Departure: the public shared functions made the bare names ambiguous in `Tests/JKAMPTests/ComErrorTests.swift`, so the two calls there now name `JKAMP_BG`. Commit `97cf4bb`.

## Item 3, the parser globals (R3)

The three `TODO: Port global` markers became `private nonisolated(unsafe) var` lines for `com_token`, `com_parsename`, and `com_lines`, each under its `/// Source:` line. Commit `f12e536`.

## Item 4, the shared stems in the gate (R9)

`draftcheck.py --every` adds `SHARED`, and the usage line and the help text name the shared stems. The tool tests ran 63 tests, with 9 skipped and no failure. Departure: the worktree had no `oracle` checkout, so one tool test failed before the change and after it. The builder ran `git submodule update --init oracle` in the worktree, and then all tests passed. Commit `70c3985`.

## Item 5, the gate and the re-splice (R7, R9)

The builder made the venv and copied the store of the main checkout into the worktree. The tool ran on the worktree only. The stock run of `draftcheck.py --stem q_shared` reported 137 holes, 0 cascade errors, 3 defects, and 0 compile holes over 1 pass. The three defects are redeclarations of `Q_stricmpn`, `Q_strncmp`, and `Q_stricmp`. The gate splices the draft over the four hand functions too, and the draft of each of those three collides with its hand `String` overload. These errors stop the type check, so the stock count of compile holes is not true. A re-splice from that print failed the build with about 40 errors.

Departure: a driver script at `/tmp/spine2/drv/keep_hand.py` imported `draftcheck.py` without an edit and ran its `gate()` with a `functions` filter that skips the Raven lines 842, 881, 900, and 1017 of the four hand functions. That run reported 167 holes, 0 cascade errors, 0 defects, and 35 compile holes over 2 passes, and it wrote the rejected rows to the store. `bodies.py` lowered the rows again first, because `Channel.swift` changed the declaration lines. The 52 drafted functions then came from `printer.py --only <name> --compile-holes`, one function at a time. The printer stopped on `Q_strrchr`, so that function came from `bodies.py --compile-holes`. A script keyed on the `/// Source:` lines spliced the 52 and kept the four hand functions. The build gave 0 errors with no hand conversion, so no statement needed a hand compile hole. The file holds 159 Port-notes and 155 lines that start with `portMissing(`. Commit `616965d`.

A later ruling can choose to teach the gate the hand functions of a stem, so the stock run gives the true count.

## Item 6, the record (R8, R9)

`notes/2026-10-08/spine-round.md` has the sentence on the six absorbed holes and a new section with the shared reference. Commit `4d77405`.
