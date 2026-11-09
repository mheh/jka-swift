# Dedicated round: vm, the virtual machine

Branch `dedicated-round-vm`, off master at `1cdd22f`, in the worktree `/tmp/jka-ded-vm`. The code commit is `5ee5b09`. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`. The stem is `Sources/JKAMP_DedLogic/vm.swift`, the port of `oracle/codemp/qcommon/vm.cpp`, and the one hole of `Sources/JKAMP_DedLogic/vm_interpreted.swift`.

## The bodies

The stub had the skeleton header, so the round adopted it and removed the header in the code commit. The drafter gave 52 holes over the stem.

- Whole bodies: VM_Debug, VM_Init, VM_ValueToSymbol, ParseHex, VM_Free, VM_Clear, VM_Call, and VM_VmInfo_f.
- Bodies with holes: VM_ValueToFunctionSymbol, VM_LoadSymbols, VM_Restart, VM_Create, VM_Shifted_Alloc, VM_Shifted_Free, and VM_VmProfile_f. The table of open holes below lists each hole.
- Markers under rule 20, with the dead note: VM_VM2C, VM_SymbolToValue, VM_SymbolForCompiledPointer, and VM_LogSyscalls. No file of either tree calls them. vm_x86.cpp and vm_interpreted.cpp call VM_LogSyscalls only in a comment.
- Markers with a row: VM_Alloc, VM_ArgPtr, BotVMShift, and VM_ExplicitArgPtr (row V1), VM_DllSyscall (row V9), and VM_ProfileSort (row V8).
- VM_LoadSymbols reads the map file through the CharBuf form of FS_ReadFile and tests `len < 0`, the form of Cmd_Exec_f.
- VM_Call reads the words of the caller once, before the arm test, under a rule 19 note. The dll arm calls `vm.runEntryPoint(callnum, words)`, and the other arms pass `[callnum] + words`, the `int_array` form of VM_CallInterpreted.

## The symbol map, ruling C8

Ruling C8 of `notes/2026-11-03/dedicated-cxx-docket.md` makes the map a Dictionary on the world. The row of `notes/2026-11-04/dedicated-round-vm-interpreted-readoption.md` puts VM_SetSymbolMap beside VM_LoadSymbols in vm.swift.

- `EngineWorld` holds `g_vmMap: [Vm: [Int32: VmSymbol]]` and `g_symbolMap: Vm?` in a `vm.cpp` section, each with a rule 24 line. The forwards of vm.swift read them. The generated `Int32` field `g_vmMap` of `EngineVariables` stays and has no reader.
- `VM_SetSymbolMap(_ vm: Vm)` stores the VM, under a rule 24 line, with the cite `oracle/codemp/qcommon/vm_local.h:162`. Its precedent is a hand home for an inline function of a header, `bg_public.h.swift`.
- VM_ValueToSymbol and VM_ValueToFunctionSymbol read `g_vmMap[g_symbolMap!]?[value]` and store the scan's symbol at the same key.
- VM_Free and VM_Clear remove the map of the slot, with the rule 19 note that C8 names.
- VM_CallInterpreted calls `VM_SetSymbolMap(vm)`, so vm_interpreted.swift has no `portMissing` line.

## The hand forms

| Form | File | Raven's counterpart |
|---|---|---|
| `Vm.runEntryPoint(_:_:)` and `VmMainWords` | `Sources/JKAMP_Ded/VmEntry.swift`, new | `vm->entryPoint( callnum, args[0], ..., args[15] )` at `vm.cpp:816`, and the `vmMain` export at `oracle/codemp/game/g_main.c:515` |
| `VM_SetSymbolMap(_:)` | `Sources/JKAMP_DedLogic/vm.swift` | `vm_local.h:162` |
| `VM_CallCompiled(_:_:)` and `VM_Compile(_:_:)` | `Sources/JKAMP_DedLogic/vm.swift` | the `oDLL_ONLY` bodies at `vm.cpp:949` and `:953`, by ruling E13 |
| `g_vmMap` and `g_symbolMap` | `Sources/JKAMP_DedLogic/EngineWorld.swift` | `vm.cpp:20` and `:21`, by ruling C8 |

`runEntryPoint` takes the fixed type of the export, `(Int, Int x 12) -> Int`, the type of `jka_vmmain_fn` in `Sources/CJKAHost/include/jka_host.h`. The module exports `vmMain` with `@_cdecl` in `Sources/jampgame/jampgame.swift:27` with that type. Each word widens from `Int32` to `Int`, and the return keeps its low 32 bits, Raven's `int`. Each change carries a rule 24 line, and the 4 extra words of Raven's call carry a rule 19 note.

VM_CallCompiled and VM_Compile have no stub, because the skeleton reads no `oDLL_ONLY` arm and vm_x86.cpp does not port. Their parameters copy the forms of VM_CallInterpreted and VM_PrepareInterpreter.

## Rows for the user

- Row V1, the `void *` returns. Question: VM_Alloc (`vm.cpp:227`), VM_ArgPtr (`:640`), BotVMShift (`:657`), and VM_ExplicitArgPtr (`:742`) return `void *`, and `RETURNS` has no row for them. Callers: VM_Create at `:560` and `:573` and VM_LoadSymbols at `:300` for VM_Alloc, sv_game.cpp, sv_client.cpp, and sv_snapshot.cpp for VM_ArgPtr, sv_client.cpp, sv_ccmds.cpp, and sv_init.cpp for VM_ExplicitArgPtr, and sv_bot.cpp for BotVMShift. Proposal: the `RETURNS` kind `raw`, the row of Z_Malloc, Hunk_Alloc, and row Z3 of the fifth ledger. VM_Create then stores `vm.dataBase = OpaquePointer(VM_Alloc(dataLength))`, the store of `vm.codeBase` in VM_PrepareInterpreter.
- Row V2, the `systemCalls` parameter of VM_Create. Question: the table gives `((inout Int32) -> Int32)?` for `int (*systemCalls)(int *)` at `vm.cpp:471`, the field `systemCall` holds `VmSystemCall`, a C function, and SV_GameSystemCalls takes `Slots<Int32>`. Sites: `vm.cpp:506` and VM_Restart at `:403` to `:408`. Proposal: a `PARAMS` row that gives the parameter the field's type `VmSystemCall?`. The caller passes a C thunk over SV_GameSystemCalls, the form of the stored function thunks of rule 3. The jampded shell sets the same thunk into `jka_systemCall` of CJKAHost.
- Row V3, the QVM image. Question: the read into `vmHeader_t *` through `(void **)&header`, the `int *` casts of the header, the `byte *` field `dataBase`, the `int *` field `instructionPointers`, and `FS_FreeFile( header )` have no form in a logic target. Sites: `vm.cpp:307`, `:416` to `:455`, and `:530` to `:587`. Proposal: an overload `FS_ReadFile(_:_: inout VmHeader?)` and `FS_FreeFile(_: VmHeader?)` in files_pc.swift, the `CharBuf?` form of row 7 of the first ledger. `views.py` writes a `Slots` accessor for a `byte *` or `int *` field that a body indexes, row 5 of `notes/2026-11-03/dedicated-round-vm-interpreted.md`.
- Row V4, the call of Sys_LoadDll. Question: the stub in win_main.swift has a signature marker for `int (**entryPoint)(int, ...)`, so `vm->dllHandle = Sys_LoadDll( module, &vm->entryPoint, VM_DllSyscall )` at `vm.cpp:518` is a hole. The C type of the third parameter is the variadic callee, which only CJKAHost holds. Proposal: the win_main round gives Sys_LoadDll the parameters `(_ name: String, _ vm: Vm)` by a `PARAMS` row, and its body calls a view-target form over `jka_load_dll`. VM_Create then reads `vm!.dllHandle = Sys_LoadDll(module, vm!)`.
- Row V5, the static `nullSym`. Question: VM_ValueToFunctionSymbol returns `&nullSym`, a static `vmSymbol_t` at `vm.cpp:115`, and a scratch slot does not live past the return. Caller: VM_CallInterpreted under `com_vmdebug`. Proposal: a `BYTE_STORAGE_LOCALS` record entry, so `nullSym_VM_ValueToFunctionSymbol` is a record on `EngineStorage`, the form of `TheZone` of row Z1.
- Row V6, the shifted words. Question: VM_Shifted_Alloc clears a raw block with `memset` at `vm.cpp:700` and stores `(int)mem - (int)currentVM->dataBase` at `:716`. VM_Shifted_Free adds the two at `:730`. The `int` casts drop the high half of an address on a 64-bit host. Callers: the `G_TRUEMALLOC` and `G_TRUEFREE` arms of sv_game.cpp and cl_cgame.cpp. Proposal: Z_Malloc with `bZeroit` true is not Raven's call, so the block is a `Slots<byte>` of `size + 1` and takes `fill(0)`. The shift is a view-target accessor on `Vm` with the full width of the address under a rule 19 note, the form of `ZoneHeader(block:)` of `ZoneBlocks.swift`.
- Row V7, the symbol chain of VM_LoadSymbols. Question: `prev` is a `vmSymbol_t **` at `vm.cpp:268` and `:301` to `:302`, and `symName` is `char symName[1]`, which Raven allocates past its C size at `:300` and `:311`. Proposal: `prev` is a `Slots<VmSymbol?>` of count 1 over the slot address, the `slot` form of row 6 of the first ledger. `symName` takes a bound from the allocation, the `Winding.byteCount(points:)` form of row 4 of the third ledger.
- Row V8, the profile sort. Question: VM_VmProfile_f sorts a Z_Malloc table of `vmSymbol_t *` with qsort at `vm.cpp:870` to `:892`, and VM_ProfileSort takes `const void *` at `:833`. The host does not depend on `JKAMP_BG`, where `qsort` lives. Proposal: `sorted` is a `[VmSymbol?]` by rule 9, the `qsort` of `bg_lib.swift` moves to `JKAShared`, and a `PARAMS` row gives VM_ProfileSort `(VmSymbol?, VmSymbol?)`.
- Row V9, the Swift VM_DllSyscall. Question: the module calls the C VM_DllSyscall of `Sources/CJKAHost/jka_host.c:10`, because Swift cannot write a C variadic callee, so the Swift stub at `vm.cpp:363` has no caller. Proposal: a `NOT_PORTED` entry that names CJKAHost, so the skeleton writes no stub, the form of row Z2 for ZoneTailFromHeader.
- Row V10, the return of VM_Call. Question: VM_Call returns `Int32`, Raven's `int`, and the `vmMain` export returns a word. `GAME_CLIENT_CONNECT` returns a pointer to the denial text, and SV_DirectConnect reads it through VM_ExplicitArgPtr, so the low 32 bits are not the address on a 64-bit host. Proposal: a `RETURNS` row that gives VM_Call `Int`, and `runEntryPoint` returns the whole word.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| VM_ValueToFunctionSymbol | :125 | `return &nullSym` | V5 |
| VM_LoadSymbols | :268 | `prev = &vm->symbols` | V7 |
| VM_LoadSymbols | :299 to :303 | VM_Alloc and the stores through `prev` | V1, V7 |
| VM_LoadSymbols | :307 | `vm->instructionPointers[value]` | V3 |
| VM_LoadSymbols | :310 to :314 | the store of the value, the name, and the map entry | V7 |
| VM_Restart | :403 to :409 | the dll arm after `Q_strncpyz` | V2 |
| VM_Restart | :416, :423, :444, :447, :451, :455 | the QVM image | V3 |
| VM_Create | :506 | `vm->systemCall = systemCalls` | V2 |
| VM_Create | :518 | Sys_LoadDll | V4 |
| VM_Create | :530, :539, :564, :568, :587 | the QVM image | V3 |
| VM_Create | :560, :573 | VM_Alloc | V1 |
| VM_Shifted_Alloc | :700, :716 | the clear and the shift | V6 |
| VM_Shifted_Free | :730 | the shift | V6 |
| VM_VmProfile_f | :870 to :892 | the sorted table and the print loop | V8 |

The dll arm of VM_Create stops at the holes of rows V2 and V4. A body for VM_Create to reach `return vm` needs row V4 and the win_main round. VM_Call, VM_Free, and VM_Clear need no more rows, but VM_Free and VM_Clear call the Sys_UnloadDll stub of win_main.swift for a loaded dll.

## The test

`commandsReturnTheReadmeValues` of `Tests/JKAMP_DedLogicTests/QVMInterpreterTests.swift` has no `.disabled` trait now, and it passes. It runs the 18 commands of the fixture README through VM_CallInterpreted, which now reaches VM_SetSymbolMap and VM_Debug.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. vm.swift gives 26 warnings: 19 "will never be executed" after the holes, 2 "never mutated" on `header`, 3 unused `Cvar_Get` results, and 2 unused `COM_Parse` results at lines Raven wrote. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests in nine runs, 0 failures, 0 skipped |
| `draftcheck.py --unit mp-engine-ded --stem vm` | exit 0. 14 of 26 hand functions replaced, 12 kept, 53 holes, 0 cascade errors, 0 defects, 1 compile hole over 2 passes |
| `draftcheck.py --unit mp-engine-ded --stem vm_interpreted` | exit 0. 0 of 4 hand functions replaced, 4 kept, 162 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The 53 holes and the compile hole are in the drafter's output, not in the working tree. `portMissing` lines in the working tree: 35 in vm.swift, the 31 holes and markers of the rows above and the 4 rule 20 markers, and 0 in vm_interpreted.swift. `grep -c Unsafe Sources/JKAMP_DedLogic/vm.swift` gives 0.
