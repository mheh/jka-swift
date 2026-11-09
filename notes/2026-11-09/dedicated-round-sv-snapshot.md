# The snapshot, world, and bot round, sv_snapshot, sv_world, and sv_bot

This record holds the round of three server stems of unit mp-engine-ded: `Sources/JKAMP_DedLogic/sv_snapshot.swift`, `sv_world.swift`, and `sv_bot.swift`. The tree is the worktree `/tmp/jka-ded-svsnap` on the branch `dedicated-round-sv-snapshot`, off master at 1cdd22f, with master at 5c71cb9 merged in after PR 77 landed the server core round. The code commit is 40522b0. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The three stubs had the skeleton header. A first draftcheck run over the three stems gave 146 holes, 31 of them compile holes, and `adopt.py` spliced the drafts over the stubs and removed the header. The hole round then filled every hole that a ruled form, an adopted stem, or a hand accessor of this round covers.

- sv_snapshot, 7 of 11 functions whole: SV_EmitPacketEntities, SV_WriteSnapshotToClient (but for the NULL `oldframe`), SV_UpdateServerCommandsToClient, SV_RateMsec, SV_SendMessageToClient, SV_SendClientMessages, and the body of SV_SendClientSnapshot after its two MSG_Init holes. `c++` over a `Slots<Client>` is `c = c.suffix(from: 1)` and a pass of the record is `c[0]`, the form of sv_main. `frame->ps = *ps` is the store `frame!.ps = ps!` through the view setter. Com_Memset of `frame->areabits` is `zero()`, and `((int *)frame->areabits)[i]` is the word subscript `frame!.areabits[int: i * Int32(Int32.byteCount)]`. The loop over `fs_gamedirvar->string[i]` binds the field into a `CharBuf` and reads its bytes.
- sv_world, 9 of 13 functions whole or Raven's form up to a row: SV_ClipHandleForEntity, SV_SectorList_f, SV_ClearWorld, SV_UnlinkEntity, SV_LinkEntity, SV_ClipToEntity, VectorDistance, SV_PointContents, and SV_Trace up to its `moveclip_t` local. The `float *origin` and `float *angles` locals that only read a vector hold a copy of it under one rule 24 line, the form of `hudTintColor` in `cg_local.swift`. The drafted `mins! = vec3_origin` of SV_Trace now reads `mins = vec3_origin`.
- sv_bot, 21 of 34 functions whole: every function with no botlib, debug polygon, or waypoint table read, among them SV_BotAllocateClient, SV_BotFreeClient, SV_BotFrame, SV_BotInitCvars, SV_BotGetConsoleMessage, SV_BotGetSnapshotEntity, and the BotImport functions of the clip map. `!cl->reliableCommands[index][0]` reads `cl!.reliableCommands[index].isEmpty`. The four static `cvar_t *` locals of BotDrawDebugPolygons are properties of `EngineWorld` under a `sv_bot.cpp` MARK, each with a forward in the stem, the form of the static locals of sv_main.

## The hand pieces

`Sources/JKAMP_Ded/SnapshotViews.swift` is a new file of the view target. Each piece carries one `// AI:` line.

| Piece | Raven's counterpart | Use |
|---|---|---|
| `WorldSector`, a view with `axis`, `dist`, `children`, and `entities` | `worldSector_t` at sv_world.cpp:48 | SV_SectorList_f, SV_UnlinkEntity, SV_LinkEntity |
| `WorldSector.table(count:)` | `worldSector_t sv_worldSectors[AREA_NODES]` at sv_world.cpp:58 | `EngineWorld.sv_worldSectors` and its forward in sv_world.swift |
| `SvEntity.worldSectorNode` | `ent->worldSector` at server.h:28 as a `worldSector_t *` | SV_UnlinkEntity and SV_LinkEntity |

The view reads Raven's layout by offset and binds no C record. A first try put Raven's text of `worldSector_t` in `ded_types.h`, and the build failed, because a complete `struct worldSector_s` turns the generated `SvEntity.worldSector` from `OpaquePointer?` into a typed pointer. The four fields have no padding on any ABI: two 4-byte fields, then three pointers at offset 8. The table is never freed, because `EngineWorld` has no hand deinit for it.

## The rule 24 sites

