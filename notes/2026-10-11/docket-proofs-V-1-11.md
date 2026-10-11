# Docket proofs for rows V1 to V11

This record proves rows V1 to V11 of Part C of `phase-2-plan.md` against the working tree of `wave-0` after a1b6196, Raven's C under `oracle/codemp/game/`, the submodule `jka-rust/`, `tools/oracle-closure/lookup.py`, the views, and `docs/transcription.md`. Seven transcriptors edit files under `Sources/JKAMP_GameLogic` while this record is written, so a line number in those files can move. No row of V1 to V11 touches a file of that wave. A line number in `docs/transcription.md` is "guide N".

### V1. Where does the `at:` overload of `RemoveColorEscapeSequences` (O5) live, since the function is internal to `JKAMP_GameLogic`?

Source. `rulings-build-helpers.md:23`, helper 12 at `:18`.

Sites. `Sources/JKAMP_GameLogic/ai_main.swift:750`, the base `func RemoveColorEscapeSequences(_ text: inout JKAShared.CharBuf)`, internal, with `/// Source: oracle/codemp/game/ai_main.c:674`. `ai_main.swift:773-781`, the overload `func RemoveColorEscapeSequences(_ text: inout JKAShared.CharBuf, at offset: some BinaryInteger)`, with two doc lines and no `Source:` line. Its body takes the suffix `text[start...]`, calls the base, and writes the suffix back byte by byte. The one caller is still a hole: `ai_main.swift:813`, the `Raven wrote:` line of the `trap_BotGetServerCommand` loop of `BotAI`.

Raven. `ai_main.c:674-687` defines the function, and `ai_main.c:724` calls it once, `RemoveColorEscapeSequences( args )`, where `args` points one byte past the space in `buf`. No other file calls it.

jka-rust. `crates/mp/game/src/ai_main.rs:700` defines `RemoveColorEscapeSequences(text: *mut c_char)` in the same file as Raven, and `:754` passes the raw pointer `args`. No overload exists there, because a raw pointer carries the offset.

Types and helpers. The base is not `public`, so a file in `JKAShared` or `JKAMP_BG` cannot see it, and `JKAShared` cannot hold the overload. The overload body is the same body as the three `at:` overloads in `Sources/JKAShared/q_shared.c.swift`: `Q_strncpyz` at `:860`, `Q_strcat` at `:891`, and `Com_sprintf` at `:974`. Each one sits beside its base and carries no `Source:` line. `CharBuf.swift:62` gives the suffix subscript `text[start...]`.

Guide. Guide 659 gives a `memcpy` at an offset as the `at:` form of `strncpy`. No guide line names where a hand overload of a game function lives. The D7 forward of `G_RadiusList` sits beside its function at `g_utils.swift:375`.

Draft tools. `draftcheck.py:71-89` keys each function of a hand file by its `/// Source:` line and splices a draft over the span from that line to the first bare `}`. The O5 overload has no `Source:` line and stands after the closing brace of the base, so the splice never reads or replaces it. The D7 forward at `g_utils.swift:374` carries the same `Source:` line as the base at `:307`, so `functions()` keys Raven line 252 to the forward and hides the base. A read-only run of `functions()` on the file confirms the key `252 -> (373, 381)`. That is D7 ground, outside this row, and V10 meets the same fault.

Verdict: The premise is true. The function is internal to `JKAMP_GameLogic`, so the overload can live only in that target, and the file of the function is the place Raven's own layout and jka-rust give. The choice is confirmed as it stands: the overload stays beside the base in `ai_main.swift`, with its two doc lines and no `Source:` line, as the three `at:` overloads of `q_shared.c.swift` do. The O5 caller then reads `RemoveColorEscapeSequences(&buf, at: args!)` as the walk gives it.

### V2. How does the `at:` overload of `Com_sprintf` (L2) pass on its variadic list, which Swift cannot forward?

