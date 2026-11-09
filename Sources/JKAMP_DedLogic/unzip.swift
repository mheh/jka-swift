import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/unzip.cpp:12
// Raven wrote: #define ZIP_fopen fopen
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/qcommon/unzip.cpp:13
// Raven wrote: #define ZIP_fclose fclose
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/qcommon/unzip.cpp:14
// Raven wrote: #define ZIP_fseek fseek
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/qcommon/unzip.cpp:15
// Raven wrote: #define ZIP_fread fread
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/qcommon/unzip.cpp:16
// Raven wrote: #define ZIP_ftell ftell
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/qcommon/unzip.cpp:235
let UNZ_BUFSIZE = (65536) as Int32

/// Source: oracle/codemp/qcommon/unzip.cpp:239
let UNZ_MAXFILENAMEINZIP = (256) as Int32

/// Source: oracle/codemp/qcommon/unzip.cpp:249
let SIZECENTRALDIRITEM = (0x2e) as Int32

/// Source: oracle/codemp/qcommon/unzip.cpp:250
let SIZEZIPLOCALHEADER = (0x1e) as Int32

/// Source: oracle/codemp/qcommon/unzip.cpp:300
let CASESENSITIVITYDEFAULTVALUE = 2 as Int32

/// Source: oracle/codemp/qcommon/unzip.cpp:306
// Raven wrote: #define STRCMPCASENOSENTIVEFUNCTION strcmpcasenosensitive_internal
private func STRCMPCASENOSENTIVEFUNCTION(_ fileName1: String, _ fileName2: String) -> Int32 {
    strcmpcasenosensitive_internal(fileName1, fileName2)
}

/// Source: oracle/codemp/qcommon/unzip.cpp:329
let BUFREADCOMMENT = (0x400) as Int32

