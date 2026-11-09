# The files round, the file system of the host

This record holds the round of `Sources/JKAMP_DedLogic/files_pc.swift` and `Sources/JKAMP_DedLogic/files_common.swift`, the stems of Raven's `oracle/codemp/qcommon/files_pc.cpp` and `files_common.cpp` in the unit mp-engine-ded. The tree is the worktree `/tmp/jka-ded-files` on the branch `dedicated-round-files`, off master at 1cdd22f. The code commit is bffdbb0. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

files_pc.swift was adopted on master. files_common.swift had the skeleton header, so the round adopted it and removed the header in the code commit. `bodies.py` gave 180 holes over files_pc and 6 over files_common. The round took the drafts as the base of each body and corrected them to the forms of `docs/transcription.md` and the five ledgers.

- files_pc: 72 `portMissing` lines before the round and 37 after. 52 of 69 functions have whole bodies, 13 keep their marker under a Port-note, and 17 bodies hold the holes of the tables below. Two overloads count in the 17.
- files_common: 12 `portMissing` lines before the round and 1 after. Every function has its body, except the `String` form of FS_ReplaceSeparators, which has no caller.
- A `char *` that FS_BuildOSPath returns and the caller then writes, `ospath[strlen(ospath)-1] = '\0'`, is a CharBuf local, `ospath = CharBuf(FS_BuildOSPath(...))`, by the text-local rule. The draft wrote the byte into a temporary copy.
- The NULL callers of FS_ReadFile, files_common.cpp:502 and files_pc.cpp:3008, pass `var buffer: CharBuf? = nil`, the overload of row 7 of the first ledger. The `CharBuf?` overload has Raven's whole body with his `if ( !buffer )` arm, and its buffer is a CharBuf of `len+1` bytes under a rule 24 line.
- Raven's `byte *buf` walk of FS_Read and FS_Write is a byte offset that FileBackend takes, under a rule 24 line.
- FS_FilenameCompare returns `true` for Raven's `(qboolean)-1`.
- Raven's `Z_Free` of a CopyString name in the two FS_PureServerSet functions drops under a rule 24 line, by the CopyString form of row Z3. The slot takes the empty text, the NULL of the generated `[String]` table.
- The `seed` product of FS_SetRestrictions wraps at 32 bits under a rule 19 note.
- The `#ifndef __linux__` arms of FS_FOpenFileRead stay, because the host parse defines no `__linux__`. The `CopyFile` arm of `fs_copyfiles 2` is a hole that names the Windows functions.

## The hand pieces

`Sources/JKAMP_Ded/FileBackend.swift` is new. It holds what the view target lacks, each piece under a rule 24 line.

| Piece | Raven's counterpart | Use |
|---|---|---|
| `PATH_SEP`, `/` or `\` by `#if os(Windows)` | `PATH_SEP` of q_shared.h:178 and :200 | FS_HashFileName, FS_CreatePath, FS_ReplaceSeparators |
| `FileHandleData`, a view with `handleFiles`, the five scalars, `name`, `nameBuffer`, and `clear()` | `fileHandleData_t` of files.h:84 | `fsh[f]` |
| `FileHandleData.table(count:)` | `fileHandleData_t fsh[MAX_FILE_HANDLES]` of files_common.cpp:202 | the zeroed table of `EngineWorld.fsh` |
| `Qfile_u`, a view with `file` and `unique` | `qfile_ut` of files.h:78 | `fsh[f].handleFiles` |
| `Qfile_gu`, a view with `o` and `z`, each `OpaquePointer?` | `qfile_gut` of files.h:71 | the stream and the zip handle |
| `Searchpath`, a view with `next`, `pack`, and `dir` | `searchpath_t` of files.h:63 | the search path walks |
| `Pack`, a view with the three names, `packHandle`, the five counts, `hashTable`, and `buildBuffer` | `pack_t` of files.h:42 | the pak walks |
| `Directory`, a view with `path`, `gamedir`, and their `Buffer` forms | `directory_t` of files.h:58 | the directory walks |
| `FileInPack`, a view with `name`, `pos`, and `next` | `fileInPack_t` of files.h:36 | the hash chains |
| `FileBackend.fopen`, `.fclose`, `.fread`, `.fwrite`, `.fseek`, `.ftell`, `.fflush`, `.setvbuf`, `.remove`, `.rename` | the C library calls of files_pc.cpp | every stream call |

