# Docket proofs for rows W1 to W33

This record collects the open findings of phase 2 as rows W1 to W33 for the next ratification walk, and proves each row. The sources are the seven wave A records `phase2-*.md`, the four wave A reviews `review-phase2-*.md`, the seven wave B records `holes2-*.md`, the wave B gate record `phase2-wave-b-gate.md`, and the four wave B reviews `review-phase2b-*.md`, all under `notes/2026-10-11/`. A finding that is already a V row of `phase-2-plan.md` Part C or of `docket-proofs-V-34-38.md` is not a W row. Findings that ask one question are one row. The evidence is the working tree of `wave-0` after the wave B commit, Raven's C under `oracle/codemp/game/`, the submodule `jka-rust/`, `tools/oracle-closure/lookup.py`, and `docs/transcription.md`. A site line in a section is the line of the working tree, and a section says so where the line moved from the line in its source record.

| Row | Question | Source |
|---|---|---|
| W1 | Does the logic `vmMain` in `g_main.swift`, with its ten holes, go now or at the next g_main re-splice under row F5? | `holes2-main.md:9-18`, `:62` |
| W2 | What form does the local `G2Trace_t G2Trace` of `G_G2TraceCollide`, a C array of `CollisionRecord_t`, take? | `holes2-combat.md:10-15` |
| W3 | Is the `sig` blocker on the four `boltMatrix` holes of `WP_CalcVehMuzzle` stale, so the holes take the `MdxaBone.scratch` form? | `holes2-combat.md:28-31`, `:53-54` |
| W4 | What form fills the four stores `pm.trace = trap_Trace` and `pm.pointcontents = trap_PointContents`? | `holes2-combat.md:18-23`, `:55` |
| W5 | Does the stale reason text on the four `pm` holes change now or stay until the holes fill? | `holes2-combat.md:56` |
| W6 | Does `fatalErrorPointer` become an integer byte offset in the generated storage, and through which `rulings.py` entry? | `holes2-bot.md:24-27`, `:62-68` |
| W7 | Which form spells `placesecond = strstr(place+1, group)`, a search from a cursor that gives an offset into the whole buffer? | `holes2-bot.md:37-40`, `:45-57` |
| W8 | How does `G_ProcessIPBans` walk the cvar memory of `g_banIPs` with two cursors and pass the cursor `t` to the `inout` parameter of `AddIP`? | `holes2-main.md:24-26`, `:36-45`, `:64` |
| W9 | What form fills the three `Q3_Set*TextColor` holes, and does `SetTextColor` take `vec4_t` by value or `inout` (guide line 91)? | `holes2-npc.md:13-15`, `:90` |
| W10 | Does `rulings.py` add `BG_TempAlloc` to `CHARBUF_ALLOCS` for the four `saberName` holes of `NPC_ParseParms`? | `holes2-npc.md:16-19`, `:91` |
| W11 | Does `ColorIndex` take an `Int32` in place of a `CChar`, so `ClientCleanName` reads it from a `TextCursor` byte? | `holes2-entities.md:26` |
| W12 | Does `SiegeItemRemoveOwner` take `carrier: Entity?` with Raven's `if (carrier)` guard restored? | `holes2-entities.md:28`, `:58` |
| W13 | What form does `SP_func_breakable` take for Raven's `char *s = NULL` passed to the `inout String` parameter of `G_SpawnString`? | `holes2-entities.md:31` |
| W14 | Does the `Client?` local of `Pickup_Powerup`, set on each loop pass and read as `client!`, take a per-pass bind? | `holes2-bones.md:55` |
| W15 | What form does a C `switch` take when Raven puts the `default` label first, as in `G_InitSessionData`? | `holes2-main.md:63`, `review-phase2b-main-entities.md:66` |
| W16 | Does the port spell the `VectorMA` macro per component where the scale holds a call to `flrand` or `crandom`? | `review-phase2b-spawn-npc.md:69-76` |
| W17 | Does `atof` return `Double` as C does, so `val += atof(...)` in `Q3_SetParm` adds in double (also U3)? | `review-phase2b-spawn-npc.md:77-82`, `holes2-npc.md:93` |
| W18 | Does the guide line 548 example change, because it narrows to `Float` before the add where the rule adds in double? | `holes2-npc.md:92` |
| W19 | Do engine bytes reach the buffer unchanged in `trap_BotGetServerCommand` and `ConcatArgs` when a byte is not valid UTF-8? | `review-phase2b-bot.md:42`, `review-phase2b-main-entities.md:65` |
| W20 | After `let message = CharBuf(ent.message!)`, what does each `%s` of `Use_Target_Print` read? | `review-phase2b-main-entities.md:67` |
| W21 | Does `Cmd_GameCommand_f` take a rule 19 note at Raven's off-by-one bound? | `review-phase2b-main-entities.md:64`, `holes2-entities.md:59` |
| W22 | What does the `String` setter store for a `%s` token of 64 bytes or more in `G_ReadSessionData`, and does the store take a note? | `holes2-main.md:65` |
| W23 | Does the read of `enemyLaggedPos[24]` in `Sniper_FaceEnemy` take a rule 19 note or a guard? | `review-phase2b-spawn-npc.md:92` |
| W24 | Does the blank line after `trap_Trace` in `VEH_TurretThink` go in? | `review-phase2b-combat-bones.md:67` |
| W25 | Do `G2Tur_SetBoneAngles` and `EWeb_SetBoneAngles` take the blank lines between the `switch` arms of `NPC_SetBoneAngles`? | `review-phase2b-spawn-npc.md:83-88` |
| W26 | Do the three `g_log.swift` reads of `modNames[j] ?? "(null)"` need the C1 note of the `obit` read? | `phase2-icarus-log.md:39`, `review-phase2-npc-icarus.md:49` |
| W27 | Does the `modNames` note in `g_local.swift` move under the `///` lines and take the word form? | `review-phase2-npc-icarus.md:41-45` |
| W28 | Do the `G_Spawn*` functions take `@discardableResult`, or the call sites that drop the result take `_ =`? | `phase2-bot-items.md:43`, `review-phase2-bot-items.md:53` |
| W29 | Do the unread `point` of `NPC_GM_Pain` and the `dot1` store of `WP_SaberStartMissileBlockCheck` stay as Raven wrote them? | `holes2-npc.md:94`, `review-phase2b-spawn-npc.md:93`, `phase2-saber.md:42` |
| W30 | Do the `portMissing` initializers of `ctfFlagStatusRemap` and `BMS_*` fill, and with what text? | `holes2-entities.md:60` |
| W31 | Does the guide-ordered `goto blockStuff` note keep the "Port-note" label, so the hole counts include it? | `holes2-combat.md:16`, `:57` |
| W32 | Which record texts carry a wrong count or site (R10, R9, N1, and five more), and how does each correction land? | `phase2-bot-items.md:41`, `review-phase2-bot-items.md:51-52`, `phase-2-plan.md` note 5, and five more |
| W33 | Does `lookup.py` get a help flag, and do its stale signature rows get regenerated? | `phase2-find.md:63`, `holes2-bones.md:58` |

### W1. Does the logic `vmMain` in `g_main.swift`, with its ten holes, go now, or at the next g_main re-splice under row F5?

Source. `notes/2026-10-11/holes2-main.md:9-18` lists the ten holes, and finding 1 at `notes/2026-10-11/holes2-main.md:62` gives the decision to the coordinator. Row F5 at `notes/2026-10-09/dispatch-fill-2-walk.md:11` reads "The logic `vmMain` in `g_main.swift` goes at the next g_main re-splice. The re-splice skips the function or a rule excludes it from the stem, so the drafter does not write it back."

Site. The logic function is `Sources/JKAMP_GameLogic/g_main.swift:545-787`, `/// Source: oracle/codemp/game/g_main.c:515` and `func vmMain(_ command: Int32, _ arg0: Int32, ..., _ arg11: Int32) -> Int32 {`, internal, with the ten Port-notes at `:557`, `:592`, `:710`, `:713`, `:716`, `:720`, `:738`, `:746`, `:751`, and `:756`. These lines match the record. The shell function is `Sources/jampgame/jampgame.swift:24-26`, `/// Source: oracle/codemp/game/g_main.c:515`, `@_cdecl("vmMain")`, `public func vmMain(`, and it holds every one of the ten arms: `GAME_CLIENT_CONNECT` at `:51`, `GAME_ROFF_NOTETRACK_CALLBACK` at `:85`, `GAME_ICARUS_GETSTRING` at `:164`, `GAME_ICARUS_GETSETIDFORSTRING` at `:176`, `GAME_NAV_CLEARPATHTOPOINT` at `:181`, `GAME_NAV_CLEARLOS` at `:192`, and `GAME_NAV_CLEARPATHBETWEENPOINTS` at `:195`. Raven: `oracle/codemp/game/g_main.c:515`, `int vmMain( int command, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10, int arg11  ) {`.

Truth. True. No code calls the logic `vmMain`. A grep of `Sources`, `Tests`, `tools`, `docs`, and `Package.swift` for `vmMain` finds no call. `Sources/jampsmoke/main.swift:47` reads `dlsym(handle, "vmMain")`, which finds the `@_cdecl` symbol of the shell, not the internal logic function. No test names the logic function. The other hits are comments: `g_local.swift:830`, `rulings.py:76`, `:126`, `:278`, `:281`, `skeleton.py:725`, `:1037`, and `draft_declarations.py:489`. The tests at `tools/oracle-closure/tests/test_shapes.py:87-96` read the draft of `vmMain`, not the hand file, so they do not change. The ten holes cannot fill in the logic target, because rule 11 (`docs/porting-rules.md:28`) puts the decode of a pointer word in the shell. So the removal breaks no caller and no test. The re-splice of F5 is the splice of `draftcheck.py`. `g_main.swift` has no generated header line, so `adopt.py:31-34` skips it and `skeleton.py` does not write it again. `draftcheck.py:148-171` `splice()` replaces only a hand function whose Raven line `functions()` finds (`draftcheck.py:69-89`), and it never inserts a draft function that the hand file does not hold. `spliced_rows()` at `:108-111` keeps the same test, `if k in h`. So a hand file with no `vmMain` body takes no draft `vmMain` at any later splice. The F5 condition "the re-splice skips the function" is true today, with no wait.

jka-rust. `jka-rust/crates/mp/game/src/g_main.rs:54-59` keeps no logic `vmMain`: "`vmMain` is the shell plus the `impl Dispatch<C> for GameContext` seam" and "The skeleton duplicates were dropped here", cite `oracle/codemp/game/g_main.c:515-696,897,1128`. The one entry is the shell, `jka-rust/crates/jampgame/src/lib.rs:95`, `pub extern "C-unwind" fn vmMain(`.

Helpers. `tools/oracle-closure/rulings.py:264-265`, `NOT_PORTED`, gives the form for a Raven function the port leaves out. `skeleton.py:1094-1097` writes the `Source` line, `// Raven wrote: <signature>`, and `// Not ported: <reason>.`, and no function. `Sources/JKAMP_GameLogic/ai_main.swift:404-406` is a live example for `BotEntityInfo`. That stub has no closing brace, so `functions()` in `draftcheck.py` gives it no span, and no splice writes over it.

Guide. `docs/transcription.md:721` reads "Rule 11 names the shell's `vmMain` as a pointer place, so the decode of a pointer word lives in `Sources/jampgame/jampgame.swift`." No line names the logic `vmMain`. No new guide line is necessary, because the `NOT_PORTED` stub carries the reason.

Verdict. The premise is true. The logic `vmMain` goes now, because no caller, test, or tool needs it, and the splice of `draftcheck.py` already skips a function that the hand file does not hold. Replace `g_main.swift:545-787` with the `NOT_PORTED` stub, and add one entry to `NOT_PORTED` in `rulings.py`, so that a later skeleton or manifest run gives the same text. The Port-note count of `g_main.swift` goes from 10 to 0, and the reference counts of the gate in `docs/oracle-closure.md:16` change at the next full draftcheck run. The stub reads:
```swift
/// Source: oracle/codemp/game/g_main.c:515
// Raven wrote: int vmMain( int command, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10, int arg11  )
// Not ported: the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5.
```
The `rulings.py` entry reads:
```python
    "vmMain": "the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5",
```
The alternate is to wait for the next g_main re-splice as F5 says, but the wait gives nothing, because the splice cannot write the function back.

### W2. What form does the local `G2Trace_t G2Trace` of `G_G2TraceCollide`, a C array of `CollisionRecord_t`, take in Swift?

Source. `notes/2026-10-11/holes2-combat.md:10-15` lists the six blocked holes, "The local `G2Trace_t G2Trace` waits on a form for a local C array of `CollisionRecord_t`. `lookup.py G2Trace_t` has no type, and the two collision traps take one `CollisionRecord`." `notes/2026-10-11/phase-2-plan.md:144` names the same six holes, "which wait on a type outside the read set".

Site. Six Port-notes in `Sources/JKAMP_GameLogic/w_saber.swift`, each two lines below the record's line, because the file moved. `:2006`, "A local `G2Trace_t G2Trace` the table has no type for.", over `G2Trace_t G2Trace;`. `:2027`, "Raven's `memset (&G2Trace, 0, sizeof(G2Trace))` runs over bytes that are not one record with a view." `:2032`, `:2054`, `:2058`, and `:2063`, each "A read of `G2Trace`, a local the draft left as a hole.", over `G2Trace[tN].mEntityNum = -1`, `trap_G2API_CollisionDetectCache ( G2Trace, ... )`, `trap_G2API_CollisionDetect ( G2Trace, ... )`, and the `if (G2Trace[0].mEntityNum != g2Hit->s.number)` block. Raven: `oracle/codemp/game/q_shared.h:1886` `#define MAX_G2_COLLISIONS 16`, `:1888` `typedef CollisionRecord_t G2Trace_t[MAX_G2_COLLISIONS];`. In `oracle/codemp/game/w_saber.c`, `:2338` `G2Trace_t		G2Trace;`, `:2365` `memset (&G2Trace, 0, sizeof(G2Trace));`, `:2369` `G2Trace[tN].mEntityNum = -1;`, `:2396` `trap_G2API_CollisionDetectCache ( G2Trace, g2Hit->ghoul2, angles, g2HitOrigin, level.time, g2Hit->s.number, lastValidStart, lastValidEnd, g2Hit->modelScale, 0, g_g2TraceLod.integer, fRadius );`, `:2400` the same call to `trap_G2API_CollisionDetect`, `:2403` `if (G2Trace[0].mEntityNum != g2Hit->s.number)`, `:2413-2414` the two `VectorCopy` from `G2Trace[0]`, and `:2418` `g2Hit->client->g2LastSurfaceHit = G2Trace[0].mSurfaceIndex;`.

Truth. Amended. `lookup.py` has no row for `G2Trace_t`, because the typedef names an array, not a struct. But the view of the element type already gives the form. `G2Trace_t` is `CollisionRecord_t[16]`, a local array of records, and `CollisionRecord.scratch(count:)` gives a `Slots<CollisionRecord>` over N zeroed slots. The traps take one `CollisionRecord`, and in C the array argument decays to the address of its first record, so `G2Trace[0]` is the same address. The engine writes up to 16 records from that address (`oracle/codemp/ghoul2/G2_API.cpp:2124`, `CollisionRecord_t *collRecMap`), and the scratch holds 16. A second point: the traps take `inout` for `rayStart` and `rayEnd`, and the Swift parameters `lastValidStart` and `lastValidEnd` are `let`. The engine only reads them, `TransformAndTranslatePoint(rayStart, transRayStart, &worldMatrixInv);` and the same for `rayEnd`, at `oracle/codemp/ghoul2/G2_API.cpp:2157-2158` for `G2API_CollisionDetect` and `:2105-2106` for `G2API_CollisionDetectCache`. So a scratch copy of each is behavior-equal.

jka-rust. `jka-rust/crates/mp/qshared/src/common/mp/qcommon/collision_record.rs:21` reads `pub type G2Trace_t = [CollisionRecord_t; MAX_G2_COLLISIONS];`. `jka-rust/crates/mp/game/src/w_saber.rs:2920` reads `let mut G2Trace: G2Trace_t = core::mem::zeroed();`, with the comment "Raven's `memset(&G2Trace,0,sizeof(G2Trace))` is covered by `zeroed()` above." The traps take `G2Trace.as_mut_ptr()`, and the rayStart and rayEnd arguments are `lastValidStart.as_ptr() as *mut f32` (`w_saber.rs:2974-2998`).

Types. `lookup.py G2Trace_t` gives "lookup: no type named G2Trace_t, and no view over it". `lookup.py CollisionRecord_t` gives "Swift view `JKAMP_Game.CollisionRecord`, over one `CollisionRecord_t` in C memory. Source: oracle/codemp/game/q_shared.h:1870.", with `mEntityNum: Int32`, `mSurfaceIndex: Int32`, `mCollisionPosition: JKAShared.vec3_t`, and `mCollisionNormal: JKAShared.vec3_t`. `lookup.py sig` has no row for either trap, because traps are not in the manifests. The compiled signatures are `Sources/JKAMP_Game/Generated/g_syscalls.swift:2197`, `public func trap_G2API_CollisionDetect(_ collRecMap: CollisionRecord, _ ghoul2: OpaquePointer?, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNumber: Int32, _ entNum: Int32, _ rayStart: inout JKAShared.vec3_t, _ rayEnd: inout JKAShared.vec3_t, _ scale: inout JKAShared.vec3_t, _ traceFlags: Int32, _ useLod: Int32, _ fRadius: Float)`, and `:2212`, the same for `trap_G2API_CollisionDetectCache`. `MAX_G2_COLLISIONS` is `public let MAX_G2_COLLISIONS = CJKAShared.MAX_G2_COLLISIONS` at `Sources/JKAShared/Generated/q_shared.swift:508`.

Helpers. `Sources/JKAMP_Game/Generated/Views/CollisionRecord.swift:39-45`, `public static func scratch<Result>(count: Int, _ body: (Slots<CollisionRecord>) throws -> Result) rethrows -> Result`, "Raven's `CollisionRecord_t CollisionRecord[N];` on the stack, a local array of records." `Sources/JKAShared/Views/Int32Indexing.swift:4-12` lets a `Slots` take an `Int32` index. `Sources/JKAShared/Views/Slots.swift:41-44` gives `zero()`, "Raven's `memset(table, 0, sizeof(table))`". No body in `Sources` uses `CollisionRecord` today. Three bodies use the `count` form of another view: `g_client.swift:2686`, `NPC_combat.swift:2270`, and `NPC_AI_Utils.swift:139`.

Guide. `docs/transcription.md:372` gives the form: "A local array of records, `trace_t traces[3];`, is the `count` form, `Trace.scratch(count: 3) { traces in ... }`, a `Slots` over N zeroed slots that live for the closure." Line 362 says the slot is zero at entry. Line 177 drops a memset of zero "over a whole record local" with no enclosing loop, and it does not name a local array of records. Line 230 orders a scratch copy of a `let` vector into a parameter the callee writes, "under a Port-note and a `portMissing` marker until that callee's write is read". The engine read at `G2_API.cpp:2157-2158` closes that condition here. No line names a typedef that hides the array, so the drafter left the local as a hole.

Verdict. The premise is amended: the form exists at guide line 372 and `CollisionRecord.scratch(count:)`, and only the typedef hid it. The closure spans from Raven's declaration to the end of his block. The memset drops, because the slots are zero at entry and nothing writes them before line 2365. The trap takes the first slot. The two `let` vectors pass as scratch copies with no marker, because the engine only reads them. The body reads:
```swift
/// Source: oracle/codemp/game/w_saber.c:2336
private func G_G2TraceCollide(_ tr: JKAMP.Trace, _ lastValidStart: JKAShared.vec3_t, _ lastValidEnd: JKAShared.vec3_t, _ traceMins: JKAShared.vec3_t, _ traceMaxs: JKAShared.vec3_t) -> Bool {
    //Hit the ent with the normal trace, try the collision trace.
    // Raven's record array lives to the end of his block, so the block is the closure.
    return CollisionRecord.scratch(count: Int(MAX_G2_COLLISIONS)) { G2Trace -> Bool in
        var g2Hit: Entity?
        var angles = vec3_t()
        var tN: Int32 = 0
        var fRadius: Float = 0

        // ... Raven's lines to the radius test, as they stand now ...

        // Raven clears the array with `memset` here. The scratch slots are zero at entry, so the body drops the call.
        while tN < MAX_G2_COLLISIONS {
            G2Trace[tN].mEntityNum = -1
            tN += 1
        }
        g2Hit = g_entities[tr.entityNum]

        if g2Hit != nil && g2Hit!.inuse && g2Hit!.ghoul2 != nil {
            // ... Raven's lines to the vehicle test, as they stand now ...

            // The engine only reads the ray, at G2_API.cpp:2157-2158, so the copies are behavior-equal.
            var rayStart = lastValidStart
            var rayEnd = lastValidEnd
            if g_optvehtrace.integer != 0 && g2Hit!.s.eType == ET_NPC && g2Hit!.s.NPC_class == CLASS_VEHICLE && g2Hit!.m_pVehicle != nil {
                trap_G2API_CollisionDetectCache(G2Trace[0], g2Hit!.ghoul2, angles, g2HitOrigin, level.time, g2Hit!.s.number, &rayStart, &rayEnd, &g2Hit!.modelScale, 0, g_g2TraceLod.integer, fRadius)
            } else {
                trap_G2API_CollisionDetect(G2Trace[0], g2Hit!.ghoul2, angles, g2HitOrigin, level.time, g2Hit!.s.number, &rayStart, &rayEnd, &g2Hit!.modelScale, 0, g_g2TraceLod.integer, fRadius)
            }

            if G2Trace[0].mEntityNum != g2Hit!.s.number {
                tr.fraction = 1.0
                tr.entityNum = ENTITYNUM_NONE
                tr.startsolid = 0
                tr.allsolid = 0
                return false
            } else {
                //The ghoul2 trace result matches, so copy the collision position into the trace endpos and send it back.
                tr.endpos = G2Trace[0].mCollisionPosition
                tr.plane.normal = G2Trace[0].mCollisionNormal

                if g2Hit!.client != nil {
                    g2Hit!.client!.g2LastSurfaceHit = G2Trace[0].mSurfaceIndex
                    g2Hit!.client!.g2LastSurfaceTime = level.time
                }
                return true
            }
        }

        return false
    }
}
```
Guide line 177 gains one sentence: "A memset of zero over a whole local array of records in the `count` form drops under the same conditions, and otherwise it is `zero()` on the `Slots`." Line 230 gains: "A trap parameter that the engine only reads takes the scratch copy with a one-line comment that cites the engine read, and no note and no marker." The alternate is to keep the memset as `G2Trace.zero()`, which gives the same bytes and keeps Raven's line.

