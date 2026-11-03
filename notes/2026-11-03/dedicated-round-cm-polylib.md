# Dedicated round: cm_polylib

Branch `dedicated-round-cm-polylib`, off `dedicated-stage-3-landing` at c167af7. The round stopped before the first hand edit. No body is transcribed and the stub stays unadopted.

## What landed

- Nothing in `Sources/`. `Sources/JKAMP_DedLogic/cm_polylib.swift` keeps its skeleton header.
- Counts: 17 function stubs, all 17 still carry `TODO: Port` and `portMissing`. The 5 counters and `MAX_HULL_POINTS` are already complete in the stub.

## Why the round stopped

The table has no row for `winding_t`. Every one of the 17 stubs carries `TODO: Port signature` with "No table row for `winding_t *`". `lookup.py winding_t` answers that no view exists. `HOST_ROOTS` in `tools/oracle-closure/rulings.py` has no `winding_t` row, so the generator makes no view and no signature.

Rule 13 and the transcription guide say a transcriptor does not change a signature. A signature change is its own commit, and a table change reruns every generator before its commit. That run (extract, merge, views, skeleton, reexport, `check.sh`, snapshot) does not fit the round, and the landing branch does not build, so no gate can prove it.

Two more facts block a body:

- `Z_Malloc` is `func Z_Malloc() -> Never` in `z_memman_pc.swift`. It takes no arguments, so `AllocWinding` cannot call it as Raven wrote it.
- `Z_Free` takes `OpaquePointer?` and `Com_Memcpy` takes `OpaquePointer?` for both pointers. A `FreeWinding` or `RemoveColinearPoints` body needs a view that gives those pointers.

## Open rows

1. The view of `winding_t`. Raven declares `int numpoints; vec3_t p[4];` and allocates `sizeof(vec_t)*3*points + sizeof(int)` bytes, so the record is variable sized. The guide has a rule for a root with a fixed layout and none for a record that Raven allocates larger than its declared size. Options: a `HOST_ROOTS` row `winding_t` to `Winding` in `CJKAMP_Ded` with `p` read as an indexed vec3 view over the allocated block, or a Swift-native `[vec3_t]` holder. Both need a ruling.
2. The `p[i]` element access. Raven passes `w->p[i]` as a `vec3_t` to `VectorSubtract`, `CrossProduct`, and `VectorNormalize2`, and writes `p[nump]` into `w->p`. The view must give a get and a set per point.
3. The `unsigned` write at `w` in `FreeWinding` (`0xdeaddead`). The first four bytes of the record are `numpoints`, so the view needs a raw word write or the sentinel must go in `numpoints` as a bit pattern.
4. The signature of `Z_Malloc` (`size`, `tag`, `zeroed`) and the result type. The `z_memman_pc` round owns it.
5. `pw` calls `printf` with float formats. Raven's `Com_Printf` arm has a `FormatArg` form, and the `printf` arm has no precedent in the host.
6. `AddWindingToConvexHull` and `ChopWindingInPlace` take `winding_t **`. The guide row for a pointer to a struct pointer gives `inout View?`, which fits once the view exists.

## Ledger

No row is ruled in this round.

## Ledger of the open rows

1. The view of `winding_t`: ruled. Raven declares `winding_t` in the header `cm_polylib.h`, so it joins `HOST_ROOTS` as `"winding_t": ("Winding", "CJKAMP_Ded")`, by the rule for a header struct that no root reaches (`docs/transcription.md:82`). The view binds over the declared record, and the larger allocation stays Raven's `Z_Malloc` size. Change: the table row, then a generator run, then the bodies.
2. The `p[i]` access: ruled. The `p` field reads as a `Slots<JKAShared.vec3_t>` with the 12-byte stride of `vec3_t`, the form of `WP_MuzzlePoint` in `BgTables.swift` (`docs/transcription.md:446`). A body reads `w.p[i]` and writes `w.p[nump] = ...`, and the slot past index 3 reads the allocated block as Raven does. Change: none past the view.
3. The `0xdeaddead` write in `FreeWinding`: ruled. The word at `w` is `numpoints`, so the body writes `w.numpoints = Int32(bitPattern: 0xdeaddead)`, the same four bytes. Precedent: rule 1, internals are free and the bytes are the behavior (`docs/porting-rules.md:7`). Change: the body line, with no `// AI:` line, because the bytes stay Raven's.
4. The `Z_Malloc` signature: ruled. The `z_memman_pc` round owns it, and a signature change is its own commit from the table (`docs/porting-rules.md:35`, `docs/transcription.md:73`). Change: a row in the table batch.
5. The float `printf` in `pw`: open for the user. The round did not prove a caller of `pw`, and no host or game site ports a bare `printf`. If `pw` has no caller in either tree, rule 20 keeps its stub as dead (`docs/porting-rules.md:45`).
6. The `winding_t **` parameters: ruled. The guide row for a pointer to a struct pointer gives `inout Winding?`, and it applies once row 1 lands. Change: the signatures come from the generator run of row 1.
