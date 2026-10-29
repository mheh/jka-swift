# The vehicle NPC docket

This record holds the separate docket that row C9 of `notes/2026-10-29/bg-consumer-docket.md:228-238` asks for. Raven's cgame project compiles four files of the game folder, `AnimalNPC.c`, `FighterNPC.c`, `SpeederNPC.c`, and `WalkerNPC.c` (`oracle/codemp/cgame/JK2_cgame.vcproj:294-303`), with `CGAME` defined and `QAGAME` not defined (`JK2_cgame.vcproj:32`, `:106`). The Swift files are in the game target: `Sources/JKAMP_GameLogic/AnimalNPC.swift`, `FighterNPC.swift`, `SpeederNPC.swift`, and `WalkerNPC.swift`. This record proves every consumer conditional of the four files, what the Swift body holds today, and what the cgame reaches. It states the two shapes that C9 names and proposes one. Every row is proposed and waits for its own ruling. No Sources, docs, or tools file changed for this record.

## The count

The unit is the unit of the bg consumer docket (`bg-consumer-docket.md:7`): one conditional chain, `#if` to `#endif`, whose `#if` or any `#elif` names `QAGAME` or `CGAME`. A nested chain counts once for each level. The four files hold 62 chains: 10, 30, 13, and 9.

C9 counts 71: 11, 36, 15, and 9 (`bg-consumer-docket.md:232`). That number comes from `grep -cE` over the directive lines, so a chain with two matching directive lines counts twice. Nine chains have two such lines, an `#elif QAGAME` and an `#elif CGAME` after an `#ifndef _JK2MP`, or an `#ifdef QAGAME` and an `#elif CGAME`: `AnimalNPC.c:185-192`, `FighterNPC.c:342-354`, `:381-388`, `:418-422`, `:1396-1403`, `:1846-1853`, `:1893-1897`, `SpeederNPC.c:325-332`, and `:752-759`. 71 less 9 is 62, and the difference per file is 1, 6, 2, and 0, which matches 11 - 10, 36 - 30, 15 - 13, and 9 - 9.

The four Swift files hold no `bg.consumer` test. Each Swift body takes the `QAGAME` arm of every chain, because the drafter read the game parse (`docs/transcription.md:569`).

## The kinds

The kinds are the kinds of the bg consumer docket (`bg-consumer-docket.md:13-17`):

- (a) The Swift body carries Raven's arms under a `bg.consumer` test.
- (b) The Swift body carries the game arm only. The cgame arm is absent, or the game arm runs for every consumer with no test.
- (c) The chain selects a header, a declaration, or an extern, and not a statement. No arm is needed.
- (d) The chain guards whole functions that only the game compiles. A chain nested inside such a function counts here too, because its cgame arm never compiles in any build.
- (e) The release build does not compile the chain: it is inside a comment, or inside a `#ifndef _JK2MP` arm that the MP build drops.

| File | (a) | (b) | (c) | (d) | (e) | Total |
|---|---|---|---|---|---|---|
| `AnimalNPC.c` | 0 | 4 | 3 | 2 | 1 | 10 |
| `FighterNPC.c` | 0 | 16 | 7 | 5 | 2 | 30 |
| `SpeederNPC.c` | 0 | 6 | 4 | 2 | 1 | 13 |
| `WalkerNPC.c` | 0 | 3 | 3 | 2 | 1 | 9 |
| Total | 0 | 29 | 17 | 11 | 5 | 62 |

The 29 (b) chains fall in four classes, rows V5 to V8: 10 game arms where Raven gives the cgame nothing, 11 chains with two arms that differ, 4 cgame-only arms, and the 4 game arms of the vehicle function setters. No chain registers an asset. The two `#ifdef CGAME` externs of `trap_S_RegisterSound` and `trap_S_StartSound` at `FighterNPC.c:357-360` are declarations.

## Facts every row uses

The build. `JK2_cgame.vcproj` defines `_JK2` and `CGAME` (`:32`). Each of the four files defines `_JK2MP` under `_JK2` at line 25-29, so every `#ifndef _JK2MP` arm is dead and every `#elif QAGAME` and `#elif CGAME` after it is live. `VEH_CONTROL_SCHEME_4` has no `#define` anywhere under `oracle/codemp`, so its chains in `FighterNPC.c` take the `#else` arm. `FighterNPC.c:725` is `#if 1`, so the chain at `:728-730` inside it is live.

What the cgame compiles. The cgame build of the four files defines 33 functions. The game build defines 48, and 15 of them stand under `#ifdef QAGAME` alone:

| File | Both builds | Game build only |
|---|---|---|
| `AnimalNPC.c` | `ProcessMoveCommands` `:168`, `ProcessOrientCommands` `:338`, `AnimalProcessOri` `:467`, `G_SetAnimalVehicleFunctions` `:857`, `G_CreateAnimalNPC` `:904` | `DeathUpdate` `:97`, `Update` `:151`, `AnimateVehicle` `:474`, `AnimateRiders` `:620` |
| `FighterNPC.c` | `BG_FighterUpdate` `:99`, `PredictedAngularDecrement` `:237`, `FighterOverValidLandingSurface` `:289`, `FighterIsLanded` `:300`, `FighterIsLanding` `:310`, `FighterIsLaunching` `:325`, `FighterSuspended` `:340`, `ProcessMoveCommands` `:370`, `FighterWingMalfunctionCheck` `:890`, `FighterNoseMalfunctionCheck` `:917`, `FighterDamageRoutine` `:935`, `FighterYawAdjust` `:1299`, `FighterPitchAdjust` `:1325`, `FighterPitchClamp` `:1352`, `ProcessOrientCommands` `:1381`, `G_SetFighterVehicleFunctions` `:1948`, `G_CreateFighterNPC` `:1994` | `Update` `:188`, `Board` `:212`, `Eject` `:224`, `FighterIsInSpace` `:276`, `AnimateVehicle` `:1836`, `AnimateRiders` `:1938` |
| `SpeederNPC.c` | `VEH_StartStrafeRam` `:140`, `ProcessMoveCommands` `:278`, `ProcessOrientCommands` `:505`, `AnimateRiders` `:630`, `G_SetSpeederVehicleFunctions` `:1044`, `G_CreateSpeederNPC` `:1092` | `Update` `:149`, `AnimateVehicle` `:608` |
| `WalkerNPC.c` | `ProcessMoveCommands` `:129`, `WalkerYawAdjust` `:254`, `ProcessOrientCommands` `:316`, `G_SetWalkerVehicleFunctions` `:547`, `G_CreateWalkerNPC` `:594` | `RegisterAssets` `:84`, `Board` `:106`, `AnimateVehicle` `:415` |

