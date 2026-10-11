import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_spawn.c:57
let NSF_DROP_TO_FLOOR = 16 as Int32

/// Source: oracle/codemp/game/NPC_spawn.c:1276
var gNPCPtrs: Slots<GNPC?> { world.storage.gNPCPtrs }

/// Source: oracle/codemp/game/NPC_spawn.c:1810
let SHY_THINK_TIME = 1000 as Int32

/// Source: oracle/codemp/game/NPC_spawn.c:1811
let SHY_SPAWN_DISTANCE = 128 as Int32

/// Source: oracle/codemp/game/NPC_spawn.c:1812
let SHY_SPAWN_DISTANCE_SQR = (SHY_SPAWN_DISTANCE * SHY_SPAWN_DISTANCE)

/// Source: oracle/codemp/game/NPC_spawn.c:4182
var showBBoxes: Bool {
    get { world.variables.showBBoxes }
    set { world.variables.showBBoxes = newValue }
}

/// Source: oracle/codemp/game/NPC_spawn.c:90
func WP_SetSaberModel(_ client: Client?, _ npcClass: JKAMP.class_t) -> Int32 {
    //rwwFIXMEFIXME: Do something here, need to let the client know.
    return 1
}

/// Source: oracle/codemp/game/NPC_spawn.c:103
func NPC_PainFunc(_ ent: Entity) -> EntityPain? {
    // Port-note: A pointer local `void (*)(gentity_t *, gentity_t *, int) func` with no view.
    // Raven wrote: void (*func)(gentity_t *self, gentity_t *attacker, int damage);
    portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

    if ent.client!.ps.weapon == WP_SABER {
        // Port-note: A store into `func`, a local the draft left as a hole.
        // Raven wrote: func = NPC_Jedi_Pain
        portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")
    } else {
        // team no longer indicates race/species, use NPC_class to determine different npc types
        /*
        switch ( ent->client->playerTeam )
        {
        default:
        func = painF_NPC_Pain;
        break;
        }
        */
        switch ent.client!.NPC_class {
        // troopers get special pain
        case CLASS_STORMTROOPER, CLASS_SWAMPTROOPER:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_ST_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_SEEKER:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Seeker_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_REMOTE:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Remote_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_MINEMONSTER:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_MineMonster_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_HOWLER:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Howler_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")
            // all other droids, did I miss any?

        case CLASS_GONK, CLASS_R2D2, CLASS_R5D2, CLASS_MOUSE, CLASS_PROTOCOL, CLASS_INTERROGATOR:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Droid_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_PROBE:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Probe_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_SENTRY:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Sentry_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_MARK1:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Mark1_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_MARK2:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Mark2_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_ATST:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_ATST_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_GALAKMECH:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_GM_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_RANCOR:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Rancor_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")

        case CLASS_WAMPA:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Wampa_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")
            // everyone else gets the normal pain func

        default:
            // Port-note: A store into `func`, a local the draft left as a hole.
            // Raven wrote: func = NPC_Pain
            portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")
        }
    }

    // Port-note: A read of `func`, a local the draft left as a hole.
    // Raven wrote: return func
    portMissing("NPC_PainFunc", source: "oracle/codemp/game/NPC_spawn.c:103")
}

/// Source: oracle/codemp/game/NPC_spawn.c:199
func NPC_TouchFunc(_ ent: Entity) -> EntityTouch? {
    // Port-note: A pointer local `void (*)(gentity_t *, gentity_t *, trace_t *) func` with no view.
    // Raven wrote: void (*func)(gentity_t *self, gentity_t *other, trace_t *trace);
    portMissing("NPC_TouchFunc", source: "oracle/codemp/game/NPC_spawn.c:199")

    // Port-note: A store into `func`, a local the draft left as a hole.
    // Raven wrote: func = NPC_Touch
    portMissing("NPC_TouchFunc", source: "oracle/codemp/game/NPC_spawn.c:199")

    // Port-note: A read of `func`, a local the draft left as a hole.
    // Raven wrote: return func
    portMissing("NPC_TouchFunc", source: "oracle/codemp/game/NPC_spawn.c:199")
}

