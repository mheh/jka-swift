# Review 11, the cmsv round: behavior differences between the Swift bodies and Raven

Tree: `/Users/milohehmsoth/Developer/Milo/jka-swift`, master at f292db9. Swift paths are under `Sources/`. Raven paths are under `oracle/codemp/`.

Scope: the round commit c40a6a4 (record `notes/2026-11-10/dedicated-body-round-cmsv.md`), the `cm_*` and `sv_*` changes of the tenth batch (2b5bccc..919cab4), and the frame-path functions that the brief names first.

Count: 2 DEFECT, 0 SUSPECT, 5 NOTE.

## Findings

### F1. DEFECT. The botlib gets the BSP entity string cut to 31999 bytes

- Swift `Sources/JKAMP_DedLogic/sv_bot.swift:851`:
  `static let BotImport_BSPEntityData: BotlibImportBSPEntityData = { ringText(JKAMP_DedLogic.BotImport_BSPEntityData()) }`
- Swift `Sources/JKAMP_Ded/ThunkReaders.swift:22-24` (the callee):
  `let buf = textRing + (textRingIndex & 1) * 32000` ... `store(text, at: buf, capacity: 32000)`. The comment at `:20` says: "a text of 32000 bytes or more is cut to 31999 and the NUL". `Sources/JKAShared/Views/CStrings.swift:17` does the cut: `let length = min(Int(strlen(buf)), capacity - 1)`.
- Raven `server/sv_bot.cpp:378-380`:
  `char *BotImport_BSPEntityData(void) { return CM_EntityString(); }`. This is the pointer to the whole `cmg.entityString`, with no length limit.
- The reader: Raven `botlib/be_aas_bspq3.cpp:464-466`, `bspworld.entdatasize = strlen(botimport.BSPEntityData()) + 1;` and `Com_Memcpy(bspworld.dentdata, botimport.BSPEntityData(), bspworld.entdatasize);`. Swift `Sources/JKAMP_DedLogic/be_aas_bspq3.swift:393` and `:396` call `botimport.runBSPEntityData()`, which calls the thunk through the C function pointer (`Sources/JKAMP_Ded/Generated/Views/BotlibImport.swift:163-165`).
- Effect: on a map whose entity lump has 32000 bytes or more, the botlib parses only the first 31999 bytes. The cut can fall in the middle of a token. The botlib then loses all BSP entities after the cut: the AAS entity epairs, the level items of BotInitLevelItems, and the model info that bots use. Many JKA MP maps have an entity lump larger than 32000 bytes. Raven's import has no limit. No `// AI:` line is at the site. The thunk came in with the tenth batch (row B1).

### F2. DEFECT (small effect). Capsule trace bounds are computed in float, Raven computes them in double

- Swift `Sources/JKAMP_DedLogic/cm_trace.swift:1579-1583`:
  `tw.bounds[0][i] = tw.start[i] - abs(tw.sphere.offset[i]) - tw.sphere.radius`
  `tw.bounds[1][i] = tw.end[i] + abs(tw.sphere.offset[i]) + tw.sphere.radius` (and the two lines of the `else` arm).
- Raven `qcommon/cm_trace.cpp:1676-1680`:
  `tw.bounds[0][i] = tw.start[i] - fabs(tw.sphere.offset[i]) - tw.sphere.radius;`
  `tw.bounds[1][i] = tw.end[i] + fabs(tw.sphere.offset[i]) + tw.sphere.radius;`
- `fabs` returns `double`, so C does the two subtractions (or additions) in double and rounds to float once, at the store. Swift `abs(Float)` keeps every step in float and rounds twice.
- Effect: `tw.bounds` can differ by one ulp when `tw.sphere.use` is true (capsule traces, `G_TRACECAPSULE` and capsule entities). The bounds feed only the broad-phase box tests (CM_TraceThroughBrush `:622-629`, CM_TestBoxInBrush `:190-197`, CM_TraceThroughPatchCollide, CM_TraceCapsuleThroughCapsule `:1155-1162`), so a different result needs a brush face on that exact ulp. Other `fabs` sites of the same files keep the double step, for example `cm_patch.swift:1678` `plane[3] = Float(Double(plane[3]) + abs(Double(offset)))`. This site came before this round, but it is in CM_Trace, a callee of CM_BoxTrace.

### F3. NOTE. Float to int conversions trap in Swift where C converts with no check

- Swift `Sources/JKAMP_DedLogic/sv_world.swift:231`, `:240`, `:249`:
  `i = Int32(gEnt.r.maxs[0])`, `j = Int32((-gEnt.r.mins[2]))`, `k = Int32((gEnt.r.maxs[2] + 32))`
- Raven `server/sv_world.cpp:211`, `:218`, `:225`:
  `i = gEnt->r.maxs[0];`, `j = (-gEnt->r.mins[2]);`, `k = (gEnt->r.maxs[2]+32);`
