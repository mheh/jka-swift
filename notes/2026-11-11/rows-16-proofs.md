# Rows of batch 16: proofs

Worktree: `/tmp/jka-int-16`, branch `dedicated-integration-16`, head `48fd2793`. A Swift or tool cite without a prefix is in that worktree. A Raven cite is under `oracle/codemp/` of the main tree. A jka-rust cite is under `jka-rust/crates/` of the main tree, at `1cb6c525`.

The generator signatures in this record come from the store of the dedicated unit, `tools/oracle-closure/out/mp-engine-ded/table.sqlite`, table `signatures`, written by the run of batch 15 (file time 2026-11-10 19:15).

## Item 1: the two SaveCommand sites

### 1a. Raven's lines and the callee, to the end

Both sites, word for word except the class name:

- `icarus/Sequence.cpp:350-351`: `//Save out the raw data` / `(m_owner->GetInterface())->I_WriteSaveData( 'BMEM', bm->GetData(), size );`
- `icarus/TaskManager.cpp:1650-1651`: the same two lines.
- The size before it: `Sequence.cpp:347` and `TaskManager.cpp:1647`, `size = bm->GetSize();`.

Both functions are dead. The one caller of each is compiled out:

- `Sequence.cpp:365`: `#if 0 //piss off, stupid function` (the first line of `CSequence::Save`).
- `TaskManager.cpp:1665`: `#if 0` (the first line of `CTaskManager::Save`).

The callee:

- `icarus/interface.h:65`: `int (*I_WriteSaveData)( unsigned long chid, void *data, int length );`
- `icarus/Q3_Interface.cpp:1006`: `pe->I_WriteSaveData = AppendToSaveGame;` inside `void Interface_Init( interface_export_t *pe )` at `:956`.
- `icarus/GameInterface.cpp:146`: `Interface_Init( &interface_export );`
- `icarus/Q3_Interface.cpp:694-698`:
  ```
  //These are useless for MP. Just taking it for now since I don't want to remove all calls to this in ICARUS.
  int AppendToSaveGame(unsigned long chid, void *data, int length)
  {
  	return 1;
  }
  ```
