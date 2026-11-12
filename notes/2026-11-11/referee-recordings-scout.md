# Referee recordings scout

A read-only scout of how the referee records, what a `.rec` can hold, which recordings exist, and which six to run next. No file outside this note changed.

## Key finding first

The green run of `corpus-ffa1.rec` probably proves the spectator paths only. `tools/host-referee.sh` does not set `g_teamAutoJoin` (`tools/host-referee.sh:139-158`). Raven parks every client that is not `SVF_BOT` in `TEAM_SPECTATOR` when `g_teamAutoJoin` is 0 (`oracle/codemp/game/w_force.c:483-492`). The replayer connects each recorded bot as a human (`openjk/codemp/server/sv_referee.cpp:317-318`). `notes/2026-10-27/client-connect.md:67` records the same fact and says every replay takes `+set g_teamAutoJoin 1`. The fork log of the green run, `/tmp/referee-run/rank7/n.log`, holds no `Kill:` line, and the replay with auto-join logs 2 kills and 4 pickups (`notes/2026-10-27/unattended-replays.md:19`). Recording 1 below is the same file again with `+set g_teamAutoJoin 1` as an extra argument.

## 1. How a `.rec` file is made today

- The recorder is the OpenJK fork, `openjk/codemp/server/sv_referee.cpp`. The Swift host holds the same recorder (`Sources/JKAMP_DedLogic/sv_referee.swift:321-354`, `:829-838`). All existing files came from the fork (dedicated `openjkded` or the listen client `openjk.arm64`).
- The cvar `sv_recordInputs <qpath>` starts a recording. `SVRef_MapSpawned` opens the file with `FS_FOpenFileWrite` at the end of `SV_SpawnServer` and writes the header (`sv_referee.cpp:585-594`, hook at `openjk/codemp/server/sv_init.cpp:760`). `SV_Shutdown` closes it (`sv_referee.cpp:192-198`, `:613-618`). A recording does not need the stepper. When `sv_replayInputs` is also set, the recorder stays off (`sv_referee.cpp:581-584`).
- `sv_refSeed` fixes the `GAME_INIT` seed, which goes into the header (`sv_referee.cpp:563-566`, `:590`). Without it the header holds the clock seed of the first `GAME_INIT`.
- The header is `REFREC v1 map=<mapname> seed=<seed> fps=<sv_fps>` (`sv_referee.cpp:166`). No gametype, `sv_maxclients`, or other cvar is in it.
- Each record is 8 bytes `{u32 frameIndex, u8 type, u8 clientNum, u16 len}` plus a payload (`sv_referee.cpp:167-171`, `:179-190`):
  - Type 1, one `usercmd_t` of 28 bytes, written at the top of `SV_ClientThink` for every usercmd of every client, bots included (`sv_referee.cpp:213-222`, hook `sv_client.cpp:1322`). A human client sends several usercmds per frame (`corpus-ffa1-human-1.rec`: 51303 usercmds over 17204 frames).
  - Type 2, the userinfo, at `SV_ClientEnterWorld`, or at the first usercmd of a bot (`sv_referee.cpp:200-211`, `:218-219`).
  - Type 3, a disconnect (`sv_referee.cpp:224-231`).
- The file holds no server time, no client command (`say`, `team`, `give`, `siegeclass`), no userinfo change after the enter, no server or console command, and no botlib input. Bot input arrives as the usercmds that botlib produced. The replay runs with `bot_enable 0` (`tools/host-referee.sh:149`).
- `frameIndex` is the count of granted game frames since the map load (`sv_referee.cpp:456-457`, `:574`).
- The file goes to `<fs_homepath>/<fs_game>/<qpath>`, through the Quake file system (`record_corpus.py:9-11`, `notes/2026-10-29/human-recordings.md:7`).
- Driver: `~/Developer/jka/seam-test/referee/record_corpus.py`. It starts one fork host with `sv_stepper 1`, `sv_refSeed`, `sv_recordInputs`, `bot_enable 1`, and `+devmap`, adds bots by `addbot`, and grants one frame at a time over stdin, because the bots make one usercmd per `SV_Frame` call (`record_corpus.py:4-6`, `:123-134`, `:159-189`). The human corpora came from the listen client with `sv_recordInputs` and `+devmap mp/ffa1` (`notes/2026-10-29/human-recordings.md:7`).

## 2. What a recording can hold

