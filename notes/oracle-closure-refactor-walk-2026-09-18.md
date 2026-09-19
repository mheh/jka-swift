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

**Change 2.** One module owns the answer to "what Swift type does this C type or expression have". A new module `spelling.py` answers one question: for this C type and this role (field, parameter, return, local, expression), what is the Swift spelling, and which conversion crosses into it. The scalar, narrow, and record-name lookups move there from views.py. Table.param, Table.result_type, views.element, views.storage, and the bodies.py methods swift_type_of, number_kind, converted, is_charbuf, and is_pointer all call it and keep no branch of their own. The tables it reads, `SCALARS` and the rulings.py constants, stay as Python constants. spelling.py is logic over a clang type, not a lookup, so it is a module and not a data file. The walk named it typing.py, and the build renamed it, because a file of that name beside the tool shadows the standard library module for the whole process.

**Change 3.** Table owns the facts about a function's locals, the way it owns the facts about parameters. A `sweep_locals` in Table computes, once per function at sweep time, which locals are text, which are buffers, which are raw bytes, which walk a table, and which names are written or addressed. bodies.py reads those facts the way it reads cursors today, and its own store-tracking walks go. sweep_locals asks spelling.py for the spelling of a local and holds no type branch of its own.

**Change 4.** bodies.py splits into modules by concern, with the Drafter as the entry and the Registry beside it. The emit code moves into modules for statements, expressions, calls and arguments, declarations, and the view, Slots, and text classification. No method body changes in this round. The two largest methods, statement_lines and expr, move whole. A split of their dispatch is a second round.

## Rulings during the build of change 1

The one parse moved generated output, so three rows closed on 2026-09-18 during the build. Change 1 landed as deb7293.

| Row | Subject | Verdict |
|---|---|---|
| A | The overlay facts | ratified as proposed |
| B | The optional trap parameter | ratified as proposed |
| C | The write walk and the macro templates | ratified as proposed |

**Row A.** The port accepts the written globals the one overlay reveals. The overlay gives the skeleton's write walk call nodes for Raven's vector macros. gPainPoint lands as generated state. saberClashNorm and WP_MuzzlePoint land as hand properties on GameWorld and BgState, in the shape of the state beside them.

**Row B.** trap_G2API_SetRagDoll takes its params parameter as optional. The NULL sweep proves over every caller the port parses, game and cgame, and a cgame caller passes NULL.

**Row C.** The skeleton's write walk reads the overlay's macro templates. For a callee in the macro table, only a destination argument counts as a write. Any other callee keeps the conservative default, where an array argument is a write. WP_MuzzlePoint and bytedirs are VectorCopy sources, so they stay unwritten, and WP_MuzzlePoint takes the shape of every Raven data table of the module, C storage in bg_tables.c with a Slots bind, instead of state on BgState. Landed as 0c17ad2.

## Rulings during the build of change 3

Change 3 landed as 8738e1d. One row closed after it on 2026-09-18.

| Row | Subject | Verdict |
|---|---|---|
| D | The local sweep on first read | replaced: in memory, no writing to disk |

**Row D.** sweep_locals computes a function's local facts on the first read of that function and holds them in memory on the Table, so a generator that never reads them pays nothing and the drafter pays for one stem alone. Table stays the one owner and the one key. Nothing is written to disk.

## Rulings after the walk

| Row | Subject | Verdict |
|---|---|---|
| E | The gates in one process | dictated: aggregate the stems instead of one process per stem |

**Row E.** draftcheck.py takes several stems in one invocation. It parses and sweeps once, then drafts, splices, builds, and reports each stem in turn, one line per stem, in the same form as today. The nine gates cost one parse and one sweep instead of nine. Nothing is written to disk beyond the mirror and the build log draftcheck already writes.
