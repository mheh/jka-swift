# The Swift module against the C module on one replay

Measured 2026-10-29 on master at 8cde4f3, on the macOS arm64 machine, with the fork's `openjkded.arm64` in stepper mode. Both modules ran the same recording through the same engine, so the engine, the map load of the BSP, and the replay are the same work, and only the game module differs.

## The two modules

- C: `.build/openjk/codemp/game/jampgamearm64.dylib`, the fork's game module built 2026-10-09, OpenJK's code with the referee probes. The probes print one `THINK`, one `PROBE`, and one `POST` line per human client per frame, which the Swift module does not.
- Swift: `.build/release/libjampgame.dylib`, `swift build -c release`, copied as `jampgamearm64.dylib`.

## The recording

`corpus-ffa1-human-2.rec` of `human-recordings.md`, the solo recording on `mp/ffa1`, 2761 frames, with `bot_minplayers 0` so that no module adds bots. The first try used `corpus-ffa1-human-3.rec` with 31 bots, and the C module added no bot in the stepper while the Swift module added 15, so that comparison was void.

## The numbers

Wall time of the whole process, `date` before and after, three rounds. The base run is `+ref_step 1`, the engine start and the map load with one step. The full run is `+ref_step 2800`, the whole recording.

| Round | C base | C full | Swift base | Swift full |
|---|---|---|---|---|
| 1 | 0.62 | 1.54 | 2.89 | 2.72 |
| 2 | 0.52 | 0.96 | 1.72 | 2.49 |
| 3 | 0.49 | 0.91 | 1.71 | 3.10 |

The best round of each column: the C module loads in 0.5 s and steps 2800 frames in 0.4 s more, 0.15 ms per step. The Swift module loads in 1.7 s and steps 2800 frames in 0.8 s more, 0.3 ms per step. The spread between rounds is near the gap, and a 2800-step solo replay is a small load, so these are first numbers and not a benchmark.

## What the numbers say

- The Swift release module costs about twice the C module per frame on a solo replay, and about three times at the map load, where `G_InitGame` parses the animation and vehicle files and builds the tables.
- Both are far under the frame. At `sv_fps 40` a frame is 25 ms, and a step costs under half a millisecond on either module.
- The debug build of the Swift module ran the 31-bot replay in 46 s against 7.8 s for the release build, six times slower, so the release build is the one to measure and to ship.
- The C side pays for 2743 probe lines per run, and the Swift side does not, so the per-step gap is a little smaller than shown.

A sharper number needs a replay with bots on both modules, which needs the C module to add bots in the stepper, and a timer inside the engine around the `GAME_RUN_FRAME` call instead of the process wall time.
