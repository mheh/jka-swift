# The body round of set S2 of docket 13

This record holds the body round of set S2 of `notes/2026-11-10/docket-13.md`, section 4, on the branch `ded-bodies-s2` in the worktree `/tmp/jka-s2`, made from `dedicated-rulings-batch-12`. Each function has no caller in the dedicated server, and each one gets its real body. No file of the set had the skeleton header.

## The counts

| File | Set functions | Landed | Open |
| --- | --- | --- | --- |
| be_aas_route | 4 | 4 | 0 |
| be_aas_sample | 4 | 4 | 0 |
| be_ea | 5 | 5 | 0 |
| be_ai_goal | 1 | 1 | 0 |
| CBlockStream | 3 | 3 | 0 |
| vm | 2 | 2 | 0 |
| Total | 19 | 19 | 0 |

`swift build -j 2` is clean, and `swift test --no-parallel -j 2` passes 156 tests.

## The functions

- AAS_CreateAllRoutingCache (`botlib/be_aas_route.cpp:870`): landed. The local `t` keeps Raven's store with no read, so the compiler warns once.
- AAS_BridgeWalkable (`:1892`): landed.
- DistancePointToLine (`:2049`): landed.
- AAS_NearestHideArea (`:2063`): landed. The hand static `hidetraveltimes` is a `Slots<UInt16>?` on `EngineWorld`, with its accessor in `be_aas_route.swift`, the form of `bot_debug`. Raven's `reach` walk pointer is the index local `reachIndex` (transcription.md:501).
- AAS_BoxOriginDistanceFromPlane (`botlib/be_aas_sample.cpp:349`): landed. `BBOX_NORMAL_EPSILON` is a double literal, so each compare widens the float.
- AAS_AreaGroundFace (`:1001`), AAS_FacePlane (`:1035`), AAS_TraceEndFace (`:1050`): landed.
- EA_Tell, EA_UseItem, EA_DropItem, EA_UseInv, EA_DropInv (`botlib/be_ea.cpp:55` to `:95`): landed in the EA_Say form.
- BotFindEntityForLevelItem (`botlib/be_ai_goal.cpp:949`): landed in the `AasEntityinfo.scratch` form of BotUpdateEntityItems.
- CBlockStream::GetUnsignedInteger (`icarus/BlockStream.cpp:420`): landed, `[int:]` with `UInt32(bitPattern:)` under a "C converts" line.
- CBlockStream::GetLong (`:452`): landed, the MSVC `long` as `Int32`.
- CBlockStream::Create (`:525`): landed with FileBackend.fopen and fwrite. The float `version` goes into a CharBuf of its bytes under an AI line, the CNode.Save form.
- VM_SymbolToValue (`qcommon/vm.cpp:148`): landed.
- VM_SymbolForCompiledPointer (`:165`): landed. `CRAZY_SYMBOL_MAP` is defined at `vm_local.h:3`, so the body keeps the VM_SetSymbolMap call.

WriteBlock, VM_VM2C, and VM_LogSyscalls are not in this set. They wait on the generator rows G10, G18, and H-VMLOG.

## The Port-notes

- The "so it keeps its marker" ends of the three CBlockStream notes are gone, because the functions now have bodies.

## The rule 19 note

- AAS_NearestHideArea zeroes `aasworld.numareas` entries of the allocation of the first call (`be_aas_route.cpp:2081`), and a larger count on a later map writes past its end. The Slots keeps the count of the first call, and the body zeroes that count with `zero()`. With a smaller count on a later map, the entries past `aasworld.numareas` are never read. With a larger count, the Slots subscript traps at `hidetraveltimes![nextareanum]` for an area past the first count.

## The review fixes

- CBlockStream::Create writes `sizeof(id_header)` bytes of `IBI_HEADER_ID` (`BlockStream.cpp:546`). `id_header` is a `char *`, and a pointer is 4 bytes in Raven's 32-bit build, the length of `IBI\0`. That is defined behavior, not rule 19. The body writes `strlen(IBI_HEADER_ID) + 1` bytes, the size form of the file's `Open`, and both readers take 4 bytes.
- The rule 19 note of AAS_NearestHideArea now states both cases, the smaller count and the larger count.
- VM_SymbolForCompiledPointer converts the `int` of `instructionPointers` to an address at `vm.cpp:175`. In Raven's 32-bit build an `int` and a pointer are both 4 bytes, so the `int` bits are the address with no extension. The body zero-extends with `UInt(UInt32(bitPattern:))`, and one comment line states the width fact.

The tests pass 156 after the review fixes.
