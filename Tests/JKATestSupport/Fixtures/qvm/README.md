# The QVM test image

`vmtest.qvm` is a small QVM image for the test of the interpreter port (`oracle/codemp/qcommon/vm_interpreted.cpp`).
Raven ships no `.qvm` file and no golden exists, so `assemble.py` writes the image and derives every expected value.

## Run

`python3 -I Tests/JKATestSupport/Fixtures/qvm/assemble.py`

The script writes `vmtest.qvm` and `vmtest.map` beside itself, reads the header back and checks each field, runs the image with each test command, and prints the table below.
It uses only the Python standard library.

## Header

The header is `vmHeader_t` of `oracle/codemp/qcommon/qfiles.h`, eight little-endian 32-bit words.

| Field | Value |
| --- | --- |
| `vmMagic` | `0x12721444` (`VM_MAGIC`) |
| `instructionCount` | 197 |
| `codeOffset` | 32 |
| `codeLength` | 622 |
| `dataOffset` | 654 |
| `dataLength` | 4 |
| `litLength` | 4 |
| `bssLength` | 131064 |

The file is 662 bytes: the 32-byte header, 622 bytes of code, one 4-byte data word (7), and the 4 lit bytes `JKA` and NUL.
The data, lit, and bss lengths add up to `0x20000`, so the data mask is `0x1ffff` and the program stack starts at `0x20000`, as `VM_Create` sets it.

## Code

An opcode is one byte, the `opcode_t` number of `vm_local.h`.
`ENTER`, `CONST`, `LOCAL`, `LEAVE`, and the compare-and-branch opcodes carry a 4-byte operand, and `ARG` carries a 1-byte operand.
A branch operand and a `CONST` used by `JUMP` or `CALL` is an instruction number, not a byte offset.
`vmMain` is instruction 0 and the second function `helper` is instruction 187.

`vmMain(command, a, b, c)` has a 32-byte frame, and its arguments are at `LOCAL 40`, `44`, `48`, and `52`.
`helper(a, b)` returns `a * a + b`.

The 23 opcodes in the image: `ADD`, `ARG`, `BAND`, `CALL`, `CONST`, `DIVI`, `ENTER`, `EQ`, `GEI`, `GTI`, `JUMP`, `LEAVE`, `LOAD1`, `LOAD4`, `LOCAL`, `LTI`, `MULI`, `NE`, `NEGI`, `POP`, `SEX8`, `STORE4`, `SUB`.

## Symbols

`vmtest.map` has the format `VM_LoadSymbols` reads: a segment, an instruction number in hex, and a name.
The code segment is 0, and `VM_LoadSymbols` skips the lines of the other segments.

| Segment | Value | Name |
| --- | --- | --- |
| 0 | `00000000` | `vmMain` |
| 0 | `000000bb` | `helper` |
| 1 | `00000000` | `g_word` |
| 2 | `00000004` | `g_lit` |

## Syscalls

A syscall is a `CALL` to a negative address, and the call number is `-1 - address`.
The test harness answers them as follows.

| Number | Address | Parameters | Result |
| --- | --- | --- | --- |
| 1 | `-2` | `p1` | `p1 * 10` |
| 2 | `-3` | `p1`, `p2` | `p1 * 100 + p2` |

## Test commands

| Command | Meaning | Arguments `a b c` | Return | Syscalls |
| --- | --- | --- | --- | --- |
| 0 | `(a + b) * c - a` | `3 4 5` | 32 | none |
| 0 | | `-2 10 3` | 26 | none |
| 1 | `abs(a - b)`, through a local | `9 4 0` | 5 | none |
| 1 | | `4 9 0` | 5 | none |
| 1 | | `5 5 0` | 0 | none |
| 2 | `helper(a, b) + c` | `6 7 8` | 51 | none |
| 3 | syscall 1 on `a`, plus `b` | `5 2 0` | 52 | 1 with `5` |
| 4 | `1 + 2 + ... + a`, a loop | `0 0 0` | 0 | none |
| 4 | | `10 0 0` | 55 | none |
| 5 | data word times `a`, plus the lit byte `J` (74) | `6 0 0` | 116 | none |
| 6 | syscall 2 on `a`, `b` with the result dropped, then `(a & b) / c` | `12 10 2` | 4 | 2 with `12 10` |
| 7 | 1 when `a == b`, else 0 | `3 3 0` | 1 | none |
| 7 | | `3 4 0` | 0 | none |
| 8 | `min(a, b)` | `9 4 0` | 4 | none |
| 8 | | `4 9 0` | 4 | none |
| 9 | the low byte of `a`, sign extended | `511 0 0` | -1 | none |
| 9 | | `127 0 0` | 127 | none |
| 10 | any other command | `1 2 3` | -1 | none |
