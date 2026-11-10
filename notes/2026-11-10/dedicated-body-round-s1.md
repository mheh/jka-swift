# The body round of set S1

This record holds the body round of set S1 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-s1` in the worktree `/tmp/jka-s1`. The branch starts from `dedicated-rulings-batch-12`. The five files were adopted already, so no generator header was removed.

## The counts

| File | Stubs | Filled | Left |
| --- | --- | --- | --- |
| be_aas_bspq3 | 4 | 4 | 0 |
| be_aas_cluster | 4 | 4 | 0 |
| be_aas_entity | 5 | 5 | 0 |
| be_aas_move | 3 | 3 | 0 |
| be_aas_reach | 3 | 3 | 0 |
| Total | 19 | 19 | 0 |

## The functions

- be_aas_bspq3: AAS_inPVS (`be_aas_bspq3.cpp:174`), AAS_inPHS (`:185`), AAS_BoxEntities (`:225`), AAS_BSPTraceLight (`:433`). Landed. AAS_inPVS gives `var` copies of the two points to `runInPVS`, because `BotImport_inPVS` at `sv_bot.cpp:370` only reads them.
- be_aas_cluster: AAS_ClearCluster (`be_aas_cluster.cpp:61`), AAS_RemovePortalsClusterReference (`:79`), AAS_NumberClusterPortals (`:271`), AAS_RemoveAllPortals (`:920`). Landed. AAS_NumberClusterPortals follows the form of AAS_NumberClusterAreas.
- be_aas_entity: AAS_EntityOrigin (`be_aas_entity.cpp:178`), AAS_EntitySize (`:269`), AAS_EntityBSPData (`:291`), AAS_NearestEntity (`:362`), AAS_BestReachableEntityArea (`:397`). Landed.
- be_aas_move: AAS_SetMovedir (`be_aas_move.cpp:218`), AAS_AirControl (`:373`), AAS_TestMovementPrediction (`:1016`). Landed. AAS_SetMovedir gives two scratch vectors to AngleVectors for Raven's NULL outputs, the form of AAS_WeaponJumpZVelocity in the same file.
- be_aas_reach: AAS_AreaLiquid (`be_aas_reach.cpp:664`), AAS_BarrierJumpTravelTime (`:758`), AAS_NearbySolidOrGap (`:787`). Landed. AAS_BarrierJumpTravelTime computes in `double` as Raven does and truncates through `UInt16`, the form of the end of AAS_AreaTravelTime in `be_aas_route.swift`.

## The notes corrected

The notes of three functions said that no file of either tree calls them. Raven calls each one only from a comment, so the notes now name the comment:

- AAS_NumberClusterPortals, at `be_aas_cluster.cpp:409`;
- AAS_SetMovedir, at `be_aas_reach.cpp:3516`;
- AAS_BarrierJumpTravelTime, at `be_aas_reach.cpp:1471`.

## The checks

- `swift build -j 2`: green. The new bodies add two warnings of a kind the files already have: the unused result of AAS_PredictClientMovement, and the `dir` of AAS_AirControl that Raven also never reads.
- `swift test --no-parallel -j 2`: 161 tests pass, 0 fail.
