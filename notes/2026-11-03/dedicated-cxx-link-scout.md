# The dedicated server C++ link scout

Row E5 links Raven's botlib, Ghoul2, NPCNav, ICARUS, ROFF, RMG, and terrain into `jampded` as C++ behind one C header each (`dedicated-opening-docket.md:29-33`). Row T4 adds the renderer files that WinDed compiles under `DEDICATED` and `png.cpp` (`dedicated-stage-1-tools.md:196`). Row C2 of the C++ docket adds `GenericParser2.cpp`. This scout compiles that set from Raven's source with Apple clang 21 on arm64 macOS, collects the engine symbols that the objects need, and probes the SwiftPM target shape. Every trial ran in `/tmp/jka-e5-scout/`. The oracle and both jka-rust trees are unchanged.

## 1. The link set and the Release configuration

The Release configuration is `oracle/codemp/WinDed.vcproj:15-79`. Its compiler defines are `WIN32,NDEBUG,_CONSOLE,DEDICATED,BOTLIB,_WINDOWS` (`WinDed.vcproj:32`). `FINAL_BUILD` is not defined, as row C7 says. The Debug configuration adds `_JK2` and swaps `NDEBUG` for `_DEBUG` (`WinDed.vcproj:91`). Neither configuration sets `AdditionalIncludeDirectories`, and no file has its own configuration or `ExcludedFromBuild`. So every include resolves relative to the including file or to the project folder `oracle/codemp`.

| Subsystem | Files | `WinDed.vcproj` lines |
|---|---|---|
| ROFF | `qcommon/RoffSystem.cpp` | 144 |
| Terrain | `qcommon/cm_randomterrain.cpp`, `qcommon/cm_terrain.cpp`, `qcommon/cm_draw.cpp` | 183, 192, 153 |
| GP2 (row C2) | `qcommon/genericparser2.cpp` | 228 |
| Ghoul2 | `ghoul2/G2_API.cpp`, `G2_bolts.cpp`, `G2_bones.cpp`, `G2_misc.cpp`, `G2_surfaces.cpp` | 304-322 |
| NPCNav | `server/NPCNav/gameCallbacks.cpp`, `navigator.cpp` | 365-368 |
| Renderer (row T4) | `renderer/matcomp.c`, `tr_backend.cpp`, `tr_ghoul2.cpp`, `tr_image.cpp`, `tr_init.cpp`, `tr_main.cpp`, `tr_mesh.cpp`, `tr_model.cpp`, `tr_shader.cpp` | 401-425 |
| png (row T4) | `png/png.cpp` | 431 |
| botlib | 28 files, `be_aas_*.cpp`, `be_ai_*.cpp`, `be_ea.cpp`, `be_interface.cpp`, `l_*.cpp` | 461-605 |
| ICARUS | `icarus/blockstream.cpp`, `gameinterface.cpp`, `instance.cpp`, `interface.cpp`, `memory.cpp`, `q3_interface.cpp`, `q3_registers.cpp`, `sequence.cpp`, `sequencer.cpp`, `taskmanager.cpp` | 736-787 |
| RMG | `rmg/rm_area.cpp`, `rm_instance.cpp`, `rm_instance_bsp.cpp`, `rm_instance_group.cpp`, `rm_instance_random.cpp`, `rm_instance_void.cpp`, `rm_instancefile.cpp`, `rm_manager.cpp`, `rm_mission.cpp`, `rm_objective.cpp`, `rm_path.cpp`, `rm_terrain.cpp` | 839-872 |

The set has 72 files: 71 C++ files and one C file, `matcomp.c`. Two facts sit at its edges. `cm_draw.cpp` holds `CDraw32`, and its only user is `cm_terrainmap.cpp`, which WinDed does not compile (WinDed names only `cm_terrainmap.h`, `WinDed.vcproj:195`). `png.cpp` includes `../zlib32/zip.h` (`png.cpp:8`) and calls Raven's own zlib, the three `zlib32` files of `WinDed.vcproj:879-894`, which row E5 does not name.

## 2. The compile trials

Each file compiled alone with `clang++ -c -Wno-everything -ferror-limit=0`, one folder per call, and the count is the number of `error:` lines. `matcomp.c` compiled as C (`-x c -std=c99`), as WinDed compiles a `.c` file. Four configurations ran.

- A, the literal brief: `-x c++ -std=c++17 -fdeclspec -fno-operator-names`, the six Release defines, and `-I oracle/codemp`.
- E: a scratch copy of `oracle/codemp` with two header edits, `SnapVector` set to Raven's own C macro (`q_shared.h:1403-1404`) and `timing.h` set to a monotonic clock. The flags add `-std=c++14`, `-fms-extensions`, `-fdelayed-template-parsing`, `-D_M_IX86`, a forced include that maps `stricmp` and `strnicmp` to `strcasecmp` and `strncasecmp`, and a stub `windows.h` that holds the typedefs of Raven's Linux branch of `qcommon/platform.h:13-21` and `POINT`.
- E+: E plus four more scratch edits, at `GameInterface.h:10-11`, `blockstream.cpp:333` and `:367`, `instance.cpp:60`, and `tr_main.cpp:10`.
- F: the unedited oracle with Raven's Linux branches. It drops `WIN32` and `_WINDOWS`, defines `__linux__`, and keeps the E flags other than `-D_M_IX86`.

