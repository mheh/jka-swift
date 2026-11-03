# The dedicated server stage 2, the tools half: the ratified rows T2, T5, T6, T7, T8, and T9

This record holds the second tools pass of the MP dedicated server, the rows of the ledger at the end of `notes/2026-11-03/dedicated-stage-1-tools.md`. The tree is the worktree `/tmp/jka-ded-tools` on the branch `dedicated-stage-2-tools`, off master at df7a30e. Each row is its own commit. No file under `Sources/` changed, and `Package.swift` did not change. The host unit has no logic target under `Sources/`, so every file of its run is under `tools/oracle-closure/out/mp-engine-ded/`, which git does not track. Row T10 belongs to the C++ docket and is not in this pass.

## The commits

| Commit | Row | Subject |
|---|---|---|
| 62552e8 | T8 | The snapshot takes a unit |
| b1190c2 | T2 | The host entry list |
| 1586b88 | T2 | CCMShader as a C struct |
| 27bcfdb | T2 | The Windows spellings of WinVars_t |
| 060b4c1 | T5 | The views of a staged unit |
| fef8ab0 | T5 | The host view roots |
| 2115121 | T7 | The traps and channel steps on a host |
| d3dd131 | T9 | One variable count per variable |
| 382cef7 | T6 | The sweeps and the drafter on a host stem |
| b426375 | | The project test reads the host entry list |

## The changed scripts and lines

The line ranges are the lines of the branch head.

| Script | Lines | Change |
|---|---|---|
| `snapshot.py` | 8-9, 15, 44-52, 76 | `--unit`. A unit other than the `[sweep]` unit gets no channel text. A unit with no trap file gets no trap text, and the trap text takes the name of the unit's trap file. `traps.py` is imported only for a unit with a trap file. |
| `project.toml` | 347-359 | The hand entry list of the host. |
| `project.toml` | 393-396 | `HINSTANCE`, `HWND`, and `OSVERSIONINFO` for `WinVars_t`. |
| `rulings.py` | 198-210 | `HOST_ROOTS`. |
| `rulings.py` | 540-542 | `C_STRUCT_CLASSES`, with `CCMShader`. |
| `extract.py` | 44, 887-895, 934, 1111 | A class of `C_STRUCT_CLASSES` is a struct of its fields. The forward line and the tag typedef spell `struct` for it. |
| `views.py` | 133-135, 887 | A record of a staged target has its target under the staged root. The view files go through `closure.written`. |
| `traps.py` | 45-48 | A host exits 0. |
| `channel.py` | 570-573 | A host exits 0. |
| `skeleton.py` | 837-838, 845-846, 1403 | `variable_entry` takes `count`, and the signature row calls it with `count=False`. |
| `table.py` | 666, 692, 749, 813, 1148, 1202, 1708, 1739, 1809, 1850, 2003 | `path.name == C.file_name(path.stem)` in the place of the `.c` suffix test. |
| `bodies.py` | 231 | The drafter opens `C.file_name(fn.stem)`. |
| `tests/test_project.py` | 25-29, 76-80 | The test expects the hand entry list and the three Windows spellings for the host. |

## T8, the snapshot cache and `--unit`

The cache `~/.cache/jka-swift/snapshot-stage-two-shared` was emptied and written again from master with `snapshot.py --out`, before any tool change. The run wrote 372 files in 320.51 s.

`snapshot.py --unit mp-cgame --out ~/.cache/jka-swift/snapshot-mp-cgame` with the tools of master and the new flag wrote 246 files in 92.52 s. The 246 files are the cgame texts less the three channel files, the same set as the cgame comparison of stage 1. This folder is the reference of the cgame check at the end.

A snapshot of `mp-engine-ded` does not run to its end. It stops at `bodies.py:387` on `GPG_GetName` of `GenericParser2`, after 18.87 s. The Rows section holds the cause.

## T2, the host entry list

The entry list holds `qcommon.h`, `qfiles.h`, `cm_local.h`, `cm_patch.h`, `files.h`, `vm_local.h`, `server.h`, `win_local.h`, and `resource.h`. The null folder has no header of its own. No botlib header is in the list.

