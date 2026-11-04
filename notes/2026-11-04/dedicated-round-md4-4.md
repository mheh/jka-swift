# The md4 round under the second batch signatures

This record holds the round of `Sources/JKAMP_DedLogic/md4.swift` after PR 64, which gave the md4 functions the `Slots` signatures of rows 3 and 4 of `notes/2026-11-04/dedicated-open-rows-ledger-2.md`. The tree is the worktree `/tmp/jka-ded-md4-3` on the branch `dedicated-round-md4-3`, off master at cb39f60. The hand bodies of commit dee92fc stood over a hand `MD4_CTX` class and `[UInt8]` arrays, and the round writes the bodies again over the `Md4Ctx` view and the `Slots` parameters.

## The bodies

| Commit | Subject |
|---|---|
| df46bcb | The md4 bodies under the second batch signatures |

- `MD4Update`, `Encode`, `Decode`, `Com_BlockChecksum`, and `Com_BlockChecksumKey` are filled.
- `MD4Update` copies with the `Slots` overload of `Com_Memcpy` from row 1 of the second batch, and Raven's `&context->buffer[index]` and `&input[i]` are `suffix(from:)` of the same row. The count and state words wrap at 32 bits with `&+=`, under the hash rule of `docs/transcription.md`, because Raven's carry test reads the wrapped sum.
- `Encode` stores Raven's `(unsigned char)` cast as `UInt8(truncatingIfNeeded:)`, and `Decode` keeps Raven's `(UINT4)` casts.
- `Com_BlockChecksum` and `Com_BlockChecksumKey` open the context with `Md4Ctx.scratch`, and the closure's value is the function's. Each body reads `digest` from the storage class through the forward of row 4, under one `// AI:` line, and hands on `digest.bytes`. `Com_BlockChecksumKey` copies `key` into `key_Com_BlockChecksumKey` and hands on the bytes of the slot, under one `// AI:` line.
- The drafter's copies `var input = input` and `var output = output` drop, because a `Slots` setter is nonmutating and Raven never assigns the parameter.

## The holes

- `MD4Transform`, the next-batch row for `x`. Decode takes a `Slots<UInt32>`, and the local `UINT4 x[16]` has no storage home. A local `[UInt32]` cannot stand, because a `Slots` over it needs an `Unsafe` type in the logic target, which rule 11 forbids.
- `MD4Final`, two next-batch rows. The local `unsigned char bits[8]` has no storage home, and Encode and MD4Update take a `Slots<UInt8>`. `PADDING` is a hand `[UInt8]` on `EngineWorld`, and no `Slots` parameter takes it.

The Port-notes of the old signatures are gone, and each hole carries a new Port-note that names its row. The stem keeps 2 `TODO: Port` markers. The checksum bodies call `MD4Final`, so they trap at that stub until the two rows land.

## The gate

| Check | Result |
|---|---|
| `swift build` | exit 0, 0 errors, no warning in `md4.swift` |
| `swift test --no-parallel` | exit 0, 138 tests, 134 pass, 4 skipped: the 3 Huffman parity tests and the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem md4` | exit 0, 1 of 15 hand functions replaced, 14 kept, 107 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 107 holes are in the drafter's output for the replaced function, not in the working tree. The round ran no generator.

No checksum fixture exists in `Tests/` or in `oracle/`. The one MD4 parity test is `jka-rust/crates/mp/engine/core/tests/md4_parity.rs`, a Rust test that this round does not run.

## Findings for a later row

- The `Slots` overload of `Com_Memcpy` takes an `Int32` count, and Raven's `partLen` and `inputLen - i` are `unsigned int`, so the two sites carry `Int32(...)`. `suffix(from:)` takes an `Int`, so the three sites carry `Int(...)`, the form of row 1.
- The drafter declares `digest` and `bits` as local arrays, keeps the `(unsigned char *)` casts as holes, and writes `Com_Memset` over the context with an `Unsafe` type where the guide gives `context.clear()`.
