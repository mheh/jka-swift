# The first hole round of the host stem huffman

This record holds the first hole round of `oracle/codemp/qcommon/huffman.cpp` in `Sources/JKAMP_DedLogic/huffman.swift`. The tree is the worktree `/tmp/jka-ded-huff` on the branch `dedicated-round-huffman`, off `dedicated-stage-3-landing` at c167af7.

## What landed

| Commit | Subject |
|---|---|
| 9fc6887 | The huffman_t root and the huffman.cpp parameter rows |
| fc04f8c | The huffman.cpp bodies, the first hole round |

- `tools/oracle-closure/rulings.py`: `HOST_ROOTS` gains `huffman_t`, so `huffman_t`, `huff_t`, and `node_t` get the views `Huffman`, `Huff`, and `Node` in `JKAMP_Ded`. `PARAMS` gives the nine `byte *` bit buffers of huffman.cpp the kind `raw`. `NULLABLE` gives `node` of `increment` an optional.
- The host runs of `views.py` and `skeleton.py` wrote the three views, the `msgHuff` record on `EngineStorage`, the `msgHuff` forward in `msg.swift`, and the new huffman.swift signatures. The host run of `views.py` also rewrote `Sources/JKAMP/Generated/Views/Callbacks.swift`, and the commit keeps the branch's file, as the stage 3 landing did.
- `huffman.swift` is adopted. The bodies start from the drafter's output of `bodies.py --unit mp-engine-ded --stem huffman`, and the round fills the holes that the codebase gives a form for.

## The counts

| Count | Value |
|---|---:|
| Functions of the stem | 18 |
| Whole bodies | 12 |
| Bodies with holes | 4 |
| Stubs that stay | 2 |
| `portMissing` calls | 14 |
| `Port-note:` lines | 14 |
| `TODO: Port` lines | 3 |
| Holes of the drafter's output | 25 |
| Errors of `swift build` | 12, all in `Sources/CJKAMP_Ded/CJKAMP_Ded.c` |

The whole bodies are `Huff_putBit`, `Huff_getBit`, `add_bit`, `get_bit`, `swap`, `swaplist`, `Huff_Receive`, `Huff_offsetReceive`, `send`, `Huff_transmit`, `Huff_offsetTransmit`, and `Huff_Init`.
The bodies with holes are `increment` with 5 holes, `Huff_addRef` with 4, `Huff_Decompress` with 1, and `Huff_Compress` with 2.
The stubs are `get_ppnode` and `free_ppnode`.

`swift build` stops in the C target with the 12 errors of the stage 3 record: 11 times "redefinition of enumerator" at `enum_TK_EOF.h:11-21` and 1 "expected identifier" at `sysEventType_t.h:11`. No Swift file compiled, so the round has no Swift error count, no test count, and no snapshot gate. The round stops there, as the brief gives it.

## Open rows

- R-A, the `byte seq[65536]` local of `Huff_Compress` and `Huff_Decompress`. Raven hands it to the `byte *fout` of `Huff_transmit`, huffman.cpp:387, and copies it into `mbuf->data` with `Com_Memcpy`, huffman.cpp:353 and :394. The drafter gives the local the `[UInt8]` form of `g_svcmds.swift:31`, and a `[UInt8]` has no raw pointer in a logic target without a `withUnsafe` call, which rule 11 bans. No game or cgame body hands a local byte array to a `raw` parameter. The choices are a byte scratch in the view target in the shape of a view's `scratch(count:)`, which is a new helper, or a `withUnsafeMutableBytes` closure in the logic body, which breaks rule 11. Three holes wait on this row.
- R-B, the `node_t **` slots of `huff_t`. `head` of `node_t` and `freelist` of `huff_t` point at a slot of `nodePtrs`, and the free list links through those slots, huffman.cpp:48-62. The generated fields are `OpaquePointer?`, and a logic body has no read or write through them. The table gives `free_ppnode` the parameter `inout Node?`, which has no slot address, and gives `get_ppnode` no return row. The choices are a pointer-slot accessor in the view target, the `[pointer:]` subscript of `RawField.swift` over the slot, which brings raw pointer code into the logic body, or an index into `nodePtrs` in Swift state, which changes the shape of a private type under rule 12. Nine holes and the two stubs wait on this row.
- R-C, the parity test over the huff goldens. The goldens come from a tree that `Huff_addRef` seeds from `msg_hData`, `main.cpp:29` of the dumper. `Huff_addRef` waits on R-B, the table waits on the port of msg.cpp under row H1 of `dedicated-huff-goldens.md`, and no test target depends on `JKAMP_DedLogic`. The round does not wire the test. The proposal is a `JKAMP_DedTests` target with the parity test in the commit that closes R-B and lands the table.

## The ledger

The rows below follow a pattern that the codebase already holds, so the round ruled them under the standing delegation.

- T1, the `huffman_t` host root: ratified. The rule of "The stub's signature" of `docs/transcription.md` gives a view to a struct a header declares that no root reaches. `huffman_t` reaches `huff_t` and `node_t`.
- T2, `byte *` as `raw`: ratified. `byte *ent` of `BG_ParseField` is the `raw` row of `PARAMS`, and the bodies index the buffer with the `[byte:]` subscript of `RawField.swift`.
- T3, `node` of `increment` as optional: ratified. Huff_addRef passes `tnode2->parent` at huffman.cpp:229, which is NULL at the root, and the body tests it at huffman.cpp:131. This is the form of the other `NULLABLE` rows.
- T4, `Callbacks.swift`: kept as the branch holds it, by the stage 3 record. Row 3 of that record changes the tool on the landing branch.
- B1, the `byte` read of the message: `Int32(buffer[byte: i] as UInt8)`. Raven's `byte` is unsigned and C widens it at the read. The `[byte:]` subscript sign-extends by default, so the `UInt8` type picks the unsigned read, and `Int32(...)` is the widening of a narrow read, the form of `Int32(m[i])` at `g_svcmds.swift:130`. The bit reads of `get_bit` and `Huff_getBit` keep the default, because a sign extension does not change bits 0 to 7 under a shift of 7 or less.
- B2, `Com_Memset` over a whole `huff_t`: the memset rule of "The stub's signature". The zero fill over a field record of `Huff_Init` is `clear()`. The zero fill over the scratch record of `Huff_Compress` and `Huff_Decompress` drops, because the scratch slot is zero at entry and no loop encloses the call.
- B3, the `buffer` local: `UnsafeMutableRawPointer(mbuf.data!) + offset`, under the rule 11 comment of `bg_vehicleLoad.swift:64`. The raw pointer from an `OpaquePointer?` field has the form of `cg_main.swift:4013`. The drafter left this site as a rule 11 hole.
- B4, the post-increments of `&(huff->nodeList[huff->blocNode++])`: the statement with the old value, then `blocNode += 1`, by the post-increment rule of "The C character buffer".
- B5, two drafter findings. The drafter adds `var fout = fout` to `Huff_putBit` and `add_bit`, which Raven never assigns, so the round drops the copy. The drafter types the copy of `node` in `Huff_Receive` and `Huff_offsetReceive` non-optional and drops Raven's NULL test and its `return`, so the round keeps `var node: Node? = node` and Raven's test.
