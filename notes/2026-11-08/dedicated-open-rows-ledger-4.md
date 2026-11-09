# The open rows of the dedicated host, the fourth ledger

This record holds the fourth batch of open rows of the dedicated host. The user ruled rows 1 to 3 by delegation on 2026-11-08. The landing is the branch `dedicated-rulings-batch-4`, off master at `7dabbb5`, in the worktree `/tmp/jka-ded-rules-4`. The code commit is `baa5d07`. The generator sequence of `tools/oracle-closure/README.md` ran once over the whole batch: the extracts of the nine merge modules, merge, tables, check, the reexport of `JKAShared` and `JKAMP_Ded`, views, skeleton, and manifest for the three units, traps for the game and the cgame, and channel. The merge moved an SP UI header on this case-insensitive file system, and the landing kept master's `Sources/CJKASP_UI`. The round bodies stay as they were, except where a row says "and fill".

## Row 1, the Huffman bit functions

Question: Huff_putBit, add_bit, send, and Huff_offsetTransmit take `fout`, and Huff_getBit, get_bit, Huff_Receive, and Huff_offsetReceive take `fin`, as `UnsafeMutableRawPointer`, the PARAMS kind `raw`. So msg.swift hands `msg.data!.base` and huffman.swift hands `fout.base` and `buffer.base`. What form do the eight parameters take?

Sites: `oracle/codemp/qcommon/huffman.cpp:12`, `:22`, `:32`, `:41`, `:236`, `:252`, `:271`, and `:298`. The callers at `oracle/codemp/qcommon/msg.cpp:193`, `:203`, `:248`, and `:254`, which are `msg.swift:544`, `:553`, `:602`, and `:610`. The hand-offs of Huff_transmit at `huffman.cpp:291` and `:294` and of Huff_Decompress at `:340` and `:344`.

Verdict: ratified as proposed, delegated, 2026-11-08, and filled. The eight parameters take the PARAMS kind `bytes`, so each is `Slots<JKAShared.byte>`. The four msg.swift calls hand `msg.data!`, and huffman.swift hands `fout` and `buffer` as they stand. The four rule 24 lines at the old hand-offs are gone, because each site now keeps Raven's form. The bodies keep `fout[byte: (bloc >> 3)]` and `fin[byte: (bloc >> 3)]`, which the byte subscript of `Slots<byte>` reads with the same sign extension and truncation as the raw pointer form. `grep -c Unsafe` gives 0 on huffman.swift and 0 on msg.swift.

Files: `tools/oracle-closure/rulings.py`, `Sources/JKAMP_DedLogic/huffman.swift`, `Sources/JKAMP_DedLogic/msg.swift`, and `Tests/JKAMP_DedLogicTests/HuffParityTests.swift`. The parity suite builds a `Slots<JKAShared.byte>` over its buffer for Huff_offsetTransmit, and its three tests pass.

## Row 2, the byte buffers on the stack of net_chan

Question: `byte send_buf[MAX_PACKETLEN]` of Netchan_TransmitNextFragment and of Netchan_Transmit and `byte string[MAX_MSGLEN*2]` of NET_OutOfBandData have no storage home, so `MSG_InitOOB` and `mbuf.data = string` have no `Slots<byte>` to take.

Sites: `oracle/codemp/qcommon/net_chan.cpp:90`, `:147`, and `:586`.

Verdict: ratified as proposed, delegated, 2026-11-08. BYTE_STORAGE_LOCALS names each local with a key of the local and its function, so each function has its own allocation on EngineStorage with the function name as a suffix: `send_buf_Netchan_TransmitNextFragment` and `send_buf_Netchan_Transmit`, each a `Slots<JKAShared.byte>` of `MAX_PACKETLEN`, and `string_NET_OutOfBandData`, a `Slots<JKAShared.byte>` of 98304. The adopted net_chan.swift takes the three forwards of the skeleton's text at Raven's lines, each under its rule 24 line.

