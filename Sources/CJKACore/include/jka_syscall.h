#ifndef JKA_SYSCALL_H
#define JKA_SYSCALL_H

#include <stdint.h>

// The engine gives the module one variadic function pointer at dllEntry.
// Source: oracle/codemp/game/g_syscalls.c:14
typedef intptr_t (*jka_syscall_fn)(intptr_t arg, ...);

// Swift cannot call a C variadic, so this shim spreads a fixed array into the variadic call.
// One arm exists per argument count Raven uses, 0 through 13.
intptr_t jka_syscall(jka_syscall_fn fn, intptr_t command, int count, const intptr_t *args);

#endif
