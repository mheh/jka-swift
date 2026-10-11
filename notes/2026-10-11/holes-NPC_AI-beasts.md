# Hole round, NPC_AI beasts and droids

This record covers the hole round on eight adopted files under `Sources/JKAMP_GameLogic/`. The docket was `grep -n "Port-note"` on each file. All 47 holes are filled. No hole stands, and no hole is blocked.

The fills use four forms of `docs/transcription.md`, section 3:

- A `NULL` output into `AngleVectors`: the signature from `lookup.py sig AngleVectors` is a plain `inout`, so the callee's NULL arm only skips the write. The scratch locals stay, and one plain comment names the NULL outputs.
- A `NULL` `dir` into `G_Damage`: the caller declares `var dir: vec3_t? = nil` and passes `&dir` to the optional-inout function.
- `vec3_origin` as the `dir` of `G_Damage`: the call passes a scratch copy, `var dir = vec3_origin`, with a one-line comment and no note and no marker.
- A `NULL` `mins` or `maxs` into `trap_Trace`: `vec3_origin` with no comment. The call already had `vec3_origin`, so only the note and the marker go.

## NPC_AI_Wampa.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Wampa_Slash | `vec3_origin` as `dir` of `G_Damage` | filled | The scratch copy form. |
| Wampa_Slash | NULL `right` into `AngleVectors` | filled | One comment for `right` and `up`. |
| Wampa_Slash | NULL `up` into `AngleVectors` | filled | Same comment. |
| Wampa_Slash | NULL `right` into `AngleVectors` | filled | Second call, one comment for `right` and `up`. |
| Wampa_Slash | NULL `up` into `AngleVectors` | filled | Same comment. |
| Wampa_Attack | NULL `right` into `AngleVectors` | filled | One comment for `right` and `up`. |
| Wampa_Attack | NULL `up` into `AngleVectors` | filled | Same comment. |
| Wampa_Combat | assignment inside an expression, `distance = enemyDist = Distance(...)` | filled | The store to `enemyDist` lifts, and `distance` reads it. |
| Wampa_Combat | read of `distance`, the `advance` initializer | filled | `var advance: Bool`. The `(qboolean)` cast drops, because the value is already `Bool`. |
| Wampa_Combat | read of `advance`, the charge test | filled | `fabs` is `abs`, as in `Rancor_Combat`. Raven's inline comments stay. |
| Wampa_Combat | read of `advance`, the attack branch | filled | `Wampa_Move( 1 )` is `Wampa_Move(1 != 0)`, as elsewhere in the file. |

## NPC_AI_Rancor.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Rancor_Swing | NULL `right` into `AngleVectors` | filled | One comment for `right` and `up`. |
| Rancor_Swing | NULL `up` into `AngleVectors` | filled | Same comment. |
| Rancor_Swing | `vec3_origin` as `dir` of `G_Damage` | filled | The scratch copy form. |
| Rancor_Smash | `vec3_origin` as `dir` of `G_Damage` | filled | The scratch copy form. |
| Rancor_Bite | `vec3_origin` as `dir` of `G_Damage` | filled | The scratch copy form. |
| Rancor_Attack | NULL `right` into `AngleVectors` | filled | One comment for `right` and `up`. |
| Rancor_Attack | NULL `up` into `AngleVectors` | filled | Same comment. |
| Rancor_Attack | `vec3_origin` as `dir` of `G_Damage`, first `BOTH_ATTACK1` arm | filled | The scratch copy form. |
| Rancor_Attack | `vec3_origin` as `dir` of `G_Damage`, the first KILL | filled | The scratch copy form. |
| Rancor_Attack | `vec3_origin` as `dir` of `G_Damage`, the second KILL | filled | The scratch copy form. |
| Rancor_Crush | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil`. |

## NPC_AI_Seeker.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_Seeker_Pain | cast `(float*)vec3_origin` for `dir` and `point` of `G_Damage` | filled | The cast is the decay of `vec3_t` to `float *` and has no Swift form. `dir` takes the scratch copy form, and `point` takes `vec3_origin` by value. |
| Seeker_Strafe | NULL `forward` into `AngleVectors` | filled | One comment for `forward` and `up`. |
| Seeker_Strafe | NULL `up` into `AngleVectors` | filled | Same comment. |
| Seeker_Strafe | NULL `mins` into `trap_Trace` | filled | Note and marker deleted. |
| Seeker_Strafe | NULL `maxs` into `trap_Trace` | filled | Note and marker deleted. |
| Seeker_Strafe | NULL `up` into `AngleVectors` | filled | One comment for `up`. |
| Seeker_Strafe | NULL `mins` into `trap_Trace` | filled | Note and marker deleted. |
| Seeker_Strafe | NULL `maxs` into `trap_Trace` | filled | Note and marker deleted. |
| Seeker_Ranged | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil`. |
| NPC_BSSeeker_Default | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil`. |

## NPC_AI_ImperialProbe.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| ImperialProbe_Strafe | NULL `forward` into `AngleVectors` | filled | One comment for `forward` and `up`. |
| ImperialProbe_Strafe | NULL `up` into `AngleVectors` | filled | Same comment. |
| ImperialProbe_Strafe | NULL `mins` into `trap_Trace` | filled | Note and marker deleted. |
| ImperialProbe_Strafe | NULL `maxs` into `trap_Trace` | filled | Note and marker deleted. |
| NPC_Probe_Pain | NULL `mins` into `trap_Trace` | filled | Note and marker deleted. |
| NPC_Probe_Pain | NULL `maxs` into `trap_Trace` | filled | Note and marker deleted. |
| ImperialProbe_Wait | NULL `mins` into `trap_Trace` | filled | Note and marker deleted. |
| ImperialProbe_Wait | NULL `maxs` into `trap_Trace` | filled | Note and marker deleted. |
| ImperialProbe_Wait | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil`. |

## NPC_AI_Howler.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Howler_TryDamage | NULL `right` into `AngleVectors` | filled | One comment for `right` and `up`. |
| Howler_TryDamage | NULL `up` into `AngleVectors` | filled | Same comment. |

## NPC_AI_MineMonster.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| MineMonster_TryDamage | NULL `right` into `AngleVectors` | filled | One comment for `right` and `up`. |
| MineMonster_TryDamage | NULL `up` into `AngleVectors` | filled | Same comment. |

## NPC_AI_Mark1.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_Mark1_Pain | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil`. |

## NPC_AI_Mark2.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_Mark2_Pain | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil`. |

## GameWorld properties

None. No hole in the eight files needs a new static.

## Docket rows

None. One fill needs the coordinator's check at the build: `NPC_Seeker_Pain` drops Raven's `(float*)` cast on `vec3_origin` with no explicit guide line, because the cast is only the array decay that the vector form already gives.
