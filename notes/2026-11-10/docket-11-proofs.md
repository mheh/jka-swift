# Docket 11, the proofs of the open rows

Tree: `/tmp/jka-batch-10`. Raven cites are under `oracle/codemp/` of the main tree. Swift and tool cites are in the worktree.

Reach check for every botlib row. The MP game calls none of the 22 botlib traps of rows 1 to 3. A grep of `game/*.c` without `g_syscalls.c` finds no call of `trap_EA_Command`, `trap_BotLibVarGet`, `trap_BotChooseBestFightWeapon`, `trap_BotChooseLTGItem`, `trap_BotChooseNBGItem`, `trap_AAS_FloatForBSPEpairKey`, `trap_GeneticParentsAndChildSelection`, or the other 14 of row 1. The MP game also does not call `trap_BotLibLoadMap` or `trap_BotLibStartFrame`, so AAS_LoadMap, AAS_LoadBSPFile, and the route cache never run. No base pk3 holds a `.aas` file. Thus rows 1 to 4 and 7 are off the live path of base MP. A fork's game module can reach them through the `sv_game` arms.

---

## Row 1. The 17 export thunks with an `inout CharBuf` parameter

**Raven.** Each function takes a non-const `char *`. The `botlib_export_t`, `aas_export_t`, `ai_export_t`, and `ea_export_t` tables store them, `botlib/be_interface.cpp:696` (EA_Command), `:853` (BotLibVarGet), `:859` (PC_SourceFileAndLine) and others. The `sv_game` arms pass the module's pointer, for example `sv_game.cpp:1042` `botlib_export->ea.EA_Command( args[1], (char *)VMA(2) )` and `:951` BotLibVarGet.

There are three groups, by what the body does with the text:

- Fills a sized buffer (6): AAS_ValueForBSPEpairKey (`be_aas_bspq3.cpp:262`), Export_BotLibVarGet (`be_interface.cpp:213`), BotGetChatMessage (`be_ai_chat.cpp:2804`), BotGoalName (`be_ai_goal.cpp:663`), Characteristic_String (`be_ai_char.cpp:733`), BotMatchVariable (`be_ai_chat.cpp:1451`).
- Fills a buffer with no size (1): PC_SourceFileAndLine (`l_precomp.cpp:3280`), `strcpy(filename, sourceFiles[handle]->filename)`, and the source field is `char filename[1024]` (`l_precomp.h:82`).
- Reads only, with Raven's `const` left out (8): EA_Command (`be_ea.cpp:119`, it calls `botimport.BotClientCommand`), BotLoadCharacter (`be_ai_char.cpp:551`), BotLoadChatFile (`be_ai_chat.cpp:2183`), BotLoadItemWeights (`be_ai_goal.cpp:1674`), BotLoadWeaponWeights (`be_ai_weap.cpp:347`), BotNumInitialChats (`be_ai_chat.cpp:2448`), StringContains (`be_ai_chat.cpp:447`), BotReplyChat (`be_ai_chat.cpp:2597`, it does `strcpy(match.string, message)`).
- Rewrites in place with no size (2): UnifyWhiteSpaces (`be_ai_chat.cpp:423`, the text only gets shorter), BotReplaceSynonyms (`be_ai_chat.cpp:744`, through StringReplaceWords `:520`, which can make the text longer with no bound).

**Swift.** The holes are in `Sources/JKAMP_DedLogic/be_interface.swift` at lines 600, 686, 708, 727, 731, 735, 739, 743, 773, 806, 810, 862, 881, 885, 911, 936, 953. Each is `portMissing` with the Port-note "the host has no thunk form that reads or writes a C buffer into a CharBuf". The Swift bodies take `inout CharBuf`, for example `be_ea.swift:129` `func EA_Command(_ client: Int32, _ command: inout JKAShared.CharBuf)`.

