# The prune of the memory folder, row E9

This record gives each of the 47 memory entries a destination. The homes come from the table "The homes of facts" of `notes/2026-11-11/after-the-stubs-ledger.md`. Nothing is applied. The user rules on this record, then one pass applies it.

Section 4 is the last section of the file, because it holds the full text of seven entries.

## Findings that touch more than one entry

- `docs/` has no architecture section. The files are `oracle-closure.md`, `porting-rules.md`, `style.md`, and `transcription.md`. Sections B and D of `docs/porting-rules.md` hold the architecture facts today. See question Q1.
- `.claude/CLAUDE.md` does not exist. `.claude/agents/` does not exist. `tools/gate.sh` and `tools/worktree-setup.sh` do not exist. Rows E1, E3, and E9 are not built, so each "contradicts" verdict below compares an entry with a ratified row, not with a tool on disk.
- The docs break their own timeless form at four lines: `docs/porting-rules.md:3` ("walked row by row on 2026-09-08"), `docs/porting-rules.md:47` ("Ruled 2026-09-09."), `docs/transcription.md:23` ("Ruling of 2026-09-09."), and `docs/transcription.md:839` ("Ruling of 2026-09-09."). Row E9 lets this pass only add text, so these lines need a ruling of their own. See question Q6.
- Rule 24 of `docs/porting-rules.md` is at line 71, below the heading "Import and path style" and after rule 23 at line 48. Its text is correct. Its position is wrong.
- The index `MEMORY.md` is stale against its own file for the walk state. The index line says "2026-11-10 master 001b610c after PRs 88 to 94 ... 99 stubs on a local branch, batch 13 in flight". The entry file says master `7d192ce6`, PRs 95 and 96, zero stubs on `dedicated-integration-16`.
- Six rulings have their reason in memory only, with no ledger row that a search of `notes/` finds: the task-local ban, the codegraph rule, the commit-only rule, the public surface for forks, the three CI rulings, and the five-hour limit. Each one goes to a home that carries the reason, or its full text is in section 4.

## 1. The table of the 47 entries

Short names: "coordinator file" is `.claude/CLAUDE.md`. "PR" is `docs/porting-rules.md`. "TR" is `docs/transcription.md`. "OC" is `docs/oracle-closure.md`.

| # | Entry file | Kind | Destination | Reason |
| --- | --- | --- | --- | --- |
| 1 | `hook-text-is-not-an-invoke.md` | Workflow rule, all projects | Remove as history | The global `CLAUDE.md` holds the invoke rule, and row E8 makes the hook print it. Row E8 makes the first sentence false. |
| 2 | `jka-swift-adopt-with-first-hand-edit.md` | Rule of the port | Doc: OC, "4. The invariants" | The doc states adoption. It does not state the same-commit rule. One sentence to add. |
| 3 | `jka-swift-agent-briefs-carry-both-skills.md` | Workflow rule | Remove as history | TR line 49 holds the rule. Row E3 replaces the two brief lines with preloaded skills. |
| 4 | `jka-swift-agents-cite-user-reads.md` | Workflow rule | Coordinator file | Row E7 states the same rule: the coordinator reads the cited lines. |
| 5 | `jka-swift-agents-commit-only.md` | Workflow rule | Coordinator file | A rule for every brief. No note under `notes/` holds it. |
| 6 | `jka-swift-agents-run-checks-serially.md` | Workflow rule | Coordinator file | The no-tail rule stands. The list of checks an agent runs is stale under rows E1 and E4. |
| 7 | `jka-swift-ai-comment-at-changed-sites.md` | Rule of the port | Doc: PR, rule 24. Nothing to add | The doc holds every part of the rule. |
| 8 | `jka-swift-bg-docket-rulings.md` | Mixed: pointer, tool facts, one open row | Doc: `tools/oracle-closure/README.md`, "Known gaps" | Two tool facts have no home. One fact is in PR rule 3. One fact is an open row. See Q2. |
| 9 | `jka-swift-blind-agents-read-set.md` | Rule of the port | Doc: TR, "The read set". Nothing to add | The doc holds the read set, and it is more exact than the entry. |
| 10 | `jka-swift-branch-and-pr-workflow.md` | Workflow rule | Coordinator file | Branch and PR flow. The `wave-0` sentences are history. |
| 11 | `jka-swift-builder-gates-once-at-end.md` | Workflow rule | Coordinator file | The one-gate-at-the-end rule stands. The per-item `swift build` is stale under row E4. |
| 12 | `jka-swift-ci.md` | Workflow rule plus state | Coordinator file | The three "do not propose" rulings have no ledger. `.github/workflows/build.yml` holds the lane facts. See Q3. |
| 13 | `jka-swift-codec-in-charbuf-only.md` | Rule of the port | Doc: TR, "A `char *` at runtime" | The doc states the rule. It does not list the banned spellings. One sentence to add. |
| 14 | `jka-swift-codegraph-first.md` | Workflow rule | Coordinator file | A brief rule and a session-start step. No note holds it. |
| 15 | `jka-swift-compile-agent-body-only-rounds.md` | Workflow rule | Remove as history | Row E4 removes the compile agent. One sentence survives in the coordinator file. |
| 16 | `jka-swift-dated-folder-records.md` | Workflow rule | Coordinator file | Where a record goes. The homes table agrees. |
| 17 | `jka-swift-dead-functions-get-bodies.md` | Rule of the port | Doc: PR, rule 20. Nothing to add | The doc holds the rule. The entry's open question is wider in the doc. See Q4. |
| 18 | `jka-swift-delegate-to-subagents.md` | How the user works | Keep in memory, with new text | The user's wish stands. "on opus" and "builds" are stale under rows E7 and E4. |
| 19 | `jka-swift-delegated-rulings.md` | How the user works | Keep in memory, with new text | The limit of the coordinator's authority is the user's own. It takes entry 36. |
| 20 | `jka-swift-do-not-adulterate-raven.md` | Rule of the port | Doc: PR, rule 19 | The doc states the divergence rule. It does not state that Raven's logic bugs stay. One sentence to add. |
| 21 | `jka-swift-docs-are-timeless-truth.md` | Workflow rule | Coordinator file | A rule for every doc edit. The words "and in memory" are stale under row E9. |
| 22 | `jka-swift-drafter-analysis-2026-09-23.md` | Pointer plus one lesson | Doc: OC, "3. The judgment layer" | The note under `notes/` holds the findings. The lesson needs one sentence in the doc. |
| 23 | `jka-swift-gate-output-before-commit.md` | How the user works | Keep in memory | The user reads output, wants no diff, and commits on a typed word. It takes entry 47. |
| 24 | `jka-swift-generator-change-runs-sequence.md` | Workflow rule plus one tool fact | Coordinator file | The three-step order is a brief rule. The tool fact needs one sentence in OC. |
| 25 | `jka-swift-handoff-command.md` | How the user talks | Merge into `jka-swift-user-pauses-agents-directly` | Two words of the user and their meaning. The shape of `HANDOFF.md` is stale under row E5. |
| 26 | `jka-swift-jka-rust-read-only.md` | Workflow rule | Coordinator file | TR lines 41 and 42 hold the two-tree fact. The write ban is a rule for every agent. |
| 27 | `jka-swift-legibility-goal.md` | The user's goal | Keep in memory, with new text | The goal is the user's. It takes entries 40 and 46. See Q5. |
| 28 | `jka-swift-no-casts-in-bodies.md` | Rule of the port | Doc: TR, "Primitive types" | The doc holds the rule. One sentence to add. The "still open" sentence is stale. |
| 29 | `jka-swift-no-new-helper-litter.md` | Rule of the port | Doc: PR, section C, a new rule | No doc states the rule. One rule to add. |
| 30 | `jka-swift-no-rerun-after-agent-gate.md` | Workflow rule | Remove as history | Row E4 moves the gate to the coordinator, so no agent gate exists to run again. |
| 31 | `jka-swift-no-submodule-deinit.md` | Workflow rule | Coordinator file | Row E1 puts the rule in `tools/worktree-setup.sh`. The removal steps stay a coordinator rule. |
| 32 | `jka-swift-no-task-local.md` | Fact of architecture | Doc: PR, rule 6 | The doc states the two singletons. It does not state the ban or its reason. One sentence to add. |
| 33 | `jka-swift-one-snapshot-cache.md` | Workflow rule | Coordinator file | The no-copy rule stands. "The only cache" is false: three caches exist. |
| 34 | `jka-swift-performance-docket.md` | Ruling | Ledger only | `notes/2026-10-29/performance-profile.md` and row 5 of the 2026-11-11 ledger hold it. The entry's order is stale. |
| 35 | `jka-swift-project-origin.md` | History | Remove as history | Two of its three facts are false today. PR line 3 states what the project is. |
| 36 | `jka-swift-prove-rows-before-presenting.md` | How the user works | Merge into `jka-swift-delegated-rulings` | One rule with entry 19: prove first, then rule or present. |
| 37 | `jka-swift-public-surface-for-forks.md` | Fact of architecture | Doc: PR, section B, a new rule | No doc states it. One rule to add. See Q1. |
| 38 | `jka-swift-round-shape.md` | Workflow rule of the cgame rounds | Remove as history | The cgame rounds are done. The user's wish to test first goes to `jka-swift-user-drives`. |
| 39 | `jka-swift-rounds-run-fast-and-parallel.md` | How the user works | Keep in memory, with new text | The time limit is the user's. The mechanics go to the coordinator file. One sentence contradicts entry 5. |
| 40 | `jka-swift-running-game-before-fixes.md` | The user's priority | Merge into `jka-swift-legibility-goal` | The game runs and the pools are done, so most of the text is stale. One rule survives. |
| 41 | `jka-swift-solid-box-investigation.md` | Ruling | Ledger only | `notes/2026-10-29/solid-box-ruling.md` and the three files under `notes/2026-09-29/` hold it. |
| 42 | `jka-swift-transcription-workflow.md` | Workflow as of 2026-09-28 | Remove as history | TR and OC hold the guide. The writer and compile agents are gone. |
| 43 | `jka-swift-unattended-run-handoff.md` | State of the work | `HANDOFF.md` | Row E5: the entry becomes a pointer. Every sentence in it is state. |
| 44 | `jka-swift-user-drives.md` | Who the user is | Keep in memory | It takes one sentence from entry 38. |
| 45 | `jka-swift-user-pauses-agents-directly.md` | How the user works | Keep in memory | It takes entry 25. See Q7 for `context.md`. |
| 46 | `jka-swift-whole-project-before-legibility.md` | The user's priority | Merge into `jka-swift-legibility-goal` | The order of the products is the user's. Row 8 of the 2026-11-11 ledger holds the exact order. |
| 47 | `jka-swift-write-records-do-not-show.md` | How the user works | Merge into `jka-swift-gate-output-before-commit` | The same rule as the diff rule: write, do not paste. |

