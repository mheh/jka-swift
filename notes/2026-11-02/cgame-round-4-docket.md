# The cgame transcription rounds, round 4, cg_players, the docket

The investigator's docket for the fourth cgame round, one stem, `cg_players`, on the branch `cgame-round-4-cg-players` at e31f30d. Draft gate of the stem: 85 of 85 replaced, 236 holes, 0 cascade errors, 0 defects, 89 compile holes over 19 passes. The adopted file is `Sources/JKAMP_CGameLogic/cg_players.swift`, and it carries 236 Port-notes. Rows R23 to R29 below are drafter rows. Each row names the Raven lines, the Swift lines, the game form, the Rust form, the module, and the sites it closes. No row was run, so the counts are the notes the row reaches by its rule, and the regate gives the real count.

The groups that stay in the hole round, with no tool row:

- `axis_` (1 declaration note, 6 reads): Raven's `vec3_t ... axis_[3] = {0,0,0, ...}` at cg_players.c:5996 is one site with a flat initializer. The drafter has no form for an initialized array of vectors, and one site does not pay for one.
- `oldG2Weapons` (1 declaration note, 4 reads): Raven's `void *oldG2Weapons[MAX_SABERS]` at cg_players.c:1510 is one site, an array of Ghoul2 handles. The transcriptor writes it as an `[OpaquePointer?]` local.
- `saber` (1 declaration note, 6 notes): Raven steps the configstring text with `saber++` at cg_players.c:7140 and :7152, so the R20 cast-store rule sees a step and leaves it. The transcriptor writes the tail of the String.
- `slash` in CG_NewClientInfo (cg_players.c:1508), CG_G2AnimEntModelLoad (:6879), and the second walk at :7011: each local points into two buffers, `v` and `newInfo.modelName` at :1623 and :1631, `GLAName` and `originalModelName` at :6916 and :6926. R27 takes one buffer per local, so these stay with the transcriptor.
- `skin` and `p` (2 declaration notes, the 2 `CharBuf != BinaryInteger` holes): Raven walks `p` with `COM_ParseExt(&p, qtrue)` over the `surfOff` and `surfOn` text at cg_players.c:566 and on. The transcriptor gives the TextCursor form of the game's parse sites.
- `Slots<vec3_t>` to `[vec3_t]` (10 holes): Raven passes `ent.axis` of a refEntity_t local to `AnglesToAxis` and `MatrixMultiply`, for example cg_players.c:3436 in the Swift. `AnglesToAxis` takes `inout [vec3_t]` at `Sources/JKAShared/q_math.swift:441`, and the view field is a Slots. No game or cgame file has a form for this shape yet, so no row is proved. The transcriptor writes each site, and the shape is an open row for the next stem that meets it.
- The 8 type-check timeouts: each is Raven's `M_PI` arithmetic, for example `angle = ((cg.time / 12) & 255) * (M_PI * 2) / 255`. The transcriptor splits the expression.
- The 5 `String?` unwraps: Raven reads `cg_customSoundNames[i]` and the other `[String?]` tables into a `const char *` parameter. The transcriptor adds the `!` where Raven's loop proved the entry.
- The 4 `ClientInfo?` unwraps: Raven's `memset(ci, 0, sizeof(*ci))`. The round 3 hole round wrote the npcClient memset as `clear()`, and the transcriptor reuses that form.
- The 2 `ClientInfo - Slots<ClientInfo>` holes: Raven's `clientNum = ci - cgs.clientinfo` at cg_players.c:878 and :999 in the Swift. The transcriptor reads the index from the view.
- The singletons, 1 or 2 notes each: `ambiguous use of 'M_PI'`, `Slots<Float>`, `PolyVert?`, `MarkFragment?`, the two `memcpy` of mark verts, the two `return NULL` of a `sfxHandle_t`, `PM_RunningAnim` and `BG_SiegeFindClassByName` out of scope, and the immutable `vec_origin`.

### R23. Two records of one view on one declaration line

