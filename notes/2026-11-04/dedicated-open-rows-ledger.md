# The open rows of the dedicated host, the ledger of 2026-11-04

This record holds the open rows of the dedicated host table batch, and the rows that joined the batch on the same day. The user ruled rows 1 to 7 by delegation ("ratify as you see fit"). The coordinator added rows 8 to 14. The landing is the branch `dedicated-rulings-batch`, off master at `5323708`, in the worktree `/tmp/jka-ded-rules`. The generator sequence of `tools/oracle-closure/README.md` ran once over the whole batch: merge, tables, check, the reexport of `JKAMP_Ded`, views, skeleton, and manifest for the three units, and traps and channel for the game and the cgame.

## Row 1, a record passed by value

Question: a record Raven passes by value crosses as its view in a function that is not a trap. Is that the rule?

Proof: `tools/oracle-closure/spelling.py:496`. The rule reaches the ten `net_chan` signatures, `CL_PacketEvent`, `SV_PacketEvent`, `SV_ConnectionlessPacket`, `SV_DirectConnect`, `SV_GetChallenge`, `SV_AuthorizeIpPacket`, `SVC_Info`, `SVC_Status`, `SVC_RemoteCommand`, `Sys_SendPacket`, and `Sys_IsLANAddress`. No host body writes such a parameter.

Verdict: ratified as proposed, delegated, 2026-11-04. The view aliases the caller's record, so a body that writes such a parameter takes a scratch copy.

Files: `tools/oracle-closure/spelling.py` (one comment sentence), `docs/porting-rules.md` (one sentence in rule 5), and `Sources/JKAMP_DedLogic/win_net.swift` (the `Sys_SendPacket` and `Sys_IsLANAddress` signatures from `lookup.py sig`).

## Row 2, the C++ bool

Question: the C++ `bool` of the host files is `Bool` for a parameter and a return. Does a C++ default stay?

Proof: `tools/oracle-closure/spelling.py:503` and `:524`. Raven declares `bool readUntilEOL = false` at `oracle/codemp/qcommon/GenericParser2.cpp:15` and `bool baseTime = false` at `oracle/codemp/qcommon/qcommon.h:978`. The `Sys_Milliseconds` row is at `notes/2026-11-03/dedicated-stage-3-landing.md:134`. The generator kept no default before this batch, so `skeleton.py` now reads the C++ default of a `bool` parameter from the definition or the first declaration.

Verdict: ratified as proposed, delegated, 2026-11-04.

Files: `tools/oracle-closure/skeleton.py` (`bool_default` and the signature), `tools/oracle-closure/table.py` (the `default` of a `Param`), `Sources/JKAMP_DedLogic/GenericParser2.swift` (generated, `GetToken` keeps `= false`), and `Sources/JKAMP_DedLogic/win_main.swift` (the `Sys_UnpackDLL` signature from `lookup.py sig`).

## Row 3, the count of `Winding.p`

Question: the view gives `p` a count of 4, and Raven allocates windings past 4 points. What bounds the view?

Proof: `oracle/codemp/qcommon/cm_polylib.h:7` declares `vec3_t p[4]` with the comment "variable sized", and `:10` defines `MAX_POINTS_ON_WINDING`. `oracle/codemp/qcommon/cm_polylib.cpp:387` caps a clipped winding at that bound. `SLOT_BOUNDS` is at `tools/oracle-closure/rulings.py:240-247`, and `views.py` reads it in `slots_count`.

Verdict: ratified as proposed, delegated, 2026-11-04. `SLOT_BOUNDS` also bounds a fixed array field, and `numpoints` stays the real extent.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/views.py`, and `Sources/JKAMP_Ded/Generated/Views/Winding.swift` (`count: Int(MAX_POINTS_ON_WINDING)` under one `// AI:` line).

## Row 4, `cmd_text_buf`

Question: `byte cmd_text_buf[MAX_CMD_BUFFER]` at `oracle/codemp/qcommon/cmd_common.cpp:18` is the buffer that `cmd_text.data` points at, `:56`. What storage does it take?

