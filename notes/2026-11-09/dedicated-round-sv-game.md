# The sv_game and sv_client round

This record holds the round of the two server stems of unit mp-engine-ded that face the game module: `Sources/JKAMP_DedLogic/sv_game.swift` and `Sources/JKAMP_DedLogic/sv_client.swift`. The tree is the worktree `/tmp/jka-ded-svgame` on the branch `dedicated-round-sv-game`, off master at 1cdd22f, with master at 5c71cb9 merged in after PR 77 landed, because that merge brings the forms of the sv core round and the new vm.swift. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The two stubs had the skeleton header, so the round adopted them and removed the header in the code commit. A first draftcheck run over the two stems gave 73 holes, 37 of them compile holes, and the drafts went into the two files over the stubs. The hole round then filled every hole that a ruled form, an adopted stem, or a hand accessor of this round covers.

- sv_game, 27 of 27 functions with a body. The drafter made the whole syscall switch one compile hole, because Raven's labels `CG_PRECISIONTIMER_START` and `CG_PRECISIONTIMER_END` are cgame names, so the round wrote SV_GameSystemCalls by hand from Raven's text. It holds all 327 of Raven's live labels. Raven's three labels inside comments stay as his comment text.
- The switch reads the module's words as the module sends them. `jka_host.c` gathers 16 `intptr_t` words, and the game's `SyscallWord` encoding puts an `int` sign-extended into a word, a pointer whole, and a float as `PASSFLOAT` bits in the low half. `args[i]` reads the low `int` of word `i`, `args.VMA(i)` reads the whole word as the type the call site wants, and `args.VMF(i)` reads the low half as float bits.
- An arm whose callee fills a `char *` buffer of the module fills a `CharBuf` of the size Raven passes, then copies the text and its NUL into the module's bytes with the `Com_Memcpy(Slots<byte>, CharBuf, count)` overload, under one rule 24 line. FS_GetFileList copies the whole buffer, because the list holds NUL separators.
- An arm whose callee writes a vector or an `int` of the module, AngleVectors, PerpendicularVector, FS_FOpenFileByMode, and the two VM_Shifted calls, passes the slot of a `Slots` at the word with `&`.
- SV_NumForGentity, SV_GentityNum, and SV_GameClientNum index the Slots of the stride the game gave. SV_GEntityForSvEntity takes `sv.svEntities.index(of:)`. SV_GameSendServerCommand and SV_GameDropClient take `svs.clientsSlots[clientNum]`. SV_GetEntityToken hands COM_Parse the cursor accessor of the field. FloatAsInt reads `bitPattern`. ConvertedEntity copies each pointer field, because VM_ArgPtr gives the same address for a module library. SV_InitGameProgs reads the global `bot_enable` of sv_bot.swift, where the draft had declared a local.
- sv_client, 24 of 24 functions with a body. SV_DirectConnect is hand work: the `client_t temp` is the closure of `Client.scratch`, and Raven's `goto gotnewcl` is the slot search under `if !reconnect`, with a Port-note that names the label. `*newcl = temp` is `copy(from:)`. SV_GetChallenge and SV_DropClient walk `challenge_t *challenge` as a `Slots<Challenge>` with `suffix(from: 1)`, the walk form of the sv core round. SV_WriteDownloadToClient lifts the store of `cl->downloadSize` out of Raven's `||` test onto the arm where it runs, and `while (blockspersnap--)` is `while true` with the test as a break. `ucmds` is a private table of `UcmdRow` values in Raven's order, the form of `spawns`, and the walk is the index `uIndex`.

The two drafted `Unsafe` lines of SV_GentityNum and SV_GameClientNum are gone, and `grep Unsafe` gives 0 in both stems.

## The rule 24 sites

- SV_GameSystemCalls (sv_game.cpp:458): the VMA and VMF macros are methods of `args`, one line at the top of the switch.
- TRAP_MEMSET and TRAP_MEMCPY (:464, :467): the `CUnsignedLong` conversion of the count.
- The buffer arms G_CVAR_VARIABLE_STRING_BUFFER, G_ARGV, G_FS_GETFILELIST, G_GET_CONFIGSTRING, G_GET_USERINFO, G_GET_SERVERINFO, BOTLIB_GET_CONSOLE_MESSAGE, and G_GET_ENTITY_TOKEN (:540, :545, :563, :612, :618, :621, :975, :1650), and SP_GETSTRINGTEXTSTRING (:686): the CharBuf fill and the copy into the module's bytes.
- TRAP_ANGLEVECTORS (:483), G_FS_FOPEN_FILE (:552), G_TRUEMALLOC and G_TRUEFREE (:731, :734): the slot of the Slots at the word.
- G_SET_SHARED_BUFFER (:939): the bytes accessor of `mSharedMemory`.
- SV_NumForGentity (:49), SV_GentityNum (:57), SV_GameClientNum (:65): the Slots of the game's stride.
- SV_GetEntityToken (:343, :356): the cursor accessor of the field.
- ConvertedEntity (:436): the pointer fields copy as they stand.

