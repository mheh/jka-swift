import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_main.c:9
var level: Level { world.storage.level }

/// Source: oracle/codemp/game/g_main.c:11
var eventClearTime: Int32 {
    get { world.variables.eventClearTime }
    set { world.variables.eventClearTime = newValue }
}

/// Source: oracle/codemp/game/g_main.c:12
var navCalcPathTime: Int32 {
    get { world.variables.navCalcPathTime }
    set { world.variables.navCalcPathTime = newValue }
}

/// Source: oracle/codemp/game/g_main.c:15
var killPlayerTimer: Int32 {
    get { world.variables.killPlayerTimer }
    set { world.variables.killPlayerTimer = newValue }
}

/// Source: oracle/codemp/game/g_main.c:27
public var g_entities: Slots<Entity> { world.storage.g_entities }

/// Source: oracle/codemp/game/g_main.c:28
var g_clients: Slots<Client> { world.storage.g_clients }

/// Source: oracle/codemp/game/g_main.c:30
var gDuelExit: Bool {
    get { world.variables.gDuelExit }
    set { world.variables.gDuelExit = newValue }
}

/// Source: oracle/codemp/game/g_main.c:32
var g_trueJedi: JKAMP.VmCvar { world.storage.g_trueJedi }

/// Source: oracle/codemp/game/g_main.c:34
var g_gametype: JKAMP.VmCvar { world.storage.g_gametype }

/// Source: oracle/codemp/game/g_main.c:35
var g_MaxHolocronCarry: JKAMP.VmCvar { world.storage.g_MaxHolocronCarry }

/// Source: oracle/codemp/game/g_main.c:36
var g_ff_objectives: JKAMP.VmCvar { world.storage.g_ff_objectives }

/// Source: oracle/codemp/game/g_main.c:37
var g_autoMapCycle: JKAMP.VmCvar { world.storage.g_autoMapCycle }

/// Source: oracle/codemp/game/g_main.c:38
var g_dmflags: JKAMP.VmCvar { world.storage.g_dmflags }

/// Source: oracle/codemp/game/g_main.c:39
var g_maxForceRank: JKAMP.VmCvar { world.storage.g_maxForceRank }

/// Source: oracle/codemp/game/g_main.c:40
var g_forceBasedTeams: JKAMP.VmCvar { world.storage.g_forceBasedTeams }

/// Source: oracle/codemp/game/g_main.c:41
var g_privateDuel: JKAMP.VmCvar { world.storage.g_privateDuel }

/// Source: oracle/codemp/game/g_main.c:43
var g_allowNPC: JKAMP.VmCvar { world.storage.g_allowNPC }

/// Source: oracle/codemp/game/g_main.c:45
var g_armBreakage: JKAMP.VmCvar { world.storage.g_armBreakage }

/// Source: oracle/codemp/game/g_main.c:47
var g_saberLocking: JKAMP.VmCvar { world.storage.g_saberLocking }

/// Source: oracle/codemp/game/g_main.c:48
var g_saberLockFactor: JKAMP.VmCvar { world.storage.g_saberLockFactor }

/// Source: oracle/codemp/game/g_main.c:49
var g_saberTraceSaberFirst: JKAMP.VmCvar { world.storage.g_saberTraceSaberFirst }

/// Source: oracle/codemp/game/g_main.c:51
var d_saberKickTweak: JKAMP.VmCvar { world.storage.d_saberKickTweak }

/// Source: oracle/codemp/game/g_main.c:53
var d_powerDuelPrint: JKAMP.VmCvar { world.storage.d_powerDuelPrint }

/// Source: oracle/codemp/game/g_main.c:55
var d_saberGhoul2Collision: JKAMP.VmCvar { world.storage.d_saberGhoul2Collision }

/// Source: oracle/codemp/game/g_main.c:56
var g_saberBladeFaces: JKAMP.VmCvar { world.storage.g_saberBladeFaces }

/// Source: oracle/codemp/game/g_main.c:57
var d_saberAlwaysBoxTrace: JKAMP.VmCvar { world.storage.d_saberAlwaysBoxTrace }

/// Source: oracle/codemp/game/g_main.c:58
var d_saberBoxTraceSize: JKAMP.VmCvar { world.storage.d_saberBoxTraceSize }

/// Source: oracle/codemp/game/g_main.c:60
var d_siegeSeekerNPC: JKAMP.VmCvar { world.storage.d_siegeSeekerNPC }

/// Source: oracle/codemp/game/g_main.c:62
var g_debugMelee: JKAMP.VmCvar { world.storage.g_debugMelee }

/// Source: oracle/codemp/game/g_main.c:63
var g_stepSlideFix: JKAMP.VmCvar { world.storage.g_stepSlideFix }

/// Source: oracle/codemp/game/g_main.c:65
var g_noSpecMove: JKAMP.VmCvar { world.storage.g_noSpecMove }

/// Source: oracle/codemp/game/g_main.c:71
var d_perPlayerGhoul2: JKAMP.VmCvar { world.storage.d_perPlayerGhoul2 }

/// Source: oracle/codemp/game/g_main.c:73
var d_projectileGhoul2Collision: JKAMP.VmCvar { world.storage.d_projectileGhoul2Collision }

/// Source: oracle/codemp/game/g_main.c:75
var g_g2TraceLod: JKAMP.VmCvar { world.storage.g_g2TraceLod }

/// Source: oracle/codemp/game/g_main.c:77
var g_optvehtrace: JKAMP.VmCvar { world.storage.g_optvehtrace }

/// Source: oracle/codemp/game/g_main.c:79
var g_locationBasedDamage: JKAMP.VmCvar { world.storage.g_locationBasedDamage }

/// Source: oracle/codemp/game/g_main.c:81
var g_allowHighPingDuelist: JKAMP.VmCvar { world.storage.g_allowHighPingDuelist }

/// Source: oracle/codemp/game/g_main.c:83
var g_logClientInfo: JKAMP.VmCvar { world.storage.g_logClientInfo }

/// Source: oracle/codemp/game/g_main.c:85
var g_slowmoDuelEnd: JKAMP.VmCvar { world.storage.g_slowmoDuelEnd }

/// Source: oracle/codemp/game/g_main.c:87
var g_saberDamageScale: JKAMP.VmCvar { world.storage.g_saberDamageScale }

/// Source: oracle/codemp/game/g_main.c:89
var g_useWhileThrowing: JKAMP.VmCvar { world.storage.g_useWhileThrowing }

/// Source: oracle/codemp/game/g_main.c:91
var g_RMG: JKAMP.VmCvar { world.storage.g_RMG }

/// Source: oracle/codemp/game/g_main.c:93
var g_svfps: JKAMP.VmCvar { world.storage.g_svfps }

/// Source: oracle/codemp/game/g_main.c:95
var g_forceRegenTime: JKAMP.VmCvar { world.storage.g_forceRegenTime }

/// Source: oracle/codemp/game/g_main.c:96
var g_spawnInvulnerability: JKAMP.VmCvar { world.storage.g_spawnInvulnerability }

/// Source: oracle/codemp/game/g_main.c:97
var g_forcePowerDisable: JKAMP.VmCvar { world.storage.g_forcePowerDisable }

/// Source: oracle/codemp/game/g_main.c:98
var g_weaponDisable: JKAMP.VmCvar { world.storage.g_weaponDisable }

/// Source: oracle/codemp/game/g_main.c:99
var g_duelWeaponDisable: JKAMP.VmCvar { world.storage.g_duelWeaponDisable }

/// Source: oracle/codemp/game/g_main.c:100
var g_allowDuelSuicide: JKAMP.VmCvar { world.storage.g_allowDuelSuicide }

/// Source: oracle/codemp/game/g_main.c:101
var g_fraglimitVoteCorrection: JKAMP.VmCvar { world.storage.g_fraglimitVoteCorrection }

/// Source: oracle/codemp/game/g_main.c:102
var g_fraglimit: JKAMP.VmCvar { world.storage.g_fraglimit }

/// Source: oracle/codemp/game/g_main.c:103
var g_duel_fraglimit: JKAMP.VmCvar { world.storage.g_duel_fraglimit }

/// Source: oracle/codemp/game/g_main.c:104
var g_timelimit: JKAMP.VmCvar { world.storage.g_timelimit }

/// Source: oracle/codemp/game/g_main.c:105
var g_capturelimit: JKAMP.VmCvar { world.storage.g_capturelimit }

/// Source: oracle/codemp/game/g_main.c:106
var d_saberInterpolate: JKAMP.VmCvar { world.storage.d_saberInterpolate }

/// Source: oracle/codemp/game/g_main.c:107
var g_friendlyFire: JKAMP.VmCvar { world.storage.g_friendlyFire }

/// Source: oracle/codemp/game/g_main.c:108
var g_friendlySaber: JKAMP.VmCvar { world.storage.g_friendlySaber }

/// Source: oracle/codemp/game/g_main.c:109
var g_password: JKAMP.VmCvar { world.storage.g_password }

/// Source: oracle/codemp/game/g_main.c:110
var g_needpass: JKAMP.VmCvar { world.storage.g_needpass }

/// Source: oracle/codemp/game/g_main.c:111
var g_maxclients: JKAMP.VmCvar { world.storage.g_maxclients }

/// Source: oracle/codemp/game/g_main.c:112
var g_maxGameClients: JKAMP.VmCvar { world.storage.g_maxGameClients }

/// Source: oracle/codemp/game/g_main.c:113
var g_dedicated: JKAMP.VmCvar { world.storage.g_dedicated }

/// Source: oracle/codemp/game/g_main.c:114
var g_developer: JKAMP.VmCvar { world.storage.g_developer }

/// Source: oracle/codemp/game/g_main.c:115
var g_speed: JKAMP.VmCvar { world.storage.g_speed }

/// Source: oracle/codemp/game/g_main.c:116
var g_gravity: JKAMP.VmCvar { world.storage.g_gravity }

/// Source: oracle/codemp/game/g_main.c:117
var g_cheats: JKAMP.VmCvar { world.storage.g_cheats }

/// Source: oracle/codemp/game/g_main.c:118
var g_knockback: JKAMP.VmCvar { world.storage.g_knockback }

/// Source: oracle/codemp/game/g_main.c:119
var g_quadfactor: JKAMP.VmCvar { world.storage.g_quadfactor }

/// Source: oracle/codemp/game/g_main.c:120
var g_forcerespawn: JKAMP.VmCvar { world.storage.g_forcerespawn }

/// Source: oracle/codemp/game/g_main.c:121
var g_siegeRespawn: JKAMP.VmCvar { world.storage.g_siegeRespawn }

/// Source: oracle/codemp/game/g_main.c:122
var g_inactivity: JKAMP.VmCvar { world.storage.g_inactivity }

/// Source: oracle/codemp/game/g_main.c:123
var g_debugMove: JKAMP.VmCvar { world.storage.g_debugMove }

/// Source: oracle/codemp/game/g_main.c:125
var g_debugDamage: JKAMP.VmCvar { world.storage.g_debugDamage }

/// Source: oracle/codemp/game/g_main.c:127
var g_debugAlloc: JKAMP.VmCvar { world.storage.g_debugAlloc }

/// Source: oracle/codemp/game/g_main.c:128
var g_debugServerSkel: JKAMP.VmCvar { world.storage.g_debugServerSkel }

/// Source: oracle/codemp/game/g_main.c:129
var g_weaponRespawn: JKAMP.VmCvar { world.storage.g_weaponRespawn }

/// Source: oracle/codemp/game/g_main.c:130
var g_weaponTeamRespawn: JKAMP.VmCvar { world.storage.g_weaponTeamRespawn }

/// Source: oracle/codemp/game/g_main.c:131
var g_adaptRespawn: JKAMP.VmCvar { world.storage.g_adaptRespawn }

/// Source: oracle/codemp/game/g_main.c:132
var g_motd: JKAMP.VmCvar { world.storage.g_motd }

/// Source: oracle/codemp/game/g_main.c:133
var g_synchronousClients: JKAMP.VmCvar { world.storage.g_synchronousClients }

/// Source: oracle/codemp/game/g_main.c:134
var g_warmup: JKAMP.VmCvar { world.storage.g_warmup }

/// Source: oracle/codemp/game/g_main.c:135
var g_doWarmup: JKAMP.VmCvar { world.storage.g_doWarmup }

/// Source: oracle/codemp/game/g_main.c:136
var g_restarted: JKAMP.VmCvar { world.storage.g_restarted }

/// Source: oracle/codemp/game/g_main.c:137
var g_log: JKAMP.VmCvar { world.storage.g_log }

/// Source: oracle/codemp/game/g_main.c:138
var g_logSync: JKAMP.VmCvar { world.storage.g_logSync }

/// Source: oracle/codemp/game/g_main.c:139
var g_statLog: JKAMP.VmCvar { world.storage.g_statLog }

/// Source: oracle/codemp/game/g_main.c:140
var g_statLogFile: JKAMP.VmCvar { world.storage.g_statLogFile }

/// Source: oracle/codemp/game/g_main.c:141
var g_blood: JKAMP.VmCvar { world.storage.g_blood }

/// Source: oracle/codemp/game/g_main.c:142
var g_podiumDist: JKAMP.VmCvar { world.storage.g_podiumDist }

/// Source: oracle/codemp/game/g_main.c:143
var g_podiumDrop: JKAMP.VmCvar { world.storage.g_podiumDrop }

/// Source: oracle/codemp/game/g_main.c:144
var g_allowVote: JKAMP.VmCvar { world.storage.g_allowVote }

/// Source: oracle/codemp/game/g_main.c:145
var g_allowTeamVote: JKAMP.VmCvar { world.storage.g_allowTeamVote }

/// Source: oracle/codemp/game/g_main.c:146
var g_teamAutoJoin: JKAMP.VmCvar { world.storage.g_teamAutoJoin }

/// Source: oracle/codemp/game/g_main.c:147
var g_teamForceBalance: JKAMP.VmCvar { world.storage.g_teamForceBalance }

/// Source: oracle/codemp/game/g_main.c:148
var g_banIPs: JKAMP.VmCvar { world.storage.g_banIPs }

/// Source: oracle/codemp/game/g_main.c:149
var g_filterBan: JKAMP.VmCvar { world.storage.g_filterBan }

/// Source: oracle/codemp/game/g_main.c:150
var g_debugForward: JKAMP.VmCvar { world.storage.g_debugForward }

/// Source: oracle/codemp/game/g_main.c:151
var g_debugRight: JKAMP.VmCvar { world.storage.g_debugRight }

/// Source: oracle/codemp/game/g_main.c:152
var g_debugUp: JKAMP.VmCvar { world.storage.g_debugUp }

/// Source: oracle/codemp/game/g_main.c:153
var g_smoothClients: JKAMP.VmCvar { world.storage.g_smoothClients }

/// Source: oracle/codemp/game/g_main.c:156
var pmove_fixed: JKAMP.VmCvar { world.storage.pmove_fixed }

/// Source: oracle/codemp/game/g_main.c:157
var pmove_msec: JKAMP.VmCvar { world.storage.pmove_msec }

/// Source: oracle/codemp/game/g_main.c:160
var g_listEntity: JKAMP.VmCvar { world.storage.g_listEntity }

/// Source: oracle/codemp/game/g_main.c:163
var g_singlePlayer: JKAMP.VmCvar { world.storage.g_singlePlayer }

/// Source: oracle/codemp/game/g_main.c:164
var g_enableBreath: JKAMP.VmCvar { world.storage.g_enableBreath }

/// Source: oracle/codemp/game/g_main.c:165
var g_dismember: JKAMP.VmCvar { world.storage.g_dismember }

/// Source: oracle/codemp/game/g_main.c:166
var g_forceDodge: JKAMP.VmCvar { world.storage.g_forceDodge }