Source. `rulings-build-helpers.md:24`, helper 10 at `:16`.

Sites. `Sources/JKAShared/q_shared.c.swift:974-983`. The body takes the suffix, then `Com_sprintf(&suffix, size, "%s", JKAShared.format(fmt, args))` under two comment lines, `// Swift cannot pass a variadic list on, so the base form prints the formatted text through one %s.` and `// That gives the same bytes and the same length checks.`, then the write-back. The base at `:956-969` formats with `strcpy(&bigbuffer, JKAShared.format(fmt, args))`, traps through `Com_Error` past 32000 bytes, prints the overflow line when `len >= size`, and copies with `Q_strncpyz`. The one caller is the L2 hole of `UpdateIPBans`, `g_svcmds.swift:103-104`, still a Port-note.

Raven. `g_svcmds.c:121-122`, `Com_sprintf( iplist + strlen(iplist), sizeof(iplist) - strlen(iplist), "%i.%i.%i.%i ", b[0], b[1], b[2], b[3])`. Raven's `Com_sprintf` at `q_shared.c:985` formats with `vsprintf` into `bigbuffer` and copies with `Q_strncpyz`.

jka-rust. `crates/mp/game/src/g_svcmds.rs:114-127` drops the offset and appends to a `String` with `push_str(&format_ip(...))`. It gives no parity point for the forward.

Helpers. `Format.swift:65`, `format(_ fmt: String, _ args: [any FormatArg]) -> String`, takes the array, so every variadic wrapper in the port calls it once: `g_main.swift:791`, `:796`, `:1272`, `:2216`, `g_ICARUScb.swift:51`, and the base itself at `q_shared.c.swift:961`. The `%s` arm of `format` at `Format.swift:131-140` cuts only under a precision and pads only under a width. With the bare `"%s"`, the text passes through unchanged, so `len` and the bytes in `bigbuffer` are the same as in a direct call.

Guide. No line covers a variadic forward. The precedent is the code above.

Verdict: The premise is true. Swift has no splat of a variadic parameter, and the base form is variadic. The choice is confirmed. The `%s` forward reuses the base with its two checks and gives the same bytes, because `format("%s", [text])` is `text`. An array core, `Com_sprintf(_:_:_:argList:)`, would give the same result but adds a second public entry point for one caller. The two comment lines stay as written.

### V3. Does the `Slots<Int32>` overload of `qsort` (A1) take the table by value or `inout`?

Source. `rulings-build-helpers.md:25`, helper 1 at `:7`.

Sites. `Sources/JKAMP_BG/bg_lib.swift:57-65`, `public func qsort(_ a: Slots<Int32>, _ n: Int32, _ cmp: (Int32, Int32) -> Int32)`. The body copies `Array(a)`, sorts `0..<n` with `qsortSpan`, and writes `a[i] = values[i]` for `i` in `0..<n`. The caller in the working tree, `g_main.swift:1843`, reads `qsort(level.sortedClients, level.numConnectedClients, SortRanks)`, and `SortRanks` at `g_main.swift:1648` now takes `(_ a: Int32, _ b: Int32) -> Int32`. Both lines are work of the running sort transcriptor.

Raven. `g_main.c:1829-1830`, `qsort( level.sortedClients, level.numConnectedClients, sizeof(level.sortedClients[0]), SortRanks )`. `g_team.c:1128` sorts a local `int clients[]` and takes the `[T]` overload at `bg_lib.swift:53`.

jka-rust. `crates/mp/game/src/g_main.rs:1068-1075` copies the indices into a scratch `Vec`, sorts it with the native port of Raven's `bg_lib.c` qsort, and writes it back. The design note at `:834-865` says why: Raven's own Bentley-McIlroy sort, not libc's, and the tie order shows from 7 clients up.

