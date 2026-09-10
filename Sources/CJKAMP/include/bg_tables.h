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

#endif // JKA_BG_TABLES_H