OpenJK's copies compiled with OpenJK's dedicated defines (`openjk/codemp/CMakeLists.txt:631` for `_CONSOLE` and `DEDICATED`, `:56` for `BOTLIB`): `MACOS_X`, `_CONSOLE`, `DEDICATED`, and `BOTLIB`, plus `ARCH_STRING="arm64"` as a trial choice, because OpenJK sets `ARCH_STRING` only outside Windows and macOS (`openjk/CMakeLists.txt:213-214`). `FINAL_BUILD` stays off to match WinDed, although OpenJK sets it outside Debug (`openjk/CMakeLists.txt:323-324`). The include paths are `codemp`, `shared`, `lib/gsl-lite/include`, and a scratch `q_version.h` made from `shared/qcommon/q_version.h.in`.

### 2.1 Pass A per folder

| Folder | Files | Clean | Hard errors | Stop at `windows.h` |
|---|---|---|---|---|
| `qcommon` | 5 | 0 | 151 | 2 |
| `ghoul2` | 5 | 0 | 314 | 1 |
| `server/NPCNav` | 2 | 0 | 41 | 2 |
| `renderer` | 9 | 1 | 782 | 1 |
| `png` | 1 | 0 | 6 | 0 |
| `botlib` | 28 | 0 | 212 | 0 |
| `icarus` | 10 | 0 | 94 | 10 |
| `rmg` | 12 | 0 | 582 | 2 |
| Total | 72 | 1 | 2182 | 18 |

A missing `windows.h` is a fatal error, so the counts of those 18 files stop at that line. Of the 2182 errors, 1328 are `reference to 'byte' is ambiguous`, 426 are the `SnapVector` assembly (six in each C++ file), 70 are pointer to `int` casts, 32 are `stricmp` and `strnicmp`, and 24 are the ICARUS template lookup. Most of the remaining 302 follow from the first errors.

### 2.2 The causes

| Cause | Where | Files | What removes it in the trials |
|---|---|---|---|
| MSVC `__asm` in `SnapVector` | `game/q_shared.h:1403-1431` | all 71 C++ files | Raven's `__linux__` macro at `:1403-1404`, by `-D__linux__` or a source edit. `-fms-extensions` gives `unsupported architecture 'arm64' for MS-style inline assembly`. |
| `windows.h` | `qcommon/platform.h:9-11` under `_WINDOWS` | 18 | A stub header. The Windows names that follow are `LPCTSTR` (`icarus/tokenizer.h:86`), `POINT` (`qcommon/cm_draw.h:232`), `OutputDebugString` (`icarus/instance.cpp:61`), and `win32/glw_win.h`, which `tr_main.cpp:9-13` includes and which stops off `_WIN32` (`glw_win.h:2-4`). |
| `std::byte` against Raven's `byte` | `using namespace std` at `qcommon/cm_landscape.h:8`, under C++17 | 29: Ghoul2, renderer, RMG, terrain, and `navigator.cpp` | `-std=c++14`. |
| `stricmp`, `strnicmp` | for example `qcommon/genericparser2.cpp:670` | 11 | A forced include or a define. |
| Two-phase template lookup | `icarus/blockstream.h:80-95` calls `ICARUS_Free` and `ICARUS_Malloc`, declared later at `icarus/icarus.h:29-30` | 6 | `-fdelayed-template-parsing`. |
| Pointer to `int` casts | `qcommon/MiniHeap.h:42`, `ghoul2/G2_API.cpp:710` and 13 more sites, `G2_surfaces.cpp:80`, `G2_misc.cpp:300`, `tr_ghoul2.cpp:4942`, `:5479`, `tr_model.cpp:769`, `:901`, `be_ai_goal.cpp:121`, `be_ai_weap.cpp:40` | 8 | `-fms-extensions` makes them warnings. |
| Paths that WinDed never compiled | `#ifndef _M_IX86` at `tr_model.cpp:689`, `:751`, `:809`, `:938`, `:1434`, `:1504`, `:1584` and `tr_ghoul2.cpp:4825`, `:4980`, `:5266`, `:5461` name `mdxaFrame_t`, `mdxmTag_t`, and `mdxmVertex_t` fields that `renderer/mdx_format.h` does not declare | 2 | `-D_M_IX86`. MSVC on x86 defines `_M_IX86`, so WinDed compiled the other branch. With it, `id386` becomes 1 (`q_shared.h:125`), and no file of the set gained an error. |
| `__int64` and `rdtsc` assembly | `qcommon/timing.h:5-58` | `G2_API.cpp`, `tr_ghoul2.cpp` | A source edit. `-fms-extensions` accepts `__int64` but not the assembly. Raven guards the `End` assembly with `__linux__` (`timing.h:36`) and leaves the `Start` assembly unguarded (`:16`). |
| `std::map` with `allocator<int>` | `icarus/GameInterface.h:10-11` | `gameinterface.cpp`, `q3_interface.cpp` | A source edit. libc++ fails a `static_assert` on the allocator type. |
| `return false` from a pointer function | `icarus/blockstream.cpp:333`, `:367` | 1 | A source edit. |
| `static` after a non-static declaration | `CommaParse` at `renderer/tr_image.cpp:3193` | 1 | `-fms-extensions`. |
| `unsigned short (expr)` cast | `qcommon/cm_draw.cpp:553`, `:585` | 1 | A source edit. No trial removed it. |

