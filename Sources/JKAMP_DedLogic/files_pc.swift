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
let fs_scrambledProductId: [JKAShared.byte] = { () -> [JKAShared.byte] in portMissing("fs_scrambledProductId", source: "oracle/codemp/qcommon/files_pc.cpp:24") }()

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
// TODO: Port signature
// Raven wrote: qboolean FS_PakIsPure( pack_t *pack )
// No table row for `pack_t * pack`.
func FS_PakIsPure() -> Never {
    // TODO: Port FS_PakIsPure
    portMissing("FS_PakIsPure", source: "oracle/codemp/qcommon/files_pc.cpp:39")
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
    // TODO: Port FS_HashFileName
    portMissing("FS_HashFileName", source: "oracle/codemp/qcommon/files_pc.cpp:64")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:85
// TODO: Port signature
// Raven wrote: static FILE *FS_FileForHandle( fileHandle_t f )
// No table row for the return `FILE *`.
private func FS_FileForHandle() -> Never {
    // TODO: Port FS_FileForHandle
    portMissing("FS_FileForHandle", source: "oracle/codemp/qcommon/files_pc.cpp:85")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:100
func FS_ForceFlush(_ f: JKAShared.fileHandle_t) {
    // TODO: Port FS_ForceFlush
    portMissing("FS_ForceFlush", source: "oracle/codemp/qcommon/files_pc.cpp:100")
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
func FS_filelength(_ f: JKAShared.fileHandle_t) -> Int32 {
    // TODO: Port FS_filelength
    portMissing("FS_filelength", source: "oracle/codemp/qcommon/files_pc.cpp:117")
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
func FS_CreatePath(_ OSPath: inout JKAShared.CharBuf) -> Bool {
    // TODO: Port FS_CreatePath
    portMissing("FS_CreatePath", source: "oracle/codemp/qcommon/files_pc.cpp:138")
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
func FS_CopyFile(_ fromOSPath: inout JKAShared.CharBuf, _ toOSPath: inout JKAShared.CharBuf) {
    // TODO: Port FS_CopyFile
    portMissing("FS_CopyFile", source: "oracle/codemp/qcommon/files_pc.cpp:166")
}

/**
```
===========
FS_Remove

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:213
func FS_Remove(_ osPath: String) {
    // TODO: Port FS_Remove
    portMissing("FS_Remove", source: "oracle/codemp/qcommon/files_pc.cpp:213")
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
func FS_FileExists(_ file: String) -> Bool {
    // TODO: Port FS_FileExists
    portMissing("FS_FileExists", source: "oracle/codemp/qcommon/files_pc.cpp:227")
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
func FS_SV_FileExists(_ file: String) -> Bool {
    // TODO: Port FS_SV_FileExists
    portMissing("FS_SV_FileExists", source: "oracle/codemp/qcommon/files_pc.cpp:249")
}

/**
```
===========
FS_SV_FOpenFileWrite

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:272
func FS_SV_FOpenFileWrite(_ filename: String) -> JKAShared.fileHandle_t {
    // TODO: Port FS_SV_FOpenFileWrite
    portMissing("FS_SV_FOpenFileWrite", source: "oracle/codemp/qcommon/files_pc.cpp:272")
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
func FS_SV_FOpenFileRead(_ filename: String, _ fp: inout Int32) -> Int32 {
    // TODO: Port FS_SV_FOpenFileRead
    portMissing("FS_SV_FOpenFileRead", source: "oracle/codemp/qcommon/files_pc.cpp:313")
}

/**
```
===========
FS_SV_Rename

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:395
func FS_SV_Rename(_ from: String, _ to: String) {
    // TODO: Port FS_SV_Rename
    portMissing("FS_SV_Rename", source: "oracle/codemp/qcommon/files_pc.cpp:395")
}

/**
```
===========
FS_Rename

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:427
func FS_Rename(_ from: String, _ to: String) {
    // TODO: Port FS_Rename
    portMissing("FS_Rename", source: "oracle/codemp/qcommon/files_pc.cpp:427")
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
func FS_FCloseFile(_ f: JKAShared.fileHandle_t) {
    // TODO: Port FS_FCloseFile
    portMissing("FS_FCloseFile", source: "oracle/codemp/qcommon/files_pc.cpp:461")
}

/**
```
===========
FS_FOpenFileWrite

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:491
func FS_FOpenFileWrite(_ filename: String) -> JKAShared.fileHandle_t {
    // TODO: Port FS_FOpenFileWrite
    portMissing("FS_FOpenFileWrite", source: "oracle/codemp/qcommon/files_pc.cpp:491")
}

/**
```
===========
FS_FOpenFileAppend

===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:532
func FS_FOpenFileAppend(_ filename: String) -> JKAShared.fileHandle_t {
    // TODO: Port FS_FOpenFileAppend
    portMissing("FS_FOpenFileAppend", source: "oracle/codemp/qcommon/files_pc.cpp:532")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:568
// TODO: Port signature
// Raven wrote: bool Sys_GetFileTime(LPCSTR psFileName, FILETIME &ft)
// No table row for `int & ft`.
func Sys_GetFileTime() -> Never {
    // TODO: Port Sys_GetFileTime
    portMissing("Sys_GetFileTime", source: "oracle/codemp/qcommon/files_pc.cpp:568")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:600
func Sys_FileOutOfDate(_ psFinalFileName: String, _ psDataFileName: String) -> Bool {
    // TODO: Port Sys_FileOutOfDate
    portMissing("Sys_FileOutOfDate", source: "oracle/codemp/qcommon/files_pc.cpp:600")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:634
func FS_FileCacheable(_ filename: String) -> Bool {
    // TODO: Port FS_FileCacheable
    portMissing("FS_FileCacheable", source: "oracle/codemp/qcommon/files_pc.cpp:634")
}

/**
```
===========
FS_ShiftedStrStr
===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:649
func FS_ShiftedStrStr(_ string: String, _ substring: String, _ shift: Int32) -> String {
    // TODO: Port FS_ShiftedStrStr
    portMissing("FS_ShiftedStrStr", source: "oracle/codemp/qcommon/files_pc.cpp:649")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:672
func FS_FOpenFileRead(_ filename: String, _ file: inout Int32, _ uniqueFILE: Bool) -> Int32 {
    // TODO: Port FS_FOpenFileRead
    portMissing("FS_FOpenFileRead", source: "oracle/codemp/qcommon/files_pc.cpp:672")
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
func FS_Read2(_ buffer: OpaquePointer?, _ len: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    // TODO: Port FS_Read2
    portMissing("FS_Read2", source: "oracle/codemp/qcommon/files_pc.cpp:1007")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1026
func FS_Read(_ buffer: OpaquePointer?, _ len: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    // TODO: Port FS_Read
    portMissing("FS_Read", source: "oracle/codemp/qcommon/files_pc.cpp:1026")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1026
/// Raven's `buffer` takes a `char buf[N]` at msg.cpp:2070, and this overload reads into that buffer.
// AI: Raven hands a `char *` buffer to the `void *` of FS_Read. The overload takes the caller's CharBuf, the form trap_FS_Read has.
func FS_Read(_ buffer: inout CharBuf, _ len: Int32, _ f: JKAShared.fileHandle_t) -> Int32 {
    // Port-note: The CharBuf overload of the FS_Read row reads into the caller's buffer, and it waits on the body of FS_Read.
    // TODO: Port FS_Read
    portMissing("FS_Read", source: "oracle/codemp/qcommon/files_pc.cpp:1026")
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
func FS_Write(_ buffer: OpaquePointer?, _ len: Int32, _ h: JKAShared.fileHandle_t) -> Int32 {
    // TODO: Port FS_Write
    portMissing("FS_Write", source: "oracle/codemp/qcommon/files_pc.cpp:1079")
}

/**
```
=================
FS_Seek

=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1131
func FS_Seek(_ f: JKAShared.fileHandle_t, _ offset: CLong, _ origin: Int32) -> Int32 {
    // TODO: Port FS_Seek
    portMissing("FS_Seek", source: "oracle/codemp/qcommon/files_pc.cpp:1131")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1191
func FS_FileIsInPAK(_ filename: String, _ pChecksum: inout Int32) -> Int32 {
    // TODO: Port FS_FileIsInPAK
    portMissing("FS_FileIsInPAK", source: "oracle/codemp/qcommon/files_pc.cpp:1191")
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
func FS_ReadFile(_ qpath: String, _ buffer: inout OpaquePointer?) -> Int32 {
    // TODO: Port FS_ReadFile
    portMissing("FS_ReadFile", source: "oracle/codemp/qcommon/files_pc.cpp:1259")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1259
// Port-note: The optional overload of the FS_ReadFile row, for the `char *` callers and the NULL callers, files_common.cpp:502 and sv_ccmds.cpp:159.
// AI: Raven hands `(void **)&f` of a `char *f`, or NULL for the length alone. A nil buffer is Raven's NULL, and a read fills the CharBuf.
func FS_ReadFile(_ qpath: String, _ buffer: inout CharBuf?) -> Int32 {
    // TODO: Port FS_ReadFile
    portMissing("FS_ReadFile", source: "oracle/codemp/qcommon/files_pc.cpp:1259")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1259
// Port-note: The CharBuf overload of the FS_ReadFile row, for the `char *` callers, cmd_common.cpp:231 and cm_shader.cpp:113.
// AI: Raven hands `(void **)&f` of a `char *f`. This forward wraps the caller's CharBuf in the optional and writes the read back.
// AI: Raven sets `*buffer` to NULL for a missing file. The forward leaves the buffer empty, so a caller tests the length Raven returns, `len < 0`.
func FS_ReadFile(_ qpath: String, _ buffer: inout CharBuf) -> Int32 {
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
func FS_FreeFile(_ buffer: OpaquePointer?) {
    // TODO: Port FS_FreeFile
    portMissing("FS_FreeFile", source: "oracle/codemp/qcommon/files_pc.cpp:1379")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1379
// Port-note: The CharBuf overload of the FS_FreeFile row, for the `char *` callers of the FS_ReadFile forward, cmd_common.cpp:240.
// The overload does nothing, because a CharBuf owns its bytes and frees them when the caller drops it.
// AI: Raven frees the hunk block that FS_ReadFile gave. The overload takes the caller's CharBuf and frees nothing.
func FS_FreeFile(_ buffer: CharBuf) {
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
// TODO: Port signature
// Raven wrote: static pack_t *FS_LoadZipFile( char *zipfile, const char *basename )
// No table row for the return `pack_t *`.
private func FS_LoadZipFile() -> Never {
    // TODO: Port FS_LoadZipFile
    portMissing("FS_LoadZipFile", source: "oracle/codemp/qcommon/files_pc.cpp:1423")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1534
private func FS_ReturnPath(_ zname: String, _ zpath: inout JKAShared.CharBuf, _ depth: inout Int32) -> Int32 {
    // TODO: Port FS_ReturnPath
    portMissing("FS_ReturnPath", source: "oracle/codemp/qcommon/files_pc.cpp:1534")
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
    // TODO: Port FS_AddFileToList
    portMissing("FS_AddFileToList", source: "oracle/codemp/qcommon/files_pc.cpp:1562")
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
// TODO: Port signature
// Raven wrote: char **FS_ListFilteredFiles( const char *path, const char *extension, char *filter, int *numfiles )
// No table row for the return `char **`.
func FS_ListFilteredFiles() -> Never {
    // TODO: Port FS_ListFilteredFiles
    portMissing("FS_ListFilteredFiles", source: "oracle/codemp/qcommon/files_pc.cpp:1587")
}

/**
```
=================
FS_ListFiles
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1724
// TODO: Port signature
// Raven wrote: char **FS_ListFiles( const char *path, const char *extension, int *numfiles )
// No table row for the return `char **`.
func FS_ListFiles() -> Never {
    // TODO: Port FS_ListFiles
    portMissing("FS_ListFiles", source: "oracle/codemp/qcommon/files_pc.cpp:1724")
}

/**
```
=================
FS_FreeFileList
=================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1733
func FS_FreeFileList(_ fileList: inout JKAShared.TextCursor) {
    // TODO: Port FS_FreeFileList
    portMissing("FS_FreeFileList", source: "oracle/codemp/qcommon/files_pc.cpp:1733")
}

/**
```
================
FS_GetFileList
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1758
func FS_GetFileList(_ path: String, _ `extension`: String, _ listbuf: inout JKAShared.CharBuf, _ bufsize: Int32) -> Int32 {
    // TODO: Port FS_GetFileList
    portMissing("FS_GetFileList", source: "oracle/codemp/qcommon/files_pc.cpp:1758")
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
private func Sys_CountFileList(_ list: inout JKAShared.TextCursor) -> UInt32 {
    // TODO: Port Sys_CountFileList
    portMissing("Sys_CountFileList", source: "oracle/codemp/qcommon/files_pc.cpp:1803")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:1818
// TODO: Port signature
// Raven wrote: static char** Sys_ConcatenateFileLists( char **list0, char **list1, char **list2 )
// No table row for the return `char **`.
private func Sys_ConcatenateFileLists() -> Never {
    // TODO: Port Sys_ConcatenateFileLists
    portMissing("Sys_ConcatenateFileLists", source: "oracle/codemp/qcommon/files_pc.cpp:1818")
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
func FS_GetModList(_ listbuf: inout JKAShared.CharBuf, _ bufsize: Int32) -> Int32 {
    // TODO: Port FS_GetModList
    portMissing("FS_GetModList", source: "oracle/codemp/qcommon/files_pc.cpp:1866")
}

/**
```
================
FS_Dir_f
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:1989
func FS_Dir_f() {
    // TODO: Port FS_Dir_f
    portMissing("FS_Dir_f", source: "oracle/codemp/qcommon/files_pc.cpp:1989")
}

/**
```
===========
FS_ConvertPath
===========
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2025
func FS_ConvertPath(_ s: inout JKAShared.CharBuf) {
    // TODO: Port FS_ConvertPath
    portMissing("FS_ConvertPath", source: "oracle/codemp/qcommon/files_pc.cpp:2025")
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
func FS_PathCmp(_ s1: String, _ s2: String) -> Int32 {
    // TODO: Port FS_PathCmp
    portMissing("FS_PathCmp", source: "oracle/codemp/qcommon/files_pc.cpp:2041")
}

/**
```
================
FS_SortFileList
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2078
func FS_SortFileList(_ filelist: inout JKAShared.TextCursor, _ numfiles: Int32) {
    // TODO: Port FS_SortFileList
    portMissing("FS_SortFileList", source: "oracle/codemp/qcommon/files_pc.cpp:2078")
}

/**
```
================
FS_NewDir_f
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2106
func FS_NewDir_f() {
    // TODO: Port FS_NewDir_f
    portMissing("FS_NewDir_f", source: "oracle/codemp/qcommon/files_pc.cpp:2106")
}

/**
```
============
FS_Path_f

============
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2140
func FS_Path_f() {
    // TODO: Port FS_Path_f
    portMissing("FS_Path_f", source: "oracle/codemp/qcommon/files_pc.cpp:2140")
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
func FS_TouchFile_f() {
    // TODO: Port FS_TouchFile_f
    portMissing("FS_TouchFile_f", source: "oracle/codemp/qcommon/files_pc.cpp:2177")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:2194
private func paksort(_ a: OpaquePointer?, _ b: OpaquePointer?) -> Int32 {
    // TODO: Port paksort
    portMissing("paksort", source: "oracle/codemp/qcommon/files_pc.cpp:2194")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:2212
private func FS_AddGameDirectory(_ path: String, _ dir: String) {
    // TODO: Port FS_AddGameDirectory
    portMissing("FS_AddGameDirectory", source: "oracle/codemp/qcommon/files_pc.cpp:2212")
}

/**
```
================
FS_idPak
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2301
func FS_idPak(_ pak: String, _ base: String) -> Bool {
    // TODO: Port FS_idPak
    portMissing("FS_idPak", source: "oracle/codemp/qcommon/files_pc.cpp:2301")
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
func FS_ComparePaks(_ neededpaks: inout JKAShared.CharBuf, _ len: Int32, _ dlstring: Bool) -> Bool {
    // TODO: Port FS_ComparePaks
    portMissing("FS_ComparePaks", source: "oracle/codemp/qcommon/files_pc.cpp:2339")
}

//rww - add search paths in for received svc_setgame
/// Source: oracle/codemp/qcommon/files_pc.cpp:2419
func FS_UpdateGamedir() {
    // TODO: Port FS_UpdateGamedir
    portMissing("FS_UpdateGamedir", source: "oracle/codemp/qcommon/files_pc.cpp:2419")
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
    // TODO: Port FS_ReorderPurePaks
    portMissing("FS_ReorderPurePaks", source: "oracle/codemp/qcommon/files_pc.cpp:2445")
}

/**
```
================
FS_Startup
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2483
func FS_Startup(_ gameName: String) {
    // TODO: Port FS_Startup
    portMissing("FS_Startup", source: "oracle/codemp/qcommon/files_pc.cpp:2483")
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
func FS_SetRestrictions() {
    // TODO: Port FS_SetRestrictions
    portMissing("FS_SetRestrictions", source: "oracle/codemp/qcommon/files_pc.cpp:2587")
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
func FS_GamePureChecksum() -> String {
    // TODO: Port FS_GamePureChecksum
    portMissing("FS_GamePureChecksum", source: "oracle/codemp/qcommon/files_pc.cpp:2646")
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
func FS_LoadedPakChecksums() -> String {
    // TODO: Port FS_LoadedPakChecksums
    portMissing("FS_LoadedPakChecksums", source: "oracle/codemp/qcommon/files_pc.cpp:2672")
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
func FS_LoadedPakNames() -> String {
    // TODO: Port FS_LoadedPakNames
    portMissing("FS_LoadedPakNames", source: "oracle/codemp/qcommon/files_pc.cpp:2698")
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
func FS_LoadedPakPureChecksums() -> String {
    // TODO: Port FS_LoadedPakPureChecksums
    portMissing("FS_LoadedPakPureChecksums", source: "oracle/codemp/qcommon/files_pc.cpp:2728")
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
func FS_ReferencedPakChecksums() -> String {
    // TODO: Port FS_ReferencedPakChecksums
    portMissing("FS_ReferencedPakChecksums", source: "oracle/codemp/qcommon/files_pc.cpp:2754")
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
func FS_ReferencedPakPureChecksums() -> String {
    // TODO: Port FS_ReferencedPakPureChecksums
    portMissing("FS_ReferencedPakPureChecksums", source: "oracle/codemp/qcommon/files_pc.cpp:2783")
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
func FS_ReferencedPakNames() -> String {
    // TODO: Port FS_ReferencedPakNames
    portMissing("FS_ReferencedPakNames", source: "oracle/codemp/qcommon/files_pc.cpp:2832")
}

/**
```
=====================
FS_ClearPakReferences
=====================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2862
func FS_ClearPakReferences(_ flags: Int32) {
    // TODO: Port FS_ClearPakReferences
    portMissing("FS_ClearPakReferences", source: "oracle/codemp/qcommon/files_pc.cpp:2862")
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
func FS_PureServerSetLoadedPaks(_ pakSums: String, _ pakNames: String) {
    // TODO: Port FS_PureServerSetLoadedPaks
    portMissing("FS_PureServerSetLoadedPaks", source: "oracle/codemp/qcommon/files_pc.cpp:2887")
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
func FS_PureServerSetReferencedPaks(_ pakSums: String, _ pakNames: String) {
    // TODO: Port FS_PureServerSetReferencedPaks
    portMissing("FS_PureServerSetReferencedPaks", source: "oracle/codemp/qcommon/files_pc.cpp:2947")
}

/**
```
================
FS_Restart
================
```
*/
/// Source: oracle/codemp/qcommon/files_pc.cpp:2988
func FS_Restart(_ checksumFeed: Int32) {
    // TODO: Port FS_Restart
    portMissing("FS_Restart", source: "oracle/codemp/qcommon/files_pc.cpp:2988")
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
func FS_ConditionalRestart(_ checksumFeed: Int32) -> Bool {
    // TODO: Port FS_ConditionalRestart
    portMissing("FS_ConditionalRestart", source: "oracle/codemp/qcommon/files_pc.cpp:3048")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:3064
func FS_FOpenFileByMode(_ qpath: String, _ f: inout Int32, _ mode: JKAShared.fsMode_t) -> Int32 {
    // TODO: Port FS_FOpenFileByMode
    portMissing("FS_FOpenFileByMode", source: "oracle/codemp/qcommon/files_pc.cpp:3064")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:3118
func FS_FTell(_ f: JKAShared.fileHandle_t) -> Int32 {
    // TODO: Port FS_FTell
    portMissing("FS_FTell", source: "oracle/codemp/qcommon/files_pc.cpp:3118")
}

/// Source: oracle/codemp/qcommon/files_pc.cpp:3128
func FS_Flush(_ f: JKAShared.fileHandle_t) {
    // TODO: Port FS_Flush
    portMissing("FS_Flush", source: "oracle/codemp/qcommon/files_pc.cpp:3128")
}
