# The fourth hole round of msg

This record holds the fourth hole pass of the host stem `msg`, after the second batch of open rows in PR 64. The tree is the worktree `/tmp/jka-ded-msg-3` on the branch `dedicated-round-msg-3`, off master at `cb39f60`. The file `Sources/JKAMP_DedLogic/msg.swift` stays adopted, and no signature changed.

## What landed

| Commit | Subject |
|---|---|
| abce74c | The fourth hole round of msg |

- `FS_Read` in `MSG_CheckNETFPSFOverrides`, `oracle/codemp/qcommon/msg.cpp:2070`: the call reads `_ = FS_Read(&overrideFile, len, f)` through the `inout CharBuf` overload of row 7 in `Sources/JKAMP_DedLogic/files_pc.swift:327`. Raven drops the result, and `FS_Read` is not `@discardableResult`, so the call takes `_ =`, the form of `cvar.swift:254`. The Port-note and the `portMissing` call are gone, and the build warning "will never be executed" is gone with them.

## The checks of the batch

- Row 8, the `Z_Malloc` site at `msg.swift:1446`: `BitStorage(Z_Malloc(Int32(BitStorage.byteCount), TAG_GENERAL, true))` reads as Raven's `(bitStorage_t *)Z_Malloc(sizeof(bitStorage_t), TAG_GENERAL, qtrue)` at `msg.cpp:2085`. The size is the form of `docs/transcription.md:586`, and `TAG_GENERAL` passes with no cast into `memtag_t`, now `Int32`.
- Row 9, the default `isVehiclePS = false` of `MSG_WriteDeltaPlayerstate` at `msg.swift:1566` and `MSG_ReadDeltaPlayerstate` at `msg.swift:1782`: both match Raven's `qboolean isVehiclePS = qfalse` at `oracle/codemp/qcommon/qcommon.h:81` and `:83`. Both bodies read the parameter, at `msg.swift:1593` and `:1814`. No Swift caller exists yet, because `SV_WriteSnapshotToClient` in `sv_snapshot.swift:43` is still a hole. Raven's callers at `oracle/codemp/server/sv_snapshot.cpp:168` to `:201` use both the default and `qtrue`, so the default fits them.
- A finding for a later row: `MSG_ReadDeltaPlayerstate` takes a non-optional `from`, but Raven tests `!from` at `msg.cpp:2470`, and `oracle/codemp/client/cl_parse.cpp:278` passes NULL. The NULL sweep does not read the client files, so the dedicated unit sees no NULL caller. The dedicated server does not call this function, so the row waits for the client unit.

## The open row for the next batch

### Row: msg_t.data bytes field

The `data` field of the `Msg` view is `OpaquePointer?` at `Sources/JKAMP_Ded/Generated/Views/Msg.swift:83`, so each byte access of the body wraps it in `UnsafeMutableRawPointer`. The field offsets of the delta functions take the same form over `handle`. The sites stay as they are in this round. `msg.swift` holds 36 lines with an `Unsafe` form.

The `msg.data` sites, 10 lines:

| Swift line | Raven line | Function |
|---|---|---|
| `msg.swift:522` | `msg.cpp:171` | MSG_WriteBits, byte store |
| `msg.swift:526` | `msg.cpp:175` | MSG_WriteBits, `unsigned short` store |
| `msg.swift:530` | `msg.cpp:180` | MSG_WriteBits, `unsigned int` store |
| `msg.swift:544` | `msg.cpp:193` | MSG_WriteBits, `Huff_putBit` |
| `msg.swift:553` | `msg.cpp:203` | MSG_WriteBits, `Huff_offsetTransmit` |
| `msg.swift:582` | `msg.cpp:227` | MSG_ReadBits, byte load |
| `msg.swift:586` | `msg.cpp:231` | MSG_ReadBits, `unsigned short` load |
| `msg.swift:590` | `msg.cpp:236` | MSG_ReadBits, `unsigned int` load |
| `msg.swift:602` | `msg.cpp:248` | MSG_ReadBits, `Huff_getBit` |
| `msg.swift:610` | `msg.cpp:254` | MSG_ReadBits, `Huff_offsetReceive` |

The `void *data` parameter sites, 2 lines:

| Swift line | Raven line | Function |
|---|---|---|
| `msg.swift:642` | `msg.cpp:301` | MSG_WriteData, `((byte *)data)[i]` |
| `msg.swift:900` | `msg.cpp:552` | MSG_ReadData, `((byte *)data)[i]` |

The `int *fromF, *toF` sites, 24 lines:

| Swift lines | Raven lines | Function |
|---|---|---|
| `msg.swift:1160`, `:1161` | `msg.cpp:1076` | MSG_WriteDeltaEntity, the declarations |
| `msg.swift:1189`, `:1190` | `msg.cpp:1107`, `:1108` | MSG_WriteDeltaEntity |
| `msg.swift:1221`, `:1222` | `msg.cpp:1147`, `:1148` | MSG_WriteDeltaEntity |
| `msg.swift:1271`, `:1272` | `msg.cpp:1233` | MSG_ReadDeltaEntity, the declarations |
| `msg.swift:1323`, `:1324` | `msg.cpp:1287`, `:1288` | MSG_ReadDeltaEntity |
| `msg.swift:1369`, `:1370` | `msg.cpp:1364`, `:1365` | MSG_ReadDeltaEntity |
| `msg.swift:1579`, `:1580` | `msg.cpp:2225` | MSG_WriteDeltaPlayerstate, the declarations |
| `msg.swift:1613`, `:1614` | `msg.cpp:2269`, `:2270` | MSG_WriteDeltaPlayerstate |
| `msg.swift:1631`, `:1632` | `msg.cpp:2288`, `:2289` | MSG_WriteDeltaPlayerstate |
| `msg.swift:1792`, `:1793` | `msg.cpp:2463` | MSG_ReadDeltaPlayerstate, the declarations |
| `msg.swift:1834`, `:1835` | `msg.cpp:2523`, `:2524` | MSG_ReadDeltaPlayerstate |
| `msg.swift:1872`, `:1873` | `msg.cpp:2575`, `:2576` | MSG_ReadDeltaPlayerstate |

Other files of `Sources/JKAMP_DedLogic` also hold `Unsafe` lines: `huffman.swift` 10, `net_chan.swift` 9, `vm_interpreted.swift` 11, and `z_memman_pc.swift` 2. This round did not audit them.

## The counts

| Count | Value |
|---|---:|
| Functions of the stem | 48 |
| Bodies transcribed | 48 |
| Functions left as holes | 0 |
| `portMissing` calls in `msg.swift` | 0, from 1 |
| `TODO: Port` markers in `msg.swift` | 1, the global `fp` |
| `Port-note:` lines | 2: the row 5 overload and 1 rule 19 note |
| `// AI:` lines | 1, the row 5 overload |

## The gate

- `swift build`, exit 0: complete, with no warning in `msg.swift`.
- `swift test --no-parallel`, exit 0: 138 tests in 9 runs, all pass.
- `draftcheck.py --unit mp-engine-ded --stem msg`, run with the tool venv, exit 0: 18 of 48 hand functions replaced, 30 kept, 92 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass. The store of the fresh worktree held no base facts and no adoption facts, so the run swept them, and the run did not change a tracked file.
