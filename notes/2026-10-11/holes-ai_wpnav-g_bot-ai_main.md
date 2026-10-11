# Hole round: ai_wpnav, g_bot, ai_main

This record covers the Port-notes of `Sources/JKAMP_GameLogic/ai_wpnav.swift`, `Sources/JKAMP_GameLogic/g_bot.swift`, and `Sources/JKAMP_GameLogic/ai_main.swift`.
The round filled 49 holes, left 15 holes as `stands`, and left 0 holes as `blocked`.
One row of a table covers each Port-note, except where the Note names a count of notes.

## ai_wpnav.swift

Totals: 25 filled, 12 stands, 0 blocked.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| GetFlagStr | `return flagstr` did not compile, because `flagstr` is a `CharBuf` and the return is a `String`. | filled | The `char *` return is a `String`, and `String(readBuf)` is the guide's read of a `CharBuf`. The line is `return String(flagstr)`. |
| RemoveWP | `memset( gWPArray[gWPNum], 0, sizeof(gWPArray[gWPNum]) )` did not compile. | stands | The size is `sizeof` of a pointer, not of `wpobject_t`, so the memset zeroes part of the record. The guide keeps a Port-note on a memset over a partial size. Docket row 1. |
| RemoveWP_InTrail | `memset( gWPArray[i], 0, sizeof(gWPArray[i]) )`, the first arm. | stands | The same partial size as RemoveWP. Docket row 1. |
| RemoveWP_InTrail | `memset( gWPArray[i], 0, sizeof(gWPArray[i]) )`, the second arm. | stands | The same partial size as RemoveWP. Docket row 1. |
| ConnectTrail | A `NULL` `mins` and a `NULL` `maxs` into `trap_Trace`, three calls, six notes. | filled | The guide gives `vec3_origin` with no comment. The call already passes `vec3_origin`, so the notes and the markers drop. |
| DoorBlockingSection | A `NULL` `mins` and a `NULL` `maxs` into `trap_Trace`, four calls, eight notes. | filled | The same form as ConnectTrail. |
| G_RecursiveConnection | A `NULL` `mins` and a `NULL` `maxs` into `trap_Trace`, one call, two notes. | filled | The same form as ConnectTrail. |
| GetObjectThatTargets | `next = G_Find( next, FOFS(target), ent->targetname )` had no operator. | filled | `FOFS(target)` is `\.target`, and the `String?` field passes to the `String` parameter with the force unwrap. Raven's NULL test of `targetname` stands above the call. |
| SavePathData | The pointer local `char *fileString`. | stands | Raven stores `NULL` and then `B_TempAlloc(524288)`. The `CharBuf` form needs every store to be the allocator call, so the `NULL` store has no form. Docket row 2. |
| SavePathData | The store `fileString = NULL`. | stands | Docket row 2. |
| SavePathData | The store `fileString = (char *)B_TempAlloc(524288)`. | stands | Docket row 2. When the row is ruled, the line is `_ = B_TempAlloc(524288)`, because the draft dropped the call. |
| SavePathData | The read in the first `Com_sprintf(fileString, 524288, ...)`. | stands | Docket row 2. |
| SavePathData | The read in `Com_sprintf(fileString, 524288, "%s} %f\n", fileString, flLen)`. | stands | Docket row 2. |
| SavePathData | The read in `strcat(fileString, storeString)`. | stands | Docket row 2. |
| SavePathData | The read in `trap_FS_Write(fileString, strlen(fileString), f)`. | stands | Docket row 2. |
| G_RMGPathing | `gentity_t *terrain = G_Find( NULL, FOFS(classname), "terrain" )` had no operator. | filled | `let terrain = G_Find(nil, \.classname, "terrain")`. |
| G_RMGPathing | The read of `terrain` in Raven's early-out test. | filled | Raven's test keeps its form on the optional, and the early-out is `return true` of the `Trace.scratch` closure, the closure's value where Raven returns. |
| G_RMGPathing | The read in `placeX = terrain->r.absmin[0]`. | filled | `terrain!.r.absmin[0]`, the force unwrap of an optional local after Raven's NULL test. |
| G_RMGPathing | The read in `placeY = terrain->r.absmin[1]`. | filled | The same form. |
| G_RMGPathing | The read in `placeZ = terrain->r.absmax[2]-400`. | filled | The same form. |
| G_RMGPathing | The read in the node grid loop. | filled | Raven's two `while` loops line for line, with `VectorCopy` as `=`, `VectorClear` as `vec3_t()`, and the `int` step into a `float` through the compound assignment of `Promotion.swift`. |
| G_RMGPathing | The read in the two calls to `G_RecursiveConnection`. | filled | Raven's two `if` tests with `true` and `false` for `qtrue` and `qfalse`. The `PAINFULLY_DEBUGGING_THROUGH_VM` arms drop, because Raven's `#define` at line 2503 is a comment. |
| AcceptBotCommand | The `while (RequiredSArgument[i])` walk of the `bot_wp_addflagged` arm did not compile. | stands | `RequiredSArgument` is a `String?` local that `ConcatArgs` sets. The guide gives the byte walk as a `CharBuf` only for a `String` parameter. Docket row 3. |
| AcceptBotCommand | The same walk in the `bot_wp_switchflags` arm. | stands | Docket row 3. |

