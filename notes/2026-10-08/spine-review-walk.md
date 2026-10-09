# The spine review walk, rulings of 2026-10-08

The docket is the last section of `notes/2026-10-08/spine-review.md`, rows R1 to R9. The user handed the rows to the Fable delegate, who proved each row against the worktree `.claude/worktrees/spine` at `fbb6043`, the main checkout at `dbef991`, `docs/transcription.md`, `docs/oracle-closure.md`, the modules under `tools/oracle-closure/`, and the earlier walks. A row marked "ratified" takes the review's proposed ruling as written. A replaced row carries its full text here, and that text is the ruling. A parked row names the reason and the smaller thing the proof supports.

## R1. The four stale hand signatures

The question. The writer kept four hand signatures of `q_shared.c.swift` that differ from the table, `GetStringForID`, `ShortSwap`, `ShortNoSwap`, and `COM_MatchToken`, and `docs/transcription.md` line 37 says a second pass takes the signature from `lookup.py sig`. The proposed ruling: a splice takes the table's signature when the hand stub is stale, and the brief says so.

The proof. `lookup.py sig` on the main checkout gives `ShortSwap(_ l: Int32) -> Int32`, `ShortNoSwap(_ l: Int32) -> Int32`, `COM_MatchToken(_ buf_p: inout JKAShared.TextCursor, _ match: String)`, and `GetStringForID(...) -> String?`, and `.claude/manifest/q_shared.md` lines 11, 17, 18, and 37 spell the same four. The worktree file holds `GetStringForID` at line 32 in the table's spelling, after the compile agent's change, and `ShortSwap` at line 144, `ShortNoSwap` at line 157, and `COM_MatchToken` at line 580 in the stale spelling. `docs/transcription.md` line 37 and line 73 both bind, the signature is the generated one and a second pass reads it from the lookup tool, not from the adopted file. A grep of `Sources/` finds no caller of the four outside `q_shared.c.swift`. The printed draft at `/tmp/spine/spine-q_shared.swift` lines 132-140 holds a `ShortSwap` body that compiles under the `Int32` signature, and `strcmp(_ a: String, _ b: String)` at `Sources/JKAShared/CString.swift:367` takes the `COM_MatchToken` body under a `String` parameter.

The ruling. Ratified. The three remaining stale lines take the table's spelling now, because no caller stands and the cost is three signature lines: `ShortSwap` and `ShortNoSwap` take and return `Int32`, and `COM_MatchToken` takes `match` as `String`. The `ShortSwap` body goes back in from the printed draft, because its one hole was the stale signature and not the draft. The gate is `swift build` and `swift test --no-parallel` in the spine worktree, and the writer brief of every later round carries the line that the splice takes the signature of `lookup.py sig`.

## R2. The eighteen holes on `Com_Printf` and `Com_Error`

The question. Eighteen holes name `Com_Printf` or `Com_Error`, which no module JKAShared imports declares. The proposed ruling: the shared module gets its error and print channel before the next shared stem.

The proof. `Com_Error` and `Com_Printf` exist at `Sources/JKAMP_BG/bg_local.swift:357` and `:367`, internal, and at `Sources/JKAMP_GameLogic/g_main.swift:628` and `:634`, public. `Sources/JKAShared/` imports `Foundation` only, and `Package.swift` line 34 gives JKAShared the dependencies `CJKAShared` and `CJKASyscall`, so no route up to the game exists. The bg module's shape under rule 23 of `docs/porting-rules.md` is `BgState` at `bg_local.swift:18`, with the closures `error: (Int32, String) -> Never` at line 23 and `print: (String) -> Void` at line 29, and the two functions forward to them. The shared module has no state object and no closure. The two shared stems are `q_math` and `q_shared`, by `target_of` at `tools/oracle-closure/skeleton.py:75-79`, and `q_math.swift` is hand-ported under rule 13, so no next shared stem comes.

The ruling. Ratified, with the timing clause replaced: the shared module gets its error and print channel before the re-splice of `q_shared` that R7 and R9 order, in the bg shape. A new hand file `Sources/JKAShared/Channel.swift` holds one state object with the closures `error: (Int32, String) -> Never` and `print: (String) -> Void`, a default that traps with the text, and the public functions `Com_Error` and `Com_Printf` that forward to them with the `format` of `Format.swift`. The game installs the two closures where it installs the bg channel, and the gate is `swift build` and `swift test --no-parallel`.

