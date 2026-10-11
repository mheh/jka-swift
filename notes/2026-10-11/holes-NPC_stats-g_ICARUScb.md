# Hole round: NPC_stats and g_ICARUScb

NPC_stats.swift: 20 filled, 0 stands, 4 blocked.
g_ICARUScb.swift: 21 filled, 4 stand, 3 blocked.

## NPC_stats.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| NPC_Precache | `char *patch` local | filled | A write cursor over `sound` is an `Int32` offset, so the local is `var patch: Int32?`. |
| NPC_Precache | store into `patch`, `snd` arm | filled | `patch = strstr(sound, "/")`, the offset form of `strstr`. |
| NPC_Precache | read of `patch`, `snd` arm | filled | `if let patch { sound[patch] = 0 }`. |
| NPC_Precache | store into `patch`, `sndcombat` arm | filled | Same form. |
| NPC_Precache | read of `patch`, `sndcombat` arm | filled | Same form. |
| NPC_Precache | store into `patch`, `sndextra` arm | filled | Same form. |
| NPC_Precache | read of `patch`, `sndextra` arm | filled | Same form. |
| NPC_Precache | store into `patch`, `sndjedi` arm | filled | Same form. |
| NPC_Precache | read of `patch`, `sndjedi` arm | filled | Same form. |
| NPC_ParseParms | `char *patch` local | filled | `var patch: Int32?`. |
| NPC_ParseParms | store into `patch`, `snd` arm | filled | `patch = strstr(sound, "/")`. |
| NPC_ParseParms | read of `patch`, `snd` arm | filled | `if let patch { sound[patch] = 0 }`. |
| NPC_ParseParms | store into `patch`, `sndcombat` arm | filled | Same form. |
| NPC_ParseParms | read of `patch`, `sndcombat` arm | filled | Same form. |
| NPC_ParseParms | store into `patch`, `sndextra` arm | filled | Same form. |
| NPC_ParseParms | read of `patch`, `sndextra` arm | filled | Same form. |
| NPC_ParseParms | store into `patch`, `sndjedi` arm | filled | Same form. |
| NPC_ParseParms | read of `patch`, `sndjedi` arm | filled | Same form. |
| NPC_ParseParms | `WP_SaberParseParms( saberName, &NPC->client->saber[0] )` does not compile | blocked | `saberName` is a `char *` from `BG_TempAlloc(4096)`. The `CHARBUF_ALLOCS` form makes it `CharBuf(4096)`, but only if `rulings.py` lists `BG_TempAlloc`. The draft kept a raw pointer, so the list probably does not hold it. `rulings.py` is outside the read set. |
| NPC_ParseParms | `npcSaber1 = G_ModelIndex(va("@%s", saberName))` does not compile | blocked | Same missing fact as the row above. |
| NPC_ParseParms | `WP_SaberParseParms( saberName, &NPC->client->saber[1] )` does not compile | blocked | Same missing fact. |
| NPC_ParseParms | `WP_RemoveSaber( NPC->client->saber, 1 )` | filled | The lookup tool gives `Client.saber` as `Slots<JKAMP.SaberInfo>`, so the caller passes the `Slots` it holds: `WP_RemoveSaber(NPC.client!.saber, 1)`. The old note said Swift holds one record, which is not correct. |
| NPC_ParseParms | `npcSaber2 = G_ModelIndex(va("@%s", saberName))` does not compile | blocked | Same missing fact as the first saber row. |
| NPC_ParseParms | `NPC->NPC_type = (char *)NPCName` does not compile | filled | `NPC.NPC_type = NPCName.text`. The `char *` field store interns the text of the cursor. |

