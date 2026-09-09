# oracle-closure

These scripts parse the oracle with libclang and answer layout and dependency questions about Raven's types and functions. They are a copy of `jka-rust/tools/closure-prototype` at jka-rust commit `70582e59`'s tree, taken on 2026-09-08. `NOTES.md` holds the verdict and the lessons from the jka-rust run.

## What each script does

- `closure.py`: the parse core. It gives the transitive dependency closure of one type or function, its by-value or pointer-only class, and its size and field offsets. `modules/` holds the per-module compile flags, mirrored from Raven's vcproj Release configs.
- `fnsweep.py`: the function manifest for one module, from one unity parse.
- `symsweep.py`: the symbol manifest. It lists every macro constant, enum constant, and file-scope global a module references.
- `pass2lib.py`: the worktree scanner the two sweeps use to mark items as ported.
- `merge.py`: the second pass. It reads the `extract.py` trees, compares every declaration across modules and trees by code identity, and writes the C targets: `CJKAShared` for what MP and SP agree on, `CJKAMP` and `CJKASP` for what each tree's modules agree on, and `CJKAMP_Game`, `CJKAMP_CGame`, `CJKAMP_UI` and their SP twins for the rest. A type is shared only when everything it includes is shared. Each target is a SwiftPM C target: the umbrella, the module map, and the headers under `include/`, with the translation unit and `layout_asserts.h` beside it. `merge.py --out ../../Sources` writes the package's targets, and the default writes `out/merge/` for a dry run.
- `reexport.py`: the Swift re-exports. It parses each C target's umbrella and writes one Swift file per Raven header under the view target's `Generated` directory: a macro as a `public let` that reads the C value, an anonymous enum's enumerators as plain constants, a named enum as a struct with one static per enumerator, and a scalar typedef as a typealias. Swift's importer refuses a macro with an expression body and offers no way to ask which, so `--probe` builds, reads the failing lines, and moves each rejected name one rung up a ladder: the C body spelled as a Swift expression, the same expression narrowed to `Int32`, then a `TODO: Port` marker with the C text.
- `extract.py`: the type copier. It writes one C header per Raven struct, union, enum, or typedef, with the oracle path mirrored, plus a constants file per Raven header, `forward.h`, `all.h`, and `layout_asserts.h` with the oracle's sizes and offsets. A file listed in `adopted.json` in the output directory is never overwritten.

## The placement rules

A type lands in the tree target, `CJKAMP` or `CJKASP`, when every module of the tree that emits it agrees on its text, or when one module alone emits it from a Raven header two or more modules see, because `usercmd_t` in `q_shared.h` belongs to every module and only the game's type closure holds it. A type from a header one module sees lands in that module's target. The bg run reads `q_shared.h`, `bg_public.h`, `bg_local.h`, and `bg_saga.h`, and never `g_local.h`, so the game-private types stay in the game target and the bg types in the tree target. A type both trees define identically lands in `CJKAShared`, and a macro identical in both trees is shared only when every name its body uses is shared too.

## The layout check

`extract.py` parses each module once per target triple, `i686-pc-windows-msvc`, `i686-pc-linux-gnu`, `x86_64-pc-windows-msvc`, `x86_64-pc-linux-gnu`, `x86_64-apple-macosx`, and `arm64-apple-macosx`, and writes `layout_asserts.h` as one block per triple under a guard on Clang's predefined macros. `check.sh` compiles every target for every triple with `-ffreestanding`, so no SDK is needed for a foreign one. The merge exits when a seam type, or a record it holds by value, has two sizes across the triples of one pointer width. `--host-only` skips the foreign parses for a quick run.

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
.venv/bin/python reexport.py --probe
```

`check.sh` compiles every merged target's translation unit as C with its dependency include directories and exits nonzero on the first failure. Its one argument is the directory the merge wrote, `out/merge` by default. `EXTRACT_DEBUG=<TypeName>` makes `extract.py` print every include it adds for that type and why, for a dependency that looks wrong.

## Known gaps

The ported-status half of `fnsweep.py`, `symsweep.py`, and `pass2lib.py` scans Rust crates under `crates/`, and `symsweep.py` names a jka-rust worktree path. Those paths do not exist here. The oracle-side half of each script works unchanged. A later step points the ported-status scan at `Sources/`.
