# The server core round, sv_main, sv_init, sv_ccmds, and sv_net_chan

This record holds the round of the four server stems of unit mp-engine-ded: `Sources/JKAMP_DedLogic/sv_main.swift`, `sv_init.swift`, `sv_ccmds.swift`, and `sv_net_chan.swift`. The tree is the worktree `/tmp/jka-ded-sv` on the branch `dedicated-round-sv-core`, off master at 1cdd22f. The code commit is 7c86051. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`.

## The bodies

The four stubs had the skeleton header, so the round adopted them and removed the header in the code commit. A first draftcheck run over the four stems gave 138 holes, 72 of them compile holes, and the drafts went into the four files over the stubs. The hole round then filled every hole that a ruled form, an adopted stem, or a hand accessor of this round covers.

- sv_net_chan, 5 of 5 functions whole. SV_Netchan_Encode and SV_Netchan_Decode read the key text as a `CharBuf`, `client.lastClientCommandStringBuffer` and `CharBuf(client.reliableCommands[...])`, with the unsigned byte read `string[index] as UInt8` of row 5 of the first ledger. The XOR writes `msg.data![i]`, the `bytes` field of row 1 of the third ledger. Raven's `long` locals stay `CLong`, the form of `cvar.swift`. SV_Netchan_Transmit hands `msg.data!` to Netchan_Transmit.
- sv_main, 18 of 18 functions with a body. Every `cl++` and `client++` over a `Slots<Client>` local is `cl = cl.suffix(from: 1)`, Raven's `p + 1` as a `Slots`, and a pass of the record is `cl[0]`. `*(int *)msg->data == -1` reads `msg.data![int: 0] == -1`, the net_chan form. SV_SendServerCommand formats into a `CharBuf(MAX_MSGLEN)` by the `vsprintf` form. The `Q_strncpyz` into a reliable command slot is the store `client.reliableCommands[index] = cmd`, because the setter of a `cStrings` Slots holds Raven's `Q_strncpyz` bound. SVC_Status had a drafted `strcpy(&status + statusLength, player)`, a pointer sum that compiled, and it now reads `strcpy(&status, player, at: statusLength)`.
- sv_init, 17 of 17 functions with a body. `svs.clients` takes the cast form `Client(Z_Malloc(...))`, and Z_Free and Hunk_FreeTempMemory take the `handle` of the view, the precedent of FreeWinding in `cm_polylib.swift`. SV_InitSV reads `sv.clear()`. The two struct copies of SV_ChangeMaxClients are the `Slots` store, which copies the record as C struct assignment does.
- sv_ccmds, 19 of 19 functions with a body. A walk of a `Client?` local from `svs.clients` takes the slot of the loop index, `cl = svs.clientsSlots[i]`. SV_Map_f walks `cmd` as a `TextCursor` and hands `nil` to the `CharBuf?` overload of FS_ReadFile, row 7 of the first ledger. SV_Status_f writes `sprintf(state, "%4i", ping)` as `strcpy(&state, JKAShared.format("%4i", [ping]))`.

The static locals are properties of `EngineWorld` under the MARK lines of their files, each with a forward in the stem, the form of `string_MSG_ReadString`: `string_SV_ExpandNewlines` (sv_main.cpp:60), `adr` (:223), `lasttime` (:496), `lastMod` (:792), and `initialized_SV_AddOperatorCommands` (sv_ccmds.cpp:959). `string` and `initialized` take the function name as a suffix, because msg.cpp and navigator.cpp have static locals of the same names. `EngineWorld` gained a `deinit` that frees `adr`.

## The rule 24 sites

- SV_SetConfigstring (sv_init.cpp:44) and SV_ClearServer (:370): Raven's `Z_Free` of a configstring drops, because the slot holds a string of the pool.
- SV_ChangeMaxClients (:335, :349) and SV_Shutdown (:963): the record pointer to Z_Free and Hunk_FreeTempMemory is the `handle` of the view.
- SVC_RemoteCommand (sv_main.cpp:499): `lasttime &+ 500`, the wrap of Raven's `unsigned int` sum.
- SVC_RemoteCommand (:515): Com_BeginRedirect takes a closure that hands `String(outputbuf)` to SV_FlushRedirect, because the stub signatures of the two functions differ.
- SV_ConnectionlessPacket (:552): the seven bytes at `&msg->data[4]` go into a `CharBuf(7)` through Com_Memcpy before Q_strncmp reads them.
- SV_ConSay_f (sv_ccmds.cpp:781): the NUL goes into a copy of the Cmd_Args text, which no later read needs.

## The hand accessors

`Sources/JKAMP_Ded/ServerViews.swift` is a new file of the view target. Each piece is an extension of `Slots where Element: HandleView` and carries one `// AI:` line.

