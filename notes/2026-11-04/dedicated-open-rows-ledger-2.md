# The open rows of the dedicated host, the second ledger of 2026-11-04

This record holds the second batch of open rows of the dedicated host. The user ruled rows 1 to 9 by delegation on 2026-11-04. The landing is the branch `dedicated-rulings-batch-2`, off master at `a016c62`, in the worktree `/tmp/jka-ded-rules-2`. The generator sequence of `tools/oracle-closure/README.md` ran once over the whole batch: the extracts of the nine merge modules, merge, tables, check, the reexport of `JKAShared` and `JKAMP_Ded`, views, skeleton, and manifest for the three units, and traps and channel for the game and the cgame. The round bodies stay as they were, except where a row says "and fill".

## Row 1, byte and record copies over Slots

Question: Com_Memcpy takes `OpaquePointer?`, so a copy between a `Slots`, a `CharBuf`, and a local array has no form. What form does a copy take?

Sites: `oracle/codemp/qcommon/cmd_common.cpp:78`, `:107`, `:182`, and the memmove at `:195`. The copies of `nump` points in `oracle/codemp/qcommon/cm_polylib.cpp:92`, `:256`, `:644`, `:703`, and `:710`. The two Com_Memcpy of `oracle/codemp/qcommon/huffman.cpp` in Huff_Compress and Huff_Decompress, and `fout` of Huff_transmit at `huffman.cpp:285`.

Verdict: ratified as proposed, delegated, 2026-11-04. `Sources/JKAShared/CString.swift` holds four overloads, each with a rule 24 line: `Com_Memcpy(_ dest: Slots<T>, _ src: Slots<T>, _ count: Int32)`, `Com_Memcpy(_ dest: Slots<byte>, _ src: CharBuf, _ count: Int32)`, `Com_Memcpy(_ dest: inout CharBuf, _ src: Slots<byte>, _ count: Int32)`, and `memmove(_ dest: Slots<byte>, _ src: Slots<byte>, _ count: Int32)`. The count is in bytes, as Raven's is. `suffix(from:)` of `Sources/JKAShared/Views/Slots.swift` gives a `Slots` over the tail, so a body writes `mbuf.data!.suffix(from: Int(offset))`. The PARAMS kind `bytes` gives `fout` of Huff_transmit the spelling `Slots<JKAShared.byte>`, so `seq` passes as it is.

Deviations: the `CharBuf` destination is `inout`, because a `CharBuf` is a value and a copy into it must reach the caller. The hand body of Huff_transmit hands `fout.base` to the raw `fout` of add_bit and send under two rule 24 lines, because those two keep the PARAMS kind `raw` for the `msg->data` callers of msg.cpp. The field `data` of msg_t is still `OpaquePointer?` on the view, so `mbuf.data!.suffix(from:)` needs a FIELDS row of kind `bytes` for `msg_t.data`. That row reaches every `UnsafeMutableRawPointer(msg.data!)` site of msg.swift and net_chan.swift, so it waits for a ruling.

Files: `Sources/JKAShared/CString.swift`, `Sources/JKAShared/Views/Slots.swift`, `tools/oracle-closure/rulings.py`, `tools/oracle-closure/spelling.py`, `Sources/JKAMP_DedLogic/huffman.swift`, and `Tests/JKASharedTests/SlotsTests.swift`.

## Row 2, the address of one Slots element as a slot

Question: the new-slot branch of get_ppnode at `oracle/codemp/qcommon/huffman.cpp:48-57` returns `&huff->nodePtrs[huff->blocPtrs++]`. What gives a `Slots<Node?>` of count 1 over one element?

Verdict: ratified as proposed, delegated, 2026-11-04. `slot(at:)` of `Sources/JKAShared/Views/Slots.swift` returns a `Slots` of count 1 over element `i`, with a rule 24 line, and it takes any C integer. It is generic over the element, so `Node?` takes it with no extra form.

Files: `Sources/JKAShared/Views/Slots.swift` and `Tests/JKASharedTests/SlotsTests.swift`.

## Row 3, the UINT4 arrays of md4.cpp

Question: MD4Transform writes its `UINT4 state[4]` parameter at `oracle/codemp/qcommon/md4.cpp:172`, and Encode and Decode index a `UINT4 *` at `md4.cpp:243` and `:257`. What spelling do they take?

Verdict: ratified as proposed, delegated, 2026-11-04. In a host function, a fixed scalar array parameter that the store sweep sees written is a `Slots` of the scalar, and a scalar pointer parameter that the subscript sweep sees indexed is a `Slots` of the scalar. The subscript sweep of `table.py` reads a scalar pointer parameter only for a host, so a game stub keeps the `inout` scalar. The TYPES spelling stays behind the pointer, so `UINT4` is `UInt32`. The drafter passes a scalar array field of a TYPES typedef to such a parameter as it stands, `MD4Transform(context.state, context.buffer)`.