The cites are the `Source:` lines of the Swift files, which point at each function's first line.

The channel. The bg bodies reach the four files through six closures on `BgCallbacks`: `BG_FighterUpdate` (`Sources/JKAMP_BG/Generated/bg_callbacks.swift:10`), `FighterIsLanded` (`:25`), and the four setters `G_SetAnimalVehicleFunctions` (`:61`), `G_SetFighterVehicleFunctions` (`:64`), `G_SetSpeederVehicleFunctions` (`:70`), and `G_SetWalkerVehicleFunctions` (`:73`). The game installs them at `Sources/JKAMP_GameLogic/Generated/BgChannel.swift:82`, `:91`, `:127`, `:130`, `:136`, and `:139`. `channel.py` puts them on the channel because their stems do not start with `bg_` (`tools/oracle-closure/channel.py:227`).

The function slots. A vehicle's move and orient code runs through function pointers on `vehicleInfo_t`. Each setter stores its file's functions there, and Swift stores a `@convention(c)` thunk from a private `VehicleInfoThunks` enum, for example `AnimalNPC.swift:662-682`. The slot types are in the shared views target (`Sources/JKAMP/Generated/Views/Callbacks.swift:19`, `:37`). The game fills the `Ghost`, `Inhabited`, and `AttachRiders` slots in `G_SetSharedVehicleFunctions`, which bg calls on the game arm only (`oracle/codemp/game/bg_vehicleLoad.c:685-688`, row C3). So in the cgame, the `Ghost` and `Inhabited` slots stay NULL, and only the `#ifndef QAGAME` stores of the four files fill `AttachRiders`.

The drafter and the rules. A `#ifdef` in a game body takes the native build's branch (`docs/transcription.md:569`). The one exception is a bg body, which spells `#ifdef QAGAME` as a `bg.consumer` test (`docs/porting-rules.md:48`, `docs/transcription.md:571`). The four files are not bg files, so today the native build of the game decides every chain. Rule 20 says "Duplicate, do not unify" (`docs/porting-rules.md:45`). Rule 13 says Swift files mirror Raven's `.c` files in name and order (`docs/porting-rules.md:33`).

The AI comment. Rule 24 (`docs/porting-rules.md:71`) puts an `AI:` line only where a ruling changes Raven's form. A copy that takes its native branch keeps Raven's form, and so does a `bg.consumer` test with both arms. No row below adds an `AI:` line.

## The chains

Every chain, with its kind, its row, and what the Swift body holds today. A Swift cite without a file name is in the Swift file of the same name.

