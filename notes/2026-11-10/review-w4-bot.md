# Review W4: bodies of sets S2, S3, S8

Read-only review. Each Swift body was compared with Raven's function, line by line.

## Item 1: CBlockStream::Create

The verdict is DEFECT, a plain width defect in the new body. A rule 19 note is the wrong label.

- Swift: `/tmp/jka-s2/Sources/JKAMP_DedLogic/CBlockStream.swift:209`
  `_ = FileBackend.fwrite(id_header, at: 0, 1, Int32(UInt.byteCount), self.m_fileHandle)`
  The note at `:207`-`:208` says: "Port-note: Rule 19. On a 64-bit target the size passes the four bytes of `IBI_HEADER_ID`, and the fwrite precondition traps."
- Raven: `oracle/codemp/icarus/BlockStream.cpp:527` `char newName[MAX_FILENAME_LENGTH], *id_header = IBI_HEADER_ID;` and `:546` `fwrite( id_header, 1, sizeof(id_header), m_fileHandle );`. `IBI_HEADER_ID` is `"IBI"` (`icarus/blockstream.h:19`).
- Raven's build is WinDed, which is 32-bit, so `sizeof(char *)` is 4. The call writes exactly the 4 bytes `'I' 'B' 'I' '\0'`. That behavior is defined, so rule 19 does not apply. The port takes WinDed widths for `icarus`: `MSVC_WIDTH_FOLDERS = {"botlib", "icarus", "NPCNav"}` (`tools/oracle-closure/rulings.py:948`). It also takes WinDed widths for a byte count that leaves the module: `sizeofCBoneCache = 140`, "the byte count of the 32-bit build" (`Sources/JKAMP_DedLogic/tr_ghoul2.swift:294`).
- The `UInt.byteCount` precedents are not the same case. In `G2_API.swift:262`-`:268`, `:523`-`:529`, and `:603`-`:609` the value is an in-process allocation counter. In `be_aas_sample.swift:159`, `be_aas_reach.swift:4718`, and `files_pc.swift:1673` it sizes a host table of pointers. No byte crosses into a file at those sites. Here the bytes go to disk.
- The reader expects 4 bytes. Raven's `CBlockStream::Open` reads `char id_header[sizeof(IBI_HEADER_ID)]` (`BlockStream.cpp:667`), which is 4 bytes, then compares them with `strcmp` (`:684`). The Swift `Open` reads `CharBuf(strlen(IBI_HEADER_ID) + 1)` (`CBlockStream.swift:317`), which is also 4 bytes.
- What the Swift must write: 4 bytes, `strlen(IBI_HEADER_ID) + 1`. That is the size of `id_header` as a CharBuf, the same count that `Open` reads. The site needs a WinDed width line (an `// AI:` or C-width line of the `sizeofCBoneCache` kind) and no rule 19 note.
- Effect today: on every 64-bit target the call traps, because it asks for 8 bytes from a 4-byte buffer. Even without the precondition, the call would write a file that `Open` cannot read: the 4 extra bytes would move the version float.

## Item 2: AAS_NearestHideArea, the Com_Memset at :2081

The verdict is NOTE. When the area count does not change, the body does what Raven does. The note states Raven's defect truly, but it is incomplete.

- Swift: `/tmp/jka-s2/Sources/JKAMP_DedLogic/be_aas_route.swift:2335`-`:2337`
  `// Port-note: Rule 19. Raven zeroes `aasworld.numareas` entries of the allocation of the first call, and a larger count writes past its end.` and `hidetraveltimes!.zero()`
- Raven: `botlib/be_aas_route.cpp:2081` `Com_Memset(hidetraveltimes, 0, aasworld.numareas * sizeof(unsigned short int));`. The pointer is a `static` (`:2067`), allocated once at `:2077`, and no code frees it or reallocates it.
- Same count: `Slots.zero()` zeroes `count * stride` bytes (`Sources/JKAShared/Views/Slots.swift:42`). The count is the `numareas` of the first call, which is the count Raven zeroes. The behavior is the same.
- Smaller count: Raven zeroes only the first `numareas` entries, and the Swift zeroes all of them. Nothing reads an entry past `numareas`, so the result is the same.
- Larger count: Raven's memset writes past the heap block. That is undefined, so the rule 19 label is correct. The note leaves out one fact: in the Swift, the later reads and writes `hidetraveltimes![nextareanum]` at `:2444` and `:2451` trap on the Slots bounds precondition for an area number past the first count. Raven reads and writes past the block at `:2160` and `:2167`. The second sentence of the note ("an entry past `aasworld.numareas` is never read") is true for the smaller case only.

## Findings

### F1 DEFECT: CBlockStream::Create header width
This is Item 1. Swift `/tmp/jka-s2/Sources/JKAMP_DedLogic/CBlockStream.swift:209`. Raven `icarus/BlockStream.cpp:546`.

### F2 NOTE: AAS_NearestHideArea, the scope of the rule 19 note
This is Item 2. Swift `/tmp/jka-s2/Sources/JKAMP_DedLogic/be_aas_route.swift:2335`. Raven `botlib/be_aas_route.cpp:2081`.

