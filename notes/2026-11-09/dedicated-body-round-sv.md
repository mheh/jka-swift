# The sv body round, sv_world, sv_game, sv_snapshot, sv_client, and gameCallbacks

This record holds the body round of five stems of unit mp-engine-ded: `Sources/JKAMP_DedLogic/sv_world.swift`, `sv_game.swift`, `sv_snapshot.swift`, `sv_client.swift`, and `gameCallbacks.swift`. The tree is the worktree `/tmp/jka-sv` on the branch `ded-bodies-sv`, off master at `7961ee4`. The round wrote bodies only. It changed no generated signature, no generator table, and no python tool, and it ran no generator, no draftcheck, and no snapshot tool. The rulings of `notes/2026-11-09/dedicated-open-rows-ledger-7.md` (rows W1, W2, G1 to G12, N1 to N5) gave the signatures and the storage that the bodies use.

## The count of holes

| Stem | `portMissing` before | `portMissing` after |
|---|---|---|
| sv_world | 34 | 6 |
| sv_game | 21 | 9 |
| sv_snapshot | 17 | 0 |
| sv_client | 9 | 5 |
| gameCallbacks | 9 | 3 |
| Total | 90 | 23 |

## The bodies

- sv_world. SV_CreateworldSector has Raven's body over the `sv_worldSectors` table, and SV_ClearWorld calls it. SV_LinkEntity and SV_PointContents hand the BYTE_STORAGE_LOCALS slots `leafs_SV_LinkEntity` and `touch_SV_PointContents` to CM_BoxLeafnums and SV_AreaEntities, each with a forward and a rule 24 line at Raven's declaration. SV_AreaEntities_r walks the sector entities and reads one sector of its `Slots<WorldSector>` parameter as `node[0]`, and a recursion hands `Slots(record:)` over a child. SV_AreaEntities takes `AreaParms.scratch`, and SV_Trace takes `Moveclip.scratch`, with Raven's memset of the record dropped because the slot is zero at entry. SV_ClipMoveToEntities has Raven's body with the two `trace_t` locals as nested `Trace.scratch` closures. Its Ghoul2 test keeps Raven's condition, and the arm under it is one hole.
- sv_game. SV_inPVS and SV_inPVSIgnorePortals read the `Slots<byte>` of CM_ClusterPVS. Raven's `mask &&` test drops, because the return of kind `bytes` is never nil. The arms TRAP_STRNCPY (rule 19 note, return 0), G_ENTITIES_IN_BOX, G_SIEGEPERSSET, G_SIEGEPERSGET, G_DEBUG_POLYGON_CREATE, G_REAL_TIME, G_SNAPVECTOR, and G_BOT_UPDATEWAYPOINTS have bodies. Fifteen of the nineteen ICARUS arms call the generated stubs of GameInterface, Q3_Interface, and Q3_Registers, so a map load now stops in the ICARUS_Init stub and not in the switch.
- sv_snapshot. Every hole is filled. SV_EmitPacketEntities takes the optional `oldframe` of row N1. SV_QsortEntityNumbers compares the two numbers of row N3 under a rule 24 line. SV_AddEntToSnapshot and SV_AddEntitiesVisibleFromPoint have Raven's bodies over `SnapshotEntityNumbers`. SV_BuildClientSnapshot runs inside `SnapshotEntityNumbers.scratch`, sorts a copy of the record's array with the `[T]` qsort of CommonViews.swift and stores the numbers back under a rule 24 line, and reads the vehicle playerstate as the view of the field, the ConvertedEntity form of row N5. SV_SendClientSnapshot hands `msg_buf_SV_SendClientSnapshot` to both MSG_Init calls.
- sv_client. SV_GetChallenge calls the host `rand` of common.swift. SV_DirectConnect tests the word of GAME_CLIENT_CONNECT and reads the text through VM_ExplicitArgPtr under a rule 24 line, and a NULL text prints as `(null)`. SV_SendClientGameState and SV_SendClientMapChange hand the two `msgBuffer` slots to MSG_Init.
- gameCallbacks. The stub was adopted in the code commit, and the skeleton header is gone. The six callbacks with integer arguments call VM_Call and test the word.

`grep Unsafe` gives 0 in the five stems.

## The hand pieces

`Sources/JKAMP_Ded/GameViews.swift` has two more VMA accessors, each with Raven's macro as its counterpart and one `// AI:` line: `VMA(_:) -> Slots<Float>` for the `(float *)VMA(2)` of G_ICARUS_GETFLOATVARIABLE, and `VMA<V>(_:) -> Slots<V?>` for the `(wpobject_t **)VMA(2)` of G_BOT_UPDATEWAYPOINTS.

## The rule 24 sites

- The four forwards of the BYTE_STORAGE_LOCALS slots: sv_world.cpp:191 and :872, sv_snapshot.cpp:720, and sv_client.cpp:701 and :823.
- SV_ClipMoveToEntities (sv_world.cpp:529): the `float *origin` and `float *angles` locals are vector copies.
- TRAP_STRNCPY (sv_game.cpp:470): the CharBuf fill and the copy into the module's bytes.
- G_SNAPVECTOR (:680) and G_ICARUS_GETFLOATVARIABLE (:823): the slot of the Slots at the word.
- SV_QsortEntityNumbers (sv_snapshot.cpp:256): the two numbers by value.
- SV_BuildClientSnapshot (sv_snapshot.cpp:555, :588): the view of the vehicle playerstate, and the sort of a copy.
- SV_DirectConnect (sv_client.cpp:520): the word of VM_Call in `deniedWord`.

## Rows for the user

