# Phase 3, group 2: the generators and the drafter

This record holds group 2 of phase 3 of the rulings build, the items of `notes/2026-10-11/phase-2-walk.md`, section "Generators and drafter in tools/oracle-closure". The tree is `wave-0` on 9bde0cb with the changes below, uncommitted. A line number is the line in the changed tree. A tool path is under `tools/oracle-closure/`.

The draft counts of the drafter rules come from two snapshots of every generator text, `snapshot.py --out` before the first change and after the last change, both on this tree. Between the two, 46 files moved: 34 body files, 3 manifest files, 6 skeleton files, 1 trap file, and 2 view files.

## V34. An integral `float` literal stored into an `int`

`spelling.py:481-487`, in `Types.crossing`: a `float` literal with an integral value that a store puts into an `Int32` is the integer text, so `client!.ps.gravity = Int32(1.0)` reads `client!.ps.gravity = 1`. A literal with a fraction keeps `Int32({text})`. The value comes from the new `Facts.literal_text` field at `spelling.py:96`, which `Expressions.literal_text` at `draft_expressions.py:210-214` fills with Raven's digits, `1.0f` or `-500.0f`.

Draft count: 7 of the 9 sites of the V34 proof change, `FighterNPC` `gravity = -500`, `500`, and `500`, `g_items` `g2radius = 30`, `g_active` `gravity = 1` twice, and `g_misc` `var add: Int32 = 0`. The two `hackingTime = 0.0f` sites of `FighterNPC.c:789` and `:797` sit inside a statement that the draft keeps as a hole, so they change by hand in group 4.

## V35 and W14. Slot-address locals with no initializer

`draft_declarations.py:410` and `:414`: drafter rule 2 takes `gclient_t` beside `gentity_t`, for a local with an initializer and for a local with none. `slot_address` at `:444-458` also takes `&level.clients[i]`, the subscript of a pointer field with a `<name>Slots` accessor, through `slots_member`.

`slot_store_place` at `:483-526` gives the keyword of a local with no initializer whose every store is a slot address:

- `let` or `var`: every store is a statement of the function's top block, the first store comes before every read, and no scratch closure opens before the first store. One store gives `let`, more give `var`. The declaration reads `let ent: Entity`.
- `closure`: the one store and every read are inside one loop body, a record local of that body opens its scratch closure before the store, and the store comes before every read. The top declaration drops, and the store reads `let client = level.clientsSlots[i]` through `store_lets` at `draft_statements.py:564-566` and `bodies.py:169` and `:246`.
- A store that the draft cannot write keeps the local optional, because the reads would then come before any store.

`slot_refs` at `:460-472` and `slot_parent` at `:474-481` hold the parent walk that `plain_entity` used, and `plain_entity` at `:528` takes `None` for a local with no initializer. A wrapper node with the extent and kind of its child keys the same as the child, so `slot_refs` gives the child the wrapper's parent, and the walk up ends. Without that test the walk loops on such a pair, which the wider rule reaches.

Draft count: 7 locals in 7 functions become plain, `Rancor_Crush` `let crush: Entity`, `BotAI_GetClientState` and `BotAI_GetEntityState` `let ent: Entity`, `G_AddBot` `let bot: Entity`, `ClientConnect` and `G_EntIsBreakable` `let ent: Entity`, and `WP_FireEmplaced` `let gun: Entity`, and their reads drop the `!`. One local takes the `closure` form: the `var client: Client?` of `Pickup_Powerup` drops. No local with an initializer changes.

The two proof sites do not change in the draft:

- `SortRanks`: the stores `ca = &level.clients[*(int *)a]` and `cb = ...` are holes of the draft, "A pointer dereference the draft cannot place", so `ca` and `cb` stay `Client?`. The site changes by hand in group 4, as the V35 ruling allows.
- `Pickup_Powerup`: the whole loop is a hole of the draft, "Raven's block leaves a loop outside the record's scope, and the closure cannot", because Raven's `continue` leaves the scratch closure. The top declaration drops, and the loop body changes by hand in group 4.

## V37. Raven's comment after a `case` or `default` label

