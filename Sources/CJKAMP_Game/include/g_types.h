// Raven's types defined inside a .c file, copied as written, so a view can bind over them and C storage can hold them.
#ifndef JKA_G_TYPES_H
#define JKA_G_TYPES_H

// Source: oracle/codemp/game/g_timer.c:10
typedef struct gtimer_s
{
	const char *name;
	int time;
	struct gtimer_s *next;	// In either free list or current list
} gtimer_t;

// Source: oracle/codemp/game/g_misc.c:2873
#define MAX_TAGS 256

// Source: oracle/codemp/game/g_misc.c:2879
typedef struct tagOwner_s
{
	char			name[MAX_REFNAME];
	reference_tag_t	tags[MAX_TAGS];
	qboolean		inuse;
} tagOwner_t;

// Source: oracle/codemp/game/w_saber.c:2446
typedef struct saberFace_s
{
	vec3_t v1;
	vec3_t v2;
	vec3_t v3;
} saberFace_t;

// Source: oracle/codemp/game/g_svcmds.c:41
typedef struct ipFilter_s
{
	unsigned	mask;
	unsigned	compare;
} ipFilter_t;

// Source: oracle/codemp/game/g_main.c:17
typedef struct {
	vmCvar_t	*vmCvar;
	char		*cvarName;
	char		*defaultString;
	int			cvarFlags;
	int			modificationCount;  // for tracking changes
	qboolean	trackChange;	    // track this variable, and announce if changed
  qboolean teamShader;        // track and if changed, update shader state
} cvarTable_t;

// Source: oracle/codemp/game/g_mover.c:18
typedef struct {
	gentity_t	*ent;
	vec3_t	origin;
	vec3_t	angles;
	float	deltayaw;
} pushed_t;

// Source: oracle/codemp/game/g_spawn.c:153
typedef struct {
	char	*name;
	void	(*spawn)(gentity_t *ent);
} spawn_t;

// Source: oracle/codemp/game/g_bot.c:21
typedef struct {
	int		clientNum;
	int		spawnTime;
} botSpawnQueue_t;

// Source: oracle/codemp/game/g_utils.c:9
typedef struct {
  char oldShader[MAX_QPATH];
  char newShader[MAX_QPATH];
  float timeOffset;
} shaderRemap_t;

// Source: oracle/codemp/game/g_misc.c:3346
typedef struct shooterClient_s
{
	gclient_t		cl;
	qboolean		inuse;
} shooterClient_t;

// Source: oracle/codemp/game/g_team.c:8
typedef struct teamgame_s {
	float			last_flag_capture;
	int				last_capture_team;
	flagStatus_t	redStatus;	// CTF
	flagStatus_t	blueStatus;	// CTF
	flagStatus_t	flagStatus;	// One Flag CTF
	int				redTakenTime;
	int				blueTakenTime;
} teamgame_t;

// Source: oracle/codemp/game/NPC_combat.c:2570
typedef struct
{
	float dist;
	int index;
} combatPt_t;

// Source: oracle/codemp/game/w_saber.c:1075
typedef enum
{
	LOCK_FIRST = 0,
	LOCK_TOP = LOCK_FIRST,
	LOCK_DIAG_TR,
	LOCK_DIAG_TL,
	LOCK_DIAG_BR,
	LOCK_DIAG_BL,
	LOCK_R,
	LOCK_L,
	LOCK_RANDOM
} sabersLockMode_t;

#endif
