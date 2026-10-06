import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_stats.c:14
// TODO: Port global TeamTable
// Raven wrote: stringID_table_t TeamTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/NPC_stats.c:24
// TODO: Port global ClassTable
// Raven wrote: stringID_table_t ClassTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/NPC_stats.c:88
// TODO: Port global BSTable
// Raven wrote: stringID_table_t BSTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/NPC_stats.c:106
// TODO: Port global BSETTable
// Raven wrote: stringID_table_t BSETTable[]
// Raven's data table is C storage in the C target, with his initializer as written, reached as a Slots over the C array, the bg_tables.c shape that tables.py writes.

/// Source: oracle/codemp/game/NPC_stats.c:133
/// Raven's data table, a hand property of `GameWorld`.
var TeamNames: [String] {
    get { world.TeamNames }
    set { world.TeamNames = newValue }
}

/// Source: oracle/codemp/game/NPC_stats.c:156
// Raven wrote: char *ClassNames[CLASS_NUM_CLASSES]
let ClassNames: [String] = { () -> [String] in portMissing("ClassNames", source: "oracle/codemp/game/NPC_stats.c:156") }()

/// Source: oracle/codemp/game/NPC_stats.c:236
let MAX_NPC_DATA_SIZE = 0x20000 as Int32

/// Source: oracle/codemp/game/NPC_stats.c:237
var NPCParms: JKAShared.CharBuf {
    get { world.variables.NPCParms }
    set { world.variables.NPCParms = newValue }
}

/// Source: oracle/codemp/game/NPC_stats.c:238
var NPCFile: JKAShared.CharBuf {
    get { world.variables.NPCFile }
    set { world.variables.NPCFile = newValue }
}

/// Source: oracle/codemp/game/NPC_stats.c:3238
var npcParseBuffer: JKAShared.CharBuf {
    get { world.variables.npcParseBuffer }
    set { world.variables.npcParseBuffer = newValue }
}

/**
```
NPC_ReactionTime
```
*/
//FIXME use grandom in here
/// Source: oracle/codemp/game/NPC_stats.c:220
func NPC_ReactionTime() -> Int32 {
    return 200 * (6 - NPCInfo!.stats.reactions)
}

/**
```
static race_t TranslateRaceName( const char *name )
{
	if ( !Q_stricmp( name, "human" ) )
	{
		return RACE_HUMAN;
	}
	return RACE_NONE;
}
```
*/
/**
```
static rank_t TranslateRankName( const char *name )

  Should be used to determine pip bolt-ons
```
*/
/// Source: oracle/codemp/game/NPC_stats.c:287
private func TranslateRankName(_ name: String) -> rank_t {
    if Q_stricmp(name, "civilian") == 0 {
        return RANK_CIVILIAN
    }

    if Q_stricmp(name, "crewman") == 0 {
        return RANK_CREWMAN
    }

    if Q_stricmp(name, "ensign") == 0 {
        return RANK_ENSIGN
    }

    if Q_stricmp(name, "ltjg") == 0 {
        return RANK_LT_JG
    }

    if Q_stricmp(name, "lt") == 0 {
        return RANK_LT
    }

    if Q_stricmp(name, "ltcomm") == 0 {
        return RANK_LT_COMM
    }

    if Q_stricmp(name, "commander") == 0 {
        return RANK_COMMANDER
    }

    if Q_stricmp(name, "captain") == 0 {
        return RANK_CAPTAIN
    }

    return RANK_CIVILIAN
}

/// Source: oracle/codemp/game/NPC_stats.c:424
func G_ParseAnimFileSet(_ filename: String, _ animCFG: String, _ animFileIndex: inout Int32) -> Bool {
    animFileIndex = BG_ParseAnimationFile(filename, nil, false)
    //if it's humanoid we should have it cached and return it, if it is not it will be loaded (unless it's also cached already)

    if animFileIndex == -1 {
        return false
    }

    //I guess this isn't really even needed game-side.
    //BG_ParseAnimationSndFile(filename, *animFileIndex);
    return true
}

/// Source: oracle/codemp/game/NPC_stats.c:439
func NPC_PrecacheAnimationCFG(_ NPC_type: String) {
    // look for the right NPC





    // parse the NPC info block


    // legsmodel
    //must copy data out of this pointer into a different part of memory because the funcs we're about to call will call COM_ParseExt

    // playerModel
    /*
    char	animName[MAX_QPATH];
    char	*GLAName;
    char	*slash = NULL;
    char	*strippedName;

    int handle = gi.G2API_PrecacheGhoul2Model( va( "models/players/%s/model.glm", value ) );
    if ( handle > 0 )//FIXME: isn't 0 a valid handle?
    {
    GLAName = gi.G2API_GetAnimFileNameIndex( handle );
    if ( GLAName )
    {
    Q_strncpyz( animName, GLAName, sizeof( animName ), qtrue );
    slash = strrchr( animName, '/' );
    if ( slash )
    {
    *slash = 0;
    }
    strippedName = COM_SkipPath( animName );

    //must copy data out of this pointer into a different part of memory because the funcs we're about to call will call COM_ParseExt
    Q_strncpyz( filename, value, sizeof( filename ), qtrue );
    G_ParseAnimFileSet( value, strippedName, &junk );//qfalse );
    //FIXME: still not precaching the animsounds.cfg?
    return;
    }
    }
    */
    //rwwFIXMEFIXME: Do this properly.
}

/// Source: oracle/codemp/game/NPC_stats.c:551
func NPC_PrecacheWeapons(_ playerTeam: JKAMP.team_t, _ spawnflags: Int32, _ NPCtype: String) {
    let weapons: Int32 = NPC_WeaponsForTeam(playerTeam, spawnflags, NPCtype)
    var curWeap: Int32

    curWeap = WP_SABER
    while curWeap < WP_NUM_WEAPONS {
        if (weapons & (1 << curWeap)) != 0 {
            RegisterItem(BG_FindItemForWeapon(weapon_t(curWeap))!)
        }
        curWeap += 1
    }

    //precache the in-hand/in-world ghoul2 weapon model
}

