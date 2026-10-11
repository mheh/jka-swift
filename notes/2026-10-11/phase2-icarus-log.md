# The record of the icarus-log transcriptor, phase 2 wave A

The transcriptor filled or changed every site of units A-08, A-20, A-27, A-35, A-36, and A-37. The line numbers before are the lines of `wave-0` at a1b6196. The helper had already changed `modNames` in `g_local.swift` to `[String?]` with 45 rows when the transcriptor read it.

## Sites

| Site before | Unit | Row | Verdict and text |
|---|---|---|---|
| `g_ICARUScb.swift:1294` | A-08 | H1 | filled, `guard let text = Q3_GetAnimBoth(ent!) else { return 0 }` |
| `g_ICARUScb.swift:1298` | A-08 | H1 | filled, `value = text`, and the second Port-note and `portMissing` left the file |
| `g_combat.swift:4333` | A-20 | N1 | changed, `forcePower = Int32(targ.client!.ps.fd.forcePower - maxtake * famt)` |
| `g_combat.swift:4335` | A-20 | N1 | changed, `forcePower = Int32(targ.client!.ps.fd.forcePower - (maxtake * famt) / 2)` |
| `g_ICARUScb.swift:78` | A-27 | R2 | changed, `g_entities[entNum].script_targetname ?? "(null)"` |
| `g_ICARUScb.swift:1827` | A-27 | R2 | changed, `ent!.script_targetname ?? "(null)"` |
| `g_ICARUScb.swift:1831` | A-27 | R2 | changed, `ent!.script_targetname ?? "(null)"` |
| `g_ICARUScb.swift:1835` | A-27 | R2 | changed, `ent!.script_targetname ?? "(null)"` |
| `g_ICARUScb.swift:1839` | A-27 | R2 | changed, `ent!.script_targetname ?? "(null)"` |
| `g_combat.swift:9` | A-35 | U2, C1 | changed, the accessor type is `[String?]` |
| `g_log.swift:277` | A-36 | U2, C1 | changed, `modNames[j] ?? "(null)"` |
| `g_log.swift:679` | A-36 | U2, C1 | changed, `modNames[j] ?? "(null)"` |
| `g_log.swift:736` | A-36 | U2, C1 | changed, `modNames[j] ?? "(null)"` |
| `g_combat.swift:1969` | A-37 | C1 | filled, the C1 `if` with `modNames.count`, and `obit = modNames[meansOfDeath] ?? "(null)"` under the two-line note |
| `g_combat.swift:1973` | A-37 | C1 | filled, `G_LogPrintf("Kill: %i %i %i: %s killed %s by %s\n", killer, ..., obit)` in Raven's argument order |

## Port-note counts

| File | Before | After |
|---|---|---|
| `g_ICARUScb.swift` | 7 | 5 |
| `g_combat.swift` | 4 | 2 |
| `g_log.swift` | 0 | 0 |

## New GameWorld properties

None.

## Findings

1. The three `g_log.swift` reads take `?? "(null)"` with no note. The C1 ruling puts the two-line note at the `obit` read only, and the R2 form at guide lines 337-339 puts no note at the argument. The coordinator can rule if the `g_log` reads need the note too.
2. `g_ICARUScb.swift` still holds 23 calls that pass a force-unwrapped `String?` (`targetname!`, `script_targetname!`, `classname!`, `NPC_type!`) to a `%s` of `G_DebugPrint` or a print call. The R2 ruling extends guide line 337 to every such site, but unit A-27 names only five sites, so the transcriptor did not change the other 23. `G_DebugPrint` evaluates its arguments before the `g_developer` test, so each of these unwraps traps where Raven prints `(null)`.
3. At `g_ICARUScb.swift:78`, Raven's `entNum` is uninitialized when `sscanf` reads no number, and the Swift reads slot 0. The R2 proof records this amendment. The transcriptor did not change it.
4. At A-08, Raven stores NULL into `*value` on the NULL path, and the Swift leaves `value` as it is. The H1 verdict rules this, because Raven's caller at `g_main.c:650-655` copies nothing on that path.
5. The A-20 lines agree with Raven's `g_combat.c:5461` and `5465` and with jka-rust. `maxtake` is `Int32` and `famt` is `Float`, so the `Promotion.swift` operators give a `Float` before the store.
