# Hole round: g_mover and g_combat

## g_mover.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_TryPushingEntity | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil` and `&dir`, the NULL-caller form of guide section 3. |
| G_TryPushingEntity | `vec3_origin` into the written `dir` of `G_Damage` | filled | A copy `var dir = vec3_origin` with the one-line comment, the `G_Damage` form of guide section 3. |
| G_MoverPush | NULL `dir` into `G_Damage`, crush on `spawnflags & 32` | filled | NULL-caller form. |
| G_MoverPush | NULL `dir` into `G_Damage`, crush of a body | filled | NULL-caller form. |
| G_MoverPush | NULL `dir` into `G_Damage`, bobbing mover | filled | NULL-caller form. |
| G_MoverPush | `*obstacle = check` | filled | `obstacle = check`. The parameter is `inout Entity?`, so the optional source needs no ruling. |
| Blocked_Door | NULL `dir` into `G_Damage` | filled | NULL-caller form. |
| G_FindDoorTrigger | assignment inside the `while` test, `FOFS(target)` | filled | `while let next = G_Find(...)` form. Raven's own `owner = NULL` follows the loop. |
| G_FindDoorTrigger | assignment inside the `while` test, `FOFS(target2)` | filled | `while let` form. |
| G_FindDoorTrigger | assignment inside the `while` test, `trigger_door` | filled | `while let` form. Nothing after the loop reads `owner`. |
| G_EntIsUnlockedDoor | assignment inside the `while` test, `FOFS(target)` | filled | `while let` form. Raven's `//FIXME` comment stays. |
| G_EntIsUnlockedDoor | assignment inside the `while` test, `FOFS(target2)` | filled | `while let` form. |
| Think_SetupTrainTargets | `ent->nextTrain = G_Find(NULL, FOFS(targetname), ent->target)` | filled | `FOFS` is a key path, `\.targetname`, and the optional `target` takes the force unwrap. |
| Think_SetupTrainTargets | `next = G_Find(next, FOFS(targetname), path->target)` | filled | Same form. |
| funcBBrushDieGo | NULL `dir` into `G_Damage` | filled | NULL-caller form. The inner `dir` shadows the outer `vec3_t` local in the nested block. |
| SP_func_breakable | `G_SpawnString("playfx", "", &s)` into a `String?` local | blocked | The parameter is `inout String`, `out_string`. The local `s` is `String?`, and Raven tests it for NULL. The shape of that local comes from the text-local rule of `docs/porting-rules.md`, which is outside the read set. |
| SP_func_breakable | `(int*)&self->material` | filled | `material_t` is an `Int32` alias, so `&self.material` is already the `inout Int32`, and the pointer cast has no Swift spelling. |

## g_combat.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| player_die | pointer local `char *obit` | filled | `var obit: String`, the same shape the draft gave its sibling `killerName` of the same declaration. |
| player_die | `sizeof(modNames) / sizeof(modNames[0])` | stands | The guide has no form for the element count of a file-scope array. See docket row 1. |
| player_die | `G_LogPrintf(..., obit)` | blocked | The format form exists, but `obit` gets its value only in the hole above. A read before that hole fills does not compile. |
| G_Dismember | `ent->ghoul2 && limbName && ...` | stands | `limbName` is a local `char limbName[MAX_QPATH]`, a `CharBuf`. The guide has no form for a truth test of a local array's address. See docket row 2. |
| G_Dismember | `ent->ghoul2 && limbName && stubCapName` | stands | Same reason, for `limbName` and `stubCapName`. See docket row 2. |

## GameWorld properties

None. No hole in this round is a static local or a file-scope static.

## Docket rows

1. `player_die`, `sizeof(modNames) / sizeof(modNames[0])`. The guide sizes a `char` buffer and a memset, but not the element count of an array of pointers. Proposed form: the quotient is `modNames.count`, and the comparison with an `Int32` uses the standard library's mixed-integer comparison, with no cast.
2. `G_Dismember`, a truth test of a local `char buf[N]`. In C the array's address is never NULL, so the test is always true. The `isEmpty` form of guide section 3 covers a record field and tests the first byte, which is a different test. Proposed form: a truth test of a local or file-scope `char` array drops from the condition, with one comment line that names Raven's test.