Most pointer casts are the `offsetof` form `(int)&((T *)0)->field` or the difference of two truncated heap pointers (`MiniHeap.h:42`). Both stay correct on arm64. Six sites in `G2_API.cpp` test a reference for null with `(int)&ghoul2` (`:710`, `:1103`, `:1302`, `:1637`, `:1668`, `:2291`). On a 64-bit host that test drops the high half of the address.

### 2.3 The results per configuration

| Configuration | Clean of 72 | Files that fail |
|---|---|---|
| A | 1 | all but `matcomp.c` |
| E | 66 by the trial table, with no retained log; the retained `log/ravenE` of a later E run holds 69 clean | `cm_draw.cpp`, `tr_main.cpp`, `blockstream.cpp`, `gameinterface.cpp`, `instance.cpp`, `q3_interface.cpp` |
| E+ | 71 | `cm_draw.cpp` |
| F | 64 of the 71 C++ files, and F did not compile `matcomp.c` | `cm_draw.cpp`, `G2_API.cpp`, `tr_ghoul2.cpp`, `tr_model.cpp`, `blockstream.cpp`, `gameinterface.cpp`, `q3_interface.cpp` |
| OpenJK | 54 of the 54 files that have an OpenJK copy | none |

From Raven, one file compiles clean under the literal flags. With flags, a stub `windows.h`, and seven edit sites in six files (`q_shared.h`, `timing.h`, `GameInterface.h`, `blockstream.cpp` twice, `instance.cpp`, `tr_main.cpp`), 71 compile. From OpenJK, the 54 files that have a copy all compile, and so do the two files OpenJK adds to its dedicated link, `ghoul2/G2_gore.cpp` and `rd-dedicated/tr_skin.cpp` (`openjk/codemp/CMakeLists.txt:635`, `:651`). Eighteen files have no OpenJK copy: `cm_draw.cpp`, `cm_randomterrain.cpp`, `cm_terrain.cpp`, the 12 RMG files, `tr_image.cpp`, `png.cpp`, and `gameCallbacks.cpp`. So under the literal flags 18 files compile from neither tree, and under E+ one file does, `cm_draw.cpp`.

The OpenJK copies do not use Raven's engine API. A link of the 56 OpenJK objects leaves 96 undefined symbols, and their signatures differ from Raven's: `Cvar_Get(char const*, char const*, unsigned int, char const*)`, `COM_StripExtension(char const*, char*, int)`, `SkipBracedSection(char const**, int)`, `Z_Malloc(int, unsigned int, qboolean, int)`, and 25 `GVM_*` wrappers in place of `VM_Call`. OpenJK also gives the `q_math` functions C linkage, so their names are not mangled.

### 2.4 Per file

E is the count before the four extra edits, and E+ the count after them. F did not compile the C file.

