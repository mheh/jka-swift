# The bg consumer docket

This record holds the docket for stage 3 of the MP cgame work: the bg module for a second consumer. `JKAMP_BG` is one module, compiled once and shared by the game, cgame, and ui (rule 23, `docs/porting-rules.md:48`). Raven compiled each `oracle/codemp/game/bg_*.c` file once per consumer and picked the arms with the preprocessor. This record proves, for every consumer conditional in Raven's bg files, what the Swift body holds today. Each row is one class of conditional, with the proposed form and its reason. Every row is proposed and waits for its own ruling. No Sources, docs, or tools file changed for this record.

## The count

The unit is one conditional chain, `#if` to `#endif`, whose `#if` or any `#elif` names `QAGAME`, `CGAME`, `UI_EXPORTS`, or `WE_ARE_IN_THE_UI`. A nested chain counts once for each level. The bg files hold 125 chains in 9 files. `bg_lib.c` and `bg_weapons.c` hold none. The scout's number 129 at `notes/2026-10-29/cgame-scout.md:234` counts directive lines, not chains, so the two numbers do not have to agree.

The Swift bg files hold 12 `bg.consumer` tests: `Sources/JKAMP_BG/bg_pmove.swift:3477`, `:3930`, `:4131`, `:5127`, `:5139`, `:5147`, `:5276`, `:5289`, and `Sources/JKAMP_BG/bg_misc.swift:165`, `:186`, `:1085`, `:1641`. Each of the 12 matches one Raven chain.

The kinds:

- (a) The Swift body carries Raven's arms under a `bg.consumer` test.
- (b) The Swift body carries the game arm only. The cgame or ui arm is absent, or the game arm runs for every consumer with no test.
- (c) The chain selects a header, a declaration, an extern, or a value, and not a statement. No arm is needed.
- (d) The chain guards whole functions that one or two consumers compile.
- (e) The release build does not compile the chain: it is inside a comment, inside `#ifdef _DEBUG`, or inside `#ifdef _TESTING_VEH_PREDICTION`.

| File | (a) | (b) | (c) | (d) | (e) | Total |
|---|---|---|---|---|---|---|
| `bg_g2_utils.c` | 0 | 0 | 4 | 0 | 0 | 4 |
| `bg_misc.c` | 4 | 0 | 8 | 1 | 1 | 14 |
| `bg_panimate.c` | 0 | 2 | 2 | 1 | 0 | 5 |
| `bg_pmove.c` | 8 | 9 | 8 | 1 | 4 | 30 |
| `bg_saber.c` | 0 | 5 | 1 | 0 | 0 | 6 |
| `bg_saberLoad.c` | 0 | 13 | 1 | 0 | 0 | 14 |
| `bg_saga.c` | 0 | 3 | 1 | 1 | 0 | 5 |
| `bg_slidemove.c` | 0 | 7 | 7 | 1 | 1 | 16 |
| `bg_vehicleLoad.c` | 0 | 25 | 5 | 1 | 0 | 31 |
| Total | 12 | 64 | 37 | 6 | 6 | 125 |

The 64 (b) chains fall in four classes, rows C3 to C6: 13 game arms with no test where Raven gives cgame nothing, 38 asset registrations, 11 logic arms, and 2 ui arms.

## Facts every row uses

Rule 23. "A bg body spells Raven's `#ifdef QAGAME` as `if bg.consumer == .game { ... } else { ... }`, with both arms on the page" (`docs/porting-rules.md:48`, `docs/transcription.md:571`). A game function a bg body calls is a bare function that forwards to a closure on `BgState` (`docs/porting-rules.md:48`). A game arm that reads the game's tables is one callback in `ARM_HOOKS` (`docs/transcription.md:488`, `tools/oracle-closure/rulings.py:416-419`, R30 of `notes/2026-10-05/walk.md:10`). A function Raven compiles only under `QAGAME` is in `QAGAME_ONLY` (`docs/transcription.md:489`, `rulings.py:437`, R31 of `notes/2026-10-05/walk.md:11`). A game field a bg body reads is one read callback (`docs/transcription.md:490-494`). A cgame-only name is on the channel, and `installBgChannel()` skips it (`docs/transcription.md:483-484`).

The consumer. `BgConsumer` has the cases `.game`, `.cgame`, and `.ui` (`Sources/JKAMP_BG/bg_local.swift:10-14`). `BgState.consumer` is a `let` (`bg_local.swift:48`), set in `init(consumer:maxPoolSize:)` (`bg_local.swift:339-343`). The game builds `BgState(consumer: .game, maxPoolSize: 3_000_000)` at `Sources/jampgame/jampgame.swift:17`. The game install is `installBgChannel()` at `Sources/JKAMP_GameLogic/Generated/BgChannel.swift:9`. The game's arm hooks are at `Sources/JKAMP_GameLogic/bg_pmove_game.swift:11`, `:52`, and `:77`.

The default. Every closure on `BgCallbacks` traps with "No consumer installed" when no consumer installs it, for example `Sources/JKAMP_BG/Generated/bg_callbacks.swift:133`. So a game arm with no test calls a closure that a cgame consumer must install, or the cgame traps.

