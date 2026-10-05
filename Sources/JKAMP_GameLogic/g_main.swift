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
var g_entities: Slots<Entity> { world.storage.g_entities }

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
var gSharedBuffer: JKAShared.CharBuf {
    get { world.variables.gSharedBuffer }
    set { world.variables.gSharedBuffer = newValue }
}

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
func vmMain(_ command: Int32, _ arg0: Int32, _ arg1: Int32, _ arg2: Int32, _ arg3: Int32, _ arg4: Int32, _ arg5: Int32, _ arg6: Int32, _ arg7: Int32, _ arg8: Int32, _ arg9: Int32, _ arg10: Int32, _ arg11: Int32) -> Int32 {
    // TODO: Port vmMain
    portMissing("vmMain", source: "oracle/codemp/game/g_main.c:515")
}

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
    // TODO: Port G_FindTeams
    portMissing("G_FindTeams", source: "oracle/codemp/game/g_main.c:736")
}

/// Source: oracle/codemp/game/g_main.c:783
func G_RemapTeamShaders() {
    // TODO: Port G_RemapTeamShaders
    portMissing("G_RemapTeamShaders", source: "oracle/codemp/game/g_main.c:783")
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
    // TODO: Port G_RegisterCvars
    portMissing("G_RegisterCvars", source: "oracle/codemp/game/g_main.c:803")
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
    // TODO: Port G_UpdateCvars
    portMissing("G_UpdateCvars", source: "oracle/codemp/game/g_main.c:852")
}

/// Source: oracle/codemp/game/g_main.c:897
func G_InitGame(_ levelTime: Int32, _ randomSeed: Int32, _ restart: Int32) {
    // TODO: Port G_InitGame
    portMissing("G_InitGame", source: "oracle/codemp/game/g_main.c:897")
}

/// Source: oracle/codemp/game/g_main.c:1128
func G_ShutdownGame(_ restart: Int32) {
    // TODO: Port G_ShutdownGame
    portMissing("G_ShutdownGame", source: "oracle/codemp/game/g_main.c:1128")
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
    // TODO: Port AddTournamentPlayer
    portMissing("AddTournamentPlayer", source: "oracle/codemp/game/g_main.c:1248")
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
    // TODO: Port RemoveTournamentLoser
    portMissing("RemoveTournamentLoser", source: "oracle/codemp/game/g_main.c:1304")
}

/// Source: oracle/codemp/game/g_main.c:1321
func G_PowerDuelCount(_ loners: inout Int32, _ doubles: inout Int32, _ countSpec: Bool) {
    // TODO: Port G_PowerDuelCount
    portMissing("G_PowerDuelCount", source: "oracle/codemp/game/g_main.c:1321")
}

/// Source: oracle/codemp/game/g_main.c:1346
func AddPowerDuelPlayers() {
    // TODO: Port AddPowerDuelPlayers
    portMissing("AddPowerDuelPlayers", source: "oracle/codemp/game/g_main.c:1346")
}

/// Source: oracle/codemp/game/g_main.c:1429
func RemovePowerDuelLosers() {
    // TODO: Port RemovePowerDuelLosers
    portMissing("RemovePowerDuelLosers", source: "oracle/codemp/game/g_main.c:1429")
}

/// Source: oracle/codemp/game/g_main.c:1473
func RemoveDuelDrawLoser() {
    // TODO: Port RemoveDuelDrawLoser
    portMissing("RemoveDuelDrawLoser", source: "oracle/codemp/game/g_main.c:1473")
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
    // TODO: Port RemoveTournamentWinner
    portMissing("RemoveTournamentWinner", source: "oracle/codemp/game/g_main.c:1519")
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
    // TODO: Port AdjustTournamentScores
    portMissing("AdjustTournamentScores", source: "oracle/codemp/game/g_main.c:1541")
}

/**
```
=============
SortRanks

=============
```
*/
/// Source: oracle/codemp/game/g_main.c:1624
func SortRanks(_ a: OpaquePointer?, _ b: OpaquePointer?) -> Int32 {
    // TODO: Port SortRanks
    portMissing("SortRanks", source: "oracle/codemp/game/g_main.c:1624")
}

//A new duel started so respawn everyone and make sure their stats are reset
/// Source: oracle/codemp/game/g_main.c:1695
func G_CanResetDuelists() -> Bool {
    // TODO: Port G_CanResetDuelists
    portMissing("G_CanResetDuelists", source: "oracle/codemp/game/g_main.c:1695")
}

/// Source: oracle/codemp/game/g_main.c:1718
func G_ResetDuelists() {
    // TODO: Port G_ResetDuelists
    portMissing("G_ResetDuelists", source: "oracle/codemp/game/g_main.c:1718")
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
    // TODO: Port CalculateRanks
    portMissing("CalculateRanks", source: "oracle/codemp/game/g_main.c:1751")
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
    // TODO: Port SendScoreboardMessageToAllClients
    portMissing("SendScoreboardMessageToAllClients", source: "oracle/codemp/game/g_main.c:1925")
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
    // TODO: Port MoveClientToIntermission
    portMissing("MoveClientToIntermission", source: "oracle/codemp/game/g_main.c:1943")
}

