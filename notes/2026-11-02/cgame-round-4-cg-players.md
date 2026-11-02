# The cgame transcription rounds, round 4, cg_players

The record of the fourth cgame transcription round on 2026-11-02, one stem, `cg_players`, on the branch `cgame-round-4-cg-players` off master `0223db5`.

## The first adoption

Draft gate of the stem: 85 of 85 replaced, 236 holes, 0 cascade errors, 0 defects, 89 compile holes over 19 passes. Adopted at e31f30d with 236 Port-notes. The same commit names the shared cache in the usage text of `snapshot.py`. The docket at 677c60d holds rows R23 to R29 and the groups that stay with the transcriptor.

## Rows R23 to R29

Ruled by the coordinator under the user's delegation on 2026-11-02, each proved at its lines in the oracle, the Swift, the tools, the game, and the Rust reference before the change. Each row commit gives the cg_players gate over the adopted file of e31f30d.

- R23. A declaration of two records with a view, `mdxaBone_t boltMatrix, lHandMatrix;` at cg_players.c:8437, opens one scratch closure per record, nested in Raven's order. Gate 210 holes, 89 compile holes. Commit e0d86e0.
- R24. A view field that holds an array of scalars, `cgs.gameModels`, passes as written to a parameter that takes the Slots of that scalar. Gate 134 holes, 46 compile holes. Commit 0f01753.
- R25. A PARAMS kind `model_list` gives the `int *modelList` of the bone traps the `Slots<qhandle_t>?` form of a `qhandle_t *`. The docket named two traps, `trap_G2API_GetBoneAnim` and `trap_G2API_GetBoneFrame`, and the change needed a third row for `strap_G2API_GetBoneAnim` in bg. The hand forwards in g_strap.swift and cg_strap.swift take the new signature. Gate 126 holes, 37 compile holes. Commit b9c6156.
- R26. The public rule of `skeleton.py` also walks the cgame function bodies of the cgame parse, so `--publish` gave 12 bg declarations `public`. bg_misc.swift takes `bgToggleableSurfaceDebris` by hand at Raven's line. Gate 118 holes, 30 compile holes. Commit 16f7a08.
- R27. A store of an element of a file-scope text table, `s = cg_customSoundNames[i]`, is a text store, so the local drafts as the String of a `[String]` table or the `String?` of a `[String?]` table. Raven's `s+1` tail at cg_players.c:876 does not draft, and the hole round wrote it. Gate 108 holes, 33 compile holes. Commit 25e15d8.
- R28. A `char *` local stored from `Q_strrchr` or `strchr` of one named buffer is a write cursor with an `Int32?` offset, and Raven's NULL test binds it with `if let`, or `if var` when the arm steps it. Gate 100 holes, 34 compile holes. Commit 3bf6bc4.
- R29. A NULL initializer of a record pointer local is no store for the Slots local test, and the declaration drops it, so `animEvents` drafts as `var animEvents: Slots<Animevent>`. The row took two more classification changes than the docket named. One of them makes a record array field of a view, `bgAllEvents[n].torsoAnimEvents`, a table that reads as its Slots. Gate 89 holes, 22 compile holes. Commit aee6175.

The per-row gates over the adopted file of e31f30d ended at 89 holes. The same tools over the stub of master gave 118 Port-notes, so the base file changes the draft. The cg_players stub of master was readopted at 8a5c03f with 118 Port-notes, and 118 is the count the hole round starts from. The cause of the difference is not known and is an open row. The build and the tests pass at the readoption.

R28 moves the ai_main draft of BotAI to an optional offset, but it spells Raven's `if (!args) continue` as a nil comparison and then passes `args` unbound. That is one compile hole in a game gate, and no landed code changes. The negated null test as a guard bind is open row R30.

The snapshot against the cache of master moves g_client, NPC_spawn, ai_main, g_combat, the bg `public` keywords, the straps, and the bg_misc table.

## The hole round

Commit c5870b6 closed 98 of the 118 notes. It added one note, at CG_PlayerAnimEventDo, so 21 Port-notes remain, and each one has no guide form. The build and the 113 tests of `swift test --no-parallel` pass.

The shapes: CG_CustomSound reads the first byte of `soundName` through a CharBuf bind, returns 0 where Raven returns NULL, and force-unwraps each `[String?]` sound name that Raven's count loop proved. CG_RegisterClientModelname walks `surfOff` and `surfOn` with a TextCursor and `COM_ParseExt`. CG_LoadCISounds passes the tail of the String for Raven's `s+1`. CG_NewClientInfo holds `oldG2Weapons` as an `[OpaquePointer?]` local, clears the record through the view's `clear()`, holds `slash` as the optional offset of `strchr` over each of its two buffers, and spells `*ci = newInfo` as `copy(from:)`. CG_CreateSaberMarks copies the mark verts record by record in the cg_marks form. CG_G2AnimEntModelLoad holds `saber` as a String and steps past the `@` with its tail. CG_AddSaberBlade declares `axis_` as a local array of three zero vectors. CG_G2TraceCollide passes `G2Trace[0]` to the collision traps in the w_saber form. CG_Player splits each `M_PI` expression into typed terms. Nine `AnglesToAxis` calls over a view's `axis` fill a local array of the three vectors and store the copy back, under one comment each, for example cg_players.swift:3633.

The 21 notes left, by line in `Sources/JKAMP_CGameLogic/cg_players.swift`:

- Six `memcpy` of scalar sound arrays: CG_CopyClientInfoModel at :1137, :1140, and :1143, and CG_ScanForExistingClientInfo at :1207, :1210, and :1213.
- Two `clientNum = ci - cgs.clientinfo` in CG_LoadClientInfo at :889 and :1010. The index form would trap on a local record.
- Three notes in CG_HandleAppendedSkin at :5844, :5851, and :5855. Raven's `p` writes a NUL into the String parameter `modelName`.
- `colorOverride` as `Slots<Float>` into the `inout vec3_t` of `BG_ValidateSkinForTeam`, at :390 in CG_RegisterClientModelname and :1622 in CG_NewClientInfo.
- Two `memset` sized by a pointer in CG_ParseSurfsFile at :304 and :307.
- `MatrixMultiply` over a Slots in CG_GetTagWorldPosition at :4634.
- A rule 11 pointer store into `m_vOrientation` in CG_G2AnimEntModelLoad at :6012.
- `++iter` inside an `if` test in CG_ForceElectrocution at :6606.
- `RARMBIT` and its siblings generated as `Int` against the `Int32` field `torsoBolt` in CG_Player at :7449.
- A `memset` of `pe.torso` sized by the sibling field `pe.legs` in CG_ResetPlayerEntity at :9495.
- A NUL write into the bytes of `stringData` in CG_PlayerAnimEventDo at :2107.

## The rows left open

- The gate base. The per-row gates over the adopted file gave 89 holes, and the same tools over the stub of master gave 118. The cause is not known.
- R30. Raven's negated null test, `if (!args) continue`, drafts as a nil comparison and leaves the local unbound. The ai_main draft of BotAI shows it after R28. A guard bind is the proposed form.
- `AnglesToAxis` and `MatrixMultiply` take `inout [vec3_t]`, and a view holds `axis` as a `Slots<vec3_t>`. No file has a form for this shape. The nine copy-and-store-back sites and the note at cg_players.swift:4634 hold it by hand.
- The static buffer a function returns, cg_event.c:46, took a local CharBuf by hand. The guide's static ring row, `docs/transcription.md:109`, is the drafter's form for the same shape, and the drafter did not reach this site.
- R17 and R18 of the round 2 record stay open.
