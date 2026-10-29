# The game pool docket

This record holds the docket for the second half of the pools: the game pool of `g_mem.c`, after the bg pool rows of `bg-pool-docket.md` merged in PR 12. The pool is Raven's bump allocator over `memoryPool` in `Sources/JKAMP_GameLogic/g_mem.swift:7-47`, with the storage `world.memoryPool` at `Sources/JKAMP_GameLogic/g_local.swift:18-25`. Each row is one class of `G_Alloc` consumer, proven against the Swift tree, Raven's tree under `oracle/`, and OpenJK under `openjk/`. Every row is proposed and waits for its own ruling. No Sources, docs, or tools file changed for this record.

## The Raven counterpart

Raven's `oracle/codemp/game/g_mem.c` has one arm and no `_XBOX` arm. `static char memoryPool[POOLSIZE]` at `:13` is 256 KB (`:11`), and `allocPoint` at `:14` is the head. `G_Alloc` at `:16-33` prints the accounting when `g_debugAlloc` is set (`:19-21`), calls `G_Error` when `allocPoint + size > POOLSIZE` (`:23-26`), returns `&memoryPool[allocPoint]`, and moves the head by `(size + 31) & ~31` (`:28-30`). `G_InitMemory` at `:35-37` sets `allocPoint` to 0. The brief names `G_ShowGameMem`, and no function of that name exists in either tree. The print function is `Svcmd_GameMem_f` at `:39-41`, which prints `allocPoint` and `POOLSIZE`, and the server command `game_memory` calls it (`g_svcmds.c:528-529`, Swift `g_svcmds.swift:542`).

No Raven MP file holds a per-call form of `G_Alloc`. The nearest counterpart is Raven's SP game, `oracle/code/game/g_mem.cpp:20-38`: `memoryPool` is a comment at `:13-16`, `G_Alloc` adds `size` to `allocPoint` and returns `gi.Malloc(size, TAG_G_ALLOC, qfalse)` once per call, with no limit and no error, and `Svcmd_GameMem_f` prints the count. The SP server frees every `TAG_G_ALLOC` block at the game shutdown, `Z_TagFree(TAG_G_ALLOC)` at `oracle/code/server/sv_init.cpp:196` and `oracle/code/server/sv_game.cpp:689`. The second counterpart is the `_XBOX` arm of `bg_misc.c:3226-3307`, which P7 of the bg docket used. The rows below use the SP arm for the shape of a per-call `G_Alloc` and P7 for the count and the error.

OpenJK changed `g_mem.c` (`openjk/codemp/game/g_mem.c`, the same text as `~/Developer/Milo/OpenJK/codemp/game/g_mem.c`). It adds a comment block at `:30-43` that says the pool is for startup objects only, sets `POOLSIZE` to 4 MB at `:45` (commit `50bde780`, 2017-03-11, "Increase memory pool limit"), adds an `ERR_DROP` for a zero or negative size at `:53-56`, calls `trap->Print` and `trap->Error( ERR_DROP, ...)` at `:59` and `:63`, and prints a percentage in `Svcmd_GameMem_f` at `:79-82`. The Swift tree keeps Raven's text at all of these lines. jka-rust keeps the bump pool on its world, `jka-rust/crates/mp/game/src/g_mem.rs:21-53`, with Raven's 262144 bytes.

## Facts every row uses

Lifetime. `dllEntry` builds a fresh world at every module load, `world = GameWorld()` at `Sources/jampgame/jampgame.swift:15`, with the rule 24 line at `:14`, from commit `522c7ad`. The old world frees `memoryPool` in its `deinit` (`g_local.swift:791-793`). Every holder of a `G_Alloc` pointer is on that world: the entity table `world.storage.g_entities` (`g_main.swift:28`) and `world.variables`. So no pointer into a `memoryPool` outlives the pool. The bg docket's Lifetime fact says that `dllEntry` does not build the world again. That fact was false when the bg docket was written, because `522c7ad` is an ancestor of master at 8a632c6.

Reset. `G_InitMemory` runs once per `G_InitGame`, at `g_main.c:936` and `g_main.swift:780`. Raven's pool never reuses a block inside one module load, because the head only moves up. `G_InitGame` clears the entity table after the reset, `memset( g_entities, ...)` at `g_main.c:978` and `g_entities.zero()` at `g_main.swift:819`, so no `parms` pointer survives the reset.