### W3. Is the `sig` blocker on the four `boltMatrix` holes of `WP_CalcVehMuzzle` stale, so the holes take the `MdxaBone.scratch` form of `g_active.swift`?

Source. `notes/2026-10-11/holes2-combat.md:28-31` lists the four holes as blocked on "the `sig` row of `trap_G2API_GetBoltMatrix_NoRecNoRot`". Findings 1 and 2 at `notes/2026-10-11/holes2-combat.md:53-54` say the file has four holes, not three, and that the blocker looks stale. The blocker comes from `notes/2026-10-11/holes-g_weapon-g_team-g_session.md:12`, "`lookup.py sig` has no row for the trap, so its Swift signature is outside the read set", and `notes/2026-10-11/frame-path-round.md:29`. `notes/2026-10-11/phase-2-plan.md:144` counts "the three `boltMatrix` holes".

Site. Four Port-notes in `Sources/JKAMP_GameLogic/g_weapon.swift`, two lines below the record's lines. `:3485`, "The draft of this statement did not compile, and the compiler wrote "failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)".", over `mdxaBone_t boltMatrix;`. `:3504`, `:3507`, and `:3510`, each "A read of `boltMatrix`, a local the draft left as a hole.", over `trap_G2API_GetBoltMatrix_NoRecNoRot(ent->ghoul2, 0, pVeh->m_iMuzzleTag[muzzleNum], &boltMatrix, vehAngles, ent->client->ps.origin, level.time, NULL, ent->modelScale)`, `BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, pVeh->m_vMuzzlePos[muzzleNum])`, and `BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, pVeh->m_vMuzzleDir[muzzleNum])`. The first hole is a compile hole, not a `sig` hole. Raven: `oracle/codemp/game/g_weapon.c:3580-3606`, with `mdxaBone_t boltMatrix;` at `:3583` and the three statements at `:3603-3606`.

Truth. True. The trap has a compiled Swift signature, so no `sig` row is necessary. `lookup.py sig` reads only the manifests, and the manifests hold no trap, so the "no row" answer is a read-set limit, not a missing signature. `g_active.swift:840-844` already calls the sister trap `trap_G2API_GetBoltMatrix` with the same parameter shape inside `MdxaBone.scratch { boltMatrix in ... }`. D8 is in the tree: `Sources/JKAMP/Generated/Views/Vehicle.swift:187` and `:190` give `m_vMuzzlePos` and `m_vMuzzleDir` as `Slots<JKAShared.vec3_t>`, and `g_weapon.swift:4152-4153` reads `start = pVeh!.m_vMuzzlePos[i]`. `g_vehicleTurret.swift:35` passes `&pVeh.m_vMuzzlePos[curMuzzle]` to an `inout vec3_t`, so the write target compiles through the nonmutating setter. The count of four in finding 1 is also true.

jka-rust. `jka-rust/crates/mp/game/src/g_weapon.rs:4356` `pub fn WP_CalcVehMuzzle`, with `let mut boltMatrix: mdxaBone_t = std::mem::zeroed();` at `:4362` and `trap::G2API_GetBoltMatrix_NoRecNoRot(` with `&mut boltMatrix,` at `:4390-4396`.

Types. `lookup.py sig trap_G2API_GetBoltMatrix_NoRecNoRot` gives "lookup: no function named trap_G2API_GetBoltMatrix_NoRecNoRot in the manifests". The compiled signature is `Sources/JKAMP_Game/Generated/g_syscalls.swift:2048-2050`, `@discardableResult` `public func trap_G2API_GetBoltMatrix_NoRecNoRot(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boltIndex: Int32, _ matrix: JKAMP.MdxaBone, _ angles: JKAShared.vec3_t, _ position: JKAShared.vec3_t, _ frameNum: Int32, _ modelList: UnsafeMutablePointer<Int32>?, _ scale: inout JKAShared.vec3_t) -> Bool`. `lookup.py Vehicle_t m_vMuzzlePos` gives "`vec3_t[12] m_vMuzzlePos`  ->  `m_vMuzzlePos: Slots<Slots<Float>>`  Array of 12.", which is stale against the generated view after D8. `BG_GiveMeVectorFromMatrix` is `public func BG_GiveMeVectorFromMatrix(_ boltMatrix: JKAMP.MdxaBone, _ flags: Int32, _ vec: inout JKAShared.vec3_t)` at `Sources/JKAMP_BG/bg_public.h.swift:9`.

Helpers. `Sources/JKAMP/Generated/Views/MdxaBone.swift:33`, `public static func scratch<Result>(_ body: (MdxaBone) throws -> Result) rethrows -> Result`. `g_strap.swift:17-18` wraps the same trap for bg, which shows that the signature compiles.

Guide. `docs/transcription.md:350` gives the scratch form, "A scratch C struct on the stack, `trace_t trace;`, is the `scratch` helper on its view, and Raven's block is the closure". Line 364 says the closure returns a value read from the slot, never the view. No line is missing. The phase-2 plan line `notes/2026-10-11/phase-2-plan.md:144` is stale twice: the count is four, and the blocker is gone.

Verdict. The premise is true. The blocker is stale, and the four holes take the `MdxaBone.scratch` form now, with the D8 targets. The closure spans from Raven's declaration to the end of his block, as at `g_active.swift:840`, so the early `return` returns from the closure and then from the function. The function reads:
```swift
/// Source: oracle/codemp/game/g_weapon.c:3580
func WP_CalcVehMuzzle(_ ent: Entity, _ muzzleNum: Int32) {
    let pVeh: Vehicle? = ent.m_pVehicle
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var vehAngles = vec3_t()


        if pVeh!.m_iMuzzleTime[muzzleNum] == level.time {
            //already done for this frame, don't need to do it again
            return
        }
        //Uh... how about we set this, hunh...?  :)
        pVeh!.m_iMuzzleTime[muzzleNum] = level.time

        vehAngles = ent.client!.ps.viewangles
        if pVeh!.m_pVehicleInfo != nil && (pVeh!.m_pVehicleInfo!.type == VH_ANIMAL || pVeh!.m_pVehicleInfo!.type == VH_WALKER || pVeh!.m_pVehicleInfo!.type == VH_SPEEDER) {
            vehAngles[ROLL] = 0
            vehAngles[PITCH] = vehAngles[ROLL]
        }

        trap_G2API_GetBoltMatrix_NoRecNoRot(ent.ghoul2, 0, pVeh!.m_iMuzzleTag[muzzleNum], boltMatrix, vehAngles, ent.client!.ps.origin, level.time, nil, &ent.modelScale)
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &pVeh!.m_vMuzzlePos[muzzleNum])
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &pVeh!.m_vMuzzleDir[muzzleNum])
    }
}
```
The record line `notes/2026-10-11/phase-2-plan.md:144` changes "the three `boltMatrix` holes of `g_weapon.swift`, which wait on a `sig` row," to "the four `boltMatrix` holes of `g_weapon.swift`, which take the `MdxaBone.scratch` form by ruling W3,". The alternate is a closure over the last three statements only, which gives the same behavior, but it departs from the "Raven's block is the closure" form of line 350.

### W4. What form fills the four stores `pm.trace = trap_Trace` and `pm.pointcontents = trap_PointContents` in `SpectatorThink` and `ClientThink_real`?

Source. `notes/2026-10-11/holes2-combat.md:18-23` gives the shape, "the store of a Swift trap function into a `@convention(c)` field of `pmove_t`, `pm.trace = trap_Trace`. No thunk for `trap_Trace` as a `PmoveTrace` exists, and the guide orders no hand closure in a callback field." Finding 3 at `notes/2026-10-11/holes2-combat.md:55` asks for a docket row. `notes/2026-10-11/phase-2-plan.md:140` reads "The 9 `pm` holes of `g_active.swift` take guide lines 325 (A4) and 552 (A5)."

Site. Four Port-notes in `Sources/JKAMP_GameLogic/g_active.swift`. `:705` and `:708` in `SpectatorThink`, four lines below the record's `:701` and `:704`, because the file moved. `:2562` and `:2565` in `ClientThink_real`, the record's lines. Each reads "A read of `pm`, a local the draft left as a hole.", over `pm.trace = trap_Trace` and `pm.pointcontents = trap_PointContents`, with `portMissing("SpectatorThink", source: "oracle/codemp/game/g_active.c:678")` or `portMissing("ClientThink_real", source: "oracle/codemp/game/g_active.c:1939")`. The `pm` local is `JKAMP.Pmove.scratch { pm in` at `:683` and `:1764`. Raven: `oracle/codemp/game/g_active.c:701-702` and `:2905-2906`, `pm.trace = trap_Trace;` and `pm.pointcontents = trap_PointContents;`.

Truth. True, and the holes are on the frame path. `bg_pmove.swift`, `bg_saber.swift`, and `bg_slidemove.swift` call `pm.runTrace(...)` 45 times and `pm.runPointcontents(...)` 5 times. `Pmove.swift:247-252` traps with "trace is NULL" when the field is NULL, and `:270-275` traps the same way for `pointcontents`. So with no store, the first `Pmove(pm)` of each client frame stops, after the `portMissing` markers. A thunk in the logic target cannot fill the field. A `PmoveTrace` receives five `OpaquePointer?`, and four of them point at `vec3_t`. The logic target has no view over a bare vector and no `Unsafe` read under rule 11 (`docs/porting-rules.md:28`), and `trap_Trace` takes `vec3_t` values. The thunk must sit in the view target of the traps, `JKAMP_Game`, where `Syscall.call` already takes pointer words. There the thunk passes the words through with no conversion, as Raven's `trap_Trace` at `oracle/codemp/game/g_syscalls.c:148` does. On the plan count: the nine `pm` holes are two A4 holes (`pm.baseEnt`), two A5 holes (`pm.entSize`), one A6 hole (`pm.pmove_fixed`), and these four, which no row covers. The plan line is wrong for five of the nine.

jka-rust. jka-rust does not set the fields. `jka-rust/crates/mp/game/src/g_active.rs:924-925` and `:3107-3108` read "The `pm.trace`/`pointcontents` fields stay for layout only." and "Bg logic reaches the engine through `BgTraps`, threaded into `Pmove` below." The Swift bg calls through the C pointer instead, so jka-rust gives no form here.

Types. `Sources/JKAMP/Generated/Views/Callbacks.swift:7`, `public typealias PmovePointcontents = @convention(c) (OpaquePointer?, Int32) -> Int32`, and `:9`, `public typealias PmoveTrace = @convention(c) (OpaquePointer?, OpaquePointer?, OpaquePointer?, OpaquePointer?, OpaquePointer?, Int32, Int32) -> Void`. `Sources/JKAMP/Generated/Views/Pmove.swift:247`, `public var trace: PmoveTrace`, and `:270`, `public var pointcontents: PmovePointcontents`, each with a `nonmutating set`. `Sources/JKAMP_Game/Generated/g_syscalls.swift:253`, `public func trap_Trace(_ results: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t, _ maxs: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ passEntityNum: Int32, _ contentmask: Int32)`, whose call is `Syscall.call(G_TRACE, results, start, mins, maxs, end, passEntityNum, contentmask, 0, 10)` at `:257`. `:281`, `public func trap_PointContents(_ point: JKAShared.vec3_t, _ passEntityNum: Int32) -> Int32`, whose call is `Syscall.call(G_POINT_CONTENTS, point, passEntityNum)` and `return Int32(truncatingIfNeeded: word)` at `:283-285`. `Sources/JKAShared/SyscallWord.swift:25` and `:45` make `OpaquePointer` and `Optional` of a word a `SyscallWord`.

Helpers. None for the pmove fields. The J1 thunks at `Sources/JKAMP_GameLogic/Generated/Callbacks.swift` cover `think`, `use`, `touch`, `die`, `pain`, `reached`, and `blocked` only, and each takes view handles, for example `static let AimAtTarget: EntityThink = { JKAMP_GameLogic.AimAtTarget(Entity(handle: $0!)) }` at `:11`. `VehicleInfoThunks` at `Sources/JKAMP_GameLogic/WalkerNPC.swift:435` is the hand pattern for a callback field of another record. No test sets `pm.trace`, and no code in `Sources` stores into either field.

Guide. `docs/transcription.md:507-509` gives the callback store, "A Raven store such as `ent->think = Name` uses the generated thunk in `Callbacks.swift`" and "The transcriptor never writes a closure into a callback field by hand." Line 510 gives the per-record namespace, `pVehInfo.Update = VehicleInfoThunks.Update`. Line 335 puts `pmove_t.trace` and `pmove_t.pointcontents` in the `NEVER_NULL` table. No line covers a trap stored into a callback field. The missing line is the one below.

Verdict. The premise is true, and the plan count of `phase-2-plan.md:140` is wrong: four of the nine `pm` holes have no row. The form is two C-shaped thunks in `JKAMP_Game`, beside the traps, that pass the words through to the same syscalls. A new hand file `Sources/JKAMP_Game/PmoveThunks.swift` reads:
```swift
import JKAMP
import JKAShared

/// This holds Raven's two traps as the C functions that `Pmove` calls through `pmove_t.trace` and `pmove_t.pointcontents`.
/// Each passes the pointer words to the syscall of its trap, as Raven's `trap_Trace` and `trap_PointContents` did.
public enum PmoveThunks {
    /// Source: oracle/codemp/game/g_syscalls.c:148
    public static let trap_Trace: PmoveTrace = { results, start, mins, maxs, end, passEntityNum, contentmask in
        _ = Syscall.call(G_TRACE, results, start, mins, maxs, end, passEntityNum, contentmask, 0, 10)
    }

    /// Source: oracle/codemp/game/g_syscalls.c:157
    public static let trap_PointContents: PmovePointcontents = { point, passEntityNum in
        Int32(truncatingIfNeeded: Syscall.call(G_POINT_CONTENTS, point, passEntityNum))
    }
}
```
The four sites read `pm.trace = PmoveThunks.trap_Trace` and `pm.pointcontents = PmoveThunks.trap_PointContents`. The guide after line 510 gains: "Raven's store of a trap into a callback field of `pmove_t`, `pm.trace = trap_Trace`, uses the thunk in `Sources/JKAMP_Game/PmoveThunks.swift`, `pm.trace = PmoveThunks.trap_Trace`, because only the view target of the traps can pass the pointer words on." The record line `phase-2-plan.md:140` changes to "The 9 `pm` holes of `g_active.swift` take guide lines 325 (A4), 552 (A5), and 539 (A6), and the four `trace` and `pointcontents` stores take the thunk of ruling W4." The alternate is to make `traps.py` write the same enum at the end of `g_syscalls.swift` from a `rulings.py` table, which is close but adds a generator change for two lines.

### W5. Does the stale reason text "A read of `pm`, a local the draft left as a hole." on the four `pm` holes change now, or stay until the holes fill?

Source. Finding 4 at `notes/2026-10-11/holes2-combat.md:56`, "The reason text "A read of `pm`, a local the draft left as a hole." on the four `pm` holes that stand is stale, because `pm` is a declared local now. The text stays until the holes fill." The holes are the four of row W4, `notes/2026-10-11/holes2-combat.md:18-23`.

Site. Four lines in `Sources/JKAMP_GameLogic/g_active.swift`, each `// Port-note: A read of `pm`, a local the draft left as a hole.`: `:705` over `// Raven wrote: pm.trace = trap_Trace`, `:708` over `// Raven wrote: pm.pointcontents = trap_PointContents`, `:2562` over `// Raven wrote: pm.trace = trap_Trace`, and `:2565` over `// Raven wrote: pm.pointcontents = trap_PointContents`. The `pm` local is declared at `:683` and `:1764`, `JKAMP.Pmove.scratch { pm in`. Raven: `oracle/codemp/game/g_active.c:701-702` and `:2905-2906`.

Truth. True, and record-only. The text names a cause that no longer holds, because both functions declare `pm` and the lines around each hole read and write it, for example `pm.tracemask = MASK_PLAYERSOLID & ~CONTENTS_BODY` at `:704`. The real cause is the one of W4: no C-shaped thunk exists for a trap stored into a `pmove_t` callback field. The text changes no behavior, because each hole runs its `portMissing` marker whatever the note says.

jka-rust. Not applicable. jka-rust keeps the two fields for layout only, `jka-rust/crates/mp/game/src/g_active.rs:924` and `:3107`, and has no hole text.

Helpers. None.

Guide. No guide line covers the reason text of a Port-note that stands. The compile-gate prefix at `tools/oracle-closure/draftcheck.py:63` matches only the "The draft of this statement did not compile" text, so a change of these four texts does not touch `hand_due()`.

Verdict. The premise is true, and the row is record-only. The four texts stay as they are, because the W4 fill in the same round deletes all four Port-notes and their markers, and a rewrite now adds a diff that the fill removes. If the user does not ratify W4 in this walk, each of the four lines changes to `// Port-note: Raven stores a trap into a callback field of `pmove_t`, and no C-shaped thunk for the trap exists yet.`, and the finding at `notes/2026-10-11/holes2-combat.md:56` stays as written.

### W6. Does `fatalErrorPointer` become an integer byte offset in the generated storage, and through which rulings.py entry?

Source. `notes/2026-10-11/holes2-bot.md:24-27` (the four blocked holes), `:62-68` (the GameWorld properties section), and finding 4 at `:75`. The frame-path round met the same four holes, and no row of that docket ruled them.

Site. The records give lines 1517, 1520, 1523, and 1601. The lines moved by two. Now the three holes of `NAV_WaypointsTooFar` sit at `Sources/JKAMP_GameLogic/g_nav.swift:1519-1521`, `// Raven wrote: if ( (fatalErrorPointer-fatalErrorString)+len >= sizeof( fatalErrorString ) ) { Com_Error( ERR_DROP, "%s%s%dTOO MANY FATAL NAV ERRORS!!!\n", fatalErrorString, temp, fatalErrors ); return qtrue; }`, at `:1522-1524`, `// Raven wrote: strcat( fatalErrorPointer, temp )`, and at `:1525-1527`, `// Raven wrote: fatalErrorPointer += len`. The hole of `NAV_CalculatePaths` sits at `:1603-1605`, `// Raven wrote: fatalErrorPointer = &fatalErrorString[0]`. The storage is `Sources/JKAMP_Game/Generated/Storage/GameVariables.swift:531`, `public var fatalErrorPointer: String = ""`, and the accessor is `g_nav.swift:74`, `var fatalErrorPointer: String {`. Raven: `oracle/codemp/game/g_nav.c:1616` `char *fatalErrorPointer = NULL;`, `:1642` `if ( (fatalErrorPointer-fatalErrorString)+len >= sizeof( fatalErrorString ) )`, `:1647` `strcat( fatalErrorPointer, temp );`, `:1648` `fatalErrorPointer += len;`, and `:1746` `fatalErrorPointer = &fatalErrorString[0];`.

Truth. True. Every use of `fatalErrorPointer` is pointer arithmetic over `fatalErrorString` or a write through it, so it is a write cursor of guide line 646, and a `String` cannot hold it. The three holes do not compile today, and the compiler texts at `:1519`, `:1522`, and `:1525` say so. `NAV_CalculatePaths` sets the cursor at `g_nav.c:1746` before any use. All four callers of `NAV_WaypointsTooFar` at `g_nav.c:1759`, `:1772`, `:1785`, and `:1798` are comments, so no input reaches the three holes in Raven's build. The fill keeps the function compiled and faithful.

jka-rust. `jka-rust/crates/mp/game/src/game_globals.rs:825-829` holds `pub fatalErrorPointer: usize`, with the comment that `fatalErrorPointer - fatalErrorString` is the value directly. `g_nav.rs:2161` tests `ctx.world.globals.fatalErrorPointer + len >= 4096`, `:2176` steps `fatalErrorPointer += len`, and `:2271` resets it to `0`. jka-rust uses an offset with no NULL state.

Types. `python3 tools/oracle-closure/lookup.py sig NAV_WaypointsTooFar` gives `g_nav.c  func NAV_WaypointsTooFar(_ wp1: Entity, _ wp2: Entity) -> Bool`. `lookup.py sig Com_Error` gives `g_main.c  public func Com_Error(_ level: Int32, _ error: String, _ args: any JKAShared.FormatArg...) -> Never`. The tool also warns that the signature rows are stale for 36 stubs. `fatalErrorString` is `JKAShared.CharBuf` at `GameVariables.swift:535`, and the local `temp` is `CharBuf(1024)` at `g_nav.swift:1505`.

Helpers. `Sources/JKAShared/CString.swift:286` gives `strcat(_ dest: inout CharBuf, _ source: CharBuf, at offset: some BinaryInteger)`, which appends at the first NUL from the offset, Raven's `strcat(marker, source)`. The generator path exists too. `tools/oracle-closure/skeleton.py:507-510` sets the Swift type of a file-scope variable from `TYPES` in `rulings.py`, and `skeleton.py:663-665` turns Raven's `= NULL` into `nil` when the type ends in `?`. For a non-optional `Int32`, `initializer` returns `None`, and `skeleton.py:1306-1309` then writes a `// TODO: Port initializer` line above the property.

Guide. Line 628: "A pointer into the buffer, Raven's `&skinName[len-3]` or the `char *slash` that `Q_strrchr` returns, is its byte offset, an `Int32`." Line 648: "A write cursor is the byte offset of the pointer rule instead, an `Int32` over the named buffer." Line 630 gives Raven's `NULL` cursor as `nil` of an `Int32?`. `rulings.py:159-165` gives the `TYPES` form, the A2 entry for `gSiegeRoundWinningTeam`. No guide line is missing.

Verdict. The premise is amended. The variable becomes a byte offset, but the type is `Int32?`, because Raven initializes it to `NULL`, and the generator already writes `nil` for `NULL` into an optional with no code change. A plain `Int32` needs a change in `skeleton.py` `initializer`, or it gets a `TODO` line. The `rulings.py` entry goes into `TYPES` after the A2 entry:
```python
    # Raven declares `char *fatalErrorPointer = NULL` at g_nav.c:1616, a write cursor into `fatalErrorString`,
    # so it is the byte offset of guide line 648, and `nil` is his NULL.
    "fatalErrorPointer": "Int32?",
```
The generator then writes `public var fatalErrorPointer: Int32? = nil` at `GameVariables.swift:531`, and the accessor at `g_nav.swift:74` becomes `var fatalErrorPointer: Int32? {`. The four holes read:
```swift
if fatalErrorPointer! + len >= Int32(fatalErrorString.count) {
    Com_Error(ERR_DROP, "%s%s%dTOO MANY FATAL NAV ERRORS!!!\n", fatalErrorString, temp, fatalErrors)
    return true
}
strcat(&fatalErrorString, temp, at: fatalErrorPointer!)
fatalErrorPointer! += len
```
```swift
fatalErrorPointer = 0
```
Raven's `fatalErrorPointer-fatalErrorString` is the offset itself, because the base is offset 0. The `return true` stays after `Com_Error`, as `FighterNPC.swift:89-90` keeps it. A close alternate is `"fatalErrorPointer": "Int32"` with one line in `skeleton.py` `initializer` that maps `NULL` to `0` for an `Int32` cursor, as jka-rust does. That removes the three `!` marks but drops Raven's NULL state.

