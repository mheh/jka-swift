# Docket proofs for rows V34 to V38

This record proves rows V34 to V38 from the wave A reviews against the tree at 4308ee3, Raven's C under `oracle/codemp/game/`, the submodule `jka-rust/`, the drafter under `tools/oracle-closure/`, and `docs/transcription.md`.

### V34

Site. `Sources/JKAMP_GameLogic/FighterNPC.swift:603` and `:608`, `parentPS!.hackingTime = Int32(0.0)`. Raven: `FighterNPC.c:789` and `:797`, `parentPS->hackingTime = 0.0f;`.

Truth. True. `lookup.py playerState_t hackingTime` gives `int hackingTime -> hackingTime: Int32`. The value is the same in both forms. The shape is not a hand error. The drafter writes it on purpose: `tools/oracle-closure/spelling.py:479-481` converts a float literal stored into an `Int32` with `Int32({text})`, under the comment "Swift types a float literal as no integer, so Raven's `gravity = 1.0f` converts at the store". Guide line 556 of `docs/transcription.md` gives the same form as its example, `ps.gravity = 1.0f` reads `ps.gravity = Int32(1.0)`.

Count. `grep -rnE "Int32\(-?[0-9]+\.[0-9]*\)" Sources/JKAMP_GameLogic` gives 9 sites, and no other integer type shows the shape:

| Swift site | Text | Raven |
|---|---|---|
| `FighterNPC.swift:603` | `Int32(0.0)` | `FighterNPC.c:789` |
| `FighterNPC.swift:608` | `Int32(0.0)` | `FighterNPC.c:797` |
| `FighterNPC.swift:644` | `Int32(-500.0)` | `FighterNPC.c:843` |
| `FighterNPC.swift:648` | `Int32(500.0)` | `FighterNPC.c:848` |
| `FighterNPC.swift:653` | `Int32(500.0)` | `FighterNPC.c:854` |
| `g_items.swift:1066` | `sentry!.s.g2radius = Int32(30.0)` | `g_items.c:1046` |
| `g_active.swift:2187` | `client!.ps.gravity = Int32(1.0)` | `g_active.c:2454` |
| `g_active.swift:2195` | `client!.ps.gravity = Int32(1.0)` | `g_active.c:2465` |
| `g_misc.swift:1656` | `var add: Int32 = Int32(0.0)` | `g_misc.c:1755`, `int add = 0.0f;` |

Every literal is integral. No site stores a float literal with a fraction into an `int`. `gravity` and `g2radius` are `Int32` by `lookup.py`. `parentPS.speed` is a `Float`, so `FighterNPC.c:410` and `:443` are not in the set.

jka-rust. Every site writes the integer literal: `fighter_npc.rs:821` and `:827` `hackingTime = 0`, `:862`, `:865`, `:869` `gravity = -500` and `500`, `g_items.rs:1388` `g2radius = 30`, `g_active.rs:2656` and `:2667` `gravity = 1`, `g_misc.rs:1992` `let mut add: c_int = 0`.

Helpers. None needed. Swift takes an integer literal into an `Int32` with no conversion.

Guide. Line 556 gives `Int32(1.0)` as the form. No line gives the integer literal.

Verdict. Premise true, and the shape is a drafter rule, not a hand fix. A float literal with an integral value stored into an `int` is the integer literal, so the sites read `parentPS!.hackingTime = 0`, `parentPS!.gravity = -500`, `sentry!.s.g2radius = 30`, `client!.ps.gravity = 1`, and `var add: Int32 = 0 //,highest;`. The ruling changes `spelling.py:479-481` to write the integer text of the literal when its value is integral, and keeps `Int32({text})` for a literal with a fraction, where C truncates. Guide line 556 then reads: "A `float` literal with an integral value stored into an `int` is the integer literal, so `ps.gravity = 1.0f` reads `ps.gravity = 1`. Any other `float` stored into an `int` takes `Int32(...)` at the store, the mirror of the next rule." The second sentence of line 556, the compound store, stays as it is. The 9 sites change by hand or by a draft refresh of the 9 lines.

### V35

Site. `Sources/JKAMP_GameLogic/g_main.swift:1648-1653`, `func SortRanks(_ a: Int32, _ b: Int32) -> Int32 {`, `var ca: Client?`, `var cb: Client?`, `ca = level.clientsSlots[a]`, `cb = level.clientsSlots[b]`, and `ca!` or `cb!` at all 20 reads to line 1702. Raven: `g_main.c:1624-1628`, `gclient_t *ca, *cb;`, `ca = &level.clients[*(int *)a];`, `cb = &level.clients[*(int *)b];`.

