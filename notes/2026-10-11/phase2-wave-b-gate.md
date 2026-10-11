# Phase 2, wave B, compile gate

## Files changed

Wave B changed 29 files under `Sources/JKAMP_GameLogic/`. The compile agent changed one line in one of these files. No file outside the wave changed.

## Build

The first build failed with one error. The second build was clean, with the result `Build complete!`.

The error was `g_cmds.swift:205:25: ambiguous use of 'tolower'`. The `SanitizeString` fill from the entities record calls `tolower`, and the file imports both Foundation and JKAShared. Each module has a `tolower(Int32) -> Int32`. The fix adds the module qualifier, so the call uses the JKAShared function in the C locale. The fix adds no cast.

- `g_cmds.swift:205` before: ``out[outIndex] = tolower(Int32(UInt8(truncatingIfNeeded: `in`[inIndex])))``
- `g_cmds.swift:205` after: ``out[outIndex] = JKAShared.tolower(Int32(UInt8(truncatingIfNeeded: `in`[inIndex])))``

The two shapes to watch compiled without a change. The bones record gives `WP_FireVehicleWeapon`, which passes `&pVeh.m_vMuzzlePos[curMuzzle]` as `inout` through the nonmutating `Slots` setter. The bot record gives `RequiredSArgument` as `CharBuf?`. The `g_local.swift` change compiled without a change.

## Sites restored to a hole

None.

## Warnings

The agent touched the 29 changed files and built again, which gave 660 unique warnings in these files. The agent compared each warning line with the lines that the wave added in `git diff -U0`. No warning is on a line that the wave added. The warnings are on lines that were in the files before the wave.

## Tests

`swift test --no-parallel` ran 112 tests in four binaries, 84, 14, 13, and 1. All tests passed.

## Load test

`tools/load-test.sh` stopped with exit 0. The log at `/tmp/lt-wave-b.log` has an InitGame line at line 40 and a ShutdownGame line at line 41. The log has no Fatal line.

## Port-note count

The total is 46 Port-notes after the wave. The total at HEAD was 176, so the wave removed 130 holes.

| File | Port-notes |
| --- | --- |
| `g_main.swift` | 10 |
| `w_saber.swift` | 7 |
| `ai_util.swift` | 4 |
| `g_active.swift` | 4 |
| `g_weapon.swift` | 4 |
| `g_nav.swift` | 4 |
| `NPC_stats.swift` | 4 |
| `g_ICARUScb.swift` | 3 |
| `g_svcmds.swift` | 3 |
| `g_client.swift` | 1 |
| `g_saga.swift` | 1 |
| `g_mover.swift` | 1 |
