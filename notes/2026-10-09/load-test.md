# The first load test under the real engine

This note records the first load of the Swift `jampgame` under the OpenJK dedicated server `.build/openjk/openjkded.arm64`. The goal is a map load where `G_InitGame` returns with no `portMissing` trap. The engine loads the module, and `G_InitGame` runs to Raven's first `G_LogPrintf` call. There it stops at a `vsprintf` hole that the guide has no form for, so the fix loop stops there.

## Setup

These commands ran from the repository root, one per call:

```sh
swift build
mkdir -p /tmp/jka-load/home/swift
cp -f .build/debug/libjampgame.dylib /tmp/jka-load/home/swift/jampgamearm64.dylib
```

`cp` follows the link `.build/debug/libjampgame.dylib` and copies the library file. The library links only system libraries under `/usr/lib` and `/System/Library`, so `dlopen` needs no `rpath`. The mod folder `swift` sits under the scratch homepath, so the mod pass of the engine finds it first. Neither `.build/openjk/` nor `base` of the Steam folder holds a game module, so no other module can win.

## The server command line

```sh
.build/openjk/openjkded.arm64 \
    +set fs_homepath /tmp/jka-load/home \
    +set fs_basepath "$HOME/Library/Application Support/Steam/steamapps/common/Jedi Academy/SWJKJA.app/Contents" \
    +set fs_game swift \
    +set dedicated 2 \
    +set sv_pure 0 \
    +set vm_game 0 \
    +map mp/ffa1 \
    +quit \
    > /tmp/jka-load/run1.log 2>&1
```

`tools/load-test.sh` holds the same steps. It builds the library, removes the scratch homepath, copies the library, and runs the server with these arguments. It writes the log to `/tmp/jka-load/server.log` and prints the tail. Extra arguments go to the server before `+map`, for example `tools/load-test.sh +set g_log ""`.

## Two traps of the test harness

The first run did not end. A `portMissing` trap does not stop the engine. The engine prints the fatal line, sends its master server heartbeats, and starts its shutdown. The shutdown calls `G_ShutdownGame`, which calls `G_LogWeaponOutput`, and that function traps at its first hole, `g_log.swift:205`. After the second trap the process hangs. The run went past the 120-second limit of the call, and `kill -9` stopped it. The script now runs the server under `perl -e 'alarm shift; exec @ARGV' 60`, so the process ends after 60 seconds with exit status 142, which is `SIGALRM`.

The shutdown also calls `G_SaveBanIP`, which writes `banip.txt` into the mod folder. The next run reads that file in `G_LoadIPBans` and calls `COM_BeginParseSession`, which calls `Com_sprintf` and traps at `q_shared.c.swift:956`. This trap is in `Sources/JKAShared/`, and it is not on the path of a clean first run. The script now removes the scratch homepath before each run.

## The loader result

The module loads through the legacy ABI, as engine-build.md predicts:

```
OpenJK-MP: vUNKNOWN macosx-arm64 Oct  9 2026
23773 files in pk3 files
VM_Create: jampgamearm64.dylib failed!
VM_CreateLegacy: jampgamearm64.dylib succeeded
------- Game Initialization -------
gamename: basejka
gamedate: unknown
G_LoadBanIP - ERROR: can't open banip.txt
JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_LogPrintf, source: oracle/codemp/game/g_main.c:2213
```

`VM_Create` fails because the library has no `GetModuleAPI`. `VM_CreateLegacy` finds `dllEntry` and `vmMain`. `GAME_INIT` calls `G_InitGame`, and the first three `G_Printf` lines and the `G_LoadBanIP` line come from the Swift code through the engine.

## The trap table

