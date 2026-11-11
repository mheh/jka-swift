# Docket 10, the rows of the third body wave

This docket holds the rows of five body-round records of the third wave. Each row is proved at Raven's line and at the Swift line, and it has a verdict.

- bot-ai: `/tmp/jka-w3-bot-ai/notes/2026-11-10/dedicated-body-round-bot-ai.md`, rows P1 to P19.
- g2tr: `/tmp/jka-w3-g2tr/notes/2026-11-10/dedicated-body-round-g2tr.md`, rows G1 to G5, R2 to R6, T1, S1, H1, D1.
- cmsv: `/tmp/jka-w3-cmsv/notes/2026-11-10/dedicated-body-round-cmsv.md`, rows B1, B1a, B4, B5, B6, Z6, C, C2, R1 to R5, S1, P7, the old R4, the `TERRAIN_STEP_MAGIC` finding, CM_Checksum.
- bot-lib: `/tmp/jka-w3-bot-lib/notes/2026-11-10/dedicated-body-round-bot-lib.md`, rows BL1 to BL14.
- bot-aas: `/tmp/jka-w3-bot-aas/notes/2026-11-10/dedicated-body-round-bot-aas.md`, rows A1 to A14 and its list of forms.
- path: `/tmp/jka-w3-path/notes/2026-11-10/dedicated-body-round-path.md`, rows 1 to 7 (W3P1, W3P2, L1, ICARUS_Init, W3P4, the two copies of JKAShared, the bot run).

Every Raven cite is under `oracle/codemp/` of the main tree, and an OpenJK cite is under `openjk/codemp/` of the main tree. A Swift cite names its worktree: `[ai]` is `/tmp/jka-w3-bot-ai`, `[g2]` is `/tmp/jka-w3-g2tr`, `[cm]` is `/tmp/jka-w3-cmsv`, `[lib]` is `/tmp/jka-w3-bot-lib`, `[aas]` is `/tmp/jka-w3-bot-aas`, and `[path]` is `/tmp/jka-w3-path`. A cite of `rulings.py`, `skeleton.py`, `reexport.py`, `table.py`, or a doc is in `[cm]`, which has the tools of master `6f3abc1`.

The verdicts:

- `PATTERN`: the form exists in this codebase for the same kind of thing, and the row cites it.
- `NO PATTERN`: no form of the same kind exists. The row gives two candidate forms and a recommendation.

## The live path of the botlib in MP

This fact changes the order of the docket, so it comes first.

The MP game calls only these botlib entries: `trap_BotLibSetup`, `trap_BotLibShutdown`, the Alloc, Free, and Reset calls of the move, goal, and weapon states, `trap_BotUpdateEntityItems`, `trap_AAS_EntityInfo`, `trap_AAS_PointReachabilityAreaIndex`, the `trap_EA_*` calls, `trap_BotUserCommand`, `trap_BotGetSnapshotEntity`, `trap_BotGetServerCommand`, `trap_BotAllocateClient`, `trap_Bot_UpdateWaypoints`, `trap_Bot_CalculatePaths`, and `trap_BotGetMemoryGame` and `trap_BotFreeMemoryGame`. The proof is a search of `trap_(Bot|AAS|EA)` in every `game/*.c` file except `g_syscalls.c`.

- No file of the game calls `trap_BotLibLoadMap`, `trap_BotLoadCharacter`, `trap_BotLoadChatFile`, `trap_BotInitialChat`, `trap_BotMoveToGoal`, `trap_BotChooseLTGItem`, `trap_BotChooseNBGItem`, `trap_BotChooseBestFightWeapon`, or `trap_GeneticParentsAndChildSelection`. The server calls only `BotLibVarSet`, `Test`, `BotLibSetup`, and `BotLibShutdown` of the export, `server/sv_bot.cpp:249`, `:250`, `:608`, `:625`.
- `Export_BotLibSetup` of `botlib/be_interface.cpp` calls `AAS_Setup` and `EA_Setup`, and Raven comments out `BotSetupWeaponAI`, `BotSetupGoalAI`, `BotSetupChatAI`, and `BotSetupMoveAI`.
- `G_InitGame` calls `BotAISetup` when `bot_enable` is set, `game/g_main.c:1068`, and `BotAISetup` calls `trap_BotLibSetup`, `game/ai_main.c:7610`. `AAS_Setup` calls `GetClearedHunkMemory`, so `botimport.HunkAlloc` runs on every map load with bots enabled.

So the AAS file load, the reachability and routing code, and the AI layers of chat, goal, move, weapon, character, and genetic selection do not run in the MP dedicated server. The rows of those stems are off the live path. The import table, the export thunks, `GetBotLibAPI`, the allocators, and the EA layer are on it.

## Tier 0, the stops of the run path

The path round ran `jampded +set dedicated 1 +map mp/ffa1`. The committed tree stops in SV_BotInitBotLib (row X1). A probe tree that skipped each stop then stopped at the hunk of CMod_LoadSubmodels (row X46), at ICARUS_Init (row X47), and at SP_worldspawn (row Z6). These rows come first.

### X46, the leaf index distance overflows `Int32` on arm64 (L1 at run time)

Question: `ClipMap.leafsurfaces(_:)` traps in CMod_LoadSubmodels with "Not enough bits to represent a signed value", because two hunk blocks lie more than 8 GB apart.

Proof of Raven's hunk:
- Raven's JKA MP has no contiguous hunk. `Hunk_Alloc` is `return Z_Malloc(size, hunk_tag, qtrue);` at `qcommon/z_memman_pc.cpp:791`, and `Hunk_AllocateTempMemory` is `Z_Malloc(size, TAG_TEMP_HUNKALLOC, qfalse)` at `:804`. `Z_Malloc` takes each block from `calloc` or `malloc` of the C library, `z_memman_pc.cpp:184` and `:186`.
- `Com_InitHunkMemory` of `z_memman_pc.cpp:678` only sets `hunk_tag = TAG_HUNK_MARK1` and calls `Hunk_Clear`. The hunk is a pair of zone tags, `TAG_HUNK_MARK1` and `TAG_HUNK_MARK2`, and `Com_ShutdownHunkMemory` frees each tag, `:683` to `:688`. `common.cpp:1294` calls `Com_InitHunkMemory` under the old comment "allocate the stack based hunk allocator", which the JKA code no longer does.
- `s_hunkData` does not exist in `oracle/codemp`. It is the arena of Q3, and Raven replaced it.
- OpenJK keeps Raven's zone hunk: `openjk/codemp/qcommon/z_memman_pc.cpp:823` is the same one-line `Hunk_Alloc`. So the claim of the path record, "the form of the Q3 hunk that OpenJK keeps", is wrong for MP.

Proof of the distance:
- CMod_LoadSubmodels stores `indexes - cm.leafbrushes` and `indexes - cm.leafsurfaces` into `int firstLeafBrush` and `int firstLeafSurface` of `cLeaf_t`, `qcommon/cm_load.cpp:154` and `:161`. Each `indexes` is a separate `Hunk_Alloc` block, so the difference is of two pointers into two objects, which C leaves undefined. On the 32-bit WinDed the difference in words always fits in an `int`.
- OpenJK widens both fields to `ptrdiff_t`, `openjk/codemp/qcommon/cm_local.h:48` and `:51`, and keeps the subtraction at `openjk/codemp/qcommon/cm_load.cpp:174` and `:181`.

Proof of the port:
- `[path] Sources/JKAMP_DedLogic/z_memman_pc.swift:563` is Raven's `Hunk_Alloc` over `Z_Malloc`, and the zone takes each block from the C library through `ZoneBackend`.
- `[path] Sources/JKAMP_Ded/LumpViews.swift:77` to `:85` give `leafbrushes(_:)` and `leafsurfaces(_:)` as `Int32(... distance ... / stride)`, and `leafbrush(at:)` and `leafsurface(at:)` read at the base plus the index. This is row L1 of ledger 8, which the user ruled on 2026-11-09: "Keep Raven's memory and Raven's numbers, and put the unchecked step in the view layer". `Int32(...)` traps when the distance passes 2^31 words.
- The record says the probe ran with `MallocNanoZone=0` and trapped the same way.

Verdict: NO PATTERN in the repo. OpenJK gives a precedent for the field width, and the change reopens the user's ruling L1, so the row goes to the user.

Candidates:
- A. The OpenJK form. `cLeaf_t` stands in `ded_types.h` as a copy with `firstLeafBrush` and `firstLeafSurface` of pointer width, under one AI line, and HOST_ROOTS keeps its view. The two view functions return `Int`, and the two readers take `Int`. The ilp32 layout does not change, and only the 64-bit copy grows. The form of a width change in a host copy is the `UINT4` row (`rulings.py:812` to `:814`) and the `token_t` widths of D5.
- B. A contiguous hunk arena: `Hunk_Alloc` takes each block from one large block that `Com_InitHunkMemory` reserves, so every distance stays small. This is the arena of Q3, not the MP code of Raven or OpenJK. `Hunk_Clear` and the tag frees of `TAG_HUNK_MARK1` and `TAG_HUNK_MARK2` then need an arena form, and the zone stats change.
- C. The leaf keeps a table index into a host-side `[Slots<Int32>]` of the blocks, and the readers look the block up. This changes Raven's numbers and every reader site.

Recommendation: A. It is the smallest change that makes the pointer difference defined, it keeps Raven's zone, and it has an OpenJK counterpart. The probe of the path round used B, and B also loaded the map.

Touches: generator (`ded_types.h`, HOST_ROOTS stays), hand code in the view target (`LumpViews.swift`). The ten reader sites keep their text. A change of ruling L1.

Live path: yes. Every map load with a submodel stops here.

### X47, ICARUS_Init, Interface_Init, and `interface_export_t` (path row 4)

Question: the path record says ICARUS_Init has no form, Interface_Init has no signature, and `interface_export_t` has no Swift form.

Proof: master `6f3abc1` already holds `Sources/JKAMP_DedLogic/interface_export_t.swift`, a final class of stored Swift functions with one AI line, and HAND_VARS names `"interface_export": "interface_export_t"` at `rulings.py:561`. CXX_CLASSES names `"interface_export_s": "interface_export_t"` at `rulings.py:1453`. So the record is wrong about the type: `[path] CSequencer.swift:50` and `:115` already declare `interface_export_t?`, and the Port-notes of `[path] CSequencer.swift:382` to `:1030` are stale. Two parts are open on master: the stub of Interface_Init is `() -> Never` with "No table row for `interface_export_t * pe`" (`[path] Q3_Interface.swift:795`), and ICARUS_Init is a stub (`[path] GameInterface.swift:111`). The g2tr branch fills both, `[g2] GameInterface.swift:111` to `:121` and `[g2] Q3_Interface.swift:823`, and the `m_ie` sites of `[g2] CSequencer.swift:386` and `:425`.

Verdict: PATTERN.

Form: the g2tr bodies land as they stand. The generator gives Interface_Init the signature `(_ pe: interface_export_t?)` by the CXX_CLASSES pointer rule, `docs/transcription.md:142`, part G1g of row X14. The stale Port-notes of the path branch go at the merge.

Touches: the merge of g2tr before path, and generator (`spelling.py` or `table.py`, row X14 G1g).

Live path: yes. G_InitGame calls `trap_ICARUS_Init` on every map load, `[path] g_main.swift:854`.

### X48, two copies of `JKAShared` in `jampded` and the game dylib (path row 6)

Question: the loader prints that `SharedChannel` and `StringPool` are implemented in both `jampded` and `jampgamearm64.dylib`.

