# The dedicated server C++ docket

This docket is row T10 of `notes/2026-11-03/dedicated-stage-1-tools.md`, the last paragraph of its Rows section, ratified as proposed in its ledger (`dedicated-stage-1-tools.md:223` on the branch `dedicated-stage-2-tools`). Row E7 asks for the measured class list as the rows of a C++ docket before the first transcription round (`notes/2026-11-03/dedicated-opening-docket.md:41-45`). Rule 17 names the classes and the types that hold one by value, and it gives the three Swift forms (`docs/porting-rules.md:42`). Every citation is read at the line.

The main tree has no `tools/oracle-closure/out/mp-engine-ded/`, and the extract of the T2 entry list does not exist yet. So this docket reads the oracle directly. The base is the eight classes of the host's `cxx_only.txt` (`dedicated-stage-1-tools.md`, section "The C++ track measure, row E7"). The read adds five types that a stage 1 file reaches through a header and that the skeleton does not list, because their methods are inline in a header and not in a stage 1 `.cpp` file.

The WinDed Release build defines `WIN32,NDEBUG,_CONSOLE,DEDICATED,BOTLIB,_WINDOWS` and no `FINAL_BUILD` (`oracle/codemp/WinDed.vcproj:32`). Every `#ifdef` below is read against that list.

## The classes

"Methods" counts the member functions apart from the constructors and destructors. The number in parentheses is the count of the definitions outside the class body. No class in the list has a virtual method.

