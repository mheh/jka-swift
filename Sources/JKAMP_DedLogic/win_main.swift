import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/win_main.cpp:16
let CD_BASEDIR = "gamedata\\gamedata"

/// Source: oracle/codemp/null/win_main.cpp:17
let CD_EXE = "jamp.exe"

/// Source: oracle/codemp/null/win_main.cpp:18
let CD_BASEDIR_LINUX = "bin\\u{86}\\glibc-2.1"

/// Source: oracle/codemp/null/win_main.cpp:19
let CD_EXE_LINUX = "jamp"

/// Source: oracle/codemp/null/win_main.cpp:20
let CD_VOLUME = "JEDIACAD"

/// Source: oracle/codemp/null/win_main.cpp:21
let MEM_THRESHOLD = 128 * 1024 * 1024 as Int32

/// Source: oracle/codemp/null/win_main.cpp:23
// Raven wrote: static char sys_cmdline[MAX_STRING_CHARS]
nonisolated(unsafe) let sys_cmdline: JKAShared.CharBuf = JKAShared.CharBuf(Int(JKAShared.MAX_STRING_CHARS))

/// Source: oracle/codemp/null/win_main.cpp:24
// TODO: Port global cls
// Raven wrote: clientStatic_t cls
// No view for `clientStatic_t` of `client.h`.

/// Source: oracle/codemp/null/win_main.cpp:26
// Raven wrote: static int sys_monkeySpank
let sys_monkeySpank: Int32 = 0

/// Source: oracle/codemp/null/win_main.cpp:27
// Raven wrote: static int sys_checksum
let sys_checksum: Int32 = 0

/// Source: oracle/codemp/null/win_main.cpp:190
var g_consoleField1: JKAShared.CharBuf {
    get { world.variables.g_consoleField1 }
    set { world.variables.g_consoleField1 = newValue }
}

/// Source: oracle/codemp/null/win_main.cpp:191
var g_consoleField2: JKAShared.CharBuf {
    get { world.variables.g_consoleField2 }
    set { world.variables.g_consoleField2 = newValue }
}

/// Source: oracle/codemp/null/win_main.cpp:432
private let MAX_FOUND_FILES = 0x1000 as Int32

/// Source: oracle/codemp/null/win_main.cpp:1110
private let MAX_QUED_EVENTS = 256 as Int32

/// Source: oracle/codemp/null/win_main.cpp:1111
private let MASK_QUED_EVENTS = (JKAMP_Ded.MAX_QUED_EVENTS - 1)

/// Source: oracle/codemp/null/win_main.cpp:1113
var eventQue: Slots<SysEvent> { world.storage.eventQue }

/// Source: oracle/codemp/null/win_main.cpp:1114
var eventHead: Int32 {
    get { world.variables.eventHead }
    set { world.variables.eventHead = newValue }
}

/// Source: oracle/codemp/null/win_main.cpp:1115
var eventTail: Int32 {
    get { world.variables.eventTail }
    set { world.variables.eventTail = newValue }
}

/// Source: oracle/codemp/null/win_main.cpp:1116
var sys_packetReceived: Slots<JKAShared.byte> { world.storage.sys_packetReceived }

/// Source: oracle/codemp/null/win_main.cpp:1162
// AI: Raven declares `ev` on the stack of Sys_GetEvent. The function uses one zeroed allocation on the storage class.
private var ev_Sys_GetEvent: SysEvent { world.storage.win_main_ev_Sys_GetEvent }

/// Source: oracle/codemp/null/win_main.cpp:1262
let OSR2_BUILD_NUMBER = 1111 as Int32

/// Source: oracle/codemp/null/win_main.cpp:1263
let WIN98_BUILD_NUMBER = 1998 as Int32

/// Source: oracle/codemp/null/win_main.cpp:30
func Sys_GetBotAIAPI(_ parms: OpaquePointer?) -> OpaquePointer? {
    return nil
}

/// Source: oracle/codemp/null/win_main.cpp:34
func Conbuf_AppendText(_ pMsg: String) {
    var msg = CharBuf(4096)
    strcpy(&msg, pMsg)
    Q_CleanStr(&msg)
    // Port-note: Raven hands the text to printf as its format, so a `%` in the text reads an argument that is not there.
    // The body prints the text as it stands.
    // AI: Raven called the C printf twice. The backend writes the bytes of each buffer to standard output.
    SysBackend.printf(msg)
    SysBackend.printf("\n")
}

