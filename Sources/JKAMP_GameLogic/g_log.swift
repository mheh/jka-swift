import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_log.c:19
var G_WeaponLogPickups: [[Int32]] {
    get { world.variables.G_WeaponLogPickups }
    set { world.variables.G_WeaponLogPickups = newValue }
}

/// Source: oracle/codemp/game/g_log.c:20
var G_WeaponLogFired: [[Int32]] {
    get { world.variables.G_WeaponLogFired }
    set { world.variables.G_WeaponLogFired = newValue }
}

/// Source: oracle/codemp/game/g_log.c:21
var G_WeaponLogDamage: [[Int32]] {
    get { world.variables.G_WeaponLogDamage }
    set { world.variables.G_WeaponLogDamage = newValue }
}

/// Source: oracle/codemp/game/g_log.c:22
var G_WeaponLogKills: [[Int32]] {
    get { world.variables.G_WeaponLogKills }
    set { world.variables.G_WeaponLogKills = newValue }
}

/// Source: oracle/codemp/game/g_log.c:23
var G_WeaponLogDeaths: [[Int32]] {
    get { world.variables.G_WeaponLogDeaths }
    set { world.variables.G_WeaponLogDeaths = newValue }
}

/// Source: oracle/codemp/game/g_log.c:24
var G_WeaponLogFrags: [[Int32]] {
    get { world.variables.G_WeaponLogFrags }
    set { world.variables.G_WeaponLogFrags = newValue }
}

/// Source: oracle/codemp/game/g_log.c:25
var G_WeaponLogTime: [[Int32]] {
    get { world.variables.G_WeaponLogTime }
    set { world.variables.G_WeaponLogTime = newValue }
}

/// Source: oracle/codemp/game/g_log.c:26
var G_WeaponLogLastTime: [Int32] {
    get { world.variables.G_WeaponLogLastTime }
    set { world.variables.G_WeaponLogLastTime = newValue }
}

/// Source: oracle/codemp/game/g_log.c:27
var G_WeaponLogClientTouch: [Bool] {
    get { world.variables.G_WeaponLogClientTouch }
    set { world.variables.G_WeaponLogClientTouch = newValue }
}

/// Source: oracle/codemp/game/g_log.c:28
var G_WeaponLogPowerups: [[Int32]] {
    get { world.variables.G_WeaponLogPowerups }
    set { world.variables.G_WeaponLogPowerups = newValue }
}

/// Source: oracle/codemp/game/g_log.c:29
var G_WeaponLogItems: [[Int32]] {
    get { world.variables.G_WeaponLogItems }
    set { world.variables.G_WeaponLogItems = newValue }
}

/// Source: oracle/codemp/game/g_log.c:35
// Raven wrote: int weaponFromMOD[MOD_MAX]
let weaponFromMOD: [Int32] = { () -> [Int32] in portMissing("weaponFromMOD", source: "oracle/codemp/game/g_log.c:35") }()

/// Source: oracle/codemp/game/g_log.c:79
/// Raven's data table, a hand property of `GameWorld`.
var weaponNameFromIndex: [String] {
    get { world.weaponNameFromIndex }
    set { world.weaponNameFromIndex = newValue }
}

/// Source: oracle/codemp/game/g_log.c:1516
let AWARDS_MSG_LENGTH = 256 as Int32

/**
```
=================
G_LogWeaponInit
=================
```
*/
/// Source: oracle/codemp/game/g_log.c:108
func G_LogWeaponInit() {
    G_WeaponLogPickups.fill(0)
    G_WeaponLogFired.fill(0)
    G_WeaponLogDamage.fill(0)
    G_WeaponLogKills.fill(0)
    G_WeaponLogDeaths.fill(0)
    G_WeaponLogFrags.fill(0)
    G_WeaponLogTime.fill(0)
    G_WeaponLogLastTime.fill(0)
    G_WeaponLogPowerups.fill(0)
    G_WeaponLogItems.fill(0)
}