| Case | Status | Proof or change |
|---|---|---|
| A client that connects mid-run | Can | Type 2 at any frame. `corpus-ffa1-human-3.rec` holds 16 clients that join over 6027 frames. |
| A client that disconnects mid-run | Can | Type 3. `reflog-force-duel.rec` holds 3, `wild-t2trip-2156.rec` holds 5. A reconnect writes type 2 again (`sv_referee.cpp:230`). |
| More than four bots | Can, to `sv_maxclients` (32 on the script line, `tools/host-referee.sh:147`) | `clientNum` is one byte, and the replayer rejects a slot at or above `sv_maxclients` (`sv_referee.cpp:299-302`). |
| More than 2400 frames | Can | `frameIndex` is 32 bits. `wild-t2wedge-3.rec` runs to frame 180622. The script alarm is `120 + FRAMES/10` seconds (`tools/host-referee.sh:72`). |
| Vehicles | Can | `wild-t2trip-fixed.rec` is the vehicle recording (`notes/2026-10-29/bg-pool-docket.md:192`). |
| NPCs and ICARUS scripts on an SP map | Can | `wild-t2wedge-*.rec` and `wild-t2trip-*.rec` on `t2_wedge` and `t2_trip`, both at `g_gametype 0` (`~/Developer/jka/seam-test/live/base/games.log`, every `InitGame` line). `t2_*` are single-player maps, not siege maps. Row H11 is a risk here: the engine's `NPCNav` calls `irand`, and the engine's `holdrand` seeds from the clock in both hosts (`notes/2026-11-03/dedicated-referee-docket.md:215`, `:270`). |
| A game type other than FFA | Can, with a manual cvar | The header has no gametype, so the run passes `GAMETYPE=<n>` (`tools/host-referee.sh:37`, `:148`, `notes/2026-11-03/dedicated-referee-harness.md:36`). The person must know the gametype of the recording. A small change in both recorders: add `gametype=%d` to the header (`sv_referee.cpp:590`, `sv_referee.swift:834`) and let the script read it as it reads `map=` and `fps=` (`tools/host-referee.sh:97-98`). The replayer reads only `seed=` (`sv_referee.cpp:285-287`), so old files stay valid. |
| Siege (`g_gametype 7` on `mp/siege_*`) | Cannot in a useful form | A siege player needs `team` and `siegeclass` client commands, and the file holds no client command. Change in both hosts: a type 4 record written in `SV_ExecuteClientCommand` (fork `sv_client.cpp`, Raven `oracle/codemp/server/sv_client.cpp`) with the command text, replayed by `Cmd_TokenizeString` and `VM_Call( gvm, GAME_CLIENT_COMMAND, num )` from `Ref_ReplayAdvance` (`sv_referee.cpp:378-403`, `sv_referee.swift:570-595`), plus the reader in `tools/reflog2rec.py` and `record_corpus.py` `verify_corpus` (`record_corpus.py:74-76`). The same record also brings back the kills that the human sessions lost (`notes/2026-10-29/human-recordings.md:19`). |
| `map_restart` | Partly | `SV_MapRestart_f` does not call `SV_SpawnServer`, so the cursor and `frameIndex` continue, and the seed comes again from `SVRef_GameSeed` (`openjk/codemp/server/sv_ccmds.cpp:240-369`, `openjk/codemp/server/sv_gameapi.cpp:2800`). Two limits. First, the game sends `map_restart 0` through the command buffer (`oracle/codemp/game/g_main.c:2151`, `:3041`, `:3211`), and the command line form `+ref_step N` runs all N frames in one `SV_Frame` (docket `:91`), so the restart runs after the last frame on both hosts and not at its recorded frame. Second, on the restart the engine reconnects a fake client as a bot, because its address is `NA_BOT` (`sv_ccmds.cpp:337-347`). Change: drive the hosts one `ref_step 1` at a time (the fork through stdin with `referee.py`, the Swift host after it reads its console, row H10), or chain `exec` files of `ref_step 1` and `wait` lines (`MAX_CMD_BUFFER` is 16384, `oracle/codemp/qcommon/cmd_common.cpp:7`). The `NA_BOT` reconnect is the same on both hosts, so it needs no change for the comparison. |
| A map change (`map`, `vstr nextmap`, `target_level_change`) | Cannot | `SVRef_MapSpawned` runs again: it closes and reopens the record file under the same name, so the recorder truncates the first map, and the replayer rewinds the cursor to the first record and clears `ref_fake` without a drop (`sv_referee.cpp:574-603`, `sv_referee.swift:818-847`). The `t=` field also splits, because the fork prints `sv.time` and the Swift host prints `svs.time` (row H3, docket `:125`, `:238`). Change in both hosts: a `REFREC v2` with a map record (type 5: map name and seed) written by `SVRef_MapSpawned` into the open file, a replayer that continues at the cursor after a map load, a `frameIndex` that does not reset or a map epoch in each record, and one time base in the `REF STEP` line on both hosts (the fork prints `svs.time`, or the Swift line keeps a per-map time). `target_level_change` uses `EXEC_NOW` (`oracle/codemp/game/g_target.c:949`), so it also starts a spawn inside a game frame. |