Types. `lookup.py level_locals_t sortedClients` gives `sortedClients: Slots<Int32>`, array of 32. The accessor at `Sources/JKAMP_Game/Generated/Views/Level.swift:180` is get-only, so `&level.sortedClients` does not compile as an `inout` argument. `Slots.swift:34-37` gives the subscript a `nonmutating set`, and `:3` says that a copy of a `Slots` is a copy of the base pointer.

Guide. Guide 141: "A caller of a `Slots` parameter passes the `Slots` it holds, or the storage table under Raven's name." The D7 forward `G_RadiusList(..., _ ent_list: Slots<Entity?>)` at `g_utils.swift:375` takes its table by value too.

Verdict: The premise is true. A get-only accessor cannot pass as `inout`, and the setter writes through the base pointer. The choice is confirmed: by value, with no `&` at the call, a sort of a copy, and a write-back of the first `n` slots. This is jka-rust's shape and guide 141's shape. The call reads `qsort(level.sortedClients, level.numConnectedClients, SortRanks)`.

### V4. What does the list `sscanf` (D2) return when the input ends before the first conversion, where C returns -1?

Source. `rulings-build-helpers.md:26`, helper 4 at `:10`.

Sites. `Sources/JKAShared/Scan.swift:209-248`. The overload counts in `read` and returns it, so an empty input returns 0. The one caller is the hole at `Sources/JKAMP_GameLogic/g_session.swift:96-98`, still a Port-note.

Raven. `g_session.c:118`, the 15-conversion `sscanf` of `G_ReadSessionData`, and the statement drops the result. Every other `sscanf` in the game oracle reads one shape: `"%f %f %f"` at `bg_misc.c:379`, `bg_vehicleLoad.c:205`, `:879`, `g_ICARUScb.c:1604`, `:5034`, `:5043`, `:5057`, `g_spawn.c:48`, `:898`, `:917`, `:945`, `"%f"` at `g_spawn.c:929`, and `"%d"` at `g_ICARUScb.c:305`. Only `bg_vehicleLoad.c:205` and `:879` read the result, and they test `!= 3`, where -1 and 0 both fail.

jka-rust. `crates/mp/game/src/g_session.rs:91-150` splits on whitespace and has no return value. Its comment at `:99-100` notes that C leaves the three locals unset on a short string.

Helpers. The six other overloads in `Scan.swift:160-207` return 0 for text with no number, through `scanVector`, `scanFloat`, and `scanInt` at `:131-157`. None returns -1. The file header at `:1-4` and guide 682 say each overload returns "the count read as C does".

Verdict: The premise is true. C's `sscanf` returns `EOF` when input fails before the first conversion, and the overload returns 0. The choice is confirmed. Every overload of `Scan.swift` returns 0 there, and no Raven caller of the list shape reads the result. A -1 in one overload alone would make the file disagree with itself.

### V5. How strict is the list `sscanf` (D2) about its format, and how does `%s` read?

Source. `rulings-build-helpers.md:27`, helper 4 at `:10`.

Sites. `Sources/JKAShared/Scan.swift:213-221`, two `precondition` calls. The first tests that every space-separated token of `fmt` is `%i` or `%s`. The second tests that the `%i` count equals `ints.count` and the `%s` count equals `texts.count`. `Scan.swift:234-244` reads a `%s`: skip whitespace, take the run up to the next whitespace, stop the scan on an empty run, and store `String(decoding: bytes[start..<i], as: UTF8.self)`.

Raven. `g_session.c:118-134` reads 12 `%i` and 3 `%s` into `char[64]` fields `sess.siegeClass`, `sess.saberType`, and `sess.saber2Type`. `G_WriteSessionData` at `g_session.c:35-69` writes the same three fields after it turns each space into byte 1, so a `%s` token never holds a space.

jka-rust. `g_session.rs:96` uses `split_whitespace`, Rust's Unicode whitespace set, and parses each token with `unwrap_or(0)`.

