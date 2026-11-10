// Raven's netField tables, the md4 padding, and the static zone blocks that ded_tables.c defines as written, declared so a view can bind over them.
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

// Raven declares the table `static` in md4.cpp, and ded_tables.c defines it without the `static`, so this header can declare it.
// Source: oracle/codemp/qcommon/md4.cpp:78
extern unsigned char PADDING[64];

// Source: oracle/codemp/qcommon/z_memman_pc.cpp:139
extern StaticZeroMem_t gZeroMalloc;
// Source: oracle/codemp/qcommon/z_memman_pc.cpp:141
extern StaticMem_t gEmptyString;
// Source: oracle/codemp/qcommon/z_memman_pc.cpp:143
extern StaticMem_t gNumberString[10];

// Raven declares the table `const` with no bound in tr_init.cpp, and ded_tables.c defines it with the bound of his 13 rows, so a view can bind over it.
// Source: oracle/codemp/renderer/tr_init.cpp:465
extern vidmode_t r_vidModes[13];

#endif
