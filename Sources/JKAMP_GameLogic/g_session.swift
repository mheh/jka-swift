import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/**
```
================
G_WriteClientSessionData

Called on game shutdown
================
```
*/
/// Source: oracle/codemp/game/g_session.c:23
func G_WriteClientSessionData(_ client: Client) {
    let s: String
    let `var`: String
    var i: Int32 = 0
    var siegeClass = CharBuf(64)
    var saberType = CharBuf(64)
    var saber2Type = CharBuf(64)

    strcpy(&siegeClass, client.sess.siegeClass)

    while siegeClass[i] != 0 {
        //sort of a hack.. we don't want spaces by siege class names have spaces so convert them all to unused chars
        if siegeClass[i] == Int32(ascii: " ") {
            siegeClass[i] = 1
        }

        i += 1
    }

    if siegeClass[0] == 0 {
        //make sure there's at least something
        strcpy(&siegeClass, "none")
    }

    //Do the same for the saber
    strcpy(&saberType, client.sess.saberType)

    i = 0
    while saberType[i] != 0 {
        if saberType[i] == Int32(ascii: " ") {
            saberType[i] = 1
        }

        i += 1
    }

    strcpy(&saber2Type, client.sess.saber2Type)

    i = 0
    while saber2Type[i] != 0 {
        if saber2Type[i] == Int32(ascii: " ") {
            saber2Type[i] = 1
        }

        i += 1
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "argument type 'Bool' does not conform to expected type 'FormatArg'".
    // Raven wrote: s = va("%i %i %i %i %i %i %i %i %i %i %i %i %s %s %s", client->sess.sessionTeam, client->sess.spectatorTime, client->sess.spectatorState, client->sess.spectatorClient, client->sess.wins, client->sess.losses, client->sess.teamLeader, client->sess.setForce, client->sess.saberLevel, client->sess.selectedFP, client->sess.duelTeam, client->sess.siegeDesiredTeam, siegeClass, saberType, saber2Type )
    portMissing("G_WriteClientSessionData", source: "oracle/codemp/game/g_session.c:23")

    // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '-' on 'Strideable' requires that 'Client' conform to '_Pointer'".
    // Raven wrote: var = va( "session%i", client - level.clients )
    portMissing("G_WriteClientSessionData", source: "oracle/codemp/game/g_session.c:23")

    trap_Cvar_Set(`var`, s)
}

/**
```
================
G_ReadSessionData

Called on a reconnect
================
```
*/
/// Source: oracle/codemp/game/g_session.c:105
func G_ReadSessionData(_ client: Client) {
    var s = CharBuf(1024)
    let `var`: String
    var i: Int32 = 0

    // bk001205 - format
    var teamLeader: Int32 = 0
    var spectatorState: Int32 = 0
    var sessionTeam: Int32 = 0

    // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '-' on 'Strideable' requires that 'Client' conform to '_Pointer'".
    // Raven wrote: var = va( "session%i", client - level.clients )
    portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")
    strcpy(&s, trap_Cvar_VariableStringBuffer(`var`, Int32((s).count)))

    // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Any'".
    // Raven wrote: sscanf( s, "%i %i %i %i %i %i %i %i %i %i %i %i %s %s %s", &sessionTeam, // bk010221 - format &client->sess.spectatorTime, &spectatorState, // bk010221 - format &client->sess.spectatorClient, &client->sess.wins, &client->sess.losses, &teamLeader, // bk010221 - format &client->sess.setForce, &client->sess.saberLevel, &client->sess.selectedFP, &client->sess.duelTeam, &client->sess.siegeDesiredTeam, &client->sess.siegeClass, &client->sess.saberType, &client->sess.saber2Type )
    portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")

    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
    // Raven wrote: while (client->sess.siegeClass[i]) { //convert back to spaces from unused chars, as session data is written that way. if (client->sess.siegeClass[i] == 1) { client->sess.siegeClass[i] = ' '; } i++; }
    portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")

    i = 0
    //And do the same for the saber type
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
    // Raven wrote: while (client->sess.saberType[i]) { if (client->sess.saberType[i] == 1) { client->sess.saberType[i] = ' '; } i++; }
    portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")

    i = 0
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
    // Raven wrote: while (client->sess.saber2Type[i]) { if (client->sess.saber2Type[i] == 1) { client->sess.saber2Type[i] = ' '; } i++; }
    portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")

    // bk001205 - format issues
    client.sess.sessionTeam = team_t(sessionTeam)
    client.sess.spectatorState = spectatorState_t(spectatorState)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "no exact matches in call to initializer".
    // Raven wrote: client->sess.teamLeader = (qboolean)teamLeader
    portMissing("G_ReadSessionData", source: "oracle/codemp/game/g_session.c:105")

    client.ps.fd.saberAnimLevel = client.sess.saberLevel
    client.ps.fd.saberDrawAnimLevel = client.sess.saberLevel
    client.ps.fd.forcePowerSelected = client.sess.selectedFP
}

/**
```
================
G_InitSessionData

Called on a first-time connect
================
```
*/
/// Source: oracle/codemp/game/g_session.c:187
func G_InitSessionData(_ client: Client, _ userinfo: String, _ isBot: Bool) {
    var sess: ClientSession?
    var value: String

    sess = client.sess

    client.sess.siegeDesiredTeam = TEAM_FREE

    // initial team determination
    if g_gametype.integer >= GT_TEAM {
        if g_teamAutoJoin.integer != 0 {
            sess!.sessionTeam = PickTeam(-1)
            BroadcastTeamChange(client, -1)
        } else {
            // always spawn as spectator in team games
            if !isBot {
                sess!.sessionTeam = TEAM_SPECTATOR
            } else {
                //Bots choose their team on creation
                value = Info_ValueForKey(userinfo, "team")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Character' and 'Int32'".
                // Raven wrote: if (value[0] == 'r' || value[0] == 'R') { sess->sessionTeam = TEAM_RED; } else if (value[0] == 'b' || value[0] == 'B') { sess->sessionTeam = TEAM_BLUE; } else { sess->sessionTeam = PickTeam( -1 ); }
                portMissing("G_InitSessionData", source: "oracle/codemp/game/g_session.c:187")
                BroadcastTeamChange(client, -1)
            }
        }
    } else {
        value = Info_ValueForKey(userinfo, "team")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Character' and 'Int32'".
        // Raven wrote: if ( value[0] == 's' ) { // a willing spectator, not a waiting-in-line sess->sessionTeam = TEAM_SPECTATOR; } else { switch ( g_gametype.integer ) { default: case GT_FFA: case GT_HOLOCRON: case GT_JEDIMASTER: case GT_SINGLE_PLAYER: if ( g_maxGameClients.integer > 0 && level.numNonSpectatorClients >= g_maxGameClients.integer ) { sess->sessionTeam = TEAM_SPECTATOR; } else { sess->sessionTeam = TEAM_FREE; } break; case GT_DUEL: // if the game is full, go into a waiting mode if ( level.numNonSpectatorClients >= 2 ) { sess->sessionTeam = TEAM_SPECTATOR; } else { sess->sessionTeam = TEAM_FREE; } break; case GT_POWERDUEL: //sess->duelTeam = DUELTEAM_LONE; //default { int loners = 0; int doubles = 0; G_PowerDuelCount(&loners, &doubles, qtrue); if (!doubles || loners > (doubles/2)) { sess->duelTeam = DUELTEAM_DOUBLE; } else { sess->duelTeam = DUELTEAM_LONE; } } sess->sessionTeam = TEAM_SPECTATOR; break; } }
        portMissing("G_InitSessionData", source: "oracle/codemp/game/g_session.c:187")
    }

    sess!.spectatorState = SPECTATOR_FREE
    sess!.spectatorTime = level.time

    sess!.siegeClass = ""
    sess!.saberType = ""
    sess!.saber2Type = ""

    G_WriteClientSessionData(client)
}

/**
```
==================
G_InitWorldSession

==================
```
*/
/// Source: oracle/codemp/game/g_session.c:291
func G_InitWorldSession() {
    var s = CharBuf(1024)
    let gt: Int32

    strcpy(&s, trap_Cvar_VariableStringBuffer("session", Int32((s).count)))
    gt = atoi(s)

    // if the gametype changed since the last session, don't use any
    // client sessions
    if g_gametype.integer != gt {
        level.newSession = true
        G_Printf("Gametype changed, clearing session data.\n")
    }
}

/**
```
==================
G_WriteSessionData

==================
```
*/
/// Source: oracle/codemp/game/g_session.c:312
func G_WriteSessionData() {
    var i: Int32

    trap_Cvar_Set("session", va("%i", g_gametype.integer))

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].pers.connected == CON_CONNECTED {
            G_WriteClientSessionData(level.clientsSlots[i])
        }
        i += 1
    }
}
