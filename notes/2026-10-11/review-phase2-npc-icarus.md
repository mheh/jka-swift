# Review of phase 2 wave A, the npc and icarus-log transcriptors

This review reads `git diff HEAD` of ten files at a1b6196: `NPC_utils.swift`, `NPC_AI_Jedi.swift`, `NPC_senses.swift`, `NPC_spawn.swift`, `NPC_combat.swift`, `NPC_AI_Rancor.swift`, `g_ICARUScb.swift`, `g_combat.swift`, `g_log.swift`, and `g_local.swift`. The diff holds 21 hunks. The line numbers are the lines after the edit. Each hunk was compared to Raven's C under `oracle/codemp/game/`, to the jka-rust port under `jka-rust/crates/mp/game/src/`, and to the ruled row in `frame-path-walk.md` and its proof.

## Hunks

| File:line | Unit | Row | Raven | Verdict | Notes |
|---|---|---|---|---|---|
| `NPC_AI_Jedi.swift:1991` | A-09 | I2 | `NPC_AI_Jedi.c:2391` | match | The comment line is the I2 text word for word. jka-rust `NPC_AI_Jedi.rs:3007` keeps only `//medium speed parry`. |
| `NPC_AI_Jedi.swift:3120-3123` | A-26 | R1 | `NPC_AI_Jedi.c:3784`, macro `q_shared.h:1365` | match | The macro expands to `v[n] + b[n]*(s)` with a `double` scale, so each component computes in `double` and narrows once at the store. The Swift is the R1 form exactly. jka-rust `NPC_AI_Jedi.rs:4532-4537` narrows the scale to `f32` first and can differ by one ulp from Raven. |
| `NPC_AI_Rancor.swift:509` | A-17 | R14 | `NPC_AI_Rancor.c:537` | match | `//, HL_NONE );//`, as R14 and jka-rust `NPC_AI_Rancor.rs:826`. |
| `NPC_AI_Rancor.swift:551` | A-17 | R14 | `NPC_AI_Rancor.c:577` | match | `//, HL_NONE );`, as R14 and jka-rust `NPC_AI_Rancor.rs:911`. |
| `NPC_combat.swift:2208-2211` | A-15 | T3 | `NPC_combat.c:2593` | match | The T3 form. The `i += 1` before `continue` is the `for` step, as at the sibling `continue` lines. jka-rust `NPC_combat.rs:2556` tests `!= 0`. |
| `NPC_senses.swift:657-661` | A-10 | I5 | `NPC_senses.c:677` | match | The loop moves records `i` to 30 from `i+1` to 31, the same span as Raven's byte count. jka-rust `NPC_senses.rs:905` is the same loop. |
| `NPC_senses.swift:700-704` | A-10 | I5 | `NPC_senses.c:718` | match | The same loop from `oldestEvent`. jka-rust `NPC_senses.rs:953`. |
| `NPC_spawn.swift:960-962` | A-11 | J2 | `NPC_spawn.c:1173`, macro `q_shared.h:1363` | match | The J2 form exactly. jka-rust `NPC_spawn.rs:864` writes one array copy with the same result. |
| `NPC_utils.swift:665` | A-01 | G1, J4 | `NPC_utils.c:870` | match | `bState_t(...)` is Raven's cast. The `bs_name!` unwrap follows the `VALIDSTRING` guard at `NPC_utils.c:863`. jka-rust `NPC_utils.rs:702`. |
| `NPC_utils.swift:680` | A-01 | J4, R2 | `NPC_utils.c:889` | form differs | See finding 1. |
| `g_ICARUScb.swift:78` | A-27 | R2 | `g_ICARUScb.c:316` | match | The R2 form exactly. jka-rust `g_ICARUScb.rs:95-97` prints an empty name. |
| `g_ICARUScb.swift:1294-1295` | A-08 | H1 | `g_ICARUScb.c:1656-1659` | match | Raven's `value[0]` is `*value`, a NULL test only, and the `guard let` is the same test. The NULL path leaves `value`, as H1 rules. jka-rust `g_ICARUScb.rs:1291-1295` stores NULL first. Both Port-notes and both `portMissing` calls left. |
| `g_ICARUScb.swift:1822-1834` | A-27 | R2 | `g_ICARUScb.c:2262`, `2267`, `2272`, `2277` | match | Four `?? "(null)"` arguments in Raven's order. jka-rust `g_ICARUScb.rs:1902-1931` prints an empty name. |
| `g_combat.swift:9` | A-35 | U2, C1 | `g_log.c:99` | match | The accessor type follows the state property. |
| `g_combat.swift:1969-1977` | A-37 | C1 | `g_combat.c:2527-2535` | match | The quotient reads 45, as Raven's does. The two-line note and the `obit` read are the C1 text word for word. The `G_LogPrintf` arguments are in Raven's order. jka-rust `g_combat.rs:2337-2346` has the same three arms. Both Port-notes and both `portMissing` calls left. |
| `g_combat.swift:4335-4337` | A-20 | N1 | `g_combat.c:5461`, `5465` | match | `maxtake` is `int` and `famt` is `float`, so C computes in `float` and truncates at the compound store. The Swift is the N1 form with no `Float(x)`. jka-rust `g_combat.rs:5624` writes the explicit `f32` casts with the same result. |
| `g_local.swift:146-150` | A-34 | U2, C1 | `g_combat.c:755` | style | See finding 2. The element type `String?` is the U2 form. |
| `g_local.swift:192-195` | A-34 | U2, C1 | `g_combat.c:755-797`, `bg_public.h:1047-1098` | match | Raven writes 42 names and `MOD_MAX` is 45. The Swift holds the same 42 names in the same order and 3 `nil` rows, 45 in all. jka-rust `g_combat.rs:66-70` declares 45 slots. |
| `g_log.swift:277` | A-36 | U2, C1 | `g_log.c:321` | match | jka-rust `g_log.rs:503-510` gives `(null)` through `modName`. |
| `g_log.swift:679` | A-36 | U2, C1 | `g_log.c:715` | match | Same read. |
| `g_log.swift:736` | A-36 | U2, C1 | `g_log.c:771` | match | Same read. |

