# The W6 body round of the dead-function wave

This record holds set W6 of section 4 of `notes/2026-11-10/docket-13.md`: the ICARUS save and load functions of `ICARUS_Instance`, `CBlockStream::WriteBlock`, `CBlockMember::WriteMember`, and the two `SaveCommand` functions. The branch is `ded-bodies-w6` from master `e820175b`, in the worktree `/tmp/jka-w6`. Rows G9 and G10 of ledger 14 give the signatures. Every Raven cite is under `oracle/codemp/icarus/`, and every Swift file is under `Sources/JKAMP_DedLogic/`.

## The functions

| Function | Raven | Status |
| --- | --- | --- |
| ICARUS_Instance::SaveSequenceIDTable | Instance.cpp:312 | landed |
| ICARUS_Instance::SaveSequencers | Instance.cpp:367 | landed |
| ICARUS_Instance::SaveSignals | Instance.cpp:389 | landed |
| ICARUS_Instance::Save | Instance.cpp:422 | open |
| ICARUS_Instance::LoadSignals | Instance.cpp:451 | landed |
| ICARUS_Instance::LoadSequences | Instance.cpp:503 | landed |
| ICARUS_Instance::LoadSequencers | Instance.cpp:547 | landed |
| ICARUS_Instance::Load | Instance.cpp:575 | open |
| CBlockMember::WriteMember | BlockStream.cpp:133 | landed |
| CBlockStream::WriteBlock | BlockStream.cpp:577 | landed |
| CSequence::SaveCommand | Sequence.cpp:320 | landed |
| CTaskManager::SaveCommand | TaskManager.cpp:1620 | landed |

Ten of twelve bodies landed.

## The open functions

- Save and Load write and read the `double version` of ICARUS_VERSION through its address, 8 bytes, at Instance.cpp:426, :442, :581, and :612. `Slots<byte>` has the `[int:]` and `[float:]` subscripts (`Sources/JKAShared/Views/Slots.swift:203`, `:210`) and no `double` subscript, so no logic body can put the 8 bytes of a `Double` into a CharBuf without a word split of its bit pattern. The row it needs: a `subscript(double:)` of `Slots<byte>` beside `[float:]`, in the same form. The file is outside the set, so each function keeps its marker with a Port-note that names the missing subscript.

## The forms

- Each value that Raven writes or reads through its address goes through a CharBuf of its bytes, the form of `CNode.Save` and `CNode.Load` (`CNode.swift:337`, `:398`). The CharBuf crosses to `I_WriteSaveData` and `I_ReadSaveData` as the `Slots<byte>` of `withSlots` or `withMutableSlots`.
- Each four-character chunk ID is its MSVC value in hex, with Raven's text in a trailing comment, the form of `CNode.swift:341`.
- The sizes are Raven's 32-bit sizes: 4 for an `int`, 1 for the `unsigned char` flags, and 4 for the `sizeof(&numSequencers)` of LoadSequencers.
- SaveSignals walks the sorted keys, because Raven's `std::map` walks its keys in order and the Dictionary has none.
- LoadSequences reads the ID table into a CharBuf and takes the `[Int32]` of AllocateSequences from its bytes.
- The three Load functions carry a rule 19 note at the first read: ReadFromSaveGame of MP fills nothing, so Raven reads an unset local, and the CharBuf starts at zero.
- The rule 20 notes lose the clause "so the function keeps its marker" where the body landed.

## The checks

`swift build -j 2` completes with no warning in the five files. `swift test --no-parallel -j 2` passes 162 tests, the count of the base.

## The double subscript and the two last bodies

The fix pass on the branch `dedicated-integration-15` closes the two open functions.

- The ruling, by the existing pattern: `Slots<byte>` gets `subscript(double:) -> Double` directly after `[float:]` in `Sources/JKAShared/Views/Slots.swift`, in the same form. It has one doc line with Raven's cast form, one `// AI:` line, and `loadWord` and `storeWord` as its getter and setter. Both helpers are generic over the type and use `MemoryLayout<T>.size`, so the 8 bytes of a `Double` go through them with no change.
- ICARUS_Instance::Save (Instance.cpp:422) and ICARUS_Instance::Load (Instance.cpp:575) are landed. Each puts the version into a CharBuf of `Double.byteCount` bytes, 8, Raven's size of `double`. The chunk IDs are `0x4943_4152` for 'ICAR' and `0x4945_4E44` for 'IEND'. Load carries the rule 19 note at its first read, as the other three Load functions do.
- The two Port-notes that named the missing subscript are removed. Twelve of twelve bodies of the set are landed.
- Cvar_Defrag (`cvar.swift`) loses its stale `// TODO: Port Cvar_Defrag` line. Its body is the ruled form of `notes/2026-11-03/dedicated-round-cvar.md`, a callable no-op with one `// AI:` line.

`swift build -j 6` completes. `swift test --no-parallel -j 6` passes 162 tests, the count of the base.
