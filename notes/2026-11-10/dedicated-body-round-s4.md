# The body round of set S4

This record holds the body round of set S4 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-s4` in the worktree `/tmp/jka-s4`. The set has twelve functions in `Sources/JKAMP_DedLogic/l_precomp.swift`, `l_crc.swift`, and `cm_polylib.swift`. No caller in the dedicated server calls them. Each body keeps its one-line Port-note about the missing caller. A check against `oracle/codemp/` found each note correct.

## The functions

| Function | Raven | State |
| --- | --- | --- |
| PC_PrintDefineHashTable | botlib/l_precomp.cpp:516 | landed |
| PC_FindDefine | :604 | landed |
| PC_DefineFromString | :1323 | landed, with `Source.scratch` for Raven's `source_t src` on the stack |
| PC_AddDefine | :1381 | landed, the DEFINEHASHING arm |
| PC_RemoveGlobalDefine | :1426 | landed, the DEFINEHASHING arm is `return qfalse` |
| PC_CopyDefine | :1479 | landed, the name in the string pool, the form of PC_Directive_define with its `AI:` line |
| PC_CheckTokenType | :2955 | landed, `Token.scratch` and `token.copy(from:)` |
| PC_SkipUntilString | :2977 | landed |
| PC_SetPunctuations | :3029 | landed |
| LoadSourceMemory | :3080 | landed, the form of LoadSourceFile |
| CRC_ProcessByte | botlib/l_crc.cpp:85 | landed, the form of CRC_ProcessString |
| pw | qcommon/cm_polylib.cpp:17 | landed, `SysBackend.printf` with the `AI:` line of `win_main.swift:168` |

Three functions of the same files are outside the set and stay stubs: PC_AddBuiltinDefines (row N-LOCALTABLE), PC_SetIncludePath (row G20), and CRC_ContinueProcessString (row G11).

## Notes

- LoadSourceMemory does not allocate `globaldefines`, as Raven does not. If no LoadSourceFile ran before it, PC_AddGlobalDefinesToSource reads a null table. Raven dereferences NULL there, and the Swift traps at the force unwrap at the same line.
- PC_DefineFromString frees `def` only when `src.defines` is not NULL. Under DEFINEHASHING that field stays NULL, so a failed define stays in memory, as in Raven.

## The checks

- `swift build -j 2`: no error, and no new warning in the three files.
- `swift test --no-parallel -j 2`: 161 tests pass, none fail.
