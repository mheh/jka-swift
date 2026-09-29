# The unity parse as a declaration source

Repo jka-swift, branch wave-0, commit 6bbbb37. Line numbers are of that commit.

## 1. The shape of the tool as it is

`closure.parse_tu` (closure.py:165-233) builds one of two translation units. The header parse (lines 199-215) reads `cfg["entry"]`, the hand list of `modules/mp-game.py` lines 4-10, and writes a synthetic `__closure_tu__.c` that includes each entry in list order. The unity parse (lines 209-216) reads `cfg["srcglob"]`, sorts the `.c` files, and includes each one after the overlay text. The entry list is read in one place only, `parse_tu`, and `extract.emit` (extract.py:832) reads `spec["entry"][0]` once more for the note line.

The header parse feeds everything below. `extract.emit` (extract.py:812-1109) parses it at line 813, `sweep` (333-461) walks it and records `FILE_ORDER` (347-348), `link` (463-561) reads the AST for the include set of each declaration, and `triple_asserts` (761-775) parses it nine more times, one per foreign triple, in a process pool. The output is the one-header-per-file tree, `forward.h`, `all.h` in Raven's include order (1054-1065), `layout_asserts.h`, `extract.json`, and `cxx_only.txt`. `merge.py` reads only that tree (load_tree, merge.py:239-262) and never a parse. `check.sh` compiles the merged targets. `reexport.parse` (reexport.py:66-74) parses the merged umbrella under `Sources/`, and `Parse.headers` (closure.py:257) holds that parse for `views.collect` (views.py:71-88) and for `spelling.scalar`. So the views, the re-exports, the traps, the skeleton signatures, and the drafter's type answers all see the header parse through the merged copy.

The unity parse feeds the body facts. `Parse.game` and `Parse.cgame` (closure.py:246-259) carry the overlay, and `Table.sweep` (table.py:1225-1255), `Skeleton.collect`, `collect_variables`, `collect_macros` (skeleton.py:200-323), `Traps`, and the drafter read them. Inside extract.py the unity parse serves one purpose. Line 919 parses it without the overlay, line 920 builds an `IfResolver` from its macro table, and the loop at 929-946 keeps only cursors whose file ends in `.c`, for the `.c` macros and enums that go to `<stem>_c/constants.h` and the `file_enums` rows of `extract.json` (998), which `Skeleton.collect_file_enums` (skeleton.py:325-350) turns into private constants.

The header parse gives four things a unity parse does not. The include order is Raven's for one module, so `all.h` follows it and a macro lands after the enum it shadows. The macro table of the parse holds the module's defines and the header macros alone, so `IfResolver` resolves a header's `#if` with the truth the header saw. The nine triple parses cost seconds each, because they parse headers alone. And the C closure test, `is_c` plus the fixed point at extract.py:842-853, and the layout check, `asserts_for` at 662-687, run over declarations the module's own headers define, never over a `.c` file's private type.

The concrete miss. `be_aas.h` declares `solid_t` at lines 60-65, `ai_main.c:21` and `g_weapon.c:7` include it, no entry header reaches it, and `g_weapon.c:4954` writes `ent->s.solid = SOLID_BBOX`. The drafter's `reference` (draft_expressions.py:513) returns a bare `SOLID_BBOX` for an enum constant, no re-export declares it, and draftcheck counts the compile error as a defect, not a hole, because `hole_names` never held it. A probe of both parses shows the miss is not one header. For mp-game the unity parse reaches 15 oracle headers the header parse does not: be_aas.h, be_ai_chat.h, be_ai_goal.h, be_ai_move.h, be_ai_weap.h, chars.h, inv.h, syn.h from ai_main.c, menudef.h from g_cmds.c with 331 macros, and six headers with prototypes only. For mp-bg the unity parse reaches g_local.h, g_public.h, b_public.h, ai.h, and g_team.h, because the bg `.c` files include g_local.h under `QAGAME` and the module defines it.

## 2. The design options

| Option | Header parse | Unity parse | Entry list |
|---|---|---|---|
| (a) derive the entry list | kept, entries computed | source of the include graph | gone, one `exclude` per module stays |
| (b) unity replaces header | gone | source of every declaration | gone |
| (c) widen the unity loop | kept, hand list stays | `.c` cursors plus unreached `.h` cursors | stays, grows by hand |

### (a) Derive the entry list from the unity include graph

Change `parse_tu` to take an `entries` argument, and add `derived_entries(module)` in closure.py: parse unity once, walk `tu.get_includes()`, keep each include whose source is a file of `srcglob`, in order of first appearance, minus the paths a module's `exclude` names. `extract.emit` computes the list once and hands it to `triple_asserts` through the pool, so the nine triple parses stay header parses. `modules/mp-game.py` loses its ten entries. `modules/mp-bg.py` keeps one line, `exclude=["codemp/game/g_local.h"]`, with the reason merge.py:43-45 already states: the bg tree target must not hold game types.