| Count | Before T2 | After T2 |
|---|---:|---:|
| Files the extract writes | 154 | 372 |
| Layout asserts per triple | 918 | 1724 |
| `CJKAMP_Ded` types | 17 | 119 |
| `CJKAMP_Ded` C++ only declarations | 0 | 40 |
| `CJKAMP_Ded` constants files | 1 | 18 |
| `CJKAMP_Ded` asserts per ABI | 57 | 382 |
| Declarations the extract drops | not recorded | 12 |
| Lines of `cxx_only.txt` of the extract | 0 | 42 |

The 17 types before T2 are `sysEvent_t`, `sysEventType_t`, `sharedTraps_t`, `vmInterpret_t`, `netadrtype_t`, `netchan_t`, `joystickAxis_t`, `xcommand_t`, `node_t`, `netsrc_t`, `svc_ops_e`, `huff_t`, `clc_ops_e`, `netadr_t`, `msg_t`, `huffman_t`, and `vm_t`. Of the four types of the stage 1 row:

- `serverStatic_t` now comes from `server.h`, in `CJKAMP_Ded/include/codemp/server/server/`.
- `server_t` now comes from `server.h`, in the same folder.
- `sysEvent_t` came from `qcommon.h` before T2 too.
- `clipMap_t` comes from `cm_local.h`, but it stands under `CJKAMP_Ded/cxx/`, because it points at the C++ class `CCMLandScape`.

The 12 dropped declarations are ICARUS classes of `blockstream.h`, `interpreter.h`, `sequence.h`, `sequencer.h`, `taskmanager.h`, `instance.h`, and `interface.h`. The first of them, `CBlockMember`, does not parse, because `ICARUS_Free` is undeclared, and the others name it.

`CCMShader`: `clipMap_t.shaders` at `cm_local.h:165` points at the class `CCMShader` of `cm_local.h:77`. `C_STRUCT_CLASSES` of `rulings.py` names it, and `extract.py` writes its four fields as a C struct with `struct CCMShader *mNext` in the place of `class CCMShader *mNext`. The four inline methods `GetName`, `GetNext`, `SetNext`, and `Destroy` stay out. The struct has a forward line and a tag typedef, and the lp64 block asserts its size of 80 bytes and its field offsets. The ilp32 and llp64 blocks hold the line "struct CCMShader did not parse for", so these two ABIs have no assert for it.

`WinVars_t`: `win_local.h` brings `WinVars_t`, which holds `HINSTANCE`, `HWND`, and `OSVERSIONINFO`. With no spelling for them, `check.sh` failed on `CJKAMP_Ded` and the views stopped in `reexport.parse`. The host unit now spells `HINSTANCE` and `HWND` as `void *`, as it spells `HANDLE`, and `OSVERSIONINFO` as a struct in the layout of the Windows SDK's `OSVERSIONINFOA`, five `unsigned int` fields and `char szCSDVersion[128]`.

The default merge and the default extracts give the same bytes as master. A run of `extract.py` over the eight default modules, `merge.py --out ../../Sources`, and `tables.py` leaves `git status` clean under `Sources/`.

## T5, the host view roots

`HOST_ROOTS` names `playerState_t`, `sharedEntity_t`, and `cvar_t` in `CJKAMP`, and `serverStatic_t`, `server_t`, `client_t`, `msg_t`, and `vm_t` in `CJKAMP_Ded`. `playerState_t` keeps the game's view name `PlayerState`.

`views.py --unit mp-engine-ded` stopped twice before it ran. First, `target_of` found no target for `forcedata_s`, because the staged parse reads every C target under `out/mp-engine-ded/Sources`. Then the run wrote its views into `Sources/JKAMP` and `Sources/JKAMP_Ded`, because `write` did not go through `closure.written`. Those files were deleted at once, and `views.py` now finds a staged target and writes under the staged root. The views also need `CPATH` set to the SDK's `usr/include`, because `qfile_gut` of `files.h` includes `<stdio.h>`. The Rows section holds that finding.

| Count | Before T5 | After T5 |
|---|---:|---:|
| View files | 0 | 33 |
| Views | 0 | 31 |
| Callback types | 0 | 25 |
| `TODO: Port` markers in the views | 0 | 0 |
| Mapped stubs | 484 | 605 |
| `TODO: Port signature` markers | 346 | 225 |
| Variable markers | 140 | 47 |

