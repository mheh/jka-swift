# The S3 body round of the dead-function wave

This record holds set S3 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-s3` in the worktree `/tmp/jka-s3`, made from `dedicated-rulings-batch-12`. The set is 20 functions in `Sources/JKAMP_DedLogic/l_script.swift` and `Sources/JKAMP_DedLogic/be_ai_chat.swift`. All 20 bodies landed. No stub is open.

## The counts

| File | Stubs | Filled | Left |
| --- | --- | --- | --- |
| l_script | 14 | 14 | 0 |
| be_ai_chat | 6 | 6 | 0 |
| Total | 20 | 20 | 0 |

`portMissing(` stands 0 times in the two files.

## l_script.swift

| Function | Raven | State |
| --- | --- | --- |
| PS_ReadLiteral | l_script.cpp:721 | landed |
| PS_ExpectTokenString | :909 | landed, `Token.scratch` |
| PS_CheckTokenString | :1008 | landed, `Token.scratch` |
| PS_CheckTokenType | :1025 | landed, `Token.scratch` and `token.copy(from:)` |
| PS_SkipUntilString | :1047 | landed, `Token.scratch` |
| PS_UnreadLastToken | :1063 | landed |
| PS_UnreadToken | :1073 | landed, `script.token.copy(from:)` |
| PS_NextWhiteSpaceChar | :1085 | landed, the post-increment is a `defer` |
| ReadSignedFloat | :1136 | landed, MSVC `long double` is `Double` |
| ReadSignedInt | :1159 | landed, `Int32(bitPattern:)` of l_struct.swift:90 and a wrap multiply for the `unsigned long` product |
| GetScriptFlags | :1192 | landed |
| ResetScript | :1202 | landed, NULL is the offset 0, with the AI line of PC_ClearTokenWhiteSpace |
| NumLinesCrossed | :1237 | landed |
| ScriptSkipTo | :1247 | landed |

## be_ai_chat.swift

| Function | Raven | State |
| --- | --- | --- |
| BotDumpSynonymList | be_ai_chat.cpp:553 | landed, the Log_Write form |
| BotDumpRandomStringList | :904 | landed, the Log_Write form |
| BotDumpMatchTemplates | :1060 | landed, the Log_Write form |
| BotDumpReplyChat | :1619 | landed, the Log_Write form |
| BotDumpInitialChat | :1971 | landed, Raven calls Log_Write |
| BotPrintReplyChatKeys | :2556 | landed, Raven calls botimport.Print |

The four fprintf dumps need no `FileBackend.fprintf`. Each fprintf becomes the form of `Log_Write` at `l_log.swift`: `JKAShared.format` makes the text, and `FileBackend.fwrite` writes its bytes to the stream of `Log_FilePointer`. One AI line in each function records the change. The `%ld` of BotDumpSynonymList uses the `l` length that `Sources/JKAShared/Format.swift` supports now.

## The checks

- `swift build -j 2`: complete, no warning in the two files.
- `swift test --no-parallel -j 2`: 156 tests pass, the count of the base branch.