The release build. `JK2_cgame.vcproj` defines `CGAME` and not `QAGAME` (`oracle/codemp/cgame/JK2_cgame.vcproj:32` and `:106`). `bg_vehicleLoad.c:3-7` defines `_JK2MP` under `_JK2`, so the `#ifndef _JK2MP` arms of that file are dead and the `#elif QAGAME` and `#elif CGAME` arms are live.

The drafter. The bodies are adopted, and the drafter reads the game parse only (`notes/2026-10-29/cgame-scout.md:230`). A new draft never writes a cgame arm. Every edit of rows C3 to C6 is a hand edit of an adopted body.

The AI comment. Rule 24 (`docs/porting-rules.md:71`) puts an `AI:` line only where a ruling changes Raven's form. A `bg.consumer` test that carries Raven's arms keeps Raven's form, so the rows below add no `AI:` line. Rule 19 (`docs/porting-rules.md:44`) applies only to row C4 item 4.

## C1. Header, declaration, and value selectors (kind c, 37 chains)

Ratified as proposed on 2026-10-29.

The sites. The include selectors at `bg_g2_utils.c:9-21` (4), `bg_misc.c:9-21` (4), `bg_panimate.c:9-18` (2), `bg_pmove.c:12-14`, `bg_saber.c:987-997`, `bg_slidemove.c:9-11`, and `bg_vehicleLoad.c:30-35` (2), which defines `WE_ARE_IN_THE_UI` for the ui. The extern selectors at `bg_misc.c:28-30`, `:341-345`, `:3190-3196`, `bg_pmove.c:18-22`, `:637-639`, `:711-714`, `:5827-5831`, `bg_saberLoad.c:20-28`, `bg_saga.c:28-30`, `bg_slidemove.c:24-27`, `:37-39`, `:41-44`, and `bg_vehicleLoad.c:42-66`, `:95-101`. The `_XBOX` selectors at `bg_pmove.c:7782-7801` and `bg_vehicleLoad.c:75-89`: the PC build compiles the first arm for every consumer, and the Swift bodies are at `bg_pmove.swift:6772` and `bg_vehicleLoad.swift:54`. The local declarations at `bg_pmove.c:5671-5673` (Swift `bg_pmove.swift:5121`, with its comment at `:5120`), `bg_pmove.c:10927-10929` (Swift `bg_pmove.swift:9203`), and `bg_slidemove.c:148-152` (Swift `bg_slidemove.swift:80`). The cgame `hitEnt` declarations at `bg_slidemove.c:159-161` and `:187-189` initialize the same entity from `PM_BGEntForNum(trace->entityNum)`, and the one Swift `hitEnt` at `bg_slidemove.swift:18` reads `pm.entity(at: trace.entityNum)` (`Sources/JKAMP/Generated/Views/Pmove.swift:65`) for every consumer. The value selector `MAX_POOL_SIZE` at `bg_misc.c:3311-3317` is `bg.maxPoolSize` (`bg_local.swift:51`, `:373`), with the hand line at `bg_misc.swift:1663-1664`.

Proposed form. No change at the sites. The cgame passes Raven's cgame value to its own `BgState(consumer: .cgame, maxPoolSize: 2_048_000)`, from `bg_misc.c:3314`. The ui value is 512000 (`bg_misc.c:3316`).

Generator rows. None.

## C2. Faithful tests (kind a, 12 chains)

Ratified as proposed on 2026-10-29.

| Raven | Swift | Raven's arms |
|---|---|---|
| `bg_misc.c:372-376` | `bg_misc.swift:165-169` | two |
| `bg_misc.c:396-415` | `bg_misc.swift:186-190` | game only, the Swift `else` holds one comment |
| `bg_misc.c:2403-2407` | `bg_misc.swift:1085-1089` | two |
| `bg_misc.c:3202-3223` | `bg_misc.swift:1641-1660` | two |
| `bg_pmove.c:3758-3760` | `bg_pmove.swift:3477-3480` | game only, the Swift `else` is empty |
| `bg_pmove.c:4234-4263` | `bg_pmove.swift:3930-3939` | game only, through `bgLandOnVehicle` (R30) |
| `bg_pmove.c:4448-4456` | `bg_pmove.swift:4131-4133` | game only, through `bgSetSolidHack` (R30) |
| `bg_pmove.c:5678-5683` | `bg_pmove.swift:5127-5131` | game only |
| `bg_pmove.c:5691-5696` | `bg_pmove.swift:5139-5143` | game only |
| `bg_pmove.c:5700-5733` | `bg_pmove.swift:5147-5172` | game only |
| `bg_pmove.c:5839-5843` | `bg_pmove.swift:5276-5280` | two, the cgame arm calls `CG_GetVehicleCamPos` |
| `bg_pmove.c:5852-5858` | `bg_pmove.swift:5289-5295` | two |

