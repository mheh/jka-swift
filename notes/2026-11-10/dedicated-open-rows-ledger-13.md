# The open rows of the dedicated host, the thirteenth ledger

This record holds the rows of the thirteenth batch: the proofs `rows-13-g2.md`, `rows-13-bot.md`, and `rows-13-eng.md`, the rulings of the user of 2026-11-10, and the rows that need no code. The landing is the branch `dedicated-rulings-13`, off master at `03223d0`, in the worktree `/tmp/jka-rulings-13`. The batch is hand code and docs only, and it changes no generator file.

The authority "auto ruled by proof" means the row follows the proof and the precedent cited beside it, under the delegation of 2026-11-03. The authority "the user's typed word, 2026-11-10" means the user ruled the row by his own word. Every Raven cite is under `oracle/codemp/`, every fork cite is under `openjk/`, and every Swift cite is under `Sources/`.

## The rows

| Row | Verdict | Authority | Status |
| --- | --- | --- | --- |
| R1, G2_Set_Bone_Rag | The `blist` parameter drops, and the body reads `ghoul2.mBlist` | auto ruled by proof G1: every Raven caller passes the `mBlist` of the same instance (`ghoul2/G2_bones.cpp:1651`, `:4671`), and the bone cache reads that list (`renderer/tr_ghoul2.cpp:1551`), precedent `CBoneCache.swift:70` and `GenericParser2.swift:192` | landed, `b89ade3` |
| R2, G_G2_LISTBONES and G_G2_LISTSURFACES | Each arm takes model 0 of the instance that the word names, with a rule 19 Port-note | auto ruled by proof G2, candidate A: Raven reads the 4-byte `CGhoul2Info_v` as a `CGhoul2Info` (`server/sv_game.cpp:1316` to `:1322`, `ghoul2/ghoul2_shared.h:328`), precedent the Z6 form of `GameViews.swift:224` | landed, `9b9d11c` |
| R3, the BotReplaceSynonyms thunk | The sized-buffer form with the capacity `MAX_MESSAGE_SIZE` and one AI line | auto ruled by proof B1, candidate A: Raven gives no bound, and the one internal caller holds `temp[MAX_MESSAGE_SIZE]` (`botlib/be_ai_chat.cpp:2247`, call `:2293`), precedent the 16 sized thunks of `be_interface.swift` | landed, `9572e94` |
| R4, the ROFF note arm | `withTextWord` in `VmEntry.swift`, the text twin of `withVectorWords`, and the arm calls VM_Call inside it | auto ruled by proof B2: Raven passes the address of `temp` (`qcommon/RoffSystem.cpp:929`, `:957`), precedent row SV3 at `VmEntry.swift:75` | landed, `8549891` |
| R5, CleanTextPool | The not-ported form, `// Not ported: row C3 makes the text pool a String ...` | auto ruled by proof B3: ruling C3 makes the text pool a String, and `CGenericParser2::Clean` drops the call (`qcommon/GenericParser2.cpp:212`, `:907`), precedent `Cvar_FreeString` at `cvar.swift:56` and the form of `skeleton.py:1440` | landed, `27d0a51` |
| R6, the `0` flag on `%d` and `%i` | The `i` and `d` case passes `zeroPad`, the X38 form | auto ruled by proof E2: C pads with zeros after the sign, precedent the `%x` case of `Format.swift` | landed, `f77a924` |
| R7, the float `M_PI` | The 43 sites compute what Raven's line computes with the float `M_PI` | auto ruled under the user's word "autorule", 2026-11-10: `docs/transcription.md:635` rules the float `M_PI` of `game/q_shared.h:548`, and rule 18 (`docs/porting-rules.md:43`) now names `golden/qmath.txt` as its one exception | landed on the branch `dedicated-mpi-sweep`: the sweep `e3dd988` (the cherry-pick of `652c2e1`), the dumper patch `bd469d9`, and rule 18 `ecc78d9`. The cost: 17 lines of one golden no longer come from jka-rust |
| R8, a function with no caller | It gets its real body like any other function, with a one-line note that it has no caller and why | the user's typed word, 2026-11-10 | landed for the docs, `52e3b4f`, and open for the bodies until the dead-function body wave |
| R9, the reference host of the referee | The fork at `35e4184f`, built with `-ffp-contract=off` | the user's typed word, 2026-11-10 | landed, `0bacadf` and `4ad3a46` |
| R10, the dead stubs of the game and cgame targets | Rule 20 is one rule for all units, so `CG_ParticleExplosion` gets its body | the user's typed word, 2026-11-10 | open until the dead-function body wave |
| R11, the `CRMInstance` hierarchy | The enum form of rule 17 in the shape below | the user's typed word, 2026-11-10 | open until the body wave writes the classes |
| R12, the heading of rule 20 | "Preserve emergent per-mode quirks and port dead surface.", so the heading agrees with the body of R8 | auto ruled under the user's word "autorule", 2026-11-10 | landed, `842097e` |
| The first-frame hitch | No change | auto ruled by proof E1: the port follows the Windows dedicated link set, `null/win_main.cpp:1222` | closed |
| The `ref_dump` line form | No change | auto ruled by proof E5: Raven's WinDed ends a line on every print, `null/win_main.cpp:38` | closed |
| `g_maxForceRank 7` on both proof lines | The H8 form, the cvar on the line of each host | auto ruled by the form of row H8: the fork registers 7 (`openjk/codemp/server/sv_init.cpp:943`), and Raven registers 6 (`server/sv_init.cpp:816`) | landed earlier, `81ebedf` |
| G2_GorePolys and G2_Get_Bone_Name | Each gets its body in the body wave under R8, and neither is a DEAD row | the user's typed word, 2026-11-10, through R8 | open until the dead-function body wave |

