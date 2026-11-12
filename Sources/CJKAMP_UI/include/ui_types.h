// Raven's types defined inside a .c file, copied as written, so a view can bind over them and C storage can hold them.
#ifndef JKA_UI_TYPES_H
#define JKA_UI_TYPES_H

// Source: oracle/codemp/ui/ui_main.c:406
typedef struct 
{
	char	*title;	
	char	*desc;	
	char	*anim;
	short	sound;
} datpadmovedata_t;

// Source: oracle/codemp/ui/ui_main.c:7878
typedef struct
{
	char *name, *altName;
} serverStatusCvar_t;

// Source: oracle/codemp/ui/ui_main.c:11279
typedef struct {
	vmCvar_t	*vmCvar;
	char		*cvarName;
	char		*defaultString;
	int			cvarFlags;
} cvarTable_t;

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

// Source: oracle/codemp/ui/ui_shared.c:7479
typedef struct uiG2PtrTracker_s uiG2PtrTracker_t;

// Source: oracle/codemp/ui/ui_shared.c:7481
struct uiG2PtrTracker_s
{
	void *ghoul2;
	uiG2PtrTracker_t *next;
};

#endif
