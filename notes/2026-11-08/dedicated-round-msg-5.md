# The fifth hole round of msg

This record holds the fifth hole pass of the host stem `msg`, after the third batch of open rows in PR 70. The tree is the worktree `/tmp/jka-ded-msg-4` on the branch `dedicated-round-msg-4`, off master at `308a763`. The file `Sources/JKAMP_DedLogic/msg.swift` stays adopted, and no signature changed.

## What landed

| Commit | Subject |
|---|---|
| 185c40c | The fifth hole round of msg |

The round applies row 1 of `notes/2026-11-04/dedicated-open-rows-ledger-3.md`, `msg_t.data` as a byte slots field, to the 36 `Unsafe` lines that `notes/2026-11-04/dedicated-round-msg-4.md` lists, and to the interim `.base` edits of PR 70.

- MSG_WriteBits and MSG_ReadBits, the out-of-band branch, `msg.cpp:171` to `:180` and `:227` to `:236`: the byte store reads `msg.data![byte: msg.cursize] = value`, and the byte load reads `Int32(msg.data![byte: msg.readcount] as UInt8)`. The `unsigned short` and `unsigned int` words read `msg.data![ushort: ...]` and `msg.data![int: ...]`. One AI line in each function replaces the rule 11 line.
- MSG_WriteData and MSG_ReadData, `msg.cpp:301` and `:552`: Raven's `((byte *)data)[i]` reads `data[byte: i]` over the `Slots<JKAShared.byte>` parameter. One AI line in each function replaces the rule 11 line.
- MSG_WriteDeltaEntity, MSG_ReadDeltaEntity, MSG_WriteDeltaPlayerstate, and MSG_ReadDeltaPlayerstate: `fromF` and `toF` are `Slots<JKAShared.byte>`, and `(int *)((byte *)from + field->offset)` reads `Slots(record: from).bytes.suffix(from: field.offset)`. The reads `fromF[int: 0]`, `toF[int: 0]`, and `toF[float: 0]` keep their text, so the locals and the loops keep Raven's shape. This is the ledger form `Slots(record: from).bytes[int: field.offset]`, with the offset held in the local as Raven holds it in the pointer. One AI line in each function replaces the rule 11 line.

The rewrite changed 32 code lines: 6 `msg.data` sites, 2 `data` sites, 8 declarations, and 16 assignments of `fromF` and `toF`. It also changed 8 comment lines.

## The open row for the next batch

### Row: the byte pointer parameters of the Huffman bit functions

`Huff_putBit`, `Huff_getBit`, `Huff_offsetTransmit`, and `Huff_offsetReceive` take `UnsafeMutableRawPointer` for Raven's `byte *fout` and `byte *fin`, at `Sources/JKAMP_DedLogic/huffman.swift:17`, `:28`, `:307`, and `:370`. So four calls in `msg.swift` still hand `msg.data!.base`, the interim edit of PR 70:

| Swift line | Raven line | Function |
|---|---|---|
| `msg.swift:544` | `msg.cpp:193` | MSG_WriteBits, `Huff_putBit` |
| `msg.swift:553` | `msg.cpp:203` | MSG_WriteBits, `Huff_offsetTransmit` |
| `msg.swift:602` | `msg.cpp:248` | MSG_ReadBits, `Huff_getBit` |
| `msg.swift:610` | `msg.cpp:254` | MSG_ReadBits, `Huff_offsetReceive` |

The proposed form is the PARAMS kind `bytes` for these parameters, and the calls then hand `msg.data!`. The signatures come from the generator, so the row waits for a ruling batch.

## The counts

| Count | Value |
|---|---:|
| Functions of the stem | 48 |
| Functions left as holes | 0 |
| Lines with `Unsafe` in `msg.swift` | 0, from 36 |
| `.base` lines in `msg.swift` | 4, from 12 |
| `TODO: Port` markers in `msg.swift` | 1, the global `fp` |
| `Port-note:` lines | 2: the row 5 overload and 1 rule 19 note |
| `// AI:` lines | 9, from 1 |

## The gate

- `swift build`, exit 0: complete, with no warning in `msg.swift`.
- `swift test --no-parallel`, exit 0: 141 tests in 9 runs pass, and 1 test, the interpreter test, is skipped.
- `draftcheck.py --unit mp-engine-ded --stem msg`, run with the tool venv, exit 0: 18 of 48 hand functions replaced, 30 kept, 92 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass. The store of the fresh worktree held no base facts and no adoption facts, so the run swept them, and the run did not change a tracked file.
