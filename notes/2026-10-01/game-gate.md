# The game gate of 2026-10-01

This is the draftcheck.py `--game` run at the tree that became commit b592573. The run gives 1579 holes, 0 cascade errors, and 1171 defects over 75 stems and 2184 hand functions. No stem fails to parse, so Swift type-checks every stem to the end and the defect counts are complete. The log is game-draftcheck.log in this folder, and classify.py reads it and prints every number below. No defect message says that a name is not in scope, so the class "cannot find 'X' in scope" is empty. The next class by count is a failed argument conversion, 275 of 1171.

## Per stem

| Stem | Functions | Holes | Defects |
|---|---|---|---|
| g_cmds | 54 | 81 | 143 |
| ai_util | 12 | 27 | 136 |
| g_vehicles | 38 | 51 | 93 |
| g_combat | 47 | 60 | 80 |
| g_ICARUScb | 161 | 25 | 43 |
| FighterNPC | 26 | 4 | 40 |
| NPC_spawn | 90 | 44 | 39 |
| g_weapon | 85 | 51 | 38 |
| g_bot | 25 | 27 | 36 |
| g_client | 46 | 60 | 35 |
| g_utils | 66 | 30 | 34 |
| g_session | 5 | 3 | 30 |
| g_spawn | 17 | 18 | 30 |
| ai_wpnav | 45 | 31 | 28 |
| g_items | 67 | 38 | 28 |
| g_nav | 50 | 17 | 27 |
| g_misc | 80 | 25 | 26 |
| g_mover | 72 | 17 | 25 |
| g_svcmds | 14 | 16 | 25 |
| w_saber | 79 | 166 | 21 |
| AnimalNPC | 12 | 1 | 17 |
| g_active | 36 | 16 | 14 |
| w_force | 52 | 44 | 13 |
| NPC_AI_Jedi | 68 | 29 | 11 |
| NPC_AI_Rancor | 16 | 7 | 11 |
| NPC_AI_GalakMech | 14 | 4 | 10 |
| g_target | 44 | 24 | 10 |
| g_vehicleTurret | 6 | 6 | 10 |
| SpeederNPC | 11 | 2 | 9 |
| g_team | 36 | 11 | 9 |
| WalkerNPC | 11 | 1 | 8 |
| g_trigger | 42 | 23 | 8 |
| NPC_stats | 8 | 23 | 7 |
| NPC_senses | 28 | 18 | 6 |
| ai_main | 108 | 77 | 6 |
| g_saga | 38 | 18 | 6 |
| tri_coll_test | 2 | 128 | 6 |
| NPC_combat | 43 | 53 | 5 |
| NPC_AI_Droid | 14 | 4 | 4 |
| NPC_AI_Seeker | 11 | 10 | 4 |
| NPC_AI_Wampa | 11 | 12 | 4 |
| g_log | 33 | 45 | 4 |
| g_turret_G2 | 15 | 18 | 4 |
| NPC_utils | 35 | 13 | 3 |
| g_turret | 14 | 10 | 3 |
| NPC_AI_Howler | 9 | 2 | 2 |
| NPC_AI_ImperialProbe | 12 | 9 | 2 |
| NPC_AI_MineMonster | 9 | 2 | 2 |
| NPC_AI_Sniper | 15 | 2 | 2 |
| NPC_AI_Stormtrooper | 31 | 7 | 2 |
| NPC_AI_Utils | 24 | 6 | 2 |
| g_main | 49 | 93 | 2 |
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
| NPC_goal | 7 | 1 | 0 |
| NPC_move | 11 | 2 | 0 |
| NPC_reactions | 12 | 2 | 0 |
| NPC_sounds | 2 | 0 | 0 |
| g_arenas | 1 | 0 | 0 |
| g_exphysics | 1 | 0 | 0 |
| g_mem | 3 | 4 | 0 |
| g_object | 4 | 0 | 0 |
| g_strap | 12 | 0 | 0 |
| g_timer | 12 | 0 | 0 |

