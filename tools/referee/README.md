# Referee tools

These two scripts help verify a game module against a reference module.
They need Python 3 and the standard library only.
They drive a patched `openjkded` engine that supports the `ref_step`, `ref_dump`, and `ref_trace` stdin protocol and the `sv_stepper`, `sv_refSeed`, `sv_refTrace`, `sv_recordInputs`, and `sv_replayInputs` settings.

## referee.py

This script starts two engine instances and steps them in lockstep.
Side A and side B each load a different game module from their own `fs_homepath`.
The script compares the checksum of each frame.
On a divergence, it reports the first differing entity or client field and the first differing boundary-trace record.
In a dump block, a line of hex digits with no `REF ` mark is the next part of the record before it, because the Swift host ends a line after each `Com_Printf` call.
The `--selftest` argument checks the parser and the differ against embedded samples and needs no engine.

Arguments:

- `--engine`: the patched engine binary. Required.
- `--basepath`: the `fs_basepath` with the game assets. Required.
- `--home-a`, `--home-b`: the `fs_homepath` of each side. Each holds `base/` with the game module of that side. Required for a run.
- `--label-a`, `--label-b`: the names of the sides in the report. The defaults are `a` and `b`.
- `--map`, `--seed`, `--frames`, `--batch`: the map, the random seed, the maximum number of frames, and the frames for each `ref_step` command.
- `--port-a`, `--port-b`: the network port of each side.
- `--replay`: a recorded input file. The script copies it into `base/` of both homepaths.
- `--run-to-end`: step until the replay ends, then report PASS.
- `--set NAME VALUE`: an extra server setting, passed as `+set NAME VALUE`. Repeat the argument for more settings.
- `--logdir`: the folder for the engine logs. The default is `/tmp/referee-scratch/logs`.
- `--timeout`, `--boot-timeout`: the seconds to wait for a step and for the first map load.
- `--selftest`: run the self-test and exit.

Example:

```
python3 tools/referee/referee.py --engine <engine> --basepath <basepath> --home-a <home-a> --home-b <home-b> --replay <corpus>.rec --run-to-end --set g_teamAutoJoin 1
```

## record_corpus.py

This script records a bot input corpus.
It starts one engine, adds bots, steps frames one at a time, quits, and verifies the recorded file.
The engine writes the file to `<home>/base/<out>`.
If `--copy-to` is given, the script also copies the file there.

Arguments:

- `--engine`: the patched engine binary. Required.
- `--module`: the game module that the script copies into `<home>/base`. Required.
- `--basepath`: the `fs_basepath` with the game assets. Required.
- `--home`: the `fs_homepath` scratch folder. Required.
- `--out`: the record file name, relative to the quake file system.
- `--copy-to`: where to copy the finished corpus. No copy happens when it is absent.
- `--map`, `--seed`, `--frames`: the map, the random seed, and the number of frames.
- `--bots`, `--warmup`, `--min-bots`: the bot list as `name:skill`, the warm-up frames after `addbot`, and the least number of active bots.
- `--set NAME VALUE`: an extra server setting, passed as `+set NAME VALUE`. Repeat the argument for more settings.
- `--logdir`: the folder for the engine log. The default is `/tmp/referee-scratch/logs`.
- `--timeout`, `--boot-timeout`: the seconds to wait for a step and for the first map load.

Example:

```
python3 tools/referee/record_corpus.py --engine <engine> --module <module> --basepath <basepath> --home <home> --out corpus.rec --copy-to <corpus>.rec --set g_teamAutoJoin 1
```

## Recordings

This repo carries no `.rec` file.
When a human made a recording, the userinfo text in it holds the `ja_guid` and the address of that player.
Do not publish such a recording.
