# After the stubs: the end state of the count and the work that follows

This note records two things for the dedicated server port as of 2026-11-10: what the stub count of the logic target reaches when the body waves end, and the work that is not a stub. It gives the facts and the sources for each, so that a session with no memory of the day can continue from it.

## Where the port stands

- `master` is at `001b610c`, the merge of PR 94. CI is green in every lane.
- The Swift `jampded` loads `mp/ffa1`, runs the game module, and replays the referee recording with four bots.
- The referee is green: the Swift host and the reference host print 2400 equal `REF STEP` lines over `corpus-ffa1.rec`. The record is `notes/2026-11-10/dedicated-referee-port.md`.
- The logic target `Sources/JKAMP_DedLogic` holds 213 `portMissing` stubs on master. The local branch `dedicated-integration-14` holds 99, after eight body sets wrote 109 bodies.

## 3. The end state of the stub count

### The rule that sets the goal

The user ruled on 2026-11-10 that a function with no caller in the dedicated server still gets its real body. Rule 20 of `docs/porting-rules.md` states it. So a proof that a function is dead does not close its stub. An independent trace confirmed 206 of the then 234 stubs as dead (`notes/2026-11-10/dead-check.md`), and all of them are ported like live functions.

### The plan

`notes/2026-11-10/docket-13.md` is the plan. It sorts every stub into a body set and names what each set waits on. The sets and their state:

| Wave | Sets | State |
|---|---|---|
| 1 | S1 to S8 | Written, reviewed, and merged into `dedicated-integration-14`. 109 bodies. |
| 2 | W1, W2, W4, W5, and two more of the W group | They wait on generator batch 13. |
| 3 | W3, W6, R1a, R2, R3, R4 | They wait on batch 13 and on the rulings of ledger 14, which are all made. |
| 4 | R1b | It waits on R1a. |
| 5 | R1c | It waits on R1b. |

Section 4 of the docket lists the files and functions of each set with Raven's file and line. Two sets that run at the same time never edit the same file.

### The rulings that the waiting sets need

All are made. Ledger 13 (`notes/2026-11-10/dedicated-open-rows-ledger-13.md`) and ledger 14 (written by generator batch 13, `notes/2026-11-10/dedicated-open-rows-ledger-14.md`) hold them. The proofs are in `notes/2026-11-10/rows-13-g2.md`, `rows-13-bot.md`, `rows-13-eng.md`, and `rows-14-new.md`. In short:

- The `CRMInstance` hierarchy takes the enum form of rule 17, by the user's typed word: one `final class CRMInstance` with the base fields, one field `kind` with the cases `bsp`, `group`, `random`, and `void`, one `switch` per virtual method, and each override in the file of its Raven subclass. It is the first class hierarchy of the port.
- The ROFF client arms return false with a rule 19 note.
- A string table that can hold NULL takes a parameter kind that gives `Slots<String?>`.
- The `drawPoly` closure takes `Slots<vec3_t>`.
- `CGPGroup` gets two weak in-order links.
- `TerrainPatchIterate` drops `userdata`, and the closure captures the value. This is the first such form in the port.
- `leafList_t.list` gets a second hand accessor for brush pointers.
- The Ghoul2 save and load write Raven's 32-bit offsets into a byte buffer, with the four pointer fields as zero.
- `G2_GetGoreRecord` takes a hand signature that returns the class.
- The builtin define table of `PC_AddBuiltinDefines` is a local array of labeled tuples with no end row.
- The two x86 opcode scans return the values of Raven's `unix/unix_main.c:68` to `:79`, and the two CPU speed functions get bodies behind `SysBackend`.

### What stays when the waves end

No `portMissing` stub stays in `Sources/JKAMP_DedLogic`. What stays is a short list of "Not ported" lines, each with its reason at the site:

| Function | Reason |
|---|---|
| `GPV_GetNext`, `GPV_GetInOrderNext`, `GPV_GetInOrderPrevious`, `GPV_GetList`, `GPG_GetPairs`, `GPG_GetInOrderPairs` | Ruling C3 makes the value list an `Array`, so the chain they walk does not exist. The user ratified this on 2026-11-10: the dead-function rule yields to C3 for these six. |
| `CleanTextPool` | Ruling C3 makes the text pool a `String`, so nothing is left to free. |
| `Cvar_FreeString`, `Sys_GetFileTime` | Raven's callers are live, but no Swift caller remains, and each Swift site drops the call under an AI line. |

