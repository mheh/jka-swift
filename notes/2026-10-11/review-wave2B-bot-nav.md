# Review of the frame-path round, wave 2B: bot and nav files

This review reads the uncommitted fills in `ai_wpnav`, `g_bot`, `ai_main`, `g_nav`, `g_navnew`, and `ai_util` under `Sources/JKAMP_GameLogic/`. The fills remove 101 `portMissing` markers: 25 in ai_wpnav, 24 in g_bot, 18 in g_nav, 10 in g_navnew, and 24 in ai_util. ai_main has no change. The review compares each fill with Raven's C, the jka-rust range of the manifest, and `docs/transcription.md`. The review finds 0 behavior findings, 1 form finding, and 2 style findings.

## Findings

| File | Function | Finding | Severity | Raven line | Swift line |
|---|---|---|---|---|---|
| ai_wpnav | G_RMGPathing | Raven's test `if (!terrain \|\| !terrain->inuse \|\| terrain->s.eType != ET_TERRAIN)` prints an error on the NULL path before it returns. The fill writes `terrain == nil \|\| !terrain!.inuse \|\| ...` and then 8 force unwraps `terrain!` through the body. The guide gives a `guard let` for a NULL early-out, and it says that a guard that does other work on the NULL path keeps a Port-note. The fill uses a shape the guide does not give. The behavior is the same, because the early-out runs before every `terrain!` read. | form | ai_wpnav.c:3068-3072 | ai_wpnav.swift:2498-2503 |
| g_nav | NAV_TestBestNode | Raven's `fabs( self->r.currentOrigin[2] - end[2] ) > 48` compares a double. The fill writes `abs(...) > 48` in `Float`. The guide's double-math rule gives `abs(Double(...)) > 48` for a comparison that C computes in double. The value does not change, because a float converts to double exactly and 48 is exact in both types. The same file already writes this form at lines 523 and 982. | style | g_nav.c:1030 | g_nav.swift:1009 |
| g_nav | NAV_CalculatePaths | The fill removes the Port-note for Raven's `if ( !tempWaypointList ) { return; }` and writes no line in its place. `tempWaypointList` is a static array at g_nav.c:1660, so the test is always false, and the guide drops a NULL guard on a never-null variable with no comment and no marker. The behavior is the same. The row records a note that was removed with no replacement line. | style | g_nav.c:1739 | g_nav.swift:1601-1606 |

## The G_AddBot fill, line by line

Raven's function starts at g_bot.c:792. The Swift function starts at g_bot.swift:869.

1. `char *botinfo` becomes `let botinfo: String?`. `G_GetBotInfoByName` returns `String?`, and the guide makes a text local set from an optional text return a `String?`. This is correct.
2. `char *botname` becomes `var botname: String`. `Info_ValueForKey` returns `String`, and every store into `botname` is a `String`. This is correct.
3. `botinfo = G_GetBotInfoByName( name );` becomes `botinfo = G_GetBotInfoByName(name)` at line 885. This is correct.
4. `if ( !botinfo ) { G_Printf( S_COLOR_RED "Error: Bot '%s' not defined\n", name ); return; }` becomes `if botinfo == nil { G_Printf(S_COLOR_RED + "Error: Bot '%s' not defined\n", name); return }`. The test keeps Raven's NULL form, as the guide asks. The `+` gives the same text as C's literal concatenation. The draft had dropped this early-out, and the fill writes it back. jka-rust g_bot.rs:647-657 has the same early-out. This is correct.
5. `userinfo[0] = '\0';` was already on the page.
6. `botname = Info_ValueForKey( botinfo, "funname" );` becomes `botname = Info_ValueForKey(botinfo!, "funname")` at line 894. The unwrap cannot trap, because step 4 returns on nil. This is correct.
7. `if( !botname[0] ) { botname = Info_ValueForKey( botinfo, "name" ); }` becomes `if botname.isEmpty { ... }`. An empty `String` is Raven's first byte of 0. This is correct.
8. `if (altname && altname[0]) { botname = altname; }` becomes `if altname[0] != 0 { botname = String(altname) }`. The `altname &&` half was already absent in the draft, because the parameter is a non-optional `String` and the one caller, `Svcmd_AddBot_f`, passes a buffer. The fill only replaces the store. This is correct.
9. `Info_SetValueForKey( userinfo, "name", botname );` becomes `Info_SetValueForKey(&userinfo, "name", botname)` at line 902. This is correct.
10. The `model`, `gender`, `color1`, `color2`, `saber1`, and `saber2` blocks each read `Info_ValueForKey(botinfo!, key)` and replace Raven's `if ( !*x ) { x = "..."; }` with `if x.isEmpty { x = "..." }`. The default texts are `kyle/default`, `male`, `4`, `4`, `single_1`, and `none`, as Raven wrote them. The `gender` block stores under the key `sex`, as Raven did. This is correct.
11. The `personality` block keeps both arms, `botfiles/default.jkb` on an empty value and `s` otherwise. This is correct.
12. The `trap_SendServerCommand` line under `clientNum == -1` now passes the literal `"MP_SVGAME"`, because `lookup.py sig G_GetStringEdString` gives two `String` parameters. This is correct.
13. Raven's two-buffer `Info_ValueForKey` has no effect here, because each result is consumed by `Info_SetValueForKey` before the next call. A returned `String` is a copy in the port, so the order of the calls gives the same text.
14. The commented-out `headmodel` block and the `//	char *headmodel;` line stay as Raven wrote them.

The G_AddBot fill has no finding.

## Files with no finding

- `g_bot`: G_RefreshNextMap, the five `cl = level.clientsSlots[i]` loops of G_AddRandomBot, G_RemoveRandomBot, G_CountHumanPlayers, and G_CountBotPlayers, G_AddBot, and Svcmd_BotList_f agree with Raven and with jka-rust. The `Level` view carries `clientsSlots`.
- `g_navnew`: the `AngleVectors` scratch outputs take the guide's plain comment. The store inside the else-if test of NAVNEW_MoveToGoal opens the else block, as the guide asks. The `++numTries` fill sits in Raven's block and takes the same `break failed` as the other `goto failed` sites.
- `ai_util`: GetValueGroup, GetPairedValue, BotDoChat, ParseEmotionalAttachments, and ReadChatGroups use the guide's byte-offset form for `strstr`, the `Buffer` accessors for byte writes, and the one-test form for `!buf[startpoint] || buf[startpoint] == '\0'`. The holes that read `placesecond` keep their Port-notes.
- `ai_main`: the working tree has no change in this file.
- In `ai_wpnav` and `g_nav`, every fill outside the three rows above has no finding. This includes GetFlagStr, the `trap_Trace` NULL `mins` and `maxs` sites, GetObjectThatTargets, NAV_CheckAhead, NAV_MoveToGoal, and the `AngleVectors` scratch outputs.