| Order | Function | File:line | Raven line | The hole's text | Result |
| --- | --- | --- | --- | --- | --- |
| 1 | `G_LogWeaponInit` | `Sources/JKAMP_GameLogic/g_log.swift:96-125` before the fill | `g_log.c:110-119` | ten Port-notes, "Raven's `memset(G_WeaponLogPickups, 0, sizeof(G_WeaponLogPickups))` runs over bytes that are not one record with a view", one per array | filled, `G_WeaponLogPickups.fill(0)` and nine more |
| 2 | `G_LogPrintf` | `Sources/JKAMP_GameLogic/g_main.swift:2202` | `g_main.c:2214` | "A pointer local `va_list argptr` with no view." | docket row 1 |
| 3 | `G_LogPrintf` | `Sources/JKAMP_GameLogic/g_main.swift:2219-2225` | `g_main.c:2227-2229` | "A read of `argptr`, a local the draft left as a hole." over `va_start`, `vsprintf( string +7 , fmt,argptr )`, and `va_end` | docket row 1 |
| 4 | `G_LogPrintf` | `Sources/JKAMP_GameLogic/g_main.swift:2228` | `g_main.c:2232` | "The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'CharBuf' to expected argument type 'Int'"." over `G_Printf( "%s", string + 7 )` | filled, `G_Printf("%s", string[7...])` |
| 5 | `G_LogWeaponOutput`, in the shutdown | `Sources/JKAMP_GameLogic/g_log.swift:205` | `g_log.c:246` | "A pointer local `char * nameptr` with no view." | not on the path of `G_InitGame`, left as is |
| 6 | `Com_sprintf`, from `COM_BeginParseSession` in `G_LoadIPBans` | `Sources/JKAShared/q_shared.c.swift:956` | `q_shared.c:991` | "The guide has no form for `vsprintf` into a buffer from the variadic arguments." | outside `Sources/JKAMP_GameLogic/`, docket row 2 |
| 7 | `Q_strcat`, from `WP_SaberLoadParms` | `Sources/JKAShared/q_shared.c.swift:881` | `q_shared.c:936` | "The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'CharBuf'"." over `Q_strncpyz( dest + l1, src, size - l1 )` | outside `Sources/JKAMP_GameLogic/`, docket row 3 |

Rows 1 to 4 come from the fix loop. Row 1 was the first trap of the first run, before the fill. Rows 2 to 4 are the holes of `G_LogPrintf`, which `G_InitGame` calls at `g_main.swift:1048` because `g_log` defaults to `games.log`. Row 4 has a guide form, the suffix subscript for a read through a pointer into a buffer, so it is filled. Rows 2 and 3 have no form, so the loop stops at row 2. A first fill of row 3 as `strcpy(&string, format(fmt, args), at: 7)` built and ran. The `Com_sprintf` port carries a Port-note that says the guide has no form for `vsprintf`, so the fill went back out before the commit.

Row 5 is the trap in the shutdown that hangs the process. Row 6 is the trap that a stale `banip.txt` gives. Row 7 comes from one probe run outside the loop, with `+set g_log ""` and no code change. With no log file, `G_InitGame` passes `G_LogWeaponInit` with the fill, `G_InitWorldSession`, the clear of the entities and clients, and `trap_LocateGameData`. It stops in `WP_SaberLoadParms` at `Sources/JKAMP_BG/bg_saberLoad.swift:2182`, Raven's `Q_strcat( marker, MAX_SABER_DATA_SIZE-totallen, bgSaberParseTBuffer )` at `bg_saberLoad.c:2778`. The call path is `vmMain` (`jampgame.swift:43`), `G_InitGame` (`g_main.swift:1084`), `WP_SaberLoadParms`, the `at:` overload of `Q_strcat` (`q_shared.c.swift:889`), and `Q_strcat` (`q_shared.c.swift:881`).

The iterations of the loop were these:

| Run | Log | Code | First trap |
| --- | --- | --- | --- |
| 1 | `/tmp/jka-load/run1.log` | `f8ba6cd` with the ten fills of row 1 | row 2, then row 5, then the hang |
| 2 | `/tmp/jka-load/run2.log` | the first fill of row 3, now withdrawn | row 6, from the `banip.txt` of run 1 |
| 3 | `/tmp/jka-load/run3.log` | rows 2 and 3 back as holes | row 6, from the `banip.txt` of run 2 |
| 4 | `/tmp/jka-load/run4.log` | the commit, from a clean homepath | row 2 |
| probe | `/tmp/jka-load/probe.log` | the commit, with `+set g_log ""` | row 7 |