The caller side already works. For a sized buffer, the view method takes `inout CharBuf` and hands its base (`Generated/Views/BotlibExport.swift:132` runBotLibVarGet, `Ai_export.swift:318` runBotGetChatMessage), and the arm copies the result into the module's bytes (`sv_game.swift:1044` to `:1046`). For no size, the method takes `OpaquePointer?` (`Ea_export.swift:71` runEA_Command), and the arm hands `args.VMA(2)` (`sv_game.swift:1206`).

**Candidate precedents.**

- `charBuf(at:capacity:)` and `store(_ buf:at:capacity:)`, `Sources/JKAShared/Views/CStrings.swift:24` and `:33`. These read a C `char[N]` as the buffer a callee writes, then write it back. The generated `...Buffer` accessors use exactly this pair, for example `Generated/Views/BotMatch.swift:69` to `:73`, "for a `char *` parameter the port spells `inout CharBuf`".
- The read, call, and write-back shape of a thunk: cgame `CG_OwnerDrawHandleKey`, `Sources/JKAMP_CGameLogic/cg_main.swift:3871`, cgame `CG_GetTeamColor`, `cg_main.swift:3929`, and ded `AAS_PresenceTypeBoundingBox`, `be_interface.swift:566`.
- A cgame callback thunk that fills a C buffer of a given size: `trap_Cvar_VariableStringBuffer`, `cg_main.swift:4011` to `:4014`, `store(value, at: UnsafeMutableRawPointer(buffer!), capacity: Int(bufsize))`. This is the one game or cgame thunk where the callee writes a text buffer.
- A cgame thunk that reads a `char *` into a CharBuf: `CG_RunMenuScript`, `cg_main.swift:3914`, `TextCursor(CharBuf(text(at: p!)))`.
- The game and cgame trap side, which the generator makes: `trap_PC_SourceFileAndLine`, `Sources/JKAMP_Game/Generated/g_syscalls.swift:1985`, makes a 128-byte buffer, lets the engine fill it, and returns a `String`.

**Verdict: PATTERN for 16 of 17.**

- Sized (6): `var buf = charBuf(at: UnsafeMutableRawPointer(p!), capacity: Int(size))`, call the body with `&buf`, then `store(buf, at: UnsafeMutableRawPointer(p!), capacity: Int(size))`. This is the pair of `CStrings.swift:24` and `:33` in the shape of `cg_main.swift:3871`.
- Read-only (8): `var buf = CharBuf(text(at: p!))`, then call the body. There is no write-back. This is the form of `cg_main.swift:3914`.
- UnifyWhiteSpaces: `CharBuf(text(at:))`, call the body, then `store(buf, at:, capacity: buf.count)`. The text only gets shorter, so the copy stays inside Raven's bytes.
- PC_SourceFileAndLine: write back with `store(String(filename), at:, capacity: 1024)`, the bound of the source field `l_precomp.h:82`. Its `int *line` takes the `Slots<Int32>(scalars:count: 1)` write-back of `cg_main.swift:3996`.

**NO PATTERN for one sub-row: BotReplaceSynonyms.** Raven writes past the text with no bound. A copy-back needs a capacity that Raven does not give. There are two candidates:

- A: capacity `MAX_MESSAGE_SIZE` (256), the botlib bound for chat text at `be_ai_chat.cpp:328` and `:1422`. Cost: this is a bound Raven does not write, so the site needs an AI comment.
- B: `CharBuf(text(at:))` and a write-back of `strlen(buf) + 1` bytes. Cost: a longer result writes past the module's text, as Raven does. It is faithful but unsafe.

No base path calls it.

**Live path.** None. EA_Command is not live on a normal FFA map. The MP game never calls `trap_EA_Command`. The botlib's own calls (`be_ai_move.cpp:2558` to `:2696`, the grapple) call the Swift function directly, not through the thunk, and they sit under BotMoveToGoal, which the MP game also does not call.

---

## Row 2. The three chooser thunks whose list has no count

