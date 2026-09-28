import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_arenas.c:10
// Raven wrote: gentity_t *podium1
nonisolated(unsafe) let podium1: Entity? = nil

/// Source: oracle/codemp/game/g_arenas.c:11
// Raven wrote: gentity_t *podium2
nonisolated(unsafe) let podium2: Entity? = nil

/// Source: oracle/codemp/game/g_arenas.c:12
// Raven wrote: gentity_t *podium3
nonisolated(unsafe) let podium3: Entity? = nil

/**
```
==================
UpdateTournamentInfo
==================
```
*/
/// Source: oracle/codemp/game/g_arenas.c:20
func UpdateTournamentInfo() {
    var i: Int32
    var player: Entity?
    let playerClientNum: Int32
    var n: Int32
    let accuracy: Int32
    let perfect: Int32
    let msglen: Int32
    var buflen: Int32
    var score1: Int32
    var score2: Int32
    var won: Bool
    var buf = CharBuf(32)
    var msg = CharBuf(1024)

    // find the real player
    player = nil
    i = 0
    while i < level.maxclients {
        player = g_entities[i]
        if !player!.inuse {
            i += 1
            continue
        }
        if !((player!.r.svFlags & SVF_BOT) != 0) {
            break
        }
        i += 1
    }
    // this should never happen!
    if player == nil || i == level.maxclients {
        return
    }
    playerClientNum = i

    CalculateRanks()

    if level.clientsSlots[playerClientNum].sess.sessionTeam == TEAM_SPECTATOR {
        Com_sprintf(&msg, Int32((msg).count), "postgame %i %i 0 0 0 0 0 0 0 0 0 0 0", level.numNonSpectatorClients, playerClientNum)
    } else {
        if player!.client!.accuracy_shots != 0 {
            accuracy = player!.client!.accuracy_hits * 100 / player!.client!.accuracy_shots
        } else {
            accuracy = 0
        }
        won = false
        if g_gametype.integer >= GT_CTF {
            score1 = level.teamScores[TEAM_RED]
            score2 = level.teamScores[TEAM_BLUE]
            if level.clientsSlots[playerClientNum].sess.sessionTeam == TEAM_RED {
                won = (level.teamScores[TEAM_RED] > level.teamScores[TEAM_BLUE])
            } else {
                won = (level.teamScores[TEAM_BLUE] > level.teamScores[TEAM_RED])
            }
        } else {
            if level.clientsSlots[playerClientNum] == level.clientsSlots[level.sortedClients[0]] {
                won = true
                score1 = level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE]
                score2 = level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE]
            } else {
                score2 = level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE]
                score1 = level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE]
            }
        }
        if won && player!.client!.ps.persistant[PERS_KILLED] == 0 {
            perfect = 1
        } else {
            perfect = 0
        }
        Com_sprintf(&msg, Int32((msg).count), "postgame %i %i %i %i %i %i %i %i %i %i %i %i %i %i", level.numNonSpectatorClients, playerClientNum, accuracy, player!.client!.ps.persistant[PERS_IMPRESSIVE_COUNT], player!.client!.ps.persistant[PERS_EXCELLENT_COUNT], player!.client!.ps.persistant[PERS_DEFEND_COUNT], player!.client!.ps.persistant[PERS_ASSIST_COUNT], player!.client!.ps.persistant[PERS_GAUNTLET_FRAG_COUNT], player!.client!.ps.persistant[PERS_SCORE], perfect, score1, score2, level.time, player!.client!.ps.persistant[PERS_CAPTURES])
    }

    msglen = strlen(msg)
    i = 0
    while i < level.numNonSpectatorClients {
        n = level.sortedClients[i]
        Com_sprintf(&buf, Int32((buf).count), " %i %i %i", n, level.clientsSlots[n].ps.persistant[PERS_RANK], level.clientsSlots[n].ps.persistant[PERS_SCORE])
        buflen = strlen(buf)
        if msglen + buflen + 1 >= Int32((msg).count) {
            break
        }
        strcat(&msg, buf)
        i += 1
    }
    trap_SendConsoleCommand(EXEC_APPEND, String(msg))
}
