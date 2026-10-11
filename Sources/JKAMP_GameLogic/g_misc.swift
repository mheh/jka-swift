import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/g_misc.c:10
let HOLOCRON_RESPAWN_TIME = 30000 as Int32

/// Source: oracle/codemp/game/g_misc.c:11
let MAX_AMMO_GIVE = 2 as Int32

/// Source: oracle/codemp/game/g_misc.c:12
let STATION_RECHARGE_TIME = 100 as Int32

/// Source: oracle/codemp/game/g_misc.c:483
let MAX_INSTANCE_TYPES = 16 as Int32

/// Source: oracle/codemp/game/g_misc.c:2260
let FX_RUNNER_RESERVED = 0x800000 as Int32

/// Source: oracle/codemp/game/g_misc.c:2261
let FX_ENT_RADIUS = 32 as Int32

/// Source: oracle/codemp/game/g_misc.c:2540
var gEscaping: Bool {
    get { world.variables.gEscaping }
    set { world.variables.gEscaping = newValue }
}

/// Source: oracle/codemp/game/g_misc.c:2541
var gEscapeTime: Int32 {
    get { world.variables.gEscapeTime }
    set { world.variables.gEscapeTime = newValue }
}

/// Source: oracle/codemp/game/g_misc.c:2868
let TAG_GENERIC_NAME = "__WORLD__"

/// Source: oracle/codemp/game/g_misc.c:2873
let MAX_TAGS = 256 as Int32

/// Source: oracle/codemp/game/g_misc.c:2874
let MAX_TAG_OWNERS = 16 as Int32

/// Source: oracle/codemp/game/g_misc.c:2886
var refTagOwnerMap: Slots<TagOwner> { world.storage.refTagOwnerMap }

/// Source: oracle/codemp/game/g_misc.c:3345
let MAX_SHOOTERS = 16 as Int32

/// Source: oracle/codemp/game/g_misc.c:3351
var g_shooterClients: Slots<ShooterClient> { world.storage.g_shooterClients }

/// Source: oracle/codemp/game/g_misc.c:3352
var g_shooterClientInit: Bool {
    get { world.variables.g_shooterClientInit }
    set { world.variables.g_shooterClientInit = newValue }
}

/**
```
QUAKED info_camp (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for calculations in the utilities (spotlights, etc), but removed during gameplay.
```
*/
/// Source: oracle/codemp/game/g_misc.c:25
func SP_info_camp(_ `self`: Entity) {
    G_SetOrigin(`self`, &`self`.s.origin)
}

/**
```
QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for calculations in the utilities (spotlights, etc), but removed during gameplay.
```
*/
/// Source: oracle/codemp/game/g_misc.c:33
func SP_info_null(_ `self`: Entity) {
    G_FreeEntity(`self`)
}

/**
```
QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for in-game calculation, like jumppad targets.
target_position does the same thing
```
*/
/// Source: oracle/codemp/game/g_misc.c:42
func SP_info_notnull(_ `self`: Entity) {
    G_SetOrigin(`self`, &`self`.s.origin)
}

/**
```
QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) linear noIncidence START_OFF
Non-displayed light.
"light" overrides the default 300 intensity. - affects size
a negative "light" will subtract the light's color
'Linear' checkbox gives linear falloff instead of inverse square
'noIncidence' checkbox makes lighting smoother
Lights pointed at a target will be spotlights.
"radius" overrides the default 64 unit radius of a spotlight at the target point.
"scale" multiplier for the light intensity - does not affect size (default 1)
		greater than 1 is brighter, between 0 and 1 is dimmer.
"color" sets the light's color
"targetname" to indicate a switchable light - NOTE that all lights with the same targetname will be grouped together and act as one light (ie: don't mix colors, styles or start_off flag)
"style" to specify a specify light style, even for switchable lights!
"style_off" light style to use when switched off (Only for switchable lights)

   1 FLICKER (first variety)
   2 SLOW STRONG PULSE
   3 CANDLE (first variety)
   4 FAST STROBE
   5 GENTLE PULSE 1
   6 FLICKER (second variety)
   7 CANDLE (second variety)
   8 CANDLE (third variety)
   9 SLOW STROBE (fourth variety)
   10 FLUORESCENT FLICKER
   11 SLOW PULSE NOT FADE TO BLACK
   12 FAST PULSE FOR JEREMY
   13 Test Blending
```
*/
/// Source: oracle/codemp/game/g_misc.c:86
private func misc_lightstyle_set(_ ent: Entity) {
    let mLightStyle: Int32 = ent.count
    let mLightSwitchStyle: Int32 = ent.bounceCount
    let mLightOffStyle: Int32 = ent.fly_sound_debounce_time
    if !ent.alt_fire {
        //turn off
        if mLightOffStyle != 0 {
            var lightstyle = CharBuf(32)
            strcpy(&lightstyle, trap_GetConfigstring(CS_LIGHT_STYLES + (mLightOffStyle * 3) + 0, 32))
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 0, String(lightstyle))

            strcpy(&lightstyle, trap_GetConfigstring(CS_LIGHT_STYLES + (mLightOffStyle * 3) + 1, 32))
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 1, String(lightstyle))

            strcpy(&lightstyle, trap_GetConfigstring(CS_LIGHT_STYLES + (mLightOffStyle * 3) + 2, 32))
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 2, String(lightstyle))
        } else {
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 0, "a")
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 1, "a")
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 2, "a")
        }
    } else {
        //Turn myself on now
        if mLightSwitchStyle != 0 {
            var lightstyle = CharBuf(32)
            strcpy(&lightstyle, trap_GetConfigstring(CS_LIGHT_STYLES + (mLightSwitchStyle * 3) + 0, 32))
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 0, String(lightstyle))

            strcpy(&lightstyle, trap_GetConfigstring(CS_LIGHT_STYLES + (mLightSwitchStyle * 3) + 1, 32))
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 1, String(lightstyle))

            strcpy(&lightstyle, trap_GetConfigstring(CS_LIGHT_STYLES + (mLightSwitchStyle * 3) + 2, 32))
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 2, String(lightstyle))
        } else {
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 0, "z")
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 1, "z")
            trap_SetConfigstring(CS_LIGHT_STYLES + (mLightStyle * 3) + 2, "z")
        }
    }
}

/// Source: oracle/codemp/game/g_misc.c:134
func misc_dlight_use(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    G_ActivateBehavior(ent, BSET_USE)

    ent.alt_fire = !ent.alt_fire //toggle
    misc_lightstyle_set(ent)
}

/// Source: oracle/codemp/game/g_misc.c:142
func SP_light(_ `self`: Entity) {
    if `self`.targetname == nil {
        //if i don't have a light style switch, the i go away
        G_FreeEntity(`self`)
        return
    }

    G_SpawnInt("style", "0", &`self`.count)
    G_SpawnInt("switch_style", "0", &`self`.bounceCount)
    G_SpawnInt("style_off", "0", &`self`.fly_sound_debounce_time)
    G_SetOrigin(`self`, &`self`.s.origin)
    trap_LinkEntity(`self`)

    `self`.use = Use.misc_dlight_use

    `self`.s.eType = ET_GENERAL
    `self`.alt_fire = false
    `self`.r.svFlags |= SVF_NOCLIENT

    if !((`self`.spawnflags & 4) != 0) {
        //turn myself on now
        `self`.alt_fire = true
    }
    misc_lightstyle_set(`self`)
}

/// Source: oracle/codemp/game/g_misc.c:177
func TeleportPlayer(_ player: Entity, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t) {
    var tent: Entity?
    var isNPC: Bool = false
    if player.s.eType == ET_NPC {
        isNPC = true
    }

    // use temp events at source and destination to prevent the effect
    // from getting dropped by a second player event
    if player.client!.sess.sessionTeam != TEAM_SPECTATOR {
        tent = G_TempEntity(player.client!.ps.origin, EV_PLAYER_TELEPORT_OUT)
        tent!.s.clientNum = player.s.clientNum

        tent = G_TempEntity(origin, EV_PLAYER_TELEPORT_IN)
        tent!.s.clientNum = player.s.clientNum
    }

    // unlink to make sure it can't possibly interfere with G_KillBox
    trap_UnlinkEntity(player)

    player.client!.ps.origin = origin
    player.client!.ps.origin[2] += 1

    // spit the player out
    // Raven passes NULL for the `right` and `up` outputs.
    var scratchRight = vec3_t()
    var scratchUp = vec3_t()
    AngleVectors(angles, &player.client!.ps.velocity, &scratchRight, &scratchUp)
    player.client!.ps.velocity = player.client!.ps.velocity * 400
    player.client!.ps.pm_time = 160 // hold time
    player.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK

    // toggle the teleport bit so the client knows to not lerp
    player.client!.ps.eFlags ^= EF_TELEPORT_BIT

    // set angles
    SetClientViewAngle(player, angles)

    // kill anything at the destination
    if player.client!.sess.sessionTeam != TEAM_SPECTATOR {
        G_KillBox(player)
    }

    // save results of pmove
    BG_PlayerStateToEntityState(player.client!.ps, player.s, true)
    if isNPC {
        player.s.eType = ET_NPC
    }

    // use the precise origin for linking
    player.r.currentOrigin = player.client!.ps.origin

    if player.client!.sess.sessionTeam != TEAM_SPECTATOR {
        trap_LinkEntity(player)
    }
}

/**
```
QUAKED misc_teleporter_dest (1 0 0) (-32 -32 -24) (32 32 -16)
Point teleporters at these.
Now that we don't have teleport destination pads, this is just
an info_notnull
```
*/
/// Source: oracle/codemp/game/g_misc.c:239
func SP_misc_teleporter_dest(_ ent: Entity) {
}

/**
```
QUAKED misc_model (1 0 0) (-16 -16 -16) (16 16 16)
"model"		arbitrary .md3 or .ase file to display
turns into map triangles - not solid
```
*/
/// Source: oracle/codemp/game/g_misc.c:249
func SP_misc_model(_ ent: Entity) {
    G_FreeEntity(ent)
}

/**
```
QUAKED misc_model_static (1 0 0) (-16 -16 0) (16 16 16)
"model"		arbitrary .md3 file to display
"zoffset"	units to offset vertical culling position by, can be
			negative or positive. This does not affect the actual
			position of the model, only the culling position. Use
			it for models with stupid origins that go below the
			ground and whatnot.
"modelscale" scale on all axis
"modelscale_vec" scale difference axis

loaded as a model in the renderer - does not take up precious
bsp space!
```
*/
/// Source: oracle/codemp/game/g_misc.c:277
func SP_misc_model_static(_ ent: Entity) {
    G_FreeEntity(ent)
}

/**
```
QUAKED misc_G2model (1 0 0) (-16 -16 -16) (16 16 16)
"model"		arbitrary .glm file to display
```
*/
/// Source: oracle/codemp/game/g_misc.c:285
func SP_misc_G2model(_ ent: Entity) {
    //	VectorSet (ent->r.mins, -16, -16, -16);
    //	VectorSet (ent->r.maxs, 16, 16, 16);

    G_FreeEntity(ent)
}

/// Source: oracle/codemp/game/g_misc.c:305
func locateCamera(_ ent: Entity) {
    var dir = vec3_t()
    var target: Entity?
    var owner: Entity?

    owner = G_PickTarget(ent.target!)
    if owner == nil {
        G_Printf("Couldn't find target for misc_partal_surface\n")
        G_FreeEntity(ent)
        return
    }
    ent.r.ownerNum = owner!.s.number

    // frame holds the rotate speed
    if (owner!.spawnflags & 1) != 0 {
        ent.s.frame = 25
    } else if (owner!.spawnflags & 2) != 0 {
        ent.s.frame = 75
    }

    // swing camera ?
    if (owner!.spawnflags & 4) != 0 {
        // set to 0 for no rotation at all
        ent.s.powerups = 0
    } else {
        ent.s.powerups = 1
    }

    // clientNum holds the rotate offset
    ent.s.clientNum = owner!.s.clientNum

    ent.s.origin2 = owner!.s.origin

    // see if the portal_camera has a target
    target = G_PickTarget(owner!.target!)
    if target != nil {
        dir = target!.s.origin - owner!.s.origin
        VectorNormalize(&dir)
    } else {
        G_SetMovedir(&owner!.s.angles, &dir)
    }

    ent.s.eventParm = DirToByte(dir)
}

