# bg docket walk of 2026-09-18

This walk ruled on the ten candidate rows that the stop walk left at fb812fd. The gate at that commit reads 21 holes over nine bg stems with zero defects. Each row closed on a typed ruling under the ratification-walk shape.

## Ledger

| Row | Subject | Verdict |
|---|---|---|
| 1 | VehicleTable as a twelfth C storage table | ratified as proposed |
| 2 | The animset edges in bg_panimate | replaced: a Slots of one record, passed and stored as its first element |
| 3 | A whole record in a format argument | ratified as proposed |
| 4 | The siegeTeam_t **teamPtr shape in bg_saga | replaced: an inout view parameter chosen by the caller |
| 5 | descBuffer->desc into a written char * parameter | ratified as proposed |
| 6 | teamInfo twice inout inside one test | ratified as proposed |
| 7 | memset over a CharBuf field of a record | ratified as proposed |
| 8 | Generated bg_tables.c, and real bounds for the row 1 field Slots | ratified as proposed |
| 9 | A hoisted local for a shared subexpression in the drafter | ratified as proposed |
| 10 | ui stays outside every caller proof | ratified as proposed |

## The rulings in full

**Row 1.** VehicleTable in bg_vehicleLoad becomes a C storage table, the same shape as row 4 of the stop walk. The table moves into `Sources/CJKAMP/bg_tables.c` with a Slots bind in `Sources/JKAMP/BgTables.swift`. The two bg_vehicleLoad holes close through the existing sweep.

**Row 2.** The two one-record edges of the Slots ruling in bg_panimate take a Slots of one record. `animset = BG_AnimsetAlloc()` stores the record as the first element of the Slots target. `BG_AnimsetFree(animset)` passes the Slots, and the callee reads its first element. Four holes.

**Row 3.** When Raven passes a whole record to a `%s` format, as PM_DebugLegsAnim does with `animTable[n]`, the draft writes `.name`, the record's first field. The docs state this as a divergence from Raven's bytes: Raven passes the record's address and the format reads the first field, and the port names that field. Two holes.

**Row 4.** A pointer to one of two file-scope variables, written through, crosses as an inout view parameter chosen by the caller. This covers the `siegeTeam_t **teamPtr` shape across three functions in bg_saga. Nine holes.

**Row 5.** A String field of a record passed as a write target to a `char *` parameter crosses as an inout CharBuf through the buffer trap overload, and the record's field is a var. This covers `descBuffer->desc` in bg_saga. One hole.

**Row 6.** When Raven passes one buffer inout to two calls inside one condition, the draft splits the condition. The first call lands in its own statement with its result in a local, and the condition reads the local and the second call. This covers `teamInfo` in bg_saga. One hole.

**Row 7.** A memset with a 0 value over a view's CharBuf field becomes a zero-fill on the field, with the same form as Slots.zero(). The CharBuf surface gains the zero-fill and the drafter maps the memset to it. This covers uiPortrait in bg_saga. One hole.

**Row 8.** The tool generates `bg_tables.c` in place of the hand file, with the per-file define such as `_JK2MP` and the offset-macro pragma. The generator covers twelve tables once row 1 lands. The field Slots from row 1 of the stop walk get real bounds, `MAX_ANIMATIONS` and `MAX_CLIENTS`, as a name rule in rulings.py.

**Row 9.** The drafter hoists a subexpression that Raven reads once but the draft emits more than once. The read lands in one local ahead of its first use. The case on record is BG_MySaber, where the draft calls `bgClientSaber(of:at:)` three times.

**Row 10.** The ui unit stays outside every caller proof until a ui parse exists. A proof over callers covers game and cgame. No sweep guesses at ui call sites before then.