`draft_statements.py:1026-1047` keeps the comment of each label beside the label, and `label_comment` at `:1107-1113` reads the text after the label's colon on its line. `:1058-1067` writes the arm head: one label keeps its comment through the `TRAILING` mark, `case SHIPSURF_FRONT: //break the nose off`. An arm that joins labels writes one label per line when any label carries a comment, with the comment after its comma, each continuation five spaces past the arm's indent. A `default` arm that takes other labels writes `default:` with the first comment of its labels.

Draft count: 273 arm heads change in 21 body files, and they keep 642 of Raven's comments. Raven's game files hold 663 label lines with a comment, the upper bound of the V37 proof. 15 of the changed heads are `default` arms.

## W1. The `vmMain` entry of `NOT_PORTED`

`rulings.py:272`: `"vmMain": "the shell's vmMain in Sources/jampgame/jampgame.swift decodes the command words and calls the bare functions, under rule 11 and ruling F5"`. The skeleton text of `g_main` now gives the stub of the W1 proof. `g_main.swift` is adopted, so its function at `:545-787` stays for group 4.

## W6. `fatalErrorPointer` is `Int32?`

`rulings.py:165-167`: the `TYPES` entry after the A2 entry, with its two-line comment. `skeleton.py` regenerates `Sources/JKAMP_Game/Generated/Storage/GameVariables.swift:531` as `public var fatalErrorPointer: Int32? = nil`, 1 line. The hand accessor at `Sources/JKAMP_GameLogic/g_nav.swift:74` reads `var fatalErrorPointer: Int32? {`, the text of `skeleton.py --only g_nav`, because the build needs the type. The four holes stay for group 4.

The draft of `NAV_CalculatePaths` writes `fatalErrorPointer = fatalErrorString[0]` for Raven's `fatalErrorPointer = &fatalErrorString[0]`. That line compiles and stores the first byte, not the offset 0. The W6 ruling gives `fatalErrorPointer = 0`, so group 4 writes that line by hand.

## W9. A scalar `vec4_t` global

`skeleton.py:550-554`: a global whose type is the typedef `vec4_t` is `JKAShared.vec4_t`, beside the `vec3_t` branch. `skeleton.py:718-719`: the zero writer gives `vec4_t()`. `GameVariables.swift:275`, `:279`, and `:283` read `public var textcolor_caption: JKAShared.vec4_t = vec4_t()` and the same for `textcolor_center` and `textcolor_scroll`, 3 lines. The hand accessors at `Sources/JKAMP_GameLogic/g_ICARUScb.swift:19`, `:25`, and `:31` take `JKAShared.vec4_t`, the text of `skeleton.py --only g_ICARUScb`, because the build needs the type. The three holes stay for group 4.

The same rule gives the 13 `vec4_t` globals of `q_math.c`, `colorBlack` to `colorDkBlue`, the type `JKAShared.vec4_t` in the skeleton text. `Sources/JKAShared/q_math.swift` is a hand file, so no Sources line moves.

## W10. `BG_TempAlloc` in `CHARBUF_ALLOCS`

`rulings.py:206-208`: `CHARBUF_ALLOCS = {"B_TempAlloc", "BG_TempAlloc"}`, with the comment line that names the `saberName` locals of `NPC_ParseParms` and the `tempReadBuffer` locals of `bg_vehicleLoad`.

The draft of `bg_vehicleLoad` from `bodies.py --stem bg_vehicleLoad` changes in the two `tempReadBuffer` functions alone for this rule: `var tempReadBuffer = CharBuf(MAX_VEH_WEAPON_DATA_SIZE)` and `CharBuf(MAX_VEHICLE_DATA_SIZE)`, `_ = BG_TempAlloc(...)`, `trap_FS_Read(&tempReadBuffer, len, f)`, and `tempReadBuffer[len] = 0`, 4 lines in each function. The draft keeps Raven's macro as the size, not its integer value. The other changes of that draft are the V37 heads. `draftcheck.py --stem bg_vehicleLoad` gives 0 holes, 0 defects, and 0 compile holes. The stem is adopted, so the gate writes no line of `Sources/JKAMP_BG/bg_vehicleLoad.swift`, and the file keeps the `UnsafeMutableRawPointer` form at `:792` and `:867`.

