# The l_precomp and l_script body round

This record holds the body round `bot-precomp` of `Sources/JKAMP_DedLogic/l_precomp.swift` and `Sources/JKAMP_DedLogic/l_script.swift`, the stems of Raven's `oracle/codemp/botlib/l_precomp.cpp` and `l_script.cpp` in the unit mp-engine-ded. The tree is the worktree `/tmp/jka-bot-precomp` on the branch `ded-bodies-bot-precomp`, off master at 7961ee4. The round ran no generator, no build, and no test.

## The survey

The survey counted the stubs that carry a `TODO: Port signature` marker. The rule of the round says that a round writes no body when more than half of its stubs are blocked. Here 102 of 118 stubs carry the marker, so the round wrote no body and did not build. Both stubs keep the skeleton header, because the round made no hand edit.

| Stem | `portMissing` before | after | Signature markers | Blocked by storage or macros | Writable now |
|---|---|---|---|---|---|
| l_precomp | 80 | 80 | 67 | 7 | 6 |
| l_script | 38 | 38 | 35 | 0 | 3 |

The markers name these C types:

| C type | l_precomp | l_script |
|---|---|---|
| `source_t *` parameter | 51 | 0 |
| `source_t *` return | 2 | 0 |
| `script_t *` parameter | 0 | 32 |
| `script_t *` return | 0 | 2 |
| `token_t *` parameter (`token`, `tokens`, `t1`) | 6 | 0 |
| `define_t *` parameter (`define`, `defines`) | 4 | 0 |
| `define_t *` return | 1 | 0 |
| `define_t **` parameter (`definehash`) | 2 | 0 |
| `pc_token_t *` parameter | 1 | 0 |
| `long double *` parameter | 0 | 1 |

The four file-scope globals also stay as markers: `default_punctuations` (l_script.cpp:69, l_script.swift:9), `globaldefines` (l_precomp.cpp:105, l_precomp.swift:27), `directives` and `dollardirectives` (l_precomp.cpp:2535 and :2648, l_precomp.swift:44 and :49), and `sourceFiles` (l_precomp.cpp:3187, l_precomp.swift:57).

## The stubs without a marker

Sixteen stubs have a generated signature. Seven of them still wait for a row:

- PC_RemoveAllGlobalDefines (l_precomp.cpp:1447, l_precomp.swift:578) walks `globaldefines` and calls PC_FreeDefine, rows P3 and P1.
- PC_LoadSourceHandle (:3189, l_precomp.swift:1112), PC_FreeSourceHandle (:3214, :1124), PC_LoadGlobalDefines (:3226, :1130), PC_SourceFileAndLine (:3280, :1157), and PC_CheckOpenSourceHandles (:3310, :1181) read `sourceFiles` and call LoadSourceFile, FreeSource, and PC_ReadToken, rows P1 and P4. PC_CheckOpenSourceHandles also calls `botimport.Print`, row B1 of the seventh ledger.
- PC_ConvertPath (:940, l_precomp.swift:417) reads `PATHSEPERATOR_CHAR` of l_precomp.h:28, and PC_OperatorPriority (:1668, l_precomp.swift:689) reads the `P_` operators of l_script.h up to :127. No Swift constant exists for a macro of these headers, row P2.

Nine stubs need nothing more. A later round can write them:

- PC_InitTokenHeap (l_precomp.cpp:230, l_precomp.swift:143): Raven's body is a comment, so the body is empty.
- PC_NameHash (:539, :269).
- PC_AddGlobalDefine (:1407, :552) and PC_RemoveGlobalDefine (:1426, :565): DEFINEHASHING is 1 at :83, so the bodies return `qtrue` and `qfalse`.
- PC_SetBaseFolder (:3300, :1169), StripDoubleQuotes (l_script.cpp:1102, l_script.swift:395), StripSingleQuotes (:1119, :407), and PS_SetBaseFolder (:1411, :585).

## Rows

