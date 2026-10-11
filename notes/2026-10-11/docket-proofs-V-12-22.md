# Docket proofs for rows V12 to V22

This record proves rows V12 to V22 of Part C of `phase-2-plan.md` against the working tree of `wave-0` on 2026-10-11, Raven's C under `oracle/codemp/game/`, the jka-rust tree in the submodule `jka-rust/`, `tools/oracle-closure/lookup.py`, and `docs/transcription.md`. The working tree holds the edits of the seven phase 2 transcriptors in flight, and a site line names the text at the time of the read. The guide lines are the lines of the committed guide, which the transcriptors do not edit. The build records cite guide lines from before the fix of review finding 1, which added two lines at 553-554, so a cite of line 554 in the records is line 556 now, and a cite of line 622 is line 624 now.

### V12. Do the words "the mirror of the next rule" on the `float` into `int` line still point at the right line?

Source. `rulings-build-guide.md:30`, Unruled item 2.

Sites. `docs/transcription.md:556`: "A `float` stored into an `int` takes `Int32(...)` at the store, the mirror of the next rule, so `ps.gravity = 1.0f` reads `ps.gravity = Int32(1.0)`. A compound store into an `int` from a `float` is ...". `docs/transcription.md:557`: "An `int` stored into a `float` with no operator between them takes `Float(...)` at the store, ...". Before phase 1, the two rules stood as the adjacent lines 541 and 542 of `3222d10`, in the same order.

Evidence. Phase 1 put four lines before the `float` into `int` line, not two: the A5 line 552, the two lines 553-554 of the review fix, and the B4 line 555. All four stand before line 556, and no line stands between 556 and 557. The N1 sentence went onto the end of line 556, after the words, and the R5 sentence onto the end of line 557. So "the next rule" is still the `int` into `float` store rule. Raven, jka-rust, and the types do not bear on this row.

Verdict: Premise true. The record counts two lines where four came in, but the count does not change the answer. Choice confirmed: the text stays as it is.

### V13. Does the R10 form at guide line 342 replace the sentence "A guard that does other work on the NULL path keeps a Port-note.", and what still keeps that Port-note?

Source. `rulings-build-guide.md:31`, Unruled item 3, and `review-rulings-build-1.md:70`, finding 3.

Sites. `docs/transcription.md:342` now ends with "An early-out whose arm does work before it leaves is a `guard` with Raven's test negated in his order and his arm in the `else`, `guard let terrain, terrain.inuse, terrain.s.eType == ET_TERRAIN else { ... }` for his `if (!terrain || !terrain->inuse || terrain->s.eType != ET_TERRAIN)`." The diff `3222d10..7728fd9` removes the old sentence from the same line. A grep for "other work", "does work", and "NULL path" over `Sources/`, `docs/`, and `tools/oracle-closure/*.py` finds only line 342. No standing Port-note cites the old sentence, and no Port-note reason text names a guard with work on the NULL path.

Raven. The R10 site is `ai_wpnav.c:3068-3074`, an arm that calls `G_Printf` and returns. The R10 ruling in `frame-path-walk.md:84` orders "Guide line 340 gains the form for an early-out whose arm does work". The ruling adds a form. It does not say that the old sentence goes.

jka-rust. `ai_wpnav.rs:2793-2804` tests `terrain_id.is_none()` first and reads through `ctx.entity(...)`. jka-rust has no Port-note shape, so it gives no answer.

Cases. The old sentence covered a NULL-path arm that does work. Three shapes of that arm exist. First, the arm does work and leaves, by `return`, `continue`, or `break`. The new form covers it, because a Swift `guard` else accepts each of these exits. Second, the arm does work and falls through, such as a store into the pointer. Then no bind is due, Raven's NULL test keeps its form for an optional (line 341 and the optional-parameter rule), and a later read takes the force unwrap of line 343. Third, Raven wraps the non-NULL block and the NULL arm is an `else`. The `if let ... { } else { }` of line 342 covers it. No `guard let ... else { continue }` exists in `Sources/JKAMP_GameLogic` today, so the exit by `continue` or `break` has no site yet.

