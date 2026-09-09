# Packet jka-swift step-002 - q_math and bg_lib against the goldens

This packet binds the second lane of the Swift port of Jedi Academy.
Step 001 built the package, the views, and the one engine call, and it left every function of the module as a generated stub.
Step 002 ports the first two Raven files for real, and it proves them against the copied goldens with no engine in the loop.
The rows below are proposals, and each one waits on a ruling from the user.

## Scope

This step ports `oracle/codemp/game/q_math.c` and `oracle/codemp/game/bg_lib.c` to Swift, so that `swift test` reproduces `Sources/JKATestSupport/Oracle/golden/qmath.txt` and `Sources/JKATestSupport/Oracle/golden/bglib.txt` byte for byte.
Rule 16 names this the proof of a `q_math` step, and rule 18 names the goldens as the differential test.
No engine runs, no syscall fires, and no trap is called.

The step delivers:

- The ported bodies of every `q_math.c` function the native build compiles, 59 of Raven's 71.
- The eight vector helpers `q_shared.h` defines as `static ID_INLINE`, which no generator has written yet.
- `vec4_t` and the plane value type the ported signatures need, both in `JKAShared`.
- A `Rng` value type in `JKAShared` that holds Raven's `holdrand`, with `Rand_Init`, `flrand`, `Q_flrand`, `irand`, and `Q_irand` as methods, and five Raven-named bare forwarders in `JKAMP_GameLogic`.
- The ported `qsort` of `bg_lib.c`, with `med3` and `swapfunc`, and the tie permutation of equal keys.
- Two parity tests, one per golden, that rebuild the golden text from the ported functions and compare the whole string.
- `q_math.swift` moved to `Sources/JKAShared/q_math.swift`, with the generated header line removed so `skeleton.py` leaves it alone, and the `Sources/JKAMP_GameLogic/q_math.swift` stub it replaces deleted.
- `Sources/JKAMP_BG/bg_lib.swift` adopted, with the generated header line removed.

The step does not deliver: `q_shared.c`, `bg_misc.c`, any `g_*` body, the cgame or ui modules, a live engine run, or the lockstep referee.
`bg_lib.c`'s libc reimplementations are deferred to the VM step, not dropped.
Those are later steps.

## Surface contract

### The oracle inventory

`q_math.c` holds 71 functions across 1670 lines.
`skeleton.py` generated 59 stubs into `Sources/JKAMP_GameLogic/q_math.swift`.
The ruled home is `Sources/JKAShared/q_math.swift`; `skeleton.py` gains one routing line that sends the `q_math` stem there, and the `JKAMP_GameLogic` stub is deleted.
12 functions are absent for four measured reasons:

| Absent | Reason | Cite |
|---|---|---|
| `VectorCompare`, `VectorLength`, `VectorLengthSquared`, `Distance`, `DistanceSquared`, `VectorNormalizeFast`, `VectorInverse`, `CrossProduct` | `q_math.c` guards them with `#ifdef __LCC__`, so the native build takes the `static ID_INLINE` twin in the header | `oracle/codemp/game/q_math.c:139`, `oracle/codemp/game/q_shared.h:1452` |
| `CrossProductA` | Raven wrapped it in `#if 0` | `oracle/codemp/game/q_math.c:196` |
| `BoxOnPlaneSide2` | Raven left it inside an unclosed block comment | `oracle/codemp/game/q_math.c:765` |
| `PlaneTypeForNormal` | Raven commented the body out | `oracle/codemp/game/q_math.c:1275` |
| `fmod` | Raven guards it with `#ifdef Q3_VM` | `oracle/codemp/game/q_math.c:1484` |

The eight header twins are live code that the goldens exercise, so this step hand-writes them.
`grep -rn "VectorLengthSquared" Sources/` finds nothing today.
The other four are dead in the native build and this step writes none of them.

