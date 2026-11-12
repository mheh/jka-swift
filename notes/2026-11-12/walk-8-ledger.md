# The ledger of the eighth walk

The session had five short walks. The user's rule from walk 7 held: each row has its proof before it is presented, and one row goes in each message. A row is closed in this ledger when its text is in the home that the "Lands in" column names. All rows are of 2026-11-12.

## The first walk: the findings of walk 7 with no ruling

| Row | Subject | Verdict | Lands in |
| --- | --- | --- | --- |
| 1 | A slot write does not fill with zeros as `Q_strncpyz` does | Ratified as proposed. The two writes of `reliableCommands` in `sv_main.swift` read the slot with `charBuf(at:capacity:)`, call the ported `Q_strncpyz`, and write the buffer back with `store(_ buf:)`. `store(_ string:)` does not change, because 285 setter lines use it and Raven's write behind some of them is `Com_sprintf`, which does not fill. Proof: Raven writes the slot only with `Q_strncpyz` (`sv_main.cpp:95`, `:140`), and the decode loop reads byte 1 of the slot when byte 0 is zero (`sv_net_chan.cpp:102-114`). | Commit `d4eca0ff`, PR 112 |
| 2 | `Info_SetValueForKey` traps for a text of exactly 1024 bytes | Ratified as proposed. `Info_SetValueForKey` and `Info_SetValueForKey_Big` take the `>=` of OpenJK at the length check, with Raven's message texts and a Port-note at each check. Proof: Raven's `strcat` writes the NUL one byte past `newi` (`q_shared.c:1311-1318`), OpenJK has `>=` (`openjk/codemp/qcommon/q_shared.c:1010`), and the connect packet and the `getstatus` packet reach the line (`sv_client.swift:285`, `sv_main.swift:483`). | Commit `cfbaf37d`, PR 112 |
| 3 | The Swift `ref_dump` that `referee.py` cannot parse | Ratified as proposed. The Swift does not change. `referee.py` joins the lines of a dump block to the record before them. Proof: the Swift console ends a line after each `Com_Printf` call, as Raven's does (`win_main.swift:96-105`, `null/win_main.cpp:34-40`), and the line form was ruled "No change" on 2026-11-10. The landed form joins only lines of hex digits, so a log line in a dump is dropped as before. | Commit `980931aa`, PR 114 |
| 4 | The lag on a swoop in the live test | Replaced by the user: "this is likely a combination of load on the computer and performance. when we reach the performance stage we will investigate this". | No file. The performance stage |

## Row 20 of walk 7

| Row | Subject | Verdict | Lands in |
| --- | --- | --- | --- |
| 20 | The landing of `golden-stage-2` and the CI change | Ratified as proposed. Proof: the full gate at `c750cd26`, and the linux step at `b84c5300` after the merge of master, which was ok with 0 error lines. | PR 111, `a7c245c6`. The first CI run with the test job in release is green |

PR 110 (`connect-compare`) merged before it on the user's word "then merge 110", as `20fcd612`, after its linux and referee steps were ok.

## The second walk: the items that needed the user's word

| Row | Subject | Verdict | Lands in |
| --- | --- | --- | --- |
| 1 | The stuck CI run record 43096301667 of PR 108 | Ratified, with "but i bet it'll fail. try to do it". The force cancel, the plain cancel, and the delete all failed. The delete gave HTTP 403. The record stays `queued` with no jobs, and it blocks no run. | No file |
| 2 | The landing of `info-slot-fixes` | Ratified as proposed. The full gate ran at `6acac7db` with master merged in. snap-game and snap-ded showed one manifest file each, with Swift line numbers only. | PR 112, `01d652da` |
| 3 | The push of the fork commit and the submodule move | Ratified as proposed. `bb0fc65e` is on `referee` of `mheh/OpenJK`, and the submodule `openjk` names it. This closes row 17 of walk 7. Proof of today: the referee step with players against a host built from `bb0fc65e`, 2400 of 2400, 2 kills. | PR 113, `b2832486` |
| 4 | The home of the ledger of this session | Ratified as proposed. This file. | `notes/2026-11-12/walk-8-ledger.md` |

## The third walk: the generator batch of walk 7 and the MP ui

