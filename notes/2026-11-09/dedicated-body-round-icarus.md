# Dedicated body round: icarus

The round fills the method bodies of the 14 ICARUS, navigator, and ROFF classes of PR 84 and the function bodies of the ICARUS interface files. Branch `ded-bodies-icarus` off master `837bc43`. Three opus agents wrote the bodies: ICARUS core, navigator and ROFF, and the interface files. No agent changed a signature, a stored field, a table, or a tool.

## Stubs per file

The count is `grep -c portMissing` on master and after the round. A count after the round includes the holes: a body that is written, with one `portMissing` at one arm that a gap blocks, in the form of `cm_patch.swift:427`.

| File | Before | After | Holes in the after count |
|---|---|---|---|
| CBlock.swift | 13 | 1 | 0 |
| CBlockMember.swift | 11 | 10 | 0 |
| CBlockStream.swift | 14 | 5 | 1 |
| CSequence.swift | 18 | 1 | 0 |
| CSequencer.swift | 44 | 21 | 9 |
| CTask.swift | 4 | 0 | 0 |
| CTaskGroup.swift | 5 | 0 | 0 |
| CTaskManager.swift | 41 | 28 | 9 |
| ICARUS_Instance.swift | 24 | 10 | 0 |
| Instance.swift | 0 | 0 | 0 |
| Memory.swift | 1 | 0 | 0 |
| GameInterface.swift | 16 | 8 | 0 |
| Q3_Interface.swift | 44 | 4 | 0 |
| Q3_Registers.swift | 16 | 16 | 0 |
| CNavigator.swift | 54 | 11 | 1 |
| CNode.swift | 15 | 2 | 0 |
| CEdge.swift | 2 | 0 | 0 |
| CPriorityQueue.swift | 5 | 3 | 0 |
| navigator.swift | 7 | 0 | 0 |
| CROFFSystem.swift | 21 | 6 | 4 |
| RoffSystem.swift | 0 | 0 | 0 |
| Total | 355 | 126 | 24 |

The four ROFF holes: the note-track branch of InitROFF2 (row 10), the client arm and the done arm of ApplyROFF (row 9), and the VM_Call of ProcessNote, which waits for row SV3 of ledger 8.

## Where the map load stops

ICARUS_Init stays a stub. It needs `interface_export` for `Interface_Init` and `ICARUS_Instance::Create`, and both keep the signature marker of `interface_export_t`. `ICARUS_Instance.GetSequencer` calls the `Never` stub `CSequencer.Init`, so ICARUS_InitEnt stops there too. The navigator's Init, Free, and Load run. Load returns false when no `.nav` file exists, and with a file it stops at GetLong. The ROFF construction, Clean, Cache, Play, PurgeEnt, and UpdateEntities run. `CTaskManager.Go` runs for an empty task list, which is the per-frame path of `G_ICARUS_MAINTAINTASKMANAGER`.

## Stubs that stay

- `interface_export_t` (`interface.h:17`): ICARUS_Init, Interface_Init, ICARUS_Instance Create, GetInterface, and the eight Save and Load methods, CSequencer Init and GetInterface, CSequence.SaveCommand, and 15 CTaskManager commands (WaitSignal, Print, Sound, Rotate, Remove, Camera, Move, Kill, Set, Use, DeclareVariable, FreeVariable, Signal, Play, SaveCommand).
- `CBlockMember.m_data` (`blockstream.h:104`): nine CBlockMember methods, CBlock.GetMemberData, ten CSequencer parse and check methods, CTaskManager GetFloat, GetVector, Get, and Wait, and ICARUS_InterrogateScript.
- `FILE *` (`blockstream.h:191`): CBlockStream Create and WriteBlock, CBlockMember.WriteMember.
- `failedEdges` (`navigator.h:245`): ClearAllFailedEdges, EdgeFailed, AddFailedEdge, CheckAllFailedEdges, Save, and the tail of Load.
- `NodeTotalGreater` (`navigator.cpp:2694`): CPriorityQueue Pop, Push, and Update.
- Rule 20, no callers: CBlockStream GetUnsignedInteger and GetLong. `CNavigator.GetNodeLeadDistance` has a declaration and no body in Raven.
- The rows below hold the rest.