**Raven.** `BotChooseBestFightWeapon(int weaponstate, int *inventory)` at `be_ai_weap.cpp:387`, `BotChooseLTGItem(..., int *inventory, ...)` at `be_ai_goal.cpp:1268`, and `BotChooseNBGItem` at `be_ai_goal.cpp:1435`. FuzzyWeight indexes `inventory[fs->index]` (`be_ai_weight.cpp:563` to `:669`), and the index comes from the weight file (`:147`). C gives no bound. The arms are at `sv_game.cpp:1217`, `:1219`, and `:1294`.

**Swift.** `be_interface.swift:640`, `:644`, and `:648` are `portMissing`, with the note "the `int *inventory` has no count beside it". The bodies take `Slots<Int32>` (`be_ai_weap.swift:267`, `be_ai_goal.swift:1182` and `:1357`), and that is ruled at `rulings.py:1442` to `:1444`, kind `bytes`. The arms pass the raw word (`sv_game.swift:1458`, `:1463`, `:1581`).

**Candidate precedents.**

- `Sources/JKAMP_Ded/GameViews.swift:94` to `:97`, Raven's `(int *)VMA(x)`, `Slots<Int32>(scalars: self.word(x)!, count: Int.max / 4)`, "the words at the word with the widest count".
- `Sources/JKAMP_Ded/BotlibViews.swift:10` to `:11`, `areatraveltimes`, "with no bound", `count: Int.max`.
- The view generator rule for an unbounded `int *` field, `tools/oracle-closure/views.py:391` to `:396`, "C gives the pointer no bound, so the Slots takes the widest count".
- The thunk-side handle form `Slots.init(scalars handle: OpaquePointer, count:)`, `Sources/JKAMP_Ded/ThunkReaders.swift:33`.

**Verdict: PATTERN.** The form is `Slots<Int32>(scalars: inventory!, count: Int.max / 4)` in each thunk, the widest count of `GameViews.swift:96`. LTG and NBG read `origin` with `vector(at:)`, as the other thunks do. NBG's `ltg` is `BotGoal(handle: $4!)`.

**Live path.** None. The MP game does not call the three traps.

---

## Row 3. The two `sv_game` arms that need PARAMS rows

**Raven.**

- `sv_game.cpp:1014` to `:1015`: `AAS_FloatForBSPEpairKey( args[1], (char *)VMA(2), (float *)VMA(3) )`. The callee writes one float, `be_aas_bspq3.cpp:306`.
- `sv_game.cpp:1310` to `:1311`: `GeneticParentsAndChildSelection(args[1], (float *)VMA(2), (int *)VMA(3), (int *)VMA(4), (int *)VMA(5))`. `ranks` is a list of `numranks` floats, and the three `int *` are single outputs, `be_ai_gen.cpp:73`.

**Swift.** `sv_game.swift:1160` to `:1163` and `:1600` to `:1603` are `portMissing`. The cause is in the view: the default rule for a non-const `float *` of a stored function is `inout vec3_t` (`views.py:861` to `:868`). So `Generated/Views/Aas_export.swift:274` and `Ai_export.swift:1098` take `inout vec3_t`. The two thunks are already right (`be_interface.swift:528` and `:865`).

**Candidate precedents.**

- AAS_FloatForBSPEpairKey: PARAMS kind `float_mut`, keyed by "record.field". The rows are `("displayContextDef_t.ownerDrawHandleKey", "special")` at `rulings.py:1270` and `("botlib_import_t.FS_FOpenFile", "file")` at `:1466`. The generator branch is at `views.py:802` to `:808`, and the kind is described at `rulings.py:1156`. The arm then follows its twin `BOTLIB_AAS_VECTOR_FOR_BSP_EPAIR_KEY`, `sv_game.swift:1155` to `:1158`, with `let v: Slots<Float> = args.VMA(3)` (the overload at `GameViews.swift:101`) and `&v[0]`.
- GeneticParentsAndChildSelection: no kind gives a `float *` list for a stored function. `table` takes only `vec3_t *` (`views.py:815`), and `bytes` takes only `void *` (`views.py:809`). The nearest rule is kind `bytes` on an `int *` list (row D16, `rulings.py:1438` to `:1444`) and the field rule `views.py:391`, which gives the caller's Slots. The arm has the `Slots<Float>` overload of VMA, `GameViews.swift:101`.