| Raven chain | Directives | Kind | Row | Swift today |
|---|---|---|---|---|
| `AnimalNPC.c:32-34` | `#ifndef QAGAME` inside `#ifndef _JK2MP` `:31-35` | e | V3 | no line |
| `AnimalNPC.c:37-41` | `#ifdef QAGAME`, `#elif defined _JK2MP` | c | V2 | the imports at `AnimalNPC.swift:1-5`, `JKAMP_Game` at `:4` |
| `AnimalNPC.c:71-155` | `#ifdef QAGAME` | d | V4 | `DeathUpdate` `:68`, `Update` `:118` |
| `AnimalNPC.c:185-192` | `#ifndef _JK2MP`, `#elif QAGAME`, `#elif CGAME` | b | V6 | `curTime = level.time` `:147`, the cgame comment alone at `:148` |
| `AnimalNPC.c:473-850` | `#ifdef QAGAME` | d | V4 | `AnimateVehicle` `:350`, `AnimateRiders` `:467` |
| `AnimalNPC.c:852-854` | `#ifndef QAGAME` | c | V2 | no line |
| `AnimalNPC.c:859-876` | `#ifdef QAGAME` | b | V8 | four stores with no test, `:624`, `:625`, `:635`, `:638` |
| `AnimalNPC.c:880-882` | `#ifndef QAGAME` | b | V7 | absent after `:641` |
| `AnimalNPC.c:894-896` | `#ifdef QAGAME` | c | V2 | no line |
| `AnimalNPC.c:908-918` | `#ifdef QAGAME`, `#else` | b | V6 | `G_AllocateVehicleObject(&pVeh)` `:657` |
| `FighterNPC.c:32-34` | `#ifndef QAGAME` inside `#ifndef _JK2MP` `:31-35` | e | V3 | no line |
| `FighterNPC.c:37-41` | `#ifdef QAGAME`, `#elif defined _JK2MP` | c | V2 | the imports at `FighterNPC.swift:1-5` |
| `FighterNPC.c:72-81` | `#ifdef QAGAME` | c | V2 | no line |
| `FighterNPC.c:91-93` | `#ifdef QAGAME` | c | V2 | no line |
| `FighterNPC.c:105-114` | `#ifdef QAGAME` | b | V5 | the `Ghost` loop with no test, `:74-83` |
| `FighterNPC.c:185-234` | `#ifdef QAGAME` | d | V4 | `Update` `:135`, `Board` `:149`, `Eject` `:162` |
| `FighterNPC.c:275-287` | `#ifdef QAGAME` | d | V4 | `FighterIsInSpace` `:206` |
| `FighterNPC.c:314-316` | `#ifdef QAGAME` | b | V5 | the `runInhabited` clause with no test, `:232-233` |
| `FighterNPC.c:329-331` | `#ifdef QAGAME` | b | V5 | the same clause, `:245-246` |
| `FighterNPC.c:342-354` | `#ifdef QAGAME`, `#elif CGAME` | b | V6 | the game body `:256-261`, no `return false` arm |
| `FighterNPC.c:357-360` | `#ifdef CGAME` | c | V2 | no line |
| `FighterNPC.c:381-388` | inside the comment `:380-389` | e | V3 | the comment text `:278-287` |
| `FighterNPC.c:418-422` | `#ifdef QAGAME`, `#elif CGAME` | b | V6 | the game arm, a comment, `:306-308`, no `trap_S_StartSound` |
| `FighterNPC.c:462-464` | `#ifdef QAGAME` | b | V5 | `G_EntitySound` with no test, `:339-342` |
| `FighterNPC.c:508-514` | `#ifdef QAGAME` | b | V5 | `G_EntitySound` with no test, `:375-379` |
| `FighterNPC.c:571-583` | `#ifdef QAGAME` | b | V5 | two `else if` clauses with no test, `:428-434` |
| `FighterNPC.c:728-730` | `#ifdef QAGAME` inside `#if 1` `:725-802` | b | V5 | the `runInhabited` clause with no test, `:544-545` |
| `FighterNPC.c:813-882` | `#ifdef QAGAME`, `#else` | b | V6 | the game block `:618-672`, no `gravity = 0` arm |
| `FighterNPC.c:1021-1032` | `#ifdef QAGAME` | b | V5 | `G_DamageFromKiller` with no test, `:789-793` |
| `FighterNPC.c:1390-1392` | `#ifdef QAGAME` | c | V2 | `let groundFraction` `:913` |
| `FighterNPC.c:1396-1403` | `#ifndef _JK2MP`, `#elif QAGAME`, `#elif CGAME` | b | V6 | `curTime = level.time` `:917`, the cgame comment alone at `:918` |
| `FighterNPC.c:1759-1776` | `#ifdef QAGAME` | b | V5 | the tumble block with no test, `:1143-1153` |
| `FighterNPC.c:1831-1942` | `#ifdef QAGAME` | d | V4 | `AnimateVehicle` `:1197`, `AnimateRiders` `:1265` |
| `FighterNPC.c:1846-1853` | `#ifndef _JK2MP`, `#elif QAGAME`, `#elif CGAME`, inside `:1831-1942` | d | V4 | `curTime = level.time` `:1205`, the cgame comment `:1206` |
| `FighterNPC.c:1893-1897` | `#ifdef QAGAME`, `#elif CGAME`, inside `:1831-1942` | d | V4 | `G_EntitySound` `:1234`, the cgame comment `:1235` |
| `FighterNPC.c:1944-1946` | `#ifndef QAGAME` | c | V2 | no line |
| `FighterNPC.c:1950-1967` | `#ifdef QAGAME` | b | V8 | five stores with no test, `:1270`, `:1271`, `:1277`, `:1278`, `:1283` |
| `FighterNPC.c:1971-1973` | `#ifndef QAGAME` | b | V7 | absent after `:1287` |
| `FighterNPC.c:1985-1987` | `#ifdef QAGAME` | c | V2 | no line |
| `FighterNPC.c:1998-2008` | `#ifdef QAGAME`, `#else` | b | V6 | `G_AllocateVehicleObject(&pVeh)` `:1302` |
| `SpeederNPC.c:32-34` | `#ifndef QAGAME` inside `#ifndef _JK2MP` `:31-35` | e | V3 | no line |
| `SpeederNPC.c:37-41` | `#ifdef QAGAME`, `#elif defined _JK2MP` | c | V2 | the imports at `SpeederNPC.swift:1-5` |
| `SpeederNPC.c:74-82` | `#ifdef QAGAME` | c | V2 | no line |
| `SpeederNPC.c:147-269` | `#ifdef QAGAME` | d | V4 | `Update` `:79` |
| `SpeederNPC.c:325-332` | `#ifndef _JK2MP`, `#elif QAGAME`, `#elif CGAME` | b | V6 | `curTime = level.time` `:167`, the cgame comment alone at `:168` |
| `SpeederNPC.c:355-370` | `#ifdef QAGAME` | b | V5 | the turbo effect block with no test, `:180-194` |
| `SpeederNPC.c:602-612` | `#ifdef QAGAME` | d | V4 | `AnimateVehicle` `:324` |
| `SpeederNPC.c:752-759` | `#ifndef _JK2MP`, `#elif QAGAME`, `#elif CGAME` | b | V6 | `curTime = level.time` `:395`, the cgame comment alone at `:396` |
| `SpeederNPC.c:1040-1042` | `#ifndef QAGAME` | c | V2 | no line |
| `SpeederNPC.c:1046-1063` | `#ifdef QAGAME` | b | V8 | three stores with no test, `:622`, `:623`, `:636` |
| `SpeederNPC.c:1069-1071` | `#ifndef QAGAME` | b | V7 | absent after `:641` |
| `SpeederNPC.c:1083-1085` | `#ifdef QAGAME` | c | V2 | no line |
| `SpeederNPC.c:1095-1105` | `#ifdef QAGAME`, `#else` | b | V6 | `G_AllocateVehicleObject(&pVeh)` `:655` |
| `WalkerNPC.c:32-34` | `#ifndef QAGAME` inside `#ifndef _JK2MP` `:31-35` | e | V3 | no line |
| `WalkerNPC.c:37-41` | `#ifdef QAGAME`, `#elif defined _JK2MP` | c | V2 | the imports at `WalkerNPC.swift:1-5` |
| `WalkerNPC.c:71-116` | `#ifdef QAGAME` | d | V4 | `RegisterAssets` `:67`, `Board` `:78` |
| `WalkerNPC.c:413-540` | `#ifdef QAGAME` | d | V4 | `AnimateVehicle` `:284` |
| `WalkerNPC.c:542-544` | `#ifndef QAGAME` | c | V2 | no line |
| `WalkerNPC.c:549-566` | `#ifdef QAGAME` | b | V8 | three stores with no test, `:395`, `:402`, `:407` |
| `WalkerNPC.c:570-572` | `#ifndef QAGAME` | b | V7 | absent after `:412` |
| `WalkerNPC.c:584-586` | `#ifdef QAGAME` | c | V2 | no line |
| `WalkerNPC.c:598-608` | `#ifdef QAGAME`, `#else` | b | V6 | `G_AllocateVehicleObject(&pVeh)` `:428` |

## V1. The shape

Ratified as proposed on 2026-10-29.

Shape A. Move the four files into `JKAMP_BG` and spell each consumer conditional as a rule 23 `bg.consumer` test with both arms. This is what jka-rust did, in a split form: the 33 functions of both builds went to the bg crate, and the 15 game-only functions stayed in the game crate (`jka-rust/crates/mp/bg/src/vehicles/mod.rs:9-17`, `jka-rust/crates/mp/game/src/AnimalNPC.rs:1-7`). The consequences:

