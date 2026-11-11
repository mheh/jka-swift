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
private func unzlocal_getShort(_ fin: OpaquePointer?, _ pX: inout CUnsignedLong) -> Int32 {
    // AI: Raven reads into a `short` local through its address. The local is a CharBuf of the two bytes, and the read gives the `short` of them.
    var v = CharBuf(Int16.byteCount)

    // ZIP_fread is Raven's macro for fread.
    FileBackend.fread(&v, at: 0, Int32(Int16.byteCount), 1, fin)

    // The `short` sign-extends into the `uLong`, as C's store does.
    pX = CUnsignedLong(truncatingIfNeeded: Int16(truncatingIfNeeded: v.withSlots { $0[ushort: 0] }))
    return UNZ_OK
}

/// Source: oracle/codemp/qcommon/unzip.cpp:265
private func unzlocal_getLong(_ fin: OpaquePointer?, _ pX: inout CUnsignedLong) -> Int32 {
    // AI: Raven reads into an `int` local through its address. The local is a CharBuf of the four bytes, and the read gives the `int` of them.
    var v = CharBuf(Int32.byteCount)

    // ZIP_fread is Raven's macro for fread.
    FileBackend.fread(&v, at: 0, Int32(Int32.byteCount), 1, fin)

    // The `int` sign-extends into the `uLong`, as C's store does.
    pX = CUnsignedLong(truncatingIfNeeded: v.withSlots { $0[int: 0] })
    return UNZ_OK
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
public func unzStringFileNameCompare(_ fileName1: String, _ fileName2: String, _ iCaseSensitivity: Int32) -> Int32 {
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
private func unzlocal_SearchCentralDir(_ fin: OpaquePointer?) -> CUnsignedLong {
    let uSizeFile: CUnsignedLong
    var uBackRead: CUnsignedLong
    var uMaxBack: CUnsignedLong = 0xffff /* maximum size of global comment */
    var uPosFound: CUnsignedLong = 0

    // ZIP_fseek is Raven's macro for fseek.
    if FileBackend.fseek(fin, 0, SEEK_END) != 0 {
        return 0
    }

    // ZIP_ftell is Raven's macro for ftell.
    uSizeFile = CUnsignedLong(truncatingIfNeeded: FileBackend.ftell(fin))

    if uMaxBack > uSizeFile {
        uMaxBack = uSizeFile
    }

    // ALLOC of unzip.cpp:243 is `Z_Malloc(size, TAG_FILESYS, qfalse)`.
    let buf = Z_Malloc(BUFREADCOMMENT + 4, TAG_FILESYS, false)

    uBackRead = 4
    while uBackRead < uMaxBack {
        let uReadSize: CUnsignedLong
        let uReadPos: CUnsignedLong
        var i: Int32
        if uBackRead &+ CUnsignedLong(BUFREADCOMMENT) > uMaxBack {
            uBackRead = uMaxBack
        } else {
            uBackRead &+= CUnsignedLong(BUFREADCOMMENT)
        }
        uReadPos = uSizeFile &- uBackRead

        uReadSize = (CUnsignedLong(BUFREADCOMMENT + 4) < (uSizeFile &- uReadPos)) ? CUnsignedLong(BUFREADCOMMENT + 4) : (uSizeFile &- uReadPos)
        if FileBackend.fseek(fin, CLong(bitPattern: uReadPos), SEEK_SET) != 0 {
            break
        }

        // AI: Raven hands the `unsigned char *` of the zone block to ZIP_fread. The call hands the Slots over the bytes of the block.
        if FileBackend.fread(Slots(scalars: buf, count: Int(BUFREADCOMMENT + 4)), at: 0, Int32(UInt32(truncatingIfNeeded: uReadSize)), 1, fin) != 1 {
            break
        }

        i = Int32(uReadSize) - 3
        while true {
            // Raven's test `(i--)>0` reads `i` before the step.
            let iBefore = i
            i -= 1
            if !(iBefore > 0) { break }
            if ((buf[byte: i] as UInt8) == 0x50) && ((buf[byte: i + 1] as UInt8) == 0x4b) && ((buf[byte: i + 2] as UInt8) == 0x05) && ((buf[byte: i + 3] as UInt8) == 0x06) {
                uPosFound = uReadPos &+ CUnsignedLong(i)
                break
            }
        }

        if uPosFound != 0 {
            break
        }
    }
    // TRYFREE of unzip.cpp:246 is `if (p) Z_Free(p)`, and the block is never NULL here.
    Z_Free(OpaquePointer(buf))
    return uPosFound
}

/// Source: oracle/codemp/qcommon/unzip.cpp:388
public func unzReOpen(_ path: String, _ file: OpaquePointer?) -> OpaquePointer? {
    let fin: OpaquePointer?

    // ZIP_fopen is Raven's macro for fopen.
    fin = FileBackend.fopen(path, "rb")
    if fin == nil {
        return nil
    }

    // ALLOC of unzip.cpp:243 is `Z_Malloc(size, TAG_FILESYS, qfalse)`.
    let s = UnzS(Z_Malloc(Int32(UnzS.byteCount), TAG_FILESYS, false))
    Com_Memcpy(s, UnzS(file!), UnzS.byteCount)

    s.file = fin
    return s.handle
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
public func unzOpen(_ path: String) -> OpaquePointer? {
    return UnzS.scratch { us -> OpaquePointer? in
        let central_pos: CUnsignedLong
        var uL: CUnsignedLong = 0
        let fin: OpaquePointer?

        var number_disk: CUnsignedLong = 0 /* number of the current dist, used for
                                   spaning ZIP, unsupported, always 0*/
        var number_disk_with_CD: CUnsignedLong = 0 /* number the the disk with central dir, used
                                   for spaning ZIP, unsupported, always 0*/
        var number_entry_CD: CUnsignedLong = 0 /* total number of entries in
                                   the central dir
                                   (same than number_entry on nospan) */

        var err: Int32 = UNZ_OK

        // ZIP_fopen is Raven's macro for fopen.
        fin = FileBackend.fopen(path, "rb")
        if fin == nil {
            return nil
        }

        central_pos = unzlocal_SearchCentralDir(fin)
        if central_pos == 0 {
            err = UNZ_ERRNO
        }

        // ZIP_fseek is Raven's macro for fseek.
        if FileBackend.fseek(fin, CLong(bitPattern: central_pos), SEEK_SET) != 0 {
            err = UNZ_ERRNO
        }

        /* the signature, already checked */
        if unzlocal_getLong(fin, &uL) != UNZ_OK {
            err = UNZ_ERRNO
        }

        /* number of this disk */
        if unzlocal_getShort(fin, &number_disk) != UNZ_OK {
            err = UNZ_ERRNO
        }

        /* number of the disk with the start of the central directory */
        if unzlocal_getShort(fin, &number_disk_with_CD) != UNZ_OK {
            err = UNZ_ERRNO
        }

        /* total number of entries in the central dir on this disk */
        if unzlocal_getShort(fin, &us.gi.number_entry) != UNZ_OK {
            err = UNZ_ERRNO
        }

        /* total number of entries in the central dir */
        if unzlocal_getShort(fin, &number_entry_CD) != UNZ_OK {
            err = UNZ_ERRNO
        }

        if (number_entry_CD != us.gi.number_entry) || (number_disk_with_CD != 0) || (number_disk != 0) {
            err = UNZ_BADZIPFILE
        }

        /* size of the central directory */
        if unzlocal_getLong(fin, &us.size_central_dir) != UNZ_OK {
            err = UNZ_ERRNO
        }

        /* offset of start of central directory with respect to the
              starting disk number */
        if unzlocal_getLong(fin, &us.offset_central_dir) != UNZ_OK {
            err = UNZ_ERRNO
        }

        /* zipfile comment length */
        if unzlocal_getShort(fin, &us.gi.size_comment) != UNZ_OK {
            err = UNZ_ERRNO
        }

        if (central_pos < us.offset_central_dir &+ us.size_central_dir) && (err == UNZ_OK) {
            err = UNZ_BADZIPFILE
        }

        if err != UNZ_OK {
            // ZIP_fclose is Raven's macro for fclose.
            FileBackend.fclose(fin)
            return nil
        }

        us.file = fin
        // The `uLong` difference wraps as C's does when the offsets are past the central directory.
        us.byte_before_the_zipfile = central_pos &- (us.offset_central_dir &+ us.size_central_dir)
        us.central_pos = central_pos
        us.pfile_in_zip_read = nil

        // ALLOC of unzip.cpp:243 is `Z_Malloc(size, TAG_FILESYS, qfalse)`.
        let s = UnzS(Z_Malloc(Int32(UnzS.byteCount), TAG_FILESYS, false))
        s.copy(from: us)
        //	unzGoToFirstFile((unzFile)s);
        return s.handle
    }
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
public func unzClose(_ file: OpaquePointer?) -> Int32 {
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
public func unzGetGlobalInfo(_ file: OpaquePointer?, _ pglobal_info: Unz_global_info) -> Int32 {
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    pglobal_info.copy(from: s.gi)
    return UNZ_OK
}

/**
```
   Translate date/time from Dos format to tm_unz (readable more easilty)
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:542
private func unzlocal_DosDateToTmuDate(_ ulDosDate: CUnsignedLong, _ ptm: Tm_unz) {
    let uDate: CUnsignedLong
    uDate = CUnsignedLong(ulDosDate >> 16)
    ptm.tm_mday = UInt32(truncatingIfNeeded: uDate & 0x1f)
    // The `uLong` difference wraps as C's does for a month of 0.
    ptm.tm_mon = UInt32(truncatingIfNeeded: (((uDate) & 0x1E0) / 0x20) &- 1)
    ptm.tm_year = UInt32(truncatingIfNeeded: ((uDate & 0x0FE00) / 0x0200) &+ 1980)

    ptm.tm_hour = UInt32(truncatingIfNeeded: (ulDosDate & 0xF800) / 0x800)
    ptm.tm_min = UInt32(truncatingIfNeeded: (ulDosDate & 0x7E0) / 0x20)
    ptm.tm_sec = UInt32(truncatingIfNeeded: 2 &* (ulDosDate & 0x1f))
}

/**
```
  Get Info about the current file in the zipfile, with internal only info
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:558
private func unzlocal_GetCurrentFileInfoInternal(_ file: OpaquePointer?, _ pfile_info: Unz_file_info?, _ pfile_info_internal: Unz_file_info_internal?, _ szFileName: inout JKAShared.CharBuf, _ fileNameBufferSize: CUnsignedLong, _ extraField: OpaquePointer?, _ extraFieldBufferSize: CUnsignedLong, _ szComment: inout JKAShared.CharBuf, _ commentBufferSize: CUnsignedLong) -> Int32 {
    return Unz_file_info.scratch { file_info -> Int32 in
        Unz_file_info_internal.scratch { file_info_internal -> Int32 in
            var err: Int32 = UNZ_OK
            var uMagic: CUnsignedLong = 0
            var lSeek: CLong = 0

            if file == nil {
                return UNZ_PARAMERROR
            }
            let s = UnzS(file!)
            // ZIP_fseek is Raven's macro for fseek.
            if FileBackend.fseek(s.file, CLong(bitPattern: s.pos_in_central_dir &+ s.byte_before_the_zipfile), SEEK_SET) != 0 {
                err = UNZ_ERRNO
            }

            /* we check the magic */
            if err == UNZ_OK {
                if unzlocal_getLong(s.file, &uMagic) != UNZ_OK {
                    err = UNZ_ERRNO
                } else if uMagic != 0x02014b50 {
                    err = UNZ_BADZIPFILE
                }
            }
            if unzlocal_getShort(s.file, &file_info.version) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.version_needed) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.flag) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.compression_method) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getLong(s.file, &file_info.dosDate) != UNZ_OK {
                err = UNZ_ERRNO
            }

            unzlocal_DosDateToTmuDate(file_info.dosDate, file_info.tmu_date)

            if unzlocal_getLong(s.file, &file_info.crc) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getLong(s.file, &file_info.compressed_size) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getLong(s.file, &file_info.uncompressed_size) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.size_filename) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.size_file_extra) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.size_file_comment) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.disk_num_start) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getShort(s.file, &file_info.internal_fa) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getLong(s.file, &file_info.external_fa) != UNZ_OK {
                err = UNZ_ERRNO
            }

            if unzlocal_getLong(s.file, &file_info_internal.offset_curfile) != UNZ_OK {
                err = UNZ_ERRNO
            }

            lSeek &+= CLong(bitPattern: file_info.size_filename)
            // Raven's `szFileName!=NULL` half has no path here, because an `inout` buffer is never NULL.
            if err == UNZ_OK {
                let uSizeRead: CUnsignedLong
                if file_info.size_filename < fileNameBufferSize {
                    szFileName[file_info.size_filename] = 0
                    uSizeRead = file_info.size_filename
                } else {
                    uSizeRead = fileNameBufferSize
                }

                if (file_info.size_filename > 0) && (fileNameBufferSize > 0) {
                    // ZIP_fread is Raven's macro for fread.
                    if FileBackend.fread(&szFileName, at: 0, Int32(UInt32(truncatingIfNeeded: uSizeRead)), 1, s.file) != 1 {
                        err = UNZ_ERRNO
                    }
                }
                lSeek &-= CLong(bitPattern: uSizeRead)
            }

            if (err == UNZ_OK) && (extraField != nil) {
                let uSizeRead: CUnsignedLong
                if file_info.size_file_extra < extraFieldBufferSize {
                    uSizeRead = file_info.size_file_extra
                } else {
                    uSizeRead = extraFieldBufferSize
                }

                if lSeek != 0 {
                    if FileBackend.fseek(s.file, lSeek, SEEK_CUR) == 0 {
                        lSeek = 0
                    } else {
                        err = UNZ_ERRNO
                    }
                }
                if (file_info.size_file_extra > 0) && (extraFieldBufferSize > 0) {
                    // AI: Raven hands the `void *` to ZIP_fread. FileBackend.fread takes a Slots of bytes, so ZipBackend.bytes gives one over the same buffer.
                    if FileBackend.fread(ZipBackend.bytes(extraField, count: uSizeRead)!, at: 0, Int32(UInt32(truncatingIfNeeded: uSizeRead)), 1, s.file) != 1 {
                        err = UNZ_ERRNO
                    }
                }
                lSeek &+= CLong(bitPattern: file_info.size_file_extra &- uSizeRead)
            } else {
                lSeek &+= CLong(bitPattern: file_info.size_file_extra)
            }

            // AI: Raven tested the comment buffer for NULL.
            // A caller with no comment passes a scratch CharBuf with a size of 0, so the test reads the size.
            if (err == UNZ_OK) && (commentBufferSize > 0) {
                let uSizeRead: CUnsignedLong
                if file_info.size_file_comment < commentBufferSize {
                    szComment[file_info.size_file_comment] = 0
                    uSizeRead = file_info.size_file_comment
                } else {
                    uSizeRead = commentBufferSize
                }

                if lSeek != 0 {
                    if FileBackend.fseek(s.file, lSeek, SEEK_CUR) == 0 {
                        lSeek = 0
                    } else {
                        err = UNZ_ERRNO
                    }
                }
                if (file_info.size_file_comment > 0) && (commentBufferSize > 0) {
                    if FileBackend.fread(&szComment, at: 0, Int32(UInt32(truncatingIfNeeded: uSizeRead)), 1, s.file) != 1 {
                        err = UNZ_ERRNO
                    }
                }
                lSeek &+= CLong(bitPattern: file_info.size_file_comment &- uSizeRead)
            } else {
                lSeek &+= CLong(bitPattern: file_info.size_file_comment)
            }

            if (err == UNZ_OK) && (pfile_info != nil) {
                pfile_info!.copy(from: file_info)
            }

            if (err == UNZ_OK) && (pfile_info_internal != nil) {
                pfile_info_internal!.copy(from: file_info_internal)
            }

            return err
        }
    }
}