`bg_lib.c` holds 36 functions across 1318 lines.
`skeleton.py` generated 8 stubs into `Sources/JKAMP_BG/bg_lib.swift`, because `#if defined( Q3_VM )` hides most of the file from a native build, at `oracle/codemp/game/bg_lib.c:189`, `:268`, and `:914`.
The 8 are `swapfunc`, `med3`, `qsort`, `__builtin___memmove_chk`, `srand`, `rand`, `atof`, and `_atof`.
`__builtin___memmove_chk` is a parse artifact of Clang's fortify macro over Raven's `memmove` at `oracle/codemp/game/bg_lib.c:287`, and it is not a Raven name.

### The state

`q_math.c` holds one mutable file-scope global, `static unsigned long holdrand = 0x89abcdef;` at `oracle/codemp/game/q_math.c:1432`.
It drives `Rand_Init`, `flrand`, `Q_flrand`, `irand`, and `Q_irand` at `q_math.c:1434` through `:1474`.
`bg_lib.c` holds a second and unrelated seed, `static int randSeed = 0;` at `oracle/codemp/game/bg_lib.c:763`, which drives its own `rand` and `srand`.
`Q_rand`, `Q_random`, and `Q_crandom` at `q_math.c:126`, `:131`, and `:135` take an `int *seed` from the caller and hold no state.

Raven compiles `q_math.c` once per target, so game, cgame, ui, and the dedicated engine each hold a private `holdrand`, at `oracle/codemp/unix/makefile:394`, `:614`, `:803`, and `:904`.
Only the engine calls `Rand_Init`, at `oracle/codemp/qcommon/common.cpp:1248`, with the millisecond timer.
Game, cgame, and ui never seed, and run `0x89abcdef` for the life of the process.
jka-rust embeds `HoldrandLcg(pub u32)` in each owner and reaches it as a method call through the threaded world, for example `ctx.world.bg_state.rng.Q_irand(5, 8)` at `crates/mp/game/src/g_weapon.rs:1717`.
Our rule 4 keeps ported bodies free of a threaded parameter, hence the bare forwarders ruled for row 2.

The read-only tables are `vec3_origin` at `q_math.c:7`, `axisDefault` at `:8`, the thirteen `color*` vectors at `:11`, `g_color_table` at `:26`, and `bytedirs` with 162 entries at `:39`.
They become Swift `let` constants, which rule 6 allows.

### The goldens

`Sources/JKATestSupport/Oracle/golden/qmath.txt` is 4645 lines.
A section opens with `== <name> ==` on its own line, and `== end ==` closes the file.
Every float prints as its raw IEEE-754 bit pattern in lower-case hex, zero-padded to eight digits, with no `0x` prefix.
Every integer prints in decimal.
A NaN normalizes to `7fc00000` before it prints, because x86 and ARM make different NaN payloads.

