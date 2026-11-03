# The cgame transcription rounds, round 9, ten middle stems

The record of the ninth cgame transcription round on 2026-11-02, ten stems, on the branch `cgame-round-9-middle` off master `07f5874`: `cg_drawtools`, `cg_newDraw`, `cg_effects`, `cg_servercmds`, `cg_localents`, `cg_consolecmds`, `FighterNPC`, `cg_predict`, `cg_saga`, and `cg_strap`.

## The adoption

The draft gate over the ten stems ended at 0 defects. The gate lines:

- `cg_drawtools: 24 of 24 hand functions replaced, 0 kept, 11 holes, 0 cascade errors, 0 defects, 3 compile holes over 2 passes`
- `cg_newDraw: 22 of 24 hand functions replaced, 2 kept, 23 holes, 0 cascade errors, 0 defects, 7 compile holes over 2 passes`
- `cg_effects: 22 of 22 hand functions replaced, 0 kept, 14 holes, 0 cascade errors, 0 defects, 5 compile holes over 2 passes`
- `cg_servercmds: 21 of 21 hand functions replaced, 0 kept, 23 holes, 0 cascade errors, 0 defects, 4 compile holes over 2 passes`
- `cg_localents: 21 of 21 hand functions replaced, 0 kept, 4 holes, 0 cascade errors, 0 defects, 4 compile holes over 3 passes`
- `cg_consolecmds: 18 of 18 hand functions replaced, 0 kept, 2 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `FighterNPC: 17 of 20 hand functions replaced, 0 kept, 5 holes, 0 cascade errors, 0 defects, 2 compile holes over 2 passes`
- `cg_predict: 14 of 14 hand functions replaced, 0 kept, 17 holes, 0 cascade errors, 0 defects, 2 compile holes over 2 passes`
- `cg_saga: 13 of 13 hand functions replaced, 0 kept, 7 holes, 0 cascade errors, 0 defects, 5 compile holes over 2 passes`
- `cg_strap: 12 of 12 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`

`adopt.py` adopted each stem, and commit abe1a89 holds the ten files with 106 Port-notes. The build passed at the adoption.

## The hole rounds

Three agents took disjoint files, and the coordinator reviewed every edit before the commit. One commit per stem holds the round, and cg_strap had no note.

| Stem | Commit | Notes closed | Notes left |
|---|---|---|---|
| cg_drawtools | d54e329 | 11 | 0 |
| cg_effects | 24de504 | 10 | 4 |
| cg_newDraw | 816ac31 | 22 | 1 |
| cg_servercmds | a7296d6 | 23 | 0 |
| cg_localents | 72526d7 | 4 | 0 |
| cg_consolecmds | 7fe6ea5 | 2 | 0 |
| FighterNPC | a39caa4 | 5 | 0 |
| cg_predict | c8e5708 | 14 | 3 |
| cg_saga | f5db1f9 | 7 | 0 |

The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

## The shapes

- `cgs.clientinfo + i` is the slot `cgs.clientinfo[i]`.
- A static local is a CGameWorld property with a forward in the stem file. `seed` of CG_SmokePuff keeps Raven's name. The two `s` locals of cg_newDraw take the function name as a suffix, `s_CG_GetKillerText` and `s_CG_GetGameStatusText`, and each function carries one AI line, because Raven's `s` points into the va ring and the world keeps a copy.
- A `const char *` walk is a TextCursor, or a CharBuf copy with an `Int32` offset. A write through a pointer into a buffer is an `Int32` write cursor, as in CG_Text_Paint_Limit.
- `strstr` from a cursor searches the suffix and adds the offset back.
- A trap that fills a buffer from its own suffix, `trap_SP_GetStringTextString(loc+1, loc, N)`, copies the returned text into the buffer.
- A memset of a whole array is `zero()`, and of a record is the view's `clear()`.
- A record store through a pointer, `*tr = trace`, is `copy(from:)`.
- The axis calls use the Slots forwards of AxisCopy and AnglesToAxis. RotateAroundDirection takes the copy and store-back of cg_players.
- `(bgEntity_t *)cg_entities` is `BgEntity(cg_entities[0])`.
- A store of a player state's `vehOrientation` into `m_vOrientation` is `pointOrientation(at:)`.
- `#ifdef QAGAME` in the borrowed FighterNPC takes the cgame branch.
- Two sites carry a rule 19 comment and no Port-note. The teamVoteString store bounds the text to its row, where Raven's 2048 bound lets the NUL pad of row 0 clear row 1 and the pad of row 1 overrun the array. The walk of CG_ParseSiegeExtendedDataEntry stops at the NUL, where Raven steps past it and reads the next byte.

