# The drafter round

The round ran on branch `drafter-round` in the worktree `.claude/worktrees/spine`, from wave-0 at 11c7899. Items 1 (R5) and G1 were already in place and the round did not redo them. The per-item gate is the tool tests, `.venv/bin/python -m unittest discover -s tests`, which ran 68 tests with 10 skipped before the round. Each item adds one shape test to `tests/test_shapes.py`, which runs only with `SLOW=1`, so each new test counts as one more skipped test in the fast gate. Each shape test also passed under `SLOW=1`.

## Drafter item 2 (R6), the output text and the String local

The change is in `empty_test` and the subscript arm of `draft_expressions.py`. Raven's `s[0]` on an `out_string_ref` parameter is the test of the String itself, and `token[1]` on a String local reads the byte through `JKAShared.CharBuf(token)`. The change is the patch at `/tmp/spine/item3-empty-test.patch`, used as written. The test `test_an_output_text_and_a_string_local_read_as_text_and_as_bytes` drafts `COM_ParseString` and `SkipBracedSection`. The gate ran 69 tests, OK, 11 skipped. The commit is 56ad589.

## Drafter item 3 (R6), the return in a void function

The change is in the `RETURN_STMT` arm of `draft_statements.py`. When the table makes the function void, the return drops Raven's value. A plain name or an integer literal drops, and any other value stays as a statement before the bare `return`, so a call in the value keeps its effect. The test `test_a_return_in_a_void_function_drops_the_value` drafts `Q_strlwr`. The gate ran 70 tests, OK, 12 skipped. The commit is 799f8c6.

## Drafter item 4 (R6), the SIMD index and the narrow local

The change is in the subscript arm of `draft_expressions.py` and in `declaration` of `draft_declarations.py`. The index of a SIMD vector other than `vec3_t` converts to `Int`. Today that is `vec4_t` only, from `VECTORS` of `spelling.py`, because `SIMD4` takes an `Int` index and only the `SIMD3` of JKAShared adds a C integer subscript in `Views/Int32Indexing.swift`. The base can be a parameter or Raven's `(*c)`, which the helper reads by its C type. A narrow local, `CChar`, `Int8`, `UInt8`, `Int16`, or `UInt16`, initialized from a wider integer parameter truncates at the store with `truncatingIfNeeded`, which is the truncation C performs. The test `test_a_simd_index_and_a_narrow_local_convert_to_the_swift_type` drafts `COM_ParseVec4` and `Q_strrchr`. The gate ran 71 tests, OK, 13 skipped. The commit is cfe7ad7.

Departure. The proof names the initializer conversion "to the local's type". The draft uses `CChar(truncatingIfNeeded: c)` and not `CChar(c)`, because the plain conversion traps on a value C truncates.

## Drafter item 5 (R3), the rule 3 note of a shared state variable

The change is the text of the SHARED arm of `variable_entry` in `skeleton.py`. The note now reads "a file-scope variable of this stub at Raven's line, the `rng` shape of q_math". skeleton.py did not run. The test `test_a_shared_state_variable_names_its_home_in_the_stub` reads the entry of `com_token`. The gate ran 72 tests, OK, 14 skipped. The commit is 9182331.

## R4, the partition rule in merge.py

The item stopped, and the round has no commit for it. The rule added an MP macro that SP never defines and that a body of `q_shared.c` or `q_math.c` reads to the shared macros of its constants file. The first form also moved the function-like macros `DotProduct`, `VectorSubtract`, `VectorCopy`, and `VectorMA` from `CJKAMP` to `CJKAShared`. A second form kept function-like macros out. That form still moved three object-like macros from `codemp/game/q_shared/constants.h` of `CJKAMP` to `shared/game/q_shared/constants.h` of `CJKAShared`: `BIG_INFO_STRING`, `BIG_INFO_KEY`, and `BIG_INFO_VALUE`. The bodies of `Info_RemoveKey_Big` and `Info_SetValueForKey_Big` read all three. The brief allows only the `BIG_INFO_STRING` placement to move, so the item stopped at that point.

The merge ran only into `/tmp/spine/m0`, `/tmp/spine/m1`, and `/tmp/spine/m2`, never into `Sources/`, so no generated file needs a revert. The run used a copy of the main checkout's `out/extract` trees in the worktree's ignored `out/` folder. Without the rule, the run at `/tmp/spine/m0` matched `Sources/` in every generated file. The `merge.py` change is reverted, and its diff is at `/tmp/spine/item5-merge-rule.patch`.

Two facts for the ruling. First, the rule closes a class, and the class holds all three `BIG_INFO` macros, so the ruling must allow three moves, not one. Second, `merge.py` writes only the C targets. The Swift re-export `Sources/JKAMP/Generated/q_shared.swift` lines 25, 28, and 31 spells `CJKAMP.BIG_INFO_STRING` and its two kin, and only `reexport.py` writes that file. The brief forbids a run of `reexport.py`, so the re-export cannot move in this round. The Swift build and tests did not run for this item.

## The references after the round

| Reference | At 11c7899 | After the round | Wall time |
|---|---|---|---|
| `draftcheck.py --all` | 89 holes, 0 defects | 89 holes, 0 defects, 0 compile holes | 81 s |
| `draftcheck.py --game` | 1211 holes, 0 defects, 136 compile holes, 13 passes | 1207 holes, 0 defects, 132 compile holes, 13 passes | 801 s |
| `--stem q_shared` | 159 holes, 0 defects, 22 compile holes | 152 holes, 0 defects, 15 compile holes | 117 s for both stems |
| `--stem g_main` | 90 holes, 0 defects, 18 compile holes | 90 holes, 0 defects, 18 compile holes | in the run above |

The holes go down and the defects stay at 0, so the round has no defect finding.

## The snapshot

`snapshot.py --check` against `$HOME/.cache/jka-swift/snapshot-stage-two-shared` ran for 119 s and exited with 1. 101 of 353 files moved: 13 body files, 86 manifest files, and the skeletons of `q_math` and `q_shared`. The skeleton lines are the new rule 3 note. The body lines include the write cursor of R5, for example `out[outIndex] = 0` in `g_client`, and the shapes of this round. The manifest lines show 0 jka-rust matches where the snapshot shows a match, because the worktree has no `../jka-rust` sibling. That move comes from the worktree path, not from the round. The snapshot was not refreshed.