- Raven: `oracle/codemp/cgame/cg_players.c:8437` declares `mdxaBone_t boltMatrix, lHandMatrix;` at the head of CG_Player. Every other `mdxaBone_t` local of the file, for example :2206, :3418, and :4372, declares one name, and those draft.
- Swift: `Sources/JKAMP_CGameLogic/cg_players.swift:6816` and :6819 carry "A local `mdxaBone_t boltMatrix` the table has no type for" and the same for `lHandMatrix`. Then 16 reads of `boltMatrix` and 14 reads of `lHandMatrix` in CG_Player, from :6793, are holes. The trap takes the view by value, `trap_G2API_GetBoltMatrix(..., _ matrix: JKAMP.MdxaBone, ...)` at `Sources/JKAMP_CGame/Generated/cg_syscalls.swift:1288`.
- What the drafter did: `record_local` at `tools/oracle-closure/draft_declarations.py:55` returns None when a declaration holds more than one variable, `if len(vars_) != 1: return None` at :65. So no scratch opens, and the declaration falls to the scalar path, which has no type for a record.
- The game form: `MdxaBone.scratch { boltMatrix in ... }` at `Sources/JKAMP_GameLogic/g_active.swift:836`, `g_turret_G2.swift:382`, and `NPC_AI_Sentry.swift:139`. The one game line with two records, `oracle/codemp/game/g_active.c:2680`, stands under `#if 0`.
- Rust: `jka-rust/crates/mp/cgame/src/cg_players.rs:10415` and :10418 declare the two matrices as two locals.
- The change: `record_local` returns every variable of the declaration when each one is a record with a view, and `statements` at `tools/oracle-closure/draft_statements.py:59` opens one scratch closure per variable, nested in Raven's order, `MdxaBone.scratch { boltMatrix in MdxaBone.scratch { lHandMatrix in ... } }`. The module is `draft_declarations.py` with `draft_statements.py`, the scratch rule "A scratch C struct on the stack".
- Sites: 32 notes in CG_Player, the 2 declarations and 30 reads. Other stems: `oracle/codemp/cgame/cg_predict.c:219`, `trace_t trace, oldTrace;`, takes the same form. No game draft moves.

### R24. A scalar array field passes as its Slots

- Raven: `oracle/codemp/cgame/cg_players.c` passes `cgs.gameModels`, the field `qhandle_t gameModels[MAX_MODELS]` of `oracle/codemp/cgame/cg_local.h:1584`, to `trap_G2API_GetBoltMatrix` 21 times, to `CG_G2SetBoneAngles` 4 times, and once each to `trap_G2API_SetBoneAngles` and `BG_AttachToRancor`. The engine reads the array of model handles.
- Swift: the view holds the field as a Slots, `public var gameModels: Slots<JKAShared.qhandle_t>` at `Sources/JKAMP_CGame/Generated/Views/Cgs.swift:368`. Each callee takes `modelList: Slots<qhandle_t>?`: `cg_syscalls.swift:1288` and :1382, `Sources/JKAMP_CGameLogic/cg_players.swift:2561`, and `Sources/JKAMP_BG/bg_g2_utils.swift:9`. The 27 sites carry "Swift holds one record here. A Slots over one record has no form yet", for example `cg_players.swift:1987` and :2604.
- What the drafter did: in `argument` of `tools/oracle-closure/draft_calls.py`, the arm at :386 passes a view field to a Slots parameter only when the field's element is a record with a view, `self.types.record_name(...element_type) in self.views.views`. `qhandle_t` is an `int`, so the arm misses, and the hole at :393 fires.
- The game and the hand form: the round 3 hole round wrote `trap_G2API_GetBoltMatrix(cent.ghoul2, 0, cent.bolt2, matrix, ..., cg.time, cgs.gameModels, &cent.modelScale)` at `Sources/JKAMP_CGameLogic/cg_event.swift:1935`. The game passes `nil`, `Sources/JKAMP_GameLogic/g_turret_G2.swift:388`. Commit a1cfe56 ruled the Slots form for the parameter.
- Rust: `jka-rust/crates/mp/cgame/src/cg_players.rs:1247`, `Some(&mut ctx.world.cgs.gameModels[0])`.
- The change: the arm at `draft_calls.py:386` also takes a constant array field of a scalar element when the parameter is the Slots of that scalar, so `cgs.gameModels` passes as written. The module is `draft_calls.py`, the Slots rule of commit a1cfe56.
- Sites: 27 notes in cg_players. Other stems: every cgame stem that passes `cgs.gameModels`, for example cg_weapons and cg_ents. No game draft moves, because the game passes NULL.

