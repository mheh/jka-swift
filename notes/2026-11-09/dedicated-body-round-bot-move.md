# Dedicated body round: bot-move

Branch `ded-bodies-bot-move`, off master at `7961ee4`, in the worktree `/tmp/jka-bot-move`. The stems are be_ai_move and be_ai_goal of `oracle/codemp/botlib/`. The round ran no generator, no draftcheck, and no snapshot tool.

## Result

The survey found both stems blocked. More than half of the stubs of each stem carry a `TODO: Port signature` marker or need a record that has no view. So the round wrote no body and ran no build. Both files keep the skeleton header, because no hand edit touched them.

| File | portMissing before | portMissing after | Signature markers | Blocked by a missing view or global |
|---|---|---|---|---|
| be_ai_move.swift | 67 | 67 | 47 | 14 of the 20 unmarked |
| be_ai_goal.swift | 43 | 43 | 18 | 25 of the 25 unmarked |

## The survey of be_ai_move

The 47 marked stubs take a `bot_movestate_t *`, an `aas_reachability_t *`, a `bot_goal_t *`, a `bot_moveresult_t *`, or a `bot_initmove_t *`, or return one of them. The table has no row for any of these records.

The 20 unmarked stubs fall into three groups.

- Blocked by the move state, 8 stubs. BotAllocMoveState, BotFreeMoveState, and BotShutdownMoveAI read `botmovestates` of `be_ai_move.cpp:102`, which has no Swift global, `be_ai_move.swift:95`. BotAddAvoidSpot, BotMoveInDirection, BotResetAvoidReach, BotResetLastAvoidReach, and BotResetMoveState call BotMoveStateFromHandle, which is a marked stub, `be_ai_move.swift:133`.
- Blocked by a callee or a global, 6 stubs. BotAirControl reads `sv_gravity->value`, and BotSetupMoveAI sets the ten `libvar_t *` globals of `be_ai_move.cpp:60` to `:69`, which have no Swift global, `be_ai_move.swift:39` to `:86`. BotSetupMoveAI also calls LibVar, a marked stub at `l_libvar.swift:116`. BotVisible calls AAS_Trace, a marked stub at `be_aas_bspq3.swift:30`. BotGapDistance calls AAS_TraceClientBBox, a marked stub at `be_aas_sample.swift:223`. BotReachabilityArea calls AAS_Trace and AAS_ReachabilityFromNum, a marked stub at `be_aas_route.swift:687`, and declares an `aas_reachability_t` local. BotFuzzyPointReachabilityArea hands `points[10]` to AAS_TraceAreas, whose Swift signature takes one `inout vec3_t`, row BM4.
- Free, 6 stubs. AngleDiff, DistanceFromLineSquared, VectorDistanceSquared, BotAddToTarget, Intersection, and BotSetBrushModelTypes need only signatures that exist. The round left them as stubs because the stem is over the threshold. The next round of the stem can fill them first.

## The survey of be_ai_goal

The 18 marked stubs take or return a `bot_goalstate_t *`, a `levelitem_t *`, an `itemconfig_t *`, a `weightconfig_t *`, or a `bot_goal_t *`.

All 25 unmarked stubs read a global that has no Swift form. 18 call BotGoalStateFromHandle, a marked stub at `be_ai_goal.swift:110`, or read `botgoalstates` of `be_ai_goal.cpp:163`, `be_ai_goal.swift:46`. BotSaveGoalFuzzyLogic is one of them. Raven comments out the write at `be_ai_goal.cpp:229`, but the call to BotGoalStateFromHandle stays and prints on a bad handle. BotShutdownGoalAI is one of them too, and it also reads `itemconfig`. The other 7 read `levelitemheap`, `freelevelitems`, `levelitems`, `itemconfig`, `maplocations`, `campspots`, or `droppedweight`, `be_ai_goal.cpp:165` to `:178`, `be_ai_goal.swift:51` to `:95`. These are InitLevelItemHeap, BotFreeInfoEntities, BotInitInfoEntities, BotInitLevelItems, BotGoalName, BotUpdateEntityItems, and BotSetupGoalAI. BotSetupGoalAI also calls LoadItemConfig, a marked stub at `be_ai_goal.swift:161`.