Proposed form. No change. The empty `else {}` at `bg_pmove.swift:3479-3480` is the one form that differs from its neighbours, which close the `if` with no `else`.

Generator rows. None.

## C3. A game arm with no test, where Raven gives cgame nothing (kind b, 13 chains)

Ratified as proposed on 2026-10-29.

Raven's chain is `#ifdef QAGAME` with no `#else`. The Swift body writes the game arm with no test, so a cgame consumer runs the game arm. Each site calls a game closure that the cgame does not have in Raven, or a read closure over the game's tables.

| Raven | Swift | What the Swift arm calls |
|---|---|---|
| `bg_panimate.c:2610-2616` | `bg_panimate.swift:1636-1640` | `bgEntityLegsAnim` |
| `bg_panimate.c:2677-2683` | `bg_panimate.swift:1702-1706` | `bgEntityTorsoAnim` |
| `bg_pmove.c:776-783` | `bg_pmove.swift:667-671` | `G_AddEvent` |
| `bg_pmove.c:842-847` | `bg_pmove.swift:732-734` | `G_PlayEffectID` |
| `bg_pmove.c:6649-6664` | `bg_pmove.swift:5963-5972` | `bgEntityInuse` |
| `bg_pmove.c:7395-7404` | `bg_pmove.swift:6518-6522` | `G_CheapWeaponFire` |
| `bg_pmove.c:10887-10901` | `bg_pmove.swift:9177-9183` | `bgEntitySpawnflags`, the vehicle `Board` |
| `bg_pmove.c:10919-10922` | `bg_pmove.swift:9200-9203` | the vehicle `Update` and `Animate` |
| `bg_saber.c:1118-1121` | `bg_saber.swift:774-775` | `NPC_SetAnim` |
| `bg_slidemove.c:128-133` | `bg_slidemove.swift:66-70` | no call, the `else` of the landing test |
| `bg_slidemove.c:313-398` | `bg_slidemove.swift:202-270` | `FighterIsLanded`, `bgEntitySpawnflags` |
| `bg_slidemove.c:724-732` | `bg_slidemove.swift:536-541` | `PM_ClientImpact` |
| `bg_vehicleLoad.c:685-688` | `bg_vehicleLoad.swift:269` | `G_SetSharedVehicleFunctions` |

What the cgame arm does. Nothing: Raven compiles no statement for cgame at these sites. At `bg_panimate.c:2610` and `:2677` the `else if` is absent, so cgame tests `ps->legsAnim == anim` alone. At `bg_slidemove.c:128-133` cgame always returns from the landing branch.

Proposed form. The rule 23 test, `if bg.consumer == .game { ... }`, around Raven's arm, as at `bg_pmove.swift:4131`. Where Raven's arm is an `else if` clause, the test joins its condition: `} else if bg.consumer == .game && bgEntityLegsAnim(of: ps.clientNum) == anim {`. The closures stay game closures, and the cgame installs none of them.

Reason. Rule 23 names the test as the form of `#ifdef QAGAME`. A cgame install of a no-op closure would give the same behavior at a leaf call, but at `bg_slidemove.c:128` and `bg_panimate.c:2610` the arm is control flow, and a closure cannot remove a branch. One form for all 13 keeps the arm visible at the site.

Alternative. jka-rust's split: control flow branches on the host, and a leaf call stays on the callback, which each consumer implements (`jka-rust/crates/mp/bg/src/bg_channel/bg_host.rs:3-7`). It is not proposed, because rule 23 has one form.

Generator rows. None. The edits are hand edits of adopted bodies.

## C4. Asset registration arms (kind b, 38 chains)

Ratified as proposed on 2026-10-29.

The game arm takes an index (`G_ModelIndex`, `G_SoundIndex`, `G_EffectIndex`) or skips the value. The cgame arm registers the asset with a `trap_R_`, `trap_S_`, or `trap_FX_` trap. The Swift body holds the game arm only.

