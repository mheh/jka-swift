// Raven's types defined inside a .c file, copied as written, so a view can bind over them and C storage can hold them.
#ifndef JKA_CG_TYPES_H
#define JKA_CG_TYPES_H

// Source: oracle/codemp/cgame/cg_main.c:875
typedef struct {
	vmCvar_t	*vmCvar;
	char		*cvarName;
	char		*defaultString;
	int			cvarFlags;
} cvarTable_t;

// Source: oracle/codemp/cgame/cg_main.c:3373
typedef struct cgSpawnEnt_s
{
	char		*classname;
	vec3_t		origin;
	vec3_t		angles;
	float		angle;
	vec3_t		scale;
	float		fScale;
	vec3_t		mins;
	vec3_t		maxs;
	char		*model;
	float		zoffset;
	int			onlyFogHere;
	float		fogstart;
	float		radarrange;
} cgSpawnEnt_t;

// Source: oracle/codemp/cgame/cg_marks.c:300
typedef struct particle_s
{
	struct particle_s	*next;

	float		time;
	float		endtime;

	vec3_t		org;
	vec3_t		vel;
	vec3_t		accel;
	int			color;
	float		colorvel;
	float		alpha;
	float		alphavel;
	int			type;
	qhandle_t	pshader;
	
	float		height;
	float		width;
				
	float		endheight;
	float		endwidth;
	
	float		start;
	float		end;

	float		startfade;
	qboolean	rotate;
	int			snum;
	
	qboolean	link;

	// Ridah
	int			shaderAnim;
	int			roll;

	int			accumroll;

} cparticle_t;

// Source: oracle/codemp/cgame/cg_draw.c:4141
#define	LAG_SAMPLES		128

// Source: oracle/codemp/cgame/cg_draw.c:4144
typedef struct {
	int		frameSamples[LAG_SAMPLES];
	int		frameCount;
	int		snapshotFlags[LAG_SAMPLES];
	int		snapshotSamples[LAG_SAMPLES];
	int		snapshotCount;
} lagometer_t;

// Source: oracle/codemp/cgame/cg_draw.c:2418
typedef struct 
{
	char	*itemName;
	short	heavyDamage;
	short	lightDamage;
} veh_damage_t;

// Source: oracle/codemp/cgame/cg_consolecmds.c:260
typedef struct {
	char	*cmd;
	void	(*function)(void);
} consoleCommand_t;

// Source: oracle/codemp/ui/ui_shared.c:24
typedef struct scrollInfo_s {
	int nextScrollTime;
	int nextAdjustTime;
	int adjustValue;
	int scrollKey;
	float xStart;
	float yStart;
	itemDef_t *item;
	qboolean scrollDir;
} scrollInfo_t;

// Source: oracle/codemp/ui/ui_shared.c:152
typedef struct  itemFlagsDef_s {
	char *string;
	int value;
}	itemFlagsDef_t;

// Source: oracle/codemp/ui/ui_shared.c:5173
typedef struct {
	char	*command;
	int		id;
	int		defaultbind1;
	int		defaultbind2;
	int		bind1;
	int		bind2;
} bind_t;

// Source: oracle/codemp/ui/ui_shared.c:279
typedef struct stringDef_s {
	struct stringDef_s *next;
	const char *str;
} stringDef_t;

#endif
