# Holes of the Slots over the game tables, class F4

| File | Function | Table | Verdict | Note |
|---|---|---|---|---|
| g_ICARUScb.swift | Q3_GetFloat | setTable | filled | `toGet = GetIDForString(setTable, name)`, Raven's FIXME comment kept. |
| g_ICARUScb.swift | Q3_GetVector | setTable | filled | `toGet = GetIDForString(setTable, name)`, Raven's FIXME comment kept. |
| g_ICARUScb.swift | Q3_GetString | setTable | filled | `toGet = GetIDForString(setTable, name)`, Raven's FIXME comment kept. |
| g_ICARUScb.swift | Q3_SetBState | BSTable | filled | `bSID = bState_t(GetIDForString(BSTable, bs_name))`, Raven's cast kept. |
| g_ICARUScb.swift | Q3_SetTempBState | BSTable | filled | `bSID = bState_t(GetIDForString(BSTable, bs_name))`, Raven's cast kept. |
| g_ICARUScb.swift | Q3_SetDefaultBState | BSTable | filled | `bSID = bState_t(GetIDForString(BSTable, bs_name))`, Raven's cast kept. |
| g_ICARUScb.swift | Q3_Set | setTable | filled | `toSet = GetIDForString(setTable, type_name)`. |
| NPC_stats.swift | NPC_Precache | TeamTable | filled | `playerTeam = team_t(GetIDForString(TeamTable, String(tk)))`. The `char tk[4096]` local is a `CharBuf`, and `String(tk)` reads it. |
| NPC_stats.swift | NPC_ParseParms | TeamTable | filled | Raven's compound store lifts the inner store first: `NPC.s.teamowner = team_t(...)`, then `NPC.client!.playerTeam = NPC.s.teamowner`. Raven's `//TranslateTeamName(value);` comment kept. |
| NPC_stats.swift | NPC_ParseParms | TeamTable | filled | `NPC.client!.enemyTeam = team_t(GetIDForString(TeamTable, String(tk)))`, Raven's comment kept. |
| NPC_stats.swift | NPC_ParseParms | ClassTable | filled | `NPC.client!.NPC_class = class_t(GetIDForString(ClassTable, value))`. |
| NPC_utils.swift | G_ActivateBehavior | BSTable | left | The argument `bs_name` has no Swift local. Its declaration, its store, and its `VALIDSTRING` test are three other holes above it. |
| NPC_utils.swift | G_ActivateBehavior | BSETTable | left | The same `G_DebugPrint` reads `bs_name`, which has no Swift local. The `GetStringForID` part alone can fill as `GetStringForID(BSETTable, bset)`. |
| NPC_spawn.swift | NPC_Kill_f | TeamTable | filled | `killTeam = team_t(GetIDForString(TeamTable, String(name)))`. The `char name[1024]` local is a `CharBuf`. |

The note at `NPC_stats.swift` in `NPC_ParseParms` that names `WP_RemoveSaber` uses the same text, but it is outside class F4, and it stays.

## Docket rows

- G_ActivateBehavior: the two table holes wait for the `char *bs_name` local, which has no form yet. A ruling on that local, likely a `String?` from `self.behaviorSet[bset]`, closes the two holes here and the three holes above them.
