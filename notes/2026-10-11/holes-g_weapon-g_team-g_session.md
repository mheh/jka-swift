# Hole round: g_weapon, g_team, g_session

This record gives one verdict for each Port-note in the three files, in the order of each file.
The round filled 14 holes, left 13 holes that stand, and left 2 holes that are blocked.

## g_weapon.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| prox_mine_think | `G_RadiusList(..., ent_list)`, `Slots<Entity?>` to `[Entity?]` | stands | `ent_list` is the file-scope `Slots<Entity?>` of the guide, and `G_RadiusList` takes `inout [Entity?]`. No form passes a `Slots` to an `inout` array parameter. Docket row D7. |
| WP_CalcVehMuzzle | `mdxaBone_t boltMatrix;` | blocked | The form is `MdxaBone.scratch { boltMatrix in ... }` around the statements that follow. The closure must hold the trap call of the next row, so this fill waits for that row. |
| WP_CalcVehMuzzle | `trap_G2API_GetBoltMatrix_NoRecNoRot(..., &boltMatrix, ...)` | blocked | `lookup.py sig` has no row for the trap, so its Swift signature is outside the read set. |
| WP_CalcVehMuzzle | `BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, pVeh->m_vMuzzlePos[muzzleNum])` | stands | The write target `m_vMuzzlePos[muzzleNum]` is a `Slots<Float>` row of `Slots<Slots<Float>>`, and no form writes a `vec3_t` into that row. The signature of the hand function is also outside the read set. Docket row D8. |
| WP_CalcVehMuzzle | `BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, pVeh->m_vMuzzleDir[muzzleNum])` | stands | The same as the row above, for `m_vMuzzleDir`. Docket row D8. |
| FireVehicleWeapon | `VectorCopy( pVeh->m_vMuzzlePos[i], start )` | stands | The source is a `Slots<Float>` row, and no form reads it as a `vec3_t`. Docket row D8. |
| FireVehicleWeapon | `VectorCopy( pVeh->m_vMuzzleDir[i], dir )` | stands | The same as the row above, for `m_vMuzzleDir`. Docket row D8. |

## g_team.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Team_FragBonuses | assignment inside a `while` test | filled | The loop has a `break`, and the statement after the loop reads `flag`, so the fill takes the step-at-the-bottom form. |
| Team_ResetFlag | assignment inside a `while` test | filled | The `while let next` form. No statement after the loop reads `ent`, so no line follows the loop. |
| SelectRandomTeamSpawnPoint | local `gentity_t *spots[32]` | filled | `var spots = [Entity?](repeating: nil, count: Int(MAX_TEAM_SPAWN_POINTS))`, the declaration form of the struct-pointer array row. |
| SelectRandomTeamSpawnPoint | assignment inside a `while` test | filled | The `while let next` form. No statement after the loop reads `spot`. The `++count` lifts to `count += 1` before its test. |
| SelectRandomTeamSpawnPoint | no operator beside the operand | filled | `return G_Find(nil, \.classname, classname)`, with the key path of `FOFS`. |
| SelectRandomTeamSpawnPoint | local `gentity_t *classSpots[32]` | filled | The same declaration form as `spots`. |
| SelectRandomTeamSpawnPoint | read of `spots` | filled | `idealclass` is a `String?`. The NULL test is `!= nil`, and the truth test of `idealclass[0]` is `isEmpty`, as the guide gives for a text field. |
| SelectRandomTeamSpawnPoint | read of `spots` | filled | `return spots[selection]`, as Raven wrote it. Raven returns `spots` and not `classSpots` here. |
| SelectRandomTeamSpawnPoint | read of `spots` | filled | `return spots[selection]`. |
| SortClients | pointer dereference `*(int *)a - *(int *)b` | stands | The comparator reads through an untyped pointer, and no `Unsafe` type may appear in a logic target. Docket row D6. |
| TeamplayInfoMessage | `clients[cnt++] = level.sortedClients[i]` | stands | The guide lifts an assignment to a statement before the enclosing statement. A post-increment inside an index needs the old value, so that lift changes the slot. Docket row D5. |
| TeamplayInfoMessage | `qsort( clients, cnt, sizeof( clients[0] ), SortClients )` | stands | No form sorts a Swift array with a C comparator. Docket row D6. |

