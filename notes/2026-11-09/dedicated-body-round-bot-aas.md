# Dedicated body round: bot-aas

Branch `ded-bodies-bot-aas`, off master at `7961ee4`, in the worktree `/tmp/jka-bot-aas`. The stems are be_aas_reach, be_aas_route, be_aas_sample, be_aas_cluster, be_aas_move, and be_aas_bspq3 of `oracle/codemp/botlib/`, which the stages section of `dedicated-open-rows-ledger-7.md` opened. The round ran no generator, no python tool, no draftcheck, and no snapshot tool.

## Result

The survey found every stem more than half blocked. So the round wrote no body, made no code commit, and ran no build and no test. Each stem keeps its skeleton header, and the next generator run can rewrite it.

| Stem | portMissing before | portMissing after | Signature markers | Blocked without a marker | Free |
|---|---|---|---|---|---|
| be_aas_reach | 53 | 53 | 6 | 42 | 5 |
| be_aas_route | 51 | 51 | 11 | 31 | 9 |
| be_aas_sample | 28 | 28 | 13 | 14 | 1 |
| be_aas_cluster | 22 | 22 | 0 | 21 | 1 |
| be_aas_move | 21 | 21 | 5 | 7 | 9 |
| be_aas_bspq3 | 20 | 20 | 4 | 10 | 6 |

A stub is blocked without a marker when its Raven body reads a global that has a `TODO: Port global` marker, or a record that has no view in the host. The survey read each Raven body from its `Source:` line to its closing brace. A free stub reads none of these. Free stubs also include bodies that call a blocked stub, for example AAS_NearbySolidOrGap calls AAS_PointAreaNum, which reads `aasworld`.

## The rows

### Row A1, `aasworld`

Raven declares `aas_t aasworld` at `oracle/codemp/botlib/be_aas_main.cpp:30`, and `struct aas_s` stands at `oracle/codemp/botlib/be_aas_def.h:183`. The global keeps its marker at `Sources/JKAMP_DedLogic/be_aas_main.swift:9`, with the line "No view for `aas_s` of `be_aas_def.h`". No record of `oracle/codemp/botlib/aasfile.h` has a view either: `aas_bbox_s` at :97, `aas_reachability_s` at :107, `aas_areasettings_s` at :119, `aas_portal_s` at :132, `aas_cluster_s` at :144, `aas_plane_s` at :157, `aas_edge_s` at :165, `aas_face_s` at :174, `aas_area_s` at :188, and `aas_node_s` at :200. The same holds for the records of `be_aas_def.h` that `aas_s` points at: `aas_link_s` at :50, `bsp_link_s` at :59, `aas_entity_s` at :78, `aas_routingcache_s` at :133, `aas_routingupdate_s` at :150, `aas_reversedlink_s` at :163, `aas_reversedreachability_s` at :171, and `aas_reachabilityareas_s` at :178. `Sources/CJKAMP_Ded/include/codemp/` holds no `botlib` folder.

This row blocks 29 stubs of be_aas_reach, 30 of be_aas_route, 12 of be_aas_sample, 21 of be_aas_cluster, and 1 of be_aas_move, and most of the signature markers of row A4.

Pattern: the clip map. The row `"clipMap_t": ("ClipMap", "CJKAMP_Ded")` of `HOST_ROOTS` at `tools/oracle-closure/rulings.py:255`, the rows of the records its fields point at below it, and the storage slot `cmg` at `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift:9` to `:11`. The host parse must reach `be_aas_def.h` and `aasfile.h` for the rows to resolve.

### Row A2, `aassettings`

Raven declares `aas_settings_t aassettings` at `oracle/codemp/botlib/be_aas_move.cpp:29`, and `struct aas_settings_s` stands at `oracle/codemp/botlib/be_aas_def.h:88`. The global keeps its marker at `Sources/JKAMP_DedLogic/be_aas_move.swift:9`, with "No view for `aas_settings_s`". This row blocks 9 stubs of be_aas_reach and 4 of be_aas_move.

Pattern: row A1, a `HOST_ROOTS` row and a storage slot, the `cmg` form.

### Row A3, `bspworld`

Raven defines `struct bsp_s` inside `oracle/codemp/botlib/be_aas_bspq3.cpp:57`, with `bsp_epair_s` at :43 and `bsp_entity_s` at :51, and declares `bsp_t bspworld` at :70. The global keeps its marker at `Sources/JKAMP_DedLogic/be_aas_bspq3.swift:15`, with "No view for `bsp_s`, a struct Raven defines inside a .c file". This row blocks 7 stubs of be_aas_bspq3.

Pattern: a record that Raven defines inside a .cpp file, the `cmd_t` form. `ded_types.h` carries the record into the host target, and the row `"cmd_t": ("Cmd", "CJKAMP_Ded")` of `tools/oracle-closure/rulings.py:222` names it. The row `"worldSector_t"` at :279 is the same form.

### Row A4, the signature markers

39 stubs carry `TODO: Port signature`. Each names a pointer or a value of a record with no table row. The causes:

- A record of row A1: `aas_face_t *`, `aas_plane_t *`, `aas_link_t *`, `aas_reachability_t *`, and `aas_routingcache_t *`. For example `Sources/JKAMP_DedLogic/be_aas_reach.swift:170` for AAS_FaceArea of `be_aas_reach.cpp:95`, and `Sources/JKAMP_DedLogic/be_aas_route.swift:121` for AAS_UnlinkCache.
- A record of a .cpp file: `aas_lreachability_t *` of `oracle/codemp/botlib/be_aas_reach.cpp:70`, at `Sources/JKAMP_DedLogic/be_aas_reach.swift:276` and `:292`. The pattern is row A3.
- A record of `oracle/codemp/game/be_aas.h`: `aas_trace_t` at :68, `bsp_trace_t` at :90, `aas_areainfo_t` at :135, `aas_clientmove_t` at :162, and `aas_predictroute_t` at :196. The game parse places five of them in `Sources/CJKAMP_Game/include/codemp/game/be_aas/`, and the host target cannot import CJKAMP_Game. `bsp_trace_t` has no header in `Sources/`. For example `Sources/JKAMP_DedLogic/be_aas_bspq3.swift:29` for AAS_Trace, and `Sources/JKAMP_DedLogic/be_aas_move.swift:230` for AAS_ClientMovementPrediction. This is the problem of row B1 of `dedicated-open-rows-ledger-7.md`: the proposed form is a copy of the records in `ded_types.h` under `HOST_ROOTS`, the form of row W1.

### Row A5, `botimport`

Raven declares `botlib_import_t botimport` at `oracle/codemp/botlib/be_interface.cpp:42`. The global keeps its marker at `Sources/JKAMP_DedLogic/be_interface.swift:19`. Every call through `botimport.Print`, `botimport.Trace`, `botimport.PointContents`, `botimport.inPVS`, and `botimport.BSPModelMinsMaxsOrigin` waits for it. This row blocks 3 stubs of be_aas_bspq3 by itself, and it is also in many stubs that row A1 blocks. It is row B1 of `dedicated-open-rows-ledger-7.md`, open, with its proposed form there.

### Row A6, the reachability heap

Raven declares `reachabilityheap`, `nextreachability`, and `areareachability` at `oracle/codemp/botlib/be_aas_reach.cpp:83` to `:85`, all of type `aas_lreachability_t`. The first keeps its marker at `Sources/JKAMP_DedLogic/be_aas_reach.swift:142`, with "No table row for `aas_lreachability_t *`". This row blocks 3 stubs of be_aas_reach, AAS_ShutDownReachabilityHeap of :459 among them. Pattern: row A3 for the record, and the FIELDS kind `pointer_table` of `("clipMap_t", "surfaces")` at `tools/oracle-closure/rulings.py:459` for the pointer table.

### Row A7, the signature of AAS_ConnectedAreas

Raven declares `qboolean AAS_ConnectedAreas(int *areanums, int numareas)` at `oracle/codemp/botlib/be_aas_cluster.cpp:706`, and the body passes `areanums` to AAS_ConnectedAreas_r as an array. The stub at `Sources/JKAMP_DedLogic/be_aas_cluster.swift:386` takes `_ areanums: inout Int32`, a single value. Pattern: the `Slots<Int32>` parameter of AAS_ConnectedAreas_r at `Sources/JKAMP_DedLogic/be_aas_cluster.swift:374`.

## The free stubs

These stubs read no blocked global and take no blocked record. Some of them call a blocked stub, for example AAS_Swimming calls AAS_PointContents, which row A5 blocks, and AAS_RocketJumpZVelocity calls AAS_WeaponJumpZVelocity, which row A2 blocks. The round did not write them, because each stem has more than half of its stubs blocked. They can take a body when the coordinator rules it, or when rows A1 to A6 land.

- be_aas_reach: VectorDistance, VectorBetweenVectors, VectorMiddle, AAS_NearbySolidOrGap, and AAS_TravelFlagsForTeam. The last two call stubs of be_aas_sample and be_aas_bspq3 that rows A1 and A3 block.
- be_aas_route: AAS_TravelFlagForType, AAS_RoutingTime, AAS_AreaTravelTime, AAS_InitRouting, AAS_AreaTravelTimeToGoalArea, AAS_AreaReachabilityToGoalArea, AAS_BridgeWalkable, AAS_AreaVisible, and DistancePointToLine. AAS_BridgeWalkable of :1892 and AAS_AreaVisible of :2039 return `qfalse` and nothing else.
- be_aas_sample: AAS_BoxOriginDistanceFromPlane.
- be_aas_cluster: AAS_ConnectedAreas, after row A7.
- be_aas_move: the two tables MOVEDIR_UP and MOVEDIR_DOWN of :214 and :216, AAS_Swimming, AAS_SetMovedir, AAS_RocketJumpZVelocity, AAS_BFGJumpZVelocity, AAS_Accelerate, AAS_AirControl, and AAS_ApplyFriction.
- be_aas_bspq3: AAS_inPHS, AAS_BoxEntities, AAS_VectorForBSPEpairKey, AAS_FloatForBSPEpairKey, AAS_IntForBSPEpairKey, and AAS_BSPTraceLight. AAS_inPHS of :185 returns `qtrue`, and AAS_BoxEntities of :225 and AAS_BSPTraceLight of :433 return 0.

## Gate

The round wrote no Swift, so it ran no build and no test. `swift build` and `swift test` have no counts for this round.