## 3. Recordings that exist

### In jka-rust (submodule `jka-rust/` at 1cb6c525, sibling `../jka-rust` at 2fceb7de, same files)

| Kind | Files | Writer and format | Can the Swift referee replay it |
|---|---|---|---|
| `.reflog` v1 | 8 files in `tools/referee-oracle/logs/`: `force-duel` 108386 B, `idle` 687 B, `melee-brawl` 23823 B, `real-duel1-combat` 277441 B, `real-duel1-idle` 1110 B, `real-duel1-walk` 103483 B, `real-ffa1-items` 523433 B, `solo` 5023 B. Header `# jka-rust referee input log (.reflog v1)`, then `version`, `name`, `map`, `seed`, `clients`, `msec`, `starttime`, `frames`, `userinfo` lines. | The mock-engine harness `tests/referee.rs` (named in line 2 of each file). That test was deleted in jka-rust commit `c5344f5d`. It is the input to the game-module boundary harness, one `cmd` line per client per frame. | After a conversion. `tools/reflog2rec.py` converts it: one type 2 per client at frame 0, one type 1 per `cmd` line in Raven's `usercmd_t` layout, one type 3 per client after the last frame (`tools/reflog2rec.py:1-12`). Five are already converted (below). `idle`, `melee-brawl`, and `solo` are on the mock map `arena3`, which has no BSP, so they cannot convert (`tools/reflog2rec.py:8`). |
| `.dm_26` demos | `tools/cgame-referee/fixtures/`: `ffa1` 342051 B, `sabers1` 151924 B, `spectator` 74223 B, `swoop1` 621132 B. Binary Quake demo, first word the sequence and second the length. | A client demo, the server-to-client message stream. `tools/cgame-referee/record-golden.sh` plays it in the oracle engine for the cgame referee. | Not at all. A demo holds snapshots, the server output. It holds no usercmd of any client. It belongs to the cgame seam, not the engine seam. |
| cgame journals | `tools/cgame-referee/goldens/*.journal.gz`, 1.0 to 2.1 MB | The recorder shim between `openjk.app` and the cgame module (`tools/cgame-referee/README.md:14-15`). | Not at all. They record the cgame trap stream. |
| lockstep tapes | None on disk. `tools/lockstep-referee/run.sh:39`, `:65` writes `/tmp/lockstep-referee/tape.txt`, which does not exist now. | jka-rust's own `ref_record` text tape, `H` header and hex records, FNV-1a 64 (docket `:95`). | Not at all as it is. A converter is possible for its `C` usercmd and `B`/`X` connect records, but no tape exists to convert. |
| Unit goldens | `tools/jampgame-oracle/goldens/`, `huff-oracle/goldens/`, the other `*-oracle/golden*` folders | Function-level goldens. | Not recordings. |

### In `~/Developer/jka/` (read only, listed)

All `REFREC v1`. Record counts come from a parse of each file.

