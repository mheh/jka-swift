# The fixes of review 11

Tree: branch `dedicated-review-fixes-11` from master `f292db9`. The reviews: `review-11-cmsv.md`, `review-11-g2tr.md`, and `review-11-path.md` of this folder. Every Swift cite is under `Sources/JKAMP_DedLogic/` unless the cite names another target.

## A. The double and float math calls

The finding said that `fabs` at `cm_trace.cpp:1676` to `:1680` returns `double`. That is true for a C file, and it is not true here. Every file of the WinDed link set is C++. In C++, `<math.h>` declares `float` overloads of `fabs`, `sqrt`, `sin`, `cos`, `atan2`, `floor`, `ceil`, `pow`, `acos`, `asin`, and `tan`, and a call with a `float` argument resolves to the `float` overload. The libc++ headers of the oracle parse do this in `-std=c++03` too, and the MSVC headers of Raven's build have the same `float` overloads. No Raven header remaps these names. `Q_fabs` of `q_shared.h:1222` is a separate `float` function. So `abs(tw.sphere.offset[i])` in `float` is Raven's line, and `cm_trace.swift:1579` to `:1583` stays as it is.

The sweep parsed the WinDed unity TU with the `mp-engine-ded` unit of `project.toml` and listed every call of these functions with the overload that clang resolved, 156 calls. The parse has errors in some headers, so a function that did not parse is not in the list. Then it compared each call with the Swift line. The ruled forms are the plain `float` call, for example `abs(offset)`, and `Double(abs(x)) < 0.1` where a `float` result meets a double literal (`be_aas_reach.swift:2425`).

Fixed, 15 sites in 7 files. Each one widened a `float` overload to `Double`:

- `be_aas_move.swift:440`, Raven `be_aas_move.cpp:392`: `sqrt` of a `vec_t`.
- `be_aas_move.swift:1145`, Raven `:1076`: `sqrt` of a `float`, then a `float` division. The old line divided the unrounded double, so the value could differ.
- `be_ai_char.swift:313`, Raven `be_ai_char.cpp:353`: `fabs` of a `float`, compared with `0.01`.
- `be_ai_move.swift:1313`, Raven `be_ai_move.cpp:1273`: `fabs` of a DotProduct, compared with `0.7`.
- `cm_patch.swift:1678` and `:1807`, Raven `cm_patch.cpp:1490` and `:1611`: `plane[3] += fabs(offset)`.
- `sv_game.swift:434`, `:437`, `:440`, `:443`, `:465`, `:468`, Raven `sv_game.cpp:473` to `:492`: the `sin`, `cos`, `atan2`, `sqrt`, `floor`, and `ceil` traps. The `sin`, `cos`, and `atan2` results could differ by one ulp.
- `cm_terrain.swift:64`, Raven `cm_terrain.cpp:1108`: `sin` with `M_PI`. The ratified line `docs/transcription.md:635` makes `M_PI` of `q_shared.h:548` a `Float`, so the call is the `float` overload. The form is `JKAShared.M_PI` of `CCMLandScape.swift:772`.
- `common.swift:1957` to `:1961` and `:1973` to `:1977`, Raven `common.cpp:2146` to `:2166`: the `M_PI` tests of Q_acos and Q_asin, by the same ruled line, two sites.

Correct as they are: the `double` calls of `be_aas_move.cpp:1067`, `be_aas_reach.cpp:251` and `:629` (a double literal in the argument), the `fabs` of a `double` at `l_precomp.cpp:2522` and `:2631`, and every other `float` call of the list. The `fmod(float, int)` calls of `G2_misc.cpp:693` and `:699` resolve to the `double` template in libc++, and the Swift calls the `float` overload. `fmod` is exact, so the value is the same. The `tan` of `be_aas_reach.cpp:3847` and the `sin` of `tr_init.cpp:1257` resolve to `double` in the parse only because the macOS math.h defines `M_PI` first. By the ratified `float` `M_PI`, the `float` calls of `be_aas_reach.swift:3969` and `tr_init.swift:1048` are Raven's lines. `G2_CreateQuaterion` of `tr_ghoul2.cpp:1074` to `:1088` and the timing function of `win_shared.cpp:395` have no Swift body.

## B. The exclusivity trap of G2_Set_Bone_Rag