### R25. The `int *modelList` of the two bone traps is the Slots of model handles

- Raven: `oracle/codemp/cgame/cg_syscalls.c:874` and :880 declare `trap_G2API_GetBoneAnim` and `trap_G2API_GetBoneFrame` with `int *modelList`, not `qhandle_t *`. The engine reads it as the same model list, `G2API_GetBoneAnim(..., int *modelList)` at `oracle/codemp/ghoul2/G2_local.h:117`, reached from `oracle/codemp/client/cl_cgame.cpp:1391` and :1402. cg_players passes `cgs.gameModels`, in the Swift at `cg_players.swift:2129`, :2145, and :2792.
- Swift: the traps take `_ modelList: UnsafeMutablePointer<Int32>?` at `Sources/JKAMP_CGame/Generated/cg_syscalls.swift:1402` and :1421. The 3 compile holes are "cannot convert `UnsafeMutablePointer<Slots<qhandle_t>>` to `UnsafeMutablePointer<Int32>`".
- What the drafter did: `tools/oracle-closure/spelling.py:416` gives `Slots<qhandle_t>?` only when the pointee spells `qhandle_t`. The `int *` falls to the bare pointer.
- The game form: the game forwards the pointer in `Sources/JKAMP_GameLogic/g_strap.swift:32`, and every game caller passes NULL.
- Rust: the same `Some(&mut ctx.world.cgs.gameModels[0])` form as R24.
- The change: a PARAMS row of `tools/oracle-closure/rulings.py:314` names `("trap_G2API_GetBoneAnim", "modelList")` and `("trap_G2API_GetBoneFrame", "modelList")` as the model handle array, and `spelling.py:416` reads the row beside the `qhandle_t` test, the same way R21 gave a `vec3_const` row. `qhandle_t` is an `int`, so the element does not change.
- Sites: 3 compile holes in cg_players. The generated trap files move, `Sources/JKAMP_CGame/Generated/cg_syscalls.swift`, `Sources/JKAMP_Game/Generated/g_syscalls.swift`, and `Sources/JKAMP_BG/Generated/bg_strap.swift`. The hand forwards `Sources/JKAMP_GameLogic/g_strap.swift:32` and `Sources/JKAMP_CGameLogic/cg_strap.swift` take the new signature by hand, as commit a1cfe56 did.

### R26. A bg name the cgame names is public

- Raven: `oracle/codemp/cgame/cg_players.c:1925`, :1926, and :8964 call `BG_SI_SetDesiredLength`. The file also calls `BG_SI_SetLength` and `BG_SI_SetLengthGradual`, and reads `bgToggleableSurfaceDebris` at :7285 to :7325, :7488, and :8067. The table is `const int bgToggleableSurfaceDebris[BG_NUM_TOGGLEABLE_SURFACES]` at `oracle/codemp/game/bg_misc.c:78`. No game file names these four, so the game unit's public rule never reached them.
- Swift: `Sources/JKAMP_BG/bg_saberLoad.swift:2381`, :2393, and :2412 declare the three functions without `public`. The table has no Swift declaration: `Sources/JKAMP_BG/bg_misc.swift` is adopted and holds `bgToggleableSurfaces` at :7 and `forceMasteryPoints` at :21, but not the debris table. The 32 notes are "cannot find ... in scope".
- What the tool did: `collect_game_calls` at `tools/oracle-closure/skeleton.py:996` walks only the files of the run's own logic target, `target_of(stem) != LOGIC` at :1005. A game run holds the cgame parse as `self.cgame_tu`, :263, and the walk does not read it. A cgame run holds no bg functions in `self.files`, so its walk finds no bg name.
- The game form: a bg function the game calls takes `public` by the same rule, for example `public func WP_SaberParseParms` at `bg_saberLoad.swift:467`. A bg data table is a `let` with a Source line, `forceMasteryPoints` at `bg_misc.swift:21`.
- Rust: `jka-rust/crates/mp/cgame/src/cg_players.rs:27` imports `BG_SI_SetDesiredLength, BG_SI_SetLength, BG_SI_SetLengthGradual`. The table is `pub static bgToggleableSurfaceDebris: [c_int; 31]` at `jka-rust/crates/mp/bg/src/local/bg_toggleable_surfaces.rs:62`.
- The change: `collect_game_calls` also walks the functions of `self.cgame_tu` whose file lies in the cgame folder, so `skeleton.py --publish` puts `public` on each bg name either module names. The adopted `bg_misc.swift` takes `public let bgToggleableSurfaceDebris: [Int32]` by hand at Raven's line, with its Source line, because `--publish` reports a name with no declaration line and adds none. The module is `skeleton.py`, the public rule.
- Sites: 32 notes in cg_players, 26 and 2 and 2 of the three functions and 2 of the table. Other stems: every cgame stem that calls a bg function the game does not call. The publish run moves only `public` keywords in `Sources/JKAMP_BG`. No game draft moves.

