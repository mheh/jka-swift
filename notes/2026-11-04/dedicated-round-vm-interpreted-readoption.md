# The vm_interpreted readoption

The record of the readoption of the host stem `vm_interpreted` after the table batch of PR 55, and of its second hole pass.
The branch is `dedicated-round-vm-interpreted-2`. The first round's record is `notes/2026-11-03/dedicated-round-vm-interpreted.md`.

## The merge

`f15ebb3` merges master at `5323708`. One file had a conflict, `Sources/JKAMP_DedLogic/vm_interpreted.swift`, at the two functions whose signatures master changed.

- `VM_PrepareInterpreter` lost its `TODO: Port signature` marker and takes master's `(_ vm: Vm, _ header: VmHeader)`.
- `VM_CallInterpreted` takes master's `_ args: [Int32]?` in place of the branch's line. The ten reads of the body read `args![i]`, by the `int_array` row of `docs/transcription.md`.
- The file stays adopted, with no skeleton header. `opnames` stays master's `[String?]`.

Open rows 1, 2, and 4 of the first record are closed by master: `VmHeader` has a view, `Hunk_Alloc` returns `UnsafeMutableRawPointer`, and the `args` row is in the table.

## The second hole pass

`53fd3b7` gives `VM_PrepareInterpreter` Raven's body.

- `vm.codeBase` takes `OpaquePointer(Hunk_Alloc(vm.codeLength * 4, h_high))`, by the store of `Vehicle+Orientation.swift:12`.
- `code` is the raw pointer over the header's slot plus `header.codeOffset`, by `docs/transcription.md` on a `byte *` cast of a view.
- `codeBase` and the jump table are `Slots<Int32>` over `vm.codeBase` and `vm.instructionPointers`, in the form of `VM_CallInterpreted`.
- A byte of code reads `Int32(code[byte: pc] as byte)`, so the read zero-extends as Raven's `byte *` does. Raven's x86 `loadWord` reads `code[int: pc]`.

The body calls the `Hunk_Alloc` stub of `z_memman_pc.swift`, so it traps there until that function has a body.
The fixture test `commandsReturnTheReadmeValues` stays disabled. Its reason names the `VM_SetSymbolMap` hole, the `VM_Debug` stub, and the `Hunk_Alloc` stub.

## The counts

- Functions: 4. Transcribed: 4. `portMissing` lines in the stem: 1, the `VM_SetSymbolMap` hole in `VM_CallInterpreted`.
- `swift build`: complete, no error.
- `swift test --no-parallel`: 132 tests in nine runs pass, and one test is skipped, the disabled fixture test.
- `draftcheck.py --unit mp-engine-ded --stem vm_interpreted`: 162 holes, 0 cascade errors, 0 defects, and 0 compile holes in the stem. The run has 1 defect in another file.

## Open rows

1. `VM_SetSymbolMap` has no Swift home, row 3 of the first record. It waits on the symbol map design row of rule 17 for the `vm.swift` round.
2. The draftcheck defect is in master's generated `Sources/JKAMP_DedLogic/Generated/Callbacks.swift:4`. The file imports `JKAMP_BG`, and `Package.swift:64` gives `JKAMP_DedLogic` the dependency `JKAMP_Ded` alone. The full `swift build` builds `JKAMP_BG` for other products and passes, but the mirror build of the host product cannot resolve the module. Proposed: the skeleton writes no `JKAMP_BG` import for the host unit, or `Package.swift` declares the dependency.