What breaks: nothing in the generators, because every reader downstream of extract.json sees a larger tree of the same shape. What grows: `be_aas.h` brings 12 structs and 103 macros into CJKAMP_Game with asserts on ten triples, `chars.h`, `inv.h`, and `syn.h` bring 144 macros, and `menudef.h` moves from CJKAMP_UI to CJKAMP because two modules then emit it and `partition_tree` unions constants two modules see. `reexport --probe` may climb the ladder for a few new macros. Generated Swift for the miss: `Sources/JKAMP_Game/Generated/be_aas.swift` gets `public typealias solid_t = Int32` and `public let SOLID_BBOX: solid_t = Int32(truncatingIfNeeded: CJKAMP_Game.SOLID_BBOX.rawValue)`, and the draft line `ent.s.solid = SOLID_BBOX` compiles, because `solid` is an Int32 field on the view. The C closure test and the layout check run on more records and change no rule. The manifest lists functions and variables, so it does not change. Adopted stubs are untouched, because skeleton.py writes only files that still carry its note.

### (b) Replace the header parse with the unity parse

`extract.emit` sweeps the unity unit, keeps every cursor of an oracle `.h` file, and keeps `.c` cursors only for the constants block. `FILE_ORDER` becomes the order of first reach across the sorted `.c` files. Four things break. `triple_asserts` becomes ten unity parses of about seventy files, minutes instead of seconds. `macro_table(tu)` then holds every `.c` file's macros, so `IfResolver` evaluates a header's `#if` with `MIN_DISTANCE`, `currentOrigin`, and the last of 14 two-body names defined, which is not the truth the header saw in Raven's build. The mp-bg partition fails outright, because the bg unity parse reaches g_local.h and the tree target would take 78 game structs. And the C closure test and the layout check would need a filter to keep `.c`-private structs out, which is the filter the `.c` loop applies today, but inverted. The Swift for `solid_t` is the same as under (a). Nothing here is better than (a), and the cost is high.

### (c) Keep both, widen the unity loop

Change the test at extract.py:931 to accept an oracle `.h` file that `FILE_ORDER` of the header parse does not hold, and give `Decl.reldir` no `_c` suffix for it, so the macros and enums land in `be_aas/constants.h` under CJKAMP_Game. `merge.partition_tree` treats it as a normal constants file, because the placement branch at merge.py:316-326 keys on a `.c` source. The Swift for `solid_t` and `SOLID_BBOX` is the same as under (a), because `reexport.emit` reads an `ENUM_DECL` in a constants file the same way. What stays missing: the 12 structs and 14 typedefs of be_aas.h get no header, no assert, and no view, so the tool then has two coverage levels for headers, and a struct rule applies differently by which parse reached the header. The `IfResolver` of these slices is the unity one, with the `.c` macro risk of (b) in small. The hand list stays.

### (d) A textual variant of (a)

Read the `#include` lines of each `.c` file with a regex and skip the unity parse. It fails on `#ifdef QAGAME` guards, which the preprocessor resolves and a regex does not. (a) reads the resolved directives, so (d) is (a) done worse.

## 3. Risks specific to this codebase

Two-body macros. Fourteen names differ between `.c` files: `MIN_DISTANCE` in twelve NPC files, `MAX_DISTANCE`, `VELOCITY_DECAY`, `CAUTIOUS_THRESHOLD`, and ten more. Under (b) and (c) the unity macro table holds the last definition, and a header `#if` that named one would resolve wrongly. Under (a) the include graph reads no macro value, only the guards, so the risk is gone.

The vehicle rewrite. `AnimalNPC.c:54`, `FighterNPC.c`, `SpeederNPC.c`, `WalkerNPC.c`, and `g_vehicles.c` define `currentOrigin` as `r.currentOrigin`. `AnimalNPC.c` sorts first in the unity unit, so every header first reached by a later `.c` file, which is every header outside g_local.h's closure, parses with that macro live. Under (b) a field or a macro named `currentOrigin` in such a header would be rewritten in the AST. Under (a) the header parse never sees a `.c` file, so the rewrite stays where extract.py:922 keeps it.

Headers under different defines. The bg module carries `QAGAME`, so its `.c` files include g_local.h. (a) needs the one `exclude`. (b) cannot be made safe without it. mp-cgame and mp-ui also compile the bg files, under `CGAME` and `UI_EXPORTS`, and their derived lists pick up cg_local.h and ui_local.h, which those modules own, so no exclude is needed there.

Shared headers between bg and game. The bg `.c` files reach G2.h, bg_strap.h, animtable.h, and w_saber.h. G2.h and w_saber.h are already two-module emits that merge places at tree level. bg_strap.h and animtable.h hold prototypes and a data table, and extract keeps nothing from them.

Two unity parses of one module. extract.py:919 parses without the overlay and Parse (closure.py:250) with it, so `macro_table` differs between them, and any fact that reads both is a fact computed twice with two truths. (a) adds a third parse unless extract takes a `Parse`.

Path spelling. The probe matched raw file names and listed G2.h as reached by one parse and not the other, because one spells `codemp/game/../ghoul2/G2.h`. `in_oracle` resolves paths and `Decl.reldir` resolves too, but `FILE_ORDER` membership at extract.py:347 uses raw names. A derived list must resolve before it compares.

