# The third readoption of the host stem huffman

This record holds the third readoption of `Sources/JKAMP_DedLogic/huffman.swift` after PR 56, and the hole pass that closes rows R-A, R-B, and R-C of `notes/2026-11-03/dedicated-round-huffman.md`. The tree is the worktree `/tmp/jka-ded-huff-2` on the branch `dedicated-round-huffman-2`.

## The readoption

| Commit | Subject |
|---|---|
| 34e4736 | Merge master into the huffman round, the third readoption |
| 656d60d | The huffman.cpp holes of rows R-A, R-B, and R-C |

- The merge of master at c24e5e7 has one conflict file, `huffman.swift`, with two hunks. Each hunk is the stub of master against the stub of the branch, so the merge takes the signatures of master and keeps every hand body. The file stays adopted.
- Two signatures change. `get_ppnode` is `(_ huff: Huff) -> Slots<Node?>` in the place of the `TODO: Port signature` marker, and `free_ppnode` takes `_ ppnode: Slots<Node?>` in the place of `inout Node?`.
- The `seq` forward of row 8 comes from master at Raven's line 306.

## The holes

- R-B, 11 sites. `get_ppnode` returns the slot of `nodePtrs` at `blocPtrs`, or pops the free list through `slotAddress`. The slot over the table's base at that offset is the address of `&(huff->nodePtrs[huff->blocPtrs++])`, under the rule 11 comment of row B3. `free_ppnode` pushes the slot through `slotAddress`. The five holes of `increment` and the four of `Huff_addRef` read `*node->head` as `node.head![0]`.
- R-A, 3 sites. The two `[UInt8]` locals are gone, under one `// AI:` line in each body. `Huff_transmit` takes `seq.base`. The two `Com_Memcpy` calls take `OpaquePointer` over the raw `data` address plus `offset` and over `seq.base`, and the count is `CUnsignedLong`, the `size_t` of the stub, under a rule 11 comment.
- R-C, the parity test. `msg_hData` of `msg.cpp:2958` is Raven's 256 rows as written, by row H1 of `dedicated-huff-goldens.md`. The target `JKAMP_DedLogicTests` holds `HuffParityTests.swift` with three tests. The seed runs once per suite, because `Huff_offsetTransmit` never changes the tree.

No `portMissing` call stays in `huffman.swift`. The 25 holes of the round are all filled.

## The gate

| Check | Result |
|---|---|
| `swift build` | Build complete, 0 errors |
| `swift test --no-parallel` | 133 tests pass, 0 failures, the parity suite in 33 seconds |
| `draftcheck.py --unit mp-engine-ded --stem huffman` | exit 0, 5 of 18 hand functions replaced, 13 kept, 33 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 33 holes are holes of the drafter's output in the five replaced functions, not holes of the working tree. The draftcheck run names stale base facts in six files and stale adoption facts in `files_pc.swift` and `msg.swift`. The round ran no generator.

## Findings for a later row

- `Com_Memcpy` of `common.swift` is a stub, so `Huff_Compress` and `Huff_Decompress` stop in `portMissing` at run time until the common stem fills it.
- `JKAMP_DedLogicTests` is also the test target of the branch `dedicated-round-vm-interpreted`. The two `Package.swift` lines can conflict at the second landing.
