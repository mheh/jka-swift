# The ledger of the fifth walk

The rows come from the findings of the session of 2026-11-10 and from the open rows of `HANDOFF.md`. The user ruled six rows. The coordinator ruled the other rows by proof, by the user's word "autorule things that can be determined from existing patterns in the codebase or learned from jka-rust. new patterns i rule on".

## The rows that the user ruled

| Row | Subject | Verdict | Lands in | Date |
| --- | --- | --- | --- | --- |
| 1 | The generator and its end | Ratified as amended, after the user's words "i would prefer to use the generator through the remaining product landings: the ui, sp, jamp executable and such. once we land all of them is when we stop using the generator". The port uses the generator through every product landing. Then the port stops using it, and the generated logic is rebuilt into Swift-oriented types. | the private goals file | 2026-11-10 |
| 2 | The hand signatures that are more Swift-like than the form of the table | Withdrawn by the coordinator after row 1. Row G of `after-the-stubs-ledger.md` decides each difference. | none | 2026-11-10 |
| 3 | Rule 15 against row E4 | Ratified as proposed. The rule is "Green at every landing". The gate passes on a branch before the merge, a commit inside a branch can fail to compile, and a referee divergence bisects to one landing with `git bisect --first-parent`. The other sentences of the rule stay. | `docs/porting-rules.md`, rule 15 | 2026-11-10 |
| 4 | Codegraph and the read set | Ratified as proposed. For a fact outside the read set that has a name, an agent asks codegraph for that symbol. A transcriptor never asks for a symbol of `jka-rust`. A Port-note follows only when codegraph does not settle the fact. | `docs/transcription.md`, "The read set", and the body writer card | 2026-11-10 |
| 5 | The cast sentence of memory entry 28 | Ratified as proposed. Three sentences: the named conversions between an `int` and a `float` are the only exceptions, another cast is a gap in the generator or the table, and a pointer cast that the Swift type does not need is dropped with no comment line. The memory entry is removed when the doc holds the text. | `docs/transcription.md`, after "A body never adds a cast Raven did not write" | 2026-11-10 |
| 6 | The two workflow sentences of `context-remains.md` | Ratified as proposed. Neither sentence is added. The file watcher of codegraph keeps the index current, and the coordinator file already requires the user's typed word for a merge. | none | 2026-11-11 |

## The rows that the coordinator ruled by proof

| Subject | Ruling | Proof | Lands in |
| --- | --- | --- | --- |
| The `case void` in the form of a closed class hierarchy | The doc stays. A subclass that adds no field has a case with no payload. | Row C makes the shape of `CRMInstance` the form, and that shape has `case void` in `CRMInstance.swift`. | `docs/transcription.md`, "A closed C++ class hierarchy" |
| The reviewer builds or not | The reviewer runs no build. | Row E4: "Reviews run on the branch that compiles". The reviewer definition has no tool that writes a file. | `docs/transcription.md`, section 4 |
| The reviewer fixes or not | The reviewer reports and puts no fix into a file. | Row E3 and the reviewer definition. | `docs/transcription.md`, section 1 |
| The commit and push lines in the two read-only cards | No change. | The lines are in the block that all four cards share, and they do nothing in a card with no write tool. | none |
| The two `portMissing` bullets of the reviewer card | No change. | Both are true: rule 14 for a ported body, and section 2 of `docs/transcription.md` for a hole in a body. | none |
| The scout card's "unless the brief names one" | No change. | The workflow rule forbids a report file. The exception of the card covers a scratch file. | none |
| The numbers 25 and 26 out of order | No change. | The number is the order of creation and the section is the place. | none |
| Rule 25 against the four symbols | `level` in `g_main.swift` becomes `public`. | `cg`, `cgs`, and the storage fields are public already. | `Sources/JKAMP_GameLogic/g_main.swift` |
| The silent empty list at `skeleton.py` and `merge.py` for an absent `extract.json` | Both get an error exit. | `merge.py` already exits with "Run extract.py first" for the absent folder. | `tools/oracle-closure/skeleton.py`, `merge.py` |
| The exit code of `reexport.py` | A probe build that fails with no names exits nonzero. | The script already returns 1 for a build that still fails after its last round. | `tools/oracle-closure/reexport.py` |
| The side labels of the referee scripts | The defaults are `a` and `b`. | `tools/host-referee.sh` names its sides that way. | `tools/referee/` |
| The logs of the referee scripts | A path argument, with the scratch folder as the default. | `tools/host-referee.sh` puts every output under `SCRATCH`. | `tools/referee/` |
| The size of the six live-path reviews | The file system part gets two agents, `files_pc.swift` alone, and `files_common.swift` with `unzip.swift`. Each other part gets one. | Row 2 of `after-the-stubs-ledger.md` splits a part above about 3000 lines. | the review briefs |
| The scope of the signature batch of row G | The batch covers the three units. | The count of row G was the dedicated unit only, and `rows-16-proofs.md` already gave the counts of the other two. | the brief of the batch |
| A hand variable of the cgame | It goes on `CGameWorld` under the MARK of its file, and not on `CGameVariables`. | `cg_local.swift` holds every such variable, and `CGameVariables` holds none. | `docs/porting-rules.md`, rule 3 |
| The count of a draft gate over a file with drafts | The count differs from the count over the stub only when a body was edited by hand. | `kept` of `draftcheck.py`. | `tools/oracle-closure/README.md` |
| The pass cap of `draftcheck.py` | The cap holds for one run, over the stems of that run. | `PASSES` and `run` of `draftcheck.py`. | `tools/oracle-closure/README.md` |
| `adopt.py` keeps every body that is not the marker pair | Nothing to add. | The tools README already says it. | none |
| One rule of `spelling.py` reaches the traps, the wrappers, and the stubs | Nothing to add. | `docs/oracle-closure.md` already says it. | none |

## The proof of the spectator finding

The finding of `after-the-stubs-ledger.md` is proven from the game state. Two replays of `corpus-ffa1.rec` ran on the engine of the fork for 2400 frames. Without the setting, each of the four clients has the join marker `@@@PLCONNECT` only, and the log holds no `Kill:` line. With `+set g_teamAutoJoin 1`, each client has `@@@PLENTER`, the log holds two `Kill:` lines, and the checksums differ from frame 1. The two kills are a fall and a crush, so the replay with the setting covers movement and death and almost no combat. A recording that is made with the setting covers combat.
