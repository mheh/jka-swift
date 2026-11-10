# The G2_bones, G2_misc, and tr_ghoul2 body round

This record holds the body round of `Sources/JKAMP_DedLogic/G2_bones.swift`, `G2_misc.swift`, and `tr_ghoul2.swift`, the stems of Raven's `oracle/codemp/ghoul2/G2_bones.cpp`, `oracle/codemp/ghoul2/G2_misc.cpp`, and `oracle/codemp/renderer/tr_ghoul2.cpp`. The tree is the worktree `/tmp/jka-g2-bones` on the branch `ded-bodies-g2-bones`, off master at 7961ee4. The code commit is 01095d0. The round ran no generator, no python tool, and no drafter.

## The bodies

The three stubs had the skeleton header, so the round adopted them and removed the header in the code commit. Most functions of the three stems carry a `TODO: Port signature` marker, because the table has no row for the Ghoul2 C++ types. A function with a marker keeps it, because a signature comes only from the generator. The round filled each function and each data initializer with a generated signature where every callee and global exists.

- G2_bones: `handPos` and `handPos2` take Raven's `{0,0,0}`. AngleNormZero is whole, and its `assert` drops under NDEBUG.
- G2_misc: G2_AreaOfTri, G2_SegmentTriangleTest, and G2_FindConfigStringSpace are whole. Raven's `stricmp` is `Q_stricmp` by `LIBC_SPELLINGS`, and `sizeof(s)` is `Int32(s.count)`.
- tr_ghoul2: G2Time_ResetTimers and G2Time_ReportTimers are whole. `goreShader` takes Raven's `-1`, because the dedicated unit never assigns it. `OldToNewRemapTable` takes Raven's 72 rows with his comments.

## The stubs that stay

Each function below has a generated signature and keeps its stub under a Port-note that names the gap.

| Function | Gap | Row |
|---|---|---|
| G2_RagDollMatchPosition | `haveDesiredPelvisOffset`, `ragBoneData`, and `ragEffectors` have no storage | G2B2 |
| G2_BoneOnGround | Rag_Trace has a signature marker | G2B1 |
| DestroyGoreTexCoordinates | FindGoreRecord has a signature marker | G2B3 |
| AllocGoreRecord, ResetGoreTag, DeleteGoreRecord, DeleteGoreSet | `GoreRecords`, `GoreTagsTemp`, and `GoreSets` have no storage | G2B3 |
| G2_List_Model_Surfaces, G2_List_Model_Bones, G2_GetAnimFileName | R_GetModelByHandle has a signature marker, and `model_t` has no view | G2B4 |
| G2_GenerateWorldMatrix | Create_Matrix and Inverse_Matrix have markers, and `worldMatrix` and `worldMatrixInv` have no storage | G2B5 |
| G2_FreeSaveBuffer | the parameter is a `CharBuf`, and Z_Free takes the zone block | G2B6 |
| bInShadowRange | the global `tr` has no view | G2B7 |

## Rows for the user