/**
```
===========================================================================
   Reads a long in LSB order from the given gz_stream. Sets
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:255
// TODO: Port signature
// Raven wrote: static int unzlocal_getShort (ZIP_FILE* fin, uLong *pX)
// No table row for `FILE * fin`.
// Port-note: The signature waits for row U1 of the unzip round, so the function keeps its marker.
private func unzlocal_getShort() -> Never {
    // TODO: Port unzlocal_getShort
    portMissing("unzlocal_getShort", source: "oracle/codemp/qcommon/unzip.cpp:255")
}

/// Source: oracle/codemp/qcommon/unzip.cpp:265
// TODO: Port signature
// Raven wrote: static int unzlocal_getLong (ZIP_FILE *fin, uLong *pX)
// No table row for `FILE * fin`.
// Port-note: The signature waits for row U1 of the unzip round, so the function keeps its marker.
private func unzlocal_getLong() -> Never {
    // TODO: Port unzlocal_getLong
    portMissing("unzlocal_getLong", source: "oracle/codemp/qcommon/unzip.cpp:265")
}

/**
```
My own strcmpi / strcasecmp
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:277
private func strcmpcasenosensitive_internal(_ fileName1: String, _ fileName2: String) -> Int32 {
    // Raven steps his own two parameters through their bytes, so the body walks a CharBuf of each with a byte offset.
    let fileName1 = CharBuf(fileName1)
    let fileName2 = CharBuf(fileName2)
    var i1: Int32 = 0
    var i2: Int32 = 0
    while true {
        var c1: Int32 = fileName1[i1]
        i1 += 1
        var c2: Int32 = fileName2[i2]
        i2 += 1
        if (c1 >= Int32(ascii: "a")) && (c1 <= Int32(ascii: "z")) {
            c1 -= 0x20
        }
        if (c2 >= Int32(ascii: "a")) && (c2 <= Int32(ascii: "z")) {
            c2 -= 0x20
        }
        if c1 == 0 {
            return (c2 == 0) ? 0 : -1
        }
        if c2 == 0 {
            return 1
        }
        if c1 < c2 {
            return -1
        }
        if c1 > c2 {
            return 1
        }
    }
}

/**
```
   Compare two filename (fileName1,fileName2).
   If iCaseSenisivity = 1, comparision is case sensitivity (like strcmp)
   If iCaseSenisivity = 2, comparision is not case sensitivity (like strcmpi
                                                                or strcasecmp)
   If iCaseSenisivity = 0, case sensitivity is defaut of your operating system
        (like 1 on Unix, 2 on Windows)
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:318
func unzStringFileNameCompare(_ fileName1: String, _ fileName2: String, _ iCaseSensitivity: Int32) -> Int32 {
    // Raven assigns his own `iCaseSensitivity` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var iCaseSensitivity = iCaseSensitivity
    if iCaseSensitivity == 0 {
        iCaseSensitivity = CASESENSITIVITYDEFAULTVALUE
    }

    if iCaseSensitivity == 1 {
        return strcmp(fileName1, fileName2)
    }

    return STRCMPCASENOSENTIVEFUNCTION(fileName1, fileName2)
}

/**
```
  Locate the Central directory of a zipfile (at the end, just before
    the global comment)
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:335
// TODO: Port signature
// Raven wrote: static uLong unzlocal_SearchCentralDir(ZIP_FILE *fin)
// No table row for `FILE * fin`.
// Port-note: The signature waits for row U1 of the unzip round, so the function keeps its marker.
private func unzlocal_SearchCentralDir() -> Never {
    // TODO: Port unzlocal_SearchCentralDir
    portMissing("unzlocal_SearchCentralDir", source: "oracle/codemp/qcommon/unzip.cpp:335")
}

/// Source: oracle/codemp/qcommon/unzip.cpp:388
// TODO: Port signature
// Raven wrote: extern unzFile unzReOpen (const char* path, unzFile file)
// No table row for the return `unzFile`.
// Port-note: The signature waits for row U2 of the unzip round, so the function keeps its marker.
func unzReOpen() -> Never {
    // TODO: Port unzReOpen
    portMissing("unzReOpen", source: "oracle/codemp/qcommon/unzip.cpp:388")
}

/**
```
  Open a Zip file. path contain the full pathname (by example,
     on a Windows NT computer "c:\\test\\zlib109.zip" or on an Unix computer
	 "zlib/zlib109.zip".
	 If the zipfile cannot be opened (file don't exist or in not valid), the
	   return value is NULL.
     Else, the return value is a unzFile Handle, usable with other function
	   of this unzip package.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:413
// TODO: Port signature
// Raven wrote: extern unzFile unzOpen (const char* path)
// No table row for the return `unzFile`.
// Port-note: The signature waits for row U2 of the unzip round, so the function keeps its marker.
func unzOpen() -> Never {
    // TODO: Port unzOpen
    portMissing("unzOpen", source: "oracle/codemp/qcommon/unzip.cpp:413")
}

/**
```
  Close a ZipFile opened with unzipOpen.
  If there is files inside the .Zip opened with unzipOpenCurrentFile (see later),
    these files MUST be closed with unzipCloseCurrentFile before call unzipClose.
  return UNZ_OK if there is no problem.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:508
@discardableResult
func unzClose(_ file: OpaquePointer?) -> Int32 {
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)

    if s.pfile_in_zip_read != nil {
        unzCloseCurrentFile(file)
    }

    // ZIP_fclose is Raven's macro for fclose.
    FileBackend.fclose(s.file)
    // TRYFREE of unzip.cpp:246 is `if (p) Z_Free(p)`, and the view is never NULL here.
    Z_Free(s.handle)
    return UNZ_OK
}

/**
```
  Write info about the ZipFile in the *pglobal_info structure.
  No preparation of the structure is needed
  return UNZ_OK if there is no problem.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:528
func unzGetGlobalInfo(_ file: OpaquePointer?, _ pglobal_info: Unz_global_info) -> Int32 {
    // TODO: Port unzGetGlobalInfo
    portMissing("unzGetGlobalInfo", source: "oracle/codemp/qcommon/unzip.cpp:528")
}

/**
```
   Translate date/time from Dos format to tm_unz (readable more easilty)
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:542
private func unzlocal_DosDateToTmuDate(_ ulDosDate: CUnsignedLong, _ ptm: Tm_unz) {
    // TODO: Port unzlocal_DosDateToTmuDate
    portMissing("unzlocal_DosDateToTmuDate", source: "oracle/codemp/qcommon/unzip.cpp:542")
}

/**
```
  Get Info about the current file in the zipfile, with internal only info
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:558
private func unzlocal_GetCurrentFileInfoInternal(_ file: OpaquePointer?, _ pfile_info: Unz_file_info, _ pfile_info_internal: Unz_file_info_internal?, _ szFileName: inout JKAShared.CharBuf, _ fileNameBufferSize: CUnsignedLong, _ extraField: OpaquePointer?, _ extraFieldBufferSize: CUnsignedLong, _ szComment: inout JKAShared.CharBuf, _ commentBufferSize: CUnsignedLong) -> Int32 {
    // TODO: Port unzlocal_GetCurrentFileInfoInternal
    portMissing("unzlocal_GetCurrentFileInfoInternal", source: "oracle/codemp/qcommon/unzip.cpp:558")
}

/**
```
  Write info about the ZipFile in the *pglobal_info structure.
  No preparation of the structure is needed
  return UNZ_OK if there is no problem.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:722
func unzGetCurrentFileInfo(_ file: OpaquePointer?, _ pfile_info: Unz_file_info?, _ szFileName: inout JKAShared.CharBuf, _ fileNameBufferSize: CUnsignedLong, _ extraField: OpaquePointer?, _ extraFieldBufferSize: CUnsignedLong, _ szComment: inout JKAShared.CharBuf, _ commentBufferSize: CUnsignedLong) -> Int32 {
    // TODO: Port unzGetCurrentFileInfo
    portMissing("unzGetCurrentFileInfo", source: "oracle/codemp/qcommon/unzip.cpp:722")
}

/**
```
  Set the current file of the zipfile to the first file.
  return UNZ_OK if there is no problem
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:737
func unzGoToFirstFile(_ file: OpaquePointer?) -> Int32 {
    var err: Int32 = UNZ_OK
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    s.pos_in_central_dir = s.offset_central_dir
    s.num_file = 0
    // Port-note: unzlocal_GetCurrentFileInfoInternal carries a signature marker, row U4 of the unzip round.
    // Raven wrote: err=unzlocal_GetCurrentFileInfoInternal(file,&s->cur_file_info, &s->cur_file_info_internal, NULL,0,NULL,0,NULL,0);
    portMissing("unzGoToFirstFile", source: "oracle/codemp/qcommon/unzip.cpp:737")
    s.current_file_ok = (err == UNZ_OK) ? 1 : 0
    return err
}

/**
```
  Set the current file of the zipfile to the next file.
  return UNZ_OK if there is no problem
  return UNZ_END_OF_LIST_OF_FILE if the actual file was the latest.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:759
func unzGoToNextFile(_ file: OpaquePointer?) -> Int32 {
    var err: Int32
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    if s.current_file_ok == 0 {
        return UNZ_END_OF_LIST_OF_FILE
    }
    if s.num_file + 1 == s.gi.number_entry {
        return UNZ_END_OF_LIST_OF_FILE
    }

    s.pos_in_central_dir += CUnsignedLong(SIZECENTRALDIRITEM) + s.cur_file_info.size_filename + s.cur_file_info.size_file_extra + s.cur_file_info.size_file_comment
    s.num_file += 1
    // Port-note: unzlocal_GetCurrentFileInfoInternal carries a signature marker, row U4 of the unzip round.
    // Raven wrote: err = unzlocal_GetCurrentFileInfoInternal(file,&s->cur_file_info, &s->cur_file_info_internal, NULL,0,NULL,0,NULL,0);
    portMissing("unzGoToNextFile", source: "oracle/codemp/qcommon/unzip.cpp:759")
    s.current_file_ok = (err == UNZ_OK) ? 1 : 0
    return err
}

/**
```
  Get the position of the info of the current file in the zip.
  return UNZ_OK if there is no problem
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:786
func unzGetCurrentFileInfoPosition(_ file: OpaquePointer?, _ pos: inout CUnsignedLong) -> Int32 {
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)

    pos = s.pos_in_central_dir
    return UNZ_OK
}

/**
```
  Set the position of the info of the current file in the zip.
  return UNZ_OK if there is no problem
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:802
@discardableResult
func unzSetCurrentFileInfoPosition(_ file: OpaquePointer?, _ pos: CUnsignedLong) -> Int32 {
    var err: Int32
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)

    s.pos_in_central_dir = pos
    // Port-note: unzlocal_GetCurrentFileInfoInternal carries a signature marker, row U4 of the unzip round.
    // Raven wrote: err = unzlocal_GetCurrentFileInfoInternal(file,&s->cur_file_info, &s->cur_file_info_internal, NULL,0,NULL,0,NULL,0);
    portMissing("unzSetCurrentFileInfoPosition", source: "oracle/codemp/qcommon/unzip.cpp:802")
    s.current_file_ok = (err == UNZ_OK) ? 1 : 0
    return UNZ_OK
}

/**
```
  Try locate the file szFileName in the zipfile.
  For the iCaseSensitivity signification, see unzipStringFileNameCompare

  return value :
  UNZ_OK if the file is found. It becomes the current file.
  UNZ_END_OF_LIST_OF_FILE if the file is not found
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:827
func unzLocateFile(_ file: OpaquePointer?, _ szFileName: String, _ iCaseSensitivity: Int32) -> Int32 {
    var err: Int32
    let num_fileSaved: CUnsignedLong
    let pos_in_central_dirSaved: CUnsignedLong

    if file == nil {
        return UNZ_PARAMERROR
    }

    if strlen(szFileName) >= UNZ_MAXFILENAMEINZIP {
        return UNZ_PARAMERROR
    }

    let s = UnzS(file!)
    if s.current_file_ok == 0 {
        return UNZ_END_OF_LIST_OF_FILE
    }

    num_fileSaved = s.num_file
    pos_in_central_dirSaved = s.pos_in_central_dir

    err = unzGoToFirstFile(file)

    while err == UNZ_OK {
        let szCurrentFileName = CharBuf(UNZ_MAXFILENAMEINZIP + 1)
        // Port-note: unzGetCurrentFileInfo carries a signature marker, row U4 of the unzip round.
        // Raven wrote: unzGetCurrentFileInfo(file,NULL, szCurrentFileName,sizeof(szCurrentFileName)-1, NULL,0,NULL,0);
        portMissing("unzLocateFile", source: "oracle/codemp/qcommon/unzip.cpp:827")
        if unzStringFileNameCompare(String(szCurrentFileName), szFileName, iCaseSensitivity) == 0 {
            return UNZ_OK
        }
        err = unzGoToNextFile(file)
    }

    s.num_file = num_fileSaved
    s.pos_in_central_dir = pos_in_central_dirSaved
    return err
}

/**
```
  Read the static header of the current zipfile
  Check the coherency of the static header and info in the end of central
        directory about this file
  store in *piSizeVar the size of extra info in static header
        (filename and size of extra field data)
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:877
private func unzlocal_CheckCurrentFileCoherencyHeader(_ s: UnzS, _ piSizeVar: inout UInt32, _ poffset_local_extrafield: inout CUnsignedLong, _ psize_local_extrafield: inout UInt32) -> Int32 {
    // TODO: Port unzlocal_CheckCurrentFileCoherencyHeader
    portMissing("unzlocal_CheckCurrentFileCoherencyHeader", source: "oracle/codemp/qcommon/unzip.cpp:877")
}

/**
```
  Open for reading data the current file in the zipfile.
  If there is no error and the file is opened, the return value is UNZ_OK.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:963
@discardableResult
func unzOpenCurrentFile(_ file: OpaquePointer?) -> Int32 {
    var err: Int32 = UNZ_OK
    let Store: Bool
    var iSizeVar: UInt32 = 0
    var offset_local_extrafield: CUnsignedLong = 0 /* offset of the static extra field */
    var size_local_extrafield: UInt32 = 0 /* size of the static extra field */

    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    if s.current_file_ok == 0 {
        return UNZ_PARAMERROR
    }

    if s.pfile_in_zip_read != nil {
        unzCloseCurrentFile(file)
    }

    // Port-note: unzlocal_CheckCurrentFileCoherencyHeader carries a signature marker, row U3 of the unzip round.
    // Raven wrote: if (unzlocal_CheckCurrentFileCoherencyHeader(s,&iSizeVar, &offset_local_extrafield,&size_local_extrafield)!=UNZ_OK) return UNZ_BADZIPFILE;
    portMissing("unzOpenCurrentFile", source: "oracle/codemp/qcommon/unzip.cpp:963")

    // ALLOC of unzip.cpp:243 is `Z_Malloc(size, TAG_FILESYS, qfalse)`.
    let pfile_in_zip_read_info = File_in_zip_read_info_s(Z_Malloc(Int32(File_in_zip_read_info_s.byteCount), TAG_FILESYS, false))
    // AI: Raven stores the `char *` of the zone block. The field holds it as the handle that fread and Z_Free take.
    pfile_in_zip_read_info.read_buffer = OpaquePointer(Z_Malloc(UNZ_BUFSIZE, TAG_FILESYS, false))
    pfile_in_zip_read_info.offset_local_extrafield = offset_local_extrafield
    pfile_in_zip_read_info.size_local_extrafield = size_local_extrafield
    pfile_in_zip_read_info.pos_local_extrafield = 0

    pfile_in_zip_read_info.stream_initialised = 0

    if (s.cur_file_info.compression_method != 0) && (s.cur_file_info.compression_method != CUnsignedLong(ZF_DEFLATED)) {
        err = UNZ_BADZIPFILE
    }
    Store = s.cur_file_info.compression_method == 0

    pfile_in_zip_read_info.crc32_wait = s.cur_file_info.crc
    pfile_in_zip_read_info.crc32 = 0
    pfile_in_zip_read_info.compression_method = s.cur_file_info.compression_method
    pfile_in_zip_read_info.file = s.file
    pfile_in_zip_read_info.byte_before_the_zipfile = s.byte_before_the_zipfile

    pfile_in_zip_read_info.stream.total_out = 0

    if !Store {
        err = ZipBackend.inflateInit(pfile_in_zip_read_info.stream, Z_SYNC_FLUSH, 1)
        if err == Z_OK {
            pfile_in_zip_read_info.stream_initialised = 1
        }
        /* windowBits is passed < 0 to tell that there is no zlib header.
         * Note that in this case inflate *requires* an extra "dummy" byte
         * after the compressed stream in order to complete decompression and
         * return Z_STREAM_END.
         * In unzip, i don't wait absolutely Z_STREAM_END because I known the
         * size of both compressed and uncompressed data
         */
    }
    pfile_in_zip_read_info.rest_read_compressed = s.cur_file_info.compressed_size
    pfile_in_zip_read_info.rest_read_uncompressed = s.cur_file_info.uncompressed_size

    pfile_in_zip_read_info.pos_in_zipfile = s.cur_file_info_internal.offset_curfile + CUnsignedLong(SIZEZIPLOCALHEADER) + CUnsignedLong(iSizeVar)

    pfile_in_zip_read_info.stream.avail_in = 0

    s.pfile_in_zip_read = pfile_in_zip_read_info
    return UNZ_OK
}

