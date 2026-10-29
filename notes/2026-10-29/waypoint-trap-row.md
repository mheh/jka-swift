# The waypoint trap row

This record holds the proof of the `gWPArray` trap of the game-pool map change run and the proposed row. The branch is `game-pool` at 6b95b8c, with the copy of `.build/debug/libjampgame.dylib` as `swift/jampgamearm64.dylib` in each scratch homepath.

## The trap

The map change run of `notes/2026-10-29/bg-pool-docket.md` trapped once at `/tmp/jka-load/gp-mapchange.log` line 151, on `mp/duel1` after `map_restart 0`, with 4 bots, in the first frame after a hitch of 20558 msec: `JKAShared/Slots.swift:32: Precondition failed: Slots index -1 is out of the range 0..<4096`. The 4096-slot table is `gWPArray`, `GameStorage.swift:757`. That log has no stack.

## The runs

All four runs use `.build/openjk/openjkded.arm64` under `lldb --batch -o run -k "bt 30"`, the Steam `fs_basepath`, `fs_game swift`, `dedicated 1`, `sv_pure 0`, `vm_game 0`, `ttycon 0`, `g_teamAutoJoin 1`, and an alarm of 600 seconds.

1. The map change run, `bot_minplayers 4`, `sv_maxclients 8`, `+map mp/ffa1 +wait 600 +map mp/duel1 +wait 1600 +map_restart 0 +wait 1200 +map mp/ffa1 +wait 1200 +quit`: exit 0, four `InitGame` lines, 4 kills, no trap. The log is `/tmp/jka-load/wt-run1.log`.
2. `mp/duel1` alone, `bot_minplayers 8`, `sv_maxclients 12`, `+map mp/duel1 +wait 1200 +quit`: exit 0, no trap. The bots join when the wait ends, and `quit` comes next, so no bot plays. The log is `/tmp/jka-load/wt-run2.log`.
3. `mp/duel1`, `bot_minplayers 8`, `sv_maxclients 12`, `+map mp/duel1 +wait 1200 +map_restart 0 +wait 3000 +quit`: the trap, in the first frame after `map_restart 0` and its hitch of 18969 msec, the same text and the same place in the run as the original. The log is `/tmp/jka-load/wt-run3.log`.

## The backtrace

```
* thread #1, queue = 'com.apple.main-thread', stop reason = Precondition failed: Slots index -1 is out of the range 0..<4096
  frame #4: jampgamearm64.dylib`Slots.subscript.getter(i=-1) at Slots.swift:32:13
  frame #5: jampgamearm64.dylib`Slots.subscript.getter(i=-1) at Int32Indexing.swift:7:17
  frame #6: jampgamearm64.dylib`GetIdealDestination(bs=JKAMP_Game.BotState @ 0x000000016fdf68b0) at ai_main.swift:3534:31
  frame #7: jampgamearm64.dylib`StandardBotAI(bs=JKAMP_Game.BotState @ 0x000000016fdfb208, thinktime=0.150000006) at ai_main.swift:5926:13
  frame #8: jampgamearm64.dylib`BotAI(client=1, thinktime=0.150000006) at ai_main.swift:850:5
  frame #9: jampgamearm64.dylib`BotAIStartFrame(time=41075) at ai_main.swift:6563:17
  frame #10: jampgamearm64.dylib`vmMain(command=10, arg0=41075, ...) at jampgame.swift:85:20
  frame #12: openjkded.arm64`VM_Call(vm_s*, int, long, ...) + 188
  frame #13: openjkded.arm64`GVM_BotAIStartFrame(int) + 80
  frame #14: openjkded.arm64`SV_Frame(int) + 1668
  frame #15: openjkded.arm64`Com_Frame() + 664
