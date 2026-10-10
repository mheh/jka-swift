# The vmMain dispatch fill

This note records the fill of the `vmMain` dispatch in `Sources/jampgame/jampgame.swift` against Raven's `vmMain` at `oracle/codemp/game/g_main.c:515`. The commit is `1078b3a`. One arm is filled. `GAME_INIT` still prints one line, and 38 arms keep their `portMissing` stubs.

## The reading of the rule

Rule 11 says: "The shell's `vmMain` decodes words into typed arguments and calls the bare function." Rule 4 says: "The entry points in the shell target call the bare functions directly." The shell therefore calls each bare function itself. It does not call the `vmMain` in `Sources/JKAMP_GameLogic/g_main.swift:546` once with the decoded words. That logic `vmMain` takes `Int32` words and holds the decode in the logic target, so it is a draft of Raven's body and not the shell's form.

## The blocker

The shell is a separate module, so it sees only `public` names. Every bare function that the dispatch calls exists in the logic targets, but only two are `public`:

- `BG_GetItemIndexByTag` at `Sources/JKAMP_BG/bg_misc.swift:803`
- `GetIDForString` at `Sources/JKAShared/q_shared.c.swift:11`

All other functions are `internal`. The same is true for `gSharedBuffer` at `Sources/JKAMP_GameLogic/g_main.swift:471`, `g_entities`, and `world`. A fix needs an edit in `Sources/JKAMP_GameLogic/`, and this round must not touch that folder. `@testable import` works only in a build with testing on, so it is not a fix for the product.

## The filled command

- `GAME_GETITEMINDEXBYTAG`: the shell decodes `arg0` and `arg1` to `Int32`, calls `BG_GetItemIndexByTag(tag, type)`, and returns the result as `Int`.

## The commands still stubbed

Each function below exists with the signature shown, and each is `internal`. The shell cannot call it.

