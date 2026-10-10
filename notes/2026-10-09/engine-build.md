# The OpenJK engine build and the game module load

This note records how the OpenJK multiplayer engine builds on this Mac, and how the engine finds and loads the Swift `jampgame` library. The engine tree is the submodule `openjk/` at commit `35e4184f` on branch `referee` of `https://github.com/mheh/OpenJK.git`. Its working tree is clean. The build is out of tree, and no file in `openjk/`, `jka-rust/`, or `oracle/` changed.

## Prerequisites

The Mac is arm64. Homebrew holds every build dependency, so the build installed nothing:

- `cmake` 4.4.3
- `sdl2-compat` 2.32.72, which Homebrew gives for `sdl2`
- `jpeg-turbo` 3.2.0, `libpng` 1.6.59, `zlib` 1.3.2

The configure step takes zlib from the macOS SDK. On Apple, the OpenJK CMake defaults use the bundled libjpeg and libpng (`openjk/CMakeLists.txt:80-83`). OpenGL and OpenAL come from the system frameworks. The client links `/opt/homebrew/opt/sdl2-compat/lib/libSDL2-2.0.0.dylib`.

## Configure and build

Run these two commands from the repository root:

```sh
cmake -S openjk -B .build/openjk -DCMAKE_BUILD_TYPE=Release \
  -DBuildSPEngine=OFF -DBuildSPGame=OFF -DBuildSPRdVanilla=OFF \
  -DBuildJK2SPEngine=OFF -DBuildJK2SPGame=OFF -DBuildJK2SPRdVanilla=OFF \
  -DBuildMPEngine=ON -DBuildMPDed=ON -DBuildMPRdVanilla=ON -DBuildMPRend2=OFF \
  -DBuildMPGame=ON -DBuildMPCGame=ON -DBuildMPUI=ON \
  -DMakeApplicationBundles=OFF
cmake --build .build/openjk --config Release -j 10
```

The flags have these reasons:

- `BuildMPGame=ON` builds the stock C game module as a control. Nothing installs it, so it does not shadow the Swift library. It exports `GetModuleAPI`, `dllEntry`, and `vmMain`.
- `BuildMPCGame=ON` and `BuildMPUI=ON` build the stock cgame and ui, which the client needs.
- `MakeApplicationBundles=OFF` keeps the engines as flat executables. Without a `.app`, the default `fs_basepath` and `fs_apppath` are the binary directory, with no bundle strip.
- `BuildMPRend2=OFF` and the SP and JK2 flags remove targets that a map load does not need.

The configure step warns "Unable to determine Git tag", so the version string is `vUNKNOWN`. That warning is harmless. The build takes about 30 seconds and has no errors.

## Build result

| Binary | Path |
| --- | --- |
| Dedicated server | `.build/openjk/openjkded.arm64` |
| Client | `.build/openjk/openjk.arm64` |
| Renderer | `.build/openjk/codemp/rd-vanilla/rd-vanilla_arm64.dylib` |
| Stock game module | `.build/openjk/codemp/game/jampgamearm64.dylib` |
| Stock cgame | `.build/openjk/codemp/cgame/cgamearm64.dylib` |
| Stock ui | `.build/openjk/codemp/ui/uiarm64.dylib` |

A start test of the dedicated server ran with `+set fs_basepath <Steam Contents> +set fs_homepath .build/openjk-home +quit`. The server mounted `assets0.pk3` to `assets3.pk3` and `assets6.pk3`, a total of 23773 files, and stopped clean. The test loaded no map.

The client loads `rd-vanilla_arm64.dylib` through `Sys_LoadDll`, which tries the binary directory and then `fs_basepath` (`openjk/shared/sys/sys_main.cpp:300-344`, `openjk/codemp/client/cl_main.cpp:2427`). The build puts the renderer in a subfolder. Before a client run, copy the renderer next to `openjk.arm64` or into `fs_basepath`.

## The loading rule

### The file name