| Raven | Swift | Arms |
|---|---|---|
| `bg_saberLoad.c:34-38`, `BG_SoundIndex` | `bg_saberLoad.swift:32-34` | game `G_SoundIndex`, cgame `trap_S_RegisterSound`, no ui arm |
| `bg_saberLoad.c:1804-1810`, `:1822-1828`, `:2215-2221`, `:2233-2239` | `bg_saberLoad.swift:1421`, `:1431`, `:1727`, `:1737` | game and ui `SkipRestOfLine`, cgame `trap_R_RegisterShader` |
| `bg_saberLoad.c:2073-2079`, `:2090-2096`, `:2107-2113`, `:2124-2130`, `:2484-2490`, `:2501-2507`, `:2518-2524`, `:2535-2541` | `bg_saberLoad.swift:1631`, `:1640`, `:1649`, `:1658`, `:1937`, `:1946`, `:1955`, `:1964` | game and ui `SkipRestOfLine`, cgame `trap_FX_RegisterEffect` |
| `bg_saga.c:997-1009` | `bg_saga.swift:773-800` | game `classShader = 0`, cgame and ui `trap_R_RegisterShaderNoMip` with a print on failure |
| `bg_saga.c:1268-1275` | `bg_saga.swift:1020` | `#ifdef CGAME`, cgame `trap_R_RegisterShaderNoMip`, game and ui 0 |
| `bg_vehicleLoad.c:232-236`, `:906-910`, `VF_MODEL` | `bg_vehicleLoad.swift:118`, `:475` | game `G_ModelIndex`, cgame and ui `trap_R_RegisterModel` |
| `bg_vehicleLoad.c:239-245`, `:913-919`, `VF_MODEL_CLIENT` | `bg_vehicleLoad.swift:120-122`, `:477-479` | game a comment, cgame and ui `trap_R_RegisterModel` |
| `bg_vehicleLoad.c:248-252`, `:922-926`, `VF_EFFECT` | `bg_vehicleLoad.swift:125`, `:482` | game `G_EffectIndex`, cgame `trap_FX_RegisterEffect`, no ui arm |
| `bg_vehicleLoad.c:255-261`, `:929-935`, `VF_EFFECT_CLIENT` | `bg_vehicleLoad.swift:127-129`, `:484-486` | game a comment, cgame `trap_FX_RegisterEffect`, no ui arm |
| `bg_vehicleLoad.c:264-268`, `:938-942`, `VF_SHADER` | `bg_vehicleLoad.swift:131-132`, `:488-489` | no game arm, cgame `trap_R_RegisterShader`, ui `trap_R_RegisterShaderNoMip` |
| `bg_vehicleLoad.c:271-273`, `:945-947`, `VF_SHADER_NOMIP` | `bg_vehicleLoad.swift:134-135`, `:491-492` | `#ifndef QAGAME`, cgame and ui `trap_R_RegisterShaderNoMip` |
| `bg_vehicleLoad.c:276-280`, `:950-954`, `VF_SOUND` | `bg_vehicleLoad.swift:138`, `:495` | game `G_SoundIndex`, cgame and ui `trap_S_RegisterSound` |
| `bg_vehicleLoad.c:283-289`, `:957-963`, `VF_SOUND_CLIENT` | `bg_vehicleLoad.swift:140-142`, `:497-499` | game a comment, cgame and ui `trap_S_RegisterSound` |
| `bg_vehicleLoad.c:392-408`, the homing sounds | `bg_vehicleLoad.swift:225-230` | game comments, cgame and ui five `trap_S_RegisterSound` |
| `bg_vehicleLoad.c:1264-1268` | `bg_vehicleLoad.swift:713-715` | game `G_ModelIndex`, cgame and ui `trap_R_RegisterModel` |
| `bg_vehicleLoad.c:1293-1299`, inside the live `#else` of `_JK2MP` | none, `bg_vehicleLoad.swift:716-721` holds the SP comments | cgame and ui `trap_R_RegisterSkin` |
| `bg_vehicleLoad.c:1308-1312` | `bg_vehicleLoad.swift:727-729` | game `G_EffectIndex`, cgame `trap_FX_RegisterEffect`, no ui arm |
| `bg_vehicleLoad.c:1316-1322` | `bg_vehicleLoad.swift:730-732` | game `G_SoundIndex`, cgame and ui `trap_S_RegisterSound` |
| `bg_vehicleLoad.c:1327-1333` | `bg_vehicleLoad.swift:734-736` | game `G_EffectIndex`, cgame `trap_FX_RegisterEffect`, no ui arm |
| `bg_vehicleLoad.c:1336-1359` | `bg_vehicleLoad.swift:738-740` | game two effects and one sound, cgame 15 registrations, no ui arm |

The traps are on the channel already: `trap_R_RegisterModel`, `trap_R_RegisterShader`, `trap_R_RegisterShaderNoMip`, `trap_S_RegisterSound`, and `trap_FX_RegisterEffect` at `Sources/JKAMP_BG/Generated/bg_strap.swift:61`, `:79`, `:82`, `:85`, `:91`, each citing `oracle/codemp/cgame/cg_syscalls.c`. `trap_R_RegisterSkin` is at `bg_strap.swift:88`.

Proposed form.

1. A two-arm chain on `QAGAME` is the rule 23 test with both arms: `if bg.consumer == .game { b[int: ofs] = G_ModelIndex(value) } else { b[int: ofs] = trap_R_RegisterModel(value) }`. A game arm that is only a comment keeps the comment in the `.game` arm.
2. A chain with a separate ui arm, or with a `CGAME` test, is a `switch bg.consumer` with one `case` per Raven arm, in Raven's order. `case .game, .ui:` stands where Raven's `#else` covers both. This needs one sentence in rule 23 and in `docs/transcription.md:571`, because the rule names only `if bg.consumer == .game`.
3. A chain with no arm for a consumer writes an empty `case` with no comment, as `case .game: break`.
4. `BG_SoundIndex` has no ui arm and no `return` for the ui (`bg_saberLoad.c:34-38`). The ui reads an undefined value. The rule 19 form is the `.ui` case with a `Port-note:` line and the value 0. OpenJK gives the ui the cgame arm (`~/Developer/Milo/OpenJK/codemp/game/bg_saberLoad.c:42-46`).

