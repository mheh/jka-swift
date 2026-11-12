# Rows E1 to E5, proofs

## E1. The first-frame hitch: SETTLED, no change

- The port follows Raven's WinDed link set. `notes/2026-11-03/dedicated-stage-1-tools.md:7` names it file by file from `oracle/codemp/WinDed.vcproj:138-894`. WinDed links `null/win_main.cpp` (`WinDed.vcproj:394`) and `win32/win_shared.cpp` (`:448`). It does not link `win32/win_main.cpp` or `unix/`.
- The linked line is `oracle/codemp/null/win_main.cpp:1221`: `ev.evTime = timeGetTime();`. The port has it at `Sources/JKAMP_DedLogic/win_main.swift:900`.
- On Windows, `timeGetTime` gives the time since Windows started, in milliseconds. `lastTime` is a static that starts at 0 (`common.cpp:1601`). So Raven's retail WinDed measures the uptime on frame one, prints `Hitch warning`, and clamps to 5000. The port does the same thing.
- The ruling "do not adulterate Raven" applies (`notes/2026-11-03/dedicated-round-cvar.md:27`, `notes/2026-10-27/unattended-replays.md:3`). Rule 19 does not apply, because this behavior is defined.
- The referee is not affected. The 2400 frames are green with the warning present, because the gate forces `msec` and clears `timeResidual` (`notes/2026-11-10/dedicated-referee-port.md:55`).
- jka-rust follows the unix oracle: `ev.evTime = sys_milliseconds(...)` (`jka-rust/crates/mp/engine/qcommon/src/sys_engine.rs:428`, file header "Behavior source: unix_main.c"). It uses a different platform file, so it is not a precedent for this port. OpenJK uses `Sys_Milliseconds()` (`shared/sys/sys_event.cpp:93`).

## E2. The `0` flag on `%d` and `%i`: SETTLED, the X38 form

- `Format.swift:100-107` reads the `0` flag for every conversion. The `i`/`d` case (`:152-159`) calls `pad` without `zeroPad`, and the comment at `:163` says so. The result is wrong output, not a trap: the padding is spaces.
- There are three sites in all of `Sources/`:
  1. `JKAMP_CGameLogic/cg_draw.swift:6576`, `va("%i:%02i", minutes, seconds)`. Today it prints `1: 5`. C prints `1:05`.
  2. `JKAMP_DedLogic/z_memman_pc.swift:343`, `(%2d.%02dMB)`. Today it prints ` 1. 5MB`. C prints ` 1.05MB`.
  3. `JKAMP_DedLogic/l_log.swift:91-93`, the `portMissing` hole of `Log_WriteTimeStamped`, with `%02d` four times. This function is dead (docket-11-proofs row 5).
- No test asserts `%0Nd` or `%0Ni`.
- Change: in `Format.swift:156-159`, pass `zeroPad: zeroPad` to `pad`. `pad` already puts the zeros after the sign (`:230-235`). Then update the header at `:1` and the comment at `:163`.
- The cgame snapshot cannot change. `tools/oracle-closure/snapshot.py:3-5` holds generator text from the oracle tables only. `Format.swift` is a hand file and is not in that text. The claim "the cgame snapshot moves" in docket-11-proofs row 5 is wrong. Only the runtime text changes.

## E3. `M_PI`: SETTLED by the doc line

- Raven's WinDed gets the float `M_PI` in every translation unit:
  - `q_shared.h:82` includes `<math.h>` before `:547 #ifndef M_PI`.
  - MSVC `math.h` defines `M_PI` only under `_USE_MATH_DEFINES`. No file in `oracle/codemp` defines `_USE_MATH_DEFINES`, and the WinDed defines are `WIN32,NDEBUG,_CONSOLE,DEDICATED,BOTLIB,_WINDOWS` (`WinDed.vcproj:32`).
  - The double `M_PI` of `Splines/` is not linked.
- Of the 56 sites in ledger 9, 43 can give a different result. Each one computes in float with the float `M_PI`, or widens the float `M_PI` value (`atan2(...)*180/M_PI`), where Swift uses `Double.pi`.
- 13 sites cannot give a different result:
  - The 8 lines of `Q_acos`/`Q_asin` (`common.swift:1957-1977`). Every return value is the same float, and `asin` never comes near π.
  - `ui_shared.swift:5763`. The float result is equal, checked with numpy.
  - `cg_players.swift:8269`, `:8271`, `:8291`, `:8293`. The values are equal, and the compares cannot hit 2πf, because t=127.5 and t=191.25 are not integers.
- `docs/transcription.md:635` (ratified in ledger 9) rules the float form, so the sweep applies a ruled form.
- Referee path:
  - Both hosts run the same Swift game module (H13). Because of this, the game, BG, and q_math sites change both hosts the same way.
  - The engine sites are `cm_terrain.swift:64`, which does not run on `mp/ffa1` (H11), and `Q_acos`/`Q_asin`, which cannot give a different result. There is also the use of JKAShared `AngleVectors` in the Swift engine for traces against rotated brush models.
  - Not proved: on macOS, `<math.h>` probably redefines `M_PI` as a double after `openjk/shared/qcommon/q_math.h:38-40`. If so, the fork's engine computes with the double `M_PI`.
- jka-rust uses `f64` PI and says that its native oracle has math.h's double (`jka-rust/crates/native/math/src/qmath.rs:564-567`, `:619-620`, `:1071`). jka-rust follows the unix build, so it is not a precedent.

## E4. Floating-point contraction in the reference host: NOT SETTLED for the reference binary. The Swift side needs no change.

- H14 (`notes/2026-11-03/dedicated-referee-docket.md:280-284`): "the proof uses the binary as it is, and the submodule pin does not move."
- H14 in the ledger (`:301`): "The binary serves as it is, and the pin does not move."
- So H14 pins the binary itself, not only the commit. A build with `-ffp-contract=off` is a different binary. H14 expects a rebuild only for the probe cost.
- H9 (`:262`) covers the mismatch: the Swift keeps Raven's form, and the step claims only frames 1 to 26. H9 speaks of an "OpenJK change" with citations in both trees. A compiler flag is not an OpenJK source change, so H9 does not select a new reference.
- No flag set is recorded for the H14 binary. Its CMake cache sets no `-ffp-contract` (`dedicated-referee-port.md:84`). The no-contract copy is at `/tmp/referee-scratch/openjk-nocontract/` (`:102`).
- Swift never fuses a multiply and an add implicitly. `Package.swift` has no `cSettings` or flags except the Linux linker flag at `:104`.
- Candidates for the user:
  - (a) Use the `-ffp-contract=off` build as the H14 reference. It is green for 2400 frames and matches Raven's MSVC build, which did not fuse. Cost: H14 changes.
  - (b) Keep the H14 binary and open an H9 row for each fused frame. Cost: up to 861 fused sites can cause more mismatches.

## E5. The `ref_dump` line form: not a porting defect. Platform console difference.

- In Raven's linked `null/win_main.cpp:34-40`, `Conbuf_AppendText` does `printf(Q_CleanStr(msg)); printf("\n");`. `Sys_Print` calls it (`:378-380`). So Raven's WinDed ends a line on every `Com_Printf`.
- The port does the same: `win_main.swift:96-105` and `:372-374`.
- The fork prints with no added newline: `openjk/shared/sys/con_passive.cpp:60-66` and `con_tty.cpp:502-512`.
- The cause is the platform console code (the null WinDed file against OpenJK's `sys/`), so the port is faithful. If the dumps must look the same, change the `/tmp` join script, not the Swift.