## g_session.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_WriteClientSessionData | `va(...)` with `qboolean` fields under `%i` | stands | `teamLeader` and `setForce` are `Bool` on the view, and `Bool` is not a `FormatArg`. Docket row D1. |
| G_WriteClientSessionData | `client - level.clients` | filled | `level.clientsSlots.index(of: client)`, the `Slots` index form, because the `%i` site takes an `Int32`. |
| G_ReadSessionData | `client - level.clients` | filled | The same form as the row above. |
| G_ReadSessionData | `sscanf` with 15 targets | stands | `Scan.swift` has one overload per target shape, and none takes this mixed format with `%s` targets. Docket row D2. |
| G_ReadSessionData | `while (client->sess.siegeClass[i])` | filled | The byte reads and writes go through the `siegeClassBuffer` accessor. Raven's comment stays. |
| G_ReadSessionData | `while (client->sess.saberType[i])` | filled | The same form, through `saberTypeBuffer`. |
| G_ReadSessionData | `while (client->sess.saber2Type[i])` | filled | The same form, through `saber2TypeBuffer`. |
| G_ReadSessionData | `client->sess.teamLeader = (qboolean)teamLeader` | stands | Raven's cast stays on the page, but `Bool(teamLeader)` has no initializer for an `Int32`. Docket row D3. |
| G_InitSessionData | `value[0] == 'r'` on a `String` local | stands | The guide gives the byte walk for a `String` parameter only. `value` is a local `String` that Raven reads by byte. Docket row D4. |
| G_InitSessionData | `value[0] == 's'` on a `String` local | stands | The same as the row above. The block also holds the `switch` on the game type, which ports once the test has a form. Docket row D4. |

## GameWorld properties

None. No fill in this round needs a static local or a file-scope static.

## Docket rows

- D1, `G_WriteClientSessionData`: Raven passes a `qboolean` to `%i`, and the view gives a `Bool`. No form converts it. Proposed form: `Bool` conforms to `FormatArg` in `Format.swift`, and `%i` and `%d` print it as `0` or `1`, as C does.
- D2, `G_ReadSessionData`: `sscanf` with twelve `%i` targets and three `%s` targets into `char[64]` fields. No overload takes this mixed format. Proposed form: a hand parse in the body with a `TextCursor` and `COM_Parse` per field, or a `Scan.swift` overload that returns the tokens as `[String]` with the count read.
- D3, `G_ReadSessionData`: Raven's `(qboolean)` cast of an `int`. No form spells it. Proposed form: `Bool(teamLeader)` through an `Int32` initializer in `JKAShared` that gives `teamLeader != 0`, so the cast stays on the page.
- D4, `G_InitSessionData`: a byte read of a `String` local, `value[0]`. The parameter form `let s1 = CharBuf(s1)` does not cover a local. Proposed form: a `String` local that the body reads by byte takes the `CharBuf` at its store, `value = CharBuf(Info_ValueForKey(userinfo, "team"))`, and `value[0] == Int32(ascii: "r")` reads the byte.
- D5, `TeamplayInfoMessage`: a post-increment inside an index, `clients[cnt++] = x`. The lift rule covers only a store before the enclosing statement. Proposed form: the statement uses the old value, `clients[cnt] = x`, and `cnt += 1` is the next statement.
- D6, `SortClients` and `TeamplayInfoMessage`: `qsort` of an `int` array with a comparator that dereferences `const void *`. Proposed form: the comparator takes `(Int32, Int32) -> Int32` and returns `a - b`, and the call is `clients[0..<Int(cnt)].sort { SortClients($0, $1) < 0 }`, or a hand `qsort` over `inout [Int32]` with a count and that closure.
- D7, `prox_mine_think`: a file-scope `Slots<Entity?>` passed to an `inout [Entity?]` parameter. Proposed form: `G_RadiusList` takes `Slots<Entity?>` for a caller that passes a file-scope table, or the caller copies `var list = Array(ent_list)`, passes `&list`, and writes the list back into the `Slots`.
- D8, `WP_CalcVehMuzzle` and `FireVehicleWeapon`: a `vec3_t[N]` field is `Slots<Slots<Float>>` on the view, and no form reads or writes one row as a `vec3_t`. Proposed form: `views.py` writes a second accessor `<name>Vectors: Slots<vec3_t>` with the 12-byte stride, the same way a `float *` field carries `<name>Vector`, so a body writes `start = pVeh.m_vMuzzlePosVectors[i]`.
