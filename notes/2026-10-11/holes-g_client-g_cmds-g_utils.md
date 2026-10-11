# Hole round: g_client, g_cmds, g_utils

This record covers the Port-notes of `Sources/JKAMP_GameLogic/g_client.swift`, `Sources/JKAMP_GameLogic/g_cmds.swift`, and `Sources/JKAMP_GameLogic/g_utils.swift`.
The round filled 9 holes, left 9 holes as `stands`, and left 1 hole as `blocked`.

## g_client.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| ClientCleanName | `ColorIndex(*in)` did not compile, because `ColorIndex` takes a `CChar` and `in.byte` is an `Int32`. | blocked | The narrow-type rule makes a `char` parameter an `Int32`, so `ColorIndex` must take an `Int32`. That fix is an edit to `Sources/JKAShared/q_shared.h.swift`, which is outside the read set. The body must not add a cast that Raven did not write. |
| ClientSpawn | The chained store with the power-duel health formula timed out in the type checker. | stands | Each part has a form: the chain splits into three stores, the `(float)` casts stay as `Float(...)`, and the store into an `int` takes `Int32(...)`. The guide gives no form to break one expression into parts for the type checker. Docket row 1. |

## g_cmds.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| ConcatArgs | `memcpy( line + len, arg, tlen )` copies the text with no NUL into an offset of a buffer. | stands | The guide gives `strcpy` only for a `memcpy` of `l+1` bytes. Docket row 2. |
| SanitizeString | The `while ( *in )` loop did not compile. | stands | The pointer walk has a form, an `Int32` offset per buffer. The guide gives no home for `tolower` and no spelling for the `(unsigned char)` cast. Docket row 3. |
| SanitizeString | `*out = 0` did not compile. | filled | `out` is a write cursor, so the body declares `var outIndex: Int32 = 0` at the top and writes `out[outIndex] = 0`. The loop hole above must step `outIndex` when it is filled. Until then, the compiler warns that `outIndex` is never mutated. |
| G_SetSaber | The Port-note said that Swift holds one record for `ent->client->saber`. | filled | `lookup.py gclient_t saber` gives `saber: Slots<JKAMP.SaberInfo>`, so the Slots passes as it is: `WP_SetSaber(ent.s.number, ent.client!.saber, saberNum, String(truncSaberName))`. |
| Cmd_GameCommand_f | `sizeof(gc_orders)/sizeof(char *)` has no Swift size. | stands | `gc_orders` is a hand `[String]` of 7 rows. The guide gives no form for the element count of a hand table. Docket row 4. |
| Cmd_CallTeamVote_f | `trap_Argv` into `&arg2[strlen(arg2)]` did not compile. | filled | The trap-fill form and the `at:` form of `strcpy` give `strcpy(&arg2, trap_Argv(i, Int32((arg2).count) - strlen(arg2)), at: strlen(arg2))`. |
| Cmd_CallTeamVote_f | `Com_sprintf` into `level.teamVoteString[cs_offset]`, the `clientkick` arm. | filled | `teamVoteString` is a `Slots<String>`. The form for a slot with room past the text gives a local `CharBuf(1024)`, the `Com_sprintf` into it, and the store back into the slot. |
| Cmd_CallTeamVote_f | `Com_sprintf` into `level.teamVoteString[cs_offset]`, the `%s %s` arm. | filled | The same form as the arm above. |

## g_utils.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| BuildShaderStateConfig | `memset(buff, 0, MAX_STRING_CHARS)` zeroes a quarter of the `char buff[MAX_STRING_CHARS*4]`. | stands | The guide names this exact memset as one that keeps its Port-note. Docket row 5. |
| G_PickTarget | The local `gentity_t *choice[MAXCHOICES]` had no type. | filled | The form for a C array of struct pointers gives `var choice = [Entity?](repeating: nil, count: Int(MAXCHOICES))`. |
| G_PickTarget | `choice[num_choices++] = ent`, a `++` inside an expression. | filled | The read-then-step form of `*s1++` gives `choice[num_choices] = ent` and then `num_choices += 1`. |
| G_PickTarget | `return choice[rand() % num_choices]` read the hole local. | filled | Raven's line, now that `choice` exists. |
| vtos | The static local `char str[8][32]` had no type. | stands | The static-local form needs a Swift type for a two-dimensional `char` array, and the guide gives none. Docket row 6. |
| vtos | The pointer local `char *s` had no view. | stands | Docket row 6. |
| vtos | The store `s = str[index]`. | stands | Docket row 6. |
| vtos | The read of `s` in `Com_sprintf (s, 32, ...)`. | stands | Docket row 6. |
| vtos | The read of `s` in `return s`. | stands | Docket row 6. |

## GameWorld properties

None. The round filled no static local, so the coordinator adds no property to `g_local.swift`.

## Docket rows

1. ClientSpawn, g_client.c:3635. The type checker times out on `Int32 - (Int32 * Float / Float)` through the Promotion operators, and no form splits an expression. Proposed form: a hole that times out in the type checker takes a typed `let` local of the C type for each parenthesized term, in Raven's order, named for the term.
2. ConcatArgs, g_cmds.c:141. `memcpy(dest + len, src, strlen(src))` copies the text with no NUL, and the `strcpy` form covers only `l+1`. Proposed form: where a later store always ends the text, this copy is `strcpy(&line, arg, at: len)`, because the extra NUL is overwritten by `line[len] = ' '` or `line[len] = 0`.
3. SanitizeString, g_cmds.c:162. `tolower` has no listed home, and the `(unsigned char)` cast has no Swift spelling. Proposed form: `tolower` joins `Sources/JKAShared/CString.swift` with an `Int32` parameter and return, and `(unsigned char) c` is `Int32(UInt8(truncatingIfNeeded: c))`.
4. Cmd_GameCommand_f, g_cmds.c:1835. `sizeof(table)/sizeof(elem)` over a hand `[String]` table has no form. Proposed form: the count of a hand table is `table.count`, and the comparison with an `Int32` uses the heterogeneous integer comparison of Swift with no cast.
5. BuildShaderStateConfig, g_utils.c:44. A memset of zero over the first N bytes of a larger `CharBuf` has no form. Proposed form: a `CharBuf` method `zero(count:)` that zeroes the first N bytes, so the line reads `buff.zero(count: MAX_STRING_CHARS)`.
6. vtos, g_utils.c:655. A static `char str[8][32]` and a `char *s` that picks one row have no form. Proposed form: the static is a `GameWorld` property `str_vtos: [CharBuf]` of 8 `CharBuf(32)`, and `s` is a row index local `sIndex: Int32`, so the body writes `Com_sprintf(&str_vtos[sIndex], 32, ...)` and returns `String(str_vtos[sIndex])`.