/// Source: oracle/codemp/null/win_main.cpp:48
func Sys_LowPhysicalMemory() -> Bool {
    // AI: Raven filled a MEMORYSTATUS with the Win32 GlobalMemoryStatus. The backend gives its `dwTotalPhys` from the page count of the platform.
    let dwTotalPhys = SysBackend.GlobalMemoryStatus()
    return (dwTotalPhys <= MEM_THRESHOLD) ? true : false
}

/**
```
==================
Sys_FunctionCmp
==================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:59
func Sys_FunctionCmp(_ f1: OpaquePointer?, _ f2: OpaquePointer?) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // AI: Raven scanned the x86 opcodes of the function body. The host runs no x86 code, so the body takes Raven's unix return.
    return 1
}

/**
```
==================
Sys_FunctionCheckSum
==================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:128
func Sys_FunctionCheckSum(_ f1: OpaquePointer?) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // AI: Raven scanned the x86 opcodes of the function body. The host runs no x86 code, so the body takes Raven's unix return.
    return 0
}

/**
```
==================
Sys_MonkeyShouldBeSpanked
==================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:171
func Sys_MonkeyShouldBeSpanked() -> Int32 {
    return sys_monkeySpank
}

/**
```
==================
Sys_VerifyCodeChecksum
==================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:181
func Sys_VerifyCodeChecksum(_ codeBase: OpaquePointer?) {
}

/// Source: oracle/codemp/null/win_main.cpp:193
private func PrintMatches(_ s: String) {
    if Q_stricmpn(s, String(g_consoleField1), strlen(g_consoleField1)) == 0 {
        // AI: Raven called the C printf. The backend writes the bytes of the formatted text to standard output.
        SysBackend.printf(CharBuf(JKAShared.format("    %s\n", [s])))
    }
}

/// Source: oracle/codemp/null/win_main.cpp:204
var len: Int32 {
    get { world.len }
    set { world.len = newValue }
}

/// Source: oracle/codemp/null/win_main.cpp:205
var bPendingExtended: Bool {
    get { world.bPendingExtended }
    set { world.bPendingExtended = newValue }
}

//qboolean stdin_active = qtrue;
/// Source: oracle/codemp/null/win_main.cpp:200
func Sys_ConsoleInput() -> String? {
    let ClearLine = CharBuf("\r                                                                               \r")

    // AI: Raven called the conio kbhit. The backend polls standard input with no wait.
    if !SysBackend.kbhit() {
        return nil
    }

    if len == 0 {
        g_consoleField1.zero()
    }

    // AI: Raven called the conio getch. The backend reads one byte from standard input.
    g_consoleField1[len] = SysBackend.getch()

    // AI: Raven called the C printf for every echo below. The backend writes the bytes of each text to standard output.
    if bPendingExtended {
        switch g_consoleField1[len] as Int32 {
        case Int32(ascii: "H"): //up
            strcpy(&g_consoleField1, String(g_consoleField2))
            SysBackend.printf(ClearLine)
            SysBackend.printf(CharBuf(JKAShared.format("%s", [g_consoleField1])))
            len = strlen(g_consoleField1)

        case Int32(ascii: "K"): //left
            break

        case Int32(ascii: "M"): //right
            break

        case Int32(ascii: "P"): //down
            break

        default:
            break
        }
        g_consoleField1[len] = 0 //erase last key hit
        bPendingExtended = false
    } else {
        switch Int32(UInt8(truncatingIfNeeded: g_consoleField1[len] as Int32)) {
        case 0x00: //fkey is next
            fallthrough

        case 0xe0: //extended = arrow keys
            g_consoleField1[len] = 0 //erase last key hit
            bPendingExtended = true

        case 8: // backspace
            SysBackend.printf(CharBuf(JKAShared.format("%c %c", [g_consoleField1[len] as Int32, g_consoleField1[len] as Int32])))
            g_consoleField1[len] = 0
            if len > 0 {
                len -= 1
            }
            g_consoleField1[len] = 0

        case 9: //Tab
            if len != 0 {
                g_consoleField1[len] = 0 //erase last key hit
                SysBackend.printf("\n")
                // run through again, printing matches
                Cmd_CommandCompletion(PrintMatches)
                Cvar_CommandCompletion(PrintMatches)
                SysBackend.printf(CharBuf(JKAShared.format("\n%s", [g_consoleField1])))
            }

        case 27: // esc
            // clear the line
            SysBackend.printf(ClearLine)
            len = 0

        case Int32(ascii: "\r"): //enter
            g_consoleField1[len] = 0 //erase last key hit
            SysBackend.printf("\n")
            if len != 0 {
                len = 0
                strcpy(&g_consoleField2, String(g_consoleField1))
                return String(g_consoleField1)
            }

        case Int32(ascii: "v") - Int32(ascii: "a") + 1: // ctrl-v is paste
            g_consoleField1[len] = 0 //erase last key hit
            var cbd: String
            cbd = Sys_GetClipboardData()
            // Port-note: Raven copies up to the whole size of the buffer from the offset `len`, which runs past the end when `len` is above 0.
            // The copy stops at the end of the buffer.
            strncpy(&g_consoleField1, cbd, Int32(g_consoleField1.count) - len, at: len)
            SysBackend.printf(CharBuf(JKAShared.format("%s", [cbd])))
            len += strlen(cbd)
            // AI: Raven frees the Z_Malloc block of the clipboard text. The text is a `String` that owns no block, so the free drops.
            if len == g_consoleField1.count {
                len = 0
                return String(g_consoleField1)
            }

        default:
            SysBackend.printf(CharBuf(JKAShared.format("%c", [g_consoleField1[len] as Int32])))
            len += 1
            if len == g_consoleField1.count {
                len = 0
                return String(g_consoleField1)
            }
        }
    }

    return nil
}

/**
```
==================
Sys_BeginProfiling
==================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:309
func Sys_BeginProfiling() {
    // this is just used on the mac build
}

/// Source: oracle/codemp/null/win_main.cpp:313
public func Sys_ShowConsole(_ visLevel: Int32, _ quitOnClose: Bool) {
}

/**
```
=============
Sys_Error

Show the early console as an error dialog
=============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:324
func Sys_Error(_ error: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(4096)

    strcpy(&text, JKAShared.format(error, args))

    Conbuf_AppendText(String(text))
    Conbuf_AppendText("\n")

    //	Sys_SetErrorText( text );
    Sys_ShowConsole(1, true)

    // AI: Raven called the Win32 timeEndPeriod for the timer resolution of Sys_Init. A POSIX host has no such resolution, so the call drops.

    IN_Shutdown()

    // wait for the user to quit
    // AI: Raven pumped the Win32 messages until a quit message came.
    // A POSIX console host has no message queue, so the wait drops and the shutdown runs.

    //	Sys_DestroyConsole();
    Com_ShutdownZoneMemory()
    Com_ShutdownHunkMemory()

    exit(1)
}

/**
```
==============
Sys_Quit
==============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:363
func Sys_Quit() {
    // AI: Raven called the Win32 timeEndPeriod for the timer resolution of Sys_Init. A POSIX host has no such resolution, so the call drops.
    IN_Shutdown()
    //	Sys_DestroyConsole();
    Com_ShutdownZoneMemory()
    Com_ShutdownHunkMemory()

    exit(0)
}

/**
```
==============
Sys_Print
==============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:378
func Sys_Print(_ msg: String) {
    Conbuf_AppendText(msg)
}

/**
```
==============
Sys_Mkdir
==============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:388
func Sys_Mkdir(_ path: String) {
    // AI: Raven called the Win32 _mkdir. The backend calls the POSIX mkdir with every permission bit, which the umask narrows.
    SysBackend._mkdir(path)
}

/**
```
==============
Sys_Cwd
==============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:397
func Sys_Cwd() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var cwd = CharBuf(MAX_OSPATH)

    // AI: Raven called the Win32 _getcwd into the buffer. The backend calls the POSIX getcwd and returns its text.
    strncpy(&cwd, SysBackend._getcwd(), Int32(cwd.count) - 1)
    cwd[MAX_OSPATH - 1] = 0

    return String(cwd)
}

/**
```
==============
Sys_DefaultCDPath
==============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:411
func Sys_DefaultCDPath() -> String {
    return ""
}

/**
```
==============
Sys_DefaultBasePath
==============
```
*/
/// Source: oracle/codemp/null/win_main.cpp:420
func Sys_DefaultBasePath() -> String {
    return Sys_Cwd()
}

