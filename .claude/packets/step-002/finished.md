# Finished jka-swift step-002 - q_math and bg_lib against the goldens

Branch `step-002-qmath-bglib`, off `master`. Both goldens match byte for byte. One row waits on a ruling, at the end of this file.

## The commits and their gates

Every commit used `git commit --no-gpg-sign`, and every code commit passed `swift build`, `swift build -c release`, and `swift test` before it landed.

| Hash | Subject | Gate |
|---|---|---|
| `8e4126f` | `process(step-002): packet and rulings` | Documents only. |
| `aaa8a3f` | `feat(step-002): vec4_t, the plane value, and the bit-pattern helper` | Three builds green, 33 tests. |
| `0e9afea` | `feat(step-002): the holdrand RNG` | Three builds green, 34 tests. The `rng` section of `qmath.txt` matches. |
| `cb28402` | `feat(step-002): q_math scalars, colors, and the direction table` | Three builds green, 34 tests. The `rng`, `qrand`, `scalars`, and `n2ll` sections match. |
| `71cf6a9` | `feat(step-002): q_math vectors, angles, and planes` | Three builds green, 34 tests. All 4645 lines of `qmath.txt` match. |
| `a1d24cc` | `feat(step-002): the qsort of bg_lib` | Three builds green, 35 tests. All 54 lines of `bglib.txt` match. |
| `bbce191` | `test(step-002): the world tests run one after the other` | Three builds green, 35 tests, and 30 runs of `swift test` green. |
| this file | `process(step-002): finished file` | Documents only. |

Both goldens matched on the first run of their suite, so no port bug was found and no golden was touched.

## Assumptions and choices, keyed to their commits

**Commit 1.** `vec4_t` is `SIMD4<Float>`, beside `vec3_t`. `Plane` carries Raven's four fields and drops `pad[2]`, because no Raven code reads the padding. `Cplane` gains `plane` and `apply` in a hand-written file beside `Plane`, so the generated view file stays generated. `GoldenFormat` holds the `f2b`, `PV3`, and `PV4` of `dumpcommon.h`, plus the first-differing-line message of jka-rust's comparator.

**Commit 2.** `Rng` holds `holdrand` at 32 bits, the row 3 ruling, cited to jka-rust's quirk Q-3. The five draws are `mutating` methods, the game world owns one instance, and `g_local.swift` holds the five Raven-named bare forwarders. Rule 3 puts a Raven global in `g_local.swift` and nowhere else, so the forwarders live there and no new file opens.

**Commit 3.** The ported file is `public` throughout. The generator emitted internal declarations, and row 1's reason is that cgame, ui, the SP modules, and any executable share these functions, which needs `public` in `JKAShared`. Raven's `vec3_t axis[3]` becomes `[vec3_t]` and `float m[3][3]` becomes `[[Float]]`, so a body indexes as Raven wrote it and no new named type opens. Two helpers carry the rule 19 divergences the whole file needs: a float cast to a byte saturates and turns a NaN into 0, and a double truncated to an int does the same. Both take the one defined behavior jka-rust took.

**Commit 4.** Every Raven `sqrt` computes in `Double` and rounds once. `sin`, `cos`, `atan2`, `acos`, and `fmod` are the double libm calls, and `M_PI` is the double of `math.h`, because `q_shared.h:548` guards its float `M_PI` with `#ifndef`. Every dot product, length, and matrix multiply keeps Raven's scalar order. `AngleVectors` drops Raven's three NULL checks, because row 6 gives an out-param as `inout` and a `vec3_t` value cannot be null. A Swift caller that wants one output passes a scratch vector for the other two, and the note sits at the declaration. `RotateAroundDirection` and `AnglesToAxis` pass each result through a local, because Raven hands two elements of one array to one call and Swift allows one exclusive access.

**Commit 5.** `qsort` is generic over a Swift array with a comparator closure. Raven's `swaptype` chunking is a speed choice the order never observes, so `swapfunc` swaps whole elements.

## Deviations from the packet

1. **Commit 2 adopted `Sources/JKAMP_GameLogic/q_math.swift` and removed its five `holdrand` stubs.** The packet moves and deletes that file in commit 3. A stub `flrand` and a forwarder `flrand` cannot both exist in one module, so commit 2 could not be green without the removal. Commit 3 deleted the file as the packet says.
2. **Commit 3 also ported `Q_rand`, `Q_random`, `Q_crandom`, and `VectorNormalize`.** The packet's commit list names no home for the `qrand` section, and the `n2ll` fixture normalizes each vector before it prints. Both sections are part of commit 3's gate in fact.
3. **Commit 3 gave every stub its row 6 signature as part of the move.** Rule 15 asks for a signature change ahead of the body that needs it, and the move is that commit. Commit 4 therefore changed bodies and nothing else.
4. **The ported functions are `public`.** See commit 3 above.
5. **`bg_lib.swift` gained two private helpers with non-Raven names.** `insertion` holds the small-array loop Raven writes twice, and `qsortSpan` holds the span Raven reaches with `goto loop` over the same locals. Rule 10 keeps the behavior, not the shape.
6. **`Tests/JKASharedTests/QMathParityTests.swift` holds one suite with one test.** An intermediate commit compared one golden section at a time, and commit 4 replaced that with the whole-text equality the packet asks for.
7. **One commit outside the packet's bundle, `bbce191`.** The three tests of `GameWorldTests` each assign a fresh world to the one global and ran in parallel, so one reset clobbered another and the run failed about once in ten. The race predates this step, and the new parity suites changed the schedule enough to show it. The three now sit in one suite with the serialized trait, which rule 3 asks for. `swift test` ran 30 times green after the fix, and 12 runs on `master` were green before it.