The engine names the game module `jampgame` (`openjk/codemp/qcommon/vm.cpp:33-37`). It adds `ARCH_STRING` and `DLL_EXT` (`openjk/shared/sys/sys_main.cpp:472` and `:605`). On macOS arm64, `ARCH_STRING` is `"arm64"` and `DLL_EXT` is `".dylib"` (`openjk/shared/qcommon/q_platform.h:111-116`). The file name is therefore `jampgamearm64.dylib`, with no `lib` prefix.

### The entry points

`SV_BindGame` (`openjk/codemp/server/sv_gameapi.cpp:2803-3145`) tries two ABIs in this order:

1. `VM_Create` calls `Sys_LoadGameDll`, which opens the library and looks up `GetModuleAPI` (`openjk/codemp/qcommon/vm.cpp:155-188`, `openjk/shared/sys/sys_main.cpp:600-670`). If the symbol is missing, it closes the library and returns NULL.
2. Then `SV_BindGame` falls back to the legacy ABI (`openjk/codemp/server/sv_gameapi.cpp:3139-3144`). `VM_CreateLegacy` calls `Sys_LoadLegacyGameDll` (`openjk/codemp/qcommon/vm.cpp:115-153`). That function looks up `dllEntry` and `vmMain`, calls `dllEntry(VM_DllSyscall)`, and keeps `vmMain` (`openjk/shared/sys/sys_main.cpp:467-548`). If either symbol is missing, the load fails with `ERR_DROP` "VM_CreateLegacy on game failed".

The engine never looks up a symbol named `GetGameAPI`. That name is only the local function pointer type in `SV_BindGame` (`sv_gameapi.cpp:3127-3128`), which holds the `GetModuleAPI` result.

This fork has a referee switch. When `sv_refTrace`, `sv_stepper`, `sv_recordInputs`, or `sv_replayInputs` is set, `SVRef_ForceLegacy` returns true (`openjk/codemp/server/sv_referee.cpp:548-553`). `SV_BindGame` then goes directly to `VM_CreateLegacy` and skips the `GetModuleAPI` attempt (`sv_gameapi.cpp:2811-2813`).

The legacy types are `VMMainProc(int, intptr_t x 12)` and `SystemCallProc(intptr_t, ...)` (`openjk/shared/sys/sys_public.h:96-97`). `VM_DllSyscall` is variadic and reads 16 words with `va_arg` (`openjk/codemp/qcommon/vm.cpp:83-95`).

### The search order

Both loaders call `Sys_LoadDllFromPaths` with `SEARCH_PATH_BASE | SEARCH_PATH_MOD` (`openjk/shared/sys/sys_main.cpp:384-459`, `:525`, `:658`). The path list is `fs_homepath`, `fs_apppath` (Mac only), `fs_basepath`, `fs_cdpath` (`sys_main.cpp:507-523`). The mod pass tries `<path>/<fs_game>/jampgamearm64.dylib` for every path in the list. After that, the base pass tries `<path>/base/jampgamearm64.dylib` for every path in the list. The first file that `dlopen` opens wins.

`FS_BuildOSPath` replaces an empty `fs_game` with `fs_gamedir`, which is `base` (`openjk/codemp/qcommon/files.cpp:520-536`). With no `fs_game`, both passes look in `base`.

The defaults are as follows:

- `fs_homepath` is `~/Library/Application Support/OpenJK` (`openjk/shared/sys/sys_unix.cpp:491-499`, `openjk/codemp/qcommon/files.cpp:3576-3580`).
- `fs_basepath` is the binary directory. `main` sets it from `DEFAULT_BASEDIR` (`openjk/shared/sys/sys_main.cpp:735-739`, `:761`).
- `fs_apppath` is the binary directory (`sys_main.cpp:93-96`, `files.cpp:3596`).

Two other paths do not apply here. Before the path search, both loaders try an old Mac bundle zipped inside a pk3 (`Sys_LoadMachOBundle`, `sys_main.cpp:352`, `:500`, `:633`), and the stock assets hold no such bundle. Unpack from a pk3 applies only when `com_unpackLibraries` is 1, and its default is 0 (`sys_main.cpp:169`). `FS_FindPureDLL` looks for `jampgamex86.dll` under `sv_pure`, and the loaders ignore its result (`files.cpp:1647-1666`).