| Section | Lines | Shape | Raven functions |
|---|---|---|---|
| `rng` | 1 to 3205 | Four blocks. Each opens `seed %08x`, then 100 groups of `fl`, `fl`, `fl`, `qf`, `ir`, `ir`, `ir`, `qi`. The seeds are `0x89abcdef`, `0`, `1`, and `0xdeadbeef`. The calls are `flrand(0,1)`, `flrand(-1,1)`, `flrand(-100,100)`, `Q_flrand(0,1000)`, `irand(0,1)`, `irand(0,100)`, `irand(-50,50)`, and `Q_irand(0,32767)`. | `Rand_Init`, `flrand`, `Q_flrand`, `irand`, `Q_irand` |
| `qrand` | 3206 to 3316 | 30 `qr %d`, then 30 `qrn %08x`, then 30 `qcr %08x`, each after a reseed to 12345, then 20 `qr %d` from seed -1. | `Q_rand`, `Q_random`, `Q_crandom` |
| `scalars` | 3317 to 3375 | 22 `cc %d cs %d log2 %d`, 10 `rsqrt %08x fabs %08x`, 6 `powf %08x`, 12 `b2d %d %08x %08x %08x`, and 4 pairs of `cb3 %08x cb4 %08x` with `ncol %08x %08x %08x %08x`. | `ClampChar`, `ClampShort`, `Q_log2`, `Q_rsqrt`, `Q_fabs`, `powf`, `ByteToDir`, `ColorBytes3`, `ColorBytes4`, `NormalizeColor` |
| `n2ll` | 3376 to 3382 | 6 lines of `n2ll %02x%02x`, the two output bytes with no separator. | `NormalToLatLong` |
| `planes` | 3383 to 3503 | 4 lines per fixture vector, `plane %d ty %d sb %d side %d`. The box takes vectors `i+1` and `i+2` modulo 30. | `SetPlaneSignbits`, `BoxOnPlaneSide` |
| `vecmath` | 3504 to 4644 | 30 blocks, one per fixture vector. A block opens `i %d` and holds 37 more tagged lines in a fixed order: `av`, `va`, `vn`, `vn2`, `vl`/`vls`, `dist`/`dsq`, `dh`/`dhs`, `vcmp`, `cross`, `dot`/`_dot`, `dpn`, `vinv`, `vma`, `vadd`, `vsub`, `vscale`, `v4s`, `proj`, `mnv`, `perp`, `rot`, `pfp`, `angsub`, `angssub`, `lerp`, `an360`/`an180`/`amod`/`adel`, `rfb`, `d2b`, `gclose`, `gdist`, `a2a`, `vrot`, `acopy`, `rad`, `aclear`, `mm`, `bounds`. | 38 functions, from `AngleVectors` to `AddPointToBounds` |

`Sources/JKATestSupport/Oracle/golden/bglib.txt` is 54 lines, one section `qsort`.
It prints `ints 30` and then 30 sorted decimal integers, then `kv 20` and then 20 lines of `%d %d`, then `== end ==`.
The `kv` block sorts a fixed 20-entry table by key alone, so its output pins the permutation `qsort` gives to equal keys.

The fixtures are `Oracle/fixtures/vectors.txt`, 30 lines of three hex bit patterns, and `Oracle/fixtures/ints.txt`, 30 decimal integers, one per line.

### The SKIP token

`proj`, `perp`, and `rot` print the literal `SKIP` in place of their values on three of the 30 vectors, at lines 3525, 3526, 4359, 4399, 4400, 4473, 4513, 4514, and 4625.
`ProjectPointOnPlane`, `PerpendicularVector`, and `RotatePointAroundVector` divide by the squared length of the normal, and the dumper skips the case where that sum is zero, at `jka-rust/tools/jampgame-oracle/main_qmath.c:26`.
This is rule 19's normalization in the dumper, so the Swift port prints `SKIP` under the same guard and never runs the divide.

### The comparison

jka-rust runs no field parser.
`qmath_parity` and `bglib_parity` rebuild the golden text with the same tokens and the same formatting, and hand the whole string to one comparator, `jka-rust/crates/testkit/src/lib.rs:40`.
The comparator tests `got == golden` and nothing else, and it falls back to a line-by-line diff only to write a useful panic message.
The Swift tests copy that shape.

### The RNG width

Raven declares `holdrand` as `unsigned long`, which is 32 bits on win32 and 64 bits on an LP64 host.
jka-rust ruled 32 bits on 2026-07-17, at `jka-rust/crates/native/math/src/rng.rs:8`, because at 64 bits `holdrand >> 17` spans the whole register and `irand(1,2)` returns values around plus or minus 32000.
The golden matches the 32-bit stream, and the Swift port uses `UInt32`.
The header comment of `jka-rust/tools/jampgame-oracle/main_qmath.c:3` still names the native width, and it is stale against the later ruling.
jka-rust's quirk ledger records this width as Q-3, at `jka-rust/docs/audits/quirk-ledger.md:21`.

### The float rules

