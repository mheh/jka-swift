# The q_shared hole round

The builder ran the q_shared hole round in the main checkout on the branch `wave-0`, from `f7f9f6f`. The hand file is `Sources/JKAShared/q_shared.c.swift`. The builder did not run `merge.py`, `tables.py`, `traps.py`, `channel.py`, `reexport.py`, `manifest.py`, or `skeleton.py`.

## Step 1. The re-splice

The gate. `draftcheck.py --stem q_shared` gave 51 of 56 hand functions replaced, 5 kept, 151 holes, 0 cascade errors, 0 defects, and 14 compile holes over 2 passes. These figures equal the reference. The gate kept `Q_stricmpn`, `Q_strncmp`, `Q_stricmp`, `va`, and `Q_strncpyz`.

The print. `printer.py --stem q_shared --compile-holes` stopped on stale lowered rows. After `bodies.py --stem q_shared --compile-holes` reset the rows, the printer printed the stem, but its text held none of the 14 compile holes. The other agent had changed `tools/oracle-closure/rulings.py` in the working tree after the gate, so the lowering key changed and the store found no rejected rows under the new key. The text of the printer and the draft file `.build-draft/drafts/q_shared.swift` differ only at those 14 statements, so the builder took the draft file as the print.

The splice. A script keyed on the `/// Source:` lines compared each hand function with its draft. The 51 replaced functions were equal to their drafts. `Q_strncpyz` was the draft of the last splice, with the two compile holes of that splice written in by hand, so `align.py` marked its lines `edited`. As the g_main re-splice did for `vmMain`, the builder took the new draft of `Q_strncpyz` and kept the four hand functions. The second `draftcheck.py --stem q_shared` built that draft and made its two statements compile holes again. The script spliced the second draft file. The splice kept every signature line, every forward, and Raven's inline comments. Against `f7f9f6f`, the net change is one `Raven wrote:` line of `Q_strncpyz`, which now matches the form of the gate.

The align run. `bodies.py --stem q_shared` without `--compile-holes` lowered the line rows. `align.py --stem q_shared` deleted 51 draft lines of the stored map and gave this line:

- q_shared: 1065 same, 8 edited, 79 hand, 5 rewritten, 0 stub

The gate. `swift build` gave 0 errors. `swift test --no-parallel` passed the binaries of 78, 14, and 13 tests. The smoke test "the loaded module answers GAME_INIT with the init line through G_PRINT" failed with `Fatal error: TODO: Port G_InitGame, source: oracle/codemp/game/g_main.c:897`, the `srand` hole of row R1 in `g_main-rulings-build.md`. The last `draftcheck.py --stem q_shared` gave 52 of 56 hand functions replaced, 4 kept, 153 holes, 0 cascade errors, 0 defects, and 16 compile holes over 2 passes. The store holds 52 splice rows for `q_shared.c.swift`, and each row matches its hand body.

Finding: the kept count fell from 5 to 4. The hand body of `Q_strncpyz` held the two hand conversions of the last re-splice, so its hash matched no row of the splices table, and the gate kept it. With the new draft spliced, its row exists and it is a replaced function again. The four kept functions are the hand functions `Q_stricmpn`, `Q_strncmp`, `Q_stricmp`, and `va`.

## Step 2. The hole round

The fills. The builder filled 99 Port-notes by hand under the forms of `docs/transcription.md`, in 17 functions. 14 functions lost every hole: `COM_SkipPath`, `COM_StripExtension`, `COM_DefaultExtension`, `Long64Swap`, `FloatSwap`, `FloatNoSwap`, `SkipWhitespace`, `COM_Compress`, `COM_ParseExt`, `SkipRestOfLine`, `Q_strrchr`, `Info_NextPair`, and the two `Info_RemoveKey` functions, which keep only the `ERR_DROP` compile hole. In `COM_ParseError`, `COM_ParseWarning`, and `Com_sprintf`, the `va_list` declaration, `va_start`, and `va_end` dropped, and the `vsprintf` hole stays with a note that names the gap. `COM_DefaultExtension` carries the note of rule 19 for an empty path. `Info_RemoveKey` and `Info_RemoveKey_Big` take back Raven's inline comment `// remove this part`. No fill adds a cast Raven did not write.