Counts: keep in memory 7, merge into a memory entry 5, coordinator file 13, doc 12, ledger only 2, `HANDOFF.md` 1, remove as history 7.

## 2. The entries with a doc as destination

Twelve entries have a doc as destination. Entry 24 has the coordinator file as destination and gives one doc sentence more. Eleven sentences to add in total. Three entries add nothing.

### Entry 2, `jka-swift-adopt-with-first-hand-edit.md`

The doc states adoption three times:

- `docs/oracle-closure.md:40`: "An adopted stub is left alone. A stub becomes adopted when its generated header line is deleted, and the generator then reports it instead of writing over the port."
- `docs/transcription.md:11`: "The transcriptor's first edit is to delete the generated header line at the top of its Swift file ... which adopts the file so a later generator run never overwrites the port."
- `docs/porting-rules.md:33` (rule 13): "A generated file is adopted the first time a hand edit is needed."

The doc does not hold: the header removal and the first hand edit go into one commit, and the manifest of the file is generated again.

Sentence to add, at the end of the third bullet of `docs/oracle-closure.md`, "4. The invariants":

> The first hand edit of a stub and the deletion of its header line are one commit, with the file's manifest generated again, because a generator run writes over every stub that still carries the line.

### Entry 7, `jka-swift-ai-comment-at-changed-sites.md`

`docs/porting-rules.md:71` (rule 24): "A ruling that changes Raven's form leaves an `AI:` comment at the site. One line, two at most, in the form `// AI: Raven <what Raven did>. <What the ruling changed it to>.` The comment names the mechanism and not the row number ... A rule 19 note keeps its `Port-note:` prefix ... A site that keeps Raven's form carries no comment."

Nothing to add. The entry's reviewer check ("no changed site lacks it and ... no faithful site has one") belongs in the reviewer card of row E3, with rule 24 as its proof.

### Entry 8, `jka-swift-bg-docket-rulings.md`

The entry has one paragraph of pointers and five facts. Each part, in order:

- The pointer paragraph. `docs/transcription.md:79` says "A shape rule is code in `table.py`", and `docs/oracle-closure.md` says "The rulings hold the names. A generator reads `rulings.py` and never invents a name". The homes table replaces the rest. Nothing to add.
- Fact 1, "`Promotion.swift` covers `Int32` only. Sites like `Float(bg.pm.cmd.forwardmove)` over `Int8` fields stay as casts." `docs/transcription.md:628` says that `Promotion.swift` defines the operators "between `Int32` and `Float`". The site is real today: `Sources/JKAMP_BG/bg_pmove.swift:2738` reads `Float(pm.cmd.forwardmove)`. The entry calls it "an open row, not a defect". An open row is state. It goes to the section "What waits" of `HANDOFF.md`, or the user closes it. See Q2.
- Fact 2, "The variable sweep misses a write through a pointer alias (SaberParms), so a global written only that way can class as a `let`." No doc holds it. A search for "pointer alias" and "SaberParms" in `docs/oracle-closure.md` and `tools/oracle-closure/README.md` finds nothing. I did not run the sweep, so I cannot say that the gap is still open.
- Fact 3, "Only the QAGAME arms are in the game parse, so cgame-only traps and CG_ functions never appear as calls. channel.py runs the cgame parse beside it for the foreign straps." No doc holds it. A search for "QAGAME" and "cgame parse" in the same two files finds nothing.
- Fact 4, the placement rule. `docs/porting-rules.md:12` (rule 3): "Every Raven global is a computed property over that instance, declared in the stub of the Raven file that declared it, at Raven's line". Nothing to add.
- Fact 5, "The README of tools/oracle-closure carries no dates and no counts, the manifests carry the numbers." This is the timeless rule of entry 21 for one file. It goes to the coordinator file with entry 21.

Sentences to add, under "Known gaps" of `tools/oracle-closure/README.md`, if the user confirms that both are still true:

> The variable sweep does not see a write through a pointer alias, so a global that a body writes only through an alias can class as a `let`.

> The game parse holds the `QAGAME` arms only, so a cgame-only trap or a `CG_` function is never a call in it. `channel.py` runs the cgame parse beside it for the foreign straps.

### Entry 9, `jka-swift-blind-agents-read-set.md`

`docs/transcription.md:23` to `:45` holds the read set. Line 44: "Neither role greps across `Sources/`." Line 45: "When a needed fact sits outside the read set, the agent writes a Port-note and moves on." Line 13: "It reads the oracle only. It never reads jka-rust."