| File | A errors | A stops at | First error in A outside `SnapVector` | E | E+ | F | OpenJK copy (errors) |
|---|---|---|---|---|---|---|---|
| `qcommon/RoffSystem.cpp` | 7 | `windows.h` |  | 0 | 0 | 0 | `qcommon/RoffSystem.cpp` (0) |
| `qcommon/cm_draw.cpp` | 22 | `windows.h` | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 7 | 2 | 7 | none |
| `qcommon/cm_randomterrain.cpp` | 52 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `qcommon/cm_terrain.cpp` | 63 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `qcommon/genericparser2.cpp` | 7 |  | `qcommon/genericparser2.cpp:670` use of undeclared identifier 'stricmp'; did you mean 'strcmp'? | 0 | 0 | 0 | `qcommon/GenericParser2.cpp` (0) |
| `ghoul2/G2_API.cpp` | 74 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 1 | `rd-dedicated/G2_API.cpp` (0) |
| `ghoul2/G2_bolts.cpp` | 46 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/G2_bolts.cpp` (0) |
| `ghoul2/G2_bones.cpp` | 82 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/G2_bones.cpp` (0) |
| `ghoul2/G2_misc.cpp` | 42 | `windows.h` | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/G2_misc.cpp` (0) |
| `ghoul2/G2_surfaces.cpp` | 70 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/G2_surfaces.cpp` (0) |
| `server/NPCNav/gameCallbacks.cpp` | 7 | `windows.h` |  | 0 | 0 | 0 | none |
| `server/NPCNav/navigator.cpp` | 34 | `windows.h` | `qcommon/qfiles.h:511` reference to 'byte' is ambiguous | 0 | 0 | 0 | `server/NPCNav/navigator.cpp` (0) |
| `renderer/tr_backend.cpp` | 39 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/tr_backend.cpp` (0) |
| `renderer/tr_ghoul2.cpp` | 203 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 29 | `rd-dedicated/tr_ghoul2.cpp` (0) |
| `renderer/tr_image.cpp` | 256 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `renderer/tr_init.cpp` | 47 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/tr_init.cpp` (0) |
| `renderer/tr_main.cpp` | 41 | `windows.h` | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 5 | 0 | 0 | `rd-dedicated/tr_main.cpp` (0) |
| `renderer/tr_mesh.cpp` | 39 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/tr_mesh.cpp` (0) |
| `renderer/tr_model.cpp` | 111 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 28 | `rd-dedicated/tr_model.cpp` (0) |
| `renderer/tr_shader.cpp` | 46 |  | `renderer/mdx_format.h:279` reference to 'byte' is ambiguous | 0 | 0 | 0 | `rd-dedicated/tr_shader.cpp` (0) |
| `png/png.cpp` | 6 |  |  | 0 | 0 | 0 | none |
| `icarus/blockstream.cpp` | 11 | `windows.h` | `icarus/blockstream.h:80` use of undeclared identifier 'ICARUS_Free' | 2 | 0 | 2 | `icarus/BlockStream.cpp` (0) |
| `icarus/gameinterface.cpp` | 7 | `windows.h` |  | 6 | 0 | 6 | `icarus/GameInterface.cpp` (0) |
| `icarus/instance.cpp` | 11 | `windows.h` | `icarus/blockstream.h:80` use of undeclared identifier 'ICARUS_Free' | 1 | 0 | 0 | `icarus/Instance.cpp` (0) |
| `icarus/interface.cpp` | 7 | `windows.h` |  | 0 | 0 | 0 | `icarus/Interface.cpp` (0) |
| `icarus/memory.cpp` | 11 | `windows.h` | `icarus/blockstream.h:80` use of undeclared identifier 'ICARUS_Free' | 0 | 0 | 0 | `icarus/Memory.cpp` (0) |
| `icarus/q3_interface.cpp` | 7 | `windows.h` |  | 3 | 0 | 3 | `icarus/Q3_Interface.cpp` (0) |
| `icarus/q3_registers.cpp` | 7 | `windows.h` |  | 0 | 0 | 0 | `icarus/Q3_Registers.cpp` (0) |
| `icarus/sequence.cpp` | 11 | `windows.h` | `icarus/blockstream.h:80` use of undeclared identifier 'ICARUS_Free' | 0 | 0 | 0 | `icarus/Sequence.cpp` (0) |
| `icarus/sequencer.cpp` | 11 | `windows.h` | `icarus/blockstream.h:80` use of undeclared identifier 'ICARUS_Free' | 0 | 0 | 0 | `icarus/Sequencer.cpp` (0) |
| `icarus/taskmanager.cpp` | 11 | `windows.h` | `icarus/blockstream.h:80` use of undeclared identifier 'ICARUS_Free' | 0 | 0 | 0 | `icarus/TaskManager.cpp` (0) |
| `rmg/rm_area.cpp` | 47 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_instance.cpp` | 47 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_instance_bsp.cpp` | 22 | `windows.h` | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_instance_group.cpp` | 47 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_instance_random.cpp` | 48 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_instance_void.cpp` | 47 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_instancefile.cpp` | 53 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_manager.cpp` | 48 | `windows.h` | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_mission.cpp` | 52 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_objective.cpp` | 47 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_path.cpp` | 49 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `rmg/rm_terrain.cpp` | 75 |  | `qcommon/cm_landscape.h:95` reference to 'byte' is ambiguous | 0 | 0 | 0 | none |
| `botlib/be_aas_bspq3.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_bspq3.cpp` (0) |
| `botlib/be_aas_cluster.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_cluster.cpp` (0) |
| `botlib/be_aas_debug.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_debug.cpp` (0) |
| `botlib/be_aas_entity.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_entity.cpp` (0) |
| `botlib/be_aas_file.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_file.cpp` (0) |
| `botlib/be_aas_main.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_main.cpp` (0) |
| `botlib/be_aas_move.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_move.cpp` (0) |
| `botlib/be_aas_optimize.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_optimize.cpp` (0) |
| `botlib/be_aas_reach.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_reach.cpp` (0) |
| `botlib/be_aas_route.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_route.cpp` (0) |
| `botlib/be_aas_routealt.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_routealt.cpp` (0) |
| `botlib/be_aas_sample.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_aas_sample.cpp` (0) |
| `botlib/be_ai_char.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_ai_char.cpp` (0) |
| `botlib/be_ai_chat.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_ai_chat.cpp` (0) |
| `botlib/be_ai_gen.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_ai_gen.cpp` (0) |
| `botlib/be_ai_goal.cpp` | 14 |  | `botlib/be_ai_goal.cpp:125` cast from pointer to smaller type 'int' loses information | 0 | 0 | 0 | `botlib/be_ai_goal.cpp` (0) |
| `botlib/be_ai_move.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_ai_move.cpp` (0) |
| `botlib/be_ai_weap.cpp` | 42 |  | `botlib/be_ai_weap.cpp:40` cast from pointer to smaller type 'int' loses information | 0 | 0 | 0 | `botlib/be_ai_weap.cpp` (0) |
| `botlib/be_ai_weight.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_ai_weight.cpp` (0) |
| `botlib/be_ea.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_ea.cpp` (0) |
| `botlib/be_interface.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/be_interface.cpp` (0) |
| `botlib/l_crc.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_crc.cpp` (0) |
| `botlib/l_libvar.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_libvar.cpp` (0) |
| `botlib/l_log.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_log.cpp` (0) |
| `botlib/l_memory.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_memory.cpp` (0) |
| `botlib/l_precomp.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_precomp.cpp` (0) |
| `botlib/l_script.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_script.cpp` (0) |
| `botlib/l_struct.cpp` | 6 |  |  | 0 | 0 | 0 | `botlib/l_struct.cpp` (0) |
| `renderer/matcomp.c` | 0 |  |  | 0 | 0 | n/a (C) | `qcommon/matcomp.cpp` (0) |

## 3. The host surface

The 71 objects of E+ linked with `clang++ *.o` against libSystem and libc++ alone. The linker reports 90 undefined symbols and no duplicate symbol. A shared-library link with `-undefined dynamic_lookup` succeeded. Of the 90, one is `main`, which the trial has no host for, and seven are Raven's `zlib32`, which only `png.cpp` calls. The other 82 are the engine surface that the Swift host gives to the linked C++: 71 functions and 11 data symbols.

| Declared in | Symbols | Data | Variadic | Names |
|---|---|---|---|---|
| `game/q_shared.h`, bodies in `q_shared.c` and `q_math.c` (through `qcommon/q_shared.cpp:4` and `q_math.cpp:4`) | 32 | 1 | 2 | `vec3_origin`, `AngleNormalize180`, `AngleNormalize360`, `AnglesToAxis`, `AngleVectors`, `AxisClear`, `Com_Clamp`, `Com_Clampi`, `COM_Compress`, `COM_ParseExt`, `Com_sprintf`, `COM_StripExtension`, `flrand`, `GetIDForString`, `Info_ValueForKey`, `irand`, `LongSwap`, `Q_fabs`, `Q_flrand`, `Q_irand`, `Q_stricmp`, `Q_stricmpn`, `Q_strlwr`, `Q_strncpyz`, `Q_strupr`, `SetPlaneSignbits`, `SkipBracedSection`, `SkipRestOfLine`, `va`, `vectoangles`, `VectorNormalize`, `VectorNormalize2` |
| `game/q_shared.h`, bodies in `common.cpp` and `z_memman_pc.cpp` | 5 | 0 | 2 | `Com_Error`, `Com_Memcpy`, `Com_Memset`, `Com_Printf`, `Hunk_Alloc` |
| `qcommon/qcommon.h` | 28 | 4 | 2 | `com_cl_running`, `com_dedicated`, `com_developer`, `com_timescale`, `Cmd_AddCommand`, `Cmd_RemoveCommand`, `Com_DPrintf`, `Com_ParseTextFile`, `Com_ParseTextFileDestroy`, `Com_TheHunkMarkHasBeenMade`, `Cvar_Get`, `Cvar_Set`, `Cvar_VariableIntegerValue`, `Cvar_VariableStringBuffer`, `FS_FCloseFile`, `FS_FileIsInPAK`, `FS_FOpenFileByMode`, `FS_FOpenFileWrite`, `FS_FreeFile`, `FS_Read`, `FS_ReadFile`, `FS_Write`, `Sys_LowPhysicalMemory`, `VM_Call`, `Z_Free`, `Z_Malloc`, `Z_MemSize`, `Z_MorphMallocTag` |
| `qcommon/cm_public.h` and `cm_local.h` | 5 | 1 | 0 | `cmg`, `CM_BoxTrace`, `CM_CalcExtents`, `CM_GetShaderInfo`, `CM_HandlePatchCollision` |
| `qcommon/vm_local.h` | 1 | 1 | 0 | `currentVM` |
| `server/server.h` | 10 | 4 | 1 | `gvm`, `sv`, `sv_pure`, `svs`, `SV_GentityNum`, `SV_GetConfigstring`, `SV_inPVS`, `SV_SendServerCommand`, `SV_SetConfigstring`, `SV_Trace` |
| `renderer/tr_local.h`, body in `null/null_renderer.cpp` | 1 | 0 | 0 | `R_SyncRenderThread` |
| Total engine | 82 | 11 | 7 | |
| `zlib32/zip.h`, Raven's zlib as C++ | 7 | 0 | 0 | `crc32`, `deflate`, `deflateEnd`, `deflateInit`, `inflate`, `inflateEnd`, `inflateInit` |

`Com_TheHunkMarkHasBeenMade` has no declaration in `qcommon.h`. `G2_API.cpp:568` and `tr_image.cpp:3299` declare it locally, and its body is in `z_memman_pc.cpp`.

| Subsystem | Objects | Undefined symbols it uses |
|---|---|---|
| botlib | 28 | 13 |
| Ghoul2 | 5 | 21 |
| NPCNav | 2 | 16 |
| Renderer | 9 | 38 |
| png | 1 | 16, seven of them `zlib32` |
| ICARUS | 10 | 22 |
| RMG | 12 | 25 |
| Terrain | 2 | 16 |
| ROFF | 1 | 10 |
| GP2 | 1 | 4 |

Four facts set the shape of the C header surface.

1. Every one of the 71 functions has C++ linkage. Raven's headers have one `extern "C"`, for `Sys_SnapVector` (`qcommon.h:981`), and that function is not in the list. So the object asks for `__Z10Com_MemcpyPvPKvm`, not `_Com_Memcpy`.
2. The 11 data symbols are not mangled, but the C++ reads them with Raven's layouts. `sv`, `svs`, and `gvm` are `server_t`, `serverStatic_t`, and `vm_t *` (`server.h:232-234`), `sv_pure` is a `cvar_t *` (`server.h:260`), `cmg` is a `clipMap_t` (`cm_local.h:220`), and `vec3_origin` is a `vec3_t` (`q_shared.h:1179`). The users are `rm_terrain.cpp` for `cmg`, `rm_instance_bsp.cpp` for `sv`, `navigator.cpp` and `RoffSystem.cpp` for `svs`, `G2_API.cpp`, `gameCallbacks.cpp`, `rm_instance_bsp.cpp`, and `RoffSystem.cpp` for `gvm`, and `G2_API.cpp` for `currentVM`.
3. Two functions take C++ types. `Com_ParseTextFile` takes `CGenericParser2 &` (`qcommon.h:822-824`), which row C2 covers. `CM_HandlePatchCollision` takes `trace_t &` and `CCMPatch *` (`cm_trace.cpp:914`), and the terrain calls it with `CM_CalcExtents` and `cmg`, so the terrain reads the collision model that the Swift host owns.
4. Seven functions are variadic: `Com_DPrintf`, `Com_Error`, `Com_Printf`, `Com_sprintf`, `va`, `VM_Call`, and `SV_SendServerCommand`.

A Swift probe exported a function under a C++ name: `@_cdecl("_Z10Com_MemcpyPvPKvm")` made `T __Z10Com_MemcpyPvPKvm` in the binary. `@_cdecl` cannot define a variadic function or a global variable, so those 18 symbols need C or C++ storage and bodies.

## 4. The SwiftPM target

`Package.swift` holds no C++ today. Its rule is that C targets hold Raven's copied headers and nothing else (`Package.swift:4-5`). `CJKASyscall` and `CJKAHost` are hand C with no Raven header (`:15-20`). `CJKAZlib` is a system library that links the system zlib (`:22-25`). `CJKAShared`, `CJKAMP`, `CJKAMP_Game`, and the other C targets hold copies that `merge.py` writes (`:27-40`), and `CJKAMP_Game` has an explicit module map, because the mirrored oracle folders sit beside its umbrella header (`Sources/CJKAMP_Game/include/module.modulemap:1-5`). `jampded` depends on `CJKAHost` and `JKAShared` (`Package.swift:64-65`). The `Package` call passes no `cxxLanguageStandard` (`:6-97`).

The one `unsafeFlags` is a linker flag, `--export-dynamic` on Linux, on the `CJKAHostTests` test target (`Package.swift:87-93`). A C++ target for this set needs `unsafeFlags` for the compiler, because `CXXSetting` has typed forms only for `define`, `headerSearchPath`, and a few others (`PackageDescription.swiftmodule/arm64-apple-macos.swiftinterface:43-47` in the Xcode toolchain), and `-fms-extensions`, `-fdelayed-template-parsing`, `-fdeclspec`, `-fno-operator-names`, and `-include` have no typed form. SwiftPM does not let a package that uses unsafe flags be a dependency that another package takes by version. This scout did not test that rule. The current flag is on a test target, which a dependent package does not build, and a compiler flag on a library target that `jampded` links is a different case. `cxxLanguageStandard` is a `Package` parameter, not a target parameter (`arm64-apple-macos.swiftinterface:350`), so it sets the standard of every C++ target in the package.

Two probes in `/tmp/jka-e5-scout/spm/` built the botlib. The `oracle` folder there is a link to the scratch copy of configuration E.

1. A target folder of 28 per-file links to the botlib sources plus one shim `.cpp`, with `.headerSearchPath("../../oracle/codemp/botlib")`, built all 29 objects. Raven's `#include "../game/q_shared.h"` resolves through that search path. The link stopped on 13 undefined symbols, the 13 of the botlib row above. SwiftPM refused a search path outside the package root with `invalid header search path '../../../rc/codemp/botlib'; header search path should not be outside the package root`. Per-file links are necessary in this form, because SwiftPM compiles every source under the target folder, and a link to a whole oracle folder brings every file of that folder.
2. A target with `path: "oracle/codemp"`, `sources:` set to the 28 files, and `publicHeadersPath: "botlib"` built the 28 objects with no link files. `publicHeadersPath` is relative to the target path, so a Swift-facing header in this form sits inside the oracle tree, which is read-only. The C header that Swift imports then needs its own target. Configuration A shows that the unedited oracle does not compile, so this form needs a tree that holds the edits.