/// Source: oracle/codemp/game/g_main.c:1979
func FindIntermissionPoint() {
    // TODO: Port FindIntermissionPoint
    portMissing("FindIntermissionPoint", source: "oracle/codemp/game/g_main.c:1979")
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
    // TODO: Port BeginIntermission
    portMissing("BeginIntermission", source: "oracle/codemp/game/g_main.c:2035")
}

/// Source: oracle/codemp/game/g_main.c:2094
func DuelLimitHit() -> Bool {
    // TODO: Port DuelLimitHit
    portMissing("DuelLimitHit", source: "oracle/codemp/game/g_main.c:2094")
}

/// Source: oracle/codemp/game/g_main.c:2114
func DuelResetWinsLosses() {
    // TODO: Port DuelResetWinsLosses
    portMissing("DuelResetWinsLosses", source: "oracle/codemp/game/g_main.c:2114")
}

/// Source: oracle/codemp/game/g_main.c:2141
func ExitLevel() {
    // TODO: Port ExitLevel
    portMissing("ExitLevel", source: "oracle/codemp/game/g_main.c:2141")
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
    // TODO: Port G_LogPrintf
    portMissing("G_LogPrintf", source: "oracle/codemp/game/g_main.c:2213")
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
    // TODO: Port LogExit
    portMissing("LogExit", source: "oracle/codemp/game/g_main.c:2249")
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
    // TODO: Port CheckIntermissionExit
    portMissing("CheckIntermissionExit", source: "oracle/codemp/game/g_main.c:2317")
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
    // TODO: Port ScoreIsTied
    portMissing("ScoreIsTied", source: "oracle/codemp/game/g_main.c:2561")
}

/// Source: oracle/codemp/game/g_main.c:2588
func CheckExitRules() {
    // TODO: Port CheckExitRules
    portMissing("CheckExitRules", source: "oracle/codemp/game/g_main.c:2588")
}

/// Source: oracle/codemp/game/g_main.c:2923
func G_RemoveDuelist(_ team: Int32) {
    // TODO: Port G_RemoveDuelist
    portMissing("G_RemoveDuelist", source: "oracle/codemp/game/g_main.c:2923")
}

/// Source: oracle/codemp/game/g_main.c:2948
func CheckTournament() {
    // TODO: Port CheckTournament
    portMissing("CheckTournament", source: "oracle/codemp/game/g_main.c:2948")
}

/// Source: oracle/codemp/game/g_main.c:3218
func G_KickAllBots() {
    // TODO: Port G_KickAllBots
    portMissing("G_KickAllBots", source: "oracle/codemp/game/g_main.c:3218")
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
    // TODO: Port CheckVote
    portMissing("CheckVote", source: "oracle/codemp/game/g_main.c:3246")
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
    // TODO: Port PrintTeam
    portMissing("PrintTeam", source: "oracle/codemp/game/g_main.c:3333")
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
    // TODO: Port SetLeader
    portMissing("SetLeader", source: "oracle/codemp/game/g_main.c:3348")
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
    // TODO: Port CheckTeamLeader
    portMissing("CheckTeamLeader", source: "oracle/codemp/game/g_main.c:3377")
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
    // TODO: Port CheckTeamVote
    portMissing("CheckTeamVote", source: "oracle/codemp/game/g_main.c:3409")
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
    // TODO: Port CheckCvars
    portMissing("CheckCvars", source: "oracle/codemp/game/g_main.c:3455")
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
    // TODO: Port G_RunThink
    portMissing("G_RunThink", source: "oracle/codemp/game/g_main.c:3489")
}

/// Source: oracle/codemp/game/g_main.c:3522
func NAV_CheckCalcPaths() {
    // TODO: Port NAV_CheckCalcPaths
    portMissing("NAV_CheckCalcPaths", source: "oracle/codemp/game/g_main.c:3522")
}

/// Source: oracle/codemp/game/g_main.c:3559
func BG_GetTime() -> Int32 {
    // TODO: Port BG_GetTime
    portMissing("BG_GetTime", source: "oracle/codemp/game/g_main.c:3559")
}

/// Source: oracle/codemp/game/g_main.c:3582
func G_RunFrame(_ levelTime: Int32) {
    // TODO: Port G_RunFrame
    portMissing("G_RunFrame", source: "oracle/codemp/game/g_main.c:3582")
}

/// Source: oracle/codemp/game/g_main.c:3895
let JETPACK_DEFUEL_RATE = 200 as Int32

/// Source: oracle/codemp/game/g_main.c:3896
let JETPACK_REFUEL_RATE = 150 as Int32

/// Source: oracle/codemp/game/g_main.c:3927
let CLOAK_DEFUEL_RATE = 200 as Int32

/// Source: oracle/codemp/game/g_main.c:3928
let CLOAK_REFUEL_RATE = 150 as Int32

/// Source: oracle/codemp/game/g_main.c:4104
func G_GetStringEdString(_ refSection: String, _ refName: String) -> String {
    // TODO: Port G_GetStringEdString
    portMissing("G_GetStringEdString", source: "oracle/codemp/game/g_main.c:4104")
}