Nothing to add. One part of the entry is stale against the doc: the entry's description says "and the referenced view files". The doc names the lookup tool at lines 29 to 37, and no view file is in the read set.

### Entry 13, `jka-swift-codec-in-charbuf-only.md`

`docs/transcription.md:586`: "The String-to-bytes codec lives only in the two initializers of `CharBuf.swift`, `CharBuf(_ string:)` and `String(_ buf:)`, one byte for each scalar in both directions, and every other helper and view read works on bytes through `CharBuf`, as its C original does."

The doc does not hold: the list of spellings that never appear, and the rule for the trap templates. The entry's sentence "The word Latin-1 appears once, in the doc comment of those two initializers" is a fact of `CharBuf.swift` and needs no doc line. The reason (the user's words "without hidden logic and unnecessary helpers") is in `notes/2026-10-11/w19-openjk-encoding.md` and the walk of 2026-10-27.

Sentence to add after line 586:

> No file other than `CharBuf.swift` writes `unicodeScalars.map`, `.utf8`, `String(cString:)`, or Foundation's `.isoLatin1`, and a trap template writes `CharBuf(string)` and no encode helper.

### Entry 17, `jka-swift-dead-functions-get-bodies.md`

`docs/porting-rules.md:45` (rule 20): "A function with zero callers in either tree gets its real body like any other function, so the port is complete where the server never calls the code, and the function carries a one-line note that says it has no caller and why."

Nothing to add. One sentence of the entry disagrees with the doc: "The user's words were about the dedicated stubs. I have not asked whether the dead stubs of the game and cgame targets follow: ask before a sweep there." Rule 20 has no such limit. See Q4. The entry's sentence "A dead function that needs a new codebase-wide form ... still goes to the user" is the limit of entry 19 and stays there.

### Entry 20, `jka-swift-do-not-adulterate-raven.md`

`docs/porting-rules.md:44` (rule 19): "Diverge only where Raven's behavior is undefined: a buffer overrun, a null dereference, a read of uninitialized memory. Pick the one defined behavior, note it in at most two lines at the site". `docs/porting-rules.md:8` (rule 2): "If Raven's behavior is unclear, port it faithfully first, even if ugly."

The doc does not hold: "Never fix Raven's own logic bugs, such as the team parse key, unless they trap", "keep it to one test", and "keep his callers as written". The entry's list of preferred forms (a NULLABLE row, a data fill, a trap kind) is an example list for the generator card, not a rule.

Sentence to add at the end of rule 19:

> The divergence is one test at the site, and Raven's callers stay as he wrote them. A logic bug of Raven's whose behavior is defined stays in the port.

### Entry 22, `jka-swift-drafter-analysis-2026-09-23.md`

`docs/oracle-closure.md:34`: "The compile gate is the proof. A draft that builds in the mirror carries no defect the Swift compiler can see".

The doc does not hold the limit of that proof. The entry: "a gate at zero defects is a compile gate, not a behaviour gate. A draft that compiles can still hang a rewritten `for` loop on a `continue`, lose a write through a member path passed twice by `&`, or compute a double literal in Float." The rest of the entry is a pointer to `notes/drafter-analysis-2026-09-23.md` and to walks that hold the rows. That part is ledger only.

Sentence to add after the quoted sentence of line 34:

> A draft that builds can still be wrong in behavior, so a gate with no defect is no proof of behavior.

### Entry 28, `jka-swift-no-casts-in-bodies.md`

- `docs/transcription.md:618`: "An array index is the C constant or variable Raven wrote, for example `vec[YAW]` and `ps.stats[STAT_HEALTH]`, never `Int(...)`. Every array in the port takes any C integer index."
- `docs/transcription.md:620`: "A C enum is an `Int32` typealias, and each case is a bare `Int32` constant with Raven's name."
- `docs/transcription.md:622`: "`.rawValue` and `EnumName(rawValue:)` never appear."
- `docs/transcription.md:627`: "A cast Raven wrote explicitly stays on the page, so `(int)v[0]` is `Int32(v[0])` and `(float)x` is `Float(x)`. A body never adds a cast Raven did not write."

The doc does not hold: "When a body needs any other cast to compile, treat it as a generator or table gap and fix the shape once, never the site."

Stale sentence of the entry: "Implicit int to float conversions Raven wrote without a cast (`Float(ps.movementDir)`) are still open and need their own row." `docs/transcription.md:628` closes it for `Int32`: `Promotion.swift` "promotes the integer as C does". What is left is fact 1 of entry 8.

Sentence to add after line 627. It is in tension with line 644 ("Any other `float` stored into an `int` takes `Int32(...)` at the store"), which is a cast that Raven did not write. The user must confirm the wording:

> Where a body needs another cast to compile, the cause is a gap in the generator or the table, and the fix is the shape and not the site.

### Entry 29, `jka-swift-no-new-helper-litter.md`

No doc states the rule. A search of `docs/porting-rules.md` and `docs/style.md` for "counterpart" and "helper" finds only rule 21 ("private helpers in the same file"). `docs/transcription.md:586` applies the idea to the codec only.

Rule to add as a new numbered rule in section C of `docs/porting-rules.md`:

> **No name without a counterpart.** A logic target gains no function, overload, type, enum, or extension member that has no counterpart of the same role in Raven's source or in OpenJK. A body uses Raven's own form, an existing helper, or a plain Swift construct. Where Swift needs a new name, the name stays inside an existing helper or inside a generator's output, and no game body spells it.

The user's words ("i don't want to litter the codebase with new funcs like rust. i want it to look somewhat like raven/openjk.") are in `notes/2026-10-11/phase-2-walk.md` by a search for "litter". I did not read that row.

### Entry 32, `jka-swift-no-task-local.md`

- `docs/porting-rules.md:15` (rule 6): "each is one instance behind one name: `Syscall.transport` in `JKAShared`, the installed `SyscallTransport`, and `world` in the logic target. No other static exists."
- `docs/porting-rules.md:12` (rule 3): "exactly one `nonisolated(unsafe) let world` instance exists in the logic target".
- `docs/porting-rules.md:35` (rule 15) names `swift test --no-parallel`.

The doc does not hold: the ban on a task-local, its reason, and why the tests run with `--no-parallel`. `notes/LEDGER.md` has no row with these words, so memory is the only place of the reason today.

Sentences to add at the end of rule 6:

> Neither singleton is a task-local value or a per-call binding, because that adds a lookup to every `world` read in the entity loops for a gain that only the tests see. The test suites run one at a time under `--no-parallel` for that reason, and no lock guards a singleton.

The entry's sentence "`withTransport` in `JKATestSupport` stays for the transport" is a fact of the test target. It needs no doc line.

### Entry 37, `jka-swift-public-surface-for-forks.md`

No doc states it. A search of `docs/` for "public" finds only generated members of views (`docs/transcription.md:358` to `:361`).

Rule to add in section B of `docs/porting-rules.md`, or in the architecture section if the user makes one (Q1):

> **The state and the entry points are public.** Each world, each storage, each state singleton, and each function at the level of `vmMain` is `public`, so a fork can add a target that reaches the engine through them. This repository holds no mailbox, task, actor, lock, or queue.

The entry's inventory ("`world`, `g_entities`, `BgState`, `CGameWorld`, the transport, and the bg tables are already public; `level`, the storage field, `cg`, and `cgs` are internal") is a snapshot of 2026-10-31. I did not check it against the tree. It does not go into the doc.

### Entry 24 (destination: coordinator file), the one tool fact

`docs/oracle-closure.md:90`: "`snapshot.py --check <folder>` writes a new snapshot and compares the two by `diff -r`."

