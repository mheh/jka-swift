# The fifth hole pass of the host stem huffman

This record holds the hole pass of `Sources/JKAMP_DedLogic/huffman.swift` that uses row 1 of `notes/2026-11-04/dedicated-open-rows-ledger-3.md`. The tree is the worktree `/tmp/jka-ded-huff-4` on the branch `dedicated-round-huffman-4`, off master at 308a763. The code commit is bf95204.

## The holes

The stem had 2 holes after `notes/2026-11-04/dedicated-round-huffman-4.md`. This pass fills both, and no hole stays open.

- Filled, row 1. The Com_Memcpy of Huff_Decompress, Raven's `Com_Memcpy(mbuf->data + offset, seq, cch);`, reads `Com_Memcpy(mbuf.data!.suffix(from: offset), seq, cch)`.
- Filled, row 1. The Com_Memcpy of Huff_Compress, Raven's `Com_Memcpy(mbuf->data+offset, seq, (bloc>>3));`, reads `Com_Memcpy(mbuf.data!.suffix(from: offset), seq, (bloc >> 3))`.

The counts and the offsets are integer-generic, so neither site has a conversion. Neither site has an AI line, because each keeps Raven's form.

## The buffer locals

The `buffer` local of each body is `mbuf.data!.suffix(from: offset)`, a `Slots<JKAShared.byte>`, in place of `mbuf.data!.base + offset`. The rule 11 comment above each local is gone, because the local keeps Raven's form. The byte reads use the Slots subscript: `Int32(buffer[0]) * 256 + Int32(buffer[1])` in Huff_Decompress and `Int32(buffer[i])` in Huff_Compress.

Huff_Receive and get_bit keep the raw `fin` parameter of their stub signatures, so Huff_Decompress hands them `buffer.base`. Each of the two sites has one AI line in the form of the Huff_transmit sites.

## The Unsafe count

`grep -c Unsafe` on the file gives 8, not 0. All 8 are parameters of generated signatures: `fout` of Huff_putBit, add_bit, send, and Huff_offsetTransmit, and `fin` of Huff_getBit, get_bit, Huff_Receive, and Huff_offsetReceive. These parameters keep the PARAMS kind `raw` for the `msg->data` callers of msg.cpp. The two bodies of this pass hold no Unsafe type. A count of 0 needs a PARAMS row of kind `bytes` for these parameters and a generator run, and that row waits for a ruling.

## The parity suite

The three tests of `HuffParitySuite` over codes.txt, seq.txt, and chat.txt pass.

## The gate

| Check | Result |
|---|---|
| `swift build` | exit 0, Build complete |
| `swift test --no-parallel` | exit 0, 141 tests, 140 pass, 1 skipped: the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem huffman` | exit 0, 4 of 18 hand functions replaced, 14 kept, 33 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 33 holes are in the drafter's output for the four replaced functions, not in the working tree. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.
