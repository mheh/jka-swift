# Hole round of g_main.swift and g_active.swift

## g_main.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| vmMain | The draft of `return (int)ClientConnect( arg0, arg1, arg2 )` did not compile. | stands | Goes under F5. |
| vmMain | The draft of `G_ROFF_NotetrackCallback( &g_entities[arg0], (const char *)arg1 )` did not compile. | stands | Goes under F5. |
| vmMain | A pointer local `char * crap` with no view. | stands | Goes under F5. |
| vmMain | A pointer local `char ** morecrap` with no view. | stands | Goes under F5. |
| vmMain | A read of `morecrap`. | stands | Goes under F5. |
| vmMain | A read of `crap`. | stands | Goes under F5. |
| vmMain | `GetIDForString(setTable, ...)` needs a Slots over one record. | stands | Goes under F5. |
| vmMain | A cast to `float *` in `NAV_ClearPathToPoint`. | stands | Goes under F5. |
| vmMain | A cast to `const float *` in `NPC_ClearLOS2`. | stands | Goes under F5. |
| vmMain | A cast to `float *` in `NAVNEW_ClearPathBetweenPoints`. | stands | Goes under F5. |
| SortRanks | `ca = &level.clients[*(int *)a]`, a read through a `void *` comparator argument. | stands | No form reads an `int` through an `OpaquePointer?` in a logic target. See docket row 1. |
| SortRanks | `cb = &level.clients[*(int *)b]`, the same read. | stands | See docket row 1. |
| CalculateRanks | `qsort( level.sortedClients, ..., SortRanks )` did not compile, because a Swift function is not a C comparator. | stands | No form for `qsort`. See docket row 1. |
| FindIntermissionPoint | `gSiegeRoundWinningTeam == SIEGETEAM_TEAM1`: Raven's extern at g_main.c:1978 declares the variable `qboolean`, and he compares it with a team number. | stands | No form compares a `Bool` with an `Int32`. See docket row 2. |
| CheckVote | `va("map %s\n", nextMap )` did not compile. | filled | The local is `String?` from `G_RefreshNextMap`, so the read under Raven's NULL test is `nextMap!`. |

## g_active.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_TouchTriggers | `hit->touch != Touch_DoorTrigger` compares a callback field with one function. | stands | The guide gives only the NULL test on a callback field. See docket row 3. |
| SpectatorThink | `pm.trace = trap_Trace`, a callback store. | blocked | The callback-store form takes the thunk in `Callbacks.swift`, and that file is outside the read set. The thunk name for `trap_Trace` as a `PmoveTrace` is the missing fact. |
| SpectatorThink | `pm.pointcontents = trap_PointContents`, a callback store. | blocked | The same fact for `trap_PointContents` as a `PmovePointcontents`. |
| SpectatorThink | `pm.baseEnt = (bgEntity_t *)g_entities`, a cast of the table base. | stands | See docket row 4. |
| SpectatorThink | `pm.entSize = sizeof(gentity_t)`. | stands | See docket row 5. |
| ClientThink_real | `pm.trace = trap_Trace`. | blocked | As in SpectatorThink. |
| ClientThink_real | `pm.pointcontents = trap_PointContents`. | blocked | As in SpectatorThink. |
| ClientThink_real | `pm.pmove_fixed = pmove_fixed.integer \| client->pers.pmoveFixed`, an `int` OR a `qboolean`. | stands | `pmoveFixed` is `Bool`, and no form puts a `Bool` into integer arithmetic. See docket row 6. |
| ClientThink_real | `pm.baseEnt = (bgEntity_t *)g_entities`. | stands | See docket row 4. |
| ClientThink_real | `pm.entSize = sizeof(gentity_t)`. | stands | See docket row 5. |

## GameWorld properties

None. No hole of this round is a static local or a file-scope static.

## Docket rows

1. SortRanks and the `qsort` of CalculateRanks. Raven's comparator reads an `int` through each `void *` argument, and the guide has no form for `qsort` or for a read through an `OpaquePointer?`. Proposed form: a `qsort` helper over a `Slots<Int32>` and a count, whose comparator takes the two `Int32` values, so `*(int *)a` is the parameter itself. The helper must sort in the same order as the oracle's libc `qsort` for equal keys.
2. `gSiegeRoundWinningTeam` in FindIntermissionPoint. Raven's extern declares it `qboolean`, and he stores and compares a team number in it. Proposed form: a TYPES ruling makes this variable `Int32`, so the comparison reads as Raven wrote it.
3. `hit->touch != Touch_DoorTrigger` in G_TouchTriggers. A C function pointer type is not `Equatable` in Swift. Proposed form: the view target generates an identity test per callback field, `hit!.touchIs(Touch.Touch_DoorTrigger)`, which compares the two addresses inside the view target.
4. `pm.baseEnt = (bgEntity_t *)g_entities` in SpectatorThink and ClientThink_real. The cast is of a table base, and the view cast form takes one view, not a `Slots`. Proposed form: Raven's cast of a table name is the view over the first slot, `pm.baseEnt = BgEntity(g_entities[0])`.
5. `pm.entSize = sizeof(gentity_t)` in SpectatorThink and ClientThink_real. `Entity.byteCount` is an `Int`, and the field is `Int32`, so the store needs a cast Raven did not write. Proposed form: each view carries an `Int32` size constant for Raven's `sizeof` of the type, or the guide rules that `sizeof(T)` into an `int` is `Int32(View.byteCount)`.
6. `pm.pmove_fixed = pmove_fixed.integer | client->pers.pmoveFixed` in ClientThink_real. A `qboolean` is `Bool`, and C reads it as 0 or 1 in integer arithmetic. Proposed form: a `qboolean` operand of an integer operator is `(b ? 1 : 0)`, the spelling `vmMain` already uses for a `qboolean` return.