/// Source: oracle/codemp/game/g_main.c:167
var g_timeouttospec: JKAMP.VmCvar { world.storage.g_timeouttospec }

/// Source: oracle/codemp/game/g_main.c:169
var g_saberDmgVelocityScale: JKAMP.VmCvar { world.storage.g_saberDmgVelocityScale }

/// Source: oracle/codemp/game/g_main.c:170
var g_saberDmgDelay_Idle: JKAMP.VmCvar { world.storage.g_saberDmgDelay_Idle }

/// Source: oracle/codemp/game/g_main.c:171
var g_saberDmgDelay_Wound: JKAMP.VmCvar { world.storage.g_saberDmgDelay_Wound }

/// Source: oracle/codemp/game/g_main.c:173
var g_saberDebugPrint: JKAMP.VmCvar { world.storage.g_saberDebugPrint }

/// Source: oracle/codemp/game/g_main.c:175
var g_siegeTeamSwitch: JKAMP.VmCvar { world.storage.g_siegeTeamSwitch }

/// Source: oracle/codemp/game/g_main.c:177
var bg_fighterAltControl: JKAMP.VmCvar { world.storage.bg_fighterAltControl }

/// Source: oracle/codemp/game/g_main.c:178
var g_vehAutoAimLead: JKAMP.VmCvar { world.storage.g_vehAutoAimLead }

/// Source: oracle/codemp/game/g_main.c:179
var g_autoKickKillSpammers: JKAMP.VmCvar { world.storage.g_autoKickKillSpammers }

/// Source: oracle/codemp/game/g_main.c:180
var g_autoBanKillSpammers: JKAMP.VmCvar { world.storage.g_autoBanKillSpammers }

/// Source: oracle/codemp/game/g_main.c:181
var g_autoKickTKSpammers: JKAMP.VmCvar { world.storage.g_autoKickTKSpammers }

/// Source: oracle/codemp/game/g_main.c:182
var g_autoBanTKSpammers: JKAMP.VmCvar { world.storage.g_autoBanTKSpammers }

/// Source: oracle/codemp/game/g_main.c:185
var g_saberDebugBox: JKAMP.VmCvar { world.storage.g_saberDebugBox }

/// Source: oracle/codemp/game/g_main.c:189
var d_altRoutes: JKAMP.VmCvar { world.storage.d_altRoutes }

/// Source: oracle/codemp/game/g_main.c:190
var d_patched: JKAMP.VmCvar { world.storage.d_patched }

/// Source: oracle/codemp/game/g_main.c:192
var g_saberRealisticCombat: JKAMP.VmCvar { world.storage.g_saberRealisticCombat }

/// Source: oracle/codemp/game/g_main.c:193
var g_saberRestrictForce: JKAMP.VmCvar { world.storage.g_saberRestrictForce }

/// Source: oracle/codemp/game/g_main.c:194
var d_saberSPStyleDamage: JKAMP.VmCvar { world.storage.d_saberSPStyleDamage }

/// Source: oracle/codemp/game/g_main.c:195
var g_debugSaberLocks: JKAMP.VmCvar { world.storage.g_debugSaberLocks }

/// Source: oracle/codemp/game/g_main.c:196
var g_saberLockRandomNess: JKAMP.VmCvar { world.storage.g_saberLockRandomNess }

/// Source: oracle/codemp/game/g_main.c:198
var g_saberWallDamageScale: JKAMP.VmCvar { world.storage.g_saberWallDamageScale }

/// Source: oracle/codemp/game/g_main.c:200
var d_saberStanceDebug: JKAMP.VmCvar { world.storage.d_saberStanceDebug }

/// Source: oracle/codemp/game/g_main.c:202
var debugNPCAI: JKAMP.VmCvar { world.storage.debugNPCAI }

/// Source: oracle/codemp/game/g_main.c:203
var debugNPCFreeze: JKAMP.VmCvar { world.storage.debugNPCFreeze }

/// Source: oracle/codemp/game/g_main.c:204
var debugNPCAimingBeam: JKAMP.VmCvar { world.storage.debugNPCAimingBeam }

/// Source: oracle/codemp/game/g_main.c:205
var debugBreak: JKAMP.VmCvar { world.storage.debugBreak }

/// Source: oracle/codemp/game/g_main.c:206
var debugNoRoam: JKAMP.VmCvar { world.storage.debugNoRoam }

/// Source: oracle/codemp/game/g_main.c:207
var d_saberCombat: JKAMP.VmCvar { world.storage.d_saberCombat }

/// Source: oracle/codemp/game/g_main.c:208
var d_JediAI: JKAMP.VmCvar { world.storage.d_JediAI }

/// Source: oracle/codemp/game/g_main.c:209
var d_noGroupAI: JKAMP.VmCvar { world.storage.d_noGroupAI }

/// Source: oracle/codemp/game/g_main.c:210
var d_asynchronousGroupAI: JKAMP.VmCvar { world.storage.d_asynchronousGroupAI }

/// Source: oracle/codemp/game/g_main.c:211
var d_slowmodeath: JKAMP.VmCvar { world.storage.d_slowmodeath }

/// Source: oracle/codemp/game/g_main.c:212
var d_noIntermissionWait: JKAMP.VmCvar { world.storage.d_noIntermissionWait }

/// Source: oracle/codemp/game/g_main.c:214
var g_spskill: JKAMP.VmCvar { world.storage.g_spskill }

/// Source: oracle/codemp/game/g_main.c:217
var g_siegeTeam1: JKAMP.VmCvar { world.storage.g_siegeTeam1 }

/// Source: oracle/codemp/game/g_main.c:218
var g_siegeTeam2: JKAMP.VmCvar { world.storage.g_siegeTeam2 }

/// Source: oracle/codemp/game/g_main.c:220
var g_austrian: JKAMP.VmCvar { world.storage.g_austrian }

/// Source: oracle/codemp/game/g_main.c:222
var g_powerDuelStartHealth: JKAMP.VmCvar { world.storage.g_powerDuelStartHealth }

/// Source: oracle/codemp/game/g_main.c:223
var g_powerDuelEndHealth: JKAMP.VmCvar { world.storage.g_powerDuelEndHealth }

/// Source: oracle/codemp/game/g_main.c:227
var g_showDuelHealths: JKAMP.VmCvar { world.storage.g_showDuelHealths }

/// Source: oracle/codemp/game/g_main.c:230
/// Raven's data table, a hand property of `GameWorld`.
var gameCvarTable: [CvarTableRow] {
    get { world.gameCvarTable }
    set { world.gameCvarTable = newValue }
}

/// Source: oracle/codemp/game/g_main.c:478
/// Raven's count of `gameCvarTable`, which is the count of the hand array.
var gameCvarTableSize: Int32 { Int32(world.gameCvarTable.count) }

/// Source: oracle/codemp/game/g_main.c:881
public var gSharedBuffer: UnsafeMutableRawPointer { world.storage.gSharedBuffer }

/// Source: oracle/codemp/game/g_main.c:1427
var g_dontFrickinCheck: Bool {
    get { world.variables.g_dontFrickinCheck }
    set { world.variables.g_dontFrickinCheck = newValue }
}

/// Source: oracle/codemp/game/g_main.c:1691
var gQueueScoreMessage: Bool {
    get { world.variables.gQueueScoreMessage }
    set { world.variables.gQueueScoreMessage = newValue }
}

/// Source: oracle/codemp/game/g_main.c:1692
var gQueueScoreMessageTime: Int32 {
    get { world.variables.gQueueScoreMessageTime }
    set { world.variables.gQueueScoreMessageTime = newValue }
}

/// Source: oracle/codemp/game/g_main.c:1717
var g_noPDuelCheck: Bool {
    get { world.variables.g_noPDuelCheck }
    set { world.variables.g_noPDuelCheck = newValue }
}

/// Source: oracle/codemp/game/g_main.c:2305
var gDidDuelStuff: Bool {
    get { world.variables.gDidDuelStuff }
    set { world.variables.gDidDuelStuff = newValue }
}

/// Source: oracle/codemp/game/g_main.c:2587
var g_endPDuel: Bool {
    get { world.variables.g_endPDuel }
    set { world.variables.g_endPDuel = newValue }
}

/// Source: oracle/codemp/game/g_main.c:2947
var g_duelPrintTimer: Int32 {
    get { world.variables.g_duelPrintTimer }
    set { world.variables.g_duelPrintTimer = newValue }
}

/// Source: oracle/codemp/game/g_main.c:3514
var g_LastFrameTime: Int32 {
    get { world.variables.g_LastFrameTime }
    set { world.variables.g_LastFrameTime = newValue }
}

/// Source: oracle/codemp/game/g_main.c:3515
var g_TimeSinceLastFrame: Int32 {
    get { world.variables.g_TimeSinceLastFrame }
    set { world.variables.g_TimeSinceLastFrame = newValue }
}

/// Source: oracle/codemp/game/g_main.c:3517
var gDoSlowMoDuel: Bool {
    get { world.variables.gDoSlowMoDuel }
    set { world.variables.gDoSlowMoDuel = newValue }
}

/// Source: oracle/codemp/game/g_main.c:3518
var gSlowMoDuelTime: Int32 {
    get { world.variables.gSlowMoDuelTime }
    set { world.variables.gSlowMoDuelTime = newValue }
}

/// Source: oracle/codemp/game/g_main.c:3580
var g_siegeRespawnCheck: Int32 {
    get { world.variables.g_siegeRespawnCheck }
    set { world.variables.g_siegeRespawnCheck = newValue }
}

/// Source: oracle/codemp/game/g_main.c:515
// Raven wrote: int vmMain( int command, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10, int arg11 )
// Not ported: the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5.

/// Source: oracle/codemp/game/g_main.c:703
func G_Printf(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    trap_Printf(format(fmt, args))
}

/// Source: oracle/codemp/game/g_main.c:714
func G_Error(_ fmt: String, _ args: any JKAShared.FormatArg...) -> Never {
    trap_Error(format(fmt, args))
}

/**
```
================
G_FindTeams

Chain together all entities with a matching team field.
Entity teams are used for item groups and multi-entity mover groups.

All but the first will have the FL_TEAMSLAVE flag set and teammaster field set
All but the last will have the teamchain field set to the next one
================
```
*/
/// Source: oracle/codemp/game/g_main.c:736
func G_FindTeams() {
    var eIndex: Int32 = 0
    var e2Index: Int32 = 0
    var i: Int32
    var j: Int32
    var c: Int32
    var c2: Int32

    c = 0
    c2 = 0
    i = 1
    eIndex = i
    while i < level.num_entities {
        if !g_entities[eIndex].inuse {
            i += 1
            eIndex += 1
            continue
        }
        if g_entities[eIndex].team == nil {
            i += 1
            eIndex += 1
            continue
        }
        if (g_entities[eIndex].flags & FL_TEAMSLAVE) != 0 {
            i += 1
            eIndex += 1
            continue
        }
        if g_entities[eIndex].r.contents == CONTENTS_TRIGGER {
            i += 1
            eIndex += 1
            continue //triggers NEVER link up in teams!
        }
        g_entities[eIndex].teammaster = g_entities[eIndex]
        c += 1
        c2 += 1
        j = i + 1
        e2Index = eIndex + 1
        while j < level.num_entities {
            if !g_entities[e2Index].inuse {
                j += 1
                e2Index += 1
                continue
            }
            if g_entities[e2Index].team == nil {
                j += 1
                e2Index += 1
                continue
            }
            if (g_entities[e2Index].flags & FL_TEAMSLAVE) != 0 {
                j += 1
                e2Index += 1
                continue
            }
            if strcmp(g_entities[eIndex].team!, g_entities[e2Index].team!) == 0 {
                c2 += 1
                g_entities[e2Index].teamchain = g_entities[eIndex].teamchain
                g_entities[eIndex].teamchain = g_entities[e2Index]
                g_entities[e2Index].teammaster = g_entities[eIndex]
                g_entities[e2Index].flags |= FL_TEAMSLAVE

                // make sure that targets only point at the master
                if g_entities[e2Index].targetname != nil {
                    g_entities[eIndex].targetname = g_entities[e2Index].targetname
                    g_entities[e2Index].targetname = nil
                }
            }
            j += 1
            e2Index += 1
        }
        i += 1
        eIndex += 1
    }

    //	G_Printf ("%i teams with %i entities\n", c, c2);
}

/// Source: oracle/codemp/game/g_main.c:783
func G_RemapTeamShaders() {
}

/**
```
=================
G_RegisterCvars
=================
```
*/
/// Source: oracle/codemp/game/g_main.c:803
func G_RegisterCvars() {
    var i: Int32
    var cvIndex: Int32 = 0
    var remapped: Bool = false

    i = 0
    cvIndex = 0
    while i < gameCvarTableSize {
        trap_Cvar_Register(gameCvarTable[cvIndex].vmCvar.map { world.storage[keyPath: $0] }, gameCvarTable[cvIndex].cvarName, gameCvarTable[cvIndex].defaultString, gameCvarTable[cvIndex].cvarFlags)
        if gameCvarTable[cvIndex].vmCvar != nil {
            gameCvarTable[cvIndex].modificationCount = world.storage[keyPath: gameCvarTable[cvIndex].vmCvar!].modificationCount
        }

        if gameCvarTable[cvIndex].teamShader {
            remapped = true
        }
        i += 1
        cvIndex += 1
    }

    if remapped {
        G_RemapTeamShaders()
    }

    // check some things
    if g_gametype.integer < 0 || g_gametype.integer >= GT_MAX_GAME_TYPE {
        G_Printf("g_gametype %i is out of range, defaulting to 0\n", g_gametype.integer)
        trap_Cvar_Set("g_gametype", "0")
    } else if g_gametype.integer == GT_HOLOCRON {
        G_Printf("This gametype is not supported.\n")
        trap_Cvar_Set("g_gametype", "0")
    } else if g_gametype.integer == GT_JEDIMASTER {
        G_Printf("This gametype is not supported.\n")
        trap_Cvar_Set("g_gametype", "0")
    } else if g_gametype.integer == GT_CTY {
        G_Printf("This gametype is not supported.\n")
        trap_Cvar_Set("g_gametype", "0")
    }

    level.warmupModificationCount = g_warmup.modificationCount
}

/**
```
=================
G_UpdateCvars
=================
```
*/
/// Source: oracle/codemp/game/g_main.c:852
func G_UpdateCvars() {
    var i: Int32
    var cvIndex: Int32 = 0
    var remapped: Bool = false

    i = 0
    cvIndex = 0
    while i < gameCvarTableSize {
        if gameCvarTable[cvIndex].vmCvar != nil {
            trap_Cvar_Update(world.storage[keyPath: gameCvarTable[cvIndex].vmCvar!])

            if gameCvarTable[cvIndex].modificationCount != world.storage[keyPath: gameCvarTable[cvIndex].vmCvar!].modificationCount {
                gameCvarTable[cvIndex].modificationCount = world.storage[keyPath: gameCvarTable[cvIndex].vmCvar!].modificationCount

                if gameCvarTable[cvIndex].trackChange {
                    trap_SendServerCommand(-1, va("print \"Server: %s changed to %s\n\"", gameCvarTable[cvIndex].cvarName, world.storage[keyPath: gameCvarTable[cvIndex].vmCvar!].string))
                }

                if gameCvarTable[cvIndex].teamShader {
                    remapped = true
                }
            }
        }
        i += 1
        cvIndex += 1
    }

    if remapped {
        G_RemapTeamShaders()
    }
}

