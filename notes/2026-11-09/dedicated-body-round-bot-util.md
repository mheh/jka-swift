# Dedicated body round: bot-util

Branch `ded-bodies-bot-util`, off master at `7961ee4`, in the worktree `/tmp/jka-bot-util`. The code commit is `09d9f77`. The round ran no generator, no draftcheck, and no snapshot tool. The stems are l_libvar, l_memory, l_log, l_crc, l_struct, be_ea, be_ai_gen, be_ai_char, be_ai_weight, and be_ai_weap of `oracle/codemp/botlib/`.

## The survey

A stub is blocked when it carries a `TODO: Port signature` marker, or when its body reads a record or a global that has no view and no storage in the host. The botlib has no host view: `Sources/JKAMP_Ded/Generated/Views/` holds no view for `libvar_t`, `logfile_t`, `fielddef_t`, `structdef_t`, `source_t`, `bot_input_t`, `bot_character_t`, `weightconfig_t`, `fuzzyseperator_t`, `weaponconfig_t`, `bot_weaponstate_t`, or `weaponinfo_t`. `botimport` and `botlibglobals` are `TODO: Port global` markers at `Sources/JKAMP_DedLogic/be_interface.swift:9` and `:19`, row B1 of the seventh ledger.

| Stem | Stubs | Signature markers | Blocked in all | Decision |
|---|---|---|---|---|
| l_libvar | 13 | 4 | 12 | rows only |
| l_memory | 8 | 4 | 6 | rows only |
| l_log | 7 | 1 | 7 | rows only |
| l_crc | 6 | 0 | 0 | bodies |
| l_struct | 9 | 9 | 9 | rows only |
| be_ea | 34 | 1 | 33 | rows only |
| be_ai_gen | 2 | 0 | 1 | bodies |
| be_ai_char | 19 | 5 | 19 | rows only |
| be_ai_weight | 21 | 20 | 21 | rows only |
| be_ai_weap | 13 | 4 | 13 | rows only |

Eight of the ten stems are blocked past half, so their files keep the skeleton header and get no edit.

## Bodies filled

l_crc.swift and be_ai_gen.swift lose the skeleton header in the code commit.

- l_crc: `crctable` takes Raven's 256 rows and one zero row, because Raven declares 257 slots, the form of `botGlobalNavWeaponWeights`. CRC_Init, CRC_Value, and CRC_ProcessString are ported. The `unsigned short` local and parameter keep their storage: a store truncates with `UInt16(truncatingIfNeeded:)` and a read widens with `Int32(...)`, the narrow local rule of the guide.
- be_ai_gen: GeneticSelection is ported. Raven's `select` is written and never read, so the build gives one warning at `be_ai_gen.swift:14`, and the line stays.

No site changes Raven's form, so the round has no rule 24 line. `grep -c Unsafe` gives 0 on both files. Each body was read line by line against Raven.

## Stubs that stay in the two filled stems

- CRC_ProcessByte, `l_crc.cpp:85`, and CRC_ContinueProcessString, `l_crc.cpp:126`: no file of either tree calls them, so each keeps its stub with the dead Port-note of rule 20, the form of `vm.swift:73`.
- GeneticParentsAndChildSelection, `be_ai_gen.cpp:73`: the body calls `botimport.Print` at `be_ai_gen.cpp:80` and `:91`. It keeps its stub with a Port-note that names row B1, at `be_ai_gen.swift:60`.

## The rows

Each row names its proof in Raven's tree and in the Swift tree, and the existing pattern it should follow.

