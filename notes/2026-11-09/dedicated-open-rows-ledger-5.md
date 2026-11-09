# The open rows of the dedicated host, the fifth ledger

This record holds the fifth batch of open rows of the dedicated host: rows Z1 to Z5 of `notes/2026-11-08/dedicated-round-z-memman-pc.md`, the row "CharBuf as send data" of `notes/2026-11-09/dedicated-round-net-chan-5.md`, and a drafter row. The user ruled the rows by delegation on 2026-11-09. The landing is the branch `dedicated-rulings-batch-5`, off master at `d540740`, in the worktree `/tmp/jka-ded-rules-5`. The generator sequence of `tools/oracle-closure/README.md` ran once over the whole batch, after every change: the extracts of the nine merge modules, merge, tables, check, the reexport of `JKAShared` and `JKAMP_Ded`, views, skeleton, and manifest for the three units, traps for the game and the cgame, and channel. The merge moved an SP UI header on this case-insensitive file system, and the landing kept master's `Sources/CJKASP_UI`. The round bodies stay as they were, except where a row says "and fill".

## Row 1 (Z1), the zone views

Question: `Sources/JKAMP_Ded/Zone.swift` held hand views of four records that z_memman_pc.cpp defines. Do the views come out of the generator?

Sites: `oracle/codemp/qcommon/z_memman_pc.cpp:30`, `:39`, `:55`, `:69`, and `TheZone` at `:77`.

Verdict: ratified as proposed, delegated, 2026-11-09. `zoneHeader_t`, `zoneTail_t`, `zoneStats_t`, and `zone_t` join `HOST_ROOTS`, the form of `bitStorage_t`. The views `ZoneHeader`, `ZoneTail`, `ZoneStats`, and `Zone` are generated, and `TheZone` is a record on `EngineStorage`. The hand file keeps `ZoneHeader(block:)`, `ZoneHeader.block`, `ZoneTailFromHeader(_:)`, and `ZoneBackend`, each with its rule 24 line. `Zone.record()` and `EngineWorld.TheZone` are gone. The forward of `TheZone` in z_memman_pc.swift takes the skeleton's text, `world.storage.TheZone`.

Deviations: the hand file is now `Sources/JKAMP_Ded/ZoneBlocks.swift`, because SwiftPM refuses two files named `Zone.swift` in one target. The `eTag` field is `memtag_t`, the `Int32` alias of `ENUM_TYPEDEFS`, over a C `char`, so `views.py` now gives a field of an `ENUM_TYPEDEFS` typedef a getter that widens and a setter that truncates, the form the hand view had.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/views.py`, `Sources/JKAMP_Ded/Generated/Views/ZoneHeader.swift`, `ZoneTail.swift`, `ZoneStats.swift`, and `Zone.swift` under the same folder, `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, `Sources/JKAMP_Ded/ZoneBlocks.swift`, `Sources/JKAMP_DedLogic/EngineWorld.swift`, and `Sources/JKAMP_DedLogic/z_memman_pc.swift`.

## Row 2 (Z2), ZoneTailFromHeader and Zone_FreeBlock

Question: the table had no row for `zoneHeader_t *`, so both stubs carried a signature marker, and the calls of Zone_FreeBlock in Z_Free and Z_TagFree were holes.

Sites: `oracle/codemp/qcommon/z_memman_pc.cpp:45`, `:342`, `:442`, and `:465`.

Verdict: ratified as proposed, delegated, 2026-11-09, and filled. The skeleton writes `private func Zone_FreeBlock(_ pMemory: ZoneHeader)`, and the body is Raven's, with his assert lines dropped and `free` as `ZoneBackend.free(pMemory)`. Z_Free and Z_TagFree call it at Raven's lines. The stub of ZoneTailFromHeader goes away. The skeleton gives it `-> ZoneTail?`, and a private stub of that name hides the view target's function from every call of the file. The view target owns the body under Raven's name, the precedent of the traps of `g_syscalls.c`, which have no logic stub. The calls keep `ZoneTailFromHeader(current).iMagic`.

The two winding tests of `Tests/JKAMP_DedLogicTests/PolylibTests.swift` have no `.disabled` now, and both pass.

Files: `Sources/JKAMP_DedLogic/z_memman_pc.swift` and `Tests/JKAMP_DedLogicTests/PolylibTests.swift`.

## Row 3 (Z3), the returns of S_Malloc and Hunk_AllocateTempMemory

Question: both functions return a `Z_Malloc` block, and `RETURNS` had no row for them.