| Class | Raven definition | Methods | Constructor, destructor | Hierarchy | Raven users |
|---|---|---:|---|---|---|
| `CTextPool` | `oracle/codemp/qcommon/GenericParser2.h:24-41` | 5 (1) | 1, 1, out of line at `GenericParser2.cpp:166`, `:179` | None. A singly linked chain through `mNext`. | `CleanTextPool` (`GenericParser2.cpp:212`), `CGenericParser2::Parse` and `Clean` (`:871`, `:903`), and every `textPool` parameter of `CGPObject`, `CGPValue`, and `CGPGroup`. |
| `CGPObject` | `GenericParser2.h:45-64` | 8 (1) | 1, 0, out of line at `GenericParser2.cpp:230` | Closed base. `CGPValue` and `CGPGroup` derive from it, both in `GenericParser2.h:68`, `:93`. No virtual method. A plain `CGPObject` is also a value node of a value list (`GenericParser2.cpp:352`, `:357`). | `CGPObject::WriteText` (`GenericParser2.cpp:238`), and the list walks of `CGPValue` and `CGPGroup`. |
| `CGPValue` | `GenericParser2.h:68-89` | 8 (6) | 1, 1, out of line at `GenericParser2.cpp:267`, `:277` | Closed. Derives from `CGPObject`, no derived class. `GetNext` hides the base `GetNext` with a cast (`GenericParser2.h:77`). | `CGPGroup::AddPair`, `FindPair`, `FindPairValue`, `Parse`, `Write`, `Duplicate` (`GenericParser2.cpp:615-857`). The `GPV_*` functions (`GenericParser2.cpp:1110-1203`) have no caller in `oracle/codemp`. |
| `CGPGroup` | `GenericParser2.h:93-134` | 21 (14) | 1, 1, out of line at `GenericParser2.cpp:458`, `:471` | Closed. Derives from `CGPObject`, no derived class. | `CGenericParser2` (`GenericParser2.cpp:860-914`). Outside stage 1: `cm_terrain.cpp:43-107`, `renderer/tr_terrain.cpp:513-573`, and the RMG (`RMG/RM_Mission.h:105-122`, `RMG/RM_Instance.h:60`). The `GPG_*` functions (`GenericParser2.cpp:977-1105`) have no caller in `oracle/codemp`. |
| `CGenericParser2` | `GenericParser2.h:136-158` | 6 (3) | 1, 1, out of line at `GenericParser2.cpp:860`, `:866` | None. | `Com_ParseTextFile` (`qcommon/common.cpp:2179`, `:2209`) and `Com_ParseTextFileDestroy` (`:2204`). Their callers are all outside stage 1: `qcommon/cm_terrain.cpp:48-109`, `renderer/tr_terrain.cpp:521-576`, `RMG/RM_Manager.cpp:152`, `RMG/RM_InstanceFile.cpp:81`, `RMG/RM_Mission.cpp:1368`, `RMG/RM_Terrain.cpp:69`. The `GP_*` functions (`GenericParser2.cpp:928-975`) have no caller. |
| `CCMShaderText` | `oracle/codemp/qcommon/cm_shader.cpp:8-26` | 5 (0) | 1, 1, both inline | None. An element of `CHash`, linked through `mNext`. | `CM_CreateShaderTextHash` (`cm_shader.cpp:37`), `CM_GetShaderText` (`:158`), `CM_FreeShaderText` (`:176`). |
| `SE_Entry_s` | `oracle/codemp/qcommon/stringed_ingame.cpp:48-59` | 0 | 1, 0, inline | None. A `struct` with two `std::string` fields. | `CStringEdPackage::AddFlagReference` (`stringed_ingame.cpp:454`), `AddEntry` (`:738`), `SetString` (`:775`), `SE_GetString` (`:981`), `SE_GetFlags` (`:1021`). |
| `CStringEdPackage` | `stringed_ingame.cpp:64-122` | 21 (17) | 1, 1, both inline | None. | The one instance `TheStringPackage` (`:124`) serves `SE_Load_Actual` (`:828`), `SE_GetString` (`:981`), `SE_GetFlags` (`:1021`), `SE_GetNumFlags` (`:1039`), `SE_GetFlagName` (`:1044`), `SE_GetFlagMask` (`:1057`), `SE_GetNumLanguages` (`:1072`), `SE_NewLanguage` (`:1144`), `SE_Init` (`:1156`), `SE_ShutDown` (`:1198`), `SE_LoadLanguage` (`:1208`). Three declared methods have no definition: `GetNumStrings`, `SetReference`, `GetCurrentFileName` (`:109`, `:111`, `:113`). |
| `CCMShader` | `oracle/codemp/qcommon/cm_local.h:77-89` | 4 (0) | 0, 0 | None. Public fields only. An element of `CHash`, linked through `mNext`. | `CMod_LoadShaders` (`cm_load.cpp:76`), `CMod_LoadBrushes` (`cm_load.cpp:253`), `CMod_LoadPatches` (`cm_load.cpp:530-531`), `CM_TraceThroughBrush` (`cm_trace.cpp:685`), `SV_ParseSurfaceParm` (`cm_shader.cpp:261`), `SV_ParseMaterial` (`:290`), `CM_ParseVector` (`:316`), `CM_ParseShader` (`:361`), `CM_SetupShaderProperties` (`:466`), both `CM_GetShaderInfo` (`:498`, `:526`). |
| `CHash<T>` | `oracle/codemp/qcommon/chash.h:11-160` | 10 (0) | 1, 1, both inline | None. A class template with two instances, `CHash<CCMShaderText> shaderTextTable` and `CHash<CCMShader> cmShaderTable` (`cm_shader.cpp:29-30`). The element must give `GetName`, `Destroy`, `GetNext`, and `SetNext` (`chash.h:4-7`). The compare is `strcmp` (`chash.h:11`). | `CM_CreateShaderTextHash` (`cm_shader.cpp:55`), `CM_GetShaderText` (`:158`), `CM_FreeShaderText` (`:176`), `CM_SetupShaderProperties` (`:475`), `CM_ShutdownShaderProperties` (`:491-494`), `CM_GetShaderInfo` by name (`:503`, `:522`). |
| `timing_c` | `oracle/codemp/qcommon/timing.h:2-60` | 2 (0) | 1, 0, inline | None. | `SV_GameSystemCalls`, the arms `CG_PRECISIONTIMER_START` and `CG_PRECISIONTIMER_END` (`server/sv_game.cpp:513-529`). `Com_Frame` (`qcommon/common.cpp:1597-1598`, `:1767-1768`) on the global `G2PerformanceTimer_PreciseFrame` of `renderer/tr_ghoul2.cpp:50`, under `G2_PERFORMANCE_ANALYSIS`, which `game/q_shared.h:45-46` defines when `FINAL_BUILD` is not defined. |
| `CMiniHeap` | `oracle/codemp/qcommon/MiniHeap.h:5-51` | 2 (0) | 1, 1, both inline | None. | Stage 1 calls no method. `SV_Init` stores the address of `CMiniHeap_singleton` (`server/sv_init.cpp:885`), and `sv_world.cpp:668`, `:744`, `:748` and `sv_game.cpp:1450`, `:1465` pass the pointer to Ghoul2. The methods run in `ghoul2/G2_API.cpp:2074`, `:2146`, `:2596`, `ghoul2/G2_misc.cpp:416`, `:639`, and `renderer/tr_ghoul2.cpp:4044`. The instance is `renderer/tr_init.cpp:30`. |
| `symbolMap_t`, `symbolVMMap_t` | `oracle/codemp/qcommon/vm_local.h:149-150` | `std::map` | | Not a Raven class. `std::` members under rule 17. `CRAZY_SYMBOL_MAP` is defined for every build but the Xbox (`vm_local.h:2-4`). | The globals `g_vmMap` and `g_symbolMap` (`vm.cpp:20-21`). `VM_ValueToSymbol` (`vm.cpp:70`), `VM_ValueToFunctionSymbol` (`:113`), `VM_SymbolForCompiledPointer` (`:185`), `VM_LoadSymbols` (`:272`, `:314`), `VM_CallInterpreted` (`vm_interpreted.cpp:313`) through `VM_SetSymbolMap` (`vm_local.h:162-165`). |

