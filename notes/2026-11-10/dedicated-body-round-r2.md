# The R2 body round of the dead-function wave

This record holds the rest of set R2 of section 4 of `notes/2026-11-10/docket-13.md`: CCMLandScape, cm_terrain, cm_test, cm_patch, and sv_bot. The eight GenericParser2 functions of R2 landed in an earlier round. The work is on the branch `ded-bodies-r2` in the worktree `/tmp/jka-r2`, from master `7d192ce6`. Each function has no caller in the dedicated server, and it gets its real body under rule 20. Each body keeps its one-line note that says why no caller exists.

## The functions

| Function | Raven | File | State |
| --- | --- | --- | --- |
| CCMLandScape::TerrainPatchIterate | `cm_terrain.cpp:997` | `CCMLandScape.swift` | landed, on row N-USERDATA |
| CM_TerrainPatchIterate | `cm_terrain.cpp:1628` | `cm_terrain.swift` | landed, on row N-USERDATA |
| CM_StoreBrushes | `cm_test.cpp:80` | `cm_test.swift` | landed, on row N-LEAFLIST |
| CM_BoxBrushes | `cm_test.cpp:194` | `cm_test.swift` | landed, on rows G8 and N-LEAFLIST |
| CM_DrawDebugSurface | `cm_patch.cpp:1651` | `cm_patch.swift` | landed, on row N-CLOSURE and the hand storage below |
| BotDrawDebugPolygons | `sv_bot.cpp:227` | `sv_bot.swift` | landed, on rows N-CLOSURE and G19 |

Six bodies landed. No stub of the set stays open.

## The forms

- N-USERDATA: both functions drop `userdata`, and the closure is `((CCMPatch?) -> Void)?`. Each signature has one AI line. No Swift caller and no thunk of either function exists, so no other site changes. The walk over `mPatches` uses the index `patchIndex`, the form of the patch walk in the same file.
- N-LEAFLIST: the hand accessor `LeafList.listBrushes: Slots<Cbrush?>?` is in `Sources/JKAMP_Ded/TraceViews.swift`, through `Slots(pointers:count:)` over the same word as `list`, with one AI line. CM_StoreBrushes writes `ll.listBrushes![ll.count] = b`. CM_BoxBrushes follows CM_BoxLeafnums, sets `ll.listBrushes = boxList`, and stores the new thunk `LeafListThunks.CM_StoreBrushes` of `cm_test.swift`.
- N-CLOSURE: the `drawPoly` closure of both functions takes `Slots<JKAShared.vec3_t>`, with one AI line at each signature. The bodies pass `poly.points`, `w!.p`, and the storage `v_CM_DrawDebugSurface`.
- CM_DrawDebugSurface, the two locals `v`: only `vec3_t v[3]` at `cm_patch.cpp:1772` builds. The second `v` stands under `#if 0`. No hand body passes a function-local vector array as a `Slots<vec3_t>`. The only form is the generator storage of `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, as `p` of RemoveColinearPoints and `hullPoints` have it. So the round adds `v_CM_DrawDebugSurface`, three vectors, by hand in that generated file in the generator's form (declaration, initializer, and deallocate), with the forward and its AI line in `cm_patch.swift`. A generator row must follow: BYTE_STORAGE_LOCALS `("v", "CM_DrawDebugSurface"): ("CM_DrawDebugSurface",)`, so that the next generator run prints the same lines.
- CM_DrawDebugSurface, the static locals `cv` and `cv2`: no storage existed. The round adds `cv_CM_DrawDebugSurface` and `cv2` to the `cm_patch.cpp` section of the hand `EngineWorld.swift`, with forwards in `cm_patch.swift`, the form of `cv_CM_TracePointThroughPatchCollide`. The name `cv` stands in three functions of `cm_patch.cpp`, so it takes the function suffix. The name `cv2` stands in one function only, so it keeps Raven's name, the form of `bot_debug`.
- CM_DrawDebugSurface: Vector4Copy is four element copies, and `VectorSubtract( vec3_origin, plane, plane )` is three element writes, the form of CM_TraceThroughPatchCollide. `fabs` on a float is `abs` of the Float.
- BotDrawDebugPolygons: `bot_highlightarea->string` is `bot_highlightarea!.string!`, the form of `be_ai_move.swift`.

## The checks

- `swift build -j 2`: exit 0, with no warning in the changed files.
- `swift test --no-parallel -j 2`: 162 of 162 pass, with no failure. The suites print 1, 1, 1, 103, 13, 20, 3, 16, and 4 tests.
