# Review of phase 2, wave B, transcriptors "main" and "entities"

This record reviews the working-tree diff against 4308ee3 of the twelve files of the two records `holes2-main.md` and `holes2-entities.md`. The reviewer read the diff once, at the start. `g_main.swift` and `g_mover.swift` have no diff. The line numbers are the lines of the new side of the diff.

## Hunks

| File:line | Function | Row | Verdict |
|---|---|---|---|
| `g_client.swift:3240` | `ClientSpawn` | B1 | match |
| `g_cmds.swift:168` | `ConcatArgs` | B2 | behavior differs, finding 2 |
| `g_cmds.swift:192` | `SanitizeString` | B3 | match |
| `g_cmds.swift:1764` | `Cmd_GameCommand_f` | B4 | form differs, finding 1 |
| `g_local.swift:787` | `GameWorld.index_vtos` drop | B6 | match |
| `g_misc.swift:716` | `SP_misc_skyportal` | L3 | match |
| `g_saga.swift:1634` | `SP_misc_siege_item` | Q1 | match |
| `g_session.swift:63` | `G_WriteClientSessionData` | D1 | match |
| `g_session.swift:111` | `G_ReadSessionData` | D2, A6 | match |
| `g_session.swift:170` | `G_ReadSessionData` | D3 | match |
| `g_session.swift:189` | `G_InitSessionData` declaration | D4 | match |
| `g_session.swift:206` | `G_InitSessionData` | D4, guide 540 | form differs, finding 3 |
| `g_svcmds.swift:30` | `StringToFilter` declarations | R3 | match |
| `g_svcmds.swift:56` | `StringToFilter` | R3 | match |
| `g_svcmds.swift:68` | `StringToFilter` | L1 | match |
| `g_svcmds.swift:83` | `UpdateIPBans` declaration | R3 | match |
| `g_svcmds.swift:95` | `UpdateIPBans` | L1, L2 | match |
| `g_svcmds.swift:113` | `G_FilterPacket` declaration | R3 | match |
| `g_svcmds.swift:127` | `G_FilterPacket` | R3 | match |
| `g_svcmds.swift:137` | `G_FilterPacket` | L1 | match |
| `g_svcmds.swift:278` | `Svcmd_ListIPs_f` | L1, R3 | match |
| `g_svcmds.swift:301` | `G_SaveBanIP` declaration | R3 | match |
| `g_svcmds.swift:317` | `G_SaveBanIP` | L1, R3 | match |
| `g_svcmds.swift:440` | `ClientForString` | guide 624 | match |
| `g_svcmds.swift:469` | `ClientForString` | guide 624 | match |
| `g_target.swift:209` | `Use_Target_Print`, four sites | Q1, guide 339 | style, finding 4 |
| `g_target.swift:785` | `scriptrunner_run` | D5 | match |
| `g_team.swift:1104` | `TeamplayInfoMessage` | D5 | match |
| `g_utils.swift:108` | `BuildShaderStateConfig` | B5 | match |
| `g_utils.swift:609` | `index_vtos` forward drop | B6 | match |
| `g_utils.swift:621` | `vtos` | B6 | match |

The table has one row per hunk, 31 hunks. The `Use_Target_Print` hunk holds the four Q1 sites of that function.

## Checks that pass

