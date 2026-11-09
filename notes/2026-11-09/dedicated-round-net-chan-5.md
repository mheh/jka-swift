# Dedicated round: net_chan, the fifth round

Branch `dedicated-round-net-chan-5`, off master at `5e8cfb7`, in the worktree `/tmp/jka-ded-net-5`. The code commit is `0ef70c7`. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`. Rows 2 and 3 of `notes/2026-11-08/dedicated-open-rows-ledger-4.md` unblock the sites below.

## Sites filled

- `Netchan_TransmitNextFragment`: `MSG_InitOOB(send, send_buf_Netchan_TransmitNextFragment, Int32(send_buf_Netchan_TransmitNextFragment.count))`, as Raven wrote at `oracle/codemp/qcommon/net_chan.cpp:94`.
- `Netchan_TransmitNextFragment`: `NET_SendPacket(chan.sock, send.cursize, send.data!, chan.remoteAddress)`.
- `Netchan_Transmit`: `MSG_InitOOB(send, send_buf_Netchan_Transmit, Int32(send_buf_Netchan_Transmit.count))`.
- `Netchan_Transmit`: `NET_SendPacket(chan.sock, send.cursize, send.data!, chan.remoteAddress)`.
- `NET_SendLoopPacket`: `Com_Memcpy(loop.msgs[i].data, data, length)`, the Slots overload, as Raven wrote at `net_chan.cpp:524`.
- `NET_SendPacket`: `if showpackets!.integer != 0 && data[int: 0] == -1`, as Raven wrote at `net_chan.cpp:534`.
- `NET_OutOfBandData`: Raven's whole body. The header bytes and the copy loop write `string_NET_OutOfBandData`, `mbuf` is a `Msg.scratch` slot, `mbuf.data = string_NET_OutOfBandData` assigns the storage forward to the field, and the call hands `mbuf.data!` to NET_SendPacket.

`grep -c Unsafe Sources/JKAMP_DedLogic/net_chan.swift` gives 0. The stale Port-notes of the two rows are gone.

## Hole open

1. Row "CharBuf as send data". NET_OutOfBandPrint at `net_chan.cpp:575` hands `char string[MAX_MSGLEN]` to NET_SendPacket. The local is a `CharBuf`, and the `data` parameter of NET_SendPacket takes a `Slots<byte>`. No form hands a CharBuf to a `Slots<byte>` parameter, so the call stays a hole with a Port-note that names this row. The fourth round listed this call under the row "NET_SendPacket data as bytes", but row 3 of the fourth ledger changed only the parameter, not the CharBuf.

## Test

`Tests/JKAMP_DedLogicTests/LoopbackTests.swift` holds `LoopbackSuite`. The test builds a fresh `EngineWorld`, sends an 11-byte message from `NS_SERVER` to a loopback address with NET_SendLoopPacket, and reads it with NET_GetLoopPacket on `NS_CLIENT` into a 64-byte buffer. The test checks the return, the length, the address type, the same bytes, and an empty queue on the second read. The test passes.

## Gate

- `grep -c Unsafe` on `net_chan.swift`: 0.
- `swift build`: exit 0, 0 errors. The file gives only the warning on the local `qport` of `Netchan_Process` that master also gives.
- `swift test --no-parallel`: exit 0, 146 tests, 0 failures, 3 skipped. The skipped tests are the interpreter test and the two winding tests.
- `draftcheck.py --unit mp-engine-ded --stem net_chan`: exit 0. 1 of 15 hand functions replaced, 14 kept, 22 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass.