## The hand accessors

`Sources/JKAMP_Ded/GameViews.swift` is a new file of the view target. Each piece carries one `// AI:` line. No piece has the signature of a piece in `ServerViews.swift`.

| Piece | Raven's counterpart | Use |
|---|---|---|
| `Slots(syscallWords:count:)` on `Slots<Int32>` | `int *args` of SV_GameSystemCalls over the words of `VM_DllSyscall` | the bridge that row V2 installs |
| `VMA(_:)` on `Slots<Int32>`, seven overloads: `OpaquePointer?`, `String`, a view `V?`, `vec3_t`, `vec3_t?`, `Slots<vec3_t>`, `Slots<byte>`, `Slots<Int32>`, and `Slots<OpaquePointer?>` | the macro `VMA(x)`, `VM_ArgPtr(args[x])`, at sv_game.cpp:403 | every pointer argument of the switch |
| `VMF(_:)` on `Slots<Int32>` | the macro `VMF(x)`, `((float *)args)[x]`, at :406 | every float argument |
| `Server.gentitiesSlots` | `(byte *)sv.gentities + sv.gentitySize*(num)` at :57 | SV_NumForGentity and SV_GentityNum |
| `Server.gameClientsSlots` | `(byte *)sv.gameClients + sv.gameClientSize*(num)` at :65 | SV_GameClientNum |
| `Server.entityParsePointCursor` and `Server.mLocalSubBSPEntityParsePointCursor` | `(const char **)&sv.entityParsePoint` at :343 and :356 | SV_GetEntityToken |
| `Server.mSharedMemoryBytes` | `sv.mSharedMemory = ((char *)VMA(1))` at :939 | G_SET_SHARED_BUFFER |

The cursor accessor copies the text from the pointer on each read, and its setter moves the C pointer by the bytes COM_Parse read, so the field keeps Raven's walk and no remainder goes into the string pool.

## Rows for the user

- Row G1, the syscall words. Question: Raven's `int *args` is a `Slots<Int32>`, and the module sends `intptr_t` words. Proposal: keep `Slots(syscallWords:)` and the `VMA` and `VMF` accessors of `GameViews.swift`, which read the low `int` and the whole word as C does on the host. Row V1 of `notes/2026-11-09/dedicated-round-vm.md` gives VM_ArgPtr a `raw` return. VMA stays the accessor, because a `raw` pointer in the switch needs a cast at every arm.
- Row G2, the server accessors of the game memory. Question: `sv.gentities` and `sv.gameClients` step by a size the game gives, the two parse points walk a `char *`, and `mSharedMemory` holds a buffer address. Proposal: keep the five `Server` accessors of `GameViews.swift`. A later views rule can give `mSharedMemory` the FIELDS kind `bytes`.
- Row G3, TRAP_STRNCPY (sv_game.cpp:470). Raven returns `(int)strncpy(...)`, the address as an `int`. C type: `char *`. Callers: the shared trap of the three modules. Proposal: a rule 19 note and a return of 0, because the module never reads the address.
- Row G4, the precision timers (:513 to :528). Raven's labels are the cgame enumerators and `timing_c` is C++. Proposal: no arm until a timing stage, and the game number reaches the default arm as in Raven's switch.
- Row G5, CM_ClusterPVS (cm_test.cpp, called at :223 and :257). C type: `byte *` return. Callers: SV_inPVS and SV_inPVSIgnorePortals. Proposal: the return is the `Slots<byte>` of the cluster row, the `bytes` form of row 1 of the third ledger.
- Row G6, SV_AreaEntities (:581). The stub takes `inout Int32` for `int *entityList`. Callers: G_ENTITIES_IN_BOX. Proposal: a PARAMS row of kind `int_array` or the host subscript sweep, so the parameter is a `Slots<Int32>` and the arm passes `args.VMA(3)`.
- Row G7, `sv_siegePersData` (:454, :640, :644). C type: `siegePers_t`. Proposal: `siegePers_t` joins `HOST_ROOTS`, the form of row 14 of the first ledger, and the variable is a record on `EngineStorage`, so the arms are `sv_siegePersData.copy(from:)` and the reverse.
- Row G8, BotImport_DebugPolygonCreate (:673). The stub takes `inout vec3_t` for `vec3_t *points`. Proposal: `Slots<vec3_t>`, the form of the host subscript sweep.
- Row G9, Com_RealTime (:678). The stub has a signature marker for `qtime_t *`. Proposal: `qtime_t` takes a view and the parameter is that view.
- Row G10, Sys_SnapVector (:680). The stub takes `inout Float` for `float *v`, which Raven reads as three floats. Proposal: `inout vec3_t`, the row of a pointer Raven fills as a fixed set of floats.
- Row G11, SV_BotWaypointReception (:1643). The stub has a signature marker for `wpobject_t **`. Proposal: the botlib stage rules it with the `Slots<Wpobject?>` form of `gWPArray`.
- Row G12, `byte msgBuffer[MAX_MSGLEN]` of SV_SendClientGameState (sv_client.cpp:701) and SV_SendClientMapChange (:823). Proposal: a BYTE_STORAGE_LOCALS key for each function, the form that row S2 of `notes/2026-11-09/dedicated-round-common.md` proposes for `bufData`. These two holes stop every gamestate, so a client cannot enter until this row lands.
- Row G13, `downloadBlocks` of client_t (sv_client.cpp:1158 and :1243). The field is `Slots<OpaquePointer?>`, so the Z_Malloc block and MSG_WriteData have no byte form. Proposal: a FIELDS row that makes each slot a `Slots<byte>?` of `MAX_DOWNLOAD_BLKSIZE`.

