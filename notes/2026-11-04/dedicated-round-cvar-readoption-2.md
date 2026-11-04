# Dedicated round: the second cvar readoption

This record covers the third merge of master into the branch `dedicated-round-cvar-2`, on the stubs of master at `c24e5e7`. The earlier records are `notes/2026-11-03/dedicated-round-cvar.md` and `notes/2026-11-04/dedicated-round-cvar-readoption.md`.

## What landed

The merge of master is clean. Master changes no signature of `cvar.swift`. The one change that reaches the stem is the accessor `cvarHandle` on the view `VmCvar`, from row 13 of `notes/2026-11-04/dedicated-open-rows-ledger.md`. The file stays adopted.

The commit fills the two holes that row 13 unblocks:

1. Cvar_Register writes `cvar_indexes.index(of: cv!)` into `vmCvar.cvarHandle`, sets the modification count to -1, and calls Cvar_Update. The generated signature takes a non-optional `VmCvar`, so Raven's NULL check at `oracle/codemp/qcommon/cvar.cpp:893` has no caller. One `Port-note:` line records this.
2. Cvar_Update keeps Raven's unsigned range check as `UInt32(bitPattern: vmCvar.cvarHandle) >= cvar_numIndexes`. It copies the string through `stringBuffer` with `Q_strncpyz`. The `assert` drops, as `docs/transcription.md` says.

The open row 2 of the first readoption, the `Callbacks.swift` defect, is closed by row 9 of the ledger. The draftcheck below shows no defect.

## Counts

- Build: complete, 0 errors.
- Tests: 127 tests in 15 suites, 0 failures.
- Draftcheck for `cvar` on `mp-engine-ded`: exit 0. 6 of 34 hand functions replaced, 28 kept, 19 holes, 0 cascade errors, 0 defects, 1 compile hole over 2 passes. The tool reports stale base facts and stale adoption facts, because the host manifests stay untracked.

## Holes that stay open

- Cvar_FreeString stays a stub. It has no caller under the string pool.
- Cvar_Realloc stays a stub with its `TODO: Port signature` marker. The table has no row for `int &`, and it has no caller.
