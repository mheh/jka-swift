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

/// Source: oracle/codemp/cgame/cg_main.c:113
// Raven wrote: int cgWeatherOverride = 0
let cgWeatherOverride: Int32 = { () -> Int32 in portMissing("cgWeatherOverride", source: "oracle/codemp/cgame/cg_main.c:113") }()

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
// Raven wrote: static int cvarTableSize = sizeof( cvarTable ) / sizeof( cvarTable[0] )
let cvarTableSize: Int32 = { () -> Int32 in portMissing("cvarTableSize", source: "oracle/codemp/cgame/cg_main.c:1055") }()

/// Source: oracle/codemp/cgame/cg_main.c:3309
let MAX_CGSTRPOOL_SIZE = 32768 as Int32

/// Source: oracle/codemp/cgame/cg_main.c:3310
var cg_strPoolSize: Int32 {
    get { world.variables.cg_strPoolSize }
    set { world.variables.cg_strPoolSize = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3311
var cg_strPool: [JKAShared.byte] {
    get { world.variables.cg_strPool }
    set { world.variables.cg_strPool = newValue }
}

/// Source: oracle/codemp/cgame/cg_main.c:3393
// TODO: Port global cg_spawnFields
// Raven wrote: BG_field_t cg_spawnFields[]
// No view for `BG_field_t`, a struct Raven defines inside a .c file.

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
    // TODO: Port CG_NoUseableForce
    portMissing("CG_NoUseableForce", source: "oracle/codemp/cgame/cg_main.c:159")
}

/// Source: oracle/codemp/cgame/cg_main.c:190
// Raven wrote: int vmMain( int command, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10, int arg11 )
// Not ported: the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5.

/// Source: oracle/codemp/cgame/cg_main.c:362
private func C_PointContents() -> Int32 {
    // TODO: Port C_PointContents
    portMissing("C_PointContents", source: "oracle/codemp/cgame/cg_main.c:362")
}

/// Source: oracle/codemp/cgame/cg_main.c:369
private func C_GetLerpOrigin() {
    // TODO: Port C_GetLerpOrigin
    portMissing("C_GetLerpOrigin", source: "oracle/codemp/cgame/cg_main.c:369")
}

/// Source: oracle/codemp/cgame/cg_main.c:376
private func C_GetLerpData() {
    // TODO: Port C_GetLerpData
    portMissing("C_GetLerpData", source: "oracle/codemp/cgame/cg_main.c:376")
}

/// Source: oracle/codemp/cgame/cg_main.c:408
private func C_Trace() {
    // TODO: Port C_Trace
    portMissing("C_Trace", source: "oracle/codemp/cgame/cg_main.c:408")
}

/// Source: oracle/codemp/cgame/cg_main.c:415
private func C_G2Trace() {
    // TODO: Port C_G2Trace
    portMissing("C_G2Trace", source: "oracle/codemp/cgame/cg_main.c:415")
}

/// Source: oracle/codemp/cgame/cg_main.c:422
private func C_G2Mark() {
    // TODO: Port C_G2Mark
    portMissing("C_G2Mark", source: "oracle/codemp/cgame/cg_main.c:422")
}

/// Source: oracle/codemp/cgame/cg_main.c:445
private func CG_DebugBoxLines(_ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ duration: Int32) {
    // TODO: Port CG_DebugBoxLines
    portMissing("CG_DebugBoxLines", source: "oracle/codemp/cgame/cg_main.c:445")
}

//handle ragdoll callbacks, for events and debugging -rww
/// Source: oracle/codemp/cgame/cg_main.c:508
private func CG_RagCallback(_ callType: Int32) -> Int32 {
    // TODO: Port CG_RagCallback
    portMissing("CG_RagCallback", source: "oracle/codemp/cgame/cg_main.c:508")
}

/// Source: oracle/codemp/cgame/cg_main.c:570
private func C_ImpactMark() {
    // TODO: Port C_ImpactMark
    portMissing("C_ImpactMark", source: "oracle/codemp/cgame/cg_main.c:570")
}

/// Source: oracle/codemp/cgame/cg_main.c:582
func CG_MiscEnt() {
    // TODO: Port CG_MiscEnt
    portMissing("CG_MiscEnt", source: "oracle/codemp/cgame/cg_main.c:582")
}

/// Source: oracle/codemp/cgame/cg_main.c:624
func CG_DrawMiscEnts() {
    // TODO: Port CG_DrawMiscEnts
    portMissing("CG_DrawMiscEnts", source: "oracle/codemp/cgame/cg_main.c:624")
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
    // TODO: Port CG_RegisterCvars
    portMissing("CG_RegisterCvars", source: "oracle/codemp/cgame/cg_main.c:1062")
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
    // TODO: Port CG_ForceModelChange
    portMissing("CG_ForceModelChange", source: "oracle/codemp/cgame/cg_main.c:1135")
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
    // TODO: Port CG_UpdateCvars
    portMissing("CG_UpdateCvars", source: "oracle/codemp/cgame/cg_main.c:1157")
}

/// Source: oracle/codemp/cgame/cg_main.c:1189
func CG_CrosshairPlayer() -> Int32 {
    // TODO: Port CG_CrosshairPlayer
    portMissing("CG_CrosshairPlayer", source: "oracle/codemp/cgame/cg_main.c:1189")
}

/// Source: oracle/codemp/cgame/cg_main.c:1202
func CG_LastAttacker() -> Int32 {
    // TODO: Port CG_LastAttacker
    portMissing("CG_LastAttacker", source: "oracle/codemp/cgame/cg_main.c:1202")
}

/// Source: oracle/codemp/cgame/cg_main.c:1209
func CG_Printf(_ msg: String, _ args: any JKAShared.FormatArg...) {
    // TODO: Port CG_Printf
    portMissing("CG_Printf", source: "oracle/codemp/cgame/cg_main.c:1209")
}

/// Source: oracle/codemp/cgame/cg_main.c:1220
func CG_Error(_ msg: String, _ args: any JKAShared.FormatArg...) -> Never {
    // TODO: Port CG_Error
    portMissing("CG_Error", source: "oracle/codemp/cgame/cg_main.c:1220")
}

/// Source: oracle/codemp/cgame/cg_main.c:1234
func Com_Error(_ level: Int32, _ error: String, _ args: any JKAShared.FormatArg...) -> Never {
    // TODO: Port Com_Error
    portMissing("Com_Error", source: "oracle/codemp/cgame/cg_main.c:1234")
}

/// Source: oracle/codemp/cgame/cg_main.c:1245
func Com_Printf(_ msg: String, _ args: any JKAShared.FormatArg...) {
    // TODO: Port Com_Printf
    portMissing("Com_Printf", source: "oracle/codemp/cgame/cg_main.c:1245")
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
    // TODO: Port CG_Argv
    portMissing("CG_Argv", source: "oracle/codemp/cgame/cg_main.c:1263")
}

/// Source: oracle/codemp/cgame/cg_main.c:1276
func BG_GetTime() -> Int32 {
    // TODO: Port BG_GetTime
    portMissing("BG_GetTime", source: "oracle/codemp/cgame/cg_main.c:1276")
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
    // TODO: Port CG_RegisterItemSounds
    portMissing("CG_RegisterItemSounds", source: "oracle/codemp/cgame/cg_main.c:1289")
}

/// Source: oracle/codemp/cgame/cg_main.c:1356
private func CG_AS_Register() {
    // TODO: Port CG_AS_Register
    portMissing("CG_AS_Register", source: "oracle/codemp/cgame/cg_main.c:1356")
}

//a global weather effect (rain, snow, etc)
/// Source: oracle/codemp/cgame/cg_main.c:1395
func CG_ParseWeatherEffect(_ str: String) {
    // TODO: Port CG_ParseWeatherEffect
    portMissing("CG_ParseWeatherEffect", source: "oracle/codemp/cgame/cg_main.c:1395")
}

/// Source: oracle/codemp/cgame/cg_main.c:1403
func CG_ParseSiegeState(_ str: String) {
    // TODO: Port CG_ParseSiegeState
    portMissing("CG_ParseSiegeState", source: "oracle/codemp/cgame/cg_main.c:1403")
}

/// Source: oracle/codemp/cgame/cg_main.c:1456
private func CG_RegisterSounds() {
    // TODO: Port CG_RegisterSounds
    portMissing("CG_RegisterSounds", source: "oracle/codemp/cgame/cg_main.c:1456")
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
    // TODO: Port CG_RegisterEffects
    portMissing("CG_RegisterEffects", source: "oracle/codemp/cgame/cg_main.c:1867")
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
    // TODO: Port CG_RegisterGraphics
    portMissing("CG_RegisterGraphics", source: "oracle/codemp/cgame/cg_main.c:1919")
}

/// Source: oracle/codemp/cgame/cg_main.c:2429
func CG_GetStringEdString(_ refSection: String, _ refName: String?) -> String {
    // TODO: Port CG_GetStringEdString
    portMissing("CG_GetStringEdString", source: "oracle/codemp/cgame/cg_main.c:2429")
}

/// Source: oracle/codemp/cgame/cg_main.c:2442
func CG_SiegeCountCvars() {
    // TODO: Port CG_SiegeCountCvars
    portMissing("CG_SiegeCountCvars", source: "oracle/codemp/cgame/cg_main.c:2442")
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
    // TODO: Port CG_BuildSpectatorString
    portMissing("CG_BuildSpectatorString", source: "oracle/codemp/cgame/cg_main.c:2480")
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
    // TODO: Port CG_RegisterClients
    portMissing("CG_RegisterClients", source: "oracle/codemp/cgame/cg_main.c:2505")
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
    // TODO: Port CG_ConfigString
    portMissing("CG_ConfigString", source: "oracle/codemp/cgame/cg_main.c:2535")
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
    // TODO: Port CG_StartMusic
    portMissing("CG_StartMusic", source: "oracle/codemp/cgame/cg_main.c:2550")
}

/// Source: oracle/codemp/cgame/cg_main.c:2563
func CG_GetMenuBuffer(_ filename: String) -> String? {
    // TODO: Port CG_GetMenuBuffer
    portMissing("CG_GetMenuBuffer", source: "oracle/codemp/cgame/cg_main.c:2563")
}

//
// ==============================
// new hud stuff ( mission pack )
// ==============================
//
/// Source: oracle/codemp/cgame/cg_main.c:2592
func CG_Asset_Parse(_ handle: Int32) -> Bool {
    // TODO: Port CG_Asset_Parse
    portMissing("CG_Asset_Parse", source: "oracle/codemp/cgame/cg_main.c:2592")
}

/// Source: oracle/codemp/cgame/cg_main.c:2753
func CG_ParseMenu(_ menuFile: String) {
    // TODO: Port CG_ParseMenu
    portMissing("CG_ParseMenu", source: "oracle/codemp/cgame/cg_main.c:2753")
}

/// Source: oracle/codemp/cgame/cg_main.c:2800
func CG_Load_Menu(_ p: inout JKAShared.TextCursor) -> Bool {
    // TODO: Port CG_Load_Menu
    portMissing("CG_Load_Menu", source: "oracle/codemp/cgame/cg_main.c:2800")
}

/// Source: oracle/codemp/cgame/cg_main.c:2829
private func CG_OwnerDrawHandleKey(_ ownerDraw: Int32, _ flags: Int32, _ special: inout Float, _ key: Int32) -> Bool {
    // TODO: Port CG_OwnerDrawHandleKey
    portMissing("CG_OwnerDrawHandleKey", source: "oracle/codemp/cgame/cg_main.c:2829")
}

/// Source: oracle/codemp/cgame/cg_main.c:2834
private func CG_FeederCount(_ feederID: Float) -> Int32 {
    // TODO: Port CG_FeederCount
    portMissing("CG_FeederCount", source: "oracle/codemp/cgame/cg_main.c:2834")
}

/// Source: oracle/codemp/cgame/cg_main.c:2856
func CG_SetScoreSelection(_ p: OpaquePointer?) {
    // TODO: Port CG_SetScoreSelection
    portMissing("CG_SetScoreSelection", source: "oracle/codemp/cgame/cg_main.c:2856")
}

// FIXME: might need to cache this info
/// Source: oracle/codemp/cgame/cg_main.c:2891
private func CG_InfoFromScoreIndex(_ index: Int32, _ team: Int32, _ scoreIndex: inout Int32) -> ClientInfo? {
    // TODO: Port CG_InfoFromScoreIndex
    portMissing("CG_InfoFromScoreIndex", source: "oracle/codemp/cgame/cg_main.c:2891")
}

/// Source: oracle/codemp/cgame/cg_main.c:2909
private func CG_FeederItemText(_ feederID: Float, _ index: Int32, _ column: Int32, _ handle1: Slots<qhandle_t>?, _ handle2: Slots<qhandle_t>?, _ handle3: Slots<qhandle_t>?) -> String {
    // TODO: Port CG_FeederItemText
    portMissing("CG_FeederItemText", source: "oracle/codemp/cgame/cg_main.c:2909")
}

/// Source: oracle/codemp/cgame/cg_main.c:2996
private func CG_FeederItemImage(_ feederID: Float, _ index: Int32) -> JKAShared.qhandle_t {
    // TODO: Port CG_FeederItemImage
    portMissing("CG_FeederItemImage", source: "oracle/codemp/cgame/cg_main.c:2996")
}

/// Source: oracle/codemp/cgame/cg_main.c:3000
private func CG_FeederSelection(_ feederID: Float, _ index: Int32, _ item: ItemDef) -> Bool {
    // TODO: Port CG_FeederSelection
    portMissing("CG_FeederSelection", source: "oracle/codemp/cgame/cg_main.c:3000")
}

/// Source: oracle/codemp/cgame/cg_main.c:3020
private func CG_Cvar_Get(_ cvar: String) -> Float {
    // TODO: Port CG_Cvar_Get
    portMissing("CG_Cvar_Get", source: "oracle/codemp/cgame/cg_main.c:3020")
}

/// Source: oracle/codemp/cgame/cg_main.c:3027
func CG_Text_PaintWithCursor(_ x: Float, _ y: Float, _ scale: Float, _ color: JKAShared.vec4_t, _ text: String, _ cursorPos: Int32, _ cursor: CChar, _ limit: Int32, _ style: Int32, _ iMenuFont: Int32) {
    // TODO: Port CG_Text_PaintWithCursor
    portMissing("CG_Text_PaintWithCursor", source: "oracle/codemp/cgame/cg_main.c:3027")
}

/// Source: oracle/codemp/cgame/cg_main.c:3031
private func CG_OwnerDrawWidth(_ ownerDraw: Int32, _ scale: Float) -> Int32 {
    // TODO: Port CG_OwnerDrawWidth
    portMissing("CG_OwnerDrawWidth", source: "oracle/codemp/cgame/cg_main.c:3031")
}

/// Source: oracle/codemp/cgame/cg_main.c:3053
private func CG_PlayCinematic(_ name: String, _ x: Float, _ y: Float, _ w: Float, _ h: Float) -> Int32 {
    // TODO: Port CG_PlayCinematic
    portMissing("CG_PlayCinematic", source: "oracle/codemp/cgame/cg_main.c:3053")
}

/// Source: oracle/codemp/cgame/cg_main.c:3057
private func CG_StopCinematic(_ handle: Int32) {
    // TODO: Port CG_StopCinematic
    portMissing("CG_StopCinematic", source: "oracle/codemp/cgame/cg_main.c:3057")
}

/// Source: oracle/codemp/cgame/cg_main.c:3061
private func CG_DrawCinematic(_ handle: Int32, _ x: Float, _ y: Float, _ w: Float, _ h: Float) {
    // TODO: Port CG_DrawCinematic
    portMissing("CG_DrawCinematic", source: "oracle/codemp/cgame/cg_main.c:3061")
}

/// Source: oracle/codemp/cgame/cg_main.c:3066
private func CG_RunCinematicFrame(_ handle: Int32) {
    // TODO: Port CG_RunCinematicFrame
    portMissing("CG_RunCinematicFrame", source: "oracle/codemp/cgame/cg_main.c:3066")
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
    // TODO: Port CG_LoadMenus
    portMissing("CG_LoadMenus", source: "oracle/codemp/cgame/cg_main.c:3076")
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
    // TODO: Port CG_LoadHudMenu
    portMissing("CG_LoadHudMenu", source: "oracle/codemp/cgame/cg_main.c:3145")
}

/// Source: oracle/codemp/cgame/cg_main.c:3221
func CG_AssetCache() {
    // TODO: Port CG_AssetCache
    portMissing("CG_AssetCache", source: "oracle/codemp/cgame/cg_main.c:3221")
}

// initialise the cg_entities structure - take into account the ghoul2 stl stuff in the active snap shots
/// Source: oracle/codemp/cgame/cg_main.c:3254
func CG_Init_CG() {
    // TODO: Port CG_Init_CG
    portMissing("CG_Init_CG", source: "oracle/codemp/cgame/cg_main.c:3254")
}

// initialise the cg_entities structure - take into account the ghoul2 stl stuff
/// Source: oracle/codemp/cgame/cg_main.c:3274
func CG_Init_CGents() {
    // TODO: Port CG_Init_CGents
    portMissing("CG_Init_CGents", source: "oracle/codemp/cgame/cg_main.c:3274")
}

/// Source: oracle/codemp/cgame/cg_main.c:3281
func CG_InitItems() {
    // TODO: Port CG_InitItems
    portMissing("CG_InitItems", source: "oracle/codemp/cgame/cg_main.c:3281")
}

/// Source: oracle/codemp/cgame/cg_main.c:3286
func CG_TransitionPermanent() {
    // TODO: Port CG_TransitionPermanent
    portMissing("CG_TransitionPermanent", source: "oracle/codemp/cgame/cg_main.c:3286")
}

/// Source: oracle/codemp/cgame/cg_main.c:3313
func CG_StrPool_Alloc(_ size: Int32) -> String {
    // TODO: Port CG_StrPool_Alloc
    portMissing("CG_StrPool_Alloc", source: "oracle/codemp/cgame/cg_main.c:3313")
}

/// Source: oracle/codemp/cgame/cg_main.c:3331
func CG_StrPool_Reset() {
    // TODO: Port CG_StrPool_Reset
    portMissing("CG_StrPool_Reset", source: "oracle/codemp/cgame/cg_main.c:3331")
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
    // TODO: Port CG_NewString
    portMissing("CG_NewString", source: "oracle/codemp/cgame/cg_main.c:3344")
}

/// Source: oracle/codemp/cgame/cg_main.c:3418
func CG_CreateSkyPortalFromSpawnEnt(_ ent: CgSpawnEnt) {
    // TODO: Port CG_CreateSkyPortalFromSpawnEnt
    portMissing("CG_CreateSkyPortalFromSpawnEnt", source: "oracle/codemp/cgame/cg_main.c:3418")
}

/// Source: oracle/codemp/cgame/cg_main.c:3432
func CG_CreateSkyOriFromSpawnEnt(_ ent: CgSpawnEnt) {
    // TODO: Port CG_CreateSkyOriFromSpawnEnt
    portMissing("CG_CreateSkyOriFromSpawnEnt", source: "oracle/codemp/cgame/cg_main.c:3432")
}

//get brush box extents, note this does not care about bsp instances.
/// Source: oracle/codemp/cgame/cg_main.c:3440
func CG_CreateBrushEntData(_ ent: CgSpawnEnt) {
    // TODO: Port CG_CreateBrushEntData
    portMissing("CG_CreateBrushEntData", source: "oracle/codemp/cgame/cg_main.c:3440")
}

/// Source: oracle/codemp/cgame/cg_main.c:3445
func CG_CreateWeatherZoneFromSpawnEnt(_ ent: CgSpawnEnt) {
    // TODO: Port CG_CreateWeatherZoneFromSpawnEnt
    portMissing("CG_CreateWeatherZoneFromSpawnEnt", source: "oracle/codemp/cgame/cg_main.c:3445")
}

//create a new cgame-only model
/// Source: oracle/codemp/cgame/cg_main.c:3452
func CG_CreateModelFromSpawnEnt(_ ent: CgSpawnEnt) {
    // TODO: Port CG_CreateModelFromSpawnEnt
    portMissing("CG_CreateModelFromSpawnEnt", source: "oracle/codemp/cgame/cg_main.c:3452")
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
    // TODO: Port CG_AddSpawnVarToken
    portMissing("CG_AddSpawnVarToken", source: "oracle/codemp/cgame/cg_main.c:3515")
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
    // TODO: Port CG_ParseSpawnVars
    portMissing("CG_ParseSpawnVars", source: "oracle/codemp/cgame/cg_main.c:3541")
}

/// Source: oracle/codemp/cgame/cg_main.c:3608
func CG_SpawnCGameEntFromVars() {
    // TODO: Port CG_SpawnCGameEntFromVars
    portMissing("CG_SpawnCGameEntFromVars", source: "oracle/codemp/cgame/cg_main.c:3608")
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
    // TODO: Port CG_SpawnCGameOnlyEnts
    portMissing("CG_SpawnCGameOnlyEnts", source: "oracle/codemp/cgame/cg_main.c:3664")
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
    // TODO: Port CG_Init
    portMissing("CG_Init", source: "oracle/codemp/cgame/cg_main.c:3704")
}

//makes sure returned string is in localized format
/// Source: oracle/codemp/cgame/cg_main.c:3936
func CG_GetLocationString(_ loc: String) -> String {
    // TODO: Port CG_GetLocationString
    portMissing("CG_GetLocationString", source: "oracle/codemp/cgame/cg_main.c:3936")
}

/// Source: oracle/codemp/cgame/cg_main.c:3951
func CG_DestroyAllGhoul2() {
    // TODO: Port CG_DestroyAllGhoul2
    portMissing("CG_DestroyAllGhoul2", source: "oracle/codemp/cgame/cg_main.c:3951")
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
    // TODO: Port CG_Shutdown
    portMissing("CG_Shutdown", source: "oracle/codemp/cgame/cg_main.c:3993")
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
    // TODO: Port CG_NextForcePower_f
    portMissing("CG_NextForcePower_f", source: "oracle/codemp/cgame/cg_main.c:4023")
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
    // TODO: Port CG_PrevForcePower_f
    portMissing("CG_PrevForcePower_f", source: "oracle/codemp/cgame/cg_main.c:4070")
}

/// Source: oracle/codemp/cgame/cg_main.c:4112
func CG_NextInventory_f() {
    // TODO: Port CG_NextInventory_f
    portMissing("CG_NextInventory_f", source: "oracle/codemp/cgame/cg_main.c:4112")
}

/// Source: oracle/codemp/cgame/cg_main.c:4142
func CG_PrevInventory_f() {
    // TODO: Port CG_PrevInventory_f
    portMissing("CG_PrevInventory_f", source: "oracle/codemp/cgame/cg_main.c:4142")
}

/// One static per function this file stores in a `DisplayContextDef` callback field, so each has one address for the life of the module.
/// The thunks stand in this file, because the functions they call are private to it.
private enum DisplayContextDefThunks {
    /// Source: oracle/codemp/cgame/cg_main.c:3020
    // TODO: Port signature
    static let CG_Cvar_Get: DisplayContextDefGetCVarValue = { _ in portMissing("CG_Cvar_Get", source: "oracle/codemp/cgame/cg_main.c:3020") }

    /// Source: oracle/codemp/cgame/cg_main.c:3061
    static let CG_DrawCinematic: DisplayContextDefDrawCinematic = { JKAMP_CGameLogic.CG_DrawCinematic($0, $1, $2, $3, $4) }

    /// Source: oracle/codemp/cgame/cg_main.c:2834
    static let CG_FeederCount: DisplayContextDefFeederCount = { JKAMP_CGameLogic.CG_FeederCount($0) }

    /// Source: oracle/codemp/cgame/cg_main.c:2996
    static let CG_FeederItemImage: DisplayContextDefFeederItemImage = { JKAMP_CGameLogic.CG_FeederItemImage($0, $1) }

    /// Source: oracle/codemp/cgame/cg_main.c:2909
    // TODO: Port signature
    static let CG_FeederItemText: DisplayContextDefFeederItemText = { _, _, _, _, _, _ in portMissing("CG_FeederItemText", source: "oracle/codemp/cgame/cg_main.c:2909") }

    /// Source: oracle/codemp/cgame/cg_main.c:3000
    static let CG_FeederSelection: DisplayContextDefFeederSelection = { JKAMP_CGameLogic.CG_FeederSelection($0, $1, ItemDef(handle: $2!)) ? 1 : 0 }

    /// Source: oracle/codemp/cgame/cg_main.c:2829
    // TODO: Port signature
    static let CG_OwnerDrawHandleKey: DisplayContextDefOwnerDrawHandleKey = { _, _, _, _ in portMissing("CG_OwnerDrawHandleKey", source: "oracle/codemp/cgame/cg_main.c:2829") }

    /// Source: oracle/codemp/cgame/cg_main.c:3031
    static let CG_OwnerDrawWidth: DisplayContextDefOwnerDrawWidth = { JKAMP_CGameLogic.CG_OwnerDrawWidth($0, $1) }

    /// Source: oracle/codemp/cgame/cg_main.c:3053
    // TODO: Port signature
    static let CG_PlayCinematic: DisplayContextDefPlayCinematic = { _, _, _, _, _ in portMissing("CG_PlayCinematic", source: "oracle/codemp/cgame/cg_main.c:3053") }

    /// Source: oracle/codemp/cgame/cg_main.c:3066
    static let CG_RunCinematicFrame: DisplayContextDefRunCinematicFrame = { JKAMP_CGameLogic.CG_RunCinematicFrame($0) }

    /// Source: oracle/codemp/cgame/cg_main.c:3057
    static let CG_StopCinematic: DisplayContextDefStopCinematic = { JKAMP_CGameLogic.CG_StopCinematic($0) }

    /// Source: oracle/codemp/cgame/cg_main.c:3027
    // TODO: Port signature
    static let CG_Text_PaintWithCursor: DisplayContextDefDrawTextWithCursor = { _, _, _, _, _, _, _, _, _, _ in portMissing("CG_Text_PaintWithCursor", source: "oracle/codemp/cgame/cg_main.c:3027") }

    /// Source: oracle/codemp/cgame/cg_main.c:1234
    // TODO: Port signature
    static let Com_Error: DisplayContextDefError = { _, _ in portMissing("Com_Error", source: "oracle/codemp/cgame/cg_main.c:1234") }

    /// Source: oracle/codemp/cgame/cg_main.c:1245
    // TODO: Port signature
    static let Com_Printf: DisplayContextDefPrint = { _ in portMissing("Com_Printf", source: "oracle/codemp/cgame/cg_main.c:1245") }
}
