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
	const float	*mins;
	const float	*maxs;
	int			*list;
	int			count, maxcount;
} areaParms_t;

// Source: oracle/codemp/server/sv_world.cpp:440
typedef struct {
	vec3_t		boxmins, boxmaxs;// enclose the test object along entire move
	const float	*mins;
	const float *maxs;	// size of the moving object
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

#endif
