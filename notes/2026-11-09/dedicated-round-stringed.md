# Dedicated round: stringed_ingame, stringed_interface, and cmd_pc

This record covers the first round of the host stems `stringed_ingame`, `stringed_interface`, and `cmd_pc` of the unit `mp-engine-ded`.
The Raven sources are `oracle/codemp/qcommon/stringed_ingame.cpp`, `stringed_interface.cpp`, and `cmd_pc.cpp`, and the Swift files are `Sources/JKAMP_DedLogic/stringed_ingame.swift`, `stringed_interface.swift`, and `cmd_pc.swift`.
The branch is `dedicated-round-stringed`, off master at `1cdd22f`, in the worktree `/tmp/jka-ded-stringed`. The code commit is `ea97a86`.

## What changed

- The three stubs are adopted, and the skeleton header is gone from each.
- The drafter gave 43 holes for stringed_ingame, 21 for cmd_pc, and 0 for stringed_interface. The bodies are hand ports of Raven's text, because the drafts held a hole at every `std::` member, every C++ method call, and every pointer local.
- `CStringEdPackage` (`stringed_ingame.cpp:64`) is a `final class` with Raven's name, its six private parse fields, its four public fields, and its 18 methods with a body. The three methods that Raven declares and never defines are not ported, by row C6. The constructor and the destructor call `Clear(false)` as Raven's do.
- `TheStringPackage` (`:124`) is a `let` of `EngineWorld`, and the stub forwards it under Raven's name.
- `m_StringEntries` is `[String: SE_Entry_t]`, `m_mapFlagMasks` is `[String: Int32]`, and `m_vstrFlagNames` is `[String]`, by row C6 and the shapes of `notes/2026-11-03/dedicated-cxx-docket.md`. `gvLanguagesAvailable` (`:1071`) is `[String]` on `EngineWorld`.
- `SE_Entry_t` (`:48`) is a struct of two `String` fields and `m_iFlags`, and `mapStringEntries_t` (`:62`) is its Dictionary alias.
- The static `std::string` of `ConvertCRLiterals_Read`, `InsideQuotes`, and `Leetify` and the static buffers of the three `Filename_` methods are locals that return `String`, by row C6 and rule 7.
- The 17 constants of `stringed_ingame.h:13-34` are file constants of `stringed_ingame.swift`, because the header parse of the unit reads `qcommon.h` alone. The commit body of `ea97a86` says 20, which is wrong. The count is 17.
- `CopeWithDumbStringData` fills a local `CharBuf` of Raven's size in place of the `Z_Malloc` block, and the `Z_Free` of `ParseLine` (`:713`) goes.
- `strtok` of the `FLAGS` arm (`:623`) is a split of the copy on the same separators, which gives the same tokens.
- `cmd_functions` (`cmd_pc.cpp:11`) is `[CmdFunctionRow]` on `EngineWorld`, with the head of Raven's list at index 0. `CmdFunctionRow` has `name` and `function` and no `next`, the form of `SpawnRow` of `g_local.swift`. `Cmd_AddCommand` inserts at 0, `Cmd_ExecuteString` moves the found row to 0, and `Cmd_RemoveCommand` removes the row. The record keeps `CopyString` for the zone count of the name, and the `S_Malloc` of the record and the two `Z_Free` calls go.
- Every site that a ruling changes carries one `// AI:` line: 26 in stringed_ingame, 6 in cmd_pc, 1 in `StringEdViews.swift`, and 2 in `EngineWorld.swift` for the command list and the language cache.
- One rule 19 note: `InsideQuotes` (`:418`) stops the trim at an empty text, where Raven reads the byte before the text.

## Hand pieces

| File | Piece | Raven counterpart |
|---|---|---|
| `Sources/JKAMP_Ded/StringEdViews.swift` | `strrchr(_ s: CharBuf, _ c: Int32) -> Int32?`, the offset of the last match | The C library `strrchr`, called at `stringed_ingame.cpp:168`, `:169`, `:190-192`, and `:943`, in the form of `strchr` of `CString.swift` |
| `Sources/JKAMP_DedLogic/EngineWorld.swift` | `cmd_functions`, `TheStringPackage`, `gvLanguagesAvailable` | `cmd_pc.cpp:11`, `stringed_ingame.cpp:124`, `:1071` |
| `Sources/JKAMP_DedLogic/cmd_pc.swift` | `CmdFunctionRow` | `cmd_function_t` of `cmd_pc.cpp:3` |

## Holes and their open rows

| File | Holes | Signature markers |
|---|---:|---:|
| `stringed_ingame.swift` | 4 `portMissing` | 1 (`SE_GetFoundFile`) |
| `stringed_interface.swift` | 4 `portMissing` | 3 (`SE_LoadFileData`, `SE_R_ListFiles`, `SE_BuildFileList`) |
| `cmd_pc.swift` | 0 | 0 |

