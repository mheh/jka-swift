# Review W4: bodies of sets S5, S6, S7

Scope: the own commits of each branch, `git diff dedicated-rulings-batch-12...HEAD -- Sources`.
The two-dot diff also shows the newer batch-12 commits in reverse (for example the `G2_Set_Bone_Rag` signature in `G2_bones.swift`).
Those lines are not part of this review.

Grades: DEFECT 0, SUSPECT 0, NOTE 3.

## The widened sites (settled first)

Rule: in C++ a math call on a `float` argument takes the float overload, a double literal widens the expression to double, and an `f` literal does not.
Background fact: a double has 53 bits and a float has 24. 53 is not less than 2*24+2, so one `+`, `-`, `*`, `/`, or `sqrt` on float operands done in double and then rounded to float gives the same bits as the float operation. The widening changes bits only when the expression has two or more operations, or a literal that a float cannot hold exactly.

1. `baryCentricK`, G2_ProcessSurfaceBolt.
   - Raven `renderer/tr_ghoul2.cpp:2364`: `float baryCentricK = 1.0 - (surfInfo->genBarycentricI + surfInfo->genBarycentricJ);`
   - Raven `renderer/tr_ghoul2.cpp:3119` (G2_ProcessSurfaceBolt2): the same line, also `1.0`.
   - Swift S5 `/tmp/jka-s5/Sources/JKAMP_DedLogic/tr_ghoul2.swift:1685`: `let baryCentricK = Float(1.0 - Double(surfInfo!.genBarycentricI + surfInfo!.genBarycentricJ))`
   - Swift Bolt2 `/tmp/jka-s5/Sources/JKAMP_DedLogic/tr_ghoul2.swift:2196`: `let baryCentricK: Float = 1.0 - (surfInfo!.genBarycentricI + surfInfo!.genBarycentricJ)`
   - Verdict: Raven's two lines are the same, so the two Swift lines must agree. C adds I and J in float, then subtracts in double. S5's line is the rule's form and is right. See NOTE N1 for Bolt2.
2. Radius, G2_ComputeLOD. Raven `tr_ghoul2.cpp:999`: `ProjectRadius( 0.75*largestScale*ent->e.radius, ...)`. Swift `tr_ghoul2.swift` (S5 diff, G2_ComputeLOD): `ProjectRadius(Float(0.75 * Double(largestScale) * Double(ent.e.radius)), ent.e.origin)`. Right. Two products in double, then one rounding at the float parameter. The plain float form would round twice and could change bits.
3. `sqrt(1.0 + ...)`, G2_CreateQuaterion. Raven `tr_ghoul2.cpp:1074`, `:1081`, `:1088`: `s = sqrt( 1.0 + mat->matrix[0][0] - mat->matrix[1][1] - mat->matrix[2][2])* 2;`. The argument is double, so the double `sqrt` is called. Swift (S5 diff, G2_CreateQuaterion): `s = Float(sqrt(1.0 + Double(mat.matrix[0][0]) - Double(mat.matrix[1][1]) - Double(mat.matrix[2][2])) * 2)`. Right.
   The first branch, Raven `:1060` `s = sqrt(t) * 2;`, has a float `t`, so the float overload is called. Swift `s = sqrt(t) * 2` is right. Swift `if Double(t) > 0.00000001` is right for Raven `:1058` `if (t > 0.00000001)`.
4. `0.25 * s`, G2_CreateQuaterion. Raven `tr_ghoul2.cpp:1064`, `:1075`, `:1083`, `:1091`: `quat[3] = 0.25 * s;`, which is a double product. Swift `quat[3] = Float(0.25 * Double(s))` is right. The product is a power-of-two scale, so the float form would give the same bits. The widened form follows the rule.
5. `fadedist*1.33`, ParseSurfaceSprites. Raven `renderer/tr_shader.cpp:925`: `stage->ss->fadeMax = fadedist*1.33;`. Swift `/tmp/jka-s7/Sources/JKAMP_DedLogic/tr_shader.swift:936`: `ss.fadeMax = Float(Double(fadedist) * 1.33)`. Right. 1.33 has no exact float value, so float math would change bits.
6. `1.0f/atof(token)`, ParseDeform. Raven `tr_shader.cpp:2023`: `ds->deformationSpread = 1.0f / atof( token );`. Swift `tr_shader.swift:1357`: `ds.deformationSpread = Float(1.0 / atof(token))`. Right. `atof` returns double, and `1.0f` widens to exactly 1.0.

