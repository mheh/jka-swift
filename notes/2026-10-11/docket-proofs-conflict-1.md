# Docket proofs, conflict 1: a comment line on the integer compare with `qfalse`

Rows E2, H2, P1, and T2 share one form, `== 0` for `qfalse` and `== 1` for `qtrue`. The E2 and P1 proofs write no comment line. The H2 proof keeps one comment line, after guide line 533. This record decides between the two.

## 1. The nine hole sites

All sites are `// Raven wrote:` lines in `Sources/JKAMP_GameLogic/`, with `portMissing` on the next line.

| Row | Swift site | Raven line | Raven's test |
| --- | --- | --- | --- |
| P1 | `g_nav.swift:349` | `g_nav.c:319` | `trace.startsolid == qfalse`, `trace.allsolid == qfalse` |
| P1 | `g_nav.swift:519` | `g_nav.c:512` | `trace->allsolid == qfalse`, `trace->startsolid == qfalse` |
| P1 | `g_nav.swift:794` | `g_nav.c:790` | `tr.startsolid == qfalse && tr.allsolid == qfalse` |
| P1 | `g_nav.swift:807` | `g_nav.c:802` | the same text |
| P1 | `g_nav.swift:978` | `g_nav.c:992` | `trace.allsolid == qfalse`, `trace.startsolid == qfalse` |
| E2 | `w_saber.swift:873` | `w_saber.c:843` | `VectorCompare( oldLookAngles, lookAngles ) == qfalse` |
| H2 | `g_ICARUScb.swift:1849` | `g_ICARUScb.c:2290` | `TAG_GetOrigin2( NULL, name, goalPos ) == qfalse` |
| T2 | `NPC_combat.swift:2232` | `NPC_combat.c:2609` | `( flags & CP_SQUAD ) == qfalse` |
| T2 | `NPC_combat.swift:2502` | `NPC_combat.c:2893` | `( level.combatPoints[i].flags & CPF_SQUAD ) == qfalse` |

## 2. The guide

Line 533 gives one comment line for an unsigned hex mask that the body spells as `~0x0000_0003`. The literal Raven wrote, `0xfffffffc`, is not on the page, and the comment keeps it.

The other lines that ask for a comment line all mark a fact that the Swift text hides: line 187 (a copy for one variable passed to two `inout` parameters), line 410 (a static local renamed with a suffix), line 443 (zero rows after a short brace list), and line 619 (two Raven tests that draft as one Swift text).

Line 618 is the counter case. `!saber->model` and `!saber->model[0]` both draft as `saber.model.isEmpty` with no comment, because one test keeps one text.

The guide gives no rule that separates a drafter respelling from a hand respelling. Lines 187 and 619 are drafter forms with a comment, and line 618 is a drafter form without one. The test is the same for both authors: a comment line goes in when the Swift text loses a fact of Raven's line, and it stays out when the Swift text is a full spelling of the test.

## 3. The drafter and the compiled bodies

`tools/oracle-closure/draft_expressions.py:508` emits `!x` on a number as `<x> == 0`, and `:316` emits a bare number test as `<x> != 0`, both with no comment. `:661-664` spell `qtrue` and `qfalse` as `true` and `false`. `bodies.py:4-5` states the same rule in its docstring.

| Module | Lines with `== 0 {` | Comment above that names Raven, `qfalse`, or `qtrue` | No such comment |
| --- | --- | --- | --- |
| `JKAMP_GameLogic` | 1321 | 0 | 1321 |
| `JKAMP_BG` | 310 | 0 | 310 |

Of these 1631 lines, 369 have some comment on the line above, and each one is Raven's own comment. The compiled `qboolean` compares, `== false` and `== true`, are 91 lines, and none has a comment that names the constant. `g_combat.swift:103` reads `VectorCompare(ppoint!, vec3_origin) == 0` with no comment. Line 533's form is in `bg_misc.swift:1685` and `:1712`, where the comment keeps the hex literal.

## 4. jka-rust

`jka-rust/crates/mp/game/src/g_nav.rs:440` reads `if trace.startsolid == 0 && trace.allsolid == 0 && trace.fraction == 1.0 {`, with no comment. `jka-rust/crates/mp/game/src/NPC_combat.rs:2578` reads `(flags & CP_SQUAD) == 0`, and the line above it is Raven's own comment. `g_ICARUScb.rs:1986` keeps `== qfalse`, because `qboolean` is `c_int` there, and `w_saber.rs:1026` writes `!VectorCompare(...)`, because its `VectorCompare` returns `bool`.

## 5. Verdict

No comment line. `qfalse` is the value 0, so `== 0` is a full spelling of the C compare and loses no fact of Raven's line, unlike the hex literal of line 533. The drafter writes the same text for `!x` with no comment, none of the 1631 compiled `== 0 {` lines has a comment that names Raven's form, line 618 gives a respelled test no comment, and jka-rust writes the same text with no comment.

```swift
// H2, g_ICARUScb.swift:1849
if TAG_GetOrigin2(nil, name, &goalPos) == 0 {
// P1, g_nav.swift:349
if ((trace.startsolid == 0) && (trace.allsolid == 0)) && (trace.fraction == 1.0) {
```

The H2 ledger row in `frame-path-walk.md` needs an amendment that drops its comment line.
