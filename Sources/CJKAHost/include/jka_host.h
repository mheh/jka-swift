#ifndef JKA_HOST_H
#define JKA_HOST_H

#include <stdint.h>

#include "jka_syscall.h"

// The engine side of the module ABI: the variadic callee the module calls, and the load that gives the callee to the module.
// Swift cannot write a C variadic callee, so both stay in C.

// The Swift host installs this function before the first VM_Call, as VM_Create sets vm->systemCall.
// It gets the command and 14 words, and the count is always 15.
// Source: oracle/codemp/qcommon/vm_local.h:115
// AI: Raven passed each syscall word as an int, which holds a pointer only on a 32-bit build. The words are intptr_t, so a pointer stays whole on a 64-bit host.
typedef intptr_t (*jka_systemcall_fn)(const intptr_t *parms, int count);

// Source: oracle/codemp/qcommon/vm.cpp:506
extern jka_systemcall_fn jka_systemCall;

// The module's vmMain, the command and twelve words.
// Port-note: Raven called vmMain through a variadic pointer, and the module defines vmMain with a fixed count of words.
// On arm64 that call reads the words from the wrong place, so this pointer type has the fixed count of the definition.
// Source: oracle/codemp/game/g_main.c:515
typedef intptr_t (*jka_vmmain_fn)(
    intptr_t command,
    intptr_t arg0,
    intptr_t arg1,
    intptr_t arg2,
    intptr_t arg3,
    intptr_t arg4,
    intptr_t arg5,
    intptr_t arg6,
    intptr_t arg7,
    intptr_t arg8,
    intptr_t arg9,
    intptr_t arg10,
    intptr_t arg11
);

// The module calls this function for every syscall, through the pointer that dllEntry gave it.
// Swift cannot call it, so a Swift test reaches it through jka_syscall.
// Source: oracle/codemp/qcommon/vm.cpp:363
intptr_t VM_DllSyscall(intptr_t arg, ...);

// This loads the module library at the path, gives it VM_DllSyscall through dllEntry, and stores its vmMain in entryPoint.
// It returns the library handle, or NULL when the load or a lookup fails.
// The path search of Sys_LoadDll is not here, because it reads the fs_* cvars.
// Source: oracle/codemp/null/win_main.cpp:784
void *jka_load_dll(const char *path, jka_vmmain_fn *entryPoint);

#endif