The doc does not hold the entry's sentence: "The snapshot gate checks the generators against the cache, not the cache against the committed tree, so a stale committed file hides."

Sentence to add at the end of "The snapshot gate" of `docs/oracle-closure.md`:

> The check compares the generators with the snapshot and not with the committed tree, so a committed generated file that no run has written again can be stale under a green check.

## 3. The entries that rows E1 to E9 contradict

Each known candidate is checked against the real text. Six more entries have a sentence that a row contradicts.

### Entry 3, `jka-swift-agent-briefs-carry-both-skills.md`, row E3

Contradicted: "every transcriptor, reviewer, and sweep brief carries two lines, each on its own line: `Invoke the house-style skill before you write anything, and pass this instruction to your sub-agents.` and `Invoke the asd-ste100 skill before you write any sentence of your own, a Port-note, a comment, or a doc line.`" Row E3 gives the four agent definitions "the two skills preloaded where the role writes", and row E7 limits a brief to "the slice".

Still right: "Raven's own comments are copied as written and are exempt." Still right for an agent with no definition (for example a general agent): the global `CLAUDE.md` asks for one invoke line for each skill.

The same row contradicts the doc: `docs/transcription.md:49` says "Every transcriptor, reviewer, and sweep brief carries the house-style and asd-ste100 invoke lines at the start." Row E9 lets the doc pass only add text, so this line needs its own ruling. See Q6.

### Entry 6, `jka-swift-agents-run-checks-serially.md`, rows E1 and E4

Contradicted in part: "An agent runs draftcheck, snapshot checks, the generator sequence, swift build, and swift test as one Bash call each, in series." Row E4: "A writing agent writes, commits, and reports, with no `swift build` and no `swift test`." Row E1 puts the builds, the tests, the tool tests, and the snapshot checks into one script, `tools/gate.sh`. So the sentence is false for a writing agent. It stays true for the fix agent, the Linux fix agent, and a generator agent.

Still right, for every agent that runs a check and for the coordinator: "The agent ends its turn to wait: it does not fill the wait with other tool calls, and it does not tail the output file. No monitor, no until-loop, no tail, no log polling."

### Entry 15, `jka-swift-compile-agent-body-only-rounds.md`, row E4

Contradicted: "In the adoption workflow (writer agents splice per file and never compile, one compile agent gates), a body-only round gives the compile agent `swift build` and `swift test --no-parallel` alone." and "Write the compile agent's brief with the two build steps only". Row E4: "The coordinator merges the branches of a wave, runs `tools/gate.sh --only build` once, and gives the compile errors to one fix agent in one batch." No compile agent exists in that flow.

Still right: "The probe and the six generators (views, skeleton, traps, channel, manifest, tables) run only when a drafter rule, a signature, or a generator script changed." Also right, and in `docs/oracle-closure.md:40` in other words: "skeleton.py overwrites any stub file that still carries its header line".

### Entry 30, `jka-swift-no-rerun-after-agent-gate.md`, rows E1 and E4

Contradicted: "When an agent reports that it ran the gate (swift build, swift test --no-parallel, draftcheck over the bg stems) and gives the counts, the main session does not run them again." Under row E4 the coordinator runs the build once and "the full gate runs once at the end", through `tools/gate.sh` of row E1. A writing agent reports no gate counts, so the premise is gone.

Still right in spirit, for the fix agent or a generator agent that builds: do not repeat a check that an agent reported with counts. Still right, and held by entry 23: "report the counts in prose, never paste a diff, and wait".

### Entry 43, `jka-swift-unattended-run-handoff.md`, row E5

Contradicted as a whole. Row E5: "The memory entry for the walk state becomes a pointer to the file." Every paragraph of the entry is state, for example: "On 2026-11-11 master is at `7d192ce6` (PRs 95 and 96 ...), CI green, 31 dedicated stubs and 1 cgame stub on master. The local branch `dedicated-integration-16` (`/tmp/jka-int-16`) holds the last bodies". Row E5 also bans a `/tmp` path in `HANDOFF.md`, so the path does not move with the text.

The state itself agrees with `HANDOFF.md` lines 9 to 12. One difference: the entry says the close-out agent "was in flight", and `HANDOFF.md:10` says "The full gate was green on that head". `HANDOFF.md` is the later text.

### Entry 5, `jka-swift-agents-commit-only.md`, rows E3 and E7

Contradicted in part: "Put the line beside the house-style, asd-ste100, codegraph, and check-rule lines at the top of every brief, read-only briefs included." Under row E3 the definition carries the role's rules, and under row E7 a brief holds the slice only. The line "You cannot push. You commit only." belongs in each of the four cards and in the brief of an agent with no definition.

Still right: the rule itself, and "The main session pushes the branch, opens the PR, and merges, each on the user's typed word."

### Entry 11, `jka-swift-builder-gates-once-at-end.md`, row E4

Contradicted: "the per-item gate is the tool tests, or `swift build` and `swift test --no-parallel` when Swift changed." Row E4 gives a writing agent no build. Entry 24 also contradicts it for a generator batch: "No check runs before the last change of a pass is in".

Still right: "The full draftcheck references, the snapshot check, and the per-stem counts run once after the last commit". Row E1 makes that one call of `tools/gate.sh`.

### Entry 18, `jka-swift-delegate-to-subagents.md`, rows E3, E4, and E7

Contradicted: "Delegate implementation work, file reads, proofs, and builds to subagents on opus". Row E7: "The cheapest tier that fits: `haiku` for a lookup, `sonnet` for inventories, scouts, and mechanical edits, `opus` for bodies, reviews, and generator batches". Row E4 gives the wave build to the coordinator. Contradicted: "Every brief carries the house-style invoke line." (row E3). Contradicted in part: "An opus agent does the implementation and reports back".

Still right: "Keep the main session's context low", "run them in parallel wherever the work is independent", and "This holds even for a two-line fix or a record amendment, when an agent can do it."

### Entry 25, `jka-swift-handoff-command.md`, row E5

Contradicted: "The deliverable is HANDOFF.md at the repo root, in the shape of the existing one: where the tree is, what comes next, open findings, standing rules, suggested skills. Update the one that exists instead of making a second file." Row E5: "at most 40 lines in four sections (State, What waits, Next, Pointers), written again from nothing at each change". "Standing rules" now go to the coordinator file.

Possibly contradicted: "write context.md at the root of its worktree". Row E5 says "`context.md` goes". See Q7.

Still right: no skill named `handoff` is installed, and "Do not kill it."

### Entry 45, `jka-swift-user-pauses-agents-directly.md`, row E5

Possibly contradicted: "`context.md` at the repo root is the agent's resume file, kept until the user resumes or the work is committed." Row E5: "`context.md` goes, after anything still true moves into a dated record." The row is about the coordinator's file at the repo root. It does not name the pause file of an agent. See Q7.

Still right: "when an agent reports a user-requested pause, leave it paused and report the state to the user."

### Entry 21, `jka-swift-docs-are-timeless-truth.md`, row E9

Contradicted: "The ledger and the dates live in the dated folders under notes/ and in memory, not in the repo docs." Row E9 takes rulings out of memory: a ruling and its reason live in the dated ledger. The rest of the entry agrees with row E9.

### Entry 1, `hook-text-is-not-an-invoke.md`, row E8

Contradicted as a fact: the description says "The startup hook prints the house-style text". Row E8: the hook "prints two lines in place of the two skill files". After row E8 the hook states the rule of this entry, so the entry has no work left.

### Entries that a row of the first walk or another entry contradicts (no E row)

