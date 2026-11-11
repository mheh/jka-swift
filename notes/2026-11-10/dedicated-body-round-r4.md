# The R4 body round of the dead-function wave

This record holds set R4 of section 4 of `notes/2026-11-10/docket-13.md`: the two x86 function scans of `win_main.swift` and the two CPU speed functions of `win_shared.swift`. The branch is `ded-bodies-r4` from the local commit `f60a012e`, in the worktree `/tmp/jka-r4`. Row N-X86 of ledger 14 gives the form, and its proof is section 10 of `notes/2026-11-10/rows-14-new.md`.

## The functions

| Function | Raven | Status |
| --- | --- | --- |
| Sys_FunctionCmp | null/win_main.cpp:59 | landed |
| Sys_FunctionCheckSum | null/win_main.cpp:128 | landed |
| Sys_GetCPUSpeedOld | win32/win_shared.cpp:338 | landed |
| Sys_GetCPUSpeed | win32/win_shared.cpp:399 | landed |

Four of four bodies landed.

## The forms

- Sys_FunctionCmp returns 1 and Sys_FunctionCheckSum returns 0, the values of Raven's `unix/unix_main.c:68` to `:79`. Each has the one `// AI:` line of the row.
- Each `rdtsc` read of the CPU speed bodies is `SysBackend.timeGetTime()` in milliseconds, the form of `timing_c.swift:20`. With a millisecond clock, Sys_GetCPUSpeed gives 0 on the host.
- SysBackend gets one member for each Win32 call: `timeBeginPeriod` and `timeEndPeriod` do nothing, `GetCurrentThread` reads `pthread_self`, `GetThreadPriority` and `SetThreadPriority` use `pthread_getschedparam` and `pthread_setschedparam`, and the two performance counter calls read `CLOCK_MONOTONIC` in nanoseconds at a frequency of 1000000000.
- GetThreadPriority gives the POSIX priority less the highest priority of the policy. That value is zero or less, so it never equals THREAD_PRIORITY_TIME_CRITICAL (15), and SetThreadPriority restores the saved value exactly.
- `LARGE_INTEGER` and `HANDLE` follow the `FILETIME` form, and `THREAD_PRIORITY_ERROR_RETURN` and `THREAD_PRIORITY_TIME_CRITICAL` follow the `FILE_ATTRIBUTE_READONLY` form. The POSIX calls have the same names on Darwin and Glibc, so no platform split is necessary.
- Raven's `unsigned long` is a `UInt32`, and its arithmetic wraps with `&+`, `&-`, and `&*`. MSVC hands each `unsigned long` difference to the `int` abs, so the body reads its bits as an `Int32`. A rule 19 note marks the abs of INT_MIN, which traps in Swift.
- The no-caller notes stay. The two CPU speed functions lose the Port-note line about the missing port.

## The checks

`swift build -j 2` completes with no warning in the three files. `swift test --no-parallel -j 2` passes 162 tests, the count of the base. The Linux lane was not built here.