The views resolve 121 of the 346 signature markers and 93 of the 140 variable markers. The T2 entry list alone resolves none: a skeleton run after T2 with no roots gave 484 stubs, 346 markers, and 140 variable markers. The 31 views are 14 in `JKAMP_Ded`, `ServerStatic`, `Server`, `Client`, `ClientSnapshot`, `Challenge`, `SvEntity`, `Netchan`, `Netadr`, `Msg`, `Vm`, `VmSymbol`, `Cmodel`, `CLeaf`, and `Callbacks`, plus 15 in `JKAMP` and 2 in `JKAShared`.

The parameter types with the most markers after T5 are `traceWork_t *` with 19, the return `void *` with 13, `winding_t *` with 12, `lump_t *` with 11, the return `bool` with 10, the return `TGPGroup` with 9, and `netadr_t` by value with 9.

## T7, the traps and channel steps

`traps.py --unit mp-engine-ded` prints "mp-engine-ded is a host and has no trap table, so the run writes nothing" and exits 0. `channel.py --unit mp-engine-ded` prints the same sentence for the bg channel and exits 0. The traps check stands at module level, because the module reads `C.TARGETS['traps']` at import.

## T9, the variable count

| Unit | Printed line before T9 | Printed line after T9 |
|---|---|---|
| `mp-engine-ded` | 44 let, 348 state, 12 data by hand, 12 storage, 94 markers | 22 let, 174 state, 6 data by hand, 6 storage, 47 markers |
| `mp-game` | 0 of each kind | 0 of each kind |
| `mp-cgame` | 0 of each kind | 0 of each kind |

The game and cgame runs print zeros, because every stub of these units is adopted and the run writes no stub. So the printed lines of the game and the cgame did not carry the double count. A count of the stub texts of every stem, as `snapshot.py` builds them, gives these totals after T9:

- `mp-game`: 0 markers, 66 let, 218 state, 30 state_data, 182 storage, 24 storage_data, 7 pointer_table, 2 hand, and 1 byte_storage.
- `mp-cgame`: 7 markers, 25 let, 136 state, 30 state_data, 149 storage, 4 storage_data, 6 pointer_table, and 2 hand.
- `mp-engine-ded`: 47 markers, 22 let, 174 state, 6 state_data, 6 storage, and 2 pointer_table, 257 variables in all.

## T6, the sweeps and the drafter on a host stem

The sweeps of `table.py` now read the host files, and the drafter opens the `.cpp` file. The skeleton counts did not change: 605 stubs and 225 markers.

| Stem | Functions | Holes | Wall time |
|---|---:|---:|---:|
| `huffman` | 18 | 28 | 50.20 s, with the sweep of the base facts |
| `msg` | 48 | 68 | 20.03 s |
| `cvar` | 34 | 19 | 18.93 s |
| `sv_init` | 17 | 18 | 22.94 s |

The 115 holes of the first three stems are mostly local holes: 32 reads and 22 stores of a local the draft left as a hole, 25 pointer locals with no view, and 12 pointer dereferences the draft cannot place.

## The gate

Each step ran in the worktree as one call, in this order. The wall time is `/usr/bin/time -p` real. Steps 8, 9, 11, and 13 ran with `CPATH` set to the SDK's `usr/include`.