Rows S2 (the C `rand` of SV_GetChallenge at sv_client.cpp:67), S3 (`denied` of SV_DirectConnect at :520), V2 (`systemCalls` of VM_Create at sv_game.cpp:1750), E5, and Z6 are open rows of earlier records, and their holes here name them.

## The open holes

| Function | Raven line | Hole | Row |
|---|---|---|---|
| SV_inPVS, SV_inPVSIgnorePortals | sv_game.cpp:223, :257 | the `mask` local, three holes each | G5 |
| SV_GameSystemCalls | :470 | TRAP_STRNCPY | G3 |
| SV_GameSystemCalls | :581 | G_ENTITIES_IN_BOX | G6 |
| SV_GameSystemCalls | :640 | G_SIEGEPERSSET and G_SIEGEPERSGET | G7 |
| SV_GameSystemCalls | :680 | G_DEBUG_POLYGON_CREATE | G8 |
| SV_GameSystemCalls | :678 | G_REAL_TIME | G9 |
| SV_GameSystemCalls | :680 | G_SNAPVECTOR | G10 |
| SV_GameSystemCalls | :714 | 5 ROFF arms | E5 |
| SV_GameSystemCalls | :739 | 19 ICARUS arms | E5 |
| SV_GameSystemCalls | :837 | 42 NPC navigator arms | E5 |
| SV_GameSystemCalls | :948, :981 | 11 and 123 botlib arms | E5 |
| SV_GameSystemCalls | :1313 | RE_RegisterServerSkin and 47 G2API_ arms, 48 arms | Z6 |
| SV_GameSystemCalls | :1624 | G_RMG_INIT and G_CM_REGISTER_TERRAIN | E5 |
| SV_GameSystemCalls | :1643 | G_BOT_UPDATEWAYPOINTS | G11 |
| SV_InitGameProgs | :1750 | VM_Create | V2 |
| SV_GetChallenge | sv_client.cpp:67 | `rand` | S2 |
| SV_DirectConnect | :520 | `denied` | S3 |
| SV_WriteRMGAutomapSymbols | :668 | the whole body | E5 |
| SV_SendClientGameState | :701, :768 | `msgBuffer`, the RMG test | G12, E5 |
| SV_SendClientMapChange | :823 | `msgBuffer` | G12 |
| SV_WriteDownloadToClient | :1158, :1243 | the block allocation and its write | G13 |

The `portMissing` count per file: sv_game.swift 21, sv_client.swift 8. G_InitGame calls `trap_ICARUS_Init` and `trap_Nav_Load` (`Sources/JKAMP_GameLogic/g_main.swift:854`, `:872`), so a map load stops at the ICARUS hole of row E5, as that row expects. The server loop also needs row V2, so SV_InitGameProgs stops first.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The warnings in the round files are unused results of calls that are not `@discardableResult`, "will never be executed" after the holes, and the locals of the `mask` holes. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests in 9 runs, all pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_game` | exit 0, 10 of 27 hand functions replaced, 17 kept, 242 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_client` | exit 0, 11 of 25 hand functions replaced, 14 kept, 47 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The draftcheck holes are in the drafter's output, not in the working tree. The 242 holes of sv_game are the drafter's own SV_GameSystemCalls, which align.py marks rewritten, so the gate keeps the hand switch. The draftcheck builds ran through a `swift` wrapper that adds `-j 2`, because draftcheck.py calls `swift build` with no job count.
