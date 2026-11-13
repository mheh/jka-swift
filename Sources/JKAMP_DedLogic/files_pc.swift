import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/files_pc.cpp:21
var fs_reordered: Bool {
    get { world.variables.fs_reordered }
    set { world.variables.fs_reordered = newValue }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:24
// Raven wrote: static const byte fs_scrambledProductId[]
let fs_scrambledProductId: [JKAShared.byte] = [
    42, 143, 149, 190, 10, 197, 225, 133, 243, 63, 189, 182, 226, 56, 143, 17, 215, 37, 197, 218, 50, 103, 24, 235, 246, 191, 183, 149, 160, 170,
    230, 52, 176, 231, 15, 194, 236, 247, 159, 168, 132, 154, 24, 133, 67, 85, 36, 97, 99, 86, 117, 189, 212, 156, 236, 153, 68, 10, 196, 241,
    39, 219, 156, 88, 93, 198, 200, 232, 142, 67, 45, 209, 53, 186, 228, 241, 162, 127, 213, 83, 7, 121, 11, 93, 123, 243, 148, 240, 229, 42,
    42, 6, 215, 239, 112, 120, 240, 244, 104, 12, 38, 47, 201, 253, 223, 208, 154, 69, 141, 157, 32, 117, 166, 146, 236, 59, 15, 223, 52, 89,
    133, 64, 201, 56, 119, 25, 211, 152, 159, 11, 92, 59, 207, 81, 123, 0, 121, 241, 116, 42, 36, 251, 51, 149, 79, 165, 12, 106, 187, 225,
    203, 99, 102, 69, 97, 81, 27, 107, 81, 178, 63, 35, 185, 64, 115,
]

/// Source: oracle/codemp/qcommon/files_pc.cpp:1263
// AI: Raven declares `len` on the stack of FS_ReadFile. The function uses one zeroed allocation on the storage class.
var len_FS_ReadFile: Slots<Int32> { world.storage.len_FS_ReadFile }

/// Source: oracle/codemp/qcommon/files_pc.cpp:1532
private let MAX_FOUND_FILES = 0x1000 as Int32

/// Source: oracle/codemp/qcommon/files_pc.cpp:2211
let MAX_PAKFILES = 1024 as Int32

/**
```
=================
FS_PakIsPure
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:39
public func FS_PakIsPure(_ pack: Pack) -> Bool {
    var i: Int32

    if fs_numServerPaks != 0 {
        // NOTE TTimo we are matching checksums without checking the pak names
        //   this means you can have the same pk3 as the server under a different name, you will still get through sv_pure validation
        //   (what happens when two pk3's have the same checkums? is it a likely situation?)
        //   also, if there's a wrong checksumed pk3 and autodownload is enabled, the checksum will be appended to the downloaded pk3 name
        i = 0
        while i < fs_numServerPaks {
            // FIXME: also use hashed file names
            if pack.checksum == fs_serverPaks[i] {
                return true // on the aproved list
            }
            i += 1
        }
        return false // not on the pure server pak list
    }
    return true
}

/**
```
================
return a hash value for the filename
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:64
private func FS_HashFileName(_ fname: String, _ hashSize: Int32) -> CLong {
    var i: Int32
    var hash: CLong
    var letter: CChar
    // Raven indexes his own `fname` parameter by byte, so the body reads a CharBuf of it.
    let fname = CharBuf(fname)

    hash = 0
    i = 0
    while fname[i] != 0 {
        let byte: UInt8 = fname[i]
        // Foundation also declares tolower, so the qualifier picks the C-locale form of JKAShared.
        letter = CChar(truncatingIfNeeded: JKAShared.tolower(Int32(byte)))
        if letter == Int32(ascii: ".") {
            break // don't include extension
        }
        if letter == Int32(ascii: "\\") {
            letter = CChar(truncatingIfNeeded: Int32(ascii: "/")) // damn path names
        }
        if letter == PATH_SEP {
            letter = CChar(truncatingIfNeeded: Int32(ascii: "/")) // damn path names
        }
        // C widens the `int` factor to `long` for the product.
        hash += CLong(letter) * CLong(i + 119)
        i += 1
    }
    hash = (hash ^ (hash >> 10) ^ (hash >> 20))
    hash &= CLong(hashSize - 1)
    return hash
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:85
private func FS_FileForHandle(_ f: JKAShared.fileHandle_t) -> OpaquePointer? {
    if f < 0 || f > MAX_FILE_HANDLES {
        Com_Error(ERR_DROP, "FS_FileForHandle: out of reange")
    }
    if fsh[f].zipFile == true {
        Com_Error(ERR_DROP, "FS_FileForHandle: can't get FILE on zip file")
    }
    if fsh[f].handleFiles.file.o == nil {
        Com_Error(ERR_DROP, "FS_FileForHandle: NULL")
    }

    return fsh[f].handleFiles.file.o
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:100
public func FS_ForceFlush(_ f: JKAShared.fileHandle_t) {
    let file: OpaquePointer?

    file = FS_FileForHandle(f)
    FileBackend.setvbuf(file, nil, _IONBF, 0)
}

/**
```
================
FS_filelength

If this is called on a non-unique FILE (from a pak file),
it will return the size of the pak file, not the expected
size of the file.
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:117
public func FS_filelength(_ f: JKAShared.fileHandle_t) -> Int32 {
    let pos: Int32
    let end: Int32
    let h: OpaquePointer?

    h = FS_FileForHandle(f)
    pos = FileBackend.ftell(h)
    FileBackend.fseek(h, 0, SEEK_END)
    end = FileBackend.ftell(h)
    FileBackend.fseek(h, CLong(pos), SEEK_SET)

    return end
}

/**
```
============
FS_CreatePath

Creates any directories needed to store the given filename
============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:138
public func FS_CreatePath(_ OSPath: inout JKAShared.CharBuf) -> Bool {
    var ofs: Int32

    // make absolutely sure that it can't back up the path
    // FIXME: is c: allowed???
    if strstr(OSPath, "..") != nil || strstr(OSPath, "::") != nil {
        Com_Printf("WARNING: refusing to create relative path \"%s\"\n", OSPath)
        return true
    }

    ofs = 1
    while OSPath[ofs] != 0 {
        if OSPath[ofs] == PATH_SEP {
            // create the directory
            OSPath[ofs] = 0
            Sys_Mkdir(String(OSPath))
            OSPath[ofs] = PATH_SEP
        }
        ofs += 1
    }
    return false
}

/**
```
=================
FS_CopyFile

Copy a fully specified file from one place to another
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:166
public func FS_CopyFile(_ fromOSPath: inout JKAShared.CharBuf, _ toOSPath: inout JKAShared.CharBuf) {
    var f: OpaquePointer?
    let len: Int32

    Com_Printf("copy %s to %s\n", fromOSPath, toOSPath)

    if strstr(fromOSPath, "journal.dat") != nil || strstr(fromOSPath, "journaldata.dat") != nil {
        Com_Printf("Ignoring journal files\n")
        return
    }

    f = FileBackend.fopen(String(fromOSPath), "rb")
    if f == nil {
        return
    }
    FileBackend.fseek(f, 0, SEEK_END)
    len = FileBackend.ftell(f)
    FileBackend.fseek(f, 0, SEEK_SET)

    // we are using direct malloc instead of Z_Malloc here, so it
    // probably won't work on a mac... Its only for developers anyway...
    // AI: Raven takes `len` bytes from malloc and frees them at the end. The buffer is a CharBuf of `len` bytes, which frees itself.
    var buf = CharBuf(len)
    if FileBackend.fread(&buf, at: 0, 1, len, f) != len {
        Com_Error(ERR_FATAL, "Short read in FS_Copyfiles()\n")
    }
    FileBackend.fclose(f)

    if FS_CreatePath(&toOSPath) {
        return
    }

    f = FileBackend.fopen(String(toOSPath), "wb")
    if f == nil {
        return
    }
    if FileBackend.fwrite(buf, at: 0, 1, len, f) != len {
        Com_Error(ERR_FATAL, "Short write in FS_Copyfiles()\n")
    }
    FileBackend.fclose(f)
}

/**
```
===========
FS_Remove

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:213
public func FS_Remove(_ osPath: String) {
    FileBackend.remove(osPath)
}

/**
```
================
FS_FileExists

Tests if the file exists in the current gamedir, this DOES NOT
search the paths.  This is to determine if opening a file to write
(which always goes into the current gamedir) will cause any overwrites.
NOTE TTimo: this goes with FS_FOpenFileWrite for opening the file afterwards
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:227
public func FS_FileExists(_ file: String) -> Bool {
    let f: OpaquePointer?
    let testpath: String

    testpath = FS_BuildOSPath(fs_homepath!.string!, String(fs_gamedir), file)

    f = FileBackend.fopen(testpath, "rb")
    if f != nil {
        FileBackend.fclose(f)
        return true
    }
    return false
}

/**
```
================
FS_SV_FileExists

Tests if the file exists
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:249
public func FS_SV_FileExists(_ file: String) -> Bool {
    let f: OpaquePointer?
    var testpath: CharBuf

    testpath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, file, ""))
    testpath[strlen(testpath) - 1] = 0

    f = FileBackend.fopen(String(testpath), "rb")
    if f != nil {
        FileBackend.fclose(f)
        return true
    }
    return false
}

/**
```
===========
FS_SV_FOpenFileWrite

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:272
public func FS_SV_FOpenFileWrite(_ filename: String) -> JKAShared.fileHandle_t {
    var ospath: CharBuf
    var f: fileHandle_t

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, filename, ""))
    ospath[strlen(ospath) - 1] = 0

    f = FS_HandleForFile()
    fsh[f].zipFile = false

    if fs_debug!.integer != 0 {
        Com_Printf("FS_SV_FOpenFileWrite: %s\n", ospath)
    }

    if FS_CreatePath(&ospath) {
        return 0
    }

    Com_DPrintf("writing to: %s\n", ospath)
    fsh[f].handleFiles.file.o = FileBackend.fopen(String(ospath), "wb")

    Q_strncpyz(&fsh[f].nameBuffer, filename, Int32(fsh[f].nameBuffer.count))

    fsh[f].handleSync = false
    if fsh[f].handleFiles.file.o == nil {
        f = 0
    }
    return f
}

/**
```
===========
FS_SV_FOpenFileRead
search for a file somewhere below the home path, base path or cd path
we search in that order, matching FS_SV_FOpenFileRead order
===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:313
public func FS_SV_FOpenFileRead(_ filename: String, _ fp: inout Int32) -> Int32 {
    var ospath: CharBuf
    var f: fileHandle_t = 0 // bk001129 - from cvs1.17

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    f = FS_HandleForFile()
    fsh[f].zipFile = false

    Q_strncpyz(&fsh[f].nameBuffer, filename, Int32(fsh[f].nameBuffer.count))

    // don't let sound stutter
    S_ClearSoundBuffer()

    // search homepath
    ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, filename, ""))
    // remove trailing slash
    ospath[strlen(ospath) - 1] = 0

    if fs_debug!.integer != 0 {
        Com_Printf("FS_SV_FOpenFileRead (fs_homepath): %s\n", ospath)
    }

    fsh[f].handleFiles.file.o = FileBackend.fopen(String(ospath), "rb")
    fsh[f].handleSync = false
    if fsh[f].handleFiles.file.o == nil {
        // NOTE TTimo on non *nix systems, fs_homepath == fs_basepath, might want to avoid
        if Q_stricmp(fs_homepath!.string!, fs_basepath!.string!) != 0 {
            // search basepath
            ospath = CharBuf(FS_BuildOSPath(fs_basepath!.string!, filename, ""))
            ospath[strlen(ospath) - 1] = 0

            if fs_debug!.integer != 0 {
                Com_Printf("FS_SV_FOpenFileRead (fs_basepath): %s\n", ospath)
            }

            fsh[f].handleFiles.file.o = FileBackend.fopen(String(ospath), "rb")
            fsh[f].handleSync = false

            if fsh[f].handleFiles.file.o == nil {
                f = 0
            }
        }
    }

    if fsh[f].handleFiles.file.o == nil {
        // search cd path
        ospath = CharBuf(FS_BuildOSPath(fs_cdpath!.string!, filename, ""))
        ospath[strlen(ospath) - 1] = 0

        if fs_debug!.integer != 0 {
            Com_Printf("FS_SV_FOpenFileRead (fs_cdpath) : %s\n", ospath)
        }

        fsh[f].handleFiles.file.o = FileBackend.fopen(String(ospath), "rb")
        fsh[f].handleSync = false

        if fsh[f].handleFiles.file.o == nil {
            f = 0
        }
    }

    fp = f
    if f != 0 {
        return FS_filelength(f)
    }
    return 0
}

/**
```
===========
FS_SV_Rename

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:395
public func FS_SV_Rename(_ from: String, _ to: String) {
    var from_ospath: CharBuf
    var to_ospath: CharBuf

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    // don't let sound stutter
    S_ClearSoundBuffer()

    from_ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, from, ""))
    to_ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, to, ""))
    from_ospath[strlen(from_ospath) - 1] = 0
    to_ospath[strlen(to_ospath) - 1] = 0

    if fs_debug!.integer != 0 {
        Com_Printf("FS_SV_Rename: %s --> %s\n", from_ospath, to_ospath)
    }

    if FileBackend.rename(String(from_ospath), String(to_ospath)) != 0 {
        // Failed, try copying it and deleting the original
        FS_CopyFile(&from_ospath, &to_ospath)
        FS_Remove(String(from_ospath))
    }
}

/**
```
===========
FS_Rename

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:427
public func FS_Rename(_ from: String, _ to: String) {
    var from_ospath: CharBuf
    var to_ospath: CharBuf

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    // don't let sound stutter
    S_ClearSoundBuffer()

    from_ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, String(fs_gamedir), from))
    to_ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, String(fs_gamedir), to))

    if fs_debug!.integer != 0 {
        Com_Printf("FS_Rename: %s --> %s\n", from_ospath, to_ospath)
    }

    if FileBackend.rename(String(from_ospath), String(to_ospath)) != 0 {
        // Failed, try copying it and deleting the original
        FS_CopyFile(&from_ospath, &to_ospath)
        FS_Remove(String(from_ospath))
    }
}

/**
```
==============
FS_FCloseFile

If the FILE pointer is an open pak file, leave it open.

For some reason, other dll's can't just cal fclose()
on files returned by FS_FOpenFile...
==============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:461
public func FS_FCloseFile(_ f: JKAShared.fileHandle_t) {
    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if fsh[f].streamed {
        Sys_EndStreamedFile(f)
    }
    if fsh[f].zipFile == true {
        unzCloseCurrentFile(fsh[f].handleFiles.file.z)
        if fsh[f].handleFiles.unique {
            unzClose(fsh[f].handleFiles.file.z)
        }
        fsh[f].clear()
        return
    }

    // we didn't find it as a pak, so close it as a unique file
    if fsh[f].handleFiles.file.o != nil {
        FileBackend.fclose(fsh[f].handleFiles.file.o)
    }
    fsh[f].clear()
}

/**
```
===========
FS_FOpenFileWrite

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:491
public func FS_FOpenFileWrite(_ filename: String) -> JKAShared.fileHandle_t {
    var ospath: CharBuf
    var f: fileHandle_t

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    f = FS_HandleForFile()
    fsh[f].zipFile = false

    ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, String(fs_gamedir), filename))

    if fs_debug!.integer != 0 {
        Com_Printf("FS_FOpenFileWrite: %s\n", ospath)
    }

    if FS_CreatePath(&ospath) {
        return 0
    }

    // enabling the following line causes a recursive function call loop
    // when running with +set logfile 1 +set developer 1
    //Com_DPrintf( "writing to: %s\n", ospath );
    fsh[f].handleFiles.file.o = FileBackend.fopen(String(ospath), "wb")

    Q_strncpyz(&fsh[f].nameBuffer, filename, Int32(fsh[f].nameBuffer.count))

    fsh[f].handleSync = false
    if fsh[f].handleFiles.file.o == nil {
        f = 0
    }
    return f
}

/**
```
===========
FS_FOpenFileAppend

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:532
public func FS_FOpenFileAppend(_ filename: String) -> JKAShared.fileHandle_t {
    var ospath: CharBuf
    var f: fileHandle_t

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    f = FS_HandleForFile()
    fsh[f].zipFile = false

    Q_strncpyz(&fsh[f].nameBuffer, filename, Int32(fsh[f].nameBuffer.count))

    // don't let sound stutter
    S_ClearSoundBuffer()

    ospath = CharBuf(FS_BuildOSPath(fs_homepath!.string!, String(fs_gamedir), filename))

    if fs_debug!.integer != 0 {
        Com_Printf("FS_FOpenFileAppend: %s\n", ospath)
    }

    if FS_CreatePath(&ospath) {
        return 0
    }

    fsh[f].handleFiles.file.o = FileBackend.fopen(String(ospath), "ab")
    fsh[f].handleSync = false
    if fsh[f].handleFiles.file.o == nil {
        f = 0
    }
    return f
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:568
// Raven wrote: bool Sys_GetFileTime(LPCSTR psFileName, FILETIME &ft)
// Not ported: SysBackend.GetFileTime of Sources/JKAMP_Ded/SysBackend.swift reads the POSIX modification time, and Sys_FileOutOfDate calls it.

/// Source: oracle/codemp/qcommon/files_pc.cpp:600
public func Sys_FileOutOfDate(_ psFinalFileName: String, _ psDataFileName: String) -> Bool {
    var ftFinalFile = FILETIME()
    var ftDataFile = FILETIME()

    // AI: Raven calls Sys_GetFileTime, which reads the last write time through the Win32 file handle. SysBackend.GetFileTime reads the POSIX stat modification time.
    if SysBackend.GetFileTime(psFinalFileName, &ftFinalFile) && SysBackend.GetFileTime(psDataFileName, &ftDataFile) {
        // timer res only accurate to within 2 seconds on FAT, so can't do exact compare...
        //
        //LONG l = CompareFileTime( &ftFinalFile, &ftDataFile );
        // Port-note: Raven hands the DWORD difference to abs as an int, and abs of the lowest int is undefined. The port reads the magnitude.
        if (Int32(bitPattern: ftFinalFile.dwLowDateTime &- ftDataFile.dwLowDateTime).magnitude <= 20000000)
            && ftFinalFile.dwHighDateTime == ftDataFile.dwHighDateTime {
            return false // file not out of date, ie use it.
        }
        return true // flag return code to copy over a replacement version of this file
    }

    // extra error check, report as suspicious if you find a file locally but not out on the net.,.
    //
    if com_developer!.integer != 0 {
        // AI: Raven calls Sys_GetFileTime, which reads the last write time through the Win32 file handle. SysBackend.GetFileTime reads the POSIX stat modification time.
        if !SysBackend.GetFileTime(psDataFileName, &ftDataFile) {
            Com_Printf("Sys_FileOutOfDate: reading %s but it's not on the net!\n", psFinalFileName)
        }
    }

    return false
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:634
public func FS_FileCacheable(_ filename: String) -> Bool {
    if com_buildScript != nil && com_buildScript!.integer != 0 {
        return true
    }
    return (strchr(filename, Int32(ascii: "/")) != nil)
}

/**
```
===========
FS_ShiftedStrStr
===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:649
public func FS_ShiftedStrStr(_ string: String, _ substring: String, _ shift: Int32) -> String? {
    var buf = CharBuf(MAX_STRING_TOKENS)
    var i: Int32
    // Raven indexes his own `substring` parameter by byte, so the body reads a CharBuf of it.
    let substring = CharBuf(substring)

    i = 0
    while substring[i] != 0 {
        buf[i] = substring[i] + shift
        i += 1
    }
    buf[i] = 0
    // AI: Raven returns the pointer into `string` at the match, or NULL. The return is the text from the match, or nil.
    return strstr(CharBuf(string), buf).map { String(CharBuf(string)[$0...]) }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:672
public func FS_FOpenFileRead(_ filename: String, _ file: inout Int32, _ uniqueFILE: Bool) -> Int32 {
    var search: Searchpath?
    var netpath: String
    var dir: Directory
    var hash: CLong
    var l: Int32
    var demoExt = CharBuf(16)
    // Raven steps his own `filename` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var filename = TextCursor(CharBuf(filename))

    hash = 0

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    Com_sprintf(&demoExt, Int32(demoExt.count), ".dm_%d", PROTOCOL_VERSION)
    // qpaths are not supposed to have a leading slash
    if filename[0] == Int32(ascii: "/") || filename[0] == Int32(ascii: "\\") {
        filename.advance()
    }

    // make absolutely sure that it can't back up the path.
    // The searchpaths do guarantee that something will always
    // be prepended, so we don't need to worry about "c:" or "//limbo"
    if strstr(filename.text, "..") != nil || strstr(filename.text, "::") != nil {
        file = 0
        return -1
    }

    // make sure the q3key file is only readable by the quake3.exe at initialization
    // any other time the key should only be accessed in memory using the provided functions
    if com_fullyInitialized && strstr(filename.text, "q3key") != nil {
        file = 0
        return -1
    }

    //
    // search through the path, one element at a time
    //

    file = FS_HandleForFile()
    fsh[file].handleFiles.unique = uniqueFILE

    // this new bool is in for an optimisation, if you (eg) opened a BSP file under fs_copyfiles==2,
    //	then it triggered a copy operation to update your local HD version, then this will re-open the
    //	file handle on your local version, not the net build. This uses a bit more CPU to re-do the loop
    //	logic, but should read faster than accessing the net version a second time.
    //
    var bFasterToReOpenUsingNewLocalFile: Bool = false

    repeat {
        bFasterToReOpenUsingNewLocalFile = false

        search = fs_searchpaths
        while search != nil {
            //
            if search!.pack != nil {
                hash = FS_HashFileName(filename.text, search!.pack!.hashSize)
            }
            // is the element a pak file?
            if search!.pack != nil && search!.pack!.hashTable![hash] != nil {
                // disregard if it doesn't match one of the allowed pure pak files
                if !FS_PakIsPure(search!.pack!) {
                    search = search!.next
                    continue
                }

                // look through all the pak file elements
                let pak = search!.pack!
                var pakFile = pak.hashTable![hash]
                repeat {
                    // case and separator insensitive comparisons
                    if !FS_FilenameCompare(pakFile!.name!, filename.text) {
                        // found it!

                        // mark the pak as having been referenced and mark specifics on cgame and ui
                        // shaders, txt, arena files  by themselves do not count as a reference as
                        // these are loaded from all pk3s
                        // from every pk3 file..
                        l = strlen(filename.text)
                        if (pak.referenced & FS_GENERAL_REF) == 0 {
                            // Port-note: Raven reads before the name when it is shorter than the extension. The cursor reads the empty text there.
                            if Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 7).text, ".shader") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".txt") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".str") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".cfg") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".fcf") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 7).text, ".config") != 0
                                && strstr(filename.text, "levelshots") == nil
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".bot") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 6).text, ".arena") != 0
                                && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 5).text, ".menu") != 0 {
                                pak.referenced |= FS_GENERAL_REF
                            }
                        }

                        /*
                        FS_ShiftedStrStr(filename, "jampgamex86.dll", -13);
                                                  //]^&`cZT`Xk+)!W__
                        FS_ShiftedStrStr(filename, "cgamex86.dll", -7);
                                                  //\`Zf^q1/']ee
                        FS_ShiftedStrStr(filename, "uix86.dll", -5);
                                                  //pds31)_gg
                        */

                        // jampgame.qvm	- 13
                        // ]^&`cZT`X!di`
                        if (pak.referenced & FS_QAGAME_REF) == 0 {
                            if FS_ShiftedStrStr(filename.text, "]T`cZT`X!di`", 13) != nil
                                || FS_ShiftedStrStr(filename.text, "]T`cZT`Xk+)!W__", 13) != nil {
                                pak.referenced |= FS_QAGAME_REF
                            }
                        }
                        // cgame.qvm	- 7
                        // \`Zf^'jof
                        if (pak.referenced & FS_CGAME_REF) == 0 {
                            if FS_ShiftedStrStr(filename.text, "\\`Zf^'jof", 7) != nil
                                || FS_ShiftedStrStr(filename.text, "\\`Zf^q1/']ee", 7) != nil {
                                pak.referenced |= FS_CGAME_REF
                            }
                        }
                        // ui.qvm		- 5
                        // pd)lqh
                        if (pak.referenced & FS_UI_REF) == 0 {
                            if FS_ShiftedStrStr(filename.text, "pd)lqh", 5) != nil
                                || FS_ShiftedStrStr(filename.text, "pds31)_gg", 5) != nil {
                                pak.referenced |= FS_UI_REF
                            }
                        }

                        if uniqueFILE {
                            // open a new file on the pakfile
                            fsh[file].handleFiles.file.z = unzReOpen(pak.pakFilename, pak.packHandle)
                            if fsh[file].handleFiles.file.z == nil {
                                Com_Error(ERR_FATAL, "Couldn't reopen %s", pak.pakFilename)
                            }
                        } else {
                            fsh[file].handleFiles.file.z = pak.packHandle
                        }
                        Q_strncpyz(&fsh[file].nameBuffer, filename.text, Int32(fsh[file].nameBuffer.count))
                        fsh[file].zipFile = true
                        let zfi = UnzS(fsh[file].handleFiles.file.z!)
                        // in case the file was new
                        let temp = zfi.file
                        // set the file position in the zip file (also sets the current file info)
                        unzSetCurrentFileInfoPosition(pak.packHandle, pakFile!.pos)
                        // copy the file info into the unzip structure
                        Com_Memcpy(zfi, UnzS(pak.packHandle!), UnzS.byteCount)
                        // we copy this back into the structure
                        zfi.file = temp
                        // open the file in the zip
                        unzOpenCurrentFile(fsh[file].handleFiles.file.z)
                        // The `unsigned long` position narrows into the `int` field, as C's store does.
                        fsh[file].zipFilePos = Int32(truncatingIfNeeded: pakFile!.pos)

                        if fs_debug!.integer != 0 {
                            Com_Printf("FS_FOpenFileRead: %s (found in '%s')\n", filename.text, pak.pakFilename)
                        }
                        // The `uLong` size narrows into the `int` return, as C's return does.
                        return Int32(truncatingIfNeeded: zfi.cur_file_info.uncompressed_size)
                    }
                    pakFile = pakFile!.next
                } while pakFile != nil
            } else if search!.dir != nil {
                // check a file in the directory tree

                // if we are running restricted, the only files we
                // will allow to come from the directory are .cfg files
                l = strlen(filename.text)
                // FIXME TTimo I'm not sure about the fs_numServerPaks test
                // if you are using FS_ReadFile to find out if a file exists,
                //   this test can make the search fail although the file is in the directory
                // I had the problem on https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=8
                // turned out I used FS_FileExists instead
                // Port-note: Raven reads before the name when it is shorter than the extension. The cursor reads the empty text there.
                if fs_restrict!.integer != 0 || fs_numServerPaks != 0 {
                    if Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".cfg") != 0 // for config files
                        && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".fcf") != 0 // force configuration files
                        && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 5).text, ".menu") != 0 // menu files
                        && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 5).text, ".game") != 0 // menu files
                        && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - strlen(demoExt)).text, String(demoExt)) != 0 // menu files
                        && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".dat") != 0 { // for journal files
                        search = search!.next
                        continue
                    }
                }

                dir = search!.dir!

                netpath = FS_BuildOSPath(dir.path, dir.gamedir, filename.text)
                fsh[file].handleFiles.file.o = FileBackend.fopen(netpath, "rb")
                if fsh[file].handleFiles.file.o == nil {
                    search = search!.next
                    continue
                }

                if Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".cfg") != 0 // for config files
                    && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".fcf") != 0 // force configuration files
                    && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 5).text, ".menu") != 0 // menu files
                    && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 5).text, ".game") != 0 // menu files
                    && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - strlen(demoExt)).text, String(demoExt)) != 0 // menu files
                    && Q_stricmp(TextCursor(filename.buf, at: filename.offset! + l - 4).text, ".dat") != 0 { // for journal files
                    fs_fakeChkSum = Int32(random())
                }
                // if running with fs_copyfiles 2, and search path == local, then we need to fail to open
                //	if the time/date stamp != the network version (so it'll loop round again and use the network path,
                //	which comes later in the search order)
                //
                if fs_copyfiles!.integer == 2 && !fs_cdpath!.string!.isEmpty && Q_stricmp(dir.path, fs_basepath!.string!) == 0
                    && FS_FileCacheable(filename.text) {
                    if Sys_FileOutOfDate(netpath, FS_BuildOSPath(fs_cdpath!.string!, dir.gamedir, filename.text)) {
                        FileBackend.fclose(fsh[file].handleFiles.file.o)
                        fsh[file].handleFiles.file.o = nil
                        search = search!.next
                        continue //carry on to find the cdpath version.
                    }
                }
                Q_strncpyz(&fsh[file].nameBuffer, filename.text, Int32(fsh[file].nameBuffer.count))
                fsh[file].zipFile = false
                if fs_debug!.integer != 0 {
                    Com_Printf("FS_FOpenFileRead: %s (found in '%s/%s')\n", filename.text, dir.path, dir.gamedir)
                }

                // if we are getting it from the cdpath, optionally copy it
                //  to the basepath
                if fs_copyfiles!.integer != 0 && Q_stricmp(dir.path, fs_cdpath!.string!) == 0 {
                    var copypath: CharBuf

                    copypath = CharBuf(FS_BuildOSPath(fs_basepath!.string!, dir.gamedir, filename.text))
                    switch fs_copyfiles!.integer {
                    case 2:
                        if FS_FileCacheable(filename.text) {
                            // maybe change this to Com_DPrintf?   On the other hand...
                            //
                            Com_Printf("fs_copyfiles(2), Copying: %s to %s\n", netpath, copypath)

                            FS_CreatePath(&copypath)

                            var bOk = true
                            // AI: Raven called the Win32 CopyFile, GetFileAttributes, and SetFileAttributes. SysBackend makes the copy and the read-only change with the POSIX calls.
                            if !SysBackend.CopyFile(netpath, String(copypath), false) {
                                let dwAttrs = SysBackend.GetFileAttributes(String(copypath))
                                _ = SysBackend.SetFileAttributes(String(copypath), dwAttrs & ~FILE_ATTRIBUTE_READONLY)
                                bOk = SysBackend.CopyFile(netpath, String(copypath), false)
                            }

                            if bOk {
                                // clear this handle and setup for re-opening of the new local copy...
                                //
                                bFasterToReOpenUsingNewLocalFile = true
                                FileBackend.fclose(fsh[file].handleFiles.file.o)
                                fsh[file].handleFiles.file.o = nil
                            }
                        }

                    default:
                        var netpathBuf = CharBuf(netpath)
                        FS_CopyFile(&netpathBuf, &copypath)
                    }
                }
                if bFasterToReOpenUsingNewLocalFile {
                    break // and re-read the local copy, not the net version
                }

                return FS_filelength(file)
            }
            search = search!.next
        }
    } while bFasterToReOpenUsingNewLocalFile

    Com_DPrintf("Can't find %s\n", filename.text)
    file = 0
    return -1
}