- BU1, `botimport` and `botlibglobals`. Raven: `be_interface.cpp:39` and `:42`. Sites in these stems: `be_ea.cpp:37` to `:121` (eight text commands) and `:506`, `l_memory.cpp:331`, `:373`, `:414`, and `:425`, `be_ai_gen.cpp:80` and `:91`, `l_log.cpp:46` to `:124`, and the Print and file sites of be_ai_char, be_ai_weap, and be_ai_weight. Swift: `be_interface.swift:9` and `:19`. Pattern: row B1 of the seventh ledger, a copy of the records in `ded_types.h` under HOST_ROOTS, the form of row W1, with the table as a record on EngineStorage. This row blocks part of every stem of the round.
- BU2, the `void *` returns of the botlib allocator. Raven: GetMemory, GetClearedMemory, GetHunkMemory, and GetClearedHunkMemory at `l_memory.cpp:325`, `:346`, `:367`, and `:388`. Swift: `l_memory.swift:26` to `:60`. Pattern: RETURNS kind `raw`, row B5 of the seventh ledger, the row of S_Malloc of row Z3 of the fifth ledger. FreeMemory at `l_memory.cpp:406` reads the `unsigned long` word before the block, so it also needs a hand accessor in JKAMP_Ded in the form of `ZoneHeader(block:)` of `Sources/JKAMP_Ded/ZoneBlocks.swift`. Only PrintUsedMemorySize and PrintMemoryLabels are empty bodies that this round could write.
- BU3, `libvar_t` and `libvarlist`. Raven: the record at `l_libvar.h:16`, the list at `l_libvar.cpp:20`, and the four record signatures at `l_libvar.cpp:66`, `:85`, `:113`, and `:172`. Swift: `l_libvar.swift:8` and the markers at `:31`, `:46`, `:73`, and `:113`. Only the botlib reads the record, so the pattern is rule 9, a Swift struct held by the world, or the `ded_types.h` and HOST_ROOTS form of row W1 if the record keeps Raven's layout. LibVarStringValue at `l_libvar.cpp:28` needs no record and waits with its stem.
- BU4, `logfile_t` and `logfile`. Raven: the record at `l_log.cpp:26`, the static at `:33`, and `FILE *Log_FilePointer` at `:138`. Swift: `l_log.swift:11` and `:82`. Pattern: a struct of a `.c` file copied into the host hand header, the guide's form of `g_types.h`, the static as a record on EngineStorage, and the `FILE *` field as FIELDS kind `opaque`, the form of `qfile_gut`. Every l_log body reads `logfile`.
- BU5, the l_struct parameters. Raven: `fielddef_t` and `structdef_t` at `l_struct.h:31` and `:43`, `source_t` at `l_precomp.h:80`, and the `FILE *` and `void *p` parameters of the nine functions of `l_struct.cpp:43` to `:441`. Swift: the nine markers of `l_struct.swift:14` to `:141`. Pattern: the field table as `Slots<View>` and the record as `UnsafeMutableRawPointer` with the typed subscripts of `RawField.swift`, the form of BG_ParseField, and `FILE *` as `OpaquePointer?`, the stream handle of `FileBackend`. The `source_t` signatures wait for the l_precomp round.
- BU6, `bot_input_t` and `botinputs`. Raven: the record at `botlib.h:93`, the table at `be_ea.cpp:27`, and EA_GetInput at `be_ea.cpp:454`. Swift: `be_ea.swift:17` and `:388`. Pattern: the record in `ded_types.h` under HOST_ROOTS and TYPES gives `botinputs` the type `Slots<BotInput>?`, the form of `debugpolygons` of row B3, so EA_Setup fills it from GetClearedHunkMemory. The record crosses to the game through EA_GetInput, so it keeps Raven's layout. 25 be_ea stubs read the table, and eight call `botimport`. EA_EndRegular at `be_ea.cpp:427` is the one free stub, because Raven puts its whole body in a comment, so its body is empty, and it waits with its stem.
- BU7, `bot_character_t` and `botcharacters`. Raven: the records at `be_ai_char.cpp:46` and `:53`, and the table at `:60`. Swift: `be_ai_char.swift:23` and the five markers from `:34`. Pattern: the record in `ded_types.h` under HOST_ROOTS and the pointer table as a `Slots<View?>` on EngineStorage, the form of `gWPArray`. Every be_ai_char body reads the table or the record.
- BU8, `weightconfig_t`, `fuzzyseperator_t`, and `weightFileList`. Raven: the records at `be_ai_weight.h:19`, `:32`, and `:39`, and the table at `be_ai_weight.cpp:34`. Swift: `be_ai_weight.swift:15` and the 20 markers from `:27`. Pattern: the records in `ded_types.h` under HOST_ROOTS and the table as a `Slots<View?>` on EngineStorage, the form of `gWPArray`. BotShutdownWeights, the one stub without a marker, reads the table.
- BU9, `weaponconfig_t`, `bot_weaponstate_t`, `weaponinfo_t`, and the field tables. Raven: the records at `be_ai_weap.cpp:96` and `:105` and `be_ai_weap.h:27` and `:45`, the tables at `be_ai_weap.cpp:38`, `:66`, `:86`, `:90`, `:111`, and `:112`. Swift: `be_ai_weap.swift:9` to `:36`. Pattern: the records in `ded_types.h` under HOST_ROOTS, the two pointer statics on EngineStorage, and the `fielddef_t` tables as C storage, the form of `fields[]` of `g_spawn.c`, after BU5. BotValidWeaponNumber reads `weaponconfig` at `be_ai_weap.cpp:124`, so every stub waits.

## Counts

| Stem | portMissing before | portMissing after |
|---|---|---|
| l_libvar | 13 | 13 |
| l_memory | 8 | 8 |
| l_log | 7 | 7 |
| l_crc | 6 | 2 |
| l_struct | 9 | 9 |
| be_ea | 34 | 34 |
| be_ai_gen | 2 | 1 |
| be_ai_char | 19 | 19 |
| be_ai_weight | 21 | 21 |
| be_ai_weap | 13 | 13 |

The count before for l_crc includes the `crctable` initializer. The round removes five `portMissing` lines, 132 before and 127 after.

## Gate

- `swift build -j 2`: exit 0 on the first run. The one warning in the two files is the `select` line above.
- `swift test --no-parallel -j 2`: exit 0, 150 tests in nine runs, 1, 1, 1, 98, 13, 14, 3, 15, and 4, with 0 failures.
