# The dedicated server stage 2, the shell

The record of stage 2 of the dedicated server, the package shell, on the branch `dedicated-stage-2-shell` off master at `df7a30e`. The docket is `notes/2026-11-03/dedicated-opening-docket.md`, and this stage builds its rows E3, E12, and E14 under E2. No logic target, view target, or `CJKAMP_Ded` target exists yet, because the generators write them in a later stage. No file under `tools/`, `.github/`, `jka-rust/`, or `../jka-rust` changed.

## The targets

- E3, `CJKAHost`, `Package.swift:18-20`. The C target holds `Sources/CJKAHost/include/jka_host.h` and `Sources/CJKAHost/jka_host.c`, and it depends on `CJKASyscall` for the type `jka_syscall_fn`. `VM_DllSyscall( intptr_t arg, ... )` copies the command and 14 words from its `va_list` into an array of 15 and calls `jka_systemCall`, the function pointer the Swift host installs, with the type `intptr_t (*)(const intptr_t *parms, int count)`. `jka_load_dll` opens a module path with `dlopen`, reads `dllEntry` and `vmMain` with `dlsym`, calls `dllEntry( VM_DllSyscall )`, and stores the `vmMain` pointer. The cites are `oracle/codemp/qcommon/vm.cpp:363` for `VM_DllSyscall` and `oracle/codemp/null/win_main.cpp:784` and `:827-828` for the load. The one `// AI:` line is at the width typedef, `jka_host.h:14`. Commit 9510fcf.
- E14, `CJKAZlib`, `Package.swift:22-25`. A system library target with `module.modulemap` (`link "z"`) and the header `CJKAZlib.h`, which includes `<zlib.h>`. No target depends on it yet, so `swift build` does not compile it. A Swift file outside the tree that imports it with `-I Sources/CJKAZlib` compiles, links `/usr/lib/libz.1.dylib`, and prints `zlibVersion()` 1.2.12 on macOS. Commit 06fbcbf.
- E12, `jampded`, the product at `Package.swift:12` and the shell target at `Package.swift:64-65`. The shell `Sources/jampded/main.swift` depends on `CJKAHost` and `JKAShared` and imports neither yet. It prints `Q3_VERSION` and `CPUSTRING`, the version line of `Com_Init` at `oracle/codemp/qcommon/common.cpp:1219`, and exits 0. On macOS the line is `(internal)JAmp: v1.0.1.0 MacOSX-other`. Commit ac10b70.
- The tests. `CJKAHostTests` at `Package.swift:87-93` depends on `CJKAHost` and `CJKASyscall`. Its suite `VMDllSyscallSuite` installs a recording function, calls `VM_DllSyscall` through `jka_syscall` with 0, 1, and 14 words and with one pointer word, and checks that the command and the words arrive in order. `jampdedTests` at `Package.swift:94-95` depends on no target. Its suite `JampdedSmokeSuite` runs the built `jampded` as a process and checks exit 0 and the version line, in the shape of `Tests/jampgameTests/JampgameSmokeTests.swift`. Commit fc426c4.
- Commit 039a312 puts each sentence of the new `Package.swift` comments on its own line. It changes no code.

## What a Linux and a Windows lane need for zlib

- Linux. The lane needs the zlib headers and `libz.so`. The image `swift:6.3.3-noble` has both: a copy of the new targets and tests in that container builds, imports `CJKAZlib`, prints `zlibVersion()` 1.3, and passes the five new tests. The CI images are `swift:6.4-noble`, so the lane needs no new package, and a release binary links `libz.so.1` from the host at run time.
- Windows. The Swift toolchain for Windows ships no system zlib. The lane needs the zlib headers and an import library, for example from vcpkg, and it passes their folders with `-Xcc -I` and `-Xlinker -L`. The module map says `link "z"`, so the linker looks for `z.lib`, and vcpkg names its library `zlib.lib`. Row 9 holds this.

## The checks

- Before: `swift test --no-parallel` passes 117 tests across its runs of 1, 1, 84, 13, 3, and 15.
- After: `swift build` passes with no warning. `swift test --no-parallel` passes 122 tests across its runs of 1, 1, 1, 84, 13, 3, 15, and 4. The new run of 1 is `JampdedSmokeSuite`, and the run of 4 is `VMDllSyscallSuite`.
- The checks ran before commit 039a312. That commit changes comments only, and `swift build` passes after it.
- The Linux run in the container is the one described in the zlib section. It passes 5 tests in 2 suites.