### W7. Which form spells Raven's `placesecond = strstr(place+1, group)`, a search from a cursor that returns an offset into the whole buffer?

Source. `notes/2026-10-11/holes2-bot.md:37-40` (the four holes) and `:45-57` (the shape with no form). `notes/2026-10-11/holes2-main.md:41` raises the same shape for `strchr` from a cursor in `G_ProcessIPBans`, row W8.

Site. The records give lines 72, 76, 158, and 162. Each Port-note still starts at that line. `Sources/JKAMP_GameLogic/ai_util.swift:72-74`, `// Raven wrote: placesecond = strstr(place+1, group)`, and `:76-78`, `// Raven wrote: if (placesecond) { startpoint += (placesecond - place); startletter += (placesecond - place); place = placesecond; } else { failure = 1; break; }`, both in `GetValueGroup`. `:158-160`, `// Raven wrote: placesecond = strstr(place+1, key)`, and `:162-164`, `// Raven wrote: if (placesecond) { startpoint += placesecond - place; startletter += placesecond - place; place = placesecond; } else { place = NULL; break; }`, both in `GetPairedValue`. The locals are `var place: Int32?` and `var placesecond: Int32?` at `:47-48` and `:111-112`. Raven: `oracle/codemp/game/ai_util.c:187` `placesecond = strstr(place+1, group);` with the test at `:189-199`, and `ai_util.c:288` `placesecond = strstr(place+1, key);` with the test at `:290-300`. In all of `oracle/codemp/game/*.c`, the only other search that starts at a cursor is `g_svcmds.c:209` `s = strchr(s, ' ');`, row W8.

Truth. True. `strstr(buf[(place! + 1)...], group)` under guide line 629 returns an offset from the start of the suffix, not from `buf`. Concrete input: `buf` = `"x a\na {"` and `group` = `"a"`. `place` is 2. Raven's `strstr(place+1, "a")` points at byte 4, so `placesecond - place` is 2. The suffix call returns 1, and a site that uses it as the offset steps `startpoint` by -1. One amendment: the record gives `failure = 1; break` as the else arm of both read holes, but `GetPairedValue` sets `place = NULL` and breaks (`ai_util.c:298`), and the Port-note at `:163` says so.

jka-rust. `jka-rust/crates/mp/game/src/ai_util.rs:98` and `:205` keep raw pointers, call `c_strstr(place.add(1), group_b)`, and compute `let delta = placesecond as isize - place as isize`. The pointer result is an address into the whole buffer, the same as Raven's.

Types. `lookup.py sig GetValueGroup` gives `ai_util.c  func GetValueGroup(_ buf: inout JKAShared.CharBuf, _ group: String, _ outbuf: inout JKAShared.CharBuf) -> Int32`. `lookup.py sig GetPairedValue` gives `ai_util.c  func GetPairedValue(_ buf: inout JKAShared.CharBuf, _ key: String, _ outbuf: inout JKAShared.CharBuf) -> Int32`.

Helpers. None for a search from an offset. `Sources/JKAShared/CString.swift:395`, `:411`, `:416`, and `:421` hold `strchr` over `CharBuf` and `String` with an `Int32` or a `Unicode.Scalar`, and `:429`, `:456`, and `:461` hold `strstr` over `CharBuf` and `String`. All of them search from byte 0 and return an offset from the start of their argument. The `at:` precedents are `strcat` at `CString.swift:276` and `:286`, `strcpy` at `:183`, `Q_strcat` at `Sources/JKAShared/q_shared.c.swift:891`, `Com_sprintf` at `q_shared.c.swift:974` (ruling L2), `RemoveColorEscapeSequences` at `Sources/JKAMP_GameLogic/ai_main.swift:773` (ruling O5), and the read `Q_IsColorString(buf, at: i)` of guide line 298.

Guide. Line 628 gives a pointer into a buffer as its byte offset into that buffer. Line 629 gives a read through it as the suffix subscript. Line 630: "`strchr`, `strstr`, and `Q_strrchr` return that offset as `Int32?`, so `if let slash` is Raven's `if (slash)`." Line 659 gives the `at:` form of `strcpy` and `strcat`. No line gives a search that starts at a cursor. The missing line names the `at:` form of `strchr` and `strstr`.

Verdict. The premise is true, with the `GetPairedValue` else-arm amendment. The form is an `at:` overload of `strchr` and `strstr` in `Sources/JKAShared/CString.swift`, which searches from the offset and returns the offset into the whole buffer, so the result is the same byte offset of guide line 628 that Raven's pointer is. The site sum works too, but it puts the arithmetic of a C pointer on the page at each of the three sites. The overloads go after `:421` and after `:461`:
```swift
/// This finds the first byte equal to `c` from byte `offset` on, Raven's `strchr(s, c)` through a pointer into the buffer.
/// It returns the offset into the whole buffer, or `nil` when there is no match.
public func strchr(_ s: CharBuf, _ c: Int32, at offset: some BinaryInteger) -> Int32? {
    guard let found = strchr(s[offset...], c) else { return nil }
    return Int32(offset) + found
}
```
```swift
/// This finds the first occurrence of `needle` from byte `offset` on, Raven's `strstr(s, needle)` through a pointer into the buffer.
/// It returns the offset into the whole buffer, or `nil` when there is no match.
public func strstr(_ s: CharBuf, _ needle: String, at offset: some BinaryInteger) -> Int32? {
    guard let found = strstr(s[offset...], CharBuf(needle)) else { return nil }
    return Int32(offset) + found
}
```
The `GetValueGroup` holes read:
```swift
placesecond = strstr(buf, group, at: place! + 1)

if let placesecond {
    startpoint += (placesecond - place!)
    startletter += (placesecond - place!)
    place = placesecond
} else {
    failure = 1
    break
}
```
The `GetPairedValue` holes read the same with `key`, and the else arm is `place = nil` and `break`. Guide line 630 gains the sentence: "A search that starts at a pointer into the buffer, `strstr(place+1, group)` or `strchr(s, ' ')`, takes the `at:` overload, `strstr(buf, group, at: place! + 1)`, and returns the offset into the whole buffer."

### W8. How does `G_ProcessIPBans` walk the cvar memory of `g_banIPs` with two cursors and pass the cursor `t` to `AddIP`?

Source. `notes/2026-10-11/holes2-main.md:24-26` (the three holes), `:36-45` (the shape of the holes and the proposed form), and finding 3 at `:64`. `notes/2026-10-11/frame-path-round.md:98` names the same block, a `strchr` overload at an offset and a buffer offset into `AddIP`.

Site. The records give lines 203, 206, and 213. The Port-note lines are now `Sources/JKAMP_GameLogic/g_svcmds.swift:193`, `:196`, and `:203`. `:193-195`, `// Raven wrote: char *s;`. `:196-198`, `// Raven wrote: t;`. `:203-205`, `// Raven wrote: for (t = s = g_banIPs.string; *t; /* */ ) { s = strchr(s, ' '); if (!s) break; while (*s == ' ') *s++ = 0; if (*t) AddIP( t ); t = s; }`. The copy stays at `:199-201`, `var str = CharBuf(1024)` and `Q_strncpyz(&str, g_banIPs.string, Int32((str).count))`. `AddIP` is `:159`, `func AddIP(_ str: inout JKAShared.CharBuf) {`, and it passes `&str` to `StringToFilter` at `:177`. Raven: `oracle/codemp/game/g_svcmds.c:201-218`, with `char *s, *t;` at `:203`, `Q_strncpyz( str, g_banIPs.string, sizeof(str) );` at `:206`, the loop at `:208-217`, and `AddIP` at `:173-195`. The one caller is a comment, `g_main.c:933` `//G_ProcessIPBans();`.

Truth. True, and finding 3 is true. Raven sets `t = s = g_banIPs.string` at `g_svcmds.c:208`, not `str`, so `*s++ = 0` writes NUL bytes into the 256 bytes of the cvar. Concrete input: `g_banIPs` = `"1.2.3.4 5.6.7.8 "`. Raven adds both filters, and after the loop the cvar memory reads `"1.2.3.4"` with NUL bytes at offsets 7 and 15. A final token with no space after it is never added, because `strchr` returns NULL and the loop breaks first. `AddIP` writes no byte through `str`. It reads `ipFilters`, passes `str` to `StringToFilter`, and `StringToFilter` (`g_svcmds.c:23-60`) only reads and steps its `s`. So a copy of the suffix at `t` is behavior-equal for the call. The step of `s` in `StringToFilter` keeps the `inout CharBuf` under guide line 210. `G_ProcessIPBans` has no live caller in Raven's MP build, so no input reaches it at run time.

jka-rust. `jka-rust/crates/mp/game/src/g_svcmds.rs:233-257` reads the cvar into a Rust `&str`, finds each space with `bytes[t..].iter().position(|&c| c == b' ')`, which gives an offset from `t` and adds `t`, and passes a fresh C string of the token to `AddIP`. It writes no byte into the cvar memory, so it differs from Raven on finding 3.

Types. `lookup.py sig AddIP` gives `g_svcmds.c  func AddIP(_ str: inout JKAShared.CharBuf)`. `lookup.py sig G_ProcessIPBans` gives `g_svcmds.c  func G_ProcessIPBans()`. `lookup.py vmCvar_t string` gives `` `char[256] string`  ->  `string: String`, `stringBuffer: JKAShared.CharBuf`  Array of 256. `` on the view `JKAMP.VmCvar`. `Sources/JKAMP/Generated/Views/VmCvar.swift:92-95` gives `stringBuffer` a getter that reads the C bytes and a `nonmutating set` that stores them back. `g_banIPs` is `var g_banIPs: JKAMP.VmCvar { world.storage.g_banIPs }` at `Sources/JKAMP_GameLogic/g_main.swift:301`.

Helpers. `strchr(_ s: CharBuf, _ c: Int32)` at `Sources/JKAShared/CString.swift:395` searches from byte 0 only. The W7 overload `strchr(_ s: CharBuf, _ c: Int32, at offset: some BinaryInteger) -> Int32?` gives the search from the cursor. The suffix subscript at `Sources/JKAShared/CharBuf.swift:62` gives the copy at `t`, and it is get-only, so `&g_banIPs.stringBuffer[t...]` does not compile and the copy needs a local. `g_cmds.swift:593` passes `&ent.client!.sess.IPstringBuffer` to `AddIP`, the precedent for a view buffer through `inout`.

Guide. Line 646: "Raven's `char *` over a named buffer is a read cursor when no use of it writes bytes, and a write cursor when one does." Line 648: "A write cursor is the byte offset of the pointer rule instead, an `Int32` over the named buffer." Line 625 gives the post-increment as the statement and then the step. Line 211: "A caller with a `String` for that parameter passes `var buf = CharBuf(name)` and `&buf`, and reads `String(buf)` after the call where Raven reads the result." Line 629 gives a read through a pointer as the suffix subscript. No line gives a pointer into a buffer passed to an `inout CharBuf` parameter the callee does not write. The W7 guide sentence covers the search from the cursor.

Verdict. The premise is true, and finding 3 is true. The port walks `g_banIPs.stringBuffer`, the cvar memory, as Raven does, with `s` and `t` as `Int32` write cursors under guide line 648. It uses the same cursor search form as W7, `strchr(buf, c, at: s)`, which returns the offset into the whole buffer. `t` passes to `AddIP` as a copy of the suffix, because `AddIP` writes no byte through it. The two declaration holes become `var s: Int32` and `var t: Int32`, and the loop hole reads:
```swift
t = 0
s = 0
while g_banIPs.stringBuffer[t] != 0 {
    guard let found = strchr(g_banIPs.stringBuffer, Int32(ascii: " "), at: s) else { break }
    s = found
    while g_banIPs.stringBuffer[s] == Int32(ascii: " ") {
        g_banIPs.stringBuffer[s] = 0
        s += 1
    }
    if g_banIPs.stringBuffer[t] != 0 {
        var token = g_banIPs.stringBuffer[t...]
        AddIP(&token)
    }
    t = s
}
```
Guide line 211 gains the sentence: "A pointer into a buffer passed to an `inout CharBuf` parameter that the callee does not write is a copy of the suffix, `var token = g_banIPs.stringBuffer[t...]` and `AddIP(&token)`."

### W9. What form fills the three `Q3_Set*TextColor` holes, where the `textcolor_*` globals are `[Float]` and `SetTextColor` takes `vec4_t` by value?

Source. notes/2026-10-11/holes2-npc.md:13-15 (the three hole rows) and finding 1 at notes/2026-10-11/holes2-npc.md:90.

Site. The holes moved from the record lines 4505, 4521, and 4537. `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4533-4537`, `private func Q3_SetCaptionTextColor(_ color: String) {` with `// Raven wrote: SetTextColor(textcolor_caption,color)` and `portMissing("Q3_SetCaptionTextColor", source: "oracle/codemp/game/g_ICARUScb.c:4955")`. `:4549-4553` is the same for `textcolor_center`, and `:4565-4569` for `textcolor_scroll`. Each Port-note quotes the compiler: "cannot convert value of type '[Float]' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')". The callee is `g_ICARUScb.swift:4518`, `private func SetTextColor(_ textcolor: JKAShared.vec4_t, _ color: String) {`, and its body is only `G_DebugPrint(WL_WARNING, "SetTextColor: NOT SUPPORTED IN MP\n")`. The globals are `Sources/JKAMP_Game/Generated/Storage/GameVariables.swift:275`, `:279`, and `:283`, `public var textcolor_caption: [Float] = [Float](repeating: 0, count: 4)` and the same for `textcolor_center` and `textcolor_scroll`, read through the hand accessors at `g_ICARUScb.swift:19-33`, `var textcolor_caption: [Float] {`. Raven: `g_ICARUScb.c:4933-4935`, `vec4_t textcolor_caption;`, `vec4_t textcolor_center;`, `vec4_t textcolor_scroll;`. `g_ICARUScb.c:4942-4945`, `static void SetTextColor ( vec4_t textcolor,const char *color)` with the one statement `G_DebugPrint( WL_WARNING, "SetTextColor: NOT SUPPORTED IN MP\n");`. `g_ICARUScb.c:4957`, `:4969`, and `:4981`, `SetTextColor(textcolor_caption,color);` and the same for the other two. No other Raven line reads or writes the three globals.

Truth. True for the type mismatch. The skeleton types a scalar `vec3_t` global as `JKAShared.vec3_t` (`tools/oracle-closure/skeleton.py:538-548`), but its test is `is_vec3` (`tools/oracle-closure/views.py:208-210`), which matches only the typedef `vec3_t`. A `vec4_t` global falls to the general array path and becomes `[Float]` of count 4. The three globals are the only file-scope `vec4_t` in the game files, and `q_math.c` holds the other `vec4_t` globals, which `Sources/JKAShared/q_math.swift:13` writes by hand as `public let colorBlack = vec4_t(0, 0, 0, 1)`. The finding's second premise, that the signature differs from guide line 91, is amended. `tools/oracle-closure/table.py:733-736` makes a non-const vector parameter `inout` only for a PARAMS hold or an adopted bg stub, and its comment says "An adopted game stub keeps the drafter's signature, which takes a vector the body never writes by value." `G_Line(_ start: JKAShared.vec3_t, ...)` at `Sources/JKAMP_GameLogic/g_nav.swift:97` for Raven's non-const `void G_Line( vec3_t start, vec3_t end, vec3_t color, float alpha )` at `g_nav.c:11` is the same case. `SetTextColor` never writes `textcolor`, so by value is the table's form, and guide line 91 does not state the exception. No value of the globals reaches any output, because the body only prints a warning.

jka-rust. `jka-rust/crates/mp/game/src/g_ICARUScb.rs:4008`, `static textcolor_caption: vec4_t = [0.0, 0.0, 0.0, 0.0];`, and the same at `:4013` and the next static for the other two. `:4020`, `pub fn SetTextColor(ctx: &mut GameContext, textcolor: vec4_t, color: *const c_char)`, by value, with the doc line at `:4003-4004`, "`textcolor` is only ever read, never written, in this NOT-SUPPORTED stub body. It stays by-value `vec4_t`". The callers pass the static by value, `SetTextColor(ctx, textcolor_caption, color);`.

Types. `lookup.py vec4_t` gives "lookup: no type named vec4_t, and no view over it". `Sources/JKAShared/Views/Vectors.swift:7` gives `public typealias vec4_t = SIMD4<Float>`. `lookup.py sig SetTextColor` gives `private func SetTextColor(_ textcolor: JKAShared.vec4_t, _ color: String)`, with the warning that the signature rows are stale for 36 stubs, none of them `g_ICARUScb.swift`.

Helpers. None. No `[Float]` to `vec4_t` conversion exists in Sources, and a `vec4_t(textcolor_caption)` spelling is not a SIMD4 initializer from an array.

Guide. Line 241 gives "`vec4_t` is `SIMD4<Float>`.", so the `[Float]` global is out of step with the guide, not the stub. Line 91 gives a non-const `vec4_t` parameter as `inout JKAShared.vec4_t` and does not name the table's by-value form for a game stub that never writes the vector. A rulings.py `TYPES` entry (`tools/oracle-closure/rulings.py:159`) can name the type, but the literal writer at `skeleton.py:700-720` has no `vec4_t` branch and writes `= 0`, which does not compile for `SIMD4<Float>`.

Verdict. Premise amended: the `[Float]` global is a skeleton gap against guide line 241, and the by-value parameter is correct under the table rule at `table.py:733-736`. Fix the skeleton, not the stub. In `skeleton.py`, a scalar `vec4_t` global takes `JKAShared.vec4_t` beside the `vec3_t` branch at `:538`, and the literal writer at `:710` gains `elif inner == "JKAShared.vec4_t": literal = "vec4_t()"`. Then `GameVariables.swift` reads `public var textcolor_caption: JKAShared.vec4_t = vec4_t()`, the hand accessors at `g_ICARUScb.swift:19-33` change their type to `JKAShared.vec4_t`, and the three bodies fill as:
```swift
SetTextColor(textcolor_caption, color)
SetTextColor(textcolor_center, color)
SetTextColor(textcolor_scroll, color)
```
Guide line 91 also gains the sentence "A vector parameter that the body never writes stays by value in a game stub, as `table.py` gives it." The close alternate is three `TYPES` rows, `"textcolor_caption": "JKAShared.vec4_t"` and the same for the other two, but these also need the same literal branch.

### W10. Does `rulings.py` add `BG_TempAlloc` to `CHARBUF_ALLOCS`, so the four `saberName` holes of `NPC_ParseParms` fill as a `CharBuf(4096)`?

Source. `notes/2026-10-11/holes2-npc.md:16-19` (the four blocked holes) and finding 2 at `:91`. `notes/2026-10-11/frame-path-round.md:96` raises the same block, and no row of that docket ruled it.

Site. The Port-note lines are unchanged. `Sources/JKAMP_GameLogic/NPC_stats.swift:1625-1627`, `// Raven wrote: WP_SaberParseParms( saberName, &NPC->client->saber[0] )`, and `:1628-1630`, `// Raven wrote: npcSaber1 = G_ModelIndex(va("@%s", saberName))`, in the `saber` arm. `:1647-1649`, `// Raven wrote: WP_SaberParseParms( saberName, &NPC->client->saber[1] )`, and `:1655-1657`, `// Raven wrote: npcSaber2 = G_ModelIndex(va("@%s", saberName))`, in the `saber2` arm. The locals are `:1616` `var saberName: UnsafeMutableRawPointer` with the store `:1622` `saberName = BG_TempAlloc(4096) //G_NewString( value );`, and `:1644` `var saberName: UnsafeMutableRawPointer = BG_TempAlloc(4096)`. Each arm writes `strcpy(saberName, value)` (`:1623`, `:1645`) and `BG_TempFree(4096)` (`:1632`, `:1659`). Raven: `oracle/codemp/game/NPC_stats.c:2345` `char *saberName;`, `:2352` `saberName = (char *)BG_TempAlloc(4096);//G_NewString( value );`, `:2353` `strcpy(saberName, value);`, `:2355` `WP_SaberParseParms( saberName, &NPC->client->saber[0] );`, `:2356` `npcSaber1 = G_ModelIndex(va("@%s", saberName));`, and `:2372-2383` the same for the second saber. The other `char *` callers of `BG_TempAlloc` in `oracle/codemp/game/` are `bg_vehicleLoad.c:1421` `tempReadBuffer = (char *)BG_TempAlloc(MAX_VEH_WEAPON_DATA_SIZE);` and `:1513` `tempReadBuffer = (char *)BG_TempAlloc(MAX_VEHICLE_DATA_SIZE);`, each under `#ifdef _JK2MP`. `ai_util.c:16` `return BG_TempAlloc(size);` is the body of `B_TempAlloc`.

Truth. True. Both `saberName` locals are `char *`, and every store into each is `(char *)BG_TempAlloc(4096)`, so they meet the rule of guide line 709 except that `CHARBUF_ALLOCS` names only `B_TempAlloc`. A raw pointer cannot pass to the `String` parameter of `WP_SaberParseParms` or to a `FormatArg`, and the compiler texts at `:1625` and `:1628` say so. The finding has one more reach. `draft_classification.py:304-314` reads a macro size as its integer literal, so the two `tempReadBuffer` locals of `bg_vehicleLoad` also become `CharBuf(131072)` and `CharBuf(524288)` at the next draft of that stem. `Sources/JKAMP_BG/bg_vehicleLoad.swift:792` and `:867` hold them as `UnsafeMutableRawPointer` today. Their uses have `CharBuf` forms: `trap_FS_Read(_ buffer: inout JKAShared.CharBuf, ...)` at `Sources/JKAMP_BG/Generated/bg_strap.swift:194`, the byte subscript for `tempReadBuffer[len] = 0`, and `strcat(_:_: CharBuf, at:)` at `Sources/JKAShared/CString.swift:286`.

jka-rust. `jka-rust/crates/mp/game/src/NPC_stats.rs:2038` and `:2078` keep `BG_TempAlloc(4096, bg) as *mut c_char` and pass the raw pointer on.

