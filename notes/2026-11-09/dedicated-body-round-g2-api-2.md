# Dedicated body round: g2-api-2

Branch `ded-bodies-g2-api-2`, off master at `837bc43`, in the worktree `/tmp/jka-g2-api-2`. The code commit is `f181541`. The round ran no generator, no python tool, no draftcheck, and no snapshot tool. The stems are G2_API, G2_bolts, and G2_surfaces of `oracle/codemp/ghoul2/`, and the hand classes whose methods `G2_API.cpp` and `ghoul2_shared.h` define: `CGhoul2Info_v`, `Ghoul2InfoArray`, `CGhoul2Info`, `surfaceInfo_t`, `boltInfo_t`, and `boneInfo_t`. `CConstructBoneList` has no method, and the round of `G2_bones`, `G2_misc`, and `tr_ghoul2` owns the other classes.

## Adoption

G2_bolts.swift and G2_surfaces.swift lose the skeleton header in the code commit. G2_API.swift and the class files had no header.

## Bodies filled

| File | portMissing before | portMissing after | Filled |
|---|---|---|---|
| G2_API.swift | 92 | 20 | 72 |
| G2_bolts.swift | 7 | 1 | 6 |
| G2_surfaces.swift | 14 | 10 | 4 |
| CGhoul2Info_v.swift | 13 | 3 | 10 |
| Ghoul2InfoArray.swift | 6 | 0 | 6 |
| boltInfo_t.swift | 1 | 1 | 0 |
| boneInfo_t.swift | 1 | 1 | 0 |

`grep -c Unsafe` gives 0 on each of the five edited files.

- G2_API: the leak tracker, TheGhoul2InfoArray and Ghoul2InfoArray_Free over `singleton`, the model clean and remove functions, G2_TestModelPointers and the `CGhoul2Info *` overload of G2_SetupModelPointers, the bone, bolt, surface, and ragdoll wrappers, the gore functions, and G2API_GetAnimFileNameIndex, whose `model_t` view now exists. G2API_AttachInstanceToEntNum is empty and G2API_OverrideServerWithClientData returns false, because `_G2_LISTEN_SERVER_OPT` is not defined.
- G2_bolts: every function but G2_Add_Bolt.
- G2_surfaces: G2_FindOverrideSurface, G2_RemoveRedundantGeneratedSurfaces, G2_AddSurface, and G2_RemoveSurface.
- CGhoul2Info_v: Alloc, Free, Array, the destructor, both `operator=` forms, the subscript, clear, size, and kill.
- Ghoul2InfoArray: every method. Get returns an empty Array where Raven returns his static empty vector, under one rule 24 line.

### Forms the bodies use

- A vector `size()` reads `Int32(list.count)`, the form of `GetNumMembers` at `Sources/JKAMP_DedLogic/CBlock.swift:171`. A shrink by `resize` reads `removeLast`, `clear` reads `removeAll`, `push_back` reads `append`, and the `list<int>` front operations read `insert(_:at: 0)` and `removeFirst`.
- Raven's explicit destructor call and his `delete` of a `CGhoul2Info_v` read `clear()`, whose body is the destructor's one call to Free, under one rule 24 line. A Swift reference that a caller or the leak tracker still holds keeps the instance alive, so the destructor of Raven runs at the `delete` site and not at the last release.
- Raven's `sizeof(*ghoul2Ptr)` in the leak accounting is the size of a pointer, `UInt.byteCount`, and his `sizeof(CGhoul2Info_v)` is the size of its one `int` field, `Int32.byteCount`. A comment at each site names the size.
- Raven's `(int)&ghoul2` test of a reference drops, because a class parameter is never nil. In G2API_SetBoneAnim, the `if (ghlInfo)` test of `&ghoul2[modelIndex]` drops for the same reason, so the `!setPtrs` arm is dead and drops with it. That arm calls the `CGhoul2Info_v &` overload of G2_SetupModelPointers in G2API_SetBoneAngles, which stays a stub for another reason.
- The `#if 0` block of G2_SetupModelPointers stays as `if false`, and the `|| 1` test stays as `|| true`, because Raven wrote both.

### Rule 19 notes

- G2_RemoveRedundantBolts, `G2_bolts.cpp:286`: after the removal of a generated-surface bolt, Raven falls into the original-surface block and reads `activeSurfaces[-1]`, or reads past the end of the list when the resize dropped the bolt. The block runs only while the bolt is still in the list with a surface. A second removal changes nothing, so the result is the same for every value C could read.
- Ghoul2InfoArray::DeleteLow, `G2_API.cpp:337`: `mIds[idx]+=MAX_G2_MODELS` overflows a signed int after about two million deletes of one slot, because the rollover test of `:330` can never be true. The add wraps at 32 bits.
- G2_DEBUG_ReportLeaks, `G2_API.cpp:68`: Raven takes `g2v[0]` before the IsValid test, and an invalid handle gives an empty list. The body reads element 0 only after the test.

