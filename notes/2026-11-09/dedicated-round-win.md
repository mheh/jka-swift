# The win round, the platform layer of the dedicated host

This record holds the round of `Sources/JKAMP_DedLogic/win_main.swift`, `win_shared.swift`, and `win_net.swift`, the stems of `oracle/codemp/null/win_main.cpp`, `oracle/codemp/win32/win_shared.cpp`, and `oracle/codemp/win32/win_net.cpp`. The tree is the worktree `/tmp/jka-ded-win` on the branch `dedicated-round-win`, off master at 1cdd22f. The code commit is ae4619b. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The three stubs had no skeleton header, because commit 77e58dc adopted them, so the round removed no header. The drafter gave 14 holes for win_shared, 64 for win_main, and 78 for win_net. The round spliced the drafts and filled every hole that a ruled form, a precedent, or a backend function of this round covers.

- win_shared, 12 of 15 functions filled: Sys_Milliseconds, CPUID, IsPentium, Is3DNOW, IsKNI, IsWIL, IsMMX, Sys_GetProcessorId, Sys_GetCurrentUser, Sys_DefaultHomePath, Sys_DefaultInstallPath, and Sys_GetPhysicalMemory.
- win_main, 29 of 38 functions filled: Conbuf_AppendText, Sys_LowPhysicalMemory, Sys_MonkeyShouldBeSpanked, Sys_VerifyCodeChecksum, PrintMatches, Sys_ConsoleInput, Sys_BeginProfiling, Sys_ShowConsole, Sys_Error, Sys_Quit, Sys_Print, Sys_Mkdir, Sys_Cwd, Sys_DefaultCDPath, Sys_DefaultBasePath, strgtr, Sys_CheckCD, Sys_GetClipboardData, Sys_UnloadDll, Sys_UnpackDLL, the six stream functions, Sys_In_Restart_f, Sys_Net_Restart_f, and Sys_Init.
- win_net, 17 of 18 functions filled: NET_ErrorString, Sys_StringToAdr, Sys_GetPacket, Sys_IsLANAddress, Sys_ShowIP, NET_IPSocket, NET_GetLocalAddress, NET_OpenIP, NET_IPXSocket, NET_OpenIPX, NET_GetCvars, NET_Config, NET_Init, NET_Shutdown, NET_Sleep, NET_Restart, and Sys_SendPacket except its SOCKS arm.
- Sys_GetProcessorId takes Raven's `#elif !defined _M_IX86` arm, the arm of the native build, so it returns CPUID_GENERIC, and CPUID and the five `Is` functions have no caller in this build.
- Raven's `return` after a `Com_Error` drops under rule 22, and every `#ifdef _XBOX` arm drops.
- Sys_Milliseconds subtracts the base with `&-=` under a rule 19 note, because Raven's int subtraction overflows when the 32-bit clock wraps.
- The ctrl-v arm of Sys_ConsoleInput copies at most the room after `len`, under a rule 19 note, because Raven's strncpy of the whole buffer size from the offset `len` runs past the end.
- Conbuf_AppendText prints the text as it stands, under a rule 19 note, because Raven hands the text to printf as its format.

## The hand pieces

`Sources/JKAMP_Ded/SysBackend.swift` is new. It imports the C library of its platform with the `canImport` ladder of `ZoneBlocks.swift`, `Darwin`, `Glibc`, or `Musl`. Every function of `SysBackend` and every Winsock name carries one AI line.

