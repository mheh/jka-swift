# Review: cm_trace.swift, cm_test.swift, cm_patch.swift against Raven

Base: master at `d6f2dd7`. Raven: `oracle/codemp/qcommon/cm_trace.cpp`, `cm_test.cpp`, `cm_patch.cpp`.
The review skips each `portMissing` hole. It checks the lines around each hole.

Count: 1 DEFECT, 1 SUSPECT, 5 RULE.

---

## 1. DEFECT: the row stride of `cGrid_t.points` is 4 bytes per element, not 12

- Swift: `Sources/JKAMP_Ded/Generated/Views/CGrid.swift:89`
  `public var points: Slots<Slots<JKAShared.vec3_t>> { Slots(rows: ..., count: 129, stride: 129 * MemoryLayout<Int32>.stride) { Slots(vectors: $0, count: 129) } }`
- Raven: `oracle/codemp/qcommon/cm_patch.h:115`
  `vec3_t	points[MAX_GRID_SIZE][MAX_GRID_SIZE];	// [width][height]`
- Difference: Raven's row `i` starts at byte `i * 129 * 12 = i * 1548`. The view starts it at byte `i * 516`. So `grid.points[i][j]` with `i > 0` reads and writes the wrong cell. Rows overlap. For example, Swift row 3 is Raven row 1, and Swift `points[0][43]` is the same memory as Swift `points[1][0]`.
- Effect: every grid body of `cm_patch.swift` reads and writes the wrong points. The affected lines are 223-246 (CM_TransposeGrid), 282 (CM_SetGridWrapWidth), 328-378 (CM_SubdivideGridColumns), 1022-1030 (CM_PatchCollideFromGrid), and 1266 (CM_GeneratePatchCollide). The defect is latent now, because the grid fill at `cm_patch.swift:1240` is a hole. When that hole closes, every patch collide that the server builds will have wrong facets and wrong planes. No crash occurs, because 129 * 516 bytes is less than the size of the record.
- The view generator writes this line, so the fix is in the generator (`views.py`), not in the body. It is the only `Slots(rows:)` field with `vec3_t` elements in the tree. Every other row field uses the correct element size.

## 2. SUSPECT: CM_Trace computes the capsule bounds in `float`, and the cm_patch bodies read Raven's `fabs` as `double`

- Swift: `Sources/JKAMP_DedLogic/cm_trace.swift:1562`
  `tw.bounds[0][i] = tw.start[i] - abs(tw.sphere.offset[i]) - tw.sphere.radius`
  (also lines 1563, 1565, 1566)
- Raven: `oracle/codemp/qcommon/cm_trace.cpp:1676`
  `tw.bounds[0][i] = tw.start[i] - fabs(tw.sphere.offset[i]) - tw.sphere.radius;`
  (also lines 1677, 1679, 1680)
- Difference: if Raven's `fabs` resolves to the `double` overload, C does the two subtractions in `double` and rounds once at the store. The Swift line does two `Float` subtractions and rounds twice. The result can differ by one ulp, and the bounds then accept or reject a brush at the edge in a different way. If the compiler of the oracle resolves `fabs(float)` to the C++ `float` overload, the Swift line is correct.
- The same file family uses the other reading. `cm_patch.swift:1575` and `cm_patch.swift:1702` write `Float(Double(plane[3]) + abs(Double(offset)))` for Raven's `plane[3] += fabs(offset);` at `cm_patch.cpp:1490` and `cm_patch.cpp:1611`. Those two lines give the same bits as the `float` form, because one `double` add of two floats rounds the same as a `float` add. Only the CM_Trace lines can diverge. A referee run of a capsule trace at a brush edge, or a check of the overload that the oracle compiler picks, decides it.

## 3. RULE: the Port-note of CM_RemoveDegenerateColumns gives a reason that no longer holds

- Swift: `Sources/JKAMP_DedLogic/cm_patch.swift:427`
  `// Port-note: CM_ComparePoints takes a \`Slots<Float>\`, and the grid point is a \`vec3_t\`, so the call waits for the \`vec3_const\` row.`