## Stubs that stay

Three stubs of G2_API carry the generator's `TODO: Port signature` marker: G2API_SetBoneIKState, G2API_IKMove, and G2API_AddSkinGore. The rows below cover every other stub that stays, and each stub carries a Port-note that names its gap.

### Row G2A1, the copy of a CGhoul2Info list

Question: CGhoul2Info_v::resize, push_back, and DeepCopy write the list that `Array()` returns by reference, and G2API_InitGhoul2Model and G2API_CopySpecificG2Model assign a CGhoul2Info by value into a slot.

Proof: `ghoul2_shared.h:350`, `:388`, `:411`, and `:430`, `G2_API.cpp:638` and `:2315`, and `Sources/JKAMP_DedLogic/CGhoul2Info_v.swift:32`, `:67`, `:74`, `:80`, and `:92`, `Ghoul2InfoArray.swift:89`, and `G2_API.swift:284` and `:1205`. Ledger 8 names the copy return of `Array` and `Get` as left open in the classes.

Pattern: the generator batch gives `Array` and `Get` a write path into `mInfos`. The value copy needs a CGhoul2Info copy in the form of the views' `copy(from:)`, which transcription.md gives for Raven's `a = b` on two records, and a subscript setter on CGhoul2Info_v.

### Row G2A2, the CGhoul2Info_v overload of G2_SetupModelPointers

Question: `qboolean G2_SetupModelPointers(CGhoul2Info_v &ghoul2)` of `G2_API.cpp:2773` has no Swift function, only a marker comment at `G2_API.swift:1492`, because the `CGhoul2Info *` overload holds the name.

Proof: the callers G2API_SetRootSurface (`G2_API.cpp:733`, `G2_API.swift:346`), G2API_AttachG2Model (`:1658`, `:946`), G2API_GetBoltMatrix (`:1795`, `:998`), G2API_CollisionDetectCache (`:2035`, `:1113`), G2API_CollisionDetect (`:2124`, `:1120`), and G2API_GetGLAName (`:2412`, `:1252`).

Pattern: a second overload beside `func G2_SetupModelPointers(_ ghlInfo: CGhoul2Info?) -> Bool` at `G2_API.swift:1425`, with the parameter `CGhoul2Info_v` that PR 84 gave every other `CGhoul2Info_v &`.

### Row G2A3, the `void *mod` of G2_IsSurfaceLegal

Question: the parameter `mod` is `OpaquePointer?` at `Sources/JKAMP_DedLogic/G2_surfaces.swift:25`, so no logic body can call the function or read the model.

Proof: `G2_surfaces.cpp:65` casts `mod` to `model_t *` on its first line. The callers G2_SetSurfaceOnOff (`G2_surfaces.cpp:148`, `G2_surfaces.swift:56`), G2_SetSurfaceOnOffFromSkin (`:201`, `:63`), G2_SetRootSurface (`:337`, `:112`), G2_GetSurfaceIndex (`:603`, `:197`), G2_IsSurfaceRendered (`:611`, `:204`), and G2_Add_Bolt (`G2_bolts.cpp:119`, `G2_bolts.swift:104`) all pass a `model_t *`.

Pattern: the PARAMS kind `("view", "model_t")`, the form row G4 of ledger 8 gave `a` and `b` of QsortDistance for `CollisionRecord_t`.

### Row G2A4, the mdx records at a byte offset

Question: Raven walks the skeleton and the surface hierarchy at a byte offset from the header, `(byte *)mdxa + sizeof(mdxaHeader_t) + offsets->offsets[i]` and `(byte *)surf + (int)&((mdxmSurfHierarchy_t *)0)->childIndexes[surf->numChildren]`. `Slots(record:)` covers only the header bytes, and a logic body holds no raw pointer.

Proof: G2API_DoesBoneExist (`G2_API.cpp:963`, `G2_API.swift:545`), G2API_SkinlessModel (`:2499`, `:1323`), G2API_GetSurfaceName (`:2360`, `:1237`), G2_IsSurfaceLegal (`G2_surfaces.cpp:65`), G2_FindSurface (`:98`, `G2_surfaces.swift:48`), G2_IsSurfaceOff (`:229`, `:71`), G2_FindRecursiveSurface (`:266`, `:78`), G2_GetParentSurface (`:588`, `:190`), G2_IsSurfaceRendered (`:611`, `:204`), and G2_Add_Bolt (`G2_bolts.cpp:119`).

Pattern: a view-target function under one rule 24 line that gives the record view at the offset, the form of `ZoneHeader(block:)` and `ZoneTailFromHeader(_:)` in `Sources/JKAMP_Ded/ZoneBlocks.swift`, or the hand mdx views that row G2B4 of `dedicated-body-round-g2-bones.md` proposed after the jka-rust `MdxmView`.

### Row G2A5, G2_FindSurface of G2_misc

