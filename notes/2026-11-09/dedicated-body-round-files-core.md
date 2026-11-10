# The files-core body round

This record holds the body round `files-core` of the dedicated host. The tree is the worktree `/tmp/jka-files-core` on the branch `ded-bodies-files-core`, off master at `7961ee4`. The code commit is `a59ef7e`. The round changed no generated signature, no generator table, and no python tool, and it ran no generator, no draftcheck, and no snapshot tool.

## The stubs per stem

| Stem | `portMissing` before | After | Filled |
|---|---|---|---|
| files_pc | 17 | 2 | 15 |
| common | 6 | 2 | 4 |
| win_main | 5 | 2 | 3 |
| win_shared | 2 | 2 | 0 |
| Memory | 2 | 1 | 1 |
| cvar | 2 | 2 | 0 |
| sv_init | 1 | 1 | 0 |
| unzip | 15 | 0 | 15 |
| GenericParser2 | 27 | 27 | 0 |
| stringed_interface | 4 | 0 | 4 |
| stringed_ingame | 4 | 1 | 3 |
| vm | 30 | 14 | 16 |
| Total | 115 | 54 | 61 |

Memory.swift had the skeleton header, so the code commit removes the two header lines.

## The bodies

- files_pc: FS_ListFilteredFiles, FS_ListFiles, FS_FreeFileList, FS_GetFileList, Sys_CountFileList, Sys_ConcatenateFileLists, FS_GetModList, FS_Dir_f, FS_SortFileList, FS_NewDir_f, paksort, FS_LoadZipFile, FS_AddGameDirectory, the pak arm of FS_FOpenFileRead, and the zip arm of the CharBuf FS_Read. The lists take the `[String]` form of row F4, and FS_FreeFileList and Sys_FreeFileList free nothing under a rule 24 line. Each Z_Malloc table of a list is the array, and the CopyString calls stay for the zone count.
- files_pc: FS_FileIsInPAK had a `continue` with no step of `search`, so a pak off the pure list looped forever. The `continue` now steps first, as Raven's `for` loop does.
- files_pc: three overloads join the FS_FreeFile and FS_ReadFile rows. `FS_FreeFile(_: Slots<byte>)` is the free of row S2. `FS_ReadFile(_:_: inout VmHeader?)` and `FS_FreeFile(_: VmHeader?)` are the overloads of row V3.
- win_main: Sys_ListFilteredFiles, Sys_ListFiles, and Sys_FreeFileList. The Win32 CRT calls `_findfirst`, `_findnext`, and `_findclose` are SysBackend calls over the POSIX `opendir`, with `_finddata_t` and `_A_SUBDIR` beside them. The backend reads a backslash as a path separator and matches `*` and `?` without case, as Win32 does. It does not give the 8.3 short-name matches of Win32.
- unzip: every stub, the row U1 to U4 bodies included. A `short` or `int` read of unzlocal_getShort and unzlocal_getLong goes into a CharBuf of the size of the local, and the value sign-extends into the `uLong` as C's store does. The callers that pass NULL for the name or the comment pass a scratch CharBuf with a size of 0, under a rule 24 line. A size of 0 reads and writes no byte, so the result is Raven's.
- unzip: row U5. `withMutableSlots` of CharBuf.swift gives the bytes of a CharBuf as a Slots that a callee writes, and the CharBuf overload of unzReadCurrentFile forwards through it.
- common: the journal write of Com_GetRealEvent, the two Com_ParseTextFile forms, and Com_ParseTextFileDestroy over the CGenericParser2 class of row G1 of the unzip round.
- stringed_interface: all four bodies. SE_LoadFileData returns the Slots over the block of FS_ReadFile and its NUL.
- stringed_ingame: SE_Load_Actual, SE_GetFoundFile, and SE_GetNumLanguages. The `set<string>` of SE_GetNumLanguages is a Swift Set.
- vm: the QVM image of VM_Create and VM_Restart, row V3, the shift of VM_Shifted_Alloc and VM_Shifted_Free, row V6, and VM_ProfileSort and VM_VmProfile_f, row V8.
- Memory: ICARUS_Free.

## The hand pieces

| Piece | File | Raven's counterpart |
|---|---|---|
| `_A_SUBDIR`, `_finddata_t`, `SysBackend._findfirst`, `._findnext`, `._findclose` | `Sources/JKAMP_Ded/SysBackend.swift` | the Win32 CRT of `null/win_main.cpp:434` to `:595` |
| `Pack.buildBufferSlots` | `Sources/JKAMP_Ded/FileBackend.swift` | `buildBuffer[i]` over `pak->buildBuffer`, `files_pc.cpp:1635` |
| `Vm.shifted(_:)` and `Vm.unshifted(_:)` | `Sources/JKAMP_Ded/VmEntry.swift` | the shift of `vm.cpp:716` and `:730`, row V6 |
| `VmHeader.bytes(count:)` | `Sources/JKAMP_Ded/VmEntry.swift` | the cast `(byte *)header` of `vm.cpp:564` |
| `CharBuf.withMutableSlots` | `Sources/JKAShared/CharBuf.swift` | the `char` array into a `void *` that the callee fills, row U5 |

## The stubs that stay