- Raven: `oracle/codemp/qcommon/cm_patch.cpp:400`
  `if ( !CM_ComparePoints( grid->points[i][j], grid->points[i+1][j] ) ) {`
- Difference: none in behavior, because the hole traps. But `CM_ComparePoints` at `cm_patch.swift:390` already takes `JKAShared.vec3_t`, so the call can be written now: `if !CM_ComparePoints(grid.points[i][j], grid.points[i + 1][j]) { break }`. The hole stays open for a reason that is gone.

## 4. RULE: the Port-note of CM_GeneratePatchCollide gives a reason that no longer holds

- Swift: `Sources/JKAMP_DedLogic/cm_patch.swift:1238`
  `// Port-note: \`points\` is one \`inout vec3_t\`, where Raven indexes the \`vec3_t *\` as the packed rows, so the read waits for the signature row.`
- Raven: `oracle/codemp/qcommon/cm_patch.cpp:1188`
  `VectorCopy( points[j*width + i], grid.points[i][j] );`
- Difference: none in behavior, because the hole traps. The signature at `cm_patch.swift:1209` already takes `_ points: [JKAShared.vec3_t]`, so `grid.points[i][j] = points[j * width + i]` can be written now. Do not close this hole before finding 1 is fixed. Otherwise the defect of finding 1 goes live.

## 5. RULE: CM_PositionTest keeps a hole for `leafs`, and the storage for `leafs` already exists and is unused

- Swift: `Sources/JKAMP_DedLogic/cm_trace.swift:477`
  `// Port-note: The local \`int leafs[MAX_POSITION_LEAFS]\` has no BYTE_STORAGE_LOCALS entry.`
  and `Sources/JKAMP_DedLogic/cm_trace.swift:11`
  `private var leafs_CM_PositionTest: Slots<Int32> { world.storage.cm_trace_leafs_CM_PositionTest }`
- Raven: `oracle/codemp/qcommon/cm_trace.cpp:449`
  `int		leafs[MAX_POSITION_LEAFS];`
- Difference: none in behavior, because the holes trap. The note says that no storage entry exists, but `EngineStorage.cm_trace_leafs_CM_PositionTest` (1024 `Int32` slots) exists, and the file declares the forward at line 11. No line reads the forward. The holes at lines 479, 498, and 516 can use `leafs_CM_PositionTest` now. The hole at line 501 (`ll.storeLeafs = CM_StoreLeafs`) stays, because it waits for a thunk.

## 6. RULE: the Port-note of CM_TraceThroughTerrain states a wrong type for `tw->bounds`

- Swift: `Sources/JKAMP_DedLogic/cm_trace.swift:706`
  `// The view gives \`tw->bounds\` as a Slots of rows, and CM_GenericBoxCollide takes \`[vec3_t]\`.`
- Raven: `oracle/codemp/qcommon/cm_trace.cpp:717`
  `if(!CM_GenericBoxCollide(tw->bounds, landscape->GetBounds()))`
- Difference: none in behavior, because the hole traps. `TraceWork.bounds` at `Sources/JKAMP_Ded/Generated/Views/TraceWork.swift:119` is `[JKAShared.vec3_t]`, the type that CM_GenericBoxCollide takes. The hole stays open for the CCMLandScape half alone (row CM6). The note at line 748 for `tw->localBounds` may be stale in the same way. Check that field before the next hole round.

## 7. RULE: an unreachable statement after a `return` in CM_FindPlane

- Swift: `Sources/JKAMP_DedLogic/cm_patch.swift:579`
  `return i`
  `i += 1`
- Raven: `oracle/codemp/qcommon/cm_patch.cpp:548`
  `return i;`
- Difference: none in behavior. The `for` step comes after the `return` at line 580, so it can never run, and the compiler warns. Remove line 580.

---

## Context, not findings

These holes are on a live server path. Each one traps at the first call of its arm.