Raven writes `(vec_t)sqrt(...)`, and `sqrt` is the double libm call rounded back to float.
A `Float.squareRoot()` double-rounds and diverges from the golden, so `VectorLength`, `VectorNormalize`, `VectorNormalize2`, and every other Raven `sqrt` compute in `Double` and convert once at the end.
jka-rust carries the same note at `jka-rust/crates/native/math/src/qmath.rs:212`.

`vec3_t` is `SIMD3<Float>` in this tree, at `Sources/JKAShared/Views/Vectors.swift:3`.
A SIMD reduction may reassociate, so a dot product, a length, and a matrix multiply keep Raven's scalar order and Raven's parenthesization.
A ported body uses SIMD only for an elementwise add, subtract, or scale, where the order cannot change.

### The test files

Two suites in Swift Testing, in the house style of `Tests/JKASharedTests/OracleDataTests.swift`.
The `q_math` suite lands at `Tests/JKASharedTests/QMathParityTests.swift`, beside the ported file.
The `bg_lib` suite lands at `Tests/JKAMPTests/BGLibParityTests.swift`, and `JKAMPTests` gains `JKATestSupport` as a dependency in `Package.swift`.
Each suite loads its fixture with `OracleData.fixture`, rebuilds the whole golden text, loads the golden with `OracleData.golden`, and asserts one string equality.
On a mismatch the suite reports the first differing line number and both lines.
A shared helper formats a `Float` as its canonical eight-digit bit pattern, and formats a `vec3_t` and a `vec4_t` as space-separated patterns.

Anything not on this list is out of scope, and the agent must not add it.
A new package dependency is a ruling of the user's, and this packet grants none.

## Commit bundle

Every commit uses `--no-gpg-sign`, a heading subject, an STE body, and no trailer of any kind.
Every commit gates on `swift build`, `swift build -c release`, and `swift test`.

1. `feat(step-002): vec4_t, the plane value, and the bit-pattern helper`
   This commit adds `vec4_t` beside `vec3_t` in `JKAShared`, adds the plane value type the two plane functions take in `JKAShared`, and adds the golden formatting helper to `JKATestSupport`. The helper turns a `Float` into its eight-digit hex bit pattern with the NaN normalization jka-rust uses, and it turns a vector into space-separated patterns. Nothing calls the helper yet, so the gate is a unit test over a handful of known patterns.
2. `feat(step-002): the holdrand RNG`
   This commit adds the `Rng` value type in `JKAShared` that holds Raven's `holdrand` at 32 bits, with `Rand_Init`, `flrand`, `Q_flrand`, `irand`, and `Q_irand` as methods. It adds five Raven-named bare functions in `JKAMP_GameLogic` that forward to the one instance the world owns, so a ported body still reads `flrand(0,1)` as Raven wrote it. The gate is the `rng` section of the golden, reproduced on its own.
3. `feat(step-002): q_math scalars, colors, and the direction table`
   This commit ports `ClampChar`, `ClampShort`, `Q_log2`, `Q_rsqrt`, `Q_fabs`, `powf`, `DirToByte`, `ByteToDir`, `ColorBytes3`, `ColorBytes4`, `NormalizeColor`, and `NormalToLatLong` into `Sources/JKAShared/q_math.swift`, and it lands the 162-entry `bytedirs` table as a constant. `ByteToDir` takes an out-of-range index in the golden, so the body keeps Raven's bounds check and the two-line note rule 19 asks for. This commit also carries the `skeleton.py` routing line for the `q_math` stem and deletes the `Sources/JKAMP_GameLogic/q_math.swift` stub it replaces, since this is the commit that opens the new home. The gate is the `scalars` and `n2ll` sections.
4. `feat(step-002): q_math vectors, angles, and planes`
   This commit ports the vector, angle, matrix, and bounds functions, the eight helpers `q_shared.h` defines as `static ID_INLINE`, and the three functions `g_local.h` declares, into `Sources/JKAShared/q_math.swift`. Every Raven `sqrt` computes in `Double` and converts once, and every dot product keeps Raven's scalar order. The gate is the `planes` and `vecmath` sections, which finishes `qmath.txt`.
