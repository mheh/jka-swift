# The unzip and GenericParser2 round

This record holds the round of `Sources/JKAMP_DedLogic/unzip.swift` and `Sources/JKAMP_DedLogic/GenericParser2.swift`, the stems of Raven's `oracle/codemp/qcommon/unzip.cpp` and `GenericParser2.cpp` in the unit mp-engine-ded. The tree is the worktree `/tmp/jka-ded-unzip` on the branch `dedicated-round-unzip`. The branch started off master at 1cdd22f and took a merge of master at 5c71cb9, the landing of PR 77, which holds `FileBackend.swift`. The code commit is d058517. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

Both stubs had the skeleton header, so the round adopted them and removed the header in the code commit. `bodies.py` gave 116 holes over unzip and 36 over GenericParser2. Most unzip holes are reads of `unz_s *` and `file_in_zip_read_info_s *`, which have no view, so the round wrote the bodies by hand from Raven's text over the hand views below.

- unzip: 25 `portMissing` lines before the round and 15 after. 13 of the 15 functions with a generated signature have whole bodies: strcmpcasenosensitive_internal, unzStringFileNameCompare, unzClose, unzGetCurrentFileInfoPosition, unzReadCurrentFile, unztell, unzeof, unzGetLocalExtrafield, unzCloseCurrentFile, and unzGetGlobalComment, plus unzGoToFirstFile, unzGoToNextFile, unzSetCurrentFileInfoPosition, unzLocateFile, and unzOpenCurrentFile up to one hole each. The ten functions with a signature marker keep the marker under a Port-note that names the row.
- GenericParser2: 28 `portMissing` lines before the round and 27 after. GetToken has its body. CleanTextPool keeps its marker, because row C3 gives CTextPool no Swift type. The 26 GP, GPG, and GPV handle functions keep their markers under a rule 20 note, because no file of `oracle/codemp` calls them, row C3 of `notes/2026-11-03/dedicated-cxx-docket.md:17-19`.
- The macros ZIP_fopen, ZIP_fclose, ZIP_fseek, ZIP_fread, ALLOC, and TRYFREE are spelled as their expansion at the site, with Raven's macro name in a comment at the first use. A stream call is the FileBackend call of the files round.
- Raven's `s=(unz_s*)file` is `let s = UnzS(file!)`, the cast form of a view over the `unzFile` handle. Raven's NULL test of `s->pfile_in_zip_read` is a `guard let`.
- Raven's byte walk of `next_in` and `next_out` in the stored arm of unzReadCurrentFile is the element subscript of two `Slots<byte>` locals and `suffix(from:)` for his `+=`.
- unzClose, unzCloseCurrentFile, unzSetCurrentFileInfoPosition, and unzOpenCurrentFile are `@discardableResult`, because files_pc.swift drops their result at most sites.
- GetToken stops its read to the end of a line at the NUL under a rule 19 note, because Raven's loop reads past the NUL when the last line of the text has no line break. GetNumSubGroups and GetNumPairs return 0 for an empty list under a rule 19 note, because Raven's do-while reads through the NULL head.

## The class form of GenericParser2

The round took the ruled form of row C3 of the C++ docket (`notes/2026-11-03/dedicated-cxx-docket.md:90` and `:121`). The classes stand in GenericParser2.swift beside GetToken, which is private to the stem, and not one class per file as rule 21 says.

- `CGPValue` is a struct with `mName: String` and `mList: [String]`. `IsList`, `GetTopValue`, `GetList`, `AddValue`, `Duplicate`, `Parse`, and `Write` keep Raven's names.
- `CGPGroup` is a final class. The pairs and the subgroups are arrays in the add order, and `mInOrderPairs` and `mInOrderSubGroups` hold the same items in name order. `SortObject` appends to the first array and inserts into the second before the first greater name by `Q_stricmp`. A subgroup keeps a weak `mNext` and a weak `mParent`, so `GetSubGroups()` returns the head and a caller walks `GetNext()` as Raven wrote it. `GetPairs()` returns the array, because a struct has no `GetNext`.
- `CGenericParser2` is a final class that holds `mTopLevel`. `Parse` takes `inout TextCursor` for Raven's `char **dataPtr`, and the inline overload takes the cursor by value.
- The text pool is a String. Each `AllocText` of Write is an append to an `inout String`, and each copy of a token into the pool drops, because a String is already a copy. Every such site carries a rule 24 line.
- `CGPGroup::Parse` fills a new value list before it adds the pair, because a struct in an array does not change through a returned copy. The pair is added before the failure return, so the tree after a failed parse is Raven's.
- `FindPairValue` returns `String?`, because `GetTopValue` returns NULL for a pair with an empty list.