## g_bot.swift

Totals: 24 filled, 0 stands, 0 blocked.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_RefreshNextMap | `trap_Cvar_Set( "nextmap", va("map %s", type))` did not compile. | filled | `type` is a `String?` local, so the format argument takes the force unwrap, `va("map %s", type!)`. Raven stores `type` on the line above. |
| G_AddRandomBot | `cl = level.clients + i`, the first loop. | filled | A pointer field Raven indexes reads its `Slots` accessor: `cl = level.clientsSlots[i]`. |
| G_AddRandomBot | `cl = level.clients + i`, the second loop. | filled | The same form. |
| G_RemoveRandomBot | `cl = level.clients + i`. | filled | The same form. |
| G_CountHumanPlayers | `cl = level.clients + i`. | filled | The same form. |
| G_CountBotPlayers | `cl = level.clients + i`. | filled | The same form. |
| G_AddBot | The pointer local `char *botname`. | filled | Every store is a text, so the local is `var botname: String`. |
| G_AddBot | `botinfo = G_GetBotInfoByName( name )` stores an optional text into a `String`. | filled | The text-local form: `botinfo` is a `String?`, Raven's NULL test keeps its form, and every later read is `botinfo!`. The draft had dropped Raven's `if ( !botinfo )` early-out with its `G_Printf`, and the fill writes it back. |
| G_AddBot | The store `botname = Info_ValueForKey( botinfo, "funname" )`. | filled | `botname = Info_ValueForKey(botinfo!, "funname")`. |
| G_AddBot | The read `if( !botname[0] )`. | filled | `botname.isEmpty`, the truth-test form that the draft also uses for `!token[0]` in G_ParseInfos. |
| G_AddBot | The store `botname = altname`. | filled | `altname` is the body's `CharBuf` copy of the parameter, so the store is `String(altname)`. |
| G_AddBot | The read `Info_SetValueForKey( userinfo, "name", botname )`. | filled | `Info_SetValueForKey(&userinfo, "name", botname)`. |
| G_AddBot | `if ( !*model )`. | filled | `model.isEmpty`, the same truth-test form. |
| G_AddBot | `if ( !*s )`, the `gender` key. | filled | The same form. |
| G_AddBot | `if ( !*s )`, the `color1` key. | filled | The same form. |
| G_AddBot | `if ( !*s )`, the `color2` key. | filled | The same form. |
| G_AddBot | `if ( !*s )`, the `saber1` key. | filled | The same form. |
| G_AddBot | `if ( !*s )`, the `saber2` key. | filled | The same form. |
| G_AddBot | `if (!*s )`, the `personality` key, with both arms. | filled | The same form, with Raven's two `Info_SetValueForKey` arms. |
| G_AddBot | `G_GetStringEdString("MP_SVGAME", ...)` into an `inout CharBuf` parameter. | filled | `lookup.py sig G_GetStringEdString` now gives `(String, String) -> String`, so the call is Raven's line. The lookup tool warned that 40 stub signatures are stale, so the build must confirm this signature in `g_main.swift`. |
| Svcmd_BotList_f | `if ( !*name )`. | filled | `name` is a `CharBuf`, and `*name` is `name[0]`: `if name[0] == 0 { strcpy(&name, "Padawan") }`. |
| Svcmd_BotList_f | `if ( !*funname )`. | filled | The same form. |
| Svcmd_BotList_f | `if ( !*model )`. | filled | The same form. |
| Svcmd_BotList_f | `if (!*personality )`. | filled | The same form. |

