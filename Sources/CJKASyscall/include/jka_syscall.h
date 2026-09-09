#ifndef JKA_SYSCALL_H
#define JKA_SYSCALL_H

#include <stdint.h>

// The engine gives the module one variadic function pointer at dllEntry.
// Source: oracle/codemp/game/g_syscalls.c:14
typedef intptr_t (*jka_syscall_fn)(intptr_t arg, ...);

// Swift cannot call a C variadic, so this shim spreads a fixed array into the variadic call.
// One arm exists per argument count Raven uses, 0 through 13.
intptr_t jka_syscall(jka_syscall_fn fn, intptr_t command, int count, const intptr_t *args);

// The stand-in engine the dlopen smoke test installs, because Swift cannot write a C variadic callee.
// It stores the command and the first word, and it always answers 0.
jka_syscall_fn jka_recorder_entry(void);

// The command of the last recorded call, and its first word.
// A word that carries a string is a pointer, so the caller reads it as a C string.
intptr_t jka_recorded_command(void);
intptr_t jka_recorded_word(void);

// This clears both records to 0 before a test drives the module.
void jka_recorder_reset(void);

#endif