Reach beyond md4: `CM_ComparePoints` (`a` and `b`) and `CM_CheckFacetPlane` (`plane`) of cm_patch.cpp, `SV_GameSystemCalls` (`args`) of sv_game.cpp, `VM_LogSyscalls` (`args`) of vm.cpp, and `CPUID` (`regs`) of win_shared.cpp. The five CPUID callers in win_shared.cpp hand a local `unsigned regs[4]`, so their drafts hold five new holes. The local `UINT4 x[16]` of MD4Transform goes to Decode, and it needs a BYTE_STORAGE_LOCALS row for a home.

Files: `tools/oracle-closure/spelling.py`, `tools/oracle-closure/table.py`, `tools/oracle-closure/draft_calls.py`, `Sources/JKAMP_DedLogic/md4.swift`, `Sources/JKAMP_DedLogic/win_shared.swift`, `Sources/JKAMP_DedLogic/cm_patch.swift`, `Sources/JKAMP_DedLogic/sv_game.swift`, and `Sources/JKAMP_DedLogic/vm.swift`.

## Row 4, the byte views of Com_BlockChecksum

Question: Com_BlockChecksum and Com_BlockChecksumKey at `oracle/codemp/qcommon/md4.cpp:267` and `:282` hand a `const void *buffer`, the local `int digest[4]`, and `&key` to MD4Update and MD4Final as bytes. What forms do they take?

Verdict: ratified as proposed, delegated, 2026-11-04. The PARAMS kind `bytes` gives each `buffer` the spelling `Slots<JKAShared.byte>`. `bytes` of `Sources/JKAShared/Views/Slots.swift` gives a `Slots<byte>` over the memory of any `Slots`, with a rule 24 line. BYTE_STORAGE_LOCALS names `digest` for both functions, a `Slots<Int32>` of 4 on EngineStorage, and `key` for Com_BlockChecksumKey, a `Slots<Int32>` of one slot. The storage of a parameter takes the function name as a suffix, `key_Com_BlockChecksumKey`, because the parameter keeps Raven's name. The skeleton writes both forwards, each with a rule 24 line.