- Row S1, the C++ `string &` parameter. Raven: `static LPCSTR SE_GetFoundFile( string &strResult )` (`stringed_ingame.cpp:875`), `static void SE_R_ListFiles( const char *psExtension, const char *psDir, string &strResults )` (`stringed_interface.cpp:132`), and `int SE_BuildFileList( const char *psStartDir, string &strResults )` (`:192`). C type: `std::string &`, which the table has no row for. Callers: `SE_GetNumLanguages` (`stringed_ingame.cpp:1077`, `:1088`), `SE_LoadLanguage` (`:1217`, `:1227`), `SE_BuildFileList` (`stringed_interface.cpp:198`), and `SE_R_ListFiles` itself (`:154`). Holes: the stubs of the three functions, and one hole each in `SE_GetNumLanguages` and `SE_LoadLanguage`. Proposal: a `std::string &` parameter is `inout String`, the form of PARAMS kind `out_string`, and `SE_GetFoundFile` returns `String?` under RETURNS kind `optional_string`, because Raven returns NULL at the end of the list. `SE_R_ListFiles` also needs the signature of `FS_ListFiles`, whose `char **` return is a row of files_pc.
- Row S2, the loaded bytes. Raven: `unsigned char *SE_LoadFileData( const char *psFileName, int *piLoadedLength /* = 0 */)` (`stringed_interface.cpp:41`) and `void SE_FreeFileDataAfterLoad( unsigned char *psLoadedFile )` (`:109`). C type: an `unsigned char *` return that the table has no row for, and an `int *` with a default that no caller passes. Callers: `SE_Load_Actual` (`stringed_ingame.cpp:832`, `:853`). Holes: the stub of `SE_LoadFileData`, the stub of `SE_FreeFileDataAfterLoad`, whose `Slots<UInt8>` no `FS_FreeFile` overload takes, and one hole in `SE_Load_Actual`. The rest of `SE_Load_Actual` is Raven's body under the proposed form and is unreachable until the row lands. Proposal: the return is `Slots<UInt8>?`, the spelling the table gives the parameter of `SE_FreeFileDataAfterLoad`, with nil for Raven's NULL, and `FS_FreeFile` takes a `Slots<byte>` overload in files_pc. `piLoadedLength` is `inout Int32?` with the default nil, the scalar output form of the NULL sweep.
- Row S3, the class form. The shapes paragraph of the C++ docket says "a plain struct with methods", and no ledger row rules it. The port uses a `final class`, the form of row C3 for `CGPGroup`, because Raven has one global object with an identity, and a struct behind the `world` forward copies the Dictionary on every change of a parse. Proposal: ratify the `final class` for `CStringEdPackage`.
- Row S4, the constants of `stringed_ingame.h`. Proposal: the header parse of the host unit reads `stringed_ingame.h`, `reexport.py` emits the 17 constants, and the file constants go.
- Row S5, the NULL error text. `SE_Load_Actual` (`:828`), `SE_Load` (`:910`), `SE_LoadLanguage` (`:1208`), and `ParseLine` (`:578`) return NULL for success. The stubs return `String`, so the port returns "" for NULL under a rule 24 line, and a caller tests `isEmpty`. Proposal: RETURNS kind `optional_string` for the three functions, so the return is `String?` and Raven's NULL test stays.
- Row S6, the C++ defaults of `SE_Load`. Raven's definition (`:910`) gives `bLoadDebug = SE_TRUE` and `bFailIsCritical = SE_TRUE`, and the stub has no default. `SE_LoadLanguage` calls `SE_Load( p, bLoadDebug )` (`:1233`), inside the hole of row S1. Proposal: `cxx_default` reads the defaults of a definition with no prior declaration, as it does for `SE_LoadLanguage`.

## The goal of the wave

The `jampded` executable does not yet run `Com_Init` to a server loop. `SE_Init` calls `SE_LoadLanguage`, which stops at the hole of row S1, and `FS_ReadFile`, `FS_ListFiles`, and `FS_FreeFile` of files_pc are stubs too. The table half of StringEd works: `StringEdSuite` parses a `.str` text through `ReadLine` and `ParseLine` and reads the strings back through `SE_GetString`.

## Test

`Tests/JKAMP_DedLogicTests/StringEdTests.swift` holds `StringEdSuite`, two tests. The first sets `se_debug` and `sp_leet` to scratch cvars, feeds a ten-line `.str` text with CR LF line ends through `SetupNewFileParse`, `ReadLine`, and `ParseLine`, and checks the end marker, a string with a quoted `//`, a string with a `\n` literal and a trailing comment, a missing reference, the flag mask, the flags of an entry, and a negative flag index. The second checks Raven's message for an unknown keyword. The test cannot go through `SE_Load` or `SE_LoadLanguage`, because of rows S1 and S2.

## Gate

- `swift build -j 2`: complete, exit 0, 0 errors. One warning in the stems, "will never be executed" at `stringed_ingame.swift:749`, after the hole of row S2.
- `swift test --no-parallel -j 2`: 148 tests in 9 runs, 0 failures, exit 0. `StringEdSuite` passed.
- `draftcheck.py --unit mp-engine-ded --stem stringed_ingame`, exit 0: 1 of 22 hand functions replaced, 21 kept, 44 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass.
- `draftcheck.py --unit mp-engine-ded --stem stringed_interface`, exit 0: 4 of 4 hand functions replaced, 0 kept, 1 hole, 0 cascade errors, 0 defects, 1 compile hole over 2 passes.
- `draftcheck.py --unit mp-engine-ded --stem cmd_pc`, exit 0: 0 of 6 hand functions replaced, 6 kept, 25 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass.

The holes in the three draftcheck lines are holes of the drafts that the tool prints, not holes of the hand files. The store of this worktree was empty, so the tool wrote the base facts and the adoption facts. This round ran no generator.
