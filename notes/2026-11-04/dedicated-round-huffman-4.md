# The fourth hole pass of the host stem huffman

This record holds the hole pass of `Sources/JKAMP_DedLogic/huffman.swift` that uses rows 1 and 2 of `notes/2026-11-04/dedicated-open-rows-ledger-2.md`. The tree is the worktree `/tmp/jka-ded-huff-3` on the branch `dedicated-round-huffman-3`, off master at cb39f60. The code commit is 0433dff.

## The holes

The stem had 4 holes after `notes/2026-11-04/dedicated-round-huffman-3.md`. This pass fills 2, and 2 stay open.

- Filled, row 2. The new-slot branch of `get_ppnode`, Raven's `return &(huff->nodePtrs[huff->blocPtrs++]);`, reads `tppnode = huff.nodePtrs.slot(at: huff.blocPtrs)`, then `huff.blocPtrs += 1`, then `return tppnode`.
- Filled, row 1. The call in Huff_Compress, Raven's `Huff_transmit(&huff, ch, seq);`, reads `Huff_transmit(huff, ch, seq)`, because `fout` is a `Slots<JKAShared.byte>`.
- Open, row msg_t.data bytes field. The Com_Memcpy of Huff_Decompress, Raven's `Com_Memcpy(mbuf->data + offset, seq, cch);`.
- Open, row msg_t.data bytes field. The Com_Memcpy of Huff_Compress, Raven's `Com_Memcpy(mbuf->data+offset, seq, (bloc>>3));`.

The two open sites need `mbuf.data!.suffix(from: Int(offset))` for the Slots overload of Com_Memcpy. The `data` field of the Msg view is still an `OpaquePointer?`, so each site has no form without an Unsafe type. The Port-note of each site names the row.

The `buffer` locals of Huff_Compress and Huff_Decompress keep `UnsafeMutableRawPointer(mbuf.data!) + offset` from row B3. Every read of the message bytes in the two bodies goes through `buffer`, so a removal leaves no body. The same row msg_t.data bytes field replaces them.

## The parity suite

The seed of `HuffParitySuite` calls `Huff_Init` and `Huff_addRef`, and `Huff_addRef` reaches `get_ppnode`. The seed path crosses no hole now, so the `.disabled` trait is gone. The three tests over codes.txt, seq.txt, and chat.txt pass.

## The gate

| Check | Result |
|---|---|
| `swift build` | exit 0, Build complete |
| `swift test --no-parallel` | exit 0, 138 tests, 137 pass, 1 skipped: the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem huffman` | exit 0, 4 of 18 hand functions replaced, 14 kept, 33 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 33 holes are in the drafter's output for the four replaced functions, not in the working tree. The build gives two "will never be executed" warnings in huffman.swift, one after each open hole. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.
