# Oracle goldens

These files are a copy of `jka-rust/crates/mp/game/tests/oracle/`, taken unchanged at jka-rust commit `dbc6861c`, with the oracle submodule at `4bebb8ec` on both sides. Rule 18 in `docs/porting-rules.md` says why: the dumpers under `jka-rust/tools/jampgame-oracle` compile the unmodified oracle, so the Swift port reproduces each golden byte for byte and `swift test` needs no C toolchain. To resync, run jka-rust's `run.sh` there and copy the two directories again.

`golden/qmath.txt` is the one exception, because `docs/transcription.md` rules the float `M_PI` of `q_shared.h:548`, the value of Raven's WinDed build. The `run.sh` build gets the double `M_PI` of the host `<math.h>` first, so its `qmath.txt` differs at 17 lines. Our copy comes from the same `run.sh` qmath build with one change: the force-included shim adds `#undef M_PI` after `#include <math.h>`, so `q_shared.h:547` defines the float `M_PI`. A resync must keep that change.

The `golden/huff` folder is a copy of `jka-rust/tools/huff-oracle/goldens/`, taken unchanged at jka-rust commit `b98932e5`, with the oracle submodule at `4bebb8ec`.
The dumper is `jka-rust/tools/huff-oracle/main.cpp`, and it drives the unmodified `codemp/qcommon/huffman.cpp`.