5. `feat(step-002): the qsort of bg_lib`
   This commit ports `qsort`, `med3`, and `swapfunc` as one generic Swift sort over a slice, index-faithful to Raven's Bentley and McIlroy body, so the permutation of equal keys matches. jka-rust ruled the same body canonical in DEC-34 and never reproduces the tie order of the MSVC runtime. The `srand`, `rand`, `atof`, `_atof`, and `__builtin___memmove_chk` stubs stay untouched, as markers for the deferred VM step. The gate is `bglib.txt`.
6. `process(step-002): finished file`

## Write scopes

- Branch: `step-002-qmath-bglib` off `master`.
- Paths: `Sources/JKAShared/`, `Sources/JKAMP_BG/bg_lib.swift`, `Sources/JKATestSupport/`, `Tests/`, `Package.swift`, `tools/oracle-closure/skeleton.py` (the one routing line), and `docs/` where a rule needs a line.
- `oracle/` is read-only.
- `Sources/JKATestSupport/Oracle/` is copied data and is never edited.
- The agent never touches `/Users/milohehmsoth/Developer/Milo/jka-rust` and never touches `/Users/milohehmsoth/Developer/jka/`.
- The finished file lands at `.claude/packets/step-002/finished.md`.

## Disposition

After a clean lane-review: open the pull request to `master` and merge it on GitHub with a merge commit.
Never squash, and never commit directly on `master`.
The user pushes and merges, the agent does not.

## Open rows as proposed

