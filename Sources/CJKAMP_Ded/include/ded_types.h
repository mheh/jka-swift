// Raven's types defined inside a .cpp file of the host, copied as written, so a view can bind over them and C storage can hold them.
#ifndef JKA_DED_TYPES_H
#define JKA_DED_TYPES_H

// Source: oracle/codemp/qcommon/cmd_common.cpp:10
typedef struct {
	byte	*data;
	int		maxsize;
	int		cursize;
} cmd_t;

// Source: oracle/codemp/qcommon/md4.cpp:17
// AI: Raven typed UINT4 as unsigned long int. The port fixes it at 32 bits so the checksum matches on an lp64 host.
typedef unsigned int UINT4;

// Source: oracle/codemp/qcommon/md4.cpp:33
typedef struct {
	UINT4 state[4];				/* state (ABCD) */
	UINT4 count[2];				/* number of bits, modulo 2^64 (lsb first) */
	unsigned char buffer[64]; 			/* input buffer */
} MD4_CTX;

// Source: oracle/codemp/qcommon/net_chan.cpp:474
#define	MAX_LOOPBACK	16

// The arm Raven's `#ifndef _XBOX` build takes.
// Source: oracle/codemp/qcommon/net_chan.cpp:33
#define	MAX_PACKETLEN			1400		// max size of a network packet

// Source: oracle/codemp/qcommon/net_chan.cpp:476
typedef struct {
	byte	data[MAX_PACKETLEN];
	int		datalen;
} loopmsg_t;

// Source: oracle/codemp/qcommon/net_chan.cpp:481
typedef struct {
	loopmsg_t	msgs[MAX_LOOPBACK];
	int			get, send;
} loopback_t;

// Source: oracle/codemp/qcommon/msg.cpp:832

typedef struct {
	char	*name;
	int		offset;
#ifdef _XBOX
	int		realSize;	// in bytes (1, 2, 4)
#endif
	int		bits;		// 0 = float
#ifndef FINAL_BUILD
	unsigned	mCount;
#endif

} netField_t;

// The arm Raven's `#ifndef _XBOX` build takes.
// Source: oracle/codemp/qcommon/msg.cpp:1994
typedef struct bitStorage_s bitStorage_t;

// Source: oracle/codemp/qcommon/msg.cpp:1996
struct bitStorage_s
{
	bitStorage_t	*next;
	int				bits;
};

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:30
typedef struct zoneHeader_s
{
		int					iMagic;
		memtag_t			eTag;
		int					iSize;
struct	zoneHeader_s		*pNext;
struct	zoneHeader_s		*pPrev;
} zoneHeader_t;

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:39
typedef struct
{
	int iMagic;

} zoneTail_t;

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:55
typedef struct zoneStats_s
{
	int		iCount;
	int		iCurrent;
	int		iPeak;

	// I'm keeping these updated on the fly, since it's quicker for cache-pool
	//	purposes rather than recalculating each time...
	//
	int		iSizesPerTag [TAG_COUNT];
	int		iCountsPerTag[TAG_COUNT];

} zoneStats_t;

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:69
typedef struct zone_s
{
	zoneStats_t				Stats;
	zoneHeader_t			Header;
} zone_t;

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:122
#pragma pack(push)
#pragma pack(1)
// Source: oracle/codemp/qcommon/z_memman_pc.cpp:124
typedef struct
{
	zoneHeader_t	Header;
//	byte mem[0];
	zoneTail_t		Tail;
} StaticZeroMem_t;

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:131
typedef struct
{
	zoneHeader_t	Header;
	byte mem[2];
	zoneTail_t		Tail;
} StaticMem_t;
#pragma pack(pop)

// Source: oracle/codemp/server/sv_world.cpp:48
typedef struct worldSector_s {
	int		axis;		// -1 = leaf node
	float	dist;
	struct worldSector_s	*children[2];
	svEntity_t	*entities;
} worldSector_t;

// Source: oracle/codemp/server/sv_world.cpp:359
typedef struct {
	// AI: Raven holds the address of the caller's vectors. The copy holds the two vectors, because sv_world.cpp only reads them, row SV1.
	vec3_t		mins;
	vec3_t		maxs;
	int			*list;
	int			count, maxcount;
} areaParms_t;

// Source: oracle/codemp/server/sv_world.cpp:440
typedef struct {
	vec3_t		boxmins, boxmaxs;// enclose the test object along entire move
	// AI: Raven holds the address of the caller's vectors. The copy holds the two vectors, because sv_world.cpp only reads them, row SV1.
	vec3_t		mins;
	vec3_t		maxs;	// size of the moving object
/*
Ghoul2 Insert Start
*/
	vec3_t		start;

	vec3_t		end;

	int			passEntityNum;
	int			contentmask;
	int			capsule;

	int			traceFlags;
	int			useLod;
	trace_t		trace;			// make sure nothing goes under here for Ghoul2 collision purposes
/*
Ghoul2 Insert End
*/
} moveclip_t;

// Source: oracle/codemp/server/sv_snapshot.cpp:244
#define	MAX_SNAPSHOT_ENTITIES	1024
typedef struct {
	int		numSnapshotEntities;
	int		snapshotEntities[MAX_SNAPSHOT_ENTITIES];	
} snapshotEntityNumbers_t;

// Source: oracle/codemp/server/sv_bot.cpp:8
typedef struct bot_debugpoly_s
{
	int inuse;
	int color;
	int numPoints;
	vec3_t points[128];
} bot_debugpoly_t;

// Source: oracle/codemp/renderer/tr_model.cpp:27
typedef	struct modelHash_s
{
	char		name[MAX_QPATH];
	qhandle_t	handle;
	struct		modelHash_s	*next;

}modelHash_t;

// Source: oracle/codemp/ghoul2/G2_bones.cpp:1165
struct SRagEffector
{
	vec3_t		currentOrigin;
	vec3_t		desiredDirection;
	vec3_t		desiredOrigin;
	float		radius;
	float		weight;
};
// C++ names the tag without its keyword, and this typedef lets C do the same.
typedef struct SRagEffector SRagEffector;

// Source: oracle/codemp/ghoul2/G2_misc.cpp:780
// AI: Raven's constructor sets `touch` to 0. The C copy drops it, because the zeroed storage of `GoreVerts` holds the same value.
struct SVertexTemp
{
	int flags;
	int touch;
	int newindex;
	float tex[2];
};
// C++ names the tag without its keyword, and this typedef lets C do the same.
typedef struct SVertexTemp SVertexTemp;

// Source: oracle/codemp/renderer/tr_image.cpp:2338
typedef struct
{
	int		pixel;
	float	weight;
} contrib_t;

// Source: oracle/codemp/renderer/tr_image.cpp:2344
typedef struct
{
	int			n;		// number of contributors
	contrib_t	*p;		// pointer to list of contributions
} contrib_list_t;

// Source: oracle/codemp/renderer/tr_init.cpp:459
typedef struct vidmode_s
{
    const char *description;
    int         width, height;
} vidmode_t;

// The botlib edge of botlib.h, a header of the game parse that the host parse does not read, row B1.
// GetBotLibAPI of be_interface.cpp:842 and SV_BotInitBotLib of sv_bot.cpp:722 read the version, row X3 of docket 10.
// Source: oracle/codemp/game/botlib.h:16
#define	BOTLIB_API_VERSION		2

// Source: oracle/codemp/game/botlib.h:18
struct aas_clientmove_s;
struct aas_entityinfo_s;
struct aas_areainfo_s;
struct aas_altroutegoal_s;
struct aas_predictroute_s;
struct bot_consolemessage_s;
struct bot_match_s;
struct bot_goal_s;
struct bot_moveresult_s;
struct bot_initmove_s;
struct weaponinfo_s;

// Source: oracle/codemp/game/botlib.h:40
#define PRT_MESSAGE				1
#define PRT_WARNING				2
#define PRT_ERROR				3
#define PRT_FATAL				4
#define PRT_EXIT				5

// Source: oracle/codemp/game/botlib.h:92
//the bot input, will be converted to an usercmd_t
typedef struct bot_input_s
{
	float thinktime;		//time since last output (in seconds)
	vec3_t dir;				//movement direction
	float speed;			//speed in the range [0, 400]
	vec3_t viewangles;		//the view angles
	int actionflags;		//one of the ACTION_? flags
	int weapon;				//weapon to use
} bot_input_t;

#ifndef BSPTRACE

#define BSPTRACE

//bsp_trace_t hit surface
typedef struct bsp_surface_s
{
	char name[16];
	int flags;
	int value;
} bsp_surface_t;

//remove the bsp_trace_s structure definition l8r on
//a trace is returned when a box is swept through the world
typedef struct bsp_trace_s
{
	qboolean		allsolid;	// if true, plane is not valid
	qboolean		startsolid;	// if true, the initial point was in a solid area
	float			fraction;	// time completed, 1.0 = didn't hit anything
	vec3_t			endpos;		// final position
	cplane_t		plane;		// surface normal at impact
	float			exp_dist;	// expanded plane distance
	int				sidenum;	// number of the brush side hit
	bsp_surface_t	surface;	// the hit point surface
	int				contents;	// contents on other side of surface hit
	int				ent;		// number of entity hit
} bsp_trace_t;

#endif	// BSPTRACE

//entity state
typedef struct bot_entitystate_s
{
	int		type;			// entity type
	int		flags;			// entity flags
	vec3_t	origin;			// origin of the entity
	vec3_t	angles;			// angles of the model
	vec3_t	old_origin;		// for lerping
	vec3_t	mins;			// bounding box minimums
	vec3_t	maxs;			// bounding box maximums
	int		groundent;		// ground entity
	int		solid;			// solid type
	int		modelindex;		// model used
	int		modelindex2;	// weapons, CTF flags, etc
	int		frame;			// model frame number
	int		event;			// impulse events -- muzzle flashes, footsteps, etc
	int		eventParm;		// even parameter
	int		powerups;		// bit flags
	int		weapon;			// determines weapon and flash model, etc
	int		legsAnim;
	int		torsoAnim;
} bot_entitystate_t;