| Step | Command | Wall time | Result |
|---|---|---:|---|
| 1 | `closure.py --list-modules` | 0.06 s | The host lists with its nine entries. |
| 2 | `extract.py mp-engine-ded` | 8.87 s | 372 files, 1724 asserts per triple, 10 triples, 42 C++ lines, 12 drops. |
| 3 | `clang -fsyntax-only ... layout_asserts.h` | 0.08 s | 14 errors: 13 asserts of `pack_t` and `directory_t`, and one `expected identifier` at `PERS_SCORE`. |
| 4 | `merge.py --mp mp-game mp-bg mp-cgame mp-ui mp-engine-ded --out out/mp-engine-ded/Sources` | 0.92 s | `CJKAMP_Ded` holds 119 types, 40 C++ only, 18 constants files, 382 asserts per ABI. |
| 5 | `tables.py` | 0.06 s | The same bytes. `git status` is clean. |
| 6 | `check.sh out/mp-engine-ded/Sources` | 3.86 s | Every other target has 0 errors. `CJKAMP_Ded` has 1136 asserts and 46 errors: one `stdio.h` not found on each of the 10 triples, and 12 asserts of `pack_t` and `directory_t` on each of the three Apple triples. |
| 7 | `reexport.py` | not run | `reexport.py:381` takes only a target whose view target is under `Sources/`. |
| 8 | `views.py --unit mp-engine-ded` | 2.14 s | 33 files, 31 views, 25 callback types, 0 markers. |
| 9 | `skeleton.py --unit mp-engine-ded` | 19.54 s | 40 files, 605 stubs, 225 markers, 47 variable markers. |
| 10 | `traps.py --unit mp-engine-ded` | 0.08 s | exit 0, no work. |
| 11 | `manifest.py --unit mp-engine-ded` | 19.56 s | 40 manifests, 830 functions, 648 with a jka-rust match. |
| 12 | `channel.py --unit mp-engine-ded` | 0.09 s | exit 0, no work. |
| 13 | `bodies.py --unit mp-engine-ded --stem sv_init` | 22.94 s | 18 holes. |

| Check | Result | Wall time |
|---|---|---:|
| `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared` | 372 files, no difference | 194.32 s |
| `snapshot.py --unit mp-cgame --check ~/.cache/jka-swift/snapshot-mp-cgame` | 246 files, no difference | 100.10 s |
| `.venv/bin/python3 -m unittest discover -s tests` | 97 tests, OK, 14 skipped | 1.96 s |
| `SLOW=1 .venv/bin/python3 -m unittest discover -s tests` | 97 tests, OK | 193.22 s |
| `swift build` | Build complete, 0 errors | 70.92 s |
| `swift test --no-parallel` | 117 tests in six runs, 1, 1, 84, 13, 3, and 15, all passed | 19.02 s |

The first run of the tool tests failed in `tests/test_project.py:76`, because the test pinned the old single entry and the old defines of the host. The test now expects the hand entry list and the three Windows spellings.

## Rows

The host snapshot stops at `tools/oracle-closure/bodies.py:387` with "no statement row for ('GPG_GetName', 'IF_STMT', 16940, 16971) of GenericParser2". `oracle/codemp/qcommon/GenericParser2.cpp:977` and `:987` define two overloads of `GPG_GetName`, and the table keys a function by its stem and its name (`tools/oracle-closure/table.py:1204`, `:2004`), so the second overload takes the place of the first. So row T8 is met for the cgame and not for the host. The proposal is that the host snapshot leaves out the drafts of a stem with a C++ overload until the C++ docket of row T10 rules on overloads, or that the key takes the line of the definition.

The header parse of the host is partial on the foreign triples. `cm_local.h` includes `cm_landscape.h`, which includes `<list>` at `oracle/codemp/qcommon/cm_landscape.h:5`, and the foreign triples have no C++ library, so the parse stops at a fatal error. So the ilp32 and llp64 blocks of `layout_asserts.h` have no assert for `CCMShader`. The proposal is to put a stub `<list>` in the glshim folder for the host parse, or to accept the lp64 asserts alone for the C++ reach of `cm_local.h`.

`CJKAMP_Ded` does not compile under `check.sh` (`tools/oracle-closure/check.sh:20`), which compiles with `-ffreestanding` and no SDK. `qfile_gut` of `oracle/codemp/qcommon/files.h:71` holds a `FILE *`, so its header includes `<stdio.h>`. The same include stops `reexport.parse` (`tools/oracle-closure/reexport.py:72`) unless `CPATH` names the SDK's `usr/include`, which this pass did for views, skeleton, manifest, and bodies. The field is a pointer alone. The proposal is a forward `typedef struct FILE FILE` in a hand header of `CJKAMP_Ded` in the place of the system include, or a ruling that the host C target may include `<stdio.h>` and that `check.sh` and `reexport.py` give the SDK path for that target.

