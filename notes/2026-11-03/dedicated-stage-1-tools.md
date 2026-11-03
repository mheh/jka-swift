# The dedicated server stage 1, the tools half: the unit glob, the host kind, the manifest, and one generator sequence

This record holds the tools stage that opens the port of the MP dedicated server, rows E6, E7, E8, and E11 of `notes/2026-11-03/dedicated-opening-docket.md`. The tree is the worktree `/tmp/jka-ded` on the branch `dedicated-stage-1-tools`, off master at d19ede5. The change is in the working tree and has no commit. No file under `Sources/` changed. The host unit has no logic target under `Sources/`, so every file of its run is under `tools/oracle-closure/out/mp-engine-ded/`, which git does not track.

## The unit glob, row E8

`srcglob` of `[units.mp-engine-ded]` in `tools/oracle-closure/project.toml` is now Raven's WinDed Release link set, file by file, from `oracle/codemp/WinDed.vcproj:138-894`. The project file excludes no file from the Release build, so the link set is every `.c` and `.cpp` file the project names. The list keeps `vm.cpp` and `vm_interpreted.cpp` and leaves `vm_x86.cpp` out, by row E13 as amended. `server/NPCNav/navigator.cpp` and `gameCallbacks.cpp` are in. The 14 files that WinDed does not compile are out: twelve of `codemp/qcommon` and `Interpreter.cpp` and `Tokenizer.cpp` of `codemp/icarus`. The null, win32, png, and zlib32 files are in, because WinDed links them.

The `[units]` row has no field for a port stage, so comments in the list give the rows. The list puts the stage 1 files first: qcommon, server, null, and win32. Then three groups follow, each under its comment:

- The renderer files and `png.cpp`, which row E5 does not name.
- The three zlib32 files, which row E14 does not port.
- The files of row E5 that a later stage ports: `RoffSystem.cpp`, the terrain files `cm_draw.cpp`, `cm_randomterrain.cpp`, and `cm_terrain.cpp`, then Ghoul2, NPCNav, the botlib, ICARUS, and the RMG.

The `deferred` key of the host row in `[targets]` names the same groups, so the skeleton writes no stub for them. `cm_draw.cpp` serves `cm_terrainmap.cpp` alone, so it stands with the terrain.

| Count | Before E8 | After E8 |
|---|---:|---:|
| Files in the unit | 117 | 116 |
| Unity parse errors | 1313 | 1317 |
| Redefinition errors among them | 1051 | 1051 |
| Files the skeleton reads, stage 1 | | 42, 40 with a definition |
| Parse errors inside those 42 files | | 3, all in `null_glimp.cpp`, the unknown type `GLenum` |

The 1051 redefinitions are the same before and after. 1019 of them are in botlib headers and 32 are in `codemp/ghoul2/G2_local.h`. Each of these headers has no include guard, and the unity source includes it once per file of its folder. The largest are `codemp/botlib/aasfile.h` with 228, `codemp/game/be_aas.h` with 209, `codemp/game/botlib.h` with 182, and `codemp/botlib/be_aas_def.h` with 144. The four new errors are three of `GLenum` in `null_glimp.cpp` and one more `std::map` iterator error of `icarus/GameInterface.cpp`.

## The host kind, row E6

A `[targets]` row takes the key `kind`. A row with no such key is a module. A `host` row names no trap file and no shell. The new row:

| Key | Value |
|---|---|
| `kind` | `host` |
| `other` | `mp-game` |
| `folder` | `codemp/server` |
| `logic`, `views`, `c_target`, `state` | `JKAMP_DedLogic`, `JKAMP_Ded`, `CJKAMP_Ded`, `Engine` |
| `rust` | `engine/qcommon`, `engine/server`, `engine/core` |
| `store` | `tools/oracle-closure/out/mp-engine-ded/table.sqlite` |
| `deferred` | the renderer, png, zlib32, ROFF, terrain, Ghoul2, NPCNav, botlib, ICARUS, and RMG files |

