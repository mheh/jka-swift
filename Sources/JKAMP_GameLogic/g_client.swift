import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_client.c:9
/// Raven's data table, a hand property of `GameWorld`.
private var playerMins: JKAShared.vec3_t {
    get { world.g_client_playerMins }
    set { world.g_client_playerMins = newValue }
}

/// Source: oracle/codemp/game/g_client.c:10
/// Raven's data table, a hand property of `GameWorld`.
private var playerMaxs: JKAShared.vec3_t {
    get { world.g_client_playerMaxs }
    set { world.g_client_playerMaxs = newValue }
}

/// Source: oracle/codemp/game/g_client.c:19
var Client_Force: Slots<JKAMP.Forcedata> { world.storage.Client_Force }

/// Source: oracle/codemp/game/g_client.c:256
let JMSABER_RESPAWN_TIME = 20000 as Int32

/// Source: oracle/codemp/game/g_client.c:471
var gJMSaberEnt: Entity? {
    get { world.variables.gJMSaberEnt }
    set { world.variables.gJMSaberEnt = newValue }
}

/// Source: oracle/codemp/game/g_client.c:589
let MAX_SPAWN_POINTS = 128 as Int32

/// Source: oracle/codemp/game/g_client.c:946
let BODY_SINK_TIME = 30000 as Int32

/// Source: oracle/codemp/game/g_client.c:1511
var g2SaberInstance: OpaquePointer? {
    get { world.variables.g2SaberInstance }
    set { world.variables.g2SaberInstance = newValue }
}

/**
```
QUAKED info_player_duel (1 0 1) (-16 -16 -24) (16 16 32) initial
potential spawning position for duelists in duel.
Targets will be fired when someone spawns in on them.
"nobots" will prevent bots from using this spot.
"nohumans" will prevent non-bots from using this spot.
```
*/
/// Source: oracle/codemp/game/g_client.c:27
func SP_info_player_duel(_ ent: Entity) {
    var i: Int32 = 0

    G_SpawnInt("nobots", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_BOTS
    }
    G_SpawnInt("nohumans", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_HUMANS
    }
}

/**
```
QUAKED info_player_duel1 (1 0 1) (-16 -16 -24) (16 16 32) initial
potential spawning position for lone duelists in powerduel.
Targets will be fired when someone spawns in on them.
"nobots" will prevent bots from using this spot.
"nohumans" will prevent non-bots from using this spot.
```
*/
/// Source: oracle/codemp/game/g_client.c:47
func SP_info_player_duel1(_ ent: Entity) {
    var i: Int32 = 0

    G_SpawnInt("nobots", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_BOTS
    }
    G_SpawnInt("nohumans", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_HUMANS
    }
}

/**
```
QUAKED info_player_duel2 (1 0 1) (-16 -16 -24) (16 16 32) initial
potential spawning position for paired duelists in powerduel.
Targets will be fired when someone spawns in on them.
"nobots" will prevent bots from using this spot.
"nohumans" will prevent non-bots from using this spot.
```
*/
/// Source: oracle/codemp/game/g_client.c:67
func SP_info_player_duel2(_ ent: Entity) {
    var i: Int32 = 0

    G_SpawnInt("nobots", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_BOTS
    }
    G_SpawnInt("nohumans", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_HUMANS
    }
}

/**
```
QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 32) initial
potential spawning position for deathmatch games.
The first time a player enters the game, they will be at an 'initial' spot.
Targets will be fired when someone spawns in on them.
"nobots" will prevent bots from using this spot.
"nohumans" will prevent non-bots from using this spot.
```
*/
/// Source: oracle/codemp/game/g_client.c:88
func SP_info_player_deathmatch(_ ent: Entity) {
    var i: Int32 = 0

    G_SpawnInt("nobots", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_BOTS
    }
    G_SpawnInt("nohumans", "0", &i)
    if i != 0 {
        ent.flags |= FL_NO_HUMANS
    }
}

/**
```
QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 32)
Targets will be fired when someone spawns in on them.
equivelant to info_player_deathmatch
```
*/
/// Source: oracle/codemp/game/g_client.c:105
func SP_info_player_start(_ ent: Entity) {
    ent.classname = "info_player_deathmatch"
    SP_info_player_deathmatch(ent)
}

/**
```
QUAKED info_player_start_red (1 0 0) (-16 -16 -24) (16 16 32) INITIAL
For Red Team DM starts

Targets will be fired when someone spawns in on them.
equivalent to info_player_deathmatch

INITIAL - The first time a player enters the game, they will be at an 'initial' spot.

"nobots" will prevent bots from using this spot.
"nohumans" will prevent non-bots from using this spot.
```
*/
/// Source: oracle/codemp/game/g_client.c:121
func SP_info_player_start_red(_ ent: Entity) {
    SP_info_player_deathmatch(ent)
}

/**
```
QUAKED info_player_start_blue (1 0 0) (-16 -16 -24) (16 16 32) INITIAL
For Blue Team DM starts

Targets will be fired when someone spawns in on them.
equivalent to info_player_deathmatch

INITIAL - The first time a player enters the game, they will be at an 'initial' spot.

"nobots" will prevent bots from using this spot.
"nohumans" will prevent non-bots from using this spot.
```
*/
/// Source: oracle/codemp/game/g_client.c:136
func SP_info_player_start_blue(_ ent: Entity) {
    SP_info_player_deathmatch(ent)
}

/// Source: oracle/codemp/game/g_client.c:140
func SiegePointUse(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    //Toggle the point on/off
    if `self`.genericValue1 != 0 {
        `self`.genericValue1 = 0
    } else {
        `self`.genericValue1 = 1
    }
}

/**
```
QUAKED info_player_siegeteam1 (1 0 0) (-16 -16 -24) (16 16 32)
siege start point - team1
name and behavior of team1 depends on what is defined in the
.siege file for this level

startoff - if non-0 spawn point will be disabled until used
idealclass - if specified, this spawn point will be considered
"ideal" for players of this class name. Corresponds to the name
entry in the .scl (siege class) file.
Targets will be fired when someone spawns in on them.
```
*/
/// Source: oracle/codemp/game/g_client.c:164
func SP_info_player_siegeteam1(_ ent: Entity) {
    var soff: Int32 = 0

    if g_gametype.integer != GT_SIEGE {
        //turn into a DM spawn if not in siege game mode
        ent.classname = "info_player_deathmatch"
        SP_info_player_deathmatch(ent)

        return
    }

    G_SpawnInt("startoff", "0", &soff)

    if soff != 0 {
        //start disabled
        ent.genericValue1 = 0
    } else {
        ent.genericValue1 = 1
    }

    ent.use = Use.SiegePointUse
}

/**
```
QUAKED info_player_siegeteam2 (0 0 1) (-16 -16 -24) (16 16 32)
siege start point - team2
name and behavior of team2 depends on what is defined in the
.siege file for this level

startoff - if non-0 spawn point will be disabled until used
idealclass - if specified, this spawn point will be considered
"ideal" for players of this class name. Corresponds to the name
entry in the .scl (siege class) file.
Targets will be fired when someone spawns in on them.
```
*/
/// Source: oracle/codemp/game/g_client.c:200
func SP_info_player_siegeteam2(_ ent: Entity) {
    var soff: Int32 = 0

    if g_gametype.integer != GT_SIEGE {
        //turn into a DM spawn if not in siege game mode
        ent.classname = "info_player_deathmatch"
        SP_info_player_deathmatch(ent)

        return
    }

    G_SpawnInt("startoff", "0", &soff)

    if soff != 0 {
        //start disabled
        ent.genericValue1 = 0
    } else {
        ent.genericValue1 = 1
    }

    ent.use = Use.SiegePointUse
}

/**
```
QUAKED info_player_intermission (1 0 1) (-16 -16 -24) (16 16 32) RED BLUE
The intermission will be viewed from this point.  Target an info_notnull for the view direction.
RED - In a Siege game, the intermission will happen here if the Red (attacking) team wins
BLUE - In a Siege game, the intermission will happen here if the Blue (defending) team wins
```
*/
/// Source: oracle/codemp/game/g_client.c:230
func SP_info_player_intermission(_ ent: Entity) {
}

/**
```
QUAKED info_player_intermission_red (1 0 1) (-16 -16 -24) (16 16 32)
The intermission will be viewed from this point.  Target an info_notnull for the view direction.

In a Siege game, the intermission will happen here if the Red (attacking) team wins
target - ent to look at
target2 - ents to use when this intermission point is chosen
```
*/
/// Source: oracle/codemp/game/g_client.c:241
func SP_info_player_intermission_red(_ ent: Entity) {
}

/**
```
QUAKED info_player_intermission_blue (1 0 1) (-16 -16 -24) (16 16 32)
The intermission will be viewed from this point.  Target an info_notnull for the view direction.

In a Siege game, the intermission will happen here if the Blue (defending) team wins
target - ent to look at
target2 - ents to use when this intermission point is chosen
```
*/
/// Source: oracle/codemp/game/g_client.c:252
func SP_info_player_intermission_blue(_ ent: Entity) {
}

/// Source: oracle/codemp/game/g_client.c:258
func ThrowSaberToAttacker(_ `self`: Entity, _ attacker: Entity?) {
    var ent: Entity? = g_entities[`self`.client!.ps.saberIndex]
    var a = vec3_t()
    var altVelocity: Int32 = 0

    if ent == nil || ent!.enemy != `self` {
        //something has gone very wrong (this should never happen)
        //but in case it does.. find the saber manually
        ent = gJMSaberEnt

        if ent == nil {
            return
        }


        ent!.enemy = `self`
        `self`.client!.ps.saberIndex = ent!.s.number
    }

    trap_SetConfigstring(CS_CLIENT_JEDIMASTER, "-1")

    if attacker != nil && attacker!.client != nil && `self`.client!.ps.saberInFlight {
        //someone killed us and we had the saber thrown, so actually move this saber to the saber location
        //if we killed ourselves with saber thrown, however, same suicide rules of respawning at spawn spot still
        //apply.
        let flyingsaber: Entity? = g_entities[`self`.client!.ps.saberEntityNum]

        if flyingsaber != nil && flyingsaber!.inuse {
            ent!.s.pos.trBase = flyingsaber!.s.pos.trBase
            ent!.s.pos.trDelta = flyingsaber!.s.pos.trDelta
            ent!.s.apos.trBase = flyingsaber!.s.apos.trBase
            ent!.s.apos.trDelta = flyingsaber!.s.apos.trDelta

            ent!.r.currentOrigin = flyingsaber!.r.currentOrigin
            ent!.r.currentAngles = flyingsaber!.r.currentAngles
            altVelocity = 1
        }
    }

    `self`.client!.ps.saberInFlight = true //say he threw it anyway in order to properly remove from dead body

    WP_SaberAddG2Model(ent!, `self`.client!.saber[0].model, `self`.client!.saber[0].skin)

    ent!.s.eFlags &= ~(EF_NODRAW)
    ent!.s.modelGhoul2 = 1
    ent!.s.eType = ET_MISSILE
    ent!.enemy = nil

    if attacker == nil || attacker!.client == nil {
        ent!.s.pos.trBase = ent!.s.origin2
        ent!.s.origin = ent!.s.origin2
        ent!.r.currentOrigin = ent!.s.origin2
        ent!.pos2[0] = 0
        trap_LinkEntity(ent!)
        return
    }

    if altVelocity == 0 {
        ent!.s.pos.trBase = `self`.s.pos.trBase
        ent!.s.origin = `self`.s.pos.trBase
        ent!.r.currentOrigin = `self`.s.pos.trBase

        a = attacker!.client!.ps.origin - ent!.s.pos.trBase

        VectorNormalize(&a)

        ent!.s.pos.trDelta[0] = a[0] * 256
        ent!.s.pos.trDelta[1] = a[1] * 256
        ent!.s.pos.trDelta[2] = 256
    }

    trap_LinkEntity(ent!)
}

/// Source: oracle/codemp/game/g_client.c:346
func JMSaberThink(_ ent: Entity) {
    gJMSaberEnt = ent

    if ent.enemy != nil {
        if ent.enemy!.client == nil || !ent.enemy!.inuse {
            //disconnected?
            ent.s.pos.trBase = ent.enemy!.s.pos.trBase
            ent.s.origin = ent.enemy!.s.pos.trBase
            ent.r.currentOrigin = ent.enemy!.s.pos.trBase
            ent.s.modelindex = G_ModelIndex("models/weapons2/saber/saber_w.glm")
            ent.s.eFlags &= ~(EF_NODRAW)
            ent.s.modelGhoul2 = 1
            ent.s.eType = ET_MISSILE
            ent.enemy = nil

            ent.pos2[0] = 1
            ent.pos2[1] = 0 //respawn next think
            trap_LinkEntity(ent)
        } else {
            ent.pos2[1] = Float(level.time + JMSABER_RESPAWN_TIME)
        }
    } else if ent.pos2[0] != 0 && ent.pos2[1] < level.time {
        ent.s.pos.trBase = ent.s.origin2
        ent.s.origin = ent.s.origin2
        ent.r.currentOrigin = ent.s.origin2
        ent.pos2[0] = 0
        trap_LinkEntity(ent)
    }

    ent.nextthink = level.time + 50
    G_RunObject(ent)
}

/// Source: oracle/codemp/game/g_client.c:385
func JMSaberTouch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var i: Int32 = 0
    //	gentity_t *te;

    if other.client == nil || other.health < 1 {
        return
    }

    if `self`.enemy != nil {
        return
    }

    if `self`.s.modelindex == 0 {
        return
    }

    if (other.client!.ps.stats[STAT_WEAPONS] & (1 << WP_SABER)) != 0 {
        return
    }

    if other.client!.ps.isJediMaster {
        return
    }

    `self`.enemy = other
    other.client!.ps.stats[STAT_WEAPONS] = (1 << WP_SABER)
    other.client!.ps.weapon = WP_SABER
    other.s.weapon = WP_SABER
    G_AddEvent(other, EV_BECOME_JEDIMASTER, 0)

    // Track the jedi master
    trap_SetConfigstring(CS_CLIENT_JEDIMASTER, va("%i", other.s.number))

    if g_spawnInvulnerability.integer != 0 {
        other.client!.ps.eFlags |= EF_INVULNERABLE
        other.client!.invulnerableTimer = level.time + g_spawnInvulnerability.integer
    }

    trap_SendServerCommand(-1, va("cp \"%s %s\n\"", other.client!.pers.netname, G_GetStringEdString("MP_SVGAME", "BECOMEJM")))

    other.client!.ps.isJediMaster = true
    other.client!.ps.saberIndex = `self`.s.number

    if other.health < 200 && other.health > 0 {
        //full health when you become the Jedi Master
        other.health = 200
        other.client!.ps.stats[STAT_HEALTH] = other.health
    }

    if other.client!.ps.fd.forcePower < 100 {
        other.client!.ps.fd.forcePower = 100
    }

    while i < NUM_FORCE_POWERS {
        other.client!.ps.fd.forcePowersKnown |= (1 << i)
        other.client!.ps.fd.forcePowerLevel[i] = FORCE_LEVEL_3

        i += 1
    }

    `self`.pos2[0] = 1
    `self`.pos2[1] = Float(level.time + JMSABER_RESPAWN_TIME)

    `self`.s.modelindex = 0
    `self`.s.eFlags |= EF_NODRAW
    `self`.s.modelGhoul2 = 0
    `self`.s.eType = ET_GENERAL

    /*
    te = G_TempEntity( vec3_origin, EV_DESTROY_GHOUL2_INSTANCE );
    te->r.svFlags |= SVF_BROADCAST;
    te->s.eventParm = self->s.number;
    */
    G_KillG2Queue(`self`.s.number)

    return
}

/**
```
QUAKED info_jedimaster_start (1 0 0) (-16 -16 -24) (16 16 32)
"jedi master" saber spawn point
```
*/
/// Source: oracle/codemp/game/g_client.c:476
func SP_info_jedimaster_start(_ ent: Entity) {
    if g_gametype.integer != GT_JEDIMASTER {
        gJMSaberEnt = nil
        G_FreeEntity(ent)
        return
    }

    ent.enemy = nil

    ent.flags = FL_BOUNCE_HALF

    ent.s.modelindex = G_ModelIndex("models/weapons2/saber/saber_w.glm")
    ent.s.modelGhoul2 = 1
    ent.s.g2radius = 20
    //ent->s.eType = ET_GENERAL;
    ent.s.eType = ET_MISSILE
    ent.s.weapon = WP_SABER
    ent.s.pos.trType = TR_GRAVITY
    ent.s.pos.trTime = level.time
    ent.r.maxs = vec3_t(3, 3, 3)
    ent.r.mins = vec3_t(-3, -3, -3)
    ent.r.contents = CONTENTS_TRIGGER
    ent.clipmask = MASK_SOLID

    ent.isSaberEntity = true

    ent.bounceCount = -5

    ent.physicsObject = true

    ent.s.origin2 = ent.s.pos.trBase //remember the spawn spot

    ent.touch = Touch.JMSaberTouch

    trap_LinkEntity(ent)

    ent.think = Think.JMSaberThink
    ent.nextthink = level.time + 50
}

