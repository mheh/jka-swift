# The spine round

## What was spliced

Two writer agents put the drafted bodies over every stub function in `Sources/JKAMP_GameLogic/g_main.swift` (45 functions) and `Sources/JKAShared/q_shared.c.swift` (52 functions). The compile agent then ran the gate on branch `spine`.

## Gate counts

The first `swift build` gave 91 error lines, all in `q_shared.c.swift`. The g_main module did not compile in that run, because its dependency JKAShared failed first. After one signature change and two hole passes, `swift build` gave 0 errors. The g_main bodies compiled with no change.

`swift test --no-parallel` ran 106 tests in four binaries, and all passed. The binaries ran 78, 14, 13, and 1 tests.

## Signature changes

`GetStringForID` returns `String?` now, not `String`. Raven returns NULL when no table entry has the ID, so the optional is the honest type. The draft body has `return nil` and `return table[index].name` with an optional name. No caller in `Sources/` calls the function in live code. The only mention is a `Raven wrote:` line in `Sources/JKAMP_GameLogic/NPC_utils.swift`. No caller needed an edit.

## Statements converted to holes

The compile agent converted 58 statements in `q_shared.c.swift` to the three-line hole form. When the failing line opened a compound statement (`if`, `while`), the whole statement became one hole. The list gives the function, the line span in the file before the edit, and the first compiler message.

- `COM_SkipPath`, lines 84-91: referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `COM_StripExtension`, lines 113-113: cannot assign value of type 'Int' to type 'CharBuf'
- `ShortSwap`, lines 154-154: cannot convert return expression of type 'Int32' to return type 'Int16'
- `COM_BeginParseSession`, lines 253-253: cannot find 'com_lines' in scope
- `COM_BeginParseSession`, lines 254-254: cannot convert value of type '_' to expected argument type 'CharBuf'
- `COM_GetCurrentParseLine`, lines 259-259: cannot find 'com_lines' in scope
- `COM_ParseError`, lines 284-284: cannot find 'Com_Printf' in scope
- `COM_ParseWarning`, lines 304-304: cannot find 'Com_Printf' in scope
- `COM_ParseExt`, lines 373-373: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 392-392: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 415-415: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 419-419: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 422-422: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 431-431: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 441-441: cannot find 'com_lines' in scope
- `COM_ParseExt`, lines 449-449: cannot find 'com_token' in scope
- `COM_ParseExt`, lines 454-454: cannot find 'com_token' in scope
- `COM_ParseString`, lines 468-471: binary operator '==' cannot be applied to operands of type 'Character' and 'Int'
- `COM_ParseInt`, lines 488-488: cannot find 'Com_Printf' in scope
- `COM_ParseFloat`, lines 509-509: cannot find 'Com_Printf' in scope
- `COM_ParseVec4`, lines 534-534: cannot convert value of type 'Int32' to expected argument type 'Int'
- `COM_MatchToken`, lines 553-553: cannot find 'Com_Error' in scope
- `SkipBracedSection`, lines 576-582: binary operator '==' cannot be applied to operands of type 'Character' and 'Int'
- `Parse2DMatrix`, lines 643-643: cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type '[Float]'
- `Parse3DMatrix`, lines 662-662: cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type '[Float]'
- `Q_strrchr`, lines 705-705: cannot convert value of type 'Int32' to specified type 'CChar' (aka 'Int8')
- `Q_strncpyz`, lines 744-744: cannot find 'Com_Error' in scope
- `Q_strlwr`, lines 859-859: unexpected non-void return value in void function
- `Q_strupr`, lines 883-883: unexpected non-void return value in void function
- `Q_strcat`, lines 901-901: cannot find 'Com_Error' in scope
- `Q_strcat`, lines 903-903: cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'CharBuf'
- `Q_CleanStr`, lines 960-960: unexpected non-void return value in void function
- `Com_sprintf`, lines 989-989: cannot find 'Com_Error' in scope
- `Com_sprintf`, lines 992-992: cannot find 'Com_Printf' in scope
- `Info_ValueForKey`, lines 1042-1044: cannot find 'BIG_INFO_STRING' in scope
- `Info_RemoveKey`, lines 1172-1172: cannot find 'Com_Error' in scope
- `Info_RemoveKey`, lines 1183-1185: referencing operator function '==' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey`, lines 1189-1196: referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey`, lines 1200-1200: binary operator '+=' cannot be applied to operands of type 'CharBuf' and 'Int'
- `Info_RemoveKey`, lines 1205-1212: referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey`, lines 1224-1226: referencing operator function '==' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey_Big`, lines 1248-1250: cannot find 'BIG_INFO_STRING' in scope
- `Info_RemoveKey_Big`, lines 1260-1262: referencing operator function '==' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey_Big`, lines 1266-1273: referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey_Big`, lines 1277-1277: binary operator '+=' cannot be applied to operands of type 'CharBuf' and 'Int'
- `Info_RemoveKey_Big`, lines 1282-1289: referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_RemoveKey_Big`, lines 1301-1303: referencing operator function '==' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'
- `Info_SetValueForKey`, lines 1342-1342: cannot find 'Com_Error' in scope
- `Info_SetValueForKey`, lines 1346-1346: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey`, lines 1351-1351: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey`, lines 1356-1356: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey`, lines 1368-1368: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey_Big`, lines 1389-1391: cannot find 'BIG_INFO_STRING' in scope
- `Info_SetValueForKey_Big`, lines 1394-1394: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey_Big`, lines 1399-1399: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey_Big`, lines 1404-1404: cannot find 'Com_Printf' in scope
- `Info_SetValueForKey_Big`, lines 1415-1418: cannot find 'BIG_INFO_STRING' in scope
- `Q_strrchr`, lines 756-760: cannot find 'cc' in scope

The `Q_strrchr` hole came from the second pass. The first pass removed the declaration of `cc`, so a later `if cc == 0` statement failed with "cannot find 'cc' in scope".

## Align

The compile agent did not run `align.py`. The worktree has no `tools/oracle-closure/table.sqlite` and no `tools/oracle-closure/.venv`.
