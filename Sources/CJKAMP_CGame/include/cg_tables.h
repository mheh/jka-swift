// Raven's cgame table that cg_tables.c defines as written, declared so a view can bind over it.
#ifndef JKA_CG_TABLES_H
#define JKA_CG_TABLES_H

// The Swift importer drops an array of unknown bound, so the bound is written, and clang checks it against the initializer.
// Source: oracle/codemp/cgame/cg_main.c:3393
extern BG_field_t cg_spawnFields[14];

// Source: oracle/codemp/ui/ui_shared.c:5190
extern bind_t g_bindings[96];

// Source: oracle/codemp/ui/ui_shared.c:157
extern itemFlagsDef_t itemFlags[2];

// Source: oracle/codemp/cgame/cg_draw.c:2425
extern veh_damage_t vehDamageData[4];

#endif