| Piece | Raven's counterpart | POSIX form |
|---|---|---|
| `SysBackend.timeGetTime()` | `timeGetTime` at win_shared.cpp:24 and :27 | `clock_gettime(CLOCK_MONOTONIC)` in milliseconds, truncated to 32 bits |
| `SysBackend.kbhit()` | `kbhit` at win_main.cpp:207 | `poll` of standard input with no wait; the first call with a terminal turns off the line mode and the echo, and `atexit` turns them on again |
| `SysBackend.getch()` | `getch` at win_main.cpp:211 | `read` of one byte, 0 at the end of file |
| `SysBackend.printf(_:)` | `printf` at win_main.cpp:38, :195, and the echoes of Sys_ConsoleInput | `fwrite` of the bytes of a `CharBuf` and `fflush` |
| `SysBackend._mkdir(_:)` | `_mkdir` at win_main.cpp:389 | `mkdir` with mode 0777 |
| `SysBackend._getcwd()` | `_getcwd` at win_main.cpp:400 | `getcwd` |
| `SysBackend.GetUserName()` | `GetUserName` at win_shared.cpp:302 | `getpwuid(geteuid())`, nil on a failure |
| `SysBackend.GlobalMemoryStatus()` | `dwTotalPhys` of `GlobalMemoryStatus` at win_main.cpp:50 and win_shared.cpp:330 | `sysconf` of the page count times the page size |
| `SysBackend.FreeLibrary(_:)` | `FreeLibrary` at win_main.cpp:727 | `dlclose` |
| `SysBackend.WSAGetLastError()` | `WSAGetLastError` at win_net.cpp:46 and every error site | `errno` |
| `SysBackend.strerror(_:)` | the switch of NET_ErrorString at win_net.cpp:47 | `strerror` |
| `SysBackend.udpSocket()` | `socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP )` at win_net.cpp:602 | `socket` with the same values |
| `SysBackend.ipxSocket()` | `socket( AF_IPX, SOCK_DGRAM, NSPROTO_IPX )` at win_net.cpp:958 | fails with `EAFNOSUPPORT` |
| `SysBackend.setNonBlocking(_:)` | `ioctlsocket` FIONBIO at win_net.cpp:611 and :967 | `fcntl` O_NONBLOCK |
| `SysBackend.setBroadcast(_:)` | `setsockopt` SO_BROADCAST at win_net.cpp:617 and :973 | `setsockopt` |
| `SysBackend.bind(_:_:)` | `bind` at win_net.cpp:638 and :988 | `bind` of the `sockaddr_in`, a failure for a record that is not IPv4 |
| `SysBackend.closesocket(_:)` | `closesocket` at win_net.cpp:640, :990, and NET_Config | `close` |
| `SysBackend.recvfrom(_:_:_:_:_:)` | `recvfrom` at win_net.cpp:272 | `recvfrom` into the `Slots<byte>` of the message, the sender converted to `Sockaddr` |
| `SysBackend.sendto(_:_:_:_:)` | `sendto` at win_net.cpp:447 | `sendto` of the `sockaddr_in`, a failure for a record that is not IPv4 |
| `SysBackend.gethostname()` | `gethostname` at win_net.cpp:852 | `gethostname` into 256 bytes, nil on a failure |
| `SysBackend.gethostbyname(_:)` | `gethostbyname` at win_net.cpp:206 and :858 | `gethostbyname`, the record copied into `Hostent` |
| `SysBackend.inet_addr(_:)` | `inet_addr` at win_net.cpp:199 | `inet_addr` |
| `SysBackend.ntohl(_:)` | `ntohl( *(int *)p )` at win_net.cpp:874 | the four bytes in network order |
| `SysBackend.htons(_:)` | `htons( (short)port )` at win_net.cpp:633 and :985 | the big-endian bytes |
| `INVALID_SOCKET`, `SOCKET_ERROR`, `WSAEWOULDBLOCK`, `WSAECONNRESET`, `WSAEAFNOSUPPORT`, `WSAEADDRNOTAVAIL` | the Winsock names | -1, -1, and the errno values of the same conditions |
| `SysBackend.AF_INET`, `.AF_IPX`, `.INADDR_ANY`, `.INADDR_BROADCAST` | the Winsock values | the Winsock values; the backend converts the family at each call |
| `Sockaddr` | `struct sockaddr` and its `sockaddr_in` and `sockaddr_ipx` casts | sixteen bytes in the Winsock layout, with Raven's field names |
| `Hostent` | `struct hostent` | the name, the aliases, the family, and the four bytes of each address |
| `NetadrToSockadr`, `SockadrToNetadr`, `Sys_StringToSockaddr` | win_net.cpp:97, :127, and :160 | Raven's bodies under Raven's names in the view target |