/**
```
void NPC_Precache ( char *NPCName )

Precaches NPC skins, tgas and md3s.
```
*/
/// Source: oracle/codemp/game/NPC_stats.c:599
func NPC_Precache(_ spawner: Entity) {
    var playerTeam: npcteam_t = NPCTEAM_FREE
    var token: String
    var value: String = ""
    var p = TextCursor()
    // Port-note: A pointer local `char * patch` with no view.
    // Raven wrote: char *patch;
    portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
    var sound = CharBuf(64)
    var md3Model: Bool = false
    var playerModel = CharBuf(64)
    var customSkin = CharBuf(64)

    if Q_stricmp("random", spawner.NPC_type!) == 0 {
        //sorry, can't precache a random just yet
        return
    }
    strcpy(&customSkin, "default")

    p = TextCursor(NPCParms)
    COM_BeginParseSession(String(NPCFile))

    // look for the right NPC
    while !p.isNull {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            return
        }

        if Q_stricmp(token, spawner.NPC_type!) == 0 {
            break
        }

        SkipBracedSection(&p)
    }

    if p.isNull {
        return
    }

    if BG_ParseLiteral(&p, "{") {
        return
    }

    // parse the NPC info block
    while 1 != 0 {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing '%s'\n", spawner.NPC_type!)
            return
        }

        if Q_stricmp(token, "}") == 0 {
            break
        }

        // headmodel
        if Q_stricmp(token, "headmodel") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }

            if Q_stricmp("none", value) == 0 {
            } else {
                //Q_strncpyz( ri.headModelName, value, sizeof(ri.headModelName), qtrue);
            }
            md3Model = true
            continue
        }

        // torsomodel
        if Q_stricmp(token, "torsomodel") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }

            if Q_stricmp("none", value) == 0 {
            } else {
                //Q_strncpyz( ri.torsoModelName, value, sizeof(ri.torsoModelName), qtrue);
            }
            md3Model = true
            continue
        }

        // legsmodel
        if Q_stricmp(token, "legsmodel") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            //Q_strncpyz( ri.legsModelName, value, sizeof(ri.legsModelName), qtrue);
            md3Model = true
            continue
        }

        // playerModel
        if Q_stricmp(token, "playerModel") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            Q_strncpyz(&playerModel, value, Int32((playerModel).count))
            md3Model = false
            continue
        }

        // customSkin
        if Q_stricmp(token, "customSkin") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            Q_strncpyz(&customSkin, value, Int32((customSkin).count))
            continue
        }

        // playerTeam
        if Q_stricmp(token, "playerTeam") == 0 {
            var tk = CharBuf(4096)

            if COM_ParseString(&p, &value) {
                continue
            }
            //playerTeam = TranslateTeamName(value);
            Com_sprintf(&tk, Int32((tk).count), "NPC%s", token)
            // Port-note: Raven passes `TeamTable` to `GetIDForString`, whose `table` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
            // Raven wrote: playerTeam = (team_t)GetIDForString( TeamTable, tk )
            portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
            continue
        }


        // snd
        if Q_stricmp(token, "snd") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            if !((spawner.r.svFlags & SVF_NO_BASIC_SOUNDS) != 0) {
                //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                Q_strncpyz(&sound, value, Int32((sound).count))
                // Port-note: A store into `patch`, a local the draft left as a hole.
                // Raven wrote: patch = strstr( sound, "/" )
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                // Port-note: A read of `patch`, a local the draft left as a hole.
                // Raven wrote: if ( patch ) { *patch = 0; }
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                spawner.s.csSounds_Std = G_SoundIndex(va("*$%s", sound))
            }
            continue
        }

        // sndcombat
        if Q_stricmp(token, "sndcombat") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            if !((spawner.r.svFlags & SVF_NO_COMBAT_SOUNDS) != 0) {
                //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                Q_strncpyz(&sound, value, Int32((sound).count))
                // Port-note: A store into `patch`, a local the draft left as a hole.
                // Raven wrote: patch = strstr( sound, "/" )
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                // Port-note: A read of `patch`, a local the draft left as a hole.
                // Raven wrote: if ( patch ) { *patch = 0; }
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                spawner.s.csSounds_Combat = G_SoundIndex(va("*$%s", sound))
            }
            continue
        }

        // sndextra
        if Q_stricmp(token, "sndextra") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            if !((spawner.r.svFlags & SVF_NO_EXTRA_SOUNDS) != 0) {
                //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                Q_strncpyz(&sound, value, Int32((sound).count))
                // Port-note: A store into `patch`, a local the draft left as a hole.
                // Raven wrote: patch = strstr( sound, "/" )
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                // Port-note: A read of `patch`, a local the draft left as a hole.
                // Raven wrote: if ( patch ) { *patch = 0; }
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                spawner.s.csSounds_Extra = G_SoundIndex(va("*$%s", sound))
            }
            continue
        }

        // sndjedi
        if Q_stricmp(token, "sndjedi") == 0 {
            if COM_ParseString(&p, &value) {
                continue
            }
            if !((spawner.r.svFlags & SVF_NO_EXTRA_SOUNDS) != 0) {
                //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                Q_strncpyz(&sound, value, Int32((sound).count))
                // Port-note: A store into `patch`, a local the draft left as a hole.
                // Raven wrote: patch = strstr( sound, "/" )
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                // Port-note: A read of `patch`, a local the draft left as a hole.
                // Raven wrote: if ( patch ) { *patch = 0; }
                portMissing("NPC_Precache", source: "oracle/codemp/game/NPC_stats.c:599")
                spawner.s.csSounds_Jedi = G_SoundIndex(va("*$%s", sound))
            }
            continue
        }

        if Q_stricmp(token, "weapon") == 0 {
            var curWeap: Int32

            if COM_ParseString(&p, &value) {
                continue
            }

            curWeap = GetIDForString(WPTable, value)

            if curWeap > WP_NONE && curWeap < WP_NUM_WEAPONS {
                RegisterItem(BG_FindItemForWeapon(weapon_t(curWeap))!)
            }
            continue
        }
    }

    // If we're not a vehicle, then an error here would be valid...
    if spawner.client == nil || spawner.client!.NPC_class != CLASS_VEHICLE {
        if md3Model {
            Com_Printf("MD3 model using NPCs are not supported in MP\n")
        } else {
            //if we have a model/skin then index them so they'll be registered immediately
            //when the client gets a configstring update.
            var modelName = CharBuf(64)

            Com_sprintf(&modelName, Int32((modelName).count), "models/players/%s/model.glm", playerModel)
            if customSkin[0] != 0 {
                //append it after a *
                strcat(&modelName, va("*%s", customSkin))
            }

            G_ModelIndex(String(modelName))
        }
    }

    //precache this NPC's possible weapons
    NPC_PrecacheWeapons(playerTeam, spawner.spawnflags, spawner.NPC_type!)

    //	CG_RegisterNPCCustomSounds( &ci );
    //	CG_RegisterNPCEffects( playerTeam );
    //rwwFIXMEFIXME: same
    //FIXME: Look for a "sounds" directory and precache death, pain, alert sounds
}

