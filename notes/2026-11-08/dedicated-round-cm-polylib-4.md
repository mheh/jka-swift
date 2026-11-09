# Dedicated round: cm_polylib, fourth pass

Branch `dedicated-round-cm-polylib-4`, off master at `308a763`. Rows 2, 3, and 4 of `notes/2026-11-04/dedicated-open-rows-ledger-3.md` give the storage forwards of the three `vec3_t` locals, the `byteCount` statics, and the `Com_Memcpy` overload over two views with `Winding.byteCount(points:)`.

## What landed

- `AllocWinding` sizes the record as `s = Int32(vec_t.byteCount) * 3 * points + Int32(Int32.byteCount)`, the form of `docs/transcription.md`.
- `RemoveColinearPoints` reads `p` through its forward and copies with `Com_Memcpy(w.p, p, nump * Int32(vec3_t.byteCount))`.
- `CopyWinding` reads `size = Int32(Winding.byteCount(points: w.numpoints))` and `Com_Memcpy(c!, w, size)`.
- `AddWindingToConvexHull` reads `hullPoints` and `newHullPoints` through their forwards, and its three copies take the `Slots` overload with `numHullPoints * Int32(vec3_t.byteCount)`.
- The two local array declarations become the rule 24 lines of the drafter, and the stale Port-notes of round 3 are gone.
- Counts: 1 `TODO: Port` (pw), 1 `portMissing` call, no `Unsafe` type in the file.

## The test

`Tests/JKAMP_DedLogicTests/PolylibTests.swift` holds two tests. The first checks that `BaseWindingForPlane` of the normal (0, 0, 1) at distance 0 gives 4 points, a positive `WindingArea`, and a `WindingPlane` result within 1e-3 of the input. The second checks that `ChopWindingInPlace` against the plane x = 0 keeps half the area, as a ratio within 1e-3, because the base winding has an area near 1.7e10. Both tests are disabled. `Z_Malloc` and `Z_Free` of `z_memman_pc.swift` are stubs, so `AllocWinding` and `FreeWinding` stop there.

## Holes open

1. `pw` stays a dead stub by row 5 of the 2026-11-03 round.
2. The two tests run when `Z_Malloc` and `Z_Free` have Swift bodies.

## Gate

- `swift build`: exit 0.
- `swift test --no-parallel`: exit 0, 143 tests, 3 skipped (the interpreter test and the two polylib tests), 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem cm_polylib`: exit 0. 9 of 17 hand functions replaced, 8 kept, 8 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass. The 8 holes are the `sizeof` holes of the drafts, which the hand bodies fill.
