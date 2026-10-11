# Hole round: NPC_spawn and NPC_utils

The round read the holes of `Sources/JKAMP_GameLogic/NPC_spawn.swift` and `Sources/JKAMP_GameLogic/NPC_utils.swift` against `docs/transcription.md`.
NPC_spawn: 47 holes, 24 filled, 23 stands, 0 blocked.
NPC_utils: 13 holes, 4 filled, 9 stands, 0 blocked.

## NPC_spawn.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_PainFunc | pointer local `void (*func)(...)` | stands | No form for a function-pointer local. Docket row 1. |
| NPC_PainFunc | 16 stores into `func` (`NPC_Jedi_Pain` to `NPC_Pain`) | stands | Each store needs the local of row 1 and a thunk name. The thunk names are outside the read set. |
| NPC_PainFunc | read of `func` at `return func` | stands | Follows row 1. |
| NPC_TouchFunc | pointer local `void (*func)(...)` | stands | Docket row 1. |
| NPC_TouchFunc | store `func = NPC_Touch` | stands | Follows row 1. |
| NPC_TouchFunc | read of `func` at `return func` | stands | Follows row 1. |
| NPC_Begin | `VectorCopy(client->pers.cmd.angles, ucmd.angles)` into the get-only `Slots<Int32>` field | stands | The VectorCopy form `b = a` needs a settable vector. Docket row 2. |
| NPC_Begin | pointer local `char *droidNPCType` | filled | `var droidNPCType: String? = nil`, a text local set from `char *` fields. |
| NPC_Begin | store `droidNPCType = ent->model2` | filled | Plain store of the `String?` field. |
| NPC_Begin | store `droidNPCType = ...->droidNPC` | filled | Plain store of the `String?` field. |
| NPC_Begin | read of `droidNPCType`, the droid spawn block | filled | Ported line for line. The chained store lifts inner first. The `(bgEntity_t *)` cast is `BgEntity(droidEnt!)`. |
| New_NPC_t | `memset(ptr, 0, sizeof(*ptr))` | filled | `ptr!.clear()` inside Raven's `if (ptr)`. |
| NPC_Spawn_Do | `memset(newent->client, 0, sizeof(*newent->client))` | filled | `newent!.client!.clear()`. |
| NPC_Spawn_Do | `ent->NPC_type = Q_strlwr(G_NewString(ent->NPC_type))` | filled | The pooled-string form: `G_NewString(Q_strlwr(ent.NPC_type!))`. |
| NPC_Spawn_Do | store of `&ps.vehOrientation[0]` into `m_vOrientation` | stands | Rule 11 keeps the pointer out of the logic target, and the guide has no form. Docket row 3. |
| NPC_Spawn_Do | `parm[parmNum] && parm[parmNum][0]` test | filled | The two tests draft as one `isEmpty` test, with two comment lines that name them. |
| NPC_VehiclePrecache | pointer local `char *droidNPCType` | filled | `var droidNPCType: String? = nil`. |
| NPC_VehiclePrecache | pointer local `char *slash` | filled | `if let slash = Q_strrchr(...)`, the text-offset form. |
| NPC_VehiclePrecache | read of `slash` | filled | `strcpy(&GLAName, "/animation.cfg", at: slash)`. |
| NPC_VehiclePrecache | store `droidNPCType = spawner->model2` | filled | Plain store. |
| NPC_VehiclePrecache | store `droidNPCType = g_vehicleInfo[iVehIndex].droidNPC` | filled | Plain store. |
| NPC_VehiclePrecache | read of `droidNPCType` | filled | `NPC_PrecacheType` takes `inout CharBuf`, so each call passes `var buf = CharBuf(text)` and `&buf`. |
| NPC_SpawnType | NULL `right` output of `AngleVectors` | filled | The callee's NULL arm only skips the write, so a plain comment names the NULL outputs. |
| NPC_SpawnType | NULL `up` output of `AngleVectors` | filled | Same comment as `right`. |
| NPC_SpawnType | NULL `mins` into `trap_Trace`, first call | filled | `vec3_origin`, no comment. |
| NPC_SpawnType | NULL `maxs` into `trap_Trace`, first call | filled | `vec3_origin`, no comment. |
| NPC_SpawnType | NULL `mins` into `trap_Trace`, second call | filled | `vec3_origin`, no comment. |
| NPC_SpawnType | NULL `maxs` into `trap_Trace`, second call | filled | `vec3_origin`, no comment. |
| Cmd_NPC_f | `showBBoxes = showBBoxes ? qfalse : qtrue` | filled | `showBBoxes ? false : true`. |
| Cmd_NPC_f | `if (!ent \|\| !ent->client) continue;` | filled | The `continue` runs the loop step first. |
| Cmd_NPC_f | `NPC_PrintScore(ent)` | filled | `NPC_PrintScore(ent!)`. |
| Cmd_NPC_f | store inside the `if` test, `(ent = G_Find(...)) != NULL && ent->client` | filled | The store lifts before the `if`, and `FOFS(targetname)` is `\.targetname`. |