Types. `lookup.py sig BG_TempAlloc` gives `bg_misc.c  public func BG_TempAlloc(_ size: Int32) -> UnsafeMutableRawPointer`. `lookup.py sig BG_TempFree` gives `bg_misc.c  public func BG_TempFree(_ size: Int32)`. `lookup.py sig WP_SaberParseParms` gives `bg_saberLoad.c  public func WP_SaberParseParms(_ SaberName: String, _ saber: JKAMP.SaberInfo) -> Bool`. `lookup.py sig G_ModelIndex` gives `g_utils.c  func G_ModelIndex(_ name: String) -> Int32`. `lookup.py sig NPC_ParseParms` gives `NPC_stats.c  func NPC_ParseParms(_ NPCName: String, _ NPC: Entity) -> Bool`.

Helpers. `tools/oracle-closure/rulings.py:202-204` holds `CHARBUF_ALLOCS = {"B_TempAlloc"}`. `draft_classification.py:361-364` (`charbuf_alloc_names`) gives the local as a `CharBuf` of the size when every store is one call of the set at one constant size, and `draft_calls.py:380-382` passes a `CharBuf` into a `String` parameter as `String(text)`. `BG_TempAlloc` and `BG_TempFree` are at `Sources/JKAMP_BG/bg_misc.swift:1711` and `:1727`. The precedent is `SavePathData`, `Sources/JKAMP_GameLogic/ai_wpnav.swift:2127` `var fileString = CharBuf(524288)` and `:2166` `_ = B_TempAlloc(524288)`.

Guide. Line 709: "A `char *` local whose every store is a call to a `CHARBUF_ALLOCS` allocator of `rulings.py` at one constant size is a `CharBuf` of that size, `var buf = CharBuf(131072)` for Raven's `buf = (char *)B_TempAlloc(131072)`." Line 710: "The call stays on the page with its result dropped, `_ = B_TempAlloc(131072)`, and the free stays too, so the pool keeps Raven's count." The guide already gives the form, and only the set in `rulings.py` is missing.

Verdict. The premise is true. `rulings.py` adds `BG_TempAlloc` to the set, and the comment names the reach into `bg_vehicleLoad`:
```python
# Allocators whose `char *` result a body holds as a CharBuf of the constant size Raven asks for, when every store into the local is that call.
# The allocation call and its free stay on the page, so the pool keeps Raven's count. See row 1 of the walk of 2026-10-01.
# BG_TempAlloc holds the saberName locals of NPC_ParseParms and the tempReadBuffer locals of bg_vehicleLoad.
CHARBUF_ALLOCS = {"B_TempAlloc", "BG_TempAlloc"}
```
The `saber` arm then reads:
```swift
var saberName = CharBuf(4096)

if COM_ParseString(&p, &value) {
    continue
}

_ = BG_TempAlloc(4096) //G_NewString( value );
strcpy(&saberName, value)

WP_SaberParseParms(String(saberName), NPC.client!.saber[0])
npcSaber1 = G_ModelIndex(va("@%s", saberName))

BG_TempFree(4096)
continue
```
The `saber2` arm reads `var saberName = CharBuf(4096)`, then `_ = BG_TempAlloc(4096)`, `strcpy(&saberName, value)`, `WP_SaberParseParms(String(saberName), NPC.client!.saber[1])`, and `npcSaber2 = G_ModelIndex(va("@%s", saberName))` in the `else` arm. The bare `WP_SaberParseParms` call follows `NPC_stats.swift:2312`. The compile agent of the round re-drafts `bg_vehicleLoad` with the rule and checks the two `tempReadBuffer` functions.

### W11. Does `ColorIndex` take an `Int32`, so `ClientCleanName` reads `ColorIndex(*in)` from the `Int32` byte of a `TextCursor`?

Source. `notes/2026-10-11/holes2-entities.md:26`.

Site. The hole is unchanged at `Sources/JKAMP_GameLogic/g_client.swift:1404-1409`, under `:1403` `// don't allow black in a name, period`. `:1404` is the Port-note `// Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'CChar' (aka 'Int8')"`, `:1405` is `portMissing("ClientCleanName", source: "oracle/codemp/game/g_client.c:1335")`, and `:1406-1409` hold the draft as comments, `// if ColorIndex(`in`.byte) == 0 {`, `//     `in`.advance()`, `//     continue`, `// }`. The function is `:1361`, and `:1369` declares `var `in` = TextCursor(CharBuf(`in`))`. The helper is `Sources/JKAShared/q_shared.h.swift:38-41`, `public func ColorIndex(_ c: CChar) -> Int32 {` with the body `(Int32(c) - Int32(UInt8(ascii: "0"))) & 7`. The commented line `:1406` is its only use in `Sources`. Raven: `oracle/codemp/game/q_shared.h:1158` `#define ColorIndex(c)	( ( (c) - '0' ) & 7 )`, and the one game use is `g_client.c:1369` `if( ColorIndex(*in) == 0 ) {` with `in++;` and `continue;`. The cgame uses pass `*(s+1)` at `cg_drawtools.c:261` and the macros `COLOR_RED` and `COLOR_GREEN` at `cg_draw.c:1981`, `:2052`, `:2124`, `:3225`, `:3343`, `:3347`, `:3444`, and `:3648`.

Truth. True. `TextCursor.byte` is `public var byte: Int32` at `Sources/JKAShared/TextCursor.swift:32`, so `ColorIndex(`in`.byte)` does not compile against a `CChar` parameter, and the Port-note quotes that error. The macro has no parameter type. C promotes `c` to `int` in `(c) - '0'`, so the value is an `int` at every use. `COLOR_RED` is `public let COLOR_RED = Int32(UInt8(ascii: "1"))` at `Sources/JKAShared/Generated/q_shared.swift:424`, so the cgame uses are `Int32` too. A `CChar` parameter fits no caller. The `& 7` gives the same result for a byte read signed or unsigned, because 256 is a multiple of 8.

jka-rust. `jka-rust/crates/mp/game/src/g_client.rs:1521-1523` defines a local `fn ColorIndex(c: u8) -> c_int` with `(c as c_int - '0' as c_int) & 0x07`, and `:1552` calls `ColorIndex(in_bytes[i])` over the bytes of the name.

Types. `lookup.py sig ColorIndex` gives `lookup: no function named ColorIndex in the manifests`, because it is a macro of `q_shared.h`. `lookup.py sig ClientCleanName` gives `g_client.c  private func ClientCleanName(_ `in`: String, _ out: inout JKAShared.CharBuf, _ outSize: Int32)`.

Helpers. `ColorIndex` at `Sources/JKAShared/q_shared.h.swift:38-41` is the helper, and only its parameter type is wrong. `Q_IsColorString` in the same file at `:30` already reads its bytes as `Int32`, `let escape: Int32 = buf[i]`.

Guide. Line 299 places the macro, "| `ColorIndex` | `Sources/JKAShared/q_shared.h.swift` |". Line 528: "A C integer narrower than `int`, a `short`, an `unsigned short`, a `signed char`, or an `unsigned char`, is `Int32` as a view's scalar field, a parameter, and a return, because C widens it to `int` at every read." Line 528 names a C type, and the macro has none, but the same reason holds, since C widens `c` to `int` in the macro body. No line is missing.

Verdict. The premise is true. `ColorIndex` takes an `Int32` under the reason of guide line 528, and the edit is in `Sources/JKAShared/q_shared.h.swift:38-41`:
```swift
/// Source: oracle/codemp/game/q_shared.h:1158
public func ColorIndex(_ c: Int32) -> Int32 {
    (c - Int32(UInt8(ascii: "0"))) & 7
}
```
The hole at `g_client.swift:1404-1409` then reads, under the existing comment at `:1403`:
```swift
if ColorIndex(`in`.byte) == 0 {
    `in`.advance()
    continue
}
```

### W12. Does `SiegeItemRemoveOwner` take `carrier: Entity?` with Raven's `if (carrier)` guard restored, so `SiegeItemRespawnOnOriginalSpot` can pass `nil`?

Source. notes/2026-10-11/holes2-entities.md:28 (the hole row of `SiegeItemRespawnOnOriginalSpot`) and finding 2 at notes/2026-10-11/holes2-entities.md:58.

Site. `Sources/JKAMP_GameLogic/g_saga.swift:1242`, `func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity) {`, with the body at `:1247-1248`, `carrier.client!.holdingObjectiveItem = 0 //The carrier is no longer carrying us` and `carrier.r.svFlags &= ~SVF_BROADCAST`, with no guard. The hole is `g_saga.swift:1272-1277`, `private func SiegeItemRespawnOnOriginalSpot(_ ent: Entity, _ carrier: Entity?) {`, with `// Port-note: Raven passes the optional `carrier` to `SiegeItemRemoveOwner`, whose `carrier` parameter takes a value. A never-null ruling is due.`, `// Raven wrote: SiegeItemRemoveOwner(ent, carrier)`, and `portMissing("SiegeItemRespawnOnOriginalSpot", source: "oracle/codemp/game/g_saga.c:1372")`. The callers of `SiegeItemRespawnOnOriginalSpot` are `g_saga.swift:1326`, `SiegeItemRespawnOnOriginalSpot(ent, nil)`, and `:1335`, `SiegeItemRespawnOnOriginalSpot(ent, carrier)`. The other callers of `SiegeItemRemoveOwner` are `g_saga.swift:1346`, `SiegeItemRemoveOwner(ent, carrier!)`, and `Sources/JKAMP_GameLogic/g_trigger.swift:190`, `SiegeItemRemoveOwner(objItem!, activator)`, where `activator` is the `Entity` parameter of `multi_trigger` at `g_trigger.swift:136`. Raven: `g_saga.c:1338-1349`, `void SiegeItemRemoveOwner(gentity_t *ent, gentity_t *carrier)` with `if (carrier)` at `:1344` around the two stores. `g_saga.c:1372-1376`, `static void SiegeItemRespawnOnOriginalSpot(gentity_t *ent, gentity_t *carrier)` with `SiegeItemRemoveOwner(ent, carrier);`. `g_saga.c:1435`, `SiegeItemRespawnOnOriginalSpot(ent, NULL);`, `:1446`, `SiegeItemRespawnOnOriginalSpot(ent, carrier);`, `:1459`, `SiegeItemRemoveOwner(ent, carrier);`, and `g_trigger.c:202`, `SiegeItemRemoveOwner(objItem, activator);`, with the prototype at `g_trigger.c:129`.

Truth. True. NULL reaches `SiegeItemRemoveOwner` one hop on. Concrete input: a siege player carries an objective item and disconnects, so `carrier->inuse` is false at `g_saga.c:1432`. `SiegeItemThink` calls `SiegeItemRespawnOnOriginalSpot(ent, NULL)`, which passes NULL on, and Raven's `if (carrier)` skips the two stores. A Swift caller that writes `carrier!` under guide line 338 traps on that path. The table already sees the hop: `sweep_null_hops` at `tools/oracle-closure/table.py:660-704` adds `("SiegeItemRemoveOwner", "carrier")` to `hopped`, but the view row at `tools/oracle-closure/spelling.py:344-346` makes a view optional only for `facts.nullable`, a direct NULL, and not for `null_reaches`. So the stub keeps `Entity`.

jka-rust. `jka-rust/crates/mp/game/src/g_saga.rs:1629`, `pub fn SiegeItemRemoveOwner(ctx: &mut GameContext, ent: EntityId, carrier: Option<EntityId>) {`, with `if let Some(carrier) = carrier {` at `:1636`. `:1677-1685` gives `SiegeItemRespawnOnOriginalSpot` a `carrier: Option<EntityId>` and passes it on unchanged, `SiegeItemRemoveOwner(ctx, ent, carrier);`.

Types. `lookup.py sig SiegeItemRemoveOwner` gives `func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity)`. `lookup.py sig SiegeItemRespawnOnOriginalSpot` gives `private func SiegeItemRespawnOnOriginalSpot(_ ent: Entity, _ carrier: Entity?)`. The tool warns that the signature rows are stale for 36 stubs, and the `g_saga.swift` lines above agree with the rows.

Helpers. None.

Guide. Line 336 gives "A view parameter is non-optional, so a body drops Raven's null guard on it, with no comment and no marker." Line 338 gives the caller's force unwrap "because the unwrap traps where Raven's callee would dereference NULL". Raven's callee here does not dereference NULL, so line 338 does not apply, and line 336 holds only when no NULL reaches the parameter. The `NULLABLE` table at `tools/oracle-closure/rulings.py:322-335` (R33) is the ruling form for "a NULL the sweep cannot see", and `("G_UseTargets2", "activator")` and `("GlobalUse", "activator")` are the same one-hop case. Line 346 gives the body form, "A view parameter that a caller passes NULL to is optional, and every read through it takes the same force unwrap, `attacker!.client`."

Verdict. Premise true. Add one row to `NULLABLE` in `tools/oracle-closure/rulings.py`, and the stub signature becomes `func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity?)`:
```python
    # SiegeItemThink passes NULL to SiegeItemRespawnOnOriginalSpot at g_saga.c:1435, which passes it on, and the body tests it at g_saga.c:1344.
    ("SiegeItemRemoveOwner", "carrier"),
```
The body restores Raven's guard with the force unwrap of guide line 346, and the hole fills with the plain call:
```swift
func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity?) {
    ent.genericValue2 = 0 //Remove picked-up flag

    ent.genericValue8 = ENTITYNUM_NONE //Mark entity carrying us as none

    if carrier != nil {
        carrier!.client!.holdingObjectiveItem = 0 //The carrier is no longer carrying us
        carrier!.r.svFlags &= ~SVF_BROADCAST
    }
}
```
```swift
    SiegeItemRemoveOwner(ent, carrier)
```
`g_trigger.swift:190` compiles with no change. `g_saga.swift:1346` compiles as it is, and drops its `!` to read `SiegeItemRemoveOwner(ent, carrier)`. The close alternate is a generator change that makes a view optional for `null_reaches`, which would move every hopped view parameter at once and needs its own sweep of the stubs.

### W13. What form does `SP_func_breakable` take for Raven's `char *s = NULL` passed to `G_SpawnString`, where the local is `String?` and the parameter is `inout String`?

Source. notes/2026-10-11/holes2-entities.md:31 (the hole row of `SP_func_breakable`).

Site. The hole moved from the record line 2573. `Sources/JKAMP_GameLogic/g_mover.swift:2571`, `var s: String? = nil`. `:2573-2575`, `// Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".`, `// Raven wrote: G_SpawnString("playfx", "", &s)`, and `portMissing("SP_func_breakable", source: "oracle/codemp/game/g_mover.c:2731")`. `:2577-2582`, `if s != nil && !s!.isEmpty {`, `` `self`.genericValue15 = G_EffectIndex(s!) ``, and `} else {` with `` `self`.genericValue15 = 0 ``. The callee is `Sources/JKAMP_GameLogic/g_spawn.swift:37-56`, `func G_SpawnString(_ key: String, _ defaultString: String?, _ out: inout String) -> Bool {`, which stores `out = level.spawnVars[i][1]!` on a hit at `:48` and `if defaultString != nil { out = defaultString! }` on the miss path at `:54`. Raven: `g_mover.c:2733-2745`, `char *s = NULL;`, `G_SpawnString("playfx", "", &s);`, `if (s && s[0])`, `self->genericValue15 = G_EffectIndex(s);`, and `self->genericValue15 = 0;` in the `else`. `g_spawn.c:6-23`, `G_SpawnString`, stores `*out = level.spawnVars[i][1];` on a hit at `:16` and `*out = (char *)defaultString;` on the miss at `:21`.

Truth. True. `G_SpawnString` stores `*out` on every path, and this call passes the default `""`, so `s` is never NULL after the call. Raven's `s` test reads a NULL that has no path. Concrete input: a `func_breakable` with no `playfx` key. Raven sets `s` to `""`, `s && s[0]` is false, and `genericValue15` is 0. The form `!s.isEmpty` over a `String` gives false and 0 too. With `playfx` set to `effects/explosion`, both give `G_EffectIndex("effects/explosion")`. The drafter made the local optional because the text-local rule at `tools/oracle-closure/draft_declarations.py:362-372` makes "A text local Raven stores his NULL into" a `String?`, and it counts the `= NULL` initializer as a store. The `filled_by_address` test at `:179-186` applies only when the local has no initializer.

jka-rust. `jka-rust/crates/mp/game/src/g_mover.rs:3206`, `let (_, s) = G_SpawnString(ctx, "playfx", "");`, and `:3208`, `if !s.is_empty() {`. The submodule holds a plain text and drops the NULL test.

Types. `lookup.py sig G_SpawnString` gives `func G_SpawnString(_ key: String, _ defaultString: String?, _ out: inout String) -> Bool`.

Helpers. Every other `G_SpawnString(..., "", &s)` caller already has the form, because Raven declares `char *s;` there with no initializer. `Sources/JKAMP_GameLogic/g_turret.swift:601`, `var s: String = ""`, `:611`, `G_SpawnString("icon", "", &s)`, and `:612`, `if !s.isEmpty {`, for Raven's `g_turret.c:676-677`, `G_SpawnString( "icon", "", &s );` and `if (s && s[0])`. `g_saga.swift:1055` and `:1081-1083`, `g_saga.swift:1564` and `:1602-1604`, and `g_target.swift:938-940` take the same form.

Guide. Line 337 gives "The same holds for an `inout` parameter, a text local the text-local rule made non-optional, ...", so Raven's NULL arm drops once the local is a `String`. Line 341 gives `String?` only for "A text local that a body sets from a callee whose return is an optional text". No line covers a `NULL` initializer that an `inout String` call overwrites before any read.

Verdict. Premise true. The local is a `String` with the empty text, and Raven's test drops its NULL arm under guide line 337, as at `g_turret.swift:601-612`:
```swift
func SP_func_breakable(_ `self`: Entity) {
    var t: Int32 = 0
    var s: String = ""

    G_SpawnString("playfx", "", &s)

    if !s.isEmpty {
        //should we play a special death effect?
        `self`.genericValue15 = G_EffectIndex(s)
    } else {
        `self`.genericValue15 = 0
    }
```
Line 341 gains the sentence "A text local whose `NULL` initializer an `inout String` call overwrites before any read is a `String` with `\"\"`, the same as one Raven left unset." The drafter rule at `draft_declarations.py:362-372` takes the same exception, so a later draft writes this form.

### W14. Does the `client` local of `Pickup_Powerup`, a `Client?` set on each loop pass and read as `client!`, take a per-pass bind?

Source. notes/2026-10-11/holes2-bones.md:55 (finding 4). The same ground is V35 at notes/2026-10-11/docket-proofs-V-34-38.md:35, whose Spread paragraph at `:47` lists this store, `g_items.c:2060`, as one of the 14 unproven `gclient_t *` stores.

Site. `Sources/JKAMP_GameLogic/g_items.swift:1945`, `var client: Client?`, at the top of `func Pickup_Powerup(_ ent: Entity, _ other: Entity) -> Int32 {`. The loop is `:1971`, `while i < level.maxclients {`, with the body inside `Trace.scratch { tr in`. The store is `:1977`, `client = level.clientsSlots[i]`, and the compare is `:1978`, `if client == other.client {`. The force unwraps are seven, not eight: `:1981` `if client!.pers.connected == CON_DISCONNECTED {`, `:1984` `if client!.ps.stats[STAT_HEALTH] <= 0 {`, `:1990` `... == client!.sess.sessionTeam {`, `:1995` `delta = ent.s.pos.trBase - client!.ps.origin`, `:2005` `AngleVectors(client!.ps.viewangles, &forward, &scratchRight, &scratchUp)`, `:2011` `trap_Trace(tr, client!.ps.origin, vec3_origin, vec3_origin, ent.s.pos.trBase, ENTITYNUM_NONE, CONTENTS_SOLID)`, and `:2017` `client!.ps.persistant[PERS_PLAYEREVENTS] ^= PLAYEREVENT_DENIEDREWARD`. No read of `client` stands after the loop. Raven: `g_items.c:2027`, `gclient_t	*client;`, `:2054`, `for ( i = 0 ; i < level.maxclients ; i++ ) {`, `:2060`, `client = &level.clients[i];`, `:2061`, `if ( client == other->client ) {`, and the seven reads at `:2064`, `:2067`, `:2073`, `:2078`, `:2085`, `:2091`, and `:2097`.

Truth. Amended. The local has one store per pass, a slot address, and no NULL store or NULL test, so no `client!` can trap. `level.clientsSlots` (`Sources/JKAMP_Game/Generated/Views/Level.swift:72`) is a `Slots<Client>`, and its subscript at `Sources/JKAShared/Views/Slots.swift:30` returns a plain `Element`. The `Client?` type comes only from the drafter. The finding's `guard let client = ... else` form is wrong for this site, because Raven wrote no NULL test, and guide line 343 says "A guard Raven wrote is the only source of a bind, so no guard is invented for him." The count in the record is seven unwraps, not eight. One fact blocks the V35 form here: the store sits inside the `Trace.scratch` closure, and Swift refuses a closure capture of a `var client: Client` that has no initializer.

jka-rust. `jka-rust/crates/mp/game/src/g_items.rs:2715-2732` has no `client` local. Each read indexes the slot again, `ctx.world.clients[i as usize].pers.connected`, and the compare reads `core::ptr::addr_of!(ctx.world.clients[i as usize])` against `other_client`.

Types. `lookup.py level_locals_t clients` gives "`struct gclient_s * clients`  ->  `clients: Client?`  Optional, nil for a NULL pointer." The view accessor `level.clientsSlots` gives `Slots<Client>`.

Helpers. None.

Guide. Line 344 binds a chain read three or more times, `let vehicleInfo = veh.m_pVehicleInfo!`, and does not name a record pointer local. Line 436 makes a record pointer local that the body steps over a table an index local, and this local is not stepped, it is set from `i`. Line 367 puts a loop-body record in a closure "around the whole body", so a local that Raven declares at the top of the function and stores only in the loop body is a local of that closure. No line states the plain local for a slot-address store, and V35 (`docket-proofs-V-34-38.md:48-60`) proposes it as the extension of drafter rule 2 (R7) to `gclient_t` and to `&level.clients[i]`.

Verdict. Premise amended: the unwraps never trap, and the form is not a guard bind. This row is the same ground as V35, with one more case: a local whose every store is a slot address inside one loop-body closure, and whose reads are all in that closure, moves its declaration to its store as a `let`, and the top declaration drops. The loop reads:
```swift
            let client = level.clientsSlots[i]
            if client == other.client {
                return
            }
            if client.pers.connected == CON_DISCONNECTED {
                return
            }
```
The five later reads become `client.sess.sessionTeam`, `client.ps.origin` (two), `client.ps.viewangles`, and `client.ps.persistant[PERS_PLAYEREVENTS]`. The V35 ruling text gains the sentence "A slot-address local that Raven stores only inside a loop body, which the port wraps in a scratch closure, and reads only there, is a `let` at its store inside the closure." If V35 rules against the plain local, this site keeps its seven force unwraps as they are.

### W15. What form does a C `switch` take when Raven puts the `default` label first or in the middle, as `G_InitSessionData` does?

