# Dedicated round: cm_polylib, third pass

Branch `dedicated-round-cm-polylib-3`, off master at `cb39f60`. Rows 1, 8, and 9 of `dedicated-open-rows-ledger-2.md` give the `Slots` overload of `Com_Memcpy`, the `Int32` alias of `memtag_t`, and the defaults of `Z_Malloc`.

## What landed

- Five full bodies: `FreeWinding`, `BaseWindingForPlane`, `ReverseWinding`, `ClipWindingEpsilon`, and `ChopWindingInPlace`. The last four come from `bodies.py --unit mp-engine-ded --stem cm_polylib`.
- Three bodies with holes: `AllocWinding`, `CopyWinding`, and `AddWindingToConvexHull`.
- `AllocWinding` reads `w = Winding(Z_Malloc(s, TAG_BSP, true))`, the form of the `Z_Malloc` site of msg.swift.
- `FreeWinding` writes the `0xdeaddead` word as `w.numpoints = Int32(bitPattern: 0xdeaddead)` by row 3 of the 2026-11-03 round, and reads it the same way. It calls `Z_Free(w.handle)` under one `// AI:` line, because `Z_Free` takes `OpaquePointer?` and `handle` is the generated accessor of the view.
- Hand edits on the drafts: the `!` after the three `CopyWinding` results goes, because the destination is optional. `(hull).numpoints` is `hull!.numpoints`, and `FreeWinding(hull)` is `FreeWinding(hull!)`.
- The stale Port-notes of round 2 are gone.
- Counts: 1 `TODO: Port` (pw), 8 `portMissing` calls, no `Unsafe` type in the file.

## Holes open

1. Row "the size of a scalar or a `vec3_t` in a host body". The size line of `AllocWinding`, `s = sizeof(vec_t)*3*points + sizeof(int)`, has no form, because no guide row gives `sizeof` of a scalar or of `vec3_t` and a body never writes `MemoryLayout`. The four `Com_Memcpy` sites below need the same row for `sizeof(vec3_t)`. This hole stops every allocation of the file at run time.
2. Row "a local `vec3_t` array as a `Slots`". `Com_Memcpy(_ dest: Slots<T>, _ src: Slots<T>, _ count: Int32)` does not take a Swift array. The drafter declares `p` of `RemoveColinearPoints` and `hullPoints` and `newHullPoints` of `AddWindingToConvexHull` as `[vec3_t]`. So the copies at `cm_polylib.cpp:92`, `:644`, `:703`, and `:710` have no form. A `BYTE_STORAGE_LOCALS` row for the three locals, or an array overload, closes them.
3. Row "a byte copy between two views of a record of variable size". `CopyWinding` sizes the copy as `(int)((winding_t *)0)->p[w->numpoints]`, an offset into the record, and copies `size` bytes from `w` to `c`. No guide row gives the offset, and no `Com_Memcpy` overload takes two views. `copy(from:)` of the view copies `sizeof(winding_t)`, which overruns an allocation of fewer than 4 points.
4. `pw` stays a dead stub by row 5 of the 2026-11-03 round.

## Gate

- `swift build`: exit 0.
- `swift test --no-parallel`: exit 0, 138 tests in 20 suites, 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem cm_polylib`: exit 0. 9 of 17 hand functions replaced, 8 kept, 8 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass.
