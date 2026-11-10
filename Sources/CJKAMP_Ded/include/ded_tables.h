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

// The botlib tables, with the bound of Raven's rows, rows D11 and D19 of the ninth batch.
// Source: oracle/codemp/botlib/l_script.cpp:69
extern punctuation_t default_punctuations[54];
// Source: oracle/codemp/botlib/be_ai_goal.cpp:123
extern fielddef_t iteminfo_fields[9];
// Source: oracle/codemp/botlib/be_ai_goal.cpp:136
extern structdef_t iteminfo_struct;
// Raven declares the next four `static` in be_ai_weap.cpp, and ded_tables.c defines them without the `static`, so this header can declare them.
// Source: oracle/codemp/botlib/be_ai_weap.cpp:38
extern fielddef_t weaponinfo_fields[23];
// Source: oracle/codemp/botlib/be_ai_weap.cpp:66
extern fielddef_t projectileinfo_fields[15];
// Source: oracle/codemp/botlib/be_ai_weap.cpp:86
extern structdef_t weaponinfo_struct;
// Source: oracle/codemp/botlib/be_ai_weap.cpp:90
extern structdef_t projectileinfo_struct;

#endif