Verdict: Premise true. Choice confirmed: the new form replaces the sentence, and no case keeps that Port-note. The three shapes above each have a form on lines 341 to 343.

### V14. Does `?? "(null)"` at guide lines 339-340 cover the `Debug_Printf` runtime-test case with no rule 19 note, so the eight `?? ""` arguments in `NPC_combat.swift` change?

Source. `rulings-build-guide.md:32`, Unruled item 4, and `review-rulings-build-1.md:86`, unruled 1.

Sites, four lines and eight arguments, unchanged from HEAD:

- `Sources/JKAMP_GameLogic/NPC_combat.swift:1315`: `Debug_Printf(debugNPCAI, DEBUG_LEVEL_INFO, &fmt, NPC!.targetname ?? "", newenemy!.targetname ?? "", vtos(newenemy!.client!.hiddenDir), vtos(diff), dot)`
- `NPC_combat.swift:1322`: `Debug_Printf(debugNPCAI, DEBUG_LEVEL_INFO, &fmt, NPC!.targetname ?? "", newenemy!.targetname ?? "", newenemy!.client!.hiddenDist)`
- `NPC_combat.swift:1434`: the same text as line 1315.
- `NPC_combat.swift:1442`: the same text as line 1322.

A fifth site appeared during this round. The npc transcriptor filled the A-01 hole at `Sources/JKAMP_GameLogic/NPC_utils.swift:680` as `G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "", GetStringForID(BSETTable, bset) ?? "", bs_name!)`. At HEAD the line was a Port-note with `Raven wrote: G_DebugPrint( WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", self->targetname, GetStringForID( BSETTable, bset ), bs_name )`. Its two `?? ""` arguments disagree with line 339 the same way. The line sits under `if 0 != 0`, Raven's `if (0)` at `NPC_utils.c:887`, so it never runs.

Raven. The four calls in `NPC_combat.c`:

- `NPC_combat.c:1581`: `Debug_Printf(&debugNPCAI, DEBUG_LEVEL_INFO, "%s saw %s trying to hide - hiddenDir %s targetDir %s dot %f\n", NPC->targetname, newenemy->targetname, vtos(newenemy->client->hiddenDir), vtos(diff), dot );`
- `NPC_combat.c:1591`: `Debug_Printf(&debugNPCAI, DEBUG_LEVEL_INFO, "%s saw %s trying to hide - hiddenDist %f\n", NPC->targetname, newenemy->targetname, newenemy->client->hiddenDist );`
- `NPC_combat.c:1724`: the same text as line 1581.
- `NPC_combat.c:1734`: the same text as line 1591.

`Debug_Printf` at `NPC_misc.c:10-35` returns when `cv->value < debugLevel` (line 16), then formats with `vsprintf (msg, fmt, argptr)` (line 31). So Raven reads the two names only when `debugNPCAI` is at least `DEBUG_LEVEL_INFO`. A NULL `targetname` is common, because most NPCs have no target name. For a NULL `%s` argument, each `vsprintf` Raven's game ran with prints `(null)`. The QVM build links `bg_lib.c`, whose `AddString` at `bg_lib.c:1146-1148` reads `if ( string == NULL ) { string = "(null)"; prec = -1; }`. The MSVC runtime of the DLL build and glibc both print `(null)` too. With `debugNPCAI 1` or more, Raven prints, for example, `(null) saw (null) trying to hide - hiddenDist 0.000000`. The Swift prints ` saw  trying to hide - hiddenDist 0.000000`.