| Piece | Raven's counterpart | Use |
|---|---|---|
| `Slots(_ raw:, count:)` | the cast `(client_t *)Hunk_AllocateTempMemory( count * sizeof(client_t) )` at sv_init.cpp:323 | `oldClients` of SV_ChangeMaxClients |
| `Slots.new(count:)` | the C++ `new entityState_s[svs.numSnapshotEntities]` at sv_init.cpp:594 | SV_SpawnServer, and the static `adr` of `EngineWorld` |
| `delete()` | the C++ `delete[] svs.snapshotEntities` at sv_init.cpp:495 and :953 | SV_SpawnServer, SV_Shutdown, and the `deinit` of `EngineWorld` |
| `zero(count:)` | `memset(svs.snapshotEntities, 0, sizeof(entityState_t)*svs.numSnapshotEntities)` at sv_init.cpp:596 and `Com_Memset( svs.clients, 0, sv_maxclients->integer * sizeof(client_t) )` at :339 | the two fills, because the `Slots` of a pointer field has the widest count |

The round needed no accessor for `sv.gentities` or `sv.gameClients`, because the stems reach them only through `SV_GentityNum` and `SV_GameClientNum` of `sv_game.swift`. SV_GentityNum returns `SharedEntity?`, so the bot arm of SV_SpawnServer reads `SV_GentityNum(i)!`.

## Rows for the user

- Row S1, the renderer and Ghoul2 calls. Question: `RE_RegisterMedia_LevelLoadBegin` (sv_init.cpp:481) and `R_SVModelInit` (:578) of tr_model.cpp, `R_InitSkins` (:533) of tr_image.cpp, `R_InitShaders(qtrue)` (:534) of tr_shader.cpp, `G2API_SetTime(svs.time,0)` (sv_main.cpp:918, sv_init.cpp:618, :670, :677, :735) of G2_API.cpp, and `G2VertSpaceServer = &CMiniHeap_singleton` (sv_init.cpp:885) of tr_init.cpp have no Swift stub, because row E5 makes those files a later port stage. Callers: SV_Frame, SV_SpawnServer, and SV_Init. Proposal: no change in this round, the precedent of row Z6. The stage of each file fills its holes. These holes stop the main path: SV_Init stops at :885 after its calls of the sv_bot stubs, SV_SpawnServer stops at :481, and SV_Frame stops at :918 on every frame. The smallest stage that frees the server loop is `G2API_SetTime` with `G2TimeBases`, `G2VertSpaceServer` with `CMiniHeap_singleton`, and the four renderer functions of the load path.
- Row S2, the C library `rand` of the host. Question: SV_SpawnServer calls `srand(Com_Milliseconds())` and `sv.checksumFeed = ( ((int) rand() << 16) ^ rand() ) ^ Com_Milliseconds()` (sv_init.cpp:625-626). The C type is `int rand(void)` of the C library, and Raven's Windows binary links the MSVC CRT. Swift makes the C `rand` unavailable on Apple platforms, and the host target has no `rand` of its own. The `srand` and `rand` of `Sources/JKAMP_BG/bg_lib.swift` are bg_lib.c, which the host does not link. Callers: SV_SpawnServer alone. Proposal: a hand `srand` and `rand` of the MSVC CRT form, `holdrand = holdrand * 214013 + 2531011` and `(holdrand >> 16) & 0x7fff`, with `holdrand` on `EngineWorld`, the nearest pattern being the bg_lib pair with its seed on the state object. No precedent exists, so this row needs the user.
- Row S3, the text of GAME_CLIENT_CONNECT. Question: `denied = (char *)VM_ExplicitArgPtr( gvm, VM_Call( gvm, GAME_CLIENT_CONNECT, i, qfalse, isBot ) )` (sv_init.cpp:700, sv_ccmds.cpp:326) needs VM_ExplicitArgPtr, whose stub in `vm.swift` carries a signature marker for the `void *` return. Callers: SV_SpawnServer, SV_MapRestart_f, and SV_DirectConnect of sv_client.cpp. Proposal: `VM_ExplicitArgPtr` takes the RETURNS kind `optional_string` for the text of a game return, so `denied` is a `String?` and nil is Raven's NULL. The two arms after the hole are already Raven's, and `denied` is declared `String?`. The hole only runs with a connected client at a map change or a map restart.
- Row S4, the zone block of CopyString. Question: SV_SetConfigstring stores `CopyString( val )` (sv_init.cpp:45), and CopyString takes an `S_Malloc` block that nothing frees, because row Z3 returns the text and the configstring slot holds a string of the pool. Raven frees the old block at :44 and in SV_ClearServer at :370, so his zone holds one block per configstring, and the port adds one block for each set. Callers: SV_SetConfigstring, SV_SpawnServer at :614, and every `CopyString` caller. Proposal: CopyString keeps its `S_Malloc` for the zone accounting, and SV_SetConfigstring and SV_ClearServer free nothing, as in this round, and a later row decides whether the pool string takes the zone block.
- Row S5, the merge of the wave. Question: this round adds MARK sections and a `deinit` to `Sources/JKAMP_DedLogic/EngineWorld.swift` and four generic pieces on `Slots` in `ServerViews.swift`. Another stem of the wave can add a static local beside them, or a piece of the same signature. Proposal: the merge keeps both sections in the order of Raven's files, and a second piece with the same signature goes away in favor of the one in `ServerViews.swift`.