Proof: `[path] Package.swift:10` builds `jampgame` as a dynamic library, and `:75` builds `jampded` as an executable. Both reach `JKAShared` (`:46`) as a static target, so each image links its own copy, with its own `sharedChannel` and `StringPool.shared`. The cgame round met the same warning between the game and cgame dylibs and recorded it with no change, `notes/2026-11-03/cgame-listen-server-runs.md:37`: "Raven's two modules also hold the bg files twice." Raven's engine and module also compile `q_shared.c` and `q_math.c` once each. Rule 6 gives one instance per logical singleton per module. The two images exchange C words through the syscall transport and no Swift object, so the runtime warning about casts does not apply to a value that crosses.

Verdict: PATTERN, no change.

Form: each image keeps its own copy, the form recorded for the game and the cgame.

Precedent: `notes/2026-11-03/cgame-listen-server-runs.md:37`, rule 6.

Touches: nothing. A future change that passes a Swift object of `JKAShared` across the ABI would break this, and rule 11 forbids that already.

Live path: yes, at every load of the module, with no effect on the run.

### X49, the bot run (path row 7)

Question: with `bot_enable 1`, G_InitGame calls `trap_BotLibSetup`, and the record says its arm is the hole of row B1 at `sv_game.swift:1044`.

Proof: `game/g_main.c:1068` and `game/ai_main.c:7610`. The record cites the wrong arm: `[path] sv_game.swift:1033` is BOTLIB_SETUP and calls SV_BotLibSetup, and the hole at `:1044` holds the 11 arms from BOTLIB_LIBVAR_SET to BOTLIB_TEST. The Port-note there, "`botlib_export_t` has no host form", is stale on the path branch: the cmsv branch fills 100 of the 134 botlib arms through the run methods, and its SV_BotLibSetup is whole at `[cm] sv_bot.swift:708`. After the merge, BOTLIB_SETUP reaches `Export_BotLibSetup` and `AAS_Setup`, then `GetClearedHunkMemory`, `GetHunkMemory` (a stub of bot-lib, row BL1), and `botimport.HunkAlloc` (row X1, W3P2).

Verdict: PATTERN. No row of its own: the stops of a bot run are rows X1 and X2.

Touches: the merge of cmsv and bot-lib.

Live path: yes, every map load with the default `bot_enable 1`.

## Tier 1, every server start, map load, spawn, or frame

### Z6, the module's `CGhoul2Info_v *` word (Z6 of cmsv, W3P4 of path)

Question: 45 arms of SV_GameSystemCalls read `args[1]` as a `CGhoul2Info_v *` and `VMA(1)` as a `CGhoul2Info_v **`, and the host has no form that gives the Swift class back from the word.

Proof of Raven: `server/sv_game.cpp:1316` to `:1617`, for example `G2API_HaveWeGhoul2Models( *((CGhoul2Info_v *)args[1]) )` at `:1325`. `ghoul2/G2_API.cpp:616` allocates `*ghoul2Ptr = new CGhoul2Info_v`, `:2340` does the same for a copy, and `:563` deletes it. Raven's `CGhoul2Info_v` is 4 bytes, `int mItem`, a handle into `TheGhoul2InfoArray`, `ghoul2/ghoul2_shared.h:328`. `server/sv_world.cpp:692` to `:782` read the same word, and `sv_world.cpp` also needs storage for its static `G2Trace_t G2Trace`.

Proof of the game side: the module holds the word as an engine handle, `OpaquePointer?`, `docs/transcription.md:523`. `trap_G2API_InitGhoul2Model` takes it as `inout OpaquePointer?` (`[path] Sources/JKAMP_Game/Generated/g_syscalls.swift:2073`), and a game body tests `ent.ghoul2 != nil`. So the module needs a word that is not zero for an instance and zero for none, and it never reads through the word.

Proof of the host: `[path] CGhoul2Info_v.swift:9` is a final class with `mItem`, `init(_ item:)` at `:366`, and a `deinit` that frees the item at `:370`. So a temporary `CGhoul2Info_v(item)` per arm frees the models when the arm returns, and `init(_ item:)` is no form for the arms. `Ghoul2InfoArray` (`[path] Ghoul2InfoArray.swift:11`) is the table of the model vectors by `mItem`, and it does not hold the `CGhoul2Info_v` instances. Swift `[path] sv_game.swift`, the 45 arms in one hole, and SP_worldspawn reaches the first arm at `[path] g_spawn.swift:577`. No `Unmanaged` stands anywhere under `Sources/`. The cmsv record names the same row Z6, and the path record says Z6 is gone because the G2API stubs have signatures now. The signatures do not give the word a form, so the two rows are one row.

Verdict: NO PATTERN.

Candidates:
- A. A table of the instances on `EngineWorld`, `[CGhoul2Info_v?]`, and the word is the slot number plus 1 as the bit pattern of the `OpaquePointer?`, so 0 stays NULL. `new` takes a free slot, and `delete` stores nil, so the `deinit` frees the item. This is the form of a host handle table that the module holds, the botlib state tables of D13 (`BotMoveStateFromHandle`).
- B. The word is the address of the instance, `Unmanaged.passRetained(instance).toOpaque()`, in the view target only, and `delete` releases it. The word has Raven's shape, an address.
- C. A C block of 4 bytes per instance that holds `mItem`, the first candidate of the path record, with a host table from the block to the class.

Recommendation: A. It needs no pointer in the logic target, the module sees a non-zero opaque word as it does today, and it has a precedent of the same kind in D13. `G2Trace` takes the static-local form of `docs/transcription.md:480`.

Touches: hand code in the view target (`GameViews.swift`, a `VMA` overload that reads the slot), and the logic target (`EngineWorld.swift`, `G2_API.swift` at `new` and `delete`, `sv_game.swift`, `sv_world.swift`).

Live path: yes. SP_worldspawn on every map load, a player spawn, and a saber trace.

### X1, the `botlib_import_t` surface (BL1, P1, B1, A4, A5, A7, W3P1, W3P2, and the import half of B5)

This row is the stop point of the committed tree of the path round, and it belongs to Tier 0.

Question: the run methods of `BotlibImport` take untyped `OpaquePointer?` values and drop two returns, and `SV_BotInitBotLib` stores none of the 21 functions.

Proof of W3P1 and W3P2, the path branch: `[path] sv_bot.swift:847` holds `BotlibImportThunks`, a copy of the generator skeleton of `sv_bot.cpp`. The skeleton `~/.cache/jka-swift/snapshot-mp-engine-ded/skeleton/sv_bot.swift` has no thunk for the five file functions FS_FOpenFileByMode, FS_Read2, FS_Write, FS_FCloseFile, and FS_Seek that Raven stores at `server/sv_bot.cpp:702` to `:706`. These five are functions of `files_pc.cpp`, another stem. The thunk writer already holds functions of another stem: `BotlibExportThunks` holds `PC_LoadSourceHandle` and `PC_FreeSourceHandle` of `l_precomp.cpp`, `[lib] be_interface.swift:894` and `:902`. Of the 18 thunks the skeleton writes, 10 are `portMissing` markers, and three of them are the W3P2 thunks with a Port-note: BSPEntityData (`[path] sv_bot.swift:855`), GetMemory (`:888`), and HunkAlloc (`:893`). Their typealiases return `OpaquePointer?`, `[path] Sources/JKAMP_Ded/Generated/Views/Callbacks.swift:234`, `:264`, `:266`, and the Swift functions return `String` and `UnsafeMutableRawPointer`.

Form of W3P1: the thunk sweep takes a stored function of another stem, the form of `PC_LoadSourceHandle` in `BotlibExportThunks`. The cause of the gap needs one read of the sweep: the five carry a `fileHandle_t *`, a `void *`, or a `long`.

Form of W3P2: a thunk that returns a text hands the C caller a pointer with `ringText(_:)`, the reader of `[lib] Sources/JKAMP_CGame/ThunkReaders.swift:27`, which `CG_FeederItemText` uses at `[lib] cg_main.swift:3855` to `:3865`. A thunk that returns a block returns `OpaquePointer(block)`, the form of `Z_Free(OpaquePointer(x.base))` at `files_pc.swift:1729`. Both readers go into the host twin of `ThunkReaders.swift` below, so the logic target names no `Unsafe` type. Verdict of W3P1 and W3P2: PATTERN.

Proof of the stores: Raven stores 21 functions into `botlib_import` at `server/sv_bot.cpp:694` to `:724`. Swift `[cm] Sources/JKAMP_DedLogic/sv_bot.swift:811` is one hole. The generator writes a `<Record>Thunks` enum only into a stub with the skeleton header, and `sv_bot.swift` is adopted, so no `BotlibImportThunks` exists. The claim holds.

Proof of the run methods: `game/botlib.h:157` to `:198` against `[lib] Sources/JKAMP_Ded/Generated/Views/BotlibImport.swift:71` to `:390`. Each member, its Swift state, and its form:

| Member | Raven type | Run method today | Verdict and form |
| --- | --- | --- | --- |
| `Print` | `void (QDECL *)(int type, char *fmt, ...)` | `runPrint(_ type: Int32, _ fmt: OpaquePointer?)`, no arguments, `:71` | NO PATTERN, row X1a |
| `Trace` | `void (*)(bsp_trace_t *, vec3_t, vec3_t, vec3_t, vec3_t, int, int)` | `BspTrace?` and four `inout vec3_t`, `:84` | correct. The vectors that only the engine reads take the copy with a comment, `transcription.md:267` |
| `EntityTrace` | the same with `entnum` | `:105` | correct, as `Trace` |
| `PointContents` | `int (*)(vec3_t)` | `inout vec3_t`, `:127` | correct |
| `inPVS` | `int (*)(vec3_t, vec3_t)` | `:143` | correct |
| `BSPEntityData` | `char *(*)(void)` | `-> String?`, `:161` | correct |
| `BSPModelMinsMaxsOrigin` | `void (*)(int, vec3_t, vec3_t, vec3_t, vec3_t)` | four `inout vec3_t`, `:174` | correct |
| `BotClientCommand` | `void (*)(int client, char *command)` | `OpaquePointer?` for `command`, `:195` | NO PATTERN, row X1b |
| `GetMemory` | `void *(*)(int size)` | returns nothing, `:208` | PATTERN: RETURNS `raw` keyed `"botlib_import_t.GetMemory"`, the kind of `Bot_GetMemoryGame` (`rulings.py:980`) and the `record.field` key of `rulings.py:1150` |
| `FreeMemory` | `void (*)(void *ptr)` | `OpaquePointer?`, `:221` | correct, the form of `Z_Free(OpaquePointer(x.base))`, `files_pc.swift:1729` |
| `AvailableMemory` | `int (*)(void)` | `:235` | correct |
| `HunkAlloc` | `void *(*)(int size)` | returns nothing, `:248` | PATTERN, as `GetMemory`, the kind of `BotImport_HunkAlloc` (`rulings.py:982`) |
| `FS_FOpenFile` | `int (*)(const char *, fileHandle_t *, fsMode_t)` | `OpaquePointer?` for `file`, `:262` | PATTERN: an `inout fileHandle_t`, the PARAMS kind `float_mut` of `("displayContextDef_t.ownerDrawHandleKey", "special")` (`rulings.py:1150`) for a scalar of a stored function, with the `int` pointee |
| `FS_Read` | `int (*)(void *, int, fileHandle_t)` | `OpaquePointer?`, `:278` | PATTERN: PARAMS `bytes` keyed `"botlib_import_t.FS_Read"`, the row of `FS_Read` (`rulings.py:1188`) |
| `FS_Write` | `int (*)(const void *, int, fileHandle_t)` | `OpaquePointer?`, `:292` | PATTERN, as `FS_Read`, the row of `FS_Write` (`rulings.py:1190`) |
| `FS_FCloseFile` | `void (*)(fileHandle_t)` | `:305` | correct |
| `FS_Seek` | `int (*)(fileHandle_t, long, int)` | `CLong`, `:319` | correct. `botlib.h` is outside `MSVC_WIDTH_FOLDERS` (`rulings.py:875`), and the value fits |
| `DebugLineCreate` | `int (*)(void)` | `:333` | correct |
| `DebugLineDelete` | `void (*)(int)` | `:346` | correct |
| `DebugLineShow` | `void (*)(int, vec3_t, vec3_t, int)` | `:359` | correct |
| `DebugPolygonCreate` | `int (*)(int, int, vec3_t *)` | `OpaquePointer?`, `:377` | PATTERN: PARAMS `table` keyed `"botlib_import_t.DebugPolygonCreate"`, the row of `BotImport_DebugPolygonCreate` (`rulings.py:1229`) |
| `DebugPolygonDelete` | `void (*)(int)` | `:390` | correct |

