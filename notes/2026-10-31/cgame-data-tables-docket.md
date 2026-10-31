# The cgame data tables docket

The 30 hand data tables of the cgame, the first stage 4 row after the defects by row V2 of `cgame-stage-4-opening.md`. Every row below is read at the cited line in Raven's tree and in the Swift tree. The walk rules on the five groups, not on the 30 tables one by one.

## Where the 30 live

The list is the 30 `TODO: Port` placeholders under `MARK: - Raven's data tables` at `Sources/JKAMP_CGameLogic/cg_local.swift:16-189`. Each one is a `lazy var` whose first read traps through `portMissing` with the subject. No note holds the list, only the count.

## The tables

All C paths are under `oracle/codemp/cgame/`. "Written" means Raven stores into the table at runtime, with the site.

| # | Raven | Element | Count | Written |
|---|---|---|---|---|
| 1 | `cg_consolecmds.c:265` `static consoleCommand_t commands[]` | name and function pointer | open | no |
| 2-5 | `cg_draw.c:43,51,59,67` `const char *armorTicName[MAX_HUD_TICS]` and health, force, ammo | `const char *` | 4 | no |
| 6 | `cg_draw.c:75` `char *showPowersName[]` | `char *` | open | no |
| 7 | `cg_draw.c:4847` `vec3_t cg_crosshairPos={0,0,0}` | `vec3_t` | 1 | `cg_draw.c:4864` |
| 8 | `cg_draw.c:5326` `vec3_t cg_saberFlashPos = {0, 0, 0}` | `vec3_t` | 1 | extern in `cg_event.c:21` |
| 9 | `cg_ents.c:632` `char *forceHolocronModels[]` | `char *` | open | no |
| 10 | `cg_event.c:1429` `const char *cg_stringEdVoiceChatTable[MAX_CUSTOM_SIEGE_SOUNDS]` | `const char *` | macro | no |
| 11 | `cg_main.c:27` `vec4_t colorTable[CT_MAX]` | `vec4_t` | `CT_MAX` | no |
| 12 | `cg_main.c:882` `static cvarTable_t cvarTable[]` | `cvarTable_t`, four fields at `:875-880` | open | no |
| 13 | `cg_marks.c:363` `static char *shaderAnimNames[MAX_SHADER_ANIMS]` | `char *` | 32 | no |
| 14 | `cg_players.c:25` `char *cg_customSoundNames[MAX_CUSTOM_SOUNDS]` | `char *` | macro | no |
| 15-18 | `cg_players.c:47,71,114,142` `const char *cg_customCombatSoundNames[]` and extra, jedi, duel | `const char *` | macro | no |
| 19 | `cg_players.c:3440` `static const char *cg_effectorStringTable[]` | `const char *` | open | no |
| 20 | `cg_players.c:4945` `static const char *cg_pushBoneNames[]` | `const char *` | open | no |
| 21 | `cg_players.c:7978` `static int lastFlyBySound[MAX_GENTITIES] = {0}` | `int` | `MAX_GENTITIES` | `cg_players.c:8043` |
| 22-23 | `cg_view.c:221,222` `static vec3_t cameramins`, `cameramaxs` over `CAMERA_SIZE` | `vec3_t` | 1 | no |
| 24-25 | `cg_view.c:227` `vec3_t cameraCurTarget`, `cameraCurLoc` | `vec3_t` | 1 | `cg_view.c:390,391` |
| 26 | `cg_view.c:1476` `vec3_t cg_lastTurretViewAngles={0}` | `vec3_t` | 1 | `cg_view.c:1646` |
| 27 | `cg_view.c:2279` `vec3_t cg_autoMapAngle = {90.0f, 0.0f, 0.0f}` | `vec3_t` | 1 | `cg_main.c:329` |
| 28-29 | `fx_bryarpistol.c:219,220` `static vec3_t WHITE`, `BRIGHT` | `vec3_t` | 1 | no |
| 30 | `fx_disruptor.c:11` `static vec3_t WHITE` | `vec3_t` | 1 | no |

"No" in the written column comes from a grep for stores and `Vector*` writes on the name. The transcriptor of each stem confirms it at the body.

## The game precedents

- A table of function pointers is hand data on `GameWorld`: `spawns: [SpawnRow]` at `Sources/JKAMP_GameLogic/g_local.swift:353`, with the reason at `:786`, "C storage cannot hold the address of a Swift function". The cgame stub already holds `ConsoleCommandRow` at `cg_local.swift:194-197`.
- The cvar table is `gameCvarTable: [CvarTableRow]` at `g_local.swift:555`, a key path into the storage per row. The cgame stub holds `CvarTableRow` with four fields at `cg_local.swift:201-206`, which matches Raven's cgame `cvarTable_t` at `cg_main.c:875-880`.
- A string table is a plain `[String]` with Raven's literals: `TeamNames` at `g_local.swift:40`. A table with NULL entries is `[String?]`: `modNames` at `:142`.
- A `vec3_t` global is a stored `var`: `shieldMins` at `g_local.swift:30` with an initializer, `saberClashPos` at `:702` zeroed. Duplicate statics take the file prefix, `g_client_playerMins` at `:726` and `g_utils_playerMins` at `:734`.
- `tables.py` writes only `bg_tables.c` and `g_tables.c` (`tools/oracle-closure/tables.py:127-129`). No cgame table needs the C storage shape, because none crosses the ABI.

