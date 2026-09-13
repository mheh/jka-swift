// Raven's tables that bg_tables.c defines as written, declared so a view can bind over them.
#ifndef JKA_BG_TABLES_H
#define JKA_BG_TABLES_H

// The Swift importer drops an array of unknown bound, so the bound is written, and clang checks it against the initializer.
// Source: oracle/codemp/game/bg_misc.c:795
extern gitem_t bg_itemlist[52];
// Source: oracle/codemp/game/bg_misc.c:1771
extern int bg_numItems;
// Source: oracle/codemp/game/bg_weapons.c:31
extern weaponData_t weaponData[WP_NUM_WEAPONS];
// Source: oracle/codemp/game/bg_weapons.c:358
extern ammoData_t ammoData[AMMO_MAX];
// Source: oracle/codemp/game/bg_saber.c:120
extern saberMoveData_t saberMoveData[LS_MOVE_MAX];

// Raven's field descriptor of the vehicle parsers, and the enum it names, defined inside bg_vehicleLoad.c.
// Source: oracle/codemp/game/bg_vehicleLoad.c:111
typedef enum {
	VF_IGNORE,
	VF_INT,
	VF_FLOAT,
	VF_LSTRING,	// string on disk, pointer in memory, TAG_LEVEL
	VF_VECTOR,
	VF_BOOL,
	VF_VEHTYPE,
	VF_ANIM,
	VF_WEAPON,	// take string, resolve into index into VehWeaponParms
	VF_MODEL,	// take the string, get the G_ModelIndex
	VF_MODEL_CLIENT,	// (cgame only) take the string, get the G_ModelIndex
	VF_EFFECT,	// take the string, get the G_EffectIndex
	VF_EFFECT_CLIENT,	// (cgame only) take the string, get the index
	VF_SHADER,	// (cgame only) take the string, call trap_R_RegisterShader
	VF_SHADER_NOMIP,// (cgame only) take the string, call trap_R_RegisterShaderNoMip
	VF_SOUND,	// take the string, get the G_SoundIndex
	VF_SOUND_CLIENT	// (cgame only) take the string, get the index
} vehFieldType_t;

// Source: oracle/codemp/game/bg_vehicleLoad.c:131
typedef struct
{
	char	*name;
	int		ofs;
	vehFieldType_t	type;
} vehField_t;

#endif // JKA_BG_TABLES_H