1. Rule 23 and `docs/transcription.md:571` name bg bodies. The four files are not `bg_*.c`, so the rule needs one sentence that brings them in. This is a doc row.
2. The 29 (b) chains become hand edits of adopted bodies, because the drafter reads the game parse and never writes a cgame arm (`bg-consumer-docket.md:44`).
3. The 15 game-only functions read the game's `gentity_t` and the game's functions throughout (see "The game names the four files reach"). Either they stay in the game target as R31 functions, which breaks rule 13's one Swift file per Raven file, or they move with the file and every game name they reach goes on the channel.
4. The six closures of the channel become plain bg functions, and the channel gains the game names of the game arms of the 33 functions. The count is in "The game names the four files reach".
5. The game target changes: four files move, and every game arm takes a test. The game gate must prove that the game run does not change.

Shape B. Compile the same four files a second time in `JKAMP_CGameLogic`, as Raven's build does. The game copy stays as it is. The cgame copy is a second Swift transcription of the same Raven text, drafted from the cgame parse, so each `#ifdef` takes the cgame's native branch by `docs/transcription.md:569`. The consequences:

1. No rule changes. The four files are game files that the cgame also compiles, and each copy follows the `#ifdef` rule of a game body. Rule 20 says "Duplicate, do not unify", and rule 13's mirror holds once per target.
2. The cgame copy holds the 33 functions of both builds and none of the 15 game-only functions. It reaches no game name, because the cgame build compiles no `QAGAME` arm.
3. The shared text exists twice. A later fix to a shared body is two edits, one per copy. OpenJK keeps the same two compiles today (`~/Developer/Milo/OpenJK/codemp/cgame/CMakeLists.txt:33-48`).
4. The six closures stay on the channel, and the cgame install points them at the cgame copy (row V9).
5. The game target does not change, so the game gate holds by construction (row V11).

Proposed form. Shape B.

Reason. Shape B repeats Raven's build, each copy takes its native branch under the rule that already binds game bodies, the drafter writes the cgame arms from the cgame parse, and no game file changes.

Alternative. Shape A. It gives one Swift text for the 33 shared functions, at the cost of a rule 23 extension, 29 hand edits in adopted game bodies, the channel entries of "The game names the four files reach", and a move of the game files with a full game gate.

Generator rows. Row V10.

## V2. Header, extern, and declaration selectors (kind c, 17 chains)

Ratified as proposed on 2026-10-29.

The sites. The include selectors at `AnimalNPC.c:37-41`, `FighterNPC.c:37-41`, `SpeederNPC.c:37-41`, and `WalkerNPC.c:37-41`: the game includes `g_local.h`, and the cgame includes `bg_public.h`. The game externs at `FighterNPC.c:72-81`, `:91-93`, and `SpeederNPC.c:74-82`. The `G_AllocateVehicleObject` externs at `AnimalNPC.c:894-896`, `FighterNPC.c:1985-1987`, `SpeederNPC.c:1083-1085`, and `WalkerNPC.c:584-586`. The cgame declarations of `AttachRidersGeneric` at `AnimalNPC.c:852-854`, `FighterNPC.c:1944-1946`, `SpeederNPC.c:1040-1042`, and `WalkerNPC.c:542-544`. The cgame trap externs at `FighterNPC.c:357-360`. The local `const float groundFraction = 0.1f` at `FighterNPC.c:1390-1392`, which only the game arm at `:1759-1776` reads.

Proposed form. The game copy does not change. The cgame copy imports `JKAMP_CGame` where the game copy imports `JKAMP_Game` (`AnimalNPC.swift:4`), and writes no extern line. The cgame copy has no `groundFraction`, because the cgame build declares none.

Under shape A. The bg file imports neither view target. `groundFraction` stays a local under the same test as its one reader, or above it with no test, since a constant local changes no behavior.

Generator rows. None.

## V3. Not compiled in the release build (kind e, 5 chains)

Ratified as proposed on 2026-10-29.

The sites. `#ifndef QAGAME` / `#define QAGAME` inside `#ifndef _JK2MP` at `AnimalNPC.c:32-34`, `FighterNPC.c:32-34`, `SpeederNPC.c:32-34`, and `WalkerNPC.c:32-34`. The MP build defines `_JK2MP` at line 25-29 of each file, so the outer chain drops them. The `curTime` chain at `FighterNPC.c:381-388` is inside the comment `:380-389`, and the Swift body keeps it as comment text at `FighterNPC.swift:278-287`.

Proposed form. No change, by `docs/transcription.md:569`. The cgame copy keeps the comment text as the game copy does.

Generator rows. None.

## V4. Whole functions only the game compiles (kind d, 11 chains)

Ratified as proposed on 2026-10-29.

The sites. `AnimalNPC.c:71-155` and `:473-850`, `FighterNPC.c:185-234`, `:275-287`, and `:1831-1942`, `SpeederNPC.c:147-269` and `:602-612`, and `WalkerNPC.c:71-116` and `:413-540`. These nine chains hold the 15 game-only functions of the facts table. The two nested chains `FighterNPC.c:1846-1853` and `:1893-1897` are inside `AnimateVehicle`, which only the game compiles, so their `CGAME` arms never compile in any build. The Swift body keeps Raven's cgame comment at `FighterNPC.swift:1206` and `:1235`.

Proposed form. The 15 functions stay in the game copy as they are. The cgame copy does not define them, because the cgame parse holds no definition of them. The two nested chains keep the game arm.

Under shape A. The 15 functions stay in the game target. `FighterIsInSpace` is the one that a function of both builds calls (`FighterNPC.c:816`, `:834`, `:864`, `:1762`), so it is a `QAGAME_ONLY` entry by R31 (`tools/oracle-closure/rulings.py:418-420`). The other 14 are reached only through the setter stores of row V8. The game keeps them in a hand file per Raven file, in the shape of `Sources/JKAMP_GameLogic/bg_pmove_game.swift`.

Generator rows. None under shape B. Under shape A, the skeleton needs a per-function target, because `target_of` decides by stem (`tools/oracle-closure/skeleton.py:87-91`).

## V5. A game arm with no cgame arm (kind b, 10 chains)

Ratified as proposed on 2026-10-29.