## g_ICARUScb.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| G_DebugPrint | `va_list argptr` local | filled | The local drops under the variadic form. |
| G_DebugPrint | `va_start` | filled | Drops under the variadic form. |
| G_DebugPrint | `vsprintf (text, format, argptr)` | filled | `strcpy(&text, JKAShared.format(format, args))`. The module name stands before `format`, because the parameter of that name hides the function. |
| G_DebugPrint | `va_end` | filled | Drops under the variadic form. |
| G_DebugPrint | `char *buffer` local | filled | A read cursor over `text`, `var buffer = TextCursor()`. |
| G_DebugPrint | `buffer = (char *) text` | filled | `buffer = TextCursor(text)`. |
| G_DebugPrint | `buffer += 5` | filled | `buffer.advance(by: 5)`. |
| G_DebugPrint | read of `buffer` in `Com_Printf` | filled | `buffer.text`, and `script_targetname!` because Raven reads the field with no guard. |
| Q3_GetAnimBoth | store of `Q3_GetAnimLower( ent )` | filled | The text-local rule makes `lowerName` a `String?`. Raven's test is `lowerName == nil \|\| lowerName!.isEmpty`, and the later reads unwrap. |
| Q3_GetAnimBoth | store of `Q3_GetAnimUpper( ent )` | filled | Same form for `upperName`. |
| Q3_PlaySound | `COM_StripExtension( (const char *)finalName, finalName )` | filled | `COM_StripExtension(String(finalName), &finalName)`. |
| Q3_PlaySound | `soundHandle = G_SoundIndex( (char *) finalName )` | filled | `G_SoundIndex(String(finalName))`. |
| Q3_PlaySound | `G_Sound( ent, voice_chan, G_SoundIndex((char *) finalName) )` | filled | `G_Sound(ent!, voice_chan, G_SoundIndex(String(finalName)))`. |
| Blocked_Mover | NULL `dir` into `G_Damage` | filled | `G_Damage` takes `inout vec3_t?`, so the caller declares `var dir: vec3_t? = nil` and passes `&dir`. |
| Q3_GetString | `*value = (char *) Q3_GetAnimBoth( ent )` | stands | No form for an `out_string` parameter set from a callee that can return NULL. See docket row 1. |
| Q3_GetString | `if ( !value \|\| !value[0] ) return 0` | stands | `value[0]` is the `char *` the store set, so this is the NULL test of docket row 1. |
| Q3_SetNavGoal | `TAG_GetOrigin2( ... ) == qfalse` | stands | `TAG_GetOrigin2` returns `Int32`, and `qfalse` is a `Bool`. No form compares an `int` with `qfalse`. See docket row 2. |
| Q3_GameSideCheckStringCounterIncrement | `char *numString` local | filled | A read cursor, `var numString = TextCursor()`. |
| Q3_GameSideCheckStringCounterIncrement | `numString = (char *)&string[1]`, `+` arm | filled | `numString = string` and `numString.advance()`, the cursor one byte on. |
| Q3_GameSideCheckStringCounterIncrement | `val = atof( numString )` | filled | `val = atof(numString.text)`. |
| Q3_GameSideCheckStringCounterIncrement | `numString = (char *)&string[1]`, `-` arm | filled | Same form. |
| Q3_GameSideCheckStringCounterIncrement | `val = atof( numString ) * -1` | filled | `val = atof(numString.text) * -1`. |
| Q3_SetCount | assignment inside an `if` test | filled | The store lifts to `val = Q3_GameSideCheckStringCounterIncrement(data)`, and the test is `if val != 0`. The arms are `` `self`!.count += Int32(val) `` and `` `self`!.count = atoi(data) ``. |
| Q3_SetParm | `memset( ent->parms, 0, sizeof(parms_t) )` | filled | The record's own size, so `ent!.parms!.clear()`. |
| Q3_SetParm | assignment inside an `if` test | stands | The lift has a form, but both arms write bytes into one row of `parm`, a `char[16][64]` field that the view gives as `Slots<String>`. No form makes a `CharBuf` of one row. See docket row 3. |
| Q3_SetCaptionTextColor | `SetTextColor(textcolor_caption,color)` | blocked | The generated `GameVariables` property for Raven's `vec4_t textcolor_caption` has the type `[Float]`, and `SetTextColor` takes `vec4_t`. The fix is in the generator, a file this round may not edit. |
| Q3_SetCenterTextColor | `SetTextColor(textcolor_center,color)` | blocked | Same cause for `textcolor_center`. |
| Q3_SetScrollTextColor | `SetTextColor(textcolor_scroll,color)` | blocked | Same cause for `textcolor_scroll`. |

## GameWorld properties

None. No hole in the two files names a static local or a file-scope static.

## Docket rows

1. Q3_GetString, `SET_ANIM_BOTH` arm. Raven sets the `out_string` parameter `*value` from `Q3_GetAnimBoth`, which returns `String?`, and then returns 0 when the result is NULL. A force unwrap traps where Raven returns 0, so the never-null store form does not fit. Proposed form: `guard let text = Q3_GetAnimBoth(ent!) else { return 0 }` and then `value = text`, with Raven's test of the pointer itself dropped as an `inout` guard.
2. Q3_SetNavGoal. Raven compares the `int` return of `TAG_GetOrigin2` with `qfalse`, and Swift has `qfalse` as a `Bool`. No form compares an `Int32` with a `qboolean` constant. Proposed form: the comparison spells the constant's value, `== 0` for `qfalse` and `== 1` for `qtrue`, with one comment line that names Raven's constant.
3. Q3_SetParm. Raven writes into one row of `parms_t.parm`, a `char[16][64]` field, with `Com_sprintf`, `strncpy`, and a byte store at index 63. The view gives the field as `Slots<String>`, and the `nameBuffer` form covers only a one-row `char name[N]` field. Proposed form: `views.py` writes a `parmBuffers` accessor that gives each row as a `CharBuf` of 64 bytes, with a setter that stores the bytes back, so a body writes `Com_sprintf(&ent!.parms!.parmBuffers[parmNum], ...)`.
