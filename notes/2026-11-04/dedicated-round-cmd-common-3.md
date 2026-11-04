# Dedicated round: cmd_common, the third readoption

This record covers the readoption of the host stem `cmd_common` after the rulings batch of PR 56.
The Raven source is `oracle/codemp/qcommon/cmd_common.cpp`, and the Swift file is `Sources/JKAMP_DedLogic/cmd_common.swift`.
The branch is `dedicated-round-cmd-common-2`, and master at `c24e5e7` merges into it with no conflict.

## What changed

- The merge gives `cmd_text_buf` its storage, `var cmd_text_buf: Slots<JKAShared.byte> { world.storage.cmd_text_buf }`, and `Cmd.data` becomes a `Slots<JKAShared.byte>?`, row 4 of the ledger.
- No function signature in master's stub differs from the branch. The file stays adopted.
- `Cbuf_Init` is a full body.
- `Cbuf_AddText`, `Cbuf_InsertText`, and `Cbuf_Execute` are Raven's bodies over `cmd_text.data![i]`, with a hole at each line that has no ruled form.
- `Cmd_Exec_f` is Raven's body over the `inout CharBuf` form of `FS_ReadFile`, row 7 of the ledger, with a hole at the `!f` test.

## Holes and their open rows

- Row "Com_Memcpy into byte slots": `Com_Memcpy` takes `OpaquePointer?`, so no body can copy a `String` into a `Slots<byte>` or a `Slots<byte>` into a `CharBuf`. The `memmove` of `CString.swift` takes a `CharBuf` only. The holes are `Com_Memcpy` at `cmd_common.cpp:78` and `:107`, and `Com_Memcpy` and `memmove` at `:182` and `:195`. Huffman row R-A has the same copy from `seq`.
- Row "FS_ReadFile NULL test": the `inout CharBuf` form gives no NULL for `if (!f)` at `cmd_common.cpp:232`, and `FS_FreeFile` at `:240` takes `OpaquePointer?`. The local `f` is `CharBuf(0)`, and the read replaces it.

## Gate

- `swift build`: complete, 0 errors. The holes give "will never be executed" warnings, and `len` of `Cmd_Exec_f` is written and never read, as in Raven.
- `swift test --no-parallel`: 130 tests in 8 runs, 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem cmd_common`, exit 0: 6 of 17 hand functions replaced, 11 kept, 27 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass.
  The tool reports stale base facts, 6 files, and stale adoption facts for `files_pc.swift` and `msg.swift`. The store of this worktree is from before the merge, and this round runs no generator.
