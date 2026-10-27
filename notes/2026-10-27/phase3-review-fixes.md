# Review fixes of phase 3, groups 1 and 2

## V35a

- `tools/oracle-closure/draft_declarations.py:460-477`: `slot_refs` keys the parent map by the cursor, `parents[kid] = node`, and `slot_parent` reads `parents.get(cur)`. The wrapper-node test and its comment are gone (ruling R2).
- `tools/oracle-closure/draft_declarations.py:503-505`: the first-store test compares a read with `first_end`, the end offset of the first store (ruling R3).
- `tools/oracle-closure/draft_declarations.py:507` and `:519`: the two other reads of the map use the cursor as the key.
- `tools/oracle-closure/draft_declarations.py:530-531`: the docstring of `plain_entity` holds one sentence on each line.
- `tools/oracle-closure/tests/test_shapes.py`, class `Slots`, parses small C functions and runs without `SLOW=1`. `tests/test_store.py` tests the SQLite store, so the cases sit beside the other drafter tests (ruling R4). The four cases:
  - `test_a_local_stored_in_straight_line_code_before_its_reads_is_let_or_var` (the SortRanks shape, then a two-store local)
  - `test_a_local_stored_first_in_a_loop_body_that_opens_a_scratch_record_is_closure` (the Pickup_Powerup shape)
  - `test_a_read_before_the_first_store_leaves_the_local_optional` (a read before the store, and a read in the right side of the first store)
  - `test_a_stacked_implicit_cast_over_a_read_ends_the_walk_up_at_the_call`
- Unittest: `.venv/bin/python -m unittest discover -s tests` gives 82 tests, OK, 16 skipped (reference 78 OK, 16 skipped).
- Snapshot: `snapshot.py --out /tmp/v35a-before` before the change and `/tmp/v35a-after` after it. 0 body files moved, and the skeleton, channel, traps, and views folders are equal. 3 manifest files differ (`NPC_stats.md`, `g_weapon.md`, `w_saber.md`), and each difference is a Swift line number in the `JKAMP_GameLogic/...swift:N` column. The cause is the edits of the other agent in `Sources/JKAMP_GameLogic` between the two runs, not the tool change.

## Hand fixes

- `Sources/JKAShared/CString.swift:480`: the doc of `withCString(_:_:)` reads "Every trap calls it for a `const char *` parameter, and a nil string reaches the engine as NULL."
- `Sources/JKAShared/Views/CStrings.swift:12-13`: the doc of `store(_:at:capacity:)` holds the two lines of the review.
- `Sources/JKATestSupport/RecordingTransport.swift:25`: `cString(at: pointer)` replaces `String(cString: pointer)` (ruling R1). The signature is `cString(at address: UnsafeRawPointer)`, and Swift converts the `UnsafePointer<CChar>` at the call.
- `notes/2026-10-27/phase3-helpers.md:105`: the W19 paragraph gains the sentence about `g_spawn.swift:231` and the two `jampsmoke` sites.
- `notes/2026-10-27/phase3-helpers.md:146`: the `memset` section reads `CString.swift:338-349`.
- `notes/2026-10-27/phase3-generators.md`, section V37: the sentence that a `default` arm that joins labels keeps the first label comment alone, and the other comments drop with their labels by ruling W15 (ruling R5).

## Blocked items

- `Sources/jampsmoke/main.swift:25` and `:69` stay as they are. The signature is `cString(at address: UnsafeRawPointer)` in `JKAShared`, and the target `jampsmoke` depends on `CJKASyscall` alone (`Package.swift:50`), so it cannot call it. The site types are `UnsafeMutablePointer<CChar>` (`dlerror()` at `:25`, a loader message and not engine text) and `UnsafePointer<CChar>` (`:69`, a command word). A fix needs a new dependency of the smoke loader on `JKAShared`, and the package comment at `Package.swift:65` keeps the smoke test free of linked game code. No overload and no helper was added. The point needs a ruling.
- `Sources/JKAMP_GameLogic/g_spawn.swift:231` belongs to group 4 and was not touched.