Engine. No pointer into `memoryPool` goes to the engine in either tree. The one Raven path that returns a pool address is `Q3_GetString` at `g_ICARUScb.c:1681`, `*value = ent->parms->parm[...]`, and its only caller, the `GAME_ICARUS_GETSTRING` arm of `vmMain` at `g_main.c:644-657`, copies the text into `gSharedBuffer` with `strcpy`. The Swift arm at `jampgame.swift:166-171` copies a `String`. `sharedEntity_t` at `g_public.h:678-690` has no `char *` field and no `parms` field.

Alignment. Raven's head moves in steps of 32. `world.memoryPool` is aligned to 16 (`g_local.swift:22`), so every block is aligned to 16. The consumers store `char` bytes and `parms_t`, which holds only `char parm[MAX_PARMS][MAX_PARM_STRING_LENGTH]` (`g_public.h:666-670`) and is 1024 bytes (`Sources/CJKAMP_Game/layout_asserts.h:1258`). No consumer needs more than alignment 1. The alignment defect of the bg pool does not occur here.

Zero. `world.memoryPool` is zero filled at each world (`g_local.swift:23`), as Raven's static pool is zero at load. No consumer reads a byte it did not write: `Q3_SetParm` clears its block, `G_NewString` writes all `l` bytes, and `G_ParseInfos` drops its block.

Count. Rule 9 (`docs/porting-rules.md:23`) keeps `G_Alloc` as a bump pool with Raven's size and overflow error, because `g_debugAlloc` prints the accounting through `trap_Print` and the referee compares that stream. Row R27 of `notes/2026-10-04/walk.md:50` records the same ruling: "G_Alloc is transcribed as Raven wrote it, on the world, with his accounting." `G_Error` is `-> Never` (`g_main.swift:555`), so Raven's `return NULL` at `g_mem.c:25` has no Swift line.

Defects. This record finds no defect in the game pool today. The bg pool changed for alignment and for the zero fill, and neither applies here. The proposed form of G5 is for one shape across the two pools.

## G1. Strings of `G_NewString` (class A)

Ratified as proposed on 2026-10-29.

The site is `G_NewString` at `Sources/JKAMP_GameLogic/g_spawn.swift:199-232`, with `newb = G_Alloc(l)` at `:208`. Raven's is `g_spawn.c:724-749`, with `G_Alloc( l )` at `:730`. bg reaches it through the channel of rule 23: `bg_callbacks.swift:52` and `:255-256`, installed at `Sources/JKAMP_GameLogic/Generated/BgChannel.swift:118-119`.

Callers. Raven's live callers in the game module are `bg_misc.c:373` (`BG_ParseField`, `F_LSTRING`, for each map entity through `g_spawn.c:776` and for the world through `:1279`), `NPC_stats.c:1805` (`NPC_ParseParms`), `NPC_senses.c:928` (`SP_target_interest`), `NPC_spawn.c:1473` (`NPC_Spawn_Do`), `:3922` and `:3926` (`NPC_SpawnType`), `g_target.c:960` (`SP_target_level_change`) and `:999` (`SP_target_play_music`), and `g_ICARUScb.c:537` (`Q3_Play`), `:3488` (`Q3_SetTargetName`), `:3518` (`Q3_SetTarget`), `:3626` (`Q3_SetFullName`), and `:4701` (`Q3_SetBehaviorSet`). The Swift sites are `bg_misc.swift:166`, `NPC_stats.swift:1215`, `NPC_senses.swift:887`, `NPC_spawn.swift:1183`, `:3358`, and `:3361`, `g_target.swift:941` and `:981`, and `g_ICARUScb.swift:290`, `:3013`, `:3040`, `:3152`, and `:4285`. Raven's `g_ICARUScb.c:2314` is inside `#ifdef _DEBUG`, and the Swift body at `g_ICARUScb.swift:1861-1868` has no line for it. Raven's `:3549` and `:3596` are inside comment blocks, as are Swift's `:3073` and `:3124`. The commented calls at `NPC_stats.c:2156-2220`, `:2352`, `:2372`, and `bg_saberLoad.c:1192` and `:1203` allocate nothing. Raven's `bg_vehicleLoad.c:199`, `:720`, and `:873` are in the `#else` arm of `_JK2MP`, which `bg_vehicleLoad.c:5` defines, so the game uses `BG_Alloc` there (row P4 of the bg docket).