### F3 NOTE: CRandomTerrain::Smooth copies border bytes that nothing wrote
- Swift `/tmp/jka-s8/Sources/JKAMP_DedLogic/CRandomTerrain.swift:134` `temp = Slots<JKAShared.byte>(scalars: Z_Malloc(self.mWidth * self.mHeight, TAG_RESAMPLE), ...)` and `:195` `Com_Memcpy(self.mGrid!, temp!, self.mWidth * self.mHeight)`.
- Raven `qcommon/cm_randomterrain.cpp:660` `temp = (byte *)Z_Malloc(mWidth * mHeight, TAG_RESAMPLE);` and `:713` `memcpy(mGrid, temp, mWidth * mHeight);`.
- The loops fill only `1..w-2` by `1..h-2`. The border bytes of `temp` are the indeterminate contents of a block that was not zeroed (`bZeroit` defaults to false, `z_memman_pc.swift:70`). Both copy those bytes into the border of `mGrid`. The port is faithful, but the site reads indeterminate memory and has no rule 19 note. The method is dead in the dedicated build.

### F4 NOTE: VM_SymbolForCompiledPointer widens a signed `int` to an address
- Swift `/tmp/jka-s2/Sources/JKAMP_DedLogic/vm.swift:230` `if UInt(truncatingIfNeeded: vm.instructionPointers![i]) > UInt(bitPattern: code) {`
- Raven `qcommon/vm.cpp:175` `if ( (void *)vm->instructionPointers[i] > code ) {`
- On 32-bit, an `int` of `0x80000000` or higher is the same address. On 64-bit, `truncatingIfNeeded` sign-extends the value to `0xFFFFFFFF8...`. Also, the interpreted VM fills `instructionPointers` with bytecode offsets, not addresses (`vm_interpreted.cpp:157`), so a compare with a code pointer has meaning only for a compiled VM, and the port has none. The function is dead. There is no behavior difference for a real caller.

## Checked and matched (no finding)

- S2: AAS_CreateAllRoutingCache, AAS_BridgeWalkable, DistancePointToLine, the AAS_NearestHideArea body (other than F2: the `t` sum truncates to `unsigned short`, and the `t += (dist1 - dist2) * 10` step goes through float to int to short, which is MSVC's float-to-short path), AAS_BoxOriginDistanceFromPlane (`BBOX_NORMAL_EPSILON` 0.001 is a double, and the compares widen correctly), AAS_AreaGroundFace, AAS_FacePlane, AAS_TraceEndFace, EA_Tell, EA_UseItem, EA_DropItem, EA_UseInv, EA_DropInv (the format strings match, including `"tell %d, %s"`), BotFindEntityForLevelItem, CBlockStream GetUnsignedInteger and GetLong (4 bytes, the WinDed `long`), the Create body other than F1 (the version float is 4 bytes, and the strip and extension steps match), VM_SymbolToValue, VM_SymbolForCompiledPointer (`CRAZY_SYMBOL_MAP` is defined at `vm_local.h:3`, so the call to VM_SetSymbolMap is correct), and the `hidetraveltimes` static on EngineWorld.
- S3, l_script: PS_ReadLiteral (each post-increment of the cursor is in place, and the `\'` loop and the terminator match), PS_ExpectTokenString, PS_CheckTokenString, PS_CheckTokenType (the cursor rewinds to `lastscript_p` on the script, and the token is copied through the caller's view), PS_SkipUntilString, PS_UnreadLastToken, PS_UnreadToken, PS_NextWhiteSpaceChar (the `defer` gives the post-increment), ReadSignedFloat, ReadSignedInt (the 32-bit unsigned product wraps), GetScriptFlags, ResetScript (the `// AI:` line about NULL as offset 0 is true, because NextWhiteSpaceChar compares the two fields only with each other), NumLinesCrossed, ScriptSkipTo.
- S3, be_ai_chat: BotDumpSynonymList (`%ld` truncates to Int32 in `Format.swift`, so `CONTEXT_ALL` prints as -1, as in C), BotDumpRandomStringList, BotDumpMatchTemplates, BotDumpReplyChat, BotDumpInitialChat, BotPrintReplyChatKeys. Each statement, its order, and each format string match. The `// AI:` lines about fprintf are true.
- S8: ParseNodes (`int = atof` truncates through `Int32(...)`), ParsePaths, ParseRivers, ParseDifficulty (`atol` is `atoi` for the 32-bit `long`, and the recursion and its order match), ParseWeapons, ParseAmmo, ParseOutfit (the live statements only, with the comment blocks kept), ParseObjectives, ParseInstances (`PRE_RELEASE_DEMO` is not defined), CRandomTerrain CreatePath, GetPathInfo, Smooth (the `unsigned` sum and the byte store by low bits are correct, and only the `#if 1` arm is written).

## Functions read
All 39 functions in scope: S2 19 plus the static, S3 20, S8 12.

## Functions not read
None in scope. Out of scope and not reviewed: the other files in the diff stat (VmEntry, CROFFSystem, G2_bones, GenericParser2, be_interface, sv_game, Format.swift), which come from the base branch merge. The callees (ParseRandom, ParseInstance, CPathInfo, AAS_InsideFace) were not read except where a finding needed them.
