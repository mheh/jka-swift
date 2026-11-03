# Dedicated round: cvar

This record covers the first hole round on the dedicated host stem `cvar`. The source is Raven's `oracle/codemp/qcommon/cvar.cpp`, and the stub is `Sources/JKAMP_DedLogic/cvar.swift`. The branch is `dedicated-round-cvar` off `dedicated-stage-3-landing`.

## What landed

The commit of the first hand edit adopts the stub and removes the skeleton header. It transcribes 29 bodies: generateHashValue, Cvar_ValidateString, Cvar_FindVar, Cvar_VariableValue, Cvar_VariableIntegerValue, Cvar_VariableString, Cvar_VariableStringBuffer, Cvar_CommandCompletion, Cvar_Get, Cvar_Set2, Cvar_Set, Cvar_SetLatched, Cvar_SetValue, Cvar_Reset, Cvar_SetCheatState, Cvar_Command, Cvar_Toggle_f, Cvar_Set_f, Cvar_SetU_f, Cvar_SetS_f, Cvar_SetA_f, Cvar_Reset_f, Cvar_WriteVariables, Cvar_List_f, Cvar_Restart_f, Cvar_InfoString, Cvar_InfoString_Big, Cvar_InfoStringBuffer, and Cvar_Init.

Five holes stay open: Cvar_FreeString, Cvar_Realloc, Cvar_Defrag, Cvar_Register, and Cvar_Update. The open rows below give the reason for each.

The bodies call the stub signatures of `cmd_common`, `common`, `files_common`, and `z_memman_pc` as they stand. This round transcribes none of those.

## Counts

- Bodies transcribed: 29
- Holes left open: 5
- `// AI:` lines: 12
- `Port-note:` lines: 1
- Build: failed in `Sources/CJKAMP_Ded/CJKAMP_Ded.c` with the 12 known C errors only (11 redefinitions of the `TK_*` enumerators in `enum_TK_EOF.h`, and one "expected identifier" in `sysEventType_t.h`). The Swift target did not compile, so the build did not check `cvar.swift`. The round stopped there, and `swift test --no-parallel` did not run.

## Ledger

| Row | Site | Ruling | Precedent |
| --- | --- | --- | --- |
| C1 | every `Cvar_FreeString` call in Cvar_Get, Cvar_Set2, Cvar_SetCheatState, Cvar_Restart_f | The call goes, with one `// AI:` line. The `Cvar` view pools every string through `StringPool`, so a string has no block to free. | `g_mem.swift:32` and `cg_main.swift:3063`, a block that is never freed |
| C2 | Cvar_Restart_f `cvar_t **prev` | The body holds the previous cvar, and nil stands for the head `cvar_vars`. One `// AI:` line. | no pointer-to-pointer view exists, the walk is the plain linked-list form |
| C3 | Cvar_Restart_f `Com_Memset(var, 0, sizeof(var))` | Faithful. The size is the size of a pointer, as Raven wrote it, so the clear covers the first field only. | do not adulterate Raven |
| C4 | Cvar_InfoString and Cvar_InfoString_Big `static char info[]` | A local `CharBuf` and a returned `String`. One `// AI:` line each. | `cg_drawtools.swift:423`, a static to a local |
| C5 | Cvar_Command `sprintf(buff, "%i", !v->value)` | `Com_sprintf` with the size of `buff`. One `// AI:` line. | no `sprintf` in the Swift tree |
| C6 | Cvar_Set_f `strlen(Cmd_Argv(i) + 1)` | Faithful, the length less one. A `Port-note:` gives the empty-argument case. | rule 19 |
| C7 | Cvar_Get null check `!var_name \|\| !var_value` | The check goes, because the stub parameters are non-optional `String`. No comment. | the table signature |
| C8 | Cvar_SetValue `value == (int)value` | `Float(Int32(value))`. Swift traps when the value is out of the `Int32` range, where C is undefined. | none recorded |

## Open rows

1. Cvar_FreeString. The stub takes `inout CharBuf`, but every caller holds a pooled `String`. Its body compares a pointer against `lastMemPool`, and the stub types `lastMemPool` as a `String`. No Swift form compares a pooled string against a pool range. Ruling C1 drops the calls, so the function has no caller. The user decides between a removal with an `// AI:` line and a new signature.
2. Cvar_Realloc and Cvar_Defrag. The stub of Cvar_Realloc has no signature (no table row for `int & memPoolUsed`). Cvar_Defrag copies every string into one `Z_Malloc` block, and the stub of `Z_Malloc` also has no signature. Under `StringPool`, a defrag has no effect. The user decides whether the body becomes a no-op with an `// AI:` line, or waits for a pool-pointer view.
3. Cvar_Register and Cvar_Update. The stubs have no signature, because the table has no row for `vmCvar_t *`. A table row comes first, then a generator run, then the bodies.
4. Ruling C8 holds no precedent in the codebase. The user confirms the `Int32(value)` trap or names a form.

## Undone

The build did not reach the Swift targets, so the bodies are not compile-checked. The next compile run after the C fix lands can show Swift errors in `cvar.swift`. The likely sites are the `Com_Filter` call with the literal `0`, the `hashTable[hash] = v` store, and the `CLong` arithmetic in generateHashValue.

## Ledger of the open rows

1. `Cvar_FreeString` with no caller: ruled. Ruling C1 removes every call, so the stub stays as generated with its `TODO: Port` marker and one line that says the pool ruling C1 removed its callers. Precedent: the dead-surface form of rule 20 (`docs/porting-rules.md:45`), and the pooled block that is never freed (`g_mem.swift:32`). Change: the one-line note at the stub.
2. `Cvar_Realloc` and `Cvar_Defrag` as no-ops: open for the user. A callable no-op is a ruling of the user's (`docs/porting-rules.md:34`), and no game or cgame site gives a pool defrag a Swift form.
3. `Cvar_Register` and `Cvar_Update`: ruled to the table. `vmCvar_t` joins `HOST_ROOTS` as `"vmCvar_t": ("VmCvar", "CJKAMP")`, the row `GAME_ROOTS` and `CGAME_ROOTS` hold (`tools/oracle-closure/rulings.py:36`, `tools/oracle-closure/rulings.py:104`). Change: the table row, a generator run, then the two bodies.
4. The float-to-`Int32` trap in `Cvar_SetValue` (ruling C8): ruled. The game spells Raven's `(int)` of a float as `Float(Int32(...))` (`Sources/JKAMP_GameLogic/NPC_AI_Interrogator.swift:384`). An out-of-range value is undefined in C, so the Swift trap is a rule 19 divergence (`docs/porting-rules.md:44`). Change: one `Port-note:` line at the site that says C is undefined past the `Int32` range.
