// Raven's cgame table that cg_tables.c defines as written, declared so a view can bind over it.
#ifndef JKA_CG_TABLES_H
#define JKA_CG_TABLES_H

// The Swift importer drops an array of unknown bound, so the bound is written, and clang checks it against the initializer.
// Source: oracle/codemp/cgame/cg_main.c:3393
extern BG_field_t cg_spawnFields[14];

#endif