## R3. The three parser globals

The question. Twelve holes name `com_token`, `com_lines`, or `com_parsename`, which no `GameWorld` property declares, and the draft spells them bare while the file's rule 3 note says `world.`. The proposed ruling: the three parser globals get their home, and the drafter spells a shared file-scope variable by that home.

The proof. The head of the worktree file, lines 1-14, carries three `TODO: Port global` markers whose note reads "a stored property of GameWorld ... spelled world.com_token in a body". `GameWorld` lives in `Sources/JKAMP_GameLogic/g_local.swift`, two modules above JKAShared, so that note names a home the shared module cannot see. The current `skeleton.py:736-738` writes a different note for a SHARED stem, "a stored property of the shared module's owner", so the file's note is older than the skeleton and names no home either. The precedent is `Sources/JKAShared/q_math.swift:1102-1105`, where Raven's `static unsigned long holdrand` is a file-scope `public nonisolated(unsafe) var rng = Rng()` with a doc line, and `docs/transcription.md` line 385 cites that same variable as the rule 3 example. The only other `com_token` in `Sources/` is a local of `g_spawn.swift:485`, which no file-scope name in JKAShared touches. `MAX_TOKEN_CHARS` is visible in JKAShared at `Generated/q_shared.swift:31`. The draft spells the three names bare, which is the spelling a file-scope variable of the same file takes.

The ruling. Replaced. The home is the stub itself, in the `rng` shape: the three markers at the head of `Sources/JKAShared/q_shared.c.swift` become `private nonisolated(unsafe) var com_token = CharBuf(MAX_TOKEN_CHARS)`, `private nonisolated(unsafe) var com_parsename = CharBuf(MAX_TOKEN_CHARS)`, and `private nonisolated(unsafe) var com_lines: Int32 = 0`, each under its `/// Source:` line, private because Raven wrote `static`. The drafter's bare spelling is right and stays. The drafter item is the note: `skeleton.py` writes the rule 3 note of a SHARED state variable as "a file-scope variable of this stub at Raven's line, the `rng` shape of q_math", so the next shared stub names its home. The gate is `swift build` and `swift test --no-parallel`.

## R4. The four holes on `BIG_INFO_STRING`

The question. Four holes name `BIG_INFO_STRING`, which `merge.py` placed in `CJKAMP` and not where JKAShared sees it. The proposed ruling: the placement of the `q_shared.h` constants that shared bodies read is ruled for `merge.py`.

The proof. `oracle/codemp/game/q_shared.h:388` defines `BIG_INFO_STRING`, and `oracle/code/game/q_shared.h` does not define it at all. `partition_shared` at `tools/oracle-closure/merge.py:467-476` makes a macro shared only when the MP and SP trees define it with the same code key, so the macro lands in the tree target by rule, at `Sources/CJKAMP/include/codemp/game/q_shared/constants.h:46` and `Sources/JKAMP/Generated/q_shared.swift:25`. The placement is not a defect of `merge.py`, it is the rule. Two fixes exist and each is a design choice: a hand `let BIG_INFO_STRING` in `Sources/JKAShared/q_shared.h.swift`, the hand home of `M_PI` and `DEG2RAD`, which then stands beside the `JKAMP` re-export of the same name and makes a use in a game body ambiguous, or an MP-only shared bin in `merge.py` for a tree macro that a shared `.c` body reads, which is a new partition rule. No game body reads `BIG_INFO_STRING` today.

The ruling. Parked. The proof shows the placement follows the rule as written, so no ruling for `merge.py` is a correction. The choice between a hand constant that shadows and a new partition rule is a design question for the user, four holes wait on it, and the game runs without them. The walk records the two fixes above as the open choice.

## R5. The fifteen holes that walk a `CharBuf` parameter as a pointer

The question. Fifteen holes walk a `CharBuf` parameter as a C pointer, a drafter defect in one shape. The proposed ruling: the drafter gets a shape rule for a `char *` parameter the body steps, and no hand fix lands in the file.