/// Source: oracle/codemp/game/NPC_spawn.c:215
func NPC_SetMiscDefaultData(_ ent: Entity) {
    if (ent.spawnflags & SFB_CINEMATIC) != 0 {
        //if a cinematic guy, default us to wait bState
        ent.NPC!.behaviorState = BS_CINEMATIC
    }
    if ent.client!.NPC_class == CLASS_BOBAFETT {
        //set some stuff, precache
        Boba_Precache()
        ent.client!.ps.fd.forcePowersKnown |= (1 << FP_LEVITATION)
        ent.client!.ps.fd.forcePowerLevel[FP_LEVITATION] = FORCE_LEVEL_3
        ent.client!.ps.fd.forcePower = 100
        ent.NPC!.scriptFlags |= (SCF_ALT_FIRE | SCF_NO_GROUPS)
    }
    //if ( !Q_stricmp( "atst_vehicle", ent->NPC_type ) )//FIXME: has to be a better, easier way to tell this, no?
    if ent.s.NPC_class == CLASS_VEHICLE && ent.m_pVehicle != nil {
        ent.s.g2radius = 255 //MAX for this value, was (ent->r.maxs[2]-ent->r.mins[2]), which is 272 or something

        if ent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
            ent.mass = 2000 //???
            ent.flags |= (FL_SHIELDED | FL_NO_KNOCKBACK)
            ent.pain = Pain.NPC_ATST_Pain
        }
        //turn the damn hatch cover on and LEAVE it on
        trap_G2API_SetSurfaceOnOff(ent.ghoul2, "head_hatchcover", 0)
    }
    if Q_stricmp("wampa", ent.NPC_type!) == 0 {
        //FIXME: extern this into NPC.cfg?
        Wampa_SetBolts(ent)
        ent.s.g2radius = 80 //???
        ent.mass = 300 //???
        ent.flags |= FL_NO_KNOCKBACK
        ent.pain = Pain.NPC_Wampa_Pain
    }
    if ent.client!.NPC_class == CLASS_RANCOR {
        Rancor_SetBolts(ent)
        ent.s.g2radius = 255 //MAX for this value, was (ent->r.maxs[2]-ent->r.mins[2]), which is 272 or something
        ent.mass = 1000 //???
        ent.flags |= FL_NO_KNOCKBACK
        ent.pain = Pain.NPC_Rancor_Pain
        ent.health *= 4
    }
    if Q_stricmp("Yoda", ent.NPC_type!) == 0 {
        //FIXME: extern this into NPC.cfg?
        ent.NPC!.scriptFlags |= SCF_NO_FORCE //force powers don't work on him
    }
    if Q_stricmp("emperor", ent.NPC_type!) == 0 {
        //FIXME: extern this into NPC.cfg?
        ent.NPC!.scriptFlags |= SCF_DONT_FIRE //so he uses only force powers
    }
    //==================
    //	if ( ent->client->ps.saber[0].type != SABER_NONE )
    if ent.client!.ps.weapon == WP_SABER {
        //if I'm equipped with a saber, initialize it (them)
        //	ent->client->ps.SaberDeactivate();
        //	ent->client->ps.SetSaberLength( 0 );
        WP_SaberInitBladeData(ent)
        ent.client!.ps.saberHolstered = 2
        //	G_CreateG2AttachedWeaponModel( ent, ent->client->ps.saber[0].model, ent->handRBolt, 0 );
        //	if ( ent->client->ps.dualSabers )
        //	{
        //		G_CreateG2AttachedWeaponModel( ent, ent->client->ps.saber[1].model, ent->handLBolt, 1 );
        //	}
        Jedi_ClearTimers(ent)
    }
    if ent.client!.ps.fd.forcePowersKnown != 0 {
        WP_InitForcePowers(ent)
        WP_SpawnInitForcePowers(ent) //rww
    }
    if ent.client!.NPC_class == CLASS_SEEKER {
        ent.NPC!.defaultBehavior = BS_DEFAULT
        ent.client!.ps.gravity = 0
        ent.NPC!.aiFlags |= NPCAI_CUSTOM_GRAVITY
        ent.client!.ps.eFlags2 |= EF2_FLYING
        ent.count = 30 // SEEKER shot ammo count
    }
    //***I'm not sure whether I should leave this as a TEAM_ switch, I think NPC_class may be more appropriate - dmv
    switch ent.client!.playerTeam {
    case NPCTEAM_PLAYER:
        //ent->flags |= FL_NO_KNOCKBACK;
        if ent.client!.NPC_class == CLASS_JEDI || ent.client!.NPC_class == CLASS_LUKE {
            //good jedi
            ent.client!.enemyTeam = NPCTEAM_ENEMY
            if (ent.spawnflags & JSF_AMBUSH) != 0 {
                //ambusher
                ent.NPC!.scriptFlags |= SCF_IGNORE_ALERTS
                ent.client!.noclip = true //hang
            }
        } else {
            /*
            if (ent->client->ps.weapon != WP_NONE)
            {
            G_CreateG2AttachedWeaponModel( ent, weaponData[ent->client->ps.weapon].weaponMdl, ent->handRBolt, 0 );
            }
            */
            switch ent.client!.ps.weapon {
            //		case WP_BLASTER_PISTOL:
            case WP_THERMAL, WP_BLASTER:
                //FIXME: health in NPCs.cfg, and not all blaster users are stormtroopers
                //ent->health = 25;
                //FIXME: not necc. a ST
                ST_ClearTimers(ent)
                if ent.NPC!.rank >= RANK_LT || ent.client!.ps.weapon == WP_THERMAL {
                    //officers, grenade-throwers use alt-fire
                    //ent->health = 50;
                    //ent->NPC->scriptFlags |= SCF_ALT_FIRE;
                }

            default:
                break
            }
        }
        if ent.client!.NPC_class == CLASS_KYLE || ent.client!.NPC_class == CLASS_VEHICLE || (ent.spawnflags & SFB_CINEMATIC) != 0 {
            ent.NPC!.defaultBehavior = BS_CINEMATIC
        } else {
            /*
            ent->NPC->defaultBehavior = BS_FOLLOW_LEADER;
            ent->client->leader = &g_entities[0];
            */
        }

    case NPCTEAM_NEUTRAL:
        if Q_stricmp(ent.NPC_type!, "gonk") == 0 {
            // I guess we generically make them player usable
            ent.r.svFlags |= SVF_PLAYER_USABLE

            // Not even sure if we want to give different levels of batteries?  ...Or even that these are the values we'd want to use.
            /*
            switch ( g_spskill.integer )
            {
            case 0:	//	EASY
            ent->client->ps.batteryCharge = MAX_BATTERIES * 0.8f;
            break;
            case 1:	//	MEDIUM
            ent->client->ps.batteryCharge = MAX_BATTERIES * 0.75f;
            break;
            default :
            case 2:	//	HARD
            ent->client->ps.batteryCharge = MAX_BATTERIES * 0.5f;
            break;
            }*/
            //rwwFIXMEFIXME: Make use of this.
        }

    case NPCTEAM_ENEMY:
        do {
            ent.NPC!.defaultBehavior = BS_DEFAULT
            if ent.client!.NPC_class == CLASS_SHADOWTROOPER {
                //FIXME: a spawnflag?
                Jedi_Cloak(ent)
            }
            if ent.client!.NPC_class == CLASS_TAVION || ent.client!.NPC_class == CLASS_REBORN || ent.client!.NPC_class == CLASS_DESANN || ent.client!.NPC_class == CLASS_SHADOWTROOPER {
                ent.client!.enemyTeam = NPCTEAM_PLAYER
                if (ent.spawnflags & JSF_AMBUSH) != 0 {
                    //ambusher
                    ent.NPC!.scriptFlags |= SCF_IGNORE_ALERTS
                    ent.client!.noclip = true //hang
                }
            } else if ent.client!.NPC_class == CLASS_PROBE || ent.client!.NPC_class == CLASS_REMOTE || ent.client!.NPC_class == CLASS_INTERROGATOR || ent.client!.NPC_class == CLASS_SENTRY {
                ent.NPC!.defaultBehavior = BS_DEFAULT
                ent.client!.ps.gravity = 0
                ent.NPC!.aiFlags |= NPCAI_CUSTOM_GRAVITY
                ent.client!.ps.eFlags2 |= EF2_FLYING
            } else {
                //		G_CreateG2AttachedWeaponModel( ent, weaponData[ent->client->ps.weapon].weaponMdl, ent->handRBolt, 0 );
                switch ent.client!.ps.weapon {
                case WP_BRYAR_PISTOL:
                    //		case WP_BLASTER_PISTOL:
                    //			break;
                    break

                case WP_DISRUPTOR:
                    //Sniper
                    //ent->NPC->scriptFlags |= SCF_ALT_FIRE;//FIXME: use primary fire sometimes?  Up close?  Different class of NPC?
                    break

                case WP_BOWCASTER:
                    break

                case WP_REPEATER:
                    //machine-gunner
                    break

                case WP_DEMP2:
                    break

                case WP_FLECHETTE:
                    //shotgunner
                    if Q_stricmp("stofficeralt", ent.NPC_type!) == 0 {
                        //ent->NPC->scriptFlags |= SCF_ALT_FIRE;
                    }

                case WP_ROCKET_LAUNCHER:
                    break

                case WP_THERMAL:
                    //Gran, use main, bouncy fire
                    //					ent->NPC->scriptFlags |= SCF_ALT_FIRE;
                    break

                case WP_STUN_BATON:
                    break

                default:
                    //FIXME: health in NPCs.cfg, and not all blaster users are stormtroopers
                    //FIXME: not necc. a ST
                    ST_ClearTimers(ent)
                    if ent.NPC!.rank >= RANK_COMMANDER {
                        //commanders use alt-fire
                        //ent->NPC->scriptFlags |= SCF_ALT_FIRE;
                    }
                    if Q_stricmp("rodian2", ent.NPC_type!) == 0 {
                        //ent->NPC->scriptFlags |= SCF_ALT_FIRE;
                    }
                }
                if Q_stricmp("galak_mech", ent.NPC_type!) == 0 {
                    //starts with armor
                    NPC_GalakMech_Init(ent)
                }
            }
        }

    default:
        break
    }


    if ent.client!.NPC_class == CLASS_SEEKER && ent.activator != nil {
        //assume my teams are already set correctly
    } else {
        //for siege, want "bad" npc's allied with the "bad" team
        if g_gametype.integer == GT_SIEGE && ent.s.NPC_class != CLASS_VEHICLE {
            if ent.client!.enemyTeam == NPCTEAM_PLAYER {
                ent.client!.sess.sessionTeam = SIEGETEAM_TEAM1
            } else if ent.client!.enemyTeam == NPCTEAM_ENEMY {
                ent.client!.sess.sessionTeam = SIEGETEAM_TEAM2
            } else {
                ent.client!.sess.sessionTeam = TEAM_FREE
            }
        }
    }

    if ent.client!.NPC_class == CLASS_ATST || ent.client!.NPC_class == CLASS_MARK1 {
        ent.flags |= (FL_SHIELDED | FL_NO_KNOCKBACK)
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:509
func NPC_WeaponsForTeam(_ team: JKAMP.team_t, _ spawnflags: Int32, _ NPC_type: String) -> Int32 {
    //*** not sure how to handle this, should I pass in class instead of team and go from there? - dmv
    switch team {
    // no longer exists
    //	case TEAM_BORG:
    //		break;
    //	case TEAM_HIROGEN:
    //		if( Q_stricmp( "hirogenalpha", NPC_type ) == 0 )
    //			return ( 1 << WP_BLASTER);
    //Falls through
    //	case TEAM_KLINGON:
    //NOTENOTE: Falls through
    //	case TEAM_IMPERIAL:
    case NPCTEAM_ENEMY:
        if Q_stricmp("tavion", NPC_type) == 0 || Q_strncmp("reborn", NPC_type, 6) == 0 || Q_stricmp("desann", NPC_type) == 0 || Q_strncmp("shadowtrooper", NPC_type, 13) == 0 {
            return (1 << WP_SABER)
        }
        //			return ( 1 << WP_IMPERIAL_BLADE);
        //NOTENOTE: Falls through if not a knife user

        //	case TEAM_SCAVENGERS:
        //	case TEAM_MALON:
        //FIXME: default weapon in npc config?
        if Q_strncmp("stofficer", NPC_type, 9) == 0 {
            return (1 << WP_FLECHETTE)
        }
        if Q_stricmp("stcommander", NPC_type) == 0 {
            return (1 << WP_REPEATER)
        }
        if Q_stricmp("swamptrooper", NPC_type) == 0 {
            return (1 << WP_FLECHETTE)
        }
        if Q_stricmp("swamptrooper2", NPC_type) == 0 {
            return (1 << WP_REPEATER)
        }
        if Q_stricmp("rockettrooper", NPC_type) == 0 {
            return (1 << WP_ROCKET_LAUNCHER)
        }
        if Q_strncmp("shadowtrooper", NPC_type, 13) == 0 {
            return (1 << WP_SABER) //|( 1 << WP_RAPID_CONCUSSION)?
        }
        if Q_stricmp("imperial", NPC_type) == 0 {
            //return ( 1 << WP_BLASTER_PISTOL);
            return (1 << WP_BLASTER)
        }
        if Q_strncmp("impworker", NPC_type, 9) == 0 {
            //return ( 1 << WP_BLASTER_PISTOL);
            return (1 << WP_BLASTER)
        }
        if Q_stricmp("stormpilot", NPC_type) == 0 {
            //return ( 1 << WP_BLASTER_PISTOL);
            return (1 << WP_BLASTER)
        }
        if Q_stricmp("galak", NPC_type) == 0 {
            return (1 << WP_BLASTER)
        }
        if Q_stricmp("galak_mech", NPC_type) == 0 {
            return (1 << WP_REPEATER)
        }
        if Q_strncmp("ugnaught", NPC_type, 8) == 0 {
            return WP_NONE
        }
        if Q_stricmp("granshooter", NPC_type) == 0 {
            return (1 << WP_BLASTER)
        }
        if Q_stricmp("granboxer", NPC_type) == 0 {
            return (1 << WP_STUN_BATON)
        }
        if Q_strncmp("gran", NPC_type, 4) == 0 {
            return ((1 << WP_THERMAL) | (1 << WP_STUN_BATON))
        }
        if Q_stricmp("rodian", NPC_type) == 0 {
            return (1 << WP_DISRUPTOR)
        }
        if Q_stricmp("rodian2", NPC_type) == 0 {
            return (1 << WP_BLASTER)
        }

        if (Q_stricmp("interrogator", NPC_type) == 0) || (Q_stricmp("sentry", NPC_type) == 0) || (Q_strncmp("protocol", NPC_type, 8) == 0) {
            return WP_NONE
        }

        if Q_strncmp("weequay", NPC_type, 7) == 0 {
            return (1 << WP_BOWCASTER) //|( 1 << WP_STAFF )(FIXME: new weap?)
        }
        if Q_stricmp("impofficer", NPC_type) == 0 {
            return (1 << WP_BLASTER)
        }
        if Q_stricmp("impcommander", NPC_type) == 0 {
            return (1 << WP_BLASTER)
        }
        if (Q_stricmp("probe", NPC_type) == 0) || (Q_stricmp("seeker", NPC_type) == 0) {
            //return ( 1 << WP_BOT_LASER);
            return 0
        }
        if Q_stricmp("remote", NPC_type) == 0 {
            //return ( 1 << WP_BOT_LASER );
            return 0
        }
        if Q_stricmp("trandoshan", NPC_type) == 0 {
            return (1 << WP_REPEATER)
        }
        if Q_stricmp("atst", NPC_type) == 0 {
            //return (( 1 << WP_ATST_MAIN)|( 1 << WP_ATST_SIDE));
            return 0
        }
        if Q_stricmp("mark1", NPC_type) == 0 {
            //return ( 1 << WP_BOT_LASER);
            return 0
        }
        if Q_stricmp("mark2", NPC_type) == 0 {
            //return ( 1 << WP_BOT_LASER);
            return 0
        }
        if Q_stricmp("minemonster", NPC_type) == 0 {
            return ((1 << WP_STUN_BATON))
        }
        if Q_stricmp("howler", NPC_type) == 0 {
            return ((1 << WP_STUN_BATON))
        }
        //Stormtroopers, etc.
        return (1 << WP_BLASTER)

    case NPCTEAM_PLAYER:
        //		if(spawnflags & SFB_TRICORDER)
        //			return ( 1 << WP_TRICORDER);

        if (spawnflags & SFB_RIFLEMAN) != 0 {
            return (1 << WP_REPEATER)
        }

        if (spawnflags & SFB_PHASER) != 0 {
            return (1 << WP_BLASTER)
        }

        if Q_strncmp("jedi", NPC_type, 4) == 0 || Q_stricmp("luke", NPC_type) == 0 {
            return (1 << WP_SABER)
        }

        if Q_strncmp("prisoner", NPC_type, 8) == 0 {
            return WP_NONE
        }
        if Q_strncmp("bespincop", NPC_type, 9) == 0 {
            //return ( 1 << WP_BLASTER_PISTOL);
            return (1 << WP_BLASTER)
        }

        if Q_stricmp("MonMothma", NPC_type) == 0 {
            return WP_NONE
        }

        //rebel
        return (1 << WP_BLASTER)

    case NPCTEAM_NEUTRAL:
        if Q_stricmp("mark1", NPC_type) == 0 {
            return WP_NONE
        }
        if Q_stricmp("mark2", NPC_type) == 0 {
            return WP_NONE
        }
        if Q_strncmp("ugnaught", NPC_type, 8) == 0 {
            return WP_NONE
        }
        if Q_stricmp("bartender", NPC_type) == 0 {
            return WP_NONE
        }
        if Q_stricmp("morgankatarn", NPC_type) == 0 {
            return WP_NONE
        }
        // these no longer exist
        //	case TEAM_FORGE:
        //		return ( 1 << WP_STUN_BATON);
        //		break;
        //	case TEAM_STASIS:
        //		return ( 1 << WP_STUN_BATON);
        //		break;
        //	case TEAM_PARASITE:
        //		break;
        //	case TEAM_8472:
        //		break;

    default:
        break
    }

    return WP_NONE
}

/// Source: oracle/codemp/game/NPC_spawn.c:759
func NPC_SetWeapons(_ ent: Entity) {
    var bestWeap: Int32 = WP_NONE
    var curWeap: Int32
    let weapons: Int32 = NPC_WeaponsForTeam(ent.client!.playerTeam, ent.spawnflags, ent.NPC_type!)

    ent.client!.ps.stats[STAT_WEAPONS] = 0
    curWeap = WP_SABER
    while curWeap < WP_NUM_WEAPONS {
        if (weapons & (1 << curWeap)) != 0 {
            ent.client!.ps.stats[STAT_WEAPONS] |= (1 << curWeap)
            //			RegisterItem( FindItemForWeapon( (weapon_t)(curWeap) ) );	//precache the weapon
            //rwwFIXMEFIXME: Precache
            ent.client!.ps.ammo[weaponData[curWeap].ammoIndex] = 100 //FIXME: max ammo
            ent.NPC!.currentAmmo = ent.client!.ps.ammo[weaponData[curWeap].ammoIndex] //FIXME: max ammo

            if bestWeap == WP_SABER {
                // still want to register other weapons -- force saber to be best weap
                curWeap += 1
                continue
            }

            if curWeap == WP_STUN_BATON {
                if bestWeap == WP_NONE {
                    // We'll only consider giving Melee since we haven't found anything better yet.
                    bestWeap = curWeap
                }
            } else if curWeap > bestWeap || bestWeap == WP_STUN_BATON {
                // This will never override saber as best weap.  Also will override WP_STUN_BATON if something better comes later in the list
                bestWeap = curWeap
            }
        }
        curWeap += 1
    }

    ent.client!.ps.weapon = bestWeap
}

/// Source: oracle/codemp/game/NPC_spawn.c:808
func NPC_SpawnEffect(_ ent: Entity) {
}

//--------------------------------------------------------------
// NPC_SetFX_SpawnStates
//
// Set up any special parms for spawn effects
//--------------------------------------------------------------
/// Source: oracle/codemp/game/NPC_spawn.c:817
func NPC_SetFX_SpawnStates(_ ent: Entity) {
    if !((ent.NPC!.aiFlags & NPCAI_CUSTOM_GRAVITY) != 0) {
        ent.client!.ps.gravity = Int32(g_gravity.value)
    }
}

/**
```
================
NPC_SpotWouldTelefrag

================
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:831
func NPC_SpotWouldTelefrag(_ npc: Entity) -> Bool {
    var i: Int32
    let num: Int32
    var touch: [Int32] = [Int32](repeating: 0, count: 1024)
    var hit: Entity?
    var mins = vec3_t()
    var maxs = vec3_t()

    mins = npc.r.currentOrigin + npc.r.mins
    maxs = npc.r.currentOrigin + npc.r.maxs
    num = trap_EntitiesInBox(mins, maxs, &touch, MAX_GENTITIES)

    i = 0
    while i < num {
        hit = g_entities[touch[i]]
        //if ( hit->client && hit->client->ps.stats[STAT_HEALTH] > 0 ) {
        if hit!.inuse && hit!.client != nil && hit!.s.number != npc.s.number && (hit!.r.contents & MASK_NPCSOLID) != 0 && hit!.s.number != npc.r.ownerNum && hit!.r.ownerNum != npc.s.number {
            return true
        }
        i += 1
    }

    return false
}

//--------------------------------------------------------------
/// Source: oracle/codemp/game/NPC_spawn.c:862
func NPC_Begin(_ ent: Entity) {
    var spawn_origin = vec3_t()
    var spawn_angles = vec3_t()
    var client: Client?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Usercmd.scratch { ucmd -> Bool in
        let spawnPoint: Entity? = nil

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        if !((ent.spawnflags & SFB_NOTSOLID) != 0) {
            //No NPCs should telefrag
            if NPC_SpotWouldTelefrag(ent) {
                if ent.wait < 0 {
                    //remove yourself
                    G_DebugPrint(WL_DEBUG, "NPC %s could not spawn, firing target3 (%s) and removing self\n", ent.targetname!, ent.target3!)
                    //Fire off our target3
                    G_UseTargets2(ent, ent, ent.target3!)

                    //Kill us
                    ent.think = Think.G_FreeEntity
                    ent.nextthink = level.time + 100
                } else {
                    G_DebugPrint(WL_DEBUG, "NPC %s could not spawn, waiting %4.2 secs to try again\n", ent.targetname!, ent.wait / 1000.0)
                    ent.think = Think.NPC_Begin
                    ent.nextthink = Int32(level.time + ent.wait) //try again in half a second
                }
                return true
            }
        }
        //Spawn effect
        NPC_SpawnEffect(ent)

        spawn_origin = ent.client!.ps.origin
        spawn_angles = ent.s.angles
        spawn_angles[YAW] = ent.NPC!.desiredYaw

        client = ent.client

        // increment the spawncount so the client will detect the respawn
        client!.ps.persistant[PERS_SPAWN_COUNT] += 1

        client!.airOutTime = level.time + 12000

        client!.ps.clientNum = ent.s.number
        // clear entity values

        if ent.health != 0 {
            client!.ps.stats[STAT_MAX_HEALTH] = ent.health
            client!.pers.maxHealth = client!.ps.stats[STAT_MAX_HEALTH]
        } else if ent.NPC!.stats.health != 0 {
            if ent.client!.NPC_class != CLASS_REBORN && ent.client!.NPC_class != CLASS_SHADOWTROOPER && ent.client!.NPC_class != CLASS_JEDI {
                // up everyone except jedi
                ent.NPC!.stats.health += ent.NPC!.stats.health / 4 * g_spskill.integer // 100% on easy, 125% on medium, 150% on hard
            }

            client!.ps.stats[STAT_MAX_HEALTH] = ent.NPC!.stats.health
            client!.pers.maxHealth = client!.ps.stats[STAT_MAX_HEALTH]
        } else {
            client!.ps.stats[STAT_MAX_HEALTH] = 100
            client!.pers.maxHealth = client!.ps.stats[STAT_MAX_HEALTH]
        }

        if Q_stricmp("rodian", ent.NPC_type!) == 0 {
            //sniper
            //NOTE: this will get overridden by any aim settings in their spawnscripts
            switch g_spskill.integer {
            case 0:
                ent.NPC!.stats.aim = 1

            case 1:
                ent.NPC!.stats.aim = Q_irand(2, 3)

            case 2:
                ent.NPC!.stats.aim = Q_irand(3, 4)

            default:
                break
            }
        } else if ent.client!.NPC_class == CLASS_STORMTROOPER || ent.client!.NPC_class == CLASS_SWAMPTROOPER || ent.client!.NPC_class == CLASS_IMPWORKER || Q_stricmp("rodian2", ent.NPC_type!) == 0 {
            //tweak yawspeed for these NPCs based on difficulty
            switch g_spskill.integer {
            case 0:
                ent.NPC!.stats.yawSpeed *= 0.75
                if ent.client!.NPC_class == CLASS_IMPWORKER {
                    ent.NPC!.stats.aim -= Q_irand(3, 6)
                }

            case 1:
                if ent.client!.NPC_class == CLASS_IMPWORKER {
                    ent.NPC!.stats.aim -= Q_irand(2, 4)
                }

            case 2:
                ent.NPC!.stats.yawSpeed *= 1.5
                if ent.client!.NPC_class == CLASS_IMPWORKER {
                    ent.NPC!.stats.aim -= Q_irand(0, 2)
                }

            default:
                break
            }
        } else if ent.client!.NPC_class == CLASS_REBORN || ent.client!.NPC_class == CLASS_SHADOWTROOPER {
            switch g_spskill.integer {
            case 1:
                ent.NPC!.stats.yawSpeed *= 1.25

            case 2:
                ent.NPC!.stats.yawSpeed *= 1.5

            default:
                break
            }
        }


        ent.s.groundEntityNum = ENTITYNUM_NONE
        ent.mass = 10
        ent.takedamage = true
        ent.inuse = true
        ent.classname = "NPC"
        //	if ( ent->client->race == RACE_HOLOGRAM )
        //	{//can shoot through holograms, but not walk through them
        //		ent->contents = CONTENTS_PLAYERCLIP|CONTENTS_MONSTERCLIP|CONTENTS_ITEM;//contents_corspe to make them show up in ID and use traces
        //		ent->clipmask = MASK_NPCSOLID;
        //	} else
        if !((ent.spawnflags & SFB_NOTSOLID) != 0) {
            ent.r.contents = CONTENTS_BODY
            ent.clipmask = MASK_NPCSOLID
        } else {
            ent.r.contents = 0
            ent.clipmask = MASK_NPCSOLID & ~CONTENTS_BODY
        }
        /*
        if(!ent->client->moveType)//Static?
        {
        ent->client->moveType = MT_RUNJUMP;
        }
        */
        //rwwFIXMEFIXME: movetype support

        ent.die = Die.player_die
        ent.waterlevel = 0
        ent.watertype = 0
        ent.client!.ps.rocketLockIndex = ENTITYNUM_NONE
        ent.client!.ps.rocketLockTime = 0

        //visible to player and NPCs
        if ent.client!.NPC_class != CLASS_R2D2 && ent.client!.NPC_class != CLASS_R5D2 && ent.client!.NPC_class != CLASS_MOUSE && ent.client!.NPC_class != CLASS_GONK && ent.client!.NPC_class != CLASS_PROTOCOL {
            ent.flags &= ~FL_NOTARGET
        }
        ent.s.eFlags &= ~EF_NODRAW

        NPC_SetFX_SpawnStates(ent)

        //client->ps.friction = 6;
        //rwwFIXMEFIXME: per ent friction?

        if ent.client!.ps.weapon == WP_NONE {
            //not set by the NPCs.cfg
            NPC_SetWeapons(ent)
        }
        //select the weapon
        ent.NPC!.currentAmmo = ent.client!.ps.ammo[weaponData[ent.client!.ps.weapon].ammoIndex]
        ent.client!.ps.weaponstate = WEAPON_IDLE
        ChangeWeapon(ent, ent.client!.ps.weapon)

        client!.ps.origin = spawn_origin

        // the respawned flag will be cleared after the attack and jump keys come up
        client!.ps.pm_flags |= PMF_RESPAWNED

        // clear entity state values
        //ent->s.eType = ET_PLAYER;
        ent.s.eType = ET_NPC
        //	ent->s.skinNum = ent - g_entities - 1;	// used as index to get custom models

        ent.s.origin = spawn_origin
        //	ent->s.origin[2] += 1;	// make sure off ground

        SetClientViewAngle(ent, spawn_angles)
        client!.renderInfo.lookTarget = ENTITYNUM_NONE

        if !((ent.spawnflags & 64) != 0) {
            G_KillBox(ent)
            trap_LinkEntity(ent)
        }

        // don't allow full run speed for a bit
        client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
        client!.ps.pm_time = 100

        client!.respawnTime = level.time
        client!.inactivityTime = Int32(level.time + g_inactivity.value * 1000)
        client!.latched_buttons = 0
        if ent.s.m_iVehicleNum != 0 {
            //I'm an NPC in a vehicle (or a vehicle), I already have owner set
        } else if client!.NPC_class == CLASS_SEEKER && ent.activator != nil {
            //somebody else "owns" me
            ent.r.ownerNum = ent.activator!.s.number
            ent.s.owner = ent.r.ownerNum
        } else {
            ent.s.owner = ENTITYNUM_NONE
        }

        // set default animations
        if ent.client!.NPC_class != CLASS_VEHICLE {
            NPC_SetAnim(ent, SETANIM_BOTH, BOTH_STAND1, SETANIM_FLAG_NORMAL)
        }

        if spawnPoint != nil {
            // fire the targets of the spawn point
            G_UseTargets(spawnPoint!, ent)
        }

        //ICARUS include
        trap_ICARUS_InitEnt(ent)

        //==NPC initialization
        SetNPCGlobals(ent)

        ent.enemy = nil
        NPCInfo!.timeOfDeath = 0
        NPCInfo!.shotTime = 0
        NPC_ClearGoal()
        NPC_ChangeWeapon(ent.client!.ps.weapon)

        //==Final NPC initialization
        ent.pain = NPC_PainFunc(ent) //painF_NPC_Pain;
        ent.touch = NPC_TouchFunc(ent) //touchF_NPC_Touch;
        //	ent->NPC->side = 1;

        ent.client!.ps.ping = ent.NPC!.stats.reactions * 50

        //MCG - Begin: NPC hacks
        //FIXME: Set the team correctly
        if ent.s.NPC_class != CLASS_VEHICLE || g_gametype.integer != GT_SIEGE {
            ent.client!.ps.persistant[PERS_TEAM] = ent.client!.playerTeam
        }

        ent.use = Use.NPC_Use
        ent.think = Think.NPC_Think
        ent.nextthink = level.time + FRAMETIME + Q_irand(0, 100)

        NPC_SetMiscDefaultData(ent)
        if ent.health <= 0 {
            //ORIGINAL ID: health will count down towards max_health
            client!.ps.stats[STAT_HEALTH] = ent.client!.pers.maxHealth
            ent.health = client!.ps.stats[STAT_HEALTH]
        } else {
            client!.ps.stats[STAT_HEALTH] = ent.health
        }

        if ent.s.shouldtarget {
            ent.maxHealth = ent.health
            G_ScaleNetHealth(ent)
        }

        ChangeWeapon(ent, ent.client!.ps.weapon) //yes, again... sigh

        if !((ent.spawnflags & SFB_STARTINSOLID) != 0) {
            //Not okay to start in solid
            G_CheckInSolid(ent, true)
        }
        ent.NPC!.lastClearOrigin = vec3_t()

        //Run a script if you have one assigned to you
        if G_ActivateBehavior(ent, BSET_SPAWN) {
            trap_ICARUS_MaintainTaskManager(ent.s.number)
        }

        ent.client!.renderInfo.eyePoint = ent.r.currentOrigin

        // run a client frame to drop exactly to the floor,
        // initialize animations and other things
        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
        //_VectorCopy( client->pers.cmd_angles, ucmd.angles );
        ucmd.angles[0] = client!.pers.cmd.angles[0]
        ucmd.angles[1] = client!.pers.cmd.angles[1]
        ucmd.angles[2] = client!.pers.cmd.angles[2]

        ent.client!.ps.groundEntityNum = ENTITYNUM_NONE

        if (ent.NPC!.aiFlags & NPCAI_MATCHPLAYERWEAPON) != 0 {
            //G_MatchPlayerWeapon( ent );
            //rwwFIXMEFIXME: Use this? Probably doesn't really matter for MP.
        }

        ClientThink(ent.s.number, ucmd)

        trap_LinkEntity(ent)

        if ent.client!.playerTeam == NPCTEAM_ENEMY {
            //valid enemy spawned
            if !((ent.spawnflags & SFB_CINEMATIC) != 0) && ent.NPC!.behaviorState != BS_CINEMATIC {
                //not a cinematic enemy
                if g_entities[0].client != nil {
                    //g_entities[0].client->sess.missionStats.enemiesSpawned++;
                    //rwwFIXMEFIXME: Do something here? And this is a rather strange place to be storing
                    //this sort of data.
                }
            }
        }
        ent.NPC!.homeWp = WAYPOINT_NONE
        ent.waypoint = ent.NPC!.homeWp

        if ent.m_pVehicle != nil {
            //a vehicle
            //check for droidunit
            if ent.m_pVehicle!.m_iDroidUnitTag != -1 {
                var droidNPCType: String? = nil
                var droidEnt: Entity? = nil
                if ent.model2 != nil && !ent.model2!.isEmpty {
                    //specified on the NPC_Vehicle spawner ent
                    droidNPCType = ent.model2
                } else if ent.m_pVehicle!.m_pVehicleInfo!.droidNPC != nil && !ent.m_pVehicle!.m_pVehicleInfo!.droidNPC!.isEmpty {
                    //specified in the vehicle's .veh file
                    droidNPCType = ent.m_pVehicle!.m_pVehicleInfo!.droidNPC
                }

                if droidNPCType != nil {
                    if Q_stricmp("random", droidNPCType!) == 0
                        || Q_stricmp("default", droidNPCType!) == 0 {
                        //use default - R2D2 or R5D2
                        if Q_irand(0, 1) != 0 {
                            droidNPCType = "r2d2"
                        } else {
                            droidNPCType = "r5d2"
                        }
                    }
                    droidEnt = NPC_SpawnType(ent, droidNPCType, nil, false)
                    if droidEnt != nil {
                        if droidEnt!.client != nil {
                            //droidEnt->s.otherEntityNum2 =
                            droidEnt!.r.ownerNum = ent.s.number
                            droidEnt!.s.owner = droidEnt!.r.ownerNum
                            droidEnt!.s.m_iVehicleNum = droidEnt!.s.owner
                            droidEnt!.client!.ps.m_iVehicleNum = droidEnt!.s.m_iVehicleNum
                            ent.m_pVehicle!.m_pDroidUnit = BgEntity(droidEnt!)
                            //SP way:
                            //droidEnt->s.m_iVehicleNum = ent->s.number;
                            //droidEnt->owner = ent;
                            //set team
                            droidEnt!.alliedTeam = ent.alliedTeam
                            droidEnt!.teamnodmg = ent.teamnodmg
                            droidEnt!.client!.sess.sessionTeam = ent.client!.sess.sessionTeam
                            droidEnt!.client!.ps.persistant[PERS_TEAM] = ent.client!.ps.persistant[PERS_TEAM]
                            //position
                            droidEnt!.s.origin = ent.r.currentOrigin
                            droidEnt!.client!.ps.origin = ent.r.currentOrigin
                            G_SetOrigin(droidEnt!, &droidEnt!.s.origin)
                            trap_LinkEntity(droidEnt!)
                            droidEnt!.s.angles = ent.r.currentAngles
                            G_SetAngles(droidEnt!, droidEnt!.s.angles)
                            if droidEnt!.NPC != nil {
                                droidEnt!.NPC!.desiredYaw = droidEnt!.s.angles[YAW]
                                droidEnt!.NPC!.desiredPitch = droidEnt!.s.angles[PITCH]
                            }
                            droidEnt!.flags |= FL_UNDYING
                        } else {
                            //wtf?
                            G_FreeEntity(droidEnt!)
                        }
                    }
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:1278
func New_NPC_t(_ entNum: Int32) -> GNPC? {
    var ptr: GNPC?

    if gNPCPtrs[entNum] == nil {
        gNPCPtrs[entNum] = GNPC(BG_Alloc(Int32(GNPC.byteCount)))
    }

    ptr = gNPCPtrs[entNum]

    if ptr != nil {
        // clear it...
        //
        ptr!.clear()
    }

    return ptr
}

/**
```
-------------------------
NPC_StasisSpawn_Go
-------------------------
```
*/
/**
```
qboolean NPC_StasisSpawn_Go( gentity_t *ent )
{
	//Setup an owner pointer if we need it
	if VALIDSTRING( ent->ownername )
	{
		ent->parent = G_Find( NULL, FOFS( targetname ), ent->ownername );

		if ( ( ent->parent ) && ( ent->parent->health <= 0 ) )
		{//our spawner thing is broken
			if ( ent->target2 && ent->target2[0] )
			{
				//Fire off our target2
				G_UseTargets2( ent, ent, ent->target2 );

				//Kill us
				ent->e_ThinkFunc = thinkF_G_FreeEntity;
				ent->nextthink = level.time + 100;
			}
			else
			{
				//Try to spawn again in one second
				ent->e_ThinkFunc = thinkF_NPC_Spawn_Go;
				ent->nextthink = level.time + 1000;
			}
			return qfalse;
		}
	}

	//Test for an entity blocking the spawn
	trace_t	tr;
	trap_Trace( &tr, ent->r.currentOrigin, ent->r.mins, ent->r.maxs, ent->r.currentOrigin, ent->s.number, MASK_NPCSOLID );

	//Can't have anything in the way
	if ( tr.allsolid || tr.startsolid )
	{
		ent->nextthink = level.time + 1000;
		return qfalse;
	}

	return qtrue;
}
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:1356
func NPC_DefaultScriptFlags(_ ent: Entity) {
    if ent.NPC == nil {
        return
    }
    //Set up default script flags
    ent.NPC!.scriptFlags = (SCF_CHASE_ENEMIES | SCF_LOOK_FOR_ENEMIES)
}

/// Source: oracle/codemp/game/NPC_spawn.c:1377
func NPC_Spawn_Do(_ ent: Entity) -> Entity? {
    var newent: Entity? = nil
    var index: Int32 = 0
    var saveOrg = vec3_t()

    /*	//Do extra code for stasis spawners
    if ( Q_stricmp( ent->classname, "NPC_Stasis" ) == 0 )
    {
    if ( NPC_StasisSpawn_Go( ent ) == qfalse )
    return;
    }
    */

    //Test for drop to floor
    finish: do {
        if (ent.spawnflags & NSF_DROP_TO_FLOOR) != 0 {
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in
                var bottom = vec3_t()

                saveOrg = ent.r.currentOrigin
                bottom = ent.r.currentOrigin
                bottom[2] = Float(MIN_WORLD_COORD)
                trap_Trace(tr, ent.r.currentOrigin, ent.r.mins, ent.r.maxs, bottom, ent.s.number, MASK_NPCSOLID)
                if tr.allsolid == 0 && tr.startsolid == 0 && Double(tr.fraction) < 1.0 {
                    G_SetOrigin(ent, &tr.endpos)
                }
            }
        }

        //Check the spawner's count
        if ent.count != -1 {
            ent.count -= 1

            if ent.count <= 0 {
                ent.use = nil //never again
                //FIXME: why not remove me...?  Because of all the string pointers?  Just do G_NewStrings?
            }
        }

        newent = G_Spawn()

        if newent == nil {
            Com_Printf(S_COLOR_RED + "ERROR: NPC G_Spawn failed\n")
            return nil
        }

        newent!.fullName = ent.fullName

        newent!.NPC = New_NPC_t(newent!.s.number)
        if newent!.NPC == nil {
            Com_Printf(S_COLOR_RED + "ERROR: NPC G_Alloc NPC failed\n")
            break finish
            return nil
        }

        //newent->client = (gclient_s *)G_Alloc (sizeof(gclient_s));
        G_CreateFakeClient(newent!.s.number, &newent!.client)

        newent!.NPC!.tempGoal = G_Spawn()

        if newent!.NPC!.tempGoal == nil {
            newent!.NPC = nil
            break finish
            return nil
        }

        newent!.NPC!.tempGoal!.classname = "NPC_goal"
        newent!.NPC!.tempGoal!.parent = newent
        newent!.NPC!.tempGoal!.r.svFlags |= SVF_NOCLIENT

        if newent!.client == nil {
            Com_Printf(S_COLOR_RED + "ERROR: NPC BG_Alloc client failed\n")
            break finish
            return nil
        }

        newent!.client!.clear()

        //Assign the pointer for bg entity access
        newent!.playerState = newent!.client!.ps

        //==NPC_Connect( newent, net_name );===================================

        if ent.NPC_type == nil {
            ent.NPC_type = "random"
        } else {
            ent.NPC_type = G_NewString(Q_strlwr(ent.NPC_type!))
        }

        if (ent.r.svFlags & SVF_NO_BASIC_SOUNDS) != 0 {
            newent!.r.svFlags |= SVF_NO_BASIC_SOUNDS
        }
        if (ent.r.svFlags & SVF_NO_COMBAT_SOUNDS) != 0 {
            newent!.r.svFlags |= SVF_NO_COMBAT_SOUNDS
        }
        if (ent.r.svFlags & SVF_NO_EXTRA_SOUNDS) != 0 {
            newent!.r.svFlags |= SVF_NO_EXTRA_SOUNDS
        }

        if ent.message != nil {
            //has a key
            newent!.message = ent.message //transfer the key name
            newent!.flags |= FL_NO_KNOCKBACK //don't fall off ledges
        }

        // If this is a vehicle we need to see what kind it is so we properlly allocate it.
        if Q_stricmp(ent.classname!, "NPC_Vehicle") == 0 {
            // Get the vehicle entry index.
            let iVehIndex: Int32 = BG_VehicleGetIndex(ent.NPC_type!)

            if iVehIndex == VEHICLE_NONE {
                G_FreeEntity(newent!)
                //get rid of the spawner, too, I guess
                G_FreeEntity(ent)
                return nil
            }
            // NOTE: If you change/add any of these, update NPC_Spawn_f for the new vehicle you
            // want to be able to spawn in manually.

            // See what kind of vehicle this is and allocate it properly.
            switch g_vehicleInfo[iVehIndex].type {
            case VH_ANIMAL:
                // Create the animal (making sure all it's data is initialized).
                G_CreateAnimalNPC(&newent!.m_pVehicle, ent.NPC_type!)

            case VH_SPEEDER:
                // Create the speeder (making sure all it's data is initialized).
                G_CreateSpeederNPC(&newent!.m_pVehicle, ent.NPC_type!)

            case VH_FIGHTER:
                // Create the fighter (making sure all it's data is initialized).
                G_CreateFighterNPC(&newent!.m_pVehicle, ent.NPC_type!)

            case VH_WALKER:
                // Create the walker (making sure all it's data is initialized).
                G_CreateWalkerNPC(&newent!.m_pVehicle, ent.NPC_type!)

            default:
                Com_Printf(S_COLOR_RED + "ERROR: Couldn't spawn NPC %s\n", ent.NPC_type!)
                G_FreeEntity(newent!)
                //get rid of the spawner, too, I guess
                G_FreeEntity(ent)
                return nil
            }


            //set up my happy prediction hack
            // Port-note: Raven stores a pointer into the `float *` field with `newent->m_pVehicle->m_vOrientation = &newent->client->ps.vehOrientation[0]`, and rule 11 keeps a pointer out of a logic target.
            // Raven wrote: newent->m_pVehicle->m_vOrientation = &newent->client->ps.vehOrientation[0]
            portMissing("NPC_Spawn_Do", source: "oracle/codemp/game/NPC_spawn.c:1377")

            // Setup the vehicle.
            newent!.m_pVehicle!.m_pParentEntity = newent.map { BgEntity($0) }
            newent!.m_pVehicle!.m_pVehicleInfo!.runInitialize(newent!.m_pVehicle)

            //cache all the assets
            newent!.m_pVehicle!.m_pVehicleInfo!.runRegisterAssets(newent!.m_pVehicle)
            //set the class
            newent!.client!.NPC_class = CLASS_VEHICLE
            if g_vehicleInfo[iVehIndex].type == VH_FIGHTER {
                //FIXME: EXTERN!!!
                newent!.flags |= (FL_NO_KNOCKBACK | FL_SHIELDED | FL_DMG_BY_HEAVY_WEAP_ONLY) //don't get pushed around, blasters bounce off, only damage from heavy weaps
            }
            //WTF?!!! Ships spawning in pointing straight down!
            //set them up to start landed
            newent!.m_pVehicle!.m_vOrientationVector[YAW] = ent.s.angles[YAW]
            newent!.m_pVehicle!.m_vOrientationVector[ROLL] = 0.0
            newent!.m_pVehicle!.m_vOrientationVector[PITCH] = newent!.m_pVehicle!.m_vOrientationVector[ROLL]
            G_SetAngles(newent!, newent!.m_pVehicle!.m_vOrientationVector)
            SetClientViewAngle(newent!, newent!.m_pVehicle!.m_vOrientationVector)

            //newent->m_pVehicle->m_ulFlags |= VEH_GEARSOPEN;
            //why? this would just make it so the initial anim never got played... -rww
            //There was no initial anim, it would just open the gear even though it's already on the ground (fixed now, made an initial anim)

            //For SUSPEND spawnflag, the amount of time to drop like a rock after SUSPEND turns off
            newent!.fly_sound_debounce_time = ent.fly_sound_debounce_time

            //for no-pilot-death delay
            newent!.damage = ent.damage

            //no-pilot-death distance
            newent!.speed = ent.speed

            //for veh transfer all healy stuff
            newent!.healingclass = ent.healingclass
            newent!.healingsound = ent.healingsound
            newent!.healingrate = ent.healingrate
            newent!.model2 = ent.model2 //for droidNPC
        } else {
            newent!.client!.ps.weapon = WP_NONE //init for later check in NPC_Begin
        }

        newent!.s.origin = ent.s.origin
        newent!.client!.ps.origin = ent.s.origin
        newent!.r.currentOrigin = ent.s.origin
        G_SetOrigin(newent!, &ent.s.origin) //just to be sure!
        //NOTE: on vehicles, anything in the .npc file will STOMP data on the NPC that's set by the vehicle
        if !NPC_ParseParms(ent.NPC_type!, newent!) {
            Com_Printf(S_COLOR_RED + "ERROR: Couldn't spawn NPC %s\n", ent.NPC_type!)
            G_FreeEntity(newent!)
            //get rid of the spawner, too, I guess
            G_FreeEntity(ent)
            return nil
        }

        if ent.NPC_type != nil {
            if Q_stricmp(ent.NPC_type!, "kyle") == 0 {
                //FIXME: "player", not Kyle?  Or check NPC_type against player's NPC_type?
                newent!.NPC!.aiFlags |= NPCAI_MATCHPLAYERWEAPON
            } else if Q_stricmp(ent.NPC_type!, "test") == 0 {
                var n: Int32 = 0
                n = 0
                while n < 1 {
                    if g_entities[n].s.eType != ET_NPC && g_entities[n].client != nil {
                        newent!.s.origin = g_entities[n].s.origin
                        newent!.s.teamowner = g_entities[n].client!.playerTeam
                        newent!.client!.playerTeam = newent!.s.teamowner
                        break
                    }
                    n += 1
                }
                newent!.NPC!.behaviorState = BS_WAIT
                newent!.NPC!.defaultBehavior = newent!.NPC!.behaviorState
                newent!.classname = "NPC"
                //		newent->r.svFlags |= SVF_NOPUSH;
            }
        }
        //=====================================================================
        //set the info we want
        if newent!.health == 0 {
            newent!.health = ent.health
        }
        newent!.script_targetname = ent.NPC_targetname
        newent!.targetname = ent.NPC_targetname
        newent!.target = ent.NPC_target //death
        newent!.target2 = ent.target2 //knocked out death
        newent!.target3 = ent.target3 //???
        newent!.target4 = ent.target4 //ffire death
        newent!.wait = ent.wait

        index = BSET_FIRST
        while index < NUM_BSETS {
            if ent.behaviorSet[index] != nil {
                newent!.behaviorSet[index] = ent.behaviorSet[index]
            }
            index += 1
        }

        newent!.classname = "NPC"
        newent!.NPC_type = ent.NPC_type
        trap_UnlinkEntity(newent!)

        newent!.s.angles = ent.s.angles
        newent!.r.currentAngles = ent.s.angles
        newent!.client!.ps.viewangles = ent.s.angles
        newent!.NPC!.desiredYaw = ent.s.angles[YAW]

        trap_LinkEntity(newent!)
        newent!.spawnflags = ent.spawnflags

        if ent.paintarget != nil {
            //safe to point at owner's string since memory is never freed during game
            newent!.paintarget = ent.paintarget
        }
        if ent.opentarget != nil {
            newent!.opentarget = ent.opentarget
        }

        //==New stuff=====================================================================
        newent!.s.eType = ET_NPC //ET_PLAYER;

        //FIXME: Call CopyParms
        if ent.parms != nil {
            var parmNum: Int32 = 0

            parmNum = 0
            while parmNum < MAX_PARMS {
                // Raven's first test is `ent->parms->parm[parmNum]`.
                // Raven's second test is `ent->parms->parm[parmNum][0]`.
                if !ent.parms!.parm[parmNum].isEmpty {
                    Q3_SetParm(newent!.s.number, parmNum, ent.parms!.parm[parmNum])
                }
                parmNum += 1
            }
        }
        //FIXME: copy cameraGroup, store mine in message or other string field

        //set origin
        newent!.s.pos.trType = TR_INTERPOLATE
        newent!.s.pos.trTime = level.time
        newent!.s.pos.trBase = newent!.r.currentOrigin
        newent!.s.pos.trDelta = vec3_t()
        newent!.s.pos.trDuration = 0
        //set angles
        newent!.s.apos.trType = TR_INTERPOLATE
        newent!.s.apos.trTime = level.time
        //VectorCopy( newent->r.currentOrigin, newent->s.apos.trBase );
        //Why was the origin being used as angles? Typo I'm assuming -rww
        newent!.s.apos.trBase = newent!.s.angles

        newent!.s.apos.trDelta = vec3_t()
        newent!.s.apos.trDuration = 0

        newent!.NPC!.combatPoint = -1

        newent!.flags |= FL_NOTARGET //So he's ignored until he's fully spawned
        newent!.s.eFlags |= EF_NODRAW //So he's ignored until he's fully spawned

        newent!.think = Think.NPC_Begin
        newent!.nextthink = level.time + FRAMETIME
        NPC_DefaultScriptFlags(newent!)

        //copy over team variables, too
        newent!.s.shouldtarget = ent.s.shouldtarget
        newent!.s.teamowner = ent.s.teamowner
        newent!.alliedTeam = ent.alliedTeam
        newent!.teamnodmg = ent.teamnodmg
        if ent.team != nil && !ent.team!.isEmpty {
            //specified team directly?
            newent!.client!.sess.sessionTeam = atoi(ent.team!)
        } else if newent!.s.teamowner != TEAM_FREE {
            newent!.client!.sess.sessionTeam = newent!.s.teamowner
        } else if newent!.alliedTeam != TEAM_FREE {
            newent!.client!.sess.sessionTeam = newent!.alliedTeam
        } else if newent!.teamnodmg != TEAM_FREE {
            newent!.client!.sess.sessionTeam = newent!.teamnodmg
        } else {
            newent!.client!.sess.sessionTeam = TEAM_FREE
        }
        newent!.client!.ps.persistant[PERS_TEAM] = newent!.client!.sess.sessionTeam

        trap_LinkEntity(newent!)

        if ent.use == nil {
            if ent.target != nil {
                //use any target we're pointed at
                G_UseTargets(ent, ent)
            }
            if ent.closetarget != nil {
                //last guy should fire this target when he dies
                newent!.target = ent.closetarget
            }
            ent.targetname = nil
            //why not remove me...?  Because of all the string pointers?  Just do G_NewStrings?
            G_FreeEntity(ent) //bye!
        }

    }
    if (ent.spawnflags & NSF_DROP_TO_FLOOR) != 0 {
        G_SetOrigin(ent, &saveOrg)
    }

    return newent
}

/// Source: oracle/codemp/game/NPC_spawn.c:1765
func NPC_Spawn_Go(_ ent: Entity) {
    NPC_Spawn_Do(ent)
}

/// Source: oracle/codemp/game/NPC_spawn.c:1814
func NPC_ShySpawn(_ ent: Entity) {
    ent.nextthink = level.time + SHY_THINK_TIME
    ent.think = Think.NPC_ShySpawn

    //rwwFIXMEFIXME: Care about other clients not just 0?
    if DistanceSquared(g_entities[0].r.currentOrigin, ent.r.currentOrigin) <= SHY_SPAWN_DISTANCE_SQR {
        return
    }

    if (InFOV(ent, g_entities[0], 80, 64)) {
        if (NPC_ClearLOS2(g_entities[0], ent.r.currentOrigin)) {
            return
        }
    }

    ent.think = nil
    ent.nextthink = 0

    NPC_Spawn_Go(ent)
}

/// Source: oracle/codemp/game/NPC_spawn.c:1839
func NPC_Spawn(_ ent: Entity, _ other: Entity, _ activator: Entity) {
    //delay before spawning NPC
    if ent.delay != 0 {
        /*		//Stasis does an extra step
        if ( Q_stricmp( ent->classname, "NPC_Stasis" ) == 0 )
        {
        if ( NPC_StasisSpawn_Go( ent ) == qfalse )
        return;
        }
        */
        if (ent.spawnflags & 2048) != 0 {
            ent.think = Think.NPC_ShySpawn
        } else {
            ent.think = Think.NPC_Spawn_Go
        }

        ent.nextthink = level.time + ent.delay
    } else {
        if (ent.spawnflags & 2048) != 0 {
            NPC_ShySpawn(ent)
        } else {
            NPC_Spawn_Do(ent)
        }
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:1961
func NPC_PrecacheType(_ NPC_type: inout JKAShared.CharBuf) {
    let fakespawner: Entity? = G_Spawn()
    if fakespawner != nil {
        fakespawner!.NPC_type = String(NPC_type)
        NPC_Precache(fakespawner!)
        //NOTE: does the spawner have to stay around to send any precached info to the clients...?
        G_FreeEntity(fakespawner!)
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:1973
func SP_NPC_spawner(_ `self`: Entity) {
    var t: Int32 = 0

    if g_allowNPC.integer == 0 {
        `self`.think = Think.G_FreeEntity
        `self`.nextthink = level.time
        return
    }
    if `self`.fullName == nil || `self`.fullName!.isEmpty {
        //FIXME: make an index into an external string table for localization
        `self`.fullName = "Humanoid Lifeform"
    }

    //register/precache the models needed for this NPC, not anymore
    //self->classname = "NPC_spawner";

    if `self`.count == 0 {
        `self`.count = 1
    }

    do {
        //Stop loading of certain extra sounds
        var garbage: Int32 = 0

        if G_SpawnInt("noBasicSounds", "0", &garbage) {
            `self`.r.svFlags |= SVF_NO_BASIC_SOUNDS
        }
        if G_SpawnInt("noCombatSounds", "0", &garbage) {
            `self`.r.svFlags |= SVF_NO_COMBAT_SOUNDS
        }
        if G_SpawnInt("noExtraSounds", "0", &garbage) {
            `self`.r.svFlags |= SVF_NO_EXTRA_SOUNDS
        }
    }

    if `self`.wait == 0 {
        `self`.wait = 500
    } else {
        `self`.wait *= 1000 //1 = 1 msec, 1000 = 1 sec
    }

    `self`.delay *= 1000 //1 = 1 msec, 1000 = 1 sec

    G_SpawnInt("showhealth", "0", &t)
    if t != 0 {
        `self`.s.shouldtarget = true
    }
    /*
    if ( self->delay > 0 )
    {
    self->r.svFlags |= SVF_NPC_PRECACHE;
    }
    */
    //rwwFIXMEFIXME: support for this flag?

    //We have to load the animation.cfg now because spawnscripts are going to want to set anims and we need to know their length and if they're valid
    NPC_PrecacheAnimationCFG(`self`.NPC_type!)

    //rww - can't cheat and do this on the client like in SP, so I'm doing this.
    NPC_Precache(`self`)

    if `self`.targetname != nil {
        //Wait for triggering
        `self`.use = Use.NPC_Spawn
        //	self->r.svFlags |= SVF_NPC_PRECACHE;//FIXME: precache my weapons somehow?

        //NPC_PrecacheModels( self->NPC_type );
    } else {
        //NOTE: auto-spawners never check for shy spawning
        //if ( spawning )
        if 1 != 0 {
            //in entity spawn stage - map starting up
            `self`.think = Think.NPC_Spawn_Go
            `self`.nextthink = level.time + START_TIME_REMOVE_ENTS + 50
        } else {
            //else spawn right now
            NPC_Spawn(`self`, `self`, `self`)
        }
    }

    //FIXME: store cameraGroup somewhere else and apply to spawned NPCs' cameraGroup
    //Or just don't include NPC_spawners in cameraGroupings
}

/**
```
QUAKED NPC_Vehicle (1 0 0) (-16 -16 -24) (16 16 32) NO_PILOT_DIE SUSPENDED x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
NO_PILOT_DIE - die after certain amount of time of not having a pilot
SUSPENDED - Fighters: Don't drop until someone gets in it (this only works as long as no-nw has *ever* ridden the vehicle, to simulate ships that are suspended-docked) - note: ships inside trigger_spaces do not drop when unoccupied
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

set NPC_type to vehicle name in vehicles.dat

"dropTime" use with SUSPENDED - if set, the vehicle will drop straight down for this number of seconds before flying forward
"dmg" use with NO_PILOT_DIE - delay in milliseconds for ship to explode if no pilot (default 10000)
"speed" use with NO_PILOT_DIE - distance for pilot to get away from ship after dismounting before it starts counting down the death timer
"model2" - if the vehicle can have a droid (has "*droidunit" tag), this NPC will be spawned and placed there - note: game will automatically use the one specified in the .veh file (if any) or, absent that, it will use an R2D2 or R5D2 NPC)

showhealth - set to 1 to show health bar on this entity when crosshair is over it

teamowner - crosshair shows green for this team, red for opposite team
	0 - none
	1 - red
	2 - blue

teamuser - only this team can use this NPC
	0 - none
	1 - red
	2 - blue

teamnodmg - team that NPC does not take damage from (turrets and other auto-defenses that have "alliedTeam" set to this team won't target this NPC)
	0 - none
	1 - red
	2 - blue
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2103
func NPC_VehiclePrecache(_ spawner: Entity) -> Bool {
    var droidNPCType: String? = nil
    //This will precache the vehicle
    var pVehInfo: VehicleInfo?
    let iVehIndex: Int32 = BG_VehicleGetIndex(spawner.NPC_type!)
    if iVehIndex == VEHICLE_NONE {
        //fixme: error msg?
        return false
    }

    G_ModelIndex(va("$%s", spawner.NPC_type!)) //make sure the thing is frickin precached
    //now cache his model/skin/anim config
    pVehInfo = g_vehicleInfo[iVehIndex]
    if pVehInfo!.model != nil && !pVehInfo!.model!.isEmpty {
        var tempG2: OpaquePointer? = nil
        var skin: Int32 = 0
        if pVehInfo!.skin != nil && !pVehInfo!.skin!.isEmpty {
            skin = trap_R_RegisterSkin(va("models/players/%s/model_%s.skin", pVehInfo!.model!, pVehInfo!.skin!))
        }
        trap_G2API_InitGhoul2Model(&tempG2, va("models/players/%s/model.glm", pVehInfo!.model!), 0, skin, 0, 0, 0)
        if tempG2 != nil {
            //now, cache the anim config.
            var GLAName = CharBuf(1024)

            GLAName[0] = 0
            strcpy(&GLAName, trap_G2API_GetGLAName(tempG2, 0))

            if GLAName[0] != 0 {
                if let slash = Q_strrchr(String(GLAName), Int32(ascii: "/")) {
                    strcpy(&GLAName, "/animation.cfg", at: slash)
                    BG_ParseAnimationFile(String(GLAName), nil, false)
                }
            }
            trap_G2API_CleanGhoul2Models(&tempG2)
        }
    }

    //also precache the droid NPC if there is one
    if spawner.model2 != nil && !spawner.model2!.isEmpty {
        droidNPCType = spawner.model2
    } else if g_vehicleInfo[iVehIndex].droidNPC != nil && !g_vehicleInfo[iVehIndex].droidNPC!.isEmpty {
        droidNPCType = g_vehicleInfo[iVehIndex].droidNPC
    }

    if droidNPCType != nil {
        if Q_stricmp("random", droidNPCType!) == 0
            || Q_stricmp("default", droidNPCType!) == 0 {
            //precache both r2 and r5, as defaults
            var r2d2 = CharBuf("r2d2")
            NPC_PrecacheType(&r2d2)
            var r5d2 = CharBuf("r5d2")
            NPC_PrecacheType(&r5d2)
        } else {
            var buf = CharBuf(droidNPCType!)
            NPC_PrecacheType(&buf)
        }
    }
    return true
}

/// Source: oracle/codemp/game/NPC_spawn.c:2175
func NPC_VehicleSpawnUse(_ `self`: Entity, _ other: Entity, _ activator: Entity) {
    if `self`.delay != 0 {
        `self`.think = Think.G_VehicleSpawn
        `self`.nextthink = level.time + `self`.delay
    } else {
        G_VehicleSpawn(`self`)
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:2188
func SP_NPC_Vehicle(_ `self`: Entity) {
    var dropTime: Float = 0
    var t: Int32 = 0
    if `self`.NPC_type == nil {
        `self`.NPC_type = "swoop"
    }

    if `self`.classname == nil {
        `self`.classname = "NPC_Vehicle"
    }

    if `self`.wait == 0 {
        `self`.wait = 500
    } else {
        `self`.wait *= 1000 //1 = 1 msec, 1000 = 1 sec
    }
    `self`.delay *= 1000 //1 = 1 msec, 1000 = 1 sec

    G_SetOrigin(`self`, &`self`.s.origin)
    G_SetAngles(`self`, `self`.s.angles)
    G_SpawnFloat("dropTime", "0", &dropTime)
    if dropTime != 0 {
        `self`.fly_sound_debounce_time = Int32(ceil(Double(dropTime) * 1000.0))
    }

    G_SpawnInt("showhealth", "0", &t)
    if t != 0 {
        `self`.s.shouldtarget = true
    }
    //FIXME: PRECACHE!!!

    if `self`.targetname != nil {
        if !NPC_VehiclePrecache(`self`) {
            //FIXME: err msg?
            G_FreeEntity(`self`)
            return
        }
        `self`.use = Use.NPC_VehicleSpawnUse
    } else {
        if `self`.delay != 0 {
            if !NPC_VehiclePrecache(`self`) {
                //FIXME: err msg?
                G_FreeEntity(`self`)
                return
            }
            `self`.think = Think.G_VehicleSpawn
            `self`.nextthink = level.time + `self`.delay
        } else {
            G_VehicleSpawn(`self`)
        }
    }
}

/**
```
QUAKED NPC_Kyle (1 0 0) (-16 -16 -24) (16 16 32) x RIFLEMAN PHASER TRICORDER DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2338
func SP_NPC_Kyle(_ `self`: Entity) {
    `self`.NPC_type = "Kyle"

    WP_SetSaberModel(nil, CLASS_KYLE)

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Lando(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2354
func SP_NPC_Lando(_ `self`: Entity) {
    `self`.NPC_type = "Lando"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Jan(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2368
func SP_NPC_Jan(_ `self`: Entity) {
    `self`.NPC_type = "Jan"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Luke(1 0 0) (-16 -16 -24) (16 16 40) x x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2382
func SP_NPC_Luke(_ `self`: Entity) {
    `self`.NPC_type = "Luke"

    WP_SetSaberModel(nil, CLASS_LUKE)

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_MonMothma(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2398
func SP_NPC_MonMothma(_ `self`: Entity) {
    `self`.NPC_type = "MonMothma"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Tavion (1 0 0) (-16 -16 -24) (16 16 32) x x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2412
func SP_NPC_Tavion(_ `self`: Entity) {
    `self`.NPC_type = "Tavion"

    WP_SetSaberModel(nil, CLASS_TAVION)

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Tavion_New (1 0 0) (-16 -16 -24) (16 16 32) SCEPTER SITH_SWORD x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
Has a red lightsaber and force powers, uses her saber style from JK2

SCEPTER - Has a red lightsaber and force powers, Ragnos' Scepter in left hand, uses dual saber style and occasionally attacks with Scepter
SITH_SWORD - Has Ragnos' Sith Sword in right hand and force powers, uses strong style
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2432
func SP_NPC_Tavion_New(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        `self`.NPC_type = "tavion_scepter"
    } else if (`self`.spawnflags & 2) != 0 {
        `self`.NPC_type = "tavion_sith_sword"
    } else {
        `self`.NPC_type = "tavion_new"
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Alora (1 0 0) (-16 -16 -24) (16 16 32) DUAL x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
Lightsaber and level 2 force powers, 300 health

DUAL - Dual sabers and level 3 force powers, 500 health
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2460
func SP_NPC_Alora(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        `self`.NPC_type = "alora_dual"
    } else {
        `self`.NPC_type = "alora"
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Reborn_New(1 0 0) (-16 -16 -24) (16 16 40) DUAL STAFF WEAK x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY

Reborn is an excellent lightsaber fighter, acrobatic and uses force powers.  Full-length red saber, 200 health.

DUAL - Use 2 shorter sabers
STAFF - Uses a saber staff
WEAK - Is a bit less tough
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2487
func SP_NPC_Reborn_New(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 4) != 0 {
            //weaker guys
            if (`self`.spawnflags & 1) != 0 {
                `self`.NPC_type = "reborn_dual2"
            } else if (`self`.spawnflags & 2) != 0 {
                `self`.NPC_type = "reborn_staff2"
            } else {
                `self`.NPC_type = "reborn_new2"
            }
        } else {
            if (`self`.spawnflags & 1) != 0 {
                `self`.NPC_type = "reborn_dual"
            } else if (`self`.spawnflags & 2) != 0 {
                `self`.NPC_type = "reborn_staff"
            } else {
                `self`.NPC_type = "reborn_new"
            }
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Cultist_Saber(1 0 0) (-16 -16 -24) (16 16 40) MED STRONG ALL THROW CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
Uses a saber and no force powers.  100 health.

default fencer uses fast style - weak, but can attack rapidly.  Good defense.

MED - Uses medium style - average speed and attack strength, average defense.
STRONG - Uses strong style, slower than others, but can do a lot of damage with one blow.  Weak defense.
ALL - Knows all 3 styles, switches between them, good defense.
THROW - can throw their saber (level 2) - reduces their defense some (can use this spawnflag alone or in combination with any *one* of the previous 3 spawnflags)

CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2542
func SP_NPC_Cultist_Saber(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_med_throw"
            } else {
                `self`.NPC_type = "cultist_saber_med"
            }
        } else if (`self`.spawnflags & 2) != 0 {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_strong_throw"
            } else {
                `self`.NPC_type = "cultist_saber_strong"
            }
        } else if (`self`.spawnflags & 2) != 0 {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_all_throw"
            } else {
                `self`.NPC_type = "cultist_saber_all"
            }
        } else {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_throw"
            } else {
                `self`.NPC_type = "cultist_saber"
            }
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Cultist_Saber_Powers(1 0 0) (-16 -16 -24) (16 16 40) MED STRONG ALL THROW CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
Uses a saber and has a couple low-level powers.  150 health.

default fencer uses fast style - weak, but can attack rapidly.  Good defense.

MED - Uses medium style - average speed and attack strength, average defense.
STRONG - Uses strong style, slower than others, but can do a lot of damage with one blow.  Weak defense.
ALL - Knows all 3 styles, switches between them, good defense.
THROW - can throw their saber (level 2) - reduces their defense some (can use this spawnflag alone or in combination with any *one* of the previous 3 spawnflags)

CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2611
func SP_NPC_Cultist_Saber_Powers(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_med_throw2"
            } else {
                `self`.NPC_type = "cultist_saber_med2"
            }
        } else if (`self`.spawnflags & 2) != 0 {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_strong_throw2"
            } else {
                `self`.NPC_type = "cultist_saber_strong2"
            }
        } else if (`self`.spawnflags & 2) != 0 {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_all_throw2"
            } else {
                `self`.NPC_type = "cultist_saber_all2"
            }
        } else {
            if (`self`.spawnflags & 8) != 0 {
                `self`.NPC_type = "cultist_saber_throw"
            } else {
                `self`.NPC_type = "cultist_saber2"
            }
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Cultist(1 0 0) (-16 -16 -24) (16 16 40) SABER GRIP LIGHTNING DRAIN CEILING CINEMATIC NOTSOLID STARTINSOLID SHY

Cultist uses a blaster and force powers.  40 health.

SABER - Uses a saber and no force powers
GRIP - Uses no weapon and grip, push and pull
LIGHTNING - Uses no weapon and lightning and push
DRAIN - Uses no weapons and drain and push

CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2679
func SP_NPC_Cultist(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = nil
            `self`.spawnflags = 0 //fast, no throw
            switch Q_irand(0, 2) {
            case 0:
                `self`.spawnflags |= 1

            case 1:
                `self`.spawnflags |= 2

            case 2:
                `self`.spawnflags |= 4

            default:
                break
            }
            if Q_irand(0, 1) != 0 {
                //throw
                `self`.spawnflags |= 8
            }
            SP_NPC_Cultist_Saber(`self`)
            return
        } else if (`self`.spawnflags & 2) != 0 {
            `self`.NPC_type = "cultist_grip"
        } else if (`self`.spawnflags & 4) != 0 {
            `self`.NPC_type = "cultist_lightning"
        } else if (`self`.spawnflags & 8) != 0 {
            `self`.NPC_type = "cultist_drain"
        } else {
            `self`.NPC_type = "cultist"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Cultist_Commando(1 0 0) (-16 -16 -24) (16 16 40) x x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY

Cultist uses dual blaster pistols and force powers.  40 health.

CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2737
func SP_NPC_Cultist_Commando(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        `self`.NPC_type = "cultistcommando"
    }
    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Cultist_Destroyer(1 0 0) (-16 -16 -24) (16 16 40) x x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY

Cultist has no weapons, runs up to you chanting & building up a Force Destruction blast - when gets to you, screams & explodes

CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2755
func SP_NPC_Cultist_Destroyer(_ `self`: Entity) {
    `self`.NPC_type = "cultist" //"cultist_explode";
    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Reelo(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2768
func SP_NPC_Reelo(_ `self`: Entity) {
    `self`.NPC_type = "Reelo"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Galak(1 0 0) (-16 -16 -24) (16 16 40) MECH x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
MECH - will be the armored Galak

DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2784
func SP_NPC_Galak(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        `self`.NPC_type = "Galak_Mech"
        NPC_GalakMech_Precache()
    } else {
        `self`.NPC_type = "Galak"
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Desann(1 0 0) (-16 -16 -24) (16 16 40) x x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2806
func SP_NPC_Desann(_ `self`: Entity) {
    `self`.NPC_type = "Desann"

    WP_SetSaberModel(nil, CLASS_DESANN)

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Bartender(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2822
func SP_NPC_Bartender(_ `self`: Entity) {
    `self`.NPC_type = "Bartender"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_MorganKatarn(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2836
func SP_NPC_MorganKatarn(_ `self`: Entity) {
    `self`.NPC_type = "MorganKatarn"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Jedi(1 0 0) (-16 -16 -24) (16 16 40) TRAINER x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
TRAINER - Special Jedi- instructor
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Ally Jedi NPC Buddy - tags along with player
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2857
func SP_NPC_Jedi(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "jeditrainer"
        } else {
            /*
            if ( !Q_irand( 0, 2 ) )
            {
            self->NPC_type = "JediF";
            }
            else
            */
            if Q_irand(0, 1) != 0 {
                `self`.NPC_type = "Jedi"
            } else {
                `self`.NPC_type = "Jedi2"
            }
        }
    }

    WP_SetSaberModel(nil, CLASS_JEDI)

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Prisoner(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2896
func SP_NPC_Prisoner(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if Q_irand(0, 1) != 0 {
            `self`.NPC_type = "Prisoner"
        } else {
            `self`.NPC_type = "Prisoner2"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Rebel(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2920
func SP_NPC_Rebel(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if Q_irand(0, 1) != 0 {
            `self`.NPC_type = "Rebel"
        } else {
            `self`.NPC_type = "Rebel2"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Stormtrooper(1 0 0) (-16 -16 -24) (16 16 40) OFFICER COMMANDER ALTOFFICER ROCKET DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
30 health, blaster

OFFICER - 60 health, flechette
COMMANDER - 60 health, heavy repeater
ALTOFFICER - 60 health, alt-fire flechette (grenades)
ROCKET - 60 health, rocket launcher

DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:2955
func SP_NPC_Stormtrooper(_ `self`: Entity) {
    if (`self`.spawnflags & 8) != 0 {
        //rocketer
        `self`.NPC_type = "rockettrooper"
    } else if (`self`.spawnflags & 4) != 0 {
        //alt-officer
        `self`.NPC_type = "stofficeralt"
    } else if (`self`.spawnflags & 2) != 0 {
        //commander
        `self`.NPC_type = "stcommander"
    } else if (`self`.spawnflags & 1) != 0 {
        //officer
        `self`.NPC_type = "stofficer"
    } else {
        //regular trooper
        if Q_irand(0, 1) != 0 {
            `self`.NPC_type = "StormTrooper"
        } else {
            `self`.NPC_type = "StormTrooper2"
        }
    }

    SP_NPC_spawner(`self`)
}

/// Source: oracle/codemp/game/NPC_spawn.c:2987
func SP_NPC_StormtrooperOfficer(_ `self`: Entity) {
    `self`.spawnflags |= 1
    SP_NPC_Stormtrooper(`self`)
}

/**
```
QUAKED NPC_Snowtrooper(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
30 health, blaster

DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3001
func SP_NPC_Snowtrooper(_ `self`: Entity) {
    `self`.NPC_type = "snowtrooper"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Tie_Pilot(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
30 health, blaster

DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3016
func SP_NPC_Tie_Pilot(_ `self`: Entity) {
    `self`.NPC_type = "stormpilot"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Ugnaught(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3030
func SP_NPC_Ugnaught(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if Q_irand(0, 1) != 0 {
            `self`.NPC_type = "Ugnaught"
        } else {
            `self`.NPC_type = "Ugnaught2"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Jawa(1 0 0) (-16 -16 -24) (16 16 40) ARMED x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
ARMED - starts with the Jawa gun in-hand

DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3056
func SP_NPC_Jawa(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "jawa_armed"
        } else {
            `self`.NPC_type = "jawa"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Gran(1 0 0) (-16 -16 -24) (16 16 40) SHOOTER BOXER x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
Uses grenade

SHOOTER - uses blaster instead of
BOXER - uses fists only
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3084
func SP_NPC_Gran(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "granshooter"
        } else if (`self`.spawnflags & 2) != 0 {
            `self`.NPC_type = "granboxer"
        } else {
            if Q_irand(0, 1) != 0 {
                `self`.NPC_type = "gran"
            } else {
                `self`.NPC_type = "gran2"
            }
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Rodian(1 0 0) (-16 -16 -24) (16 16 40) BLASTER NO_HIDE x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
BLASTER uses a blaster instead of sniper rifle, different skin
NO_HIDE (only applicable with snipers) does not duck and hide between shots
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3121
func SP_NPC_Rodian(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "rodian2"
        } else {
            `self`.NPC_type = "rodian"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Weequay(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3145
func SP_NPC_Weequay(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        switch Q_irand(0, 3) {
        case 0:
            `self`.NPC_type = "Weequay"

        case 1:
            `self`.NPC_type = "Weequay2"

        case 2:
            `self`.NPC_type = "Weequay3"

        case 3:
            `self`.NPC_type = "Weequay4"

        default:
            break
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Trandoshan(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3176
func SP_NPC_Trandoshan(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        `self`.NPC_type = "Trandoshan"
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Tusken(1 0 0) (-16 -16 -24) (16 16 40) SNIPER x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3193
func SP_NPC_Tusken(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "tuskensniper"
        } else {
            `self`.NPC_type = "tusken"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Noghri(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3217
func SP_NPC_Noghri(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        `self`.NPC_type = "noghri"
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_SwampTrooper(1 0 0) (-16 -16 -24) (16 16 40) REPEATER x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
REPEATER - Swaptrooper who uses the repeater
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3235
func SP_NPC_SwampTrooper(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "SwampTrooper2"
        } else {
            `self`.NPC_type = "SwampTrooper"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Imperial(1 0 0) (-16 -16 -24) (16 16 40) OFFICER COMMANDER x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY

Greyshirt grunt, uses blaster pistol, 20 health.

OFFICER - Brownshirt Officer, uses blaster rifle, 40 health
COMMANDER - Blackshirt Commander, uses rapid-fire blaster rifle, 80 healt

"message" - if a COMMANDER, turns on his key surface.  This is the name of the key you get when you walk over his body.  This must match the "message" field of the func_security_panel you want this key to open.  Set to "goodie" to have him carrying a goodie key that player can use to operate doors with "GOODIE" spawnflag.

DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3267
func SP_NPC_Imperial(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "ImpOfficer"
        } else if (`self`.spawnflags & 2) != 0 {
            `self`.NPC_type = "ImpCommander"
        } else {
            `self`.NPC_type = "Imperial"
        }
    }

    /*
    if ( self->message )
    {//may drop a key, precache the key model and pickup sound
    G_SoundIndex( "sound/weapons/key_pkup.wav" );
    if ( !Q_stricmp( "goodie", self->message ) )
    {
    RegisterItem( FindItemForInventory( INV_GOODIE_KEY ) );
    }
    else
    {
    RegisterItem( FindItemForInventory( INV_SECURITY_KEY ) );
    }
    }
    */
    //rwwFIXMEFIXME: Allow goodie keys
    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_ImpWorker(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3310
func SP_NPC_ImpWorker(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if Q_irand(0, 2) == 0 {
            `self`.NPC_type = "ImpWorker"
        } else if Q_irand(0, 1) != 0 {
            `self`.NPC_type = "ImpWorker2"
        } else {
            `self`.NPC_type = "ImpWorker3"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_BespinCop(1 0 0) (-16 -16 -24) (16 16 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3338
func SP_NPC_BespinCop(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if Q_irand(0, 1) == 0 {
            `self`.NPC_type = "BespinCop"
        } else {
            `self`.NPC_type = "BespinCop2"
        }
    }

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Reborn(1 0 0) (-16 -16 -24) (16 16 40) FORCE FENCER ACROBAT BOSS CEILING CINEMATIC NOTSOLID STARTINSOLID SHY

Default Reborn is A poor lightsaber fighter, acrobatic and uses no force powers.  Yellow saber, 40 health.

FORCE - Uses force powers but is not the best lightsaber fighter and not acrobatic.  Purple saber, 75 health.
FENCER - A good lightsaber fighter, but not acrobatic and uses no force powers.  Yellow saber, 100 health.
ACROBAT - quite acrobatic, but not the best lightsaber fighter and uses no force powers.  Red saber, 100 health.
BOSS - quite acrobatic, good lightsaber fighter and uses force powers.  Orange saber, 150 health.

NOTE: Saber colors are temporary until they have different by skins to tell them apart

CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3372
func SP_NPC_Reborn(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if (`self`.spawnflags & 1) != 0 {
            `self`.NPC_type = "rebornforceuser"
        } else if (`self`.spawnflags & 2) != 0 {
            `self`.NPC_type = "rebornfencer"
        } else if (`self`.spawnflags & 4) != 0 {
            `self`.NPC_type = "rebornacrobat"
        } else if (`self`.spawnflags & 8) != 0 {
            `self`.NPC_type = "rebornboss"
        } else {
            `self`.NPC_type = "reborn"
        }
    }

    WP_SetSaberModel(nil, CLASS_REBORN)
    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_ShadowTrooper(1 0 0) (-16 -16 -24) (16 16 40) x x x x CEILING CINEMATIC NOTSOLID STARTINSOLID SHY
CEILING - Sticks to the ceiling until he sees an enemy or takes pain
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3409
func SP_NPC_ShadowTrooper(_ `self`: Entity) {
    if `self`.NPC_type == nil {
        if Q_irand(0, 1) == 0 {
            `self`.NPC_type = "ShadowTrooper"
        } else {
            `self`.NPC_type = "ShadowTrooper2"
        }
    }

    NPC_ShadowTrooper_Precache()
    WP_SetSaberModel(nil, CLASS_SHADOWTROOPER)

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Murjj (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3439
func SP_NPC_Monster_Murjj(_ `self`: Entity) {
    `self`.NPC_type = "Murjj"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Swamp (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3453
func SP_NPC_Monster_Swamp(_ `self`: Entity) {
    `self`.NPC_type = "Swamp"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Howler (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3467
func SP_NPC_Monster_Howler(_ `self`: Entity) {
    `self`.NPC_type = "howler"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_MineMonster (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3481
func SP_NPC_MineMonster(_ `self`: Entity) {
    `self`.NPC_type = "minemonster"

    SP_NPC_spawner(`self`)
    NPC_MineMonster_Precache()
}

/**
```
QUAKED NPC_Monster_Claw (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3496
func SP_NPC_Monster_Claw(_ `self`: Entity) {
    `self`.NPC_type = "Claw"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Glider (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3510
func SP_NPC_Monster_Glider(_ `self`: Entity) {
    `self`.NPC_type = "Glider"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Flier2 (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3524
func SP_NPC_Monster_Flier2(_ `self`: Entity) {
    `self`.NPC_type = "Flier2"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Lizard (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3538
func SP_NPC_Monster_Lizard(_ `self`: Entity) {
    `self`.NPC_type = "Lizard"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Fish (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3552
func SP_NPC_Monster_Fish(_ `self`: Entity) {
    `self`.NPC_type = "Fish"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Wampa (1 0 0) (-12 -12 -24) (12 12 40) WANDER SEARCH x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
WANDER - When I don't have an enemy, I'll just wander the waypoint network aimlessly
SEARCH - When I don't have an enemy, I'll go back and forth between the nearest waypoints, looking for enemies
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3568
func SP_NPC_Monster_Wampa(_ `self`: Entity) {
    `self`.NPC_type = "wampa"

    NPC_Wampa_Precache()

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Monster_Rancor (1 0 0) (-30 -30 -24) (30 30 104) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3584
func SP_NPC_Monster_Rancor(_ `self`: Entity) {
    `self`.NPC_type = "rancor"

    SP_NPC_spawner(`self`)
}

/**
```
QUAKED NPC_Droid_Interrogator (1 0 0) (-12 -12 -24) (12 12 0) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3602
func SP_NPC_Droid_Interrogator(_ `self`: Entity) {
    `self`.NPC_type = "interrogator"

    SP_NPC_spawner(`self`)

    NPC_Interrogator_Precache(`self`)
}

/**
```
QUAKED NPC_Droid_Probe (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Imperial Probe Droid - the multilegged floating droid that Han and Chewie shot on the ice planet Hoth
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3620
func SP_NPC_Droid_Probe(_ `self`: Entity) {
    `self`.NPC_type = "probe"

    SP_NPC_spawner(`self`)

    NPC_Probe_Precache()
}

/**
```
QUAKED NPC_Droid_Mark1 (1 0 0) (-36 -36 -24) (36 36 80) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Big walking droid
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3639
func SP_NPC_Droid_Mark1(_ `self`: Entity) {
    `self`.NPC_type = "mark1"

    SP_NPC_spawner(`self`)

    NPC_Mark1_Precache()
}

/**
```
QUAKED NPC_Droid_Mark2 (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Small rolling droid with one gun.
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3658
func SP_NPC_Droid_Mark2(_ `self`: Entity) {
    `self`.NPC_type = "mark2"

    SP_NPC_spawner(`self`)

    NPC_Mark2_Precache()
}

/**
```
QUAKED NPC_Droid_ATST (1 0 0) (-40 -40 -24) (40 40 248) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3674
func SP_NPC_Droid_ATST(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        `self`.NPC_type = "atst_vehicle"
    } else {
        `self`.NPC_type = "atst"
    }

    SP_NPC_spawner(`self`)

    NPC_ATST_Precache()
}

/**
```
QUAKED NPC_Droid_Remote (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Remote Droid - the floating round droid used by Obi Wan to train Luke about the force while on the Millenium Falcon.
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3699
func SP_NPC_Droid_Remote(_ `self`: Entity) {
    `self`.NPC_type = "remote"

    SP_NPC_spawner(`self`)

    NPC_Remote_Precache()
}

/**
```
QUAKED NPC_Droid_Seeker (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Seeker Droid - floating round droids that shadow troopers spawn
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3717
func SP_NPC_Droid_Seeker(_ `self`: Entity) {
    `self`.NPC_type = "seeker"

    SP_NPC_spawner(`self`)

    NPC_Seeker_Precache()
}

/**
```
QUAKED NPC_Droid_Sentry (1 0 0) (-24 -24 -24) (24 24 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Sentry Droid - Large, armored floating Imperial droids with 3 forward-facing gun turrets
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3735
func SP_NPC_Droid_Sentry(_ `self`: Entity) {
    `self`.NPC_type = "sentry"

    SP_NPC_spawner(`self`)

    NPC_Sentry_Precache()
}

/**
```
QUAKED NPC_Droid_Gonk (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Gonk Droid - the droid that looks like a walking ice machine. Was in the Jawa land crawler, walking around talking to itself.

NOTARGET by default
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3755
func SP_NPC_Droid_Gonk(_ `self`: Entity) {
    `self`.NPC_type = "gonk"

    SP_NPC_spawner(`self`)

    //precache the Gonk sounds
    NPC_Gonk_Precache()
}

/**
```
QUAKED NPC_Droid_Mouse (1 0 0) (-12 -12 -24) (12 12 40) x x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

Mouse Droid - small, box shaped droid, first seen on the Death Star. Chewie yelled at it and it backed up and ran away.

NOTARGET by default
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3776
func SP_NPC_Droid_Mouse(_ `self`: Entity) {
    `self`.NPC_type = "mouse"

    SP_NPC_spawner(`self`)

    //precache the Mouse sounds
    NPC_Mouse_Precache()
}

/**
```
QUAKED NPC_Droid_R2D2 (1 0 0) (-12 -12 -24) (12 12 40) IMPERIAL x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

R2D2 Droid - you probably know this one already.

NOTARGET by default
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3798
func SP_NPC_Droid_R2D2(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        //imperial skin
        `self`.NPC_type = "r2d2_imp"
    } else {
        `self`.NPC_type = "r2d2"
    }

    SP_NPC_spawner(`self`)

    NPC_R2D2_Precache()
}

/**
```
QUAKED NPC_Droid_R5D2 (1 0 0) (-12 -12 -24) (12 12 40) IMPERIAL ALWAYSDIE x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
ALWAYSDIE - won't go into spinning zombie AI when at low health.
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

R5D2 Droid - the droid originally chosen by Uncle Owen until it blew a bad motivator, and they took R2D2 instead.

NOTARGET by default
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3826
func SP_NPC_Droid_R5D2(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        //imperial skin
        `self`.NPC_type = "r5d2_imp"
    } else {
        `self`.NPC_type = "r5d2"
    }

    SP_NPC_spawner(`self`)

    NPC_R5D2_Precache()
}

/**
```
QUAKED NPC_Droid_Protocol (1 0 0) (-12 -12 -24) (12 12 40) IMPERIAL x x x DROPTOFLOOR CINEMATIC NOTSOLID STARTINSOLID SHY
DROPTOFLOOR - NPC can be in air, but will spawn on the closest floor surface below it
CINEMATIC - Will spawn with no default AI (BS_CINEMATIC)
NOTSOLID - Starts not solid
STARTINSOLID - Don't try to fix if spawn in solid
SHY - Spawner is shy

NOTARGET by default
```
*/
/// Source: oracle/codemp/game/NPC_spawn.c:3851
func SP_NPC_Droid_Protocol(_ `self`: Entity) {
    if (`self`.spawnflags & 1) != 0 {
        //imperial skin
        `self`.NPC_type = "protocol_imp"
    } else {
        `self`.NPC_type = "protocol"
    }

    SP_NPC_spawner(`self`)
    NPC_Protocol_Precache()
}

/// Source: oracle/codemp/game/NPC_spawn.c:3872
func NPC_SpawnType(_ ent: Entity, _ npc_type: String?, _ targetname: String?, _ isVehicle: Bool) -> Entity? {
    let NPCspawner: Entity? = G_Spawn()
    var forward = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Entity? in

        if NPCspawner == nil {
            Com_Printf(S_COLOR_RED + "NPC_Spawn Error: Out of entities!\n")
            return nil
        }

        NPCspawner!.think = Think.G_FreeEntity
        NPCspawner!.nextthink = level.time + FRAMETIME

        if npc_type == nil {
            return nil
        }

        if npc_type!.isEmpty {
            Com_Printf(S_COLOR_RED + "Error, expected one of:\n" + S_COLOR_WHITE + " NPC spawn [NPC type (from ext_data/NPCs)]\n NPC spawn vehicle [VEH type (from ext_data/vehicles)]\n")
            return nil
        }

        if ent.client == nil {
            //screw you, go away
            return nil
        }

        //rwwFIXMEFIXME: Care about who is issuing this command/other clients besides 0?
        //Spawn it at spot of first player
        //FIXME: will gib them!
        // Raven passes NULL for the `right` and `up` outputs, so the body passes scratch locals it never reads.
        var scratchRight = vec3_t()
        var scratchUp = vec3_t()
        AngleVectors(ent.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)
        VectorNormalize(&forward)
        _VectorMA(ent.r.currentOrigin, 64, forward, &end)
        trap_Trace(trace, ent.r.currentOrigin, vec3_origin, vec3_origin, end, 0, MASK_SOLID)
        end = trace.endpos
        end[2] -= 24
        trap_Trace(trace, trace.endpos, vec3_origin, vec3_origin, end, 0, MASK_SOLID)
        end = trace.endpos
        end[2] += 24
        G_SetOrigin(NPCspawner!, &end)
        NPCspawner!.s.origin = NPCspawner!.r.currentOrigin
        //set the yaw so that they face away from player
        NPCspawner!.s.angles[1] = ent.client!.ps.viewangles[1]

        trap_LinkEntity(NPCspawner!)

        NPCspawner!.NPC_type = G_NewString(npc_type!)

        if targetname != nil {
            NPCspawner!.NPC_targetname = G_NewString(targetname!)
        }

        NPCspawner!.count = 1

        NPCspawner!.delay = 0

        //NPCspawner->spawnflags |= SFB_NOTSOLID;

        //NPCspawner->playerTeam = TEAM_FREE;
        //NPCspawner->behaviorSet[BSET_SPAWN] = "common/guard";

        if isVehicle {
            NPCspawner!.classname = "NPC_Vehicle"
        }

        //call precache funcs for James' builds
        if Q_stricmp("gonk", NPCspawner!.NPC_type!) == 0 {
            NPC_Gonk_Precache()
        } else if Q_stricmp("mouse", NPCspawner!.NPC_type!) == 0 {
            NPC_Mouse_Precache()
        } else if Q_strncmp("r2d2", NPCspawner!.NPC_type!, 4) == 0 {
            NPC_R2D2_Precache()
        } else if Q_stricmp("atst", NPCspawner!.NPC_type!) == 0 {
            NPC_ATST_Precache()
        } else if Q_strncmp("r5d2", NPCspawner!.NPC_type!, 4) == 0 {
            NPC_R5D2_Precache()
        } else if Q_stricmp("mark1", NPCspawner!.NPC_type!) == 0 {
            NPC_Mark1_Precache()
        } else if Q_stricmp("mark2", NPCspawner!.NPC_type!) == 0 {
            NPC_Mark2_Precache()
        } else if Q_stricmp("interrogator", NPCspawner!.NPC_type!) == 0 {
            NPC_Interrogator_Precache(nil)
        } else if Q_stricmp("probe", NPCspawner!.NPC_type!) == 0 {
            NPC_Probe_Precache()
        } else if Q_stricmp("seeker", NPCspawner!.NPC_type!) == 0 {
            NPC_Seeker_Precache()
        } else if Q_stricmp("remote", NPCspawner!.NPC_type!) == 0 {
            NPC_Remote_Precache()
        } else if Q_strncmp("shadowtrooper", NPCspawner!.NPC_type!, 13) == 0 {
            NPC_ShadowTrooper_Precache()
        } else if Q_stricmp("minemonster", NPCspawner!.NPC_type!) == 0 {
            NPC_MineMonster_Precache()
        } else if Q_stricmp("howler", NPCspawner!.NPC_type!) == 0 {
            NPC_Howler_Precache()
        } else if Q_stricmp("sentry", NPCspawner!.NPC_type!) == 0 {
            NPC_Sentry_Precache()
        } else if Q_stricmp("protocol", NPCspawner!.NPC_type!) == 0 {
            NPC_Protocol_Precache()
        } else if Q_stricmp("galak_mech", NPCspawner!.NPC_type!) == 0 {
            NPC_GalakMech_Precache()
        } else if Q_stricmp("wampa", NPCspawner!.NPC_type!) == 0 {
            NPC_Wampa_Precache()
        }

        return (NPC_Spawn_Do(NPCspawner!))
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:4020
func NPC_Spawn_f(_ ent: Entity) {
    var npc_type = CharBuf(1024)
    var targetname = CharBuf(1024)
    var isVehicle: Bool = false

    strcpy(&npc_type, trap_Argv(2, 1024))
    if Q_stricmp("vehicle", npc_type) == 0 {
        isVehicle = true
        strcpy(&npc_type, trap_Argv(3, 1024))
        strcpy(&targetname, trap_Argv(4, 1024))
    } else {
        strcpy(&targetname, trap_Argv(3, 1024))
    }

    _ = NPC_SpawnType(ent, String(npc_type), String(targetname), isVehicle)
}

/// Source: oracle/codemp/game/NPC_spawn.c:4045
func NPC_Kill_f() {
    var n: Int32
    var player: Entity?
    var name = CharBuf(1024)
    var killTeam: team_t = TEAM_FREE
    var killNonSF: Bool = false

    strcpy(&name, trap_Argv(2, 1024))

    if name[0] == 0 {
        Com_Printf(S_COLOR_RED + "Error, Expected:\n")
        Com_Printf(S_COLOR_RED + "NPC kill '[NPC targetname]' - kills NPCs with certain targetname\n")
        Com_Printf(S_COLOR_RED + "or\n")
        Com_Printf(S_COLOR_RED + "NPC kill 'all' - kills all NPCs\n")
        Com_Printf(S_COLOR_RED + "or\n")
        Com_Printf(S_COLOR_RED + "NPC team '[teamname]' - kills all NPCs of a certain team ('nonally' is all but your allies)\n")
        return
    }

    if Q_stricmp("team", name) == 0 {
        strcpy(&name, trap_Argv(3, 1024))

        if name[0] == 0 {
            Com_Printf(S_COLOR_RED + "NPC_Kill Error: 'npc kill team' requires a team name!\n")
            Com_Printf(S_COLOR_RED + "Valid team names are:\n")
            n = (TEAM_FREE + 1)
            while n < TEAM_NUM_TEAMS {
                Com_Printf(S_COLOR_RED + "%s\n", TeamNames[n])
                n += 1
            }
            Com_Printf(S_COLOR_RED + "nonally - kills all but your teammates\n")
            return
        }

        if Q_stricmp("nonally", name) == 0 {
            killNonSF = true
        } else {
            killTeam = team_t(GetIDForString(TeamTable, String(name)))

            if killTeam == TEAM_FREE {
                Com_Printf(S_COLOR_RED + "NPC_Kill Error: team '%s' not recognized\n", name)
                Com_Printf(S_COLOR_RED + "Valid team names are:\n")
                n = (TEAM_FREE + 1)
                while n < TEAM_NUM_TEAMS {
                    Com_Printf(S_COLOR_RED + "%s\n", TeamNames[n])
                    n += 1
                }
                Com_Printf(S_COLOR_RED + "nonally - kills all but your teammates\n")
                return
            }
        }
    }

    n = 1
    while n < ENTITYNUM_MAX_NORMAL {
        player = g_entities[n]
        if !player!.inuse {
            n += 1
            continue
        }
        if killNonSF {
            if player != nil {
                if player!.client != nil {
                    if player!.client!.playerTeam != NPCTEAM_PLAYER {
                        Com_Printf(S_COLOR_GREEN + "Killing NPC %s named %s\n", player!.NPC_type!, player!.targetname!)
                        player!.health = 0

                        if player!.die != nil && player!.client != nil {
                            player!.runDie(player, player, player!.client!.pers.maxHealth, MOD_UNKNOWN)
                        }
                    }
                } else if player!.NPC_type != nil && player!.classname != nil && !player!.classname!.isEmpty && Q_stricmp("NPC_starfleet", player!.classname!) != 0 {
                    //A spawner, remove it
                    Com_Printf(S_COLOR_GREEN + "Removing NPC spawner %s with NPC named %s\n", player!.NPC_type!, player!.NPC_targetname!)
                    G_FreeEntity(player!)
                    //FIXME: G_UseTargets2(player, player, player->NPC_target & player->target);?
                }
            }
        } else if player != nil && player!.NPC != nil && player!.client != nil {
            if killTeam != TEAM_FREE {
                if player!.client!.playerTeam == killTeam {
                    Com_Printf(S_COLOR_GREEN + "Killing NPC %s named %s\n", player!.NPC_type!, player!.targetname!)
                    player!.health = 0
                    if player!.die != nil {
                        player!.runDie(player, player, player!.client!.pers.maxHealth, MOD_UNKNOWN)
                    }
                }
            } else if (player!.targetname != nil && Q_stricmp(String(name), player!.targetname!) == 0) || Q_stricmp(name, "all") == 0 {
                Com_Printf(S_COLOR_GREEN + "Killing NPC %s named %s\n", player!.NPC_type!, player!.targetname!)
                player!.health = 0
                player!.client!.ps.stats[STAT_HEALTH] = 0
                if player!.die != nil {
                    player!.runDie(player, player, 100, MOD_UNKNOWN)
                }
            }
        }
        /*
        else if ( player && (player->r.svFlags&SVF_NPC_PRECACHE) )
        {//a spawner
        Com_Printf( S_COLOR_GREEN"Removing NPC spawner %s named %s\n", player->NPC_type, player->targetname );
        G_FreeEntity( player );
        }
        */
        //rwwFIXMEFIXME: should really do something here.
        n += 1
    }
}

/// Source: oracle/codemp/game/NPC_spawn.c:4172
func NPC_PrintScore(_ ent: Entity) {
    Com_Printf("%s: %d\n", ent.targetname!, ent.client!.ps.persistant[PERS_SCORE])
}

/// Source: oracle/codemp/game/NPC_spawn.c:4183
func Cmd_NPC_f(_ ent: Entity) {
    var cmd = CharBuf(1024)
    // Raven assigns his own `ent` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var ent = ent

    strcpy(&cmd, trap_Argv(1, 1024))

    if cmd[0] == 0 {
        Com_Printf("Valid NPC commands are:\n")
        Com_Printf(" spawn [NPC type (from NCPCs.cfg)]\n")
        Com_Printf(" kill [NPC targetname] or [all(kills all NPCs)] or 'team [teamname]'\n")
        Com_Printf(" showbounds (draws exact bounding boxes of NPCs)\n")
        Com_Printf(" score [NPC targetname] (prints number of kills per NPC)\n")
    } else if Q_stricmp(cmd, "spawn") == 0 {
        NPC_Spawn_f(ent)
    } else if Q_stricmp(cmd, "kill") == 0 {
        NPC_Kill_f()
    } else if Q_stricmp(cmd, "showbounds") == 0 {
        //Toggle on and off
        showBBoxes = showBBoxes ? false : true
    } else if Q_stricmp(cmd, "score") == 0 {
        var cmd2 = CharBuf(1024)
        var ent: Entity? = nil

        strcpy(&cmd2, trap_Argv(2, 1024))

        if cmd2[0] == 0 {
            //Show the score for all NPCs
            var i: Int32

            Com_Printf("SCORE LIST:\n")
            i = 0
            while i < ENTITYNUM_WORLD {
                ent = g_entities[i]
                if ent == nil || ent!.client == nil {
                    i += 1
                    continue
                }
                NPC_PrintScore(ent!)
                i += 1
            }
        } else {
            ent = G_Find(nil, \.targetname, String(cmd2))
            if ent != nil && ent!.client != nil {
                NPC_PrintScore(ent!)
            } else {
                Com_Printf("ERROR: NPC score - no such NPC %s\n", cmd2)
            }
        }
    }
}
