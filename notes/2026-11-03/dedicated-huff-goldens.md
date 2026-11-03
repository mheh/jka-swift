# The huff goldens

Row E10 of `dedicated-opening-docket.md` is ratified.
Stage 1 copies the huff goldens into `JKATestSupport`, because the Huffman code is in qcommon.

## What is copied

The files sit in `Sources/JKATestSupport/Oracle/golden/huff/`.
They are a copy of `jka-rust/tools/huff-oracle/goldens/`, taken unchanged at jka-rust commit `b98932e5`, with the oracle submodule at `4bebb8ec`.
The dumper is `jka-rust/tools/huff-oracle/main.cpp`. It drives the unmodified `codemp/qcommon/huffman.cpp`.
The seed is the `msg_hData` table, the way `MSG_initHuffman` seeds it.

- `codes.txt` (6534 bytes, 256 lines): one line per symbol 0 to 255, in the form `%3d: <bits>  (<n> bits)`. The bits are the frozen prefix code of the compressor, LSB first. Source: `dump_codes`, `main.cpp:55`.
- `seq.txt` (612 bytes, 11 lines): the header `seq bloc=2308 bytes=289`, then the bitstream of the symbols 0 to 255 as hex, 32 bytes per line. Source: `dump_stream`, `main.cpp:72`.
- `chat.txt` (66 bytes, 2 lines): the header `chat bloc=162 bytes=21`, then the bitstream of the chat string that holds the byte `0xB0`, as hex. Source: `main.cpp:112`.

The Rust twin is `jka-rust/crates/mp/engine/qcommon/tests/huff_golden.rs`.
The README at `Sources/JKATestSupport/Oracle/README.md` records the commit and the source path.

## The test

`Tests/JKASharedTests/HuffGoldenFormatTests.swift` has 4 tests.
It checks the line counts, the field counts, the symbol order 0 to 255, the 0 and 1 digits, that each code length matches its `(n bits)` field, and that no code is a prefix of another.
For both streams it checks that `bytes` equals `(bloc + 7) >> 3`, the hex line widths, and that `bloc` equals the sum of the code lengths of the symbols in the stream.
It holds no Huffman code. The parity test comes with the port of `huffman.cpp`.

## Rows

- H1: the parity test needs the `msg_hData` table. The oracle table is in `msg.cpp`, and `extract_table.py` in the harness reads it. Proposed: the port of `msg.cpp` brings the table, and the parity test seeds from it.

## The ledger

- H1, ratified. The `msg_hData` table lands with the port of `msg.cpp`, in the form Raven's data tables take in the game and cgame, and the parity test over the goldens lands with the port of `huffman.cpp`.