/// Source: oracle/codemp/game/g_main.c:897
public func G_InitGame(_ levelTime: Int32, _ randomSeed: Int32, _ restart: Int32) {
    var i: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    VmCvar.scratch { mapname in
        // Raven's record lives to the end of his block, so the block is the closure.
        VmCvar.scratch { ckSum in


            //Init RMG to 0, it will be autoset to 1 if there is terrain on the level.
            trap_Cvar_Set("RMG", "0")
            g_RMG.integer = 0

            //Clean up any client-server ghoul2 instance attachments that may still exist exe-side
            trap_G2API_CleanEntAttachments()

            BG_InitAnimsets() //clear it out

            B_InitAlloc() //make sure everything is clean

            trap_SV_RegisterSharedMemory(gSharedBuffer)

            //Load external vehicle data
            BG_VehicleLoadParms()

            G_Printf("------- Game Initialization -------\n")
            G_Printf("gamename: %s\n", GAMEVERSION)
            G_Printf("gamedate: %s\n", buildDate)

            srand(randomSeed)

            G_RegisterCvars()

            //G_ProcessIPBans();
            G_LoadIPBans()

            G_InitMemory()

            // set some level globals
            level.clear()
            level.time = levelTime
            level.startTime = levelTime

            level.snd_fry = G_SoundIndex("sound/player/fry.wav") // FIXME standing in lava / slime

            level.snd_hack = G_SoundIndex("sound/player/hacking.wav")
            level.snd_medHealed = G_SoundIndex("sound/player/supp_healed.wav")
            level.snd_medSupplied = G_SoundIndex("sound/player/supp_supplied.wav")

            //trap_SP_RegisterServer("mp_svgame");

            if !g_log.string.isEmpty {
                if g_logSync.integer != 0 {
                    trap_FS_FOpenFile(g_log.string, &level.logFile, FS_APPEND_SYNC)
                } else {
                    trap_FS_FOpenFile(g_log.string, &level.logFile, FS_APPEND)
                }
                if level.logFile == 0 {
                    G_Printf("WARNING: Couldn't open logfile: %s\n", g_log.string)
                } else {
                    var serverinfo = CharBuf(1024)

                    strcpy(&serverinfo, trap_GetServerinfo(Int32((serverinfo).count)))

                    G_LogPrintf("------------------------------------------------------------\n")
                    G_LogPrintf("InitGame: %s\n", serverinfo)
                }
            } else {
                G_Printf("Not logging to disk.\n")
            }

            G_LogWeaponInit()

            G_InitWorldSession()

            // initialize all entities for this game
            g_entities.zero()
            level.gentities = g_entities[0]

            // initialize all clients for this game
            level.maxclients = g_maxclients.integer
            g_clients.zero()
            level.clientsSlots = g_clients

            // set client fields on player ents
            i = 0
            while i < level.maxclients {
                g_entities[i].client = level.clientsSlots[i]
                i += 1
            }

            // always leave room for the max number of clients,
            // even if they aren't all used, so numbers inside that
            // range are NEVER anything but clients
            level.num_entities = MAX_CLIENTS

            // let the server system know where the entites are
            trap_LocateGameData(level.gentities!, level.num_entities, Int32(Entity.byteCount), level.clientsSlots[0].ps, Int32(Client.byteCount))

            //Load sabers.cfg data
            WP_SaberLoadParms()

            NPC_InitGame()

            TIMER_Clear()
            //
            //ICARUS INIT START

            //	Com_Printf("------ ICARUS Initialization ------\n");

            trap_ICARUS_Init()

            //	Com_Printf ("-----------------------------------\n");

            //ICARUS INIT END
            //

            // reserve some spots for dead player bodies
            InitBodyQue()

            ClearRegisteredItems()

            //make sure saber data is loaded before this! (so we can precache the appropriate hilts)
            InitSiegeMode()

            trap_Cvar_Register(mapname, "mapname", "", CVAR_SERVERINFO | CVAR_ROM)
            trap_Cvar_Register(ckSum, "sv_mapChecksum", "", CVAR_ROM)

            navCalculatePaths = (trap_Nav_Load(mapname.string, ckSum.integer) == false)

            // parse the key/value pairs and spawn gentities
            G_SpawnEntitiesFromString(false)

            // general initialization
            G_FindTeams()

            // make sure we have flags for CTF, etc
            if g_gametype.integer >= GT_TEAM {
                G_CheckTeamItems()
            } else if g_gametype.integer == GT_JEDIMASTER {
                trap_SetConfigstring(CS_CLIENT_JEDIMASTER, "-1")
            }

            if g_gametype.integer == GT_POWERDUEL {
                trap_SetConfigstring(CS_CLIENT_DUELISTS, va("-1|-1|-1"))
            } else {
                trap_SetConfigstring(CS_CLIENT_DUELISTS, va("-1|-1"))
            }
            // nmckenzie: DUEL_HEALTH: Default.
            trap_SetConfigstring(CS_CLIENT_DUELHEALTHS, va("-1|-1|!"))
            trap_SetConfigstring(CS_CLIENT_DUELWINNER, va("-1"))

            SaveRegisteredItems()

            //G_Printf ("-----------------------------------\n");

            if g_gametype.integer == GT_SINGLE_PLAYER || trap_Cvar_VariableIntegerValue("com_buildScript") != 0 {
                G_ModelIndex(SP_PODIUM_MODEL)
                G_SoundIndex("sound/player/gurp1.wav")
                G_SoundIndex("sound/player/gurp2.wav")
            }

            if trap_Cvar_VariableIntegerValue("bot_enable") != 0 {
                BotAISetup(restart)
                BotAILoadMap(restart)
                G_InitBots(restart != 0)
            }

            G_RemapTeamShaders()

            if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
                G_LogPrintf("Duel Tournament Begun: kill limit %d, win limit: %d\n", g_fraglimit.integer, g_duel_fraglimit.integer)
            }

            if navCalculatePaths {
                //not loaded - need to calc paths
                navCalcPathTime = level.time + START_TIME_NAV_CALC //make sure all ents are in and linked
            } else {
                //loaded
                //FIXME: if this is from a loadgame, it needs to be sure to write this
                //out whenever you do a savegame since the edges and routes are dynamic...
                //OR: always do a navigator.CheckBlockedEdges() on map startup after nav-load/calc-paths
                //navigator.pathsCalculated = qtrue;//just to be safe?  Does this get saved out?  No... assumed
                trap_Nav_SetPathsCalculated(true)
                //need to do this, because combatpoint waypoints aren't saved out...?
                CP_FindCombatPointWaypoints()
                navCalcPathTime = 0

                /*
                if ( g_eSavedGameJustLoaded == eNO )
                {//clear all the failed edges unless we just loaded the game (which would include failed edges)
                trap_Nav_ClearAllFailedEdges();
                }
                */
                //No loading games in MP.
            }

            if g_gametype.integer == GT_SIEGE {
                //just get these configstrings registered now...
                var i: Int32 = 0
                while i < MAX_CUSTOM_SIEGE_SOUNDS {
                    if bg_customSiegeSoundNames[i] == nil {
                        break
                    }
                    G_SoundIndex(bg_customSiegeSoundNames[i])
                    i += 1
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/g_main.c:1128
public func G_ShutdownGame(_ restart: Int32) {
    var i: Int32 = 0
    var ent: Entity?

    //	G_Printf ("==== ShutdownGame ====\n");

    G_SaveBanIP()
    G_CleanAllFakeClients() //get rid of dynamically allocated fake client structs.

    BG_ClearAnimsets() //free all dynamic allocations made through the engine

    //	Com_Printf("... Gameside GHOUL2 Cleanup\n");
    while i < MAX_GENTITIES {
        //clean up all the ghoul2 instances
        ent = g_entities[i]

        if ent!.ghoul2 != nil && trap_G2_HaveWeGhoul2Models(ent!.ghoul2) {
            trap_G2API_CleanGhoul2Models(&ent!.ghoul2)
            ent!.ghoul2 = nil
        }
        if ent!.client != nil {
            var j: Int32 = 0

            while j < MAX_SABERS {
                if ent!.client!.weaponGhoul2[j] != nil && trap_G2_HaveWeGhoul2Models(ent!.client!.weaponGhoul2[j]) {
                    trap_G2API_CleanGhoul2Models(&ent!.client!.weaponGhoul2[j])
                }
                j += 1
            }
        }
        i += 1
    }
    if g2SaberInstance != nil && trap_G2_HaveWeGhoul2Models(g2SaberInstance) {
        trap_G2API_CleanGhoul2Models(&g2SaberInstance)
        g2SaberInstance = nil
    }
    if precachedKyle != nil && trap_G2_HaveWeGhoul2Models(precachedKyle) {
        trap_G2API_CleanGhoul2Models(&precachedKyle)
        precachedKyle = nil
    }

    //	Com_Printf ("... ICARUS_Shutdown\n");
    trap_ICARUS_Shutdown() //Shut ICARUS down

    //	Com_Printf ("... Reference Tags Cleared\n");
    TAG_Init() //Clear the reference tags

    G_LogWeaponOutput()

    if level.logFile != 0 {
        G_LogPrintf("ShutdownGame:\n")
        G_LogPrintf("------------------------------------------------------------\n")
        trap_FS_FCloseFile(level.logFile)
    }

    // write all the client session data so we can get it back
    G_WriteSessionData()

    trap_ROFF_Clean()

    if trap_Cvar_VariableIntegerValue("bot_enable") != 0 {
        BotAIShutdown(restart)
    }

    B_CleanupAlloc() //clean up all allocations made with B_Alloc
}

/// Source: oracle/codemp/game/g_main.c:1208
public func Com_Error(_ level: Int32, _ error: String, _ args: any JKAShared.FormatArg...) -> Never {
    // Raven's `G_Error("%s", text)` drops `level`, so this does too.
    trap_Error(format(error, args))
}

/// Source: oracle/codemp/game/g_main.c:1219
public func Com_Printf(_ msg: String, _ args: any JKAShared.FormatArg...) {
    trap_Printf(format(msg, args))
}

/**
```
=============
AddTournamentPlayer

If there are less than two tournament players, put a
spectator in the game and restart
=============
```
*/
/// Source: oracle/codemp/game/g_main.c:1248
func AddTournamentPlayer() {
    var i: Int32
    var client: Client?
    var nextInLine: Client?

    if level.numPlayingClients >= 2 {
        return
    }

    // never change during intermission
    //	if ( level.intermissiontime ) {
    //		return;
    //	}

    nextInLine = nil

    i = 0
    while i < level.maxclients {
        client = level.clientsSlots[i]
        if client!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if g_allowHighPingDuelist.integer == 0 && client!.ps.ping >= 999 {
            //don't add people who are lagging out if cvar is not set to allow it.
            i += 1
            continue
        }
        if client!.sess.sessionTeam != TEAM_SPECTATOR {
            i += 1
            continue
        }
        // never select the dedicated follow or scoreboard clients
        if client!.sess.spectatorState == SPECTATOR_SCOREBOARD || client!.sess.spectatorClient < 0 {
            i += 1
            continue
        }

        if nextInLine == nil || client!.sess.spectatorTime < nextInLine!.sess.spectatorTime {
            nextInLine = client
        }
        i += 1
    }

    if nextInLine == nil {
        return
    }

    level.warmupTime = -1

    // set them to free-for-all team
    SetTeam(g_entities[level.clientsSlots.index(of: nextInLine!)], "f")
}

/**
```
=======================
RemoveTournamentLoser

Make the loser a spectator at the back of the line
=======================
```
*/
/// Source: oracle/codemp/game/g_main.c:1304
func RemoveTournamentLoser() {
    let clientNum: Int32

    if level.numPlayingClients != 2 {
        return
    }

    clientNum = level.sortedClients[1]

    if level.clientsSlots[clientNum].pers.connected != CON_CONNECTED {
        return
    }

    // make them a spectator
    SetTeam(g_entities[clientNum], "s")
}

/// Source: oracle/codemp/game/g_main.c:1321
func G_PowerDuelCount(_ loners: inout Int32, _ doubles: inout Int32, _ countSpec: Bool) {
    var i: Int32 = 0
    var cl: Client?

    while i < MAX_CLIENTS {
        cl = g_entities[i].client

        if g_entities[i].inuse && cl != nil && (countSpec || cl!.sess.sessionTeam != TEAM_SPECTATOR) {
            if cl!.sess.duelTeam == DUELTEAM_LONE {
                (loners) += 1
            } else if cl!.sess.duelTeam == DUELTEAM_DOUBLE {
                (doubles) += 1
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_main.c:1346
func AddPowerDuelPlayers() {
    var i: Int32
    var loners: Int32 = 0
    var doubles: Int32 = 0
    var nonspecLoners: Int32 = 0
    var nonspecDoubles: Int32 = 0
    var client: Client?
    var nextInLine: Client?

    if level.numPlayingClients >= 3 {
        return
    }

    nextInLine = nil

    G_PowerDuelCount(&nonspecLoners, &nonspecDoubles, false)
    if nonspecLoners >= 1 && nonspecDoubles >= 2 {
        //we have enough people, stop
        return
    }

    //Could be written faster, but it's not enough to care I suppose.
    G_PowerDuelCount(&loners, &doubles, true)

    if loners < 1 || doubles < 2 {
        //don't bother trying to spawn anyone yet if the balance is not even set up between spectators
        return
    }

    //Count again, with only in-game clients in mind.
    loners = nonspecLoners
    doubles = nonspecDoubles
    //	G_PowerDuelCount(&loners, &doubles, qfalse);

    i = 0
    while i < level.maxclients {
        client = level.clientsSlots[i]
        if client!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if client!.sess.sessionTeam != TEAM_SPECTATOR {
            i += 1
            continue
        }
        if client!.sess.duelTeam == DUELTEAM_FREE {
            i += 1
            continue
        }
        if client!.sess.duelTeam == DUELTEAM_LONE && loners >= 1 {
            i += 1
            continue
        }
        if client!.sess.duelTeam == DUELTEAM_DOUBLE && doubles >= 2 {
            i += 1
            continue
        }

        // never select the dedicated follow or scoreboard clients
        if client!.sess.spectatorState == SPECTATOR_SCOREBOARD || client!.sess.spectatorClient < 0 {
            i += 1
            continue
        }

        if nextInLine == nil || client!.sess.spectatorTime < nextInLine!.sess.spectatorTime {
            nextInLine = client
        }
        i += 1
    }

    if nextInLine == nil {
        return
    }

    level.warmupTime = -1

    // set them to free-for-all team
    SetTeam(g_entities[level.clientsSlots.index(of: nextInLine!)], "f")

    //Call recursively until everyone is in
    AddPowerDuelPlayers()
}

/// Source: oracle/codemp/game/g_main.c:1429
func RemovePowerDuelLosers() {
    var remClients: [Int32] = [Int32](repeating: 0, count: 3)
    var remNum: Int32 = 0
    var i: Int32 = 0
    var cl: Client?

    while i < MAX_CLIENTS && remNum < 3 {
        //cl = &level.clients[level.sortedClients[i]];
        cl = level.clientsSlots[i]

        if cl!.pers.connected == CON_CONNECTED {
            if (cl!.ps.stats[STAT_HEALTH] <= 0 || cl!.iAmALoser) && (cl!.sess.sessionTeam != TEAM_SPECTATOR || cl!.iAmALoser) {
                //he was dead or he was spectating as a loser
                remClients[remNum] = cl!.ps.clientNum
                remNum += 1
            }
        }

        i += 1
    }

    if remNum == 0 {
        //Time ran out or something? Oh well, just remove the main guy.
        remClients[remNum] = level.sortedClients[0]
        remNum += 1
    }

    i = 0
    while i < remNum {
        //set them all to spectator
        SetTeam(g_entities[remClients[i]], "s")
        i += 1
    }

    g_dontFrickinCheck = false

    //recalculate stuff now that we have reset teams.
    CalculateRanks()
}

/// Source: oracle/codemp/game/g_main.c:1473
func RemoveDuelDrawLoser() {
    var clFirst: Int32 = 0
    var clSec: Int32 = 0
    var clFailure: Int32 = 0

    if level.clientsSlots[level.sortedClients[0]].pers.connected != CON_CONNECTED {
        return
    }
    if level.clientsSlots[level.sortedClients[1]].pers.connected != CON_CONNECTED {
        return
    }

    clFirst = level.clientsSlots[level.sortedClients[0]].ps.stats[STAT_HEALTH] + level.clientsSlots[level.sortedClients[0]].ps.stats[STAT_ARMOR]
    clSec = level.clientsSlots[level.sortedClients[1]].ps.stats[STAT_HEALTH] + level.clientsSlots[level.sortedClients[1]].ps.stats[STAT_ARMOR]

    if clFirst > clSec {
        clFailure = 1
    } else if clSec > clFirst {
        clFailure = 0
    } else {
        clFailure = 2
    }

    if clFailure != 2 {
        SetTeam(g_entities[level.sortedClients[clFailure]], "s")
    } else {
        //we could be more elegant about this, but oh well.
        SetTeam(g_entities[level.sortedClients[1]], "s")
    }
}

/**
```
=======================
RemoveTournamentWinner
=======================
```
*/
/// Source: oracle/codemp/game/g_main.c:1519
func RemoveTournamentWinner() {
    let clientNum: Int32

    if level.numPlayingClients != 2 {
        return
    }

    clientNum = level.sortedClients[0]

    if level.clientsSlots[clientNum].pers.connected != CON_CONNECTED {
        return
    }

    // make them a spectator
    SetTeam(g_entities[clientNum], "s")
}

/**
```
=======================
AdjustTournamentScores
=======================
```
*/
/// Source: oracle/codemp/game/g_main.c:1541
func AdjustTournamentScores() {
    var clientNum: Int32

    if level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE] == level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE] && level.clientsSlots[level.sortedClients[0]].pers.connected == CON_CONNECTED && level.clientsSlots[level.sortedClients[1]].pers.connected == CON_CONNECTED {
        let clFirst: Int32 = level.clientsSlots[level.sortedClients[0]].ps.stats[STAT_HEALTH] + level.clientsSlots[level.sortedClients[0]].ps.stats[STAT_ARMOR]
        let clSec: Int32 = level.clientsSlots[level.sortedClients[1]].ps.stats[STAT_HEALTH] + level.clientsSlots[level.sortedClients[1]].ps.stats[STAT_ARMOR]
        var clFailure: Int32 = 0
        var clSuccess: Int32 = 0

        if clFirst > clSec {
            clFailure = 1
            clSuccess = 0
        } else if clSec > clFirst {
            clFailure = 0
            clSuccess = 1
        } else {
            clFailure = 2
            clSuccess = 2
        }

        if clFailure != 2 {
            clientNum = level.sortedClients[clSuccess]

            level.clientsSlots[clientNum].sess.wins += 1
            ClientUserinfoChanged(clientNum)
            trap_SetConfigstring(CS_CLIENT_DUELWINNER, va("%i", clientNum))

            clientNum = level.sortedClients[clFailure]

            level.clientsSlots[clientNum].sess.losses += 1
            ClientUserinfoChanged(clientNum)
        } else {
            clSuccess = 0
            clFailure = 1

            clientNum = level.sortedClients[clSuccess]

            level.clientsSlots[clientNum].sess.wins += 1
            ClientUserinfoChanged(clientNum)
            trap_SetConfigstring(CS_CLIENT_DUELWINNER, va("%i", clientNum))

            clientNum = level.sortedClients[clFailure]

            level.clientsSlots[clientNum].sess.losses += 1
            ClientUserinfoChanged(clientNum)
        }
    } else {
        clientNum = level.sortedClients[0]
        if level.clientsSlots[clientNum].pers.connected == CON_CONNECTED {
            level.clientsSlots[clientNum].sess.wins += 1
            ClientUserinfoChanged(clientNum)

            trap_SetConfigstring(CS_CLIENT_DUELWINNER, va("%i", clientNum))
        }

        clientNum = level.sortedClients[1]
        if level.clientsSlots[clientNum].pers.connected == CON_CONNECTED {
            level.clientsSlots[clientNum].sess.losses += 1
            ClientUserinfoChanged(clientNum)
        }
    }
}

/**
```
=============
SortRanks

=============
```
*/
/// Source: oracle/codemp/game/g_main.c:1624
func SortRanks(_ a: Int32, _ b: Int32) -> Int32 {
    let ca: Client
    let cb: Client

    ca = level.clientsSlots[a]
    cb = level.clientsSlots[b]

    if g_gametype.integer == GT_POWERDUEL {
        //sort single duelists first
        if ca.sess.duelTeam == DUELTEAM_LONE && ca.sess.sessionTeam != TEAM_SPECTATOR {
            return -1
        }
        if cb.sess.duelTeam == DUELTEAM_LONE && cb.sess.sessionTeam != TEAM_SPECTATOR {
            return 1
        }

        //others will be auto-sorted below but above spectators.
    }

    // sort special clients last
    if ca.sess.spectatorState == SPECTATOR_SCOREBOARD || ca.sess.spectatorClient < 0 {
        return 1
    }
    if cb.sess.spectatorState == SPECTATOR_SCOREBOARD || cb.sess.spectatorClient < 0 {
        return -1
    }

    // then connecting clients
    if ca.pers.connected == CON_CONNECTING {
        return 1
    }
    if cb.pers.connected == CON_CONNECTING {
        return -1
    }


    // then spectators
    if ca.sess.sessionTeam == TEAM_SPECTATOR && cb.sess.sessionTeam == TEAM_SPECTATOR {
        if ca.sess.spectatorTime < cb.sess.spectatorTime {
            return -1
        }
        if ca.sess.spectatorTime > cb.sess.spectatorTime {
            return 1
        }
        return 0
    }
    if ca.sess.sessionTeam == TEAM_SPECTATOR {
        return 1
    }
    if cb.sess.sessionTeam == TEAM_SPECTATOR {
        return -1
    }

    // then sort by score
    if ca.ps.persistant[PERS_SCORE] > cb.ps.persistant[PERS_SCORE] {
        return -1
    }
    if ca.ps.persistant[PERS_SCORE] < cb.ps.persistant[PERS_SCORE] {
        return 1
    }
    return 0
}

//A new duel started so respawn everyone and make sure their stats are reset
/// Source: oracle/codemp/game/g_main.c:1695
func G_CanResetDuelists() -> Bool {
    var i: Int32
    var ent: Entity?

    i = 0
    while i < 3 {
        //precheck to make sure they are all respawnable
        ent = g_entities[level.sortedClients[i]]

        if !ent!.inuse || ent!.client == nil || ent!.health <= 0 || ent!.client!.sess.sessionTeam == TEAM_SPECTATOR || ent!.client!.sess.duelTeam <= DUELTEAM_FREE {
            return false
        }
        i += 1
    }

    return true
}

/// Source: oracle/codemp/game/g_main.c:1718
func G_ResetDuelists() {
    var i: Int32
    var ent: Entity?
    var tent: Entity?

    i = 0
    while i < 3 {
        ent = g_entities[level.sortedClients[i]]

        g_noPDuelCheck = true
        player_die(ent!, ent!, ent!, 999, MOD_SUICIDE)
        g_noPDuelCheck = false
        trap_UnlinkEntity(ent!)
        ClientSpawn(ent!)

        // add a teleportation effect
        tent = G_TempEntity(ent!.client!.ps.origin, EV_PLAYER_TELEPORT_IN)
        tent!.s.clientNum = ent!.s.clientNum
        i += 1
    }
}

/**
```
============
CalculateRanks

Recalculates the score ranks of all players
This will be called on every client connect, begin, disconnect, death,
and team change.
============
```
*/
/// Source: oracle/codemp/game/g_main.c:1751
func CalculateRanks() {
    var i: Int32
    var rank: Int32
    var score: Int32
    var newScore: Int32
    var preNumSpec: Int32 = 0
    //int		nonSpecIndex = -1;
    var cl: Client?

    preNumSpec = level.numNonSpectatorClients

    level.follow1 = -1
    level.follow2 = -1
    level.numConnectedClients = 0
    level.numNonSpectatorClients = 0
    level.numPlayingClients = 0
    level.numVotingClients = 0 // don't count bots
    i = 0
    while i < TEAM_NUM_TEAMS {
        level.numteamVotingClients[i] = 0
        i += 1
    }
    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].pers.connected != CON_DISCONNECTED {
            level.sortedClients[level.numConnectedClients] = i
            level.numConnectedClients += 1

            if level.clientsSlots[i].sess.sessionTeam != TEAM_SPECTATOR || g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
                if level.clientsSlots[i].sess.sessionTeam != TEAM_SPECTATOR {
                    level.numNonSpectatorClients += 1
                    //nonSpecIndex = i;
                }

                // decide if this should be auto-followed
                if level.clientsSlots[i].pers.connected == CON_CONNECTED {
                    if level.clientsSlots[i].sess.sessionTeam != TEAM_SPECTATOR || level.clientsSlots[i].iAmALoser {
                        level.numPlayingClients += 1
                    }
                    if !((g_entities[i].r.svFlags & SVF_BOT) != 0) {
                        level.numVotingClients += 1
                        if level.clientsSlots[i].sess.sessionTeam == TEAM_RED {
                            level.numteamVotingClients[0] += 1
                        } else if level.clientsSlots[i].sess.sessionTeam == TEAM_BLUE {
                            level.numteamVotingClients[1] += 1
                        }
                    }
                    if level.follow1 == -1 {
                        level.follow1 = i
                    } else if level.follow2 == -1 {
                        level.follow2 = i
                    }
                }
            }
        }
        i += 1
    }

    //if (!g_warmup.integer)
    if 1 != 0 {
        level.warmupTime = 0
    }

    /*
    if (level.numNonSpectatorClients == 2 && preNumSpec < 2 && nonSpecIndex != -1 && g_gametype.integer == GT_DUEL && !level.warmupTime)
    {
    gentity_t *currentWinner = G_GetDuelWinner(&level.clients[nonSpecIndex]);

    if (currentWinner && currentWinner->client)
    {
    trap_SendServerCommand( -1, va("cp \"%s" S_COLOR_WHITE " %s %s\n\"",
    currentWinner->client->pers.netname, G_GetStringEdString("MP_SVGAME", "VERSUS"), level.clients[nonSpecIndex].pers.netname));
    }
    }
    */
    //NOTE: for now not doing this either. May use later if appropriate.

    qsort(level.sortedClients, level.numConnectedClients, SortRanks)

    // set the rank value for all clients that are connected and not spectators
    if g_gametype.integer >= GT_TEAM {
        // in team games, rank is just the order of the teams, 0=red, 1=blue, 2=tied
        i = 0
        while i < level.numConnectedClients {
            cl = level.clientsSlots[level.sortedClients[i]]
            if level.teamScores[TEAM_RED] == level.teamScores[TEAM_BLUE] {
                cl!.ps.persistant[PERS_RANK] = 2
            } else if level.teamScores[TEAM_RED] > level.teamScores[TEAM_BLUE] {
                cl!.ps.persistant[PERS_RANK] = 0
            } else {
                cl!.ps.persistant[PERS_RANK] = 1
            }
            i += 1
        }
    } else {
        rank = -1
        score = 0
        i = 0
        while i < level.numPlayingClients {
            cl = level.clientsSlots[level.sortedClients[i]]
            newScore = cl!.ps.persistant[PERS_SCORE]
            if i == 0 || newScore != score {
                rank = i
                // assume we aren't tied until the next client is checked
                level.clientsSlots[level.sortedClients[i]].ps.persistant[PERS_RANK] = rank
            } else {
                // we are tied with the previous client
                level.clientsSlots[level.sortedClients[i - 1]].ps.persistant[PERS_RANK] = rank | RANK_TIED_FLAG
                level.clientsSlots[level.sortedClients[i]].ps.persistant[PERS_RANK] = rank | RANK_TIED_FLAG
            }
            score = newScore
            if g_gametype.integer == GT_SINGLE_PLAYER && level.numPlayingClients == 1 {
                level.clientsSlots[level.sortedClients[i]].ps.persistant[PERS_RANK] = rank | RANK_TIED_FLAG
            }
            i += 1
        }
    }

    // set the CS_SCORES1/2 configstrings, which will be visible to everyone
    if g_gametype.integer >= GT_TEAM {
        trap_SetConfigstring(CS_SCORES1, va("%i", level.teamScores[TEAM_RED]))
        trap_SetConfigstring(CS_SCORES2, va("%i", level.teamScores[TEAM_BLUE]))
    } else {
        if level.numConnectedClients == 0 {
            trap_SetConfigstring(CS_SCORES1, va("%i", SCORE_NOT_PRESENT))
            trap_SetConfigstring(CS_SCORES2, va("%i", SCORE_NOT_PRESENT))
        } else if level.numConnectedClients == 1 {
            trap_SetConfigstring(CS_SCORES1, va("%i", level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE]))
            trap_SetConfigstring(CS_SCORES2, va("%i", SCORE_NOT_PRESENT))
        } else {
            trap_SetConfigstring(CS_SCORES1, va("%i", level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE]))
            trap_SetConfigstring(CS_SCORES2, va("%i", level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE]))
        }

        if g_gametype.integer != GT_DUEL || g_gametype.integer != GT_POWERDUEL {
            //when not in duel, use this configstring to pass the index of the player currently in first place
            if level.numConnectedClients >= 1 {
                trap_SetConfigstring(CS_CLIENT_DUELWINNER, va("%i", level.sortedClients[0]))
            } else {
                trap_SetConfigstring(CS_CLIENT_DUELWINNER, "-1")
            }
        }
    }

    // see if it is time to end the level
    CheckExitRules()

    // if we are at the intermission or in multi-frag Duel game mode, send the new info to everyone
    if level.intermissiontime != 0 || g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        gQueueScoreMessage = true
        gQueueScoreMessageTime = level.time + 500
        //SendScoreboardMessageToAllClients();
        //rww - Made this operate on a "queue" system because it was causing large overflows
    }
}

