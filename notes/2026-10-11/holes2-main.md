# Hole round 2, transcriptor "main"

This record covers the Port-notes of `g_main.swift`, `g_svcmds.swift`, and `g_session.swift` in wave B of phase 2. The line numbers are the lines before the edit, at 4308ee3.

## The holes

| File:line before | Function | Row or guide line | What the body has now |
|---|---|---|---|
| `g_main.swift:557` | `vmMain` | F5 | blocked, F5 removes the logic `vmMain` at the next g_main re-splice, and the shell arm of `jampgame.swift:51` holds the form |
| `g_main.swift:592` | `vmMain` | F5 | blocked, F5, the shell arm of `jampgame.swift:85` holds the form |
| `g_main.swift:710` | `vmMain` | F5 | blocked, F5, the guide's `GAME_ICARUS_GETSTRING` arm (guide 117-128) is the shell form at `jampgame.swift:164` |
| `g_main.swift:713` | `vmMain` | F5 | blocked, F5, same arm |
| `g_main.swift:716` | `vmMain` | F5 | blocked, F5, same arm |
| `g_main.swift:720` | `vmMain` | F5 | blocked, F5, same arm |
| `g_main.swift:738` | `vmMain` | F5 | blocked, F5, the shell arm of `jampgame.swift:176` holds the form |
| `g_main.swift:746` | `vmMain` | F5 | blocked, F5, the `float *` word decode is a shell job under rule 11, `jampgame.swift:181` |
| `g_main.swift:751` | `vmMain` | F5 | blocked, F5, `jampgame.swift:192` |
| `g_main.swift:756` | `vmMain` | F5 | blocked, F5, `jampgame.swift:195` |
| `g_svcmds.swift:69` | `StringToFilter` | L1, R3 | `f.mask = UInt32(nativeBytes: m)`, with `b` and `m` declared `[UInt8]` and `b[i] = UInt8(truncatingIfNeeded: atoi(num))` |
| `g_svcmds.swift:72` | `StringToFilter` | L1, R3 | `f.compare = UInt32(nativeBytes: b)` |
| `g_svcmds.swift:100` | `UpdateIPBans` | L1, R3 | `b = nativeBytes(of: ipFilters[i].compare)`, with `b` declared `[UInt8]` |
| `g_svcmds.swift:103` | `UpdateIPBans` | L2 | the ruled line, `Com_sprintf(&iplist, Int32(iplist.count) - strlen(iplist), "%i.%i.%i.%i ", Int32(b[0]), ..., at: strlen(iplist))` |
| `g_svcmds.swift:146` | `G_FilterPacket` | L1, R3 | `` `in` = UInt32(nativeBytes: m) ``, with `m` declared `[UInt8]` and the R3 truncating store in the digit loop |
| `g_svcmds.swift:203` | `G_ProcessIPBans` | none | no form, shape below |
| `g_svcmds.swift:206` | `G_ProcessIPBans` | none | no form, shape below |
| `g_svcmds.swift:213` | `G_ProcessIPBans` | none | no form, shape below |
| `g_svcmds.swift:298` | `Svcmd_ListIPs_f` | L1, R3 | `b = nativeBytes(of: ipFilters[i].compare)`, `b` is `[UInt8]`, and the `%i` arguments read `Int32(b[0])` under guide 532 |
| `g_svcmds.swift:330` | `G_SaveBanIP` | L1, R3 | the same as `Svcmd_ListIPs_f` |
| `g_svcmds.swift:460` | `ClientForString` | guide 624 | `let s = CharBuf(s)` at the top, Raven's numeric arm as written with `Int32(ascii:)`, and the later `Q_stricmp` reads `String(s)` |
| `g_session.swift:64` | `G_WriteClientSessionData` | D1 | the `va` call with the session fields as Raven wrote them, `teamLeader` and `setForce` as `Bool` |
| `g_session.swift:96` | `G_ReadSessionData` | D2, D3, A6 | the proof's form: `ints` and `texts` arrays, `sscanf(s, "...", &ints, &texts)`, and one store back per target in Raven's order, `setForce` through `Bool(ints[7])` |
| `g_session.swift:128` | `G_ReadSessionData` | D3 | `client.sess.teamLeader = Bool(teamLeader)` |
| `g_session.swift:167` | `G_InitSessionData` | D4 | `var value: CharBuf`, `value = CharBuf(Info_ValueForKey(userinfo, "team"))`, and Raven's `r`, `R`, `b`, `B` tests on `value[0]` |
| `g_session.swift:175` | `G_InitSessionData` | D4, guide 540 | the same store and the `s` test, the gametype `switch`, and `doubles == 0` for `!doubles` |

### The shape of the `G_ProcessIPBans` holes

Raven walks two `char *` locals over `g_banIPs.string`, the cvar's own `char[256]`, and writes NUL bytes into it.
Guide 646-649 gives `s` and `t` as `Int32` write cursors over `g_banIPs.stringBuffer`, and guide 625 gives `*s++ = 0`.
Two steps of the loop have no form:

1. `s = strchr(s, ' ')`, a search that starts at a cursor. `strchr` over the suffix `g_banIPs.stringBuffer[s...]` gives an offset from `s`, not from the buffer. The same shape stands as a hole at `ai_util.swift:72`, `placesecond = strstr(place+1, group)`.
2. `AddIP( t )`, a pointer into a buffer passed to the `inout CharBuf` parameter of `AddIP`. No `at:` overload of `AddIP` exists, and guide 211 covers a `String` argument only.

A proposed form for a docket row: `let found = strchr(g_banIPs.stringBuffer[s...], " ")`, `if found == nil { break }`, `s += found!`, and `var tText = g_banIPs.stringBuffer[t...]` with `AddIP(&tText)`. `AddIP` writes no byte through its parameter, so the copy is behavior-equal.

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_main.swift` | 10 | 10 |
| `g_svcmds.swift` | 11 | 3 |
| `g_session.swift` | 5 | 0 |
| Total | 26 | 13 |

## GameWorld properties

None.

## Findings

1. The ten `g_main.swift` holes are all in the logic `vmMain`, which row F5 of `notes/2026-10-09/dispatch-fill-2-walk.md:11` removes at the next g_main re-splice. No form in the logic target can decode a pointer word under rule 11, so the plan's form for `crap` and `morecrap` does not apply there. The shell `vmMain` in `Sources/jampgame/jampgame.swift` already holds every one of the ten arms. The coordinator decides whether the function goes now or at the re-splice.
2. Raven's `G_InitSessionData` puts the `default` label first, over `GT_FFA`, `GT_HOLOCRON`, `GT_JEDIMASTER`, and `GT_SINGLE_PLAYER`. Swift puts `default` last, so the body has the `GT_DUEL` and `GT_POWERDUEL` arms first and the `default` arm last, with two comment lines that name Raven's four labels. The behavior is the same. The guide has no line for a `default` label that is not last, so this can become a docket row.
3. Raven's `G_ProcessIPBans` copies `g_banIPs.string` into `str` and then walks `g_banIPs.string`, not `str`, so his loop writes NUL bytes into the cvar memory. jka-rust (`g_svcmds.rs:233-257`) walks a copy and writes nothing. A faithful port walks `g_banIPs.stringBuffer`.
4. In `G_ReadSessionData`, a `%s` token of 64 bytes or more overruns Raven's `char[64]` fields. The port stores the token through the view's `String` setter, so that setter decides what a long token stores. This round did not read the setter. Rule 19 may want a two-line note at the store.
5. The D2 ruling says "the hand `COM_Parse` walk drops". The file at 4308ee3 has no such walk, so nothing dropped.