- The other `Interface_Init` is commented out: `icarus/Interface.cpp:14` opens `/*`, `:24` closes it, and the function at `:15-22` is inside.
- The dedicated build compiles `Q3_Interface.cpp`: `WinDed.vcproj:769` `RelativePath=".\icarus\q3_interface.cpp"`, and `unix/makefile:285` `$(B)/ded/Q3_Interface.o \`.

Result: the MP dedicated callee reads neither `data` nor `length`. It keeps no counter, writes no chunk header, and prints nothing. It returns 1, and both sites discard the value.

### 1b. Can a held member have NULL data with size 0? No.

Every path that sets `m_data` in Raven (`icarus/BlockStream.cpp`, `icarus/blockstream.h`):

| Path | Line | What it does |
| --- | --- | --- |
| constructor | `BlockStream.cpp:26-30` | `m_size = -1;` `m_data = NULL;`. Size is -1, not 0. |
| `Free` | `BlockStream.cpp:44-53` | `m_data = NULL;` then `m_id = m_size = -1;`. Size is -1. The one caller is the destructor, `:35` `Free();`. No other `CBlockMember::Free` call exists. |
| `SetData(const char *)` | `BlockStream.cpp:74-77` | `WriteDataPointer( data, strlen(data)+1 );`, so the size is at least 1. |
| `SetData(vector_t)` | `BlockStream.cpp:79-82` | `WriteDataPointer( data, 3 );`, 12 bytes. |
| `SetData(void *, int)` | `BlockStream.cpp:84-92` | `m_data = ICARUS_Malloc( size );` |
| `ReadMember` | `BlockStream.cpp:102-128` | `m_data = ICARUS_Malloc( m_size );` on both arms, `:111` and `:119`. |
| `WriteData<T>` | `blockstream.h:76-86` | `m_data = ICARUS_Malloc( sizeof(T) );` |
| `WriteDataPointer<T>` | `blockstream.h:88-98` | `m_data = ICARUS_Malloc( num*sizeof(T) );` |
| `Duplicate` | `BlockStream.cpp:148-159` | `newblock->SetData( m_data, m_size );`, so it goes through `SetData(void *, int)`. |

`ICARUS_Malloc` never returns NULL, also for size 0:

- `icarus/Memory.cpp:8-13`: `return Z_Malloc(iSize, TAG_ICARUS5, qfalse);`
- `qcommon/z_memman_pc.cpp:161-165`:
  ```
  if (iSize == 0)
  {
  	zoneHeader_t *pMemory = (zoneHeader_t *) &gZeroMalloc;
  	return &pMemory[1];
  }
  ```
- `gZeroMalloc` is a static, `z_memman_pc.cpp:139`: `StaticZeroMem_t gZeroMalloc =`. The dedicated build compiles this file: `WinDed.vcproj:294`, `unix/makefile:225`.
- A non-zero size loops `while (pMemory == NULL)` from `:174` until malloc succeeds or the function drops with an error.

Every member that a block holds comes from one of these paths, then `AddMember`:

- `CBlock::Write` overloads, `BlockStream.cpp:244-295`: `new CBlockMember`, then `SetData` or `WriteData`, then `AddMember( bMember )`.
- `CBlock::Duplicate`, `BlockStream.cpp:374`: `newblock->AddMember( (*mi)->Duplicate() );`
- `CBlockStream::ReadBlock`, `BlockStream.cpp:647-649`: `bMember = new CBlockMember;` `bMember->ReadMember( &m_stream, &m_streamPos );` `get->AddMember( bMember );`
- `CBlock::Write( CBlockMember *bMember )`, `BlockStream.cpp:300-306`, takes a member from outside. No file of `icarus/` calls it: `grep "Write( *[a-zA-Z_]* *)" icarus/*.cpp` gives no line.

So a member that a block holds always has a non-NULL `m_data`. A member with size 0 holds the address `&gZeroMalloc[1]`, not NULL. Raven never passes NULL at `'BMEM'`.

The Swift paths agree:

- `Sources/JKAMP_DedLogic/CBlockMember.swift:26-30`: the init sets `m_data = nil` with `m_size = -1`.
- `:95`, `:120`, `:129`, `:225`, `:239`, `:254`, `:268`: every set is `Slots<JKAShared.byte>(scalars: ICARUS_Malloc(...), count: ...)`, which is not optional.
- `Sources/JKAMP_DedLogic/Memory.swift:9`: `func ICARUS_Malloc(_ iSize: Int32) -> UnsafeMutableRawPointer {`, not optional.
- `Sources/JKAMP_DedLogic/z_memman_pc.swift:73-76`: `if iSize == 0 {` / `let pMemory = ZoneHeader(gZeroMalloc)` / `return pMemory.block`.

So `bm!.GetData()!` cannot trap on a member that a block holds. The two Port-notes state the opposite of the fact:

- `Sources/JKAMP_DedLogic/CSequence.swift:373-374` and `CTaskManager.swift:1580-1581`: `// Port-note: Raven passes a NULL \`m_data\` with size 0, and the save call writes nothing.` / `// The \`bytes\` parameter has no nullable form, so the unwrap traps there.`

### 1c. The Swift callee and its row

- `Sources/JKAMP_DedLogic/interface_export_t.swift:59`: `var I_WriteSaveData: ((CUnsignedLong, Slots<JKAShared.byte>, Int32) -> Int32)? = nil`
- `Sources/JKAMP_DedLogic/Q3_Interface.swift:561-563`: `func AppendToSaveGame(_ chid: CUnsignedLong, _ data: Slots<JKAShared.byte>, _ length: Int32) -> Int32 {` / `return 1` / `}`
- `Sources/JKAMP_DedLogic/Q3_Interface.swift:872`: `pe!.I_WriteSaveData = AppendToSaveGame`
- The rows, `tools/oracle-closure/rulings.py:1562-1567`: `("AppendToSaveGame", "data"): "bytes",`, `("ReadFromSaveGame", "pvAddress"): "bytes",`, `("interface_export_t.I_WriteSaveData", "data"): "bytes",`, `("interface_export_t.I_ReadSaveData", "address"): "bytes",`. The comment names them row G9.
- The kind, `spelling.py:327-338`: a `void *` falls to `:338` `return Answer("Slots<JKAShared.byte>", "slots")`.
- Both `interface_export_t.swift` and `Q3_Interface.swift` are adopted hand files (no skeleton header on line 1), so the generator writes neither.

Every caller of `I_WriteSaveData`: 20 call lines. 6 in `CSequence.swift`, 6 in `CTaskManager.swift` (the two SaveCommand bodies), and 8 in `ICARUS_Instance.swift` (`:250`, `:264`, `:308`, `:335`, `:350`, `:353`, `:377`, `:394`). Each of the 18 other calls passes `value.withSlots { ... $0 ... }`, `idTable.withSlots`, or `name.withSlots`, a non-optional Slots. The `gi.AppendToSaveGame` lines of `Q3_Registers.swift:200-239` are Raven text inside a comment, not calls.

A side finding: the generator gives `chid` the type `UInt32` (store row `AppendToSaveGame`: `func AppendToSaveGame(_ chid: UInt32, _ data: Slots<JKAShared.byte>, _ length: Int32) -> Int32`, by `MSVC_WIDTH_FOLDERS = {"botlib", "icarus", "NPCNav"}` at `rulings.py:985`). The hand file has `CUnsignedLong` at `Q3_Interface.swift:561` and `:567` and `interface_export_t.swift:59` and `:61`. No ledger records this difference.

### 1d. The candidates

**(A) A guard that skips the call.** The form is at `Sources/JKAMP_DedLogic/CBlockMember.swift:156-159`:

```
// AI: Raven hands a NULL `m_data` with size 0 to `fwrite`, which writes nothing. The Swift skips the write for a nil `m_data`.
if self.m_data != nil {
    _ = FileBackend.fwrite(self.m_data!, at: 0, self.m_size, 1, m_fileHandle)
}
```

That guard came in commit `70dc73ea` ("The review fixes of the dead-function wave"), not `0e4cc2f7`. `git log -S"The Swift skips the write for a nil" -- Sources/JKAMP_DedLogic/CBlockMember.swift` gives `70dc73ea` only. Commit `0e4cc2f7` added the two SaveCommand Port-notes ("The two SaveCommand sites keep the unwrap under a note, because the `bytes` parameter has no nullable form").

By 1a, `AppendToSaveGame` does nothing with any argument, so a skip has the same effect as the call. By 1b, the nil case never occurs, so the guard is a dead branch. The WriteMember guard rests on the same wrong premise: Raven never hands NULL to `fwrite` there either.
Cost: 2 sites, each 3 lines change (`if let data = bm!.GetData() { ... }`) and the 2-line Port-note becomes one `// AI:` line. No generator table, no generated file, no snapshot line (the SaveCommand bodies are adopted hand code, outside `bodies.py` drafts of stubs).

**(B) A nullable form of `bytes`.** The branch goes after `spelling.py:327`: `if facts.nullable: return Answer("Slots<JKAShared.byte>?", "slots_opt")`, the form of the `table` kind at `spelling.py:369-372`. `facts.nullable` comes from `table.py:2058` `nullable=(owner, name) in self.nullable`, which is the NULL sweep plus `NULLABLE` (`rulings.py:1785`). No Raven caller passes NULL, so the sweep does not mark the parameter, and the change also needs `NULLABLE` rows for `("AppendToSaveGame", "data")` and the field key.
Reach: of the 64 PARAMS rows of kind `bytes`, 0 are in the nullable set today (the store's swept `nullable` facts, the `rulings` facts, and `NULLABLE`, intersected with the PARAMS rows of kind `bytes`). So the branch changes no existing signature. It changes the generated signature of `AppendToSaveGame` in the store and the manifest only. The adopted `Q3_Interface.swift:561` and `interface_export_t.swift:59` still need a hand edit, because the generator does not write them. The stored-function field goes through `views.py`, which has its own `bytes` branches (`views.py:809`, `:814`), but `interface_export_t` is a hand Swift class and not a view, so no view file changes.
This makes a NULL legal at a site where Raven never passes NULL. It is a new form for no real case.

**(C) An existing empty buffer value.** None is passed to a `bytes` parameter for a C NULL. `Slots` (`Sources/JKAShared/Views/Slots.swift:16-152`) has no empty or default initializer, only initializers over a base pointer. `CharBuf(0)` occurs in hand code (`GameInterface.swift:17`, `:257`, `win_main.swift:676`, `vm.swift:300`, `files_pc.swift:1546`, `:2864`, `CBlockStream.swift:22`, `:36`, `:168`, `:227`), but each is a placeholder value of a local or field, and none goes to a `bytes` parameter in place of NULL.

**(D) jka-rust.** It has no SaveCommand. `CSequence::Save` is inert: `icarus/src/sequence/csequence.rs:172-176`, `/// Raven \`CSequence::Save\` — inert in MP dedicated (Divergences).` ... `false as i32`. `CTaskManager::Save` is empty: `icarus/src/taskmanager/ctask_manager.rs:304-307`, `pub fn save(&self) {}`. The callee: `icarus/src/q3_interface/mod.rs:931-940`, `/// Raven \`AppendToSaveGame\` — the \`I_WriteSaveData\` target; inert (\`return 1\`)` with `_data: &[u8]` and the body `1`. The member data is `pub m_data: Vec<u8>,` (`icarus/src/blockstream/cblock_member.rs:32`), which cannot be null.

**(E) Keep the call as it is, and delete the false Port-note.** The unwrap is the faithful form of a pointer that is never NULL. Rule 24 puts no `// AI:` line at a faithful site.
Cost: 4 lines removed (`CSequence.swift:373-374`, `CTaskManager.swift:1580-1581`). No generator change, no generated file, no snapshot line. The open item P5 of ledger 15 (`notes/2026-11-10/dedicated-open-rows-ledger-15.md`, "The open items") closes. Optional and separate: the guard at `CBlockMember.swift:156-159` can go back to the plain `fwrite` for the same reason (1 AI line and 2 guard lines removed).

### 1e. Recommendation

E. Raven never passes NULL at `'BMEM'`, because `Z_Malloc(0)` returns `&gZeroMalloc[1]` (`z_memman_pc.cpp:161-165`), and every member a block holds went through `ICARUS_Malloc`. The unwrap is faithful, and the Port-note is false. A, B, and C each add code for a case that cannot occur. Ask the user whether the WriteMember guard of `70dc73ea` also goes, because it has the same premise.

## Item 2: the four hand-ruled signature groups

### How the port records a hand signature today

- No table records "this signature is hand-ruled". `grep -n "HAND_SIGNATURE\|hand_signature" tools/oracle-closure/*.py` finds only `adopt.py:36` `def hand_signatures(hand: list[str], draft: list[str]) -> list[str]:`, which keeps the hand func line when a draft is adopted again. `rulings.py:1553` says: "The skeleton writes no stub for a method, so such a row records the hand signature." That is a PARAMS row, not a list.
- No `// AI:` line at a signature says "hand signature" or "hand-ruled" (`grep -rn -i "hand signature\|hand-ruled" Sources` gives no line). The four groups carry rule 24 lines at the signature (for example `cm_terrain.swift:110`, `G2_misc.swift:162`).
- The only record of the four groups is the table of ledger 15 ("The hand-ruled signatures", `notes/2026-11-10/dedicated-open-rows-ledger-15.md:29-36`) and the rows N-G2SAVE, N-GORE, N-USERDATA, and N-CLOSURE of ledger 14 (`dedicated-open-rows-ledger-14.md:77-82`).

What protects the adopted files:

- `skeleton.py:1694-1696`: `if out.exists() and out.read_text().split("\n", 1)[0] != header_line(stem):` / `adopted.append(...)` / `continue`. A file whose line 1 is not the skeleton header is never written again.
- `draftcheck.py:118-135` (`kept`): a function that `align.py` marks `hand`, `edited`, or `rewritten` is never spliced over. A changed func line makes the function `edited`.
- `adopt.py:36-38`: if a person adopts a draft again, the hand func line stays.

What a run reports:

- The manifest (`.claude/manifest/mp-engine-ded/<stem>.md`, untracked) prints the store signature in its Signature column, not the hand line. Example, `G2_misc.md:40`: `` `func G2_SaveGhoul2Models(_ ghoul2: CGhoul2Info_v, _ buffer: inout JKAShared.TextCursor, _ size: inout Int32) -> Bool` ``. And `G2_misc.md:14`: `` `func G2_GetGoreRecord() -> Never` TODO: Port signature. No table row for the return `void *`. ``
- `lookup.py sig <name>` prints the same store text. `docs/transcription.md:37` says: "An adopted file keeps its old stub line, so a second pass takes the parameter list from this command and not from the file." A second pass that follows this line takes the wrong signature for all four groups. This is the real risk of a hand-ruled signature.
- `snapshot.py --check` compares the generated skeleton, drafts, and manifests with the cache, not with the adopted files. The four groups make no difference there after the cache refresh. They are not red and not noisy today.
- The build and `draftcheck` stay green, because the hand function is kept.

How many adopted signatures differ from the store: a script compared each `function` row of the dedicated store with the `func` line of the same name in `Sources/JKAMP_DedLogic/*.swift`, with access words and `{` removed and `CUnsignedLong` read as `UInt32`. Result: 1924 equal, 43 differ, 16 not found. The 43 fall into these groups:

- The four groups of this item: 7 functions (G2_SaveGhoul2Models, G2API_SaveGhoul2Models, G2_GetGoreRecord, CM_TerrainPatchIterate, CM_DrawDebugSurface, BotDrawDebugPolygons, CM_CircularIterate). The method `CCMLandScape.TerrainPatchIterate` has no store row (methods have no stub).
- The other 36 are outside the ledger 15 table. Some are spelling only, with the same type: a `JKAMP.` prefix (G2API_SetBoneIKState, G2API_IKMove, G2API_AddSkinGore, G2_InitIK, G2_SetBoneIKState, G2_IKMove, EvalBoneCache, G2_GetBoneBasepose, and others), a trailing comment after `{` (CM_LoadMap_Actual, RE_SplitSkins), a default argument (G2API_RagEffectorGoal), and `memtag_t` for `Int32` (Z_Malloc, Z_MorphMallocTag, Z_MemSize, Z_TagFree). Some are real hand changes of type: G2_SetupModelPointers (an overload), G2_Set_Bone_Rag (no `blist`), IsWhiteSpace, add_bit, and PS_NextWhiteSpaceChar (`CChar`), BotAvoidSpots (not optional), CM_GetWorldHeight (`inout`), CM_AreaCollision (`[Int32]?`), CreateRandomTerrain (`Slots<byte>?`), Log_Write and Log_WriteTimeStamped (`String` format), PC_EvaluateTokens, PC_Evaluate, and PC_DollarEvaluate (`UnsafeMutablePointer<Int32>?` in a logic signature), and SV_GameSystemCalls (`-> Int`). The full list is the output of the script. This record does not prove these rows, and no ledger table lists them.

Of the same shapes as the four groups, in the dedicated unit: closure parameter types, 3 (CM_DrawDebugSurface, BotDrawDebugPolygons, CM_CircularIterate); a `char **` buffer, 2; a `void *` return of a class, 1; a dropped `userdata`, 1 function and 1 method.

The same script over the game store (`tools/oracle-closure/table.sqlite`, against `JKAMP_GameLogic`, `JKAMP_BG*`, and `JKAShared`) gives 48 differences, and over the cgame store 1. Filtered for a closure, a `TextCursor`, or a `-> Never` marker, the game has 4: `qsort` (store `cmp: (() -> Int32)?`, hand `Sources/JKAMP_BG/bg_lib.swift:61` `cmp: (Int32, Int32) -> Int32`), and three store markers with hand signatures, `memmove` (`Sources/JKAShared/CString.swift:404`), `MatrixMultiply` (`Sources/JKAShared/q_math.swift:992`), and `NormalToLatLong` (`q_math.swift:1111`). These are older hand code of the shared targets. None has a `char **` buffer or a dropped `userdata`.

### Group 1: G2_SaveGhoul2Models, G2API_SaveGhoul2Models

**a. Raven.**

- `ghoul2/G2_misc.cpp:1719`: `qboolean G2_SaveGhoul2Models(CGhoul2Info_v &ghoul2, char **buffer, int *size)`
- `:1725`: `*buffer = (char *)Z_Malloc(4, TAG_GHOUL2, qtrue);` (empty vector), and the body later allocates the full block the same way.
- `ghoul2/G2_API.cpp:2472-2474`: `qboolean G2API_SaveGhoul2Models(CGhoul2Info_v &ghoul2, char **buffer, int *size)` / `{` / `return G2_SaveGhoul2Models(ghoul2, buffer, size);`
- Callers: `grep -rn "SaveGhoul2Models" oracle/codemp` gives only the two definitions, the API call at `G2_API.cpp:2474`, the two declarations in `G2_local.h:83` and `:177`, and a comment at `G2_misc.cpp:1769`. No file outside `ghoul2/` calls either. The block is a `Z_Malloc` byte block that the caller owns, the shape of `ppvBuffer` of RE_RegisterModels_GetDiskFile.

**b. The generator path.** The two parameters have no PARAMS row. `spelling.py:564-566`: `if inner.kind == TypeKind.POINTER and inner.get_pointee().get_canonical().kind == TypeKind.CHAR_S:` / `return None if facts.traps else Answer("inout JKAShared.TextCursor", "text_cursor")`. That is the text cursor default.

Smallest change: an existing kind extended by one branch value, plus two rows.

- `spelling.py:329`: `if pointee.kind == TypeKind.POINTER and pointee.get_pointee().get_canonical().kind in (TypeKind.VOID, TypeKind.UCHAR):` takes `TypeKind.CHAR_S` in the tuple, with the comment line extended.
- `rulings.py`, after `:1579`: `("G2_SaveGhoul2Models", "buffer"): "bytes",` and `("G2API_SaveGhoul2Models", "buffer"): "bytes",` under the row R3 comment of `:1574-1575`.
- Reach of the tuple change: it applies only to a parameter with a PARAMS row of kind `bytes`. Of the 64 such rows, 2 are double pointers (`RE_RegisterModels_GetDiskFile` `ppvBuffer`, `void **`, and `LoadTGA` `pic`, `byte **`), and neither has a `char` pointee. So 0 existing signatures change.
- Output: the store rows and manifest rows of the two functions, and the drafts of the two in `bodies/G2_misc.swift` and `bodies/G2_API.swift` of the snapshot. The adopted files do not change, and they then agree with the generator.

**c. Same shape elsewhere.** No other `char **` parameter of kind `bytes` exists. No other adopted signature has `inout Slots<JKAShared.byte>?` against a store `TextCursor`.

**d. jka-rust.** `ghoul2/src/misc.rs:1604`: `pub fn g2_save_ghoul2_models(g2: &Ghoul2System, ghoul2: &CGhoul2Info_v) -> Option<Vec<u8>> {`, and `ghoul2/src/api_saveload.rs:80`: `pub fn g2api_save_ghoul2_models(g2: &Ghoul2System, ghoul2: &CGhoul2Info_v) -> Option<Vec<u8>> {`. jka-rust returns the buffer and drops `size`. It does not keep Raven's out-parameter shape.

**e. If it stays hand-ruled.** The adopted files stay as they are (`skeleton.py:1694`). The manifest and `lookup.py sig` keep showing `inout JKAShared.TextCursor`, and a pass that follows `docs/transcription.md:37` takes that.

**f. Recommendation: extended kind.** One tuple member and two rows, no existing signature touched, and the form already exists for `void **` and `byte **` (rows TR13 and G11).

### Group 2: G2_GetGoreRecord

**a. Raven.**

- `ghoul2/G2_misc.cpp:113-116`: `void *G2_GetGoreRecord(int tag)` / `{` / `return FindGoreRecord(tag);` / `}`
- `:103`: `GoreTextureCoordinates *FindGoreRecord(int tag)`, which returns `&(*i).second` or `0` (`:108`, `:110`).
- Callers: none in `oracle/codemp`. `grep -rn "GetGoreRecord" oracle/` gives only the definition and the SP copy `oracle/code/ghoul2/G2_misc.cpp:118`. The one referent is `GoreTextureCoordinates`, or NULL.

**b. The generator path.** No RETURNS row. `table.py:2201-2206` (`class_ref`) reads the pointee declaration: `declaration = cur.result_type.get_canonical().get_pointee().get_canonical().get_declaration()` / `if declaration is not None and declaration.spelling in CXX_CLASSES:`. A `void *` has no declaration, so a `class_ref` row gives nothing, and the function gets the marker `func G2_GetGoreRecord() -> Never` with the reason "No table row for the return `void *`." The marker also drops the `tag` parameter.

Smallest change: an existing kind extended by one branch.

- `table.py`, beside `:2211` (`if isinstance(ruled, tuple) and ruled[0] == "view":`): `if isinstance(ruled, tuple) and ruled[0] == "class_ref":` / `return (f"{CXX_CLASSES[ruled[1]]}?", "")`. This is the class twin of the `("view", record)` form, which already serves a `void *` return: `rulings.py:1004` "view ... ("view", record), for a `void *` return of that record or NULL", and `rulings.py:1050` `"Display_CaptureItem": ("view", "menuDef_t"),`.
- `rulings.py` RETURNS: `"G2_GetGoreRecord": ("class_ref", "GoreTextureCoordinates"),`. `GoreTextureCoordinates` is in CXX_CLASSES at `rulings.py:1718`.
- The `rulings.py:1004-1016` legend line of `class_ref` takes the tuple form.
- Reach: the only `class_ref` row today is `"Com_ParseTextFile": "class_ref"` (`rulings.py:1103`), a string, not a tuple. 0 existing signatures change.
- Output: the store row and manifest row of G2_GetGoreRecord (the marker and its TODO go), and its draft in the snapshot.

**c. Same shape elsewhere.** No other `void *` return of a C++ class in the dedicated store differs from its adopted line.

**d. jka-rust.** Dropped. `ghoul2/src/api_gore.rs:16-17`: "`G2_GetGoreRecord` (`:113`, no caller anywhere in `codemp/`) are dropped alongside it for the same reason and carry no roster row at all".

**e. If it stays hand-ruled.** The adopted file stays. The manifest row keeps `-> Never` and "TODO: Port signature", which a grep of the manifests for `TODO: Port` counts. `grep -rn "TODO: Port" Sources` does not see it, because the manifests are under `.claude/`.

**f. Recommendation: extended kind.** One tuple branch in the form of `("view", record)`, one row, no existing signature touched.

### Group 3: CM_TerrainPatchIterate, CCMLandScape.TerrainPatchIterate

**a. Raven.**

- `qcommon/cm_terrain.cpp:997`: `void CCMLandScape::TerrainPatchIterate(void (*IterateFunc)( CCMPatch *, void * ), void *userdata) const`, and `:1005` `IterateFunc(patch, userdata);`
- `:1628-1630`: `void CM_TerrainPatchIterate(const class CCMLandScape *landscape, void (*IterateFunc)( CCMPatch *, void * ), void *userdata)` / `{` / `landscape->TerrainPatchIterate(IterateFunc, userdata);`
- Callers, 2:
  - `renderer/tr_terrain.cpp:923`: `CM_TerrainPatchIterate(common, InitRendererPatches, this);`. `this` is a `CTRLandScape *`. The dedicated build does not compile it: `unix/makefile:323` `#	$(B)/ded/tr_terrain.o \`.
  - `RMG/RM_Terrain.cpp:493`: `CM_TerrainPatchIterate(landscape->GetCommon(), SpawnPatchModelsWrapper, landscape);`. `landscape` is a `CRMLandScape *`, and `:478` casts it back: `CRMLandScape *landscape = (CRMLandScape *)userdata;`. The one caller of `RM_CreateRandomModels` is `client/cl_cgame.cpp:1707`, the client.
- Two referent types, and neither is ported in the dedicated unit.

**b. The generator path.** `table.py:2076-2078` sends a function pointer to `closure()` at `:2129`, which spells each prototype parameter through `self.param(p, following, traps=False)` (`:2135`). A `void *` gives `OpaquePointer?` (`spelling.py:485` `inner = pointee.get_canonical()`, and `:548-549` `if inner.kind == TypeKind.VOID:` / `return Answer("OpaquePointer?", "bare")`), so the store has `func CM_TerrainPatchIterate(_ landscape: CCMLandScape?, _ IterateFunc: ((CCMPatch?, OpaquePointer?) -> Void)?, _ userdata: OpaquePointer?)`.

No kind removes a parameter. The PARAMS legend (`rulings.py:1185-1222`) has no such kind, and `keyword_buckets` (`spelling.py:310-313`) only adds one. A row cannot make the hand form. A new kind would have to drop the `userdata` parameter and the matching closure parameter together, and the closure path has no owner key today (see group 4). That is a new kind and a new closure-path change for one dead function. The method has no stub, so the generator writes no signature for it in any case.

**c. Same shape elsewhere.** None. Ledger 14 row N-USERDATA says "This is the first such form in the port" (`dedicated-open-rows-ledger-14.md:79`).

**d. jka-rust.** Dropped. `qcommon/src/cm_terrain.rs:59-60`: "`CM_TerrainPatchIterate`/`TerrainPatchIterate` (renderer + dead generation-path callers only)".

**e. If it stays hand-ruled.** The adopted `cm_terrain.swift` and `CCMLandScape.swift` stay. The manifest row of `cm_terrain` shows the three-parameter form.

**f. Recommendation: stay hand-ruled, with a recorded entry.** A new kind for one dead function with one dead method is not worth its cost. The record is the ledger 15 table. If the user wants a record in the tool, the smallest is one comment line in `rulings.py` near `:1553`, the form that already records a method's hand signature.

### Group 4: CM_DrawDebugSurface, BotDrawDebugPolygons, and the callback of CM_CircularIterate

**a. Raven.**

- `qcommon/cm_patch.cpp:1651`: `void CM_DrawDebugSurface( void (*drawPoly)(int color, int numPoints, float *points) ) {`
- `server/sv_bot.cpp:227`: `void BotDrawDebugPolygons(void (*drawPoly)(int color, int numPoints, float *points), int value) {`
- Calls of `drawPoly`: `cm_patch.cpp:1758` and `:1761` pass `w->p[0]` (a winding's vector table), `:1777` and `:1782` pass `v[0]` (a local `vec3_t v[3]`), `:1804` is inside `#if 0`. `sv_bot.cpp:257`: `drawPoly(poly->color, poly->numPoints, (float *) poly->points);`
- Callers: `cm_patch.cpp:1674` `BotDrawDebugPolygons(drawPoly, cv2->integer);`, and `renderer/tr_main.cpp:1583` `CM_DrawDebugSurface( R_DebugPolygon );`, the renderer only. The one real `drawPoly`, `R_DebugPolygon` (`tr_main.cpp:1540`), reads `points + i * 3` at `:1550`, a table of vectors.
- `qcommon/cm_landscape.h:258` and `cm_terrain.cpp:1067`: `void CM_CircularIterate(..., int *user, void (*callback)(byte *, float, int *))`. The callers at `cm_terrain.cpp:1343`, `:1356`, `:1361`, `:1362`, `:1366` pass `CM_GetAverage`, `CM_Smooth`, `CM_ForceHeight`. Those have PARAMS rows `("CM_ForceHeight", "user"): "bytes"` and the like (`rulings.py:1544-1549`), so they take `Slots<Int32>`.

**b. The generator path.** The same `closure()`, `table.py:2129-2137`. It calls `self.param(p, following, traps=False)` with no `owner`, so no PARAMS row can reach a prototype parameter. `float *points` then takes the scalar pointer default `inout Float`, and `int *` takes `inout Int32`.

The stored functions of a view already have the owner key: `views.py:787`, `:802`, `:809`, `:814`, `:819` read `PARAMS.get((f"{owner}.{name}", label))`, where `label` is the prototype name or `f"p{i}"` (`views.py:778`). Example row: `("botlib_import_t.DebugPolygonCreate", "points"): "table"`.

Smallest change: the closure path takes the same key, plus one branch, plus rows.

1. `table.py:2078`: pass the function's owner, `self.closure(cur, name, owner)`. `table.py:2135`: `self.param(p, following, traps=False, owner=f"{owner}.{name}")`, and the label `p.spelling or f"p{i}"` as in `views.py:778`. No PARAMS key of the form `"<function>.<parameter>"` exists today, so 0 existing closures change.
2. `spelling.py:367`: the `table` branch requires a pointee in VECTORS (`t.get_pointee().spelling.replace("const ", "") in VECTORS`). A `float *` table needs one more branch, `Slots<JKAShared.vec3_t>` for a `float` pointee of kind `table`. The 18 PARAMS rows of kind `table` all have a `vec3_t *` or a record pointee today, so 0 existing signatures change.
3. Rows: `("CM_DrawDebugSurface.drawPoly", "points"): "table"`, `("BotDrawDebugPolygons.drawPoly", "points"): "table"`, and `("CM_CircularIterate.callback", "p2"): "bytes"` (the `int *` gives `Slots<Int32>` by `spelling.py:333-335`).

Output: the store and manifest rows of 3 functions, and their drafts in the snapshot.

**c. Same shape elsewhere.** In the dedicated unit, these 3. In the game, 1: the `qsort` comparator of `bg_lib.swift:61`, a hand function of the shared bg code. The cgame has none.

**d. jka-rust.** Not ported. `qcommon/src/cm_patch_fns.rs:17-20`: "the `mRandomTerrain` cached-cvar writes feed only `CM_DrawDebugSurface`, whose `drawPoly` callback seam has no home in this tree ... `CM_DrawDebugSurface` itself is not ported (it has no callers here)." `CM_CircularIterate` has no Rust function (`grep -rn -i "circular_iterate"` gives none).

**e. If it stays hand-ruled.** The adopted `cm_patch.swift`, `sv_bot.swift`, and `cm_terrain.swift` stay. The manifests show the `inout Float` and `inout Int32` closures.

**f. Recommendation: extended path, if the user wants the generator to own closure parameters.** It is the `views.py` owner-key pattern moved to `table.closure`, plus one `float *` branch of `table`, and it touches 0 existing signatures. If the user does not want a tool change for three dead debug functions, they stay hand-ruled under the ledger 15 table. The tool change has more value than group 3, because the same key would serve any later closure parameter.

## Side question: `import Foundation` in `bg_weapons.swift`

**The rule.** `tools/oracle-closure/reexport.py:306-307`:

```
if set(re.findall(r"\b\w+\b", expression)) & libc or re.fullmatch(r"[A-Za-z_]\w*", expression) and expression not in known:
    FOUNDATION_STEMS.add((target, header_stem(sources[0]) if sources else "unknown"))
```

and `:378-379`: `if (target, stem) in FOUNDATION_STEMS:` / `imports = ["import Foundation"] + imports`.
`known` is `{cur.spelling for cur in tu.cursor.get_children()}` (`:248`), the top-level cursors of the parse. Its comment (`:247`) says the arm is for "A macro the platform section spells as one name the parse never declares, `stricmp=strcasecmp`".

**The trigger.** `game/bg_weapons.h:43`: `#define LAST_USEABLE_WEAPON WP_BRYAR_OLD`. `WP_BRYAR_OLD` is an enumerator of `typedef enum { ... } weapon_t;` (`bg_weapons.h:8`, `:26`). An enumerator is a child of the enum cursor, not a top-level cursor, so it is not in `known`. The macro is on the expression rung (`Sources/JKAMP/Generated/bg_weapons.swift:8`, `public let LAST_USEABLE_WEAPON = WP_BRYAR_OLD`), and its expression is one bare name outside `known`. So the arm fires. The import is a false positive of the arm: `WP_BRYAR_OLD` is not a C library name. It does no harm, because every stub imports Foundation.

**Why master lacked it.**

- The rule came in `23d542c3` (2026-11-04, "The host table batch and one generator run"): its diff adds `FOUNDATION_STEMS`, `libc`, `known`, and the two lines above. `git log -G'expression not in known' -- tools/oracle-closure/reexport.py` gives `23d542c3` only. Later commits to `reexport.py` (`fc9786ce`, `1888dfbc`, `b4ac083b`) do not touch the rule.
- `bg_weapons.swift` did not change from `a941f966` (2026-09-09) until `c058e38c`: `git log --oneline -- Sources/JKAMP/Generated/bg_weapons.swift` gives `c058e38c`, `a941f966`, `6baff7e4`.
- No re-export file of `Sources/JKAMP/Generated` (outside `Views/` and `Storage/`) changed between `23d542c3` and `c058e38c`: `git log 23d542c3..c058e38c -- Sources/JKAMP/Generated ':!Sources/JKAMP/Generated/Views' ':!Sources/JKAMP/Generated/Storage'` gives `c058e38c` only.
- `reexport.py --target` writes only the named view targets, and "the others keep their files" (`reexport.py:407` help text, and the loop at `:422-430`, which reads a target outside `chosen` and does not write it). The batch ledgers record that form: `notes/2026-11-09/dedicated-open-rows-ledger-5.md:3` and `dedicated-open-rows-ledger-6.md:5` say "the reexport of `JKAShared` and `JKAMP_Ded`". So from `23d542c3` on, the dedicated batches did not write `CJKAMP`'s files, and the rule never ran over `bg_weapons`.
- Batch 14 ran the step of `tools/oracle-closure/README.md:63`, `.venv/bin/python reexport.py`, with no `--target`, so it wrote `CJKAMP` for the first time since the rule. Ledger 15 shows a reexport step of 152 s and 160 s (`dedicated-open-rows-ledger-15.md:54`), against 56 s and 91 s for batches 11 and 12 (`-12.md:50`, `-11.md:57`). This last point is an inference from the timing and the ledgers. No ledger records the exact command line of batch 14.

So no commit changed the trigger. The rule came in `23d542c3`, and the file was not regenerated until batch 14 ran the re-export over every target.