The proof. `bodies.py:280-284` opens a read cursor for a parameter the body writes only when its kind is `cstring`, the `const char *` case. A parameter of kind `inout_charbuf`, `pathname` of `COM_SkipPath` at worktree line 76, is in `self.inout_locals` and gets no cursor, so `cursor_deref` at `draft_classification.py:168-193` returns `None` for `*pathname`, and the draft prints `while pathname != 0` and `pathname += 1` from the printed draft lines 69-75. The `TextCursor` and `.byte` shapes exist, `text_cursor` at `draft_classification.py:153-159` and `cursor_deref` at `:190`, so the defect is one missing case, not a missing shape. The fifteen holes are all compares, steps, stores, and address-plus-offset forms on an `inout CharBuf` parameter, in `COM_SkipPath`, `COM_StripExtension`, `Q_strcat`, `Parse2DMatrix`, `Parse3DMatrix`, `Info_RemoveKey`, and `Info_RemoveKey_Big`.

The ruling. Ratified. The shape rule for the drafter: an `inout_charbuf` parameter the body steps or compares as a pointer walks a write cursor over the buffer, the `offset_cursors` shape, with its index declared at the head of the function. The owner is `bodies.py` at the cursor decision of lines 280-284, with the emit in `draft_classification.py`. No hand fix lands in `q_shared.c.swift`.

## R6. The three smaller drafter shapes

The question. Two holes index a `String` as a char array, three return the parameter under a void signature, and two keep an `Int32` where the type is `Int` or `CChar`, three drafter defects in three shapes. The proposed ruling: the three shapes go to the drafter as shape rules.

The proof. `COM_ParseString` at worktree line 492 takes `s` as `inout String`, the `out_string` kind, and its `s[0] == 0` is Raven's test of the pointer `s[0]`, where `empty_test` at `draft_expressions.py:226-252` serves a `cstring` and a `cstring_opt` kind only. `SkipBracedSection` at line 603 compares `token[1] == 0` on a `String` local by the same path. The `RETURN_STMT` arm at `draft_statements.py:463-470` reads `self.fn.returns` for `nil` and for a stepped value and never tests a void return, so `Q_strlwr`, `Q_strupr`, and `Q_CleanStr`, void over `inout CharBuf` at lines 884, 910, and 982, keep Raven's `return s1`. `COM_ParseVec4` at line 555 indexes `vec4_t`, which is `SIMD4<Float>` at `Views/Vectors.swift:7`, with an `Int32` local, and `SIMD4` takes `Int`, where the subscript arm at `draft_expressions.py:411-425` converts the index to `Int32` for cursors only. `Q_strrchr` at line 738 declares `let cc: CChar = c` from an `Int32` parameter through `declaration` at `draft_declarations.py:283`, with no conversion of the initializer.

The ruling. Ratified. Three shape rules go to the drafter: `draft_expressions.py` reads Raven's `s[0]` on an `out_string` parameter as a test of the string itself and `token[1]` on a `String` local through its bytes, `draft_statements.py` drops the value of a `return` in a function the table makes void, and `draft_expressions.py` converts the index of a `SIMD` vector to `Int` while `draft_declarations.py` converts the initializer of a narrow local from a wider parameter. No hand fix lands in the file.

## R7. The two line texts of the 58 hand compile holes

The question. The compile agent's 58 holes carry the bare compiler message as the Port-note and the drafted Swift as the `Raven wrote:` line, where the tool's compile hole carries the `COMPILE_NOTE` sentence and Raven's C. The proposed ruling: a hand compile hole takes the tool's two line texts, and the 58 are redone to that form or left as they stand by a ruling.

The proof. `layout.py:11` holds `COMPILE_NOTE`, "The draft of this statement did not compile, and the compiler wrote ...", and `printer.py:97-98` writes that sentence as the Port-note and the `statements` row's C text after `Raven wrote:`. Worktree lines 84-86 of `COM_SkipPath` show the agent's form: the bare message, then a `Raven wrote:` line that holds the drafted Swift `while pathname != 0 { ... }` with a `portMissing` call inside it. `docs/oracle-closure.md` section 5 says the compile holes of the last pass go to the `rejected` table and the printer puts the three lines in place of each rejected statement, so the tool reproduces every one of the 58 from the store once `draftcheck.py` runs over `q_shared`.

The ruling. Ratified for the rule, and the 58 stand as they are. A hand compile hole takes the tool's two texts, and no agent hand-writes one again. The 58 are not redone by hand, because R9 orders a `draftcheck.py` run over `q_shared` and a re-splice from `printer.py --compile-holes`, or from `bodies.py --compile-holes` on the functions the printer stops on, and that re-splice replaces all 58 with the tool's form by rule.