## Findings

### N1 NOTE: G2_ProcessSurfaceBolt2 computes baryCentricK in float, against rule text
- Swift `/tmp/jka-s5/Sources/JKAMP_DedLogic/tr_ghoul2.swift:2196`: `let baryCentricK: Float = 1.0 - (surfInfo!.genBarycentricI + surfInfo!.genBarycentricJ)`
- Raven `oracle/codemp/renderer/tr_ghoul2.cpp:3119`: `float baryCentricK = 1.0 - (surfInfo->genBarycentricI + surfInfo->genBarycentricJ);`
- Effect: none on the result. The double step is one subtraction of two float values, so the result has the same bits. The line still breaks `docs/transcription.md:633`. The fix for consistency is the S5 form at `:1685`. This line comes from an earlier round and is not in the S5 diff.

### N2 NOTE: the Port-note of G2_Get_Bone_Name leaves out the third call
- Swift `/tmp/jka-s6/Sources/JKAMP_DedLogic/G2_bones.swift` (G2_Get_Bone_Name, first comment line): `// Raven's two calls, at G2_bones.cpp:2625 and :3851, stand under _DEBUG_BONE_NAMES, and only _DEBUG defines it (:2576), so the Release build has no caller.`
- Raven `oracle/codemp/ghoul2/G2_bones.cpp:3964`: `strcpy(callData->boneName, G2_Get_Bone_Name(&ghoul2V[0], ghoul2V[0].mBlist, bone.boneNumber));`. This call is in G2_BoneSnap, in the `#else` arm of `#ifdef DEDICATED` (`:3953` to `:3967`).
- Effect: none on behavior. The body is dead in the dedicated build. But Raven has three calls, not two, and the client Release build does call the function. The old note named the G2_BoneSnap arm. The new note should name all three calls and say "the dedicated build".

### N3 NOTE: G2_ComputeLOD converts float to int with `Int32(flod)`, which traps on NaN
- Swift `/tmp/jka-s5/Sources/JKAMP_DedLogic/tr_ghoul2.swift` (G2_ComputeLOD): `lod = Int32(flod)`
- Raven `oracle/codemp/renderer/tr_ghoul2.cpp:1021`: `lod = myftol( flod );` (`(int)(x)` under DEDICATED, `:1018`).
- Effect: Swift traps on NaN or on a value out of the `int` range. MSVC gives `0x80000000`. The value is bounded only if ProjectRadius is bounded. This review did not read ProjectRadius. The conversion is the form that rule `transcription.md:644` requires, so this is not a defect. It is recorded only because a dead body has no other check.

## Checked and found faithful (no finding)

S5 (`tr_ghoul2.swift`, `CRenderableSurface.swift`):
- G2_Find_Bone_ByNum (Raven :112), G2_GetBoneNameFromSkel (:678), G2_GetParentBoneMatrixLow (:780). The AI line on the `inout MdxaBone?` out pointers is true. The parent clamp, the identity store, and the delegate call match.
- R_GCullModel (:896). All three cases and the counters match.
- R_GComputeFogNum (:939). The loop starts at 1, and the `j == 3` test matches.
- G2_ComputeLOD (:967). The clamps and the bias match.
- G2_CreateQuaterion (:1048), G2_CreateMatrixFromQuaterion (:1097).
- G2_SetUpBolts (:2053).
- G2_ProcessSurfaceBolt (:2246). The triangle and vertex byte offsets step by `MdxmTriangle.byteCount` and `MdxmVertex.byteCount`. The vertex step at the end of each pass matches. `pTri` indexes per vertex as in the non-XBOX arm. The axes and sides math, the `MDX_TAG_ORIGIN` origin, and the axis swap with signs match.
- G2_ProcessGeneratedSurfaceBolts (:2495). The timer is live because `G2_PERFORMANCE_ANALYSIS` is defined under `#ifndef FINAL_BUILD`, `game/q_shared.h:45-46`.
- ProcessModelBoltSurfaces (:2739). The early return skips the timer End, as Raven's code does.
- bInShadowRange (:3369).
- CRenderableSurface `operator=` and `Init` (`tr_local.h:2067`, `:2092`).
- `boltInfo_t.position` and `MdxaBone` are handle views, so the writes through `Multiply_3x4Matrix` reach the list.

