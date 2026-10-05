# The game gate at 9a756c8

The class table over the six batch logs of the round at 9a756c8, from classify.py beside this file over the joined logs.

stems 75 functions 2184
holes 1632 cascade 0 defects 341 defect lines 341
log total line (547, 0, 53)
stems with a defect count that differs from the defect lines:

## Per stem
| Stem | Functions | Holes | Defects |
|---|---|---|---|
| g_main | 49 | 96 | 33 |
| g_session | 5 | 3 | 26 |
| g_spawn | 17 | 18 | 20 |
| g_bot | 25 | 27 | 19 |
| g_cmds | 54 | 87 | 18 |
| g_nav | 50 | 17 | 16 |
| NPC_spawn | 90 | 42 | 13 |
| g_svcmds | 14 | 16 | 13 |
| g_utils | 66 | 37 | 13 |
| w_saber | 79 | 165 | 13 |
| FighterNPC | 26 | 4 | 12 |
| g_ICARUScb | 161 | 25 | 12 |
| g_vehicles | 38 | 52 | 12 |
| g_active | 36 | 16 | 11 |
| g_client | 46 | 62 | 8 |
| g_vehicleTurret | 6 | 6 | 8 |
| AnimalNPC | 12 | 1 | 7 |
| g_combat | 47 | 77 | 7 |
| g_misc | 80 | 26 | 7 |
| g_weapon | 85 | 55 | 7 |
| NPC_AI_Rancor | 16 | 7 | 6 |
| NPC_senses | 28 | 18 | 6 |
| ai_wpnav | 45 | 31 | 6 |
| NPC_stats | 8 | 23 | 5 |
| ai_main | 108 | 79 | 5 |
| g_mover | 72 | 16 | 5 |
| NPC_AI_Jedi | 68 | 29 | 4 |
| NPC_combat | 43 | 54 | 4 |
| SpeederNPC | 11 | 2 | 4 |
| g_team | 36 | 11 | 4 |
| ai_util | 12 | 27 | 3 |
| g_items | 67 | 40 | 3 |
| g_saga | 38 | 19 | 3 |
| NPC_AI_Sniper | 15 | 2 | 2 |
| WalkerNPC | 11 | 1 | 2 |
| NPC_AI_GalakMech | 14 | 4 | 1 |
| NPC_AI_Stormtrooper | 31 | 7 | 1 |
| NPC_AI_Wampa | 11 | 12 | 1 |
| g_target | 44 | 23 | 1 |
| NPC | 43 | 8 | 0 |
| NPC_AI_Atst | 9 | 0 | 0 |
| NPC_AI_Default | 15 | 0 | 0 |
| NPC_AI_Droid | 14 | 4 | 0 |
| NPC_AI_Grenadier | 11 | 1 | 0 |
| NPC_AI_Howler | 9 | 2 | 0 |
| NPC_AI_ImperialProbe | 12 | 9 | 0 |
| NPC_AI_Interrogator | 10 | 5 | 0 |
| NPC_AI_Mark1 | 16 | 1 | 0 |
| NPC_AI_Mark2 | 10 | 1 | 0 |
| NPC_AI_MineMonster | 9 | 2 | 0 |
| NPC_AI_Remote | 11 | 4 | 0 |
| NPC_AI_Seeker | 11 | 10 | 0 |
| NPC_AI_Sentry | 12 | 4 | 0 |
| NPC_AI_Utils | 24 | 6 | 0 |
| NPC_behavior | 21 | 7 | 0 |
| NPC_goal | 7 | 1 | 0 |
| NPC_misc | 2 | 8 | 0 |
| NPC_move | 11 | 2 | 0 |
| NPC_reactions | 12 | 2 | 0 |
| NPC_sounds | 2 | 0 | 0 |
| NPC_utils | 35 | 15 | 0 |
| g_arenas | 1 | 0 | 0 |
| g_exphysics | 1 | 0 | 0 |
| g_log | 33 | 45 | 0 |
| g_mem | 3 | 4 | 0 |
| g_missile | 10 | 12 | 0 |
| g_navnew | 13 | 10 | 0 |
| g_object | 4 | 0 | 0 |
| g_strap | 12 | 0 | 0 |
| g_timer | 12 | 0 | 0 |
| g_trigger | 42 | 23 | 0 |
| g_turret | 14 | 10 | 0 |
| g_turret_G2 | 15 | 18 | 0 |
| tri_coll_test | 2 | 128 | 0 |
| w_force | 52 | 53 | 0 |

