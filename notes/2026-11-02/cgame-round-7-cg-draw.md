# The cgame transcription rounds, round 7, cg_draw

The record of the seventh cgame transcription round on 2026-11-02, one stem, `cg_draw`, on the branch `cgame-round-7-cg-draw` off master `07f5874`. The file was adopted in round 1 and kept its bodies through rows R4 to R8, so the round starts from 160 Port-notes and 161 `portMissing` lines.

## The hole round

Commit f70f405 is the rule 15 signature commit. Raven's `chatBoxItem_t **array` of CG_ChatBox_ArrayInsert is a C array of struct pointers that the function fills, so the parameter takes `inout [ChatBoxItem?]`, the signature row of the guide. The adopted file keeps the hand signature.

Commit 7748303 closed 158 of the 160 notes by hand and wrote two rule 19 notes. cg_draw.swift holds 4 Port-notes and 2 `portMissing` lines. The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

## The shapes

- 49 calls into ui_shared. Menu_FindItemByName, Menus_FindByName, Menus_CloseByName, and Menu_PaintAll are stubs of `ui_shared.swift` since R45, so each call reads as Raven wrote it. A menu local that is optional takes the force unwrap, and Raven's `(menuDef_t *)` cast drops. A `char itemName[64]` argument passes `String(itemName)`.
- 45 color calls. CG_DrawRect, CG_FillRect, CG_DrawStringExt, and CG_DrawHealthBarRough take `vec4_t?` since R4, so the call passes the `vec4_t` local. A `float[4]` local crosses by its four elements under R2, and an `int` passed to a `float` parameter takes `Float(...)`, and the mirror case takes `Int32(...)`.
- 19 reads of `g_color_table[ColorIndex(COLOR_X)]`, which the drafter printed with no operator. The table and ColorIndex are in JKAShared, so the read is Raven's text. A VectorCopy into a `vec4_t` is three element stores, the expansion of the macro, because `b = a` would copy the alpha too.
- 3 R7 memcpy sites take the plain store from the table row.
- 11 static local notes. `flip` of CG_DrawZoomMask, and `previousTimes`, `index`, `previous`, and `lastupdate` of CG_DrawFPS, are properties of CGameWorld under the cg_draw.c MARK with forwards in cg_draw.swift. The `unsigned short` stores truncate and the reads widen, the narrow local rule.
- 12 fade color notes. `fadeColor` of CG_DrawPickupItem and `color` of CG_DrawCenterString and CG_DrawCrosshairNames are `vec4_t?` under R8. Raven's NULL test is `== nil`, and a read of an element takes the force unwrap.
- 9 force power and siege notes. `forcePowerSorted`, BG_ProperForceIndex, and BG_SiegeFindClassByName are in JKAMP_BG. A `continue` in a `for` runs the step first.
- CG_Draw3DModel calls the `Slots<vec3_t>` forwards of AnglesToAxis and AxisClear from round 5.
- CG_DrawHealthBarRough reads `color1![0]`, the element of the `vec4_t?` parameter.
- UI_ParseAnimationFile passes `Slots(record: animset)`, the Slots of one record.
- CG_DrawInvenSelect takes the R3 tuple form, with `Q_strupr(&upperKey)` before the trap, as `cg_event.swift` does.
- CG_DrawVote spells `stricmp` as `Q_stricmp` with one comment line. Raven's `stricmp` is the platform's `strcasecmp`, and the zero test is the same over ASCII.
- CG_Draw2D splits `fallTime /= (FALL_FADE_TIME/2)` into a typed `Int32` term, because Swift finds two readings of the divide.
- `menuScoreboard` takes Raven's `NULL` initializer as `nil`, because no cgame body assigns it.
- CG_ChatBox_ArrayInsert and its caller pass `&drawThese` under the new signature.

## The notes left

- CG_DrawVehicleDamage, two notes. `vehDamageData` is a table of `veh_damage_t`, a struct Raven defines in cg_draw.c. Its stub entry names the C storage form that `tables.py` writes, and that tool work is outside a hole round.
- CG_DrawForceSelect, two rule 19 notes and no `portMissing`. After the wrap to `MAX_SHOWPOWERS`, Raven reads `forcePowerSorted[18]`, one past the end, which is the first slot of `forcePowerDarkLight` in his data. The Swift array traps there, and the loop reaches the wrap whenever the force select shows fewer powers than its side count. The defined behavior is a ruling for the user.

## Drafter rows found

- A read of a `vec4_t` table row through a function-like macro index prints with no operator.
  C: `trap_R_SetColor( g_color_table[ColorIndex(COLOR_RED)] );`
  Swift: `trap_R_SetColor(g_color_table[ColorIndex(COLOR_RED)])`
- VectorCopy into a `vec4_t` destination.
  C: `VectorCopy ( g_color_table[ColorIndex(COLOR_GREEN)], teamColor );`
  Swift: `teamColor[0] = g_color_table[ColorIndex(COLOR_GREEN)][0]`, and the same for 1 and 2.
- A static local becomes a CGameWorld property and a forward.
  C: `static int previous, lastupdate;`
  Swift: `var previous: Int32 { get { world.previous } set { world.previous = newValue } }`
- A pointer to one record passed to a parameter that takes the Slots.
  C: `return BG_ParseAnimationFile(filename, animset, isHumanoid);`
  Swift: `return BG_ParseAnimationFile(filename, Slots(record: animset), isHumanoid)`
- An element read of a `vec4_t?` parameter.
  C: `color3[0] = color1[0] * 0.5f;`
  Swift: `color3[0] = color1![0] * 0.5`
- `stricmp` as a `LIBC_SPELLINGS` row.
  C: `if ( stricmp("Duel", cgs.voteString+11)==0 )`
  Swift: `if Q_stricmp("Duel", String(CharBuf(cgs.voteString)[11...])) == 0 {`
- A `chatBoxItem_t **` parameter over a C array of struct pointers as a PARAMS row.
  C: `void CG_ChatBox_ArrayInsert(chatBoxItem_t **array, int insPoint, int maxNum, chatBoxItem_t *item)`
  Swift: `func CG_ChatBox_ArrayInsert(_ array: inout [ChatBoxItem?], _ insPoint: Int32, _ maxNum: Int32, _ item: ChatBoxItem)`
- A compound divide of a float by an integer quotient.
  C: `fallTime /= (FALL_FADE_TIME/2);`
  Swift: `let fadeHalf: Int32 = FALL_FADE_TIME / 2` and `fallTime /= fadeHalf`
- The R3 tuple form with an in-place call inside the trap argument.
  C: `if ( trap_SP_GetStringTextString( va("SP_INGAME_%s",Q_strupr(upperKey)), text, sizeof( text )))`
  Swift: `Q_strupr(&upperKey)`, then `let filledTest = trap_SP_GetStringTextString(va("SP_INGAME_%s", upperKey), Int32((text).count))`
- A file-scope pointer that no body assigns takes its initializer.
  C: `menuDef_t *menuScoreboard = NULL;`
  Swift: `nonisolated(unsafe) let menuScoreboard: MenuDef? = nil`

The ui_shared calls, the color calls, the fade color locals, and the force power names need no new row. Each one failed only because the draft came before R45, R4, R8, or the JKAMP_BG names, so a readoption of the stub drafts them.
