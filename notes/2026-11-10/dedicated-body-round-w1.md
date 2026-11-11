# The GenericParser2 body round of set W1

This record holds the body round of set W1 of section 4 of `notes/2026-11-10/docket-13.md`, plus the eight GenericParser2 functions of set R2, on the branch `ded-bodies-w1` in the worktree `/tmp/jka-w1`. The one file is `Sources/JKAMP_DedLogic/GenericParser2.swift`, which was adopted already. The bodies are commit `18debde5`.

## The counts

| Part | Functions | Bodies | Markers | Left |
| --- | --- | --- | --- | --- |
| W1 | 19 | 18 | 1 | 0 |
| R2, N-GP2 group part | 2 | 2 | 0 | 0 |
| R2, N-GP2 value part | 6 | 0 | 6 | 0 |
| Total | 27 | 20 | 7 | 0 |

## The functions

- W1, landed with a body: GP_Parse, GP_Clean, GP_Delete, GP_GetBaseParseGroup, GPG_GetName (1 and 2 arguments), GPG_GetNext, GPG_GetSubGroups, GPG_GetInOrderSubGroups, GPG_FindSubGroup, GPG_FindPair, GPG_FindPairValue (3 and 4 arguments), GPV_GetName (1 and 2 arguments), GPV_IsList, GPV_GetTopValue (1 and 2 arguments).
- W1, CleanTextPool: the not-ported marker of ledger 13 row R5 was already in the file. No change.
- R2, landed with a body: GPG_GetInOrderNext and GPG_GetInOrderPrevious. Row N-GP2, group part: `CGPGroup` has the weak `mInOrderNext` and `mInOrderPrevious` in the `mNext` form, and the accessors `GetInOrderNext` and `GetInOrderPrevious` of `GenericParser2.h:57` and `:59`. `AddGroup` sets the two links after `SortObject`, as Raven's `SortObject` does at `GenericParser2.cpp:596` to `:606`.
- R2, not ported: GPG_GetPairs, GPG_GetInOrderPairs, GPV_GetNext, GPV_GetInOrderNext, GPV_GetInOrderPrevious, GPV_GetList. Row N-GP2, value part: the marker "C3 makes the value list an Array, so the chain does not exist.", the text of the `rulings.py` rows and of the skeleton.

Each body keeps the note `Port-note: Rule 20. No file of oracle/codemp calls this function.` without the old words "so it keeps its marker".

## The AI lines

- GP_Parse: Raven deletes the parser when the parse fails. The return of nil releases the class.
- GP_Delete: Raven deletes the parser and clears the handle. The store of nil releases the class.

## The rule 19 notes

- GPG_FindPairValue with a Value buffer (`GenericParser2.cpp:1099`): Raven's strcpy reads through NULL when the pair holds an empty list. The unwrap traps there.
- GPV_GetTopValue with a Value buffer (`GenericParser2.cpp:1182`): the same NULL for a value with an empty list. The docket did not name this site.

## The checks

- `swift build -j 2`: exit 0, no warning in the file.
- `swift test --no-parallel -j 2`: 162 tests, all pass.
