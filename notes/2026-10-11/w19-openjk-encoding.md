# W19. The text encoding at the engine string boundary, from the OpenJK source

This record answers two questions about row W19 in `notes/2026-10-11/docket-proofs-W.md`: why Latin-1, and what OpenJK does. Every citation is under `openjk/` unless the path says otherwise.

## 1. The bytes that reach the game module

### The network readers

`MSG_ReadByte` reads one unsigned byte, `codemp/qcommon/msg.cpp:448-456`, so a byte from 128 to 255 reads as a positive value. `MSG_ReadString` at `codemp/qcommon/msg.cpp:491-528` stops at NUL and changes `%` to `.` at `:503-505`. Its filter for bytes above 127 is a comment at `:506-511`, under "eurofix: remove this so we can chat in european languages". `MSG_ReadBigString` at `:530-553` and `MSG_ReadStringLine` at `:555-576` do the same `%` change and have no filter for high bytes. No reader changes a control byte from 1 to 31.

The write side is the same. `MSG_WriteString` at `codemp/qcommon/msg.cpp:364-390` and `MSG_WriteBigString` at `:392-418` keep their filter for bytes above 127 in a comment, at `:379-386` and `:406-415`.

### A client command

`SV_ClientCommand` reads the text with `MSG_ReadString` at `codemp/server/sv_client.cpp:1260` and calls `SV_ExecuteClientCommand` at `:1302`. `SV_ExecuteClientCommand` at `:1216-1247` tokenizes the text at `:1220`. When `sv_filterCommands` is set, it calls `Cmd_Args_Sanitize` at `:1233-1238` to change `\n` and `\r` to spaces, and also `;` when the value is 2. Then it calls `GVM_ClientCommand` at `:1240`.

`Cmd_TokenizeString2` at `codemp/qcommon/cmd.cpp:515-617` reads each byte as `unsigned char`, with the comment "eurofix", at `:543` and `:592`. So a byte from 1 to 32 separates two tokens, and a byte from 128 to 255 is part of a token. Inside quotes, at `:571-583`, every byte except NUL and `"` goes into the token, control bytes too. `Cmd_Args_Sanitize` at `:489-501` cuts each argument to `length - 1` bytes and calls `Q_strstrip`. `trap_Argv` reaches `Cmd_ArgvBuffer` through `G_ARGV` at `codemp/server/sv_gameapi.cpp:1856-1858`, and `Cmd_ArgvBuffer` at `codemp/qcommon/cmd.cpp:390-392` is a `Q_strncpyz`.

### A userinfo string

`SV_UpdateUserinfo_f` at `codemp/server/sv_client.cpp:1158-1189` copies `Cmd_Argv(1)` into `cl->userinfo` with `Q_strncpyz` at `:1165`. `SV_UserinfoChanged` at `:1068-1150` reads `name`, `rate`, and `snaps`, and adds `ip`. It checks no byte. `Info_Validate` at `codemp/qcommon/q_shared.c:960-979` rejects a byte that `Q_isprint` rejects, so it rejects every byte above 126. But no code in `codemp/` calls `Info_Validate`. The only other hit is the declaration at `codemp/qcommon/q_shared.h:681`. `Info_SetValueForKey` at `codemp/qcommon/q_shared.c:987-1020` rejects only `\`, `;`, and `"`, at `:989-998`. `trap_GetUserinfo` reaches `SV_GetUserinfo` through `G_GET_USERINFO` at `codemp/server/sv_gameapi.cpp:1942-1943`, and `SV_GetUserinfo` at `codemp/server/sv_init.cpp:201-208` is a `Q_strncpyz`.

Raven's `ClientCleanName` at `oracle/codemp/game/g_client.c:1335` removes leading spaces, black color codes, and long runs of spaces. It keeps bytes above 127.

### A server command

`SV_GameSendServerCommand` at `codemp/server/sv_gameapi.cpp:446-448` formats the game's text with `"%s"`. `SV_SendServerCommand` formats with `Q_vsnprintf` at `codemp/server/sv_main.cpp:165`, and `SV_AddServerCommand` stores the text with `Q_strncpyz` at `:145`. `trap_BotGetServerCommand` reaches `SV_BotGetConsoleMessage` through `BOTLIB_GET_CONSOLE_MESSAGE` at `codemp/server/sv_gameapi.cpp:2251-2252`. That function at `codemp/server/sv_bot.cpp:753-774` is a `Q_strncpyz` from `reliableCommands`. So a bot reads the bytes that the game and the engine wrote, with no change.

### A cvar string and a configstring