### R27. A text table element is a text store

- Raven: `oracle/codemp/cgame/cg_players.c:808` declares `const char *s`, and :873, :913, and :957 store `s = cg_customSoundNames[i]`, `bg_customSiegeSoundNames[i]`, and `cg_customDuelSoundNames[i]`. :7272 declares `const char *surfName = NULL`, and :7276 stores `surfName = bgToggleableSurfaces[surfNum]`.
- Swift: the tables are text arrays, `var cg_customSoundNames: [String?]` at `Sources/JKAMP_CGameLogic/cg_players.swift:15` and `public var bgToggleableSurfaces: [String]` at `Sources/JKAMP_BG/bg_misc.swift:7`. The locals carry "A pointer local `const char * s` with no view" at `cg_players.swift:686` and the same for `surfName` at :5924, then the store and read notes, for example :745 and :5929.
- What the drafter did: `text_store_kind` at `tools/oracle-closure/draft_classification.py:284` knows a String call, a literal, a `char name[N]` field, and a char buffer. An element of a file-scope text table is "other", so `text_local_names` at :216 drops the local.
- The game form: `let s = cg_customSoundNames[i]` is the shape the cg_main and g_client tables already read, a `String?` element bound before its use.
- Rust: `jka-rust/crates/mp/cgame/src/cg_players.rs:845`, `let s = match cg_customSoundNames[i] { ... }`.
- The change: `text_store_kind` gives "text" for an array subscript over a file-scope table whose Swift type is `[String]`, and "optional" for `[String?]`, so the local drafts as the String or the `String?` of R20. The module is `draft_classification.py`, the text-local rule of R20.
- Sites: 13 notes in cg_players, `s` with its declaration, 3 stores, and 6 reads, and `surfName` with its declaration and 2 notes. Raven's `s+1` at :876 reads past the first byte, and the regate shows whether the tail form drafts. If it does not, the transcriptor writes it. Other stems: any cgame or game local that reads one of the text tables. The snapshot shows which game draft moves, if any.

### R28. A `char *` local from `Q_strrchr` or `strchr` of one buffer is an optional offset