jka-rust. `NPC_combat.rs:1436-1442`, `:1459-1464`, `:1615-1620`, and `:1640-1645` read `targetname_str()` and pass `.as_deref().unwrap_or_default()`, so jka-rust prints an empty name at these four sites. Elsewhere jka-rust prints `(null)`: `c_format.rs:29` and `:148` render `FmtArg::Str(None)` as `(null)`, `g_combat.rs:2342-2343` writes `obit = "(null)"`, and `g_log.rs:18` and `:502` name glibc's `(null)`. jka-rust is not consistent here.

Types. `lookup.py gentity_t targetname` gives `targetname: String?`, nil for a NULL pointer. `lookup.py sig Debug_Printf` gives `func Debug_Printf(_ cv: JKAMP.VmCvar, _ debugLevel: Int32, _ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...)`. `lookup.py sig G_DebugPrint` gives `func G_DebugPrint(_ level: Int32, _ format: String, _ args: any JKAShared.FormatArg...)`, and `GetStringForID` returns `String?`. `Sources/JKAShared/Format.swift:27-57` gives `FormatArg` to `Int32`, `Int`, `Float`, `Double`, `String`, `CharBuf`, `PooledString`, and `Bool`, and to no `Optional`, so a `String?` argument needs a fallback or an unwrap.

Guide and helpers. Line 339: "A `String?` that Raven passes to a `%s` takes `?? "(null)"` at the argument in place of the force unwrap, the text his `vsprintf` prints for NULL". Line 340: "The rule holds where a format call such as `Debug_Printf` reads the text only under a runtime test, because Swift evaluates the argument before the test and the unwrap would trap there." Before phase 1, old line 337 gave `?? ""` for exactly this runtime-test case, which is where the four lines got their form. The R2 ruling (`frame-path-walk.md:76`) extends the rule to every `String?` at a `%s`. The R2 proof site, `g_ICARUScb.swift:78`, carries no note, and the transcriptor's lines at `g_ICARUScb.swift:1822-1834` carry none. The C1 ruling (`frame-path-walk.md:19`) orders a two-line note at the `modNames` read, and `g_combat.swift:1972-1973` now reads `// Raven's table holds NULL past its 42 names, and his `%s` of NULL is undefined.` and `// The port prints "(null)", as the C runtimes do.`

Rule 19 (`docs/porting-rules.md:44`) asks for a note where the port picks one behavior for a behavior of Raven's that is undefined. ISO C leaves a NULL `%s` undefined, but every runtime Raven's game ran on, `bg_lib.c` among them, prints `(null)`. `?? "(null)"` gives that same text, so the port does not diverge, and the rule 19 note has nothing to record. The C1 note is a ruled exception at one site, and it stays as ruled.

Verdict: Premise true. Choice confirmed: the runtime-test case takes `?? "(null)"` with no note, and line 340 keeps the case as the reason the fallback replaces the unwrap there. Unit A-42 changes the four lines to:

```swift
Debug_Printf(debugNPCAI, DEBUG_LEVEL_INFO, &fmt, NPC!.targetname ?? "(null)", newenemy!.targetname ?? "(null)", vtos(newenemy!.client!.hiddenDir), vtos(diff), dot)
Debug_Printf(debugNPCAI, DEBUG_LEVEL_INFO, &fmt, NPC!.targetname ?? "(null)", newenemy!.targetname ?? "(null)", newenemy!.client!.hiddenDist)
```

The first form is lines 1315 and 1434, and the second is lines 1322 and 1442. The ruling should add the fifth site to A-42, in the same transcriptor's file, as ``G_DebugPrint(WL_VERBOSE, "%s attempting to run bSet %s (%s)\n", `self`.targetname ?? "(null)", GetStringForID(BSETTable, bset) ?? "(null)", bs_name!)``. To stop the next transcriptor from adding a note, line 339 can name the point in place: "A `String?` that Raven passes to a `%s` takes `?? "(null)"` at the argument in place of the force unwrap, with no comment, the text his `vsprintf` prints for NULL, `g_entities[entNum].script_targetname ?? "(null)"`." That edit keeps the line count, so no later guide line moves.