/**
```
========================
SendScoreboardMessageToAllClients

Do this at BeginIntermission time and whenever ranks are recalculated
due to enters/exits/forced team changes
========================
```
*/
/// Source: oracle/codemp/game/g_main.c:1925
func SendScoreboardMessageToAllClients() {
    var i: Int32

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].pers.connected == CON_CONNECTED {
            DeathmatchScoreboardMessage(g_entities[i])
        }
        i += 1
    }
}

/**
```
========================
MoveClientToIntermission

When the intermission starts, this will be called for all players.
If a new client connects, this will be called after the spawn function.
========================
```
*/
/// Source: oracle/codemp/game/g_main.c:1943
func MoveClientToIntermission(_ ent: Entity) {
    // take out of follow mode if needed
    if ent.client!.sess.spectatorState == SPECTATOR_FOLLOW {
        StopFollowing(ent)
    }


    // move to the spot
    ent.s.origin = level.intermission_origin
    ent.client!.ps.origin = level.intermission_origin
    ent.client!.ps.viewangles = level.intermission_angle
    ent.client!.ps.pm_type = PM_INTERMISSION

    // clean up powerup info
    ent.client!.ps.powerups.fill(0)

    ent.client!.ps.eFlags = 0
    ent.s.eFlags = 0
    ent.s.eType = ET_GENERAL
    ent.s.modelindex = 0
    ent.s.loopSound = 0
    ent.s.loopIsSoundset = false
    ent.s.event = 0
    ent.r.contents = 0
}

