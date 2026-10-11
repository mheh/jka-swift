# Review of phase 2, wave B, transcriptor bot

This review covers the hole round of `g_nav.swift`, `ai_wpnav.swift`, `ai_util.swift`, and `ai_main.swift` in `Sources/JKAMP_GameLogic/`, with the record `notes/2026-10-11/holes2-bot.md`. The text under review is `git diff HEAD` at 4308ee3, read once at the start. The line numbers are the lines of the new text. No build, no test, and no generator ran.

The diff has 16 hunks in three files. `ai_util.swift` has no change, so its four `placesecond` holes (lines 72-78 and 158-164) stay as they were. The four `fatalErrorPointer` holes of `g_nav.swift` (lines 1519-1527 and 1603-1605) are outside every hunk and stay as they were. Every closed hole lost its Port-note line, its `Raven wrote:` line, and its `portMissing` call. No other line of the four files changed.

## Hunks

| File:line | Function | Row | Verdict |
|---|---|---|---|
| `ai_main.swift:707` | `BotUpdateInput` | O4 | match |
| `ai_main.swift:793` | `BotAI`, `args` local | O5 | match |
| `ai_main.swift:808-834` | `BotAI`, server-command loop | O5, D5 | match, see finding 1 |
| `ai_wpnav.swift:2127` | `SavePathData`, `fileString` local | O2 | match |
| `ai_wpnav.swift:2136` | `SavePathData`, `NULL` store | O2 | match |
| `ai_wpnav.swift:2166-2169` | `SavePathData`, allocation and first `Com_sprintf` | O2 | match |
| `ai_wpnav.swift:2191` | `SavePathData`, second `Com_sprintf` | O2 | match |
| `ai_wpnav.swift:2221-2226` | `SavePathData`, `strcat` and `trap_FS_Write` | O2 | match |
| `ai_wpnav.swift:2800` | `AcceptBotCommand`, `RequiredSArgument` local | O3 | match |
| `ai_wpnav.swift:2904-2934` | `AcceptBotCommand`, `bot_wp_addflagged` store, test, and walk | O3 | match |
| `ai_wpnav.swift:2953-2983` | `AcceptBotCommand`, `bot_wp_switchflags` store, test, and walk | O3 | match |
| `g_nav.swift:348` | `NAV_ClearPathToPoint` | P1 | match |
| `g_nav.swift:519` | `NAV_CheckAhead` | P1 | match |
| `g_nav.swift:794` | `NAV_StackedCanyon`, first test | P1 | match |
| `g_nav.swift:807` | `NAV_StackedCanyon`, second test | P1 | match |
| `g_nav.swift:978` | `NAV_TestBestNode` | P1 | match |

## Notes on the matches

`BotUpdateInput` (`ai_main.c:644`). The call is the O4 text exactly. `Float(time) / 1000` is Raven's `(float) time / 1000`, a float division. `bi` is the `BotInput.scratch` view, and the generated overload forwards `bi.handle`, which is Raven's `&bi`. jka-rust passes `time as f32 / 1000.0` and a raw pointer to the record.

`BotAI` (`ai_main.c:697-730`). `var args: Int32?` is Raven's uninitialized `char *args` as a byte offset. The loop is the O5 text: the trap, `strcpy(&buf, text)`, and `if count == 0 { break }`. `strchr(buf, Int32(ascii: " "))` stops at the first NUL and returns `nil` when no space exists, which is Raven's `strchr` returning `NULL`. On `nil`, `continue` goes back to the trap call, which is what Raven's `continue` in a `while` test does. `buf[args!] = 0` and `args! += 1` are Raven's `*args++ = '\0'` under D5. `RemoveColorEscapeSequences(&buf, at: args!)` is the O5 text, and its suffix-and-write-back body changes only the bytes from `args` on, as Raven's call through the pointer does. The four `Q_stricmp(buf, ...) == 0` arms keep Raven's order, his `"cp "` with the trailing space, and his comment bodies. On a false trap result the Swift writes an empty string into `buf`, and Raven's engine leaves `buf` as it was. No read of `buf` follows the loop, so the difference has no effect. jka-rust drops the `Q_stricmp` chain and copies the arguments into a temporary buffer for the color strip.

`SavePathData` (`ai_wpnav.c:2372-2450`). The order in the file is `var fileString = CharBuf(524288)`, the comment, and `_ = B_TempAlloc(524288)`, which is the O2 text and the same form as `LoadPathData` at `ai_wpnav.swift:1786` and `:1818`. The record's finding 1 says that the comment place differs from the ruling text, but the three lines stand in the ruled order, so this review finds no difference. The comment is one STE sentence with no em dash. The two `Com_sprintf` calls, the `strcat`, and the `trap_FS_Write` keep Raven's operands, his size `524288`, and his order. The `fileString` operand of the second `Com_sprintf` formats into the 32000-byte `bigbuffer` first, as Raven's `Com_sprintf` does, so the self-reference is safe. `B_TempFree(524288)` at the end is unchanged. jka-rust builds the text with `format!` and keeps the `B_TempAlloc` call for the pool count.

`AcceptBotCommand` (`ai_wpnav.c:3630-3760`). The declaration, the two stores, and the two tests are the O3 text. `RequiredSArgument == nil` is always false because `ConcatArgs` returns a `String`, and Raven's `ConcatArgs` never returns `NULL`, so the behavior agrees. The walk reads the byte with `RequiredSArgument![i] != 0`, the ten arms keep Raven's letter order `j d c f s x y g n m` and his flag for each letter, and `i += 1` closes each pass. `i` starts at 0 from the declaration, and each arm returns, so the second walk also starts at 0, as in Raven. jka-rust walks `as_bytes()` up to the string length with the same ten arms.

`g_nav.swift`. Each test is Raven's at `g_nav.c:319`, `:512`, `:790`, `:802`, and `:992`, with `== qfalse` as `== 0` under P1 and `1.0f` as `1.0` on a `Float` field. The `NAV_ClearPathToPoint` line is the P1 text exactly. Raven's `//FIXME: check for drops` and `//it's clear` move to the first line of the block, as the drafter places a comment after an opening brace. No new cast appears.

## Findings

1. `BotAI` byte path through the trap text. Raven's line is `while( trap_BotGetServerCommand(client, buf, sizeof(buf)) )` at `ai_main.c:717`, which writes the engine's bytes into `buf` unchanged. The Swift lines are `let (count, text) = trap_BotGetServerCommand(client, Int32(buf.count))` and `strcpy(&buf, text)` at `ai_main.swift:809-810`. The generated trap at `Sources/JKAMP_Game/Generated/g_syscalls.swift:1030` decodes the bytes through `String(nulTerminated:)`, which uses `String(decoding:as: UTF8.self)`. A byte that is not valid UTF-8, for example a Latin-1 letter in a player name of a `cs` command, becomes U+FFFD, which is three bytes. The text in `buf` then differs from Raven's bytes, and a command near 1023 bytes with such bytes can pass 1024 bytes and trap in `strcpy`. jka-rust `trap.rs:358` also returns a `String` through `buf_to_string`, but it writes no fixed buffer, so it cannot trap there. The hunk is the O5 ruled form exactly, and the difference comes from the generated trap, so the coordinator decides if the trap needs a row that returns the bytes.
