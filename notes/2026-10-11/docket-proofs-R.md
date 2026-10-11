# Docket proofs for rows R1 to R14

This record proves the findings and the proposed fixes of rows R1 to R14 of `frame-path-round.md` against the committed tree at 3f2a965, Raven's C under `oracle/codemp/game/`, the jka-rust range of each manifest in the submodule `jka-rust/`, and `docs/transcription.md`.

### R1

Site. `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:3122`, `_VectorMA(NPC!.enemy!.r.currentOrigin, Float(Double(enemy_movespeed) * 0.001 * Double(prediction)), enemy_movedir, &enemy_dest)`. Raven: `NPC_AI_Jedi.c:3784`, `VectorMA( NPC->enemy->r.currentOrigin, *enemy_movespeed * 0.001 * prediction, enemy_movedir, enemy_dest )`.

Truth. True. The build takes the `#if 1` branch of `q_shared.h:1351`, so `VectorMA` is the macro at `q_shared.h:1365`, `(o)[i]=(v)[i]+(b)[i]*(s)`. With the double `s`, each component computes in double and narrows once at the store. `_VectorMA` at `Sources/JKAShared/q_math.swift:891` takes `scale: Float` and computes in float. A test over 100000 random inputs (`v` in -4000 to 4000, `b` in -1 to 1, speed 0 to 400, prediction 300) gives a different result in 2194 cases, one ulp each. Example: `v = 700.64484`, `b = 0.764958`, speed `338.47897`: Raven stores `778.3215`, the Swift stores `778.32153`. jka-rust `NPC_AI_Jedi.rs:4531-4534` narrows the scale to `f32` the same way, with a comment that says so.

Helpers. None. `q_math.swift:891` is the only `_VectorMA`, and no `Double` scale overload exists in JKAShared, JKAMP_BG, or JKAMP_Game.

Guide. The VectorMA row at `docs/transcription.md:249` gives one form, `_VectorMA(a, s, b, &c)`, and does not name a double scale. The double-math rule at lines 538-541 asks for `Double` on each operand and `Float` once at the store, and the row hides that store inside the callee. The two rules disagree at this site.

Verdict. Finding confirmed. Fix amended: the guide's VectorMA row gains a double-scale form, and the site spells the macro per component, because a `Double` overload of `_VectorMA` would also catch every bare Swift literal scale that Raven wrote with `f` (11 C sites pass an unsuffixed decimal scale, and more pass an `f` scale). The site reads:
```swift
let scale = Double(enemy_movespeed) * 0.001 * Double(prediction)
enemy_dest[0] = Float(Double(NPC!.enemy!.r.currentOrigin[0]) + Double(enemy_movedir[0]) * scale)
enemy_dest[1] = Float(Double(NPC!.enemy!.r.currentOrigin[1]) + Double(enemy_movedir[1]) * scale)
enemy_dest[2] = Float(Double(NPC!.enemy!.r.currentOrigin[2]) + Double(enemy_movedir[2]) * scale)
```
A labeled helper in `q_math.swift`, `_VectorMA(a, doubleScale: s, b, &c)`, gives the same bits in one line, if the user prefers it. If the user rules for jka-rust parity instead, the row stands and one line notes the one-ulp divergence. Three `_VectorMA` sites in GameLogic carry a `Float(Double(...))` or `Float(... * 0.x)` scale and share the ground.

### R2

Site. `Sources/JKAMP_GameLogic/g_ICARUScb.swift:78`, `Com_Printf(S_COLOR_BLUE + "DEBUG: %s(%d): %s\n", g_entities[entNum].script_targetname!, entNum, buffer.text)`. Raven: `g_ICARUScb.c:316`, the same call with `g_entities[entNum].script_targetname` and no test.

Truth. True. `lookup.py gentity_t script_targetname` gives `script_targetname: String?`, nil for a NULL pointer. The line runs only when `g_developer.integer == 2` (`g_ICARUScb.c:284`), at a `WL_DEBUG` level. The Swift `entNum` starts at 0, so a text with no leading number reads slot 0, the first client, whose `script_targetname` is NULL unless a script named it. Concrete input: `g_developer 2` and any `WL_DEBUG` print whose text does not name a scripted entity. The Swift traps at the unwrap, and Raven prints `(null)` through the MSVC and glibc `vsprintf`. One amendment: in Raven, `entNum` is uninitialized when `sscanf` reads no number, so his slot is not always 0. jka-rust `g_ICARUScb.rs:84-104` reads `script_targetname_str().unwrap_or_default()` and prints an empty name.