/**
```
QUAKED misc_portal_surface (0 0 1) (-8 -8 -8) (8 8 8)
The portal surface nearest this entity will show a view from the targeted misc_portal_camera, or a mirror view if untargeted.
This must be within 64 world units of the surface!
```
*/
/// Source: oracle/codemp/game/g_misc.c:355
func SP_misc_portal_surface(_ ent: Entity) {
    ent.r.mins = vec3_t()
    ent.r.maxs = vec3_t()
    trap_LinkEntity(ent)

    ent.r.svFlags = SVF_PORTAL
    ent.s.eType = ET_PORTAL

    if ent.target == nil {
        ent.s.origin2 = ent.s.origin
    } else {
        ent.think = Think.locateCamera
        ent.nextthink = level.time + 100
    }
}

/**
```
QUAKED misc_portal_camera (0 0 1) (-8 -8 -8) (8 8 8) slowrotate fastrotate noswing
The target for a misc_portal_director.  You can set either angles or target another entity to determine the direction of view.
"roll" an angle modifier to orient the camera around the target vector;
```
*/
/// Source: oracle/codemp/game/g_misc.c:375
func SP_misc_portal_camera(_ ent: Entity) {
    var roll: Float = 0

    ent.r.mins = vec3_t()
    ent.r.maxs = vec3_t()
    trap_LinkEntity(ent)

    G_SpawnFloat("roll", "0", &roll)

    ent.s.clientNum = Int32(Double(roll) / 360.0 * 256)
}

/**
```
QUAKED misc_bsp (1 0 0) (-16 -16 -16) (16 16 16)
"bspmodel"		arbitrary .bsp file to display
```
*/
/// Source: oracle/codemp/game/g_misc.c:390
func SP_misc_bsp(_ ent: Entity) {
    var temp = CharBuf(64)
    var out: String = ""
    var newAngle: Float = 0
    var tempint: Int32 = 0

    G_SpawnFloat("angle", "0", &newAngle)
    if Double(newAngle) != 0.0 {
        ent.s.angles[1] = newAngle
    }
    // don't support rotation any other way
    ent.s.angles[0] = 0.0
    ent.s.angles[2] = 0.0

    G_SpawnString("bspmodel", "", &out)

    ent.s.eFlags = EF_PERMANENT

    // Mainly for debugging
    G_SpawnInt("spacing", "0", &tempint)
    ent.s.time2 = tempint
    G_SpawnInt("flatten", "0", &tempint)
    ent.s.time = tempint

    Com_sprintf(&temp, MAX_QPATH, "#%s", out)
    trap_SetBrushModel(ent, String(temp)) // SV_SetBrushModel -- sets mins and maxs
    G_BSPIndex(String(temp))

    level.mNumBSPInstances += 1
    Com_sprintf(&temp, MAX_QPATH, "%d-", level.mNumBSPInstances)
    level.mOriginAdjust = ent.s.origin
    level.mRotationAdjust = ent.s.angles[1]
    level.mTargetAdjust = String(temp)
    //level.hasBspInstances = qtrue; //rww - also not referenced anywhere.
    level.mBSPInstanceDepth += 1
    /*
    G_SpawnString("filter", "", &out);
    strcpy(level.mFilter, out);
    */
    G_SpawnString("teamfilter", "", &out)
    strcpy(&level.mTeamFilterBuffer, out)

    ent.s.pos.trBase = ent.s.origin
    ent.r.currentOrigin = ent.s.origin
    ent.s.apos.trBase = ent.s.angles
    ent.r.currentAngles = ent.s.angles

    ent.s.eType = ET_MOVER

    trap_LinkEntity(ent)

    trap_SetActiveSubBSP(ent.s.modelindex)
    G_SpawnEntitiesFromString(true)
    trap_SetActiveSubBSP(-1)

    level.mBSPInstanceDepth -= 1
    //level.mFilter[0] = level.mTeamFilter[0] = 0;
    level.mTeamFilter = ""

    /*
    if ( g_debugRMG.integer )
    {
    G_SpawnDebugCylinder ( ent->s.origin, ent->s.time2, &g_entities[0], 2000, COLOR_WHITE );

    if ( ent->s.time )
    {
    G_SpawnDebugCylinder ( ent->s.origin, ent->s.time, &g_entities[0], 2000, COLOR_RED );
    }
    }
    */
}

/// Source: oracle/codemp/game/g_misc.c:484
func SP_terrain(_ ent: Entity) {
    var temp = CharBuf(1024)
    var final = CharBuf(64)
    var seed = CharBuf(64)
    var missionType = CharBuf(64)
    //char				soundSet[MAX_QPATH];
    let shaderNum: Int32
    var i: Int32
    var value: String = ""
    let terrainID: Int32

    //Force it to 1 when there is terrain on the level.
    trap_Cvar_Set("RMG", "1")
    g_RMG.integer = 1

    ent.s.angles = vec3_t()
    trap_SetBrushModel(ent, ent.model!)

    // Get the shader from the top of the brush
    //	shaderNum = gi.CM_GetShaderNum(s.modelindex);
    shaderNum = 0

    if g_RMG.integer != 0 {
        /*
        // Grab the default terrain file from the RMG cvar
        trap_Cvar_VariableStringBuffer("RMG_terrain", temp, MAX_QPATH);
        Com_sprintf(final, MAX_QPATH, "%s", temp);
        AddSpawnField("terrainDef", temp);

        trap_Cvar_VariableStringBuffer("RMG_instances", temp, MAX_QPATH);
        Com_sprintf(final, MAX_QPATH, "%s", temp);
        AddSpawnField("instanceDef", temp);

        trap_Cvar_VariableStringBuffer("RMG_miscents", temp, MAX_QPATH);
        Com_sprintf(final, MAX_QPATH, "%s", temp);
        AddSpawnField("miscentDef", temp);
        */
        //rww - disabled for now, don't want cvar overrides.

        strcpy(&seed, trap_Cvar_VariableStringBuffer("RMG_seed", MAX_QPATH))
        strcpy(&missionType, trap_Cvar_VariableStringBuffer("RMG_mission", MAX_QPATH))

        //rww - May want to implement these at some point.
        //trap_Cvar_VariableStringBuffer("RMG_soundset", soundSet, MAX_QPATH);
        //trap_SetConfigstring(CS_AMBIENT_SOUNDSETS, soundSet );
    }

    // Get info required for the common init
    temp[0] = 0
    G_SpawnString("heightmap", "", &value)
    Info_SetValueForKey(&temp, "heightMap", value)

    G_SpawnString("numpatches", "400", &value)
    Info_SetValueForKey(&temp, "numPatches", va("%d", atoi(value)))

    G_SpawnString("terxels", "4", &value)
    Info_SetValueForKey(&temp, "terxels", va("%d", atoi(value)))

    Info_SetValueForKey(&temp, "seed", String(seed))
    Info_SetValueForKey(&temp, "minx", va("%f", ent.r.mins[0]))
    Info_SetValueForKey(&temp, "miny", va("%f", ent.r.mins[1]))
    Info_SetValueForKey(&temp, "minz", va("%f", ent.r.mins[2]))
    Info_SetValueForKey(&temp, "maxx", va("%f", ent.r.maxs[0]))
    Info_SetValueForKey(&temp, "maxy", va("%f", ent.r.maxs[1]))
    Info_SetValueForKey(&temp, "maxz", va("%f", ent.r.maxs[2]))

    Info_SetValueForKey(&temp, "modelIndex", va("%d", ent.s.modelindex))

    G_SpawnString("terraindef", "grassyhills", &value)
    Info_SetValueForKey(&temp, "terrainDef", value)

    G_SpawnString("instancedef", "", &value)
    Info_SetValueForKey(&temp, "instanceDef", value)

    G_SpawnString("miscentdef", "", &value)
    Info_SetValueForKey(&temp, "miscentDef", value)

    Info_SetValueForKey(&temp, "missionType", String(missionType))

    i = 0
    while i < MAX_INSTANCE_TYPES {
        strcpy(&final, trap_Cvar_VariableStringBuffer(va("RMG_instance%d", i), MAX_QPATH))
        if strlen(final) != 0 {
            Info_SetValueForKey(&temp, va("inst%d", i), String(final))
        }
        i += 1
    }

    // Set additional data required on the client only
    G_SpawnString("densitymap", "", &value)
    Info_SetValueForKey(&temp, "densityMap", value)

    Info_SetValueForKey(&temp, "shader", va("%d", shaderNum))
    G_SpawnString("texturescale", "0.005", &value)
    Info_SetValueForKey(&temp, "texturescale", va("%f", atof(value)))

    // Initialise the common aspects of the terrain
    terrainID = trap_CM_RegisterTerrain(String(temp))
    //	SetCommon(common);

    Info_SetValueForKey(&temp, "terrainId", va("%d", terrainID))

    // Let the entity know if it is random generated or not
    //	SetIsRandom(common->GetIsRandom());

    // Let the game remember everything
    //level.landScapes[terrainID] = ent; //rww - also not referenced

    // Send all the data down to the client
    trap_SetConfigstring(CS_TERRAINS + terrainID, String(temp))

    // Make sure the contents are properly set
    ent.r.contents = CONTENTS_TERRAIN
    ent.r.svFlags = SVF_NOCLIENT
    ent.s.eFlags = EF_PERMANENT
    ent.s.eType = ET_TERRAIN

    // Hook into the world so physics will work
    trap_LinkEntity(ent)

    // If running RMG then initialize the terrain and handle team skins
    if g_RMG.integer != 0 {
        trap_RMG_Init(terrainID)

        /*
        if ( level.gametypeData->teams )
        {
        char temp[MAX_QPATH];

        // Red team change from RMG ?
        trap_GetConfigstring ( CS_GAMETYPE_REDTEAM, temp, MAX_QPATH );
        if ( Q_stricmp ( temp, level.gametypeTeam[TEAM_RED] ) )
        {
        level.gametypeTeam[TEAM_RED] = trap_VM_LocalStringAlloc ( temp );
        }

        // Blue team change from RMG ?
        trap_GetConfigstring ( CS_GAMETYPE_BLUETEAM, temp, MAX_QPATH );
        if ( Q_stricmp ( temp, level.gametypeTeam[TEAM_BLUE] ) )
        {
        level.gametypeTeam[TEAM_BLUE] = trap_VM_LocalStringAlloc ( temp );
        }
        }
        */
    }
}

//rww - Called by skyportal entities. This will check through entities and flag them
//as portal ents if they are in the same pvs as a skyportal entity and pass
//a direct point trace check between origins. I really wanted to use an eFlag for
//flagging portal entities, but too many entities like to reset their eFlags.
//Note that this was not part of the original wolf sky portal stuff.
/// Source: oracle/codemp/game/g_misc.c:638
func G_PortalifyEntities(_ ent: Entity) {
    var i: Int32 = 0
    var scan: Entity? = nil

    while i < MAX_GENTITIES {
        scan = g_entities[i]

        if scan != nil && scan!.inuse && scan!.s.number != ent.s.number && trap_InPVS(ent.s.origin, scan!.r.currentOrigin) {
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in

                trap_Trace(tr, ent.s.origin, vec3_origin, vec3_origin, scan!.r.currentOrigin, ent.s.number, CONTENTS_SOLID)

                if Double(tr.fraction) == 1.0 || (tr.entityNum == scan!.s.number && tr.entityNum != ENTITYNUM_NONE && tr.entityNum != ENTITYNUM_WORLD) {
                    if scan!.client == nil || scan!.s.eType == ET_NPC {
                        //making a client a portal entity would be bad.
                        scan!.s.isPortalEnt = true //he's flagged now
                    }
                }
            }
        }

        i += 1
    }

    ent.think = Think.G_FreeEntity //the portal entity is no longer needed because its information is stored in a config string.
    ent.nextthink = level.time
}