## R8. The six holes the compound conversions absorbed

The question. Fifteen compound conversions absorbed six drafter holes into comment text, so a grep of `portMissing` counts 189 where the file holds 183 calls. The proposed ruling: a hole count reads the calls and not the text, and the record states the absorbed six.

The proof. On the worktree file, `grep -c portMissing` gives 189, `grep -c '^[[:space:]]*portMissing('` gives 183, and `grep -c '^[[:space:]]*//.*portMissing'` gives 6, with no other line. The six stand inside `Raven wrote:` comments, as at line 85 of `COM_SkipPath`. The record `spine-round.md` says the whole compound became one hole and does not count the six.

The ruling. Ratified. A hole count of a file is the count of lines that start with `portMissing(` after indentation, never a plain grep of the word. The record gets one sentence after its hole list: the fifteen compound conversions carried six drafter holes into their `Raven wrote:` lines, so the file holds 183 calls and a plain grep counts 189.

## R9. The gate over the shared stem

The question. `q_shared` never passed `draftcheck.py`, because the gate covers bg and game stems only, so the compile agent did by hand what the gate does by rule. The proposed ruling: `draftcheck.py` gains the shared stems before another shared stem splices.

The proof. `draftcheck.py:199-216` takes `--stem` with any stem the skeleton holds, and adds `BG` for `--all` and `LOGIC` for `--game` and `--every`. `gate()` reads `stub_path(stem)`, which maps `q_shared` to `JKAShared/q_shared.c.swift` at `skeleton.py:68-72`, and nothing in the gate reads the target of the stem. So `draftcheck.py --stem q_shared` runs today, and only the three group flags leave `SHARED` out. The snapshot lowers the shared stems, by item 3 of the steps 8-10 walk. The two shared stems are `q_math` and `q_shared`, `q_math` is hand-ported under rule 13, so "another shared stem" never comes. The record says the compile agent did not run `align.py` and the worktree holds no store, so no gate ran on `q_shared` in the round.

The ruling. Replaced. `draftcheck.py` `--every` adds `SHARED` beside `BG` and `LOGIC`, and the usage lines at `draftcheck.py:21-23` and the `--every` help text say so, with the tool tests under `tools/oracle-closure/tests` as the gate. The round's gate on `q_shared` is `draftcheck.py --stem q_shared` on the spine branch after the R1, R2, and R3 changes land, and its counts go into the round's record as the shared reference beside the bg and game references of `docs/oracle-closure.md` section 10.

## Ledger

| Row | Verdict | Ruled by | Date |
|---|---|---|---|
| R1 | Ratified. The three remaining stale signatures take the table's spelling now, and the `ShortSwap` body returns from the printed draft. | Fable delegate | 2026-10-08 |
| R2 | Ratified, timing replaced: the channel lands before the re-splice of `q_shared`, in the bg shape, as a hand file `Sources/JKAShared/Channel.swift`. | Fable delegate | 2026-10-08 |
| R3 | Replaced. The home is the stub, three file-scope `private nonisolated(unsafe) var` lines in the `rng` shape, and the drafter's bare spelling stays. | Fable delegate | 2026-10-08 |
| R4 | Parked. The placement follows the merge rule, and the choice between a hand constant that shadows and a new partition rule is the user's. | Fable delegate | 2026-10-08 |
| R5 | Ratified. The shape rule names `bodies.py` lines 280-284 as the owner, with the emit in `draft_classification.py`. | Fable delegate | 2026-10-08 |
| R6 | Ratified. Three shape rules, owned by `draft_expressions.py`, `draft_statements.py`, and `draft_declarations.py`. | Fable delegate | 2026-10-08 |
| R7 | Ratified for the rule. The 58 stand until the R9 re-splice replaces them by rule. | Fable delegate | 2026-10-08 |
| R8 | Ratified. The count reads the calls, and the record gains one sentence on the six. | Fable delegate | 2026-10-08 |
| R9 | Replaced. `--every` adds `SHARED`, `--stem q_shared` already runs, and the shared reference goes into the record. | Fable delegate | 2026-10-08 |

## The work the rulings order

The code changes, for a later builder on branch `spine`, in this order.