One stub is outside the dedicated target and belongs to the same rule: `CG_ParticleExplosion` at `Sources/JKAMP_CGameLogic/cg_marks.swift:1554`. The user ratified that it gets its body.

### How each wave lands

1. Six body agents at most, each in its own worktree, with `-j 2`. The common brief is `/tmp/wave4-brief.md`. If `/tmp` was cleared, the brief's content is: follow Raven's lines in order, no cast where the ruled form avoids it, no `Unsafe` in a logic body, no new helper without a Raven counterpart or an existing pattern, one `// AI:` line only where a ruling changes what Raven did, a C++ math call on a `float` takes the float overload, a stub that needs a missing row stays with an exact note.
2. A line-by-line review by read-only agents. These functions have no caller, so no run and no referee can check them. The review is their only check. In wave 1 it found one defect in 109 bodies: `CBlockStream::Create` wrote 8 bytes for a header that Raven's 32-bit build writes as 4.
3. A local merge of all sets into one integration branch, the gate, the Linux build in the `swift:6.4-noble` container, the three snapshot checks, the referee through `tools/host-referee.sh`, then one PR and one CI run.

### Two rules of size that the reviews showed

The docs do not state these in one place yet.

- Bytes that go into a file or a buffer with Raven's format take the sizes of Raven's 32-bit build. Examples: the 4-byte header of `CBlockStream::Create`, `sizeofCBoneCache`, the Ghoul2 save layout.
- Slots that hold real pointers of this machine and that no file stores take the size of this machine. Example: the define hash table of `l_precomp.swift`.

## 4. The work that is not a stub

### 4.1 A wider referee

What a green run proves, in one sentence: for the 2400 frames of `corpus-ffa1.rec`, with one Swift game module, the Swift engine and the OpenJK engine at `35e4184f` give the same state checksum after each frame, when both do one IEEE rounding for each `float` operation with no contraction.

What it does not prove:

- Equality with the retail server. Retail is x87 code and rounds at the store. On a random surface normal, the strict and the x87 result of `DotProduct` differ in about 43 % of samples. The full study is `notes/2026-11-10/float-semantics.md`.
- Anything outside this recording. It is one map, FFA, four bots, 60 seconds. It does not exercise a siege map (ICARUS scripts and ROFF), vehicles, a real network client, or a map change.

The reference host is the OpenJK fork at the pinned commit `35e4184f`, built with `-ffp-contract=off` by `tools/build-referee-host.sh` into `.build/openjk-nocontract/`. The user ratified this as an amendment of row H14. Without the flag, the fork's arm64 build fuses a multiply and an add: `DotProduct` then breaks frame 27, and the end point line of `CM_Trace` breaks frame 1410. Both hosts set `g_maxForceRank 7`, because OpenJK changed that default from Raven's 6.

The next step is new recordings. Each `.rec` file is recorded on the fork. Candidates, in order of how much new code each reaches: a siege map, a map with vehicles, a duel, a recording with a map change. The design of a recording is in `notes/2026-11-03/dedicated-referee-docket.md`, and the harness is in `notes/2026-11-03/dedicated-referee-harness.md`. The existing corpus is at `/Users/milohehmsoth/Developer/jka/seam-test/referee/corpus-ffa1.rec`. That tree is read-only for an agent.

A mismatch in a new recording is one of three things, and row H9 says how to treat each: a porting defect in the Swift (fix it), an OpenJK change to Raven's engine (the Swift keeps Raven's form, and the mismatch becomes its own row), or a property of the reference build.

### 4.2 The review of the live path that is not done

Three reviews on 2026-11-10 read the live path of a map (`notes/2026-11-10/review-11-path.md`, `review-11-cmsv.md`, `review-11-g2tr.md`). They did not read these parts:

- The file system and pk3 code (`files*.swift`).
- `msg.swift`, the Huffman code, and `net_chan.swift`.
- `CM_LoadMap` and the patch build path of `cm_patch.swift`.
- `SV_InitGameProgs`, `SV_SendClientMessages`, and most of `sv_client.swift` and `sv_snapshot.swift`.
- `VM_Create` and `Sys_LoadDll`.
- The cvar, zone, and hunk internals.

