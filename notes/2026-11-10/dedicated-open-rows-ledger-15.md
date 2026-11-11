# The open rows of the dedicated host, the fifteenth ledger

This record holds the close of the branch `dedicated-integration-16` in the worktree `/tmp/jka-int-16`: the hand fixes of the four reviews of the last body wave (`/tmp/review-w6-a.md` to `-d.md`), and the generator batch 14 with rows R1 to R5. The base is `9af201d1`, which holds the bodies of sets R1a, R1b, R1c, R2, R3, R4, and row R10 of ledger 13. Every Raven cite is under `oracle/codemp/`, and every Swift cite is under `Sources/`.

The authority "auto ruled by pattern" means that the proof at Raven's line and at the line of the precedent was checked before the change, under the delegation of 2026-11-03.

## The hand fixes of the reviews

| Row | Verdict | Authority | Deciding source | Status |
| --- | --- | --- | --- | --- |
| P1, PC_SetIncludePath | `source_t` puts `char filename[1024]` directly before `char includepath[1024]` (`botlib/l_precomp.h:82` to `:83`). Both creators clear the record and copy at most MAX_PATH bytes into `filename` (`l_precomp.cpp:3058` to `:3061`, `:3091` to `:3094`), so `filename[1023]` is always 0, and Raven appends PATHSEPERATOR_STR for an empty path. The body tests for the empty path first and appends, under one AI line that replaces the rule 19 note | the brief's ruling, after the proof of the layout | review b, note 1 | landed, `0e4cc2f7` |
| P2, rule 19 notes of reviews a and d | Review a: the float to `int` conversions of `CRMBSPInstance.swift` (irand of `mAngleVariance`, the terxel alignment, the two `(int)` radii of the entity text) and `CRMInstance.swift` (the terxel alignment) get the note of `matcomp.swift:159`. The `count` loop of the Group constructor gets a note for a decrement through INT_MIN. Review d names no trap without a note: its four rule 19 notes are present | auto ruled by pattern | `matcomp.swift:159`; review a, notes N3 and N4 | landed, `0e4cc2f7` |
| P3, bone padding note | Bytes 656 and 657 are the two bools, 658 to 659 pad to `parentBoneIndex` at 660, 684 is `hasOverGoal`, and 685 to 687 pad to `animFrameMatrix` at 688 (`ghoul2/ghoul2_shared.h:127` to `:140`). The note names the full runs | auto ruled by proof | review b, note 2 | landed, `0e4cc2f7` |
| P4, the CPU speed clock | The first clock read of each function carries a second AI line: `coarse` is 0 and Sys_GetCPUSpeedOld returns 0, and each `freq` is 0 and Sys_GetCPUSpeed returns 0. No logic changed | auto ruled by proof | review c, point 5; `timing_c.swift:20` | landed, `0e4cc2f7` |
| P5, the two SaveCommand unwraps | No hand form passes an empty buffer to a `bytes` parameter: `CharBuf.withSlots` force-unwraps the base address of its Array, and no site passes `CharBuf(0)` to a `Slots<byte>`. The PARAMS kind `bytes` has no nullable form, and only RETURNS has `optional_bytes`. The two sites in `CSequence.swift` and `CTaskManager.swift` keep the unwrap under a two-line Port-note. Raven's AppendToSaveGame (`icarus/Q3_Interface.cpp:695`) returns 1 and reads nothing | none | `spelling.py:327` to `:339`; `table.py:2189` to `:2197` | open, a note at each site |

## The rows of batch 14