/**
```
================
SpotWouldTelefrag

================
```
*/
/// Source: oracle/codemp/game/g_client.c:532
func SpotWouldTelefrag(_ spot: Entity) -> Bool {
    var i: Int32
    let num: Int32
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
    var hit: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()

    mins = spot.s.origin + playerMins
    maxs = spot.s.origin + playerMaxs
    num = trap_EntitiesInBox(mins, maxs, &touch, MAX_GENTITIES)

    i = 0
    while i < num {
        hit = g_entities[touch[i]]
        //if ( hit->client && hit->client->ps.stats[STAT_HEALTH] > 0 ) {
        if hit!.client != nil {
            return true
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_client.c:554
func SpotWouldTelefrag2(_ mover: Entity, _ dest: JKAShared.vec3_t) -> Bool {
    var i: Int32
    let num: Int32
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
    var hit: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()

    mins = dest + mover.r.mins
    maxs = dest + mover.r.maxs
    num = trap_EntitiesInBox(mins, maxs, &touch, MAX_GENTITIES)

    i = 0
    while i < num {
        hit = g_entities[touch[i]]
        if hit == mover {
            i += 1
            continue
        }

        if (hit!.r.contents & mover.r.contents) != 0 {
            return true
        }
        i += 1
    }

    return false
}

/// Source: oracle/codemp/game/g_client.c:590
func SelectNearestDeathmatchSpawnPoint(_ from: JKAShared.vec3_t) -> Entity? {
    var spot: Entity?
    var delta = vec3_t()
    var dist: Float
    var nearestDist: Float
    var nearestSpot: Entity?

    nearestDist = 999999
    nearestSpot = nil
    spot = nil

    // Port-note: An assignment inside an expression.
    // Raven wrote: while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) { VectorSubtract( spot->s.origin, from, delta ); dist = VectorLength( delta ); if ( dist < nearestDist ) { nearestDist = dist; nearestSpot = spot; } }
    portMissing("SelectNearestDeathmatchSpawnPoint", source: "oracle/codemp/game/g_client.c:590")

    return nearestSpot
}

/// Source: oracle/codemp/game/g_client.c:622
func SelectRandomDeathmatchSpawnPoint() -> Entity? {
    var spot: Entity?
    var count: Int32
    let selection: Int32
    var spots = [Entity?](repeating: nil, count: Int(MAX_SPAWN_POINTS))

    count = 0
    spot = nil

    // Port-note: An assignment inside an expression.
    // Raven wrote: while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) { if ( SpotWouldTelefrag( spot ) ) { continue; } spots[ count ] = spot; count++; }
    portMissing("SelectRandomDeathmatchSpawnPoint", source: "oracle/codemp/game/g_client.c:622")

    if count == 0 {
        // no spots that won't telefrag
        // Port-note: No operator beside the operand, the text there is ``.
        // Raven wrote: return G_Find( NULL, FOFS(classname), "info_player_deathmatch")
        portMissing("SelectRandomDeathmatchSpawnPoint", source: "oracle/codemp/game/g_client.c:622")
    }

    // The SDK also declares `rand`, so the call names the bg module.
    selection = JKAMP_BG.rand() % count
    return spots[selection]
}

/**
```
===========
SelectRandomFurthestSpawnPoint

Chooses a player start, deathmatch start, etc
============
```
*/
/// Source: oracle/codemp/game/g_client.c:654
func SelectRandomFurthestSpawnPoint(_ avoidPoint: JKAShared.vec3_t, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t, _ team: JKAMP.team_t) -> Entity? {
    var spot: Entity?
    var delta = vec3_t()
    var dist: Float
    var list_dist: [Float] = [Float](repeating: 0, count: 64)
    var list_spot = [Entity?](repeating: nil, count: 64)
    var numSpots: Int32
    let rnd: Int32
    var i: Int32
    var j: Int32

    numSpots = 0
    spot = nil

    //in Team DM, look for a team start spot first, if any
    if g_gametype.integer == GT_TEAM && team != TEAM_FREE && team != TEAM_SPECTATOR {
        var classname: String? = nil
        if team == TEAM_RED {
            classname = "info_player_start_red"
        } else {
            classname = "info_player_start_blue"
        }
        // Port-note: An assignment inside an expression.
        // Raven wrote: while ((spot = G_Find (spot, FOFS(classname), classname)) != NULL) { if ( SpotWouldTelefrag( spot ) ) { continue; } VectorSubtract( spot->s.origin, avoidPoint, delta ); dist = VectorLength( delta ); for (i = 0; i < numSpots; i++) { if ( dist > list_dist[i] ) { if ( numSpots >= 64 ) numSpots = 64-1; for (j = numSpots; j > i; j--) { list_dist[j] = list_dist[j-1]; list_spot[j] = list_spot[j-1]; } list_dist[i] = dist; list_spot[i] = spot; numSpots++; if (numSpots > 64) numSpots = 64; break; } } if (i >= numSpots && numSpots < 64) { list_dist[numSpots] = dist; list_spot[numSpots] = spot; numSpots++; } }
        portMissing("SelectRandomFurthestSpawnPoint", source: "oracle/codemp/game/g_client.c:654")
    }

    if numSpots == 0 {
        //couldn't find any of the above
        // Port-note: An assignment inside an expression.
        // Raven wrote: while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) { if ( SpotWouldTelefrag( spot ) ) { continue; } VectorSubtract( spot->s.origin, avoidPoint, delta ); dist = VectorLength( delta ); for (i = 0; i < numSpots; i++) { if ( dist > list_dist[i] ) { if ( numSpots >= 64 ) numSpots = 64-1; for (j = numSpots; j > i; j--) { list_dist[j] = list_dist[j-1]; list_spot[j] = list_spot[j-1]; } list_dist[i] = dist; list_spot[i] = spot; numSpots++; if (numSpots > 64) numSpots = 64; break; } } if (i >= numSpots && numSpots < 64) { list_dist[numSpots] = dist; list_spot[numSpots] = spot; numSpots++; } }
        portMissing("SelectRandomFurthestSpawnPoint", source: "oracle/codemp/game/g_client.c:654")
        if numSpots == 0 {
            // Port-note: No operator beside the operand, the text there is ``.
            // Raven wrote: spot = G_Find( NULL, FOFS(classname), "info_player_deathmatch")
            portMissing("SelectRandomFurthestSpawnPoint", source: "oracle/codemp/game/g_client.c:654")
            if spot == nil {
                G_Error("Couldn't find a spawn point")
            }
            origin = spot!.s.origin
            origin[2] += 9
            angles = spot!.s.angles
            return spot
        }
    }

    // select a random spot from the spawn points furthest away
    // The SDK also declares `random`, so the call names the bg module.
    rnd = Int32(JKAMP_BG.random() * (numSpots / 2))

    origin = list_spot[rnd]!.s.origin
    origin[2] += 9
    angles = list_spot[rnd]!.s.angles

    return list_spot[rnd]
}

/// Source: oracle/codemp/game/g_client.c:760
func SelectDuelSpawnPoint(_ team: Int32, _ avoidPoint: JKAShared.vec3_t, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) -> Entity? {
    var spot: Entity?
    var delta = vec3_t()
    var dist: Float
    var list_dist: [Float] = [Float](repeating: 0, count: 64)
    var list_spot = [Entity?](repeating: nil, count: 64)
    var numSpots: Int32
    let rnd: Int32
    var i: Int32
    var j: Int32
    var spotName: String

    if team == DUELTEAM_LONE {
        spotName = "info_player_duel1"
    } else if team == DUELTEAM_DOUBLE {
        spotName = "info_player_duel2"
    } else if team == DUELTEAM_SINGLE {
        spotName = "info_player_duel"
    } else {
        spotName = "info_player_deathmatch"
    }
    tryAgain: while true {

        numSpots = 0
        spot = nil

        // Port-note: An assignment inside an expression.
        // Raven wrote: while ((spot = G_Find (spot, FOFS(classname), spotName)) != NULL) { if ( SpotWouldTelefrag( spot ) ) { continue; } VectorSubtract( spot->s.origin, avoidPoint, delta ); dist = VectorLength( delta ); for (i = 0; i < numSpots; i++) { if ( dist > list_dist[i] ) { if ( numSpots >= 64 ) numSpots = 64-1; for (j = numSpots; j > i; j--) { list_dist[j] = list_dist[j-1]; list_spot[j] = list_spot[j-1]; } list_dist[i] = dist; list_spot[i] = spot; numSpots++; if (numSpots > 64) numSpots = 64; break; } } if (i >= numSpots && numSpots < 64) { list_dist[numSpots] = dist; list_spot[numSpots] = spot; numSpots++; } }
        portMissing("SelectDuelSpawnPoint", source: "oracle/codemp/game/g_client.c:760")
        if numSpots == 0 {
            if Q_stricmp(spotName, "info_player_deathmatch") != 0 {
                //try the loop again with info_player_deathmatch as the target if we couldn't find a duel spot
                spotName = "info_player_deathmatch"
                continue tryAgain
            }

            //If we got here we found no free duel or DM spots, just try the first DM spot
            // Port-note: No operator beside the operand, the text there is ``.
            // Raven wrote: spot = G_Find( NULL, FOFS(classname), "info_player_deathmatch")
            portMissing("SelectDuelSpawnPoint", source: "oracle/codemp/game/g_client.c:760")
            if spot == nil {
                G_Error("Couldn't find a spawn point")
            }
            origin = spot!.s.origin
            origin[2] += 9
            angles = spot!.s.angles
            return spot
        }

        // select a random spot from the spawn points furthest away
        // The SDK also declares `random`, so the call names the bg module.
        rnd = Int32(JKAMP_BG.random() * (numSpots / 2))

        origin = list_spot[rnd]!.s.origin
        origin[2] += 9
        angles = list_spot[rnd]!.s.angles

        return list_spot[rnd]
    }
}

/**
```
===========
SelectSpawnPoint

Chooses a player start, deathmatch start, etc
============
```
*/
/// Source: oracle/codemp/game/g_client.c:854
func SelectSpawnPoint(_ avoidPoint: JKAShared.vec3_t, _ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t, _ team: JKAMP.team_t) -> Entity? {
    return SelectRandomFurthestSpawnPoint(avoidPoint, &origin, &angles, team)

    /*
    gentity_t	*spot;
    gentity_t	*nearestSpot;

    nearestSpot = SelectNearestDeathmatchSpawnPoint( avoidPoint );

    spot = SelectRandomDeathmatchSpawnPoint ( );
    if ( spot == nearestSpot ) {
    // roll again if it would be real close to point of death
    spot = SelectRandomDeathmatchSpawnPoint ( );
    if ( spot == nearestSpot ) {
    // last try
    spot = SelectRandomDeathmatchSpawnPoint ( );
    }
    }

    // find a single player start spot
    if (!spot) {
    G_Error( "Couldn't find a spawn point" );
    }

    VectorCopy (spot->s.origin, origin);
    origin[2] += 9;
    VectorCopy (spot->s.angles, angles);

    return spot;
    */
}

/**
```
===========
SelectInitialSpawnPoint

Try to find a spawn point marked 'initial', otherwise
use normal spawn selection.
============
```
*/
/// Source: oracle/codemp/game/g_client.c:894
func SelectInitialSpawnPoint(_ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t, _ team: JKAMP.team_t) -> Entity? {
    var spot: Entity?

    spot = nil
    // Port-note: An assignment inside an expression.
    // Raven wrote: while ((spot = G_Find (spot, FOFS(classname), "info_player_deathmatch")) != NULL) { if ( spot->spawnflags & 1 ) { break; } }
    portMissing("SelectInitialSpawnPoint", source: "oracle/codemp/game/g_client.c:894")

    if spot == nil || SpotWouldTelefrag(spot!) {
        return SelectSpawnPoint(vec3_origin, &origin, &angles, team)
    }

    origin = spot!.s.origin
    origin[2] += 9
    angles = spot!.s.angles

    return spot
}

/**
```
===========
SelectSpectatorSpawnPoint

============
```
*/
/// Source: oracle/codemp/game/g_client.c:921
func SelectSpectatorSpawnPoint(_ origin: inout JKAShared.vec3_t, _ angles: inout JKAShared.vec3_t) -> Entity? {
    FindIntermissionPoint()

    origin = level.intermission_origin
    angles = level.intermission_angle

    return nil
}

/**
```
===============
InitBodyQue
===============
```
*/
/// Source: oracle/codemp/game/g_client.c:953
func InitBodyQue() {
    var i: Int32
    var ent: Entity?

    level.bodyQueIndex = 0
    i = 0
    while i < BODY_QUEUE_SIZE {
        ent = G_Spawn()
        ent!.classname = "bodyque"
        ent!.neverFree = true
        level.bodyQue[i] = ent
        i += 1
    }
}

/**
```
=============
BodySink

After sitting around for five seconds, fall into the ground and dissapear
=============
```
*/
/// Source: oracle/codemp/game/g_client.c:973
func BodySink(_ ent: Entity) {
    if level.time - ent.timestamp > BODY_SINK_TIME + 2500 {
        // the body ques are never actually freed, they are just unlinked
        trap_UnlinkEntity(ent)
        ent.physicsObject = false
        return
    }
    //	ent->nextthink = level.time + 100;
    //	ent->s.pos.trBase[2] -= 1;

    G_AddEvent(ent, EV_BODYFADE, 0)
    ent.nextthink = level.time + 18000
    ent.takedamage = false
}

/**
```
=============
CopyToBodyQue

A player is respawning, so make an entity that looks
just like the existing corpse to leave behind.
=============
```
*/
/// Source: oracle/codemp/game/g_client.c:996
private func CopyToBodyQue(_ ent: Entity) -> Bool {
    var body: Entity?
    let contents: Int32
    var islight: Int32 = 0

    if level.intermissiontime != 0 {
        return false
    }

    trap_UnlinkEntity(ent)

    // if client is in a nodrop area, don't leave the body
    contents = trap_PointContents(ent.s.origin, -1)
    if (contents & CONTENTS_NODROP) != 0 {
        return false
    }

    if ent.client != nil && (ent.client!.ps.eFlags & EF_DISINTEGRATION) != 0 {
        //for now, just don't spawn a body if you got disint'd
        return false
    }

    // grab a body que and cycle to the next one
    body = level.bodyQue[level.bodyQueIndex]
    level.bodyQueIndex = (level.bodyQueIndex + 1) % BODY_QUEUE_SIZE

    trap_UnlinkEntity(body!)
    body!.s.copy(from: ent.s)

    //avoid oddly angled corpses floating around
    body!.s.apos.trBase[ROLL] = 0
    body!.s.apos.trBase[PITCH] = body!.s.apos.trBase[ROLL]
    body!.s.angles[ROLL] = body!.s.apos.trBase[PITCH]
    body!.s.angles[PITCH] = body!.s.angles[ROLL]

    body!.s.g2radius = 100

    body!.s.eType = ET_BODY
    body!.s.eFlags = EF_DEAD // clear EF_TALK, etc

    if ent.client != nil && (ent.client!.ps.eFlags & EF_DISINTEGRATION) != 0 {
        body!.s.eFlags |= EF_DISINTEGRATION
    }

    body!.s.origin2 = ent.client!.ps.lastHitLoc

    body!.s.powerups = 0 // clear powerups
    body!.s.loopSound = 0 // clear lava burning
    body!.s.loopIsSoundset = false
    body!.s.number = g_entities.slot(of: body!)
    body!.timestamp = level.time
    body!.physicsObject = true
    body!.physicsBounce = 0 // don't bounce
    if body!.s.groundEntityNum == ENTITYNUM_NONE {
        body!.s.pos.trType = TR_GRAVITY
        body!.s.pos.trTime = level.time
        body!.s.pos.trDelta = ent.client!.ps.velocity
    } else {
        body!.s.pos.trType = TR_STATIONARY
    }
    body!.s.event = 0

    body!.s.weapon = ent.s.bolt2

    if body!.s.weapon == WP_SABER && ent.client!.ps.saberInFlight {
        body!.s.weapon = WP_BLASTER //lie to keep from putting a saber on the corpse, because it was thrown at death
    }

    //G_AddEvent(body, EV_BODY_QUEUE_COPY, ent->s.clientNum);
    //Now doing this through a modified version of the rcg reliable command.
    if ent.client != nil && ent.client!.ps.fd.forceSide == FORCE_LIGHTSIDE {
        islight = 1
    }
    trap_SendServerCommand(-1, va("ircg %i %i %i %i", ent.s.number, body!.s.number, body!.s.weapon, islight))

    body!.r.svFlags = ent.r.svFlags | SVF_BROADCAST
    body!.r.mins = ent.r.mins
    body!.r.maxs = ent.r.maxs
    body!.r.absmin = ent.r.absmin
    body!.r.absmax = ent.r.absmax

    body!.s.legsAnim = ent.client!.ps.legsAnim
    body!.s.torsoAnim = body!.s.legsAnim

    body!.s.customRGBA[0] = ent.client!.ps.customRGBA[0]
    body!.s.customRGBA[1] = ent.client!.ps.customRGBA[1]
    body!.s.customRGBA[2] = ent.client!.ps.customRGBA[2]
    body!.s.customRGBA[3] = ent.client!.ps.customRGBA[3]

    body!.clipmask = CONTENTS_SOLID | CONTENTS_PLAYERCLIP
    body!.r.contents = CONTENTS_CORPSE
    body!.r.ownerNum = ent.s.number

    body!.nextthink = level.time + BODY_SINK_TIME
    body!.think = Think.BodySink

    body!.die = Die.body_die

    // don't take more damage if already gibbed
    if ent.health <= GIB_HEALTH {
        body!.takedamage = false
    } else {
        body!.takedamage = true
    }

    body!.r.currentOrigin = body!.s.pos.trBase
    trap_LinkEntity(body!)

    return true
}

/**
```
==================
SetClientViewAngle

==================
```
*/
/// Source: oracle/codemp/game/g_client.c:1116
func SetClientViewAngle(_ ent: Entity, _ angle: JKAShared.vec3_t) {
    var i: Int32

    // set the delta angle
    i = 0
    while i < 3 {
        var cmdAngle: Int32

        cmdAngle = ANGLE2SHORT(angle[i])
        ent.client!.ps.delta_angles[i] = cmdAngle - ent.client!.pers.cmd.angles[i]
        i += 1
    }
    ent.s.angles = angle
    ent.client!.ps.viewangles = ent.s.angles
}

/// Source: oracle/codemp/game/g_client.c:1130
func MaintainBodyQueue(_ ent: Entity) {
    //do whatever should be done taking ragdoll and dismemberment states into account.
    var doRCG: Bool = false

    if ent.client!.tempSpectate > level.time || (ent.client!.ps.eFlags2 & EF2_SHIP_DEATH) != 0 {
        ent.client!.noCorpse = true
    }

    if !ent.client!.noCorpse && ent.client!.ps.fallingToDeath == 0 {
        if !CopyToBodyQue(ent) {
            doRCG = true
        }
    } else {
        ent.client!.noCorpse = false //clear it for next time
        ent.client!.ps.fallingToDeath = 0
        doRCG = true
    }

    if doRCG {
        //bodyque func didn't manage to call ircg so call this to assure our limbs and ragdoll states are proper on the client.
        trap_SendServerCommand(-1, va("rcg %i", ent.s.clientNum))
    }
}

/// Source: oracle/codemp/game/g_client.c:1167
func respawn(_ ent: Entity) {
    MaintainBodyQueue(ent)

    if gEscaping || g_gametype.integer == GT_POWERDUEL {
        ent.client!.sess.sessionTeam = TEAM_SPECTATOR
        ent.client!.sess.spectatorState = SPECTATOR_FREE
        ent.client!.sess.spectatorClient = 0

        ent.client!.pers.teamState.state = TEAM_BEGIN
        ent.client!.sess.spectatorTime = level.time
        ClientSpawn(ent)
        ent.client!.iAmALoser = true
        return
    }

    trap_UnlinkEntity(ent)

    if g_gametype.integer == GT_SIEGE {
        if g_siegeRespawn.integer != 0 {
            if ent.client!.tempSpectate <= level.time {
                var minDel: Int32 = g_siegeRespawn.integer * 2000
                if minDel < 20000 {
                    minDel = 20000
                }
                ent.client!.tempSpectate = level.time + minDel
                ent.client!.ps.stats[STAT_HEALTH] = 1
                ent.health = ent.client!.ps.stats[STAT_HEALTH]
                ent.client!.ps.weapon = WP_NONE
                ent.client!.ps.stats[STAT_WEAPONS] = 0
                ent.client!.ps.stats[STAT_HOLDABLE_ITEMS] = 0
                ent.client!.ps.stats[STAT_HOLDABLE_ITEM] = 0
                ent.takedamage = false
                trap_LinkEntity(ent)

                // Respawn time.
                if ent.s.number < MAX_CLIENTS {
                    let te: Entity? = G_TempEntity(ent.client!.ps.origin, EV_SIEGESPEC)
                    te!.s.time = g_siegeRespawnCheck
                    te!.s.owner = ent.s.number
                }

                return
            }
        }
        SiegeRespawn(ent)
    } else {
        var tent: Entity?

        ClientSpawn(ent)

        // add a teleportation effect
        tent = G_TempEntity(ent.client!.ps.origin, EV_PLAYER_TELEPORT_IN)
        tent!.s.clientNum = ent.s.clientNum
    }
}

/**
```
================
TeamCount

Returns number of players on a team
================
```
*/
/// Source: oracle/codemp/game/g_client.c:1237
func TeamCount(_ ignoreClientNum: Int32, _ team: Int32) -> JKAMP.team_t {
    var i: Int32
    var count: Int32 = 0

    i = 0
    while i < level.maxclients {
        if i == ignoreClientNum {
            i += 1
            continue
        }
        if level.clientsSlots[i].pers.connected == CON_DISCONNECTED {
            i += 1
            continue
        }
        if level.clientsSlots[i].sess.sessionTeam == team {
            count += 1
        } else if g_gametype.integer == GT_SIEGE && level.clientsSlots[i].sess.siegeDesiredTeam == team {
            count += 1
        }
        i += 1
    }

    return count
}

/**
```
================
TeamLeader

Returns the client number of the team leader
================
```
*/
/// Source: oracle/codemp/game/g_client.c:1268
func TeamLeader(_ team: Int32) -> Int32 {
    var i: Int32

    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].pers.connected == CON_DISCONNECTED {
            i += 1
            continue
        }
        if level.clientsSlots[i].sess.sessionTeam == team {
            if level.clientsSlots[i].sess.teamLeader {
                return i
            }
        }
        i += 1
    }

    return -1
}

/**
```
================
PickTeam

================
```
*/
/// Source: oracle/codemp/game/g_client.c:1291
func PickTeam(_ ignoreClientNum: Int32) -> JKAMP.team_t {
    var counts: [Int32] = [Int32](repeating: 0, count: 4)

    counts[TEAM_BLUE] = TeamCount(ignoreClientNum, TEAM_BLUE)
    counts[TEAM_RED] = TeamCount(ignoreClientNum, TEAM_RED)

    if counts[TEAM_BLUE] > counts[TEAM_RED] {
        return TEAM_RED
    }
    if counts[TEAM_RED] > counts[TEAM_BLUE] {
        return TEAM_BLUE
    }
    // equal team count, so join the team with the lowest score
    if level.teamScores[TEAM_BLUE] > level.teamScores[TEAM_RED] {
        return TEAM_RED
    }
    return TEAM_BLUE
}

/**
```
===========
ClientCheckName
============
```
*/
/// Source: oracle/codemp/game/g_client.c:1335
private func ClientCleanName(_ `in`: String, _ out: inout JKAShared.CharBuf, _ outSize: Int32) {
    var len: Int32
    var colorlessLen: Int32
    var ch: CChar
    // Raven's `p` is a pointer into `out`, so it is a byte offset.
    var p: Int32
    var spaces: Int32
    // Raven steps his own ``in`` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var `in` = TextCursor(CharBuf(`in`))
    // Raven assigns his own `outSize` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var outSize = outSize
    // Raven steps his own `out` parameter through its bytes, so the body holds the byte offset of his pointer.
    var outIndex: Int32 = 0

    //save room for trailing null byte
    outSize -= 1

    len = 0
    colorlessLen = 0
    p = outIndex
    out[p] = 0
    spaces = 0

    while 1 != 0 {
        ch = CChar(truncatingIfNeeded: `in`.byte)
        `in`.advance()
        if ch == 0 {
            break
        }

        // don't allow leading spaces
        if out[p] == 0 && ch == Int32(ascii: " ") {
            continue
        }

        // check colors
        if ch == Q_COLOR_ESCAPE {
            // solo trailing carat is not a color prefix
            if `in`.byte == 0 {
                break
            }

            // don't allow black in a name, period
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'CChar' (aka 'Int8')"
            portMissing("ClientCleanName", source: "oracle/codemp/game/g_client.c:1335")
            // if ColorIndex(`in`.byte) == 0 {
            //     `in`.advance()
            //     continue
            // }

            // make sure room in dest for both chars
            if len > outSize - 2 {
                break
            }

            out[outIndex] = ch
            outIndex += 1
            out[outIndex] = `in`.byte
            outIndex += 1
            `in`.advance()
            len += 2
            continue
        }

        // don't allow too many consecutive spaces
        if ch == Int32(ascii: " ") {
            spaces += 1
            if spaces > 3 {
                continue
            }
        } else {
            spaces = 0
        }

        if len > outSize - 1 {
            break
        }

        out[outIndex] = ch
        outIndex += 1
        colorlessLen += 1
        len += 1
    }
    out[outIndex] = 0

    // don't allow empty names
    if out[p] == 0 || colorlessLen == 0 {
        // Raven's `p` holds offset 0 of `out`, so the copy writes the whole buffer.
        Q_strncpyz(&out, "Padawan", outSize)
    }
}

/// Source: oracle/codemp/game/g_client.c:1423
func G_SaberModelSetup(_ ent: Entity) -> Bool {
    var i: Int32 = 0
    var fallbackForSaber: Bool = true

    while i < MAX_SABERS {
        if !ent.client!.saber[i].model.isEmpty {
            //first kill it off if we've already got it
            if ent.client!.weaponGhoul2[i] != nil {
                trap_G2API_CleanGhoul2Models(&(ent.client!.weaponGhoul2[i]))
            }
            trap_G2API_InitGhoul2Model(&ent.client!.weaponGhoul2[i], ent.client!.saber[i].model, 0, 0, -20, 0, 0)

            if ent.client!.weaponGhoul2[i] != nil {
                var j: Int32 = 0
                var tagName: String
                var tagBolt: Int32

                if ent.client!.saber[i].skin != 0 {
                    trap_G2API_SetSkin(ent.client!.weaponGhoul2[i], 0, ent.client!.saber[i].skin, ent.client!.saber[i].skin)
                }

                if (ent.client!.saber[i].saberFlags & SFL_BOLT_TO_WRIST) != 0 {
                    trap_G2API_SetBoltInfo(ent.client!.weaponGhoul2[i], 0, 3 + i)
                } else {
                    // bolt to right hand for 0, or left hand for 1
                    trap_G2API_SetBoltInfo(ent.client!.weaponGhoul2[i], 0, i)
                }

                //Add all the bolt points
                while j < ent.client!.saber[i].numBlades {
                    tagName = va("*blade%i", j + 1)
                    tagBolt = trap_G2API_AddBolt(ent.client!.weaponGhoul2[i], 0, tagName)

                    if tagBolt == -1 {
                        if j == 0 {
                            //guess this is an 0ldsk3wl saber
                            tagBolt = trap_G2API_AddBolt(ent.client!.weaponGhoul2[i], 0, "*flash")
                            fallbackForSaber = false
                            break
                        }

                        if tagBolt == -1 {
                            break
                        }
                    }
                    j += 1

                    fallbackForSaber = false //got at least one custom saber so don't need default
                }

                //Copy it into the main instance
                trap_G2API_CopySpecificGhoul2Model(ent.client!.weaponGhoul2[i], 0, ent.ghoul2, i + 1)
            }
        } else {
            break
        }

        i += 1
    }

    return fallbackForSaber
}

/// Source: oracle/codemp/game/g_client.c:1519
func SetupGameGhoul2Model(_ ent: Entity, _ modelname: inout JKAShared.CharBuf, _ skinName: inout JKAShared.CharBuf) {
    var handle: Int32
    var afilename = CharBuf(64)
    var GLAName = CharBuf(64)
    var tempVec = vec3_t(0, 0, 0)

    // First things first.  If this is a ghoul2 model, then let's make sure we demolish this first.
    if ent.ghoul2 != nil && trap_G2_HaveWeGhoul2Models(ent.ghoul2) {
        trap_G2API_CleanGhoul2Models(&(ent.ghoul2))
    }

    //rww - just load the "standard" model for the server"
    if precachedKyle == nil {
        let defSkin: Int32

        Com_sprintf(&afilename, Int32((afilename).count), "models/players/kyle/model.glm")
        handle = trap_G2API_InitGhoul2Model(&precachedKyle, String(afilename), 0, 0, -20, 0, 0)

        if handle < 0 {
            return
        }

        defSkin = trap_R_RegisterSkin("models/players/kyle/model_default.skin")
        trap_G2API_SetSkin(precachedKyle, 0, defSkin, defSkin)
    }

    if precachedKyle != nil && trap_G2_HaveWeGhoul2Models(precachedKyle) {
        if d_perPlayerGhoul2.integer != 0 || ent.s.number >= MAX_CLIENTS || G_PlayerHasCustomSkeleton(ent) {
            //rww - allow option for perplayer models on server for collision and bolt stuff.
            var modelFullPath = CharBuf(64)
            var truncModelName = CharBuf(64)
            var skin = CharBuf(64)
            var vehicleName = CharBuf(64)
            var skinHandle: Int32 = 0
            var i: Int32 = 0
            // Raven's `p` is a pointer into `truncModelName`, so it is a byte offset, and nil is his NULL.
            var p: Int32?

            // If this is a vehicle, get it's model name.
            if ent.client!.NPC_class == CLASS_VEHICLE {
                strcpy(&vehicleName, modelname)
                BG_GetVehicleModelName(&modelname)
                strcpy(&truncModelName, modelname)
                skin[0] = 0
                if ent.m_pVehicle != nil && ent.m_pVehicle!.m_pVehicleInfo != nil && ent.m_pVehicle!.m_pVehicleInfo!.skin != nil && !ent.m_pVehicle!.m_pVehicleInfo!.skin!.isEmpty {
                    skinHandle = trap_R_RegisterSkin(va("models/players/%s/model_%s.skin", modelname, ent.m_pVehicle!.m_pVehicleInfo!.skin!))
                } else {
                    skinHandle = trap_R_RegisterSkin(va("models/players/%s/model_default.skin", modelname))
                }
            } else {
                if skinName[0] != 0 {
                    strcpy(&skin, skinName)
                    strcpy(&truncModelName, modelname)
                } else {
                    strcpy(&skin, "default")

                    strcpy(&truncModelName, modelname)
                    p = Q_strrchr(String(truncModelName), Int32(ascii: "/"))

                    if p != nil {
                        truncModelName[p!] = 0
                        p! += 1

                        while p != nil && truncModelName[p!] != 0 {
                            skin[i] = truncModelName[p!]
                            i += 1
                            p! += 1
                        }
                        skin[i] = 0
                        i = 0
                    }

                    if !BG_IsValidCharacterModel(String(truncModelName), String(skin)) {
                        strcpy(&truncModelName, "kyle")
                        strcpy(&skin, "default")
                    }

                    if g_gametype.integer >= GT_TEAM && g_gametype.integer != GT_SIEGE && g_trueJedi.integer == 0 {
                        // Raven passes NULL for the `colors` output, so the body passes a scratch local it never reads.
                        var scratchColors = vec3_t()
                        BG_ValidateSkinForTeam(String(truncModelName), &skin, ent.client!.sess.sessionTeam, &scratchColors)
                    } else if g_gametype.integer == GT_SIEGE {
                        //force skin for class if appropriate
                        if ent.client!.siegeClass != -1 {
                            let scl: SiegeClass? = bgSiegeClasses[ent.client!.siegeClass]
                            if !scl!.forcedSkin.isEmpty {
                                strcpy(&skin, scl!.forcedSkin)
                            }
                        }
                    }
                }
            }

            if skin[0] != 0 {
                let useSkinName: String

                if strchr(skin, Int32(ascii: "|")) != nil {
                    //three part skin
                    useSkinName = va("models/players/%s/|%s", truncModelName, skin)
                } else {
                    useSkinName = va("models/players/%s/model_%s.skin", truncModelName, skin)
                }

                skinHandle = trap_R_RegisterSkin(useSkinName)
            }

            strcpy(&modelFullPath, va("models/players/%s/model.glm", truncModelName))
            handle = trap_G2API_InitGhoul2Model(&ent.ghoul2, String(modelFullPath), 0, skinHandle, -20, 0, 0)

            if handle < 0 {
                //Huh. Guess we don't have this model. Use the default.

                if ent.ghoul2 != nil && trap_G2_HaveWeGhoul2Models(ent.ghoul2) {
                    trap_G2API_CleanGhoul2Models(&(ent.ghoul2))
                }
                ent.ghoul2 = nil
                trap_G2API_DuplicateGhoul2Instance(precachedKyle, &ent.ghoul2)
            } else {
                trap_G2API_SetSkin(ent.ghoul2, 0, skinHandle, skinHandle)

                GLAName[0] = 0
                strcpy(&GLAName, trap_G2API_GetGLAName(ent.ghoul2, 0))

                if GLAName[0] == 0 || (strstr(GLAName, "players/_humanoid/") == nil && ent.s.number < MAX_CLIENTS && !G_PlayerHasCustomSkeleton(ent)) {
                    //a bad model
                    trap_G2API_CleanGhoul2Models(&(ent.ghoul2))
                    ent.ghoul2 = nil
                    trap_G2API_DuplicateGhoul2Instance(precachedKyle, &ent.ghoul2)
                }

                if ent.s.number >= MAX_CLIENTS {
                    ent.s.modelGhoul2 = 1 //so we know to free it on the client when we're removed.

                    if skin[0] != 0 {
                        //append it after a *
                        strcat(&modelFullPath, va("*%s", skin))
                    }

                    if ent.client!.NPC_class == CLASS_VEHICLE {
                        //vehicles are tricky and send over their vehicle names as the model (the model is then retrieved based on the vehicle name)
                        ent.s.modelindex = G_ModelIndex(String(vehicleName))
                    } else {
                        ent.s.modelindex = G_ModelIndex(String(modelFullPath))
                    }
                }
            }
        } else {
            trap_G2API_DuplicateGhoul2Instance(precachedKyle, &ent.ghoul2)
        }
    } else {
        return
    }

    //Attach the instance to this entity num so we can make use of client-server
    //shared operations if possible.
    trap_G2API_AttachInstanceToEntNum(ent.ghoul2, ent.s.number, true)

    // The model is now loaded.

    GLAName[0] = 0

    if !BGPAFtextLoaded {
        if BG_ParseAnimationFile("models/players/_humanoid/animation.cfg", bgHumanoidAnimations, true) == -1 {
            Com_Printf("Failed to load humanoid animation file\n")
            return
        }
    }

    if ent.s.number >= MAX_CLIENTS || G_PlayerHasCustomSkeleton(ent) {
        ent.localAnimIndex = -1

        GLAName[0] = 0
        strcpy(&GLAName, trap_G2API_GetGLAName(ent.ghoul2, 0))

        if GLAName[0] != 0 && strstr(GLAName, "players/_humanoid/") == nil {
            //it doesn't use humanoid anims.
            if let slash = Q_strrchr(String(GLAName), Int32(ascii: "/")) {
                strcpy(&GLAName, "/animation.cfg", at: slash)

                ent.localAnimIndex = BG_ParseAnimationFile(String(GLAName), nil, false)
            }
        } else {
            //humanoid index.
            if strstr(GLAName, "players/rockettrooper/") != nil {
                ent.localAnimIndex = 1
            } else {
                ent.localAnimIndex = 0
            }
        }

        if ent.localAnimIndex == -1 {
            Com_Error(ERR_DROP, "NPC had an invalid GLA\n")
        }
    } else {
        GLAName[0] = 0
        strcpy(&GLAName, trap_G2API_GetGLAName(ent.ghoul2, 0))

        if strstr(GLAName, "players/rockettrooper/") != nil {
            //assert(!"Should not have gotten in here with rockettrooper skel");
            ent.localAnimIndex = 1
        } else {
            ent.localAnimIndex = 0
        }
    }

    if ent.s.NPC_class == CLASS_VEHICLE && ent.m_pVehicle != nil {
        //do special vehicle stuff
        var strTemp = CharBuf(128)
        var i: Int32

        // Setup the default first bolt
        i = trap_G2API_AddBolt(ent.ghoul2, 0, "model_root")

        // Setup the droid unit.
        ent.m_pVehicle!.m_iDroidUnitTag = trap_G2API_AddBolt(ent.ghoul2, 0, "*droidunit")

        // Setup the Exhausts.
        i = 0
        while i < MAX_VEHICLE_EXHAUSTS {
            Com_sprintf(&strTemp, 128, "*exhaust%i", i + 1)
            ent.m_pVehicle!.m_iExhaustTag[i] = trap_G2API_AddBolt(ent.ghoul2, 0, String(strTemp))
            i += 1
        }

        // Setup the Muzzles.
        i = 0
        while i < MAX_VEHICLE_MUZZLES {
            Com_sprintf(&strTemp, 128, "*muzzle%i", i + 1)
            ent.m_pVehicle!.m_iMuzzleTag[i] = trap_G2API_AddBolt(ent.ghoul2, 0, String(strTemp))
            if ent.m_pVehicle!.m_iMuzzleTag[i] == -1 {
                //ergh, try *flash?
                Com_sprintf(&strTemp, 128, "*flash%i", i + 1)
                ent.m_pVehicle!.m_iMuzzleTag[i] = trap_G2API_AddBolt(ent.ghoul2, 0, String(strTemp))
            }
            i += 1
        }

        // Setup the Turrets.
        i = 0
        while i < MAX_VEHICLE_TURRET_MUZZLES {
            if ent.m_pVehicle!.m_pVehicleInfo!.turret[i].gunnerViewTag != nil {
                ent.m_pVehicle!.m_iGunnerViewTag[i] = trap_G2API_AddBolt(ent.ghoul2, 0, ent.m_pVehicle!.m_pVehicleInfo!.turret[i].gunnerViewTag!)
            } else {
                ent.m_pVehicle!.m_iGunnerViewTag[i] = -1
            }
            i += 1
        }
    }

    if ent.client!.ps.weapon == WP_SABER || ent.s.number < MAX_CLIENTS {
        //a player or NPC saber user
        trap_G2API_AddBolt(ent.ghoul2, 0, "*r_hand")
        trap_G2API_AddBolt(ent.ghoul2, 0, "*l_hand")

        //rhand must always be first bolt. lhand always second. Whichever you want the
        //jetpack bolted to must always be third.
        trap_G2API_AddBolt(ent.ghoul2, 0, "*chestg")

        //claw bolts
        trap_G2API_AddBolt(ent.ghoul2, 0, "*r_hand_cap_r_arm")
        trap_G2API_AddBolt(ent.ghoul2, 0, "*l_hand_cap_l_arm")

        trap_G2API_SetBoneAnim(ent.ghoul2, 0, "model_root", 0, 12, BONE_ANIM_OVERRIDE_LOOP, 1.0, level.time, -1, -1)
        trap_G2API_SetBoneAngles(ent.ghoul2, 0, "upper_lumbar", tempVec, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, level.time)
        trap_G2API_SetBoneAngles(ent.ghoul2, 0, "cranium", tempVec, BONE_ANGLES_POSTMULT, POSITIVE_Z, NEGATIVE_Y, POSITIVE_X, nil, 0, level.time)

        if g2SaberInstance == nil {
            trap_G2API_InitGhoul2Model(&g2SaberInstance, "models/weapons2/saber/saber_w.glm", 0, 0, -20, 0, 0)

            if g2SaberInstance != nil {
                // indicate we will be bolted to model 0 (ie the player) on bolt 0 (always the right hand) when we get copied
                trap_G2API_SetBoltInfo(g2SaberInstance, 0, 0)
                // now set up the gun bolt on it
                trap_G2API_AddBolt(g2SaberInstance, 0, "*blade1")
            }
        }

        if G_SaberModelSetup(ent) {
            if g2SaberInstance != nil {
                trap_G2API_CopySpecificGhoul2Model(g2SaberInstance, 0, ent.ghoul2, 1)
            }
        }
    }

    if ent.s.number >= MAX_CLIENTS {
        //some extra NPC stuff
        if trap_G2API_AddBolt(ent.ghoul2, 0, "lower_lumbar") == -1 {
            //check now to see if we have this bone for setting anims and such
            ent.noLumbar = true
        }
    }
}

/// Source: oracle/codemp/game/g_client.c:1888
func ClientUserinfoChanged(_ clientNum: Int32) {
    var entIndex: Int32 = 0
    let teamTask: Int32
    let teamLeader: Int32
    var team: Int32
    let health: Int32
    var s: String
    var model = CharBuf(64)
    //char	headModel[MAX_QPATH];
    var forcePowers = CharBuf(64)
    var oldname = CharBuf(1024)
    var client: Client?
    var c1 = CharBuf(1024)
    var c2 = CharBuf(1024)
    //	char	redTeam[MAX_INFO_STRING];
    //	char	blueTeam[MAX_INFO_STRING];
    var userinfo = CharBuf(1024)
    var className = CharBuf(64)
    var saberName = CharBuf(64)
    var saber2Name = CharBuf(64)
    var value: String
    var maxHealth: Int32
    var modelChanged: Bool = false

    entIndex = clientNum
    client = g_entities[entIndex].client

    strcpy(&userinfo, trap_GetUserinfo(clientNum, Int32((userinfo).count)))

    // check for malformed or illegal info strings
    if !Info_Validate(String(userinfo)) {
        strcpy(&userinfo, "\\name\\badinfo")
    }

    // check for local client
    s = Info_ValueForKey(String(userinfo), "ip")
    if strcmp(s, "localhost") == 0 {
        client!.pers.localClient = true
    }

    // check the item prediction
    s = Info_ValueForKey(String(userinfo), "cg_predictItems")
    if atoi(s) == 0 {
        client!.pers.predictItemPickup = false
    } else {
        client!.pers.predictItemPickup = true
    }

    // set name
    Q_strncpyz(&oldname, client!.pers.netname, Int32((oldname).count))
    s = Info_ValueForKey(String(userinfo), "name")
    ClientCleanName(s, &client!.pers.netnameBuffer, 36)

    if client!.sess.sessionTeam == TEAM_SPECTATOR {
        if client!.sess.spectatorState == SPECTATOR_SCOREBOARD {
            Q_strncpyz(&client!.pers.netnameBuffer, "scoreboard", 36)
        }
    }

    if client!.pers.connected == CON_CONNECTED {
        if strcmp(oldname, client!.pers.netname) != 0 {
            if client!.pers.netnameTime > level.time {
                trap_SendServerCommand(clientNum, va("print \"%s\n\"", G_GetStringEdString("MP_SVGAME", "NONAMECHANGE")))

                Info_SetValueForKey(&userinfo, "name", String(oldname))
                trap_SetUserinfo(clientNum, String(userinfo))
                strcpy(&client!.pers.netnameBuffer, oldname)
            } else {
                // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: trap_SendServerCommand( -1, va("print \"%s" S_COLOR_WHITE " %s %s\n\"", oldname, G_GetStringEdString("MP_SVGAME", "PLRENAME"), client->pers.netname) )
                portMissing("ClientUserinfoChanged", source: "oracle/codemp/game/g_client.c:1888")
                client!.pers.netnameTime = level.time + 5000
            }
        }
    }

    // set model
    Q_strncpyz(&model, Info_ValueForKey(String(userinfo), "model"), Int32((model).count))

    if d_perPlayerGhoul2.integer != 0 {
        if Q_stricmp(String(model), client!.modelname) != 0 {
            strcpy(&client!.modelnameBuffer, model)
            modelChanged = true
        }
    }

    //Get the skin RGB based on his userinfo
    value = Info_ValueForKey(String(userinfo), "char_color_red")
    client!.ps.customRGBA[0] = atoi(value)

    value = Info_ValueForKey(String(userinfo), "char_color_green")
    client!.ps.customRGBA[1] = atoi(value)

    value = Info_ValueForKey(String(userinfo), "char_color_blue")
    client!.ps.customRGBA[2] = atoi(value)

    if (client!.ps.customRGBA[0] + client!.ps.customRGBA[1] + client!.ps.customRGBA[2]) < 100 {
        //hmm, too dark!
        client!.ps.customRGBA[2] = 255
        client!.ps.customRGBA[1] = client!.ps.customRGBA[2]
        client!.ps.customRGBA[0] = client!.ps.customRGBA[1]
    }

    client!.ps.customRGBA[3] = 255

    Q_strncpyz(&forcePowers, Info_ValueForKey(String(userinfo), "forcepowers"), Int32((forcePowers).count))

    // bots set their team a few frames later
    if g_gametype.integer >= GT_TEAM && (g_entities[clientNum].r.svFlags & SVF_BOT) != 0 {
        s = Info_ValueForKey(String(userinfo), "team")
        if Q_stricmp(s, "red") == 0 || Q_stricmp(s, "r") == 0 {
            team = TEAM_RED
        } else if Q_stricmp(s, "blue") == 0 || Q_stricmp(s, "b") == 0 {
            team = TEAM_BLUE
        } else {
            // pick the team with the least number of players
            team = PickTeam(clientNum)
        }
    } else {
        team = client!.sess.sessionTeam
    }

    //Set the siege class
    if g_gametype.integer == GT_SIEGE {
        strcpy(&className, client!.sess.siegeClass)

        //This function will see if the given class is legal for the given team.
        //If not className will be filled in with the first legal class for this team.
        /*		if (!BG_SiegeCheckClassLegality(team, className) &&
        Q_stricmp(client->sess.siegeClass, "none"))
        { //if it isn't legal pop up the class menu
        trap_SendServerCommand(ent-g_entities, "scl");
        }
        */
        //Now that the team is legal for sure, we'll go ahead and get an index for it.
        client!.siegeClass = BG_SiegeFindClassIndexByName(String(className))
        if client!.siegeClass == -1 {
            //ok, get the first valid class for the team you're on then, I guess.
            BG_SiegeCheckClassLegality(team, &className)
            strcpy(&client!.sess.siegeClassBuffer, className)
            client!.siegeClass = BG_SiegeFindClassIndexByName(String(className))
        } else {
            //otherwise, make sure the class we are using is legal.
            G_ValidateSiegeClassForTeam(g_entities[entIndex], team)
            strcpy(&className, client!.sess.siegeClass)
        }

        //Set the sabers if the class dictates
        if client!.siegeClass != -1 {
            let scl: SiegeClass? = bgSiegeClasses[client!.siegeClass]

            if !scl!.saber1.isEmpty {
                G_SetSaber(g_entities[entIndex], 0, &scl!.saber1Buffer, true)
            } else {
                //default I guess
                // Port-note: Raven passes `"Kyle"` to `G_SetSaber`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: G_SetSaber(ent, 0, "Kyle", qtrue)
                portMissing("ClientUserinfoChanged", source: "oracle/codemp/game/g_client.c:1888")
            }
            if !scl!.saber2.isEmpty {
                G_SetSaber(g_entities[entIndex], 1, &scl!.saber2Buffer, true)
            } else {
                //no second saber then
                // Port-note: Raven passes `"none"` to `G_SetSaber`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: G_SetSaber(ent, 1, "none", qtrue)
                portMissing("ClientUserinfoChanged", source: "oracle/codemp/game/g_client.c:1888")
            }

            //make sure the saber models are updated
            G_SaberModelSetup(g_entities[entIndex])

            if !scl!.forcedModel.isEmpty {
                //be sure to override the model we actually use
                strcpy(&model, scl!.forcedModel)
                if d_perPlayerGhoul2.integer != 0 {
                    if Q_stricmp(String(model), client!.modelname) != 0 {
                        strcpy(&client!.modelnameBuffer, model)
                        modelChanged = true
                    }
                }
            }

            //force them to use their class model on the server, if the class dictates
            if G_PlayerHasCustomSkeleton(g_entities[entIndex]) {
                if Q_stricmp(String(model), client!.modelname) != 0 || g_entities[entIndex].localAnimIndex == 0 {
                    strcpy(&client!.modelnameBuffer, model)
                    modelChanged = true
                }
            }
        }
    } else {
        strcpy(&className, "none")
    }

    //Set the saber name
    strcpy(&saberName, client!.sess.saberType)
    strcpy(&saber2Name, client!.sess.saber2Type)

    // set max health
    if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 {
        let scl: SiegeClass? = bgSiegeClasses[client!.siegeClass]
        maxHealth = 100

        if scl!.maxhealth != 0 {
            maxHealth = scl!.maxhealth
        }

        health = maxHealth
    } else {
        maxHealth = 100
        health = 100 //atoi( Info_ValueForKey( userinfo, "handicap" ) );
    }
    client!.pers.maxHealth = health
    if client!.pers.maxHealth < 1 || client!.pers.maxHealth > maxHealth {
        client!.pers.maxHealth = 100
    }
    client!.ps.stats[STAT_MAX_HEALTH] = client!.pers.maxHealth

    /*	NOTE: all client side now

    // team
    switch( team ) {
    case TEAM_RED:
    ForceClientSkin(client, model, "red");
    //		ForceClientSkin(client, headModel, "red");
    break;
    case TEAM_BLUE:
    ForceClientSkin(client, model, "blue");
    //		ForceClientSkin(client, headModel, "blue");
    break;
    }
    // don't ever use a default skin in teamplay, it would just waste memory
    // however bots will always join a team but they spawn in as spectator
    if ( g_gametype.integer >= GT_TEAM && team == TEAM_SPECTATOR) {
    ForceClientSkin(client, model, "red");
    //		ForceClientSkin(client, headModel, "red");
    }
    */

    if g_gametype.integer >= GT_TEAM {
        client!.pers.teamInfo = true
    } else {
        s = Info_ValueForKey(String(userinfo), "teamoverlay")
        if s.isEmpty || atoi(s) != 0 {
            client!.pers.teamInfo = true
        } else {
            client!.pers.teamInfo = false
        }
    }
    /*
    s = Info_ValueForKey( userinfo, "cg_pmove_fixed" );
    if ( !*s || atoi( s ) == 0 ) {
    client->pers.pmoveFixed = qfalse;
    }
    else {
    client->pers.pmoveFixed = qtrue;
    }
    */

    // team task (0 = none, 1 = offence, 2 = defence)
    teamTask = atoi(Info_ValueForKey(String(userinfo), "teamtask"))
    // team Leader (1 = leader, 0 is normal player)
    teamLeader = (client!.sess.teamLeader ? 1 : 0)

    // colors
    strcpy(&c1, Info_ValueForKey(String(userinfo), "color1"))
    strcpy(&c2, Info_ValueForKey(String(userinfo), "color2"))

    //	strcpy(redTeam, Info_ValueForKey( userinfo, "g_redteam" ));
    //	strcpy(blueTeam, Info_ValueForKey( userinfo, "g_blueteam" ));

    // send over a subset of the userinfo keys so other clients can
    // print scoreboards, display models, and play custom sounds
    if (g_entities[entIndex].r.svFlags & SVF_BOT) != 0 {
        s = va("n\\%s\\t\\%i\\model\\%s\\c1\\%s\\c2\\%s\\hc\\%i\\w\\%i\\l\\%i\\skill\\%s\\tt\\%d\\tl\\%d\\siegeclass\\%s\\st\\%s\\st2\\%s\\dt\\%i\\sdt\\%i", client!.pers.netname, team, model, c1, c2, client!.pers.maxHealth, client!.sess.wins, client!.sess.losses, Info_ValueForKey(String(userinfo), "skill"), teamTask, teamLeader, className, saberName, saber2Name, client!.sess.duelTeam, client!.sess.siegeDesiredTeam)
    } else {
        if g_gametype.integer == GT_SIEGE {
            //more crap to send
            s = va("n\\%s\\t\\%i\\model\\%s\\c1\\%s\\c2\\%s\\hc\\%i\\w\\%i\\l\\%i\\tt\\%d\\tl\\%d\\siegeclass\\%s\\st\\%s\\st2\\%s\\dt\\%i\\sdt\\%i", client!.pers.netname, client!.sess.sessionTeam, model, c1, c2, client!.pers.maxHealth, client!.sess.wins, client!.sess.losses, teamTask, teamLeader, className, saberName, saber2Name, client!.sess.duelTeam, client!.sess.siegeDesiredTeam)
        } else {
            s = va("n\\%s\\t\\%i\\model\\%s\\c1\\%s\\c2\\%s\\hc\\%i\\w\\%i\\l\\%i\\tt\\%d\\tl\\%d\\st\\%s\\st2\\%s\\dt\\%i", client!.pers.netname, client!.sess.sessionTeam, model, c1, c2, client!.pers.maxHealth, client!.sess.wins, client!.sess.losses, teamTask, teamLeader, saberName, saber2Name, client!.sess.duelTeam)
        }
    }

    trap_SetConfigstring(CS_PLAYERS + clientNum, s)

    if modelChanged {
        //update the server g2 instance if appropriate
        let modelname: String = Info_ValueForKey(String(userinfo), "model")
        // Port-note: Raven passes `modelname` to `SetupGameGhoul2Model`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
        // Raven wrote: SetupGameGhoul2Model(ent, modelname, NULL)
        portMissing("ClientUserinfoChanged", source: "oracle/codemp/game/g_client.c:1888")

        if g_entities[entIndex].ghoul2 != nil && g_entities[entIndex].client != nil {
            g_entities[entIndex].client!.renderInfo.lastG2 = nil //update the renderinfo bolts next update.
        }

        client!.legsAnimExecute = -1
        client!.torsoAnimExecute = client!.legsAnimExecute
        client!.legsLastFlip = false
        client!.torsoLastFlip = client!.legsLastFlip
    }

    if g_logClientInfo.integer != 0 {
        G_LogPrintf("ClientUserinfoChanged: %i %s\n", clientNum, s)
    }
}

/**
```
===========
ClientConnect

Called when a player begins connecting to the server.
Called again for every map change or tournement restart.

The session information will be valid after exit.

Return NULL if the client should be allowed, otherwise return
a string with the reason for denial.

Otherwise, the client will be sent the current gamestate
and will eventually get to ClientBegin.

firstTime will be qtrue the very first time a client connects
to the server machine, but qfalse on map changes and tournement
restarts.
============
```
*/
/// Source: oracle/codemp/game/g_client.c:2258
func ClientConnect(_ clientNum: Int32, _ firstTime: Bool, _ isBot: Bool) -> String? {
    var value: String
    //	char		*areabits;
    var client: Client?
    var userinfo = CharBuf(1024)
    var IPstring = CharBuf(32)
    var ent: Entity?
    var te: Entity?

    ent = g_entities[clientNum]

    strcpy(&userinfo, trap_GetUserinfo(clientNum, Int32((userinfo).count)))

    // check to see if they are on the banned IP list
    value = Info_ValueForKey(String(userinfo), "ip")
    Q_strncpyz(&IPstring, value, Int32((IPstring).count))


    // Port-note: Raven passes `value` to `G_FilterPacket`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
    // Raven wrote: if ( G_FilterPacket( value ) ) { return "Banned."; }
    portMissing("ClientConnect", source: "oracle/codemp/game/g_client.c:2258")

    if !((ent!.r.svFlags & SVF_BOT) != 0) && !isBot && g_needpass.integer != 0 {
        // check for a password
        value = Info_ValueForKey(String(userinfo), "password")
        if !g_password.string.isEmpty && Q_stricmp(g_password.string, "none") != 0 && strcmp(g_password.string, value) != 0 {
            // Port-note: A static local `sTemp` the function returns, storage that outlives the call.
            // Raven wrote: static char sTemp[1024];
            portMissing("ClientConnect", source: "oracle/codemp/game/g_client.c:2258")
            // Port-note: A read of `sTemp`, a local the draft left as a hole.
            // Raven wrote: Q_strncpyz(sTemp, G_GetStringEdString("MP_SVGAME","INVALID_ESCAPE_TO_MAIN"), sizeof (sTemp) )
            portMissing("ClientConnect", source: "oracle/codemp/game/g_client.c:2258")
            // Port-note: A read of `sTemp`, a local the draft left as a hole.
            // Raven wrote: return sTemp
            portMissing("ClientConnect", source: "oracle/codemp/game/g_client.c:2258")
        }
    }

    // they can connect
    ent!.client = level.clientsSlots[clientNum]
    client = ent!.client

    //assign the pointer for bg entity access
    ent!.playerState = ent!.client!.ps

    //	areabits = client->areabits;

    client!.clear()

    client!.pers.connected = CON_CONNECTING

    // read or initialize the session data
    if firstTime || level.newSession {
        G_InitSessionData(client!, String(userinfo), isBot)
    }
    G_ReadSessionData(client!)

    client!.sess.IPstring = ""
    Q_strncpyz(&client!.sess.IPstringBuffer, String(IPstring), 32)

    if g_gametype.integer == GT_SIEGE && (firstTime || level.newSession) {
        //if this is the first time then auto-assign a desired siege team and show briefing for that team
        client!.sess.siegeDesiredTeam = 0 //PickTeam(ent->s.number);
        /*
        trap_SendServerCommand(ent->s.number, va("sb %i", client->sess.siegeDesiredTeam));
        */
        //don't just show it - they'll see it if they switch to a team on purpose.
    }


    if g_gametype.integer == GT_SIEGE && client!.sess.sessionTeam != TEAM_SPECTATOR {
        if firstTime || level.newSession {
            //start as spec
            client!.sess.siegeDesiredTeam = client!.sess.sessionTeam
            client!.sess.sessionTeam = TEAM_SPECTATOR
        }
    } else if g_gametype.integer == GT_POWERDUEL && client!.sess.sessionTeam != TEAM_SPECTATOR {
        client!.sess.sessionTeam = TEAM_SPECTATOR
    }

    if isBot {
        ent!.r.svFlags |= SVF_BOT
        ent!.inuse = true
        if !G_BotConnect(clientNum, !firstTime) {
            return "BotConnectfailed"
        }
    }

    // get and distribute relevent paramters
    G_LogPrintf("ClientConnect: %i\n", clientNum)
    ClientUserinfoChanged(clientNum)
    G_LogPrintf("%s connected with IP: %s\n", client!.pers.netname, client!.sess.IPstring)

    // don't do the "xxx connected" messages if they were caried over from previous level
    if firstTime {
        // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
        // Raven wrote: trap_SendServerCommand( -1, va("print \"%s" S_COLOR_WHITE " %s\n\"", client->pers.netname, G_GetStringEdString("MP_SVGAME", "PLCONNECT")) )
        portMissing("ClientConnect", source: "oracle/codemp/game/g_client.c:2258")
    }

    if g_gametype.integer >= GT_TEAM && client!.sess.sessionTeam != TEAM_SPECTATOR {
        BroadcastTeamChange(client!, -1)
    }

    // count current clients and rank for scoreboard
    CalculateRanks()

    te = G_TempEntity(vec3_origin, EV_CLIENTJOIN)
    te!.r.svFlags |= SVF_BROADCAST
    te!.s.eventParm = clientNum

    // for statistics
    //	client->areabits = areabits;
    //	if ( !client->areabits )
    //		client->areabits = G_Alloc( (trap_AAS_PointReachabilityAreaIndex( NULL ) + 7) / 8 );

    return nil
}

/// Source: oracle/codemp/game/g_client.c:2393
func ClientBegin(_ clientNum: Int32, _ allowTeamReset: Bool) {
    var entIndex: Int32 = 0
    var client: Client?
    var tent: Entity?
    let flags: Int32
    var i: Int32
    var userinfo = CharBuf(1024)
    let modelname: String

    entIndex = clientNum

    if (g_entities[entIndex].r.svFlags & SVF_BOT) != 0 && g_gametype.integer >= GT_TEAM {
        if allowTeamReset {
            var team: String = "Red"
            let preSess: Int32

            //SetTeam(ent, "");
            g_entities[entIndex].client!.sess.sessionTeam = PickTeam(-1)
            strcpy(&userinfo, trap_GetUserinfo(clientNum, MAX_INFO_STRING))

            if g_entities[entIndex].client!.sess.sessionTeam == TEAM_SPECTATOR {
                g_entities[entIndex].client!.sess.sessionTeam = TEAM_RED
            }

            if g_entities[entIndex].client!.sess.sessionTeam == TEAM_RED {
                team = "Red"
            } else {
                team = "Blue"
            }

            Info_SetValueForKey(&userinfo, "team", team)

            trap_SetUserinfo(clientNum, String(userinfo))

            g_entities[entIndex].client!.ps.persistant[PERS_TEAM] = g_entities[entIndex].client!.sess.sessionTeam

            preSess = g_entities[entIndex].client!.sess.sessionTeam
            G_ReadSessionData(g_entities[entIndex].client!)
            g_entities[entIndex].client!.sess.sessionTeam = preSess
            G_WriteClientSessionData(g_entities[entIndex].client!)
            ClientUserinfoChanged(clientNum)
            ClientBegin(clientNum, false)
            return
        }
    }

    client = level.clientsSlots[clientNum]

    if g_entities[entIndex].r.linked {
        trap_UnlinkEntity(g_entities[entIndex])
    }
    G_InitGentity(g_entities[entIndex])
    g_entities[entIndex].touch = nil
    g_entities[entIndex].pain = nil
    g_entities[entIndex].client = client

    //assign the pointer for bg entity access
    g_entities[entIndex].playerState = g_entities[entIndex].client!.ps

    client!.pers.connected = CON_CONNECTED
    client!.pers.enterTime = level.time
    client!.pers.teamState.state = TEAM_BEGIN

    // save eflags around this, because changing teams will
    // cause this to happen with a valid entity, and we
    // want to make sure the teleport bit is set right
    // so the viewpoint doesn't interpolate through the
    // world to the new position
    flags = client!.ps.eFlags

    i = 0

    while i < NUM_FORCE_POWERS {
        if (g_entities[entIndex].client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
            WP_ForcePowerStop(g_entities[entIndex], i)
        }
        i += 1
    }

    i = TRACK_CHANNEL_1

    while i < NUM_TRACK_CHANNELS {
        if g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50] != 0 && g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50] < MAX_GENTITIES && g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50] > 0 {
            G_MuteSound(g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50], CHAN_VOICE)
        }
        i += 1
    }
    i = 0

    client!.ps.clear()
    client!.ps.eFlags = flags

    client!.ps.hasDetPackPlanted = false

    //first-time force power initialization
    WP_InitForcePowers(g_entities[entIndex])

    //init saber ent
    WP_SaberInitBladeData(g_entities[entIndex])

    // First time model setup for that player.
    strcpy(&userinfo, trap_GetUserinfo(clientNum, Int32((userinfo).count)))
    modelname = Info_ValueForKey(String(userinfo), "model")
    // Port-note: Raven passes `modelname` to `SetupGameGhoul2Model`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
    // Raven wrote: SetupGameGhoul2Model(ent, modelname, NULL)
    portMissing("ClientBegin", source: "oracle/codemp/game/g_client.c:2393")

    if g_entities[entIndex].ghoul2 != nil && g_entities[entIndex].client != nil {
        g_entities[entIndex].client!.renderInfo.lastG2 = nil //update the renderinfo bolts next update.
    }

    if g_gametype.integer == GT_POWERDUEL && client!.sess.sessionTeam != TEAM_SPECTATOR && client!.sess.duelTeam == DUELTEAM_FREE {
        SetTeam(g_entities[entIndex], "s")
    } else {
        if g_gametype.integer == GT_SIEGE && (!gSiegeRoundBegun || gSiegeRoundEnded) {
            SetTeamQuick(g_entities[entIndex], TEAM_SPECTATOR, false)
        }

        if (g_entities[entIndex].r.svFlags & SVF_BOT) != 0 && g_gametype.integer != GT_SIEGE {
            let saberVal: String = Info_ValueForKey(String(userinfo), "saber1")
            let saber2Val: String = Info_ValueForKey(String(userinfo), "saber2")

            if saberVal.isEmpty {
                //blah, set em up with a random saber
                // The SDK also declares `rand`, so the call names the bg module.
                let r: Int32 = JKAMP_BG.rand() % 50
                var sab1 = CharBuf(1024)
                var sab2 = CharBuf(1024)

                if r <= 17 {
                    strcpy(&sab1, "Katarn")
                    strcpy(&sab2, "none")
                } else if r <= 34 {
                    strcpy(&sab1, "Katarn")
                    strcpy(&sab2, "Katarn")
                } else {
                    strcpy(&sab1, "dual_1")
                    strcpy(&sab2, "none")
                }
                G_SetSaber(g_entities[entIndex], 0, &sab1, false)
                G_SetSaber(g_entities[entIndex], 0, &sab2, false)
                Info_SetValueForKey(&userinfo, "saber1", String(sab1))
                Info_SetValueForKey(&userinfo, "saber2", String(sab2))
                trap_SetUserinfo(clientNum, String(userinfo))
            } else {
                // Port-note: Raven passes `saberVal` to `G_SetSaber`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: G_SetSaber(ent, 0, saberVal, qfalse)
                portMissing("ClientBegin", source: "oracle/codemp/game/g_client.c:2393")
            }

            if !saberVal.isEmpty && (saber2Val.isEmpty) {
                // Port-note: Raven passes `"none"` to `G_SetSaber`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: G_SetSaber(ent, 0, "none", qfalse)
                portMissing("ClientBegin", source: "oracle/codemp/game/g_client.c:2393")
                Info_SetValueForKey(&userinfo, "saber2", "none")
                trap_SetUserinfo(clientNum, String(userinfo))
            } else {
                // Port-note: Raven passes `saber2Val` to `G_SetSaber`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: G_SetSaber(ent, 0, saber2Val, qfalse)
                portMissing("ClientBegin", source: "oracle/codemp/game/g_client.c:2393")
            }
        }

        // locate ent at a spawn point
        ClientSpawn(g_entities[entIndex])
    }

    if client!.sess.sessionTeam != TEAM_SPECTATOR {
        // send event
        tent = G_TempEntity(g_entities[entIndex].client!.ps.origin, EV_PLAYER_TELEPORT_IN)
        tent!.s.clientNum = g_entities[entIndex].s.clientNum

        if g_gametype.integer != GT_DUEL || g_gametype.integer == GT_POWERDUEL {
            // Port-note: Raven passes `"MP_SVGAME"` to `G_GetStringEdString`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
            // Raven wrote: trap_SendServerCommand( -1, va("print \"%s" S_COLOR_WHITE " %s\n\"", client->pers.netname, G_GetStringEdString("MP_SVGAME", "PLENTER")) )
            portMissing("ClientBegin", source: "oracle/codemp/game/g_client.c:2393")
        }
    }
    G_LogPrintf("ClientBegin: %i\n", clientNum)

    // count current clients and rank for scoreboard
    CalculateRanks()

    G_ClearClientLog(clientNum)
}