Types. `lookup.py clientSession_t siegeClass` gives `siegeClass: String` and `siegeClassBuffer: JKAShared.CharBuf`, array of 64, and `saberType` the same. The `String` setter at `Sources/JKAMP_Game/Generated/Views/ClientSession.swift:133` calls `store(_:at:capacity:)` at `Sources/JKAShared/Views/CStrings.swift:8-13`, which copies at most 63 UTF-8 bytes and a NUL. The getter `cString(at:)` at `CStrings.swift:2-4` decodes as UTF-8 too.

Helpers and guide. Every other overload of `Scan.swift` checks its format with a `precondition` on the exact string, and the file header at `:3-4` states the rule. Guide 682-683 gives one overload per target shape, each one checked. `isScanSpace` at `Scan.swift:31-33` takes space, tab, newline, and carriage return. C's `isspace` also takes `\v` and `\f`. That gap is common to every overload in the file, and session text never holds those two bytes.

Verdict: The premise is true. The choice is confirmed. A token check in place of an exact string fits one overload that serves a family of formats, and the count check catches a wrong target list at once, as the file header asks. The UTF-8 read of `%s` is the same decode as the view getter and setter of the three fields, and the session text comes from those getters, so the round trip keeps the bytes. A `[CharBuf]` target would keep raw bytes outside UTF-8, but no session text holds such bytes, and the site would then need the `Buffer` setters. The overload stays as written.

### V6. Where does `Bool.init(_ value: Int32)` (D3, I1) live?

Source. `rulings-build-helpers.md:28`, helper 5 at `:11`.

Sites. `Sources/JKAShared/Bool+Int32.swift:1-7`, `extension Bool { public init(_ value: Int32) { self = value != 0 } }` with two doc lines. No body calls it yet. The sites are the D3 and I1 holes: `client.sess.teamLeader = Bool(teamLeader)` in `G_ReadSessionData` and ``return Bool(`self`.client!.ps.eFlags2 & EF2_FLYING)``, the I1 site.

Raven. `g_session.c:170-172` casts the three `int` locals into enum and `qboolean` fields, `client->sess.teamLeader = (qboolean)teamLeader`. The I1 site, `NPC_AI_Jedi.c:388`, returns `((qboolean)(self->client->ps.eFlags2&EF2_FLYING))`.

jka-rust. `qboolean` is a `c_int` there, so the cast is a plain store and no conversion exists.

Helpers. `Sources/JKAShared/Int32+Ascii.swift` is the model: one initializer on a standard type in a file named `Type+Topic.swift`. `Promotion.swift:44-48` gained a `// MARK: - Truth values` section for the L3 `+=` in the same build, and its header says it holds operators between `Int32` and `Float`. Two other `extension Bool` blocks, `Format.swift:57` and `SyscallWord.swift:15`, are protocol conformances in the file of their protocol. The many `Bool((x > y))` calls in GameLogic, such as `NPC_AI_Seeker.swift:350`, are the stdlib identity initializer and do not reach the new one.

Guide. Guide 534-535 keeps Raven's explicit cast on the page, which is why D3 asked for an initializer and not `!= 0`.

Verdict: The premise is true. No `JKAShared` file held a `Bool` initializer. The choice is confirmed: `Bool+Int32.swift` matches the `Int32+Ascii.swift` model, and `Promotion.swift` is the file of operators, not of initializers. The file stays as written.

### V7. Where do the native-byte helpers (L1) live, and what does the unpack do with an array that does not hold four bytes?

Source. `rulings-build-helpers.md:29`, helper 9 at `:15`.

Sites. `Sources/JKAShared/NativeBytes.swift:1-21`: `extension UInt32 { public init(nativeBytes bytes: [UInt8]) }` with `precondition(bytes.count == 4, "UInt32(nativeBytes:) takes four bytes")`, and `public func nativeBytes(of value: UInt32) -> [UInt8]`. No body calls them yet. The locals they serve are still `[Int32]` at `g_svcmds.swift:31-32`, `:88`, `:122`, `:289`, and `:314`, until the R3 drafter rule gives `[UInt8]`.

