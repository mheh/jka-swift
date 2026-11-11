# The W2 body round of the dead-function wave

This record holds set W2 of section 4 of `notes/2026-11-10/docket-13.md`: CCMLandScape, cm_load, vm, and CNavigator. The work is on the branch `ded-bodies-w2` in the worktree `/tmp/jka-w2`, from master `e820175b`. Each function has no caller in the dedicated server, and it gets its real body under rule 20. Each body keeps its one-line note that says why no caller exists. A check against `oracle/codemp/` confirmed each note.

## The functions

| Function | Raven | File | State |
| --- | --- | --- | --- |
| CCMLandScape::GetTerxelLocalCoords | `cm_terrain.cpp:862` | `CCMLandScape.swift` | landed |
| CCMLandScape::CarveLine | `cm_terrain.cpp:1133` | `CCMLandScape.swift` | landed |
| CCMLandScape::CarveBezierCurve | `cm_terrain.cpp:1245` | `CCMLandScape.swift` | landed, on the `Slots<vec3_t>` of row G7 |
| CCMLandScape::FractionBelowLevel | `cm_terrain.cpp:1379` | `CCMLandScape.swift` | landed, on the `info_FractionBelowLevel` storage of row G6 |
| CCMLandScape::GetFirstObjectiveArea | `cm_terrain.cpp:1422` | `CCMLandScape.swift` | landed |
| CCMLandScape::GetPlayerArea | `cm_terrain.cpp:1442` | `CCMLandScape.swift` | landed |
| CCMLandScape::GetNextObjectiveArea | `cm_terrain.cpp:1472` | `CCMLandScape.swift` | landed |
| CM_Checksum | `cm_load.cpp:544` | `cm_load.swift` | landed, on the `checksums_CM_Checksum` storage of row G6 |
| VM_VM2C | `vm.cpp:37` | `vm.swift` | landed, on the `opaque` return of row G18 |
| VM_LogSyscalls | `vm.cpp:934` | `vm.swift` | landed, on the static locals of hand item H-VMLOG |
| CNavigator::GetNodeLeadDistance | `navigator.h:182` | `CNavigator.swift` | closed before this round. The generator batch of ledger 14 (row G5) wrote the "Not ported" marker, so this round has no change |

Ten bodies landed. No stub of the set stays open.

## The forms

- GetTerxelLocalCoords: the internal name of the Slots parameter is now `localCoords`, the name of Raven's definition. The header `cm_landscape.h:180` names it `coords`, and that name is the same as the name of Raven's local. The external label stays `_`, so no caller changes.
- CarveLine: `irand` is the method of the class, because C++ finds the member first. The `float` and `int` conversions at `pt`, the `CArea::Init` radius, and the FlattenArea height have "C converts" comments.
- VM_LogSyscalls: Raven's `fprintf` is `JKAShared.format` into a CharBuf and `FileBackend.fwrite`, the form of `l_log.swift`. The pointer difference `args - (int *)currentVM->dataBase` is `dataBase.offset(of: args.bytes) / Int32(Int32.byteCount)`, the verdict of H-VMLOG.
- CM_Checksum: LittleLong of the WinDed arm is its argument, the form of `vm.swift` and `files_pc.swift`.

## The checks

- `swift build -j 2`: exit 0, no warning in the three changed files.
- `swift test --no-parallel -j 2`: 166 of 166 pass, with no failure. The suites print 1, 1, 1, 103, 13, 20, 3, 16, 4, and 4 tests.