Each FileBackend call names the C library module of its platform under `#if canImport`, the form of ZoneBackend. A stream is the `OpaquePointer?` of `Qfile_gu.o`. `fread` and `fwrite` take an `OpaquePointer?` buffer or a CharBuf, and a byte offset `at:`. `ftell` and the counts return `Int32`, the narrowing of Raven's store.

`EngineWorld.swift` takes two hand properties under a `files_common.cpp` mark: `fs_searchpaths: Searchpath?` and `fsh`, the table of `FileHandleData.table(count:)`. The stub forwards each name at Raven's line under a rule 24 line.

The round adds three overloads in the logic files, each after its original with a Port-note and a rule 24 line, by the CharBuf overload precedent of `MSG_WriteData` and `NET_SendPacket`:

- `FS_ReplaceSeparators(_ path: inout CharBuf)`, which the two FS_BuildOSPath forms call. Row F7 covers it.
- `FS_Write(_ buffer: CharBuf, _ len: Int32, _ h: fileHandle_t)`, for `char msg[MAXPRINTMSG]` of FS_Printf at files_common.cpp:383 and the log file write of common.cpp:188.
- The `CharBuf?` overload of FS_ReadFile and the CharBuf overload of FS_Read were on master as markers. They now have bodies.

## Rows for the user

