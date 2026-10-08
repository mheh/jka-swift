# The stage-two amendment walk, rulings of 2026-10-08

The first review of 2026-10-07 named five rows whose text no longer matches the code after steps 1 to 4, and the second review of 2026-10-08 added facts to three of them. The user ruled each row one at a time under the ratification-walk skill. An amended row carries its full amendment here, and that text is the ruling on top of the row in `notes/2026-10-06/stage-two-seams.md` and its verdict in `notes/2026-10-06/stage-two-walk.md`.

## Ledger

| Row | Verdict | Ruled by | Date |
|---|---|---|---|
| S2 | Amended as proposed. The init and the step of a `for`, and the two sides of a comma operator in a statement place, get a row beside the statement nodes. The rest of the text stands. | User | 2026-10-08 |
| S5 | Amended as proposed. The key covers the adoption key, the declaration lines the registry reads from every Swift file under Sources, the generated files included, and the lowering modules that `project.toml` lists under its lowering key, which is the one list. The key and the reset of the lowered rows are per language. Today's single key stands until stage three brings the second language. | User | 2026-10-08 |
| S7 | Amended as proposed. `seq` numbers the rows of one function from the first header row to the closing brace, and a trailing row has its own `seq` and the depth of the line it follows. `statement_seq` is null for a header row and for the function's own braces, as ruled, and step 5 marks every top-level line of the body walk with the body's seq 0 so the code meets the text. `text` carries no indentation, except a header row, which keeps the stub's own bytes and the printer never reindents. | User | 2026-10-08 |
| S14 | Amended as proposed. A key change drops every `lowered` and `lines` row. The reset runs once, when the lowering object opens under a key that differs from the stored key, and it names the stale files on standard error from the per-file hashes. The per-function form stands as ruled. | User | 2026-10-08 |
| S38 | Amended as proposed. The printer prints the footer from the count of line rows with role note, as S38a rules, and the blank line between functions. The `lowered` rows with form hole and note stay as the per-statement count, and S6's "one query answers both counts" holds per statement, not per hole. Step 5 retires the in-memory footer of `bodies.py`, and the S30 test then compares the drafter's lines against the printer. draftcheck keeps its own join and prints the drafter's counter. | User | 2026-10-08 |

## What the amendments give the next builders

Step 5 carries two items from this walk: one `marked()` call around the body walk with the body's seq 0, so no line but the header and the function's own braces carries a null `statement_seq`, and the retirement of the in-memory footer of `bodies.py` once `printer.py` prints the footer from the rows. Stage three carries one: the lowered key and its reset become per language before a second language writes rows.
