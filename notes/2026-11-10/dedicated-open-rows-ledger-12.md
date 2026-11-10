# The open rows of the dedicated host, the twelfth ledger

This record holds the twelfth batch of open rows of the dedicated host: the ROW-PATTERN rows of `notes/2026-11-10/docket-12.md` of the main tree, and the note corrections that the docket lists. The batch is a generator batch on the branch `dedicated-rulings-batch-12`, from master `03223d0`, with the branch `ded-bodies-be-ai-char` merged first (the 16 bodies of `be_ai_char.swift`).

Each row is auto ruled by pattern, under the standing delegation of the dedicated track. The coordinator checked each proof at its Raven line and at the line of its precedent before the change. Every proof held at its line.

Out of scope by the brief: every ROW-NEW row (BotReplaceSynonyms, the two Z6 LIST arms, the VM_Call text word), every DEAD reclassification, any rule 20 change, `%02d`, the hitch line at `win_main.swift:892`, and any `M_PI` change.

## The rows

Row FN-consolehandle, the `handle` field of `bot_consolemessage_t`: PATTERN, auto ruled by pattern, precedent the FIELD_NAMES rows of `tools/oracle-closure/rulings.py:847` to `:851` (cvarHandle, packHandle, modelHandle). Raven writes the field at `be_ai_chat.cpp:325` and reads it at `:290` and `:360`. Landed: the row at `rulings.py:853`, the accessor `messageHandle` in `Sources/JKAMP_Ded/Generated/Views/BotConsolemessage.swift`.

Row FN-chathandle, the `handle` field of `bot_chatstate_t`: PATTERN, auto ruled by pattern, same precedent. Raven counts the field at `be_ai_chat.cpp:323` to `:325`. Landed: the row at `rulings.py:855`, the accessor `chatHandle` in `Sources/JKAMP_Ded/Generated/Views/BotChatstate.swift`.

The three bodies these rows unblock, `Sources/JKAMP_DedLogic/be_ai_chat.swift`: BotRemoveConsoleMessage (`be_ai_chat.cpp:279`), BotQueueConsoleMessage (`:309`), and BotNextConsoleMessage (`:350`). Landed, Raven's lines in order, no AI line.

Row NOT_PORTED-replaced, Cvar_FreeString (`cvar.cpp:26`): PATTERN, auto ruled by pattern, precedent the NOT_PORTED rows memmove and VM_DllSyscall of `rulings.py:1547` and `:1560`, form `skeleton.py:1440` to `:1443`. Raven's callers in cvar.cpp are live. No Swift caller remains: each Swift site drops the free under an AI line (`cvar.swift:232`, `:243`, `:252`, `:344`, `:364`, `:376`, `:458`, `:755`). Landed: the row at `rulings.py:1562` and the marker in `cvar.swift`.

Row NOT_PORTED-replaced, Sys_GetFileTime (`files_pc.cpp:568`): PATTERN, auto ruled by pattern, same precedent. Sys_FileOutOfDate (`files_pc.cpp:600`) is the one caller, and the Swift body calls `SysBackend.GetFileTime` under an AI line at both sites. No Swift caller of Sys_GetFileTime remains. Landed: the row at `rulings.py:1564` and the marker in `files_pc.swift`. The manifest rows of both functions read `missing | marker`, the form of VM_DllSyscall.

## The note corrections

Each note now states what is true at Raven's lines. No behavior changes.

- AAS_StringFromIndex and AAS_IndexFromString, `be_aas_main.swift`: dead by chain, through AAS_ModelFromIndex (`be_aas_main.cpp:107`) and AAS_IndexFromModel (`:117`). Landed.
- AAS_NearbySolidOrGap, `be_aas_reach.swift`: callers only in comments, `be_aas_reach.cpp:978` and the blocks of `:1022` and `:1366`. Landed.
- VM_VM2C, `vm.swift`: a rule 20 dead line. Landed.
- Cvar_Realloc, `cvar.swift`: dead, Cvar_Defrag is the one caller and only `client/cl_main.cpp:715` calls it. Landed.
- Sys_GetCPUSpeed, `win_shared.swift`: dead, the one caller `win32/win_main.cpp:1469` is not in the WinDed link set. Landed.
- Sys_GetCPUSpeedOld, `win_shared.swift`: the old note said no file of the link set calls it, which is false (`win_shared.cpp:425`). Now dead by chain through Sys_GetCPUSpeed. Landed.
- MC_Compress and MC_UnCompress, `matcomp.swift`: rule 20 dead lines, the second with the comment callers of `tr_ghoul2.cpp:1705` to `:1746`. Landed.
- Log_WriteTimeStamped, `l_log.swift`: the "no `0` flag" note was stale, because `JKAShared/Format.swift` pads with zeros. Now a rule 20 dead line, only the declaration `l_log.h:24` names it. Landed.
- CBlockStream::Create, `CBlockStream.swift`: the note cited callers in Interpreter.cpp, but no file calls CBlockStream::Create. Landed.
- CBoneCache::SmoothLow, `CBoneCache.swift`: the note now names the EvalRender calls of RB_SurfaceGhoul at `tr_ghoul2.cpp:4314` to `:4368`, under `#ifndef DEDICATED`. Landed.
- WriteIndent and WriteFloat: the DEAD row text (`rulings.py:1537` to `:1538`) and the hand notes of `l_struct.swift` now also name the calls of `be_ai_weight.cpp:433` to `:525` under the `#if 0` of `:421` to `:533`. Landed.
- The views BotConsolemessage and BotChatstate said that no body reads `handle`. The FIELD_NAMES rows replace that line. Landed.
- PC_FindDefine, PC_DefineFromString, PC_CopyDefine: the hand notes were already true. No change.
- The 20 CRMMission stubs: open. Most of their dead proofs use the DEAD-BY-DEDICATED-NULL proof form, which the user rules first.

