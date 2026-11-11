# The signature batch ledger

This ledger closes row G of `notes/2026-11-11/after-the-stubs-ledger.md`. `tools/oracle-closure/sigcheck.py` compares each Swift function signature of `mp-game`, `mp-cgame`, and `mp-engine-ded` with the signature that the table gives today, and the `sigs` step of `tools/gate.sh` runs it. The check found 31 differences: 3 of exit 1, 14 of exit 2, 13 of exit 3, and `main`, which has no Swift function. Each row gives the function, the Swift line, Raven's line, the exit, and the proof. Exit 1 is a row for an existing kind, exit 2 is a return to the generated form, and exit 3 is a row for the user. `SIGNATURE_EXCEPTIONS` of `rulings.py` names each row of exit 3 and the row of `main`, so the check prints those rows with their ledger row and fails on any other difference.

## The rows for the user

| Row | Function | Swift | Raven | Question | Hand form | Table form |
|---|---|---|---|---|---|---|
| SG3 | `BG_AnimsetAlloc` | `Sources/JKAMP_BG/bg_panimate.swift:1379` | `oracle/codemp/game/bg_panimate.c:1729` | The RETURNS row `"BG_AnimsetAlloc": "table"` names the kind, and `Table.result` of `table.py` has no branch for the kind `table`. Does the tool get the branch, so the table gives the hand form? | `func BG_AnimsetAlloc() -> Slots<JKAMP.Animation>` | `func BG_AnimsetAlloc() -> JKAMP.Animation?` |
| SG6 | `AxisCopy` | `Sources/JKAShared/q_math.swift:488` | `oracle/codemp/game/q_math.c:550` | The body only reads `in`, and the axis branch of `spelling.py` gives a `vec3_t name[3]` the inout whether or not the body writes it. The kind `vec3_array` reads a pointer parameter, and the parse gives this parameter as an array. Does the axis branch get a by-value form for an axis the body only reads, the form of the vector at `spelling.py:463`, or do the eight Swift callers pass the axis inout? | `` func AxisCopy(_ `in`: [vec3_t], _ out: inout [vec3_t]) `` | `` public func AxisCopy(_ `in`: inout [JKAShared.vec3_t], _ out: inout [JKAShared.vec3_t]) `` |
| SG7 | `VectorRotate` | `Sources/JKAShared/q_math.swift:555` | `oracle/codemp/game/q_math.c:603` | The question of SG6, for `matrix`. | `` func VectorRotate(_ `in`: vec3_t, _ matrix: [vec3_t], _ out: inout vec3_t) `` | `` public func VectorRotate(_ `in`: JKAShared.vec3_t, _ matrix: inout [JKAShared.vec3_t], _ out: inout JKAShared.vec3_t) `` |
| SG8 | `SetPlaneSignbits` | `Sources/JKAShared/q_math.swift:717` | `oracle/codemp/game/q_math.c:751` | The hand q_math takes the value `Plane` of `Sources/JKAShared/Views/Plane.swift`, and the three callers of the host read the plane out of the view and write it back. Does the value stay, or do the functions take the view `Cplane`? | `func SetPlaneSignbits(_ out: inout Plane)` | `public func SetPlaneSignbits(_ out: JKAShared.Cplane)` |
| SG9 | `BoxOnPlaneSide` | `Sources/JKAShared/q_math.swift:740` | `oracle/codemp/game/q_math.c:809` | The question of SG8. | `func BoxOnPlaneSide(_ emins: vec3_t, _ emaxs: vec3_t, _ p: inout Plane) -> Int32` | `public func BoxOnPlaneSide(_ emins: JKAShared.vec3_t, _ emaxs: JKAShared.vec3_t, _ p: JKAShared.Cplane) -> Int32` |
| SG14 | `G2_Set_Bone_Rag` | `Sources/JKAMP_DedLogic/G2_bones.swift:1125` | `oracle/codemp/ghoul2/G2_bones.cpp:1318` | Both callers bind `blist` to `ghoul2.mBlist`, G2_bones.cpp:1651 and :4671, and the hand body reads the list through `ghoul2` under an AI line. Does the dropped parameter stay, or does the function take `inout [boneInfo_t]` beside the class that holds the same list? | `private func G2_Set_Bone_Rag(_ mod_a: MdxaHeader, _ boneName: String, _ ghoul2: CGhoul2Info, _ scale: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) -> Int32` | `private func G2_Set_Bone_Rag(_ mod_a: MdxaHeader, _ blist: inout [boneInfo_t], _ boneName: String, _ ghoul2: CGhoul2Info, _ scale: JKAShared.vec3_t, _ origin: JKAShared.vec3_t) -> Int32` |
| SG23 | `Log_Write` | `Sources/JKAMP_DedLogic/l_log.swift:73` | `oracle/codemp/botlib/l_log.cpp:96` | The body only reads `fmt` through `vfprintf` at l_log.cpp:102, and `vfprintf` is in `TEXT_READERS` of `table.py`, but the text sweep does not put the parameter in its read set. Does the sweep get the fix, so the table gives `String`? | `func Log_Write(_ fmt: String, _ args: any JKAShared.FormatArg...)` | `func Log_Write(_ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...)` |
| SG24 | `Log_WriteTimeStamped` | `Sources/JKAMP_DedLogic/l_log.swift:89` | `oracle/codemp/botlib/l_log.cpp:113` | The question of SG23, for the read at l_log.cpp:126. | `func Log_WriteTimeStamped(_ fmt: String, _ args: any JKAShared.FormatArg...)` | `func Log_WriteTimeStamped(_ fmt: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...)` |
| SG25 | `PC_EvaluateTokens` | `Sources/JKAMP_DedLogic/l_precomp.swift:1455` | `oracle/codemp/botlib/l_precomp.cpp:1730` | The width branch of `Table.param` gives a `signed long int *` of the botlib `inout Int32` before `spelling.py` reads the NULL, and callers hand NULL for `intvalue`, l_precomp.cpp:2517 and :2626. The `double *floatvalue` beside it takes the `UnsafeMutablePointer<Double>?` of the NULL rule. Does the width branch get the NULL rule? | `func PC_EvaluateTokens(_ source: Source, _ tokens: Token, _ intvalue: UnsafeMutablePointer<Int32>?, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32` | `func PC_EvaluateTokens(_ source: Source, _ tokens: Token, _ intvalue: inout Int32, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32` |
| SG26 | `PC_Evaluate` | `Sources/JKAMP_DedLogic/l_precomp.swift:1830` | `oracle/codemp/botlib/l_precomp.cpp:2184` | The question of SG25, with the NULL of l_precomp.cpp:2517. | `func PC_Evaluate(_ source: Source, _ intvalue: UnsafeMutablePointer<Int32>?, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32` | `func PC_Evaluate(_ source: Source, _ intvalue: inout Int32, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32` |
| SG27 | `PC_DollarEvaluate` | `Sources/JKAMP_DedLogic/l_precomp.swift:1907` | `oracle/codemp/botlib/l_precomp.cpp:2283` | The question of SG25, with the NULL of l_precomp.cpp:2626. | `func PC_DollarEvaluate(_ source: Source, _ intvalue: UnsafeMutablePointer<Int32>?, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32` | `func PC_DollarEvaluate(_ source: Source, _ intvalue: inout Int32, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32` |
| SG29 | `SV_GameSystemCalls` | `Sources/JKAMP_DedLogic/sv_referee.swift:232` | `oracle/codemp/server/sv_game.cpp:458` | Raven returns an address in the `int` at sv_game.cpp:471 and :668, and the hand function, the fork's referee wrapper of `SV_GameSystemCalls_Real` at sv_game.swift:409, returns the pointer-wide word. The RETURNS kind `word` gives that form, and under the row `bodies.py` writes the hole "Raven returns NULL, and the function returns a `Int`" at each integer `return` of the dispatcher. Does the row land with a fix of the drafter, or does the function stay named? | `public func SV_GameSystemCalls(_ args: Slots<Int32>) -> Int` | `func SV_GameSystemCalls(_ args: Slots<Int32>) -> Int32` |
| SG31 | `ZoneTailFromHeader` | `Sources/JKAMP_Ded/ZoneBlocks.swift:35` | `oracle/codemp/qcommon/z_memman_pc.cpp:45` | Raven computes the tail address from the header and never returns NULL, and no RETURNS kind gives a record pointer return that is never NULL. Does the hand form stay, or does the tool get a kind for that return? | `public func ZoneTailFromHeader(_ pHeader: ZoneHeader) -> ZoneTail` | `private func ZoneTailFromHeader(_ pHeader: ZoneHeader) -> ZoneTail?` |