1. `Sources/JKAShared/q_shared.c.swift`: the signature lines of `ShortSwap`, `ShortNoSwap`, and `COM_MatchToken` take the spelling of `lookup.py sig`, and the `ShortSwap` body is the printed draft at `/tmp/spine/spine-q_shared.swift` lines 133-139. Gate: `swift build` and `swift test --no-parallel`. (R1)
2. `Sources/JKAShared/Channel.swift`, new: one state object with the closures `error` and `print`, a trapping default, and the public functions `Com_Error` and `Com_Printf` that forward through `format`, with the game installing the closures beside `installBgChannel()`. Gate: `swift build` and `swift test --no-parallel`. (R2)
3. `Sources/JKAShared/q_shared.c.swift`: the three `TODO: Port global` markers at lines 1-14 become `private nonisolated(unsafe) var com_token = CharBuf(MAX_TOKEN_CHARS)`, `com_parsename` the same, and `com_lines: Int32 = 0`, each under its `/// Source:` line. Gate: `swift build` and `swift test --no-parallel`. (R3)
4. `tools/oracle-closure/draftcheck.py`: `--every` adds `SHARED` to the targets, and the usage and help texts name it. Gate: the tool tests. (R9)
5. `draftcheck.py --stem q_shared` on the main checkout's store after items 1 to 4 land, then a re-splice of `Sources/JKAShared/q_shared.c.swift` from `printer.py --compile-holes`, and from `bodies.py --compile-holes` on the functions the printer stops on, which replaces the 58 hand holes with the tool's form. Gate: `swift build`, `swift test --no-parallel`, and the gate's own counts. (R7, R9)
6. `notes/2026-10-08/spine-round.md`: one sentence after the hole list, that the fifteen compound conversions carried six drafter holes into their `Raven wrote:` lines, so the file holds 183 calls and a plain grep counts 189, and the counts of item 5 as the shared reference. (R8, R9)

The drafter items, each a shape rule in a lowering module.

1. `tools/oracle-closure/bodies.py`, lines 280-284: an `inout_charbuf` parameter the body steps or compares as a pointer walks a write cursor over the buffer, with its index declared at the head of the function, and `draft_classification.py` emits the reads and steps through it. (R5)
2. `tools/oracle-closure/draft_expressions.py`, `empty_test`: Raven's `s[0]` on an `out_string` parameter is a test of the string, and `token[1]` on a `String` local reads its byte. (R6)
3. `tools/oracle-closure/draft_statements.py`, the `RETURN_STMT` arm: a `return` with a value in a function the table makes void drops the value. (R6)
4. `tools/oracle-closure/draft_expressions.py`, the subscript arm, and `draft_declarations.py`, `declaration`: the index of a `SIMD` vector converts to `Int`, and the initializer of a narrow local from a wider parameter converts to the local's type. (R6)
5. `tools/oracle-closure/skeleton.py`, lines 736-738: the rule 3 note of a SHARED state variable names the home, a file-scope variable of the stub at Raven's line in the `rng` shape of q_math. (R3)

## The user's ruling on R4

| Row | Verdict | Ruled by | Date |
|---|---|---|---|
| R4, the four holes on `BIG_INFO_STRING` | Ratified as proposed. The placement of the `q_shared.h` constants that shared bodies read is ruled for `merge.py`. The fix is the partition rule, not a hand constant: a tree macro that a shared `.c` body reads goes where JKAShared sees it. The row leaves the parked state and joins the drafter round's docket beside the five drafter items and G1. | User | 2026-10-08 |

## The amendment of R4, 2026-10-09

| Row | Verdict | Ruled by | Date |
|---|---|---|---|
| R4, amended | Amended as proposed. The rule stands as ruled, and its reach is three macros: `BIG_INFO_STRING`, `BIG_INFO_KEY`, and `BIG_INFO_VALUE`, defined together at lines 388 to 390 of the MP `q_shared.h` and read together by the big-info functions of q_shared. The move lands them where JKAShared sees them, and the game module's re-export of the three names follows from one run of `reexport.py`, which a builder runs only when a rule changed, and this is such a change. The gate is `swift build` at 0 errors and `swift test --no-parallel` at 106 tests. A regenerate that moves any file beyond the three placements and their re-exports stops the item. The four holes of q_shared on these names go away at the next re-splice. | User | 2026-10-09 |