**Verdict.**

- AAS_FloatForBSPEpairKey: **PATTERN**. Add the row `("aas_export_t.AAS_FloatForBSPEpairKey", "value"): "float_mut"`, then write the arm in the form of `sv_game.swift:1157`.
- GeneticParentsAndChildSelection: **PATTERN with a generator branch**. Add the row `("ai_export_t.GeneticParentsAndChildSelection", "ranks"): "bytes"` and one `elif` in `views.py` beside `:809`, for a FLOAT pointee: the parameter is `Slots<Float>`, and the argument is `OpaquePointer(ranks.base)`, the shape of the `table` branch at `:815` to `:820`. The arm passes `args.VMA(2)` as `Slots<Float>` and the three `int *` words as they are. The cost is new code in a generator branch, so the sequence must run. Option B makes no generator change: `ranks` stays `inout vec3_t`, and the arm keeps its hole. The arm is dead on base MP.

**Live path.** None. The MP game does not call either trap.

---

## Row 4. Two scalar FS reads and writes

**Raven.**

- `be_aas_file.cpp:481` to `:492`, AAS_WriteAASLump: `botimport.FS_Write(data, length, fp)`, where `data` is a `char *` into the AAS world. It is not a scalar. It is a block of `length` bytes.
- `be_aas_route.cpp:1014` to `:1019`, AAS_ReadCache: `botimport.FS_Read(&size, sizeof(size), fp)`, the read of one `int` by its address.

**Swift.**

- `be_aas_file.swift:281` to `:294`: `data: OpaquePointer?`, and the hole at `:293` has the note "no form binds the OpaquePointer `data` without an `Unsafe` type".
- `be_aas_route.swift:1092` to `:1098`: `let size: Int32 = 0`, and the hole at `:1098`.

**Candidate precedents.**

- For the block write: the handle form `Slots.init(scalars handle: OpaquePointer, count:)` at `Sources/JKAMP_Ded/ThunkReaders.swift:33`. DedLogic already uses it with OpaquePointer words, for example `be_interface.swift:592` `Slots<Int32>(scalars: areas!, count: Int(maxareas))`. Also the read of a raw block, `common.swift:1078` `FS_Read(Slots(scalars: block, count: Int(ev.evPtrLength)), ...)`.
- For the scalar read: the CNavigator form, a CharBuf of the value's bytes, `CNavigator.swift:2018` to `:2024` (GetInt: `var value = CharBuf(Int32.byteCount)`, `FS_Read(&value, ...)`, `value.withSlots { $0[int: 0] }`) and the write twin `CNavigator.swift:183` to `:199`. The bridge from a CharBuf to `Slots<byte>` is `CharBuf.withMutableSlots`, `Sources/JKAShared/CharBuf.swift:106`, which `files_pc.swift:1159` uses for `FS_Write`.

**Verdict: PATTERN for both.**

- AAS_WriteAASLump: `botimport.runFS_Write(Slots<byte>(scalars: data!, count: Int(length)), length, fp)`, the handle form of `ThunkReaders.swift:33`.
- AAS_ReadCache: `var sizeBytes = CharBuf(Int32.byteCount)`, then `sizeBytes.withMutableSlots { botimport.runFS_Read($0, Int32(Int32.byteCount), fp) }`, then `let size = sizeBytes.withSlots { $0[int: 0] }`. This is the GetInt form of `CNavigator.swift:2018`.

**Live path.** None. AAS_WriteAASFile and AAS_ReadRouteCache run only after AAS_LoadMap, and the MP game does not call `trap_BotLibLoadMap`.

---

## Row 5. The `%02d` and `%lu` format specifiers