The 34 definitions of `GenericParser2.cpp` are the out-of-line counts of its five classes, 3 + 2 + 8 + 16 + 5. The 7 of `cm_shader.cpp` are the constructor, the destructor, and the 5 inline methods of `CCMShaderText`. The 21 of `stringed_ingame.cpp` are the 18 methods of `CStringEdPackage` with a body, its constructor and destructor, and the constructor of `SE_Entry_s`.

Out of scope, with the reason:

- `INetProfile` (`qcommon/INetProfile.h:6-13`) is an interface class, but `msg.cpp:4` includes it under `_DONETPROFILE_`, which WinDed does not define.
- `CCMLandScape`, `CCMPatch`, `CCMHeightDetails`, `CArea` (`qcommon/cm_landscape.h:42-135`), `CPixel32`, `CDraw32` (`cm_draw.h:42`, `:86`), `CRandomTerrain`, `CPathInfo`, and `CTerrainMap` are the terrain of row E5.
- `SPARC` (`qcommon/sparc.h:525`) is the type of `clipMap_t.visibility` on the Xbox alone (`cm_local.h:104-139`).
- `hstring`, `CMapPool`, `sstring`, `VVFixedMap`, `CNetProfile`, and the classes of `hstring.cpp` belong to files that WinDed does not compile or that no stage 1 file includes.

## The holders by value

No struct field of `qcommon.h`, `qfiles.h`, `cm_local.h`, `cm_patch.h`, `files.h`, `vm_local.h`, `server.h`, or `win32/win_local.h` has one of the classes above as its type. The `null` folder has no header. The one field that names a class is a pointer: `CCMShader *shaders` of `clipMap_t` (`cm_local.h:165`). It points at a hunk array of `CCMShader` values, one per BSP shader plus one (`cm_load.cpp:91`). `clipMap_t` also holds `CCMLandScape *landScape` (`cm_local.h:210`), a terrain class of row E5.

The holders by value are inside the C++ files and at file scope:

| Holder | Held by value | Citation |
|---|---|---|
| `CGenericParser2.mTopLevel` | `CGPGroup` | `GenericParser2.h:139` |
| `CStringEdPackage.m_StringEntries` | `SE_Entry_t`, as the value of a `std::map<string, SE_Entry_t>` | `stringed_ingame.cpp:62`, `:87` |
| `CStringEdPackage` string fields | `std::string`, `std::vector<string>`, `std::map<string,int>` | `stringed_ingame.cpp:69-72`, `:92-93` |
| `symbolVMMap_t` | `symbolMap_t`, as the value of a `std::map<vm_t*, symbolMap_t>` | `vm_local.h:150` |
| global `TheStringPackage` | `CStringEdPackage` | `stringed_ingame.cpp:124` |
| global `gvLanguagesAvailable` | `std::vector<string>` | `stringed_ingame.cpp:1071` |
| function statics `str` | `std::string` | `stringed_ingame.cpp:277`, `:393`, `:754` |
| globals `shaderTextTable`, `cmShaderTable` | `CHash<CCMShaderText>`, `CHash<CCMShader>` | `cm_shader.cpp:29-30` |
| global `g_vmMap` | `symbolVMMap_t` | `vm.cpp:20` |
| global `CMiniHeap_singleton`, outside stage 1 | `CMiniHeap` | `renderer/tr_init.cpp:30` |
| global `G2PerformanceTimer_PreciseFrame`, outside stage 1 | `timing_c` | `renderer/tr_ghoul2.cpp:50` |
| `CRMInstanceFile.mParser`, outside stage 1 | `CGenericParser2` | `RMG/RM_InstanceFile.h:24` |
| locals `parse`, `parser`, outside stage 1 | `CGenericParser2` | `cm_terrain.cpp:42`, `renderer/tr_terrain.cpp:512`, `RMG/RM_Manager.cpp:146`, `RMG/RM_Mission.cpp:1364`, `RMG/RM_Terrain.cpp:62` |

## The shapes

Each paragraph names the Swift form of rule 17 and the jka-rust precedent under `jka-rust/crates/mp/engine/qcommon/src/`.

The GP2 classes, `CTextPool`, `CGPObject`, `CGPValue`, `CGPGroup`, and `CGenericParser2`. The hierarchy has no virtual method, so it is not a virtual hierarchy, and each class becomes a plain struct with methods. `CTextPool` and `CGPObject` have no Swift type: the text pool becomes `String`, and the intrusive `mNext` and `mInOrder*` chains become `Array` order. `CGPValue` holds a name and `[String]`. `CGPGroup` holds a name, `[CGPValue]`, and its subgroups. `CGenericParser2` holds the top group by value, as `mTopLevel` does. jka-rust drops `CTextPool` and `CGPObject` (`gp2/mod.rs:9-10`), keeps the values as `Vec<String>` (`gp2/gp_value.rs:3-14`), and keeps the groups in an arena owned by `GenericParser2` with a `GpGroupId` index and a borrow type `GpGroup` (`gp2/generic_parser2.rs:9-24`, `gp2/gp_group.rs:6-41`). jka-rust does not port the `GP_*`, `GPG_*`, and `GPV_*` handle functions, because they have no caller (`gp2/mod.rs:11-14`). Row C2 asks whether stage 1 ports GP2 at all.

`CCMShaderText` and `CHash<T>`. `CHash` is a name-keyed table, so rule 17 makes it a `Dictionary` held by the world. `shaderTextTable` becomes `[String: Int]`, the name of each block to the offset of its text in `shaderText`, and `CCMShaderText` has no Swift type. `cmShaderTable` becomes `[String: ...]` over the `CCMShader` records. The element protocol of `chash.h:4-7` has no Swift counterpart. jka-rust holds `shaderTextTable` as `BTreeMap<String, usize>` of offsets (`collision_world.rs:205-214`). Its `cmShaderTable` is a stand-in `CmHashTable` whose lookup always misses (`collision_world.rs:48-90`, `:216-223`), so it is not a precedent for the lookup.

`CCMShader`. It has public fields, no constructor, and inline methods, so it becomes a C struct with its four fields in Raven's order and layout asserts, and its `GetName` becomes a method on the imported struct. With `CHash` as a `Dictionary`, `GetNext`, `SetNext`, and `Destroy` have no caller. jka-rust keeps a `#[repr(C)]` struct with `GetName`, `GetNext`, and `SetNext` (`cm/ccmshader.rs:7-40`).