/// Source: oracle/codemp/game/g_main.c:1979
func FindIntermissionPoint() {
    var ent: Entity? = nil
    var target: Entity?
    var dir = vec3_t()

    // find the intermission spot
    if g_gametype.integer == GT_SIEGE && level.intermissiontime != 0 && level.intermissiontime <= level.time && gSiegeRoundEnded {
        if gSiegeRoundWinningTeam == SIEGETEAM_TEAM1 {
            ent = G_Find(nil, \.classname, "info_player_intermission_red")
            if ent != nil && ent!.target2 != nil {
                G_UseTargets2(ent!, ent, ent!.target2)
            }
        } else if gSiegeRoundWinningTeam == SIEGETEAM_TEAM2 {
            ent = G_Find(nil, \.classname, "info_player_intermission_blue")
            if ent != nil && ent!.target2 != nil {
                G_UseTargets2(ent!, ent, ent!.target2)
            }
        }
    }
    if ent == nil {
        ent = G_Find(nil, \.classname, "info_player_intermission")
    }
    if ent == nil {
        // the map creator forgot to put in an intermission point...
        SelectSpawnPoint(vec3_origin, &level.intermission_origin, &level.intermission_angle, TEAM_SPECTATOR)
    } else {
        level.intermission_origin = ent!.s.origin
        level.intermission_angle = ent!.s.angles
        // if it has a target, look towards it
        if ent!.target != nil {
            target = G_PickTarget(ent!.target!)
            if target != nil {
                dir = target!.s.origin - level.intermission_origin
                vectoangles(dir, &level.intermission_angle)
            }
        }
    }
}

/**
```
==================
BeginIntermission
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:2035
func BeginIntermission() {
    var i: Int32
    var clientIndex: Int32 = 0

    if level.intermissiontime != 0 {
        return // already active
    }

    // if in tournement mode, change the wins / losses
    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        trap_SetConfigstring(CS_CLIENT_DUELWINNER, "-1")

        if g_gametype.integer != GT_POWERDUEL {
            AdjustTournamentScores()
        }
        if DuelLimitHit() {
            gDuelExit = true
        } else {
            gDuelExit = false
        }
    }

    level.intermissiontime = level.time
    FindIntermissionPoint()

    /*
    if (g_singlePlayer.integer) {
    trap_Cvar_Set("ui_singlePlayerActive", "0");
    UpdateTournamentInfo();
    }
    */
    //what the? Well, I don't want this to happen.

    // move all clients to the intermission point
    i = 0
    while i < level.maxclients {
        clientIndex = i
        if !g_entities[clientIndex].inuse {
            i += 1
            continue
        }
        // respawn if dead
        if g_entities[clientIndex].health <= 0 {
            if g_gametype.integer != GT_POWERDUEL || g_entities[clientIndex].client == nil || g_entities[clientIndex].client!.sess.sessionTeam != TEAM_SPECTATOR {
                //don't respawn spectators in powerduel or it will mess the line order all up
                respawn(g_entities[clientIndex])
            }
        }
        MoveClientToIntermission(g_entities[clientIndex])
        i += 1
    }

    // send the current scoring to all clients
    SendScoreboardMessageToAllClients()
}

/// Source: oracle/codemp/game/g_main.c:2094
func DuelLimitHit() -> Bool {
    var i: Int32
    var cl: Client?

    i = 0
    while i < g_maxclients.integer {
        cl = level.clientsSlots[i]
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }

        if g_duel_fraglimit.integer != 0 && cl!.sess.wins >= g_duel_fraglimit.integer {
            return true
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_main.c:2114
func DuelResetWinsLosses() {
    var i: Int32
    var cl: Client?

    i = 0
    while i < g_maxclients.integer {
        cl = level.clientsSlots[i]
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }

        cl!.sess.wins = 0
        cl!.sess.losses = 0
        i += 1
    }
}

/// Source: oracle/codemp/game/g_main.c:2141
func ExitLevel() {
    var i: Int32
    var cl: Client?

    // if we are running a tournement map, kick the loser to spectator status,
    // which will automatically grab the next spectator and restart
    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        if !DuelLimitHit() {
            if !level.restarted {
                trap_SendConsoleCommand(EXEC_APPEND, "map_restart 0\n")
                level.restarted = true
                level.changemap = nil
                level.intermissiontime = 0
            }
            return
        }

        DuelResetWinsLosses()
    }


    if g_gametype.integer == GT_SIEGE && g_siegeTeamSwitch.integer != 0 && g_siegePersistant.beatingTime {
        //restart same map...
        trap_SendConsoleCommand(EXEC_APPEND, "map_restart 0\n")
    } else {
        trap_SendConsoleCommand(EXEC_APPEND, "vstr nextmap\n")
    }
    level.changemap = nil
    level.intermissiontime = 0

    if g_gametype.integer == GT_SIEGE && g_siegeTeamSwitch.integer != 0 {
        //switch out now
        SiegeDoTeamAssign()
    }

    // reset all the scores so we don't enter the intermission again
    level.teamScores[TEAM_RED] = 0
    level.teamScores[TEAM_BLUE] = 0
    i = 0
    while i < g_maxclients.integer {
        cl = level.clientsSlots[i]
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        cl!.ps.persistant[PERS_SCORE] = 0
        i += 1
    }

    // we need to do this here before chaning to CON_CONNECTING
    G_WriteSessionData()

    // change all client states to connecting, so the early players into the
    // next level will know the others aren't done reconnecting
    i = 0
    while i < g_maxclients.integer {
        if level.clientsSlots[i].pers.connected == CON_CONNECTED {
            level.clientsSlots[i].pers.connected = CON_CONNECTING
        }
        i += 1
    }
}

/**
```
=================
G_LogPrintf

Print to the logfile with a time stamp if it is open
=================
```
*/
/// Source: oracle/codemp/game/g_main.c:2213
func G_LogPrintf(_ fmt: String, _ args: any JKAShared.FormatArg...) {
    var string = CharBuf(1024)
    let min: Int32
    let tens: Int32
    var sec: Int32

    sec = level.time / 1000

    min = sec / 60
    sec -= min * 60
    tens = sec / 10
    sec -= tens * 10

    Com_sprintf(&string, Int32((string).count), "%3i:%i%i ", min, tens, sec)

    strcpy(&string, format(fmt, args), at: 7)

    if g_dedicated.integer != 0 {
        G_Printf("%s", string[7...])
    }

    if level.logFile == 0 {
        return
    }

    trap_FS_Write(&string, strlen(string), level.logFile)
}

/**
```
================
LogExit

Append information about this game to the log file
================
```
*/
/// Source: oracle/codemp/game/g_main.c:2249
func LogExit(_ string: String) {
    var i: Int32
    var numSorted: Int32
    var cl: Client?
    //	qboolean		won = qtrue;
    G_LogPrintf("Exit: %s\n", string)

    level.intermissionQueued = level.time

    // this will keep the clients from playing any voice sounds
    // that will get cut off when the queued intermission starts
    trap_SetConfigstring(CS_INTERMISSION, "1")

    // don't send more than 32 scores (FIXME?)
    numSorted = level.numConnectedClients
    if numSorted > 32 {
        numSorted = 32
    }

    if g_gametype.integer >= GT_TEAM {
        G_LogPrintf("red:%i  blue:%i\n", level.teamScores[TEAM_RED], level.teamScores[TEAM_BLUE])
    }

    i = 0
    while i < numSorted {
        var ping: Int32

        cl = level.clientsSlots[level.sortedClients[i]]

        if cl!.sess.sessionTeam == TEAM_SPECTATOR {
            i += 1
            continue
        }
        if cl!.pers.connected == CON_CONNECTING {
            i += 1
            continue
        }

        ping = cl!.ps.ping < 999 ? cl!.ps.ping : 999

        G_LogPrintf("score: %i  ping: %i  client: %i %s\n", cl!.ps.persistant[PERS_SCORE], ping, level.sortedClients[i], cl!.pers.netname)
        //		if (g_singlePlayer.integer && (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL)) {
        //			if (g_entities[cl - level.clients].r.svFlags & SVF_BOT && cl->ps.persistant[PERS_RANK] == 0) {
        //				won = qfalse;
        //			}
        //		}
        i += 1
    }

    //yeah.. how about not.
    /*
    if (g_singlePlayer.integer) {
    if (g_gametype.integer >= GT_CTF) {
    won = level.teamScores[TEAM_RED] > level.teamScores[TEAM_BLUE];
    }
    trap_SendConsoleCommand( EXEC_APPEND, (won) ? "spWin\n" : "spLose\n" );
    }
    */
}

/**
```
=================
CheckIntermissionExit

The level will stay at the intermission for a minimum of 5 seconds
If all players wish to continue, the level will then exit.
If one or more players have not acknowledged the continue, the game will
wait 10 seconds before going on.
=================
```
*/
/// Source: oracle/codemp/game/g_main.c:2317
func CheckIntermissionExit() {
    var ready: Int32
    var notReady: Int32
    var i: Int32
    var cl: Client?
    var readyMask: Int32

    // see which players are ready
    ready = 0
    notReady = 0
    readyMask = 0
    i = 0
    while i < g_maxclients.integer {
        cl = level.clientsSlots[i]
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if (g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0 {
            i += 1
            continue
        }

        if cl!.readyToExit {
            ready += 1
            if i < 16 {
                readyMask |= 1 << i
            }
        } else {
            notReady += 1
        }
        i += 1
    }

    if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && !gDidDuelStuff && (level.time > level.intermissiontime + 2000) {
        gDidDuelStuff = true

        if g_austrian.integer != 0 && g_gametype.integer != GT_POWERDUEL {
            G_LogPrintf("Duel Results:\n")
            //G_LogPrintf("Duel Time: %d\n", level.time );
            G_LogPrintf("winner: %s, score: %d, wins/losses: %d/%d\n", level.clientsSlots[level.sortedClients[0]].pers.netname, level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE], level.clientsSlots[level.sortedClients[0]].sess.wins, level.clientsSlots[level.sortedClients[0]].sess.losses)
            G_LogPrintf("loser: %s, score: %d, wins/losses: %d/%d\n", level.clientsSlots[level.sortedClients[1]].pers.netname, level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE], level.clientsSlots[level.sortedClients[1]].sess.wins, level.clientsSlots[level.sortedClients[1]].sess.losses)
        }
        // if we are running a tournement map, kick the loser to spectator status,
        // which will automatically grab the next spectator and restart
        if !DuelLimitHit() {
            if g_gametype.integer == GT_POWERDUEL {
                RemovePowerDuelLosers()
                AddPowerDuelPlayers()
            } else {
                if level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE] == level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE] && level.clientsSlots[level.sortedClients[0]].pers.connected == CON_CONNECTED && level.clientsSlots[level.sortedClients[1]].pers.connected == CON_CONNECTED {
                    RemoveDuelDrawLoser()
                } else {
                    RemoveTournamentLoser()
                }
                AddTournamentPlayer()
            }

            if g_austrian.integer != 0 {
                if g_gametype.integer == GT_POWERDUEL {
                    G_LogPrintf("Power Duel Initiated: %s %d/%d vs %s %d/%d and %s %d/%d, kill limit: %d\n", level.clientsSlots[level.sortedClients[0]].pers.netname, level.clientsSlots[level.sortedClients[0]].sess.wins, level.clientsSlots[level.sortedClients[0]].sess.losses, level.clientsSlots[level.sortedClients[1]].pers.netname, level.clientsSlots[level.sortedClients[1]].sess.wins, level.clientsSlots[level.sortedClients[1]].sess.losses, level.clientsSlots[level.sortedClients[2]].pers.netname, level.clientsSlots[level.sortedClients[2]].sess.wins, level.clientsSlots[level.sortedClients[2]].sess.losses, g_fraglimit.integer)
                } else {
                    G_LogPrintf("Duel Initiated: %s %d/%d vs %s %d/%d, kill limit: %d\n", level.clientsSlots[level.sortedClients[0]].pers.netname, level.clientsSlots[level.sortedClients[0]].sess.wins, level.clientsSlots[level.sortedClients[0]].sess.losses, level.clientsSlots[level.sortedClients[1]].pers.netname, level.clientsSlots[level.sortedClients[1]].sess.wins, level.clientsSlots[level.sortedClients[1]].sess.losses, g_fraglimit.integer)
                }
            }

            if g_gametype.integer == GT_POWERDUEL {
                if level.numPlayingClients >= 3 && level.numNonSpectatorClients >= 3 {
                    trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i|%i", level.sortedClients[0], level.sortedClients[1], level.sortedClients[2]))
                    trap_SetConfigstring(CS_CLIENT_DUELWINNER, "-1")
                }
            } else {
                if level.numPlayingClients >= 2 {
                    trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i", level.sortedClients[0], level.sortedClients[1]))
                    trap_SetConfigstring(CS_CLIENT_DUELWINNER, "-1")
                }
            }

            return
        }

        if g_austrian.integer != 0 && g_gametype.integer != GT_POWERDUEL {
            G_LogPrintf("Duel Tournament Winner: %s wins/losses: %d/%d\n", level.clientsSlots[level.sortedClients[0]].pers.netname, level.clientsSlots[level.sortedClients[0]].sess.wins, level.clientsSlots[level.sortedClients[0]].sess.losses)
        }

        if g_gametype.integer == GT_POWERDUEL {
            RemovePowerDuelLosers()
            AddPowerDuelPlayers()

            if level.numPlayingClients >= 3 && level.numNonSpectatorClients >= 3 {
                trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i|%i", level.sortedClients[0], level.sortedClients[1], level.sortedClients[2]))
                trap_SetConfigstring(CS_CLIENT_DUELWINNER, "-1")
            }
        } else {
            //this means we hit the duel limit so reset the wins/losses
            //but still push the loser to the back of the line, and retain the order for
            //the map change
            if level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE] == level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE] && level.clientsSlots[level.sortedClients[0]].pers.connected == CON_CONNECTED && level.clientsSlots[level.sortedClients[1]].pers.connected == CON_CONNECTED {
                RemoveDuelDrawLoser()
            } else {
                RemoveTournamentLoser()
            }

            AddTournamentPlayer()

            if level.numPlayingClients >= 2 {
                trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i", level.sortedClients[0], level.sortedClients[1]))
                trap_SetConfigstring(CS_CLIENT_DUELWINNER, "-1")
            }
        }
    }

    if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && !gDuelExit {
        //in duel, we have different behaviour for between-round intermissions
        if level.time > level.intermissiontime + 4000 {
            //automatically go to next after 4 seconds
            ExitLevel()
            return
        }

        i = 0
        while i < g_maxclients.integer {
            //being in a "ready" state is not necessary here, so clear it for everyone
            //yes, I also thinking holding this in a ps value uniquely for each player
            //is bad and wrong, but it wasn't my idea.
            cl = level.clientsSlots[i]
            if cl!.pers.connected != CON_CONNECTED {
                i += 1
                continue
            }
            cl!.ps.stats[STAT_CLIENTS_READY] = 0
            i += 1
        }
        return
    }

    // copy the readyMask to each player's stats so
    // it can be displayed on the scoreboard
    i = 0
    while i < g_maxclients.integer {
        cl = level.clientsSlots[i]
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        cl!.ps.stats[STAT_CLIENTS_READY] = readyMask
        i += 1
    }

    // never exit in less than five seconds
    if level.time < level.intermissiontime + 5000 {
        return
    }

    if d_noIntermissionWait.integer != 0 {
        //don't care who wants to go, just go.
        ExitLevel()
        return
    }

    // if nobody wants to go, clear timer
    if ready == 0 {
        level.readyToExit = false
        return
    }

    // if everyone wants to go, go now
    if notReady == 0 {
        ExitLevel()
        return
    }

    // the first person to ready starts the ten second timeout
    if !level.readyToExit {
        level.readyToExit = true
        level.exitTime = level.time
    }

    // if we have waited ten seconds since at least one player
    // wanted to exit, go ahead
    if level.time < level.exitTime + 10000 {
        return
    }

    ExitLevel()
}