Truth. True. Each local has one store, a slot address, and no NULL store or NULL test. The `!` never traps, because `level.clientsSlots` (`Sources/JKAMP_Game/Generated/Views/Level.swift:72`) returns a plain `Client` and traps itself with "clients is NULL" if the pointer is NULL. `lookup.py gclient_t` gives the view `JKAMP_Game.Client`. `lookup.py level_locals_t clients` gives `clients: Client?`.

Drafter rule. The rule that the review calls rule 11 is drafter rule 2 of `rulings-build-generators.md`, from R7: `tools/oracle-closure/draft_declarations.py:410-413` and `plain_entity` at `:442`. It does not cover `SortRanks` on three counts:

1. It tests `record == "gentity_t"`, so a `gclient_t *` local stays `Client?`.
2. It needs an initializer. `SortRanks` declares the locals with no initializer and stores them in the next statements. The "Unruled" section of `rulings-build-generators.md` says a local with no initializer stays optional, because Swift's definite-initialization check can refuse a `let` set in branches.
3. `slot_address` at `:422-433` needs a file-scope `CONSTANTARRAY` as the base. `level.clients` is a pointer field of a file-scope struct, which the Swift reads through the `Slots` accessor `level.clientsSlots`.

Spread. `grep "= &level\.clients\[" oracle/codemp/game/*.c` gives 21 lines. 16 of them are stores into a `gclient_t *` local: `g_active.c:3760`, `g_cmds.c:48`, `:199`, `:651`, `g_items.c:2060`, `g_combat.c:2799`, `g_main.c:1265`, `:1383`, `:1439`, `:1627`, `:1628`, `:1836`, `:1849`, `:2275`, `g_svcmds.c:458`, and `:468`. The other five are a field store (`g_client.c:3309`), a compare (`g_arenas.c:70`), two `playerState_t *` locals (`g_main.c:2988-2989`), and a comment (`g_main.c:1438`). GameLogic holds 42 `var <name>: Client?` declarations. This record does not prove which of the other 14 stores fit the "no NULL store, no NULL test" test.

jka-rust. `jka-rust/crates/mp/game/src/g_main.rs:883-886` takes `(ia: c_int, ib: c_int)` and binds `let ca = (*world).clients.as_mut_ptr().add(ia as usize)`, a raw pointer with no NULL test, and reads `(*ca).sess`.

Guide. No line of `docs/transcription.md` states the R7 form, and no line names a `gclient_t *` local. Line 439 names `level.clientsSlots` as the accessor of a pointer field Raven indexes.

Verdict. Premise true, and rule 2 does not reach the site as built. The ruling extends drafter rule 2 in two steps: the record test takes `gclient_t` beside `gentity_t`, and `slot_address` takes `&level.clients[i]`, the subscript of a pointer field with a `<name>Slots` accessor. A local with no initializer whose stores are all slot addresses and whose first store comes before every read in straight-line code is a plain local with no initializer, `let` for one store and `var` for more, and the compile gate checks the definite initialization. `SortRanks` then reads:

```swift
func SortRanks(_ a: Int32, _ b: Int32) -> Int32 {
    let ca: Client
    let cb: Client

    ca = level.clientsSlots[a]
    cb = level.clientsSlots[b]
```

and every read drops its `!`, `ca.sess.duelTeam == DUELTEAM_LONE && ca.sess.sessionTeam != TEAM_SPECTATOR`. If the user wants the smaller ruling, the extension takes the record test and the `level.clients` base only, and `SortRanks` changes by hand to the lines above, since it is the one site with no initializer that this record proves.

### V36

Site. `Sources/JKAMP_GameLogic/g_items.swift:2458`, `respawn = Int32(respawn + crandom() * ent.random)`. The row named line 2386. The line moved to 2458 in wave A. Raven: `g_items.c:2601`, `respawn += crandom() * ent->random;`, with `int respawn`.

Truth. True. `q_shared.h:1591` is `#define random() ((rand () & 0x7fff) / ((float)0x7fff))`, a `float`. `q_shared.h:1592` is `#define crandom() (2.0 * (random() - 0.5))`, a `double`, because `2.0` and `0.5` are double literals. C computes `respawn + crandom() * ent->random` in double and truncates once into `int`. `Sources/JKAMP_BG/bg_lib.swift:193` gives `public func crandom() -> Float { Float(2.0 * (Double(random()) - 0.5)) }`, so the Swift narrows the macro to `Float` at the return, and the Promotion operators then multiply and add in float. `lookup.py gentity_t random` gives `random: Float`.

Two losses occur:

1. The return. For 5456 of the 32768 values of `rand() & 0x7fff`, the double `2.0 * (r - 0.5)` has no exact `Float`, because `r` below 0.25 carries more low bits than the result can hold.
2. The arithmetic. Even with an exact `crandom()`, the float product and sum round where C's double does not. A test over `respawn` in 5 to 180 and `ent->random` in 0.1 to 12.5 gives 18 different results in 3932160 cases. Example: `respawn = 10`, `ent->random = 4.2`, `rand() & 0x7fff = 28086`. C computes `12.999999935` and stores 12. The Swift computes `13.0` in float and stores 13. With integral `ent->random` values, 1 to 60, the one difference found gives -3 against -4, and both clamp to 1 at `g_items.c:2602`.