Raven. `g_svcmds.c:98-99`, `f->mask = *(unsigned *)m` and `f->compare = *(unsigned *)b`, `:159`, `in = *(unsigned int *)m`, and `:121`, `:292`, `:324`, `*(unsigned *)b = ipFilters[i].compare`. Every array is a local `byte b[4]` or `byte m[4]`.

jka-rust. `g_svcmds.rs:102-103` and `:163` read `u32::from_ne_bytes(m)`, and `:31` writes `ip.to_ne_bytes()`. Rust takes `[u8; 4]`, so the compiler checks the length.

Types. `lookup.py ipFilter_t` gives `mask: UInt32` and `compare: UInt32`.

Guide. No line covers a type pun of a byte array. Porting-rules rule 11 keeps raw pointers out of a logic target, so the helper belongs below GameLogic.

Verdict: The premise is true. The choice is confirmed. Swift has no fixed-length array type that `[UInt8]` storage fits, so a runtime check takes the place of Rust's `[u8; 4]`, and a trap is the house form for a broken precondition. Every Raven site passes a four-byte local, so the trap never fires on Raven's paths. The new file in `JKAShared` sits beside `Int32+Ascii.swift` and `Bool+Int32.swift` and stays as written.

### V8. Where does `pointOrientation(at:)` (J3) live, and what does it take?

Source. `rulings-build-helpers.md:30`, helper 8 at `:14`.

Sites. `Sources/JKAMP/Vehicle+Orientation.swift:1-14`, `extension Vehicle { public func pointOrientation(at ps: PlayerState) }`. The body adds `MemoryLayout<playerState_t>.offset(of: \.vehOrientation)!` to the raw base of `ps` and stores the address into `self.raw.pointee.m_vOrientation`. The caller is the hole at `NPC_spawn.swift:1286-1287`, followed at `:1304-1308` by the `m_vOrientationVector` reads that trap until the store runs.

Raven. The game module stores the field once, `NPC_spawn.c:1544`, `newent->m_pVehicle->m_vOrientation = &newent->client->ps.vehOrientation[0]`. The cgame stores it at `cg_predict.c:267`, `:270`, `:1329`, `:1492` and `cg_players.c:7046`, `:7566`, `:7570`. Four of those point at another vector, `&cent->lerpAngles[0]`, or restore a saved pointer `old`.

jka-rust. `crates/mp/game/src/NPC_spawn.rs:1244` stores the raw pointer and `:1258-1263` writes through it.

Types. `lookup.py Vehicle_t m_vOrientation` gives `m_vOrientation: OpaquePointer?` and `m_vOrientationVector: JKAShared.vec3_t`, optional, nil for a NULL pointer. The sibling helper of the same build, `Sources/JKAMP/EntityState+Bones.swift`, has the same shape: an extension on a view in `JKAMP`, which takes an address with `MemoryLayout.offset(of:)`.

Guide. Guide 322-332 gives the view accessors, and porting-rules rule 11 keeps the address in the view target. The J3 ruling names `Sources/JKAMP/` and the call `newent.m_pVehicle!.pointOrientation(at: newent.client!.ps)`.

Verdict: The premise is true. The choice is confirmed for the game module: a `Vehicle+Orientation.swift` file in `JKAMP` that takes the `PlayerState` view fits the J3 ruling, rule 11, and the `EntityState+Bones.swift` model. The cgame stores need a second form later, over a `centity_t` vector and over a saved pointer. That work is outside this phase.

### V9. What count type does `CharBuf.zero(count:)` (B5) take, and what happens past the end?

Source. `rulings-build-helpers.md:31`, helper 2 at `:8`.