- Row SV1, the `const float *` fields of `areaParms_t` and `moveclip_t`. Question: Raven stores the address of a caller's vector, `ap.mins = mins` and `clip.mins = mins`, and the generated setter takes an `OpaquePointer?`. A Swift `vec3_t` has no address that a body can store. Sites: `oracle/codemp/server/sv_world.cpp:360`, `:361`, `:424`, `:425`, `:442`, `:443`, `:839`, and `:840`, the setters of `Sources/JKAMP_Ded/Generated/Views/AreaParms.swift` and `Moveclip.swift`, and the holes `sv_world.swift:434`, `:437`, `:701`, and `:704`. Every trace and every area query of the server stops at these holes. Proposal: a views.py rule that gives such a field a vector setter over a 12-byte block the record owns, or a FIELDS kind that reads the field as a `Slots<vec3_t>?` so a caller hands a storage slot. No precedent.
- Row SV2, the static local `touchlist` of SV_ClipMoveToEntities. Question: `static int touchlist[MAX_GENTITIES]` (sv_world.cpp:523) is the list SV_AreaEntities fills at :532, and it has no storage row, so the `Slots<Int32>` has no source. Site: the hole `sv_world.swift:505`. Proposal: a BYTE_STORAGE_LOCALS key `("touchlist", "SV_ClipMoveToEntities")`, the form of `touch_SV_PointContents` of row G6, because SV_AreaEntities writes the list before every read.
- Row SV3, vector arguments of VM_Call. Question: GNavCallback_NAV_ClearPathToPoint, GNavCallback_NPC_ClearLOS, and GNavCallback_NAVNEW_ClearPathBetweenPoints hand the address of `vec3_t` parameters to the module (gameCallbacks.cpp:8, :13, :18), and VM_Call reads only integer arguments (`vm.swift:845`, `:861` to `:866`). Sites: the holes `gameCallbacks.swift:10`, `:17`, and `:24`. Proposal: a word form for a vector argument, which needs a host block that the module can read for the life of the call. No precedent.
- Row SV4, the `value` parameter of Q3_GetVectorVariable. Question: the stub takes `value` by value (`Q3_Registers.swift:60`), and Raven's `sscanf` writes the three floats through it (`oracle/codemp/icarus/Q3_Registers.cpp:170`, `:179`). Site: the G_ICARUS_GETVECTORVARIABLE arm, sv_game.cpp:833 and the hole `sv_game.swift:833`. Proposal: a PARAMS row that makes `value` an `inout JKAShared.vec3_t`, the row of a written vector, and the arm hands `&v[0]` of the Slots at the word.

## The open holes

| Function | Raven line | Hole | Row |
|---|---|---|---|
| SV_AreaEntities | sv_world.cpp:424, :425 | `ap.mins`, `ap.maxs` | SV1 |
| SV_ClipMoveToEntities | :523 | the static `touchlist` | SV2 |
| SV_ClipMoveToEntities | :692 to :782 | the Ghoul2 collision arm, `G2Trace_t` and the G2API_ markers | Z6 |
| SV_Trace | :839, :840 | `clip.mins`, `clip.maxs` | SV1 |
| SV_GameSystemCalls | sv_game.cpp:715 | 5 ROFF arms, the class CROFFSystem | C |
| SV_GameSystemCalls | :752 to :782 | G_ICARUS_ISINITIALIZED, MAINTAINTASKMANAGER, ISRUNNING, the classes CSequencer and CTaskManager | C |
| SV_GameSystemCalls | :833 | G_ICARUS_GETVECTORVARIABLE | SV4 |
| SV_GameSystemCalls | :837 | 42 navigator arms, the class CNavigator | C |
| SV_GameSystemCalls | :944, :954 to :1311 | 11 and 123 botlib arms | B1 |
| SV_GameSystemCalls | :1314 | RE_RegisterServerSkin and 47 G2API_ arms | Z6 |
| SV_GameSystemCalls | :1624 to :1641 | G_RMG_INIT and G_CM_REGISTER_TERRAIN, the classes CRMManager and CCMLandScape | C |
| SV_InitGameProgs | :1750 | VM_Create of SV_GameSystemCalls | V2 |
| SV_WriteRMGAutomapSymbols | sv_client.cpp:668 | the whole body | C |
| SV_SendClientGameState | :768 | the RMG test | C |
| SV_WriteDownloadToClient | :1158, :1243 | the block allocation, its read, and its write | G13 |
| GNavCallback_NAV_ClearPathToPoint, GNavCallback_NPC_ClearLOS, GNavCallback_NAVNEW_ClearPathBetweenPoints | gameCallbacks.cpp:6, :11, :16 | the vector arguments | SV3 |

Row V2 stays open in a new form. VM_Create takes `VmSystemCall?`, a C function over the words (`Callbacks.swift:12`), and SV_GameSystemCalls takes a `Slots<Int32>`. No C thunk over SV_GameSystemCalls exists, and the shell does not set `jka_systemCall` of `Sources/CJKAHost/jka_host.c:7`, which VM_DllSyscall calls at :25. Proposal: a thunk in the view target that builds `Slots(syscallWords:count:)` over the words and calls a closure the shell installs over SV_GameSystemCalls, the form of `LoadLibrary` of `VmEntry.swift:48`, and the shell sets `jka_systemCall` to the same thunk. Row G13 waits on the user, and its three holes stay.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | first run exit 1 with one error, "variable 'i' captured by a closure before being initialized" in sv_snapshot.swift. The fix moved the locals that a scratch closure writes into the closure, in SV_BuildClientSnapshot, SV_ClipMoveToEntities, and SV_Trace. Second run exit 0. |
| `swift test --no-parallel -j 2` | exit 0, 150 tests in 9 runs, 0 failures |
