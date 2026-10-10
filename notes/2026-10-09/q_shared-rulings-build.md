# The q_shared rulings build

The builder built the nine rulings of `q_shared-holes-walk.md`, Q1 to Q9, in the main checkout on the branch `wave-0`, from `f8ba6cd`. The hand file is `Sources/JKAShared/q_shared.c.swift`. The builder did not run `merge.py`, `tables.py`, `traps.py`, `channel.py`, `manifest.py`, or `skeleton.py`, and it did not change `rulings.py` or a drafter module.

## Step 1. The helpers

The builder added the helpers of Q3, Q5, Q6, and Q7.

- `CString.swift` has `strncpy(_:_:_:at:)`, which copies at most `n` bytes of a `String` from a byte offset and pads with NUL, in the shape of the `at:` forms of `strcpy` and `strcat`.
- `CString.swift` has `tolower` and `toupper` over `Int32`, with C's semantics in the C locale. Raven's own pair in `bg_lib.c` compiles only under `Q3_VM`, so the two functions carry no `/// Source:` line.
- `Views/Int32Indexing.swift` gives `Array` a subscript over a `Range` of any integer and an `init(repeating:count:)` that takes any integer. The brief named `Int32Indexing.swift` in `Sources/JKAShared/`, and the file is in `Sources/JKAShared/Views/`.
- `Q_IsColorString(_:at:)` in `q_shared.h.swift` is generic over `BinaryInteger`. The callers in `HeaderMacroTests.swift` and `ai_main.swift` compile with no change.

The new file `Tests/JKASharedTests/QSharedHelperTests.swift` holds six tests.

The gate. `swift build` gave 0 errors. `swift test --no-parallel` passed 112 tests in four binaries: 84, 14, 13, and 1. The commit is `801da13`.

## Step 2. The reexport and the guide

The builder ran `reexport.py --probe`. The run wrote 635 declarations for `JKAShared`, 4002 for `JKAMP`, and 1372 for `JKAMP_Game`, and it ended with 42 macros spelled as Swift expressions, 0 narrowed, and 0 marked. After the run, `git status --short` showed no change to a generated file, so the probed spellings stayed and no file moved.

Finding: the run did not bring `errorParm_t` into `JKAShared`. `reexport.py` writes the enums of each C target's own headers, and `merge.py` put `errorParm_t` in `CJKAMP`, at `Sources/CJKAMP/include/codemp/game/q_shared/errorParm_t.h`. The merge sends to `CJKAShared` only a type that both trees define the same, and the SP tree declares `errorParm_t` without `ERR_SERVERDISCONNECT`, at `oracle/code/game/q_shared.h:251`. So ruling Q1 needs a change outside the reexport. See R1 below.

The builder wrote the two guide forms in `docs/transcription.md`. The form of Q2 is in the section "C string functions", after the lines on `va`. The form of Q8 is in the section "A file-scope static or a static local", after the static-local rule.

The gate. `swift build` gave 0 errors. `swift test --no-parallel` passed 112 tests. The commit is `a3a1d6a`, with the subject "The two q_shared forms of the guide", because it holds no enum.

## Step 3. The re-splice and the fills

The gate. `draftcheck.py --stem q_shared` gave 35 of 56 hand functions replaced, 21 kept, 146 holes, 0 cascade errors, 0 defects, and 9 compile holes over 2 passes. The compile hole of `strncpy` in `Q_strncpyz` went, because the `at:` overload now exists.

The print. `printer.py --stem q_shared --compile-holes` first stopped, because the store held no line rows for `COM_MatchToken`. After `bodies.py --stem q_shared` lowered the rows, the printer printed the stem, and its text equals the draft file `.build-draft/drafts/q_shared.swift` except for the footer line.

The splice. A script keyed on the `/// Source:` lines compared each hand function with its print. The script kept the 17 hand-filled functions of the hole round and the four comparison functions `Q_stricmp`, `Q_stricmpn`, `Q_strncmp`, and `va`. Of the other functions, only `Q_strncpyz` differed from its print, so the splice changed only `Q_strncpyz`: its `strncpy` compile hole became `strncpy(&dest, src, destsize - 1, at: destIndex)`.

The align run. `align.py --stem q_shared` deleted 227 draft lines of the stored map and gave this line:

- q_shared: 746 same, 23 edited, 178 hand, 131 rewritten, 0 stub

The fills.