Stores. Each caller stores the result in a `char *` field: `gentity_t` fields such as `target`, `targetname`, `message`, `NPC_type`, `NPC_targetname`, `roffname`, `fullName`, and `behaviorSet[]`, and `level.interestPoints[].target`. Raven's pointer points into `memoryPool` until the module unloads.

The Swift tree already handles this class differently. `G_NewString` writes the translated bytes into the block and returns `cString(at: newb)` at `g_spawn.swift:231`, a `String` copy (`Sources/JKAShared/Views/CStrings.swift:2-9`). The `String?` setter of each view interns the text in `StringPool.shared`, for example `Sources/JKAMP_Game/Generated/Views/Entity.swift:506-509` and `Sources/JKAMP_Game/Generated/Views/InterestPoint.swift:71-73`, and `b[string:]` of `BG_ParseField` does the same (`Sources/JKAShared/Views/RawField.swift:53`). So no field points into `memoryPool`. The block is scratch that one call writes and reads.

The string pool. `StringPool` at `Sources/JKAShared/Views/StringPool.swift:4-30` keeps one copy per distinct text (`:21-29`), never frees it (`:20`), and is one static of the process (`:8`), so it outlives each world. Raven's pool gives a new copy per call and frees all copies at the unload. Two Raven behaviours depend on a private copy. A write in place into the copy is the first: `NPC_spawn.c:1473` lowercases the copy, and `docs/transcription.md:690` moves the lowercase before the pool. A compare of two pointers is the second, and a search of `oracle/codemp/game/*.c` for an equality test between two of these fields found none. `G_NewString` still bumps `allocPoint` by `l` rounded to 32, so the `g_debugAlloc` stream and the overflow point stay Raven's.

Raven's escape text. For a backslash before a character other than `n`, Raven's loop at `g_spawn.c:735-746` steps past the second character and writes only the backslash. OpenJK's loop at `openjk/codemp/game/g_spawn.c:749-763` keeps the second character (commit `b319c52f`). OpenJK also adds `G_NewString_Safe` at `:768-796`, with `malloc` and no caller in `openjk/codemp`. The Swift loop at `g_spawn.swift:214-230` keeps Raven's text, and no row changes it.

Proposed form. No change at the site. Under G5, `G_Alloc` returns one zeroed block per call, and `G_NewString` writes into it as Raven wrote.

Alternative. The `CHARBUF_ALLOCS` form of P5: `var newb = CharBuf(l)`, the call `_ = G_Alloc(l)` on the page, `newb[new_p] = ...`, and `return String(newb)`. This adds `"G_Alloc"` to `CHARBUF_ALLOCS` at `tools/oracle-closure/rulings.py:212`, moves the example of `docs/transcription.md:710` to another raw allocation, and leaves `Q3_SetParm` as the only body that reads a `G_Alloc` block. It is not proposed, because the site works as written under G5.

Generator rows. None for the proposed form.

## G2. Bot and arena info strings (class B)

Ratified as proposed on 2026-10-29.

The site is `G_ParseInfos` at `Sources/JKAMP_GameLogic/g_bot.swift:62-110`, with `_ = G_Alloc(strlen(info) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1)` at `:105`. Raven's is `g_bot.c:50-98`, with the allocation at `:92` and the copy at `:93-96`. The callers are `G_LoadArenasFromFile` at `g_bot.c:126` (`g_bot.swift:140`) and `G_LoadBotsFromFile` at `g_bot.c:1214` (`g_bot.swift:1209`), under `G_InitBots` at `g_bot.c:1302-1304` (`g_bot.swift:1315-1317`), which `G_InitGame` calls when `bot_enable` is set (`g_main.c:1068-1072`, `g_main.swift:909`).