Reason. The arms differ in the call and in the value that lands in the field, so one closure per index function cannot stand for them. A cgame install of `G_ModelIndex` that calls `trap_R_RegisterModel` would give the right value at 6 sites and the wrong one at the 6 `_CLIENT` sites, where the game writes nothing and cgame registers.

Alternative. jka-rust's per-arm callback: one method per site class that each consumer implements, `veh_field_model` and its siblings (`jka-rust/crates/mp/bg/src/bg_channel/game_callbacks.rs:323-400`). It moves the arms out of the bg body into the consumers, against rule 23. It is not proposed.

Generator rows. None. The rule 23 sentence of item 2 is a doc row.

## C5. Logic arms that differ for cgame (kind b, 11 chains)

Ratified as proposed on 2026-10-29.

| Raven | Swift | Raven's cgame arm |
|---|---|---|
| `bg_pmove.c:6699-6712` | `bg_pmove.swift:6000-6004` | sets `vehicleRocketLock` and clears only `BUTTON_ATTACK` when either vehicle weapon is homing |
| `bg_pmove.c:7478-7488`, inside the live `#else` of `#if 0` at `:7447` | `bg_pmove.swift:6559-6563` | `return` |
| `bg_pmove.c:10944-11019` | `bg_pmove.swift:9213-9240`, with Raven's cgame comments left at `:9234-9240` and no statements | `BG_FighterUpdate`, sets the pilot, the orientation commands, `PM_SetPMViewAngle`, the move direction |
| `bg_saber.c:1172-1184` | `bg_saber.swift:823-829` | `PM_SetAnim` on the local player only |
| `bg_saber.c:1200-1204` | `bg_saber.swift:844` | `if ( duelist->clientNum == pm->ps->clientNum )` in place of `if ( 1 )` |
| `bg_saber.c:1213-1217` | `bg_saber.swift:852` | the same test |
| `bg_saber.c:4103-4138`, `BG_MySaber` | `bg_saber.swift:3155-3168` | reads `cgs.clientinfo[clientNum]` or `cg_entities[clientNum].npcClient`, tests `infoValid` |
| `bg_slidemove.c:55-107` | `bg_slidemove.swift:18-65` | no `hitEnt` early return, no death spiral, no `func_rotating`, only the landing test |
| `bg_slidemove.c:197-201` | `bg_slidemove.swift:104` | `hitEnt->s.origin` in place of `bgEntityCurrentOrigin` |
| `bg_slidemove.c:218-229` | `bg_slidemove.swift:126-133` | scales `bounceDir` into `bounceDir`, so `pushDir` stays zero |
| `bg_slidemove.c:402-554` | `bg_slidemove.swift:274-393` | `PM_BGEntForNum`, an owner test, `trap_FX_PlayEffectID`, `VEH_CRASHING` |

Proposed form. The rule 23 test with both arms on the page. A cgame arm that reads a cgame table, as `BG_MySaber` reads `cgs.clientinfo` and `cg_entities`, reads it through one read callback per field, in the shape of `docs/transcription.md:490-494`, which the cgame install defines. Raven's arm at `bg_slidemove.c:218-229` scales `bounceDir` and not `pushDir`. The cgame arm keeps that text, by the do-not-adulterate ruling, and OpenJK keeps it too (`~/Developer/Milo/OpenJK/codemp/game/bg_slidemove.c:270-271`).

Reason. These arms are control flow and differ by consumer, so rule 23 is the only form. The read callbacks follow the form the game arms already use (`bgClientSaber` at `bg_callbacks.swift:106`, `bgEntityAtInuse` at `:115`).

Alternative for `BG_MySaber`. Keep one body and let the cgame install `bgEntityAtInuse` and `bgClientSaber` over `cgs.clientinfo` with Raven's cgame arm, `infoValid` and `npcClient` included. jka-rust takes this shape with one `my_saber` method per consumer (`jka-rust/crates/mp/bg/src/bg_channel/game_callbacks.rs:209-212`, `jka-rust/crates/mp/game/src/bg_channel/game_impl.rs:863`, `jka-rust/crates/mp/cgame/src/bg_channel/cg_game_callbacks.rs:391`). It moves the cgame arm out of the bg body and gives the read callbacks two meanings. It is not proposed.

Generator rows. One `ARM_HOOKS`-like entry per cgame read callback, which `channel.py` writes into a cgame install. `channel.py:418-422` writes only the game install today (blocker 8 at `notes/2026-10-29/cgame-scout.md:313`).

## C6. ui-only arms (kind b, 2 chains)

Ratified as proposed on 2026-10-29.

`bg_saga.c:978-987` gives the game and cgame the same arm and the ui a register and a copy. The Swift body at `bg_saga.swift:764-767` holds the game arm. `bg_vehicleLoad.c:690-706` gives the game and cgame the switch of `G_Set*VehicleFunctions` and the ui nothing. The Swift body at `bg_vehicleLoad.swift:271-285` holds the switch. The ui arms of the three-arm chains of C4 are in the same position.

