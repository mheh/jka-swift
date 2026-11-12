# Batch 10 resume state

The user paused the batch on 2026-11-10. Worktree `/tmp/jka-batch-10`, branch `dedicated-rulings-batch-10`, head `feb1ebc`. Everything is committed except the untracked `.claude/manifest/mp-engine-ded/`, which master does not track either, and this file.

## Phase

The run phase, after the gate and the first server runs. The bulk fix and the gate are done and green. The ledger `notes/2026-11-10/dedicated-open-rows-ledger-10.md` is not written yet, and that is the next step.

## Docket rows

- Done, the PATTERN rows: X1 (thunks, the five file thunks, the stores, the W3P2 returns), X2, X3, X4, X5, X6, X9, X10, X11, X12 (except the two Wait holes), X14 (G1b to G1g, G1a and G1g were already right), X16, X17, X18, X19, X20, X21, X22, X24, X25, X26, X27, X28, X29, X30, X31, X32, X33, X34, X35, X36, X37, X39 P17a, X40, X41, X42, X44, X45. X15, X24 P18, X47, X48, X49 needed no change.
- Done, the ten rulings of 2026-11-10: X46 (WIDENED_FIELDS in extract.py, `ptrdiff_t` fields, Int sites under "C converts" lines), Z6 with W3P4, X1a, X1b, X7, X8, X13 (unverified against Raven's binary), X38, X39 P17b (candidate B), X43.
- Left open: the two Wait holes of CTaskManager (TaskManager.cpp:1111 and :1122, no storage form for `&dwtime` of a method and no UInt32 and Float compare), the G_G2_LISTBONES and G_G2_LISTSURFACES arms, G2_GorePolys (dead on DED), 17 export thunks with an `inout CharBuf` parameter (EA_Command among them), BotChooseBestFightWeapon, BotChooseLTGItem, and BotChooseNBGItem thunks (no count), the AAS_FloatForBSPEpairKey and GeneticParentsAndChildSelection arms of sv_game (need PARAMS rows), AAS_WriteAASLump and AAS_ReadCache scalar writes, Log_WriteTimeStamped (`%02d`), CM_TerrainPatchIterate, ProcessAutomapSymbols, the RMG classes without a form (CPathInfo, CRMInstance and others), `%lu`, and the 32000-byte cut of BSPEntityData through `ringText`.

## Last results (from /tmp/b10-timing.log)

- Sequence run 6, all steps exit 0, 333 s in total (reexport 107 s, skeletons 62 s, manifests 63 s).
- Build run 13, exit 0, 4 s (the last full debug build was run 12, 35 s). Release build, exit 0, 116 s.
- snapshot.py --check: mp-game exit 1 (123 s), mp-cgame exit 1 (51 s), mp-engine-ded exit 1 (72 s). The game and cgame differences all come from row X23, the narrow plain `char`: the GNPC view and the cg_main skeleton signature `cursor: CChar` to `Int32`, and the drafts of 25 game and 9 cgame stems. The host differences are the batch itself. The caches are not refreshed yet.
- swift test --no-parallel -j 6, exit 0, 40 s. Tool tests, 99 run, OK, 2 s.
- portMissing calls in JKAMP_DedLogic: 265, from 770 lines on master.

## Open build and test errors

None.

## Server

Arguments: `/tmp/b10-run-rel.sh <N>` (release) or `/tmp/b10-run.sh <N>` (debug), from `~/Developer/jka/jka_server`, `+set fs_game swift +set sv_pure 0 +set vm_game 0 +set bot_enable ${BOT:-0} +set fs_homepath /tmp/b10-out/home +set fs_cdpath /tmp/b10-out/home +set dedicated 1 +map mp/ffa1`, with the dylib copied to `/tmp/b10-out/home/swift/jampgamearm64.dylib`. The log goes to `/tmp/b10-out/run<N>.txt`.
Stop point: none. The server loads mp/ffa1, runs SV_SpawnServer and GAME_INIT to `InitGame:`, then runs Com_Frame until the alarm, with `bot_enable 0` (runs 3 and 4) and `bot_enable 1` (run 6). The only lines after InitGame are two `Hitch warning` lines of the first frames. A sample of run 5 shows the main loop idle in `usleep` and Com_Frame. The debug build spends minutes in MSG_initHuffman before the first frame. The smoke test passed in the gate.

## Sub-agents

Four opus agents (A host botlib surface, B botlib bodies, C Ghoul2 and ICARUS, D terrain and clip map). All four have finished. None runs.

## Next command

Write `notes/2026-11-10/dedicated-open-rows-ledger-10.md` (every row with verdict, authority, and pattern, the timing table, the gate counts, the open rows), commit it apart, then refresh the three snapshot caches in place with `snapshot.py --unit <unit> --out ~/.cache/jka-swift/<folder>` only after the user accepts the X23 differences.