/**
```
QUAKED misc_skyportal_orient (.6 .7 .7) (-8 -8 0) (8 8 16)
point from which to orient the sky portal cam in relation
to the regular view position.

"modelscale"			the scale at which to scale positions
```
*/
/// Source: oracle/codemp/game/g_misc.c:675
func SP_misc_skyportal_orient(_ ent: Entity) {
    G_FreeEntity(ent)
}

/**
```
QUAKED misc_skyportal (.6 .7 .7) (-8 -8 0) (8 8 16)
"fov" for the skybox default is 80
To have the portal sky fogged, enter any of the following values:
"onlyfoghere" if non-0 allows you to set a global fog, but will only use that fog within this sky portal.

Also note that entities in the same PVS and visible (via point trace) from this
object will be flagged as portal entities. This means they will be sent and
updated from the server for every client every update regardless of where
they are, and they will essentially be added to the scene twice if the client
is in the same PVS as them (only once otherwise, but still once no matter
where the client is). In other words, don't go overboard with it or everything
will explode.
```
*/
/// Source: oracle/codemp/game/g_misc.c:694
func SP_misc_skyportal(_ ent: Entity) {
    var fov: String = ""
    var fogv = vec3_t()
    var fogn: Int32 = 0
    var fogf: Int32 = 0
    var isfog: Int32 = 0

    let fov_x: Float

    G_SpawnString("fov", "80", &fov)
    fov_x = atof(fov)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int32'".
    // Raven wrote: isfog += G_SpawnVector ("fogcolor", "0 0 0", fogv)
    portMissing("SP_misc_skyportal", source: "oracle/codemp/game/g_misc.c:694")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int32'".
    // Raven wrote: isfog += G_SpawnInt ("fognear", "0", &fogn)
    portMissing("SP_misc_skyportal", source: "oracle/codemp/game/g_misc.c:694")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int32'".
    // Raven wrote: isfog += G_SpawnInt ("fogfar", "300", &fogf)
    portMissing("SP_misc_skyportal", source: "oracle/codemp/game/g_misc.c:694")

    trap_SetConfigstring(CS_SKYBOXORG, va("%.2f %.2f %.2f %.1f %i %.2f %.2f %.2f %i %i", ent.s.origin[0], ent.s.origin[1], ent.s.origin[2], fov_x, Int32(isfog), fogv[0], fogv[1], fogv[2], fogn, fogf))

    ent.think = Think.G_PortalifyEntities
    ent.nextthink = level.time + 1050 //give it some time first so that all other entities are spawned.
}

/// Source: oracle/codemp/game/g_misc.c:760
func HolocronRespawn(_ `self`: Entity) {
    `self`.s.modelindex = (`self`.count - 128)
}

/// Source: oracle/codemp/game/g_misc.c:765
func HolocronPopOut(_ `self`: Entity) {
    if Q_irand(1, 10) < 5 {
        `self`.s.pos.trDelta[0] = Float(150 + Q_irand(1, 100))
    } else {
        `self`.s.pos.trDelta[0] = Float(-150 - Q_irand(1, 100))
    }
    if Q_irand(1, 10) < 5 {
        `self`.s.pos.trDelta[1] = Float(150 + Q_irand(1, 100))
    } else {
        `self`.s.pos.trDelta[1] = Float(-150 - Q_irand(1, 100))
    }
    `self`.s.pos.trDelta[2] = Float(150 + Q_irand(1, 100))
}

/// Source: oracle/codemp/game/g_misc.c:786
func HolocronTouch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    var i: Int32 = 0
    var othercarrying: Int32 = 0
    var time_lowest: Float = 0
    var index_lowest: Int32 = -1
    var hasall: Int32 = 1
    let forceReselect: Int32 = WP_NONE

    `self`.s.groundEntityNum = trace.entityNum

    if other.client == nil || other.health < 1 {
        return
    }

    if `self`.s.modelindex == 0 {
        return
    }

    if `self`.enemy != nil {
        return
    }

    if other.client!.ps.holocronsCarried[`self`.count] != 0 {
        return
    }

    if other.client!.ps.holocronCantTouch == `self`.s.number && other.client!.ps.holocronCantTouchTime > level.time {
        return
    }

    while i < NUM_FORCE_POWERS {
        if other.client!.ps.holocronsCarried[i] != 0 {
            othercarrying += 1

            if index_lowest == -1 || other.client!.ps.holocronsCarried[i] < time_lowest {
                index_lowest = i
                time_lowest = other.client!.ps.holocronsCarried[i]
            }
        } else if i != `self`.count {
            hasall = 0
        }
        i += 1
    }

    if hasall != 0 {
        //once we pick up this holocron we'll have all of them, so give us super special best prize!
        //G_Printf("You deserve a pat on the back.\n");
    }

    if !((other.client!.ps.fd.forcePowersActive & (1 << other.client!.ps.fd.forcePowerSelected)) != 0) {
        //If the player isn't using his currently selected force power, select this one
        if `self`.count != FP_SABER_OFFENSE && `self`.count != FP_SABER_DEFENSE && `self`.count != FP_SABERTHROW && `self`.count != FP_LEVITATION {
            other.client!.ps.fd.forcePowerSelected = `self`.count
        }
    }

    if g_MaxHolocronCarry.integer != 0 && othercarrying >= g_MaxHolocronCarry.integer {
        //make the oldest holocron carried by the player pop out to make room for this one
        other.client!.ps.holocronsCarried[index_lowest] = 0

        /*
        if (index_lowest == FP_SABER_OFFENSE && !HasSetSaberOnly())
        { //you lost your saberattack holocron, so no more saber for you
        other->client->ps.stats[STAT_WEAPONS] |= (1 << WP_STUN_BATON);
        other->client->ps.stats[STAT_WEAPONS] &= ~(1 << WP_SABER);

        if (other->client->ps.weapon == WP_SABER)
        {
        forceReselect = WP_SABER;
        }
        }
        */
        //NOTE: No longer valid as we are now always giving a force level 1 saber attack level in holocron
    }

    //G_Sound(other, CHAN_AUTO, G_SoundIndex("sound/weapons/w_pkup.wav"));
    G_AddEvent(other, EV_ITEM_PICKUP, `self`.s.number)

    other.client!.ps.holocronsCarried[`self`.count] = Float(level.time)
    `self`.s.modelindex = 0
    `self`.enemy = other

    `self`.pos2[0] = 1
    `self`.pos2[1] = Float(level.time + HOLOCRON_RESPAWN_TIME)

    /*
    if (self->count == FP_SABER_OFFENSE && !HasSetSaberOnly())
    { //player gets a saber
    other->client->ps.stats[STAT_WEAPONS] |= (1 << WP_SABER);
    other->client->ps.stats[STAT_WEAPONS] &= ~(1 << WP_STUN_BATON);

    if (other->client->ps.weapon == WP_STUN_BATON)
    {
    forceReselect = WP_STUN_BATON;
    }
    }
    */

    if forceReselect != WP_NONE {
        G_AddEvent(other, EV_NOAMMO, forceReselect)
    }

    //G_Printf("DON'T TOUCH ME\n");
}

/// Source: oracle/codemp/game/g_misc.c:907
func HolocronThink(_ ent: Entity) {
    justthink: do {
        if ent.pos2[0] != 0 && (ent.enemy == nil || ent.enemy!.client == nil || ent.enemy!.health < 1) {
            if ent.enemy != nil && ent.enemy!.client != nil {
                HolocronRespawn(ent)
                ent.s.pos.trBase = ent.enemy!.client!.ps.origin
                ent.s.origin = ent.enemy!.client!.ps.origin
                ent.r.currentOrigin = ent.enemy!.client!.ps.origin
                //copy to person carrying's origin before popping out of them
                HolocronPopOut(ent)
                ent.enemy!.client!.ps.holocronsCarried[ent.count] = 0
                ent.enemy = nil

                break justthink
            }
        } else if ent.pos2[0] != 0 && ent.enemy != nil && ent.enemy!.client != nil {
            ent.pos2[1] = Float(level.time + HOLOCRON_RESPAWN_TIME)
        }

        if ent.enemy != nil && ent.enemy!.client != nil {
            if ent.enemy!.client!.ps.holocronsCarried[ent.count] == 0 {
                ent.enemy!.client!.ps.holocronCantTouch = ent.s.number
                ent.enemy!.client!.ps.holocronCantTouchTime = Float(level.time + 5000)

                HolocronRespawn(ent)
                ent.s.pos.trBase = ent.enemy!.client!.ps.origin
                ent.s.origin = ent.enemy!.client!.ps.origin
                ent.r.currentOrigin = ent.enemy!.client!.ps.origin
                //copy to person carrying's origin before popping out of them
                HolocronPopOut(ent)
                ent.enemy = nil

                break justthink
            }

            if !ent.enemy!.inuse || (ent.enemy!.client != nil && ent.enemy!.client!.ps.fallingToDeath != 0) {
                if ent.enemy!.inuse && ent.enemy!.client != nil {
                    ent.enemy!.client!.ps.holocronBits &= ~(1 << ent.count)
                    ent.enemy!.client!.ps.holocronsCarried[ent.count] = 0
                }
                ent.enemy = nil
                HolocronRespawn(ent)
                ent.s.pos.trBase = ent.s.origin2
                ent.s.origin = ent.s.origin2
                ent.r.currentOrigin = ent.s.origin2

                ent.s.pos.trTime = level.time

                ent.pos2[0] = 0

                trap_LinkEntity(ent)

                break justthink
            }
        }

        if ent.pos2[0] != 0 && ent.pos2[1] < level.time {
            //isn't in original place and has been there for (HOLOCRON_RESPAWN_TIME) seconds without being picked up, so respawn
            ent.s.pos.trBase = ent.s.origin2
            ent.s.origin = ent.s.origin2
            ent.r.currentOrigin = ent.s.origin2

            ent.s.pos.trTime = level.time

            ent.pos2[0] = 0

            trap_LinkEntity(ent)
        }

    }
    ent.nextthink = level.time + 50

    if ent.s.pos.trDelta[0] != 0 || ent.s.pos.trDelta[1] != 0 || ent.s.pos.trDelta[2] != 0 {
        G_RunObject(ent)
    }
}