Proof: the `gSharedBuffer` precedent at `tools/oracle-closure/rulings.py:274-277` and `Sources/JKAMP_Game/Generated/Storage/GameStorage.swift:683`. `BYTE_STORAGE_FIELDS` spells a char array field as the raw address of the field, and it gives no indexable form for a `byte *` field.

Verdict: ratified as proposed, delegated, 2026-11-04. `cmd_text_buf` joins `BYTE_STORAGE_VARS`, and `skeleton.py` accepts a `UCHAR` element. A `byte` buffer is a `Slots<JKAShared.byte>` over the zeroed allocation, so `cmd_text.data = cmd_text_buf` reads as Raven wrote it. `Cmd.data` takes the `FIELDS` kind `bytes`, a `Slots<JKAShared.byte>?` of the widest count over the pointer, by `Slots(scalars:)`, so a body indexes `cmd_text.data![i]`.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/skeleton.py`, `tools/oracle-closure/views.py`, `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, `Sources/JKAMP_Ded/Generated/Views/Cmd.swift`, and `Sources/JKAMP_DedLogic/cmd_common.swift`.

## Row 5, the `MSG_WriteData` overload

Question: Raven hands text and char buffers to `const void *data` at `oracle/codemp/qcommon/msg.cpp:330`, `:338`, `:352`, and `:358`. Where does the overload live?

Proof: `CharBuf` is `ExpressibleByStringLiteral` at `Sources/JKAShared/CharBuf.swift:26`, with a byte subscript at `:51`. Raven's loop is at `oracle/codemp/qcommon/msg.cpp:298-302`.

Verdict: ratified as proposed, delegated, 2026-11-04. One overload `MSG_WriteData(_ buf: Msg, _ data: CharBuf, _ length: Int32)` stands beside the stub, with a Port-note and a `// AI:` line. The byte reads as `Int32(data[i] as UInt8)`, because Raven reads `((byte *)data)[i]` unsigned and `MSG_WriteBits` counts a negative value as an overflow at `msg.cpp:147`.

Files: `Sources/JKAMP_DedLogic/msg.swift`, adopted in this commit.

## Row 6, the `node_t **` fields

Question: `node_t **head` of `node_t` at `oracle/codemp/qcommon/qcommon.h:1047-1053` and `node_t **freelist` of `huff_t` at `qcommon.h:1065` have no view form. What form do they take?

Proof: `Slots(pointers:count:)` at `Sources/JKAShared/Views/Slots.swift:79`, the form of `Huff.loc` at `Sources/JKAMP_Ded/Generated/Views/Huff.swift:95`. A shared slot stays shared at `oracle/codemp/qcommon/huffman.cpp:150`. The free list reuses a `node_t *` slot to hold a `node_t **` at `huffman.cpp:54` and `:60`.

Verdict: ratified as proposed, delegated, 2026-11-04. A `FIELDS` kind `slot` makes each field a `Slots<Node?>?` of count 1 over the slot address, so `*node->head` reads `node.head![0]`. The `RETURNS` kind `slot` gives `get_ppnode` the return `Slots<Node?>`, and the `PARAMS` kind `slot` gives `free_ppnode` the parameter `Slots<Node?>`. The accessor `slotAddress` in the view target reads and writes a slot as a slot address, under one `// AI:` line. The huffman round record names the same form as row R-B, a views accessor row, so the two agree.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/spelling.py`, `tools/oracle-closure/table.py`, `tools/oracle-closure/views.py`, `Sources/JKAMP_Ded/Generated/Views/Node.swift`, `Sources/JKAMP_Ded/Generated/Views/Huff.swift`, `Sources/JKAMP_Ded/NodeSlots.swift`, and `Sources/JKAMP_DedLogic/huffman.swift` (generated stubs only).

## Row 7, the `FS_ReadFile` buffer

Question: `void **buffer` of `FS_ReadFile` at `oracle/codemp/qcommon/files_pc.cpp:1259` is `inout OpaquePointer?`. What do the `char *` callers and the NULL callers pass?

Proof: the `trap_TrueMalloc` precedent at `Sources/JKAMP_Game/Generated/g_syscalls.swift:518` and the `trap_FS_Read` overload at `:137`. The `char *` callers are at `oracle/codemp/qcommon/cmd_common.cpp:231` and `oracle/codemp/qcommon/cm_shader.cpp:113`. The NULL callers are at `oracle/codemp/qcommon/files_common.cpp:502` and `oracle/codemp/server/sv_ccmds.cpp:159`. The `vec3_mut_opt` shape is at `tools/oracle-closure/spelling.py:314-318`.

Verdict: ratified as proposed, delegated, 2026-11-04. The `inout OpaquePointer?` form stays, and its body stays as on master. An overload with `inout CharBuf?` takes the NULL callers, where nil is Raven's NULL. A forward with `inout CharBuf` wraps the caller's buffer in the optional and writes the read back, the forward shape of `vec3_mut_opt`. Each overload carries a Port-note and a `// AI:` line.

