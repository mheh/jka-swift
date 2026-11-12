# The ledger of the walk after the stubs

The rows come from section 4 of `notes/2026-11-10/after-the-stubs.md`. The walk has eight rows.

| Row | Subject | Verdict | Date |
| --- | --- | --- | --- |
| 1 | The wider referee | Ratified as proposed, with one addition by the user: "there should be recordings we can copy from jka-rust". The scout looks in `jka-rust` for recordings before it plans new ones. | 2026-11-11 |
| 2 | The review of the unread live path | Ratified as proposed | 2026-11-11 |
| 3 | A real client | Ratified as proposed | 2026-11-11 |
| 4 | The goldens without a parity test | Ratified as proposed, with one addition by the user: "there should be some goldens in jka-rust". Before the test agents start, one agent lists the goldens and golden tests that `jka-rust` holds and compares that list with the goldens of this repo. | 2026-11-11 |
| 5 | Speed | Ratified as proposed | 2026-11-11 |
| 6 | Cleanup | Ratified as proposed | 2026-11-11 |
| 7 | What done means for the dedicated server | Ratified as proposed | 2026-11-11 |
| 8 | What follows the dedicated server | Ratified as proposed, with the user's words "but we will stop here". The order is ruled. No work of this walk starts in the session of the ruling. | 2026-11-11 |

## Row 8 as ratified

The MP ui module ports next, as a parallel track. The order after it: the MP client engine, the MP renderer, SP, then legibility and the performance docket. A scout measures the `mp-ui` closure before a plan. Generator batches of the two tracks take turns. The session stopped at this row by the user's word, so the start of each ratified row waits for the next session.

## A finding during the walk: the green run tested spectators

The referee scout (`notes/2026-11-11/referee-recordings-scout.md`) found, and the coordinator confirmed from the sources, that the green run over `corpus-ffa1.rec` most likely held four spectators. `w_force.c:483` to `:492` puts every client that is not a bot into `TEAM_SPECTATOR` when `g_teamAutoJoin` is 0, the default of `g_main.c:336`. `tools/host-referee.sh` sets `bot_enable 0` and does not set `g_teamAutoJoin`. The fork's log of the run holds no `Kill:` line. The proof from the game state is not done: run the corpus once with `+set g_teamAutoJoin 1` and look for `Kill:` lines and a changed checksum. Until then no recording counts for condition 2 of row 7. Twenty `.rec` files exist under `~/Developer/jka/` and replay as they are.

## Row 7 as ratified

The dedicated track is closed when all of these are true on master:

1. No `portMissing` call exists in the port.
2. The referee is green on the first six recordings of row 1, or each red frame has a recorded row that names its cause as an OpenJK change or a property of the reference build.
3. The six live-path reviews of row 2 are done, and each confirmed defect has a fix on master.
4. A scripted client and then the user at a retail client can join the Swift server, play a full map, and see a map change, with no trap.
5. Every golden has a Swift parity test that passes.

The track does not claim equality with the retail binary. The stated claim: the Swift server agrees with the OpenJK fork at `35e4184f` under strict float arithmetic for the recordings, and a retail client can play on it.

## Row 6 as ratified

One pass after the last body PR is merged.

1. Copy out what exists in no commit: `/tmp/jka-batch-10/.claude/manifest/mp-engine-ded/` to `notes/2026-11-10/manifest-mp-engine-ded/`, and the review files, briefs, and gate outputs under `/tmp` to `notes/2026-11-10/` and `notes/2026-11-11/`.
2. Rebuild the reference host in the main tree with `tools/build-referee-host.sh`, because the host that the gates used is in the worktree `/tmp/jka-rulings-13`.
3. Remove all worktrees (42 on 2026-11-11): remove the submodule folders with `rm -rf`, then `git worktree remove --force`. Never `git submodule deinit`.
4. Delete the local branches that are merged in master with `git branch -d`.
5. Delete the remote branches that are merged in `origin/master`.
6. Keep every branch that is not merged, the docker volume `jka-linux-build`, and the three snapshot caches.

The coordinator reports the counts and anything that `git branch -d` refused.

## Row 5 as ratified

No speed work starts. The ruling of 2026-10-29 holds: rows R1 to R5 of `notes/2026-10-29/performance-profile.md` wait until the whole project is ported. The measured numbers stay as input: a corpus replay takes 4 s on the fork and 25 s on the Swift host, and the slow part is the view access form. One exception: if a new referee recording or the real client test becomes too slow to use (more than about ten minutes for each run on the Swift host), the coordinator reports the number and asks, and does not start a fix alone.