The gate. `swift build` gave 0 errors. `swift test --no-parallel` passed the binaries of 78, 14, and 13 tests. The smoke test failed with `Fatal error: TODO: Port G_LogWeaponInit, source: oracle/codemp/game/g_log.c:108`. The other agent's commits `4b7fac1` and `fb9ae24` and its fill in the working tree moved the smoke test past `G_InitGame`, and its record holds the same failure. `draftcheck.py --stem q_shared` gave 35 of 56 hand functions replaced, 21 kept, 147 holes, 0 cascade errors, 0 defects, and 10 compile holes over 2 passes. The 17 filled functions are now hand functions, so the kept count rose by 17. `align.py` reports `FloatSwap`, `COM_Compress`, and `Info_NextPair` as rewritten, beside `va`.

## The commits

The builder made no commit. Each step's gate failed on the smoke test during the round. Each failure is a `portMissing` call outside `q_shared.c.swift`, and the point of failure moved with the other agent's work.

The cause was the uncommitted dispatch fill in `jampgame.swift`. The gate passed with 106 tests when the fill was set aside, for both steps.

The re-splice is commit `b9caaaa`. The hole fills are commit `ff7f2b2`.

## The counts

| Point | Holes | Compile holes | Replaced | Kept | Port-notes | `portMissing` lines |
| --- | --- | --- | --- | --- | --- | --- |
| Before, the first draftcheck | 151 | 14 | 51 of 56 | 5 | 145 | 141 |
| After step 1 | 153 | 16 | 52 of 56 | 4 | 145 | 141 |
| After step 2 | 147 | 10 | 35 of 56 | 21 | 46 | 42 |

The holes and the compile holes are the counts of the draft. The Port-notes and the `portMissing` lines are the counts of the hand file. Four Port-notes have no `portMissing` call: the notes of the hand functions `Q_stricmp`, `Q_stricmpn`, and `Q_strncmp`.

## The hole table

The table lists every Port-note of the hand file after step 1.

