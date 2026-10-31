# The cgame signature markers and the D16 constants docket

The second and third stage 4 rows by row V2 of `cgame-stage-4-opening.md`. Every citation is read at the line in Raven's tree and in the Swift tree.

## The count

The stage 3 note, `../2026-10-29/cgame-stage-3-tools.md:93`, prints three sets: 20 `TODO: Port signature` markers in the stubs, 9 in `cg_syscalls.swift`, and 9 thunks over an unmapped signature. Row V2 named the first two. The grep today gives 9 in the generated trap file and 29 in the logic target, the 20 stubs plus the 9 thunk closures. This docket carries all 38.

## The D8 reading of rule 11

Rule 11, `docs/porting-rules.md:28`: pointer code lives only in the view target, which holds the typed traps and generated thunks, and a logic target holds no `Unsafe` type. D8, `departures-ledger.md:16`: a thunk reads a vector, text, or scalar pointer in the view target, as the typed traps do, and gives the logic target a view or a Swift value.

## The 9 trap markers, `Sources/JKAMP_CGame/Generated/cg_syscalls.swift`

| Swift | Trap | `cg_syscalls.c` | Blocking type |
|---|---|---|---|
| :341 | trap_CM_MarkFragments | :177 | `const vec3_t *points` |
| :409 | trap_S_Respatialize | :220 | `vec3_t axis[3]` |
| :724 | trap_R_GetLightStyle | :411 | `color4ub_t color` |
| :979 | trap_RealTime | :575 | `qtime_t *` |
| :1044 | trap_R_inPVS | :616 | `byte *mask` |
| :1073 | trap_FX_PlayEntityEffect | :631 | `vec3_t axis[3]` |
| :1100 | trap_FX_PlayEntityEffectID | :647 | `vec3_t axis[3]` |
| :1655 | trap_G2API_SetBoneIKState | :1040 | `sharedSetBoneIKStateParams_t *` |
| :1664 | trap_G2API_IKMove | :1045 | `sharedIKMoveParams_t *` |

## The 20 stub markers, `Sources/JKAMP_CGameLogic/`

- `menuDef_t *menuHUD`, 14 stubs in `cg_draw.swift` at :558, :574, :593, :609, :625, :678, :687, :696, :705, :715, :724, :733, :742, :752, for `cg_draw.c` :614, :702, :841, :928, :1042, :1873, :1942, :2013, :2084, :2156, :2197, :2251, :2344, :2434. No view covers `menuDef_t`.
- `vec2_t uv[4]`, 2 stubs: `cg_effects.swift:152` CG_DoGlassQuad (`cg_effects.c:261`) and `:161` CG_CalcBiLerp (`cg_effects.c:367`).
- A `float *` return, 1 stub: `cg_drawtools.swift:236` CG_FadeColor (`cg_drawtools.c:387`). The body returns a static `vec4_t`, and NULL when `startMsec` is 0 (`:391-392`).
- `char **args`, 2 stubs: `cg_newDraw.swift:168` CG_RunMenuScript (`cg_newDraw.c:876`) and `:177` CG_DeferMenuScript (`:879`).
- A `void *` return, 1 stub: `cg_weapons.swift:328` CG_G2WeaponInstance (`cg_weapons.c:2373`).

## The 9 thunk closures

Closures typed by a callback typealias with a `portMissing` body: `cg_predict.swift:196` CG_PointContents (`cg_predict.c:393`) and `:200` CG_Trace (`:359`); `cg_main.swift:1211` CG_Cvar_Get (`cg_main.c:3020`), `:1224` CG_FeederItemText (`:2909`), `:1231` CG_OwnerDrawHandleKey (`:2829`), `:1238` CG_PlayCinematic (`:3053`), `:1248` CG_Text_PaintWithCursor (`:3027`), `:1252` Com_Error (`:1234`), `:1256` Com_Printf (`:1245`).

## The rows

### M1, the trap record pointers, 3 traps

