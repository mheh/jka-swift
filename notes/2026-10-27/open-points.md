# The open points of the walk, landed

This record holds the unattended landing of the open points that stood after PR 3, on the branch `open-points` off master at a7474b7, on 2026-10-27 night. The rulings are the coordinator's, in the pattern of the ratified rows of `client-connect.md`, and the user reads them after the fact. `HANDOFF.md` is removed, because the memory and the dated records hold the state.

## The reexport under Swift 6.4

The twelve rewritten declaration files of the unattended run were no toolchain drift. `reexport.py` writes every macro as an import unless its `--probe` flag runs the build rounds that mark what the importer refuses, and the run of that night went without the flag. With the probe, the run writes the committed text to the byte, 0 files changed. The probe is the default run now, and `--no-probe` is the one-round write for a reader who wants the raw form. No declaration file changes.

## The bot fill

The server with `bot_minplayers 2` that added no bot in sixty seconds was an artifact of the command line, not a hole. The game adds a bot through `trap_SendConsoleCommand`, and a `+wait N` on the command line holds the command buffer for N frames, so every `addbot` ran at the end of the wait, which the log of this run shows: five connects in the second before `ShutdownGame`. Without the wait, a server with `bot_minplayers 4` fills in forty seconds and logs kills and pickups.

## X22. `StandardBotAI` keeps the goal index inside the waypoint table

An eight-bot soak on `mp/ffa1` trapped after three minutes in `StandardBotAI` at `ai_main.swift:5913`, "Slots index -1 is out of the range 0..<4096", from `BotAI` and `BotAIStartFrame`. Raven's `ai_main.c:6668` and `:6672` set `goalWPIndex` to the current waypoint's index minus or plus one, and `:6693` reads `gWPArray[goalWPIndex]` with no bound, so a bot at waypoint 0 reads the pointer before the table and a bot at the last reads the one past it, which is undefined and which Raven's layout absorbs when the neighbor holds a NULL. OpenJK keeps the lines at `ai_main.c:6702`, `:6706`, and `:6727`. The form, by rule 19: the test opens with `goalWPIndex >= 0 && goalWPIndex < MAX_WPARRAY_SIZE`, under a two-line note inside the arm, and nothing else moves.

## X23. `StandardBotAI` tests the bounds of the desired index before the read

The soak after X22 trapped after eleven kills at `ai_main.swift:5953`, the same message, from the same path. Raven's `ai_main.c:6745-6748` reads `gWPArray[desiredIndex]` and its `inuse` first and tests `desiredIndex < gWPNum` and `desiredIndex >= 0` after, so a bot at waypoint 0 going backward reads the pointer before the table before the test that would refuse it, which is undefined. OpenJK keeps the order at `ai_main.c:6779-6782`. The form, by rule 19: the two bound tests of Raven's own line come first in the `&&` chain, under a two-line note, and the chain reads the same otherwise.

## The face animations

The view bound of `anims` and `animations` was `MAX_ANIMATIONS`, by docket row 8 of 2026-09-18, while Raven allocates `MAX_TOTALANIMATIONS` records for both the static humanoid table at `bg_panimate.c:1672` and `BG_AnimsetAlloc` at `:1732`, and the parser writes any animation the file names, including the nine `FACE_` entries of the humanoid file, which sit above `MAX_ANIMATIONS`. The two `SLOT_BOUNDS` rows read `MAX_TOTALANIMATIONS` now, the views regenerate, and the vehicle recording and the combat corpus replay as before.

## Not landed

A fresh recording of the user's own play needs the user at the keyboard, and this run had none.

## The gate

After X23 an eight-bot soak on `mp/ffa1` ran its full ten minutes with 56 kills and no trap, and the vehicle recording and the combat corpus replay as before under the wider animation bound. The build has 0 errors, the 112 Swift tests pass in four runs, the 82 tool tests pass with 16 skipped, and `tools/load-test.sh` exits 0. The snapshot check reported the two view files of the bound rows and the `ai_main` manifest line shifts, and the standing snapshot is refreshed after that read. The eight-bot server is a new trap finder beside the recordings: `openjkded.arm64` with the load-test cvars, `sv_maxclients 12`, `bot_minplayers 8`, `+map mp/ffa1`, and no `+wait`.