The referee checks the result of these only as far as the entity state and the player state. It does not see the bytes of a network message, a file read that gives the same data by a wrong path, or memory use. So this review is worth agents before a real client connects.

Note for the brief of such a review: one reviewer of the first round read a commit of a merged branch and not the head, and reported 13 stubs that master had already filled. The brief must name the head to read.

### 4.3 A real client

Nothing has tested a real client that connects to the Swift server. The referee drives fake clients from a recording. A real connection exercises the challenge and connect packets, the netchan fragments, the delta compression of snapshots, the download path, and `sv_pure`. This is the test of the milestone "a person can join and play", and it needs the user at a client, or a scripted client.

### 4.4 Speed

A replay of the corpus takes 4 s on the fork and 25 s on the Swift host. With no client, 2400 frames take 2 s and 20 s. A debug build spends minutes in `MSG_initHuffman`: the loop bounds match Raven (2,106,680 `Huff_addRef` calls), and each view access makes a new `Slots` with two closures that a debug build does not specialize. This was read from the code and not profiled.

By the user's ruling of 2026-10-29 the performance rows wait until the whole project is ported (`notes/2026-10-29/performance-profile.md`, rows R1 to R5). These numbers are input for that docket, not work to start.

### 4.5 The goldens without a parity test

Rule 18 says the Swift port reproduces each golden in a Swift test. Only `qmath`, `bglib`, `huff`, and the trajectory section of `bgmisc` have such a test. Seven goldens are only loaded: `gcombat`, `pmove`, `pmove_saber`, `pmove_trace`, `qshared`, `saberload`, `wsaber`, and most of `bgmisc`.

The float `M_PI` sweep of 2026-11-10 changed three goldens: `qmath` (17 lines), `pmove` (18 records), and `bgmisc` (8 records). They now come from the `jka-rust` dumpers with `float-mpi.patch` applied, so that Raven's own `M_PI` of `q_shared.h:548` applies. That is the named exception of rule 18. An agent proved each rebuild: the unpatched dumper output equals the old golden byte for byte. Nothing compares the Swift with `pmove`, so that part of the sweep is not proved.

The user saved this work for later on 2026-11-10. It is task 1 of the session's task list and an item of `HANDOFF.md`. It is outside the dedicated track and does not start without the user's word.

### 4.6 Cleanup

About 28 worktrees are under `/tmp`, and their branches exist locally. Twelve remote branches are merged. The permission classifier blocked a removal loop once, so the coordinator needs the user's word for it. The rule for a worktree with submodules: remove the submodule folders with `rm -rf`, then `git worktree remove --force`. Never run `git submodule deinit`.

Before removal, copy out what is not committed: `/tmp/jka-batch-10/.claude/manifest/mp-engine-ded/` was never committed.

### 4.7 The question of what done means

Two milestones are different, and the port has reached neither in full:

1. No stub in the dedicated logic target, and a green referee on one recording. The stubs end with wave 5. The recording is green today.
2. A server that a real client can join and play on, over more than one map and game type. Nothing has tested this.

The user has not said which one closes the dedicated track, or what follows it. The standing order from 2026-10-29 is: every product ports first (cgame, ui, engine, renderer, SP), legibility after, plus a number for Swift against C.

## The facts a new session must not get wrong

- A claim that an agent returns is not a fact until someone reads the cited lines. Three times on 2026-11-10 a claim was wrong and was repeated to the user: "all snapshot differences come from row X23" hid lost drafts, "the capsule bounds differ because `fabs` is double" was false because Raven's server files are C++, and "the end point line causes frame 27" was false because `DotProduct` does.
- A fixture is not changed to agree with the port on the coordinator's word alone. The goldens changed only after an independent rebuild proved the dumper, and under the user's word.
- A generator row that can reach the game or the cgame needs its snapshot differences read line by line before the caches are refreshed.
- The Linux lane of CI fails on things the Mac build accepts: Glibc marks the arguments of `strcmp` as nonnull, and `random()` is ambiguous with the C library's. Build in the `swift:6.4-noble` container before a push. The named volume `jka-linux-build` holds an incremental build.
