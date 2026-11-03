# The dedicated server opening docket

The rows that open the port of the MP dedicated server, the engine host. The scout note `dedicated-scout.md` in this folder holds the survey and every citation; its section 7 raises the fourteen questions below as rows E1 to E14. Each row carries a proposed default for a ratification walk. The ledger section at the end records every verdict.

## E1, the oracle source set

Raven's `WinDed.vcproj` is the port's oracle (`docs/porting-rules.md:3`), and it loads the game only through `dllEntry` and `vmMain` (`oracle/codemp/null/win_main.cpp:827-828`). OpenJK's `openjkded` is the binary that runs today, tries `GetModuleAPI` first (`openjk/codemp/server/sv_gameapi.cpp:2815`), and replaces Raven's RMG, terrain, zip, and QVM files with its own (scout section 1).

Proposed: stage 1 ports Raven's `WinDed.vcproj` Release link set, 130977 lines of source with the botlib compiled in. OpenJK's `GetModuleAPI` path, `sv_gameapi.cpp`, and its `shared/sys` files are not Raven and do not port. The fork's referee instrumentation is row E9.

## E2, the word width

Raven's `VM_Call`, `VM_DllSyscall`, and `SV_GameSystemCalls` take `int` (`oracle/codemp/qcommon/vm.cpp:363`, `:787`, `oracle/codemp/server/sv_game.cpp:458`). The Swift game speaks `intptr_t` (`Sources/CJKASyscall/include/jka_syscall.h:8`), as OpenJK does (`openjk/codemp/qcommon/vm.cpp:83`, `:285`).

Proposed: the host ABI takes `intptr_t` words under rule 19, because Raven's `int` holds a pointer only on an ILP32 build and is undefined on a 64-bit host. One `// AI:` line at the shim's typedef, none at the call sites.

## E3, the variadic callee

Swift cannot write a C variadic callee (`jka_syscall.h:14`), and the module calls `VM_DllSyscall( int arg, ... )` through the pointer `dllEntry` gave it.

Proposed: a C target `CJKAHost` beside `CJKASyscall` holds the variadic callee. It reads the words into a fixed array of 15 and calls one Swift function `SV_GameSystemCalls(words)`. It also holds `dlopen` and the `dllEntry` call, the mirror of `jampsmoke`'s loader. No other C code in the host.

## E4, the world rules for a host

Rules 3, 6, and 11 describe one module world and one `Syscall.transport` (`docs/porting-rules.md:12`, `:15`, `:28`). The host keeps 245 file-scope variables in the server, qcommon, null, and win32 files (scout section 3) and reads module memory through `SV_LocateGameData` (`oracle/codemp/server/sv_game.cpp:327`).

Proposed: the rules apply with the engine as the module. One `final class EngineWorld` in a logic target holds every file-scope variable under a MARK per Raven file, as `GameWorld` and `CGameWorld` do. A view target holds the views over `sharedEntity_t`, `playerState_t`, and the other module records the host reads at the base `SV_LocateGameData` gives, so rule 11's three places stay three.

## E5, the subsystems of stage 1

The game's syscalls reach the botlib (132 arms), Ghoul2 (48), NPCNav (42), ICARUS (19), ROFF (5), the RMG, and the terrain (scout section 2). The Swift game calls 38 botlib traps (`Sources/JKAMP_GameLogic/ai_main.swift:6628`), and bots are the only test load a dedicated server has without players.

Proposed: stage 1 ports qcommon, server, null, and win32 in Swift, and links Raven's botlib, Ghoul2, NPCNav, ICARUS, ROFF, RMG, and terrain as C++ compiled into the product behind one C header each, the way the game first stood on stubs. Each linked subsystem is its own later stage with its own docket, and the Ghoul2 server side goes first because its 48 arms carry the trace.

## E6, the unit kind

Every generator after the closure reads a `[targets]` row that assumes a trap file and a vmMain shell (`tools/oracle-closure/project.toml:14-23`, `traps.py:49-51`, `skeleton.py:782`, `:1131`). The skeleton skips every `.cpp` file and every C++ method (`skeleton.py:299-303`, `:351`), and the merge lists no engine module (`merge.py:44-50`).

Proposed: a third `[targets]` row `mp-engine-ded` of a new kind `host`. A `host` row names no trap file and no shell, the skeleton reads a `.cpp` file whose definitions are plain functions, and the merge gains the engine module. This is a tools stage before transcription, in the shape of the cgame's stage 3, and it is proven by one generator sequence over the unit with its counts in a record.

## E7, the C++ track scope

Rule 17 asks for a measured list of classes (`docs/porting-rules.md:42`). The unity parse holds 637 methods and 128 constructors and destructors, 394 and 69 of them in ICARUS (scout section 4), and the drafter reads no method.

Proposed: with E5 the classes of stage 1 are the ones in qcommon and server alone. The tools stage of E6 writes `cxx_only.txt` for the unit after E8 fixes the glob, and the measured list becomes the rows of a C++ docket before the first transcription round.

## E8, the unit glob

The `mp-engine-ded` glob takes 14 files WinDed does not compile and misses `server/NPCNav` (`project.toml:354-369`, `oracle/codemp/WinDed.vcproj:365-371`), and the unity parse reports 1051 redefinition errors.

Proposed: the glob becomes the WinDed Release list, file by file, with NPCNav in and the 14 out. The redefinition count after the change is the first number of the E6 record.

## E9, the proof of a host step