| Command | Function | Location | Signature |
| --- | --- | --- | --- |
| `GAME_INIT` (prints) | `G_InitGame` | `g_main.swift:1011` | `(Int32, Int32, Int32)` |
| `GAME_SHUTDOWN` | `G_ShutdownGame` | `g_main.swift:1227` | `(Int32)` |
| `GAME_CLIENT_CONNECT` | `ClientConnect` | `g_client.swift:2140` | `(Int32, Bool, Bool) -> String?` |
| `GAME_CLIENT_THINK` | `ClientThink` | `g_active.swift:3192` | `(Int32, Usercmd?)` |
| `GAME_CLIENT_USERINFO_CHANGED` | `ClientUserinfoChanged` | `g_client.swift:1812` | `(Int32)` |
| `GAME_CLIENT_DISCONNECT` | `ClientDisconnect` | `g_client.swift:3429` | `(Int32)` |
| `GAME_CLIENT_BEGIN` | `ClientBegin` | `g_client.swift:2251` | `(Int32, Bool)` |
| `GAME_CLIENT_COMMAND` | `ClientCommand` | `g_cmds.swift:3056` | `(Int32)` |
| `GAME_RUN_FRAME` | `G_RunFrame` | `g_main.swift:3433` | `(Int32)` |
| `GAME_CONSOLE_COMMAND` | `ConsoleCommand` | `g_svcmds.swift:522` | `() -> Bool` |
| `BOTAI_START_FRAME` | `BotAIStartFrame` | `ai_main.swift:6473` | `(Int32) -> Int32` |
| `GAME_ROFF_NOTETRACK_CALLBACK` | `G_ROFF_NotetrackCallback` | `g_utils.swift:1901` | `(Entity, String)` |
| `GAME_SPAWN_RMG_ENTITY` | `G_ParseSpawnVars`, `G_SpawnGEntityFromSpawnVars` | `g_spawn.swift:483`, `:222` | `(Bool) -> Bool`, `(Bool)` |
| `GAME_ICARUS_PLAYSOUND` | `Q3_PlaySound` | `g_ICARUScb.swift:187` | `(Int32, Int32, String, String) -> Int32` |
| `GAME_ICARUS_SET` | `Q3_Set` | `g_ICARUScb.swift:4635` | `(Int32, Int32, String, String) -> Bool` |
| `GAME_ICARUS_LERP2POS` | `Q3_Lerp2Pos` | `g_ICARUScb.swift:561` | `(Int32, Int32, vec3_t, vec3_t?, Float)` |
| `GAME_ICARUS_LERP2ORIGIN` | `Q3_Lerp2Origin` | `g_ICARUScb.swift:1686` | `(Int32, Int32, vec3_t, Float)` |
| `GAME_ICARUS_LERP2ANGLES` | `Q3_Lerp2Angles` | `g_ICARUScb.swift:665` | `(Int32, Int32, vec3_t, Float)` |
| `GAME_ICARUS_GETTAG` | `Q3_GetTag` | `g_ICARUScb.swift:719` | `(Int32, String, Int32, inout vec3_t) -> Int32` |
| `GAME_ICARUS_LERP2START` | `Q3_Lerp2Start` | `g_ICARUScb.swift:468` | `(Int32, Int32, Float)` |
| `GAME_ICARUS_LERP2END` | `Q3_Lerp2End` | `g_ICARUScb.swift:514` | `(Int32, Int32, Float)` |
| `GAME_ICARUS_USE` | `Q3_Use` | `g_ICARUScb.swift:750` | `(Int32, String)` |
| `GAME_ICARUS_KILL` | `Q3_Kill` | `g_ICARUScb.swift:778` | `(Int32, String)` |
| `GAME_ICARUS_REMOVE` | `Q3_Remove` | `g_ICARUScb.swift:885` | `(Int32, String)` |
| `GAME_ICARUS_PLAY` | `Q3_Play` | `g_ICARUScb.swift:312` | `(Int32, Int32, String, String)` |
| `GAME_ICARUS_GETFLOAT` | `Q3_GetFloat` | `g_ICARUScb.swift:929` | `(Int32, Int32, String, inout Float) -> Int32` |
| `GAME_ICARUS_GETVECTOR` | `Q3_GetVector` | `g_ICARUScb.swift:1268` | `(Int32, Int32, String, inout vec3_t) -> Int32` |
| `GAME_ICARUS_GETSTRING` | `Q3_GetString` | `g_ICARUScb.swift:1320` | `(Int32, Int32, String, inout String) -> Int32` |
| `GAME_ICARUS_SOUNDINDEX` | `G_SoundIndex` | `JKAMP_BG/Generated/bg_callbacks.swift:295` | `(String) -> Int32` |
| `GAME_ICARUS_GETSETIDFORSTRING` | `GetIDForString` (public) | `JKAShared/q_shared.c.swift:11` | `(Slots<StringIDTable>, String) -> Int32` |
| `GAME_NAV_CLEARPATHTOPOINT` | `NAV_ClearPathToPoint` | `g_nav.swift:263` | `(Entity, vec3_t, vec3_t, vec3_t, Int32, Int32) -> Bool` |
| `GAME_NAV_CLEARLOS` | `NPC_ClearLOS2` | `NPC_utils.swift:833` | `(Entity, vec3_t) -> Bool` |
| `GAME_NAV_CLEARPATHBETWEENPOINTS` | `NAVNEW_ClearPathBetweenPoints` | `g_navnew.swift:60` | `(vec3_t, vec3_t, vec3_t, vec3_t, Int32, Int32) -> Int32` |
| `GAME_NAV_CHECKNODEFAILEDFORENT` | `NAV_CheckNodeFailedForEnt` | `g_navnew.swift:8` | `(Entity, Int32) -> Bool` |
| `GAME_NAV_ENTISUNLOCKEDDOOR` | `G_EntIsUnlockedDoor` | `g_mover.swift:1293` | `(Int32) -> Bool` |
| `GAME_NAV_ENTISDOOR` | `G_EntIsDoor` | `g_mover.swift:1247` | `(Int32) -> Bool` |
| `GAME_NAV_ENTISBREAKABLE` | `G_EntIsBreakable` | `g_mover.swift:2650` | `(Int32) -> Bool` |
| `GAME_NAV_ENTISREMOVABLEUSABLE` | `G_EntIsRemovableUsable` | `g_mover.swift:2846` | `(Int32) -> Bool` |
| `GAME_NAV_FINDCOMBATPOINTWAYPOINTS` | `CP_FindCombatPointWaypoints` | `NPC_combat.swift:2178` | `()` |

