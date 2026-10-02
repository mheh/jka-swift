# The game gate at 476626c

The class table over the six batch logs of the round at 476626c, from classify.py beside this file over the joined logs.

stems 75 functions 2184
holes 1576 cascade 0 defects 824 defect lines 824
log total line (526, 0, 205)
stems with a defect count that differs from the defect lines:

## Per stem
| Stem | Functions | Holes | Defects |
|---|---|---|---|
| g_vehicles | 38 | 51 | 93 |
| g_combat | 47 | 60 | 74 |
| g_cmds | 54 | 81 | 65 |
| g_main | 49 | 93 | 48 |
| g_ICARUScb | 161 | 25 | 41 |
| FighterNPC | 26 | 4 | 40 |
| g_weapon | 85 | 51 | 37 |
| g_items | 67 | 38 | 26 |
| g_session | 5 | 3 | 26 |
| g_client | 46 | 60 | 22 |
| NPC_spawn | 90 | 44 | 21 |
| g_nav | 50 | 17 | 21 |
| g_spawn | 17 | 18 | 21 |
| g_bot | 25 | 27 | 20 |
| g_utils | 66 | 29 | 20 |
| w_saber | 79 | 166 | 19 |
| AnimalNPC | 12 | 1 | 17 |
| g_mover | 72 | 16 | 14 |
| g_active | 36 | 16 | 13 |
| g_svcmds | 14 | 16 | 13 |
| NPC_AI_GalakMech | 14 | 4 | 10 |
| g_vehicleTurret | 6 | 6 | 10 |
| SpeederNPC | 11 | 2 | 9 |
| g_target | 44 | 23 | 9 |
| g_team | 36 | 11 | 9 |
| NPC_AI_Jedi | 68 | 29 | 8 |
| NPC_AI_Rancor | 16 | 7 | 8 |
| WalkerNPC | 11 | 1 | 8 |
| g_misc | 80 | 25 | 8 |
| NPC_stats | 8 | 23 | 7 |
| ai_wpnav | 45 | 31 | 7 |
| w_force | 52 | 44 | 7 |
| NPC_senses | 28 | 18 | 6 |
| ai_main | 108 | 77 | 6 |
| g_trigger | 42 | 23 | 6 |
| tri_coll_test | 2 | 128 | 6 |
| NPC_combat | 43 | 53 | 5 |
| NPC_AI_Droid | 14 | 4 | 4 |
| g_saga | 38 | 18 | 4 |
| g_turret_G2 | 15 | 18 | 4 |
| NPC_AI_Seeker | 11 | 10 | 3 |
| NPC_AI_Wampa | 11 | 12 | 3 |
| ai_util | 12 | 27 | 3 |
| g_turret | 14 | 10 | 3 |
| NPC_AI_Howler | 9 | 2 | 2 |
| NPC_AI_ImperialProbe | 12 | 9 | 2 |
| NPC_AI_MineMonster | 9 | 2 | 2 |
| NPC_AI_Sniper | 15 | 2 | 2 |
| NPC_AI_Stormtrooper | 31 | 7 | 2 |
| g_log | 33 | 45 | 2 |
| g_missile | 10 | 12 | 2 |
| NPC_AI_Interrogator | 10 | 5 | 1 |
| NPC_AI_Remote | 11 | 4 | 1 |
| NPC_AI_Sentry | 12 | 4 | 1 |
| NPC_behavior | 21 | 7 | 1 |
| NPC_misc | 2 | 8 | 1 |
| g_navnew | 13 | 10 | 1 |
| NPC | 43 | 8 | 0 |
| NPC_AI_Atst | 9 | 0 | 0 |
| NPC_AI_Default | 15 | 0 | 0 |
| NPC_AI_Grenadier | 11 | 1 | 0 |
| NPC_AI_Mark1 | 16 | 1 | 0 |
| NPC_AI_Mark2 | 10 | 1 | 0 |
| NPC_AI_Utils | 24 | 6 | 0 |
| NPC_goal | 7 | 1 | 0 |
| NPC_move | 11 | 2 | 0 |
| NPC_reactions | 12 | 2 | 0 |
| NPC_sounds | 2 | 0 | 0 |
| NPC_utils | 35 | 13 | 0 |
| g_arenas | 1 | 0 | 0 |
| g_exphysics | 1 | 0 | 0 |
| g_mem | 3 | 4 | 0 |
| g_object | 4 | 0 | 0 |
| g_strap | 12 | 0 | 0 |
| g_timer | 12 | 0 | 0 |

