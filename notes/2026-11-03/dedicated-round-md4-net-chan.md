# Dedicated round: md4 and net_chan

Branch `dedicated-round-md4-net-chan`, cut from `dedicated-stage-3-landing`. This was the first hole round on two small dedicated host stems.

## What landed

- `md4`: all 8 functions of the stub have bodies (`MD4Init`, `MD4Update`, `MD4Final`, `MD4Transform`, `Encode`, `Decode`, `Com_BlockChecksum`, `Com_BlockChecksumKey`). 0 holes.
- `md4` also gained the Raven macros `F`, `G`, `H`, `ROTATE_LEFT`, `FF`, `GG`, and `HH` as private hand functions with a `Source:` cite each, and the `MD4_CTX` type (see open row 1).
- `EngineWorld` gained the two hand properties the stubs already named: `PADDING` and `netsrcString`.
- `net_chan`: 15 functions in the stub. 13 have bodies. 2 stay holes (`NET_GetLoopPacket`, `NET_SendLoopPacket`), each with a Port-note and its `portMissing` call (open row 2).
- Both stubs were adopted: the skeleton header left in the commit of the first hand edit of each file.
- The 10 `net_chan` stubs that carried `TODO: Port signature` got a signature. The change is its own commit, ahead of the bodies.

## Commits

1. `The md4 bodies`
2. `The net_chan signatures`
3. `The net_chan bodies`

## Build

`swift build` fails with only the 12 errors in `Sources/CJKAMP_Ded/CJKAMP_Ded.c` (`sysEventType_t.h` and the redefined `TK_*` enumerators), which another agent fixes. No Swift file was compiled, so the bodies are checked by `swiftc -parse` only. `swift test --no-parallel` did not run.

## Signature ledger

| Function | Signature |
|---|---|
| `Netchan_Setup` | `(sock: netsrc_t, chan: Netchan, adr: Netadr, qport: Int32)` |
| `Netchan_Transmit` | `(chan: Netchan, length: Int32, data: OpaquePointer?)` |
| `NET_CompareBaseAdr`, `NET_CompareAdr` | `(a: Netadr, b: Netadr) -> Bool` |
| `NET_AdrToString` | `(a: Netadr) -> String` |
| `NET_IsLocalAddress` | `(adr: Netadr) -> Bool` |
| `NET_SendLoopPacket`, `NET_SendPacket` | `(sock, length: Int32, data: OpaquePointer?, to: Netadr)` |
| `NET_OutOfBandPrint` | `(sock, adr: Netadr, format: String, args: any FormatArg...)` |
| `NET_OutOfBandData` | `(sock, adr: Netadr, format: OpaquePointer?, len: Int32)` |

These follow the existing rows: a struct by value is its view, a `const void *` or `byte *` is `OpaquePointer?`, and a variadic is `any FormatArg...`. The `md4` stubs with `TODO: Port signature` took `MD4_CTX` (a class), `[UInt8]` for input bytes, `inout [UInt8]` for the digest, `UInt32` for `UINT4` and `unsigned int`.

## AI-comment sites

- `md4`: the buffer copies in `MD4Update` (2 sites), the byte copy and the key bytes in `Com_BlockChecksum` and `Com_BlockChecksumKey`, and the digest word load (2 sites).
- `net_chan`: the buffer-plus-offset sums in `Netchan_TransmitNextFragment` and `Netchan_Process`, and the formatted text in `NET_OutOfBandPrint`.

## Open rows for the user

1. `MD4_CTX` has no table row, no view, and no hand header. It is a struct Raven defines in the header text of `md4.cpp`. The round declared it as a final Swift class with Raven's three fields, because no C view is possible without a hand header in `CJKAMP_Ded`. A hand header plus `ROOTS` entry is the alternative the transcription guide names for a struct defined in a `.c` file.
2. `loopback_t` and `loopmsg_t` (net_chan.cpp:474-486) have no view and no Swift home, so `NET_GetLoopPacket` and `NET_SendLoopPacket` stay holes. The same hand-header question as row 1 decides them.
3. `MSG_InitOOB` and `Sys_SendPacket` are still `-> Never` stubs with no signature. The bodies call them in Raven's argument order: `MSG_InitOOB(Msg, OpaquePointer?, Int32)` and `Sys_SendPacket(Int32, OpaquePointer?, Netadr)`. The parallel agents must match these.
4. `LittleLong` and `BigShort` have no Swift definition in any target. `Netchan_Process` and `NET_AdrToString` call them by Raven's name, with `BigShort` taking the `Int32` port and `NET_StringToAdr` passing `Int16`. A row must give their parameter type.
5. `NET_AdrToString` passes `a.ip[n]` (a `UInt8`) to `Com_sprintf`, and `UInt8` is not a `FormatArg`. A row must give either a `FormatArg` conformance for `byte` or Raven's int promotion at the call.
6. `NET_StringToAdr` takes `a: Netadr` as a non-inout view, and the signature came from the stub as generated. It also calls `Sys_StringToAdr(String(base), a)`. Both are unproven until the build runs.
7. `memcmp(a.ipx, b.ipx, 10)` in the two compare functions assumes a `memcmp` over two `Slots<byte>`. No such overload was found.
8. `Netchan_TransmitNextFragment` and `Netchan_Transmit` use `Msg.scratch` and a raw allocation for `send_buf`, and `Netchan_Process` reads the fragment through `msg.data`. The raw-pointer sums use `Int(...)` or an `Int32` sum on `Slots.base`, which no existing row names.
9. `NET_OutOfBandPrint` names the module (`JKAShared.format`) to clear the clash with its own `format` parameter, under a one-line comment.