Proposed form. No change in this stage. Both sites are right for the cgame. The ui arms land in the ui stage, in the `switch` form of C4 item 2. A site that C4 edits takes its ui case in the same edit.

Generator rows. None.

## C7. Whole functions one or two consumers compile (kind d, 6 chains)

Ratified as proposed on 2026-10-29.

| Raven | Consumers | In `JKAMP_BG` today |
|---|---|---|
| `bg_panimate.c:1756-2328`, `#ifndef QAGAME` | cgame, ui | absent: `animEventTypeTable` `:1758`, `footstepTypeTable` `:1772`, `CheckAnimFrameForEventType` `:1782`, `ParseAnimationEvtBlock` `:1800`, `bgAllEvents` `:2166`, `bgNumAnimEvents` `:2167`, `BG_ParseAnimationEvtFile` `:2169` |
| `bg_pmove.c:3683-3723`, `PM_CrashLandEffect` | game | not a bg body. It is in `QAGAME_ONLY` (`rulings.py:437`) and in `Sources/JKAMP_GameLogic/bg_pmove_game.swift:11`, through the channel at `bg_callbacks.swift:97` |
| `bg_slidemove.c:588-624`, `PM_ClientImpact` | game | present at `bg_slidemove.swift:412`, with its game reads through `bgLevelTime`, `bgEntityContents`, and `Client_CheckImpactBBrush` |
| `bg_misc.c:335-425`, `BG_ParseField` and its externs | game, cgame | present at `bg_misc.swift:151`, public |
| `bg_saga.c:1358-1414`, `BG_PrecacheSabersForSiegeTeam` | game, cgame | present at `bg_saga.swift:1097`, public |
| `bg_vehicleLoad.c:1636-1665`, `AttachRidersGeneric` | game, cgame | present at `bg_vehicleLoad.swift:976`, public |

Proposed form.

1. The cgame and ui block of `bg_panimate.c:1756-2328` goes into `bg_panimate.swift` as bg bodies. `bgAllEvents` and `bgNumAnimEvents` go on `BgStorage` and `BgVariables`. `BG_ParseAnimationEvtFile` is `public`, because cgame calls it. The game never calls the block, so the bodies need no test.
2. `PM_ClientImpact` stays a bg body. Its one call site takes the C3 test at `bg_slidemove.swift:536-541`, so no cgame path reaches it.
3. The three game and cgame functions do not change. No ui caller exists, because no ui parse exists (`docs/transcription.md:145`).

Reason for item 1. The block is bg code that reads bg statics, and both Raven and jka-rust keep it in bg (`jka-rust/crates/mp/bg/src/bg_panimate.rs:2894`, `:2925`, `:3253`).

Reason for item 2. R31 makes a `QAGAME` function a game function, and `PM_ClientImpact` is the second such function. The body already reaches the game only through the channel, so it works in bg. The alternative is a second `QAGAME_ONLY` entry and a move to `bg_pmove_game.swift`, which R31 names. The record proposes item 2 and lists the R31 move as the alternative.

Generator rows. Item 1 needs the skeleton to read the cgame parse for the block (blocker 3 at `notes/2026-10-29/cgame-scout.md:308`). The R31 alternative of item 2 needs a `QAGAME_ONLY` entry at `rulings.py:437`.

## C8. Not compiled in the release build (kind e, 6 chains)

Ratified as proposed on 2026-10-29.

Inside a comment: `bg_pmove.c:647-652`, `:3450-3454`, `:10546-10550`, and `bg_slidemove.c:119-123`. Inside `#ifdef _DEBUG`: `bg_misc.c:2649-2653`. Inside `#ifdef _TESTING_VEH_PREDICTION`: `bg_pmove.c:10844-10853`. The Swift bodies keep the comments as text, for example `bg_slidemove.swift:58-64`, and carry no line for the two dead arms.

Proposed form. No change, by `docs/transcription.md:569`.

Generator rows. None.

## C9. The vehicle NPC files that cgame also compiles

Ratified as proposed on 2026-10-29.

`JK2_cgame.vcproj` compiles `AnimalNPC.c`, `FighterNPC.c`, `SpeederNPC.c`, and `WalkerNPC.c` from the game folder with `CGAME` defined. These files are outside `bg_*.c`, and they carry 71 consumer conditionals: 11, 36, 15, and 9 (`grep -cE` over `#if`, `#ifdef`, `#ifndef`, and `#elif` with `QAGAME` or `CGAME`). For example, `FighterNPC.c:185-197` keeps a block for the game only. The Swift files are in the game target: `Sources/JKAMP_GameLogic/AnimalNPC.swift`, `FighterNPC.swift`, `SpeederNPC.swift`, and `WalkerNPC.swift`. The bg channel reaches them through `BG_FighterUpdate`, `FighterIsLanded`, and the four `G_Set*VehicleFunctions` (`bg_callbacks.swift:10`, `:25`, `:61`, `:64`, `:70`, `:73`), each citing a game file. The cgame arm of `bg_pmove.c:10944-11019` calls `BG_FighterUpdate` at `:10966-10970`, and `BG_SetSharedVehicleFunctions` calls the four setters for cgame at `bg_vehicleLoad.c:690-706`.

