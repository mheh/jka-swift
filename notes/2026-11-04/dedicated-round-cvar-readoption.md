# Dedicated round: cvar readoption

This record covers the readoption of the host stem `cvar` on the stubs of master at `5323708`. The branch is `dedicated-round-cvar-2`, and the first record is `notes/2026-11-03/dedicated-round-cvar.md`.

## What landed

The merge of master is clean. Master gives two new signatures, Cvar_Register and Cvar_Update, from the `vmCvar_t` row of the table batch. Every other declaration line of the branch file is equal to the stub that master generated. Cvar_Realloc keeps its `TODO: Port signature` marker, because the table has no row for `int &`. The file stays adopted.

The commit applies the four ruled rows of the first record:

1. Cvar_FreeString stays a stub with one line that says it has no caller.
2. Cvar_Defrag is a callable no-op with its marker and one `// AI:` line. Cvar_Realloc stays a stub with one line that says it has no caller, because its stub has no signature and a no-op body cannot return `Never`.
3. Cvar_Register and Cvar_Update have their signatures, but the bodies stay stubs. See the open row below.
4. Cvar_SetValue has one `Port-note:` line for the float range that C leaves undefined.

The first build of the stem showed one error: `tolower` in generateHashValue is ambiguous between JKAShared and Foundation. The call takes the `JKAShared` qualifier with a one-line comment, as the import rule says.

## Counts

- Build: complete, 0 errors.
- Tests: 127 tests in 15 suites, 0 failures.
- Draftcheck for `cvar` on `mp-engine-ded`: 19 holes, 0 cascade errors, 0 defects, 0 compile holes in the stem. One defect stands in another file, `Callbacks.swift:4: unable to resolve module dependency: 'JKAMP_BG'`, in the mirror build.

## Open rows

1. The `handle` field of `vmCvar_t`. The view `VmCvar` gives its own `handle` to the slot pointer and has no accessor for the Raven field (`Sources/JKAMP/Generated/Views/VmCvar.swift:65`). Cvar_Register writes the field at `cvar.cpp:896`, and Cvar_Update reads it at `cvar.cpp:913` and `:917`. The drafter writes `vmCvar.handle = cvar_indexes.index(of: cv!)`, which does not compile. No game or cgame body reads the field, so no precedent exists. The row needs a view accessor under another name, then a generator run, then the two bodies.
2. The draftcheck defect in `Callbacks.swift` is outside the stem. The row needs a check on master to show whether the mirror build of the host unit has this defect without the round.
