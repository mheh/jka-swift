# Hole round on w_force and g_missile

The docket was `grep -n "Port-note"` on the two files at HEAD 619bed8.
Line numbers in the tables are the lines of the Port-notes at HEAD.

## w_force.swift

Totals: 44 filled, 0 stands, 0 blocked.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| `ForceGrip` (line 1207) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceGrip` (line 1210) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceGrip` (line 1218) | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `ForceGrip` (line 1220) | NULL `maxs` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `ForceShootLightning` (line 1522) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceShootLightning` (line 1525) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceShootLightning` (line 1543) | Local `gentity_t *entityList[MAX_GENTITIES]` | filled | Declared as `var entityList = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, the guide form for a C array of struct pointers. |
| `ForceShootLightning` (line 1562) | Read of `entityList` | filled | Written as Raven wrote it: `entityList[i] = g_entities[iEntityList[i]]`. |
| `ForceShootLightning` (line 1571) | Read of `entityList` | filled | Written as Raven wrote it: `traceEnt = entityList[e]`. |
| `ForceShootLightning` (line 1624) | Assignment inside an `if` test | filled | Lifted: `dot = _DotProduct(dir, forward)`, then `if Double(dot) < 0.5` with `e += 1` and `continue`. |
| `ForceShootDrain` (line 1823) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceShootDrain` (line 1826) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceShootDrain` (line 1844) | Local `gentity_t *entityList[MAX_GENTITIES]` | filled | Declared as `var entityList = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, the guide form for a C array of struct pointers. |
| `ForceShootDrain` (line 1863) | Read of `entityList` | filled | Written as Raven wrote it: `entityList[i] = g_entities[iEntityList[i]]`. |
| `ForceShootDrain` (line 1872) | Read of `entityList` | filled | Written as Raven wrote it: `traceEnt = entityList[e]`. |
| `ForceShootDrain` (line 1929) | Assignment inside an `if` test | filled | Lifted: `dot = _DotProduct(dir, forward)`, then `if Double(dot) < 0.5` with `e += 1` and `continue`. |
| `WP_GetVelocityForForceJump` (line 2046) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceTelepathyCheckDirectNPCTarget` (line 2165) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceTelepathyCheckDirectNPCTarget` (line 2168) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceTelepathyCheckDirectNPCTarget` (line 2176) | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `ForceTelepathyCheckDirectNPCTarget` (line 2178) | NULL `maxs` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `ForceTelepathyCheckDirectNPCTarget` (line 2289) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceTelepathyCheckDirectNPCTarget` (line 2292) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceTelepathy` (line 2391) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceThrow` (line 2588) | Local `gentity_t *push_list[MAX_GENTITIES]` | filled | Declared as `var push_list = [Entity?](repeating: nil, count: Int(MAX_GENTITIES))`, the guide form for a C array of struct pointers. |
| `ForceThrow` (line 2697) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceThrow` (line 2734) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceThrow` (line 2737) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `ForceThrow` (line 2745) | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `ForceThrow` (line 2747) | NULL `maxs` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `ForceThrow` (line 2922) | Assignment inside an `if` test | filled | Lifted: `dot1 = _DotProduct(dir, forward)`, then `if Double(dot1) < 0.6` with `e += 1` and `continue`. |
| `ForceThrow` (line 2960) | Read of `push_list` | filled | Written as Raven wrote it: `push_list[ent_count] = ent`. |
| `ForceThrow` (line 2974) | Read of `push_list` | filled | The `if (push_list[x]->client)` block with `WP_AbsorbConversion` is written as Raven wrote it, through `push_list[x]!`. |
| `ForceThrow` (line 2980) | Read of `push_list` | filled | The `VectorCopy` pair is written as `thispush_org = push_list[x]!.client!.ps.origin` and `thispush_org = push_list[x]!.s.origin`. |
| `ForceThrow` (line 2984) | Read of `push_list` | filled | Ported line for line with `push_list[x]!`. A `continue` runs `x += 1` first. Compound stores into `pushPowerMod` with a double operand take `Int32(Double(...) - Double(...) * k)`. The door arm passes `Float(radius)` to `_VectorMA` and calls `Distance`, see the note under the table. |
| `DoGripAction` (line 3147) | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `DoGripAction` (line 3149) | NULL `maxs` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `DoGripAction` (line 3182) | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`. The scratch is now `var dir: vec3_t? = nil`, passed as `&dir`. |
| `DoGripAction` (line 3220) | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`. The scratch is now `var dir: vec3_t? = nil`, passed as `&dir`. |
| `DoGripAction` (line 3257) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `DoGripAction` (line 3260) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `DoGripAction` (line 3306) | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`. The scratch is now `var dir: vec3_t? = nil`, passed as `&dir`. |
| `SeekerDroneUpdate` (line 3912) | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |
| `SeekerDroneUpdate` (line 3914) | NULL `maxs` into `trap_Trace` | filled | The call already passes `vec3_origin`. Port-note and marker deleted, no comment, as the guide states. |

Three facts of the big `ForceThrow` fill at line 2984 rest on the guide and not on a file in the read set:

- `pushPowerMod -= pushPowerMod*0.2` and `pushPowerMod -= (dirLen*0.7)` store a double result into an `int`. The fill writes `pushPowerMod = Int32(Double(pushPowerMod) - Double(pushPowerMod) * 0.2)`, because C subtracts in double before it truncates, and `Int32` on the product alone gives a different integer.
- `VectorMA( trFrom, radius, forward, end )` passes the `int` `radius` to the `float` scale. The fill writes `Float(radius)` under the rule for an `int` stored into a `float`.
- `Distance( pos1, trFrom )` has no row in the lookup tool. The fill calls `Distance` by Raven's name, the same as the file calls `VectorLength` and `VectorCompare`. The build confirms the name.

## g_missile.swift

Totals: 11 filled, 0 stands, 0 blocked.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| `G_DeflectMissile` (line 92) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_DeflectMissile` (line 95) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_RunStuckMissile` (line 243) | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`. The scratch is now `var dir: vec3_t? = nil`, passed as `&dir`. |
| `G_MissileImpact` (line 406) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 409) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 414) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 417) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 452) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 455) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 512) | NULL `right` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |
| `G_MissileImpact` (line 515) | NULL `up` into `AngleVectors` | filled | The signature takes a plain `inout`, so the NULL arm only skips the write. Port-note and marker replaced with the plain comment that names the NULL outputs. |

## GameWorld properties

None. No hole in the two files is a static local or a file-scope static.

## Docket rows

None. Every hole had a form in the guide.