- `sv_worldSectors` (sv_world.cpp:58): a forward to the hand allocation of the world.
- SV_ClipToEntity (sv_world.cpp:473) and SV_PointContents (:877): the `float *` locals over a vector are vector copies.

## Rows for the user

- Row W1, the records of sv_world.cpp. Question: `worldSector_t` (sv_world.cpp:48), `areaParms_t` (:359), and `moveclip_t` (:440) are records of a `.cpp` file, so the table has no row for SV_CreateworldSector (`worldSector_t *` return), SV_AreaEntities_r (`worldSector_t *node`, `areaParms_t *ap`), SV_ClipMoveToEntities (`moveclip_t *clip`), or the locals `ap` of SV_AreaEntities and `clip` of SV_Trace. Callers: SV_ClearWorld, SV_AreaEntities, SV_Trace, and through them every game trace and link. Proposal: the three records join `ded_types.h` and `HOST_ROOTS`, the form of `bitStorage_t` (ledger 1 row 14) and of the zone records (ledger 5 row Z1), and `sv_worldSectors` becomes an `EngineStorage` table. The same generator run rewrites `SvEntity.worldSector` as a `WorldSector?`, and `SnapshotViews.swift` and `EngineWorld.sv_worldSectors` go away in that commit. `areaParms_t.list` and `moveclip_t.mins` and `.maxs` need FIELDS rows, `int_array` or `bytes` for `list` and `vec3` for the two `const float *`.
- Row W2, `int *` with a count beside it. Question: SV_AreaEntities takes `int *entityList` and CM_BoxLeafnums of cm_test takes `int *boxList`, each as one `inout Int32`, and every caller hands an array to fill: `touch` of SV_PointContents (sv_world.cpp:883) and `leafs` of SV_LinkEntity (:280). Callers: SV_PointContents, SV_LinkEntity, and SV_GameSystemCalls. Proposal: the trap rule of `docs/transcription.md`, an `inout [Int32]` the callee fills, as a PARAMS row of the two parameters.
- Row N1, the NULL `from` of SV_EmitPacketEntities. Question: SV_WriteSnapshotToClient passes `oldframe` NULL on a retransmit or a first snapshot (sv_snapshot.cpp:115, :121, :131), and the stub takes `from` as `ClientSnapshot`. Raven tests `if ( !from )` at :43. Proposal: a NULLABLE row, the form of Cvar_Register (ledger 2 row 5), so the body keeps Raven's test and the caller passes `oldframe`. Until then the call site holds a hole for the NULL case.
- Row N2, `snapshotEntityNumbers_t`. Question: the record at sv_snapshot.cpp:246 is local to the file, so SV_AddEntToSnapshot and SV_AddEntitiesVisibleFromPoint carry signature markers and the local `entityNumbers` of SV_BuildClientSnapshot has no type. Caller: SV_BuildClientSnapshot alone, through SV_SendClientSnapshot. Proposal: the record joins `ded_types.h` and `HOST_ROOTS` as in row W1, and the local is a `scratch` record, so `eNums->snapshotEntities` is a `Slots<Int32>` field.
- Row N3, the entity sort. Question: `qsort( entityNumbers.snapshotEntities, ..., SV_QsortEntityNumbers )` (sv_snapshot.cpp:588). The host has no qsort, and the comparator takes `const void *` as `OpaquePointer?`. The game precedent is `qsort(_ a: Slots<Int32>, _ n: Int32, _ cmp: (Int32, Int32) -> Int32)` of `Sources/JKAMP_BG/bg_lib.swift:61` with PARAMS `int_value` for `SortRanks` and `SortClients` (`tools/oracle-closure/rulings.py:565-571`), and the host does not link JKAMP_BG. Proposal: PARAMS `int_value` for `a` and `b` of SV_QsortEntityNumbers, and the host reaches the same Bentley and McIlroy qsort over a `Slots<Int32>`. The entity numbers are distinct, so the tie order of the sort cannot change the output.
- Row N4, `msg_buf` of SV_SendClientSnapshot. Question: `byte msg_buf[MAX_MSGLEN]` (sv_snapshot.cpp:720) has no `Slots<byte>` for MSG_Init. Proposal: a BYTE_STORAGE_LOCALS key `("msg_buf", "SV_SendClientSnapshot")`, the form of `send_buf_Netchan_Transmit` (ledger 4 row 2). SV_SendClientGameState of sv_client has the same local.
- Row N5, the vehicle playerstate. Question: `VM_ArgPtr((int)veh->playerState)` (sv_snapshot.cpp:555) needs VM_ArgPtr, whose stub carries a marker for its `void *` return. Proposal: the row S3 form of the server core round, a RETURNS kind for the record the game hands back, here a `PlayerState` view.
- Row B1, the botlib edge. Question: the host has no form for `botlib_export_t *botlib_export` (a TODO global of sv_game.swift), for the `botlib_import_t` table, for `GetBotLibAPI`, or for the `PRT_` print types of botlib.h. Row E5 of `notes/2026-11-03/dedicated-opening-docket.md` makes the botlib a later stage. The round leaves 30 B1 holes: 24 in SV_BotInitBotLib (the local, 22 stores, and the GetBotLibAPI call), 2 in SV_BotLibSetup, 2 in SV_BotLibShutdown, 1 in BotImport_Print, and 1 in BotDrawDebugPolygons. BotImport_Trace and BotImport_EntityTrace also carry markers for `bsp_trace_t *`. Proposal: the botlib stage of row E5 decides the form. Until then SV_Init stops at the first line of SV_BotInitBotLib (sv_init.cpp:878).
- Row B2, `gWPArray`. Question: `static wpobject_t *gWPArray[MAX_WPARRAY_SIZE]` (sv_bot.cpp:23) has no table row, and SV_BotWaypointReception carries a marker for `wpobject_t **wps`. Proposal: one zeroed `Slots<Wpobject?>` on `EngineStorage`, the form of the game's `gWPArray` in `docs/transcription.md`, and PARAMS `pointer_array` for `wps`.
- Row B3, the debug polygons. Question: `static bot_debugpoly_t *debugpolygons` (sv_bot.cpp:16) and the record `bot_debugpoly_t` (:8) have no view, so 24 holes stand in BotDrawDebugPolygons, SV_BotInitBotLib, and the three BotImport_DebugPolygon functions. Proposal: the record joins `ded_types.h` and `HOST_ROOTS`, and the variable takes the cast form of a view over the `Z_Malloc` block, `Slots` of the record with Raven's count, as SV_ChangeMaxClients does for `svs.clients`.
- Row B4, `vec3_t *points`. Question: BotImport_DebugPolygonCreate and BotImport_DebugPolygonShow take `vec3_t *points` with `numPoints` beside it as one `inout vec3_t`, and BotImport_DebugLineCreate and BotImport_DebugLineShow hand them an array (sv_bot.cpp:527, :569). Proposal: `[vec3_t]` by value, the trap row of a `vec3_t *` with a count.
- Row B5, the `void *` returns of sv_bot. Question: Bot_GetMemoryGame, BotImport_GetMemory, and BotImport_HunkAlloc return a `Z_Malloc` or `Hunk_Alloc` block and carry markers. Proposal: RETURNS `raw`, the row Z3 form of S_Malloc. Their callers are the botlib and the game syscalls.

## The open holes

| File | `portMissing` lines | Signature markers among them | Rows |
|---|---|---|---|
| sv_snapshot.swift | 17 | 2 | N1 1, N2 5, N3 7, N4 2, N5 1 |
| sv_world.swift | 34 | 3 | W1 29, W2 3, one of them under both |
| sv_bot.swift | 64 | 6 | B1 30, B2 2, B3 24, B4 2 |

`grep Unsafe` gives 0 in the three stems.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The round files give "will never be executed" warnings after the holes, 30 unused results of Cvar_Get, VM_Call, and VectorNormalize, and warnings on locals that a hole leaves unread. |
| `swift test --no-parallel -j 2` | exit 0, 143 tests in 20 suites, all pass, 0 skipped |
| `draftcheck.py --unit mp-engine-ded --stem sv_snapshot` | exit 0, 5 of 11 hand functions replaced, 6 kept, 22 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_world` | exit 0, 5 of 13 hand functions replaced, 8 kept, 45 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_bot` | exit 0, 21 of 34 hand functions replaced, 13 kept, 47 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The draftcheck holes are in the drafter's output, not in the working tree. A "replaced" function is one whose hand body is still the draft, so the splice changes no text.