//bot AI library exported functions
typedef struct botlib_import_s
{
	//print messages from the bot library
	void		(QDECL *Print)(int type, char *fmt, ...);
	//trace a bbox through the world
	void		(*Trace)(bsp_trace_t *trace, vec3_t start, vec3_t mins, vec3_t maxs, vec3_t end, int passent, int contentmask);
	//trace a bbox against a specific entity
	void		(*EntityTrace)(bsp_trace_t *trace, vec3_t start, vec3_t mins, vec3_t maxs, vec3_t end, int entnum, int contentmask);
	//retrieve the contents at the given point
	int			(*PointContents)(vec3_t point);
	//check if the point is in potential visible sight
	int			(*inPVS)(vec3_t p1, vec3_t p2);
	//retrieve the BSP entity data lump
	char		*(*BSPEntityData)(void);
	//
	void		(*BSPModelMinsMaxsOrigin)(int modelnum, vec3_t angles, vec3_t mins, vec3_t maxs, vec3_t origin);
	//send a bot client command
	void		(*BotClientCommand)(int client, char *command);
	//memory allocation
	void		*(*GetMemory)(int size);		// allocate from Zone
	void		(*FreeMemory)(void *ptr);		// free memory from Zone
	int			(*AvailableMemory)(void);		// available Zone memory
	void		*(*HunkAlloc)(int size);		// allocate from hunk
	//file system access
	int			(*FS_FOpenFile)( const char *qpath, fileHandle_t *file, fsMode_t mode );
	int			(*FS_Read)( void *buffer, int len, fileHandle_t f );
	int			(*FS_Write)( const void *buffer, int len, fileHandle_t f );
	void		(*FS_FCloseFile)( fileHandle_t f );
	int			(*FS_Seek)( fileHandle_t f, long offset, int origin );
	//debug visualisation stuff
	int			(*DebugLineCreate)(void);
	void		(*DebugLineDelete)(int line);
	void		(*DebugLineShow)(int line, vec3_t start, vec3_t end, int color);
	//
	int			(*DebugPolygonCreate)(int color, int numPoints, vec3_t *points);
	void		(*DebugPolygonDelete)(int id);
} botlib_import_t;

typedef struct aas_export_s
{
	//-----------------------------------
	// be_aas_entity.h
	//-----------------------------------
	void		(*AAS_EntityInfo)(int entnum, struct aas_entityinfo_s *info);
	//-----------------------------------
	// be_aas_main.h
	//-----------------------------------
	int			(*AAS_Initialized)(void);
	void		(*AAS_PresenceTypeBoundingBox)(int presencetype, vec3_t mins, vec3_t maxs);
	float		(*AAS_Time)(void);
	//--------------------------------------------
	// be_aas_sample.c
	//--------------------------------------------
	int			(*AAS_PointAreaNum)(vec3_t point);
	int			(*AAS_PointReachabilityAreaIndex)( vec3_t point );
	int			(*AAS_TraceAreas)(vec3_t start, vec3_t end, int *areas, vec3_t *points, int maxareas);
	int			(*AAS_BBoxAreas)(vec3_t absmins, vec3_t absmaxs, int *areas, int maxareas);
	int			(*AAS_AreaInfo)( int areanum, struct aas_areainfo_s *info );
	//--------------------------------------------
	// be_aas_bspq3.c
	//--------------------------------------------
	int			(*AAS_PointContents)(vec3_t point);
	int			(*AAS_NextBSPEntity)(int ent);
	int			(*AAS_ValueForBSPEpairKey)(int ent, char *key, char *value, int size);
	int			(*AAS_VectorForBSPEpairKey)(int ent, char *key, vec3_t v);
	int			(*AAS_FloatForBSPEpairKey)(int ent, char *key, float *value);
	int			(*AAS_IntForBSPEpairKey)(int ent, char *key, int *value);
	//--------------------------------------------
	// be_aas_reach.c
	//--------------------------------------------
	int			(*AAS_AreaReachability)(int areanum);
	//--------------------------------------------
	// be_aas_route.c
	//--------------------------------------------
	int			(*AAS_AreaTravelTimeToGoalArea)(int areanum, vec3_t origin, int goalareanum, int travelflags);
	int			(*AAS_EnableRoutingArea)(int areanum, int enable);
	int			(*AAS_PredictRoute)(struct aas_predictroute_s *route, int areanum, vec3_t origin,
							int goalareanum, int travelflags, int maxareas, int maxtime,
							int stopevent, int stopcontents, int stoptfl, int stopareanum);
	//--------------------------------------------
	// be_aas_altroute.c
	//--------------------------------------------
	int			(*AAS_AlternativeRouteGoals)(vec3_t start, int startareanum, vec3_t goal, int goalareanum, int travelflags,
										struct aas_altroutegoal_s *altroutegoals, int maxaltroutegoals,
										int type);
	//--------------------------------------------
	// be_aas_move.c
	//--------------------------------------------
	int			(*AAS_Swimming)(vec3_t origin);
	int			(*AAS_PredictClientMovement)(struct aas_clientmove_s *move,
											int entnum, vec3_t origin,
											int presencetype, int onground,
											vec3_t velocity, vec3_t cmdmove,
											int cmdframes,
											int maxframes, float frametime,
											int stopevent, int stopareanum, int visualize);
} aas_export_t;

typedef struct ea_export_s
{
	//ClientCommand elementary actions
	void	(*EA_Command)(int client, char *command );
	void	(*EA_Say)(int client, char *str);
	void	(*EA_SayTeam)(int client, char *str);
	//
	void	(*EA_Action)(int client, int action);
	void	(*EA_Gesture)(int client);
	void	(*EA_Talk)(int client);
	void	(*EA_Attack)(int client);
	void	(*EA_Use)(int client);
	void	(*EA_Respawn)(int client);
	void	(*EA_MoveUp)(int client);
	void	(*EA_MoveDown)(int client);
	void	(*EA_MoveForward)(int client);
	void	(*EA_MoveBack)(int client);
	void	(*EA_MoveLeft)(int client);
	void	(*EA_MoveRight)(int client);
	void	(*EA_Crouch)(int client);
	void	(*EA_Alt_Attack)(int client);
	void	(*EA_ForcePower)(int client);

	void	(*EA_SelectWeapon)(int client, int weapon);
	void	(*EA_Jump)(int client);
	void	(*EA_DelayedJump)(int client);
	void	(*EA_Move)(int client, vec3_t dir, float speed);
	void	(*EA_View)(int client, vec3_t viewangles);
	//send regular input to the server
	void	(*EA_EndRegular)(int client, float thinktime);
	void	(*EA_GetInput)(int client, float thinktime, bot_input_t *input);
	void	(*EA_ResetInput)(int client);
} ea_export_t;

typedef struct ai_export_s
{
	//-----------------------------------
	// be_ai_char.h
	//-----------------------------------
	int		(*BotLoadCharacter)(char *charfile, float skill);
	void	(*BotFreeCharacter)(int character);
	float	(*Characteristic_Float)(int character, int index);
	float	(*Characteristic_BFloat)(int character, int index, float min, float max);
	int		(*Characteristic_Integer)(int character, int index);
	int		(*Characteristic_BInteger)(int character, int index, int min, int max);
	void	(*Characteristic_String)(int character, int index, char *buf, int size);
	//-----------------------------------
	// be_ai_chat.h
	//-----------------------------------
	int		(*BotAllocChatState)(void);
	void	(*BotFreeChatState)(int handle);
	void	(*BotQueueConsoleMessage)(int chatstate, int type, char *message);
	void	(*BotRemoveConsoleMessage)(int chatstate, int handle);
	int		(*BotNextConsoleMessage)(int chatstate, struct bot_consolemessage_s *cm);
	int		(*BotNumConsoleMessages)(int chatstate);
	void	(*BotInitialChat)(int chatstate, char *type, int mcontext, char *var0, char *var1, char *var2, char *var3, char *var4, char *var5, char *var6, char *var7);
	int		(*BotNumInitialChats)(int chatstate, char *type);
	int		(*BotReplyChat)(int chatstate, char *message, int mcontext, int vcontext, char *var0, char *var1, char *var2, char *var3, char *var4, char *var5, char *var6, char *var7);
	int		(*BotChatLength)(int chatstate);
	void	(*BotEnterChat)(int chatstate, int client, int sendto);
	void	(*BotGetChatMessage)(int chatstate, char *buf, int size);
	int		(*StringContains)(char *str1, char *str2, int casesensitive);
	int		(*BotFindMatch)(char *str, struct bot_match_s *match, unsigned long int context);
	void	(*BotMatchVariable)(struct bot_match_s *match, int variable, char *buf, int size);
	void	(*UnifyWhiteSpaces)(char *string);
	void	(*BotReplaceSynonyms)(char *string, unsigned long int context);
	int		(*BotLoadChatFile)(int chatstate, char *chatfile, char *chatname);
	void	(*BotSetChatGender)(int chatstate, int gender);
	void	(*BotSetChatName)(int chatstate, char *name, int client);
	//-----------------------------------
	// be_ai_goal.h
	//-----------------------------------
	void	(*BotResetGoalState)(int goalstate);
	void	(*BotResetAvoidGoals)(int goalstate);
	void	(*BotRemoveFromAvoidGoals)(int goalstate, int number);
	void	(*BotPushGoal)(int goalstate, struct bot_goal_s *goal);
	void	(*BotPopGoal)(int goalstate);
	void	(*BotEmptyGoalStack)(int goalstate);
	void	(*BotDumpAvoidGoals)(int goalstate);
	void	(*BotDumpGoalStack)(int goalstate);
	void	(*BotGoalName)(int number, char *name, int size);
	int		(*BotGetTopGoal)(int goalstate, struct bot_goal_s *goal);
	int		(*BotGetSecondGoal)(int goalstate, struct bot_goal_s *goal);
	int		(*BotChooseLTGItem)(int goalstate, vec3_t origin, int *inventory, int travelflags);
	int		(*BotChooseNBGItem)(int goalstate, vec3_t origin, int *inventory, int travelflags,
								struct bot_goal_s *ltg, float maxtime);
	int		(*BotTouchingGoal)(vec3_t origin, struct bot_goal_s *goal);
	int		(*BotItemGoalInVisButNotVisible)(int viewer, vec3_t eye, vec3_t viewangles, struct bot_goal_s *goal);
	int		(*BotGetLevelItemGoal)(int index, char *classname, struct bot_goal_s *goal);
	int		(*BotGetNextCampSpotGoal)(int num, struct bot_goal_s *goal);
	int		(*BotGetMapLocationGoal)(char *name, struct bot_goal_s *goal);
	float	(*BotAvoidGoalTime)(int goalstate, int number);
	void	(*BotSetAvoidGoalTime)(int goalstate, int number, float avoidtime);
	void	(*BotInitLevelItems)(void);
	void	(*BotUpdateEntityItems)(void);
	int		(*BotLoadItemWeights)(int goalstate, char *filename);
	void	(*BotFreeItemWeights)(int goalstate);
	void	(*BotInterbreedGoalFuzzyLogic)(int parent1, int parent2, int child);
	void	(*BotSaveGoalFuzzyLogic)(int goalstate, char *filename);
	void	(*BotMutateGoalFuzzyLogic)(int goalstate, float range);
	int		(*BotAllocGoalState)(int client);
	void	(*BotFreeGoalState)(int handle);
	//-----------------------------------
	// be_ai_move.h
	//-----------------------------------
	void	(*BotResetMoveState)(int movestate);
	void	(*BotMoveToGoal)(struct bot_moveresult_s *result, int movestate, struct bot_goal_s *goal, int travelflags);
	int		(*BotMoveInDirection)(int movestate, vec3_t dir, float speed, int type);
	void	(*BotResetAvoidReach)(int movestate);
	void	(*BotResetLastAvoidReach)(int movestate);
	int		(*BotReachabilityArea)(vec3_t origin, int testground);
	int		(*BotMovementViewTarget)(int movestate, struct bot_goal_s *goal, int travelflags, float lookahead, vec3_t target);
	int		(*BotPredictVisiblePosition)(vec3_t origin, int areanum, struct bot_goal_s *goal, int travelflags, vec3_t target);
	int		(*BotAllocMoveState)(void);
	void	(*BotFreeMoveState)(int handle);
	void	(*BotInitMoveState)(int handle, struct bot_initmove_s *initmove);
	void	(*BotAddAvoidSpot)(int movestate, vec3_t origin, float radius, int type);
	//-----------------------------------
	// be_ai_weap.h
	//-----------------------------------
	int		(*BotChooseBestFightWeapon)(int weaponstate, int *inventory);
	void	(*BotGetWeaponInfo)(int weaponstate, int weapon, struct weaponinfo_s *weaponinfo);
	int		(*BotLoadWeaponWeights)(int weaponstate, char *filename);
	int		(*BotAllocWeaponState)(void);
	void	(*BotFreeWeaponState)(int weaponstate);
	void	(*BotResetWeaponState)(int weaponstate);
	//-----------------------------------
	// be_ai_gen.h
	//-----------------------------------
	int		(*GeneticParentsAndChildSelection)(int numranks, float *ranks, int *parent1, int *parent2, int *child);
} ai_export_t;