Sites. `Sources/JKAShared/CharBuf.swift:76-84`, `public mutating func zero<I: BinaryInteger>(count n: I)`, with `precondition(n >= 0 && n <= self.count, "CharBuf zero count past the end")`. No body calls it yet. The site is the hole at `g_utils.swift:109-110`, `memset(buff, 0, MAX_STRING_CHARS)` in `BuildShaderStateConfig`, where `buff` is the world forward at `g_utils.swift:97` of Raven's `static char buff[MAX_STRING_CHARS*4]`.

Raven. `g_utils.c:44`, the only partial zero `memset` of a `char` buffer in the game oracle. It clears the first 1024 of 4096 bytes.

jka-rust. `crates/mp/game/src/g_utils.rs:96-101` drops the static and builds a new `String`, so it gives no parity point for the count.

Types. `MAX_STRING_CHARS` is `public let MAX_STRING_CHARS = CJKAShared.MAX_STRING_CHARS` at `Sources/JKAShared/Generated/q_shared.swift:27`, a C macro that Swift imports as `Int32`. `CharBuf.swift:9` takes `some BinaryInteger` in `init(_ count:)`, and the subscripts at `:49` and `:55` take any `BinaryInteger` index. `setByte` and `signedByte` at `:35-45` trap past the end with a `precondition`.

Guide. Guide 179 gives the call, `buff.zero(count: MAX_STRING_CHARS)`, and guide 534 lets any C integer index an array with no cast.

Verdict: The premise is true. The choice is confirmed. A `BinaryInteger` count matches the rest of `CharBuf`, so the guide's call compiles with no cast. A `memset` past the end of a C array is undefined behavior, and the trap matches the read and write checks of the same type. The generic `<I: BinaryInteger>` spelling matches the subscripts, and the initializer's `some BinaryInteger` is the same contract.

### V10. Which Raven line does the `Source:` line of the `Q_stricmp(String?, String?)` overload (R9) cite?

Source. `rulings-build-helpers.md:32`, helper 13 at `:19`.

Sites. `Sources/JKAShared/q_shared.c.swift:817-822`:

```swift
/// Raven's `Q_stricmp` with a NULL argument, which returns -1 and compares nothing.
/// Source: oracle/codemp/game/q_shared.c:900
public func Q_stricmp(_ s1: String?, _ s2: String?) -> Int32 {
    guard let s1, let s2 else { return -1 }
    return Q_stricmp(s1, s2)
}
```

The base at `:807-810` carries the same `/// Source: oracle/codemp/game/q_shared.c:900`. The other hand overloads of the file carry no `Source:` line: the `String` forms of `Q_stricmpn` at `:765`, `Q_strncmp` at `:802`, and `Q_stricmp` at `:812`, the value forms of `Q_strlwr`, `Q_strupr`, and `Q_CleanStr`, and the `at:` forms at `:860`, `:891`, and `:974`.

Raven. `q_shared.c:900-902`, `int Q_stricmp (const char *s1, const char *s2) { return (s1 && s2) ? Q_stricmpn (s1, s2, 99999) : -1; }`. Line 900 is the function line, and line 901 is the body with the NULL test.

The proof. The R9 verdict in `docket-proofs-R.md` says the overload "returns -1 for nil, as `q_shared.c:901` does". It cites the body line for the behavior, and it gives no `Source:` line. The walk row R9 at `frame-path-walk.md:83` repeats that text.

jka-rust. `crates/mp/game/src/g_target.rs:994-1003` holds the target as `Option<String>` and skips the call on `None`. It has no overload.

Draft tools. Porting-rules line 52 asks for a `Source:` line on every generated and every ported item. `draftcheck.py:51` matches `/// Source: oracle/codemp/game/<stem>.c:<line>`, and `functions()` at `:71-89` keeps one span per Raven line, so the later span wins. A read-only run of `functions()` over the file gives `900 -> (817, 821)`, the overload, so the base at `:807` drops out of the key. The splice at `:148-171` then can write the drafted `Q_stricmp` body over the overload, unless `kept()` marks the overload as hand work. A forward may share a `Source:` line only under the `FORWARD_DOC` line at `draftcheck.py:53`, and this overload does not carry it.