Helpers. `Sources/JKAShared/Format.swift:27-53` gives `FormatArg` to `Int32`, `Int`, `Float`, `Double`, `String`, `CharBuf`, and `PooledString`. No conformance takes `String?`, so a `String?` argument does not compile without the unwrap. `va` (`q_shared.c.swift:977`), `Com_Printf` (`Channel.swift:34`, `bg_local.swift:367`, `g_main.swift:1271`), and `G_Printf` (`g_main.swift:790`) all take `any FormatArg...`, and none has a `String?` overload.

Guide. Line 337 gives `?? ""` for a `String?` that a format call reads only under a runtime test. Line 336 allows the force unwrap only where Raven's callee dereferences NULL, and `vsprintf` does not. No line gives a `String?` that Raven passes to `%s` with no test.

Verdict. Finding confirmed, with the `entNum` amendment. Fix amended to one choice: extend line 337 to every `String?` that Raven passes to a `%s`, and write `?? "(null)"`, the text Raven's `vsprintf` prints, at the argument. The site reads `g_entities[entNum].script_targetname ?? "(null)"`. A conditional conformance `extension Optional: FormatArg where Wrapped == String` gives the same text with no site change, but it also hides an unwrap a later rule may want visible. `g_ICARUScb.swift:1827-1839` passes `ent!.script_targetname!` to `G_DebugPrint`, which evaluates before the `g_developer` test, and is the same ground under line 337.

### R3

Site. `Sources/JKAMP_GameLogic/g_svcmds.swift:122` and `:136`, `var m: [Int32] = [Int32](repeating: 0, count: 4)` and `m[i] = m[i] * 10 + (p.byte - Int32(ascii: "0"))`. `StringToFilter` at `:31-32` declares `b` and `m` the same way and stores `b[i] = atoi(num)` at `:57`. Raven: `g_svcmds.c:136` `byte m[4]`, `:151` `m[i] = m[i]*10 + (*p - '0')`, and `:66-67`, `:89` `b[i] = atoi(num)`.

Truth. True. C stores the low 8 bits. Input `1.2.3.300` to `G_FilterPacket`: Raven keeps `m[3] = 44`, the Swift keeps 300. Input `1.2.3.4000000000`: the Swift traps at `400000000 * 10` on `Int32` overflow, where C wraps. Input `addip 300.1.1.1` to `StringToFilter`: Raven keeps `b[0] = 44`, the Swift keeps 300. The engine passes a real address with groups under 256 to `G_FilterPacket`, so the likely path is the `addip` and `g_filterban` text. Today both functions stop at the `portMissing` of the `*(unsigned *)m` read first. jka-rust `g_svcmds.rs:46-47`, `:84`, `:134-148` uses `[0u8; 4]`, `as u8`, and `wrapping_mul` and `wrapping_add`.

Drafter. `tools/oracle-closure/draft_declarations.py:531-532`, in `array_declaration`, sets `element = "Int32"` when `self.types.narrow(t.element_type)` is not None. `narrow_local_names` at `:519` excludes a `CONSTANTARRAY`, so no narrow store applies to the elements.

Helpers. No pack or unpack helper exists for four bytes into a `UInt32`, which is row L1. `Int32Indexing.swift:26` and `:37` index any `Array` with a C integer, so a `[UInt8]` takes `m[i]`.

Guide. Line 525: "A fixed array of a narrow type keeps its element type." Line 526-527 give the truncating store for a narrow local. The drafter is out of step with line 525.

Verdict. Finding confirmed. Fix confirmed: the drafter keeps the narrow element type of a local array, and each store truncates as line 527 says. The sites read:
```swift
var m: [UInt8] = [UInt8](repeating: 0, count: 4)
m[i] = UInt8(truncatingIfNeeded: Int32(m[i]) * 10 + (p.byte - Int32(ascii: "0")))
b[i] = UInt8(truncatingIfNeeded: atoi(num))
```
`m[i] = 255` and `b[i] != 0` need no change. Same ground as L1. Lines 88, 289, and 314 of `g_svcmds.swift` declare other `byte b[4]` locals the same way.

