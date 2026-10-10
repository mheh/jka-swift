# The post-spine changes

The builder did items 1 to 6 of "The work the rulings order" in `notes/2026-10-09/post-spine-walk.md`, on branch `post-spine` in the worktree `.claude/worktrees/spine`, from `9258302`. Each item is one commit. Every tool run used the worktree venv and the worktree store copy. The builder did not run `merge.py`, `tables.py`, `traps.py`, `channel.py`, `reexport.py`, or `manifest.py`.

## Item 1. The ICARUS views, `db5df91`

The change. The 17 `T_G_ICARUS_*` structs of `g_public.h` join `ROOTS` in `rulings.py` under `CJKAMP_Game`, with the names of row P1.

The generator run. `views.py` with no flags, 76 s. It reported 102 files, 100 views, and 33 callback types. It moved only the 17 new files `Sources/JKAMP_Game/Generated/Views/Icarus*.swift`.

The gate. `swift build` at 0 errors.

## Item 2. `gSharedBuffer` on `GameStorage`, `46a582a`

The change. A new name rule `BYTE_STORAGE_VARS = {"gSharedBuffer"}` in `rulings.py`. `skeleton.py` reads it: a one-level `char` array in the set is a new variable kind `byte_storage`, one zeroed allocation of Raven's bound in bytes on the storage class, typed `UnsafeMutableRawPointer`, freed in `deinit`. The stub forward is `var gSharedBuffer: UnsafeMutableRawPointer { world.storage.gSharedBuffer }`.

The generator run. `skeleton.py` with no flags. The first run also moved `Sources/JKAMP_BG/Generated/BgStorage.swift`, because the `bytes` allocator went into every storage class. The builder reverted that file, made the allocator appear only in a storage class that holds a byte buffer, and ran `skeleton.py` again. The second run moved only `GameStorage.swift` and `GameVariables.swift`. No adopted file moved.

The gate. `swift build` at 0 errors, `swift test --no-parallel` at 106 tests in four binaries (78, 14, 13, 1), and the tool tests at 73 tests with 14 skipped.

Departure. `g_main.swift` is adopted, so `skeleton.py` left its old `CharBuf` forward in place, and the build needs the new forward. The builder put the forward text that `skeleton.py --only g_main` prints into `g_main.swift`. Row P1 names this forward, so the builder counts it as part of the ruling and not as a hand fix of a body.

## Item 3. The drafter shape for a view at the byte buffer, `45f4afe`

The change. `draft_declarations.py` gets the shape rule: a pointer local whose initializer is a C cast of a variable in `BYTE_STORAGE_VARS` to a view type is `let sharedMem = IcarusPlaySound(handle: OpaquePointer(gSharedBuffer))`, with the view of the local's type. The new test `test_a_cast_of_the_shared_byte_buffer_is_a_view_at_its_base` in `tests/test_shapes.py` drafts `vmMain` and passed under `SLOW=1`.

The gate. `draftcheck.py --stem g_main`: 44 holes, 0 cascade errors, 0 defects, 4 compile holes over 2 passes, 32 of 49 hand functions replaced and 17 kept, 63 s. The reference was 90 holes, 0 defects, and 18 compile holes. The drop is 46 holes, more than the 33 the walk expected, and 14 compile holes. The 17 views of item 1 and the storage of item 2 likely remove the other holes that read `sharedMem`. The tool tests: 74 tests, 15 skipped.

Departure. None. The 33 Port-notes in the hand `g_main.swift` stay until a later re-splice, as the brief orders. The register call `trap_SV_RegisterSharedMemory(gSharedBuffer)` is not part of item 3 and was not checked.

## Item 4. `lastMod` and `text` on `GameWorld`, `57b86cd`

The change. `GameWorld` in `g_local.swift` gets `var lastMod: Int32 = -1` and `var text = CharBuf(1024)` under the `g_main.c` mark, each with its Raven line and its `/// Source:` line. `g_main.swift` gets the two forwards in the form of `line` in `g_cmds.swift`, each above its function. The Port-notes of `CheckCvars` and `G_GetStringEdString` stay for a transcriptor round.

The gate. `swift build` at 0 errors and `swift test --no-parallel` at 106 tests (78, 14, 13, 1).

## Item 5. The `level.gentities` store, `4c655ea`

The change. `G_InitGame` in `g_main.swift` stores `level.gentities = g_entities[0]`. The Port-note, its `Raven wrote:` line, and the `portMissing` call go.

The gate. `swift build` at 0 errors and `swift test --no-parallel` at 106 tests (78, 14, 13, 1).

## Item 6. The `splices` table, `6ef5a3c`

The change. `store.py` gets the table `splices (path, function, hash)` with the primary key `(path, function)`, and the methods `save_splices` and `splices`. `draftcheck.py` writes one row per function that the last pass spliced over a hand function, with the SHA-256 of the drafted lines from the Source line to the closing brace. `kept` takes the splice rows of the hand file and removes from the kept set each function whose body hash equals its row. The function name comes from the `func` line of the span. Two tests join `tests/test_draftcheck.py`: one for `kept` with a splice row and one for the store methods. The tool tests: 76 tests, 15 skipped.

The gate. `draftcheck.py --stem q_shared` twice. Both runs: 51 of 56 hand functions replaced, 5 kept, 151 holes, 0 cascade errors, 0 defects, 14 compile holes over 2 passes. The first run took 169 s and the second 32 s. The store holds 51 splice rows after the runs.

Departures. The kept count is 5, not the 4 of the reference. The `draftcheck.py` of `9258302` gives 5 kept on this tree too, so the 5 is the tree before the change and not a defect of the change. The gate writes only the mirror, so a splice row matches a hand body only after a re-splice writes that draft into the hand file. The proof of a drop in the kept count therefore waits for the next re-splice of `q_shared`. The builder did not raise `SCHEMA_VERSION`, though `store.py` asks for the next number on a table change. The schema uses `CREATE TABLE IF NOT EXISTS` on each open, so the table joins an old store, and a new version would delete the whole store.

## The references after the round

`draftcheck.py --all`: 89 holes, 0 cascade errors, 0 defects, 0 compile holes in 1 pass, 76 s. The reference before was 89 holes and 0 defects.

`draftcheck.py --game` in 5 calls of `--stem` over the 75 game stems, 15 stems each: 1161 holes, 0 cascade errors, 0 defects, 118 compile holes in 20 passes, about 1121 s. The reference before was 1207 holes, 0 defects, and 132 compile holes in 13 passes. The drop is 46 holes and 14 compile holes, the same as the drop of `g_main` in item 3. Each call builds its slice in its own passes, so the 20 passes are a sum over the calls and do not compare with the 13 of one call. The wall time of the second call comes from the times of its draft files, so the sum is approximate.