### The shadow

`~/Library/Application Support/OpenJK/base/` already holds a `jampgamearm64.dylib` from an earlier project. It exports `dllEntry` and `vmMain` and has no `GetModuleAPI`. The same folder also holds `cgamearm64.dylib` and `uiarm64.dylib`. Because `fs_homepath` comes first in the search, these files win over any library in `base` of `fs_basepath`. A load of the Swift module must use one of these two methods:

- Set `fs_game` to a mod folder, and put the Swift library at `<fs_basepath>/<fs_game>/jampgamearm64.dylib`. The mod pass runs before the base pass on all paths.
- Set `fs_homepath` to a scratch folder such as `.build/openjk-home`. The start test above used this method.

## The Swift library

`swift build --product jampgame` uses the swiftbuild layout. The output is `.build/debug/libjampgame.dylib`, a link to `.build/out/Products/Debug/libjampgame.dylib`. A release build gives `.build/release/libjampgame.dylib`. The install name is `@rpath/libjampgame.dylib`. The library links the system Swift runtime under `/usr/lib/swift`.

`nm -gU` shows two entry symbols, `_dllEntry` and `_vmMain`, from `@_cdecl` in `Sources/jampgame/jampgame.swift:11` and `:25`. The library has no `_GetModuleAPI` and no `_GetGameAPI`.

The legacy ABI is the path that matches. `Sys_LoadGameDll` finds no `GetModuleAPI`, closes the library, and `SV_BindGame` falls back to `VM_CreateLegacy`, which finds both symbols. The file name does not match. SwiftPM writes `libjampgame.dylib`, and the engine opens `jampgamearm64.dylib`. A copy or a symbolic link with the engine name closes this gap. No change to the Swift sources is necessary.

`vmMain` in Swift takes `command` as `Int`, and the C type is `int`. The shell reads it with `Int32(truncatingIfNeeded:)`, so the high bits of the register have no effect.

## Assets

The Steam copy holds the base assets at `~/Library/Application Support/Steam/steamapps/common/Jedi Academy/SWJKJA.app/Contents/base/`:

- `assets0.pk3`, 561806019 bytes
- `assets1.pk3`, 652804510 bytes
- `assets2.pk3`, 1116384 bytes
- `assets3.pk3`, 9282026 bytes
- `assets6.pk3`, 291967 bytes

Use `.../SWJKJA.app/Contents` as `fs_basepath`. Other complete sets of `assets0.pk3` to `assets3.pk3` are in `~/Developer/jka/jka_server/base`, `~/Developer/jka/g2-server/base`, `~/Developer/jka/openjk-ref/base`, and `~/Developer/jka/jamp-mixed/base`. `~/Developer/jka/openjk-ref/base` also holds a `jampgamearm64.dylib`. `~/Library/Application Support/OpenJK/base` holds no `assets*.pk3`. No GOG copy and no copy under `/Applications` exist.

## Open items that block a map load

1. The engine opens `jampgamearm64.dylib`, and SwiftPM writes `libjampgame.dylib`. A copy or a link with the engine name must go into the mod folder or the scratch homepath.
2. The old `jampgamearm64.dylib`, `cgamearm64.dylib`, and `uiarm64.dylib` in `~/Library/Application Support/OpenJK/base` shadow the new libraries. Use `fs_game` or a scratch `fs_homepath`.
3. The `vmMain` shell answers only `GAME_INIT`, and that arm prints one line and does not call `G_InitGame`. A map load calls `GAME_RUN_FRAME` and other commands, and each arm stops in `portMissing`. A map can start, but the first frame stops the server.
4. The client needs `rd-vanilla_arm64.dylib` next to `openjk.arm64` or in `fs_basepath`. The dedicated server does not need it.
5. A dedicated server run with `+set fs_game <mod> +map <name>` is the first test. It reads `ERR_DROP` or the `portMissing` text from the console log.