Verdict of the stores: PATTERN. `sv_bot.swift` takes a private `BotlibImportThunks` enum at the end of the stub in the generated shape, and `SV_BotInitBotLib` stores `botlib_import.Print = BotlibImportThunks.BotImport_Print` and the 20 others in Raven's order.

Precedent of the stores: "uses the private thunk at the end of the stub of the store", `docs/transcription.md:592`, the hand `LeafListThunks` of `[cm] cm_test.swift:473`, and the adopted `DisplayContextDefThunks` of `[lib] Sources/JKAMP_CGameLogic/cg_main.swift:3841`. A thunk reads a C text with `text(at:)` and a vector with `vector(at:)`, the readers of `[lib] Sources/JKAMP_CGame/ThunkReaders.swift:9` and `:15`. The host view target has no reader, so `JKAMP_Ded` takes a twin of `ThunkReaders.swift`.

Note: the ledger has no row for the hand `LeafListThunks` of `cm_test.swift:473` and `cm_trace.swift:1796`, as cmsv says. This docket row is the precedent the ledger records for both.

Touches: generator (`views.py` and `spelling.py` for the `record.field` keys of RETURNS and PARAMS, and `rulings.py` PARAMS and RETURNS), hand code in the view target (the reader twin of `ThunkReaders.swift`), and hand code in the logic target (`BotlibImportThunks` and the 21 stores in `sv_bot.swift`).

Live path: yes. `SV_Init` calls `SV_BotInitBotLib` at every server start, and `AAS_Setup` calls `botimport.HunkAlloc` through `GetClearedHunkMemory` at every map load with bots enabled. `trap_EA_Say` reaches `botimport.BotClientCommand` when a bot talks.

#### X1a, the variadic `Print` member (BL1, P1, A5)

Question: `Print` is a C variadic function pointer, and the botlib calls it at about 260 sites with format arguments: 164 in bot-ai, about 95 in bot-aas, and 14 in bot-lib.

Proof: `game/botlib.h:160`, `[lib] BotlibImport.swift:71`. The cgame twin `DisplayContextDef.runPrint(_ msg: String)` at `[ai] Sources/JKAMP_CGame/Generated/Views/DisplayContextDef.swift:792` has no arguments, because `ui/ui_shared.c` calls `DC->Print` only with a literal, `:222` and `:4171`. Swift cannot call a C variadic function. Only Swift fills the field and only Swift calls it, so the C type of the pointer is never called by C.

Verdict: NO PATTERN.

Candidates:
- A. The run method takes `(_ type: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...)`, formats with `JKAShared.format` in the view target, and passes the text and the format `"%s"` through the stored pointer. The thunk calls `BotImport_Print(type, "%s", text(at: $1!))`. The form of the arguments is D18 of the ninth batch (`BotImport_Print` at `[cm] sv_bot.swift:312`).
- B. A C variadic shim in `CJKAHost` that the field holds, with a `va_list` decode into a Swift callback.

Recommendation: A. It adds no C code, and the text that `BotImport_Print` writes is the same, because `vsprintf` of `"%s"` copies the text. The text passes through `str[2048]` of `sv_bot.cpp` as before.

#### X1b, the non-const `char *` parameter of a stored function (BotClientCommand)

Question: `BotClientCommand` takes a non-const `char *command` that the filler only reads, and the run method gives `OpaquePointer?`.

Proof: `game/botlib.h:174`, `[lib] BotlibImport.swift:195`, filler `BotImport_BotClientCommand` of `server/sv_bot.cpp`. The view gives a `String` only for a `const char *` parameter of a stored function. No PARAMS kind gives a text, and the text sweep has no body to read for a field.

Verdict: NO PATTERN.

Candidates:
- A. A PARAMS row `("botlib_import_t.BotClientCommand", "command")` of a new kind `text`, keyed as `rulings.py:1150` is. The reason is the trap rule of `docs/transcription.md:105`: Raven's missing `const` is habit.
- B. `views.py` reads the parameter of the stored function as the text sweep reads its filler, `BotImport_BotClientCommand`, whose Swift parameter is a `String`.

Recommendation: A. One row per field is explicit and needs no sweep of the filler.

### X2, the export thunks and the botlib arms of `SV_GameSystemCalls` (B5, the thunk markers of bot-lib)

Question: the run methods of `botlib_export_t`, `aas_export_t`, `ea_export_t`, and `ai_export_t` take `OpaquePointer?` for a module `char *`, `int *`, or `float (*)[3]`, and the generated thunks of `be_interface.swift` keep a marker for such a parameter.

Proof: Raven `server/sv_game.cpp:948`, `:950`, `:953`, `:961`, `:971`, and 29 arms from `:981` to `:1311`. Swift `[cm] sv_game.swift:1060` (5 arms) and `:1484` (29 arms), `[cm] Sources/JKAMP_Ded/Generated/Views/Ai_export.swift:250` (`runBotInitialChat`, nine `OpaquePointer?`), `[cm] BotlibExport.swift:118` (`runBotLibVarSet`). The thunks: `[lib] Sources/JKAMP_DedLogic/be_interface.swift:515`, `:600`, `:860`, `:917`, for example `EA_Say` at `:982` and `Export_BotLibLoadMap` at `:862` are `portMissing` thunks. The claim holds, and the cause is one cause: the host has no thunk reader.

Verdict: PATTERN.

Form: each arm passes `args.VMA(n)` to the run method, the `VMA -> OpaquePointer?` overload of `[cm] Sources/JKAMP_Ded/GameViews.swift:32`, as TRAP_MEMSET does. Each generated thunk decodes the handle into the Swift parameter: `text(at:)` for a text, `Slots<Int32>(scalars:count:)` for an `int *` list, and `vector(at:)` for a vector, the form of `CG_PlayCinematic` and `CG_OwnerDrawHandleKey` at `[lib] Sources/JKAMP_CGameLogic/cg_main.swift:3843` to `:3881`. The readers are the host twin of `ThunkReaders.swift` of row X1.

Touches: hand code in the view target (the reader twin), generator (the thunk writer of `skeleton.py` takes the host readers), and hand code in the logic target (the 34 arms of `sv_game.swift`).

Live path: yes for bots. `trap_EA_Say`, `trap_EA_SayTeam`, and `trap_EA_Command` reach the BOTLIB_EA_SAY arms of `[cm] sv_game.swift:1473` when a bot talks. The other arms of the hole serve calls that the MP game never makes.

### X3, `BOTLIB_API_VERSION` (BL5, B1a)

Question: the host does not re-export `BOTLIB_API_VERSION` of `game/botlib.h:16`.

Proof: only `[lib] Sources/JKAMP_Game/Generated/botlib.swift` and `[lib] Sources/CJKAMP_Game/include/codemp/game/botlib/constants.h` hold it. Raven reads it at `botlib/be_interface.cpp:842` and `server/sv_bot.cpp:722`. Swift: the literal 2 under one AI line at `[cm] sv_bot.swift:813`, and a hole in `GetBotLibAPI` in `[lib] be_interface.swift`. `[lib] Sources/JKAMP_Ded/Generated/botlib.swift` holds `PRT_MESSAGE`, `BOTFILESBASEFOLDER`, and `CMS_NORMAL`, so the D10 copy landed, and line 16 is outside it. Row B1 of ledger 8 copied `botlib.h:18` to `:28`, `:40` to `:44`, and `:92` to `:422`. The claim of BL5 holds: D10 is ruled, and this macro of it did not land.

Verdict: PATTERN.

Form: `ded_types.h` copies `botlib.h:16` with the other macros of D10, the reexport gives the constant, and both sites read the name. The AI line of `sv_bot.swift:813` goes.

Precedent: D10 of the ninth batch, the macros `ded_types.h` copies with their records, `[cm] Sources/JKAMP_Ded/Generated/net_chan.swift:8`.

Touches: generator (the hand header `ded_types.h`, then `reexport.py`), hand code in the logic target (two sites).

Live path: yes. `GetBotLibAPI` tests the version at server start.

### X4, UnCompressBone and the matcomp unit (R3)

Question: UnCompressBone takes `mat: [[Float]]` by value, `MC_UnCompressQuat` has no stub, and `mdxaCompQuatBone_t` has no view.

Proof: Raven `renderer/tr_ghoul2.cpp:1158`, and the callers pass the `matrix` of an `mdxaBone_t` that the body writes at `:1464`, `:1707`, `:1708`, `:1723`, `:1747`, `:1748`. `renderer/matcomp.c` is not in the host parse. `mdx_format.h:119` declares `mdxaCompQuatBone_t`. Swift `[g2] Sources/JKAMP_DedLogic/tr_ghoul2.swift`, UnCompressBone stub. The claim holds.

Verdict: PATTERN.

Form: three parts.
- The parameter is the `MdxaBone` view, "a `mdxaBone_t *` parameter is the view", row G3 of ledger 8, and a caller passes the record.
- `renderer/matcomp.c` joins the host source list of `project.toml`, so the skeleton writes `MC_UnCompressQuat`, the entry-list form of row G3 of ledger 8 (`tr_local.h`).
- HOST_ROOTS names `mdxaCompQuatBone_t`, the mdx rows of `rulings.py:315` to `:325`.

Touches: generator (`project.toml`, `rulings.py` HOST_ROOTS and PARAMS), hand code in the logic target (the body).

Live path: yes. `G2API_GetBoltMatrix` of the game reaches `CBoneCache.EvalLow` and UnCompressBone, the bone path of every saber and bolt.

### X5, the static locals of G2_TransformBone (R4)

Question: the static locals of G2_TransformBone have no storage.

Proof: Raven `renderer/tr_ghoul2.cpp:1544` to `:1552`. Swift `[g2] tr_ghoul2.swift`, G2_TransformBone stub.

Verdict: PATTERN.

Form: a property of `EngineWorld` with Raven's name and a forward in `tr_ghoul2.swift`, the static-local form of `docs/transcription.md:480`, with the function name as a suffix where a name repeats.

Precedent: `cv_CM_TracePointThroughPatchCollide`, row TR6 and P3 of ledger 8, and `sPrevMapName` of `tr_model.swift`.

Touches: hand code in the logic target (`EngineWorld.swift`, `tr_ghoul2.swift`).

Live path: yes, the bone path of row X4.

### X6, `mdxaIndex_t` (R2)

Question: `mdxaIndex_t` has no view, so G2_GetBonePoolIndex has no body.

Proof: `renderer/mdx_format.h:410`, read at `renderer/tr_ghoul2.cpp:1152`. Swift `[g2] tr_ghoul2.swift`, G2_GetBonePoolIndex stub.

Verdict: PATTERN.

Form: HOST_ROOTS names `mdxaIndex_t`, and the body reads the index at its offset through `HandleView.init(_:byteOffset:)` of `LumpViews.swift`.

Precedent: `rulings.py:315` to `:325`, and the G2A4 form of ledger 9.

