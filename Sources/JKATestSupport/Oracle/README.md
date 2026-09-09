# Oracle goldens

These files are a copy of `jka-rust/crates/mp/game/tests/oracle/`, taken unchanged at jka-rust commit `dbc6861c`, with the oracle submodule at `4bebb8ec` on both sides. Rule 18 in `docs/porting-rules.md` says why: the dumpers under `jka-rust/tools/jampgame-oracle` compile the unmodified oracle, so the Swift port reproduces each golden byte for byte and `swift test` needs no C toolchain. To resync, run jka-rust's `run.sh` there and copy the two directories again.