/// Source: oracle/codemp/game/g_misc.c:993
func SP_misc_holocron(_ ent: Entity) {
    var dest = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        if g_gametype.integer != GT_HOLOCRON {
            G_FreeEntity(ent)
            return true
        }

        if HasSetSaberOnly() {
            if ent.count == FP_SABER_OFFENSE || ent.count == FP_SABER_DEFENSE || ent.count == FP_SABERTHROW {
                //having saber holocrons in saber only mode is pointless
                G_FreeEntity(ent)
                return true
            }
        }

        ent.s.isJediMaster = true

        ent.r.maxs = vec3_t(8, 8, 8)
        ent.r.mins = vec3_t(-8, -8, -8)

        ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.1)
        ent.r.maxs[2] = Float(Double(ent.r.maxs[2]) - 0.1)

        dest = vec3_t(ent.s.origin[0], ent.s.origin[1], ent.s.origin[2] - 4096)
        trap_Trace(tr, ent.s.origin, ent.r.mins, ent.r.maxs, dest, ent.s.number, MASK_SOLID)
        if tr.startsolid != 0 {
            G_Printf("SP_misc_holocron: misc_holocron startsolid at %s\n", vtos(ent.s.origin))
            G_FreeEntity(ent)
            return true
        }

        //add the 0.1 back after the trace
        ent.r.maxs[2] = Float(Double(ent.r.maxs[2]) + 0.1)

        // allow to ride movers
        //	ent->s.groundEntityNum = tr.entityNum;

        G_SetOrigin(ent, &tr.endpos)

        if ent.count < 0 {
            ent.count = 0
        }

        if ent.count >= NUM_FORCE_POWERS {
            ent.count = NUM_FORCE_POWERS - 1
        }
        /*
        if (g_forcePowerDisable.integer &&
        (g_forcePowerDisable.integer & (1 << ent->count)))
        {
        G_FreeEntity(ent);
        return;
        }
        */
        //No longer doing this, causing too many complaints about accidentally setting no force powers at all
        //and starting a holocron game (making it basically just FFA)

        ent.enemy = nil

        ent.flags = FL_BOUNCE_HALF

        ent.s.modelindex = (ent.count - 128) //G_ModelIndex(holocronTypeModels[ent->count]);
        ent.s.eType = ET_HOLOCRON
        ent.s.pos.trType = TR_GRAVITY
        ent.s.pos.trTime = level.time

        ent.r.contents = CONTENTS_TRIGGER
        ent.clipmask = MASK_SOLID

        ent.s.trickedentindex4 = ent.count

        if forcePowerDarkLight[ent.count] == FORCE_DARKSIDE {
            ent.s.trickedentindex3 = 1
        } else if forcePowerDarkLight[ent.count] == FORCE_LIGHTSIDE {
            ent.s.trickedentindex3 = 2
        } else {
            ent.s.trickedentindex3 = 3
        }

        ent.physicsObject = true

        ent.s.origin2 = ent.s.pos.trBase //remember the spawn spot

        ent.touch = Touch.HolocronTouch

        trap_LinkEntity(ent)

        ent.think = Think.HolocronThink
        ent.nextthink = level.time + 50
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_misc.c:1107
func Use_Shooter(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    var dir = vec3_t()
    var deg: Float
    var up = vec3_t()
    var right = vec3_t()

    // see if we have a target
    if ent.enemy != nil {
        dir = ent.enemy!.r.currentOrigin - ent.s.origin
        VectorNormalize(&dir)
    } else {
        dir = ent.movedir
    }

    // randomize a bit
    PerpendicularVector(&up, dir)
    CrossProduct(up, dir, &right)

    deg = crandom() * ent.random
    _VectorMA(dir, deg, up, &dir)

    deg = crandom() * ent.random
    _VectorMA(dir, deg, right, &dir)

    VectorNormalize(&dir)

    switch ent.s.weapon {
    case WP_BLASTER:
        WP_FireBlasterMissile(ent, &ent.s.origin, dir, false)

    default:
        break
    }

    G_AddEvent(ent, EV_FIRE_WEAPON, 0)
}

/// Source: oracle/codemp/game/g_misc.c:1142
func InitShooter_Finish(_ ent: Entity) {
    ent.enemy = G_PickTarget(ent.target!)
    ent.think = nil
    ent.nextthink = 0
}

/// Source: oracle/codemp/game/g_misc.c:1148
func InitShooter(_ ent: Entity, _ weapon: Int32) {
    ent.use = Use.Use_Shooter
    ent.s.weapon = weapon

    RegisterItem(BG_FindItemForWeapon(weapon)!)

    G_SetMovedir(&ent.s.angles, &ent.movedir)

    if ent.random == 0 {
        ent.random = 1.0
    }
    ent.random = Float(sin(M_PI * Double(ent.random) / 180))
    // target might be a moving object, so we can't set movedir for it
    if ent.target != nil {
        ent.think = Think.InitShooter_Finish
        ent.nextthink = level.time + 500
    }
    trap_LinkEntity(ent)
}

/**
```
QUAKED shooter_blaster (1 0 0) (-16 -16 -16) (16 16 16)
Fires at either the target or the current direction.
"random" is the number of degrees of deviance from the taget. (1.0 default)
```
*/
/// Source: oracle/codemp/game/g_misc.c:1172
func SP_shooter_blaster(_ ent: Entity) {
    InitShooter(ent, WP_BLASTER)
}

/// Source: oracle/codemp/game/g_misc.c:1176
func check_recharge(_ ent: Entity) {
    if ent.fly_sound_debounce_time < level.time || ent.activator == nil || ent.activator!.client == nil || !((ent.activator!.client!.pers.cmd.buttons & BUTTON_USE) != 0) {
        if ent.activator != nil {
            G_Sound(ent, CHAN_AUTO, ent.genericValue7)
        }
        ent.s.loopSound = 0
        ent.s.loopIsSoundset = false
        ent.activator = nil
        ent.fly_sound_debounce_time = 0
    }

    if ent.activator == nil {
        //don't recharge during use
        if ent.genericValue8 < level.time {
            if ent.count < ent.genericValue4 {
                ent.count += 1
            }
            ent.genericValue8 = level.time + ent.genericValue5
        }
    }
    ent.s.health = ent.count //the "health bar" is gonna be how full we are
    ent.nextthink = level.time
}

/**
```
================
EnergyShieldStationSettings
================
```
*/
/// Source: oracle/codemp/game/g_misc.c:1213
func EnergyShieldStationSettings(_ ent: Entity) {
    G_SpawnInt("count", "200", &ent.count)

    G_SpawnInt("chargerate", "0", &ent.genericValue5)

    if ent.genericValue5 == 0 {
        ent.genericValue5 = STATION_RECHARGE_TIME
    }
}

/**
```
================
shield_power_converter_use
================
```
*/
/// Source: oracle/codemp/game/g_misc.c:1230
func shield_power_converter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    let dif: Int32
    var add: Int32
    var stop: Int32 = 1

    if activator.client == nil {
        return
    }

    if g_gametype.integer == GT_SIEGE && other.client != nil && other.client!.siegeClass != 0 {
        if bgSiegeClasses[other.client!.siegeClass].maxarmor == 0 {
            //can't use it!
            G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/interface/shieldcon_empty"))
            return
        }
    }

    if `self`.setTime < level.time {
        let maxArmor: Int32
        if `self`.s.loopSound == 0 {
            `self`.s.loopSound = G_SoundIndex("sound/interface/shieldcon_run")
            `self`.s.loopIsSoundset = false
        }
        `self`.setTime = level.time + 100

        if g_gametype.integer == GT_SIEGE && other.client != nil && other.client!.siegeClass != -1 {
            maxArmor = bgSiegeClasses[other.client!.siegeClass].maxarmor
        } else {
            maxArmor = activator.client!.ps.stats[STAT_MAX_HEALTH]
        }
        dif = maxArmor - activator.client!.ps.stats[STAT_ARMOR]

        if dif > 0 {
            if dif > MAX_AMMO_GIVE {
                add = MAX_AMMO_GIVE
            } else {
                add = dif
            }

            if `self`.count < add {
                add = `self`.count
            }

            if `self`.genericValue12 == 0 {
                `self`.count -= add
            }
            if `self`.count <= 0 {
                `self`.setTime = 0
            }
            stop = 0

            `self`.fly_sound_debounce_time = level.time + 500
            `self`.activator = activator

            activator.client!.ps.stats[STAT_ARMOR] += add
        }
    }

    if stop != 0 || `self`.count <= 0 {
        if `self`.s.loopSound != 0 && `self`.setTime < level.time {
            if `self`.count <= 0 {
                G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/interface/shieldcon_empty"))
            } else {
                G_Sound(`self`, CHAN_AUTO, `self`.genericValue7)
            }
        }
        `self`.s.loopSound = 0
        `self`.s.loopIsSoundset = false
        if `self`.setTime < level.time {
            `self`.setTime = level.time + `self`.genericValue5 + 100
        }
    }
}

//dispense generic ammo
/// Source: oracle/codemp/game/g_misc.c:1331
func ammo_generic_power_converter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    var add: Int32
    //int ammoType;
    var stop: Int32 = 1

    if activator.client == nil {
        return
    }

    if `self`.setTime < level.time {
        var gaveSome: Bool = false
        /*
        while (i < 3)
        {
        if (!self->s.loopSound)
        {
        self->s.loopSound = G_SoundIndex("sound/interface/ammocon_run");
        self->s.loopIsSoundset = qfalse;
        }
        self->setTime = level.time + 100;

        //dif = activator->client->ps.stats[STAT_MAX_HEALTH] - activator->client->ps.stats[STAT_ARMOR];
        switch (i)
        { //don't give rockets I guess
        case 0:
        ammoType = AMMO_BLASTER;
        break;
        case 1:
        ammoType = AMMO_POWERCELL;
        break;
        case 2:
        ammoType = AMMO_METAL_BOLTS;
        break;
        default:
        ammoType = -1;
        break;
        }

        if (ammoType != -1)
        {
        dif = ammoData[ammoType].max - activator->client->ps.ammo[ammoType];
        }
        else
        {
        dif = 0;
        }

        if (dif > 0)
        { //only give if not full
        if (dif > MAX_AMMO_GIVE)
        {
        add = MAX_AMMO_GIVE;
        }
        else
        {
        add = dif;
        }

        if (self->count<add)
        {
        add = self->count;
        }

        self->count -= add;
        if (self->count <= 0)
        {
        self->setTime = 0;
        break;
        }
        stop = 0;

        self->fly_sound_debounce_time = level.time + 500;
        self->activator = activator;

        activator->client->ps.ammo[ammoType] += add;
        }

        i++;
        }
        */
        var i: Int32 = AMMO_BLASTER
        if `self`.s.loopSound == 0 {
            `self`.s.loopSound = G_SoundIndex("sound/interface/ammocon_run")
            `self`.s.loopIsSoundset = false
        }
        //self->setTime = level.time + 100;
        `self`.fly_sound_debounce_time = level.time + 500
        `self`.activator = activator
        while i < AMMO_MAX {
            add = Int32(Double(ammoData[i].max) * 0.05)
            if add < 1 {
                add = 1
            }
            if ((activator.client!.ps.eFlags & EF_DOUBLE_AMMO) != 0 && (activator.client!.ps.ammo[i] < ammoData[i].max * 2)) || (activator.client!.ps.ammo[i] < ammoData[i].max) {
                gaveSome = true
                if g_gametype.integer == GT_SIEGE && i == AMMO_ROCKETS && activator.client!.ps.ammo[i] >= 10 {
                    //this stuff is already a freaking mess, so..
                    gaveSome = false
                }
                activator.client!.ps.ammo[i] += add
                if g_gametype.integer == GT_SIEGE && i == AMMO_ROCKETS && activator.client!.ps.ammo[i] >= 10 {
                    // fixme - this should SERIOUSLY be externed.
                    activator.client!.ps.ammo[i] = 10
                } else if (activator.client!.ps.eFlags & EF_DOUBLE_AMMO) != 0 {
                    if activator.client!.ps.ammo[i] >= ammoData[i].max * 2 {
                        // yuck.
                        activator.client!.ps.ammo[i] = ammoData[i].max * 2
                    } else {
                        stop = 0
                    }
                } else {
                    if activator.client!.ps.ammo[i] >= ammoData[i].max {
                        activator.client!.ps.ammo[i] = ammoData[i].max
                    } else {
                        stop = 0
                    }
                }
            }
            i += 1
            if `self`.genericValue12 == 0 && gaveSome {
                var sub: Int32 = Int32((Double(add) * 0.2))
                if sub < 1 {
                    sub = 1
                }
                `self`.count -= sub
                if `self`.count <= 0 {
                    `self`.count = 0
                    stop = 1
                    break
                }
            }
        }
    }

    if stop != 0 || `self`.count <= 0 {
        if `self`.s.loopSound != 0 && `self`.setTime < level.time {
            if `self`.count <= 0 {
                G_Sound(`self`, CHAN_AUTO, G_SoundIndex("sound/interface/ammocon_empty"))
            } else {
                G_Sound(`self`, CHAN_AUTO, `self`.genericValue7)
            }
        }
        `self`.s.loopSound = 0
        `self`.s.loopIsSoundset = false
        if `self`.setTime < level.time {
            `self`.setTime = level.time + `self`.genericValue5 + 100
        }
    }
}