Stores. Raven stores the pointer in `char *g_botInfos[MAX_BOTS]` and `char *g_arenaInfos[MAX_ARENAS]`, which live until the unload. `G_LoadArenas` writes the `\num\<n>` pair into the extra bytes of the block in place, `g_bot.c:316-318`. The engine does not read these blocks.

The Swift tree already handles this class differently. The slots are `[String]` on `world.variables` (`Sources/JKAMP_Game/Generated/Storage/GameVariables.swift:291` and `:299`). `G_ParseInfos` drops the block and stores `String(info)` at `g_bot.swift:106`. `G_LoadArenas` builds a `CharBuf` of the same sum and stores the text back at `g_bot.swift:337-340`. `docs/transcription.md:213` and `:716` record the form, and `notes/2026-10-29/discarded-result-rows.md:29` proves it.

Proposed form. No change at the site. Under G5 the call bumps the count and drops a fresh block.

Doc line. `docs/transcription.md:716` quotes the form as `_ = G_Alloc(strlen(info) + 1)`, and the site passes Raven's full sum. The line needs the site's text in either outcome.

Generator rows. None.

## G3. The ICARUS `parms_t` block (class C)

Ratified as proposed on 2026-10-29.

The site is `Q3_SetParm` at `Sources/JKAMP_GameLogic/g_ICARUScb.swift:3195-3198`, `ent!.parms = Parms(G_Alloc(Int32(Parms.byteCount)))` and `ent!.parms!.clear()`. Raven's is `g_ICARUScb.c:3668-3672`, `G_Alloc( sizeof(parms_t) )` and its `memset`. This is the one body that reads a `G_Alloc` block after the call returns.

Callers. `BG_ParseField` for the `F_PARM1` to `F_PARM16` keys of a map entity, `bg_misc.c:413` (`bg_misc.swift:187`). `Q3_Set` from a script at run time, `g_ICARUScb.c:5461` (`g_ICARUScb.swift:4961`). `NPC_Spawn_Do` copies the spawner's parms to each new NPC at run time, `NPC_spawn.c:1673-1683` (`NPC_spawn.swift:1368-1376`).

Readers. `Q3_GetFloat` at `g_ICARUScb.c:1221-1226` (`g_ICARUScb.swift:912` and `:916`), `Q3_GetVector` at `:1604` (`:1254`), `Q3_GetString` at `:1681` (`:1306-1307`), `Q3_SetParm` itself at `:3676-3687` (`:3202-3219`), and the copy of `NPC_Spawn_Do`. The field is `parms_t *parms` of the module part of `gentity_t` (`g_local.h:148`), and the view is `Entity.swift:110-113`. The engine reads no `parms` pointer (see Engine above).

Lifetime. The entity keeps the block until `G_FreeEntity` clears the entity (`g_utils.c:1039`, `g_utils.swift:982`) or `G_InitGame` clears the table. Neither frees the block, so Raven's pool keeps it until the unload. A new entity in the same slot allocates a new block at its first `Q3_SetParm`. The run-time callers make this the one class that grows the count during play: each spawned NPC with parms and each scripted entity adds 1024 bytes. At 256 KB Raven drops the game with `G_Alloc: failed on allocation of 1024 bytes`.

Alignment. 1. Size 1024.

Proposed form. No change at the site. Under G5 `G_Alloc` returns a zeroed block, and `clear()` stays as Raven's `memset`. The count of G5 keeps Raven's drop at the same allocation.

Alternative. A `GameStorage` table of `MAX_GENTITIES` records of `parms_t`, 1024 × 1024 bytes, in the shape of `g_vehiclePool`, with `ent.parms` set to the record of the slot. This costs 1 MB, a storage name Raven does not have, an edit to Raven's line, and a `skeleton.py` row, as the alternative of P1. It also changes Raven's count unless the call stays on the page. It is not proposed.

Generator rows. None.

## G4. Sites with no allocation (class D)

Ratified as proposed on 2026-10-29.

`g_vehicles.c:1693` allocates `m_ppPassengers` with `G_Alloc` inside `#ifndef _JK2MP`, and `g_vehicles.c:9` defines `_JK2MP`, so the MP game never compiles the call. In MP the field is the fixed array `bgEntity_t *m_ppPassengers[VEH_MAX_PASSENGERS]` at `bg_vehicles.h:489`. The Swift body at `g_vehicles.swift:1072-1077` keeps Raven's comment and the clear loop and has no call. OpenJK's `bg_vehicles.h:499` has the same array.