Run 1 printed the trap in `G_LogPrintf` after the line from `G_LoadBanIP`. The `srand` hole that dispatch-fill-2.md names was already filled, so the run passed it.

## The state at the end

`G_InitGame` does not return. It stops at `G_LogPrintf`, `g_main.swift:2202`, the first `G_LogPrintf` call at `g_main.swift:1048`. The guide has no form for Raven's `va_list` and `vsprintf`, so the fix loop stops there after four runs. Behind that stop, the next known stop is `Q_strcat` in `Sources/JKAShared/`, which this task does not touch.

The gate before the commit of the fills passed. `swift build` completed with 0 errors. `swift test --no-parallel` passed 112 tests in four binaries, 84, 14, 13, and 1. The JKAShared binary has 84 tests because the other agent added tests in its q_shared round. `git status --short` showed no file of the other agent at the time of the gate.

## Hashes

| Commit | Subject |
| --- | --- |
| `0126e9f` | The G_InitGame path fills, 1 |
| this commit | The record of the first load test |

## Docket rows

1. The `vsprintf` of `G_LogPrintf` into an offset of a local buffer. Raven writes `vsprintf( string +7 , fmt,argptr )` between `va_start` and `va_end`. The proposed form is `strcpy(&string, format(fmt, args), at: 7)`, with the `va_list` declaration, `va_start`, and `va_end` dropped under the variadic form. Each part is a form of the guide: `format` of `Format.swift`, the `at:` offset of `strcpy`, and "`va_start` and `va_end` go with the variadic form". The guide does not name `vsprintf` itself, and the `Com_sprintf` port says that no form exists. The proposed default is to write this form into `docs/transcription.md` next to `va`, and then fill the four holes of `G_LogPrintf` and the `vsprintf` holes of `G_Printf`-shaped callers.
2. The `vsprintf` of `Com_sprintf` into `bigbuffer`, `q_shared.c.swift:956`. The proposed form is `strcpy(&bigbuffer, format(fmt, args))` with `len = strlen(bigbuffer)`, because `vsprintf` returns the count of bytes it wrote. The `Com_Error( ERR_FATAL, ... )` hole at `q_shared.c.swift:960` needs `ERR_FATAL` in scope in `JKAShared`. This row belongs to the q_shared hole round, and it blocks every map load that finds a `banip.txt`.
3. The `Q_strncpyz( dest + l1, src, size - l1 )` of `Q_strcat`, `q_shared.c.swift:881`. The guide reads a pointer into a buffer as a byte offset, and a write through it as the `at:` form. `Q_strncpyz` has no `at:` overload. The proposed form is an `at:` overload of `Q_strncpyz` beside the one of `Q_strcat`, so the line reads `Q_strncpyz(&dest, src, size - l1, at: l1)`. This row belongs to the q_shared hole round, and it blocks `WP_SaberLoadParms` in every map load.
4. The trap in the shutdown. `G_LogWeaponOutput` traps at its first hole, `g_log.swift:205`, and the engine then hangs after the second fatal error. Every run of the load test with a trap in `G_InitGame` hangs this way until the hole is filled or the script ends the process. The proposed default is to keep the 60-second alarm of `tools/load-test.sh` and to fill `G_LogWeaponOutput` in the g_log hole round, because the first clean `+quit` needs it.
5. The master server heartbeats. With `dedicated 2`, the server resolves `masterjk3.ravensoft.com` and `master.jkhub.org` and sends heartbeats, also after a trap. The proposed default is `+set dedicated 1` in `tools/load-test.sh`, which is a LAN server with no heartbeat.

## The second run

The second run builds the rulings L1 and L5 of `load-test-walk.md` and continues the trap loop from `WP_SaberLoadParms`.

### The rulings and the script changes

The guide's `vsprintf` form in `docs/transcription.md` has the offset case of L1: Raven's `vsprintf(string + 7, fmt, argptr)` is `strcpy(&string, format(fmt, args), at: 7)`, and the `va_list` local, `va_start`, and `va_end` drop. `G_LogPrintf` in `Sources/JKAMP_GameLogic/g_main.swift` fills its four holes under that form, and its Port-notes and `portMissing` calls are gone. `tools/load-test.sh` sets `dedicated` to 1 under L5. The server log of the run has no line with `heartbeat` or `master`. The script keeps the 60-second alarm of L4.

