# Rows 13, G2 group

## G1. The bone-list overlap: SETTLED

What Raven needs: an alias. Every Raven caller passes the `mBlist` of the same `ghoul2` that it passes as the fourth argument: `G2_bones.cpp:1651` `boneInfo_v &blist = ghoul2.mBlist;` then `:1791` to `:1816`, and `:4671` `boneInfo_v &blist = g2.mBlist;` then `:4791`. In G2_Set_Bone_Rag (`:1318`), G2_Add_Bone can append to `blist` (`:1330`), and then G2_GetBoneMatrixLow (`:1338`) runs the bone cache. The cache reads the same list through `*BC.rootBoneList` (`tr_ghoul2.cpp:1551`, `:2219`), so the callee chain reads what the caller wrote. The cache does not change the list size.

Precedents:
- jka-rust, the same site: `jka-rust/crates/mp/engine/ghoul2/src/api_ragdoll.rs:466` to `:516`. `g2_set_bone_rag` takes no `blist`. It gets the list through the instance (`info.blist`), passes `&mut info.blist` to `g2_add_bone` for that call only, and then lets the cache read the live list. The doc at `:448` to `:451` gives the reason: "`blist` is always `ghlInfo`'s own `mBlist` at every call site, so this takes just `info`". `mod_a` is dropped too.
- `CBoneCache.swift:70`, ruled in ledger 9 (`dedicated-open-rows-ledger-9.md:56`): the cache gets `mBlist` through its owner, not as a separate list.
- `GenericParser2.swift:192`, `:372`, `:439`, `:455`: a Raven parameter that the Swift form makes unnecessary is dropped, with one AI line.
- The copy-through-a-local form (`q_math.swift:374`) is only for a callee that does not read the aliased storage. Here the cache reads it, so candidate 1 is not correct.

Change: in `Sources/JKAMP_DedLogic/G2_bones.swift`, remove `_ blist: inout [boneInfo_t]` from G2_Set_Bone_Rag (`:1076`). In the body, use `&ghoul2.mBlist` for G2_Find_Bone_Rag and G2_Add_Bone, and `ghoul2.mBlist[index]` for `bone`. Add one rule 24 line: `// AI: Raven passes ghoul2.mBlist again as blist. The function reads the list through ghoul2, because the bone cache reads the same list.` Remove the `&g2.mBlist` / `&ghoul2.mBlist` argument at all 26 calls (`:1332` to `:1357`, `:3127`). Keep `mod_a`, as the user's choice. No PARAMS row: the file is adopted, and the GenericParser2 drops have no PARAMS row.

## G2. G_G2_LISTBONES and G_G2_LISTSURFACES: NOT SETTLED

Raven `sv_game.cpp:1316` to `:1322`: `G2API_ListBones( (CGhoul2Info *) VMA(1), args[2]);` and `G2API_ListSurfaces( (CGhoul2Info *) args[1] );`. The word is a `CGhoul2Info_v *`, which is 4 bytes, `int mItem` (`ghoul2_shared.h:328`). Raven reads it as a `CGhoul2Info`, which is undefined (it reads past the object). The two arms also translate the word in different ways (VMA and args). Swift: `sv_game.swift:1636` to `:1646`, `portMissing`.
- OpenJK has the same cast: `openjk/codemp/server/sv_gameapi.cpp:1462`, `:1466`, `:2592` to `:2598`.
- jka-rust keeps the raw reinterpret as "§19; dead in normal play": `jka-rust/crates/mp/engine/server/src/sv_game.rs:3023` to `:3037`. Rule 11 does not allow this form in Swift.
- No file of the game, cgame, or ui calls `trap_G2_ListModelBones` or `trap_G2_ListModelSurfaces`. The other G2 arms take a model index from an argument (`sv_game.swift:1623`, `:1679`). These two arms have no model index.
- The host still ports the arm of a trap that no game file calls (`sv_game.swift:1135` BOTLIB_AAS_TRACE_AREAS, `:1390` BOTLIB_AI_UNIFY_WHITE_SPACES). So there is no precedent for a "dead arm" form.
- Rule 19 tells you to pick one defined behavior. No source tells which one.

Candidates (docket-12.md:364):
- A: `ghoul2Instances.instance(word:)![0]` with a Port-note. The cost is a behavior that you choose, and an empty vector traps.
- B: pass `nil`, so G2_SetupModelPointers fails and nothing prints (G2_API.swift:1273, :1280). The cost is a no-op that you choose.
- C: a new dead-arm form. The cost is a new convention.

Recommendation: A.

## G3. G2_GorePolys: SETTLED, DEAD

In Raven, a NULL map reaches the gore arm (`G2_misc.cpp:1490` to `:1495`) and then crashes at `G2_API.cpp:2166`. In Swift, `G2API_CollisionDetect` takes a non-optional `Slots<CollisionRecord>`, and `VMA` force-unwraps the word (`Sources/JKAMP_Ded/GameViews.swift:123` to `:125`). So a NULL map stops at the arm (`sv_game.swift:1775`), which is the rule 19 null form. The only Swift caller that passes nil is G2API_AddSkinGore (`G2_API.swift:1855`), and no server file calls it.
- jka-rust treats the gore arm as permanently unreachable and removes it: `misc.rs:75` to `:98`, `:607` to `:612`.
- OpenJK defines `_G2_GORE` (`q_shared.h:1823`) and keeps the body in rd-dedicated (`G2_misc.cpp:787`, `:1470`). Its trap also gets a real map.

Change: add `"G2_GorePolys": "G2_TraceSurfaces calls it only for a nil collision map, which only G2API_AddSkinGore passes, and no server file calls G2API_AddSkinGore"` to DEAD in `tools/oracle-closure/rulings.py`. The stub note at `G2_misc.swift:689` is already correct.

## G4. G2_Get_Bone_Name: SETTLED, DEAD

The port follows Raven's release build: `docs/transcription.md:348` (assert is `((void)0)` under NDEBUG), and `:654` and `:655` (`#ifdef` uses the native release branch). `_DEBUG_BONE_NAMES` is defined only `#ifdef _DEBUG` (`G2_bones.cpp:2576` to `:2578`). The callers are at `:2624` and `:3848`. The third caller, G2_BoneSnap (`:3964`), is in the `#ifndef DEDICATED` arm. The precedent is DEAD `WriteIndent` (`rulings.py`, "under DEBUG_AI_WEAP, which the build does not define").

Change: add `"G2_Get_Bone_Name": "Its callers stand under _DEBUG_BONE_NAMES, which only _DEBUG defines, and in the #ifndef DEDICATED arm of G2_BoneSnap"` to DEAD. Change the note at `G2_bones.swift:1789` to give the same reason.