//bot AI library imported functions
typedef struct botlib_export_s
{
	//Area Awareness System functions
	aas_export_t aas;
	//Elementary Action functions
	ea_export_t ea;
	//AI functions
	ai_export_t ai;
	//setup the bot library, returns BLERR_
	int (*BotLibSetup)(void);
	//shutdown the bot library, returns BLERR_
	int (*BotLibShutdown)(void);
	//sets a library variable returns BLERR_
	int (*BotLibVarSet)(char *var_name, char *value);
	//gets a library variable returns BLERR_
	int (*BotLibVarGet)(char *var_name, char *value, int size);

	//sets a C-like define returns BLERR_
	int (*PC_AddGlobalDefine)(char *string);
	int (*PC_LoadSourceHandle)(const char *filename);
	int (*PC_FreeSourceHandle)(int handle);
	int (*PC_ReadTokenHandle)(int handle, pc_token_t *pc_token);
	int (*PC_SourceFileAndLine)(int handle, char *filename, int *line);
	int (*PC_LoadGlobalDefines)(const char* filename );
	void (*PC_RemoveAllGlobalDefines) ( void );

	//start a frame in the bot library
	int (*BotLibStartFrame)(float time);
	//load a new map in the bot library
	int (*BotLibLoadMap)(const char *mapname);
	//entity updates
	int (*BotLibUpdateEntity)(int ent, bot_entitystate_t *state);
	//just for testing
	int (*Test)(int parm0, char *parm1, vec3_t parm2, vec3_t parm3);
} botlib_export_t;

// The botlib records of its own headers, its .cpp files, and the game headers it reads, rows D1 to D5 of the ninth batch.
// Source: oracle/codemp/game/botlib.h:30
#define BOTFILESBASEFOLDER		"botfiles"
//debug line colors
#define LINECOLOR_NONE			-1
#define LINECOLOR_RED			1//0xf2f2f0f0L
#define LINECOLOR_GREEN			2//0xd0d1d2d3L
#define LINECOLOR_BLUE			3//0xf3f3f1f1L
#define LINECOLOR_YELLOW		4//0xdcdddedfL
#define LINECOLOR_ORANGE		5//0xe0e1e2e3L

// Source: oracle/codemp/game/botlib.h:46
//console message types
#define CMS_NORMAL				0
#define CMS_CHAT				1

//botlib error codes
#define BLERR_NOERROR					0	//no error
#define BLERR_LIBRARYNOTSETUP			1	//library not setup
#define BLERR_INVALIDENTITYNUMBER		2	//invalid entity number
#define BLERR_NOAASFILE					3	//no AAS file available
#define BLERR_CANNOTOPENAASFILE			4	//cannot open AAS file
#define BLERR_WRONGAASFILEID			5	//incorrect AAS file id
#define BLERR_WRONGAASFILEVERSION		6	//incorrect AAS file version
#define BLERR_CANNOTREADAASLUMP			7	//cannot read AAS file lump
#define BLERR_CANNOTLOADICHAT			8	//cannot load initial chats
#define BLERR_CANNOTLOADITEMWEIGHTS		9	//cannot load item weights
#define BLERR_CANNOTLOADITEMCONFIG		10	//cannot load item config
#define BLERR_CANNOTLOADWEAPONWEIGHTS	11	//cannot load weapon weights
#define BLERR_CANNOTLOADWEAPONCONFIG	12	//cannot load weapon config

//action flags
#define ACTION_ATTACK			0x0000001
#define ACTION_USE				0x0000002
#define ACTION_RESPAWN			0x0000008
#define ACTION_JUMP				0x0000010
#define ACTION_MOVEUP			0x0000020
#define ACTION_CROUCH			0x0000080
#define ACTION_MOVEDOWN			0x0000100
#define ACTION_MOVEFORWARD		0x0000200
#define ACTION_MOVEBACK			0x0000800
#define ACTION_MOVELEFT			0x0001000
#define ACTION_MOVERIGHT		0x0002000
#define ACTION_DELAYEDJUMP		0x0008000
#define ACTION_TALK				0x0010000
#define ACTION_GESTURE			0x0020000
#define ACTION_WALK				0x0080000
#define ACTION_FORCEPOWER		0x0100000
#define ACTION_ALT_ATTACK		0x0200000
/*
#define ACTION_AFFIRMATIVE		0x0100000
#define ACTION_NEGATIVE			0x0200000
#define ACTION_GETFLAG			0x0800000
#define ACTION_GUARDBASE		0x1000000
#define ACTION_PATROL			0x2000000
#define ACTION_FOLLOWME			0x8000000
*/

// Source: oracle/codemp/game/be_aas.h:17
#ifndef MAX_STRINGFIELD
#define MAX_STRINGFIELD				80
#endif

//travel flags
#define TFL_INVALID				0x00000001	//traveling temporary not possible
#define TFL_WALK				0x00000002	//walking
#define TFL_CROUCH				0x00000004	//crouching
#define TFL_BARRIERJUMP			0x00000008	//jumping onto a barrier
#define TFL_JUMP				0x00000010	//jumping
#define TFL_LADDER				0x00000020	//climbing a ladder
#define TFL_WALKOFFLEDGE		0x00000080	//walking of a ledge
#define TFL_SWIM				0x00000100	//swimming
#define TFL_WATERJUMP			0x00000200	//jumping out of the water
#define TFL_TELEPORT			0x00000400	//teleporting
#define TFL_ELEVATOR			0x00000800	//elevator
#define TFL_ROCKETJUMP			0x00001000	//rocket jumping
#define TFL_BFGJUMP				0x00002000	//bfg jumping
#define TFL_GRAPPLEHOOK			0x00004000	//grappling hook
#define TFL_DOUBLEJUMP			0x00008000	//double jump
#define TFL_RAMPJUMP			0x00010000	//ramp jump
#define TFL_STRAFEJUMP			0x00020000	//strafe jump
#define TFL_JUMPPAD				0x00040000	//jump pad
#define TFL_AIR					0x00080000	//travel through air
#define TFL_WATER				0x00100000	//travel through water
#define TFL_SLIME				0x00200000	//travel through slime
#define TFL_LAVA				0x00400000	//travel through lava
#define TFL_DONOTENTER			0x00800000	//travel through donotenter area
#define TFL_FUNCBOB				0x01000000	//func bobbing
#define TFL_FLIGHT				0x02000000	//flight
#define TFL_BRIDGE				0x04000000	//move over a bridge
//
#define TFL_NOTTEAM1			0x08000000	//not team 1
#define TFL_NOTTEAM2			0x10000000	//not team 2

//default travel flags
#define TFL_DEFAULT	TFL_WALK|TFL_CROUCH|TFL_BARRIERJUMP|\
	TFL_JUMP|TFL_LADDER|\
	TFL_WALKOFFLEDGE|TFL_SWIM|TFL_WATERJUMP|\
	TFL_TELEPORT|TFL_ELEVATOR|\
	TFL_AIR|TFL_WATER|TFL_JUMPPAD|TFL_FUNCBOB

typedef enum
{
	SOLID_NOT,			// no interaction with other objects
	SOLID_TRIGGER,		// only touch when inside, after moving
	SOLID_BBOX,			// touch on edge
	SOLID_BSP			// bsp clip, touch on edge
} solid_t;