| Row | Subject | Verdict | Lands in |
| --- | --- | --- | --- |
| 1 | The landing of `gen-bg-public`: rows 2, 3, 5, 6, and 7 of walk 7 | Ratified as proposed, with the counts the batch found. Row 6 covers 35 host types and 680 members over 46 types, and not 25 and 487, because a public member names a type and that type's members follow by Raven's access. 24 members that Raven declares private or protected stay internal. Row 3 counts 242 head lines in the game unit, 165 in the cgame unit, and 459 in the host unit. Proof: with the access words taken out, the four large commits change no other line but `Sendable` on `InfoParm`. A script check of the three snap diffs left only the head lines. | PR 114, `f1b475ad` |
| 2 | The bg channel of the ui | Ratified as proposed. No new rule. The read rows of the bg channel are a table with one entry for each unit: the cgame keeps its five rows, and the ui has none. `dllEntry` of the ui builds `BgState(consumer: .ui, maxPoolSize: 512_000)` and calls `installBgChannel()`. Proof: `BgConsumer` has the case `ui` and rule 23 names it, the five rows come from `bg_saber.c:4118-4135`, and Raven's ui build compiles only five bg files (`ui.vcproj:287-323`). | Commits `50ca155a`, `1fce4348`, `dd210c2a`, PR 115 |
| 3 | The tool points of the MP ui batch | Ratified as proposed. The gate has the step `snap-ui`, which passes with "no cache folder" until a landing writes the folder. `worktree-setup.sh --tools` extracts `mp-ui`. `tables.py` writes the ui tables in the form of `cg_tables.c`. The thunks get a map only where the cgame has the same form. | Commits `37db7ee6`, `8f10b6cf`, `77b6846d`, PR 115 |

## The fourth walk: the landing of the MP ui

| Row | Subject | Verdict | Lands in |
| --- | --- | --- | --- |
| 1 | The landing of `mp-ui-batch-1`: rows 8, 9, and 10 of walk 7 | Ratified as proposed. The unit has 594 functions in 6 files and 130 trap functions, and no function has a body. `UI_GETAPIVERSION` answers 7 in the smoke test. One more form in `channel.py`: the line for `bg.fighterAltControl` goes into an install only where the consumer's own C files define the cvar. Proof: no source file of the game, the cgame, the bg target, the host, or the shared target changed, and the gate at `2eed8a40` was ok on each step. | PR 115, `75479fb5`. The cache folder `snapshot-mp-ui` exists |
| 2 | The 12 thunks of the ui display context | Ratified as proposed. `skeleton.py` gives the thunk readers to each unit that has a `ThunkReaders.swift`, and it gets `vector4(at:)`. The generator writes 6 ui thunks. The other 6 stay markers until the body wave of `ui_main.c` adopts the file. `UI_FeederItemText` and `UI_OwnerDraw` come back as rows at that time. Reason: the port uses the generator until each product is landed. | PR 116 |

## The fifth walk: the cgame text of the generator

| Row | Subject | Verdict | Lands in |
| --- | --- | --- | --- |
| 1 | The landing of `ui-thunk-readers` | Ratified as proposed. Two clauses of row 2 above were in conflict, because the cgame has a reader file. The first clause holds: the generator's text for `cg_main.swift` and `cg_predict.swift` maps 6 cgame thunks, and no unit list by name is added. No committed cgame file changes. One more commit: a plain host run adds `public` to `gSequencers` and `gTaskManagers` in `Instance.swift`. Proof: 5 of the 6 generated cgame lines equal the hand lines, and the sixth makes the same call in one line. | PR 116, `948c551a` |

## Findings with no ruling

- The referee checksums depend on how the frames are grouped into `ref_step` calls, on both hosts. This finding is from walk 7.
- The test of row 1 of the first walk proves that all 1024 bytes of the slot are zero after an empty command. It does not prove the decode key, because `SV_Netchan_Decode` is `private`.
- The three recordings with players that were red against the old reference host did not run against the host of `bb0fc65e`. Their green result is the proof of 2026-11-11.
- `datapadMoveData`, one of the 5 ui tables, has its C storage and no Swift side. It has two bounds, `[6][16]`, and no Tables file of the port holds a table with two bounds.
- `trap_R_RegisterShaderNoMip` keeps its default in the ui install of the bg channel, because its ui trap has the one signature marker that is left.
- The ui unit in `project.toml` takes each `codemp/game/bg_*.c` file, which is wider than Raven's five. None of the 594 functions comes from a bg file, so the ui target gets nothing from the wide line.
- The permission check of the session blocked `gh pr create` and `gh pr merge` for PR 112, and the user ran both. It let the same commands through for PR 113 to PR 116.