- files_pc: Sys_GetFileTime, row F3, a Windows platform function. FS_ReorderPurePaks, row F10, the `searchpath_t **` walk of `files_pc.cpp:2458`, which the sixth and seventh ledgers do not rule.
- common: the two holes of Com_Frame, row C, the `timing_c` of `common.cpp:1598` and `:1768`.
- win_main: Sys_FunctionCmp and Sys_FunctionCheckSum, dead by rule 20.
- win_shared: Sys_GetCPUSpeedOld and Sys_GetCPUSpeed, row W7.
- Memory: ICARUS_Malloc, the signature marker of the `void *` return, row FC4 below.
- cvar: Cvar_FreeString and Cvar_Realloc, no caller under the string pool.
- sv_init: SV_Init, row C, `G2VertSpaceServer = &CMiniHeap_singleton` of `sv_init.cpp:885`.
- GenericParser2: CleanTextPool, row C3, and the 26 GP, GPG, and GPV handle functions, dead by rule 20.
- stringed_ingame: SE_LoadLanguage, row S6. Raven calls `SE_Load( p, bLoadDebug )` at `stringed_ingame.cpp:1233`, and the stub of SE_Load at `stringed_ingame.swift:800` has no default for `bFailIsCritical`. Row S4 has no hole in these stems, because `sSE_STRINGS_DIR` and `sSE_INGAME_FILE_EXTENSION` are file constants of stringed_ingame.swift.
- vm: VM_VM2C, VM_SymbolToValue, VM_SymbolForCompiledPointer, and VM_LogSyscalls are dead by rule 20, and the round adds the rule 20 note to the last three. VM_ArgPtr, BotVMShift, and VM_ExplicitArgPtr keep their ten holes, row FC3 below.

## The rows

- Row FC1, the buildBuffer table. Raven indexes a local copy of `pak->buildBuffer` at `files_pc.cpp:1635` to `:1641` and the Z_Malloc block at `:1460` to `:1509`, so the subscript sweep of `table.py` gives `Pack` no `buildBufferSlots`. The hand accessor is at `Sources/JKAMP_Ded/FileBackend.swift:232`, in the form of a generated `<name>Slots` accessor. Proposal: a sweep or FIELDS row so that `views.py` writes the accessor, and the hand accessor goes in that commit.
- Row FC2, the NULL text buffers of unzip. Raven passes NULL for `szFileName` and `szComment` at `unzip.cpp:746`, `:775`, `:812`, `:855`, and `files_pc.cpp:1452` and `:1493`. Row U4 keeps the two parameters `inout CharBuf`, so the callers pass a scratch CharBuf with a size of 0 at `unzip.swift:618`, `:650`, `:692`, `:736`, and `files_pc.swift:1633`. The one difference is a relative `fseek` of the comment arm when the name and the extra field leave `lSeek` above 0, and every reader seeks to an absolute position first. Proposal: ratify the scratch form, the form of a scratch `vec3_t` for a NULL vector.
- Row FC3, the word reads of the module. VM_ArgPtr and BotVMShift return NULL at `vm.cpp:642`, `:646`, `:661`, and `:666`, and the RETURNS kind `raw` gives a non-optional `UnsafeMutableRawPointer` at `vm.swift:678` and `:703`. The dll arms read `dataBase + intValue` over a NULL `dataBase` at `vm.cpp:649` and `:671`, which is the address word itself, row N5. VM_ExplicitArgPtr reads the text at the same address at `vm.cpp:753` and `:756`, and its `String?` at `vm.swift:779` needs a read of the text at a word in the view target. Proposal: an optional RETURNS kind `raw` for the two `void *` returns, and a `Vm` accessor that reads at `dataBase + word` at the full width, the `text(at:)` form of the shell.
- Row FC4, ICARUS_Malloc. Raven returns `void *` at `Memory.cpp:8`, and the stub at `Memory.swift:12` has a signature marker. Proposal: the RETURNS kind `raw`, the row of Z_Malloc and row B5.
- Row F10, FS_ReorderPurePaks, stays open with its hole at `files_pc.swift:2747`. The body returns at once when `fs_numServerPaks` is 0, which the dedicated host never sets.
- Rows S4 and S6 wait for the tool fix of the next batch, as the brief says.

## The checks

- `swift build -j 2` exited 0 on the first run, with 0 errors. A second run after three `@discardableResult` attributes in unzip.swift also exited 0.
- `swift test --no-parallel -j 2` exited 0. It ran 150 tests in nine runs, 1, 1, 1, 98, 13, 14, 3, 15, and 4, with 0 failures.

## Where jampded stops

`.build/debug/jampded < /dev/null` now passes FS_Startup twice, the second time for the demo directory of the restricted mode, and traps at `CM_ClearMap` (`cm_load.cpp:791`), a stub of the cm_load stem, exit 133. The trap of master was at `FS_AddGameDirectory` (`files_pc.cpp:2212`).

A run with `+set fs_basepath` over a folder with three pk3 files lists each pak with its file count and gives "5 files in pk3 files". A deflated `productid.txt` with the right bytes in one pak reads through FS_FOpenFileRead, unzOpenCurrentFile, and unzReadCurrentFile, and the restricted mode stays off. The same run then traps at `CM_ClearMap`.