//a trace is returned when a box is swept through the AAS world
typedef struct aas_trace_s
{
	qboolean	startsolid;	// if true, the initial point was in a solid area
	float		fraction;	// time completed, 1.0 = didn't hit anything
	vec3_t		endpos;		// final position
	int			ent;		// entity blocking the trace
	int			lastarea;	// last area the trace was in (zero if none)
	int			area;		// area blocking the trace (zero if none)
	int			planenum;	// number of the plane that was hit
} aas_trace_t;

/* Defined in botlib.h

//bsp_trace_t hit surface
typedef struct bsp_surface_s
{
	char name[16];
	int flags;
	int value;
} bsp_surface_t;

//a trace is returned when a box is swept through the BSP world
typedef struct bsp_trace_s
{
	qboolean		allsolid;	// if true, plane is not valid
	qboolean		startsolid;	// if true, the initial point was in a solid area
	float			fraction;	// time completed, 1.0 = didn't hit anything
	vec3_t			endpos;		// final position
	cplane_t		plane;		// surface normal at impact
	float			exp_dist;	// expanded plane distance
	int				sidenum;	// number of the brush side hit
	bsp_surface_t	surface;	// hit surface
	int				contents;	// contents on other side of surface hit
	int				ent;		// number of entity hit
} bsp_trace_t;
//
*/

//entity info
typedef struct aas_entityinfo_s
{
	int		valid;			// true if updated this frame
	int		type;			// entity type
	int		flags;			// entity flags
	float	ltime;			// local time
	float	update_time;	// time between last and current update
	int		number;			// number of the entity
	vec3_t	origin;			// origin of the entity
	vec3_t	angles;			// angles of the model
	vec3_t	old_origin;		// for lerping
	vec3_t	lastvisorigin;	// last visible origin
	vec3_t	mins;			// bounding box minimums
	vec3_t	maxs;			// bounding box maximums
	int		groundent;		// ground entity
	int		solid;			// solid type
	int		modelindex;		// model used
	int		modelindex2;	// weapons, CTF flags, etc
	int		frame;			// model frame number
	int		event;			// impulse events -- muzzle flashes, footsteps, etc
	int		eventParm;		// even parameter
	int		powerups;		// bit flags
	int		weapon;			// determines weapon and flash model, etc
	int		legsAnim;		// current legs anim
	int		torsoAnim;		// current torso anim
} aas_entityinfo_t;

// area info
typedef struct aas_areainfo_s
{
	int contents;
	int flags;
	int presencetype;
	int cluster;
	vec3_t mins;
	vec3_t maxs;
	vec3_t center;
} aas_areainfo_t;

// client movement prediction stop events, stop as soon as:
// SE_NONE of be_aas.h:147 is 0, the value of the SE_NONE enumerator of sysEventType_t in CJKAMP_Ded, so the copy leaves it out.
#define SE_HITGROUND			1		// the ground is hit
#define SE_LEAVEGROUND			2		// there's no ground
#define SE_ENTERWATER			4		// water is entered
#define SE_ENTERSLIME			8		// slime is entered
#define SE_ENTERLAVA			16		// lava is entered
#define SE_HITGROUNDDAMAGE		32		// the ground is hit with damage
#define SE_GAP					64		// there's a gap
#define SE_TOUCHJUMPPAD			128		// touching a jump pad area
#define SE_TOUCHTELEPORTER		256		// touching teleporter
#define SE_ENTERAREA			512		// the given stoparea is entered
#define SE_HITGROUNDAREA		1024	// a ground face in the area is hit
#define SE_HITBOUNDINGBOX		2048	// hit the specified bounding box
#define SE_TOUCHCLUSTERPORTAL	4096	// touching a cluster portal

typedef struct aas_clientmove_s
{
	vec3_t endpos;			//position at the end of movement prediction
	int endarea;			//area at end of movement prediction
	vec3_t velocity;		//velocity at the end of movement prediction
	aas_trace_t trace;		//last trace
	int presencetype;		//presence type at end of movement prediction
	int stopevent;			//event that made the prediction stop
	int endcontents;		//contents at the end of movement prediction
	float time;				//time predicted ahead
	int frames;				//number of frames predicted ahead
} aas_clientmove_t;

// alternate route goals
#define ALTROUTEGOAL_ALL				1
#define ALTROUTEGOAL_CLUSTERPORTALS		2
#define ALTROUTEGOAL_VIEWPORTALS		4

typedef struct aas_altroutegoal_s
{
	vec3_t origin;
	int areanum;
	unsigned short starttraveltime;
	unsigned short goaltraveltime;
	unsigned short extratraveltime;
} aas_altroutegoal_t;

// route prediction stop events
#define RSE_NONE				0
#define RSE_NOROUTE				1	//no route to goal
#define RSE_USETRAVELTYPE		2	//stop as soon as on of the given travel types is used
#define RSE_ENTERCONTENTS		4	//stop when entering the given contents
#define RSE_ENTERAREA			8	//stop when entering the given area

typedef struct aas_predictroute_s
{
	vec3_t endpos;			//position at the end of movement prediction
	int endarea;			//area at end of movement prediction
	int stopevent;			//event that made the prediction stop
	int endcontents;		//contents at the end of movement prediction
	int endtravelflags;		//end travel flags
	int numareas;			//number of areas predicted ahead
	int time;				//time predicted ahead (in hundreth of a sec)
} aas_predictroute_t;

// Source: oracle/codemp/game/be_ai_goal.h:16
#define MAX_AVOIDGOALS			256
#define MAX_GOALSTACK			8

#define GFL_NONE				0
#define GFL_ITEM				1
#define GFL_ROAM				2
#define GFL_DROPPED				4

//a bot goal
typedef struct bot_goal_s
{
	vec3_t origin;				//origin of the goal
	int areanum;				//area number of the goal
	vec3_t mins, maxs;			//mins and maxs of the goal
	int entitynum;				//number of the goal entity
	int number;					//goal number
	int flags;					//goal flags
	int iteminfo;				//item information
} bot_goal_t;

// Source: oracle/codemp/game/be_ai_move.h:18
#define MOVE_WALK						1
#define MOVE_CROUCH						2
#define MOVE_JUMP						4
#define MOVE_GRAPPLE					8
#define MOVE_ROCKETJUMP					16
#define MOVE_BFGJUMP					32
//move flags
#define MFL_BARRIERJUMP					1		//bot is performing a barrier jump
#define MFL_ONGROUND					2		//bot is in the ground
#define MFL_SWIMMING					4		//bot is swimming
#define MFL_AGAINSTLADDER				8		//bot is against a ladder
#define MFL_WATERJUMP					16		//bot is waterjumping
#define MFL_TELEPORTED					32		//bot is being teleported
#define MFL_GRAPPLEPULL					64		//bot is being pulled by the grapple
#define MFL_ACTIVEGRAPPLE				128		//bot is using the grapple hook
#define MFL_GRAPPLERESET				256		//bot has reset the grapple
#define MFL_WALK						512		//bot should walk slowly
// move result flags
#define MOVERESULT_MOVEMENTVIEW			1		//bot uses view for movement
#define MOVERESULT_SWIMVIEW				2		//bot uses view for swimming
#define MOVERESULT_WAITING				4		//bot is waiting for something
#define MOVERESULT_MOVEMENTVIEWSET		8		//bot has set the view in movement code
#define MOVERESULT_MOVEMENTWEAPON		16		//bot uses weapon for movement
#define MOVERESULT_ONTOPOFOBSTACLE		32		//bot is ontop of obstacle
#define MOVERESULT_ONTOPOF_FUNCBOB		64		//bot is ontop of a func_bobbing
#define MOVERESULT_ONTOPOF_ELEVATOR		128		//bot is ontop of an elevator (func_plat)
#define MOVERESULT_BLOCKEDBYAVOIDSPOT	256		//bot is blocked by an avoid spot
//
#define MAX_AVOIDREACH					1
#define MAX_AVOIDSPOTS					32
// avoid spot types
#define AVOID_CLEAR						0		//clear all avoid spots
#define AVOID_ALWAYS					1		//avoid always
#define AVOID_DONTBLOCK					2		//never totally block
// restult types
#define RESULTTYPE_ELEVATORUP			1		//elevator is up
#define RESULTTYPE_WAITFORFUNCBOBBING	2		//waiting for func bobbing to arrive
#define RESULTTYPE_BADGRAPPLEPATH		4		//grapple path is obstructed
#define RESULTTYPE_INSOLIDAREA			8		//stuck in solid area, this is bad

//structure used to initialize the movement state
//the or_moveflags MFL_ONGROUND, MFL_TELEPORTED and MFL_WATERJUMP come from the playerstate
typedef struct bot_initmove_s
{
	vec3_t origin;				//origin of the bot
	vec3_t velocity;			//velocity of the bot
	vec3_t viewoffset;			//view offset
	int entitynum;				//entity number of the bot
	int client;					//client number of the bot
	float thinktime;			//time the bot thinks
	int presencetype;			//presencetype of the bot
	vec3_t viewangles;			//view angles of the bot
	int or_moveflags;			//values ored to the movement flags
} bot_initmove_t;

//NOTE: the ideal_viewangles are only valid if MFL_MOVEMENTVIEW is set
typedef struct bot_moveresult_s
{
	int failure;				//true if movement failed all together
	int type;					//failure or blocked type
	int blocked;				//true if blocked by an entity
	int blockentity;			//entity blocking the bot
	int traveltype;				//last executed travel type
	int flags;					//result flags
	int weapon;					//weapon used for movement
	vec3_t movedir;				//movement direction
	vec3_t ideal_viewangles;	//ideal viewangles for the movement
} bot_moveresult_t;

// bk001204: from code/botlib/be_ai_move.c
// TTimo 04/12/2001 was moved here to avoid dup defines
typedef struct bot_avoidspot_s
{
	vec3_t origin;
	float radius;
	int type;
} bot_avoidspot_t;

// Source: oracle/codemp/game/be_ai_chat.h:16
#define MAX_MESSAGE_SIZE		256
#define MAX_CHATTYPE_NAME		32
#define MAX_MATCHVARIABLES		8