- Row F1, `pack_t *`. Question: FS_PakIsPure (files_pc.cpp:39) takes `pack_t *pack`, and FS_LoadZipFile (:1423) returns `pack_t *`, and the table has no row for either. Callers: FS_PakIsPure from FS_FOpenFileRead (:745), FS_FileIsInPAK (:1229), FS_ListFilteredFiles (:1629), and FS_Path_f (:2149). FS_LoadZipFile from FS_AddGameDirectory (:2265). Proposal: row F5 gives the view `Pack`, and the skeleton writes `func FS_PakIsPure(_ pack: Pack) -> Bool` and `private func FS_LoadZipFile(_ zipfile: inout CharBuf, _ basename: String) -> Pack?`. FS_LoadZipFile also needs unzOpen, unzGetGlobalInfo, and unzGetCurrentFileInfo, which carry signature markers in unzip.swift.
- Row F2, `FILE *`. Question: FS_FileForHandle (:85) returns `FILE *`, and the table has no row. Callers: FS_ForceFlush (:103), FS_filelength (:122), FS_Write (:1094), FS_Seek (:1162), and FS_GetModList (:1948). Proposal: the RETURNS kind `opaque` for `FILE *`, so the skeleton writes `private func FS_FileForHandle(_ f: fileHandle_t) -> OpaquePointer?`, the stream handle of FileBackend. This row is first, because FS_filelength ends every read of a file in a directory, so FS_ReadFile stops at its hole.
- Row F3, `FILETIME`. Question: Sys_GetFileTime (:568) takes `FILETIME &ft`, a Windows type the host parse does not define, and calls `GetFileAttributesEx`. Sys_FileOutOfDate (:600) reads two of them. Caller: FS_FOpenFileRead (:905), under `fs_copyfiles 2` alone. Proposal: both keep their marker as Windows platform functions, the form of `timeGetTime`, until a ruling gives FileBackend a file time.
- Row F4, the `char **` lists. Question: FS_ListFilteredFiles (:1587), FS_ListFiles (:1724), Sys_ConcatenateFileLists (:1818), and `Sys_ListFiles` of win_main.cpp:502 return `char **` with `int *numfiles`. The skeleton gives FS_FreeFileList (:1733), Sys_CountFileList (:1803), and FS_SortFileList (:2078) a TextCursor, which holds one text. paksort (:2194) is a `qsort` comparator over `void *`. Callers: FS_AddGameDirectory (:2250), FS_GetFileList (:1770), FS_GetModList (:1883), FS_Dir_f (:2012), and FS_NewDir_f (:2122). Proposal: a RETURNS kind for a list of zone strings that gives `[String]`, `int *numfiles` as `inout Int32`, the list parameters as `inout [String]`, and FS_FreeFileList and Sys_FreeFileList of `[String]` that free nothing, the form of the CharBuf FS_FreeFile. Raven's `qsort( sorted, numfiles, 4, paksort )` is a sort of the array by paksort over two `String` values. FS_AddGameDirectory stops at this hole on every FS_Startup.
- Row F5, the files.h views. Question: FileBackend.swift holds hand views of seven records that files.h defines. Proposal: `HOST_ROOTS` takes `fileHandleData_t`, `searchpath_t`, `pack_t`, `directory_t`, and `fileInPack_t`, which reach `qfile_ut` and `qfile_gut`, the form of row Z1. `FIELD_NAMES` takes `("pack_t", "handle")` as `packHandle`, and `FIELDS` gives `qfile_gut.o` the kind `opaque`. The generator sequence then writes the views, and the hand views go in that commit. `PATH_SEP` and FileBackend stay as hand pieces.
- Row F6, the storage of `fs_searchpaths` and `fsh`. Question: the skeleton has no row for `searchpath_t *` (files_common.cpp:193) and no view for `fileHandleData_t` (:202), so the world holds both by hand. Proposal: after row F5, `fs_searchpaths` is a property of EngineVariables, `fsh` is a table on EngineStorage, and the two forwards take the skeleton's text. The two properties of EngineWorld.swift go in that commit.
- Row F7, FS_ReplaceSeparators. Question: Raven writes through `char *path` (files_common.cpp:277) by the local `s`, and the text sweep reads the parameter as a `String`. Caller: the two FS_BuildOSPath forms (:310, :332). Proposal: the sweep counts a store through a local set from the parameter, so the skeleton writes `inout CharBuf`. The hand overload and the `String` form then go.
- Row F8, FS_ShiftedStrStr. Question: the function (:649) returns `strstr(string, buf)`, a pointer or NULL, and the skeleton gives `-> String`. Callers: the pak arm of FS_FOpenFileRead (:793 to :821). Proposal: the RETURNS kind `optional_string`, so the body returns the text from the match or nil.
- Row F9, the journal length. Question: FS_ReadFile reads and writes its `int len` through `&len`, at :1283, :1330, :1339, and :1367. FS_Read and FS_Write take a buffer and no address of an `int`. Proposal: a `BYTE_STORAGE_LOCALS` entry for `len` of FS_ReadFile, a `Slots<Int32>` of one slot, and the `bytes` form of FS_Read and FS_Write of row F14, so the call reads `FS_Read(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)`, the form of `key_Com_BlockChecksumKey`. The arms run only under `com_journal`.
- Row F10, FS_ReorderPurePaks. Question: the function (:2445) walks `searchpath_t **` slots, `&fs_searchpaths` (:2458) and `&s->next`. Caller: FS_Startup (:2561), and the body returns at once when `fs_numServerPaks` is 0. Proposal: the `slot` kind of row 6 of the first ledger for `searchpath_t.next`, and `fs_searchpaths` as a `Slots<Searchpath?>` of one slot on EngineStorage, so both addresses are a `Slots<Searchpath?>` of count 1.
- Row F11, `unz_s`. Question: the pak arm of FS_FOpenFileRead casts the zip handle to `unz_s *` (:828), copies `sizeof(unz_s)` bytes into it (:834), and returns `zfi->cur_file_info.uncompressed_size` (:854). Proposal: `HOST_ROOTS` takes `unz_s`, a row for the unzip round.
- Row F12, `random()`. Question: FS_FOpenFileRead writes `fs_fakeChkSum = random()` (:895) for every directory file that is not one of six extensions. The macro has a home in JKAMP_BG alone, which the host does not import. Proposal: the macro of q_shared.h:1591 moves to JKAShared beside `rand`, so every module reads one home.
- Row F13, unzReadCurrentFile into a CharBuf. Question: the zip arm of the CharBuf FS_Read reads into the caller's CharBuf, and unzReadCurrentFile of unzip.swift takes an `OpaquePointer?` buffer. Proposal: a CharBuf overload in unzip.swift, a row for the unzip round.
- Row F14, the `void *` buffers. Question: FS_Read, FS_Read2, FS_Write, and FS_WriteFile take `OpaquePointer?`, so FS_ReadFile hands `OpaquePointer(buf)` of its zone block under a rule 24 line, and the streams are `OpaquePointer?` locals in the logic target. Proposal: the PARAMS kind `bytes` for these `void *` parameters, the form of `MSG_WriteData`, so FS_ReadFile hands a `Slots<byte>` over the zone block and the walk is `suffix(from:)`. The stream stays the opaque handle of row F2.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| FS_PakIsPure, FS_LoadZipFile | :39, :1423 | signature marker | F1 |
| FS_FileForHandle | :85 | signature marker | F2 |
| FS_ForceFlush, FS_filelength, FS_Write (2 forms), FS_Seek | :103, :122, :1094, :1162 | `FS_FileForHandle(f)` | F2 |
| Sys_GetFileTime, Sys_FileOutOfDate | :568, :600 | marker | F3 |
| FS_ListFilteredFiles, FS_ListFiles, FS_FreeFileList, Sys_CountFileList, Sys_ConcatenateFileLists, FS_GetModList, FS_SortFileList, paksort | :1587 to :2194 | marker | F4 |
| FS_GetFileList, FS_Dir_f, FS_NewDir_f | :1770, :2012, :2122 | the `char **` list | F4 |
| FS_AddGameDirectory | :2250 | `Sys_ListFiles` and the pak loads | F4, F1 |
| FS_FOpenFileRead, FS_FileIsInPAK, FS_Path_f | :745, :1229, :2149 | `FS_PakIsPure` and the pak arm | F1, F11 |
| FS_FOpenFileRead | :895 | `random()` | F12 |
| FS_FOpenFileRead | :948 | `CopyFile`, `GetFileAttributes`, `SetFileAttributes` | Windows |
| FS_ShiftedStrStr | :657 | the NULL return of `strstr` | F8 |
| FS_ReadFile (2 forms) | :1283, :1330, :1339, :1367 | `&len` of the journal | F9 |
| FS_ReorderPurePaks | :2458 | `searchpath_t **` | F10 |
| FS_Read, the CharBuf form | :1068 | unzReadCurrentFile into a CharBuf | F13 |
| FS_ReplaceSeparators, the `String` form | files_common.cpp:277 | no caller | F7 |

