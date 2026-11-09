# The hand rows of the sixth wave

This record holds the round of the hand rows of the six round records of the sixth wave: `dedicated-round-common.md`, `dedicated-round-files.md`, `dedicated-round-win.md`, `dedicated-round-vm.md`, `dedicated-round-sv-core.md`, and `dedicated-round-cm-load.md`. The tree is the worktree `/tmp/jka-ded-hand-6` on the branch `dedicated-round-wave6-hand`, off master at 5c71cb9. The code commit is 6a334c3. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`. The user ruled the rows by delegation on 2026-11-09, and the main session read the source for each ruling.

A sibling batch takes the table and `HOST_ROOTS` rows on another branch. A row below that needs a signature from the generator stays open here and names the row that the batch or a later batch must take.

## Row 1, the drop path of Com_Error (common C1)

Proof: Raven throws `"DISCONNECTED\n"` at common.cpp:312, `"DROPPED\n"` at :326, and `"NEED CD\n"` at :336. The catch of Com_Init at :1439 hands the text to Sys_Error. The catch of Com_Frame at :1762 calls `Com_Printf (reason)` and returns.

Form: each throw site keeps every step Raven wrote before the throw. Then the site calls `Com_Printf` with the thrown text and `exit(1)`, under the AI line of the ruling. The two catch sites keep their Port-note, which now says that the three throw sites of row C1 print the text and end the process. The user can overturn this row later with a throwing form.

Deviation: SysBackend has no exit form. The site calls `exit(1)` of Foundation, the call that Sys_Error and Sys_Quit of win_main.swift make.

Files: `Sources/JKAMP_DedLogic/common.swift`.

## Row 2, rand and random (sv-core S2, files F12)

Proof: `srand(Com_Milliseconds())` and `sv.checksumFeed = ( ((int) rand() << 16) ^ rand() ) ^ Com_Milliseconds()` at sv_init.cpp:625 and :626. `fs_fakeChkSum = random()` at files_pc.cpp:895, the macro of q_shared.h:1591. `Package.swift:64` gives `JKAMP_DedLogic` the one dependency `JKAMP_Ded`, with the comment "A host compiles no bg file", so the host cannot call the `srand`, `rand`, and `random` of `Sources/JKAMP_BG/bg_lib.swift:173` to `:190`.

Form: `EngineWorld.holdrand`, a `UInt32` with the start value 1 of the MSVC runtime, under one AI line that names bg_lib.swift. common.swift holds the forward and the three functions under the MARK "The C library rand", each with one AI line: `srand` in the `UInt32` and `Int32` forms of bg_lib.swift, `rand` as `holdrand = holdrand &* 214013 &+ 2531011` and `(holdrand >> 16) & 0x7fff`, the MSVC form that row S2 named, and `random` as Raven's macro. The two sites read as Raven wrote them. FS_FOpenFileRead reads `fs_fakeChkSum = Int32(random())`, the C conversion of the float to an int.

Deviation: the ruling named CommonViews.swift as the home. The view target cannot see `EngineWorld`, so the functions are in common.swift beside the forward. The other C library `rand` sites, sv_client.cpp:67, are in the stub of sv_client.swift, which has no round yet.

Files: `Sources/JKAMP_DedLogic/EngineWorld.swift`, `Sources/JKAMP_DedLogic/common.swift`, `Sources/JKAMP_DedLogic/sv_init.swift`, `Sources/JKAMP_DedLogic/files_pc.swift`.

## Row 3, qsort (vm V8)

Proof: `qsort` is defined at `Sources/JKAMP_BG/bg_lib.swift:49` and `:55`, which the host does not import. The game call `qsort(&slots, count, comparator)` at `Sources/JKAMP_GameLogic/g_main.swift:1605` reads the `[T]` form of `:55`. The host sites are vm.cpp:878, files_pc.cpp:2261, and sv_snapshot.cpp:588.

Form: `Sources/JKAMP_Ded/CommonViews.swift` holds the two `[T]` forms of bg_lib.swift and their private helpers `swapfunc`, `med3`, `insertion`, and `qsortSpan`, with Raven's block and the `Source:` lines of bg_lib.c, under one AI line that names bg_lib.swift. The `Slots<Int32>` form stays out, because no host site sorts an `int` table.

Open: no site fills in this round. VM_ProfileSort at vm.cpp:833 has the stub `(_ a: OpaquePointer?, _ b: OpaquePointer?)`, and the comparator of qsort takes two elements. Row V8 needs a PARAMS row that gives VM_ProfileSort `(VmSymbol?, VmSymbol?)`, the form of the `int_value` comparator kind, and VM_VmProfile_f also reads `symName`, row V7. paksort waits on row F4. sv_snapshot.swift has no round.

Files: `Sources/JKAMP_Ded/CommonViews.swift`.

## Row 4, the Win32 drops (common O1, win W7, win W2)

Proof for W2: a search of the oracle for `Sys_FunctionCmp` and `Sys_FunctionCheckSum` gives only definitions and the declarations of qcommon.h:1032 and :1033, in null/win_main.cpp, win32/win_main.cpp, win32/win_main_common.cpp, unix/unix_main.c, and code/win32/win_main_common.cpp. No file of either tree calls them, and the extract of mp-engine-ded does not name them.

Proof for W7: `Sys_GetCPUSpeed` has one caller, `Cvar_SetValue( "sys_cpuspeed", Sys_GetCPUSpeed() )` at win32/win_main.cpp:1469, the client's main, which the WinDed link set does not hold. `Sys_GetCPUSpeedOld` has one caller, Sys_GetCPUSpeed at win_shared.cpp:425.

Form: OutputDebugString of Com_OPrintf drops under one AI line, the timeBeginPeriod form. Sys_FunctionCmp and Sys_FunctionCheckSum keep the marker with the rule 20 note "Raven calls this function from no file of either tree, so it is dead", the form of VM_VM2C, because no caller exists in either tree.

Deviation: Sys_GetCPUSpeedOld and Sys_GetCPUSpeed keep their markers and their Port-notes. Every statement of the two bodies is an x86 `rdtsc`, a Win32 timer, or arithmetic on their values, so the drop form leaves a busy wait and a value that Raven never computes. The dedicated build has no caller. The client stage takes them with the caller at win32/win_main.cpp:1469.

Files: `Sources/JKAMP_DedLogic/common.swift`, `Sources/JKAMP_DedLogic/win_main.swift`.

## Row 5, SOCKS (win W8)

Proof: NET_OpenSocks at win_net.cpp:653 to :828 and the SOCKS arm of Sys_SendPacket at :435 to :443. NET_OpenIP calls NET_OpenSocks when `net_socksEnabled` is not 0. Raven's SOCKS code calls `socket`, `gethostbyname`, `connect`, `send`, `recv`, and `sendto`, and no `select`.

Form: NET_OpenSocks has Raven's body. `unsigned char buf[64]` is a `CharBuf(64)` local, and `socksBuf` is the generated `CharBuf` variable. SysBackend takes `tcpSocket`, `connect`, `send` over a CharBuf, and `recv` into a CharBuf, each with one AI line, and each call site has the AI line of its Winsock call. Raven's `*(int *)&buf[4]` and `*(short *)&buf[8]` are the subscripts `buf[int: 4]` and `buf[ushort: 8]` on CharBuf, the form of `Slots[int:]` and `Slots[ushort:]`, in SysBackend.swift. The `ushort` subscript gives a `UInt16`, the type of `Sockaddr.sin_port` and of `SysBackend.htons`, so the port moves with no conversion. `memcpy( &buf[2], ... )` and `memcpy( &socksBuf[10], data, length )` are `memcpy(_:_:_:at:)` from a CharBuf or a `Slots<byte>`, the form of `Com_Memset(_:_:_:at:)` of CommonViews.swift. `*(int *)h->h_addr_list[0]` puts the four bytes of the first address into the address field of `Sockaddr` under one AI line. The SOCKS arm hands `socksBuf` to `SysBackend.sendto` through `withSlots`. The unsigned reads of `buf[1]` and `buf[3]` in the switch and the prints are `as UInt8`.

Deviation: the ruling named `select`. Raven's SOCKS code calls no `select`, so SysBackend takes no `select` form.

Files: `Sources/JKAMP_Ded/SysBackend.swift`, `Sources/JKAMP_DedLogic/win_net.swift`.

## Row 6, Sys_SnapVector (win W6)

Proof: Raven steps `float *v` over three floats at win_shared.cpp:41 and rounds each with `fistp`, the round to nearest even of the x87 default mode. The stub at win_shared.swift:63 takes one `inout Float`. The port's `SnapVector` of `Sources/JKAShared/q_math.swift:1439` truncates, the macro of q_shared.h:1408, so it is not Raven's rounding.

Open: a body over one `inout Float` cannot write three floats, and a signature comes only from the generator. The row needs the PARAMS kind `vec3_mut` for `("Sys_SnapVector", "v")`, the form of `float *colors` of BG_ValidateSkinForTeam. The body is then `v[i] = Float(Int32(v[i].rounded(.toNearestOrEven)))` for each of the three components, under one AI line. This is a row for the batch.

Files: none.

## Row 7, the file times (files F3)

Proof: Sys_GetFileTime at files_pc.cpp:568 reads the last write time with CreateFile and GetFileTime. Sys_FileOutOfDate at :600 compares the low halves of two FILETIME values within 20000000 steps and the high halves for equality. The caller is FS_FOpenFileRead at :905 under `fs_copyfiles 2`.

Form: SysBackend.swift takes the record `FILETIME` with its two fields and `SysBackend.GetFileTime(_:_:)`, which reads the `stat` modification time as 100-nanosecond steps since 1601, each with one AI line. Sys_FileOutOfDate has Raven's body, with each call of Sys_GetFileTime as a call of `SysBackend.GetFileTime` under one AI line. The compare keeps Raven's shape. Raven hands the DWORD difference to `abs` as an `int`, and `abs` of the lowest `int` is undefined, so the port reads the magnitude under a rule 19 note.

Open: the stub of Sys_GetFileTime keeps its signature marker, because the table has no row for `FILETIME &ft`. Its Port-note names SysBackend.GetFileTime as the POSIX form of its body.

Files: `Sources/JKAMP_Ded/SysBackend.swift`, `Sources/JKAMP_DedLogic/files_pc.swift`.

## Row 8, the `char **` file lists (files F4, win W3)

Proof: Sys_ListFiles at win_main.swift:478, FS_ListFilteredFiles at files_pc.swift, FS_ListFiles, and Sys_ConcatenateFileLists carry a `TODO: Port signature` marker for the `char **` return. Sys_ListFilteredFiles, Sys_FreeFileList, FS_FreeFileList, Sys_CountFileList, and FS_SortFileList have a generated `inout TextCursor` for `char **`. paksort has `OpaquePointer?` parameters. No ledger rules a list of C strings. The adopted stems give two forms: `inout ArraySlice<String>` for `char *infos[]` of G_ParseInfos at `Sources/JKAMP_GameLogic/g_bot.swift:62`, and the `cStrings` Slots of the reliable commands in sv_main.swift, which is a fixed table of C memory with a bound per slot.

Form taken: `[String]`. A `char **` return of a list of zone strings is `[String]`, nil-free, with `int *numfiles` as `inout Int32`. A `char **psList` parameter that a body fills by index is `inout ArraySlice<String>`, the G_ParseInfos form, because that is the one adopted form for a list of texts that a function fills. Sys_FreeFileList and FS_FreeFileList free nothing, the form of the CharBuf overload of FS_FreeFile. paksort is `(String, String) -> Int32`, and `qsort( sorted, numfiles, 4, paksort )` is `qsort(&sorted, numfiles, paksort)` over the qsort of row 3. The `cStrings` form does not fit, because a file list is a zone allocation of a count that the walk finds, not a table of C memory with a fixed bound.

Open: every function of the row needs its signature from the generator, a RETURNS kind for the list and PARAMS rows for `psList`, the list parameters, and the paksort comparator. A hand signature is out of this round, so FS_AddGameDirectory and Sys_ListFiles keep their holes, and FS_Startup still stops at FS_AddGameDirectory. The `_findfirst` walk of Sys_ListFilteredFiles and Sys_ListFiles then takes one SysBackend function that lists the names and the subdirectory flags of a folder. This is a row for the batch.

Files: none.

## Row 9, CopyFile of `fs_copyfiles 2`

Proof: files_pc.cpp:942 to :961 calls `CopyFile( netpath, copypath, FALSE )`, and on a failure clears FILE_ATTRIBUTE_READONLY with GetFileAttributes and SetFileAttributes and copies again. On a success it sets `bFasterToReOpenUsingNewLocalFile` and closes the net stream.

Form: SysBackend.swift takes `CopyFile`, a byte copy through the C library streams in the form of FileBackend, `GetFileAttributes`, which gives FILE_ATTRIBUTE_READONLY from the owner write bit of the POSIX mode, and `SetFileAttributes`, which clears or sets the write bits with `chmod`, each with one AI line, and the constant `FILE_ATTRIBUTE_READONLY`. The arm has Raven's statements with one AI line, and the stream closes through `FileBackend.fclose`.

Files: `Sources/JKAMP_Ded/SysBackend.swift`, `Sources/JKAMP_DedLogic/files_pc.swift`.

## Row 10, FS_ReplaceSeparators and FS_ShiftedStrStr (files F7, F8)

Proof: F7. The `String` form of FS_ReplaceSeparators at files_common.swift:226 has no caller, because the two FS_BuildOSPath forms call the `inout CharBuf` overload. Raven writes through `char *path`, which a `String` parameter cannot carry back. F8. FS_ShiftedStrStr returns `strstr(string, buf)`, a pointer or NULL, and the stub returns `String`.

Open: both need a signature. F7 needs the sweep row that makes the parameter `inout CharBuf`, after which the overload and the `String` form go. F8 needs the RETURNS kind `optional_string`. Both are rows for the batch.

Files: none.

## Row 11, the other hand rows

- Common F1, the log file write. The files round added the CharBuf overload `FS_Write(_ buffer: CharBuf, _ len: Int32, _ h: fileHandle_t)` at files_pc.swift:1050. Com_Printf now reads `_ = FS_Write(msg, strlen(msg), logfile)` at Raven's line, with no AI line, because the site keeps Raven's form. The call then stops at the FS_FileForHandle hole of row F2 inside FS_Write. File: `Sources/JKAMP_DedLogic/common.swift`.
- Cm-load CM5, `Z_Free(shaderText)` of CM_FreeShaderText. The row has two proposals, the drop of the `G_Alloc` form and a `HAND_VARS` entry that keeps the block, so it needs a ruling. The arm runs only after CM_LoadShaderFiles, which is a marker. No change.
- No other row of the six records closes with a hand body. Each one needs a table or a `HOST_ROOTS` row, a later stage under row E5, or a ruling with no precedent.

## The open holes of the touched files

The `portMissing` count per file, master and then this round: common.swift 17 to 12, sv_init.swift 11 to 10, files_pc.swift 37 to 34, win_net.swift 2 to 0, win_main.swift 9 to 9. `grep -c Unsafe` gives 0 on common.swift, sv_init.swift, files_pc.swift, win_net.swift, win_main.swift, and EngineWorld.swift.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The touched files give no new warning beyond Raven's unread `err` of NET_OpenSocks. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests, 146 pass, 0 skipped |
| `draftcheck.py --unit mp-engine-ded --stem common` | exit 0, 11 of 44 hand functions replaced, 33 kept, 46 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_init` | exit 0, 5 of 17 hand functions replaced, 12 kept, 18 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem files_pc` | exit 0, 19 of 69 hand functions replaced, 50 kept, 200 holes, 0 cascade errors, 0 defects, 4 compile holes over 2 passes |
| `draftcheck.py --unit mp-engine-ded --stem win_net` | exit 0, 6 of 18 hand functions replaced, 12 kept, 78 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem win_main` | exit 0, 15 of 38 hand functions replaced, 23 kept, 66 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `swift build -j 2 --product jampded` | exit 0, 0 errors |

The draftcheck holes are in the drafter's output, not in the working tree.

## The run

`.build/debug/jampded` with standard input from `/dev/null`, under a 20-second alarm, prints the version line and stops at `TODO: Port Com_InitPushEvent, source: oracle/codemp/qcommon/common.cpp:834`, exit 133. That is row S1 of the common round, the `sysEvent_t` view, which the batch takes.