## Defect classes 36
| Count | Message | Top stems |
|---|---|---|
| 151 | value of optional type 'X' must be unwrapped to a value of type 'X' | g_vehicles 62, FighterNPC 18, NPC_spawn 8 |
| 120 | binary operator 'X' cannot be applied to operands of type 'X' and 'X' | g_cmds 46, g_main 11, g_session 11 |
| 90 | cannot convert value of type 'X' to expected argument type 'X' | g_main 17, NPC_AI_GalakMech 6, NPC_senses 6 |
| 85 | cannot assign value of type 'X' to type 'X' (aka 'X') | g_vehicles 18, g_weapon 11, g_mover 8 |
| 80 | value of optional type 'X' must be unwrapped to refer to member 'X' of wrapped base type 'X' | g_combat 53, NPC_AI_Jedi 4, g_client 4 |
| 61 | cannot assign value of type 'X' to type 'X' | g_ICARUScb 21, g_items 5, g_client 4 |
| 45 | cannot pass immutable value as inout argument: 'X' is a 'X' constant | NPC_AI_Rancor 6, NPC_AI_Droid 4, g_combat 4 |
| 32 | cannot force unwrap value of non-optional type 'X' | g_vehicles 11, FighterNPC 10, g_weapon 8 |
| 31 | referencing operator function 'X' on 'X' requires that 'X' conform to 'X' | g_cmds 5, g_items 5, g_svcmds 5 |
| 22 | no 'X' candidates produce the expected contextual result type 'X' | g_main 8, g_bot 6, g_client 3 |
| 17 | no exact matches in call to subscript  | g_session 6, g_utils 4, g_spawn 3 |
| 10 | value of type 'X' has no subscripts | w_saber 7, g_spawn 3 |
| 8 | cannot assign value of type 'X' to subscript of type 'X' | g_spawn 5, NPC_stats 2, g_items 1 |
| 7 | cannot convert return expression of type 'X' to return type 'X' | g_ICARUScb 2, ai_wpnav 1, g_client 1 |
| 6 | failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs) | g_cmds 2, NPC_AI_Sniper 1, g_bot 1 |
| 6 | cannot convert value of type 'X' to expected argument type 'X' (aka 'X') | g_ICARUScb 3, g_vehicleTurret 2, g_session 1 |
| 6 | binary operator 'X' cannot be applied to two 'X' operands | g_cmds 2, g_main 2, g_active 1 |
| 6 | cannot convert value of type 'X' (aka 'X') to expected argument type 'X' | g_mover 3, g_saga 2, g_misc 1 |
| 5 | cannot convert value of type 'X' to specified type 'X' | NPC_combat 1, ai_main 1, g_misc 1 |
| 4 | binary operator 'X' cannot be applied to operands of type 'X' (aka 'X') and 'X' | g_vehicleTurret 3, NPC_AI_GalakMech 1 |
| 4 | no exact matches in call to initializer  | NPC_AI_Jedi 2, g_main 1, g_session 1 |
| 4 | argument type 'X' does not conform to expected type 'X' | NPC_stats 2, g_session 2 |
| 4 | subscript 'X' requires that 'X' conform to 'X' | g_items 3, g_log 1 |
| 4 | 'X' used with non-inout argument of type 'X' | g_main 2, g_session 1, g_spawn 1 |
| 3 | cannot pass immutable value as inout argument: 'X' returns immutable value | g_main 2, NPC_spawn 1 |
| 2 | unary operators must not be juxtaposed; parenthesize inner expression | AnimalNPC 1, SpeederNPC 1 |
| 2 | extra argument in call | ai_main 1, g_cmds 1 |
| 1 | result values in 'X' expression have mismatching types 'X' and 'X' | AnimalNPC 1 |
| 1 | assigning a variable to itself | NPC_AI_Jedi 1 |
| 1 | no exact matches in call to global function 'X' | NPC_spawn 1 |
| 1 | 'X' is unavailable: cannot subscript String with an Int, use a String.Index instead. | g_ICARUScb 1 |
| 1 | type 'X' cannot conform to 'X' [#]N;;https://docs.swift.org/compiler/documentation/diagnostics/protocol-type-non-conformance\ProtocolTypeNonConformance]N;;\] | g_active 1 |
| 1 | value of type 'X' has no member 'X' | g_active 1 |
| 1 | type 'X' cannot be used as a boolean; test for 'X' instead | g_items 1 |
| 1 | cannot pass immutable value as inout argument: 'X' is a get-only property | g_weapon 1 |
| 1 | the compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions | w_saber 1 |

## Examples
151	value of optional type 'X' must be unwrapped to a value of type 'X'
	eg AnimalNPC.swift:73: value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'
120	binary operator 'X' cannot be applied to operands of type 'X' and 'X'
	eg NPC_AI_Stormtrooper.swift:567: binary operator '<' cannot be applied to operands of type 'Float' and 'Double'
90	cannot convert value of type 'X' to expected argument type 'X'
	eg AnimalNPC.swift:496: cannot convert value of type '_' to expected argument type 'Bool'
85	cannot assign value of type 'X' to type 'X' (aka 'X')
	eg AnimalNPC.swift:637: cannot assign value of type '@Sendable (Vehicle) -> ()' to type 'VehicleInfoAnimateVehicle' (aka '@convention(c) (Optional<OpaquePointer>) -> ()')
80	value of optional type 'X' must be unwrapped to refer to member 'X' of wrapped base type 'X'
	eg AnimalNPC.swift:674: value of optional type 'Vehicle?' must be unwrapped to refer to member 'm_pVehicleInfo' of wrapped base type 'Vehicle'
61	cannot assign value of type 'X' to type 'X'
	eg AnimalNPC.swift:362: cannot assign value of type 'Int' to type 'PlayerState'
45	cannot pass immutable value as inout argument: 'X' is a 'X' constant
	eg NPC_AI_Droid.swift:274: cannot pass immutable value as inout argument: 'vec3_origin' is a 'let' constant
32	cannot force unwrap value of non-optional type 'X'
	eg FighterNPC.swift:138: cannot force unwrap value of non-optional type 'Entity'
31	referencing operator function 'X' on 'X' requires that 'X' conform to 'X'
	eg g_active.swift:771: referencing operator function '-' on 'Strideable' requires that 'Client' conform to '_Pointer'
22	no 'X' candidates produce the expected contextual result type 'X'
	eg NPC_spawn.swift:1190: no 'Q_strlwr' candidates produce the expected contextual result type 'PooledString?'