## Every difference

| Row | Function | Swift | Raven | Exit | Proof |
|---|---|---|---|---|---|
| SG1 | `Debug_Printf` | `Sources/JKAMP_GameLogic/NPC_misc.swift:13` | `oracle/codemp/game/NPC_misc.c:10` | 2 | The body only reads `fmt` through `vsprintf` at NPC_misc.c:31, the callers hand a literal at NPC_combat.c:1581 and :1591, and the four Swift callers now pass the literal. |
| SG2 | `Debug_NPCPrintf` | `Sources/JKAMP_GameLogic/NPC_misc.swift:44` | `oracle/codemp/game/NPC_misc.c:41` | 2 | The body only reads `fmt` through `vsprintf`, the form of SG1, and no Swift line calls it. |
| SG3 | `BG_AnimsetAlloc` | `Sources/JKAMP_BG/bg_panimate.swift:1379` | `oracle/codemp/game/bg_panimate.c:1729` | 3 | The RETURNS row of the kind `table` exists, and the tool gives the kind no return form. |
| SG4 | `ClampChar` | `Sources/JKAShared/q_math.swift:160` | `oracle/codemp/game/q_math.c:279` | 2 | `NARROW` of `reexport.py` makes the return of a `signed char` Int32, and no Swift line calls it. |
| SG5 | `ClampShort` | `Sources/JKAShared/q_math.swift:171` | `oracle/codemp/game/q_math.c:289` | 2 | `NARROW` makes the return of a `signed short` Int32, and no Swift line calls it. |
| SG6 | `AxisCopy` | `Sources/JKAShared/q_math.swift:488` | `oracle/codemp/game/q_math.c:550` | 3 | The body reads the three vectors of `in` and writes none, and the axis branch of `spelling.py` gives every `vec3_t name[3]` with no NULL the inout. |
| SG7 | `VectorRotate` | `Sources/JKAShared/q_math.swift:555` | `oracle/codemp/game/q_math.c:603` | 3 | The body reads the three vectors of `matrix` and writes none, the form of SG6. |
| SG8 | `SetPlaneSignbits` | `Sources/JKAShared/q_math.swift:717` | `oracle/codemp/game/q_math.c:751` | 3 | The hand value `Plane` and the table's view `Cplane` both carry Raven's `cplane_t *`. |
| SG9 | `BoxOnPlaneSide` | `Sources/JKAShared/q_math.swift:740` | `oracle/codemp/game/q_math.c:809` | 3 | The form of SG8. |
| SG10 | `COM_ParseError` | `Sources/JKAShared/q_shared.c.swift:212` | `oracle/codemp/game/q_shared.c:300` | 2 | The body only reads `format` through `vsprintf` at q_shared.c:306, and no Swift line calls it. |
| SG11 | `COM_ParseWarning` | `Sources/JKAShared/q_shared.c.swift:221` | `oracle/codemp/game/q_shared.c:312` | 2 | The body only reads `format` through `vsprintf` at q_shared.c:318, and no Swift line calls it. |
| SG12 | `CG_ChatBox_ArrayInsert` | `Sources/JKAMP_CGameLogic/cg_draw.swift:6767` | `oracle/codemp/cgame/cg_draw.c:7627` | 1 | The caller hands its `chatBoxItem_t *drawThese[MAX_CHATBOX_ITEMS]` at cg_draw.c:7676 and the body fills it at :7639, so the PARAMS kind `view_array` gives the hand `inout [ChatBoxItem?]`. |
| SG13 | `G2API_RagEffectorGoal` | `Sources/JKAMP_DedLogic/G2_API.swift:995` | `oracle/codemp/ghoul2/G2_API.cpp:1538` | 2 | Raven gives `pos` no default at G2_API.cpp:1538 or G2_local.h:198, and every Swift caller passes it. |
| SG14 | `G2_Set_Bone_Rag` | `Sources/JKAMP_DedLogic/G2_bones.swift:1125` | `oracle/codemp/ghoul2/G2_bones.cpp:1318` | 3 | Both callers bind `blist` to `ghoul2.mBlist`, so the dropped parameter and the table's `inout` list are both defensible. |
| SG15 | `AppendToSaveGame` | `Sources/JKAMP_DedLogic/Q3_Interface.swift:561` | `oracle/codemp/icarus/Q3_Interface.cpp:695` | 2 | `MSVC_WIDTH_FOLDERS` makes the `unsigned long chid` of the icarus folder UInt32, and the field `I_WriteSaveData` of `interface_export_t.swift` takes the same type. |
| SG16 | `ReadFromSaveGame` | `Sources/JKAMP_DedLogic/Q3_Interface.swift:567` | `oracle/codemp/icarus/Q3_Interface.cpp:701` | 2 | The width of SG15, and the field `I_ReadSaveData` takes the same type. |
| SG17 | `IsWhiteSpace` | `Sources/JKAMP_DedLogic/be_ai_chat.swift:265` | `oracle/codemp/botlib/be_ai_chat.cpp:384` | 2 | `NARROW` makes a `char` parameter Int32, and the body compares `c` with Int32 values. |
| SG18 | `BotAvoidSpots` | `Sources/JKAMP_DedLogic/be_ai_move.swift:682` | `oracle/codemp/botlib/be_ai_move.cpp:636` | 2 | The NULLABLE row of `avoidspots` holds, because BotGetReachabilityToGoal hands its NULL on at be_ai_move.cpp:781, and the old caller trapped on that nil. |
| SG19 | `CM_GetWorldHeight` | `Sources/JKAMP_DedLogic/cm_terrain.swift:116` | `oracle/codemp/qcommon/cm_terrain.cpp:1633` | 1 | `CCMLandScape::GetWorldHeight` writes `origin[2]` at cm_terrain.cpp:1054 through the `origin` of :1635, so the PARAMS kind `vec3_mut` gives the hand `inout`. |
| SG20 | `CM_AreaCollision` | `Sources/JKAMP_DedLogic/cm_terrain.swift:142` | `oracle/codemp/qcommon/cm_terrain.cpp:1658` | 1 | The body hands `areaTypes` to `CCMLandScape::AreaCollision` at cm_terrain.cpp:1660, which reads `areaTypeCount` types, so the PARAMS kind `int_array` gives the hand `[Int32]?`. |
| SG21 | `CreateRandomTerrain` | `Sources/JKAMP_DedLogic/cm_terrain.swift:172` | `oracle/codemp/qcommon/cm_terrain.cpp:1688` | 2 | No caller of either tree hands NULL for `heightmap`, no NULLABLE row names it, and no Swift line calls it. |
| SG22 | `add_bit` | `Sources/JKAMP_DedLogic/huffman.swift:43` | `oracle/codemp/qcommon/huffman.cpp:32` | 2 | `NARROW` makes a `char` parameter Int32, and the caller of huffman.swift:359 drops its CChar cast. |
| SG23 | `Log_Write` | `Sources/JKAMP_DedLogic/l_log.swift:73` | `oracle/codemp/botlib/l_log.cpp:96` | 3 | The body only reads `fmt`, and the text sweep leaves it out of its read set. |
| SG24 | `Log_WriteTimeStamped` | `Sources/JKAMP_DedLogic/l_log.swift:89` | `oracle/codemp/botlib/l_log.cpp:113` | 3 | The form of SG23. |
| SG25 | `PC_EvaluateTokens` | `Sources/JKAMP_DedLogic/l_precomp.swift:1455` | `oracle/codemp/botlib/l_precomp.cpp:1730` | 3 | Callers hand NULL for `intvalue`, and the width branch of the table gives no optional. |
| SG26 | `PC_Evaluate` | `Sources/JKAMP_DedLogic/l_precomp.swift:1830` | `oracle/codemp/botlib/l_precomp.cpp:2184` | 3 | The form of SG25. |
| SG27 | `PC_DollarEvaluate` | `Sources/JKAMP_DedLogic/l_precomp.swift:1907` | `oracle/codemp/botlib/l_precomp.cpp:2283` | 3 | The form of SG25. |
| SG28 | `PS_NextWhiteSpaceChar` | `Sources/JKAMP_DedLogic/l_script.swift:960` | `oracle/codemp/botlib/l_script.cpp:1085` | 2 | `NARROW` makes a `char` return Int32, and no Swift line calls it. |
| SG29 | `SV_GameSystemCalls` | `Sources/JKAMP_DedLogic/sv_referee.swift:232` | `oracle/codemp/server/sv_game.cpp:458` | 3 | Raven returns an address in the word at sv_game.cpp:471 and :668, and the RETURNS kind `word` gives the hand `Int`, but under that row the drafter writes a hole at each integer `return` of the dispatcher. |
| SG30 | `main` | `Sources/jampded/main.swift` | `oracle/codemp/null/win_main.cpp:1410` | named | The top-level code of the executable target is the entry, so no Swift function has the name. |
| SG31 | `ZoneTailFromHeader` | `Sources/JKAMP_Ded/ZoneBlocks.swift:35` | `oracle/codemp/qcommon/z_memman_pc.cpp:45` | 3 | Raven never returns NULL, and no RETURNS kind gives a pointer return with no optional. |