The asserts of `pack_t` and `directory_t` fail on the three Apple triples. `MAX_OSPATH` takes `PATH_MAX` when it is defined (`oracle/codemp/game/q_shared.h:394-398`, `PLATFORM_MACROS` at `tools/oracle-closure/rulings.py:538`). The lp64 parse of the extract reads the macOS SDK, where `PATH_MAX` is 1024, and the freestanding check has no `PATH_MAX`, so it takes 256. WinDed has no `PATH_MAX` and takes 256. The proposal is that the host layout follows Raven's Windows build, 256, through an undefined `PATH_MAX` in the host parse, because `files.h` puts these arrays inside records of the server.

The syntax check of the extract (`layout_asserts.h` of `out/extract/mp-engine-ded`) fails with "expected identifier" at `PERS_SCORE`. `oracle/codemp/server/server.h:22` defines the macro `PERS_SCORE` as 0, and `oracle/codemp/game/bg_public.h:540` names the enumerator `PERS_SCORE`, and `server.h:12` includes `bg_public.h`. The merged target of `check.sh` does not show the error. The proposal is that the merge places the server.h macro in the host constants file after `bg_public.h`, or that the macro stays in `server.h` alone and the extract reports it as a name a header uses as an identifier.

`clipMap_t` stays C++ only, under `CJKAMP_Ded/cxx/`, because it points at the class `CCMLandScape` (`oracle/codemp/qcommon/cm_local.h:210`). `CCMLandScape` is terrain, which `deferred` keeps out of this stage. A pointer to a class needs only the tag in C. The proposal is that `C_STRUCT_CLASSES` gains a second form, a class that C names behind a pointer alone, with a bare `struct CCMLandScape;`, so `clipMap_t` lands in C. The coordinator asked for this pass to change `CCMShader` alone.

The other C++ declarations that the entry list headers bring, by `cxx_only.txt` of the extract, are 42 lines. `cm_landscape.h` gives 6: `CArea`, `areaList_t`, `areaIter_t`, `CCMHeightDetails`, `CCMPatch`, and `CCMLandScape`, all reached through `cm_local.h`. `cm_local.h` gives 2: `clipMap_t`, by `CCMLandScape`, and `traceWork_t`, whose fields `startout` and `getout` are `bool` (`oracle/codemp/qcommon/cm_local.h:261-262`). `vm_local.h` gives 2: `symbolMap_t` and `symbolVMMap_t`, each a `std::map` under `CRAZY_SYMBOL_MAP` (`oracle/codemp/qcommon/vm_local.h:3`, `:148-150`). ICARUS gives 32, through `server.h`: 27 of `tokenizer.h`, 2 of `blockstream.h`, 2 of `interpreter.h`, and 1 of `taskmanager.h`. `CHash<T>` of `chash.h` is not in the list, because `chash.h` is not in the entry list. `traceWork_t *` gives 19 of the 225 signature markers. The proposal is that the C++ docket of row T10 reads this list beside the eight classes of stage 1, and that `traceWork_t` takes the same struct form as `CCMShader` with `bool` spelled as C's `_Bool`.

The project defines of `WinVars_t` (`tools/oracle-closure/project.toml:393-396`) are a spelling this pass added to keep the host C target compiling and the views running, after the ratified entry list brought `win_local.h`. The `OSVERSIONINFO` define is the layout of the Windows SDK's `OSVERSIONINFOA`, not Raven's text. The proposal is to keep the three spellings, or to leave `win_local.h` out of the entry list until the win32 files port, since only `win_main.cpp` and `null/win_main.cpp` read `WinVars_t`.

The skeleton gives `sysEvent_t`, `clipMap_t`, `StaticMem_t`, and nine other records the reason "a struct Raven defines inside a .c file" (`tools/oracle-closure/skeleton.py:616`). `sysEvent_t` comes from `qcommon.h` and `clipMap_t` from `cm_local.h`. The reason holds for any record with no view, whatever its file. The proposal is that the reason names the header of the record when the record has one, "No view for `sysEvent_t` of `qcommon.h`".

The cgame check needs a reference of its own, and this pass wrote it to `~/.cache/jka-swift/snapshot-mp-cgame` from master. The ruling of one snapshot cache names one folder. The proposal is that the one cache holds a folder per unit, `snapshot-stage-two-shared` for the game and `snapshot-mp-cgame` for the cgame, each refreshed in place after a landing.