#define CHAT_GENDERLESS			0
#define CHAT_GENDERFEMALE		1
#define CHAT_GENDERMALE			2

#define CHAT_ALL					0
#define CHAT_TEAM					1
#define CHAT_TELL					2

//a console message
typedef struct bot_consolemessage_s
{
	int handle;
	float time;									//message time
	int type;									//message type
	char message[MAX_MESSAGE_SIZE];				//message
	struct bot_consolemessage_s *prev, *next;	//prev and next in list
} bot_consolemessage_t;

//match variable
typedef struct bot_matchvariable_s
{
	char offset;
	int length;
} bot_matchvariable_t;
//returned to AI when a match is found
typedef struct bot_match_s
{
	char string[MAX_MESSAGE_SIZE];
	int type;
	int subtype;
	bot_matchvariable_t variables[MAX_MATCHVARIABLES];
} bot_match_t;

// Source: oracle/codemp/game/be_ai_weap.h:18
#define PFL_WINDOWDAMAGE			1		//projectile damages through window
#define PFL_RETURN					2		//set when projectile returns to owner
//weapon flags
#define WFL_FIRERELEASED			1		//set when projectile is fired with key-up event
//damage types
#define DAMAGETYPE_IMPACT			1		//damage on impact
#define DAMAGETYPE_RADIAL			2		//radial damage
#define DAMAGETYPE_VISIBLE			4		//damage to all entities visible to the projectile

typedef struct projectileinfo_s
{
	char name[MAX_STRINGFIELD];
	char model[MAX_STRINGFIELD];
	int flags;
	float gravity;
	int damage;
	float radius;
	int visdamage;
	int damagetype;
	int healthinc;
	float push;
	float detonation;
	float bounce;
	float bouncefric;
	float bouncestop;
} projectileinfo_t;

typedef struct weaponinfo_s
{
	int valid;					//true if the weapon info is valid
	int number;									//number of the weapon
	char name[MAX_STRINGFIELD];
	char model[MAX_STRINGFIELD];
	int level;
	int weaponindex;
	int flags;
	char projectile[MAX_STRINGFIELD];
	int numprojectiles;
	float hspread;
	float vspread;
	float speed;
	float acceleration;
	vec3_t recoil;
	vec3_t offset;
	vec3_t angleoffset;
	float extrazvelocity;
	int ammoamount;
	int ammoindex;
	float activate;
	float reload;
	float spinup;
	float spindown;
	projectileinfo_t proj;						//pointer to the used projectile
} weaponinfo_t;

// Source: oracle/codemp/botlib/aasfile.h:6
#define AASID						(('S'<<24)+('A'<<16)+('A'<<8)+'E')
#define AASVERSION_OLD				4
#define AASVERSION					5

//presence types
#define PRESENCE_NONE				1
#define PRESENCE_NORMAL				2
#define PRESENCE_CROUCH				4

//travel types
#define MAX_TRAVELTYPES				32
#define TRAVEL_INVALID				1		//temporary not possible
#define TRAVEL_WALK					2		//walking
#define TRAVEL_CROUCH				3		//crouching
#define TRAVEL_BARRIERJUMP			4		//jumping onto a barrier
#define TRAVEL_JUMP					5		//jumping
#define TRAVEL_LADDER				6		//climbing a ladder
#define TRAVEL_WALKOFFLEDGE			7		//walking of a ledge
#define TRAVEL_SWIM					8		//swimming
#define TRAVEL_WATERJUMP			9		//jump out of the water
#define TRAVEL_TELEPORT				10		//teleportation
#define TRAVEL_ELEVATOR				11		//travel by elevator
#define TRAVEL_ROCKETJUMP			12		//rocket jumping required for travel
#define TRAVEL_BFGJUMP				13		//bfg jumping required for travel
#define TRAVEL_GRAPPLEHOOK			14		//grappling hook required for travel
#define TRAVEL_DOUBLEJUMP			15		//double jump
#define TRAVEL_RAMPJUMP				16		//ramp jump
#define TRAVEL_STRAFEJUMP			17		//strafe jump
#define TRAVEL_JUMPPAD				18		//jump pad
#define TRAVEL_FUNCBOB				19		//func bob

//additional travel flags
#define TRAVELTYPE_MASK				0xFFFFFF
#define TRAVELFLAG_NOTTEAM1			(1 << 24)
#define TRAVELFLAG_NOTTEAM2			(2 << 24)

//face flags
#define FACE_SOLID					1		//just solid at the other side
#define FACE_LADDER					2		//ladder
#define FACE_GROUND					4		//standing on ground when in this face
#define FACE_GAP					8		//gap in the ground
#define FACE_LIQUID					16		//face seperating two areas with liquid
#define FACE_LIQUIDSURFACE			32		//face seperating liquid and air
#define FACE_BRIDGE					64		//can walk over this face if bridge is closed

//area contents
#define AREACONTENTS_WATER				1
#define AREACONTENTS_LAVA				2
#define AREACONTENTS_SLIME				4
#define AREACONTENTS_CLUSTERPORTAL		8
#define AREACONTENTS_TELEPORTAL			16
#define AREACONTENTS_ROUTEPORTAL		32
#define AREACONTENTS_TELEPORTER			64
#define AREACONTENTS_JUMPPAD			128
#define AREACONTENTS_DONOTENTER			256
#define	AREACONTENTS_VIEWPORTAL			512
#define AREACONTENTS_MOVER				1024
#define AREACONTENTS_NOTTEAM1			2048
#define AREACONTENTS_NOTTEAM2			4096
//number of model of the mover inside this area
#define AREACONTENTS_MODELNUMSHIFT		24
#define AREACONTENTS_MAXMODELNUM		0xFF
#define AREACONTENTS_MODELNUM			(AREACONTENTS_MAXMODELNUM << AREACONTENTS_MODELNUMSHIFT)

//area flags
#define AREA_GROUNDED				1		//bot can stand on the ground
#define AREA_LADDER					2		//area contains one or more ladder faces
#define AREA_LIQUID					4		//area contains a liquid
#define AREA_DISABLED				8		//area is disabled for routing when set
#define AREA_BRIDGE					16		//area ontop of a bridge

//aas file header lumps
#define AAS_LUMPS					14
#define AASLUMP_BBOXES				0
#define AASLUMP_VERTEXES			1
#define AASLUMP_PLANES				2
#define AASLUMP_EDGES				3
#define AASLUMP_EDGEINDEX			4
#define AASLUMP_FACES				5
#define AASLUMP_FACEINDEX			6
#define AASLUMP_AREAS				7
#define AASLUMP_AREASETTINGS		8
#define AASLUMP_REACHABILITY		9
#define AASLUMP_NODES				10
#define AASLUMP_PORTALS				11
#define AASLUMP_PORTALINDEX			12
#define AASLUMP_CLUSTERS			13

//========== bounding box =========

//bounding box
typedef struct aas_bbox_s
{
	int presencetype;
	int flags;
	vec3_t mins, maxs;
} aas_bbox_t;

//============ settings ===========

//reachability to another area
typedef struct aas_reachability_s
{
	int areanum;						//number of the reachable area
	int facenum;						//number of the face towards the other area
	int edgenum;						//number of the edge towards the other area
	vec3_t start;						//start point of inter area movement
	vec3_t end;							//end point of inter area movement
	int traveltype;					//type of travel required to get to the area
	unsigned short int traveltime;//travel time of the inter area movement
} aas_reachability_t;

//area settings
typedef struct aas_areasettings_s
{
	//could also add all kind of statistic fields
	int contents;						//contents of the area
	int areaflags;						//several area flags
	int presencetype;					//how a bot can be present in this area
	int cluster;						//cluster the area belongs to, if negative it's a portal
	int clusterareanum;				//number of the area in the cluster
	int numreachableareas;			//number of reachable areas from this one
	int firstreachablearea;			//first reachable area in the reachable area index
} aas_areasettings_t;

//cluster portal
typedef struct aas_portal_s
{
	int areanum;						//area that is the actual portal
	int frontcluster;					//cluster at front of portal
	int backcluster;					//cluster at back of portal
	int clusterareanum[2];			//number of the area in the front and back cluster
} aas_portal_t;

//cluster portal index
typedef int aas_portalindex_t;

//cluster
typedef struct aas_cluster_s
{
	int numareas;						//number of areas in the cluster
	int numreachabilityareas;			//number of areas with reachabilities
	int numportals;						//number of cluster portals
	int firstportal;					//first cluster portal in the index
} aas_cluster_t;

//============ 3d definition ============

typedef vec3_t aas_vertex_t;

//just a plane in the third dimension
typedef struct aas_plane_s
{
	vec3_t normal;						//normal vector of the plane
	float dist;							//distance of the plane (normal vector * distance = point in plane)
	int type;
} aas_plane_t;

//edge
typedef struct aas_edge_s
{
	int v[2];							//numbers of the vertexes of this edge
} aas_edge_t;

//edge index, negative if vertexes are reversed
typedef int aas_edgeindex_t;

//a face bounds an area, often it will also seperate two areas
typedef struct aas_face_s
{
	int planenum;						//number of the plane this face is in
	int faceflags;						//face flags (no use to create face settings for just this field)
	int numedges;						//number of edges in the boundary of the face
	int firstedge;						//first edge in the edge index
	int frontarea;						//area at the front of this face
	int backarea;						//area at the back of this face
} aas_face_t;

//face index, stores a negative index if backside of face
typedef int aas_faceindex_t;

//area with a boundary of faces
typedef struct aas_area_s
{
	int areanum;						//number of this area
	//3d definition
	int numfaces;						//number of faces used for the boundary of the area
	int firstface;						//first face in the face index used for the boundary of the area
	vec3_t mins;						//mins of the area
	vec3_t maxs;						//maxs of the area
	vec3_t center;						//'center' of the area
} aas_area_t;

//nodes of the bsp tree
typedef struct aas_node_s
{
	int planenum;
	int children[2];					//child nodes of this node, or areas as leaves when negative
										//when a child is zero it's a solid leaf
} aas_node_t;

//=========== aas file ===============