| File | Bytes | Header | Clients | Last frame | Notes |
|---|---|---|---|---|---|
| `seam-test/referee/corpus-ffa1.rec` | 346883 | `map=mp/ffa1 seed=42 fps=40` | 4 bots | 2399 | The green corpus. |
| `seam-test/referee/corpus-ffa1-combat.rec` | 692483 | `map=mp/ffa1 seed=42 fps=40` | 4 bots | 4799 | 2 kills, 10 pickups with auto-join. |
| `seam-test/referee/corpus-ffa1-human-1.rec` | 1847296 | `map=mp/ffa1 seed=327 fps=40` | 1 human | 17204 | Truncated tail of 34 bytes. |
| `seam-test/referee/corpus-ffa1-human-2.rec` | 307429 | `map=mp/ffa1 seed=1169 fps=40` | 1 human | 2761 | Solo, `give all`. |
| `seam-test/referee/corpus-ffa1-human-3.rec` | 4748530 | `map=mp/ffa1 seed=1175 fps=40` | 1 human, 15 bots | 6027 | Bots join mid-run. Live session ran `sv_maxclients 32`, `bot_minplayers 31`. |
| `seam-test/referee/reflog-real-duel1-idle.rec` | 866 | `map=mp/duel1 seed=4001 fps=20` | 4 | 1 | The repo fixture. |
| `seam-test/referee/reflog-real-duel1-walk.rec` | 108450 | `map=mp/duel1 seed=4002 fps=20` | 2 | 1501 | |
| `seam-test/referee/reflog-force-duel.rec` | 108660 | `map=mp/duel1 seed=3845 fps=20` | 3 | 1001 | |
| `seam-test/referee/reflog-real-duel1-combat.rec` | 288866 | `map=mp/duel1 seed=4003 fps=20` | 4 | 2001 | |
| `seam-test/referee/reflog-real-ffa1-items.rec` | 541285 | `map=mp/ffa1 seed=4004 fps=20` | 6 | 2501 | 4 kills, 8 pickups. |
| `seam-test/live/base/wild-t2wedge.rec` | 92526 | `map=t2_wedge seed=327 fps=40` | 4 | 1393 | |
| `seam-test/live/base/wild-t2wedge-2.rec` | 41261 | `map=t2_wedge seed=329 fps=40` | 2 | 1152 | |
| `seam-test/live/base/wild-t2wedge-3.rec` | 26128384 | `map=t2_wedge seed=330 fps=40` | 4, 1 disconnect | 180622 | NPCs, 40 kills, ICARUS parms (`notes/2026-10-29/game-pool-docket.md:175`). Truncated tail. |
| `seam-test/live/base/wild-t2wedge-4.rec` | 1134592 | `map=t2_wedge seed=334 fps=40` | 4 | 8942 | Stormtrooper NPCs, 27 kills. Truncated tail. |
| `seam-test/live/base/wild-t2trip-fixed.rec` | 3223552 | `map=t2_trip seed=331 fps=40` | 5, 1 disconnect | 21780 | Vehicles, saber transitions. Truncated tail. |
| `seam-test/live/base/wild-t2trip-2.rec` | 5677056 | `map=t2_trip seed=332 fps=40` | 4 | 40405 | Truncated tail. |
| `seam-test/live/base/wild-t2trip-3.rec` | 5808128 | `map=t2_trip seed=347 fps=40` | 4 | 41341 | Truncated tail. |
| `seam-test/live/base/wild-t2trip-2156.rec` | 13713408 | `map=t2_trip seed=345 fps=40` | 5, 5 disconnects | 90169 | Ghoul2 saber removal (`client-connect.md:93`). |
| `seam-test/referee/side-c/base/wild-t2trip-snap.rec` | 585728 | `map=t2_trip seed=345 fps=40` | 4 | 4162 | Truncated tail. The other `side-c` and `side-rust` files are copies. |

A truncated tail is a host that stopped before the file closed. The replayer then prints `REF WARN truncated replay record` and ends the replay normally (`sv_referee.cpp:371-374`, `:406-412`), so the green test still sees `REF REPLAY END`. The `.dm_26` copies in `cgame-probe-home/base/demos/` and the cgame traces `trace-*.bin` (30 MB to 355 MB) are cgame-seam data and cannot drive the server referee.

So "the recordings we can copy from jka-rust" are already copied: the five convertible `.reflog` files exist as `.rec` beside the corpora. Twenty `.rec` files exist in all, and every one replays as it is with `tools/host-referee.sh`. None needs a copy.

## 4. The cost of one recording

### A run of an existing file (no recording)

```sh
SCRATCH=/tmp/referee-scratch-<name> FRAMES=<last frame + 1> GAMETYPE=<n> \
    tools/host-referee.sh <path.rec> .build/release/jampded +set g_teamAutoJoin 1 [extra]
```

Host A defaults to `.build/openjk-nocontract/openjkded.arm64` (`tools/host-referee.sh:20`). The script reads the file where it is and copies it into its scratch folder (`:117`), so a file in `~/Developer/jka/` needs no copy. Time: 2400 frames took 4 s on the fork and 25 s on the release Swift host (`notes/2026-11-10/dedicated-referee-port.md:112`), and 65 s for the whole script with the module build (`notes/2026-11-10/dedicated-open-rows-ledger-13.md:142`). By that rate (about 100 frames per second on the Swift host), 9000 frames take about 2 minutes, 22000 about 4 minutes, 180000 about 30 minutes. NPC maps can run slower. No hand step.

### A new bot recording