The three callers of common.swift (row C3 of `notes/2026-11-09/dedicated-round-common.md:54`) can now call `parser.Parse(&bufParse, cleanFirst)`, `parser.Clean()`, and `CGenericParser2()`. Their signature markers wait for row G1.

## The hand pieces

`Sources/JKAMP_Ded/ZipBackend.swift` is new. Each piece carries a rule 24 line.

| Piece | Raven's counterpart | Use |
|---|---|---|
| `UnzS`, a view with `file`, `gi`, the seven counts, `cur_file_info`, `cur_file_info_internal`, and `pfile_in_zip_read` | `unz_s` of unzip.h:88 | every unzip body |
| `UnzS(_ file: OpaquePointer)` | the cast `(unz_s *)file` | every unzip body |
| `UnzGlobalInfo` | `unz_global_info` of unzip.h:27 | unzGoToNextFile, unzGetGlobalComment |
| `UnzFileInfo`, with the seven fields a body reads | `unz_file_info` of unzip.h:35 | unzGoToNextFile, unzOpenCurrentFile, unzReadCurrentFile |
| `UnzFileInfoInternal` | `unz_file_info_internal` of unzip.h:57 | unzOpenCurrentFile |
| `FileInZipReadInfo`, with `read_buffer` as the `OpaquePointer?` that fread and Z_Free take | `file_in_zip_read_info_s` of unzip.h:64 | the read of the open file |
| `ZStream`, with `next_in` and `next_out` as `Slots<byte>?` of the widest count | `z_stream` of zlib32/zip.h:129 | the read of the open file |
| `ZipBackend.bytes(_:count:)` | the cast `(Byte *)buf` | unzReadCurrentFile |
| `ZipBackend.inflateInit`, `.inflate`, `.inflateEnd` | `inflateInit`, `inflate`, and `inflateEnd` of zlib32/zip.h:186 to :188 | unzOpenCurrentFile, unzReadCurrentFile, unzCloseCurrentFile |

The system zlib stream lives in a C allocation that the `istate` field of Raven's stream holds. Each `inflate` copies the two positions and the two counts into the system stream, runs `inflate` with `Z_SYNC_FLUSH`, copies them back, and adds the counts to `total_in` and `total_out`. Each status maps to the `EStatus` of zlib32, whose numbers differ from the system zlib.

`Sources/JKAZlib/SystemInflate.swift` is a new target. zlib.h and Raven's zlib32 header both define `struct z_stream_s`, and Clang refuses the two records in one module context, so no file that imports CJKAMP_Ded can import CJKAZlib. An `internal import` of CJKAZlib in JKAZlib still loaded the C module into JKAMP_Ded, so the import is `@_implementationOnly`, and each build gives one warning for it. `Package.swift` makes JKAMP_Ded depend on JKAZlib and JKAZlib on CJKAZlib. The Windows lane builds only jampgame and cgame, so it does not build the target.

`unzOpenCurrentFile` stores `OpaquePointer(Z_Malloc(UNZ_BUFSIZE, TAG_FILESYS, false))` into `read_buffer` under a rule 24 line, the form of the zone block of FS_ReadFile in the files round.

## Rows for the user

