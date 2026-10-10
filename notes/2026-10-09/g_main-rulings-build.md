# The g_main rulings build

The builder built rulings D1, D3, and D4 of `notes/2026-10-09/g_main-resplice-walk.md` in the main checkout on the branch `wave-0`, from `699746a`. Each step is one commit. The builder did not run `merge.py`, `tables.py`, `traps.py`, `channel.py`, `reexport.py`, or `manifest.py`.

## Step 1. Ruling D1, `3a10ea1`

The change. `optional_base` in `draft_classification.py` decides if a read through a pointer local takes `!`. For a local with no other rule, it returned true for every `VAR_DECL`, so the view local `sharedMem` read as `sharedMem!`. The new helper `byte_storage_view` in `draft_declarations.py` is true for a local whose initializer is a cast of a `BYTE_STORAGE_VARS` variable, the same test `byte_storage_cast` that item 3 of `post-spine-changes.md` uses for the declaration. `optional_base` returns false for such a local, so each read is plain, `sharedMem.taskID`. The new test `test_a_read_of_a_view_at_the_shared_byte_buffer_takes_no_force_unwrap` in `tests/test_shapes.py` drafts `vmMain` and checks that the text holds `sharedMem.` and no `sharedMem!`.

The tool tests. `SLOW=1 .venv/bin/python -m unittest discover -s tests` ran 78 tests, all passed, in 241 s.

The re-splice. `draftcheck.py --stem g_main` gave 33 of 49 hand functions replaced, 16 kept, 46 holes, 0 cascade errors, 0 defects, and 6 compile holes over 2 passes. `printer.py --stem g_main --compile-holes` stopped, first on stale lowered rows and then on no line rows for `vmMain`. So the builder took the print of `bodies.py --stem g_main --compile-holes`, whose text equals `.build-draft/drafts/g_main.swift` except the last line, the hole count. A script keyed on `/// Source: oracle/codemp/game/g_main.c:515` spliced only `vmMain`, from the Source line to its closing brace. The 15 compile holes on `sharedMem!` went, and each case now reads its view plain. The hole on `morecrap` in `GAME_ICARUS_GETSTRING` stays, because the draft does not handle it.

The gate. `swift build` gave 0 errors. `swift test --no-parallel` passed 106 tests in four binaries: 78, 14, 13, and 1. The second `draftcheck.py --stem g_main` gave the same figures as the first.

## Step 2. Rulings D3 and D4, `7b3a598`

`G_InitGame`. The register call `trap_SV_RegisterSharedMemory(gSharedBuffer)` from the gated draft compiles, and its Port-note and `portMissing` call went. The seed call `JKAMP_BG.srand(randomSeed)` from the draft does not compile in the hand body, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'UInt32'". `srand` in `Sources/JKAMP_BG/bg_lib.swift` takes a `UInt32`, Raven passes an `int`, and C converts the value with no cast on the page. The guide has no form for this conversion, and a body adds no cast Raven did not write, so the seed call keeps its Port-note and its `portMissing` call. See row R1.

`CheckCvars`. The body reads and writes `lastMod` through its forward. Raven's `char *c = password` is a write cursor, so it is the byte offset `var c: Int32 = 0` over the `CharBuf` `password`, under "The text cursor" in the guide. The body passes `String(password)` to `trap_Cvar_Set`. Its two Port-notes and two `portMissing` calls went.

`G_GetStringEdString`. The body writes `text` through its forward with `Com_sprintf(&text, Int32((text).count), "@@@%s", refName)` and returns `String(text)`. Its three Port-notes and three `portMissing` calls went.

The gate. `swift build` gave 0 errors. `swift test --no-parallel` passed 106 tests in four binaries: 78, 14, 13, and 1. `draftcheck.py --stem g_main` gave 33 of 49 hand functions replaced, 16 kept, 46 holes, 0 cascade errors, 0 defects, and 6 compile holes over 2 passes. The kept count did not rise, because the three functions were already in the kept set. `align.py` now also reports `CheckCvars` as rewritten, ratio 0.24.

## The counts

| Point | Holes | Compile holes | Replaced | Kept | Port-notes | `portMissing` lines |
| --- | --- | --- | --- | --- | --- | --- |
| Before, the D2 figure | 61 | 21 | 33 of 49 | 16 | 42 | 42 |
| After step 1 | 46 | 6 | 33 of 49 | 16 | 27 | 27 |
| After step 2 | 46 | 6 | 33 of 49 | 16 | 21 | 21 |

The holes and the compile holes are the counts of the draft. The Port-notes and the `portMissing` lines are the counts of the hand file `Sources/JKAMP_GameLogic/g_main.swift`.

The 6 compile holes of the draft are in `vmMain` two times, the `ClientConnect` return and the `G_ROFF_NotetrackCallback` call, and one each in `CalculateRanks`, `FindIntermissionPoint`, `G_LogPrintf`, and `CheckVote`.

## Docket

| Row | Item | Proposed |
| --- | --- | --- |
| R1 | Raven passes an `int` to an `unsigned` parameter, `srand( randomSeed )` in `G_InitGame`. C converts the value with no cast, but Swift rejects an `Int32` where `srand` takes a `UInt32`. The guide has no form for this conversion. | A guide form for an implicit `int` to `unsigned` argument, for example an `Int32` overload of `srand` in `bg_lib.swift` that converts once inside it, as `strlen` narrows once inside it. |
