// Raven's game tables that g_tables.c defines as written, declared so a view can bind over them.
#ifndef JKA_G_TABLES_H
#define JKA_G_TABLES_H

// The Swift importer drops an array of unknown bound, so the bound is written, and clang checks it against the initializer.
// Source: oracle/codemp/game/g_ICARUScb.c:52
extern stringID_table_t setTable[212];
// Source: oracle/codemp/game/NPC_stats.c:14
extern stringID_table_t TeamTable[5];
// Source: oracle/codemp/game/NPC_stats.c:24
extern stringID_table_t ClassTable[57];
// Source: oracle/codemp/game/NPC_stats.c:88
extern stringID_table_t BSTable[11];
// Source: oracle/codemp/game/NPC_stats.c:106
extern stringID_table_t BSETTable[19];
// Source: oracle/codemp/game/g_spawn.c:54
extern BG_field_t fields[86];

#endif
