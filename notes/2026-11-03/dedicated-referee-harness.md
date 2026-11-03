# The dedicated referee harness

The record of rows H10, H12, and H13 of `notes/2026-11-03/dedicated-referee-docket.md`. The work adds the A/B script, the referee fixture with its header test, and the rule 16 sentence. No Swift host code changed, and `sv_referee.swift` does not exist yet.
No file under `tools/oracle-closure/`, `jka-rust/`, or `../jka-rust` changed, and the `openjk` pin did not move.

## What landed

- `tools/host-referee.sh` (140 lines), row H10. It takes a `.rec` path, host A, and host B, plus extra arguments for both hosts (`tools/host-referee.sh:3`). It reads `map=` and `fps=` from the header line (`:45-46`), builds the module with `swift build --product jampgame` (`:53`), and copies `libjampgame.dylib` as `jampgamearm64.dylib` and the `.rec` into `/tmp/jka-referee/{a,b}/swift/` with a `shasum` check of the two module copies (`:55-68`). `run_host` sets the six cvars of row H8 and the stepper cvars on each command line (`:72-102`). It adds `dedicated 1` and `ttycon 0` only when the binary name starts with `openjkded`, because Raven forces `dedicated` and has no `ttycon`. The script prints the two `diff` results (`:115-119`), the frame counts, the `REF REPLAY END` counts, and the wall time, and exits 0 on the green test of section 3 (`:132-140`).
- `Sources/JKATestSupport/Oracle/fixtures/referee/reflog-real-duel1-idle.rec`, row H12. The file is 866 bytes with the `shasum` `cf7496fd871e8c08d36bb54c8b4771980ac07a3d`, copied from `~/Developer/jka/seam-test/referee/`.
- `Tests/JKASharedTests/RefereeFixtureTests.swift`, row H12. `RefereeFixtureSuite.headerFields` reads the fixture through `OracleData.fixtureData` and checks the size, the newline at byte 39, `REFREC`, `v1`, the key order `map`, `seed`, `fps`, and the values `mp/duel1`, 4001, and 20 (`RefereeFixtureTests.swift:8-28`).
- `docs/porting-rules.md:36`, row H13. The ratified sentence follows the sentence on a game module step.

## The A/B run

The run used `.build/openjk/openjkded.arm64` of the main checkout on both sides, the fork binary with no rebuild under row H14. The corpus is `~/Developer/jka/seam-test/referee/corpus-ffa1.rec`, `shasum` `9c08017178ab1cd2f720242c457fbc566d584f6e`, with the header `REFREC v1 map=mp/ffa1 seed=42 fps=40`. It holds 9604 records: 4 enter-world records and 9600 usercmds, the last at frame 2399.

- Granted frames: 4000, the default `FRAMES`.
- `REF STEP` lines: 4000 on host A and 4000 on host B. The step diff is empty.
- `REF READY` lines: equal, `REF READY map=mp/ffa1 seed=42 fps=40 es=532 er=112 ps=1552 cmd=28`.
- First and last step: `REF STEP n=1 t=425 ck=3cfa876c` and `REF STEP n=4000 t=100400 ck=c24e9a6b`.
- `REF REPLAY END`: once on each side.
- Both hosts exited 0. The script printed `green` and exited 0.
- Wall time: 47 seconds for the two host runs in sequence, and 85 seconds for the whole script with the module build.

The module `shasum` was `fac7507823e0501a52447a944592f7dd941d1b21`.

## The checks

- `swift build` passes.
- `swift test --no-parallel` passes with 126 tests in 8 runs. The `JKASharedTests` run goes from 87 to 88 tests with `RefereeFixtureSuite`, and the other runs are unchanged.

## Rows

1. The worktree has no `.build/openjk/`, so the run passed the main checkout's `openjkded.arm64` by its absolute path. The script takes both host paths as arguments, so it needs no change for this.
2. Both sides ran one binary with one module, so the green run proves that two processes of the fork agree on this corpus with the engine's `holdrand` seeded from the clock. This agrees with row H11. It does not prove a Swift host, because `jampded` does not run a frame yet.
3. The script holds three choices that the docket does not name. `FRAMES` defaults to 4000 as in section 3. `GAMETYPE` defaults to 0, because the header has no gametype field. The `openjkded*` name test adds `dedicated 1` and `ttycon 0` for the fork alone. Proposed: keep all three. A duel corpus, for example the fixture `mp/duel1`, then runs with `GAMETYPE=3`.
4. The green test requires `REF REPLAY END` on both sides, so a run with `FRAMES` at or below the last record frame is never green. Section 3 sets this test only when `N` passes the last record. Proposed: keep it, because every claimed corpus runs to its end.
5. The step diff prints its first 20 lines only, so a long mismatch shows its start. The full streams stay in `/tmp/jka-referee/a.steps` and `b.steps`.
6. The `SEAM` probe lines of the probe commit did not appear in the host log of this run, so the `grep -o` filter had no probe line to drop.
