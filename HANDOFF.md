# Handoff, 2026-10-11

This file is for the session that resumes the work. It replaces the handoff of 2026-10-09, which the frame loop closed. Delete it when the rulings build of the frame-path docket is committed and reviewed, after task 2 below.

## Where the tree is

- Branch `wave-0` at 3222d10 in the main checkout, 58 commits past `origin/wave-0`. Nothing is pushed. Every commit passed its gate: `swift build` at 0 errors, `swift test --no-parallel` at 112 tests in four binaries (84, 14, 13, 1), and `tools/load-test.sh` at exit status 0.
- The working tree holds the uncommitted phase 1 of the rulings build, 34 files: 13 helpers from the helper builder, 21 guide lines in `docs/transcription.md` from the guide builder, and whatever the generator builder has written so far. See "The run in flight".
- The milestone of the day: the frame loop runs clean under the real OpenJK engine. `G_InitGame` returns, the settle loop runs, `+quit` runs `G_ShutdownGame` to its end, and `FRAMES=2400 tools/load-test.sh` holds the server for one minute of frames with no client and exits 0. `G_InitGame` spends about eleven seconds after its `InitGame:` line, in the bot path load or the arena parse, a finding not yet measured.
- The frame-path round ran in three waves, 19 transcriptors, and the game-logic Port-note count fell from 830 to 246. Five reviewers read all 585 fills against Raven's C and jka-rust. Their findings are rows, not hand fixes.
- The remaining 246 holes stand on forms the docket rules on. The docket of 85 rows (A1 to U3) is ruled, with the walk record as the ledger, and the rulings build applies it.

## The records of the day

All under `notes/2026-10-11/`, and the load-test record of 2026-10-09 gained sections seven to nine.

- `frame-path-round.md`, the round: three waves, two review legs, the proofs, and the docket rows A1 to U3 with the findings outside the rows.
- `frame-path-walk.md`, the ledger: every verdict, the delegation, "The work the rulings order" grouped by where it lands, and the six conflict rulings. This is the plan the rulings build follows.
- `holes-*.md`, twenty per-file hole tables. `review-*.md`, five review records.
- `docket-proofs-*.md`, seven proof records by letter group and six conflict proofs. A row is presented with its proof; see the memory `jka-swift-prove-rows-before-presenting`.
- `rulings-build-helpers.md`, `rulings-build-guide.md`, and when the builder lands, `rulings-build-generators.md`: the phase 1 records, each with an "Unruled" section of the choices no proof gave.

## The run in flight

A generator builder (opus) was running when this handoff was written. Its brief: the three `rulings.py` entries, the six generator changes (generator item 3 is the `spelling.py` check swap only, per conflict 3), the three drafter rules, then the generators in pipeline order without `merge.py`, then `manifest.py`, then `swift build`, `swift test --no-parallel`, `tools/load-test.sh`, and the tool tests. It fixes errors in files it owns and in the 13 helper files when the proof gives the fix, and records the rest. It does not commit. Its record is `notes/2026-10-11/rulings-build-generators.md`.

If the resume finds that record complete: read it, run `git status --short`, and go to task 1. If the record is absent or partial: the builder was stopped. Run `swift build` yourself, read the errors, and finish its steps 3 to 6 from the brief above before task 1. The three helper records name every file phase 1 touched.

## What comes next

1. Gate and commit phase 1. The gate is the builder's. Then one review leg over the uncommitted diff of phase 1, read-only, against the proofs: do the helpers, generators, drafter rules, and guide lines match the Verdict paragraphs of `docket-proofs-*.md` and the six conflict verdicts. Commit code and records separately, subjects "The rulings build, phase 1" and "The records of the rulings build, phase 1". Then present the unruled choices of the three records as rows, one per message, under the ratification walk, each proven first.
2. Phase 2, the hand sites and the fills. Transcriptors on disjoint files under `Sources/JKAMP_GameLogic/`, the same brief shape as the frame-path waves, with the walk record's forms now in the guide. The work: the 17 "Hole fills that can run now" of the walk record; the committed-code changes the rulings order (N1, the `hackingTime` stores in FighterNPC and the eleven other `Int32(Float(x) ...)` sites; R1 `Jedi_SetEnemyInfo`; R2 `G_DebugPrint`; R6 SpeederNPC; R9 `G_Find` and its 15 callers; R10 `G_RMGPathing`; R14 `Rancor_Attack`; U2 `modNames`); and a new hole round over the 246 standing holes, since most of them now have a form. Gate, review leg, commit per wave, as before.
3. Task 6 of the old list: a stock client connects to the running server. The client `openjk.arm64` needs `rd-vanilla_arm64.dylib` beside it or in the basepath, and nobody has run it. It opens a game window, so the user is at the machine for it.
4. Playable FFA with two clients, then CTF or Siege and bots.
5. The open findings: the eleven of the 2026-10-08 handoff (git history at 7781d65), the eleven seconds of `G_InitGame`, the `atof` double add (U3), and the pools.

Housekeeping the user has not asked for: the snapshot refresh at `$HOME/.cache/jka-swift/snapshot-stage-two-shared` per `notes/2026-10-09/snapshot-refresh.md`, the full `draftcheck.py --game` reference as five `--stem` calls of 15 stems, and the removal of the worktrees `.claude/worktrees/spine`, `agent-ac60452bfe29cede1`, and `agent-ab5a812070adf61d9`. The manifest regenerate is in the generator builder's brief.

## The standing rules of this work

- The user drives. Short steps, surface choices for a ruling, commit on the typed word "commit", push on "push". On 2026-10-11 the user said "commit and go, you do the work for this session", and the coordinator committed each gated step and each record. A new session asks before it assumes that authority again.
- A docket row is proven before it is presented: investigator agents (opus) prove every hole site, every Raven use with file and line, the jka-rust handling, the Swift types, the existing helpers, and the guide, and give a verdict on the premise and the form. Then the row is presented one per message under the ratification walk, with its proof. "ratified", "ratified as amended", or a dictated replacement closes it. "ratify all as proposed" delegates the open rows to the coordinator, who rules each as its proof proposed and writes the ledger. When proofs disagree on shared ground, the disagreement is a new question, proven and ruled on its own.
- Transcriptors read only their files, their oracle slices, their manifests, the state file, the guide, and the lookup tool, never build, never edit `g_local.swift` or the guide, and list the `GameWorld` properties the coordinator must add. The coordinator gates each wave with `swift build`, `swift test --no-parallel`, and `tools/load-test.sh`, in one foreground Bash call each, and a review leg reads every fill against Raven's C and the jka-rust range before the commit. Reviewers report, they do not fix. A finding is a docket row.
- Every agent brief carries the house-style and asd-ste100 invoke lines. Subagents run on opus, sonnet, or haiku. A record is written straight into its file in `notes/<date>/`, never pasted in chat. Records and code commit separately. No co-author trailer.
- Two builders run at once only on disjoint files, and only one builds at a time: the others leave the gate to the one that runs the generators or to the coordinator. Nobody runs the store tools while another builder does.
- A defect of a form goes to the form, the guide line, the generator, or the drafter rule, not to a hand fix in one file. A hand fix of committed code happens only under a ruled row.
- Both jka-rust trees are read-only. The submodule `jka-rust/` is the manifest's tree. Nothing under `openjk/`, `oracle/`, or the Steam folder changes.

## Suggested skills

- `ratification-walk` before any row is presented, and the proof first.
- `house-style` and `asd-ste100` before any Swift, comment, doc, record, or commit body, through the Skill tool.
- `code-review` for the review leg over phase 1.