The diff changes nothing outside these hunks. The Port-note counts agree with the two transcriptor records: 44 to 37 in the six npc files, and 11 to 7 in `g_ICARUScb.swift` and `g_combat.swift`. Each filled hole removed its Port-note line, its Raven-wrote line, and its `portMissing` call. No hunk adds a cast that Raven did not write, except the `Double` and `Float` conversions of the double-math rule at A-26.

## Findings

1. `NPC_utils.swift:680`, unit A-01, form differs from R2.
   - Raven, `NPC_utils.c:889`: `G_DebugPrint( WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", self->targetname, GetStringForID( BSETTable, bset ), bs_name );`
   - Swift: ``G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "", GetStringForID(BSETTable, bset) ?? "", bs_name!)``
   - jka-rust `NPC_utils.rs:710` drops the `if (0)` branch and writes no call.
   - The Swift is the J4 proof text. The R2 ruling extends guide line 337 to every `String?` that Raven passes to a `%s` and gives `?? "(null)"`. `GetStringForID` returns NULL for an unknown id, and Raven's `vsprintf` prints `(null)`. The branch is under Raven's `if (0)`, so no behavior differs. The site is the V14 case that the transcriptor record names, with the four A-42 lines.

2. `g_local.swift:146-147`, unit A-34, style. The finding was resolved before the wave B commit.
   - Raven, `g_combat.c:755`: `char	*modNames[MOD_MAX] = {` with 42 rows.
   - Swift: `// Raven writes 42 rows for a `MOD_MAX` array of 45, so C zeroes the last 3 slots.` and `// The last 3 rows here are those zeros.`, above the `///` lines.
   - jka-rust `g_combat.rs:62-64` puts the note in the `///` doc of the table.
   - The guide exemplar at `ai_wpnav.swift:63-64` writes the count as a word, "the last three slots", and puts the two lines directly above the declaration, under the `///` and Raven-wrote lines. The `g_local.swift` lines write "3" and stand above the `///` lines. The text and the facts are correct.

## Other notes

- The R2 ruling covers every `String?` that Raven passes to a `%s`. Unit A-27 names five sites, and `g_ICARUScb.swift` still holds about 23 force unwraps of the same ground, as finding 2 of `phase2-icarus-log.md` says. These are outside the diff.
- Units A-24 and A-42 of the npc transcriptor wait on a ruling, and the diff does not touch `NPC_combat.swift:130` or the `?? ""` lines of A-42.
