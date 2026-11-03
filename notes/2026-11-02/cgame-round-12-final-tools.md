# The cgame transcription rounds, round 12, the final tool pass

The record of the twelfth cgame transcription round on 2026-11-02, the last tool rows of the cgame, on the branch `cgame-round-12-final-tools` off master `a69e79a`. The round closes the Port-notes, the `portMissing` lines, and the signature markers that the rounds 7 to 11 left in `Sources/JKAMP_CGameLogic/`.

## The rows

Ruled before the round. Each row is one commit or a tool commit and a body commit, and the checks ran once after the last row.

- Row 4. `Display_CaptureItem` takes its arguments since R49, so CG_KeyEvent stores `Display_CaptureItem(cgs.cursorX, cgs.cursorY)` into `cgs.capturedItem` as Raven wrote it. Commit b620640.
- Row 3. A second `pointOrientation(at:)` points the vehicle orientation at the `lerpAngles` of a centity. The first overload is the hand file `Sources/JKAMP/Vehicle+Orientation.swift`, and the centity view lives in the cgame view target, so the second overload is the hand file `Sources/JKAMP_CGame/Vehicle+Orientation.swift`. CG_ClipMoveToEntities saves `m_vOrientation` in the `old` local, points it at the centity, and restores it, the form of Raven. The body adds no AI line. Commit ff2c194.
- Row 1, the tool part. `veh_damage_t` was already in `cg_types.h` with its CGAME_ROOTS row and the `Veh_damage` view. `tables.py` copies `vehDamageData` of `cg_draw.c:2425` into `cg_tables.c`, `cg_tables.h` declares it, and `CGameTables.swift` reaches it as a `Slots<Veh_damage>`, the itemFlags form. Commit 4971f45.
- Row 2, the tool part. `spelling.py` gives a non-const `vec2_t` parameter `inout JKAShared.vec2_t` by the `vec3_t` rule, and a `vec2_t uv[N]` parameter `inout [JKAShared.vec2_t]` by the axis rule. The RETURNS kind `vec4` gives CG_FadeColor `JKAShared.vec4_t?`, the twin of the `vec3` kind. The guide takes the three rows. Commit 4c6c40f.
- Row 5, the tool part. The RETURNS kind `opaque` gives CG_G2WeaponInstance `OpaquePointer?`, and `LIBC_SPELLINGS` spells `stricmp` as `Q_stricmp`. Commit 01633f5.
- Row 6, the keyword hash. The PARAMS kinds `keyword_buckets`, `keyword_buckets_mut`, and `row_index`, and the RETURNS kind `row_index`, give the skeleton the hand signatures of KeywordHash_Add and KeywordHash_Find with the `rows` parameter, so a readoption keeps them. Commit 7ac8565.
- The generator sequence. `extract.py` over the eight merge modules, `merge.py`, `tables.py`, `check.sh`, `reexport.py`, and `views.py`, `traps.py`, `channel.py`, `skeleton.py`, and `manifest.py` for both units. `cg_tables.c` takes `vehDamageData`, and the manifests take the run's output. No view, trap, re-export, or skeleton file changed. Commit dcebf29.
- Row 2, the signature commit. Rule 15. Vector2Set takes `inout JKAShared.vec2_t`, and the three signature markers close. Commit c247cc8.
- Row 1, the body. CG_DrawVehicleDamage reads `vehDamageData[index]` and calls `Menu_FindItemByName`, and both notes close. Commit b5f6ef6.
- Row 2, the bodies. CG_DoGlassQuad, CG_CalcBiLerp, and Vector2Set take the draft, and the four Vector2Set calls of CG_DoGlass pass `&biPoints[n]`. CG_FadeColor returns the vector by value, with one rule 24 line, because Raven returns the address of a static `vec4_t`. Commit d7c133b.

`lookup.py --unit mp-cgame sig` gives each hand signature of the rows: CG_FadeColor, CG_DoGlassQuad, CG_CalcBiLerp, Vector2Set, CG_G2WeaponInstance, KeywordHash_Add, and KeywordHash_Find.

## The gate lines

- `check.sh`: 0 errors in every target.
- The tool tests: 96 tests, OK, 14 skipped.
- `draftcheck.py --unit mp-cgame --stem cg_players,cg_draw`:
  - `cg_players: 59 of 85 hand functions replaced, 26 kept, 62 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
  - `cg_draw: 57 of 100 hand functions replaced, 43 kept, 73 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `swift build` passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

## The snapshot moves

The check against `~/.cache/jka-swift/snapshot-stage-two-shared` moved three files, and each move comes from a round that landed on master before this one. The NPC_senses draft passes `&level.alertEvents[i]` to `memmove`, because round 6 added `memmove` to `CString.swift` and the registry reads its `inout` first parameter. The `bg_lib` manifest drops `public` from the memmove stub row for the same reason. The `bg_misc` manifest moves its Swift lines by 13, the `forceMasteryLevels` table of round 10. The rows of this round move no snapshot byte, because the snapshot holds the bg, game, and shared stems. The cache was refreshed in place.

## The counts

Over `Sources/JKAMP_CGameLogic/`: 5 `Port-note:` lines, 1 `portMissing(` line, and 0 `TODO: Port signature` markers.

- The five Port-note lines are the rule 19 lines of ui_shared that round 6 recorded: UI_Alloc, Item_SetFocus, UI_InsertG2Pointer, ItemParse_cvarStrList, and ItemParse_cvarFloatList. Rule 24 keeps the `Port-note:` prefix on a rule 19 line, and none of them has a `portMissing` marker.
- The one `portMissing` line is the dead stub of CG_ParticleExplosion in `cg_marks.swift`, R17.

## The rows left open

- R60 arm 2. The cursor sweep of `table.py` reads a `char *` local as a cursor only over a named buffer, and the drafter spells every cursor through that buffer name. A stepped local over a text a call returns or a `char *` field has no buffer name, so the arm needs a new cursor row, a new store form, and new reads in the drafter. That is more than an hour of work, and the arm stays open.
- The `CG_G2PlayerAngles` copy site and the R3 tuple form in a `while` test, from the round 5 record.