## Defect classes 36
| Count | Message | Top stems |
|---|---|---|
| 60 | binary operator 'X' cannot be applied to operands of type 'X' and 'X' | g_main 11, g_session 11, g_nav 8 |
| 57 | cannot convert value of type 'X' to expected argument type 'X' | g_main 7, NPC_senses 6, g_misc 4 |
| 31 | value of optional type 'X' must be unwrapped to a value of type 'X' | g_vehicles 10, FighterNPC 7, AnimalNPC 2 |
| 25 | referencing operator function 'X' on 'X' requires that 'X' conform to 'X' | g_cmds 5, g_svcmds 5, g_combat 4 |
| 18 | cannot assign value of type 'X' to type 'X' | FighterNPC 3, g_svcmds 3, AnimalNPC 1 |
| 18 | no 'X' candidates produce the expected contextual result type 'X' | g_main 8, g_bot 6, g_client 2 |
| 17 | value of optional type 'X' must be unwrapped to refer to member 'X' of wrapped base type 'X' | NPC_spawn 3, ai_wpnav 3, g_active 3 |
| 17 | no exact matches in call to subscript  | g_session 6, g_utils 4, g_spawn 3 |
| 11 | cannot pass immutable value as inout argument: 'X' is a 'X' constant | NPC_AI_Rancor 6, w_saber 3, NPC_AI_Wampa 1 |
| 10 | value of type 'X' has no subscripts | w_saber 7, g_spawn 3 |
| 6 | failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs) | g_cmds 2, NPC_AI_Sniper 1, g_bot 1 |
| 6 | cannot convert value of type 'X' to expected argument type 'X' (aka 'X') | g_ICARUScb 3, g_vehicleTurret 2, g_session 1 |
| 6 | binary operator 'X' cannot be applied to two 'X' operands | g_cmds 2, g_main 2, g_active 1 |
| 6 | cannot convert value of type 'X' (aka 'X') to expected argument type 'X' | g_mover 3, g_saga 2, g_misc 1 |
| 5 | cannot assign value of type 'X' to type 'X' (aka 'X') | g_weapon 2, NPC_AI_Sniper 1, g_client 1 |
| 5 | cannot convert value of type 'X' to specified type 'X' | NPC_combat 1, ai_main 1, g_misc 1 |
| 5 | cannot assign value of type 'X' to subscript of type 'X' | g_spawn 5 |
| 4 | binary operator 'X' cannot be applied to operands of type 'X' (aka 'X') and 'X' | g_vehicleTurret 3, NPC_AI_GalakMech 1 |
| 4 | no exact matches in call to initializer  | NPC_AI_Jedi 2, g_main 1, g_session 1 |
| 4 | argument type 'X' does not conform to expected type 'X' | NPC_stats 2, g_session 2 |
| 4 | 'X' used with non-inout argument of type 'X' | g_main 2, g_session 1, g_spawn 1 |
| 3 | cannot pass immutable value as inout argument: 'X' returns immutable value | g_main 2, NPC_spawn 1 |
| 3 | cannot convert return expression of type 'X' to return type 'X' | g_ICARUScb 2, ai_wpnav 1 |
| 2 | unary operators must not be juxtaposed; parenthesize inner expression | AnimalNPC 1, SpeederNPC 1 |
| 2 | extra argument in call | ai_main 1, g_cmds 1 |
| 2 | cannot force unwrap value of non-optional type 'X' | g_bot 1, g_cmds 1 |
| 1 | result values in 'X' expression have mismatching types 'X' and 'X' | AnimalNPC 1 |
| 1 | assigning a variable to itself | NPC_AI_Jedi 1 |
| 1 | cannot assign to property: 'X' is a get-only property | NPC_spawn 1 |
| 1 | no exact matches in call to global function 'X' | NPC_spawn 1 |
| 1 | 'X' is unavailable: cannot subscript String with an Int, use a String.Index instead. | g_ICARUScb 1 |
| 1 | type 'X' cannot conform to 'X' [#]N;;https://docs.swift.org/compiler/documentation/diagnostics/protocol-type-non-conformance\ProtocolTypeNonConformance]N;;\] | g_active 1 |
| 1 | value of type 'X' has no member 'X' | g_active 1 |
| 1 | type 'X' cannot be used as a boolean; test for 'X' instead | g_items 1 |
| 1 | cannot pass immutable value as inout argument: 'X' is a get-only property | g_weapon 1 |
| 1 | the compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions | w_saber 1 |

## Examples
60	binary operator 'X' cannot be applied to operands of type 'X' and 'X'
	eg NPC_combat.swift:2269: binary operator '==' cannot be applied to operands of type 'Bool' and 'Int'
57	cannot convert value of type 'X' to expected argument type 'X'
	eg AnimalNPC.swift:496: cannot convert value of type '_' to expected argument type 'Bool'
31	value of optional type 'X' must be unwrapped to a value of type 'X'
	eg AnimalNPC.swift:73: value of optional type 'Bool?' must be unwrapped to a value of type 'Bool'
25	referencing operator function 'X' on 'X' requires that 'X' conform to 'X'
	eg g_active.swift:771: referencing operator function '-' on 'Strideable' requires that 'Client' conform to '_Pointer'
18	cannot assign value of type 'X' to type 'X'
	eg AnimalNPC.swift:362: cannot assign value of type 'Int' to type 'PlayerState'
18	no 'X' candidates produce the expected contextual result type 'X'
	eg NPC_spawn.swift:1191: no 'Q_strlwr' candidates produce the expected contextual result type 'PooledString?'
17	value of optional type 'X' must be unwrapped to refer to member 'X' of wrapped base type 'X'
	eg AnimalNPC.swift:674: value of optional type 'Vehicle?' must be unwrapped to refer to member 'm_pVehicleInfo' of wrapped base type 'Vehicle'
17	no exact matches in call to subscript 
	eg ai_util.swift:356: no exact matches in call to subscript 
11	cannot pass immutable value as inout argument: 'X' is a 'X' constant
	eg NPC_AI_Rancor.swift:275: cannot pass immutable value as inout argument: 'vec3_origin' is a 'let' constant
10	value of type 'X' has no subscripts
	eg g_spawn.swift:88: value of type 'Float' has no subscripts