### V15. Does the B5 line join the old partial-size Port-note sentence into its next line?

Source. `rulings-build-guide.md:33`, Unruled item 5.

Sites. Before phase 1, `docs/transcription.md` read "A memset over a partial size keeps its Port-note, `memset(buff, 0, MAX_STRING_CHARS)` over the `char buff[MAX_STRING_CHARS*4]` of `BuildShaderStateConfig` among them." and then "A memset with a value the rules above do not give, or over a record with no view, keeps its Port-note too." Now line 179 reads "A memset of zero over the first N bytes of a `CharBuf` is `zero(count:)`, so `memset(buff, 0, MAX_STRING_CHARS)` ... is `buff.zero(count: MAX_STRING_CHARS)`." and line 180 reads "A memset over any other partial size, with a value the rules above do not give, or over a record with no view, keeps its Port-note."

Raven. `g_utils.c:44`, `memset(buff, 0, MAX_STRING_CHARS);`, over the `char buff[MAX_STRING_CHARS*4]` of `BuildShaderStateConfig`.

Helper. `Sources/JKAShared/CharBuf.swift:75-83`, `public mutating func zero<I: BinaryInteger>(count n: I)`, with a `precondition` that the count is not past the end.

Code. No site calls `zero(count:)` yet. The B5 site still stands as a Port-note at `Sources/JKAMP_GameLogic/g_utils.swift:109-110`: "Port-note: Raven's `memset(buff, 0, MAX_STRING_CHARS)` runs over bytes that are not one record with a view." Part A of the plan has no unit for it, and Part B counts it among the six `g_utils.swift` holes. The other memset Port-note, `w_saber.swift:2025-2026` over `G2Trace`, waits on the `G2Trace` type.

Evidence. The join keeps both old conditions and adds the word "other". The three items of line 180 are not parallel, "over any other partial size", "with a value the rules above do not give", and "over a record with no view". A reader can take the first comma as a qualifier and read "a partial size with a value the rules do not give" as one condition. Under that reading, a partial memset of zero over a record that is not a `CharBuf` has no rule.

Verdict: Premise true. Choice confirmed, with one wording amendment that keeps the line count. Line 180 reads: "A memset over any other partial size keeps its Port-note, and so does a memset with a value the rules above do not give or over a record with no view." The B5 site at `g_utils.swift:109-110` fills now with `buff.zero(count: MAX_STRING_CHARS)`, and the Part B entities transcriptor owns it.

### V16. Does the B6 line say that the index of `index_vtos` drops with its world property and its forward?

Source. `rulings-build-guide.md:34`, Unruled item 6.

Sites. `docs/transcription.md:419`: "A ring of static buffers that any function returns as a `String`, the two buffers of `va` and of `Info_ValueForKey` and the eight of `vtos`, is a local `CharBuf` of Raven's bound, `var s = CharBuf(32)`, and the index that picks one buffer drops, with its world property and its forward in the game module." Line 420: "Raven's ring keeps one result valid across a later call, and a returned `String` is already a copy." Line 421: "The function carries one comment line that says this." The code still holds the parts that drop: the property `var index_vtos: Int32 = 0` at `Sources/JKAMP_GameLogic/g_local.swift:790`, the forward at `g_utils.swift:612-617`, the comment `// Raven's static local `index` is `index_vtos`, because `tv` and `vtos` both declare an `index`.` at `g_utils.swift:631`, and three Port-notes at `:632-642` with the store `index_vtos = (index_vtos + 1) & 7` at `:643`.

Raven. `g_utils.c:653-665`: `static int index; static char str[8][32]; char *s;`, then `s = str[index]; index = (index + 1)&7;` and `Com_sprintf (s, 32, "(%i %i %i)", (int)v[0], (int)v[1], (int)v[2]); return s;`. `tv` at `g_utils.c:627-642` has its own `static int index` and ring of eight `vec3_t`, and the Swift `tv` at `g_utils.swift:608-610` already returns `vec3_t(x, y, z)` with no ring.