- Q2: `COM_ParseError` and `COM_ParseWarning` write `strcpy(&string, JKAShared.format(String(format), args))`. `Com_sprintf` writes `strcpy(&bigbuffer, JKAShared.format(fmt, args))` and `len = strlen(bigbuffer)`, with the note of rule 19 in one line: Raven's `vsprintf` overruns `bigbuffer` past 32000 bytes, and `strcpy` traps there.
- Q4: the hand overload `Q_strncpyz(_:_:_:at:)` stands after `Q_strupr`, in the shape of `Q_strcat(_:_:_:at:)`, and `Q_strcat` calls `Q_strncpyz(&dest, src, size - l1, at: l1)`.
- Q5: `Parse2DMatrix` fills a local `[Float](repeating: 0, count: x)` through `Parse1DMatrix` and copies it into `m[i * x ..< i * x + x]`. `Parse3DMatrix` does the same with a local of `x * y` floats.
- Q6: `Q_PrintStrlen` walks a byte offset `p` into a `CharBuf` copy of `string`. `Q_CleanStr` walks the offsets `s` and `d` into its buffer, and the store in the `while` test lifts to `while true` with a break.
- Q7: `Q_strlwr` and `Q_strupr` walk the offset `s` and write `tolower` or `toupper` of each byte.
- Q8: `Info_ValueForKey` writes into one local `CharBuf(BIG_INFO_VALUE)` and returns `String(value)`. `valueindex` dropped, and one comment line says why. Raven's two comment lines on `value` stay.
- Q9: the two NULL-guard notes of `Q_stricmp` and `Q_stricmpn` went. The two sign notes of `Q_stricmpn` and `Q_strncmp` are now plain comments, one sentence per line.

No fill adds a cast Raven did not write. The nine `Com_Error` calls stay holes, because `ERR_DROP` and `ERR_FATAL` are not in scope in `JKAShared`.

The gate. `swift build` gave 0 errors and no warning in `q_shared.c.swift`. `swift test --no-parallel` passed 112 tests. The last `draftcheck.py --stem q_shared` gave 27 of 56 hand functions replaced, 29 kept, 141 holes, 0 cascade errors, 0 defects, and 4 compile holes over 2 passes. The kept count rose by 8, the filled functions other than `Q_strncpyz`, whose body is still the spliced draft. The 4 compile holes are the `Com_Error` calls in the replaced functions `COM_MatchToken`, `Q_strncpyz`, `Info_SetValueForKey`, and `Info_SetValueForKey_Big`. The other five `Com_Error` calls are in kept functions. The commit is `3dd38bb`.

The other agent committed `0126e9f` and `6eb5718` during the round. No test outside `JKAShared` failed.

## The counts

| Point | Holes | Compile holes | Replaced | Kept | Port-notes | `portMissing` lines |
| --- | --- | --- | --- | --- | --- | --- |
| Before, the reference | 147 | 10 | 35 of 56 | 21 | 46 | 42 |
| After the re-splice | 146 | 9 | 35 of 56 | 21 | 45 | 41 |
| After the fills | 141 | 4 | 27 of 56 | 29 | 9 | 9 |

The holes and the compile holes are the counts of the draft. The Port-notes and the `portMissing` lines are the counts of the hand file. Each of the 9 Port-notes in the hand file is a `Com_Error` call, and each has its `portMissing` call.

## The commits

| Step | Commit |
| --- | --- |
| The helpers | `801da13` |
| The guide forms | `a3a1d6a` |
| The fills | `3dd38bb` |

## Docket

| Row | Item | Proposed |
| --- | --- | --- |
| R1 | Nine `Com_Error` calls name `ERR_DROP` or `ERR_FATAL`, in `COM_MatchToken`, `Q_strncpyz`, `Q_strcat`, `Com_sprintf`, `Info_ValueForKey`, the two `Info_RemoveKey` functions, and the two `Info_SetValueForKey` functions. The reexport cannot bring `errorParm_t` into `JKAShared`, because the merge keeps the enum in `CJKAMP`, and the SP tree declares it without `ERR_SERVERDISCONNECT`. | The guide's form for an enum that cannot reach its module: `private let ERR_FATAL: Int32 = 0` and `private let ERR_DROP: Int32 = 1` at the top of `q_shared.c.swift`, under the `/// Source:` line `oracle/codemp/game/q_shared.h:451`. Both trees give these two cases the same values. `private` keeps the names out of the files that import `JKAMP`. Then a hand fill of the nine calls. |
| R2 | `printer.py --stem q_shared --compile-holes` stops after a `draftcheck.py` run until `bodies.py --stem q_shared` lowers the line rows again. | Add `bodies.py --stem <stem>` before the print in the re-splice procedure of `g_main-resplice.md`. |
