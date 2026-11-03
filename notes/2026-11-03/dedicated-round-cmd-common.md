# Dedicated round: cmd_common

This record covers the first hole round on the host stem `cmd_common`.
The Raven source is `oracle/codemp/qcommon/cmd_common.cpp`, and the Swift file is `Sources/JKAMP_DedLogic/cmd_common.swift`.
The branch is `dedicated-round-cmd-common`, off `dedicated-stage-3-landing`.

## What landed

The stub is adopted, and the skeleton header is gone in the commit of the first hand edit.
The round transcribes 12 of 17 bodies from Raven's C.

- `Cmd_Wait_f`
- `Cbuf_ExecuteText`
- `Cmd_Vstr_f`
- `Cmd_Echo_f`
- `Cmd_Argc`
- `Cmd_Argv`
- `Cmd_ArgvBuffer`
- `Cmd_Args`
- `Cmd_ArgsFrom`
- `Cmd_ArgsBuffer`
- `Cmd_TokenizeString`
- `Cmd_Init`

Five bodies stay holes: `Cbuf_Init`, `Cbuf_AddText`, `Cbuf_InsertText`, `Cbuf_Execute`, and `Cmd_Exec_f`.
Open rows 1 and 2 hold the reasons.

## Counts

- Bodies: 17 in the stub, 12 transcribed, 5 holes.
- `// AI:` lines: 2, both in `Cmd_TokenizeString`, one for each token form.
- `Port-note:` lines: 0.
- `swift build`: fails only on the 12 known C errors in `Sources/CJKAMP_Ded/CJKAMP_Ded.c` (11 `TK_*` enumerator redefinitions in `enum_TK_EOF.h` and 1 in `sysEventType_t.h`).
  The build stops at the C target, so the Swift compiler did not check `cmd_common.swift`.
- `swift test --no-parallel`: not run, because the build fails.

## Ledger

- `Cmd_TokenizeString` writes each token into `cmd_tokenized` byte for byte, as Raven does.
  Raven pointed `cmd_argv[cmd_argc]` into `cmd_tokenized`, and the view gives `cmd_argv` as `[String]`.
  The port reads each token out of `cmd_tokenized` through `TextCursor(_:at:).text` at the token's NUL.
  `cmd_tokenized` changes from `let` to `var` so that the writes compile.
- `Cmd_TokenizeString` reads the input through `CharBuf(text_in)`, so the trailing NUL gives the `text[1]` reads of Raven a byte.
  The eurofix `*(const unsigned char *)text > ' '` reads the byte as `UInt8` through the `CharBuf` subscript.
- `Cmd_Argv` writes Raven's `(unsigned)arg >= cmd_argc` as `arg < 0 || arg >= cmd_argc`.
- `Cmd_Args` and `Cmd_ArgsFrom` build a local `String` where Raven fills a static `char` buffer with `strcat`, because the stub returns `String`.
- `Cbuf_ExecuteText` drops Raven's `text &&` test, because the stub parameter is a non-optional `String`.

## Open rows

1. `cmd_text` has no view, because Raven defines `cmd_t` inside `cmd_common.cpp`.
   The stub declares `cmd_text_buf` as a `let` array outside the world.
   No hand file in the codebase gives a `.c`-local struct a Swift form or a place in `EngineWorld`.
   `Cbuf_Init`, `Cbuf_AddText`, `Cbuf_InsertText`, and `Cbuf_Execute` wait for a ruling on the form of `cmd_t` and the home of `cmd_text`.
2. `Cmd_Exec_f` reads a file through the stub `FS_ReadFile(_:_: inout OpaquePointer?)`.
   No code in the codebase turns that buffer into the `String` that `Cbuf_InsertText` takes without a cast.
   The body waits for a ruling on the `FS_ReadFile` buffer form, or for the `files_pc` round to give one.

## Ledger of the open rows

1. The form of `cmd_t` and the home of `cmd_text`: ruled. A struct Raven defines inside a `.c` file has its definition copied as Raven wrote it, with a `// Source:` cite, into a hand header the target's umbrella includes, as `g_types.h` and `cg_types.h` do for the game and the cgame (`docs/transcription.md:83`, `docs/transcription.md:87`). Then `cmd_t` joins `HOST_ROOTS` as `"cmd_t": ("Cmd", "CJKAMP_Ded")`. A file-scope record Raven leaves zero is one zeroed allocation on the storage class, so `cmd_text` lives on `EngineStorage` and the stub forwards `var cmd_text: Cmd { world.storage.cmd_text }` (`docs/transcription.md:447`). A file-scope character array is a `CharBuf` of Raven's bound, so `cmd_text_buf` is a `CharBuf(MAX_CMD_BUFFER)` on the same storage (`docs/transcription.md:461`). Change: the hand header and the table row in the table batch, a generator run, then the four `Cbuf_*` bodies.
2. The `FS_ReadFile` buffer in `Cmd_Exec_f`: ruled to wait. The signature of `FS_ReadFile` belongs to the `files_pc` round and comes from the table, because a transcriptor keeps a signature as generated (`docs/transcription.md:73`, `docs/porting-rules.md:35`). Change: a `FS_ReadFile` row in the table batch, then the body of `Cmd_Exec_f`.