- Row U1, the stream helpers. Raven: `unzlocal_getShort` (unzip.cpp:255), `unzlocal_getLong` (:265), and `unzlocal_SearchCentralDir` (:335). C types: `ZIP_FILE *fin`, which is `FILE *`, `uLong *pX`, and the `uLong` return. Callers: unzOpen (:413), unzlocal_GetCurrentFileInfoInternal (:558), and unzlocal_CheckCurrentFileCoherencyHeader (:877). Proposal: the PARAMS kind `opaque` for `FILE *`, the stream of FileBackend and row F2, and `inout CUnsignedLong` for `uLong *`, so the skeleton writes `private func unzlocal_getShort(_ fin: OpaquePointer?, _ pX: inout CUnsignedLong) -> Int32`. The `short v` and `int v` locals take `BYTE_STORAGE_LOCALS` rows, a `Slots<Int16>` and a `Slots<Int32>` of one slot, so `ZIP_fread(&v, sizeof(v), 1, fin)` reads through FileBackend. Raven stores the signed `short` into `uLong`, which sign-extends, and the body keeps that.
- Row U2, the `unzFile` return. Raven: `unzOpen` (:413) and `unzReOpen` (:388). C type: `unzFile`, a `void *`. Callers: FS_LoadZipFile of files_pc.cpp:1423. Proposal: the RETURNS kind `opaque`, so the skeleton writes `func unzOpen(_ path: String) -> OpaquePointer?`. Raven's `unz_s us` local is a `UnzS.scratch` closure, and `*s=us` is `s.copy(from: us)`.
- Row U3, the unzip.h records. Raven: unzip.h:15 to :105 and zlib32/zip.h:129. C types: `unz_s`, `unz_global_info`, `unz_file_info`, `unz_file_info_internal`, `file_in_zip_read_info_s`, `tm_unz`, and `z_stream`. Callers: unzGetGlobalInfo (:528), unzlocal_DosDateToTmuDate (:542), and unzlocal_CheckCurrentFileCoherencyHeader (:877), and row F11 of the files round. Proposal: `HOST_ROOTS` takes the seven records, the form of row Z1 and row F5. `FIELDS` gives `z_stream.next_in` and `.next_out` the kind `bytes` and `file_in_zip_read_info_s.read_buffer` and the two `file` fields the kind `opaque`. The generator then writes the views, the hand views of ZipBackend.swift go in that commit, and `ZipBackend.bytes` and the three inflate calls stay. The skeleton then writes `func unzGetGlobalInfo(_ file: OpaquePointer?, _ pglobal_info: UnzGlobalInfo) -> Int32`, `private func unzlocal_DosDateToTmuDate(_ ulDosDate: CUnsignedLong, _ ptm: TmUnz)`, and `private func unzlocal_CheckCurrentFileCoherencyHeader(_ s: UnzS, _ piSizeVar: inout UInt32, _ poffset_local_extrafield: inout CUnsignedLong, _ psize_local_extrafield: inout UInt32) -> Int32`. The hole of unzOpenCurrentFile closes with it.
- Row U4, the file info of the current file. Raven: `unzlocal_GetCurrentFileInfoInternal` (:558) and `unzGetCurrentFileInfo` (:722). C types: `unz_file_info *` and `unz_file_info_internal *`, each NULL at some callers, `char *szFileName` and `char *szComment` with a size beside each, NULL at some callers, and `void *extraField`. Callers: unzGoToFirstFile (:737), unzGoToNextFile (:759), unzSetCurrentFileInfoPosition (:802), unzLocateFile (:827), and FS_LoadZipFile of files_pc.cpp:1423. Proposal: after row U3, `UnzFileInfo?` and `UnzFileInfoInternal?` by the NULL sweep, `inout CharBuf?` for the two text buffers, the form of the `CharBuf?` FS_ReadFile of row 7 of the first ledger, and `OpaquePointer?` for `extraField`. The four holes of unzGoToFirstFile, unzGoToNextFile, unzSetCurrentFileInfoPosition, and unzLocateFile close with it.
- Row U5, unzReadCurrentFile into a CharBuf. This is row F13 of the files round. Raven: the zip arm of FS_Read at files_pc.cpp:1068 into the caller's `char` array. Question: `withSlots` of CharBuf.swift gives the bytes for a read alone, and the inflate writes. Proposal: a mutating form of `withSlots` in CharBuf.swift under a rule 24 line, and an overload `unzReadCurrentFile(_ file: OpaquePointer?, _ buf: inout CharBuf, _ len: UInt32) -> Int32` after the original that hands the bytes on through it. The original then takes the `Slots<byte>` by the PARAMS kind `bytes`, so the overload has no second body.
- Row G1, the C++ class signatures of common.swift. Raven: `Com_ParseTextFile` (common.cpp:2179 and :2209) and `Com_ParseTextFileDestroy` (:2204). C types: `class CGenericParser2 &parser` and the return `CGenericParser2 *`. Proposal: a TYPES row that names `CGenericParser2` as the Swift class of this round, so a reference is the class, `func Com_ParseTextFile(_ file: String, _ parser: CGenericParser2, _ cleanFirst: Bool) -> Bool`, and the pointer return is `CGenericParser2?`. The `new char[length + 1]` buffer is a CharBuf, and `&bufParse` is a TextCursor over it.
- Row G2, the class file layout. Rule 21 asks for one class per file on the C++ track. The three classes call the private GetToken of the stem, so they stand in GenericParser2.swift. Proposal: keep them there, because GetToken is the one helper of the three, and rule 21 allows private helpers in the same file.

