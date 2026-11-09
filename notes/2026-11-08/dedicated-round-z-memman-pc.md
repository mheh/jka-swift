# The z_memman_pc round, the zone allocator

This record holds the round of `Sources/JKAMP_DedLogic/z_memman_pc.swift`, the stem that row 4 of `notes/2026-11-03/dedicated-stage-3-landing.md` names after `win_shared` and `common`. The tree is the worktree `/tmp/jka-ded-zmem` on the branch `dedicated-round-z-memman-pc`, off master at 7dabbb5. The code commit is 32f87ec. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The stub had the skeleton header, so the round adopted it and removed the header in the code commit. The drafter gave 45 holes over the stem. The hole round filled every hole that a ruled form or a hand accessor of this round covers.

- Filled, 24 of 28 functions: Z_Validate, Z_Malloc, Z_MorphMallocTag, Z_Size, Z_Free, Z_MemSize, Z_TagFree, Z_Stats_f, Z_Details_f, Com_ShutdownZoneMemory, Com_InitZoneMemory, CopyString, Com_TouchMemory, Com_TheHunkMarkHasBeenMade, Com_InitHunkMemory, Com_ShutdownHunkMemory, Hunk_MemoryRemaining, Hunk_SetMark, Hunk_ClearToMark, Hunk_CheckMark, Hunk_Clear, Hunk_Alloc, Hunk_FreeTempMemory, and Hunk_ClearTempMemory.
- Stubs with a signature marker, 4: ZoneTailFromHeader, Zone_FreeBlock, S_Malloc, and Hunk_AllocateTempMemory. Each has a Port-note above its marker.
- The bodies of Z_Free, Z_TagFree, CopyString, Z_Malloc, and Hunk_Clear hold the holes of the table below.
- Raven's `memset(&TheZone, 0, sizeof(TheZone))` is `TheZone.clear()`, by the memset rule of a whole record. Raven's `return` after a `Com_Error` drops under rule 22, and his comment `// won't get here` stays.
- Raven's `#ifdef _WIN32` sleep in Z_Malloc and every `DETAILED_ZONE_DEBUG_CODE` arm drop, because the native build defines neither. His `assert` lines drop.
- Com_TouchMemory sums the words of each block with `&+=` under a rule 19 note, because Raven's `int` sum overflows on a large zone.

## The hand pieces

The C records are Raven's text in `Sources/CJKAMP_Ded/include/ded_types.h`, each with its `// Source:` line: `zoneHeader_t` (z_memman_pc.cpp:30), `zoneTail_t` (:39), `zoneStats_t` (:55), and `zone_t` (:69). The Swift side is one file, `Sources/JKAMP_Ded/Zone.swift`, and each piece carries one `// AI:` line.

| Piece | Raven's counterpart | Address computation |
|---|---|---|
| `ZoneHeader`, a view with `iMagic`, `eTag`, `iSize`, `pNext`, `pPrev`, and `byteCount` | `zoneHeader_t` | none |
| `ZoneHeader(block:)` | `((zoneHeader_t *)pvAddress) - 1` at :315, :385, :412 | the header from the block |
| `ZoneHeader.block` | `&pMemory[1]` at :164, :306, :649 | the block from the header |
| `ZoneTail`, a view with `iMagic` and `byteCount`, unaligned reads and writes | `zoneTail_t` | none |
| `ZoneTailFromHeader(_:)` | `ZoneTailFromHeader` at :45 | the tail from the header and the size |
| `ZoneStats`, a view with the three counts and the two `Slots<Int32>` tables | `zoneStats_t` | none |
| `Zone`, a view with `Stats`, `Header`, and `clear()` | `zone_t` | none |
| `Zone.record()` | `zone_t TheZone = {0}` at :77 | the zeroed allocation that `EngineWorld.TheZone` owns |
| `ZoneBackend.malloc`, `.calloc`, `.free` | `malloc`, `calloc`, `free` at :184, :186, :365 | the allocation, typed to the header view |

`ZoneTailFromHeader(_:)` in the view target has Raven's name, so the calls in Z_Validate, Z_Malloc, and Z_Free read as Raven wrote them. The private stub of the same name in the stem has no parameter, and Swift picks the view target's function for a call with one argument. `ZoneBackend.free` has no caller yet, because its caller is Zone_FreeBlock.

The two returns of CopyString from the static blocks are text: `""` for `gEmptyString` and the argument for a digit of `gNumberString`. Each has one `// AI:` line, by the precedent of `BG_StringAlloc`, which returns its text.

## Rows for the user