## The details

### R1

The 24 live calls drop the argument. Raven's two commented calls at `G2_bones.swift:1349` and `:1350` stay as he wrote them, so the 26 calls of the proof are 24 changes and 2 comments. The function keeps `mod_a`. `G2_Find_Bone_Rag` does not read `ghoul2.mBlist` inside its body, so the `inout` access of the list has no overlap.

### R2

Both arms read the word through `args.VMA(1)`, because Raven's `VMA(x)` is `(void *)args[x]` (`server/sv_game.cpp:401`), so his `args[1]` of the surfaces arm is the same word. A NULL word or an empty vector traps.

### R3

The thunk also keeps the low 32 bits of `unsigned long context`, with the AI line of `BotFindMatch`, because the C type of the field is the host's 64-bit `unsigned long`.

### R6

The tests hold `%02d`, `%03d`, `%2d`, `%-2d`, and `-5` under `%03d`. A C program printed the expected text: `05`, `12`, `007`, `1234`, ` 5`, `5 `, `-5`, `-05`, `-12`, `1:05`.

### R7

`Float.pi` is `0x40490fda`, and Raven's `3.14159265358979323846f` is `0x40490fdb`, so `Float.pi` is not the float `M_PI`. Every site uses `JKAShared.M_PI` of `Sources/JKAShared/q_shared.h.swift:4`, which has the right value, and the qualifier breaks the tie with Foundation's double. `q_math.swift` is in `JKAShared`, so it reads the bare `M_PI`. "MP" below is `JKAShared.M_PI`.

