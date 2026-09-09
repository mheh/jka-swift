# oracle-closure

These scripts parse the oracle with libclang and answer layout and dependency questions about Raven's types and functions. They are a copy of `jka-rust/tools/closure-prototype` at jka-rust commit `70582e59`'s tree, taken on 2026-09-08. `NOTES.md` holds the verdict and the lessons from the jka-rust run.

## What each script does

- `closure.py`: the parse core. It gives the transitive dependency closure of one type or function, its by-value or pointer-only class, and its size and field offsets. `modules/` holds the per-module compile flags, mirrored from Raven's vcproj Release configs.
- `fnsweep.py`: the function manifest for one module, from one unity parse.
- `symsweep.py`: the symbol manifest. It lists every macro constant, enum constant, and file-scope global a module references.
- `pass2lib.py`: the worktree scanner the two sweeps use to mark items as ported.

## Setup

```sh
cd tools/oracle-closure
python3 -m venv .venv
.venv/bin/pip install libclang==18.1.1
.venv/bin/python closure.py --list-modules
.venv/bin/python closure.py mp-game playerState_t --layout
```

## Known gaps

The ported-status half of `fnsweep.py`, `symsweep.py`, and `pass2lib.py` scans Rust crates under `crates/`, and `symsweep.py` names a jka-rust worktree path. Those paths do not exist here. The oracle-side half of each script works unchanged. A later step points the ported-status scan at `Sources/`.
