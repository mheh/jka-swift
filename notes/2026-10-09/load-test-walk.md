# The first load test walk

The walk of the five docket rows in `load-test.md`, under the ratification-walk skill. Rows 2 and 3 were closed before the walk by the q_shared rulings Q2 and Q4 in `q_shared-holes-walk.md`. The other three were ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| L1 | ratified as proposed | `G_LogPrintf` writes `strcpy(&string, format(fmt, args), at: 7)`. The `va_list` local, `va_start`, and `va_end` drop under the variadic form. The guide's `vsprintf` form of Q2 gains the offset case. The four holes fill. |
| L2 | closed by Q2 | The `vsprintf` of `Com_sprintf`. |
| L3 | closed by Q4 | The `Q_strncpyz(_:_:_:at:)` overload that `Q_strcat` needs, which blocks `WP_SaberLoadParms` in every map load. |
| L4 | ratified as proposed | `tools/load-test.sh` keeps the 60-second alarm. `G_LogWeaponOutput` fills in the g_log hole round, because a clean `+quit` needs it. |
| L5 | ratified as proposed | `tools/load-test.sh` sets `dedicated` to 1, a LAN server with no master heartbeats. |

## The work the rulings order

1. The offset case of the `vsprintf` form in `docs/transcription.md`, after the q_shared rulings build writes the form.
2. The four `G_LogPrintf` fills and the `dedicated 1` line of the script.
3. The second load test run, which continues the trap loop from `WP_SaberLoadParms` once Q4 lands.

## The second run

The walk of the one docket row in the section "The second run" of `load-test.md`. The record names it S1, and it is M1 here, because `q_shared-rulings-walk.md` of the same day holds S1.

| Row | Verdict | What the ruling orders |
|---|---|---|
| M1 | ratified as proposed | A `memcpy` of `strlen + 1` bytes of a String is a `strcpy`. In `G_AddSpawnVarToken`, `dest` becomes a write cursor, an `Int32` byte offset at `level.numSpawnVarChars`. The copy is `strcpy(&level.spawnVarCharsBuffer, string, at: dest)`, and the return is `String(level.spawnVarCharsBuffer[dest...])`. The form joins the "C string functions" section of the guide, and the four holes fill. The callers store the String into `level.spawnVars`, so the pointers point into the string pool and not into `spawnVarChars`. The text is the same, and the buffer keeps Raven's count. |

## The third run

The walk of the two docket rows in the section "The third run" of `load-test.md`. Both were ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| T1 | ratified as proposed | `memoryPool` joins `HAND_VARS` in `rulings.py` as one raw allocation of `POOLSIZE` bytes that the world owns, the shape of `bg_pool`. `G_Alloc` writes `let p: UnsafeMutableRawPointer`, `p = memoryPool + allocPoint`, and `return p`. The `return NULL` after `G_Error` drops under rule 22. This is the smallest pool change that lets init run. The deeper pool work waits under the running-game rule. |
| T2 | ratified as proposed | The two stores of `defaultString` in `G_SpawnString` become `if defaultString != nil { out = defaultString! }`, the out-string NULL form of the guide. |

## The fourth run

The walk of the two docket rows in the section "The fourth run" of `load-test.md`. The record names them F1 and F2, and they are P1 and P2 here, because `dispatch-fill-2-walk.md` of the same day holds F1 to F5. Both were ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| P1 | ratified as proposed | The first body line of `G_ParseInfos` is `var buf = TextCursor(buf)`, by analogy with the guide's `let s1 = CharBuf(s1)`. The three calls read `COM_Parse(&buf)`, `COM_ParseExt(&buf, true)`, and `COM_ParseExt(&buf, false)`. The signature and the callers stay. |
| P2 | ratified as proposed | In the `CHARBUF_ALLOCS` shape: `_ = G_Alloc(strlen(info) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1)` keeps Raven's pool count, then `infos[infos.startIndex + count] = String(info)` and `count += 1`. The NULL test drops under rule 22. |

## The fifth run

The walk of the one docket row in the section "The fifth run" of `load-test.md`, and of the helper the builder added without a ruling. Both were ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| V0 | ratified as proposed | The disfavored global `+` in `Int32Indexing.swift` that takes an `Int` and any C integer and returns an `Int` stays, as the form for an `Int` index plus a C integer count. Its guide line sits beside the array index rule. |
| V1 | ratified as proposed | In `G_LoadArenas`, the buffer takes the size of Raven's slot: `var info = CharBuf(strlen(g_arenaInfos[n]) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1)`, then `strcpy(&info, g_arenaInfos[n])`, `Info_SetValueForKey(&info, "num", va("%i", n))`, and `g_arenaInfos[n] = String(info)`. The form joins the guide beside the `String` caller form. |

## The sixth run

The walk of the one docket row in the section "The sixth run" of `load-test.md`. The user ruled it on 2026-10-11.

| Row | Verdict | What the ruling orders |
|---|---|---|
| W1 | ratified as proposed | One guide line beside the data-initializer rule: an array whose brace list is shorter than its declared bound takes one `0` row per slot that C zeroes, after Raven's last row, under a comment that names Raven's row count and the bound. The fill of `botGlobalNavWeaponWeights` in a255995 stands as the exemplar. The Port-note of `WeaponAttackAnim` in `bg_local.swift` becomes the same comment. |

## The work the rulings order

1. The guide line in `docs/transcription.md` beside the data-initializer rule.
2. The `WeaponAttackAnim` comment in `bg_local.swift`, in place of its Port-note.