`views.py` wrote host views into `Sources/JKAMP` and `Sources/JKAMP_Ded` before the fix of `tools/oracle-closure/views.py:887`. Other writers of a staged run may have the same gap. `views.py:107`, `:422`, and `:549` read the view targets under `Sources/` and not under the staged root, so a staged run reads the committed re-exports and callbacks of `JKAMP` and not the staged ones. The proposal is a survey of every `SOURCES /` path of the generators against `closure.written` before the first host hole round.

## The ledger

The user delegated the rows on 2026-11-03 with the words "remember to prove the rows and auto rule. match existing codebase patterns in reference to the rows". The rows take the numbers S1 to S11 in the order of the Rows section.

- S1, the overload key: ratified as amended. The table keys a function by its stem, its name, and the line of its definition, the key `adopt.py` already uses to match a draft to a stub. No stem is left out of the host snapshot.
- S2, the foreign triples: ratified as amended. The lp64 asserts alone cover the C++ reach of `cm_local.h`. No stub `<list>`.
- S3, `<stdio.h>`: ratified as amended. The host C target includes `<stdio.h>`, as `CJKASyscall` includes `<stdint.h>`, and `check.sh` and `reexport.py` give the SDK include path for the host target.
- S4, `PATH_MAX`: ratified as proposed. The host layout follows Raven's Windows build, 256, through an undefined `PATH_MAX` in the host parse.
- S5, `PERS_SCORE`: ratified as amended. The macro stays in `server.h` alone, the constants file omits a macro whose name is an enumerator of an included header, and the extract reports the omission.
- S6, `clipMap_t`: ratified as proposed. `C_STRUCT_CLASSES` gains the second form, a bare `struct CCMLandScape;` tag for a class C names behind a pointer alone.
- S7, the other C++ declarations: ratified as proposed. The list joins row C1 of the C++ docket, and `traceWork_t` takes the struct form of `CCMShader` with `_Bool`.
- S8, `WinVars_t`: ratified as amended. The three spellings stay, and they live in `CJKAMP_Ded_platform.h` alone, where row T3 keeps the host's platform spellings.
- S9, the skeleton reason: ratified as proposed.
- S10, the cache folders: ratified as proposed. One cache root with one folder per unit, each refreshed in place after a landing.
- S11, the staged paths: ratified as proposed. The survey runs before the first host hole round.

## Stage 2, second pass

This pass implements the rows S1 to S11 of the ledger above, one commit per row, and runs the gate once after the last row. No row stays for a later pass. The host runs no longer need `CPATH`.

### The commits

| Commit | Row | Subject |
|---|---|---|
| a7eb85c | S1 | The function key of a C++ overload |
| 1f79fc7 | S2 | The lp64 asserts for the C++ reach of cm_local.h |
| f883d28 | S3 | The SDK include path of the host C target |
| 861f934 | S4 | No PATH_MAX in the host parse |
| 1848f13 | S5 | A header macro named as an included enumerator |
| b36fb25 | S6 | The bare struct tag of CCMLandScape |
| 0eb0a1b | S7 | traceWork_t as a C struct |
| 1621879 | S8 | The host platform spellings in the host target alone |
| 7f4a911 | S9 | The no-view reason names the header |
| 4d7f51c | S10 | One snapshot folder per unit |
| cd5c371 | S11 | The staged root in every read of a staged run |
| 7b21325 | S1 | The drafter on C++ host bodies |

### The rows