Rule 16 names jka-rust's `mp_app` and the lockstep referee (`docs/porting-rules.md:36`), which compares two game modules under one engine (`jka-rust/tools/lockstep-referee/run.sh:4-10`). The fork's stepper prints `REF STEP` checksums and records and replays inputs (`openjk/codemp/server/sv_referee.cpp:456-459`), and that instrumentation is OpenJK's, not Raven's.

Proposed: the Swift host carries the fork's referee cvars and `.rec` format as its one non-Raven piece, under rule 24 with the `// AI:` line at each site. One `.rec` file then drives the C host and the Swift host with the same Swift game, and a step is green when the two `REF STEP` streams match across the frames it claims. Rule 16 gains one sentence for the host.

## E10, the goldens

The huff, ghoul2-server, npcnav, icarus, roff, trmodel, stringed, gp2, rmg, and terrainmap harnesses hold committed goldens (scout section 5), and rule 18 says a Swift test reads them (`docs/porting-rules.md:43`).

Proposed: stage 1 copies the huff goldens into `JKATestSupport` with their Swift test, because the Huffman code is in qcommon. Each other golden set lands with the stage of its subsystem under E5.

## E11, the manifest and jka-rust's engine

`[targets]` names one crate under `jka-rust/crates/mp` (`project.toml:19`), and the engine is eight crates under `jka-rust/crates/mp/engine` (scout section 5).

Proposed: the `rust` field of a `host` row takes a list, and the `mp-engine-ded` row names `engine/qcommon`, `engine/server`, and `engine/core` for stage 1. The other five join with their stages.

## E12, the product

The package has two dynamic library products and no executable (`Package.swift:9-12`), and CI names products alone (`.github/workflows/build.yml:20`).

Proposed: an executable product `jampded`, Raven's name for the binary, with a shell target that holds `main`. CI gains `jampded` lanes for Linux and Windows in the zip shape of the module lanes, and still no macOS lane. The CI change is its own row by the CI ruling.

## E13, the QVM

Raven's `VM_Create` falls back to a QVM through `vm_interpreted.cpp` and `vm_x86.cpp` (`oracle/codemp/qcommon/vm.cpp:471`, `:518`, `WinDed.vcproj:285-291`), and OpenJK dropped both.

Proposed: out. The two files do not port, and `VM_Create` keeps only the dll arm with one `// AI:` line at the dropped fallback, as R17 kept a ruled dead stub.

Amended in the walk: the interpreter is self-contained and the load path is wired, and retail ships no `.qvm` only because Raven defaulted the three `vm_*` cvars to the dll. `vm_x86.cpp` emits x86 machine code, and Raven's own `DLL_ONLY` guard at `oracle/codemp/qcommon/vm.cpp:945-951` makes `VM_Compile` empty and `VM_CallCompiled` return 0.

Ratified as amended: in. `vm.cpp`, `vm_interpreted.cpp`, and `vm_local.h` port faithfully, and `VM_Create` keeps Raven's full arm order, the dll first and then `vm/<name>.qvm`. `vm_x86.cpp` does not port. `VMI_COMPILED` takes the interpreter on every host, with one `// AI:` line at `VM_Compile` that cites Raven's `DLL_ONLY` stub. The `vm_game` cvar keeps its three values. The stage 1 proof for the interpreter is a Swift test over a small QVM image, because no golden exists, and it lands with the qcommon rows rather than blocking the host gate.

## E14, the zip code

Raven reads a pk3 through its own `unzip.cpp` over `zlib32` (`oracle/codemp/qcommon/files_pc.cpp:1440`, `WinDed.vcproj:276`, `:879-894`), and OpenJK links minizip and zlib (`openjk/codemp/CMakeLists.txt:185-191`).

Proposed: `unzip.cpp` ports in Swift as part of qcommon, and the inflate calls go to the system zlib through a C target, because zlib is a library Raven did not write.

## The ledger

- E1, ratified as proposed, 2026-11-03.
- E2, ratified as proposed, 2026-11-03.
- E3, ratified as proposed, 2026-11-03.
- E4, ratified as proposed, 2026-11-03.
- E5, ratified as proposed, 2026-11-03. Amended on 2026-11-03 after the compile scout `dedicated-cxx-link-scout.md`, under the user's delegation "rule them automatically after proving them and making sure patterns match": the C++ link set is out. Raven's 72 files compile one in 72 unedited, and the link needs edited copies of Raven's C++, four unsafe compiler flags on a library target, `extern "C"` in copied headers against rule 12, and C storage for `sv`, `svs`, and `cmg` against E4, none of which the codebase holds. Stage 1 ports qcommon, server, null, and win32 in Swift, and every syscall arm of the botlib, Ghoul2, NPCNav, ICARUS, ROFF, RMG, and terrain is a `portMissing` body, the one stub form the skeleton writes, until its subsystem ports in its own stage. The first host proof is a referee corpus with no bot and no NPC, as row H11 of the referee docket sets. An arm a corpus reaches is measured by the trap it raises, and the Ghoul2 stage opens first on that measure, as the row already orders.
- E6, ratified as proposed, 2026-11-03.
- E7, ratified as proposed, 2026-11-03.
- E8, ratified as proposed, 2026-11-03.
- E9, ratified as proposed, 2026-11-03.
- E10, ratified as proposed, 2026-11-03.
- E11, ratified as proposed, 2026-11-03.
- E12, ratified as proposed, 2026-11-03.
- E13, ratified as amended: the QVM interpreter is in, `vm_x86.cpp` is out, 2026-11-03.
- E14, ratified as proposed, 2026-11-03.