### R4

Site. `Sources/JKAMP_GameLogic/g_cmds.swift:2233-2235` and `:2238-2240`, a local `var teamVoteString = CharBuf(1024)`, `Com_sprintf(&teamVoteString, 1024, ...)`, and `level.teamVoteString[cs_offset] = String(teamVoteString)`. Raven: `g_cmds.c:2326` and `:2330`, `Com_sprintf( level.teamVoteString[cs_offset], sizeof( level.teamVoteString[cs_offset] ), ... )`.

Truth. True as a form finding, and the behavior is the same. `lookup.py level_locals_t teamVoteString` gives `char[2][1024]` as `teamVoteString: Slots<String>`, with no buffer accessor. `Com_sprintf` truncates to 1023 bytes as Raven's does, and the `Slots` setter (`Slots.swift:129`, `store` at `CStrings.swift:8-13`) writes at most 1023 bytes and a NUL, and leaves the bytes past the NUL as C does. No input gives a different result. jka-rust `g_cmds.rs:2636-2645` stores `strncpyz_string(...)` into the row, also a format then a store.

Helpers. None. `views.py` writes a `<name>Buffer` accessor for a `char name[N]` field only, such as `voteStringBuffer: CharBuf`. No `<name>Buffers` row accessor exists in the generated views.

Guide. Lines 164-166 give the `Buffer` accessor for a `char name[N]` field as a write target, and say nothing about one row of `char[N][M]`. Line 170 lets the size be the bound constant of the declaration, `MAX_STRING_CHARS` from `g_local.h:875`, where the fill wrote the literal `1024`.

Verdict. Finding confirmed. Fix amended: take the H3 accessor, a `Slots<CharBuf>` row accessor that `views.py` writes beside the `Slots<String>`, and the size from line 170. After H3 the site reads `Com_sprintf(&level.teamVoteStringBuffers[cs_offset], MAX_STRING_CHARS, "clientkick %s", arg2)`, and the same for `"%s %s", arg1, arg2`. Until H3 rules, the present form gives the same bytes and can stand. Same ground as H3.

### R5

Site. `Sources/JKAMP_GameLogic/g_items.swift:653`, `count = G_RadiusList(org2, Float(TURRET_RADIUS), `self`, true, &entity_list)`. Raven: `g_items.c:570`, `G_RadiusList( org2, TURRET_RADIUS, self, qtrue, entity_list )`, with `#define TURRET_RADIUS 800` at `:544`.

Truth. True as a form finding. `lookup.py sig G_RadiusList` gives `_ radius: Float`, and the stub has `let TURRET_RADIUS = 800 as Int32` at `g_items.swift:113`. C converts the `int` to `float` at the call. `Float(Int32)` rounds as C's conversion does, so no input gives a different value, and 800 is exact. jka-rust `g_items.rs:811-812` types the constant `f32` and passes it bare. `w_force.swift:3144`, `_VectorMA(trFrom, Float(radius), forward, &end)`, is the same case for Raven's `int radius` at `w_force.c:3066` and his `VectorMA( trFrom, radius, forward, end )` at `:3737`.

Helpers. None. `Promotion.swift` gives the mixed `Int32` and `Float` operators, not an argument conversion, and no `Int32` overload of `G_RadiusList` or `_VectorMA` exists.

Guide. Line 544 gives `Float(...)` for an `int` stored into a `float`, and line 545 for an `int` in a float table. Lines 546-548 give a second `Int32` overload for an `int` into an `unsigned` parameter. No line covers an `int` into a `float` parameter.

Verdict. Finding confirmed. Fix amended to one choice: line 544 gains "an `int` passed to a `float` parameter takes `Float(...)` at the argument, as at a store", because Swift has no conversion at a call either. The site stays as it is, `G_RadiusList(org2, Float(TURRET_RADIUS), `self`, true, &entity_list)`, and so does `w_force.swift:3144`. A `Float` constant or an overload per callee would spread to every callee with a `float` parameter.

### R6