| Row | Verdict | Authority | Deciding source | Status |
| --- | --- | --- | --- | --- |
| R1, BYTE_STORAGE_LOCALS `("v", "CM_DrawDebugSurface")` | Three vectors. The one `v` that builds is `vec3_t v[3]` of `qcommon/cm_patch.cpp:1772`, which goes to `drawPoly` at `:1777` and `:1782`. The `v[4]` of `:1786` stands under the `#if 0` of `:1785` to `:1805`. The generator writes the same lines that set R2 wrote by hand: after both runs, `JKAMP_Ded/Generated/Storage/EngineStorage.swift` does not change. This closes the open item "G6 `v`" of ledger 14 | auto ruled by pattern | the `hullPoints` row, `rulings.py:624` | landed, `a5ec1747` |
| R2, CXX_CLASSES `CRMInstance`, `CRMInstanceFile` | The class of `RMG/RM_Instance.h:25` and the class of `RM_InstanceFile.h:11` are the final classes of `CRMInstance.swift` and `CRMInstanceFile.swift`. The four subclasses are the payload structs of `CRMInstance.Kind`, so they take no row. All six Raven files of the hierarchy and `RM_Mission.cpp` stand in `deferred` of `[targets.mp-engine-ded]` (`project.toml:86` to `:102`), the treatment of `RM_Area.cpp` and `RM_Path.cpp`. So the skeleton writes no stub over the six new files or `CRMMission.swift`, draftcheck drafts none of them, and the row moves no printed byte | auto ruled by pattern | `CRMArea`, `CRMPathManager`, `rulings.py:1728` to `:1729` | landed, `a5ec1747` |
| R3, PARAMS `bytes` | `("G2_LoadGhoul2Model", "buffer")`, `("G2_FreeSaveBuffer", "buffer")`, `("G2API_LoadGhoul2Models", "buffer")`, and `("G2API_FreeSaveBuffer", "buffer")`: each `char *buffer` (`ghoul2/G2_misc.cpp:1812`, `:1841`, `G2_API.cpp:2477`, `:2482`) is the save block, read at offsets or handed to Z_Free. The skeleton now prints the hand signature `Slots<JKAShared.byte>` | auto ruled by pattern | `("ServerLoadMDXA", "buffer")`, `rulings.py:1448` | landed, `a5ec1747` |
| R3, hand-ruled signatures | See the next table | none | ledger 14 rows | hand-ruled |
| R3, thunk order | `LeafListThunks` of `cm_test.swift` lists CM_StoreBrushes before CM_StoreLeafs, the order and spacing of the skeleton | hand edit | the skeleton output of `cm_test` | landed, `78c95595` |
| R4, DEAD `CG_ParticleExplosion` | The row goes out, because the body landed (`d28968a3`, row R10 of ledger 13). The table is empty, and the comment says so | auto ruled by the rule of the table | `rulings.py:1590` to `:1596` | landed, `a5ec1747` |
| R5, stale markers | No `// TODO: Port` marker under `Sources` names a function with a body. The 35 lines are 2 lines of `PortMissing.swift` (its doc line and its trap text), 24 re-export and view markers under `JKAMP_Ded/Generated`, and 9 globals (`cls`, `fp`, `debuglogfile`, and the six GL pointers of `null_glimp.swift`). No "keeps its marker" note remains | auto ruled by proof | grep | closed, no change |

The hand-ruled signatures. No existing kind gives these, and the batch adds no kind.

| Function | Hand signature | Generated signature | Ledger 14 row |
| --- | --- | --- | --- |
| G2_SaveGhoul2Models, G2API_SaveGhoul2Models | `_ buffer: inout Slots<JKAShared.byte>?` | `inout JKAShared.TextCursor`. The `void **` branch of the kind `bytes` (`spelling.py:329`) takes a `void` or `unsigned char` pointee, and `char **` has a `char` pointee | N-G2SAVE |
| G2_GetGoreRecord | `-> GoreTextureCoordinates?` | a signature marker. The kind `class_ref` (`table.py:2201`) reads a class pointee, and `void *` has none | N-GORE |
| CM_TerrainPatchIterate, CCMLandScape.TerrainPatchIterate | `((CCMPatch?) -> Void)?` with no `userdata` | `((CCMPatch?, OpaquePointer?) -> Void)?, _ userdata: OpaquePointer?`. The method has no stub | N-USERDATA |
| CM_DrawDebugSurface, BotDrawDebugPolygons | `drawPoly: ((Int32, Int32, Slots<JKAShared.vec3_t>) -> Void)?` | `((Int32, Int32, inout Float) -> Void)?`. The callback of CM_CircularIterate is hand-ruled the same way | N-CLOSURE |

The other hand signatures of sets R2, R3, and R4 are equal to the skeleton output: CM_StoreBrushes, CM_BoxBrushes, PC_AddBuiltinDefines, PC_SetIncludePath, the five AAS string index functions, Sys_FunctionCmp, Sys_FunctionCheckSum, Sys_GetCPUSpeedOld, and Sys_GetCPUSpeed. The ROFF arms are methods with no stub. The new SysBackend members of set R4 are hand code of the view target, outside the generator.

## The docs

No sentence of `docs/` or `README.md` states a count of stubs or names the DEAD row, so no doc changed.

## The timing

Each line is one step, in seconds. All steps exit 0. No other Swift process ran.

| Step | Run 1 | Run 2 |
| --- | --- | --- |
| extract, 9 units | 71 | 69 |
| merge | 1 | 1 |
| tables | 0 | 0 |
| check | 5 | 4 |
| reexport | 152 | 160 |
| views-game | 68 | 2 |
| views-cgame | 46 | 2 |
| views-ded | 53 | 2 |
| skeleton-game | 26 | 25 |
| skeleton-cgame | 15 | 16 |
| skeleton-ded | 25 | 30 |
| manifest-game | 24 | 27 |
| manifest-cgame | 16 | 15 |
| manifest-ded | 25 | 24 |
| traps-game | 3 | 4 |
| traps-cgame | 2 | 2 |
| channel | 3 | 2 |
| sum of steps | 535 | 385 |

