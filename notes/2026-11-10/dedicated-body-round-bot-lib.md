# The body round of the botlib library stems

This record holds the body round of the `l_*` stems and of `be_ea` and `be_interface` of `Sources/JKAMP_DedLogic`, branch `ded-wave3-bot-lib`. The round adopts the eight stub files, fills 158 bodies, and leaves 37 stubs. Every Raven cite is under `oracle/codemp/botlib/`, and every Swift cite is under `Sources/` of the worktree.

## The gate

- `swift build -j 2`: exit 0, 3251 warnings in the build, 43 of them in the files of this round. Most of them are statements after a `portMissing` hole.
- `swift test --no-parallel -j 2`: 150 tests in 9 runs, all pass.

## The bodies per file

| File | Filled | Left |
| --- | --- | --- |
| `l_memory.swift` | 6 | 2 |
| `l_libvar.swift` | 13 | 0 |
| `l_log.swift` | 7 | 0 |
| `l_crc.swift` | 0 | 2 |
| `l_struct.swift` | 5 | 4 |
| `l_script.swift` | 24 | 14 |
| `l_precomp.swift` | 62 | 18 |
| `be_ea.swift` | 29 | 5 |
| `be_interface.swift` | 12 | 1 |

The 62 thunk markers of `be_interface.swift` are generated thunks of functions in other stems or with a `TODO: Port signature`, and the round leaves them.

## The stubs left

- Dead under rule 20, with a note: `CRC_ProcessByte`, `CRC_ContinueProcessString`, `WriteStructWithIndent`, `WriteStructure`, `EA_Tell`, `EA_UseItem`, `EA_DropItem`, `EA_UseInv`, `EA_DropInv`, the 14 dead `l_script` functions (`PS_ExpectTokenString`, `PS_CheckTokenString`, `PS_CheckTokenType`, `PS_SkipUntilString`, `PS_UnreadLastToken`, `PS_UnreadToken`, `PS_NextWhiteSpaceChar`, `ReadSignedFloat`, `ReadSignedInt`, `GetScriptFlags`, `ResetScript`, `NumLinesCrossed`, `ScriptSkipTo`, `PS_ReadLiteral`), and the 12 dead `l_precomp` functions (`PC_PrintDefineHashTable`, `PC_FindDefine`, `PC_AddBuiltinDefines`, `PC_DefineFromString`, `PC_AddDefine`, `PC_RemoveGlobalDefine`, `PC_CopyDefine`, `PC_CheckTokenType`, `PC_SkipUntilString`, `PC_SetIncludePath`, `PC_SetPunctuations`, `LoadSourceMemory`).
- `GetMemory` and `GetHunkMemory`: row BL1.
- `WriteIndent` and `WriteFloat`: row BL2.
- `Sys_MilliSeconds`: row BL4.
- `PC_EvaluateTokens`, `PC_Evaluate`, `PC_DollarEvaluate`: row BL7.
- `PC_AddDefineToHash` and `PC_FindHashedDefine`: row BL6.
- `PC_ReadDefineParms`: row BL8.

## The forms of the round

- The four allocators take a second overload with an `Int32` size, the `srand` form of `bg_lib.swift:179`, so a body passes Raven's `int` expression with no cast.
- A record is the view over the block, the `Searchpath(Z_Malloc(...))` form. A text for a `char *` field keeps the call for the count and takes the setter, the CopyString form, and its free drops under an AI line. A record with its name after it is the shape 8 form of `files_pc.swift:1664`.
- `FreeMemory` reads the word before the block through `Slots<UInt32>(wordBefore:)` of `BotlibViews.swift:57`.
- The export tables are filled through the generated thunks, `aas.AAS_EntityInfo = Aas_exportThunks.AAS_EntityInfo`.
- The `Maximum` and `Minimum` macros of `l_utils.h:17` and `:18` are private hand functions of `l_struct.swift`, the macro form of the guide.
- `LoadScriptFile` and `LoadScriptMemory` set `script.length` before the NUL at `buffer[length]`, under an AI line, because the `buffer` view takes its count from `length`.
- `strncat` at `l_precomp.cpp:461`, `:463`, and `:1014` is `Q_strcat` with the size of the buffer, with a rule 19 note for the overrun. The text is the same on every path that does not overrun. This choice needs a review, see row BL12.

## The localized holes

Each hole is a Port-note, a `// Raven wrote:` line, and a `portMissing` line, so the rest of the body is filled.

- Row BL1, `botimport.Print`: `l_log.swift` (6), `be_interface.swift` (5), `ScriptError`, `ScriptWarning`, `SourceError`, `SourceWarning`, `PC_CheckOpenSourceHandles`. Row BL1, `botimport.BotClientCommand`: `EA_Say`, `EA_SayTeam`, `EA_Command`. Row BL1, `botimport.FS_FOpenFile` and `FS_Read`: `LoadScriptFile`.
- Row BL2: `Log_Write`, `Log_WriteTimeStamped`.
- Row BL3: `ReadString`.
- Row BL5: `GetBotLibAPI`.
- Row BL6: `PC_Directive_define` (3), `PC_AddGlobalDefinesToSource`, `PC_Directive_if_def`, `PC_ReadToken`.
- Row BL7: `PC_Directive_elif`, `PC_Directive_if`, `PC_Directive_eval`, `PC_Directive_evalfloat`, `PC_DollarDirective_evalint`, `PC_DollarDirective_evalfloat`.
- Row BL8: `PC_ExpandDefine`.
- Row BL9: `PS_ReadPunctuation`.
- Row BL10: `PS_ReadString`.
- Row BL11: `LoadScriptFile`.
- Row BL13: `PC_ExpandDefine`.
- `PC_ExpandBuiltinDefine`, the `BUILTIN_DATE` and `BUILTIN_TIME` arms: `time` and `ctime` have no port, row BL14.