The gate before the commit `5bb5372` passed. `swift build` completed with 0 errors. `swift test --no-parallel` passed 112 tests in four binaries, 84, 14, 13, and 1.

### The trap table

| Order | Function | File:line | Raven line | The hole's text | Result |
| --- | --- | --- | --- | --- | --- |
| 1 | `ClearRegisteredItems` | `Sources/JKAMP_GameLogic/g_items.swift:2807` before the fill | `g_items.c:2999` | "Raven's `memset( itemRegistered, 0, sizeof( itemRegistered ) )` runs over bytes that are not one record with a view." | filled, `itemRegistered.fill(false)`, the fill form with `false` for a `qboolean` element |
| 2 | `G_AddSpawnVarToken` | `Sources/JKAMP_GameLogic/g_spawn.swift:321-341` | `g_spawn.c:853`, `860`, `861`, and `865` | four holes: "A pointer local `char * dest` with no view.", "A store into `dest`, a local the draft left as a hole." over `dest = level.spawnVarChars + level.numSpawnVarChars`, "Raven's `memcpy( dest, string, l+1 )` runs over bytes that are not one record with a view.", and "A read of `dest`, a local the draft left as a hole." over `return dest` | docket row S1 |
| 3 | `G_LogWeaponOutput`, in the shutdown | `Sources/JKAMP_GameLogic/g_log.swift:203` | `g_log.c:246` | "A pointer local `char * nameptr` with no view." | recorded, not filled, under L4 |

Row 1 traps at `g_main.swift:1104`, after `WP_SaberLoadParms` at `g_main.swift:1084`. So the `Q_strncpyz(_:_:_:at:)` overload of Q4 unblocks `WP_SaberLoadParms`, and the saber files load with no trap. Row 2 traps after `InitSiegeMode`, the two `trap_Cvar_Register` calls, and `trap_Nav_Load`. By the order of `G_InitGame`, the call is `G_SpawnEntitiesFromString` at `g_main.swift:1115`, then `G_ParseSpawnVars`, then `G_AddSpawnVarToken` at `g_spawn.swift:525`. The guide has no form for Raven's `memcpy` of a text into a byte offset of a buffer, so the loop stops at row 2. Row 3 follows each trap in `G_InitGame`, and the process then hangs until the alarm ends it with exit status 142.

The iterations of the loop were these:

| Run | Code | First trap |
| --- | --- | --- |
| 1 | `5bb5372` | row 1, then row 3, then the alarm |
| 2 | `5bb5372` with the fill of row 1, committed as `ec0f08f` | row 2, then row 3, then the alarm |

The script writes each run to `/tmp/jka-load/server.log`, so the log on disk is the log of run 2.

The tail of run 2, without the `InitGame:` line of the server info that follows the dashed line:

```
VM_Create: jampgamearm64.dylib failed!
VM_CreateLegacy: jampgamearm64.dylib succeeded
------- Game Initialization -------
gamename: basejka
gamedate: unknown
G_LoadBanIP - ERROR: can't open banip.txt
------------------------------------------------------------
JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_AddSpawnVarToken, source: oracle/codemp/game/g_spawn.c:851
JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_LogWeaponOutput, source: oracle/codemp/game/g_log.c:227
```

The dashed line and the `InitGame:` line with the server info come from the first two `G_LogPrintf` calls, through `G_Printf`, so the L1 fill runs. The file `games.log` in the mod folder has 0 bytes after the run. The process ends on `SIGALRM`, so an unflushed engine write is one possible cause. This note does not check the cause.

### Where G_InitGame stands

`G_InitGame` does not return. It stops in `G_AddSpawnVarToken`, the first function of the entity parse, at `g_spawn.swift:321`. The loop stopped after two runs, because row 2 has no guide form. The holes after row 2 on the same path are known from the file, not from a run:

- `AddSpawnField`, `g_spawn.swift:352`, a compile hole over the `Q_stricmp` test of `level.spawnVars[i][0]`, a `String?`.
- `SP_worldspawn`, `g_spawn.swift:560`, a compile hole over the `Q_stricmp` test of `level.spawnVars[i][0]` and the `BG_ParseField` call.
- `G_SpawnEntitiesFromString`, `g_spawn.swift:729`, a compile hole over the test of `behaviorSet[BSET_SPAWN]` of the world entity.

### Hashes

| Commit | Subject |
| --- | --- |
| `5bb5372` | The G_LogPrintf fills and the LAN server |
| `ec0f08f` | The G_InitGame path fills, 2 |
| this commit | The record of the second load test |

### Docket rows

S1. The text copy of `G_AddSpawnVarToken` into `level.spawnVarChars`. Raven sets `dest = level.spawnVarChars + level.numSpawnVarChars`, copies `l+1` bytes with `memcpy`, where `l = strlen( string )`, and returns `dest`. The guide reads a `char *` over a named buffer that a use writes as a write cursor, a byte offset `Int32`. It reads a write through the cursor as the `at:` form of `strcpy`, and a read through it as the suffix subscript. The guide has no form for `memcpy` of a text. The proposed form treats a `memcpy` of `strlen + 1` bytes of a `String` as `strcpy`, because both copy the text and its NUL, and nothing else:

```swift
let dest: Int32
...
dest = level.numSpawnVarChars
strcpy(&level.spawnVarCharsBuffer, string, at: dest)

level.numSpawnVarChars += l + 1

return String(level.spawnVarCharsBuffer[dest...])
```

The return is a `String` by the signature, and the callers store it into `level.spawnVars`, whose setter interns it in the string pool. So the pointer in `spawnVars` points into the pool and not into `spawnVarChars` as in Raven. The text is the same. The proposed default is to write the form into the section "C string functions" of `docs/transcription.md` and to fill the four holes.

## The third run

The third run builds the rulings S1, S2, and M1, and continues the trap loop from `G_AddSpawnVarToken`.

### The rulings

S1: `Sources/JKAShared/q_shared.c.swift` has `private let ERR_FATAL: Int32 = 0` and `private let ERR_DROP: Int32 = 1` at the top, under `/// Source: oracle/codemp/game/q_shared.h:451`. The nine `Com_Error` calls are filled by hand, and their Port-notes and `portMissing` calls are gone. `swift build` gave 0 errors, so the private names collide in no file that imports `JKAMP`. S2: the section "The print" of `g_main-resplice.md` has the `bodies.py --stem <stem>` step before `printer.py --compile-holes`.

M1: the section "C string functions" of `docs/transcription.md` has the form for a `memcpy` of `strlen + 1` bytes of a `String`. `G_AddSpawnVarToken` fills its four holes with that form. The level property for Raven's `spawnVarChars` as a buffer is `spawnVarCharsBuffer`, the name the walk record used, and the count is `numSpawnVarChars`.

The gate before each commit passed. `swift build` completed with 0 errors. `swift test --no-parallel` passed 112 tests in four binaries, 84, 14, 13, and 1.

### The trap table