1. **The home of the ported math.** Where does the ported `q_math.c` live? `skeleton.py` put it in `JKAMP_GameLogic`, because the Raven file sits in `codemp/game`, at `tools/oracle-closure/skeleton.py:46`. Proposed: a new logic target `JKAMPMath`, which depends on `JKAShared` only, holding `q_math.swift`. `JKAMP_BG` and `JKAMP_GameLogic` both depend on it. Reason: the types it uses are `vec3_t` and `vec_t` in `JKAShared`, it calls no trap and needs no view, and cgame and ui will want the same file without the game module. `skeleton.py` gains one routing line for the `q_math` stem, and the moved file drops its generated header line, which adopts it under the rule at `skeleton.py:15`.
2. **The home of the RNG state.** Is `holdrand` a static, or is it passed in? Proposed: a `struct Rng` value type in the math target holds the seed and carries the five methods, and one instance is a stored property of `GameWorld`, reached through the Raven-named bare functions `flrand`, `irand`, `Q_flrand`, `Q_irand`, and `Rand_Init` in `JKAMP_GameLogic`. Reason: rule 3 forbids a new global and rule 4 keeps ported bodies free of a threaded parameter. jka-rust made the same split, an owned `HoldrandLcg` at `jka-rust/crates/native/math/src/rng.rs:28` that owners embed, and the parity test constructs its own instance at `jka-rust/crates/mp/game/tests/jampgame_parity.rs:98`. A parity test therefore needs no world.
3. **The width of holdrand.** Raven declares `unsigned long`, which is 32 bits on win32 and 64 on this host. Proposed: `UInt32`. Reason: jka-rust ruled 32 bits on 2026-07-17 at `jka-rust/crates/native/math/src/rng.rs:8`, after a live finding that `irand(1,2)` returned values near plus or minus 32000 at 64 bits, and the copied golden holds the 32-bit stream. The comment at `jka-rust/tools/jampgame-oracle/main_qmath.c:3` predates that ruling and is stale.
4. **What bg_lib keeps.** Which of Raven's 36 `bg_lib.c` functions does this tree port? Proposed: `qsort` with `med3` and `swapfunc`, and nothing else. Reason: `#if defined( Q3_VM )` hides everything else from a native build, at `oracle/codemp/game/bg_lib.c:189`, and Swift already has the string, memory, and number conversions those bodies reimplement. `qsort` stays because the game module calls it at `oracle/codemp/game/g_team.c:1128` and `oracle/codemp/game/g_main.c:1829`, and its permutation of equal keys reaches the engine through the scoreboard order. `srand`, `rand`, `atof`, `_atof`, and the `__builtin___memmove_chk` artifact are removed with a one-line reason each, and `bg_lib.c` therefore holds no marker after this step.
5. **The test shape.** One file per golden or one file for both, and in which target? Proposed: `Tests/JKAMPMathTests/QMathParityTests.swift` and `Tests/JKAMPTests/BGLibParityTests.swift`, one suite each, with the bit-pattern formatter in `JKATestSupport` beside `OracleData`. Reason: a test lives with the target it drives, the formatter is shared by both suites and by every later golden, and `JKAMPTests` needs `JKATestSupport` added to its dependency list, which it lacks today at `Package.swift:61`. Each suite rebuilds the whole golden text and asserts one string equality, which copies jka-rust's comparator at `jka-rust/crates/testkit/src/lib.rs:40`. No section parser is written, because neither side parses.
6. **The signature style.** The stubs carry the trap table's shapes, and the trap table exists for word packing. Proposed: pure math takes Raven's inputs by value and writes an out-param through `inout`, so `func VectorLength(_ v: vec3_t) -> vec_t`, `func VectorNormalize(_ v: inout vec3_t) -> vec_t`, and `func _VectorMA(_ veca: vec3_t, _ scale: Float, _ vecb: vec3_t, _ vecc: inout vec3_t)`. Reason: `vec3_t` is `SIMD3<Float>` at `Sources/JKAShared/Views/Vectors.swift:3`, so it is a value type and copies are cheap, and rule 11 keeps every `Unsafe` type out of a logic target. jka-rust chose the same form at `jka-rust/crates/native/math/src/qmath.rs:211`, `:1011`, and `:1132`. Rule 7's return-value form is not taken here, because Raven's callers pass the same vector as input and output in places and a returned value would change the aliasing. Raven's comment block stays verbatim as `/** */`, and the `/// Source:` line sits directly above the declaration.
7. **The plane type.** `SetPlaneSignbits` and `BoxOnPlaneSide` take `struct cplane_s *`, and this tree has only the pointer-backed `Cplane` view, at `Sources/JKAShared/Generated/Views/Cplane.swift:9`. Proposed: the two functions take an `inout Plane`, a Swift value struct with Raven's four fields, and `Cplane` gains a `plane` getter and an `apply` setter in the views target for the day a trace hands one over. Reason: a logic target holds no pointer under rule 11, and a parity test cannot build a `Cplane` without allocating C memory. jka-rust kept these two in its ABI tier over `*mut cplane_t`, at `jka-rust/crates/mp/qshared/src/shared/q_math.rs`, so this row diverges from jka-rust on purpose. The alternative is to keep the view in the signature and give `JKATestSupport` a small allocator.
8. **The uncovered functions.** What happens to a ported function no golden line touches? Proposed: port it with its real body and add no marker, and record the list in the finished file. Reason: rule 14 says a marker means unported work, so a marker on a finished body would make `grep -rn "TODO: Port"` lie about the work left. Every `q_math.c` function the native build compiles has a Raven caller, so none of them is dead under rule 20. The finished file names each uncovered function, which is where a later golden gets its target list.
9. **The four dead q_math functions.** `CrossProductA`, `BoxOnPlaneSide2`, `PlaneTypeForNormal`, and `fmod` never reached the skeleton. Proposed: write none of them, and record the four with their cites in the finished file. Reason: Raven disabled each one in the source with `#if 0`, a block comment, a comment, or `#ifdef Q3_VM`, so no native build ever held them. Rule 20 asks for a stub with a marker for a function that is dead, and these four have no stub to mark, because the parse never saw them.

## Rulings

The user ruled on every row above in a ratification walk on 2026-09-09.