## Rows

1. The `// AI:` line at `Sources/CJKAHost/include/jka_host.h:14` names the mechanism and not row E2, because rule 24 says the line names no row number (`docs/porting-rules.md:71`). The stage brief asked for a line that cites E2.
2. The `count` parameter of `jka_systemcall_fn` (`jka_host.h:15`) has no Raven counterpart. Raven's `systemCall` takes `int *parms` alone (`oracle/codemp/qcommon/vm_local.h:115`), and `VM_DllSyscall` always passes 15 (`Sources/CJKAHost/jka_host.c:24`). The site has no `// AI:` line, because no ruling covers the parameter.
3. The array of `VM_DllSyscall` holds 15 words (`jka_host.c:13`). Raven's linux powerpc arm, the form the port copies, holds 16 (`oracle/codemp/qcommon/vm.cpp:366`).
4. `VM_DllSyscall` reads 14 words for every call (`jka_host.c:21`), so a call with fewer words reads past the arguments the module passed. Raven does the same and says "the extra is thrown away" (`oracle/codemp/qcommon/vm.cpp:358-359`). C leaves this read undefined. The tests with 0 and 1 words pass on macOS arm64 and on Linux arm64 in the container.
5. Swift cannot name a C variadic function as a value. So `jka_load_dll` calls `dllEntry( VM_DllSyscall )` itself (`jka_host.c:44`) and takes no `systemcalls` parameter, where Raven's `Sys_LoadDll` gets it from `VM_Create` (`oracle/codemp/qcommon/vm.cpp:518`, `oracle/codemp/null/win_main.cpp:784-785`). The site has no `// AI:` line.
6. The host test finds `VM_DllSyscall` with `dlsym`, and on Linux that needs `--export-dynamic` through `unsafeFlags` (`Package.swift:87-93`). This is the one `unsafeFlags` in the package. SwiftPM refuses `unsafeFlags` in some packages that another package depends on, so a fork's mod target can meet it.
7. `jka_load_dll` keeps Raven's `FreeLibrary` as `dlclose` when a lookup fails (`jka_host.c:41`, `oracle/codemp/null/win_main.cpp:830`). The loader `jampsmoke` says that an unload of a Swift library is unsafe (`Sources/jampsmoke/main.swift:54`).
8. `jka_load_dll` uses `dlfcn.h` only (`jka_host.c:3`). A Windows `jampded` needs Raven's `LoadLibrary` and `GetProcAddress` (`oracle/codemp/null/win_main.cpp:803`, `:827-828`).
9. `CJKAZlib` links `z` (`Sources/CJKAZlib/module.modulemap:3`). On Windows the linker then looks for `z.lib`, and vcpkg names the library `zlib.lib`.
10. The version line drops Raven's `__DATE__` (`Sources/jampded/main.swift:23-24`), because Swift has no compile date. The site has an `// AI:` line, and no ruling covers the change.
11. `CPUSTRING` follows Raven's arms per platform: `MacOSX-other` on macOS (`oracle/codemp/game/q_shared.h:197`) and `linux-other` on Linux (`:276`). Raven defines none for a 64-bit Windows build, and the shell uses `win-x86` there under a `Port-note:` (`Sources/jampded/main.swift:17-19`).
12. `Q3_VERSION` is the `(internal)` arm of `oracle/codemp/qcommon/game_version.h:11`, because WinDed Release defines no `FINAL_BUILD` (`oracle/codemp/WinDed.vcproj:32`). The shell holds the text as a literal (`Sources/jampded/main.swift:7`), because the merged macro is only in `Sources/CJKAMP_UI/include/codemp/qcommon/game_version/constants.h:7` and the shell imports no MP header.
13. The `vmMain` pointer type has a fixed count of 12 words under a `Port-note:` (`Sources/CJKAHost/include/jka_host.h:21-22`), where Raven's `entryPoint` is variadic (`oracle/codemp/qcommon/vm_local.h:123`) and `VM_Call` passes 16 words (`oracle/codemp/qcommon/vm.cpp:816-819`).
