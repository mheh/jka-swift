# The W4 body round of the dead-function wave

This record holds set W4 of section 4 of `notes/2026-11-10/docket-13.md`, on the branch `ded-bodies-w4` in the worktree `/tmp/jka-w4`, made from master `e820175b`. One agent wrote the six bodies and ran the checks. The five files were adopted already.

## The functions

| Function | Raven | Swift | Status |
| --- | --- | --- | --- |
| AllocRS | `renderer/tr_ghoul2.cpp:869` | `tr_ghoul2.swift` | landed |
| MC_Compress | `renderer/matcomp.c:50` | `matcomp.swift` | landed |
| MC_UnCompress | `renderer/matcomp.c:163` | `matcomp.swift` | landed |
| R_LerpTag | `renderer/tr_model.cpp:1768` | `tr_model.swift` | landed |
| LoadTGA | `renderer/tr_image.cpp:1421` | `tr_image.swift` | landed |
| GetRefAPI | `renderer/tr_init.cpp:1459` | `tr_init.swift` | landed |

No stub of the set stays open.

## The forms the bodies use

- AllocRS reads the ring `RSStorage` and the index `NextRS` through their forwards (row G17). The `%=` takes `UInt32(MAX_RENDER_SURFACES)`, the conversion C makes for an `unsigned int` operand.
- MC_Compress holds `comp` as a CharBuf of `MC_COMP_BYTES*2` bytes, and each `*(unsigned int *)(comp+pos) |=` is `comp.withMutableSlots { $0[int: pos] |= ... }`, the `CNode.Save` form that ledger 14 names for the `comp` key of G6. One AI line states the change. The copy into `_comp` is the `Com_Memcpy(Slots<byte>, CharBuf, count)` overload.
- MC_UnCompress reads each `((unsigned short *)comp)[n]` as `comp[ushort: n * 2]`, the form of MC_UnCompressQuat, under one AI line.
- matcomp: the macros of `matcomp.h:9` to `:20` (MC_BITS_X, MC_BITS_Y, MC_BITS_Z, MC_BITS_VECT, MC_SCALE_X, MC_SCALE_Y, MC_SCALE_Z, MC_COMP_BYTES) had no Swift declaration. They are file-scope `let`s in `matcomp.swift` with their `Source:` lines, the form of the header constants of `CRMMission.swift:7` to `:17`. The macros of `matcomp.c` stay expanded at the site, as the generated notes of the file say.
- R_LerpTag writes `tag.origin` and the Slots `tag.axis` of the Orientation view. VectorClear is `= vec3_t()` (transcription.md:290), and the function returns 0 and 1, because Raven returns `int`.
- LoadTGA reads the file with `FS_ReadFile` into an `OpaquePointer?` and views it with `ZipBackend.bytes(..., count: iLen + 1)`, the form of RE_RegisterModels_GetDiskFile. The header is `TGAHeader(buffer.base)`, the form of `MdxmHeader(buffer.base)`. `pIn` and `pOut` are byte offsets into the Slots of the file and of the zone block, the form of R_InvertImage. The `goto TGADone` of TGA_FORMAT_ERROR is a labeled `do` block, and `goto breakOut` is a labeled break of the `x` loop, under rule 10. The `sprintf` of the macro is `Com_sprintf` with the size of `sErrorString`, under one AI line, the form of `GameInterface.swift:271`. Raven's `if (width)` and `if (height)` tests drop under one AI line, because the parameters are inout. Swift puts the `default` arm of the scan-line switch last, and it holds Raven's `case 0x00` arm.
- GetRefAPI takes the DEDICATED arm: it clears the static `re` through its forward `re_GetRefAPI` (row G16), checks REF_API_VERSION, and stores the one thunk `RefexportThunks.RE_Shutdown`. The precedent is GetBotLibAPI, `be_interface.swift:466`.

## The corrected notes

- AllocRS: the note now names the call at `tr_ghoul2.cpp:2660` inside RenderSurfaces under the `#ifndef DEDICATED` of `:2520`.
- R_LerpTag: GetRefAPI stores it only in its `#ifndef DEDICATED` arm at `tr_init.cpp:1488`. The old note said that GetRefAPI stores it, but the dedicated arm of GetRefAPI stores only Shutdown, so the arm is the reason.
- GetRefAPI: the note names the caller `cl_main.cpp:2483`.

## The checks

- `swift build -j 2`: exit 0 on the first run, so no fix round was necessary. The five files give no new warning.
- `swift test --no-parallel -j 2`: exit 0, 162 tests in 9 runs pass.
