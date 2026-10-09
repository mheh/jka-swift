# The spine round, reviewed

The review reads the diff `dbef991..e68822d` of branch `spine`, captured once at `/tmp/spine-review/splice.diff`, the printed drafts under `/tmp/spine/`, and the record `notes/2026-10-08/spine-round.md` at `fbb6043`. The rules are `docs/transcription.md`, `docs/oracle-closure.md`, and the rule that a drafter defect goes to the drafter as a shape rule and never as a hand fix in the file.

## 1. Fidelity of the splice

Method. The writer scripts at `/tmp/spine/splice_g_main.py` and `/tmp/spine/splice_q_shared.py` replace a marker pair under a `/// Source:` line with the draft body under the same `/// Source:` line. I ran the same replacement with my own script, `/tmp/spine-review/resplice.py`, over the `dbef991` text of each file and the printed draft, and compared the result with the `e68822d` text by `diff`. This checks all 97 functions, not a sample of ten, and it checks every line outside the bodies at the same time, because any line the writer touched outside a body would stand in the residual diff.

g_main. The residual diff is empty. All 45 bodies match the printed draft line for line, every hand signature stands, and no line outside the 45 bodies changed. The draft signatures and the hand signatures of g_main agree on every function.

q_shared. The residual diff holds 299 changed lines, and every one of them is the compile agent's work: the one signature line of `GetStringForID` and the 58 hole conversions of section 3. No writer edit stands outside the 52 bodies, and the 52 bodies went in line for line with the hand signature kept. The hand signatures and the draft signatures differ on 13 functions. Nine differ only by the module qualifier, `CharBuf` against `JKAShared.CharBuf`, which is spelling. Four differ in type: `GetStringForID` returns `String` in the hand file and `String?` in the draft, `ShortSwap` and `ShortNoSwap` take and return `Int16` in the hand file and `Int32` in the draft, and `COM_MatchToken` takes `match` as `inout JKAShared.CharBuf` in the hand file and as `String` in the draft. The manifest `.claude/manifest/q_shared.md` gives the draft's spelling for all four, so the hand stubs are stale against the table. `docs/transcription.md` line 37 says that an adopted file keeps its old stub line and a second pass takes the signature from `lookup.py sig`, not from the file. The writer brief said to keep the hand signature, so the writer followed the brief and not that rule. The `ShortSwap` hole of section 2 is the direct cost.

## 2. The 58 holes

I grouped the 58 by the compiler's message and the drafted text behind it. The counts sum to 58.

Com_Printf and Com_Error are not visible in JKAShared, 18 holes. Twelve name `Com_Printf` and six name `Com_Error`. Both functions exist only in `Sources/JKAMP_BG/bg_local.swift`, internal, and in `Sources/JKAMP_GameLogic/g_main.swift`, public, and JKAShared imports neither module. This is a missing declaration in Sources, a channel for the shared module, of the kind `docs/oracle-closure.md` section 6 names for the bg module. Example: `Com_Error(ERR_DROP, "MatchToken: %s != %s", token, match)` in `COM_MatchToken` of `q_shared.c.swift`.

The file-scope state of the parser is not declared, 12 holes. Eight name `com_token`, three name `com_lines`, and one is the `Com_sprintf(&com_parsename, ...)` call of `COM_BeginParseSession`, whose message reads `cannot convert value of type '_'` because `com_parsename` has no declaration. The head of `q_shared.c.swift` carries the three `TODO: Port global` markers and the rule 3 note that each is a stored property of `GameWorld` spelled `world.com_token` in a body. No `GameWorld` property exists, and the only `com_token` in Sources is a local of `g_spawn.swift`. This is a missing declaration in Sources first. The draft also spells the name bare, not `world.com_token` as the rule 3 note says, so the drafter and the note disagree on the spelling, and that part is a drafter question. Example: `com_token[0] = 0` in `COM_ParseExt`.

`BIG_INFO_STRING` is not visible in JKAShared, 4 holes. The constant stands in `Sources/CJKAMP/include/codemp/game/q_shared/constants.h` and `Sources/JKAMP/Generated/q_shared.swift`, and JKAShared sees neither. This is a missing declaration in Sources, a placement question for `merge.py`. Example: `if strlen(s) >= BIG_INFO_STRING` in `Info_RemoveKey_Big`.