Proved at the lines. `mBlist` is a stored property of the final class `CGhoul2Info` (`CGhoul2Info.swift:13`), so Swift checks the access at run time. `G2_bones.swift:3127` passes `&g2.mBlist` as `inout`, a modify access for the whole call. `G2_bones.swift:1076` calls G2_GetBoneMatrixLow, which calls `boneCache.Eval` (`tr_ghoul2.swift:442`). Eval calls EvalLow when the touch differs (`CBoneCache.swift:250`), and G2_SetBoneIKState makes it differ with G2_ConstructGhoulSkeleton at `G2_bones.swift:3116`. EvalLow calls G2_TransformBone (`CBoneCache.swift:117`), which reads `BC.rootBoneList` (`tr_ghoul2.swift:816`). The getter reads `rootBoneListOwner!.mBlist` (`CBoneCache.swift:70`), and the owner is the same `g2` (`tr_ghoul2.swift:1345`). That read overlaps the modify access, so the process stops.

No existing form fixes it. The ledger 9 rows (`rootBoneListOwner`, the `inout` of `boneInfo_v &`) give the conflict and not a way out of it. No change. The candidates:

1. The callers copy the list out, call with the copy, and store it back. No new helper, but 26 sites take the form, and during the call the cache reads the old list, which lacks a bone that G2_Add_Bone appended in the same call.
2. G2_Set_Bone_Rag takes no `inout` list and works on `ghoul2.mBlist` through the instance. One signature leaves Raven's `boneInfo_v &`, which needs a PARAMS row.
3. The bone lists become one reference type, the shape of Raven's reference to a vector. This touches the 118 `inout` list sites.
4. Row R4 of `notes/2026-10-29/performance-profile.md`, `-enforce-exclusivity=unchecked`. This removes the diagnostic for every access, and the user reserved it.

The search of the Ghoul2 and bone files: 55 functions take a list as `inout`. Four reach the bone cache. G2_Set_Bone_Rag holds `mBlist`, and its callers are G2_SetBoneIKState (`G2_bones.swift:3127`) and G2_SetRagDoll (`G2_bones.swift:1332` to `:1357`, 25 calls, dead on the server). G2_ProcessSurfaceBolt2 (`tr_ghoul2.swift:1861`) holds `mBltlist`, and G2_TransformSurfaces (`G2_misc.swift:568`) holds `mSlist`. Each reaches Eval, which reads only `mBlist`, a different property, so they do not conflict. G2_TransformGhoulBones holds `mBlist` and only stores the owner. So the open shape has 26 call sites in 2 functions.

## C. Float to int conversions

The documented form is the plain `Int32(x)`. `docs/transcription.md:627` keeps an explicit cast of Raven, and `docs/transcription.md:644` gives `Int32(...)` at the store of any other `float` into an `int`. The sites follow it: `sv_world.swift:231`, `:240`, `:249` (implicit stores, `sv_world.cpp:211`, `:218`, `:225`), `sv_client.swift:569` to `:570` (the explicit `(long)` cast), and `G2_bones.swift:699` and `:702` (implicit stores, `G2_bones.cpp:678` and `:683`). No change. `truncateToInt` of `Sources/JKAShared/q_math.swift:125` is the rule 19 form of `G2_bones.swift:768`, used where a site proves that an infinite or NaN value reaches the conversion. A site of this list takes it only on such a proof.

## D. The dangling bone of G2_RagGetAnimMatrix

Proved undefined. Raven takes `boneInfo_t &bone = ghoul2.mBlist[bListIndex]` (`tr_ghoul2.cpp:1455`). The recursive call (`:1470`) can reach G2_Add_Bone, which reuses a free slot or calls `push_back` (`G2_bones.cpp:139`). A reallocation frees the old buffer, so the writes at `:1495` and `:1528` go through a dangling reference. The Swift element is a class object, so the writes reach the live bone. A rule 19 Port-note of two lines is at the `let bone` line of `tr_ghoul2.swift`.

## E. planes[-1] in CM_EdgePlaneNum

Proved on master. CM_GridPlane returns -1 after its warning (`cm_patch.cpp:605`), and each of the six arms of CM_EdgePlaneNum reads `planes[p]` (`cm_patch.cpp:624` and the five arms after it). Raven reads before the array. `planes` is a `Slots<PatchPlane>`, whose subscript traps on a negative index (`Sources/JKAShared/Views/Slots.swift:32`). This is the trap that rule 19 names. A Port-note of two lines is above the switch of `cm_patch.swift`, and the behavior stays.

## Open

- B: the exclusivity trap, with the four candidates above.
- `G2_misc.swift:609` and `:614`: the `fmod(float, int)` overload. The value is the same, and no change is needed unless a ruling wants the `double` form of the parse.