- Entry 34, `jka-swift-performance-docket.md`: "do not start a performance row before the cgame module is done. When cgame is done, walk R1 to R5 in order". Row 5 of the first walk: "rows R1 to R5 ... wait until the whole project is ported." Row 8 puts the performance docket last. The index line "build after cgame" is stale in the same way.
- Entry 33, `jka-swift-one-snapshot-cache.md`: "The snapshot cache `~/.cache/jka-swift/snapshot-stage-two-shared` is the only cache." Three exist today: `snapshot-mp-cgame`, `snapshot-mp-engine-ded`, `snapshot-stage-two-shared`. Row 6 of the first walk says "the three snapshot caches". Row E1 adds that the gate script "never writes into `~/.cache/jka-swift/`", so "After a landing, refresh the cache in place" is a coordinator step and not a gate step.
- Entry 39, `jka-swift-rounds-run-fast-and-parallel.md`: "one agent per stem or batch in its own worktree off master, each ending in a pushed PR." Entry 5, one day later: "You cannot push." Row E4 also merges the branches of a wave into one branch.
- Entry 35, `jka-swift-project-origin.md`: "The private repo mheh/jka-swift was created on 2026-09-08. Work lands on branch wave-0." Entry 12: the repo is public since 2026-10-28. Entry 10: `wave-0` is deleted.
- Entry 40, `jka-swift-running-game-before-fixes.md`: "deeper fixes such as removing Raven's pools wait until then" and "the work is transcription hole rounds, bg first, then game, toward a module that loads and runs". Entry 46 says "with the MP game module complete and the pools done". Both sentences are stale.
- Entry 42, `jka-swift-transcription-workflow.md`: "A drafter defect goes to the drafter as a shape rule, never as a hand fix in the file". Entry 27: "The user stopped the drafter rule rounds on 2026-10-04 ... and turned the remaining defects into holes." Entry 38 replaced the writer agents with `adopt.py`.
- Entry 27, `jka-swift-legibility-goal.md`: "written to ~/Desktop/jka-swift-goals.md". That file does not exist today.
- Entry 44, `jka-swift-user-drives.md`: "Surface design choices for a ruling instead of picking defaults silently." Entry 19 narrows it: a provable row with no new codebase-wide pattern is the coordinator's to rule.
- Entry 36, `jka-swift-prove-rows-before-presenting.md`: "send investigator agents (opus)". Row E7 gives a scout to `sonnet` and a review to `opus`. The tier of a proof agent is not ruled. The merged text below names no tier.
- Entry 47, `jka-swift-write-records-do-not-show.md`: no contradiction. Row E8 ("The coordinator shows the new file content before it writes the file") is an exception for one file outside the repo.

## 5. The draft of `.claude/CLAUDE.md`

59 lines. Each line names its source in a trailing comment.

```markdown
# How the coordinator runs jka-swift

## Read first
- `HANDOFF.md` at the repo root holds the state. Read it before any work. <!-- E5 -->
- Check for `.codegraph/` in the main tree at session start, and run `codegraph init` when it is missing. <!-- jka-swift-codegraph-first -->
- The rules of the port are in `docs/porting-rules.md` and `docs/transcription.md`. The pipeline is in `docs/oracle-closure.md`. <!-- jka-swift-transcription-workflow -->

## Where facts go
- A rule of the port goes to the two rule docs, and the role card changes in the same commit. <!-- E9 -->
- A fact of architecture goes to the architecture section in `docs/`. <!-- E9 -->
- A rule of this workflow goes to this file. State goes to `HANDOFF.md`. <!-- E9, E5 -->
- A ruling and its reason go to the ledger of `notes/<date>/`. `notes/LEDGER.md` takes no new row. <!-- jka-swift-dated-folder-records -->
- Every ledger has a "lands in" column, and a row is not closed until its text is in that home. <!-- E9 -->
- A doc states what is: no date, no "ratified", no row number, no sentence that says a shape changed. Edit the sentence in place. <!-- jka-swift-docs-are-timeless-truth -->
- `tools/oracle-closure/README.md` carries no dates and no counts. <!-- jka-swift-bg-docket-rulings -->

## Agents
- Use the four definitions `jka-body-writer`, `jka-reviewer`, `jka-generator`, and `jka-scout`. <!-- E3 -->
- Tiers: `haiku` for a lookup. `sonnet` for inventories, scouts, and mechanical edits. `opus` for bodies, reviews, and generator batches. A Fable agent only on the user's explicit word. <!-- E7 -->
- A brief holds the slice: the agent type, the task, the function list with Raven's file and line range, the ledger rows quoted, the worktree, and the branch. No whole docket and no rules document. <!-- E7 -->
- One agent continues a chain of dependent tasks by message. <!-- E7 -->
- Start independent agents in one message. Keep tool edits serial in one worktree, because a drafter change moves every stem's draft. <!-- jka-swift-rounds-run-fast-and-parallel -->
- Every agent commits only. The coordinator pushes, opens the PR, and merges. A brief for an agent with no definition carries the line: `You cannot push. You commit only. Pushes, pull requests, and merges happen in the main session.` <!-- jka-swift-agents-commit-only -->
- A brief for an agent with no definition also carries the two skill invoke lines. <!-- jka-swift-agent-briefs-carry-both-skills -->
- Every brief says: codegraph before grep, with `projectPath` set to the main tree. Grep only to confirm a line in the worktree. <!-- jka-swift-codegraph-first -->
- A survey agent returns `path:line - gist` citations only. It writes no report file and gives no opinion. <!-- jka-swift-agents-cite-user-reads -->
- Read the cited lines of every claim before you pass it on, defects and notes alike. <!-- E7 -->
- A brief that tells an agent to hand-edit a stub also tells it to delete the header lines in the same commit. <!-- jka-swift-adopt-with-first-hand-edit -->

## Builds and gates
- A writing agent writes, commits, and reports. It runs no `swift build` and no `swift test`. <!-- E4 -->
- Merge the branches of a wave, run `tools/gate.sh --only build` once, and give the compile errors to one fix agent in one batch. <!-- E4 -->
- Reviews run on the branch that compiles. The full gate, `tools/gate.sh`, runs once at the end. <!-- E4, E1 -->
- An agent whose task is a compile fix or a Linux fix builds. <!-- E4 -->
- If the fix batch of a wave is larger than about one agent's work, report it to the user. <!-- E4 -->
- A generator batch: 1. make every change. 2. run the sequence and the gate once. 3. fix everything the gate found as one pass, then run both again, until green. <!-- jka-swift-generator-change-runs-sequence -->
- Collect every table row, tool fix, and rule change before the brief goes out. No row goes to a running batch by message. <!-- jka-swift-generator-change-runs-sequence -->
- A wave of bodies only runs no generator. The generators run when a rule, a signature, or a generator script changed. <!-- jka-swift-compile-agent-body-only-rounds -->
- When a tool and a committed file disagree, read the intent of the commit that changed each side before you name one side as the drift. <!-- jka-swift-generator-change-runs-sequence -->
- A check is one Bash call. When the harness moves it to the background, end the turn and wait for the notification. No tail, no poll, no monitor loop. <!-- jka-swift-agents-run-checks-serially -->
- A rise in defects at the end of a round goes into the record. It is not fixed in the same round. <!-- jka-swift-builder-gates-once-at-end -->
- The gate never writes into `~/.cache/jka-swift/`. After a landing, refresh the snapshot caches in place, with no copy first. <!-- E1, jka-swift-one-snapshot-cache -->

## Git
- Master is the base. Every change goes on a branch with a PR. Never commit on master. Commit code and records apart. <!-- jka-swift-branch-and-pr-workflow -->
- Commit, push, PR, and merge each need the user's typed word. An authorization ends with its session. <!-- jka-swift-branch-and-pr-workflow, jka-swift-unattended-run-handoff -->
- A PR body follows the house style and has no footer. <!-- jka-swift-branch-and-pr-workflow -->
- CI runs on a push to master only. After a merge, watch the run with `gh run watch <id> --exit-status` in the background and report the jobs. <!-- jka-swift-ci -->
- Do not propose a pull request trigger, a required status check, or a macOS lane. <!-- jka-swift-ci -->
- Never run `git submodule deinit`. Prepare a worktree with `tools/worktree-setup.sh`. <!-- E1, jka-swift-no-submodule-deinit -->
- Remove a worktree: `rm -rf` its submodule folders, then `git worktree remove --force`, then `git worktree prune`. Then `git submodule status` in the main tree shows no `-` prefix. <!-- jka-swift-no-submodule-deinit -->

## Trees that are read-only
- `jka-rust/` at the repo root and the sibling `../jka-rust`: no git command that writes refs, objects, or the working tree. A `git fetch` is a write. A reviewer reads the submodule, never the sibling clone. <!-- jka-swift-jka-rust-read-only -->
- The corpus tree `~/Developer/jka/`: no write without the user's word. <!-- jka-swift-solid-box-investigation, ledger 2026-11-11 row 1 -->

## Reports
- Reply when a decision or a result exists. Say once what a wave runs, and report the wave once when it is complete. <!-- E7 -->
- `HANDOFF.md`: at most 40 lines, four sections (State, What waits, Next, Pointers), written again from nothing at each change, with branch names and no `/tmp` path. <!-- E5 -->
```