A `CharBuf` parameter walked as a C pointer, 15 holes. The draft compares the buffer itself to an `Int32`, steps it with `+= 1`, assigns `0` to it, or takes `&buffer + offset` as a pointer. The messages are the `BinaryInteger` conformance errors, nine, the `+=` errors, two, the assignment error of `COM_StripExtension`, one, the `UnsafeMutableRawPointer` errors of `Q_strcat`, `Parse2DMatrix`, and `Parse3DMatrix`, three. This is a drafter defect. The `TextCursor` and `.byte` shapes exist, `COM_StripExtension` uses `in.byte` on the line before its hole, and the drafter does not apply them to a `char *` parameter the body steps. Example: `while pathname != 0` in `COM_SkipPath`.

A `String` indexed as a C char array, 2 holes. `COM_ParseString` compares `s[0] == 0` and `SkipBracedSection` compares `token[1] == 0` where `s` and `token` are `String`. This is a drafter defect. Example: `if s[0] == 0` in `COM_ParseString`.

A return of the parameter under a void signature, 3 holes. `Q_strlwr`, `Q_strupr`, and `Q_CleanStr` return `char *` in Raven, the table gives them a void signature over `inout CharBuf`, and the draft keeps `return s1`. The drafter wrote a return that its own signature forbids. This is a drafter defect. Example: `return s1` in `Q_strlwr`.

An integer width the drafter did not convert, 2 holes. `COM_ParseVec4` indexes `vec4_t` with an `Int32` and `Q_strrchr` writes `let cc: CChar = c` from an `Int32`. This is a drafter defect. Example: `(c)[i] = f` in `COM_ParseVec4`.

A signature mismatch between the hand file and the table, 1 hole. `ShortSwap` returns `Int32` arithmetic into the hand file's `Int16`. The table gives `Int32`. This is the stale stub of section 1, not a drafter defect.

A cascade, 1 hole. The second `Q_strrchr` hole, `if cc == 0`, follows from the first pass, which removed the declaration of `cc`. `docs/oracle-closure.md` names this a cascade and not a defect.

By class, 34 holes are missing declarations in Sources, 22 are drafter defects in four shapes, 1 is a stale hand signature, and 1 is a cascade. The 22 drafter holes are four classes, and under the standing rule each class is a drafter finding, not a hand fix.

## 3. The compile agent's hole conversions

All 58 conversions are three lines: a `// Port-note:` line, a `// Raven wrote:` line, and a `portMissing` call with the function and the `oracle/codemp/game/q_shared.c` source of the function. The indentation matches the statement's depth. The three-line shape is the drafter's shape in the same file.

The content of two of the three lines differs from the tool's own compile hole. `printer.py --compile-holes` writes the Port-note as the sentence of `COMPILE_NOTE` in `tools/oracle-closure/layout.py`, `The draft of this statement did not compile, and the compiler wrote "..."`, and it writes the `Raven wrote:` line from the `statements` row, which holds Raven's C text. The compile agent wrote the bare compiler message as the Port-note and the drafted Swift text as the `Raven wrote:` line. So a reader of the 58 holes sees Swift after `Raven wrote:`, and a grep for the tool's compile holes by its sentence does not find them.

One conversion dropped a declaration a later statement reads. The first pass holed `let cc: CChar = c` in `Q_strrchr`, and the second pass holed `if cc == 0 { ... }` for `cannot find 'cc' in scope`. The record names it. No other conversion removed a declaration.

Fifteen conversions took more lines than the failing statement, because the failing line opened a compound statement and the whole compound became one hole. The cases are `COM_SkipPath` lines 84-91, `COM_ParseString` 468-471, `SkipBracedSection` 576-582, `Q_strrchr` 720-724 in the text after the first pass, `Info_ValueForKey` 1042-1044, `Info_RemoveKey` 1183-1185, 1189-1196, 1205-1212, and 1224-1226, `Info_RemoveKey_Big` 1260-1262, 1266-1273, 1282-1289, and 1301-1303, `Info_SetValueForKey_Big` 1389-1391 and 1415-1418. This is the rule of `holed()` in `printer.py`, a statement inside a rejected statement goes with it, so the shape matches the tool. The cost is that six drafter holes inside those compounds vanished into the `Raven wrote:` comment line: one in `COM_SkipPath`, two in `Info_RemoveKey`, two in `Info_RemoveKey_Big`, and one in `Q_strrchr`. The file holds 183 `portMissing` calls now, 131 from the draft less the six absorbed plus the 58 of the agent. A plain grep counts 189, because the six absorbed calls stand as text inside six `Raven wrote:` comments. The record does not say that the compound conversions absorbed holes, and any count that greps `portMissing` on this file is six high.