Spread. GameLogic holds 28 `crandom()` texts and Raven holds 28 in `oracle/codemp/game/*.c`. One, `g_items.swift:2783`, is inside Raven's `/* */` block, so 27 sites are live. No other target calls `crandom()`. GameLogic holds 57 `random()` texts against Raven's 57. `random()` is `float` in C, so its `Float` return is correct, and the double-literal rule at guide lines 538-549 covers a `random()` term beside a double literal. Three `crandom()` samples:

1. `g_target.swift:117`, `ent.nextthink = Int32(level.time + (ent.wait + ent.random * crandom()) * 1000)`. Raven `g_target.c:88`, `ent->nextthink = level.time + ( ent->wait + ent->random * crandom() ) * 1000;`. C computes the whole sum in double. The Swift computes in float.
2. `g_weapon.swift:621`, `angs[PITCH] += crandom() * BLASTER_SPREAD`. Raven `g_weapon.c:461`, with `#define BLASTER_SPREAD 1.6f` at `g_weapon.c:25`. C computes `angs[PITCH] + crandom() * 1.6f` in double and narrows at the store. The Swift computes in float.
3. `NPC_AI_Rancor.swift:103`, `TIMER_Set(NPC!, "patrolTime", Int32(crandom() * 5000 + 5000))`. Raven `NPC_AI_Rancor.c:97`. C computes in double and converts at the `int` parameter. The Swift computes in float.

jka-rust. `jka-rust/crates/native/math/src/rng.rs:212` gives `pub fn crandom(&mut self) -> f64 { 2.0 * (self.random() as f64 - 0.5) }`, with a doc that says the macro's C type is `double` and every expression stays double until it narrows at a float store. `jka-rust/crates/mp/game/src/g_items.rs:3384-3387` reads `respawn = (respawn as f64 + ctx.world.bg_state.rng.crandom() * random) as c_int;` with `let random = ctx.entity(ent).random as f64`. The second type in the same file, `QRand` at `rng.rs:338`, has an `f32` `crandom`, and the game site does not call it.

Helpers. `crandom()` at `bg_lib.swift:193` is the only one. No `Double` form exists.

Guide. Line 293 names `crandom()` in `bg_lib.swift` and gives no type. The double-math rule at lines 538-549 asks for `Double` on each operand and one conversion at the store, and line 549 names a macro constant that expands to a double literal. It does not name a function-like macro of double type, and the `Float` return hides the double from the drafter: `arith_kind` in `draft_expressions.py` reads the overlay's return type for Raven's macros.

Verdict. Premise true, and the N1 form keeps float arithmetic. The form that gives Raven's double arithmetic is a `crandom()` that returns `Double`, the C type of the macro, as jka-rust does:

```swift
/// Source: oracle/codemp/game/q_shared.h:1592
public func crandom() -> Double {
    2.0 * (Double(random()) - 0.5)
}
```

The site then reads `respawn = Int32(Double(respawn) + crandom() * Double(ent.random))`, under the double-math rule. The 27 live sites change by the same rule, for example `ent.nextthink = Int32(Double(level.time) + (Double(ent.wait) + Double(ent.random) * crandom()) * 1000)` and `angs[PITCH] = Float(Double(angs[PITCH]) + crandom() * Double(BLASTER_SPREAD))`. The Rancor site keeps its text, because `5000` takes the `Double` type. Guide line 549 gains: "A function-like macro whose C type is `double`, `crandom()`, returns `Double`, and its sites take the same widening." Every `Float`-typed `crandom()` site fails to compile after the change, so the compile gate lists the full set. If the user rules for one site alone, `Int32(Double(respawn) + Double(crandom()) * Double(ent.random))` fixes the arithmetic loss but not the return loss.

### V37

Site. `Sources/JKAMP_GameLogic/g_vehicles.swift:2131`, `:2138`, `:2150`, and `:2160`, `case SHIPSURF_FRONT:`, `case SHIPSURF_BACK:`, `case SHIPSURF_RIGHT:`, `case SHIPSURF_LEFT:`. Raven: `g_vehicles.c:3115` `case SHIPSURF_FRONT: //break the nose off`, `:3122` `case SHIPSURF_BACK: //break both the bottom wings off for a backward impact I guess`, `:3134` `case SHIPSURF_RIGHT: //break both right wings off`, `:3145` `case SHIPSURF_LEFT: //break both left wings off`. The same file drops `g_vehicles.c:2966` `case 3://destroyed`, `:2994` `case 2://heavy only`, `:3017` `case 1://light only`, and `:3027` `case 0://no damage`, at `g_vehicles.swift:1999`, `:2026`, and `:2047`, and at `:2057`, where the drafter joins `case 0` into the `default` arm and writes `default:` alone.