| Raven | Swift today | What the game arm does |
|---|---|---|
| `FighterNPC.c:105-114` | `FighterNPC.swift:74-83` | calls the `Ghost` slot for the pilot and each passenger |
| `FighterNPC.c:314-316` | `:232-233` | adds the `Inhabited` slot clause to the landing test |
| `FighterNPC.c:329-331` | `:245-246` | the same clause in the launch test |
| `FighterNPC.c:462-464` | `:339-342` | `G_EntitySound` of the take-off sound |
| `FighterNPC.c:508-514` | `:375-379` | `G_EntitySound` of the turbo sound |
| `FighterNPC.c:571-583` | `:428-434` | two `else if` clauses, `FighterSuspended` and the `Inhabited` slot |
| `FighterNPC.c:728-730` | `:544-545` | the `Inhabited` slot clause in the strafe test |
| `FighterNPC.c:1021-1032` | `:789-793` | `G_DamageFromKiller` of a fighter that lands with parts missing |
| `FighterNPC.c:1759-1776` | `:1143-1153` | pitches an empty fighter down as it falls |
| `SpeederNPC.c:355-370` | `SpeederNPC.swift:180-194` | `trap_G2API_GetBoltMatrix` and `G_PlayEffectID` per exhaust at turbo start |

What the cgame arm does. Nothing: Raven compiles no statement for the cgame at these sites. Four of the sites call a slot that the cgame leaves NULL, the `Ghost` slot at `FighterNPC.c:109` and `:112` and the `Inhabited` slot at `:315`, `:330`, `:577`, `:729`, and `:1760`. The Swift view call `runInhabited` would reach a NULL function in the cgame.

Proposed form. The game copy does not change. The cgame copy writes no statement and no clause, the cgame's native branch.

Under shape A. The rule 23 test around each arm, `if bg.consumer == .game { ... }`, and the C3 form where the arm is a clause of a condition: `&& (bg.consumer != .game || pVeh.m_pVehicleInfo!.runInhabited(pVeh))`, or `} else if bg.consumer == .game && FighterSuspended(pVeh, parentPS!) {` (`bg-consumer-docket.md:105`). The game names of the arms go on the channel.

Generator rows. None under shape B.

## V6. Two arms that differ (kind b, 11 chains)

Ratified as proposed on 2026-10-29.

| Raven | Swift today | Raven's cgame arm |
|---|---|---|
| `AnimalNPC.c:185-192` | `AnimalNPC.swift:147-148` | `curTime = pm->cmd.serverTime` |
| `FighterNPC.c:1396-1403` | `FighterNPC.swift:917-918` | the same |
| `SpeederNPC.c:325-332` | `SpeederNPC.swift:167-168` | the same |
| `SpeederNPC.c:752-759` | `SpeederNPC.swift:395-396` | the same, in `AnimateRiders`, which the cgame compiles and never stores in a slot |
| `FighterNPC.c:342-354` | `FighterNPC.swift:256-261` | `FighterSuspended` returns `qfalse` |
| `FighterNPC.c:418-422` | `FighterNPC.swift:306-308` | `trap_S_StartSound( NULL, pm->ps->clientNum, CHAN_LOCAL, pVeh->m_pVehicleInfo->soundHyper )`, where the game arm is a comment |
| `FighterNPC.c:813-882` | `FighterNPC.swift:618-672` | `parentPS->gravity = 0` in place of the pitch, speed, and gravity block |
| `AnimalNPC.c:908-918` | `AnimalNPC.swift:657` | `BG_Alloc( sizeof(Vehicle_t) )` when `*pVeh` is NULL, in place of `G_AllocateVehicleObject` |
| `FighterNPC.c:1998-2008` | `FighterNPC.swift:1302` | the same |
| `SpeederNPC.c:1095-1105` | `SpeederNPC.swift:655` | the same |
| `WalkerNPC.c:598-608` | `WalkerNPC.swift:428` | the same |

The game arms of the four `curTime` chains read `level.time`, and Raven's comment on the cgame arm reads "FIXME: pass in ucmd?  Not sure if this is reliable...". Each Swift body keeps that comment with no statement after the game arm, as row C5 found at `bg_pmove.swift:9234-9240`.

Proposed form. The game copy does not change. The cgame copy writes Raven's cgame arm. `pm`, `BG_Alloc`, and `AttachRidersGeneric` are public in `JKAMP_BG` (`Sources/JKAMP_BG/bg_misc.swift:1683`, `Sources/JKAMP_BG/bg_vehicleLoad.swift:976`), and the game copy already reads `pm.cmd.serverTime` at `FighterNPC.swift:290`. `trap_S_StartSound` is a cgame trap of `oracle/codemp/cgame/cg_syscalls.c:192`, which the cgame copy reaches through its own typed traps.

Under shape A. The rule 23 test with both arms. The game arm of a `curTime` chain reads `bgLevelTime()` (`bg_callbacks.swift:151`). `trap_S_StartSound` joins `bg_strap.swift` as a cgame-only trap that `installBgChannel()` skips (`docs/transcription.md:483-484`). `G_AllocateVehicleObject` becomes a new game closure. `FighterSuspended` reads `bgEntitySpawnflags` (`bg_callbacks.swift:139`).

Generator rows. None under shape B, beyond row V10. Under shape A, `channel.py` collects `trap_S_StartSound` only when the cgame parse compiles the four files (row V10).

## V7. The cgame `AttachRiders` stores (kind b, 4 chains)

Ratified as proposed on 2026-10-29.

The sites. `AnimalNPC.c:880-882`, `FighterNPC.c:1971-1973`, `SpeederNPC.c:1069-1071`, and `WalkerNPC.c:570-572` each store `pVehInfo->AttachRiders = AttachRidersGeneric` under `#ifndef QAGAME`. The Swift setters hold no such store, after `AnimalNPC.swift:641`, `FighterNPC.swift:1287`, `SpeederNPC.swift:641`, and `WalkerNPC.swift:412`.

Why the cgame needs them. The cgame calls the slot at `oracle/codemp/cgame/cg_players.c:8557`, and bg calls it for every consumer at `oracle/codemp/game/bg_pmove.c:11148`, which the Swift body spells at `Sources/JKAMP_BG/bg_pmove.swift:9350`. In the cgame, only these four stores fill the slot.