/**
```
  Write info about the ZipFile in the *pglobal_info structure.
  No preparation of the structure is needed
  return UNZ_OK if there is no problem.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:722
@discardableResult
public func unzGetCurrentFileInfo(_ file: OpaquePointer?, _ pfile_info: Unz_file_info?, _ szFileName: inout JKAShared.CharBuf, _ fileNameBufferSize: CUnsignedLong, _ extraField: OpaquePointer?, _ extraFieldBufferSize: CUnsignedLong, _ szComment: inout JKAShared.CharBuf, _ commentBufferSize: CUnsignedLong) -> Int32 {
    return unzlocal_GetCurrentFileInfoInternal(file, pfile_info, nil, &szFileName, fileNameBufferSize, extraField, extraFieldBufferSize, &szComment, commentBufferSize)
}

/**
```
  Set the current file of the zipfile to the first file.
  return UNZ_OK if there is no problem
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:737
@discardableResult
public func unzGoToFirstFile(_ file: OpaquePointer?) -> Int32 {
    var err: Int32 = UNZ_OK
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    s.pos_in_central_dir = s.offset_central_dir
    s.num_file = 0
    // AI: Raven passes NULL for the name and the comment. The call passes a scratch CharBuf with a size of 0, so it reads and writes no byte.
    var szFileName = CharBuf(1)
    var szComment = CharBuf(1)
    err = unzlocal_GetCurrentFileInfoInternal(file, s.cur_file_info, s.cur_file_info_internal, &szFileName, 0, nil, 0, &szComment, 0)
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
@discardableResult
public func unzGoToNextFile(_ file: OpaquePointer?) -> Int32 {
    var err: Int32
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    if s.current_file_ok == 0 {
        return UNZ_END_OF_LIST_OF_FILE
    }
    if s.num_file &+ 1 == s.gi.number_entry {
        return UNZ_END_OF_LIST_OF_FILE
    }

    s.pos_in_central_dir &+= CUnsignedLong(SIZECENTRALDIRITEM) &+ s.cur_file_info.size_filename &+ s.cur_file_info.size_file_extra &+ s.cur_file_info.size_file_comment
    s.num_file &+= 1
    // AI: Raven passes NULL for the name and the comment. The call passes a scratch CharBuf with a size of 0, so it reads and writes no byte.
    var szFileName = CharBuf(1)
    var szComment = CharBuf(1)
    err = unzlocal_GetCurrentFileInfoInternal(file, s.cur_file_info, s.cur_file_info_internal, &szFileName, 0, nil, 0, &szComment, 0)
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
@discardableResult
public func unzGetCurrentFileInfoPosition(_ file: OpaquePointer?, _ pos: inout CUnsignedLong) -> Int32 {
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
public func unzSetCurrentFileInfoPosition(_ file: OpaquePointer?, _ pos: CUnsignedLong) -> Int32 {
    var err: Int32
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)

    s.pos_in_central_dir = pos
    // AI: Raven passes NULL for the name and the comment. The call passes a scratch CharBuf with a size of 0, so it reads and writes no byte.
    var szFileName = CharBuf(1)
    var szComment = CharBuf(1)
    err = unzlocal_GetCurrentFileInfoInternal(file, s.cur_file_info, s.cur_file_info_internal, &szFileName, 0, nil, 0, &szComment, 0)
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
public func unzLocateFile(_ file: OpaquePointer?, _ szFileName: String, _ iCaseSensitivity: Int32) -> Int32 {
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
        var szCurrentFileName = CharBuf(UNZ_MAXFILENAMEINZIP + 1)
        // AI: Raven passes NULL for the comment. The call passes a scratch CharBuf with a size of 0, so it reads and writes no byte.
        var szComment = CharBuf(1)
        unzGetCurrentFileInfo(file, nil, &szCurrentFileName, CUnsignedLong(szCurrentFileName.count - 1), nil, 0, &szComment, 0)
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
    var uMagic: CUnsignedLong = 0
    var uData: CUnsignedLong = 0
    var uFlags: CUnsignedLong = 0
    var size_filename: CUnsignedLong = 0
    var size_extra_field: CUnsignedLong = 0
    var err: Int32 = UNZ_OK

    piSizeVar = 0
    poffset_local_extrafield = 0
    psize_local_extrafield = 0

    // ZIP_fseek is Raven's macro for fseek.
    if FileBackend.fseek(s.file, CLong(bitPattern: s.cur_file_info_internal.offset_curfile &+ s.byte_before_the_zipfile), SEEK_SET) != 0 {
        return UNZ_ERRNO
    }

    if err == UNZ_OK {
        if unzlocal_getLong(s.file, &uMagic) != UNZ_OK {
            err = UNZ_ERRNO
        } else if uMagic != 0x04034b50 {
            err = UNZ_BADZIPFILE
        }
    }
    if unzlocal_getShort(s.file, &uData) != UNZ_OK {
        err = UNZ_ERRNO
    }
    /*
        else if ((err==UNZ_OK) && (uData!=s->cur_file_info.wVersion))
            err=UNZ_BADZIPFILE;
    */
    if unzlocal_getShort(s.file, &uFlags) != UNZ_OK {
        err = UNZ_ERRNO
    }

    if unzlocal_getShort(s.file, &uData) != UNZ_OK {
        err = UNZ_ERRNO
    } else if (err == UNZ_OK) && (uData != s.cur_file_info.compression_method) {
        err = UNZ_BADZIPFILE
    }

    if (err == UNZ_OK) && (s.cur_file_info.compression_method != 0) && (s.cur_file_info.compression_method != CUnsignedLong(ZF_DEFLATED)) {
        err = UNZ_BADZIPFILE
    }

    if unzlocal_getLong(s.file, &uData) != UNZ_OK { /* date/time */
        err = UNZ_ERRNO
    }

    if unzlocal_getLong(s.file, &uData) != UNZ_OK { /* crc */
        err = UNZ_ERRNO
    } else if (err == UNZ_OK) && (uData != s.cur_file_info.crc) && ((uFlags & 8) == 0) {
        err = UNZ_BADZIPFILE
    }

    if unzlocal_getLong(s.file, &uData) != UNZ_OK { /* size compr */
        err = UNZ_ERRNO
    } else if (err == UNZ_OK) && (uData != s.cur_file_info.compressed_size) && ((uFlags & 8) == 0) {
        err = UNZ_BADZIPFILE
    }

    if unzlocal_getLong(s.file, &uData) != UNZ_OK { /* size uncompr */
        err = UNZ_ERRNO
    } else if (err == UNZ_OK) && (uData != s.cur_file_info.uncompressed_size) && ((uFlags & 8) == 0) {
        err = UNZ_BADZIPFILE
    }

    if unzlocal_getShort(s.file, &size_filename) != UNZ_OK {
        err = UNZ_ERRNO
    } else if (err == UNZ_OK) && (size_filename != s.cur_file_info.size_filename) {
        err = UNZ_BADZIPFILE
    }

    piSizeVar &+= UInt32(truncatingIfNeeded: size_filename)

    if unzlocal_getShort(s.file, &size_extra_field) != UNZ_OK {
        err = UNZ_ERRNO
    }
    poffset_local_extrafield = s.cur_file_info_internal.offset_curfile &+ CUnsignedLong(SIZEZIPLOCALHEADER) &+ size_filename
    psize_local_extrafield = UInt32(truncatingIfNeeded: size_extra_field)

    piSizeVar &+= UInt32(truncatingIfNeeded: size_extra_field)

    return err
}