## The macros the tables need

`MAX_HUD_TICS`, `MAX_SHADER_ANIMS`, and `CAMERA_SIZE` are macros inside `.c` files, and the stubs already carry them as file-scope lets at `cg_draw.swift:64`, `cg_marks.swift:50`, and `cg_view.swift:13`, by the "A macro inside a `.c` file" section of `docs/transcription.md`. `CT_MAX` is re-exported in `Sources/JKAMP/Generated/q_shared.swift`, `MAX_CUSTOM_SOUNDS` in `Sources/JKAMP_CGame/Generated/cg_local.swift`, and `MAX_CUSTOM_SIEGE_SOUNDS` in `Sources/JKAMP/Generated/bg_public.swift`.

## The rows

### T1, the record tables, rows 1 and 12

Proposed: a hand `[ConsoleCommandRow]` and a hand `[CvarTableRow]` on `CGameWorld`, Raven's rows in Raven's order, the shape of `spawns` and `gameCvarTable`. Rules 3, 6, and 8. No `// AI:` line, as at the game tables.

### T2, the read-only string tables, rows 2 to 6, 9, 10, 13 to 20

Proposed: a `let` of `[String]` with Raven's literals, `[String?]` where Raven has a NULL entry. Rule 9, memory only the module reads is a Swift Array. Rows 6, 9, 13, and 14 are `char *` without `const`, so the transcriptor confirms no store before `let` stands. No `// AI:` line.

### T3, the `vec3_t` globals, rows 7, 8, 22 to 30

Proposed: a stored `var` of `vec3_t` with Raven's initializer, `vec3_t()` for a zero initializer, `CAMERA_SIZE` as Raven writes it for rows 22 and 23, the file prefix for the two `WHITE`. Rules 3 and 6, precedent `g_local.swift:30` and `:702`. No `// AI:` line.

### T4, the written int array, row 21

Proposed: `var lastFlyBySound: [Int32] = Array(repeating: 0, count: Int(MAX_GENTITIES))`. Rule 9. No `// AI:` line.

### T5, the `vec4_t` color table, row 11

The stub at `cg_local.swift:82` spells the table as `[[Float]]`, and Raven's type is `vec4_t[CT_MAX]`. `vec4_t` exists in `Sources/JKAShared/q_math.swift:13`. Proposed: a `let colorTable: [vec4_t]` with Raven's `CT_MAX` rows, under rule 9, and the stub's `[[Float]]` corrected to `[vec4_t]`. No game precedent. No `// AI:` line.

## The ledger

The walk of 2026-10-31. Every row ratified as proposed.

| Row | Verdict |
|---|---|
| T1 | ratified as proposed |
| T2 | ratified as proposed, the transcriptor confirms no store before `let` stands on rows 6, 9, 13, 14 |
| T3 | ratified as proposed |
| T4 | ratified as proposed |
| T5 | ratified as proposed, the stub's `[[Float]]` becomes `[vec4_t]` |

## The transcription

Commit `ee15214` replaces all 30 placeholders in `Sources/JKAMP_CGameLogic/cg_local.swift`, and the diff over 8 files is 556 lines added and 162 removed. The tables hold 31 console commands, 124 cvar rows, 67 colors, 15 string tables, 11 `vec3_t` globals, and `lastFlyBySound`.

- The store search in `oracle/codemp/cgame/*.c` finds no store into rows 6, 9, 13, or 14, so every string table is a `let` and no row needs a `var`.
- `CAMERA_SIZE` at `cg_view.swift:13` is internal already, so the two camera bounds stay on `CGameWorld` and read it as `Float(CAMERA_SIZE)`.
- A string table with a NULL row is `[String?]`. A sized table that Raven fills only in part pads to its macro with `Array(repeating: nil, count:)`, so the count stays Raven's.
- The forwards of the 17 `let` tables lose their setters, and the forward of `colorTable` reads `[vec4_t]`.
- The 15 static functions of `cg_consolecmds.swift` lose `private`, because the `commands` table names them from `cg_local.swift`. This is the rule of `skeleton.py` for a static function that a thunk names from another file.
- `swift build` is clean, and `swift test --no-parallel` passes 112 tests. `compare.py` takes a stem and compares function bodies with their drafts, so it does not apply to hand tables.

## A1, the seven unadopted stubs

The table commit edits seven stubs that still carry the generated header of `skeleton.py:71`, "Do not edit until adopted. Rule 13": `cg_consolecmds.swift`, `cg_draw.swift`, `cg_ents.swift`, `cg_event.swift`, `cg_main.swift`, `cg_marks.swift`, `cg_players.swift`. The edits are the forwards of the tables, which take the ruled types and lose their setters, and the 15 `private` removals on the console command functions that `commands` names. A rerun of `skeleton.py --unit mp-cgame` undoes every one of them and the build then fails, because the skeleton emits a setter whenever its write sweep at `:378-411` sets `written`, and that sweep counts an array passed by name to a call as a write. The game port never met this, because its stubs were adopted before any hand edit, and the skeleton leaves an adopted stub alone.

Two options. Adopt the seven stubs now, the act their transcription rounds perform anyway, so the skeleton leaves them alone and the forwards stand. Or hold the table commit until each stem's round adopts its file, and land the tables stem by stem. A generator change to the write sweep is a third path that no ruling asked for.

Ratified: adopt the seven stubs on this branch, the act their transcription rounds perform anyway.
