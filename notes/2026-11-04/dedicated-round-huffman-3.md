# The third readoption of the host stem huffman

This record holds the third readoption of `Sources/JKAMP_DedLogic/huffman.swift` after PR 56, and the hole pass that closes rows R-A, R-B, and R-C of `notes/2026-11-03/dedicated-round-huffman.md`. The tree is the worktree `/tmp/jka-ded-huff-2` on the branch `dedicated-round-huffman-2`.

## The readoption

| Commit | Subject |
|---|---|
| 34e4736 | Merge master into the huffman round, the third readoption |
| 656d60d | The huffman.cpp holes of rows R-A, R-B, and R-C |
| 23d790c | Merge master into the huffman round, the fourth readoption |
| a51cc13 | The rule 11 sites of huffman.cpp back to holes |

- The merge of master at c24e5e7 has one conflict file, `huffman.swift`, with two hunks. Each hunk is the stub of master against the stub of the branch, so the merge takes the signatures of master and keeps every hand body. The file stays adopted.
- Two signatures change. `get_ppnode` is `(_ huff: Huff) -> Slots<Node?>` in the place of the `TODO: Port signature` marker, and `free_ppnode` takes `_ ppnode: Slots<Node?>` in the place of `inout Node?`.
- The `seq` forward of row 8 comes from master at Raven's line 306.
- The second merge, of master at 26807f0, has two conflict files. The msg round fills `msg_hData` with the same 256 rows, so `msg.swift` takes the file of master. `Package.swift` keeps one `JKAMP_DedLogicTests` target for the interpreter tests and the parity tests.

## The holes

- R-B, 11 sites, 10 filled. The free list branch of `get_ppnode` pops through `slotAddress`, and `free_ppnode` pushes through `slotAddress`. The five holes of `increment` and the four of `Huff_addRef` read `*node->head` as `node.head![0]`. The new-slot branch of `get_ppnode`, `&(huff->nodePtrs[huff->blocPtrs++])`, stays a hole on the open row of the address of one element of a Slots as a slot, because the form needs raw arithmetic under rule 11.
- R-A, 3 sites, 0 filled. The two `[UInt8]` locals are gone, under one `// AI:` line in each body, and the bodies index the `seq` storage of row 8. The `Huff_transmit` call takes a raw `fout`, and the two `Com_Memcpy` calls take `OpaquePointer?`. The three sites stay holes on the open row Com_Memcpy into byte slots, the row of the cmd_common round.
- R-C, the parity test. `msg_hData` comes from master. `HuffParityTests.swift` in `JKAMP_DedLogicTests` holds three tests over codes.txt, seq.txt, and chat.txt. The three tests passed against the filled `get_ppnode` of 656d60d. The seed reaches the `get_ppnode` hole, so the suite is disabled on the same row.

The stem keeps 4 holes. 21 of the 25 holes of the round are filled.

## The gate

| Check | Result |
|---|---|
| `swift build` | Build complete, 0 errors |
| `swift test --no-parallel` | exit 0, 134 tests pass, 4 skipped: the 3 parity tests and the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem huffman` | exit 0, 5 of 18 hand functions replaced, 13 kept, 33 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 33 holes are in the drafter's output for the five replaced functions, not in the working tree. The draftcheck run reports stale adoption facts in six files of the landed rounds. The round ran no generator.

## Findings for a later row

- The `buffer` locals of `Huff_Compress` and `Huff_Decompress` keep `UnsafeMutableRawPointer(mbuf.data!) + offset` from row B3 of the first round. That form also has an Unsafe type and raw arithmetic in the logic target.
- The generated huffman.cpp signatures take `UnsafeMutableRawPointer` for each `byte *` buffer, the `raw` kind of row T2.