Files: `Sources/JKAMP_DedLogic/files_pc.swift`, adopted in this commit.

## Row 8, the `seq` scratch of huffman.cpp

Question: `byte seq[65536]` is a local of `Huff_Decompress` and `Huff_Compress`, `oracle/codemp/qcommon/huffman.cpp:306` and `:360`. A body hands its base to `Huff_transmit` and to `Com_Memcpy`.

Proof: row R-A of `notes/2026-11-03/dedicated-round-huffman.md:58` on the branch `dedicated-round-huffman-2`, and the zeroed storage rule of `docs/transcription.md:447`. `add_bit` zeroes each byte before it writes, `huffman.cpp:33-35`, and the two functions never run at once, so one allocation serves both.

Verdict: ruled on the round, built here, 2026-11-04. `BYTE_STORAGE_LOCALS` names the local and its two functions, and `seq` is a zeroed `Slots<JKAShared.byte>` of 65536 on `EngineStorage`. The forward in `huffman.swift` carries one `// AI:` line. The huffman bodies were not touched.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/skeleton.py`, `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, and `Sources/JKAMP_DedLogic/huffman.swift` (generated).

## Row 9, the bg import of the host thunks

Question: `thunks()` wrote `import JKAMP_BG` for every unit, and `JKAMP_DedLogic` does not depend on `JKAMP_BG`.

Proof: the stub writer guards the import at `tools/oracle-closure/skeleton.py:1276`, and `thunks()` at `:1352` did not.

Verdict: found by the gate, fixed here, 2026-11-04. `thunks()` takes the same host guard.

Files: `tools/oracle-closure/skeleton.py` and `Sources/JKAMP_DedLogic/Generated/Callbacks.swift`.

## Row 10, the Source line of a host stem in draftcheck

Question: `SOURCE_LINE` at `tools/oracle-closure/draftcheck.py:58` accepted only `.c:`, so no hand function of a host stem matched and the splice replaced nothing.

Proof: every host stem cites `.cpp`. `align.py:32` imports the same pattern.

Verdict: found by the gate, fixed here, 2026-11-04. The pattern accepts `.c` and `.cpp`. `draftcheck.py --unit mp-engine-ded --stem cmd_common` now reports 17 of 17 hand functions replaced, 0 kept, 28 holes, 0 cascade errors, 0 defects, and 1 compile hole over 2 passes, exit 0.

Files: `tools/oracle-closure/draftcheck.py`.

## Row 11, the `unsigned char` parameter

Question: `MD4Update`, `MD4Final`, `MD4Transform`, `Encode`, and `Decode` of `oracle/codemp/qcommon/md4.cpp` had no table row for an `unsigned char` pointer or array.

Proof: a trap's `byte *` crosses as `Slots<byte>` at `tools/oracle-closure/spelling.py:444-449` of master. The game has no row for a `byte *` or a `byte[]` of a function that is not a trap.

Verdict: ruled by delegation, 2026-11-04. A host function's `byte *` or `byte[N]` takes the row of the trap, the caller's `Slots` over the bytes. The rule is for the host alone, because the array rule reached `NormalToLatLong` of `q_math.c` in the game snapshot. A game function with the shape keeps its marker.