**The formatter.** `Sources/JKAShared/Format.swift:74` to `:180` takes `%[-][width][.precision][l](i|d|s|c|f)`. It has no `0` flag: the width loop at `:104` to `:107` reads `02` as width 2 and pads with spaces, and it does not trap. It has no `u` and no `x`. The `l` modifier (`:124` to `:128`) takes only `i` and `d`, so `%lu` traps at `:132`.

**`%02d`.**

- Raven: `botlib/l_log.cpp:113` to `:118`, Log_WriteTimeStamped, `"%d   %02d:%02d:%02d:%02d   "`. No file of the botlib, server, or game calls Log_WriteTimeStamped. The function is dead.
- Swift: `Sources/JKAMP_DedLogic/l_log.swift:89` to `:98`, the hole at `:93`.
- Other ported sites already pass a zero flag to the formatter with no note, and they print spaces where Raven prints zeros: `Sources/JKAMP_CGameLogic/cg_draw.swift:6576` `va("%i:%02i", minutes, seconds)`, the cgame timer, and `Sources/JKAMP_DedLogic/z_memman_pc.swift:343` `%2d.%02dMB`. Two ded sites use `x`, which traps: `net_chan.swift:457` (`%02x`, the IPX address) and `files_pc.swift:2684` (`%08x`, the download name).

**`%lu`.** Raven's only use is `botlib/be_interface.cpp:578` and `:585`, inside a `/* ... */` block. No Swift site exists. The row has nothing to port.

**Candidate precedent.** Row X38 of docket 10, candidate A for `%ld`, which added the `l` modifier in `Format.swift:124` under the user's delegation (ledger 10, line 79). Before that, the `UInt32` conformance of X12 at `Format.swift:37`.

**Verdict.**

- `%02d`: **PATTERN**, the X38 form: add the `0` flag to `Format.swift`, as `l` was added. Note that this change reaches the ruled targets. The cgame timer at `cg_draw.swift:6576` changes from `1: 5` to `1:05`, which is Raven's output, so the cgame snapshot moves. Log_WriteTimeStamped itself is dead, so a DEAD row (`rulings.py:1503`) also closes the hole if the user does not want the flag now.
- `%lu`: **no row**. Raven comments it out. Close it.
- Out of scope, for the record: `%02x` and `%08x` trap at `net_chan.swift:457` and `files_pc.swift:2684`.

**Live path.** Log_WriteTimeStamped: no. The `%02d` defect is live in the cgame timer and in the ded `meminfo` print, but not in this row.

---

## Row 6. The two Wait holes of CTaskManager (ICARUS)

**Raven.** `icarus/TaskManager.cpp:1067` declares `float dwtime`.

- `:1111`: `bm->SetData( &dwtime, sizeof( dwtime ) );`, which stores the random wait into the block member.
- `:1122`: `if ( (task->GetTimeStamp() + dwtime) < ((m_owner->GetInterface())->I_GetTime()) )`. A `DWORD` plus a `float` is a float in C, and the compare converts the `DWORD` of I_GetTime to float. Inside the `if`, `:1127` does a second `SetData(&dwtime, ...)`.

**Swift.** `Sources/JKAMP_DedLogic/CTaskManager.swift:984` to `:989` and `:1001` to `:1004`. `dwtime` is `var dwtime: Float` (`:944`). `SetData(_ data: Slots<byte>?, _ size: Int32)` is at `CBlockMember.swift:88`. `GetTimeStamp() -> UInt32` is at `CTask.swift:56`, and `I_GetTime: (() -> UInt32)?` is at `interface_export_t.swift:18`.

**Candidate precedents.**