Touches: generator (`rulings.py` HOST_ROOTS), hand code in the logic target.

Live path: yes, the bone path of row X4.

### X7, `qsort` over a table of records (G3)

Question: no `qsort` form sorts a table of records in C memory.

Proof: Raven `ghoul2/G2_API.cpp:2117` and `:2170` sort `collRecMap`, `CollisionRecord_t[MAX_G2_COLLISIONS]`, with QsortDistance. Swift holes `[g2] G2_API.swift:1442` and `:1488`. The host `qsort` of `[g2] Sources/JKAMP_Ded/CommonViews.swift:148` and `:154` sorts a Swift `[T]`, and bg has `qsort(_ a: Slots<Int32>, ...)` at `[g2] Sources/JKAMP_BG/bg_lib.swift:61`. `VM_ProfileSort` sorts an array of record pointers, which is a `[View]`. No body of the game, the cgame, or the host sorts records by value.

Verdict: NO PATTERN.

Candidates:
- A. A `qsort` overload over `Slots<V: HandleView>` in `CommonViews.swift`, beside the `Slots<Int32>` overload of bg, that copies the records out, sorts with the same algorithm as the `[T]` overload, and copies them back.
- B. A body form: copy the records into a Swift array of scratch records, sort with the `[T]` overload, and copy back, with one AI line.

Recommendation: A. It is the record twin of `bg_lib.swift:61`, and the call site reads as Raven wrote it.

Note: the host `qsort` ports Raven's BSD `qsort` of `bg_lib.c`, and WinDed links the MSVC runtime `qsort`. The order of two records of equal distance can differ. This is not new to the row, because `paksort` and `SV_QsortEntityNumbers` use the same function.

Touches: hand code in the view target.

Live path: yes. G2API_CollisionDetect traps at the sort, and a saber trace of a dedicated server reaches it.

### X8, a pointer stored in an `int` (G4)

Question: R_TransformEachSurface stores a pointer in an `int` slot, and the trace functions read it back as `float *`.

Proof: Raven `ghoul2/G2_misc.cpp:416`, `TransformedVertsArray[i] = (int)TransformedVerts`. Swift `[g2] G2_misc.swift:325`, `:567`, `:575`, `:583`. Ledger 8 left `mTransformedVertsArray` open for the same reason. R_TransformEachSurface also needs G2_GetVertWeights, G2_GetVertBoneIndex, and G2_GetVertBoneWeight of `mdx_format.h:290` to `:322`, which are row X12.

Verdict: NO PATTERN.

Candidates:
- A. The slot holds the byte offset of the vertices in the `CMiniHeap` block, and a reader turns the offset into a `Slots<Float>`. The `int` keeps its width and the offset fits in 32 bits.
- B. A Swift table `[Slots<Float>?]` on the `CGhoul2Info`, one per surface, in place of the C `int` slots.

Recommendation: A. It keeps Raven's memory and Raven's numbers, the form the user ruled for row L1 of ledger 8, with the unchecked step in the view layer.

Touches: hand code in the view target and the logic target, the PARAMS rows of `rulings.py:1303` and `:1304` stay.

Live path: yes, the saber trace of row X7.

### X9, `CTraceSurface.collRecMap` (G5)

Question: `CTraceSurface.collRecMap` is one record, and Raven's field is a table.

Proof: Raven `ghoul2/G2_misc.cpp:190`, `CollisionRecord_t *collRecMap`. Swift `[g2] CTraceSurface.swift:17` and `:45`.

Verdict: PATTERN.

Form: `Slots<CollisionRecord>?` on the hand class, the type the PARAMS kind `table` of G2_TraceModels gives.

Precedent: `rulings.py:1317` (`table`) and `:1579` (NULLABLE).

Touches: hand code in the logic target (`CTraceSurface.swift`).

Live path: yes, the saber trace of row X7.

### X10, G2_ProcessSurfaceBolt2 and the mdx inline functions (R5)

Question: the three `static inline` functions of `mdx_format.h:290` to `:322` have no Swift home, and `mdxmTriangle_t` has no view.

Proof: Raven `renderer/mdx_format.h:250` and `:290` to `:322`. Swift `[g2] tr_ghoul2.swift`, G2_ProcessSurfaceBolt2 stub.

Verdict: PATTERN.

Form: each inline function is a hand function of the same name in the logic target with a `/// Source:` cite, and HOST_ROOTS names `mdxmTriangle_t`.

Precedent: `BG_GiveMeVectorFromMatrix`, "a `static ID_INLINE` function of bg_public.h, which is a macro to the port", `docs/transcription.md:339`, and the mdx rows of `rulings.py:315` to `:325`.

Touches: generator (`rulings.py` HOST_ROOTS), hand code in the logic target.

Live path: yes when the game asks the bolt matrix of a surface bolt, through G2_GetBoltMatrixLow.

### X11, the `SET_` names of `Q3_Interface.h` (S1 of g2tr)

Question: the `SET_` names go only into the game target, so the switch of ICARUS_InterrogateScript has no names.

Proof: Raven `icarus/Q3_Interface.h:6` to `:255`, read at `server/GameInterface.cpp:540` to `:572`. Swift hole `[g2] GameInterface.swift:449`. The names stand in `JKAMP_Game/Generated/Q3_Interface.swift:9` only.

Verdict: PATTERN.

Form: `icarus/Q3_Interface.h` joins the host entry list of `project.toml`, and the reexport writes the names into `JKAMP_Ded`.

Precedent: rows 4 and 5 of ledger 9, the four headers of the icarus round.

Touches: generator (`project.toml`, `tests/test_project.py`, `reexport.py` run).

Live path: yes on a map with ICARUS scripts. The hole traps on every text `set` block of a script precache at map load.

### X12, the ICARUS time stamp (T1)

Question: `CTask.m_timeStamp` is `Int32`, `I_GetTime` returns `UInt32`, and the format takes no `UInt32`.

Proof: Raven `icarus/taskmanager.h:56`, `DWORD m_timeStamp`, `icarus/interface.h:9`, `typedef unsigned long DWORD`, and `:24`. Holes `[g2] CTaskManager.swift:632` (`TaskManager.cpp:728`), the Wait stub (`TaskManager.cpp:1111` to `:1132`), and `[g2] CSequencer.swift:979` (`Sequencer.cpp:973`). `[g2] CTask.swift:11` declares `Int32`. `Format.swift` conforms `Int32`, `UInt8`, `Int`, `Float`, `Double`, and the texts, and not `UInt32`.

Verdict: PATTERN.

Form:
- `m_timeStamp`, `GetTimeStamp`, and `SetTimeStamp` of `CTask` take `UInt32`, because `icarus` is in `MSVC_WIDTH_FOLDERS` (`rulings.py:875`) and `unsigned long` is 32 bits there.
- `UInt32` conforms to `FormatArg` as `.integer(Int64(self))`, the twin of the `UInt8` conformance at `[ai] Sources/JKAShared/Format.swift:32`.
- The Wait stub also needs a `Slots` over a local `float` for `SetData`, which is row X20.

Touches: hand code in the logic target (`CTask.swift`, the three sites), hand code in `JKAShared` (`Format.swift`).

Live path: yes on a map with ICARUS scripts. The Go hole traps on the first task of any script.

### X13, `std::pop_heap` and `std::push_heap` (H1)

Question: CPriorityQueue uses the heap algorithms of the C++ library, and the order of edges of equal cost follows the MSVC algorithm.

Proof: Raven `server/NPCNav/navigator.cpp:2737`, `:2757`, `:2771`. Swift `[g2] CPriorityQueue.swift`, Pop, Push, and Update stubs. Rule 17 gives `Array` for a `std::` member, and no rule names an algorithm of the C++ library. The MSVC library is not in the oracle.

Verdict: NO PATTERN.

Candidates:
- A. Private hand functions `push_heap` and `pop_heap` in `CPriorityQueue.swift` that follow the MSVC 6 algorithm step for step, with its sift order, and one AI line that names the library.
- B. A Swift binary heap of the textbook form, with one AI line that says the order of equal costs can differ.

Recommendation: A. The path an NPC takes depends on the order of equal costs, and rule 1 asks for parity.

Touches: hand code in the logic target.

Live path: yes when an NPC asks a path from the navigator.

### X14, the Ghoul2 signatures that the generator does not write (G1)

Question: the round changed seven signatures by hand, and the generator gives other ones.

Proof and form, each part:
- G1a. G2_RagSetState `bool &resetOrigin` (`ghoul2/G2_bones.cpp:2152`) and G2_BuildHitPointST, four `float &` (`ghoul2/G2_misc.cpp:677`): `inout Bool` and `inout Float` at `[g2] G2_bones.swift:1491` and `[g2] G2_misc.swift:471`. PATTERN: a non-const C++ reference to a scalar is `inout`, the twin of the reference rule of the TYPES vectors and maps (`rulings.py:847`, `:853`) and of the hand class `[g2] CTaskManager.swift:660`. Touches `spelling.py`.
- G1b. EvalBoneCache returns `const mdxaBone_t &` (`renderer/tr_ghoul2.cpp:585`): returns `MdxaBone` at `[g2] tr_ghoul2.swift:277`. PATTERN: a C++ reference to a record is the record's view, `docs/transcription.md:126`, and `CBoneCache.Eval` (`[g2] CBoneCache.swift:155`). Touches `spelling.py` for the return role.
- G1c. G2_GetBoneBasepose and G2_GetBoneMatrixLow take `mdxaBone_t *&` (`renderer/tr_ghoul2.cpp:656`, `:727`): `inout MdxaBone?` at `[g2] tr_ghoul2.swift:347` and `:399`. PATTERN: "a pointer to a struct pointer, in a function that is not a trap" is `inout View?`, `docs/transcription.md:103`, and a `T **` of a class (`spelling.py:358`). Touches `spelling.py`.
- G1d. G2_FindSurface_BC returns `void *` (`renderer/tr_ghoul2.cpp:2952`): `MdxmSurface?` at `[g2] tr_ghoul2.swift:1039`. PATTERN: RETURNS `("view", "mdxmSurface_t")`, the row of G2_FindSurface at `rulings.py:1004`. Touches `rulings.py`.
- G1e. G2_ProcessSurfaceBolt2 `surface`: G2_GetBoltMatrixLow passes NULL at `renderer/tr_ghoul2.cpp:3316` to `:3324`. PATTERN: a NULLABLE row, the form of `rulings.py:1576`. Touches `rulings.py`.
- G1f. G2_TimingModel kept the old marker after batch 9. PATTERN: an adopted stem takes the stub of the generator at the changed signature, matched by its `Source:` line, ledger 8 line 5, and `lookup.py sig` gives it, `docs/transcription.md:37`. Touches hand code only.
- G1g. Interface_Init `interface_export_t *pe` (`icarus/Q3_Interface.cpp:956`): `(_ pe: interface_export_t?)` at `[g2] Q3_Interface.swift:823`, and the skeleton writes `() -> Never`. CXX_CLASSES already names `"interface_export_s": "interface_export_t"` at `rulings.py:1453`, so the table row exists, and the spelling misses the typedef name. PATTERN: the CXX_CLASSES pointer rule, optional for a pointer, `docs/transcription.md:142`. Touches `spelling.py` or `table.py` (the lookup by the canonical record name).

Verdict: PATTERN, each part as above.

Live path: no stop. The hand signatures already build. The rows keep the next generator run from a second form.

### X15, the `ERagState` enum (G2)

Question: `ERagState` of `ghoul2/G2_bones.cpp:1233` has no generated names, and `[g2] G2_bones.swift:151` holds three file-private lets.

Proof: no header names `ERS_DYNAMIC`, `ERS_SETTLING`, or `ERS_SETTLED`. Only `G2_bones.cpp` declares them.