Files: `tools/oracle-closure/spelling.py`, `Sources/JKAMP_DedLogic/md4.swift`, `Sources/JKAMP_DedLogic/cm_test.swift`, and `Sources/JKAMP_DedLogic/stringed_interface.swift` (generated stubs).

## Row 12, the width of UINT4

Question: `ded_types.h` copied `typedef unsigned long int UINT4` from `oracle/codemp/qcommon/md4.cpp:17`, which is 8 bytes on an lp64 host. MD4 needs 32-bit words.

Proof: the re-export spelled `UINT4` as `CUnsignedLong`, and the skeleton read the canonical `unsigned long` of the oracle parse.

Verdict: ruled by delegation, 2026-11-04. `ded_types.h` declares `typedef unsigned int UINT4` under one `// AI:` line, so the C record and the view use 4-byte words. `TYPES` maps `UINT4` to `UInt32` under the same `// AI:` line, and `spelling.py` reads that row behind a pointer or an array. The view fields are `Slots<UINT4>` with `UINT4 = UInt32`.

Files: `Sources/CJKAMP_Ded/include/ded_types.h`, `Sources/JKAMP_Ded/Generated/md4.swift`, `tools/oracle-closure/rulings.py`, `tools/oracle-closure/spelling.py`, and `Sources/JKAMP_DedLogic/md4.swift`.

## Row 13, the `handle` field of vmCvar_t

Question: the `VmCvar` view uses `handle` for its own slot pointer and gave no accessor for Raven's field. Raven writes it at `oracle/codemp/qcommon/cvar.cpp:896` and reads it at `:913` and `:917`.

Proof: `views.py` skipped a field named `handle` or `raw` with the comment "No module body reads it". No rename table existed.

Verdict: ruled by delegation, 2026-11-04. The table `FIELD_NAMES` gives `("vmCvar_t", "handle")` the accessor name `cvarHandle`, with one `// AI:` line on the accessor.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/views.py`, and `Sources/JKAMP/Generated/Views/VmCvar.swift`.

## Row 14, a view for `bitStorage_t`

Question: `bitStorage_t` is defined inside `oracle/codemp/qcommon/msg.cpp:1994`, so `g_netfBitStorage` and `g_psfBitStorage` at `:2002` and `:2003` had no table row.

Proof: a record Raven defines inside a `.cpp` file goes into the hand header `ded_types.h` with a Source line, as `cmd_t` and `MD4_CTX` do, and joins `HOST_ROOTS`.

Verdict: ruled by delegation, 2026-11-04. `bitStorage_t` joins `ded_types.h` and `HOST_ROOTS`, the view `BitStorage` comes out of the run, and the two pointers are `BitStorage?` variables.

Files: `Sources/CJKAMP_Ded/include/ded_types.h`, `tools/oracle-closure/rulings.py`, `Sources/JKAMP_Ded/Generated/Views/BitStorage.swift`, `Sources/JKAMP_Ded/Generated/Storage/EngineVariables.swift`, and `Sources/JKAMP_DedLogic/msg.swift`.

## The gate

- The game snapshot check differs in one file, `views/JKAMP/VmCvar.swift`, from row 13. The view is shared, so every unit writes it.
- The cgame snapshot check differs in the same file alone.
- The host snapshot check differs in 35 files and one new view, all at the sites of the rows above.
- `swift build` passed, and `swift test --no-parallel` passed 130 tests with no failure.
- The tool tests passed, 97 tests with 14 skipped.

The sequence also corrected three committed files of master that were stale against the generator: `Sources/JKAMP_Game/Generated/Storage/GameVariables.swift` (`JKAMP.Q3_INFINITE`), `Sources/JKAMP_Game/Generated/g_syscalls.swift` (`JKAMP.FailedEdge`), and ten game and cgame manifests with line numbers of adopted files. The host manifests under `.claude/manifest/mp-engine-ded/` stay untracked.

## Findings for a later row

- `MD4Transform` takes `UINT4 state[4]` as `[UInt32]` by value, but its body writes `state`, so the signature needs `inout`.
- `Encode` takes `UINT4 *input` and `Decode` takes `UINT4 *output` as one `inout UInt32`, but each body walks an array of words.