- `CM_PositionTest` (`cm_trace.swift:479`) traps at entry. CM_Trace calls it for each point trace with `start == end` against the world.
- `CM_BoxLeafnums` (`cm_test.swift:180`) traps on `storeLeafs`. SV_LinkEntity calls it.
- `CM_TraceThroughPatchCollide` (`cm_patch.swift:1606`) and `CM_TracePointThroughPatchCollide` (`cm_patch.swift:1382`) trap when a trace hits a curve facet, on the static `cv` lines.

## Functions compared in full

The review compared each line that is not a `portMissing` hole.

cm_trace.swift: RotatePoint, TransposeMatrix, CreateRotationMatrix, CM_ProjectPointOntoVector, CM_DistanceFromLineSquared, CM_VectorDistanceSquared, SquareRootFloat, CM_TestBoxInBrush, CM_TestInLeaf, CM_TestCapsuleInCapsule, CM_TestBoundingBoxInCapsule, CM_PositionTest (lines around holes), CM_TraceThroughPatch, CM_PlaneCollision, CM_TraceThroughBrush, CM_TraceThroughTerrain (lines around holes), CM_GenericBoxCollide, CM_TraceThroughLeaf, CM_TraceThroughSphere, CM_TraceThroughVerticalCylinder, CM_TraceCapsuleThroughCapsule, CM_TraceBoundingBoxThroughCapsule, CM_TraceToLeaf, CM_TraceThroughTree, CM_CalcExtents, CM_Trace, CM_BoxTrace, CM_TransformedBoxTrace, CM_CullBox, CM_CullWorldBox.

cm_test.swift: CM_PointLeafnum_r, CM_PointLeafnum, CM_StoreLeafs, CM_StoreBrushes (lines around the hole), CM_BoxLeafnums_r, CM_BoxLeafnums (lines around the hole), CM_PointContents (lines around the terrain hole), CM_TransformedPointContents, CM_ClusterPVS, CM_FloodArea_r, CM_FloodAreaConnections, CM_AdjustAreaPortalState, CM_AreasConnected, CM_WriteAreaBits.

cm_patch.swift: CM_ClearLevelPatches, CM_SignbitsForNormal, CM_PlaneFromPoints, CM_NeedsSubdivision, CM_Subdivide, CM_TransposeGrid, CM_SetGridWrapWidth, CM_SubdivideGridColumns, CM_ComparePoints, CM_RemoveDegenerateColumns (lines around the hole), CM_PlaneEqual, CM_SnapVector, CM_FindPlane2, CM_FindPlane, CM_PointOnPlaneSide, CM_ValidateFacet, CM_AddFacetBevels, CM_PatchCollideFromGrid (lines around holes), CM_GeneratePatchCollide (lines around holes), CM_TracePointThroughPatchCollide (lines around holes), CM_CheckFacetPlane, CM_TraceThroughPatchCollide (lines around holes), CM_PositionTestInPatchCollide.

The review also read the view helpers that these bodies depend on: `Cbrushside` subscript and `TraceWork.startout`/`getout` (`Sources/JKAMP_Ded/TraceViews.swift`), `leafbrush(at:)` and `leafsurface(at:)` (`Sources/JKAMP_Ded/LumpViews.swift`), `Slots(rows:)` and `Slots(vectors:)` (`Sources/JKAShared/Views/Slots.swift`), `PatchCollide.bounds`, `PatchPlane.plane`, `Facet.border*`, and `TraceWork.bounds`.

## Functions not reached

None with a body. These are stubs with a signature marker or a dead marker, so the review had no body to compare: CM_HandlePatchCollision (`cm_trace.swift:801`), CM_BoxBrushes (`cm_test.swift:199`), CM_GridPlane (`cm_patch.swift:633`), CM_EdgePlaneNum (`cm_patch.swift:649`), CM_SetBorderInward (`cm_patch.swift:665`), CM_DrawDebugSurface (`cm_patch.swift:1724`).