## The rows with no Swift line

The skeleton finds no Swift line for 23 rows. The check reads each one as follows.

- `BotEntityInfo` of `mp-game`, `oracle/codemp/game/ai_main.c:407-409`: a hole, which the check skips.
- `memmove` of `mp-game`, `oracle/codemp/game/bg_lib.c:287-300`: a hole, which the check skips.
- `atof` of `mp-game`, `oracle/codemp/game/bg_lib.c:774-839`: a function of `NOT_PORTED`, which the check skips.
- `PM_CrashLandEffect` of `mp-game`, `oracle/codemp/game/bg_pmove.c:3684-3722`: the check finds it at `Sources/JKAMP_BG/Generated/bg_callbacks.swift:349` and `Sources/JKAMP_GameLogic/bg_pmove_game.swift:11`.
- `vmMain` of `mp-game`, `oracle/codemp/game/g_main.c:515-696`: a function of `NOT_PORTED`, which the check skips.
- `vmMain` of `mp-cgame`, `oracle/codemp/cgame/cg_main.c:190-359`: a function of `NOT_PORTED`, which the check skips.
- `CleanTextPool` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:212-222`: a hole, which the check skips.
- `GPG_GetPairs` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1029-1037`: a function of `NOT_PORTED`, which the check skips.
- `GPG_GetInOrderPairs` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1039-1047`: a function of `NOT_PORTED`, which the check skips.
- `GPV_GetNext` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1132-1140`: a function of `NOT_PORTED`, which the check skips.
- `GPV_GetInOrderNext` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1142-1150`: a function of `NOT_PORTED`, which the check skips.
- `GPV_GetInOrderPrevious` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1152-1160`: a function of `NOT_PORTED`, which the check skips.
- `GPV_GetList` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1195-1203`: a function of `NOT_PORTED`, which the check skips.
- `Cvar_FreeString` of `mp-engine-ded`, `oracle/codemp/qcommon/cvar.cpp:26-32`: a function of `NOT_PORTED`, which the check skips.
- `Cvar_Realloc` of `mp-engine-ded`, `oracle/codemp/qcommon/cvar.cpp:965-975`: a function of `NOT_PORTED`, which the check skips.
- `Sys_GetFileTime` of `mp-engine-ded`, `oracle/codemp/qcommon/files_pc.cpp:568-598`: a function of `NOT_PORTED`, which the check skips.
- `SV_GameSystemCalls` of `mp-engine-ded`, `oracle/codemp/server/sv_game.cpp:458-1657`: the check finds it at `Sources/JKAMP_DedLogic/sv_referee.swift:232`.
- `VM_DllSyscall` of `mp-engine-ded`, `oracle/codemp/qcommon/vm.cpp:363-381`: a function of `NOT_PORTED`, which the check skips.
- `main` of `mp-engine-ded`, `oracle/codemp/null/win_main.cpp:1410-1502`: named by row SG30 of notes/2026-11-11/signature-batch-ledger.md.
- `NetadrToSockadr` of `mp-engine-ded`, `oracle/codemp/win32/win_net.cpp:97-124`: a hole, which the check skips.
- `SockadrToNetadr` of `mp-engine-ded`, `oracle/codemp/win32/win_net.cpp:127-141`: a hole, which the check skips.
- `Sys_StringToSockaddr` of `mp-engine-ded`, `oracle/codemp/win32/win_net.cpp:160-216`: a hole, which the check skips.
- `ZoneTailFromHeader` of `mp-engine-ded`, `oracle/codemp/qcommon/z_memman_pc.cpp:45-48`: named by row SG31 of notes/2026-11-11/signature-batch-ledger.md.

## The rows that the check skips

A row with a `TODO: Port signature` reason has no table form, so the check skips it:

- `BotEntityInfo` of `mp-game`, `oracle/codemp/game/ai_main.c:407-409`, a hole: No table row for `aas_entityinfo_t * info`.
- `memmove` of `mp-game`, `oracle/codemp/game/bg_lib.c:287-300`, a hole: No table row for the return `void *`.
- `MatrixMultiply` of `mp-game`, `oracle/codemp/game/q_math.c:1293-1312`, a hole: No table row for `float[3][3] in1`.
- `NormalToLatLong` of `mp-game`, `oracle/codemp/game/q_math.c:1394-1423`, a hole: No table row for `byte[2] bytes`.
- `CleanTextPool` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:212-222`, a hole: No table row for `CTextPool * pool`.
- `NetadrToSockadr` of `mp-engine-ded`, `oracle/codemp/win32/win_net.cpp:97-124`, a hole: No table row for `struct sockaddr * s`.
- `SockadrToNetadr` of `mp-engine-ded`, `oracle/codemp/win32/win_net.cpp:127-141`, a hole: No table row for `struct sockaddr * s`.
- `Sys_StringToSockaddr` of `mp-engine-ded`, `oracle/codemp/win32/win_net.cpp:160-216`, a hole: No table row for `struct sockaddr * sadr`.