The CI workflow does not fetch submodules. Its checkout steps pass no `submodules` input (`.github/workflows/build.yml:54` and the four others at `:79`, `:127`, `:172`, and `:220`), so no lane has `oracle/` or `openjk/`. The release lanes build only `jampgame` and `cgame` (`build.yml:89`, `:137`, `:182`, `:230`), but the Linux test lane runs `swift test --no-parallel` (`build.yml:67`), which builds every target, `jampded` and its dependencies included. On Linux the compiler defines `__linux__` itself, so Raven's Linux branches of section 2.2 turn on beside the WinDed defines. This scout did not compile the set on Linux. The Windows lanes (`build.yml:114-116`, `:207-209`) would compile the set with the real `windows.h`, and a Git checkout on Windows writes links as plain files unless `core.symlinks` is on. This scout did not test either Windows fact.

## Rows

### L1, the source tree of the linked C++

Configuration A shows that Raven's files do not compile unedited on this host, and configuration F shows that Raven's Linux branches leave seven failures. OpenJK's copies compile clean, but they cover 54 of 72 files, they lack the terrain, the RMG, `tr_image.cpp`, `png.cpp`, and `gameCallbacks.cpp`, and they call OpenJK's engine API, which has other signatures and the `GVM_*` wrappers (section 2.3). A Swift host that follows Raven cannot serve OpenJK objects without a second API. Proposed: the linked C++ is Raven's files, copied into the repo by a tool in the way `merge.py` copies headers, with the seven edit sites of section 2.3 applied to the copy and each site marked with the rule 24 line. The alternative is OpenJK's copies for the 54 files and Raven's for the other 18, with both engine APIs in the host.

