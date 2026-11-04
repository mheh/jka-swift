# The third hole round of msg

This record holds the third readoption of the host stem `msg` after the open rows of PR 56, and the third hole pass. The tree is the worktree `/tmp/jka-ded-msg-2` on the branch `dedicated-round-msg-2`, with master at c24e5e7 merged in.

## The merge

`git merge master` merged with no conflict, as 5013f2d. Git applied master's two changes to the adopted `msg.swift`: the overload `MSG_WriteData(_ buf: Msg, _ data: CharBuf, _ length: Int32)` of row 5 stands beside the stub, and `g_netfBitStorage` and `g_psfBitStorage` are `BitStorage?` variables over `world.variables` by row 14. The file stays adopted.

## The signatures

No function signature changed. The two globals changed from the `TODO: Port` marker to a real variable.

## What landed

| Commit | Subject |
|---|---|
| 5013f2d | Merge branch 'master' into dedicated-round-msg-2 |
| 9db355d | The third hole round of msg |

- `MSG_WriteString` and `MSG_WriteBigString` have Raven's body. The literal `""` and the local `CharBuf` go to the overload of row 5. Raven's NULL test of `s` has no Swift form, because the parameter is a `String`, the form of `bg_misc.swift:176`.
- `MSG_CheckNETFPSFOverrides` has Raven's body. The choice of `&g_psfBitStorage` or `&g_netfBitStorage` is a nested function that takes the chosen variable as an `inout BitStorage?`, the shape of "A pointer to a chosen file-scope variable" in `docs/transcription.md`. The locals that only the nested function reads are declared inside it, because a nested function cannot capture a local before its first store.
- Raven's walk `bitStorage = &(*bitStorage)->next` keeps the last record, so each new record goes into the head or into that record's `next`. `assert(restore)` drops under the NDEBUG row.

## The holes left open

- `FS_Read` in `MSG_CheckNETFPSFOverrides`, `msg.cpp:2070`: a new open row. `FS_Read` takes `OpaquePointer?`, and the host has no `inout CharBuf` overload, the form `trap_FS_Read` has at `Sources/JKAMP_Game/Generated/g_syscalls.swift:137`. The site is a `portMissing` call under a Port-note, so the statements after it do not run.
- `Z_Malloc` in the same body: a new open row. `TAG_GENERAL` is an `Int32` in `Sources/JKAMP/Generated/q_shared.swift:599`, and `memtag_t` is a `CChar` in `Sources/JKAShared/Generated/q_shared.swift:670`. The site writes `memtag_t(TAG_GENERAL)` under a Port-note, a cast that Raven did not write.
- The global `fp` keeps its `TODO: Port` marker, as before.

## The counts

| Count | Value |
|---|---:|
| Functions of the stem | 48 |
| Bodies transcribed | 48 |
| Functions left as holes | 0 |
| `portMissing` calls in `msg.swift` | 1, from 3 |
| `TODO: Port` markers in `msg.swift` | 1, the global `fp` |
| `Port-note:` lines | 4: the row 5 overload, 1 rule 19 note, and 2 open rows |
| `// AI:` lines | 1, the row 5 overload |

## The gate

- `swift build`: complete, no error. One warning in the stem, "will never be executed", after the `FS_Read` hole.
- `swift test --no-parallel`: 130 tests in 8 runs, all pass.
- `draftcheck.py --unit mp-engine-ded --stem msg`, run with the tool venv, exit 0: 18 of 48 hand functions replaced, 30 kept, 93 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass. The tool reported stale base facts (6 files) and stale adoption facts (`files_pc.swift`) before the run, and the run did not change a tracked file.