The draft of `NPC_ParseParms` gives the `saber` and `saber2` arms of the W10 proof: `var saberName = CharBuf(4096)`, `strcpy(&saberName, value)`, and `WP_SaberParseParms(String(saberName), NPC.client!.saber[0])` and `[1]`.

## W12. `SiegeItemRemoveOwner` takes an optional carrier

`rulings.py:340-341`: the `NULLABLE` row `("SiegeItemRemoveOwner", "carrier")` with its comment line. The signature row reads `func SiegeItemRemoveOwner(_ ent: Entity, _ carrier: Entity?)`, and the draft restores `if carrier != nil {` with `carrier!` reads. `g_saga.swift` is adopted, so its body and the hole stay for group 4.

## W19. The trap template encodes through `withCString(_:_:)`

`traps.py:168-170`: a `const char *` parameter, optional or not, wraps the call in `withCString({name}) {{ {name} in`, the function of `Sources/JKAShared/CString.swift:482`, which encodes through `CharBuf(_ string:)`. `traps.py:282`: the text overload reads `withCString({text.name}) {{ base in`. The template emits no `String.withCString` and no `String(cString:)`.

`traps.py` regenerates `Sources/JKAMP_Game/Generated/g_syscalls.swift`: 98 lines change, and each one is an encode line, `buffer.withCString { buffer in` to `withCString(buffer) { buffer in`. No other line moves. The 16 decode sites already read `String(nulTerminated:)`, which decodes through `CharBuf`, so they do not change.

`draft_statements.py:486-488`: a `String` return of a raw allocation reads `return cString(at: {expr})`. The draft changes at 2 sites, `return cString(at: newb)` and `return cString(at: dest)`. The hand line `Sources/JKAMP_GameLogic/g_spawn.swift:231` still reads `String(cString: newb.assumingMemoryBound(to: CChar.self))`.

## W33. `lookup.py --help` and `skeleton.py --signatures`

`lookup.py:157-159`: `-h` or `--help` prints the docstring and exits 0. `skeleton.py:1405`: the `--signatures` flag saves the signature rows from the stubs on disk and writes no file, and `:1418-1420` prints the row count. `save_signatures` at `:1266` returns the count. The docstring at `:31` names the flag.

## V23. The row accessors come out of `views.py`

`views.py:279`: the `CONSTANTARRAY` branch returns the one `Slots` accessor, and the `row_buffers` method is gone, which is the text before generator item 5 of phase 1. `views.py` regenerates `Sources/JKAMP_Game/Generated/Views/Parms.swift` and `Level.swift`, and each loses the 5 lines of its accessor, `parmBuffers` and `teamVoteStringBuffers`. No other view file moves.

The H3 site of `Q3_SetParm` at `Sources/JKAMP_GameLogic/g_ICARUScb.swift:3197-3212` takes Raven's form in the same step. The `Com_sprintf` arm writes into `var buf = CharBuf(MAX_PARM_STRING_LENGTH)` and stores `ent!.parms!.parm[parmNum] = String(buf)`. The `strncpy` arm writes into its own `buf`, runs the truncation test on `buf[MAX_PARM_STRING_LENGTH - 1]`, and stores after the test. The warning prints `buf`, because the `Slots<String>` setter keeps at most 63 bytes, so the field cannot show the untruncated byte to the test. The R4 site at `g_cmds.swift:2243-2250` stays.

`rosetta.py` ran once. `lookup.py` shows the five `vec3_t` retypes, `gNPC_t enemyLaggedPos`, `Vehicle_t m_vMuzzlePos` and `m_vMuzzleDir`, and `saberTrail_t oldPos` and `oldNormal`, each `Slots<JKAShared.vec3_t>`. `lookup.py parms_t parmBuffers` and `level_locals_t teamVoteStringBuffers` answer "has no field", and no stone names a `Buffers` accessor. The run also writes 17 stones that the views already had, `T_G_ICARUS_GETFLOAT` to `T_G_ICARUS_USE`, with their rows in `index.md`.

## Open point 2. `atof` and `memset`