Proposed form. The cgame copy writes the store with a thunk over the bg function, in the shape of the other thunks of the file: `pVehInfo.AttachRiders = VehicleInfoThunks.AttachRiders`, where the thunk calls `AttachRidersGeneric`. The game copy does not change.

Under shape A. `if bg.consumer != .game { pVehInfo.AttachRiders = VehicleInfoThunks.AttachRiders }`, the test of an `#ifndef QAGAME` chain.

Generator rows. None. The skeleton writes the thunks per file (`tools/oracle-closure/skeleton.py:911`).

## V8. The game arms of the four setters (kind b, 4 chains)

Ratified as proposed on 2026-10-29.

The sites. `AnimalNPC.c:859-876`, `FighterNPC.c:1950-1967`, `SpeederNPC.c:1046-1063`, and `WalkerNPC.c:549-566`. Each stores the file's game-only functions in the slots: 4, 5, 3, and 3 stores. 14 of the 15 stored functions are game-only. Speeder's `AnimateRiders` is the exception: the cgame compiles it, and only the game stores it. The Swift setters hold the stores with no test (the chain table).

Proposed form. The game copy does not change. The cgame copy holds the two stores of both builds, `ProcessMoveCommands` and `ProcessOrientCommands`, and the store of row V7.

Under shape A. The game arm names private game functions that a bg file cannot name. The forms are one `ARM_HOOKS` entry per setter (`tools/oracle-closure/rulings.py:414-417`), which the game defines by hand and which stores the game slots, or 14 `QAGAME_ONLY` closures with bg thunks that call them. The second form needs channel names for private functions that share a name across files, `Update` three times and `AnimateVehicle` four times, so it renames Raven's functions. The first form keeps the stores in the game, off the page of the bg body.

Generator rows. None under shape B. Under shape A, four `ARM_HOOKS` entries.

## V9. What the cgame calls, and the cgame install

Ratified as proposed on 2026-10-29.

The cgame reaches the four files at these sites:

| Site | What it reaches | Swift today |
|---|---|---|
| `oracle/codemp/cgame/cg_players.c:7025`, `:7029`, `:7033`, `:7037` | `G_CreateAnimalNPC`, `G_CreateSpeederNPC`, `G_CreateFighterNPC`, `G_CreateWalkerNPC`, declared at `:6991-6994` | no cgame Swift body exists yet |
| `oracle/codemp/game/bg_vehicleLoad.c:690-706` | the four setters, for game and cgame | the closures at `bg_callbacks.swift:61`, `:64`, `:70`, `:73` |
| `oracle/codemp/game/bg_pmove.c:10967` | `BG_FighterUpdate`, on the cgame arm | row C5, comments only at `bg_pmove.swift:9234-9240` |
| `oracle/codemp/game/bg_pmove.c:10980`, `:10982` | the `ProcessOrientCommands` and `ProcessMoveCommands` slots, on the cgame arm | row C5 |
| `oracle/codemp/game/bg_pmove.c:11148`, `oracle/codemp/cgame/cg_players.c:8557` | the `AttachRiders` slot | `bg_pmove.swift:9350`, row V7 |
| `oracle/codemp/game/bg_slidemove.c:316` | `FighterIsLanded`, on the game arm only | row C3 puts it under the game test, so no cgame path reaches it |

No other cgame `.c` file names a function of the four files. `AnimalProcessOri` has no caller in either tree: `SpeederNPC.c:503` declares it and no line calls it.

How jka-rust's cgame reaches them. The cgame defines its own `G_Create*NPC` over a cgame vehicle pool in place of `BG_Alloc` (`jka-rust/crates/mp/cgame/src/vehicle_npc.rs:1-10`, `:26-52`, `jka-rust/crates/mp/cgame/src/world/cg_world.rs:112`), called at `jka-rust/crates/mp/cgame/src/cg_players.rs:6889-6901`. The bg `Pmove` calls the shared functions directly, with no slot, at `jka-rust/crates/mp/bg/src/bg_pmove.rs:1732`, `:1753`, and `:1760`, through the dispatch `jka-rust/crates/mp/bg/src/vehicles/veh_process.rs:22-43`. The `AttachRiders` slot is one callback per consumer (`jka-rust/crates/mp/cgame/src/bg_channel/cg_game_callbacks.rs:233-250`).

Proposed form. The cgame install points the six closures at the cgame copy: `BG_FighterUpdate`, `FighterIsLanded`, and the four setters. `G_SetSharedVehicleFunctions` stays a game closure, which no cgame path reaches after row C3. `cg_players.c` calls the four `G_Create*NPC` of the cgame copy by name, in the same target.

Under shape A. The six closures leave the channel. The cgame install adds only `trap_S_StartSound`, because `BG_Alloc` and `AttachRidersGeneric` are bg functions. The game closures of the game arms keep their trapping defaults in the cgame, and a cgame call to one is a defect that the default names (`bg-consumer-docket.md:258`).

Generator rows. The cgame install writer of row V10.

## V10. The generator rows

Ratified as proposed on 2026-10-29.

Shape B needs these rows:

1. The cgame parse compiles the four files. `srcglob` of `[units.mp-cgame]` lists `codemp/cgame/*.c`, `codemp/game/bg_*.c`, and `codemp/ui/ui_shared.c` (`tools/oracle-closure/project.toml:189-193`), so today the cgame parse holds no definition from the four files. The row adds the four paths, Raven's list at `JK2_cgame.vcproj:294-303`.
2. The skeleton collects them for the cgame unit. `collect` keeps only the functions of the unit's own folder (`tools/oracle-closure/skeleton.py:276-283`), and the cites and the source reader join `ORACLE_DIR` to the stem (`skeleton.py:109`, `:161`, `:194`, `:272`). For the cgame unit, `ORACLE_DIR` is `codemp/cgame` (`skeleton.py:56`, `tools/oracle-closure/closure.py:334`). The row names the four stems as game-folder files of the cgame unit, so the stubs land in `JKAMP_CGameLogic` by `target_of` (`skeleton.py:91`) with `Source:` lines under `oracle/codemp/game/`.
3. The manifest cites jka-rust for the four cgame stubs: the bg vehicles files and `jka-rust/crates/mp/cgame/src/vehicle_npc.rs`. `skeleton.py:195` reads jka-rust under `game`, `bg`, and `qshared` today (blocker 7 at `notes/2026-10-29/cgame-scout.md:312`).
4. The cgame install. `channel.py` writes the install into the logic target of the game unit only (`channel.py:417-424`), and a cgame run writes nothing (`channel.py:442-445`). The row is blocker 8 at `cgame-scout.md:313`, with the six closures of row V9 among its entries.
5. The compile gate. `draftcheck.py --unit mp-cgame` gates the four cgame stems with the rest of the cgame, once the shell target exists (`notes/2026-10-29/cgame-stage-2.md:123`).

