# The SP umbrella headers under a fresh extract and merge

This record holds the investigation of the open row of `HANDOFF.md` line 15 and `notes/2026-10-28/windows-rows.md` line 13: the SP umbrella headers move when `extract.py` and `merge.py` run fresh. The tree is master at 4f89c89. No file of the tree changed, and the four moved umbrellas went back to their committed text after the checks.

## The commands

The extract usage comes from the docstring of `tools/oracle-closure/extract.py`, and the merge usage comes from the docstring of `merge.py` and the Setup section of `tools/oracle-closure/README.md`. The merge reads the eight modules of `MP_MODULES` and `SP_MODULES` at `merge.py:44-45`, so the fresh run extracts those eight. All commands ran in `tools/oracle-closure`:

1. `for m in mp-game mp-bg mp-cgame mp-ui sp-game sp-bg sp-cgame sp-ui; do .venv/bin/python extract.py $m; done`, 60 seconds.
2. `.venv/bin/python merge.py --out ../../Sources`
3. `.venv/bin/python tables.py`
4. `./check.sh ../../Sources`
5. `swift build` at the repo root, then `swift build --target <T>` for each of the four SP targets.

Before step 1, a copy of the eight trees of `out/extract/` went to `/tmp/spx-before/`. After step 1, `diff -rq` reports no difference for any of the eight trees. The fresh extract writes the same bytes as the run of 2026-10-28 00:38, so the extract is not where the move starts today.

## The moved files

After step 2, `git status --short` lists six files:

- `Sources/CJKASP/include/CJKASP.h`, 91 lines out and 91 lines in.
- `Sources/CJKASP_Game/include/CJKASP_Game.h`, 28 out and 28 in.
- `Sources/CJKASP_UI/include/CJKASP_UI.h`, 13 out and 13 in.
- `Sources/CJKASP_CGame/include/CJKASP_CGame.h`, 2 out and 2 in.
- `Sources/CJKAMP/bg_tables.c` and `Sources/CJKAMP_Game/g_tables.c`, deleted.

The two table files are deleted by the merge and written again by `tables.py`, which item 2 of `docs/oracle-closure.md` puts after the merge. After step 3 they are byte-identical to the committed text. The four SP umbrellas are the only files that move. No MP target, no `CJKAShared` file, and no constants file moves.

## The class of each hunk

Every hunk of the four umbrellas is an order change. For each umbrella, the sorted line set of the committed text and of the regenerated text is the same, so no include is added, no include is removed, and no text of a constants file changes. The windows-rows suspects do not apply. The `PATH_MAX` conditional of `platform_block` at `extract.py:619-649` and the first-`#define` name read at `merge.py:173-174` change only the text inside `q_shared/constants.h`, and that text is the same in both trees. The `CUnsignedLong` row changed `reexport.py` and `spelling.py` alone, and no C target reads them.

The committed SP umbrellas are in alphabetical order of the header directory, with the constants file of each header first. A test over the four committed files confirms this for all 134, 52, 22, and 75 includes. The regenerated umbrellas are in Raven's include order. For example, `CJKASP_CGame.h` committed reads `cg_camera`, `cg_lights`, `cg_local`, `cg_media`, and the regenerated text reads `cg_local`, `cg_camera`, `cg_media`, `cg_lights`, which is the order in which `cg_local.h` and the entry list of `sp-cgame` reach them.

## The cause

The order comes from two places. `extract.py:1124-1142` writes `all.h` in Raven's include order, header by header, constants first, and `wrap` at `extract.py:756-760` keeps that order for a file it writes with `ordered=True`. `header_rank` at `merge.py:260-276` reads the `all.h` of each module of a tree and gives each oracle header its rank, and the umbrella sort key at `merge.py:723-731` sorts by that rank, then constants before types, then the placement order.

Commit b592573 of 2026-10-01, "umbrella order", added both halves. Before it, `wrap` sorted every include, so each `all.h` was alphabetical. That round committed all nine umbrellas, but it extracted the MP modules alone. The SP trees under `out/extract/` still held the alphabetical `all.h` of the earlier extract, so `header_rank` gave the SP umbrellas the alphabetical order. The SP umbrellas have not changed in git since b592573. To prove this, a worktree at b592573 ran its own `extract.py --host-only` over the eight modules and its own `merge.py` into `/tmp`. Its four SP umbrellas differ from the committed text and agree with today's regenerated text. The one exception is the one include `code/ui/ui_public/uiImport_t.h` in `CJKASP_UI.h`, which a later round added. The b592573 `merge.py` over today's trees also writes today's regenerated text for all four. The committed SP text was never the output of the code it was committed with. It is the output of stale SP trees.

## The rule

Item 2 of `docs/oracle-closure.md`, line 8: "The umbrella of each target follows the `all.h` order of the modules, header by header, with the constants of a header before its types, which is Raven's include order." The regenerated SP umbrellas follow that rule. The committed SP umbrellas follow alphabetical order, which no rule of the doc states. The committed text is stale, and the generator has no defect.

## The build with the regenerated text

`check.sh ../../Sources` compiles every target for all ten triples. All nine targets report 0 errors, the four SP targets among them: `CJKASP` 1899 asserts, `CJKASP_Game` 354, `CJKASP_CGame` 858, `CJKASP_UI` 1392. `swift build` completes with no error in 20.5 seconds, and it compiles the four SP targets, which `Package.swift:27-30` declares. Each `swift build --target` of an SP target completes. No Swift file under `Sources/` or `Tests/` imports an SP target, so the order change reaches no Swift code.

## The restore

`git checkout --` restored the four umbrellas. The temporary worktree at `/tmp/wt-b592` is removed and pruned. `git status --short` lists only `HANDOFF.md` and `notes/2026-10-29/`, and this file is in that folder.

## S1. The SP umbrella headers take Raven's include order

Ratified as proposed on 2026-10-29. A fresh `extract.py` and `merge.py` run moves the four SP umbrellas, `CJKASP.h`, `CJKASP_Game.h`, `CJKASP_UI.h`, and `CJKASP_CGame.h`, by 134 lines of order alone, with no include added or removed and no constants text changed. The committed text is the alphabetical order of the SP trees that b592573 did not extract again, and the regenerated text is the `all.h` order that `docs/oracle-closure.md` item 2 states, from `extract.py:1124-1142` and `merge.py:260-276` and `:723-731`. The form: commit the regenerated headers as is, on a branch with a PR, with no generator change. `check.sh` reports 0 errors on every triple, and `swift build` has 0 errors with the regenerated text. After that commit, a fresh run over the eight modules moves no file, and later rounds do not need the put-back.

## The gate on the branch

The branch `sp-umbrella-order` holds the regenerated headers from the eight-module extract, the merge, and `tables.py`, and the four SP umbrellas are the only files that moved, by 134 lines of order. `check.sh` reports 0 errors on all nine targets. `swift build` has 0 errors. `swift test --no-parallel` passes 112 tests in four runs. `tools/load-test.sh` exits 0, and the 82 tool tests pass with 16 skipped. No generator, rule, or signature changed, so the draftcheck and snapshot checks are not due.