- S1: `closure.function_key` gives the name of a function, and the name with the line of its definition when the file defines the name more than once. The table, the syntax rows, the skeleton, the drafter, `draftcheck.py`, and `snapshot.py` read a function by this key. A C function keeps its name as its key. The host snapshot then stopped in the drafter on nine functions that call a C++ method, `shaderTextTable.clear()` of `cm_shader.cpp:178` first, and on `IsPentium` of `win_shared.cpp:102`, whose label takes a goto from both sides at the top of the body. A call through a member that is no field is now a hole that names the method, and a hole that no statement holds makes the whole body one hole.
- S2: a comment at the host entry list of `project.toml` records that the lp64 asserts alone cover the C++ reach of `cm_local.h`. The extract writes this already, so no tool changes.
- S3: `SDK_TARGETS` of `rulings.py` names `CJKAMP_Ded`. `reexport.parse` and `check.sh` give such a target `-isystem` with the SDK's `usr/include`. `check.sh` also defines `__arm64__` on an aarch64 triple, because the SDK names 64-bit ARM so and stops on any other spelling.
- S4: the host unit defines `_SYS_SYSLIMITS_H_`, the guard of the one SDK header that defines `PATH_MAX`. `MAX_OSPATH` is 256 on every triple, `pack_t` is 816 bytes on lp64, and `directory_t` is 512 bytes.
- S5: the extract leaves out of the constants files a header macro whose name is an enumerator of a header that the macro's header includes, and reports it. It reports `server.h:22 macro PERS_SCORE` alone. A first form with no include test also caught the four `CT_*` macros of `menudef.h` and changed `Sources/CJKAMP`, so the test reads the include graph of the parse.
- S6: `C_STRUCT_CLASSES` takes a form per class, `fields` or `tag`. A `tag` class is `struct X;` and `typedef struct X X;` in `forward.h`, and a pointer to it includes no header. `CCMLandScape` is the first, and `clipMap_t` now lands in C.
- S7: `traceWork_t` takes the `fields` form, its fields in Raven's text with `_Bool` in the place of `bool`.
- S8: `merge.py` writes the platform spellings of the host module into `CJKAMP_Ded_platform.h` alone. A merge with the host now gives the module targets the same platform headers as master.
- S9: a record with no view that comes from a header takes the reason "No view for `sysEvent_t` of `qcommon.h`.". The cgame text changes at `commandList` of `ui_shared.c`, whose `commandDef_t` comes from `ui_shared.h`.
- S10: the README and the usage of `snapshot.py` name the cache root `~/.cache/jka-swift` and its folders `snapshot-stage-two-shared`, `snapshot-mp-cgame`, and `snapshot-mp-engine-ded`. The host folder now holds the snapshot of this branch.
- S11: `closure.READ_ROOTS` holds the output root, and the staged root after it for a staged unit. The survey found these reads of `Sources/` that a staged run takes, and each now reads every root: `skeleton.py` `field_owners`, `collect_outside_calls`, and `collect_never`, `views.py` `scan_declared`, `exported_names`, `callback_alias`, and `target_of`, `channel.py` `ConsumerInstall`, the registry of `bodies.py`, and the lowered key of `bodies.py`, `printer.py`, and `lowering_key.py`. These reads stay on `Sources/`: `reexport.py`, which takes no staged target, `tables.py`, which writes the committed tables, and the `JKAMP_BG` and `JKAShared` reads of `channel.py` and `skeleton.py`, which a staged run never writes.

### The counts

| Count | Before the pass | After the pass |
|---|---:|---:|
| `CJKAMP_Ded` types | 119 | 119 |
| `CJKAMP_Ded` C++ only declarations | 40 | 38 |
| `CJKAMP_Ded` asserts per ABI | 382 | 437 |
| Extract asserts per triple | 1724 | 1779 |
| Extract C++ lines | 42 | 40 |
| Errors of the extract syntax check | 14 | 0 |
| `check.sh` errors of `CJKAMP_Ded` | 46 | 0 |
| `TODO: Port signature` markers | 225 | 225 |
| Variable markers | 47 | 47 |
| Files of the host snapshot | stops in `bodies.py` | 153 |
| Holes of the 40 host drafts | | 1383, 77 of them C++ methods |

### The gate