//header lump
typedef struct
{
	int fileofs;
	int filelen;
} aas_lump_t;

//aas file header
typedef struct aas_header_s
{
	int ident;
	int version;
	int bspchecksum;
	//data entries
	aas_lump_t lumps[AAS_LUMPS];
} aas_header_t;

// Source: oracle/codemp/botlib/be_aas_bsp.h:41
#define MAX_EPAIRKEY		128

// Source: oracle/codemp/botlib/be_aas_def.h:16
#define AAS_DEBUG


// Source: oracle/codemp/botlib/be_aas_def.h:33
#define DF_AASENTNUMBER(x)		(x - aasworld.entities)
#define DF_NUMBERAASENT(x)		(&aasworld.entities[x])
#define DF_AASENTCLIENT(x)		(x - aasworld.entities - 1)
#define DF_CLIENTAASENT(x)		(&aasworld.entities[x + 1])

#ifndef MAX_PATH
	#define MAX_PATH				MAX_QPATH
#endif

//string index (for model, sound and image index)
typedef struct aas_stringindex_s
{
	int numindexes;
	char **index;
} aas_stringindex_t;

//structure to link entities to areas and areas to entities
typedef struct aas_link_s
{
	int entnum;
	int areanum;
	struct aas_link_s *next_ent, *prev_ent;
	struct aas_link_s *next_area, *prev_area;
} aas_link_t;

//structure to link entities to leaves and leaves to entities
typedef struct bsp_link_s
{
	int entnum;
	int leafnum;
	struct bsp_link_s *next_ent, *prev_ent;
	struct bsp_link_s *next_leaf, *prev_leaf;
} bsp_link_t;

typedef struct bsp_entdata_s
{
	vec3_t origin;
	vec3_t angles;
	vec3_t absmins;
	vec3_t absmaxs;
	int solid;
	int modelnum;
} bsp_entdata_t;

//entity
typedef struct aas_entity_s
{
	//entity info
	aas_entityinfo_t i;
	//links into the AAS areas
	aas_link_t *areas;
	//links into the BSP leaves
	bsp_link_t *leaves;
} aas_entity_t;

typedef struct aas_settings_s
{
	vec3_t phys_gravitydirection;
	float phys_friction;
	float phys_stopspeed;
	float phys_gravity;
	float phys_waterfriction;
	float phys_watergravity;
	float phys_maxvelocity;
	float phys_maxwalkvelocity;
	float phys_maxcrouchvelocity;
	float phys_maxswimvelocity;
	float phys_walkaccelerate;
	float phys_airaccelerate;
	float phys_swimaccelerate;
	float phys_maxstep;
	float phys_maxsteepness;
	float phys_maxwaterjump;
	float phys_maxbarrier;
	float phys_jumpvel;
	float phys_falldelta5;
	float phys_falldelta10;
	float rs_waterjump;
	float rs_teleport;
	float rs_barrierjump;
	float rs_startcrouch;
	float rs_startgrapple;
	float rs_startwalkoffledge;
	float rs_startjump;
	float rs_rocketjump;
	float rs_bfgjump;
	float rs_jumppad;
	float rs_aircontrolledjumppad;
	float rs_funcbob;
	float rs_startelevator;
	float rs_falldamage5;
	float rs_falldamage10;
	float rs_maxfallheight;
	float rs_maxjumpfallheight;
} aas_settings_t;

#define CACHETYPE_PORTAL		0
#define CACHETYPE_AREA			1

//routing cache
typedef struct aas_routingcache_s
{
	byte type;									//portal or area cache
	float time;									//last time accessed or updated
	int size;									//size of the routing cache
	int cluster;								//cluster the cache is for
	int areanum;								//area the cache is created for
	vec3_t origin;								//origin within the area
	float starttraveltime;						//travel time to start with
	int travelflags;							//combinations of the travel flags
	struct aas_routingcache_s *prev, *next;
	struct aas_routingcache_s *time_prev, *time_next;
	unsigned char *reachabilities;				//reachabilities used for routing
	unsigned short int traveltimes[1];			//travel time for every area (variable sized)
} aas_routingcache_t;

//fields for the routing algorithm
typedef struct aas_routingupdate_s
{
	int cluster;
	int areanum;								//area number of the update
	vec3_t start;								//start point the area was entered
	unsigned short int tmptraveltime;			//temporary travel time
	unsigned short int *areatraveltimes;		//travel times within the area
	qboolean inlist;							//true if the update is in the list
	struct aas_routingupdate_s *next;
	struct aas_routingupdate_s *prev;
} aas_routingupdate_t;

//reversed reachability link
typedef struct aas_reversedlink_s
{
	int linknum;								//the aas_areareachability_t
	int areanum;								//reachable from this area
	struct aas_reversedlink_s *next;			//next link
} aas_reversedlink_t;

//reversed area reachability
typedef struct aas_reversedreachability_s
{
	int numlinks;
	aas_reversedlink_t *first;
} aas_reversedreachability_t;

//areas a reachability goes through
typedef struct aas_reachabilityareas_s
{
	int firstarea, numareas;
} aas_reachabilityareas_t;

typedef struct aas_s
{
	int loaded;									//true when an AAS file is loaded
	int initialized;							//true when AAS has been initialized
	int savefile;								//set true when file should be saved
	int bspchecksum;
	//current time
	float time;
	int numframes;
	//name of the aas file
	char filename[MAX_PATH];
	char mapname[MAX_PATH];
	//bounding boxes
	int numbboxes;
	aas_bbox_t *bboxes;
	//vertexes
	int numvertexes;
	aas_vertex_t *vertexes;
	//planes
	int numplanes;
	aas_plane_t *planes;
	//edges
	int numedges;
	aas_edge_t *edges;
	//edge index
	int edgeindexsize;
	aas_edgeindex_t *edgeindex;
	//faces
	int numfaces;
	aas_face_t *faces;
	//face index
	int faceindexsize;
	aas_faceindex_t *faceindex;
	//convex areas
	int numareas;
	aas_area_t *areas;
	//convex area settings
	int numareasettings;
	aas_areasettings_t *areasettings;
	//reachablity list
	int reachabilitysize;
	aas_reachability_t *reachability;
	//nodes of the bsp tree
	int numnodes;
	aas_node_t *nodes;
	//cluster portals
	int numportals;
	aas_portal_t *portals;
	//cluster portal index
	int portalindexsize;
	aas_portalindex_t *portalindex;
	//clusters
	int numclusters;
	aas_cluster_t *clusters;
	//
	int numreachabilityareas;
	float reachabilitytime;
	//enities linked in the areas
	aas_link_t *linkheap;						//heap with link structures
	int linkheapsize;							//size of the link heap
	aas_link_t *freelinks;						//first free link
	aas_link_t **arealinkedentities;			//entities linked into areas
	//entities
	int maxentities;
	int maxclients;
	aas_entity_t *entities;
	//string indexes
	char *configstrings[MAX_CONFIGSTRINGS];
	int indexessetup;
	//index to retrieve travel flag for a travel type
	int travelflagfortype[MAX_TRAVELTYPES];
	//travel flags for each area based on contents
	int *areacontentstravelflags;
	//routing update
	aas_routingupdate_t *areaupdate;
	aas_routingupdate_t *portalupdate;
	//number of routing updates during a frame (reset every frame)
	int frameroutingupdates;
	//reversed reachability links
	aas_reversedreachability_t *reversedreachability;
	//travel times within the areas
	unsigned short ***areatraveltimes;
	//array of size numclusters with cluster cache
	aas_routingcache_t ***clusterareacache;
	aas_routingcache_t **portalcache;
	//cache list sorted on time
	aas_routingcache_t *oldestcache;		// start of cache list sorted on time
	aas_routingcache_t *newestcache;		// end of cache list sorted on time
	//maximum travel time through portal areas
	int *portalmaxtraveltimes;
	//areas the reachabilities go through
	int *reachabilityareaindex;
	aas_reachabilityareas_t *reachabilityareas;
} aas_t;

// Source: oracle/codemp/botlib/l_script.h:16
#define BINARYNUMBERS
//undef if not using the token.intvalue and token.floatvalue
#define NUMBERVALUE
//use dollar sign also as punctuation
#define DOLLAR

//maximum token length
#define MAX_TOKEN					1024

// QDECL of l_script.h:25 to :27 stands only under BSPC, and q_shared.h of CJKAShared defines it.


//script flags
#define SCFL_NOERRORS				0x0001
#define SCFL_NOWARNINGS				0x0002
#define SCFL_NOSTRINGWHITESPACES	0x0004
#define SCFL_NOSTRINGESCAPECHARS	0x0008
#define SCFL_PRIMITIVE				0x0010
#define SCFL_NOBINARYNUMBERS		0x0020
#define SCFL_NONUMBERVALUES		0x0040

//token types
// TT_STRING to TT_PUNCTUATION of l_script.h:36 to :40 have the same values in q_shared.h of CJKAMP, so the copy leaves them out.

//string sub type
//---------------
//		the length of the string
//literal sub type
//----------------
//		the ASCII code of the literal
//number sub type
//---------------
#define TT_DECIMAL					0x0008	// decimal number
#define TT_HEX							0x0100	// hexadecimal number
#define TT_OCTAL						0x0200	// octal number
#ifdef BINARYNUMBERS
#define TT_BINARY						0x0400	// binary number
#endif //BINARYNUMBERS
#define TT_FLOAT						0x0800	// floating point number
#define TT_INTEGER					0x1000	// integer number
#define TT_LONG						0x2000	// long number
#define TT_UNSIGNED					0x4000	// unsigned number
//punctuation sub type
//--------------------
#define P_RSHIFT_ASSIGN				1
#define P_LSHIFT_ASSIGN				2
#define P_PARMS						3
#define P_PRECOMPMERGE				4

#define P_LOGIC_AND					5
#define P_LOGIC_OR					6
#define P_LOGIC_GEQ					7
#define P_LOGIC_LEQ					8
#define P_LOGIC_EQ					9
#define P_LOGIC_UNEQ					10

#define P_MUL_ASSIGN					11
#define P_DIV_ASSIGN					12
#define P_MOD_ASSIGN					13
#define P_ADD_ASSIGN					14
#define P_SUB_ASSIGN					15
#define P_INC							16
#define P_DEC							17