`Cvar_ValidateString` at `codemp/qcommon/cvar.cpp:80-94` rejects `\`, `"`, and `;`. `Cvar_Get` applies it to the name at `:346-349`, and the check of the value is in an `#if 0` block at `:351-355`. A cvar value has no byte check.

`SV_SetConfigstring` at `codemp/server/sv_init.cpp:113-150` stores a copy with `CopyString` and checks no byte. `SV_GetConfigstring` at `:161-172` is a `Q_strncpyz`. The engine sends a configstring to the client with `MSG_WriteBigString` at `codemp/server/sv_client.cpp:449`.

### The copy and format helpers

`Q_strncpyz` at `shared/qcommon/q_string.c:108-115` is `strncpy` plus a NUL. `Com_sprintf` at `codemp/qcommon/q_shared.c:662-674` is `Q_vsnprintf`. The two copy bytes and do not filter.

### The filter, in one list

- `%` becomes `.` at every network string reader. This applies to a client command, a connect userinfo, and every string the client reads.
- With `sv_filterCommands`, `\n` and `\r` in a game command argument become spaces, and also `;` when the value is 2.
- The tokenizer uses a byte from 1 to 32 as a separator outside quotes.
- `Info_SetValueForKey` and `Cvar_ValidateString` reject `\`, `;`, and `"` where they apply.
- No code filters a byte from 128 to 255. The two filters that did are in comments, and `Info_Validate` has no caller.

## 2. The encoding notion in OpenJK

The engine treats a `char *` as bytes. A case-insensitive search for "utf", "unicode", "latin", "iso-8859", and "1252" in `codemp/` and `shared/` finds one encoding notion, on the client input side. `ConvertUTF8ToUTF32` at `codemp/qcommon/common.cpp:2035-2069` decodes one UTF-8 character. `ConvertUTF32ToExpectedCharset` at `shared/sdl/sdl_input.cpp:652-808` maps the code point to one byte. Cyrillic maps to Windows-1251 at `:656`, Polish and Czech letters map to Windows-1250 at `:722`, and every other code point maps through `default: return (uint8_t)utf32;` at `:806`. For U+0080 to U+00FF, that default is the Latin-1 byte. Three sites call the pair: SDL text input at `shared/sdl/sdl_input.cpp:850-873`, clipboard paste at `codemp/client/cl_keys.cpp:504-508`, and the UI clipboard at `codemp/client/cl_uiapi.cpp:169-173`.

So an OpenJK client never sends UTF-8. It sends one byte for each typed character, and that byte is not valid UTF-8 when it is above 127. A name such as "José" reaches the server as `4A 6F 73 E9`.

The renderer reads one byte as one glyph for Western languages. `AnyLanguage_ReadCharFromString` at `codemp/rd-common/tr_font.cpp:693` casts to `const byte *` at `:695` and returns `psString[0]` at `:801`. For Korean, Taiwanese, Japanese, Chinese, and Thai it reads a two-byte code. For Russian and Polish, the font code loads a different single-byte font, at `:75-87` and `:958-969`. The engine has no UTF-8 renderer. The meaning of a high byte depends on the client's `se_language`, not on the server or the game module.

Raven's game source has no byte above 127 in a `.c` or `.h` file under `oracle/codemp/game/`. Every high byte that the game module sees comes from the engine.

## 3. The Swift boundary now

`Sources/JKAMP_Game/Generated/g_syscalls.swift` has 16 decodes with `String(nulTerminated:)`. Examples are `trap_Cvar_VariableStringBuffer` at `:92-99`, `trap_Argv` at `:111-117`, `trap_GetConfigstring` at `:204-210`, `trap_GetUserinfo` at `:214-220`, and `trap_BotGetServerCommand` at `:1030-1036`. Each fills a `[CChar]` buffer and returns `String(nulTerminated:)`. That initializer at `Sources/JKAShared/Views/String+NulTerminated.swift:4-8` calls `String(decoding:as: UTF8.self)`, which changes each byte sequence that is not valid UTF-8 to U+FFFD, the three bytes `EF BF BD`. The view read `cString(at:)` at `Sources/JKAShared/Views/CStrings.swift:2-4` uses `String(cString:)`, which does the same change.

The encode is UTF-8 at every site. Every `String` argument of a trap goes through `withCString`, for example `trap_SendServerCommand` at `g_syscalls.swift:189-193` and `trap_SetUserinfo` at `:223-227`. `store(_:at:capacity:)` at `Sources/JKAShared/Views/CStrings.swift:9-13` copies `string.utf8.prefix(length)`, so a cut can split a multi-byte sequence. `strlen(_ s: String)` at `Sources/JKAShared/CString.swift:143-145` counts `s.utf8`, and `strcpy(_:_ source: String)` at `:170-172` copies `source.utf8`.