- For `&dwtime`: the CharBuf form for the bytes of a scalar in a C++ class method, `CNavigator.swift:183` to `:189` (`var value = CharBuf(Int32.byteCount)`, `value.withMutableSlots { $0[int: 0] = ... }`, then the write). It uses the `[float:]` subscript of `Slots`, `Sources/JKAShared/Views/Slots.swift:210`, and `CharBuf.withMutableSlots`, `CharBuf.swift:106`. The note says that BYTE_STORAGE_LOCALS does not reach a method. CNavigator is a C++ class too, and its hand form does not need that table.
- For the compare: X39 P17b, candidate B, ruled by the user's typed word (ledger 10, line 15): "Each site keeps its explicit conversion under a 'C converts' comment, and no new operator goes into `Promotion.swift`." Sites: `be_ai_chat.swift:1014`, `be_ai_char.swift:197`, `l_struct.swift:89`.

**Verdict: PATTERN for both.**

- `:1111` and `:1127`: `var bytes = CharBuf(Float.byteCount)`, then `bytes.withMutableSlots { $0[float: 0] = dwtime; bm!.SetData($0, Int32(Float.byteCount)) }`. This is the CNavigator form.
- `:1122`: `// C converts the DWORD time stamp and the DWORD time to float.`, then `if Float(task!.GetTimeStamp()) + dwtime < Float(I_GetTime!())`. This is X39 P17b.

**Live path.** Not on FFA. Wait runs only inside a running ICARUS script. A scan of the base MP BSPs finds script keys only in `mp/siege_desert` and `mp/siege_hoth`. Siege can reach it.

---

## Row 7. BSPEntityData through the 32000-byte ring

**Raven.** `server/sv_bot.cpp:378` to `:379`: `char *BotImport_BSPEntityData(void) { return CM_EntityString(); }`, which returns the clip map's own pointer with no copy and no bound. `qcommon/cm_load.cpp` CM_EntityString returns `cm.entityString`. The botlib reads it twice, `be_aas_bspq3.cpp:464` (`strlen`) and `:466` (`Com_Memcpy`). `sv_game.cpp:1686` sets `sv.entityParsePoint = CM_EntityString()`.

**Swift.**

- The thunk, `Sources/JKAMP_DedLogic/sv_bot.swift:851`: `{ ringText(JKAMP_DedLogic.BotImport_BSPEntityData()) }`.
- The ring, `Sources/JKAMP_Ded/ThunkReaders.swift:13` to `:26`: two buffers of 32000 bytes. `store(text, at: buf, capacity: 32000)` cuts at 31999 bytes. The cgame has the same ring (`Sources/JKAMP_CGame/ThunkReaders.swift:19` to `:32`). Its other use is `CG_FeederItemText` (`cg_main.swift:2909`), which is short text, as Raven's static buffers are.
- The source: `cm_load.swift:984`, `CM_EntityString() -> String` returns `cmg.entityString!`. The loader sets the field at `cm_load.swift:574`, and the view setter interns it in the pool: `Generated/Views/ClipMap.swift:287`, `StringPool.shared.pointer(for: newValue)`.
- The botlib side, `be_aas_bspq3.swift:393` to `:396`, calls `runBSPEntityData()` twice, as Raven does.

**How long text crosses elsewhere without the ring.**

- `Sources/jampgame/jampgame.swift:52` to `:55`, GAME_CLIENT_CONNECT: "The engine reads the denial text through the pointer, so the text goes through the string pool", `return Int(bitPattern: StringPool.shared.pointer(for: denial))`.
- Every `char *` field setter of the views: `ClipMap.swift:287`, `World.swift:269`, and `Sources/JKAShared/Views/RawField.swift:90`. `StringPool.intern` (`Sources/JKAShared/Views/StringPool.swift:21` to `:27`) copies a text of any length once, never frees it, and returns the same pointer for the same text.

**Verdict: PATTERN.** The thunk returns `OpaquePointer(StringPool.shared.pointer(for: JKAMP_DedLogic.BotImport_BSPEntityData()))`, the form of `jampgame.swift:55`. The entity string is already in the pool, so this is a lookup and gives the pointer of the field, as Raven returns `cm.entityString`. There is no cut and no copy. The ring stays for the short texts that Raven returns from static buffers.