At runtime, `PC_ReadToken` traps on every name token (BL6), and `PS_ReadPunctuation` traps on every punctuation (BL9), so no bot script loads yet. `GetBotLibAPI` traps at BL5, and every botlib allocation traps at BL1.

## The rows

- BL1, the run methods of `BotlibImport`. `runPrint(_:_:)` takes the format as an `OpaquePointer?` and has no arguments (`Sources/JKAMP_Ded/Generated/Views/BotlibImport.swift:71`, Raven `botlib.h` `void (QDECL *Print)(int type, char *fmt, ...)`). `runGetMemory` and `runHunkAlloc` return nothing (`:208`, `:248`, Raven `l_memory.cpp:331` and `:373` read the return). `runBotClientCommand`, `runFS_FOpenFile`, `runFS_Read`, and `runFS_Write` take the text, the handle out-parameter, and the buffer as `OpaquePointer?`. The nearest form is `DisplayContextDef.runPrint(_ msg: String)` at `Sources/JKAMP_CGame/Generated/Views/DisplayContextDef.swift:792`, a `const char *` with no varargs. No form exists for a varargs function pointer field or for a `void *` return of a field. The host side, `SV_BotInitBotLib` at `sv_bot.swift:741`, does not fill the table yet either.
- BL2, `fprintf` and `vfprintf` on a `FILE *`. Raven `l_log.cpp:102`, `:119` to `:127`, and `l_struct.cpp:303` and `:331`. `FileBackend` (`Sources/JKAMP_Ded/FileBackend.swift:34`) has `fwrite` of a CharBuf and no `fprintf`. The candidate forms are a `FileBackend.fprintf(_ stream:, _ fmt:, _ args...)`, or the formatted text through `FileBackend.fwrite(CharBuf, at:...)`.
- BL3, `strncpy` into a raw destination. Raven `l_struct.cpp:207`, Swift `l_struct.swift` ReadString. `CString.swift` has `strcpy(_ dest: UnsafeMutableRawPointer, _:)` at `:221` and no raw `strncpy`.
- BL4, the C library `clock()` of `Sys_MilliSeconds`, `be_interface.cpp:62`. `SysBackend` (`Sources/JKAMP_Ded/SysBackend.swift:174`) has `timeGetTime` and no `clock`.
- BL5, `BOTLIB_API_VERSION` of `game/botlib.h`. Only `Sources/JKAMP_Game/Generated/botlib.swift` holds it, and the host does not import it. Raven `be_interface.cpp:842`. D10 names the macro groups of `botlib.h` beyond `PRT_` for the copy, and this one did not land.
- BL6, D6 not applied to `definehash`. PC_AddDefineToHash (`l_precomp.cpp:559`) and PC_FindHashedDefine (`:585`) take `inout Define?` (`l_precomp.swift:245`, `:257`), and Raven indexes the table. The form is the PARAMS kind `pointer_table` of `rulings.py:698` and `:857`, `Slots<Define?>`, the type of `source.definehash`. The docket names only PC_FindHashedDefine and PC_PrintDefineHashTable, so PC_AddDefineToHash also needs the row.
- BL7, D5 not applied to the three evaluate functions. They keep `TODO: Port signature`. The ruling gives `inout Int32` and `inout Double`, and the callers pass NULL, so the parameters need NULLABLE too.
- BL8, `parms` of PC_ReadDefineParms (`l_precomp.cpp:351`, `l_precomp.swift:191`) is `inout Token?`, and Raven fills an array. The form is `inout [View?]` of transcription.md line 115, which the caller's local already has.
- BL9, `strncmp` of a `Slots<byte>` at an offset against a text, `l_script.cpp:790`. The nearest forms are `Q_strncmp(CharBuf, CharBuf, n)` at `JKAShared/q_shared.c.swift:771` and the `Slots<byte>` overloads of `CString.swift:390` to `:429`.
- BL10, the one-`char` out-parameter of PS_ReadEscapeCharacter (`l_script.cpp:344`, called with `&token->string[len]` at `:446`). The stub takes `inout CharBuf`. The candidates are a PARAMS row to `inout Int8`, the scalar out-parameter form of row G6, or `inout CharBuf` with an `at:` offset, the form of `strcpy(_:_:at:)` at `CString.swift:178`.
- BL11, COM_Compress over `script->buffer`, `l_script.cpp:1352`. `COM_Compress` at `JKAShared/q_shared.c.swift:266` takes `inout CharBuf`, and `script.buffer` is a `Slots<byte>`.
- BL12, `strncat`. `CString.swift` has none. The round writes `Q_strcat` with the buffer size at `l_precomp.cpp:461`, `:463`, and `:1014`. The other candidate is a `strncat` overload in `CString.swift`.
- BL13, `tokens` of PC_StringizeTokens (`l_precomp.cpp:450`) is a non-optional `Token`, and Raven passes `parms[parmnum]`, which is NULL for an empty argument, at `:848`. The form is a NULLABLE row.
- BL14, `time` and `ctime` of PC_ExpandBuiltinDefine, `l_precomp.cpp` BUILTIN_DATE and BUILTIN_TIME. No host port exists, and `ctime` returns a `char *`.