A host has no single folder. `closure.py` reads every file of the unit's `srcglob` less the files of `deferred`, and each file outside `folder` stands as a borrowed file of the unit. So `within` and `folder_of` serve the host with no change. `file_name(stem)` gives the file name with its suffix, `.cpp` for a host file and `.c` for every module file.

The changed scripts and lines:

| Script | Lines | Change |
|---|---|---|
| `closure.py` | 336-371, 410-411 | `HOST`, `host_files`, the host files as borrowed files, `SUFFIXES`, `file_name`. `Parse` reads the C target of a staged unit under `out/<unit>/Sources`. |
| `reexport.py` | 68-73 | `parse` takes a root, `Sources/` by default. |
| `merge.py` | 49-52, 64, 791-793 | `mp-engine-ded` maps to `CJKAMP_Ded`, and `CJKAMP_Ded` reaches `CJKAMP` and `CJKAShared`. The default `--mp` list is unchanged. The report leaves out a target with no file. |
| `check.sh` | 10 | The target list has `CJKAMP_Ded`. |
| `rulings.py` | 198-201 | `HOST_ROOTS`, an empty table, and its row in `ROOTS`. |
| `skeleton.py` | 59-90, 127, 179, 212-227, 289-292, 316-354, 395, 464, 1144, 1263-1266, 1385-1403, 1432-1447, 1473, 1503, 1584, 1604-1610 | `SKIP` is empty for a host. `CXX_KINDS`, `CXX_RECORDS`, and `header_line`. The cites, the source reader, the signature rows, and the stub header take `file_name`. `RustIndex` reads a list of crates. `collect` counts the skipped C++ definitions through `skip_cxx`. The stubs of a host do not import `JKAMP_BG`. A host run writes `cxx_only.txt`. The report prints the skipped definitions per file. |
| `table.py` | 903-905 | `adopted` reads `header_line`. |
| `adopt.py` | 29, 58 | The same. |
| `align.py` | 146-149 | The same. |
| `manifest.py` | 28, 62, 64, 116 | The manifest header names the file with its suffix. |
| `tests/test_project.py` | 5, 22-33, 68-70 | The engine glob is the WinDed list less `vm_x86.cpp`, read from the vcproj. |
| `tests/test_unit.py` | 104-123 | The re-export tables name `CJKAMP_Ded`, and one new test reads the host row. |

`header_line(stem)` gives the first line of a stub. For a module it is `NOTE.format(stem=stem)`, the same bytes as before, so the adoption salt of `table.py:1974` keeps the same `NOTE` text.

## The manifest, row E11

The `rust` key of the host row is a list. `RustIndex` of `skeleton.py` reads each crate of the list under `jka-rust/crates/mp`, then `bg` and `qshared` as before. A module row keeps a single crate.

`manifest.py --unit mp-engine-ded` writes 40 manifests with 1087 rows: 830 function rows and 257 variable rows. 648 functions have a jka-rust match: 496 in `engine/qcommon`, 151 in `engine/server`, and 1 in `qshared`. `engine/core` gives no match. 182 functions have none. The manifests are under `out/mp-engine-ded/.claude/manifest/mp-engine-ded/`.

## The generator sequence

Each step ran in the worktree as one call, in this order. The wall time is `/usr/bin/time -p` real.