`SE_Entry_s` and `CStringEdPackage`. No hierarchy, so each becomes a plain struct with methods. `CStringEdPackage` is a stored property of the engine world, as `TheStringPackage` is one instance. Its `std::map` fields become `Dictionary`, the `std::vector<string>` becomes `[String]`, and the `std::string` fields become `String`. `gvLanguagesAvailable` becomes `[String]` on the world, and the `set<string>` of `SE_GetNumLanguages` (`stringed_ingame.cpp:1086`) becomes a local `Set<String>`. jka-rust renames the types `StringEdPackage` and `SeEntry`, holds the package in `Common` (`stringed/package.rs:30-36`, `stringed/entry.rs:8-30`, `common/common.rs:143`), and keeps sorted `BTreeMap` order (`stringed/package.rs:69-71`, `:84-86`). jka-rust drops the three undefined methods (`stringed/mod.rs:26-29`).

`timing_c`. No hierarchy, so it becomes a plain struct with `Start` and `End`. The `CG_PRECISIONTIMER_START` arm writes the address of a new timer into module memory, and the `END` arm reads it back and frees it (`sv_game.cpp:513-529`). So the module holds the timer as an opaque handle, and the Swift timer needs a stable address. jka-rust boxes the timer and casts the handle back (`jka-rust/crates/mp/engine/server/src/sv_game.rs:877-882`), and it reads `Instant` in place of `rdtsc` (`timing/timing_c.rs:5-45`).

`CMiniHeap`. Stage 1 calls no method of it, so it becomes the handle it hides: an `OpaquePointer` on the world that `SV_Init` sets and the Ghoul2 traps pass on. The class stays C++ with Ghoul2. jka-rust keeps a `#[repr(C)]` struct with layout asserts in `native_types` (`miniheap/cmini_heap.rs:3`, `jka-rust/crates/native/types/src/miniheap/cmini_heap.rs:11-25`).

`symbolMap_t` and `symbolVMMap_t`. Rule 17 makes the `std::map` a `Dictionary` held by the world: `g_vmMap` becomes a dictionary from the VM to a `[Int32: ...]` symbol cache, and `g_symbolMap` names the cache of the current VM. jka-rust treats `CRAZY_SYMBOL_MAP` as never defined and ports the linear scan alone (`vm_fns.rs:56-59`). Row C8 asks which is right.

## Rows

### C1, the list and the tool

The host's `cxx_only.txt` lists a class only when a stage 1 `.cpp` file holds one of its definitions (`dedicated-stage-1-tools.md`, section "The C++ track measure, row E7"). So it misses `CCMShader`, `CHash`, `timing_c`, `CMiniHeap`, and the `std::map` types of `vm_local.h`, whose methods are inline in headers that stage 1 files include (`cm_shader.cpp:4-6`, `sv_game.cpp:28`, `sv_init.cpp:14`, `vm.cpp:17`). Proposed: the thirteen types of this docket are the list of the C++ track for stage 1. The skeleton's host run also writes a header class to `cxx_only.txt` when a stage 1 file includes its header under the WinDed defines and calls one of its methods or holds it by value, in the tools stage of T6.

### C2, where GP2 lives

The only stage 1 users of GP2 are `Com_ParseTextFile` and `Com_ParseTextFileDestroy` (`common.cpp:2179-2240`). Every caller of those is in the terrain, the renderer, or the RMG (`cm_terrain.cpp:48-109`, `tr_terrain.cpp:521-576`, `RM_Manager.cpp:152`, `RM_InstanceFile.cpp:81`, `RM_Mission.cpp:1368`, `RM_Terrain.cpp:69`), which row E5 links as C++ and which row T4 joins with the renderer. That C++ holds `CGenericParser2` by value and passes it by reference (`qcommon.h:822-824`, `RM_InstanceFile.h:24`), so a Swift GP2 cannot serve it. Proposed: `GenericParser2.cpp` and the three `Com_ParseTextFile` functions link as C++ with the terrain and the RMG, the 34 definitions stay skipped, and the Swift shape of the section above waits for the stage that ports the RMG. The alternative is a Swift GP2 in stage 1 with a C header for the linked C++, which needs a new bridge with no Raven counterpart.

### C3, the GP2 Swift shape when it ports