**Live path.** None on base MP. AAS_LoadBSPFile runs only under AAS_LoadMap, which the MP game does not call. A long entity string is common, so a fork that loads AAS would get a cut string.

---

## Row 8. The RMG classes

**What is still a hole.**

- `CRMManager.swift:354`, ProcessAutomapSymbols (`RMG/RM_Manager.cpp:442`). On DED, Raven's body is empty: `#ifndef DEDICATED` wraps the whole body (`:444` to `:473`). Its two callers, `RM_Mission.cpp:1508` and `:1512`, also stand under `#ifndef DEDICATED`.
- `cm_terrain.swift:110`, CM_TerrainPatchIterate (`qcommon/cm_terrain.cpp:1628`). Its callers are `renderer/tr_terrain.cpp:923` and `RMG/RM_Terrain.cpp:493` (RM_CreateRandomModels, which only `client/cl_cgame.cpp:1707` calls). Neither caller is in the DED build.
- `CRMMission.swift`: 24 holes (`:87` to `:412`). The causes are no Swift type for `symmetry_t` (`RM_Headers.h:29`), CRMAreaManager, CRMPathManager, CRMInstance, and no table row for `int* flattenHeight` (`:322`).
- `CRandomTerrain.swift`: 6 holes (`:24` to `:119`). The causes are no Swift class for CPathInfo (`qcommon/cm_randomterrain.h:15`) and no table row for the `vec4_t` outputs of GetPathInfo (`:89`).
- `CRMObjective.swift`: no hole.

**Reach on base MP.** The single entry is `G_RMG_INIT` (`sv_game.cpp:1624` to `:1636`), under `com_RMG->integer`. The cvar defaults to `"0"` (`common.cpp:1335`). The game sets it to 1 and calls `trap_RMG_Init` only in SP_terrain (`game/g_misc.c:496` and `:608`), the spawn function of a `terrain` entity (`g_spawn.c:530`). A scan of every `maps/mp/*.bsp` in `assets0.pk3` to `assets3.pk3` finds no `"classname" "terrain"`. The other `com_RMG` checks (`sv_game.cpp:155`, `sv_snapshot.cpp:394`) call only clip map functions, not the RMG classes. Base MP maps do not reach the RMG.

**Candidate precedents.**

- For the missing classes: the CXX_CLASSES table, `tools/oracle-closure/rulings.py:1632` to `:1635` (CRMManager, CRMObjective, CRandomTerrain, CRMMission), row X41 and row C of ledger 8.
- For the two dead functions: the DEAD table, `rulings.py:1503`, with the rows of BotDrawDebugPolygons (`:1524`, "the dedicated build never draws") and WriteIndent (`:1527`, "stands only under DEBUG_AI_WEAP, which the build does not define").

**Verdict.**

- ProcessAutomapSymbols: **PATTERN, DEAD row**. The body and both callers stand under `#ifndef DEDICATED`.
- CM_TerrainPatchIterate: **PATTERN, DEAD row**. Its two callers are the renderer and RM_CreateRandomModels, which only the client calls.
- CPathInfo, CRMInstance, CRMAreaManager, CRMPathManager, `symmetry_t`, and the two table rows: **PATTERN**, CXX_CLASSES rows by X41, with their RMG files in the host list. The cost is a large generator run for code that base MP never reaches. Because of that cost, the user may want to rule the order (now, or after cgame).

**Live path.** None on any base MP map.

---

## Summary of the live path

On a normal FFA map with bots (`bot_enable 1`, `mp/ffa1`), none of the eight rows is on the live path. The MP game calls no trap of rows 1 to 3 and never loads AAS (rows 4 and 7). Log_WriteTimeStamped has no caller and `%lu` is commented out (row 5). ICARUS Wait needs a script, and only the siege maps have one (row 6). No MP map has a terrain entity (row 8). The live `%02d` defect is outside the row, in the cgame timer `cg_draw.swift:6576` and in `z_memman_pc.swift:343`.
