# The open rows of the dedicated host, the third ledger of 2026-11-04

This record holds the third batch of open rows of the dedicated host. The user ruled rows 1 to 6 by delegation on 2026-11-04. The landing is the branch `dedicated-rulings-batch-3`, off master at `54dd8c9`, in the worktree `/tmp/jka-ded-rules-3`. The generator sequence of `tools/oracle-closure/README.md` ran once over the whole batch: the extracts of the nine merge modules, merge, tables, check, the reexport of `JKAShared` and `JKAMP_Ded`, views, skeleton, and manifest for the three units, traps for the game and the cgame, and channel. The merge moved an SP UI header on this case-insensitive file system, and the landing kept master's `Sources/CJKASP_UI`. The round bodies stay as they were, except where a row says "and fill".

## Row 1, msg_t.data as a byte slots field

Question: the `data` field of the `Msg` view is `OpaquePointer?`, so every body that reads message bytes writes `UnsafeMutableRawPointer(msg.data!)` in the logic target. What form does the field take?

Sites: the 36 lines of `msg.swift` in `notes/2026-11-04/dedicated-round-msg-4.md`, the 9 lines of `net_chan.swift`, and the two Com_Memcpy holes and the two `buffer` locals of `huffman.swift`.

Verdict: ratified as proposed, delegated, 2026-11-04. `("msg_t", "data")` takes the FIELDS kind `bytes`, so `Msg.data` is `Slots<JKAShared.byte>?` with the widest count. The PARAMS kind `bytes` gives `data` of `MSG_WriteData` and `MSG_ReadData` the spelling `Slots<JKAShared.byte>`. `Slots<byte>` gets the word subscripts `[int:]`, `[float:]`, `[ushort:]`, and `[byte:]` of the raw pointer, each with a rule 24 line, so a body writes `msg.data![int: msg.cursize]`. A delta walker reads a field offset through the bytes of the record, `Slots(record: from).bytes[int: field.offset]`.

The rows reach the field `Msg.data` and five host signatures: `MSG_Init`, `MSG_InitOOB`, `MSG_WriteData`, `MSG_ReadData`, and `Netchan_Transmit`, each with `_ data: Slots<JKAShared.byte>`.

Deviations: `MSG_Init` and `MSG_InitOOB` move from the PARAMS kind `opaque` to `bytes`, because each stores `data` into the field, and `Netchan_Transmit` moves too, because it hands `data` to `MSG_WriteData`. The bodies keep their form, but a body that used the old `OpaquePointer?` does not compile, so each such site takes the smallest edit that compiles: `msg.data!.base` for `UnsafeMutableRawPointer(msg.data!)` at 10 sites of `msg.swift`, 3 of `net_chan.swift`, and 2 of `huffman.swift`, `data.base` at the two `MSG_WriteData` and `MSG_ReadData` reads, and in `net_chan.swift` a `Slots(scalars:)` over the two `send_buf` allocations, `OpaquePointer($0.base)` where `NET_SendPacket` and `Com_Memcpy` take a handle, and `suffix(from:)` for the `MSG_WriteData` fragment, under a reworded rule 24 line. The rounds rewrite these sites.

Files: `tools/oracle-closure/rulings.py`, `Sources/JKAMP_Ded/Generated/Views/Msg.swift`, `Sources/JKAShared/Views/Slots.swift`, `Sources/JKAMP_DedLogic/msg.swift`, `Sources/JKAMP_DedLogic/net_chan.swift`, `Sources/JKAMP_DedLogic/huffman.swift`, and `Tests/JKASharedTests/SlotsTests.swift`.

## Row 2, storage homes for locals

Question: `UINT4 x[16]` of MD4Transform, `unsigned char bits[8]` of MD4Final, `unsigned regs[4]` of the CPUID callers, and the `vec3_t` arrays of cm_polylib.cpp have no storage home for a `Slots` parameter, and `PADDING` of md4.cpp is a hand `[UInt8]`. What homes do they take?

Sites: `oracle/codemp/qcommon/md4.cpp:149`, `:174`, and `:78`, `oracle/codemp/win32/win_shared.cpp:137`, `:176`, `:190`, and `:230`, and `oracle/codemp/qcommon/cm_polylib.cpp:69`, `:632`, and `:633`.