Raven walks groups through pointers: `GetParent`, `GetNext`, and casts such as `(CGPGroup *)items->GetNext()` (`GenericParser2.h:110-111`, `cm_terrain.cpp:105-107`). A Swift struct tree has no parent pointer. jka-rust uses an arena with a `GpGroupId` index and a borrow type (`gp2/gp_group.rs:6-41`), which adds types that Raven does not have. Proposed: `CGPGroup` and `CGenericParser2` become `final class` types with Raven's names, so `GetParent` and the sibling walk stay as Raven wrote them, and `CGPValue` becomes a struct with `[String]`. This row applies only if C2 ports GP2 to Swift.

### C4, `CCMShader` in a copied header

`cm_local.h` is in the T2 entry list (`dedicated-stage-1-tools.md:215` on the branch `dedicated-stage-2-tools`). It declares `class CCMShader` with `public:` and inline methods (`cm_local.h:77-89`), which a C target cannot import, and rule 12 does not let a copied header change. Proposed: the extract writes `CCMShader` into the C target as a struct with the four fields `shader`, `mNext`, `surfaceFlags`, and `contentFlags` in Raven's order, with the oracle's `sizeof` and `offsetof` in the layout asserts, as jka-rust does (`cm/ccmshader.rs:11-17`). `GetName` becomes a method on the imported struct. `GetNext`, `SetNext`, and `Destroy` stay as stubs with a `TODO: Port` marker under rule 20, because the `Dictionary` of C5 calls none of them.

### C5, the shader hash tables

`CHash` inserts at the head of a chain and finds the newest entry first (`chash.h:64-88`), so a `Dictionary` that overwrites gives the same lookup. `count()` is read once, as a test for zero (`cm_shader.cpp:491`). `CCMShaderText::Destroy` deletes the entry (`cm_shader.cpp:23`), and `CCMShader::Destroy` does nothing, because the record is in the hunk (`cm_local.h:88`, `cm_shader.cpp:510`). Proposed: `shaderTextTable` becomes `[String: Int]`, the offset of the block in `shaderText`, as jka-rust (`collision_world.rs:205-214`). `cmShaderTable` becomes `[String: Int]` too, the index of the record in `cm.shaders`, for a name that the BSP gives. A name that `CM_GetShaderInfo` makes with `Hunk_Alloc` (`cm_shader.cpp:510`) is not in `cm.shaders`, so this row also needs the ruling on the value for that case: a pointer to the hunk record, or a world array of the extra records.

### C6, the StringEd names and the map order

No Raven function walks `m_StringEntries` or `m_mapFlagMasks` in order. Each use is a `find` or a subscript (`stringed_ingame.cpp:443-463`, `:468`, `:743-747`, `:777`, `:988`, `:1023`). Proposed: `Dictionary` for both, not a sorted map as jka-rust chose (`stringed/package.rs:69-71`). The types keep Raven's names `CStringEdPackage` and `SE_Entry_t`, not jka-rust's `StringEdPackage` and `SeEntry`. The three function statics `str` (`:277`, `:393`, `:754`) become return values of `String`, by rule 7. The three undefined methods are not ported.

### C7, the timers and `FINAL_BUILD`

WinDed does not define `FINAL_BUILD` (`WinDed.vcproj:32`), and the client project does (`oracle/codemp/jk2mp.vcproj:32`). So in WinDed `G2_PERFORMANCE_ANALYSIS` is on (`q_shared.h:45-46`), and `Com_Frame` starts and ends the C++ global `G2PerformanceTimer_PreciseFrame` of the Ghoul2 renderer file (`common.cpp:1581-1598`, `:1767-1775`). jka-rust treats that path as off (`common_fns.rs:1288-1289`). The same define also gates the `shaders/test` load of `CM_LoadShaderFiles` (`cm_shader.cpp:75-132`). Proposed: the host follows the WinDed defines. `EngineWorld` holds its own `timing_c` for `Com_Frame`, and the C header of the linked Ghoul2 gives `G2Time_PreciseFrame`, `G2Time_ResetTimers`, and `G2Time_ReportTimers` as C symbols. The game timer of `CG_PRECISIONTIMER_START` becomes a heap `timing_c` whose address the module holds, freed at `END`, as Raven does. Both timers read a monotonic clock in place of `rdtsc`, by rule 19, because the `__asm` block is x86 and Windows alone (`timing.h:16-30`).