Deviation: the brief gave `MAX_MSGLEN` as the bound of `send_buf`. Raven declares `send_buf[MAX_PACKETLEN]` at both sites, and the generator reads that bound, 1400.

Files: `tools/oracle-closure/rulings.py`, `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, and `Sources/JKAMP_DedLogic/net_chan.swift`.

## Row 3, the send data as bytes

Question: `data` of NET_SendPacket, NET_SendLoopPacket, and Sys_SendPacket is `OpaquePointer?`, and `format` of NET_OutOfBandData has the PARAMS kind `opaque`. So the `*(int *)data == -1` test and the loopback copy have no form.

Sites: `oracle/codemp/qcommon/net_chan.cpp:514`, `:531`, and `:585`, and `oracle/codemp/win32/win_net.cpp:393`.

Verdict: ratified as proposed, delegated, 2026-11-08. The four parameters take the PARAMS kind `bytes`, so `*(int *)data == -1` can read `data[int: 0] == -1` and the loopback copy can be Com_Memcpy over two Slots. The adopted win_net.swift takes the new signature of Sys_SendPacket from `lookup.py sig` and keeps its marker body.

The rows reach four host signatures, each with a `Slots<JKAShared.byte>` parameter:

- `func NET_SendPacket(_ sock: netsrc_t, _ length: Int32, _ data: Slots<JKAShared.byte>, _ to: Netadr)`
- `func NET_SendLoopPacket(_ sock: netsrc_t, _ length: Int32, _ data: Slots<JKAShared.byte>, _ to: Netadr)`
- `func NET_OutOfBandData(_ sock: netsrc_t, _ adr: Netadr, _ format: Slots<JKAShared.byte>, _ len: Int32)`
- `func Sys_SendPacket(_ length: Int32, _ data: Slots<JKAShared.byte>, _ to: Netadr)`

No file outside net_chan.swift and win_net.swift calls the four functions.

The six net_chan holes stay open for the net_chan pass. Their Port-notes still name the old `OpaquePointer?` parameters and the missing storage, and the pass removes them with the holes.

Files: `tools/oracle-closure/rulings.py`, `Sources/JKAMP_DedLogic/net_chan.swift`, and `Sources/JKAMP_DedLogic/win_net.swift`.

## The gate

- The game snapshot check read 372 files and found no difference, exit 0.
- The cgame snapshot check read 246 files and found no difference, exit 0.
- The host snapshot check read 165 files and found 9 differing files, exit 1, all at the sites of the rows: the bodies, the manifests, and the skeleton text of huffman, net_chan, and win_net.
- `swift build` passed, exit 0. net_chan.swift gives the 6 "will never be executed" warnings of the open holes and the `qport` warning that master also gives.
- `swift test --no-parallel` passed 145 tests with 3 skipped, exit 0. The skipped tests are the interpreter test and the two winding tests. The three tests of `HuffParitySuite` pass.
- The tool tests passed 97 tests with 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over huffman, msg, net_chan, and win_net gave 221 holes, 3 cascade errors, 1 defect, and 8 compile holes over 3 passes, exit 1. Per stem: huffman 33 holes, msg 92, net_chan 22, all with 0 defects and 0 compile holes, and win_net 74 holes with the 3 cascade errors, the defect, and the 8 compile holes. The defect is at the draft of NET_ErrorString, `win_net.swift:136` of the mirror, a compile hole whose marker stands where an `Int32` is due. The host snapshot shows that draft unchanged from master, so the defect stands outside the rows. No round has gated win_net.

## Findings for a later row

- The drafter writes `fout[(bloc >> 3)] = 0` for the byte store of Huff_putBit and add_bit, the element subscript of `Slots<byte>`. The hand bodies keep the `[byte:]` subscript, because the `|=` of an `Int32` shift needs its generic setter.
- The draft of NET_OutOfBandData stores `mbuf.data = string` as a hole, "Swift holds the source as a Slots where the target takes one record". This is the `buf->data = data` finding of the third ledger.