## Row 8, the golden coverage

Every ported body has a real body and carries no marker, as row 8 rules. `grep -rn "TODO: Port" Sources/JKAShared/q_math.swift` finds nothing.

Two ported functions no golden line touches directly:

- `_VectorCopy`, at `oracle/codemp/game/q_math.c:1237`. The dumper uses Raven's `VectorCopy` macro, not this function. The Swift suite calls it where the dumper writes the macro, so it is covered in fact.
- `VectorNormalizeFast`, at `oracle/codemp/game/q_shared.h:1536`. No golden line reaches it. A later golden needs it.

## Row 8, golden-only callers

The row 8 reason claims that every `q_math.c` function the native build compiles has a Raven caller. A grep of both oracle trees for a call outside `q_math.c` itself finds no caller for five functions. The user ratified an amendment to row 8 on 2026-09-09: a function the native build compiles, that a golden exercises, counts as live under rule 20, even with no Raven caller. These five functions keep their real bodies under that ruling:

| Function | Cite | Why it has no caller |
|---|---|---|
| `_VectorMA` | `oracle/codemp/game/q_math.c:1214` | `q_shared.h:1365` takes the `#if 1` branch, so `VectorMA` is the inline macro and the `_` twin is never called. |
| `_DotProduct` | `oracle/codemp/game/q_math.c:1221` | `q_shared.h:1358`, same reason for `DotProduct`. |
| `_VectorSubtract` | `oracle/codemp/game/q_math.c:1225` | `q_shared.h:1359`, same reason. |
| `_VectorAdd` | `oracle/codemp/game/q_math.c:1231` | `q_shared.h:1360`, same reason. |
| `Vector4Scale` | `oracle/codemp/game/q_math.c:1249` | No tree calls it. `q_shared.h:1401` gives `Vector4Copy` as a macro, and no `Vector4Scale` macro exists. |

`_VectorCopy` at `:1237` and `_VectorScale` at `:1243` have no caller in `codemp`, and both have one in `code`, the SP tree.

## Row 4, the deferred Q3_VM list of bg_lib.c

Raven's `bg_lib.c` holds 36 functions. The skeleton parsed 8, and 28 sit behind a guard a native build never takes. Row 4 defers all 28 to the VM step, and none of them has a stub today. `#if 0` hides ten and `Q3_VM` hides eighteen.