1. Copy `record_corpus.py` and `referee.py` to a scratch folder. The script writes its log beside itself (`record_corpus.py:138`) and copies the corpus beside itself by default (`:110`), and its default engine and module paths name a dead `/private/tmp/claude-502/...` folder (`:28-32`). Both writes would land in `~/Developer/jka/`.
2. Add one argument that passes extra `+set` lines, because the script has no gametype, `sv_maxclients`, or `g_teamAutoJoin` option (`:123-134`).
3. Run:

```sh
python3 <scratch>/record_corpus.py \
    --engine .build/openjk-nocontract/openjkded.arm64 \
    --module .build/debug/libjampgame.dylib \
    --basepath ~/Developer/jka/jka_server \
    --home /tmp/record-home --map mp/ctf1 --out corpus-ctf1.rec \
    --copy-to <corpora folder>/corpus-ctf1.rec --seed 42 --frames 4800 \
    --bots "Desann:4,Alora:4,Tavion:4,Reelo:4,Jedi:4,Rodian:4" \
    [extra: +set g_gametype 8 +set sv_maxclients 32]
```

The fork host writes `/tmp/record-home/base/corpus-ctf1.rec`, the script checks it and copies it. Then run it through `tools/host-referee.sh` with `GAMETYPE=8`. Time: not measured. The fork runs about 600 frames per second batched, and each stdin round trip adds a small cost, so 4800 frames take about one minute by estimate. Hand work: none for bots. The `jka_server` base path has no space, and the Steam path has one (`notes/2026-11-10/dedicated-open-rows-ledger-12.md:94`), so the record line uses `jka_server`.

### A new human recording

The listen client `.build/openjk/openjk.arm64` with `sv_recordInputs` and `+devmap` (`notes/2026-10-29/human-recordings.md:7`). A person must play at the keyboard and quit from the game. Nothing else.

## 5. The first six recordings

Ordered by the code each reaches that `corpus-ffa1.rec` does not. Every run adds `+set g_teamAutoJoin 1`.

| # | File | Map | `g_gametype` | Clients | Frames to grant | New code |
|---|---|---|---|---|---|---|
| 1 | `corpus-ffa1.rec` again (copy, none needed) | `mp/ffa1` | 0 | 4 bots as humans | 2400 | Live players: `ClientSpawn`, pmove with input, weapons, saber, damage, pickups (2 kills, 4 pickups). The green run reached spectator code only. Cheapest and the base for the rest. |
| 2 | `wild-t2wedge-4.rec` (existing) | `t2_wedge` | 0 | 4 | 9000 | NPC spawn and AI, engine `NPCNav`, ICARUS, `G_Alloc`, 27 kills. Watch for row H11. |
| 3 | `wild-t2trip-fixed.rec` (existing) | `t2_trip` | 0 | 5, 1 disconnect | 21800 | Vehicles, `PM_VehicleImpact`, saber transitions, a mid-run disconnect. |
| 4 | `corpus-ffa1-human-3.rec` (existing), extra `+set bot_minplayers 31` | `mp/ffa1` | 0 | 16, joins mid-run | 6100 | 16 player states, snapshots for 16 clients, connects over the run, 11 kills. |
| 5 | `reflog-real-duel1-combat.rec` (existing) | `mp/duel1` | 3 | 4, 4 disconnects | 2100 | Duel game type, the tournament queue, `sv_fps 20`. Its game-issued `map_restart` runs after the batch, as section 2 says. |
| 6 | `corpus-ctf1.rec` (new, bots) | `mp/ctf1` | 8 | 6 bots | 4800 | Team code, flags, CTF scoring, team spawns. No existing file has a team game. |

After these six, `wild-t2wedge-3.rec` (180622 frames, ICARUS parms, about 30 minutes on the Swift host) and `wild-t2trip-2156.rec` (90169 frames, 5 disconnects, Ghoul2 saber removal) are the long soaks.

### The folder

The five existing files stay where they are. The script reads them by path and writes its copy into `SCRATCH` (`tools/host-referee.sh:117`), so nothing is written into the game data tree. The new file of row 6 goes to a folder outside both repositories and outside `~/Developer/jka/`, for example `/Users/milohehmsoth/Developer/Milo/referee-corpora/`, with a `shasum` beside it, as row H12 keeps larger corpora outside the repo (docket `:274`). Not under `/tmp`, because `/tmp` does not last. If the user wants all corpora in one place, the user copies the new file into `~/Developer/jka/seam-test/referee/` by hand, because agents do not write there.
