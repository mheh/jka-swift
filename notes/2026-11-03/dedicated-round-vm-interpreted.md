# The vm_interpreted hole round

The record of the first hole round on the dedicated host stem `vm_interpreted`, the port of `oracle/codemp/qcommon/vm_interpreted.cpp` into `Sources/JKAMP_DedLogic/vm_interpreted.swift`.
Ruling E13 of `notes/2026-11-03/dedicated-opening-docket.md` puts the interpreter in and keeps `vm_x86.cpp` out.
The branch is `dedicated-round-vm-interpreted`, off `dedicated-stage-3-landing`. The `vm.swift` stem did not change.

## What landed

1. `22cc450`, the adoption. The stub lost its skeleton header. `VM_CallInterpreted` takes `_ args: [Int32]` in place of `inout Int32`, and the `opnames` forward reads `[String?]`.
2. `dde8541`, three subscripts in `Sources/JKAShared/Views/RawField.swift`: `[int: ofs, index]`, `[short: ofs]`, and `[ushort: ofs]`.
3. `ca8bd33`, the bodies. `VM_Indent`, `VM_StackTrace`, and `VM_CallInterpreted` hold Raven's bodies. `EngineWorld` holds Raven's `opnames` table, 60 names and 196 nil slots.
4. `72b23d0`, the test. The new test target `JKAMP_DedLogicTests` holds `QVMInterpreterSuite` in `Tests/JKAMP_DedLogicTests/QVMInterpreterTests.swift`.

`VM_CallInterpreted` keeps Raven's switch in Raven's order, with 58 bare opcode cases and `default` last.
Raven's labels `nextInstruction` and `nextInstruction2` are two labeled loops, and each `goto` is a labeled `continue`. Raven's `goto done` is the break out of the outer loop.
The pointer `opStack` is an `Int32` index into the `stack` array, so `opStack != &stack[1]` reads `opStack != 1`.
The data image is the raw pointer over `vm.dataBase`, and the reads and writes take the `RawField` subscripts, `image[int: programStack + 44] = args[9]`.
The code image and the jump table are `Slots<Int32>` over `vm.codeBase` and `vm.instructionPointers`, so `codeImage[programCounter]` reads as Raven wrote it.

## The counts

- Functions: 4. Transcribed: 3. Left with the marker: 1, `VM_PrepareInterpreter`.
- `portMissing` lines in the stem: 2, the `VM_SetSymbolMap` hole in `VM_CallInterpreted` and the marker of `VM_PrepareInterpreter`.
- `Port-note:` lines in the stem: 10. `// AI:` lines in the stem: 3.
- Build: one `swift build`. It fails in the C target `CJKAMP_Ded` with 12 clang errors and no Swift error reached: 11 redefinitions of the `TK_*` enumerators in `Sources/CJKAMP_Ded/include/codemp/icarus/tokenizer/enum_TK_EOF.h:11-21`, and one `expected identifier` at `Sources/CJKAMP_Ded/include/codemp/qcommon/qcommon/sysEventType_t.h:11`. These are the 12 known errors of the landing branch, so the round stopped there.
- Tests, `swift build -c release`, and the round gate did not run. The Swift of this round has not met the compiler.

## The QVM fixture test

`indent` checks `VM_Indent` at call levels 0, 3, 20, and 25, and it can run once the target builds.
`commandsReturnTheReadmeValues` runs the 18 commands of `Sources/JKATestSupport/Oracle/fixtures/qvm/README.md` and checks each return value, each syscall, and the program stack after the call. It is disabled, because the interpreter stops at three places before its first instruction:

1. The `VM_SetSymbolMap` hole in `VM_CallInterpreted`.
2. The `VM_Debug` stub in `vm.swift`.
3. The `VM_PrepareInterpreter` marker. A loader in the test stands in for the QVM arm of `VM_Create` and for the two passes of `VM_PrepareInterpreter`. A call to `VM_PrepareInterpreter` replaces the loader when the function has a signature.

## Open rows