## Rows

### Row BM1, the botlib-private records

Question: the move and goal stems need views of the records that Raven defines inside the botlib .cpp files. These are `bot_movestate_t` of `be_ai_move.cpp:42`, `bot_goalstate_t` of `be_ai_goal.cpp:148`, `levelitem_t` of `:93`, `iteminfo_t` of `:107`, `itemconfig_t` of `:141`, `maplocation_t` of `:53`, and `campspot_t` of `:62`. No Swift view exists for them, and HOST_ROOTS of `rulings.py:199` has no row.

Proposed form: the form of `cmd_t` and of row W1 of the seventh ledger. Each record joins `ded_types.h` with Raven's text, and gets a HOST_ROOTS row with its view name and the target `CJKAMP_Ded`.

### Row BM2, the records of the botlib headers

Question: `aas_reachability_t` of `aasfile.h:107` and `libvar_t` of `l_libvar.h:16` have no view. 32 signatures of be_ai_move take an `aas_reachability_t`, and the ten `libvar_t *` globals of `be_ai_move.cpp:60` to `:69` wait on them, with `droppedweight` of `be_ai_goal.cpp:178`.

Proposed form: a HOST_ROOTS row for each, the form of `bot_debugpoly_t` and of the clip map records in `rulings.py`. A `libvar_t *` global then takes the form of a `cvar_t *` global, `var sv_fps: JKAMP.Cvar?` at `sv_main.swift:19`.

### Row BM3, the records of the game headers

Question: `bot_goal_t` of `game/be_ai_goal.h:25`, `bot_initmove_t` of `game/be_ai_move.h:60`, `bot_moveresult_t` of `:74`, and `bot_avoidspot_t` of `:89` are headers of the game parse. `CJKAMP_Game.h:76` and `:79` include them in CJKAMP_Game, which the host cannot import. `CJKAMP_forward.h:38` to `:42` gives only the forward names.

Proposed form: the form row B1 of the seventh ledger proposes for `botlib_export_t` and `botlib_import_t`, a copy in `ded_types.h` under HOST_ROOTS. Row B1 waits on the user, so this row takes its ruling.

### Row BM4, the `vec3_t *` list of AAS_TraceAreas

Question: Raven's `int AAS_TraceAreas(vec3_t start, vec3_t end, int *areas, vec3_t *points, int maxareas)` of `be_aas_sample.h:41` takes a list of points. The Swift signature at `be_aas_sample.swift:236` reads `points` as one `inout JKAShared.vec3_t`. BotFuzzyPointReachabilityArea at `be_ai_move.cpp:224` hands `vec3_t points[10]`.

Proposed form: the PARAMS kind `table` on a `vec3_t *`, which gives `Slots<vec3_t>`, rows G8 and B4 of the seventh ledger. The locals `areas` and `points` of BotFuzzyPointReachabilityArea join BYTE_STORAGE_LOCALS, the form of rows G6, W2, and T4.

### Row BM5, the handle tables

Question: `botmovestates` of `be_ai_move.cpp:102` and `botgoalstates` of `be_ai_goal.cpp:163` are `[MAX_CLIENTS + 1]` arrays of record pointers.

Proposed form: no new rule. After row BM1 gives the views, the `pointer_table` kind of `skeleton.py:723` gives each global as a `Slots<View?>`, the form of `cg_solidEntities` at `cg_predict.swift:17`. The marked handle functions, BotMoveStateFromHandle and BotGoalStateFromHandle, then return the optional view.

## Gate

No build and no test ran, by the brief's rule for a round where every stem is blocked.