Site. `Sources/JKAMP_GameLogic/SpeederNPC.swift:253-257`, `if pVeh.m_pVehicleInfo!.strafePerc == 0 || (0 != 0 && pVeh.m_pParentEntity!.s.number < MAX_CLIENTS) {` with two comments and no statement. Raven: `SpeederNPC.c:462-469`, the `_JK2MP` arm `|| (0 && pVeh->m_pParentEntity->s.number < MAX_CLIENTS) )`.

Truth. True, and the behavior is the same. `0 != 0` is false, so `&&` never reads `m_pParentEntity!`. The body is empty, so neither arm changes state. The left read of `m_pVehicleInfo!` traps only where earlier reads in the function already trapped. jka-rust `speeder_npc.rs:151-171` drops the whole `else` block with no comment.

Helpers. Not applicable.

Guide. No line gives a truth test on an integer literal. Line 553 drops a `#ifdef` arm by the build's choice, which does not cover this `0`. Line 680 keeps Raven's inline comments verbatim, so a full drop loses his two comment lines unless a comment quotes them.

Verdict. Finding confirmed. Fix amended: keep the block, its two comments, and Raven's shape, and write his `0` as `false`, the value C gives a `0` operand of `&&`. The site reads `if pVeh.m_pVehicleInfo!.strafePerc == 0 || (false && pVeh.m_pParentEntity!.s.number < MAX_CLIENTS) {`. The reviewer's drop under one quoting comment is the other choice, and it matches jka-rust.

### R7

Site. `Sources/JKAMP_GameLogic/w_force.swift:3056-3060`, `let vehEnt: Entity? = g_entities[push_list[x]!.client!.ps.m_iVehicleNum]` and six `vehEnt!` reads. Raven: `w_force.c:3636`, `gentity_t *vehEnt = &g_entities[push_list[x]->client->ps.m_iVehicleNum]`.

Truth. True, and the behavior is the same. `g_entities` is `Slots<Entity>` (`g_main.swift:28`), so the subscript never gives nil and no unwrap can trap. Amendment: the shape is not the fill's own choice. The fill copies `w_force.swift:1220`, committed at a43b87e for Raven's `w_force.c:1572`, and 136 locals in GameLogic declare `let <name>: Entity? = g_entities[...]`. The drafter writes `Entity?` for every `gentity_t *` local. jka-rust `w_force.rs` reads a raw pointer with no test.

Helpers. Not applicable. A plain `let` over the subscript gives `Entity`.

Guide. Line 335 drops a NULL guard on a never-null variable, and lines 431 and 434 give the index forms for a walked table pointer. No line makes a local set once to a table slot address non-optional.

Verdict. Finding amended: the defect is the drafter's form for a record pointer local set from `&table[i]`, at 136 sites, not this fill. Fix amended: a drafter rule that a `gentity_t *` local whose every store is a table slot address, with no NULL store and no NULL test, is a plain `Entity`. The site reads `let vehEnt = g_entities[push_list[x]!.client!.ps.m_iVehicleNum]`, then `vehEnt.inuse`, `vehEnt.m_pVehicle!.m_pVehicleInfo!.type`, and the same at line 1220.

### R8

Site. `Sources/JKAMP_GameLogic/g_cmds.swift:195` declares `var outIndex: Int32 = 0`, `:197-199` hold the Port-note and `portMissing` for the `while ( *in )` loop, and `:201` writes `out[outIndex] = 0`. Raven: `g_cmds.c:161-175`, with `*out++ = tolower( (unsigned char) *in++ )` at `:171` and `*out = 0` at `:174`.

Truth. True, and no input gives a wrong result today. `portMissing` at `Sources/JKAShared/PortMissing.swift:3` returns `Never`, so line 201 never runs until the loop is filled. A loop fill that does not step `outIndex` would write every byte at offset 0. jka-rust `g_cmds.rs:239-260` builds a `Vec<u8>` with `push`, so it has no cursor.

Helpers. `tolower(_ c: Int32) -> Int32` now exists at `Sources/JKAShared/CString.swift:468`, which closes the first half of B3. No spelling of `(unsigned char)` exists, the second half of B3.

Guide. Lines 631-633 make a written `char *` over a named buffer an `Int32` write cursor. The cursor of the fill follows that rule.