## Row 4 as ratified

The saved task starts when the last body PR is merged, in parallel with rows 1 and 2. One agent per golden writes a Swift test that feeds the golden's inputs to the Swift function and compares the result with the golden's record, in the form of the existing tests. The goldens: `gcombat`, `pmove`, `pmove_saber`, `pmove_trace`, `qshared`, `saberload`, `wsaber`, and most of `bgmisc`. `pmove` goes first. A red test is a finding: the agent reports the first record that differs, and the coordinator reads the cited lines. A golden never changes to make a test pass. First, one agent lists what `jka-rust` holds: its goldens, its dumpers, and its own tests against them, so that a golden this repo does not yet carry can be copied by the rule 18 path, and so that each Swift test can follow the Rust test of the same golden.

## Row 3 as ratified

Two stages. Stage 1, after the fixes of row 2 land: one agent finds out whether a headless client can connect (the fork's client build, or a small script under `tools/`), connects it to the Swift `jampded` on localhost for a fixed time, and checks that the server does not trap, that the client reaches the active state, and that it receives snapshots. If no headless client exists and a script is more than a small tool, the coordinator reports the cost and does not build it without the user's word. Stage 2, when stage 1 passes: the coordinator gives the user the command that starts the server, and the user joins with a retail client and plays.

## Row 2 as ratified

Six read-only review agents run in parallel when the last body PR is merged, one per part, and each brief names the head commit to read: the file system and pk3 code. `msg.swift`, the Huffman code, and `net_chan.swift`. `CM_LoadMap` and the patch build path. `SV_InitGameProgs`, `SV_SendClientMessages`, `sv_client.swift`, and `sv_snapshot.swift` (two agents if the files are over about 3000 lines together). `VM_Create` and `Sys_LoadDll`. The cvar, zone, and hunk internals. The coordinator reads the cited lines of each defect before a fix. One PR lands the fixes after one gate.

## Row 1 as ratified

The wider referee starts first when the last body PR is merged.

1. One agent scouts how to make a new recording on the fork with the existing tools. It reports the cost of one recording and what a recording can hold. It also lists the recordings that `jka-rust` holds and says which ones the Swift referee can replay.
2. The coordinator reports that to the user before a batch of recordings runs.
3. New recordings follow in this order: a siege map, a map with vehicles, a duel, a recording with a map change.
4. Row H9 of `notes/2026-11-03/dedicated-referee-docket.md` says how to treat a mismatch.

The corpus tree `/Users/milohehmsoth/Developer/jka/` is read-only for agents. A write into it needs the user's word.

## The second walk: what the coordinator needs from the user

| Row | Subject | Verdict | Date |
| --- | --- | --- | --- |
| A | Land `dedicated-integration-16` | Replaced by the user: "we should fix the save command and figure out the signature groups before pushing". The branch does not go to master until the two `SaveCommand` sites are fixed and each hand-ruled signature group has a generator row or a recorded reason why none can exist. The other steps of the proposal stay: find the cause of the `import Foundation` line, read the snapshot differences, refresh the caches, then push, one PR, merge, watch CI. | 2026-11-11 |

## The third walk: the changes that cut token use

Nothing is built until the walk is complete. The cache lifetime of a subagent stays at its default by the user's word.

| Row | Subject | Verdict | Date |
| --- | --- | --- | --- |
| E1 | The gate script | Ratified as proposed. `tools/gate.sh` runs both builds, the tests, the tool tests, the three snapshot checks, the Linux container build, the referee with the count of `Kill:` lines, and the stub counts. It prints a summary of at most 40 lines, keeps the full outputs in a folder, and never writes into `~/.cache/jka-swift/`. `tools/worktree-setup.sh` prepares a worktree for the generator tools and never runs `git submodule deinit`. | 2026-11-11 |
| E2 | The role cards | Ratified as proposed. Four tracked files under `docs/agents/`: `body-writer.md`, `reviewer.md`, `generator.md`, `scout.md`, each 60 to 100 lines, rules only, with a pointer to the section of the full document. The full documents stay the authority. A ruling that changes a document changes the card in the same commit. One agent writes the cards, and the coordinator reviews them against the documents before they land. | 2026-11-11 |
| E2, amended | The role cards | Amended by the user: "the cards are made by a fable agent and it proves each row". One Fable agent writes the cards. Each rule in a card has a proof: the section and line of `docs/porting-rules.md` or `docs/transcription.md`, or the ledger row, with the quoted line. A rule with no proof does not go into a card. The coordinator reads the cited lines before the cards land. | 2026-11-11 |
| E3 | The agent definitions | Ratified with the recommended choice: the definition is the only copy of each card. Four definitions under `.claude/agents/`: `jka-body-writer`, `jka-reviewer`, `jka-generator`, `jka-scout`, with the card as the system prompt, the two skills preloaded where the role writes, a fixed model, limited tools, and `CLAUDE.md` still loaded. This replaces the four files under `docs/agents/` of row E2. The user added: "gitignore the .claude folder entirely as i want this to remain private". That direction is the subject of row E6. | 2026-11-11 |
| E6 | `.claude` and git | Replaced by the user: "gitignore the .claude folder entirely as i want this to remain private", then "ratified. no retroactive edits. no backup.", then "they leave the index". `.gitignore` gets the line `.claude/`. `git rm -r --cached .claude` takes the 236 tracked files out of the index, and the files stay on disk. No rewrite of the public history. No backup script and no copy to another repo. One commit, one PR. The three places in `docs/` that name `.claude` paths get a check, and a new worktree gets its manifest and rosetta files from a generator run. | 2026-11-11 |
| E4 | Writing agents do not build | Ratified as proposed. A writing agent writes, commits, and reports, with no `swift build` and no `swift test`. The coordinator merges the branches of a wave, runs `tools/gate.sh --only build` once, and gives the compile errors to one fix agent in one batch. Reviews run on the branch that compiles, and the full gate runs once at the end. An agent whose task is a compile fix or a Linux fix builds. The first wave without self-builds is the test: if the fix batch is larger than about one agent's work, the coordinator reports it. | 2026-11-11 |
| E5 | The state file | Ratified as proposed. `HANDOFF.md` at the repo root is the one file a new session reads: at most 40 lines in four sections (State, What waits, Next, Pointers), written again from nothing at each change, untracked. `context.md` goes, after anything still true moves into a dated record. The memory entry for the walk state becomes a pointer to the file. The file names branches and no `/tmp` path. | 2026-11-11 |
| E7 | The coordinator's working habits | Ratified as proposed. Five standing rules. A brief holds the slice: the agent type, the task, the function list with Raven's file and line range, the ledger rows quoted, the worktree, and the branch, with no whole docket or rules document. One agent continues a chain of dependent tasks by message. The coordinator replies when a decision or a result exists, says once what a wave runs, and reports the wave once when it is complete. The cheapest tier that fits: `haiku` for a lookup, `sonnet` for inventories, scouts, and mechanical edits, `opus` for bodies, reviews, and generator batches, a Fable agent only on the user's explicit word. The coordinator reads the cited lines of every claim it passes on, defects and notes alike. | 2026-11-11 |
| E8 | The start hook | Ratified as proposed, with one addition by the user: "once we make the changes spawn a subagent and look to see whether the session start hook fired". `~/.claude/hooks/style-inject.sh` prints two lines in place of the two skill files: the style is active, chat prose follows ASD-STE100, and the two skills are invoked through the Skill tool before any writing. The coordinator shows the new file content before it writes the file. After the change, one subagent is started and asked what the hook put into its context, to find out whether a session start hook fires for a subagent. | 2026-11-11 |
| E9 | The memory folder and where facts go | Ratified as amended. One record, `notes/2026-11-11/memory-prune.md`, gives each of the 47 entries a destination: a named doc section, the coordinator file, the ledger, `HANDOFF.md`, memory, or removal as history. The user rules on the record, then one pass applies it. A new private coordinator file, `.claude/CLAUDE.md`, at most 60 lines, holds how the coordinator runs this project. The agent definitions set `omitClaudeMd`, and the cards carry the three global rules that apply to an agent (the zsh rule, no co-author trailer, the STE form): this amends row E3. A doc change in this pass only adds text that states an existing ruling, and it runs before the cards are written. Standing rule: every ledger has a "lands in" column, a row is not closed until its text is in that home, and before a memory entry is written the coordinator asks whether the fact is a rule of the port, a fact of the architecture, or a rule of the workflow, in which case it goes to its home and not to memory. | 2026-11-11 |

## The homes of facts, from row E9

| Kind of fact | Home |
| --- | --- |
| A rule for how the Swift is written | `docs/porting-rules.md` or `docs/transcription.md`, and the role card in the same commit |
| A fact of architecture | an architecture section in `docs/` |
| How the coordinator runs this project | `.claude/CLAUDE.md` |
| The state of the work | `HANDOFF.md` |
| A ruling and its reason | the dated ledger under `notes/` |
| Who the user is and how the user wants to work | memory |
| B | The two `SaveCommand` sites | Ratified as proposed. No code fix. The two false Port-notes at `CSequence.swift:373` and `CTaskManager.swift:1580` go, and the unwrap stays. The guard in `CBlockMember.WriteMember` from the fixes of PR 96 is reverted with its AI line, and that site gets a rule 19 note for the one undefined case (NULL data with size -1). The entry of ledger 15 is corrected. Proof: `Z_Malloc` with size 0 returns `&pMemory[1]` (`z_memman_pc.cpp:160` to `:164`), and a member with NULL data has size -1 (`BlockStream.cpp:29`, `:30`, `:49`, `:51`). | 2026-11-11 |
| S1 | The signature of `G2_SaveGhoul2Models` and its wrapper | Ratified as proposed. The tuple of the `bytes` branch at `spelling.py:329` gains plain `char` beside `void` and `unsigned char`, with one comment line that names the function. Two `PARAMS` rows of kind `bytes` for `buffer` of `G2_SaveGhoul2Models` and of `G2API_SaveGhoul2Models`. One tool test. The generator run must change exactly these two signatures. Rows S1 to S4 run in one generator run on `dedicated-integration-16`. | 2026-11-11 |
| S2 | The signature of `G2_GetGoreRecord` | Ratified as proposed. In `table.py`, beside the `("view", record)` branch at `:2211`, a `RETURNS` row of the form `("class_ref", "<hand class>")` returns that class as an optional, and the plain `class_ref` form stays. One `RETURNS` row `("class_ref", "GoreTextureCoordinates")` for `G2_GetGoreRecord`. One tool test. | 2026-11-11 |
| S3 | The signature of the two terrain patch iterators | Ratified as proposed. `CM_TerrainPatchIterate` and `CCMLandScape.TerrainPatchIterate` take the generated signature, which is Raven's parameter list with `userdata: OpaquePointer?`. The method body calls `IterateFunc!(patch, userdata)` as `cm_terrain.cpp:1005` does. The two AI lines go. No tool change. This replaces row N-USERDATA of ledger 14, which the coordinator ruled alone although it was a new form. | 2026-11-11 |
| S4 | The `drawPoly` closure and the callback of `CM_CircularIterate` | Ratified as proposed. `table.closure` passes the owner `"<function>.<parameter>"` and the label to the parameter speller, in the form of `views.py:778` to `:819`. The `table` kind gains one branch: a `float *` that a row rules as `table` is a `Slots<JKAShared.vec3_t>`. Three rows: `("CM_DrawDebugSurface.drawPoly", "points"): "table"`, the same for `BotDrawDebugPolygons`, and `("CM_CircularIterate.callback", "p2"): "bytes"`. Tool tests for the key and the branch. The run must change the signatures of exactly these three functions, plus the two of S1, the one of S2, and the two of S3. | 2026-11-11 |
| C | The form of a closed class hierarchy | Ruled by the user's word "B". The shape of the `CRMInstance` hierarchy is the form for every closed C++ hierarchy, with one change: the kind enum is a top-level type `enum <Base>Kind`, declared in the base class's file directly above the class, and not a nested `Kind`. No type is nested unless Raven nests it. The six points: one class for the base with a field `kind`. A `struct` for each subclass with Raven's class name and only the fields it adds. A labeled `convenience init` for each subclass constructor. Each virtual method is one method of the base with a switch, and an override is a method named `<RavenClass>_<Method>`. One file for each Raven class. A `deinit` with a switch for the subclasses whose destructor has a body. The form goes into `docs/transcription.md` with `CRMInstance` as the example, and rule 17 points to it. The rename to `CRMInstanceKind` is applied on `dedicated-integration-16` before the push. Lands in: `docs/transcription.md`. | 2026-11-11 |
| D | The order of the golden tests, and the goldens of `jka-rust` | Ratified as proposed. This amends row 4 of the first walk. Stage 1, in parallel, one agent for each golden: `wsaber`, the seven untested sections of `bgmisc`, `qshared`, and the three sections of `gcombat`. Stage 2: one agent builds the brush world and the `Pmove` setup as shared test support, then `pmove_trace`, `pmove`, `pmove_saber`, and `saberload` use it. Stage 3: the engine goldens of `jka-rust` come in by the rule 18 path, one group at a time with its parity test, first gp2, icarus, rmg, roff, terrainmap, and ghoul2-server. Stage 3 starts with gp2 alone, and the coordinator reports its cost before the other five. A red test is a finding, and a golden never changes to make a test pass. | 2026-11-11 |
| E | Where recordings live | Ratified as proposed, after the user's word "no .rec in the repo". This repo carries no `.rec` file. The existing files stay under `~/Developer/jka/` and are read by path. New recordings go to `/Users/milohehmsoth/Developer/Milo/referee-corpora/`, created when the first new recording is made. `record_corpus.py` and `referee.py` are copied to `tools/referee/`, with the dead default paths removed and one argument for extra `+set` lines, after the coordinator checks them for anything that should not be public and reports it. `tools/gate.sh` takes the corpus path from a variable. Fact for a later decision: a human recording holds the player's `ja_guid` and address in its userinfo text. | 2026-11-11 |
| G | The adopted signatures that differ from the generator | Ratified as proposed. After the push of `dedicated-integration-16`, one batch: the comparison becomes `tools/oracle-closure/sigcheck.py` and a step `sigs` of `tools/gate.sh`, which ignores spelling that does not change the type. One agent proves each real difference at Raven's lines: a row for an existing kind, a return to the generated form, or a row for the user. End state: the check prints nothing, or only entries that a table in `rulings.py` names with their ledger row, and a new difference fails the gate. The investigator's count: 43 differ, 7 are the groups of S1 to S4, 36 are in no ledger. This does not block the push. | 2026-11-11 |
| F | The order of the work and the coordinator's authority | Ratified as proposed, with the user's words "i will start fresh and we will run the new changes for this". Phase 1: the efficiency changes land on the branch `agent-efficiency` by Fable agents (gate scripts, the user's ruling on the memory record and the apply pass, the four agent definitions, the ignore commit, the start hook and the subagent test), one PR. Phase 2: rows B, S1 to S4, and C on `dedicated-integration-16`, one generator run, `tools/gate.sh`, one PR. Phase 3 in parallel: the referee recordings, the six live-path reviews, stage 1 of the golden tests, the signature batch. Phase 4: the cleanup, the scripted client, the later golden stages, the ui scout. The coordinator may commit, push, open a PR, merge, and watch CI for the branches of phases 1 and 2 and the fix PRs of phase 3, and may create the folder `referee-corpora`. It stops for every new form, for the user's configuration and memory, before the cleanup, for the retail client test, and for a red gate it cannot explain. | 2026-11-11 |

## The fourth walk: the questions of the memory record

The rows are the eight questions of section 7 of `notes/2026-11-11/memory-prune.md`. Row Q5 gained five rows during the walk. The texts of rows Q5.1 to Q5.5 are private and are in no tracked file.

| Row | Subject | Verdict | Lands in | Date |
| --- | --- | --- | --- | --- |
| Q1 | The home of the architecture facts | Ratified as proposed. Sections B and D of `docs/porting-rules.md` are the architecture section, and no new file is made. Entries 32 and 37 land in section B. | `docs/porting-rules.md`, section B | 2026-11-10 |
| Q2 | The three facts of entry 8 | Ratified as amended. The pointer-alias gap of the variable sweep is closed in `skeleton.py:504` to `:509`, so the fact goes. The QAGAME fact is the design and gets no README sentence, because `channel.py:115` states it. The cast `Float(pm.cmd.forwardmove)` at `bg_pmove.swift:2738` stays, and its row is closed: operators for `Int8` are a new form across the codebase. The entry is removed. | No home, the entry goes | 2026-11-10 |
| Q3 | The three CI rulings of entry 12 | Ratified as proposed. Two lines in the coordinator file, and the entry is removed. | `.claude/CLAUDE.md` | 2026-11-10 |
| Q4 | The reach of rule 20 | Ratified as proposed. Rule 20 holds for every target, nothing is added to the doc, and `CG_ParticleExplosion` at `cg_marks.swift:1554` gets its body. | `docs/porting-rules.md`, rule 20, nothing to add | 2026-11-10 |
| Q5.1 | The definition of the first goal | Replaced by the user. The text is private. | The private goals file | 2026-11-10 |
| Q5.2 | The definition of the second goal | Replaced by the user. The text is private. | The private goals file | 2026-11-10 |
| Q5.3 | The definition of the third goal | Ratified as amended. The text is private. One public effect: each logic target gets a library product in `Package.swift` at some time, and each executable is a thin wrapper over its logic target. | The private goals file | 2026-11-10 |
| Q5.4 | The definition of the fourth goal | Ratified as proposed. The text is private. | The private goals file | 2026-11-10 |
| Q5.5 | What legibility means after the port | Ratified as proposed, from the user's words. The text is private. The rules of the port hold until every product is ported. | The private goals file | 2026-11-10 |
| Q5 | The home of the goal and the order | Replaced by the user: "actually the private .claude/goals.md for agent definitions and such makes more sense". The private file holds the whole text. The coordinator file and the definitions of the reviewer, the generator, and the scout point to it by the absolute path of the main tree. The memory entry `jka-swift-legibility-goal` becomes short and keeps the user's quotes. No public file quotes the goals. | `.claude/goals.md` and memory | 2026-11-10 |
| Q6 | The doc lines that the pass may not change | Ratified as proposed. One exception to the "only add text" limit of row E9, seven edits: the dates go from `docs/porting-rules.md:3` and `:47` and from `docs/transcription.md:23`, `:544`, and `:839`. `docs/transcription.md:49` states the form after row E3. Rule 24 of `docs/porting-rules.md` moves to its place after rule 23. No rule changes its meaning. | `docs/porting-rules.md`, `docs/transcription.md` | 2026-11-10 |
| Q7 | The name `context.md` | Ratified as proposed, with the user's word "worktree". Row E5 covers the coordinator's file at the root of the main tree only. A paused agent writes `context.md` at the root of its own worktree, and the file goes when the agent resumes or its work is committed. | Memory, `jka-swift-user-pauses-agents-directly` | 2026-11-10 |
| Q8 | The lesson about the start hook, entry 1 | Ratified as proposed. The entry is removed in the apply pass. The global `CLAUDE.md` holds the invoke rule. | No home, the entry goes | 2026-11-10 |

One sentence of the record is not ruled: the sentence for entry 28 after `docs/transcription.md:627`, which the record marks "The user must confirm the wording". The apply pass leaves it out.

## A finding of the same session: the game snapshot of a new worktree

The `snap-game` difference of the first full run of `tools/gate.sh` had this cause: `skeleton.py:542` reads `out/extract/<unit>/extract.json` and takes an absent file as an empty list, and a new worktree has no `out/`. The cache was right. `tools/worktree-setup.sh --tools` runs `extract.py` for a unit with no `extract.json` since the commit `bce47b20` on `agent-efficiency`. A possible row for the user: an error exit at `skeleton.py:542` and `merge.py:252` in place of the silent empty list.

## The user's words from the removed memory entries

The apply pass of row E9 removed 38 memory entries. These words of the user were in those entries only. The rule of each is in its home, and this section keeps the words and their dates.

| Subject | The user's words | Date | The rule lives in |
| --- | --- | --- | --- |
| Agents commit only | "can you make a brief you provide every agent you spawn that says that they cannot push. all they can do is commit. pushes, pull requests and merges happen by you." | 2026-11-04 | `.claude/CLAUDE.md` |
| CI | "i only want CI on master merges for now. no gating but yes matrix of executables" and "no macos runner for now". Branch protection on master: a pull request with zero approvals, enforced for admins, no force push, no deletion, no required status check. | 2026-10-28 | `.claude/CLAUDE.md`, `.github/workflows/build.yml` |
| Task-local | "no, don't do a task local" | 2026-09-09 | `docs/porting-rules.md`, rule 6 |
| Dead functions | "don't drop the dead ones" | 2026-11-10 | `docs/porting-rules.md`, rule 20 |
| Checks | "it should just finish with it running in the background and wait for output and start again." | 2026-11-02 | `.claude/CLAUDE.md` |
| Checks | "tell the agents to complete when waiting for background work to finish and not to tail output." | 2026-11-03 | `.claude/CLAUDE.md` |
| Docs | "update porting-rules.md in place, no amendments - it is a source of truth always, not dated" | 2026-09-09 | `.claude/CLAUDE.md` |
| The read set | The agents "are investigating too much. They should be blind and only work within the 3 sets of files they're assigned and the views files they reference." | 2026-09-09 | `docs/transcription.md`, "The read set" |
| Branches | "start branching and doing PRs for all the future work" | 2026-10-27 | `.claude/CLAUDE.md` |
| Performance | "write the findings and these samples. then after cgame we will do them". Row 5 of the first walk moved the start to the end of the whole port. | 2026-10-29 | `notes/2026-10-29/performance-profile.md` |