`qtime_t *`, `sharedSetBoneIKStateParams_t *`, `sharedIKMoveParams_t *`. The game's trap table already spells them as views: `Sources/JKAMP_Game/Generated/g_syscalls.swift:424` `trap_RealTime(_ qtime: JKAMP.Qtime)`, `:2372` and `:2381` for the two IK records. Proposed: the cgame trap table takes the game's rows. No `// AI:` line.

### M2, the trap arrays and byte pointers, 6 traps

`vec3_t axis[3]` three times, `const vec3_t *points`, `byte *mask`, `color4ub_t`. The game has no such trap. Proposed under D8: the trap wrapper reads or writes the pointer in the view target and takes a Swift value at the logic side: `inout [vec3_t]` for an axis, `[vec3_t]` for the points, `Slots<byte>` or `[UInt8]` for the mask as the caller holds it, and the `color4ub_t` record as a view. The `docs/transcription.md:97` row for a fixed set of floats as `inout vec3_t` extends to a fixed array. Rule 24 applies only where the parameter form leaves Raven's, which it does not at the call site.

### M3, `menuDef_t *`, 14 stubs

No view covers the struct. Proposed: a `MenuDef` view in the view target by the views generator, and the parameter spelled as that view, rule 11. No game precedent. No `// AI:` line.

### M4, `vec2_t uv[4]`, 2 stubs

Proposed: `inout [vec2_t]`, the form of M2. No `// AI:` line.

### M5, the `float *` return of CG_FadeColor, 1 stub

`docs/transcription.md:109` and `:204` give a static ring of temporaries as a value return. Raven returns a static `vec4_t` or NULL. Proposed: `-> vec4_t?`, nil where Raven returns NULL. No `// AI:` line.

### M6, `char **args`, 2 stubs

`docs/transcription.md:103` gives `const char **` as `inout JKAShared.TextCursor`, and `:112` gives a `char **` set once as `inout String`. CG_RunMenuScript walks the tokens. Proposed: `inout TextCursor` for both. No `// AI:` line.

### M7, the `void *` return of CG_G2WeaponInstance, 1 stub

`docs/transcription.md:454`: a `void *` variable is an engine handle, `OpaquePointer?`. Proposed: `-> OpaquePointer?`. No `// AI:` line.

### M8, the 9 thunk closures

Game precedent: `Sources/JKAMP_Game/PmoveThunks.swift:7-15`, a hand enum in the view target whose `PmoveTrace` and `PmovePointcontents` closures call `Syscall.call` directly. Proposed under D8: CG_Trace and CG_PointContents take the same view-target form, and the seven display-context closures take views or Strings that the thunk reads. No `// AI:` line.

### K1, the D16 constants

Raven, `oracle/codemp/cgame/cg_local.h:19-21`: `#define NULL_HANDLE ((qhandle_t) 0)`, `NULL_SOUND ((sfxHandle_t) 0)`, `NULL_FX ((fxHandle_t) 0)`. Sites: `NULL_HANDLE` 5 in `cg_ents.c` and 16 in `cg_weaponinit.c` (`cg_ents.c:2499`), `NULL_SOUND` 94 in `cg_weaponinit.c` (`:150`), `NULL_FX` 6 in `cg_weaponinit.c` (`:478`).

Today each is a `TODO: Port` marker at `Sources/JKAMP_CGame/Generated/cg_local.swift:8`, `:12`, `:16`. The ladder at `tools/oracle-closure/reexport.py:341` climbs import, expression, narrowed `Int32`, marker, and `swift_expression` (`:124-185`) sends `qhandle_t` through as a name, so the cast body fails every rung.

Proposed: a reexport.py rule, general and not a list of names. A macro body of the form `( ( <scalar typedef> ) <literal> )`, with the typedef among the declared scalar typealiases, writes `public let NAME: <typedef> = <literal>`, the rung between the expression and the marker. The alternative is a rulings.py table beside `NOT_PORTED_MACROS` (`rulings.py:402`). A hand constant has no Raven counterpart. The generator change reruns every generator before its commit. No `// AI:` line, because the value and the type stay Raven's.
