# The W3 body round of the dead-function wave

This record holds the body round of set W3 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-w3` in the worktree `/tmp/jka-w3`. The set is 11 functions in seven files under `Sources/JKAMP_DedLogic`. Every file was adopted already, so no skeleton header was removed. The set follows the rows G5, G7, G11, and G12 and the hand items H-RMG, H-FPRINTF, and H-E2 of `notes/2026-11-10/dedicated-open-rows-ledger-14.md`.

## The counts

| File | Set | Landed | Open |
| --- | --- | --- | --- |
| CRMMission | 2 | 2 | 0 |
| CRMManager | 1 | 1 | 0 |
| CRandomTerrain | 1 | 1 | 0 |
| l_crc | 1 | 1 | 0 |
| l_struct | 4 | 4 | 0 |
| l_log | 1 | 1 | 0 |
| cvar | 1 | 1 | 0 |
| Total | 11 | 11 | 0 |

`swift build -j 2` is clean, with no new warning in the seven files. `swift test --no-parallel -j 2` passes 162 tests, the count of the base.

## The functions

- CRMMission::ParseRandom (`RMG/RM_Mission.cpp:1189`): landed. The local `groups[MAX_RANDOM_CHOICES]` is an Array of the optional class, with MAX_RANDOM_CHOICES of H-RMG. Raven writes past the array when the weights add up to more than 100, so the site has a rule 19 Port-note. The `for` loop with a `continue` advances the group before the `continue`.
- CRMMission::ParseOrigin (`:163`): landed on the hand signature of row G12. The two `if ( flattenHeight )` tests drop, each under an AI line, because an inout Int32 is never NULL. `GetPath` returns `float`, so the `int pathID` store takes `Int32(...)` with a C conversion line.
- CRMManager::ProcessAutomapSymbols (`RMG/RM_Manager.cpp:442`): landed. Raven's whole body stands under `#ifndef DEDICATED`, so the dedicated body is empty, the form of R_AddGhoulSurfaces in `tr_ghoul2.swift`.
- CRandomTerrain::Generate (`qcommon/cm_randomterrain.cpp:770`): landed with the noise code of H-RMG. The `#if 0` locals `t2` and `t3` drop by the `#ifdef` rule, and the comment block stays. The memset is Com_Memset over the Slots of `mGrid` under an AI line. The path loop reads `mPaths[MAX_RANDOM_PATHS]` past the array when every path is set, so the site has a rule 19 Port-note.
- CRC_ContinueProcessString (`botlib/l_crc.cpp:126`): landed on the `Slots<byte>` of row G11. Raven's `char` is signed, so a byte of 128 or more gives a negative index into `crctable`, which is undefined. The port reads the byte unsigned, with a rule 19 Port-note.
- WriteIndent (`botlib/l_struct.cpp:313`), WriteFloat (`:327`), WriteStructWithIndent (`:355`), WriteStructure (`:441`): landed in the H-FPRINTF form. Each `fprintf` is `JKAShared.format` into a CharBuf and `FileBackend.fwrite`, and the test of a negative return reads the short count of the write, under one AI line per function. The `sprintf` of WriteFloat is `strcpy(&buf, JKAShared.format("%f", [value]))`, the form of transcription.md. WriteStructWithIndent reads the record through the RawField subscripts, as ReadStructure does, and the string field through `cString(at:)`. Raven passes `structure`, not `p`, to the nested call of FT_STRUCT, and the port keeps that.
- Log_WriteTimeStamped (`botlib/l_log.cpp:113`): landed. The hole is the first `fprintf`, with the `%02d` pad of H-E2. The AI line now names the three writes.
- Cvar_Realloc (`qcommon/cvar.cpp:965`): the batch of ledger 14 already put the not-ported marker in `cvar.swift` and removed the stub. One line of the old stub stayed, `// TODO: Port signature`, above the `Raven wrote:` line. This round removes it, so the marker has the form of Cvar_FreeString and of `skeleton.py:1440` to `:1443`.

## The open items

- `Cvar_Defrag` (`cvar.cpp:979`), outside the set, still holds a `// TODO: Port Cvar_Defrag` line above its hand no-op body and its AI line. No `portMissing` call stands there.
