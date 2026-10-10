import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_spawn.c:54
// TODO: Port global fields
// Raven wrote: BG_field_t fields[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/g_spawn.c:435
/// Raven's data table, a hand property of `GameWorld`.
var spawns: [SpawnRow] { world.spawns }

/// Source: oracle/codemp/game/g_spawn.c:886
let NOVALUE = "novalue"

/// Source: oracle/codemp/game/g_spawn.c:1070
/// Raven's data table, a hand property of `GameWorld`.
var defaultStyles: [[String]] {
    get { world.defaultStyles }
    set { world.defaultStyles = newValue }
}

/// Source: oracle/codemp/game/g_spawn.c:1234
var precachedKyle: OpaquePointer? {
    get { world.variables.precachedKyle }
    set { world.variables.precachedKyle = newValue }
}

/// Source: oracle/codemp/game/g_spawn.c:1258
var g_cullDistance: Float {
    get { world.variables.g_cullDistance }
    set { world.variables.g_cullDistance = newValue }
}

/// Source: oracle/codemp/game/g_spawn.c:6
func G_SpawnString(_ key: String, _ defaultString: String?, _ out: inout String) -> Bool {
    var i: Int32

    if !level.spawning {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: *out = (char *)defaultString
        portMissing("G_SpawnString", source: "oracle/codemp/game/g_spawn.c:6")
        //		G_Error( "G_SpawnString() called while not spawning" );
    }

    i = 0
    while i < level.numSpawnVars {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: if ( !Q_stricmp( key, level.spawnVars[i][0] ) ) { *out = level.spawnVars[i][1]; return qtrue; }
        portMissing("G_SpawnString", source: "oracle/codemp/game/g_spawn.c:6")
        i += 1
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: *out = (char *)defaultString
    portMissing("G_SpawnString", source: "oracle/codemp/game/g_spawn.c:6")
    return false
}

/// Source: oracle/codemp/game/g_spawn.c:25
func G_SpawnFloat(_ key: String, _ defaultString: String, _ out: inout Float) -> Bool {
    var s: String = ""
    let present: Bool

    present = G_SpawnString(key, defaultString, &s)
    out = atof(s)
    return present
}

/// Source: oracle/codemp/game/g_spawn.c:34
func G_SpawnInt(_ key: String, _ defaultString: String, _ out: inout Int32) -> Bool {
    var s: String = ""
    let present: Bool

    present = G_SpawnString(key, defaultString, &s)
    out = atoi(s)
    return present
}

/// Source: oracle/codemp/game/g_spawn.c:43
func G_SpawnVector(_ key: String, _ defaultString: String, _ out: inout Float) -> Bool {
    var s: String = ""
    let present: Bool

    present = G_SpawnString(key, defaultString, &s)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Any'".
    // Raven wrote: sscanf( s, "%f %f %f", &out[0], &out[1], &out[2] )
    portMissing("G_SpawnVector", source: "oracle/codemp/game/g_spawn.c:43")
    return present
}

/// Source: oracle/codemp/game/g_spawn.c:368
func SP_item_botroam(_ ent: Entity) {
}

/// Source: oracle/codemp/game/g_spawn.c:372
func SP_gametype_item(_ ent: Entity) {
    var item: Gitem? = nil
    var value: String = ""
    var team: Int32 = -1

    G_SpawnString("teamfilter", "", &value)

    G_SetOrigin(ent, &ent.s.origin)

    // If a team filter is set then override any team settings for the spawns
    if !level.mTeamFilter.isEmpty {
        if Q_stricmp(level.mTeamFilter, "red") == 0 {
            team = TEAM_RED
        } else if Q_stricmp(level.mTeamFilter, "blue") == 0 {
            team = TEAM_BLUE
        }
    }

    if ent.targetname != nil && !ent.targetname!.isEmpty {
        if team != -1 {
            if strstr(ent.targetname!, "flag") != nil {
                if team == TEAM_RED {
                    item = BG_FindItem("team_CTF_redflag")
                } else {
                    //blue
                    item = BG_FindItem("team_CTF_blueflag")
                }
            }
        } else if strstr(ent.targetname!, "red_flag") != nil {
            item = BG_FindItem("team_CTF_redflag")
        } else if strstr(ent.targetname!, "blue_flag") != nil {
            item = BG_FindItem("team_CTF_blueflag")
        } else {
            item = nil
        }

        if item != nil {
            ent.targetname = nil
            ent.classname = item!.classname
            G_SpawnItem(ent, item!)
        }
    }
}

/**
```
===============
G_CallSpawn

Finds the spawn function for the entity and calls it,
returning qfalse if not found
===============
```
*/
/// Source: oracle/codemp/game/g_spawn.c:683
func G_CallSpawn(_ ent: Entity) -> Bool {
    var sIndex: Int32 = 0
    var itemIndex: Int32 = 0

    if ent.classname == nil {
        G_Printf("G_CallSpawn: NULL classname\n")
        return false
    }

    // check item spawn functions
    itemIndex = 1
    while bg_itemlist[itemIndex].classname != nil {
        if strcmp(bg_itemlist[itemIndex].classname!, ent.classname!) == 0 {
            G_SpawnItem(ent, bg_itemlist[itemIndex])
            return true
        }
        itemIndex += 1
    }

    // check normal spawn functions
    // Port-note: Raven walks `spawns` by pointer, and the hand table is a Swift array of rows with no view. A walk over it has no form yet.
    // Raven wrote: for ( s=spawns ; s->name ; s++ ) { if ( !strcmp(s->name, ent->classname) ) { // found it if (ent->healingsound && ent->healingsound[0]) { //yeah...this can be used for anything, so.. precache it if it's there G_SoundIndex(ent->healingsound); } s->spawn(ent); return qtrue; } }
    portMissing("G_CallSpawn", source: "oracle/codemp/game/g_spawn.c:683")
    G_Printf("%s doesn't have a spawn function\n", ent.classname!)
    return false
}

/**
```
=============
G_NewString

Builds a copy of the string, translating \n to real linefeeds
so message texts can be multi-line
=============
```
*/
/// Source: oracle/codemp/game/g_spawn.c:724
func G_NewString(_ string: String) -> String {
    let newb: UnsafeMutableRawPointer
    // Port-note: A pointer local `char * new_p` with no view.
    // Raven wrote: new_p;
    portMissing("G_NewString", source: "oracle/codemp/game/g_spawn.c:724")
    var i: Int32
    let l: Int32

    l = strlen(string) + 1

    newb = G_Alloc(l)

    // Port-note: A store into `new_p`, a local the draft left as a hole.
    // Raven wrote: new_p = newb
    portMissing("G_NewString", source: "oracle/codemp/game/g_spawn.c:724")

    // turn \n into a real linefeed
    i = 0
    while i < l {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Character' and 'Int32'".
        // Raven wrote: if (string[i] == '\\' && i < l-1) { i++; if (string[i] == 'n') { *new_p++ = '\n'; } else { *new_p++ = '\\'; } } else { *new_p++ = string[i]; }
        portMissing("G_NewString", source: "oracle/codemp/game/g_spawn.c:724")
        i += 1
    }

    return String(cString: newb.assumingMemoryBound(to: CChar.self))
}

/// Source: oracle/codemp/game/g_spawn.c:766
public func G_SpawnGEntityFromSpawnVars(_ inSubBSP: Bool) {
    var i: Int32 = 0
    var ent: Entity?
    // Port-note: A pointer local `char * s` with no view.
    // Raven wrote: char *s;
    portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")
    var value: String = ""
    // Port-note: A pointer local `char * gametypeName` with no view.
    // Raven wrote: gametypeName;
    portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")
    // Port-note: A local `char *[10] gametypeNames` the table has no type for.
    // Raven wrote: static char *gametypeNames[] = {"ffa", "holocron", "jedimaster", "duel", "powerduel", "single", "team", "siege", "ctf", "cty"};
    portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")

    // get the next free entity
    ent = G_Spawn()

    i = 0
    while i < level.numSpawnVars {
        // Port-note: Raven passes `fields` to `BG_ParseField`, whose `l_fields` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
        // Raven wrote: BG_ParseField( fields, level.spawnVars[i][0], level.spawnVars[i][1], (byte *)ent )
        portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")
        i += 1
    }

    // check for "notsingle" flag
    if g_gametype.integer == GT_SINGLE_PLAYER {
        G_SpawnInt("notsingle", "0", &i)
        if i != 0 {
            G_FreeEntity(ent!)
            return
        }
    }
    // check for "notteam" flag (GT_FFA, GT_DUEL, GT_SINGLE_PLAYER)
    if g_gametype.integer >= GT_TEAM {
        G_SpawnInt("notteam", "0", &i)
        if i != 0 {
            G_FreeEntity(ent!)
            return
        }
    } else {
        G_SpawnInt("notfree", "0", &i)
        if i != 0 {
            G_FreeEntity(ent!)
            return
        }
    }

    G_SpawnInt("notta", "0", &i)
    if i != 0 {
        G_FreeEntity(ent!)
        return
    }

    if G_SpawnString("gametype", nil, &value) {
        if g_gametype.integer >= GT_FFA && g_gametype.integer < GT_MAX_GAME_TYPE {
            // Port-note: A store into `gametypeName`, a local the draft left as a hole.
            // Raven wrote: gametypeName = gametypeNames[g_gametype.integer]
            portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")

            // Port-note: A store into `s`, a local the draft left as a hole.
            // Raven wrote: s = strstr( value, gametypeName )
            portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")
            // Port-note: A read of `s`, a local the draft left as a hole.
            // Raven wrote: if( !s ) { G_FreeEntity( ent ); return; }
            portMissing("G_SpawnGEntityFromSpawnVars", source: "oracle/codemp/game/g_spawn.c:766")
        }
    }

    // move editor origin to pos
    ent!.s.pos.trBase = ent!.s.origin
    ent!.r.currentOrigin = ent!.s.origin

    // if we didn't get a classname, don't bother spawning anything
    if !G_CallSpawn(ent!) {
        G_FreeEntity(ent!)
    }

    //Tag on the ICARUS scripting information only to valid recipients
    if trap_ICARUS_ValidEnt(ent!) {
        trap_ICARUS_InitEnt(ent!)

        if ent!.classname != nil && !ent!.classname!.isEmpty {
            if Q_strncmp("NPC_", ent!.classname!, 4) != 0 {
                //Not an NPC_spawner (rww - probably don't even care for MP, but whatever)
                G_ActivateBehavior(ent!, BSET_SPAWN)
            }
        }
    }
}

/**
```
====================
G_AddSpawnVarToken
====================
```
*/
/// Source: oracle/codemp/game/g_spawn.c:851
func G_AddSpawnVarToken(_ string: String) -> String {
    let l: Int32
    // Port-note: A pointer local `char * dest` with no view.
    // Raven wrote: char *dest;
    portMissing("G_AddSpawnVarToken", source: "oracle/codemp/game/g_spawn.c:851")

    l = strlen(string)
    if level.numSpawnVarChars + l + 1 > MAX_SPAWN_VARS_CHARS {
        G_Error("G_AddSpawnVarToken: MAX_SPAWN_CHARS")
    }

    // Port-note: A store into `dest`, a local the draft left as a hole.
    // Raven wrote: dest = level.spawnVarChars + level.numSpawnVarChars
    portMissing("G_AddSpawnVarToken", source: "oracle/codemp/game/g_spawn.c:851")
    // Port-note: Raven's `memcpy( dest, string, l+1 )` runs over bytes that are not one record with a view.
    // Raven wrote: memcpy( dest, string, l+1 )
    portMissing("G_AddSpawnVarToken", source: "oracle/codemp/game/g_spawn.c:851")

    level.numSpawnVarChars += l + 1

    // Port-note: A read of `dest`, a local the draft left as a hole.
    // Raven wrote: return dest
    portMissing("G_AddSpawnVarToken", source: "oracle/codemp/game/g_spawn.c:851")
}

/// Source: oracle/codemp/game/g_spawn.c:868
func AddSpawnField(_ field: String, _ value: String) {
    var i: Int32

    i = 0
    while i < level.numSpawnVars {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: if (Q_stricmp(level.spawnVars[i][0], field) == 0) { level.spawnVars[ i ][1] = G_AddSpawnVarToken( value ); return; }
        portMissing("AddSpawnField", source: "oracle/codemp/game/g_spawn.c:868")
        i += 1
    }

    level.spawnVars[level.numSpawnVars][0] = G_AddSpawnVarToken(field)
    level.spawnVars[level.numSpawnVars][1] = G_AddSpawnVarToken(value)
    level.numSpawnVars += 1
}

/// Source: oracle/codemp/game/g_spawn.c:888
private func HandleEntityAdjustment() {
    var value: String = ""
    var origin = vec3_t()
    var newOrigin = vec3_t()
    var angles = vec3_t()
    var temp = CharBuf(64)
    let rotation: Float

    G_SpawnString("origin", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        sscanf(value, "%f %f %f", &origin)
    } else {
        origin[2] = 0.0
        origin[1] = origin[2]
        origin[0] = origin[1]
    }

    rotation = DEG2RAD(level.mRotationAdjust)
    newOrigin[0] = origin[0] * cos(rotation) - origin[1] * sin(rotation)
    newOrigin[1] = origin[0] * sin(rotation) + origin[1] * cos(rotation)
    newOrigin[2] = origin[2]
    newOrigin = newOrigin + level.mOriginAdjust
    // damn VMs don't handle outputing a float that is compatible with sscanf in all cases
    Com_sprintf(&temp, MAX_QPATH, "%0.0f %0.0f %0.0f", newOrigin[0], newOrigin[1], newOrigin[2])
    AddSpawnField("origin", String(temp))

    G_SpawnString("angles", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        sscanf(value, "%f %f %f", &angles)

        angles[1] = Float(fmod(angles[1] + level.mRotationAdjust, 360.0))
        // damn VMs don't handle outputing a float that is compatible with sscanf in all cases
        Com_sprintf(&temp, MAX_QPATH, "%0.0f %0.0f %0.0f", angles[0], angles[1], angles[2])
        AddSpawnField("angles", String(temp))
    } else {
        G_SpawnString("angle", NOVALUE, &value)
        if Q_stricmp(value, NOVALUE) != 0 {
            sscanf(value, "%f", &angles[1])
        } else {
            angles[1] = 0.0
        }
        angles[1] = Float(fmod(angles[1] + level.mRotationAdjust, 360.0))
        Com_sprintf(&temp, MAX_QPATH, "%0.0f", angles[1])
        AddSpawnField("angle", String(temp))
    }

    // RJR experimental code for handling "direction" field of breakable brushes
    // though direction is rarely ever used.
    G_SpawnString("direction", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        sscanf(value, "%f %f %f", &angles)
    } else {
        angles[2] = 0.0
        angles[1] = angles[2]
        angles[0] = angles[1]
    }
    angles[1] = Float(fmod(angles[1] + level.mRotationAdjust, 360.0))
    Com_sprintf(&temp, MAX_QPATH, "%0.0f %0.0f %0.0f", angles[0], angles[1], angles[2])
    AddSpawnField("direction", String(temp))


    AddSpawnField("BSPInstanceID", level.mTargetAdjust!)

    G_SpawnString("targetname", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("targetname", String(temp))
    }

    G_SpawnString("target", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("target", String(temp))
    }

    G_SpawnString("killtarget", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("killtarget", String(temp))
    }

    G_SpawnString("brushparent", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("brushparent", String(temp))
    }

    G_SpawnString("brushchild", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("brushchild", String(temp))
    }

    G_SpawnString("enemy", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("enemy", String(temp))
    }

    G_SpawnString("ICARUSname", NOVALUE, &value)
    if Q_stricmp(value, NOVALUE) != 0 {
        Com_sprintf(&temp, MAX_QPATH, "%s%s", level.mTargetAdjust!, value)
        AddSpawnField("ICARUSname", String(temp))
    }
}

/**
```
====================
G_ParseSpawnVars

Parses a brace bounded set of key / value pairs out of the
level's entity strings into level.spawnVars[]

This does not actually spawn an entity.
====================
```
*/
/// Source: oracle/codemp/game/g_spawn.c:1018
public func G_ParseSpawnVars(_ inSubBSP: Bool) -> Bool {
    var keyname = CharBuf(1024)
    var com_token = CharBuf(1024)

    level.numSpawnVars = 0
    level.numSpawnVarChars = 0

    // parse the opening brace
    let filledTest = trap_GetEntityToken(Int32((com_token).count))
    strcpy(&com_token, filledTest.1)
    if !filledTest.0 {
        // end of spawn string
        return false
    }
    if com_token[0] != Int32(ascii: "{") {
        G_Error("G_ParseSpawnVars: found %s when expecting {", com_token)
    }

    // go through all the key / value pairs
    while 1 != 0 {
        // parse key
        let filledTest2 = trap_GetEntityToken(Int32((keyname).count))
        strcpy(&keyname, filledTest2.1)
        if !filledTest2.0 {
            G_Error("G_ParseSpawnVars: EOF without closing brace")
        }

        if keyname[0] == Int32(ascii: "}") {
            break
        }

        // parse value
        let filledTest3 = trap_GetEntityToken(Int32((com_token).count))
        strcpy(&com_token, filledTest3.1)
        if !filledTest3.0 {
            G_Error("G_ParseSpawnVars: EOF without closing brace")
        }

        if com_token[0] == Int32(ascii: "}") {
            G_Error("G_ParseSpawnVars: closing brace without data")
        }
        if level.numSpawnVars == MAX_SPAWN_VARS {
            G_Error("G_ParseSpawnVars: MAX_SPAWN_VARS")
        }
        level.spawnVars[level.numSpawnVars][0] = G_AddSpawnVarToken(String(keyname))
        level.spawnVars[level.numSpawnVars][1] = G_AddSpawnVarToken(String(com_token))
        level.numSpawnVars += 1
    }

    if inSubBSP {
        HandleEntityAdjustment()
    }

    return true
}

/// Source: oracle/codemp/game/g_spawn.c:1259
func SP_worldspawn() {
    var text: String = ""
    var temp = CharBuf(32)
    var i: Int32
    var lengthRed: Int32
    var lengthBlue: Int32
    var lengthGreen: Int32

    //I want to "cull" entities out of net sends to clients to reduce
    //net traffic on our larger open maps -rww
    G_SpawnFloat("distanceCull", "6000.0", &g_cullDistance)
    trap_SetServerCull(g_cullDistance)

    G_SpawnString("classname", "", &text)
    if Q_stricmp(text, "worldspawn") != 0 {
        G_Error("SP_worldspawn: The first entity isn't 'worldspawn'")
    }

    i = 0
    while i < level.numSpawnVars {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
        // Raven wrote: if ( Q_stricmp( "spawnscript", level.spawnVars[i][0] ) == 0 ) {//ONly let them set spawnscript, we don't want them setting an angle or something on the world. BG_ParseField( fields, level.spawnVars[i][0], level.spawnVars[i][1], (byte *)&g_entities[ENTITYNUM_WORLD] ); }
        portMissing("SP_worldspawn", source: "oracle/codemp/game/g_spawn.c:1259")
        i += 1
    }
    //The server will precache the standard model and animations, so that there is no hit
    //when the first client connnects.
    if !BGPAFtextLoaded {
        BG_ParseAnimationFile("models/players/_humanoid/animation.cfg", bgHumanoidAnimations, true)
    }

    if precachedKyle == nil {
        let defSkin: Int32

        trap_G2API_InitGhoul2Model(&precachedKyle, "models/players/kyle/model.glm", 0, 0, -20, 0, 0)

        if precachedKyle != nil {
            defSkin = trap_R_RegisterSkin("models/players/kyle/model_default.skin")
            trap_G2API_SetSkin(precachedKyle, 0, defSkin, defSkin)
        }
    }

    if g2SaberInstance == nil {
        trap_G2API_InitGhoul2Model(&g2SaberInstance, "models/weapons2/saber/saber_w.glm", 0, 0, -20, 0, 0)

        if g2SaberInstance != nil {
            // indicate we will be bolted to model 0 (ie the player) on bolt 0 (always the right hand) when we get copied
            trap_G2API_SetBoltInfo(g2SaberInstance, 0, 0)
            // now set up the gun bolt on it
            trap_G2API_AddBolt(g2SaberInstance, 0, "*blade1")
        }
    }

    if g_gametype.integer == GT_SIEGE {
        //a tad bit of a hack, but..
        EWebPrecache()
    }

    // make some data visible to connecting client
    trap_SetConfigstring(CS_GAME_VERSION, GAME_VERSION)

    trap_SetConfigstring(CS_LEVEL_START_TIME, va("%i", level.startTime))

    G_SpawnString("music", "", &text)
    trap_SetConfigstring(CS_MUSIC, text)

    G_SpawnString("message", "", &text)
    trap_SetConfigstring(CS_MESSAGE, text) // map specific message

    trap_SetConfigstring(CS_MOTD, g_motd.string) // message of the day

    G_SpawnString("gravity", "800", &text)
    trap_Cvar_Set("g_gravity", text)

    G_SpawnString("enableBreath", "0", &text)
    trap_Cvar_Set("g_enableBreath", text)

    G_SpawnString("soundSet", "default", &text)
    trap_SetConfigstring(CS_GLOBAL_AMBIENT_SET, text)

    g_entities[ENTITYNUM_WORLD].s.number = ENTITYNUM_WORLD
    g_entities[ENTITYNUM_WORLD].classname = "worldspawn"

    // see if we want a warmup time
    trap_SetConfigstring(CS_WARMUP, "")
    if g_restarted.integer != 0 {
        trap_Cvar_Set("g_restarted", "0")
        level.warmupTime = 0
    }
    /*
    else if ( g_doWarmup.integer && g_gametype.integer != GT_DUEL && g_gametype.integer != GT_POWERDUEL ) { // Turn it on
    level.warmupTime = -1;
    trap_SetConfigstring( CS_WARMUP, va("%i", level.warmupTime) );
    G_LogPrintf( "Warmup:\n" );
    }
    */

    trap_SetConfigstring(CS_LIGHT_STYLES + (LS_STYLES_START * 3) + 0, defaultStyles[0][0])
    trap_SetConfigstring(CS_LIGHT_STYLES + (LS_STYLES_START * 3) + 1, defaultStyles[0][1])
    trap_SetConfigstring(CS_LIGHT_STYLES + (LS_STYLES_START * 3) + 2, defaultStyles[0][2])

    i = 1
    while i < LS_NUM_STYLES {
        Com_sprintf(&temp, Int32((temp).count), "ls_%dr", i)
        G_SpawnString(String(temp), defaultStyles[i][0], &text)
        lengthRed = strlen(text)
        trap_SetConfigstring(CS_LIGHT_STYLES + ((i + LS_STYLES_START) * 3) + 0, text)

        Com_sprintf(&temp, Int32((temp).count), "ls_%dg", i)
        G_SpawnString(String(temp), defaultStyles[i][1], &text)
        lengthGreen = strlen(text)
        trap_SetConfigstring(CS_LIGHT_STYLES + ((i + LS_STYLES_START) * 3) + 1, text)

        Com_sprintf(&temp, Int32((temp).count), "ls_%db", i)
        G_SpawnString(String(temp), defaultStyles[i][2], &text)
        lengthBlue = strlen(text)
        trap_SetConfigstring(CS_LIGHT_STYLES + ((i + LS_STYLES_START) * 3) + 2, text)

        if lengthRed != lengthGreen || lengthGreen != lengthBlue {
            Com_Error(ERR_DROP, "Style %d has inconsistent lengths: R %d, G %d, B %d", i, lengthRed, lengthGreen, lengthBlue)
        }
        i += 1
    }
}

//rww - Planning on having something here?
/// Source: oracle/codemp/game/g_spawn.c:1389
func SP_bsp_worldspawn() -> Bool {
    return true
}

/// Source: oracle/codemp/game/g_spawn.c:1394
func G_PrecacheSoundsets() {
    var ent: Entity? = nil
    var i: Int32
    var countedSets: Int32 = 0

    i = 0
    while i < MAX_GENTITIES {
        ent = g_entities[i]

        if ent!.inuse && ent!.soundSet != nil && !ent!.soundSet!.isEmpty {
            if countedSets >= MAX_AMBIENT_SETS {
                Com_Error(ERR_DROP, "MAX_AMBIENT_SETS was exceeded! (too many soundsets)\n")
            }

            ent!.s.soundSetIndex = G_SoundSetIndex(ent!.soundSet!)
            countedSets += 1
        }
        i += 1
    }
}

/**
```
==============
G_SpawnEntitiesFromString

Parses textual entity definitions out of an entstring and spawns gentities.
==============
```
*/
/// Source: oracle/codemp/game/g_spawn.c:1424
func G_SpawnEntitiesFromString(_ inSubBSP: Bool) {
    // allow calls to G_Spawn*()
    level.spawning = true
    level.numSpawnVars = 0

    // the worldspawn is not an actual entity, but it still
    // has a "spawn" function to perform any global setup
    // needed by a level (setting configstrings or cvars, etc)
    if !G_ParseSpawnVars(false) {
        G_Error("SpawnEntities: no entities")
    }

    if !inSubBSP {
        SP_worldspawn()
    } else {
        // Skip this guy if its worldspawn fails
        if !SP_bsp_worldspawn() {
            return
        }
    }

    // parse ents
    while G_ParseSpawnVars(inSubBSP) {
        G_SpawnGEntityFromSpawnVars(inSubBSP)
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Character' to expected argument type 'Int'".
    // Raven wrote: if( g_entities[ENTITYNUM_WORLD].behaviorSet[BSET_SPAWN] && g_entities[ENTITYNUM_WORLD].behaviorSet[BSET_SPAWN][0] ) {//World has a spawn script, but we don't want the world in ICARUS and running scripts, //so make a scriptrunner and start it going. gentity_t *script_runner = G_Spawn(); if ( script_runner ) { script_runner->behaviorSet[BSET_USE] = g_entities[ENTITYNUM_WORLD].behaviorSet[BSET_SPAWN]; script_runner->count = 1; script_runner->think = scriptrunner_run; script_runner->nextthink = level.time + 100; if ( script_runner->inuse ) { trap_ICARUS_InitEnt( script_runner ); } } }
    portMissing("G_SpawnEntitiesFromString", source: "oracle/codemp/game/g_spawn.c:1424")

    if !inSubBSP {
        level.spawning = false // any future calls to G_Spawn*() will be errors
    }

    G_PrecacheSoundsets()
}