Not in the draft, on purpose: the round shape of the cgame (entry 38), the writer and compile agents (entries 15 and 42), and the lane shapes of CI (the workflow file holds them).

## 6. The draft of `MEMORY.md` and the files that remain

### The index, 9 lines

```markdown
- [User drives jka-swift](jka-swift-user-drives.md) — hands-on, short steps, tests the first result before more of the same
- [Delegate to subagents](jka-swift-delegate-to-subagents.md) — keep main context low, agents do the work, in parallel where independent
- [Delegated rulings](jka-swift-delegated-rulings.md) — prove every row first, auto rule unless the ruling brings a new codebase-wide pattern, no walk for provable rows
- [Gate output before commit](jka-swift-gate-output-before-commit.md) — counts and findings in prose, no pasted diff or record, commit only on the typed word
- [Rounds run fast](jka-swift-rounds-run-fast-and-parallel.md) — the user watches the clock, hours for one round is unacceptable
- [User pauses agents directly](jka-swift-user-pauses-agents-directly.md) — a pause claim in a report is real, "handoff" means HANDOFF.md, "pause the agent" means a stop message
- [The goal and the order](jka-swift-legibility-goal.md) — readable Swift that looks like Raven, every product ported before legibility and speed
- [Walk state](jka-swift-unattended-run-handoff.md) — a pointer: the state is in HANDOFF.md at the repo root
- [Where facts go](jka-swift-where-facts-go.md) — a rule of the port, the architecture, or the workflow goes to its home, not to memory
```

### The files that remain

Nine files: `jka-swift-user-drives.md`, `jka-swift-delegate-to-subagents.md`, `jka-swift-delegated-rulings.md`, `jka-swift-gate-output-before-commit.md`, `jka-swift-rounds-run-fast-and-parallel.md`, `jka-swift-user-pauses-agents-directly.md`, `jka-swift-legibility-goal.md`, `jka-swift-unattended-run-handoff.md`, and the new `jka-swift-where-facts-go.md`. The other 39 files are deleted after their text is in its home.

The proposed body of each file follows. Each keeps its present frontmatter with a new description. The user's words stay as quotes, with their dates, because memory is the one home that keeps them.

#### `jka-swift-user-drives.md` (takes one sentence of entry 38)

The user wants to drive the jka-swift port far more directly than they drove jka-rust.

**Why:** They know Swift better than Rust, so they want the design and code decisions in their own hands.

**How to apply:** Prefer short steps with the user in the loop over long autonomous runs. Bring a design choice with a new codebase-wide pattern to the user for a ruling. Other rows follow [[jka-swift-delegated-rulings]]. The user tests the first result of a new kind of work before more of the same starts: "remember to test the transcriptions before we commit to more of them" (2026-11-01), and "run attended" when offered an unattended run (2026-11-02).

#### `jka-swift-delegate-to-subagents.md` (new text)

Keep the main session's context low. Delegate implementation, file reads, and proofs to subagents, run them in parallel where the work is independent, and keep only the conclusions in the main session. This holds also for a two-line fix or a record amendment, when an agent can do it.

**Why:** The user said on 2026-09-08 "I want you to keep your context low and use subagents (opus, sonnet, haiku) for work", on 2026-10-11 "delegate your work to subagents when possible", and on 2026-11-04 "remember to always delegate work to opus agents. work in parallel as much as possible." Long sessions compact often, and the walks need the main context for rulings.

**How to apply:** The main session presents rows, records rulings, writes briefs, and runs the wave gate. The model tiers and the brief form are in `.claude/CLAUDE.md`. See [[jka-swift-user-drives]].

#### `jka-swift-delegated-rulings.md` (takes entry 36)

The user delegates docket rows to the coordinator. The delegation is standing.

Prove first. Before any row reaches the user, an agent proves it: every site, every Raven use with file and line, the jka-rust handling, the Swift types, whether a helper or a guide form exists, and a verdict on the premise with the exact Swift at one site. The user rules on the proof, not on the claim: "all of these rulings, prove them before you show me them. send the agents back out to investigate." (2026-10-11). The coordinator reads the cited lines.

Then rule. The three proof sources are this codebase, `jka-rust` (the semantic that a site needs, never its text codec forms), and Raven's source in `oracle/`. The coordinator rules a row by the form that the codebase already uses for the same shape, or by the nearest existing pattern. It may also rule a single-site form that no source fixes exactly. A ruling that brings a new pattern across the codebase goes to the user, and so does a reversal of an earlier ruling. A dead function that needs a new codebase-wide form goes to the user for that form.

**Why:** The user wants the design to move when the shape is clear. Their words: "remember to prove the rows and auto rule. match existing codebase patterns in reference to the rows." (2026-11-03), "autorule these by proving them and matching existing patterns" (2026-11-09), "can't you prove these based on the code that exists in this codebase, what jka-rust might have, and oracle?" and "so long as we don't introduce a pattern across the codebase I am open to your autoruling" (2026-11-10).

**How to apply:** Do not open a walk for provable rows. Rule them in one pass, write the ledger with a "Ruled by" column into `notes/<date>/`, and report in prose the rows you amended or added and the findings that need the user's word. See [[jka-swift-user-drives]] and [[jka-swift-gate-output-before-commit]].

#### `jka-swift-gate-output-before-commit.md` (takes entry 47)

The user gates each round on the reports and the counts, and commits only on a typed "commit".

**Why:** "all of these choices we're making I will gate by seeing output before committing and we will make changes as necessary" (2026-09-09). A row is ratified on its description, and the output is the real test of the shape. "don't show me the diffs" (2026-09-27). On 2026-10-05 the user said that a pasted ten-row ledger was too big for the screen.

**How to apply:** After a round, report the counts, the reviewer's findings, and any open ruling in prose, and stop before `git commit`. Never paste a diff. When a walk closes and the user names the destination, write the record into the file and say in one line where it is. Do not paste the record in chat first: this replaces the "show the recording text" step of the ratification-walk skill for this user. Do not repeat a check that an agent reported with counts. A ruling can change after the user sees the output. See [[jka-swift-user-drives]].

#### `jka-swift-rounds-run-fast-and-parallel.md` (new text, takes the user's part of entries 11 and 24)

The user watches the clock. A round that takes hours is unacceptable.