## ai_main.swift

Totals: 0 filled, 3 stands, 0 blocked.

| Function | Reason | Verdict | Note |
|---|---|---|---|
| BotUpdateInput | `trap_EA_GetInput(bs->client, (float) time / 1000, &bi)` did not compile, because the trap takes an `OpaquePointer` and `bi` is a `BotInput` view. | stands | The guide gives a `void *` trap parameter a second overload only for a `char buf[N]`. It gives no form to pass a view's slot. Docket row 4. |
| BotAI | The pointer local `char *args`. | stands | `args` is a write cursor into `buf`, an `Int32` offset. The fill depends on the loop hole below. Docket row 5. |
| BotAI | `while( trap_BotGetServerCommand(client, buf, sizeof(buf)) )` did not compile, because the trap returns `(Int32, String)`. | stands | The guide gives the trap-and-copy form for an `if` test only, and no form for a `while` test. `RemoveColorEscapeSequences( args )` passes a pointer into `buf` to an `inout CharBuf` parameter, and the guide gives no form for that. Docket row 5. |

## GameWorld properties

None. No hole in the three files is a static local or a file-scope static.

## Docket rows

1. RemoveWP and RemoveWP_InTrail, three notes. Raven's `memset( gWPArray[i], 0, sizeof(gWPArray[i]) )` takes `sizeof` of a `wpobject_t *`, so it zeroes 4 bytes on Raven's 32-bit build and 8 bytes on a 64-bit build, which is `origin[0]` or `origin[0]` and `origin[1]`. Proposed form: a ruling names the pointer width the port follows, and the body zeroes those floats of `origin` by name, with one comment line that says what Raven wrote.
2. SavePathData, seven notes. The `char *` local `fileString` has a `NULL` store before its one `B_TempAlloc(524288)` store, and no read reaches the `NULL`. Proposed form: a `NULL` store that no read reaches before the allocator store drops, and the local takes the `CHARBUF_ALLOCS` form, `var fileString = CharBuf(524288)`, with `_ = B_TempAlloc(524288)` at Raven's store.
3. AcceptBotCommand, two notes. Raven walks the `String?` local `RequiredSArgument` by byte, `while (RequiredSArgument[i])`. Proposed form: a text local that a body walks by byte becomes a `CharBuf` at the walk, `let RequiredSArgumentBuf = CharBuf(RequiredSArgument!)`, as the guide does for a `String` parameter, and the walk reads that buffer.
4. BotUpdateInput, one note. Raven passes `&bi`, a `bot_input_t` scratch slot, to the `void *` parameter of `trap_EA_GetInput`. Proposed form: the trap gains a second overload that takes the view, `BotInput`, and hands the engine the view's slot inside the generated file, as the `CharBuf` overload does.
5. BotAI, two notes. Raven's `while( trap_BotGetServerCommand(client, buf, sizeof(buf)) )` tests a trap that returns `(Int32, String)` in a `while`, and `RemoveColorEscapeSequences( args )` passes a pointer into `buf`. Proposed form: the loop is `while true`, with the call and the `strcpy` into `buf` first and the test as a break, and `args` is an `Int32` offset whose callee takes an `at:` overload or a copy of the suffix that the body writes back.
