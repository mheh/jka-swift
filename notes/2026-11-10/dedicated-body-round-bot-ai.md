# The bot-ai body round of the third wave

This record holds the body round of the seven `be_ai_*` stems of `Sources/JKAMP_DedLogic`, on the branch `ded-wave3-bot-ai` in the worktree `/tmp/jka-w3-bot-ai`. Three opus transcriptors wrote be_ai_chat, be_ai_goal, and be_ai_move. The bot-ai agent wrote be_ai_char, be_ai_weight, be_ai_weap, and be_ai_gen, and ran the build and the tests. The six generated files are adopted in the code commit. `be_ai_gen.swift` was adopted already.

## The counts

| File | Stubs | Filled | Left |
| --- | --- | --- | --- |
| be_ai_char | 19 | 19 | 0 |
| be_ai_chat | 60 | 46 | 14 |
| be_ai_gen | 1 | 0 | 1 |
| be_ai_goal | 43 | 41 | 2 |
| be_ai_move | 67 | 42 | 25 |
| be_ai_weap | 13 | 11 | 2 |
| be_ai_weight | 21 | 19 | 2 |
| Total | 224 | 178 | 46 |

A filled body can hold inline holes. Each hole is a `Port-note` that names its row, a `Raven wrote:` line, and a `portMissing` call with the name and the cite of the function, the form of `sv_bot.swift:109` to `:111`. `portMissing(` stands 237 times in the seven files.

## The stubs left, with the reason

- be_ai_move: the 25 functions with a `-> Never` signature, the `BotTravel_*` and `BotFinishTravel_*` functions and BotMoveInGoalArea, which return `bot_moveresult_t` by value. Row P13.
- be_ai_chat, dead under rule 20: BotDumpSynonymList, BotDumpRandomStringList, BotDumpMatchTemplates, BotDumpReplyChat, BotDumpInitialChat, BotPrintReplyChatKeys. Only comments call them, at `be_ai_chat.cpp:733`, `:1020`, `:1330`, `:1955`, and `:2151`.
- be_ai_chat, row P3 (D12 shape 11): BotLoadSynonyms (`be_ai_chat.cpp:596`), BotLoadRandomStrings (`:949`), BotLoadInitialChat (`:2018`).
- be_ai_chat, row P14: BotCheckChatMessageIntegrety, BotCheckInitialChatIntegrety, BotCheckReplyChatIntegrety.
- be_ai_chat, row P15: StringReplaceWords, BotReplaceReplySynonyms.
- be_ai_goal: ItemWeightIndex (`-> Never`, row P8), and BotFindEntityForLevelItem, dead under rule 20. Its one call is in a comment block at `be_ai_goal.cpp:1156`.
- be_ai_weap: WeaponWeightIndex (`-> Never`, row P8), and BotChooseBestFightWeapon (rows P4 and P8).
- be_ai_weight: FuzzyWeight and FuzzyWeightUndecided, row P4.
- be_ai_gen: GeneticParentsAndChildSelection, rows P1 and P9.

## The rows

Each row has no existing pattern in the dedicated, game, or cgame code. A Swift line is in the worktree, and a Raven line is under `oracle/codemp/`.