## The open holes

| Function | Line | Hole | Row |
|---|---|---|---|
| unzlocal_getShort, unzlocal_getLong, unzlocal_SearchCentralDir | :255, :265, :335 | signature marker | U1 |
| unzReOpen, unzOpen | :388, :413 | signature marker | U2 |
| unzGetGlobalInfo, unzlocal_DosDateToTmuDate, unzlocal_CheckCurrentFileCoherencyHeader | :528, :542, :877 | signature marker | U3 |
| unzlocal_GetCurrentFileInfoInternal, unzGetCurrentFileInfo | :558, :722 | signature marker | U4 |
| unzOpenCurrentFile | :982 | the call of unzlocal_CheckCurrentFileCoherencyHeader | U3 |
| unzGoToFirstFile, unzGoToNextFile, unzSetCurrentFileInfoPosition | :746, :775, :812 | the call of unzlocal_GetCurrentFileInfoInternal | U4 |
| unzLocateFile | :855 | the call of unzGetCurrentFileInfo | U4 |
| CleanTextPool | GenericParser2.cpp:212 | no caller under row C3 | C3 |
| GP, GPG, and GPV handle functions, 26 | GenericParser2.cpp:928 to :1195 | no caller in `oracle/codemp` | rule 20 |

## The test

`Tests/JKAMP_DedLogicTests/GenericParser2Tests.swift` parses a small terrain text with a comment, two subgroups, a quoted value with a space, and a bracket list, and checks the sibling walk, the pair values with a default and a `||` key, and the list. A second test fails a parse of a group with no closing brace. Both pass.

The round adds no zip test. unzOpen carries a signature marker, row U2, and its helpers carry the markers of rows U1 and U3, so no Swift call opens a zip file yet.

## The gate

The gate ran on the branch after the merge of master at 5c71cb9.

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. unzip.swift gives 11 warnings, all at the holes: "will never be executed" after each of the 5 holes, and "never mutated" for `err` of three functions and the three locals of unzOpenCurrentFile that the hole of row U3 would write. SystemInflate.swift gives the `@_implementationOnly` warning. |
| `swift test --no-parallel -j 2` | exit 0, 148 tests, 0 failures, with the two tests of `GenericParser2Suite` |
| `draftcheck.py --unit mp-engine-ded --stem unzip` | exit 0, 10 of 26 hand functions replaced, 16 kept, 116 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem GenericParser2` | exit 0, 27 of 29 hand functions replaced, 2 kept, 36 holes, 0 cascade errors, 0 defects, 8 compile holes over 2 passes |

The holes of draftcheck are in the drafter's output, not in the working tree. The working tree holds 15 `portMissing` lines in unzip.swift and 27 in GenericParser2.swift, the lines of the table above. `grep Unsafe` gives 0 lines in both files.