### C8, the VM symbol map

`vm_local.h:2-4` defines `CRAZY_SYMBOL_MAP` for every build but the Xbox, so `g_vmMap` and `g_symbolMap` are live in WinDed (`vm.cpp:20-21`, `:74-95`, `:117-137`). jka-rust says the macro is never defined and ports the scan alone (`vm_fns.rs:56-59`). The cache gives the same symbol as the scan, because it stores the scan's result (`vm.cpp:89-93`) or the loaded symbol for its own value (`vm.cpp:313-315`). Raven never removes the entry of a freed VM. Proposed: port the cache as a `Dictionary` on the world, faithful to Raven. A stale entry for a reused VM address is rule 19 behavior, and the port clears the VM's entry when the VM is freed, with a `Port-note:` at the site.

### C9, `CMiniHeap` as a handle

Stage 1 only stores and passes the `CMiniHeap` pointer (`sv_init.cpp:885`, `sv_world.cpp:668-748`, `sv_game.cpp:1450-1465`). The instance and every method call are in the Ghoul2 and renderer files that T4 links as C++ (`tr_init.cpp:30`, `G2_API.cpp:2074-2596`). Proposed: `G2VertSpaceServer` is an `OpaquePointer?` on `EngineWorld`, and the C header of the linked Ghoul2 gives the address of `CMiniHeap_singleton` as a C function. jka-rust's `#[repr(C)]` layout (`jka-rust/crates/native/types/src/miniheap/cmini_heap.rs:11-25`) is not needed while the class stays in C++.
## The ledger

The user delegated the rows on 2026-11-03 with the words "remember to prove the rows and auto rule. match existing codebase patterns in reference to the rows". A proving agent opened every citation, the coordinator read the failures and the sources below, and each ruling takes the form the game and cgame already use for the same shape.

- C1, ratified as proposed. The thirteen types are the list, and the skeleton's host run lists a header class too, in the T6 tools stage. The ten C++ declarations the stage 2 tools record found through the entry list (`traceWork_t`, `clipMap_t`, the six of `cm_landscape.h`, the two of `vm_local.h`) join the list.
- C2, ratified as proposed. GenericParser2 and the three `Com_ParseTextFile` functions link as C++ with the terrain and the RMG, as every E5 subsystem does.
- C3, ratified as proposed. The user said on 2026-11-03 "The RMG should port", so the RMG is a port stage under E5 and GenericParser2 ports with it. `CGPGroup` and `CGenericParser2` become `final class` types with Raven's names, and `CGPValue` becomes a struct over `[String]`.
- C4, ratified as amended. The extract writes `CCMShader` as a C struct with the layout asserts, as commit 1586b88 of the stage 2 tools pass did. `GetName` is a free function `CCMShader_GetName` over the imported struct, the form the game uses for every Raven function over a C record, not a method, because no logic target holds an extension over an imported type. The three unused methods take the rule 20 marker.
- C5, ratified as amended. Both tables become `[String: Int]`. The value of `shaderTextTable` is the offset of the block in `shaderText`, and the value of `cmShaderTable` is the hunk offset of the record, read through a view at that offset, as the views over engine memory do. A record that `CM_GetShaderInfo` makes with `Hunk_Alloc` takes the same form at `cm_shader.cpp:510`, so the sub-case needs no second storage.
- C6, ratified as proposed. `Dictionary` for both, Raven's names, the three statics become `String` return values by rule 7.
- C7, ratified as proposed. The host follows the WinDed defines, `EngineWorld` holds its `timing_c`, and the linked Ghoul2 gives the three timer symbols through its C header.
- C8, ratified as proposed. The cache is a `Dictionary` on the world, faithful to Raven, and the clear on a freed VM is rule 19 behavior with a `Port-note:` at the site, as rule 24 keeps for a rule 19 note.
- C9, ratified as proposed. `G2VertSpaceServer` is an `OpaquePointer?` on `EngineWorld`, the form `CGameWorld.g2WeaponInstances` already uses at `cg_local.swift:759`.