/// Source: oracle/codemp/null/win_main.cpp:434
func Sys_ListFilteredFiles(_ basedir: String, _ subdirs: inout JKAShared.CharBuf, _ filter: String?, _ psList: inout ArraySlice<String>, _ numfiles: inout Int32) {
    var search = CharBuf(MAX_OSPATH)
    var newsubdirs = CharBuf(MAX_OSPATH)
    var filename = CharBuf(MAX_OSPATH)
    let findhandle: Int32
    var findinfo = _finddata_t()

    if numfiles >= MAX_FOUND_FILES - 1 {
        return
    }

    if strlen(subdirs) != 0 {
        Com_sprintf(&search, Int32(search.count), "%s\\%s\\*", basedir, subdirs)
    } else {
        Com_sprintf(&search, Int32(search.count), "%s\\*", basedir)
    }

    findhandle = SysBackend._findfirst(search, &findinfo)
    if findhandle == -1 {
        return
    }

    repeat {
        if (findinfo.attrib & _A_SUBDIR) != 0 {
            if Q_stricmp(findinfo.name, ".") != 0 && Q_stricmp(findinfo.name, "..") != 0 {
                if strlen(subdirs) != 0 {
                    Com_sprintf(&newsubdirs, Int32(newsubdirs.count), "%s\\%s", subdirs, findinfo.name)
                } else {
                    Com_sprintf(&newsubdirs, Int32(newsubdirs.count), "%s", findinfo.name)
                }
                Sys_ListFilteredFiles(basedir, &newsubdirs, filter, &psList, &numfiles)
            }
        }
        if numfiles >= MAX_FOUND_FILES - 1 {
            break
        }
        Com_sprintf(&filename, Int32(filename.count), "%s\\%s", subdirs, findinfo.name)
        if Com_FilterPath(filter, String(filename), 0) == 0 {
            continue
        }
        psList[psList.startIndex + numfiles] = CopyString(String(filename))
        numfiles += 1
    } while SysBackend._findnext(findhandle, &findinfo) != -1

    SysBackend._findclose(findhandle)
}

