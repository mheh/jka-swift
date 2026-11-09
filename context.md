# Resume state of the seventh batch of dedicated rulings

The user paused the batch on 2026-11-09. The worktree is `/tmp/jka-ded-rules-7`, the branch is `dedicated-rulings-batch-7`, off master at `1d2bdeb`. Nothing is pushed.

## Where the batch stopped

- Step 1, the changes, is done.
- Step 2 ran once. Its build failed on the `const float *` fields of `moveclip_t` and `areaParms_t`.
- Step 3, the loop, is at the end of its sixth pass. Passes 1 to 5 each stopped at the build, fixed the finding, and ran the sequence again. The sixth pass ran the sequence, the build, the three snapshots, the Swift tests, the tool tests, and draftcheck, and each passed or showed the expected host difference.
- Two checks of the gate did not run: `swift build --product jampded` and the run of `.build/debug/jampded`.

## The gate of the sixth pass

- Sequence: every step exit 0. The script is `/tmp/jka7-scripts/sequence.sh <pass>`, with logs under `/tmp/jka7-seq-<pass>/`.
- `swift build`: exit 0.
- Game snapshot: 372 files, no difference, exit 0.
- Cgame snapshot: 246 files, no difference, exit 0.
- Host snapshot: 373 files, exit 1, 49 files differ and 120 are new.
- `swift test --no-parallel`: 147 tests in nine runs, exit 0.
- Tool tests: 97 tests, 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over cm_load, cm_patch, cm_test, cm_trace, common, files_pc, stringed_ingame, stringed_interface, sv_bot, sv_game, sv_snapshot, sv_world, unzip, vm, and win_main: 1208 holes, 0 cascade errors, 0 defects, 133 compile holes over 19 passes, exit 0.

No finding of the last run needs a fix.

## Rows

Done, with the verdict in `notes/2026-11-09/dedicated-open-rows-ledger-7.md`: F4 with W3, V8, CM5 (the form, the fill goes to the cm_load round), F3, W7, G1, G2, G3 and G4 (forms only), G5 with T5, G6 with W2 and T4, G7, G8 with B4, G11 with B2, G12 with N4, W1, N1, N2, N3, N5, B3, B5, T1, T2, T3, T7 in part, T8, T9, T10, T11, U1 in part, U2, U4 in part, G1 and G2 of the unzip round, S1, S2 in part, S3, S5, and the `cmod_base` row of cm_load. F7, F8, V9, G9, G10, T6, and U3 were closed by the sixth ledger.

Open, each with a proposed form in the ledger: G13 (`downloadBlocks`), B1 (the botlib records), S4 (not taken), S6 (the defaults of SE_Load, cause not found), U5, V3, V6, and row C, the C++ classes of ICARUS, the navigator, and ROFF.

## Stages

The botlib, ICARUS, the NPC navigator, and ROFF left `deferred` of `project.toml`. The run gives 36 new stems with 795 `portMissing` lines, listed per stem in the ledger. The `portMissing` total over `Sources/JKAMP_DedLogic` is 1549: 795 new and 754 in the old stems, from 765 on master.

## Commits

- `1888dfb` the code
- `30d1352` the docs
- `1215435` the ledger

## The next command

```sh
cd /tmp/jka-ded-rules-7 && swift build --product jampded; echo "exit $?"
```

Then `.build/debug/jampded < /dev/null` for at most 20 seconds with its first `TODO: Port`, then the ledger section of the run, the report, and a refresh of the three snapshot caches after the landing.