Verdict: PATTERN, no change.

Form: the file-private `let` constants of a host `.cpp` enum with Raven's values, the `file_enums` rows the skeleton writes for a host `.cpp` enum.

Precedent: `GT_FFA` of `be_ai_goal.swift`, ledger 9 line 21, and the five constants of `be_aas_entity.cpp:32` in bot-aas. The next skeleton run must not write a second copy, because `G2_bones.swift` is adopted.

Touches: nothing.

Live path: no effect.

### X16, `_ =` before the `Q3_Registers` calls (D1)

Question: Q3_SetVar writes `_ =` at `[g2] Q3_Interface.swift:256` to `:265`.

Proof: `[g2] Q3_Registers.swift:108`, `:156`, and `:168` declare Q3_GetFloatVariable, Q3_SetFloatVariable, and Q3_SetStringVariable with no `@discardableResult`. The record says row 12 of ledger 9 put the attribute on these declarations. That is wrong: row 12 put it on other declarations, and these three do not have it.

Verdict: PATTERN.

Form: `@discardableResult` on the Q3_Registers declarations whose result Raven drops, and the `_ =` lines go.

Precedent: `docs/transcription.md:789`, and row 12 of ledger 9.

Touches: hand code in the logic target.

Live path: no effect.

## Tier 2, the bot paths that the MP game does not call

These rows are correct work, but no MP server reaches them. Each row says so.

### X17, a record returned by value (P13, A1)

Question: AAS_Trace, AAS_TraceClientBBox, and the 25 travel functions of be_ai_move return a record by value and have no signature.

Proof: Raven `botlib/be_aas_bspq3.cpp:130` (`bsp_trace_t`), `botlib/be_aas_sample.cpp:432` (`aas_trace_t`), and the `BotTravel_*`, `BotFinishTravel_*`, and BotMoveInGoalArea functions of `botlib/be_ai_move.cpp` (`bot_moveresult_t`). Swift `[aas] be_aas_bspq3.swift` and `[aas] be_aas_sample.swift` markers, and 25 `-> Never` stubs of `[ai] be_ai_move.swift`. 40 holes in be_ai_move, 2 in be_ai_goal, 21 in bot-aas.

Verdict: PATTERN.

Form: RETURNS kind `record` for each function, and a BYTE_STORAGE_LOCALS key `(<local>, <function>)` for the local each body returns, so the body returns the storage record and the caller copies it, `trace.copy(from: AAS_TraceClientBBox(...))`.

Precedent: `Com_GetRealEvent`, `Com_GetEvent`, and `Sys_GetEvent` of RETURNS (`rulings.py:967` to `:969`), and the keys `("ev", "Com_GetRealEvent")` and `("ev", "Sys_GetEvent")` of `rulings.py:610` and `:611`. `docs/transcription.md:129`.

Touches: generator (`rulings.py` RETURNS and BYTE_STORAGE_LOCALS).

Live path: no. AAS_Trace runs only after an AAS load, and the MP game loads no AAS map.

### X18, AAS_BSPModelMinsMaxsOrigin writes its outputs (P10, A2)

Question: the function takes `mins`, `maxs`, and `origin` by value, but the import writes them.

Proof: Raven `botlib/be_aas_bspq3.cpp:195` hands them to `botimport.BSPModelMinsMaxsOrigin`, and `server/sv_bot.cpp:387` writes them, with `if (outmins)` before each copy. Swift `[aas] be_aas_bspq3.swift:91`, `origin` is `vec3_t?`. NULL callers: `be_aas_reach.cpp:3305`, `be_aas_entity.cpp:107`, `be_ai_move.cpp:435`.

Correction of P10: the optional inout of `docs/transcription.md:262` is for a NULL test that does more than skip the write. Here the NULL arm only skips the write, so A2 is right.

Verdict: PATTERN.

Form: PARAMS `vec3_mut` for `mins`, `maxs`, and `origin`. A caller that passes NULL passes a scratch local, `var origin = vec3_t()`, with a plain comment that names the NULL output and no Port-note, `docs/transcription.md:254` and `:261`.

Precedent: `("Sys_SnapVector", "v")` and `("CM_ParseVector", "v")` at `rulings.py:1078` and `:1259`.

Touches: generator (`rulings.py` PARAMS), hand code at the callers.

Live path: no. The callers are the AAS load, the reachability code, and AAS_UpdateEntity, which only BotLibUpdateEntity reaches.

### X19, NULL into a view parameter (P14, A8, BL13, P6, P11, G1e is in X14)

Question: Raven's callers pass NULL to a view parameter, and the parameter is a plain view.

Proof:
- P14: BotFreeMatchPieces, BotFreeMatchTemplates, BotFreeReplyChat, BotCheckReplyChatIntegrety, and the `stringlist` and `list` parameters of BotCheckChatMessageIntegrety and BotFindStringInList, `botlib/be_ai_chat.cpp:1097`, `:1224`, `:1674`, `:1593`, `:1496`, `:1480`. The NULL reaches through a local that starts NULL, at `:1142`, `:1205`, `:1264`, `:1273`, `:1836`, `:1958`, `:1578`, `:1604`.
- A8: AAS_UnlinkFromAreas (`botlib/be_aas_sample.cpp:1175`), AAS_UnlinkFromBSPLeaves (`be_aas_bspq3.cpp:206`), and AAS_BestReachableLinkArea (`be_aas_reach.cpp:168`). Swift `[aas] be_aas_sample.swift:770` takes `AasLink`.
- BL13: `tokens` of PC_StringizeTokens, `botlib/l_precomp.cpp:450`, gets `parms[parmnum]`, which is NULL for an empty argument, at `:848`. Swift `[lib] l_precomp.swift:298`.
- P6: FreeFuzzySeperators_r tests `!fs` at `botlib/be_ai_weight.cpp:97`, and ReadFuzzySeperators_r passes a NULL `firstfs` at `:166` to `:235`. Swift `[ai] be_ai_weight.swift:72`.
- P11: `avoidspots` of BotGetReachabilityToGoal is `BotAvoidspot?` at `[ai] be_ai_move.swift:409`, and Raven passes the table `ms->avoidspots` at `be_ai_move.cpp:3279` and `:3401`. This one also needs PARAMS `table`.

Verdict: PATTERN.

Form: one NULLABLE row per parameter. P11 also takes PARAMS `table`.

Precedent: NULLABLE `("increment", "node")` at `rulings.py:1545`, and PARAMS `table` with NULLABLE for `("AAS_TraceAreas", "points")` at `rulings.py:1329` and `:1559`.

Touches: generator (`rulings.py` NULLABLE and PARAMS).

Live path: no. A8 claims AAS_UnlinkInvalidEntities reaches the hole on the first frame, but only AAS_StartFrame calls it, and only BotLibStartFrame calls that, which no MP caller reaches.

### X20, more scalar kinds for BYTE_STORAGE_LOCALS (P9, P12, A10, the Wait stub of T1)

Question: a local array of `float` or `unsigned short` that Raven hands to a list parameter has no storage form.

Proof:
- P9: `float rankings[256]` of GeneticParentsAndChildSelection, `botlib/be_ai_gen.cpp:75`, to the `Slots<Float>` of GeneticSelection.
- P12: `avoidreach`, `avoidreachtimes`, and `avoidreachtries` of BotPredictVisiblePosition, `botlib/be_ai_move.cpp:899` to `:901`, `int`, `float`, `int`.
- A10: `unsigned short startareatraveltimes[128]` of AAS_UpdateAreaRoutingCache, `botlib/be_aas_route.cpp:1275`, whose address a record keeps.
- T1: the Wait stub of `icarus/TaskManager.cpp:1111` hands a local `float` to `SetData`.

`skeleton.py:72` holds `INT_ELEMENTS = (TypeKind.INT, TypeKind.UINT)`, and a TYPES typedef, an `unsigned char`, and a `vec3_t` take their own arms. A `float` and an `unsigned short` take none.

Verdict: PATTERN.

Form: a BYTE_STORAGE_LOCALS key per local, and `INT_ELEMENTS` of `skeleton.py:72` takes `TypeKind.FLOAT` and `TypeKind.USHORT`, so the forward is `Slots<Float>` or `Slots<UInt16>`.

Precedent: the `int` keys of `rulings.py:632` to `:635` and the `unsigned int` rule of `UINT4 x[16]` (`rulings.py:595`). An `unsigned short` field of FIELDS kind `bytes` is already a `Slots`, row N5 (`rulings.py:751`, `:752`).

Touches: generator (`rulings.py` BYTE_STORAGE_LOCALS, `skeleton.py:72`).

Live path: no for the botlib parts. Yes for the Wait stub on a map with ICARUS scripts.

### X21, the botlib list parameters (P4, P8)

Question: FuzzyWeight and FuzzyWeightUndecided take `int *inventory` as one `inout Int32`, and the two `int *` weight index fields and their builders have no form.

Proof:
- P4: `botlib/be_ai_weight.cpp:627` and `:658` against `[ai] be_ai_weight.swift:475` and `:488`. The bodies hand `inventory` to FuzzyWeight_r, which takes `Slots<Int32>` (`:394`). The callers already take `Slots<Int32>` by `rulings.py:1322` to `:1324`.
- P8: `bot_weaponstate_t.weaponweightindex` and `bot_goalstate_t.itemweightindex` are `OpaquePointer?` at `[ai] Sources/JKAMP_Ded/Generated/Views/BotWeaponstate.swift:70` and `BotGoalstate.swift:70`. Raven indexes them at `be_ai_weap.cpp:407` and `be_ai_goal.cpp:1329`, `:1500`. WeaponWeightIndex and ItemWeightIndex return `int *` with no row, `[ai] be_ai_weap.swift:229` and `be_ai_goal.swift:280`.

Verdict: PATTERN.

Form:
- P4: PARAMS `bytes` for `("FuzzyWeight", "inventory")` and `("FuzzyWeightUndecided", "inventory")`.
- P8: FIELDS `bytes` for the two fields, and RETURNS `bytes` for the two builders. An `int *` of kind `bytes` is `Slots<Int32>` for a field and a parameter today. The return role takes the same rule in `spelling.py`. The body binds the block as `Slots<Int32>(scalars: block, count:)`, the form of `vm_interpreted.swift:81` and site B of ledger 9.

Precedent: `rulings.py:1322` (PARAMS), `rulings.py:691` (FIELDS `leafbrushes`), `rulings.py:971` (RETURNS `bytes`).

Touches: generator (`rulings.py`, and `spelling.py` for an `int *` return of kind `bytes`).

Live path: no. The choosers run only from `trap_BotChooseLTGItem`, `trap_BotChooseNBGItem`, and `trap_BotChooseBestFightWeapon`, which the MP game never calls.

### X22, the union `value` of `bot_characteristic_t` (P2)

Question: the field `union cvalue value` has no accessor.

Proof: Raven `botlib/be_ai_char.cpp:39` to `:50`, a named union. Swift `[ai] Sources/JKAMP_Ded/Generated/Views/BotCharacteristic.swift:70`, `TODO: Port bot_characteristic_t.value`.

Verdict: PATTERN.

Form: HOST_ROOTS names the union `cvalue`, so the view gives `integer`, `_float`, and `string`, the last a `String?` that interns. A free of the text drops under an AI line, the CopyString free of ledger 7 row CM5.

Precedent: "A named union that a root row names, `qfile_gut`", `docs/transcription.md:393`, and `rulings.py:251`.

Touches: generator (`rulings.py` HOST_ROOTS, `ded_types.h` if the union is not yet in the copy).

Live path: no. Only BotLoadCharacter reads it.

### X23, a plain `char` scalar field (P5)

Question: the plain `char` fields `bot_characteristic_t.type` and `bot_matchvariable_t.offset` are `CChar` on the view, and a narrow field is `Int32`.

