# The stage-two walk, rulings of 2026-10-06

The docket is `notes/2026-10-06/stage-two-seams.md`. The user ruled rows S1 to S13 one at a time under the ratification-walk skill, added S3a and S5a from the discussion, and then delegated the open rows S14 to S38 to the coordinator. The coordinator read each row against `tools/oracle-closure/` and ruled as recorded below. A row marked "ratified" takes the docket's proposed default as written. An amended or added row carries its full text here, and that text is the ruling.

## Ledger

| Row | Verdict | Ruled by |
|---|---|---|
| S1 | Amended. The stage-two work does not manage schema versions. The new tables and columns pass the existing `Schema` project-word test, and a language is a column value, never a column name. | User |
| S2 | Ratified. | User |
| S3 | Ratified. | User |
| S3a | Added and ratified. Every stage-two table declares its primary key, `(file, function, seq)` for `statements` and the same three columns plus `line` or `start_offset` where one statement holds several rows, and an index on `(file, function)`. No foreign keys, because the loader writes a function's rows in one transaction and the cache rebuilds whole, so the constraint buys nothing and costs a pragma per connection. | User |
| S4 | Ratified. | User |
| S5 | Ratified. | User |
| S5a | Added and ratified. Carry-over 4, the signature rows. A generation `signatures`. `skeleton.py` writes the rows, because it runs after the parse and holds the input key. The generation's key is the input key plus a per-file hash of every Swift stub file the skeleton reads, and the `files` table keeps the per-file hashes as C2 rules. `lookup.py` checks the part it can compute, the Swift file hashes, and on a mismatch names the stale file and tells the user to run `skeleton.py`. It does not check the input-key part, because only a generator run can refresh it and the standing rule already says regenerate the manifests after every table change. | User |
| S6 | Ratified. | User |
| S7 | Ratified. | User |
| S7a | Added. The `language` column leads the primary key of `lowered`, `lines`, and `rejected`, before the three columns S3a names. One store holds the rows of more than one language, and the key must tell them apart. | Coordinator |
| S8 | Ratified. | User |
| S9 | Ratified. | User |
| S10 | Ratified. | User |
| S11 | Ratified. | User |
| S12 | Ratified. | User |
| S13 | Ratified. | User |
| S14 | Ratified. `Table.locals_of` and `Store.drop_locals` are the pattern the row cites, and both exist. | Coordinator |
| S15 | Ratified. The printer's key check follows the shape of S5a: it rehashes the paths the `files` table lists and the registry lines, and it needs no parse for either. | Coordinator |
| S16 | Ratified. `--compile-holes` is a new flag on `bodies.py` and `printer.py`. No command carries it today. | Coordinator |
| S17 | Ratified. `bodies.py` strips the statement mark from every output line, so the change of key leaves the printed bytes alone. | Coordinator |
| S18 | Ratified. | Coordinator |
| S19 | Amended. The docket text stands, with one case added: an unequal `replace` block gives `hand` rows with null `line_seq` for its hand lines, and its draft lines count as deleted on standard error. The docket ruled the equal-length block, the insert, and the delete, and left this case to the builder. | Coordinator |
| S20 | Ratified. | Coordinator |
| S21 | Ratified. | Coordinator |
| S22 | Ratified. | Coordinator |
| S23 | Ratified. `lookup.py` exits 2 on a missing input today, so the codes agree. | Coordinator |
| S24 | Ratified. The snapshot folder is the caller's and sits outside version control. | Coordinator |
| S25 | Amended. Carry-overs 1, 2, 3, and 5 are committed on the branch `cache-carryovers` in a worktree off wave-0 8170635, one commit each, and the tool tests went from 23 to 32. Carry-over 4 follows S5a and lands on the same branch. Gate: the 32 tests pass without a `manifest.py` run, and every generator output is byte for byte equal to wave-0. The builder ran that check by hand, and it stands for `snapshot.py --check` until step 1 exists. The branch lands before step 1. | Coordinator |
| S26 | Ratified. | Coordinator |
| S27 | Ratified. | Coordinator |
| S28 | Ratified. | Coordinator |
| S29 | Ratified, with one allowance. If `PM_pitch_roll_for_slope` does not show the five roles the row names, the builder picks a function that does and names it in the commit body. | Coordinator |
| S30 | Ratified. | Coordinator |
| S31 | Ratified. | Coordinator |
| S32 | Ratified. | Coordinator |
| S33 | Ratified. | Coordinator |
| S34 | Ratified. | Coordinator |
| S35 | Ratified. | Coordinator |
| S36 | Ratified. | Coordinator |
| S37 | Ratified. | Coordinator |
| S38 | Ratified. | Coordinator |

## Findings for the user

The committed manifest `.claude/manifest/ai_main.md` is three Swift line numbers behind the tree. Unchanged wave-0 code regenerates it with that diff, so the stale file predates this work. A regenerate on wave-0 is one commit the user has not asked for yet.

The branch `cache-carryovers` holds four commits and waits for the word to land, after carry-over 4 joins it under S5a.

`bodies.py` creates `table.sqlite` under `tools/oracle-closure/` on a run. The file is outside version control and the first cold run of the day pays about 75 seconds.
