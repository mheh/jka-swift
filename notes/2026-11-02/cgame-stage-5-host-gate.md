# The cgame stage 5, the host gate

The record of stage 5 of the cgame on 2026-11-02, the host gate, on the branch `cgame-stage-5-host-gate` off the round 12 branch at `e673f7b`. The docket is `notes/2026-10-31/cgame-host-gate-docket.md`. Every row is ruled as proposed. H5 is ruled: stage 5 ships on the build, the tests, the smoke run, and one listen-server run by a person, and the client referee is a later fork branch.

## The rows

Each row is one commit, and H2 is two commits by the CI ruling. The checks ran once after the last row.

- H7, the access levels. Every function that a vmMain arm calls is public, as the game's `G_InitGame` is public. The arms of cg_main.c call the `C_` wrappers, `C_PointContents`, `C_GetLerpOrigin`, `C_GetLerpData`, `C_Trace`, `C_G2Trace`, `C_G2Mark`, and `C_ImpactMark`, so these are public and `CG_Trace`, `CG_G2Trace`, `CG_PointContents`, and `CG_ImpactMark` stay internal. `CG_RagCallback`, `CG_NoUseableForce`, `CG_DoCameraShake`, `CG_Error`, `Com_Error`, and `Com_Printf` are public. The inline arms read `cg`, `cgs`, `cg_entities`, `cgDC`, `cg_autoMapInput`, `cg_autoMapInputTime`, and `cg_autoMapAngle`, so these are public too. Commit 7cc9fdf.
- H6, the D10 move. `channel.py` no longer writes `bg.error` and `bg.print` into the install of a consumer other than the game. The generator sequence ran for both units: `extract.py` over the eight merge modules, `merge.py`, `tables.py`, `check.sh`, `reexport.py`, and `views.py`, `traps.py`, `channel.py`, `skeleton.py`, and `manifest.py` for each unit. `BgChannel.swift` of the cgame lost the two lines. The `cg_draw`, `cg_drawtools`, and `cg_effects` manifests took the line moves of the round 12 bodies. No other file changed. Commit 0edd87c.
- H1, the shell. `Sources/cgame/cgame.swift` mirrors `jampgame.swift`. `dllEntry` sets the transport, a fresh `CGameWorld` with the rule 24 line of the game, `BgState(consumer: .cgame, maxPoolSize: 2_048_000)` with the `bg_misc.c:3314` cite, the two channel lines, `installBgChannel()`, and `sharedChannel`. `vmMain` has the 32 arms of `cg_main.c:190-355` in Raven's order, and each inline body stays in its arm. The default arm calls `CG_Error` as Raven does, so Swift needs no fall-through return. The shell keeps the two word decoders of the game shell, `int32` and `text(at:)`. `Package.swift` adds the `cgame` target in the shape of the `jampgame` target. The `vmMain` note in `cg_main.swift` now names `Sources/cgame/cgame.swift`. Commit 030f82c.
- H2, the product. `.library(name: "cgame", type: .dynamic, targets: ["cgame"])` stands beside the jampgame product. `tools/load-test.sh` copies `libcgame.dylib` as `cgamearm64.dylib` beside `jampgamearm64.dylib`, the form of the game copy. Commit b355b83.
- H2, the CI part. `.github/workflows/build.yml` builds `--product cgame` on Linux and Windows and packages `cgamex86_64.so` and `cgamex86_64.dll` in the zip shape of the game lanes. No macOS lane runs. The release job waits for the two new lanes. Commit 36095d4.
- H3, the loader. `jampsmoke` takes the library path, the command number, the expected answer, and up to twelve argument words. It exits 1 when the answer differs. The game smoke sends `39 4 1 6`, `GAME_GETITEMINDEXBYTAG`. The cgame smoke sends `5 -1`, `CG_LAST_ATTACKER` after `dllEntry`, and the fresh world answers -1. Commit ad52a17.
- H4, the tests. `JKAMP_CGameTests` on `JKAMP_CGameLogic` and `JKATestSupport` mirrors `JKAMP_GameTests`. Its suite holds the transport test first, then a typed `CG_PRINT` call, then `CG_LastAttacker` on a fresh world. `cgameTests` on `CJKAMP_CGame` runs the loader on the cgame library as a process. Commit 49dc783.

## The checks

- `swift build` passes, and `swift build -c release` passes.
- `swift test --no-parallel` passes 117 tests across its runs of 1, 1, 84, 13, 3, and 15. The run of 1 after the game smoke is `CgameSmokeSuite`, and the run of 3 is `SyscallCGameSuite`.
- The smoke run by hand on the debug build: `jampsmoke libcgame.dylib 5 -1` prints `answer -1`, `command 0`, and `text`, exit 0. `jampsmoke libjampgame.dylib 39 4 1 6` prints `answer 4`, `command 0`, and `text`, exit 0.
- `snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-shared`: 372 files, no difference. The snapshot holds the bg, game, and shared stems, and H6 moves the cgame channel only.
- The tool tests: 96 tests, OK, 14 skipped.

## The listen-server run

A person does this run once. It loads the Swift cgame in a client that is also the server. The client log shows a `portMissing` trap if one occurs. No reference run exists to compare against.

SwiftPM writes the cgame library to `.build/debug/libcgame.dylib`. The engine loads the module by the name `cgamearm64.dylib`, from the `"%s" ARCH_STRING DLL_EXT` name of `../OpenJK/shared/sys/sys_main.cpp:605`. The engine looks for the file in the mod folder of the homepath, `/tmp/jka-client/home/swift/`, because `fs_game` is `swift`. The engine calls `dllEntry` and `vmMain` through the legacy ABI, because the Swift module exports no `GetModuleAPI`.

1. Go to the root of the repository.
2. Run `swift build`.
3. Make sure that the build passes.
4. Make the folder `/tmp/jka-client/home/swift`.
5. Remove the old `jampgamearm64.dylib` and the old `cgamearm64.dylib` from that folder.
6. Copy `.build/debug/libjampgame.dylib` to `/tmp/jka-client/home/swift/jampgamearm64.dylib`.
7. Copy `.build/debug/libcgame.dylib` to `/tmp/jka-client/home/swift/cgamearm64.dylib`.
8. Start the client `.build/openjk/openjk.arm64` with these settings: `+set fs_homepath /tmp/jka-client/home`, `+set fs_basepath` with the Steam folder `SWJKJA.app/Contents`, `+set fs_game swift`, `+set sv_pure 0`, `+set vm_game 0`, `+set vm_cgame 0`, and `+devmap mp/ffa1`.
9. Send the output of the client to a log file with a shell redirect.
10. When the map loads, move the player and fire a weapon.
11. Quit from the game menu.
12. Read the log file for a `portMissing` trap or a crash.
13. Write the result in a new record under `notes/`.

## The rows left open

- The client referee, the H5 ruling. A client referee needs a `CL_CgameSystemCalls` wrapper, a `VM_CGAME` trace in `VM_Call`, a client frame gate, and a legacy-ABI force for the cgame. It becomes its own fork branch and docket, with the trace format of the jka-rust shim under `jka-rust/tools/cgame-referee/` as its precedent.
- The listen-server run above waits for a person.
- `CG_INIT` stays out of the smoke until a fake that knows the client and renderer traps exists.
