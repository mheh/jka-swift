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

## Ledger of the open rows

1. `MD4_CTX`: ruled for the hand header. Raven defines it inside `md4.cpp`, and the guide copies a `.c` struct as Raven wrote it into a hand header the umbrella includes, the form of `g_types.h` and `cg_types.h` (`docs/transcription.md:83`, `docs/transcription.md:87`). It joins `HOST_ROOTS` as `"MD4_CTX": ("Md4Ctx", "CJKAMP_Ded")`. Change: the final class goes, the hand header and the table row go in the table batch, and the `md4` signatures come from the generator run.
2. `loopback_t` and `loopmsg_t`: ruled by the same rule as row 1. Both go into the hand header and join `HOST_ROOTS` as `"loopback_t": ("Loopback", "CJKAMP_Ded")` and `"loopmsg_t": ("Loopmsg", "CJKAMP_Ded")`. The file-scope `loopbacks[2]` is one zeroed allocation on `EngineStorage`, a `Slots<Loopback>` the stub forwards at Raven's line (`docs/transcription.md:447`). Change: the table rows, a generator run, then `NET_GetLoopPacket` and `NET_SendLoopPacket`.
3. `MSG_InitOOB` and `Sys_SendPacket`: ruled to the table. Their signatures come from the table in their own rounds (`docs/transcription.md:73`). Change: two rows in the table batch.
4. `LittleLong` and `BigShort`: ruled, by the M3 verdict of the `msg` round. The WinDed build defines `LittleLong` as an empty macro (`oracle/codemp/game/q_shared.h:174`), so the call is the value, and the site carries no comment. The same arm defines `BigShort` as a function, `short BigShort( short l) { return ShortSwap(l); }` (`oracle/codemp/game/q_shared.h:171`), so it is a real swap. Change: `LittleLong(x)` becomes `x` at its sites, and `BigShort` becomes a bare `(Int16) -> Int16` function in `JKAShared` over `ShortSwap`, with Raven's name and a `Source:` line, the home of the shared `q_shared` helpers beside `Format.swift`.
5. `UInt8` as a `FormatArg`: ruled. The varargs carry C's int promotion, and `Format.swift:27` already gives `Int32` its conformance. Change: one `extension UInt8: FormatArg` beside it, so the call keeps Raven's `a.ip[n]` with no cast.
6. `NET_StringToAdr` with a non-inout `Netadr`: ruled faithful. A view holds the pointer and its setters are `nonmutating`, so a by-value view writes through (`docs/porting-rules.md:12`). Change: none.
7. `memcmp` over two `Slots<byte>`: ruled. Each compare site becomes an element loop over Raven's byte count, 10 for `a.ipx` and `b.ipx`, with one `// AI: Raven compared with memcmp. The loop compares the same bytes.` line. Change: the loops at the two compare functions, with no new helper.
8. The raw offset sums on `Slots.base`: ruled. A logic target holds no pointer arithmetic, and a body indexes a `Slots` as `gWPArray[i]` does (`docs/porting-rules.md:28`, `docs/transcription.md:465`). Change: the bodies index `msg.data[...]` and the `send_buf` storage as `Slots<byte>`, and a trap that needs the base takes the `Slots`.
9. The `JKAShared.format` qualification: ruled. A module name clears a name clash the same way the signatures spell `JKAShared.vec3_t` (`docs/transcription.md:75`). The one-line comment stays, with no `// AI:` line, because the call is Raven's.
10. The 10 hand signatures of commit `f857901`: ruled to the table. A transcriptor keeps a stub signature as generated, and a signature change is its own commit from the table (`docs/transcription.md:73`, `docs/porting-rules.md:33`, `docs/porting-rules.md:35`). The cgame rounds took every new signature from a table row and a generator run. Change: the table batch carries rows for `netadr_t` and `netchan_t`, and the generator run replaces the hand lines. A body keeps its line where `lookup.py sig` gives the same text.