/// Source: oracle/codemp/game/g_client.c:2595
private func AllForceDisabled(_ force: Int32) -> Bool {
    var i: Int32

    if force != 0 {
        i = 0
        while i < NUM_FORCE_POWERS {
            if !((force & (1 << i)) != 0) {
                return false
            }
            i += 1
        }

        return true
    }

    return false
}

//Convenient interface to set all my limb breakage stuff up -rww
/// Source: oracle/codemp/game/g_client.c:2616
func G_BreakArm(_ ent: Entity, _ arm: Int32) {
    var anim: Int32 = -1


    if ent.s.NPC_class == CLASS_VEHICLE || ent.localAnimIndex > 1 {
        //no broken limbs for vehicles and non-humanoids
        return
    }

    if arm == 0 {
        //repair him
        ent.client!.ps.brokenLimbs = 0
        return
    }

    if ent.client!.ps.fd.saberAnimLevel == SS_STAFF {
        //I'm too lazy to deal with this as well for now.
        return
    }

    if arm == BROKENLIMB_LARM {
        if !ent.client!.saber[1].model.isEmpty && ent.client!.ps.weapon == WP_SABER && ent.client!.ps.saberHolstered == 0 && ent.client!.saber[1].soundOff != 0 {
            //the left arm shuts off its saber upon being broken
            G_Sound(ent, CHAN_AUTO, ent.client!.saber[1].soundOff)
        }
    }

    ent.client!.ps.brokenLimbs = 0 //make sure it's cleared out
    ent.client!.ps.brokenLimbs |= (1 << arm) //this arm is now marked as broken

    //Do a pain anim based on the side. Since getting your arm broken does tend to hurt.
    if arm == BROKENLIMB_LARM {
        anim = BOTH_PAIN2
    } else if arm == BROKENLIMB_RARM {
        anim = BOTH_PAIN3
    }

    if anim == -1 {
        return
    }

    G_SetAnim(ent, ent.client!.pers.cmd, SETANIM_BOTH, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD, 0)

    //This could be combined into a single event. But I guess limbs don't break often enough to
    //worry about it.
    G_EntitySound(ent, CHAN_VOICE, G_SoundIndex("*pain25.wav"))
    //FIXME: A nice bone snapping sound instead if possible
    G_Sound(ent, CHAN_AUTO, G_SoundIndex(va("sound/player/bodyfall_human%i.wav", Q_irand(1, 3))))
}