### L2, the platform defines

WinDed defines `WIN32` and `_WINDOWS`, and on this host `_WINDOWS` pulls `windows.h` through `platform.h:9-11`. Raven wrote a Linux branch at `platform.h:13-21`, `q_shared.h:263` and `:1403`, `tr_main.cpp:10`, `instance.cpp:60`, and `timing.h:36`, and configuration F reaches it with `-D__linux__`, which tells the macOS SDK a false platform. Proposed: the target keeps the six WinDed defines on every platform, and on macOS and Linux a stub `windows.h` in the target holds the typedefs of Raven's own `platform.h:13-21` and nothing else. The Windows lane uses the real header. The alternative is `__linux__` on macOS and Linux, which needs no stub but still needs the `timing.h:16` edit, the `_M_IX86` branch, and the ICARUS edits. On the Linux lane the compiler defines `__linux__` in either case, so the macOS trial does not prove the Linux compile.

### L3, the compiler flags and the standard

The set compiles under `-std=c++14`. Under C++17, `using namespace std` at `cm_landscape.h:8` makes `byte` ambiguous in 29 files. Configuration E+ also needs `-fms-extensions` (the pointer casts and `tr_image.cpp:3193`), `-fdelayed-template-parsing` (`blockstream.h:80-95`), `-D_M_IX86` (section 2.2), and the `stricmp` mapping. All of them except `-D_M_IX86` are unsafe flags. Proposed: `cxxLanguageStandard: .cxx14` on the package, the four compiler flags as `unsafeFlags` on the C++ target alone, `-D_M_IX86` as a `define` because it reproduces the branch that MSVC compiled, and `stricmp` and `strnicmp` as `define` settings. The alternative is C++17 with an edit at `cm_landscape.h:8`.

