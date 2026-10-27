# Phase 2, wave A, the saber record

The transcriptor "saber" owns `Sources/JKAMP_GameLogic/w_saber.swift` and `Sources/JKAMP_GameLogic/g_active.swift`. The units are A-03, A-04, A-05, A-06, A-21, and A-22 of `phase-2-plan.md`. The line numbers before are the lines of `wave-0` at a1b6196.

## Sites

| File:line before | Unit | Row | What the body has now |
|---|---|---|---|
| `w_saber.swift:458` | A-03 | E1 | `var alwaysBlock = [[Bool]](repeating: [Bool](repeating: false, count: MAX_BLADES), count: MAX_SABERS)` |
| `w_saber.swift:488` | A-03 | E1 | `alwaysBlock[i][j] = false` |
| `w_saber.swift:497` | A-03 | E1 | `alwaysBlock[i][j] = true` |
| `w_saber.swift:508` | A-03 | E1 | `alwaysBlock[i][j] = true` |
| `w_saber.swift:513` | A-03 | E1 | `alwaysBlock[i][j] = false` |
| `w_saber.swift:595` | A-03 | E1 | `if !alwaysBlock[j][k] { k += 1; continue }` on four lines, under Raven's comment |
| `w_saber.swift:1010` | A-04 | E3 | The Port-note and the marker become the one comment line of the ruling, and the copy and the call stay |
| `w_saber.swift:2102` | A-05 | E4 | `var d1 = vec3_t()` |
| `w_saber.swift:2105` | A-05 | E4 | `var d2 = vec3_t()` |
| `w_saber.swift:2110-2113` | A-05 | E4 | The copies `var fwd = fwd` and `var right = right` and their two comment lines drop |
| `w_saber.swift:2124` to `:2151`, 8 stores | A-05 | E4 | `d1 = fwd`, `d2 = invRight`, `d1 = fwd`, `d2 = right`, `d1 = right`, `d2 = fwd`, `d1 = right`, `d2 = invFwd` |
| `w_saber.swift:2157` to `:2198`, 12 reads | A-05 | E4 | `_VectorMA(a, radius / 2.0, d1, &faces[i].vN)`, with `-radius / 2.0` where Raven wrote `-radius/2.0f` |
| `w_saber.swift:4869` | A-06 | E5 | The `var jump` flag form of the ruling, with Raven's three comments on the two arms |
| `w_saber.swift:1961` | A-21 | N1 | `totalDamage = Int32(totalDamage * damageFactor)` |
| `w_saber.swift:3840` | A-21 | N1 | `dmg = Int32(dmg * g_saberDamageScale.value)` |
| `w_saber.swift:4337` | A-21 | N1 | `dmg = Int32(dmg * 0.2)` |
| `g_active.swift:303` | A-22 | N1 | No change |

No hole is left in the six units. No unit needs a new `GameWorld` property.

## Port-note counts

| File | Before | After |
|---|---|---|
| `w_saber.swift` | 38 | 8 |
| `g_active.swift` | 10 | 10 |

The 30 filled Port-notes are 6 of E1, 1 of E3, 22 of E4, and 1 of E5.

## Findings

1. A-22 is no change. Raven wrote `other->splashRadius = (float)(self->r.maxs[0] - self->r.mins[0])/4.0f;` at `g_active.c:332`. The store is a plain store, not a compound store, and the `(float)` cast is Raven's. The line `other.splashRadius = Int32(Float((self.r.maxs[0] - self.r.mins[0])) / 4.0)` keeps its form.
2. At `w_saber.swift:4337`, the literal `0.2` takes the `Float` type through the `(Int32, Float)` operator of `Promotion.swift`. This agrees with Raven's `0.2f`.
3. E5 keeps Raven's dead store into `dot1`, as the ruling orders. jka-rust drops `dot1` at `w_saber.rs:6759`. Both stores are read on the next line, so the compiler reports nothing.
4. The E4 condition holds over the whole function. No statement of `G_BuildSaberFaces` writes `fwd`, `right`, `invFwd`, or `invRight` after `VectorInverse`.
5. The sites at `w_saber.swift:3787` and `:3789` read `Int32(ceil(Float(dmg) * ...))`. Raven wrote the `(float)` cast there at `w_saber.c:4416` and `:4421`, so they are not N1 sites and stay.