/// Source: oracle/codemp/game/g_client.c:2681
func G_UpdateClientAnims(_ `self`: Entity, _ animSpeedScale: Float) {
    let f: Int32
    let torsoAnim: Int32
    let legsAnim: Int32
    var firstFrame: Int32
    var lastFrame: Int32
    var aFlags: Int32
    var animSpeed: Float
    var lAnimSpeedScale: Float
    var setTorso: Bool = false

    // Raven assigns his own `animSpeedScale` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var animSpeedScale = animSpeedScale
    tryTorso: do {
        torsoAnim = (`self`.client!.ps.torsoAnim)
        legsAnim = (`self`.client!.ps.legsAnim)

        if `self`.client!.ps.saberLockFrame != 0 {
            trap_G2API_SetBoneAnim(`self`.ghoul2, 0, "model_root", `self`.client!.ps.saberLockFrame, `self`.client!.ps.saberLockFrame + 1, BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND, animSpeedScale, level.time, -1, 150)
            trap_G2API_SetBoneAnim(`self`.ghoul2, 0, "lower_lumbar", `self`.client!.ps.saberLockFrame, `self`.client!.ps.saberLockFrame + 1, BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND, animSpeedScale, level.time, -1, 150)
            trap_G2API_SetBoneAnim(`self`.ghoul2, 0, "Motion", `self`.client!.ps.saberLockFrame, `self`.client!.ps.saberLockFrame + 1, BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND, animSpeedScale, level.time, -1, 150)
            return
        }

        if `self`.localAnimIndex > 1 && bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].firstFrame == 0 && bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].numFrames == 0 {
            //We'll allow this for non-humanoids.
            break tryTorso
        }

        if `self`.client!.legsAnimExecute != legsAnim || `self`.client!.legsLastFlip != `self`.client!.ps.legsFlip {
            animSpeed = 50.0 / bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].frameLerp
            // Port-note: No rule for a COMPOUND_ASSIGNMENT_OPERATOR expression.
            // Raven wrote: lAnimSpeedScale = (animSpeed *= animSpeedScale)
            portMissing("G_UpdateClientAnims", source: "oracle/codemp/game/g_client.c:2681")

            if bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].loopFrames != -1 {
                aFlags = BONE_ANIM_OVERRIDE_LOOP
            } else {
                aFlags = BONE_ANIM_OVERRIDE_FREEZE
            }

            if animSpeed < 0 {
                lastFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].firstFrame
                firstFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].firstFrame + bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].numFrames
            } else {
                firstFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].firstFrame
                lastFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].firstFrame + bgAllAnims[`self`.localAnimIndex].animsSlots[legsAnim].numFrames
            }

            aFlags |= BONE_ANIM_BLEND //since client defaults to blend. Not sure if this will make much difference if any on server position, but it's here just for the sake of matching them.

            trap_G2API_SetBoneAnim(`self`.ghoul2, 0, "model_root", firstFrame, lastFrame, aFlags, lAnimSpeedScale, level.time, -1, 150)
            `self`.client!.legsAnimExecute = legsAnim
            `self`.client!.legsLastFlip = `self`.client!.ps.legsFlip
        }

    }
    if `self`.localAnimIndex > 1 && bgAllAnims[`self`.localAnimIndex].animsSlots[torsoAnim].firstFrame == 0 && bgAllAnims[`self`.localAnimIndex].animsSlots[torsoAnim].numFrames == 0 {
        //If this fails as well just return.
        return
    } else if `self`.s.number >= MAX_CLIENTS && `self`.s.NPC_class == CLASS_VEHICLE {
        //we only want to set the root bone for vehicles
        return
    }

    if (`self`.client!.torsoAnimExecute != torsoAnim || `self`.client!.torsoLastFlip != `self`.client!.ps.torsoFlip) && !`self`.noLumbar {
        aFlags = 0
        animSpeed = 0

        f = torsoAnim

        BG_SaberStartTransAnim(`self`.s.number, `self`.client!.ps.fd.saberAnimLevel, `self`.client!.ps.weapon, f, &animSpeedScale, `self`.client!.ps.brokenLimbs)

        animSpeed = 50.0 / bgAllAnims[`self`.localAnimIndex].animsSlots[f].frameLerp
        // Port-note: No rule for a COMPOUND_ASSIGNMENT_OPERATOR expression.
        // Raven wrote: lAnimSpeedScale = (animSpeed *= animSpeedScale)
        portMissing("G_UpdateClientAnims", source: "oracle/codemp/game/g_client.c:2681")

        if bgAllAnims[`self`.localAnimIndex].animsSlots[f].loopFrames != -1 {
            aFlags = BONE_ANIM_OVERRIDE_LOOP
        } else {
            aFlags = BONE_ANIM_OVERRIDE_FREEZE
        }

        aFlags |= BONE_ANIM_BLEND //since client defaults to blend. Not sure if this will make much difference if any on client position, but it's here just for the sake of matching them.

        if animSpeed < 0 {
            lastFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[f].firstFrame
            firstFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[f].firstFrame + bgAllAnims[`self`.localAnimIndex].animsSlots[f].numFrames
        } else {
            firstFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[f].firstFrame
            lastFrame = bgAllAnims[`self`.localAnimIndex].animsSlots[f].firstFrame + bgAllAnims[`self`.localAnimIndex].animsSlots[f].numFrames
        }

        trap_G2API_SetBoneAnim(`self`.ghoul2, 0, "lower_lumbar", firstFrame, lastFrame, aFlags, lAnimSpeedScale, level.time, -1, 150)

        `self`.client!.torsoAnimExecute = torsoAnim
        `self`.client!.torsoLastFlip = `self`.client!.ps.torsoFlip

        setTorso = true
    }

    if setTorso && `self`.localAnimIndex <= 1 {
        //only set the motion bone for humanoids.
        // Port-note: The draft of this statement did not compile, and the compiler wrote "variable 'aFlags' used before being initialized".
        // Raven wrote: trap_G2API_SetBoneAnim(self->ghoul2, 0, "Motion", firstFrame, lastFrame, aFlags, lAnimSpeedScale, level.time, -1, 150)
        portMissing("G_UpdateClientAnims", source: "oracle/codemp/game/g_client.c:2681")
    }






    //Only put the arm in a broken pose if the anim is such that we
    //want to allow it.


    //armFirstFrame = armAnim->firstFrame;


    //Now set the left arm to "support" the right one


    //Warning: Don't remove bones that you've added as bolts unless you want to invalidate your bolt index
    //(well, in theory, I haven't actually run into the problem)

    //want to remove the support bone too then


    //Set the flags and stuff to 0, so that the remove will succeed

    //Now remove it
}