| Function | Reason | Verdict | Note |
| --- | --- | --- | --- |
| COM_SkipPath | A pointer local `char * last` with no view. | filled | `last` is the byte offset `Int32` into `pathname`, under the pointer rule of the C character buffer. |
| COM_SkipPath | A store into `last`, a local the draft left as a hole. | filled | `last` is the byte offset `Int32` into `pathname`, under the pointer rule of the C character buffer. |
| COM_SkipPath | A store into `last`, a local the draft left as a hole. | filled | `last` is the byte offset `Int32` into `pathname`, under the pointer rule of the C character buffer. |
| COM_SkipPath | A read of `last`, a local the draft left as a hole. | filled | `last` is the byte offset `Int32` into `pathname`, under the pointer rule of the C character buffer. |
| COM_StripExtension | A pointer dereference the draft cannot place. | filled | `*out++ = *in++` is the write at `outIndex`, its step, and `in.advance()`. |
| COM_DefaultExtension | A pointer local `char * src` with no view. | filled | `src` is the byte offset `strlen(path) - 1`, and `src != path` is `src != 0`. |
| COM_DefaultExtension | A store into `src`, a local the draft left as a hole. | filled | `src` is the byte offset `strlen(path) - 1`, and `src != path` is `src != 0`. |
| COM_DefaultExtension | A pointer dereference the draft cannot place. | filled | `src` is the byte offset `strlen(path) - 1`, and `src != path` is `src != 0`. |
| Long64Swap | A local `qint64 result` the table has no type for. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| Long64Swap | A read of `result`, a local the draft left as a hole. | filled | The body swaps with `byteSwapped`, the form of the byte-swap pair. |
| FloatSwap | A pointer local `const _FloatByteUnion * in` with no view. | filled | The body reads `bitPattern` and swaps it with `byteSwapped`, the form of the byte-swap pair. |
| FloatSwap | A local `_FloatByteUnion out` the table has no type for. | filled | The body reads `bitPattern` and swaps it with `byteSwapped`, the form of the byte-swap pair. |
| FloatSwap | A store into `in`, a local the draft left as a hole. | filled | The body reads `bitPattern` and swaps it with `byteSwapped`, the form of the byte-swap pair. |
| FloatSwap | A read of `out`, a local the draft left as a hole. | filled | The body reads `bitPattern` and swaps it with `byteSwapped`, the form of the byte-swap pair. |
| FloatSwap | A read of `out`, a local the draft left as a hole. | filled | The body reads `bitPattern` and swaps it with `byteSwapped`, the form of the byte-swap pair. |
| FloatNoSwap | A pointer dereference the draft cannot place. | filled | A pointer to a const scalar is the scalar by value, so `*f` is `f`. |
| COM_ParseError | A pointer local `va_list argptr` with no view. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| COM_ParseError | A read of `argptr`, a local the draft left as a hole. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| COM_ParseError | A read of `argptr`, a local the draft left as a hole. | stands | The guide has no form for `vsprintf` into a buffer. The note now says so. See D2. |
| COM_ParseError | A read of `argptr`, a local the draft left as a hole. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| COM_ParseWarning | A pointer local `va_list argptr` with no view. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| COM_ParseWarning | A read of `argptr`, a local the draft left as a hole. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| COM_ParseWarning | A read of `argptr`, a local the draft left as a hole. | stands | The guide has no form for `vsprintf` into a buffer. The note now says so. See D2. |
| COM_ParseWarning | A read of `argptr`, a local the draft left as a hole. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| SkipWhitespace | A pointer dereference the draft cannot place. | filled | The store in the `while` test lifts to `while true` with a break, and `return NULL` is `TextCursor()`. |
| COM_Compress | A pointer local `char * in` with no view. | filled | `in` and `out` are byte offsets into `data_p`, `out` is a write cursor, and `out - data_p` is `out`. |
| COM_Compress | A pointer local `char * out` with no view. | filled | `in` and `out` are byte offsets into `data_p`, `out` is a write cursor, and `out - data_p` is `out`. |
| COM_Compress | A store into `in`, a local the draft left as a hole. | filled | `in` and `out` are byte offsets into `data_p`, `out` is a write cursor, and `out - data_p` is `out`. |
| COM_Compress | A read of `in`, a local the draft left as a hole. | filled | `in` and `out` are byte offsets into `data_p`, `out` is a write cursor, and `out - data_p` is `out`. |
| COM_Compress | A pointer dereference the draft cannot place. | filled | `in` and `out` are byte offsets into `data_p`, `out` is a write cursor, and `out - data_p` is `out`. |
| COM_Compress | A read of `out`, a local the draft left as a hole. | filled | `in` and `out` are byte offsets into `data_p`, `out` is a write cursor, and `out - data_p` is `out`. |
| COM_ParseExt | A pointer local `const char * data` with no view. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A store into `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A store into `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | The draft of this statement did not compile, and the compiler wrote "cannot convert return expression of type 'CharBuf' to return type 'String'". | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A pointer dereference the draft cannot place. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A pointer dereference the draft cannot place. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | The draft of this statement did not compile, and the compiler wrote "cannot convert return expression of type 'CharBuf' to return type 'String'". | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A pointer dereference the draft cannot place. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | A read of `data`, a local the draft left as a hole. | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_ParseExt | The draft of this statement did not compile, and the compiler wrote "cannot convert return expression of type 'CharBuf' to return type 'String'". | filled | `data` is a read cursor, a `TextCursor`, and `*data_p = data` is the store back into the parameter. |
| COM_MatchToken | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| SkipRestOfLine | A pointer local `const char * p` with no view. | filled | `p` is a read cursor, and the store in the `while` test lifts to `while true` with a break. |
| SkipRestOfLine | A store into `p`, a local the draft left as a hole. | filled | `p` is a read cursor, and the store in the `while` test lifts to `while true` with a break. |
| SkipRestOfLine | A pointer dereference the draft cannot place. | filled | `p` is a read cursor, and the store in the `while` test lifts to `while true` with a break. |
| SkipRestOfLine | A read of `p`, a local the draft left as a hole. | filled | `p` is a read cursor, and the store in the `while` test lifts to `while true` with a break. |
| Parse2DMatrix | The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type '[Float]'". | blocked | The guide's form `m[i * x ..< i * x + x]` needs a subscript over an `Int32` range. See D5. |
| Parse3DMatrix | The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type '[Float]'". | blocked | The guide's form `m[i * x ..< i * x + x]` needs a subscript over an `Int32` range. See D5. |
| Q_strrchr | A pointer local `char * s` with no view. | filled | `s` and `sp` are byte offsets into a `CharBuf` copy of `string`, and `sp` is nil for Raven's NULL. |
| Q_strrchr | A pointer local `char * sp` with no view. | filled | `s` and `sp` are byte offsets into a `CharBuf` copy of `string`, and `sp` is nil for Raven's NULL. |
| Q_strrchr | A store into `s`, a local the draft left as a hole. | filled | `s` and `sp` are byte offsets into a `CharBuf` copy of `string`, and `sp` is nil for Raven's NULL. |
| Q_strrchr | A pointer dereference the draft cannot place. | filled | `s` and `sp` are byte offsets into a `CharBuf` copy of `string`, and `sp` is nil for Raven's NULL. |
| Q_strrchr | A store into `sp`, a local the draft left as a hole. | filled | `s` and `sp` are byte offsets into a `CharBuf` copy of `string`, and `sp` is nil for Raven's NULL. |
| Q_strrchr | A read of `sp`, a local the draft left as a hole. | filled | `s` and `sp` are byte offsets into a `CharBuf` copy of `string`, and `sp` is nil for Raven's NULL. |
| Q_strncpyz | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_FATAL' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Q_strncpyz | The draft of this statement did not compile, and the compiler wrote "extra argument 'at' in call". | stands | `CString.swift` has no `strncpy` with an `at:` offset. See D3. |
| Q_stricmpn | Raven returns 0, -1, or 1 here for a NULL s1 or a NULL s2. A `String` is non-optional, so the guard has no Swift form. | stands | A note of a kept hand function, with no `portMissing` call. See D9. |
| Q_stricmpn | A C `char` is signed on the target build, so a byte above 127 reads as a negative int. The port keeps that sign. | stands | A note of a kept hand function, with no `portMissing` call. See D9. |
| Q_strncmp | A C `char` is signed on the target build, so a byte above 127 reads as a negative int. The port keeps that sign. | stands | A note of a kept hand function, with no `portMissing` call. See D9. |
| Q_stricmp | Raven returns -1 when s1 or s2 is NULL. A `String` is non-optional, so the guard has no Swift form. | stands | A note of a kept hand function, with no `portMissing` call. See D9. |
| Q_strlwr | A pointer local `char * s` with no view. | stands | The write offset form applies, but `tolower` and `toupper` have no home in `JKAShared`. See D7. |
| Q_strlwr | A store into `s`, a local the draft left as a hole. | stands | The write offset form applies, but `tolower` and `toupper` have no home in `JKAShared`. See D7. |
| Q_strlwr | A pointer dereference the draft cannot place. | stands | The write offset form applies, but `tolower` and `toupper` have no home in `JKAShared`. See D7. |
| Q_strupr | A pointer local `char * s` with no view. | stands | The write offset form applies, but `tolower` and `toupper` have no home in `JKAShared`. See D7. |
| Q_strupr | A store into `s`, a local the draft left as a hole. | stands | The write offset form applies, but `tolower` and `toupper` have no home in `JKAShared`. See D7. |
| Q_strupr | A pointer dereference the draft cannot place. | stands | The write offset form applies, but `tolower` and `toupper` have no home in `JKAShared`. See D7. |
| Q_strcat | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_FATAL' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Q_strcat | The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'CharBuf'". | stands | The guide has no form for `Q_strncpyz` through a pointer into the buffer. See D4. |
| Q_PrintStrlen | A pointer local `const char * p` with no view. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_PrintStrlen | A store into `p`, a local the draft left as a hole. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_PrintStrlen | A pointer dereference the draft cannot place. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_CleanStr | A pointer local `char * d` with no view. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_CleanStr | A pointer local `char * s` with no view. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_CleanStr | A store into `s`, a local the draft left as a hole. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_CleanStr | A store into `d`, a local the draft left as a hole. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_CleanStr | A pointer dereference the draft cannot place. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Q_CleanStr | A pointer dereference the draft cannot place. | blocked | The offset form needs `Q_IsColorString(_:at:)` to take an `Int32` offset. It takes an `Int`. See D6. |
| Com_sprintf | A pointer local `va_list argptr` with no view. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| Com_sprintf | A read of `argptr`, a local the draft left as a hole. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| Com_sprintf | A read of `argptr`, a local the draft left as a hole. | stands | The guide has no form for `vsprintf` into a buffer. The note now says so. See D2. |
| Com_sprintf | A read of `argptr`, a local the draft left as a hole. | filled | `va_start` and `va_end` go with the variadic form, so the line drops. |
| Com_sprintf | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_FATAL' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Info_ValueForKey | A local `char[2][8192] value` the table has no type for. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A static local `valueindex` a statement reads before it writes, storage that outlives the call. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A pointer local `char * o` with no view. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Info_ValueForKey | A store into `valueindex`, a local the draft left as a hole. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A store into `o`, a local the draft left as a hole. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A pointer dereference the draft cannot place. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A pointer dereference the draft cannot place. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A store into `o`, a local the draft left as a hole. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A pointer dereference the draft cannot place. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A pointer dereference the draft cannot place. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_ValueForKey | A read of `value`, a local the draft left as a hole. | stands | `o` writes into the static `value[valueindex]`, and the guide gives a static local of `JKAShared` no home. See D8. |
| Info_NextPair | A pointer local `char * o` with no view. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A pointer local `const char * s` with no view. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A store into `s`, a local the draft left as a hole. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A pointer dereference the draft cannot place. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A store into `o`, a local the draft left as a hole. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A pointer dereference the draft cannot place. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A pointer dereference the draft cannot place. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A read of `s`, a local the draft left as a hole. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A store into `o`, a local the draft left as a hole. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A pointer dereference the draft cannot place. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A pointer dereference the draft cannot place. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_NextPair | A read of `s`, a local the draft left as a hole. | filled | `s` is a read cursor over `head`, and `o` is the write offset into `key` and then into `value`. |
| Info_RemoveKey | A pointer local `char * start` with no view. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A pointer local `char * o` with no view. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Info_RemoveKey | A store into `start`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A store into `o`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A store into `o`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey | A read of `start`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A pointer local `char * start` with no view. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A pointer local `char * o` with no view. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Info_RemoveKey_Big | A store into `start`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A store into `o`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A store into `o`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A pointer dereference the draft cannot place. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_RemoveKey_Big | A read of `start`, a local the draft left as a hole. | filled | `start` and `o` are byte offsets, and `strcpy(start, s)` is `strcpy(&s, String(s[sIndex...]), at: start)`. |
| Info_SetValueForKey | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |
| Info_SetValueForKey_Big | The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope". | blocked | This call needs the `errorParm_t` constants in `JKAShared`. `ERR_DROP` and `ERR_FATAL` are in `JKAMP`. See D1. |