The other Raven mentions are comments: `g_client.c:2370` (Swift `g_client.swift:2243`), `ai_main.c:822` with the remark of `:824` (Swift `ai_main.swift:922` and `:924`), and `NPC_spawn.c:1432` and `:1437` (Swift `NPC_spawn.swift:1147` and `:1152`). The `TAGDEF(G_ALLOC)` line at `Sources/CJKASP/include/code/game/q_shared/enum_TAG_ALL.h:27` is the SP tag of the SP counterpart, not a call.

Proposed form. No change. This row only closes the caller list. Raven's MP game module has three live callers of `G_Alloc`: `g_spawn.c:730`, `g_bot.c:92`, and `g_ICARUScb.c:3670`. The Swift tree has the same three: `g_spawn.swift:208`, `g_bot.swift:105`, and `g_ICARUScb.swift:3196`.

Generator rows. None.

## G5. The allocator, the reset, the print, and the pool state (class E)

Ratified as proposed on 2026-10-29.

The Swift code is `g_mem.swift:7-47`. Raven's is `g_mem.c:11-41`. The SP counterpart is `oracle/code/game/g_mem.cpp:13-38`.

1. `world.memoryPool` goes: the property and its zero fill at `g_local.swift:18-25` and its free at `:792`. The `memoryPool` entry of `HAND_VARS` at `tools/oracle-closure/rulings.py:124-125` takes the value `None` of H1, with the reason in the comment above it. The stub generator then prints "No storage, by the HAND_VARS ruling." at `g_mem.swift:11-12` (`skeleton.py:788-791`), and the stub line takes a rule 24 line as the `bg_pool` stub did. The drafter at `draft_expressions.py:542-544` and `:724-725` stops writing `world.memoryPool + (allocPoint)`, so the drafted return of `G_Alloc` becomes a `portMissing` hole, as the three bg returns did after H1.
2. `G_Alloc` keeps the `g_debugAlloc` print, the overflow test with Raven's `G_Error` text, and the bump of `allocPoint` by `(size + 31) & ~31`. Only the return changes: one block per call, aligned to 16, zero filled as the static pool is, and never freed, in the shape of `g_mem.cpp:28` with the count of `g_mem.c`. The return line takes one rule 24 comment.
3. `G_InitMemory` and `Svcmd_GameMem_f` do not change. `allocPoint` stays a `GameVariables` property (`GameVariables.swift:465-467`), and `POOLSIZE` stays at `g_mem.swift:8`. The `game_memory` command prints Raven's count, and the `g_debugAlloc` stream stays byte for byte Raven's.
4. The `RETURNS` row `"G_Alloc": "raw"` at `rulings.py:202` stays, because every caller still receives an `UnsafeMutableRawPointer`.
5. The docs. Rule 9 at `docs/porting-rules.md:23` says "`G_Alloc` stays a bump pool over `memoryPool` and `allocPoint` on the world", and that sentence takes the ruled text. The same rule says "`G_NewString` goes away" and "the ICARUS `parms_t` block is the pool's only other consumer". Both are false today, under any outcome: `G_NewString` is at `g_spawn.swift:199`, and `G_ParseInfos` is a third consumer. `docs/transcription.md:455` names `memoryPool` as `world.memoryPool` and takes the ruled text. Rule 3 at `docs/porting-rules.md:12` says the string pool "stands beside `G_Alloc`, which keeps Raven's accounting", and stays true. Row R27 of `notes/2026-10-04/walk.md:50` is a dated record and does not change.

The blocks are never freed, as in P7. A world that ends leaves at most `POOLSIZE` plus the rounding of its blocks, because the count stops the game at 256 KB. Each module load adds that much again.

Alternative A, no change. The pool dies with its world (`jampgame.swift:15`, `g_local.swift:791-793`), no consumer needs more than alignment 1, and no consumer reads an unwritten byte. jka-rust keeps the same pool. The cost is two allocator shapes in one module.