/**
```
=============
ScoreIsTied
=============
```
*/
/// Source: oracle/codemp/game/g_main.c:2561
func ScoreIsTied() -> Bool {
    let a: Int32
    let b: Int32

    if level.numPlayingClients < 2 {
        return false
    }

    if g_gametype.integer >= GT_TEAM {
        return level.teamScores[TEAM_RED] == level.teamScores[TEAM_BLUE]
    }

    a = level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE]
    b = level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE]

    return a == b
}

/// Source: oracle/codemp/game/g_main.c:2588
func CheckExitRules() {
    var i: Int32
    var cl: Client?
    var sKillLimit: String
    var printLimit: Bool = true
    // if at the intermission, wait for all non-bots to
    // signal ready, then go to next level
    if level.intermissiontime != 0 {
        CheckIntermissionExit()
        return
    }

    if gDoSlowMoDuel {
        //don't go to intermission while in slow motion
        return
    }

    if gEscaping {
        var i: Int32 = 0
        var numLiveClients: Int32 = 0

        while i < MAX_CLIENTS {
            if g_entities[i].inuse && g_entities[i].client != nil && g_entities[i].health > 0 {
                if g_entities[i].client!.sess.sessionTeam != TEAM_SPECTATOR && !((g_entities[i].client!.ps.pm_flags & PMF_FOLLOW) != 0) {
                    numLiveClients += 1
                }
            }

            i += 1
        }
        if gEscapeTime < level.time {
            gEscaping = false
            LogExit("Escape time ended.")
            return
        }
        if numLiveClients == 0 {
            gEscaping = false
            LogExit("Everyone failed to escape.")
            return
        }
    }

    if level.intermissionQueued != 0 {
        //int time = (g_singlePlayer.integer) ? SP_INTERMISSION_DELAY_TIME : INTERMISSION_DELAY_TIME;
        let time: Int32 = INTERMISSION_DELAY_TIME
        if level.time - level.intermissionQueued >= time {
            level.intermissionQueued = 0
            BeginIntermission()
        }
        return
    }

    /*
    if (g_gametype.integer == GT_POWERDUEL)
    {
    if (level.numPlayingClients < 3)
    {
    if (!level.intermissiontime)
    {
    if (d_powerDuelPrint.integer)
    {
    Com_Printf("POWERDUEL WIN CONDITION: Duel forfeit (1)\n");
    }
    LogExit("Duel forfeit.");
    return;
    }
    }
    }
    */

    // check for sudden death
    if g_gametype.integer != GT_SIEGE {
        if ScoreIsTied() {
            // always wait for sudden death
            if (g_gametype.integer != GT_DUEL) || g_timelimit.integer == 0 {
                if g_gametype.integer != GT_POWERDUEL {
                    return
                }
            }
        }
    }

    if g_gametype.integer != GT_SIEGE {
        if g_timelimit.integer != 0 && level.warmupTime == 0 {
            if level.time - level.startTime >= g_timelimit.integer * 60000 {
                //				trap_SendServerCommand( -1, "print \"Timelimit hit.\n\"");
                trap_SendServerCommand(-1, va("print \"%s.\n\"", G_GetStringEdString("MP_SVGAME", "TIMELIMIT_HIT")))
                if d_powerDuelPrint.integer != 0 {
                    Com_Printf("POWERDUEL WIN CONDITION: Timelimit hit (1)\n")
                }
                LogExit("Timelimit hit.")
                return
            }
        }
    }

    if g_gametype.integer == GT_POWERDUEL && level.numPlayingClients >= 3 {
        if g_endPDuel {
            g_endPDuel = false
            LogExit("Powerduel ended.")
        }

        //yeah, this stuff was completely insane.
        /*
        int duelists[3];
        duelists[0] = level.sortedClients[0];
        duelists[1] = level.sortedClients[1];
        duelists[2] = level.sortedClients[2];

        if (duelists[0] != -1 &&
        duelists[1] != -1 &&
        duelists[2] != -1)
        {
        if (!g_entities[duelists[0]].inuse ||
        !g_entities[duelists[0]].client ||
        g_entities[duelists[0]].client->ps.stats[STAT_HEALTH] <= 0 ||
        g_entities[duelists[0]].client->sess.sessionTeam != TEAM_FREE)
        { //The lone duelist lost, give the other two wins (if applicable) and him a loss
        if (g_entities[duelists[0]].inuse &&
        g_entities[duelists[0]].client)
        {
        g_entities[duelists[0]].client->sess.losses++;
        ClientUserinfoChanged(duelists[0]);
        }
        if (g_entities[duelists[1]].inuse &&
        g_entities[duelists[1]].client)
        {
        if (g_entities[duelists[1]].client->ps.stats[STAT_HEALTH] > 0 &&
        g_entities[duelists[1]].client->sess.sessionTeam == TEAM_FREE)
        {
        g_entities[duelists[1]].client->sess.wins++;
        }
        else
        {
        g_entities[duelists[1]].client->sess.losses++;
        }
        ClientUserinfoChanged(duelists[1]);
        }
        if (g_entities[duelists[2]].inuse &&
        g_entities[duelists[2]].client)
        {
        if (g_entities[duelists[2]].client->ps.stats[STAT_HEALTH] > 0 &&
        g_entities[duelists[2]].client->sess.sessionTeam == TEAM_FREE)
        {
        g_entities[duelists[2]].client->sess.wins++;
        }
        else
        {
        g_entities[duelists[2]].client->sess.losses++;
        }
        ClientUserinfoChanged(duelists[2]);
        }

        //Will want to parse indecies for two out at some point probably
        trap_SetConfigstring ( CS_CLIENT_DUELWINNER, va("%i", duelists[1] ) );

        if (d_powerDuelPrint.integer)
        {
        Com_Printf("POWERDUEL WIN CONDITION: Coupled duelists won (1)\n");
        }
        LogExit( "Coupled duelists won." );
        gDuelExit = qfalse;
        }
        else if ((!g_entities[duelists[1]].inuse ||
        !g_entities[duelists[1]].client ||
        g_entities[duelists[1]].client->sess.sessionTeam != TEAM_FREE ||
        g_entities[duelists[1]].client->ps.stats[STAT_HEALTH] <= 0) &&
        (!g_entities[duelists[2]].inuse ||
        !g_entities[duelists[2]].client ||
        g_entities[duelists[2]].client->sess.sessionTeam != TEAM_FREE ||
        g_entities[duelists[2]].client->ps.stats[STAT_HEALTH] <= 0))
        { //the coupled duelists lost, give the lone duelist a win (if applicable) and the couple both losses
        if (g_entities[duelists[1]].inuse &&
        g_entities[duelists[1]].client)
        {
        g_entities[duelists[1]].client->sess.losses++;
        ClientUserinfoChanged(duelists[1]);
        }
        if (g_entities[duelists[2]].inuse &&
        g_entities[duelists[2]].client)
        {
        g_entities[duelists[2]].client->sess.losses++;
        ClientUserinfoChanged(duelists[2]);
        }

        if (g_entities[duelists[0]].inuse &&
        g_entities[duelists[0]].client &&
        g_entities[duelists[0]].client->ps.stats[STAT_HEALTH] > 0 &&
        g_entities[duelists[0]].client->sess.sessionTeam == TEAM_FREE)
        {
        g_entities[duelists[0]].client->sess.wins++;
        ClientUserinfoChanged(duelists[0]);
        }

        trap_SetConfigstring ( CS_CLIENT_DUELWINNER, va("%i", duelists[0] ) );

        if (d_powerDuelPrint.integer)
        {
        Com_Printf("POWERDUEL WIN CONDITION: Lone duelist won (1)\n");
        }
        LogExit( "Lone duelist won." );
        gDuelExit = qfalse;
        }
        }
        */
        return
    }

    if level.numPlayingClients < 2 {
        return
    }

    if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
        if g_fraglimit.integer > 1 {
            sKillLimit = "Kill limit hit."
        } else {
            sKillLimit = ""
            printLimit = false
        }
    } else {
        sKillLimit = "Kill limit hit."
    }
    if g_gametype.integer < GT_SIEGE && g_fraglimit.integer != 0 {
        if level.teamScores[TEAM_RED] >= g_fraglimit.integer {
            trap_SendServerCommand(-1, va("print \"Red %s\n\"", G_GetStringEdString("MP_SVGAME", "HIT_THE_KILL_LIMIT")))
            if d_powerDuelPrint.integer != 0 {
                Com_Printf("POWERDUEL WIN CONDITION: Kill limit (1)\n")
            }
            LogExit(sKillLimit)
            return
        }

        if level.teamScores[TEAM_BLUE] >= g_fraglimit.integer {
            trap_SendServerCommand(-1, va("print \"Blue %s\n\"", G_GetStringEdString("MP_SVGAME", "HIT_THE_KILL_LIMIT")))
            if d_powerDuelPrint.integer != 0 {
                Com_Printf("POWERDUEL WIN CONDITION: Kill limit (2)\n")
            }
            LogExit(sKillLimit)
            return
        }

        i = 0
        while i < g_maxclients.integer {
            cl = level.clientsSlots[i]
            if cl!.pers.connected != CON_CONNECTED {
                i += 1
                continue
            }
            if cl!.sess.sessionTeam != TEAM_FREE {
                i += 1
                continue
            }

            if (g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL) && g_duel_fraglimit.integer != 0 && cl!.sess.wins >= g_duel_fraglimit.integer {
                if d_powerDuelPrint.integer != 0 {
                    Com_Printf("POWERDUEL WIN CONDITION: Duel limit hit (1)\n")
                }
                LogExit("Duel limit hit.")
                gDuelExit = true
                trap_SendServerCommand(-1, va("print \"%s" + S_COLOR_WHITE + " hit the win limit.\n\"", cl!.pers.netname))
                return
            }

            if cl!.ps.persistant[PERS_SCORE] >= g_fraglimit.integer {
                if d_powerDuelPrint.integer != 0 {
                    Com_Printf("POWERDUEL WIN CONDITION: Kill limit (3)\n")
                }
                LogExit(sKillLimit)
                gDuelExit = false
                if printLimit {
                    trap_SendServerCommand(-1, va("print \"%s" + S_COLOR_WHITE + " %s.\n\"", cl!.pers.netname, G_GetStringEdString("MP_SVGAME", "HIT_THE_KILL_LIMIT")))
                }
                return
            }
            i += 1
        }
    }

    if g_gametype.integer >= GT_CTF && g_capturelimit.integer != 0 {
        if level.teamScores[TEAM_RED] >= g_capturelimit.integer {
            trap_SendServerCommand(-1, va("print \"%s \"", G_GetStringEdString("MP_SVGAME", "PRINTREDTEAM")))
            trap_SendServerCommand(-1, va("print \"%s.\n\"", G_GetStringEdString("MP_SVGAME", "HIT_CAPTURE_LIMIT")))
            LogExit("Capturelimit hit.")
            return
        }

        if level.teamScores[TEAM_BLUE] >= g_capturelimit.integer {
            trap_SendServerCommand(-1, va("print \"%s \"", G_GetStringEdString("MP_SVGAME", "PRINTBLUETEAM")))
            trap_SendServerCommand(-1, va("print \"%s.\n\"", G_GetStringEdString("MP_SVGAME", "HIT_CAPTURE_LIMIT")))
            LogExit("Capturelimit hit.")
            return
        }
    }
}