#define P_BIN_AND_ASSIGN			18
#define P_BIN_OR_ASSIGN				19
#define P_BIN_XOR_ASSIGN			20
#define P_RSHIFT						21
#define P_LSHIFT						22

#define P_POINTERREF					23
#define P_CPP1							24
#define P_CPP2							25
#define P_MUL							26
#define P_DIV							27
#define P_MOD							28
#define P_ADD							29
#define P_SUB							30
#define P_ASSIGN						31

#define P_BIN_AND						32
#define P_BIN_OR						33
#define P_BIN_XOR						34
#define P_BIN_NOT						35

#define P_LOGIC_NOT					36
#define P_LOGIC_GREATER				37
#define P_LOGIC_LESS					38

#define P_REF							39
#define P_COMMA						40
#define P_SEMICOLON					41
#define P_COLON						42
#define P_QUESTIONMARK				43

#define P_PARENTHESESOPEN			44
#define P_PARENTHESESCLOSE			45
#define P_BRACEOPEN					46
#define P_BRACECLOSE					47
#define P_SQBRACKETOPEN				48
#define P_SQBRACKETCLOSE			49
#define P_BACKSLASH					50

#define P_PRECOMP						51
#define P_DOLLAR						52
#define	P_ATSIGN						53
//name sub type
//-------------
//		the length of the name

//punctuation
typedef struct punctuation_s
{
	char *p;						//punctuation character(s)
	int n;							//punctuation indication
	struct punctuation_s *next;		//next punctuation
} punctuation_t;

//token
typedef struct token_s
{
	char string[MAX_TOKEN];			//available token
	int type;						//last read token type
	int subtype;					//last read token sub type
#ifdef NUMBERVALUE
// AI: Raven typed this unsigned long int. The copy keeps the 32 bits of WinDed, so the record has one layout on every host.
	unsigned int intvalue;	//integer value
// AI: Raven typed this long double. The copy keeps the 64 bits of WinDed, so the record has one layout on every host.
	double floatvalue;			//floating point value
#endif //NUMBERVALUE
	char *whitespace_p;				//start of white space before token
	char *endwhitespace_p;			//start of white space before token
	int line;						//line the token was on
	int linescrossed;				//lines crossed in white space
	struct token_s *next;			//next token in chain
} token_t;

//script file
typedef struct script_s
{
	char filename[1024];			//file name of the script
	char *buffer;					//buffer containing the script
	char *script_p;					//current pointer in the script
	char *end_p;					//pointer to the end of the script
	char *lastscript_p;				//script pointer before reading token
	char *whitespace_p;				//begin of the white space
	char *endwhitespace_p;			//end of the white space
	int length;						//length of the script in bytes
	int line;						//current line in script
	int lastline;					//line before reading token
	int tokenavailable;				//set by UnreadLastToken
	int flags;						//several script flags
	punctuation_t *punctuations;	//the punctuations used in the script
	punctuation_t **punctuationtable;
	token_t token;					//available token
	struct script_s *next;			//next script in a chain
} script_t;

// Source: oracle/codemp/botlib/l_precomp.h:39
#define DEFINE_FIXED			0x0001
#define	DEFINE_GLOBAL			0x0002

#define BUILTIN_LINE			1
#define BUILTIN_FILE			2
#define BUILTIN_DATE			3
#define BUILTIN_TIME			4
#define BUILTIN_STDC			5

#define INDENT_IF				0x0001
#define INDENT_ELSE				0x0002
#define INDENT_ELIF				0x0004
#define INDENT_IFDEF			0x0008
#define INDENT_IFNDEF			0x0010

//macro definitions
typedef struct define_s
{
	char *name;							//define name
	int flags;							//define flags
	int builtin;						// > 0 if builtin define
	int numparms;						//number of define parameters
	token_t *parms;						//define parameters
	token_t *tokens;					//macro tokens (possibly containing parm tokens)
	struct define_s *next;				//next defined macro in a list
	struct define_s *hashnext;			//next define in the hash chain
	struct define_s *globalnext;		//used to link up the globald defines
} define_t;

//indents
//used for conditional compilation directives:
//#if, #else, #elif, #ifdef, #ifndef
typedef struct indent_s
{
	int type;								//indent type
	int skip;								//true if skipping current indent
	script_t *script;						//script the indent was in
	struct indent_s *next;					//next indent on the indent stack
} indent_t;

//source file
typedef struct source_s
{
	char filename[1024];					//file name of the script
	char includepath[1024];					//path to include files
	punctuation_t *punctuations;			//punctuations to use
	script_t *scriptstack;					//stack with scripts of the source
	token_t *tokens;						//tokens to read first
	define_t *defines;						//list with macro definitions
	define_t **definehash;					//hash chain with defines
	indent_t *indentstack;					//stack with indents
	int skip;								// > 0 if skipping conditional code
	token_t token;							//last read token
} source_t;

// Source: oracle/codemp/botlib/l_libvar.h:16
typedef struct libvar_s
{
	char		*name;
	char		*string;
	int		flags;
	qboolean	modified;	// set each time the cvar is changed
	float		value;
	struct	libvar_s *next;
} libvar_t;

// Source: oracle/codemp/botlib/l_struct.h:16
#define MAX_STRINGFIELD				80
//field types
#define FT_CHAR						1			// char
#define FT_INT							2			// int
#define FT_FLOAT						3			// float
#define FT_STRING						4			// char [MAX_STRINGFIELD]
#define FT_STRUCT						6			// struct (sub structure)
//type only mask
#define FT_TYPE						0x00FF	// only type, clear subtype
//sub types
#define FT_ARRAY						0x0100	// array of type
#define FT_BOUNDED					0x0200	// bounded value
#define FT_UNSIGNED					0x0400

//structure field definition
typedef struct fielddef_s
{
	char *name;										//name of the field
	int offset;										//offset in the structure
	int type;										//type of the field
	//type specific fields
	int maxarray;									//maximum array size
	float floatmin, floatmax;					//float min and max
	struct structdef_s *substruct;			//sub structure
} fielddef_t;

//structure definition
typedef struct structdef_s
{
	int size;
	fielddef_t *fields;
} structdef_t;

// Source: oracle/codemp/botlib/be_ai_weight.h:15
#define WT_BALANCE			1
#define MAX_WEIGHTS			128

//fuzzy seperator
typedef struct fuzzyseperator_s
{
	int index;
	int value;
	int type;
	float weight;
	float minweight;
	float maxweight;
	struct fuzzyseperator_s *child;
	struct fuzzyseperator_s *next;
} fuzzyseperator_t;

//fuzzy weight
typedef struct weight_s
{
	char *name;
	struct fuzzyseperator_s *firstseperator;
} weight_t;

//weight configuration
typedef struct weightconfig_s
{
	int numweights;
	weight_t weights[MAX_WEIGHTS];
	char		filename[MAX_QPATH];
} weightconfig_t;

// The arm Raven's WinDed Release build takes, with DEBUG undefined.
// Source: oracle/codemp/botlib/be_interface.h:16
#define RANDOMIZE		//randomize bot behaviour

//FIXME: get rid of this global structure
typedef struct botlib_globals_s
{
	int botlibsetup;						//true when the bot library has been setup
	int maxentities;						//maximum number of entities
	int maxclients;							//maximum number of clients
	float time;								//the global time
#ifdef DEBUG
	qboolean debug;							//true if debug is on
	int goalareanum;
	vec3_t goalorigin;
	int runai;
#endif
} botlib_globals_t;

// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:33
#define MAX_BSPENTITIES		2048

// Source: oracle/codemp/botlib/be_aas_bspq3.cpp:35
typedef struct rgb_s
{
	int red;
	int green;
	int blue;
} rgb_t;

//bsp entity epair
typedef struct bsp_epair_s
{
	char *key;
	char *value;
	struct bsp_epair_s *next;
} bsp_epair_t;

//bsp data entity
typedef struct bsp_entity_s
{
	bsp_epair_t *epairs;
} bsp_entity_t;

//id Sofware BSP data
typedef struct bsp_s
{
	//true when bsp file is loaded
	int loaded;
	//entity data
	int entdatasize;
	char *dentdata;
	//bsp entities
	int numentities;
	bsp_entity_t entities[MAX_BSPENTITIES];
} bsp_t;

// Source: oracle/codemp/botlib/be_aas_reach.cpp:70
typedef struct aas_lreachability_s
{
	int areanum;					//number of the reachable area
	int facenum;					//number of the face towards the other area
	int edgenum;					//number of the edge towards the other area
	vec3_t start;					//start point of inter area movement
	vec3_t end;						//end point of inter area movement
	int traveltype;					//type of travel required to get to the area
	unsigned short int traveltime;	//travel time of the inter area movement
	//
	struct aas_lreachability_s *next;
} aas_lreachability_t;

// Source: oracle/codemp/botlib/be_aas_sample.cpp:40
typedef struct aas_tracestack_s
{
	vec3_t start;		//start point of the piece of line to trace
	vec3_t end;			//end point of the piece of line to trace
	int planenum;		//last plane used as splitter
	int nodenum;		//node found after splitting with planenum
} aas_tracestack_t;

// Source: oracle/codemp/botlib/be_aas_sample.cpp:1201
typedef struct
{
	int nodenum;		//node found after splitting
} aas_linkstack_t;

// Source: oracle/codemp/botlib/be_aas_route.cpp:899
typedef struct routecacheheader_s
{
	int ident;
	int version;
	int numareas;
	int numclusters;
	int areacrc;
	int clustercrc;
	int numportalcache;
	int numareacache;
} routecacheheader_t;

// Source: oracle/codemp/botlib/be_aas_optimize.cpp:29
typedef struct optimized_s
{
	//vertexes
	int numvertexes;
	aas_vertex_t *vertexes;
	//edges
	int numedges;
	aas_edge_t *edges;
	//edge index
	int edgeindexsize;
	aas_edgeindex_t *edgeindex;
	//faces
	int numfaces;
	aas_face_t *faces;
	//face index
	int faceindexsize;
	aas_faceindex_t *faceindex;
	//convex areas
	int numareas;
	aas_area_t *areas;
	//
	int *vertexoptimizeindex;
	int *edgeoptimizeindex;
	int *faceoptimizeindex;
} optimized_t;