/**
```
  Open for reading data the current file in the zipfile.
  If there is no error and the file is opened, the return value is UNZ_OK.
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:963
@discardableResult
public func unzOpenCurrentFile(_ file: OpaquePointer?) -> Int32 {
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

    if unzlocal_CheckCurrentFileCoherencyHeader(s, &iSizeVar, &offset_local_extrafield, &size_local_extrafield) != UNZ_OK {
        return UNZ_BADZIPFILE
    }

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

    pfile_in_zip_read_info.pos_in_zipfile = s.cur_file_info_internal.offset_curfile &+ CUnsignedLong(SIZEZIPLOCALHEADER) &+ CUnsignedLong(iSizeVar)

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
public func unzReadCurrentFile(_ file: OpaquePointer?, _ buf: Slots<JKAShared.byte>, _ len: UInt32) -> Int32 {
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
                if FileBackend.fseek(pfile_in_zip_read_info.file, CLong(bitPattern: pfile_in_zip_read_info.pos_in_zipfile &+ pfile_in_zip_read_info.byte_before_the_zipfile), SEEK_SET) != 0 {
                    return UNZ_ERRNO
                }
            }
            // ZIP_fread is Raven's macro for fread.
            // AI: Raven hands a pointer to ZIP_fread. FileBackend.fread takes a Slots of bytes, so ZipBackend.bytes gives one over the same buffer.
            if FileBackend.fread(ZipBackend.bytes(pfile_in_zip_read_info.read_buffer, count: UNZ_BUFSIZE)!, at: 0, Int32(bitPattern: uReadThis), 1, pfile_in_zip_read_info.file) != 1 {
                return UNZ_ERRNO
            }
            pfile_in_zip_read_info.pos_in_zipfile &+= CUnsignedLong(uReadThis)

            pfile_in_zip_read_info.rest_read_compressed &-= CUnsignedLong(uReadThis)

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
                i &+= 1
            }

            //			pfile_in_zip_read_info->crc32 = crc32(pfile_in_zip_read_info->crc32,
            //								pfile_in_zip_read_info->stream.next_out,
            //								uDoCopy);
            pfile_in_zip_read_info.rest_read_uncompressed &-= CUnsignedLong(uDoCopy)
            pfile_in_zip_read_info.stream.avail_in &-= CUnsignedLong(uDoCopy)
            pfile_in_zip_read_info.stream.avail_out &-= CUnsignedLong(uDoCopy)
            pfile_in_zip_read_info.stream.next_out = next_out.suffix(from: uDoCopy)
            pfile_in_zip_read_info.stream.next_in = next_in.suffix(from: uDoCopy)
            pfile_in_zip_read_info.stream.total_out &+= CUnsignedLong(uDoCopy)
            iRead &+= uDoCopy
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
            uOutThis = uTotalOutAfter &- uTotalOutBefore

            //			pfile_in_zip_read_info->crc32 =
            //                crc32(pfile_in_zip_read_info->crc32,bufBefore,
            //                        (uInt)(uOutThis));

            pfile_in_zip_read_info.rest_read_uncompressed &-= uOutThis

            iRead &+= UInt32(truncatingIfNeeded: uTotalOutAfter &- uTotalOutBefore)

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

/// Source: oracle/codemp/qcommon/unzip.cpp:1050
// Port-note: The CharBuf overload of row U5, for the `char` array of the zip arm of FS_Read, files_pc.cpp:1068.
// AI: Raven hands the caller's `char` array as the `void *` buffer. The overload hands the bytes of the CharBuf to the original as a Slots that it writes.
public func unzReadCurrentFile(_ file: OpaquePointer?, _ buf: inout CharBuf, _ len: UInt32) -> Int32 {
    return buf.withMutableSlots { bytes in
        unzReadCurrentFile(file, bytes, len)
    }
}

/**
```
  Give the current position in uncompressed data
```
*/
/// Source: oracle/codemp/qcommon/unzip.cpp:1174
public func unztell(_ file: OpaquePointer?) -> CLong {
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
public func unzeof(_ file: OpaquePointer?) -> Int32 {
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
public func unzGetLocalExtrafield(_ file: OpaquePointer?, _ buf: OpaquePointer?, _ len: UInt32) -> Int32 {
    let read_now: UInt32
    let size_to_read: CUnsignedLong

    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)
    guard let pfile_in_zip_read_info = s.pfile_in_zip_read else {
        return UNZ_PARAMERROR
    }

    size_to_read = CUnsignedLong(pfile_in_zip_read_info.size_local_extrafield) &- pfile_in_zip_read_info.pos_local_extrafield

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

    if FileBackend.fseek(pfile_in_zip_read_info.file, CLong(bitPattern: pfile_in_zip_read_info.offset_local_extrafield &+ pfile_in_zip_read_info.pos_local_extrafield), SEEK_SET) != 0 {
        return UNZ_ERRNO
    }

    // AI: Raven hands a pointer to ZIP_fread. FileBackend.fread takes a Slots of bytes, so ZipBackend.bytes gives one over the same buffer.
    if FileBackend.fread(ZipBackend.bytes(buf, count: size_to_read)!, at: 0, Int32(truncatingIfNeeded: size_to_read), 1, pfile_in_zip_read_info.file) != 1 {
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
public func unzCloseCurrentFile(_ file: OpaquePointer?) -> Int32 {
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
public func unzGetGlobalComment(_ file: OpaquePointer?, _ szComment: inout JKAShared.CharBuf, _ uSizeBuf: CUnsignedLong) -> Int32 {
    var uReadThis: CUnsignedLong
    if file == nil {
        return UNZ_PARAMERROR
    }
    let s = UnzS(file!)

    uReadThis = uSizeBuf
    if uReadThis > s.gi.size_comment {
        uReadThis = s.gi.size_comment
    }

    if FileBackend.fseek(s.file, CLong(bitPattern: s.central_pos &+ 22), SEEK_SET) != 0 {
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
