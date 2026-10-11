# Review of the frame-path round, wave 1 (619bed8)

| File | Function | Finding | Severity | Raven line | Swift line |
|---|---|---|---|---|---|
| g_cmds | SanitizeString | The fill writes `out[outIndex] = 0` through a new write cursor `outIndex`, but no statement steps the cursor, because the `while ( *in )` loop above it stays a hole. The result is correct only when the loop fill also steps `outIndex` at Raven's `*out++`. | style | oracle/codemp/game/g_cmds.c:174 | Sources/JKAMP_GameLogic/g_cmds.swift:195, 201 |
| g_cmds | Cmd_CallTeamVote_f | The two `Com_sprintf` fills into `level.teamVoteString[cs_offset]` format into a local `CharBuf(1024)` and then store `String(teamVoteString)` into the `Slots<String>` element. The guide gives a buffer writer the `<name>Buffer` accessor of a `char name[N]` field, and it gives no form for an element of a `char[2][N]` field. The literal `1024` stands for Raven's `sizeof( level.teamVoteString[cs_offset] )`. The behavior is the same, because the text is under 1024 bytes and the setter writes it with its NUL. | form | oracle/codemp/game/g_cmds.c:2326, 2330 | Sources/JKAMP_GameLogic/g_cmds.swift:2233-2235, 2238-2240 |
| g_items | pas_find_enemies | The fill writes `Float(TURRET_RADIUS)` at the `radius` argument of `G_RadiusList`, and Raven wrote no cast. C converts the `int` macro at the call. The guide gives `Float(...)` for an `int` at a store and in a float table, not at an argument. The value is the same. | form | oracle/codemp/game/g_items.c:570 | Sources/JKAMP_GameLogic/g_items.swift:653 |

## Files with no finding

- `NPC_spawn`, `NPC_stats`, and `g_ICARUScb`: the sixteen `GetIDForString` fills pass the table by name as a `Slots`, keep Raven's casts, and keep his trailing comments. `NPC_ParseParms` lifts `NPC->client->playerTeam = NPC->s.teamowner = ...` inner store first.
- `g_combat`: `obit` is a `String` local, and Raven sets it on both arms before any read.
- `g_main`: `CheckVote` passes `nextMap!` under Raven's test.
- `g_utils`: `G_PickTarget` uses the struct-pointer array form, lifts `choice[num_choices++]`, and the bare `rand()` resolves to `JKAMP_BG.rand()` in the built object.
- `g_session`: `level.clientsSlots.index(of: client)` is the `Slots` index form, and the three byte loops use the `Buffer` accessors with Raven's comment.
- `g_team`: the four `G_Find` loops follow the `while let` and break-loop forms. `SelectRandomTeamSpawnPoint` keeps Raven's `return spots[ selection ]` in the class arm, where `classSpots` was likely his intent. jka-rust records the same read.
- `g_mover`: the `NULL` `dir` fills use `var dir: vec3_t? = nil`, the `vec3_origin` fill passes a copy under the one-line comment, `*obstacle = check` stores into the `inout Entity?`, and the `G_Find` loops and calls follow the guide.
- `w_saber`: `fList` walks `faces` by an index local, as the `G_Find` form does. The `goto blockStuff` restructure moves the label's statements into a nested function that both arms return. Both arms reach `return didHit` after the chain in Raven, so the control flow is the same. The `dmg *= 1.5`, `0.7`, and `0.5` stores compute in double, `dmg *= 0.2f` computes in float, and the `#ifndef FINAL_BUILD` prints stay, because the build defines no `FINAL_BUILD`.
- `g_items` other than `pas_find_enemies`: the `NULL` trace bounds are `vec3_origin` with no comment, the `NULL` `AngleVectors` outputs carry the plain comment, `g2radius = Int32(30.0)` is the float-to-int store form, `ItemUse_Seeker` lifts the compound store, and `RespawnItem` stores `master!` and `ent.teamchain!` where Raven reads through them.
- `g_active`, `g_client`, `g_weapon`, and `NPC_utils`: the commit changes no line in these files.