Alternative B, the SP free. The form of item 2, with every block freed when its world ends, as `Z_TagFree(TAG_G_ALLOC)` frees the SP blocks at the shutdown. This needs a hand array of block pointers on `GameWorld`, in the shape of `tempAllocPointers` on `BgState`, and a loop in `deinit`. It is not proposed, because P7 never frees a `BG_Alloc` block.

Generator rows. The `HAND_VARS` value of item 1. No `skeleton.py` or drafter code changes, because H1 added the `None` form.

## The gate

The count is the gate. With item 2 of G5, a run with `g_debugAlloc 1` prints the same `G_Alloc of %i bytes (%i left)` lines before and after the change, and `game_memory` prints the same count. A diff of the two print streams of one replay is the first check, and it must be empty.

`G_InitGame` exercises G1 at every map load, because `BG_ParseField` copies every string key of every map entity through `G_NewString`. G2 runs at every map load with `bot_enable` set. `corpus-ffa1-human-3.rec` of `notes/2026-10-29/human-recordings.md`, with 15 bots on `mp/ffa1`, exercises G1 and G2.

G3 needs a map entity with a `parm` key, an ICARUS script that sets a parm, or an NPC spawner with parms. The wild t2 recordings of `notes/2026-10-27/client-connect.md`, `wild-t2wedge-3.rec` and `wild-t2trip-fixed.rec`, spawn NPCs and run scripts on siege maps. This record does not prove that either sets a parm. A run with `g_debugAlloc 1` shows it: a line of 1024 bytes is a `parms_t` block.

The map change run of the bg docket, `mp/ffa1`, `mp/duel1`, `map_restart 0`, and `mp/ffa1` again, exercises the reset of each world. No record measures how near a map comes to 256 KB. The `game_memory` command at the end of each replay gives the number.

The rest of the gate is the gate of the bg build: `swift build`, `swift test --no-parallel`, `tools/load-test.sh`, the tool tests, `draftcheck.py --every`, and `snapshot.py --check`. The snapshot shows the `memoryPool` stub line and the drafted return of `G_Alloc` as changed, in `bodies/g_mem.swift`, `skeleton/g_mem.swift`, and `manifest/g_mem.md`.

## The ledger

- G5, ratified as proposed, 2026-10-29.
- G1, ratified as proposed, 2026-10-29.
- G2, ratified as proposed, 2026-10-29.
- G3, ratified as proposed, 2026-10-29.
- G4, ratified as proposed, 2026-10-29.

The user walked the five rows on 2026-10-29, G5 first because it carries the shape, then G1 to G4, and ratified each as proposed. G5 removes `world.memoryPool` and returns one zeroed block per call with Raven's count and error kept. G1 to G4 change no site. Rule 9 takes the ruled text and loses its two false sentences, and `transcription.md:455` and `:716` take the site text.

## The build and the gate

The branch is `game-pool`, off master at 5ba0ab4, with the change in the working tree and no commit.

### The changed files

- `Sources/JKAMP_GameLogic/g_local.swift`, G5. The `memoryPool` property of `GameWorld`, its zero fill, its `MARK` line, and its `deallocate` in `deinit` are gone.
- `Sources/JKAMP_GameLogic/g_mem.swift`, G5. The `memoryPool` stub line is the rule 24 line `// AI: Raven allocates from this static pool. Each allocation is its own block, so the pool has no storage.` `G_Alloc` keeps the `g_debugAlloc` print, the overflow test with Raven's `G_Error` text, and the bump of `allocPoint`. The store into `p` is one allocation of `size` bytes with alignment 16 and a zero fill, never freed, under one rule 24 line. `G_InitMemory`, `Svcmd_GameMem_f`, `allocPoint`, and `POOLSIZE` do not change.
- `tools/oracle-closure/rulings.py`, G5. The `memoryPool` entry of `HAND_VARS` has the value `None`, and the two comment lines above it give the reason in the form of the `bg_pool` lines. The `RETURNS` row of `G_Alloc` does not change.
- `docs/porting-rules.md`, rule 9, takes the ruled text. The two false sentences are gone, and the rule names the three consumers.
- `docs/transcription.md`, `:455` and `:716`. No other hand storage example exists, so `:455` says that both entries have no storage. `:716` quotes the text of `g_bot.swift:105`. `:475-476` name only `bg_pool`, and no other line names `world.memoryPool`.