| Step | Command | Wall time | Result |
|---|---|---:|---|
| 1 | `closure.py --list-modules` | 0.10 s | The engine unit lists with its entry `codemp/qcommon/qcommon.h`. |
| 2 | `extract.py mp-engine-ded` | 3.68 s | 154 files, 918 layout asserts per triple, 10 triples. `cxx_only.txt` is empty. |
| 3 | `clang -fsyntax-only ... out/extract/mp-engine-ded/layout_asserts.h` | 0.27 s | exit 0. |
| 4 | `merge.py --mp mp-game mp-bg mp-cgame mp-ui mp-engine-ded --out out/mp-engine-ded/Sources` | 0.66 s | `CJKAMP_Ded` holds 17 types, 1 constants file, 57 asserts per ABI, 3 ABIs. |
| 5 | `tables.py` | 0.05 s | It takes no unit. It wrote the same bytes, and git shows no change. |
| 6 | `check.sh out/mp-engine-ded/Sources` | 3.52 s | Every target compiles on every triple, 0 errors. `CJKAMP_Ded` has 171 asserts. |
| 7 | `reexport.py` | not run | `reexport.py:381` takes only a target whose view target is under `Sources/`, so the host target is out of its reach. |
| 8 | `views.py --unit mp-engine-ded` | 20.85 s | 0 files, 0 views. The host has no view root. |
| 9 | `skeleton.py --unit mp-engine-ded` | 18.27 s | 40 files, 484 mapped stubs, 346 `TODO: Port signature` markers, 0 thunks. A second run took 37.29 s and wrote the same bytes. |
| 10 | `traps.py --unit mp-engine-ded` | 0.16 s | It stops at `traps.py:49`, `KeyError: 'traps'`. A host has no trap file. |
| 11 | `manifest.py --unit mp-engine-ded` | 33.35 s | 40 manifests, 830 functions, 648 with a jka-rust match. |
| 12 | `channel.py --unit mp-engine-ded` | 5.87 s | It stops at `channel.py:474`, `KeyError: 'traps'`. A host has no bg channel. |
| 13 | `bodies.py --unit mp-engine-ded --stem sv_init` | 31.94 s | It stops at `bodies.py:231`, which opens `oracle/codemp/server/sv_init.c`. |

The merge of step 4 needs the hand C files of the package beside its output. A first merge into an empty folder failed in `check.sh` on every MP target with `'bg_tables.h' file not found`. Then the five hand files of `HAND_FILES` were copied from `Sources/` into the staged folder, and the merge ran again. The default merge, `merge.py` with no argument, writes the same bytes and prints the same report as the `merge.py` of master.

The extract of step 2 differs from the extract cache that the worktree took over. The differences are in `all.h`, `q_shared/constants.h`, `extract.json`, and `layout_asserts.h`. The entry of the unit is unchanged, so the cache was older than the extractor of master.

## The skeleton counts

The skeleton reads 42 files: 25 of qcommon, 9 of server, 6 of null, and 2 of win32. `q_math.cpp` and `q_shared.cpp` hold only an include of the game's `.c` file, which `JKAShared` holds already, so they give no stub. The table counts each file. "Markers" are the `TODO: Port signature` markers of the functions. The variable kinds are the kinds of the skeleton: `let` for a constant, `state` for a stored property of `EngineVariables`, `state_data` for a table by hand, and `marker` for a variable with no table row.

