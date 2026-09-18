# oracle-closure refactor walk of 2026-09-18

This walk ruled on the form of the oracle-closure tool. The pipeline and the hole stay as they are. The four changes move code, and the nine bg gates at fb812fd are the proof that nothing moves: the same hole counts, a generator diff stat of zero, a clean build, and green tests. Each change is one commit, in the order below.

## Ledger

| Change | Subject | Verdict |
|---|---|---|
| 1 | One parse per run | ratified as proposed |
| 2 | One owner of the type question | ratified as proposed |
| 3 | Local facts move into Table | ratified as proposed |
| 4 | Split the Drafter by concern | ratified as proposed |

## The rulings in full

**Change 1.** The tool parses each unit once and hands the parse to every generator. A `Parse` value in closure.py holds the mp-game and mp-cgame translation units, the CJKAMP_Game header translation unit, and the overlay text. Every generator takes a `Parse` at construction instead of parsing itself. Table sweeps once over that value, and skeleton.py, traps.py, channel.py, and manifest.py read the one swept Table. The main entry points build the `Parse` once and hand it down. The skeleton overlay and the bodies overlay merge into one text.

**Change 2.** One module owns the answer to "what Swift type does this C type or expression have". A new module `typing.py` answers one question: for this C type and this role (field, parameter, return, local, expression), what is the Swift spelling, and which conversion crosses into it. The scalar, narrow, and record-name lookups move there from views.py. Table.param, Table.result_type, views.element, views.storage, and the bodies.py methods swift_type_of, number_kind, converted, is_charbuf, and is_pointer all call it and keep no branch of their own. The tables it reads, `SCALARS` and the rulings.py constants, stay as Python constants. typing.py is logic over a clang type, not a lookup, so it is a module and not a data file.

**Change 3.** Table owns the facts about a function's locals, the way it owns the facts about parameters. A `sweep_locals` in Table computes, once per function at sweep time, which locals are text, which are buffers, which are raw bytes, which walk a table, and which names are written or addressed. bodies.py reads those facts the way it reads cursors today, and its own store-tracking walks go. sweep_locals asks typing.py for the spelling of a local and holds no type branch of its own.

**Change 4.** bodies.py splits into modules by concern, with the Drafter as the entry and the Registry beside it. The emit code moves into modules for statements, expressions, calls and arguments, declarations, and the view, Slots, and text classification. No method body changes in this round. The two largest methods, statement_lines and expr, move whole. A split of their dispatch is a second round.
