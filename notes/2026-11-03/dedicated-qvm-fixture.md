# The QVM test fixture

The record of the small QVM image for the stage 1 proof of row E13, the interpreter port of `oracle/codemp/qcommon/vm_interpreted.cpp`.
The docket is `notes/2026-11-03/dedicated-opening-docket.md`. This work builds the fixture and a test of its header only. The interpreter is not ported yet.
No file under `tools/`, `Sources/`, `.github/`, `jka-rust/`, or `../jka-rust` changed.

## How the image was made

`Sources/JKATestSupport/Oracle/fixtures/qvm/assemble.py` assembles the image from an opcode list in the script, with named labels for the branch and call targets.
It writes the header as `vmHeader_t` of `oracle/codemp/qcommon/qfiles.h` (eight little-endian words, `VM_MAGIC` 0x12721444), the code at offset 32, the data word, the lit bytes, and the map file in the format `VM_LoadSymbols` parses (`oracle/codemp/qcommon/vm.cpp:238`).
After the write, the script reads the file back and asserts each header field, the file size, and the data and lit bytes.
The script also holds an interpreter that follows `VM_PrepareInterpreter` and `VM_CallInterpreted`. It decodes the code bytes, builds the instruction pointers the way Raven does, uses the 48-byte entry frame with `-1` as the return marker, and answers a `CALL` to a negative address as a syscall.
It runs the image with 18 test commands and prints the expected return values and the syscalls. The README holds the table.

## The opcodes

The image uses 23 distinct opcodes: `ADD`, `ARG`, `BAND`, `CALL`, `CONST`, `DIVI`, `ENTER`, `EQ`, `GEI`, `GTI`, `JUMP`, `LEAVE`, `LOAD1`, `LOAD4`, `LOCAL`, `LTI`, `MULI`, `NE`, `NEGI`, `POP`, `SEX8`, `STORE4`, `SUB`.
It has 197 instructions in 622 code bytes. It makes a call to the second function `helper`, two syscalls (addresses -2 and -3), a loop with a backward `JUMP`, and a read of the data and lit segments.
It does not use `BREAK`, `PUSH`, `LOAD2`, `STORE1`, `STORE2`, `BLOCK_COPY`, the unsigned compares, the float opcodes, `MODI`, `MODU`, `DIVU`, `MULU`, `BOR`, `BXOR`, `BCOM`, the shifts, or `SEX16`.

## The checks

- `swift build` passes.
- `swift test --no-parallel` passes with 3 new tests in `QVMFixtureSuite` (`Tests/JKASharedTests/QVMFixtureTests.swift`). The `JKASharedTests` run goes from 84 to 87 tests, and the other runs are unchanged.

## Rows

1. `Tests/JKATestSupport/` did not exist, so the fixture directory `Sources/JKATestSupport/Oracle/fixtures/qvm/` is new. The `JKATestSupport` target lives at `Sources/JKATestSupport` and holds its goldens as `Oracle` resources (`Package.swift:71-76`). The fixture is not a resource of that target. The test finds it with `#filePath`, so the test needs the source tree at its build path. Proposed: keep this, or move the fixture to `Sources/JKATestSupport/Fixtures` as a `.copy` resource.
2. The image comes from a hand-written assembler and not from `q3asm`, so it holds no `lcc` output. A stage 1 test of the interpreter proves the opcodes listed above and no more.
3. The opcodes the image does not use are not proved by this fixture. Proposed: add cases to `assemble.py` when the interpreter port reaches them, for example the float compares and `BLOCK_COPY`.
4. `bssLength` is 131064 so that the data mask is `0x1ffff` and the 0x20000-byte stack of `VM_Create` fits at the end. The value is a choice of this fixture, and `q3asm` sets its own.
5. The expected values come from the interpreter in the script, which the same author wrote from the same source as the port. A shared misreading of `vm_interpreted.cpp` would pass in both. The hand checks of the values in the README (for example 32 = (3 + 4) * 5 - 3) are the only independent check.

## Ledger

1. Replaced by the resource form. The fixture moved to `Sources/JKATestSupport/Oracle/fixtures/qvm/` beside the other fixtures, and `QVMFixtureSuite` reads it through `OracleData.fixtureData` and `OracleData.fixture`. The test no longer uses `#filePath`. `assemble.py` and the README stay beside the image.
2. Ratified as a fact.
3. Ratified as a fact.
4. Ratified as a fact.
5. Ratified as a fact.