The three conversion functions live in the view target by the precedent of `ZoneTailFromHeader` in row 2 of `notes/2026-11-09/dedicated-open-rows-ledger-5.md`, because their stubs had a signature marker for `struct sockaddr *`. win_net.swift has no stub of these names, and a comment at each of Raven's lines points to the view target.

`EngineWorld.swift` gets six hand properties, each with Raven's name and a `Source:` line: `len` and `bPendingExtended` of Sys_ConsoleInput, `socksRelayAddr`, `ip_socket`, `socks_socket`, and the `lazy var sys_timeBase`, which sets its value on the first read, as C++ sets a static local. The stubs forward each one under Raven's name. The generator gave `ip_socket` and `socks_socket` a `let` with a `portMissing` initializer, which traps on the first read, so the forwards replace them. The init sets `variables.ipx_socket` to INVALID_SOCKET, the hand line that the generated `EngineVariables` names.

## The Win32 sites

| Site | Raven's call | The form on a POSIX host |
|---|---|---|
| Sys_Init, win_main.cpp:1270 | `timeBeginPeriod( 1 )` | drops, one AI line |
| Sys_Error and Sys_Quit, win_main.cpp:339 and :364 | `timeEndPeriod( 1 )` | drops, one AI line |
| Sys_Error, win_main.cpp:345 | the `GetMessage` loop that waits for a quit message | drops, so the shutdown and `exit(1)` run, one AI line |
| Sys_GetClipboardData, win_main.cpp:687 | the Win32 clipboard | returns an empty text, one AI line |
| CPUID, win_shared.cpp:84 | the `cpuid` instruction | stores nothing, one AI line |
| IsPentium, win_shared.cpp:102 | the EFLAGS ID test in assembly | returns Raven's `err:` arm, 0 |
| IsWIL, win_shared.cpp:206 | one Willamette instruction under `__try` | the test drops, and the arm returns Raven's qtrue |
| Is3DNOW, win_shared.cpp:142 | `CPUID( 0, ( unsigned int * ) pstring )` | drops, because CPUID stores nothing, and `pstring` stays zero |
| NET_Init, win_net.cpp:1171 | `WSAStartup` | `r = 0`, Raven's value for a success |
| NET_Shutdown, win_net.cpp:1199 | `WSACleanup` | drops |
| NET_ErrorString, win_net.cpp:47 | the switch over the Winsock codes | the `strerror` text of errno |
| main, win_main.cpp:1410 | `SetErrorMode` and the rest | stays in the shell, `Sources/jampded/main.swift`, unchanged |

## The two rows of ledger 5

- The C++ `bool` tested against zero in Sys_Milliseconds: the drafter still prints `if baseTime == 0`. The hand body reads `if !baseTime`, the form of a `qboolean`, so the stem has no compile hole. The drafter row stays open for the drafter.
- `Is3DNOW` handing `char pstring[16]` to CPUID at win_shared.cpp:142: closed by the CPUID form of this round. CPUID stores nothing on this host, so the call drops under one AI line.

## Rows for the user

