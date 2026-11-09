# The md4 round under the third batch storage

This record holds the round of `Sources/JKAMP_DedLogic/md4.swift` after PR 70. Row 2 of `notes/2026-11-04/dedicated-open-rows-ledger-3.md` gave the storage class the `x` and `bits` locals and made `PADDING` C storage that `DedTables.swift` reads as a `Slots<JKAShared.byte>`. The tree is the worktree `/tmp/jka-ded-md4-4` on the branch `dedicated-round-md4-4`, off master at 308a763.

## The bodies

| Commit | Subject |
|---|---|
| 901cb65 | The md4 transform and final bodies and the RFC 1320 test |

- `MD4Transform` is filled. It decodes the block into the `x` forward, runs Raven's 48 `FF`, `GG`, and `HH` steps with his step numbers as trailing comments, and adds the four words into `state` with `&+=` under the hash rule of `docs/transcription.md`. Raven's `Com_Memset` of `x` is `x.zero()`. The body takes no copy of `state`, because a `Slots` setter is nonmutating.
- `MD4Final` is filled. It encodes the count into the `bits` forward, pads with `PADDING`, and appends `bits`. Raven's `Com_Memset` of the context is `context.clear()`. The body has the drafter's form, except the index reads `context.count[0]` without `UInt32(bitPattern:)`, because `count` is already a `Slots<UInt32>`, the form of MD4Update.
- Each forward has one `// AI:` line at its declaration in the body.

The stem holds no `TODO: Port` marker, no Port-note, and no `Unsafe` type.

## The test

`Tests/JKAMP_DedLogicTests/MD4Tests.swift` holds the suite `MD4Suite`. The first test hashes the three RFC 1320 vectors, "", "abc", and "message digest", through MD4Init, MD4Update, and MD4Final and compares the digest bytes in hexadecimal. The second test compares `Com_BlockChecksum` of "abc" with the exclusive or of the four digest words. Raven's body at md4.cpp:276 reads the digest as four `int` words and computes `digest[0] ^ digest[1] ^ digest[2] ^ digest[3]`, so the test takes that value and not the first word alone. Both tests pass.

## The gate

| Check | Result |
|---|---|
| `swift build` | exit 0, 0 errors |
| `swift test --no-parallel` | exit 0, 143 tests, 142 pass, 1 skipped: the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem md4` | exit 0, 1 of 15 hand functions replaced, 14 kept, 97 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 97 holes are in the drafter's output for the replaced function, MD4Transform, not in the working tree. They are the 96 `FF`, `GG`, and `HH` macro lines and `&input[i]` of MD4Update, as the third batch ledger records. The round ran no generator.