// Source: oracle/codemp/botlib/be_aas_routealt.cpp:32
typedef struct midrangearea_s
{
	int valid;
	unsigned short starttime;
	unsigned short goaltime;
} midrangearea_t;

// Source: oracle/codemp/botlib/be_ai_char.cpp:30
#define MAX_CHARACTERISTICS		80

// Source: oracle/codemp/botlib/be_ai_char.cpp:38
//characteristic value
union cvalue
{
	int integer;
	float _float;
	char *string;
};
//a characteristic
typedef struct bot_characteristic_s
{
	char type;						//characteristic type
	union cvalue value;				//characteristic value
} bot_characteristic_t;

//a bot character
typedef struct bot_character_s
{
	char filename[MAX_QPATH];
	float skill;
	bot_characteristic_t c[1];		//variable sized
} bot_character_t;

// Source: oracle/codemp/botlib/be_ai_chat.cpp:57
typedef struct bot_chatmessage_s
{
	char *chatmessage;					//chat message string
	float time;							//last time used
	struct bot_chatmessage_s *next;		//next chat message in a list
} bot_chatmessage_t;
//bot chat type with chat lines
typedef struct bot_chattype_s
{
	char name[MAX_CHATTYPE_NAME];
	int numchatmessages;
	bot_chatmessage_t *firstchatmessage;
	struct bot_chattype_s *next;
} bot_chattype_t;
//bot chat lines
typedef struct bot_chat_s
{
	bot_chattype_t *types;
} bot_chat_t;

//random string
typedef struct bot_randomstring_s
{
	char *string;
	struct bot_randomstring_s *next;
} bot_randomstring_t;
//list with random strings
typedef struct bot_randomlist_s
{
	char *string;
	int numstrings;
	bot_randomstring_t *firstrandomstring;
	struct bot_randomlist_s *next;
} bot_randomlist_t;

//synonym
typedef struct bot_synonym_s
{
	char *string;
	float weight;
	struct bot_synonym_s *next;
} bot_synonym_t;
//list with synonyms
typedef struct bot_synonymlist_s
{
// AI: Raven typed this unsigned long int. The copy keeps the 32 bits of WinDed, so the record has one layout on every host.
	unsigned int context;
	float totalweight;
	bot_synonym_t *firstsynonym;
	struct bot_synonymlist_s *next;
} bot_synonymlist_t;

//fixed match string
typedef struct bot_matchstring_s
{
	char *string;
	struct bot_matchstring_s *next;
} bot_matchstring_t;

//piece of a match template
typedef struct bot_matchpiece_s
{
	int type;
	bot_matchstring_t *firststring;
	int variable;
	struct bot_matchpiece_s *next;
} bot_matchpiece_t;
//match template
typedef struct bot_matchtemplate_s
{
// AI: Raven typed this unsigned long int. The copy keeps the 32 bits of WinDed, so the record has one layout on every host.
	unsigned int context;
	int type;
	int subtype;
	bot_matchpiece_t *first;
	struct bot_matchtemplate_s *next;
} bot_matchtemplate_t;

//reply chat key
typedef struct bot_replychatkey_s
{
	int flags;
	char *string;
	bot_matchpiece_t *match;
	struct bot_replychatkey_s *next;
} bot_replychatkey_t;
//reply chat
typedef struct bot_replychat_s
{
	bot_replychatkey_t *keys;
	float priority;
	int numchatmessages;
	bot_chatmessage_t *firstchatmessage;
	struct bot_replychat_s *next;
} bot_replychat_t;

//string list
typedef struct bot_stringlist_s
{
	char *string;
	struct bot_stringlist_s *next;
} bot_stringlist_t;

//chat state of a bot
typedef struct bot_chatstate_s
{
	int gender;											//0=it, 1=female, 2=male
	int client;											//client number
	char name[32];										//name of the bot
	char chatmessage[MAX_MESSAGE_SIZE];
	int handle;
	//the console messages visible to the bot
	bot_consolemessage_t *firstmessage;			//first message is the first typed message
	bot_consolemessage_t *lastmessage;			//last message is the last typed message, bottom of console
	//number of console messages stored in the state
	int numconsolemessages;
	//the bot chat lines
	bot_chat_t *chat;
} bot_chatstate_t;

typedef struct {
	bot_chat_t	*chat;
	char		filename[MAX_QPATH];
	char		chatname[MAX_QPATH];
} bot_ichatdata_t;

// Source: oracle/codemp/botlib/be_ai_goal.cpp:52
//location in the map "target_location"
typedef struct maplocation_s
{
	vec3_t origin;
	int areanum;
	char name[MAX_EPAIRKEY];
	struct maplocation_s *next;
} maplocation_t;

//camp spots "info_camp"
typedef struct campspot_s
{
	vec3_t origin;
	int areanum;
	char name[MAX_EPAIRKEY];
	float range;
	float weight;
	float wait;
	float random;
	struct campspot_s *next;
} campspot_t;

// Source: oracle/codemp/botlib/be_ai_goal.cpp:93
typedef struct levelitem_s
{
	int number;							//number of the level item
	int iteminfo;						//index into the item info
	int flags;							//item flags
	float weight;						//fixed roam weight
	vec3_t origin;						//origin of the item
	int goalareanum;					//area the item is in
	vec3_t goalorigin;					//goal origin within the area
	int entitynum;						//entity number
	float timeout;						//item is removed after this time
	struct levelitem_s *prev, *next;
} levelitem_t;

typedef struct iteminfo_s
{
	char classname[32];					//classname of the item
	char name[MAX_STRINGFIELD];			//name of the item
	char model[MAX_STRINGFIELD];		//model of the item
	int modelindex;						//model index
	int type;							//item type
	int index;							//index in the inventory
	float respawntime;					//respawn time
	vec3_t mins;						//mins of the item
	vec3_t maxs;						//maxs of the item
	int number;							//number of the item info
} iteminfo_t;

// Source: oracle/codemp/botlib/be_ai_goal.cpp:141
typedef struct itemconfig_s
{
	int numiteminfo;
	iteminfo_t *iteminfo;
} itemconfig_t;

//goal state
typedef struct bot_goalstate_s
{
	struct weightconfig_s *itemweightconfig;	//weight config
	int *itemweightindex;						//index from item to weight
	//
	int client;									//client using this goal state
	int lastreachabilityarea;					//last area with reachabilities the bot was in
	//
	bot_goal_t goalstack[MAX_GOALSTACK];		//goal stack
	int goalstacktop;							//the top of the goal stack
	//
	int avoidgoals[MAX_AVOIDGOALS];				//goals to avoid
	float avoidgoaltimes[MAX_AVOIDGOALS];		//times to avoid the goals
} bot_goalstate_t;

// Source: oracle/codemp/botlib/be_ai_move.cpp:39
//movement state
//NOTE: the moveflags MFL_ONGROUND, MFL_TELEPORTED, MFL_WATERJUMP and
//		MFL_GRAPPLEPULL must be set outside the movement code
typedef struct bot_movestate_s
{
	//input vars (all set outside the movement code)
	vec3_t origin;								//origin of the bot
	vec3_t velocity;							//velocity of the bot
	vec3_t viewoffset;							//view offset
	int entitynum;								//entity number of the bot
	int client;									//client number of the bot
	float thinktime;							//time the bot thinks
	int presencetype;							//presencetype of the bot
	vec3_t viewangles;							//view angles of the bot
	//state vars
	int areanum;								//area the bot is in
	int lastareanum;							//last area the bot was in
	int lastgoalareanum;						//last goal area number
	int lastreachnum;							//last reachability number
	vec3_t lastorigin;							//origin previous cycle
	int reachareanum;							//area number of the reachabilty
	int moveflags;								//movement flags
	int jumpreach;								//set when jumped
	float grapplevisible_time;					//last time the grapple was visible
	float lastgrappledist;						//last distance to the grapple end
	float reachability_time;					//time to use current reachability
	int avoidreach[MAX_AVOIDREACH];				//reachabilities to avoid
	float avoidreachtimes[MAX_AVOIDREACH];		//times to avoid the reachabilities
	int avoidreachtries[MAX_AVOIDREACH];		//number of tries before avoiding
	//
	bot_avoidspot_t avoidspots[MAX_AVOIDSPOTS];	//spots to avoid
	int numavoidspots;
} bot_movestate_t;

// Source: oracle/codemp/botlib/be_ai_weap.cpp:95
//weapon configuration: set of weapons with projectiles
typedef struct weaponconfig_s
{
	int numweapons;
	int numprojectiles;
	projectileinfo_t *projectileinfo;
	weaponinfo_t *weaponinfo;
} weaponconfig_t;

//the bot weapon state
typedef struct bot_weaponstate_s
{
	struct weightconfig_s *weaponweightconfig;		//weapon weight configuration
	int *weaponweightindex;							//weapon weight index
} bot_weaponstate_t;

// Source: oracle/codemp/botlib/l_log.cpp:24
#define MAX_LOGFILENAMESIZE		1024

typedef struct logfile_s
{
	char filename[MAX_LOGFILENAMESIZE];
	FILE *fp;
	int numwrites;
} logfile_t;

// Source: oracle/codemp/botlib/l_precomp.cpp:1652
typedef struct operator_s
{
	int mOperator;
	int priority;
	int parentheses;
	struct operator_s *prev, *next;
} operator_t;

typedef struct value_s
{
// AI: Raven typed this signed long int. The copy keeps the 32 bits of WinDed, so the record has one layout on every host.
	int intvalue;
	double floatvalue;
	int parentheses;
	struct value_s *prev, *next;
} value_t;

// The automap symbol of client.h, a header the host parse does not read, which GetAutomapSymbol of RM_Manager.cpp:418 returns
// and SV_SendClientGameState of sv_client.cpp:677 reads, row X41 of docket 10.
// Source: oracle/codemp/client/client.h:142
typedef struct 
{
	int			mType;
	int			mSide;
	vec3_t		mOrigin;

} rmAutomapSymbol_t;

#endif