`CharBuf` at `Sources/JKAShared/CharBuf.swift:3-98` stores `[UInt8]`, one byte for each element, not `Int32`. Its subscript getter sign-extends as a signed `char` at `:49-58`. `CharBuf(bytes:)` at `:29-32` keeps every engine byte. `CharBuf(_ string: String)` at `:16-21` writes the UTF-8 bytes of the string plus a NUL. `String(_ buf: CharBuf)` at `:104-114` decodes with UTF-8 and repair at `:113`. `CharBuf` has no `Equatable` conformance, so code compares two buffers through the C string functions in `CString.swift`. So a `CharBuf` keeps bytes exactly, and each conversion to or from `String` uses UTF-8.

The result for "José" from an OpenJK client: `trap_GetUserinfo` returns `"Jos\u{FFFD}"`, and every later encode sends `4A 6F 73 EF BF BD`. The name grows by two bytes and loses the letter for every client.

## 4. jka-rust

`buf_to_string` and `latin1_to_string` at `jka-rust/crates/native/string/src/cstr.rs:11-14` and `:27-29` decode one byte to one `char`, U+0000 to U+00FF. `string_to_latin1` at `:37-41` encodes one `char` to one byte, and a `char` above U+00FF becomes `.`. The game traps in `jka-rust/crates/mp/game/src/trap.rs` decode with these at 10 sites, for example `Argv` at `:266-277`.

The encode side is not complete. `trap.rs` calls `cstr` 36 times and `string_to_latin1` once, in `SendServerCommand` at `:1937-1947`. `cstr` at `cstr.rs:17-19` is `CString::new(s)`, a UTF-8 encode. So `SetConfigstring` at `trap.rs:1972-1975`, `SetUserinfo` at `:1992-1993`, and `Cvar_Set` at `:526-527` send U+00E9 as `C3 A9`. A Latin-1 name that jka-rust reads with `GetUserinfo` and writes back with `SetConfigstring` grows by one byte for each high byte. jka-rust chose Latin-1, and it applied Latin-1 only to the decode side and to one encode.

## Comparison

| Option | Raven's bytes kept | Valid input from an OpenJK client | Legibility | Work |
| --- | --- | --- | --- | --- |
| (a) Latin-1 decode and encode at every boundary | Yes, every byte from 1 to 255 round-trips. | Accepted. | A `String` at a `char *` field stays. A name in Windows-1251 shows as Latin-1 letters if Swift code renders it, but the game module renders no text. | All decodes, all `withCString` encodes, `store`, `strlen`, `strcpy`, `CharBuf(String)`, and `String(CharBuf)` change to one codec pair. `strlen` counts `unicodeScalars`, not `utf8` and not `count`. |
| (b) UTF-8 with an error, not a repair | No. A high byte is an error. | Rejected. An OpenJK client sends single-byte text, so "José" fails. | A `String` stays. | Small, but it adds an error path at each trap that Raven does not have. |
| (c) Bytes at the boundary, `String` only where Raven reads text | Yes, while the value stays a `CharBuf`. | Accepted. | A `CharBuf` replaces a `String` at many fields and parameters. A conversion to `String` still needs a codec, so this option still needs (a) at that point. | Large. Every trap signature and many call sites change. |

## Verdict

Option (a) preserves Raven's behavior exactly, and it is the only option that also keeps a `String` at a `char *` field as the legibility goal asks. OpenJK has no encoding in the server path: it treats every `char *` as bytes, it filters no byte from 128 to 255, and its client sends one byte for each character in Latin-1, Windows-1250, or Windows-1251. Latin-1 is the one decode that maps all 256 byte values to distinct `String` scalars and back with no loss, so it is the codec that makes a `String` carry engine bytes. Option (b) rejects the text of every OpenJK client that types a non-ASCII letter. Option (c) keeps bytes, but it changes many signatures, and each conversion to `String` still needs a lossless codec, which is (a). The rule must cover both directions at every site, because jka-rust shows the defect of a half rule: a Latin-1 decode with a UTF-8 encode changes every high byte on the way back. Two hazards stay with (a). A length or a cut must count `unicodeScalars`, because `count` joins `\r\n` into one `Character`. Swift case functions such as `lowercased()` change letters above 127 that C `tolower` keeps, so a port of `Q_stricmp` must stay byte-based.