| Swift site | Raven site | Before | After |
| --- | --- | --- | --- |
| `g_misc.swift:1088` | `g_misc.c:1159` | `sin(M_PI * Double(random) / 180)` | `sin(Double(MP * random / 180))` |
| `w_force.swift:4135`, `:4174`, `:4226` | `w_force.c:4730`, `:4777`, `:4845` | `Float(Double(..) * (M_PI * 2) / 255)` | `((level.time / 12) & 255) * (MP * 2) / 255`, in float |
| `g_mover.swift:2161` | `g_mover.c:2298` | `1 / (M_PI * 2)` in double | `Double(1 / (MP * 2))` |
| `bg_misc.swift:536` | `bg_misc.c:1780` | `/ Double.pi` | `/ Double(MP)` |
| `bg_misc.swift:1103`, `:1164` | `bg_misc.c:2368`, `:2433` | `sin` or `cos(Double(dt) * Double.pi * 2)` | `sin` or `cos(Double(dt * MP * 2))` |
| `bg_misc.swift:1125`, `:1180` | `bg_misc.c:2393`, `:2450` | `cos(Double(deg) * Double.pi / 180)` | `cos(Double(DEG2RAD(deg)))` |
| `cg_view.swift:1065`, `:1192`, `:1723` | `cg_view.c:1139`, `:1296`, `:1896` | `tan(Double(fov_x / 360) * M_PI)` | `tan(Double(fov_x / 360 * MP))` |
| `cg_view.swift:1067`, `:1194`, `:1725` | `cg_view.c:1141`, `:1298`, `:1898` | `Float(Double(fov_y * 360) / M_PI)` | `fov_y * 360 / MP`, in float |
| `cg_view.swift:1199` | `cg_view.c:1303` | `* M_PI * 2` | `* Double(MP) * 2` |
| `cg_draw.swift:7155`, `:7164`, `:7173` | `cg_draw.c:8088`, `:8098`, `:8108` | `* M_PI * 2` | `* Double(MP) * 2` |
| `cg_view.swift:1485` | `cg_view.c:1601` | `/ 127.0 * M_PI` | `/ 127.0 * Double(MP)` |
| `cg_localents.swift:712` | `cg_localents.c:684` | `sin(Double(c * 2) * M_PI)` | `sin(Double(c * 2 * MP))` |
| `cg_players.swift:7682`, `:7703`, `:8250` | `cg_players.c:9114`, `:9137`, `:9763` | the double form | `timeStep * (MP * 2) / 255`, in float |
| `cg_players.swift:7723`, `:8259` | `cg_players.c:9159`, `:9770` | the double form | `(degrees / MP) + 90`, in float |
| `cg_players.swift:8268` | `cg_players.c:9778` | the double form | `timeStep * (MP * 2) / 255 + MP`, in float |
| `cg_players.swift:8278` | `cg_players.c:9786` | `0.5 * M_PI` | `0.5 * Double(MP)` |
| `cg_players.swift:8281` | `cg_players.c:9787` | the double form | `360 - (degrees / MP)`, in float |
| `cg_players.swift:8290` | `cg_players.c:9795` | the double form | `Float(Double(timeStep * (MP * 2) / 255) + 0.5 * Double(MP))` |
| `ui_shared.swift:5220` | `ui/ui_shared.c:5827` | the `tan` argument in double, `* (360 / M_PI)` | the `tan` argument in float, `* Double(360 / MP)` |
| `cm_terrain.swift:64` | `cm_terrain.cpp:1108` | Foundation's double `M_PI` | `sin(MP / 2 * 3 + (1.0 - lerp) * (MP / 2)) + 1.0`, the C++ float overload |
| `q_math.swift:348` | `q_math.c:447` | the double form | `rad = DEG2RAD(degrees)` |
| `q_math.swift:410`, `:421` | `q_math.c:500`, `:513` | `/ Double.pi` | `/ Double(M_PI)` |
| `q_math.swift:1039`, `:1042`, `:1045` | `q_math.c:1320`, `:1323`, `:1326` | the double form | `angles[X] * (M_PI * 2 / 360)`, in float |
| `q_math.swift:1127`, `:1131` | `q_math.c:1414`, `:1417` | a double local `scale` | `truncateToInt(Double(RAD2DEG(v) * (255.0 / 360.0)))` |
| `q_math.swift:1278`, `:1354` | `q_math.c:1595`, `:1661` | the double form | `cos(Double(DEG2RAD(theta)))` |

The proof held at all 43 sites, and no site stayed as it was. The 13 sites that cannot differ have no change: the 8 lines of `Q_acos` and `Q_asin` in `common.swift`, `ui_shared.swift:5763`, and `cg_players.swift:8269`, `:8271`, `:8291`, `:8293`. The comments at `bg_misc.swift` 535, 1102, 1123, 1163, 1178, `q_math.swift` 409, 1038, 1125, and `cm_terrain.swift` 63 now state the float `M_PI`. The comment above `q_math.swift:348` is gone, because the line is Raven's.

The commit also changes the golden `Sources/JKATestSupport/Oracle/golden/qmath.txt`. The old golden came from the jka-rust qmath dumper built on the host, where `<math.h>` defines the double `M_PI` before the `#ifndef M_PI` of `q_shared.h`. So 17 lines held the double form, and `QMathParityTests` failed after the sweep. The same dumper with `#undef M_PI` after `<math.h>` gives the Swift output byte for byte, and without the `#undef` it gives the old golden byte for byte. The new golden is the output with the `#undef`, and the README of the goldens names this one difference from the jka-rust copy. No file of jka-rust changed.

