import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/files_common.cpp:183
var fs_gamedir: JKAShared.CharBuf {
    get { world.variables.fs_gamedir }
    set { world.variables.fs_gamedir = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:184
var fs_debug: JKAMP.Cvar? {
    get { world.variables.fs_debug }
    set { world.variables.fs_debug = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:185
var fs_homepath: JKAMP.Cvar? {
    get { world.variables.fs_homepath }
    set { world.variables.fs_homepath = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:186
var fs_basepath: JKAMP.Cvar? {
    get { world.variables.fs_basepath }
    set { world.variables.fs_basepath = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:187
var fs_basegame: JKAMP.Cvar? {
    get { world.variables.fs_basegame }
    set { world.variables.fs_basegame = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:188
var fs_cdpath: JKAMP.Cvar? {
    get { world.variables.fs_cdpath }
    set { world.variables.fs_cdpath = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:189
var fs_copyfiles: JKAMP.Cvar? {
    get { world.variables.fs_copyfiles }
    set { world.variables.fs_copyfiles = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:190
var fs_gamedirvar: JKAMP.Cvar? {
    get { world.variables.fs_gamedirvar }
    set { world.variables.fs_gamedirvar = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:191
var fs_restrict: JKAMP.Cvar? {
    get { world.variables.fs_restrict }
    set { world.variables.fs_restrict = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:192
var fs_dirbeforepak: JKAMP.Cvar? {
    get { world.variables.fs_dirbeforepak }
    set { world.variables.fs_dirbeforepak = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:193
// AI: Raven takes the address of the pointer in FS_ReorderPurePaks. The pointer is slot 0 of a storage slot, and the forward keeps Raven's name.
var fs_searchpaths: Searchpath? {
    get { world.storage.fs_searchpaths[0] }
    set { world.storage.fs_searchpaths[0] = newValue }
}

/// Raven's `&fs_searchpaths`, the slot of the pointer as the Slots of one optional view.
/// Source: oracle/codemp/qcommon/files_pc.cpp:2458
var fs_searchpathsSlot: Slots<Searchpath?> { world.storage.fs_searchpaths }

/// Source: oracle/codemp/qcommon/files_common.cpp:194
var fs_readCount: Int32 {
    get { world.variables.fs_readCount }
    set { world.variables.fs_readCount = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:195
var fs_loadCount: Int32 {
    get { world.variables.fs_loadCount }
    set { world.variables.fs_loadCount = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:196
var fs_loadStack: Int32 {
    get { world.variables.fs_loadStack }
    set { world.variables.fs_loadStack = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:197
var fs_packFiles: Int32 {
    get { world.variables.fs_packFiles }
    set { world.variables.fs_packFiles = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:199
var fs_fakeChkSum: Int32 {
    get { world.variables.fs_fakeChkSum }
    set { world.variables.fs_fakeChkSum = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:200
var fs_checksumFeed: Int32 {
    get { world.variables.fs_checksumFeed }
    set { world.variables.fs_checksumFeed = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:202
var fsh: Slots<FileHandleData> { world.storage.fsh }

/// Source: oracle/codemp/qcommon/files_common.cpp:206
var fs_numServerPaks: Int32 {
    get { world.variables.fs_numServerPaks }
    set { world.variables.fs_numServerPaks = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:207
var fs_serverPaks: [Int32] {
    get { world.variables.fs_serverPaks }
    set { world.variables.fs_serverPaks = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:208
var fs_serverPakNames: [String] {
    get { world.variables.fs_serverPakNames }
    set { world.variables.fs_serverPakNames = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:212
var fs_numServerReferencedPaks: Int32 {
    get { world.variables.fs_numServerReferencedPaks }
    set { world.variables.fs_numServerReferencedPaks = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:213
var fs_serverReferencedPaks: [Int32] {
    get { world.variables.fs_serverReferencedPaks }
    set { world.variables.fs_serverReferencedPaks = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:214
var fs_serverReferencedPakNames: [String] {
    get { world.variables.fs_serverReferencedPakNames }
    set { world.variables.fs_serverReferencedPakNames = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:217
var lastValidBase: JKAShared.CharBuf {
    get { world.variables.lastValidBase }
    set { world.variables.lastValidBase = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:218
var lastValidGame: JKAShared.CharBuf {
    get { world.variables.lastValidGame }
    set { world.variables.lastValidGame = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:224
var initialized: Bool {
    get { world.variables.initialized }
    set { world.variables.initialized = newValue }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:374
private let MAXPRINTMSG = 4096 as Int32


/**
```
	Extra utility for checking that FS is up and running
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:229
func FS_CheckInit() {
    if !initialized {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }
}

/// Source: oracle/codemp/qcommon/files_common.cpp:243
func FS_Initialized() -> Bool {
    return (fs_searchpaths != nil)
}

/**
```
=================
FS_LoadStack
return load stack
=================
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:253
func FS_LoadStack() -> Int32 {
    return fs_loadStack
}

/// Source: oracle/codemp/qcommon/files_common.cpp:258
func FS_HandleForFile() -> JKAShared.fileHandle_t {
    var i: Int32

    i = 1
    while i < MAX_FILE_HANDLES {
        if fsh[i].handleFiles.file.o == nil {
            return i
        }
        i += 1
    }
    Com_Error(ERR_DROP, "FS_HandleForFile: none free")
    // Raven writes `return 0` after this call, which `Com_Error` never reaches.
}

/**
```
====================
FS_ReplaceSeparators

Fix things up differently for win/unix/mac
====================
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:277
func FS_ReplaceSeparators(_ path: inout JKAShared.CharBuf) {
    var s: Int32

    s = 0
    while path[s] != 0 {
        if path[s] == Int32(ascii: "/") || path[s] == Int32(ascii: "\\") {
            path[s] = PATH_SEP
        }
        s += 1
    }
}

/**
```
===================
FS_BuildOSPath

Qpath may have either forward or backwards slashes
===================
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:294
func FS_BuildOSPath(_ qpath: String) -> String {
    var temp = CharBuf(MAX_OSPATH)
    // Raven's ring of static buffers keeps one result valid across a later call, and a returned `String` is already a copy.
    var ospath = CharBuf(MAX_OSPATH)
    // Raven steps his own `qpath` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var qpath = TextCursor(CharBuf(qpath))

    // Fix for filenames that are given to FS with a leading "/" (/botfiles/Foo)
    if qpath[0] == Int32(ascii: "\\") || qpath[0] == Int32(ascii: "/") {
        qpath.advance()
    }

    // FIXME VVFIXME Holy crap this is wrong.
    //	Com_sprintf( temp, sizeof(temp), "/%s/%s", fs_gamedirvar->string, qpath );
    Com_sprintf(&temp, Int32(temp.count), "/%s/%s", "base", qpath.text)

    FS_ReplaceSeparators(&temp)
    Com_sprintf(&ospath, Int32(ospath.count), "%s%s", fs_basepath!.string!, temp)

    return String(ospath)
}

/// Source: oracle/codemp/qcommon/files_common.cpp:317
func FS_BuildOSPath(_ base: String, _ game: String, _ qpath: String) -> String {
    var temp = CharBuf(MAX_OSPATH)
    // Raven's ring of static buffers keeps one result valid across a later call, and a returned `String` is already a copy.
    var ospath = CharBuf(MAX_OSPATH)
    // Raven assigns his own `game` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var game = game

    //pre-fs_cf2
    //toggle ^= 1;		// flip-flop to allow two returns without clash
    //post-fs_cf2

    if game.isEmpty {
        game = String(fs_gamedir)
    }

    Com_sprintf(&temp, Int32(temp.count), "/%s/%s", game, qpath)
    FS_ReplaceSeparators(&temp)
    Com_sprintf(&ospath, Int32(ospath.count), "%s%s", base, temp)

    return String(ospath)
}

/**
```
===========
FS_FilenameCompare

Ignore case and seprator char distinctions
===========
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:345
func FS_FilenameCompare(_ s1: String, _ s2: String) -> Bool {
    var c1: Int32
    var c2: Int32
    // Raven steps his own `s1` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var s1 = TextCursor(CharBuf(s1))
    // Raven steps his own `s2` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var s2 = TextCursor(CharBuf(s2))

    repeat {
        c1 = s1.byte
        s1.advance()
        c2 = s2.byte
        s2.advance()

        if c1 >= Int32(ascii: "a") && c1 <= Int32(ascii: "z") {
            c1 -= (Int32(ascii: "a") - Int32(ascii: "A"))
        }
        if c2 >= Int32(ascii: "a") && c2 <= Int32(ascii: "z") {
            c2 -= (Int32(ascii: "a") - Int32(ascii: "A"))
        }

        if c1 == Int32(ascii: "\\") || c1 == Int32(ascii: ":") {
            c1 = Int32(ascii: "/")
        }
        if c2 == Int32(ascii: "\\") || c2 == Int32(ascii: ":") {
            c2 = Int32(ascii: "/")
        }

        if c1 != c2 {
            // Raven's `(qboolean)-1` is true.
            return true // strings not equal
        }
    } while c1 != 0

    return false // strings are equal
}

/// Source: oracle/codemp/qcommon/files_common.cpp:375
func FS_Printf(_ h: JKAShared.fileHandle_t, _ fmt: String, _ args: any JKAShared.FormatArg...) {
    var msg = CharBuf(MAXPRINTMSG)

    strcpy(&msg, JKAShared.format(fmt, args))

    FS_Write(msg, strlen(msg), h)
}

/**
```
============
FS_WriteFile

Filename are reletive to the quake search path
============
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:401
func FS_WriteFile(_ qpath: String, _ buffer: Slots<JKAShared.byte>, _ size: Int32) {
    let f: fileHandle_t

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if buffer == nil {
        Com_Error(ERR_FATAL, "FS_WriteFile: NULL parameter")
    }

    f = FS_FOpenFileWrite(qpath)
    if f == 0 {
        Com_Printf("Failed to open %s\n", qpath)
        return
    }

    FS_Write(buffer, size, f)

    FS_FCloseFile(f)
}

/**
```
================
FS_Shutdown

Frees all resources and closes all files
================
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:430
func FS_Shutdown(_ closemfp: Bool) {
    var p: Searchpath?
    var next: Searchpath?
    var i: Int32

    i = 0
    while i < MAX_FILE_HANDLES {
        if fsh[i].fileSize != 0 {
            FS_FCloseFile(i)
        }
        i += 1
    }

    // free everything
    p = fs_searchpaths
    while p != nil {
        next = p!.next

        if p!.pack != nil {
            let pack = p!.pack!
            unzClose(pack.packHandle)
            Z_Free(pack.buildBuffer?.handle)
            Z_Free(pack.handle)
        }
        if p!.dir != nil {
            Z_Free(p!.dir!.handle)
        }
        Z_Free(p!.handle)
        p = next
    }

    // any FS_ calls will now be an error until reinitialized
    fs_searchpaths = nil

    Cmd_RemoveCommand("path")
    Cmd_RemoveCommand("dir")
    Cmd_RemoveCommand("fdir")
    Cmd_RemoveCommand("touchFile")
}

/**
```
================
FS_InitFilesystem

Called only at inital startup, not when the filesystem
is resetting due to a game change
================
```
*/
/// Source: oracle/codemp/qcommon/files_common.cpp:480
func FS_InitFilesystem() {
    // allow command line parms to override our defaults
    // we have to specially handle this, because normal command
    // line variable sets don't happen until after the filesystem
    // has already been initialized
    Com_StartupVariable("fs_cdpath")
    Com_StartupVariable("fs_basepath")
    Com_StartupVariable("fs_homepath")
    Com_StartupVariable("fs_game")
    Com_StartupVariable("fs_copyfiles")
    Com_StartupVariable("fs_restrict")

    // try to start up normally
    FS_Startup(BASEGAME)
    initialized = true

    // see if we are going to allow add-ons
    FS_SetRestrictions()

    // if we can't find default.cfg, assume that the paths are
    // busted and error out now, rather than getting an unreadable
    // graphics screen when the font fails to load
    var buffer: CharBuf? = nil
    if FS_ReadFile("mpdefault.cfg", &buffer) <= 0 {
        Com_Error(ERR_FATAL, "Couldn't load mpdefault.cfg")
        // bk001208 - SafeMode see below, FIXME?
    }

    Q_strncpyz(&lastValidBase, fs_basepath!.string!, Int32(lastValidBase.count))
    Q_strncpyz(&lastValidGame, fs_gamedirvar!.string!, Int32(lastValidGame.count))

    // bk001208 - SafeMode see below, FIXME?
}
