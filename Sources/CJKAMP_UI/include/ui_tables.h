// Raven's ui tables that ui_tables.c defines as written, declared so a view can bind over them.
#ifndef JKA_UI_TABLES_H
#define JKA_UI_TABLES_H

// The Swift importer drops an array of unknown bound, so the bound is written, and clang checks it against the initializer.
// Source: oracle/codemp/ui/ui_main.c:414
extern datpadmovedata_t datapadMoveData[MD_MOVE_TITLE_MAX][MAX_MOVES];

// Source: oracle/codemp/ui/ui_main.c:896
extern serverFilter_t serverFilters[2];

// Source: oracle/codemp/ui/ui_main.c:7883
extern serverStatusCvar_t serverStatusCvars[10];

// Source: oracle/codemp/ui/ui_shared.c:5190
extern bind_t g_bindings[96];

// Source: oracle/codemp/ui/ui_shared.c:157
extern itemFlagsDef_t itemFlags[2];

#endif
