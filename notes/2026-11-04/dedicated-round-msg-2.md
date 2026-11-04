# The second hole round of msg

This record holds the readoption of the host stem `msg` after the table batch of PR 55, and the second hole pass. The tree is the worktree `/tmp/jka-ded-msg-2` on the branch `dedicated-round-msg-2`, with master at 5323708 merged in.

## The merge

`git merge master` merged with no conflict. Git applied master's stub changes to the adopted `msg.swift`: `msgHuff` is the `Huffman` view of `world.storage`, `g_nOverrideChecked` forwards to `world.variables`, and the four netField tables are C storage in `Sources/CJKAMP_Ded/ded_tables.c`, reached as `Slots<NetField>` from `Sources/JKAMP_Ded/DedTables.swift`.

## The signatures

Master's stub and the branch file have the same function lines after the merge. Two signatures changed from the generator's marker to a real signature: `MSG_Init` and `MSG_InitOOB`, now `(_ buf: Msg, _ data: OpaquePointer?, _ length: Int32)`. No other signature changed.

## What landed

| Commit | Subject |
|---|---|
| 801a6ea | Merge branch 'master' into dedicated-round-msg-2 |
| 4fb5956 | The second hole round of msg |

- `MSG_Init` and `MSG_InitOOB` have Raven's body. `Com_Memset(buf, 0, sizeof(*buf))` is `buf.clear()`, the form of `Huff_Init` in the huffman round.
- The Huffman arms of `MSG_WriteBits` and `MSG_ReadBits` call `Huff_putBit`, `Huff_offsetTransmit`, `Huff_getBit`, and `Huff_offsetReceive`, which are stubs on master. The mask `0xffffffff>>(32-bits)` is an unsigned shift, so the body writes `Int32(bitPattern: 0xffffffff >> (32 - bits))` under one comment.
- `MSG_initHuffman` has Raven's body under `#ifndef _USINGNEWHUFFTABLE_`. `(byte)i` is `Int32(UInt8(truncatingIfNeeded: i))`.
- The four netField walkers `MSG_WriteDeltaEntity`, `MSG_ReadDeltaEntity`, `MSG_WriteDeltaPlayerstate`, and `MSG_ReadDeltaPlayerstate`, and `MSG_ReportChangeVectors_f`, have Raven's body. Raven's `fromF` and `toF` are raw pointers over the record plus the field offset, under the rule 11 comment of row M1, and `*fromF` reads `fromF[int: 0]`. `FINAL_BUILD` is not defined, so `field->mCount++` and `gLastBitIndex = lc` stay. `_OPTIMIZED_VEHICLE_NETWORKING` is defined in `q_shared.h:2154`, so the pilot and vehicle arms stay.
- `MSG_WriteDeltaPlayerstate` opens `PlayerState.scratch` for Raven's `playerState_t dummy`, and the body is the closure. `MSG_ReadDeltaPlayerstate` takes a non-optional `from`, so its null guard and its dummy drop.
- Raven's `LOG(x)` macro of `msg.cpp:565` expands at its four sites, with one comment at the first site, because the stub has no function for it.

## The holes left open

- `MSG_WriteString` and `MSG_WriteBigString`: open row O1, a `char` buffer and the literal `""` into the `OpaquePointer?` of `MSG_WriteData`. The brief of this round states that the row has no ruling, so the ledger line in `notes/2026-11-03/dedicated-round-msg.md` does not apply. No overload exists, and this round adds none.
- `MSG_CheckNETFPSFOverrides`: the open row is `bitStorage_t` of `msg.cpp:1994`, which has no view, so `g_netfBitStorage` and `g_psfBitStorage` have no table row.

## The counts

| Count | Value |
|---|---:|
| Functions of the stem | 48 |
| Bodies transcribed | 45 |
| Functions left as holes | 3 |
| `portMissing` calls in `msg.swift` | 3, from 13 |
| `TODO: Port` markers in `msg.swift` | 6: 3 functions, 3 globals |
| `Port-note:` lines | 4: 3 holes and 1 rule 19 note |
| `// AI:` lines | 0 |

## The gate

- `swift build`: complete, no error.
- `swift test --no-parallel`: 130 tests in 8 runs, all pass.
- `draftcheck.py --unit mp-engine-ded --stem msg`: `msg` gives 0 cascade errors, 0 defects, and 0 compile holes, with 95 holes in the draft over 1 pass. One defect is outside the stem: `Callbacks.swift:4`, "unable to resolve module dependency: 'JKAMP_BG'", in the mirror build.