## Defect classes

The Top stems column lists the three stems with the most lines in the class.

| Count | Message | Top stems |
|---|---|---|
| 275 | cannot convert value of type 'X' to expected argument type 'X' | ai_util 60, g_cmds 41, g_utils 16 |
| 150 | value of optional type 'X' must be unwrapped to a value of type 'X' | g_vehicles 62, FighterNPC 18, NPC_spawn 8 |
| 117 | binary operator 'X' cannot be applied to operands of type 'X' and 'X' | g_cmds 46, g_session 11, g_nav 8 |
| 103 | cannot pass immutable value as inout argument: 'X' is a 'X' constant | ai_util 54, ai_wpnav 8, NPC_AI_Rancor 6 |
| 98 | extra argument in call | g_cmds 40, NPC_spawn 9, g_misc 9 |
| 85 | cannot assign value of type 'X' to type 'X' (aka 'X') | g_vehicles 18, g_weapon 11, g_mover 8 |
| 82 | value of optional type 'X' must be unwrapped to refer to member 'X' of wrapped base type 'X' | g_combat 53, NPC_AI_Jedi 4, g_client 4 |
| 64 | cannot assign value of type 'X' to type 'X' | g_ICARUScb 21, g_items 5, ai_util 4 |
| 32 | cannot force unwrap value of non-optional type 'X' | g_vehicles 11, FighterNPC 10, g_weapon 8 |
| 31 | referencing operator function 'X' on 'X' requires that 'X' conform to 'X' | g_cmds 5, g_items 5, g_svcmds 5 |
| 17 | no exact matches in call to subscript  | g_session 6, g_utils 4, g_spawn 3 |
| 15 | no 'X' candidates produce the expected contextual result type 'X' | g_bot 6, g_client 3, g_utils 2 |
| 15 | missing argument label 'X' in subscript | ai_util 15 |
| 10 | argument type 'X' does not conform to expected type 'X' | ai_wpnav 5, NPC_stats 2, g_session 2 |
| 10 | value of type 'X' has no subscripts | w_saber 7, g_spawn 3 |
| 8 | cannot assign value of type 'X' to subscript of type 'X' | g_spawn 5, NPC_stats 2, g_items 1 |
| 6 | failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs) | g_cmds 2, NPC_AI_Sniper 1, g_bot 1 |
| 6 | cannot convert return expression of type 'X' to return type 'X' | g_ICARUScb 2, ai_wpnav 1, g_client 1 |
| 6 | cannot convert value of type 'X' to expected argument type 'X' (aka 'X') | g_ICARUScb 3, g_vehicleTurret 2, g_session 1 |
| 6 | cannot convert value of type 'X' (aka 'X') to expected argument type 'X' | g_mover 3, g_saga 2, g_misc 1 |
| 5 | cannot convert value of type 'X' to specified type 'X' | NPC_combat 1, ai_main 1, g_misc 1 |
| 4 | binary operator 'X' cannot be applied to operands of type 'X' (aka 'X') and 'X' | g_vehicleTurret 3, NPC_AI_GalakMech 1 |
| 4 | binary operator 'X' cannot be applied to two 'X' operands | g_cmds 2, g_active 1, g_svcmds 1 |
| 4 | subscript 'X' requires that 'X' conform to 'X' | g_items 3, g_log 1 |
| 3 | no exact matches in call to initializer  | NPC_AI_Jedi 2, g_session 1 |
| 2 | unary operators must not be juxtaposed; parenthesize inner expression | AnimalNPC 1, SpeederNPC 1 |
| 2 | module 'X' has no member named 'X' | g_main 2 |
| 2 | 'X' used with non-inout argument of type 'X' | g_session 1, g_spawn 1 |
| 1 | result values in 'X' expression have mismatching types 'X' and 'X' | AnimalNPC 1 |
| 1 | assigning a variable to itself | NPC_AI_Jedi 1 |
| 1 | no exact matches in call to global function 'X' | NPC_spawn 1 |
| 1 | cannot pass immutable value as inout argument: 'X' returns immutable value | NPC_spawn 1 |
| 1 | 'X' is unavailable: cannot subscript String with an Int, use a String.Index instead. | g_ICARUScb 1 |
| 1 | value of type 'X' has no member 'X' | g_active 1 |
| 1 | type 'X' cannot be used as a boolean; test for 'X' instead | g_items 1 |
| 1 | cannot pass immutable value as inout argument: 'X' is a get-only property | g_weapon 1 |
| 1 | the compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions | w_saber 1 |