| Gate step | Seconds | Exit |
| --- | --- | --- |
| debug build after run 1 | 34 | 0 |
| debug build of the gate | 18 | 0 |
| swift test | 33 | 0 |
| tool tests | 3 | 0 |
| release build | 112 | 0 |
| snapshot check mp-game | 122 | 0 |
| snapshot check mp-cgame | 51 | 1 |
| snapshot check mp-engine-ded | 70 | 1 |
| Linux build | 57 | 0 |
| referee | 83 | 0 |

## The gate

- The sequence, run 1: every step exits 0, and the debug build after it exits 0, so no fix round was necessary. Run 1 changed three tracked files: the cgame manifest of `cg_marks`, the manifest of `q_math`, and the re-export of `bg_weapons`, which now imports Foundation, because the macro LAST_USEABLE_WEAPON is the one name WP_BRYAR_OLD and the rule of `reexport.py:306` adds the import for such a name. No row of this batch changes that rule. The file at master did not have the line. The manifest of `q_math` takes the line numbers of the current `q_math.swift`. The two manifests are the catch-up of bodies on master and of the CG_ParticleExplosion body.
- The sequence, run 2, after those changes: `git status` shows the same changes and no other, and `bg_weapons.swift` is byte-equal to run 1. The generated files are equal to generator output. The untracked `.claude/manifest/mp-engine-ded/` stays out of the commits, as before.
- `swift build -j 6`: exit 0. `swift build -c release -j 6`: exit 0.
- `swift test --no-parallel -j 6`: 162 of 162 pass.
- The tool tests: 102 run, OK, 15 skipped. No row adds tool logic, so no test was added.
- `snapshot.py --check`, mp-game: no difference.
- mp-cgame: three files differ, all from row R4 and the body of row R10 of ledger 13. `skeleton/cg_marks.swift` loses the line "Raven calls this function from no file of either tree, so it is dead." of the CG_ParticleExplosion stub. `bodies/cg_marks.swift` prints the full draft of CG_ParticleExplosion in place of the stub. `manifest/cg_marks.md` marks the function ported ("1 with a marker" becomes "0 with a marker") and shifts the Swift line numbers of the rows after it.
- mp-engine-ded: 16 files differ, and each line belongs to a row of this batch or to a body of sets R1a to R4. Skeleton: the four signatures of row R3 in `G2_API.swift` and `G2_misc.swift`, and the forward `v_CM_DrawDebugSurface` with its AI line in `cm_patch.swift`, row R1. Bodies: the drafts of the four row R3 functions take the Slots signature, so the drafts of G2API_FreeSaveBuffer and G2_FreeSaveBuffer lose their hole (`Z_Free(buffer)`), and the hole counts go from 135 to 134 and from 119 to 118. The draft of CM_DrawDebugSurface uses the storage `v_CM_DrawDebugSurface` in place of a local Array, row R1. Manifests of ten stems: 18 rows go from `marker` to `ported`, the bodies of sets R2, R3, and R4 (the five AAS string index functions, BotDrawDebugPolygons, CM_BoxBrushes, CM_DrawDebugSurface, CM_TerrainPatchIterate, G2_GetGoreRecord, G2_LoadGhoul2Model, G2_SaveGhoul2Models, PC_AddBuiltinDefines, PC_SetIncludePath, Sys_FunctionCheckSum, Sys_FunctionCmp, Sys_GetCPUSpeedOld, Sys_GetCPUSpeed), the four signature columns of row R3, the new variable row `v` of row R1, the counts of each header line, and line shifts. With the line numbers removed, the other rows are the same. The sets R1a, R1b, and R1c make no snapshot line, because their Raven files are deferred. No difference is without a cause.
- Fresh snapshots: `/tmp/int16-snap-cgame` and `/tmp/int16-snap-ded`. The mp-game cache stays valid.
- Linux build in `swift:6.4-noble`: exit 0, 234 of 234 steps. The thread priority members of set R4 build with no platform split.

## The result

`grep -rn "portMissing(" Sources` gives only the definition, `JKAShared/PortMissing.swift:3`. `grep -rn "TODO: Port" Sources` counts 35.

The referee replay of `corpus-ffa1.rec`, 2400 frames, through `SCRATCH=/tmp/referee-scratch-i16 FRAMES=2400 tools/host-referee.sh <rec> /tmp/jka-rulings-13/.build/openjk-nocontract/openjkded.arm64 .build/release/jampded`: green. The `REF READY` lines are equal, each host prints 2400 `REF STEP` lines, the diff is empty, and each host prints `REF REPLAY END` once. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=2400 t=60400 ck=c7559f41`, the values before this branch. Module shasum `a3a4b0947149f18c2a9662047f604d42ae0f4f66`.

## The open items

- P5: the two SaveCommand unwraps wait for a nullable form of the PARAMS kind `bytes` or a hand form of an empty Slots.
- The hand-ruled signatures of the table above stay hand-ruled until a kind gives them.