S6:
- G2_GorePolys (`G2_misc.cpp:804`). All literals are `f` literals. The flag masks, the cull, and the vertex remap match. The data block layout matches: count words, then `newNumVerts*9` words skipped, then the texture pairs, then the indices, then the 24-float matrix pair. The allocation is `sizeof(int)*size` bytes. The AI lines (the X8 heap and the memcpy loops) state the change truly.
- G2_LerpAngles (`G2_misc.cpp:1912`). `boneInfo_t` is a class, and `matrix` and `newMatrix` are slot views, so the writes alias as in Raven.
- G2_Animate_Bone_List (`G2_bones.cpp:1065`). `50.0f`, `Int32(endFrame - startFrame)` for the implicit `int` store, and `fmod` in float all match. `fmod` is exact, so the overload does not change the result.
- G2_SetRagDollBullet (`G2_bones.cpp:2040`). `int magicFactor13=150.0f` gives 150. The loop goes in reverse. `fabs` is `abs`. The `#if 0` block is correctly left out.
- G2_Get_Bone_Name (`G2_bones.cpp:2580`). The body matches. See N2 for the note.
- CBoneCache::SetRenderMatrix (`tr_ghoul2.cpp:208`). The whole body is under `#ifdef _XBOX`, so an empty body is right.
- CBoneCache::SmoothLow (`tr_ghoul2.cpp:267`). The 12-float lerp, the memcpy arm, the normalize and scale by `maxl`, and the touch update match.

S7 (`tr_shader.swift`):
- ParseTexMod (:572). All seven keywords, every warning, and every return match. A local cursor over `_text` is right, because Raven's `text` points at its own parameter.
- ParseSurfaceSprites (:808). The `_ = ss.vertSkew` line keeps Raven's no-op statement at :934.
- ParseSurfaceSpritesOptional (:970). The 13 keywords, the bounds, and the case-insensitive `Q_stricmp` match. `fxDuration` is `float` in `tr_local.h:367`, so the store with no cast is right.
- ParseDeform (:1936). `text` with `token[4]` reads the NUL that `CharBuf(String)` appends, so n becomes 0 as in C. `Q_stricmpn` with 4 matches. The order of the deform checks matches.
- RE_RegisterShaderFromImage (:3598). The hash walk, the clear, the copies, the texMods rows, the five lightmap arms, and the `|=` on stage 1 match.

## Functions read
S5: G2_Find_Bone_ByNum, G2_GetBoneNameFromSkel, G2_GetParentBoneMatrixLow, R_GCullModel, R_GComputeFogNum, G2_ComputeLOD, G2_CreateQuaterion, G2_CreateMatrixFromQuaterion, G2_SetUpBolts, G2_ProcessSurfaceBolt, G2_ProcessGeneratedSurfaceBolts, ProcessModelBoltSurfaces, bInShadowRange, CRenderableSurface.copy, CRenderableSurface.Init.
S6: G2_GorePolys, G2_LerpAngles, G2_Animate_Bone_List, G2_SetRagDollBullet, G2_Get_Bone_Name, CBoneCache.SetRenderMatrix, CBoneCache.SmoothLow.
S7: ParseTexMod, ParseSurfaceSprites, ParseSurfaceSpritesOptional, ParseDeform, RE_RegisterShaderFromImage.

## Not read
- The callees' bodies: ProjectRadius, R_CullLocalPointAndRadius, G2_GetVertBoneWeight, G2_FindOverrideSurface, ParseWaveForm, FinishShader, IsShader, Com_Error. This review took their signatures as given.
- The view record sizes in `mdx_format.h` against `MdxmVertex.byteCount` and `MdxmTriangle.byteCount`. The bodies use the generated byteCount and no literal size.
- The `notes/2026-11-10/dedicated-body-round-s<N>.md` records.
- G2_ProcessSurfaceBolt2, except its `baryCentricK` line.