- Row W1, the return of Sys_GetBotAIAPI. Raven line: `void *Sys_GetBotAIAPI (void *parms )` at win_main.cpp:30, which returns NULL. C type: `void *` return and `void *` parameter. Callers: none in the WinDed link set. Proposal: RETURNS kind `opaque`, the row of `CG_G2WeaponInstance`, so the stub returns `OpaquePointer?` and the body is `return nil`.
- Row W2, the x86 code checksum. Raven lines: Sys_FunctionCmp at win_main.cpp:59 and Sys_FunctionCheckSum at :128 read the x86 machine code at a function address. C type: `void *` of a function. Callers: none in the WinDed link set. Proposal: the stubs keep their markers until the client stage, the form of row Z6 of `notes/2026-11-08/dedicated-round-z-memman-pc.md`.
- Row W3, the char ** file list. Raven lines: `char **Sys_ListFiles(...)` at win_main.cpp:502, `char **psList` of Sys_ListFilteredFiles at :434, and of Sys_FreeFileList at :597. C type: `char **`, a NULL-terminated array of `CopyString` texts. Callers: FS_ListFilteredFiles of files_pc.cpp. The stubs give `psList` as `inout TextCursor`, which cannot hold a string per slot. Proposal: `psList` takes the `inout ArraySlice<String>` row of `char *infos[]` of `G_ParseInfos`, Sys_ListFiles returns `[String]?` with nil for NULL, and Sys_FreeFileList frees nothing, the form of the `CharBuf` overload of `FS_FreeFile`. The `_findfirst` walk then takes one backend function that lists the names and the subdirectory flags of a folder. Rule this row with the files_pc round, because both sides of the list change together.
- Row W4, Sys_LoadDll. Raven line: `void * QDECL Sys_LoadDll( const char *name, int (QDECL **entryPoint)(int, ...), int (QDECL *systemcalls)(int, ...) )` at win_main.cpp:784. C type: a pointer to the `vmMain` slot and the syscall entry. Callers: VM_Create at vm.cpp:518, a stub today. Proposal: the stub takes the `vm_t` slot of `entryPoint` as a PARAMS `slot` row and drops `systemcalls`, because the shell owns VM_DllSyscall. The body builds Raven's file name with the arch suffix of `tools/host-referee.sh`, `jampgamearm64.dylib` on Apple arm64, calls Sys_UnpackDLL, and tries the current folder, then `fs_basepath`, then `fs_cdpath`, as Raven does. The load is `jka_load_dll` of `Sources/CJKAHost/jka_host.c:30`, which already calls dlopen, resolves `dllEntry` and `vmMain`, and hands VM_DllSyscall to `dllEntry`. The logic target cannot import CJKAHost, so the shell installs one closure for that call at its entry, the form of `sharedChannel` in `Sources/jampded/main.swift`.
- Row W5, the sysEvent_t view. Raven lines: `sysEvent_t eventQue[MAX_QUED_EVENTS]` at win_main.cpp:1113, `sysEvent_t *ev` of Sys_QueEvent at :1127, and the return of Sys_GetEvent at :1160. C type: `sysEvent_t` of qcommon.h:934. Callers: Com_GetRealEvent of common.cpp for Sys_GetEvent, and Sys_GetEvent for Sys_QueEvent. Proposal: `HOST_ROOTS` takes `sysEvent_t`, the form of row 14 of `notes/2026-11-04/dedicated-open-rows-ledger.md` for `bitStorage_t`, so `eventQue` is a table on `EngineStorage`, `ev` is the view of a slot, and Sys_GetEvent returns the view of its scratch copy. Until then the server loop stops at Sys_GetEvent, so the console input and Sys_GetPacket have no caller that runs.
- Row W6, the vector of Sys_SnapVector. Raven line: `void Sys_SnapVector( float *v )` at win_shared.cpp:41, which steps `v` over three floats. C type: `float *`. Callers: the G_SNAPVECTOR arm of sv_game.cpp. The stub takes one `inout Float`. Proposal: the PARAMS row of `float *colors` of `BG_ValidateSkinForTeam`, `inout vec3_t`, and the body stores `Float` of each component rounded to the nearest even value, the default rounding of x87 `fistp`, under one AI line.
- Row W7, the CPU speed. Raven lines: Sys_GetCPUSpeedOld at win_shared.cpp:338 and Sys_GetCPUSpeed at :399 time the x86 `rdtsc` counter against the Win32 timers. Callers: none in the WinDed link set. Proposal: the stubs keep their markers until the client stage, the form of row W2.
- Row W8, SOCKS. Raven lines: NET_OpenSocks at win_net.cpp:653, and the SOCKS arm of Sys_SendPacket at :436, which stores an int and a short into `char socksBuf[4096]`. C types: `unsigned char buf[64]` and `char socksBuf[4096]`. Callers: NET_OpenIP when `net_socksEnabled` is not 0, its default. `usingSocks` stays false until NET_OpenSocks runs, so the SOCKS arm of Sys_SendPacket has no path today. Proposal: `socksBuf` and `buf` become `Slots<byte>` allocations on `EngineStorage`, the form of `BYTE_STORAGE_LOCALS`, so the stores read `socksBuf[int: 4]` and `socksBuf[ushort: 8]`, and the backend takes a TCP socket, `connect`, `send`, and `recv`.
- Row W9, the storage of the socket statics. Raven lines: `static SOCKET ip_socket = INVALID_SOCKET` and `socks_socket` at win_net.cpp:27 and :28, `socksRelayAddr` at :22, and the static locals `len`, `bPendingExtended`, and `sys_timeBase`. The generator reads the Winsock initializer as no initializer, so it gave the two sockets a trapping `let`. Proposal: the skeleton gives the two sockets `EngineVariables` storage with the hand line of `ipx_socket`, and the hand properties of `EngineWorld` for them go in that commit. The other four stay hand properties.
- Row W10, the Linux and Windows lanes of `SysBackend.swift`. The macOS build proves the `Darwin` arm. The `Glibc` arm reads `SOCK_DGRAM.rawValue` and has no other branch, and the next CI push builds it in the test job. No lane builds jampded on Windows, so the file has no `ucrt` arm. Proposal: no change until a lane shows an error.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| Sys_GetBotAIAPI | win_main.cpp:30 | signature marker | W1 |
| Sys_FunctionCmp | win_main.cpp:59 | the x86 code scan | W2 |
| Sys_FunctionCheckSum | win_main.cpp:128 | the x86 code scan | W2 |
| Sys_ListFilteredFiles | win_main.cpp:434 | `char **psList` | W3 |
| Sys_ListFiles | win_main.cpp:502 | signature marker | W3 |
| Sys_FreeFileList | win_main.cpp:597 | `char **psList` | W3 |
| Sys_LoadDll | win_main.cpp:784 | signature marker | W4 |
| Sys_QueEvent | win_main.cpp:1127 | `sysEvent_t *ev` | W5 |
| Sys_GetEvent | win_main.cpp:1160 | signature marker | W5 |
| Sys_SnapVector | win_shared.cpp:41 | `float *v` | W6 |
| Sys_GetCPUSpeedOld | win_shared.cpp:338 | `rdtsc` | W7 |
| Sys_GetCPUSpeed | win_shared.cpp:399 | `rdtsc` | W7 |
| NET_OpenSocks | win_net.cpp:653 | the SOCKS client | W8 |
| Sys_SendPacket | win_net.cpp:436 | the SOCKS arm | W8 |

The `portMissing` count per file: win_main.swift 9, win_shared.swift 3, and win_net.swift 2. The globals `cls` and `eventQue` of win_main.swift keep their `TODO: Port global` markers.

## The run

`jampded` with standard input from `/dev/null` now passes Sys_Milliseconds and Sys_InitStreamThread and stops at the Com_Init stub of common.swift, `TODO: Port Com_Init`, exit 133. The jampded smoke test passes on that stop.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors, 0 warnings in the gate run, a warm build |
| `swift test --no-parallel -j 2` | exit 0, 146 tests, 145 pass, 1 skipped, the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem win_main` | exit 0, 15 of 38 hand functions replaced, 23 kept, 66 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem win_shared` | exit 0, 5 of 15 hand functions replaced, 10 kept, 18 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem win_net` | exit 0, 6 of 18 hand functions replaced, 12 kept, 78 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The first full build of the round printed five warnings in the stems, at Raven's lines: the dropped results of FS_Seek, Cvar_Get, and NET_GetCvars, the unread `error` of NET_GetLocalAddress, and the arm after `r = 0` in NET_Init that never runs.
