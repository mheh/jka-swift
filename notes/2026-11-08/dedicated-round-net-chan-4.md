# Dedicated round: net_chan, the fourth round

Branch `dedicated-round-net-chan-4`, off master at `308a763`, in the worktree `/tmp/jka-ded-net-4`. The code commit is `2d76f5b`. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## Sites rewritten

- `Netchan_Transmit`: `Com_Memcpy(chan.unsentBuffer, data, length)`, the Slots overload, as Raven wrote at `oracle/codemp/qcommon/net_chan.cpp:163`.
- `Netchan_Process`: the fragment copy is `Com_Memcpy(chan.fragmentBuffer.suffix(from: chan.fragmentLength), msg.data!.suffix(from: msg.readcount), fragmentLength)` under one rule 24 line.
- `Netchan_Process`: the sequence write is `msg.data![int: 0] = sequence`, and the full copy is `Com_Memcpy(msg.data!.suffix(from: 4), chan.fragmentBuffer, chan.fragmentLength)`, each under one rule 24 line.
- `NET_GetLoopPacket`: `Com_Memcpy(net_message.data!, loop.msgs[i].data, loop.msgs[i].datalen)`, as Raven wrote at `net_chan.cpp:505`.
- `Netchan_TransmitNextFragment`: the `MSG_WriteData` fragment keeps `chan.unsentBuffer.suffix(from: chan.unsentFragmentStart)` under its rule 24 line.

`grep -c Unsafe Sources/JKAMP_DedLogic/net_chan.swift` gives 0. The file has no `.base`, no `Slots(scalars:)`, and no `OpaquePointer(...)` conversion.

## Holes open

1. Row "send_buf as byte storage". `byte send_buf[MAX_PACKETLEN]` of `Netchan_TransmitNextFragment` at `net_chan.cpp:90` and of `Netchan_Transmit` at `:147` is a function local. `BYTE_STORAGE_LOCALS` has no entry for it, and `EngineStorage` has no field for it, so `MSG_InitOOB` has no `Slots<byte>` to take. The `MSG_InitOOB` site of each function is a hole. `byte string[MAX_MSGLEN*2]` of `NET_OutOfBandData` at `:586` is the same shape, because `mbuf.data = string` needs a `Slots<byte>`.
2. Row "NET_SendPacket data as bytes". The generated `data` of `NET_SendPacket` and `NET_SendLoopPacket`, and `format` of `NET_OutOfBandData`, are `OpaquePointer?`. A body that holds a `Slots<byte>` has no form for that parameter, and a body that reads the parameter has no form either. The holes are the `NET_SendPacket` calls of `Netchan_TransmitNextFragment`, `Netchan_Transmit`, and `NET_OutOfBandPrint`, the `*(int *)data == -1` test of `NET_SendPacket` at `:534`, and the copy of `NET_SendLoopPacket` at `:524`. `Sys_SendPacket` of win_net takes the same `OpaquePointer?`, so the row covers it too.

`NET_OutOfBandData` holds both rows on every statement, so it is the generated marker body with two Port-notes. The hand body stays in master at `308a763`.

## Gate

- `grep -c Unsafe` on `net_chan.swift`: 0.
- `swift build`: exit 0, 0 errors. The file gives 6 "will never be executed" warnings, one after each open hole, and the warning on the local `qport` of `Netchan_Process` that master also gives.
- `swift test --no-parallel`: exit 0, 141 tests, 0 failures, 1 skipped.
- `draftcheck.py --unit mp-engine-ded --stem net_chan`: exit 0. 1 of 15 hand functions replaced, 14 kept, 22 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass. `align.py` reports `NET_OutOfBandData` as rewritten.