## The open holes

| Function | Raven line | Hole | Row |
|---|---|---|---|
| SV_Frame | sv_main.cpp:918 | `G2API_SetTime(svs.time,0)` | S1 |
| SV_SpawnServer | sv_init.cpp:481 | `RE_RegisterMedia_LevelLoadBegin(server, eForceReload)` | S1 |
| SV_SpawnServer | :533 | `R_InitSkins()` | S1 |
| SV_SpawnServer | :534 | `R_InitShaders(qtrue)` | S1 |
| SV_SpawnServer | :578 | `R_SVModelInit()` | S1 |
| SV_SpawnServer | :618, :670, :677, :735 | `G2API_SetTime(svs.time,0)` | S1 |
| SV_SpawnServer | :625 | `srand` and `rand` of the checksum feed | S2 |
| SV_SpawnServer | :700 | `denied` of VM_ExplicitArgPtr | S3 |
| SV_Init | :885 | `G2VertSpaceServer = &CMiniHeap_singleton` | S1 |
| SV_MapRestart_f | sv_ccmds.cpp:326 | `denied` of VM_ExplicitArgPtr | S3 |

The `portMissing` count per file: sv_main.swift 1, sv_init.swift 11, sv_ccmds.swift 1, and sv_net_chan.swift 0. `grep Unsafe` gives 0 in the four stems.

## The gate

| Check | Result |
|---|---|
| `swift build -j 2` | exit 0, 0 errors. The first full build gave 45 warnings in the round files: 30 unused results of calls that are not `@discardableResult` in other stems, 9 "will never be executed" after the holes, and 6 on locals, among them `denied`, which the row S3 store writes. |
| `swift test --no-parallel -j 2` | exit 0, 146 tests, 145 pass, 1 skipped: the interpreter test |
| `draftcheck.py --unit mp-engine-ded --stem sv_main` | exit 0, 3 of 18 hand functions replaced, 15 kept, 23 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_init` | exit 0, 5 of 17 hand functions replaced, 12 kept, 18 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_ccmds` | exit 0, 10 of 19 hand functions replaced, 9 kept, 14 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |
| `draftcheck.py --unit mp-engine-ded --stem sv_net_chan` | exit 0, 2 of 5 hand functions replaced, 3 kept, 11 holes, 0 cascade errors, 0 defects, 0 compile holes over 1 pass |

The draftcheck holes are in the drafter's output, not in the working tree. A "replaced" function is one whose hand body is still the draft, so the splice changes no text.