### L4, the unsafe flags and a fork

A library target with compiler `unsafeFlags` keeps this package from being a version-based dependency of another package (section 4). The rule on the public surface keeps `vmMain`-level symbols public for a fork's mod target. Proposed: accept the flags, because a fork clones the repo and does not take it by version, and record the limit in the package comment. The alternative is to move every flag into source edits, which adds an edit at each pointer cast (70 errors in configuration A) and at the template order of `blockstream.h`.

### L5, `cm_draw.cpp`

`cm_draw.cpp` fails under every configuration, and WinDed links it with no caller, because its only user, `cm_terrainmap.cpp`, is not in the WinDed build (`WinDed.vcproj:195`). Proposed: leave `cm_draw.cpp` out of the link set, with a line in the set's record that names the reason. The alternative is two more edits at `cm_draw.cpp:553` and `:585` and a `POINT` typedef in the stub header.

### L6, Raven's zlib for `png.cpp`

`png.cpp` calls seven functions of Raven's `zlib32` with C++ linkage and Raven's own types, `EFlush` and `ELevel` (section 3). The package links the system zlib for the pak reader (`Package.swift:22-25`). Proposed: the three `zlib32` files of `WinDed.vcproj:879-894` join the linked C++ with `png.cpp`, because row T4 links `png.cpp` as Raven wrote it. The alternative is an edit of `png.cpp` onto the system zlib.