- Row P1, the records of l_script.h and l_precomp.h. Raven: `punctuation_t` (l_script.h:133), `token_t` (:141), `script_t` (:158), `define_t` (l_precomp.h:55), `indent_t` (:71), and `source_t` (:80), plus `directive_t` of l_precomp.cpp:86. Port: no view for any of them, because the host entry list reads no botlib header, `tools/oracle-closure/project.toml:354` and :358 to :368, and `HOST_ROOTS` of `tools/oracle-closure/rulings.py:199` names none of them. The 102 signature markers and the globals `default_punctuations`, `directives`, and `dollardirectives` close with this row. Proposal: copy the seven records with Raven's text into `Sources/CJKAMP_Ded/include/ded_types.h` and add them to HOST_ROOTS, the form of row W1 and row N2 of the seventh ledger and of `bot_debugpoly_t` of row B3. The `char *` cursors of `script_t` (`buffer`, `script_p`, `end_p`, `lastscript_p`, `whitespace_p`, `endwhitespace_p`) and of `token_t` need FIELDS kinds, the `bytes` kind of `z_stream.next_in` of row U3 of the unzip round. `directive_t.func` takes `source_t *`, so it is a stored Swift function, the form of `captureFunc` of TYPES (rulings.py:519).
- Row P2, the macros of l_script.h and l_precomp.h. Raven: the `TT_` subtypes, `SCFL_` flags, `P_` operators, and the other macros of l_script.h:16 to :127, and the `INDENT_`, `DEFINE_`, and `BUILTIN_` constants and `PATHSEPERATOR_CHAR` of l_precomp.h:21 to :52. Port: no Swift constant, the same cause as row P1. Proposal: the copy of row P1 carries the macros into ded_types.h, the form of the PRT_ macros in the proposal of row B1. `PATHSEPERATOR_CHAR` takes the hand PATH_SEP of `Sources/JKAMP_Ded/FileBackend.swift`, the NOT_PORTED_MACROS row of `PATH_SEP` at rulings.py:956.
- Row P3, `globaldefines`. Raven: `define_t **globaldefines` (l_precomp.cpp:105), a table of DEFINEHASHSIZE chain heads. Port: marker at l_precomp.swift:27. Proposal: after row P1, TYPES gives it `Slots<Define?>?`, the form of `facets` and `sv_bot:debugpolygons` (rulings.py:527 and :530). The `define_t **definehash` parameter of PC_PrintDefineHashTable (l_precomp.swift:263) and PC_FindHashedDefine (:299) and the field `source_t.definehash` take the same form.
- Row P4, `sourceFiles`. Raven: `source_t *sourceFiles[MAX_SOURCEFILES]` (l_precomp.cpp:3187). Port: marker at l_precomp.swift:57, "No table row for `source_t *[64]`". Proposal: after row P1, TYPES gives it `[Source?]` of 64 slots, the form of `opnames` (rulings.py:521).
- Row P5, `pc_token_t` in the host. Raven: PC_ReadTokenHandle (l_precomp.cpp:3253) takes the `pc_token_t` of q_shared.h:1661. Port: the view `PcToken` exists in `Sources/JKAMP/Generated/Views/PcToken.swift`, and GAME_ROOTS and CGAME_ROOTS name it (rulings.py:47 and :116), but HOST_ROOTS does not, so l_precomp.swift:1145 keeps its marker. Proposal: HOST_ROOTS takes `"pc_token_t": ("PcToken", "CJKAMP")`, the form of `playerState_t` and `qtime_t` at rulings.py:201 and :239.
- Row P6, `long double`. Raven: `token_t.floatvalue` (l_script.h:148) and the `long double *floatvalue` of NumberValue (l_script.cpp:541, l_script.swift:172). WinDed is an MSVC build, where `long double` has the width of `double`. Proposal: `long double` is `Double`, and the pointer parameter is `inout Double`, the form of the `int *` parameters of row G6 of the seventh ledger.
- Row P7, the varargs error functions. Raven: SourceError and SourceWarning (l_precomp.cpp:117 and :141) and ScriptError and ScriptWarning (l_script.cpp:216 and :242) take `char *str, ...` and print through `botimport.Print`. Proposal: after row P1, the generated signature ends in `_ args: any JKAShared.FormatArg...`, the form of Com_Printf at `Sources/JKAMP_BG/bg_local.swift:368`. The print call waits for row B1 of the seventh ledger.

## Build and test

The round wrote no body, so it ran no build and no test.
