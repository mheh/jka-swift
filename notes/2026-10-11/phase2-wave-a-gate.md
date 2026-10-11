# Phase 2 wave A gate

## Files changed

The working tree has 26 changed files under `Sources/JKAMP_GameLogic/`. One of them is `g_local.swift`, where the helper changed the `modNames` declaration. The tree also has eight new records under `notes/2026-10-11/`.

## Build

The first `swift build` was clean, with zero errors. I made no fixes, and I restored no site to a Port-note hole.

## qsort binding

The two call sites are `qsort(&clients, cnt, SortClients)` at `g_team.swift:1113` and `qsort(level.sortedClients, level.numConnectedClients, SortRanks)` at `g_main.swift:1843`. Both calls have three arguments, and Darwin `qsort` has four, so Darwin cannot take them. In `g_team.swift`, `clients` is a `[Int32]`, so the call binds to `qsort<T>(_ a: inout [T], _ n: Int32, _ cmp: (T, T) -> Int32)` at `Sources/JKAMP_BG/bg_lib.swift:53`. In `g_main.swift`, `level.sortedClients` is a `Slots<Int32>`, so the call binds to `qsort(_ a: Slots<Int32>, _ n: Int32, _ cmp: (Int32, Int32) -> Int32)` at `bg_lib.swift:59`. Both comparators have the type `(Int32, Int32) -> Int32`.

## Tests

`swift test --no-parallel` passed 112 tests in four binaries: 84, 14, 13, and 1. No test failed.

## Load test

`tools/load-test.sh` exited with 0. The log has an InitGame line at line 40 and a ShutdownGame line at line 41. The log has no Fatal line.

## Port-note total

The total of `Port-note:` lines in `Sources/JKAMP_GameLogic/*.swift` is 176 after the wave. The total was 246 before the wave, and the plan expected about 176.