Proof: `[ai] BotCharacteristic.swift:64`, `[ai] BotMatchvariable.swift:64`. `reexport.py:58` holds `NARROW = {SHORT, USHORT, SCHAR, UCHAR}`, and `CHAR_S` is not in it. The game view `GNPC.swift:491` and `:497` (`last_forwardmove`, `last_rightmove`) has the same `CChar`. `docs/transcription.md:612` lists a `signed char`, and a plain `char` is signed in MSVC.

Verdict: PATTERN.

Form: `NARROW` takes `TypeKind.CHAR_S` for a scalar, so the field reads `Int32` and stores the truncation. A `char` array keeps `CharBuf`.

Precedent: the narrow rule, `docs/transcription.md:612`, `reexport.py:58`.

Caution: the change reaches every plain `char` scalar of the game and the cgame, the two GNPC fields and any `char` parameter. The game and cgame snapshots will differ, and that difference is the change.

Touches: generator (`reexport.py` or `spelling.py`), all three units.

Live path: no.

### X24, the text and offset returns of be_ai_chat (P15, P19, P18)

- P15. StringContainsWord returns `String?`, and Raven returns a pointer into `str1` that StringReplaceWords (`botlib/be_ai_chat.cpp:534` to `:544`) and BotReplaceReplySynonyms (`:817`, `:822`) compare and step. Verdict: PATTERN. RETURNS `text_offset`, the row of `Q_strrchr` at `rulings.py:919`, `docs/transcription.md:160`. Touches `rulings.py`. Live path: no.
- P19. The `var0` to `var7` texts of BotInitialChat and BotReplyChat are `String`, and Raven tests them for NULL at `be_ai_chat.cpp:2499` and `:2682`. The NULL comes from the module through the export, which the sweep cannot see. Verdict: PATTERN. NULLABLE rows for the 16 parameters, the form of `("G_UseTargets2", "string")` at `rulings.py:1511`, so each is `String?` (`docs/transcription.md:251`). The export thunk passes nil for a zero word. Touches `rulings.py`. Live path: no, the MP game never calls `trap_BotInitialChat` or `trap_BotReplyChat`.
- P18, corrected. BotChooseNBGItem takes `ltg: BotGoal`, and Raven tests `if (ltg)` at `be_ai_goal.cpp:1465`. No caller of the MP tree passes NULL: `trap_BotChooseNBGItem` of `game/g_syscalls.c:1013` has no caller. Verdict: PATTERN, no change. A view parameter is non-optional and the body drops Raven's guard, `docs/transcription.md:403`. Live path: no.

### X25, the botlib blocks of records and texts (P3)

Question: P3 says no form exists for a record with its text after it (D12 shape 8) or one block cut into many records and texts (D12 shape 11).

Proof: Raven `botlib/be_ai_chat.cpp:596` (synonyms), `:949` (random strings), `:2018` (initial chats), `:1189`, `:1538`, `:1942`. Swift Port-notes at `[ai] be_ai_chat.swift:454`, `:625`, `:782`, `:1108`, `:1432`, `:1484`.

Correction: the forms exist. Shape 8 is `VmSymbol(VM_Alloc(Int32(VmSymbol.byteCount) + chars))` and `sym.symName = token` at `vm.swift:331` and `:343`, and the AI line for the unused bytes of `[ai] files_pc.swift:1664` and `:1665`. Shape 11 is ruled by N8 of ledger 9 (line 17): the site takes the form of `[ai] files_pc.swift:1679` to `:1682`, which holds the block in an untyped local and binds each record at its offset. The bot-aas round of this wave used that form, "a block walk holds the raw block in an untyped local, the N8 form".

Verdict: PATTERN.

Form: as above. A text of the block goes through the field setter, and the block keeps Raven's size.

Precedent: `vm.swift:331`, `files_pc.swift:1664` to `:1682`, ledger 9 N8.

Touches: hand code in the logic target.

Live path: no.

### X26, `crandom` in the host (P7 of bot-ai)

Question: the host logic target has no `crandom`.

Proof: `game/q_shared.h:1592`, `#define crandom() (2.0 * (random() - 0.5))`. `random` stands at `[ai] Sources/JKAMP_DedLogic/common.swift:2077`, and `crandom` only at `[ai] Sources/JKAMP_BG/bg_lib.swift:195`. One hole in EvolveFuzzySeperator_r.

Verdict: PATTERN.

Form: `func crandom() -> Double` beside `random` in `common.swift`, with the body of `bg_lib.swift:195` and its `Source:` line. `docs/transcription.md:635` gives the `Double` sites.

Precedent: `bg_lib.swift:195`, the function-like macro table of `docs/transcription.md:330`.

Touches: hand code in the logic target.

Live path: no.

### X27, the C library twins (BL3, BL9, BL12, R1 of cmsv)

Question: four C library functions have no Swift form.

Proof:
- BL3: `strncpy` into a raw destination, `botlib/l_struct.cpp:207`, ReadString. `[lib] Sources/JKAShared/CString.swift:221` has `strcpy(_ dest: UnsafeMutableRawPointer, ...)` and `:308` to `:334` have `strncpy` into a `CharBuf` only.
- BL9: `strncmp(script->script_p, p, len)` at `botlib/l_script.cpp:790`, a cursor into `script.buffer`, a `Slots<byte>`. `CString.swift` has no `strncmp`, and `TEXT_READERS` of `table.py:315` names it.
- BL12: `strncat` at `botlib/l_precomp.cpp:461`, `:463`, `:1014`. `CString.swift` has none. The round wrote `Q_strcat` with the buffer size and a rule 19 note.
- R1: `atol` at `qcommon/cm_terrain.cpp:74`, `:93`, `:134` to `:136`, and `strtoul` at `:137` and `:1696`. `LIBC_SPELLINGS` of `rulings.py:1404` has no row. The `seed` of `:137` has no reader in the constructor, and `:1696` hands it to `rand_seed`.

Verdict: PATTERN.

Form:
- BL3: a `strncpy(_ dest: UnsafeMutableRawPointer, _ source: String, _ n:)` beside the raw `strcpy` of `CString.swift:221`.
- BL9: a `strncmp` with C semantics in `CString.swift`, over the `Slots<byte>` from the cursor, `script.buffer!.suffix(from: script.script_p)`, and a `String`.
- BL12: a `strncat` with C semantics in `CString.swift`, and the three sites go back to Raven's call. The `Q_strcat` sites and their notes go.
- R1: the LIBC_SPELLINGS row `"atol": "atoi"`, because `long` is 32 bits in MSVC, and a `strtoul` with C semantics in `CString.swift` for `:137` and `:1696`.

Precedent: "`Sources/JKAShared/CString.swift` holds the libc names Raven calls ... with C semantics", `docs/transcription.md:746`, the raw `strcpy` at `CString.swift:221`, and `"stricmp": "Q_stricmp"` of `rulings.py:1404`.

Touches: hand code in `JKAShared`, `rulings.py` LIBC_SPELLINGS, the call sites.

Live path: no. The scripts load only for the AI layers, and the terrain loads only on a terrain map.

### X28, the C library time functions (BL4, A14, BL14)

Question: `clock()` of Sys_MilliSeconds and `time` and `ctime` of PC_ExpandBuiltinDefine have no host form.

Proof: Raven `botlib/be_interface.cpp:62`, `Sys_MilliSeconds` returns `clock() * 1000 / CLOCKS_PER_SEC`, and the BUILTIN_DATE and BUILTIN_TIME arms of `l_precomp.cpp`. Swift `[lib] be_interface.swift:36` stub, `[lib] Sources/JKAMP_Ded/SysBackend.swift:174` has `timeGetTime` and no `clock`. Callers of Sys_MilliSeconds: AAS_CalculateAreaTravelTimes and AAS_ContinueInitReachability.

Verdict: PATTERN.

Form: `SysBackend.clock()`, `SysBackend.time()`, and `SysBackend.ctime(_:)` beside `timeGetTime`, each over the C library call, `ctime` as a `String`. `clock` is the processor time of the process, as Raven's call is.

Precedent: `SysBackend.timeGetTime()` at `SysBackend.swift:174`, and `timing_c` of ledger 9 line 77, which reads milliseconds through `SysBackend`.

Touches: hand code in the view target, hand code in the logic target.

Live path: no.

### X29, the definehash table parameters (BL6)

Question: PC_AddDefineToHash and PC_FindHashedDefine take `inout Define?`, and Raven indexes the table.

Proof: Raven `botlib/l_precomp.cpp:559` and `:585`. Swift `[lib] l_precomp.swift:382` and `:395`. On master `6f3abc1`, the stub of `l_precomp.swift:245`, `:257`, and `:227` gives the same `inout Define?`. D6 of `notes/2026-11-09/botlib-docket-9.md` names PC_PrintDefineHashTable and PC_FindHashedDefine for the PARAMS kind `pointer_table`, and PARAMS of `rulings.py` has no `definehash` row. The claim of BL6 holds: D6 is ruled and its PARAMS part is not applied. D6 also leaves out PC_AddDefineToHash.

Verdict: PATTERN.

Form: PARAMS `pointer_table` for `("PC_PrintDefineHashTable", "definehash")`, `("PC_FindHashedDefine", "definehash")`, and `("PC_AddDefineToHash", "definehash")`, so each is `Slots<Define?>`, the type of `source.definehash`.

Precedent: `("SV_BotWaypointReception", "wps")` at `rulings.py:1232`, and the FIELDS row of `source_t.definehash` at `rulings.py:732`.

Touches: generator (`rulings.py` PARAMS).

Live path: no. PC_ReadToken traps on every name token today, and the scripts load only for the AI layers.

### X30, the evaluate functions of l_precomp (BL7)

Question: PC_EvaluateTokens, PC_Evaluate, and PC_DollarEvaluate keep `TODO: Port signature`.

Proof: `[lib] l_precomp.swift:1223` to `:1256`, each with "No table row for `double * floatvalue`". Raven `botlib/l_precomp.cpp:1730`, `:2184`, `:2283`. The callers pass NULL for one of the two pointers at `:2402`, `:2418`, `:2493`, `:2517`, `:2598`, `:2626`, and each body tests `if (intvalue)` and `if (floatvalue)` at `:1753`, `:2158`, `:2174`, `:2192`, `:2291`. D5 names these three as width sites and says a `signed long int *` is `inout Int32` and a `long double *` is `inout Double`. The `signed long` half took the width of `MSVC_WIDTH_FOLDERS`. The `double *` half has no table row. The claim of BL7 holds in part: D5 is ruled, and its `double *` spelling did not land.

Verdict: PATTERN.

Form: a scalar output that a caller passes NULL to crosses as the pointer, `UnsafeMutablePointer<Int32>?` and `UnsafeMutablePointer<Double>?`, and the body keeps Raven's NULL tests. `spelling.py` gives a `double *` scalar pointer the same rule as an `int *` one.

Precedent: "A scalar output that the sweep reaches by the same three paths crosses as the pointer", `docs/transcription.md:259`, `crazySmoothFactor` of `BG_G2PlayerAngles`, and `flags` of BotGetReachabilityToGoal at `[lib] be_ai_move.swift:409`.

Touches: generator (`spelling.py`).

Live path: no.

### X31, the parameter array of PC_ReadDefineParms (BL8)

Question: `parms` is `inout Token?`, and Raven fills an array.

Proof: Raven `botlib/l_precomp.cpp:351`, `token_t **parms`, and the caller's `token_t *parms[MAX_DEFINEPARMS]`. Swift `[lib] l_precomp.swift:285`.

Verdict: PATTERN.

Form: `inout [Token?]`, and the caller declares `var parms = [Token?](repeating: nil, count: Int(MAX_DEFINEPARMS))`.