| File | Functions | Mapped | Markers | Static | Variables | Variable kinds | Macros | Skipped C++ |
|---|---:|---:|---:|---:|---:|---|---:|---|
| `cm_load.cpp` | 37 | 18 | 19 | 1 | 18 | 9 marker, 9 state | 6 | |
| `cm_patch.cpp` | 27 | 12 | 15 | 22 | 10, 7 static | 2 let, 4 marker, 4 state | 3 | |
| `cm_polylib.cpp` | 17 | 0 | 17 | 0 | 5 | 5 state | 1 | |
| `cm_shader.cpp` | 13 | 7 | 6 | 2 | 5 | 2 let, 1 marker, 1 state, 1 state_data | 1 | 5 methods, 1 constructor, 1 destructor |
| `cm_test.cpp` | 15 | 6 | 9 | 0 | 0 | | 0 | |
| `cm_trace.cpp` | 31 | 7 | 24 | 0 | 0 | | 2 | |
| `cmd_common.cpp` | 17 | 17 | 0 | 0 | 6, 3 static | 2 let, 1 marker, 3 state | 2 | |
| `cmd_pc.cpp` | 5 | 5 | 0 | 0 | 1, 1 static | 1 marker | 0 | |
| `common.cpp` | 42 | 34 | 8 | 3 | 49, 6 static | 4 let, 29 marker, 16 state | 4 | |
| `cvar.cpp` | 34 | 28 | 6 | 5 | 8, 3 static | 4 marker, 4 state | 2 | |
| `files_common.cpp` | 12 | 12 | 0 | 0 | 27 | 11 marker, 16 state | 1 | |
| `files_pc.cpp` | 69 | 60 | 9 | 10 | 2, 2 static | 1 let, 1 state | 2 | |
| `GenericParser2.cpp` | 28 | 6 | 22 | 1 | 1, 1 static | 1 state | 1 | 25 methods, 5 constructors, 4 destructors |
| `huffman.cpp` | 18 | 0 | 18 | 8 | 1, 1 static | 1 state | 0 | |
| `md4.cpp` | 8 | 2 | 6 | 3 | 1, 1 static | 1 state_data | 12 | |
| `msg.cpp` | 48 | 4 | 44 | 0 | 15, 5 static | 2 let, 9 marker, 4 state | 13 | |
| `net_chan.cpp` | 15 | 1 | 14 | 0 | 6, 1 static | 5 marker, 1 state_data | 5 | |
| `null_client.cpp` | 19 | 18 | 1 | 0 | 2 | 1 let, 1 marker | 0 | |
| `null_glimp.cpp` | 7 | 7 | 0 | 0 | 6 | 6 marker | 0 | |
| `null_input.cpp` | 4 | 4 | 0 | 0 | 0 | | 0 | |
| `null_renderer.cpp` | 5 | 5 | 0 | 0 | 0 | | 0 | |
| `null_snddma.cpp` | 10 | 10 | 0 | 0 | 1 | 1 let | 0 | |
| `stringed_ingame.cpp` | 20 | 19 | 1 | 3 | 5 | 1 let, 4 marker | 0 | 18 methods, 2 constructors, 1 destructor |
| `stringed_interface.cpp` | 4 | 0 | 4 | 1 | 1 | 1 state | 0 | |
| `sv_bot.cpp` | 34 | 28 | 6 | 2 | 5, 3 static | 2 marker, 3 state | 0 | |
| `sv_ccmds.cpp` | 19 | 16 | 3 | 14 | 1, 1 static | 1 state_data | 0 | |
| `sv_client.cpp` | 24 | 0 | 24 | 7 | 1, 1 static | 1 marker | 2 | |
| `sv_game.cpp` | 27 | 16 | 11 | 2 | 3 | 3 marker | 0 | |
| `sv_init.cpp` | 17 | 17 | 0 | 0 | 0 | | 0 | |
| `sv_main.cpp` | 18 | 9 | 9 | 1 | 29, 1 static | 28 marker, 1 state | 4 | |
| `sv_net_chan.cpp` | 5 | 0 | 5 | 2 | 0 | | 0 | |
| `sv_snapshot.cpp` | 11 | 2 | 9 | 7 | 1 | 1 state | 2 | |
| `sv_world.cpp` | 13 | 5 | 8 | 2 | 2 | 1 marker, 1 state | 3 | |
| `unzip.cpp` | 25 | 15 | 10 | 7 | 0 | | 12 | |
| `vm.cpp` | 25 | 11 | 14 | 1 | 6 | 4 marker, 2 state | 4 | |
| `vm_interpreted.cpp` | 4 | 0 | 4 | 0 | 1, 1 static | 1 state_data | 4 | |
| `win_main.cpp` | 39 | 33 | 6 | 2 | 10, 7 static | 3 let, 2 marker, 5 state | 11 | |
| `win_net.cpp` | 21 | 14 | 7 | 1 | 20, 19 static | 3 let, 9 marker, 8 state | 1 | |
| `win_shared.cpp` | 15 | 14 | 1 | 6 | 0 | | 2 | |
| `z_memman_pc.cpp` | 28 | 22 | 6 | 4 | 8, 2 static | 5 marker, 2 state, 1 state_data | 1 | |
| Total | 830 | 484 | 346 | 117 | 257, 66 static | 22 let, 140 marker, 89 state, 6 state_data | 101 | 48 methods, 8 constructors, 6 destructors |