Verdict: The premise is false in part. The builder says the existing overloads cite the function line, and they cite nothing. The proof's 901 is a behavior cite, not a `Source:` line. The choice is amended: the overload carries no `Source:` line, as every other hand overload of the file, and its first doc line names Raven's line in prose, so the draft key of line 900 stays on the base. The overload reads:

```swift
/// Raven's `Q_stricmp` returns -1 for a NULL argument at `q_shared.c:901` and compares nothing.
public func Q_stricmp(_ s1: String?, _ s2: String?) -> Int32 {
    guard let s1, let s2 else { return -1 }
    return Q_stricmp(s1, s2)
}
```

The D7 forward of `G_RadiusList` at `g_utils.swift:374` has the same duplicate key, Raven line 252. The coordinator can fix it in the same pass, with the `Source:` line dropped there too.

### V11. Where does the compound store form of N1 go, since the walk record names line 542 and the `float` into `int` rule stood at line 543?

Source. `rulings-build-guide.md:29`, item 15 at `:19`.

Sites. Guide 556 now reads: "A `float` stored into an `int` takes `Int32(...)` at the store, the mirror of the next rule, so `ps.gravity = 1.0f` reads `ps.gravity = Int32(1.0)`. A compound store into an `int` from a `float` is `x = Int32(x op f)` over the `Promotion.swift` operator, with no `Float(x)`, so `parentPS->hackingTime -= 50*pVeh->m_fTimeModifier` reads `parentPS!.hackingTime = Int32(parentPS!.hackingTime - 50 * pVeh.m_fTimeModifier)`." Guide 551 reads "This is the one place a body writes a conversion Raven did not write, ...", the last sentence of the double-math rule at guide 547-551, unchanged.

History. At 3f2a965, a8e1779, 8a41bfb, and 3222d10, guide 542 is "This is the one place a body writes a conversion Raven did not write" and guide 543 is the `float` into `int` rule. The N1 proof in `docket-proofs-L-M-N-O.md` says "Guide 542 gives `Int32(...)` at a float-into-int store". That text describes line 543, so the proof's number is one off. The A5 proof in `docket-proofs-A-B.md` cites 543 for the same rule. The walk row N1 at `frame-path-walk.md:58` copies the proof's 542.

Line numbers. The record says "now line 554", but at 7728fd9, a1b6196, and the working tree the rule is at guide 556. The review fix of V18 added guide 553 and 554, the `size` against `stride` lines, after the record was written. Items 7, 15, and 20 of `rulings-build-guide.md` are two lines stale: `sizeof(t)/sizeof(t[0])` is guide 555, the compound store is guide 556, and the `int` to `float` parameter is guide 557. Item 2, guide 552, is still right.

Raven and jka-rust. The N1 proof lists the Raven sites, `FighterNPC.c:760`, `:776`, `:786`, `:794` and eleven more, and jka-rust `crates/mp/bg/src/vehicles/fighter_npc.rs:799-827` writes `(hackingTime as f32 - 50.0 * m_fTimeModifier) as c_int`.

Helpers. `Promotion.swift:10` gives `- (Int32, Float) -> Float`, so `hackingTime - 50 * m_fTimeModifier` is a `Float` with no `Float(x)`, and the form needs no new operator.

Verdict: The premise is true. The walk names line 542 by the proof's off-by-one number, and its words "a float-into-int store" name line 543. The choice is confirmed: the compound store belongs on the `float` into `int` rule, and the double-math rule stays as it was. One record fix follows. Items 7, 15, and 20 of `rulings-build-guide.md`, and the V11 row of `phase-2-plan.md`, read guide 555, 556, and 557 in place of 553, 554, and 555.