| Function | Cite | Guard |
|---|---|---|
| `strlen` | `oracle/codemp/game/bg_lib.c:191` | `Q3_VM`, `bg_lib.c:189` |
| `strcat` | `oracle/codemp/game/bg_lib.c:202` | `Q3_VM`, `bg_lib.c:189` |
| `strcpy` | `oracle/codemp/game/bg_lib.c:216` | `Q3_VM`, `bg_lib.c:189` |
| `strcmp` | `oracle/codemp/game/bg_lib.c:228` | `Q3_VM`, `bg_lib.c:189` |
| `strchr` | `oracle/codemp/game/bg_lib.c:237` | `Q3_VM`, `bg_lib.c:189` |
| `strstr` | `oracle/codemp/game/bg_lib.c:247` | `Q3_VM`, `bg_lib.c:189` |
| `tolower` | `oracle/codemp/game/bg_lib.c:269` | `Q3_VM`, `bg_lib.c:268` |
| `toupper` | `oracle/codemp/game/bg_lib.c:277` | `Q3_VM`, `bg_lib.c:268` |
| `floor` | `oracle/codemp/game/bg_lib.c:305` | `#if 0`, `bg_lib.c:303` |
| `memset` | `oracle/codemp/game/bg_lib.c:309` | `#if 0`, `bg_lib.c:303` |
| `memcpy` | `oracle/codemp/game/bg_lib.c:316` | `#if 0`, `bg_lib.c:303` |
| `strncpy` | `oracle/codemp/game/bg_lib.c:323` | `#if 0`, `bg_lib.c:303` |
| `sqrt` | `oracle/codemp/game/bg_lib.c:337` | `#if 0`, `bg_lib.c:303` |
| `sin` | `oracle/codemp/game/bg_lib.c:492` | `#if 0`, `bg_lib.c:303` |
| `cos` | `oracle/codemp/game/bg_lib.c:513` | `#if 0`, `bg_lib.c:303` |
| `create_acostable` | `oracle/codemp/game/bg_lib.c:535` | `#if 0`, `bg_lib.c:303` |
| `acos` | `oracle/codemp/game/bg_lib.c:684` | `#if 0`, `bg_lib.c:303` |
| `atan2` | `oracle/codemp/game/bg_lib.c:695` | `#if 0`, `bg_lib.c:303` |
| `tan` | `oracle/codemp/game/bg_lib.c:757` | `Q3_VM`, `bg_lib.c:754` |
| `atoi` | `oracle/codemp/game/bg_lib.c:915` | `Q3_VM`, `bg_lib.c:914` |
| `_atoi` | `oracle/codemp/game/bg_lib.c:961` | `Q3_VM`, `bg_lib.c:914` |
| `abs` | `oracle/codemp/game/bg_lib.c:1010` | `Q3_VM`, `bg_lib.c:914` |
| `fabs` | `oracle/codemp/game/bg_lib.c:1014` | `Q3_VM`, `bg_lib.c:914` |
| `AddInt` | `oracle/codemp/game/bg_lib.c:1037` | `Q3_VM`, `bg_lib.c:914` |
| `AddFloat` | `oracle/codemp/game/bg_lib.c:1080` | `Q3_VM`, `bg_lib.c:914` |
| `AddString` | `oracle/codemp/game/bg_lib.c:1140` | `Q3_VM`, `bg_lib.c:914` |
| `vsprintf` | `oracle/codemp/game/bg_lib.c:1183` | `Q3_VM`, `bg_lib.c:914` |
| `sscanf` | `oracle/codemp/game/bg_lib.c:1285` | `Q3_VM`, `bg_lib.c:914` |

The five stubs `srand`, `rand`, `atof`, `_atof`, and `__builtin___memmove_chk` stay untouched, as markers. `__builtin___memmove_chk` is a parse artifact of Clang's fortify macro over Raven's `memmove` at `oracle/codemp/game/bg_lib.c:287`, and it is not a Raven name.

## Row 9, the four dead q_math functions

None of the four is written, and none has a stub, because the parse never saw one.

| Function | Cite | Why it never reached the skeleton |
|---|---|---|
| `CrossProductA` | `oracle/codemp/game/q_math.c:196` | Raven wrapped it in `#if 0`. The body is x86 inline assembly. |
| `BoxOnPlaneSide2` | `oracle/codemp/game/q_math.c:765` | Raven left it inside an unclosed block comment that opens at `:766`. |
| `PlaneTypeForNormal` | `oracle/codemp/game/q_math.c:1275` | Raven commented the body out. `q_shared.h:1856` gives the live form as a macro. |
| `fmod` | `oracle/codemp/game/q_math.c:1484` | Raven guards it with `#ifdef Q3_VM`. |

## Open gaps

1. **Row 8, amended on 2026-09-09.** The lane brief said that a ported function with no caller gets the rule 20 stub and marker instead of a body. The measurement above found five such functions. The `qmath.txt` golden calls all five directly, at the `vma`, `dot`, `vsub`, `vadd`, and `v4s` lines, and three of them are the macro expansions that other ported bodies use. The user ratified the amendment: a function the native build compiles, that a golden exercises, counts as live under rule 20, even with no Raven caller. All five keep their real bodies and no marker, the row 8 verdict as the packet now writes it, under the golden-only callers heading above.
2. **`AngleVectors` has no way to say NULL.** Raven's three NULL checks have no Swift form under row 6, and a caller passes a scratch vector. A later step that ports a caller writing `AngleVectors(angles, forward, NULL, NULL)` may want an optional shape.
3. **Row 6 asked for a note on the alias case.** Raven's callers pass one vector as both input and output in places, for example `VectorMA(right, -d, forward, right)` inside `MakeNormalVectors`. The `inout` form handles that inside one body, because the elementwise write reads no other element. A later port that aliases two whole `inout` arguments of one call needs a local copy, and Swift will report the exclusivity violation at compile time.
4. **`Plane` carries no `pad[2]`.** A trace that hands over a `cplane_t` reaches the value through `Cplane.plane`, and `apply` leaves the padding as the engine left it. If a later engine read depends on the padding, `Plane` needs a fourth field.
5. **`SyscallGameSuite` also resets the world, and it is a separate suite.** Swift Testing serializes the tests inside one suite, and two suites still run in parallel, so a cross-suite race on `world` is still possible. A fix nests every world-touching suite under one serialized parent, which restructures a step-001 test file, so this step left it.
6. **`q_shared.c` and the rest of `bg_*.c` are untouched.** `Sources/JKAMP_GameLogic/q_shared.swift` still holds its generated stubs.
