// Raven's netField tables that ded_tables.c defines as written, declared so a view can bind over them.
#ifndef JKA_DED_TABLES_H
#define JKA_DED_TABLES_H

// The Swift importer drops an array of unknown bound, so the bound is written, and clang checks it against the initializer.
// Source: oracle/codemp/qcommon/msg.cpp:859
extern netField_t entityStateFields[132];
#ifdef _OPTIMIZED_VEHICLE_NETWORKING
// Source: oracle/codemp/qcommon/msg.cpp:1410
extern netField_t playerStateFields[137];
// Source: oracle/codemp/qcommon/msg.cpp:1570
extern netField_t pilotPlayerStateFields[140];
// Source: oracle/codemp/qcommon/msg.cpp:1736
extern netField_t vehPlayerStateFields[69];
#else
// Source: oracle/codemp/qcommon/msg.cpp:1829
extern netField_t playerStateFields[152];
#endif

#endif