/**
```
  Read bytes from the current file.
  buf contain buffer where data must be copied
  len the size of buf.

  return the number of byte copied if somes bytes are copied
  return 0 if the end of file was reached
  return <0 with error code if there is an error
    (UNZ_ERRNO for IO error, or zLib error for uncompress error)
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1050
func unzReadCurrentFile(_ file: OpaquePointer?, _ buf: Slots<JKAShared.byte>, _ len: UInt32) -> Int32 {
    var err: Int32 = UNZ_OK
    var iRead: UInt32 = 0

    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    guard let pfile_in_zip_read_info = s.pfile_in_zip_read else {
        return UNZ_PARAMERROR
    }

    if pfile_in_zip_read_info.read_buffer == nil {
        return UNZ_END_OF_LIST_OF_FILE
    }
    if len == 0 {
        return 0
    }

    pfile_in_zip_read_info.stream.next_out = buf

    pfile_in_zip_read_info.stream.avail_out = CUnsignedLong(len)

    if CUnsignedLong(len) > pfile_in_zip_read_info.rest_read_uncompressed {
        pfile_in_zip_read_info.stream.avail_out = CUnsignedLong(UInt32(truncatingIfNeeded: pfile_in_zip_read_info.rest_read_uncompressed))
    }

    while pfile_in_zip_read_info.stream.avail_out > 0 {
        if (pfile_in_zip_read_info.stream.avail_in == 0) && (pfile_in_zip_read_info.rest_read_compressed > 0) {
            var uReadThis = UInt32(UNZ_BUFSIZE)
            if pfile_in_zip_read_info.rest_read_compressed < CUnsignedLong(uReadThis) {
                uReadThis = UInt32(truncatingIfNeeded: pfile_in_zip_read_info.rest_read_compressed)
            }
            if uReadThis == 0 {
                return UNZ_EOF
            }
            if s.cur_file_info.compressed_size == pfile_in_zip_read_info.rest_read_compressed {
                // ZIP_fseek is Raven's macro for fseek.
                if FileBackend.fseek(pfile_in_zip_read_info.file, CLong(bitPattern: pfile_in_zip_read_info.pos_in_zipfile + pfile_in_zip_read_info.byte_before_the_zipfile), SEEK_SET) != 0 {
                    return UNZ_ERRNO
                }
            }
            // ZIP_fread is Raven's macro for fread.
            if FileBackend.fread(pfile_in_zip_read_info.read_buffer, at: 0, Int32(bitPattern: uReadThis), 1, pfile_in_zip_read_info.file) != 1 {
                return UNZ_ERRNO
            }
            pfile_in_zip_read_info.pos_in_zipfile += CUnsignedLong(uReadThis)

            pfile_in_zip_read_info.rest_read_compressed -= CUnsignedLong(uReadThis)

            pfile_in_zip_read_info.stream.next_in = ZipBackend.bytes(pfile_in_zip_read_info.read_buffer, count: UNZ_BUFSIZE)
            pfile_in_zip_read_info.stream.avail_in = CUnsignedLong(uReadThis)
        }

        if pfile_in_zip_read_info.compression_method == 0 {
            var uDoCopy: UInt32
            var i: UInt32
            if pfile_in_zip_read_info.stream.avail_out < pfile_in_zip_read_info.stream.avail_in {
                uDoCopy = UInt32(truncatingIfNeeded: pfile_in_zip_read_info.stream.avail_out)
            } else {
                uDoCopy = UInt32(truncatingIfNeeded: pfile_in_zip_read_info.stream.avail_in)
            }

            let next_out = pfile_in_zip_read_info.stream.next_out!
            let next_in = pfile_in_zip_read_info.stream.next_in!
            i = 0
            while i < uDoCopy {
                next_out[i] = next_in[i]
                i += 1
            }

            //			pfile_in_zip_read_info->crc32 = crc32(pfile_in_zip_read_info->crc32,
            //								pfile_in_zip_read_info->stream.next_out,
            //								uDoCopy);
            pfile_in_zip_read_info.rest_read_uncompressed -= CUnsignedLong(uDoCopy)
            pfile_in_zip_read_info.stream.avail_in -= CUnsignedLong(uDoCopy)
            pfile_in_zip_read_info.stream.avail_out -= CUnsignedLong(uDoCopy)
            pfile_in_zip_read_info.stream.next_out = next_out.suffix(from: uDoCopy)
            pfile_in_zip_read_info.stream.next_in = next_in.suffix(from: uDoCopy)
            pfile_in_zip_read_info.stream.total_out += CUnsignedLong(uDoCopy)
            iRead += uDoCopy
        } else {
            let uTotalOutBefore: CUnsignedLong
            let uTotalOutAfter: CUnsignedLong
            let uOutThis: CUnsignedLong

            uTotalOutBefore = pfile_in_zip_read_info.stream.total_out
            // AI: Raven keeps `bufBefore = stream.next_out` for the crc32 call he commented out. The local has no read, so it drops.

            /*
            if ((pfile_in_zip_read_info->rest_read_uncompressed ==
                     pfile_in_zip_read_info->stream.avail_out) &&
                (pfile_in_zip_read_info->rest_read_compressed == 0))
                flush = Z_FINISH;
            */
            err = ZipBackend.inflate(pfile_in_zip_read_info.stream)

            uTotalOutAfter = pfile_in_zip_read_info.stream.total_out
            uOutThis = uTotalOutAfter - uTotalOutBefore

            //			pfile_in_zip_read_info->crc32 =
            //                crc32(pfile_in_zip_read_info->crc32,bufBefore,
            //                        (uInt)(uOutThis));

            pfile_in_zip_read_info.rest_read_uncompressed -= uOutThis

            iRead += UInt32(truncatingIfNeeded: uTotalOutAfter - uTotalOutBefore)

            if err == Z_STREAM_END {
                return (iRead == 0) ? UNZ_EOF : Int32(bitPattern: iRead)
            }
            if err != Z_OK {
                break
            }
        }
    }

    if err == Z_OK {
        return Int32(bitPattern: iRead)
    }
    return err
}