Paths without a target folder are under `Sources/JKAMP_GameLogic/`. `GAME_ICARUS_GETSETIDFORSTRING` has a second block: `GetIDForString` is public, but its table argument `setTable` is a `TODO: Port global` line with no storage. The ICARUS arms also need `gSharedBuffer`, which is internal. The `Icarus*` views in `Sources/JKAMP_Game/Generated/Views/` are public.

## The TODO lines

The sources hold 22 `// TODO: Port global` lines. None is a one-line forward to a `GameWorld` property, so this round fills none.

These 16 lines name a table that already exists as a public `Slots` in `Sources/JKAMP/BgTables.swift`. Every bg body that reads the name reaches that table, so the TODO line is a stale marker. The bg files are skeleton output that rule 13 marks "Do not edit until adopted", so the lines stay.

- `Sources/JKAMP_BG/bg_vehicleLoad.swift:42` `vehWeaponFields`
- `Sources/JKAMP_BG/bg_vehicleLoad.swift:47` `vehicleFields`
- `Sources/JKAMP_BG/bg_vehicleLoad.swift:52` `VehicleTable`
- `Sources/JKAMP_BG/bg_misc.swift:475` `bg_itemlist`
- `Sources/JKAMP_BG/bg_saber.swift:18` `saberMoveData`
- `Sources/JKAMP_BG/bg_weapons.swift:8` `WP_MuzzlePoint`
- `Sources/JKAMP_BG/bg_weapons.swift:13` `weaponData`
- `Sources/JKAMP_BG/bg_weapons.swift:18` `ammoData`
- `Sources/JKAMP_BG/bg_saberLoad.swift:15` `SaberTable`
- `Sources/JKAMP_BG/bg_saberLoad.swift:20` `SaberMoveTable`
- `Sources/JKAMP_BG/bg_saga.swift:51` `bgSiegeClassFlagNames`
- `Sources/JKAMP_BG/bg_saga.swift:56` `StanceTable`
- `Sources/JKAMP_BG/bg_saga.swift:61` `WPTable`
- `Sources/JKAMP_BG/bg_saga.swift:66` `FPTable`
- `Sources/JKAMP_BG/bg_saga.swift:71` `HoldableTable`
- `Sources/JKAMP_BG/bg_saga.swift:76` `PowerupTable`

These 6 lines name a game table with no storage in any target. Each is in `Sources/JKAMP_GameLogic/`, which this round must not touch.

- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:8` `setTable`
- `Sources/JKAMP_GameLogic/NPC_stats.swift:8` `TeamTable`
- `Sources/JKAMP_GameLogic/NPC_stats.swift:13` `ClassTable`
- `Sources/JKAMP_GameLogic/NPC_stats.swift:18` `BSTable`
- `Sources/JKAMP_GameLogic/NPC_stats.swift:23` `BSETTable`
- `Sources/JKAMP_GameLogic/g_spawn.swift:8` `fields`

## The gate

`swift build` completed with 0 errors. `swift test --no-parallel` ran 106 tests in four binaries, 1, 78, 13, and 14, and all passed.

`swift run jampsmoke .build/debug/libjampgame.dylib` wrote this output:

```
answer 0
command 0
text jka-swift jampgame init\n
```

`GAME_INIT` returns 0 and sends one print syscall with the init line. The smoke run does not reach `G_InitGame`.

## Docket rows

1. The access level of the shell's callees. The shell needs about 40 bare functions, `gSharedBuffer`, and `g_entities` from `JKAMP_GameLogic` and `JKAMP_BG`, and they are all `internal`. The choices are these: mark each callee `public` in its logic file, or add one public entry file in the logic target that the shell calls, or give the logic `vmMain` public access and let the shell forward to it. Rule 11 points to the first choice. The proposed default is the first choice, made after the agent that edits `g_main.swift` stops.
2. The storage of `setTable`, `TeamTable`, `ClassTable`, `BSTable`, `BSETTable`, and `fields`. These six game tables have no `Slots` in a C target. `GAME_ICARUS_GETSETIDFORSTRING` needs `setTable`. The proposed default is the `BgTables.swift` shape in the game view target.
3. The 16 stale bg TODO lines. Their tables exist in `Sources/JKAMP/BgTables.swift`. The proposed default is to remove the lines when the bg files are adopted.