The 346 markers have two reasons. 284 are "No table row" for a parameter and 62 for a return. The parameter types with the most markers are `msg_t *` with 41, `client_t *` with 31, `traceWork_t *` with 19, `vm_t *` with 13, `winding_t *` with 12, `void *` with 12, `lump_t *` with 11, `bool` with 9, `TGPGroup` with 9, and `netadr_t` by value with 9. Of the 140 variable markers, 81 are `cvar_t *`.

The skeleton prints `variables: 44 let, 178 state, 12 data by hand, 1 initializers by hand, 0 storage, 0 data tables from tables.py, 280 markers`. These counts are twice the counts of the table, because the run counts a variable each time it prints the variable's entry, once in the stub and once in the signature row.

## The C++ track measure, row E7

The skeleton skips each C++ definition of a stage 1 file and counts it per file. Three files hold such definitions, 62 in total: `GenericParser2.cpp` 34, `stringed_ingame.cpp` 21, and `cm_shader.cpp` 7. No qcommon, server, null, or win32 file of stage 1 holds another method, constructor, destructor, or function template.

The header parse of the unit reads `codemp/qcommon/qcommon.h` alone, so the `cxx_only.txt` of `extract.py` is empty. The host run of the skeleton writes `out/mp-engine-ded/cxx_only.txt` in the same form, one line per class that owns a skipped definition. It holds eight classes:

- `oracle/codemp/qcommon/GenericParser2.h:24 class CTextPool`
- `oracle/codemp/qcommon/GenericParser2.h:45 class CGPObject`
- `oracle/codemp/qcommon/GenericParser2.h:68 class CGPValue`
- `oracle/codemp/qcommon/GenericParser2.h:93 class CGPGroup`
- `oracle/codemp/qcommon/GenericParser2.h:136 class CGenericParser2`
- `oracle/codemp/qcommon/cm_shader.cpp:8 class CCMShaderText`
- `oracle/codemp/qcommon/stringed_ingame.cpp:48 struct SE_Entry_s`
- `oracle/codemp/qcommon/stringed_ingame.cpp:64 class CStringEdPackage`

The list holds the classes with a method. It does not hold the types that hold one of these classes by value, which rule 17 also names.

## The snapshot

`snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared` read 372 files and found one difference, in `traps/g_syscalls.swift`. The cache spells `trap_G2API_HasGhoul2ModelOnIndex` with `_ ghlInfo: OpaquePointer?`, and the tools spell it with `inout OpaquePointer?` and `withUnsafeMutablePointer`. The tools of master give the same difference: a snapshot of master, made with the tool changes stashed, differs from the cache in this one function alone. The cache is older than commit a90f5a1, "The ghoul2 index test takes the handle's address".

So the gate compares with the snapshot of master:

| Unit | Command | Files | Result | Wall time |
|---|---|---:|---|---:|
| `mp-game` | `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared` | 372 | 1 difference, the same as master | 271.77 s |
| `mp-game` | `snapshot.py --out` on master | 372 | | 227.03 s |
| `mp-game` | `snapshot.py --check` against the master snapshot | 372 | no difference | 180.25 s |
| `mp-cgame` | the snapshot texts less channel, on master | 246 | | 51.75 s |
| `mp-cgame` | the same, with the changes, and `diff -r` | 246 | no difference | 94.94 s |

`snapshot.py` takes no `--unit`. A copy with `--unit` stopped on the cgame at master in `channel.py:235`, `KeyError: 'G_NewString'`, in `collect_callbacks`. So the cgame comparison used a script outside the repository with the text of `snapshot.write` less the three channel files: the skeleton and the manifest per stem, `traps.py`, `views.py`, and `bodies.py` per stem of the cgame logic target.

## The tests