Shape A needs these rows:

1. A set of bg stems that holds `bg_*` and the four files, read by `target_of` (`skeleton.py:91`), `called_from_bg` (`channel.py:181`), `collect_callbacks` (`channel.py:227`), and the read sweep (`tools/oracle-closure/table.py:499`, `:745`). With it, the six closures drop from the channel, and the calls of the moved bodies reach `collect_callbacks`.
2. A per-function target in the skeleton for the 15 game-only functions, or the whole-file move of row V1.
3. `QAGAME_ONLY` gains `FighterIsInSpace` (`rulings.py:420`). `ARM_HOOKS` gains the four setter arms (`rulings.py:414-417`).
4. The cgame parse compiles the four files, row 1 of shape B, so that `called_from_bg` sees the cgame arms (`channel.py:178-182`) and collects `trap_S_StartSound`.
5. `skeleton.py --publish` makes public the names that game files read: the four `G_Create*NPC` (`Sources/JKAMP_GameLogic/NPC_spawn.swift`) and `FighterIsLanded` (`Sources/JKAMP_GameLogic/g_missile.swift`).
6. The compile gate gates the four stems as bg stems.

Proposed form. The five rows of shape B.

Generator rows. As listed.

## V11. The gate

Ratified as proposed on 2026-10-29.

Shape B. No file under `Sources/JKAMP_GameLogic`, `Sources/JKAMP_Game`, or `Sources/JKAMP_BG` changes, so the game run cannot change. Three checks prove it: `git diff --stat master -- Sources/JKAMP_GameLogic Sources/JKAMP_Game Sources/JKAMP_BG` is empty, `snapshot.py --check` of the game unit reports no difference, and one replay of `notes/2026-10-29/game-pool-docket.md:170-180` gives the same `G_Alloc of` stream. `swift build`, `swift test --no-parallel`, and the tool tests are the rest of the gate. The cgame copy is proven by a test in the cgame test target: the cgame copy's `G_SetFighterVehicleFunctions` on a zeroed `VehicleInfo` fills the two move and orient slots and the `AttachRiders` slot and leaves `Update` empty, and the cgame `curTime` arm reads `pm.cmd.serverTime`.

Shape A. The four files move, and the game arms take a test. The gate is the gate of the bg consumer docket (`bg-consumer-docket.md:301`): every game replay and the map change run of `game-pool-docket.md:127` give the same output, with `swift build`, `swift test --no-parallel`, `tools/load-test.sh`, the tool tests, `draftcheck.py --every`, and `snapshot.py --check`. The snapshot changes by design, so the check must show only the moved files, the six closures that leave the channel, and the new hooks. A unit test builds `BgState(consumer: .cgame, ...)`, runs the moved `ProcessMoveCommands` of each class, and proves that no game closure traps.

Proposed form. The shape B gate.

Generator rows. None.

## The game names the four files reach

The names that a cgame build has no counterpart for, by where they stand. Every one of them is on a `QAGAME` arm, so the cgame build compiles none of them.

On the game arms of the 33 functions of both builds:

| Game name | Raven sites | Count | On the channel today | Shape A form |
|---|---|---|---|---|
| `level.time` | `AnimalNPC.c:188`, `FighterNPC.c:1399`, `SpeederNPC.c:328`, `:365`, `:755` | 5 | `bgLevelTime`, `bg_callbacks.swift:151` | the read callback |
| `G_EntitySound` | `FighterNPC.c:463`, `:512` | 2 | no | a new callback, `oracle/codemp/game/g_utils.c:1392` |
| `FighterIsInSpace`, which reads `client->inSpaceIndex` | `FighterNPC.c:816`, `:834`, `:864`, `:1762` | 4 | no | a `QAGAME_ONLY` entry, `FighterNPC.c:276` |
| `gentity_t.spawnflags` | `FighterNPC.c:347` | 1 | `bgEntitySpawnflags`, `bg_callbacks.swift:139` | the read callback |
| `G_DamageFromKiller` | `FighterNPC.c:1026` | 1 | yes, `bg_callbacks.swift:40` | the callback |
| `gentity_t.client->ps.origin` | `FighterNPC.c:1026` | 1 | no | a new read callback |
| `G_PlayEffectID` | `SpeederNPC.c:368` | 1 | yes, `bg_callbacks.swift:58` | the callback |
| `trap_G2API_GetBoltMatrix` of `g_syscalls.c` | `SpeederNPC.c:365` | 1 | yes, `Sources/JKAMP_BG/Generated/bg_strap.swift:70` | the strap |
| `G_AllocateVehicleObject` | `AnimalNPC.c:912`, `FighterNPC.c:2002`, `SpeederNPC.c:1099`, `WalkerNPC.c:602` | 4 | no | a new callback, `g_utils.c:388` |
| the 14 game-only functions of the setter stores | `AnimalNPC.c:859-876`, `FighterNPC.c:1950-1967`, `SpeederNPC.c:1046-1063`, `WalkerNPC.c:549-566` | 15 stores | no | four `ARM_HOOKS` entries, row V8 |
| the `Ghost` and `Inhabited` slots | `FighterNPC.c:109`, `:112`, `:315`, `:330`, `:577`, `:729`, `:1760` | 7 | not a channel name | the test alone, row V5 |

So shape A puts 10 game names on the arms: 5 reuse a channel entry, and 5 are new, `G_EntitySound`, `FighterIsInSpace`, the `client->ps.origin` read, `G_AllocateVehicleObject`, and the setter arm hooks counted as one class of four. The cgame needs one new foreign trap, `trap_S_StartSound`.