Sites: `oracle/codemp/qcommon/z_memman_pc.cpp:480` and `:804`, and CopyString at `:619`.

Verdict: ratified as proposed, delegated, 2026-11-09, and filled. Both take the `RETURNS` kind `raw`, the row of `Z_Malloc` and `Hunk_Alloc`. S_Malloc returns `Z_Malloc(iSize, TAG_SMALL)`, and Hunk_AllocateTempMemory returns `Z_Malloc(size, TAG_TEMP_HUNKALLOC, false)` with Raven's comment. CopyString reads `_ = S_Malloc(strlen(in) + 1)` and returns its text under a rule 24 line, the `G_Alloc` form. The block stays in the zone, because the caller gets a `String` and frees no block.

Files: `tools/oracle-closure/rulings.py` and `Sources/JKAMP_DedLogic/z_memman_pc.swift`.

## Row 4 (Z4), the static blocks

Question: `gZeroMalloc`, `gEmptyString`, and `gNumberString` had no storage, so the `iSize == 0` arm of Z_Malloc was a hole.

Sites: `oracle/codemp/qcommon/z_memman_pc.cpp:122` to `:154`, Z_Malloc at `:161`, and CopyString at `:612` and `:616`.

Verdict: ratified as proposed, delegated, 2026-11-09, and filled. `StaticZeroMem_t` and `StaticMem_t` join `ded_types.h` under Raven's `#pragma pack(1)` and `HOST_ROOTS`, so the views `StaticZeroMem` and `StaticMem` are generated. `tables.py` copies Raven's `ZONE_MAGIC` line and the three initializers into `ded_tables.c`, `ded_tables.h` declares them, and `DedTables.swift` reads them as `StaticZeroMem`, `StaticMem`, and `Slots<StaticMem>`. The stub entries take the skeleton's data-table text. Z_Malloc reads `let pMemory = ZoneHeader(gZeroMalloc)` and `return pMemory.block`, the cast form of a view, with no rule 24 line. CopyString returns the text of the `mem` bytes of `gEmptyString` and of `gNumberString[in[0] - '0']`, each under a rule 24 line, because the function returns a `String` and not a pointer into the block.

Files: `Sources/CJKAMP_Ded/include/ded_types.h`, `Sources/CJKAMP_Ded/include/ded_tables.h`, `Sources/CJKAMP_Ded/ded_tables.c`, `tools/oracle-closure/tables.py`, `tools/oracle-closure/rulings.py`, `Sources/JKAMP_Ded/Generated/Views/StaticZeroMem.swift`, `Sources/JKAMP_Ded/Generated/Views/StaticMem.swift`, `Sources/JKAMP_Ded/DedTables.swift`, and `Sources/JKAMP_DedLogic/z_memman_pc.swift`.

## Row 5 (Z5), ZoneBackend on every platform

Question: `ZoneBackend` called `Foundation.malloc`, `Foundation.calloc`, and `Foundation.free`, and only the macOS build proved it.

Sites: `oracle/codemp/qcommon/z_memman_pc.cpp:184`, `:186`, and `:365`.

Verdict: ratified as proposed, delegated, 2026-11-09. `ZoneBlocks.swift` imports the C library module of its platform, `Darwin`, `Glibc`, `Musl`, or `ucrt`, under `#if canImport`, the form of `Sources/jampsmoke/main.swift`, and imports no Foundation. Each call names that module, because the member of the same name hides the C function. The enum still returns `ZoneHeader?`, so a failed allocation is nil and Raven's recovery loop stays. The macOS build proves the `Darwin` arm. The Linux and Windows lanes run on the next CI push.

Files: `Sources/JKAMP_Ded/ZoneBlocks.swift`.

## Row 6, CharBuf as send data

Question: NET_OutOfBandPrint hands its `char string[MAX_MSGLEN]` to NET_SendPacket, whose `data` is a `Slots<byte>`.

Sites: `oracle/codemp/qcommon/net_chan.cpp:531` and `:575`.

Verdict: ratified as proposed, delegated, 2026-11-09, by the second arm, and filled. A `CharBuf` is a struct over a Swift array, so its bytes have no fixed address, and a `bytes` accessor cannot return a `Slots` that lives past the access. NET_SendPacket takes a `CharBuf` overload in net_chan.swift, after the original, with a Port-note and a rule 24 line, as the `MSG_WriteData` overload has. NET_OutOfBandPrint reads `NET_SendPacket(sock, strlen(string), string, adr)`.

