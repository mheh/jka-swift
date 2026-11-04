# Dedicated round: md4 and net_chan, the readoption

Branch `dedicated-round-md4-net-chan-2`. The branch merged master at `5323708`, the table batch of PR 55. The two stems took the stub text of master, and the hand bodies of the first round stand under the generated signatures.

## Merge

Two files had conflicts, `md4.swift` and `net_chan.swift`. Each file took master's generated text, with the skeleton header removed, and the hand bodies went back under master's signatures. No other file had a conflict.

## Signatures

- `md4`: `MD4Init(_ context: Md4Ctx)` is the one new signature. The other five functions with a `TODO: Port signature` marker keep it, because the table has no row for Raven's `unsigned char` pointer and array parameters. `Com_BlockChecksum` and `Com_BlockChecksumKey` keep the signature of the first round.
- `net_chan`: the ten signatures of the batch replace the ten `-> Never` stubs. They are the same as the hand lines of the first round, with `Netadr` for a record passed by value (`spelling.py:496`).

## Bodies

- `md4`: `MD4Init` is ported over the `Md4Ctx` view. The final class `MD4_CTX` is gone, as ledger row 1 of the first round rules. The seven other functions keep their stubs with a Port-note, and their hand bodies stay in commit `dee92fc`. The macros `F`, `G`, `H`, `ROTATE_LEFT`, `FF`, `GG`, and `HH` stay, with no caller until `MD4Transform` has a signature.
- `net_chan`: the 13 hand bodies stand under master's signatures. The ledger rows of the first round apply: `LittleLong(x)` is `x` (row 4), a loop over the 10 bytes replaces `memcmp` with one `// AI:` line (row 7), and the byte reads and stores of a `void *` use the `RawField` subscripts, as the `msg` round does (row 8). `NET_OutOfBandPrint` takes the `strcpy(..., at: 4)` form of the guide for `vsprintf`.
- The second hole pass filled `NET_GetLoopPacket` and `NET_SendLoopPacket` over `loopbacks`, the `Slots<Loopback>` of the batch.

## Open rows

1. The md4 byte buffers: the table has no row for `const unsigned char *`, `unsigned char[16]`, `unsigned char[64]`, and `UINT4 *`. Five md4 stubs wait on it, and the two checksum functions wait on them.
2. The width of `UINT4`: `ded_types.h` copies Raven's `typedef unsigned long int UINT4`, so `Md4Ctx.state` and `Md4Ctx.count` are 8 bytes per element on an lp64 host and 4 bytes on Windows. MD4 needs 32-bit words. The hand bodies of `dee92fc` use `UInt32`. A ruling decides the element type before the md4 bodies readopt.
3. `Sys_SendPacket`: `win_net.swift` is adopted and keeps its `-> Never` stub. `lookup.py sig` gives `(_ length: Int32, _ data: OpaquePointer?, _ to: Netadr)`. The last line of `NET_SendPacket` is a hole until that file readopts.
4. `BigShort` at a port: master gives `BigShort` as `(Int16) -> Int16`, and the view gives `Netadr.port` as `Int32`. The three sites spell C's conversions, `Int32(BigShort(Int16(truncatingIfNeeded: a.port)))`, under a plain comment, by the narrow-type rule of `docs/transcription.md:537`.

## Gate

- `swift build`: 0 errors.
- `swift test --no-parallel`: 130 tests, 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem md4,net_chan`: md4 0 holes, net_chan 22 holes, 0 cascade errors, 0 compile holes. The one defect is outside the stems. The mirror build cannot resolve `JKAMP_BG` for `Sources/JKAMP_DedLogic/Generated/Callbacks.swift:4`, a file equal to master's, and the package build resolves it.
