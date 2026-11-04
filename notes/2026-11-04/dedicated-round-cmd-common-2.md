# Dedicated round: cmd_common, the readoption

This record covers the readoption of the host stem `cmd_common` after the table batch of PR 55.
The Raven source is `oracle/codemp/qcommon/cmd_common.cpp`, and the Swift file is `Sources/JKAMP_DedLogic/cmd_common.swift`.
The branch is `dedicated-round-cmd-common-2`, and master merges into it with no conflict.

## What changed

- The merge gives `cmd_text` its view: `var cmd_text: Cmd { world.storage.cmd_text }`.
- No function signature in master's stub differs from the branch, and no `TODO: Port signature` marker was in the stub.
- The 12 hand bodies stay as written. The file stays adopted.
- The second hole pass fills no body. Each of the five holes has a one-line `Port-note:` that names its open row.

## Holes and their open rows

- `Cbuf_Init`, `Cbuf_AddText`, `Cbuf_InsertText`, `Cbuf_Execute`: the row `cmd_text_buf`. The stub keeps `let cmd_text_buf: [byte]`, and `Cmd.data` is an `OpaquePointer?`, so no body can point `data` at the buffer or index it.
- `Cmd_Exec_f`: the row `FS_ReadFile` buffer. The stub `FS_ReadFile(_:_: inout OpaquePointer?)` gives no `String` for `Cbuf_InsertText`.

## Gate

- `swift build`: complete, 0 errors.
- `swift test --no-parallel`: 130 tests in 8 runs, 0 failures.
- `draftcheck.py --unit mp-engine-ded --stem cmd_common`: 27 holes, 0 cascade errors, 0 compile holes, 0 defects in the stem.
  One defect stands outside the stem: the mirror cannot resolve `JKAMP_BG` at `Sources/JKAMP_DedLogic/Generated/Callbacks.swift:4`. The file is the same as on master, and the real build resolves the module.