**Why:** "please don't let it take an hour again. it's been 1 hr and 33 minutes already" (2026-10-08). "5 hours is unacceptable. it should be much faster" (2026-11-02), with a request for parallel agents in separate worktrees. "remember for the generator work to always make all changes and then test in one sweep. that way we don't wait 10 minutes per change." (2026-11-04). "it should have done all work first, then run the gate and python scripts once and made fixes over time." (2026-11-09).

**How to apply:** Plan each round for well under an hour. Run independent work in parallel, and run each long check once at the end and not after each item. The mechanics are in `.claude/CLAUDE.md`. If a round passes an hour, tell the user why. See [[jka-swift-delegate-to-subagents]].

#### `jka-swift-user-pauses-agents-directly.md` (takes entry 25)

The user talks to subagents directly and can pause one outside the coordinator's view. On 2026-10-05 an agent reported "I paused on the user's request", the coordinator resumed it, and the user corrected the coordinator.

**How to apply:** When an agent reports a user-requested pause, leave it paused and report the state to the user. Ask only if the pause conflicts with an instruction the user gave in chat.

Two phrases of the user. "write a /mattpocock-skills:handoff": no skill of that name exists, and the user means `HANDOFF.md` at the repo root, in the form that `.claude/CLAUDE.md` gives. Skip the skill search. "pause the agent": send the agent a message to finish its tool call, commit only a green complete change, write its resume state, and report. Do not kill it. See [[jka-swift-user-drives]].

(The sentence on `context.md` waits for the answer to Q7.)

#### `jka-swift-legibility-goal.md` (takes entries 40 and 46)

The primary goal of jka-swift is readable gameplay source as Swift, stated 2026-10-04. Four goals stand on it, and their text is private (row Q5 of the fourth walk). The user wants Swift-native semantics with legibility and minimal abstraction. The accepted patterns: real C types behind Swift types, Swift syntax and semantics in bodies, and global mutable state behind singleton-style globals. One view layer over engine-owned memory is the accepted abstraction. Above it the user wants plain Swift, for example a real `String` at a `char *` field, and not two or more layers of functions.

The Swift must also look like Raven. "i don't want to litter the codebase with new funcs like rust. i want it to look somewhat like raven/openjk." (2026-10-11). "i don't want you to adulterate raven code too much" (2026-10-27). "if we're matching oracle as much as possible, retain this problem" (2026-10-29).

The order. Every product of the oracle is ported before any legibility pass or speed work: "i'd like to have the entirety of the project done. so all products (the executable, the renderer, cgame, ui, sp) before we start doing all the legibility" (2026-10-29). The exact order is in the ledger of 2026-11-11, row 8.

**How to apply:** Weigh every ruling against the goal. When you offer next work, offer the next product in the ruled order, not a shape row, a legibility row, or a speed row. When a fix tempts a structural change, write the legible local form and put the structural idea into the dated notes folder for later. See [[jka-swift-delegated-rulings]].

#### `jka-swift-unattended-run-handoff.md` (a pointer, row E5)

The state of the work is in `HANDOFF.md` at the root of the repo. Read it first. This entry holds no state.

**How to apply:** An authorization to push, merge, or start a row ends with the session that got it. Ask the user again in a new session.

#### `jka-swift-where-facts-go.md` (new)

Before a memory entry is written, ask one question: is the fact a rule of the port, a fact of the architecture, or a rule of the workflow? If yes, it does not go to memory. A rule of the port goes to `docs/porting-rules.md` or `docs/transcription.md`. A fact of the architecture goes to the architecture section in `docs/`. A rule of the workflow goes to `.claude/CLAUDE.md`. The state of the work goes to `HANDOFF.md`. A ruling and its reason go to the dated ledger under `notes/`. Memory holds only who the user is and how the user wants to work with the coordinator.

**Why:** The user ruled the homes on 2026-11-11, row E9 of `notes/2026-11-11/after-the-stubs-ledger.md`. Memory had collected 47 entries of six kinds because no other home existed, and several were stale against the docs.

**How to apply:** Write the fact in its home in the same pass as the ruling. A ledger row is not closed until its text is in the home that its "lands in" column names.

## 7. The entries with an uncertain destination

- Q1, entries 32 and 37 (and the homes table). Candidates: a new rule in section B of `docs/porting-rules.md`, or a new architecture section in `docs/`. Question: `docs/` has no architecture section today. Does the user want a new file (for example `docs/architecture.md`), or do sections B and D of `docs/porting-rules.md` count as the architecture section?
- Q2, entry 8. Candidates: "Known gaps" of `tools/oracle-closure/README.md` for facts 2 and 3 with `HANDOFF.md` for fact 1, or removal as history. Question: are the pointer-alias gap of the variable sweep and the QAGAME-only parse still true, and does the user want to rule the `Float(pm.cmd.forwardmove)` row (`bg_pmove.swift:2738`) or keep it open?
- Q3, entry 12. Candidates: the coordinator file (as drafted), or the dated ledger. Question: the rulings "no pull request trigger", "no required check", and "no macOS lane" have no ledger row. Is one line in the coordinator file enough, or does the user want a ledger row with the quotes of 2026-10-28?
- Q4, entry 17. Candidates: doc with nothing to add, or doc with a limit. Question: rule 20 says that every function with zero callers gets its body. The entry says the user's words were about the dedicated stubs only. Does rule 20 hold for the game and cgame targets too?
- Q5, entries 27, 40, and 46. Candidates: memory (as drafted), or the opening of `docs/porting-rules.md` for the goal with `HANDOFF.md` for the order. Question: is the goal a fact about the user, or a fact about the project that every agent must read?
- Q6, entry 3 and the four dated doc lines. Candidates: change `docs/transcription.md:49` in this pass, or leave it for the pass that writes the agent definitions. Question: row E9 lets this pass only add text. Row E3 makes line 49 false, and four doc lines carry a date. Does the user allow these five edits now?
- Q7, entries 25 and 45. Candidates: keep `context.md` as the resume file of a paused agent, or remove the name. Question: row E5 says "`context.md` goes". Does that cover only the coordinator's file at the repo root, or also the file that a paused agent writes?
- Q8, entry 1. Candidates: remove as history (as drafted), or keep in memory. Question: the entry is about all projects, not this one. After row E8 the hook states the rule. Does the user want the lesson kept in memory until row E8 is built and checked?

## 4. The full text of the entries with the destination "remove as history"

Seven entries, copied whole from the memory folder, frontmatter included.

### `hook-text-is-not-an-invoke.md`

~~~~text
---
name: hook-text-is-not-an-invoke
description: "The startup hook prints the house-style text, but that is not the skill invoke. Call house-style and asd-ste100 through the Skill tool before a commit body or a comment."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 02118c75-6243-453f-9059-d24085627cfb
  modified: 2026-09-28T01:23:44.268Z
---

On 2026-09-27 I wrote a commit body with the house-style text in context from the startup hook and skipped the Skill call, and I never called asd-ste100. The user asked "what happened to /house-style for commit messages and /asd-ste100 and code comments?". The body was column-wrapped and had one sentence over the cap, and the commit had to be amended.

**Why:** the hook text is a reminder, not the pipeline. The house-style skill calls asd-ste100 as step 2, and the self-lints run only when both are loaded.

**How to apply:** before the first commit body, comment, doc line, or agent brief of a session, call the Skill tool for house-style and then asd-ste100. Run both self-lints on the text before it lands. See [[jka-swift-agent-briefs-carry-both-skills]].

~~~~

### `jka-swift-agent-briefs-carry-both-skills.md`