## 4. The signature change

Raven's `GetStringForID` at `oracle/codemp/game/q_shared.c:35-49` returns `NULL` when no entry of the table has the ID, so `String?` is the honest return and the draft body's `return nil` and `return table[index].name` fit it. The manifest already gives `String?` for this function, so the agent did not change the table's signature, it brought a stale hand stub to the table's spelling. No live caller exists in Sources. The one mention is the `Raven wrote:` line of a hole in `Sources/JKAMP_GameLogic/NPC_utils.swift:687`, where `G_DebugPrint` passes the result to a `%s`, and that hole stays a hole for its own reason, a `Slots` over one record. The change is right and no caller needed an edit.

The same staleness stands on `ShortSwap`, `ShortNoSwap`, and `COM_MatchToken`, which the agent did not change. `ShortSwap` paid one hole for it. `COM_MatchToken` compiled with `match` as `inout CharBuf`, so no hole shows the mismatch, but a caller that holds a `String` cannot call it as the table spells it.

## 5. The record against the diff

The record's counts hold: 45 and 52 functions, 58 holes, one signature change, 0 errors, 106 tests. The 58 entries match the residual diff one to one, and the record's line spans are the spans of the text before each edit.

Three statements of the record are short of the diff. First, the record says the whole compound became one hole and does not say that six drafter holes inside those compounds went with it, so the record's reader cannot count the holes of the file from the record. Second, the record lists `ShortSwap` among the 58 without its cause, which is the stale hand signature and not the draft. Third, the second `Q_strrchr` span, 756-760, is in the text after the first pass, while every other span is in the text before any edit, and the list does not say so. Nothing in the record contradicts the diff.

## Open findings for the user

| Row | Finding | Proposed ruling |
| --- | --- | --- |
| R1 | The writer kept four stale hand signatures of `q_shared.c.swift` against the table, `GetStringForID`, `ShortSwap`, `ShortNoSwap`, `COM_MatchToken`, and `docs/transcription.md` line 37 says a second pass takes the signature from `lookup.py sig`. | A splice takes the table's signature when the hand stub is stale, and the brief says so. |
| R2 | Eighteen holes name `Com_Printf` or `Com_Error`, which no module JKAShared imports declares. | The shared module gets its error and print channel before the next shared stem. |
| R3 | Twelve holes name `com_token`, `com_lines`, or `com_parsename`, which no `GameWorld` property declares, and the draft spells them bare while the file's rule 3 note says `world.`. | The three parser globals get their home, and the drafter spells a shared file-scope variable by that home. |
| R4 | Four holes name `BIG_INFO_STRING`, which `merge.py` placed in `CJKAMP` and not where JKAShared sees it. | The placement of the `q_shared.h` constants that shared bodies read is ruled for `merge.py`. |
| R5 | Fifteen holes walk a `CharBuf` parameter as a C pointer, a drafter defect in one shape. | The drafter gets a shape rule for a `char *` parameter the body steps, and no hand fix lands in the file. |
| R6 | Two holes index a `String` as a char array, and three return the parameter under a void signature, and two keep an `Int32` where the type is `Int` or `CChar`, three drafter defects in three shapes. | The three shapes go to the drafter as shape rules. |
| R7 | The compile agent's 58 holes carry the bare compiler message as the Port-note and the drafted Swift as the `Raven wrote:` line, where the tool's compile hole carries the `COMPILE_NOTE` sentence and Raven's C. | A hand compile hole takes the tool's two line texts, and the 58 are redone to that form or left as they stand by a ruling. |
| R8 | Fifteen compound conversions absorbed six drafter holes into comment text, so a grep of `portMissing` counts 189 where the file holds 183 calls. | A hole count reads the calls and not the text, and the record states the absorbed six. |
| R9 | `q_shared` never passed `draftcheck.py`, because the gate covers bg and game stems only, so the compile agent did by hand what the gate does by rule. | `draftcheck.py` gains the shared stems before another shared stem splices. |