/// Source: oracle/codemp/game/NPC_stats.c:974
func NPC_ParseParms(_ NPCName: String, _ NPC: Entity) -> Bool {
    var token: String
    var value: String = ""
    var p = TextCursor()
    var n: Int32 = 0
    var f: Float = 0
    // Port-note: A pointer local `char * patch` with no view.
    // Raven wrote: char *patch;
    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
    var sound = CharBuf(64)
    var playerModel = CharBuf(64)
    var customSkin = CharBuf(64)
    let ri: RenderInfo? = NPC.client!.renderInfo
    var stats: GNPCstats? = nil
    var md3Model: Bool = true
    var surfOff = CharBuf(1024)
    var surfOn = CharBuf(1024)
    var parsingPlayer: Bool = false
    var playerMins = vec3_t()
    var playerMaxs = vec3_t()
    var npcSaber1: Int32 = 0
    var npcSaber2: Int32 = 0
    // Raven steps his own `NPCName` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var NPCName = TextCursor(CharBuf(NPCName))

    playerMins = vec3_t(-15, -15, Float(DEFAULT_MINS_2))
    playerMaxs = vec3_t(15, 15, Float(DEFAULT_MAXS_2))

    strcpy(&customSkin, "default")
    if NPCName[0] == 0 {
        NPCName = TextCursor("Player")
    }

    if NPC.s.number == 0 && NPC.client != nil {
        //player, only want certain data
        parsingPlayer = true
    }

    if NPC.NPC != nil {
        stats = NPC.NPC!.stats
        /*
        NPC->NPC->allWeaponOrder[0]	= WP_BRYAR_PISTOL;
        NPC->NPC->allWeaponOrder[1]	= WP_SABER;
        NPC->NPC->allWeaponOrder[2]	= WP_IMOD;
        NPC->NPC->allWeaponOrder[3]	= WP_SCAVENGER_RIFLE;
        NPC->NPC->allWeaponOrder[4]	= WP_TRICORDER;
        NPC->NPC->allWeaponOrder[6]	= WP_NONE;
        NPC->NPC->allWeaponOrder[6]	= WP_NONE;
        NPC->NPC->allWeaponOrder[7]	= WP_NONE;
        */
        // fill in defaults
        stats!.aggression = 3
        stats!.aim = 3
        stats!.earshot = 1024
        stats!.evasion = 3
        stats!.hfov = 90
        stats!.intelligence = 3
        stats!.move = 3
        stats!.reactions = 3
        stats!.vfov = 60
        stats!.vigilance = 0.1
        stats!.visrange = 1024

        stats!.health = 0

        stats!.yawSpeed = 90
        stats!.walkSpeed = 90
        stats!.runSpeed = 300
        stats!.acceleration = 15 //Increase/descrease speed this much per frame (20fps)
    } else {
        stats = nil
    }

    //Set defaults
    //FIXME: should probably put default torso and head models, but what about enemies
    //that don't have any- like Stasis?
    //Q_strncpyz( ri->headModelName,	DEFAULT_HEADMODEL,  sizeof(ri->headModelName),	qtrue);
    //Q_strncpyz( ri->torsoModelName, DEFAULT_TORSOMODEL, sizeof(ri->torsoModelName),	qtrue);
    //Q_strncpyz( ri->legsModelName,	DEFAULT_LEGSMODEL,  sizeof(ri->legsModelName),	qtrue);
    //FIXME: should we have one for weapon too?
    surfOff.zero()
    surfOn.zero()

    /*
    ri->headYawRangeLeft = 50;
    ri->headYawRangeRight = 50;
    ri->headPitchRangeUp = 40;
    ri->headPitchRangeDown = 50;
    ri->torsoYawRangeLeft = 60;
    ri->torsoYawRangeRight = 60;
    ri->torsoPitchRangeUp = 30;
    ri->torsoPitchRangeDown = 70;
    */

    ri!.headYawRangeLeft = 80
    ri!.headYawRangeRight = 80
    ri!.headPitchRangeUp = 45
    ri!.headPitchRangeDown = 45
    ri!.torsoYawRangeLeft = 60
    ri!.torsoYawRangeRight = 60
    ri!.torsoPitchRangeUp = 30
    ri!.torsoPitchRangeDown = 50

    NPC.r.mins = playerMins
    NPC.r.maxs = playerMaxs
    NPC.client!.ps.crouchheight = CROUCH_MAXS_2
    NPC.client!.ps.standheight = DEFAULT_MAXS_2

    //rwwFIXMEFIXME: ...
    /*
    NPC->client->moveType		= MT_RUNJUMP;

    NPC->client->dismemberProbHead = 100;
    NPC->client->dismemberProbArms = 100;
    NPC->client->dismemberProbHands = 100;
    NPC->client->dismemberProbWaist = 100;
    NPC->client->dismemberProbLegs = 100;

    NPC->s.modelScale[0] = NPC->s.modelScale[1] = NPC->s.modelScale[2] = 1.0f;
    */

    NPC.client!.ps.customRGBA[0] = 255
    NPC.client!.ps.customRGBA[1] = 255
    NPC.client!.ps.customRGBA[2] = 255
    NPC.client!.ps.customRGBA[3] = 255

    if Q_stricmp("random", NPCName.text) == 0 {
        //Randomly assemble a starfleet guy
        //NPC_BuildRandom( NPC );
        Com_Printf("RANDOM NPC NOT SUPPORTED IN MP\n")
        return false
    } else {
        var fp: Int32

        p = TextCursor(NPCParms)
        COM_BeginParseSession(String(NPCFile))

        // look for the right NPC
        while !p.isNull {
            token = COM_ParseExt(&p, true)
            if token.isEmpty {
                return false
            }

            if Q_stricmp(token, NPCName.text) == 0 {
                break
            }

            SkipBracedSection(&p)
        }
        if p.isNull {
            return false
        }

        if BG_ParseLiteral(&p, "{") {
            return false
        }

        // parse the NPC info block
        while 1 != 0 {
            token = COM_ParseExt(&p, true)
            if token.isEmpty {
                Com_Printf(S_COLOR_RED + "ERROR: unexpected EOF while parsing '%s'\n", NPCName.text)
                return false
            }

            if Q_stricmp(token, "}") == 0 {
                break
            }
            //===MODEL PROPERTIES===========================================================
            // custom color
            if Q_stricmp(token, "customRGBA") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if Q_stricmp(value, "random") == 0 {
                    NPC.client!.ps.customRGBA[0] = Q_irand(0, 255)
                    NPC.client!.ps.customRGBA[1] = Q_irand(0, 255)
                    NPC.client!.ps.customRGBA[2] = Q_irand(0, 255)
                    NPC.client!.ps.customRGBA[3] = 255
                } else {
                    NPC.client!.ps.customRGBA[0] = atoi(value)

                    if COM_ParseInt(&p, &n) {
                        continue
                    }
                    NPC.client!.ps.customRGBA[1] = n

                    if COM_ParseInt(&p, &n) {
                        continue
                    }
                    NPC.client!.ps.customRGBA[2] = n

                    if COM_ParseInt(&p, &n) {
                        continue
                    }
                    NPC.client!.ps.customRGBA[3] = n
                }
                continue
            }

            // headmodel
            if Q_stricmp(token, "headmodel") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }

                if Q_stricmp("none", value) == 0 {
                    //Zero the head clamp range so the torso & legs don't lag behind
                    ri!.headPitchRangeDown = 0
                    ri!.headPitchRangeUp = ri!.headPitchRangeDown
                    ri!.headYawRangeRight = ri!.headPitchRangeUp
                    ri!.headYawRangeLeft = ri!.headYawRangeRight
                }
                continue
            }

            // torsomodel
            if Q_stricmp(token, "torsomodel") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }

                if Q_stricmp("none", value) == 0 {
                    //Zero the torso clamp range so the legs don't lag behind
                    ri!.torsoPitchRangeDown = 0
                    ri!.torsoPitchRangeUp = ri!.torsoPitchRangeDown
                    ri!.torsoYawRangeRight = ri!.torsoPitchRangeUp
                    ri!.torsoYawRangeLeft = ri!.torsoYawRangeRight
                }
                continue
            }

            // legsmodel
            if Q_stricmp(token, "legsmodel") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                /*
                Q_strncpyz( ri->legsModelName, value, sizeof(ri->legsModelName), qtrue);
                //Need to do this here to get the right index
                G_ParseAnimFileSet( ri->legsModelName, ri->legsModelName, &ci->animFileIndex );
                */
                continue
            }

            // playerModel
            if Q_stricmp(token, "playerModel") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                Q_strncpyz(&playerModel, value, Int32((playerModel).count))
                md3Model = false
                continue
            }

            // customSkin
            if Q_stricmp(token, "customSkin") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                Q_strncpyz(&customSkin, value, Int32((customSkin).count))
                continue
            }

            // surfOff
            if Q_stricmp(token, "surfOff") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if surfOff[0] != 0 {
                    Q_strcat(&surfOff, Int32((surfOff).count), ",")
                    Q_strcat(&surfOff, Int32((surfOff).count), value)
                } else {
                    Q_strncpyz(&surfOff, value, Int32((surfOff).count))
                }
                continue
            }

            // surfOn
            if Q_stricmp(token, "surfOn") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if surfOn[0] != 0 {
                    Q_strcat(&surfOn, Int32((surfOn).count), ",")
                    Q_strcat(&surfOn, Int32((surfOn).count), value)
                } else {
                    Q_strncpyz(&surfOn, value, Int32((surfOn).count))
                }
                continue
            }

            //headYawRangeLeft
            if Q_stricmp(token, "headYawRangeLeft") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.headYawRangeLeft = n
                continue
            }

            //headYawRangeRight
            if Q_stricmp(token, "headYawRangeRight") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.headYawRangeRight = n
                continue
            }

            //headPitchRangeUp
            if Q_stricmp(token, "headPitchRangeUp") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.headPitchRangeUp = n
                continue
            }

            //headPitchRangeDown
            if Q_stricmp(token, "headPitchRangeDown") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.headPitchRangeDown = n
                continue
            }

            //torsoYawRangeLeft
            if Q_stricmp(token, "torsoYawRangeLeft") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.torsoYawRangeLeft = n
                continue
            }

            //torsoYawRangeRight
            if Q_stricmp(token, "torsoYawRangeRight") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.torsoYawRangeRight = n
                continue
            }

            //torsoPitchRangeUp
            if Q_stricmp(token, "torsoPitchRangeUp") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.torsoPitchRangeUp = n
                continue
            }

            //torsoPitchRangeDown
            if Q_stricmp(token, "torsoPitchRangeDown") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                ri!.torsoPitchRangeDown = n
                continue
            }

            // Uniform XYZ scale
            if Q_stricmp(token, "scale") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if n != 100 {
                    NPC.client!.ps.iModelScale = n //so the client knows
                    if n >= 1024 {
                        Com_Printf("WARNING: MP does not support scaling up to or over 1024%\n")
                        n = 1023
                    }

                    NPC.modelScale[2] = n / 100.0
                    NPC.modelScale[1] = NPC.modelScale[2]
                    NPC.modelScale[0] = NPC.modelScale[1]
                }
                continue
            }

            //X scale
            if Q_stricmp(token, "scaleX") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if n != 100 {
                    Com_Printf("MP doesn't support xyz scaling, use 'scale'.\n")
                    //NPC->s.modelScale[0] = n/100.0f;
                }
                continue
            }

            //Y scale
            if Q_stricmp(token, "scaleY") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if n != 100 {
                    Com_Printf("MP doesn't support xyz scaling, use 'scale'.\n")
                    //NPC->s.modelScale[1] = n/100.0f;
                }
                continue
            }

            //Z scale
            if Q_stricmp(token, "scaleZ") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if n != 100 {
                    Com_Printf("MP doesn't support xyz scaling, use 'scale'.\n")
                    //	NPC->s.modelScale[2] = n/100.0f;
                }
                continue
            }

            //===AI STATS=====================================================================
            if !parsingPlayer {
                // aggression
                if Q_stricmp(token, "aggression") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 1 || n > 5 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.aggression = n
                    }
                    continue
                }

                // aim
                if Q_stricmp(token, "aim") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 1 || n > 5 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.aim = n
                    }
                    continue
                }

                // earshot
                if Q_stricmp(token, "earshot") == 0 {
                    if COM_ParseFloat(&p, &f) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if f < 0.0 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.earshot = f
                    }
                    continue
                }

                // evasion
                if Q_stricmp(token, "evasion") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 1 || n > 5 {
                        Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.evasion = n
                    }
                    continue
                }

                // hfov
                if Q_stricmp(token, "hfov") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 30 || n > 180 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.hfov = n // / 2;	//FIXME: Why was this being done?!
                    }
                    continue
                }

                // intelligence
                if Q_stricmp(token, "intelligence") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 1 || n > 5 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.intelligence = n
                    }
                    continue
                }

                // move
                if Q_stricmp(token, "move") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 1 || n > 5 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.move = n
                    }
                    continue
                }

                // reactions
                if Q_stricmp(token, "reactions") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 1 || n > 5 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.reactions = n
                    }
                    continue
                }

                // shootDistance
                if Q_stricmp(token, "shootDistance") == 0 {
                    if COM_ParseFloat(&p, &f) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if f < 0.0 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.shootDistance = f
                    }
                    continue
                }

                // vfov
                if Q_stricmp(token, "vfov") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 30 || n > 180 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.vfov = n / 2
                    }
                    continue
                }

                // vigilance
                if Q_stricmp(token, "vigilance") == 0 {
                    if COM_ParseFloat(&p, &f) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if f < 0.0 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.vigilance = f
                    }
                    continue
                }

                // visrange
                if Q_stricmp(token, "visrange") == 0 {
                    if COM_ParseFloat(&p, &f) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if f < 0.0 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.visrange = f
                    }
                    continue
                }

                // race
                //		if ( !Q_stricmp( token, "race" ) )
                //		{
                //			if ( COM_ParseString( &p, &value ) )
                //			{
                //				continue;
                //			}
                //			NPC->client->race = TranslateRaceName(value);
                //			continue;
                //		}

                // rank
                if Q_stricmp(token, "rank") == 0 {
                    if COM_ParseString(&p, &value) {
                        continue
                    }
                    if NPC.NPC != nil {
                        NPC.NPC!.rank = TranslateRankName(value)
                    }
                    continue
                }
            }

            // health
            if Q_stricmp(token, "health") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if NPC.NPC != nil {
                    stats!.health = n
                } else if parsingPlayer {
                    NPC.client!.pers.maxHealth = n
                    NPC.client!.ps.stats[STAT_MAX_HEALTH] = NPC.client!.pers.maxHealth
                }
                continue
            }

            // fullName
            if Q_stricmp(token, "fullName") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                NPC.fullName = G_NewString(value)
                continue
            }

            // playerTeam
            if Q_stricmp(token, "playerTeam") == 0 {
                var tk = CharBuf(4096)

                if COM_ParseString(&p, &value) {
                    continue
                }
                Com_sprintf(&tk, Int32((tk).count), "NPC%s", token)
                // Port-note: Raven passes `TeamTable` to `GetIDForString`, whose `table` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
                // Raven wrote: NPC->client->playerTeam = NPC->s.teamowner = (team_t)GetIDForString( TeamTable, tk )
                portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                continue
            }

            // enemyTeam
            if Q_stricmp(token, "enemyTeam") == 0 {
                var tk = CharBuf(4096)

                if COM_ParseString(&p, &value) {
                    continue
                }
                Com_sprintf(&tk, Int32((tk).count), "NPC%s", token)
                // Port-note: Raven passes `TeamTable` to `GetIDForString`, whose `table` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
                // Raven wrote: NPC->client->enemyTeam = (team_t)GetIDForString( TeamTable, tk )
                portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                continue
            }

            // class
            if Q_stricmp(token, "class") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                // Port-note: Raven passes `ClassTable` to `GetIDForString`, whose `table` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
                // Raven wrote: NPC->client->NPC_class = (class_t)GetIDForString( ClassTable, value )
                portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                NPC.s.NPC_class = NPC.client!.NPC_class //we actually only need this value now, but at the moment I don't feel like changing the 200+ references to client->NPC_class.

                // No md3's for vehicles.
                if NPC.client!.NPC_class == CLASS_VEHICLE {
                    if NPC.m_pVehicle == nil {
                        //you didn't spawn this guy right!
                        Com_Printf(S_COLOR_RED + "ERROR: Tried to spawn a vehicle NPC (%s) without using NPC_Vehicle or 'NPC spawn vehicle <vehiclename>'!!!  Bad, bad, bad!  Shame on you!\n", NPCName.text)
                        return false
                    }
                    md3Model = false
                }

                continue
            }

            // dismemberment probability for head
            if Q_stricmp(token, "dismemberProbHead") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if NPC.NPC != nil {
                    //	NPC->client->dismemberProbHead = n;
                    //rwwFIXMEFIXME: support for this?
                }
                continue
            }

            // dismemberment probability for arms
            if Q_stricmp(token, "dismemberProbArms") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if NPC.NPC != nil {
                    //	NPC->client->dismemberProbArms = n;
                }
                continue
            }

            // dismemberment probability for hands
            if Q_stricmp(token, "dismemberProbHands") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if NPC.NPC != nil {
                    //	NPC->client->dismemberProbHands = n;
                }
                continue
            }

            // dismemberment probability for waist
            if Q_stricmp(token, "dismemberProbWaist") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if NPC.NPC != nil {
                    //	NPC->client->dismemberProbWaist = n;
                }
                continue
            }

            // dismemberment probability for legs
            if Q_stricmp(token, "dismemberProbLegs") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                if n < 0 {
                    Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                    continue
                }
                if NPC.NPC != nil {
                    //	NPC->client->dismemberProbLegs = n;
                }
                continue
            }

            //===MOVEMENT STATS============================================================

            if Q_stricmp(token, "width") == 0 {
                if COM_ParseInt(&p, &n) {
                    continue
                }

                NPC.r.mins[1] = Float(-n)
                NPC.r.mins[0] = NPC.r.mins[1]
                NPC.r.maxs[1] = Float(n)
                NPC.r.maxs[0] = NPC.r.maxs[1]
                continue
            }

            if Q_stricmp(token, "height") == 0 {
                if COM_ParseInt(&p, &n) {
                    continue
                }
                if NPC.client!.NPC_class == CLASS_VEHICLE && NPC.m_pVehicle != nil && NPC.m_pVehicle!.m_pVehicleInfo != nil && NPC.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                    //a flying vehicle's origin must be centered in bbox and it should spawn on the ground
                    //trace_t		tr;
                    //vec3_t		bottom;
                    //float		adjust = 32.0f;
                    NPC.client!.ps.standheight = Int32((n / 2.0))
                    NPC.r.maxs[2] = Float(NPC.client!.ps.standheight)
                    NPC.r.mins[2] = -NPC.r.maxs[2]
                    NPC.s.origin[2] += (DEFAULT_MINS_2 - NPC.r.mins[2]) + 0.125
                    NPC.client!.ps.origin = NPC.s.origin
                    NPC.r.currentOrigin = NPC.s.origin
                    G_SetOrigin(NPC, &NPC.s.origin)
                    trap_LinkEntity(NPC)
                    //now trace down
                    /*
                    VectorCopy( NPC->s.origin, bottom );
                    bottom[2] -= adjust;
                    trap_Trace( &tr, NPC->s.origin, NPC->r.mins, NPC->r.maxs, bottom, NPC->s.number, MASK_NPCSOLID );
                    if ( !tr.allsolid && !tr.startsolid )
                    {
                    G_SetOrigin( NPC, tr.endpos );
                    trap_LinkEntity(NPC);
                    }
                    */
                } else {
                    NPC.r.mins[2] = Float(DEFAULT_MINS_2) //Cannot change
                    NPC.client!.ps.standheight = n + DEFAULT_MINS_2
                    NPC.r.maxs[2] = Float(NPC.client!.ps.standheight)
                }
                NPC.radius = Float(n)
                continue
            }

            if Q_stricmp(token, "crouchheight") == 0 {
                if COM_ParseInt(&p, &n) {
                    continue
                }

                NPC.client!.ps.crouchheight = n + DEFAULT_MINS_2
                continue
            }

            if !parsingPlayer {
                if Q_stricmp(token, "movetype") == 0 {
                    if COM_ParseString(&p, &value) {
                        continue
                    }
                    if Q_stricmp("flyswim", value) == 0 {
                        NPC.client!.ps.eFlags2 |= EF2_FLYING
                    }
                    //NPC->client->moveType = (movetype_t)MoveTypeNameToEnum(value);
                    //rwwFIXMEFIXME: support for movetypes
                    continue
                }

                // yawSpeed
                if Q_stricmp(token, "yawSpeed") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n <= 0 {
                        Com_Printf("bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.yawSpeed = (Float((n)))
                    }
                    continue
                }

                // walkSpeed
                if Q_stricmp(token, "walkSpeed") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 0 {
                        Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.walkSpeed = n
                    }
                    continue
                }

                //runSpeed
                if Q_stricmp(token, "runSpeed") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 0 {
                        Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.runSpeed = n
                    }
                    continue
                }

                //acceleration
                if Q_stricmp(token, "acceleration") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < 0 {
                        Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        stats!.acceleration = n
                    }
                    continue
                }
                //sex - skip in MP
                if Q_stricmp(token, "sex") == 0 {
                    SkipRestOfLine(&p)
                    continue
                }
                //===MISC===============================================================================
                // default behavior
                if Q_stricmp(token, "behavior") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if n < BS_DEFAULT || n >= NUM_BSTATES {
                        Com_Printf(S_COLOR_YELLOW + "WARNING: bad %s in NPC '%s'\n", token, NPCName.text)
                        continue
                    }
                    if NPC.NPC != nil {
                        NPC.NPC!.defaultBehavior = bState_t((n))
                    }
                    continue
                }
            }

            // snd
            if Q_stricmp(token, "snd") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if !((NPC.r.svFlags & SVF_NO_BASIC_SOUNDS) != 0) {
                    //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                    Q_strncpyz(&sound, value, Int32((sound).count))
                    // Port-note: A store into `patch`, a local the draft left as a hole.
                    // Raven wrote: patch = strstr( sound, "/" )
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    // Port-note: A read of `patch`, a local the draft left as a hole.
                    // Raven wrote: if ( patch ) { *patch = 0; }
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    //	ci->customBasicSoundDir = G_NewString( sound );
                    //rwwFIXMEFIXME: Hooray for violating client server rules
                }
                continue
            }

            // sndcombat
            if Q_stricmp(token, "sndcombat") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if !((NPC.r.svFlags & SVF_NO_COMBAT_SOUNDS) != 0) {
                    //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                    Q_strncpyz(&sound, value, Int32((sound).count))
                    // Port-note: A store into `patch`, a local the draft left as a hole.
                    // Raven wrote: patch = strstr( sound, "/" )
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    // Port-note: A read of `patch`, a local the draft left as a hole.
                    // Raven wrote: if ( patch ) { *patch = 0; }
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    //	ci->customCombatSoundDir = G_NewString( sound );
                }
                continue
            }

            // sndextra
            if Q_stricmp(token, "sndextra") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if !((NPC.r.svFlags & SVF_NO_EXTRA_SOUNDS) != 0) {
                    //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                    Q_strncpyz(&sound, value, Int32((sound).count))
                    // Port-note: A store into `patch`, a local the draft left as a hole.
                    // Raven wrote: patch = strstr( sound, "/" )
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    // Port-note: A read of `patch`, a local the draft left as a hole.
                    // Raven wrote: if ( patch ) { *patch = 0; }
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    //	ci->customExtraSoundDir = G_NewString( sound );
                }
                continue
            }

            // sndjedi
            if Q_stricmp(token, "sndjedi") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if !((NPC.r.svFlags & SVF_NO_EXTRA_SOUNDS) != 0) {
                    //FIXME: store this in some sound field or parse in the soundTable like the animTable...
                    Q_strncpyz(&sound, value, Int32((sound).count))
                    // Port-note: A store into `patch`, a local the draft left as a hole.
                    // Raven wrote: patch = strstr( sound, "/" )
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    // Port-note: A read of `patch`, a local the draft left as a hole.
                    // Raven wrote: if ( patch ) { *patch = 0; }
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    //ci->customJediSoundDir = G_NewString( sound );
                }
                continue
            }

            //New NPC/jedi stats:
            //starting weapon
            if Q_stricmp(token, "weapon") == 0 {
                var weap: Int32

                if COM_ParseString(&p, &value) {
                    continue
                }
                //FIXME: need to precache the weapon, too?  (in above func)
                weap = GetIDForString(WPTable, value)
                if weap >= WP_NONE && weap <= WP_NUM_WEAPONS {
                    NPC.client!.ps.weapon = weap
                    NPC.client!.ps.stats[STAT_WEAPONS] |= (1 << NPC.client!.ps.weapon)
                    if weap > WP_NONE {
                        //	RegisterItem( FindItemForWeapon( (weapon_t)(NPC->client->ps.weapon) ) );	//precache the weapon
                        NPC.client!.ps.ammo[weaponData[NPC.client!.ps.weapon].ammoIndex] = 100 //FIXME: max ammo!
                    }
                }
                continue
            }

            if !parsingPlayer {
                //altFire
                if Q_stricmp(token, "altFire") == 0 {
                    if COM_ParseInt(&p, &n) {
                        SkipRestOfLine(&p)
                        continue
                    }
                    if NPC.NPC != nil {
                        if n != 0 {
                            NPC.NPC!.scriptFlags |= SCF_ALT_FIRE
                        }
                    }
                    continue
                }
                //Other unique behaviors/numbers that are currently hardcoded?
            }

            //force powers
            fp = GetIDForString(FPTable, token)
            if fp >= FP_FIRST && fp < NUM_FORCE_POWERS {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                //FIXME: need to precache the fx, too?  (in above func)
                //cap
                if n > 5 {
                    n = 5
                } else if n < 0 {
                    n = 0
                }
                if n != 0 {
                    //set
                    NPC.client!.ps.fd.forcePowersKnown |= (1 << fp)
                } else {
                    //clear
                    NPC.client!.ps.fd.forcePowersKnown &= ~(1 << fp)
                }
                NPC.client!.ps.fd.forcePowerLevel[fp] = n
                continue
            }

            //max force power
            if Q_stricmp(token, "forcePowerMax") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                NPC.client!.ps.fd.forcePowerMax = n
                continue
            }

            //force regen rate - default is 100ms
            if Q_stricmp(token, "forceRegenRate") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                //NPC->client->ps.forcePowerRegenRate = n;
                //rwwFIXMEFIXME: support this?
                continue
            }

            //force regen amount - default is 1 (points per second)
            if Q_stricmp(token, "forceRegenAmount") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                //NPC->client->ps.forcePowerRegenAmount = n;
                //rwwFIXMEFIXME: support this?
                continue
            }

            //have a sabers.cfg and just name your saber in your NPCs.cfg/ICARUS script
            //saber name
            if Q_stricmp(token, "saber") == 0 {
                var saberName: UnsafeMutableRawPointer

                if COM_ParseString(&p, &value) {
                    continue
                }

                saberName = BG_TempAlloc(4096) //G_NewString( value );
                strcpy(saberName, value)

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'String'".
                // Raven wrote: WP_SaberParseParms( saberName, &NPC->client->saber[0] )
                portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "argument type 'UnsafeMutableRawPointer' does not conform to expected type 'FormatArg'".
                // Raven wrote: npcSaber1 = G_ModelIndex(va("@%s", saberName))
                portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")

                BG_TempFree(4096)
                continue
            }

            //second saber name
            if Q_stricmp(token, "saber2") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }

                if !((NPC.client!.saber[0].saberFlags & SFL_TWO_HANDED) != 0) {
                    //can't use a second saber if first one is a two-handed saber...?
                    var saberName: UnsafeMutableRawPointer = BG_TempAlloc(4096)
                    strcpy(saberName, value)

                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'String'".
                    // Raven wrote: WP_SaberParseParms( saberName, &NPC->client->saber[1] )
                    portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    if (NPC.client!.saber[1].saberFlags & SFL_TWO_HANDED) != 0 {
                        //tsk tsk, can't use a twoHanded saber as second saber
                        // Port-note: Raven passes `NPC->client->saber` to `WP_RemoveSaber`, whose `sabers` parameter takes the Slots over the records, and Swift holds one record here. A Slots over one record has no form yet.
                        // Raven wrote: WP_RemoveSaber( NPC->client->saber, 1 )
                        portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    } else {
                        //NPC->client->ps.dualSabers = qtrue;
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "argument type 'UnsafeMutableRawPointer' does not conform to expected type 'FormatArg'".
                        // Raven wrote: npcSaber2 = G_ModelIndex(va("@%s", saberName))
                        portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
                    }
                    BG_TempFree(4096)
                }
                continue
            }

            // saberColor
            if Q_stricmp(token, "saberColor") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    let color: saber_colors_t = TranslateSaberColor(value)
                    n = 0
                    while n < MAX_BLADES {
                        NPC.client!.saber[0].blade[n].color = color
                        n += 1
                    }
                }
                continue
            }

            if Q_stricmp(token, "saberColor2") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[1].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saberColor3") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[2].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saberColor4") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[3].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saberColor5") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[4].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saberColor6") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[5].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saberColor7") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[6].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saberColor8") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[0].blade[7].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    let color: saber_colors_t = TranslateSaberColor(value)
                    n = 0
                    while n < MAX_BLADES {
                        NPC.client!.saber[1].blade[n].color = color
                        n += 1
                    }
                }
                continue
            }

            if Q_stricmp(token, "saber2Color2") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[1].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color3") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[2].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color4") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[3].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color5") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[4].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color6") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[5].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color7") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[6].color = TranslateSaberColor(value)
                }
                continue
            }

            if Q_stricmp(token, "saber2Color8") == 0 {
                if COM_ParseString(&p, &value) {
                    continue
                }
                if NPC.client != nil {
                    NPC.client!.saber[1].blade[7].color = TranslateSaberColor(value)
                }
                continue
            }

            //saber length
            if Q_stricmp(token, "saberLength") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }

                n = 0
                while n < MAX_BLADES {
                    NPC.client!.saber[0].blade[n].lengthMax = f
                    n += 1
                }
                continue
            }

            if Q_stricmp(token, "saberLength2") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[1].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saberLength3") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[2].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saberLength4") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[3].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saberLength5") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[4].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saberLength6") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[5].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saberLength7") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[6].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saberLength8") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[0].blade[7].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                n = 0
                while n < MAX_BLADES {
                    NPC.client!.saber[1].blade[n].lengthMax = f
                    n += 1
                }
                continue
            }

            if Q_stricmp(token, "saber2Length2") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[1].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length3") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[2].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length4") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[3].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length5") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[4].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length6") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[5].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length7") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[6].lengthMax = f
                continue
            }

            if Q_stricmp(token, "saber2Length8") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 4.0 {
                    f = 4.0
                }
                NPC.client!.saber[1].blade[7].lengthMax = f
                continue
            }

            //saber radius
            if Q_stricmp(token, "saberRadius") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                n = 0
                while n < MAX_BLADES {
                    NPC.client!.saber[0].blade[n].radius = f
                    n += 1
                }
                continue
            }

            if Q_stricmp(token, "saberRadius2") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[1].radius = f
                continue
            }

            if Q_stricmp(token, "saberRadius3") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[2].radius = f
                continue
            }

            if Q_stricmp(token, "saberRadius4") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[3].radius = f
                continue
            }

            if Q_stricmp(token, "saberRadius5") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[4].radius = f
                continue
            }

            if Q_stricmp(token, "saberRadius6") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[5].radius = f
                continue
            }

            if Q_stricmp(token, "saberRadius7") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[6].radius = f
                continue
            }

            if Q_stricmp(token, "saberRadius8") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[0].blade[7].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                n = 0
                while n < MAX_BLADES {
                    NPC.client!.saber[1].blade[n].radius = f
                    n += 1
                }
                continue
            }

            if Q_stricmp(token, "saber2Radius2") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[1].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius3") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[2].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius4") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[3].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius5") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[4].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius6") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[5].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius7") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[6].radius = f
                continue
            }

            if Q_stricmp(token, "saber2Radius8") == 0 {
                if COM_ParseFloat(&p, &f) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if f < 0.25 {
                    f = 0.25
                }
                NPC.client!.saber[1].blade[7].radius = f
                continue
            }

            //ADD:
            //saber sounds (on, off, loop)
            //loop sound (like Vader's breathing or droid bleeps, etc.)

            //starting saber style
            if Q_stricmp(token, "saberStyle") == 0 {
                if COM_ParseInt(&p, &n) {
                    SkipRestOfLine(&p)
                    continue
                }
                //cap
                if n < 0 {
                    n = 0
                } else if n > 5 {
                    n = 5
                }
                NPC.client!.ps.fd.saberAnimLevel = n
                /*
                if ( parsingPlayer )
                {
                cg.saberAnimLevelPending = n;
                }
                */
                continue
            }

            if !parsingPlayer {
                Com_Printf("WARNING: unknown keyword '%s' while parsing '%s'\n", token, NPCName.text)
            }
            SkipRestOfLine(&p)
        }
    }

    /*
    Ghoul2 Insert Start
    */
    if !md3Model {
        var setTypeBack: Bool = false

        if npcSaber1 == 0 {
            //use "kyle" for a default then
            npcSaber1 = G_ModelIndex("@Kyle")
            WP_SaberParseParms("Kyle", NPC.client!.saber[0])
        }

        NPC.s.npcSaber1 = npcSaber1
        NPC.s.npcSaber2 = npcSaber2

        if customSkin[0] == 0 {
            strcpy(&customSkin, "default")
        }

        if NPC.client != nil && NPC.client!.NPC_class == CLASS_VEHICLE {
            //vehicles want their names fed in as models
            //we put the $ in front to indicate a name and not a model
            strcpy(&playerModel, va("$%s", NPCName.text))
        }
        SetupGameGhoul2Model(NPC, &playerModel, String(customSkin))

        if NPC.NPC_type == nil {
            //just do this for now so NPC_Precache can see the name.
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'TextCursor' to type 'String'".
            // Raven wrote: NPC->NPC_type = (char *)NPCName
            portMissing("NPC_ParseParms", source: "oracle/codemp/game/NPC_stats.c:974")
            setTypeBack = true
        }

        NPC_Precache(NPC) //this will just soundindex some values for sounds on the client,

        if setTypeBack {
            //don't want this being set if we aren't ready yet.
            NPC.NPC_type = nil
        }
    } else {
        Com_Printf("MD3 MODEL NPC'S ARE NOT SUPPORTED IN MP!\n")
        return false
    }
    /*
    Ghoul2 Insert End
    */
    /*
    if(	NPCsPrecached )
    {//Spawning in after initial precache, our models are precached, we just need to set our clientInfo
    CG_RegisterClientModels( NPC->s.number );
    CG_RegisterNPCCustomSounds( ci );
    CG_RegisterNPCEffects( NPC->client->playerTeam );
    }
    */
    //rwwFIXMEFIXME: Do something here I guess to properly precache stuff.

    return true
}