## Rows

1. `ICARUS_BufferList` and `ICARUS_EntList`, `std::map` globals of `icarus/GameInterface.cpp:17` and `:18`, have no storage (`GameInterface.swift:14`, `:19`). They block ICARUS_GetScript, ICARUS_RegisterScript, ICARUS_Shutdown, ICARUS_FreeEnt, ICARUS_AssociateEnt, and Q3_GetEntityByName. Pattern: HAND_VARS rows (`rulings.py:387`) with `[String: pscript_t]` and `[String: Int32]` hand properties of `EngineWorld`, the form of `gSequencers` (`EngineWorld.swift:463`). `pscript_t` needs a Swift form, a CharBuf and a length.
2. `BSTable` of `icarus/GameInterface.cpp:592` has no host table (`GameInterface.swift:28`), so ICARUS_PrecacheEnt stays. Pattern: `BSTable: Slots<StringIDTable>` of `JKAMP_Game/GameTables.swift:18`, a twin in JKAMP_Ded.
3. `varStrings`, `varFloats`, and `varVectors` of `icarus/Q3_Registers.cpp:9` to `:11` have no storage (`Q3_Registers.swift:9`, `:14`, `:19`), so all 16 register functions stay. Pattern: HAND_VARS rows with `[String: String]` and `[String: Float]` hand properties of `EngineWorld`. The four `varFloat_m &` and `varString_m &` parameters (`Q3_Registers.swift:93`, `:102`, `:117`, `:126`) then need PARAMS rows.
4. The constants of `Q3_Registers.h:6` and `:14` (VTYPE_*, MAX_VARIABLES) and the SET_* names have an export in `JKAMP_Game/Generated/Q3_Registers.swift:8` only, so Q3_SetVar (`Q3_Interface.swift`, Raven `Q3_Interface.cpp:337`) stays. Pattern: the re-export of `tokenizer.h` into `JKAMP_Ded/Generated/tokenizer.swift`.
5. The constants of `server/NPCNav/navigator.h:9` to `:22` and `:133`, `game/g_nav.h:7` and `:9`, and `qcommon/RoffSystem.h:24` to `:27` have no host export. The navigator and ROFF bodies use Raven's literal values, each under a rule 24 line (`CNode.swift:80`, `CNavigator.swift`, `CROFFSystem.swift`). Pattern: the re-export of a header of the host parse, as row 4, after which each literal takes its name.
6. `Q3_ReadScript` takes `void **buf` as `inout OpaquePointer?` (`Q3_Interface.swift:12`, Raven `Q3_Interface.cpp:45`). Pattern: a PARAMS row that gives `inout TextCursor`, the form of `buf` of ICARUS_GetScript (`GameInterface.swift:33`).
7. Raven's `long` fields and reads have no one width. CNavigator.GetLong (`CNavigator.swift`, Raven `navigator.cpp:557`) and CNode Save and Load (`CNode.swift`, Raven `navigator.cpp:385`, `:426`) stay, because `Slots<byte>` has no 8-byte subscript (`JKAShared/Views/Slots.swift:200` to `:230`). The ROFF bodies read `mVersion` of `RoffSystem.h:58` and `:75` as 4 bytes, the width of Raven's Win32 build. A ruling picks one width for the shipped `.nav` and `.rof` files. The 4-byte width reads the files Raven's tools wrote.
8. `CheckedNodes` is `let CheckedNodes: Int32 = 0` at `navigator.swift:57`, and Raven's is `static map<int,byte>` at `navigator.cpp:1687`. ClearCheckedNodes, CheckedNode, and SetCheckedNode stay. Pattern: a HAND_VARS `[Int32: JKAShared.byte]` property of `EngineWorld` with a forward.
9. `delta` of CROFFSystem.SetLerp is `vec3_t` (`CROFFSystem.swift:535`), and Raven tests it against NULL at `RoffSystem.cpp:1024` and `:1032` and passes NULL at `:866`, `:867`, `:1012`, `:1013`. SetLerp, ClearLerp, and the done arm of ApplyROFF stay. Pattern: `vec3_t?`, the mins and maxs of SV_Trace (`sv_world.swift:660`).
10. The note-track branch of InitROFF2 needs `strlen` over a `Slots<byte>` (`CROFFSystem.swift:326`, Raven `RoffSystem.cpp:221` to `:240`). `CString.swift:134` to `:150` has `strlen` for CharBuf, String, and PooledString only. Pattern: the file bytes as a CharBuf through the CharBuf overload of FS_ReadFile (`files_pc.swift:1548`).
11. The `m_fileHandle = NULL` store of CBlockStream.Init (`CBlockStream.swift:189`, Raven `BlockStream.cpp:558`) is a hole on the path of ICARUS_InterrogateScript. It closes with the `FILE *` row, or a ruling drops the store.
12. Bodies discard results with `_ =` at each site where Raven drops the result of PushCommand, Route, Recall, Free, Init, AddMember, Create, PushTask, Completed, and SetCommand. `docs/transcription.md:788` gives `@discardableResult` on the declaration, as `GenericParser2.swift:439`. That is a declaration change, so the round did not make it.
13. The interface bodies convert the `Int` of VM_Call to Raven's `int` with `Int32(truncatingIfNeeded:)`, under a rule 24 line, in ICARUS_GetIDForString, Q3_PlaySound, Q3_GetTag, Q3_GetFloat, Q3_GetVector, and Q3_GetString. No body before this round does that. Q3_GetTime and Q3_GetTimeScale convert to `DWORD` with no cast in Raven. A ruling picks the form.
14. The shared memory bodies of `Q3_Interface.swift` read Raven's `(T_G_ICARUS_X *)sv.mSharedMemory` as `IcarusX(sv.mSharedMemoryBytes!.base)`, the view cast of `docs/transcription.md:362`. No body before this round reads `mSharedMemoryBytes`.
15. The round added three hand declarations with a Raven source: `IBI_VERSION` (`CBlockStream.swift:7`, `blockstream.h:21`), `RUNAWAY_LIMIT` (`CTaskManager.swift:7`, `taskmanager.h:15`), and the function-like macro `S_FAILED` (`CSequencer.swift:8`, `sequencer.h:36`). Pattern: the hand `MAX_FILENAME_LENGTH` of `CBlockStream.swift` and `docs/transcription.md:322`. A re-export of these headers replaces the two constants.
16. Outside the round: `be_aas_entity.swift:9` declares `let MASK_SOLID = JKAShared.CONTENTS_PLAYERCLIP`, which hides `JKAShared.MASK_SOLID` in all of JKAMP_DedLogic. SV_OrgVisibleBox (`sv_bot.swift:53`, `:55`) then traces with CONTENTS_PLAYERCLIP and not Raven's `CONTENTS_SOLID|CONTENTS_TERRAIN` of `bg_public.h:1171`. The navigator bodies write `JKAShared.MASK_SOLID`.

## Departures from Raven's form

Each site carries a rule 24 line or a rule 19 Port-note.
- ICARUS_Instance Free and DeleteSequence call `Delete()` and `Free()` where Raven's `delete` ran the destructor, because a sequence holds its children and its return sequence by strong references.
- `CSequencer.GetTaskSequence` returns nil for a nil group, because a Dictionary has no nil key.
- The two StripExtension bodies test the index before the read, under rule 19.
- `CNavigator.GetPathCost` adds with `&+` under rule 19.

## Build and tests

- `swift build -j 2`: exit 0 on the first run. The holes give "will never be executed" warnings.
- `swift test --no-parallel -j 2`: exit 0, 150 tests in 9 runs, 0 failures.