jka-rust. `g_utils.rs:769-777` formats into an owned `String` and cuts it at 32 bytes with `strncpyz_string(formatted.as_bytes(), 32)`, under a comment that says an owned `String` per call makes the ring unnecessary.

Helpers and guide. `Com_sprintf(_ dest: inout CharBuf, _ size: Int32, _ fmt: String, _ args: any FormatArg...)` at `Sources/JKAShared/q_shared.c.swift:956`. The B6 ruling (`frame-path-walk.md:18`) orders that `str`, `s`, `index`, `index_vtos`, and its forward drop, and that no `[CharBuf]` goes on `GameWorld`. The line covers that with "the index that picks one buffer drops, with its world property and its forward in the game module". The model `va` at `q_shared.c.swift:997-1000` carries one comment line of the same kind.

Verdict: Premise true. Choice confirmed: the line says so, and line 421 stays. When the Part B hole round fills `vtos`, the coordinator drops `g_local.swift:790`, the transcriptor drops the forward at `g_utils.swift:612-617`, and the comment at `:631` becomes the one comment line of line 421. The body reads:

```swift
func vtos(_ v: JKAShared.vec3_t) -> String {
    // Raven's ring of eight buffers keeps one result valid across a later call, and a returned `String` is already a copy.
    var s = CharBuf(32)
    Com_sprintf(&s, 32, "(%i %i %i)", Int32(v[0]), Int32(v[1]), Int32(v[2]))
    return String(s)
}
```

### V17. Where does the `char *` field form of Q1 go?

Source. `rulings-build-guide.md:35`, Unruled item 7.

Sites. `docs/transcription.md:624`, the third sentence: "A byte read of a `char *` field binds the field into a `CharBuf` on the arm where Raven reads it, `let message = CharBuf(ent.message!)`, and reads the byte, `message[0] == Int32(ascii: "@")`." The record says line 622. The line moved to 624 with the review fix of finding 1. The Q1 site still stands as a Port-note at `Sources/JKAMP_GameLogic/g_target.swift:210-212`, and its reason text says "The generated field is an `OpaquePointer?`", which the view no longer gives. `CharBuf(x!)` of a text already stands at `g_bot.swift:145` and `NPC_spawn.swift:1734`.

Raven. `g_target.c:132` and its block, `if (ent->message[0] == '@' && ent->message[1] != '@')`.

Types. `lookup.py gentity_t message` gives `message: String?`, nil for a NULL pointer.

Guide. Two places can hold the form. Line 624 is in "The C character buffer" and holds the parameter form and the text-local form, both of which convert a text to a `CharBuf` for a byte read. Lines 501-504 are "A `char *` at runtime" and hold the field as `String?`, the store, the copy, and the compare. The Q1 ruling (`frame-path-walk.md:66`) names "`CharBuf(field!)` at the site, bound on the arm where Raven reads the field, then the byte subscript", which is the same operation as the two forms on line 624. A transcriptor who meets a byte read looks for the byte-read rule, and line 624 is where the other two byte-read rules stand.

Verdict: Premise true. Choice confirmed: the form stays on line 624, beside the local form. The ruling cites line 624, not 622.

### V18. Does the A5 line say anything about `size` against `stride`?

Source. `rulings-build-guide.md:36`, Unruled item 8, `review-rulings-build-1.md:66`, finding 1, and `rulings-build-generators.md:96`, fix 1.

