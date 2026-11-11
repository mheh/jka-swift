# The body round of set R3

This record holds the body round of set R3 of section 4 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-r3` in the worktree `/tmp/jka-r3`, from `f60a012e`. The bodies are commit `8582f669`. All touched files were adopted already, so no skeleton header was removed.

## The counts

| Part | Functions | Bodies | Landed earlier | Left |
| --- | --- | --- | --- | --- |
| be_aas_main | 5 | 5 | 0 | 0 |
| be_interface, BotReplaceSynonyms thunk | 1 | 0 | 1 | 0 |
| l_precomp | 2 | 2 | 0 | 0 |
| sv_game, G_G2_LISTBONES and G_G2_LISTSURFACES | 2 | 0 | 2 | 0 |
| CROFFSystem, ApplyROFF, ProcessNote, and ClearLerp arms | 3 | 2 | 1 | 0 |
| G2_misc | 3 | 3 | 0 | 0 |
| Total | 16 | 12 | 4 | 0 |

The four that landed earlier held no `portMissing` call and no `// TODO: Port` marker in the worktree: the BotReplaceSynonyms thunk, the two G2 LIST arms, and the ProcessNote game arm with `withTextWord`.

## The functions

- AAS_StringFromIndex, AAS_IndexFromString, AAS_ModelFromIndex, AAS_IndexFromModel, AAS_UpdateStringIndexes: rows G22 and N-STRSLOTS. The tables are `Slots<String?>`, a NULL slot is `== nil`, and the two callers pass `aasworld.configstrings.suffix(from: CS_MODELS)`. The index name is a local `CharBuf`, the form of `be_interface.swift`. AAS_UpdateStringIndexes keeps the GetMemory call for the memory count, the form of `be_aas_bspq3.swift`.
- PC_AddBuiltinDefines: row N-LOCALTABLE. A local array of labeled tuples, no end row, and a walk to the count. The define takes the form of PC_Directive_define.
- PC_SetIncludePath: row G20, `PATHSEPERATOR_STR` of `FileBackend.swift`, through `includepathBuffer`.
- ApplyROFF and ClearLerp, client arms: row N-ROFFCLIENT, `return false` under a rule 19 Port-note of two lines.
- G2_GetGoreRecord: row N-GORE, the hand signature `(_ tag: Int32) -> GoreTextureCoordinates?` and one AI line.
- G2_SaveGhoul2Models and G2_LoadGhoul2Model: row N-G2SAVE. The buffer is a `Slots<byte>` from `Z_Malloc(size, TAG_GHOUL2, true)`. Each member goes at its offset of the 32-bit build: the band of 116 bytes, the surface record of 24, the bone record of 744 (the offsets of `bone_info_t.rs` ILP32), and the bolt record of 16. The matrices copy as 48 bytes with `Com_Memcpy`. The save writes the four basepose words as zero, and the load stores nil in the four views. The zeroed block keeps the padding at 658 and 685 zero, under a Port-note.
- G2_FreeSaveBuffer and the three G2API wrappers in `G2_API.swift`: the hand signatures of row N-G2SAVE. The two free functions call `Z_Free(OpaquePointer(buffer.base))`, the form of `FS_FreeFile`, and the empty G2B6 bodies are gone.

## The AI lines

- The local builtin table of PC_AddBuiltinDefines, and the name bytes after the define record.
- The GetMemory call of AAS_UpdateStringIndexes.
- The `void *` return of G2_GetGoreRecord.
- In G2_misc: the three block size constants, the band size, the `char **` and `char *` buffer parameters, each memcpy of a band or a record, and the basepose words.

## The rule 19 notes

- PC_SetIncludePath: with an empty path, Raven reads the byte before `includepath`. The Swift index traps there.
- ApplyROFF and ClearLerp: Raven writes through uninitialized trajectory pointers in the client arm. The arm returns false.

## The checks

- `swift build -j 2`: exit 0, no new warning in the touched files.
- `swift test --no-parallel -j 2`: 162 tests, all pass.
