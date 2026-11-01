# The cgame signature markers and the D16 constants ledger

The record of the walk over `../2026-10-31/cgame-markers-docket.md`, rows M1 to M8 and K1, ruled on 2026-11-01. Every row was proven again at its cited lines in Raven's tree and in the Swift tree before it was shown. A row the proof changed is recorded with its amended text, and the ruling binds that text.

## The ledger

| Row | Verdict |
|---|---|
| M1 | ratified as proposed |
| M2 | ratified as amended |
| M3 | ratified as proposed |
| M4 | ratified as amended |
| M5 | ratified as proposed |
| M6 | ratified as proposed |
| M7 | ratified as proposed |
| M8 | ratified as amended |
| K1 | ratified as proposed |
| M9 | ruled during the work, see the row |

## M1, the trap record pointers

The cgame trap table takes the game's rows. Only `trap_RealTime` at `Sources/JKAMP_CGame/Generated/cg_syscalls.swift:979` still holds the marker. `trap_G2API_SetBoneIKState` at line 1655 and `trap_G2API_IKMove` at line 1664 already take the `SharedSetBoneIKStateParams?` and `SharedIKMoveParams` views, so the work is one trap. No `// AI:` line.

## M2, the trap arrays and byte pointers, amended

The trap wrapper reads or writes the pointer in the view target and takes a Swift value at the logic side: `inout [vec3_t]` for an axis, `[vec3_t]` for the points, `Slots<byte>` or `[UInt8]` for the mask as the caller holds it, and `inout [UInt8]` for `color4ub_t`. The docket named `color4ub_t` a record. Raven declares it at `oracle/codemp/cgame/tr_types.h:69` as `typedef byte color4ub_t[4]`, so it takes the array form of the axis case. Rule 24 applies only where the parameter form leaves Raven's, which it does not at the call site. No `// AI:` line.

## M3, `menuDef_t *`

A `MenuDef` view in the cgame view target by the views generator, and the fourteen parameters spelled as that view under rule 11. The generator makes views only for the closure of the `CGAME_ROOTS` table of `tools/oracle-closure/rulings.py`, and no root reaches `menuDef_t`, so the work is one root row, `"menuDef_t": ("MenuDef", "CJKAMP_CGame")`, beside the `itemDef_t` row at line 157. A root change reruns every generator before its commit. The markers sit at `Sources/JKAMP_CGameLogic/cg_draw.swift` lines 542 to 736. The file-scope variable `menuDef_t *menuScoreboard` at line 9 takes `MenuDef?` by the same view. No `// AI:` line.

## M4, `vec2_t uv[4]`, amended

`inout [vec2_t]`, the form of M2, with `vec2_t` declared as `SIMD2<Float>` beside `vec3_t` in `Sources/JKAShared/Views/Vectors.swift`. Swift had no `vec2_t`, and Raven's `typedef vec_t vec2_t[2]` is its counterpart. No `// AI:` line.

## M5, the `float *` return of CG_FadeColor

`-> vec4_t?`, nil where Raven returns NULL. Raven returns NULL when `startMsec` is 0 and when the elapsed time reaches `totalMsec`, and every caller in `cg_draw.c` tests the result for NULL. No `// AI:` line.

## M6, `char **args`

`inout TextCursor` for CG_RunMenuScript and CG_DeferMenuScript. Raven's two bodies are empty. Both functions are stored into the display context at `cg_main.c:3176` and 3177, and the callback typealiases at `Sources/JKAMP_CGame/Generated/Views/Callbacks.swift` lines 102 and 16 take `OpaquePointer?`, so each also takes a thunk closure of the M8 form. No `// AI:` line.

## M7, the `void *` return of CG_G2WeaponInstance

`-> OpaquePointer?`. The Centity view already spells `ghoul2weapon` as `OpaquePointer?`, and every caller assigns, compares, or hands the result to a Ghoul2 trap. The table `g2WeaponInstances` at `cg_weapons.swift:31` becomes `[OpaquePointer?]` by the same transcription row when the stem is transcribed. No `// AI:` line.

## M8, the thunk closures, amended

The nine closures, plus the two of M6, stay in the private thunk enums of their logic files, in the form of the working closures beside them. Each closure turns its `OpaquePointer?` words into views with `init(handle:)` and into `vec3_t` or `String` values with two readers added to the view target for a vector word and a C string word, then calls the logic function with the Swift signature its stub already carries. CG_Trace and CG_PointContents keep Raven's bodies in the logic target. Com_Error and Com_Printf format no varargs. Each hands the string to the channel line D10 names. No `// AI:` line.

The docket's precedent, `Sources/JKAMP_Game/PmoveThunks.swift`, does not fit. The game's two thunks are traps and call `Syscall.call` directly. Raven's cgame CG_Trace at `cg_predict.c:359` calls the box trace and then CG_ClipMoveToEntities, and CG_PointContents walks `cg_solidEntities`. Both are logic bodies, and the logic target imports the view target at `Package.swift:48`, not the reverse. Rule 11 names the `OpaquePointer` handle a thunk receives as the one exception in a logic target.

## K1, the D16 constants

A `reexport.py` rule, general and not a list of names. A macro body of the form `( ( <scalar typedef> ) <literal> )`, with the typedef among the declared scalar typealiases, writes `public let NAME: <typedef> = <literal>`, the rung between the expression and the marker. The generator change reruns every generator before its commit. No `// AI:` line, because the value and the type stay Raven's.

## M9, the two fill buffers of trap_CM_MarkFragments

A row the M2 work found and the user ruled on 2026-11-01. Raven's caller CG_ImpactMark at `oracle/codemp/cgame/cg_marks.c:161` passes the first of 384 local vectors as `pointBuffer` and the first of 128 local records as `fragmentBuffer`, with the two counts beside them, and the engine fills both. The spelling rule read the declared single-vector type and gave `inout vec3_t` and one `MarkFragment` view, so a transcribed caller would let the engine write past a 12-byte stack value. The game's `trap_EntitiesInBox` is the precedent for a buffer the engine fills with a count beside it, `inout [Int32]`.

Ruled: `pointBuffer` takes `inout [vec3_t]` by a trap rule for a vector parameter the engine fills with a count beside it, and `fragmentBuffer` takes `Slots<markFragment_t>`, the records owned by the caller in C memory. No `// AI:` line, the call site keeps Raven's form.

## Facts the walk found outside its rows

- The view target has no reader from an `OpaquePointer?` word to a `vec3_t` or a `String`. M8 adds the two.
- `cg_main.swift` holds no thunk closure for `runScript` or `deferScript`, so the two M6 functions are not stored today.