| Order | Function | File:line | Raven line | The hole's text | Result |
| --- | --- | --- | --- | --- | --- |
| 1 | `G_SpawnString` | `Sources/JKAMP_GameLogic/g_spawn.swift:41`, `49`, and `55` before the fill | `g_spawn.c:10`, `15-18`, and `21` | three compile holes, "The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'"." over `*out = (char *)defaultString` twice and the `Q_stricmp` test of `level.spawnVars[i][0]` | filled, the force unwrap of an optional stored into a value or passed where a value is due, `level.spawnVars[i][0]!` and `out = defaultString!`; see docket row T2 |
| 2 | `AddSpawnField`, found by reading | `g_spawn.swift:342` before the fill | `g_spawn.c:874` | the same compile hole over the `Q_stricmp` test of `level.spawnVars[i][0]` | filled, the force unwrap |
| 3 | `SP_worldspawn`, found by reading | `g_spawn.swift:550` before the fill | `g_spawn.c:1277` | the same compile hole over the `Q_stricmp` test and the `BG_ParseField` call | filled, the force unwrap, and `UnsafeMutableRawPointer(g_entities[ENTITYNUM_WORLD].handle)` for Raven's `(byte *)` cast, with the comment that names rule 11, the guide's form for a caller of `BG_ParseField` |
| 4 | `G_SpawnEntitiesFromString`, found by reading | `g_spawn.swift:719` before the fill | `g_spawn.c:1454` | "The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Character' to expected argument type 'Int'"." over the test of `behaviorSet[BSET_SPAWN]` and the script runner block | filled, `behaviorSet[BSET_SPAWN] != nil && !behaviorSet[BSET_SPAWN]!.isEmpty`, `if let script_runner` for Raven's guard, and `Think.scriptrunner_run` for the store of the callback |
| 5 | `G_CallSpawn`, found by reading | `g_spawn.swift:173` before the fill | `g_spawn.c:701` | "Raven walks `spawns` by pointer, and the hand table is a Swift array of rows with no view. A walk over it has no form yet." | filled, the index local `sIndex` of the pointer walk, with the count of `spawns` in place of Raven's `{0, 0}` row |
| 6 | `G_NewString`, found by reading | `g_spawn.swift:193`, `203`, and `210` before the fill | `g_spawn.c:725`, `732`, and `736-747` | "A pointer local `char * new_p` with no view.", "A store into `new_p`, a local the draft left as a hole.", and the compile hole "binary operator '==' cannot be applied to operands of type 'Character' and 'Int32'" over the loop body | filled, `new_p` is a write cursor, an `Int32` offset into `newb`, `*new_p++ = c` is `newb[byte: new_p] = c` and `new_p += 1`, and `string` becomes a `CharBuf` at the top of the body |
| 7 | `G_SpawnGEntityFromSpawnVars`, found by reading | `g_spawn.swift:223`, `227`, `230`, `239`, `276`, `280`, and `283` before the fill | `g_spawn.c:769`, `770`, `776`, `810`, `812`, and `813` | three locals with no view or type, `char *s`, `char *gametypeName`, and `static char *gametypeNames[]`, the `BG_ParseField` note "A Slots over one record has no form yet.", and the store and read holes of `gametypeName` and `s` | filled, `s` is the `Int32?` offset that `strstr` returns, `gametypeName` is a `String`, `gametypeNames` is a `[String]` property of `GameWorld` with a forward, and the `BG_ParseField` call passes `fields`, the `Slots<BgField>` of `GameTables.swift` |
| 8 | `G_Alloc` | `Sources/JKAMP_GameLogic/g_mem.swift:24`, `34`, `39`, and `45` | `g_mem.c:17`, `25`, `28`, and `32` | "A pointer local `char * p` with no view.", "Raven returns NULL, and the function returns a `UnsafeMutableRawPointer`.", "A store into `p`, a local the draft left as a hole." over `p = &memoryPool[allocPoint]`, and "A read of `p`, a local the draft left as a hole." over `return p` | docket row T1 |
| 9 | `G_LogWeaponOutput`, in the shutdown | `Sources/JKAMP_GameLogic/g_log.swift:203` | `g_log.c:246` | "A pointer local `char * nameptr` with no view." | recorded, not filled, under L4 |

Row 1 traps first. It is the loop of `G_SpawnString`, which `SP_worldspawn` reaches through `G_SpawnFloat("distanceCull", ...)`. Rows 2 to 7 are on the same path, and the loop filled them by reading before the next run. `G_SpawnGEntityFromSpawnVars` held a trap at its entry, so no entity after the worldspawn could spawn without row 7. The `strstr` of row 7 needs a `String` haystack, so `Sources/JKAShared/CString.swift` gains the overload `strstr(_: String, _: String)`, in the shape of the `String` overloads of `strchr`.