Verdict. Finding confirmed as a dependency, not a defect. Fix confirmed: the loop fill under B3 steps the cursor at Raven's `*out++`, `out[outIndex] = tolower(...)` then `outIndex += 1`, with an `inIndex` read cursor over `in` by the same rule. Same ground as B3.

### R9

Site. `Sources/JKAMP_GameLogic/g_target.swift:689` and `:709`, `while let next = G_Find(t, \.targetname, `self`.target!) {`. Raven: `g_target.c:693` and `:715`, `G_Find (t, FOFS(targetname), self->target)`.

Truth. True, with one amendment. Raven's `G_Find` at `g_utils.c:222-243` calls `Q_stricmp (s, match)`. `Q_stricmp` at `q_shared.c:900-902` returns -1 when either argument is NULL and does not call `Q_stricmpn`, so the reviewer's `Q_stricmpn` path at `:852` is not the one that runs. The result is the same: no slot matches, `G_Find` returns NULL, `t_count` stays 0, and `target_random_use` returns at `g_target.c:702`. `SP_target_random` at `:748-751` does not require a `target` key. Concrete input: a `target_random` with no `target` key, used by a trigger. The Swift traps at the unwrap. The Swift `G_Find` at `g_utils.swift:270` takes `_ match: String` and calls `Q_stricmp(s!, match)` at `:291`. jka-rust `g_target.rs:994-1003` holds the target as `Option<String>` and skips the call on `None`, with a comment that names Raven's NULL.

Helpers. None. `Q_stricmp` and `Q_stricmpn` in `Sources/JKAShared/q_shared.c.swift:723`, `:766`, `:808`, `:813` take `CharBuf` or `String`, and none takes `String?`.

Guide. Line 336 allows the force unwrap only "where Raven's callee would dereference NULL", and this callee does not. No line gives a NULL `match`.

Verdict. Finding confirmed, with the `Q_stricmp` amendment. Fix amended to the callee form: a `rulings.py` entry makes the `match` parameter of `G_Find` a `String?`, and the body keeps Raven's call through a `Q_stricmp(_ s1: String?, _ s2: String?)` overload in JKAShared that returns -1 for nil, as `q_shared.c:901` does. The site reads `while let next = G_Find(t, \.targetname, `self`.target) {`. Fourteen other `G_Find(..., x.target!)` calls in `g_trigger`, `g_misc`, `g_target`, and `g_mover` share the ground, and a guard at the caller would cost one guard per site.

### R10

Site. `Sources/JKAMP_GameLogic/ai_wpnav.swift:2500-2503`, `if terrain == nil || !terrain!.inuse || terrain!.s.eType != ET_TERRAIN { G_Printf("Error: RMG with no terrain!\n"); return true }`, inside the `Trace.scratch` closure, and eight `terrain!` reads at `:2512-2586`. Raven: `ai_wpnav.c:3068-3074`.

Truth. True as a form finding, and the behavior is the same. The early-out returns before every `terrain!` read, so no unwrap can trap. jka-rust `ai_wpnav.rs:2793-2804` tests `terrain_id.is_none()` first and then reads through `ctx.entity(...)`.

Helpers. Not applicable.

Guide. Line 340 gives `guard let ... else { return }` for an early-out and says "A guard that does other work on the NULL path keeps a Port-note." Line 218 keeps Raven's NULL test form, `x == nil`, for an optional parameter. Line 342 binds a chain that a body reads three or more times, which does not cover a local.

Verdict. Finding confirmed. Fix confirmed: line 340 gains the form for an early-out whose arm does work, a `guard` whose conditions are Raven's test negated in his order and whose `else` holds his arm. The site reads:
```swift
guard let terrain, terrain.inuse, terrain.s.eType == ET_TERRAIN else {
    G_Printf("Error: RMG with no terrain!\n")
    return true
}
```
The eight reads become `terrain.r.absmin[0]` and the like.

### R11

Site. `Sources/JKAMP_GameLogic/g_saga.swift:218`, `if levelname[0] == 0 { break failure }`. Raven: `g_saga.c:145`, `if (!levelname || !levelname[0])`, with `char levelname[512]` at `:99`.

Truth. True that the test drops with no comment, and the behavior is the same. `levelname` is a local array, so its address is never NULL and `!levelname` is always false. jka-rust `g_saga.rs:162` tests only the empty text, with no comment.