| Step | Command | Wall time | Result |
|---|---|---:|---|
| 1 | `closure.py --list-modules` | | The host lists. |
| 2 | `extract.py mp-engine-ded` | 10.30 s | 372 files, 1779 asserts per triple, 40 C++ lines, 12 drops, `PERS_SCORE` reported. |
| 3 | `clang -fsyntax-only ... layout_asserts.h` | | 0 errors. |
| 4 | `merge.py --mp mp-game mp-bg mp-cgame mp-ui mp-engine-ded --out out/mp-engine-ded/Sources` | 0.85 s | `CJKAMP_Ded` holds 119 types, 38 C++ only, 18 constants files, 437 asserts per ABI. |
| 5 | `tables.py` | | The same bytes. `git status` is clean. |
| 6 | `check.sh out/mp-engine-ded/Sources` | 4.83 s | Every target 0 errors, `CJKAMP_Ded` with 1301 asserts. |
| 8 | `views.py --unit mp-engine-ded` | 34.81 s | 33 files, 31 views, 25 callback types, 0 markers. |
| 9 | `skeleton.py --unit mp-engine-ded` | 18.15 s | 40 files, 605 stubs, 225 markers, 47 variable markers. |
| 10 | `traps.py --unit mp-engine-ded` | 0.06 s | exit 0, no work. |
| 11 | `manifest.py --unit mp-engine-ded` | 19.88 s | 40 manifests, 830 functions, 648 with a jka-rust match. |
| 12 | `channel.py --unit mp-engine-ded` | 0.10 s | exit 0, no work. |
| 13 | `bodies.py --unit mp-engine-ded --stem sv_init` | 19.07 s | 18 holes. |
| 14 | `snapshot.py --unit mp-engine-ded --out ~/.cache/jka-swift/snapshot-mp-engine-ded` | 20.00 s | 153 files. |

| Check | Result | Wall time |
|---|---|---:|
| `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared` | 372 files, no difference | 210.89 s |
| `snapshot.py --unit mp-cgame --check ~/.cache/jka-swift/snapshot-mp-cgame` | 246 files, two differing lines, both the S9 reason of `commandList` in `skeleton/ui_shared.swift` and `manifest/ui_shared.md` | 118.73 s |
| `.venv/bin/python3 -m unittest discover -s tests` | 97 tests, OK, 14 skipped | 2.08 s |
| `SLOW=1 .venv/bin/python3 -m unittest discover -s tests` | 97 tests, OK | 326.43 s |
| `swift build` | Build complete, 0 errors | 42.85 s |
| `swift test --no-parallel` | 117 tests in six runs, 1, 1, 84, 13, 3, and 15, all passed | 6.20 s |

### Rows

The cgame check differs from `~/.cache/jka-swift/snapshot-mp-cgame` in the two lines that row S9 changes, `commandList` of `oracle/codemp/ui/ui_shared.c:2196`, whose `commandDef_t` comes from `oracle/codemp/ui/ui_shared.h:398`. The proposal is to refresh the cgame folder in place with `snapshot.py --unit mp-cgame --out` when this branch lands, by row S10.

The C++ method hole of `tools/oracle-closure/draft_calls.py:128-133` and the body hole of `tools/oracle-closure/bodies.py:330-334` are drafter changes that row S1 did not name. Without them the host snapshot stops on ten host functions. The proposal is to keep them, and that the C++ docket of row T10 reads the 77 C++ method holes of the host drafts.

`check.sh` defines `__arm64__` on the aarch64 triples of `CJKAMP_Ded` (`tools/oracle-closure/check.sh:27`), so the macOS SDK takes its arm64 arm on a Linux and a Windows triple. The SDK of the Mac checks the layout of every triple, and no Linux or Windows C library takes part. The proposal is to accept this for the check, because the layout asserts come from the extract and `FILE` stands behind a pointer alone.

The guard `_SYS_SYSLIMITS_H_` of row S4 (`tools/oracle-closure/project.toml`, the host defines) names a header of the macOS SDK. A host parse on Linux reads `PATH_MAX` from `linux/limits.h` and would take 4096. The proposal is to add the Linux guard `_LINUX_LIMITS_H` beside it when the tools first run on Linux.

## The ledger of the second pass

- The cgame cache refresh: ratified as proposed, refreshed in place with `snapshot.py --unit mp-cgame --out` at the landing, by row S10.
- The two drafter changes of S1: ratified as proposed. The C++ method hole and the body hole stay, and the C++ docket reads the 77 method holes.
- `__arm64__` on the aarch64 triples of the check: ratified as proposed.
- The Linux guard for `PATH_MAX`: ratified as proposed, added when the tools first run on Linux.