Source. notes/2026-10-11/holes2-main.md:63 (finding 2). notes/2026-10-11/review-phase2b-main-entities.md:66 (finding 3) raises the same point.

Site. `Sources/JKAMP_GameLogic/g_session.swift:224`, `switch g_gametype.integer {`, then `:225` `case GT_DUEL:`, `:233` `case GT_POWERDUEL:`, and `:249` `default:` with the two comment lines `:250` `// Raven's `default` label stands first, over the labels `GT_FFA`, `GT_HOLOCRON`, `GT_JEDIMASTER`, and `GT_SINGLE_PLAYER`.` and `:251` `// Swift puts `default` last, and those four labels share its body.` The review cites `g_session.swift:226` to `243` and `g_session.c:224`, and both lines moved. Raven: `g_session.c:230-236`, `switch ( g_gametype.integer ) {`, `default:`, `case GT_FFA:`, `case GT_HOLOCRON:`, `case GT_JEDIMASTER:`, `case GT_SINGLE_PLAYER:`, with the arm ending in `break;`, then `case GT_DUEL:` and `case GT_POWERDUEL:`. A scan of `oracle/codemp/game/*.c` for a `default:` label with a `case` label after it in the same `switch` (script `/tmp/wproofs/scripts/defaults.py`, comments and strings blanked) gives 20 sites. In 17 of them `default:` stands directly over `case` labels. In 3 of them, `NPC_spawn.c:328`, `bg_panimate.c:773`, and `w_saber.c:2220`, `default:` comes after other labels of the same arm, for example `case BLOCKED_UPPER_RIGHT://LS_PARRY_UR:` then `default://case LS_READY:`. In 13 of the 20, more arms follow the `default` arm, and each `default` arm ends in `break;` or `return`, so no arm falls through into a later label. Examples and their Swift today: `NPC.c:958-960`, `default:` `case BS_DEFAULT://whatever` `NPC_BSDefault();`, is `NPC.swift:865-866`, `default:` `NPC_BSDefault()`, last, with `BS_DEFAULT` dropped and no comment. `g_cmds.c:1633-1634`, `default:` `case SAY_ALL:`, is `g_cmds.swift:1605`, `default:`, last, with no comment. `NPC_spawn.c:327-329`, `case WP_ROCKET_LAUNCHER:` `default:` `break;` in the middle, is `NPC_spawn.swift:210` `case WP_THERMAL, WP_BLASTER:` first and `default:` `break` last. `bg_panimate.c:772-774` is `bg_panimate.swift:405-406`, `default:` `return LS_K1_TR //push up, slightly to right`, last, with `BLOCKED_UPPER_RIGHT` dropped. `w_saber.c:2219-2221` is `w_saber.swift:1916-1917`, the same form. `g_combat.c:1630-1632`, `default:` `case 0:`, is `g_combat.swift:1223-1224`, `default:` last after `case 2:`. `g_session.swift:250-251` is the only site with a comment.

Truth. True as a form finding. Swift refuses a `case` after `default` ("additional 'case' blocks cannot appear after the 'default' block of a 'switch'"), and a `default` arm takes no other label, so the move is forced. The behavior is the same at every one of the 20 sites. C picks an arm by the label value, not by the order, and the scan shows that every `default` arm ends in `break;` or `return`, so no other arm runs into it or out of it. Concrete input: `g_gametype 0` (GT_FFA) runs the `default` arm in both, and `g_gametype 9` (no label) runs it in both.

jka-rust. `jka-rust/crates/mp/game/src/g_session.rs:222-241`, `match ctx.world.cvars.g_gametype.integer {` with `x if x == GT_DUEL as i32 => {`, `x if x == GT_POWERDUEL as i32 => {`, and `_ => {` last. It drops the four labels and has no comment about the move.

Helpers. None.

Guide. Line 616 gives "A `switch` with fallthrough uses Swift's `fallthrough` keyword, case for case, in Raven's order." No line covers a `default` label that is not last, or the `case` labels stacked with it. The six other sites above already follow one unwritten form: `default` last, its shared labels dropped, no comment.

Verdict. Premise true. The guide gains one sentence after line 616, and the two comment lines at `g_session.swift:250-251` drop so the site matches the other sites: "A `default` label that Raven puts first or in the middle is the last arm, the `case` labels that share its arm drop, and the other arms keep Raven's order with no comment, because Swift puts `default` last and gives it no other label, and every such arm of Raven's ends in `break` or `return`." The site then reads:
```swift
            default:
                if g_maxGameClients.integer > 0 && level.numNonSpectatorClients >= g_maxGameClients.integer {
                    sess!.sessionTeam = TEAM_SPECTATOR
                } else {
                    sess!.sessionTeam = TEAM_FREE
                }
```
The close alternate keeps the dropped labels visible as a `case GT_FFA, GT_HOLOCRON, GT_JEDIMASTER, GT_SINGLE_PLAYER: fallthrough` arm just before `default`, but no other site uses it.

### W16. Does the port spell Raven's `VectorMA` macro per component, with one random call per component, where the scale holds a call to `flrand` or `crandom`?

Source. `notes/2026-10-11/review-phase2b-spawn-npc.md:69-76`, finding 1, which names `Jedi_FaceEnemy` and the four Sniper calls. Row R1 of `notes/2026-10-11/frame-path-walk.md:75` and `notes/2026-10-11/docket-proofs-R.md` R1 rule the double-scale form of the same macro.

Site. A scan of every `_VectorMA(`, `_VectorScale(`, `VectorScale(`, and `VectorAdvance(` call in `Sources/JKAMP_GameLogic` and `Sources/JKAMP_BG`, multi-line calls included, finds six calls whose scale holds a call to `flrand`, `crandom`, `random`, `Q_irand`, or `Q_flrand`. All six are `_VectorMA`, and no `_VectorScale` call has one. The line numbers of the record are current. `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:3167`, `_VectorMA(enemy_eyes, eDist * flrand(0.95, 1.25), NPC!.enemy!.client!.ps.velocity, &enemy_eyes)`. Raven `NPC_AI_Jedi.c:3838`, `VectorMA( enemy_eyes, eDist*flrand(0.95f,1.25f), NPC->enemy->client->ps.velocity, enemy_eyes );`. `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:493`, `_VectorMA(target, NPC!.enemy!.r.maxs[2] * flrand(1.5, 4), right, &target)`. Raven `NPC_AI_Sniper.c:544`, `VectorMA( target, NPC->enemy->r.maxs[2]*flrand(1.5, 4), right, target );`. `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:495`, `_VectorMA(target, NPC!.enemy!.r.mins[2] * flrand(1.5, 4), right, &target)`. Raven `NPC_AI_Sniper.c:548`, `VectorMA( target, NPC->enemy->r.mins[2]*flrand(1.5, 4), right, target );`. `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:500`, `_VectorMA(target, NPC!.enemy!.r.maxs[2] * flrand(1.5, 4), up, &target)`. Raven `NPC_AI_Sniper.c:555`, `VectorMA( target, NPC->enemy->r.maxs[2]*flrand(1.5, 4), up, target );`. `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:502`, `_VectorMA(target, NPC!.enemy!.r.mins[2] * flrand(1.5, 4), up, &target)`. Raven `NPC_AI_Sniper.c:559`, `VectorMA( target, NPC->enemy->r.mins[2]*flrand(1.5, 4), up, target );`. `Sources/JKAMP_GameLogic/NPC_AI_Seeker.swift:206`, `_VectorMA(end, crandom() * 25, dir, &end)`. Raven `NPC_AI_Seeker.c:207`, `VectorMA( end, crandom() * 25, dir, end );`. The record does not name this site. A scan of Raven's `oracle/codemp/game/*.c` with the same pattern finds the same six calls and no other.

Truth. True, and amended with a sixth site. The build takes the `#if 1` branch at `q_shared.h:1351`, so `VectorMA` is the macro at `q_shared.h:1365`, `((o)[0]=(v)[0]+(b)[0]*(s),(o)[1]=(v)[1]+(b)[1]*(s),(o)[2]=(v)[2]+(b)[2]*(s))`. The comma operator runs the three stores in the order 0, 1, 2, and each store evaluates its own copy of `s`. So each of the five `flrand` calls draws three times in Raven, and each component takes a different scale. The Swift draws once, so the vector differs and every later draw of the shared stream shifts by two. The Seeker site has the same three draws, because `crandom()` is the macro `(2.0 * (random() - 0.5))` at `q_shared.h:1592`, and `random()` at `:1591` calls `rand()`. The Seeker site also has the R1 ground: Raven's `crandom() * 25` is a `double`, and `crandom()` in `Sources/JKAMP_BG/bg_lib.swift:193` returns a `Float`. For `rand() & 0x7fff == 1`, Raven's `crandom()` is `-0.9999389629811049`, and the Swift returns `-0.99993896484375`.

jka-rust. `crates/mp/game/src/NPC_AI_Jedi.rs:4607-4613` writes `for i in 0..3 { enemy_eyes[i] += (*enemy_client).ps.velocity[i] * (eDist * ctx.world.bg_state.rng.flrand(0.95f32, 1.25f32)); }` under a comment that names the `#if 1` macro and the three draws. `crates/mp/game/src/NPC_AI_Sniper.rs:706-735` writes the same loop at each of the four calls, all in `f32`. `crates/mp/game/src/NPC_AI_Seeker.rs:329-335` writes `end[i] = (end[i] as f64 + ctx.world.bg_state.rng.crandom() * 25.0 * dir[i] as f64) as f32;` in a loop, with a `crandom` that returns `f64` (`crates/native/math/src/rng.rs:212`).

Types. `lookup.py sig flrand` gives `public func flrand(_ min: Float, _ max: Float) -> Float`. `lookup.py sig _VectorMA` gives `public func _VectorMA(_ veca: JKAShared.vec3_t, _ scale: Float, _ vecb: JKAShared.vec3_t, _ vecc: inout JKAShared.vec3_t)`. `lookup.py sig crandom` gives "no function named crandom in the manifests", because Raven's `crandom` is a macro. The Swift `crandom()` at `Sources/JKAMP_BG/bg_lib.swift:193` returns `Float`.

Helpers. None. `_VectorMA` at `Sources/JKAShared/q_math.swift:891` takes one `Float` scale, and no helper takes a scale closure or a per-component scale.

Guide. Line 251 of `docs/transcription.md` reads "`VectorMA(a, s, b, c)` | `_VectorMA(a, s, b, &c)`, and where C computes `s` in `double`, one store per component, ...". It gives the double-scale form of R1 and does not name a scale that holds a call. No line of the guide states that a macro argument with a side effect runs once per use in the macro text.

Verdict. The premise is true, with the Seeker site added. Each site spells the macro per component, one store per component in the order 0, 1, 2, with its own call in each store, in Raven's operand order `v + b * (s)`. `Jedi_FaceEnemy` reads:
```swift
enemy_eyes[0] = enemy_eyes[0] + NPC!.enemy!.client!.ps.velocity[0] * (eDist * flrand(0.95, 1.25))
enemy_eyes[1] = enemy_eyes[1] + NPC!.enemy!.client!.ps.velocity[1] * (eDist * flrand(0.95, 1.25))
enemy_eyes[2] = enemy_eyes[2] + NPC!.enemy!.client!.ps.velocity[2] * (eDist * flrand(0.95, 1.25))
```
Each Sniper call reads the same way, for example `target[0] = target[0] + right[0] * (NPC!.enemy!.r.maxs[2] * flrand(1.5, 4))` and the same for 1 and 2. The Seeker call writes the `crandom` macro text in double, as R1 does for a double scale, `end[0] = Float(Double(end[0]) + Double(dir[0]) * (2.0 * (Double(random()) - 0.5) * 25))` and the same for 1 and 2. A `crandom()` that returns `Double`, as C's macro does, gives the same Seeker bits in a shorter line, but it changes every other `crandom` caller. The guide row 251 gains this sentence: "Where the scale holds a call, `flrand`, `crandom`, `random`, `Q_irand`, or `Q_flrand`, the macro puts the call into each component, so the body writes one store per component with its own call, in the order 0, 1, 2, `enemy_eyes[0] = enemy_eyes[0] + NPC!.enemy!.client!.ps.velocity[0] * (eDist * flrand(0.95, 1.25))`."

### W17. Does Swift's `atof` return `Double` as C's does, so that `val += atof(...)` in `Q3_SetParm` adds in double as Raven does?

Source. `notes/2026-10-11/review-phase2b-spawn-npc.md:77-82`, finding 2. The same point is finding 4 of `notes/2026-10-11/holes2-npc.md:93`, the conflict 6 row of `notes/2026-10-11/frame-path-walk.md:190`, row U3 of `notes/2026-10-11/frame-path-round.md:229` ("Unruled"), and the side finding of `notes/2026-10-11/docket-proofs-conflict-6.md:59`.

Site. `Sources/JKAShared/CString.swift:72`, `private func atofCore<C: RandomAccessCollection>(_ bytes: C) -> Float`, which ends `return Float(Double(text) ?? 0)` at `:116`. `Sources/JKAShared/CString.swift:120`, `public func atof(_ s: CharBuf) -> Float`, and `:125`, `public func atof(_ s: String) -> Float`. `Sources/JKAMP_GameLogic/g_ICARUScb.swift:3194`, `val += atof(ent!.parms!.parm[parmNum])`, the line of the record. Raven `g_ICARUScb.c:3676`, `val += atof( ent->parms->parm[parmNum] );`, with `float val` and `Com_sprintf( ent->parms->parm[parmNum], sizeof(ent->parms->parm), "%f", val );` at `:3677`. Sources holds 56 `atof(` calls: 8 in `Sources/JKAMP_BG`, 46 in `Sources/JKAMP_GameLogic`, and 2 in `Sources/JKAShared/q_shared.c.swift`. The text at `g_ICARUScb.swift:4006` is inside a block comment and does not count. Four calls use the `double` beyond a store: `g_ICARUScb.swift:3194` (Raven `g_ICARUScb.c:3676`, the add), `g_misc.swift:585`, `Info_SetValueForKey(&temp, "texturescale", va("%f", atof(value)))` (Raven `g_misc.c:579`, the same text, a `double` vararg), `bg_vehicleLoad.swift:104`, `b[int: vehWeaponFields[i].ofs] = (Bool((atof(value) != 0)) ? 1 : 0)` (Raven `bg_vehicleLoad.c:216`, `(qboolean)(atof(value)!=0)`), and `bg_vehicleLoad.swift:462` (Raven `bg_vehicleLoad.c:890`, the same test). The other 52 calls are a plain store into a `float`, for example `ai_util.swift:500`, `bs.skills.accuracy = atof(readbuf)` (Raven `ai_util.c:674`), and the twenty `float_data = atof(data)` lines of `g_ICARUScb.swift:4645-5230` (Raven `g_ICARUScb.c:5062-5779`). `g_ICARUScb.swift:2945`, `val = atof(numString.text) * -1` (Raven `g_ICARUScb.c:3424`), is a store too, because the negation is exact in both types.

Truth. True for the four sites, and false for the 52 plain stores. Raven's DLL links the C library `atof`, which returns `double`. `JK2_game.vcproj:405-411` excludes `bg_lib.c` from the Release build, so its `atof` is the VM one only. For `Q3_SetParm`, take an increment of 100 and an old row of `"4020.521729"`. Raven adds the `double` 4020.521729 to 100 and narrows once to `4120.52197265625`, and `%f` writes `"4120.521973"`. The Swift narrows the parse to `4020.5217285` first, the `float` sum is a tie, and ties-to-even stores `4120.521484375`, so the row reads `"4120.521484"`. For `g_misc.swift:585`, the value `"16777217"` prints `"16777217.000000"` in Raven and `"16777216.000000"` in the Swift. For the two `!= 0` tests, the value `"1e-50"` is true in Raven and false in the Swift, because `Float(1e-50)` is 0. For a plain store, C parses to `double` and narrows once at the store, and `atofCore` does the same two steps, `Float(Double(text) ?? 0)`, so the bits are the same. Double rounding is real, but it is Raven's own: for the text `"1.00000005960464477539062500000000001"`, the `double` parse gives `1 + 2^-24`, a `float` tie, and the store gives `1.0`, where a direct correctly rounded `float` parse gives `1.0000001`. The Swift gives `1.0`, as Raven does. This holds against a correctly rounded `double` parse. Swift's `Double(String)` is correctly rounded, and this proof does not prove that the MSVC library `atof` of Raven's build is.

jka-rust. `crates/native/string/src/atof.rs:15` and `:20` give `pub fn atof(text: &str) -> f64` and `pub fn atof_bytes(bytes: &[u8]) -> f64`. `crates/mp/game/src/g_ICARUScb.rs:3013-3018` writes `let total = (val as f64 + atof_bytes(...)) as f32;` under a comment that names the `double` add.

Types. `lookup.py parms_t parm` gives `char[16][64] parm` -> `parm: Slots<String>`. `lookup.py sig Q3_GameSideCheckStringCounterIncrement` gives `private func Q3_GameSideCheckStringCounterIncrement(_ string: String) -> Float`. `lookup.py sig Q3_SetParm` gives `func Q3_SetParm(_ entID: Int32, _ parmNum: Int32, _ parmValue: String)`.

Helpers. `atofCore` at `Sources/JKAShared/CString.swift:72` already computes the `Double` and narrows it in its last line. `Sources/JKAMP_BG/bg_lib.swift:199`, `func atof(_ string: String) -> Double`, is the port of the VM `atof` of `bg_lib.c:774`, which computes in `float`. It is internal to JKAMP_BG, and today no call binds to it, because every JKAMP_BG caller passes a `CharBuf` or stores into a `Float`. A public JKAShared `atof(_ s: String) -> Double` has the same signature, so JKAMP_BG would need that VM port renamed or removed.

Guide. Line 656 of `docs/transcription.md` reads "`Sources/JKAShared/CString.swift` holds the libc names Raven calls, `atoi`, `atof`, `strcpy`, ... with C semantics." No line gives the return type of `atof`. Line 548 gives the double rule, and line 551 makes it "the one place a body writes a conversion Raven did not write".

Verdict. The premise is true at four sites and false at 52 plain stores, which give Raven's bits today. `atofCore` and both `atof` overloads return `Double`, C's prototype, and each site writes what C computes under the double rule. A plain store narrows once, `bs.skills.accuracy = Float(atof(readbuf))`. The four sites read:
```swift
val = Float(Double(val) + atof(ent!.parms!.parm[parmNum]))
Info_SetValueForKey(&temp, "texturescale", va("%f", atof(value)))
b[int: vehWeaponFields[i].ofs] = (Bool((atof(value) != 0)) ? 1 : 0)
b[int: vehicleFields[i].ofs] = (Bool((atof(value) != 0)) ? 1 : 0)
```
The VM port at `bg_lib.swift:199` takes Raven's name with a VM mark, or drops, so that the two signatures do not meet. Guide line 656 gains: "`atof` returns `Double` as C's does, so a store into a `float` reads `x = Float(atof(s))`, and an add, a test, or a `%f` argument uses the `Double`, `val = Float(Double(val) + atof(ent!.parms!.parm[parmNum]))`." A close alternate keeps the `Float` overloads for the 52 stores and adds `Double` overloads, but then `va("%f", atof(value))` and `atof(value) != 0` have two candidates of equal rank and need an explicit type at the site.

### W18. Does the example of the double rule at guide line 548, `drop += Float(Double(speed) * 0.1 * ...)`, change, because it narrows the product before the float add where C adds in double and narrows once?

Source. `notes/2026-10-11/holes2-npc.md:92`, finding 3.

Site. `docs/transcription.md:548` reads "So a body writes `Double(...)` on each operand at the operator where it meets the double operand, and `Float(...)` once at the store, `drop += Float(Double(speed) * 0.1 * Double(bg.pml.frametime))`, and `(150 + pml.frametime) * 0.003` is `Double(150 + pml.frametime) * 0.003`, because C adds in float." `Sources/JKAMP_BG/bg_pmove.swift:988`, `drop += Float(Double(speed) * 0.1 * Double(pml.frametime))`. Raven `bg_pmove.c:1105`, `drop += speed*0.1*pml.frametime;`, with `float drop;` at `bg_pmove.c:1002`. A grep of Sources for a compound assignment whose right side starts with `Float(` finds one more site of the example form, `Sources/JKAMP_BG/bg_misc.swift:1084`, `result[2] -= Float(0.5 * Double(DEFAULT_GRAVITY) * Double(deltaTime) * Double(deltaTime))`. Raven `bg_misc.c:2400`, `result[2] -= 0.5 * DEFAULT_GRAVITY * deltaTime * deltaTime;`, with `float deltaTime;` at `bg_misc.c:2354`. The other hits, `bg_pmove.swift:3324` and `:3717-3719`, convert an integer and hold no double. A grep for `+ Float(Double(` and `- Float(Double(` finds no site. The sites that already take the rule text are `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:3993-4000`, for example `dest[0] = Float(Double(dest[0]) + Double(NPC!.enemy!.r.maxs[0]) * 1.25)`, and `Sources/JKAMP_GameLogic/g_combat.swift:4628-4629`, `dest[0] = Float(Double(dest[0]) + 15.0)`.

Truth. True. C converts `drop` to `double` for `+=`, because the right side is `double`, adds in `double`, and narrows once at the store. The example narrows the product to `float` and then adds in `float`, which rounds twice. With `drop = 1.0026445`, `speed = 492.63837`, and `frametime = 0.016`, Raven stores `1.7908660173416138`, and the example form stores `1.7908658981323242`. A random test of 100000 inputs gives a different result in 2555 cases. The `PM_FLOAT` arm runs after the water arm at `bg_pmove.c:1092-1093`, so a floating player in water reaches the add with `drop` not 0. With `drop` 0 the two forms agree. For `bg_misc.swift:1084`, `result[2] = 1180.7743` and `atTime - trTime = 2671` give `-1672.922119140625` in Raven and `-1672.9219970703125` in the Swift. `BG_EvaluateTrajectory` runs for every `TR_GRAVITY` missile and item, so this site is on the frame path.

jka-rust. `crates/mp/bg/src/bg_pmove.rs:906`, `drop = (drop as f64 + speed as f64 * 0.1 * self.pml.frametime as f64) as f32;`, under a comment that names the `double` literal. `crates/mp/bg/src/bg_misc.rs:1144-1147`, `result[2] = (result[2] as f64 - 0.5 * 800.0 * deltaTime as f64 * deltaTime as f64) as f32;`.

Helpers. None. `Sources/JKAShared/Promotion.swift` gives the `Int32` and `Float` operators and no `Float` and `Double` compound assignment.

Guide. Line 548 states the rule correctly and gives an example that breaks it. The rule says `Float(...)` once at the store, and for a compound assignment the store holds the left operand too.