jka-rust moved the four files into its bg crate: `jka-rust/crates/mp/bg/src/vehicles/animal_npc.rs:31`, `fighter_npc.rs:230`, and `speeder_npc.rs:11` and `:70`, with the host test of C10.

Proposed form. A separate docket, before the cgame install. This record does not prove the 71 chains. The two shapes are a move of the four files into `JKAMP_BG` with rule 23 tests, or a cgame compile of the same four files in the cgame target.

Generator rows. Not proposed here.

## The closures the cgame must install

From `notes/2026-10-29/cgame-scout.md:236-243`, checked against the cgame tree. The bg bodies of the cgame compile call 28 functions that a cgame `.c` file defines.

| Group | Names | cgame definition |
|---|---|---|
| Own hooks, `bg.error` and `bg.print` (`bg_local.swift:22`, `:29`) | `Com_Error`, `Com_Printf` | `cg_main.c:1234`, `:1245` |
| Callbacks | `BG_GetTime`, `CG_GetVehicleCamPos`, `CG_NewString` | `cg_main.c:1276`, `cg_view.c:797`, `cg_main.c:3344` |
| `strap_` | `strap_G2API_GetBoltMatrix`, `strap_G2API_GetBoltMatrix_NoRecNoRot`, `strap_G2API_SetBoneAngles`, `strap_G2API_SetBoneAnim`, `strap_G2API_GetBoneAnim`, `strap_G2API_AnimateG2Models`, `strap_G2API_SetBoneIKState`, `strap_G2API_IKMove` | `cg_strap.c:6`, `:18`, `:24`, `:31`, `:37`, `:48`, `:53`, `:58` |
| Traps | `trap_FS_FOpenFile`, `trap_FS_Read`, `trap_FS_FCloseFile`, `trap_FS_GetFileList`, `trap_FX_RegisterEffect`, `trap_FX_PlayEffectID`, `trap_G2API_AddBolt`, `trap_G2API_GetBoltMatrix`, `trap_G2API_GetSurfaceRenderStatus`, `trap_R_RegisterModel`, `trap_R_RegisterShader`, `trap_R_RegisterShaderNoMip`, `trap_R_RegisterSkin`, `trap_S_RegisterSound`, `trap_SnapVector` | `cg_syscalls.c:83`, `:87`, `:95`, `:99`, `:621`, `:637`, `:940`, `:791`, `:976`, `:266`, `:274`, `:278`, `:270`, `:229`, `:579` |

Beyond the 28, the cgame install needs these:

- The six vehicle closures of C9, which a cgame compile of the game folder files defines.
- The cvar view `bg.fighterAltControl` (`bg_local.swift:61`) over the cgame's own `bg_fighterAltControl` (`cg_main.c:770`, registered at `:953`).
- The cgame read callbacks of C5.
- `BgState(consumer: .cgame, maxPoolSize: 2_048_000)` at the cgame entry point (C1).

After C3, no cgame path reaches the game closures of the C3 table. Their trapping defaults stay, and a cgame call to one of them is a defect that the default names.

## The three `#ifndef QAGAME` functions absent from `JKAMP_BG`

| Function | Raven | Callers |
|---|---|---|
| `CheckAnimFrameForEventType` | `bg_panimate.c:1782` | `ParseAnimationEvtBlock` at `bg_panimate.c:1884` only |
| `ParseAnimationEvtBlock` | `bg_panimate.c:1800` | `BG_ParseAnimationEvtFile` at `bg_panimate.c:2304` and `:2309` only |
| `BG_ParseAnimationEvtFile` | `bg_panimate.c:2169`, declared at `bg_public.h:1630` | `cg_players.c:544`, `:556`, `:791`, `:6933`, `:7254`, and itself at `bg_panimate.c:2297` |

The block also holds `animEventTypeTable` and `footstepTypeTable` (`bg_panimate.c:1758`, `:1772`, declared at `bg_public.h:267-268`), `bgAllEvents`, and `bgNumAnimEvents` (`bg_panimate.c:2166-2167`). No Swift file under `Sources/JKAMP_BG` names any of the seven. Row C7 item 1 holds the proposed form.

## How jka-rust handled the consumer in its bg crate

Citations into the submodule `jka-rust/` at 1cb6c525.

