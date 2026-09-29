# Review of the derived entry list, as landed

Uncommitted tree over 6bbbb37. Reads only. One scratch run of `bodies.py --only Q3_GetTag` and one scratch script that reproduces `derived_entries` to print the filter decisions.

## 1. The landing against sections 2(a) and 4

The core matches: `derived_entries` (closure.py:242-280) reads `tu.get_includes()`, keeps a direct include of a `srcglob` file in first-reach order, resolves paths first, and drops the `exclude` paths. `parse_tu` takes `entries`, `extract.emit` computes the list once (extract.py:813-815) and hands it to the pool (781-786). The specs lost their hand lists. `be_aas.swift:164-168` carries `solid_t` and `SOLID_BBOX` in the form section 2(a) predicted. Five departures follow.

The root filter. Not in the proposal, and sound. My probe compared header sets and never parsed the derived list, so it missed that g_local.h and bg_saga.h have no include guard. See section 2.

The menudef exclude. Sound as a stopgap, and it hides a merge defect. See section 3.

No `--derive-entries` flag. The agent proved the list in scratch and landed it whole. Sound, because the gate ran: build clean, 106 tests, bg 0 defects, game defects down by five.

The staged switch. mp-cgame and mp-ui keep `entry` beside `srcglob`, and `entry_list` (closure.py:231-239) prefers the hand list when a spec has one. Sound, because the cgame diff changes struct text and is not explained yet. See section 5.

`SABERINVALID`. rulings.py adds a third tuple element to `HAND_MACROS`, draft_expressions.py:226-230 reads it, and g_local.swift gains a hand `saberInvalid` function. This is a separate row of the walk, not part of (a). Two notes. The third element is a type fact inside a name table, so a shape rule now lives as data, which the rulings docstring forbids. And w_saber.swift still carries the skeleton note on line 1, so the next skeleton run rewrites it, which is correct only because the change came from the generator.

## 2. The root filter

The test is "another derived header reaches this one, and this one does not reach that one back". Against the include graph of the two modules it drops four of 39 direct includes: g_local.h (b_local.h reaches it), bg_saga.h (ai_main.h reaches it), and namespace_begin.h and namespace_end.h in both modules. It keeps every other header. No cycle exists among the direct includes today, so the cycle clause has no effect yet, and it is the right guard for the day a cycle appears.

The test is a proxy. The property that matters is "has no include guard", and the filter drops guarded headers too, which costs nothing because the kept header reaches them. The one way it drops a header that should stay: an include that the unity parse resolves under a define a `.c` file sets before the include, as g_ICARUScb.c does for interpreter.h. The header parse has no such define, so the filter can leave a root to a header that never reaches it there. Nothing in the tree proves that this does not happen. Fix: after the header parse, `extract.emit` checks that every header of the unfiltered `found` list stands in `FILE_ORDER`, and exits with the missing names. `derived_entries` returns `found` beside the filtered list, or a second function gives it.

## 3. menudef.h: the exclude or a merge rule

The merge rule is right, and the exclude costs nothing today. Of the 331 macros in `oracle/ui/menudef.h`, zero are named in any `codemp/game/*.c` file. g_cmds.c includes the header and uses no name from it. So the game drafts lose no macro, and the exclude comment in mp-game.py:11-12 states the cause correctly.

The defect it hides is a rule two generators apply differently. extract.py:1054-1065 orders `all.h` by Raven's `FILE_ORDER`, constants of one header and then its types, header by header, and the comment there names the CT_LTBLUE1 case as the reason. merge.py:660 flattens the umbrella to every constants file and then every type, so the order extract.py keeps is lost. Four names collide: CT_DKBLUE1, CT_DKCYAN, CT_LTBLUE1, CT_LTCYAN, enumerators of `ct_table_t` in q_shared.h:1066-1127 and macros of menudef.h. Any future constants file that redefines an enumerator breaks the same way. Fix: `merge.emit` orders each target's umbrella by the position of each file's first `Source:` header in the emitting module's `all.h`, which merge.py already skips at load_tree (merge.py:252). Then the exclude goes.

## 4. TYPE_ORIGIN and TYPE_ANGLES