Verdict. The premise is true. The example changes, and two sites take the same form. Line 548 reads: "So a body writes `Double(...)` on each operand at the operator where it meets the double operand, and `Float(...)` once at the store, so a compound assignment is a plain store with the left side widened, `drop = Float(Double(drop) + Double(speed) * 0.1 * Double(pml.frametime))`, and `(150 + pml.frametime) * 0.003` is `Double(150 + pml.frametime) * 0.003`, because C adds in float." The sites read:
```swift
drop = Float(Double(drop) + Double(speed) * 0.1 * Double(pml.frametime))
result[2] = Float(Double(result[2]) - 0.5 * Double(DEFAULT_GRAVITY) * Double(deltaTime) * Double(deltaTime))		// FIXME: local gravity...
```
The comment line above `bg_misc.swift:1084`, "Raven's `0.5` is a double, so the whole term runs in double and rounds once into the float.", changes to "Raven's `0.5` is a double, so the subtraction runs in double and rounds once into the float."

### W19. Do the engine bytes of `trap_BotGetServerCommand` in `BotAI` and of the arguments in `ConcatArgs` reach the buffer unchanged, when a byte is not valid UTF-8?

Source. `notes/2026-10-11/review-phase2b-bot.md:42`, finding 1, for `BotAI`. `notes/2026-10-11/review-phase2b-main-entities.md:65`, finding 2, for `ConcatArgs`.

Site. `Sources/JKAMP_Game/Generated/g_syscalls.swift:1030-1035`, `public func trap_BotGetServerCommand(_ clientNum: Int32, _ size: Int32) -> (Int32, String)`, which returns `String(nulTerminated: message)`. `Sources/JKAMP_GameLogic/ai_main.swift:809-810`, `let (count, text) = trap_BotGetServerCommand(client, Int32(buf.count))` and `strcpy(&buf, text)`. Raven `ai_main.c:698`, `char buf[1024], *args;`, and `:717`, `while( trap_BotGetServerCommand(client, buf, sizeof(buf)) ) {`. `Sources/JKAMP_Game/Generated/g_syscalls.swift:111-117`, `public func trap_Argv(_ n: Int32, _ bufferLength: Int32) -> String`, which returns `String(nulTerminated: buffer)`. `Sources/JKAMP_GameLogic/g_cmds.swift:163`, `strcpy(&arg, trap_Argv(i, Int32((arg).count)))`, `:168`, `strncpy(&line, String(arg), tlen, at: len)`, and `:178`, `return String(line)`. Raven `g_cmds.c:136`, `trap_Argv( i, arg, sizeof( arg ) );`, `:141`, `memcpy( line + len, arg, tlen );`, and `:151`, `return line;`. `Sources/JKAShared/Views/String+NulTerminated.swift:7` and `Sources/JKAShared/CharBuf.swift:113` both decode with `String(decoding: ..., as: UTF8.self)`.

Truth. True for `BotAI`, and amended for `ConcatArgs`. The JKA engine sends bytes above 127 to the game: `oracle/codemp/qcommon/msg.cpp:472-478` comments out the `c > 127` filter under "eurofix: remove this so we can chat in european languages". `String(decoding:as: UTF8.self)` replaces a byte that is not valid UTF-8 with U+FFFD, the three bytes `EF BF BD`. In `BotAI`, a server command that holds the Latin-1 byte `E9` for "é" reaches Raven's `buf` as `E9` and the Swift `buf` as `EF BF BD`. A 1000-byte command with twelve `E9` bytes grows to 1024 bytes, and `strcpy(&buf, text)` traps at its precondition at `Sources/JKAShared/CString.swift:172`, because `buf` holds 1024 bytes with the NUL. In `ConcatArgs`, the loss is at `trap_Argv`, not at `String(arg)`. For the argument bytes `E9 61 62 63`, `trap_Argv` returns `"\u{FFFD}abc"`, `strcpy` writes `EF BF BD 61 62 63` into `arg`, and `tlen` is 6. `String(arg)` then reads valid UTF-8 and writes the same six bytes, so no byte is lost after the decode, and the record's example, where `bc` is lost, does not happen. Raven's `line` holds `E9 61 62 63`, and the Swift `line` holds `EF BF BD 61 62 63`. An argument of 342 bytes of `E9` grows to 1026 bytes, and `strcpy(&arg, ...)` traps. `return String(line)` and every outgoing `withCString` then send the repaired bytes, so a chat line with "é" reaches the other clients as `EF BF BD`.

jka-rust. `crates/mp/game/src/trap.rs:266-277`, `Argv`, decodes "Latin-1 wire bytes" one byte to one char through `latin1_to_string`. `crates/mp/game/src/trap.rs:358-365`, `BotGetServerCommand`, returns `buf_to_string(&buffer)`, which is `latin1_to_string` at `crates/native/string/src/cstr.rs:11-14`. `crates/mp/game/src/g_cmds.rs:207-230` builds the `String` with `push_str` and counts `tlen` in Latin-1 chars. So jka-rust keeps every byte and does not trap.

Types. `lookup.py sig ConcatArgs` gives `func ConcatArgs(_ start: Int32) -> String`. `lookup.py sig trap_BotGetServerCommand` and `lookup.py sig trap_Argv` give "no function named ... in the manifests", because the traps are generated outside the manifests.

Helpers. `CharBuf(bytes:)` at `Sources/JKAShared/CharBuf.swift:29` keeps every byte of an engine buffer. `strcpy(_ dest: inout CharBuf, _ source: CharBuf)` exists at `Sources/JKAShared/CString.swift:156`. `strncpy(_ dest: inout CharBuf, _ source: CharBuf, _ n:)` exists at `:300`, with no `at:` form. The byte boundary has 3 decodes with `String(decoding:as: UTF8.self)` (`CharBuf.swift:113`, `String+NulTerminated.swift:7`, `Scan.swift:242`), 66 `String(cString:)` reads, 17 `.utf8` encodes (10 in `CString.swift`, 3 in `Scan.swift`, 2 in `Views/CStrings.swift:10-11`, and one each at `CharBuf.swift:17` and `Views/StringPool.swift:25`), and 102 `withCString` calls.

Guide. Line 150 of `docs/transcription.md` reads "A body that hands that trap a `char buf[N]` copies the returned text into the buffer, `strcpy(&arg, trap_Argv(1, Int32(arg.count)))`, so the buffer keeps its N bytes." Line 661 gives the B2 form, `strncpy(&line, String(arg), tlen, at: len)`. The B2 row at `notes/2026-10-11/frame-path-walk.md:14` says "The form writes exactly Raven's bytes", and the O5 row at `:63` gives the `BotAI` form. No line of the guide names the text codec at the engine boundary.

Verdict. The premise is true for `BotAI` and amended for `ConcatArgs`, where the bytes change at `trap_Argv` before `String(arg)`. The engine boundary reads and writes a `String` as Latin-1, one byte to one scalar from U+0000 to U+00FF, as jka-rust does. Then the B2 and O5 sites stay as ruled, a `String` stays at a `char *` field as the legibility goal asks, and every byte round-trips. The decode reads:
```swift
extension String {
    /// This builds a string from an engine buffer up to the first NUL, one scalar per byte, so every byte comes back unchanged.
    public init(nulTerminated buffer: [CChar]) {
        let end = buffer.firstIndex(of: 0) ?? buffer.endIndex
        var scalars = String.UnicodeScalarView()
        for byte in buffer[..<end] {
            scalars.append(Unicode.Scalar(UInt8(bitPattern: byte)))
        }
        self = String(scalars)
    }
}
```
`String(CharBuf)` and `Scan.swift:242` decode the same way. Each encode writes `string.unicodeScalars.map { UInt8(truncatingIfNeeded: $0.value) }` where it writes `Array(string.utf8)` today, and a length reads `unicodeScalars.count`, not `utf8.count` and not `count`, because `"\r\n"` is one `Character`. The generator writes the `withCString` and `String(cString:)` calls through the same pair. The alternate gives `trap_BotGetServerCommand` a `(Int32, CharBuf)` return through `CharBuf(bytes:)` and adds `trap_Argv(i, &arg, Int32(arg.count))` and a `CharBuf`-source `strncpy` with `at:`, but `ConcatArgs` still returns `String(line)`, so the bytes change at the return and on the wire.

### W20. After `let message = CharBuf(ent.message!)`, does each `%s` of `Use_Target_Print` read `message`, `ent.message!`, or stay `ent.message ?? "(null)"`?

Source. `notes/2026-10-11/review-phase2b-main-entities.md:67`, finding 4. `notes/2026-10-11/holes2-entities.md:15-18` fills the four holes with `ent.message ?? "(null)"` at each `%s`, and the Q1 row of `notes/2026-10-11/frame-path-walk.md:66` gives only the `CharBuf` binding and the byte test.

Site. `Sources/JKAMP_GameLogic/g_target.swift`, eight reads in four arms, the lines match the record. Line 210 binds `let message = CharBuf(ent.message!)`, and lines 212 and 214 read `va("cps \"%s\"", ent.message ?? "(null)")` and `va("cp \"%s\"", ent.message ?? "(null)")`. Lines 223, 225, 227 (TEAM_RED), lines 231, 233, 235 (TEAM_BLUE), and lines 241, 243, 245 (all clients) have the same shape. Raven: `g_target.c:192-235`, for example `:194` `trap_SendServerCommand( activator-g_entities, va("cps \"%s\"", ent->message ));` and `:229` `if (ent->message[0] == '@' && ent->message[1] != '@')`. Raven reads `ent->message` for the byte test first, so a NULL `message` crashes there.

Truth. True. On each arm the bind `CharBuf(ent.message!)` runs before the `%s`. A nil `message` traps at the bind, so the `?? "(null)"` after it has no input that reaches it. Concrete input: any `target_print` with no `message` key. Raven dereferences NULL at `ent->message[0]`, and the Swift traps one statement earlier, the divergence of rule 19 that guide line 334 allows for a NULL pointer.

jka-rust. `jka-rust/crates/mp/game/src/g_target.rs:291` clones `message` once, and `:301`, `:318` unwrap it once per arm, `message.as_deref().unwrap()`. Every `format!` after that reads the unwrapped `msg`. jka-rust has no fallback after the unwrap.

Types. `python3 tools/oracle-closure/lookup.py gentity_t message` gives `char * message  ->  message: String?  Optional, nil for a NULL pointer.` `Sources/JKAShared/CharBuf.swift:16` builds a `CharBuf` from a `String` as its UTF-8 bytes plus a NUL. `Sources/JKAShared/Format.swift:47-49` gives `CharBuf` a `FormatArg` conformance, `.text(String(self))`, and `String(CharBuf)` reads up to the first NUL.

Helpers. `CharBuf: FormatArg` at `Sources/JKAShared/Format.swift:47` already gives the form. A `CharBuf` passes to `va` as a `%s` argument with no conversion, and it prints the same text as `ent.message`.

Guide. Line 339 covers a `String?` at a `%s` and says `?? "(null)"` takes the place of the force unwrap. After the Q1 bind the argument is not a `String?`, so line 339 has nothing to say. Line 624 gives the Q1 bind, `let message = CharBuf(ent.message!)`, and the byte read `message[0] == Int32(ascii: "@")`, and it says nothing about the `%s`.

Verdict. Premise true. Propose the bound name at every `%s`, because the `CharBuf` is the checked value, it needs no second unwrap, and it prints the bytes Raven prints. One alternate: `ent.message!`, which unwraps twice.
```swift
trap_SendServerCommand(activator.s.number, va("cps \"%s\"", message))
```
The eight reads change the same way. Add to guide line 624 after the Q1 clause: "and a `%s` on that arm reads the bound name, `va("cps \"%s\"", message)`." The Q1 row in `frame-path-walk.md:66` stays as ruled.

### W21. Does `Cmd_GameCommand_f` take a rule 19 note line at Raven's off-by-one bound `order > gc_orders.count`?

Source. `notes/2026-10-11/review-phase2b-main-entities.md:64`, finding 1. `notes/2026-10-11/holes2-entities.md:59`, finding 3, says the same. Both records list the site as `g_cmds.swift:1764` with no note.

Site. `Sources/JKAMP_GameLogic/g_cmds.swift:1764-1767` now reads `// Raven tests `order > gc_orders.count`, so an `order` of 7 reads one past the seven rows and the subscript traps there. Rule 19.` and then `if order < 0 || order > gc_orders.count {`. The note exists in HEAD 1db7d1b and in the working tree. Raven: `g_cmds.c:1835` `if ( order < 0 || order > sizeof(gc_orders)/sizeof(char *) ) {`, with the table at `g_cmds.c:1812-1820` of seven rows.

Truth. False. The premise "has no rule 19 note line" is stale, because the line was added before the wave B commit. The off-by-one itself is true: `order == 7` passes the test, and `gc_orders[7]` traps in Swift where C reads one pointer past the table (`gc 0 7` from a client). The record `docket-proofs-conflict-5.md:17-18` proves this.

jka-rust. `jka-rust/crates/mp/game/src/g_cmds.rs:2008-2011` changes the test to `order as usize >= gc_orders.len()` and states the off-by-one in a comment. The B4 ruling keeps Raven's `>`, so jka-rust is not the model.

Types. `gc_orders` is `[String]` at `Sources/JKAMP_GameLogic/g_cmds.swift:31`, forwarded from `world.gc_orders`. The test compares `Int32` with `Int`, the mixed-integer comparison B4 allows.

Helpers. None.

Guide. `docs/porting-rules.md:44`, rule 19: "Pick the one defined behavior, note it in at most two lines at the site ... A Swift trap on an out-of-range index is a divergence of this kind when Raven read past the end, and the note says what Raven read." The precedent `Sources/JKAShared/q_shared.c.swift:127` is one line: `// Raven reads the byte before the buffer for an empty path, and the Swift subscript traps there.` The B4 row (`frame-path-walk.md:16`) rules a one-line note in that form.

Verdict. Premise false, record-only. The site already has the note, one line, 144 columns, and it says what Raven read. Change the row text of `review-phase2b-main-entities.md:64` and `holes2-entities.md:59` to "resolved before the wave B commit". If the user wants the exact precedent form, the line can read, without the trailing "Rule 19.":
```swift
// Raven reads one past the seven rows for an order of 7, and the Swift subscript traps there.
```
No site edit is needed.

### W22. What does the `String` setter store for a `%s` token of 64 bytes or more in `G_ReadSessionData`, and does the store take a rule 19 note?

Source. `notes/2026-10-11/holes2-main.md:65`, finding 4.

Site. `Sources/JKAMP_GameLogic/g_session.swift:139-141` reads `client.sess.siegeClass = texts[0]`, `client.sess.saberType = texts[1]`, and `client.sess.saber2Type = texts[2]`, with no note. The scan is `sscanf(s, "%i %i %i %i %i %i %i %i %i %i %i %i %s %s %s", &ints, &texts)` at line 117. Raven: `g_session.c:118-134` passes `&client->sess.siegeClass`, `&client->sess.saberType`, and `&client->sess.saber2Type` to `%s`, three `char[64]` fields (`g_local.h:423-425`), with no width.

Truth. True. A cvar `session<N>` text such as `... 1 1 1 1 1 1 1 1 1 1 1 1 <100 letters> a b` makes Raven write 101 bytes into the 64-byte `siegeClass` field and over `saberType` and the fields after it, which is undefined. Normal play does not reach this, because `G_WriteClientSessionData` (`g_session.c:23-90`) writes the three tokens from the same 64-byte fields, so each token is at most 63 bytes. A hand-set cvar does reach it. In Swift, `Sources/JKAShared/Scan.swift:235-242` reads the whole token into a `String`, and the setter then stores it. The setter, `store(_:at:capacity:)` at `Sources/JKAShared/Views/CStrings.swift:8-13`, copies `min(utf8.count, capacity - 1)` bytes and then a NUL. So a token of 64 bytes or more stores its first 63 bytes and the NUL. The generated setter is `Sources/JKAMP_Game/Generated/Views/ClientSession.swift:131-134`, `store(newValue, at: ..., capacity: 64)`. The neighbor fields stay as they were.

jka-rust. `jka-rust/crates/mp/game/src/g_session.rs:156-165` stores `strncpyz_string(parts[idx].as_bytes(), 64)` for each of the three fields, the same 63 bytes plus NUL.

Types. `python3 tools/oracle-closure/lookup.py clientSession_t` gives `char[64] siegeClass  ->  siegeClass: String, siegeClassBuffer: JKAShared.CharBuf  Array of 64.` The same two lines exist for `saberType` and `saber2Type`.

Helpers. The `String` setter above is the helper, and it truncates as `Q_strncpyz` does (the doc line at `CStrings.swift:7`).

Guide. No line of `docs/transcription.md` names a long `%s` token. `docs/porting-rules.md:44`, rule 19, asks for a note of at most two lines at the site when the port picks one behavior for a buffer overrun.

Verdict. Premise true. The setter stores 63 bytes and a NUL, and the store takes a two-line rule 19 note, placed once above line 139 for all three stores.
```swift
// Raven reads a token of 64 bytes or more into a `char[64]` field and overruns it.
// The setter stores the first 63 bytes and the NUL, as `Q_strncpyz` does.
client.sess.siegeClass = texts[0]
```
Alternate: a note on `Scan.swift` at the `%s` arm instead, which would cover every caller, but this is the only `%s` caller, so the session site is the one to mark.

### W23. In `Sniper_FaceEnemy`, where Raven clamps `missFactor` to 24 and reads `enemyLaggedPos[24]`, one past the array, does the Swift site take a rule 19 note or a guard?

Source. `notes/2026-10-11/review-phase2b-spawn-npc.md:92`, the first bullet of Notes.

Site. `Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift:519-526`, `var missFactor: Int32 = 8 - (NPCInfo!.stats.aim + g_spskill.integer) * 3`, `if missFactor > ENEMY_POS_LAG_STEPS {`, `missFactor = ENEMY_POS_LAG_STEPS`, `} else if missFactor < 0 {`, `missFactor = 0`, and `target = NPCInfo!.enemyLaggedPos[missFactor]` at `:526`, the line of the record. No comment line names the edge. Raven `NPC_AI_Sniper.c:579-588`, `int missFactor = 8-(NPCInfo->stats.aim+g_spskill.integer) * 3;`, `if ( missFactor > ENEMY_POS_LAG_STEPS )`, `missFactor = ENEMY_POS_LAG_STEPS;`, `else if ( missFactor < 0 )`, `missFactor = 0 ;`, and `VectorCopy( NPCInfo->enemyLaggedPos[missFactor], target );`. `b_public.h:113-115` gives `ENEMY_POS_LAG_STEPS` as `2400/100`, 24, and `:257` declares `vec3_t enemyLaggedPos[ENEMY_POS_LAG_STEPS];`.

Truth. True. The clamp branch stores 24 when `missFactor` is above 24, and `8 - 3 * (aim + skill)` is above 24 when `aim + skill` is -6 or less. `stats.aim` is 3 by default (`NPC_stats.c:1025`), 1 to 5 from an NPC file (`NPC_stats.c:1560-1566`), and 1, 2 to 3, or 3 to 4 at spawn (`NPC_spawn.c:940-946`). `g_spskill` is the cvar `g_npcspskill`, default `"0"` and `CVAR_ARCHIVE` (`g_main.c:459`, `NPC.c:2007`), and no game line clamps it. So `g_npcspskill -7` with an NPC of aim 1 gives `missFactor` 26, then 24, and Raven reads `enemyLaggedPos[24]`. The struct places `gentity_t *watchTarget` right after the array, then `int ffireCount` and `int ffireDebounce` (`b_public.h:259-263`). In Raven's 32-bit x86 build, the read takes the pointer bits of `watchTarget`, `ffireCount`, and `ffireDebounce` as three floats, so the sniper aims at a point with no meaning. The Swift `Slots` subscript at `Sources/JKAShared/Views/Slots.swift:32` traps with "Slots index 24 is out of the range 0..<24". The read is past the array, so rule 19 covers it.

jka-rust. `crates/mp/game/src/NPC_AI_Sniper.rs:760-775` clamps the same way, then reads only when `missFactor < ENEMY_POS_LAG_STEPS`, under a `§19` comment, and leaves `target` unchanged at 24. Its comment says "The guard is unreachable in practice, because missFactor = 8-(aim+skill)*3 is always at most 8", which is false for a negative `g_npcspskill`.

Types. `lookup.py gNPC_t enemyLaggedPos` gives `vec3_t[24] enemyLaggedPos` -> `enemyLaggedPos: Slots<Slots<Float>>`, Array of 24. The lookup store is stale for this field: the generated view at `Sources/JKAMP_Game/Generated/Views/GNPC.swift:629` reads `public var enemyLaggedPos: Slots<JKAShared.vec3_t> { Slots(vectors: ..., count: 24) }`. The next field is `gentity_t * watchTarget` -> `watchTarget: Entity?`.

Helpers. None. No clamp helper or rule 19 helper exists. The precedent form of the note is `Sources/JKAShared/q_shared.c.swift:127`, `// Raven reads the byte before the buffer for an empty path, and the Swift subscript traps there.`

Guide. `docs/porting-rules.md:44`, rule 19, reads "A Swift trap on an out-of-range index is a divergence of this kind when Raven read past the end, and the note says what Raven read." `docs/transcription.md:676` gives a rule 19 note in two lines at a site. The B4 row of `notes/2026-10-11/frame-path-walk.md` keeps Raven's test under a one-line rule 19 note in the same form.

Verdict. The premise is true. The site keeps Raven's lines and the trap, and takes a one-line rule 19 note above `:526`, with no guard. A guard would pick a value Raven never computes, and rule 19 already names the trap as the one defined behavior. The site reads:
```swift
// Raven reads one row past the 24 rows, the bytes of watchTarget and the next fields, when stats.aim plus g_spskill.integer is -6 or less, and the Swift subscript traps there.
target = NPCInfo!.enemyLaggedPos[missFactor]
```

### W24. Does the blank line after `trap_Trace( &tr, start, NULL, NULL, end, parent->s.number, MASK_SHOT );` in `VEH_TurretThink` go into the Swift?

Source. `notes/2026-10-11/review-phase2b-combat-bones.md:67`, finding 1.

Site. `Sources/JKAMP_GameLogic/g_vehicleTurret.swift:361-362` reads `trap_Trace(tr, start, vec3_origin, vec3_origin, end, parent.s.number, MASK_SHOT)` and, with no blank line between, `if tr.entityNum == turretEnemy!.s.number || (tr.allsolid == 0 && tr.startsolid == 0) {`. The record gives line 353, and the line moved to 361. Raven: `g_vehicleTurret.c:424` `trap_Trace( &tr, start, NULL, NULL, end, parent->s.number, MASK_SHOT );`, `:425` blank, `:426` `if ( tr.entityNum == turretEnemy->s.number`. The Swift keeps Raven's other blank lines in the same block, one before `end =` (Raven `:422`, Swift `:359`).

