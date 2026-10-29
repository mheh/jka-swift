# The profile of the release module, and the performance docket

Taken 2026-10-29 on master at 8cde4f3, after the numbers of `performance-number.md`. The sample and the replay log sit in `profile/` beside this record. Ruled 2026-10-29: the five rows below are built after the MP cgame module, one measurement after each row.

## The sample

`sample` of `openjkded.arm64` for 4 seconds at 1 ms, started 2.5 seconds into the 31-bot replay of `corpus-ffa1-human-3.rec` on `mp/ffa1`, `+ref_step 6500`, with the release module `.build/release/libjampgame.dylib` copied as `jampgamearm64.dylib`. The file is `profile/release-31-bots.sample`, 1 MB of text, and `profile/release-31-bots.log.gz` is the server log of that run, which reached `REF REPLAY END` with exit 0.

Top of stack, the heaviest frames of the whole process, from the "Sort by top of stack" section of the sample:

| Frame | Samples | Where |
|---|---|---|
| `SVRef_PostGameFrame()` | 258 | the engine, the referee's checksum per step |
| `__select` | 94 | the kernel, the server's idle wait |
| `CM_TraceThroughBrush`, `CM_TraceThroughLeaf`, `CM_TraceThroughTree` | 90, 87, 87 | the engine, the collision traces the module asks for |
| `_xzm_free`, `_xzm_xzone_malloc`, `_free`, `malloc_type_malloc` | 75, 35, 26, 16 | the allocator |
| `swift_release`, `swift_retain`, `swift_allocObject`, `swift_deallocObject`, `doDecrementSlow` | 63, 26, 33, 25, 44 | the Swift runtime, reference counting and objects |
| `AccessSet::insert`, `swift_beginAccess`, `SwiftTLSContext::get` | 61, 40, 25 | the Swift runtime, exclusivity checks |
| `BinaryInteger.isSigned`, `bitWidth`, `_lowWord` dispatch thunks | 58, 46, 22 | the Swift runtime, unspecialized generic integer calls |
| `Slots.subscript.getter` | 54 | the module, the view table subscript |
| `_StringGuts.append`, `String.init` from `CharBuf` | 23, 14 | the Swift runtime, text copies |
| `SIMD3.subscript.getter` and `.setter` | 16, 37 | the module, vector field reads and writes |
| `Collection.map` | 16 | the module, a per-call array build |

The deeper frames of the call graph, by sample count inside the module: `Syscall.call` at `Syscall.swift:18` and `Syscall+Game.swift:8` with `ContiguousArray._createNewBuffer` under it, `Slots.init(scalars:count:)` at `Slots.swift:56-57`, `Trace.scratch` at `Trace.swift:35`, the `pm` getter at `bg_pmove.swift:12`, and `Slots.subscript.getter` through `Int32Indexing.swift:7`.

## What the sample says

The referee's own checksum is the single heaviest frame, so the per-step numbers of `performance-number.md` carry the referee's cost on both modules. The engine's collision traces are the next, and the module asks for them as Raven's bodies do. Of the module's own cost, none is in the transcribed bodies. It is in the view layer and the runtime under it:

1. Reference counting and object allocation. Transient views are objects. `Slots.init(scalars:count:)` builds a fresh object every time a body reads a vector field through a view, `Trace.scratch` allocates per trace call, and `String.init` from a `CharBuf` copies on every text read. Each is a malloc and a free inside the frame.
2. Unspecialized generic integer calls. The view subscripts take a generic `BinaryInteger` index across the module boundary, so every index goes through a witness table instead of a plain load.
3. Exclusivity checks. Every read of a global through `world` and `bg`, for example the `pm` getter, pays a dynamic access check.
4. The syscall path. `Syscall.call` builds a fresh array per call for the arguments, one allocation per trap call, and the module makes thousands per frame.

## The docket, five rows

Each row changes the view layer or the build, and no body. Each row ends with the two replays of `performance-number.md` under the same wall-time method, the solo recording and the 31-bot recording, against the numbers of that record as the baseline.

- R1. Cross-module optimization and inlinable views. The view subscripts and the small helpers of `JKAShared` take `@inlinable`, or the package builds with cross-module optimization, so the generic index specializes to a plain load. Expected: the three dispatch thunks and most of the `Slots` cost go.
- R2. No object per view read. `Slots` and the other transient views become structs over a raw pointer and a stride, so a vector read is a load and not an allocation. The trace scratch becomes a stack buffer. Expected: most of the retain, release, and allocator cost goes.
- R3. A stack buffer for the syscall arguments. `Syscall.call` takes `withUnsafeTemporaryAllocation` or a fixed tuple. Expected: one malloc and one free per trap call go.
- R4. Exclusivity off in release, `-enforce-exclusivity=unchecked`. A build flag and a judgment call, because it removes a class of runtime diagnostics. It comes after R1 to R3 and a measurement.
- R5. Text reads without a copy. A `char *` field read that only compares or prints does not build a `String`. This touches the view layer's string form and is the slowest row to do well.

Not a row: `-Ounchecked`. It removes the bounds precondition that found W1 and W2, and those traps are the port's referee on the module side.

## The baseline

`performance-number.md`: the C module loads in 0.5 s and steps 2800 frames in 0.4 s more, the Swift release module loads in 1.7 s and steps 2800 frames in 0.8 s more, on the solo recording. The 31-bot recording of 6500 steps ran in 7.8 s and 7.6 s whole-process on the release module and in 46.1 s on the debug build. The map load, three times the C module's, has no profile yet and gets one when R1 to R3 are in.
