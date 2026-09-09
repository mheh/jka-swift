#include "jka_syscall.h"

#include <stdlib.h>

intptr_t jka_syscall(jka_syscall_fn fn, intptr_t command, int count, const intptr_t *a) {
    switch (count) {
    case 0: return fn(command);
    case 1: return fn(command, a[0]);
    case 2: return fn(command, a[0], a[1]);
    case 3: return fn(command, a[0], a[1], a[2]);
    case 4: return fn(command, a[0], a[1], a[2], a[3]);
    case 5: return fn(command, a[0], a[1], a[2], a[3], a[4]);
    case 6: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5]);
    case 7: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
    case 8: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
    case 9: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
    case 10: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]);
    case 11: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]);
    case 12: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]);
    case 13: return fn(command, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12]);
    default:
        // No Raven trap passes more than 13 arguments, so a wider call is a module bug.
        abort();
    }
}
