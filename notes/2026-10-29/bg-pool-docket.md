# The bg pool docket

This record holds the docket for the first structural change of the project: the bg pool goes, by the user's ruling of 2026-10-04 that sanctions deeper fixes after the game runs. The pool is Raven's bump allocator over `bg.pool` in `Sources/JKAMP_BG/bg_misc.swift:1662-1748`. Each row is one allocation class, proven against the Swift tree, Raven's tree under `oracle/`, and OpenJK under `openjk/`. Every row is proposed and waits for its own ruling. No Sources file changed for this record.

## The Raven counterpart

Raven wrote two arms of the allocator in `bg_misc.c`. The PC arm at `:3310-3394` is the pool: `static char bg_pool[MAX_POOL_SIZE]`, a head that `BG_Alloc` moves up in steps of 4, and a tail that `BG_TempAlloc` moves down. The `_XBOX` arm at `:3226-3307` has no pool: `BG_Alloc` and `BG_AllocUnaligned` call `Z_Malloc` once per call, and `BG_TempAlloc` and `BG_TempFree` keep the last three temporary blocks in `tempAllocPointers` and `tempAllocSizes`. On Xbox, `CL_ClearLastLevel` at `oracle/codemp/client/cl_main.cpp:702-720` frees the `TAG_BG_ALLOC` blocks at the level change and calls `G_ClPtrClear` (`g_utils.c:441-446`) and `NPC_NPCPtrsClear` (`NPC_spawn.c:1299-1305`) to null the pointer tables. The rows below use the `_XBOX` arm as the Raven form of a BG_Alloc with no pool, so no row adds a function, an overload, or a type.

## Facts every row uses

Lifetime. The PC pool never frees inside a module load. The engine unloads the module and loads it again at each map load and each `map_restart`: OpenJK's `VM_Restart` at `openjk/codemp/qcommon/vm.cpp:104-113` frees the VM and creates it again, so Raven's pool and his pointer tables start at zero. In Swift, each `dllEntry` builds a new `BgState` (`Sources/jampgame/jampgame.swift:15`), and the old pool is never freed (`Sources/JKAMP_BG/bg_local.swift:53-55`). `world` is one process global (`Sources/JKAMP_GameLogic/g_local.swift:831`), and `dllEntry` does not build it again. If the image stays loaded across the reload, `gClPtrs`, `gNPCPtrs`, `botstates`, and `gWPArray` on `world` keep pointers into the old pool. These pointers stay valid only because no code frees that pool. This record does not prove whether each platform unloads the image. For this reason, every proposed form below never frees a block, as the pool is never freed today.

Alignment. `BG_Alloc` rounds the head to 4 (`bg_misc.swift:1685`) over a base aligned to 16 (`bg_local.swift:342`). A view binds the memory with `assumingMemoryBound(to:)` (`Sources/JKAMP_Game/Generated/Views/Client.swift:19`) and reads `raw.pointee`, so Swift needs the alignment of the C type. On a 64-bit build, `gclient_t` (7344 bytes), `gNPC_t` (896), and `bot_state_t` (5096) hold pointers and need 8 (`Sources/CJKAMP_Game/layout_asserts.h:3277`, `:2743`, `:2582`). `wpobject_t` is 300 bytes (`Sources/CJKAMP/layout_asserts.h:3921`), so each waypoint block moves the head by 4 modulo 8. `G_InitBots` loads the waypoints during `G_InitGame` (`g_bot.c:1309`, `g_main.c:1070`), before any NPC spawns and before any bot connects. The vehicle text blocks (1024 and 128 bytes) and the animation sets (7 × 1544 = 10808 bytes) keep the head at 8. So after an odd count of waypoint blocks, every later `Client`, `GNPC`, and `BotState` starts at 4 modulo 8. This is undefined behaviour in Swift. arm64 and x86_64 accept a plain misaligned load, so no trap shows. jka-rust added `BG_AllocPad8` for the same cause (`jka-rust/crates/mp/bg/src/bg_misc.rs:1821-1841`).

Zero. Raven's static pool is zero at load. `bg.pool` is allocated with no zero fill (`bg_local.swift:342`). A large allocation gets fresh zero pages in practice, but nothing guarantees it. `CreateNewWP` (`ai_wpnav.c:371-400`) does not set `neighbornum`, so a new waypoint reads C's zero only from a zero pool.