Verdict: ratified as proposed, delegated, 2026-11-04. BYTE_STORAGE_LOCALS names each local. `x` is a `Slots<UInt32>` of 16, because the TYPES spelling of `UINT4` holds behind the array, and `bits` is a `Slots<JKAShared.byte>` of 8. A key of a local and its function, `("regs", "IsKNI")`, gives each of the four CPUID callers `Is3DNOW`, `IsKNI`, `IsWIL`, and `IsMMX` its own `Slots<UInt32>` of 4, `regs_IsKNI`, by the static-local suffix rule. `p`, `hullPoints`, and `newHullPoints` are `Slots<JKAShared.vec3_t>` of `MAX_POINTS_ON_WINDING` and 128 with Raven's 12-byte stride. `PADDING` joins `SCALAR_DATA_TABLES`, `tables.py` copies Raven's rows into `ded_tables.c`, `ded_tables.h` declares it, and `DedTables.swift` reads it as a `Slots<JKAShared.byte>` under a rule 24 line. The hand property of `EngineWorld` is gone. The forwards of the adopted files take the skeleton's text.

Deviation: win_shared.cpp has four `regs` callers, not five. `Is3DNOW` also hands `char pstring[16]` to CPUID at `win_shared.cpp:142`, which this row does not cover.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/skeleton.py`, `tools/oracle-closure/tables.py`, `Sources/CJKAMP_Ded/ded_tables.c`, `Sources/CJKAMP_Ded/include/ded_tables.h`, `Sources/JKAMP_Ded/DedTables.swift`, `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, `Sources/JKAMP_DedLogic/EngineWorld.swift`, `Sources/JKAMP_DedLogic/md4.swift`, `Sources/JKAMP_DedLogic/cm_polylib.swift`, and `Sources/JKAMP_DedLogic/win_shared.swift`.

## Row 3, sizeof in a host body

Question: `s = sizeof(vec_t)*3*points + sizeof(int)` of AllocWinding at `oracle/codemp/qcommon/cm_polylib.cpp:41` has no form, and a body never writes `MemoryLayout`.

Verdict: ratified as proposed, delegated, 2026-11-04. `sizeof(T)` of a scalar alias or a vector is `T.byteCount`. `Sources/JKAShared/Views/ByteCount.swift` gives the static to `Int8`, `UInt8` (`byte`), `Int16`, `UInt16` (`word`), `Int32` (`int` and every `Int32` alias), `UInt32` (`UINT4`, and `ulong` where `unsigned long` is 4 bytes), `UInt` (`ulong` where it is 8 bytes), `Float` (`vec_t`), `Double`, and `vec2_t`, `vec3_t`, and `vec4_t` with the size of the C type, so `vec3_t.byteCount` is 12.

Files: `Sources/JKAShared/Views/ByteCount.swift` and `Tests/JKASharedTests/SlotsTests.swift`.

## Row 4, a byte copy between two views of a record of variable size

Question: CopyWinding sizes its copy as `(int)((winding_t *)0)->p[w->numpoints]` and copies that many bytes between two windings, `oracle/codemp/qcommon/cm_polylib.cpp:255` and `:256`.

Verdict: ratified as proposed, delegated, 2026-11-04. `Com_Memcpy(_ dest: V, _ src: V, _ count: some BinaryInteger)` of `Sources/JKAShared/CString.swift` copies the first `count` bytes between two views of one record type. `Winding.byteCount(points:)` of `Sources/JKAMP_Ded/WindingSize.swift` gives the offset of point n. Each carries a rule 24 line.

Files: `Sources/JKAShared/CString.swift` and `Sources/JKAMP_Ded/WindingSize.swift`.

## Row 5, the counts of Com_Memcpy and memmove

Question: the `Slots` overloads take an `Int32` count, and Raven passes `unsigned int` and `size_t`, so md4 and cmd_common sites carry conversions Raven did not write.