Question: `void *G2_FindSurface(void *mod_t, int index, int lod)` of `G2_misc.cpp:1689` has a signature marker and is `private` at `Sources/JKAMP_DedLogic/G2_misc.swift:400`, so G2_surfaces cannot call it.

Proof: the callers `G2_surfaces.cpp:123`, `:269`, and `:596`, and `G2_API.cpp:2385`.

Pattern: the return `MdxmSurface?` and the parameter `Model`, the spellings of `G2_FindSurface` of G2_surfaces at `G2_surfaces.swift:48`, without `private`.

### Row G2A6, the modelList of G2API_GetBoneAnim

Question: `int *modelList` of `G2_API.cpp:1140` is `inout Int32` at `G2_API.swift:649`, and the callee G2_Get_Bone_Anim takes `Slots<qhandle_t>?` at `G2_bones.swift:276` for its `const int *modelList` of `G2_bones.cpp:905`.

Pattern: `Slots<qhandle_t>?`, the spelling of `modelList` of G2API_SetBoneAnglesIndex at `G2_API.swift:697`.

### Row G2A7, the angles of G2_Set_Bone_Angles

Question: G2API_SetBoneAnglesIndex and G2API_SetBoneAngles take `vec3_t angles` at `G2_API.swift:697` and `:704`, and pass it to G2_Set_Bone_Angles_Index and G2_Set_Bone_Angles, whose `const float *angles` of `G2_bones.cpp:435` and `:477` is `vec4_t?` at `G2_bones.swift:221` and `:228`.

Pattern: `vec3_t`, the spelling of the API's own `const vec3_t angles`, because each caller of the two callees passes a `vec3_t`.

### Row G2A8, GHOUL2_CRAZY_SMOOTH

Question: G2API_AbsurdSmoothing of `G2_API.cpp:1386` sets `GHOUL2_CRAZY_SMOOTH` of `ghoul2/G2_local.h:12`, and no module of the host declares the constant. The stub stands at `G2_API.swift:751`.

Pattern: the re-export of the other GHOUL2 flags in `Sources/JKAMP_Ded/Generated/ghoul2_shared.swift`, or a `let` in the file that reads it, in the form of `GHOUL2_RAG_STARTED` at `G2_API.swift:72`.

### Row G2A9, the four-argument G2_Animate_Bone_List

Question: G2API_AnimateG2Models of `G2_API.cpp:1434` calls `G2_Animate_Bone_List(ghoul2, currentTime, model, params)` of `G2_bones.cpp:4498`. The Swift function at `G2_bones.swift:324` has the three arguments of the overload at `G2_bones.cpp:1065`, and the C++ build compiles both. The stub stands at `G2_API.swift:778`.

Pattern: a second overload with `_ params: CRagDollUpdateParams?`, the parameter spelling of G2API_AnimateG2Models.

### Row G2A10, a matrix row as a vector

Question: G2API_GetBoltMatrix_SPMethod of `G2_API.cpp:1727` normalizes each row of a `mdxaBone_t` in place, `VectorNormalize((float*)use->matrix[0])`. `MdxaBone.matrix` is a `Slots<Slots<Float>>`, and VectorNormalize takes `inout vec3_t`. G2API_GetBoltMatrix of `:1795` has the same lines. The stub stands at `G2_API.swift:989`.

Pattern: the `<name>Vector` accessor that a `float *` field carries, given to a matrix row.

### Known gaps, no new row

- boltInfo_t and boneInfo_t keep their constructor stubs, because a field that holds `mdxaBone_t` by value has no allocator, as ledger 8 states. G2_Add_Bolt_Surf_Num calls `boltInfo_t()`, so it traps at that call until the generator batch fills the constructor.
- G2_SetupModelPointers calls `G2PerformanceTimer_G2_SetupModelPointers.Start()` and `End()`, because `G2_PERFORMANCE_ANALYSIS` is defined. The two methods of `Sources/JKAMP_DedLogic/timing_c.swift` are still stubs, so every API function that sets up the model pointers traps there until timing_c has bodies.
- A body passes a `CGhoul2Info` and `&ghlInfo.mBlist` of the same instance to one callee, as Raven does. A callee that reads `ghlInfo.mBlist` during that call violates Swift's exclusive access and traps. The signatures of row G2B1 hold both parameters.
- Raven's tracker keeps a dangling pointer after G2API_RemoveGhoul2Model deletes an instance, because only G2API_CleanGhoul2Models removes it. The Swift tracker holds the instance, so G2_DEBUG_ReportLeaks reads an instance whose handle is 0 where Raven reads freed memory.

## Gate

- `swift build -j 2`: exit 0 on the first run, 0 errors. Six warnings in the round's files, each at a line Raven wrote: five unused results of G2_Remove_Bolt and G2_RemoveSurface, and the unread `ignore` of G2API_DuplicateGhoul2Instance.
- `swift test --no-parallel -j 2`: exit 0, 150 tests in 25 suites, 0 failures.