An independent rebuild proves the golden. The harness `jka-rust/tools/jampgame-oracle` at jka-rust `1cb6c525` was copied to `/tmp/mpi-out/oracle/`, with the oracle source at `4bebb8ec` and the jka-rust fixtures. Without the change, the qmath dumper gives 4645 lines, equal byte for byte to `golden/qmath.txt` of master. With the one line `#undef M_PI` after `#include <math.h>` in the shim of `run.sh`, it gives 4645 lines, equal byte for byte to the golden of `e3dd988`. The 17 changed lines are these records:

- `va`, 4 lines: `vectoangles`.
- `rad`, 5 lines: `RotateAroundDirection`, on the axis of `AnglesToAxis`.
- `av`, 2 lines: `AngleVectors`.
- `a2a`, 2 lines: `AnglesToAxis`.
- `rot`, 2 lines: `RotatePointAroundVector`.
- `acopy`, 1 line: `AxisCopy`, on the axis of `AnglesToAxis`.
- `gclose`, 1 line: `G_FindClosestPointOnLineSegment`.

`Sources/JKATestSupport/Oracle/qmath-float-mpi.patch` records the change as a patch to `run.sh`, and the README of the goldens tells how to resync with it. The same `#undef M_PI` in the shims of `run.sh` and `run_bgmisc.sh` changes 18 records of `golden/pmove.txt` and 8 records of `golden/bgmisc.txt` (the `et` and `ed` fields of `BG_EvaluateTrajectory` and `BG_EvaluateTrajectoryDelta`). These two goldens stay unchanged copies, and no Swift test compares them with the port.

The gate of the branch `dedicated-mpi-sweep`: `swift build -j 2` exit 0, `swift test --no-parallel -j 2` 161 tests pass, and `swift build -c release -j 2 --product jampded` exit 0. The referee ran with the reference host of `/tmp/jka-rulings-13/.build/openjk-nocontract/openjkded.arm64` as host A: `SCRATCH=/tmp/referee-scratch-mpi FRAMES=2400 tools/host-referee.sh corpus-ffa1.rec <host A> .build/release/jampded`. The run is green: 2400 equal `REF STEP` lines, from `n=1 t=425 ck=3cfa876c` to `n=2400 t=60400 ck=c7559f41`. The fork engine keeps the double `M_PI`, and no engine site differs in this corpus.

### R8

The last sentence of rule 20 (`docs/porting-rules.md:45`) now reads that a function with zero callers gets its real body like any other function, and that it carries a one-line note that says it has no caller and why. `docs/transcription.md` and `docs/oracle-closure.md` hold no sentence of the old form. Row R12 changes the heading "drop dead surface" to "port dead surface", so the heading agrees with the new sentence.

### R9

The reference host of every referee step is the OpenJK fork at the pinned commit `35e4184f`, built with `-ffp-contract=off`. This amends row H14 of `notes/2026-11-03/dedicated-referee-docket.md` in one point: the flag is part of the definition of the reference binary. The submodule pin does not move, no line of `openjk/` changes, and no Swift code or Swift build setting changes. The flag makes the reference evaluate the source text one `float` operation at a time with one IEEE rounding each, which the port's rules require of the Swift (`docs/transcription.md:631` to `:636`) and which the other oracle build scripts of the project already do. A green run proves that, for the frames of the recording and with one Swift game module, the Swift engine and the OpenJK engine at `35e4184f` give the same state checksum after each frame, when both do one IEEE rounding for each `float` operation with no contraction. It does not prove equality with the retail server, which is x87 code and a third evaluation model (`notes/2026-11-10/float-semantics.md`). The authority is the user's typed word, 2026-11-10. The user ratified on the reason first given, the investigation `notes/2026-11-10/float-semantics.md` then corrected the reason, and the choice of reference is unchanged.

The flag covers the whole build, because the fused instructions are many and two of them already matter in this corpus. A bisection of the fork build with `g_maxForceRank 7` on both lines gives these facts:

- Contraction off in the endpos block of `CM_Trace` only (`openjk/codemp/qcommon/cm_trace.cpp:1447`), or in all of `cm_trace.cpp`: frames 1 to 26 are equal, and frame 27 differs.
- Contraction off in `DotProduct` only (`openjk/shared/qcommon/q_math.c:1220`): 2397 lines are equal, and frames 1410, 1546, and 1566 differ. So `DotProduct` causes frame 27.
- Contraction off in `DotProduct` and in the endpos block: all 2400 lines are equal. So the endpos line causes frame 1410.
- Contraction off for the whole build: all 2400 lines are equal.
- The H14 binary holds 863 fused scalar instructions and 27 vector `fmla` instructions in 115 functions. 63 of those functions are in files the server runs each frame: 34 in `q_math`, 22 in the Ghoul2 files, and 7 in the `cm_` files.

