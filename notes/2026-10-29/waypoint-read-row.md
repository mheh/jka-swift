# W2. `CalculateJumpRoutes` reads the waypoint before the first with no bound

This record holds the second unbounded waypoint read, found while the trap of W1 was proven, `waypoint-trap-row.md`. No run has trapped at it. It is proven by reading and by a scan of the shipped route files.

## The site

`CalculateJumpRoutes` at `Sources/JKAMP_GameLogic/ai_wpnav.swift:1742-1775` walks `i` from 0 to `gWPNum` and, for each waypoint with `WPFLAG_JUMP`, reads `gWPArray[i - 1]` at `:1755` and `gWPArray[i + 1]` at `:1759` before any bound test. Raven's loop is `ai_wpnav.c:1953-1993`, with the two reads at `:1970` and `:1974`, and OpenJK keeps them at `ai_wpnav.c:1982` and `:1986`. `LoadPathData` calls the function once at every map load, `ai_wpnav.swift:2002` and `ai_wpnav.c:2245`, after the route file is read.

## When the read is out of the table

The read of `i - 1` is index -1 when waypoint 0 carries the jump flag. The read of `i + 1` is index `gWPNum`, which is inside the table unless the table is full at `MAX_WPARRAY_SIZE`, 4096. Raven's `gWPArray` is a static array at `ai_wpnav.c:12`, so the read before it lands on the static that sits before it in the data segment, which is undefined, and the Swift table traps with `Slots index -1 is out of the range 0..<4096`.

A scan of the twenty route files of `assets0.pk3`, `botroutes/mp/*.wnt`, finds no file whose first waypoint or last waypoint carries the jump flag, bit 0x10 of the second field. That is why no replay and no map change run trapped here. A route file from another mod or a hand-made one with a jump at waypoint 0 traps the Swift module at map load.

## The proposed form

Ratified as proposed on 2026-10-29.

By rule 19, the two bound tests come first in each chain, and the rest of each line stays as it is, in the form of W1 and X22. One two-line note under the `Port-note:` prefix of rule 24 above the first read.

```swift
                // Port-note: Raven reads the pointer before the table for a jump at waypoint 0, and the one past it at a full table, which is undefined.
                // The two bounds below make an index outside the table no waypoint.
                if i - 1 >= 0 && gWPArray[i - 1] != nil && gWPArray[i - 1]!.inuse != 0 && (gWPArray[i - 1]!.origin[2] + 16) < gWPArray[i]!.origin[2] {
                    ...
                }

                if i + 1 < MAX_WPARRAY_SIZE && gWPArray[i + 1] != nil && gWPArray[i + 1]!.inuse != 0 && (gWPArray[i + 1]!.origin[2] + 16) < gWPArray[i]!.origin[2] {
```

## The gate

`swift build`, `swift test --no-parallel`, `tools/load-test.sh`, and one map load of a route file with the jump flag set on waypoint 0: a copy of `botroutes/mp/duel1.wnt` with the second field of its first line set to 16, placed in the scratch homepath under `swift/botroutes/mp/duel1.wnt`, loaded with `+map mp/duel1`, must trap on master's dylib and pass on the fixed one.

## The build and the gate

The two reads at `ai_wpnav.swift:1757` and `:1761` open with their bound tests, and the two-line note sits above the first under the `Port-note:` prefix. No other line changes.

1. `swift build`: 0 errors.
2. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all pass.
3. `tools/load-test.sh`: exit 0.
4. The route file check. A copy of `botroutes/mp/duel1.wnt` with the second field of its first line set to 16, under `swift/botroutes/mp/` in a fresh homepath, loaded with `+map mp/duel1`. On the dylib before the change: exit 2, one `InitGame`, and `JKAShared/Slots.swift:32: Precondition failed: Slots index -1 is out of the range 0..<4096`. On the fixed dylib: exit 0, one `InitGame`, no trap. Logs `/tmp/jka-load/w2-before.log` and `w2-after.log`.

The generators did not change, so draftcheck and the snapshot did not run.
