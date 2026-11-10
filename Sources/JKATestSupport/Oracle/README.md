# Oracle goldens

These files come from `jka-rust/crates/mp/game/tests/oracle/` at jka-rust commit `dbc6861c`, with the oracle submodule at `4bebb8ec` on both sides. Rule 18 in `docs/porting-rules.md` says why: the dumpers under `jka-rust/tools/jampgame-oracle` compile the unmodified oracle, so the Swift port reproduces each golden byte for byte and `swift test` needs no C toolchain. The fixtures are unchanged copies. The goldens are the output of the same dumpers with one change, `float-mpi.patch`.

The change follows `docs/transcription.md`, which rules the float `M_PI` of `q_shared.h:548`, the value of Raven's Windows build. On the host of the dumpers, `<math.h>` defines the double `M_PI` first, so the `#ifndef M_PI` of `q_shared.h:547` never applies. The patch adds `#undef M_PI` after `#include <math.h>` in the force-included shim of each of the six scripts `run.sh`, `run_bgmisc.sh`, `run_gcombat.sh`, `run_pmove_saber.sh`, `run_qshared.sh`, and `run_wsaber.sh`. With the patch, three goldens differ from the jka-rust copy: `qmath.txt` at 17 lines, `pmove.txt` at 18 records, and `bgmisc.txt` at 8 records. The other seven goldens are the same with or without the patch.

To resync:

1. Copy `jka-rust/tools/jampgame-oracle`, the oracle checkout, and `jka-rust/crates/mp/game/tests/oracle` into one folder tree with the jka-rust layout.
2. In the copy of `tools/jampgame-oracle`, apply the patch with `patch -p1 < float-mpi.patch`.
3. Run `sh run.sh --regen` and each `sh run_<name>.sh --regen` there.
4. Copy the `golden` and `fixtures` folders of the copied data folder here.

The `golden/huff` folder is a copy of `jka-rust/tools/huff-oracle/goldens/`, taken unchanged at jka-rust commit `b98932e5`, with the oracle submodule at `4bebb8ec`.
The dumper is `jka-rust/tools/huff-oracle/main.cpp`, and it drives the unmodified `codemp/qcommon/huffman.cpp`.
It has no math shim, so the patch does not apply to it.

A Swift parity test reproduces only these goldens: `qmath` (`Tests/JKASharedTests/QMathParityTests.swift`), `bglib` (`Tests/JKAMPTests/BGLibParityTests.swift`), the `huff` folder (`Tests/JKAMP_DedLogicTests/HuffParityTests.swift`), and the `trajectory` section of `bgmisc` (`Tests/JKAMPTests/BGMiscTrajectoryParityTests.swift`). `Tests/JKASharedTests/OracleDataTests.swift` only loads the other goldens and checks their first line. Rule 18 asks for a parity test for each golden, so those goldens are open work.