| Check | Result | Wall time |
|---|---|---:|
| `.venv/bin/python3 -m unittest discover -s tests` | 97 tests, OK, 14 skipped | 1.81 s |
| `SLOW=1 .venv/bin/python3 -m unittest discover -s tests` | 97 tests, OK | 178.69 s |
| `swift build` | Build complete, 0 errors | 47.77 s |
| `swift test --no-parallel` | 117 tests in six runs, 1, 1, 84, 13, 3, and 15, all passed | 6.52 s |

The first run of the tool tests failed in `tests/test_unit.py:104`, because the re-export tables pin every unit's C target and the host is a new unit. The test now names `CJKAMP_Ded`.

## Rows

E8 said that the 14 extra files gave the 1051 redefinitions. They do not. The count is 1051 before and after the change, and every redefinition is in a header with no include guard that the unity source of `closure.py:181-192` includes once per file of its folder: 1019 in the botlib headers, `codemp/botlib/aasfile.h` and `codemp/game/botlib.h` first, and 32 in `codemp/ghoul2/G2_local.h`. The stage 1 files hold 3 parse errors, all of `GLenum` in `oracle/codemp/null/null_glimp.cpp`. The proposal is to leave the count as it is for stage 1, and to give each later subsystem its own unity parse when its stage opens, as `[units.mp-botlib]` and `[units.mp-ghoul2]` already exist.

The header parse of the unit reads `codemp/qcommon/qcommon.h` alone (`tools/oracle-closure/project.toml:347`), so `CJKAMP_Ded` holds 17 types and none of `server.h`, `vm_local.h`, or `cm_local.h`. The skeleton then gives `serverStatic_t`, `server_t`, `clipMap_t`, and `sysEvent_t` the reason "a struct Raven defines inside a .c file", which is wrong for these headers. A trial with no `entry` key, which derives the list from the glob, stopped in `extract.py` with `source_t has 2 layouts across the ilp32 triples`, because the botlib's `source_t` of `l_precomp.h` meets another. The proposal is a hand entry list for the host in the shape of `[units.mp-engine]` (`project.toml:516-540`): `qcommon.h`, `qfiles.h`, `cm_local.h`, `cm_patch.h`, `files.h`, `vm_local.h`, `server.h`, and the null and win32 headers, with no botlib header.

The engine module is not in the default list of `merge.py:44`, so the default merge writes the same bytes as master. A merge that names the engine changes the committed targets: `CJKAMP_platform.h` and the platform header of every MP target gain the 16 Windows spellings of the engine's defines, `CJKAMP_forward.h` gains `node_t` and `struct vm_s`, and `CJKAShared` gains `shared/qcommon/qcommon/constants.h`. The proposal is that the engine joins the default list only when `CJKAMP_Ded` lands under `Sources/`, and that the platform spellings of the engine stay in `CJKAMP_Ded_platform.h` alone.

Row E5 does not name the renderer files and `png.cpp` of `oracle/codemp/WinDed.vcproj:400-430`, which WinDed compiles under `DEDICATED` for the server side of the model and Ghoul2 loading. This stage puts them in `deferred` (`project.toml:81`) with the later stages, and the skeleton writes no stub for them. The proposal is that the renderer files link as C++ with Ghoul2 under row E5, because `tr_ghoul2.cpp` and `tr_model.cpp` serve the 48 Ghoul2 arms, and that `png.cpp` links with them.

The host has no view root (`tools/oracle-closure/rulings.py:199`), so `views.py --unit mp-engine-ded` writes 0 views and the stubs and the state files name no view. Row E4 names `sharedEntity_t`, `playerState_t`, and "the other module records the host reads". The proposal is a first `HOST_ROOTS` of `serverStatic_t`, `server_t`, `client_t`, `sharedEntity_t`, `playerState_t`, `msg_t`, `vm_t`, and `cvar_t`, in `CJKAMP_Ded` and `CJKAMP`, after the entry list of the second row. `msg_t *`, `client_t *`, and `vm_t *` give 85 of the 346 signature markers, and `cvar_t *` and `vm_t *` give 84 of the 140 variable markers.

