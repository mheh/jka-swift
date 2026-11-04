# Dedicated round: md4 and net_chan, the third readoption

Branch `dedicated-round-md4-net-chan-2`. The branch merged master at `c24e5e7`, the open rows of the dedicated host of PR 56, in the merge commit `77e6809`. The ledger of the rows is `notes/2026-11-04/dedicated-open-rows-ledger.md`.

## Merge

One file had a conflict, `md4.swift`. The file kept its adoption, with no skeleton header, and took master's generated signature lines and stub text for the five conflicted functions. No other file had a conflict. The `net_chan.swift` signatures are equal to master's.

## Signatures

- `md4`, rows 11 and 12: `MD4Update(_ context: Md4Ctx, _ input: Slots<UInt8>, _ inputLen: UInt32)`, `MD4Final(_ digest: Slots<UInt8>, _ context: Md4Ctx)`, `MD4Transform(_ state: [UInt32], _ block: Slots<UInt8>)`, `Encode(_ output: Slots<UInt8>, _ input: inout UInt32, _ len: UInt32)`, and `Decode(_ output: inout UInt32, _ input: Slots<UInt8>, _ len: UInt32)`. `UINT4` is `UInt32`, so `Md4Ctx.state` and `Md4Ctx.count` are `Slots<UINT4>` of 4-byte words.
- `win_net`, row 1: `Sys_SendPacket(_ length: Int32, _ data: OpaquePointer?, _ to: Netadr)`.

## Holes filled

- `NET_SendPacket` calls `Sys_SendPacket(length, data, to)` as its last line, as Raven wrote at `oracle/codemp/qcommon/net_chan.cpp:549`.

## Holes open

1. `MD4Transform`: the generated signature takes `state` by value, and Raven writes `state`. The stub waits on the MD4Transform row of the next table batch.
2. `Encode`: the generated signature takes the UINT4 array `input` as one `inout UInt32`. The stub waits on the Encode row of the next table batch.
3. `Decode`: the generated signature takes the UINT4 array `output` as one `inout UInt32`. The stub waits on the Decode row of the next table batch.
4. `MD4Update` has the right signature, and its body calls `MD4Transform`. It waits on row 1 of this list.
5. `MD4Final` has the right signature, and its body calls `Encode`. It waits on row 2 of this list.
6. `Com_BlockChecksum` and `Com_BlockChecksumKey` call `MD4Update` and `MD4Final`, so they wait on rows 1 and 2. Their bodies also hand `buffer`, a `const void *`, to a `Slots<UInt8>` parameter, and hand the address of the local `int digest[4]`, and of `key`, as bytes. The guide has no form for these three, so the readoption names them for the same batch.

The hand bodies of all seven functions stay in commit `dee92fc`. The macros `F`, `G`, `H`, `ROTATE_LEFT`, `FF`, `GG`, and `HH` stay, with no caller until `MD4Transform` has a body.

## Gate

- `swift build`: exit 0, 0 errors.
- `swift test --no-parallel`: exit 0, 130 tests, 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem md4,net_chan`: exit 0. md4 has 0 of 15 hand functions replaced, 15 kept, 106 holes, 0 cascade errors, 0 defects, and 0 compile holes. net_chan has 1 of 15 hand functions replaced, 14 kept, 21 holes, 0 cascade errors, 0 defects, and 0 compile holes. The total is 127 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass. The run warned that the base facts and the adoption facts of the store are stale, because the round runs no generator.
