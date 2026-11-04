# Dedicated round: cmd_common, the fourth round

This record covers the hole round of the host stem `cmd_common` after the second rulings batch of PR 64.
The Raven source is `oracle/codemp/qcommon/cmd_common.cpp`, and the Swift file is `Sources/JKAMP_DedLogic/cmd_common.swift`.
The branch is `dedicated-round-cmd-common-3`, off master at `cb39f60`, in the worktree `/tmp/jka-ded-cmd-3`.

## What changed

- `Cbuf_AddText` at `cmd_common.cpp:78` reads `Com_Memcpy(cmd_text.data!.suffix(from: Int(cmd_text.cursize)), CharBuf(text), l)`, row 1 of the second ledger.
- `Cbuf_InsertText` at `cmd_common.cpp:107` reads `Com_Memcpy(cmd_text.data!, CharBuf(text), len - 1)`, row 1 of the second ledger.
- `Cbuf_Execute` at `cmd_common.cpp:182` reads `Com_Memcpy(&line, text, i)`, and at `:195` it reads `memmove(text, text.suffix(from: Int(i)), cmd_text.cursize)`, row 1 of the second ledger.
- `Cmd_Exec_f` tests `len < 0` at `cmd_common.cpp:232` and calls `FS_FreeFile(f)` at `:240` through the CharBuf overload, row 6 of the second ledger.
- The two text copies, the move, and the length test each have one rule 24 line. The copy of the line keeps Raven's form and has no comment.
- The file has no Port-note and no `portMissing` call. No signature changed.

## Holes and their open rows

No hole stays open in this stem.

## Gate

- `swift build`: complete, exit 0, 0 errors, and no warning in `cmd_common.swift`.
- `swift test --no-parallel`: 138 tests in 9 runs, 0 failures, exit 0.
- `draftcheck.py --unit mp-engine-ded --stem cmd_common`, exit 0: 6 of 17 hand functions replaced, 11 kept, 27 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass.
  The 27 holes are holes of the drafts that the tool prints, not holes of the hand file. The store of this worktree was empty, so the tool wrote the base facts and the adoption facts. This round ran no generator.