Helpers. Not applicable.

Guide. Line 334 drops a NULL guard on a non-optional view parameter "with no comment and no marker", and line 335 extends the rule to "a never-null variable". A local array is a never-null variable, so the guide rules this drop as silent.

Verdict. Finding withdrawn: the fill follows lines 334-335, and the reviewer's claim that no guide form drops the test silently is wrong. Fix replaced: no change at the site. If the user wants a comment at every dropped never-null test, the change goes into line 334 for every site at once, not into this site. Same ground as R13 and S1.

### R12

Site. `Sources/JKAMP_GameLogic/g_nav.swift:1009`, `if `self`.s.weapon != WP_SABER && abs(`self`.r.currentOrigin[2] - end[2]) > 48 {`. Raven: `g_nav.c:1030`, `fabs( self->r.currentOrigin[2] - end[2] ) > 48`.

Truth. The reviewer's evidence is false. Lines 523 and 982 of `g_nav.swift` write the same `Float` form, `abs(`self`.r.currentOrigin[2] - end[2]) > 48`, for Raven's `g_nav.c:516` and `:998`, and no `abs(Double(` appears in the file. `NPC_move.swift:31` uses the same form. The subtraction is float in C, the float converts to double exactly, `fabs` is exact, and 48 is exact, so no input gives a different result. jka-rust `g_nav.rs:1418` and `:1449` compare `.abs() > 48.0` in `f32`.

Helpers. Swift's generic `abs` serves both types, and line 549 spells `fabs` as `abs`.

Guide. Line 540 asks for `abs(Double(du0)) < EPSILON` where C compares in double, and its example compares with a double constant. By its letter the `fabs` result is a double, so the line applies. By value it changes nothing here.

Verdict. Finding amended: the site follows the file's two other sites and no bits change, so the row is a guide question, not a site defect. Fix replaced: no change at the site. If the user rules for the letter of line 540, the change covers all four `fabs` sites at once, `abs(Double(`self`.r.currentOrigin[2] - end[2])) > 48` at `g_nav.swift:523`, `:982`, `:1009`, and `NPC_move.swift:31`.

### R13

Site. `Sources/JKAMP_GameLogic/g_nav.swift:1600-1605`, the start of `NAV_CalculatePaths`, where commit 5e99704 removed the Port-note and `portMissing` for Raven's test and wrote nothing. Raven: `g_nav.c:1739-1742`, `if ( !tempWaypointList ) { return; }`, with `static waypointData_t tempWaypointList[MAX_STORED_WAYPOINTS]` at `:1660`.

Truth. True that the test drops with no line, and the behavior is the same. The address of a static array is never NULL. jka-rust `g_nav.rs:2263-2265` writes a three-line comment that names the vacuous guard.

Helpers. Not applicable.

Guide. Lines 334-335 drop a NULL guard on a never-null variable with no comment and no marker. The round record's own row text says the drop is allowed.

Verdict. Finding withdrawn: the fill follows lines 334-335. Fix replaced: no change at the site, and a comment rule, if the user wants one, goes into line 334 for every site. Same ground as R11 and S1.

### R14

Site. `Sources/JKAMP_GameLogic/NPC_AI_Rancor.swift:509` and `:551`, the two `G_Damage(NPC!.activator!, ..., MOD_MELEE)` calls with no trailing comment. Raven: `NPC_AI_Rancor.c:537` ends in `);//, HL_NONE );//`, and `:577` ends in `);//, HL_NONE );`.

Truth. True. The comments are dropped, and the behavior is the same. The same file keeps this kind of comment at `:275` and `:337`, `G_Knockdown(radiusEnt!) //, NPC, pushDir, 100, qtrue );`. jka-rust `NPC_AI_Rancor.rs:826` and `:911` keep both comments.

Helpers. Not applicable.

Guide. Line 680: "Raven's inline comments stay in place, verbatim, inside the ported body."

Verdict. Finding confirmed. Fix confirmed: write both comments back after the call. The sites read `G_Damage(..., MOD_MELEE) //, HL_NONE );//` at line 509 and `G_Damage(..., MOD_MELEE) //, HL_NONE );` at line 551.