## 4. Recommendation

Take (a), with an `exclude` field per module spec. It keeps every property the header parse gives, it makes the unity parse the source of exactly one fact, the module's include graph, and it removes the ten-line hand list that the G2.h, w_saber.h, and icarus precedents have grown by hand three times. (c) leaves structs invisible and creates a second coverage class. (b) trades a correct macro truth and a fast triple check for nothing (a) does not give.

The smallest first step that proves it: add `derived_entries(module)` to closure.py and an `--derive-entries` flag to extract.py that uses it, then run `extract.py mp-game --check --host-only --derive-entries` and the same for mp-bg, and diff the file lists against `out/extract`. The run writes nothing. It shows the 15 new mp-game headers and the five bg headers the `exclude` must name, and it shows whether any existing file changes. Only then delete the entry lists.

## 5. Holes and improvements

Ranked, the most consequential first.

1. extract.py:929-931. The unity loop drops every `.h` cursor, so a header only a `.c` file includes contributes nothing: 15 real headers in mp-game today, be_aas.h among them. Fix: option (a) above.

2. draft_expressions.py:340-350 and 513, draftcheck.py:113-116. A header macro or enum constant with no re-export drafts as a bare name and fails as a defect, not a hole, because `reach` acts only for bg bodies and knows only names with a home. Fix: `Registry` (bodies.py:63-110) also indexes the `// TODO: Port NAME` lines of `Generated/`, and `reach` raises a Hole for a macro or enum constant that no target exports.

3. merge.py:43-45 and extract.py:931. The design says the bg parse never sees g_local.h, and the bg unity parse does. Only the `.c` filter protects the partition. Fix: an `exclude` in modules/mp-bg.py that every parse path honors, and a check in `partition_tree` that no identity of mp-bg alone names a game header.

4. extract.py:919 and closure.py:250. Two unity parses of one module, one without the overlay, so `macro_table` and the call shapes differ. Fix: extract's unity parse takes `overlay=OVERLAY`, or `emit` takes a `Parse`.

5. views.py:58-65, views.py:285-297, skeleton.py:455-467, skeleton.py:625-634, bodies.py:63-110. Five regex scans of the generated Swift for one fact, which public names exist and in which module, each with its own pattern. Fix: reexport.py writes one index beside `Generated/`, and every reader takes it.

6. table.py:1225-1255. `sweep_stores`, `sweep_text`, `sweep_cursors`, and `sweep_returns` walk the game unit only, while the other sweeps walk both. A bg body whose cgame arm writes through a `char *` crosses as a String. Fix: run the four over the cgame unit with both folders, as the NULL sweep does.

7. skeleton.py:325-330. `collect_file_enums` returns an empty dict when `out/extract/mp-game/extract.json` is absent, so a stale or missing extract silently writes stubs without their private constants. Fix: exit with the path, and compare the manifest's oracle commit to `oracle_commit()`.

8. extract.py:1036-1038. A second declaration of one name is skipped with a stderr warning and never reaches `DROPPED` or the summary. Fix: append it to `DROPPED` so the count reports it.

9. extract.py:145 and reexport.py:123, extract.py:82 and merge.py:105, extract.py:703-716 and merge.py:460-472, extract.py:934 and reexport.py:222. Four helpers live twice, and the enum-name test differs in form between the two copies. Fix: one small module of C text helpers that both import.

10. docs/porting-rules.md rule 8 says a Raven enum imports as a Swift struct with static members, and reexport.py:191-204 writes an Int32 typealias with bare lets by the ruling of 2026-09-09. extract.py:11-18 names `constants_<header>.h` and a flat directory, and the code writes `<dir>/<stem>/constants.h` in a mirrored tree. closure.py:2 still says "PROTOTYPE, throwaway". Fix: reword the three texts to what the code does.

11. extract.py:923-926 and 988. `header_identifiers` is built from slices with comments kept, so a word in a Raven comment keeps a `.c` macro or enum out of `constants.h` and adds a NOTES line. Fix: `strip_comments` before the `findall`.

12. spelling.py:215-235. The vector rules test `t.spelling.split()[-1] in VECTORS` and `"vec3_t" in t.spelling`, text tests that match any typedef whose name contains the word. Fix: test through `views.is_vec3` and the canonical array type.

13. views.py:71-88 and table.py. The views read `parse.headers`, the merged copy, and the sweeps read the oracle unit, matched by name alone through `record_name`. A record the merge left in `cxx/` or dropped gets no view and no report. Fix: after `collect`, check that every record a sweep names has a definition in `parse.headers` with the same `get_size()`.

14. tables.py:53-86. `PIECES` holds hand line ranges, and `copied` checks only the file length, so an oracle bump moves a range silently. Fix: each `Piece` carries the expected first line, and `copied` exits on a mismatch.

15. extract.py:942. A `.c` macro whose name a header macro already has is dropped with no NOTES line. Fix: one NOTES line, as the other drops of that loop get.

16. skeleton.py:888-895. `thunk` walks every record to find `gentity_s` for each stored function. Fix: read `self.table.views.records["gentity_s"]` once in `thunks`.
