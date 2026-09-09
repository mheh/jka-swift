# oracle-closure

These scripts parse the oracle with libclang and answer layout and dependency questions about Raven's types and functions. They are a copy of `jka-rust/tools/closure-prototype` at jka-rust commit `70582e59`'s tree, taken on 2026-09-08. `NOTES.md` holds the verdict and the lessons from the jka-rust run.

## What each script does

- `closure.py`: the parse core. It gives the transitive dependency closure of one type or function, its by-value or pointer-only class, and its size and field offsets. `modules/` holds the per-module compile flags, mirrored from Raven's vcproj Release configs.
- `fnsweep.py`: the function manifest for one module, from one unity parse.
- `symsweep.py`: the symbol manifest. It lists every macro constant, enum constant, and file-scope global a module references.
- `pass2lib.py`: the worktree scanner the two sweeps use to mark items as ported.
- `merge.py`: the second pass. It reads the `extract.py` trees, compares every declaration across modules and trees by code identity, and writes the C targets: `CJKAShared` for what MP and SP agree on, `CJKAMP` and `CJKASP` for what each tree's modules agree on, and `CJKAMP_Game`, `CJKAMP_CGame`, `CJKAMP_UI` and their SP twins for the rest. A type is shared only when everything it includes is shared. Each target is a SwiftPM C target: the umbrella, the module map, and the headers under `include/`, with the translation unit and `layout_asserts.h` beside it. `merge.py --out ../../Sources` writes the package's targets, and the default writes `out/merge/` for a dry run.
- `extract.py`: the type copier. It writes one C header per Raven struct, union, enum, or typedef, with the oracle path mirrored, plus a constants file per Raven header, `forward.h`, `all.h`, and `layout_asserts.h` with the oracle's sizes and offsets. A file listed in `adopted.json` in the output directory is never overwritten.

## Setup

```sh
cd tools/oracle-closure
python3 -m venv .venv
.venv/bin/pip install libclang==18.1.1
.venv/bin/python closure.py --list-modules
.venv/bin/python closure.py mp-game playerState_t --layout
.venv/bin/python extract.py mp-game
clang -fsyntax-only -x c -std=gnu11 -Wno-everything -I out/extract/mp-game -I glshim out/extract/mp-game/layout_asserts.h
.venv/bin/python merge.py --out ../../Sources
./check.sh ../../Sources
```

`check.sh` compiles every merged target's translation unit as C with its dependency include directories and exits nonzero on the first failure. Its one argument is the directory the merge wrote, `out/merge` by default. `EXTRACT_DEBUG=<TypeName>` makes `extract.py` print every include it adds for that type and why, for a dependency that looks wrong.

## Known gaps

The ported-status half of `fnsweep.py`, `symsweep.py`, and `pass2lib.py` scans Rust crates under `crates/`, and `symsweep.py` names a jka-rust worktree path. Those paths do not exist here. The oracle-side half of each script works unchanged. A later step points the ported-status scan at `Sources/`.