Truth. True. Raven has the blank line and the Swift has none. The behavior is the same, and only the layout differs.

jka-rust. `jka-rust/crates/mp/game/src/g_vehicleTurret.rs:645` wraps the trace in a multi-line call. The record says jka-rust is not the reference for blank lines, and the guide agrees.

Helpers. None.

Guide. No line of `docs/transcription.md` or `docs/porting-rules.md` asks for Raven's blank lines. `docs/style.md:93` says "A blank line separates multi-line switch cases and marks effect phases. Related one-liners cluster into blocks." The trace call ends one effect phase (the trace fills `tr`), and the `if` starts the next phase (the test of `tr`). The ledger and the notes of 2026-10-11 hold no ruling on blank lines.

Verdict. Premise true. The blank line goes in, as an effect-phase mark under `docs/style.md:93` and as Raven's own layout, and it costs nothing.
```swift
                        trap_Trace(tr, start, vec3_origin, vec3_origin, end, parent.s.number, MASK_SHOT)

                        if tr.entityNum == turretEnemy!.s.number || (tr.allsolid == 0 && tr.startsolid == 0) {
```
Alternate: leave the layout, because no guide line asks for Raven's blank lines.

### W25. Do `G2Tur_SetBoneAngles` and `EWeb_SetBoneAngles` take the blank lines between the `switch` arms that `NPC_SetBoneAngles` has?

Source. `notes/2026-10-11/review-phase2b-spawn-npc.md:83`, finding 3. The proof text `notes/2026-10-11/docket-proofs-conflict-4.md:21` says the three bodies are the same text.

Site. The three `switch i` blocks, lines from the working tree. `Sources/JKAMP_GameLogic/NPC_utils.swift:713-729`:
```
713:        switch i {
714:        case 0:
715:            thebone = 1
716:            boneVector = 1
717: 
718:        case 1:
719:            thebone = 2
720:            boneVector = 2
721: 
722:        case 2:
723:            thebone = 3
724:            boneVector = 3
725: 
726:        default:
727:            thebone = nil
728:            boneVector = nil
729:        }
```
`Sources/JKAMP_GameLogic/g_turret_G2.swift:63-76`:
```
63:        switch i {
64:        case 0:
65:            thebone = 1
66:            boneVector = 1
67:        case 1:
68:            thebone = 2
69:            boneVector = 2
70:        case 2:
71:            thebone = 3
72:            boneVector = 3
73:        default:
74:            thebone = nil
75:            boneVector = nil
76:        }
```
`Sources/JKAMP_GameLogic/g_items.swift:1477-1490`:
```
1477:        switch i {
1478:        case 0:
1479:            thebone = 1
1480:            boneVector = 1
1481:        case 1:
1482:            thebone = 2
1483:            boneVector = 2
1484:        case 2:
1485:            thebone = 3
1486:            boneVector = 3
1487:        default:
1488:            thebone = nil
1489:            boneVector = nil
1490:        }
```
Raven: `NPC_utils.c:936-954`, `g_turret_G2.c:54` and `g_items.c:1529` hold the same `switch (i)` with three-line arms (two stores and a `break`) and no blank line between arms. The record cites `g_items.swift:1477-1489`, and the end line is 1490.

Truth. True. Raven has no blank line between arms, so the blank lines in `NPC_utils.swift` come from the house rule, and the other two files lack them. Each arm is two lines in Swift, so it is a multi-line arm. A count over `Sources/JKAMP_GameLogic/*.swift` finds about 1181 `case` or `default` lines after a blank line against about 116 after a non-blank line, so the blank-line form is the tree norm.

jka-rust. `NPC_utils.rs:732`, `g_turret_G2.rs:69`, and `g_items.rs:1940` use a `for` loop and a `match` (`docket-proofs-conflict-4.md:31`), so they give no layout.

Helpers. None.

Guide. `docs/style.md:93`: "A blank line separates multi-line switch cases and marks effect phases." The house-style skill says the same, "Blank line between multi-line switch cases." No line of `docs/transcription.md` speaks of blank lines.

Verdict. Premise true. Both files take the blank lines of `NPC_utils.swift`: one blank line before `case 1:`, before `case 2:`, and before `default:`, in each file. Nothing else changes. The edit is three blank lines in `g_turret_G2.swift` (after lines 66, 69, 72) and three in `g_items.swift` (after lines 1480, 1483, 1486).

### W26. Do the three `g_log.swift` reads of `modNames[j] ?? "(null)"` need the two-line note that the C1 ruling puts at the `obit` read?

Source. `notes/2026-10-11/phase2-icarus-log.md:39`, finding 1. The deciding record is V14, `notes/2026-10-11/docket-proofs-V-12-22.md:29` onward.

Site. `Sources/JKAMP_GameLogic/g_log.swift:277` `G_LogPrintf("%25s:  Damage: %6d,  Kills: %5d\n", modNames[j] ?? "(null)", totaldamageMOD[j], totalkillsMOD[j])`, `:679` `Com_sprintf(&string, Int32((string).count), "\t%s", modNames[j] ?? "(null)")`, and `:736` the same text. Each loop runs `j` over `MOD_MAX`, 45, and the last three slots are NULL. The `obit` read with the note is `Sources/JKAMP_GameLogic/g_combat.swift:1972-1974`: `// Raven's table holds NULL past its 42 names, and his `%s` of NULL is undefined.`, `// The port prints "(null)", as the C runtimes do.`, `obit = modNames[meansOfDeath] ?? "(null)"`. Raven: `g_log.c:321` `modNames[j], totaldamageMOD[j], totalkillsMOD[j]);`, `:715` and `:771` `Com_sprintf(string, sizeof(string), "\t%s", modNames[j]);`, and `g_combat.c:2530` `obit = modNames[ meansOfDeath ];`. The table `g_combat.c:755` holds 42 names in a `MOD_MAX` array.

Truth. True. The three reads carry no note, and the C1 text (`frame-path-walk.md:19`) says only that the g_log reads "take the same `??`". The meaning of "same" is open. Concrete input: the stats dump at game end prints the `MOD_MAX` rows, so slots 42 to 44 print `(null)` in Raven and in the port.

V14 decision. V14 is open in `docket-proofs-V-12-22.md`, and its Verdict proposes that a `?? "(null)"` at a `%s` takes no note, because every runtime Raven ran on prints `(null)` for NULL, so the port does not diverge and rule 19 has nothing to record. V14 keeps the C1 note at `obit` "as ruled". If V14 is ratified, it decides this row, and W26 is a consequence of V14: the three g_log reads take no note. Walk V14 first.

jka-rust. `jka-rust/crates/mp/game/src/g_log.rs:501-510`, `modName(j)`, returns `(null)` for a NULL slot, with a doc line that names glibc. `g_combat.rs:2342-2343` writes `obit = "(null)"`.

Types. `modNames` is `[String?]` at `Sources/JKAMP_GameLogic/g_combat.swift:9`, forwarded from `world.modNames`, with the last three rows `nil` at `g_local.swift:192-195`.

Helpers. None. No `FormatArg` conformance takes `String?` (`Sources/JKAShared/Format.swift:27-57`).

Guide. `docs/transcription.md:339`: "A `String?` that Raven passes to a `%s` takes `?? "(null)"` at the argument in place of the force unwrap". It gives no note. Rulings: C1 at `frame-path-walk.md:19` and R2 at `:76`, which says "C1 and U2 take the same read".

Verdict. Premise true, and the row is a consequence of V14. Proposed form: no note at the three g_log reads, the lines stay as they are. If V14 is not ratified, each of the three reads takes the two lines of `g_combat.swift:1972-1973`.

### W27. Does the `modNames` note in `g_local.swift` move under the `///` lines and take the word form "three"?

Source. `notes/2026-10-11/review-phase2-npc-icarus.md:41-45`, finding 2, unit A-34.

Site. Current `Sources/JKAMP_GameLogic/g_local.swift:146-150`:
```swift
    /// Raven's `char *modNames[MOD_MAX]` of `g_combat.c`.
    /// Source: oracle/codemp/game/g_combat.c:755
    // Raven writes 42 rows for a `MOD_MAX` array of 45, so C zeroes the last three slots.
    // The last three rows here are those zeros.
    var modNames: [String?] = [
```
The record quotes the earlier text: `// Raven writes 42 rows for a `MOD_MAX` array of 45, so C zeroes the last 3 slots.` and `// The last 3 rows here are those zeros.`, above the two `///` lines. The exemplar `Sources/JKAMP_GameLogic/ai_wpnav.swift:63-65`:
```swift
// Raven wrote: float botGlobalNavWeaponWeights[WP_NUM_WEAPONS]
// Raven writes 16 rows for a `WP_NUM_WEAPONS` array, so C zeroes the last three slots.
// The last three rows here are those zeros.
let botGlobalNavWeaponWeights: [Float] = [
```
Raven: `g_combat.c:755` `char	*modNames[MOD_MAX] = {`, 42 rows to `:797`.

Truth. False. The tree already has the word form and the placement under the `///` lines, directly above the declaration, as the exemplar has. The wave B commit 1db7d1b holds the new text, and the review read the wave A text. The row is stale, record-only.

jka-rust. `jka-rust/crates/mp/game/src/g_combat.rs:62-64` puts the note in the `///` doc of the table, and the record says jka-rust is not the reference for placement.

Types. `modNames` is `[String?]` with 45 slots, and the last three are `nil` (`g_local.swift:192-195`).

Helpers. None.

Guide. The exemplar at `ai_wpnav.swift:63-65` is the form. `g_local.swift` is the state file that only the coordinator edits, and no edit is due.

Verdict. Premise false, record-only. Change the row text of `review-phase2-npc-icarus.md:41-45` to "resolved before the wave B commit". No site edit.

### W28. Do the four `G_Spawn*` functions take `@discardableResult`, or do the call sites that drop the result take `_ =`?

Source. `notes/2026-10-11/phase2-bot-items.md:43` (finding 3), and `notes/2026-10-11/review-phase2-bot-items.md:53` (note 3) raises the same point.

Site. The four functions are at `Sources/JKAMP_GameLogic/g_spawn.swift:37` `func G_SpawnString(_ key: String, _ defaultString: String?, _ out: inout String) -> Bool`, `:59` `func G_SpawnFloat(...) -> Bool`, `:69` `func G_SpawnInt(...) -> Bool`, and `:79` `func G_SpawnVector(...) -> Bool`. None has an attribute. The two A-02 sites are `Sources/JKAMP_GameLogic/g_saga.swift:1643` `G_SpawnVector("mins", "-16 -16 -24", &ent.r.mins)` and `:1644` `G_SpawnVector("maxs", "16 16 32", &ent.r.maxs)`. The records give :1641 and :1644, so the first line moved. The `G_SpawnInt` drops in `g_saga.swift` are at lines 1063, 1064, 1126, 1209, 1210, 1575, 1576, 1583, 1592, 1594, 1595, 1652, 1662, 1668, and 1669. A grep for a call that starts a statement (`^\s*G_Spawn(String|Float|Int|Vector)\(`) finds 161 dropped results in Sources: 45 of `G_SpawnString`, 33 of `G_SpawnFloat`, 81 of `G_SpawnInt`, and 2 of `G_SpawnVector`. The files are g_misc 39, g_mover 27, g_spawn 26, g_saga 26, g_trigger 12, g_client 10, g_target 5, g_turret_G2 5, g_items 3, g_turret 3, NPC_spawn 3, and g_weapon 2. Another 23 sites use the result, for example `if G_SpawnString(...)`. No site in Sources has `_ = G_Spawn*`. Raven: `g_saga.c:1762` `G_SpawnVector("mins", "-16 -16 -24", ent->r.mins);` and `g_saga.c:1763`. Raven drops the result at the same 161 statement sites, for example `g_spawn.c:781` `G_SpawnInt( "notsingle", "0", &i );`. The C functions return `qboolean` (`g_spawn.c:6`, `:25`, `:34`, `:43`).

Truth. True. A Swift call to a function with a non-Void result that nobody reads gives the warning "result of call to 'G_SpawnInt' is unused". The source order of the 161 sites decides nothing here. Every one of them warns until the attribute exists. The count in the record (two A-02 sites and the `G_SpawnInt` calls in g_saga) is low. The true count is 161.

jka-rust. `jka-rust/crates/mp/game/src/g_spawn.rs:124` `pub fn G_SpawnInt(...) -> qboolean` and `:140` `pub fn G_SpawnVector(...) -> qboolean` carry no attribute. Rust warns only for `#[must_use]` results, so the rust port drops the result with no change.

Types. `python3 tools/oracle-closure/lookup.py sig G_SpawnVector` prints `g_spawn.c  \`func G_SpawnVector(_ key: String, _ defaultString: String, _ out: inout JKAShared.vec3_t) -> Bool\``. `sig G_SpawnInt` prints `func G_SpawnInt(_ key: String, _ defaultString: String, _ out: inout Int32) -> Bool`. Both prints follow the stale-row line (see W33).

Helpers. None for the four functions. `@discardableResult` exists only in generated trap, strap, and callback code: `Sources/JKAMP_Game/Generated/g_syscalls.swift:23` and the `Sources/JKAMP_BG/Generated/bg_strap.swift` and `bg_callbacks.swift` files. No file in `Sources/JKAMP_GameLogic` uses it. The generators write it at `tools/oracle-closure/traps.py:156`, `channel.py:312`, and `views.py:549`. For a hand-bodied Raven function, GameLogic has 17 `_ = ` sites, for example `bg_pmove_game.swift:45` `_ = G_PlayEffect(effectID, bottom, groundNormal)`, `NPC_spawn.swift:3435` `_ = NPC_SpawnType(...)`, and `ai_util.swift:224` `_ = B_TempAlloc(MAX_CHAT_BUFFER_SIZE)`. Each of these 17 is a site where Raven drops a result the function mostly returns for other callers.

Guide. `docs/transcription.md:692`: "A trap's return is `@discardableResult`, and so is a strap's or a callback's, because Raven drops it at most sites and C never warned, so a body writes his line with no `_ =`." Lines 710-711 give `_ = B_TempAlloc(131072)` and `_ = G_Alloc(strlen(info) + 1)` for a single dropped pool call. No line covers a transcribed C function whose result Raven drops at most sites. The 161 against 23 split is the same reason line 692 gives for traps.

Verdict. Premise true, and the count is 161 sites, not 17. Put `@discardableResult` on the four functions, because a `_ =` at 161 sites changes Raven's line at every site and the guide already ruled that shape out for traps. Add the attribute above `func` at `g_spawn.swift:37`, `:59`, `:69`, and `:79`:
```swift
@discardableResult
func G_SpawnVector(_ key: String, _ defaultString: String, _ out: inout JKAShared.vec3_t) -> Bool {
```
Add one guide sentence after line 692: "A transcribed C function whose result Raven drops at most of its call sites, such as the `G_Spawn*` family, is `@discardableResult`, and a body writes Raven's line with no `_ =`." The 23 sites that read the result stay as they are. The `_ =` form stays for a single site of a function that most callers read, such as `G_PlayEffect`. Alternate, close: no guide sentence, one note in the g_spawn Port-notes.

### W29. Do the unread local `point` of `NPC_GM_Pain` and the `dot1` store of `WP_SaberStartMissileBlockCheck` stay as Raven wrote them, or take a form that silences the warning?

Source. `notes/2026-10-11/holes2-npc.md:94` (finding 5) for `point`. `notes/2026-10-11/review-phase2b-spawn-npc.md:93` (Notes, second bullet) raises the same point. `notes/2026-10-11/phase2-saber.md:42` (finding 3) for `dot1`.

Site. `point`: `Sources/JKAMP_GameLogic/NPC_AI_GalakMech.swift:262` `var point = vec3_t()` and `:267` `point = gPainPoint`. No later line of `NPC_GM_Pain` reads `point`. The `else` arm at :294-299 holds only comments, `//	VectorCopy( point, self->pos4 );` among them. Raven: `NPC_AI_GalakMech.c:240` `vec3_t point;`, `:245` `VectorCopy(gPainPoint, point);`, and `:275` `if ( point )`. The only C read is the always-true array test that S1 drops. `dot1`: `Sources/JKAMP_GameLogic/w_saber.swift:4639` `var dot1: Float = 0`, `:4818` `dot1 = _DotProduct(dir, forward)` followed at `:4819` by `jump = dot1 < SABER_REFLECT_MISSILE_CONE`, and `:4897` `dot1 = _DotProduct(dir, forward)` followed at `:4898` by `if dot1 < SABER_REFLECT_MISSILE_CONE {`. The records give no line for `dot1`. Raven: `w_saber.c:5504` `float		dot1, dot2;`, `:5693` `(dot1 = DotProduct( dir, forward )) < SABER_REFLECT_MISSILE_CONE||`, and `:5769` `if ( (dot1 = DotProduct( dir, forward )) < SABER_REFLECT_MISSILE_CONE )`. The sibling precedent for an unread value is `w_saber.swift:5779` `_ = other.client!.saber[1].disarmBonus`.

Truth. Amended. For `point` the premise is true. Swift warns "variable 'point' was written to, but never read" once S1 drops the read. C gave no warning, because the `if ( point )` read existed and no unused-but-set warning flag is on. For `dot1` the premise is false. Both Swift stores are read on the next line, in `dot1 < SABER_REFLECT_MISSILE_CONE`, so the compiler has no unread store to report. Swift does not warn about the dead-looking initializer `= 0` of a `var` that a later store overwrites. The phrase "dead store" in the E5 ruling means that the store sits in a `||` chain that C evaluates in order. It does not mean an unread variable.

jka-rust. `NPC_GM_Pain` in `jka-rust/crates/mp/game/src/NPC_AI_GalakMech.rs:321-` has no `point` local at all. The port dropped the local with the always-true test. `w_saber.rs:6759` writes `_DotProduct(dir, forward) < SABER_REFLECT_MISSILE_CONE` with no `dot1` variable, inside the long `&&` condition.

Types. `gPainPoint` is a `vec3_t` global in `Sources/JKAMP_GameLogic`, and `point` is a `vec3_t`. No view type is involved. `dot1` is `Float`.

Helpers. None for a silencing form. The one precedent for a read made only to quiet the compiler is `_ = other.client!.saber[1].disarmBonus` at `w_saber.swift:5779` and `:5856`, where Raven's own expression statement drops its value.

Guide. No line of `docs/transcription.md` covers an unread local or a dead store. A grep for "dead store", "unread", "never read", and "unused" finds nothing about locals. Lines 334-335 drop a never-null test with no comment and no marker. The S1 ruling in `notes/2026-10-11/frame-path-walk.md:70` says "with no comment and no marker", and `notes/2026-10-11/docket-proofs-conflict-2.md` (Verdict) settled it: "No comment. C2 is correct, and the S1 form changes to match it." The same Verdict names the `point` warning: "After the fill no line reads `point`, so the compiler can warn". The E5 ruling at `frame-path-walk.md:33` ends "The form keeps Raven's dead store."

Verdict. Amended. `dot1` needs no change, because the compiler has nothing to report there, so only the E5 and phase2-saber record wording changes (finding 3 should read that both stores are read on the next line). For `point`, the warning stays as accepted. Raven wrote the local and the copy, S1 ruled no marker at the fill, and a silencing line such as `_ = point` is a marker of the kind S1 and C2 refused. The site does not change:
```swift
var point = vec3_t()
...
point = gPainPoint
```
Alternate, close: add `_ = point` after the fill, in the form of `w_saber.swift:5779`, if the user wants a build with no warnings.

### W30. Do the `portMissing` initializers of `ctfFlagStatusRemap` and `BMS_START`, `BMS_MID`, `BMS_END` fill, and with what text?

Source. `notes/2026-10-11/holes2-entities.md:60` (finding 4).

Site. `Sources/JKAMP_GameLogic/g_team.swift:10-12` is `// Raven wrote: static char ctfFlagStatusRemap[] = { '0', '1', '*', '*', '2' }` and `nonisolated(unsafe) let ctfFlagStatusRemap: JKAShared.CharBuf = { () -> JKAShared.CharBuf in portMissing("ctfFlagStatusRemap", source: "oracle/codemp/game/g_team.c:279") }()`. `Sources/JKAMP_GameLogic/g_mover.swift:42-51` is three entries of the form `let BMS_START: Int32 = { () -> Int32 in portMissing("BMS_START", source: "oracle/codemp/game/g_mover.c:35") }()`, with `BMS_MID` at :47 (g_mover.c:36) and `BMS_END` at :51 (g_mover.c:37). The records give the same lines. Each entry has a `// Raven wrote:` line and no Port-note. Raven: `oracle/codemp/game/g_team.c:279` `static char ctfFlagStatusRemap[] = { '0', '1', '*', '*', '2' };`, read at `g_team.c:311-312` `st[0] = ctfFlagStatusRemap[teamgame.redStatus];` (Swift reads at `g_team.swift:251-252`). Raven: `oracle/codemp/game/g_mover.c:35-37` `int	BMS_START = 0;`, `int	BMS_MID = 1;`, `int	BMS_END = 2;`. Nothing in `oracle/codemp` assigns them. `cg_ents.c:2736-2738` holds separate `CG_BMS_*` copies. The Swift reads are `g_mover.swift:73`, `:672`, `:691`, `:724`, `:763`, and five sites in `g_ICARUScb.swift` (:362, :466, :512, :617, :1691). All of them trap through `portMissing` today.

Truth. True. The four entries are guide line 447 entries that the transcriptor never filled, and they are not Port-note holes. Any door, plat, or ICARUS call that reaches `G_PlayDoorSound` traps at the first read of `BMS_START`, `BMS_MID`, or `BMS_END`, and `Team_SetFlagStatus` traps at the first CTF flag change. Neither Swift file ever assigns the names, so the "never assigns" condition of line 447 holds.

jka-rust. `jka-rust/crates/mp/game/src/g_mover.rs:95-100` has a comment that the three never get reassigned and then `pub const BMS_START: c_int = 0;`, `pub const BMS_MID: c_int = 1;`, `pub const BMS_END: c_int = 2;`. `jka-rust/crates/mp/game/src/g_team.rs:346` has the local `let ctfFlagStatusRemap: &[u8] = &[b'0', b'1', b'*', b'*', b'2'];`, read at :355 and :357.

Types. `python3 tools/oracle-closure/lookup.py Teamgame redStatus` gives `redStatus: JKAMP.flagStatus_t`, an `Int32` alias, so the subscript takes it with no cast. `lookup.py CharBuf` finds no type, because `CharBuf` is a hand struct in `Sources/JKAShared/CharBuf.swift`. Its inits are `init(_ count:)` (zero filled), `init(_ string: String)` (adds a trailing NUL, so five characters give count 6), `init(stringLiteral:)`, and `init(bytes: [CChar])` (keeps every byte, count equals the array count). Its subscript `subscript<I: BinaryInteger>(i: I) -> Int8` reads the byte sign-extended. `G_PlayDoorSound(_ ent: Entity, _ type: Int32)` at `g_mover.swift:82` takes the BMS names as `Int32`.