Truth. True, and the drafter drops the comment. `switch_statement` at `tools/oracle-closure/draft_statements.py:1016-1092` writes each arm head as `[f"{pad}{label}:"]` at line 1077 with no `self.trailing(...)`. The gaps it reads, `self.gap(label_line, ...)`, start after the label line, so the text after the colon on that line is never read. Other statements keep their trailing comment through `trailing` at `:199-208`, behind the `TRAILING` mark that prints as one space.

Count. A scan of `oracle/codemp/game/*.c` for a `case` or `default` label with a trailing `//` gives 663 lines in 22 files, 653 `case` and 10 `default`. 418 of the 663 stand next to another label, so the drafter joins them into one `case A, B:` arm. GameLogic holds 10 such lines, for example `g_combat.swift:4696` and `NPC_combat.swift:470`, which transcriptors kept by hand. Per file: `g_vehicles` 8 in Raven and 0 in Swift, `g_combat` 49 and 1, `w_saber` 7 and 1, `NPC_combat` 16 and 4. Some of the 663 lines sit in `#if 0` blocks or in code the port does not build, so 663 is the upper bound.

jka-rust. Not proved. jka-rust rewrites switches as `match` arms, and the row asks about the Swift drafter.

Guide. No line of `docs/transcription.md` names a comment on a `case` line. The house rule that Raven's comments stay at his lines covers it.

Verdict. Premise true. The drop is a drafter defect, and the fix is a drafter rule. An arm with one label keeps Raven's comment after the colon, `case SHIPSURF_FRONT: //break the nose off`, through the `TRAILING` mark. An arm that joins labels writes one label per line when any label carries a comment, with the comment after its comma:

```swift
case BOTH_A7_KICK_F, //these kicks attack, too
     BOTH_A7_KICK_B:
```

The ruling also names how the comments reach the bodies already filled. A draft refresh moves only the arm heads, so a writer can splice the heads in each file, about 650 lines over 22 files, or the user can rule the fix for new drafts only and leave the filled files as they are.

### V38

Site. `Sources/JKAMP_GameLogic/g_ICARUScb.swift:63`, `var entNum: Int32 = 0`, then `:66` `sscanf(text, "%d", &entNum)`, `:74-76` the range test, and `:78` the print. Raven: `g_ICARUScb.c:303-316`, `int entNum;` with no initializer, `sscanf( text, "%d", &entNum );`, and `if ( ( entNum < 0 ) || ( entNum > MAX_GENTITIES ) ) entNum = 0;`.

The amendment. The R2 proof in `docket-proofs-R.md` reads: "One amendment: in Raven, `entNum` is uninitialized when `sscanf` reads no number, so his slot is not always 0." It corrects the proof's own claim that a text with no number reads slot 0. It is a fact about Raven, not a change to the R2 form. The R2 verdict and the R2 ruling at `frame-path-walk.md:76` name only `?? "(null)"`, and line 78 has that form now.

Truth. The amendment is true, and it is still open in one point. When `sscanf` reads no number, Raven reads a stack value that the C standard does not define, and the Swift reads slot 0. That is a read of uninitialized memory, so `docs/porting-rules.md` rule 19 applies: "Pick the one defined behavior, note it in at most two lines at the site." The Swift picks 0, which is correct. No note stands at line 63. `Sources/JKAShared/Scan.swift:196-204`, the `inout Int32` overload of `sscanf`, leaves `n` as it is when it reads no number, so the 0 stays.

jka-rust. `jka-rust/crates/mp/game/src/g_ICARUScb.rs:84-88` parses the first word and takes `.unwrap_or(0)`, the same 0 with no note.

Helpers. None needed.

Guide. Guide line 362 gives the form for a slot "zero at entry where Raven's was uninitialized". The drafter writes `= 0` for an addressed local with no initializer at `draft_declarations.py:449-452`, and its Python comment names rule 19, but it emits no comment line into the Swift.

Verdict. Premise true. The open item is the rule 19 note, not a code change. The site reads:

```swift
            // Raven's `entNum` is uninitialized, and he reads a stack value when `sscanf` finds no number.
            // The port starts it at 0, so that print names slot 0.
            var entNum: Int32 = 0
```

One more point under the same rule: the test `entNum > MAX_GENTITIES` lets 1024 through, and `g_entities` holds 1024 slots (`GameStorage.swift:764`). For a text that starts with 1024, Raven reads past the end of the table, and the `Slots` subscript of the Swift traps. This record does not trace whether any `WL_DEBUG` caller can print 1024 first, and the ruling can leave this point to a later row.
