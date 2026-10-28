# Ruling X4, the by-number read outside a pm function

## The ruling

Ratified 2026-10-27: a bg body's `&g_entities[n]` outside a pm function reads the game by number through the channel.

The defect: `BG_MySaber` read `pm.entity(at: clientNum)`, and the pmove stride trapped with "entSize is 0" on the first frame after a client spawn, because no Pmove had run. The backtrace is G_RunFrame, WP_SaberPositionUpdate, G_UpdateClientAnims, BG_SaberStartTransAnim, BG_MySaber. Raven's `PM_BGEntForNum` at `bg_pmove.c:178` asserts outside a pm function, so the stride is wrong there by his own rule.

## Part 1, the read sweep and the channel

`Table.names_pm` at tools/oracle-closure/table.py:590 is true when a body names the file-scope `pm`. The read sweep at table.py:500 sets `by_number` for a bg function whose body never names `pm`. `Table.chain` at table.py:602 and table.py:621 then gives the `entities` root to a local Raven set to `&g_entities[n]`, so each read through it is an indexed read with `entityNum`.

The new read `ent->inuse` shares its short name `bgEntityInuse` with the view form. The generator's collision rule gives each read of a group its long name, and the long name of the `entities` root is `bgEntityAt<Field>`. So the hook is `bgEntityAtInuse(of:)`, not `bgEntityInuse(of:)`. The view form keeps `bgEntityInuse(_:)`, because its long name is the same as its short name. A Swift overload of one name is not possible here, because the `BgCallbacks` struct holds one closure property per name.

The channel writes the hook at Sources/JKAMP_BG/Generated/bg_callbacks.swift:115 and :370, and the game install at Sources/JKAMP_GameLogic/Generated/BgChannel.swift:181 reads `g_entities[Int(entityNum)].inuse`.

## Part 2, the draft

`game_chain` at tools/oracle-closure/draft_classification.py:578 passes `by_number` to the chain for a bg function that never names `pm`. The declaration at tools/oracle-closure/draft_declarations.py:397 drops a `gentity_t *` local set to `&g_entities[n]` in such a function, because every read through it takes the number. A use of the local other than through a field is a hole.

`client_bind` at tools/oracle-closure/draft_statements.py:1117 reads Raven's by-number `ent->client` test as the bind of the record read his then arm shares, because `bgClientSaber` hands back nil where the game's client is NULL. tools/oracle-closure/bodies.py:312 holds the bound reads, and `optional_base` at draft_classification.py:673 drops the `!` on a bound local.

`entity_slot` keeps `pm.entity(at:)` for a direct argument, `NPC_SetAnim(&g_entities[n], ...)`. A by-number form for a call argument needs a by-number hook of the callee, and the ruling adds no such name. See Blocked items.

## Part 3, the hand site

Sources/JKAMP_BG/bg_saber.swift:2992 takes the draft's form. The draft prints `bgEntityAtInuse(of:)` in place of the expected `bgEntityInuse(of:)`, for the reason in part 1. The draft also keeps its two notes on Raven's double `model` test. The rest matches the expected text.

```swift
    //returns a pointer to the requested saberNum
    if bgEntityAtInuse(of: clientNum), let saber = bgClientSaber(of: clientNum, at: saberNum) {
        // Raven tests `!ent->client->saber[saberNum].model` and `!ent->client->saber[saberNum].model[0]`.
        // Both read as the same Swift test, so the draft writes it once.
        if saber.model.isEmpty {
            //don't have saber anymore!
            return nil
        }
        return saber
    }

    return nil
```

## The bg sites of `&g_entities[`

- bg_saber.c:1119, `PM_SaberLockLoseAnim`: the body never names `pm`. The site is a call argument, so the stride stays. The hand file did not change (bg_saber.swift:608). See Blocked items.
- bg_saber.c:1180, `PM_SaberLockResultAnim`: names `pm`, the stride stays. The hand file did not change (bg_saber.swift:662).
- bg_saber.c:1192, `PM_SaberLockResultAnim`: the line is inside Raven's `/* */` comment, so no code reads it.
- bg_saber.c:2157, `PM_CheckPullAttack`: names `pm`, the stride stays. The hand file did not change.
- bg_saber.c:4104, `BG_MySaber`: never names `pm`, so it changes. The hand file changed (bg_saber.swift:2992).
- bg_pmove.c:4242, `PM_GroundTrace`: names `pm`, the stride stays. The hand file did not change.
- bg_pmove.c:4450, `PM_CheckDuck`: names `pm`, the stride stays. The hand file did not change.
- bg_slidemove.c:56 and :462, `PM_VehicleImpact`: names `pm`, the stride stays. The hand file did not change.
- bg_slidemove.c:606 and :613, `PM_ClientImpact`: names `pm`, the stride stays. The hand file did not change.

## Snapshot moved files

`snapshot.py --out /tmp/x4-before` ran before the first tool change, and `--out /tmp/x4-after` after the last draft change, 370 files each. Three files moved: bodies/bg_saber.swift (the `BG_MySaber` draft only), channel/bg_callbacks.swift, and channel/BgChannel.swift. No other file moved. After the second snapshot, one hole message text in draft_declarations.py:397 became shorter, and no draft reaches that hole.

## Counts

- Tool unit tests: 82 run, OK, 16 skipped.
- channel.py: 30 straps, 52 callbacks, 82 hooks, 0 TODO markers. `git diff --stat` shows only the two Generated channel files from it, 12 insertions.
- swift build: 0 errors.
- swift test --no-parallel: 112 tests in four binaries, 84, 14, 13, and 1, all passed.
- tools/load-test.sh: exit 0.

## Blocked items

- bg_saber.c:1119, `PM_SaberLockLoseAnim`, never names `pm`, so the ruling's criterion puts it outside pm scope. The site passes `&g_entities[genemy->clientNum]` to `NPC_SetAnim`, which takes a `BgEntity`, and the channel has no by-number form of `NPC_SetAnim`. The stride stays. The only caller is `PM_SaberLockResultAnim`, which runs under Pmove, so the stride holds a valid `pm` at run time. A by-number form needs a new hook name, which needs a ruling.