- P1, `botimport.Print`. Raven's `void (QDECL *Print)(int type, char *fmt, ...)` of `game/botlib.h` crosses as `runPrint(_ type: Int32, _ fmt: OpaquePointer?)` at `Sources/JKAMP_Ded/Generated/Views/BotlibImport.swift:71`, with no text form and no arguments. The `const char *msg` of `displayContextDef_t.Print` gets a `String` at `Sources/JKAMP_CGame/Generated/Views/DisplayContextDef.swift:792`, because the field is `const`. Candidate: a text row for the `char *fmt` of the field, and a run method that formats with `JKAShared.format(fmt, args)`, the form of `BotImport_Print` at `sv_bot.swift:278`. 164 holes: char 23, weight 7, weap 18, chat 23, goal 19, move 15. This row stops every load of a character, a weight, or a weapon config on its success path, because Raven prints "loaded ..." there.
- P2, the union `value` of `bot_characteristic_t` (`be_ai_char.cpp:39` to `:50`) has no accessor: `Sources/JKAMP_Ded/Generated/Views/BotCharacteristic.swift:70` keeps `TODO: Port bot_characteristic_t.value`. Candidate: one accessor per member, `integer`, `_float`, and `string` as `String?` that interns, the form of a named union of `qfile_gut` (transcription.md:393). 16 holes in be_ai_char, 3 in be_ai_chat.
- P3, a table of records, a record with its text after it, or one block cut into many records in a botlib block (D12 shapes 8 and 11). No Slots form over such a block exists in a logic body. 3 stubs and 2 holes in be_ai_chat (`be_ai_chat.cpp:1538` among them).
- P4, the `int *inventory` of FuzzyWeight and FuzzyWeightUndecided (`be_ai_weight.cpp:627`, `:658`) crosses as one `inout Int32` at `be_ai_weight.swift`, and the body hands it to the `Slots<Int32>` of FuzzyWeight_r. Their callers BotChooseLTGItem, BotChooseNBGItem, and BotChooseBestFightWeapon hold the `Slots<Int32>` of D16. Candidate: the PARAMS kind `bytes` of D16, the `SV_AreaEntities` row at `rulings.py:849`. 2 stubs in be_ai_weight, 1 in be_ai_weap, 2 holes in be_ai_goal (the goal agent's G3).
- P5, the `char type` of `bot_characteristic_t` and the `char offset` of `bot_matchvariable_t` are `CChar` on their views (`BotCharacteristic.swift:64`, `BotMatchvariable.swift:64`), where transcription.md:612 gives a narrow field `Int32`. Applied, no hole: a read takes `Int32(...)` and a store takes `CChar(...)` or `Int8(truncatingIfNeeded:)`. Candidate: the generator widens a `char` scalar field.
- P6, FreeFuzzySeperators_r tests `!fs` at `be_ai_weight.cpp:97`, and ReadFuzzySeperators_r passes a NULL `firstfs` at `:229` when the first name is invalid. The parameter is a plain view, so the unwrap traps there. Candidate: the NULL sweep makes it `Fuzzyseperator?`. One note, no hole.
- P7, the dedicated logic target has no `crandom` of `q_shared.h`. `random` is at `common.swift:2077`, and `crandom` exists only at `Sources/JKAMP_BG/bg_lib.swift:195`. 1 hole in EvolveFuzzySeperator_r. Candidate: `crandom` beside `random` in `common.swift`.
- P8, the `int *` index tables. `bot_weaponstate_t.weaponweightindex` and `bot_goalstate_t.itemweightindex` are `OpaquePointer?` on their views (`BotWeaponstate.swift:70`, `BotGoalstate.swift:70`), and WeaponWeightIndex and ItemWeightIndex return `int *` with no table row. Raven indexes the fields at `be_ai_weap.cpp:409` and `be_ai_goal.cpp:1329`, `:1500`. Candidate: the FIELDS kind `bytes`, the `leafbrushes` row at `rulings.py:430`, and a `Slots<Int32>` return. 1 hole in be_ai_weap, 3 in be_ai_goal (the goal agent's G2).
- P9, the local `float rankings[256]` of GeneticParentsAndChildSelection (`be_ai_gen.cpp:75`) goes to the `Slots<Float>` of GeneticSelection. Candidate: a `BYTE_STORAGE_LOCALS` row.
- P10, AAS_BSPModelMinsMaxsOrigin (`be_aas_bspq3.cpp:195`, `be_aas_bspq3.swift:91`) writes `mins`, `maxs`, and `origin`, but takes them by value. Candidate: `inout`, and `inout vec3_t?` for the NULL `origin`, transcription.md:262. 4 holes in be_ai_move.
- P11, the `avoidspots` of BotGetReachabilityToGoal is `BotAvoidspot?`, but Raven passes the table `ms->avoidspots` (`be_ai_move.cpp:3279`, `:3401`) and hands it to the `Slots<BotAvoidspot>` of BotAvoidSpots. Candidate: the PARAMS kind `table` with NULLABLE, D16. 3 holes in be_ai_move.
- P12, the locals `avoidreach`, `avoidreachtimes`, and `avoidreachtries` of BotPredictVisiblePosition (`be_ai_move.cpp:899` to `:901`) have no Slots storage. Candidate: `BYTE_STORAGE_LOCALS` rows. 2 holes in be_ai_move.
- P13, a record return with no signature: AAS_Trace (`be_aas_bspq3.swift:28`), AAS_TraceClientBBox (`be_aas_sample.swift:214`), and the 25 travel functions of be_ai_move. Candidate: the RETURNS kind `record` of transcription.md:129, with `trace.copy(from: AAS_Trace(...))` at a site. 40 holes in be_ai_move, 2 in be_ai_goal (the goal agent's G1).
- P14, a view parameter that Raven's callers pass NULL to: BotFreeMatchPieces, BotFreeMatchTemplates, BotFreeReplyChat, BotCheckReplyChatIntegrety, and the `stringlist` and `list` parameters of BotCheckChatMessageIntegrety and BotFindStringInList (`be_ai_chat.cpp:1097`, `:1224`, `:1674`, `:1593`, `:1496`, `:1480`). The NULL sites are `be_ai_chat.cpp:1142`, `:1205`, `:1264`, `:1273`, `:1836`, `:1958`, `:1578`, and `:1604`. Candidate: the NULL sweep makes them optional. 3 stubs and 6 holes in be_ai_chat.
- P15, StringContainsWord returns `String?`, but Raven returns a pointer into `str1` that StringReplaceWords (`be_ai_chat.cpp:534` to `:544`) and BotReplaceReplySynonyms (`:817`, `:822`) compare and step. Candidate: the RETURNS kind `text_offset`, transcription.md:160. 2 stubs.
- P16, `%ld` at `be_ai_chat.cpp:875` is outside the format subset of `Sources/JKAShared/Format.swift:125` to `:150`. Candidate: the `l` length modifier. 1 hole.
- P17, the conversions Raven did not write, applied with no hole. The `unsigned long` of `token_t.intvalue` (D5) meets an `int` with no operator of `Promotion.swift`, so a store into an `int` takes `Int32(truncatingIfNeeded:)` or `Int32(bitPattern:)`, a compare takes `UInt32(bitPattern:)`, and a store into a `float` takes `Float(...)`. A `sizeof` or a `strlen` size into the `unsigned long` of GetMemory takes `UInt32(...)`, the `Int32(View.byteCount)` form with the parameter type. be_ai_chat passes an `int` to an `unsigned long` parameter at `be_ai_chat.cpp:2548`, `:2734`, and `:2742` with `UInt32(bitPattern:)` and an AI line. Candidate: `UInt32` operators in `Promotion.swift`, and the `Int32` overload of transcription.md:647 on GetMemory and the chat functions.
- P18, BotChooseNBGItem takes `ltg: BotGoal`, so its body drops Raven's `if (ltg)` tests at `be_ai_goal.cpp:1465` and `:1534` and the `ltg_time = 99999` arm. The game can pass NULL through the export. Candidate: a NULLABLE row.
- P19, the `var0` to `var7` texts of BotInitialChat and BotReplyChat are `String`, and Raven tests them for NULL at `be_ai_chat.cpp:2499` and `:2682`. The body drops the tests. The output is the same, because an empty text copies zero bytes. Candidate: the NULL sweep makes them `String?`.

## The rule 19 notes

- BotLoadCharacterFromFile tests `index > MAX_CHARACTERISTICS` (`be_ai_char.cpp:249`), so index 80 reads one characteristic past the block. The Slots of `c` traps there.
- BotDumpCharacter passes the float `skill` to a `%d` (`be_ai_char.cpp:93`). The port passes the integer part.
- BotExpandChatMessage tests `num > MAX_MATCHVARIABLES` (`be_ai_chat.cpp:2270`) and reads `variables[8]`. The Slots traps there.
- BotResetLastAvoidReach reads `avoidreachtries[MAX_AVOIDREACH]` (`be_ai_move.cpp:3537`) when `latesttime` is not 0. The Slots traps there.
- BotSetBrushModelTypes writes `modeltypes[MAX_MODELS]` (`be_ai_move.cpp:510` to `:523`). The array traps there.

## The forms the bodies use

- A record block: `View(GetClearedMemory(UInt32(View.byteCount)))`, and its free `FreeMemory(view.handle)`, the form of `Z_Free(pack.handle)` at `files_common.swift:415`.
- A record with its tables after it (D12 shape 10, row N8): the form of `files_pc.swift:1679` to `:1682` in LoadWeaponConfig and LoadItemConfig.
- A text for a `char *` field (D12 shape 6): the CopyString form of `z_memman_pc.swift:403` to `:405`, and its free drops under an AI line.
- A record that crosses to ReadStructure: `UnsafeMutableRawPointer(view.handle)` with the rule 11 comment, the form of the BG_ParseField caller.
- `levelitemheap` and `consolemessageheap`: `Slots<View>(raw, count:)` of `ServerViews.swift:9`.

## The checks

- `swift build -j 2`: exit 0. The warnings in the seven files are 133 "will never be executed" after a hole, 15 unused results, and 16 of other kinds.
- `swift test --no-parallel -j 2`: exit 0, 150 tests in 9 runs pass.
