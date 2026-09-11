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

#endif