/**
```
QUAKED misc_ammo_floor_unit (1 0 0) (-16 -16 0) (16 16 40)
model="/models/items/a_pwr_converter.md3"
Gives generic ammo when used

"count" - max charge value (default 200)
"chargerate" - rechage 1 point every this many milliseconds (default 2000)
"nodrain" - don't drain power from station if 1
```
*/
/// Source: oracle/codemp/game/g_misc.c:1515
func SP_misc_ammo_floor_unit(_ ent: Entity) {
    var dest = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        ent.r.mins = vec3_t(-16, -16, 0)
        ent.r.maxs = vec3_t(16, 16, 40)

        ent.s.origin[2] += 0.1
        ent.r.maxs[2] -= 0.1

        dest = vec3_t(ent.s.origin[0], ent.s.origin[1], ent.s.origin[2] - 4096)
        trap_Trace(tr, ent.s.origin, ent.r.mins, ent.r.maxs, dest, ent.s.number, MASK_SOLID)
        if tr.startsolid != 0 {
            G_Printf("SP_misc_ammo_floor_unit: misc_ammo_floor_unit startsolid at %s\n", vtos(ent.s.origin))
            G_FreeEntity(ent)
            return true
        }

        //add the 0.1 back after the trace
        ent.r.maxs[2] += 0.1

        // allow to ride movers
        ent.s.groundEntityNum = tr.entityNum

        G_SetOrigin(ent, &tr.endpos)

        if ent.health == 0 {
            ent.health = 60
        }

        if ent.model == nil || ent.model!.isEmpty {
            ent.model = "/models/items/a_pwr_converter.md3"
        }

        ent.s.modelindex = G_ModelIndex(ent.model!)

        ent.s.eFlags = 0
        ent.r.svFlags |= SVF_PLAYER_USABLE
        ent.r.contents = CONTENTS_SOLID
        ent.clipmask = MASK_SOLID

        EnergyShieldStationSettings(ent)

        ent.genericValue4 = ent.count //initial value
        ent.think = Think.check_recharge

        G_SpawnInt("nodrain", "0", &ent.genericValue12)

        if ent.genericValue12 == 0 {
            ent.s.health = ent.count
            ent.s.maxhealth = ent.s.health
        }
        ent.s.shouldtarget = true
        ent.s.teamowner = 0
        ent.s.owner = ENTITYNUM_NONE

        ent.nextthink = level.time + 200 // + STATION_RECHARGE_TIME;

        ent.use = Use.ammo_generic_power_converter_use

        ent.s.apos.trBase = ent.s.angles
        trap_LinkEntity(ent)

        G_SoundIndex("sound/interface/ammocon_run")
        ent.genericValue7 = G_SoundIndex("sound/interface/ammocon_done")
        G_SoundIndex("sound/interface/ammocon_empty")

        if g_gametype.integer == GT_SIEGE {
            //show on radar from everywhere
            ent.r.svFlags |= SVF_BROADCAST
            ent.s.eFlags |= EF_RADAROBJECT
            ent.s.genericenemyindex = G_IconIndex("gfx/mp/siegeicons/desert/weapon_recharge")
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
QUAKED misc_shield_floor_unit (1 0 0) (-16 -16 0) (16 16 40)
model="/models/items/a_shield_converter.md3"
Gives shield energy when used.

"count" - max charge value (default 50)
"chargerate" - rechage 1 point every this many milliseconds (default 3000)
"nodrain" - don't drain power from me
```
*/
/// Source: oracle/codemp/game/g_misc.c:1602
func SP_misc_shield_floor_unit(_ ent: Entity) {
    var dest = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { tr -> Bool in

        if g_gametype.integer != GT_CTF && g_gametype.integer != GT_CTY && g_gametype.integer != GT_SIEGE {
            G_FreeEntity(ent)
            return true
        }

        ent.r.mins = vec3_t(-16, -16, 0)
        ent.r.maxs = vec3_t(16, 16, 40)

        ent.s.origin[2] = Float(Double(ent.s.origin[2]) + 0.1)
        ent.r.maxs[2] = Float(Double(ent.r.maxs[2]) - 0.1)

        dest = vec3_t(ent.s.origin[0], ent.s.origin[1], ent.s.origin[2] - 4096)
        trap_Trace(tr, ent.s.origin, ent.r.mins, ent.r.maxs, dest, ent.s.number, MASK_SOLID)
        if tr.startsolid != 0 {
            G_Printf("SP_misc_shield_floor_unit: misc_shield_floor_unit startsolid at %s\n", vtos(ent.s.origin))
            G_FreeEntity(ent)
            return true
        }

        //add the 0.1 back after the trace
        ent.r.maxs[2] = Float(Double(ent.r.maxs[2]) + 0.1)

        // allow to ride movers
        ent.s.groundEntityNum = tr.entityNum

        G_SetOrigin(ent, &tr.endpos)

        if ent.health == 0 {
            ent.health = 60
        }

        if ent.model == nil || ent.model!.isEmpty {
            ent.model = "/models/items/a_shield_converter.md3"
        }

        ent.s.modelindex = G_ModelIndex(ent.model!)

        ent.s.eFlags = 0
        ent.r.svFlags |= SVF_PLAYER_USABLE
        ent.r.contents = CONTENTS_SOLID
        ent.clipmask = MASK_SOLID

        EnergyShieldStationSettings(ent)

        ent.genericValue4 = ent.count //initial value
        ent.think = Think.check_recharge

        G_SpawnInt("nodrain", "0", &ent.genericValue12)

        if ent.genericValue12 == 0 {
            ent.s.health = ent.count
            ent.s.maxhealth = ent.s.health
        }
        ent.s.shouldtarget = true
        ent.s.teamowner = 0
        ent.s.owner = ENTITYNUM_NONE

        ent.nextthink = level.time + 200 // + STATION_RECHARGE_TIME;

        ent.use = Use.shield_power_converter_use

        ent.s.apos.trBase = ent.s.angles
        trap_LinkEntity(ent)

        G_SoundIndex("sound/interface/shieldcon_run")
        ent.genericValue7 = G_SoundIndex("sound/interface/shieldcon_done")
        G_SoundIndex("sound/interface/shieldcon_empty")

        if g_gametype.integer == GT_SIEGE {
            //show on radar from everywhere
            ent.r.svFlags |= SVF_BROADCAST
            ent.s.eFlags |= EF_RADAROBJECT
            ent.s.genericenemyindex = G_IconIndex("gfx/mp/siegeicons/desert/shield_recharge")
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
QUAKED misc_model_shield_power_converter (1 0 0) (-16 -16 -16) (16 16 16)
model="models/items/psd_big.md3"
Gives shield energy when used.

"count" - the amount of ammo given when used (default 200)
```
*/
//------------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:1697
func SP_misc_model_shield_power_converter(_ ent: Entity) {
    if ent.health == 0 {
        ent.health = 60
    }

    ent.r.mins = vec3_t(-16, -16, -16)
    ent.r.maxs = vec3_t(16, 16, 16)

    ent.s.modelindex = G_ModelIndex(ent.model!)

    ent.s.eFlags = 0
    ent.r.svFlags |= SVF_PLAYER_USABLE
    ent.r.contents = CONTENTS_SOLID
    ent.clipmask = MASK_SOLID

    EnergyShieldStationSettings(ent)

    ent.genericValue4 = ent.count //initial value
    ent.think = Think.check_recharge

    ent.s.health = ent.count
    ent.s.maxhealth = ent.s.health
    ent.s.shouldtarget = true
    ent.s.teamowner = 0
    ent.s.owner = ENTITYNUM_NONE

    ent.nextthink = level.time + 200 // + STATION_RECHARGE_TIME;

    ent.use = Use.shield_power_converter_use

    G_SetOrigin(ent, &ent.s.origin)
    ent.s.apos.trBase = ent.s.angles
    trap_LinkEntity(ent)

    //G_SoundIndex("sound/movers/objects/useshieldstation.wav");

    ent.s.modelindex2 = G_ModelIndex("/models/items/psd_big.md3") // Precache model
}

/**
```
================
EnergyAmmoShieldStationSettings
================
```
*/
/// Source: oracle/codemp/game/g_misc.c:1743
func EnergyAmmoStationSettings(_ ent: Entity) {
    G_SpawnInt("count", "200", &ent.count)
}

/**
```
================
ammo_power_converter_use
================
```
*/
/// Source: oracle/codemp/game/g_misc.c:1753
func ammo_power_converter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    var add: Int32 = Int32(0.0) //,highest;
    let overcharge: Bool
    //	int			difBlaster,difPowerCell,difMetalBolts;
    var stop: Int32 = 1

    if activator.client == nil {
        return
    }

    if `self`.setTime < level.time {
        overcharge = false

        if `self`.s.loopSound == 0 {
            `self`.s.loopSound = G_SoundIndex("sound/player/pickupshield.wav")
        }

        `self`.setTime = level.time + 100

        if `self`.count != 0 {
            var i: Int32 = AMMO_BLASTER
            while i < AMMO_MAX {
                add = Int32(Double(ammoData[i].max) * 0.1)
                if add < 1 {
                    add = 1
                }
                if activator.client!.ps.ammo[i] < ammoData[i].max {
                    activator.client!.ps.ammo[i] += add
                    if activator.client!.ps.ammo[i] > ammoData[i].max {
                        activator.client!.ps.ammo[i] = ammoData[i].max
                    }
                }
                i += 1
            }
            if `self`.genericValue12 == 0 {
                `self`.count -= add
            }
            stop = 0

            `self`.fly_sound_debounce_time = level.time + 500
            `self`.activator = activator

            /*
            if (self->count > MAX_AMMO_GIVE)
            {
            add = MAX_AMMO_GIVE;
            }
            else if (self->count<0)
            {
            add = 0;
            }
            else
            {
            add = self->count;
            }

            activator->client->ps.ammo[AMMO_BLASTER] += add;
            activator->client->ps.ammo[AMMO_POWERCELL] += add;
            activator->client->ps.ammo[AMMO_METAL_BOLTS] += add;

            self->count -= add;
            stop = 0;

            self->fly_sound_debounce_time = level.time + 500;
            self->activator = activator;

            difBlaster = activator->client->ps.ammo[AMMO_BLASTER] - ammoData[AMMO_BLASTER].max;
            difPowerCell = activator->client->ps.ammo[AMMO_POWERCELL] - ammoData[AMMO_POWERCELL].max;
            difMetalBolts = activator->client->ps.ammo[AMMO_METAL_BOLTS] - ammoData[AMMO_METAL_BOLTS].max;

            // Find the highest one
            highest = difBlaster;
            if (difPowerCell>difBlaster)
            {
            highest = difPowerCell;
            }

            if (difMetalBolts > highest)
            {
            highest = difMetalBolts;
            }
            */
        }
    }

    if stop != 0 {
        `self`.s.loopSound = 0
        `self`.s.loopIsSoundset = false
    }
}

/**
```
QUAKED misc_model_ammo_power_converter (1 0 0) (-16 -16 -16) (16 16 16)
model="models/items/power_converter.md3"
Gives ammo energy when used.

"count" - the amount of ammo given when used (default 200)
"nodrain" - don't drain power from me
```
*/
//------------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:1864
func SP_misc_model_ammo_power_converter(_ ent: Entity) {
    if ent.health == 0 {
        ent.health = 60
    }

    ent.r.mins = vec3_t(-16, -16, -16)
    ent.r.maxs = vec3_t(16, 16, 16)

    ent.s.modelindex = G_ModelIndex(ent.model!)

    ent.s.eFlags = 0
    ent.r.svFlags |= SVF_PLAYER_USABLE
    ent.r.contents = CONTENTS_SOLID
    ent.clipmask = MASK_SOLID

    G_SpawnInt("nodrain", "0", &ent.genericValue12)
    ent.use = Use.ammo_power_converter_use

    EnergyAmmoStationSettings(ent)

    ent.genericValue4 = ent.count //initial value
    ent.think = Think.check_recharge

    if ent.genericValue12 == 0 {
        ent.s.health = ent.count
        ent.s.maxhealth = ent.s.health
    }
    ent.s.shouldtarget = true
    ent.s.teamowner = 0
    ent.s.owner = ENTITYNUM_NONE

    ent.nextthink = level.time + 200 // + STATION_RECHARGE_TIME;

    G_SetOrigin(ent, &ent.s.origin)
    ent.s.apos.trBase = ent.s.angles
    trap_LinkEntity(ent)

    //G_SoundIndex("sound/movers/objects/useshieldstation.wav");
}

/**
```
================
EnergyHealthStationSettings
================
```
*/
/// Source: oracle/codemp/game/g_misc.c:1911
func EnergyHealthStationSettings(_ ent: Entity) {
    G_SpawnInt("count", "200", &ent.count)
}

/**
```
================
health_power_converter_use
================
```
*/
/// Source: oracle/codemp/game/g_misc.c:1921
func health_power_converter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    let dif: Int32
    var add: Int32
    var stop: Int32 = 1

    if activator.client == nil {
        return
    }

    if `self`.setTime < level.time {
        if `self`.s.loopSound == 0 {
            `self`.s.loopSound = G_SoundIndex("sound/player/pickuphealth.wav")
        }
        `self`.setTime = level.time + 100

        dif = activator.client!.ps.stats[STAT_MAX_HEALTH] - activator.health

        if dif > 0 {
            if dif > 5 {
                add = 5 //MAX_AMMO_GIVE;
            } else {
                add = dif
            }

            if `self`.count < add {
                add = `self`.count
            }

            //self->count -= add;
            stop = 0

            `self`.fly_sound_debounce_time = level.time + 500
            `self`.activator = activator

            activator.health += add
        }
    }

    if stop != 0 {
        `self`.s.loopSound = 0
        `self`.s.loopIsSoundset = false
    }
}