## NPC_utils.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_ActivateBehavior | pointer local `char *bs_name` | filled | `var bs_name: String? = nil`. |
| G_ActivateBehavior | store `bs_name = self->behaviorSet[bset]` | filled | `behaviorSet` is `Slots<String?>`. |
| G_ActivateBehavior | `if (!(VALIDSTRING(bs_name)))` | filled | The `String?` overload of `VALIDSTRING`. |
| G_ActivateBehavior | `GetIDForString(BSTable, bs_name)` | stands | The guide keeps a hole where the caller holds one record and the callee takes a `Slots`. Docket row 4. |
| G_ActivateBehavior | `GetStringForID(BSETTable, bset)` inside `G_DebugPrint` | stands | Same shape as the row above. Docket row 4. |
| G_ActivateBehavior | read of `bs_name` in `trap_ICARUS_RunScript` | filled | `trap_ICARUS_RunScript(`self`, va("%s/%s", Q3_SCRIPT_DIR, bs_name!))`. The lookup tool has no row for the trap, so the build confirms its signature. |
| NPC_SetBoneAngles | pointer local `int *thebone` | stands | No form for a pointer that walks four named fields of one record. Docket row 5. |
| NPC_SetBoneAngles | pointer local `int *firstFree` | stands | Docket row 5. |
| NPC_SetBoneAngles | pointer local `vec3_t *boneVector` | stands | Docket row 5. |
| NPC_SetBoneAngles | pointer local `vec3_t *freeBoneVec` | stands | Docket row 5. |
| NPC_SetBoneAngles | read of `thebone`, the search loop | stands | Follows row 5. |
| NPC_SetBoneAngles | read of `thebone`, the create arm | stands | Follows row 5. |
| NPC_SetBoneAngles | `VectorCopy(angles, *boneVector)` | stands | Follows row 5. |

## GameWorld properties

None. No hole in the two files is a static local or a file-scope static.

## Docket rows

1. NPC_PainFunc and NPC_TouchFunc, the function-pointer local `func`. The guide gives a form for a function-pointer return and for a store into a callback field, but not for a local. Proposed form: the local is `var func: EntityPain?` of the view's callback typealias, and each store takes the generated thunk, `func = Pain.NPC_Jedi_Pain`, so the generator must emit thunks for every function Raven stores into such a local.
2. NPC_Begin, `VectorCopy` of an `int[3]` field into another `int[3]` field. The `Slots<Int32>` accessor is get-only, so `b = a` does not compile. Proposed form: three element stores, `ucmd.angles[i] = client!.pers.cmd.angles[i]` for i in 0...2, or a `Slots` copy method beside `fill(_:)`.
3. NPC_Spawn_Do, the store of `&newent->client->ps.vehOrientation[0]` into the `float *` field `m_vOrientation`. Rule 11 keeps the pointer out of the logic target. Proposed form: a generated setter on the view that points a `float *` field at a vector field of another view, written in the view target.
4. G_ActivateBehavior, `BSTable` and `BSETTable` reach the body as one record, but `GetIDForString` and `GetStringForID` take a `Slots`. The guide keeps the hole by rule. Proposed form: forward both tables as `Slots<StringIDTable>` over Raven's C arrays, the same way `bg_itemlist` is reached.
5. NPC_SetBoneAngles, four pointer locals that walk `boneIndex1` to `boneIndex4` and `boneAngles1` to `boneAngles4` of one `entityState_t`. No form covers a pointer over named fields of one record. Proposed form: an `Int32?` slot index for each pointer, with a private hand accessor that reads and writes `boneIndexN` and `boneAnglesN` by that index.