/// Source: oracle/codemp/null/win_main.cpp:481
private func strgtr(_ s0: String, _ s1: String) -> Bool {
    var l0: Int32
    let l1: Int32
    var i: Int32
    let s0 = CharBuf(s0)
    let s1 = CharBuf(s1)

    l0 = strlen(s0)
    l1 = strlen(s1)

    if l1 < l0 {
        l0 = l1
    }

    i = 0
    while i < l0 {
        if (s1[i] as Int32) > (s0[i] as Int32) {
            return true
        }
        if (s1[i] as Int32) < (s0[i] as Int32) {
            return false
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/null/win_main.cpp:502
func Sys_ListFiles(_ directory: String, _ `extension`: String?, _ filter: String?, _ numfiles: inout Int32, _ wantsubs: Bool) -> [String] {
    var search = CharBuf(MAX_OSPATH)
    var nfiles: Int32
    var listCopy: [String]
    var list = [String](repeating: "", count: Int(MAX_FOUND_FILES))
    var findinfo = _finddata_t()
    let findhandle: Int32
    var flag: Int32
    var i: Int32
    // Raven assigns his own `extension` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var `extension` = `extension`

    if filter != nil {

        nfiles = 0
        var subdirs: CharBuf = ""
        Sys_ListFilteredFiles(directory, &subdirs, filter, &list[...], &nfiles)

        list[nfiles] = ""
        numfiles = nfiles

        if nfiles == 0 {
            return []
        }

        // AI: Raven copies the list into a Z_Malloc table with a NULL at the end. The array is the table, and its count ends the list.
        listCopy = [String](repeating: "", count: Int(nfiles))
        i = 0
        while i < nfiles {
            listCopy[i] = list[i]
            i += 1
        }

        return listCopy
    }

    if `extension` == nil {
        `extension` = ""
    }

    // passing a slash as extension will find directories
    if CharBuf(`extension`!)[0] == Int32(ascii: "/") && CharBuf(`extension`!)[1] == 0 {
        `extension` = ""
        flag = 0
    } else {
        flag = _A_SUBDIR
    }

    Com_sprintf(&search, Int32(search.count), "%s\\*%s", directory, `extension`!)

    // search
    nfiles = 0

    findhandle = SysBackend._findfirst(search, &findinfo)
    if findhandle == -1 {
        numfiles = 0
        return []
    }

    repeat {
        if (!wantsubs && (flag ^ (findinfo.attrib & _A_SUBDIR)) != 0) || (wantsubs && (findinfo.attrib & _A_SUBDIR) != 0) {
            if nfiles == MAX_FOUND_FILES - 1 {
                break
            }
            list[nfiles] = CopyString(findinfo.name)
            nfiles += 1
        }
    } while SysBackend._findnext(findhandle, &findinfo) != -1

    list[nfiles] = ""

    SysBackend._findclose(findhandle)

    // return a copy of the list
    numfiles = nfiles

    if nfiles == 0 {
        return []
    }

    // AI: Raven copies the list into a Z_Malloc table with a NULL at the end. The array is the table, and its count ends the list.
    listCopy = [String](repeating: "", count: Int(nfiles))
    i = 0
    while i < nfiles {
        listCopy[i] = list[i]
        i += 1
    }

    repeat {
        flag = 0
        i = 1
        while i < nfiles {
            if strgtr(listCopy[i - 1], listCopy[i]) {
                let temp = listCopy[i]
                listCopy[i] = listCopy[i - 1]
                listCopy[i - 1] = temp
                flag = 1
            }
            i += 1
        }
    } while flag != 0

    return listCopy
}

/// Source: oracle/codemp/null/win_main.cpp:597
func Sys_FreeFileList(_ psList: [String]) {
    // AI: Raven frees each CopyString text and the Z_Malloc table. The list is a Swift array that frees itself, so the function frees nothing.
}

/**
```
================
Sys_CheckCD

Return true if the proper CD is in the drive
================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:672
func Sys_CheckCD() -> Bool {
    //	return Sys_ScanForCD();
    return true
}

/**
```
================
Sys_GetClipboardData

================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:687
func Sys_GetClipboardData() -> String {
    // AI: Raven copied the Win32 clipboard text into a Z_Malloc block.
    // A dedicated POSIX host has no clipboard, so the function returns an empty text.
    return ""
}

/**
```
=================
Sys_UnloadDll

=================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:723
func Sys_UnloadDll(_ dllHandle: OpaquePointer?) {
    if dllHandle == nil {
        return
    }
    // AI: Raven called the Win32 FreeLibrary. The backend calls the POSIX dlclose.
    if !SysBackend.FreeLibrary(dllHandle!) {
        Com_Error(ERR_FATAL, "Sys_UnloadDll FreeLibrary failed")
    }
}

//make sure the dll can be opened by the file system, then write the
//file back out again so it can be loaded is a library. If the read
//fails then the dll is probably not in the pk3 and we are running
//a pure server -rww
/// Source: oracle/codemp/null/win_main.cpp:735
func Sys_UnpackDLL(_ name: String) -> Bool {
    // AI: Raven reads the dll into a `void *` block of the zone. The read takes the CharBuf form of FS_ReadFile, whose bytes the CharBuf FS_Write takes.
    // The buffer starts as an empty CharBuf, because Raven hands FS_ReadFile the address `&data`, and a nil buffer is his NULL, which asks for the length alone.
    var data: CharBuf? = CharBuf(0)
    let f: fileHandle_t
    let len: Int32 = FS_ReadFile(name, &data)
    var ck: Int32 = 0

    if len < 1 {
        //failed to read the file (out of the pk3 if pure)
        return false
    }

    if FS_FileIsInPAK(name, &ck) == -1 {
        //alright, it isn't in a pk3 anyway, so we don't need to write it.
        //this is allowable when running non-pure.
        FS_FreeFile(data!)
        return true
    }

    f = FS_FOpenFileWrite(name)
    if f == 0 {
        //can't open for writing? Might be in use.
        //This is possibly a malicious user attempt to circumvent dll
        //replacement so we won't allow it.
        FS_FreeFile(data!)
        return false
    }

    if FS_Write(data!, len, f) < len {
        //Failed to write the full length. Full disk maybe?
        FS_FreeFile(data!)
        return false
    }

    FS_FCloseFile(f)
    FS_FreeFile(data!)

    return true
}

/// Source: oracle/codemp/null/win_main.cpp:784
func Sys_LoadDll(_ name: String, _ entryPoint: UnsafeMutableRawPointer, _ systemcalls: OpaquePointer?) -> OpaquePointer? {
    var libHandle: OpaquePointer?
    let basepath: String
    let homepath: String
    let cdpath: String
    let gamedir: String
    var fn: String
    var filename = CharBuf(MAX_QPATH)

    // AI: Raven names the Windows dll `%sx86.dll`. The name takes DLL_SUFFIX, the arch and the library extension of the build, `jampgamearm64.dylib` on Apple arm64.
    Com_sprintf(&filename, Int32((filename).count), "%s%s", name, DLL_SUFFIX)

    if !Sys_UnpackDLL(String(filename)) {
        return nil
    }

    // rjr disable for final release #ifndef NDEBUG
    // AI: Raven calls the Win32 LoadLibrary. The call is the loader closure that the shell installs over jka_load_library.
    libHandle = LoadLibrary!(String(filename))
    if libHandle == nil {
        //#endif
        basepath = Cvar_VariableString("fs_basepath")
        homepath = Cvar_VariableString("fs_homepath")
        cdpath = Cvar_VariableString("fs_cdpath")
        gamedir = Cvar_VariableString("fs_game")

        // AI: Raven looks under fs_basepath and fs_cdpath. The lookup looks under fs_homepath first, as the fork's loader does, so one mod folder serves both hosts.
        fn = FS_BuildOSPath(homepath, gamedir, String(filename))
        libHandle = LoadLibrary!(fn)

        if libHandle == nil {
            fn = FS_BuildOSPath(basepath, gamedir, String(filename))
            libHandle = LoadLibrary!(fn)
        }

        if libHandle == nil {
            if !cdpath.isEmpty {
                fn = FS_BuildOSPath(cdpath, gamedir, String(filename))
                libHandle = LoadLibrary!(fn)
            }

            if libHandle == nil {
                return nil
            }
        }
        //#ifndef NDEBUG
    }
    //#endif

    // AI: Raven reads dllEntry and vmMain with GetProcAddress, and hands `systemcalls` to dllEntry.
    // The call is the closure that the shell installs over jka_dll_entry, which hands the module the C VM_DllSyscall.
    if !GetProcAddress!(libHandle!, entryPoint) {
        // AI: Raven called the Win32 FreeLibrary. The backend calls the POSIX dlclose.
        _ = SysBackend.FreeLibrary(libHandle!)
        return nil
    }

    return libHandle
}

/// Source: oracle/codemp/null/win_main.cpp:849
public func Sys_InitStreamThread() {
}

/// Source: oracle/codemp/null/win_main.cpp:852
func Sys_ShutdownStreamThread() {
}

/// Source: oracle/codemp/null/win_main.cpp:855
func Sys_BeginStreamedFile(_ f: JKAShared.fileHandle_t, _ readAhead: Int32) {
}

/// Source: oracle/codemp/null/win_main.cpp:858
func Sys_EndStreamedFile(_ f: JKAShared.fileHandle_t) {
}

/// Source: oracle/codemp/null/win_main.cpp:861
func Sys_StreamedRead(_ buffer: Slots<JKAShared.byte>, _ size: Int32, _ count: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    return FS_Read(buffer, size * count, f)
}

/// Source: oracle/codemp/null/win_main.cpp:865
func Sys_StreamSeek(_ f: JKAShared.fileHandle_t, _ offset: Int32, _ origin: Int32) {
    FS_Seek(f, CLong(offset), origin)
}

/**
```
================
Sys_QueEvent

A time of 0 will get the current time
Ptr should either be null, or point to a block of data that can
be freed by the game later.
================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:1127
func Sys_QueEvent(_ time: Int32, _ type: sysEventType_t, _ value: Int32, _ value2: Int32, _ ptrLength: Int32, _ ptr: UnsafeMutableRawPointer) {
    let ev: SysEvent
    // Raven assigns his own `time` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var time = time

    ev = eventQue[eventHead & MASK_QUED_EVENTS]
    if eventHead - eventTail >= MAX_QUED_EVENTS {
        Com_Printf("Sys_QueEvent: overflow\n")
        // we are discarding an event, but don't leak memory
        if ev.evPtr != nil {
            // AI: Raven frees the `void *` field. Z_Free takes the handle of the block.
            Z_Free(OpaquePointer(ev.evPtr))
        }
        eventTail += 1
    }

    eventHead += 1

    if time == 0 {
        time = Sys_Milliseconds()
    }

    ev.evTime = time
    ev.evType = type
    ev.evValue = value
    ev.evValue2 = value2
    ev.evPtrLength = ptrLength
    ev.evPtr = ptr
}

/**
```
================
Sys_GetEvent

================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:1160
func Sys_GetEvent() -> SysEvent {
    let ev = ev_Sys_GetEvent
    let s: String?

    // return if we have data
    if eventHead > eventTail {
        eventTail += 1
        return eventQue[(eventTail - 1) & MASK_QUED_EVENTS]
    }

    // pump the message loop
    // AI: Raven pumps the Win32 message loop with PeekMessage, GetMessage, TranslateMessage, and DispatchMessage. A dedicated server on another platform has no such loop, so the pump drops.

    // check for console commands
    s = Sys_ConsoleInput()
    if s != nil {
        let len: Int32

        len = strlen(s!) + 1
        let b = Z_Malloc(len, TAG_EVENT)
        // AI: Raven copies the text with Q_strncpyz at its length plus the NUL. strcpy into the raw block writes the same bytes.
        strcpy(b, s!)
        Sys_QueEvent(0, SE_CONSOLE, 0, 0, len, b)
    }

    // check for network packets
    Msg.scratch { netmsg in
        Netadr.scratch { adr in
            MSG_Init(netmsg, sys_packetReceived, Int32(sys_packetReceived.count))
            if Sys_GetPacket(adr, netmsg) {
                let len: Int32

                // copy out to a seperate buffer for qeueing
                // the readcount stepahead is for SOCKS support
                len = Int32(Netadr.byteCount) + netmsg.cursize - netmsg.readcount
                let buf = Z_Malloc(len, TAG_EVENT, true)
                Netadr(buf).copy(from: adr)
                // AI: Raven copies the data after the record, to `buf+1`. The copy writes the tail of the block from the byte offset of one record.
                Com_Memcpy(Slots<JKAShared.byte>(scalars: buf, count: Int(len)).suffix(from: Netadr.byteCount), netmsg.data!.suffix(from: netmsg.readcount), netmsg.cursize - netmsg.readcount)
                Sys_QueEvent(0, SE_PACKET, 0, 0, len, buf)
            }
        }
    }

    // return if we have data
    if eventHead > eventTail {
        eventTail += 1
        return eventQue[(eventTail - 1) & MASK_QUED_EVENTS]
    }

    // create an empty event to return

    ev.clear()
    // AI: Raven reads the Win32 timeGetTime. The backend reads the monotonic clock of the platform.
    ev.evTime = SysBackend.timeGetTime()

    return ev
}

/**
```
=================
Sys_In_Restart_f

Restart the input subsystem
=================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:1236
func Sys_In_Restart_f() {
    IN_Shutdown()
    IN_Init()
}

/**
```
=================
Sys_Net_Restart_f

Restart the network subsystem
=================
```
*/
/// Source: oracle/codemp/null/win_main.cpp:1249
func Sys_Net_Restart_f() {
    NET_Restart()
}

/// Source: oracle/codemp/null/win_main.cpp:1265
func Sys_Init() {
    var cpuid: Int32

    // make sure the timer is high precision, otherwise
    // NT gets 18ms resolution
    // AI: Raven called the Win32 timeBeginPeriod for a 1 ms timer. The POSIX clock has no such mode, so the call drops.

    Cmd_AddCommand("in_restart", Sys_In_Restart_f)
    Cmd_AddCommand("net_restart", Sys_Net_Restart_f)

    //	g_wv.osversion.dwOSVersionInfoSize = sizeof( g_wv.osversion );

    //	if (!GetVersionEx (&g_wv.osversion))
    //		Sys_Error ("Couldn't get OS info");

    //	if (g_wv.osversion.dwMajorVersion < 4)
    //		Sys_Error ("This game requires Windows version 4 or greater");
    //	if (g_wv.osversion.dwPlatformId == VER_PLATFORM_WIN32s)
    //		Sys_Error ("This game doesn't run on Win32s");

    //	if ( g_wv.osversion.dwPlatformId == VER_PLATFORM_WIN32_NT )
    //	{
    //		Cvar_Set( "arch", "winnt" );
    //	}
    //	else if ( g_wv.osversion.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS )
    //	{
    //		if ( LOWORD( g_wv.osversion.dwBuildNumber ) >= WIN98_BUILD_NUMBER )
    //		{
    //			Cvar_Set( "arch", "win98" );
    //		}
    //		else if ( LOWORD( g_wv.osversion.dwBuildNumber ) >= OSR2_BUILD_NUMBER )
    //		{
    //			Cvar_Set( "arch", "win95 osr2.x" );
    //		}
    //		else
    //		{
    //			Cvar_Set( "arch", "win95" );
    //		}
    //	}
    //	else
    //	{
    //		Cvar_Set( "arch", "unknown Windows variant" );
    //	}

    // save out a couple things in rom cvars for the renderer to access
    //	Cvar_Get( "win_hinstance", va("%i", (int)g_wv.hInstance), CVAR_ROM );
    //	Cvar_Get( "win_wndproc", va("%i", (int)MainWndProc), CVAR_ROM );

    //
    // figure out our CPU
    //
    Cvar_Get("sys_cpustring", "detect", 0)
    if Q_stricmp(Cvar_VariableString("sys_cpustring"), "detect") == 0 {
        Com_Printf("...detecting CPU, found ")

        cpuid = Sys_GetProcessorId()

        switch cpuid {
        case CPUID_GENERIC:
            Cvar_Set("sys_cpustring", "generic")

        case CPUID_INTEL_UNSUPPORTED:
            Cvar_Set("sys_cpustring", "x86 (pre-Pentium)")

        case CPUID_INTEL_PENTIUM:
            Cvar_Set("sys_cpustring", "x86 (P5/PPro, non-MMX)")

        case CPUID_INTEL_MMX:
            Cvar_Set("sys_cpustring", "x86 (P5/Pentium2, MMX)")

        case CPUID_INTEL_KATMAI:
            Cvar_Set("sys_cpustring", "Intel Pentium III")

        case CPUID_INTEL_WILLIAMETTE:
            Cvar_Set("sys_cpustring", "Intel Pentium IV")

        case CPUID_AMD_3DNOW:
            Cvar_Set("sys_cpustring", "AMD w/ 3DNow!")

        case CPUID_AXP:
            Cvar_Set("sys_cpustring", "Alpha AXP")

        default:
            Com_Error(ERR_FATAL, "Unknown cpu type %d\n", cpuid)
        }
    } else {
        Com_Printf("...forcing CPU type to ")
        if Q_stricmp(Cvar_VariableString("sys_cpustring"), "generic") == 0 {
            cpuid = CPUID_GENERIC
        } else if Q_stricmp(Cvar_VariableString("sys_cpustring"), "x87") == 0 {
            cpuid = CPUID_INTEL_PENTIUM
        } else if Q_stricmp(Cvar_VariableString("sys_cpustring"), "mmx") == 0 {
            cpuid = CPUID_INTEL_MMX
        } else if Q_stricmp(Cvar_VariableString("sys_cpustring"), "3dnow") == 0 {
            cpuid = CPUID_AMD_3DNOW
        } else if Q_stricmp(Cvar_VariableString("sys_cpustring"), "PentiumIII") == 0 {
            cpuid = CPUID_INTEL_KATMAI
        } else if Q_stricmp(Cvar_VariableString("sys_cpustring"), "PentiumIV") == 0 {
            cpuid = CPUID_INTEL_WILLIAMETTE
        } else if Q_stricmp(Cvar_VariableString("sys_cpustring"), "axp") == 0 {
            cpuid = CPUID_AXP
        } else {
            Com_Printf("WARNING: unknown sys_cpustring '%s'\n", Cvar_VariableString("sys_cpustring"))
            cpuid = CPUID_GENERIC
        }
    }
    Cvar_SetValue("sys_cpuid", Float(cpuid))
    Com_Printf("%s\n", Cvar_VariableString("sys_cpustring"))

    Cvar_Set("username", Sys_GetCurrentUser())

    IN_Init() // FIXME: not in dedicated?
}

/**
```
==================
WinMain

==================
```
*/
//int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
/// Source: oracle/codemp/null/win_main.cpp:1410
// Raven wrote: int main(int argc, char **argv)
// Not ported: the shell's main in Sources/jampded/main.swift merges the command line and calls the bare functions, under rule 11 and ruling F5.