A function of `NOT_PORTED` has no Swift function of Raven's shape, so the check skips it. `swapfunc`, `med3`, and `qsort` of bg_lib.c are among them, with the reason that the hand port is generic over the element type:

- `swapfunc` of `mp-game`, `oracle/codemp/game/bg_lib.c:80-86`.
- `med3` of `mp-game`, `oracle/codemp/game/bg_lib.c:98-103`.
- `qsort` of `mp-game`, `oracle/codemp/game/bg_lib.c:105-181`.
- `atof` of `mp-game`, `oracle/codemp/game/bg_lib.c:774-839`.
- `vmMain` of `mp-game`, `oracle/codemp/game/g_main.c:515-696`.
- `vmMain` of `mp-cgame`, `oracle/codemp/cgame/cg_main.c:190-359`.
- `GPG_GetPairs` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1029-1037`.
- `GPG_GetInOrderPairs` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1039-1047`.
- `GPV_GetNext` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1132-1140`.
- `GPV_GetInOrderNext` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1142-1150`.
- `GPV_GetInOrderPrevious` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1152-1160`.
- `GPV_GetList` of `mp-engine-ded`, `oracle/codemp/qcommon/GenericParser2.cpp:1195-1203`.
- `Cvar_FreeString` of `mp-engine-ded`, `oracle/codemp/qcommon/cvar.cpp:26-32`.
- `Cvar_Realloc` of `mp-engine-ded`, `oracle/codemp/qcommon/cvar.cpp:965-975`.
- `Sys_GetFileTime` of `mp-engine-ded`, `oracle/codemp/qcommon/files_pc.cpp:568-598`.
- `VM_DllSyscall` of `mp-engine-ded`, `oracle/codemp/qcommon/vm.cpp:363-381`.

## The other rulings of the batch

- `skeleton.py` and `merge.py` stop on an absent `out/extract/<unit>/extract.json`. Every run of `extract.py` that is not a check writes the file, `extract.py:1257` and `:1258`, and `tools/worktree-setup.sh --tools` runs the extract of each of the three units. A check run makes the module folder at `extract.py:1249` and writes no manifest, so `merge.py` reads the manifest and not the folder.
- `reexport.py` exits 1 when a probe build fails and names no generated declaration, the exit of a build that still fails after its last round.
- Rule 25: `level` of `Sources/JKAMP_GameLogic/g_main.swift:7` is `public`. `skeleton.py` writes that line for a stub that is not adopted, so `PUBLIC_NAMES` of `rulings.py` names `level`, `cg`, and `cgs`, and the table gives `public` to the three forwards.
