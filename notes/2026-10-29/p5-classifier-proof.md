# P5 classifier proof

Row P5 of `notes/2026-10-29/bg-pool-docket.md`. The question: why do the two `tempReadBuffer` locals of `Sources/JKAMP_BG/bg_vehicleLoad.swift` hold `UnsafeMutableRawPointer` when `CHARBUF_ALLOCS` names `BG_TempAlloc`?

## Verdict

No defect. The file predates the rule. The stem was adopted on 2026-09-25, and the drafter output is never written into an adopted stem. The drafter gives the CharBuf form for both functions today. The hand file did not get the change when `BG_TempAlloc` joined `CHARBUF_ALLOCS` on 2026-10-27.

## The drafter output today

`.venv/bin/python bodies.py --only BG_VehWeaponLoadParms` in `tools/oracle-closure` prints these lines:

- `var tempReadBuffer = CharBuf(MAX_VEH_WEAPON_DATA_SIZE)`
- `_ = BG_TempAlloc(MAX_VEH_WEAPON_DATA_SIZE)`
- `trap_FS_Read(&tempReadBuffer, len, f)`
- `tempReadBuffer[len] = 0`
- `strcat(&VehWeaponParms, tempReadBuffer, at: marker)`
- `BG_TempFree(MAX_VEH_WEAPON_DATA_SIZE)`

`bodies.py --only BG_VehicleLoadParms` prints the same form with `MAX_VEHICLE_DATA_SIZE`. The run writes only the store `table.sqlite`, which `.gitignore:11` ignores.

## Why the classifier accepts the two locals

`charbuf_alloc_names` at `tools/oracle-closure/draft_classification.py:362` accepts a `char *` local when every store is one `CHARBUF_ALLOCS` call at one constant size. `charbuf_alloc` at `:304-314` requires an integer literal after the macro expands. The parse reads the `_JK2MP` arm. In that arm, the one store of `tempReadBuffer` is `(char *)BG_TempAlloc(MAX_VEH_WEAPON_DATA_SIZE)` at `oracle/codemp/game/bg_vehicleLoad.c:1421`, and `:1513` for the twin. The macros are `0x20000` and `0x80000` at `:72-73`, so both are integer literals. The `gi.Malloc` store at `:1423` and the NULL store at `:1483` are in the `#else` arm, so the parse does not see them. The pass to `trap_FS_Read`, the byte store at `[len]`, and the `strcat` are reads, and the classifier keys only on stores. Raven's `saberName` at `NPC_stats.c:2352` and the `B_TempAlloc` locals of `ai_util.c` have the same shape. Thus no difference keeps the vehicle locals out.

## Why the hand file keeps the raw form

1. Commit `2740013` of 2026-09-25, "Eight bg stems adopted", spliced the drafter output into `bg_vehicleLoad.swift` and removed its generated header line. From then on, the generators leave the file alone (`docs/oracle-closure.md:40`).
2. Commit `476626c` of 2026-10-01 added `CHARBUF_ALLOCS = {"B_TempAlloc"}`. `BG_TempAlloc` was not in the set.
3. Commit `feb5ab4` of 2026-10-27 (row W10) added `BG_TempAlloc` and the comment line that names the `tempReadBuffer` locals.
4. `notes/2026-10-27/phase3-generators.md:58` records the W10 draft change for both functions. It also records that the stem is adopted, so the gate wrote no line of the file, and the file kept the `UnsafeMutableRawPointer` form.
5. The W10 ruling at `notes/2026-10-11/phase-2-walk.md:58` and `:113` says that the compile agent re-drafts `bg_vehicleLoad`. The hand-site group, `notes/2026-10-27/phase3-hand-sites.md:105`, carried only the `saberName` arms of `NPC_ParseParms`. Commit `92088c1` changed `NPC_stats.swift` and did not change the two `tempReadBuffer` sites.

The gap is in the hand-site list of W10, not in the classifier. The ruled form for `bg_vehicleLoad` did not reach the hand file.

## Consequence for P5

P5 is the hand application of a rule that is already ratified (W10). It is not a new form. The hand edit copies the six drafter lines above into the two functions of `bg_vehicleLoad.swift` at `:789-847` and `:864-922`. No generator change is necessary.

`docs/transcription.md:709` uses `tempReadBuffer[byte: len] = 0` as its example of the `b[byte:]` subscript through a raw allocation. After P5, no body has that form, so the example needs a new site or removal in the same change.