```

Frames 0 to 3 are the Swift runtime report. Column 31 of `ai_main.swift:3534` is the first subscript of the line, `gWPArray[cWPIndex - 1]`, so `cWPIndex` is 0.

## The candidates

Each row gives the Swift line, Raven's line, OpenJK's line, the source of the index, and the bound test.

| Swift | Raven | OpenJK | Index | Bound test |
|---|---|---|---|---|
| `ai_main.swift:3534` `GetIdealDestination` | `ai_main.c:3859` | `ai_main.c:3907` | `cWPIndex - 1` and `cWPIndex + 1`, `cWPIndex = bs.wpCurrent!.index` at `:3524` | None. A bot at waypoint 0 reads index -1. |
| `ai_main.swift:6034` `StandardBotAI` | `ai_main.c:6852` | `ai_main.c:6886` | `bs.wpCurrent!.index - 1` | Yes. The arm opens with `bs.wpCurrent!.index > 0` at `:6032`, Raven's `:6848`. |
| `ai_main.swift:1528` `WPTouchRoutine` | `ai_main.c:1494` | `ai_main.c:1518` | `lastNum = bs.wpCurrent!.index - 1` at `:1525`, when `wpDirection` is 0 | None. A camper at waypoint 0 reads index -1. |
| `ai_main.swift:3446` `GetIdealDestination` | `ai_main.c:3736` | `ai_main.c:3784` | `tempInt = bs.wpCurrent!.index - 1` at `:3442`, when `wpDirection` is 0 | None. A bot at waypoint 0 that runs from a bad thing reads index -1. |
| `ai_wpnav.swift:1755` `CalculateJumpRoutes` | `ai_wpnav.c:1970` | `ai_wpnav.c:1982` | `i - 1`, with `i` from 0 in the `i < gWPNum` loop | None. Waypoint 0 with `WPFLAG_JUMP` reads index -1 at route load. |

The `+ 1` reads of `ai_wpnav.swift:1366`, `:1759`, `:2182`, `:2210`, and `:2658` cannot give -1. They reach 4096 only when `gWPNum` is at `MAX_WPARRAY_SIZE`, the clamp of Raven's `ai_wpnav.c:1508`.

The stack names `ai_main.swift:3534`. The rows at `:1528`, `:3446`, and `ai_wpnav.swift:1755` hold the same undefined read in Raven and stay open, with no trap in a run so far.

## Why Raven's layout absorbs the read

Raven declares `wpobject_t *gWPArray[MAX_WPARRAY_SIZE];` at `ai_wpnav.c:12`, a file-scope table of pointers. `gWPArray[-1]` is the pointer-sized word before the table, which is undefined. In Raven's build that word belongs to another global or to padding. When it is zero, the first test of the `&&` chain is false, and the arm does nothing, which is the same result as no waypoint before waypoint 0. When it is not zero, Raven reads `->inuse` through a stray pointer. The Swift `Slots` view checks the range and traps on -1.

The `cWPIndex + 1` read is inside the table for every index below 4095, because `B_InitAlloc` zeroes the slots past `gWPNum`. It leaves the table only for a bot at waypoint 4095 of a full table.

## The proposed form

Ratified as proposed on 2026-10-29, with both bounds and the `Port-note:` prefix of rule 24.

By rule 19, the smallest bound test comes first in the `&&` chain, and the rest of the line stays as it is. The two tests name the two indices of the line, as X22 does. No other line changes.

```swift
            } else if cWPIndex - 1 >= 0 && cWPIndex + 1 < MAX_WPARRAY_SIZE && gWPArray[cWPIndex - 1] != nil && gWPArray[cWPIndex - 1]!.inuse != 0 && gWPArray[cWPIndex + 1] != nil && gWPArray[cWPIndex + 1]!.inuse != 0 {
                // Raven reads the pointer before the table for a bot at waypoint 0, and the one past it at the last slot, which is undefined.
                // The two bounds above make an index outside the table no waypoint.
```

The trap needs only the first test. The second test covers the `+ 1` read at the last slot, as X22 covers it. If the ruling wants the smallest form only, the line opens with `cWPIndex - 1 >= 0 &&` and the note keeps its first clause.

The note takes the two-line form of the landed X22 and X23 sites, which carry no `Port-note:` prefix. Rule 24 says that a rule 19 note keeps its `Port-note:` prefix, so the ruling picks the X22 form or the rule 24 prefix.

## The build and the gate

The line at `ai_main.swift:3534` opens with the two bound tests, and the two-line note under it carries the `Port-note:` prefix. No other line changes.

1. `swift build`: 0 errors.
2. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all pass.
3. `tools/load-test.sh`: exit 0.
4. The run that trapped, `mp/duel1` with 8 bots in 12 slots, 1200 waits, `map_restart 0`, 3000 waits, under lldb with the fixed dylib: exit 0, no trap, two `InitGame` lines, 5 kills, and the same hitch frames of 21300 and 19952 msec after each load that preceded the trap before. Log `/tmp/jka-load/w1-run.log`.

The generators did not change, so draftcheck and the snapshot did not run.