The sections below cover the five largest classes. Each has one real line from the log.

### cannot convert value of type 'X' to expected argument type 'X'

A call passes a value whose Swift type does not match the parameter type. Two pairs make 157 of the 275 lines. The pair CharBuf to Int32 occurs 89 times, and UnsafeMutableRawPointer to CharBuf occurs 68 times. The stems ai_util and g_cmds hold 101 of the class. Example: `ai_util.swift:253: cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'CharBuf'`.

### value of optional type 'X' must be unwrapped to a value of type 'X'

A value has an optional type where the use needs a plain value. The draft does not unwrap it. The stem g_vehicles holds 62 of the 150 lines, and FighterNPC holds 18. Example: `g_vehicles.swift:212: value of optional type 'BgEntity?' must be unwrapped to a value of type 'BgEntity'`.

### binary operator 'X' cannot be applied to operands of type 'X' and 'X'

An operator has two operands of types that Swift does not mix, for example Float with Double, or Entity with Slots<Entity>. C converts these types without a cast. Swift does not. The stem g_cmds holds 46 of the 117 lines. Example: `g_cmds.swift:102: binary operator '-' cannot be applied to operands of type 'Entity' and 'Slots<Entity>'`.

### cannot pass immutable value as inout argument: 'X' is a 'X' constant

A call passes a name that the draft declares with `let` to a parameter that the callee changes. The stem ai_util holds 54 of the 103 lines. Example: `ai_util.swift:528: cannot pass immutable value as inout argument: 'group' is a 'let' constant`.

### extra argument in call

A call has more arguments than the callee takes. The stem g_cmds holds 40 of the 98 lines, and the same call often shows a conversion defect on the same line. Example: `g_cmds.swift:163: extra argument in call`.

## Parse errors

No stem has a Swift parse error that stops type-checking. Two lines carry a parser diagnostic: `AnimalNPC.swift:496` and `SpeederNPC.swift:408` both read "unary operators must not be juxtaposed; parenthesize inner expression". Both stems also show type errors after these lines, so the compiler reached them.

The log starts with two `[warn]` blocks from the C front end of draftcheck.py. They report 6628 and 5442 parse errors in the C headers, and the first three of each sit in `oracle/codemp/game/q_shared.h` (line 1242 and lines 1414 and 1415). These are errors in C source, not in the Swift drafts. The layouts they touch may be partial.

## Reading

Four stems hold 452 of the 1171 defects, 39 percent. They are g_cmds with 143, ai_util with 136, g_vehicles with 93, and g_combat with 80. Each of the four has one dominant class. In ai_util, 59 lines pass a raw pointer where a CharBuf is expected, and 54 lines pass a `let` constant as an inout argument. In g_cmds, 39 lines pass a CharBuf where an Int32 is expected. In g_vehicles, 62 lines are unwrapped-optional defects. In g_combat, 53 lines are optional-member defects on an Entity. Sixteen stems have zero defects: NPC, NPC_AI_Atst, NPC_AI_Default, NPC_AI_Grenadier, NPC_AI_Mark1, NPC_AI_Mark2, NPC_goal, NPC_move, NPC_reactions, NPC_sounds, g_arenas, g_exphysics, g_mem, g_object, g_strap, and g_timer.