This round ruled 145 Port-notes: 99 filled, 26 stands, and 20 blocked.

## Docket

| Row | Item | Proposed |
| --- | --- | --- |
| D1 | Nine `Com_Error` calls name `ERR_DROP` or `ERR_FATAL`, in `COM_MatchToken`, `Q_strncpyz`, `Q_strcat`, `Com_sprintf`, `Info_ValueForKey`, the two `Info_RemoveKey` functions, and the two `Info_SetValueForKey` functions. The constants of `errorParm_t` are in `Sources/JKAMP/Generated/q_shared.swift`, and `JKAShared` cannot import `JKAMP`. | The reexport writes `errorParm_t` and its cases into `JKAShared`, then a re-splice takes the nine drafted calls. |
| D2 | `vsprintf(buf, fmt, argptr)` in `COM_ParseError`, `COM_ParseWarning`, and `Com_sprintf`. The guide drops `va_start` and `va_end` but gives no form for the formatted write into a buffer. | A guide form `strcpy(&buf, JKAShared.format(fmt, args))`, with `String(format)` for the `CharBuf` format of the two parse functions, and `len = strlen(buf)` for the count `Com_sprintf` reads. |
| D3 | `strncpy(dest, src, destsize-1)` in `Q_strncpyz` drafts as `strncpy(&dest, src, destsize - 1, at: destIndex)`, and `CString.swift` has no `strncpy` with an `at:` offset. | A `strncpy(_:_:_:at:)` overload in `CString.swift` beside the `at:` forms of `strcpy` and `strcat`. |
| D4 | `Q_strncpyz(dest + l1, src, size - l1)` in `Q_strcat` passes a pointer into the buffer, and `Q_strncpyz` has no `at:` form. | A hand overload `Q_strncpyz(_:_:_:at:)` in the shape of the hand `Q_strcat(_:_:_:at:)`, and the call `Q_strncpyz(&dest, src, size - l1, at: l1)`. |
| D5 | `Parse2DMatrix` and `Parse3DMatrix`. The guide's form copies a row-sized local into `m[i * x ..< i * x + x]`, but `Array` has no subscript over an `Int32` range and no `Int32` count for the local. | A range subscript over any integer range and an `init(repeating:count:)` that takes any integer, both in `Int32Indexing.swift`, then the guide's form. |
| D6 | `Q_PrintStrlen` and `Q_CleanStr` call `Q_IsColorString(p)` through a pointer, and `Q_IsColorString(_:at:)` in `q_shared.h.swift` takes an `Int`. The guide's offset is an `Int32`. | `Q_IsColorString(_:at:)` takes any integer offset, then the two bodies take the byte offset form. |
| D7 | `Q_strlwr` and `Q_strupr` call `tolower` and `toupper`, which have no home in `JKAShared`. | `tolower` and `toupper` over `Int32` in `CString.swift`, with C's semantics in the C locale, then the two bodies take the write offset form. |
| D8 | `Info_ValueForKey` returns `value[valueindex]`, a static `char value[2][BIG_INFO_VALUE]` with a static index. The static-local rule names `GameWorld`, which `JKAShared` cannot see. | The form of `va`: the function returns a `String`, so `value` is one local `CharBuf(BIG_INFO_VALUE)`, `valueindex` drops, and one comment line says why. |
| D9 | Four Port-notes of the kept hand functions `Q_stricmp`, `Q_stricmpn`, and `Q_strncmp` carry no `portMissing` call. Two name a NULL guard on a `String`, and two name the sign of a `char`. | Under "Engine memory through views", a body drops a NULL guard on a non-optional value with no comment, so the two guard notes go. The two sign notes become plain comments, because the body keeps C's sign. |