## The timing

Each line is one step, in seconds. One sequence run, all steps exit 0. No other Swift process ran.

| Step | Run 1 |
| --- | --- |
| extract, 9 units | 73 |
| merge | 1 |
| tables | 0 |
| check | 4 |
| reexport | 56 |
| views-game | 65 |
| views-cgame | 45 |
| views-ded | 49 |
| skeleton-game | 25 |
| skeleton-cgame | 15 |
| skeleton-ded | 25 |
| manifest-game | 24 |
| manifest-cgame | 15 |
| manifest-ded | 25 |
| traps-game | 4 |
| traps-cgame | 2 |
| channel | 3 |
| sum of steps | 431 |

| Gate step | Seconds | Exit |
| --- | --- | --- |
| debug build | 49 | 0 |
| snapshot check mp-game | 125 | 0 |
| snapshot check mp-cgame | 52 | 0 |
| snapshot check mp-engine-ded | 72 | 1 |
| swift test | 42 | 0 |
| tool tests | 3 | 0 |
| release build | 115 | 0 |
| referee, fork host | 2 | 0 |
| referee, Swift host | 21 | 0 |

## The gate

- The sequence, run 1: every step exits 0. The debug build, run 1: exit 0, so no fix round was necessary.
- `swift build -c release -j 6`: exit 0.
- `swift test --no-parallel -j 6`: 156 of 156 pass.
- The tool tests: 100 run, OK, 15 skipped.
- `snapshot.py --check`: mp-game, 372 files, no difference. mp-cgame, 246 files, no difference.
- mp-engine-ded, 554 files, a difference in 14 files. Each line belongs to this batch: the two accessors of the views, the NOT_PORTED markers in the skeleton and the drafts of `cvar.swift` (22 holes to 21) and `files_pc.swift` (193 holes to 190), the DEAD text in the skeleton and the draft of `l_struct.swift`, the `missing` column of the manifest rows of Cvar_FreeString and Sys_GetFileTime, and line shifts in the manifests of `be_ai_char`, `be_ai_chat`, `cvar`, `files_pc`, `matcomp`, and `vm`. With the line numbers removed, the other old and new manifest rows are the same.

## The result

`portMissing(` stands 213 times under `Sources/JKAMP_DedLogic`, against 234 on master `03223d0`. The merge of the be_ai_char bodies removed 16, and this batch removed 5.

The referee replay of `corpus-ffa1.rec`, 2400 frames, `g_maxForceRank 7` on both lines, the contract-off fork host (`/tmp/referee-ref/openjkded.arm64`, a copy of `/tmp/referee-scratch/openjk-nocontract/openjkded.arm64`) against the release `jampded` of this branch, one release module in both homepaths: green. The `REF READY` lines are equal, both hosts print 2400 `REF STEP` lines, the diff of the two streams is empty, and both hosts print `REF REPLAY END` once. First and last steps: `n=1 t=425 ck=3cfa876c` and `n=2400 t=60400 ck=1b1716ec`, the same as the green run of the referee port. The runner is `/tmp/b12-run-corpus.sh`, the form of `/tmp/referee-out/run-corpus.sh`, and the streams are in `/tmp/b12-referee/`.

## The open items

- `tools/host-referee.sh` does not run green as it is. Its `fs_basepath` is the Steam folder, whose path holds a space, and the Swift host splits the argument at the space (`/Users/milohehmsoth/Library/Application`), so it finds no game data and stops before the first `REF STEP`. The fork host takes the path whole. The runner of the referee port uses `~/Developer/jka/jka_server` as the base path, and that run is green. The script also deletes `SCRATCH`, which held the build folder of the contract-off fork host.
- The drafter does not apply FIELD_NAMES. The drafts of `be_ai_chat.swift` spell `m!.handle` and `cm.handle`, as the drafts of the cvarHandle sites do.
- The 20 dead notes of `CRMMission.swift` wait for the DEAD-BY-DEDICATED-NULL proof form.