`tools/build-referee-host.sh` builds the reference out of tree into `.build/openjk-nocontract/openjkded.arm64`, with the configuration of `notes/2026-10-09/engine-build.md` and only `BuildMPDed=ON`. It fails if `otool` finds a fused multiply and add in the binary. The check finds 863 in the H14 binary and 0 in the new one. `tools/host-referee.sh` takes the reference as host A by default and refuses a SCRATCH that is the root folder, that is in the repository, or that holds it, after it resolves the links. The record `dedicated-referee-port.md` now names the two causes.

The space in the Steam base path: the defect is in neither the script's quoting nor the port. Raven's `main` joins `argv` with a space and no quotes (`null/win_main.cpp:1425` to `:1434`), and the port does the same (`Sources/jampded/main.swift:33`). `Com_ParseCommandLine` then splits at `+`, and the tokenizer splits `fs_basepath` at the space. The fork quotes an argument with a space (`openjk/shared/sys/sys_main.cpp:764` to `:774`), which is an OpenJK change. So the script gives both hosts a link with no space, `$SCRATCH/basepath`, to the base path. `BASE_PATH` can override the Steam default.

The referee run through the script: `SCRATCH=/tmp/referee-scratch-13 FRAMES=2400 tools/host-referee.sh corpus-ffa1.rec .build/release/jampded`, with the debug module of this branch in both homepaths (shasum `32a1a0b583f3e49dbbac579ec06bdef12cbac7f8`). The `REF READY` lines are equal, each host prints 2400 `REF STEP` lines, the diff is empty, and each host prints `REF REPLAY END` once. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=2400 t=60400 ck=c7559f41`. The run is green in 65 s. The last checksum differs from the one of the referee port, because the game module of R7 differs, and both hosts run the same module.

### R10

The one dead stub of the game and cgame targets is `CG_ParticleExplosion` (`Sources/JKAMP_CGameLogic/cg_marks.swift:1554`, Raven `cgame/cg_marks.c:1496`). It gets its body in the dead-function body wave.

### R11

The `CRMInstance` hierarchy (`RMG/RM_Instance.h:25`) has four subclasses that `RM_InstanceFile.cpp:158` to `:177` makes by name: bsp, group, random, and void. The form is the enum of rule 17 (`docs/porting-rules.md:42`), and it is the first hierarchy of the port and the example for later ones:

1. One `final class CRMInstance` holds the base fields, as Raven's base class does.
2. It holds one field `kind`, an enum with the four cases `bsp`, `group`, `random`, and `void`, and each case carries the fields that its Raven subclass adds.
3. Each virtual method is one method on `CRMInstance` with a `switch self.kind`, and a case that Raven's subclass does not override runs the base body.
4. The body of each override stays in the file of its Raven subclass, as an extension method with Raven's name in its doc line, so each Swift file maps to one Raven file.

### G2_GorePolys and G2_Get_Bone_Name

Proofs G3 and G4 show that the server never calls either function: G2_GorePolys runs only for a nil collision map, and the callers of G2_Get_Bone_Name stand under `_DEBUG_BONE_NAMES` and in the `#ifndef DEDICATED` arm. Under R8 each gets its body, with a one-line note that gives that reason. No DEAD row is added.

## The rows for the generator batch

- R5: a NOT_PORTED row `"CleanTextPool"` in `rulings.py` with the reason of the Swift line. `GenericParser2.swift` is adopted, so no run undoes the hand change, and the row records the ruling in the table.
- R8: the comment of `DEAD` at `tools/oracle-closure/rulings.py:1507` and the comment at `tools/oracle-closure/bodies.py:220` state the old form of rule 20. Each DEAD row then needs a decision: a body in the body wave, with its reason as the one-line note.
- R1 needs no row: `G2_bones.swift` is adopted, and the GenericParser2 drops have no PARAMS row either.

## The gate

- `swift build -j 2`: exit 0.
- `swift test --no-parallel -j 2`: 161 tests pass, the 156 of master and the 5 tests of R6.
- `swift build -c release -j 2 --product jampded`: exit 0.
- `JOBS=2 tools/build-referee-host.sh`: exit 0, no fused multiply and add.
- The referee: green, 2400 equal `REF STEP` lines.
