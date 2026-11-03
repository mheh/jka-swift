import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_main.c:8
var cgDC: DisplayContextDef { world.storage.cgDC }

/// Source: oracle/codemp/cgame/cg_main.c:27
/// Raven's data table, a hand property of `CGameWorld`.
var colorTable: [vec4_t] { world.colorTable }

/// Source: oracle/codemp/cgame/holocronicons.h:4
/// Raven's data table, a hand property of `CGameWorld`.
var HolocronIcons: [String] { world.HolocronIcons }

/// Source: oracle/codemp/cgame/cg_main.c:113
// Raven wrote: int cgWeatherOverride = 0
let cgWeatherOverride: Int32 = 0

/// Source: oracle/codemp/cgame/cg_main.c:115
var forceModelModificationCount: Int32 {
    get { world.variables.forceModelModificationCount }
    set { world.variables.forceModelModificationCount = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:140
let MAX_MISC_ENTS = 4000 as Int32

/// Source: oracle/codemp/cgame/cg_main.c:145
var MiscEnts: Slots<JKAMP.RefEntity> { world.storage.MiscEnts }

/// Source: oracle/codemp/cgame/cg_main.c:146
var Radius: [Float] {
    get { world.variables.Radius }
    set { world.variables.Radius = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:147
var zOffset: [Float] {
    get { world.variables.zOffset }
    set { world.variables.zOffset = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:149
var NumMiscEnts: Int32 {
    get { world.variables.NumMiscEnts }
    set { world.variables.NumMiscEnts = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:691
var cg: Cg { world.storage.cg }

/// Source: oracle/codemp/cgame/cg_main.c:692
var cgs: Cgs { world.storage.cgs }

/// Source: oracle/codemp/cgame/cg_main.c:693
var cg_entities: Slots<Centity> { world.storage.cg_entities }

/// Source: oracle/codemp/cgame/cg_main.c:695
var cg_permanents: Slots<Centity?> { world.storage.cg_permanents }

/// Source: oracle/codemp/cgame/cg_main.c:696
var cg_numpermanents: Int32 {
    get { world.variables.cg_numpermanents }
    set { world.variables.cg_numpermanents = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:698
var cg_weapons: Slots<WeaponInfo> { world.storage.cg_weapons }

/// Source: oracle/codemp/cgame/cg_main.c:699
var cg_items: Slots<ItemInfo> { world.storage.cg_items }

/// Source: oracle/codemp/cgame/cg_main.c:702
var cg_centertime: JKAMP.VmCvar { world.storage.cg_centertime }

/// Source: oracle/codemp/cgame/cg_main.c:703
var cg_runpitch: JKAMP.VmCvar { world.storage.cg_runpitch }

/// Source: oracle/codemp/cgame/cg_main.c:704
var cg_runroll: JKAMP.VmCvar { world.storage.cg_runroll }

/// Source: oracle/codemp/cgame/cg_main.c:705
var cg_bobup: JKAMP.VmCvar { world.storage.cg_bobup }

/// Source: oracle/codemp/cgame/cg_main.c:706
var cg_bobpitch: JKAMP.VmCvar { world.storage.cg_bobpitch }

/// Source: oracle/codemp/cgame/cg_main.c:707
var cg_bobroll: JKAMP.VmCvar { world.storage.cg_bobroll }

/// Source: oracle/codemp/cgame/cg_main.c:709
var cg_shadows: JKAMP.VmCvar { world.storage.cg_shadows }

/// Source: oracle/codemp/cgame/cg_main.c:710
var cg_renderToTextureFX: JKAMP.VmCvar { world.storage.cg_renderToTextureFX }

/// Source: oracle/codemp/cgame/cg_main.c:711
var cg_drawTimer: JKAMP.VmCvar { world.storage.cg_drawTimer }

/// Source: oracle/codemp/cgame/cg_main.c:712
var cg_drawFPS: JKAMP.VmCvar { world.storage.cg_drawFPS }

/// Source: oracle/codemp/cgame/cg_main.c:713
var cg_drawSnapshot: JKAMP.VmCvar { world.storage.cg_drawSnapshot }

/// Source: oracle/codemp/cgame/cg_main.c:714
var cg_draw3dIcons: JKAMP.VmCvar { world.storage.cg_draw3dIcons }

/// Source: oracle/codemp/cgame/cg_main.c:715
var cg_drawIcons: JKAMP.VmCvar { world.storage.cg_drawIcons }

/// Source: oracle/codemp/cgame/cg_main.c:716
var cg_drawAmmoWarning: JKAMP.VmCvar { world.storage.cg_drawAmmoWarning }

/// Source: oracle/codemp/cgame/cg_main.c:717
var cg_drawCrosshair: JKAMP.VmCvar { world.storage.cg_drawCrosshair }

/// Source: oracle/codemp/cgame/cg_main.c:718
var cg_drawCrosshairNames: JKAMP.VmCvar { world.storage.cg_drawCrosshairNames }

/// Source: oracle/codemp/cgame/cg_main.c:719
var cg_drawRadar: JKAMP.VmCvar { world.storage.cg_drawRadar }

/// Source: oracle/codemp/cgame/cg_main.c:720
var cg_drawVehLeadIndicator: JKAMP.VmCvar { world.storage.cg_drawVehLeadIndicator }

/// Source: oracle/codemp/cgame/cg_main.c:721
var cg_dynamicCrosshair: JKAMP.VmCvar { world.storage.cg_dynamicCrosshair }

/// Source: oracle/codemp/cgame/cg_main.c:722
var cg_dynamicCrosshairPrecision: JKAMP.VmCvar { world.storage.cg_dynamicCrosshairPrecision }

/// Source: oracle/codemp/cgame/cg_main.c:723
var cg_drawRewards: JKAMP.VmCvar { world.storage.cg_drawRewards }

/// Source: oracle/codemp/cgame/cg_main.c:724
var cg_drawScores: JKAMP.VmCvar { world.storage.cg_drawScores }

/// Source: oracle/codemp/cgame/cg_main.c:725
var cg_crosshairSize: JKAMP.VmCvar { world.storage.cg_crosshairSize }

/// Source: oracle/codemp/cgame/cg_main.c:726
var cg_crosshairX: JKAMP.VmCvar { world.storage.cg_crosshairX }

/// Source: oracle/codemp/cgame/cg_main.c:727
var cg_crosshairY: JKAMP.VmCvar { world.storage.cg_crosshairY }

/// Source: oracle/codemp/cgame/cg_main.c:728
var cg_crosshairHealth: JKAMP.VmCvar { world.storage.cg_crosshairHealth }

/// Source: oracle/codemp/cgame/cg_main.c:729
var cg_draw2D: JKAMP.VmCvar { world.storage.cg_draw2D }

/// Source: oracle/codemp/cgame/cg_main.c:730
var cg_drawStatus: JKAMP.VmCvar { world.storage.cg_drawStatus }

/// Source: oracle/codemp/cgame/cg_main.c:731
var cg_animSpeed: JKAMP.VmCvar { world.storage.cg_animSpeed }

/// Source: oracle/codemp/cgame/cg_main.c:732
var cg_debugAnim: JKAMP.VmCvar { world.storage.cg_debugAnim }

/// Source: oracle/codemp/cgame/cg_main.c:733
var cg_debugSaber: JKAMP.VmCvar { world.storage.cg_debugSaber }

/// Source: oracle/codemp/cgame/cg_main.c:734
var cg_debugPosition: JKAMP.VmCvar { world.storage.cg_debugPosition }

/// Source: oracle/codemp/cgame/cg_main.c:735
var cg_debugEvents: JKAMP.VmCvar { world.storage.cg_debugEvents }

/// Source: oracle/codemp/cgame/cg_main.c:736
var cg_errorDecay: JKAMP.VmCvar { world.storage.cg_errorDecay }

/// Source: oracle/codemp/cgame/cg_main.c:737
var cg_nopredict: JKAMP.VmCvar { world.storage.cg_nopredict }

/// Source: oracle/codemp/cgame/cg_main.c:738
var cg_noPlayerAnims: JKAMP.VmCvar { world.storage.cg_noPlayerAnims }

/// Source: oracle/codemp/cgame/cg_main.c:739
var cg_showmiss: JKAMP.VmCvar { world.storage.cg_showmiss }

/// Source: oracle/codemp/cgame/cg_main.c:740
var cg_showVehMiss: JKAMP.VmCvar { world.storage.cg_showVehMiss }

/// Source: oracle/codemp/cgame/cg_main.c:741
var cg_footsteps: JKAMP.VmCvar { world.storage.cg_footsteps }

/// Source: oracle/codemp/cgame/cg_main.c:742
var cg_addMarks: JKAMP.VmCvar { world.storage.cg_addMarks }

/// Source: oracle/codemp/cgame/cg_main.c:743
var cg_viewsize: JKAMP.VmCvar { world.storage.cg_viewsize }

/// Source: oracle/codemp/cgame/cg_main.c:744
var cg_drawGun: JKAMP.VmCvar { world.storage.cg_drawGun }

/// Source: oracle/codemp/cgame/cg_main.c:745
var cg_gun_frame: JKAMP.VmCvar { world.storage.cg_gun_frame }

/// Source: oracle/codemp/cgame/cg_main.c:746
var cg_gun_x: JKAMP.VmCvar { world.storage.cg_gun_x }

/// Source: oracle/codemp/cgame/cg_main.c:747
var cg_gun_y: JKAMP.VmCvar { world.storage.cg_gun_y }

/// Source: oracle/codemp/cgame/cg_main.c:748
var cg_gun_z: JKAMP.VmCvar { world.storage.cg_gun_z }

/// Source: oracle/codemp/cgame/cg_main.c:749
var cg_autoswitch: JKAMP.VmCvar { world.storage.cg_autoswitch }

/// Source: oracle/codemp/cgame/cg_main.c:750
var cg_ignore: JKAMP.VmCvar { world.storage.cg_ignore }

/// Source: oracle/codemp/cgame/cg_main.c:751
var cg_simpleItems: JKAMP.VmCvar { world.storage.cg_simpleItems }

/// Source: oracle/codemp/cgame/cg_main.c:752
var cg_fov: JKAMP.VmCvar { world.storage.cg_fov }

/// Source: oracle/codemp/cgame/cg_main.c:753
var cg_zoomFov: JKAMP.VmCvar { world.storage.cg_zoomFov }

/// Source: oracle/codemp/cgame/cg_main.c:755
var cg_swingAngles: JKAMP.VmCvar { world.storage.cg_swingAngles }

/// Source: oracle/codemp/cgame/cg_main.c:757
var cg_oldPainSounds: JKAMP.VmCvar { world.storage.cg_oldPainSounds }

/// Source: oracle/codemp/cgame/cg_main.c:759
var cg_ragDoll: JKAMP.VmCvar { world.storage.cg_ragDoll }

/// Source: oracle/codemp/cgame/cg_main.c:761
var cg_jumpSounds: JKAMP.VmCvar { world.storage.cg_jumpSounds }

/// Source: oracle/codemp/cgame/cg_main.c:763
var cg_autoMap: JKAMP.VmCvar { world.storage.cg_autoMap }

/// Source: oracle/codemp/cgame/cg_main.c:764
var cg_autoMapX: JKAMP.VmCvar { world.storage.cg_autoMapX }

/// Source: oracle/codemp/cgame/cg_main.c:765
var cg_autoMapY: JKAMP.VmCvar { world.storage.cg_autoMapY }

/// Source: oracle/codemp/cgame/cg_main.c:766
var cg_autoMapW: JKAMP.VmCvar { world.storage.cg_autoMapW }

/// Source: oracle/codemp/cgame/cg_main.c:767
var cg_autoMapH: JKAMP.VmCvar { world.storage.cg_autoMapH }

/// Source: oracle/codemp/cgame/cg_main.c:770
var bg_fighterAltControl: JKAMP.VmCvar { world.storage.bg_fighterAltControl }

/// Source: oracle/codemp/cgame/cg_main.c:773
var cg_chatBox: JKAMP.VmCvar { world.storage.cg_chatBox }

/// Source: oracle/codemp/cgame/cg_main.c:774
var cg_chatBoxHeight: JKAMP.VmCvar { world.storage.cg_chatBoxHeight }

/// Source: oracle/codemp/cgame/cg_main.c:776
var cg_saberModelTraceEffect: JKAMP.VmCvar { world.storage.cg_saberModelTraceEffect }

/// Source: oracle/codemp/cgame/cg_main.c:778
var cg_saberClientVisualCompensation: JKAMP.VmCvar { world.storage.cg_saberClientVisualCompensation }

/// Source: oracle/codemp/cgame/cg_main.c:780
var cg_g2TraceLod: JKAMP.VmCvar { world.storage.cg_g2TraceLod }

/// Source: oracle/codemp/cgame/cg_main.c:782
var cg_fpls: JKAMP.VmCvar { world.storage.cg_fpls }

/// Source: oracle/codemp/cgame/cg_main.c:784
var cg_ghoul2Marks: JKAMP.VmCvar { world.storage.cg_ghoul2Marks }

/// Source: oracle/codemp/cgame/cg_main.c:786
var cg_optvehtrace: JKAMP.VmCvar { world.storage.cg_optvehtrace }

/// Source: oracle/codemp/cgame/cg_main.c:788
var cg_saberDynamicMarks: JKAMP.VmCvar { world.storage.cg_saberDynamicMarks }

/// Source: oracle/codemp/cgame/cg_main.c:789
var cg_saberDynamicMarkTime: JKAMP.VmCvar { world.storage.cg_saberDynamicMarkTime }

/// Source: oracle/codemp/cgame/cg_main.c:791
var cg_saberContact: JKAMP.VmCvar { world.storage.cg_saberContact }

/// Source: oracle/codemp/cgame/cg_main.c:792
var cg_saberTrail: JKAMP.VmCvar { world.storage.cg_saberTrail }

/// Source: oracle/codemp/cgame/cg_main.c:794
var cg_duelHeadAngles: JKAMP.VmCvar { world.storage.cg_duelHeadAngles }

/// Source: oracle/codemp/cgame/cg_main.c:796
var cg_speedTrail: JKAMP.VmCvar { world.storage.cg_speedTrail }

/// Source: oracle/codemp/cgame/cg_main.c:797
var cg_auraShell: JKAMP.VmCvar { world.storage.cg_auraShell }

/// Source: oracle/codemp/cgame/cg_main.c:799
var cg_repeaterOrb: JKAMP.VmCvar { world.storage.cg_repeaterOrb }

/// Source: oracle/codemp/cgame/cg_main.c:801
var cg_animBlend: JKAMP.VmCvar { world.storage.cg_animBlend }

/// Source: oracle/codemp/cgame/cg_main.c:803
var cg_dismember: JKAMP.VmCvar { world.storage.cg_dismember }

/// Source: oracle/codemp/cgame/cg_main.c:805
var cg_thirdPersonSpecialCam: JKAMP.VmCvar { world.storage.cg_thirdPersonSpecialCam }

/// Source: oracle/codemp/cgame/cg_main.c:807
var cg_thirdPerson: JKAMP.VmCvar { world.storage.cg_thirdPerson }

/// Source: oracle/codemp/cgame/cg_main.c:808
var cg_thirdPersonRange: JKAMP.VmCvar { world.storage.cg_thirdPersonRange }

/// Source: oracle/codemp/cgame/cg_main.c:809
var cg_thirdPersonAngle: JKAMP.VmCvar { world.storage.cg_thirdPersonAngle }

/// Source: oracle/codemp/cgame/cg_main.c:810
var cg_thirdPersonPitchOffset: JKAMP.VmCvar { world.storage.cg_thirdPersonPitchOffset }

/// Source: oracle/codemp/cgame/cg_main.c:811
var cg_thirdPersonVertOffset: JKAMP.VmCvar { world.storage.cg_thirdPersonVertOffset }

/// Source: oracle/codemp/cgame/cg_main.c:812
var cg_thirdPersonCameraDamp: JKAMP.VmCvar { world.storage.cg_thirdPersonCameraDamp }

/// Source: oracle/codemp/cgame/cg_main.c:813
var cg_thirdPersonTargetDamp: JKAMP.VmCvar { world.storage.cg_thirdPersonTargetDamp }

/// Source: oracle/codemp/cgame/cg_main.c:815
var cg_thirdPersonAlpha: JKAMP.VmCvar { world.storage.cg_thirdPersonAlpha }

/// Source: oracle/codemp/cgame/cg_main.c:816
var cg_thirdPersonHorzOffset: JKAMP.VmCvar { world.storage.cg_thirdPersonHorzOffset }

/// Source: oracle/codemp/cgame/cg_main.c:818
var cg_stereoSeparation: JKAMP.VmCvar { world.storage.cg_stereoSeparation }

/// Source: oracle/codemp/cgame/cg_main.c:819
var cg_lagometer: JKAMP.VmCvar { world.storage.cg_lagometer }

/// Source: oracle/codemp/cgame/cg_main.c:820
var cg_drawEnemyInfo: JKAMP.VmCvar { world.storage.cg_drawEnemyInfo }

/// Source: oracle/codemp/cgame/cg_main.c:821
var cg_synchronousClients: JKAMP.VmCvar { world.storage.cg_synchronousClients }

/// Source: oracle/codemp/cgame/cg_main.c:822
var cg_stats: JKAMP.VmCvar { world.storage.cg_stats }

/// Source: oracle/codemp/cgame/cg_main.c:823
var cg_buildScript: JKAMP.VmCvar { world.storage.cg_buildScript }

/// Source: oracle/codemp/cgame/cg_main.c:824
var cg_forceModel: JKAMP.VmCvar { world.storage.cg_forceModel }

/// Source: oracle/codemp/cgame/cg_main.c:825
var cg_paused: JKAMP.VmCvar { world.storage.cg_paused }

/// Source: oracle/codemp/cgame/cg_main.c:826
var cg_blood: JKAMP.VmCvar { world.storage.cg_blood }

/// Source: oracle/codemp/cgame/cg_main.c:827
var cg_predictItems: JKAMP.VmCvar { world.storage.cg_predictItems }

/// Source: oracle/codemp/cgame/cg_main.c:828
var cg_deferPlayers: JKAMP.VmCvar { world.storage.cg_deferPlayers }

/// Source: oracle/codemp/cgame/cg_main.c:829
var cg_drawTeamOverlay: JKAMP.VmCvar { world.storage.cg_drawTeamOverlay }

/// Source: oracle/codemp/cgame/cg_main.c:830
var cg_teamOverlayUserinfo: JKAMP.VmCvar { world.storage.cg_teamOverlayUserinfo }

/// Source: oracle/codemp/cgame/cg_main.c:831
var cg_drawFriend: JKAMP.VmCvar { world.storage.cg_drawFriend }

/// Source: oracle/codemp/cgame/cg_main.c:832
var cg_teamChatsOnly: JKAMP.VmCvar { world.storage.cg_teamChatsOnly }

/// Source: oracle/codemp/cgame/cg_main.c:833
var cg_hudFiles: JKAMP.VmCvar { world.storage.cg_hudFiles }

/// Source: oracle/codemp/cgame/cg_main.c:834
var cg_scorePlum: JKAMP.VmCvar { world.storage.cg_scorePlum }

/// Source: oracle/codemp/cgame/cg_main.c:835
var cg_smoothClients: JKAMP.VmCvar { world.storage.cg_smoothClients }

/// Source: oracle/codemp/cgame/cg_main.c:838
var pmove_fixed: JKAMP.VmCvar { world.storage.pmove_fixed }

/// Source: oracle/codemp/cgame/cg_main.c:840
var pmove_msec: JKAMP.VmCvar { world.storage.pmove_msec }

/// Source: oracle/codemp/cgame/cg_main.c:842
var g_showDuelHealths: JKAMP.VmCvar { world.storage.g_showDuelHealths }

/// Source: oracle/codemp/cgame/cg_main.c:845
var cg_pmove_msec: JKAMP.VmCvar { world.storage.cg_pmove_msec }

/// Source: oracle/codemp/cgame/cg_main.c:846
var cg_cameraMode: JKAMP.VmCvar { world.storage.cg_cameraMode }

/// Source: oracle/codemp/cgame/cg_main.c:847
var cg_cameraOrbit: JKAMP.VmCvar { world.storage.cg_cameraOrbit }

/// Source: oracle/codemp/cgame/cg_main.c:848
var cg_cameraOrbitDelay: JKAMP.VmCvar { world.storage.cg_cameraOrbitDelay }

/// Source: oracle/codemp/cgame/cg_main.c:849
var cg_timescaleFadeEnd: JKAMP.VmCvar { world.storage.cg_timescaleFadeEnd }

/// Source: oracle/codemp/cgame/cg_main.c:850
var cg_timescaleFadeSpeed: JKAMP.VmCvar { world.storage.cg_timescaleFadeSpeed }

/// Source: oracle/codemp/cgame/cg_main.c:851
var cg_timescale: JKAMP.VmCvar { world.storage.cg_timescale }

/// Source: oracle/codemp/cgame/cg_main.c:852
var cg_noTaunt: JKAMP.VmCvar { world.storage.cg_noTaunt }

/// Source: oracle/codemp/cgame/cg_main.c:853
var cg_noProjectileTrail: JKAMP.VmCvar { world.storage.cg_noProjectileTrail }

/// Source: oracle/codemp/cgame/cg_main.c:858
var cg_debugBB: JKAMP.VmCvar { world.storage.cg_debugBB }

/// Source: oracle/codemp/cgame/cg_main.c:864
var cg_currentSelectedPlayer: JKAMP.VmCvar { world.storage.cg_currentSelectedPlayer }

/// Source: oracle/codemp/cgame/cg_main.c:865
var cg_currentSelectedPlayerName: JKAMP.VmCvar { world.storage.cg_currentSelectedPlayerName }

/// Source: oracle/codemp/cgame/cg_main.c:867
var cg_recordSPDemo: JKAMP.VmCvar { world.storage.cg_recordSPDemo }

/// Source: oracle/codemp/cgame/cg_main.c:868
var cg_recordSPDemoName: JKAMP.VmCvar { world.storage.cg_recordSPDemoName }

/// Source: oracle/codemp/cgame/cg_main.c:869
var cg_showVehBounds: JKAMP.VmCvar { world.storage.cg_showVehBounds }

/// Source: oracle/codemp/cgame/cg_main.c:871
var ui_myteam: JKAMP.VmCvar { world.storage.ui_myteam }

/// Source: oracle/codemp/cgame/cg_main.c:873
var cg_snapshotTimeout: JKAMP.VmCvar { world.storage.cg_snapshotTimeout }

/// Source: oracle/codemp/cgame/cg_main.c:882
/// Raven's data table, a hand property of `CGameWorld`.
var cvarTable: [CvarTableRow] { world.cvarTable }

/// Source: oracle/codemp/cgame/cg_main.c:1055
/// Raven's count of `cvarTable`, which is the count of the hand array.
var cvarTableSize: Int32 { Int32(world.cvarTable.count) }

/// Source: oracle/codemp/cgame/cg_main.c:3309
let MAX_CGSTRPOOL_SIZE = 32768 as Int32

/// Source: oracle/codemp/cgame/cg_main.c:3310
var cg_strPoolSize: Int32 {
    get { world.variables.cg_strPoolSize }
    set { world.variables.cg_strPoolSize = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3311
// Raven wrote: static byte cg_strPool[MAX_CGSTRPOOL_SIZE]
// AI: Raven allocates from this static pool. Each allocation is its own block, so the pool has no storage.

/// Source: oracle/codemp/cgame/cg_main.c:3393
// Raven wrote: BG_field_t cg_spawnFields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/cgame/cg_main.c:3411
var cg_numSpawnVars: Int32 {
    get { world.variables.cg_numSpawnVars }
    set { world.variables.cg_numSpawnVars = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3412
var cg_numSpawnVarChars: Int32 {
    get { world.variables.cg_numSpawnVarChars }
    set { world.variables.cg_numSpawnVarChars = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3413
var cg_spawnVars: [[String]] {
    get { world.variables.cg_spawnVars }
    set { world.variables.cg_spawnVars = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3414
var cg_spawnVarChars: JKAShared.CharBuf {
    get { world.variables.cg_spawnVarChars }
    set { world.variables.cg_spawnVarChars = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3417
var cg_noFogOutsidePortal: Bool {
    get { world.variables.cg_noFogOutsidePortal }
    set { world.variables.cg_noFogOutsidePortal = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3429
var cg_skyOri: Bool {
    get { world.variables.cg_skyOri }
    set { world.variables.cg_skyOri = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3430
var cg_skyOriPos: JKAShared.vec3_t {
    get { world.variables.cg_skyOriPos }
    set { world.variables.cg_skyOriPos = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3431
var cg_skyOriScale: Float {
    get { world.variables.cg_skyOriScale }
    set { world.variables.cg_skyOriScale = newValue }
}

//do we have any force powers that we would normally need to cycle to?
/// Source: oracle/codemp/cgame/cg_main.c:159
func CG_NoUseableForce() -> Bool {
    var i: Int32 = FP_HEAL
    while i < NUM_FORCE_POWERS {
        if i != FP_SABERTHROW && i != FP_SABER_OFFENSE && i != FP_SABER_DEFENSE && i != FP_LEVITATION {
            //valid selectable power
            if (cg.predictedPlayerState.fd.forcePowersKnown & (1 << i)) != 0 {
                //we have it
                return false
            }
        }
        i += 1
    }

    //no useable force powers, I guess.
    return true
}

/// Source: oracle/codemp/cgame/cg_main.c:190
// Raven wrote: int vmMain( int command, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10, int arg11 )
// Not ported: the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5.

/// Source: oracle/codemp/cgame/cg_main.c:362
private func C_PointContents() -> Int32 {
    let data = CGPointContents(handle: OpaquePointer(cg.sharedBuffer))

    return CG_PointContents(data.mPoint, data.mPassEntityNum)
}

/// Source: oracle/codemp/cgame/cg_main.c:369
private func C_GetLerpOrigin() {
    let data = CGVectorData(handle: OpaquePointer(cg.sharedBuffer))

    data.mPoint = cg_entities[data.mEntityNum].lerpOrigin
}

/// Source: oracle/codemp/cgame/cg_main.c:376
private func C_GetLerpData() {
    //only used by FX system to pass to getboltmat
    let data = CGGetBoltData(handle: OpaquePointer(cg.sharedBuffer))

    data.mOrigin = cg_entities[data.mEntityNum].lerpOrigin
    data.mScale = cg_entities[data.mEntityNum].modelScale
    data.mAngles = cg_entities[data.mEntityNum].lerpAngles
    if cg_entities[data.mEntityNum].currentState.eType == ET_PLAYER {
        //normal player
        data.mAngles[PITCH] = 0.0
        data.mAngles[ROLL] = 0.0
    } else if cg_entities[data.mEntityNum].currentState.eType == ET_NPC {
        //an NPC
        let pVeh: Vehicle? = cg_entities[data.mEntityNum].m_pVehicle
        if pVeh == nil {
            //for vehicles, we may or may not want to 0 out pitch and roll
            data.mAngles[PITCH] = 0.0
            data.mAngles[ROLL] = 0.0
        } else if pVeh!.m_pVehicleInfo!.type == VH_SPEEDER {
            //speeder wants no pitch but a roll
            data.mAngles[PITCH] = 0.0
        } else if pVeh!.m_pVehicleInfo!.type != VH_FIGHTER {
            //fighters want all angles
            data.mAngles[PITCH] = 0.0
            data.mAngles[ROLL] = 0.0
        }
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:408
private func C_Trace() {
    let td = CGTrace(handle: OpaquePointer(cg.sharedBuffer))

    CG_Trace(td.mResult, td.mStart, td.mMins, td.mMaxs, td.mEnd, td.mSkipNumber, td.mMask)
}

/// Source: oracle/codemp/cgame/cg_main.c:415
private func C_G2Trace() {
    let td = CGTrace(handle: OpaquePointer(cg.sharedBuffer))

    CG_G2Trace(td.mResult, td.mStart, td.mMins, td.mMaxs, td.mEnd, td.mSkipNumber, td.mMask)
}

/// Source: oracle/codemp/cgame/cg_main.c:422
private func C_G2Mark() {
    let td = CGG2Mark(handle: OpaquePointer(cg.sharedBuffer))
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var end = vec3_t()

        _VectorMA(td.start, 64, td.dir, &end)
        CG_G2Trace(tr, td.start, nil, nil, end, ENTITYNUM_NONE, MASK_PLAYERSOLID)

        if tr.entityNum < ENTITYNUM_WORLD && cg_entities[tr.entityNum].ghoul2 != nil {
            //hit someone with a ghoul2 instance, let's project the decal on them then.
            let cent: Centity? = cg_entities[tr.entityNum]

            //CG_TestLine(tr.endpos, end, 2000, 0x0000ff, 1);

            CG_AddGhoul2Mark(td.shader, td.size, tr.endpos, end, tr.entityNum, cent!.lerpOrigin, cent!.lerpAngles[YAW], cent!.ghoul2, &cent!.modelScale, Q_irand(2000, 4000))
            //I'm making fx system decals have a very short lifetime.
        }
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:445
private func CG_DebugBoxLines(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ duration: Int32) {
    var start = vec3_t()
    var end = vec3_t()
    var vert = vec3_t()

    let x: Float = maxs[0] - mins[0]
    let y: Float = maxs[1] - mins[1]

    start[2] = maxs[2]
    vert[2] = mins[2]

    vert[0] = mins[0]
    vert[1] = mins[1]
    start[0] = vert[0]
    start[1] = vert[1]
    CG_TestLine(start, vert, duration, 0x00000ff, 1)

    vert[0] = mins[0]
    vert[1] = maxs[1]
    start[0] = vert[0]
    start[1] = vert[1]
    CG_TestLine(start, vert, duration, 0x00000ff, 1)

    vert[0] = maxs[0]
    vert[1] = mins[1]
    start[0] = vert[0]
    start[1] = vert[1]
    CG_TestLine(start, vert, duration, 0x00000ff, 1)

    vert[0] = maxs[0]
    vert[1] = maxs[1]
    start[0] = vert[0]
    start[1] = vert[1]
    CG_TestLine(start, vert, duration, 0x00000ff, 1)

    // top of box
    start = maxs
    end = maxs
    start[0] -= x
    CG_TestLine(start, end, duration, 0x00000ff, 1)
    end[0] = start[0]
    end[1] -= y
    CG_TestLine(start, end, duration, 0x00000ff, 1)
    start[1] = end[1]
    start[0] += x
    CG_TestLine(start, end, duration, 0x00000ff, 1)
    CG_TestLine(start, maxs, duration, 0x00000ff, 1)
    // bottom of box
    start = mins
    end = mins
    start[0] += x
    CG_TestLine(start, end, duration, 0x00000ff, 1)
    end[0] = start[0]
    end[1] += y
    CG_TestLine(start, end, duration, 0x00000ff, 1)
    start[1] = end[1]
    start[0] -= x
    CG_TestLine(start, end, duration, 0x00000ff, 1)
    CG_TestLine(start, mins, duration, 0x00000ff, 1)
}

//handle ragdoll callbacks, for events and debugging -rww
/// Source: oracle/codemp/cgame/cg_main.c:508
private func CG_RagCallback(_ callType: Int32) -> Int32 {
    switch callType {
    case RAG_CALLBACK_DEBUGBOX:
        do {
            let callData = RagCallbackDebugBox(handle: OpaquePointer(cg.sharedBuffer))

            CG_DebugBoxLines(callData.mins, callData.maxs, callData.duration)
        }

    case RAG_CALLBACK_DEBUGLINE:
        do {
            let callData = RagCallbackDebugLine(handle: OpaquePointer(cg.sharedBuffer))

            CG_TestLine(callData.start, callData.end, callData.time, UInt32(bitPattern: callData.color), callData.radius)
        }

    case RAG_CALLBACK_BONESNAP:
        do {
            let callData = RagCallbackBoneSnap(handle: OpaquePointer(cg.sharedBuffer))
            let cent: Centity? = cg_entities[callData.entNum]
            let snapSound: Int32 = trap_S_RegisterSound(va("sound/player/bodyfall_human%i.wav", Q_irand(1, 3)))

            trap_S_StartSound(cent!.lerpOrigin, callData.entNum, CHAN_AUTO, snapSound)
        }
        fallthrough

    case RAG_CALLBACK_BONEIMPACT:
        break

    case RAG_CALLBACK_BONEINSOLID:
        break

    case RAG_CALLBACK_TRACELINE:
        do {
            let callData = RagCallbackTraceLine(handle: OpaquePointer(cg.sharedBuffer))

            CG_Trace(callData.tr, callData.start, callData.mins, callData.maxs, callData.end, callData.ignore, callData.mask)
        }

    default:
        Com_Error(ERR_DROP, "Invalid callType in CG_RagCallback")
    }

    return 0
}

/// Source: oracle/codemp/cgame/cg_main.c:570
private func C_ImpactMark() {
    let data = CGImpactMark(handle: OpaquePointer(cg.sharedBuffer))

    /*
    CG_ImpactMark((int)arg0, (const float *)arg1, (const float *)arg2, (float)arg3,
    (float)arg4, (float)arg5, (float)arg6, (float)arg7, qtrue, (float)arg8, qfalse);
    */
    CG_ImpactMark(data.mHandle, data.mPoint, data.mAngle, data.mRotation, data.mRed, data.mGreen, data.mBlue, data.mAlphaStart, true, data.mSizeStart, false)
}

/// Source: oracle/codemp/cgame/cg_main.c:582
func CG_MiscEnt() {
    let modelIndex: Int32
    var RefEnt: RefEntity?
    let data = CGMiscEnt(handle: OpaquePointer(cg.sharedBuffer))
    var mins = vec3_t()
    var maxs = vec3_t()
    var radiusIndex: Int32 = 0
    var zOffIndex: Int32 = 0

    if NumMiscEnts >= MAX_MISC_ENTS {
        return
    }

    radiusIndex = NumMiscEnts
    zOffIndex = NumMiscEnts
    RefEnt = MiscEnts[NumMiscEnts]
    NumMiscEnts += 1

    modelIndex = trap_R_RegisterModel(data.mModel)
    if modelIndex == 0 {
        Com_Error(ERR_DROP, "client_model has invalid model definition")
        return
    }

    zOffset[zOffIndex] = 0

    RefEnt!.clear()
    RefEnt!.reType = RT_MODEL
    RefEnt!.hModel = modelIndex
    RefEnt!.frame = 0
    trap_R_ModelBounds(modelIndex, &mins, &maxs)
    RefEnt!.modelScale = data.mScale
    RefEnt!.origin = data.mOrigin

    mins = mins * data.mScale
    maxs = maxs * data.mScale
    Radius[radiusIndex] = Distance(mins, maxs)

    AnglesToAxis(data.mAngles, RefEnt!.axis)
    ScaleModelAxis(RefEnt!)
}

/// Source: oracle/codemp/cgame/cg_main.c:624
func CG_DrawMiscEnts() {
    var i: Int32
    var RefEntIndex: Int32 = 0
    var radiusIndex: Int32 = 0
    var zOffIndex: Int32 = 0
    var difference = vec3_t()
    var cullOrigin = vec3_t()

    RefEntIndex = 0
    radiusIndex = 0
    zOffIndex = 0
    i = 0
    while i < NumMiscEnts {
        cullOrigin = MiscEnts[RefEntIndex].origin
        cullOrigin[2] += 1.0

        if zOffset[zOffIndex] != 0 {
            cullOrigin[2] += zOffset[zOffIndex]
        }

        if cg.snap != nil && trap_R_inPVS(cg.refdef.vieworg, cullOrigin, cg.snap!.areamask) {
            difference = MiscEnts[RefEntIndex].origin - cg.refdef.vieworg
            if VectorLength(difference) - (Radius[radiusIndex]) <= cg.distanceCull {
                trap_R_AddRefEntityToScene(MiscEnts[RefEntIndex])
            }
        }
        RefEntIndex += 1
        radiusIndex += 1
        zOffIndex += 1
        i += 1
    }
}

/**
```
=================
CG_RegisterCvars
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:1062
func CG_RegisterCvars() {
    var i: Int32
    var cvIndex: Int32 = 0
    var `var` = CharBuf(1024)

    i = 0
    cvIndex = 0
    while i < cvarTableSize {
        trap_Cvar_Register(cvarTable[cvIndex].vmCvar.map { world.storage[keyPath: $0] }, cvarTable[cvIndex].cvarName, cvarTable[cvIndex].defaultString, cvarTable[cvIndex].cvarFlags)
        i += 1
        cvIndex += 1
    }

    // see if we are also running the server on this machine
    strcpy(&`var`, trap_Cvar_VariableStringBuffer("sv_running", Int32((`var`).count)))
    cgs.localServer = atoi(`var`) != 0

    forceModelModificationCount = cg_forceModel.modificationCount

    trap_Cvar_Register(nil, "model", DEFAULT_MODEL, CVAR_USERINFO | CVAR_ARCHIVE)
    trap_Cvar_Register(nil, "forcepowers", DEFAULT_FORCEPOWERS, CVAR_USERINFO | CVAR_ARCHIVE)

    // Cvars uses for transferring data between client and server
    trap_Cvar_Register(nil, "ui_about_gametype", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_fraglimit", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_capturelimit", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_duellimit", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_timelimit", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_maxclients", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_dmflags", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_mapname", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_hostname", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_needpass", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_about_botminplayers", "0", CVAR_ROM | CVAR_INTERNAL)

    trap_Cvar_Register(nil, "ui_tm1_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm2_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm3_cnt", "0", CVAR_ROM | CVAR_INTERNAL)

    trap_Cvar_Register(nil, "ui_tm1_c0_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm1_c1_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm1_c2_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm1_c3_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm1_c4_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm1_c5_cnt", "0", CVAR_ROM | CVAR_INTERNAL)

    trap_Cvar_Register(nil, "ui_tm2_c0_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm2_c1_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm2_c2_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm2_c3_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm2_c4_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
    trap_Cvar_Register(nil, "ui_tm2_c5_cnt", "0", CVAR_ROM | CVAR_INTERNAL)
}

/**
```
===================
CG_ForceModelChange
===================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:1135
private func CG_ForceModelChange() {
    var i: Int32

    i = 0
    while i < MAX_CLIENTS {
        var clientInfo: String
        var oldGhoul2: OpaquePointer? = nil

        clientInfo = CG_ConfigString(CS_PLAYERS + i)
        if clientInfo.isEmpty {
            i += 1
            continue
        }

        oldGhoul2 = cgs.clientinfo[i].ghoul2Model
        CG_NewClientInfo(i, true)
        i += 1
    }
}

/// Raven's `static int drawTeamOverlayModificationCount` of `CG_UpdateCvars`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_main.c:1160
var drawTeamOverlayModificationCount: Int32 {
    get { world.drawTeamOverlayModificationCount }
    set { world.drawTeamOverlayModificationCount = newValue }
}

/**
```
=================
CG_UpdateCvars
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:1157
func CG_UpdateCvars() {
    var i: Int32
    var cvIndex: Int32 = 0

    i = 0
    cvIndex = 0
    while i < cvarTableSize {
        trap_Cvar_Update(world.storage[keyPath: cvarTable[cvIndex].vmCvar!])
        i += 1
        cvIndex += 1
    }

    // check for modications here

    // If team overlay is on, ask for updates from the server.  If its off,
    // let the server know so we don't receive it
    if drawTeamOverlayModificationCount != cg_drawTeamOverlay.modificationCount {
        drawTeamOverlayModificationCount = cg_drawTeamOverlay.modificationCount

        if cg_drawTeamOverlay.integer > 0 {
            trap_Cvar_Set("teamoverlay", "1")
        } else {
            trap_Cvar_Set("teamoverlay", "0")
        }
        // FIXME E3 HACK
        trap_Cvar_Set("teamoverlay", "1")
    }

    // if force model changed
    if forceModelModificationCount != cg_forceModel.modificationCount {
        forceModelModificationCount = cg_forceModel.modificationCount
        CG_ForceModelChange()
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:1189
func CG_CrosshairPlayer() -> Int32 {
    if cg.time > (cg.crosshairClientTime + 1000) {
        return -1
    }

    if cg.crosshairClientNum >= MAX_CLIENTS {
        return -1
    }

    return cg.crosshairClientNum
}

/// Source: oracle/codemp/cgame/cg_main.c:1202
func CG_LastAttacker() -> Int32 {
    if cg.attackerTime == 0 {
        return -1
    }
    return cg.snap!.ps.persistant[PERS_ATTACKER]
}

/// Source: oracle/codemp/cgame/cg_main.c:1209
func CG_Printf(_ msg: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(msg, args))

    trap_Print(String(text))
}

/// Source: oracle/codemp/cgame/cg_main.c:1220
func CG_Error(_ msg: String, _ args: any JKAShared.FormatArg...) -> Never {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(msg, args))

    trap_Error(String(text))
}

/// Source: oracle/codemp/cgame/cg_main.c:1234
func Com_Error(_ level: Int32, _ error: String, _ args: any JKAShared.FormatArg...) -> Never {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(error, args))

    CG_Error("%s", text)
}

/// Source: oracle/codemp/cgame/cg_main.c:1245
func Com_Printf(_ msg: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(msg, args))

    CG_Printf("%s", text)
}

/**
```
================
CG_Argv
================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:1263
func CG_Argv(_ arg: Int32) -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var buffer = CharBuf(1024)

    strcpy(&buffer, trap_Argv(arg, Int32((buffer).count)))

    return String(buffer)
}

/// Source: oracle/codemp/cgame/cg_main.c:1276
func BG_GetTime() -> Int32 {
    return cg.time
}

/**
```
=================
CG_RegisterItemSounds

The server says this item is used on this level
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:1289
private func CG_RegisterItemSounds(_ itemNum: Int32) {
    var item: Gitem?
    var data = CharBuf(64)
    var s: TextCursor
    var start: Int32
    var len: Int32

    item = bg_itemlist[itemNum]

    if item!.pickup_sound != nil {
        trap_S_RegisterSound(item!.pickup_sound!)
    }

    // parse the space seperated precache string for other media
    s = item!.sounds.map { TextCursor(CharBuf($0)) } ?? TextCursor()
    if s.isNull || s[0] == 0 {
        return
    }

    while s.byte != 0 {
        start = s.offset!
        while s.byte != 0 && s.byte != Int32(ascii: " ") {
            s.advance()
        }

        len = s.offset! - start
        if len >= MAX_QPATH || len < 5 {
            CG_Error("PrecacheItem: %s has bad precache string", item!.classname ?? "(null)")
            return
        }
        strncpy(&data, s.buf[start...], len)
        data[len] = 0
        if s.byte != 0 {
            s.advance()
        }

        trap_S_RegisterSound(String(data))
    }

    // parse the space seperated precache string for other media
    s = item!.precaches.map { TextCursor(CharBuf($0)) } ?? TextCursor()
    if s.isNull || s[0] == 0 {
        return
    }

    while s.byte != 0 {
        start = s.offset!
        while s.byte != 0 && s.byte != Int32(ascii: " ") {
            s.advance()
        }

        len = s.offset! - start
        if len >= MAX_QPATH || len < 5 {
            CG_Error("PrecacheItem: %s has bad precache string", item!.classname ?? "(null)")
            return
        }
        strncpy(&data, s.buf[start...], len)
        data[len] = 0
        if s.byte != 0 {
            s.advance()
        }

        if strcmp(data[(len - 3)...], "efx") == 0 {
            trap_FX_RegisterEffect(String(data))
        }
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:1356
private func CG_AS_Register() {
    var soundName: String
    var i: Int32

    //	CG_LoadingString( "ambient sound sets" );

    //Load the ambient sets
    //FIXME: Don't ask... I had to get around a really nasty MS error in the templates with this...
    trap_AS_AddPrecacheEntry("#clear")

    i = 1
    while i < MAX_AMBIENT_SETS {
        soundName = CG_ConfigString(CS_AMBIENT_SET + i)
        if soundName.isEmpty {
            break
        }

        trap_AS_AddPrecacheEntry(soundName)
        i += 1
    }
    soundName = CG_ConfigString(CS_GLOBAL_AMBIENT_SET)
    if !soundName.isEmpty && Q_stricmp(soundName, "default") != 0 {
        //global soundset
        trap_AS_AddPrecacheEntry(soundName)
    }

    trap_AS_ParseSets()
}

//a global weather effect (rain, snow, etc)
/// Source: oracle/codemp/cgame/cg_main.c:1395
func CG_ParseWeatherEffect(_ str: String) {
    let sptr = String(str.dropFirst()) //pass the '*'
    trap_R_WorldEffectCommand(sptr)
}

/// Source: oracle/codemp/cgame/cg_main.c:1403
func CG_ParseSiegeState(_ str: String) {
    var i: Int32 = 0
    var j: Int32 = 0
    //	int prevState = cgSiegeRoundState;
    var b = CharBuf(1024)

    while CharBuf(str)[i] != 0 && CharBuf(str)[i] != Int32(ascii: "|") {
        b[j] = CharBuf(str)[i]
        i += 1
        j += 1
    }
    b[j] = 0
    cgSiegeRoundState = atoi(b)

    if CharBuf(str)[i] == Int32(ascii: "|") {
        j = 0
        i += 1
        while CharBuf(str)[i] != 0 {
            b[j] = CharBuf(str)[i]
            i += 1
            j += 1
        }
        b[j] = 0
        //		if (cgSiegeRoundState != prevState)
        do {
            //it changed
            cgSiegeRoundTime = atoi(b)
            if cgSiegeRoundState == 0 || cgSiegeRoundState == 2 {
                cgSiegeRoundBeganTime = cgSiegeRoundTime
            }
        }
    } else {
        cgSiegeRoundTime = cg.time
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:1456
private func CG_RegisterSounds() {
    var i: Int32
    var items = CharBuf(257)
    var name = CharBuf(64)
    var soundName: String

    CG_AS_Register()

    //	CG_LoadingString( "sounds" );

    trap_S_RegisterSound("sound/weapons/melee/punch1.mp3")
    trap_S_RegisterSound("sound/weapons/melee/punch2.mp3")
    trap_S_RegisterSound("sound/weapons/melee/punch3.mp3")
    trap_S_RegisterSound("sound/weapons/melee/punch4.mp3")
    trap_S_RegisterSound("sound/movers/objects/saber_slam")

    trap_S_RegisterSound("sound/player/bodyfall_human1.wav")
    trap_S_RegisterSound("sound/player/bodyfall_human2.wav")
    trap_S_RegisterSound("sound/player/bodyfall_human3.wav")

    //test effects
    trap_FX_RegisterEffect("effects/mp/test_sparks.efx")
    trap_FX_RegisterEffect("effects/mp/test_wall_impact.efx")

    cgs.media.oneMinuteSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM004")
    cgs.media.fiveMinuteSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM005")
    cgs.media.oneFragSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM001")
    cgs.media.twoFragSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM002")
    cgs.media.threeFragSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM003")
    cgs.media.count3Sound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM035")
    cgs.media.count2Sound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM036")
    cgs.media.count1Sound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM037")
    cgs.media.countFightSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM038")

    cgs.media.hackerIconShader = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_tech")

    cgs.media.redSaberGlowShader = trap_R_RegisterShader("gfx/effects/sabers/red_glow")
    cgs.media.redSaberCoreShader = trap_R_RegisterShader("gfx/effects/sabers/red_line")
    cgs.media.orangeSaberGlowShader = trap_R_RegisterShader("gfx/effects/sabers/orange_glow")
    cgs.media.orangeSaberCoreShader = trap_R_RegisterShader("gfx/effects/sabers/orange_line")
    cgs.media.yellowSaberGlowShader = trap_R_RegisterShader("gfx/effects/sabers/yellow_glow")
    cgs.media.yellowSaberCoreShader = trap_R_RegisterShader("gfx/effects/sabers/yellow_line")
    cgs.media.greenSaberGlowShader = trap_R_RegisterShader("gfx/effects/sabers/green_glow")
    cgs.media.greenSaberCoreShader = trap_R_RegisterShader("gfx/effects/sabers/green_line")
    cgs.media.blueSaberGlowShader = trap_R_RegisterShader("gfx/effects/sabers/blue_glow")
    cgs.media.blueSaberCoreShader = trap_R_RegisterShader("gfx/effects/sabers/blue_line")
    cgs.media.purpleSaberGlowShader = trap_R_RegisterShader("gfx/effects/sabers/purple_glow")
    cgs.media.purpleSaberCoreShader = trap_R_RegisterShader("gfx/effects/sabers/purple_line")
    cgs.media.saberBlurShader = trap_R_RegisterShader("gfx/effects/sabers/saberBlur")
    cgs.media.swordTrailShader = trap_R_RegisterShader("gfx/effects/sabers/swordTrail")

    cgs.media.forceCoronaShader = trap_R_RegisterShaderNoMip("gfx/hud/force_swirl")

    cgs.media.yellowDroppedSaberShader = trap_R_RegisterShader("gfx/effects/yellow_glow")

    cgs.media.rivetMarkShader = trap_R_RegisterShader("gfx/damage/rivetmark")

    trap_R_RegisterShader("gfx/effects/saberFlare")

    trap_R_RegisterShader("powerups/ysalimarishell")

    trap_R_RegisterShader("gfx/effects/forcePush")

    trap_R_RegisterShader("gfx/misc/red_dmgshield")
    trap_R_RegisterShader("gfx/misc/red_portashield")
    trap_R_RegisterShader("gfx/misc/blue_dmgshield")
    trap_R_RegisterShader("gfx/misc/blue_portashield")

    trap_R_RegisterShader("models/map_objects/imp_mine/turret_chair_dmg.tga")

    i = 1
    while i < 9 {
        trap_S_RegisterSound(va("sound/weapons/saber/saberhup%i.wav", i))
        i += 1
    }

    i = 1
    while i < 10 {
        trap_S_RegisterSound(va("sound/weapons/saber/saberblock%i.wav", i))
        i += 1
    }

    i = 1
    while i < 4 {
        trap_S_RegisterSound(va("sound/weapons/saber/bounce%i.wav", i))
        i += 1
    }

    trap_S_RegisterSound("sound/weapons/saber/enemy_saber_on.wav")
    trap_S_RegisterSound("sound/weapons/saber/enemy_saber_off.wav")

    trap_S_RegisterSound("sound/weapons/saber/saberhum1.wav")
    trap_S_RegisterSound("sound/weapons/saber/saberon.wav")
    trap_S_RegisterSound("sound/weapons/saber/saberoffquick.wav")
    trap_S_RegisterSound("sound/weapons/saber/saberhitwall1")
    trap_S_RegisterSound("sound/weapons/saber/saberhitwall2")
    trap_S_RegisterSound("sound/weapons/saber/saberhitwall3")
    trap_S_RegisterSound("sound/weapons/saber/saberhit.wav")
    trap_S_RegisterSound("sound/weapons/saber/saberhit1.wav")
    trap_S_RegisterSound("sound/weapons/saber/saberhit2.wav")
    trap_S_RegisterSound("sound/weapons/saber/saberhit3.wav")

    trap_S_RegisterSound("sound/weapons/saber/saber_catch.wav")

    cgs.media.teamHealSound = trap_S_RegisterSound("sound/weapons/force/teamheal.wav")
    cgs.media.teamRegenSound = trap_S_RegisterSound("sound/weapons/force/teamforce.wav")

    trap_S_RegisterSound("sound/weapons/force/heal.wav")
    trap_S_RegisterSound("sound/weapons/force/speed.wav")
    trap_S_RegisterSound("sound/weapons/force/see.wav")
    trap_S_RegisterSound("sound/weapons/force/rage.wav")
    trap_S_RegisterSound("sound/weapons/force/lightning")
    trap_S_RegisterSound("sound/weapons/force/lightninghit1")
    trap_S_RegisterSound("sound/weapons/force/lightninghit2")
    trap_S_RegisterSound("sound/weapons/force/lightninghit3")
    trap_S_RegisterSound("sound/weapons/force/drain.wav")
    trap_S_RegisterSound("sound/weapons/force/jumpbuild.wav")
    trap_S_RegisterSound("sound/weapons/force/distract.wav")
    trap_S_RegisterSound("sound/weapons/force/distractstop.wav")
    trap_S_RegisterSound("sound/weapons/force/pull.wav")
    trap_S_RegisterSound("sound/weapons/force/push.wav")

    i = 1
    while i < 3 {
        trap_S_RegisterSound(va("sound/weapons/thermal/bounce%i.wav", i))
        i += 1
    }

    trap_S_RegisterSound("sound/movers/switches/switch2.wav")
    trap_S_RegisterSound("sound/movers/switches/switch3.wav")
    trap_S_RegisterSound("sound/ambience/spark5.wav")
    trap_S_RegisterSound("sound/chars/turret/ping.wav")
    trap_S_RegisterSound("sound/chars/turret/startup.wav")
    trap_S_RegisterSound("sound/chars/turret/shutdown.wav")
    trap_S_RegisterSound("sound/chars/turret/move.wav")
    trap_S_RegisterSound("sound/player/pickuphealth.wav")
    trap_S_RegisterSound("sound/player/pickupshield.wav")

    trap_S_RegisterSound("sound/effects/glassbreak1.wav")

    trap_S_RegisterSound("sound/weapons/rocket/tick.wav")
    trap_S_RegisterSound("sound/weapons/rocket/lock.wav")

    trap_S_RegisterSound("sound/weapons/force/speedloop.wav")

    trap_S_RegisterSound("sound/weapons/force/protecthit.mp3") //PDSOUND_PROTECTHIT
    trap_S_RegisterSound("sound/weapons/force/protect.mp3") //PDSOUND_PROTECT
    trap_S_RegisterSound("sound/weapons/force/absorbhit.mp3") //PDSOUND_ABSORBHIT
    trap_S_RegisterSound("sound/weapons/force/absorb.mp3") //PDSOUND_ABSORB
    trap_S_RegisterSound("sound/weapons/force/jump.mp3") //PDSOUND_FORCEJUMP
    trap_S_RegisterSound("sound/weapons/force/grip.mp3") //PDSOUND_FORCEGRIP

    if cgs.gametype >= GT_TEAM || cg_buildScript.integer != 0 {
        cgs.media.redLeadsSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM046")
        cgs.media.blueLeadsSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM045")
        cgs.media.teamsTiedSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM032")

        cgs.media.redScoredSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM044")
        cgs.media.blueScoredSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM043")

        if cgs.gametype == GT_CTF || cg_buildScript.integer != 0 {
            cgs.media.redFlagReturnedSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM042")
            cgs.media.blueFlagReturnedSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM041")
            cgs.media.redTookFlagSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM040")
            cgs.media.blueTookFlagSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM039")
        }
        if cgs.gametype == GT_CTY {
            cgs.media.redYsalReturnedSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM050")
            cgs.media.blueYsalReturnedSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM049")
            cgs.media.redTookYsalSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM048")
            cgs.media.blueTookYsalSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM047")
        }
    }

    cgs.media.drainSound = trap_S_RegisterSound("sound/weapons/force/drained.mp3")

    cgs.media.happyMusic = trap_S_RegisterSound("music/goodsmall.mp3")
    cgs.media.dramaticFailure = trap_S_RegisterSound("music/badsmall.mp3")

    //PRECACHE ALL MUSIC HERE (don't need to precache normally because it's streamed off the disk)
    if cg_buildScript.integer != 0 {
        trap_S_StartBackgroundTrack("music/mp/duel.mp3", "music/mp/duel.mp3", false)
    }

    cg.loadLCARSStage = 1

    cgs.media.selectSound = trap_S_RegisterSound("sound/weapons/change.wav")

    cgs.media.teleInSound = trap_S_RegisterSound("sound/player/telein.wav")
    cgs.media.teleOutSound = trap_S_RegisterSound("sound/player/teleout.wav")
    cgs.media.respawnSound = trap_S_RegisterSound("sound/items/respawn1.wav")

    trap_S_RegisterSound("sound/movers/objects/objectHit.wav")

    cgs.media.talkSound = trap_S_RegisterSound("sound/player/talk.wav")
    cgs.media.landSound = trap_S_RegisterSound("sound/player/land1.wav")
    cgs.media.fallSound = trap_S_RegisterSound("sound/player/fallsplat.wav")

    cgs.media.crackleSound = trap_S_RegisterSound("sound/effects/energy_crackle.wav")

    /*
    cgs.media.takenLeadSound = trap_S_RegisterSound( "sound/chars/protocol/misc/40MOM051");
    cgs.media.tiedLeadSound = trap_S_RegisterSound( "sound/chars/protocol/misc/40MOM032");
    cgs.media.lostLeadSound = trap_S_RegisterSound( "sound/chars/protocol/misc/40MOM052");
    */

    cgs.media.rollSound = trap_S_RegisterSound("sound/player/roll1.wav")

    cgs.media.noforceSound = trap_S_RegisterSound("sound/weapons/force/noforce")

    cgs.media.watrInSound = trap_S_RegisterSound("sound/player/watr_in.wav")
    cgs.media.watrOutSound = trap_S_RegisterSound("sound/player/watr_out.wav")
    cgs.media.watrUnSound = trap_S_RegisterSound("sound/player/watr_un.wav")

    cgs.media.explosionModel = trap_R_RegisterModel("models/map_objects/mp/sphere.md3")
    cgs.media.surfaceExplosionShader = trap_R_RegisterShader("surfaceExplosion")

    cgs.media.disruptorShader = trap_R_RegisterShader("gfx/effects/burn")

    if cg_buildScript.integer != 0 {
        trap_R_RegisterShader("gfx/effects/turretflashdie")
    }

    cgs.media.solidWhite = trap_R_RegisterShader("gfx/effects/solidWhite_cull")

    trap_R_RegisterShader("gfx/misc/mp_light_enlight_disable")
    trap_R_RegisterShader("gfx/misc/mp_dark_enlight_disable")

    trap_R_RegisterModel("models/map_objects/mp/sphere.md3")
    trap_R_RegisterModel("models/items/remote.md3")

    cgs.media.holocronPickup = trap_S_RegisterSound("sound/player/holocron.wav")

    // Zoom
    cgs.media.zoomStart = trap_S_RegisterSound("sound/interface/zoomstart.wav")
    cgs.media.zoomLoop = trap_S_RegisterSound("sound/interface/zoomloop.wav")
    cgs.media.zoomEnd = trap_S_RegisterSound("sound/interface/zoomend.wav")

    i = 0
    while i < 4 {
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/stone_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_STONEWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/stone_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_STONERUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/metal_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_METALWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/metal_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_METALRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/pipe_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_PIPEWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/pipe_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_PIPERUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/water_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_SPLASH][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/water_walk%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_WADE][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/water_wade_0%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_SWIM][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/snow_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_SNOWWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/snow_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_SNOWRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/sand_walk%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_SANDWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/sand_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_SANDRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/grass_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_GRASSWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/grass_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_GRASSRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/dirt_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_DIRTWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/dirt_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_DIRTRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/mud_walk%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_MUDWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/mud_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_MUDRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/gravel_walk%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_GRAVELWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/gravel_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_GRAVELRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/rug_step%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_RUGWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/rug_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_RUGRUN][i] = trap_S_RegisterSound(String(name))

        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/wood_walk%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_WOODWALK][i] = trap_S_RegisterSound(String(name))
        Com_sprintf(&name, Int32((name).count), "sound/player/footsteps/wood_run%i.wav", i + 1)
        cgs.media.footsteps[FOOTSTEP_WOODRUN][i] = trap_S_RegisterSound(String(name))
        i += 1
    }

    // only register the items that the server says we need
    strcpy(&items, CG_ConfigString(CS_ITEMS))

    i = 1
    while i < bg_numItems {
        if items[i] == Int32(ascii: "1") || cg_buildScript.integer != 0 {
            CG_RegisterItemSounds(i)
        }
        i += 1
    }

    i = 1
    while i < MAX_SOUNDS {
        soundName = CG_ConfigString(CS_SOUNDS + i)
        if soundName.isEmpty {
            break
        }
        if CharBuf(soundName)[0] == Int32(ascii: "*") {
            if CharBuf(soundName)[1] == Int32(ascii: "$") {
                //an NPC soundset
                CG_PrecacheNPCSounds(soundName)
            }
            i += 1
            continue // custom sound
        }
        cgs.gameSounds[i] = trap_S_RegisterSound(soundName)
        i += 1
    }

    i = 1
    while i < MAX_FX {
        soundName = CG_ConfigString(CS_EFFECTS + i)
        if soundName.isEmpty {
            break
        }

        if CharBuf(soundName)[0] == Int32(ascii: "*") {
            //it's a special global weather effect
            CG_ParseWeatherEffect(soundName)
            cgs.gameEffects[i] = 0
        } else {
            cgs.gameEffects[i] = trap_FX_RegisterEffect(soundName)
        }
        i += 1
    }

    // register all the server specified icons
    i = 1
    while i < MAX_ICONS {
        var iconName: String

        iconName = CG_ConfigString(CS_ICONS + i)
        if iconName.isEmpty {
            break
        }

        cgs.gameIcons[i] = trap_R_RegisterShaderNoMip(iconName)
        i += 1
    }

    soundName = CG_ConfigString(CS_SIEGE_STATE)

    if !soundName.isEmpty {
        CG_ParseSiegeState(soundName)
    }

    soundName = CG_ConfigString(CS_SIEGE_WINTEAM)

    if !soundName.isEmpty {
        cg_siegeWinTeam = atoi(soundName)
    }

    if cgs.gametype == GT_SIEGE {
        CG_ParseSiegeObjectiveStatus(CG_ConfigString(CS_SIEGE_OBJECTIVES))
        cg_beatingSiegeTime = atoi(CG_ConfigString(CS_SIEGE_TIMEOVERRIDE))
        if cg_beatingSiegeTime != 0 {
            CG_SetSiegeTimerCvar(cg_beatingSiegeTime)
        }
    }

    cg.loadLCARSStage = 2

    // FIXME: only needed with item
    cgs.media.deploySeeker = trap_S_RegisterSound("sound/chars/seeker/misc/hiss")
    cgs.media.medkitSound = trap_S_RegisterSound("sound/items/use_bacta.wav")

    cgs.media.winnerSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM006")
    cgs.media.loserSound = trap_S_RegisterSound("sound/chars/protocol/misc/40MOM010")
}

//-------------------------------------
// CG_RegisterEffects
//
// Handles precaching all effect files
//	and any shader, model, or sound
//	files an effect may use.
//-------------------------------------
/// Source: oracle/codemp/cgame/cg_main.c:1867
private func CG_RegisterEffects() {
    /*
    const char	*effectName;
    int			i;

    for ( i = 1 ; i < MAX_FX ; i++ )
    {
    effectName = CG_ConfigString( CS_EFFECTS + i );

    if ( !effectName[0] )
    {
    break;
    }

    trap_FX_RegisterEffect( effectName );
    }
    */
    //the above was redundant as it's being done in CG_RegisterSounds

    // Set up the glass effects mini-system.
    CG_InitGlass()

    //footstep effects
    cgs.effects.footstepMud = trap_FX_RegisterEffect("materials/mud")
    cgs.effects.footstepSand = trap_FX_RegisterEffect("materials/sand")
    cgs.effects.footstepSnow = trap_FX_RegisterEffect("materials/snow")
    cgs.effects.footstepGravel = trap_FX_RegisterEffect("materials/gravel")
    //landing effects
    cgs.effects.landingMud = trap_FX_RegisterEffect("materials/mud_large")
    cgs.effects.landingSand = trap_FX_RegisterEffect("materials/sand_large")
    cgs.effects.landingDirt = trap_FX_RegisterEffect("materials/dirt_large")
    cgs.effects.landingSnow = trap_FX_RegisterEffect("materials/snow_large")
    cgs.effects.landingGravel = trap_FX_RegisterEffect("materials/gravel_large")
    //splashes
    cgs.effects.waterSplash = trap_FX_RegisterEffect("env/water_impact")
    cgs.effects.lavaSplash = trap_FX_RegisterEffect("env/lava_splash")
    cgs.effects.acidSplash = trap_FX_RegisterEffect("env/acid_splash")
}

/// Raven's `static char *sb_nums[11]` of `CG_RegisterGraphics`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_main.c:1926
var sb_nums: [String] {
    get { world.sb_nums }
    set { world.sb_nums = newValue }
}

/// Raven's `static char *sb_t_nums[11]` of `CG_RegisterGraphics`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_main.c:1940
var sb_t_nums: [String] {
    get { world.sb_t_nums }
    set { world.sb_t_nums = newValue }
}

/// Raven's `static char *sb_c_nums[11]` of `CG_RegisterGraphics`, which the world keeps.
/// Source: oracle/codemp/cgame/cg_main.c:1954
var sb_c_nums: [String] {
    get { world.sb_c_nums }
    set { world.sb_c_nums = newValue }
}

/**
```
=================
CG_RegisterGraphics

This function may execute for a couple of minutes with a slow disk.
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:1919
private func CG_RegisterGraphics() {
    var i: Int32
    var breakPoint: Int32
    var items = CharBuf(257)
    var terrainInfo: String
    var terrainID: Int32

    // clear any references to old media
    cg.refdef.clear()
    trap_R_ClearScene()

    CG_LoadingString(cgs.mapname)

    //#ifndef _XBOX
    trap_R_LoadWorldMap(cgs.mapname)
    //#endif

    // precache status bar pics
    //	CG_LoadingString( "game media" );

    i = 0
    while i < 11 {
        cgs.media.numberShaders[i] = trap_R_RegisterShader(sb_nums[i])
        i += 1
    }

    cg.loadLCARSStage = 3

    i = 0
    while i < 11 {
        cgs.media.numberShaders[i] = trap_R_RegisterShaderNoMip(sb_nums[i])
        cgs.media.smallnumberShaders[i] = trap_R_RegisterShaderNoMip(sb_t_nums[i])
        cgs.media.chunkyNumberShaders[i] = trap_R_RegisterShaderNoMip(sb_c_nums[i])
        i += 1
    }

    trap_R_RegisterShaderNoMip("gfx/mp/pduel_icon_lone")
    trap_R_RegisterShaderNoMip("gfx/mp/pduel_icon_double")

    cgs.media.balloonShader = trap_R_RegisterShader("gfx/mp/chat_icon")
    cgs.media.vchatShader = trap_R_RegisterShader("gfx/mp/vchat_icon")

    cgs.media.deferShader = trap_R_RegisterShaderNoMip("gfx/2d/defer.tga")

    cgs.media.radarShader = trap_R_RegisterShaderNoMip("gfx/menus/radar/radar.png")
    cgs.media.siegeItemShader = trap_R_RegisterShaderNoMip("gfx/menus/radar/goalitem")
    cgs.media.mAutomapPlayerIcon = trap_R_RegisterShader("gfx/menus/radar/arrow_w")
    cgs.media.mAutomapRocketIcon = trap_R_RegisterShader("gfx/menus/radar/rocket")

    cgs.media.wireframeAutomapFrame_left = trap_R_RegisterShader("gfx/mp_automap/mpauto_frame_left")
    cgs.media.wireframeAutomapFrame_right = trap_R_RegisterShader("gfx/mp_automap/mpauto_frame_right")
    cgs.media.wireframeAutomapFrame_top = trap_R_RegisterShader("gfx/mp_automap/mpauto_frame_top")
    cgs.media.wireframeAutomapFrame_bottom = trap_R_RegisterShader("gfx/mp_automap/mpauto_frame_bottom")

    cgs.media.lagometerShader = trap_R_RegisterShaderNoMip("gfx/2d/lag")
    cgs.media.connectionShader = trap_R_RegisterShaderNoMip("gfx/2d/net")

    trap_FX_InitSystem(cg.refdef)
    CG_RegisterEffects()

    cgs.media.boltShader = trap_R_RegisterShader("gfx/misc/blueLine")

    cgs.effects.turretShotEffect = trap_FX_RegisterEffect("turret/shot")
    cgs.effects.mEmplacedDeadSmoke = trap_FX_RegisterEffect("emplaced/dead_smoke.efx")
    cgs.effects.mEmplacedExplode = trap_FX_RegisterEffect("emplaced/explode.efx")
    cgs.effects.mTurretExplode = trap_FX_RegisterEffect("turret/explode.efx")
    cgs.effects.mSparkExplosion = trap_FX_RegisterEffect("sparks/spark_explosion.efx")
    cgs.effects.mTripmineExplosion = trap_FX_RegisterEffect("tripMine/explosion.efx")
    cgs.effects.mDetpackExplosion = trap_FX_RegisterEffect("detpack/explosion.efx")
    cgs.effects.mFlechetteAltBlow = trap_FX_RegisterEffect("flechette/alt_blow.efx")
    cgs.effects.mStunBatonFleshImpact = trap_FX_RegisterEffect("stunBaton/flesh_impact.efx")
    cgs.effects.mAltDetonate = trap_FX_RegisterEffect("demp2/altDetonate.efx")
    cgs.effects.mSparksExplodeNoSound = trap_FX_RegisterEffect("sparks/spark_exp_nosnd")
    cgs.effects.mTripMineLaster = trap_FX_RegisterEffect("tripMine/laser.efx")
    cgs.effects.mEmplacedMuzzleFlash = trap_FX_RegisterEffect("effects/emplaced/muzzle_flash")
    cgs.effects.mConcussionAltRing = trap_FX_RegisterEffect("concussion/alt_ring")

    cgs.effects.mHyperspaceStars = trap_FX_RegisterEffect("ships/hyperspace_stars")
    cgs.effects.mBlackSmoke = trap_FX_RegisterEffect("volumetric/black_smoke")
    cgs.effects.mShipDestDestroyed = trap_FX_RegisterEffect("effects/ships/dest_destroyed.efx")
    cgs.effects.mShipDestBurning = trap_FX_RegisterEffect("effects/ships/dest_burning.efx")
    cgs.effects.mBobaJet = trap_FX_RegisterEffect("effects/boba/jet.efx")


    cgs.effects.itemCone = trap_FX_RegisterEffect("mp/itemcone.efx")
    cgs.effects.mTurretMuzzleFlash = trap_FX_RegisterEffect("effects/turret/muzzle_flash.efx")
    cgs.effects.mSparks = trap_FX_RegisterEffect("sparks/spark_nosnd.efx") //sparks/spark.efx
    cgs.effects.mSaberCut = trap_FX_RegisterEffect("saber/saber_cut.efx")
    cgs.effects.mSaberBlock = trap_FX_RegisterEffect("saber/saber_block.efx")
    cgs.effects.mSaberBloodSparks = trap_FX_RegisterEffect("saber/blood_sparks_mp.efx")
    cgs.effects.mSaberBloodSparksSmall = trap_FX_RegisterEffect("saber/blood_sparks_25_mp.efx")
    cgs.effects.mSaberBloodSparksMid = trap_FX_RegisterEffect("saber/blood_sparks_50_mp.efx")
    cgs.effects.mSpawn = trap_FX_RegisterEffect("mp/spawn.efx")
    cgs.effects.mJediSpawn = trap_FX_RegisterEffect("mp/jedispawn.efx")
    cgs.effects.mBlasterDeflect = trap_FX_RegisterEffect("blaster/deflect.efx")
    cgs.effects.mBlasterSmoke = trap_FX_RegisterEffect("blaster/smoke_bolton")
    cgs.effects.mForceConfustionOld = trap_FX_RegisterEffect("force/confusion_old.efx")

    cgs.effects.forceLightning = trap_FX_RegisterEffect("effects/force/lightning.efx")
    cgs.effects.forceLightningWide = trap_FX_RegisterEffect("effects/force/lightningwide.efx")
    cgs.effects.forceDrain = trap_FX_RegisterEffect("effects/mp/drain.efx")
    cgs.effects.forceDrainWide = trap_FX_RegisterEffect("effects/mp/drainwide.efx")
    cgs.effects.forceDrained = trap_FX_RegisterEffect("effects/mp/drainhit.efx")

    cgs.effects.mDisruptorDeathSmoke = trap_FX_RegisterEffect("disruptor/death_smoke")

    i = 0
    while i < NUM_CROSSHAIRS {
        cgs.media.crosshairShader[i] = trap_R_RegisterShaderNoMip(va("gfx/2d/crosshair%c", Int32(ascii: "a") + i))
        i += 1
    }

    cg.loadLCARSStage = 4

    cgs.media.backTileShader = trap_R_RegisterShader("gfx/2d/backtile")

    //precache the fpls skin
    //trap_R_RegisterSkin("models/players/kyle/model_fpls2.skin");

    cgs.media.itemRespawningPlaceholder = trap_R_RegisterShader("powerups/placeholder")
    cgs.media.itemRespawningRezOut = trap_R_RegisterShader("powerups/rezout")

    cgs.media.playerShieldDamage = trap_R_RegisterShader("gfx/misc/personalshield")
    cgs.media.protectShader = trap_R_RegisterShader("gfx/misc/forceprotect")
    cgs.media.forceSightBubble = trap_R_RegisterShader("gfx/misc/sightbubble")
    cgs.media.forceShell = trap_R_RegisterShader("powerups/forceshell")
    cgs.media.sightShell = trap_R_RegisterShader("powerups/sightshell")

    cgs.media.itemHoloModel = trap_R_RegisterModel("models/map_objects/mp/holo.md3")

    if cgs.gametype == GT_HOLOCRON || cg_buildScript.integer != 0 {
        i = 0
        while i < NUM_FORCE_POWERS {
            if forceHolocronModels[i] != nil && CharBuf(forceHolocronModels[i])[0] != 0 {
                trap_R_RegisterModel(forceHolocronModels[i])
            }
            i += 1
        }
    }

    if cgs.gametype == GT_CTF || cgs.gametype == GT_CTY || cg_buildScript.integer != 0 {
        if cg_buildScript.integer != 0 {
            trap_R_RegisterModel("models/flags/r_flag.md3")
            trap_R_RegisterModel("models/flags/b_flag.md3")
            trap_R_RegisterModel("models/flags/r_flag_ysal.md3")
            trap_R_RegisterModel("models/flags/b_flag_ysal.md3")
        }

        if cgs.gametype == GT_CTF {
            cgs.media.redFlagModel = trap_R_RegisterModel("models/flags/r_flag.md3")
            cgs.media.blueFlagModel = trap_R_RegisterModel("models/flags/b_flag.md3")
        } else {
            cgs.media.redFlagModel = trap_R_RegisterModel("models/flags/r_flag_ysal.md3")
            cgs.media.blueFlagModel = trap_R_RegisterModel("models/flags/b_flag_ysal.md3")
        }

        trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag_x")
        trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag_x")

        trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag_ys")
        trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag_ys")

        trap_R_RegisterShaderNoMip("gfx/hud/mpi_rflag")
        trap_R_RegisterShaderNoMip("gfx/hud/mpi_bflag")

        trap_R_RegisterShaderNoMip("gfx/2d/net.tga")

        cgs.media.flagPoleModel = trap_R_RegisterModel("models/flag2/flagpole.md3")
        cgs.media.flagFlapModel = trap_R_RegisterModel("models/flag2/flagflap3.md3")

        cgs.media.redFlagBaseModel = trap_R_RegisterModel("models/mapobjects/flagbase/red_base.md3")
        cgs.media.blueFlagBaseModel = trap_R_RegisterModel("models/mapobjects/flagbase/blue_base.md3")
        cgs.media.neutralFlagBaseModel = trap_R_RegisterModel("models/mapobjects/flagbase/ntrl_base.md3")
    }

    if cgs.gametype >= GT_TEAM || cg_buildScript.integer != 0 {
        cgs.media.teamRedShader = trap_R_RegisterShader("sprites/team_red")
        cgs.media.teamBlueShader = trap_R_RegisterShader("sprites/team_blue")
        //cgs.media.redQuadShader = trap_R_RegisterShader("powerups/blueflag" );
        cgs.media.teamStatusBar = trap_R_RegisterShader("gfx/2d/colorbar.tga")
    } else if cgs.gametype == GT_JEDIMASTER {
        cgs.media.teamRedShader = trap_R_RegisterShader("sprites/team_red")
    }

    if cgs.gametype == GT_POWERDUEL || cg_buildScript.integer != 0 {
        cgs.media.powerDuelAllyShader = trap_R_RegisterShader("gfx/mp/pduel_icon_double") //trap_R_RegisterShader("gfx/mp/pduel_gameicon_ally");
    }

    cgs.media.heartShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/selectedhealth.tga")

    cgs.media.ysaliredShader = trap_R_RegisterShader("powerups/ysaliredshell")
    cgs.media.ysaliblueShader = trap_R_RegisterShader("powerups/ysaliblueshell")
    cgs.media.ysalimariShader = trap_R_RegisterShader("powerups/ysalimarishell")
    cgs.media.boonShader = trap_R_RegisterShader("powerups/boonshell")
    cgs.media.endarkenmentShader = trap_R_RegisterShader("powerups/endarkenmentshell")
    cgs.media.enlightenmentShader = trap_R_RegisterShader("powerups/enlightenmentshell")
    cgs.media.invulnerabilityShader = trap_R_RegisterShader("powerups/invulnerabilityshell")


    // Binocular interface
    cgs.media.binocularCircle = trap_R_RegisterShader("gfx/2d/binCircle")
    cgs.media.binocularMask = trap_R_RegisterShader("gfx/2d/binMask")
    cgs.media.binocularArrow = trap_R_RegisterShader("gfx/2d/binSideArrow")
    cgs.media.binocularTri = trap_R_RegisterShader("gfx/2d/binTopTri")
    cgs.media.binocularStatic = trap_R_RegisterShader("gfx/2d/binocularWindow")
    cgs.media.binocularOverlay = trap_R_RegisterShader("gfx/2d/binocularNumOverlay")

    cg.loadLCARSStage = 5

    // Chunk models
    //FIXME: jfm:? bother to conditionally load these if an ent has this material type?
    i = 0
    while i < NUM_CHUNK_MODELS {
        cgs.media.chunkModels[CHUNK_METAL2][i] = trap_R_RegisterModel(va("models/chunks/metal/metal1_%i.md3", i + 1)) //_ /switched\ _
        cgs.media.chunkModels[CHUNK_METAL1][i] = trap_R_RegisterModel(va("models/chunks/metal/metal2_%i.md3", i + 1)) //  \switched/
        cgs.media.chunkModels[CHUNK_ROCK1][i] = trap_R_RegisterModel(va("models/chunks/rock/rock1_%i.md3", i + 1))
        cgs.media.chunkModels[CHUNK_ROCK2][i] = trap_R_RegisterModel(va("models/chunks/rock/rock2_%i.md3", i + 1))
        cgs.media.chunkModels[CHUNK_ROCK3][i] = trap_R_RegisterModel(va("models/chunks/rock/rock3_%i.md3", i + 1))
        cgs.media.chunkModels[CHUNK_CRATE1][i] = trap_R_RegisterModel(va("models/chunks/crate/crate1_%i.md3", i + 1))
        cgs.media.chunkModels[CHUNK_CRATE2][i] = trap_R_RegisterModel(va("models/chunks/crate/crate2_%i.md3", i + 1))
        cgs.media.chunkModels[CHUNK_WHITE_METAL][i] = trap_R_RegisterModel(va("models/chunks/metal/wmetal1_%i.md3", i + 1))
        i += 1
    }

    cgs.media.chunkSound = trap_S_RegisterSound("sound/weapons/explosions/glasslcar")
    cgs.media.grateSound = trap_S_RegisterSound("sound/effects/grate_destroy")
    cgs.media.rockBreakSound = trap_S_RegisterSound("sound/effects/wall_smash")
    cgs.media.rockBounceSound[0] = trap_S_RegisterSound("sound/effects/stone_bounce")
    cgs.media.rockBounceSound[1] = trap_S_RegisterSound("sound/effects/stone_bounce2")
    cgs.media.metalBounceSound[0] = trap_S_RegisterSound("sound/effects/metal_bounce")
    cgs.media.metalBounceSound[1] = trap_S_RegisterSound("sound/effects/metal_bounce2")
    cgs.media.glassChunkSound = trap_S_RegisterSound("sound/weapons/explosions/glassbreak1")
    cgs.media.crateBreakSound[0] = trap_S_RegisterSound("sound/weapons/explosions/crateBust1")
    cgs.media.crateBreakSound[1] = trap_S_RegisterSound("sound/weapons/explosions/crateBust2")

    /*
    Ghoul2 Insert Start
    */
    CG_InitItems()
    /*
    Ghoul2 Insert End
    */
    cg_weapons.zero()

    // only register the items that the server says we need
    strcpy(&items, CG_ConfigString(CS_ITEMS))

    i = 1
    while i < bg_numItems {
        if items[i] == Int32(ascii: "1") || cg_buildScript.integer != 0 {
            CG_LoadingItem(i)
            CG_RegisterItemVisuals(i)
        }
        i += 1
    }

    cg.loadLCARSStage = 6

    cgs.media.glassShardShader = trap_R_RegisterShader("gfx/misc/test_crackle")

    // doing one shader just makes it look like a shell.  By using two shaders with different bulge offsets and different texture scales, it has a much more chaotic look
    cgs.media.electricBodyShader = trap_R_RegisterShader("gfx/misc/electric")
    cgs.media.electricBody2Shader = trap_R_RegisterShader("gfx/misc/fullbodyelectric2")

    cgs.media.fsrMarkShader = trap_R_RegisterShader("footstep_r")
    cgs.media.fslMarkShader = trap_R_RegisterShader("footstep_l")
    cgs.media.fshrMarkShader = trap_R_RegisterShader("footstep_heavy_r")
    cgs.media.fshlMarkShader = trap_R_RegisterShader("footstep_heavy_l")

    cgs.media.refractionShader = trap_R_RegisterShader("effects/refraction")

    cgs.media.cloakedShader = trap_R_RegisterShader("gfx/effects/cloakedShader")

    // wall marks
    cgs.media.shadowMarkShader = trap_R_RegisterShader("markShadow")
    cgs.media.wakeMarkShader = trap_R_RegisterShader("wake")

    cgs.media.viewPainShader = trap_R_RegisterShader("gfx/misc/borgeyeflare")
    cgs.media.viewPainShader_Shields = trap_R_RegisterShader("gfx/mp/dmgshader_shields")
    cgs.media.viewPainShader_ShieldsAndHealth = trap_R_RegisterShader("gfx/mp/dmgshader_shieldsandhealth")

    // register the inline models
    cgs.numInlineModels = trap_CM_NumInlineModels()
    breakPoint = cgs.numInlineModels
    i = 1
    while i < cgs.numInlineModels {
        var name = CharBuf(10)
        var mins = vec3_t()
        var maxs = vec3_t()
        var j: Int32

        Com_sprintf(&name, Int32((name).count), "*%i", i)
        cgs.inlineDrawModel[i] = trap_R_RegisterModel(String(name))
        if cgs.inlineDrawModel[i] == 0 {
            breakPoint = i
            break
        }

        trap_R_ModelBounds(cgs.inlineDrawModel[i], &mins, &maxs)
        j = 0
        while j < 3 {
            cgs.inlineModelMidpoints[i][j] = Float(Double(mins[j]) + 0.5 * Double(maxs[j] - mins[j]))
            j += 1
        }
        i += 1
    }

    cg.loadLCARSStage = 7

    // register all the server specified models
    i = 1
    while i < MAX_MODELS {
        var cModelName: String
        var modelName = CharBuf(64)

        cModelName = CG_ConfigString(CS_MODELS + i)
        if cModelName.isEmpty {
            break
        }

        strcpy(&modelName, cModelName)
        if strstr(modelName, ".glm") != nil || modelName[0] == Int32(ascii: "$") {
            //Check to see if it has a custom skin attached.
            CG_HandleAppendedSkin(&modelName)
            CG_CacheG2AnimInfo(String(modelName))
        }

        if modelName[0] != Int32(ascii: "$") && modelName[0] != Int32(ascii: "@") {
            //don't register vehicle names and saber names as models.
            cgs.gameModels[i] = trap_R_RegisterModel(String(modelName))
        } else {
            //FIXME: register here so that stuff gets precached!!!
            cgs.gameModels[i] = 0
        }
        i += 1
    }
    cg.loadLCARSStage = 8
    /*
    Ghoul2 Insert Start
    */


    //	CG_LoadingString( "BSP instances" );

    i = 1
    while i < MAX_SUB_BSP {
        var bspName: String? = nil
        var mins = vec3_t()
        var maxs = vec3_t()
        var j: Int32
        var sub: Int32 = 0
        var temp = CharBuf(64)

        bspName = CG_ConfigString(CS_BSP_MODELS + i)
        if bspName!.isEmpty {
            break
        }

        trap_CM_LoadMap(bspName!, true)
        cgs.inlineDrawModel[breakPoint] = trap_R_RegisterModel(bspName!)
        trap_R_ModelBounds(cgs.inlineDrawModel[breakPoint], &mins, &maxs)
        j = 0
        while j < 3 {
            cgs.inlineModelMidpoints[breakPoint][j] = Float(Double(mins[j]) + 0.5 * Double(maxs[j] - mins[j]))
            j += 1
        }
        breakPoint += 1
        sub = 1
        while sub < MAX_MODELS {
            Com_sprintf(&temp, MAX_QPATH, "*%d-%d", i, sub)
            cgs.inlineDrawModel[breakPoint] = trap_R_RegisterModel(String(temp))
            if cgs.inlineDrawModel[breakPoint] == 0 {
                break
            }
            trap_R_ModelBounds(cgs.inlineDrawModel[breakPoint], &mins, &maxs)
            j = 0
            while j < 3 {
                cgs.inlineModelMidpoints[breakPoint][j] = Float(Double(mins[j]) + 0.5 * Double(maxs[j] - mins[j]))
                j += 1
            }
            breakPoint += 1
            sub += 1
        }
        i += 1
    }

    //	CG_LoadingString( "Creating terrain" );
    i = 1
    while i < MAX_TERRAINS {
        terrainInfo = CG_ConfigString(CS_TERRAINS + i)
        if terrainInfo.isEmpty {
            break
        }

        terrainID = trap_CM_RegisterTerrain(terrainInfo)

        trap_RMG_Init(terrainID, terrainInfo)

        // Send off the terrainInfo to the renderer
        trap_RE_InitRendererTerrain(terrainInfo)
        i += 1
    }

    /*
    CG_LoadingString("skins");
    // register all the server specified models
    for (i=1 ; i<MAX_CHARSKINS ; i++) {
    const char		*modelName;

    modelName = CG_ConfigString( CS_CHARSKINS+i );
    if ( !modelName[0] ) {
    break;
    }
    cgs.skins[i] = trap_R_RegisterSkin( modelName );
    }
    */
    //rww - removed and replaced with CS_G2BONES. For custom skins
    //the new method is to append a * after an indexed model name and
    //then append the skin name after that (note that this is only
    //used for NPCs)

    //	CG_LoadingString("weapons");

    CG_InitG2Weapons()

    /*
    Ghoul2 Insert End
    */
    cg.loadLCARSStage = 9


    // new stuff
    cgs.media.patrolShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/patrol.tga")
    cgs.media.assaultShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/assault.tga")
    cgs.media.campShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/camp.tga")
    cgs.media.followShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/follow.tga")
    cgs.media.defendShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/defend.tga")
    cgs.media.teamLeaderShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/team_leader.tga")
    cgs.media.retrieveShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/retrieve.tga")
    cgs.media.escortShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/escort.tga")
    cgs.media.cursor = trap_R_RegisterShaderNoMip("menu/art/3_cursor2")
    cgs.media.sizeCursor = trap_R_RegisterShaderNoMip("ui/assets/sizecursor.tga")
    cgs.media.selectCursor = trap_R_RegisterShaderNoMip("ui/assets/selectcursor.tga")
    cgs.media.flagShaders[0] = trap_R_RegisterShaderNoMip("ui/assets/statusbar/flag_in_base.tga")
    cgs.media.flagShaders[1] = trap_R_RegisterShaderNoMip("ui/assets/statusbar/flag_capture.tga")
    cgs.media.flagShaders[2] = trap_R_RegisterShaderNoMip("ui/assets/statusbar/flag_missing.tga")

    cgs.media.halfShieldModel = trap_R_RegisterModel("models/weaphits/testboom.md3")
    cgs.media.halfShieldShader = trap_R_RegisterShader("halfShieldShell")

    trap_FX_RegisterEffect("force/force_touch")

    CG_ClearParticles()
    /*
    for (i=1; i<MAX_PARTICLES_AREAS; i++)
    {
    {
    int rval;

    rval = CG_NewParticleArea ( CS_PARTICLES + i);
    if (!rval)
    break;
    }
    }
    */
}

/// Source: oracle/codemp/cgame/cg_main.c:2429
func CG_GetStringEdString(_ refSection: String, _ refName: String?) -> String {
    // Raven's ring of static buffers keeps one result valid across a later call, and a returned `String` is already a copy.
    var text = CharBuf(1024)

    strcpy(&text, trap_SP_GetStringTextString(va("%s_%s", refSection, refName!), Int32((text).count)).1)
    return String(text)
}

/// Source: oracle/codemp/cgame/cg_main.c:2442
func CG_SiegeCountCvars() {
    var classGfx: [Int32] = [Int32](repeating: 0, count: 6)

    trap_Cvar_Set("ui_tm1_cnt", va("%d", CG_GetTeamNonScoreCount(TEAM_RED)))
    trap_Cvar_Set("ui_tm2_cnt", va("%d", CG_GetTeamNonScoreCount(TEAM_BLUE)))
    trap_Cvar_Set("ui_tm3_cnt", va("%d", CG_GetTeamNonScoreCount(TEAM_SPECTATOR)))

    // This is because the only way we can match up classes is by the gfx handle.
    classGfx[0] = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_infantry")
    classGfx[1] = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_heavy_weapons")
    classGfx[2] = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_demolitionist")
    classGfx[3] = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_vanguard")
    classGfx[4] = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_support")
    classGfx[5] = trap_R_RegisterShaderNoMip("gfx/mp/c_icon_jedi_general")

    trap_Cvar_Set("ui_tm1_c0_cnt", va("%d", CG_GetClassCount(TEAM_RED, classGfx[0])))
    trap_Cvar_Set("ui_tm1_c1_cnt", va("%d", CG_GetClassCount(TEAM_RED, classGfx[1])))
    trap_Cvar_Set("ui_tm1_c2_cnt", va("%d", CG_GetClassCount(TEAM_RED, classGfx[2])))
    trap_Cvar_Set("ui_tm1_c3_cnt", va("%d", CG_GetClassCount(TEAM_RED, classGfx[3])))
    trap_Cvar_Set("ui_tm1_c4_cnt", va("%d", CG_GetClassCount(TEAM_RED, classGfx[4])))
    trap_Cvar_Set("ui_tm1_c5_cnt", va("%d", CG_GetClassCount(TEAM_RED, classGfx[5])))

    trap_Cvar_Set("ui_tm2_c0_cnt", va("%d", CG_GetClassCount(TEAM_BLUE, classGfx[0])))
    trap_Cvar_Set("ui_tm2_c1_cnt", va("%d", CG_GetClassCount(TEAM_BLUE, classGfx[1])))
    trap_Cvar_Set("ui_tm2_c2_cnt", va("%d", CG_GetClassCount(TEAM_BLUE, classGfx[2])))
    trap_Cvar_Set("ui_tm2_c3_cnt", va("%d", CG_GetClassCount(TEAM_BLUE, classGfx[3])))
    trap_Cvar_Set("ui_tm2_c4_cnt", va("%d", CG_GetClassCount(TEAM_BLUE, classGfx[4])))
    trap_Cvar_Set("ui_tm2_c5_cnt", va("%d", CG_GetClassCount(TEAM_BLUE, classGfx[5])))
}

/**
```
=======================
CG_BuildSpectatorString

=======================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:2480
func CG_BuildSpectatorString() {
    var i: Int32
    cg.spectatorList = ""

    // Count up the number of players per team and per class
    CG_SiegeCountCvars()

    i = 0
    while i < MAX_CLIENTS {
        if cgs.clientinfo[i].infoValid && cgs.clientinfo[i].team == TEAM_SPECTATOR {
            Q_strcat(&cg.spectatorListBuffer, 1024, va("%s     ", cgs.clientinfo[i].name))
        }
        i += 1
    }
    i = strlen(cg.spectatorList)
    if i != cg.spectatorLen {
        cg.spectatorLen = i
        cg.spectatorWidth = -1
    }
}

/**
```
===================
CG_RegisterClients
===================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:2505
private func CG_RegisterClients() {
    var i: Int32

    CG_LoadingClient(cg.clientNum)
    CG_NewClientInfo(cg.clientNum, false)

    i = 0
    while i < MAX_CLIENTS {
        var clientInfo: String

        if cg.clientNum == i {
            i += 1
            continue
        }

        clientInfo = CG_ConfigString(CS_PLAYERS + i)
        if clientInfo.isEmpty {
            i += 1
            continue
        }
        CG_LoadingClient(i)
        CG_NewClientInfo(i, false)
        i += 1
    }
    CG_BuildSpectatorString()
}

/**
```
=================
CG_ConfigString
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:2535
func CG_ConfigString(_ index: Int32) -> String {
    if index < 0 || index >= MAX_CONFIGSTRINGS {
        CG_Error("CG_ConfigString: bad index: %i", index)
    }
    return String(cgs.gameState.stringDataBuffer[cgs.gameState.stringOffsets[index]...])
}

/**
```
======================
CG_StartMusic

======================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:2550
func CG_StartMusic(_ bForceStart: Bool) {
    var s = TextCursor()
    var parm1 = CharBuf(64)
    var parm2 = CharBuf(64)

    // start the background music
    s = TextCursor(CharBuf(CG_ConfigString(CS_MUSIC)))
    Q_strncpyz(&parm1, COM_Parse(&s), Int32((parm1).count))
    Q_strncpyz(&parm2, COM_Parse(&s), Int32((parm2).count))

    trap_S_StartBackgroundTrack(String(parm1), String(parm2), !bForceStart)
}

/// Source: oracle/codemp/cgame/cg_main.c:2563
func CG_GetMenuBuffer(_ filename: String) -> String? {
    let len: Int32
    var f: fileHandle_t = 0
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var buf = CharBuf(32768)

    len = trap_FS_FOpenFile(filename, &f, FS_READ)
    if f == 0 {
        trap_Print(va(S_COLOR_RED + "menu file not found: %s, using default\n", filename))
        return nil
    }
    if len >= MAX_MENUFILE {
        trap_Print(va(S_COLOR_RED + "menu file too large: %s is %i, max allowed is %i", filename, len, MAX_MENUFILE))
        trap_FS_FCloseFile(f)
        return nil
    }

    trap_FS_Read(&buf, len, f)
    buf[len] = 0
    trap_FS_FCloseFile(f)

    return String(buf)
}

//
// ==============================
// new hud stuff ( mission pack )
// ==============================
//
/// Source: oracle/codemp/cgame/cg_main.c:2592
func CG_Asset_Parse(_ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        if Q_stricmp(token.string, "{") != 0 {
            return false
        }

        while 1 != 0 {
            if trap_PC_ReadToken(handle, token) == 0 {
                return false
            }

            if Q_stricmp(token.string, "}") == 0 {
                return true
            }

            // font
            if Q_stricmp(token.string, "font") == 0 {
                var pointSize: Int32 = 0
                if trap_PC_ReadToken(handle, token) == 0 || !PC_Int_Parse(handle, &pointSize) {
                    return false
                }

                //			cgDC.registerFont(token.string, pointSize, &cgDC.Assets.textFont);
                cgDC.Assets.qhMediumFont = cgDC.runRegisterFont(token.string)
                continue
            }

            // smallFont
            if Q_stricmp(token.string, "smallFont") == 0 {
                var pointSize: Int32 = 0
                if trap_PC_ReadToken(handle, token) == 0 || !PC_Int_Parse(handle, &pointSize) {
                    return false
                }
                //			cgDC.registerFont(token.string, pointSize, &cgDC.Assets.smallFont);
                cgDC.Assets.qhSmallFont = cgDC.runRegisterFont(token.string)
                continue
            }

            // smallFont
            if Q_stricmp(token.string, "small2Font") == 0 {
                var pointSize: Int32 = 0
                if trap_PC_ReadToken(handle, token) == 0 || !PC_Int_Parse(handle, &pointSize) {
                    return false
                }
                //			cgDC.registerFont(token.string, pointSize, &cgDC.Assets.smallFont);
                cgDC.Assets.qhSmall2Font = cgDC.runRegisterFont(token.string)
                continue
            }

            // font
            if Q_stricmp(token.string, "bigfont") == 0 {
                var pointSize: Int32 = 0
                if trap_PC_ReadToken(handle, token) == 0 || !PC_Int_Parse(handle, &pointSize) {
                    return false
                }
                //			cgDC.registerFont(token.string, pointSize, &cgDC.Assets.bigFont);
                cgDC.Assets.qhBigFont = cgDC.runRegisterFont(token.string)
                continue
            }

            // gradientbar
            if Q_stricmp(token.string, "gradientbar") == 0 {
                if trap_PC_ReadToken(handle, token) == 0 {
                    return false
                }
                cgDC.Assets.gradientBar = trap_R_RegisterShaderNoMip(token.string)
                continue
            }

            // enterMenuSound
            if Q_stricmp(token.string, "menuEnterSound") == 0 {
                if trap_PC_ReadToken(handle, token) == 0 {
                    return false
                }
                cgDC.Assets.menuEnterSound = trap_S_RegisterSound(token.string)
                continue
            }

            // exitMenuSound
            if Q_stricmp(token.string, "menuExitSound") == 0 {
                if trap_PC_ReadToken(handle, token) == 0 {
                    return false
                }
                cgDC.Assets.menuExitSound = trap_S_RegisterSound(token.string)
                continue
            }

            // itemFocusSound
            if Q_stricmp(token.string, "itemFocusSound") == 0 {
                if trap_PC_ReadToken(handle, token) == 0 {
                    return false
                }
                cgDC.Assets.itemFocusSound = trap_S_RegisterSound(token.string)
                continue
            }

            // menuBuzzSound
            if Q_stricmp(token.string, "menuBuzzSound") == 0 {
                if trap_PC_ReadToken(handle, token) == 0 {
                    return false
                }
                cgDC.Assets.menuBuzzSound = trap_S_RegisterSound(token.string)
                continue
            }

            if Q_stricmp(token.string, "cursor") == 0 {
                var cursorStr: String? = nil
                if !PC_String_Parse(handle, &cursorStr) {
                    return false
                }
                cgDC.Assets.cursorStr = cursorStr
                cgDC.Assets.cursor = trap_R_RegisterShaderNoMip(cgDC.Assets.cursorStr!)
                continue
            }

            if Q_stricmp(token.string, "fadeClamp") == 0 {
                if !PC_Float_Parse(handle, &cgDC.Assets.fadeClamp) {
                    return false
                }
                continue
            }

            if Q_stricmp(token.string, "fadeCycle") == 0 {
                if !PC_Int_Parse(handle, &cgDC.Assets.fadeCycle) {
                    return false
                }
                continue
            }

            if Q_stricmp(token.string, "fadeAmount") == 0 {
                if !PC_Float_Parse(handle, &cgDC.Assets.fadeAmount) {
                    return false
                }
                continue
            }

            if Q_stricmp(token.string, "shadowX") == 0 {
                if !PC_Float_Parse(handle, &cgDC.Assets.shadowX) {
                    return false
                }
                continue
            }

            if Q_stricmp(token.string, "shadowY") == 0 {
                if !PC_Float_Parse(handle, &cgDC.Assets.shadowY) {
                    return false
                }
                continue
            }

            if Q_stricmp(token.string, "shadowColor") == 0 {
                // PC_Color_Parse takes a vec4_t, and the view holds `shadowColor` as a Slots, so the call fills a copy that stores back.
                var shadowColor = vec4_t(cgDC.Assets.shadowColor[0], cgDC.Assets.shadowColor[1], cgDC.Assets.shadowColor[2], cgDC.Assets.shadowColor[3])
                let parsed = PC_Color_Parse(handle, &shadowColor)
                cgDC.Assets.shadowColor[0] = shadowColor[0]
                cgDC.Assets.shadowColor[1] = shadowColor[1]
                cgDC.Assets.shadowColor[2] = shadowColor[2]
                cgDC.Assets.shadowColor[3] = shadowColor[3]
                if !parsed {
                    return false
                }
                cgDC.Assets.shadowFadeClamp = cgDC.Assets.shadowColor[3]
                continue
            }
        }
        return false // bk001204 - why not?
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:2753
func CG_ParseMenu(_ menuFile: String) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = PcToken.scratch { token -> Bool in
        var handle: Int32 = 0

        handle = trap_PC_LoadSource(menuFile)
        if handle == 0 {
            handle = trap_PC_LoadSource("ui/testhud.menu")
        }
        if handle == 0 {
            return true
        }

        while 1 != 0 {
            if trap_PC_ReadToken(handle, token) == 0 {
                break
            }

            //if ( Q_stricmp( token, "{" ) ) {
            //	Com_Printf( "Missing { in menu file\n" );
            //	break;
            //}

            //if ( menuCount == MAX_MENUS ) {
            //	Com_Printf( "Too many menus!\n" );
            //	break;
            //}

            if token.stringBuffer[0] == Int32(ascii: "}") {
                break
            }

            if Q_stricmp(token.string, "assetGlobalDef") == 0 {
                if CG_Asset_Parse(handle) {
                    continue
                } else {
                    break
                }
            }


            if Q_stricmp(token.string, "menudef") == 0 {
                // start a new menu
                Menu_New(handle)
            }
        }
        trap_PC_FreeSource(handle)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:2800
func CG_Load_Menu(_ p: inout JKAShared.TextCursor) -> Bool {
    var token: String

    token = COM_ParseExt(&p, true)

    if CharBuf(token)[0] != Int32(ascii: "{") {
        return false
    }

    while 1 != 0 {
        token = COM_ParseExt(&p, true)

        if Q_stricmp(token, "}") == 0 {
            return true
        }

        if token.isEmpty {
            return false
        }

        CG_ParseMenu(token)
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_main.c:2829
private func CG_OwnerDrawHandleKey(_ ownerDraw: Int32, _ flags: Int32, _ special: inout Float, _ key: Int32) -> Bool {
    return false
}

/// Source: oracle/codemp/cgame/cg_main.c:2834
private func CG_FeederCount(_ feederID: Float) -> Int32 {
    var i: Int32
    var count: Int32
    count = 0
    if feederID == FEEDER_REDTEAM_LIST {
        i = 0
        while i < cg.numScores {
            if cg.scores[i].team == TEAM_RED {
                count += 1
            }
            i += 1
        }
    } else if feederID == FEEDER_BLUETEAM_LIST {
        i = 0
        while i < cg.numScores {
            if cg.scores[i].team == TEAM_BLUE {
                count += 1
            }
            i += 1
        }
    } else if feederID == FEEDER_SCOREBOARD {
        return cg.numScores
    }
    return count
}

/// Source: oracle/codemp/cgame/cg_main.c:2856
func CG_SetScoreSelection(_ p: MenuDef?) {
    let menu: MenuDef? = p
    let ps: PlayerState? = cg.snap!.ps
    var i: Int32
    var red: Int32
    var blue: Int32
    blue = 0
    red = blue
    i = 0
    while i < cg.numScores {
        if cg.scores[i].team == TEAM_RED {
            red += 1
        } else if cg.scores[i].team == TEAM_BLUE {
            blue += 1
        }
        if ps!.clientNum == cg.scores[i].client {
            cg.selectedScore = i
        }
        i += 1
    }

    if menu == nil {
        // just interested in setting the selected score
        return
    }

    if cgs.gametype >= GT_TEAM {
        var feeder: Int32 = FEEDER_REDTEAM_LIST
        i = red
        if cg.scores[cg.selectedScore].team == TEAM_BLUE {
            feeder = FEEDER_BLUETEAM_LIST
            i = blue
        }
        Menu_SetFeederSelection(menu!, feeder, i, nil)
    } else {
        Menu_SetFeederSelection(menu!, FEEDER_SCOREBOARD, cg.selectedScore, nil)
    }
}

// FIXME: might need to cache this info
/// Source: oracle/codemp/cgame/cg_main.c:2891
private func CG_InfoFromScoreIndex(_ index: Int32, _ team: Int32, _ scoreIndex: inout Int32) -> ClientInfo? {
    var i: Int32
    var count: Int32
    if cgs.gametype >= GT_TEAM {
        count = 0
        i = 0
        while i < cg.numScores {
            if cg.scores[i].team == team {
                if count == index {
                    scoreIndex = i
                    return cgs.clientinfo[cg.scores[i].client]
                }
                count += 1
            }
            i += 1
        }
    }
    scoreIndex = index
    return cgs.clientinfo[cg.scores[index].client]
}

/// Source: oracle/codemp/cgame/cg_main.c:2909
private func CG_FeederItemText(_ feederID: Float, _ index: Int32, _ column: Int32, _ handle1: Slots<qhandle_t>?, _ handle2: Slots<qhandle_t>?, _ handle3: Slots<qhandle_t>?) -> String {
    var item: Gitem?
    var scoreIndex: Int32 = 0
    var info: ClientInfo? = nil
    var team: Int32 = -1
    var sp: Score? = nil

    handle1![0] = -1
    handle2![0] = -1
    handle3![0] = -1

    if feederID == FEEDER_REDTEAM_LIST {
        team = TEAM_RED
    } else if feederID == FEEDER_BLUETEAM_LIST {
        team = TEAM_BLUE
    }

    info = CG_InfoFromScoreIndex(index, team, &scoreIndex)
    sp = cg.scores[scoreIndex]

    if info != nil && info!.infoValid {
        switch column {
        case 0:
            if (info!.powerups & (1 << PW_NEUTRALFLAG)) != 0 {
                item = BG_FindItemForPowerup(PW_NEUTRALFLAG)
                handle1![0] = cg_items[bg_itemlist.index(of: item!)].icon
            } else if (info!.powerups & (1 << PW_REDFLAG)) != 0 {
                item = BG_FindItemForPowerup(PW_REDFLAG)
                handle1![0] = cg_items[bg_itemlist.index(of: item!)].icon
            } else if (info!.powerups & (1 << PW_BLUEFLAG)) != 0 {
                item = BG_FindItemForPowerup(PW_BLUEFLAG)
                handle1![0] = cg_items[bg_itemlist.index(of: item!)].icon
            } else {
                /*
                if ( info->botSkill > 0 && info->botSkill <= 5 ) {
                *handle1 = cgs.media.botSkillShaders[ info->botSkill - 1 ];
                } else if ( info->handicap < 100 ) {
                return va("%i", info->handicap );
                }
                */
            }

        case 1:
            if team == -1 {
                return ""
            } else {
                handle1![0] = CG_StatusHandle(info!.teamTask)
            }

        case 2:
            if (cg.snap!.ps.stats[STAT_CLIENTS_READY] & (1 << sp!.client)) != 0 {
                return "Ready"
            }
            if team == -1 {
                if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL {
                    return va("%i/%i", info!.wins, info!.losses)
                } else if info!.infoValid && info!.team == TEAM_SPECTATOR {
                    return "Spectator"
                } else {
                    return ""
                }
            } else {
                if info!.teamLeader {
                    return "Leader"
                }
            }

        case 3:
            return info!.name

        case 4:
            return va("%i", info!.score)

        case 5:
            return va("%4i", sp!.time)

        case 6:
            if sp!.ping == -1 {
                return "connecting"
            }
            return va("%4i", sp!.ping)

        default:
            break
        }
    }

    return ""
}

/// Source: oracle/codemp/cgame/cg_main.c:2996
private func CG_FeederItemImage(_ feederID: Float, _ index: Int32) -> JKAShared.qhandle_t {
    return 0
}

/// Source: oracle/codemp/cgame/cg_main.c:3000
private func CG_FeederSelection(_ feederID: Float, _ index: Int32, _ item: ItemDef) -> Bool {
    if cgs.gametype >= GT_TEAM {
        var i: Int32
        var count: Int32
        let team: Int32 = (feederID == FEEDER_REDTEAM_LIST) ? TEAM_RED : TEAM_BLUE
        count = 0
        i = 0
        while i < cg.numScores {
            if cg.scores[i].team == team {
                if index == count {
                    cg.selectedScore = i
                }
                count += 1
            }
            i += 1
        }
    } else {
        cg.selectedScore = index
    }

    return true
}

/// Source: oracle/codemp/cgame/cg_main.c:3020
private func CG_Cvar_Get(_ cvar: String) -> Float {
    var buff = CharBuf(128)
    buff.zero()
    strcpy(&buff, trap_Cvar_VariableStringBuffer(cvar, Int32((buff).count)))
    return Float(atof(buff))
}

/// Source: oracle/codemp/cgame/cg_main.c:3027
func CG_Text_PaintWithCursor(_ x: Float, _ y: Float, _ scale: Float, _ color: JKAShared.vec4_t, _ text: String, _ cursorPos: Int32, _ cursor: CChar, _ limit: Int32, _ style: Int32, _ iMenuFont: Int32) {
    CG_Text_Paint(x, y, scale, color, text, 0, limit, style, iMenuFont)
}

/// Source: oracle/codemp/cgame/cg_main.c:3031
private func CG_OwnerDrawWidth(_ ownerDraw: Int32, _ scale: Float) -> Int32 {
    switch ownerDraw {
    case CG_GAME_TYPE:
        return CG_Text_Width(CG_GameTypeString(), scale, FONT_MEDIUM)

    case CG_GAME_STATUS:
        return CG_Text_Width(CG_GetGameStatusText(), scale, FONT_MEDIUM)

    case CG_KILLER:
        return CG_Text_Width(CG_GetKillerText(), scale, FONT_MEDIUM)

    case CG_RED_NAME:
        return CG_Text_Width(DEFAULT_REDTEAM_NAME, scale, FONT_MEDIUM)

    case CG_BLUE_NAME:
        return CG_Text_Width(DEFAULT_BLUETEAM_NAME, scale, FONT_MEDIUM)

    default:
        break
    }
    return 0
}

/// Source: oracle/codemp/cgame/cg_main.c:3053
private func CG_PlayCinematic(_ name: String, _ x: Float, _ y: Float, _ w: Float, _ h: Float) -> Int32 {
    return trap_CIN_PlayCinematic(name, Int32(x), Int32(y), Int32(w), Int32(h), CIN_loop)
}

/// Source: oracle/codemp/cgame/cg_main.c:3057
private func CG_StopCinematic(_ handle: Int32) {
    trap_CIN_StopCinematic(handle)
}

/// Source: oracle/codemp/cgame/cg_main.c:3061
private func CG_DrawCinematic(_ handle: Int32, _ x: Float, _ y: Float, _ w: Float, _ h: Float) {
    trap_CIN_SetExtents(handle, Int32(x), Int32(y), Int32(w), Int32(h))
    trap_CIN_DrawCinematic(handle)
}

/// Source: oracle/codemp/cgame/cg_main.c:3066
private func CG_RunCinematicFrame(_ handle: Int32) {
    trap_CIN_RunCinematic(handle)
}

/**
```
=================
CG_LoadMenus();

=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3076
func CG_LoadMenus(_ menuFile: String) {
    var token: String
    var p = TextCursor()
    var len: Int32
    var f: fileHandle_t = 0
    var buf = CharBuf(4096)

    len = trap_FS_FOpenFile(menuFile, &f, FS_READ)

    if f == 0 {
        trap_Print(va(S_COLOR_RED + "menu file not found: %s, using default\n", menuFile))

        len = trap_FS_FOpenFile("ui/jahud.txt", &f, FS_READ)
        if f == 0 {
            trap_Print(va(S_COLOR_RED + "default menu file not found: ui/hud.txt, unable to continue!\n", menuFile))
        }
    }

    if len >= MAX_MENUDEFFILE {
        trap_Print(va(S_COLOR_RED + "menu file too large: %s is %i, max allowed is %i", menuFile, len, MAX_MENUDEFFILE))
        trap_FS_FCloseFile(f)
        return
    }

    trap_FS_Read(&buf, len, f)
    buf[len] = 0
    trap_FS_FCloseFile(f)

    p = TextCursor(buf)

    while 1 != 0 {
        token = COM_ParseExt(&p, true)
        if token.isEmpty || CharBuf(token)[0] == Int32(ascii: "}") {
            break
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }

        if Q_stricmp(token, "loadmenu") == 0 {
            if CG_Load_Menu(&p) {
                continue
            } else {
                break
            }
        }
    }

    //Com_Printf("UI menu load time = %d milli seconds\n", cgi_Milliseconds() - start);
}

/**
```
=================
CG_LoadHudMenu();

=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3145
func CG_LoadHudMenu() {
    var hudSet: String

    cgDC.registerShaderNoMip = DisplayContextDefThunks.trap_R_RegisterShaderNoMip
    cgDC.setColor = DisplayContextDefThunks.trap_R_SetColor
    cgDC.drawHandlePic = CG_DrawPic
    cgDC.drawStretchPic = trap_R_DrawStretchPic
    cgDC.drawText = DisplayContextDefThunks.CG_Text_Paint
    cgDC.textWidth = DisplayContextDefThunks.CG_Text_Width
    cgDC.textHeight = DisplayContextDefThunks.CG_Text_Height
    cgDC.registerModel = DisplayContextDefThunks.trap_R_RegisterModel
    cgDC.modelBounds = DisplayContextDefThunks.trap_R_ModelBounds
    cgDC.fillRect = DisplayContextDefThunks.CG_FillRect
    cgDC.drawRect = DisplayContextDefThunks.CG_DrawRect
    cgDC.drawSides = CG_DrawSides
    cgDC.drawTopBottom = CG_DrawTopBottom
    cgDC.clearScene = trap_R_ClearScene
    cgDC.addRefEntityToScene = DisplayContextDefThunks.trap_R_AddRefEntityToScene
    cgDC.renderScene = DisplayContextDefThunks.trap_R_RenderScene
    cgDC.RegisterFont = DisplayContextDefThunks.trap_R_RegisterFont
    cgDC.Font_StrLenPixels = DisplayContextDefThunks.trap_R_Font_StrLenPixels
    cgDC.Font_StrLenChars = DisplayContextDefThunks.trap_R_Font_StrLenChars
    cgDC.Font_HeightPixels = trap_R_Font_HeightPixels
    cgDC.Font_DrawString = DisplayContextDefThunks.trap_R_Font_DrawString
    cgDC.Language_IsAsian = DisplayContextDefThunks.trap_Language_IsAsian
    cgDC.Language_UsesSpaces = DisplayContextDefThunks.trap_Language_UsesSpaces
    cgDC.AnyLanguage_ReadCharFromString = DisplayContextDefThunks.trap_AnyLanguage_ReadCharFromString
    cgDC.ownerDrawItem = DisplayContextDefThunks.CG_OwnerDraw
    cgDC.getValue = CG_GetValue
    cgDC.ownerDrawVisible = DisplayContextDefThunks.CG_OwnerDrawVisible
    cgDC.runScript = DisplayContextDefThunks.CG_RunMenuScript
    cgDC.deferScript = DisplayContextDefThunks.CG_DeferMenuScript
    cgDC.getTeamColor = DisplayContextDefThunks.CG_GetTeamColor
    cgDC.setCVar = DisplayContextDefThunks.trap_Cvar_Set
    cgDC.getCVarString = DisplayContextDefThunks.trap_Cvar_VariableStringBuffer
    cgDC.getCVarValue = DisplayContextDefThunks.CG_Cvar_Get
    cgDC.drawTextWithCursor = DisplayContextDefThunks.CG_Text_PaintWithCursor
    //cgDC.setOverstrikeMode = &trap_Key_SetOverstrikeMode;
    //cgDC.getOverstrikeMode = &trap_Key_GetOverstrikeMode;
    cgDC.startLocalSound = trap_S_StartLocalSound
    cgDC.ownerDrawHandleKey = DisplayContextDefThunks.CG_OwnerDrawHandleKey
    cgDC.feederCount = DisplayContextDefThunks.CG_FeederCount
    cgDC.feederItemImage = DisplayContextDefThunks.CG_FeederItemImage
    cgDC.feederItemText = DisplayContextDefThunks.CG_FeederItemText
    cgDC.feederSelection = DisplayContextDefThunks.CG_FeederSelection
    //cgDC.setBinding = &trap_Key_SetBinding;
    //cgDC.getBindingBuf = &trap_Key_GetBindingBuf;
    //cgDC.keynumToStringBuf = &trap_Key_KeynumToStringBuf;
    //cgDC.executeText = &trap_Cmd_ExecuteText;
    cgDC.Error = DisplayContextDefThunks.Com_Error
    cgDC.Print = DisplayContextDefThunks.Com_Printf
    cgDC.ownerDrawWidth = DisplayContextDefThunks.CG_OwnerDrawWidth
    //cgDC.Pause = &CG_Pause;
    cgDC.registerSound = DisplayContextDefThunks.trap_S_RegisterSound
    cgDC.startBackgroundTrack = DisplayContextDefThunks.trap_S_StartBackgroundTrack
    cgDC.stopBackgroundTrack = trap_S_StopBackgroundTrack
    cgDC.playCinematic = DisplayContextDefThunks.CG_PlayCinematic
    cgDC.stopCinematic = DisplayContextDefThunks.CG_StopCinematic
    cgDC.drawCinematic = DisplayContextDefThunks.CG_DrawCinematic
    cgDC.runCinematicFrame = DisplayContextDefThunks.CG_RunCinematicFrame

    Init_Display(cgDC)

    Menu_Reset()

    hudSet = cg_hudFiles.string
    if CharBuf(hudSet)[0] == 0 {
        hudSet = "ui/jahud.txt"
    }

    CG_LoadMenus(hudSet)
}

/// Source: oracle/codemp/cgame/cg_main.c:3221
func CG_AssetCache() {
    //if (Assets.textFont == NULL) {
    //  trap_R_RegisterFont("fonts/arial.ttf", 72, &Assets.textFont);
    //}
    //Assets.background = trap_R_RegisterShaderNoMip( ASSET_BACKGROUND );
    //Com_Printf("Menu Size: %i bytes\n", sizeof(Menus));
    cgDC.Assets.gradientBar = trap_R_RegisterShaderNoMip(ASSET_GRADIENTBAR)
    cgDC.Assets.fxBasePic = trap_R_RegisterShaderNoMip(ART_FX_BASE)
    cgDC.Assets.fxPic[0] = trap_R_RegisterShaderNoMip(ART_FX_RED)
    cgDC.Assets.fxPic[1] = trap_R_RegisterShaderNoMip(ART_FX_YELLOW)
    cgDC.Assets.fxPic[2] = trap_R_RegisterShaderNoMip(ART_FX_GREEN)
    cgDC.Assets.fxPic[3] = trap_R_RegisterShaderNoMip(ART_FX_TEAL)
    cgDC.Assets.fxPic[4] = trap_R_RegisterShaderNoMip(ART_FX_BLUE)
    cgDC.Assets.fxPic[5] = trap_R_RegisterShaderNoMip(ART_FX_CYAN)
    cgDC.Assets.fxPic[6] = trap_R_RegisterShaderNoMip(ART_FX_WHITE)
    cgDC.Assets.scrollBar = trap_R_RegisterShaderNoMip(ASSET_SCROLLBAR)
    cgDC.Assets.scrollBarArrowDown = trap_R_RegisterShaderNoMip(ASSET_SCROLLBAR_ARROWDOWN)
    cgDC.Assets.scrollBarArrowUp = trap_R_RegisterShaderNoMip(ASSET_SCROLLBAR_ARROWUP)
    cgDC.Assets.scrollBarArrowLeft = trap_R_RegisterShaderNoMip(ASSET_SCROLLBAR_ARROWLEFT)
    cgDC.Assets.scrollBarArrowRight = trap_R_RegisterShaderNoMip(ASSET_SCROLLBAR_ARROWRIGHT)
    cgDC.Assets.scrollBarThumb = trap_R_RegisterShaderNoMip(ASSET_SCROLL_THUMB)
    cgDC.Assets.sliderBar = trap_R_RegisterShaderNoMip(ASSET_SLIDER_BAR)
    cgDC.Assets.sliderThumb = trap_R_RegisterShaderNoMip(ASSET_SLIDER_THUMB)
}

// initialise the cg_entities structure - take into account the ghoul2 stl stuff in the active snap shots
/// Source: oracle/codemp/cgame/cg_main.c:3254
func CG_Init_CG() {
    cg.clear()
}

// initialise the cg_entities structure - take into account the ghoul2 stl stuff
/// Source: oracle/codemp/cgame/cg_main.c:3274
func CG_Init_CGents() {
    cg_entities.zero()
}

/// Source: oracle/codemp/cgame/cg_main.c:3281
func CG_InitItems() {
    cg_items.zero()
}

/// Source: oracle/codemp/cgame/cg_main.c:3286
func CG_TransitionPermanent() {
    var centIndex: Int32 = 0
    var i: Int32

    cg_numpermanents = 0
    i = 0
    while i < MAX_GENTITIES {
        if trap_GetDefaultState(i, cg_entities[centIndex].currentState) {
            cg_entities[centIndex].nextState.copy(from: cg_entities[centIndex].currentState)
            cg_entities[centIndex].lerpOrigin = cg_entities[centIndex].currentState.origin
            cg_entities[centIndex].lerpAngles = cg_entities[centIndex].currentState.angles
            cg_entities[centIndex].currentValid = true

            cg_permanents[cg_numpermanents] = cg_entities[centIndex]
            cg_numpermanents += 1
        }
        i += 1
        centIndex += 1
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:3313
func CG_StrPool_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    let giveThemThis: UnsafeMutableRawPointer

    if cg_strPoolSize + size >= MAX_CGSTRPOOL_SIZE {
        Com_Error(ERR_DROP, "You exceeded the cgame string pool size. Bad programmer!\n")
    }

    // AI: Raven returns a pointer into cg_strPool. Each call allocates one block that is never freed, as G_Alloc does.
    giveThemThis = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 16)
    cg_strPoolSize += size

    //memset it for them, just to be nice.
    giveThemThis.initializeMemory(as: UInt8.self, repeating: 0, count: Int(size))

    return giveThemThis
}

/// Source: oracle/codemp/cgame/cg_main.c:3331
func CG_StrPool_Reset() {
    cg_strPoolSize = 0
}

/**
```
=============
CG_NewString

Builds a copy of the string, translating \n to real linefeeds
so message texts can be multi-line
=============
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3344
func CG_NewString(_ string: String) -> String {
    let string = CharBuf(string)
    let newb: UnsafeMutableRawPointer
    var new_p: Int32
    var i: Int32
    let l: Int32

    l = strlen(string) + 1

    newb = CG_StrPool_Alloc(l)

    new_p = 0

    // turn \n into a real linefeed
    i = 0
    while i < l {
        if string[i] == Int32(ascii: "\\") && i < l - 1 {
            i += 1
            if string[i] == Int32(ascii: "n") {
                newb[byte: new_p] = Int32(ascii: "\n")
                new_p += 1
            } else {
                newb[byte: new_p] = Int32(ascii: "\\")
                new_p += 1
            }
        } else {
            newb[byte: new_p] = string[i]
            new_p += 1
        }
        i += 1
    }

    return cString(at: newb)
}

/// Source: oracle/codemp/cgame/cg_main.c:3418
func CG_CreateSkyPortalFromSpawnEnt(_ ent: CgSpawnEnt) {
    if ent.onlyFogHere != 0 {
        //only globally fog INSIDE the sky portal
        cg_noFogOutsidePortal = true
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:3432
func CG_CreateSkyOriFromSpawnEnt(_ ent: CgSpawnEnt) {
    cg_skyOri = true
    cg_skyOriPos = ent.origin
    cg_skyOriScale = ent.fScale
}

//get brush box extents, note this does not care about bsp instances.
/// Source: oracle/codemp/cgame/cg_main.c:3440
func CG_CreateBrushEntData(_ ent: CgSpawnEnt) {
    trap_R_ModelBounds(trap_R_RegisterModel(ent.model!), &ent.mins, &ent.maxs)
}

/// Source: oracle/codemp/cgame/cg_main.c:3445
func CG_CreateWeatherZoneFromSpawnEnt(_ ent: CgSpawnEnt) {
    CG_CreateBrushEntData(ent)
    trap_WE_AddWeatherZone(ent.mins, ent.maxs)
}

//create a new cgame-only model
/// Source: oracle/codemp/cgame/cg_main.c:3452
func CG_CreateModelFromSpawnEnt(_ ent: CgSpawnEnt) {
    let modelIndex: Int32
    var RefEnt: RefEntity?
    var mins = vec3_t()
    var maxs = vec3_t()
    var radiusIndex: Int32 = 0
    var zOffIndex: Int32 = 0

    if NumMiscEnts >= MAX_MISC_ENTS {
        Com_Error(ERR_DROP, "Too many misc_model_static's on level, ask a programmer to raise the limit (currently %i), or take some out.", MAX_MISC_ENTS)
        return
    }

    if ent.model == nil || ent.model!.isEmpty {
        Com_Error(ERR_DROP, "misc_model_static with no model.")
        return
    }

    radiusIndex = NumMiscEnts
    zOffIndex = NumMiscEnts
    RefEnt = MiscEnts[NumMiscEnts]
    NumMiscEnts += 1

    modelIndex = trap_R_RegisterModel(ent.model!)
    if modelIndex == 0 {
        Com_Error(ERR_DROP, "misc_model_static failed to load model '%s'", ent.model!)
        return
    }

    RefEnt!.clear()
    RefEnt!.reType = RT_MODEL
    RefEnt!.hModel = modelIndex
    RefEnt!.frame = 0
    trap_R_ModelBounds(modelIndex, &mins, &maxs)
    RefEnt!.modelScale = ent.scale
    if ent.fScale != 0 {
        //use same scale on each axis then
        RefEnt!.modelScale[2] = ent.fScale
        RefEnt!.modelScale[1] = RefEnt!.modelScale[2]
        RefEnt!.modelScale[0] = RefEnt!.modelScale[1]
    }
    RefEnt!.origin = ent.origin
    RefEnt!.lightingOrigin = ent.origin

    mins = mins * ent.scale
    maxs = maxs * ent.scale
    Radius[radiusIndex] = Distance(mins, maxs)
    zOffset[zOffIndex] = ent.zoffset

    if ent.angle != 0 {
        //only yaw supplied...
        ent.angles[YAW] = ent.angle
    }

    AnglesToAxis(ent.angles, RefEnt!.axis)
    ScaleModelAxis(RefEnt!)
}

/**
```
====================
CG_AddSpawnVarToken
====================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3515
func CG_AddSpawnVarToken(_ string: String) -> String {
    let l: Int32
    var dest: Int32 = 0

    l = strlen(string)
    if cg_numSpawnVarChars + l + 1 > MAX_SPAWN_VARS_CHARS {
        CG_Error("CG_AddSpawnVarToken: MAX_SPAWN_VARS")
    }

    dest = cg_numSpawnVarChars
    strcpy(&cg_spawnVarChars, string, at: dest)

    cg_numSpawnVarChars += l + 1

    return String(cg_spawnVarChars[dest...])
}

/**
```
====================
CG_ParseSpawnVars

cgame version of G_ParseSpawnVars, for ents that don't really
need to take up an entity slot (e.g. static models) -rww
====================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3541
func CG_ParseSpawnVars() -> Bool {
    var keyname = CharBuf(1024)
    var com_token = CharBuf(1024)

    cg_numSpawnVars = 0
    cg_numSpawnVarChars = 0

    // parse the opening brace
    let filledTest = trap_GetEntityToken(Int32((com_token).count))
    strcpy(&com_token, filledTest.1)
    if !filledTest.0 {
        // end of spawn string
        return false
    }
    if com_token[0] != Int32(ascii: "{") {
        CG_Error("CG_ParseSpawnVars: found %s when expecting {", com_token)
    }

    // go through all the key / value pairs
    while 1 != 0 {
        // parse key
        let filledTest2 = trap_GetEntityToken(Int32((keyname).count))
        strcpy(&keyname, filledTest2.1)
        if !filledTest2.0 {
            CG_Error("CG_ParseSpawnVars: EOF without closing brace")
        }

        if keyname[0] == Int32(ascii: "}") {
            break
        }

        // parse value
        let filledTest3 = trap_GetEntityToken(Int32((com_token).count))
        strcpy(&com_token, filledTest3.1)
        if !filledTest3.0 {
            //this happens on mike's test level, I don't know why. Fixme?
            //CG_Error( "CG_ParseSpawnVars: EOF without closing brace" );
            break
        }

        if com_token[0] == Int32(ascii: "}") {
            CG_Error("CG_ParseSpawnVars: closing brace without data")
        }
        if cg_numSpawnVars == MAX_SPAWN_VARS {
            CG_Error("CG_ParseSpawnVars: MAX_SPAWN_VARS")
        }
        cg_spawnVars[cg_numSpawnVars][0] = CG_AddSpawnVarToken(String(keyname))
        cg_spawnVars[cg_numSpawnVars][1] = CG_AddSpawnVarToken(String(com_token))
        cg_numSpawnVars += 1
    }

    return true
}

/// Source: oracle/codemp/cgame/cg_main.c:3608
func CG_SpawnCGameEntFromVars() {
    var i: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    CgSpawnEnt.scratch { ent in

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        i = 0
        while i < cg_numSpawnVars {
            //shove all this stuff into our data structure used specifically for getting spawn info
            BG_ParseField(cg_spawnFields, cg_spawnVars[i][0], cg_spawnVars[i][1], UnsafeMutableRawPointer(ent.handle))
            i += 1
        }

        if ent.classname != nil && !ent.classname!.isEmpty {
            //we'll just stricmp this bastard, since there aren't all that many cgame-only things, and they all have special handling
            if Q_stricmp(ent.classname!, "worldspawn") == 0 {
                //I'd like some info off this guy
                if ent.fogstart != 0 {
                    //linear fog method
                    cg_linearFogOverride = ent.fogstart
                }
                //get radarRange off of worldspawn
                if ent.radarrange != 0 {
                    //linear fog method
                    cg_radarRange = ent.radarrange
                }
            } else if Q_stricmp(ent.classname!, "misc_model_static") == 0 {
                //we've got us a static model
                CG_CreateModelFromSpawnEnt(ent)
            } else if Q_stricmp(ent.classname!, "misc_skyportal_orient") == 0 {
                //a sky portal orientation point
                CG_CreateSkyOriFromSpawnEnt(ent)
            } else if Q_stricmp(ent.classname!, "misc_skyportal") == 0 {
                //might as well parse this thing cgame side for the extra info I want out of it
                CG_CreateSkyPortalFromSpawnEnt(ent)
            } else if Q_stricmp(ent.classname!, "misc_weather_zone") == 0 {
                //might as well parse this thing cgame side for the extra info I want out of it
                CG_CreateWeatherZoneFromSpawnEnt(ent)
            }
        }

        //reset the string pool for the next entity, if there is one
        CG_StrPool_Reset()
    }
}

/**
```
==============
CG_SpawnCGameOnlyEnts

Parses entity string data for cgame-only entities, that we can throw away on
the server and never even bother sending. -rww
==============
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3664
func CG_SpawnCGameOnlyEnts() {
    //make sure it is reset
    trap_GetEntityToken(nil, -1)

    if !CG_ParseSpawnVars() {
        //first one is gonna be the world spawn
        CG_Error("no entities for cgame parse")
    } else {
        //parse the world spawn info we want
        CG_SpawnCGameEntFromVars()
    }

    while CG_ParseSpawnVars() {
        //now run through the whole list, and look for things we care about cgame-side
        CG_SpawnCGameEntFromVars()
    }
}

/**
```
=================
CG_Init

Called after every level change or subsystem restart
Will perform callbacks to make the loading info screen update.
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3704
func CG_Init(_ serverMessageNum: Int32, _ serverCommandSequence: Int32, _ clientNum: Int32) {
    var item: Gitem?
    var buf = CharBuf(64)
    var s: String
    var i: Int32 = 0

    BG_InitAnimsets() //clear it out

    trap_CG_RegisterSharedMemory(cg.sharedBuffer)

    //Load external vehicle data
    BG_VehicleLoadParms()

    // clear everything
    /*
    Ghoul2 Insert Start
    */

    //	memset( cg_entities, 0, sizeof( cg_entities ) );
    CG_Init_CGents()
    // this is a No-No now we have stl vector classes in here.
    //	memset( &cg, 0, sizeof( cg ) );
    CG_Init_CG()
    CG_InitItems()

    //create the global jetpack instance
    CG_InitJetpackGhoul2()

    CG_PmoveClientPointerUpdate()

    /*
    Ghoul2 Insert End
    */

    //Load sabers.cfg data
    WP_SaberLoadParms()

    // this is kinda dumb as well, but I need to pre-load some fonts in order to have the text available
    //	to say I'm loading the assets.... which includes loading the fonts. So I'll set these up as reasonable
    //	defaults, then let the menu asset parser (which actually specifies the ingame fonts) load over them
    //	if desired during parse.  Dunno how legal it is to store in these cgDC things, but it causes no harm
    //	and even if/when they get overwritten they'll be legalised by the menu asset parser :-)
    //	CG_LoadFonts();
    cgDC.Assets.qhSmallFont = trap_R_RegisterFont("ocr_a")
    cgDC.Assets.qhMediumFont = trap_R_RegisterFont("ergoec")
    cgDC.Assets.qhBigFont = cgDC.Assets.qhMediumFont

    cgs.clear()
    cg_weapons.zero()

    cg.clientNum = clientNum

    cgs.processedSnapshotNum = serverMessageNum
    cgs.serverCommandSequence = serverCommandSequence

    cg.loadLCARSStage = 0

    cg.itemSelect = -1
    cg.forceSelect = -1

    // load a few needed things before we do any screen updates
    cgs.media.charsetShader = trap_R_RegisterShaderNoMip("gfx/2d/charsgrid_med")
    cgs.media.whiteShader = trap_R_RegisterShader("white")

    cgs.media.loadBarLED = trap_R_RegisterShaderNoMip("gfx/hud/load_tick")
    cgs.media.loadBarLEDCap = trap_R_RegisterShaderNoMip("gfx/hud/load_tick_cap")
    cgs.media.loadBarLEDSurround = trap_R_RegisterShaderNoMip("gfx/hud/mp_levelload")

    // Force HUD set up
    cg.forceHUDActive = true
    cg.forceHUDTotalFlashTime = 0
    cg.forceHUDNextFlashTime = 0

    i = WP_NONE + 1
    while i <= WP_BRYAR_OLD {
        item = BG_FindItemForWeapon(i)

        if item != nil && item!.icon != nil && !item!.icon!.isEmpty {
            cgs.media.weaponIcons[i] = trap_R_RegisterShaderNoMip(item!.icon!)
            cgs.media.weaponIcons_NA[i] = trap_R_RegisterShaderNoMip(va("%s_na", item!.icon!))
        } else {
            //make sure it is zero'd (default shader)
            cgs.media.weaponIcons[i] = 0
            cgs.media.weaponIcons_NA[i] = 0
        }
        i += 1
    }
    strcpy(&buf, trap_Cvar_VariableStringBuffer("com_buildscript", Int32((buf).count)))
    if atoi(buf) != 0 {
        trap_R_RegisterShaderNoMip("gfx/hud/w_icon_saberstaff")
        trap_R_RegisterShaderNoMip("gfx/hud/w_icon_duallightsaber")
    }
    i = 0

    // HUD artwork for cycling inventory,weapons and force powers
    cgs.media.weaponIconBackground = trap_R_RegisterShaderNoMip("gfx/hud/background")
    cgs.media.forceIconBackground = trap_R_RegisterShaderNoMip("gfx/hud/background_f")
    cgs.media.inventoryIconBackground = trap_R_RegisterShaderNoMip("gfx/hud/background_i")

    //rww - precache holdable item icons here
    while i < bg_numItems {
        if bg_itemlist[i].giType == IT_HOLDABLE {
            if bg_itemlist[i].icon != nil {
                cgs.media.invenIcons[bg_itemlist[i].giTag] = trap_R_RegisterShaderNoMip(bg_itemlist[i].icon!)
            } else {
                cgs.media.invenIcons[bg_itemlist[i].giTag] = 0
            }
        }

        i += 1
    }

    //rww - precache force power icons here
    i = 0

    while i < NUM_FORCE_POWERS {
        cgs.media.forcePowerIcons[i] = trap_R_RegisterShaderNoMip(HolocronIcons[i])

        i += 1
    }
    cgs.media.rageRecShader = trap_R_RegisterShaderNoMip("gfx/mp/f_icon_ragerec")


    //body decal shaders -rww
    cgs.media.bdecal_bodyburn1 = trap_R_RegisterShader("gfx/damage/bodyburnmark1")
    cgs.media.bdecal_saberglow = trap_R_RegisterShader("gfx/damage/saberglowmark")
    cgs.media.bdecal_burn1 = trap_R_RegisterShader("gfx/damage/bodybigburnmark1")
    cgs.media.mSaberDamageGlow = trap_R_RegisterShader("gfx/effects/saberDamageGlow")

    CG_RegisterCvars()

    CG_InitConsoleCommands()

    cg.weaponSelect = WP_BRYAR_PISTOL

    cgs.blueflag = -1 // For compatibily, default to unset for
    cgs.redflag = cgs.blueflag // For compatibily, default to unset for
    cgs.flagStatus = -1
    // old servers

    // get the rendering configuration from the client system
    trap_GetGlconfig(cgs.glconfig)
    cgs.screenXScale = Float(Double(cgs.glconfig.vidWidth) / 640.0)
    cgs.screenYScale = Float(Double(cgs.glconfig.vidHeight) / 480.0)

    // get the gamestate from the client system
    trap_GetGameState(cgs.gameState)

    CG_TransitionPermanent() //rwwRMG - added

    // check version
    s = CG_ConfigString(CS_GAME_VERSION)
    if strcmp(s, GAME_VERSION) != 0 {
        CG_Error("Client/Server game mismatch: %s/%s", GAME_VERSION, s)
    }

    s = CG_ConfigString(CS_LEVEL_START_TIME)
    cgs.levelStartTime = atoi(s)

    CG_ParseServerinfo()

    // load the new map
    //	CG_LoadingString( "collision map" );

    trap_CM_LoadMap(cgs.mapname, false)

    String_Init()

    cg.loading = true // force players to load instead of defer

    //make sure saber data is loaded before this! (so we can precache the appropriate hilts)
    CG_InitSiegeMode()

    CG_RegisterSounds()

    //	CG_LoadingString( "graphics" );

    CG_RegisterGraphics()

    //	CG_LoadingString( "clients" );

    CG_RegisterClients() // if low on memory, some clients will be deferred

    CG_AssetCache()
    CG_LoadHudMenu() // load new hud stuff

    cg.loading = false // future players will be deferred

    CG_InitLocalEntities()

    CG_InitMarkPolys()

    // remove the last loading update
    cg.infoScreenText = ""

    // Make sure we have update values (scores)
    CG_SetConfigValues()

    CG_StartMusic(false)

    //	CG_LoadingString( "Clearing light styles" );
    CG_ClearLightStyles()

    //	CG_LoadingString( "Creating automap data" );
    //init automap
    trap_R_InitWireframeAutomap()

    CG_LoadingString("")

    CG_ShaderStateChanged()

    trap_S_ClearLoopingSounds()

    trap_R_GetDistanceCull(&cg.distanceCull)

    //now get all the cgame only cents
    CG_SpawnCGameOnlyEnts()
}

//makes sure returned string is in localized format
/// Source: oracle/codemp/cgame/cg_main.c:3936
func CG_GetLocationString(_ loc: String) -> String {
    // Raven's static buffer keeps the result valid after the return, and a returned `String` is already a copy.
    var text = CharBuf(1024)

    if CharBuf(loc)[0] != Int32(ascii: "@") {
        //just a raw string
        return loc
    }

    strcpy(&text, trap_SP_GetStringTextString(String(loc.dropFirst()), Int32((text).count)).1)
    return String(text)
}

/// Source: oracle/codemp/cgame/cg_main.c:3951
func CG_DestroyAllGhoul2() {
    var i: Int32 = 0
    var j: Int32

    //	Com_Printf("... CGameside GHOUL2 Cleanup\n");
    while i < MAX_GENTITIES {
        //free all dynamically allocated npc client info structs and ghoul2 instances
        CG_KillCEntityG2(i)
        i += 1
    }

    //Clean the weapon instances
    CG_ShutDownG2Weapons()

    i = 0
    while i < MAX_ITEMS {
        //and now for items
        j = 0
        while j < MAX_ITEM_MODELS {
            if cg_items[i].g2Models[j] != nil && trap_G2_HaveWeGhoul2Models(cg_items[i].g2Models[j]) {
                trap_G2API_CleanGhoul2Models(&cg_items[i].g2Models[j])
                cg_items[i].g2Models[j] = nil
            }
            j += 1
        }
        i += 1
    }

    //Clean the global jetpack instance
    CG_CleanJetpackGhoul2()
}

/**
```
=================
CG_Shutdown

Called before every level change or subsystem restart
=================
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:3993
func CG_Shutdown() {
    BG_ClearAnimsets() //free all dynamic allocations made through the engine

    CG_DestroyAllGhoul2()

    //	Com_Printf("... FX System Cleanup\n");
    trap_FX_FreeSystem()
    trap_ROFF_Clean()

    if cgWeatherOverride != 0 {
        trap_R_WeatherContentsOverride(0) //rwwRMG - reset it engine-side
    }

    //reset weather
    trap_R_WorldEffectCommand("die")

    UI_CleanupGhoul2()
    //If there was any ghoul2 stuff in our side of the shared ui code, then remove it now.

    // some mods may need to do cleanup work here,
    // like closing files or archiving session data
}

/**
```
===============
CG_NextForcePower_f
===============
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:4023
func CG_NextForcePower_f() {
    var current: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Usercmd.scratch { cmd -> Bool in
        if cg.snap == nil {
            return true
        }

        if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
            return true
        }

        current = trap_GetCurrentCmdNumber()
        trap_GetUserCmd(current, cmd)
        if (cmd.buttons & BUTTON_USE) != 0 || CG_NoUseableForce() {
            CG_NextInventory_f()
            return true
        }

        if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
            return true
        }

        //	BG_CycleForce(&cg.snap->ps, 1);
        if cg.forceSelect != -1 {
            cg.snap!.ps.fd.forcePowerSelected = cg.forceSelect
        }

        BG_CycleForce(cg.snap!.ps, 1)

        if (cg.snap!.ps.fd.forcePowersKnown & (1 << cg.snap!.ps.fd.forcePowerSelected)) != 0 {
            cg.forceSelect = cg.snap!.ps.fd.forcePowerSelected
            cg.forceSelectTime = Float(cg.time)
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===============
CG_PrevForcePower_f
===============
```
*/
/// Source: oracle/codemp/cgame/cg_main.c:4070
func CG_PrevForcePower_f() {
    var current: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Usercmd.scratch { cmd -> Bool in
        if cg.snap == nil {
            return true
        }

        if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
            return true
        }

        current = trap_GetCurrentCmdNumber()
        trap_GetUserCmd(current, cmd)
        if (cmd.buttons & BUTTON_USE) != 0 || CG_NoUseableForce() {
            CG_PrevInventory_f()
            return true
        }

        if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
            return true
        }

        //	BG_CycleForce(&cg.snap->ps, -1);
        if cg.forceSelect != -1 {
            cg.snap!.ps.fd.forcePowerSelected = cg.forceSelect
        }

        BG_CycleForce(cg.snap!.ps, -1)

        if (cg.snap!.ps.fd.forcePowersKnown & (1 << cg.snap!.ps.fd.forcePowerSelected)) != 0 {
            cg.forceSelect = cg.snap!.ps.fd.forcePowerSelected
            cg.forceSelectTime = Float(cg.time)
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:4112
func CG_NextInventory_f() {
    if cg.snap == nil {
        return
    }

    if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
        return
    }

    if cg.itemSelect != -1 {
        cg.snap!.ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(cg.itemSelect, IT_HOLDABLE)
    }
    BG_CycleInven(cg.snap!.ps, 1)

    if cg.snap!.ps.stats[STAT_HOLDABLE_ITEM] != 0 {
        cg.itemSelect = bg_itemlist[cg.snap!.ps.stats[STAT_HOLDABLE_ITEM]].giTag
        cg.invenSelectTime = Float(cg.time)
    }
}

/// Source: oracle/codemp/cgame/cg_main.c:4142
func CG_PrevInventory_f() {
    if cg.snap == nil {
        return
    }

    if (cg.snap!.ps.pm_flags & PMF_FOLLOW) != 0 {
        return
    }

    if cg.predictedPlayerState.pm_type == PM_SPECTATOR {
        return
    }

    if cg.itemSelect != -1 {
        cg.snap!.ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(cg.itemSelect, IT_HOLDABLE)
    }
    BG_CycleInven(cg.snap!.ps, -1)

    if cg.snap!.ps.stats[STAT_HOLDABLE_ITEM] != 0 {
        cg.itemSelect = bg_itemlist[cg.snap!.ps.stats[STAT_HOLDABLE_ITEM]].giTag
        cg.invenSelectTime = Float(cg.time)
    }
}

/// One static per function this file stores in a `DisplayContextDef` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum DisplayContextDefThunks {
    /// Source: oracle/codemp/cgame/cg_main.c:3020
    static let CG_Cvar_Get: DisplayContextDefGetCVarValue = { JKAMP_CGameLogic.CG_Cvar_Get(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_main.c:3061
    static let CG_DrawCinematic: DisplayContextDefDrawCinematic = { JKAMP_CGameLogic.CG_DrawCinematic($0, $1, $2, $3, $4) }

    /// Source: oracle/codemp/cgame/cg_main.c:2834
    static let CG_FeederCount: DisplayContextDefFeederCount = { JKAMP_CGameLogic.CG_FeederCount($0) }

    /// Source: oracle/codemp/cgame/cg_main.c:2996
    static let CG_FeederItemImage: DisplayContextDefFeederItemImage = { JKAMP_CGameLogic.CG_FeederItemImage($0, $1) }

    /// Source: oracle/codemp/cgame/cg_main.c:2909
    static let CG_FeederItemText: DisplayContextDefFeederItemText = { feederID, index, column, handle1, handle2, handle3 in
        let text = JKAMP_CGameLogic.CG_FeederItemText(
            feederID,
            index,
            column,
            handle1.map { Slots<qhandle_t>(scalars: $0, count: 1) },
            handle2.map { Slots<qhandle_t>(scalars: $0, count: 1) },
            handle3.map { Slots<qhandle_t>(scalars: $0, count: 1) }
        )
        return ringText(text)
    }

    /// Source: oracle/codemp/cgame/cg_main.c:3000
    static let CG_FeederSelection: DisplayContextDefFeederSelection = { JKAMP_CGameLogic.CG_FeederSelection($0, $1, ItemDef(handle: $2!)) ? 1 : 0 }

    /// Source: oracle/codemp/cgame/cg_main.c:2829
    static let CG_OwnerDrawHandleKey: DisplayContextDefOwnerDrawHandleKey = { ownerDraw, flags, special, key in
        let slots = Slots<Float>(scalars: special!, count: 1)
        var value = slots[0]
        let handled = JKAMP_CGameLogic.CG_OwnerDrawHandleKey(ownerDraw, flags, &value, key)
        slots[0] = value
        return handled ? 1 : 0
    }

    /// Source: oracle/codemp/cgame/cg_main.c:3031
    static let CG_OwnerDrawWidth: DisplayContextDefOwnerDrawWidth = { JKAMP_CGameLogic.CG_OwnerDrawWidth($0, $1) }

    /// Source: oracle/codemp/cgame/cg_main.c:3053
    static let CG_PlayCinematic: DisplayContextDefPlayCinematic = { JKAMP_CGameLogic.CG_PlayCinematic(text(at: $0!), $1, $2, $3, $4) }

    /// Source: oracle/codemp/cgame/cg_main.c:3066
    static let CG_RunCinematicFrame: DisplayContextDefRunCinematicFrame = { JKAMP_CGameLogic.CG_RunCinematicFrame($0) }

    /// Source: oracle/codemp/cgame/cg_main.c:3057
    static let CG_StopCinematic: DisplayContextDefStopCinematic = { JKAMP_CGameLogic.CG_StopCinematic($0) }

    /// Source: oracle/codemp/cgame/cg_main.c:3027
    static let CG_Text_PaintWithCursor: DisplayContextDefDrawTextWithCursor = { x, y, scale, color, text, cursorPos, cursor, limit, style, iMenuFont in
        JKAMP_CGameLogic.CG_Text_PaintWithCursor(
            x,
            y,
            scale,
            vector4(at: color!),
            JKAMP_CGame.text(at: text!),
            cursorPos,
            cursor,
            limit,
            style,
            iMenuFont
        )
    }

    /// Source: oracle/codemp/cgame/cg_main.c:1234
    static let Com_Error: DisplayContextDefError = { JKAMP_CGameLogic.Com_Error($0, text(at: $1!)) }

    /// Source: oracle/codemp/cgame/cg_main.c:1245
    static let Com_Printf: DisplayContextDefPrint = { JKAMP_CGameLogic.Com_Printf(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_newDraw.c:876
    static let CG_RunMenuScript: DisplayContextDefRunScript = {
        let args = Slots<OpaquePointer?>(opaque: $0!, count: 1)
        let p = args[0]
        var cursor = TextCursor(CharBuf(text(at: p!)))
        JKAMP_CGameLogic.CG_RunMenuScript(&cursor)
        args[0] = cursor.offset.map { advanced(p!, by: $0) }
    }

    /// Source: oracle/codemp/cgame/cg_newDraw.c:879
    static let CG_DeferMenuScript: DisplayContextDefDeferScript = {
        let args = Slots<OpaquePointer?>(opaque: $0!, count: 1)
        let p = args[0]
        var cursor = TextCursor(CharBuf(text(at: p!)))
        let deferred = JKAMP_CGameLogic.CG_DeferMenuScript(&cursor)
        args[0] = cursor.offset.map { advanced(p!, by: $0) }
        return deferred ? 1 : 0
    }

    /// Source: oracle/codemp/cgame/cg_drawtools.c:24
    static let CG_DrawRect: DisplayContextDefDrawRect = { JKAMP_CGameLogic.CG_DrawRect($0, $1, $2, $3, $4, $5.map { vector4(at: $0) }) }

    /// Source: oracle/codemp/cgame/cg_drawtools.c:116
    static let CG_FillRect: DisplayContextDefFillRect = { JKAMP_CGameLogic.CG_FillRect($0, $1, $2, $3, $4.map { vector4(at: $0) }) }

    /// Source: oracle/codemp/cgame/cg_newDraw.c:884
    static let CG_GetTeamColor: DisplayContextDefGetTeamColor = { color in
        let slots = Slots<Float>(scalars: color!, count: 4)
        var value = vector4(at: color!)
        JKAMP_CGameLogic.CG_GetTeamColor(&value)
        slots[0] = value[0]
        slots[1] = value[1]
        slots[2] = value[2]
        slots[3] = value[3]
    }

    /// Source: oracle/codemp/cgame/cg_newDraw.c:562
    static let CG_OwnerDraw: DisplayContextDefOwnerDrawItem = { x, y, w, h, text_x, text_y, ownerDraw, ownerDrawFlags, align, special, scale, color, shader, textStyle, font in
        JKAMP_CGameLogic.CG_OwnerDraw(
            x,
            y,
            w,
            h,
            text_x,
            text_y,
            ownerDraw,
            ownerDrawFlags,
            align,
            special,
            scale,
            vector4(at: color!),
            shader,
            textStyle,
            font
        )
    }

    /// Source: oracle/codemp/cgame/cg_newDraw.c:123
    static let CG_OwnerDrawVisible: DisplayContextDefOwnerDrawVisible = { JKAMP_CGameLogic.CG_OwnerDrawVisible($0) ? 1 : 0 }

    /// Source: oracle/codemp/cgame/cg_draw.c:130
    static let CG_Text_Height: DisplayContextDefTextHeight = { JKAMP_CGameLogic.CG_Text_Height(text(at: $0!), $1, $2) }

    /// Source: oracle/codemp/cgame/cg_draw.c:138
    static let CG_Text_Paint: DisplayContextDefDrawText = { x, y, scale, color, text, adjust, limit, style, iMenuFont in
        JKAMP_CGameLogic.CG_Text_Paint(
            x,
            y,
            scale,
            vector4(at: color!),
            JKAMP_CGame.text(at: text!),
            adjust,
            limit,
            style,
            iMenuFont
        )
    }

    /// Source: oracle/codemp/cgame/cg_draw.c:123
    static let CG_Text_Width: DisplayContextDefTextWidth = { JKAMP_CGameLogic.CG_Text_Width(text(at: $0!), $1, $2) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:317
    static let trap_AnyLanguage_ReadCharFromString: DisplayContextDefAnyLanguage_ReadCharFromString = { psText, piAdvanceCount, pbIsTrailingPunctuation in
        let advance = Slots<Int32>(scalars: piAdvanceCount!, count: 1)
        var advanceCount = advance[0]
        var isTrailingPunctuation = false
        let letter = JKAMP_CGame.trap_AnyLanguage_ReadCharFromString(text(at: psText!), &advanceCount, &isTrailingPunctuation)
        advance[0] = advanceCount
        if let pbIsTrailingPunctuation {
            Slots<Int32>(scalars: pbIsTrailingPunctuation, count: 1)[0] = isTrailingPunctuation ? 1 : 0
        }
        return letter
    }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:58
    static let trap_Cvar_Set: DisplayContextDefSetCVar = { JKAMP_CGame.trap_Cvar_Set(text(at: $0!), text(at: $1!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:62
    static let trap_Cvar_VariableStringBuffer: DisplayContextDefGetCVarString = { var_name, buffer, bufsize in
        let value = JKAMP_CGame.trap_Cvar_VariableStringBuffer(text(at: var_name!), bufsize)
        store(value, at: UnsafeMutableRawPointer(buffer!), capacity: Int(bufsize))
    }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:307
    static let trap_Language_IsAsian: DisplayContextDefLanguage_IsAsian = { JKAMP_CGame.trap_Language_IsAsian() ? 1 : 0 }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:312
    static let trap_Language_UsesSpaces: DisplayContextDefLanguage_UsesSpaces = { JKAMP_CGame.trap_Language_UsesSpaces() ? 1 : 0 }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:331
    static let trap_R_AddRefEntityToScene: DisplayContextDefAddRefEntityToScene = { JKAMP_CGame.trap_R_AddRefEntityToScene(RefEntity(handle: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:302
    static let trap_R_Font_DrawString: DisplayContextDefFont_DrawString = { ox, oy, text, rgba, setIndex, iCharLimit, scale in
        JKAMP_CGame.trap_R_Font_DrawString(
            ox,
            oy,
            JKAMP_CGame.text(at: text!),
            rgba.map { vector4(at: $0) },
            setIndex,
            iCharLimit,
            scale
        )
    }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:292
    static let trap_R_Font_StrLenChars: DisplayContextDefFont_StrLenChars = { JKAMP_CGame.trap_R_Font_StrLenChars(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:287
    static let trap_R_Font_StrLenPixels: DisplayContextDefFont_StrLenPixels = { JKAMP_CGame.trap_R_Font_StrLenPixels(text(at: $0!), $1, $2) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:373
    static let trap_R_ModelBounds: DisplayContextDefModelBounds = { model, mins, maxs in
        let minsSlots = Slots<Float>(scalars: mins!, count: 3)
        let maxsSlots = Slots<Float>(scalars: maxs!, count: 3)
        var minsValue = vector(at: mins!)
        var maxsValue = vector(at: maxs!)
        JKAMP_CGame.trap_R_ModelBounds(model, &minsValue, &maxsValue)
        minsSlots[0] = minsValue[0]
        minsSlots[1] = minsValue[1]
        minsSlots[2] = minsValue[2]
        maxsSlots[0] = maxsValue[0]
        maxsSlots[1] = maxsValue[1]
        maxsSlots[2] = maxsValue[2]
    }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:282
    static let trap_R_RegisterFont: DisplayContextDefRegisterFont = { JKAMP_CGame.trap_R_RegisterFont(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:266
    static let trap_R_RegisterModel: DisplayContextDefRegisterModel = { JKAMP_CGame.trap_R_RegisterModel(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:278
    static let trap_R_RegisterShaderNoMip: DisplayContextDefRegisterShaderNoMip = { JKAMP_CGame.trap_R_RegisterShaderNoMip(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:360
    static let trap_R_RenderScene: DisplayContextDefRenderScene = { JKAMP_CGame.trap_R_RenderScene(Refdef(handle: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:364
    static let trap_R_SetColor: DisplayContextDefSetColor = { JKAMP_CGame.trap_R_SetColor($0.map { vector4(at: $0) }) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:229
    static let trap_S_RegisterSound: DisplayContextDefRegisterSound = { JKAMP_CGame.trap_S_RegisterSound(text(at: $0!)) }

    /// Source: oracle/codemp/cgame/cg_syscalls.c:233
    static let trap_S_StartBackgroundTrack: DisplayContextDefStartBackgroundTrack = { JKAMP_CGame.trap_S_StartBackgroundTrack(text(at: $0!), text(at: $1!), $2 != 0) }
}