- Row G2B1, the Ghoul2 parameter types. Question: the table has no row for `boneInfo_v &`, `boneInfo_t &`, `CGhoul2Info *`, `CGhoul2Info &`, `CGhoul2Info_v &`, `CRagDollUpdateParams *`, `EG2_Collision`, `mdxaHeader_t *`, or `const model_t *`, so 53 functions of G2_bones, 22 of G2_misc, and 39 of tr_ghoul2 have no signature. Proof: `G2_bones.cpp:40` and `G2_bones.swift:178` (G2_Find_Bone), `G2_bones.cpp:1065` and `G2_bones.swift:396` (G2_Animate_Bone_List), `G2_bones.cpp:2683` and `G2_bones.swift:529` (Rag_Trace), `tr_ghoul2.cpp:592` and `tr_ghoul2.swift:301` (G2_GetModA). The other agent's G2_API, G2_bolts, and G2_surfaces stems hold the same types. Proposal: row C of the seventh ledger, the C++ track of rule 17, decides the shape of `CGhoul2Info` and `boneInfo_t` first, and the table rows follow from it.
- Row G2B2, the ragdoll statics. Question: `ragBasepose`, `ragBaseposeInv`, `ragBones`, `ragEffectors`, `ragBoneData`, `haveDesiredPelvisOffset`, and `rag` have no storage. Proof: `G2_bones.cpp:1214` to `:1218`, `:1225`, and `:1241`, and `G2_bones.swift:82`, `:87`, `:128`, and `:165`. Proposal: `bool` takes the `Bool` row of a variable, `mdxaBone_t` takes a view by row G2B5, and the arrays take a `Slots` on the engine storage class.
- Row G2B3, the gore maps. Question: `map<int,GoreTextureCoordinates> GoreRecords`, `map<pair<int,int>,int> GoreTagsTemp`, and `map<int,CGoreSet *> GoreSets` have no storage, and FindGoreRecord, G2_GetGoreRecord, FindGoreSet, and NewGoreSet return a C++ class pointer. Proof: `G2_misc.cpp:35`, `:36`, `:103`, and `:125`, and `G2_misc.swift:25`, `:30`, `:56`, and `:129`. Proposal: rule 17 makes each map a Swift `Dictionary` on the engine world, keyed as Raven keys it, and the classes take the shape of row G2B1.
- Row G2B4, `model_t` and R_GetModelByHandle. Question: R_GetModelByHandle has a signature marker, and `model_t`, `mdxmHeader_t`, `mdxmSurfHierarchy_t`, `mdxaHeader_t`, and `mdxaSkel_t` have no view. Proof: `tr_model.cpp:593` and `tr_model.swift:143`, and the callers `G2_misc.cpp:282`, `:312`, and `:359`. The renderer stems of the third agent hold this function. Proposal: `model_t` joins `HOST_ROOTS` with the generated view, and the mdx headers take hand views over the loaded block, in the form of the jka-rust `MdxmView`.
- Row G2B5, `mdxaBone_t`. Question: `mdxaBone_t` of `q_shared.h` has no view, so `worldMatrix`, `worldMatrixInv`, and `identityMatrix` have no storage, and TransformPoint, TransformAndTranslatePoint, Create_Matrix, Inverse_Matrix, and Multiply_3x4Matrix have no signature. Proof: `tr_ghoul2.cpp:128`, `:136`, and `:137`, `G2_misc.cpp:1613` to `:1656`, and `tr_ghoul2.swift:122` and `G2_misc.swift:392` and `:411`. Proposal: `mdxaBone_t` is a Swift struct of three `vec4_t` rows by rule 12 for an internal type, the two globals are variables on the engine world, and `mdxaBone_t *` is `inout` for a written matrix and a value for a read one.
- Row G2B6, the `char *buffer` of G2_FreeSaveBuffer. Question: the table gives the parameter as `inout CharBuf`, and Raven hands it to Z_Free, which takes the zone block as `OpaquePointer?`. Proof: `G2_misc.cpp:1812` and `G2_misc.swift:455`, and `z_memman_pc.swift:261`. The block comes from the Z_Malloc of G2_SaveGhoul2Models (`G2_misc.cpp:1719`). Proposal: the parameter takes the `OpaquePointer?` of a zone block, the form of `ev.evPtr` at `common.swift:1144`, in the signature batch that gives G2_SaveGhoul2Models its `char **buffer`.
- Row G2B7, the global `tr`. Question: `trGlobals_t tr` has no view, so bInShadowRange cannot read `tr.viewParms.ori`. Proof: `tr_ghoul2.cpp:3369` and `tr_ghoul2.swift:600`, and `tr_main.swift:9`. The one caller is R_AddGhoulSurfaces under `#ifndef DEDICATED` at `tr_ghoul2.cpp:3384`. Proposal: the dead-function note of rule 20 for the dedicated unit.
- Row G2B8, the `timing_c` globals. Question: `timing_c` of `timing.h` has no view, so the nine `G2PerformanceTimer_*` globals have no storage. Proof: `tr_ghoul2.cpp:42` to `:50`, and `tr_ghoul2.swift:7`. No body of the dedicated unit reads them. Proposal: the dead-surface note of rule 20.

## Counts

`portMissing` counts, before and after: G2_bones.swift 58 to 55, G2_misc.swift 35 to 32, tr_ghoul2.swift 44 to 40. The remaining counts hold 53, 22, and 39 signature markers, and 2, 10, and 1 Port-note stubs. `grep -c Unsafe` gives 0 on all three files.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, first run, no error, no warning in the three files |
| `swift test --no-parallel -j 2` | exit 0, 150 tests in 9 runs passed, 0 failed |

The round ran no draftcheck and no snapshot, because one tool pass runs after all six rounds merge.