## The notes left

- cg_effects, 4 notes in CG_DoGlass. The generated Vector2Set takes its `vec2_t` as `[Float]` by value, so Raven's write does not reach `biPoints`. A rule 15 signature commit to `inout vec2_t` closes them.
- cg_predict, 3 notes in CG_ClipMoveToEntities. Raven saves `m_vOrientation`, points it at `cent->lerpAngles`, and restores it. `pointOrientation(at:)` points only at a player state, and a centity form needs a view method in the cgame view target.
- cg_newDraw, 1 note in CG_KeyEvent. The ui_shared stub of Display_CaptureItem has a signature marker and takes no arguments.
- Three stubs keep a `TODO: Port signature` marker and a portMissing line with no Port-note: CG_FadeColor of cg_drawtools, and CG_DoGlassQuad and CG_CalcBiLerp of cg_effects.
- The teamVoteString divergence changes what a player sees when row 0 changes, and it waits for a ruling.

## Drafter rows found

- `ci = cgs.clientinfo + sortedTeamPlayers[i];` drafts as `ci = cgs.clientinfo[sortedTeamPlayers[i]]`.
- `i < sizeof( commands ) / sizeof( commands[0] )` drafts as `i < commands.count`.
- `VectorClear( hcolor );` over a `vec4_t` drafts as `hcolor[2] = 0`, `hcolor[1] = hcolor[2]`, `hcolor[0] = hcolor[1]`.
- `memcpy( color, setColor, sizeof(color) );` over a `vec4_t` drafts as `color = setColor!`.
- `color[3] = setColor[3];` over an optional parameter drafts as `color[3] = setColor![3]`.
- `if (p && *p)` over a `String` local drafts as `if !p.isEmpty`.
- `&cg.spectatorList[off]` at a `String` parameter drafts as `String(cg.spectatorListBuffer[off...])`.
- `static const char *s = "";` that the function returns drafts as a world property and a forward `s_<function>`.
- `static int seed = 0x92;` drafts as a world property `var seed: Int32 = 0x92` and a forward.
- `if ( trap_GetServerCommand( ++x ) )` drafts as `x += 1` and `if trap_GetServerCommand(x) {`.
- `text[l++] = text[i];` drafts as `text[l] = text[i]` and `l += 1`.
- `if (text[i] == '\x19')` drafts as `if text[i] == Int32(ascii: "\u{19}")`.
- `trap_SP_GetStringTextString(loc+1, loc, N);` drafts as `strcpy(&loc, trap_SP_GetStringTextString(String(loc[1...]), N).1)`.
- `const char *s = F(...); if (!s) break; s++;` over a `String?` return drafts as `var s = F(...).map { TextCursor(CharBuf($0)) } ?? TextCursor()`, `if s.isNull { break }`, and `s.advance()`.
- `char *str = (char *)conStr;` that only reads drafts as `var str = TextCursor(CharBuf(conStr))`.
- `n = strstr(o, "=");` over a cursor drafts as `if let found = strstr(o.buf[o.offset!...], "=") { n = o.offset! + found } else { n = nil }`.
- `memset( cg.scores, 0, sizeof( cg.scores ) );` drafts as `cg.scores.zero()`.
- `if (!buf || !buf[0])` over a local `char[N]` drafts as `if buf[0] == 0`.
- `x = (f() > 0) ? qtrue : qfalse;` drafts as `x = (f() > 0) ? true : false`.
- `memset( le, 0, sizeof( *le ) );` over an optional local drafts as `le!.clear()`.
- `*tr = trace;` drafts as `tr.copy(from: trace)`.
- `memset(&cgSendPSPool[0], 0, sizeof(cgSendPSPool));` drafts as `cgSendPSPool.zero()`.
- `cg_pmove.baseEnt = (bgEntity_t *)cg_entities;` drafts as `cg_pmove.baseEnt = BgEntity(cg_entities[0])`.
- `veh->m_pVehicle->m_vOrientation = &cg.predictedVehicleState.vehOrientation[0];` drafts as `veh!.m_pVehicle!.pointOrientation(at: cg.predictedVehicleState)`.
- `AxisCopy( axisDefault, re->axis );` drafts as `AxisCopy(axisDefault, re!.axis)`.
- `#ifdef QAGAME && X #endif &&` in a borrowed game file under the cgame unit drafts with the clause dropped.
- `vec2_t biPoints[4];` drafts as `var biPoints = [vec2_t](repeating: vec2_t(), count: 4)`.
- `t_e > le->refEntity.shaderRGBA[3]` drafts as `t_e > Float(le.refEntity.shaderRGBA[3])`.
