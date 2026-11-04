# Dedicated round: cm_polylib, second pass

Branch `dedicated-round-cm-polylib-2`, with master at c24e5e7 merged in. Row 3 of `dedicated-open-rows-ledger.md` gives `Winding.p` the count `MAX_POINTS_ON_WINDING`, and `numpoints` is the real extent.

## What landed

- The stub `Sources/JKAMP_DedLogic/cm_polylib.swift` is adopted, and its skeleton header is gone.
- Eight bodies come from `bodies.py --unit mp-engine-ded --stem cm_polylib`: `RemoveColinearPoints`, `WindingPlane`, `WindingArea`, `WindingBounds`, `WindingCenter`, `ChopWinding`, `CheckWinding`, and `WindingOnPlaneSide`.
- One hand edit on a draft: `ChopWinding` passes `ON_EPSILON` with no `Float(...)`, because the macro is `0.1f` and Raven wrote no cast.
- Counts: 9 of 17 functions keep `TODO: Port`, and the file holds 10 `portMissing` calls.

## Holes open

1. `RemoveColinearPoints`, `Com_Memcpy (w->p, p, nump*sizeof(p[0]))`. No guide row gives a copy of `nump` points from a local array into `w.p`, and `Com_Memcpy` takes `OpaquePointer?`. The hole keeps its Port-note and its `portMissing`.
2. `AllocWinding`. `Z_Malloc` takes its tag as `JKAShared.memtag_t`, which is `CChar`, and `TAG_BSP` is an `Int32`. The signature also has no default for `bZeroit` and `iAlign`. So `Z_Malloc (s, TAG_BSP, qtrue)` does not compile without a cast and two arguments that Raven did not write. The `z_memman_pc` round owns the signature, row 4 of `notes/2026-11-03/dedicated-round-cm-polylib.md`.
3. `FreeWinding`. `Z_Free` takes `OpaquePointer?`, and rule 11 keeps the handle of a view in generated code, so `Z_Free (w)` has no form in a body. The `z_memman_pc` round owns this signature too. The `0xdeaddead` lines take the form of row 3 of the 2026-11-03 ledger when the body lands.
4. `BaseWindingForPlane`, `CopyWinding`, `ReverseWinding`, `ClipWindingEpsilon`, `ChopWindingInPlace`, and `AddWindingToConvexHull` allocate through `AllocWinding`, so they stay stubs with rows 2 and 3. The drafts of all six exist. `CopyWinding` and `AddWindingToConvexHull` also hold a `Com_Memcpy` of the hole 1 kind.
5. `pw` stays a dead stub by row 5 of the 2026-11-03 ledger.

## Gate

- `swift build`: exit 0.
- `swift test --no-parallel`: exit 0, 130 tests in 18 suites, 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem cm_polylib`: exit 0. 6 of 17 hand functions replaced, 11 kept, 8 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass.