### The gate counts

1. `swift build`: 0 errors.
2. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all pass.
3. `tools/load-test.sh`: exit 0.
4. The tool tests: 82 tests, OK, 16 skipped.
5. `draftcheck.py --every`: 1283 holes, 0 cascade errors, 0 defects, 2 compile holes. The count is the count after H1 of the bg build, because the drafted `G_Alloc` already had holes at the store into `p` and at the return of `p`.

### The snapshot differences

`snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared` exited 1 with 370 files and 2 files different.

- `skeleton/g_mem.swift` and `manifest/g_mem.md`: the `memoryPool` line reads "No storage, by the HAND_VARS ruling."
- `manifest/g_mem.md`: the lines of `G_InitMemory` and `Svcmd_GameMem_f` move from `:40` and `:45` to `:42` and `:47`.

`bodies/g_mem.swift` did not change. The drafter keeps `p` as a local hole, so the draft never reached `memoryPool`. The differences are only those of the ruled form, so the snapshot was refreshed, and a second check exits 0 with no difference.

### The replays

Each replay ran on a fresh scratch homepath through `replay.sh` of the bg build, with `+set g_debugAlloc 1`. A copy at `/tmp/game-pool-scripts/replay.sh` takes the dylib from `DYLIB` when it is set.

- `wild-t2trip-fixed.rec` on `t2_trip`, 22000 steps: `REF REPLAY END` at log line 23745, exit 0, no trap, 2 kills, 1822 `G_Alloc of` lines, no block of 1024 bytes.
- `wild-t2wedge-3.rec` on `t2_wedge`, 181000 steps: `REF REPLAY END` at log line 185319, exit 0, no trap, 40 kills, 3280 `G_Alloc of` lines. 21 lines are blocks of 1024 bytes, so G3 runs on this map.
- `corpus-ffa1-human-3.rec` on `mp/ffa1` with `sv_maxclients 32` and `bot_minplayers 31`, 6500 steps: `REF REPLAY END` at log line 6721, exit 0, no trap, 11 kills, 472 `G_Alloc of` lines.

### The count check

The human-3 replay ran again with the dylib of master at 5ba0ab4, built in the worktree `/tmp/game-pool-master` and then removed: `REF REPLAY END` at log line 6721, exit 0, 11 kills, 472 `G_Alloc of` lines. The diff of the `G_Alloc of` text of the two logs, without the time stamps, is empty.

The last line of each log gives the bytes left at the end of the map load, from 262144 bytes.

| Map | Last line | Peak use |
|---|---|---|
| `t2_trip` | `G_Alloc of 81 bytes (195104 left)` | 67040 bytes |
| `t2_wedge` | `G_Alloc of 13 bytes (126560 left)` | 135584 bytes |
| `mp/ffa1` with 31 bots | `G_Alloc of 81 bytes (240768 left)` | 21376 bytes |

### The map change run

`mp/ffa1`, `mp/duel1`, `map_restart 0`, and `mp/ffa1` again, with `bot_minplayers 4`, `sv_maxclients 8`, and the cvars of `tools/load-test.sh`, under the alarm of 400 seconds.

The first run went at the same time as the `t2_wedge` replay. It ended with exit 2 after 120 seconds, three `InitGame` and three `ShutdownGame` lines, no Fatal line, and this trap after the `map_restart 0` on `mp/duel1`:

`JKAShared/Slots.swift:32: Precondition failed: Slots index -1 is out of the range 0..<4096`

The table of 4096 slots is `gWPArray`. The log has no stack, and the text matches the open point of `notes/2026-10-27/open-points.md:15`, the read of `gWPArray[goalWPIndex]` in `StandardBotAI` with no bound, which Raven also does. The game pool does not reach that read. The master dylib then ran the same sequence: exit 0 after 196 seconds, four `InitGame` and four `ShutdownGame` lines, 4 kills. The branch dylib ran it again with no other load: exit 0 after 194 seconds, four `InitGame` and four `ShutdownGame` lines, 6 kills, and no Fatal line.