- `StringToFilter`, `UpdateIPBans`, `G_FilterPacket`, `Svcmd_ListIPs_f`, and `G_SaveBanIP` use `UInt32(nativeBytes:)` and `nativeBytes(of:)` from `Sources/JKAShared/NativeBytes.swift`, which copy the four bytes in the native byte order, as Raven's `*(unsigned *)` cast and jka-rust's `from_ne_bytes` do. The pack and the unpack use the same order on both sides of the compare, so `(in & mask) == compare` gives Raven's result.
- `StringToFilter` sets `m[i] = 255` only for a nonzero octet, as Raven does. A zero octet gives mask 0 and compare 0 for that byte, so that byte matches any address. This is Raven's partial-mask behavior, and the Swift keeps it.
- `b[i] = UInt8(truncatingIfNeeded: atoi(num))` and the `G_FilterPacket` digit store keep Raven's truncating store into a `byte`, so "300" stores 44, as jka-rust's `as u8` and `wrapping_mul` do.
- The `UpdateIPBans` call is the L2 line exactly. `iplist` is `CharBuf(1024)`, Raven's `MAX_INFO_STRING`.
- The D2 store-back order is Raven's argument order: `sessionTeam`, `spectatorTime`, `spectatorState`, `spectatorClient`, `wins`, `losses`, `teamLeader`, `setForce`, `saberLevel`, `selectedFP`, `duelTeam`, `siegeDesiredTeam`, `siegeClass`, `saberType`, `saber2Type`. The `sscanf` overload leaves a slot past the stop with its seed value, so a short string stores the old value back, as C does by not writing.
- D1: `Bool: FormatArg` prints `.integer(self ? 1 : 0)`, the 0 or 1 that Raven's `%i` prints for a `qboolean`.
- B1: `(start - end)` is an `int` in C, and the Swift term `healthSpan: Int32` keeps it. The multiply by `(float)wins` and the divide by `(float)fraglimit` run left to right in `Float`, and the store truncates toward zero. The three stores run in Raven's right-to-left chain order: `STAT_MAX_HEALTH`, then `STAT_HEALTH`, then `ent.health`.
- B3: the `Int8` overload of the `CharBuf` subscript gives the signed byte, so `in[inIndex] < 32` drops the bytes 128 to 255, as Raven's signed `char` compare does and as jka-rust's `(c as i8) < 32` does. The color-code skip, the `tolower` of the unsigned byte, and the terminator are Raven's.
- B5: `zero(count:)` zeroes the first 1024 bytes of the 4096-byte buffer, as Raven's `memset` does.
- B6: the format string and the width 32 are Raven's. `index_vtos`, its forward, and the `GameWorld` property are gone, and no file reads `index_vtos`. The `Int32(v[0])` casts are Raven's `(int)` casts, and they trap on a NaN or an out-of-range value where jka-rust's `as c_int` saturates. This is the house behavior of every `Int32(Float)` cast.
- L3: `isfog += G_SpawnVector(...)` uses the `Int32 += Bool` operator of `Promotion.swift:48`, which adds 1 or 0.
- Q1, `SP_misc_siege_item`: a model name under 4 bytes gives a negative start, and the suffix subscript traps. C reads before the buffer there, and jka-rust guards with `len() >= 4`. The Q1 ruling names this trap.
- D5: both sites use the old value, then step on the next statement. The `va` in `scriptrunner_run` reads the old value, as Raven's `numNewICARUSEnts++` does.
- `G_InitSessionData`: the C labels are disjoint and every arm ends in `break`, so the place of `default` does not change which body runs. `do { }` holds Raven's brace block.
- `ClientForString`: `level.clientsSlots[idnum]` is the form that the name loop already uses. `G_Printf("User %s ...", s)` now passes the `CharBuf`, which conforms to `FormatArg`.
- The closed holes removed their Port-note, Raven-wrote line, and `portMissing` call. The counts are `g_main` 10, `g_svcmds` 3, `g_client` 1, `g_saga` 1, `g_mover` 1, and 0 in the other files, as the two records say. The ten `vmMain` holes, the three `G_ProcessIPBans` holes, `ClientCleanName`, `SiegeItemRespawnOnOriginalSpot`, and `SP_func_breakable` have no diff. No hunk changes a line outside a hole.

## Findings

1. `Cmd_GameCommand_f` has no rule 19 note. Raven, `g_cmds.c:1835`: `if ( order < 0 || order > sizeof(gc_orders)/sizeof(char *) ) {`. Swift, `g_cmds.swift:1764`: `if order < 0 || order > gc_orders.count {`, with no comment line. jka-rust, `g_cmds.rs:2009`, changes the test to `>=` and states the off-by-one in a comment. The B4 ruling keeps Raven's `>` under a one-line rule 19 note in the form of the `q_shared` precedents, for example `q_shared.c.swift:127`. The test is the ruled form, but the note line is not there. A proposed line: `// Raven reads one past the seven rows for an order of 7, and the Swift subscript traps there.`
2. The B2 form in `ConcatArgs` does not write Raven's bytes when an argument holds bytes that are not UTF-8. Raven, `g_cmds.c:140`: `memcpy( line + len, arg, tlen );`. Swift, `g_cmds.swift:168`: `strncpy(&line, String(arg), tlen, at: len)`. `String(CharBuf)` decodes with UTF-8 repair, so a Latin-1 byte such as `0xE9` becomes the three bytes `EF BF BD`. The copy then stops after `tlen` bytes of the repaired text. For the argument bytes `E9 61 62 63`, the line gets `EF BF BD 61`, and `bc` is lost. jka-rust, `g_cmds.rs:208`, counts Latin-1 characters and appends the whole argument. The B2 ruling says the form writes exactly Raven's bytes, and that is true for UTF-8 text only. A `strncpy` overload with a `CharBuf` source and `at:` would copy the raw bytes.
3. `G_InitSessionData` puts `default` last, under a two-line comment, and no guide line or ruling gives that form. Raven, `g_session.c:224`: `default: case GT_FFA: case GT_HOLOCRON: case GT_JEDIMASTER: case GT_SINGLE_PLAYER:` first. Swift, `g_session.swift:226` to `243`: `case GT_DUEL`, `case GT_POWERDUEL`, then `default` with the comment. jka-rust uses a `match` with a `_` arm last. The behavior is the same, as the checks above say. The transcriptor raised the same point as finding 2 of `holes2-main.md`, so the row is a guide line for a `default` label that is not last.
4. The four `Use_Target_Print` sites keep `ent.message ?? "(null)"` at each `%s` after `let message = CharBuf(ent.message!)` on the same arm. Raven, `g_target.c:194`: `va("cps \"%s\"", ent->message )`. Swift, `g_target.swift:212`: `va("cps \"%s\"", ent.message ?? "(null)")`. The force unwrap traps first on a nil `message`, so the fallback never runs. jka-rust unwraps once and formats `msg`. The behavior is the same, and the form follows guide line 339 with the Q1 line. The row is whether the `%s` reads `message` or `ent.message!` after the Q1 binding.
