# The second hole pass of the host stem huffman

This record holds the readoption of `Sources/JKAMP_DedLogic/huffman.swift` after the table batch of PR 55, and the second hole pass of the stem. The tree is the worktree `/tmp/jka-ded-huff-2` on the branch `dedicated-round-huffman-2`. The merge of master at 5323708 is ebefdb4.

## The readoption

- The merge has one conflict file, `huffman.swift`. Every hunk is a hand body of the branch against the stub text of master. The branch keeps each hand body.
- The signature lines, the Source lines, and the `TODO: Port signature` marker of `get_ppnode` are byte-equal on both sides. No body readopts to a new signature.
- The file stays adopted with no skeleton header.

## The second hole pass

No hole fills in this pass. No stub gets a new signature from master, and the rows that the holes wait on are ruled but not built on master.

- R-A, the `seq[65536]` byte scratch of `Huff_Compress` and `Huff_Decompress`. The ruling gives a zeroed `Slots<UInt8>` field of 65536 on `EngineStorage`. Master has no such field, so the three holes stay.
- R-B, the `node_t **` slots of `huff_t`, huffman.cpp:48-62. The ruling gives a `views.py` accessor row. Master's `Node.head` and `Huff.freelist` stay `OpaquePointer?`, and `get_ppnode` keeps the `TODO: Port signature` marker. The nine holes of `increment` and `Huff_addRef` and the two stubs `get_ppnode` and `free_ppnode` stay.
- R-C, the parity test, waits on R-B.

## The gate

| Check | Result |
|---|---|
| `swift build` | Build complete, 0 errors |
| `swift test --no-parallel` | 130 tests pass, 0 failures |
| `draftcheck.py --unit mp-engine-ded --stem huffman` | 25 holes, 0 cascade errors, 0 defects, 0 compile holes, 1 pass |
| `draftcheck.py`, other files | 1 defect |

The defect outside the stem is in the mirror only. `.build-draft/tree/Sources/JKAMP_DedLogic/Generated/Callbacks.swift:4` imports `JKAMP_BG`, and the host logic target has no dependency on that module. No file of the working tree has this line.
