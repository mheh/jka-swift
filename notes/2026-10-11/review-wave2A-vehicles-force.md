# Review of wave 2A: the vehicle files, w_force, g_missile, g_svcmds, g_misc, and g_trigger

This record reviews the fills of commit ead6901 in eleven files under `Sources/JKAMP_GameLogic/`.
The commit removes 138 `portMissing` holes in these files, and each removed hole has a fill or a guide form that needs no line, such as a `NULL` trace `mins` or `maxs`.
Each fill was read against Raven's C under `oracle/codemp/game/`, the jka-rust range of the manifest in the submodule `jka-rust/`, and `docs/transcription.md`.
The `ForceThrow` push loop of w_force and the `ProcessMoveCommands` fill of FighterNPC had a line-by-line read.

| File | Function | Finding | Severity | Raven line | Swift line |
|---|---|---|---|---|---|
| SpeederNPC | `ProcessMoveCommands` | The fill writes Raven's `_JK2MP` arm `(0 && ...)` as `(0 != 0 && ...)`. The guide gives no form for a truth test on an integer literal. The block body is empty, so no behavior changes. | style | SpeederNPC.c:463 | SpeederNPC.swift:254 |
| w_force | `ForceThrow` | Raven's `gentity_t *vehEnt = &g_entities[...]` is the address of a table slot and is never NULL. The fill declares it `Entity?` and force-unwraps it six times. The guide gives no optional form for a slot address. No behavior changes. | style | w_force.c:3636 | w_force.swift:3056 |
| g_svcmds | `G_FilterPacket` | Raven's `m` is `byte m[4]`, so `m[i] = m[i]*10 + (*p - '0')` wraps at 8 bits, and jka-rust uses `wrapping_mul` and `wrapping_add` on `u8`. The fill stores into the draft's `[Int32]` array. So a group above 255 keeps a different value, and a group of ten or more digits traps on the Int32 overflow where C wraps. The guide's narrow-type rule keeps the element type of a fixed narrow array. `b` of `StringToFilter` has the same draft declaration at Swift line 31. | behavior | g_svcmds.c:151 | g_svcmds.swift:136 |

## Files with no finding

- FighterNPC: 14 fills. The `ProcessMoveCommands` else-chain, the strafe block, and the three gravity stores match Raven and the jka-rust body in order, value, and type. The `hackingTime` stores take the `Int32(Float(x) op f)` form, the `0.0f` stores take `Int32(0.0)`, and the `MIN_LANDING_SPEED` store takes `Float(...)`. The `NULL` outputs of `AngleVectors` take the scratch form with its comment. All of Raven's comments stay, including the comments on the `#ifdef QAGAME` lines.
- AnimalNPC: 7 fills. They have no finding. The `#ifndef _JK2MP` aim arm drops by the build's choice, and `default: assert(0)` becomes `default: break`.
- WalkerNPC: 3 fills. They have no finding.
- g_vehicleTurret: 3 fills. They have no finding. `turretEnemy!` is under Raven's own test.
- g_vehicles: the commit changes nothing in this file.
- w_force: 44 fills. The `ForceThrow` push loop matches Raven's statements, comments, and `continue` arms. Each `continue` runs the loop step first. The double math of `pushPowerMod` agrees with jka-rust. Only the `vehEnt` row above is a finding.
- g_missile: 11 fills. They have no finding. The `NULL` `dir` of `G_Damage` takes the `var dir: vec3_t? = nil` form.
- g_misc: 21 fills. They have no finding. `add = ammoData[i].max*0.1` computes in double. `TAG_Add` takes the `nameBuffer` and `Q_strlwr` value forms.
- g_trigger: 16 fills. They have no finding. The two `G_Find` loops of `asteroid_pick_random_asteroid` take the `while let` form, with `t = nil` after the first loop because the second loop reads `t`.

## Note outside the fills

The manifest `.claude/manifest/FighterNPC.md` gives `crates/mp/bg/src/vehicles/animal_npc.rs` as the jka-rust range of the FighterNPC `ProcessMoveCommands` and `ProcessOrientCommands`.
The FighterNPC bodies are in `crates/mp/bg/src/vehicles/fighter_npc.rs`, at lines 539 and 902, and this review read them there.