| Row | Verdict |
|---|---|
| 1 | Replaced. The home is `JKAShared`, not a new `JKAMPMath` target. |
| 2 | Ratified as proposed. `Rng` in `JKAShared`, five bare forwarders in each module that owns a world. |
| 3 | Ratified as proposed. `UInt32`, with a cite to jka-rust's quirk ledger, Q-3. |
| 4 | Replaced. Only `qsort`, `med3`, and `swapfunc` port. The other stubs stay untouched, and the Q3_VM-hidden 28 are deferred to the VM step. |
| 5 | Ratified as proposed, with the ruled paths: `Tests/JKASharedTests/QMathParityTests.swift` and `Tests/JKAMPTests/BGLibParityTests.swift`. |
| 6 | Ratified as proposed, plus a note on the `inout`-and-value-alias case for a later step. |
| 7 | Ratified as proposed. `Plane` and `vec4_t` land in `JKAShared`, the `Cplane` view in the same target gains the getter and setter. |
| 8 | Ratified as proposed. The lane agent measures live-caller coverage before writing the finished file. |
| 9 | Ratified as originally proposed. All four stay unwritten, recorded with cites. |

**Row 1.** The ported `q_math.c` lives in `JKAShared`, at `Sources/JKAShared/q_math.swift`, beside `Sources/JKAShared/Views/Vectors.swift`, which defines `vec3_t`. No new target opens. Every module target already depends on `JKAShared`, so cgame, ui, the SP modules, and any executable share the same functions without a new dependency edge. `skeleton.py` gains one routing line that sends the `q_math` stem to `JKAShared`. The moved file drops its generated header line, which adopts it. The stub file `Sources/JKAMP_GameLogic/q_math.swift` is deleted. The user's reason: the math functions are shared between all built dylibs and executables.

**Row 4.** This step ports `qsort`, with `med3` and `swapfunc`, and nothing else. The stubs `srand`, `rand`, `atof`, `_atof`, and `__builtin___memmove_chk` stay as markers, untouched. The 28 functions the `Q3_VM` guard hid from the parse get no stub now. The finished file lists them under one heading as deferred to the VM step, with cites, so the VM step has its target list. The user's reason: "we will port the VM sometime," so the `Q3_VM` branches are deferred work, not dead code. Commit 6 of the bundle, "drop the dead bg_lib stubs," is removed, and the finished-file commit becomes commit 6.

## Dispatch flags

- Oracle ambiguity: **true**. The width of `holdrand` reads two ways in the oracle and the jka-rust comments disagree, row 3.
- New state home: **true**. Rows 1 and 2 are ruled: the RNG seed lives in `JKAShared` as `Rng`, and the ported math lives in `JKAShared` too, with no new target.
- ABI or parity-gate surface: **true**. Both goldens are the gate, and row 7 changes a signature that a trace will later cross.
- Divergence proposal: **true**. Row 7 diverges from jka-rust's shape on purpose, and the `SKIP` token and the `ByteToDir` bounds check are rule 19 cases.

## Standing constraints for the lane agent

- Invoke the `house-style` skill before you write anything, and pass this instruction to your sub-agents.
- Read `~/.claude/skills/asd-ste100/SKILL.md` and `~/.claude/skills/house-style/SKILL.md` by path before you write.
- `oracle/` is read-only and is cited by `file:line`.
- `Sources/JKATestSupport/Oracle/` is copied data and is never edited. A golden that does not match is a bug in the port.
- Source files change through the Edit tool only.
- `swift build` is the ground truth for compilation, and the two goldens are the ground truth for behavior.
- Do not push.
- Pause on any unlisted surface, any contract signature change, any new dependency, or any fact that contradicts this packet. Ask, and resume after the packet is rewritten.
- The `## Rulings` section binds. Where an earlier section and a ruling disagree, the ruling wins.
- The finished file is the last act: assumptions and choices keyed to their commits, deviations or the word "none", the commit list with gate results, the uncovered function list from row 8, and open gaps.
