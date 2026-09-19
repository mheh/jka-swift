// Raven's tables as C storage, copied as written, so a view can bind over them. Rule 6 keeps them read-only at the Swift surface.
// The umbrella carries no standard header, and Raven's rows say NULL.
#include <stddef.h>
#include "CJKAMP.h"
#include "bg_tables.h"

// Source: oracle/codemp/game/bg_misc.c:795-1771
gitem_t	bg_itemlist[] = 
{
	{
		NULL,				// classname	
		NULL,				// pickup_sound
		{	NULL,			// world_model[0]
			NULL,			// world_model[1]
			0, 0} ,			// world_model[2],[3]
		NULL,				// view_model
/* icon */		NULL,		// icon
/* pickup */	//NULL,		// pickup_name
		0,					// quantity
		0,					// giType (IT_*)
		0,					// giTag
/* precache */ "",			// precaches
/* sounds */ "",			// sounds
		""					// description
	},	// leave index 0 alone

	//
	// Pickups
	//

/*QUAKED item_shield_sm_instant (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Instant shield pickup, restores 25
*/
	{
		"item_shield_sm_instant", 
		"sound/player/pickupshield.wav",
        { "models/map_objects/mp/psd_sm.md3",
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/mp/small_shield",
/* pickup *///	"Shield Small",
		25,
		IT_ARMOR,
		1, //special for shield - max on pickup is maxhealth*tag, thus small shield goes up to 100 shield
/* precache */ "",
/* sounds */ ""
		""					// description
	},

/*QUAKED item_shield_lrg_instant (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Instant shield pickup, restores 100
*/
	{
		"item_shield_lrg_instant", 
		"sound/player/pickupshield.wav",
        { "models/map_objects/mp/psd.md3",
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/mp/large_shield",
/* pickup *///	"Shield Large",
		100,
		IT_ARMOR,
		2, //special for shield - max on pickup is maxhealth*tag, thus large shield goes up to 200 shield
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED item_medpak_instant (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Instant medpack pickup, heals 25
*/
	{
		"item_medpak_instant",
		"sound/player/pickuphealth.wav",
        { "models/map_objects/mp/medpac.md3", 
		0, 0, 0 },
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_medkit",
/* pickup *///	"Medpack",
		25,
		IT_HEALTH,
		0,
/* precache */ "",
/* sounds */ "",
		""					// description
	},


	//
	// ITEMS
	//

/*QUAKED item_seeker (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
30 seconds of seeker drone
*/
	{
		"item_seeker", 
		"sound/weapons/w_pkup.wav",
		{ "models/items/remote.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_seeker",
/* pickup *///	"Seeker Drone",
		120,
		IT_HOLDABLE,
		HI_SEEKER,
/* precache */ "",
/* sounds */ "",
		"@MENUS_AN_ATTACK_DRONE_SIMILAR"					// description
	},

/*QUAKED item_shield (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Portable shield
*/
	{
		"item_shield", 
		"sound/weapons/w_pkup.wav",
		{ "models/map_objects/mp/shield.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_shieldwall",
/* pickup *///	"Forcefield",
		120,
		IT_HOLDABLE,
		HI_SHIELD,
/* precache */ "",
/* sounds */ "sound/weapons/detpack/stick.wav sound/movers/doors/forcefield_on.wav sound/movers/doors/forcefield_off.wav sound/movers/doors/forcefield_lp.wav sound/effects/bumpfield.wav",
		"@MENUS_THIS_STATIONARY_ENERGY"					// description
	},

/*QUAKED item_medpac (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Bacta canister pickup, heals 25 on use
*/
	{
		"item_medpac",	//should be item_bacta
		"sound/weapons/w_pkup.wav",
		{ "models/map_objects/mp/bacta.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_bacta",
/* pickup *///	"Bacta Canister",
		25,
		IT_HOLDABLE,
		HI_MEDPAC,
/* precache */ "",
/* sounds */ "",
		"@SP_INGAME_BACTA_DESC"					// description
	},

/*QUAKED item_medpac_big (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Big bacta canister pickup, heals 50 on use
*/
	{
		"item_medpac_big",	//should be item_bacta
		"sound/weapons/w_pkup.wav",
		{ "models/items/big_bacta.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_big_bacta",
/* pickup *///	"Bacta Canister",
		25,
		IT_HOLDABLE,
		HI_MEDPAC_BIG,
/* precache */ "",
/* sounds */ "",
		"@SP_INGAME_BACTA_DESC"					// description
	},

/*QUAKED item_binoculars (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
These will be standard equipment on the player - DO NOT PLACE
*/
	{
		"item_binoculars", 
		"sound/weapons/w_pkup.wav",
		{ "models/items/binoculars.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_zoom",
/* pickup *///	"Binoculars",
		60,
		IT_HOLDABLE,
		HI_BINOCULARS,
/* precache */ "",
/* sounds */ "",
		"@SP_INGAME_LA_GOGGLES_DESC"					// description
	},

/*QUAKED item_sentry_gun (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Sentry gun inventory pickup.
*/
	{
		"item_sentry_gun", 
		"sound/weapons/w_pkup.wav",
		{ "models/items/psgun.glm", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_sentrygun",
/* pickup *///	"Sentry Gun",
		120,
		IT_HOLDABLE,
		HI_SENTRY_GUN,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THIS_DEADLY_WEAPON_IS"					// description
	},

/*QUAKED item_jetpack (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Do not place.
*/
	{
		"item_jetpack", 
		"sound/weapons/w_pkup.wav",
		{ "models/items/psgun.glm", //FIXME: no model
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_jetpack",
/* pickup *///	"Sentry Gun",
		120,
		IT_HOLDABLE,
		HI_JETPACK,
/* precache */ "effects/boba/jet.efx",
/* sounds */ "sound/chars/boba/JETON.wav sound/chars/boba/JETHOVER.wav sound/effects/fire_lp.wav",
		"@MENUS_JETPACK_DESC"					// description
	},

/*QUAKED item_healthdisp (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Do not place. For siege classes ONLY.
*/
	{
		"item_healthdisp", 
		"sound/weapons/w_pkup.wav",
		{ "models/map_objects/mp/bacta.md3", //replace me
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_healthdisp",
/* pickup *///	"Sentry Gun",
		120,
		IT_HOLDABLE,
		HI_HEALTHDISP,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED item_ammodisp (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Do not place. For siege classes ONLY.
*/
	{
		"item_ammodisp", 
		"sound/weapons/w_pkup.wav",
		{ "models/map_objects/mp/bacta.md3", //replace me
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_ammodisp",
/* pickup *///	"Sentry Gun",
		120,
		IT_HOLDABLE,
		HI_AMMODISP,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED item_eweb_holdable (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
Do not place. For siege classes ONLY.
*/
	{
		"item_eweb_holdable", 
		"sound/interface/shieldcon_empty",
		{ "models/map_objects/hoth/eweb_model.glm",
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_eweb",
/* pickup *///	"Sentry Gun",
		120,
		IT_HOLDABLE,
		HI_EWEB,
/* precache */ "",
/* sounds */ "",
		"@MENUS_EWEB_DESC"					// description
	},

/*QUAKED item_seeker (.3 .3 1) (-8 -8 -0) (8 8 16) suspended
30 seconds of seeker drone
*/
	{
		"item_cloak", 
		"sound/weapons/w_pkup.wav",
		{ "models/items/psgun.glm", //FIXME: no model
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_cloak",
/* pickup *///	"Seeker Drone",
		120,
		IT_HOLDABLE,
		HI_CLOAK,
/* precache */ "",
/* sounds */ "",
		"@MENUS_CLOAK_DESC"					// description
	},

/*QUAKED item_force_enlighten_light (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Adds one rank to all Force powers temporarily. Only light jedi can use.
*/
	{
		"item_force_enlighten_light",
		"sound/player/enlightenment.wav",
		{ "models/map_objects/mp/jedi_enlightenment.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/mpi_jlight",
/* pickup *///	"Light Force Enlightenment",
		25,
		IT_POWERUP,
		PW_FORCE_ENLIGHTENED_LIGHT,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED item_force_enlighten_dark (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Adds one rank to all Force powers temporarily. Only dark jedi can use.
*/
	{
		"item_force_enlighten_dark",
		"sound/player/enlightenment.wav",
		{ "models/map_objects/mp/dk_enlightenment.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/mpi_dklight",
/* pickup *///	"Dark Force Enlightenment",
		25,
		IT_POWERUP,
		PW_FORCE_ENLIGHTENED_DARK,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED item_force_boon (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Unlimited Force Pool for a short time.
*/
	{
		"item_force_boon",
		"sound/player/boon.wav",
		{ "models/map_objects/mp/force_boon.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/mpi_fboon",
/* pickup *///	"Force Boon",
		25,
		IT_POWERUP,
		PW_FORCE_BOON,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED item_ysalimari (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
A small lizard carried on the player, which prevents the possessor from using any Force power.  However, he is unaffected by any Force power.
*/
	{
		"item_ysalimari",
		"sound/player/ysalimari.wav",
		{ "models/map_objects/mp/ysalimari.md3", 
		0, 0, 0} ,
/* view */		NULL,			
/* icon */		"gfx/hud/mpi_ysamari",
/* pickup *///	"Ysalamiri",
		25,
		IT_POWERUP,
		PW_YSALAMIRI,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	//
	// WEAPONS 
	//

/*QUAKED weapon_stun_baton (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Don't place this
*/
	{
		"weapon_stun_baton", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/stun_baton/baton_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/stun_baton/baton.md3", 
/* icon */		"gfx/hud/w_icon_stunbaton",
/* pickup *///	"Stun Baton",
		100,
		IT_WEAPON,
		WP_STUN_BATON,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED weapon_melee (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Don't place this
*/
	{
		"weapon_melee", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/stun_baton/baton_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/stun_baton/baton.md3", 
/* icon */		"gfx/hud/w_icon_melee",
/* pickup *///	"Stun Baton",
		100,
		IT_WEAPON,
		WP_MELEE,
/* precache */ "",
/* sounds */ "",
		"@MENUS_MELEE_DESC"					// description
	},

/*QUAKED weapon_saber (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Don't place this
*/
	{
		"weapon_saber", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/saber/saber_w.glm",
		0, 0, 0},
/* view */		"models/weapons2/saber/saber_w.md3",
/* icon */		"gfx/hud/w_icon_lightsaber",
/* pickup *///	"Lightsaber",
		100,
		IT_WEAPON,
		WP_SABER,
/* precache */ "",
/* sounds */ "",
		"@MENUS_AN_ELEGANT_WEAPON_FOR"				// description
	},

/*QUAKED weapon_bryar_pistol (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Don't place this
*/
	{
		//"weapon_bryar_pistol", 
		"weapon_blaster_pistol", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/blaster_pistol/blaster_pistol_w.glm",//"models/weapons2/briar_pistol/briar_pistol_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/blaster_pistol/blaster_pistol.md3",//"models/weapons2/briar_pistol/briar_pistol.md3", 
/* icon */		"gfx/hud/w_icon_blaster_pistol",//"gfx/hud/w_icon_rifle",
/* pickup *///	"Bryar Pistol",
		100,
		IT_WEAPON,
		WP_BRYAR_PISTOL,
/* precache */ "",
/* sounds */ "",
		"@MENUS_BLASTER_PISTOL_DESC"					// description
	},

/*QUAKED weapon_concussion_rifle (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_concussion_rifle", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/concussion/c_rifle_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/concussion/c_rifle.md3", 
/* icon */		"gfx/hud/w_icon_c_rifle",//"gfx/hud/w_icon_rifle",
/* pickup *///	"Concussion Rifle",
		50,
		IT_WEAPON,
		WP_CONCUSSION,
/* precache */ "",
/* sounds */ "",
		"@MENUS_CONC_RIFLE_DESC"					// description
	},

/*QUAKED weapon_bryar_pistol_old (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Don't place this
*/
	{
		"weapon_bryar_pistol", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/briar_pistol/briar_pistol_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/briar_pistol/briar_pistol.md3", 
/* icon */		"gfx/hud/w_icon_briar",//"gfx/hud/w_icon_rifle",
/* pickup *///	"Bryar Pistol",
		100,
		IT_WEAPON,
		WP_BRYAR_OLD,
/* precache */ "",
/* sounds */ "",
		"@SP_INGAME_BLASTER_PISTOL"					// description
	},

/*QUAKED weapon_blaster (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_blaster", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/blaster_r/blaster_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/blaster_r/blaster.md3", 
/* icon */		"gfx/hud/w_icon_blaster",
/* pickup *///	"E11 Blaster Rifle",
		100,
		IT_WEAPON,
		WP_BLASTER,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THE_PRIMARY_WEAPON_OF"				// description
	},

/*QUAKED weapon_disruptor (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_disruptor",
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/disruptor/disruptor_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/disruptor/disruptor.md3", 
/* icon */		"gfx/hud/w_icon_disruptor",
/* pickup *///	"Tenloss Disruptor Rifle",
		100,
		IT_WEAPON,
		WP_DISRUPTOR,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THIS_NEFARIOUS_WEAPON"					// description
	},

/*QUAKED weapon_bowcaster (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_bowcaster",
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/bowcaster/bowcaster_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/bowcaster/bowcaster.md3", 
/* icon */		"gfx/hud/w_icon_bowcaster",
/* pickup *///	"Wookiee Bowcaster",
		100,
		IT_WEAPON,
		WP_BOWCASTER,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THIS_ARCHAIC_LOOKING"					// description
	},

/*QUAKED weapon_repeater (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_repeater", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/heavy_repeater/heavy_repeater_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/heavy_repeater/heavy_repeater.md3", 
/* icon */		"gfx/hud/w_icon_repeater",
/* pickup *///	"Imperial Heavy Repeater",
		100,
		IT_WEAPON,
		WP_REPEATER,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THIS_DESTRUCTIVE_PROJECTILE"					// description
	},

/*QUAKED weapon_demp2 (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
NOTENOTE This weapon is not yet complete.  Don't place it.
*/
	{
		"weapon_demp2", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/demp2/demp2_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/demp2/demp2.md3", 
/* icon */		"gfx/hud/w_icon_demp2",
/* pickup *///	"DEMP2",
		100,
		IT_WEAPON,
		WP_DEMP2,
/* precache */ "",
/* sounds */ "",
		"@MENUS_COMMONLY_REFERRED_TO"					// description
	},

/*QUAKED weapon_flechette (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_flechette", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/golan_arms/golan_arms_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/golan_arms/golan_arms.md3", 
/* icon */		"gfx/hud/w_icon_flechette",
/* pickup *///	"Golan Arms Flechette",
		100,
		IT_WEAPON,
		WP_FLECHETTE,
/* precache */ "",
/* sounds */ "",
		"@MENUS_WIDELY_USED_BY_THE_CORPORATE"					// description
	},

/*QUAKED weapon_rocket_launcher (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_rocket_launcher",
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/merr_sonn/merr_sonn_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/merr_sonn/merr_sonn.md3", 
/* icon */		"gfx/hud/w_icon_merrsonn",
/* pickup *///	"Merr-Sonn Missile System",
		3,
		IT_WEAPON,
		WP_ROCKET_LAUNCHER,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THE_PLX_2M_IS_AN_EXTREMELY"					// description
	},

/*QUAKED ammo_thermal (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"ammo_thermal",
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/thermal/thermal_pu.md3", 
		"models/weapons2/thermal/thermal_w.glm", 0, 0},
/* view */		"models/weapons2/thermal/thermal.md3", 
/* icon */		"gfx/hud/w_icon_thermal",
/* pickup *///	"Thermal Detonators",
		4,
		IT_AMMO,
		AMMO_THERMAL,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THE_THERMAL_DETONATOR"					// description
	},

/*QUAKED ammo_tripmine (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"ammo_tripmine", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/laser_trap/laser_trap_pu.md3", 
		"models/weapons2/laser_trap/laser_trap_w.glm", 0, 0},
/* view */		"models/weapons2/laser_trap/laser_trap.md3", 
/* icon */		"gfx/hud/w_icon_tripmine",
/* pickup *///	"Trip Mines",
		3,
		IT_AMMO,
		AMMO_TRIPMINE,
/* precache */ "",
/* sounds */ "",
		"@MENUS_TRIP_MINES_CONSIST_OF"					// description
	},

/*QUAKED ammo_detpack (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"ammo_detpack", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/detpack/det_pack_pu.md3", "models/weapons2/detpack/det_pack_proj.glm", "models/weapons2/detpack/det_pack_w.glm", 0},
/* view */		"models/weapons2/detpack/det_pack.md3", 
/* icon */		"gfx/hud/w_icon_detpack",
/* pickup *///	"Det Packs",
		3,
		IT_AMMO,
		AMMO_DETPACK,
/* precache */ "",
/* sounds */ "",
		"@MENUS_A_DETONATION_PACK_IS"					// description
	},

/*QUAKED weapon_thermal (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_thermal",
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/thermal/thermal_w.glm", "models/weapons2/thermal/thermal_pu.md3",
		0, 0 },
/* view */		"models/weapons2/thermal/thermal.md3", 
/* icon */		"gfx/hud/w_icon_thermal",
/* pickup *///	"Thermal Detonator",
		4,
		IT_WEAPON,
		WP_THERMAL,
/* precache */ "",
/* sounds */ "",
		"@MENUS_THE_THERMAL_DETONATOR"					// description
	},

/*QUAKED weapon_trip_mine (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_trip_mine", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/laser_trap/laser_trap_w.glm", "models/weapons2/laser_trap/laser_trap_pu.md3",
		0, 0},
/* view */		"models/weapons2/laser_trap/laser_trap.md3", 
/* icon */		"gfx/hud/w_icon_tripmine",
/* pickup *///	"Trip Mine",
		3,
		IT_WEAPON,
		WP_TRIP_MINE,
/* precache */ "",
/* sounds */ "",
		"@MENUS_TRIP_MINES_CONSIST_OF"					// description
	},

/*QUAKED weapon_det_pack (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_det_pack", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/detpack/det_pack_proj.glm", "models/weapons2/detpack/det_pack_pu.md3", "models/weapons2/detpack/det_pack_w.glm", 0},
/* view */		"models/weapons2/detpack/det_pack.md3", 
/* icon */		"gfx/hud/w_icon_detpack",
/* pickup *///	"Det Pack",
		3,
		IT_WEAPON,
		WP_DET_PACK,
/* precache */ "",
/* sounds */ "",
		"@MENUS_A_DETONATION_PACK_IS"					// description
	},

/*QUAKED weapon_emplaced (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
*/
	{
		"weapon_emplaced", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/blaster_r/blaster_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/blaster_r/blaster.md3", 
/* icon */		"gfx/hud/w_icon_blaster",
/* pickup *///	"Emplaced Gun",
		50,
		IT_WEAPON,
		WP_EMPLACED_GUN,
/* precache */ "",
/* sounds */ "",
		""					// description
	},


//NOTE: This is to keep things from messing up because the turret weapon type isn't real
	{
		"weapon_turretwp", 
		"sound/weapons/w_pkup.wav",
        { "models/weapons2/blaster_r/blaster_w.glm", 
		0, 0, 0},
/* view */		"models/weapons2/blaster_r/blaster.md3", 
/* icon */		"gfx/hud/w_icon_blaster",
/* pickup *///	"Turret Gun",
		50,
		IT_WEAPON,
		WP_TURRET,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	//
	// AMMO ITEMS
	//

/*QUAKED ammo_force (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Don't place this
*/
	{
		"ammo_force",
		"sound/player/pickupenergy.wav",
        { "models/items/energy_cell.md3", 
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/hud/w_icon_blaster",
/* pickup *///	"Force??",
		100,
		IT_AMMO,
		AMMO_FORCE,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED ammo_blaster (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Ammo for the Bryar and Blaster pistols.
*/
	{
		"ammo_blaster",
		"sound/player/pickupenergy.wav",
        { "models/items/energy_cell.md3", 
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/hud/i_icon_battery",
/* pickup *///	"Blaster Pack",
		100,
		IT_AMMO,
		AMMO_BLASTER,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED ammo_powercell (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Ammo for Tenloss Disruptor, Wookie Bowcaster, and the Destructive Electro Magnetic Pulse (demp2 ) guns
*/
	{
		"ammo_powercell",
		"sound/player/pickupenergy.wav",
        { "models/items/power_cell.md3", 
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/mp/ammo_power_cell",
/* pickup *///	"Power Cell",
		100,
		IT_AMMO,
		AMMO_POWERCELL,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED ammo_metallic_bolts (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Ammo for Imperial Heavy Repeater and the Golan Arms Flechette
*/
	{
		"ammo_metallic_bolts",
		"sound/player/pickupenergy.wav",
        { "models/items/metallic_bolts.md3", 
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/mp/ammo_metallic_bolts",
/* pickup *///	"Metallic Bolts",
		100,
		IT_AMMO,
		AMMO_METAL_BOLTS,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED ammo_rockets (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
Ammo for Merr-Sonn portable missile launcher
*/
	{
		"ammo_rockets",
		"sound/player/pickupenergy.wav",
        { "models/items/rockets.md3", 
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/mp/ammo_rockets",
/* pickup *///	"Rockets",
		3,
		IT_AMMO,
		AMMO_ROCKETS,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED ammo_all (.3 .3 1) (-16 -16 -16) (16 16 16) suspended
DO NOT PLACE in a map, this is only for siege classes that have ammo
dispensing ability
*/
	{
		"ammo_all",
		"sound/player/pickupenergy.wav",
        { "models/items/battery.md3",  //replace me
		0, 0, 0},
/* view */		NULL,			
/* icon */		"gfx/mp/ammo_rockets", //replace me
/* pickup *///	"Rockets",
		0,
		IT_AMMO,
		-1,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	//
	// POWERUP ITEMS
	//
/*QUAKED team_CTF_redflag (1 0 0) (-16 -16 -16) (16 16 16)
Only in CTF games
*/
	{
		"team_CTF_redflag",
		NULL,
        { "models/flags/r_flag.md3",
		"models/flags/r_flag_ysal.md3", 0, 0 },
/* view */		NULL,			
/* icon */		"gfx/hud/mpi_rflag",
/* pickup *///	"Red Flag",
		0,
		IT_TEAM,
		PW_REDFLAG,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

/*QUAKED team_CTF_blueflag (0 0 1) (-16 -16 -16) (16 16 16)
Only in CTF games
*/
	{
		"team_CTF_blueflag",
		NULL,
        { "models/flags/b_flag.md3",
		"models/flags/b_flag_ysal.md3", 0, 0 },
/* view */		NULL,			
/* icon */		"gfx/hud/mpi_bflag",
/* pickup *///	"Blue Flag",
		0,
		IT_TEAM,
		PW_BLUEFLAG,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	//
	// PERSISTANT POWERUP ITEMS
	//

	/*QUAKED team_CTF_neutralflag (0 0 1) (-16 -16 -16) (16 16 16)
Only in One Flag CTF games
*/
	{
		"team_CTF_neutralflag",
		NULL,
        { "models/flags/n_flag.md3",
		0, 0, 0 },
/* view */		NULL,			
/* icon */		"icons/iconf_neutral1",
/* pickup *///	"Neutral Flag",
		0,
		IT_TEAM,
		PW_NEUTRALFLAG,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	{
		"item_redcube",
		"sound/player/pickupenergy.wav",
        { "models/powerups/orb/r_orb.md3",
		0, 0, 0 },
/* view */		NULL,			
/* icon */		"icons/iconh_rorb",
/* pickup *///	"Red Cube",
		0,
		IT_TEAM,
		0,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	{
		"item_bluecube",
		"sound/player/pickupenergy.wav",
        { "models/powerups/orb/b_orb.md3",
		0, 0, 0 },
/* view */		NULL,			
/* icon */		"icons/iconh_borb",
/* pickup *///	"Blue Cube",
		0,
		IT_TEAM,
		0,
/* precache */ "",
/* sounds */ "",
		""					// description
	},

	// end of list marker
	{NULL}
};

int		bg_numItems = sizeof(bg_itemlist) / sizeof(bg_itemlist[0]) - 1;

// Source: oracle/codemp/game/bg_weapons.c:10-29
vec3_t WP_MuzzlePoint[WP_NUM_WEAPONS] = 
{//	Fwd,	right,	up.
	{0,		0,		0	},	// WP_NONE,
	{0	,	8,		0	},	// WP_STUN_BATON,
	{0	,	8,		0	},	// WP_MELEE,
	{8	,	16,		0	},	// WP_SABER,				 
	{12,	6,		-6	},	// WP_BRYAR_PISTOL,
	{12,	6,		-6	},	// WP_BLASTER,
	{12,	6,		-6	},	// WP_DISRUPTOR,
	{12,	2,		-6	},	// WP_BOWCASTER,
	{12,	4.5,	-6	},	// WP_REPEATER,
	{12,	6,		-6	},	// WP_DEMP2,
	{12,	6,		-6	},	// WP_FLECHETTE,
	{12,	8,		-4	},	// WP_ROCKET_LAUNCHER,
	{12,	0,		-4	},	// WP_THERMAL,
	{12,	0,		-10	},	// WP_TRIP_MINE,
	{12,	0,		-4	},	// WP_DET_PACK,
	{12,	6,		-6	},	// WP_CONCUSSION
	{12,	6,		-6	},	// WP_BRYAR_OLD,
};

// Source: oracle/codemp/game/bg_weapons.c:31-356
weaponData_t weaponData[WP_NUM_WEAPONS] = 
{
	{	// WP_NONE
//		"No Weapon",			//	char	classname[32];		// Spawning name
		AMMO_NONE,				//	int		ammoIndex;			// Index to proper ammo slot
		0,						//	int		ammoLow;			// Count when ammo is low
		0,						//	int		energyPerShot;		// Amount of energy used per shot
		0,						//	int		fireTime;			// Amount of time between firings
		0,						//	int		range;				// Range of weapon
		0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		0,						//	int		altFireTime;		// Amount of time between alt-firings
		0,						//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_STUN_BATON
//		"Stun Baton",			//	char	classname[32];		// Spawning name
		AMMO_NONE,				//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		0,						//	int		energyPerShot;		// Amount of energy used per shot
		400,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_MELEE
//		"Melee",			//	char	classname[32];		// Spawning name
		AMMO_NONE,				//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		0,						//	int		energyPerShot;		// Amount of energy used per shot
		400,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_SABER,
//		"Lightsaber",			//	char	classname[32];		// Spawning name
		AMMO_NONE,				//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		0,						//	int		energyPerShot;		// Amount of energy used per shot
		100,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		100,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_BRYAR_PISTOL,
//		"Bryar Pistol",			//	char	classname[32];		// Spawning name
		AMMO_BLASTER,			//	int		ammoIndex;			// Index to proper ammo slot
		0,//15,						//	int		ammoLow;			// Count when ammo is low
		0,//2,						//	int		energyPerShot;		// Amount of energy used per shot
		800,//400,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		0,//2,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		800,//400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,//200,					//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,//1,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0,//1500					//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_BLASTER
//		"E11 Blaster Rifle",	//	char	classname[32];		// Spawning name
		AMMO_BLASTER,			//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		2,						//	int		energyPerShot;		// Amount of energy used per shot
		350,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		3,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		150,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_DISRUPTOR
//		"Tenloss Disruptor Rifle",//	char	classname[32];		// Spawning name
		AMMO_POWERCELL,			//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		5,						//	int		energyPerShot;		// Amount of energy used per shot
		600,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		6,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		1300,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		200,					//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		3,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		1700					//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_BOWCASTER
//		"Wookiee Bowcaster",		//	char	classname[32];		// Spawning name
		AMMO_POWERCELL,			//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		5,						//	int		energyPerShot;		// Amount of energy used per shot
		1000,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		5,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		750,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		400,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,					//	int		altChargeSubTime;	// above for secondary
		5,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		1700,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0					//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_REPEATER
//		"Imperial Heavy Repeater",//	char	classname[32];		// Spawning name
		AMMO_METAL_BOLTS,		//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		1,						//	int		energyPerShot;		// Amount of energy used per shot
		100,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		15,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		800,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_DEMP2
//		"DEMP2",				//	char	classname[32];		// Spawning name
		AMMO_POWERCELL,			//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		8,						//	int		energyPerShot;		// Amount of energy used per shot
		500,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		6,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		900,						//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		250,					//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		3,						//	int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		2100					//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_FLECHETTE
//		"Golan Arms Flechette",	//	char	classname[32];		// Spawning name
		AMMO_METAL_BOLTS,		//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		10,						//	int		energyPerShot;		// Amount of energy used per shot
		700,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		15,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		800,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_ROCKET_LAUNCHER
//		"Merr-Sonn Missile System",	//	char	classname[32];		// Spawning name
		AMMO_ROCKETS,			//	int		ammoIndex;			// Index to proper ammo slot
		5,						//	int		ammoLow;			// Count when ammo is low
		1,						//	int		energyPerShot;		// Amount of energy used per shot
		900,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		2,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		1200,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_THERMAL
//		"Thermal Detonator",	//	char	classname[32];		// Spawning name
		AMMO_THERMAL,				//	int		ammoIndex;			// Index to proper ammo slot
		0,						//	int		ammoLow;			// Count when ammo is low
		1,						//	int		energyPerShot;		// Amount of energy used per shot
		800,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		1,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_TRIP_MINE
//		"Trip Mine",			//	char	classname[32];		// Spawning name
		AMMO_TRIPMINE,				//	int		ammoIndex;			// Index to proper ammo slot
		0,						//	int		ammoLow;			// Count when ammo is low
		1,						//	int		energyPerShot;		// Amount of energy used per shot
		800,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		1,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_DET_PACK
//		"Det Pack",				//	char	classname[32];		// Spawning name
		AMMO_DETPACK,				//	int		ammoIndex;			// Index to proper ammo slot
		0,						//	int		ammoLow;			// Count when ammo is low
		1,						//	int		energyPerShot;		// Amount of energy used per shot
		800,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_CONCUSSION
//		"Concussion Rifle",		//	char	classname[32];		// Spawning name
		AMMO_METAL_BOLTS,		//	int		ammoIndex;			// Index to proper ammo slot
		40,						//	int		ammoLow;			// Count when ammo is low
		40,						//	int		energyPerShot;		// Amount of energy used per shot
		800,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		50,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		1200,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//	int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_BRYAR_OLD,
//		"Bryar Pistol",			//	char	classname[32];		// Spawning name
		AMMO_BLASTER,			//	int		ammoIndex;			// Index to proper ammo slot
		15,						//	int		ammoLow;			// Count when ammo is low
		2,						//	int		energyPerShot;		// Amount of energy used per shot
		400,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		2,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		400,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		200,					//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		1,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		1500					//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_EMPLCACED_GUN
//		"Emplaced Gun",			//	char	classname[32];		// Spawning name
		/*AMMO_BLASTER*/0,			//	int		ammoIndex;			// Index to proper ammo slot
		/*5*/0,						//	int		ammoLow;			// Count when ammo is low
		/*2*/0,						//	int		energyPerShot;		// Amount of energy used per shot
		100,					//	int		fireTime;			// Amount of time between firings
		8192,					//	int		range;				// Range of weapon
		/*3*/0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		100,					//	int		altFireTime;		// Amount of time between alt-firings
		8192,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	},
	{	// WP_TURRET - NOTE NOT ACTUALLY USEABLE BY PLAYER!
//		"Emplaced Gun",			//	char	classname[32];		// Spawning name
		/*AMMO_BLASTER*/0,			//	int		ammoIndex;			// Index to proper ammo slot
		/*5*/0,						//	int		ammoLow;			// Count when ammo is low
		/*2*/0,						//	int		energyPerShot;		// Amount of energy used per shot
		0,					//	int		fireTime;			// Amount of time between firings
		0,					//	int		range;				// Range of weapon
		/*3*/0,						//	int		altEnergyPerShot;	// Amount of energy used for alt-fire
		0,					//	int		altFireTime;		// Amount of time between alt-firings
		0,					//	int		altRange;			// Range of alt-fire
		0,						//	int		chargeSubTime;		// ms interval for subtracting ammo during charge
		0,						//	int		altChargeSubTime;	// above for secondary
		0,						//	int		chargeSub;			// amount to subtract during charge on each interval
		0,						//int		altChargeSub;		// above for secondary
		0,						//	int		maxCharge;			// stop subtracting once charged for this many ms
		0						//	int		altMaxCharge;		// above for secondary
	}
};

// Source: oracle/codemp/game/bg_weapons.c:358-400
ammoData_t ammoData[AMMO_MAX] = 
{
	{	// AMMO_NONE
//		"",				//	char	icon[32];	// Name of ammo icon file
		0				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_FORCE
//		"",				//	char	icon[32];	// Name of ammo icon file
		100				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_BLASTER
//		"",				//	char	icon[32];	// Name of ammo icon file
		300				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_POWERCELL
//		"",				//	char	icon[32];	// Name of ammo icon file
		300				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_METAL_BOLTS
//		"",				//	char	icon[32];	// Name of ammo icon file
		300				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_ROCKETS
//		"",				//	char	icon[32];	// Name of ammo icon file
		25				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_EMPLACED
//		"",				//	char	icon[32];	// Name of ammo icon file
		800				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_THERMAL
//		"",				//	char	icon[32];	// Name of ammo icon file
		10				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_TRIPMINE
//		"",				//	char	icon[32];	// Name of ammo icon file
		10				//	int		max;		// Max amount player can hold of ammo
	},
	{	// AMMO_DETPACK
//		"",				//	char	icon[32];	// Name of ammo icon file
		10				//	int		max;		// Max amount player can hold of ammo
	}
};

// Raven's animation flag macros of bg_saber.c, which the table below names.
// Source: oracle/codemp/game/bg_saber.c:114-117
#define AFLAG_IDLE	(SETANIM_FLAG_NORMAL)
#define AFLAG_ACTIVE (SETANIM_FLAG_OVERRIDE|SETANIM_FLAG_HOLD | SETANIM_FLAG_HOLDLESS)
#define AFLAG_WAIT (SETANIM_FLAG_HOLD | SETANIM_FLAG_HOLDLESS)
#define AFLAG_FINISH (SETANIM_FLAG_HOLD)

// Source: oracle/codemp/game/bg_saber.c:120-321
saberMoveData_t	saberMoveData[LS_MOVE_MAX] = {//							NB:randomized
	// name			anim(do all styles?)startQ	endQ	setanimflag		blend,	blocking	chain_idle		chain_attack	trailLen
	{"None",		BOTH_STAND1,		Q_R,	Q_R,	AFLAG_IDLE,		350,	BLK_NO,		LS_NONE,		LS_NONE,		0	},	// LS_NONE		= 0,

	// General movements with saber
	{"Ready",		BOTH_STAND2,		Q_R,	Q_R,	AFLAG_IDLE,		350,	BLK_WIDE,	LS_READY,		LS_S_R2L,		0	},	// LS_READY,
	{"Draw",		BOTH_STAND1TO2,		Q_R,	Q_R,	AFLAG_FINISH,	350,	BLK_NO,		LS_READY,		LS_S_R2L,		0	},	// LS_DRAW,
	{"Putaway",		BOTH_STAND2TO1,		Q_R,	Q_R,	AFLAG_FINISH,	350,	BLK_NO,		LS_READY,		LS_S_R2L,		0	},	// LS_PUTAWAY,

	// Attacks
	//UL2LR
	{"TL2BR Att",	BOTH_A1_TL_BR,		Q_TL,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_R_TL2BR,		LS_R_TL2BR,		200	},	// LS_A_TL2BR
	//SLASH LEFT
	{"L2R Att",		BOTH_A1__L__R,		Q_L,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_R_L2R,		LS_R_L2R,		200 },	// LS_A_L2R
	//LL2UR
	{"BL2TR Att",	BOTH_A1_BL_TR,		Q_BL,	Q_TR,	AFLAG_ACTIVE,	50,		BLK_TIGHT,	LS_R_BL2TR,		LS_R_BL2TR,		200	},	// LS_A_BL2TR
	//LR2UL
	{"BR2TL Att",	BOTH_A1_BR_TL,		Q_BR,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_R_BR2TL,		LS_R_BR2TL,		200	},	// LS_A_BR2TL
	//SLASH RIGHT
	{"R2L Att",		BOTH_A1__R__L,		Q_R,	Q_L,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_R_R2L,		LS_R_R2L,		200 },// LS_A_R2L
	//UR2LL
	{"TR2BL Att",	BOTH_A1_TR_BL,		Q_TR,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_R_TR2BL,		LS_R_TR2BL,		200	},	// LS_A_TR2BL
	//SLASH DOWN
	{"T2B Att",		BOTH_A1_T__B_,		Q_T,	Q_B,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_R_T2B,		LS_R_T2B,		200	},	// LS_A_T2B
	//special attacks
	{"Back Stab",	BOTH_A2_STABBACK1,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_A_BACKSTAB
	{"Back Att",	BOTH_ATTACK_BACK,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_A_BACK
	{"CR Back Att",	BOTH_CROUCHATTACKBACK1,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_A_BACK_CR
	{"RollStab",	BOTH_ROLL_STAB,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_ROLL_STAB
	{"Lunge Att",	BOTH_LUNGE2_B__T_,	Q_B,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_A_LUNGE
	{"Jump Att",	BOTH_FORCELEAP2_T__B_,Q_T,	Q_B,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_A_JUMP_T__B_
	{"Flip Stab",	BOTH_JUMPFLIPSTABDOWN,Q_R,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1_T___R,	200	},	// LS_A_FLIP_STAB
	{"Flip Slash",	BOTH_JUMPFLIPSLASHDOWN1,Q_L,Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1__R_T_,	200	},	// LS_A_FLIP_SLASH
	{"DualJump Atk",BOTH_JUMPATTACK6,	Q_R,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1_BL_TR,	200	},	// LS_JUMPATTACK_DUAL

	{"DualJumpAtkL_A",BOTH_ARIAL_LEFT,	Q_R,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_A_TL2BR,		200	},	// LS_JUMPATTACK_ARIAL_LEFT
	{"DualJumpAtkR_A",BOTH_ARIAL_RIGHT,	Q_R,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_A_TR2BL,		200	},	// LS_JUMPATTACK_ARIAL_RIGHT

	{"DualJumpAtkL_A",BOTH_CARTWHEEL_LEFT,	Q_R,Q_TL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1_TL_BR,	200	},	// LS_JUMPATTACK_CART_LEFT
	{"DualJumpAtkR_A",BOTH_CARTWHEEL_RIGHT,	Q_R,Q_TR,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1_TR_BL,	200	},	// LS_JUMPATTACK_CART_RIGHT
	
	{"DualJumpAtkLStaff", BOTH_BUTTERFLY_FL1,Q_R,Q_L,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1__L__R,	200	},	// LS_JUMPATTACK_STAFF_LEFT
	{"DualJumpAtkRStaff", BOTH_BUTTERFLY_FR1,Q_R,Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1__R__L,	200	},	// LS_JUMPATTACK_STAFF_RIGHT

	{"ButterflyLeft", BOTH_BUTTERFLY_LEFT,Q_R,Q_L,		AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1__L__R,	200	},	// LS_BUTTERFLY_LEFT
	{"ButterflyRight", BOTH_BUTTERFLY_RIGHT,Q_R,Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1__R__L,	200	},	// LS_BUTTERFLY_RIGHT
	
	{"BkFlip Atk",	BOTH_JUMPATTACK7,	Q_B,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_T1_T___R,	200	},	// LS_A_BACKFLIP_ATK
	{"DualSpinAtk",	BOTH_SPINATTACK6,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_SPINATTACK_DUAL
	{"StfSpinAtk",	BOTH_SPINATTACK7,	Q_L,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_SPINATTACK
	{"LngLeapAtk",	BOTH_FORCELONGLEAP_ATTACK,Q_R,Q_L,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_LEAP_ATTACK
	{"SwoopAtkR",	BOTH_VS_ATR_S,		Q_R,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_SWOOP_ATTACK_RIGHT
	{"SwoopAtkL",	BOTH_VS_ATL_S,		Q_L,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_SWOOP_ATTACK_LEFT
	{"TauntaunAtkR",BOTH_VT_ATR_S,		Q_R,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_TAUNTAUN_ATTACK_RIGHT
	{"TauntaunAtkL",BOTH_VT_ATL_S,		Q_L,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_TAUNTAUN_ATTACK_LEFT
	{"StfKickFwd",	BOTH_A7_KICK_F,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_F
	{"StfKickBack",	BOTH_A7_KICK_B,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_B
	{"StfKickRight",BOTH_A7_KICK_R,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_R
	{"StfKickLeft",	BOTH_A7_KICK_L,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_L
	{"StfKickSpin",	BOTH_A7_KICK_S,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,		LS_READY,		LS_S_R2L,		200	},	// LS_KICK_S
	{"StfKickBkFwd",BOTH_A7_KICK_BF,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,		LS_READY,		LS_S_R2L,		200	},	// LS_KICK_BF
	{"StfKickSplit",BOTH_A7_KICK_RL,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,		LS_READY,		LS_S_R2L,		200	},	// LS_KICK_RL
	{"StfKickFwdAir",BOTH_A7_KICK_F_AIR,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_F_AIR
	{"StfKickBackAir",BOTH_A7_KICK_B_AIR,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_B_AIR
	{"StfKickRightAir",BOTH_A7_KICK_R_AIR,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_R_AIR
	{"StfKickLeftAir",BOTH_A7_KICK_L_AIR,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_KICK_L_AIR
	{"StabDown",	BOTH_STABDOWN,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_STABDOWN
	{"StabDownStf",	BOTH_STABDOWN_STAFF,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_STABDOWN_STAFF
	{"StabDownDual",BOTH_STABDOWN_DUAL,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_S_R2L,		200	},	// LS_STABDOWN_DUAL
	{"dualspinprot",BOTH_A6_SABERPROTECT,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		500	},	// LS_DUAL_SPIN_PROTECT
	{"StfSoulCal",	BOTH_A7_SOULCAL,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		500	},	// LS_STAFF_SOULCAL
	{"specialfast",	BOTH_A1_SPECIAL,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		2000},	// LS_A1_SPECIAL
	{"specialmed",	BOTH_A2_SPECIAL,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		2000},	// LS_A2_SPECIAL
	{"specialstr",	BOTH_A3_SPECIAL,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		2000},	// LS_A3_SPECIAL
	{"upsidedwnatk",BOTH_FLIP_ATTACK7,	Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200},	// LS_UPSIDE_DOWN_ATTACK
	{"pullatkstab",	BOTH_PULL_IMPALE_STAB,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200},	// LS_PULL_ATTACK_STAB
	{"pullatkswing",BOTH_PULL_IMPALE_SWING,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200},	// LS_PULL_ATTACK_SWING
	{"AloraSpinAtk",BOTH_ALORA_SPIN_SLASH,Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_SPINATTACK_ALORA
	{"Dual FB Atk",	BOTH_A6_FB,			Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_DUAL_FB
	{"Dual LR Atk",	BOTH_A6_LR,			Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200 },	// LS_DUAL_LR
	{"StfHiltBash",	BOTH_A7_HILT,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_HILT_BASH

	//starts
	{"TL2BR St",	BOTH_S1_S1_TL,		Q_R,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_TL2BR,		LS_A_TL2BR,		200	},	// LS_S_TL2BR
	{"L2R St",		BOTH_S1_S1__L,		Q_R,	Q_L,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_L2R,		LS_A_L2R,		200	},	// LS_S_L2R
	{"BL2TR St",	BOTH_S1_S1_BL,		Q_R,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_BL2TR,		LS_A_BL2TR,		200	},	// LS_S_BL2TR
	{"BR2TL St",	BOTH_S1_S1_BR,		Q_R,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_BR2TL,		LS_A_BR2TL,		200	},	// LS_S_BR2TL
	{"R2L St",		BOTH_S1_S1__R,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_R2L,		LS_A_R2L,		200	},	// LS_S_R2L
	{"TR2BL St",	BOTH_S1_S1_TR,		Q_R,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_TR2BL,		LS_A_TR2BL,		200	},	// LS_S_TR2BL
	{"T2B St",		BOTH_S1_S1_T_,		Q_R,	Q_T,	AFLAG_ACTIVE,	100,	BLK_TIGHT,	LS_A_T2B,		LS_A_T2B,		200	},	// LS_S_T2B
	
	//returns
	{"TL2BR Ret",	BOTH_R1_BR_S1,		Q_BR,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_TL2BR
	{"L2R Ret",		BOTH_R1__R_S1,		Q_R,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_L2R
	{"BL2TR Ret",	BOTH_R1_TR_S1,		Q_TR,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_BL2TR
	{"BR2TL Ret",	BOTH_R1_TL_S1,		Q_TL,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_BR2TL
	{"R2L Ret",		BOTH_R1__L_S1,		Q_L,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_R2L
	{"TR2BL Ret",	BOTH_R1_BL_S1,		Q_BL,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_TR2BL
	{"T2B Ret",		BOTH_R1_B__S1,		Q_B,	Q_R,	AFLAG_FINISH,	100,	BLK_TIGHT,	LS_READY,		LS_READY,		200	},	// LS_R_T2B

	//Transitions
	{"BR2R Trans",	BOTH_T1_BR__R,		Q_BR,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_A_R2L,		150	},	//# Fast arc bottom right to right
	{"BR2TR Trans",	BOTH_T1_BR_TR,		Q_BR,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	//# Fast arc bottom right to top right		(use: BOTH_T1_TR_BR)
	{"BR2T Trans",	BOTH_T1_BR_T_,		Q_BR,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_T2B,		150	},	//# Fast arc bottom right to top			(use: BOTH_T1_T__BR)
	{"BR2TL Trans",	BOTH_T1_BR_TL,		Q_BR,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	//# Fast weak spin bottom right to top left
	{"BR2L Trans",	BOTH_T1_BR__L,		Q_BR,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_A_L2R,		150	},	//# Fast weak spin bottom right to left
	{"BR2BL Trans",	BOTH_T1_BR_BL,		Q_BR,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	//# Fast weak spin bottom right to bottom left
	{"R2BR Trans",	BOTH_T1__R_BR,		Q_R,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	//# Fast arc right to bottom right			(use: BOTH_T1_BR__R)
	{"R2TR Trans",	BOTH_T1__R_TR,		Q_R,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	//# Fast arc right to top right
	{"R2T Trans",	BOTH_T1__R_T_,		Q_R,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_T2B,		150	},	//# Fast ar right to top				(use: BOTH_T1_T___R)
	{"R2TL Trans",	BOTH_T1__R_TL,		Q_R,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	//# Fast arc right to top left
	{"R2L Trans",	BOTH_T1__R__L,		Q_R,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_A_L2R,		150	},	//# Fast weak spin right to left
	{"R2BL Trans",	BOTH_T1__R_BL,		Q_R,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	//# Fast weak spin right to bottom left
	{"TR2BR Trans",	BOTH_T1_TR_BR,		Q_TR,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	//# Fast arc top right to bottom right
	{"TR2R Trans",	BOTH_T1_TR__R,		Q_TR,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_A_R2L,		150	},	//# Fast arc top right to right			(use: BOTH_T1__R_TR)
	{"TR2T Trans",	BOTH_T1_TR_T_,		Q_TR,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_T2B,		150	},	//# Fast arc top right to top				(use: BOTH_T1_T__TR)
	{"TR2TL Trans",	BOTH_T1_TR_TL,		Q_TR,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	//# Fast arc top right to top left
	{"TR2L Trans",	BOTH_T1_TR__L,		Q_TR,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_A_L2R,		150	},	//# Fast arc top right to left
	{"TR2BL Trans",	BOTH_T1_TR_BL,		Q_TR,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	//# Fast weak spin top right to bottom left
	{"T2BR Trans",	BOTH_T1_T__BR,		Q_T,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	//# Fast arc top to bottom right
	{"T2R Trans",	BOTH_T1_T___R,		Q_T,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_A_R2L,		150	},	//# Fast arc top to right
	{"T2TR Trans",	BOTH_T1_T__TR,		Q_T,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	//# Fast arc top to top right
	{"T2TL Trans",	BOTH_T1_T__TL,		Q_T,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	//# Fast arc top to top left
	{"T2L Trans",	BOTH_T1_T___L,		Q_T,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_A_L2R,		150	},	//# Fast arc top to left
	{"T2BL Trans",	BOTH_T1_T__BL,		Q_T,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	//# Fast arc top to bottom left
	{"TL2BR Trans",	BOTH_T1_TL_BR,		Q_TL,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	//# Fast weak spin top left to bottom right
	{"TL2R Trans",	BOTH_T1_TL__R,		Q_TL,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_A_R2L,		150	},	//# Fast arc top left to right			(use: BOTH_T1__R_TL)
	{"TL2TR Trans",	BOTH_T1_TL_TR,		Q_TL,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	//# Fast arc top left to top right			(use: BOTH_T1_TR_TL)
	{"TL2T Trans",	BOTH_T1_TL_T_,		Q_TL,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_T2B,		150	},	//# Fast arc top left to top				(use: BOTH_T1_T__TL)
	{"TL2L Trans",	BOTH_T1_TL__L,		Q_TL,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_A_L2R,		150	},	//# Fast arc top left to left				(use: BOTH_T1__L_TL)
	{"TL2BL Trans",	BOTH_T1_TL_BL,		Q_TL,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	//# Fast arc top left to bottom left
	{"L2BR Trans",	BOTH_T1__L_BR,		Q_L,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	//# Fast weak spin left to bottom right
	{"L2R Trans",	BOTH_T1__L__R,		Q_L,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_A_R2L,		150	},	//# Fast weak spin left to right
	{"L2TR Trans",	BOTH_T1__L_TR,		Q_L,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	//# Fast arc left to top right			(use: BOTH_T1_TR__L)
	{"L2T Trans",	BOTH_T1__L_T_,		Q_L,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_T2B,		150	},	//# Fast arc left to top				(use: BOTH_T1_T___L)
	{"L2TL Trans",	BOTH_T1__L_TL,		Q_L,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	//# Fast arc left to top left
	{"L2BL Trans",	BOTH_T1__L_BL,		Q_L,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	//# Fast arc left to bottom left			(use: BOTH_T1_BL__L)
	{"BL2BR Trans",	BOTH_T1_BL_BR,		Q_BL,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	//# Fast weak spin bottom left to bottom right
	{"BL2R Trans",	BOTH_T1_BL__R,		Q_BL,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_A_R2L,		150	},	//# Fast weak spin bottom left to right
	{"BL2TR Trans",	BOTH_T1_BL_TR,		Q_BL,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	//# Fast weak spin bottom left to top right
	{"BL2T Trans",	BOTH_T1_BL_T_,		Q_BL,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_A_T2B,		150	},	//# Fast arc bottom left to top			(use: BOTH_T1_T__BL)
	{"BL2TL Trans",	BOTH_T1_BL_TL,		Q_BL,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	//# Fast arc bottom left to top left		(use: BOTH_T1_TL_BL)
	{"BL2L Trans",	BOTH_T1_BL__L,		Q_BL,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_A_L2R,		150	},	//# Fast arc bottom left to left

	//Bounces
	{"Bounce BR",	BOTH_B1_BR___,		Q_BR,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_T1_BR_TR,	150	},	
	{"Bounce R",	BOTH_B1__R___,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_T1__R__L,	150	},	
	{"Bounce TR",	BOTH_B1_TR___,		Q_TR,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_T1_TR_TL,	150	},	
	{"Bounce T",	BOTH_B1_T____,		Q_T,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_T1_T__BL,	150	},	
	{"Bounce TL",	BOTH_B1_TL___,		Q_TL,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_T1_TL_TR,	150	},	
	{"Bounce L",	BOTH_B1__L___,		Q_L,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_T1__L__R,	150	},	
	{"Bounce BL",	BOTH_B1_BL___,		Q_BL,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_T1_BL_TR,	150	},	

	//Deflected attacks (like bounces, but slide off enemy saber, not straight back)
	{"Deflect BR",	BOTH_D1_BR___,		Q_BR,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TL2BR,		LS_T1_BR_TR,	150	},	
	{"Deflect R",	BOTH_D1__R___,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_L2R,		LS_T1__R__L,	150	},	
	{"Deflect TR",	BOTH_D1_TR___,		Q_TR,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_T1_TR_TL,	150	},	
	{"Deflect T",	BOTH_B1_T____,		Q_T,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_T1_T__BL,	150	},	
	{"Deflect TL",	BOTH_D1_TL___,		Q_TL,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BR2TL,		LS_T1_TL_TR,	150	},	
	{"Deflect L",	BOTH_D1__L___,		Q_L,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_R2L,		LS_T1__L__R,	150	},	
	{"Deflect BL",	BOTH_D1_BL___,		Q_BL,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_TR2BL,		LS_T1_BL_TR,	150	},	
	{"Deflect B",	BOTH_D1_B____,		Q_B,	Q_B,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_R_BL2TR,		LS_T1_T__BL,	150	},	

	//Reflected attacks
	{"Reflected BR",BOTH_V1_BR_S1,		Q_BR,	Q_BR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1_BR
	{"Reflected R",	BOTH_V1__R_S1,		Q_R,	Q_R,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1__R
	{"Reflected TR",BOTH_V1_TR_S1,		Q_TR,	Q_TR,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1_TR
	{"Reflected T",	BOTH_V1_T__S1,		Q_T,	Q_T,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1_T_
	{"Reflected TL",BOTH_V1_TL_S1,		Q_TL,	Q_TL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1_TL
	{"Reflected L",	BOTH_V1__L_S1,		Q_L,	Q_L,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1__L
	{"Reflected BL",BOTH_V1_BL_S1,		Q_BL,	Q_BL,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1_BL
	{"Reflected B",	BOTH_V1_B__S1,		Q_B,	Q_B,	AFLAG_ACTIVE,	100,	BLK_NO,	LS_READY,		LS_READY,	150	},//	LS_V1_B_

	// Broken parries
	{"BParry Top",	BOTH_H1_S1_T_,		Q_T,	Q_B,	AFLAG_ACTIVE,	50,		BLK_NO,	LS_READY,		LS_READY,		150	},	// LS_PARRY_UP,
	{"BParry UR",	BOTH_H1_S1_TR,		Q_TR,	Q_BL,	AFLAG_ACTIVE,	50,		BLK_NO,	LS_READY,		LS_READY,		150	},	// LS_PARRY_UR,
	{"BParry UL",	BOTH_H1_S1_TL,		Q_TL,	Q_BR,	AFLAG_ACTIVE,	50,		BLK_NO,	LS_READY,		LS_READY,		150	},	// LS_PARRY_UL,
	{"BParry LR",	BOTH_H1_S1_BL,		Q_BL,	Q_TR,	AFLAG_ACTIVE,	50,		BLK_NO,	LS_READY,		LS_READY,		150	},	// LS_PARRY_LR,
	{"BParry Bot",	BOTH_H1_S1_B_,		Q_B,	Q_T,	AFLAG_ACTIVE,	50,		BLK_NO,	LS_READY,		LS_READY,		150	},	// LS_PARRY_LL
	{"BParry LL",	BOTH_H1_S1_BR,		Q_BR,	Q_TL,	AFLAG_ACTIVE,	50,		BLK_NO,	LS_READY,		LS_READY,		150	},	// LS_PARRY_LL

	// Knockaways
	{"Knock Top",	BOTH_K1_S1_T_,		Q_R,	Q_T,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BL2TR,		LS_T1_T__BR,		150	},	// LS_PARRY_UP,
	{"Knock UR",	BOTH_K1_S1_TR,		Q_R,	Q_TR,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BL2TR,		LS_T1_TR__R,		150	},	// LS_PARRY_UR,
	{"Knock UL",	BOTH_K1_S1_TL,		Q_R,	Q_TL,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BR2TL,		LS_T1_TL__L,		150	},	// LS_PARRY_UL,
	{"Knock LR",	BOTH_K1_S1_BL,		Q_R,	Q_BL,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_TL2BR,		LS_T1_BL_TL,		150	},	// LS_PARRY_LR,
	{"Knock LL",	BOTH_K1_S1_BR,		Q_R,	Q_BR,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_TR2BL,		LS_T1_BR_TR,		150	},	// LS_PARRY_LL

	// Parry
	{"Parry Top",	BOTH_P1_S1_T_,		Q_R,	Q_T,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BL2TR,		LS_A_T2B,		150	},	// LS_PARRY_UP,
	{"Parry UR",	BOTH_P1_S1_TR,		Q_R,	Q_TL,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BL2TR,		LS_A_TR2BL,		150	},	// LS_PARRY_UR,
	{"Parry UL",	BOTH_P1_S1_TL,		Q_R,	Q_TR,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BR2TL,		LS_A_TL2BR,		150	},	// LS_PARRY_UL,
	{"Parry LR",	BOTH_P1_S1_BL,		Q_R,	Q_BR,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_TL2BR,		LS_A_BR2TL,		150	},	// LS_PARRY_LR,
	{"Parry LL",	BOTH_P1_S1_BR,		Q_R,	Q_BL,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_TR2BL,		LS_A_BL2TR,		150	},	// LS_PARRY_LL

	// Reflecting a missile
	{"Reflect Top",	BOTH_P1_S1_T_,		Q_R,	Q_T,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BL2TR,		LS_A_T2B,		300	},	// LS_PARRY_UP,
	{"Reflect UR",	BOTH_P1_S1_TL,		Q_R,	Q_TR,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BR2TL,		LS_A_TL2BR,		300	},	// LS_PARRY_UR,
	{"Reflect UL",	BOTH_P1_S1_TR,		Q_R,	Q_TL,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_BL2TR,		LS_A_TR2BL,		300	},	// LS_PARRY_UL,
	{"Reflect LR",	BOTH_P1_S1_BR,		Q_R,	Q_BL,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_TR2BL,		LS_A_BL2TR,		300	},	// LS_PARRY_LR
	{"Reflect LL",	BOTH_P1_S1_BL,		Q_R,	Q_BR,	AFLAG_ACTIVE,	50,		BLK_WIDE,	LS_R_TL2BR,		LS_A_BR2TL,		300	},	// LS_PARRY_LL,
};


// Source: oracle/codemp/cgame/animtable.h:9-1791
stringID_table_t animTable [MAX_ANIMATIONS+1] =
{
	//=================================================
	//HEAD ANIMS
	//=================================================
	//# #sep Head-only anims
	ENUM2STRING(FACE_TALK0),			//# silent
	ENUM2STRING(FACE_TALK1),			//# quiet
	ENUM2STRING(FACE_TALK2),			//# semi-quiet
	ENUM2STRING(FACE_TALK3),			//# semi-loud
	ENUM2STRING(FACE_TALK4),			//# loud
	ENUM2STRING(FACE_ALERT),				//# 
	ENUM2STRING(FACE_SMILE),				//# 
	ENUM2STRING(FACE_FROWN),				//# 
	ENUM2STRING(FACE_DEAD),				//# 

	//=================================================
	//ANIMS IN WHICH UPPER AND LOWER OBJECTS ARE IN MD3
	//=================================================
	//# #sep ENUM2STRING(BOTH_ DEATHS
	ENUM2STRING(BOTH_DEATH1),		//# First Death anim
	ENUM2STRING(BOTH_DEATH2),			//# Second Death anim
	ENUM2STRING(BOTH_DEATH3),			//# Third Death anim
	ENUM2STRING(BOTH_DEATH4),			//# Fourth Death anim
	ENUM2STRING(BOTH_DEATH5),			//# Fifth Death anim
	ENUM2STRING(BOTH_DEATH6),			//# Sixth Death anim
	ENUM2STRING(BOTH_DEATH7),			//# Seventh Death anim
	ENUM2STRING(BOTH_DEATH8),			//# 
	ENUM2STRING(BOTH_DEATH9),			//# 
	ENUM2STRING(BOTH_DEATH10),			//# 
	ENUM2STRING(BOTH_DEATH11),			//#
	ENUM2STRING(BOTH_DEATH12),			//# 
	ENUM2STRING(BOTH_DEATH13),			//# 
	ENUM2STRING(BOTH_DEATH14),			//# 
	ENUM2STRING(BOTH_DEATH15),			//# 
	ENUM2STRING(BOTH_DEATH16),			//# 
	ENUM2STRING(BOTH_DEATH17),			//# 
	ENUM2STRING(BOTH_DEATH18),			//# 
	ENUM2STRING(BOTH_DEATH19),			//# 
	ENUM2STRING(BOTH_DEATH20),			//# 
	ENUM2STRING(BOTH_DEATH21),			//# 
	ENUM2STRING(BOTH_DEATH22),			//# 
	ENUM2STRING(BOTH_DEATH23),			//# 
	ENUM2STRING(BOTH_DEATH24),			//# 
	ENUM2STRING(BOTH_DEATH25),			//# 

	ENUM2STRING(BOTH_DEATHFORWARD1),		//# First Death in which they get thrown forward
	ENUM2STRING(BOTH_DEATHFORWARD2),		//# Second Death in which they get thrown forward
	ENUM2STRING(BOTH_DEATHFORWARD3),		//# Tavion's falling in cin# 23
	ENUM2STRING(BOTH_DEATHBACKWARD1),	//# First Death in which they get thrown backward
	ENUM2STRING(BOTH_DEATHBACKWARD2),	//# Second Death in which they get thrown backward

	ENUM2STRING(BOTH_DEATH1IDLE),		//# Idle while close to death
	ENUM2STRING(BOTH_LYINGDEATH1),		//# Death to play when killed lying down
	ENUM2STRING(BOTH_STUMBLEDEATH1),		//# Stumble forward and fall face first death
	ENUM2STRING(BOTH_FALLDEATH1),		//# Fall forward off a high cliff and splat death - start
	ENUM2STRING(BOTH_FALLDEATH1INAIR),	//# Fall forward off a high cliff and splat death - loop
	ENUM2STRING(BOTH_FALLDEATH1LAND),	//# Fall forward off a high cliff and splat death - hit bottom
	ENUM2STRING(BOTH_DEATH_ROLL),		//# Death anim from a roll
	ENUM2STRING(BOTH_DEATH_FLIP),		//# Death anim from a flip
	ENUM2STRING(BOTH_DEATH_SPIN_90_R),	//# Death anim when facing 90 degrees right
	ENUM2STRING(BOTH_DEATH_SPIN_90_L),	//# Death anim when facing 90 degrees left
	ENUM2STRING(BOTH_DEATH_SPIN_180),	//# Death anim when facing backwards
	ENUM2STRING(BOTH_DEATH_LYING_UP),	//# Death anim when lying on back
	ENUM2STRING(BOTH_DEATH_LYING_DN),	//# Death anim when lying on front
	ENUM2STRING(BOTH_DEATH_FALLING_DN),	//# Death anim when falling on face
	ENUM2STRING(BOTH_DEATH_FALLING_UP),	//# Death anim when falling on back
	ENUM2STRING(BOTH_DEATH_CROUCHED),	//# Death anim when crouched
	//# #sep ENUM2STRING(BOTH_ DEAD POSES # Should be last frame of corresponding previous anims
	ENUM2STRING(BOTH_DEAD1),				//# First Death finished pose
	ENUM2STRING(BOTH_DEAD2),				//# Second Death finished pose
	ENUM2STRING(BOTH_DEAD3),				//# Third Death finished pose
	ENUM2STRING(BOTH_DEAD4),				//# Fourth Death finished pose
	ENUM2STRING(BOTH_DEAD5),				//# Fifth Death finished pose
	ENUM2STRING(BOTH_DEAD6),				//# Sixth Death finished pose
	ENUM2STRING(BOTH_DEAD7),				//# Seventh Death finished pose
	ENUM2STRING(BOTH_DEAD8),				//# 
	ENUM2STRING(BOTH_DEAD9),				//# 
	ENUM2STRING(BOTH_DEAD10),			//# 
	ENUM2STRING(BOTH_DEAD11),			//#
	ENUM2STRING(BOTH_DEAD12),			//# 
	ENUM2STRING(BOTH_DEAD13),			//# 
	ENUM2STRING(BOTH_DEAD14),			//# 
	ENUM2STRING(BOTH_DEAD15),			//# 
	ENUM2STRING(BOTH_DEAD16),			//# 
	ENUM2STRING(BOTH_DEAD17),			//# 
	ENUM2STRING(BOTH_DEAD18),			//# 
	ENUM2STRING(BOTH_DEAD19),			//# 
	ENUM2STRING(BOTH_DEAD20),			//# 
	ENUM2STRING(BOTH_DEAD21),			//# 
	ENUM2STRING(BOTH_DEAD22),			//# 
	ENUM2STRING(BOTH_DEAD23),			//# 
	ENUM2STRING(BOTH_DEAD24),			//# 
	ENUM2STRING(BOTH_DEAD25),			//# 
	ENUM2STRING(BOTH_DEADFORWARD1),		//# First thrown forward death finished pose
	ENUM2STRING(BOTH_DEADFORWARD2),		//# Second thrown forward death finished pose
	ENUM2STRING(BOTH_DEADBACKWARD1),		//# First thrown backward death finished pose
	ENUM2STRING(BOTH_DEADBACKWARD2),		//# Second thrown backward death finished pose
	ENUM2STRING(BOTH_LYINGDEAD1),		//# Killed lying down death finished pose
	ENUM2STRING(BOTH_STUMBLEDEAD1),		//# Stumble forward death finished pose
	ENUM2STRING(BOTH_FALLDEAD1LAND),		//# Fall forward and splat death finished pose
	//# #sep ENUM2STRING(BOTH_ DEAD TWITCH/FLOP # React to being shot from death poses
	ENUM2STRING(BOTH_DEADFLOP1),		//# React to being shot from First Death finished pose
	ENUM2STRING(BOTH_DEADFLOP2),		//# React to being shot from Second Death finished pose
	ENUM2STRING(BOTH_DISMEMBER_HEAD1),	//#
	ENUM2STRING(BOTH_DISMEMBER_TORSO1),	//#
	ENUM2STRING(BOTH_DISMEMBER_LLEG),	//#
	ENUM2STRING(BOTH_DISMEMBER_RLEG),	//#
	ENUM2STRING(BOTH_DISMEMBER_RARM),	//#
	ENUM2STRING(BOTH_DISMEMBER_LARM),	//#
	//# #sep ENUM2STRING(BOTH_ PAINS
	ENUM2STRING(BOTH_PAIN1),				//# First take pain anim
	ENUM2STRING(BOTH_PAIN2),				//# Second take pain anim
	ENUM2STRING(BOTH_PAIN3),				//# Third take pain anim
	ENUM2STRING(BOTH_PAIN4),				//# Fourth take pain anim
	ENUM2STRING(BOTH_PAIN5),				//# Fifth take pain anim - from behind
	ENUM2STRING(BOTH_PAIN6),				//# Sixth take pain anim - from behind
	ENUM2STRING(BOTH_PAIN7),				//# Seventh take pain anim - from behind
	ENUM2STRING(BOTH_PAIN8),				//# Eigth take pain anim - from behind
	ENUM2STRING(BOTH_PAIN9),				//# 
	ENUM2STRING(BOTH_PAIN10),			//# 
	ENUM2STRING(BOTH_PAIN11),			//# 
	ENUM2STRING(BOTH_PAIN12),			//# 
	ENUM2STRING(BOTH_PAIN13),			//# 
	ENUM2STRING(BOTH_PAIN14),			//# 
	ENUM2STRING(BOTH_PAIN15),			//# 
	ENUM2STRING(BOTH_PAIN16),			//# 
	ENUM2STRING(BOTH_PAIN17),			//# 
	ENUM2STRING(BOTH_PAIN18),			//# 

	//# #sep ENUM2STRING(BOTH_ ATTACKS
	ENUM2STRING(BOTH_ATTACK1),			//# Attack with stun baton
	ENUM2STRING(BOTH_ATTACK2),			//# Attack with one-handed pistol
	ENUM2STRING(BOTH_ATTACK3),			//# Attack with blaster rifle
	ENUM2STRING(BOTH_ATTACK4),			//# Attack with disruptor
	ENUM2STRING(BOTH_ATTACK5),			//# Another Rancor Attack
	ENUM2STRING(BOTH_ATTACK6),			//# Yet Another Rancor Attack
	ENUM2STRING(BOTH_ATTACK7),			//# Yet Another Rancor Attack
	ENUM2STRING(BOTH_ATTACK10),			//# Attack with thermal det
	ENUM2STRING(BOTH_ATTACK11),			//# "Attack" with tripmine and detpack
	ENUM2STRING(BOTH_MELEE1),			//# First melee attack
	ENUM2STRING(BOTH_MELEE2),			//# Second melee attack
	ENUM2STRING(BOTH_THERMAL_READY),	//# pull back with thermal
	ENUM2STRING(BOTH_THERMAL_THROW),	//# throw thermal
	//* #sep ENUM2STRING(BOTH_ SABER ANIMS
	//Saber attack anims - power level 1
	ENUM2STRING(BOTH_A1_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A1__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A1__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A1_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A1_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A1_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A1_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T1_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T1_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T1_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T1_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T1__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T1__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T1__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T1__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T1_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T1_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T1_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T1_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T1_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T1_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T1_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T1_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T1_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T1_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T1_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T1_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T1__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T1__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T1__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T1_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T1_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T1_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T1_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T1_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T1_TR_BR)
	ENUM2STRING(BOTH_T1_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T1_T__BR)
	ENUM2STRING(BOTH_T1__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T1_BR__R)
	ENUM2STRING(BOTH_T1__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T1_T___R)
	ENUM2STRING(BOTH_T1_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T1__R_TR)
	ENUM2STRING(BOTH_T1_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T1_T__TR)
	ENUM2STRING(BOTH_T1_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T1__R_TL)
	ENUM2STRING(BOTH_T1_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T1_TR_TL)
	ENUM2STRING(BOTH_T1_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T1_T__TL)
	ENUM2STRING(BOTH_T1_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T1__L_TL)
	ENUM2STRING(BOTH_T1__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T1_TR__L)
	ENUM2STRING(BOTH_T1__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T1_T___L)
	ENUM2STRING(BOTH_T1__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T1_BL__L)
	ENUM2STRING(BOTH_T1_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T1_T__BL)
	ENUM2STRING(BOTH_T1_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T1_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S1_S1_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S1_S1__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S1_S1__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S1_S1_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S1_S1_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S1_S1_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S1_S1_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R1_B__S1),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R1__L_S1),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R1__R_S1),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R1_TL_S1),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R1_BR_S1),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R1_BL_S1),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R1_TR_S1),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B1_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B1__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B1_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B1_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B1_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B1__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B1_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D1_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D1__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D1_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D1_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D1__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D1_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D1_B____),	//# Deflection toward B
	//Saber attack anims - power level 2
	ENUM2STRING(BOTH_A2_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A2__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A2__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A2_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A2_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A2_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A2_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T2_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T2_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T2_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T2_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T2__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T2__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T2__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T2__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T2_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T2_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T2_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T2_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T2_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T2_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T2_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T2_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T2_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T2_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T2_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T2_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T2__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T2__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T2__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T2_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T2_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T2_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T2_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T2_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T2_TR_BR)
	ENUM2STRING(BOTH_T2_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T2_T__BR)
	ENUM2STRING(BOTH_T2__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T2_BR__R)
	ENUM2STRING(BOTH_T2__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T2_T___R)
	ENUM2STRING(BOTH_T2_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T2__R_TR)
	ENUM2STRING(BOTH_T2_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T2_T__TR)
	ENUM2STRING(BOTH_T2_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T2__R_TL)
	ENUM2STRING(BOTH_T2_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T2_TR_TL)
	ENUM2STRING(BOTH_T2_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T2_T__TL)
	ENUM2STRING(BOTH_T2_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T2__L_TL)
	ENUM2STRING(BOTH_T2__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T2_TR__L)
	ENUM2STRING(BOTH_T2__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T2_T___L)
	ENUM2STRING(BOTH_T2__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T2_BL__L)
	ENUM2STRING(BOTH_T2_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T2_T__BL)
	ENUM2STRING(BOTH_T2_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T2_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S2_S1_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S2_S1__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S2_S1__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S2_S1_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S2_S1_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S2_S1_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S2_S1_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R2_B__S1),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R2__L_S1),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R2__R_S1),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R2_TL_S1),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R2_BR_S1),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R2_BL_S1),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R2_TR_S1),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B2_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B2__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B2_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B2_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B2_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B2__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B2_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D2_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D2__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D2_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D2_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D2__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D2_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D2_B____),	//# Deflection toward B
	//Saber attack anims - power level 3
	ENUM2STRING(BOTH_A3_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A3__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A3__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A3_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A3_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A3_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A3_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T3_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T3_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T3_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T3_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T3__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T3__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T3__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T3__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T3_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T3_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T3_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T3_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T3_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T3_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T3_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T3_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T3_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T3_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T3_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T3_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T3__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T3__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T3__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T3_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T3_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T3_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T3_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T3_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T3_TR_BR)
	ENUM2STRING(BOTH_T3_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T3_T__BR)
	ENUM2STRING(BOTH_T3__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T3_BR__R)
	ENUM2STRING(BOTH_T3__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T3_T___R)
	ENUM2STRING(BOTH_T3_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T3__R_TR)
	ENUM2STRING(BOTH_T3_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T3_T__TR)
	ENUM2STRING(BOTH_T3_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T3__R_TL)
	ENUM2STRING(BOTH_T3_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T3_TR_TL)
	ENUM2STRING(BOTH_T3_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T3_T__TL)
	ENUM2STRING(BOTH_T3_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T3__L_TL)
	ENUM2STRING(BOTH_T3__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T3_TR__L)
	ENUM2STRING(BOTH_T3__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T3_T___L)
	ENUM2STRING(BOTH_T3__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T3_BL__L)
	ENUM2STRING(BOTH_T3_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T3_T__BL)
	ENUM2STRING(BOTH_T3_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T3_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S3_S1_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S3_S1__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S3_S1__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S3_S1_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S3_S1_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S3_S1_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S3_S1_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R3_B__S1),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R3__L_S1),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R3__R_S1),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R3_TL_S1),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R3_BR_S1),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R3_BL_S1),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R3_TR_S1),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B3_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B3__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B3_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B3_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B3_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B3__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B3_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D3_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D3__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D3_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D3_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D3__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D3_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D3_B____),	//# Deflection toward B
	//Saber attack anims - power level 4 - Desann's
	ENUM2STRING(BOTH_A4_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A4__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A4__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A4_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A4_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A4_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A4_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T4_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T4_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T4_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T4_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T4__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T4__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T4__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T4__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T4_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T4_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T4_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T4_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T4_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T4_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T4_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T4_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T4_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T4_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T4_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T4_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T4__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T4__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T4__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T4_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T4_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T4_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T4_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T4_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T4_TR_BR)
	ENUM2STRING(BOTH_T4_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T4_T__BR)
	ENUM2STRING(BOTH_T4__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T4_BR__R)
	ENUM2STRING(BOTH_T4__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T4_T___R)
	ENUM2STRING(BOTH_T4_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T4__R_TR)
	ENUM2STRING(BOTH_T4_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T4_T__TR)
	ENUM2STRING(BOTH_T4_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T4__R_TL)
	ENUM2STRING(BOTH_T4_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T4_TR_TL)
	ENUM2STRING(BOTH_T4_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T4_T__TL)
	ENUM2STRING(BOTH_T4_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T4__L_TL)
	ENUM2STRING(BOTH_T4__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T4_TR__L)
	ENUM2STRING(BOTH_T4__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T4_T___L)
	ENUM2STRING(BOTH_T4__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T4_BL__L)
	ENUM2STRING(BOTH_T4_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T4_T__BL)
	ENUM2STRING(BOTH_T4_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T4_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S4_S1_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S4_S1__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S4_S1__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S4_S1_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S4_S1_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S4_S1_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S4_S1_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R4_B__S1),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R4__L_S1),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R4__R_S1),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R4_TL_S1),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R4_BR_S1),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R4_BL_S1),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R4_TR_S1),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B4_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B4__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B4_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B4_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B4_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B4__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B4_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D4_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D4__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D4_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D4_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D4__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D4_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D4_B____),	//# Deflection toward B
	//Saber attack anims - power level 5 - Tavion's
	ENUM2STRING(BOTH_A5_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A5__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A5__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A5_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A5_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A5_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A5_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T5_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T5_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T5_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T5_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T5__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T5__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T5__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T5__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T5_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T5_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T5_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T5_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T5_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T5_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T5_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T5_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T5_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T5_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T5_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T5_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T5__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T5__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T5__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T5_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T5_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T5_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T5_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T5_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T5_TR_BR)
	ENUM2STRING(BOTH_T5_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T5_T__BR)
	ENUM2STRING(BOTH_T5__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T5_BR__R)
	ENUM2STRING(BOTH_T5__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T5_T___R)
	ENUM2STRING(BOTH_T5_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T5__R_TR)
	ENUM2STRING(BOTH_T5_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T5_T__TR)
	ENUM2STRING(BOTH_T5_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T5__R_TL)
	ENUM2STRING(BOTH_T5_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T5_TR_TL)
	ENUM2STRING(BOTH_T5_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T5_T__TL)
	ENUM2STRING(BOTH_T5_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T5__L_TL)
	ENUM2STRING(BOTH_T5__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T5_TR__L)
	ENUM2STRING(BOTH_T5__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T5_T___L)
	ENUM2STRING(BOTH_T5__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T5_BL__L)
	ENUM2STRING(BOTH_T5_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T5_T__BL)
	ENUM2STRING(BOTH_T5_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T5_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S5_S1_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S5_S1__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S5_S1__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S5_S1_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S5_S1_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S5_S1_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S5_S1_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R5_B__S1),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R5__L_S1),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R5__R_S1),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R5_TL_S1),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R5_BR_S1),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R5_BL_S1),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R5_TR_S1),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B5_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B5__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B5_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B5_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B5_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B5__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B5_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D5_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D5__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D5_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D5_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D5__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D5_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D5_B____),	//# Deflection toward B
	//Saber attack anims - power level 6
	ENUM2STRING(BOTH_A6_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A6__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A6__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A6_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A6_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A6_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A6_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T6_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T6_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T6_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T6_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T6__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T6__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T6__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T6__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T6_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T6_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T6_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T6_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T6_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T6_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T6_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T6_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T6_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T6_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T6_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T6_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T6__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T6__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T6__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T6_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T6_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T6_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T6_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T6_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T6_TR_BR)
	ENUM2STRING(BOTH_T6_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T6_T__BR)
	ENUM2STRING(BOTH_T6__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T6_BR__R)
	ENUM2STRING(BOTH_T6__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T6_T___R)
	ENUM2STRING(BOTH_T6_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T6__R_TR)
	ENUM2STRING(BOTH_T6_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T6_T__TR)
	ENUM2STRING(BOTH_T6_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T6__R_TL)
	ENUM2STRING(BOTH_T6_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T6_TR_TL)
	ENUM2STRING(BOTH_T6_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T6_T__TL)
	ENUM2STRING(BOTH_T6_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T6__L_TL)
	ENUM2STRING(BOTH_T6__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T6_TR__L)
	ENUM2STRING(BOTH_T6__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T6_T___L)
	ENUM2STRING(BOTH_T6__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T6_BL__L)
	ENUM2STRING(BOTH_T6_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T6_T__BL)
	ENUM2STRING(BOTH_T6_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T6_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S6_S6_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S6_S6__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S6_S6__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S6_S6_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S6_S6_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S6_S6_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S6_S6_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R6_B__S6),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R6__L_S6),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R6__R_S6),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R6_TL_S6),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R6_BR_S6),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R6_BL_S6),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R6_TR_S6),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B6_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B6__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B6_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B6_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B6_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B6__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B6_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D6_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D6__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D6_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D6_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D6__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D6_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D6_B____),	//# Deflection toward B
	//Saber attack anims - power level 7
	ENUM2STRING(BOTH_A7_T__B_),	//# Fast weak vertical attack top to bottom
	ENUM2STRING(BOTH_A7__L__R),	//# Fast weak horizontal attack left to right
	ENUM2STRING(BOTH_A7__R__L),	//# Fast weak horizontal attack right to left
	ENUM2STRING(BOTH_A7_TL_BR),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A7_BR_TL),	//# Fast weak diagonal attack top left to botom right
	ENUM2STRING(BOTH_A7_BL_TR),	//# Fast weak diagonal attack bottom left to top right
	ENUM2STRING(BOTH_A7_TR_BL),	//# Fast weak diagonal attack bottom left to right
	//Saber Arc and Spin Transitions
	ENUM2STRING(BOTH_T7_BR__R),	//# Fast arc bottom right to right
	ENUM2STRING(BOTH_T7_BR_TL),	//# Fast weak spin bottom right to top left
	ENUM2STRING(BOTH_T7_BR__L),	//# Fast weak spin bottom right to left
	ENUM2STRING(BOTH_T7_BR_BL),	//# Fast weak spin bottom right to bottom left
	ENUM2STRING(BOTH_T7__R_TR),	//# Fast arc right to top right
	ENUM2STRING(BOTH_T7__R_TL),	//# Fast arc right to top left
	ENUM2STRING(BOTH_T7__R__L),	//# Fast weak spin right to left
	ENUM2STRING(BOTH_T7__R_BL),	//# Fast weak spin right to bottom left
	ENUM2STRING(BOTH_T7_TR_BR),	//# Fast arc top right to bottom right
	ENUM2STRING(BOTH_T7_TR_TL),	//# Fast arc top right to top left
	ENUM2STRING(BOTH_T7_TR__L),	//# Fast arc top right to left
	ENUM2STRING(BOTH_T7_TR_BL),	//# Fast weak spin top right to bottom left
	ENUM2STRING(BOTH_T7_T__BR),	//# Fast arc top to bottom right
	ENUM2STRING(BOTH_T7_T___R),	//# Fast arc top to right
	ENUM2STRING(BOTH_T7_T__TR),	//# Fast arc top to top right
	ENUM2STRING(BOTH_T7_T__TL),	//# Fast arc top to top left
	ENUM2STRING(BOTH_T7_T___L),	//# Fast arc top to left
	ENUM2STRING(BOTH_T7_T__BL),	//# Fast arc top to bottom left
	ENUM2STRING(BOTH_T7_TL_BR),	//# Fast weak spin top left to bottom right
	ENUM2STRING(BOTH_T7_TL_BL),	//# Fast arc top left to bottom left
	ENUM2STRING(BOTH_T7__L_BR),	//# Fast weak spin left to bottom right
	ENUM2STRING(BOTH_T7__L__R),	//# Fast weak spin left to right
	ENUM2STRING(BOTH_T7__L_TL),	//# Fast arc left to top left
	ENUM2STRING(BOTH_T7_BL_BR),	//# Fast weak spin bottom left to bottom right
	ENUM2STRING(BOTH_T7_BL__R),	//# Fast weak spin bottom left to right
	ENUM2STRING(BOTH_T7_BL_TR),	//# Fast weak spin bottom left to top right
	ENUM2STRING(BOTH_T7_BL__L),	//# Fast arc bottom left to left
	//Saber Arc Transitions that use existing animations played backwards
	ENUM2STRING(BOTH_T7_BR_TR),	//# Fast arc bottom right to top right		(use: ENUM2STRING(BOTH_T7_TR_BR)
	ENUM2STRING(BOTH_T7_BR_T_),	//# Fast arc bottom right to top			(use: ENUM2STRING(BOTH_T7_T__BR)
	ENUM2STRING(BOTH_T7__R_BR),	//# Fast arc right to bottom right			(use: ENUM2STRING(BOTH_T7_BR__R)
	ENUM2STRING(BOTH_T7__R_T_),	//# Fast ar right to top				(use: ENUM2STRING(BOTH_T7_T___R)
	ENUM2STRING(BOTH_T7_TR__R),	//# Fast arc top right to right			(use: ENUM2STRING(BOTH_T7__R_TR)
	ENUM2STRING(BOTH_T7_TR_T_),	//# Fast arc top right to top				(use: ENUM2STRING(BOTH_T7_T__TR)
	ENUM2STRING(BOTH_T7_TL__R),	//# Fast arc top left to right			(use: ENUM2STRING(BOTH_T7__R_TL)
	ENUM2STRING(BOTH_T7_TL_TR),	//# Fast arc top left to top right			(use: ENUM2STRING(BOTH_T7_TR_TL)
	ENUM2STRING(BOTH_T7_TL_T_),	//# Fast arc top left to top				(use: ENUM2STRING(BOTH_T7_T__TL)
	ENUM2STRING(BOTH_T7_TL__L),	//# Fast arc top left to left				(use: ENUM2STRING(BOTH_T7__L_TL)
	ENUM2STRING(BOTH_T7__L_TR),	//# Fast arc left to top right			(use: ENUM2STRING(BOTH_T7_TR__L)
	ENUM2STRING(BOTH_T7__L_T_),	//# Fast arc left to top				(use: ENUM2STRING(BOTH_T7_T___L)
	ENUM2STRING(BOTH_T7__L_BL),	//# Fast arc left to bottom left			(use: ENUM2STRING(BOTH_T7_BL__L)
	ENUM2STRING(BOTH_T7_BL_T_),	//# Fast arc bottom left to top			(use: ENUM2STRING(BOTH_T7_T__BL)
	ENUM2STRING(BOTH_T7_BL_TL),	//# Fast arc bottom left to top left		(use: ENUM2STRING(BOTH_T7_TL_BL)
	//Saber Attack Start Transitions
	ENUM2STRING(BOTH_S7_S7_T_),	//# Fast plain transition from stance1 to top-to-bottom Fast weak attack
	ENUM2STRING(BOTH_S7_S7__L),	//# Fast plain transition from stance1 to left-to-right Fast weak attack
	ENUM2STRING(BOTH_S7_S7__R),	//# Fast plain transition from stance1 to right-to-left Fast weak attack
	ENUM2STRING(BOTH_S7_S7_TL),	//# Fast plain transition from stance1 to top-left-to-bottom-right Fast weak attack
	ENUM2STRING(BOTH_S7_S7_BR),	//# Fast plain transition from stance1 to bottom-right-to-top-left Fast weak attack
	ENUM2STRING(BOTH_S7_S7_BL),	//# Fast plain transition from stance1 to bottom-left-to-top-right Fast weak attack
	ENUM2STRING(BOTH_S7_S7_TR),	//# Fast plain transition from stance1 to top-right-to-bottom-left Fast weak attack
	//Saber Attack Return Transitions
	ENUM2STRING(BOTH_R7_B__S7),	//# Fast plain transition from top-to-bottom Fast weak attack to stance1
	ENUM2STRING(BOTH_R7__L_S7),	//# Fast plain transition from left-to-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R7__R_S7),	//# Fast plain transition from right-to-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R7_TL_S7),	//# Fast plain transition from top-left-to-bottom-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R7_BR_S7),	//# Fast plain transition from bottom-right-to-top-left Fast weak attack to stance1
	ENUM2STRING(BOTH_R7_BL_S7),	//# Fast plain transition from bottom-left-to-top-right Fast weak attack to stance1
	ENUM2STRING(BOTH_R7_TR_S7),	//# Fast plain transition from top-right-to-bottom-left Fast weak attack
	//Saber Attack Bounces (first 4 frames of an attack), played backwards)
	ENUM2STRING(BOTH_B7_BR___),	//# Bounce-back if attack from BR is blocked
	ENUM2STRING(BOTH_B7__R___),	//# Bounce-back if attack from R is blocked
	ENUM2STRING(BOTH_B7_TR___),	//# Bounce-back if attack from TR is blocked
	ENUM2STRING(BOTH_B7_T____),	//# Bounce-back if attack from T is blocked
	ENUM2STRING(BOTH_B7_TL___),	//# Bounce-back if attack from TL is blocked
	ENUM2STRING(BOTH_B7__L___),	//# Bounce-back if attack from L is blocked
	ENUM2STRING(BOTH_B7_BL___),	//# Bounce-back if attack from BL is blocked
	//Saber Attack Deflections (last 4 frames of an attack)
	ENUM2STRING(BOTH_D7_BR___),	//# Deflection toward BR
	ENUM2STRING(BOTH_D7__R___),	//# Deflection toward R
	ENUM2STRING(BOTH_D7_TR___),	//# Deflection toward TR
	ENUM2STRING(BOTH_D7_TL___),	//# Deflection toward TL
	ENUM2STRING(BOTH_D7__L___),	//# Deflection toward L
	ENUM2STRING(BOTH_D7_BL___),	//# Deflection toward BL
	ENUM2STRING(BOTH_D7_B____),	//# Deflection toward B
	//Saber parry anims
	ENUM2STRING(BOTH_P1_S1_T_),	//# Block shot/saber top
	ENUM2STRING(BOTH_P1_S1_TR),	//# Block shot/saber top right
	ENUM2STRING(BOTH_P1_S1_TL),	//# Block shot/saber top left
	ENUM2STRING(BOTH_P1_S1_BL),	//# Block shot/saber bottom left
	ENUM2STRING(BOTH_P1_S1_BR),	//# Block shot/saber bottom right
	//Saber knockaway
	ENUM2STRING(BOTH_K1_S1_T_),	//# knockaway saber top
	ENUM2STRING(BOTH_K1_S1_TR),	//# knockaway saber top right
	ENUM2STRING(BOTH_K1_S1_TL),	//# knockaway saber top left
	ENUM2STRING(BOTH_K1_S1_BL),	//# knockaway saber bottom left
	ENUM2STRING(BOTH_K1_S1_B_),	//# knockaway saber bottom
	ENUM2STRING(BOTH_K1_S1_BR),	//# knockaway saber bottom right
	//Saber attack knocked away
	ENUM2STRING(BOTH_V1_BR_S1),	//# BR attack knocked away
	ENUM2STRING(BOTH_V1__R_S1),	//# R attack knocked away
	ENUM2STRING(BOTH_V1_TR_S1),	//# TR attack knocked away
	ENUM2STRING(BOTH_V1_T__S1),	//# T attack knocked away
	ENUM2STRING(BOTH_V1_TL_S1),	//# TL attack knocked away
	ENUM2STRING(BOTH_V1__L_S1),	//# L attack knocked away
	ENUM2STRING(BOTH_V1_BL_S1),	//# BL attack knocked away
	ENUM2STRING(BOTH_V1_B__S1),	//# B attack knocked away
	//Saber parry broken
	ENUM2STRING(BOTH_H1_S1_T_),	//# saber knocked down from top parry
	ENUM2STRING(BOTH_H1_S1_TR),	//# saber knocked down-left from TR parry
	ENUM2STRING(BOTH_H1_S1_TL),	//# saber knocked down-right from TL parry
	ENUM2STRING(BOTH_H1_S1_BL),	//# saber knocked up-right from BL parry
	ENUM2STRING(BOTH_H1_S1_B_),	//# saber knocked up over head from ready?
	ENUM2STRING(BOTH_H1_S1_BR),	//# saber knocked up-left from BR parry
	//Dual Sabers parry anims
	ENUM2STRING(BOTH_P6_S6_T_),	//# Block shot/saber top
	ENUM2STRING(BOTH_P6_S6_TR),	//# Block shot/saber top right
	ENUM2STRING(BOTH_P6_S6_TL),	//# Block shot/saber top left
	ENUM2STRING(BOTH_P6_S6_BL),	//# Block shot/saber bottom left
	ENUM2STRING(BOTH_P6_S6_BR),	//# Block shot/saber bottom right
	//Dual Sabers knockaway
	ENUM2STRING(BOTH_K6_S6_T_),	//# knockaway saber top
	ENUM2STRING(BOTH_K6_S6_TR),	//# knockaway saber top right
	ENUM2STRING(BOTH_K6_S6_TL),	//# knockaway saber top left
	ENUM2STRING(BOTH_K6_S6_BL),	//# knockaway saber bottom left
	ENUM2STRING(BOTH_K6_S6_B_),	//# knockaway saber bottom
	ENUM2STRING(BOTH_K6_S6_BR),	//# knockaway saber bottom right
	//Dual Sabers attack knocked away
	ENUM2STRING(BOTH_V6_BR_S6),	//# BR attack knocked away
	ENUM2STRING(BOTH_V6__R_S6),	//# R attack knocked away
	ENUM2STRING(BOTH_V6_TR_S6),	//# TR attack knocked away
	ENUM2STRING(BOTH_V6_T__S6),	//# T attack knocked away
	ENUM2STRING(BOTH_V6_TL_S6),	//# TL attack knocked away
	ENUM2STRING(BOTH_V6__L_S6),	//# L attack knocked away
	ENUM2STRING(BOTH_V6_BL_S6),	//# BL attack knocked away
	ENUM2STRING(BOTH_V6_B__S6),	//# B attack knocked away
	//Dual Sabers parry broken
	ENUM2STRING(BOTH_H6_S6_T_),	//# saber knocked down from top parry
	ENUM2STRING(BOTH_H6_S6_TR),	//# saber knocked down-left from TR parry
	ENUM2STRING(BOTH_H6_S6_TL),	//# saber knocked down-right from TL parry
	ENUM2STRING(BOTH_H6_S6_BL),	//# saber knocked up-right from BL parry
	ENUM2STRING(BOTH_H6_S6_B_),	//# saber knocked up over head from ready?
	ENUM2STRING(BOTH_H6_S6_BR),	//# saber knocked up-left from BR parry
	//SaberStaff parry anims
	ENUM2STRING(BOTH_P7_S7_T_),	//# Block shot/saber top
	ENUM2STRING(BOTH_P7_S7_TR),	//# Block shot/saber top right
	ENUM2STRING(BOTH_P7_S7_TL),	//# Block shot/saber top left
	ENUM2STRING(BOTH_P7_S7_BL),	//# Block shot/saber bottom left
	ENUM2STRING(BOTH_P7_S7_BR),	//# Block shot/saber bottom right
	//SaberStaff knockaway
	ENUM2STRING(BOTH_K7_S7_T_),	//# knockaway saber top
	ENUM2STRING(BOTH_K7_S7_TR),	//# knockaway saber top right
	ENUM2STRING(BOTH_K7_S7_TL),	//# knockaway saber top left
	ENUM2STRING(BOTH_K7_S7_BL),	//# knockaway saber bottom left
	ENUM2STRING(BOTH_K7_S7_B_),	//# knockaway saber bottom
	ENUM2STRING(BOTH_K7_S7_BR),	//# knockaway saber bottom right
	//SaberStaff attack knocked away
	ENUM2STRING(BOTH_V7_BR_S7),	//# BR attack knocked away
	ENUM2STRING(BOTH_V7__R_S7),	//# R attack knocked away
	ENUM2STRING(BOTH_V7_TR_S7),	//# TR attack knocked away
	ENUM2STRING(BOTH_V7_T__S7),	//# T attack knocked away
	ENUM2STRING(BOTH_V7_TL_S7),	//# TL attack knocked away
	ENUM2STRING(BOTH_V7__L_S7),	//# L attack knocked away
	ENUM2STRING(BOTH_V7_BL_S7),	//# BL attack knocked away
	ENUM2STRING(BOTH_V7_B__S7),	//# B attack knocked away
	//SaberStaff parry broken
	ENUM2STRING(BOTH_H7_S7_T_),	//# saber knocked down from top parry
	ENUM2STRING(BOTH_H7_S7_TR),	//# saber knocked down-left from TR parry
	ENUM2STRING(BOTH_H7_S7_TL),	//# saber knocked down-right from TL parry
	ENUM2STRING(BOTH_H7_S7_BL),	//# saber knocked up-right from BL parry
	ENUM2STRING(BOTH_H7_S7_B_),	//# saber knocked up over head from ready?
	ENUM2STRING(BOTH_H7_S7_BR),	//# saber knocked up-left from BR parry
	//Sabers locked anims
	//* #sep BOTH_ SABER LOCKED ANIMS
	//BOTH_(DL, S, ST)_(DL, S, ST)_(T, S)_(L, B, SB)_1(_W, _L)
//===Single locks==================================================================
//SINGLE vs. DUAL
	//side locks - I'm using a single and they're using dual
	ENUM2STRING(BOTH_LK_S_DL_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_S_DL_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_S_DL_S_L_1),		//lock if I'm using single vs. a dual
	ENUM2STRING(BOTH_LK_S_DL_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_S_DL_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_S_DL_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_S_DL_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_S_DL_T_L_1),		//lock if I'm using single vs. a dual
	ENUM2STRING(BOTH_LK_S_DL_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_S_DL_T_SB_1_W),	//super break I won
//SINGLE vs. STAFF
	//side locks
	ENUM2STRING(BOTH_LK_S_ST_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_S_ST_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_S_ST_S_L_1),		//lock if I'm using single vs. a staff
	ENUM2STRING(BOTH_LK_S_ST_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_S_ST_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_S_ST_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_S_ST_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_S_ST_T_L_1),		//lock if I'm using single vs. a staff
	ENUM2STRING(BOTH_LK_S_ST_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_S_ST_T_SB_1_W),	//super break I won
//SINGLE vs. SINGLE
	//side locks
	ENUM2STRING(BOTH_LK_S_S_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_S_S_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_S_S_S_L_1),		//lock if I'm using single vs. a single and I initiated
	ENUM2STRING(BOTH_LK_S_S_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_S_S_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_S_S_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_S_S_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_S_S_T_L_1),		//lock if I'm using single vs. a single and I initiated
	ENUM2STRING(BOTH_LK_S_S_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_S_S_T_SB_1_W),	//super break I won
//===Dual Saber locks==================================================================
//DUAL vs. DUAL	
	//side locks
	ENUM2STRING(BOTH_LK_DL_DL_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_DL_DL_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_DL_DL_S_L_1),	//lock if I'm using dual vs. dual and I initiated
	ENUM2STRING(BOTH_LK_DL_DL_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_DL_DL_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_DL_DL_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_DL_DL_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_DL_DL_T_L_1),	//lock if I'm using dual vs. dual and I initiated
	ENUM2STRING(BOTH_LK_DL_DL_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_DL_DL_T_SB_1_W),	//super break I won
//DUAL vs. STAFF
	//side locks
	ENUM2STRING(BOTH_LK_DL_ST_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_DL_ST_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_DL_ST_S_L_1),	//lock if I'm using dual vs. a staff
	ENUM2STRING(BOTH_LK_DL_ST_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_DL_ST_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_DL_ST_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_DL_ST_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_DL_ST_T_L_1),	//lock if I'm using dual vs. a staff
	ENUM2STRING(BOTH_LK_DL_ST_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_DL_ST_T_SB_1_W),	//super break I won
//DUAL vs. SINGLE
	//side locks
	ENUM2STRING(BOTH_LK_DL_S_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_DL_S_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_DL_S_S_L_1),		//lock if I'm using dual vs. a single
	ENUM2STRING(BOTH_LK_DL_S_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_DL_S_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_DL_S_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_DL_S_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_DL_S_T_L_1),		//lock if I'm using dual vs. a single
	ENUM2STRING(BOTH_LK_DL_S_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_DL_S_T_SB_1_W),	//super break I won
//===Saber Staff locks==================================================================
//STAFF vs. DUAL
	//side locks
	ENUM2STRING(BOTH_LK_ST_DL_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_ST_DL_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_ST_DL_S_L_1),	//lock if I'm using staff vs. dual
	ENUM2STRING(BOTH_LK_ST_DL_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_ST_DL_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_ST_DL_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_ST_DL_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_ST_DL_T_L_1),	//lock if I'm using staff vs. dual
	ENUM2STRING(BOTH_LK_ST_DL_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_ST_DL_T_SB_1_W),	//super break I won
//STAFF vs. STAFF
	//side locks
	ENUM2STRING(BOTH_LK_ST_ST_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_ST_ST_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_ST_ST_S_L_1),	//lock if I'm using staff vs. a staff and I initiated
	ENUM2STRING(BOTH_LK_ST_ST_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_ST_ST_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_ST_ST_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_ST_ST_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_ST_ST_T_L_1),	//lock if I'm using staff vs. a staff and I initiated
	ENUM2STRING(BOTH_LK_ST_ST_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_ST_ST_T_SB_1_W),	//super break I won
//STAFF vs. SINGLE
	//side locks
	ENUM2STRING(BOTH_LK_ST_S_S_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_ST_S_S_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_ST_S_S_L_1),		//lock if I'm using staff vs. a single
	ENUM2STRING(BOTH_LK_ST_S_S_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_ST_S_S_SB_1_W),	//super break I won
	//top locks
	ENUM2STRING(BOTH_LK_ST_S_T_B_1_L),	//normal break I lost
	ENUM2STRING(BOTH_LK_ST_S_T_B_1_W),	//normal break I won
	ENUM2STRING(BOTH_LK_ST_S_T_L_1),		//lock if I'm using staff vs. a single
	ENUM2STRING(BOTH_LK_ST_S_T_SB_1_L),	//super break I lost
	ENUM2STRING(BOTH_LK_ST_S_T_SB_1_W),	//super break I won
//Special cases for same saber style vs. each other (won't fit in nice 5-anim size lists above)
	ENUM2STRING(BOTH_LK_S_S_S_L_2),		//lock if I'm using single vs. a single and other intitiated
	ENUM2STRING(BOTH_LK_S_S_T_L_2),		//lock if I'm using single vs. a single and other initiated
	ENUM2STRING(BOTH_LK_DL_DL_S_L_2),	//lock if I'm using dual vs. dual and other initiated
	ENUM2STRING(BOTH_LK_DL_DL_T_L_2),	//lock if I'm using dual vs. dual and other initiated
	ENUM2STRING(BOTH_LK_ST_ST_S_L_2),	//lock if I'm using staff vs. a staff and other initiated
	ENUM2STRING(BOTH_LK_ST_ST_T_L_2),	//lock if I'm using staff vs. a staff and other initiated
//===End Saber locks==================================================================
	ENUM2STRING(BOTH_BF2RETURN),	//#
	ENUM2STRING(BOTH_BF2BREAK),	//#
	ENUM2STRING(BOTH_BF2LOCK),	//#
	ENUM2STRING(BOTH_BF1RETURN),	//#
	ENUM2STRING(BOTH_BF1BREAK),	//#
	ENUM2STRING(BOTH_BF1LOCK),	//#
	ENUM2STRING(BOTH_CWCIRCLE_R2__R_S1),	//#
	ENUM2STRING(BOTH_CCWCIRCLE_R2__L_S1),	//#
	ENUM2STRING(BOTH_CWCIRCLE_A2__L__R),	//#
	ENUM2STRING(BOTH_CCWCIRCLE_A2__R__L),	//#
	ENUM2STRING(BOTH_CWCIRCLEBREAK),	//#
	ENUM2STRING(BOTH_CCWCIRCLEBREAK),	//#
	ENUM2STRING(BOTH_CWCIRCLELOCK),	//#
	ENUM2STRING(BOTH_CCWCIRCLELOCK),	//#
	//other saber anims/attacks
	ENUM2STRING(BOTH_SABERFAST_STANCE),
	ENUM2STRING(BOTH_SABERSLOW_STANCE),
	ENUM2STRING(BOTH_SABERDUAL_STANCE),
	ENUM2STRING(BOTH_SABERSTAFF_STANCE),
	ENUM2STRING(BOTH_A2_STABBACK1),		//# Stab saber backward
	ENUM2STRING(BOTH_ATTACK_BACK),		//# Swing around backwards and attack
	ENUM2STRING(BOTH_JUMPFLIPSLASHDOWN1),//#
	ENUM2STRING(BOTH_JUMPFLIPSTABDOWN),//#
	ENUM2STRING(BOTH_FORCELEAP2_T__B_),//#
	ENUM2STRING(BOTH_LUNGE2_B__T_),//#
	ENUM2STRING(BOTH_CROUCHATTACKBACK1),//#
	//New specials for JKA:
	ENUM2STRING(BOTH_JUMPATTACK6),//#
	ENUM2STRING(BOTH_JUMPATTACK7),//#
	ENUM2STRING(BOTH_SPINATTACK6),//#
	ENUM2STRING(BOTH_SPINATTACK7),//#
	ENUM2STRING(BOTH_S1_S6),//#	From stand1 to saberdual stance - turning on your dual sabers
	ENUM2STRING(BOTH_S6_S1),//#	From dualstaff stance to stand1 - turning off your dual sabers
	ENUM2STRING(BOTH_S1_S7),//#	From stand1 to saberstaff stance - turning on your saberstaff
	ENUM2STRING(BOTH_S7_S1),//#	From saberstaff stance to stand1 - turning off your saberstaff
	ENUM2STRING(BOTH_FORCELONGLEAP_START),
	ENUM2STRING(BOTH_FORCELONGLEAP_ATTACK),
	ENUM2STRING(BOTH_FORCELONGLEAP_LAND),
	ENUM2STRING(BOTH_FORCEWALLRUNFLIP_START),
	ENUM2STRING(BOTH_FORCEWALLRUNFLIP_END),
	ENUM2STRING(BOTH_FORCEWALLRUNFLIP_ALT),
	ENUM2STRING(BOTH_FORCEWALLREBOUND_FORWARD),
	ENUM2STRING(BOTH_FORCEWALLREBOUND_LEFT),
	ENUM2STRING(BOTH_FORCEWALLREBOUND_BACK),
	ENUM2STRING(BOTH_FORCEWALLREBOUND_RIGHT),
	ENUM2STRING(BOTH_FORCEWALLHOLD_FORWARD),
	ENUM2STRING(BOTH_FORCEWALLHOLD_LEFT),
	ENUM2STRING(BOTH_FORCEWALLHOLD_BACK),
	ENUM2STRING(BOTH_FORCEWALLHOLD_RIGHT),
	ENUM2STRING(BOTH_FORCEWALLRELEASE_FORWARD),
	ENUM2STRING(BOTH_FORCEWALLRELEASE_LEFT),
	ENUM2STRING(BOTH_FORCEWALLRELEASE_BACK),
	ENUM2STRING(BOTH_FORCEWALLRELEASE_RIGHT),
	ENUM2STRING(BOTH_A7_KICK_F),
	ENUM2STRING(BOTH_A7_KICK_B),
	ENUM2STRING(BOTH_A7_KICK_R),
	ENUM2STRING(BOTH_A7_KICK_L),
	ENUM2STRING(BOTH_A7_KICK_S),
	ENUM2STRING(BOTH_A7_KICK_BF),
	ENUM2STRING(BOTH_A7_KICK_BF_STOP),
	ENUM2STRING(BOTH_A7_KICK_RL),
	ENUM2STRING(BOTH_A7_KICK_F_AIR),
	ENUM2STRING(BOTH_A7_KICK_B_AIR),
	ENUM2STRING(BOTH_A7_KICK_R_AIR),
	ENUM2STRING(BOTH_A7_KICK_L_AIR),
	ENUM2STRING(BOTH_FLIP_ATTACK7),
	ENUM2STRING(BOTH_FLIP_HOLD7),
	ENUM2STRING(BOTH_FLIP_LAND),
	ENUM2STRING(BOTH_PULL_IMPALE_STAB),
	ENUM2STRING(BOTH_PULL_IMPALE_SWING),
	ENUM2STRING(BOTH_PULLED_INAIR_B),
	ENUM2STRING(BOTH_PULLED_INAIR_F),
	ENUM2STRING(BOTH_STABDOWN),
	ENUM2STRING(BOTH_STABDOWN_STAFF),
	ENUM2STRING(BOTH_STABDOWN_DUAL),
	ENUM2STRING(BOTH_A6_SABERPROTECT),
	ENUM2STRING(BOTH_A7_SOULCAL),
	ENUM2STRING(BOTH_A1_SPECIAL),
	ENUM2STRING(BOTH_A2_SPECIAL),
	ENUM2STRING(BOTH_A3_SPECIAL),
	ENUM2STRING(BOTH_ROLL_STAB),

	//# #sep ENUM2STRING(BOTH_ STANDING
	ENUM2STRING(BOTH_STAND1),			//# Standing idle, no weapon, hands down
	ENUM2STRING(BOTH_STAND1IDLE1),		//# Random standing idle
	ENUM2STRING(BOTH_STAND2),			//# Standing idle with a saber
	ENUM2STRING(BOTH_STAND2IDLE1),		//# Random standing idle
	ENUM2STRING(BOTH_STAND2IDLE2),
	ENUM2STRING(BOTH_STAND3),			//# Standing idle with 2-handed weapon
	ENUM2STRING(BOTH_STAND3IDLE1),		//# Random standing idle
	ENUM2STRING(BOTH_STAND4),			//# hands clasp behind back
	ENUM2STRING(BOTH_STAND5),			//# standing idle, no weapon, hand down, back straight
	ENUM2STRING(BOTH_STAND5IDLE1),		//# Random standing idle
	ENUM2STRING(BOTH_STAND6),			//# one handed), gun at side), relaxed stand
	ENUM2STRING(BOTH_STAND8),			//# both hands on hips (male)
	ENUM2STRING(BOTH_STAND1TO2),			//# Transition from stand1 to stand2
	ENUM2STRING(BOTH_STAND2TO1),			//# Transition from stand2 to stand1
	ENUM2STRING(BOTH_STAND2TO4),			//# Transition from stand2 to stand4
	ENUM2STRING(BOTH_STAND4TO2),			//# Transition from stand4 to stand2
	ENUM2STRING(BOTH_STAND4TOATTACK2),	//# relaxed stand to 1-handed pistol ready
	ENUM2STRING(BOTH_STANDUP2),			//# Luke standing up from his meditation platform (cin # 37)
	ENUM2STRING(BOTH_STAND5TOSIT3),		//# transition from stand 5 to sit 3
	ENUM2STRING(BOTH_STAND1TOSTAND5),	//# Transition from stand1 to stand5
	ENUM2STRING(BOTH_STAND5TOSTAND1),	//# Transition from stand5 to stand1
	ENUM2STRING(BOTH_STAND5TOAIM),		//# Transition of Kye aiming his gun at Desann (cin #9) 
	ENUM2STRING(BOTH_STAND5STARTLEDLOOKLEFT),	//# Kyle turning to watch the bridge drop (cin #9) 
	ENUM2STRING(BOTH_STARTLEDLOOKLEFTTOSTAND5),	//# Kyle returning to stand 5 from watching the bridge drop (cin #9) 
	ENUM2STRING(BOTH_STAND5TOSTAND8),	//# Transition from stand5 to stand8
	ENUM2STRING(BOTH_STAND7TOSTAND8),	//# Tavion putting hands on back of chair (cin #11)
	ENUM2STRING(BOTH_STAND8TOSTAND5),	//# Transition from stand8 to stand5
	ENUM2STRING(BOTH_STAND9),			//# Kyle's standing idle, no weapon, hands down
	ENUM2STRING(BOTH_STAND9IDLE1),		//# Kyle's random standing idle
	ENUM2STRING(BOTH_STAND5SHIFTWEIGHT),	//# Weightshift from stand5 to side and back to stand5
	ENUM2STRING(BOTH_STAND5SHIFTWEIGHTSTART),	//# From stand5 to side
	ENUM2STRING(BOTH_STAND5SHIFTWEIGHTSTOP),		//# From side to stand5
	ENUM2STRING(BOTH_STAND5TURNLEFTSTART),		//# Start turning left from stand5
	ENUM2STRING(BOTH_STAND5TURNLEFTSTOP),		//# Stop turning left from stand5
	ENUM2STRING(BOTH_STAND5TURNRIGHTSTART),		//# Start turning right from stand5
	ENUM2STRING(BOTH_STAND5TURNRIGHTSTOP),		//# Stop turning right from stand5
	ENUM2STRING(BOTH_STAND5LOOK180LEFTSTART),	//# Start looking over left shoulder (cin #17)
	ENUM2STRING(BOTH_STAND5LOOK180LEFTSTOP),	//# Stop looking over left shoulder (cin #17)

	ENUM2STRING(BOTH_CONSOLE1START),	//# typing at a console
	ENUM2STRING(BOTH_CONSOLE1),			//# typing at a console
	ENUM2STRING(BOTH_CONSOLE1STOP),		//# typing at a console
	ENUM2STRING(BOTH_CONSOLE2START),	//# typing at a console with comm link in hand (cin #5) 
	ENUM2STRING(BOTH_CONSOLE2),			//# typing at a console with comm link in hand (cin #5) 
	ENUM2STRING(BOTH_CONSOLE2STOP),		//# typing at a console with comm link in hand (cin #5) 
	ENUM2STRING(BOTH_CONSOLE2HOLDCOMSTART),	//# lean in to type at console while holding comm link in hand (cin #5) 
	ENUM2STRING(BOTH_CONSOLE2HOLDCOMSTOP),	//# lean away after typing at console while holding comm link in hand (cin #5) 

	ENUM2STRING(BOTH_GUARD_LOOKAROUND1),	//# Cradling weapon and looking around
	ENUM2STRING(BOTH_GUARD_IDLE1),		//# Cradling weapon and standing
	ENUM2STRING(BOTH_GESTURE1),			//# Generic gesture), non-specific
	ENUM2STRING(BOTH_GESTURE2),			//# Generic gesture), non-specific
	ENUM2STRING(BOTH_WALK1TALKCOMM1),	//# Talking into coom link while walking
	ENUM2STRING(BOTH_TALK1),			//# Generic talk anim
	ENUM2STRING(BOTH_TALK2),			//# Generic talk anim
	ENUM2STRING(BOTH_TALKCOMM1START),	//# Start talking into a comm link
	ENUM2STRING(BOTH_TALKCOMM1),		//# Talking into a comm link
	ENUM2STRING(BOTH_TALKCOMM1STOP),	//# Stop talking into a comm link
	ENUM2STRING(BOTH_TALKGESTURE1),		//# Generic talk anim

	ENUM2STRING(BOTH_HEADTILTLSTART),		//# Head tilt to left
	ENUM2STRING(BOTH_HEADTILTLSTOP),		//# Head tilt to left
	ENUM2STRING(BOTH_HEADTILTRSTART),		//# Head tilt to right
	ENUM2STRING(BOTH_HEADTILTRSTOP),		//# Head tilt to right
	ENUM2STRING(BOTH_HEADNOD),				//# Head shake YES
	ENUM2STRING(BOTH_HEADSHAKE),			//# Head shake NO
	ENUM2STRING(BOTH_SIT2HEADTILTLSTART),	//# Head tilt to left from seated position 2
	ENUM2STRING(BOTH_SIT2HEADTILTLSTOP),	//# Head tilt to left from seated position 2

	ENUM2STRING(BOTH_REACH1START),		//# Monmothma reaching for crystal
	ENUM2STRING(BOTH_REACH1STOP),		//# Monmothma reaching for crystal

	ENUM2STRING(BOTH_COME_ON1),				//# Jan gesturing to Kyle (cin #32a)
	ENUM2STRING(BOTH_STEADYSELF1),			//# Jan trying to keep footing (cin #32a) Kyle (cin#5)
	ENUM2STRING(BOTH_STEADYSELF1END),		//# Return hands to side from STEADSELF1 Kyle (cin#5)
	ENUM2STRING(BOTH_SILENCEGESTURE1),		//# Luke silencing Kyle with a raised hand (cin #37)
	ENUM2STRING(BOTH_REACHFORSABER1),		//# Luke holding hand out for Kyle's saber (cin #37)
	ENUM2STRING(BOTH_SABERKILLER1),			//# Tavion about to strike Jan with saber (cin #9)
	ENUM2STRING(BOTH_SABERKILLEE1),			//# Jan about to be struck by Tavion with saber (cin #9)
	ENUM2STRING(BOTH_HUGGER1),				//# Kyle hugging Jan (cin #29)
	ENUM2STRING(BOTH_HUGGERSTOP1),			//# Kyle stop hugging Jan but don't let her go (cin #29)
	ENUM2STRING(BOTH_HUGGEE1),				//# Jan being hugged (cin #29)
	ENUM2STRING(BOTH_HUGGEESTOP1),			//# Jan stop being hugged but don't let go (cin #29)

	ENUM2STRING(BOTH_SABERTHROW1START),		//# Desann throwing his light saber (cin #26)
	ENUM2STRING(BOTH_SABERTHROW1STOP),		//# Desann throwing his light saber (cin #26)
	ENUM2STRING(BOTH_SABERTHROW2START),		//# Kyle throwing his light saber (cin #32)
	ENUM2STRING(BOTH_SABERTHROW2STOP),		//# Kyle throwing his light saber (cin #32)

	//# #sep ENUM2STRING(BOTH_ SITTING/CROUCHING
	ENUM2STRING(BOTH_SIT1),				//# Normal chair sit.
	ENUM2STRING(BOTH_SIT2),				//# Lotus position.
	ENUM2STRING(BOTH_SIT3),				//# Sitting in tired position), elbows on knees

	ENUM2STRING(BOTH_SIT2TOSTAND5),		//# Transition from sit 2 to stand 5
	ENUM2STRING(BOTH_STAND5TOSIT2),		//# Transition from stand 5 to sit 2
	ENUM2STRING(BOTH_SIT2TOSIT4),		//# Trans from sit2 to sit4 (cin #12) Luke leaning back from lotus position.
	ENUM2STRING(BOTH_SIT3TOSTAND5),		//# transition from sit 3 to stand 5

	ENUM2STRING(BOTH_CROUCH1),			//# Transition from standing to crouch
	ENUM2STRING(BOTH_CROUCH1IDLE),		//# Crouching idle
	ENUM2STRING(BOTH_CROUCH1WALK),		//# Walking while crouched
	ENUM2STRING(BOTH_CROUCH1WALKBACK),	//# Walking while crouched
	ENUM2STRING(BOTH_UNCROUCH1),			//# Transition from crouch to standing
	ENUM2STRING(BOTH_CROUCH2TOSTAND1),	//# going from crouch2 to stand1
	ENUM2STRING(BOTH_CROUCH3),			//# Desann crouching down to Kyle (cin 9)
	ENUM2STRING(BOTH_UNCROUCH3),			//# Desann uncrouching down to Kyle (cin 9)
	ENUM2STRING(BOTH_CROUCH4),			//# Slower version of crouch1 for cinematics
	ENUM2STRING(BOTH_UNCROUCH4),		//# Slower version of uncrouch1 for cinematics

	ENUM2STRING(BOTH_GUNSIT1),			//# sitting on an emplaced gun.

	// Swoop Vehicle animations.
	//* #sep BOTH_ SWOOP ANIMS
	ENUM2STRING(BOTH_VS_MOUNT_L),			//# Mount from left		
	ENUM2STRING(BOTH_VS_DISMOUNT_L),		//# Dismount to left		
	ENUM2STRING(BOTH_VS_MOUNT_R),			//# Mount from  right (symmetry)		
	ENUM2STRING(BOTH_VS_DISMOUNT_R),		//# Dismount to  right (symmetry)		

	ENUM2STRING(BOTH_VS_MOUNTJUMP_L),		//#
	ENUM2STRING(BOTH_VS_MOUNTTHROW),		//# Land on an occupied vehicle & throw off current pilot
	ENUM2STRING(BOTH_VS_MOUNTTHROW_L),		//# Land on an occupied vehicle & throw off current pilot
	ENUM2STRING(BOTH_VS_MOUNTTHROW_R),		//# Land on an occupied vehicle & throw off current pilot
	ENUM2STRING(BOTH_VS_MOUNTTHROWEE),		//# Current pilot getting thrown off by another guy
				
	ENUM2STRING(BOTH_VS_LOOKLEFT),			//# Turn & Look behind and to the left (no weapon)		
	ENUM2STRING(BOTH_VS_LOOKRIGHT),			//# Turn & Look behind and to the right (no weapon)		

	ENUM2STRING(BOTH_VS_TURBO),				//# Hit The Turbo Button

	ENUM2STRING(BOTH_VS_REV),				//# Player looks back as swoop reverses		

	ENUM2STRING(BOTH_VS_AIR),				//# Player stands up when swoop is airborn		
	ENUM2STRING(BOTH_VS_AIR_G),				//# "" with Gun
	ENUM2STRING(BOTH_VS_AIR_SL),			//# "" with Saber Left
	ENUM2STRING(BOTH_VS_AIR_SR),			//# "" with Saber Right

	ENUM2STRING(BOTH_VS_LAND),				//# Player bounces down when swoop lands		
	ENUM2STRING(BOTH_VS_LAND_G),			//#  "" with Gun
	ENUM2STRING(BOTH_VS_LAND_SL),			//#  "" with Saber Left
	ENUM2STRING(BOTH_VS_LAND_SR),			//#  "" with Saber Right

	ENUM2STRING(BOTH_VS_IDLE),				//# Sit
	ENUM2STRING(BOTH_VS_IDLE_G),			//# Sit (gun)
	ENUM2STRING(BOTH_VS_IDLE_SL),			//# Sit (saber left)		
	ENUM2STRING(BOTH_VS_IDLE_SR),			//# Sit (saber right)		

	ENUM2STRING(BOTH_VS_LEANL),				//# Lean left
	ENUM2STRING(BOTH_VS_LEANL_G),			//# Lean left (gun)		
	ENUM2STRING(BOTH_VS_LEANL_SL),			//# Lean left (saber left)		
	ENUM2STRING(BOTH_VS_LEANL_SR),			//# Lean left (saber right)		

	ENUM2STRING(BOTH_VS_LEANR),				//# Lean right		
	ENUM2STRING(BOTH_VS_LEANR_G),			//# Lean right (gun)		
	ENUM2STRING(BOTH_VS_LEANR_SL),			//# Lean right (saber left)		
	ENUM2STRING(BOTH_VS_LEANR_SR),			//# Lean right (saber right)		
				
	ENUM2STRING(BOTH_VS_ATL_S),				//# Attack left with saber		
	ENUM2STRING(BOTH_VS_ATR_S),				//# Attack right with saber		
	ENUM2STRING(BOTH_VS_ATR_TO_L_S),		//# Attack toss saber from right to left hand
	ENUM2STRING(BOTH_VS_ATL_TO_R_S),		//# Attack toss saber from left to right hand
	ENUM2STRING(BOTH_VS_ATR_G),				//# Attack right with gun (90)		
	ENUM2STRING(BOTH_VS_ATL_G),				//# Attack left with gun (90)		
	ENUM2STRING(BOTH_VS_ATF_G),				//# Attack forward with gun		

	ENUM2STRING(BOTH_VS_PAIN1),				//# Pain		

	// Added 12/04/02 by Aurelio.
	//* #sep BOTH_ TAUNTAUN ANIMS
	ENUM2STRING(BOTH_VT_MOUNT_L),			//# Mount from left	
	ENUM2STRING(BOTH_VT_MOUNT_R),			//# Mount from right	
	ENUM2STRING(BOTH_VT_MOUNT_B),			//# Mount from air, behind
	ENUM2STRING(BOTH_VT_DISMOUNT),			//# Dismount for tauntaun
	ENUM2STRING(BOTH_VT_DISMOUNT_L),		//# Dismount to tauntauns left	
	ENUM2STRING(BOTH_VT_DISMOUNT_R),		//# Dismount to tauntauns right (symmetry)	

	ENUM2STRING(BOTH_VT_WALK_FWD),			//# Walk forward	
	ENUM2STRING(BOTH_VT_WALK_REV),			//# Walk backward	
	ENUM2STRING(BOTH_VT_WALK_FWD_L),		//# walk lean left
	ENUM2STRING(BOTH_VT_WALK_FWD_R),		//# walk lean right
	ENUM2STRING(BOTH_VT_RUN_FWD),			//# Run forward	
	ENUM2STRING(BOTH_VT_RUN_REV),			//# Look backwards while running (not weapon specific)	
	ENUM2STRING(BOTH_VT_RUN_FWD_L),			//# run lean left
	ENUM2STRING(BOTH_VT_RUN_FWD_R),			//# run lean right

	ENUM2STRING(BOTH_VT_SLIDEF),			//# Tauntaun slides forward with abrupt stop	
	ENUM2STRING(BOTH_VT_AIR),				//# Tauntaun jump	
	ENUM2STRING(BOTH_VT_ATB),				//# Tauntaun tail swipe	
	ENUM2STRING(BOTH_VT_PAIN1),				//# Pain	
	ENUM2STRING(BOTH_VT_DEATH1),			//# Die	
	ENUM2STRING(BOTH_VT_STAND),				//# Stand still and breath	
	ENUM2STRING(BOTH_VT_BUCK),				//# Tauntaun bucking loop animation	

	ENUM2STRING(BOTH_VT_LAND),				//# Player bounces down when tauntaun lands	
	ENUM2STRING(BOTH_VT_TURBO),				//# Hit The Turbo Button
	ENUM2STRING(BOTH_VT_IDLE_SL),			//# Sit (saber left)		
	ENUM2STRING(BOTH_VT_IDLE_SR),			//# Sit (saber right)		
	ENUM2STRING(BOTH_VT_IDLE),				//# Sit with no weapon selected	
	ENUM2STRING(BOTH_VT_IDLE1),				//# Sit with no weapon selected	
	ENUM2STRING(BOTH_VT_IDLE_S),			//# Sit with saber selected	
	ENUM2STRING(BOTH_VT_IDLE_G),			//# Sit with gun selected	
	ENUM2STRING(BOTH_VT_IDLE_T),			//# Sit with thermal grenade selected

	ENUM2STRING(BOTH_VT_ATL_S),				//# Attack left with saber	
	ENUM2STRING(BOTH_VT_ATR_S),				//# Attack right with saber	
	ENUM2STRING(BOTH_VT_ATR_TO_L_S),		//# Attack toss saber from right to left hand
	ENUM2STRING(BOTH_VT_ATL_TO_R_S),		//# Attack toss saber from left to right hand
	ENUM2STRING(BOTH_VT_ATR_G),				//# Attack right with gun (90)	
	ENUM2STRING(BOTH_VT_ATL_G),				//# Attack left with gun (90)	
	ENUM2STRING(BOTH_VT_ATF_G),				//# Attack forward with gun	


	// Added 2/26/02 by Aurelio.
	//* #sep BOTH_ FIGHTER ANIMS
	ENUM2STRING( BOTH_GEARS_OPEN ),
	ENUM2STRING( BOTH_GEARS_CLOSE ),
	ENUM2STRING( BOTH_WINGS_OPEN ),
	ENUM2STRING( BOTH_WINGS_CLOSE ),

	///////////////////////////////////

	ENUM2STRING(BOTH_DEATH14_UNGRIP),	//# Desann's end death (cin #35)
	ENUM2STRING(BOTH_DEATH14_SITUP),	//# Tavion sitting up after having been thrown (cin #23)
	ENUM2STRING(BOTH_KNEES1),			//# Tavion on her knees
	ENUM2STRING(BOTH_KNEES2),			//# Tavion on her knees looking down
	ENUM2STRING(BOTH_KNEES2TO1),		//# Transition of KNEES2 to KNEES1

	//# #sep ENUM2STRING(BOTH_ MOVING
	ENUM2STRING(BOTH_WALK1),				//# Normal walk
	ENUM2STRING(BOTH_WALK2),				//# Normal walk
	ENUM2STRING(BOTH_WALK_STAFF),		//# Walk with saberstaff turned on
	ENUM2STRING(BOTH_WALKBACK_STAFF),	//# Walk backwards with saberstaff turned on
	ENUM2STRING(BOTH_WALK_DUAL),			//# Walk with dual turned on
	ENUM2STRING(BOTH_WALKBACK_DUAL),		//# Walk backwards with dual turned on
	ENUM2STRING(BOTH_WALK5),				//# Tavion taunting Kyle (cin 22)
	ENUM2STRING(BOTH_WALK6),				//# Slow walk for Luke (cin 12)
	ENUM2STRING(BOTH_WALK7),				//# Fast walk
	ENUM2STRING(BOTH_RUN1),				//# Full run
	ENUM2STRING(BOTH_RUN1START),			//# Start into full run1
	ENUM2STRING(BOTH_RUN1STOP),			//# Stop from full run1
	ENUM2STRING(BOTH_RUN2),				//# Full run
	ENUM2STRING(BOTH_RUN1TORUN2),		//# Wampa run anim transition
	ENUM2STRING(BOTH_RUN2TORUN1),		//# Wampa run anim transition
	ENUM2STRING(BOTH_RUN4),				//# Jawa run
	ENUM2STRING(BOTH_RUN_STAFF),			//# Run with saberstaff turned on
	ENUM2STRING(BOTH_RUNBACK_STAFF),		//# Run backwards with saberstaff turned on
	ENUM2STRING(BOTH_RUN_DUAL),			//# Run with dual turned on
	ENUM2STRING(BOTH_RUNBACK_DUAL),		//# Run backwards with dual turned on
	ENUM2STRING(BOTH_STRAFE_LEFT1),		//# Sidestep left), should loop
	ENUM2STRING(BOTH_STRAFE_RIGHT1),		//# Sidestep right), should loop
	ENUM2STRING(BOTH_RUNSTRAFE_LEFT1),	//# Sidestep left), should loop
	ENUM2STRING(BOTH_RUNSTRAFE_RIGHT1),	//# Sidestep right), should loop
	ENUM2STRING(BOTH_TURN_LEFT1),		//# Turn left), should loop
	ENUM2STRING(BOTH_TURN_RIGHT1),		//# Turn right), should loop
	ENUM2STRING(BOTH_TURNSTAND1),		//# Turn from STAND1 position
	ENUM2STRING(BOTH_TURNSTAND2),		//# Turn from STAND2 position
	ENUM2STRING(BOTH_TURNSTAND3),		//# Turn from STAND3 position
	ENUM2STRING(BOTH_TURNSTAND4),		//# Turn from STAND4 position
	ENUM2STRING(BOTH_TURNSTAND5),		//# Turn from STAND5 position
	ENUM2STRING(BOTH_TURNCROUCH1),		//# Turn from CROUCH1 position

	ENUM2STRING(BOTH_WALKBACK1),			//# Walk1 backwards
	ENUM2STRING(BOTH_WALKBACK2),			//# Walk2 backwards
	ENUM2STRING(BOTH_RUNBACK1),			//# Run1 backwards
	ENUM2STRING(BOTH_RUNBACK2),			//# Run1 backwards
	
	//# #sep BOTH_ JUMPING
	ENUM2STRING(BOTH_JUMP1),				//# Jump - wind-up and leave ground
	ENUM2STRING(BOTH_INAIR1),			//# In air loop (from jump)
	ENUM2STRING(BOTH_LAND1),				//# Landing (from in air loop)
	ENUM2STRING(BOTH_LAND2),				//# Landing Hard (from a great height)

	ENUM2STRING(BOTH_JUMPBACK1),			//# Jump backwards - wind-up and leave ground
	ENUM2STRING(BOTH_INAIRBACK1),		//# In air loop (from jump back)
	ENUM2STRING(BOTH_LANDBACK1),			//# Landing backwards(from in air loop)

	ENUM2STRING(BOTH_JUMPLEFT1),			//# Jump left - wind-up and leave ground
	ENUM2STRING(BOTH_INAIRLEFT1),		//# In air loop (from jump left)
	ENUM2STRING(BOTH_LANDLEFT1),			//# Landing left(from in air loop)

	ENUM2STRING(BOTH_JUMPRIGHT1),		//# Jump right - wind-up and leave ground
	ENUM2STRING(BOTH_INAIRRIGHT1),		//# In air loop (from jump right)
	ENUM2STRING(BOTH_LANDRIGHT1),		//# Landing right(from in air loop)

	ENUM2STRING(BOTH_FORCEJUMP1),				//# Jump - wind-up and leave ground
	ENUM2STRING(BOTH_FORCEINAIR1),			//# In air loop (from jump)
	ENUM2STRING(BOTH_FORCELAND1),				//# Landing (from in air loop)

	ENUM2STRING(BOTH_FORCEJUMPBACK1),			//# Jump backwards - wind-up and leave ground
	ENUM2STRING(BOTH_FORCEINAIRBACK1),		//# In air loop (from jump back)
	ENUM2STRING(BOTH_FORCELANDBACK1),			//# Landing backwards(from in air loop)

	ENUM2STRING(BOTH_FORCEJUMPLEFT1),			//# Jump left - wind-up and leave ground
	ENUM2STRING(BOTH_FORCEINAIRLEFT1),		//# In air loop (from jump left)
	ENUM2STRING(BOTH_FORCELANDLEFT1),			//# Landing left(from in air loop)

	ENUM2STRING(BOTH_FORCEJUMPRIGHT1),		//# Jump right - wind-up and leave ground
	ENUM2STRING(BOTH_FORCEINAIRRIGHT1),		//# In air loop (from jump right)
	ENUM2STRING(BOTH_FORCELANDRIGHT1),		//# Landing right(from in air loop)
	//# #sep BOTH_ ACROBATICS
	ENUM2STRING(BOTH_FLIP_F),			//# Flip forward
	ENUM2STRING(BOTH_FLIP_B),			//# Flip backwards
	ENUM2STRING(BOTH_FLIP_L),			//# Flip left
	ENUM2STRING(BOTH_FLIP_R),			//# Flip right

	ENUM2STRING(BOTH_ROLL_F),			//# Roll forward
	ENUM2STRING(BOTH_ROLL_B),			//# Roll backward
	ENUM2STRING(BOTH_ROLL_L),			//# Roll left
	ENUM2STRING(BOTH_ROLL_R),			//# Roll right

	ENUM2STRING(BOTH_HOP_F),				//# quickstep forward
	ENUM2STRING(BOTH_HOP_B),				//# quickstep backwards
	ENUM2STRING(BOTH_HOP_L),				//# quickstep left
	ENUM2STRING(BOTH_HOP_R),				//# quickstep right

	ENUM2STRING(BOTH_DODGE_FL),			//# lean-dodge forward left
	ENUM2STRING(BOTH_DODGE_FR),			//# lean-dodge forward right
	ENUM2STRING(BOTH_DODGE_BL),			//# lean-dodge backwards left
	ENUM2STRING(BOTH_DODGE_BR),			//# lean-dodge backwards right
	ENUM2STRING(BOTH_DODGE_L),			//# lean-dodge left
	ENUM2STRING(BOTH_DODGE_R),			//# lean-dodge right
	ENUM2STRING(BOTH_DODGE_HOLD_FL),			//# lean-dodge pose forward left
	ENUM2STRING(BOTH_DODGE_HOLD_FR),			//# lean-dodge pose forward right
	ENUM2STRING(BOTH_DODGE_HOLD_BL),			//# lean-dodge pose backwards left
	ENUM2STRING(BOTH_DODGE_HOLD_BR),			//# lean-dodge pose backwards right
	ENUM2STRING(BOTH_DODGE_HOLD_L),			//# lean-dodge pose left
	ENUM2STRING(BOTH_DODGE_HOLD_R),			//# lean-dodge pose right

	//MP taunt anims
	ENUM2STRING(BOTH_ENGAGETAUNT),
	ENUM2STRING(BOTH_BOW),
	ENUM2STRING(BOTH_MEDITATE),
	ENUM2STRING(BOTH_MEDITATE_END),
	ENUM2STRING(BOTH_SHOWOFF_FAST),
	ENUM2STRING(BOTH_SHOWOFF_MEDIUM),
	ENUM2STRING(BOTH_SHOWOFF_STRONG),
	ENUM2STRING(BOTH_SHOWOFF_DUAL),
	ENUM2STRING(BOTH_SHOWOFF_STAFF),
	ENUM2STRING(BOTH_VICTORY_FAST),
	ENUM2STRING(BOTH_VICTORY_MEDIUM),
	ENUM2STRING(BOTH_VICTORY_STRONG),
	ENUM2STRING(BOTH_VICTORY_DUAL),
	ENUM2STRING(BOTH_VICTORY_STAFF),
	//other saber/acro anims
	ENUM2STRING(BOTH_ARIAL_LEFT),		//# 
	ENUM2STRING(BOTH_ARIAL_RIGHT),		//# 
	ENUM2STRING(BOTH_CARTWHEEL_LEFT),	//# 
	ENUM2STRING(BOTH_CARTWHEEL_RIGHT),	//# 
	ENUM2STRING(BOTH_FLIP_LEFT),			//# 
	ENUM2STRING(BOTH_FLIP_BACK1),		//# 
	ENUM2STRING(BOTH_FLIP_BACK2),		//# 
	ENUM2STRING(BOTH_FLIP_BACK3),		//# 
	ENUM2STRING(BOTH_BUTTERFLY_LEFT),	//# 
	ENUM2STRING(BOTH_BUTTERFLY_RIGHT),	//# 
	ENUM2STRING(BOTH_WALL_RUN_RIGHT),	//# 
	ENUM2STRING(BOTH_WALL_RUN_RIGHT_FLIP),//#
	ENUM2STRING(BOTH_WALL_RUN_RIGHT_STOP),//# 
	ENUM2STRING(BOTH_WALL_RUN_LEFT),		//# 
	ENUM2STRING(BOTH_WALL_RUN_LEFT_FLIP),//#
	ENUM2STRING(BOTH_WALL_RUN_LEFT_STOP),//# 
	ENUM2STRING(BOTH_WALL_FLIP_RIGHT),	//# 
	ENUM2STRING(BOTH_WALL_FLIP_LEFT),	//# 
	ENUM2STRING(BOTH_KNOCKDOWN1),		//# knocked backwards
	ENUM2STRING(BOTH_KNOCKDOWN2),		//# knocked backwards hard
	ENUM2STRING(BOTH_KNOCKDOWN3),		//#	knocked forwards
	ENUM2STRING(BOTH_KNOCKDOWN4),		//# knocked backwards from crouch
	ENUM2STRING(BOTH_KNOCKDOWN5),		//# dupe of 3 - will be removed
	ENUM2STRING(BOTH_GETUP1),			//#
	ENUM2STRING(BOTH_GETUP2),			//#
	ENUM2STRING(BOTH_GETUP3),			//#
	ENUM2STRING(BOTH_GETUP4),			//#
	ENUM2STRING(BOTH_GETUP5),			//#
	ENUM2STRING(BOTH_GETUP_CROUCH_F1),	//#
	ENUM2STRING(BOTH_GETUP_CROUCH_B1),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_F1),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_F2),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_B1),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_B2),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_B3),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_B4),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_B5),	//#
	ENUM2STRING(BOTH_FORCE_GETUP_B6),	//#
	ENUM2STRING(BOTH_GETUP_BROLL_B),	//#
	ENUM2STRING(BOTH_GETUP_BROLL_F),	//#
	ENUM2STRING(BOTH_GETUP_BROLL_L),	//#
	ENUM2STRING(BOTH_GETUP_BROLL_R),	//#
	ENUM2STRING(BOTH_GETUP_FROLL_B),	//#
	ENUM2STRING(BOTH_GETUP_FROLL_F),	//#
	ENUM2STRING(BOTH_GETUP_FROLL_L),	//#
	ENUM2STRING(BOTH_GETUP_FROLL_R),	//#
	ENUM2STRING(BOTH_WALL_FLIP_BACK1),	//#
	ENUM2STRING(BOTH_WALL_FLIP_BACK2),	//#
	ENUM2STRING(BOTH_SPIN1),				//#
	ENUM2STRING(BOTH_CEILING_CLING),		//# clinging to ceiling
	ENUM2STRING(BOTH_CEILING_DROP),		//# dropping from ceiling cling

	//TESTING
	ENUM2STRING(BOTH_FJSS_TR_BL),		//# jump spin slash tr to bl
	ENUM2STRING(BOTH_FJSS_TL_BR),		//# jump spin slash bl to tr
	ENUM2STRING(BOTH_RIGHTHANDCHOPPEDOFF),//#
	ENUM2STRING(BOTH_DEFLECTSLASH__R__L_FIN),//#
	ENUM2STRING(BOTH_BASHED1),//#
	ENUM2STRING(BOTH_ARIAL_F1),//#
	ENUM2STRING(BOTH_BUTTERFLY_FR1),//#
	ENUM2STRING(BOTH_BUTTERFLY_FL1),//#

	//NEW SABER/JEDI/FORCE ANIMS
	ENUM2STRING(BOTH_BACK_FLIP_UP),	//# back flip up Bonus Animation!!!!	
	ENUM2STRING(BOTH_LOSE_SABER),	//# player losing saber (pulled from hand by force pull 4 - Kyle?)
	ENUM2STRING(BOTH_STAFF_TAUNT),	//# taunt saberstaff			
	ENUM2STRING(BOTH_DUAL_TAUNT),		//# taunt dual
	ENUM2STRING(BOTH_A6_FB),				//# dual attack front/back		
	ENUM2STRING(BOTH_A6_LR),				//# dual attack left/right
	ENUM2STRING(BOTH_A7_HILT),			//# saber knock (alt + stand still)
	//Alora			
	ENUM2STRING(BOTH_ALORA_SPIN),		//#jump spin attack	death ballet	
	ENUM2STRING(BOTH_ALORA_FLIP_1),		//# gymnast move 1		
	ENUM2STRING(BOTH_ALORA_FLIP_2),		//# gymnast move 2		
	ENUM2STRING(BOTH_ALORA_FLIP_3),		//# gymnast move3		
	ENUM2STRING(BOTH_ALORA_FLIP_B),		//# gymnast move back		
	ENUM2STRING(BOTH_ALORA_SPIN_THROW),	//# dual saber throw		
	ENUM2STRING(BOTH_ALORA_SPIN_SLASH),	//# spin slash	special bonus animation!! :)	
	ENUM2STRING(BOTH_ALORA_TAUNT),		//# special taunt
	//Rosh (Kothos battle)			
	ENUM2STRING(BOTH_ROSH_PAIN),	//# hurt animation (exhausted)		
	ENUM2STRING(BOTH_ROSH_HEAL),	//# healed/rejuvenated		
	//Tavion			
	ENUM2STRING(BOTH_TAVION_SCEPTERGROUND), //# stabbing ground with sith sword shoots electricity everywhere
	ENUM2STRING(BOTH_TAVION_SWORDPOWER),//# Tavion doing the He-Man(tm) thing
	ENUM2STRING(BOTH_SCEPTER_START),	//#Point scepter and attack start
	ENUM2STRING(BOTH_SCEPTER_HOLD),	//#Point scepter and attack hold
	ENUM2STRING(BOTH_SCEPTER_STOP),	//#Point scepter and attack stop
	//Kyle Boss			
	ENUM2STRING(BOTH_KYLE_GRAB),		//# grab
	ENUM2STRING(BOTH_KYLE_MISS),		//# miss
	ENUM2STRING(BOTH_KYLE_PA_1),		//# hold 1
	ENUM2STRING(BOTH_PLAYER_PA_1),	//# player getting held 1
	ENUM2STRING(BOTH_KYLE_PA_2),		//# hold 2
	ENUM2STRING(BOTH_PLAYER_PA_2),	//# player getting held 2
	ENUM2STRING(BOTH_PLAYER_PA_FLY),	//# player getting knocked back from punch at end of hold 1
	ENUM2STRING(BOTH_KYLE_PA_3),		//# hold 3
	ENUM2STRING(BOTH_PLAYER_PA_3),	//# player getting held 3
	ENUM2STRING(BOTH_PLAYER_PA_3_FLY),//# player getting thrown at end of hold 3
	//Rancor
	ENUM2STRING(BOTH_BUCK_RIDER),	//# Rancor bucks when someone is on him
	//WAMPA Grabbing enemy
	ENUM2STRING(BOTH_HOLD_START),	//#
	ENUM2STRING(BOTH_HOLD_MISS),	//#
	ENUM2STRING(BOTH_HOLD_IDLE),	//#
	ENUM2STRING(BOTH_HOLD_END),	//#
	ENUM2STRING(BOTH_HOLD_ATTACK),	//#
	ENUM2STRING(BOTH_HOLD_SNIFF),	//# Sniff the guy you're holding
	ENUM2STRING(BOTH_HOLD_DROP),		//# just drop 'em
	//BEING GRABBED BY WAMPA
	ENUM2STRING(BOTH_GRABBED),	//#
	ENUM2STRING(BOTH_RELEASED),	//#
	ENUM2STRING(BOTH_HANG_IDLE),	//#
	ENUM2STRING(BOTH_HANG_ATTACK),	//#
	ENUM2STRING(BOTH_HANG_PAIN),	//#

	//# #sep BOTH_ MISC MOVEMENT
	ENUM2STRING(BOTH_HIT1),				//# Kyle hit by crate in cin #9
	ENUM2STRING(BOTH_LADDER_UP1),		//# Climbing up a ladder with rungs at 16 unit intervals
	ENUM2STRING(BOTH_LADDER_DWN1),		//# Climbing down a ladder with rungs at 16 unit intervals
	ENUM2STRING(BOTH_LADDER_IDLE),		//#	Just sitting on the ladder

	//# #sep ENUM2STRING(BOTH_ FLYING IDLE
	ENUM2STRING(BOTH_FLY_SHIELDED),		//# For sentry droid, shields in

	//# #sep BOTH_ SWIMMING
	ENUM2STRING(BOTH_SWIM_IDLE1),		//# Swimming Idle 1
	ENUM2STRING(BOTH_SWIMFORWARD),		//# Swim forward loop
	ENUM2STRING(BOTH_SWIMBACKWARD),		//# Swim backward loop
	
	//# #sep ENUM2STRING(BOTH_ LYING
	ENUM2STRING(BOTH_SLEEP1),			//# laying on back-rknee up-rhand on torso
	ENUM2STRING(BOTH_SLEEP6START),		//# Kyle leaning back to sleep (cin 20)
	ENUM2STRING(BOTH_SLEEP6STOP),		//# Kyle waking up and shaking his head (cin 21)
	ENUM2STRING(BOTH_SLEEP1GETUP),		//# alarmed and getting up out of sleep1 pose to stand
	ENUM2STRING(BOTH_SLEEP1GETUP2),		//# 

	ENUM2STRING(BOTH_CHOKE1START),		//# tavion in force grip choke
	ENUM2STRING(BOTH_CHOKE1STARTHOLD),		//# loop of tavion in force grip choke
	ENUM2STRING(BOTH_CHOKE1),			//# tavion in force grip choke

	ENUM2STRING(BOTH_CHOKE2),			//# tavion recovering from force grip choke
	ENUM2STRING(BOTH_CHOKE3),			//# left-handed choke (for people still holding a weapon)

	//# #sep ENUM2STRING(BOTH_ HUNTER-SEEKER BOT-SPECIFIC
	ENUM2STRING(BOTH_POWERUP1),			//# Wakes up

	ENUM2STRING(BOTH_TURNON),			//# Protocol Droid wakes up
	ENUM2STRING(BOTH_TURNOFF),			//# Protocol Droid shuts off
	ENUM2STRING(BOTH_BUTTON1),			//# Single button push with right hand
	ENUM2STRING(BOTH_BUTTON2),			//# Single button push with left finger
	ENUM2STRING(BOTH_BUTTON_HOLD),		//# Single button hold with left hand
	ENUM2STRING(BOTH_BUTTON_RELEASE),	//# Single button release with left hand

	//# JEDI-SPECIFIC
	//# #sep BOTH_ FORCE ANIMS
	ENUM2STRING(BOTH_RESISTPUSH),			//# plant yourself to resist force push/pulls.
	ENUM2STRING(BOTH_FORCEPUSH),			//# Use off-hand to do force power.
	ENUM2STRING(BOTH_FORCEPULL),			//# Use off-hand to do force power.
	ENUM2STRING(BOTH_MINDTRICK1),			//# Use off-hand to do mind trick
	ENUM2STRING(BOTH_MINDTRICK2),			//# Use off-hand to do distraction
	ENUM2STRING(BOTH_FORCELIGHTNING),		//# Use off-hand to do lightning
	ENUM2STRING(BOTH_FORCELIGHTNING_START),	//# Use off-hand to do lightning - start
	ENUM2STRING(BOTH_FORCELIGHTNING_HOLD),	//# Use off-hand to do lightning - hold
	ENUM2STRING(BOTH_FORCELIGHTNING_RELEASE),//# Use off-hand to do lightning - release
	ENUM2STRING(BOTH_FORCEHEAL_START),		//# Healing meditation pose start
	ENUM2STRING(BOTH_FORCEHEAL_STOP),		//# Healing meditation pose end
	ENUM2STRING(BOTH_FORCEHEAL_QUICK),		//# Healing meditation gesture
	ENUM2STRING(BOTH_SABERPULL),			//# Use off-hand to do force power.
	ENUM2STRING(BOTH_FORCEGRIP1),			//# force-gripping (no anim?)
	ENUM2STRING(BOTH_FORCEGRIP3),			//# force-gripping (right-hand)
	ENUM2STRING(BOTH_FORCEGRIP3THROW),		//# throwing while force-gripping (right hand)
	ENUM2STRING(BOTH_FORCEGRIP_HOLD),	//# Use off-hand to do grip - hold
	ENUM2STRING(BOTH_FORCEGRIP_RELEASE),//# Use off-hand to do grip - release
	ENUM2STRING(BOTH_TOSS1),				//# throwing to left after force gripping
	ENUM2STRING(BOTH_TOSS2),				//# throwing to right after force gripping
	//NEW force anims for JKA:
	ENUM2STRING(BOTH_FORCE_RAGE),
	ENUM2STRING(BOTH_FORCE_2HANDEDLIGHTNING),
	ENUM2STRING(BOTH_FORCE_2HANDEDLIGHTNING_START),
	ENUM2STRING(BOTH_FORCE_2HANDEDLIGHTNING_HOLD),
	ENUM2STRING(BOTH_FORCE_2HANDEDLIGHTNING_RELEASE),
	ENUM2STRING(BOTH_FORCE_DRAIN),
	ENUM2STRING(BOTH_FORCE_DRAIN_START),
	ENUM2STRING(BOTH_FORCE_DRAIN_HOLD),
	ENUM2STRING(BOTH_FORCE_DRAIN_RELEASE),
	ENUM2STRING(BOTH_FORCE_DRAIN_GRAB_START),
	ENUM2STRING(BOTH_FORCE_DRAIN_GRAB_HOLD),
	ENUM2STRING(BOTH_FORCE_DRAIN_GRAB_END),
	ENUM2STRING(BOTH_FORCE_DRAIN_GRABBED),
	ENUM2STRING(BOTH_FORCE_ABSORB),
	ENUM2STRING(BOTH_FORCE_ABSORB_START),
	ENUM2STRING(BOTH_FORCE_ABSORB_END),
	ENUM2STRING(BOTH_FORCE_PROTECT),
	ENUM2STRING(BOTH_FORCE_PROTECT_FAST),

	ENUM2STRING(BOTH_WIND),

	ENUM2STRING(BOTH_STAND_TO_KNEEL),
	ENUM2STRING(BOTH_KNEEL_TO_STAND),

	ENUM2STRING(BOTH_TUSKENATTACK1),
	ENUM2STRING(BOTH_TUSKENATTACK2),
	ENUM2STRING(BOTH_TUSKENATTACK3),
	ENUM2STRING(BOTH_TUSKENLUNGE1),
	ENUM2STRING(BOTH_TUSKENTAUNT1),

	ENUM2STRING(BOTH_COWER1_START),		//# cower start
	ENUM2STRING(BOTH_COWER1),			//# cower loop
	ENUM2STRING(BOTH_COWER1_STOP),		//# cower stop
	ENUM2STRING(BOTH_SONICPAIN_START),
	ENUM2STRING(BOTH_SONICPAIN_HOLD),
	ENUM2STRING(BOTH_SONICPAIN_END),

	//new anim slots per Jarrod's request
	ENUM2STRING(BOTH_STAND10),
	ENUM2STRING(BOTH_STAND10_TALK1),
	ENUM2STRING(BOTH_STAND10_TALK2),
	ENUM2STRING(BOTH_STAND10TOSTAND1),

	ENUM2STRING(BOTH_STAND1_TALK1),
	ENUM2STRING(BOTH_STAND1_TALK2),
	ENUM2STRING(BOTH_STAND1_TALK3),

	ENUM2STRING(BOTH_SIT4),
	ENUM2STRING(BOTH_SIT5),
	ENUM2STRING(BOTH_SIT5_TALK1),
	ENUM2STRING(BOTH_SIT5_TALK2),
	ENUM2STRING(BOTH_SIT5_TALK3),

	ENUM2STRING(BOTH_SIT6),
	ENUM2STRING(BOTH_SIT7),
	//=================================================
	//ANIMS IN WHICH ONLY THE UPPER OBJECTS ARE IN MD3
	//=================================================
	//# #sep ENUM2STRING(TORSO_ WEAPON-RELATED
	ENUM2STRING(TORSO_DROPWEAP1),		//# Put weapon away
	ENUM2STRING(TORSO_DROPWEAP4),		//# Put weapon away
	ENUM2STRING(TORSO_RAISEWEAP1),		//# Draw Weapon
	ENUM2STRING(TORSO_RAISEWEAP4),		//# Draw Weapon
	ENUM2STRING(TORSO_WEAPONREADY1),		//# Ready to fire stun baton
	ENUM2STRING(TORSO_WEAPONREADY2),		//# Ready to fire one-handed blaster pistol
	ENUM2STRING(TORSO_WEAPONREADY3),		//# Ready to fire blaster rifle
	ENUM2STRING(TORSO_WEAPONREADY4),		//# Ready to fire sniper rifle
	ENUM2STRING(TORSO_WEAPONREADY10),	//# Ready to fire thermal det
	ENUM2STRING(TORSO_WEAPONIDLE2),		//# Holding one-handed blaster
	ENUM2STRING(TORSO_WEAPONIDLE3),		//# Holding blaster rifle
	ENUM2STRING(TORSO_WEAPONIDLE4),		//# Holding sniper rifle
	ENUM2STRING(TORSO_WEAPONIDLE10),		//# Holding thermal det

	//# #sep ENUM2STRING(TORSO_ USING NON-WEAPON OBJECTS

	//# #sep ENUM2STRING(TORSO_ MISC
	ENUM2STRING(TORSO_SURRENDER_START),	//# arms up
	ENUM2STRING(TORSO_SURRENDER_STOP),	//# arms back down
	ENUM2STRING(TORSO_CHOKING1),			//# TEMP

	ENUM2STRING(TORSO_HANDSIGNAL1),
	ENUM2STRING(TORSO_HANDSIGNAL2),
	ENUM2STRING(TORSO_HANDSIGNAL3),
	ENUM2STRING(TORSO_HANDSIGNAL4),
	ENUM2STRING(TORSO_HANDSIGNAL5),

	//=================================================
	//ANIMS IN WHICH ONLY THE LOWER OBJECTS ARE IN MD3
	//=================================================
	//# #sep Legs-only anims
	ENUM2STRING(LEGS_TURN1),				//# What legs do when you turn your lower body to match your upper body facing
	ENUM2STRING(LEGS_TURN2),				//# Leg turning from stand2
	ENUM2STRING(LEGS_LEAN_LEFT1),		//# Lean left
	ENUM2STRING(LEGS_LEAN_RIGHT1),		//# Lean Right
	ENUM2STRING(LEGS_CHOKING1),			//# TEMP
	ENUM2STRING(LEGS_LEFTUP1),			//# On a slope with left foot 4 higher than right
	ENUM2STRING(LEGS_LEFTUP2),			//# On a slope with left foot 8 higher than right
	ENUM2STRING(LEGS_LEFTUP3),			//# On a slope with left foot 12 higher than right
	ENUM2STRING(LEGS_LEFTUP4),			//# On a slope with left foot 16 higher than right
	ENUM2STRING(LEGS_LEFTUP5),			//# On a slope with left foot 20 higher than right
	ENUM2STRING(LEGS_RIGHTUP1),			//# On a slope with RIGHT foot 4 higher than left
	ENUM2STRING(LEGS_RIGHTUP2),			//# On a slope with RIGHT foot 8 higher than left
	ENUM2STRING(LEGS_RIGHTUP3),			//# On a slope with RIGHT foot 12 higher than left
	ENUM2STRING(LEGS_RIGHTUP4),			//# On a slope with RIGHT foot 16 higher than left
	ENUM2STRING(LEGS_RIGHTUP5),			//# On a slope with RIGHT foot 20 higher than left
	ENUM2STRING(LEGS_S1_LUP1),
	ENUM2STRING(LEGS_S1_LUP2),
	ENUM2STRING(LEGS_S1_LUP3),
	ENUM2STRING(LEGS_S1_LUP4),
	ENUM2STRING(LEGS_S1_LUP5),
	ENUM2STRING(LEGS_S1_RUP1),
	ENUM2STRING(LEGS_S1_RUP2),
	ENUM2STRING(LEGS_S1_RUP3),
	ENUM2STRING(LEGS_S1_RUP4),
	ENUM2STRING(LEGS_S1_RUP5),
	ENUM2STRING(LEGS_S3_LUP1),
	ENUM2STRING(LEGS_S3_LUP2),
	ENUM2STRING(LEGS_S3_LUP3),
	ENUM2STRING(LEGS_S3_LUP4),
	ENUM2STRING(LEGS_S3_LUP5),
	ENUM2STRING(LEGS_S3_RUP1),
	ENUM2STRING(LEGS_S3_RUP2),
	ENUM2STRING(LEGS_S3_RUP3),
	ENUM2STRING(LEGS_S3_RUP4),
	ENUM2STRING(LEGS_S3_RUP5),
	ENUM2STRING(LEGS_S4_LUP1),
	ENUM2STRING(LEGS_S4_LUP2),
	ENUM2STRING(LEGS_S4_LUP3),
	ENUM2STRING(LEGS_S4_LUP4),
	ENUM2STRING(LEGS_S4_LUP5),
	ENUM2STRING(LEGS_S4_RUP1),
	ENUM2STRING(LEGS_S4_RUP2),
	ENUM2STRING(LEGS_S4_RUP3),
	ENUM2STRING(LEGS_S4_RUP4),
	ENUM2STRING(LEGS_S4_RUP5),
	ENUM2STRING(LEGS_S5_LUP1),
	ENUM2STRING(LEGS_S5_LUP2),
	ENUM2STRING(LEGS_S5_LUP3),
	ENUM2STRING(LEGS_S5_LUP4),
	ENUM2STRING(LEGS_S5_LUP5),
	ENUM2STRING(LEGS_S5_RUP1),
	ENUM2STRING(LEGS_S5_RUP2),
	ENUM2STRING(LEGS_S5_RUP3),
	ENUM2STRING(LEGS_S5_RUP4),
	ENUM2STRING(LEGS_S5_RUP5),
	ENUM2STRING(LEGS_S6_LUP1),
	ENUM2STRING(LEGS_S6_LUP2),
	ENUM2STRING(LEGS_S6_LUP3),
	ENUM2STRING(LEGS_S6_LUP4),
	ENUM2STRING(LEGS_S6_LUP5),
	ENUM2STRING(LEGS_S6_RUP1),
	ENUM2STRING(LEGS_S6_RUP2),
	ENUM2STRING(LEGS_S6_RUP3),
	ENUM2STRING(LEGS_S6_RUP4),
	ENUM2STRING(LEGS_S6_RUP5),
	ENUM2STRING(LEGS_S7_LUP1),
	ENUM2STRING(LEGS_S7_LUP2),
	ENUM2STRING(LEGS_S7_LUP3),
	ENUM2STRING(LEGS_S7_LUP4),
	ENUM2STRING(LEGS_S7_LUP5),
	ENUM2STRING(LEGS_S7_RUP1),
	ENUM2STRING(LEGS_S7_RUP2),
	ENUM2STRING(LEGS_S7_RUP3),
	ENUM2STRING(LEGS_S7_RUP4),
	ENUM2STRING(LEGS_S7_RUP5),

	//New anim as per Jarrod's request
	ENUM2STRING(LEGS_TURN180),

	//======================================================
	//cinematic anims
	//======================================================
	//# #sep BOTH_ CINEMATIC-ONLY
	ENUM2STRING(BOTH_CIN_1),		//# Level specific cinematic 1
	ENUM2STRING(BOTH_CIN_2),		//# Level specific cinematic 2
	ENUM2STRING(BOTH_CIN_3),		//# Level specific cinematic 3
	ENUM2STRING(BOTH_CIN_4),		//# Level specific cinematic 4
	ENUM2STRING(BOTH_CIN_5),		//# Level specific cinematic 5
	ENUM2STRING(BOTH_CIN_6),		//# Level specific cinematic 6
	ENUM2STRING(BOTH_CIN_7),		//# Level specific cinematic 7
	ENUM2STRING(BOTH_CIN_8),		//# Level specific cinematic 8
	ENUM2STRING(BOTH_CIN_9),		//# Level specific cinematic 9
	ENUM2STRING(BOTH_CIN_10),		//# Level specific cinematic 10
	ENUM2STRING(BOTH_CIN_11),		//# Level specific cinematic 11
	ENUM2STRING(BOTH_CIN_12),		//# Level specific cinematic 12
	ENUM2STRING(BOTH_CIN_13),		//# Level specific cinematic 13
	ENUM2STRING(BOTH_CIN_14),		//# Level specific cinematic 14
	ENUM2STRING(BOTH_CIN_15),		//# Level specific cinematic 15
	ENUM2STRING(BOTH_CIN_16),		//# Level specific cinematic 16
	ENUM2STRING(BOTH_CIN_17),		//# Level specific cinematic 17
	ENUM2STRING(BOTH_CIN_18),		//# Level specific cinematic 18
	ENUM2STRING(BOTH_CIN_19),		//# Level specific cinematic 19
	ENUM2STRING(BOTH_CIN_20),		//# Level specific cinematic 20
	ENUM2STRING(BOTH_CIN_21),		//# Level specific cinematic 21
	ENUM2STRING(BOTH_CIN_22),		//# Level specific cinematic 22
	ENUM2STRING(BOTH_CIN_23),		//# Level specific cinematic 23
	ENUM2STRING(BOTH_CIN_24),		//# Level specific cinematic 24
	ENUM2STRING(BOTH_CIN_25),		//# Level specific cinematic 25

	ENUM2STRING(BOTH_CIN_26),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_27),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_28),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_29),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_30),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_31),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_32),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_33),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_34),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_35),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_36),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_37),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_38),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_39),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_40),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_41),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_42),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_43),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_44),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_45),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_46),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_47),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_48),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_49),		//# Level specific cinematic
	ENUM2STRING(BOTH_CIN_50),		//# Level specific cinematic
										
	//must be terminated
	NULL,-1
};

// Source: oracle/codemp/game/bg_saberLoad.c:46-61
stringID_table_t SaberTable[] =
{
	ENUM2STRING(SABER_NONE),
	ENUM2STRING(SABER_SINGLE),
	ENUM2STRING(SABER_STAFF),
	ENUM2STRING(SABER_BROAD),
	ENUM2STRING(SABER_PRONG),
	ENUM2STRING(SABER_DAGGER),
	ENUM2STRING(SABER_ARC),
	ENUM2STRING(SABER_SAI),
	ENUM2STRING(SABER_CLAW),
	ENUM2STRING(SABER_LANCE),
	ENUM2STRING(SABER_STAR),
	ENUM2STRING(SABER_TRIDENT),
	"",	-1
};

// Source: oracle/codemp/game/bg_saberLoad.c:63-126
stringID_table_t SaberMoveTable[] =
{
	ENUM2STRING(LS_NONE),
	// Attacks
	ENUM2STRING(LS_A_TL2BR),
	ENUM2STRING(LS_A_L2R),
	ENUM2STRING(LS_A_BL2TR),
	ENUM2STRING(LS_A_BR2TL),
	ENUM2STRING(LS_A_R2L),
	ENUM2STRING(LS_A_TR2BL),
	ENUM2STRING(LS_A_T2B),
	ENUM2STRING(LS_A_BACKSTAB),
	ENUM2STRING(LS_A_BACK),
	ENUM2STRING(LS_A_BACK_CR),
	ENUM2STRING(LS_ROLL_STAB),
	ENUM2STRING(LS_A_LUNGE),
	ENUM2STRING(LS_A_JUMP_T__B_),
	ENUM2STRING(LS_A_FLIP_STAB),
	ENUM2STRING(LS_A_FLIP_SLASH),
	ENUM2STRING(LS_JUMPATTACK_DUAL),
	ENUM2STRING(LS_JUMPATTACK_ARIAL_LEFT),
	ENUM2STRING(LS_JUMPATTACK_ARIAL_RIGHT),
	ENUM2STRING(LS_JUMPATTACK_CART_LEFT),
	ENUM2STRING(LS_JUMPATTACK_CART_RIGHT),
	ENUM2STRING(LS_JUMPATTACK_STAFF_LEFT),
	ENUM2STRING(LS_JUMPATTACK_STAFF_RIGHT),
	ENUM2STRING(LS_BUTTERFLY_LEFT),
	ENUM2STRING(LS_BUTTERFLY_RIGHT),
	ENUM2STRING(LS_A_BACKFLIP_ATK),
	ENUM2STRING(LS_SPINATTACK_DUAL),
	ENUM2STRING(LS_SPINATTACK),
	ENUM2STRING(LS_LEAP_ATTACK),
	ENUM2STRING(LS_SWOOP_ATTACK_RIGHT),
	ENUM2STRING(LS_SWOOP_ATTACK_LEFT),
	ENUM2STRING(LS_TAUNTAUN_ATTACK_RIGHT),
	ENUM2STRING(LS_TAUNTAUN_ATTACK_LEFT),
	ENUM2STRING(LS_KICK_F),
	ENUM2STRING(LS_KICK_B),
	ENUM2STRING(LS_KICK_R),
	ENUM2STRING(LS_KICK_L),
	ENUM2STRING(LS_KICK_S),
	ENUM2STRING(LS_KICK_BF),
	ENUM2STRING(LS_KICK_RL),
	ENUM2STRING(LS_KICK_F_AIR),
	ENUM2STRING(LS_KICK_B_AIR),
	ENUM2STRING(LS_KICK_R_AIR),
	ENUM2STRING(LS_KICK_L_AIR),
	ENUM2STRING(LS_STABDOWN),
	ENUM2STRING(LS_STABDOWN_STAFF),
	ENUM2STRING(LS_STABDOWN_DUAL),
	ENUM2STRING(LS_DUAL_SPIN_PROTECT),
	ENUM2STRING(LS_STAFF_SOULCAL),
	ENUM2STRING(LS_A1_SPECIAL),
	ENUM2STRING(LS_A2_SPECIAL),
	ENUM2STRING(LS_A3_SPECIAL),
	ENUM2STRING(LS_UPSIDE_DOWN_ATTACK),
	ENUM2STRING(LS_PULL_ATTACK_STAB),
	ENUM2STRING(LS_PULL_ATTACK_SWING),
	ENUM2STRING(LS_SPINATTACK_ALORA),
	ENUM2STRING(LS_DUAL_FB),
	ENUM2STRING(LS_DUAL_LR),
	ENUM2STRING(LS_HILT_BASH),
	"",	-1
};

// Source: oracle/codemp/game/bg_saga.c:45-56
stringID_table_t bgSiegeClassFlagNames[] =
{
	ENUM2STRING(CFL_MORESABERDMG),
	ENUM2STRING(CFL_STRONGAGAINSTPHYSICAL),
	ENUM2STRING(CFL_FASTFORCEREGEN),
	ENUM2STRING(CFL_STATVIEWER),
	ENUM2STRING(CFL_HEAVYMELEE),
	ENUM2STRING(CFL_SINGLE_ROCKET),
	ENUM2STRING(CFL_CUSTOMSKEL),
	ENUM2STRING(CFL_EXTRA_AMMO),
	"", -1
};

// Source: oracle/codemp/game/bg_saga.c:59-70
stringID_table_t StanceTable[] =
{
	ENUM2STRING(SS_NONE),
	ENUM2STRING(SS_FAST),
	ENUM2STRING(SS_MEDIUM),
	ENUM2STRING(SS_STRONG),
	ENUM2STRING(SS_DESANN),
	ENUM2STRING(SS_TAVION),
	ENUM2STRING(SS_DUAL),
	ENUM2STRING(SS_STAFF),
	"", 0
};

// Source: oracle/codemp/game/bg_saga.c:73-98
stringID_table_t WPTable[] =
{
	"NULL",WP_NONE,
	ENUM2STRING(WP_NONE),
	// Player weapons
	ENUM2STRING(WP_STUN_BATON),
	ENUM2STRING(WP_MELEE),
	ENUM2STRING(WP_SABER),
	ENUM2STRING(WP_BRYAR_PISTOL),
	"WP_BLASTER_PISTOL", WP_BRYAR_PISTOL,
	ENUM2STRING(WP_BLASTER),
	ENUM2STRING(WP_DISRUPTOR),
	ENUM2STRING(WP_BOWCASTER),
	ENUM2STRING(WP_REPEATER),
	ENUM2STRING(WP_DEMP2),
	ENUM2STRING(WP_FLECHETTE),
	ENUM2STRING(WP_ROCKET_LAUNCHER),
	ENUM2STRING(WP_THERMAL),
	ENUM2STRING(WP_TRIP_MINE),
	ENUM2STRING(WP_DET_PACK),
	ENUM2STRING(WP_CONCUSSION),
	ENUM2STRING(WP_BRYAR_OLD),
	ENUM2STRING(WP_EMPLACED_GUN),
	ENUM2STRING(WP_TURRET),
	"", 0
};

// Source: oracle/codemp/game/bg_saga.c:100-121
stringID_table_t FPTable[] =
{
	ENUM2STRING(FP_HEAL),
	ENUM2STRING(FP_LEVITATION),
	ENUM2STRING(FP_SPEED),
	ENUM2STRING(FP_PUSH),
	ENUM2STRING(FP_PULL),
	ENUM2STRING(FP_TELEPATHY),
	ENUM2STRING(FP_GRIP),
	ENUM2STRING(FP_LIGHTNING),
	ENUM2STRING(FP_RAGE),
	ENUM2STRING(FP_PROTECT),
	ENUM2STRING(FP_ABSORB),
	ENUM2STRING(FP_TEAM_HEAL),
	ENUM2STRING(FP_TEAM_FORCE),
	ENUM2STRING(FP_DRAIN),
	ENUM2STRING(FP_SEE),
	ENUM2STRING(FP_SABER_OFFENSE),
	ENUM2STRING(FP_SABER_DEFENSE),
	ENUM2STRING(FP_SABERTHROW),
	"",	-1
};

// Source: oracle/codemp/game/bg_saga.c:123-140
stringID_table_t HoldableTable[] =
{
	ENUM2STRING(HI_NONE),

	ENUM2STRING(HI_SEEKER),
	ENUM2STRING(HI_SHIELD),
	ENUM2STRING(HI_MEDPAC),
	ENUM2STRING(HI_MEDPAC_BIG),
	ENUM2STRING(HI_BINOCULARS),
	ENUM2STRING(HI_SENTRY_GUN),
	ENUM2STRING(HI_JETPACK),
	ENUM2STRING(HI_HEALTHDISP),
	ENUM2STRING(HI_AMMODISP),
	ENUM2STRING(HI_EWEB),
	ENUM2STRING(HI_CLOAK),

	"", -1
};

// Source: oracle/codemp/game/bg_saga.c:142-162
stringID_table_t PowerupTable[] =
{
	ENUM2STRING(PW_NONE),
	ENUM2STRING(PW_QUAD),
	ENUM2STRING(PW_BATTLESUIT),
	ENUM2STRING(PW_PULL),
	ENUM2STRING(PW_REDFLAG),
	ENUM2STRING(PW_BLUEFLAG),
	ENUM2STRING(PW_NEUTRALFLAG),
	ENUM2STRING(PW_SHIELDHIT),
	ENUM2STRING(PW_SPEEDBURST),
	ENUM2STRING(PW_DISINT_4),
	ENUM2STRING(PW_SPEED),
	ENUM2STRING(PW_CLOAKED),
	ENUM2STRING(PW_FORCE_ENLIGHTENED_LIGHT),
	ENUM2STRING(PW_FORCE_ENLIGHTENED_DARK),
	ENUM2STRING(PW_FORCE_BOON),
	ENUM2STRING(PW_YSALAMIRI),

	"", -1
};

// Raven's `VFOFS` and `VWFOFS` read a field offset as a cast of a pointer to `int`, which is narrower on a 64-bit target.
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"

// The two vehicle tables read Raven's `#ifdef _JK2MP` arms, and bg_vehicleLoad.c sets the name at the top of the file.
// Source: oracle/codemp/game/bg_vehicleLoad.c:5
#define _JK2MP

// Source: oracle/codemp/game/bg_vehicleLoad.c:138-165
vehField_t vehWeaponFields[NUM_VWEAP_PARMS] = 
{
	{"name", VWFOFS(name), VF_LSTRING},	//unique name of the vehicle
	{"projectile", VWFOFS(bIsProjectile), VF_BOOL},	//traceline or entity?
	{"hasGravity", VWFOFS(bHasGravity), VF_BOOL},	//if a projectile, drops
	{"ionWeapon", VWFOFS(bIonWeapon), VF_BOOL},	//disables ship shields and sends them out of control
	{"saberBlockable", VWFOFS(bSaberBlockable), VF_BOOL},	//lightsabers can deflect this projectile
	{"muzzleFX", VWFOFS(iMuzzleFX), VF_EFFECT_CLIENT},	//index of Muzzle Effect
	{"model", VWFOFS(iModel), VF_MODEL_CLIENT},	//handle to the model used by this projectile
	{"shotFX", VWFOFS(iShotFX), VF_EFFECT_CLIENT},	//index of Shot Effect
	{"impactFX", VWFOFS(iImpactFX), VF_EFFECT_CLIENT},	//index of Impact Effect
	{"g2MarkShader", VWFOFS(iG2MarkShaderHandle), VF_SHADER},	//index of shader to use for G2 marks made on other models when hit by this projectile
	{"g2MarkSize", VWFOFS(fG2MarkSize), VF_FLOAT},	//size (diameter) of the ghoul2 mark
	{"loopSound", VWFOFS(iLoopSound), VF_SOUND_CLIENT},	//index of loopSound
	{"speed", VWFOFS(fSpeed), VF_FLOAT},		//speed of projectile/range of traceline
	{"homing", VWFOFS(fHoming), VF_FLOAT},		//0.0 = not homing, 0.5 = half vel to targ, half cur vel, 1.0 = all vel to targ
	{"homingFOV", VWFOFS(fHomingFOV), VF_FLOAT},//missile will lose lock on if DotProduct of missile direction and direction to target ever drops below this (-1 to 1, -1 = never lose target, 0 = lose if ship gets behind missile, 1 = pretty much will lose it's target right away)
	{"lockOnTime", VWFOFS(iLockOnTime), VF_INT},	//0 = no lock time needed, else # of ms needed to lock on
	{"damage", VWFOFS(iDamage), VF_INT},		//damage done when traceline or projectile directly hits target
	{"splashDamage", VWFOFS(iSplashDamage), VF_INT},//damage done to ents in splashRadius of end of traceline or projectile origin on impact
	{"splashRadius", VWFOFS(fSplashRadius), VF_FLOAT},//radius that ent must be in to take splashDamage (linear fall-off)
	{"ammoPerShot", VWFOFS(iAmmoPerShot), VF_INT},//how much "ammo" each shot takes
	{"health", VWFOFS(iHealth), VF_INT},		//if non-zero, projectile can be shot, takes this much damage before being destroyed
	{"width", VWFOFS(fWidth), VF_FLOAT},		//width of traceline or bounding box of projecile (non-rotating!)
	{"height", VWFOFS(fHeight), VF_FLOAT},		//height of traceline or bounding box of projecile (non-rotating!)
	{"lifetime", VWFOFS(iLifeTime), VF_INT},	//removes itself after this amount of time
	{"explodeOnExpire", VWFOFS(bExplodeOnExpire), VF_BOOL},	//when iLifeTime is up, explodes rather than simply removing itself
};

// Source: oracle/codemp/game/bg_vehicleLoad.c:445-669
vehField_t vehicleFields[] = 
{
	{"name", VFOFS(name), VF_LSTRING},	//unique name of the vehicle

	//general data
	{"type", VFOFS(type), VF_VEHTYPE},	//what kind of vehicle
	{"numHands", VFOFS(numHands), VF_INT},	//if 2 hands, no weapons, if 1 hand, can use 1-handed weapons, if 0 hands, can use 2-handed weapons
	{"lookPitch", VFOFS(lookPitch), VF_FLOAT},	//How far you can look up and down off the forward of the vehicle
	{"lookYaw", VFOFS(lookYaw), VF_FLOAT},	//How far you can look left and right off the forward of the vehicle
	{"length", VFOFS(length), VF_FLOAT},		//how long it is - used for body length traces when turning/moving?
	{"width", VFOFS(width), VF_FLOAT},		//how wide it is - used for body length traces when turning/moving?
	{"height", VFOFS(height), VF_FLOAT},		//how tall it is - used for body length traces when turning/moving?
	{"centerOfGravity", VFOFS(centerOfGravity), VF_VECTOR},//offset from origin: {forward, right, up} as a modifier on that dimension (-1.0f is all the way back, 1.0f is all the way forward)

	//speed stats
	{"speedMax", VFOFS(speedMax), VF_FLOAT},		//top speed
	{"turboSpeed", VFOFS(turboSpeed), VF_FLOAT},	//turbo speed
	{"speedMin", VFOFS(speedMin), VF_FLOAT},		//if < 0, can go in reverse
	{"speedIdle", VFOFS(speedIdle), VF_FLOAT},		//what speed it drifts to when no accel/decel input is given
	{"accelIdle", VFOFS(accelIdle), VF_FLOAT},		//if speedIdle > 0, how quickly it goes up to that speed
	{"acceleration", VFOFS(acceleration), VF_FLOAT},	//when pressing on accelerator
	{"decelIdle", VFOFS(decelIdle), VF_FLOAT},		//when giving no input, how quickly it drops to speedIdle
	{"throttleSticks", VFOFS(throttleSticks), VF_BOOL},//if true, speed stays at whatever you accel/decel to, unless you turbo or brake
	{"strafePerc", VFOFS(strafePerc), VF_FLOAT},		//multiplier on current speed for strafing.  If 1.0f, you can strafe at the same speed as you're going forward, 0.5 is half, 0 is no strafing

	//handling stats
	{"bankingSpeed", VFOFS(bankingSpeed), VF_FLOAT},	//how quickly it pitches and rolls (not under player control)
	{"pitchLimit", VFOFS(pitchLimit), VF_FLOAT},		//how far it can roll forward or backward
	{"rollLimit", VFOFS(rollLimit), VF_FLOAT},		//how far it can roll to either side
	{"braking", VFOFS(braking), VF_FLOAT},		//when pressing on decelerator
	{"mouseYaw", VFOFS(mouseYaw), VF_FLOAT},			// The mouse yaw override.
	{"mousePitch", VFOFS(mousePitch), VF_FLOAT},			// The mouse yaw override.
	{"turningSpeed", VFOFS(turningSpeed), VF_FLOAT},	//how quickly you can turn
	{"turnWhenStopped", VFOFS(turnWhenStopped), VF_BOOL},//whether or not you can turn when not moving
	{"traction", VFOFS(traction), VF_FLOAT},		//how much your command input affects velocity
	{"friction", VFOFS(friction), VF_FLOAT},		//how much velocity is cut on its own
	{"maxSlope", VFOFS(maxSlope), VF_FLOAT},		//the max slope that it can go up with control
	{"speedDependantTurning", VFOFS(speedDependantTurning), VF_BOOL},//vehicle turns faster the faster it's going
	
	//durability stats
	{"mass", VFOFS(mass), VF_INT},			//for momentum and impact force (player mass is 10)
	{"armor", VFOFS(armor), VF_INT},			//total points of damage it can take
	{"shields", VFOFS(shields), VF_INT},			//energy shield damage points
	{"shieldRechargeMS", VFOFS(shieldRechargeMS), VF_INT},//energy shield milliseconds per point recharged
	{"toughness", VFOFS(toughness), VF_FLOAT},		//modifies incoming damage, 1.0 is normal, 0.5 is half, etc.  Simulates being made of tougher materials/construction
	{"malfunctionArmorLevel", VFOFS(malfunctionArmorLevel), VF_INT},//when armor drops to or below this point, start malfunctioning
	{"surfDestruction", VFOFS(surfDestruction), VF_INT},

	//visuals & sounds
	{"model", VFOFS(model), VF_LSTRING},			//what model to use - if make it an NPC's primary model, don't need this?
	{"skin", VFOFS(skin), VF_LSTRING},				//what skin to use - if make it an NPC's primary model, don't need this?
	{"g2radius", VFOFS(g2radius), VF_INT},			//render radius (really diameter, but...) for the ghoul2 model
	{"riderAnim", VFOFS(riderAnim), VF_ANIM},		//what animation the rider uses
	{"droidNPC", VFOFS(droidNPC), VF_LSTRING},		//NPC to attach to *droidunit tag (if it exists in the model)

#ifdef _JK2MP
	{"radarIcon", VFOFS(radarIconHandle), VF_SHADER_NOMIP},		//what icon to show on radar in MP
	{"dmgIndicFrame", VFOFS(dmgIndicFrameHandle), VF_SHADER_NOMIP},	//what image to use for the frame of the damage indicator
	{"dmgIndicShield", VFOFS(dmgIndicShieldHandle), VF_SHADER_NOMIP},//what image to use for the shield of the damage indicator
	{"dmgIndicBackground", VFOFS(dmgIndicBackgroundHandle), VF_SHADER_NOMIP},//what image to use for the background of the damage indicator
	{"icon_front", VFOFS(iconFrontHandle), VF_SHADER_NOMIP},	//what image to use for the front of the ship on the damage indicator
	{"icon_back", VFOFS(iconBackHandle), VF_SHADER_NOMIP},		//what image to use for the back of the ship on the damage indicator
	{"icon_right", VFOFS(iconRightHandle), VF_SHADER_NOMIP},	//what image to use for the right of the ship on the damage indicator
	{"icon_left", VFOFS(iconLeftHandle), VF_SHADER_NOMIP},		//what image to use for the left of the ship on the damage indicator
	{"crosshairShader", VFOFS(crosshairShaderHandle), VF_SHADER_NOMIP},	//what image to use as the crosshair
	{"shieldShader", VFOFS(shieldShaderHandle), VF_SHADER},		//What shader to use when drawing the shield shell

	//individual "area" health -rww
	{"health_front", VFOFS(health_front), VF_INT},
	{"health_back", VFOFS(health_back), VF_INT},
	{"health_right", VFOFS(health_right), VF_INT},
	{"health_left", VFOFS(health_left), VF_INT},
#else
	{"radarIcon", 0, VF_IGNORE},		//what icon to show on radar in MP
#endif

	{"soundOn",			VFOFS(soundOn),			VF_SOUND},//sound to play when get on it
	{"soundOff",		VFOFS(soundOff),		VF_SOUND},//sound to play when get off
	{"soundLoop",		VFOFS(soundLoop),		VF_SOUND},//sound to loop while riding it
	{"soundTakeOff",	VFOFS(soundTakeOff),	VF_SOUND},//sound to play when ship takes off
	{"soundEngineStart",VFOFS(soundEngineStart),VF_SOUND_CLIENT},//sound to play when ship's thrusters first activate
	{"soundSpin",		VFOFS(soundSpin),		VF_SOUND},//sound to loop while spiraling out of control
	{"soundTurbo",		VFOFS(soundTurbo),		VF_SOUND},//sound to play when turbo/afterburner kicks in
	{"soundHyper",		VFOFS(soundHyper),		VF_SOUND_CLIENT},//sound to play when hits hyperspace
	{"soundLand",		VFOFS(soundLand),		VF_SOUND},//sound to play when ship lands
	{"soundFlyBy",		VFOFS(soundFlyBy),		VF_SOUND_CLIENT},//sound to play when they buzz you
	{"soundFlyBy2",		VFOFS(soundFlyBy2),		VF_SOUND_CLIENT},//alternate sound to play when they buzz you
	{"soundShift1",		VFOFS(soundShift1),		VF_SOUND},//sound to play when changing speeds
	{"soundShift2",		VFOFS(soundShift2),		VF_SOUND},//sound to play when changing speeds
	{"soundShift3",		VFOFS(soundShift3),		VF_SOUND},//sound to play when changing speeds
	{"soundShift4",		VFOFS(soundShift4),		VF_SOUND},//sound to play when changing speeds

	{"exhaustFX", VFOFS(iExhaustFX), VF_EFFECT_CLIENT},		//exhaust effect, played from "*exhaust" bolt(s)
	{"turboFX", VFOFS(iTurboFX), VF_EFFECT_CLIENT},		//turbo exhaust effect, played from "*exhaust" bolt(s) when ship is in "turbo" mode
	{"turboStartFX", VFOFS(iTurboStartFX), VF_EFFECT},		//turbo start effect, played from "*exhaust" bolt(s) when ship is in "turbo" mode
	{"trailFX", VFOFS(iTrailFX), VF_EFFECT_CLIENT},		//trail effect, played from "*trail" bolt(s)
	{"impactFX", VFOFS(iImpactFX), VF_EFFECT_CLIENT},		//impact effect, for when it bumps into something
	{"explodeFX", VFOFS(iExplodeFX), VF_EFFECT},		//explosion effect, for when it blows up (should have the sound built into explosion effect)
	{"wakeFX", VFOFS(iWakeFX), VF_EFFECT_CLIENT},		//effect it makes when going across water
	{"dmgFX", VFOFS(iDmgFX), VF_EFFECT_CLIENT},		//effect to play on damage from a weapon or something
#ifdef _JK2MP
	{"injureFX", VFOFS(iInjureFX), VF_EFFECT_CLIENT}, //effect to play on partially damaged ship surface
	{"noseFX", VFOFS(iNoseFX), VF_EFFECT_CLIENT},		//effect for nose piece flying away when blown off
	{"lwingFX", VFOFS(iLWingFX), VF_EFFECT_CLIENT},		//effect for left wing piece flying away when blown off
	{"rwingFX", VFOFS(iRWingFX), VF_EFFECT_CLIENT},		//effect for right wing piece flying away when blown off
#else
	{"armorLowFX", VFOFS(iArmorLowFX), VF_EFFECT_CLIENT},		//effect to play on damage from a weapon or something
	{"armorGoneFX", VFOFS(iArmorGoneFX), VF_EFFECT_CLIENT},		//effect to play on damage from a weapon or something
#endif

	// Weapon stuff:
	{"weap1", VFOFS(weapon[0].ID), VF_WEAPON},	//weapon used when press fire
	{"weap2", VFOFS(weapon[1].ID), VF_WEAPON},//weapon used when press alt-fire
	// The delay between shots for this weapon.
	{"weap1Delay", VFOFS(weapon[0].delay), VF_INT},
	{"weap2Delay", VFOFS(weapon[1].delay), VF_INT},
	// Whether or not all the muzzles for each weapon can be linked together (linked delay = weapon delay * number of muzzles linked!)
	{"weap1Link", VFOFS(weapon[0].linkable), VF_INT},
	{"weap2Link", VFOFS(weapon[1].linkable), VF_INT},
	// Whether or not to auto-aim the projectiles at the thing under the crosshair when we fire
	{"weap1Aim", VFOFS(weapon[0].aimCorrect), VF_BOOL},
	{"weap2Aim", VFOFS(weapon[1].aimCorrect), VF_BOOL},
	//maximum ammo
	{"weap1AmmoMax", VFOFS(weapon[0].ammoMax), VF_INT},
	{"weap2AmmoMax", VFOFS(weapon[1].ammoMax), VF_INT},
	//ammo recharge rate - milliseconds per unit (minimum of 100, which is 10 ammo per second)
	{"weap1AmmoRechargeMS", VFOFS(weapon[0].ammoRechargeMS), VF_INT},
	{"weap2AmmoRechargeMS", VFOFS(weapon[1].ammoRechargeMS), VF_INT},
	//sound to play when out of ammo (plays default "no ammo" sound if none specified)
	{"weap1SoundNoAmmo", VFOFS(weapon[0].soundNoAmmo), VF_SOUND_CLIENT},//sound to play when try to fire weapon 1 with no ammo
	{"weap2SoundNoAmmo", VFOFS(weapon[1].soundNoAmmo), VF_SOUND_CLIENT},//sound to play when try to fire weapon 2 with no ammo
	
	// Which weapon a muzzle fires (has to match one of the weapons this vehicle has).
	{"weapMuzzle1", VFOFS(weapMuzzle[0]), VF_WEAPON},
	{"weapMuzzle2", VFOFS(weapMuzzle[1]), VF_WEAPON},
	{"weapMuzzle3", VFOFS(weapMuzzle[2]), VF_WEAPON},
	{"weapMuzzle4", VFOFS(weapMuzzle[3]), VF_WEAPON},
	{"weapMuzzle5", VFOFS(weapMuzzle[4]), VF_WEAPON},
	{"weapMuzzle6", VFOFS(weapMuzzle[5]), VF_WEAPON},
	{"weapMuzzle7", VFOFS(weapMuzzle[6]), VF_WEAPON},
	{"weapMuzzle8", VFOFS(weapMuzzle[7]), VF_WEAPON},
	{"weapMuzzle9", VFOFS(weapMuzzle[8]), VF_WEAPON},
	{"weapMuzzle10", VFOFS(weapMuzzle[9]), VF_WEAPON},

	// The max height before this ship (?) starts (auto)landing.
	{"landingHeight", VFOFS(landingHeight), VF_FLOAT},

	//other misc stats
	{"gravity", VFOFS(gravity), VF_INT},			//normal is 800
	{"hoverHeight", VFOFS(hoverHeight), VF_FLOAT},	//if 0, it's a ground vehicle
	{"hoverStrength", VFOFS(hoverStrength), VF_FLOAT},	//how hard it pushes off ground when less than hover height... causes "bounce", like shocks
	{"waterProof", VFOFS(waterProof), VF_BOOL},		//can drive underwater if it has to
	{"bouyancy", VFOFS(bouyancy), VF_FLOAT},		//when in water, how high it floats (1 is neutral bouyancy)
	{"fuelMax", VFOFS(fuelMax), VF_INT},		//how much fuel it can hold (capacity)
	{"fuelRate", VFOFS(fuelRate), VF_INT},		//how quickly is uses up fuel
	{"turboDuration", VFOFS(turboDuration), VF_INT},		//how long turbo lasts
	{"turboRecharge", VFOFS(turboRecharge), VF_INT},		//how long turbo takes to recharge
	{"visibility", VFOFS(visibility), VF_INT},		//for sight alerts
	{"loudness", VFOFS(loudness), VF_INT},		//for sound alerts
	{"explosionRadius", VFOFS(explosionRadius), VF_FLOAT},//range of explosion
	{"explosionDamage", VFOFS(explosionDamage), VF_INT},//damage of explosion

	//new stuff
	{"maxPassengers", VFOFS(maxPassengers), VF_INT},	// The max number of passengers this vehicle may have (Default = 0).
	{"hideRider", VFOFS(hideRider), VF_BOOL},			// rider (and passengers?) should not be drawn
	{"killRiderOnDeath", VFOFS(killRiderOnDeath), VF_BOOL},//if rider is on vehicle when it dies, they should die
	{"flammable", VFOFS(flammable), VF_BOOL},			//whether or not the vehicle should catch on fire before it explodes
	{"explosionDelay", VFOFS(explosionDelay), VF_INT},	//how long the vehicle should be on fire/dying before it explodes
	//camera stuff
	{"cameraOverride", VFOFS(cameraOverride), VF_BOOL},//override the third person camera with the below values - normal is 0 (off)
	{"cameraRange", VFOFS(cameraRange), VF_FLOAT},		//how far back the camera should be - normal is 80
	{"cameraVertOffset", VFOFS(cameraVertOffset), VF_FLOAT},//how high over the vehicle origin the camera should be - normal is 16
	{"cameraHorzOffset", VFOFS(cameraHorzOffset), VF_FLOAT},//how far to left/right (negative/positive) of of the vehicle origin the camera should be - normal is 0
	{"cameraPitchOffset", VFOFS(cameraPitchOffset), VF_FLOAT},//a modifier on the camera's pitch (up/down angle) to the vehicle - normal is 0
	{"cameraFOV", VFOFS(cameraFOV), VF_FLOAT},			//third person camera FOV, default is 80
	{"cameraAlpha", VFOFS(cameraAlpha), VF_FLOAT},		//fade out the vehicle to this alpha (0.1-1.0f) if it's in the way of the crosshair
	{"cameraPitchDependantVertOffset", VFOFS(cameraPitchDependantVertOffset), VF_BOOL},		//use the hacky AT-ST pitch dependant vertical offset
//===TURRETS===========================================================================
	//Turret 1
	{"turret1Weap", VFOFS(turret[0].iWeapon), VF_WEAPON},
	{"turret1Delay", VFOFS(turret[0].iDelay), VF_INT},
	{"turret1AmmoMax", VFOFS(turret[0].iAmmoMax), VF_INT},
	{"turret1AmmoRechargeMS", VFOFS(turret[0].iAmmoRechargeMS), VF_INT},
	{"turret1YawBone", VFOFS(turret[0].yawBone), VF_LSTRING},
	{"turret1PitchBone", VFOFS(turret[0].pitchBone), VF_LSTRING},
	{"turret1YawAxis", VFOFS(turret[0].yawAxis), VF_INT},
	{"turret1PitchAxis", VFOFS(turret[0].pitchAxis), VF_INT},
	{"turret1ClampYawL", VFOFS(turret[0].yawClampLeft), VF_FLOAT},	//how far the turret is allowed to turn left
	{"turret1ClampYawR", VFOFS(turret[0].yawClampRight), VF_FLOAT},	//how far the turret is allowed to turn right
	{"turret1ClampPitchU", VFOFS(turret[0].pitchClampUp), VF_FLOAT},	//how far the turret is allowed to title up
	{"turret1ClampPitchD", VFOFS(turret[0].pitchClampDown), VF_FLOAT}, //how far the turret is allowed to tilt down
	{"turret1Muzzle1", VFOFS(turret[0].iMuzzle[0]), VF_INT},
	{"turret1Muzzle2", VFOFS(turret[0].iMuzzle[1]), VF_INT},
	{"turret1TurnSpeed", VFOFS(turret[0].fTurnSpeed), VF_FLOAT},
	{"turret1AI", VFOFS(turret[0].bAI), VF_BOOL},
	{"turret1AILead", VFOFS(turret[0].bAILead), VF_BOOL},
	{"turret1AIRange", VFOFS(turret[0].fAIRange), VF_FLOAT},
	{"turret1PassengerNum", VFOFS(turret[0].passengerNum), VF_INT},//which number passenger can control this turret
	{"turret1GunnerViewTag", VFOFS(turret[0].gunnerViewTag), VF_LSTRING},
	
	//Turret 2
	{"turret2Weap", VFOFS(turret[1].iWeapon), VF_WEAPON},
	{"turret2Delay", VFOFS(turret[1].iDelay), VF_INT},
	{"turret2AmmoMax", VFOFS(turret[1].iAmmoMax), VF_INT},
	{"turret2AmmoRechargeMS", VFOFS(turret[1].iAmmoRechargeMS), VF_INT},
	{"turret2YawBone", VFOFS(turret[1].yawBone), VF_LSTRING},
	{"turret2PitchBone", VFOFS(turret[1].pitchBone), VF_LSTRING},
	{"turret2YawAxis", VFOFS(turret[1].yawAxis), VF_INT},
	{"turret2PitchAxis", VFOFS(turret[1].pitchAxis), VF_INT},
	{"turret2ClampYawL", VFOFS(turret[1].yawClampLeft), VF_FLOAT},	//how far the turret is allowed to turn left
	{"turret2ClampYawR", VFOFS(turret[1].yawClampRight), VF_FLOAT},	//how far the turret is allowed to turn right
	{"turret2ClampPitchU", VFOFS(turret[1].pitchClampUp), VF_FLOAT},	//how far the turret is allowed to title up
	{"turret2ClampPitchD", VFOFS(turret[1].pitchClampDown), VF_FLOAT}, //how far the turret is allowed to tilt down
	{"turret2Muzzle1", VFOFS(turret[1].iMuzzle[0]), VF_INT},
	{"turret2Muzzle2", VFOFS(turret[1].iMuzzle[1]), VF_INT},
	{"turret2TurnSpeed", VFOFS(turret[1].fTurnSpeed), VF_FLOAT},
	{"turret2AI", VFOFS(turret[1].bAI), VF_BOOL},
	{"turret2AILead", VFOFS(turret[1].bAILead), VF_BOOL},
	{"turret2AIRange", VFOFS(turret[1].fAIRange), VF_FLOAT},
	{"turret2PassengerNum", VFOFS(turret[1].passengerNum), VF_INT},//which number passenger can control this turret
	{"turret2GunnerViewTag", VFOFS(turret[1].gunnerViewTag), VF_LSTRING},
//===END TURRETS===========================================================================
	//terminating entry
	{0, -1, VF_INT}
};

// The `_JK2MP` name belongs to Raven's bg_vehicleLoad.c alone, so it ends with the two vehicle field tables.
#undef _JK2MP

// Source: oracle/codemp/game/bg_vehicleLoad.c:671-680
stringID_table_t VehicleTable[VH_NUM_VEHICLES+1] =
{
	ENUM2STRING(VH_NONE),
	ENUM2STRING(VH_WALKER),		//something you ride inside of, it walks like you, like an AT-ST
	ENUM2STRING(VH_FIGHTER),	//something you fly inside of, like an X-Wing or TIE fighter
	ENUM2STRING(VH_SPEEDER),	//something you ride on that hovers, like a speeder or swoop
	ENUM2STRING(VH_ANIMAL),		//animal you ride on top of that walks, like a tauntaun
	ENUM2STRING(VH_FLIER),		//animal you ride on top of that flies, like a giant mynoc?
	0,	-1
};