/**
```
=================
FS_Read

Properly handles partial reads
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1007
public func FS_Read2(_ buffer: Slots<JKAShared.byte>, _ len: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if f == 0 {
        return 0
    }
    if fsh[f].streamed {
        let r: Int32
        fsh[f].streamed = false
        r = Sys_StreamedRead(buffer, len, 1, f)
        fsh[f].streamed = true
        return r
    } else {
        return FS_Read(buffer, len, f)
    }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1026
public func FS_Read(_ buffer: Slots<JKAShared.byte>, _ len: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    var block: Int32
    var remaining: Int32
    var read: Int32
    var buf: Int32
    var tries: Int32

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if f == 0 {
        return 0
    }

    // AI: Raven walks a `byte *` over the buffer. The walk is a byte offset into it, which FileBackend.fread takes.
    buf = 0
    fs_readCount += len

    if fsh[f].zipFile == false {
        remaining = len
        tries = 0
        while remaining != 0 {
            block = remaining
            read = FileBackend.fread(buffer, at: buf, 1, block, fsh[f].handleFiles.file.o)
            if read == 0 {
                // we might have been trying to read from a CD, which
                // sometimes returns a 0 read on windows
                if tries == 0 {
                    tries = 1
                } else {
                    return len - remaining //Com_Error (ERR_FATAL, "FS_Read: 0 bytes read");
                }
            }

            if read == -1 {
                Com_Error(ERR_FATAL, "FS_Read: -1 bytes read")
            }

            remaining -= read
            buf += read
        }
        return len
    } else {
        // C converts the `int` length to the `unsigned` parameter.
        return unzReadCurrentFile(fsh[f].handleFiles.file.z, buffer, UInt32(bitPattern: len))
    }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1026
/// Raven's `buffer` takes a `char buf[N]` at msg.cpp:2070, and this overload reads into that buffer.
// Port-note: The CharBuf overload of the FS_Read row, which reads into the caller's buffer.
// AI: Raven hands a `char *` buffer to the `void *` of FS_Read. The overload takes the caller's CharBuf, the form trap_FS_Read has.
public func FS_Read(_ buffer: inout CharBuf, _ len: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    var block: Int32
    var remaining: Int32
    var read: Int32
    var buf: Int32
    var tries: Int32

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if f == 0 {
        return 0
    }

    // AI: Raven walks a `byte *` over the buffer. The walk is a byte offset into it, which FileBackend.fread takes.
    buf = 0
    fs_readCount += len

    if fsh[f].zipFile == false {
        remaining = len
        tries = 0
        while remaining != 0 {
            block = remaining
            read = FileBackend.fread(&buffer, at: buf, 1, block, fsh[f].handleFiles.file.o)
            if read == 0 {
                // we might have been trying to read from a CD, which
                // sometimes returns a 0 read on windows
                if tries == 0 {
                    tries = 1
                } else {
                    return len - remaining //Com_Error (ERR_FATAL, "FS_Read: 0 bytes read");
                }
            }

            if read == -1 {
                Com_Error(ERR_FATAL, "FS_Read: -1 bytes read")
            }

            remaining -= read
            buf += read
        }
        return len
    } else {
        return unzReadCurrentFile(fsh[f].handleFiles.file.z, &buffer, UInt32(bitPattern: len))
    }
}

/**
```
=================
FS_Write

Properly handles partial writes
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1079
public func FS_Write(_ buffer: Slots<JKAShared.byte>, _ len: Int32, _ h: JKAShared.fileHandle_t) -> Int32 {
    var block: Int32
    var remaining: Int32
    var written: Int32
    var buf: Int32
    var tries: Int32
    let f: OpaquePointer?

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if h == 0 {
        return 0
    }

    f = FS_FileForHandle(h)
    // AI: Raven walks a `byte *` over the buffer. The walk is a byte offset into it, which FileBackend.fwrite takes.
    buf = 0

    remaining = len
    tries = 0
    while remaining != 0 {
        block = remaining
        written = FileBackend.fwrite(buffer, at: buf, 1, block, f)
        if written == 0 {
            if tries == 0 {
                tries = 1
            } else {
                Com_Printf("FS_Write: 0 bytes written\n")
                return 0
            }
        }

        if written == -1 {
            Com_Printf("FS_Write: -1 bytes written\n")
            return 0
        }

        remaining -= written
        buf += written
    }
    if fsh[h].handleSync {
        FileBackend.fflush(f)
    }
    return len
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1079
// Port-note: The CharBuf overload of FS_Write, for the `char msg[MAXPRINTMSG]` of FS_Printf at files_common.cpp:383 and the log file write of common.cpp:188.
// AI: Raven casts the caller's `char *` to `const void *`. A CharBuf overload hands the bytes of the buffer on as a Slots of bytes.
public func FS_Write(_ buffer: CharBuf, _ len: Int32, _ h: JKAShared.fileHandle_t) -> Int32 {
    buffer.withSlots { FS_Write($0, len, h) }
}

/**
```
=================
FS_Seek

=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1131
public func FS_Seek(_ f: JKAShared.fileHandle_t, _ offset: CLong, _ origin: Int32) -> Int32 {
    var _origin: Int32
    var foo = CharBuf(65536)

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
        // Raven writes `return -1` after this call, which `Com_Error` never reaches.
    }

    if fsh[f].streamed {
        fsh[f].streamed = false
        // C narrows the `long` offset to the `int` parameter.
        Sys_StreamSeek(f, Int32(truncatingIfNeeded: offset), origin)
        fsh[f].streamed = true
    }

    if fsh[f].zipFile == true {
        if offset == 0 && origin == FS_SEEK_SET {
            // set the file position in the zip file (also sets the current file info)
            // C converts the `int` position to the `unsigned long` parameter.
            unzSetCurrentFileInfoPosition(fsh[f].handleFiles.file.z, CUnsignedLong(truncatingIfNeeded: fsh[f].zipFilePos))
            return unzOpenCurrentFile(fsh[f].handleFiles.file.z)
        } else if offset < 65536 {
            // set the file position in the zip file (also sets the current file info)
            unzSetCurrentFileInfoPosition(fsh[f].handleFiles.file.z, CUnsignedLong(truncatingIfNeeded: fsh[f].zipFilePos))
            unzOpenCurrentFile(fsh[f].handleFiles.file.z)
            // C narrows the `long` offset to the `int` parameter.
            return FS_Read(&foo, Int32(truncatingIfNeeded: offset), f)
        } else {
            Com_Error(ERR_FATAL, "ZIP FILE FSEEK NOT YET IMPLEMENTED\n")
            // Raven writes `return -1` after this call, which `Com_Error` never reaches.
        }
    } else {
        let file: OpaquePointer?
        file = FS_FileForHandle(f)
        switch origin {
        case FS_SEEK_CUR:
            _origin = SEEK_CUR

        case FS_SEEK_END:
            _origin = SEEK_END

        case FS_SEEK_SET:
            _origin = SEEK_SET

        default:
            _origin = SEEK_CUR
            Com_Error(ERR_FATAL, "Bad origin in FS_Seek\n")
        }

        return FileBackend.fseek(file, offset, _origin)
    }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1191
public func FS_FileIsInPAK(_ filename: String, _ pChecksum: inout Int32) -> Int32 {
    var search: Searchpath?
    var hash: CLong = 0
    // Raven steps his own `filename` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var filename = TextCursor(CharBuf(filename))

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    // qpaths are not supposed to have a leading slash
    if filename[0] == Int32(ascii: "/") || filename[0] == Int32(ascii: "\\") {
        filename.advance()
    }

    // make absolutely sure that it can't back up the path.
    // The searchpaths do guarantee that something will always
    // be prepended, so we don't need to worry about "c:" or "//limbo"
    if strstr(filename.text, "..") != nil || strstr(filename.text, "::") != nil {
        return -1
    }

    //
    // search through the path, one element at a time
    //

    search = fs_searchpaths
    while search != nil {
        //
        if search!.pack != nil {
            hash = FS_HashFileName(filename.text, search!.pack!.hashSize)
        }
        // is the element a pak file?
        if search!.pack != nil && search!.pack!.hashTable![hash] != nil {
            // disregard if it doesn't match one of the allowed pure pak files
            if !FS_PakIsPure(search!.pack!) {
                search = search!.next
                continue
            }

            // look through all the pak file elements
            let pak = search!.pack!
            var pakFile = pak.hashTable![hash]
            repeat {
                // case and separator insensitive comparisons
                if !FS_FilenameCompare(pakFile!.name!, filename.text) {
                    pChecksum = pak.pure_checksum
                    return 1
                }
                pakFile = pakFile!.next
            } while pakFile != nil
        }
        search = search!.next
    }
    return -1
}

/**
```
============
FS_ReadFile

Filename are relative to the quake search path
a null buffer will just return the file length without loading
============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1259
public func FS_ReadFile(_ qpath: String, _ buffer: inout OpaquePointer?) -> Int32 {
    var h: fileHandle_t = 0
    let isConfig: Bool
    var len: Int32 = 0

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if qpath.isEmpty {
        Com_Error(ERR_FATAL, "FS_ReadFile with empty name\n")
    }

    // Raven's `buf = NULL; // quiet compiler warning` has no line, because `buf` takes its value at its one store below.

    // if this is a .cfg file and we are playing back a journal, read
    // it from the journal file
    if strstr(qpath, ".cfg") != nil {
        isConfig = true
        if com_journal != nil && com_journal!.integer == 2 {
            Com_DPrintf("Loading %s from journal file.\n", qpath)
            var r: Int32
            // AI: Raven reads `len` itself through `&len`. The read fills the storage slot of `len`, and `len` takes its value.
            r = FS_Read(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
            len = len_FS_ReadFile[0]
            if r != Int32(Int32.byteCount) {
                buffer = nil
                return -1
            }
            // if the file didn't exist when the journal was created
            if len == 0 {
                // Raven's `if (buffer == NULL)` arm has no path here, because an `inout` buffer is never NULL.
                buffer = nil
                return -1
            }

            let buf = Hunk_AllocateTempMemory(len + 1)
            // AI: Raven stores the `byte *` of the block into the caller's `void *`. The store is the handle of the block.
            buffer = OpaquePointer(buf)

            // AI: Raven hands the `byte *` of the block to FS_Read. The call hands the Slots over the `len+1` bytes of the block.
            r = FS_Read(Slots(scalars: buf, count: Int(len) + 1), len, com_journalDataFile)
            if r != len {
                Com_Error(ERR_FATAL, "Read from journalDataFile failed")
            }

            fs_loadCount += 1
            fs_loadStack += 1

            // guarantee that it will have a trailing 0 for string operations
            buf[byte: len] = 0

            return len
        }
    } else {
        isConfig = false
    }

    // look for it in the filesystem or pack files
    len = FS_FOpenFileRead(qpath, &h, false)
    if h == 0 {
        buffer = nil
        // if we are journalling and it is a config file, write a zero to the journal file
        if isConfig && com_journal != nil && com_journal!.integer == 1 {
            Com_DPrintf("Writing zero for %s to journal file.\n", qpath)
            len = 0
            // AI: Raven writes `len` itself through `&len`. The write copies `len` into its storage slot and hands on the bytes of the slot.
            len_FS_ReadFile[0] = len
            FS_Write(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
            FS_Flush(com_journalDataFile)
        }
        return -1
    }

    // Raven's `if ( !buffer )` arm has no path here, because an `inout` buffer is never NULL. The `CharBuf?` overload keeps it.

    fs_loadCount += 1
    /*	fs_loadStack++;

    buf = (unsigned char *)Hunk_AllocateTempMemory(len+1);
    *buffer = buf;*/

    let buf = Z_Malloc(len + 1, TAG_FILESYS, false)
    buf[byte: len] = 0 // because we're not calling Z_Malloc with optional trailing 'bZeroIt' bool
    // AI: Raven stores the `byte *` of the zone block into the caller's `void *`. The store is the handle of the block.
    buffer = OpaquePointer(buf)

    //	Z_Label(buf, qpath);

    // AI: Raven hands the `byte *` of the zone block to FS_Read. The call hands the Slots over the `len+1` bytes of the block.
    FS_Read(Slots(scalars: buf, count: Int(len) + 1), len, h)

    // guarantee that it will have a trailing 0 for string operations
    buf[byte: len] = 0
    FS_FCloseFile(h)

    // if we are journalling and it is a config file, write it to the journal file
    if isConfig && com_journal != nil && com_journal!.integer == 1 {
        Com_DPrintf("Writing %s to journal file.\n", qpath)
        // AI: Raven writes `len` itself through `&len`. The write copies `len` into its storage slot and hands on the bytes of the slot.
        len_FS_ReadFile[0] = len
        FS_Write(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
        FS_Write(Slots(scalars: buf, count: Int(len) + 1), len, com_journalDataFile)
        FS_Flush(com_journalDataFile)
    }
    return len
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1259
// Port-note: The VmHeader overload of row V3, for `(void **)&header` of VM_Create and VM_Restart, vm.cpp:530 and :416.
// AI: Raven reads the QVM image into a zone block and stores its address in the `vmHeader_t *`. The overload gives the view over the block, or nil.
public func FS_ReadFile(_ qpath: String, _ buffer: inout VmHeader?) -> Int32 {
    var block: OpaquePointer? = nil
    let len = FS_ReadFile(qpath, &block)
    buffer = block.map { VmHeader(handle: $0) }
    return len
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1259
// Port-note: The optional overload of the FS_ReadFile row, for the `char *` callers and the NULL callers, files_common.cpp:502 and sv_ccmds.cpp:159.
// AI: Raven hands `(void **)&f` of a `char *f`, or NULL for the length alone. A nil buffer is Raven's NULL, and a read fills the CharBuf.
public func FS_ReadFile(_ qpath: String, _ buffer: inout CharBuf?) -> Int32 {
    var h: fileHandle_t = 0
    let isConfig: Bool
    var len: Int32 = 0

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    if qpath.isEmpty {
        Com_Error(ERR_FATAL, "FS_ReadFile with empty name\n")
    }

    // Raven's `buf = NULL; // quiet compiler warning` has no line, because `buf` takes its value at its one store below.

    // if this is a .cfg file and we are playing back a journal, read
    // it from the journal file
    if strstr(qpath, ".cfg") != nil {
        isConfig = true
        if com_journal != nil && com_journal!.integer == 2 {
            Com_DPrintf("Loading %s from journal file.\n", qpath)
            var r: Int32
            // AI: Raven reads `len` itself through `&len`. The read fills the storage slot of `len`, and `len` takes its value.
            r = FS_Read(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
            len = len_FS_ReadFile[0]
            if r != Int32(Int32.byteCount) {
                if buffer != nil {
                    buffer = nil
                }
                return -1
            }
            // if the file didn't exist when the journal was created
            if len == 0 {
                if buffer == nil {
                    return 1 // hack for old journal files
                }
                buffer = nil
                return -1
            }
            if buffer == nil {
                return len
            }

            // AI: Raven takes `len+1` bytes of the hunk for the file. The buffer is a CharBuf of `len+1` bytes that the caller owns.
            _ = Hunk_AllocateTempMemory(len + 1)
            var buf = CharBuf(len + 1)

            r = FS_Read(&buf, len, com_journalDataFile)
            if r != len {
                Com_Error(ERR_FATAL, "Read from journalDataFile failed")
            }

            fs_loadCount += 1
            fs_loadStack += 1

            // guarantee that it will have a trailing 0 for string operations
            buf[len] = 0
            // AI: Raven hands the caller the pointer before the read. A CharBuf is a value, so the store follows the read.
            buffer = buf

            return len
        }
    } else {
        isConfig = false
    }

    // look for it in the filesystem or pack files
    len = FS_FOpenFileRead(qpath, &h, false)
    if h == 0 {
        if buffer != nil {
            buffer = nil
        }
        // if we are journalling and it is a config file, write a zero to the journal file
        if isConfig && com_journal != nil && com_journal!.integer == 1 {
            Com_DPrintf("Writing zero for %s to journal file.\n", qpath)
            len = 0
            // AI: Raven writes `len` itself through `&len`. The write copies `len` into its storage slot and hands on the bytes of the slot.
            len_FS_ReadFile[0] = len
            FS_Write(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
            FS_Flush(com_journalDataFile)
        }
        return -1
    }

    if buffer == nil {
        if isConfig && com_journal != nil && com_journal!.integer == 1 {
            Com_DPrintf("Writing len for %s to journal file.\n", qpath)
            // AI: Raven writes `len` itself through `&len`. The write copies `len` into its storage slot and hands on the bytes of the slot.
            len_FS_ReadFile[0] = len
            FS_Write(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
            FS_Flush(com_journalDataFile)
        }
        FS_FCloseFile(h)
        return len
    }

    fs_loadCount += 1
    /*	fs_loadStack++;

    buf = (unsigned char *)Hunk_AllocateTempMemory(len+1);
    *buffer = buf;*/

    // AI: Raven takes `len+1` bytes of the zone for the file.
    // The buffer is a CharBuf of `len+1` bytes that the caller owns, so FS_FreeFile frees nothing.
    var buf = CharBuf(len + 1)
    buf[len] = 0 // because we're not calling Z_Malloc with optional trailing 'bZeroIt' bool

    //	Z_Label(buf, qpath);

    FS_Read(&buf, len, h)

    // guarantee that it will have a trailing 0 for string operations
    buf[len] = 0
    // AI: Raven hands the caller the pointer before the read. A CharBuf is a value, so the store follows the read.
    buffer = buf
    FS_FCloseFile(h)

    // if we are journalling and it is a config file, write it to the journal file
    if isConfig && com_journal != nil && com_journal!.integer == 1 {
        Com_DPrintf("Writing %s to journal file.\n", qpath)
        // AI: Raven writes `len` itself through `&len`. The write copies `len` into its storage slot and hands on the bytes of the slot.
        len_FS_ReadFile[0] = len
        FS_Write(len_FS_ReadFile.bytes, Int32(Int32.byteCount), com_journalDataFile)
        FS_Write(buf, len, com_journalDataFile)
        FS_Flush(com_journalDataFile)
    }
    return len
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1259
// Port-note: The CharBuf overload of the FS_ReadFile row, for the `char *` callers, cmd_common.cpp:231 and cm_shader.cpp:113.
// AI: Raven hands `(void **)&f` of a `char *f`. This forward wraps the caller's CharBuf in the optional and writes the read back.
// AI: Raven sets `*buffer` to NULL for a missing file. The forward leaves the buffer empty, so a caller tests the length Raven returns, `len < 0`.
public func FS_ReadFile(_ qpath: String, _ buffer: inout CharBuf) -> Int32 {
    var optionalBuffer: CharBuf? = buffer
    let length = FS_ReadFile(qpath, &optionalBuffer)
    buffer = optionalBuffer ?? CharBuf(0)
    return length
}

/**
```
=============
FS_FreeFile
=============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1379
public func FS_FreeFile(_ buffer: OpaquePointer?) {
    /*
    if ( !fs_searchpaths ) {
    Com_Error( ERR_FATAL, "Filesystem call made without initialization\n" );
    }
    if ( !buffer ) {
    Com_Error( ERR_FATAL, "FS_FreeFile( NULL )" );
    }
    fs_loadStack--;

    Hunk_FreeTempMemory( buffer );

    // if all of our temp files are free, clear all of our space
    if ( fs_loadStack == 0 ) {
    Hunk_ClearTempMemory();
    }
    */

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }
    if buffer == nil {
        Com_Error(ERR_FATAL, "FS_FreeFile( NULL )")
    }

    Z_Free(buffer)
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1379
// Port-note: The CharBuf overload of the FS_FreeFile row, for the `char *` callers of the FS_ReadFile forward, cmd_common.cpp:240.
// The overload does nothing, because a CharBuf owns its bytes and frees them when the caller drops it.
// AI: Raven frees the hunk block that FS_ReadFile gave. The overload takes the caller's CharBuf and frees nothing.
public func FS_FreeFile(_ buffer: CharBuf) {
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1379
// Port-note: The VmHeader overload of row V3, for the `vmHeader_t *` of VM_Create and VM_Restart, vm.cpp:587 and :455.
// AI: Raven frees the block of the QVM image through the header pointer. The overload hands the handle of the view to the original.
public func FS_FreeFile(_ buffer: VmHeader?) {
    FS_FreeFile(buffer.map { $0.handle })
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1379
// Port-note: The Slots overload of the FS_FreeFile row, for the `unsigned char *` of SE_FreeFileDataAfterLoad, stringed_interface.cpp:117.
// AI: Raven hands the block that FS_ReadFile gave. The overload hands the handle of the block the Slots covers to the original.
public func FS_FreeFile(_ buffer: Slots<JKAShared.byte>) {
    FS_FreeFile(OpaquePointer(buffer.base))
}

/**
```
=================
FS_LoadZipFile

Creates a new pak_t in the search chain for the contents
of a zip file.
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1423
private func FS_LoadZipFile(_ zipfile: String, _ basename: String) -> Pack? {
    return Unz_global_info.scratch { gi -> Pack? in
        Unz_file_info.scratch { file_info -> Pack? in
            let buildBuffer: Slots<FileInPack>
            let pack: Pack
            let uf: OpaquePointer?
            var err: Int32
            var filename_inzip = CharBuf(MAX_ZPATH)
            // AI: Raven passes NULL for the comment. The call passes a scratch CharBuf with a size of 0, so it reads and writes no byte.
            var szComment = CharBuf(1)
            var i: Int32
            var len: Int32
            var hash: CLong
            var fs_numHeaderLongs: Int32
            let fs_headerLongs: Slots<Int32>

            fs_numHeaderLongs = 0

            uf = unzOpen(zipfile)
            err = unzGetGlobalInfo(uf, gi)

            if err != UNZ_OK {
                return nil
            }

            // The `uLong` count narrows into the `int` total, as C's add does.
            fs_packFiles += Int32(truncatingIfNeeded: gi.number_entry)

            len = 0
            unzGoToFirstFile(uf)
            i = 0
            while CUnsignedLong(i) < gi.number_entry {
                err = unzGetCurrentFileInfo(uf, file_info, &filename_inzip, CUnsignedLong(filename_inzip.count), nil, 0, &szComment, 0)
                if err != UNZ_OK {
                    break
                }
                len += strlen(filename_inzip) + 1
                unzGoToNextFile(uf)
                i += 1
            }

            // AI: Raven copies each name into the block after the records. The name setter of the view keeps the text in the string pool, so those bytes stay unused.
            buildBuffer = Slots<FileInPack>(Z_Malloc((Int32(truncatingIfNeeded: gi.number_entry) * Int32(FileInPack.byteCount)) + len, TAG_FILESYS, true), count: gi.number_entry)
            fs_headerLongs = Slots<Int32>(scalars: Z_Malloc(Int32(truncatingIfNeeded: gi.number_entry) * Int32(Int32.byteCount), TAG_FILESYS, true), count: Int(gi.number_entry))

            // get the hash table size from the number of files in the zip
            // because lots of custom pk3 files have less than 32 or 64 files
            i = 1
            while i <= MAX_FILEHASH_SIZE {
                if CUnsignedLong(i) > gi.number_entry {
                    break
                }
                i <<= 1
            }

            // The table of `i` record pointers follows the record in the block, and `UInt.byteCount` is the size of one pointer.
            let packBlock = Z_Malloc(Int32(Pack.byteCount) + i * Int32(UInt.byteCount), TAG_FILESYS, true)
            pack = Pack(packBlock)
            pack.hashSize = i
            pack.hashTable = Slots(pointers: packBlock + Pack.byteCount, count: Int(i))
            i = 0
            while i < pack.hashSize {
                pack.hashTable![i] = nil
                i += 1
            }

            Q_strncpyz(&pack.pakFilenameBuffer, zipfile, Int32(pack.pakFilenameBuffer.count))
            Q_strncpyz(&pack.pakBasenameBuffer, basename, Int32(pack.pakBasenameBuffer.count))

            // strip .pk3 if needed
            if strlen(pack.pakBasename) > 4 && Q_stricmp(TextCursor(pack.pakBasenameBuffer, at: strlen(pack.pakBasename) - 4).text, ".pk3") == 0 {
                pack.pakBasenameBuffer[strlen(pack.pakBasename) - 4] = 0
            }

            pack.packHandle = uf
            pack.numfiles = Int32(truncatingIfNeeded: gi.number_entry)
            unzGoToFirstFile(uf)

            i = 0
            while CUnsignedLong(i) < gi.number_entry {
                err = unzGetCurrentFileInfo(uf, file_info, &filename_inzip, CUnsignedLong(filename_inzip.count), nil, 0, &szComment, 0)
                if err != UNZ_OK {
                    break
                }
                if file_info.uncompressed_size > 0 {
                    // LittleLong of the WinDed arm is its argument, and the `uLong` narrows into the `int` slot.
                    fs_headerLongs[fs_numHeaderLongs] = Int32(truncatingIfNeeded: file_info.crc)
                    fs_numHeaderLongs += 1
                }
                Q_strlwr(&filename_inzip)
                hash = FS_HashFileName(String(filename_inzip), pack.hashSize)
                buildBuffer[i].name = String(filename_inzip)
                // store the file position in the zip
                unzGetCurrentFileInfoPosition(uf, &buildBuffer[i].pos)
                //
                buildBuffer[i].next = pack.hashTable![hash]
                pack.hashTable![hash] = buildBuffer[i]
                unzGoToNextFile(uf)
                i += 1
            }

            pack.checksum = Int32(bitPattern: Com_BlockChecksum(fs_headerLongs.bytes, 4 * fs_numHeaderLongs))
            // LittleLong of the WinDed arm is its argument.
            pack.pure_checksum = Int32(bitPattern: Com_BlockChecksumKey(fs_headerLongs.bytes, 4 * fs_numHeaderLongs, fs_checksumFeed))
            // Raven's `pack->checksum = LittleLong( pack->checksum )` and the same line for `pure_checksum` have no line, because LittleLong of the WinDed arm is its argument.

            Z_Free(OpaquePointer(fs_headerLongs.base))

            pack.buildBufferSlots = buildBuffer
            return pack
        }
    }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1534
private func FS_ReturnPath(_ zname: String, _ zpath: inout JKAShared.CharBuf, _ depth: inout Int32) -> Int32 {
    var len: Int32
    var at: Int32
    var newdep: Int32
    // Raven indexes his own `zname` parameter by byte, so the body reads a CharBuf of it.
    let zname = CharBuf(zname)

    newdep = 0
    zpath[0] = 0
    len = 0
    at = 0

    while zname[at] != 0 {
        if zname[at] == Int32(ascii: "/") || zname[at] == Int32(ascii: "\\") {
            len = at
            newdep += 1
        }
        at += 1
    }
    strcpy(&zpath, zname)
    zpath[len] = 0
    depth = newdep

    return len
}

/**
```
==================
FS_AddFileToList
==================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1562
private func FS_AddFileToList(_ name: String, _ list: inout ArraySlice<String>, _ nfiles: Int32) -> Int32 {
    var i: Int32
    // Raven assigns his own `nfiles` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var nfiles = nfiles

    if nfiles == MAX_FOUND_FILES - 1 {
        return nfiles
    }
    i = 0
    while i < nfiles {
        if Q_stricmp(name, list[list.startIndex + i]) == 0 {
            return nfiles // allready in list
        }
        i += 1
    }
    list[list.startIndex + nfiles] = CopyString(name)
    nfiles += 1

    return nfiles
}

/**
```
===============
FS_ListFilteredFiles

Returns a uniqued list of files that match the given criteria
from all search paths
===============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1587
public func FS_ListFilteredFiles(_ path: String, _ `extension`: String, _ filter: String?, _ numfiles: inout Int32) -> [String] {
    var nfiles: Int32
    var listCopy: [String]
    var list = [String](repeating: "", count: Int(MAX_FOUND_FILES))
    var search: Searchpath?
    var i: Int32
    var pathLength: Int32
    let extensionLength: Int32
    var length: Int32
    var pathDepth: Int32 = 0
    var temp: Int32
    var pak: Pack
    var buildBuffer: Slots<FileInPack>
    var zpath = CharBuf(MAX_ZPATH)

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    // Raven's `if ( !path )` and `if ( !extension )` arms have no path here, because the two texts are never NULL.

    pathLength = strlen(path)
    // Port-note: Raven reads `path[-1]` for an empty path, which FS_NewDir_f passes.
    // The test reads no byte before the text, so the length stays 0.
    if pathLength > 0 && (CharBuf(path)[pathLength - 1] == Int32(ascii: "\\") || CharBuf(path)[pathLength - 1] == Int32(ascii: "/")) {
        pathLength -= 1
    }
    extensionLength = strlen(`extension`)
    nfiles = 0
    FS_ReturnPath(path, &zpath, &pathDepth)

    //
    // search through the path, one element at a time, adding to list
    //
    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack != nil {

            //ZOID:  If we are pure, don't search for files on paks that
            // aren't on the pure list
            if !FS_PakIsPure(search!.pack!) {
                search = search!.next
                continue
            }

            // look through all the pak file elements
            pak = search!.pack!
            buildBuffer = pak.buildBufferSlots
            i = 0
            while i < pak.numfiles {
                let name: String
                var zpathLen: Int32
                var depth: Int32 = 0

                // check for directory match
                name = buildBuffer[i].name!
                //
                if filter != nil {
                    // case insensitive
                    if Com_FilterPath(filter, name, 0) == 0 {
                        i += 1
                        continue
                    }
                    // unique the match
                    nfiles = FS_AddFileToList(name, &list[...], nfiles)
                } else {

                    zpathLen = FS_ReturnPath(name, &zpath, &depth)

                    if (depth - pathDepth) > 2 || pathLength > zpathLen || Q_stricmpn(name, path, pathLength) != 0 {
                        i += 1
                        continue
                    }

                    // check for extension match
                    length = strlen(name)
                    if length < extensionLength {
                        i += 1
                        continue
                    }

                    if Q_stricmp(TextCursor(CharBuf(name), at: length - extensionLength).text, `extension`) != 0 {
                        i += 1
                        continue
                    }
                    // unique the match

                    temp = pathLength
                    if pathLength != 0 {
                        temp += 1 // include the '/'
                    }
                    nfiles = FS_AddFileToList(TextCursor(CharBuf(name), at: temp).text, &list[...], nfiles)
                }
                i += 1
            }
        } else if search!.dir != nil { // scan for files in the filesystem
            let netpath: String
            var numSysFiles: Int32 = 0
            let sysFiles: [String]
            var name: String

            // don't scan directories for files if we are pure or restricted
            // Raven's `!extension` term has no path here, because the text is never NULL.
            if (fs_restrict!.integer != 0 || fs_numServerPaks != 0) && (Q_stricmp(`extension`, "fcf") != 0 || fs_restrict!.integer != 0) {
                //rww - allow scanning for fcf files outside of pak even if pure
                search = search!.next
                continue
            } else {
                netpath = FS_BuildOSPath(search!.dir!.path, search!.dir!.gamedir, path)
                sysFiles = Sys_ListFiles(netpath, `extension`, filter, &numSysFiles, false)
                i = 0
                while i < numSysFiles {
                    // unique the match
                    name = sysFiles[i]
                    nfiles = FS_AddFileToList(name, &list[...], nfiles)
                    i += 1
                }
                Sys_FreeFileList(sysFiles)
            }
        }
        search = search!.next
    }

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

    return listCopy
}

/**
```
=================
FS_ListFiles
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1724
public func FS_ListFiles(_ path: String, _ `extension`: String, _ numfiles: inout Int32) -> [String] {
    return FS_ListFilteredFiles(path, `extension`, nil, &numfiles)
}

/**
```
=================
FS_FreeFileList
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1733
public func FS_FreeFileList(_ fileList: [String]) {
    //rwwRMG - changed to fileList to not conflict with list type

    if fs_searchpaths == nil {
        Com_Error(ERR_FATAL, "Filesystem call made without initialization\n")
    }

    // AI: Raven frees each CopyString text and the Z_Malloc table. The list is a Swift array that frees itself, so the function frees nothing.
}

/**
```
================
FS_GetFileList
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1758
public func FS_GetFileList(_ path: String, _ `extension`: String, _ listbuf: inout JKAShared.CharBuf, _ bufsize: Int32) -> Int32 {
    var nFiles: Int32
    var i: Int32
    var nTotal: Int32
    var nLen: Int32
    var pFiles: [String] = []
    // Raven steps his own `listbuf` parameter, so the body writes at a byte offset into it.
    var listbufIndex: Int32 = 0

    listbuf[0] = 0
    nFiles = 0
    nTotal = 0

    if Q_stricmp(path, "$modlist") == 0 {
        return FS_GetModList(&listbuf, bufsize)
    }

    pFiles = FS_ListFiles(path, `extension`, &nFiles)

    i = 0
    while i < nFiles {
        nLen = strlen(pFiles[i]) + 1
        if nTotal + nLen + 1 < bufsize {
            strcpy(&listbuf, pFiles[i], at: listbufIndex)
            listbufIndex += nLen
            nTotal += nLen
        } else {
            nFiles = i
            break
        }
        i += 1
    }

    FS_FreeFileList(pFiles)

    return nFiles
}

// NOTE: could prolly turn out useful for the win32 version too, but it's used only by linux and Mac OS X
//#if defined(__linux__) || defined(MACOS_X)
/**
```
=======================
Sys_ConcatenateFileLists

mkv: Naive implementation. Concatenates three lists into a
     new list, and frees the old lists from the heap.
bk001129 - from cvs1.17 (mkv)

FIXME TTimo those two should move to common.c next to Sys_ListFiles
=======================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1803
private func Sys_CountFileList(_ list: [String]) -> UInt32 {
    var i: Int32 = 0

    // AI: Raven walks the list to its NULL. The array count ends the list, so the walk stops at the count.
    while i < list.count {
        i += 1
    }
    return UInt32(bitPattern: i)
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1818
private func Sys_ConcatenateFileLists(_ list0: [String], _ list1: [String], _ list2: [String]) -> [String] {
    var totalLength: Int32 = 0
    var cat: [String]

    totalLength += Int32(bitPattern: Sys_CountFileList(list0))
    totalLength += Int32(bitPattern: Sys_CountFileList(list1))
    totalLength += Int32(bitPattern: Sys_CountFileList(list2))

    /* Create new list. */
    // AI: Raven copies the texts into a Z_Malloc table of `totalLength + 1` slots. The array is the table, and its count ends the list.
    cat = []
    cat.reserveCapacity(Int(totalLength))

    /* Copy over lists. */
    for src in list0 {
        cat.append(src)
    }
    for src in list1 {
        cat.append(src)
    }
    for src in list2 {
        cat.append(src)
    }

    // Terminate the list
    // Free our old lists.
    // NOTE: not freeing their content, it's been merged in dst and still being used
    // AI: Raven frees the three old tables with Z_Free. Each list is a Swift array that frees itself.

    return cat
}

/**
```
================
FS_GetModList

Returns a list of mod directory names
A mod directory is a peer to base with a pk3 in it
The directories are searched in base path, cd path and home path
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1866
public func FS_GetModList(_ listbuf: inout JKAShared.CharBuf, _ bufsize: Int32) -> Int32 {
    var nMods: Int32
    var i: Int32
    var j: Int32
    var nTotal: Int32
    var nLen: Int32
    var nPaks: Int32
    var nPotential: Int32
    var nDescLen: Int32
    var pFiles: [String] = []
    var pPaks: [String] = []
    var name: String
    var path: String
    var descPath = CharBuf(MAX_OSPATH)
    var descHandle: fileHandle_t = 0
    // Raven steps his own `listbuf` parameter, so the body writes at a byte offset into it.
    var listbufIndex: Int32 = 0

    var dummy: Int32 = 0
    var pFiles0: [String] = []
    var pFiles1: [String] = []
    var pFiles2: [String] = []
    var bDrop: Bool = false

    listbuf[0] = 0
    nTotal = 0
    nPotential = nTotal
    nMods = nPotential

    pFiles0 = Sys_ListFiles(fs_homepath!.string!, nil, nil, &dummy, true)
    pFiles1 = Sys_ListFiles(fs_basepath!.string!, nil, nil, &dummy, true)
    pFiles2 = Sys_ListFiles(fs_cdpath!.string!, nil, nil, &dummy, true)
    // we searched for mods in the three paths
    // it is likely that we have duplicate names now, which we will cleanup below
    pFiles = Sys_ConcatenateFileLists(pFiles0, pFiles1, pFiles2)
    nPotential = Int32(bitPattern: Sys_CountFileList(pFiles))

    i = 0
    while i < nPotential {
        name = pFiles[i]
        // NOTE: cleaner would involve more changes
        // ignore duplicate mod directories
        if i != 0 {
            bDrop = false
            j = 0
            while j < i {
                if Q_stricmp(pFiles[j], name) == 0 {
                    // this one can be dropped
                    bDrop = true
                    break
                }
                j += 1
            }
        }
        if bDrop {
            i += 1
            continue
        }
        // we drop "base" "." and ".."
        if Q_stricmp(name, "base") != 0 && Q_stricmpn(name, ".", 1) != 0 {
            // now we need to find some .pk3 files to validate the mod
            // NOTE TTimo: (actually I'm not sure why .. what if it's a mod under developement with no .pk3?)
            // we didn't keep the information when we merged the directory names, as to what OS Path it was found under
            //   so it could be in base path, cd path or home path
            //   we will try each three of them here (yes, it's a bit messy)
            path = FS_BuildOSPath(fs_basepath!.string!, name, "")
            nPaks = 0
            pPaks = Sys_ListFiles(path, ".pk3", nil, &nPaks, false)
            Sys_FreeFileList(pPaks) // we only use Sys_ListFiles to check wether .pk3 files are present

            /* Try on cd path */
            if nPaks <= 0 {
                path = FS_BuildOSPath(fs_cdpath!.string!, name, "")
                nPaks = 0
                pPaks = Sys_ListFiles(path, ".pk3", nil, &nPaks, false)
                Sys_FreeFileList(pPaks)
            }

            /* try on home path */
            if nPaks <= 0 {
                path = FS_BuildOSPath(fs_homepath!.string!, name, "")
                nPaks = 0
                pPaks = Sys_ListFiles(path, ".pk3", nil, &nPaks, false)
                Sys_FreeFileList(pPaks)
            }

            if nPaks > 0 {
                nLen = strlen(name) + 1
                // nLen is the length of the mod path
                // we need to see if there is a description available
                descPath[0] = 0
                strcpy(&descPath, name)
                strcat(&descPath, "/description.txt")
                nDescLen = FS_SV_FOpenFileRead(String(descPath), &descHandle)
                if nDescLen > 0 && descHandle != 0 {
                    let file: OpaquePointer?
                    file = FS_FileForHandle(descHandle)
                    descPath.zero()
                    nDescLen = FileBackend.fread(&descPath, at: 0, 1, 48, file)
                    if nDescLen >= 0 {
                        descPath[nDescLen] = 0
                    }
                    FS_FCloseFile(descHandle)
                } else {
                    strcpy(&descPath, name)
                }
                nDescLen = strlen(descPath) + 1

                if nTotal + nLen + 1 + nDescLen + 1 < bufsize {
                    strcpy(&listbuf, name, at: listbufIndex)
                    listbufIndex += nLen
                    strcpy(&listbuf, String(descPath), at: listbufIndex)
                    listbufIndex += nDescLen
                    nTotal += nLen + nDescLen
                    nMods += 1
                } else {
                    break
                }
            }
        }
        i += 1
    }
    Sys_FreeFileList(pFiles)

    return nMods
}

/**
```
================
FS_Dir_f
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1989
public func FS_Dir_f() {
    let path: String
    let `extension`: String
    let dirnames: [String]
    var ndirs: Int32 = 0
    var i: Int32

    if Cmd_Argc() < 2 || Cmd_Argc() > 3 {
        Com_Printf("usage: dir <directory> [extension]\n")
        return
    }

    if Cmd_Argc() == 2 {
        path = Cmd_Argv(1)
        `extension` = ""
    } else {
        path = Cmd_Argv(1)
        `extension` = Cmd_Argv(2)
    }

    Com_Printf("Directory of %s %s\n", path, `extension`)
    Com_Printf("---------------\n")

    dirnames = FS_ListFiles(path, `extension`, &ndirs)

    i = 0
    while i < ndirs {
        Com_Printf("%s\n", dirnames[i])
        i += 1
    }
    FS_FreeFileList(dirnames)
}

/**
```
===========
FS_ConvertPath
===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2025
public func FS_ConvertPath(_ s: inout JKAShared.CharBuf) {
    var sIndex: Int32 = 0
    while s[sIndex] != 0 {
        if s[sIndex] == Int32(ascii: "\\") || s[sIndex] == Int32(ascii: ":") {
            s[sIndex] = Int32(ascii: "/")
        }
        sIndex += 1
    }
}

/**
```
===========
FS_PathCmp

Ignore case and seprator char distinctions
===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2041
public func FS_PathCmp(_ s1: String, _ s2: String) -> Int32 {
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

        if c1 < c2 {
            return -1 // strings not equal
        }
        if c1 > c2 {
            return 1
        }
    } while c1 != 0

    return 0 // strings are equal
}

/**
```
================
FS_SortFileList
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2078
public func FS_SortFileList(_ filelist: inout [String], _ numfiles: Int32) {
    var i: Int32
    var j: Int32
    var k: Int32
    var numsortedfiles: Int32
    var sortedlist: [String]

    // AI: Raven sorts into a Z_Malloc table of `numfiles + 1` slots. The table is a Swift array, and the empty text is his NULL.
    sortedlist = [String](repeating: "", count: Int(numfiles + 1))
    sortedlist[0] = ""
    numsortedfiles = 0
    i = 0
    while i < numfiles {
        j = 0
        while j < numsortedfiles {
            if FS_PathCmp(filelist[i], sortedlist[j]) < 0 {
                break
            }
            j += 1
        }
        k = numsortedfiles
        while k > j {
            sortedlist[k] = sortedlist[k - 1]
            k -= 1
        }
        sortedlist[j] = filelist[i]
        numsortedfiles += 1
        i += 1
    }
    // AI: Raven copies the sorted pointers back with Com_Memcpy and frees the table with Z_Free. The loop copies each text, and the array frees itself.
    i = 0
    while i < numfiles {
        filelist[i] = sortedlist[i]
        i += 1
    }
}

/**
```
================
FS_NewDir_f
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2106
public func FS_NewDir_f() {
    let filter: String
    var dirnames: [String]
    var ndirs: Int32 = 0
    var i: Int32

    if Cmd_Argc() < 2 {
        Com_Printf("usage: fdir <filter>\n")
        Com_Printf("example: fdir *q3dm*.bsp\n")
        return
    }

    filter = Cmd_Argv(1)

    Com_Printf("---------------\n")

    dirnames = FS_ListFilteredFiles("", "", filter, &ndirs)

    FS_SortFileList(&dirnames, ndirs)

    i = 0
    while i < ndirs {
        var dirname = CharBuf(dirnames[i])
        FS_ConvertPath(&dirname)
        dirnames[i] = String(dirname)
        Com_Printf("%s\n", dirnames[i])
        i += 1
    }
    Com_Printf("%d files listed\n", ndirs)
    FS_FreeFileList(dirnames)
}

/**
```
============
FS_Path_f

============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2140
public func FS_Path_f() {
    var s: Searchpath?
    var i: Int32

    Com_Printf("Current search path:\n")
    s = fs_searchpaths
    while s != nil {
        if s!.pack != nil {
            Com_Printf("%s (%i files)\n", s!.pack!.pakFilename, s!.pack!.numfiles)
            if fs_numServerPaks != 0 {
                if !FS_PakIsPure(s!.pack!) {
                    Com_Printf("    not on the pure list\n")
                } else {
                    Com_Printf("    on the pure list\n")
                }
            }
        } else {
            Com_Printf("%s/%s\n", s!.dir!.path, s!.dir!.gamedir)
        }
        s = s!.next
    }


    Com_Printf("\n")
    i = 1
    while i < MAX_FILE_HANDLES {
        if fsh[i].handleFiles.file.o != nil {
            Com_Printf("handle %i: %s\n", i, fsh[i].name)
        }
        i += 1
    }
}

/**
```
============
FS_TouchFile_f

The only purpose of this function is to allow game script files to copy
arbitrary files furing an "fs_copyfiles 1" run.
============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2177
public func FS_TouchFile_f() {
    var f: fileHandle_t = 0

    if Cmd_Argc() != 2 {
        Com_Printf("Usage: touchFile <file>\n")
        return
    }

    FS_FOpenFileRead(Cmd_Argv(1), &f, false)
    if f != 0 {
        FS_FCloseFile(f)
    }
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:2194
private func paksort(_ a: String, _ b: String) -> Int32 {
    let aa: String
    let bb: String

    aa = a
    bb = b

    return FS_PathCmp(aa, bb)
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:2212
private func FS_AddGameDirectory(_ path: String, _ dir: String) {
    var sp: Searchpath?
    var i: Int32
    var search: Searchpath
    let thedir: Searchpath
    var pak: Pack?
    var pakfile: CharBuf
    var numfiles: Int32 = 0
    let pakfiles: [String]
    var sorted = [String](repeating: "", count: Int(MAX_PAKFILES))

    // this fixes the case where fs_basepath is the same as fs_cdpath
    // which happens on full installs
    sp = fs_searchpaths
    while sp != nil {
        if sp!.dir != nil && Q_stricmp(sp!.dir!.path, path) == 0 && Q_stricmp(sp!.dir!.gamedir, dir) == 0 {
            return // we've already got this one
        }
        sp = sp!.next
    }

    Q_strncpyz(&fs_gamedir, dir, Int32(fs_gamedir.count))

    //
    // add the directory to the search path
    //
    search = Searchpath(Z_Malloc(Int32(Searchpath.byteCount), TAG_FILESYS, true))
    search.dir = Directory(Z_Malloc(Int32(Directory.byteCount), TAG_FILESYS, true))

    Q_strncpyz(&search.dir!.pathBuffer, path, Int32(search.dir!.pathBuffer.count))
    Q_strncpyz(&search.dir!.gamedirBuffer, dir, Int32(search.dir!.gamedirBuffer.count))
    search.next = fs_searchpaths
    fs_searchpaths = search

    thedir = search

    // find all pak files in this directory
    pakfile = CharBuf(FS_BuildOSPath(path, dir, ""))
    pakfile[strlen(pakfile) - 1] = 0 // strip the trailing slash

    pakfiles = Sys_ListFiles(String(pakfile), ".pk3", nil, &numfiles, false)

    // sort them so that later alphabetic matches override
    // earlier ones.  This makes pak1.pk3 override pak0.pk3
    if numfiles > MAX_PAKFILES {
        numfiles = MAX_PAKFILES
    }
    i = 0
    while i < numfiles {
        sorted[i] = pakfiles[i]
        i += 1
    }

    qsort(&sorted, numfiles, paksort)

    i = 0
    while i < numfiles {
        pakfile = CharBuf(FS_BuildOSPath(path, dir, sorted[i]))
        pak = FS_LoadZipFile(String(pakfile), sorted[i])
        if pak == nil {
            i += 1
            continue
        }
        // store the game name for downloading
        strcpy(&pak!.pakGamenameBuffer, dir)

        search = Searchpath(Z_Malloc(Int32(Searchpath.byteCount), TAG_FILESYS, true))
        search.pack = pak

        // Raven's `&& thedir` term has no path here, because `thedir` is never NULL.
        if fs_dirbeforepak != nil && fs_dirbeforepak!.integer != 0 {
            var oldnext = thedir.next
            thedir.next = search

            while oldnext != nil {
                search.next = oldnext
                search = search.next!
                oldnext = oldnext!.next
            }
        } else {
            search.next = fs_searchpaths
            fs_searchpaths = search
        }
        i += 1
    }

    // done
    Sys_FreeFileList(pakfiles)
}

/**
```
================
FS_idPak
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2301
public func FS_idPak(_ pak: String, _ base: String) -> Bool {
    var i: Int32

    i = 0
    while i < NUM_ID_PAKS {
        if !FS_FilenameCompare(pak, va("%s/assets%d", base, i)) {
            break
        }
        i += 1
    }
    if i < NUM_ID_PAKS {
        return true
    }
    return false
}

/**
```
================
FS_ComparePaks

if dlstring == qtrue

Returns a list of pak files that we should download from the server. They all get stored
in the current gamedir and an FS_Restart will be fired up after we download them all.

The string is the format:

@remotename@localname [repeat]

static int		fs_numServerReferencedPaks;
static int		fs_serverReferencedPaks[MAX_SEARCH_PATHS];
static char		*fs_serverReferencedPakNames[MAX_SEARCH_PATHS];

----------------
dlstring == qfalse

we are not interested in a download string format, we want something human-readable
(this is used for diagnostics while connecting to a pure server)
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2339
public func FS_ComparePaks(_ neededpaks: inout JKAShared.CharBuf, _ len: Int32, _ dlstring: Bool) -> Bool {
    var sp: Searchpath?
    var havepak: Bool
    var badchecksum: Bool
    var i: Int32

    if fs_numServerReferencedPaks == 0 {
        return false // Server didn't send any pack information along
    }

    neededpaks[0] = 0

    i = 0
    while i < fs_numServerReferencedPaks {
        // Ok, see if we have this pak file
        badchecksum = false
        havepak = false

        // never autodownload any of the id paks
        if FS_idPak(fs_serverReferencedPakNames[i]!, "base") || FS_idPak(fs_serverReferencedPakNames[i]!, "missionpack") {
            i += 1
            continue
        }

        sp = fs_searchpaths
        while sp != nil {
            if sp!.pack != nil && sp!.pack!.checksum == fs_serverReferencedPaks[i] {
                havepak = true // This is it!
                break
            }
            sp = sp!.next
        }

        if !havepak && fs_serverReferencedPakNames[i] != nil && !fs_serverReferencedPakNames[i]!.isEmpty {
            // Don't got it

            if dlstring {
                // Remote name
                Q_strcat(&neededpaks, len, "@")
                Q_strcat(&neededpaks, len, fs_serverReferencedPakNames[i]!)
                Q_strcat(&neededpaks, len, ".pk3")

                // Local name
                Q_strcat(&neededpaks, len, "@")
                // Do we have one with the same name?
                if FS_SV_FileExists(va("%s.pk3", fs_serverReferencedPakNames[i]!)) {
                    var st = CharBuf(MAX_ZPATH)
                    // We already have one called this, we need to download it to another name
                    // Make something up with the checksum in it
                    Com_sprintf(&st, Int32(st.count), "%s.%08x.pk3", fs_serverReferencedPakNames[i]!, fs_serverReferencedPaks[i])
                    Q_strcat(&neededpaks, len, String(st))
                } else {
                    Q_strcat(&neededpaks, len, fs_serverReferencedPakNames[i]!)
                    Q_strcat(&neededpaks, len, ".pk3")
                }
            } else {
                Q_strcat(&neededpaks, len, fs_serverReferencedPakNames[i]!)
                Q_strcat(&neededpaks, len, ".pk3")
                // Do we have one with the same name?
                if FS_SV_FileExists(va("%s.pk3", fs_serverReferencedPakNames[i]!)) {
                    Q_strcat(&neededpaks, len, " (local file exists with wrong checksum)")
                }
                Q_strcat(&neededpaks, len, "\n")
            }
        }
        i += 1
    }
    if neededpaks[0] != 0 {
        return true
    }

    return false // We have them all
}

//rww - add search paths in for received svc_setgame
/// Source: oracle/codemp/qcommon/files_pc.cpp:2419
public func FS_UpdateGamedir() {
    if !fs_gamedirvar!.string!.isEmpty && Q_stricmp(fs_gamedirvar!.string!, BASEGAME) != 0 {
        if !fs_cdpath!.string!.isEmpty {
            FS_AddGameDirectory(fs_cdpath!.string!, fs_gamedirvar!.string!)
        }
        if !fs_basepath!.string!.isEmpty {
            FS_AddGameDirectory(fs_basepath!.string!, fs_gamedirvar!.string!)
        }
        if !fs_homepath!.string!.isEmpty && Q_stricmp(fs_homepath!.string!, fs_basepath!.string!) != 0 {
            FS_AddGameDirectory(fs_homepath!.string!, fs_gamedirvar!.string!)
        }
    }
}

/**
```
================
FS_ReorderPurePaks
NOTE TTimo: the reordering that happens here is not reflected in the cvars (\cvarlist *pak*)
  this can lead to misleading situations, see https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=540
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2445
private func FS_ReorderPurePaks() {
    // only relevant when connected to pure server
    if fs_numServerPaks == 0 {
        return
    }

    fs_reordered = false

    // AI: Raven walks `searchpath_t **` slots. Each slot is the Slots of one optional view, `fs_searchpathsSlot` and the `nextSlot` of a record.
    var p_insert_index = fs_searchpathsSlot // we insert in order at the beginning of the list
    var i: Int32 = 0
    while i < fs_numServerPaks {
        var p_previous = p_insert_index // track the pointer-to-current-item
        var s = p_insert_index[0]
        while let sp = s {
            // the part of the list before p_insert_index has been sorted already
            if sp.pack != nil && fs_serverPaks[i] == sp.pack!.checksum {
                fs_reordered = true
                // move this element to the insert list
                p_previous[0] = sp.next
                sp.next = p_insert_index[0]
                p_insert_index[0] = sp
                // increment insert list
                p_insert_index = sp.nextSlot
                break // iterate to next server pack
            }
            p_previous = sp.nextSlot
            s = sp.next
        }
        i += 1
    }
}

/**
```
================
FS_Startup
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2483
public func FS_Startup(_ gameName: String) {
    var homePath: String?

    Com_Printf("----- FS_Startup -----\n")

    fs_debug = Cvar_Get("fs_debug", "0", 0)
    fs_copyfiles = Cvar_Get("fs_copyfiles", "0", CVAR_INIT)
    fs_cdpath = Cvar_Get("fs_cdpath", Sys_DefaultCDPath(), CVAR_INIT)
    fs_basepath = Cvar_Get("fs_basepath", Sys_DefaultInstallPath(), CVAR_INIT)
    fs_basegame = Cvar_Get("fs_basegame", "", CVAR_INIT)
    homePath = Sys_DefaultHomePath()
    if homePath == nil || homePath!.isEmpty {
        homePath = fs_basepath!.string
    }
    fs_homepath = Cvar_Get("fs_homepath", homePath!, CVAR_INIT)
    fs_gamedirvar = Cvar_Get("fs_game", "", CVAR_INIT | CVAR_SYSTEMINFO)
    fs_restrict = Cvar_Get("fs_restrict", "", CVAR_INIT)

    fs_dirbeforepak = Cvar_Get("fs_dirbeforepak", "0", CVAR_INIT)

    // add search path elements in reverse priority order
    if !fs_cdpath!.string!.isEmpty {
        FS_AddGameDirectory(fs_cdpath!.string!, gameName)
    }
    if !fs_basepath!.string!.isEmpty {
        FS_AddGameDirectory(fs_basepath!.string!, gameName)
    }
    // fs_homepath is somewhat particular to *nix systems, only add if relevant
    // NOTE: same filtering below for mods and basegame
    if !fs_basepath!.string!.isEmpty && Q_stricmp(fs_homepath!.string!, fs_basepath!.string!) != 0 {
        FS_AddGameDirectory(fs_homepath!.string!, gameName)
    }

    // check for additional base game so mods can be based upon other mods
    if !fs_basegame!.string!.isEmpty && Q_stricmp(gameName, BASEGAME) == 0 && Q_stricmp(fs_basegame!.string!, gameName) != 0 {
        if !fs_cdpath!.string!.isEmpty {
            FS_AddGameDirectory(fs_cdpath!.string!, fs_basegame!.string!)
        }
        if !fs_basepath!.string!.isEmpty {
            FS_AddGameDirectory(fs_basepath!.string!, fs_basegame!.string!)
        }
        if !fs_homepath!.string!.isEmpty && Q_stricmp(fs_homepath!.string!, fs_basepath!.string!) != 0 {
            FS_AddGameDirectory(fs_homepath!.string!, fs_basegame!.string!)
        }
    }

    // check for additional game folder for mods
    if !fs_gamedirvar!.string!.isEmpty && Q_stricmp(gameName, BASEGAME) == 0 && Q_stricmp(fs_gamedirvar!.string!, gameName) != 0 {
        if !fs_cdpath!.string!.isEmpty {
            FS_AddGameDirectory(fs_cdpath!.string!, fs_gamedirvar!.string!)
        }
        if !fs_basepath!.string!.isEmpty {
            FS_AddGameDirectory(fs_basepath!.string!, fs_gamedirvar!.string!)
        }
        if !fs_homepath!.string!.isEmpty && Q_stricmp(fs_homepath!.string!, fs_basepath!.string!) != 0 {
            FS_AddGameDirectory(fs_homepath!.string!, fs_gamedirvar!.string!)
        }
    }

    // add our commands
    Cmd_AddCommand("path", FS_Path_f)
    Cmd_AddCommand("dir", FS_Dir_f)
    Cmd_AddCommand("fdir", FS_NewDir_f)
    Cmd_AddCommand("touchFile", FS_TouchFile_f)

    // https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=506
    // reorder the pure pk3 files according to server order
    FS_ReorderPurePaks()

    // print the current search paths
    FS_Path_f()

    fs_gamedirvar!.modified = false // We just loaded, it's not modified

    Com_Printf("----------------------\n")

    Com_Printf("%d files in pk3 files\n", fs_packFiles)
}

/**
```
===================
FS_SetRestrictions

Looks for product keys and restricts media add on ability
if the full version is not found
===================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2587
public func FS_SetRestrictions() {
    var path: Searchpath?
    // A buffer asks FS_ReadFile for the read, and the overload sets it to nil for a missing file, Raven's NULL.
    var productId: CharBuf? = CharBuf(0)

    // if fs_restrict is set, don't even look for the id file,
    // which allows the demo release to be tested even if
    // the full game is present
    if fs_restrict!.integer == 0 {
        // look for the full game id
        FS_ReadFile("productid.txt", &productId)
        if productId != nil {
            // check against the hardcoded string
            var seed: Int32
            var i: Int32

            seed = 102270
            i = 0
            while i < fs_scrambledProductId.count {
                if (Int32(fs_scrambledProductId[i]) ^ (seed & 255)) != productId![i] {
                    break
                }
                // Port-note: Raven's `int` product overflows, which C leaves undefined. The port wraps at 32 bits.
                seed = (69069 &* seed &+ 1)
                i += 1
            }

            FS_FreeFile(productId!)

            if i == fs_scrambledProductId.count {
                return // no restrictions
            }
            Com_Error(ERR_FATAL, "Invalid product identification")
        }
    }
    Cvar_Set("fs_restrict", "1")

    Com_Printf("\nRunning in restricted demo mode.\n\n")

    // restart the filesystem with just the demo directory
    FS_Shutdown(false)
    FS_Startup(DEMOGAME)

    // make sure that the pak file has the header checksum we expect
    path = fs_searchpaths
    while path != nil {
        if path!.pack != nil {
            // a tiny attempt to keep the checksum from being scannable from the exe
            // C converts the `int` checksum to `unsigned` for the compare with the unsigned constant.
            if (UInt32(bitPattern: path!.pack!.checksum) ^ 0x02261994) != (DEMO_PAK_CHECKSUM ^ 0x02261994) {
                Com_Error(ERR_FATAL, "Corrupted pak0.pk3: %u", path!.pack!.checksum)
            }
        }
        path = path!.next
    }
}

/**
```
=====================
FS_GamePureChecksum

Returns the checksum of the pk3 from which the server loaded the qagame.qvm
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2646
public func FS_GamePureChecksum() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(MAX_STRING_TOKENS)
    var search: Searchpath?

    info[0] = 0

    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack != nil {
            if (search!.pack!.referenced & FS_QAGAME_REF) != 0 {
                Com_sprintf(&info, Int32(info.count), "%d", search!.pack!.checksum)
            }
        }
        search = search!.next
    }

    return String(info)
}

/**
```
=====================
FS_LoadedPakChecksums

Returns a space separated string containing the checksums of all loaded pk3 files.
Servers with sv_pure set will get this string and pass it to clients.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2672
public func FS_LoadedPakChecksums() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(BIG_INFO_STRING)
    var search: Searchpath?

    info[0] = 0

    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack == nil {
            search = search!.next
            continue
        }

        Q_strcat(&info, Int32(info.count), va("%i ", search!.pack!.checksum))
        search = search!.next
    }

    return String(info)
}

/**
```
=====================
FS_LoadedPakNames

Returns a space separated string containing the names of all loaded pk3 files.
Servers with sv_pure set will get this string and pass it to clients.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2698
public func FS_LoadedPakNames() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(BIG_INFO_STRING)
    var search: Searchpath?

    info[0] = 0

    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack == nil {
            search = search!.next
            continue
        }

        if info[0] != 0 {
            Q_strcat(&info, Int32(info.count), " ")
        }
        Q_strcat(&info, Int32(info.count), search!.pack!.pakBasename)
        search = search!.next
    }

    return String(info)
}

/**
```
=====================
FS_LoadedPakPureChecksums

Returns a space separated string containing the pure checksums of all loaded pk3 files.
Servers with sv_pure use these checksums to compare with the checksums the clients send
back to the server.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2728
public func FS_LoadedPakPureChecksums() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(BIG_INFO_STRING)
    var search: Searchpath?

    info[0] = 0

    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack == nil {
            search = search!.next
            continue
        }

        Q_strcat(&info, Int32(info.count), va("%i ", search!.pack!.pure_checksum))
        search = search!.next
    }

    return String(info)
}

/**
```
=====================
FS_ReferencedPakChecksums

Returns a space separated string containing the checksums of all referenced pk3 files.
The server will send this to the clients so they can check which files should be auto-downloaded.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2754
public func FS_ReferencedPakChecksums() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(BIG_INFO_STRING)
    var search: Searchpath?

    info[0] = 0


    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack != nil {
            if search!.pack!.referenced != 0 || Q_stricmpn(search!.pack!.pakGamename, BASEGAME, strlen(BASEGAME)) != 0 {
                Q_strcat(&info, Int32(info.count), va("%i ", search!.pack!.checksum))
            }
        }
        search = search!.next
    }

    return String(info)
}

/**
```
=====================
FS_ReferencedPakPureChecksums

Returns a space separated string containing the pure checksums of all referenced pk3 files.
Servers with sv_pure set will get this string back from clients for pure validation

The string has a specific order, "cgame ui @ ref1 ref2 ref3 ..."
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2783
public func FS_ReferencedPakPureChecksums() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(BIG_INFO_STRING)
    var search: Searchpath?
    var nFlags: Int32
    var numPaks: Int32
    var checksum: Int32

    info[0] = 0

    checksum = fs_checksumFeed
    numPaks = 0
    nFlags = FS_CGAME_REF
    while nFlags != 0 {
        if (nFlags & FS_GENERAL_REF) != 0 {
            // add a delimter between must haves and general refs
            //Q_strcat(info, sizeof(info), "@ ");
            info[strlen(info) + 1] = 0
            info[strlen(info) + 2] = 0
            info[strlen(info)] = Int32(ascii: "@")
            info[strlen(info)] = Int32(ascii: " ")
        }
        search = fs_searchpaths
        while search != nil {
            // is the element a pak file and has it been referenced based on flag?
            if search!.pack != nil && (search!.pack!.referenced & nFlags) != 0 {
                Q_strcat(&info, Int32(info.count), va("%i ", search!.pack!.pure_checksum))
                if (nFlags & (FS_CGAME_REF | FS_UI_REF)) != 0 {
                    break
                }
                checksum ^= search!.pack!.pure_checksum
                numPaks += 1
            }
            search = search!.next
        }
        if fs_fakeChkSum != 0 {
            // only added if a non-pure file is referenced
            Q_strcat(&info, Int32(info.count), va("%i ", fs_fakeChkSum))
        }
        nFlags = nFlags >> 1
    }
    // last checksum is the encoded number of referenced pk3s
    checksum ^= numPaks
    Q_strcat(&info, Int32(info.count), va("%i ", checksum))

    return String(info)
}

/**
```
=====================
FS_ReferencedPakNames

Returns a space separated string containing the names of all referenced pk3 files.
The server will send this to the clients so they can check which files should be auto-downloaded.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2832
public func FS_ReferencedPakNames() -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var info = CharBuf(BIG_INFO_STRING)
    var search: Searchpath?

    info[0] = 0

    // we want to return ALL pk3's from the fs_game path
    // and referenced one's from base
    search = fs_searchpaths
    while search != nil {
        // is the element a pak file?
        if search!.pack != nil {
            if info[0] != 0 {
                Q_strcat(&info, Int32(info.count), " ")
            }
            if search!.pack!.referenced != 0 || Q_stricmpn(search!.pack!.pakGamename, BASEGAME, strlen(BASEGAME)) != 0 {
                Q_strcat(&info, Int32(info.count), search!.pack!.pakGamename)
                Q_strcat(&info, Int32(info.count), "/")
                Q_strcat(&info, Int32(info.count), search!.pack!.pakBasename)
            }
        }
        search = search!.next
    }

    return String(info)
}

/**
```
=====================
FS_ClearPakReferences
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2862
public func FS_ClearPakReferences(_ flags: Int32) {
    var search: Searchpath?
    // Raven assigns his own `flags` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var flags = flags

    if flags == 0 {
        flags = -1
    }
    search = fs_searchpaths
    while search != nil {
        // is the element a pak file and has it been referenced?
        if search!.pack != nil {
            search!.pack!.referenced &= ~flags
        }
        search = search!.next
    }
}

/**
```
=====================
FS_PureServerSetLoadedPaks

If the string is empty, all data sources will be allowed.
If not empty, only pk3 files that match one of the space
separated checksums will be checked for files, with the
exception of .cfg and .dat files.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2887
public func FS_PureServerSetLoadedPaks(_ pakSums: String, _ pakNames: String) {
    var i: Int32
    var c: Int32
    var d: Int32

    Cmd_TokenizeString(pakSums)

    c = Cmd_Argc()
    if c > MAX_SEARCH_PATHS {
        c = MAX_SEARCH_PATHS
    }

    fs_numServerPaks = c

    i = 0
    while i < c {
        fs_serverPaks[i] = atoi(Cmd_Argv(i))
        i += 1
    }

    if fs_numServerPaks != 0 {
        Com_DPrintf("Connected to a pure server.\n")
    } else {
        if fs_reordered {
            // https://zerowing.idsoftware.com/bugzilla/show_bug.cgi?id=540
            // force a restart to make sure the search order will be correct
            Com_DPrintf("FS search reorder is required\n")
            FS_Restart(fs_checksumFeed)
            return
        }
    }

    i = 0
    while i < c {
        // AI: Raven frees the CopyString block of the name.
        // CopyString returns the text and leaves its block in the zone, so the slot takes nil, Raven's NULL.
        fs_serverPakNames[i] = nil
        i += 1
    }
    // Raven tests `pakNames` for NULL.
    // Raven tests `*pakNames` for the empty text.
    if !pakNames.isEmpty {
        Cmd_TokenizeString(pakNames)

        d = Cmd_Argc()
        if d > MAX_SEARCH_PATHS {
            d = MAX_SEARCH_PATHS
        }

        i = 0
        while i < d {
            fs_serverPakNames[i] = CopyString(Cmd_Argv(i))
            i += 1
        }
    }
}

/**
```
=====================
FS_PureServerSetReferencedPaks

The checksums and names of the pk3 files referenced at the server
are sent to the client and stored here. The client will use these
checksums to see if any pk3 files need to be auto-downloaded.
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2947
public func FS_PureServerSetReferencedPaks(_ pakSums: String, _ pakNames: String) {
    var i: Int32
    var c: Int32
    var d: Int32

    Cmd_TokenizeString(pakSums)

    c = Cmd_Argc()
    if c > MAX_SEARCH_PATHS {
        c = MAX_SEARCH_PATHS
    }

    fs_numServerReferencedPaks = c

    i = 0
    while i < c {
        fs_serverReferencedPaks[i] = atoi(Cmd_Argv(i))
        i += 1
    }

    i = 0
    while i < c {
        // AI: Raven frees the CopyString block of the name.
        // CopyString returns the text and leaves its block in the zone, so the slot takes nil, Raven's NULL.
        fs_serverReferencedPakNames[i] = nil
        i += 1
    }
    // Raven tests `pakNames` for NULL.
    // Raven tests `*pakNames` for the empty text.
    if !pakNames.isEmpty {
        Cmd_TokenizeString(pakNames)

        d = Cmd_Argc()
        if d > MAX_SEARCH_PATHS {
            d = MAX_SEARCH_PATHS
        }

        i = 0
        while i < d {
            fs_serverReferencedPakNames[i] = CopyString(Cmd_Argv(i))
            i += 1
        }
    }
}

/**
```
================
FS_Restart
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2988
public func FS_Restart(_ checksumFeed: Int32) {
    // free anything we currently have loaded
    FS_Shutdown(false)

    // set the checksum feed
    fs_checksumFeed = checksumFeed

    // clear pak references
    FS_ClearPakReferences(0)

    // try to start up normally
    FS_Startup(BASEGAME)

    // see if we are going to allow add-ons
    FS_SetRestrictions()

    // if we can't find default.cfg, assume that the paths are
    // busted and error out now, rather than getting an unreadable
    // graphics screen when the font fails to load
    var buffer: CharBuf? = nil
    if FS_ReadFile("mpdefault.cfg", &buffer) <= 0 {
        // this might happen when connecting to a pure server not using BASEGAME/pak0.pk3
        // (for instance a TA demo server)
        if lastValidBase[0] != 0 {
            FS_PureServerSetLoadedPaks("", "")
            Cvar_Set("fs_basepath", String(lastValidBase))
            Cvar_Set("fs_gamedirvar", String(lastValidGame))
            lastValidBase[0] = 0
            lastValidGame[0] = 0
            Cvar_Set("fs_restrict", "0")
            FS_Restart(checksumFeed)
            Com_Error(ERR_DROP, "Invalid game folder\n")
            // Raven writes `return` after this call, which `Com_Error` never reaches.
        }
        Com_Error(ERR_FATAL, "Couldn't load mpdefault.cfg")
    }

    // bk010116 - new check before safeMode
    if Q_stricmp(fs_gamedirvar!.string!, String(lastValidGame)) != 0 {
        // skip the jampconfig.cfg if "safe" is on the command line
        if !Com_SafeMode() {
            Cbuf_AddText("exec jampserver.cfg\n")
        }
    }

    Q_strncpyz(&lastValidBase, fs_basepath!.string!, Int32(lastValidBase.count))
    Q_strncpyz(&lastValidGame, fs_gamedirvar!.string!, Int32(lastValidGame.count))
}

/**
```
=================
FS_ConditionalRestart
restart if necessary
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:3048
public func FS_ConditionalRestart(_ checksumFeed: Int32) -> Bool {
    if fs_gamedirvar!.modified || checksumFeed != fs_checksumFeed {
        FS_Restart(checksumFeed)
        return true
    }
    return false
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:3064
public func FS_FOpenFileByMode(_ qpath: String, _ f: inout Int32, _ mode: JKAShared.fsMode_t) -> Int32 {
    var r: Int32
    var sync: Bool

    sync = false

    switch mode {
    case FS_READ:
        r = FS_FOpenFileRead(qpath, &f, true)

    case FS_WRITE:
        f = FS_FOpenFileWrite(qpath)
        r = 0
        if f == 0 {
            r = -1
        }

    case FS_APPEND_SYNC:
        sync = true
        fallthrough

    case FS_APPEND:
        f = FS_FOpenFileAppend(qpath)
        r = 0
        if f == 0 {
            r = -1
        }

    default:
        Com_Error(ERR_FATAL, "FSH_FOpenFile: bad mode")
        // Raven writes `return -1` after this call, which `Com_Error` never reaches.
    }

    if f != 0 {
        if fsh[f].zipFile == true {
            // C narrows the `long` position to the `int` field.
            fsh[f].baseOffset = Int32(truncatingIfNeeded: unztell(fsh[f].handleFiles.file.z))
        } else {
            fsh[f].baseOffset = FileBackend.ftell(fsh[f].handleFiles.file.o)
        }
        fsh[f].fileSize = r
        fsh[f].streamed = false

        if mode == FS_READ {
            Sys_BeginStreamedFile(f, 0x4000)
            fsh[f].streamed = true
        }
    }
    fsh[f].handleSync = sync

    return r
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:3118
public func FS_FTell(_ f: JKAShared.fileHandle_t) -> Int32 {
    let pos: Int32
    if fsh[f].zipFile == true {
        // C narrows the `long` position to the `int` local.
        pos = Int32(truncatingIfNeeded: unztell(fsh[f].handleFiles.file.z))
    } else {
        pos = FileBackend.ftell(fsh[f].handleFiles.file.o)
    }
    return pos
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:3128
public func FS_Flush(_ f: JKAShared.fileHandle_t) {
    FileBackend.fflush(fsh[f].handleFiles.file.o)
}
