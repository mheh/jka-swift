# The R1c body round of the dead-function wave

This record holds set R1c of section 4 of `notes/2026-11-10/docket-13.md`: the last nine stubs of `Sources/JKAMP_DedLogic/CRMMission.swift` against Raven's `RMG/RM_Mission.cpp`. The branch is `ded-bodies-r1c` from `b8e3f174`, in the worktree `/tmp/jka-r1c`. The records `notes/2026-11-10/dedicated-body-round-r1a.md` and `-r1b.md` give the API of the `CRMInstance` hierarchy, and `-w3.md` gives the form of ParseRandom and ParseOrigin. Every Raven cite is under `oracle/codemp/RMG/`.

## The functions

| Function | Raven | Status |
| --- | --- | --- |
| CRMMission::~CRMMission | RM_Mission.cpp:85 | landed |
| CRMMission::Load | :1362 | landed |
| CRMMission::Spawn | :1438 | landed |
| CRMMission::Preview | :1711 | landed |
| CRMMission::PlaceBridges | :379 | landed |
| CRMMission::PlaceWallInstance | :450 | landed on a hand signature |
| CRMMission::ParseInstance | :886 | landed |
| CRMMission::ParseInstancesOnPath | :737 | landed |
| CRMMission::ParseWallRect | :485 | landed |

Every function of the set landed, and no stub or hole stays open in `CRMMission.swift`.

## The fields

- `mInstances` is `rmInstanceList_t`, the `[CRMInstance]` of R1b, at the place of `RM_Mission.h:20`.
- `mInstanceFile` is a `let` of the final class `CRMInstanceFile`, at the place of `RM_Mission.h:22`. Raven holds it by value. The mission is its one owner, so the reference has the same lifetime, the form of `mParser` in `CRMInstanceFile.swift`.

## The form

- The preprocessor arms follow the dedicated Windows release build: `PRE_RELEASE_DEMO` is not defined, so its `#ifndef` arms build. `DEDICATED` is defined, so the `#ifndef DEDICATED` arms of Spawn drop, each with one line that names what Raven does there. `FINAL_BUILD` is not defined, so the `rmg_saveautomap` arm of Spawn builds, and its `return false` after `Com_Error` drops under the line of `bg_misc.swift`.
- Each `rmInstanceIter_t` loop is a for-in over `mInstances`, by the AI line of `rmInstanceList_t`. No loop of the set erases an element.
- Each `for` loop with a `continue` is a `while` loop that advances before the `continue`, the form of ParseRandom. The `for` of Spawn that assigns `area` in its condition reads the next area at the end of the body and before the `continue`.
- `VectorSet` of PlaceBridges is the `vec3_t(x, y, z)` store of `docs/transcription.md`. `vec3pair_t bounds` is a two-element Array, the type of the `bounds` parameter of GetWorldHeight.
- Each `int` to `float` conversion at a call or a multiply has a C conversion line: the `int` padding of GetDefaultPadding at each CreateArea, the cells of PlaceWallInstance, and the count and the index of ParseInstancesOnPath. The `float` path id of `GetPath` stores into the `int` local with the line of ParseOrigin.
- Raven's write through `newarea->GetPosition()` at `:1579` writes `newarea.mPosition`, by the AI line of the CArea field.
- ParseOrigin and ParseInstancesOnPath get `@discardableResult`, because ParseInstance drops their results at `:925` and `:948`.

## The sites with a note

- `~CRMMission`: Raven deletes each instance. The clear of the Array releases each one, under the AI line of the R1b sites.
- Load: Raven calls GetName through NULL when the mission file holds no root group. The unwrap traps there, under a rule 19 Port-note.
- Load: Raven reads the "info" pair into the local `mInfo` that no line reads. The local drops under an AI line, the form of `CRMGroupInstance.swift:86`.
- PlaceWallInstance: Raven passes `origin` as the origin that CreateArea moves and as the look-at origin. The call passes a copy as the look-at origin, under an AI line. The copy is faithful, because MoveArea writes the origin only for a symmetric area, and this call makes an area with symmetry 0.
- ParseInstancesOnPath: Raven passes `origin` as the origin and as the confine origin of CreateArea. The call passes a copy as the confine origin, under an AI line. The copy is faithful, because the CRMArea constructor copies the confine origin before MoveArea runs, and CreateArea does not read it again.
- ParseInstance: when the group has no "origin" sub group, ParseOrigin writes only `origin`, and Raven reads the uninitialized `lookat` at `:930`. The local starts at zero, under a rule 19 Port-note.
- ParseWallRect: Raven calls FindSubGroup through `group` before its NULL test. The unwrap traps there, under a rule 19 Port-note.
- ParseWallRect: Raven calls SetSide through NULL when CreateInstance finds no instance of the name. One rule 19 Port-note at the top of the block covers each `instance!` before a PlaceWallInstance.

## The open item

PlaceWallInstance has the hand signature `(_ instance: CRMInstance?, _ xpos: Float, _ ypos: Float, _ zpos: Float, _ x: Int32, _ y: Int32, _ angle: Float)`. The file is adopted, and the form follows the hand signature of ParseOrigin. The generator has no `CXX_CLASSES` row for `CRMInstance` (`tools/oracle-closure/rulings.py:1722`), so a generator run still makes the signature marker for `CRMInstance* instance`. The row `"CRMInstance": "CRMInstance"` keeps draftcheck in agreement with the hand signature. This round does not change a generator table.

## The gate

- `swift build -j 2`: exit 0, with no warning in `CRMMission.swift`.
- `swift test --no-parallel -j 2`: exit 0, 162 tests pass, the count of the base.