Sites. `docs/transcription.md:552`: "Raven's `sizeof(T)` stored into an `int` is `Int32(View.byteCount)`, so `pm->entSize = sizeof(gentity_t)` is `pm.entSize = Int32(Entity.byteCount)`." Line 553: "`byteCount` is `MemoryLayout<T>.size`, and C's `sizeof` is Swift's `stride`, so the form holds only where the size and the stride of `T` are equal." Line 554: "For `gentity_t` the two are 1832." The `byteCount` reads in the code: `g_main.swift:1081` (`Entity.byteCount`, `Client.byteCount`), `NPC_spawn.swift:1062` (`GNPC.byteCount`), `g_ICARUScb.swift:3173` (`Parms.byteCount`), `ai_main.swift:904` (`BotState.byteCount`), and `ai_wpnav.swift:393` and `:420` (`Wpobject.byteCount`).

Types. Every generated view gives `public static let byteCount = MemoryLayout<C>.size` and `public static let stride = MemoryLayout<C>.stride` over the imported C struct, for example `Sources/JKAMP_Game/Generated/Views/Entity.swift:28` and `:31` over `gentity_t`. `Sources/CJKAMP_Game/layout_asserts.h:2129` and `:3403` assert `sizeof(gentity_t) == 1832`, and `Tests/JKAMP_GameTests/LayoutTests.swift:9` checks `MemoryLayout<gentity_t>.size == 1832`. jka-rust `world/game_world.rs:24` names the same 1832.

Probe. A two-line program outside the repo, built with `swiftc -import-objc-header` (Apple Swift 6.4), imports `struct tp { double a; char b; };` and prints `MemoryLayout<tp>.size` and `.stride`. It prints `16 16`. A Swift struct with the same two fields prints `9 16`. Swift gives an imported C struct its Clang size, tail padding included, so `size`, `stride`, and C's `sizeof` are equal for every C record. The gap between `size` and `stride` exists only for a type that Swift lays out itself, and no view is such a type.

Evidence. The A5 proof said "`size` differs only by tail padding", and the review fix wrote that as a condition. The condition is true for every view, so the sentence warns about a case that cannot occur and asks every reader to check it.

Verdict: Premise true. Choice amended: line 553 states the fact and line 554 keeps the number, so no later guide line moves. Line 553 reads: "`byteCount` is `MemoryLayout<T>.size` over the imported C struct, and Swift keeps the C layout of an imported struct, tail padding included, so `size`, `stride`, and C's `sizeof` are equal." Line 554 reads: "For `gentity_t` the value is 1832, which `LayoutTests.swift` checks." The seven `byteCount` reads above stay as they are.

### V19. How does the A2 entry key a variable in `TYPES`, a table that held typedef names only?

Source. `rulings-build-generators.md:83`, the A2 item of "Unruled".