Finding: the drafter still declares `digest` as a local array and keeps the `(unsigned char *)` casts as holes, so the md4 round fills those lines by hand.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/skeleton.py`, `tools/oracle-closure/spelling.py`, `Sources/JKAShared/Views/Slots.swift`, `Sources/JKAMP_Ded/Generated/Storage/EngineStorage.swift`, and `Sources/JKAMP_DedLogic/md4.swift`.

## Row 5, the NULL test of Cvar_Register

Question: the host signature of Cvar_Register at `oracle/codemp/qcommon/cvar.cpp:889` took a non-optional VmCvar, so Raven's `if ( !vmCvar ) return` at `:893` had no form.

Verdict: ratified as proposed, delegated, 2026-11-04, and filled. A NULLABLE row makes the parameter `VmCvar?`, the form of the game and cgame trap. The body reads `guard let vmCvar else { return }` at Raven's test.

Files: `tools/oracle-closure/rulings.py` and `Sources/JKAMP_DedLogic/cvar.swift`.

## Row 6, the NULL test of FS_ReadFile and FS_FreeFile

Question: Cmd_Exec_f at `oracle/codemp/qcommon/cmd_common.cpp:231-240` tests `if (!f)` after FS_ReadFile and calls `FS_FreeFile (f)`. The `inout CharBuf` form gives no NULL, and FS_FreeFile takes an `OpaquePointer?`.

Verdict: ratified as proposed, delegated, 2026-11-04. The `inout CharBuf` forward of FS_ReadFile returns Raven's length and leaves the buffer empty for a missing file, so the test reads `len < 0`. FS_FreeFile has a `CharBuf` overload that frees nothing, under a Port-note and a rule 24 line, because a `CharBuf` owns its bytes. Cmd_Exec_f keeps its body for the round.

Files: `Sources/JKAMP_DedLogic/files_pc.swift`.

## Row 7, FS_Read into a CharBuf

Question: MSG_CheckNETFPSFOverrides hands `char overrideFile[4096]` to FS_Read at `oracle/codemp/qcommon/msg.cpp:2070`, and FS_Read takes `OpaquePointer?` alone.

Verdict: ratified as proposed, delegated, 2026-11-04. An `inout CharBuf` overload stands after the `OpaquePointer?` form in files_pc.swift, the form of `trap_FS_Read` at `Sources/JKAMP_Game/Generated/g_syscalls.swift:137`, with a marker body and a rule 24 line. The draft of FS_Seek now reads `return FS_Read(&foo, offset, f)`.

Deviation: the marker body carries one Port-note line. `functions()` of `draftcheck.py` keys a hand function by its Raven line and keeps the last one, so a bare marker after the original took the draft of the original and gave a redeclaration. The Port-note makes the overload a hand function that the gate keeps. The original stays first, because the drafter's registry reads the first signature of a name.

Files: `Sources/JKAMP_DedLogic/files_pc.swift`.

## Row 8, the type of memtag_t

Question: `Sources/JKAShared/Generated/q_shared.swift` gave `memtag_t` as `CChar`, and the `TAG_` names are `Int32`.

Proof: Raven declares `typedef char memtag_t` at `oracle/codemp/game/q_shared.h:3107` after the anonymous enum of the `TAG_` names, and the SP tree does the same at `oracle/code/game/q_shared.h:2688`. No view field has the type.

Verdict: ratified as proposed, delegated, 2026-11-04, and filled. `ENUM_TYPEDEFS` of `rulings.py` names `memtag_t`, and `reexport.py` writes it as `public typealias memtag_t = Int32` under a rule 24 line. The Z_Malloc site of msg.swift reads `Z_Malloc(Int32(BitStorage.byteCount), TAG_GENERAL, true)` as Raven wrote it, and its Port-note is gone. The C header keeps Raven's `char`.

Files: `tools/oracle-closure/rulings.py`, `tools/oracle-closure/reexport.py`, `Sources/JKAShared/Generated/q_shared.swift`, and `Sources/JKAMP_DedLogic/msg.swift`.

## Row 9, the C++ default arguments

Question: row 2 of the first batch copied a `bool` default alone. Does every C++ default of a host function stay?

Verdict: ratified as proposed, delegated, 2026-11-04. `cxx_default` of `skeleton.py` replaces `bool_default`. It reads the default from the definition or the first declaration, resolves a macro to the name the parse gives, and spells it for the Swift parameter: `false` or `true` for a `bool` or a `qboolean`, a number as Raven wrote it, `nil` for a NULL into an optional, and an enumerator by name. A default that the spelling cannot hold gives no default.

Signatures that gain a default: `Z_Malloc` (`bZeroit = false`, `iUnusedAlign = 4`), `MSG_WriteDeltaPlayerstate` and `MSG_ReadDeltaPlayerstate` (`isVehiclePS = false`), and `SE_LoadLanguage` (`bLoadDebug = true`, from `SE_TRUE`). `GetToken` and `Sys_Milliseconds` keep theirs. `CM_ClipHandleToModel`, `SE_LoadFileData`, and `Com_ParseTextFile` carry a signature marker, so their defaults wait for those rows.

Files: `tools/oracle-closure/skeleton.py`, `Sources/JKAMP_DedLogic/z_memman_pc.swift`, `Sources/JKAMP_DedLogic/stringed_ingame.swift`, and `Sources/JKAMP_DedLogic/msg.swift`.

## The gate

- The game snapshot check read 372 files and found no difference, exit 0.
- The cgame snapshot check read 246 files and found no difference, exit 0.
- The host snapshot check read 165 files and found 33 differing files, exit 1, all at the sites of the rows: the bodies, the manifest, and the skeleton text of cm_patch, cvar, huffman, md4, msg, stringed_ingame, sv_game, vm, win_shared, and z_memman_pc, the bodies of cmd_common, and the bodies and the manifest of files_pc.
- `swift build` passed, exit 0.
- `swift test --no-parallel` passed 138 tests with no failure, exit 0.
- The tool tests passed 97 tests with 14 skipped, exit 0.
- `draftcheck.py --unit mp-engine-ded` over huffman, md4, cmd_common, msg, cm_polylib, cvar, and files_pc gave 558 holes, 0 cascade errors, 0 defects, and 82 compile holes over 2 passes, exit 0. The compile holes are 81 in files_pc and 1 in cvar, and none stands at a site of the rows.

A fresh extract of sp-ui on a case-insensitive file system writes `uiimport_t.h` beside the committed `uiImport_t.h`, and the merge then moves the SP UI header. The landing kept master's `Sources/CJKASP_UI`, because the move is outside every row.

## Findings for a later row

- `msg_t.data` needs a FIELDS row of kind `bytes` before a body can write `mbuf.data!.suffix(from:)`, and the row reaches the raw sites of msg.swift and net_chan.swift.
- The drafter does not read BYTE_STORAGE_LOCALS, `bytes`, or a cast to `unsigned char *` of a `Slots` parameter, so the md4 and huffman rounds fill those lines by hand.
- The local `UINT4 x[16]` of MD4Transform and the local `unsigned regs[4]` of the CPUID callers have no storage home for a `Slots` parameter.
- The Port-notes of md4.swift and of AllocWinding in cm_polylib.swift still name the old signatures, and the readoption of each round replaces them.