Precedent: "a C array of struct pointers the function fills", `docs/transcription.md:115`.

Touches: generator (a PARAMS row or the array-of-pointers rule for this shape).

Live path: no.

### X32, the one-`char` output of PS_ReadEscapeCharacter (BL10)

Question: `char *ch` is one character that the body writes, called with `&token->string[len]`, and the stub takes `inout CharBuf`.

Proof: Raven `botlib/l_script.cpp:344`, called at `:446` and `:735`. Swift `[lib] l_script.swift:199`.

Verdict: PATTERN.

Form: `ch` is a scalar output, `inout CChar`, and the caller passes `&token.stringBuffer[len]` through the `nameBuffer` accessor of `docs/transcription.md:202`. The `CharBuf` subscript is generic in the type it stores, so the inout reaches the byte.

Precedent: the scalar output parameters that keep `inout`, D16 of the ninth batch ("PC_PopIndent", "PC_SourceFileAndLine"), and the narrow local of `docs/transcription.md:615`.

Touches: generator (a PARAMS row of the scalar output kind).

Live path: no.

### X33, COM_Compress over `script->buffer` (BL11)

Question: COM_Compress takes `inout CharBuf`, and `script.buffer` is a `Slots<byte>`.

Proof: Raven `botlib/l_script.cpp:1352`. Swift `[lib] Sources/JKAShared/q_shared.c.swift:266`, `[lib] Sources/JKAMP_Ded/Generated/Views/Script.swift:76`.

Verdict: PATTERN.

Form: copy the bytes into a `CharBuf` of `length + 1`, call COM_Compress, and copy back with Raven's returned length, through `Com_Memcpy(&buf, script.buffer!, n)` and `Com_Memcpy(script.buffer!, buf, n)`, under one AI line.

Precedent: the two `Com_Memcpy` overloads between `CharBuf` and `Slots<byte>` at `[lib] CString.swift:414` and `:429`, `docs/transcription.md:776`.

Touches: hand code in the logic target.

Live path: no.

### X34, `fprintf` and `vfprintf` on a `FILE *` (BL2)

Question: Log_Write, Log_WriteTimeStamped, WriteIndent, and WriteFloat print to a `FILE *`, and `FileBackend` has no `fprintf`.

Proof: Raven `botlib/l_log.cpp:102`, `:119` to `:127`, `botlib/l_struct.cpp:303`, `:331`. `[lib] Sources/JKAMP_Ded/FileBackend.swift:34` has `fwrite` of a `CharBuf`.

Verdict: PATTERN.

Form: the formatted text through `JKAShared.format`, then `FileBackend.fwrite`, the `vsprintf` form of `docs/transcription.md:758`. WriteIndent and WriteFloat have only WriteStructWithIndent as caller, which the round leaves dead under rule 20, so both take the dead note if no other caller stands.

Precedent: `docs/transcription.md:758`, and the `Com_Printf` write to the log through `FS_Write` of `docs/transcription.md:195`.

Touches: hand code in the logic target.

Live path: no. `Log_Open` opens the log only when the `log` libvar is set.

### X35, the `fmt` of Log_Write (A12)

Question: Log_Write takes `inout CharBuf`, and ledger 9 says D18 made its `fmt` a `String`.

Proof: `[lib] l_log.swift:85` and `:101`, and the stub of master `6f3abc1` `l_log.swift:57` and `:69`, which has the skeleton header and still gives `inout JKAShared.CharBuf`. Ledger 9 line 13 says the D18 change of TEXT_READERS gave Log_Write a `String`. That claim is wrong for Log_Write: the body passes `fmt` to `vfprintf` at `l_log.cpp:121`, which is not in `TEXT_READERS` (`table.py:315`), so the text sweep keeps `CharBuf`. Eleven sites of `be_aas_cluster` and `be_aas_reach` pass `var fmt = CharBuf("...")`.

Verdict: PATTERN.

Form: `vfprintf` and `fprintf` join `TEXT_READERS`, so `fmt` is a `String`, and the eleven sites pass the literal.

Precedent: the row `__builtin_va_start` of D18, ledger 9 line 13.

Touches: generator (`table.py:315`), then a snapshot check of the three units, and hand code at the eleven sites.

Live path: no.

### X36, the remaining bot-aas rows (A3, A6, A9, A11, A13)

- A3. AAS_LoadAASLump returns the raw block that each caller casts to a lump table, and `[aas] be_aas_file.swift:90` returns `String?`. Raven `botlib/be_aas_file.cpp:273` returns NULL on a failed read. Verdict: PATTERN. RETURNS `optional_raw`, the row of `GetMemory` (`rulings.py:997`) and FC3 (`rulings.py:952`), D12 shape 7. Touches `rulings.py`. Live path: no.
- A6. Static locals of AAS_ContinueInitReachability (`be_aas_reach.cpp:4350`, `:4351`) and AAS_ShowReachableAreas (`be_aas_debug.cpp:670` to `:672`). Verdict: PATTERN. The static-local form of `docs/transcription.md:480`, a property of `EngineWorld` with a forward, the function name as a suffix where a name repeats. Precedent: `lastErrorTime` (`EngineWorld.swift:109`, `common.swift:480`) and row TR6 of ledger 8. Touches hand code in the logic target. Live path: no.
- A9. CRC_ProcessString over the bytes of the first N records of a `Slots` with the widest count, `be_aas_route.cpp:959`, `:960`, `:1069`, `:1075`. `bytes` of `Slots` (`[aas] Sources/JKAShared/Views/Slots.swift:193`) multiplies the widest count, which overflows. Verdict: PATTERN. `Slots<byte>(scalars: aasworld.areas!.base, count: Int(...))` with Raven's byte count, the form of site B of ledger 9 (`Slots<Int32>(scalars: heap.base, count: numSurfaces)`) and `vm_interpreted.swift:81`. No new `bytes(count:)` helper. Touches hand code in the logic target. Live path: no, the route cache is read only after an AAS load.
- A11. `sscanf(buf, "%lf %lf %lf", ...)` of AAS_VectorForBSPEpairKey (`be_aas_bspq3.cpp:294`). Verdict: PATTERN. One more overload in `Scan.swift` with three `inout Double`, "one overload per target shape in use", `docs/transcription.md:778`, the twin of the vector overload at `Scan.swift:164`. Touches hand code in `JKAShared`. Live path: no.
- A13. AAS_AreaTravelTime returns `unsigned short` (`be_aas_route.cpp:457`), and the port returns the `Int32` with no truncation. Verdict: PATTERN. The return truncates as C's conversion does, `Int32(UInt16(truncatingIfNeeded: x))`, the narrow store of `docs/transcription.md:616`, with no AI line because it is C's own conversion. Touches hand code in the logic target. Live path: no.

### X37, the forms the bot-aas round used

- A text into a GetHunkMemory or GetClearedHunkMemory block keeps the call for the hunk count, and the `char *` field takes the text: PATTERN, the CopyString form of D12 shape 6, `z_memman_pc.swift:404`, and its free under an AI line, ledger 7 row CM5.
- The private hand function for the macro AAS_OrthogonalToVectors: PATTERN, a function-like macro is a hand function of the same name with its cite, `docs/transcription.md:322`, and the private `Maximum` and `Minimum` of `[lib] l_struct.swift`.
- The five private constants for the enum of `be_aas_entity.cpp:32`: PATTERN, `docs/transcription.md:86`, because `ET_MOVER` has another value in `bg_public.h`.
- The size of an allocator call takes `UInt32(...)` at the `unsigned long` parameter. The bot-lib round adds an `Int32` overload of each allocator, the `srand` form of `docs/transcription.md:647`. After both branches merge, the `UInt32(...)` of bot-aas is a conversion Raven did not write, and it goes. This is a merge task, not a row.

### X38, the format subset (P16, P7 of cmsv)

Question: `%ld` and `%p` are outside the format subset.

Proof: `%ld` at `botlib/be_ai_chat.cpp:875` with the `unsigned long` of `token.intvalue`. `%p` at `qcommon/cm_patch.cpp:1171` before a fatal error. `[ai] Sources/JKAShared/Format.swift:126` to `:150` take `i`, `d`, `s`, `c`, and `f`, and the doc line says a new specifier traps "so a new shape surfaces at once". No length modifier and no pointer conversion exist, and no ledger row added one.

Verdict: NO PATTERN.

Candidates:
- A. The format reads an `l` length modifier and prints the integer as `%d` and `%u` do, because `long` is 32 bits in MSVC. `%p` prints the 8 upper-case hex digits of MSVC, with the value 0 under a rule 24 line, because no Swift value has Raven's address.
- B. The sites pass through with a cast and an AI line: `%ld` becomes `%d` with `Int32(bitPattern:)`, and `%p` becomes `%d` with 0.

Recommendation: A for `%ld`, because the subset grows by the shape Raven uses. B for `%p`, because the line prints before a fatal error and no address can match.

Touches: hand code in `JKAShared` (`Format.swift`) or at two sites.

Live path: no.

### X39, the conversions between `unsigned long` and `int` (P17)

Question: the botlib bodies convert between the `UInt32` of the MSVC `unsigned long` and `Int32` where Raven wrote no cast.

Proof: `token_t.intvalue` is `unsigned long` (D5). be_ai_chat passes an `int` to an `unsigned long` parameter at `be_ai_chat.cpp:2548`, `:2734`, `:2742`. `Promotion.swift` defines operators between `Int32` and `Float` only.

Part P17a: an `int` into an `unsigned long` parameter of GetMemory and the chat functions. Verdict: PATTERN. A second overload with an `Int32` parameter, `docs/transcription.md:647`, the `srand` form. The bot-lib round already added it to the four allocators.

Part P17b: an `unsigned long` operand that meets an `int` in an expression, a compare, or a store. Verdict: NO PATTERN.

Candidates:
- A. Operators between `UInt32` and `Int32` in `Promotion.swift` that convert the `Int32` to `UInt32` as C's usual arithmetic conversions do, and a store into an `int` that truncates.
- B. Each site keeps an explicit conversion with one AI line.

Recommendation: A, the twin of the `Int32` and `Float` operators, so a body reads as Raven wrote it. It is a shared module change, so it needs the game and cgame snapshot check.

Touches: hand code in `JKAShared` (`Promotion.swift`) or at the sites.

Live path: no.

## Tier 3, the terrain, the random mission manager, and the clip map rows

### X40, `CCMLandScape *` and `CCMPatch *` signatures (C of cmsv)

Question: CM_RegisterTerrain, the 14 wrappers of cm_terrain, and CM_HandlePatchCollision have no signature.

Proof: Raven `qcommon/cm_load.cpp:1036`, `qcommon/cm_terrain.cpp:1618` to `:1688`, `qcommon/cm_trace.cpp:914`. Swift `[cm] cm_load.swift:1138`, `[cm] cm_terrain.swift:85` to `:205`, `[cm] cm_trace.swift:778`, each "No table row for ... `class CCMLandScape *`". CXX_CLASSES names `CCMLandScape` and `CCMPatch` at `rulings.py:1455`, and C_STRUCT_CLASSES also names `CCMLandScape` as a tag at `rulings.py:1416`. The table row exists, and the spelling of the elaborated type `class CCMLandScape *` misses it.

Verdict: PATTERN.

Form: a pointer to a class of CXX_CLASSES is the optional Swift class, and a return takes RETURNS `class_ref`, `docs/transcription.md:142`. The fix is in `spelling.py`: a CXX_CLASSES name wins over the C tag in a function signature. The `brush++` walk over GetCollisionData is an index local, `docs/transcription.md:501`.

Precedent: `Com_ParseTextFile` of RETURNS `class_ref` (`rulings.py:992`) and the CXX_CLASSES rule of `rulings.py:1430`.

