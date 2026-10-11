# Wave B hole round, transcriptor bot

This record covers the holes of `g_nav.swift`, `ai_wpnav.swift`, `ai_util.swift`, and `ai_main.swift` in `Sources/JKAMP_GameLogic/`. The line numbers are the lines of `wave-0` at 4308ee3, before the edit. No build and no test ran.

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_nav.swift` | 9 | 4 |
| `ai_wpnav.swift` | 9 | 0 |
| `ai_util.swift` | 4 | 4 |
| `ai_main.swift` | 3 | 0 |
| Total | 25 | 8 |

## The holes

| File:line before | Function | Row or guide line | Verdict |
|---|---|---|---|
| `g_nav.swift:348` | `NAV_ClearPathToPoint` | P1, guide line 540 | Filled. `if ((trace.startsolid == 0) && (trace.allsolid == 0)) && (trace.fraction == 1.0) {`, with Raven's `//FIXME: check for drops` and `return true` in the block. |
| `g_nav.swift:518` | `NAV_CheckAhead` | P1, guide line 540 | Filled. `if (trace.allsolid == 0) && (trace.startsolid == 0) && (trace.fraction == 1.0) { return true }`. |
| `g_nav.swift:793` | `NAV_StackedCanyon` | P1, guide line 540 | Filled. `if tr.startsolid == 0 && tr.allsolid == 0 { return false }`, Raven's line 790. |
| `g_nav.swift:806` | `NAV_StackedCanyon` | P1, guide line 540 | Filled. The same test, Raven's line 802. |
| `g_nav.swift:977` | `NAV_TestBestNode` | P1, guide line 540 | Filled. `if (trace.allsolid == 0) && (trace.startsolid == 0) && (trace.fraction == 1.0) {`, with Raven's `//it's clear` and `return endID`. |
| `g_nav.swift:1517` | `NAV_WaypointsTooFar` | none | Blocked. `(fatalErrorPointer-fatalErrorString)+len` needs `fatalErrorPointer` as an `Int32` offset. See the GameWorld properties section. |
| `g_nav.swift:1520` | `NAV_WaypointsTooFar` | none | Blocked, same cause. With the offset the line is `strcat(&fatalErrorString, String(temp), at: fatalErrorPointer)`. |
| `g_nav.swift:1523` | `NAV_WaypointsTooFar` | none | Blocked, same cause. With the offset the line is `fatalErrorPointer += len`. |
| `g_nav.swift:1601` | `NAV_CalculatePaths` | none | Blocked, same cause. With the offset the line is `fatalErrorPointer = 0`. |
| `ai_wpnav.swift:2127` | `SavePathData` | O2, guide line 622 | Filled. `var fileString = CharBuf(524288)`, the text of `bodies.py --stem ai_wpnav --only SavePathData`. |
| `ai_wpnav.swift:2138` | `SavePathData` | O2 | Filled. The `NULL` store drops under the drafter's comment, `// Raven wrote `fileString = NULL` here, and no read reaches it before the allocation.` |
| `ai_wpnav.swift:2170` | `SavePathData` | O2 | Filled. `_ = B_TempAlloc(524288)`. |
| `ai_wpnav.swift:2175` | `SavePathData` | O2 | Filled. `Com_sprintf(&fileString, 524288, "%i %i %f (%f %f %f) { ", ...)`. |
| `ai_wpnav.swift:2199` | `SavePathData` | O2 | Filled. `Com_sprintf(&fileString, 524288, "%s} %f\n", fileString, flLen)`. |
| `ai_wpnav.swift:2231` | `SavePathData` | O2 | Filled. `strcat(&fileString, storeString)`. |
| `ai_wpnav.swift:2238` | `SavePathData` | O2 | Filled. `trap_FS_Write(&fileString, strlen(fileString), f)`. |
| `ai_wpnav.swift:2925` | `AcceptBotCommand`, `bot_wp_addflagged` arm | O3, guide line 622 | Filled. `while RequiredSArgument![i] != 0 {` and the ten `== Int32(ascii: "j")` arms, then `i += 1`. The declaration became `var RequiredSArgument: CharBuf? = nil`, the store `RequiredSArgument = CharBuf(ConcatArgs(1))`, and the test `RequiredSArgument == nil || RequiredSArgument![0] == 0`. |
| `ai_wpnav.swift:2953` | `AcceptBotCommand`, `bot_wp_switchflags` arm | O3, guide line 622 | Filled. The same walk, store, and test. |
| `ai_util.swift:72` | `GetValueGroup` | none | No form, shape below. |
| `ai_util.swift:76` | `GetValueGroup` | none | No form. It depends on the store at line 72. |
| `ai_util.swift:158` | `GetPairedValue` | none | No form, shape below. |
| `ai_util.swift:162` | `GetPairedValue` | none | No form. It depends on the store at line 158. |
| `ai_main.swift:707` | `BotUpdateInput` | O4 | Filled. `trap_EA_GetInput(bs.client, Float(time) / 1000, bi)`. |
| `ai_main.swift:795` | `BotAI` | O5 | Filled. `var args: Int32?`. |
| `ai_main.swift:812` | `BotAI` | O5, guide line 153, D5 | Filled. `while true` with the trap call, `strcpy(&buf, text)`, and `if count == 0 { break }` at the top, then `args = strchr(buf, Int32(ascii: " "))`, `if args == nil { continue }`, `buf[args!] = 0`, `args! += 1`, `RemoveColorEscapeSequences(&buf, at: args!)`, and the four `Q_stricmp(buf, ...) == 0` arms with Raven's comments. |

## The shape with no form

Raven's `placesecond = strstr(place+1, group)` in `GetValueGroup` (`ai_util.c:187`) and `placesecond = strstr(place+1, key)` in `GetPairedValue` (`ai_util.c:288`) search from a pointer into the buffer and keep the result as a pointer into the same buffer.
The read through the pointer is the suffix subscript of guide line 629, `strstr(buf[(place! + 1)...], group)`.
`strstr` over that suffix returns an offset from the start of the suffix, so the offset into `buf` is the result plus `place! + 1`.
No guide line and no ruling gives that sum.
Two forms fit, and a docket row must choose one.

1. At the site: `if let found = strstr(buf[(place! + 1)...], group) { placesecond = place! + 1 + found } else { placesecond = nil }`.
2. An `at:` overload of `strstr` in `CString.swift`, on the model of L2 and O5, that returns the offset into the whole buffer, so the site reads `placesecond = strstr(buf, group, at: place! + 1)`.

The read holes then take `if placesecond != nil { startpoint += (placesecond! - place!) ... } else { failure = 1; break }`, which the existing forms give.
jka-rust (`crates/mp/game/src/ai_util.rs:98`, `:205`) keeps raw pointers and computes the same delta.

## GameWorld properties

No property of `g_local.swift` is needed.
The four `fatalErrorPointer` holes need a change in the generated `GameVariables`, not in `g_local.swift`.

- File: `Sources/JKAMP_Game/Generated/Storage/GameVariables.swift:531`, and the accessor at `g_nav.swift:74`.
- Doc lines: `/// Raven's `char *fatalErrorPointer` of `g_nav.c`, a write cursor into `fatalErrorString`, kept as its byte offset.` and `/// Source: oracle/codemp/game/g_nav.c:1616`.
- Now: `public var fatalErrorPointer: String = ""`.
- Needed: `public var fatalErrorPointer: Int32 = 0`, under guide line 628, a pointer into a buffer is its byte offset.
- The generator writes this file, so the change needs a `rulings.py` entry or a generator change and a docket row.

## Findings

1. The O2 ruling text puts the comment between `var fileString = CharBuf(524288)` and `_ = B_TempAlloc(524288)`. The drafter puts the declaration at the top of the function and the comment at the line of Raven's `NULL` store. This record follows the drafter, as the V25 proof says the round does. The two texts agree in content and differ only in the place of the comment.
2. In `AcceptBotCommand`, `ConcatArgs` returns a `String`, so `CharBuf(ConcatArgs(1))` is never `nil`, and the `RequiredSArgument == nil` test is always false. Raven's `ConcatArgs` never returns `NULL` either, so the behavior agrees with Raven's C.
3. `OptionalSArgument` stays `String?`, because its reads are `atoi` and a truth test, not byte reads, and guide line 622 does not reach it.
4. The four `fatalErrorPointer` holes and the four `placesecond` holes are the same as in the frame-path round. No ruling of the frame-path docket reached them, so they need new rows.