Helpers. None for the data. `CharBuf(bytes:)` at `Sources/JKAShared/CharBuf.swift` builds the exact five bytes. The filled-table precedent is `botGlobalNavWeaponWeights` at `Sources/JKAMP_GameLogic/ai_wpnav.swift:62-65`, a `// Raven wrote:` line and then the data. A filled `Int32` constant precedent is `Sources/JKAMP_GameLogic/g_mover.swift:36` `let MOVER_INACTIVE = 128 as Int32`.

Guide. `docs/transcription.md:447`: "A variable the module never assigns is a typed `let` with a `portMissing` initializer and a `// Raven wrote:` line, and the transcriptor replaces the initializer with Raven's data." The guide gives no form for a `char` array initializer.

Verdict. Premise true, and all four fill with Raven's data. The `// Raven wrote:` lines stay, because line 447 keeps them. In `g_mover.swift`:
```swift
let BMS_START: Int32 = 0
let BMS_MID: Int32 = 1
let BMS_END: Int32 = 2
```
In `g_team.swift`, with the five bytes `'0'` 0x30, `'1'` 0x31, `'*'` 0x2A, `'*'` 0x2A, `'2'` 0x32:
```swift
nonisolated(unsafe) let ctfFlagStatusRemap: JKAShared.CharBuf = CharBuf(bytes: [0x30, 0x31, 0x2A, 0x2A, 0x32])
```
The `CharBuf("01**2")` alternate gives a sixth NUL byte and differs from Raven's `sizeof`. No read uses `sizeof`, so the alternate is close but not exact. Add to guide line 447, after the sentence: "A `char` array initializer takes `CharBuf(bytes: [...])` with Raven's character codes in hex, so the byte count stays Raven's."

The grep of all `portMissing(` calls in `Sources/JKAMP_GameLogic` finds 58 calls. 13 have no line with `Port-note` in the three lines above them. Ten of them are the same kind of file-scope entry that line 447 fills, and the four above are among the 13. The full list, as file:line `text`:

- `NPC.swift:70` `let NPCDEBUG_GREEN: JKAShared.vec3_t = ... portMissing("NPCDEBUG_GREEN", source: "oracle/codemp/game/NPC.c:657")`
- `NPC.swift:81` `let NPCDEBUG_LIGHT_BLUE: JKAShared.vec3_t = ... portMissing("NPCDEBUG_LIGHT_BLUE", source: "oracle/codemp/game/NPC.c:659")`
- `NPC_stats.swift:28` `let ClassNames: [String] = ... portMissing("ClassNames", source: "oracle/codemp/game/NPC_stats.c:156")`
- `ai_main.swift:124` `let ctfStateNames: [String] = ... portMissing("ctfStateNames", source: "oracle/codemp/game/ai_main.c:96")`
- `g_ICARUScb.swift:16` `let player_locked: Bool = ... portMissing("player_locked", source: "oracle/codemp/game/g_ICARUScb.c:4575")`
- `g_log.swift:75` `let weaponFromMOD: [Int32] = ... portMissing("weaponFromMOD", source: "oracle/codemp/game/g_log.c:35")`
- `g_mover.swift:43`, `:47`, `:51` `BMS_START`, `BMS_MID`, `BMS_END` (above)
- `g_team.swift:12` `ctfFlagStatusRemap` (above)
- `w_force.swift:51` `let forcePowerMinRank: [[Int32]] = ... portMissing("forcePowerMinRank", source: "oracle/codemp/game/w_force.c:51")`
- `w_force.swift:55` `let mindTrickTime: [Int32] = ... portMissing("mindTrickTime", source: "oracle/codemp/game/w_force.c:139")`
- `w_force.swift:59` `let forcePushPullRadius: [Float] = ... portMissing("forcePushPullRadius", source: "oracle/codemp/game/w_force.c:3044")`

The other 45 `portMissing` calls have a Port-note within three lines. The three file-scope entries of `Sources/JKAMP_BG/bg_saber.swift` (:24, :28, :47) are in the same state and sit outside the module that the row names. A second row can fill the other nine entries of GameLogic with Raven's data the same way.

### W31. Does the `goto blockStuff` note keep the "Port-note" label, or take another label so the hole counts exclude it?

Source. `notes/2026-10-11/holes2-combat.md:16` (table row) and `:57` (finding 5).

Site. `Sources/JKAMP_GameLogic/w_saber.swift:3902` `// Port-note: Raven's `goto blockStuff` jumps from the blocked-hit arm into the saber-clash arm, to his label `blockStuff`.` The records give :3900, so the line moved by two. A second comment line follows: `// The statements from the label to the end of the saber-clash arm are this nested function, and both arms return its value.` Then `func blockStuff() -> Bool {` stands at :3904. The two jumps are `w_saber.swift:4237` `// Raven wrote `goto blockStuff` at this line.` with `return blockStuff()` under it, and `:4401` `return blockStuff()`. The note has no `portMissing` call under it. Raven: the `goto blockStuff` and the label `blockStuff:` in `oracle/codemp/game/w_saber.c`, inside `CheckSaberDamage`. Other Port-notes in Sources that name a label or a `goto`: only `Sources/JKAMP_BG/bg_pmove.swift:5738` `// Port-note: Raven writes the label `backAgain:` here and jumps back to it once, from the saber case. Rule 10 turns that jump into a loop that repeats the block.` A scan of all 57 `// Port-note` lines in Sources finds 10 with no `portMissing` call in the three lines after the note. They are `bg_misc.swift:217`, `:733`, `bg_panimate.swift:876`, `:879`, `bg_pmove.swift:897`, `:987`, `:5738`, `:6945`, `:8215`, and the `w_saber.swift:3902` note. Only the last one is in `Sources/JKAMP_GameLogic`. The other eight are rule 19 and divergence notes, and `backAgain` is the one other guide-ordered `goto` note. `bg_lib.swift:67` carries a `///` doc about `goto loop` with no Port-note label. `g_navnew.swift:865` has a `goto finish;` in a comment.

Truth. True. The note is guide-ordered and it is not a hole. A hole is a Port-note with a `portMissing` call under it (guide line 64), and this note has none. No round fills it, because the restructuring is done and it only records the label for review. The per-file count in the plan counts every `Port-note` line by grep, so it counts this note once too many.

jka-rust. `jka-rust/crates/mp/game/src/w_saber.rs` has no label note to follow. The rust port keeps Raven's control flow with its own structure, and no row depends on it.

Helpers. None. The drafter counts holes itself: `tools/oracle-closure/draftcheck.py:330-372` prints "holes", "compile holes", and "defects" per stem from the drafter's own list (`drafter.holes`, `drafter.compile_holes`), and never greps for the text "Port-note". The only tool code that names the text is the line writer `tools/oracle-closure/layout.py:17` (`"// Port-note: " + ...`), the drafter notes in `draft_statements.py`, `draft_expressions.py`, and `draft_calls.py`, and the marker regex `MARKER = re.compile(r'^portMissing\("(\w+)"')` at `draftcheck.py:64`. The marker, not the label, defines a hole to the tools.

Guide. `docs/transcription.md:609-611`: "A `goto` is restructured with the smallest change that preserves Raven's control flow, per rule 10." and "It gets a Port-note naming the label, so the reviewer and the user can check the restructuring against Raven's intent." Line 64: "A Port-note that names a behavior the body does not reproduce has a `portMissing` call on the line under it, so a grep for `portMissing` finds it and the drafter counts it as a hole." Line 607 also orders a Port-note for a labeled `continue`, and that note does carry a `portMissing` marker.

Verdict. Premise true, and the label stays "Port-note". The guide orders that exact label at line 611 and `bg_pmove.swift:5738` uses it the same way, so a new label would split the guide in two. The hole definition already excludes the note, because a hole needs the `portMissing` call under the note. Change the count, not the note. Every plan and round count of holes states its method as "Port-notes with a `portMissing` call on the next line", and a hole grep reads `grep -c 'portMissing('` per file. The record text `holes2-combat.md:57` changes from "so the per-file count of the plan holds one note that no round fills" to "so a count by the text Port-note holds one note that no round fills, and a count by the `portMissing` marker excludes it". No Sources file changes. Alternate, close: none.

### W32. Which record texts carry a wrong count or a wrong site, and does each old text change or does a line in a new dated record note the correction?

Source. `notes/2026-10-11/phase2-bot-items.md:41` and `:44` with `review-phase2-bot-items.md:51-52` for (a) and (c). `notes/2026-10-11/phase-2-plan.md:67` for (b). `notes/2026-10-11/holes2-combat.md:53` and `:55` for (d) and (e). `notes/2026-10-11/holes2-entities.md:57` for (f). `notes/2026-10-11/holes2-main.md:66` for (g). `notes/2026-10-11/phase2-sort.md:29` for (h).

Site. See each item. Every text below is a record text, and no file in Sources changes.

Truth. Record-only for all eight items. The premise of each item is true, except where the item says otherwise. Placement rule from the user's memory: a walk record is a dated record under `notes/2026-10-11/`, and `docs/` states timeless truth. So no item touches `docs/transcription.md`. `notes/LEDGER.md` lists only the verdict rows of past walks, and the rows below are not verdicts. The old record files are the commit history of what each agent believed when it wrote the file. The proposal for all eight: leave the old file text as it stands, and add one line per item to a new dated record, `notes/2026-10-11/count-corrections.md`, that names the old file and line, the old text, and the corrected text. The one exception is (g), where the ruling text itself in `frame-path-walk.md:22` and `docket-proofs-C-D.md:94` carries the false clause. A ruling text drives later work, so (g) changes in place.

- (a) The R10 count of reads. Premise true. `oracle/codemp/game/ai_wpnav.c:3055` `void G_RMGPathing(void)` has the early-out at `:3070` `if (!terrain || !terrain->inuse || terrain->s.eType != ET_TERRAIN)`. After it, `terrain->` appears at `:3086`, `:3087`, `:3088`, `:3092`, `:3099`, `:3114`, `:3127`, `:3170`, and `:3178`, which is nine reads (a count over `:3071-3250`, the end of the function). The Swift has nine at `Sources/JKAMP_GameLogic/ai_wpnav.swift:2498`, `:2499`, `:2500`, `:2504`, `:2509`, `:2522`, `:2533`, `:2568`, `:2572`, and the guard is at :2486 `guard let terrain, terrain.inuse, terrain.s.eType == ET_TERRAIN else {`. The wrong texts are `notes/2026-10-11/frame-path-walk.md:84` (R10) "The eight reads become `terrain.r.absmin[0]` and the like.", `notes/2026-10-11/docket-proofs-R.md:130` and `:145` ("eight `terrain!` reads at `:2512-2586`" and "The eight reads become"), and `notes/2026-10-11/phase-2-plan.md:42` (A-28) "the 11 `terrain!` reads after it". Corrected text: "The nine reads become `terrain.r.absmin[0]` and the like." and "the 9 `terrain!` reads after it". The work is done (the guard stands in the tree), so the old texts only mislead a reader who counts. Propose the line in the new record, and the plan row A-28 is already past.
- (b) The R9 count of other calls. Premise true. In the tree at a1b6196 (the base of the plan), a grep for `G_Find(...)` with `.target!` or `.target2!` in `g_trigger.swift`, `g_misc.swift`, `g_target.swift`, and `g_mover.swift` gives 17 lines. Two of them are the `target_random_use` sites, `g_target.swift:689` and `:709`. The other 15 are `g_trigger.swift:1390`, `:1500`, `:1513`, `:1542`, `:1683`, `:1696`, `:1702`, `g_misc.swift:2030`, `:2048`, `:2718`, `:2815`, `g_target.swift:42`, `:410`, `g_mover.swift:1792`, and `:1823`. The wrong text is `notes/2026-10-11/frame-path-walk.md:83` (R9) "Fourteen other `G_Find(..., x.target!)` calls in g_trigger, g_misc, g_target, and g_mover share the ground." Corrected text: "Fifteen other". The plan note 5 at `phase-2-plan.md:67` already gives the right count. Those 15 sites are already changed in the working tree (`g_trigger.swift:1390` now reads `G_Find(nil, \.targetname, `self`.target)`, and a grep for `.target!` inside `G_Find(` gives no line). Line to add to the new record only.
- (c) The N1 line in Raven. Premise true. `oracle/codemp/game/g_weapon.c:1765` `vel *= 0.5f;` sits in `rocketThink` (`:1651`) where `vel` is a `float`, so it is no int compound store. `g_weapon.c:1837` `vel *= 0.5f;` sits in `WP_FireRocket` (`:1826`) after `int	vel = ROCKET_VELOCITY;` at `:1829`, and it is the site that the Swift `vel = Int32(vel * 0.5)` at `g_weapon.swift:1868` matches. The wrong text is `notes/2026-10-11/docket-proofs-L-M-N-O.md:170` "g_combat.c:5461, 5465, g_items.c:2601, g_mover.c:2451, g_weapon.c:1368, 1765, bg_pmove.c:10715, ...". Corrected text: replace `1765` with `1837`. Line to add to the new record. The Swift site is correct and `g_weapon.swift:1804` (`vel *= 0.5` over a `Float`) is the `rocketThink` line that needs no change.
- (d) The count of `boltMatrix` holes. Premise true. In `Sources/JKAMP_GameLogic/g_weapon.swift` at a1b6196 there were four notes that name `boltMatrix`: the declaration note and three read notes (the `GetBoltMatrix_NoRecNoRot` call and two `BG_GiveMeVectorFromMatrix` calls). In the tree now they are at `:3485` (the declaration, a compile-failure note, `portMissing("WP_CalcVehMuzzle", ...)` at :3487), `:3504`, `:3507`, and `:3510`. The wrong text is `notes/2026-10-11/phase-2-plan.md:144` "the three `boltMatrix` holes of `g_weapon.swift`". The brief of wave B repeated it. Corrected text: "the four `boltMatrix` holes". Line to add to the new record.
- (e) The count of `pm` holes. Premise true. `Sources/JKAMP_GameLogic/g_active.swift` at a1b6196 had nine "A read of `pm`" Port-notes at :701, :704, :714, :717, :2562, :2565, :2571, :2625, :2628. A4 (guide line 323) covers the two `pm.baseEnt` sites (:714, :2625). A5 (guide line 552) covers the two `pm.entSize` sites (:717, :2628). A6 (guide line 539) covers the one `pm.pmove_fixed` site (:2571). The other four, `pm.trace` at :701 and :2562 and `pm.pointcontents` at :704 and :2565, have no ruling (the four that stand in the tree now). The wrong text is `phase-2-plan.md:140` "The 9 `pm` holes of `g_active.swift` take guide lines 325 (A4) and 552 (A5)." Corrected text: "Five `pm` holes of `g_active.swift` take guide lines 323 (A4), 552 (A5), and 539 (A6), and four have no form, the `pm.trace` and `pm.pointcontents` stores." Note the plan says line 325 and the guide line is 323 in the A4 ruling text. Line to add to the new record.
- (f) Holes that "have no form". Premise true. `phase-2-plan.md:144` lists "the five holes of the rule 11 `char *` field shape" as having no form. Q1 (`frame-path-walk.md:66`) and guide line 624 give the form, `CharBuf(ent.message!)` at the site. The five holes are the four `Use_Target_Print` message holes and the `model` hole, and the records say they are filled now. Corrected text: delete "and the five holes of the rule 11 `char *` field shape" from the sentence, so it ends "...which wait on a `sig` row." (after (d) the sentence also reads "four `boltMatrix` holes"). Line to add to the new record.
- (g) The D2 phrase "the hand `COM_Parse` walk drops". Premise true, and amended in meaning. The file never held such a walk (`git log -S"COM_Parse" -- Sources/JKAMP_GameLogic/g_session.swift` finds no commit, and the file has no `COM_Parse` now). The words come from `frame-path-round.md:53`, the D2 row of proposals, "A token overload or a hand `COM_Parse` walk", where the hand walk was the rejected alternate form. The ruling then dropped the alternate, not code. The wrong texts are `docket-proofs-C-D.md:94` and `frame-path-walk.md:22`. Corrected text for both: "The hand `COM_Parse` walk is not used, because `COM_Parse` reads quotes and comments that `sscanf` does not." Change the two texts in place, because a ruling text steers the next reader.
- (h) The A1 and A2 proofs. Premise true. `notes/2026-10-11/docket-proofs-A-B.md:1` reads "Docket proofs of rows A3 to A6 and B1 to B6", and its first section is `### A3` at :6. A1 and A2 have no proof section. They were ruled from the ledger rows `frame-path-walk.md:7` and `:8` and from the proposals in `frame-path-round.md:38-39`. The wrong text is the task text that `phase2-sort.md:29` quotes, "a Verdict paragraph for A1 and A2 in `docket-proofs-A-B.md`", and it lives in a brief, not in a record. No record text changes. Line to add to the new record: "A1 and A2 have no proof section. Their rulings are the rows `frame-path-walk.md:7-8`."

jka-rust. Not involved. All eight items are record counts.

Types. None.

Helpers. None.

Guide. No `docs/transcription.md` line changes for any item. Items (b), (e), and (f) touch plan counts, not guide rules. Guide line 323 (A4), 539 (A6), 552 (A5), and 624 (Q1) are the lines that the corrected texts cite.

Verdict. Premise true for all eight. Propose one new record, `notes/2026-10-11/count-corrections.md`, with one line each for (a) to (f) and (h) in the shape "File:line, old text, corrected text". Items (a) to (f) and (h) leave the old files alone. Item (g) changes the two ruling texts in place to the corrected clause above. Alternate, close: edit all eight old texts in place, if the user wants the plan to read right at the next Part B count, because the plan is the one file a later agent reads for counts.

### W33. Does `lookup.py` get a help flag, and do the stale signature rows get regenerated?

Source. `notes/2026-10-11/phase2-find.md:63` (finding 3) for the help flag. `notes/2026-10-11/holes2-bones.md:58` (finding 7) for the stale rows.

Site. `tools/oracle-closure/lookup.py:152-176`, `def main() -> None:`. It sets `args = sys.argv[1:]` and prints `__doc__` with exit 2 only when `args` is empty. A single argument goes to `stone(args[0], None)` and `index(args[0])`, then prints `lookup: no type named {args[0]}, and no view over it` with exit 1. The stale report is at `lookup.py:90-100`, in `stored(name)`: `stale = store.rehashed(SIGNATURES, REPO)`, then a `print(... "the signature rows in the store are stale, {len(stale)} Swift stubs changed: {shown}. Run skeleton.py to write them again.", file=sys.stderr)` and `return None`. `Store.rehashed` is at `tools/oracle-closure/store.py:328-331`: it hashes the whole bytes of each saved Swift file and compares them with the hash saved by the last generator run.

Truth. True for both. Run now: `python3 tools/oracle-closure/lookup.py --help` prints `lookup: no type named --help, and no view over it`. Run now: `python3 tools/oracle-closure/lookup.py sig G_Find` prints on standard error `lookup.py: the signature rows in the store are stale, 36 Swift stubs changed: Sources/JKAMP_GameLogic/FighterNPC.swift, Sources/JKAMP_GameLogic/NPC_AI_GalakMech.swift, Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift, Sources/JKAMP_GameLogic/NPC_AI_Rancor.swift, Sources/JKAMP_GameLogic/NPC_AI_Sniper.swift, and 31 more. Run skeleton.py to write them again.` The answer then comes from the manifests, not the store (`g_spawn.c  `func G_SpawnVector(...) -> Bool`` for `sig G_SpawnVector`). The count is 36 today, not 28, because the phase 2 waves edited more files since the records. The 36 are all in `Sources/JKAMP_GameLogic`: FighterNPC, NPC_AI_GalakMech, NPC_AI_Jedi, NPC_AI_Rancor, NPC_AI_Sniper, NPC_AI_Utils, NPC_combat, NPC_senses, NPC_spawn, NPC_utils, SpeederNPC, ai_main, ai_wpnav, g_ICARUScb, g_active, g_client, g_cmds, g_combat, g_items, g_log, g_main, g_misc, g_mover, g_nav, g_saga, g_session, g_svcmds, g_target, g_team, g_trigger, g_turret_G2, g_utils, g_vehicleTurret, g_vehicles, g_weapon, and w_saber (all `.swift`). The tool names files, not stubs, and the record calls them 28 stubs. The check is a hash of a whole file, so every body edit of a transcribed file makes its rows stale, whether the signatures changed or not. The 28 list in the record cannot be rebuilt from the tool, because the tool prints five names and a count.

jka-rust. Not involved. The tool is Swift-side tooling only.

Types. None.

Helpers. The generator that writes the rows is `tools/oracle-closure/skeleton.py`. Its `save_signatures` (`skeleton.py:1258-1265`) writes the rows and the file hashes into the store through `Store.save_signatures`, and `main` calls it at `:1403` (after `--publish`) and `:1414` (after a normal run). `skeleton.py` has no flag that writes the rows alone. A normal run also calls `gen.write()`, which replaces every stub file that still carries the generated header (adopted files stay), and rewrites `Sources/JKAMP_GameLogic/Generated/Callbacks.swift`. `--only <stem>` prints one stub to stdout and writes nothing, and `--publish` edits adopted bg files. I did not run any of them. 20 scripts of the tool use `argparse` and so already answer `--help`. `lookup.py` is the one that reads `sys.argv` by hand.

Guide. `docs/transcription.md` does not mention `lookup.py --help` or the stale report. The `lookup.py` docstring (`lookup.py:9-18`) is the only usage text, and it prints on an empty argument list.

Verdict. Premise true for both. Add the help flag in `main` before the other branches, so the docstring prints with exit 0:
```python
    if not args:
        print(__doc__)
        sys.exit(2)
    if args[0] in ("-h", "--help"):
        print(__doc__)
        return
```
For the stale rows, add a `--signatures` flag to `skeleton.py` that builds `Skeleton(C.Parse())`, calls `gen.save_signatures()`, prints the row count, and returns, with no `gen.write()`. The rows read the stubs on disk (`skeleton.py` docstring: "A row reads the stub on disk"), so the flag gives fresh rows from the adopted bodies and touches no Sources file. A coordinator runs it once after each wave's commit, in the same step as the gate. Alternate, close: run the existing full `skeleton.py` once, which gives the same rows but also rewrites unadopted stubs and `Callbacks.swift`. A further change, not proposed here: hash only the signature lines of a stub in `Store.rehashed`, so a body edit stops making rows stale.