~~~~text
---
name: jka-swift-agent-briefs-carry-both-skills
description: "Every agent brief that writes invented text (Port-notes, comments, docs) carries the house-style and asd-ste100 invoke lines, both skills sit in ~/.claude/skills and ~/.claude-work/skills"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b46fb998-6538-4908-8fcd-833de4cffb82
  modified: 2026-09-10T01:15:01.182Z
---

On 2026-09-09 the user pointed at a transcriptor's Port-note in bg_misc.swift and said "The comment is an AI comment. ~/.claude or ~/.claude-work should have /house-style. and /asd-ste100. Agent prompts should always contain those when writing their own invented text".

**Why:** a Port-note, a doc line, or a comment the agent invents is prose in the repo, and the house style and STE apply to it the same as to hand-written text. A brief that names only house-style lets the agent skip the STE form.

**How to apply:** every transcriptor, reviewer, and sweep brief carries two lines, each on its own line: `Invoke the house-style skill before you write anything, and pass this instruction to your sub-agents.` and `Invoke the asd-ste100 skill before you write any sentence of your own, a Port-note, a comment, or a doc line.` Raven's own comments are copied as written and are exempt. The rule is recorded in `docs/transcription.md`. See [[jka-swift-transcription-workflow]] and [[jka-swift-blind-agents-read-set]].

~~~~

### `jka-swift-compile-agent-body-only-rounds.md`

~~~~text
---
name: jka-swift-compile-agent-body-only-rounds
description: The compile agent runs swift build and swift test only in a body-only round; the probe and the six generators run only when a drafter rule or a signature changed
metadata:
  node_type: memory
  type: feedback
  originSessionId: 9701fbef-e62e-411e-934c-da4871bf3a15
  modified: 2026-09-24T05:20:03.926Z
---

In the adoption workflow (writer agents splice per file and never compile, one compile agent gates), a body-only round gives the compile agent `swift build` and `swift test --no-parallel` alone. The probe and the six generators (views, skeleton, traps, channel, manifest, tables) run only when a drafter rule, a signature, or a generator script changed.

**Why:** Ruled by the user on 2026-09-24. For a splice of bodies no signature changes and the Generated files stay as committed, so the generators add a minute and one risk: skeleton.py overwrites any stub file that still carries its header line, which erased seven splices in the first round.

**How to apply:** Write the compile agent's brief with the two build steps only, unless the round touched tools/oracle-closure or a hand signature. When the generators do run, have the agent report skeleton.py's "adopted, left alone" list. See [[jka-swift-agents-run-checks-serially]] and [[jka-swift-no-rerun-after-agent-gate]].

~~~~

### `jka-swift-no-rerun-after-agent-gate.md`

~~~~text
---
name: jka-swift-no-rerun-after-agent-gate
description: "When an agent reports it ran the build, tests, and draftcheck gate, do not rerun them in the main session; report the counts in prose and wait for \"commit\""
metadata:
  node_type: memory
  type: feedback
  originSessionId: 9701fbef-e62e-411e-934c-da4871bf3a15
  modified: 2026-09-23T20:57:57.272Z
---

When an agent reports that it ran the gate (swift build, swift test --no-parallel, draftcheck over the bg stems) and gives the counts, the main session does not run them again. It reports the counts in prose and waits for the user's "commit".

**Why:** The user stopped a rerun on 2026-09-23 with "it ran the gates". A rerun repeats minutes of work for a result the agent already reported.

**How to apply:** After an agent hand-back, run only `git status`, quote the agent's counts in prose, never paste a diff, and wait. Rerun a check only when the agent's report is missing the counts, or when the user asks. See [[jka-swift-gate-output-before-commit]] and [[jka-swift-agents-run-checks-serially]].

~~~~

### `jka-swift-project-origin.md`

~~~~text
---
name: jka-swift-project-origin
description: "jka-swift is a Swift port of Jedi Academy modeled on mheh/jka-rust; repo created 2026-09-08, old JKA-Swift experiment renamed"
metadata: 
  node_type: memory
  type: project
  originSessionId: b46fb998-6538-4908-8fcd-833de4cffb82
  modified: 2026-09-09T00:47:13.985Z
---

jka-swift is a Swift port of Jedi Academy that follows the mheh/jka-rust method: same oracle submodule (mheh/jediacademy), same porting rules, same differential rigs, with Swift C interop as the ABI layer.
The private repo mheh/jka-swift was created on 2026-09-08. Work lands on branch wave-0.
An older July 2025 C++ interop experiment that held the name was renamed to mheh/jka-swift-cxx-experiment-2025 and is unrelated to this port.

**Why:** The packet's row 1 fixes the home as mheh/jka-swift, and the old repo blocked that name.
**How to apply:** Do not treat the renamed experiment as prior art for this port. See [[jka-swift-user-drives]].

~~~~

### `jka-swift-round-shape.md`

~~~~text
---
name: jka-swift-round-shape
description: The cgame round shape since 2026-11-01, one stem per PR, the user tests each before the next, a drafter change lands by reset and readopt only before the first hole round
metadata:
  type: feedback
---

On 2026-11-01 the user said "remember to test the transcriptions before we commit to more of them", and round 1 ran on one stem, cg_draw, as one PR.

**Why:** a drafter shape wrong for the cgame shows in the first stem's note counts, and fixing it there saves every later stem a hand round.

**How to apply:** one stem per round: draft gate of the stem, adopt with `adopt.py --unit mp-cgame --stem <stem>`, build and test, commit, the coordinator reads the largest Port-note group and proposes drafter rows, the user rules, readopt by a reset of the file to its stub (safe only before the first hole round), the hole round by a blind transcriptor, the compile gate, the record under notes/<date>/, then push and PR on the user's words. See [[jka-swift-transcription-workflow]] and [[jka-swift-builder-gates-once-at-end]].

~~~~

### `jka-swift-transcription-workflow.md`

~~~~text
---
name: jka-swift-transcription-workflow
description: "The port workflow as of 2026-09-28: the drafter writes bodies, writer agents splice them per file, one compile agent gates, transcriptors do hole rounds, Port-notes are the docket"
metadata:
  node_type: memory
  type: project
  originSessionId: b46fb998-6538-4908-8fcd-833de4cffb82
  modified: 2026-09-28T00:00:00.000Z
---

On 2026-09-09 the user set a batch workflow, files first and tests after, bg files first. Since 2026-09-24 the drafter in tools/oracle-closure writes the first body of every function, and the batch shape is:

- draftcheck.py gates the drafts of a stem in a mirror under .build-draft/ before any adoption. A stem adopts when its drafts compile.
- One writer agent per file splices the drafter's bodies over the `portMissing` stubs and deletes the skeleton.py header line. Writer agents never compile.
- One compile agent runs the gate, `swift build` and `swift test --no-parallel`, plus the generators only when a rule or a generator script changed, and groups errors by file.
- A transcriptor runs a hole round on one adopted file: it rules each `// Port-note:` as stands, fills, or blocked, and fills only what it can from the oracle slice. A transcriptor never builds.
- A problem is a `// Port-note: <missing thing>` comment in the code, nothing else. `grep -rn "Port-note:"` is the docket. A drafter defect goes to the drafter as a shape rule, never as a hand fix in the file, ruled by the user on 2026-09-27.
- The guide is docs/transcription.md, the pipeline is docs/oracle-closure.md, the manifest generator is tools/oracle-closure/manifest.py.

**Why:** the architecture is fixed, and the remaining work is bodies. A drafter rule closes a class of holes across every file, where a hand fix closes one.

**How to apply:** do not draft a packet for a game file. Fix the drafter, regate, adopt, then run hole rounds. See [[jka-swift-user-drives]], [[jka-swift-blind-agents-read-set]], and [[jka-swift-compile-agent-body-only-rounds]].

~~~~
