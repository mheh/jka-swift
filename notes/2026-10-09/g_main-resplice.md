# The g_main re-splice

## The gate

The builder ran `draftcheck.py --stem g_main` in the main checkout on the branch `wave-0`, level with `c82143f`. The run gave 32 of 49 hand functions replaced, 17 kept, 44 holes, 0 cascade errors, 0 defects, and 4 compile holes over 2 passes. These figures are the figures of item 3 in `notes/2026-10-09/post-spine-changes.md`.

Finding: the gate kept `vmMain`, so the 44 holes and the 4 compile holes do not include a build of the new `vmMain` draft. The hand body of `vmMain` was the draft of an earlier splice, with the verdict text of the hole round added to its blocked Port-notes. `align.py` marks such lines `edited` against the new draft, so `kept` keeps the function. The other 16 kept functions are hand work: `G_Printf`, `G_Error`, `Com_Error`, and `Com_Printf`, the fills of the hole round in `G_RegisterCvars`, `G_UpdateCvars`, `SendScoreboardMessageToAllClients`, `DuelLimitHit`, `DuelResetWinsLosses`, `ExitLevel`, `CheckIntermissionExit`, `CheckExitRules`, and `G_KickAllBots`, the hand store of item 5 in `G_InitGame`, and the verdict text in `CheckCvars` and `G_GetStringEdString`.

As the q_shared re-splice did for `Q_strncpyz` and `Info_NextPair`, the builder took the new draft of `vmMain` and kept the 16 hand functions. The builder spliced the new `vmMain` into the hand file and ran `draftcheck.py --stem g_main` again, so the mirror built the new draft. That run gave 33 of 49 hand functions replaced, 16 kept, 61 holes, 0 cascade errors, 0 defects, and 21 compile holes over 2 passes. The 17 new compile holes are all in `vmMain`.

## The print

`bodies.py --stem g_main --compile-holes` reset the lowered rows. After each draftcheck run, `printer.py --stem g_main --compile-holes` printed the whole stem with no stop, and its text equals the draft file of the run under `.build-draft/drafts/`. The printer did not stop on a function, so the builder did not need `bodies.py --only`. After a draftcheck run, `bodies.py --stem <stem>` lowers the line rows again before `printer.py --stem <stem> --compile-holes` prints, because the printer stops on a function with no line rows.

A script keyed on the `/// Source:` lines spliced the 33 drafted functions. The kept set is each hand function with no row in the `splices` table. The script kept the 16 hand functions, every forward, and every signature line. The splice changed only `vmMain`. The other 32 drafted functions were equal to their hand bodies. `vmMain` lost no Raven comment.

## The compile holes in vmMain

The builder made no hand conversion. The gate itself made each statement that did not compile into a compile hole in the `COMPILE_NOTE` form, and the splice took the print of the gate.

- 15 reads of `sharedMem`, one in each case of `GAME_ICARUS_PLAYSOUND`, `SET`, `LERP2POS`, `LERP2ORIGIN`, `LERP2ANGLES`, `GETTAG`, `LERP2START`, `LERP2END`, `USE`, `KILL`, `REMOVE`, `PLAY`, `GETFLOAT`, `GETVECTOR`, and `SOUNDINDEX`. The compiler wrote "cannot force unwrap value of non-optional type 'IcarusPlaySound'", with the view of each case. The drafter reads the local as `sharedMem!`, and the view at `gSharedBuffer` is not optional.
- `return (int)ClientConnect( arg0, arg1, arg2 )`, and the compiler wrote "no exact matches in call to initializer". The hand body held the same compile hole.
- `G_ROFF_NotetrackCallback( &g_entities[arg0], (const char *)arg1 )`, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'String'". The hand body held the same compile hole.

The 17 declarations `let sharedMem = Icarus<View>(handle: OpaquePointer(gSharedBuffer))` compile. The read in `GAME_ICARUS_GETSTRING` is now a hole on `morecrap`, and the read in `GAME_ICARUS_GETSETIDFORSTRING` keeps its `setTable` hole.

## The counts

Before the re-splice, the file held 59 Port-notes and 59 lines that start with `portMissing(`. After it, the file holds 42 Port-notes and 42 such lines. The 33 Port-notes about `sharedMem` went, and 15 compile holes and 1 hole on `morecrap` came in.

The align run needed the line rows in the store first, so the builder ran `bodies.py --stem g_main` without `--compile-holes`. The align run gave this line, and it deleted 50 draft lines of the stored map:

- g_main: 2966 same, 18 edited, 89 hand, 17 rewritten, 0 stub

The 18 edited lines are in the kept hand functions. `vmMain` has 51 of the 89 hand lines, the lines of its 17 compile holes, because the line rows of a print without `--compile-holes` hold the drafted statements.

`swift build` gives 0 errors. `swift test --no-parallel` passes 106 tests in four binaries: 78, 14, 13, and 1. The last `draftcheck.py --stem g_main` gives 33 of 49 hand functions replaced, 16 kept, 61 holes, 0 cascade errors, 0 defects, and 21 compile holes over 2 passes. The store holds 33 splice rows for `g_main.swift`, and each row matches its hand body.

The re-splice is commit `5648469`.

## Docket

| Row | Item | Proposed |
| --- | --- | --- |
| D1 | The drafter reads a view local at `gSharedBuffer` as `sharedMem!`, but the view is not optional. This gives 15 compile holes in `vmMain`. | A drafter change in the shape of item 3, so a read of such a local has no force unwrap, then a re-splice of `vmMain`. |
| D2 | The reference of item 3, 44 holes and 4 compile holes, did not build `vmMain`. With `vmMain` built, `g_main` is at 61 holes and 21 compile holes. | Take 61 and 21 as the reference of `g_main` and of the `--game` sum. |
| D3 | The new draft of `G_InitGame` writes `trap_SV_RegisterSharedMemory(gSharedBuffer)` and `JKAMP_BG.srand(randomSeed)` over two compile holes of the hand body. The gate kept the hand body, so it built neither line. | A transcriptor round on `G_InitGame` takes the two lines and builds them. |
| D4 | The drafts of `CheckCvars` and `G_GetStringEdString` still hold the holes on `lastMod` and `text`, though item 4 added the stored properties and the forwards. | A drafter rule that reads a static local through its `GameWorld` forward, or a transcriptor round on the two bodies. |