1. `VM_PrepareInterpreter` has no signature, because `vmHeader_t` has no view. Proposed: a `ROOTS` row for `vmHeader_t` in `rulings.py`, so `views.py` writes a `VmHeader` view, and the signature `func VM_PrepareInterpreter(_ vm: Vm, _ header: VmHeader)`. Raven reads the code bytes at `(byte *)header + header->codeOffset`, and that read needs the raw pointer over the view's slot, in the form of `bg_vehicleLoad.swift:65`. The row needs the generator sequence of the host unit.
2. `Hunk_Alloc` in `z_memman_pc.swift` has no signature, because no table row maps its `void *` return. Proposed: the `UnsafeMutableRawPointer` return of `G_Alloc` and `BG_Alloc`, a `RETURNS` row. `VM_PrepareInterpreter` needs it for `vm->codeBase`.
3. `VM_SetSymbolMap` is an inline function of `vm_local.h` over the `std::map` of `g_vmMap`, and the symbol map has no Swift shape. `vm.swift` spells `g_vmMap` as an `Int32` and keeps `g_symbolMap` as a marker. Proposed: the map is a design row of rule 17 for the `vm.swift` round, and `VM_SetSymbolMap` lives beside `VM_LoadSymbols` in `vm.swift`.
4. The `VM_CallInterpreted` signature and the `opnames` type are hand edits of an adopted file, and no `PARAMS` row records them. The store of the host unit is not built in this worktree, so `lookup.py sig` has no answer for the host. Proposed: a `PARAMS` row of kind `int_array` for `VM_CallInterpreted.args` at the next generator run of the host unit.
5. The `Vm` view gives `dataBase`, `codeBase`, and `instructionPointers` as `OpaquePointer?`, so the body builds the raw pointer and the two `Slots` itself, under rule 11. Proposed: keep this, or a later `views.py` row that writes a `Slots` accessor for an `int *` field the body indexes, as the `<name>Slots` accessor of a struct pointer field.

## Ledger

The rows below are ruled by an existing pattern of the codebase, under the delegated rulings of the dedicated track. The open rows above wait for the user.

1. `args` of `VM_CallInterpreted` is `[Int32]` by value. Ruled by the `int_array` row of the transcription guide, a read-only `int *` as `[Int32]`. The site carries an `// AI:` line.
2. `opnames` is `[String?]` with 196 nil rows after Raven's 60 names. Ruled by `Slots(strings:)`, where a `char *` slot is `String?`, and by the padding rule of `botGlobalNavWeaponWeights` in `ai_wpnav.swift`. The 196 rows are one `repeating:` array under a comment that names the row count and the bound. The debug print passes `opnames[opcode] ?? "(null)"`, the `%s` rule for a NULL text.
3. The static `string` of `VM_Indent` is a local `CharBuf`. Ruled by the rule for the static buffers of `va` and `vtos`: a returned `String` is a copy, and no statement writes the text. The site carries an `// AI:` line.
4. The data image is a raw pointer over the view field, with a rule 11 comment. Ruled by `bg_vehicleLoad.swift:65` and the `RawField` subscripts of `BG_ParseField`.
5. The subscripts `[int: ofs, index]`, `[short: ofs]`, and `[ushort: ofs]` join `RawField.swift`. Ruled by the file's own rule, one labeled subscript per C type Raven casts to at an offset, beside `[float: ofs, index]`.
6. `opStack` is an index local, and `src` and `dest` of `OP_BLOCK_COPY` are byte offsets. Ruled by the pointer rules of the guide: a pointer into one table is its index, and a pointer into a buffer is its byte offset. The alignment test of `OP_BLOCK_COPY` reads the offsets, and the site carries an `// AI:` line.
7. The `(float *)opStack` reads and writes take `Float(bitPattern:)` and `.bitPattern`. Ruled by the guide's `bitPattern` rule for a reinterpret of a scalar's bytes.
8. The `(unsigned)` casts are `UInt32(bitPattern:)`, and a store of an unsigned result into an `int` slot is `Int32(bitPattern:)`. Ruled by `g_client.swift:2859`.
9. Signed `+`, `-`, `*`, unary `-`, and the shifts wrap. Rule 19: C leaves the overflow undefined, and the x86 build wraps. One `Port-note:` pair at the switch names the operators.
10. The read of `stack[-1]` at the free spot reads 0. Rule 19, with a `Port-note:` pair at the read.
11. `VM_StackTrace` spells `while ( programCounter != -1 && ++count < 32 )` as a `break` on `-1` and the step before the test. Ruled by rule 10. The short circuit of Raven's `&&` stays.
12. `OP_BCOM` writes `opStack[-1]` and leaves `opStack` as it is, as Raven wrote it. The port keeps this form.