Sites. `tools/oracle-closure/rulings.py:157-164`: the header comment now reads "C typedef or file-scope variable -> the Swift type it is at every surface", and the entry `"gSiegeRoundWinningTeam": "Int32"` stands under three comment lines that name Raven's `qboolean` at g_saga.c:38 and g_main.c:1978, the team numbers, and ruling A2. `skeleton.py:505-510`, `map_variable`, reads `if var.name in TYPES:` first and sets `var.swift = TYPES[var.name]`. The output is `Sources/JKAMP_Game/Generated/Storage/GameVariables.swift:597-599`, `public var gSiegeRoundWinningTeam: Int32 = 0` under `/// Raven's `qboolean gSiegeRoundWinningTeam` of `g_saga.c`.`

Other readers of `TYPES`. `spelling.py:264` and `:426` look up a type spelling, `t.spelling`, and a variable name is never a type spelling, so the new key does not reach them. The oracle has no typedef named `gSiegeRoundWinningTeam`.

Raven. `g_saga.c:38`, `qboolean gSiegeRoundWinningTeam = qfalse;`, the extern at `g_main.c:1978`, and the store of a team number at `g_saga.c:688`.

Alternatives. `rulings.py` keeps other per-variable rulings in their own tables, `NEVER_NULL_VARS` (line 118), `HAND_VARS` (line 123), and `BYTE_STORAGE_VARS` (line 128). A separate `VAR_TYPES` would follow that pattern. But the A2 ruling (`frame-path-walk.md:8`) reads "`gSiegeRoundWinningTeam` is a TYPES entry in `rulings.py` as `Int32`", so the builder did what the ruling says, and the header comment now names both kinds of key.

Verdict: Premise true. Choice confirmed: the variable name keys `TYPES`, and `map_variable` reads it before every other shape. The ruling is the A2 text, and no change follows.

### V20. What shape does the A1 and D6 sig ruling take in `rulings.py`?

Source. `rulings-build-generators.md:84`, the A1 and D6 item of "Unruled".

Sites. `tools/oracle-closure/rulings.py:216` documents the kind: "`int_value` an Int32 by value for a `const void *` a qsort comparator reads as `*(int *)`, so the comparator is `(Int32, Int32) -> Int32`". Lines 253-259 hold the four rows `("SortClients", "a")`, `("SortClients", "b")`, `("SortRanks", "a")`, and `("SortRanks", "b")`, each `"int_value"`, under a comment that names Raven's two comparators, the hand `qsort`, and the rulings. `spelling.py:258-260` maps the kind to `Answer("Int32", "bare")`. `lookup.py sig SortRanks` gives `func SortRanks(_ a: Int32, _ b: Int32) -> Int32`, and `lookup.py sig SortClients` gives `private func SortClients(_ a: Int32, _ b: Int32) -> Int32`. The sort transcriptor has already changed the compiled signatures at `g_main.swift:1648` and `g_team.swift:1065` to the same text.

Raven. `g_team.c:1089-1091`, `static int QDECL SortClients( const void *a, const void *b ) { return *(int *)a - *(int *)b; }`, and `g_main.c:1624-1628`, `int QDECL SortRanks( const void *a, const void *b )` with `ca = &level.clients[*(int *)a];`.

jka-rust. `g_team.rs:1343`, `pub fn SortClients(a: &c_int, b: &c_int) -> c_int`, and `g_main.rs:883`, `fn SortRanks(world: *mut GameWorld, ia: c_int, ib: c_int) -> c_int`. jka-rust also gives each comparator `int` parameters.

Helper. `Sources/JKAMP_BG/bg_lib.swift:59`, `public func qsort(_ a: Slots<Int32>, _ n: Int32, _ cmp: (Int32, Int32) -> Int32)`, and `:53` for an `inout [T]`.

Alternatives. Every `PARAMS` row keys `(function, parameter)` and names one kind, and the kinds `key_path`, `table`, and `vec3_mut` follow the same shape. A set of comparator names would be a new table that `spelling.py` reads in a new place. The per-parameter rows use the existing path in `spelling.py` and say per parameter what the C type does not say.

Verdict: Premise true. Choice confirmed: the new `PARAMS` kind `int_value` with one row per parameter, four rows.

### V21. Does a function-pointer local whose type fits more than one callback field get a J1 thunk?

Source. `rulings-build-generators.md:85`, the J1 item of "Unruled".

Sites. `tools/oracle-closure/skeleton.py:806-850`, `collect_stores`. The docstring says "A local whose type fits more than one field names no field." The code builds `field_of_proto`, prototype spelling to the set of `gentity_s` callback fields of that prototype, and `stored_field` returns a field for a local only `if len(fields) == 1`. The output is `Sources/JKAMP_GameLogic/Generated/Callbacks.swift`, 215 thunks.

Raven. The callback fields at `g_local.h:285-291`: `think` and `reached` both have the prototype `void (*)(gentity_t *self)`, and the other five each have their own. The game oracle has two function-pointer locals in a body, `void (*func)(gentity_t *self, gentity_t *attacker, int damage);` at `NPC_spawn.c:105` and `void (*func)(gentity_t *self, gentity_t *other, trace_t *trace);` at `NPC_spawn.c:201`. Each fits one field, `pain` and `touch`. The other function-pointer declarations, at `FighterNPC.c:100` and `bg_pmove.c:9995` and `:10086`, are parameters of trace type, not locals of a callback type. No local of the `think` and `reached` prototype exists, so the rule has no site today.

jka-rust. `NPC_spawn.rs:79-117` returns `Option<EntPain>` and `Option<EntTouch>` enum values and has no local. It has no thunk shape, so it gives no answer.

Swift. `Sources/JKAMP_GameLogic/NPC_spawn.swift:35-43` still holds the `func` local as a Port-note. The J1 ruling (`frame-path-walk.md:47`) gives the local as ``var `func`: EntityPain?`` and the store as `` `func` = Pain.NPC_Jedi_Pain ``.

Evidence. A thunk sits in the namespace of one field, `Pain.NPC_Jedi_Pain`. For a local that fits two fields, the field is the one the function stores the local into, and the prototype alone cannot say it. A thunk in both namespaces would write a thunk that no field may need. With no thunk, the store stays a visible hole, and a ruling can name the field when a site appears.

Verdict: Premise true. Choice confirmed: such a local names no field and gets no thunk. The rule has no site in the oracle today.

### V22. Does the O4 overload copy the syscall body or forward to the first overload, and which callers does the rule check?

Source. `rulings-build-generators.md:86`, the O4 item of "Unruled".

Sites. `tools/oracle-closure/traps.py:198` calls `record_overload`, and `traps.py:289-334` writes it. The tag comes from Raven's parameter text by `re.search(r"/\*\s*struct\s+(\w+)\s*\*/", self.source.slice(p.extent))` at line 301. The body is one forward call, `{name}(...)`, with `{p.name}.handle` for the record parameter (lines 315-327). `callers_pass_record` at `traps.py:336-358` walks every function definition whose file is in the game folder and returns true when at least one call exists and every call hands that argument the address of the tagged struct. The output is `Sources/JKAMP_Game/Generated/g_syscalls.swift:1374-1378`:

```swift
/// Source: oracle/codemp/game/g_syscalls.c:845
/// Raven's `input` takes the address of a `struct bot_input_s` record at every call site, and this overload takes the view.
public func trap_EA_GetInput(_ client: Int32, _ thinktime: Float, _ input: BotInput) {
    trap_EA_GetInput(client, thinktime, input.handle)
}
```

The first overload at `:1370-1372` is `public func trap_EA_GetInput(_ client: Int32, _ thinktime: Float, _ input: OpaquePointer?)` with the body `Syscall.call(BOTLIB_EA_GET_INPUT, client, thinktime, input)`.

Raven. `g_syscalls.c:845`, `void trap_EA_GetInput(int client, float thinktime, void /* struct bot_input_s */ *input)`. The one caller is `ai_main.c:644`, `trap_EA_GetInput(bs->client, (float) time / 1000, &bi);`, and the Swift site is still a Port-note at `ai_main.swift:708`.

jka-rust. `ai_main.rs:646` calls `trap::EA_GetInput(` with the record. jka-rust has no generated overload to compare.

Types. `BotInput` conforms to `HandleView`, whose `handle` is an `OpaquePointer` (`Sources/JKAShared/Views/HandleView.swift:7`), and `BotInput.swift:22-24` gives the conversion both ways. The first overload takes `OpaquePointer?`, so `input.handle` passes with no cast.

Evidence. A forward keeps one `Syscall.call` per trap, so a change to the syscall number or the argument words changes one place. It matches the O4 ruling's words, "a second generated overload of `trap_EA_GetInput` that takes the view". The comment text is the only place Raven names the struct, because the C type is `void *`, so the rule must read the parameter text. `g_syscalls.c` belongs to the game module alone, so the game unit's callers are all of the trap's callers, and the bot code that calls `trap_EA_GetInput` is in the game folder. The check returns false for a trap with no caller, so no overload is written for a trap the module never calls.

Verdict: Premise true. Choice confirmed: the overload forwards to the first overload with `input.handle`, reads Raven's comment from the parameter text, and checks the game unit's callers only.