/**
```
QUAKED misc_model_health_power_converter (1 0 0) (-16 -16 -16) (16 16 16)
model="models/items/power_converter.md3"
Gives ammo energy when used.

"count" - the amount of ammo given when used (default 200)
```
*/
//------------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:1982
func SP_misc_model_health_power_converter(_ ent: Entity) {
    if ent.health == 0 {
        ent.health = 60
    }

    ent.r.mins = vec3_t(-16, -16, -16)
    ent.r.maxs = vec3_t(16, 16, 16)

    ent.s.modelindex = G_ModelIndex(ent.model!)

    ent.s.eFlags = 0
    ent.r.svFlags |= SVF_PLAYER_USABLE
    ent.r.contents = CONTENTS_SOLID
    ent.clipmask = MASK_SOLID

    ent.use = Use.health_power_converter_use

    EnergyHealthStationSettings(ent)

    ent.genericValue4 = ent.count //initial value
    ent.think = Think.check_recharge

    //ent->s.maxhealth = ent->s.health = ent->count;
    ent.s.shouldtarget = true
    ent.s.teamowner = 0
    ent.s.owner = ENTITYNUM_NONE

    ent.nextthink = level.time + 200 // + STATION_RECHARGE_TIME;

    G_SetOrigin(ent, &ent.s.origin)
    ent.s.apos.trBase = ent.s.angles
    trap_LinkEntity(ent)

    //G_SoundIndex("sound/movers/objects/useshieldstation.wav");
    G_SoundIndex("sound/player/pickuphealth.wav")
    ent.genericValue7 = G_SoundIndex("sound/interface/shieldcon_done")

    if g_gametype.integer == GT_SIEGE {
        //show on radar from everywhere
        ent.r.svFlags |= SVF_BROADCAST
        ent.s.eFlags |= EF_RADAROBJECT
        ent.s.genericenemyindex = G_IconIndex("gfx/mp/siegeicons/desert/bacta")
    }
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2266
func fx_runner_think(_ ent: Entity) {
    BG_EvaluateTrajectory(ent.s.pos, level.time, &ent.r.currentOrigin)
    BG_EvaluateTrajectory(ent.s.apos, level.time, &ent.r.currentAngles)

    // call the effect with the desired position and orientation
    if ent.s.isPortalEnt {
        //		G_AddEvent( ent, EV_PLAY_PORTAL_EFFECT_ID, ent->genericValue5 );
    } else {
        //		G_AddEvent( ent, EV_PLAY_EFFECT_ID, ent->genericValue5 );
    }

    // start the fx on the client (continuous)
    ent.s.modelindex2 = FX_STATE_CONTINUOUS

    ent.s.angles = ent.r.currentAngles
    ent.s.origin = ent.r.currentOrigin

    // The SDK also declares `random`, so the call names the bg module.
    ent.nextthink = Int32(level.time + ent.delay + JKAMP_BG.random() * ent.random)

    if (ent.spawnflags & 4) != 0 {
        G_RadiusDamage(ent.r.currentOrigin, ent, Float(ent.splashDamage), Float(ent.splashRadius), ent, ent, MOD_UNKNOWN)
    }

    if ent.target2 != nil && !ent.target2!.isEmpty {
        // let our target know that we have spawned an effect
        G_UseTargets2(ent, ent, ent.target2!)
    }

    if !((ent.spawnflags & 2) != 0) && ent.s.loopSound == 0 {
        if ent.soundSet != nil && !ent.soundSet!.isEmpty {
            ent.s.soundSetIndex = G_SoundSetIndex(ent.soundSet!)
            ent.s.loopIsSoundset = true
            ent.s.loopSound = BMS_MID
        }
    }
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2313
func fx_runner_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.s.isPortalEnt {
        //rww - mark it as broadcast upon first use if it's within the area of a skyportal
        `self`.r.svFlags |= SVF_BROADCAST
    }

    if (`self`.spawnflags & 2) != 0 {
        // call the effect with the desired position and orientation, as a safety thing,
        //	make sure we aren't thinking at all.
        let saveState: Int32 = `self`.s.modelindex2 + 1

        fx_runner_think(`self`)
        `self`.nextthink = -1
        // one shot indicator
        `self`.s.modelindex2 = saveState
        if `self`.s.modelindex2 > FX_STATE_ONE_SHOT_LIMIT {
            `self`.s.modelindex2 = FX_STATE_ONE_SHOT
        }

        if `self`.target2 != nil {
            // let our target know that we have spawned an effect
            G_UseTargets2(`self`, `self`, `self`.target2!)
        }

        if `self`.soundSet != nil && !`self`.soundSet!.isEmpty {
            `self`.s.soundSetIndex = G_SoundSetIndex(`self`.soundSet!)
            G_AddEvent(`self`, EV_BMODEL_SOUND, BMS_START)
        }
    } else {
        // ensure we are working with the right think function
        `self`.think = Think.fx_runner_think

        // toggle our state
        if `self`.nextthink == -1 {
            // NOTE: we fire the effect immediately on use, the fx_runner_think func will set
            //	up the nextthink time.
            fx_runner_think(`self`)

            if `self`.soundSet != nil && !`self`.soundSet!.isEmpty {
                `self`.s.soundSetIndex = G_SoundSetIndex(`self`.soundSet!)
                G_AddEvent(`self`, EV_BMODEL_SOUND, BMS_START)
                `self`.s.loopSound = BMS_MID
                `self`.s.loopIsSoundset = true
            }
        } else {
            // turn off for now
            `self`.nextthink = -1

            // turn off fx on client
            `self`.s.modelindex2 = FX_STATE_OFF

            if `self`.soundSet != nil && !`self`.soundSet!.isEmpty {
                `self`.s.soundSetIndex = G_SoundSetIndex(`self`.soundSet!)
                G_AddEvent(`self`, EV_BMODEL_SOUND, BMS_END)
                `self`.s.loopSound = 0
                `self`.s.loopIsSoundset = false
            }
        }
    }
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2387
func fx_runner_link(_ ent: Entity) {
    var dir = vec3_t()

    if ent.target != nil && !ent.target!.isEmpty {
        // try to use the target to override the orientation
        var target: Entity? = nil

        target = G_Find(target, \.targetname, ent.target)

        if target == nil {
            // Bah, no good, dump a warning, but continue on and use the UP vector
            Com_Printf("fx_runner_link: target specified but not found: %s\n", ent.target!)
            Com_Printf("  -assuming UP orientation.\n")
        } else {
            // Our target is valid so let's override the default UP vector
            dir = target!.s.origin - ent.s.origin
            VectorNormalize(&dir)
            vectoangles(dir, &ent.s.angles)
        }
    }

    // don't really do anything with this right now other than do a check to warn the designers if the target2 is bogus
    if ent.target2 != nil && !ent.target2!.isEmpty {
        var target: Entity? = nil

        target = G_Find(target, \.targetname, ent.target2)

        if target == nil {
            // Target2 is bogus, but we can still continue
            Com_Printf("fx_runner_link: target2 was specified but is not valid: %s\n", ent.target2!)
        }
    }

    G_SetAngles(ent, ent.s.angles)

    if (ent.spawnflags & 1) != 0 || (ent.spawnflags & 2) != 0 {
        // We won't even consider thinking until we are used
        ent.nextthink = -1
    } else {
        if ent.soundSet != nil && !ent.soundSet!.isEmpty {
            ent.s.soundSetIndex = G_SoundSetIndex(ent.soundSet!)
            ent.s.loopSound = BMS_MID
            ent.s.loopIsSoundset = true
        }

        // Let's get to work right now!
        ent.think = Think.fx_runner_think
        ent.nextthink = level.time + 200 // wait a small bit, then start working
    }

    // make us useable if we can be targeted
    if ent.targetname != nil && !ent.targetname!.isEmpty {
        ent.use = Use.fx_runner_use
    }
}

//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2456
func SP_fx_runner(_ ent: Entity) {
    var fxFile: String = ""

    G_SpawnString("fxFile", "", &fxFile)
    // Get our defaults
    G_SpawnInt("delay", "200", &ent.delay)
    G_SpawnFloat("random", "0", &ent.random)
    G_SpawnInt("splashRadius", "16", &ent.splashRadius)
    G_SpawnInt("splashDamage", "5", &ent.splashDamage)

    if ent.s.angles[0] == 0 && ent.s.angles[1] == 0 && ent.s.angles[2] == 0 {
        // didn't have angles, so give us the default of up
        ent.s.angles = vec3_t(-90, 0, 0)
    }

    if fxFile.isEmpty {
        Com_Printf(S_COLOR_RED + "ERROR: fx_runner %s at %s has no fxFile specified\n", ent.targetname!, vtos(ent.s.origin))
        G_FreeEntity(ent)
        return
    }

    // Try and associate an effect file, unfortunately we won't know if this worked or not
    //	until the CGAME trys to register it...
    ent.s.modelindex = G_EffectIndex(fxFile)

    // important info transmitted
    ent.s.eType = ET_FX
    ent.s.speed = Float(ent.delay)
    ent.s.time = Int32(ent.random)
    ent.s.modelindex2 = FX_STATE_OFF

    // Give us a bit of time to spawn in the other entities, since we may have to target one of 'em
    ent.think = Think.fx_runner_link
    ent.nextthink = level.time + 400

    // Save our position and link us up!
    G_SetOrigin(ent, &ent.s.origin)

    ent.r.maxs = vec3_t(Float(FX_ENT_RADIUS), Float(FX_ENT_RADIUS), Float(FX_ENT_RADIUS))
    ent.r.mins = ent.r.maxs * -1

    trap_LinkEntity(ent)
}

/**
```
QUAKED fx_spacedust (1 0 0) (-16 -16 -16) (16 16 16)
This world effect will spawn space dust globally into the level.

"count" the number of snow particles (default of 1000)
```
*/
//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2509
func SP_CreateSpaceDust(_ ent: Entity) {
    G_EffectIndex(va("*spacedust %i", ent.count))
    //G_EffectIndex("*constantwind ( 10 -10 0 )");
}

/**
```
QUAKED fx_snow (1 0 0) (-16 -16 -16) (16 16 16)
This world effect will spawn snow globally into the level.

"count" the number of snow particles (default of 1000)
```
*/
//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2522
func SP_CreateSnow(_ ent: Entity) {
    G_EffectIndex("*snow")
    G_EffectIndex("*fog")
    G_EffectIndex("*constantwind (100 100 -100)")
}

/**
```
QUAKED fx_rain (1 0 0) (-16 -16 -16) (16 16 16)
This world effect will spawn rain globally into the level.

"count" the number of rain particles (default of 500)
```
*/
//----------------------------------------------------------
/// Source: oracle/codemp/game/g_misc.c:2535
func SP_CreateRain(_ ent: Entity) {
    G_EffectIndex(va("*rain init %i", ent.count))
}

/// Source: oracle/codemp/game/g_misc.c:2543
func Use_Target_Screenshake(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    var bGlobal: Bool = false

    if ent.genericValue6 != 0 {
        bGlobal = true
    }

    G_ScreenShake(ent.s.origin, nil, ent.speed, ent.genericValue5, bGlobal)
}

/// Source: oracle/codemp/game/g_misc.c:2555
func SP_target_screenshake(_ ent: Entity) {
    G_SpawnFloat("intensity", "10", &ent.speed)
    //intensity of the shake
    G_SpawnInt("duration", "800", &ent.genericValue5)
    //duration of the shake
    G_SpawnInt("globalshake", "1", &ent.genericValue6)
    //non-0 if shake should be global (all clients). Otherwise, only in the PVS.

    ent.use = Use.Use_Target_Screenshake
}

/// Source: oracle/codemp/game/g_misc.c:2569
func Use_Target_Escapetrig(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    if ent.genericValue6 == 0 {
        gEscaping = true
        gEscapeTime = level.time + ent.genericValue5
    } else if gEscaping {
        var i: Int32 = 0
        gEscaping = false
        while i < MAX_CLIENTS {
            //all of the survivors get 100 points!
            if g_entities[i].inuse && g_entities[i].client != nil && g_entities[i].health > 0 && g_entities[i].client!.sess.sessionTeam != TEAM_SPECTATOR && !((g_entities[i].client!.ps.pm_flags & PMF_FOLLOW) != 0) {
                AddScore(g_entities[i], g_entities[i].client!.ps.origin, 100)
            }
            i += 1
        }
        if activator.inuse && activator.client != nil {
            //the one who escaped gets 500
            AddScore(activator, activator.client!.ps.origin, 500)
        }

        LogExit("Escaped!")
    }
}

/// Source: oracle/codemp/game/g_misc.c:2599
func SP_target_escapetrig(_ ent: Entity) {
    if g_gametype.integer != GT_SINGLE_PLAYER {
        G_FreeEntity(ent)
        return
    }

    G_SpawnInt("escapetime", "60000", &ent.genericValue5)
    //time given (in ms) for the escape
    G_SpawnInt("escapegoal", "0", &ent.genericValue6)
    //if non-0, when used, will end an ongoing escape instead of start it

    ent.use = Use.Use_Target_Escapetrig
}

/**
```
QUAKED misc_maglock (0 .5 .8) (-8 -8 -8) (8 8 8) x x x x x x x x
Place facing a door (using the angle, not a targetname) and it will lock that door.  Can only be destroyed by lightsaber and will automatically unlock the door it's attached to

NOTE: place these half-way in the door to make it flush with the door's surface.

"target"	thing to use when destoryed (not doors - it automatically unlocks the door it was angled at)
"health"	default is 10
```
*/
/// Source: oracle/codemp/game/g_misc.c:2623
func maglock_die(_ `self`: Entity, _ inflictor: Entity, _ attacker: Entity, _ damage: Int32, _ mod: Int32) {
    //unlock our door if we're the last lock pointed at the door
    if `self`.activator != nil {
        `self`.activator!.lockCount -= 1
        if `self`.activator!.lockCount == 0 {
            `self`.activator!.flags &= ~FL_INACTIVE
        }
    }

    //use targets
    G_UseTargets(`self`, attacker)
    //die
    //rwwFIXMEFIXME - weap expl func
    //	WP_Explode( self );
}

/// Source: oracle/codemp/game/g_misc.c:2645
func SP_misc_maglock(_ `self`: Entity) {
    //NOTE: May have to make these only work on doors that are either untargeted
    //		or are targeted by a trigger, not doors fired off by scripts, counters
    //		or other such things?
    `self`.s.modelindex = G_ModelIndex("models/map_objects/imp_detention/door_lock.md3")
    `self`.genericValue1 = G_EffectIndex("maglock/explosion")

    G_SetOrigin(`self`, &`self`.s.origin)

    `self`.think = Think.maglock_link
    //FIXME: for some reason, when you re-load a level, these fail to find their doors...?  Random?  Testing an additional 200ms after the START_TIME_FIND_LINKS
    `self`.nextthink = level.time + START_TIME_FIND_LINKS + 200 //START_TIME_FIND_LINKS;//because we need to let the doors link up and spawn their triggers first!
}

/// Source: oracle/codemp/game/g_misc.c:2659
func maglock_link(_ `self`: Entity) {
    //find what we're supposed to be attached to
    var forward = vec3_t()
    var start = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var traceEnt: Entity?

        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(`self`.s.angles, &forward, &scratchRight, &scratchUp)
        _VectorMA(`self`.s.origin, 128, forward, &end)
        _VectorMA(`self`.s.origin, -4, forward, &start)

        trap_Trace(trace, start, vec3_origin, vec3_origin, end, `self`.s.number, MASK_SHOT)

        if trace.allsolid != 0 || trace.startsolid != 0 {
            Com_Error(ERR_DROP, "misc_maglock at %s in solid\n", vtos(`self`.s.origin))
            G_FreeEntity(`self`)
            return true
        }
        if Double(trace.fraction) == 1.0 {
            `self`.think = Think.maglock_link
            `self`.nextthink = level.time + 100
            /*
            Com_Error( ERR_DROP,"misc_maglock at %s pointed at no surface\n", vtos(self->s.origin) );
            G_FreeEntity( self );
            */
            return true
        }
        traceEnt = g_entities[trace.entityNum]
        if trace.entityNum >= ENTITYNUM_WORLD || traceEnt == nil || Q_stricmp("func_door", traceEnt!.classname!) != 0 {
            `self`.think = Think.maglock_link
            `self`.nextthink = level.time + 100
            //Com_Error( ERR_DROP,"misc_maglock at %s not pointed at a door\n", vtos(self->s.origin) );
            //G_FreeEntity( self );
            return true
        }

        //check the traceEnt, make sure it's a door and give it a lockCount and deactivate it
        //find the trigger for the door
        `self`.activator = G_FindDoorTrigger(traceEnt!)
        if `self`.activator == nil {
            `self`.activator = traceEnt
        }
        `self`.activator!.lockCount += 1
        `self`.activator!.flags |= FL_INACTIVE

        //now position and orient it
        vectoangles(trace.plane.normal, &end)
        G_SetOrigin(`self`, &trace.endpos)
        G_SetAngles(`self`, end)

        //make it hittable
        //FIXME: if rotated/inclined this bbox may be off... but okay if we're a ghoul model?
        //self->s.modelindex = G_ModelIndex( "models/map_objects/imp_detention/door_lock.md3" );
        `self`.r.mins = vec3_t(-8, -8, -8)
        `self`.r.maxs = vec3_t(8, 8, 8)
        `self`.r.contents = CONTENTS_CORPSE

        //make it destroyable
        `self`.flags |= FL_SHIELDED //only damagable by lightsabers
        `self`.takedamage = true
        `self`.health = 10
        `self`.die = Die.maglock_die
        //self->fxID = G_EffectIndex( "maglock/explosion" );

        trap_LinkEntity(`self`)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/g_misc.c:2730
func faller_touch(_ `self`: Entity, _ other: Entity, _ trace: JKAMP.Trace) {
    if `self`.epVelocity[2] < -100 && `self`.genericValue7 < level.time {
        let r: Int32 = Q_irand(1, 3)

        if r == 1 {
            `self`.genericValue11 = G_SoundIndex("sound/chars/stofficer1/misc/pain25")
        } else if r == 2 {
            `self`.genericValue11 = G_SoundIndex("sound/chars/stofficer1/misc/pain50")
        } else {
            `self`.genericValue11 = G_SoundIndex("sound/chars/stofficer1/misc/pain75")
        }

        G_EntitySound(`self`, CHAN_VOICE, `self`.genericValue11)
        G_EntitySound(`self`, CHAN_AUTO, `self`.genericValue10)

        `self`.genericValue6 = level.time + 3000

        `self`.genericValue7 = level.time + 200
    }
}

/// Source: oracle/codemp/game/g_misc.c:2758
func faller_think(_ ent: Entity) {
    let gravity: Float = 3.0
    let mass: Float = 0.09
    let bounce: Float = 1.1

    if ent.genericValue6 < level.time {
        ent.think = Think.G_FreeEntity
        ent.nextthink = level.time
        return
    }

    if ent.epVelocity[2] < -100 {
        if ent.genericValue8 == 0 {
            G_EntitySound(ent, CHAN_VOICE, ent.genericValue9)
            ent.genericValue8 = 1
        }
    } else {
        ent.genericValue8 = 0
    }

    G_RunExPhys(ent, gravity, mass, bounce, true, nil, 0)
    ent.s.pos.trDelta = ent.epVelocity * 10.0
    ent.nextthink = level.time + 25
}

/// Source: oracle/codemp/game/g_misc.c:2789
func misc_faller_create(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    let faller: Entity? = G_Spawn()

    faller!.genericValue10 = G_SoundIndex("sound/player/fallsplat")
    faller!.genericValue9 = G_SoundIndex("sound/chars/stofficer1/misc/falling1")
    faller!.genericValue8 = 0
    faller!.genericValue7 = 0

    faller!.genericValue6 = level.time + 15000

    G_SetOrigin(faller!, &ent.s.origin)

    faller!.s.modelGhoul2 = 1
    faller!.s.modelindex = G_ModelIndex("models/players/stormtrooper/model.glm")
    faller!.s.g2radius = 100

    faller!.s.customRGBA[0] = Q_irand(1, 255)
    faller!.s.customRGBA[1] = Q_irand(1, 255)
    faller!.s.customRGBA[2] = Q_irand(1, 255)
    faller!.s.customRGBA[3] = 255

    faller!.r.mins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
    faller!.r.maxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))

    faller!.clipmask = MASK_PLAYERSOLID
    faller!.r.contents = MASK_PLAYERSOLID

    faller!.s.eFlags = (EF_RAG | EF_CLIENTSMOOTH)

    faller!.think = Think.faller_think
    faller!.nextthink = level.time

    faller!.touch = Touch.faller_touch

    faller!.epVelocity[0] = flrand(-256.0, 256.0)
    faller!.epVelocity[1] = flrand(-256.0, 256.0)

    trap_LinkEntity(faller!)
}

/// Source: oracle/codemp/game/g_misc.c:2830
func misc_faller_think(_ ent: Entity) {
    misc_faller_create(ent, ent, ent)
    ent.nextthink = level.time + ent.genericValue1 + Q_irand(0, ent.genericValue2)
}

/**
```
QUAKED misc_faller (1 0 0) (-8 -8 -8) (8 8 8)
Falling stormtrooper - spawned every interval+random fudgefactor,
or if specified, when used.

targetname	- if specified, will only spawn when used
interval	- spawn every so often (milliseconds)
fudgefactor	- milliseconds between 0 and this number randomly added to interval
```
*/
/// Source: oracle/codemp/game/g_misc.c:2844
func SP_misc_faller(_ ent: Entity) {
    G_ModelIndex("models/players/stormtrooper/model.glm")
    G_SoundIndex("sound/chars/stofficer1/misc/pain25")
    G_SoundIndex("sound/chars/stofficer1/misc/pain50")
    G_SoundIndex("sound/chars/stofficer1/misc/pain75")
    G_SoundIndex("sound/chars/stofficer1/misc/falling1")
    G_SoundIndex("sound/player/fallsplat")

    G_SpawnInt("interval", "500", &ent.genericValue1)
    G_SpawnInt("fudgefactor", "0", &ent.genericValue2)

    if ent.targetname == nil || ent.targetname!.isEmpty {
        ent.think = Think.misc_faller_think
        ent.nextthink = level.time + ent.genericValue1 + Q_irand(0, ent.genericValue2)
    } else {
        ent.use = Use.misc_faller_create
    }
}

/// Source: oracle/codemp/game/g_misc.c:2888
func FirstFreeTagOwner() -> TagOwner? {
    var i: Int32 = 0

    while i < MAX_TAG_OWNERS {
        if !refTagOwnerMap[i].inuse {
            return refTagOwnerMap[i]
        }
        i += 1
    }

    Com_Printf("WARNING: MAX_TAG_OWNERS (%i) REF TAG LIMIT HIT\n", MAX_TAG_OWNERS)
    return nil
}

/// Source: oracle/codemp/game/g_misc.c:2905
func FirstFreeRefTag(_ tagOwner: TagOwner) -> ReferenceTag? {
    var i: Int32 = 0


    while i < MAX_TAGS {
        if !tagOwner.tags[i].inuse {
            return tagOwner.tags[i]
        }
        i += 1
    }

    Com_Printf("WARNING: MAX_TAGS (%i) REF TAG LIMIT HIT\n", MAX_TAGS)
    return nil
}

/// Source: oracle/codemp/game/g_misc.c:2930
func TAG_Init() {
    var i: Int32 = 0
    var x: Int32 = 0

    while i < MAX_TAG_OWNERS {
        while x < MAX_TAGS {
            refTagOwnerMap[i].tags[x].clear()
            x += 1
        }
        refTagOwnerMap[i].clear()
        i += 1
    }
}

/// Source: oracle/codemp/game/g_misc.c:2953
func TAG_FindOwner(_ owner: String) -> TagOwner? {
    var i: Int32 = 0

    while i < MAX_TAG_OWNERS {
        if refTagOwnerMap[i].inuse && Q_stricmp(refTagOwnerMap[i].name, owner) == 0 {
            return refTagOwnerMap[i]
        }
        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/g_misc.c:2975
func TAG_Find(_ owner: String, _ name: String) -> ReferenceTag? {
    var tagOwner: TagOwner? = nil
    var i: Int32 = 0

    if !owner.isEmpty {
        tagOwner = TAG_FindOwner(owner)
    }
    if tagOwner == nil {
        tagOwner = TAG_FindOwner(TAG_GENERIC_NAME)
    }

    //Not found...
    if tagOwner == nil {
        tagOwner = TAG_FindOwner(TAG_GENERIC_NAME)

        if tagOwner == nil {
            return nil
        }
    }

    while i < MAX_TAGS {
        if tagOwner!.tags[i].inuse && Q_stricmp(tagOwner!.tags[i].name, name) == 0 {
            return tagOwner!.tags[i]
        }
        i += 1
    }

    //Try the generic owner instead
    tagOwner = TAG_FindOwner(TAG_GENERIC_NAME)

    if tagOwner == nil {
        return nil
    }

    i = 0
    while i < MAX_TAGS {
        if tagOwner!.tags[i].inuse && Q_stricmp(tagOwner!.tags[i].name, name) == 0 {
            return tagOwner!.tags[i]
        }
        i += 1
    }

    return nil
}

/// Source: oracle/codemp/game/g_misc.c:3036
func TAG_Add(_ name: String, _ owner: String?, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t, _ radius: Int32, _ flags: Int32) -> ReferenceTag? {
    var tag: ReferenceTag? = nil
    var tagOwner: TagOwner? = nil
    // Raven assigns his own `owner` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var owner = owner

    //Make sure this tag's name isn't alread in use
    if TAG_Find(owner!, name) != nil {
        Com_Printf(S_COLOR_RED + "Duplicate tag name \"%s\"\n", name)
        return nil
    }

    //Attempt to add this to the owner's list
    if owner == nil || owner!.isEmpty {
        //If the owner isn't found, use the generic world name
        owner = TAG_GENERIC_NAME
    }

    tagOwner = TAG_FindOwner(owner!)

    if tagOwner == nil {
        //Create a new owner list
        tagOwner = FirstFreeTagOwner() //new	tagOwner_t;

        if tagOwner == nil {
            return nil
        }
    }

    //This is actually reverse order of how SP does it because of the way we're storing/allocating.
    //Now that we have the owner, we want to get the first free reftag on the owner itself.
    tag = FirstFreeRefTag(tagOwner!)

    if tag == nil {
        return nil
    }

    //Copy the information
    tag!.origin = origin
    tag!.angles = angles
    tag!.radius = radius
    tag!.flags = flags

    if name.isEmpty {
        Com_Printf(S_COLOR_RED + "ERROR: Nameless ref_tag found at (%i %i %i)\n", Int32(origin[0]), Int32(origin[1]), Int32(origin[2]))
        return nil
    }


    //Copy the name
    Q_strncpyz(&tagOwner!.nameBuffer, owner!, MAX_REFNAME)
    tagOwner!.name = Q_strlwr(tagOwner!.name) //NOTENOTE: For case insensitive searches on a map

    //Copy the name
    Q_strncpyz(&tag!.nameBuffer, name, MAX_REFNAME)
    tag!.name = Q_strlwr(tag!.name) //NOTENOTE: For case insensitive searches on a map

    tagOwner!.inuse = true
    tag!.inuse = true

    return tag
}

/// Source: oracle/codemp/game/g_misc.c:3112
func TAG_GetOrigin(_ owner: String, _ name: String, _ origin: inout JKAShared.vec3_t) -> Int32 {
    let tag: ReferenceTag? = TAG_Find(owner, name)

    if tag == nil {
        origin = vec3_t()
        return 0
    }

    origin = tag!.origin

    return 1
}

/// Source: oracle/codemp/game/g_misc.c:3134
func TAG_GetOrigin2(_ owner: String?, _ name: String, _ origin: inout JKAShared.vec3_t) -> Int32 {
    let tag: ReferenceTag? = TAG_Find(owner!, name)

    if tag == nil {
        return 0
    }

    origin = tag!.origin

    return 1
}

/// Source: oracle/codemp/game/g_misc.c:3153
func TAG_GetAngles(_ owner: String, _ name: String, _ angles: inout JKAShared.vec3_t) -> Int32 {
    let tag: ReferenceTag? = TAG_Find(owner, name)

    if tag == nil {
        return 0
    }

    angles = tag!.angles

    return 1
}

/// Source: oracle/codemp/game/g_misc.c:3174
func TAG_GetRadius(_ owner: String?, _ name: String) -> Int32 {
    let tag: ReferenceTag? = TAG_Find(owner!, name)

    if tag == nil {
        return 0
    }

    return tag!.radius
}

/// Source: oracle/codemp/game/g_misc.c:3193
func TAG_GetFlags(_ owner: String, _ name: String) -> Int32 {
    let tag: ReferenceTag? = TAG_Find(owner, name)

    if tag == nil {
        return 0
    }

    return tag!.flags
}

/// Source: oracle/codemp/game/g_misc.c:3267
func ref_link(_ ent: Entity) {
    var tag: ReferenceTag?

    if ent.target != nil {
        //TODO: Find the target and set our angles to that direction
        let target: Entity? = G_Find(nil, \.targetname, ent.target)
        var dir = vec3_t()

        if target != nil {
            //Find the direction to the target
            dir = target!.s.origin - ent.s.origin
            VectorNormalize(&dir)
            vectoangles(dir, &ent.s.angles)

            //FIXME: Does pitch get flipped?
        } else {
            Com_Printf(S_COLOR_RED + "ERROR: ref_tag (%s) has invalid target (%s)", ent.targetname!, ent.target!)
        }
    }

    //Add the tag
    tag = TAG_Add(ent.targetname!, ent.ownername, ent.s.origin, ent.s.angles, 16, 0)

    //Delete immediately, cannot be refered to as an entity again
    //NOTE: this means if you wanted to link them in a chain for, say, a path, you can't
    G_FreeEntity(ent)
}

/// Source: oracle/codemp/game/g_misc.c:3300
func SP_reference_tag(_ ent: Entity) {
    if ent.target != nil {
        //Init cannot occur until all entities have been spawned
        ent.think = Think.ref_link
        ent.nextthink = level.time + START_TIME_LINK_ENTS
    } else {
        ref_link(ent)
    }
}

/// Source: oracle/codemp/game/g_misc.c:3354
func G_ClientForShooter() -> Client? {
    var i: Int32 = 0

    if !g_shooterClientInit {
        //in theory it should be initialized to 0 on the stack, but just in case.
        g_shooterClients.zero()
        g_shooterClientInit = true
    }

    while i < MAX_SHOOTERS {
        if !g_shooterClients[i].inuse {
            return g_shooterClients[i].cl
        }
        i += 1
    }

    Com_Error(ERR_DROP, "No free shooter clients - hit MAX_SHOOTERS")
    return nil
}

/// Source: oracle/codemp/game/g_misc.c:3377
func G_FreeClientForShooter(_ cl: Client) {
    var i: Int32 = 0
    while i < MAX_SHOOTERS {
        if g_shooterClients[i].cl == cl {
            g_shooterClients[i].inuse = false
            return
        }
        i += 1
    }
}

/// Source: oracle/codemp/game/g_misc.c:3391
func misc_weapon_shooter_fire(_ `self`: Entity) {
    FireWeapon(`self`, (`self`.spawnflags & 1) != 0)
    if (`self`.spawnflags & 2) != 0 {
        //repeat
        `self`.think = Think.misc_weapon_shooter_fire
        `self`.nextthink = Int32(level.time + `self`.wait)
    }
}

/// Source: oracle/codemp/game/g_misc.c:3401
func misc_weapon_shooter_use(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.think == Think.misc_weapon_shooter_fire {
        //repeating fire, stop
        /*
        G_FreeClientForShooter(self->client);
        self->think = G_FreeEntity;
        self->nextthink = level.time;
        */
        `self`.nextthink = 0
        return
    }
    //otherwise, fire
    misc_weapon_shooter_fire(`self`)
}

/// Source: oracle/codemp/game/g_misc.c:3417
func misc_weapon_shooter_aim(_ `self`: Entity) {
    //update my aim
    if `self`.target != nil {
        let targ: Entity? = G_Find(nil, \.targetname, `self`.target)
        if targ != nil {
            `self`.enemy = targ
            `self`.pos1 = targ!.r.currentOrigin - `self`.r.currentOrigin
            `self`.pos1 = targ!.r.currentOrigin
            vectoangles(`self`.pos1, &`self`.client!.ps.viewangles)
            SetClientViewAngle(`self`, `self`.client!.ps.viewangles)
            //FIXME: don't keep doing this unless target is a moving target?
            `self`.nextthink = level.time + FRAMETIME
        } else {
            `self`.enemy = nil
        }
    }
}

/// Source: oracle/codemp/game/g_misc.c:3444
func SP_misc_weapon_shooter(_ `self`: Entity) {
    var s: String = ""

    //alloc a client just for the weapon code to use
    `self`.client = G_ClientForShooter() //(gclient_s *)gi.Malloc(sizeof(gclient_s), TAG_G_ALLOC, qtrue);

    G_SpawnString("weapon", "", &s)

    //set weapon
    `self`.client!.ps.weapon = WP_BLASTER
    `self`.s.weapon = `self`.client!.ps.weapon
    if !s.isEmpty {
        //use a different weapon
        `self`.client!.ps.weapon = GetIDForString(WPTable, s)
        `self`.s.weapon = `self`.client!.ps.weapon
    }

    RegisterItem(BG_FindItemForWeapon(`self`.s.weapon)!)

    //set where our muzzle is
    `self`.client!.renderInfo.muzzlePoint = `self`.s.origin
    //permanently updated (don't need for MP)
    //self->client->renderInfo.mPCalcTime = Q3_INFINITE;

    //set up to link
    if `self`.target != nil {
        `self`.think = Think.misc_weapon_shooter_aim
        `self`.nextthink = level.time + START_TIME_LINK_ENTS
    } else {
        //just set aim angles
        `self`.client!.ps.viewangles = `self`.s.angles
        // Raven passes NULL for the `right` and `up` outputs.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(`self`.s.angles, &`self`.pos1, &scratchRight, &scratchUp)
    }

    //set up to fire when used
    `self`.use = Use.misc_weapon_shooter_use

    if `self`.wait == 0 {
        `self`.wait = 500
    }
}

/**
```
QUAKED misc_weather_zone (0 .5 .8) ?
Determines a region to check for weather contents - will significantly reduce load time
```
*/
/// Source: oracle/codemp/game/g_misc.c:3491
func SP_misc_weather_zone(_ ent: Entity) {
    G_FreeEntity(ent)
}