- Raven: CG_RegisterClientModelname stores `slash = Q_strrchr( afilename, '/' )` at `oracle/codemp/cgame/cg_players.c:521`, then `strcpy(slash, "/animation.cfg")`. CG_G2SkelForModel at :758 does the same over `GLAName`. CG_G2EvIndexForModel at :785 stores the same, then `slash++` and `*slash = 0` at :788 and :789. Each local points into one local char buffer.
- Swift: `Q_strrchr` returns `Int32?`, a byte offset into its argument, at `Sources/JKAShared/q_shared.c.swift:679`, by the `text_offset` kind of `tools/oracle-closure/rulings.py:280`. `strchr` has the same shape at `Sources/JKAShared/CString.swift:405`. `strcpy(_:_:at:)` writes at an offset, `CString.swift:177`. The locals carry "A pointer local `char * slash` with no view" at `cg_players.swift:337`, :634, and :656, then the store and read notes at :431, :434, :641, :644, :667, and :670.
- What the tool did: `cursor_store` at `tools/oracle-closure/table.py:1236` takes only `p = buf`, `p = buf + offset`, and NULL. A store of a `text_offset` call gives None, and `cursor_buffers` at :1228 drops the local, so it has no cursor row.
- The game form: `if let slash = Q_strrchr(String(GLAName), Int32(ascii: "/")) { strcpy(&GLAName, "/animation.cfg", at: slash) ... }` at `Sources/JKAMP_GameLogic/g_client.swift:1692` and `Sources/JKAMP_GameLogic/NPC_spawn.swift:1665`.
- Rust: `jka-rust/crates/mp/cgame/src/cg_players.rs:693` and :727, `if let Some(slash) = GLAName.rfind('/')`.
- The change: `cursor_store` takes a call of a `text_offset` function whose first argument is a named char buffer as a store into that buffer, and the cursor row marks the local optional. The draft gives the game form: `if (slash)` binds with `if let`, a write through the local is a write at the offset, and `slash++` steps the bound offset. The modules are `table.py`, the cursor sweep of row 47, and the write-cursor spelling of `draft_classification.py`.
- Sites: 9 notes in cg_players, the 3 declarations and their 6 notes. The locals with two buffers stay in the hole round, see the head of this docket. Other stems: any cgame or game `char *` local over `Q_strrchr` or `strchr` of one buffer. g_client and NPC_spawn hold the form by hand, so their drafts move toward their hand files. The snapshot gives the count.

### R29. A Slots local with a NULL initializer

- Raven: CG_PlayerAnimEvents declares `animevent_t *animEvents = NULL;` at `oracle/codemp/cgame/cg_players.c:2466`, then stores `bgAllEvents[eventFileIndex].torsoAnimEvents` or `.legsAnimEvents` in the two arms at :2470 and :2474. Then the body indexes `animEvents[i]`.
- Swift: the local drafts as one record, `var animEvents: Animevent? = nil` at `Sources/JKAMP_CGameLogic/cg_players.swift:2028`. The 2 compile holes are "cannot assign `Slots<Animevent>` to `Animevent`" at :2032 and :2036. The 4 walk notes are "Raven walks `animEvents[i]` as an array", at :2096, :2101, :2105, and :2110.
- What the drafter did: `slots_local_names` at `tools/oracle-closure/draft_classification.py:897` takes a local only when every store is a table, `all(kinds)`. `table_expression` at :936 gives False for NULL, so the NULL initializer drops the local to the one-record form.
- The game form: the Slots local form of `draft_declarations.py:435`, `var name: Slots<view>`, as the anim table reads in bg_panimate.
- Rust: this docket does not cite a Rust line for this row. The transcriptor checks `CG_PlayerAnimEvents` in `jka-rust/crates/mp/cgame/src/cg_players.rs`.
- The change: `slots_local_names` treats a NULL store as no store, and the declaration drops its NULL when every path stores a table before the first read, the same test `slot_store_place` gives a plain entity. The local then drafts as `var animEvents: Slots<Animevent>`. The module is `draft_classification.py`, the Slots local rule.
- Sites: 6 notes in cg_players. Other stems: a local `T *x = NULL` filled from a record table. The snapshot shows which game draft moves, if any.

## The ledger

The user delegated the rows to the coordinator on 2026-11-02 with "check each of these and ratify as you see fit". The coordinator read every cited line in the oracle, the Swift, the tools, the game, and the Rust reference before each ruling.

- R23. Ratified as proposed, 2026-11-02. The one-line, two-record declaration opens one nested scratch per record.
- R24. Ratified as proposed, 2026-11-02. A constant array field of a scalar passes as its Slots when the parameter is that Slots.
- R25. Ratified as proposed, 2026-11-02. A PARAMS row for the two `int *modelList` parameters, in the R21 form.
- R26. Ratified as proposed, 2026-11-02. `collect_game_calls` also walks the cgame parse, and `bg_misc.swift` takes the debris table by hand.
- R27. Ratified as proposed, 2026-11-02. An element of a file-scope text table is a text store. The `s+1` tail goes to the transcriptor if it does not draft.
- R28. Ratified as proposed, 2026-11-02. A `text_offset` call over one named buffer is a cursor store, and the local is an optional offset.
- R29. Ratified as proposed, 2026-11-02. A NULL initializer is no store for the Slots local test.