- Effect: for a NaN bound or a bound of 2^31 or more, Swift stops the server with a trap. On x86, C gives INT_MIN, and the clamp makes it 1. C calls this undefined, so this is a NOTE. The same form is at `Sources/JKAMP_DedLogic/sv_client.swift:569-570` `MSG_WriteLong(msg, Int32(symbol!.mOrigin[0]))` against Raven `server/sv_client.cpp:677` area `MSG_WriteLong ( msg, (long)symbol->mOrigin[0] );` (random missions only).

### F4. NOTE. The operator precedence is different, but the value is the same

- Swift `Sources/JKAMP_DedLogic/sv_world.swift:261`: `gEnt.s.solid = (k << 16) | (j << 8) | i - 1`
- Raven `server/sv_world.cpp:235`: `gEnt->s.solid = (k<<16) | (j<<8) | i-1;`
- In Swift, `|` and `-` have the same precedence (AdditionPrecedence), so the line is `((k<<16)|(j<<8)|i) - 1`. In C it is `(k<<16)|(j<<8)|(i-1)`. The line runs only when `solid == SOLID_BMODEL`, so i is 255, and both forms give 0xfffffe. No effect now. A later edit to this line can make the difference real.

### F5. NOTE. The module buffer arms copy `strlen + 1` bytes, and Raven's Q_strncpyz writes the whole buffer

- Swift `Sources/JKAMP_DedLogic/sv_game.swift:519` (and `:529`, `:629`, `:640`, `:647`, `:740`, `:744`, `:1046`, `:1086`, `:1153`, `:1328`, `:1373`, `:1387`, `:1446`, `:1946`): `Com_Memcpy(args.VMA(2), buffer, strlen(buffer) + 1)`
- Raven `server/sv_game.cpp:553` `Cvar_VariableStringBuffer( (const char *)VMA(1), (char *)VMA(2), args[3] );`, and the callees use `Q_strncpyz`, which is `strncpy( dest, src, destsize-1 ); dest[destsize-1] = 0;` (`game/q_shared.c:838-839`). `strncpy` fills the rest of the buffer with zeros.
- Effect: after the NUL, Raven's module buffer holds zeros, and the Swift module buffer keeps its old bytes. A module that reads only up to the NUL sees no difference. Each arm has an `// AI:` line, and the line states the copy truly. It does not state the lost zero fill.

### F6. NOTE. The comment at G_G2_GETSURFACENAME is true in effect

- Swift `Sources/JKAMP_DedLogic/sv_game.swift:1628-1630`: "Raven tests `local` for NULL. The Swift function returns a String, so the copy always runs."
- Raven `server/sv_game.cpp:1599-1602` `if (local) { strcpy(point, local); }`, and `ghoul2/G2_API.cpp:2360-2382` returns `noSurface` (`""`), never NULL, on the error path.
- No effect. I record it because the line is not an `// AI:` line, and it describes a change.

### F7. NOTE. CM_EdgePlaneNum indexes `planes[-1]` the same way Raven does

- Swift `Sources/JKAMP_DedLogic/cm_patch.swift:670` (and the five other arms): `p = CM_GridPlane(gridPlanes, i, j, 0)` then `_VectorMA(p1, 4, planes[p].plane.vector, &up)`.
- Raven `qcommon/cm_patch.cpp:623-624`: `p = CM_GridPlane( gridPlanes, i, j, 0 ); VectorMA( p1, 4, planes[ p ].plane, up );`
- When CM_GridPlane returns -1 ("should never happen"), C reads out of bounds and continues. Swift traps. This is a NOTE, because Raven's behavior there is undefined.

## Sites I checked and found faithful

These need no action. I list them so that a later reader knows that they were compared.

- The float and double steps of CM_TraceThroughTree (`cm_trace.swift:1404-1412` against `cm_trace.cpp:1501-1509`), CM_PlaneCollision (`:550-594` against `:540-598`), CM_Trace offset (`:1519` against `:1617`), CM_CheckFacetPlane and CM_TracePointThroughPatchCollide (`cm_patch.swift:1495`, `:1527-1550` against `cm_patch.cpp:1329`, `:1355-1376`), and the `fabs` sites of CM_TraceThroughPatchCollide and CM_PositionTestInPatchCollide.
- SquareRootFloat (`cm_trace.swift:150-166`): the 32-bit `long` read and the arithmetic shift give Raven's bits.
- The value copies of `TraceWork.sphere` (`JKAMP_Ded/Generated/Views/TraceWork.swift:113-116`), `Moveclip.trace` (`Moveclip.swift:131-134`), and the byte width of `trace.allsolid` and `trace.startsolid` match C's struct copies.
- The `G_NAV_SETCHECKEDNODE` and `G_NAV_FLAGALLNODES` fall-throughs (`sv_game.swift:1008-1020`), and the `BOTLIB_EA_ACTION` `break` to `return -1` (`:1209-1211`, `:1952`).
- The mixed operators `1.0 / count`, `i * (1.0 / count)`, `nLDist < maxNeighborDist`, and `Float(generic1) * generic1` resolve to the Float forms of `JKAShared/Promotion.swift:8-22`, which match C's float arithmetic.
- The `cmShaderTable` dictionary of the tenth batch (`cm_shader.swift:107-147`) matches `CHash` with its default `strcmp` (`qcommon/chash.h:10`): a later insert of the same name wins, and the key compare is case-sensitive.
- The `// AI:` lines that I read state their change truly: the `leafbrush(at:)` and `leafsurface(at:)` reads, `landScape_cmg`, the copied `origin` and `angles` locals of sv_world, the AreaParms and Moveclip vector copies, the module vector slots of sv_game, the `ghoul2Instances` word lookups, the `%p` text of `cm_patch.swift:1320`, and the `heightmap` storage of sv_client.