/**
```
  Give the current position in uncompressed data
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1174
func unztell(_ file: OpaquePointer?) -> CLong {
    if file == nil {
        return CLong(UNZ_PARAMERROR)
    }
    let s = UnzS(file!)
    guard let pfile_in_zip_read_info = s.pfile_in_zip_read else {
        return CLong(UNZ_PARAMERROR)
    }

    return CLong(bitPattern: pfile_in_zip_read_info.stream.total_out)
}

/**
```
  return 1 if the end of file was reached, 0 elsewhere
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1193
func unzeof(_ file: OpaquePointer?) -> Int32 {
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    guard let pfile_in_zip_read_info = s.pfile_in_zip_read else {
        return UNZ_PARAMERROR
    }

    if pfile_in_zip_read_info.rest_read_uncompressed == 0 {
        return 1
    } else {
        return 0
    }
}

/**
```
  Read extra field from the current file (opened by unzOpenCurrentFile)
  This is the static-header version of the extra field (sometimes, there is
    more info in the static-header version than in the central-header)

  if buf==NULL, it return the size of the static extra field that can be read

  if buf!=NULL, len is the size of the buffer, the extra header is copied in
	buf.
  the return value is the number of bytes copied in buf, or (if <0)
	the error code
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1225
func unzGetLocalExtrafield(_ file: OpaquePointer?, _ buf: OpaquePointer?, _ len: UInt32) -> Int32 {
    let read_now: UInt32
    let size_to_read: CUnsignedLong

    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    guard let pfile_in_zip_read_info = s.pfile_in_zip_read else {
        return UNZ_PARAMERROR
    }

    size_to_read = CUnsignedLong(pfile_in_zip_read_info.size_local_extrafield) - pfile_in_zip_read_info.pos_local_extrafield

    if buf == nil {
        return Int32(truncatingIfNeeded: size_to_read)
    }

    if CUnsignedLong(len) > size_to_read {
        read_now = UInt32(truncatingIfNeeded: size_to_read)
    } else {
        read_now = len
    }

    if read_now == 0 {
        return 0
    }

    if FileBackend.fseek(pfile_in_zip_read_info.file, CLong(bitPattern: pfile_in_zip_read_info.offset_local_extrafield + pfile_in_zip_read_info.pos_local_extrafield), SEEK_SET) != 0 {
        return UNZ_ERRNO
    }

    if FileBackend.fread(buf, at: 0, Int32(truncatingIfNeeded: size_to_read), 1, pfile_in_zip_read_info.file) != 1 {
        return UNZ_ERRNO
    }

    return Int32(bitPattern: read_now)
}

/**
```
  Close the file in zip opened with unzipOpenCurrentFile
  Return UNZ_CRCERROR if all the file was read but the CRC is not good
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1269
@discardableResult
func unzCloseCurrentFile(_ file: OpaquePointer?) -> Int32 {
    let err: Int32 = UNZ_OK

    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    guard let pfile_in_zip_read_info = s.pfile_in_zip_read else {
        return UNZ_PARAMERROR
    }

    /*
    if (pfile_in_zip_read_info->rest_read_uncompressed == 0)
    {
        if (pfile_in_zip_read_info->crc32 != pfile_in_zip_read_info->crc32_wait)
            err=UNZ_CRCERROR;
    }
    */

    // TRYFREE of unzip.cpp:246 is `if (p) Z_Free(p)`.
    if pfile_in_zip_read_info.read_buffer != nil {
        Z_Free(pfile_in_zip_read_info.read_buffer)
    }
    pfile_in_zip_read_info.read_buffer = nil
    if pfile_in_zip_read_info.stream_initialised != 0 {
        ZipBackend.inflateEnd(pfile_in_zip_read_info.stream)
    }

    pfile_in_zip_read_info.stream_initialised = 0
    Z_Free(pfile_in_zip_read_info.handle)

    s.pfile_in_zip_read = nil

    return err
}

/**
```
  Get the global comment string of the ZipFile, in the szComment buffer.
  uSizeBuf is the size of the szComment buffer.
  return the number of byte copied or an error code <0
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1310
func unzGetGlobalComment(_ file: OpaquePointer?, _ szComment: inout JKAShared.CharBuf, _ uSizeBuf: CUnsignedLong) -> Int32 {
    var uReadThis: CUnsignedLong
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)

    uReadThis = uSizeBuf
    if uReadThis > s.gi.size_comment {
        uReadThis = s.gi.size_comment
    }

    if FileBackend.fseek(s.file, CLong(bitPattern: s.central_pos + 22), SEEK_SET) != 0 {
        return UNZ_ERRNO
    }

    if uReadThis > 0 {
        szComment[0] = 0
        if FileBackend.fread(&szComment, at: 0, Int32(truncatingIfNeeded: uReadThis), 1, s.file) != 1 {
            return UNZ_ERRNO
        }
    }

    if uSizeBuf > s.gi.size_comment {
        szComment[s.gi.size_comment] = 0
    }
    return Int32(truncatingIfNeeded: uReadThis)
}