Deviation: the overload needs a `Slots<byte>` without an `Unsafe` type in the logic target. `withSlots` of `Sources/JKAShared/CharBuf.swift` gives the bytes of the buffer to a closure as a `Slots<byte>`, under a rule 24 line, and the overload calls the original inside it.

Files: `Sources/JKAShared/CharBuf.swift` and `Sources/JKAMP_DedLogic/net_chan.swift`.

## Row 7, the drafter

Question: the drafter wrote the element subscript for a byte store where the hand form is `[byte:]`, left `mbuf.data = string` as a hole, and wrote an empty right side for the calls of `timeGetTime` in Sys_Milliseconds and `WSAGetLastError` in NET_ErrorString.

Sites: `oracle/codemp/qcommon/huffman.cpp:15`, `:17`, `:34`, and `:36`, `oracle/codemp/qcommon/net_chan.cpp:600`, `oracle/codemp/win32/win_shared.cpp:24` and `:27`, and `oracle/codemp/win32/win_net.cpp:46`.

Verdict: ratified as proposed, delegated, 2026-11-09.

- A store into one byte of a `Slots<byte>` whose value C computes in `int`, a literal or a compound assignment, is `fout[byte: (bloc >> 3)] |= bit << (bloc & 7)`. A byte into a byte keeps the element subscript.
- A store of a `Slots<byte>` into a field of FIELDS kind `bytes` is `mbuf.data = string_NET_OutOfBandData`. The same rule gives `buf.data = data` in MSG_Init and MSG_InitOOB and `cmd_text.data = cmd_text_buf` in Cbuf_Init.
- A byte local of BYTE_STORAGE_LOCALS reads through its forward in a byte store, so `string[0] = 0xff` of NET_OutOfBandData drafts `string_NET_OutOfBandData[0] = 0xff`.
- A call to a function that no header of the parse declares is a hole with a Port-note that names it. The C++ parse gives such a call an unresolved name, which the drafter spelled as nothing. The rule also reaches `GlobalMemoryStatus` and `kbhit` of win_main and `operator!=` of SE_GetString in stringed_ingame.

Draftcheck of win_shared and win_net before the change: win_shared 16 holes, 0 defects, 6 compile holes, and win_net 74 holes, 3 cascade errors, 1 defect, 8 compile holes, exit 1. After the change: win_shared 27 holes, 0 defects, 10 compile holes, and win_net 78 holes, 0 cascade errors, 0 defects, 0 compile holes, exit 0. The win_shared compile holes include `if baseTime == 0` of Sys_Milliseconds, a C++ `bool` the drafter tests against zero.

Files: `tools/oracle-closure/draft_classification.py`, `tools/oracle-closure/draft_expressions.py`, and `tools/oracle-closure/draft_statements.py`.

## The gate

- The game snapshot check read 372 files and found no difference, exit 0.
- The cgame snapshot check read 246 files and found no difference, exit 0.
- The host snapshot check read 171 files and found a difference, exit 1. The bodies of cmd_common, huffman, msg, net_chan, stringed_ingame, win_main, win_net, win_shared, and z_memman_pc differ, and so do the manifests of net_chan and z_memman_pc and the skeleton text of z_memman_pc. Six views are new: StaticMem, StaticZeroMem, Zone, ZoneHeader, ZoneStats, and ZoneTail. The net_chan manifest differed from the cache before the batch too, by the line moves of the fifth net_chan round.
- `swift build` passed, exit 0, 0 errors.
- `swift test --no-parallel` passed 146 tests with 1 skipped, the interpreter test, exit 0. The two winding tests of `PolylibSuite` pass.
- The tool tests passed 97 tests with 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over z_memman_pc, net_chan, win_net, and win_shared gave 137 holes, 0 cascade errors, 0 defects, and 10 compile holes over 4 passes, exit 0. Per stem: z_memman_pc 12 holes, net_chan 20, and win_net 78, each with 0 compile holes, and win_shared 27 with the 10 compile holes.

`grep Unsafe` of z_memman_pc.swift gives the four `UnsafeMutableRawPointer` returns of the `RETURNS` kind `raw`, Z_Malloc, S_Malloc, Hunk_Alloc, and Hunk_AllocateTempMemory. net_chan.swift gives 0.

## The open holes of z_memman_pc

| Function | Line | Hole | Row |
|---|---|---|---|
| Z_Malloc | :226 | `RE_RegisterModels_LevelLoadEnd` in the recovery loop | Z6 |
| Hunk_Clear | :768 | `R_HunkClearCrap()` | Z6 |
| Hunk_Clear | :776 | the Ghoul2 leak report | Z6 |