/// Source: oracle/codemp/game/g_log.c:123
func G_LogWeaponPickup(_ client: Int32, _ weaponid: Int32) {
    G_WeaponLogPickups[client][weaponid] += 1
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:131
func G_LogWeaponFire(_ client: Int32, _ weaponid: Int32) {
    let dur: Int32

    G_WeaponLogFired[client][weaponid] += 1
    dur = level.time - G_WeaponLogLastTime[client]
    if dur > 5000 {
        G_WeaponLogTime[client][weaponid] += 5000
    } else {
        G_WeaponLogTime[client][weaponid] += dur
    }
    G_WeaponLogLastTime[client] = level.time
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:147
func G_LogWeaponDamage(_ client: Int32, _ mod: Int32, _ amount: Int32) {
    if client >= MAX_CLIENTS {
        return
    }
    G_WeaponLogDamage[client][mod] += amount
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:157
func G_LogWeaponKill(_ client: Int32, _ mod: Int32) {
    if client >= MAX_CLIENTS {
        return
    }
    G_WeaponLogKills[client][mod] += 1
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:167
func G_LogWeaponFrag(_ attacker: Int32, _ deadguy: Int32) {
    if (attacker >= MAX_CLIENTS) || (deadguy >= MAX_CLIENTS) {
        return
    }
    G_WeaponLogFrags[attacker][deadguy] += 1
    G_WeaponLogClientTouch[attacker] = true
}

/// Source: oracle/codemp/game/g_log.c:177
func G_LogWeaponDeath(_ client: Int32, _ weaponid: Int32) {
    if client >= MAX_CLIENTS {
        return
    }
    G_WeaponLogDeaths[client][weaponid] += 1
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:187
func G_LogWeaponPowerup(_ client: Int32, _ powerupid: Int32) {
    if client >= MAX_CLIENTS {
        return
    }
    G_WeaponLogPowerups[client][powerupid] += 1
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:197
func G_LogWeaponItem(_ client: Int32, _ itemid: Int32) {
    if client >= MAX_CLIENTS {
        return
    }
    G_WeaponLogItems[client][itemid] += 1
    G_WeaponLogClientTouch[client] = true
}

/// Source: oracle/codemp/game/g_log.c:227
func G_LogWeaponOutput() {
    var i: Int32
    var j: Int32
    var curwp: Int32
    var pershot: Float
    var weaponfile: fileHandle_t = 0
    var string = CharBuf(1024)

    var totalpickups: [Int32] = [Int32](repeating: 0, count: 19)
    var totaltime: [Int32] = [Int32](repeating: 0, count: 19)
    var totaldeaths: [Int32] = [Int32](repeating: 0, count: 19)
    var totaldamageMOD: [Int32] = [Int32](repeating: 0, count: 45)
    var totalkillsMOD: [Int32] = [Int32](repeating: 0, count: 45)
    var totaldamage: [Int32] = [Int32](repeating: 0, count: 19)
    var totalkills: [Int32] = [Int32](repeating: 0, count: 19)
    var totalshots: [Int32] = [Int32](repeating: 0, count: 19)
    var percharacter: [Int32] = [Int32](repeating: 0, count: 19)
    var info = CharBuf(1024)
    var mapname = CharBuf(128)
    var nameptr: String
    let unknownname: String = "<Unknown>"

    if g_statLog.integer == 0 {
        return
    }

    G_LogPrintf("*****************************Weapon Log:\n")

    totalpickups.fill(0)
    totaltime.fill(0)
    totaldeaths.fill(0)
    totaldamageMOD.fill(0)
    totalkillsMOD.fill(0)
    totaldamage.fill(0)
    totalkills.fill(0)
    totalshots.fill(0)

    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            j = 0
            while j < WP_NUM_WEAPONS {
                totalpickups[j] += G_WeaponLogPickups[i][j]
                totaltime[j] += G_WeaponLogTime[i][j]
                totaldeaths[j] += G_WeaponLogDeaths[i][j]
                totalshots[j] += G_WeaponLogFired[i][j]
                j += 1
            }

            j = 0
            while j < MOD_MAX {
                totaldamageMOD[j] += G_WeaponLogDamage[i][j]
                totalkillsMOD[j] += G_WeaponLogKills[i][j]
                j += 1
            }
        }
        i += 1
    }

    // Now total the weapon data from the MOD data.
    j = 0
    while j < MOD_MAX {
        if j <= MOD_SENTRY {
            curwp = weaponFromMOD[j]
            totaldamage[curwp] += totaldamageMOD[j]
            totalkills[curwp] += totalkillsMOD[j]
        }
        j += 1
    }

    G_LogPrintf("\n****Data by Weapon:\n")
    j = 0
    while j < WP_NUM_WEAPONS {
        G_LogPrintf("%15s:  Pickups: %4d,  Time:  %5d,  Deaths: %5d\n", weaponNameFromIndex[j], totalpickups[j], Int32((totaltime[j] / 1000)), totaldeaths[j])
        j += 1
    }

    G_LogPrintf("\n****Combat Data by Weapon:\n")
    j = 0
    while j < WP_NUM_WEAPONS {
        if totalshots[j] > 0 {
            pershot = Float((totaldamage[j])) / Float((totalshots[j]))
        } else {
            pershot = 0
        }
        G_LogPrintf("%15s:  Damage: %6d,  Kills: %5d,  Dmg per Shot: %f\n", weaponNameFromIndex[j], totaldamage[j], totalkills[j], pershot)
        j += 1
    }

    G_LogPrintf("\n****Combat Data By Damage Type:\n")
    j = 0
    while j < MOD_MAX {
        G_LogPrintf("%25s:  Damage: %6d,  Kills: %5d\n", modNames[j] ?? "(null)", totaldamageMOD[j], totalkillsMOD[j])
        j += 1
    }

    G_LogPrintf("\n")



    // Write the whole weapon statistic log out to a file.
    trap_FS_FOpenFile(g_statLogFile.string, &weaponfile, FS_APPEND)
    if weaponfile == 0 {
        //failed to open file, let's not crash, shall we?
        return
    }

    // Write out the level name
    strcpy(&info, trap_GetServerinfo(Int32((info).count)))
    strncpy(&mapname, Info_ValueForKey(String(info), "mapname"), Int32((mapname).count) - 1)
    mapname[Int32((mapname).count) - 1] = 0

    Com_sprintf(&string, Int32((string).count), "\n\n\nLevel:\t%s\n\n\n", mapname)
    trap_FS_Write(&string, strlen(string), weaponfile)


    // Combat data per character

    // Start with Pickups per character
    Com_sprintf(&string, Int32((string).count), "Weapon Pickups per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%s", weaponNameFromIndex[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < WP_NUM_WEAPONS {
                Com_sprintf(&string, Int32((string).count), "\t%d", G_WeaponLogPickups[i][j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%d", totalpickups[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)


    // Weapon fires per character
    Com_sprintf(&string, Int32((string).count), "Weapon Shots per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%s", weaponNameFromIndex[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < WP_NUM_WEAPONS {
                Com_sprintf(&string, Int32((string).count), "\t%d", G_WeaponLogFired[i][j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%d", totalshots[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)


    // Weapon time per character
    Com_sprintf(&string, Int32((string).count), "Weapon Use Time per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%s", weaponNameFromIndex[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < WP_NUM_WEAPONS {
                Com_sprintf(&string, Int32((string).count), "\t%d", G_WeaponLogTime[i][j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%d", totaltime[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)



    // Weapon deaths per character
    Com_sprintf(&string, Int32((string).count), "Weapon Deaths per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%s", weaponNameFromIndex[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < WP_NUM_WEAPONS {
                Com_sprintf(&string, Int32((string).count), "\t%d", G_WeaponLogDeaths[i][j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%d", totaldeaths[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)




    // Weapon damage per character

    Com_sprintf(&string, Int32((string).count), "Weapon Damage per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%s", weaponNameFromIndex[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!

            // We must grab the totals from the damage types for the player and map them to the weapons.
            percharacter.fill(0)
            j = 0
            while j < MOD_MAX {
                if j <= MOD_SENTRY {
                    curwp = weaponFromMOD[j]
                    percharacter[curwp] += G_WeaponLogDamage[i][j]
                }
                j += 1
            }

            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < WP_NUM_WEAPONS {
                Com_sprintf(&string, Int32((string).count), "\t%d", percharacter[j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%d", totaldamage[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)



    // Weapon kills per character

    Com_sprintf(&string, Int32((string).count), "Weapon Kills per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%s", weaponNameFromIndex[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!

            // We must grab the totals from the damage types for the player and map them to the weapons.
            percharacter.fill(0)
            j = 0
            while j < MOD_MAX {
                if j <= MOD_SENTRY {
                    curwp = weaponFromMOD[j]
                    percharacter[curwp] += G_WeaponLogKills[i][j]
                }
                j += 1
            }

            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < WP_NUM_WEAPONS {
                Com_sprintf(&string, Int32((string).count), "\t%d", percharacter[j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < WP_NUM_WEAPONS {
        Com_sprintf(&string, Int32((string).count), "\t%d", totalkills[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)



    // Damage type damage per character
    Com_sprintf(&string, Int32((string).count), "Typed Damage per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < MOD_MAX {
        Com_sprintf(&string, Int32((string).count), "\t%s", modNames[j] ?? "(null)")
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < MOD_MAX {
                Com_sprintf(&string, Int32((string).count), "\t%d", G_WeaponLogDamage[i][j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < MOD_MAX {
        Com_sprintf(&string, Int32((string).count), "\t%d", totaldamageMOD[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)



    // Damage type kills per character
    Com_sprintf(&string, Int32((string).count), "Damage-Typed Kills per Player:\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    Com_sprintf(&string, Int32((string).count), "Player")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < MOD_MAX {
        Com_sprintf(&string, Int32((string).count), "\t%s", modNames[j] ?? "(null)")
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }
    Com_sprintf(&string, Int32((string).count), "\n")
    trap_FS_Write(&string, strlen(string), weaponfile)

    // Cycle through each player, give their name and the number of times they picked up each weapon.
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogClientTouch[i] {
            // Ignore any entity/clients we don't care about!
            if g_entities[i].client != nil {
                nameptr = g_entities[i].client!.pers.netname
            } else {
                nameptr = unknownname
            }
            trap_FS_Write(nameptr, strlen(nameptr), weaponfile)

            j = 0
            while j < MOD_MAX {
                Com_sprintf(&string, Int32((string).count), "\t%d", G_WeaponLogKills[i][j])
                trap_FS_Write(&string, strlen(string), weaponfile)
                j += 1
            }

            Com_sprintf(&string, Int32((string).count), "\n")
            trap_FS_Write(&string, strlen(string), weaponfile)
        }
        i += 1
    }

    // Sum up the totals.
    Com_sprintf(&string, Int32((string).count), "\n***TOTAL:")
    trap_FS_Write(&string, strlen(string), weaponfile)

    j = 0
    while j < MOD_MAX {
        Com_sprintf(&string, Int32((string).count), "\t%d", totalkillsMOD[j])
        trap_FS_Write(&string, strlen(string), weaponfile)
        j += 1
    }

    Com_sprintf(&string, Int32((string).count), "\n\n\n")
    trap_FS_Write(&string, strlen(string), weaponfile)


    trap_FS_FCloseFile(weaponfile)
}

// did this player earn the efficiency award?
/// Source: oracle/codemp/game/g_log.c:824
func CalculateEfficiency(_ ent: Entity, _ efficiency: inout Int32) -> Bool {
    var fAccuracyRatio: Float = 0
    var fBestRatio: Float = 0
    var i: Int32 = 0
    var nShotsFired: Int32 = 0
    var nShotsHit: Int32 = 0
    var nBestPlayer: Int32 = -1
    var tempEff: Int32 = 0
    var playerIndex: Int32 = 0


    i = 0
    while i < g_maxclients.integer {
        playerIndex = i
        if !g_entities[playerIndex].inuse {
            i += 1
            continue
        }
        nShotsFired = g_entities[playerIndex].client!.accuracy_shots //player->client->ps.persistant[PERS_ACCURACY_SHOTS];
        nShotsHit = g_entities[playerIndex].client!.accuracy_hits //player->client->ps.persistant[PERS_ACCURACY_HITS];
        fAccuracyRatio = ((Float(nShotsHit)) / (Float(nShotsFired)))
        if fAccuracyRatio > fBestRatio {
            fBestRatio = fAccuracyRatio
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        // huh?
        return false
    }
    if nBestPlayer == ent.s.number {
        tempEff = Int32((100 * fBestRatio))
        if tempEff > 50 {
            efficiency = tempEff
            return true
        }
        return false
    }
    return false
}

// did this player earn the sharpshooter award?
/// Source: oracle/codemp/game/g_log.c:866
func CalculateSharpshooter(_ ent: Entity, _ frags: inout Int32) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nKills: Int32 = 0
    var nMostKills: Int32 = 0
    let playTime: Int32 = (level.time - ent.client!.pers.enterTime) / 60000
    var playerIndex: Int32 = 0

    // if this guy didn't get one kill per minute, reject him right now
    if Double((Float((G_WeaponLogKills[ent.s.number][MOD_DISRUPTOR_SNIPER]))) / (Float((playTime)))) < 1.0 {
        return false
    }

    i = 0
    while i < g_maxclients.integer {
        nKills = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse {
            i += 1
            continue
        }
        nKills = G_WeaponLogKills[i][MOD_DISRUPTOR_SNIPER]
        if nKills > nMostKills {
            nMostKills = nKills
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        frags = nMostKills
        return true
    }
    return false
}

// did this player earn the untouchable award?
/// Source: oracle/codemp/game/g_log.c:906
func CalculateUntouchable(_ ent: Entity) -> Bool {
    let playTime: Int32
    playTime = (level.time - ent.client!.pers.enterTime) / 60000

    if g_gametype.integer == GT_JEDIMASTER && ent.client!.ps.isJediMaster {
        //Jedi Master (was Borg queen) can only be killed once anyway
        return false
    }
    //------------------------------------------------------ MUST HAVE ACHIEVED 2 KILLS PER MINUTE
    if Double((Float(ent.client!.ps.persistant[PERS_SCORE])) / (Float((playTime)))) < 2.0 || playTime == 0 {
        return false
    }
    //------------------------------------------------------ MUST HAVE ACHIEVED 2 KILLS PER MINUTE


    // if this guy was never killed...  Award Away!!!
    if ent.client!.ps.persistant[PERS_KILLED] == 0 {
        return true
    }

    return false
}

// did this player earn the logistics award?
/// Source: oracle/codemp/game/g_log.c:931
func CalculateLogistics(_ ent: Entity, _ stuffUsed: inout Int32) -> Bool {
    var i: Int32 = 0
    var j: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nStuffUsed: Int32 = 0
    var nMostStuffUsed: Int32 = 0
    var nDifferent: Int32 = 0
    var nMostDifferent: Int32 = 0
    var playerIndex: Int32 = 0

    i = 0
    while i < g_maxclients.integer {
        nStuffUsed = 0
        nDifferent = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse {
            i += 1
            continue
        }
        j = HI_NONE + 1
        while j < HI_NUM_HOLDABLE {
            if G_WeaponLogPowerups[i][j] != 0 {
                nDifferent += 1
            }
            nStuffUsed += G_WeaponLogPowerups[i][j]
            j += 1
        }
        j = PW_NONE + 1
        while j < PW_NUM_POWERUPS {
            if G_WeaponLogItems[i][j] != 0 {
                nDifferent += 1
            }
            nStuffUsed += G_WeaponLogItems[i][j]
            j += 1
        }
        if (nDifferent >= 4) && (nDifferent >= nMostDifferent) {
            if nStuffUsed > nMostStuffUsed {
                nMostDifferent = nDifferent
                nMostStuffUsed = nStuffUsed
                nBestPlayer = i
            }
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        stuffUsed = nMostDifferent
        return true
    }
    return false
}

// did this player earn the tactician award?
/// Source: oracle/codemp/game/g_log.c:988
func CalculateTactician(_ ent: Entity, _ kills: inout Int32) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nKills: Int32 = 0
    var nMostKills: Int32 = 0
    var person: Int32 = 0
    var weapon: Int32 = 0
    var playerIndex: Int32 = 0
    var wasPickedUpBySomeone: [Int32] = [Int32](repeating: 0, count: 19)
    var killsWithWeapon: [Int32] = [Int32](repeating: 0, count: 19)
    let playTime: Int32 = (level.time - ent.client!.pers.enterTime) / 60000

    if HasSetSaberOnly() {
        //duh, only 1 weapon
        return false
    }
    if g_gametype.integer == GT_JEDIMASTER && ent.client!.ps.isJediMaster {
        //Jedi Master (was Borg queen) has only 1 weapon
        return false
    }
    //------------------------------------------------------ MUST HAVE ACHIEVED 2 KILLS PER MINUTE
    if Double(playTime) < 0.3 {
        return false
    }

    if Double((Float(ent.client!.ps.persistant[PERS_SCORE])) / (Float((playTime)))) < 2.0 {
        return false
    }
    //------------------------------------------------------ MUST HAVE ACHIEVED 2 KILLS PER MINUTE




    //------------------------------------------------------ FOR EVERY WEAPON, ADD UP TOTAL PICKUPS
    weapon = 0
    while weapon < WP_NUM_WEAPONS {
        wasPickedUpBySomeone[weapon] = 0 // CLEAR
        weapon += 1
    }

    person = 0
    while person < g_maxclients.integer {
        weapon = 0
        while weapon < WP_NUM_WEAPONS {
            if G_WeaponLogPickups[person][weapon] > 0 {
                wasPickedUpBySomeone[weapon] += 1
            }
            weapon += 1
        }
        person += 1
    }
    //------------------------------------------------------ FOR EVERY WEAPON, ADD UP TOTAL PICKUPS




    //------------------------------------------------------ FOR EVERY PERSON, CHECK FOR CANDIDATE
    person = 0
    while person < g_maxclients.integer {
        playerIndex = person
        if !g_entities[playerIndex].inuse {
            person += 1
            continue
        }

        nKills = 0 // This Persons's Kills
        weapon = 0
        while weapon < WP_NUM_WEAPONS {
            killsWithWeapon[weapon] = 0 // CLEAR
            weapon += 1
        }

        i = 0
        while i < MOD_MAX {
            weapon = weaponFromMOD[i] // Select Weapon
            killsWithWeapon[weapon] += G_WeaponLogKills[person][i] // Store Num Kills With Weapon
            i += 1
        }

        weapon = WP_STUN_BATON // Start At Stun Baton
        //   keep looking through weapons if weapon is not on map, or if it is and we used it
        while weapon < WP_NUM_WEAPONS && (wasPickedUpBySomeone[weapon] == 0 || killsWithWeapon[weapon] > 0) {
            weapon += 1
            nKills += killsWithWeapon[weapon] //  Update the number of kills
        }
        //
        // At this point we have either successfully gone through every weapon on the map and saw it had
        // been used, or we found one that WAS on the map and was NOT used
        //
        // so we look to see if the weapon==Max (i.e. we used every one) and then we check to see
        // if we got the most kills out of anyone else who did this.
        //
        if weapon >= WP_NUM_WEAPONS && nKills > nMostKills {
            // WE ARE A TACTICION CANDIDATE
            nMostKills = nKills
            nBestPlayer = person
        }
        person += 1
    }
    //------------------------------------------------------ FOR EVERY PERSON, CHECK FOR CANDIDATE

    //Now, if we are the best player, return true and the number of kills we got
    if nBestPlayer == ent.s.number {
        kills = nMostKills
        return true
    }
    return false
}

// did this player earn the demolitionist award?
/// Source: oracle/codemp/game/g_log.c:1087
func CalculateDemolitionist(_ ent: Entity, _ kills: inout Int32) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nKills: Int32 = 0
    var nMostKills: Int32 = 0
    let playTime: Int32 = (level.time - ent.client!.pers.enterTime) / 60000
    var playerIndex: Int32 = 0

    i = 0
    while i < g_maxclients.integer {
        nKills = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse {
            i += 1
            continue
        }

        nKills = G_WeaponLogKills[i][MOD_THERMAL]
        nKills += G_WeaponLogKills[i][MOD_THERMAL_SPLASH]
        nKills += G_WeaponLogKills[i][MOD_ROCKET]
        nKills += G_WeaponLogKills[i][MOD_ROCKET_SPLASH]
        nKills += G_WeaponLogKills[i][MOD_ROCKET_HOMING]
        nKills += G_WeaponLogKills[i][MOD_ROCKET_HOMING_SPLASH]
        nKills += G_WeaponLogKills[i][MOD_TRIP_MINE_SPLASH]
        nKills += G_WeaponLogKills[i][MOD_TIMED_MINE_SPLASH]
        nKills += G_WeaponLogKills[i][MOD_DET_PACK_SPLASH]

        // if this guy didn't get two explosive kills per minute, reject him right now
        if Double((Float(nKills)) / (Float((playTime)))) < 2.0 {
            i += 1
            continue
        }

        if nKills > nMostKills {
            nMostKills = nKills
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        kills = nMostKills
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1136
func CalculateStreak(_ ent: Entity) -> Int32 {
    //No streak calculation, at least for now.
    return 0
}

/// Source: oracle/codemp/game/g_log.c:1160
func CalculateTeamMVP(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_TEAM]
    var playerIndex: Int32 = 0

    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse || (g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team) {
            i += 1
            continue
        }
        nScore = g_entities[playerIndex].client!.ps.persistant[PERS_SCORE]
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1190
func CalculateTeamMVPByRank(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_RANK] + 1
    let bTied: Bool = (team == 3)
    var playerIndex: Int32 = 0

    /*
    if ( team == ent->client->ps.persistant[PERS_TEAM] && ent->client->ps.persistant[PERS_CLASS] == PC_BORG )
    {//only the queen can be the MVP
    if ( borgQueenClientNum == ent->s.number )
    {
    return qtrue;
    }
    else
    {
    return qfalse;
    }
    }
    */

    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse {
            i += 1
            continue
        }
        if !bTied {
            if g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team {
                i += 1
                continue
            }
        }
        nScore = g_entities[playerIndex].client!.ps.persistant[PERS_SCORE]
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1242
func CalculateTeamDefender(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_TEAM]
    var playerIndex: Int32 = 0

    /*
    if (CalculateTeamMVP(ent))
    {
    return qfalse;
    }
    */
    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse || (g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team) {
            i += 1
            continue
        }
        nScore = g_entities[playerIndex].client!.pers.teamState.basedefense
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1278
func CalculateTeamWarrior(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_TEAM]
    var playerIndex: Int32 = 0

    /*
    if (CalculateTeamMVP(ent) || CalculateTeamDefender(ent))
    {
    return qfalse;
    }
    */
    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse || (g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team) {
            i += 1
            continue
        }
        nScore = g_entities[playerIndex].client!.ps.persistant[PERS_SCORE]
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1314
func CalculateTeamCarrier(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_TEAM]
    var playerIndex: Int32 = 0

    /*
    if (CalculateTeamMVP(ent) || CalculateTeamDefender(ent) || CalculateTeamWarrior(ent))
    {
    return qfalse;
    }
    */
    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse || (g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team) {
            i += 1
            continue
        }
        nScore = g_entities[playerIndex].client!.pers.teamState.captures
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1350
func CalculateTeamInterceptor(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_TEAM]
    var playerIndex: Int32 = 0

    /*
    if (CalculateTeamMVP(ent) || CalculateTeamDefender(ent) || CalculateTeamWarrior(ent) ||
    CalculateTeamCarrier(ent))
    {
    return qfalse;
    }
    */
    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse || (g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team) {
            i += 1
            continue
        }
        nScore = g_entities[playerIndex].client!.pers.teamState.flagrecovery
        nScore += g_entities[playerIndex].client!.pers.teamState.fragcarrier
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1388
func CalculateTeamRedShirt(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var nBestPlayer: Int32 = -1
    var nScore: Int32 = 0
    var nHighestScore: Int32 = 0
    let team: Int32 = ent.client!.ps.persistant[PERS_TEAM]
    var playerIndex: Int32 = 0

    /*
    if (CalculateTeamMVP(ent) || CalculateTeamDefender(ent) || CalculateTeamWarrior(ent) ||
    CalculateTeamCarrier(ent) || CalculateTeamInterceptor(ent))
    {
    return qfalse;
    }
    */
    i = 0
    while i < g_maxclients.integer {
        nScore = 0
        playerIndex = i
        if !g_entities[playerIndex].inuse || (g_entities[playerIndex].client!.ps.persistant[PERS_TEAM] != team) {
            i += 1
            continue
        }
        nScore = g_entities[playerIndex].client!.ps.persistant[PERS_KILLED]
        nScore -= g_entities[playerIndex].client!.ps.fd.suicides // suicides don't count, you big cheater.
        if nScore > nHighestScore {
            nHighestScore = nScore
            nBestPlayer = i
        }
        i += 1
    }
    if -1 == nBestPlayer {
        return false
    }
    if nBestPlayer == ent.s.number {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1451
func CalculateTeamAward(_ ent: Entity) -> Int32 {
    var teamAwards: Int32 = 0

    if CalculateTeamMVP(ent) {
        teamAwards |= (1 << TEAM_MVP)
    }
    if GT_CTF == g_gametype.integer || GT_CTY == g_gametype.integer {
        if CalculateTeamDefender(ent) {
            teamAwards |= (1 << TEAM_DEFENDER)
        }
        if CalculateTeamWarrior(ent) {
            teamAwards |= (1 << TEAM_WARRIOR)
        }
        if CalculateTeamCarrier(ent) {
            teamAwards |= (1 << TEAM_CARRIER)
        }
        if CalculateTeamInterceptor(ent) {
            teamAwards |= (1 << TEAM_INTERCEPTOR)
        }
    }
    if teamAwards == 0 && CalculateTeamRedShirt(ent) {
        //if you got nothing else and died a lot, at least get bravery
        teamAwards |= (1 << TEAM_BRAVERY)
    }
    return teamAwards
}

/// Source: oracle/codemp/game/g_log.c:1486
func CalculateSection31Award(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var frags: Int32 = 0
    var efficiency: Int32 = 0
    var playerIndex: Int32 = 0

    i = 0
    while i < g_maxclients.integer {
        playerIndex = i
        if !g_entities[playerIndex].inuse {
            i += 1
            continue
        }
        //
        //	kef -- heh.
        //
        //		if (strcmp("JaxxonPhred", ent->client->pers.netname))
        //		{
        //			continue;
        //		}
        CalculateEfficiency(ent, &efficiency)
        if !CalculateSharpshooter(ent, &frags) || !CalculateUntouchable(ent) || (efficiency < 75) {
            i += 1
            continue
        }
        return true
        i += 1
    }
    return false
}

/// Source: oracle/codemp/game/g_log.c:1518
func CalculateAwards(_ ent: Entity, _ msg: inout JKAShared.CharBuf) {
    var buf1 = CharBuf(256)
    var buf2 = CharBuf(256)
    var awardFlags: Int32 = 0
    var efficiency: Int32 = 0
    var stuffUsed: Int32 = 0
    var kills: Int32 = 0
    var streak: Int32 = 0
    var teamAwards: Int32 = 0

    buf1.zero()
    buf2.zero()
    if CalculateEfficiency(ent, &efficiency) {
        awardFlags |= (1 << AWARD_EFFICIENCY)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, " %d", efficiency)
    }
    if CalculateSharpshooter(ent, &kills) {
        awardFlags |= (1 << AWARD_SHARPSHOOTER)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, kills)
    }
    if CalculateUntouchable(ent) {
        awardFlags |= (1 << AWARD_UNTOUCHABLE)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, 0)
    }
    if CalculateLogistics(ent, &stuffUsed) {
        awardFlags |= (1 << AWARD_LOGISTICS)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, stuffUsed)
    }
    if CalculateTactician(ent, &kills) {
        awardFlags |= (1 << AWARD_TACTICIAN)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, kills)
    }
    if CalculateDemolitionist(ent, &kills) {
        awardFlags |= (1 << AWARD_DEMOLITIONIST)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, kills)
    }
    streak = CalculateStreak(ent)
    if streak != 0 {
        awardFlags |= (1 << AWARD_STREAK)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, streak)
    }
    if g_gametype.integer >= GT_TEAM {
        teamAwards = CalculateTeamAward(ent)
        if teamAwards != 0 {
            awardFlags |= (1 << AWARD_TEAM)
            strcpy(&buf2, buf1)
            Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, teamAwards)
        }
    }
    if CalculateSection31Award(ent) {
        awardFlags |= (1 << AWARD_SECTION31)
        strcpy(&buf2, buf1)
        Com_sprintf(&buf1, AWARDS_MSG_LENGTH, "%s %d", buf2, 0)
    }
    strcpy(&buf2, msg)
    Com_sprintf(&msg, AWARDS_MSG_LENGTH, "%s %d%s", buf2, awardFlags, buf1)
}

/// Source: oracle/codemp/game/g_log.c:1589
func GetMaxDeathsForClient(_ nClient: Int32) -> Int32 {
    var i: Int32 = 0
    var nMostDeaths: Int32 = 0

    if (nClient < 0) || (nClient >= MAX_CLIENTS) {
        return 0
    }
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogFrags[i][nClient] > nMostDeaths {
            nMostDeaths = G_WeaponLogFrags[i][nClient]
        }
        i += 1
    }
    return nMostDeaths
}

/// Source: oracle/codemp/game/g_log.c:1607
func GetMaxKillsForClient(_ nClient: Int32) -> Int32 {
    var i: Int32 = 0
    var nMostKills: Int32 = 0

    if (nClient < 0) || (nClient >= MAX_CLIENTS) {
        return 0
    }
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogFrags[nClient][i] > nMostKills {
            nMostKills = G_WeaponLogFrags[nClient][i]
        }
        i += 1
    }
    return nMostKills
}

/// Source: oracle/codemp/game/g_log.c:1625
func GetFavoriteTargetForClient(_ nClient: Int32) -> Int32 {
    var i: Int32 = 0
    var nMostKills: Int32 = 0
    var nFavoriteTarget: Int32 = -1

    if (nClient < 0) || (nClient >= MAX_CLIENTS) {
        return 0
    }
    i = 0
    while i < MAX_CLIENTS {
        if G_WeaponLogFrags[nClient][i] > nMostKills {
            nMostKills = G_WeaponLogFrags[nClient][i]
            nFavoriteTarget = i
        }
        i += 1
    }
    return nFavoriteTarget
}

/// Source: oracle/codemp/game/g_log.c:1644
func GetWorstEnemyForClient(_ nClient: Int32) -> Int32 {
    var i: Int32 = 0
    var nMostDeaths: Int32 = 0
    var nWorstEnemy: Int32 = -1

    if (nClient < 0) || (nClient >= MAX_CLIENTS) {
        return 0
    }
    i = 0
    while i < MAX_CLIENTS {
        // If there is a tie for most deaths, we want to choose anybody else
        // over the client...  I.E. Most deaths should not tie with yourself and
        // have yourself show up...

        if G_WeaponLogFrags[i][nClient] > nMostDeaths || (G_WeaponLogFrags[i][nClient] == nMostDeaths && i != nClient && nMostDeaths != 0) {
            nMostDeaths = G_WeaponLogFrags[i][nClient]
            nWorstEnemy = i
        }
        i += 1
    }
    return nWorstEnemy
}

/// Source: oracle/codemp/game/g_log.c:1668
func GetFavoriteWeaponForClient(_ nClient: Int32) -> Int32 {
    var i: Int32 = 0
    var nMostKills: Int32 = 0
    var fav: Int32 = 0
    var weapon: Int32 = WP_STUN_BATON
    var killsWithWeapon: [Int32] = [Int32](repeating: 0, count: 19)


    // First thing we need to do is cycle through all the MOD types and convert
    // number of kills to a single weapon.
    //----------------------------------------------------------------
    weapon = 0
    while weapon < WP_NUM_WEAPONS {
        killsWithWeapon[weapon] = 0 // CLEAR
        weapon += 1
    }

    i = MOD_STUN_BATON
    while i <= MOD_FORCE_DARK {
        weapon = weaponFromMOD[i] // Select Weapon

        if weapon != WP_NONE {
            killsWithWeapon[weapon] += G_WeaponLogKills[nClient][i] // Store Num Kills With Weapon
        }
        i += 1
    }

    // now look through our list of kills per weapon and pick the biggest
    //----------------------------------------------------------------
    nMostKills = 0
    weapon = WP_STUN_BATON
    while weapon < WP_NUM_WEAPONS {
        if killsWithWeapon[weapon] > nMostKills {
            nMostKills = killsWithWeapon[weapon]
            fav = weapon
        }
        weapon += 1
    }
    return fav
}

// kef -- if a client leaves the game, clear out all counters he may have set
/// Source: oracle/codemp/game/g_log.c:1705
func G_ClearClientLog(_ client: Int32) {
    var i: Int32 = 0

    i = 0
    while i < WP_NUM_WEAPONS {
        G_WeaponLogPickups[client][i] = 0
        i += 1
    }
    i = 0
    while i < WP_NUM_WEAPONS {
        G_WeaponLogFired[client][i] = 0
        i += 1
    }
    i = 0
    while i < MOD_MAX {
        G_WeaponLogDamage[client][i] = 0
        i += 1
    }
    i = 0
    while i < MOD_MAX {
        G_WeaponLogKills[client][i] = 0
        i += 1
    }
    i = 0
    while i < WP_NUM_WEAPONS {
        G_WeaponLogDeaths[client][i] = 0
        i += 1
    }
    i = 0
    while i < MAX_CLIENTS {
        G_WeaponLogFrags[client][i] = 0
        i += 1
    }
    i = 0
    while i < MAX_CLIENTS {
        G_WeaponLogFrags[i][client] = 0
        i += 1
    }
    i = 0
    while i < WP_NUM_WEAPONS {
        G_WeaponLogTime[client][i] = 0
        i += 1
    }
    G_WeaponLogLastTime[client] = 0
    G_WeaponLogClientTouch[client] = false
    i = 0
    while i < HI_NUM_HOLDABLE {
        G_WeaponLogPowerups[client][i] = 0
        i += 1
    }
    i = 0
    while i < PW_NUM_POWERUPS {
        G_WeaponLogItems[client][i] = 0
        i += 1
    }
}