/// Source: oracle/codemp/game/g_main.c:2923
func G_RemoveDuelist(_ team: Int32) {
    var i: Int32 = 0
    var ent: Entity?
    while i < MAX_CLIENTS {
        ent = g_entities[i]

        if ent!.inuse && ent!.client != nil && ent!.client!.sess.sessionTeam != TEAM_SPECTATOR && ent!.client!.sess.duelTeam == team {
            SetTeam(ent!, "s")
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_main.c:2948
func CheckTournament() {
    // check because we run 3 game frames before calling Connect and/or ClientBegin
    // for clients on a map_restart
    //	if ( level.numPlayingClients == 0 && (g_gametype.integer != GT_POWERDUEL) ) {
    //		return;
    //	}

    if g_gametype.integer == GT_POWERDUEL {
        if level.numPlayingClients >= 3 && level.numNonSpectatorClients >= 3 {
            trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i|%i", level.sortedClients[0], level.sortedClients[1], level.sortedClients[2]))
        }
    } else {
        if level.numPlayingClients >= 2 {
            trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i", level.sortedClients[0], level.sortedClients[1]))
        }
    }

    if g_gametype.integer == GT_DUEL {
        // pull in a spectator if needed
        if level.numPlayingClients < 2 && level.intermissiontime == 0 && level.intermissionQueued == 0 {
            AddTournamentPlayer()

            if level.numPlayingClients >= 2 {
                trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i", level.sortedClients[0], level.sortedClients[1]))
            }
        }

        if level.numPlayingClients >= 2 {
            // nmckenzie: DUEL_HEALTH
            if g_showDuelHealths.integer >= 1 {
                var ps1: PlayerState?
                var ps2: PlayerState?
                ps1 = level.clientsSlots[level.sortedClients[0]].ps
                ps2 = level.clientsSlots[level.sortedClients[1]].ps
                trap_SetConfigstring(CS_CLIENT_DUELHEALTHS, va("%i|%i|!", ps1!.stats[STAT_HEALTH], ps2!.stats[STAT_HEALTH]))
            }
        }

        //rww - It seems we have decided there will be no warmup in duel.
        //if (!g_warmup.integer)
        do {
            //don't care about any of this stuff then, just add people and leave me alone
            level.warmupTime = 0
            return
        }
        // if we don't have two players, go back to "waiting for players"


        // if the warmup is changed at the console, restart it

        // if all players have arrived, start the countdown
        // fudge by -1 to account for extra delays


        // if the warmup time has counted down, restart
    } else if g_gametype.integer == GT_POWERDUEL {
        if level.numPlayingClients < 2 {
            //hmm, ok, pull more in.
            g_dontFrickinCheck = false
        }

        if level.numPlayingClients > 3 {
            //umm..yes..lets take care of that then.
            var lone: Int32 = 0
            var dbl: Int32 = 0

            G_PowerDuelCount(&lone, &dbl, false)
            if lone > 1 {
                G_RemoveDuelist(DUELTEAM_LONE)
            } else if dbl > 2 {
                G_RemoveDuelist(DUELTEAM_DOUBLE)
            }
        } else if level.numPlayingClients < 3 {
            //hmm, someone disconnected or something and we need em
            var lone: Int32 = 0
            var dbl: Int32 = 0

            G_PowerDuelCount(&lone, &dbl, false)
            if lone < 1 {
                g_dontFrickinCheck = false
            } else if dbl < 1 {
                g_dontFrickinCheck = false
            }
        }

        // pull in a spectator if needed
        if level.numPlayingClients < 3 && !g_dontFrickinCheck {
            AddPowerDuelPlayers()

            if level.numPlayingClients >= 3 && G_CanResetDuelists() {
                let te: Entity? = G_TempEntity(vec3_origin, EV_GLOBAL_DUEL)
                te!.r.svFlags |= SVF_BROADCAST
                //this is really pretty nasty, but..
                te!.s.otherEntityNum = level.sortedClients[0]
                te!.s.otherEntityNum2 = level.sortedClients[1]
                te!.s.groundEntityNum = level.sortedClients[2]

                trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i|%i", level.sortedClients[0], level.sortedClients[1], level.sortedClients[2]))
                G_ResetDuelists()

                g_dontFrickinCheck = true
            } else if level.numPlayingClients > 0 || level.numConnectedClients > 0 {
                if g_duelPrintTimer < level.time {
                    //print once every 10 seconds
                    var lone: Int32 = 0
                    var dbl: Int32 = 0

                    G_PowerDuelCount(&lone, &dbl, true)
                    if lone < 1 {
                        trap_SendServerCommand(-1, va("cp \"%s\n\"", G_GetStringEdString("MP_SVGAME", "DUELMORESINGLE")))
                    } else {
                        trap_SendServerCommand(-1, va("cp \"%s\n\"", G_GetStringEdString("MP_SVGAME", "DUELMOREPAIRED")))
                    }
                    g_duelPrintTimer = level.time + 10000
                }
            }

            if level.numPlayingClients >= 3 && level.numNonSpectatorClients >= 3 {
                //pulled in a needed person
                if G_CanResetDuelists() {
                    let te: Entity? = G_TempEntity(vec3_origin, EV_GLOBAL_DUEL)
                    te!.r.svFlags |= SVF_BROADCAST
                    //this is really pretty nasty, but..
                    te!.s.otherEntityNum = level.sortedClients[0]
                    te!.s.otherEntityNum2 = level.sortedClients[1]
                    te!.s.groundEntityNum = level.sortedClients[2]

                    trap_SetConfigstring(CS_CLIENT_DUELISTS, va("%i|%i|%i", level.sortedClients[0], level.sortedClients[1], level.sortedClients[2]))

                    if g_austrian.integer != 0 {
                        G_LogPrintf("Duel Initiated: %s %d/%d vs %s %d/%d and %s %d/%d, kill limit: %d\n", level.clientsSlots[level.sortedClients[0]].pers.netname, level.clientsSlots[level.sortedClients[0]].sess.wins, level.clientsSlots[level.sortedClients[0]].sess.losses, level.clientsSlots[level.sortedClients[1]].pers.netname, level.clientsSlots[level.sortedClients[1]].sess.wins, level.clientsSlots[level.sortedClients[1]].sess.losses, level.clientsSlots[level.sortedClients[2]].pers.netname, level.clientsSlots[level.sortedClients[2]].sess.wins, level.clientsSlots[level.sortedClients[2]].sess.losses, g_fraglimit.integer)
                    }
                    //trap_SendConsoleCommand( EXEC_APPEND, "map_restart 0\n" );
                    //FIXME: This seems to cause problems. But we'd like to reset things whenever a new opponent is set.
                }
            }
        } else {
            //if you have proper num of players then don't try to add again
            g_dontFrickinCheck = true
        }

        level.warmupTime = 0
        return
    } else if level.warmupTime != 0 {
        var counts: [Int32] = [Int32](repeating: 0, count: 4)
        var notEnough: Bool = false

        if g_gametype.integer > GT_TEAM {
            counts[TEAM_BLUE] = TeamCount(-1, TEAM_BLUE)
            counts[TEAM_RED] = TeamCount(-1, TEAM_RED)

            if counts[TEAM_RED] < 1 || counts[TEAM_BLUE] < 1 {
                notEnough = true
            }
        } else if level.numPlayingClients < 2 {
            notEnough = true
        }

        if notEnough {
            if level.warmupTime != -1 {
                level.warmupTime = -1
                trap_SetConfigstring(CS_WARMUP, va("%i", level.warmupTime))
                G_LogPrintf("Warmup:\n")
            }
            return // still waiting for team members
        }

        if level.warmupTime == 0 {
            return
        }

        // if the warmup is changed at the console, restart it
        /*
        if ( g_warmup.modificationCount != level.warmupModificationCount ) {
        level.warmupModificationCount = g_warmup.modificationCount;
        level.warmupTime = -1;
        }
        */

        // if all players have arrived, start the countdown
        if level.warmupTime < 0 {
            // fudge by -1 to account for extra delays
            level.warmupTime = level.time + (g_warmup.integer - 1) * 1000
            trap_SetConfigstring(CS_WARMUP, va("%i", level.warmupTime))
            return
        }

        // if the warmup time has counted down, restart
        if level.time > level.warmupTime {
            level.warmupTime += 10000
            trap_Cvar_Set("g_restarted", "1")
            trap_SendConsoleCommand(EXEC_APPEND, "map_restart 0\n")
            level.restarted = true
            return
        }
    }
}

/// Source: oracle/codemp/game/g_main.c:3218
func G_KickAllBots() {
    var i: Int32
    var netname = CharBuf(36)
    var cl: Client?

    i = 0
    while i < g_maxclients.integer {
        cl = level.clientsSlots[i]
        if cl!.pers.connected != CON_CONNECTED {
            i += 1
            continue
        }
        if !((g_entities[cl!.ps.clientNum].r.svFlags & SVF_BOT) != 0) {
            i += 1
            continue
        }
        strcpy(&netname, cl!.pers.netname)
        Q_CleanStr(&netname)
        trap_SendConsoleCommand(EXEC_INSERT, va("kick \"%s\"\n", netname))
        i += 1
    }
}

/**
```
==================
CheckVote
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:3246
func CheckVote() {
    if level.voteExecuteTime != 0 && level.voteExecuteTime < level.time {
        level.voteExecuteTime = 0
        trap_SendConsoleCommand(EXEC_APPEND, va("%s\n", level.voteString))

        if level.votingGametype {
            if trap_Cvar_VariableIntegerValue("g_gametype") != level.votingGametypeTo {
                //If we're voting to a different game type, be sure to refresh all the map stuff
                var nextMap: String? = G_RefreshNextMap(level.votingGametypeTo, true)

                if level.votingGametypeTo == GT_SIEGE {
                    //ok, kick all the bots, cause the aren't supported!
                    G_KickAllBots()
                    //just in case, set this to 0 too... I guess...maybe?
                    //trap_Cvar_Set("bot_minplayers", "0");
                }

                if nextMap != nil && !nextMap!.isEmpty {
                    trap_SendConsoleCommand(EXEC_APPEND, va("map %s\n", nextMap!))
                }
            } else {
                //otherwise, just leave the map until a restart
                G_RefreshNextMap(level.votingGametypeTo, false)
            }

            if g_fraglimitVoteCorrection.integer != 0 {
                //This means to auto-correct fraglimit when voting to and from duel.
                let currentGT: Int32 = trap_Cvar_VariableIntegerValue("g_gametype")
                let currentFL: Int32 = trap_Cvar_VariableIntegerValue("fraglimit")
                let currentTL: Int32 = trap_Cvar_VariableIntegerValue("timelimit")

                if (level.votingGametypeTo == GT_DUEL || level.votingGametypeTo == GT_POWERDUEL) && currentGT != GT_DUEL && currentGT != GT_POWERDUEL {
                    if currentFL > 3 || currentFL == 0 {
                        //if voting to duel, and fraglimit is more than 3 (or unlimited), then set it down to 3
                        trap_SendConsoleCommand(EXEC_APPEND, "fraglimit 3\n")
                    }
                    if currentTL != 0 {
                        //if voting to duel, and timelimit is set, make it unlimited
                        trap_SendConsoleCommand(EXEC_APPEND, "timelimit 0\n")
                    }
                } else if (level.votingGametypeTo != GT_DUEL && level.votingGametypeTo != GT_POWERDUEL) && (currentGT == GT_DUEL || currentGT == GT_POWERDUEL) {
                    if currentFL != 0 && currentFL < 20 {
                        //if voting from duel, an fraglimit is less than 20, then set it up to 20
                        trap_SendConsoleCommand(EXEC_APPEND, "fraglimit 20\n")
                    }
                }
            }

            level.votingGametype = false
            level.votingGametypeTo = 0
        }
    }
    if level.voteTime == 0 {
        return
    }
    if level.time - level.voteTime >= VOTE_TIME {
        trap_SendServerCommand(-1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "VOTEFAILED")))
    } else {
        if level.voteYes > level.numVotingClients / 2 {
            // execute the command, then remove the vote
            trap_SendServerCommand(-1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "VOTEPASSED")))
            level.voteExecuteTime = level.time + 3000
        } else if level.voteNo >= level.numVotingClients / 2 {
            // same behavior as a timeout
            trap_SendServerCommand(-1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "VOTEFAILED")))
        } else {
            // still waiting for a majority
            return
        }
    }
    level.voteTime = 0
    trap_SetConfigstring(CS_VOTE_TIME, "")
}

/**
```
==================
PrintTeam
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:3333
func PrintTeam(_ team: Int32, _ message: String) {
    var i: Int32

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].sess.sessionTeam != team {
            i += 1
            continue
        }
        trap_SendServerCommand(i, message)
        i += 1
    }
}

/**
```
==================
SetLeader
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:3348
func SetLeader(_ team: Int32, _ client: Int32) {
    var i: Int32

    if level.clientsSlots[client].pers.connected == CON_DISCONNECTED {
        PrintTeam(team, va("print \"%s is not connected\n\"", level.clientsSlots[client].pers.netname))
        return
    }
    if level.clientsSlots[client].sess.sessionTeam != team {
        PrintTeam(team, va("print \"%s is not on the team anymore\n\"", level.clientsSlots[client].pers.netname))
        return
    }
    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].sess.sessionTeam != team {
            i += 1
            continue
        }
        if level.clientsSlots[i].sess.teamLeader {
            level.clientsSlots[i].sess.teamLeader = false
            ClientUserinfoChanged(i)
        }
        i += 1
    }
    level.clientsSlots[client].sess.teamLeader = true
    ClientUserinfoChanged(client)
    PrintTeam(team, va("print \"%s %s\n\"", level.clientsSlots[client].pers.netname, G_GetStringEdString("MP_SVGAME", "NEWTEAMLEADER")))
}

/**
```
==================
CheckTeamLeader
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:3377
func CheckTeamLeader(_ team: Int32) {
    var i: Int32

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].sess.sessionTeam != team {
            i += 1
            continue
        }
        if level.clientsSlots[i].sess.teamLeader {
            break
        }
        i += 1
    }
    if i >= level.maxclients {
        i = 0
        while i < level.maxclients {
            if level.clientsSlots[i].sess.sessionTeam != team {
                i += 1
                continue
            }
            if !((g_entities[i].r.svFlags & SVF_BOT) != 0) {
                level.clientsSlots[i].sess.teamLeader = true
                break
            }
            i += 1
        }
        i = 0
        while i < level.maxclients {
            if level.clientsSlots[i].sess.sessionTeam != team {
                i += 1
                continue
            }
            level.clientsSlots[i].sess.teamLeader = true
            break
            i += 1
        }
    }
}

/**
```
==================
CheckTeamVote
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:3409
func CheckTeamVote(_ team: Int32) {
    var cs_offset: Int32

    if team == TEAM_RED {
        cs_offset = 0
    } else if team == TEAM_BLUE {
        cs_offset = 1
    } else {
        return
    }

    if level.teamVoteTime[cs_offset] == 0 {
        return
    }
    if level.time - level.teamVoteTime[cs_offset] >= VOTE_TIME {
        trap_SendServerCommand(-1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TEAMVOTEFAILED")))
    } else {
        if level.teamVoteYes[cs_offset] > level.numteamVotingClients[cs_offset] / 2 {
            // execute the command, then remove the vote
            trap_SendServerCommand(-1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TEAMVOTEPASSED")))
            //
            if Q_strncmp("leader", level.teamVoteString[cs_offset], 6) == 0 {
                //set the team leader
                //SetLeader(team, atoi(level.teamVoteString[cs_offset] + 7));
            } else {
                trap_SendConsoleCommand(EXEC_APPEND, va("%s\n", level.teamVoteString[cs_offset]))
            }
        } else if level.teamVoteNo[cs_offset] >= level.numteamVotingClients[cs_offset] / 2 {
            // same behavior as a timeout
            trap_SendServerCommand(-1, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "TEAMVOTEFAILED")))
        } else {
            // still waiting for a majority
            return
        }
    }
    level.teamVoteTime[cs_offset] = 0
    trap_SetConfigstring(CS_TEAMVOTE_TIME + cs_offset, "")
}

/// Raven's `static int lastMod` of `CheckCvars`, a property of `GameWorld`.
/// Source: oracle/codemp/game/g_main.c:3456
var lastMod: Int32 {
    get { world.lastMod }
    set { world.lastMod = newValue }
}

/**
```
==================
CheckCvars
==================
```
*/
/// Source: oracle/codemp/game/g_main.c:3455
func CheckCvars() {
    if g_password.modificationCount != lastMod {
        var password = CharBuf(MAX_INFO_STRING)
        var c: Int32 = 0
        lastMod = g_password.modificationCount

        strcpy(&password, g_password.string)
        while password[c] != 0 {
            if password[c] == Int32(ascii: "%") {
                password[c] = Int32(ascii: ".")
            }
            c += 1
        }
        trap_Cvar_Set("g_password", String(password))

        if !g_password.string.isEmpty && Q_stricmp(g_password.string, "none") != 0 {
            trap_Cvar_Set("g_needpass", "1")
        } else {
            trap_Cvar_Set("g_needpass", "0")
        }
    }
}

/**
```
=============
G_RunThink

Runs thinking code for this frame if necessary
=============
```
*/
/// Source: oracle/codemp/game/g_main.c:3489
func G_RunThink(_ ent: Entity) {
    let thinktime: Float

    runicarus: do {
        thinktime = Float(ent.nextthink)
        if thinktime <= 0 {
            break runicarus
        }
        if thinktime > level.time {
            break runicarus
        }

        ent.nextthink = 0
        if ent.think == nil {
            //G_Error ( "NULL ent->think");
            break runicarus
        }
        ent.runThink()

    }
    if ent.inuse {
        trap_ICARUS_MaintainTaskManager(ent.s.number)
    }
}

/// Source: oracle/codemp/game/g_main.c:3522
func NAV_CheckCalcPaths() {
    if navCalcPathTime != 0 && navCalcPathTime < level.time {
        //first time we've ever loaded this map...
        // Raven's record lives to the end of his block, so the block is the closure.
        VmCvar.scratch { mapname in
            // Raven's record lives to the end of his block, so the block is the closure.
            VmCvar.scratch { ckSum in

                trap_Cvar_Register(mapname, "mapname", "", CVAR_SERVERINFO | CVAR_ROM)
                trap_Cvar_Register(ckSum, "sv_mapChecksum", "", CVAR_ROM)

                //clear all the failed edges
                trap_Nav_ClearAllFailedEdges()

                //Calculate all paths
                NAV_CalculatePaths(mapname.string, ckSum.integer)

                trap_Nav_CalculatePaths(false)

                if fatalErrors != 0 {
                    Com_Printf(S_COLOR_RED + "Not saving .nav file due to fatal nav errors\n")
                } else if trap_Nav_Save(mapname.string, ckSum.integer) == false {
                    Com_Printf("Unable to save navigations data for map \"%s\" (checksum:%d)\n", mapname.string, ckSum.integer)
                }
                navCalcPathTime = 0
            }
        }
    }
}

/// Source: oracle/codemp/game/g_main.c:3559
func BG_GetTime() -> Int32 {
    return level.time
}

/// Source: oracle/codemp/game/g_main.c:3582
public func G_RunFrame(_ levelTime: Int32) {
    var i: Int32
    var entIndex: Int32 = 0
    let msec: Int32

    if g_gametype.integer == GT_SIEGE && g_siegeRespawn.integer != 0 && g_siegeRespawnCheck < level.time {
        //check for a respawn wave
        var i: Int32 = 0
        var clEnt: Entity?
        while i < MAX_CLIENTS {
            clEnt = g_entities[i]

            if clEnt!.inuse && clEnt!.client != nil && clEnt!.client!.tempSpectate > level.time && clEnt!.client!.sess.sessionTeam != TEAM_SPECTATOR {
                respawn(clEnt!)
                clEnt!.client!.tempSpectate = 0
            }
            i += 1
        }

        g_siegeRespawnCheck = level.time + g_siegeRespawn.integer * 1000
    }

    if gDoSlowMoDuel {
        if level.restarted {
            var buf = CharBuf(128)
            var tFVal: Float = 0

            strcpy(&buf, trap_Cvar_VariableStringBuffer("timescale", Int32((buf).count)))

            tFVal = Float(atof(buf))

            trap_Cvar_Set("timescale", "1")
            if tFVal == 1.0 {
                gDoSlowMoDuel = false
            }
        } else {
            let timeDif: Float = Float((level.time - gSlowMoDuelTime))
            var useDif: Float = 0

            if timeDif < 150 {
                trap_Cvar_Set("timescale", "0.1f")
            } else if timeDif < 1150 {
                useDif = (timeDif / 1000) //scale from 0.1 up to 1
                if Double(useDif) < 0.1 {
                    useDif = 0.1
                }
                if Double(useDif) > 1.0 {
                    useDif = 1.0
                }
                trap_Cvar_Set("timescale", va("%f", useDif))
            } else {
                var buf = CharBuf(128)
                var tFVal: Float = 0

                strcpy(&buf, trap_Cvar_VariableStringBuffer("timescale", Int32((buf).count)))

                tFVal = Float(atof(buf))

                trap_Cvar_Set("timescale", "1")
                if timeDif > 1500 && tFVal == 1.0 {
                    gDoSlowMoDuel = false
                }
            }
        }
    }

    // if we are waiting for the level to restart, do nothing
    if level.restarted {
        return
    }

    level.framenum += 1
    level.previousTime = level.time
    level.time = levelTime
    msec = level.time - level.previousTime

    if g_allowNPC.integer != 0 {
        NAV_CheckCalcPaths()
    }

    AI_UpdateGroups()

    if g_allowNPC.integer != 0 {
        if d_altRoutes.integer != 0 {
            trap_Nav_CheckAllFailedEdges()
        }
        trap_Nav_ClearCheckedNodes()

        //remember last waypoint, clear current one
        i = 0
        while i < level.num_entities {
            entIndex = i

            if !g_entities[entIndex].inuse {
                i += 1
                continue
            }

            if g_entities[entIndex].waypoint != WAYPOINT_NONE && g_entities[entIndex].noWaypointTime < level.time {
                g_entities[entIndex].lastWaypoint = g_entities[entIndex].waypoint
                g_entities[entIndex].waypoint = WAYPOINT_NONE
            }
            if d_altRoutes.integer != 0 {
                trap_Nav_CheckFailedNodes(g_entities[entIndex])
            }
            i += 1
        }

        //Look to clear out old events
        ClearPlayerAlertEvents()
    }

    g_TimeSinceLastFrame = (level.time - g_LastFrameTime)

    // get any cvar changes
    G_UpdateCvars()



    //
    // go through all allocated objects
    //
    entIndex = 0
    i = 0
    while i < level.num_entities {
        if !g_entities[entIndex].inuse {
            i += 1
            entIndex += 1
            continue
        }

        // clear events that are too old
        if level.time - g_entities[entIndex].eventTime > EVENT_VALID_MSEC {
            if g_entities[entIndex].s.event != 0 {
                g_entities[entIndex].s.event = 0 // &= EV_EVENT_BITS;
                if g_entities[entIndex].client != nil {
                    g_entities[entIndex].client!.ps.externalEvent = 0
                    // predicted events should never be set to zero
                    //ent->client->ps.events[0] = 0;
                    //ent->client->ps.events[1] = 0;
                }
            }
            if g_entities[entIndex].freeAfterEvent {
                // tempEntities or dropped items completely go away after their event
                if (g_entities[entIndex].s.eFlags & EF_SOUNDTRACKER) != 0 {
                    //don't trigger the event again..
                    g_entities[entIndex].s.event = 0
                    g_entities[entIndex].s.eventParm = 0
                    g_entities[entIndex].s.eType = 0
                    g_entities[entIndex].eventTime = 0
                } else {
                    G_FreeEntity(g_entities[entIndex])
                    i += 1
                    entIndex += 1
                    continue
                }
            } else if g_entities[entIndex].unlinkAfterEvent {
                // items that will respawn will hide themselves after their pickup event
                g_entities[entIndex].unlinkAfterEvent = false
                trap_UnlinkEntity(g_entities[entIndex])
            }
        }

        // temporary entities don't think
        if g_entities[entIndex].freeAfterEvent {
            i += 1
            entIndex += 1
            continue
        }

        if !g_entities[entIndex].r.linked && g_entities[entIndex].neverFree {
            i += 1
            entIndex += 1
            continue
        }

        if g_entities[entIndex].s.eType == ET_MISSILE {
            G_RunMissile(g_entities[entIndex])
            i += 1
            entIndex += 1
            continue
        }

        if g_entities[entIndex].s.eType == ET_ITEM || g_entities[entIndex].physicsObject {
            G_RunItem(g_entities[entIndex])
            i += 1
            entIndex += 1
            continue
        }

        if g_entities[entIndex].s.eType == ET_MOVER {
            G_RunMover(g_entities[entIndex])
            i += 1
            entIndex += 1
            continue
        }

        if i < MAX_CLIENTS {
            G_CheckClientTimeouts(g_entities[entIndex])

            if g_entities[entIndex].client!.inSpaceIndex != 0 && g_entities[entIndex].client!.inSpaceIndex != ENTITYNUM_NONE {
                //we're in space, check for suffocating and for exiting
                let spacetrigger: Entity? = g_entities[g_entities[entIndex].client!.inSpaceIndex]

                if !spacetrigger!.inuse || !G_PointInBounds(g_entities[entIndex].client!.ps.origin, spacetrigger!.r.absmin, spacetrigger!.r.absmax) {
                    //no longer in space then I suppose
                    g_entities[entIndex].client!.inSpaceIndex = 0
                } else {
                    //check for suffocation
                    if g_entities[entIndex].client!.inSpaceSuffocation < level.time {
                        //suffocate!
                        if g_entities[entIndex].health > 0 && g_entities[entIndex].takedamage {
                            //if they're still alive..
                            var dir: vec3_t? = nil
                            G_Damage(g_entities[entIndex], spacetrigger, spacetrigger, &dir, g_entities[entIndex].client!.ps.origin, Q_irand(50, 70), DAMAGE_NO_ARMOR, MOD_SUICIDE)

                            if g_entities[entIndex].health > 0 {
                                //did that last one kill them?
                                //play the choking sound
                                G_EntitySound(g_entities[entIndex], CHAN_VOICE, G_SoundIndex(va("*choke%d.wav", Q_irand(1, 3))))

                                //make them grasp their throat
                                g_entities[entIndex].client!.ps.forceHandExtend = HANDEXTEND_CHOKE
                                g_entities[entIndex].client!.ps.forceHandExtendTime = level.time + 2000
                            }
                        }

                        g_entities[entIndex].client!.inSpaceSuffocation = level.time + Q_irand(100, 200)
                    }
                }
            }

            if g_entities[entIndex].client!.isHacking != 0 {
                //hacking checks
                let hacked: Entity? = g_entities[g_entities[entIndex].client!.isHacking]
                var angDif = vec3_t()

                angDif = g_entities[entIndex].client!.ps.viewangles - g_entities[entIndex].client!.hackingAngles

                //keep him in the "use" anim
                if g_entities[entIndex].client!.ps.torsoAnim != BOTH_CONSOLE1 {
                    G_SetAnim(g_entities[entIndex], nil, SETANIM_TORSO, BOTH_CONSOLE1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)
                } else {
                    g_entities[entIndex].client!.ps.torsoTimer = 500
                }
                g_entities[entIndex].client!.ps.weaponTime = g_entities[entIndex].client!.ps.torsoTimer

                if !((g_entities[entIndex].client!.pers.cmd.buttons & BUTTON_USE) != 0) {
                    //have to keep holding use
                    g_entities[entIndex].client!.isHacking = 0
                    g_entities[entIndex].client!.ps.hackingTime = 0
                } else if hacked == nil || !hacked!.inuse {
                    //shouldn't happen, but safety first
                    g_entities[entIndex].client!.isHacking = 0
                    g_entities[entIndex].client!.ps.hackingTime = 0
                } else if !G_PointInBounds(g_entities[entIndex].client!.ps.origin, hacked!.r.absmin, hacked!.r.absmax) {
                    //they stepped outside the thing they're hacking, so reset hacking time
                    g_entities[entIndex].client!.isHacking = 0
                    g_entities[entIndex].client!.ps.hackingTime = 0
                } else if VectorLength(angDif) > 10.0 {
                    //must remain facing generally the same angle as when we start
                    g_entities[entIndex].client!.isHacking = 0
                    g_entities[entIndex].client!.ps.hackingTime = 0
                }
            }

            if g_entities[entIndex].client!.jetPackOn {
                //using jetpack, drain fuel
                if g_entities[entIndex].client!.jetPackDebReduce < level.time {
                    if g_entities[entIndex].client!.pers.cmd.upmove > 0 {
                        //take more if they're thrusting
                        g_entities[entIndex].client!.ps.jetpackFuel -= 2
                    } else {
                        g_entities[entIndex].client!.ps.jetpackFuel -= 1
                    }

                    if g_entities[entIndex].client!.ps.jetpackFuel <= 0 {
                        //turn it off
                        g_entities[entIndex].client!.ps.jetpackFuel = 0
                        Jetpack_Off(g_entities[entIndex])
                    }
                    g_entities[entIndex].client!.jetPackDebReduce = level.time + JETPACK_DEFUEL_RATE
                }
            } else if g_entities[entIndex].client!.ps.jetpackFuel < 100 {
                //recharge jetpack
                if g_entities[entIndex].client!.jetPackDebRecharge < level.time {
                    g_entities[entIndex].client!.ps.jetpackFuel += 1
                    g_entities[entIndex].client!.jetPackDebRecharge = level.time + JETPACK_REFUEL_RATE
                }
            }

            if g_entities[entIndex].client!.ps.powerups[PW_CLOAKED] != 0 {
                //using cloak, drain battery
                if g_entities[entIndex].client!.cloakDebReduce < level.time {
                    g_entities[entIndex].client!.ps.cloakFuel -= 1

                    if g_entities[entIndex].client!.ps.cloakFuel <= 0 {
                        //turn it off
                        g_entities[entIndex].client!.ps.cloakFuel = 0
                        Jedi_Decloak(g_entities[entIndex])
                    }
                    g_entities[entIndex].client!.cloakDebReduce = level.time + CLOAK_DEFUEL_RATE
                }
            } else if g_entities[entIndex].client!.ps.cloakFuel < 100 {
                //recharge cloak
                if g_entities[entIndex].client!.cloakDebRecharge < level.time {
                    g_entities[entIndex].client!.ps.cloakFuel += 1
                    g_entities[entIndex].client!.cloakDebRecharge = level.time + CLOAK_REFUEL_RATE
                }
            }

            if g_gametype.integer == GT_SIEGE && g_entities[entIndex].client!.siegeClass != -1 && (bgSiegeClasses[g_entities[entIndex].client!.siegeClass].classflags & (1 << CFL_STATVIEWER)) != 0 {
                //see if it's time to send this guy an update of extended info
                if g_entities[entIndex].client!.siegeEDataSend < level.time {
                    G_SiegeClientExData(g_entities[entIndex])
                    g_entities[entIndex].client!.siegeEDataSend = level.time + 1000 //once every sec seems ok
                }
            }

            if (level.intermissiontime == 0) && !((g_entities[entIndex].client!.ps.pm_flags & PMF_FOLLOW) != 0) && g_entities[entIndex].client!.sess.sessionTeam != TEAM_SPECTATOR {
                WP_ForcePowersUpdate(g_entities[entIndex], g_entities[entIndex].client!.pers.cmd)
                WP_SaberPositionUpdate(g_entities[entIndex], g_entities[entIndex].client!.pers.cmd)
                WP_SaberStartMissileBlockCheck(g_entities[entIndex], g_entities[entIndex].client!.pers.cmd)
            }

            if g_allowNPC.integer != 0 {
                //This was originally intended to only be done for client 0.
                //Make sure it doesn't slow things down too much with lots of clients in game.
                NAV_FindPlayerWaypoint(i)
            }

            trap_ICARUS_MaintainTaskManager(g_entities[entIndex].s.number)

            G_RunClient(g_entities[entIndex])
            i += 1
            entIndex += 1
            continue
        } else if g_entities[entIndex].s.eType == ET_NPC {
            var j: Int32
            // turn off any expired powerups
            j = 0
            while j < MAX_POWERUPS {
                if g_entities[entIndex].client!.ps.powerups[j] < level.time {
                    g_entities[entIndex].client!.ps.powerups[j] = 0
                }
                j += 1
            }

            WP_ForcePowersUpdate(g_entities[entIndex], g_entities[entIndex].client!.pers.cmd)
            WP_SaberPositionUpdate(g_entities[entIndex], g_entities[entIndex].client!.pers.cmd)
            WP_SaberStartMissileBlockCheck(g_entities[entIndex], g_entities[entIndex].client!.pers.cmd)
        }

        G_RunThink(g_entities[entIndex])

        if g_allowNPC.integer != 0 {
            ClearNPCGlobals()
        }
        i += 1
        entIndex += 1
    }

    SiegeCheckTimers()

    trap_ROFF_UpdateEntities()



    // perform final fixups on the players
    entIndex = 0
    i = 0
    while i < level.maxclients {
        if g_entities[entIndex].inuse {
            ClientEndFrame(g_entities[entIndex])
        }
        i += 1
        entIndex += 1
    }



    // see if it is time to do a tournement restart
    CheckTournament()

    // see if it is time to end the level
    CheckExitRules()

    // update to team status?
    CheckTeamStatus()

    // cancel vote if timed out
    CheckVote()

    // check team votes
    CheckTeamVote(TEAM_RED)
    CheckTeamVote(TEAM_BLUE)

    // for tracking changes
    CheckCvars()

    if g_listEntity.integer != 0 {
        i = 0
        while i < MAX_GENTITIES {
            G_Printf("%4i: %s\n", i, g_entities[i].classname!)
            i += 1
        }
        trap_Cvar_Set("g_listEntity", "0")
    }



    //At the end of the frame, send out the ghoul2 kill queue, if there is one
    G_SendG2KillQueue()

    if gQueueScoreMessage {
        if gQueueScoreMessageTime < level.time {
            SendScoreboardMessageToAllClients()

            gQueueScoreMessageTime = 0
            gQueueScoreMessage = 0 != 0
        }
    }




    g_LastFrameTime = level.time
}

/// Source: oracle/codemp/game/g_main.c:3895
let JETPACK_DEFUEL_RATE = 200 as Int32

/// Source: oracle/codemp/game/g_main.c:3896
let JETPACK_REFUEL_RATE = 150 as Int32

/// Source: oracle/codemp/game/g_main.c:3927
let CLOAK_DEFUEL_RATE = 200 as Int32

/// Source: oracle/codemp/game/g_main.c:3928
let CLOAK_REFUEL_RATE = 150 as Int32

/// Raven's `static char text[1024]` of `G_GetStringEdString`, a property of `GameWorld`.
/// Source: oracle/codemp/game/g_main.c:4117
var text: CharBuf {
    get { world.text }
    set { world.text = newValue }
}

/// Source: oracle/codemp/game/g_main.c:4104
func G_GetStringEdString(_ refSection: String, _ refName: String) -> String {
    /*
    static char text[1024]={0};
    trap_SP_GetStringTextString(va("%s_%s", refSection, refName), text, sizeof(text));
    return text;
    */

    //Well, it would've been lovely doing it the above way, but it would mean mixing
    //languages for the client depending on what the server is. So we'll mark this as
    //a stringed reference with @@@ and send the refname to the client, and when it goes
    //to print it will get scanned for the stringed reference indication and dealt with
    //properly.
    Com_sprintf(&text, Int32((text).count), "@@@%s", refName)
    return String(text)
}