Touches: generator (`spelling.py`, `rulings.py` RETURNS).

Live path: no. Only a terrain map registers a landscape.

### X41, the classes of the random mission manager (R3, C of GetAutomapSymbol)

Question: `CRandomTerrain`, `CRMMission`, and `rmAutomapSymbol_t` have no Swift form, and GetAutomapSymbol has no signature.

Proof: Raven `qcommon/cm_terrain.cpp:169`, `:1605`, `qcommon/cm_landscape.h:224`, `RMG/RM_Manager.cpp:37` to `:407`, `server/sv_client.cpp:677`. Swift `[cm] CCMLandScape.swift:115`, `:168`, `:1014`, `[cm] CRMManager.swift:117` to `:526`, `[cm] sv_client.swift:563`, `[cm] CRMManager.swift:197`. In the DEDICATED build, `cm_terrain.cpp:169` stores only 0 into `mRandomTerrain`.

Verdict: PATTERN.

Form: a `final class` per Raven class with its fields and method stubs, CXX_CLASSES rows, one class per file. `rmAutomapSymbol_t` is a copy in `ded_types.h` and a HOST_ROOTS row, and GetAutomapSymbol returns its view. `mRandomTerrain` is `CRandomTerrain?` that stays nil, and the methods that only a client build calls keep the rule 20 note.

Precedent: row C of ledger 8 (`rulings.py:1432` to `:1456`), and row W1 for a `.cpp` record in `ded_types.h`.

Touches: generator (`rulings.py` CXX_CLASSES and HOST_ROOTS, `ded_types.h`), hand code in the logic target.

Live path: no. SV_SendClientGameState writes the short 0 when no random mission exists.

### X42, the smaller terrain rows (R2, R4, R5 of cmsv)

- R2. `Round` of `qcommon/qcommon.h:1094` is an `inline` function with no Swift home, read at `cm_terrain.cpp:150`, `:151`. Verdict: PATTERN. A hand function `Round(_ value: Float) -> Int32` with Raven's body in `common.swift`, the inline-function form of `BG_GiveMeVectorFromMatrix`, `docs/transcription.md:339`, and `Square` of ledger 8 line 218. Touches hand code in the logic target. Live path: no.
- R4. `origin` of GetWorldHeight: Raven writes `origin[2]` at `qcommon/cm_terrain.cpp:1054`, and `RMG/RM_Mission.cpp:403`, `:412` read it. Swift `[cm] CCMLandScape.swift:476`. Verdict: PATTERN. An `inout vec3_t` on the hand method, the PARAMS kind `vec3_mut` (`rulings.py:1259`). Touches hand code in the logic target. Live path: no.
- R5. `user` of CM_CircularIterate and its four callbacks: Raven passes an `ivec3_t` at `cm_terrain.cpp:1343` and `:1401`, and CM_GetAverage and CM_BelowLevel take it as `int *`. Swift `[cm] CCMLandScape.swift:729`, `[cm] cm_terrain.swift:10`, `:43`, `:74`. Verdict: PATTERN. PARAMS `bytes` for `user` of the iterator and of each callback, so each is `Slots<Int32>`, the `int *` rule of `rulings.py:1226`. Touches `rulings.py`. Live path: no.

### X43, `cmShaderTable` records outside `cmg.shaders` (S1 of cmsv)

Question: CM_RegisterShader inserts a Hunk_Alloc record into `cmShaderTable`, and the table holds offsets into `cmg.shaders`.

Proof: Raven `qcommon/cm_shader.cpp:521`. Swift `[cm] cm_shader.swift:449`. Rows S1 and CM6 of ledger 8 left it open, and the offset form of row C5 covers only records inside `cmg.shaders`.

Verdict: NO PATTERN.

Candidates:
- A. `cmShaderTable` becomes a Swift `[String: CmShader]`, rule 17, where each value is the view of its record, inside `cmg.shaders` or in a Hunk_Alloc block.
- B. A second table of views for the records outside `cmg.shaders`, beside the offset table, with a flag per entry.

Recommendation: A. One table holds every record by name, as Raven's hash table does.

Touches: hand code in the logic target.

Live path: no. Only CCMLandScape calls it.

### X44, zlib `deflate` (C2)

Question: SV_SendClientGameState compresses the automap symbols with `deflate`, and only `inflate` exists.

Proof: Raven `server/sv_client.cpp:742` to `:781`. Swift `[cm] sv_client.swift:661`. `JKAZlib` ports `inflate` only.

Verdict: PATTERN.

Form: the `deflate` functions of Raven's zlib port into `JKAZlib` beside `inflate`, in the same shape.

Precedent: the `inflate` port of `Sources/JKAZlib`.

Touches: hand code in `JKAZlib`.

Live path: no. Only a map with a random mission writes the symbols.

### X45, the clip map findings (TERRAIN_STEP_MAGIC, CM_Checksum, the old R4, B4, B6)

- `TERRAIN_STEP_MAGIC` is `(1.0f / 1.2071f)` at `qcommon/cm_landscape.h:17`, and `[cm] Sources/JKAMP_Ded/Generated/cm_landscape.swift:11` gives a `Double`. Verdict: PATTERN. A macro with an `f` literal is a `Float`, `docs/transcription.md:311` and `:635`. The reexport keeps the `f` suffix of a literal inside parentheses. Touches `reexport.py`, then the snapshot check. Live path: no, and `cm_trace.swift:719` sets `count = 1` on the next line.
- CM_Checksum of `qcommon/cm_load.cpp:544` has no caller in either tree. Verdict: PATTERN. A DEAD row, the form of `rulings.py:1356`, and no BYTE_STORAGE_LOCALS row. Touches `rulings.py`. Live path: no.
- The old R4 of the cm round, `cbrush_t **` of CM_BoxBrushes and CM_StoreBrushes: already ruled, DEAD at `rulings.py:1356` and `:1357`, row R4 of ledger 8. No change.
- B4. The local `vec3_t points[1]` of BotImport_DebugLineCreate and the local array of BotImport_DebugLineShow go to a `Slots<vec3_t>` parameter, `server/sv_bot.cpp:526` and `:569`, Swift `[cm] sv_bot.swift:610` and `:666`. Verdict: PATTERN. BYTE_STORAGE_LOCALS keys `("points", "BotImport_DebugLineCreate")` and `("points", "BotImport_DebugLineShow")`, the `vec3_t` rule of `hullPoints` (`rulings.py:602`) and the key form of `rulings.py:638`. Touches `rulings.py`. Live path: no, the AAS debug code is the caller.
- B6, corrected. The `drawPoly` parameter of BotDrawDebugPolygons. Its one caller is CM_DrawDebugSurface at `qcommon/cm_patch.cpp:1674`, which is DEAD at `rulings.py:1349`. Verdict: PATTERN. A DEAD row for BotDrawDebugPolygons, the form of `rulings.py:1349`, and no PARAMS row. Touches `rulings.py`. Live path: no.

## The PATTERN rows by generator table

- `rulings.py` HOST_ROOTS: X4 (`mdxaCompQuatBone_t`), X6 (`mdxaIndex_t`), X10 (`mdxmTriangle_t`), X22 (`cvalue`), X41 (`rmAutomapSymbol_t`), R6 of g2tr (`md3Surface_t`, the form of `rulings.py:312` to `:314`, live only when the server registers an `.md3` model).
- `rulings.py` PARAMS: X1 (`botlib_import_t.FS_FOpenFile`, `.FS_Read`, `.FS_Write`, `.DebugPolygonCreate`), X4 (UnCompressBone), X18 (`vec3_mut` x3), X19 (P11 `table`), X21 (P4 `bytes`), X29 (`pointer_table` x3), X31, X32, X42 (R5 `bytes`).
- `rulings.py` RETURNS: X1 (`botlib_import_t.GetMemory`, `.HunkAlloc` as `raw`), X14 G1d, X17 (`record`), X21 (P8 `bytes`), X24 P15 (`text_offset`), X36 A3 (`optional_raw`), X40 (`class_ref`).
- `rulings.py` FIELDS: X21 (P8 `bytes` x2).
- `rulings.py` NULLABLE: X14 G1e, X19 (P14, A8, BL13, P6, P11), X24 P19.
- `rulings.py` BYTE_STORAGE_LOCALS: X17, X20, X45 B4.
- `rulings.py` CXX_CLASSES: X41.
- `rulings.py` DEAD: X45 (CM_Checksum, BotDrawDebugPolygons), X34 (WriteIndent and WriteFloat if no live caller stands).
- `rulings.py` LIBC_SPELLINGS: X27 (`atol`).
- `skeleton.py`: X20 (`INT_ELEMENTS` takes `FLOAT` and `USHORT`), X2 and X1 W3P1 (the thunk writer takes the host readers and the five file functions of another stem).
- `spelling.py`: X1 (the `record.field` keys of RETURNS), X14 G1a, G1b, G1c, G1g with X47, X21 (an `int *` return of kind `bytes`), X30 (a `double *` scalar pointer), X40 (a CXX_CLASSES name over the C tag).
- `table.py`: X35 (`vfprintf` and `fprintf` in TEXT_READERS).
- `reexport.py`: X23 (`CHAR_S` in NARROW), X45 (`TERRAIN_STEP_MAGIC`).
- `project.toml`: X4 (`renderer/matcomp.c`), X11 (`icarus/Q3_Interface.h`).
- The hand header `ded_types.h`: X3 (`botlib.h:16`), X22, X41.
- Hand code only, no table: X1 (`BotlibImportThunks`, the 21 stores, and the W3P2 returns), X47 (the g2tr bodies at the merge), X48 (no change), X49 (the merges), X2 (the reader twin and the 34 arms), X5, X9, X12, X14 G1f, X15 (no change), X16, X24 P18 (no change), X25, X26, X27, X28, X33, X34, X36 A6, A9, A11, A13, X37, X39 P17a, X42 R2, R4, X44.

## The NO PATTERN rows for the user

- X46 (L1 at run time): the leaf index distance between two zone blocks overflows `Int32` on arm64. Recommendation: the OpenJK form, `firstLeafBrush` and `firstLeafSurface` of pointer width in a `ded_types.h` copy of `cLeaf_t`. It reopens ruling L1. Live: yes, every map load.
- Z6 (with W3P4): the module word of a `CGhoul2Info_v`. Recommendation: a table of the instances on `EngineWorld`, the word is the slot plus 1. Live: yes, SP_worldspawn on every map load.
- X1a: the variadic `Print` of `botlib_import_t`. Recommendation: the run method formats in Swift and passes the text with `"%s"`. Live: yes, every botlib print.
- X1b: the non-const `char *` of `botlib_import_t.BotClientCommand`. Recommendation: a PARAMS row of a new kind `text`, keyed by the field. Live: yes, a bot that talks.
- X7 (G3): `qsort` over a table of records. Recommendation: a `qsort` overload over `Slots<V>` beside `bg_lib.swift:61`. Live: yes, the saber trace.
- X8 (G4): a pointer stored in an `int`. Recommendation: the byte offset in the `CMiniHeap` block, the L1 form. Live: yes, the saber trace.
- X13 (H1): `std::pop_heap` and `std::push_heap`. Recommendation: a port of the MSVC algorithm. Live: yes, NPC paths.
- X38 (P16, P7 of cmsv): `%ld` and `%p`. Recommendation: the `l` modifier in the format, and `%p` as `%d` of 0 under an AI line. Live: no.
- X39 P17b: operators between `UInt32` and `Int32`. Recommendation: the operators in `Promotion.swift`. Live: no.
- X43 (S1 of cmsv): `cmShaderTable` records outside `cmg.shaders`. Recommendation: `[String: CmShader]`. Live: no.