- The host enum: `jka-rust/crates/mp/bg/src/bg_channel/bg_host.rs:3-20`.
- The host on the state: `jka-rust/crates/mp/bg/src/bg_channel/bg_state.rs:72-74`, `:200`, `:208`.
- The cgame state: `jka-rust/crates/mp/cgame/src/world/cg_world.rs:288`, with `MAX_POOL_SIZE_CGAME` at `jka-rust/crates/mp/bg/src/bg_misc.rs:1894`, and the game and ui values at `:1885` and `:1889`.
- The host tests in bg bodies: `jka-rust/crates/mp/bg/src/bg_pmove.rs:1664`, `:1696`, `:7144`, `:7760`, and `jka-rust/crates/mp/bg/src/bg_slidemove.rs:748`.
- The per-module arm callbacks: `jka-rust/crates/mp/bg/src/bg_channel/game_callbacks.rs:323-334`, with the methods at `:335-420`.
- The game implementation: `jka-rust/crates/mp/game/src/bg_channel/game_impl.rs:437`, `:863`, `:1113`, `:1153`, `:1172`.
- The cgame implementation: `jka-rust/crates/mp/cgame/src/bg_channel/cg_game_callbacks.rs:86`, `:391`, `:455`, `:460`, `:498`, `:541`.
- `BG_MySaber` through the callback: `jka-rust/crates/mp/bg/src/bg_pmove.rs:174-175`, `game_callbacks.rs:209-212`.
- `BG_SoundIndex` through the callback: `jka-rust/crates/mp/bg/src/bg_saberLoad.rs:404`.
- The saber parse with the game arm only: `jka-rust/crates/mp/bg/src/bg_saberLoad.rs:1785-1792`.
- The anim event block in bg: `jka-rust/crates/mp/bg/src/bg_panimate.rs:2894`, `:2925`, `:3253`.
- The vehicle NPC files in bg: `jka-rust/crates/mp/bg/src/vehicles/animal_npc.rs:31`, `fighter_npc.rs:185`, `:230`, `:414`, `speeder_npc.rs:11`, `:70`.

## Where OpenJK differs from Raven in a bg conditional

OpenJK is at `~/Developer/Milo/OpenJK` at 35e4184f. It spells the consumers `_GAME`, `_CGAME`, and `UI_BUILD`.

- `BG_SoundIndex` gives the ui the cgame arm: `codemp/game/bg_saberLoad.c:42-46`. Raven's ui has no `return` (`bg_saberLoad.c:34-38`).
- The anim event block is `#ifdef _CGAME` and not `#ifndef QAGAME`, so the ui does not compile it: `codemp/game/bg_panimate.c:1737`.
- `PM_VehicleImpact` tests `#elif defined(_CGAME)` where Raven has `#else`: `codemp/game/bg_slidemove.c:149`.
- The saber parse is one function per key, and each tests `#ifdef _CGAME` with an `#else`, for example `codemp/game/bg_saberLoad.c:1339-1349`. The game and ui arm stays `SkipRestOfLine`, as in Raven.
- `BG_EvaluateTrajectoryDelta` gets a per-consumer error text: `codemp/game/bg_misc.c:2333-2337`. Raven has one text.
- OpenJK adds consumer chains with no Raven counterpart: `BG_FixWeaponAttackAnim` at `codemp/game/bg_misc.c:324-332`, `BG_AreRunWalkAnimsFixed` at `codemp/game/bg_pmove.c:5165-5171`, `PM_Footsteps` at `:5431-5440`, `BG_FixSaberMoveData` at `codemp/game/bg_saber.c:352-358`, and a ui block at `codemp/game/bg_saberLoad.c:2291-2394`.
- The cgame arm of `bg_slidemove.c:218-229` keeps Raven's `bounceDir` text: `codemp/game/bg_slidemove.c:270-271`.

## The gate

A game run must not change. The C3 and C5 edits put the game arm under `bg.consumer == .game`, and the game's `BgState` has `.game`, so every game replay and the map change run of `notes/2026-10-29/game-pool-docket.md` give the same output. `swift build`, `swift test --no-parallel`, `tools/load-test.sh`, the tool tests, `draftcheck.py --every`, and `snapshot.py --check` are the rest of the gate.

A cgame run does not exist yet (blockers 9 to 11 at `notes/2026-10-29/cgame-scout.md:314-316`). A unit test can build `BgState(consumer: .cgame, ...)` with no cgame install and run `Pmove` on a test player. Before C3, the first game closure traps with its "No consumer installed" text. After C3, that path runs without a trap.

## The ledger

Every row was ratified as proposed on 2026-10-29, in one walk, one row per message. The coordinator read every cited line in both trees before each row, and two cites were short, corrected in the rows above.

| Row | Verdict | Date |
|---|---|---|
| C1. Header, declaration, and value selectors | ratified as proposed | 2026-10-29 |
| C2. Faithful tests | ratified as proposed | 2026-10-29 |
| C3. A game arm with no test, where Raven gives cgame nothing | ratified as proposed | 2026-10-29 |
| C4. Asset registration arms | ratified as proposed | 2026-10-29 |
| C5. Logic arms that differ for cgame | ratified as proposed | 2026-10-29 |
| C6. ui-only arms | ratified as proposed | 2026-10-29 |
| C7. Whole functions one or two consumers compile | ratified as proposed | 2026-10-29 |
| C8. Not compiled in the release build | ratified as proposed | 2026-10-29 |
| C9. The vehicle NPC files that cgame also compiles | ratified as proposed, a separate docket follows | 2026-10-29 |