The path of Com_Init also stops at the stubs of other stems: `Sys_ListFiles` and the four streamed file functions of win_main.swift, `Sys_DefaultCDPath`, `Sys_DefaultInstallPath`, and `Sys_DefaultHomePath` of win_main.swift and win_shared.swift, `Sys_Mkdir`, `S_ClearSoundBuffer` of null_snddma.swift, `Com_DPrintf` of common.swift, and the unz functions of unzip.swift.

## The test

The round adds no test of FS_ReadFile. A read of a file that a directory holds stops at the FS_FileForHandle hole of FS_filelength, row F2. A read of a missing file reaches `Com_DPrintf("Can't find %s\n")`, and Com_DPrintf of common.swift is a stub. A trial test over a temporary folder stopped at that stub, so the round removed it.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. files_pc.swift gives 26 warnings and files_common.swift 3: "will never be executed" after the holes, unused results of calls whose results Raven drops, and the unused `filter`, `thedir`, and `badchecksum` that Raven writes. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests, 145 pass, 1 skipped, the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem files_pc` | exit 0, 20 of 69 hand functions replaced, 49 kept, 201 holes, 0 cascade errors, 0 defects, 5 compile holes over 2 passes |
| `draftcheck.py --unit mp-engine-ded --stem files_common` | exit 0, 4 of 12 hand functions replaced, 8 kept, 7 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The holes of draftcheck are in the drafter's output, not in the working tree. The working tree holds the 38 `portMissing` lines, 37 in files_pc.swift and 1 in files_common.swift, of the tables above. `grep Unsafe` gives 0 lines in files_pc.swift and files_common.swift.