`rulings.py:271`: the `NOT_PORTED` entry `"atof": "the VM's, which computes in float, and the DLL build links the C library's `atof`, which `JKAShared` holds"`, the text of `Sources/JKAMP_BG/bg_lib.swift:197-199`. The skeleton text of `bg_lib` now gives that stub.

The `memset` change to `overlay.py:63` is blocked. `UNDEFINED` holds the names of the SDK's fortify macros that the C parse must not expand, and it does not name Swift functions. With `memset` out of the tuple, the parse sees `__builtin___memset_chk`, and the draft of `g_client` breaks at 3 sites, for example `client.clear()` becomes `__builtin___memset_chk(client, , ...)`, and one more hole. The change is reverted, and `overlay.py` is as it was.

## Blocked items

- The `memset` half of open point 2, as above.

## Gate

The gate ran in one call: `swift build`, `swift test --no-parallel`, and `tools/load-test.sh`.

- `swift build`: 0 errors, "Build complete!".
- `swift test --no-parallel`: 112 tests in four binaries, 84, 14, 13, and 1, all passed.
- `tools/load-test.sh`: exit 0. The server loaded `mp/ffa1`, ran `InitGame`, and shut down with `ShutdownGame`.

The tool tests, `.venv/bin/python -m unittest discover -s tests`, ran 78 tests, OK, with 16 skipped.

## V28. Skeleton and manifest

- `skeleton.py`: 1 file written, `Callbacks.swift` with no change, 215 thunks in 7 namespaces, and every stub file adopted. The storage file is the `GameVariables.swift` of W6 and W9.
- `manifest.py`: 88 manifests, 2628 functions, 2539 with a jka-rust match. 35 manifest files moved.
- `skeleton.py --signatures`: 3153 signature rows saved from the stubs on disk. `lookup.py sig G_Find` then prints no stale warning.

## V26. Draftcheck and the snapshot

`draftcheck.py` ran as five `--stem` calls of 15 game stems each, 75 stems:

| Call | Stems | Holes | Cascade errors | Defects | Compile holes | Passes |
|---|---|---|---|---|---|---|
| 1 | `ai_main` to `g_log` | 266 | 0 | 0 | 1 | 2 |
| 2 | `g_main` to `g_team` | 147 | 0 | 0 | 4 | 2 |
| 3 | `g_timer` to `NPC_AI_Howler` | 131 | 0 | 0 | 1 | 2 |
| 4 | `NPC_AI_ImperialProbe` to `NPC_behavior` | 64 | 0 | 0 | 0 | 1 |
| 5 | `NPC_combat` to `WalkerNPC` | 417 | 0 | 0 | 0 | 1 |
| Total | 75 | 1025 | 0 | 0 | 6 | |

The reference of the plan is 1357 holes, 0 defects, and 224 compile holes. The holes and the compile holes are lower, and the defects agree. The six compile holes are `g_client` `trap_G2API_SetBoneAnim(...)` in `SP_info_player_duel`, "variable 'aFlags' used before being initialized", the three `fatalErrorPointer` statements of `NAV_WaypointsTooFar` and `if ( !tempWaypointList )` of `g_nav`, and `if ( point )` of `NPC_AI_GalakMech`.

`snapshot.py --check $HOME/.cache/jka-swift/snapshot-stage-two-shared` exits 1 with "370 files, a difference". 153 files moved: 46 body files, 67 manifest files, 19 skeleton files, 1 trap file, and 20 view files. The snapshot was taken at c82143f, before the waves of phase 2 and group 1 of phase 3, so the check is stale, and it is not refreshed. The 46 files that this group moves are the count of the before and after snapshots at the top of this record.

## For the review leg and group 4

- `SortRanks` and `Pickup_Powerup` change by hand, because the draft holds their stores or their loop as holes.
- The two `hackingTime` sites of V34 change by hand.
- `g_spawn.swift:231` still reads `String(cString:)`.
- The `NAV_CalculatePaths` draft line `fatalErrorPointer = fatalErrorString[0]` compiles with the wrong value.
- The W10 draft of `bg_vehicleLoad` is not in the tree, because the stem is adopted.