Row 8 traps after `SP_worldspawn`. By the order of the code, the call is `G_SpawnEntitiesFromString` at `g_main.swift:1115`, then `G_SpawnGEntityFromSpawnVars`, then `BG_ParseField` of the `classname` key, then `G_NewString` at `bg_misc.swift:166` through the bg channel, then `G_Alloc` at `g_spawn.swift:206`. `memoryPool` is a `CharBuf` of `GameVariables`, a Swift value with no fixed address, and `G_Alloc` returns an `UnsafeMutableRawPointer` into it. The guide has no form for that pointer, so the loop stops at row 8.

The iterations of the loop were these:

| Run | Code | First trap |
| --- | --- | --- |
| 1 | `66a4dbe` | row 1, then row 9, then the alarm |
| 2 | `66a4dbe` with the fills of rows 1 to 7, committed as `2de188c` | row 8, then row 9, then the alarm |
| probe | `2de188c`, with `+set g_logSync 1` | row 8, then row 9, then the alarm |

The log on disk at `/tmp/jka-load/server.log` is the log of the probe. The tail of run 2, with the `InitGame:` line cut:

```
VM_CreateLegacy: jampgamearm64.dylib succeeded
------- Game Initialization -------
gamename: basejka
gamedate: unknown
G_LoadBanIP - ERROR: can't open banip.txt
------------------------------------------------------------
InitGame: \version\OpenJK-MP: vUNKNOWN macosx-arm64 Oct  9 2026\...
JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_Alloc, source: oracle/codemp/game/g_mem.c:16
JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_LogWeaponOutput, source: oracle/codemp/game/g_log.c:227
```

### The empty games.log

`G_InitGame` opens `games.log` with `FS_APPEND` when `g_logSync` is 0, the engine buffers the writes, and the `SIGALRM` ends the process before the engine closes the file, so `games.log` has 0 bytes after run 2 and 879 bytes, the two `G_LogPrintf` lines, after the probe with `g_logSync 1`.

### Where G_InitGame stands

`G_InitGame` does not return. It stops in `G_Alloc`, `g_mem.swift:24`, under the first `G_NewString` call of the entity parse. `SP_worldspawn` runs to its end before the stop. The loop stopped after two runs and one probe, because row 8 has no guide form. The server does not reach the frame loop, so this run shows no `G_RunFrame` trap.

### Hashes

| Commit | Subject |
| --- | --- |
| `e229e7c` | The error constants of q_shared and the printer step |
| `66a4dbe` | The memcpy of a text as a strcpy at a cursor |
| `2de188c` | The G_InitGame path fills, 3 |
| this commit | The record of the third load test |

### Docket rows

T1. The bump pool of `G_Alloc`. Raven sets `p = &memoryPool[allocPoint]` and returns `p`, a pointer into the static `char memoryPool[POOLSIZE]`. The port holds `memoryPool` as a `CharBuf` of `GameVariables`, which has no fixed address, and the guide's table gives `G_Alloc` an `UnsafeMutableRawPointer` return. Rule 9 keeps `G_Alloc` a bump pool over `memoryPool` and `allocPoint` on the world. The proposed form is the shape of `bg_pool`: `memoryPool` joins `HAND_VARS` of `rulings.py` as one raw allocation of `POOLSIZE` bytes that the world owns and frees, and the stub forwards it under Raven's name. `G_Alloc` then writes `let p: UnsafeMutableRawPointer`, `p = memoryPool + allocPoint` with the `+` of `RawField.swift`, and `return p`. The `return NULL` after `G_Error` drops, because `G_Error` is `-> Never` under rule 22, so the line has no path.

T2. The NULL default of `G_SpawnString`. The fill of row 1 writes `out = defaultString!`, the guide's force unwrap for an optional stored into a value. `G_SpawnGEntityFromSpawnVars` calls `G_SpawnString("gametype", nil, &value)` at `g_spawn.swift:274`. Raven stores NULL into `value` and returns `qfalse`, and the caller reads nothing. The unwrap traps on each entity with no `gametype` key, a place where Raven does not crash, so this trap is the next stop behind T1. The proposed form follows the `out_string` NULL form of the guide: the store keeps the caller's text when the default is NULL, `if defaultString != nil { out = defaultString! }`, at the two stores of `defaultString`.
