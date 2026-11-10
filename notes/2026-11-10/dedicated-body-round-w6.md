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