/// Source: oracle/codemp/game/g_client.c:2938
func ClientSpawn(_ ent: Entity) {
    var index: Int32 = 0
    var spawn_origin = vec3_t()
    var spawn_angles = vec3_t()
    var client: Client?
    var i: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = ClientPersistant.scratch { saved -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = ClientSession.scratch { savedSess -> Bool in
            var persistant: [Int32] = [Int32](repeating: 0, count: 16)
            var spawnPoint: Entity?
            var flags: Int32 = 0
            var gameFlags: Int32 = 0
            var savedPing: Int32 = 0
            var accuracy_hits: Int32 = 0
            var accuracy_shots: Int32 = 0
            var eventSequence: Int32 = 0
            var userinfo = CharBuf(1024)
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives true where Raven returns from the function.
            let earlyOut3 = Forcedata.scratch { savedForce -> Bool in
                var saveSaberNum: Int32 = ENTITYNUM_NONE
                var wDisable: Int32 = 0
                var savedSiegeIndex: Int32 = 0
                var maxHealth: Int32 = 0
                // Port-note: A local `saberInfo_t[2] saberSaved` the table has no type for.
                // Raven wrote: saberInfo_t saberSaved[MAX_SABERS];
                portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")
                var l: Int32 = 0
                var g2WeaponPtrs = [OpaquePointer?](repeating: nil, count: Int(MAX_SABERS))
                var value: String
                var saber: String? = nil
                var changedSaber: Bool = false
                var inSiegeWithClass: Bool = false

                index = ent.s.number
                client = ent.client

                //first we want the userinfo so we can see if we should update this client's saber -rww
                strcpy(&userinfo, trap_GetUserinfo(index, Int32((userinfo).count)))
                while l < MAX_SABERS {
                    switch l {
                    case 0:
                        saber = ent.client!.sess.saberType

                    case 1:
                        saber = ent.client!.sess.saber2Type

                    default:
                        saber = nil
                    }

                    value = Info_ValueForKey(String(userinfo), va("saber%i", l + 1))
                    if saber != nil && (Q_stricmp(value, saber!) != 0 || saber!.isEmpty || ent.client!.saber[0].model.isEmpty) {
                        //doesn't match up (or our session saber is BS), we want to try setting it
                        // Port-note: Raven passes `value` to `G_SetSaber`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                        // Raven wrote: if (G_SetSaber(ent, l, value, qfalse)) { changedSaber = qtrue; } else if (!saber[0] || !ent->client->saber[0].model[0]) { //Well, we still want to say they changed then (it means this is siege and we have some overrides) changedSaber = qtrue; }
                        portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")
                    }
                    l += 1
                }

                if changedSaber {
                    //make sure our new info is sent out to all the other clients, and give us a valid stance
                    ClientUserinfoChanged(ent.s.number)

                    //make sure the saber models are updated
                    G_SaberModelSetup(ent)

                    l = 0
                    while l < MAX_SABERS {
                        //go through and make sure both sabers match the userinfo
                        switch l {
                        case 0:
                            saber = ent.client!.sess.saberType

                        case 1:
                            saber = ent.client!.sess.saber2Type

                        default:
                            saber = nil
                        }

                        value = Info_ValueForKey(String(userinfo), va("saber%i", l + 1))

                        if Q_stricmp(value, saber!) != 0 {
                            //they don't match up, force the user info
                            Info_SetValueForKey(&userinfo, va("saber%i", l + 1), saber!)
                            trap_SetUserinfo(ent.s.number, String(userinfo))
                        }
                        l += 1
                    }

                    if !ent.client!.saber[0].model.isEmpty && !ent.client!.saber[1].model.isEmpty {
                        //dual
                        ent.client!.ps.fd.saberDrawAnimLevel = SS_DUAL
                        ent.client!.ps.fd.saberAnimLevel = ent.client!.ps.fd.saberDrawAnimLevel
                        ent.client!.ps.fd.saberAnimLevelBase = ent.client!.ps.fd.saberAnimLevel
                    } else if (ent.client!.saber[0].saberFlags & SFL_TWO_HANDED) != 0 {
                        //staff
                        ent.client!.ps.fd.saberDrawAnimLevel = SS_STAFF
                        ent.client!.ps.fd.saberAnimLevel = ent.client!.ps.fd.saberDrawAnimLevel
                    } else {
                        if ent.client!.sess.saberLevel < SS_FAST {
                            ent.client!.sess.saberLevel = SS_FAST
                        } else if ent.client!.sess.saberLevel > SS_STRONG {
                            ent.client!.sess.saberLevel = SS_STRONG
                        }
                        ent.client!.ps.fd.saberDrawAnimLevel = ent.client!.sess.saberLevel
                        ent.client!.ps.fd.saberAnimLevel = ent.client!.ps.fd.saberDrawAnimLevel
                        ent.client!.ps.fd.saberAnimLevelBase = ent.client!.ps.fd.saberAnimLevel

                        if g_gametype.integer != GT_SIEGE && ent.client!.ps.fd.saberAnimLevel > ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] {
                            ent.client!.sess.saberLevel = ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE]
                            ent.client!.ps.fd.saberDrawAnimLevel = ent.client!.sess.saberLevel
                            ent.client!.ps.fd.saberAnimLevel = ent.client!.ps.fd.saberDrawAnimLevel
                            ent.client!.ps.fd.saberAnimLevelBase = ent.client!.ps.fd.saberAnimLevel
                        }
                    }
                    if g_gametype.integer != GT_SIEGE {
                        //let's just make sure the styles we chose are cool
                        if !WP_SaberStyleValidForSaber(ent.client!.saber[0], ent.client!.saber[1], ent.client!.ps.saberHolstered, ent.client!.ps.fd.saberAnimLevel) {
                            WP_UseFirstValidSaberStyle(ent.client!.saber[0], ent.client!.saber[1], ent.client!.ps.saberHolstered, &ent.client!.ps.fd.saberAnimLevel)
                            ent.client!.saberCycleQueue = ent.client!.ps.fd.saberAnimLevel
                            ent.client!.ps.fd.saberAnimLevelBase = ent.client!.saberCycleQueue
                        }
                    }
                }
                l = 0

                if client!.ps.fd.forceDoInit != 0 {
                    //force a reread of force powers
                    WP_InitForcePowers(ent)
                    client!.ps.fd.forceDoInit = 0
                }

                if ent.client!.ps.fd.saberAnimLevel != SS_STAFF && ent.client!.ps.fd.saberAnimLevel != SS_DUAL && ent.client!.ps.fd.saberAnimLevel == ent.client!.ps.fd.saberDrawAnimLevel && ent.client!.ps.fd.saberAnimLevel == ent.client!.sess.saberLevel {
                    if ent.client!.sess.saberLevel < SS_FAST {
                        ent.client!.sess.saberLevel = SS_FAST
                    } else if ent.client!.sess.saberLevel > SS_STRONG {
                        ent.client!.sess.saberLevel = SS_STRONG
                    }
                    ent.client!.ps.fd.saberDrawAnimLevel = ent.client!.sess.saberLevel
                    ent.client!.ps.fd.saberAnimLevel = ent.client!.ps.fd.saberDrawAnimLevel

                    if g_gametype.integer != GT_SIEGE && ent.client!.ps.fd.saberAnimLevel > ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] {
                        ent.client!.sess.saberLevel = ent.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE]
                        ent.client!.ps.fd.saberDrawAnimLevel = ent.client!.sess.saberLevel
                        ent.client!.ps.fd.saberAnimLevel = ent.client!.ps.fd.saberDrawAnimLevel
                    }
                }

                // find a spawn point
                // do it before setting health back up, so farthest
                // ranging doesn't count this client
                if client!.sess.sessionTeam == TEAM_SPECTATOR {
                    spawnPoint = SelectSpectatorSpawnPoint(&spawn_origin, &spawn_angles)
                } else if g_gametype.integer == GT_CTF || g_gametype.integer == GT_CTY {
                    // all base oriented team games use the CTF spawn points
                    spawnPoint = SelectCTFSpawnPoint(client!.sess.sessionTeam, client!.pers.teamState.state, &spawn_origin, &spawn_angles)
                } else if g_gametype.integer == GT_SIEGE {
                    spawnPoint = SelectSiegeSpawnPoint(client!.siegeClass, client!.sess.sessionTeam, client!.pers.teamState.state, &spawn_origin, &spawn_angles)
                } else {
                    repeat {
                        if g_gametype.integer == GT_POWERDUEL {
                            spawnPoint = SelectDuelSpawnPoint(client!.sess.duelTeam, client!.ps.origin, &spawn_origin, &spawn_angles)
                        } else if g_gametype.integer == GT_DUEL {
                            // duel
                            spawnPoint = SelectDuelSpawnPoint(DUELTEAM_SINGLE, client!.ps.origin, &spawn_origin, &spawn_angles)
                        } else {
                            // the first spawn should be at a good looking spot
                            if !client!.pers.initialSpawn && client!.pers.localClient {
                                client!.pers.initialSpawn = true
                                spawnPoint = SelectInitialSpawnPoint(&spawn_origin, &spawn_angles, client!.sess.sessionTeam)
                            } else {
                                // don't spawn near existing origin if possible
                                spawnPoint = SelectSpawnPoint(client!.ps.origin, &spawn_origin, &spawn_angles, client!.sess.sessionTeam)
                            }
                        }

                        // Tim needs to prevent bots from spawning at the initial point
                        // on q3dm0...
                        if (spawnPoint!.flags & FL_NO_BOTS) != 0 && (ent.r.svFlags & SVF_BOT) != 0 {
                            continue // try again
                        }
                        // just to be symetric, we have a nohumans option...
                        if (spawnPoint!.flags & FL_NO_HUMANS) != 0 && !((ent.r.svFlags & SVF_BOT) != 0) {
                            continue // try again
                        }

                        break
                    } while 1 != 0
                }
                client!.pers.teamState.state = TEAM_ACTIVE

                // toggle the teleport bit so the client knows to not lerp
                // and never clear the voted flag
                flags = ent.client!.ps.eFlags & (EF_TELEPORT_BIT)
                flags ^= EF_TELEPORT_BIT
                gameFlags = Int32(bitPattern: ent.client!.mGameFlags & (UInt32(bitPattern: PSG_VOTED) | UInt32(bitPattern: PSG_TEAMVOTED)))

                // clear everything but the persistant data

                saved.copy(from: client!.pers)
                savedSess.copy(from: client!.sess)
                savedPing = client!.ps.ping
                //	savedAreaBits = client->areabits;
                accuracy_hits = client!.accuracy_hits
                accuracy_shots = client!.accuracy_shots
                i = 0
                while i < MAX_PERSISTANT {
                    persistant[i] = client!.ps.persistant[i]
                    i += 1
                }
                eventSequence = client!.ps.eventSequence

                savedForce.copy(from: client!.ps.fd)

                saveSaberNum = client!.ps.saberEntityNum

                savedSiegeIndex = client!.siegeClass

                l = 0
                while l < MAX_SABERS {
                    // Port-note: A read of `saberSaved`, a local the draft left as a hole.
                    // Raven wrote: saberSaved[l] = client->saber[l]
                    portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")
                    g2WeaponPtrs[l] = client!.weaponGhoul2[l]
                    l += 1
                }

                i = 0
                while i < HL_MAX {
                    ent.locationDamage[i] = 0
                    i += 1
                }

                client!.clear()
                client!.bodyGrabIndex = ENTITYNUM_NONE

                //Get the skin RGB based on his userinfo
                value = Info_ValueForKey(String(userinfo), "char_color_red")
                client!.ps.customRGBA[0] = atoi(value)

                value = Info_ValueForKey(String(userinfo), "char_color_green")
                client!.ps.customRGBA[1] = atoi(value)

                value = Info_ValueForKey(String(userinfo), "char_color_blue")
                client!.ps.customRGBA[2] = atoi(value)

                if (client!.ps.customRGBA[0] + client!.ps.customRGBA[1] + client!.ps.customRGBA[2]) < 100 {
                    //hmm, too dark!
                    client!.ps.customRGBA[2] = 255
                    client!.ps.customRGBA[1] = client!.ps.customRGBA[2]
                    client!.ps.customRGBA[0] = client!.ps.customRGBA[1]
                }

                client!.ps.customRGBA[3] = 255

                client!.siegeClass = savedSiegeIndex

                l = 0
                while l < MAX_SABERS {
                    // Port-note: A read of `saberSaved`, a local the draft left as a hole.
                    // Raven wrote: client->saber[l] = saberSaved[l]
                    portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")
                    client!.weaponGhoul2[l] = g2WeaponPtrs[l]
                    l += 1
                }

                //or the saber ent num
                client!.ps.saberEntityNum = saveSaberNum
                client!.saberStoredIndex = saveSaberNum

                client!.ps.fd.copy(from: savedForce)

                client!.ps.duelIndex = ENTITYNUM_NONE

                //spawn with 100
                client!.ps.jetpackFuel = 100
                client!.ps.cloakFuel = 100

                client!.pers.copy(from: saved)
                client!.sess.copy(from: savedSess)
                client!.ps.ping = savedPing
                //	client->areabits = savedAreaBits;
                client!.accuracy_hits = accuracy_hits
                client!.accuracy_shots = accuracy_shots
                client!.lastkilled_client = -1

                i = 0
                while i < MAX_PERSISTANT {
                    client!.ps.persistant[i] = persistant[i]
                    i += 1
                }
                client!.ps.eventSequence = eventSequence
                // increment the spawncount so the client will detect the respawn
                client!.ps.persistant[PERS_SPAWN_COUNT] += 1
                client!.ps.persistant[PERS_TEAM] = client!.sess.sessionTeam

                client!.airOutTime = level.time + 12000

                // set max health
                if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 {
                    let scl: SiegeClass? = bgSiegeClasses[client!.siegeClass]
                    maxHealth = 100

                    if scl!.maxhealth != 0 {
                        maxHealth = scl!.maxhealth
                    }
                } else {
                    maxHealth = 100
                }
                client!.pers.maxHealth = maxHealth //atoi( Info_ValueForKey( userinfo, "handicap" ) );
                if client!.pers.maxHealth < 1 || client!.pers.maxHealth > maxHealth {
                    client!.pers.maxHealth = 100
                }
                // clear entity values
                client!.ps.stats[STAT_MAX_HEALTH] = client!.pers.maxHealth
                client!.ps.eFlags = flags
                client!.mGameFlags = UInt32(bitPattern: gameFlags)

                ent.s.groundEntityNum = ENTITYNUM_NONE
                ent.client = level.clientsSlots[index]
                ent.playerState = ent.client!.ps
                ent.takedamage = true
                ent.inuse = true
                ent.classname = "player"
                ent.r.contents = CONTENTS_BODY
                ent.clipmask = MASK_PLAYERSOLID
                ent.die = Die.player_die
                ent.waterlevel = 0
                ent.watertype = 0
                ent.flags = 0

                ent.r.mins = playerMins
                ent.r.maxs = playerMaxs
                client!.ps.crouchheight = CROUCH_MAXS_2
                client!.ps.standheight = DEFAULT_MAXS_2

                client!.ps.clientNum = index
                //give default weapons
                client!.ps.stats[STAT_WEAPONS] = (1 << WP_NONE)

                if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
                    wDisable = g_duelWeaponDisable.integer
                } else {
                    wDisable = g_weaponDisable.integer
                }



                if g_gametype.integer != GT_HOLOCRON && g_gametype.integer != GT_JEDIMASTER && !HasSetSaberOnly() && !AllForceDisabled(g_forcePowerDisable.integer) && g_trueJedi.integer != 0 {
                    if g_gametype.integer >= GT_TEAM && (client!.sess.sessionTeam == TEAM_BLUE || client!.sess.sessionTeam == TEAM_RED) {
                        //In Team games, force one side to be merc and other to be jedi
                        if level.numPlayingClients > 0 {
                            //already someone in the game
                            var i: Int32 = 0
                            var forceTeam: Int32 = TEAM_SPECTATOR
                            i = 0
                            while i < level.maxclients {
                                if level.clientsSlots[i].pers.connected == CON_DISCONNECTED {
                                    i += 1
                                    continue
                                }
                                if level.clientsSlots[i].sess.sessionTeam == TEAM_BLUE || level.clientsSlots[i].sess.sessionTeam == TEAM_RED {
                                    //in-game
                                    if WP_HasForcePowers(level.clientsSlots[i].ps) {
                                        //this side is using force
                                        forceTeam = level.clientsSlots[i].sess.sessionTeam
                                    } else {
                                        //other team is using force
                                        if level.clientsSlots[i].sess.sessionTeam == TEAM_BLUE {
                                            forceTeam = TEAM_RED
                                        } else {
                                            forceTeam = TEAM_BLUE
                                        }
                                    }
                                    break
                                }
                                i += 1
                            }
                            if WP_HasForcePowers(client!.ps) && client!.sess.sessionTeam != forceTeam {
                                //using force but not on right team, switch him over
                                let teamName: String = TeamName(forceTeam)
                                //client->sess.sessionTeam = forceTeam;
                                SetTeam(ent, teamName)
                                return true
                            }
                        }
                    }

                    if WP_HasForcePowers(client!.ps) {
                        client!.ps.trueNonJedi = false
                        client!.ps.trueJedi = true
                        //make sure they only use the saber
                        client!.ps.weapon = WP_SABER
                        client!.ps.stats[STAT_WEAPONS] = (1 << WP_SABER)
                    } else {
                        //no force powers set
                        client!.ps.trueNonJedi = true
                        client!.ps.trueJedi = false
                        if wDisable == 0 || !((wDisable & (1 << WP_BRYAR_PISTOL)) != 0) {
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_BRYAR_PISTOL)
                        }
                        if wDisable == 0 || !((wDisable & (1 << WP_BLASTER)) != 0) {
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_BLASTER)
                        }
                        if wDisable == 0 || !((wDisable & (1 << WP_BOWCASTER)) != 0) {
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_BOWCASTER)
                        }
                        client!.ps.stats[STAT_WEAPONS] &= ~(1 << WP_SABER)
                        client!.ps.stats[STAT_WEAPONS] |= (1 << WP_MELEE)
                        client!.ps.ammo[AMMO_POWERCELL] = ammoData[AMMO_POWERCELL].max
                        client!.ps.weapon = WP_BRYAR_PISTOL
                    }
                } else {
                    //jediVmerc is incompatible with this gametype, turn it off!
                    trap_Cvar_Set("g_jediVmerc", "0")
                    if g_gametype.integer == GT_HOLOCRON {
                        //always get free saber level 1 in holocron
                        client!.ps.stats[STAT_WEAPONS] |= (1 << WP_SABER) //these are precached in g_items, ClearRegisteredItems()
                    } else {
                        if client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] != 0 {
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_SABER) //these are precached in g_items, ClearRegisteredItems()
                        } else {
                            //if you don't have saber attack rank then you don't get a saber
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_MELEE)
                        }
                    }

                    if g_gametype.integer != GT_SIEGE {
                        if wDisable == 0 || !((wDisable & (1 << WP_BRYAR_PISTOL)) != 0) {
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_BRYAR_PISTOL)
                        } else if g_gametype.integer == GT_JEDIMASTER {
                            client!.ps.stats[STAT_WEAPONS] |= (1 << WP_BRYAR_PISTOL)
                        }
                    }

                    if g_gametype.integer == GT_JEDIMASTER {
                        client!.ps.stats[STAT_WEAPONS] &= ~(1 << WP_SABER)
                        client!.ps.stats[STAT_WEAPONS] |= (1 << WP_MELEE)
                    }

                    if (client!.ps.stats[STAT_WEAPONS] & (1 << WP_SABER)) != 0 {
                        client!.ps.weapon = WP_SABER
                    } else if (client!.ps.stats[STAT_WEAPONS] & (1 << WP_BRYAR_PISTOL)) != 0 {
                        client!.ps.weapon = WP_BRYAR_PISTOL
                    } else {
                        client!.ps.weapon = WP_MELEE
                    }
                }

                /*
                client->ps.stats[STAT_HOLDABLE_ITEMS] |= ( 1 << HI_BINOCULARS );
                client->ps.stats[STAT_HOLDABLE_ITEM] = BG_GetItemIndexByTag(HI_BINOCULARS, IT_HOLDABLE);
                */

                if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 && client!.sess.sessionTeam != TEAM_SPECTATOR {
                    //well then, we will use a custom weaponset for our class
                    var m: Int32 = 0

                    client!.ps.stats[STAT_WEAPONS] = bgSiegeClasses[client!.siegeClass].weapons

                    if (client!.ps.stats[STAT_WEAPONS] & (1 << WP_SABER)) != 0 {
                        client!.ps.weapon = WP_SABER
                    } else if (client!.ps.stats[STAT_WEAPONS] & (1 << WP_BRYAR_PISTOL)) != 0 {
                        client!.ps.weapon = WP_BRYAR_PISTOL
                    } else {
                        client!.ps.weapon = WP_MELEE
                    }
                    inSiegeWithClass = true

                    while m < WP_NUM_WEAPONS {
                        if (client!.ps.stats[STAT_WEAPONS] & (1 << m)) != 0 {
                            if client!.ps.weapon != WP_SABER {
                                //try to find the highest ranking weapon we have
                                if m > client!.ps.weapon {
                                    client!.ps.weapon = m
                                }
                            }

                            if m >= WP_BRYAR_PISTOL {
                                //Max his ammo out for all the weapons he has.
                                if g_gametype.integer == GT_SIEGE && m == WP_ROCKET_LAUNCHER {
                                    //don't give full ammo!
                                    //FIXME: extern this and check it when getting ammo from supplier, pickups or ammo stations!
                                    if client!.siegeClass != -1 && (bgSiegeClasses[client!.siegeClass].classflags & (1 << CFL_SINGLE_ROCKET)) != 0 {
                                        client!.ps.ammo[weaponData[m].ammoIndex] = 1
                                    } else {
                                        client!.ps.ammo[weaponData[m].ammoIndex] = 10
                                    }
                                } else {
                                    if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 && (bgSiegeClasses[client!.siegeClass].classflags & (1 << CFL_EXTRA_AMMO)) != 0 {
                                        //double ammo
                                        client!.ps.ammo[weaponData[m].ammoIndex] = ammoData[weaponData[m].ammoIndex].max * 2
                                        client!.ps.eFlags |= EF_DOUBLE_AMMO
                                    } else {
                                        client!.ps.ammo[weaponData[m].ammoIndex] = ammoData[weaponData[m].ammoIndex].max
                                    }
                                }
                            }
                        }
                        m += 1
                    }
                }

                if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 && client!.sess.sessionTeam != TEAM_SPECTATOR {
                    //use class-specified inventory
                    client!.ps.stats[STAT_HOLDABLE_ITEMS] = bgSiegeClasses[client!.siegeClass].invenItems
                    client!.ps.stats[STAT_HOLDABLE_ITEM] = 0
                } else {
                    client!.ps.stats[STAT_HOLDABLE_ITEMS] = 0
                    client!.ps.stats[STAT_HOLDABLE_ITEM] = 0
                }

                if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 && bgSiegeClasses[client!.siegeClass].powerups != 0 && client!.sess.sessionTeam != TEAM_SPECTATOR {
                    //this class has some start powerups
                    i = 0
                    while i < PW_NUM_POWERUPS {
                        if (bgSiegeClasses[client!.siegeClass].powerups & (1 << i)) != 0 {
                            client!.ps.powerups[i] = Q3_INFINITE
                        }
                        i += 1
                    }
                }

                if client!.sess.sessionTeam == TEAM_SPECTATOR {
                    client!.ps.stats[STAT_WEAPONS] = 0
                    client!.ps.stats[STAT_HOLDABLE_ITEMS] = 0
                    client!.ps.stats[STAT_HOLDABLE_ITEM] = 0
                }

                // nmckenzie: DESERT_SIEGE... or well, siege generally.  This was over-writing the max value, which was NOT good for siege.
                if inSiegeWithClass == false {
                    client!.ps.ammo[AMMO_BLASTER] = 100 //ammoData[AMMO_BLASTER].max; //100 seems fair.
                }
                //	client->ps.ammo[AMMO_POWERCELL] = ammoData[AMMO_POWERCELL].max;
                //	client->ps.ammo[AMMO_FORCE] = ammoData[AMMO_FORCE].max;
                //	client->ps.ammo[AMMO_METAL_BOLTS] = ammoData[AMMO_METAL_BOLTS].max;
                //	client->ps.ammo[AMMO_ROCKETS] = ammoData[AMMO_ROCKETS].max;
                /*
                client->ps.stats[STAT_WEAPONS] = ( 1 << WP_BRYAR_PISTOL);
                if ( g_gametype.integer == GT_TEAM ) {
                client->ps.ammo[WP_BRYAR_PISTOL] = 50;
                } else {
                client->ps.ammo[WP_BRYAR_PISTOL] = 100;
                }
                */
                client!.ps.rocketLockIndex = ENTITYNUM_NONE
                client!.ps.rocketLockTime = 0

                //rww - Set here to initialize the circling seeker drone to off.
                //A quick note about this so I don't forget how it works again:
                //ps.genericEnemyIndex is kept in sync between the server and client.
                //When it gets set then an entitystate value of the same name gets
                //set along with an entitystate flag in the shared bg code. Which
                //is why a value needs to be both on the player state and entity state.
                //(it doesn't seem to just carry over the entitystate value automatically
                //because entity state value is derived from player state data or some
                //such)
                client!.ps.genericEnemyIndex = -1

                client!.ps.isJediMaster = false

                if client!.ps.fallingToDeath != 0 {
                    client!.ps.fallingToDeath = 0
                    client!.noCorpse = true
                }

                //Do per-spawn force power initialization
                WP_SpawnInitForcePowers(ent)

                // health will count down towards max_health
                if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 && bgSiegeClasses[client!.siegeClass].starthealth != 0 {
                    //class specifies a start health, so use it
                    client!.ps.stats[STAT_HEALTH] = bgSiegeClasses[client!.siegeClass].starthealth
                    ent.health = client!.ps.stats[STAT_HEALTH]
                } else if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
                    //only start with 100 health in Duel
                    if g_gametype.integer == GT_POWERDUEL && client!.sess.duelTeam == DUELTEAM_LONE {
                        if g_duel_fraglimit.integer != 0 {
                            // Port-note: The draft of this statement did not compile, and the compiler wrote "the compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions".
                            // Raven wrote: ent->health = client->ps.stats[STAT_HEALTH] = client->ps.stats[STAT_MAX_HEALTH] = g_powerDuelStartHealth.integer - ((g_powerDuelStartHealth.integer - g_powerDuelEndHealth.integer) * (float)client->sess.wins / (float)g_duel_fraglimit.integer)
                            portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")
                        } else {
                            client!.ps.stats[STAT_MAX_HEALTH] = 150
                            client!.ps.stats[STAT_HEALTH] = client!.ps.stats[STAT_MAX_HEALTH]
                            ent.health = client!.ps.stats[STAT_HEALTH]
                        }
                    } else {
                        client!.ps.stats[STAT_MAX_HEALTH] = 100
                        client!.ps.stats[STAT_HEALTH] = client!.ps.stats[STAT_MAX_HEALTH]
                        ent.health = client!.ps.stats[STAT_HEALTH]
                    }
                } else if client!.ps.stats[STAT_MAX_HEALTH] <= 100 {
                    client!.ps.stats[STAT_HEALTH] = Int32(Double(client!.ps.stats[STAT_MAX_HEALTH]) * 1.25)
                    ent.health = client!.ps.stats[STAT_HEALTH]
                } else if client!.ps.stats[STAT_MAX_HEALTH] < 125 {
                    client!.ps.stats[STAT_HEALTH] = 125
                    ent.health = client!.ps.stats[STAT_HEALTH]
                } else {
                    client!.ps.stats[STAT_HEALTH] = client!.ps.stats[STAT_MAX_HEALTH]
                    ent.health = client!.ps.stats[STAT_HEALTH]
                }

                // Start with a small amount of armor as well.
                if g_gametype.integer == GT_SIEGE && client!.siegeClass != -1 {
                    //class specifies a start armor amount, so use it
                    client!.ps.stats[STAT_ARMOR] = bgSiegeClasses[client!.siegeClass].startarmor
                } else if g_gametype.integer == GT_DUEL || g_gametype.integer == GT_POWERDUEL {
                    //no armor in duel
                    client!.ps.stats[STAT_ARMOR] = 0
                } else {
                    client!.ps.stats[STAT_ARMOR] = Int32(Double(client!.ps.stats[STAT_MAX_HEALTH]) * 0.25)
                }

                G_SetOrigin(ent, &spawn_origin)
                client!.ps.origin = spawn_origin

                // the respawned flag will be cleared after the attack and jump keys come up
                client!.ps.pm_flags |= PMF_RESPAWNED

                // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to two 'Client?' operands".
                // Raven wrote: trap_GetUsercmd( client - level.clients, &ent->client->pers.cmd )
                portMissing("ClientSpawn", source: "oracle/codemp/game/g_client.c:2938")
                SetClientViewAngle(ent, spawn_angles)

                if ent.client!.sess.sessionTeam == TEAM_SPECTATOR {
                } else {
                    G_KillBox(ent)
                    trap_LinkEntity(ent)

                    // force the base weapon up
                    //client->ps.weapon = WP_BRYAR_PISTOL;
                    //client->ps.weaponstate = FIRST_WEAPON;
                    if client!.ps.weapon <= WP_NONE {
                        client!.ps.weapon = WP_BRYAR_PISTOL
                    }

                    client!.ps.legsTimer = 0
                    client!.ps.torsoTimer = client!.ps.legsTimer

                    if client!.ps.weapon == WP_SABER {
                        G_SetAnim(ent, nil, SETANIM_BOTH, BOTH_STAND1TO2, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_HOLDLESS, 0)
                    } else {
                        G_SetAnim(ent, nil, SETANIM_TORSO, TORSO_RAISEWEAP1, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD | SETANIM_FLAG_HOLDLESS, 0)
                        client!.ps.legsAnim = WeaponReadyAnim[client!.ps.weapon]
                    }
                    client!.ps.weaponstate = WEAPON_RAISING
                    client!.ps.weaponTime = client!.ps.torsoTimer
                }

                // don't allow full run speed for a bit
                client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
                client!.ps.pm_time = 100

                client!.respawnTime = level.time
                client!.inactivityTime = level.time + g_inactivity.integer * 1000
                client!.latched_buttons = 0

                if level.intermissiontime != 0 {
                    MoveClientToIntermission(ent)
                } else {
                    // fire the targets of the spawn point
                    G_UseTargets(spawnPoint!, ent)

                    // select the highest weapon number available, after any
                    // spawn given items have fired
                    /*
                    client->ps.weapon = 1;
                    for ( i = WP_NUM_WEAPONS - 1 ; i > 0 ; i-- ) {
                    if ( client->ps.stats[STAT_WEAPONS] & ( 1 << i ) ) {
                    client->ps.weapon = i;
                    break;
                    }
                    }
                    */
                }

                //set teams for NPCs to recognize
                if g_gametype.integer == GT_SIEGE {
                    //Imperial (team1) team is allied with "enemy" NPCs in this mode
                    if client!.sess.sessionTeam == SIEGETEAM_TEAM1 {
                        ent.s.teamowner = NPCTEAM_ENEMY
                        client!.playerTeam = ent.s.teamowner
                        client!.enemyTeam = NPCTEAM_PLAYER
                    } else {
                        ent.s.teamowner = NPCTEAM_PLAYER
                        client!.playerTeam = ent.s.teamowner
                        client!.enemyTeam = NPCTEAM_ENEMY
                    }
                } else {
                    ent.s.teamowner = NPCTEAM_PLAYER
                    client!.playerTeam = ent.s.teamowner
                    client!.enemyTeam = NPCTEAM_ENEMY
                }

                /*
                //scaling for the power duel opponent
                if (g_gametype.integer == GT_POWERDUEL &&
                client->sess.duelTeam == DUELTEAM_LONE)
                {
                client->ps.iModelScale = 125;
                VectorSet(ent->modelScale, 1.25f, 1.25f, 1.25f);
                }
                */
                //Disabled. At least for now. Not sure if I'll want to do it or not eventually.

                // run a client frame to drop exactly to the floor,
                // initialize animations and other things
                client!.ps.commandTime = level.time - 100
                ent.client!.pers.cmd.serverTime = level.time
                ClientThink(ent.s.number, nil)

                // positively link the client, even if the command times are weird
                if ent.client!.sess.sessionTeam != TEAM_SPECTATOR {
                    BG_PlayerStateToEntityState(client!.ps, ent.s, true)
                    ent.r.currentOrigin = ent.client!.ps.origin
                    trap_LinkEntity(ent)
                }

                if g_spawnInvulnerability.integer != 0 {
                    ent.client!.ps.eFlags |= EF_INVULNERABLE
                    ent.client!.invulnerableTimer = level.time + g_spawnInvulnerability.integer
                }

                // run the presend to set anything else
                ClientEndFrame(ent)

                // clear entity state values
                BG_PlayerStateToEntityState(client!.ps, ent.s, true)

                //rww - make sure client has a valid icarus instance
                trap_ICARUS_FreeEnt(ent)
                trap_ICARUS_InitEnt(ent)
                return false
            }
            if earlyOut3 {
                return true
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===========
ClientDisconnect

Called when a player drops from the server.
Will not be called between levels.

This should NOT be called directly by any game logic,
call trap_DropClient(), which will call this and do
server system housekeeping.
============
```
*/
/// Source: oracle/codemp/game/g_client.c:3816
func ClientDisconnect(_ clientNum: Int32) {
    var entIndex: Int32 = 0
    var tent: Entity?
    var i: Int32

    // cleanup if we are kicking a bot that
    // hasn't spawned yet
    G_RemoveQueuedBotBegin(clientNum)

    entIndex = clientNum
    if g_entities[entIndex].client == nil {
        return
    }

    i = 0

    while i < NUM_FORCE_POWERS {
        if (g_entities[entIndex].client!.ps.fd.forcePowersActive & (1 << i)) != 0 {
            WP_ForcePowerStop(g_entities[entIndex], i)
        }
        i += 1
    }

    i = TRACK_CHANNEL_1

    while i < NUM_TRACK_CHANNELS {
        if g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50] != 0 && g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50] < MAX_GENTITIES && g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50] > 0 {
            G_MuteSound(g_entities[entIndex].client!.ps.fd.killSoundEntIndex[i - 50], CHAN_VOICE)
        }
        i += 1
    }
    i = 0

    if g_entities[entIndex].client!.ps.m_iVehicleNum != 0 {
        //tell it I'm getting off
        let veh: Entity? = g_entities[g_entities[entIndex].client!.ps.m_iVehicleNum]

        if veh!.inuse && veh!.client != nil && veh!.m_pVehicle != nil {
            let pCon: Int32 = g_entities[entIndex].client!.pers.connected

            g_entities[entIndex].client!.pers.connected = 0
            veh!.m_pVehicle!.m_pVehicleInfo!.runEject(veh!.m_pVehicle, BgEntity(g_entities[entIndex]), true)
            g_entities[entIndex].client!.pers.connected = pCon
        }
    }

    // stop any following clients
    i = 0
    while i < level.maxclients {
        if level.clientsSlots[i].sess.sessionTeam == TEAM_SPECTATOR && level.clientsSlots[i].sess.spectatorState == SPECTATOR_FOLLOW && level.clientsSlots[i].sess.spectatorClient == clientNum {
            StopFollowing(g_entities[i])
        }
        i += 1
    }

    // send effect if they were completely connected
    if g_entities[entIndex].client!.pers.connected == CON_CONNECTED && g_entities[entIndex].client!.sess.sessionTeam != TEAM_SPECTATOR {
        tent = G_TempEntity(g_entities[entIndex].client!.ps.origin, EV_PLAYER_TELEPORT_OUT)
        tent!.s.clientNum = g_entities[entIndex].s.clientNum

        // They don't get to take powerups with them!
        // Especially important for stuff like CTF flags
        TossClientItems(g_entities[entIndex])
    }

    G_LogPrintf("ClientDisconnect: %i\n", clientNum)
    G_LogPrintf("%s disconnected with IP: %s\n", g_entities[entIndex].client!.pers.netname, g_entities[entIndex].client!.sess.IPstring)

    // if we are playing in tourney mode, give a win to the other player and clear his frags for this round
    if (g_gametype.integer == GT_DUEL) && level.intermissiontime == 0 && level.warmupTime == 0 {
        if level.sortedClients[1] == clientNum {
            level.clientsSlots[level.sortedClients[0]].ps.persistant[PERS_SCORE] = 0
            level.clientsSlots[level.sortedClients[0]].sess.wins += 1
            ClientUserinfoChanged(level.sortedClients[0])
        } else if level.sortedClients[0] == clientNum {
            level.clientsSlots[level.sortedClients[1]].ps.persistant[PERS_SCORE] = 0
            level.clientsSlots[level.sortedClients[1]].sess.wins += 1
            ClientUserinfoChanged(level.sortedClients[1])
        }
    }

    if g_entities[entIndex].ghoul2 != nil && trap_G2_HaveWeGhoul2Models(g_entities[entIndex].ghoul2) {
        trap_G2API_CleanGhoul2Models(&g_entities[entIndex].ghoul2)
    }
    i = 0
    while i < MAX_SABERS {
        if g_entities[entIndex].client!.weaponGhoul2[i] != nil && trap_G2_HaveWeGhoul2Models(g_entities[entIndex].client!.weaponGhoul2[i]) {
            trap_G2API_CleanGhoul2Models(&g_entities[entIndex].client!.weaponGhoul2[i])
        }
        i += 1
    }

    trap_UnlinkEntity(g_entities[entIndex])
    g_entities[entIndex].s.modelindex = 0
    g_entities[entIndex].inuse = false
    g_entities[entIndex].classname = "disconnected"
    g_entities[entIndex].client!.pers.connected = CON_DISCONNECTED
    g_entities[entIndex].client!.ps.persistant[PERS_TEAM] = TEAM_FREE
    g_entities[entIndex].client!.sess.sessionTeam = TEAM_FREE
    g_entities[entIndex].r.contents = 0

    trap_SetConfigstring(CS_PLAYERS + clientNum, "")

    CalculateRanks()

    if (g_entities[entIndex].r.svFlags & SVF_BOT) != 0 {
        BotAIShutdownClient(clientNum, false)
    }

    G_ClearClientLog(clientNum)
}