## Functions read

- cm_trace: RotatePoint, TransposeMatrix, CreateRotationMatrix, CM_ProjectPointOntoVector, CM_DistanceFromLineSquared, CM_VectorDistanceSquared, SquareRootFloat, CM_TestBoxInBrush, CM_TestInLeaf, CM_TestCapsuleInCapsule, CM_TestBoundingBoxInCapsule, CM_PositionTest, CM_TraceThroughPatch, CM_PlaneCollision, CM_TraceThroughBrush, CM_TraceThroughTerrain, CM_HandlePatchCollision, CM_GenericBoxCollide, CM_TraceThroughLeaf, CM_TraceThroughSphere, CM_TraceThroughVerticalCylinder, CM_TraceCapsuleThroughCapsule, CM_TraceBoundingBoxThroughCapsule, CM_TraceToLeaf, CM_TraceThroughTree, CM_CalcExtents, CM_Trace, CM_BoxTrace, CM_TransformedBoxTrace, CM_CullBox, CM_CullWorldBox.
- cm_patch: CM_GridPlane, CM_EdgePlaneNum, CM_SetBorderInward, CM_TracePointThroughPatchCollide, CM_CheckFacetPlane, CM_TraceThroughPatchCollide, CM_PositionTestInPatchCollide, the `%p` line of CM_GeneratePatchCollide.
- cm_load: CM_ClipHandleToModel, CM_InlineModel, CM_LeafCluster, CM_LeafArea, CM_InitBoxHull, CM_TempBoxModel, CM_ModelBounds, CM_RegisterTerrain, CM_ShutdownTerrain, the CMod_LoadPatches line of the round.
- cm_test: the round lines of CM_PointContents, CM_StoreBrushes, CM_BoxBrushes.
- cm_shader: CM_ParseVector (the removed shadow copy), the fogParms arm of CM_ParseShader, CM_SetupShaderProperties, CM_GetShaderInfo(name).
- sv_world: all functions (SV_ClipHandleForEntity, SV_SectorList_f, SV_CreateworldSector, SV_ClearWorld, SV_UnlinkEntity, SV_LinkEntity, SV_AreaEntities_r, SV_AreaEntities, SV_ClipToEntity, VectorDistance, SV_ClipMoveToEntities with the Ghoul2 block, SV_Trace, SV_PointContents).
- sv_game: SV_GameError to ConvertedEntity, all arms of SV_GameSystemCalls.
- sv_snapshot: SV_QsortEntityNumbers, SV_AddEntToSnapshot, SV_AddEntitiesVisibleFromPoint, SV_BuildClientSnapshot.
- sv_bot: all functions and all BotlibImportThunks.
- sv_client: SV_WriteRMGAutomapSymbols, the RMG block of SV_SendClientGameState, the download block lines of SV_WriteDownloadToClient.
- sv_main: SV_Frame. sv_init: the G2VertSpaceServer line of SV_Init.

## Functions not read

- CCMLandScape (all methods), CCMPatch (all five methods), CRMManager, CRMObjective: the terrain and random mission classes of the round. Only an RMG map or a terrain brush reaches them.
- cm_terrain: the 14 wrappers (they keep signature markers).
- cm_patch: the patch build path (CM_GeneratePatchCollide body, CM_PatchCollideFromGrid, CM_AddFacetBevels, CM_ValidateFacet, the grid functions, CM_FindPlane and its helpers), except the lines above.
- cm_test: CM_BoxLeafnums_r, CM_BoxLeafnums, CM_StoreLeafs, CM_PointLeafnum, CM_TransformedPointContents, and the rest of CM_PointContents. cm_load: CM_ClusterPVS, CM_AreasConnected, CM_WriteAreaBits, CM_ModelContents.
- sv_snapshot: SV_EmitPacketEntities, SV_WriteSnapshotToClient, SV_UpdateServerCommandsToClient, SV_RateMsec, SV_SendMessageToClient, SV_SendClientSnapshot, SV_SendClientMessages.
- sv_main: all functions except SV_Frame. sv_client: all functions except the lines above.
- The botlib and other non-cm, non-sv stems of the tenth batch (be_*, l_*, tr_*, matcomp), which are outside this scope.