The sweeps of the table read `.c` files alone, for example `tools/oracle-closure/table.py:666`, `:692`, `:749`, `:813`, `:1148`, `:1202`, `:1708`, `:1739`, `:1809`, and `:1850`. So the NULL, write, and local facts of every host function are empty, and the skeleton maps the host signatures with no caller facts. The drafter opens `<stem>.c` at `tools/oracle-closure/bodies.py:231`, so it stops on a host stem. The proposal is that the sweeps and the drafter test a file with `path.name == C.file_name(path.stem)`, as `skeleton.py` now does, in a stage of its own with a snapshot gate, before the first host hole round.

`traps.py:49` and `channel.py:474` stop on a host with `KeyError: 'traps'`. A host has no trap table and no bg channel, so neither step has work for it. The proposal is one line in each script that names the host kind and exits 0, so a sequence over a host runs to its end.

The snapshot cache `~/.cache/jka-swift/snapshot-stage-two-shared` is older than master. It differs from the tools of master in `trap_G2API_HasGhoul2ModelOnIndex`, commit a90f5a1. `snapshot.py` takes no `--unit`, and a snapshot of the cgame stops at `channel.py:235` with `KeyError: 'G_NewString'`. The proposal is to refresh the cache in place from master, and to give `snapshot.py` a `--unit` that skips the channel texts of a unit with no bg channel of its own.

The skeleton's variable line counts each variable twice, because `variable_entry` adds to the counts (`tools/oracle-closure/skeleton.py:844`) and the run calls it for the stub and again for the signature row. The host run prints 280 markers for 140 variables. The game and cgame lines carry the same double count. The proposal is that `variable_entry` counts only when the stub writer calls it.

The `cxx_only.txt` of the host lists the eight classes that own a method and not the types that hold one of them by value, which rule 17 names (`docs/porting-rules.md:42`). The C++ docket of row E7 needs that second half before the first transcription round. The proposal is that the C++ docket reads the class list of this record and finds the holders by value from the hand entry list of the second row, through `extract.py`, which marks a declaration that depends on a C++ type (`tools/oracle-closure/extract.py:1098`).

## The ledger

The user delegated the ten rows to the coordinator on 2026-11-03 with the words "run agents in parallel as much as possible to work toward the dedicated executable running". The rows take the numbers T1 to T10 in the order of the section above.

- T1, the redefinitions: ratified as proposed. The count stands for stage 1, and each later subsystem gets its own unity parse when its stage opens.
- T2, the host entry list: ratified as proposed. A hand entry list in the shape of `[units.mp-engine]`, with `qcommon.h`, `qfiles.h`, `cm_local.h`, `cm_patch.h`, `files.h`, `vm_local.h`, `server.h`, and the null and win32 headers, and no botlib header.
- T3, the engine in the default merge: ratified as proposed. The engine joins the default list when `CJKAMP_Ded` lands under `Sources/`, and its platform spellings stay in `CJKAMP_Ded_platform.h`.
- T4, the renderer files and `png.cpp`: ratified as proposed. They link as C++ with Ghoul2 under row E5.
- T5, the host view roots: ratified as proposed. `HOST_ROOTS` of `serverStatic_t`, `server_t`, `client_t`, `sharedEntity_t`, `playerState_t`, `msg_t`, `vm_t`, and `cvar_t`, after the entry list of T2.
- T6, the sweeps and the drafter on a host stem: ratified as proposed. The sweeps and the drafter test the file name through the unit's kind, in a stage of its own with a snapshot gate, before the first host hole round.
- T7, the traps and channel steps on a host: ratified as proposed. One line in each script names the host kind and exits 0.
- T8, the snapshot cache and `--unit`: ratified as proposed. The cache refreshes in place from master, and `snapshot.py` gains `--unit`.
- T9, the double variable count: ratified as proposed. `variable_entry` counts only when the stub writer calls it.
- T10, the C++ docket: ratified as proposed. The docket reads the class list of this record and finds the holders by value through `extract.py`.