- Row Z1, the hand zone views. Question: `Zone.swift` holds hand views of four records that a `.cpp` file defines. Proposal: `HOST_ROOTS` takes `zoneHeader_t`, `zoneTail_t`, `zoneStats_t`, and `zone_t`, which `ded_types.h` now holds, the form of row 14 of `notes/2026-11-04/dedicated-open-rows-ledger.md` for `bitStorage_t`. The generator sequence then writes the views, and `TheZone` becomes an `EngineStorage` record. The hand views, `Zone.record()`, and `EngineWorld.TheZone` go in that commit. The three address accessors and `ZoneTailFromHeader(_:)` stay as hand accessors on the generated view.
- Row Z2, the signatures of ZoneTailFromHeader and Zone_FreeBlock. Question: the table has no row for `zoneHeader_t *`, so both stubs carry a signature marker. Proposal: row Z1 gives the row, and the skeleton writes `Zone_FreeBlock(_ pMemory: ZoneHeader)`. The calls of Zone_FreeBlock in Z_Free (:442) and Z_TagFree (:465) are holes until then. ZoneTailFromHeader then keeps one home, the view target, and the stub takes a forward or a "body in the view target" entry.
- Row Z3, the `void *` returns of S_Malloc and Hunk_AllocateTempMemory. Question: both return a `Z_Malloc` block, and `RETURNS` of `rulings.py` has no row for them. Proposal: both take `raw`, the row of `Z_Malloc` and `Hunk_Alloc` at `tools/oracle-closure/rulings.py:450-452`. CopyString then reads `_ = S_Malloc(strlen(in) + 1)` and returns its text, the `G_Alloc` form of `docs/transcription.md`.
- Row Z4, the static blocks. Question: `gZeroMalloc`, `gEmptyString`, and `gNumberString` (:139 to :154) have no storage, so the `iSize == 0` arm of Z_Malloc is a hole. Proposal: `StaticZeroMem_t` and `StaticMem_t` join `ded_types.h` under Raven's `#pragma pack(1)`, and `tables.py` copies the three initializers into `ded_tables.c`, the form of `PADDING`.
- Row Z5, `ZoneBackend`. Question: Raven's zone calls `malloc`, `calloc`, and `free`, and rule 11 keeps a raw pointer out of the logic target. Proposal: keep the one hand enum in the view target, which returns `ZoneHeader?`, so a failed allocation is nil and Raven's recovery loop stays. It calls `Foundation.malloc`, `Foundation.calloc`, and `Foundation.free`, which the macOS build proves. The Windows lane has not built it.
- Row Z6, the renderer and Ghoul2 names. Question: `R_HunkClearCrap` and `RE_RegisterModels_LevelLoadEnd` of tr_model.cpp, and `g_Ghoul2Allocations`, `g_G2ClientAlloc`, `g_G2ServerAlloc`, and `G2_DEBUG_ReportLeaks` of G2_API.cpp, have no Swift stub, because row E5 makes those files a later port stage. Hunk_Clear stops first at the `SV_ShutdownGameProgs` stub of sv_game.swift, and after that stub has a body it stops at `R_HunkClearCrap`. Proposal: no change in this round, and the stage that adds those files fills the holes.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| Z_Malloc | :161 | `gZeroMalloc` for `iSize == 0` | Z4 |
| Z_Malloc | :226 | `RE_RegisterModels_LevelLoadEnd` in the recovery loop | Z6 |
| Z_Free | :442 | `Zone_FreeBlock(pMemory)` | Z2 |
| Z_TagFree | :465 | `Zone_FreeBlock(pMemory)` | Z2 |
| CopyString | :619 | `S_Malloc(strlen(in)+1)` and the copy | Z3 |
| Hunk_Clear | :768 | `R_HunkClearCrap()` | Z6 |
| Hunk_Clear | :776 | the Ghoul2 leak report | Z6 |

The polylib tests stay disabled. AllocWinding now runs through Z_Malloc, but FreeWinding stops at the Zone_FreeBlock hole of Z_Free, so both tests need row Z2 first.

## The gate

| Check | Result |
|---|---|
| `swift build` | exit 0, 0 errors, 0 warnings in the gate run |
| `swift test --no-parallel` | exit 0, 145 tests, 142 pass, 3 skipped: the two polylib tests and the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem z_memman_pc` | exit 0, 17 of 28 hand functions replaced, 11 kept, 45 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 45 holes are in the drafter's output, not in the working tree. The working tree holds 7 body holes and 4 signature markers, which the tables above list. The first build of the round printed two "will never be executed" warnings, at the statements after the holes of Z_Malloc and Hunk_Clear.
