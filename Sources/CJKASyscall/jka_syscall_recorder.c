#include "jka_syscall.h"

#include <stdarg.h>

// The stand-in engine of the dlopen smoke test lives in C, because the module calls its entry point as a C variadic.
// On arm64 macOS a variadic callee reads its arguments from a different place than a fixed-arity callee does.
// A Swift @convention(c) function is always fixed-arity, so it would read the wrong words.
static intptr_t jka_last_command = 0;
static intptr_t jka_last_word = 0;

static intptr_t jka_recording_syscall(intptr_t command, ...) {
    va_list words;
    va_start(words, command);
    jka_last_command = command;
    jka_last_word = va_arg(words, intptr_t);
    va_end(words);
    return 0;
}

jka_syscall_fn jka_recorder_entry(void) {
    return jka_recording_syscall;
}

intptr_t jka_recorded_command(void) {
    return jka_last_command;
}

intptr_t jka_recorded_word(void) {
    return jka_last_word;
}

void jka_recorder_reset(void) {
    jka_last_command = 0;
    jka_last_word = 0;
}
