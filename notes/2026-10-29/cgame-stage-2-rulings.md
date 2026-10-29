# The stage 2 rulings of the MP cgame module

This record holds the two rulings the stage 2 builder asked for in its report. Both choices stand in `tools/oracle-closure/rulings.py` on the branch `cgame-stage-2`, and `notes/2026-10-29/cgame-stage-2.md` holds the build record. The coordinator read the cited lines before each row, and the user ratified each row on its own. No Sources, docs, or tools file changed for this record.

## S1. The `CollisionRecord_t` view

Ratified as proposed on 2026-10-29.

The cgame has a second view of `CollisionRecord_t`, a `CJKAMP` type, in `JKAMP_CGame` at `rulings.py:156`, in the same shape as the game's view in `JKAMP_Game` at `rulings.py:63`. A cgame target cannot import `JKAMP_Game`. One view in `JKAMP` for both units cannot stand beside the game's today, because `JKAMP_GameLogic` imports both `JKAMP` and `JKAMP_Game`, and `Sources/JKAMP_GameLogic/w_saber.swift:2007` names `CollisionRecord` with no module. The alternative, one view in `JKAMP` for both units, moves one game file and the game's rulings row, and it is not taken.

## S2. The view names of the typedefs without `_t`

Ratified as proposed on 2026-10-29.

Raven named `SSkinGoreData` and the eight `TCG*` shared-buffer records of `cg_public.h` with a leading letter and no `_t`, so the default view name would hide the C type. Each view drops the leading letter, at `rulings.py:150` and `:160-167`: `SkinGoreData`, `CGTrace`, `CGPointContents`, `CGVectorData`, `CGGetBoltData`, `CGImpactMark`, `CGMiscEnt`, `CGG2Mark`, and `CGCameraShake`. The game drops a prefix the same way, `T_G_ICARUS_PLAYSOUND` to `IcarusPlaySound` at `rulings.py:78`.

## The ledger

| Row | Verdict | Date |
|---|---|---|
| S1. The `CollisionRecord_t` view | ratified as proposed | 2026-10-29 |
| S2. The view names of the typedefs without `_t` | ratified as proposed | 2026-10-29 |
