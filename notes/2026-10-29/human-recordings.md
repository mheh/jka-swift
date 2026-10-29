# Two human recordings on the listen server

This record holds the two recordings of the user's own play on 2026-10-29, the row that waited in `HANDOFF.md` of 2026-10-28 for someone at the keyboard. Both ran on master at 4f89c89 with no code change, and neither raised a trap.

## The setup

The earlier human recording of `client-connect.md` ran a dedicated server with a client connected to it. These two ran the client as a listen server, by the user's word: `.build/openjk/openjk.arm64` with the scratch homepath `/tmp/jka-client/home`, the Steam `SWJKJA.app/Contents` as `fs_basepath`, `fs_game swift`, `sv_pure 0`, `vm_game 0`, `g_teamAutoJoin 1`, `sv_recordInputs <name>.rec`, and `+devmap mp/ffa1`. The Swift library goes into `/tmp/jka-client/home/swift/jampgamearm64.dylib`, the old file removed first. The client binary holds the referee recorder, and the record file lands in the mod folder of the homepath. The client log goes to a file through a shell redirect, and the quit from the game ends the process.

The replay of each file is the stepper of the earlier records: `openjkded.arm64` with the load-test cvars, `ttycon 0`, `sv_fps 40`, `g_teamAutoJoin 1`, `sv_stepper 1`, `sv_replayInputs <name>.rec`, and `+map mp/ffa1 +ref_step N +wait 5 +quit`, with N above the last recorded frame. The second replay also takes `sv_maxclients 32` and `bot_minplayers 31`, the same as its live session.

## The runs

`corpus-ffa1-human-2.rec` is a solo session at seed 1169: 2761 frames and 8530 usercmds over 69 seconds, with `give all` and no other player, so the game log holds no kill and no pickup. The replay ran 3200 granted frames, connected and disconnected the one fake client, and exited 0.

`corpus-ffa1-human-3.rec` is a session at seed 1175 with `sv_maxclients 32` and `bot_minplayers 31`: 6027 frames and 131819 usercmds over 152 seconds. Fifteen bots entered before the quit, one every few seconds, and the live game log holds 33 kills and 35 pickups. The recorder writes the usercmds of every client, bots included, so the file holds 16 clients. The replay connected all 16, ran 6500 granted frames, logged 11 kills and 17 pickups, and exited 0. The replay logs fewer kills than the live session because the engine replays usercmds and no client command.

Both files sit beside the other corpora under `~/Developer/jka/seam-test/referee/`.

## What stands

No code row came out of either run. The listen server is a third trap finder beside the stepper replays and the eight-bot soak, and the one that puts a human at the keyboard with weapons against bot targets.