The cause is the one the handoff names, and it did not change with this landing. g_ICARUScb.c:20-44 declares `TK_USERDEF` in an enum of its own, then line 48 includes interpreter.h. interpreter.h:15-30 opens its first enum at `TK_BLOCK_START = TK_USERDEF`, so the header parse, which has no such name, reports an error inside that enum, and extract.py:395-405 drops it. The second enum opens at `NUM_USER_TOKENS` and the third at `NUM_IDS`, so the cascade at extract.py:406-419 drops both. `TYPE_ANGLES` and `TYPE_ORIGIN` sit in the third (interpreter.h:72-105). The merged tree confirms it: `Sources/CJKAMP_Game/include/codemp/icarus/interpreter/` holds constants.h, enum_MSG_COMPLETED.h, and vector_t.h, and no TYPE enum. The unity parse sees the header after the `.c` enum and parses it clean, and the loop at extract.py:929-931 drops it as a `.h` cursor.

Why now and not at 6bbbb37: the errors were there. The draft of `Q3_GetTag` (g_ICARUScb.c:948) writes `case TYPE_ORIGIN:` and `case TYPE_ANGLES:` bare with zero holes, and nothing this landing touched feeds that draft. notes/2026-09-29/game-gate.md says the agent read only the tail of the output at 6bbbb37, so the count of five not-in-scope defects there is a tail count, not a proof. HANDOFF.md:26, written before 6bbbb37, already lists the two errors with this cause.

The smallest fix: a name rule `HEADER_PRELUDES` in rulings.py, `{"codemp/icarus/interpreter.h": ("codemp/game/g_ICARUScb.c", 20, 44)}`, and `parse_tu` writes that slice into the synthetic TU before the header's include. Raven's comment at interpreter.h:13 names the pairing. Two consequences need one line each. The `named` rule at extract.py:988 then sees `TK_USERDEF` in a header slice and keeps the `.c` enum out of `g_ICARUScb_c/constants.h`, where it stands today, so the rule exempts names the prelude defines. And the umbrella must place that constants file before the interpreter enums, which the section 3 fix gives. `extract.py mp-game --check --host-only` proves it when DROPPED loses the three interpreter.h rows.

## 5. The cgame and ui switch

They should switch, after three things are true. First, the cgame content changes in cg_t, cgs_t, cgMedia_t, clientInfo_t, and saberInfo_t are explained. A struct's text changes only when `IfResolver` takes another branch, so a header of the derived list defines a macro the hand list did not, and the diff names it. Second, the case claim is checked. No file under codemp/cgame, codemp/ui, or codemp/game spells `ghoul2/g2.h`, only oracle/code does, so the folder name `g2` needs a cause before a fix. If a real lowercase include exists, `derived_entries` must take the on-disk spelling from `parent.iterdir()`, because `Path.resolve()` keeps the spelled case on macOS and the merge identity `ghoul2/G2` would split. Third, the section 3 merge rule lands, because ui_local.h and cg_local.h reach menudef.h and the collision returns at tree level for cgame.

## 6. Other holes the landing opened, ranked

1. No proof that the header parse reaches every derived root. See section 2. One check in `extract.emit`.

2. Three unity parses of mp-game per pipeline run: `derived_entries`, extract.py:919, and `Parse.game`. `entry_list` caches per process, and the extract process is not the generator process. Fix: `derived_entries` takes an optional `tu`, and extract.py:919 parses once and hands it over.

3. The `exclude` for menudef.h stands as a comment with no marker. A future reader sees a design choice. Fix: a `TODO: Port` line with the merge rule as the subject, so the grep lists it.

4. `HAND_MACROS` grew a typed third element. Fix: a small dataclass `HandMacro(spelling, reason, swift=None)` in rulings.py, so the shape is one place and the drafter reads a field, not an index.

5. docs/oracle-closure.md part 1 now says the header parse "reads the entry list that closure.py derives" and also that every other module "keeps a hand entry list". The second half is a state of the walk, not a timeless rule. Fix: state the rule, a spec with `entry` uses it, a spec without it derives, and drop the module names.

6. CJKAMP_forward.h gains typedef pairs for 15 botlib records whose types live in CJKAMP_Game. Harmless, because merge unions forward lines per tree, and the pointer-only tags were there before. No change needed, noted so the diff reads as expected.