Verdict: ratified as proposed, delegated, 2026-11-04, and filled for the wraps. The count of each `Com_Memcpy` overload and of the `Slots` `memmove` is `some BinaryInteger`, under a rule 24 line. `suffix(from:)` gets a generic form beside the `Int` form, because a generic form alone loses to the `Collection` form for an `Int` offset. `slot(at:)` already took any C integer. The `Int32(...)` and `Int(...)` wraps are gone at `md4.swift` MD4Update, three lines, and at `cmd_common.swift` Cbuf_AddText and Cbuf_Execute, two lines.

Files: `Sources/JKAShared/CString.swift`, `Sources/JKAShared/Views/Slots.swift`, `Sources/JKAMP_DedLogic/md4.swift`, and `Sources/JKAMP_DedLogic/cmd_common.swift`.

## Row 6, drafter reads

Question: the drafter declares a BYTE_STORAGE_LOCALS local as a Swift array, keeps a `(unsigned char *)` cast of a `Slots` as a hole, and writes Com_Memset over a record with an Unsafe type.

Verdict: ratified as proposed, delegated, 2026-11-04. `storage_local_names` of `draft_classification.py` reads the entry for each function. The declaration of such a local is a rule 24 line that names its forward, a read of the local is the forward, and a parameter of the entry is copied into its slot at the head of the body. `byte_view` of `draft_calls.py` gives `digest.bytes` for a cast handed to a `Slots<byte>`, the `Slots` itself where it holds bytes, and `key_Com_BlockChecksumKey.bytes` for `&key`. A `Com_Memset` of zero with a `sizeof` size takes the `memset` forms, `context.clear()` and `x.zero()`, and `sizeof` of a pointer keeps the call.

Two guards keep other drafts. A local of another function whose name is a storage forward takes no `Slots` answer from the registry, which also corrects `cl.lastClientCommand = seq` of SV_ClientCommand. A text argument passes to a `CharBuf` overload before the `Slots` hole, so `MSG_WriteData(sb, string, l + 1)` keeps its draft.

The md4 draft holds 107 holes before and 97 after. The 97 are the 96 `FF`, `GG`, and `HH` macro lines and `&input[i]` of MD4Update. The huffman draft holds 33 holes before and after, because its sites were not holes: `seq` is now the forward line, and the three Com_Memset calls are `clear()` or a dropped scratch clear.

Files: `tools/oracle-closure/bodies.py`, `tools/oracle-closure/draft_calls.py`, `tools/oracle-closure/draft_classification.py`, `tools/oracle-closure/draft_declarations.py`, `tools/oracle-closure/draft_expressions.py`, and `tools/oracle-closure/draft_statements.py`.

## The gate

- The game snapshot check read 372 files and found no difference, exit 0.
- The cgame snapshot check read 246 files and found no difference, exit 0.
- The host snapshot check read 165 files and found 23 differing files, exit 1, all at the sites of the rows: the bodies of cm_polylib, common, huffman, md4, msg, net_chan, sv_client, sv_init, sv_snapshot, sv_world, vm, and win_shared, the manifests of cm_polylib, md4, msg, net_chan, and win_shared, the skeleton text of the same five, and the view `Msg.swift`.
- `swift build` passed, exit 0.
- `swift test --no-parallel` passed 141 tests with 1 skipped, the interpreter test, exit 0.
- The tool tests passed 97 tests with 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over msg, huffman, net_chan, md4, cm_polylib, and win_shared gave 268 holes, 0 cascade errors, 1 defect, and 6 compile holes over 3 passes, exit 1. Per stem: msg 92 holes, huffman 33, net_chan 22, md4 97, cm_polylib 8, and win_shared 16 with the 6 compile holes and the defect. The defect is at the draft of Sys_Milliseconds, `win_shared.swift:46`, a compile hole whose marker stands where an `Int32` is due. The host snapshot shows that draft unchanged from master, so the defect stands outside the rows.

## Findings for a later row

- The drafter does not write `suffix(from:)` for Raven's `data + offset` handed to a `Slots`, so `MSG_WriteData(&send, chan->unsentBuffer + chan->unsentFragmentStart, ...)` of net_chan and `&input[i]` of MD4Update stay holes.
- The drafter reads `buf->data = data` of MSG_Init as a store of a `Slots` into one record, so the store stays a hole.
- `char pstring[16]` of Is3DNOW goes to CPUID as `unsigned int *` and has no form.