Inside the 15 game-only functions, from the Swift bodies: `level.time` 8 times, `Vehicle_SetAnim` 6 times, `RegisterItem`, `g_gravity`, `G_VehicleTrace`, and `G_EntitySound` once each, and the `gentity_t` fields `health`, `client->ps.legsAnim`, `client->ps.legsTimer`, `client->ps.speed`, `client->ps.m_iVehicleNum`, `r.mins`, `r.maxs`, and `client->inSpaceIndex`. These need no channel entry under shape B, or under the split form of shape A. A whole-file move under shape A puts each of them on the channel.

No line of the four files reads `g_entities`. The one mention is Raven's comment `//&g_entities[parent->r.ownerNum];` beside `PM_BGEntForNum`, for example `AnimalNPC.swift:257`.

## How jka-rust did it

Citations into the submodule `jka-rust/` at 1cb6c525.

- The shared half in bg: `jka-rust/crates/mp/bg/src/vehicles/mod.rs:9-17`, with one file per class, `animal_npc.rs:1-8`, `fighter_npc.rs:1-19`, `speeder_npc.rs:1-13`, and `walker_npc.rs:1-9`.
- The game-only half in the game crate: `jka-rust/crates/mp/game/src/AnimalNPC.rs:1-7`, beside `FighterNPC.rs`, `SpeederNPC.rs`, and `WalkerNPC.rs`.
- The host on the bg state: `jka-rust/crates/mp/bg/src/bg_channel/bg_state.rs:74`, `:208`.
- The host tests at the consumer chains: `curTime` at `animal_npc.rs:29-35`, `speeder_npc.rs:68-74`, and `fighter_npc.rs:910-916`. The turbo effect at `speeder_npc.rs:90-97`. The `Inhabited` clauses at `fighter_npc.rs:175-185`. `FighterSuspended` at `fighter_npc.rs:217-232`. The crash at `fighter_npc.rs:411-416`. The gravity block at `fighter_npc.rs:837-839`. The tumble at `fighter_npc.rs:1105-1106`.
- The `Ghost` loop of `BG_FighterUpdate` moved into the game's `Update` wrapper: `fighter_npc.rs:16-19`.
- The callbacks it added for the game names: `fighter_is_landed`, `entity_sound`, `fighter_is_in_space`, `veh_turbo_start_fx`, and `veh_fighter_crash_suicide` at `jka-rust/crates/mp/bg/src/bg_channel/game_callbacks.rs:287`, `:294`, `:301`, `:309`, and `:318`, with `entity_spawnflags` at `:274` and `get_time` at `:162`. The game implements them at `jka-rust/crates/mp/game/src/bg_channel/game_impl.rs:976`, `:986`, `:1001`, `:1010`, and `:1077`. The cgame implements them as inert or unreachable at `jka-rust/crates/mp/cgame/src/bg_channel/cg_game_callbacks.rs:315`, `:321`, `:328`, `:334`, and `:340`.
- No slots: the shared functions run through a dispatch on the vehicle type (`veh_process.rs:22-43`), called from `bg_pmove.rs:1753` and `:1760`.
- The cgame `G_Create*NPC`: `jka-rust/crates/mp/cgame/src/vehicle_npc.rs:26-52`.
- One open gap: the cgame arm of the hyperspace sound, `FighterNPC.c:418-422`, is a marker at `fighter_npc.rs:557`.
- Two differences from Raven's build. jka-rust keeps `AnimalProcessOri` and `FighterPitchClamp` in the game crate (`AnimalNPC.rs:6`, `fighter_npc.rs:8-10`), but Raven compiles both under `#ifdef _JK2MP` for both consumers (`AnimalNPC.c:466-471`, `FighterNPC.c:1091-1372`). Neither has a live caller in Raven's tree.

## What OpenJK does

OpenJK is at `~/Developer/Milo/OpenJK` at 35e4184f. It keeps Raven's two compiles: the cgame lists the four files (`codemp/cgame/CMakeLists.txt:33-48`) with `_CGAME` defined, and the game lists them with `_GAME` (`codemp/game/CMakeLists.txt:38`, `:49`, `:115`, `:119`).

- It drops the `_JK2MP` and SP arms, so the files hold 53 consumer chains: 9, 24, 12, and 8.
- It spells the `curTime` chains `#ifdef _GAME` / `#elif defined(_CGAME)` (`codemp/game/AnimalNPC.c:122-127`) or `#elif _CGAME` (`codemp/game/FighterNPC.c:1291-1296`, `codemp/game/SpeederNPC.c:116-121`, `:409-414`).
- It keeps the cgame hyperspace sound through its trap table, `trap->S_StartSound` (`codemp/game/FighterNPC.c:326-330`).
- It keeps the cgame `AttachRiders` stores (`codemp/game/FighterNPC.c:1799-1801`, `codemp/game/WalkerNPC.c:475-477`) and the cgame `BG_Alloc` arms (`codemp/game/FighterNPC.c:1817-1827`, `codemp/game/WalkerNPC.c:496-506`).
- It adds a cgame include, `cgame/cg_local.h`, under `#elif _CGAME` (`codemp/game/FighterNPC.c:26-30`).
- Inside the game-only `AnimateVehicle`, it writes `int curTime = level.time;` with no chain (`codemp/game/FighterNPC.c:1692`).

## The ledger

The user delegated the eleven rows to the coordinator on 2026-10-29, and the coordinator read the cited lines of every row in all four trees before the rulings. Every row is ratified as proposed, so the four files compile a second time in `JKAMP_CGameLogic`, shape B.

| Row | Verdict | Date |
|---|---|---|
| V1. The shape | ratified as proposed | 2026-10-29 |
| V2. Header, extern, and declaration selectors | ratified as proposed | 2026-10-29 |
| V3. Not compiled in the release build | ratified as proposed | 2026-10-29 |
| V4. Whole functions only the game compiles | ratified as proposed | 2026-10-29 |
| V5. A game arm with no cgame arm | ratified as proposed | 2026-10-29 |
| V6. Two arms that differ | ratified as proposed | 2026-10-29 |
| V7. The cgame `AttachRiders` stores | ratified as proposed | 2026-10-29 |
| V8. The game arms of the four setters | ratified as proposed | 2026-10-29 |
| V9. What the cgame calls, and the cgame install | ratified as proposed | 2026-10-29 |
| V10. The generator rows | ratified as proposed | 2026-10-29 |
| V11. The gate | ratified as proposed | 2026-10-29 |