## P1. Client structs per entity slot (class A)

Ratified as proposed on 2026-10-29.

The site is `G_CreateFakeClient` at `Sources/JKAMP_GameLogic/g_utils.swift:476-481`, with `BG_Alloc(Int32(Client.byteCount))` at `:478`. Raven's is `g_utils.c:428-438`. `G_FreeFakeClient` at `g_utils.swift:431-436` has an empty body, as Raven's at `g_utils.c:376-381`, whose `trap_TrueFree` is a comment. Its callers are `G_CleanAllFakeClients` (`g_utils.swift:493`, called from `G_ShutdownGame` at `g_main.swift:964`) and `G_FreeEntity` (`g_utils.swift:954`).

Readers. `gClPtrs` is `world.storage.gClPtrs` (`g_utils.swift:38`, `Sources/JKAMP_Game/Generated/Storage/GameStorage.swift:729-731`), read at `g_utils.swift:477` and `:480`. The one caller, `NPC_Spawn_Do` at `NPC_spawn.swift:1153`, stores the client in `newent.client`, clears it at `:1172` (Raven's `memset` at `NPC_spawn.c:1460`), and sets `playerState` to `client.ps` at `:1176`. After that, every `ent.client` read of an NPC reads the block. The engine reads it too: `SV_BuildClientSnapshot` at `openjk/codemp/server/sv_snapshot.cpp:579-585` copies the vehicle's `playerState` into each rider's snapshot through `veh->playerState` of `sharedEntity_t` (`g_public.h:681`). So the block must keep its address while the entity holds it.

Lifetime. Raven allocates once per slot per module load, never frees, and gives the same block to the next NPC in that slot. At a map change, the module reload sets `gClPtrs` to NULL. In Swift, `gClPtrs` lives on `world`.

Proposed form. No change at the site. `G_CreateFakeClient` keeps Raven's lines. Under P7, `BG_Alloc` returns a zeroed block aligned to 16, so the `Client` is aligned and zero. No owner frees the block. `gClPtrs` on `world.storage` holds the pointer. The reset point is the module load, as in Raven.

Alternative. A generated table of `MAX_GENTITIES` records of `gclient_t` on `GameStorage`, in the shape of `g_vehiclePool` (`GameStorage.swift:725-727`, used by `G_AllocateVehicleObject` at `g_utils.swift:438-458`), with `gClPtrs[entNum]` set to record `entNum`. This costs about 7.5 MB, one storage name that Raven does not have, an edit to Raven's line at `:478`, and a `skeleton.py` row. It is not proposed.

Generator rows. None for the proposed form.

## P2. NPC structs per slot (class B)

Ratified as proposed on 2026-10-29.

The site is `New_NPC_t` at `Sources/JKAMP_GameLogic/NPC_spawn.swift:1015-1029`, with `BG_Alloc(Int32(GNPC.byteCount))` at `:1020`. Raven's is `NPC_spawn.c:1278-1296`. `gNPCPtrs` is `world.storage.gNPCPtrs` (`NPC_spawn.swift:11`, `GameStorage.swift:21-23`).

Readers. `New_NPC_t` reads `gNPCPtrs` at `:1019` and `:1023` and clears the block at `:1028` (Raven's `memset` at `NPC_spawn.c:1293`). The one caller stores it in `newent.NPC` at `NPC_spawn.swift:1145`, and every `NPC` read of the NPC files reads it after that. The engine does not read it: `sharedEntity_t` at `g_public.h:678-690` has no `NPC` field.

Lifetime. The same as P1. Raven never frees the block and clears it at each `New_NPC_t`.

Alignment. 8 on a 64-bit build, misaligned today after an odd waypoint count.

Proposed form. No change at the site. P7 gives an aligned, zeroed block.

Alternative. Rule 9 says memory that only the module reads becomes Swift state on the world. `GNPC` is a view over C memory that every NPC file reads by field, so a Swift struct is a port of its own. It is not proposed.

Generator rows. None.

## P3. Animation sets (class C)

Ratified as proposed on 2026-10-29.

The sites are in `Sources/JKAMP_BG/bg_panimate.swift`: `BG_AnimsetAlloc` at `:1356-1360` with `BG_Alloc(Int32(Animation.byteCount) * MAX_TOTALANIMATIONS)` at `:1357`, `BG_AnimsetFree` at `:1363` with Raven's body in a comment, `BG_ClearAnimsets` at `:1340` with Raven's body in a comment, and `BG_InitAnimsets` at `:1331`, which zeroes `bgAllAnims`. Raven's are `bg_panimate.c:1702-1744`. `BG_ParseAnimationFile` calls the allocator at `:1443` for the rocket trooper and at `:1450` for any other non-humanoid skeleton, and the no-op free at `:1466` and `:1479`.

Readers. `bgAllAnims` is `bg.storage.bgAllAnims` (`bg_panimate.swift:15`, `Sources/JKAMP_BG/Generated/BgStorage.swift:13-15`), and its `anims` field holds the block. The reads are `bg_panimate.swift:1258`, `:1428`, `:1570`, `:1576`, and `:1933`, `g_active.swift:2576`, which sets `pm.animations`, `g_client.swift:2546-2608`, `w_saber.swift:1324`, `:1327`, `:1928`, `:1971`, and `:6346-6347`, `g_combat.swift:630`, and `SpeederNPC.swift:371` and `:617`. Each entity's `localAnimIndex` holds an index into `bgAllAnims` for the level.

Lifetime. The block lives until the module unloads. `BG_InitAnimsets` at `G_InitGame` (`g_main.swift:760`, Raven's `g_main.c:916`) zeroes the table and drops the pointers with no free. `bgNumAllAnims` keeps its count, which Raven resets only with the module (`bg_panimate.c:1703`) and Swift resets with each new `BgState`. A failed parse leaves its block, and the next `BG_AnimsetAlloc` writes over the slot's pointer.

Alignment. `animation_t` is 7 bytes and holds no pointer, so any address holds it.

Proposed form. No change at the site. P7 gives the block.

Alternative. A `BgStorage` table of `MAX_ANIM_FILES` sets, 64 × 10808 = 691712 bytes, needs a row slice of `Slots`, which `Slots` does not have, so it needs a new helper. It is not proposed.

Outside the Swift tree. The UI allocates animation sets at `ui_main.c:648`, cgame allocates `clientInfo_t` at `cg_players.c:7698` and `Vehicle_t` in the `#else` arm of `G_CreateAnimalNPC` and its three twins, and `ParseAnimationEvtBlock` at `bg_panimate.c:2089` allocates 2048 bytes under `#ifndef QAGAME`. A later cgame or UI port reaches all of them through the same `BG_Alloc`.

Generator rows. None.

## P4. Vehicle strings (class D)

Ratified as proposed on 2026-10-29.

The live sites are in `Sources/JKAMP_BG/bg_vehicleLoad.swift`: the `VF_LSTRING` arm of `BG_ParseVehWeaponParm` at `:85-89`, with `BG_Alloc(1024)` and a raw `strcpy`, and the arm of `BG_ParseVehicleParm` at `:443-447`, with `BG_Alloc(128)`. Raven's are `bg_vehicleLoad.c:196` and `:870`. The lines at `:296` and `:345` are inside the comment block at `:292-389`, Raven's own comment at `bg_vehicleLoad.c:712`, so they allocate nothing.

Readers. The fields are the `char *` fields of `vehWeaponInfo_t` and `vehicleInfo_t` in `g_vehWeaponInfo` and `g_vehicleInfo`, and every read goes through the view's `String?` getter: `bg_vehicleLoad.swift:244`, `:713-714`, `:756`, `:954`, `:966`, and `:969`, `g_client.swift:1560-1561` and `:1756-1757`, `NPC_spawn.swift:956`, `:958`, and `:1677-1678`, `FighterNPC.swift:89`, and `g_vehicleTurret.swift:147`, `:150`, `:153`, and `:156`. No Swift body writes into the text, although Raven's comment keeps 1024 bytes "in case we want to write over the string".

Lifetime. `BG_VehicleSetDefaults` clears the record at each parse, so each `G_InitGame` allocates again. Raven's test of a NULL field keeps the first value of a repeated key.

Proposed form. The string pool, the text ABI boundary of rule 9, holds the text, as it does for `G_NewString`. Each arm reads `if b[pointer: ofs] == nil { b[string: ofs] = value }`: Raven's test stays, and the `BG_Alloc` call and the raw `strcpy` go. The `b[string:]` store interns the text (`docs/transcription.md:707`). The two calls at `:88` and `:446` are the callers this record found for the raw `strcpy` overloads at `Sources/JKAShared/CString.swift:220`, `:226`, and `:237`. A build shows whether any other caller remains.

Alternative. No change. Under P7 the arms work as written.

Generator rows. None. The file is adopted.

## P5. Vehicle read buffers (class E)

Ratified as proposed on 2026-10-29.

The sites are in `bg_vehicleLoad.swift`: the local `var tempReadBuffer: UnsafeMutableRawPointer` at `:789`, `BG_TempAlloc(MAX_VEH_WEAPON_DATA_SIZE)` at `:806`, `trap_FS_Read(OpaquePointer(tempReadBuffer), len, f)` at `:824`, `tempReadBuffer[byte: len] = 0` at `:825`, the raw `strcat`, and `BG_TempFree` at `:847`. The twin is at `:881-922` with `MAX_VEHICLE_DATA_SIZE`. Raven's are `bg_vehicleLoad.c:1421` and `:1513`, with the sizes 0x20000 and 0x80000 at `:72-73`. The only readers are the two loops of the same functions.

Proposed form. The `CHARBUF_ALLOCS` form that `tools/oracle-closure/rulings.py:210-211` already names for these two locals: `var tempReadBuffer = CharBuf(MAX_VEH_WEAPON_DATA_SIZE)`, the call `_ = BG_TempAlloc(MAX_VEH_WEAPON_DATA_SIZE)` and its `BG_TempFree` on the page, `trap_FS_Read(&tempReadBuffer, len, f)` (`Sources/JKAMP_BG/Generated/bg_strap.swift:194`), `tempReadBuffer[len] = 0`, and `strcat(&VehWeaponParms, tempReadBuffer, at: marker)` (`CString.swift:293`). After this row, no body reads the result of a temporary allocation, and the raw `strcat` at `CString.swift:299` has no caller. jka-rust made the same move with a local heap buffer (`jka-rust/crates/mp/bg/src/bg_vehicleLoad.rs:895`).

Open point. The draft classifier did not give these locals the `CharBuf` form, although the ruling names them. This record does not prove the cause. The row needs a check of `draft_classification.py:362` so that a draft writes the same form.

Generator rows. The classifier check above, if it finds a gap.

## P6. Bot library forwards (class F)

Ratified as proposed on 2026-10-29.

The forwards are at `Sources/JKAMP_GameLogic/ai_util.swift:14-44`. Raven's are `ai_util.c:14-23` for `B_TempAlloc` and `B_TempFree`, `:25-79` for `B_Alloc`, whose PC arm returns `BG_Alloc(size)` at `:77`, `:82-131` for `B_Free`, `:133-140` for `B_InitAlloc`, which zeroes `gWPArray`, and `:142-157` for `B_CleanupAlloc`, which is empty without `BOT_ZMALLOC`. `B_InitAlloc` runs at `g_main.swift:762` (`g_main.c:918`), and `B_CleanupAlloc` at `g_main.swift:1021` (`g_main.c:1198`). `B_Free` has 0 callers. The three at `ai_wpnav.swift:496`, `:553`, and `:565` are Raven's comments.

Permanent blocks, 6 `B_Alloc` sites. `botstates` at `ai_main.swift:922` (`ai_main.c:822`) gets one block per client slot, cleared at each setup (`ai_main.c:825`). `BotAISetup` zeroes the table when the start is not a restart (`ai_main.swift:6624`, `ai_main.c:7608`). Its readers are 79 `botstates[` sites in `ai_main.swift` and 5 in `w_force.swift`. The waypoints at `ai_wpnav.swift:393`, `:420`, `:447`, `:627`, and `:695` (`ai_wpnav.c:353`, `:384`, `:414`, `:616`, `:695`) get one block per waypoint. Every `gWPArray[i]` of the bot files reads them, and so does the engine: `trap_Bot_UpdateWaypoints` at `ai_wpnav.swift:2647` gives the table to the engine, and `SV_BotWaypointReception` at `openjk/codemp/server/sv_bot.cpp:79-90` keeps the pointers for its path work. The waypoint blocks must keep their address.

Temporary blocks. 11 `B_TempAlloc` sites and 16 `B_TempFree` sites, in `ai_util.swift` at `:238`, `:467`, `:499`, and `:500`, and in `ai_wpnav.swift` at `:106`, `:1800`, `:1818`, `:1819`, `:2144`, `:2166`, and `:2167`. Each is `_ = B_TempAlloc(n)` with a `CharBuf` local as the buffer (`docs/transcription.md:713-714`). The deepest nest is three, in `BotUtilizePersonality`. The 2 `BG_TempAlloc` sites at `NPC_stats.swift:1678` and `:1697` have the same form, and another agent owns them now.

Alignment. `BotState` needs 8 and `Wpobject` needs 4.

Proposed form. The forwards keep Raven's bodies. The permanent sites need no change under P7. The temporary sites need no change under P7, item 4.

Alternative for `botstates`. jka-rust's box per client slot with a stable address (commit `e81c2789` in `jka-rust/`), here a `GameStorage` table of `MAX_CLIENTS` records of `bot_state_t`, 32 × 5096 bytes. It is not proposed, for the reason of P1.

Generator rows. None.

## P7. The allocator, the unused pair, and the pool state (class G)

Ratified as proposed on 2026-10-29.

The Swift code is `bg_misc.swift:1662-1748`, Raven's PC arm is `bg_misc.c:3310-3394`, and his `_XBOX` arm is `:3226-3307`.

1. `bg.pool` goes: the property at `bg_local.swift:53-55`, its allocation at `:342`, and the `bg_pool` entry of `HAND_VARS` at `rulings.py:121-123`. Without that entry, `skeleton.py` (`:164`, `:788`) writes Raven's `static char bg_pool[MAX_POOL_SIZE]` as a `CharBuf` of 3000000 bytes, so the entry stays with a new reason and no storage. The user rules the reason text. `draft_expressions.py:543` drafts `&bg_pool[i]` and has no other reader.
2. `BG_Alloc` and `BG_AllocUnaligned` return one block per call, aligned to 16, zero filled as the PC pool is, and never freed. This is the shape of the `_XBOX` arm at `bg_misc.c:3234-3243`. `BG_AllocUnaligned` has 0 callers in both trees.
3. The count. Proposed: `bg_poolSize`, `bg_poolTail`, `MAX_POOL_SIZE`, and the three `Com_Error` paths stay as Raven's PC count, so the game still drops with Raven's text at Raven's 3000000 bytes, under rule 20. Only the return line of each function changes, and `HAND_MACROS` at `rulings.py:140-146` stays. Alternative: the pure `_XBOX` arm, with no count and no error. That removes the `HAND_MACROS` row, the two `BgVariables` entries through a new `skeleton.py` row, the hand line at `bg_local.swift:340-341`, the `maxPoolSize` parameter at `jampgame.swift:15` and in rule 23, and the test at `Tests/JKAMPTests/BgChannelTests.swift:78-83`.
4. `BG_TempAlloc` and `BG_TempFree` keep the count of item 3 and take the block store of the `_XBOX` arm at `bg_misc.c:3245-3292`: `tempAllocPointers` and `tempAllocSizes` of `MAX_TEMP_ALLOCS`, 3, as hand properties on `bg`, a zeroed block per call, and the free at the matching `BG_TempFree`. No call site changes. No body reads the block after P5. Alternative: the pair return nothing, the `RETURNS` rows at `rulings.py:197` and `:199` go, and the 13 sites in scope plus the 2 in `NPC_stats.swift` drop `_ =`.
5. `BG_StringAlloc` has 0 callers in the Swift tree and in Raven's game, cgame, and UI. Its body already returns the text (`bg_misc.swift:1739-1742`), and it needs no change. `BG_OutOfMemory` at `bg_misc.swift:1745-1747` has 0 callers in both trees. It stays with the count, or returns false as the `_XBOX` arm does at `bg_misc.c:3303-3307`.
6. The docs. Rule 9 says "`String_Alloc` and `BG_Alloc` become owned tables the same way". The proposed form is a block per call, not a table, so rule 9 needs text from the ruling. `docs/transcription.md:455`, `:475-476`, and `:716`, which quotes `return bg.pool + (bg.poolSize - size)`, need the same. Rule 23 changes only with the pure arm.

No class needs the game pool, `G_Alloc` of `g_mem.swift`. The `rww - G_Alloc bad! B_Alloc good.` comment at `ai_main.swift:924` records Raven's own move of `botstates` off it.

## H1. The `bg_pool` entry of `HAND_VARS`

Ratified as proposed on 2026-10-29.

The value of a `HAND_VARS` entry is the Swift spelling of the storage. The stub generator prints it at `skeleton.py:788`, and the drafter writes it into expressions at `draft_expressions.py:544` and `:725`. After P7 the pool has no storage, and a reason sentence in the value lands in three drafted returns and one stub line.

The value `None` means no storage. The entry reads `"bg_pool": None`, and the comment lines above it hold the reason. The stub generator prints "No storage, by the HAND_VARS ruling." for a `None` value and keeps the hand property line for a spelling. The drafter treats a `None` entry as no entry, so `&bg_pool[i]` and the bare name draft as a `portMissing` hole with the Port-note of an unreached variable. The drafted bodies of the three allocator functions cannot match Raven's pointer arithmetic after P7, and the hole is the drafter's existing form for a body hand work replaces. The other option, a legal Swift spelling, has no true name after P7. `NOT_PORTED` at `rulings.py:277` is the row for a function and has no variable form.

## The gate

`BG_VehicleLoadParms` (`g_main.c:923`) and the humanoid animation parse run at every `G_InitGame`, so every recording exercises P4, P5, and the static humanoid set. P3 needs a non-humanoid skeleton: a vehicle, an animal, or a rocket trooper.

`corpus-ffa1-human-3.rec` of `notes/2026-10-29/human-recordings.md` holds 16 clients, with 15 bots, on `mp/ffa1` with no NPC. It exercises P6: `botstates`, the `ffa1` waypoints, the waypoint file temporaries, and the chat buffers. It exercises no P1 or P2 block. The eight-bot soak of `notes/2026-10-27/open-points.md` exercises the same class for ten minutes.

The wild t2 recordings hold NPCs: `wild-t2wedge-3.rec`, `wild-t2wedge-4.rec`, `wild-t2trip-fixed.rec`, and `wild-t2trip-2156.rec` of `notes/2026-10-27/client-connect.md`. They exercise P1 and P2 at each NPC spawn, and P3 for each non-humanoid skeleton they load.

`open-points.md` names "the vehicle recording" with no file name. The `t2_trip` replays reach the first vehicle collision (`client-connect.md:61`), so they exercise a vehicle NPC. The engine read of a vehicle's `playerState` in P1 runs only while a client rides a vehicle, and no record proves which recording holds a ride. With the count of P7 item 3 kept, a replay is the same at the pool limit too. No recording comes near 3000000 bytes.

## The ledger

The user walked the seven rows on 2026-10-29, P7 first because it carries the shape, then P1 to P6, and ratified each as proposed: P7 the allocator returns one block per call in the shape of Raven's Xbox arm with the count and the overflow errors kept, P1, P2, P3, and P6 no change at the sites, P4 the vehicle strings through the string pool under Raven's nil test, and P5 the vehicle read buffers as CharBuf locals with the allocator calls kept on the page. The classifier open point of P5 has its own proof record, `p5-classifier-proof.md`, and any defect it finds is a generator row of its own. The builder surfaced the `HAND_VARS` form as H1 during the build, and the user ratified it as proposed on 2026-10-29.

## The build and the gate

The branch is `bg-pool`, off master at 8a632c6, with the change in the working tree and no commit.

### The changed files

- `Sources/JKAMP_BG/bg_local.swift`, P7. The `pool` property of `BgState` and its allocation are gone. `BgState` has the hand properties `tempAllocPointers` and `tempAllocSizes` of `MAX_TEMP_ALLOCS` slots, with a Source line to `bg_misc.c:3247-3249`. The file-scope `let MAX_TEMP_ALLOCS: Int32 = 3` has a Source line to `bg_misc.c:3247`, the define of the Xbox arm. `maxPoolSize` and the `bg_poolTail` line stay.
- `Sources/JKAMP_BG/bg_misc.swift`, P7. The `bg_pool` stub takes a rule 24 line. `BG_Alloc` and `BG_AllocUnaligned` keep the rounding, the tail test, the `Com_Error`, and the `bg_poolSize` bump, and return one zeroed block of alignment 16 that is never freed. `BG_TempAlloc` and `BG_TempFree` keep the count and take the slot search, the two `Com_Error` texts, and Raven's two comments of the Xbox arm. `BG_StringAlloc` and `BG_OutOfMemory` do not change.
- `Sources/JKAMP_BG/bg_vehicleLoad.swift`, P4 and P5. Each `VF_LSTRING` arm reads `b[string: ofs] = String(value)` under Raven's nil test and Raven's comment. `value` is a `CharBuf` and the subscript takes a `String`, so the line needs `String(value)`. In `BG_VehWeaponLoadParms` and `BG_VehicleLoadParms`, the buffer is a `CharBuf` local of the constant size, the call is `_ = BG_TempAlloc(...)` with its free, the read takes `&tempReadBuffer`, and the terminator is `tempReadBuffer[len] = 0`. These lines match the drafter output of `bodies.py --only` for both functions.
- `docs/porting-rules.md`, rule 9, and `docs/transcription.md`, `:455`, `:475-476`, `:710`, and `:717`, take the ratified form.
- `tools/oracle-closure/rulings.py`, `skeleton.py`, and `draft_expressions.py`, H1. The `bg_pool` entry of `HAND_VARS` stays with the value `None`, the stub generator prints "No storage, by the HAND_VARS ruling." for it, and the drafter gives it no spelling.

Each changed function body has one rule 24 comment. The raw `strcpy` overloads at `CString.swift:220` and `:226` keep callers in `StringPool.swift:26` and in the tests. The `PooledString` overload at `:237` and the raw `strcat` at `:299` keep only test callers or none. All stay in place.

### The reason text

The builder first wrote the reason as the value, `"bg_pool": "the allocator returns one block per call, so the pool has no storage"`, and the generators read it as a Swift spelling. H1 moved the reason into the comment above the entry and made `None` the value.

### The gate counts

1. `swift build`: 0 errors. The first build had 2 errors at the two P4 lines, and `String(value)` fixed them.
2. `swift test --no-parallel`: 112 tests in four runs, 1, 84, 13, and 14, all pass.
3. `tools/load-test.sh`: exit 0.
4. The tool tests: 82 tests, OK, 16 skipped. Run again after H1 with the same counts.
5. `draftcheck.py --every`: 1280 holes, 0 cascade errors, 0 defects, 2 compile holes before H1. After H1: 1283 holes, 0 cascade errors, 0 defects, 2 compile holes. The three new holes are the `bg_pool` reads in the drafted returns of `BG_Alloc`, `BG_AllocUnaligned`, and `BG_TempAlloc`.

### The snapshot differences

Before H1, `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared` exited 1 with 4 files and 30 lines different: the three drafted returns read the reason text as an expression, and the `bg_pool` stub line named it as a hand property. After H1 the check showed the ruled form, and the snapshot was refreshed. A second check against the refreshed snapshot exits 0.

- `bodies/bg_misc.swift`: the drafted returns of `BG_Alloc`, `BG_AllocUnaligned`, and `BG_TempAlloc` are `portMissing` holes, each under `// Port-note: Raven reaches \`bg_pool\` here, and no Swift file holds it yet.` and Raven's line.
- `skeleton/bg_misc.swift` and `manifest/bg_misc.md`: the `bg_pool` line reads "No storage, by the HAND_VARS ruling."
- `manifest/bg_misc.md` and `manifest/bg_vehicleLoad.md`: line shifts only.

### The replays

Each replay ran on a fresh scratch homepath with the dylib, the recording, and the two `.nav` files copied in, through the stepper with `g_teamAutoJoin 1` and `ttycon 0`.

- `wild-t2trip-fixed.rec` on `t2_trip`, the vehicle recording, 22000 steps: `REF REPLAY END` at log line 21923, exit 0, no trap, 2 kills.
- `wild-t2wedge-3.rec` on `t2_wedge`, with NPCs, 181000 steps: `REF REPLAY END` at log line 182039, exit 0, no trap, 40 kills. The run of 2026-10-27 on master also logged 40 kills.
- `corpus-ffa1-human-3.rec` on `mp/ffa1` with `sv_maxclients 32` and `bot_minplayers 31`, 6500 steps: `REF REPLAY END` at log line 6249, exit 0, no trap, 11 kills.

### The map change run

`mp/ffa1`, `mp/duel1`, `map_restart 0`, and `mp/ffa1` again, with `bot_minplayers 4` and `sv_maxclients 8`, under the alarm of 400 seconds: exit 0 after 195 seconds, four `InitGame` and four `ShutdownGame` lines, 8 kills, and no Fatal line.