### L7, the C++ linkage of the engine surface

The linked C++ needs 71 functions under C++ names and 11 globals in Raven's layouts (section 3). Swift can put a function at a mangled name with `@_cdecl`, but not a variadic function or a global. Proposed: the copied engine headers that the linked C++ includes (`q_shared.h`, `qcommon.h`, `cm_public.h`, `cm_local.h`, `vm_local.h`, `server.h`, `tr_local.h`) wrap their declarations in `extern "C"` under `__cplusplus` in the copy. Then the C++ calls C names, the Swift host exports them with `@_cdecl`, and a C file in `CJKAHost` holds the seven variadic bodies, as it holds `VM_DllSyscall` today. The alternative is `@_cdecl` with mangled names, which needs no header edit, depends on the Itanium mangling, and still needs the C file for the variadic functions.

### L8, the globals that the linked C++ reads

`sv`, `svs`, `gvm`, `currentVM`, `cmg`, `sv_pure`, `com_dedicated`, `com_cl_running`, `com_developer`, `com_timescale`, and `vec3_origin` are read by the C++ at Raven's layouts. The Swift side keeps its world state in plain Swift globals, which have no C symbol name. Proposed: these 11 symbols are C storage in a C target, defined from the copied Raven headers, and the Swift engine reaches `sv`, `svs`, and `cmg` through view types on that storage, as the views of `JKAMP_Game` reach engine memory (`Package.swift:47`). The alternative is to remove the readers: `rm_instance_bsp.cpp`, `rm_terrain.cpp`, `navigator.cpp`, `RoffSystem.cpp`, `G2_API.cpp`, and `gameCallbacks.cpp` each get an edit to a C accessor, which is new code with no Raven counterpart.

### L9, the target shape and CI

The probes built a C++ target from per-file links and from `path:` with `sources:`. CI has no submodule today, so a target that reads `oracle/` fails in every lane. Proposed: one C++ target, `CJKAEngineCxx`, whose folder holds the copied and edited files of row L1, so CI needs no submodule and Windows needs no links, plus one C header target per subsystem for the Swift side, as row E5 says. The alternative is one C++ target per subsystem, which gives each later stage one target to delete, and which needs the shared headers in every target.

### L10, the null tests on a reference

`G2_API.cpp` tests `(int)&ghoul2` six times (section 2.2). On arm64 the cast drops the high half, so an address whose low 32 bits are zero reads as null. Proposed: keep Raven's text under `-fms-extensions`, because a heap address with a zero low half does not occur in practice, and list the six sites for the Ghoul2 stage. The alternative is an edit of the six sites to a pointer compare.

## The ledger

The user delegated the rows on 2026-11-03 with the words "rule them automatically after proving them and making sure patterns match". A proving agent opened about 120 citations and counts, and the coordinator fixed five cites and two counts in this note before the ruling. The conclusion stands on the verified counts: one file in 72 compiles unedited, and the link leaves 90 undefined symbols.

- The ruling on the set: row E5 of `dedicated-opening-docket.md` is amended, and the C++ link set is out. The codebase holds no edited copy of Raven's C++, no unsafe compiler flag on a library target, no changed copied header (rule 12), and no server state outside the world (row E4). The game first stood on `portMissing` stubs, and the host's unported subsystem arms take the same form.
- L1, L2, L3, L4, L6, L7, L8, L9: closed by the E5 amendment. No source copy, no platform stub, no flags, no header wrapper, no C storage, no C++ target.
- L5, `cm_draw.cpp`: closed with them, and the fact that WinDed links it with no caller goes to the terrain stage's docket.
- L10, the six null tests on a reference in `G2_API.cpp`: open for the Ghoul2 stage's docket, where the port reads the six sites under rule 19.
