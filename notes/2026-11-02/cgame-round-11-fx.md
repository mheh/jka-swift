# The cgame transcription rounds, round 11, the fx_ files

The record of the eleventh cgame transcription round, nine stems, `fx_blaster`, `fx_bowcaster`, `fx_bryarpistol`, `fx_demp2`, `fx_disruptor`, `fx_flechette`, `fx_force`, `fx_heavyrepeater`, and `fx_rocketlauncher`, on the branch `cgame-round-11-fx` off master `07f5874`.

## The adoption

The draft gate over the nine stems ended at 0 defects:

- `fx_blaster: 4 of 4 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_bowcaster: 4 of 4 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_bryarpistol: 13 of 13 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_demp2: 5 of 5 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_disruptor: 6 of 6 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_flechette: 4 of 4 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_force: 1 of 1 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`
- `fx_heavyrepeater: 7 of 7 hand functions replaced, 0 kept, 1 holes, 0 cascade errors, 0 defects, 1 compile holes over 2 passes`
- `fx_rocketlauncher: 4 of 4 hand functions replaced, 0 kept, 0 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 passes`

`adopt.py` spliced all 48 functions and kept no hand function. The nine files took 1 Port-note and 1 `portMissing` line, both in CG_DistortionOrb of fx_heavyrepeater. The build passes at the adoption. Commit 39415bd.

## The hole round

Commit bd37774 closed the one note. The draft passed the scratch record's axis to `AnglesToAxis` with `&`, and the compiler refused it, because the axis is a `Slots<vec3_t>` and not an `inout` value. The call passes the Slots as it stands, through the Slots forward of `AnglesToAxis` in `q_math.swift`, the form of `cg_main.swift:793`. The commit adds no AI line, because the call keeps Raven's form.

The nine files hold 0 Port-notes and 0 `portMissing` lines. The build passes, and `swift test --no-parallel` passes 113 tests across its runs of 1, 84, 13, and 15.

## The shapes

- A view's axis into `AnglesToAxis`, the Slots forward, one site.

## The notes left

None.

## Drafter rows found

- The axis of a scratch record into `AnglesToAxis`. The drafter writes `&` before a `Slots<vec3_t>` axis of a `scratch` view, where the Slots forward takes the Slots by value.
  - C: `AnglesToAxis(ang, ent.axis);`
  - Swift: `AnglesToAxis(ang, ent.axis)`