/// Source: oracle/codemp/game/NPC_stats.c:3241
func NPC_LoadParms() {
    var len: Int32
    var totallen: Int32
    var npcExtFNLen: Int32
    let mainBlockLen: Int32
    let fileCnt: Int32
    var i: Int32
    //	const char	*filename = "ext_data/NPC2.cfg";
    var holdChar = TextCursor()
    var marker: Int32 = 0
    var npcExtensionListBuf = CharBuf(2048)
    var f: fileHandle_t = 0
    len = 0

    //remember where to store the next one
    mainBlockLen = len
    totallen = mainBlockLen
    marker = totallen
    NPCParms[marker] = 0

    //now load in the extra .npc extensions
    let filled = trap_FS_GetFileList("ext_data/NPCs", ".npc", Int32((npcExtensionListBuf).count))
    fileCnt = filled.0
    npcExtensionListBuf = filled.1


    holdChar = TextCursor(npcExtensionListBuf)
    i = 0
    while i < fileCnt {
        npcExtFNLen = strlen(holdChar.text)

        //		Com_Printf( "Parsing %s\n", holdChar );

        len = trap_FS_FOpenFile(va("ext_data/NPCs/%s", holdChar.text), &f, FS_READ)

        if len == -1 {
            Com_Printf("error reading file\n")
        } else {
            if totallen + len >= MAX_NPC_DATA_SIZE {
                G_Error("NPC extensions (*.npc) are too large")
            }
            trap_FS_Read(&npcParseBuffer, len, f)
            npcParseBuffer[len] = 0

            len = COM_Compress(&npcParseBuffer)

            strcat(&NPCParms, npcParseBuffer, at: marker)
            strcat(&NPCParms, "\n", at: marker)
            len += 1
            trap_FS_FCloseFile(f)

            totallen += len
            marker = totallen
            //*marker = 0; //rww - make sure this is null or strcat will not append to the correct place
            //rww  12/19/02-actually the probelm was npcParseBuffer not being nul-term'd, which could cause issues in the strcat too
        }
        i += 1
        holdChar.advance(by: npcExtFNLen + 1)
    }
}
