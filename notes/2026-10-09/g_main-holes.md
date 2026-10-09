# g_main.c holes round

| Function | Reason | Verdict | Note |
| --- | --- | --- | --- |
| vmMain | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| vmMain | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| vmMain | A pointer local `T_G_ICARUS_PLAYSOUND * sharedMem` with no v | blocked | This body needs a view over `T_G_ICARUS_PLAYSOUND` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_SET * sharedMem` with no view. | blocked | This body needs a view over `T_G_ICARUS_SET` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_LERP2POS * sharedMem` with no vi | blocked | This body needs a view over `T_G_ICARUS_LERP2POS` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_LERP2ORIGIN * sharedMem` with no | blocked | This body needs a view over `T_G_ICARUS_LERP2ORIGIN` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_LERP2ANGLES * sharedMem` with no | blocked | This body needs a view over `T_G_ICARUS_LERP2ANGLES` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_GETTAG * sharedMem` with no view | blocked | This body needs a view over `T_G_ICARUS_GETTAG` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_LERP2START * sharedMem` with no  | blocked | This body needs a view over `T_G_ICARUS_LERP2START` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_LERP2END * sharedMem` with no vi | blocked | This body needs a view over `T_G_ICARUS_LERP2END` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_USE * sharedMem` with no view. | blocked | This body needs a view over `T_G_ICARUS_USE` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_KILL * sharedMem` with no view. | blocked | This body needs a view over `T_G_ICARUS_KILL` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_REMOVE * sharedMem` with no view | blocked | This body needs a view over `T_G_ICARUS_REMOVE` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_PLAY * sharedMem` with no view. | blocked | This body needs a view over `T_G_ICARUS_PLAY` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_GETFLOAT * sharedMem` with no vi | blocked | This body needs a view over `T_G_ICARUS_GETFLOAT` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_GETVECTOR * sharedMem` with no v | blocked | This body needs a view over `T_G_ICARUS_GETVECTOR` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_GETSTRING * sharedMem` with no v | blocked | This body needs a view over `T_G_ICARUS_GETSTRING` on the `gSharedBuffer` bytes. |
| vmMain | A pointer local `char * crap` with no view. | stands | The read set has no view or shape for this form. |
| vmMain | A pointer local `char ** morecrap` with no view. | stands | The read set has no view or shape for this form. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A read of `crap`, a local the draft left as a hole. | stands | The read set has no view or shape for this form. |
| vmMain | A pointer local `T_G_ICARUS_SOUNDINDEX * sharedMem` with no  | blocked | This body needs a view over `T_G_ICARUS_SOUNDINDEX` on the `gSharedBuffer` bytes. |
| vmMain | A read of `sharedMem`, a local the draft left as a hole. | blocked | This read needs the `sharedMem` local, which needs a view over the `gSharedBuffer` bytes. |
| vmMain | A pointer local `T_G_ICARUS_GETSETIDFORSTRING * sharedMem` w | blocked | This body needs a view over `T_G_ICARUS_GETSETIDFORSTRING` on the `gSharedBuffer` bytes. |
| vmMain | Raven passes `setTable` to `GetIDForString`, whose `table` p | stands | The guide has no shape for this form. |
| vmMain | A cast to `float *` the draft has no view for. | stands | The read set has no view or shape for this form. |
| vmMain | A cast to `const float *` the draft has no view for. | stands | The read set has no view or shape for this form. |
| vmMain | A cast to `float *` the draft has no view for. | stands | The read set has no view or shape for this form. |
| G_RegisterCvars | Raven walks `gameCvarTable` by pointer, and the hand table i | fills | The call passes the key path mapped through `world.storage`, with the nil overload for the NULL rows. |
| G_RegisterCvars | Raven walks `gameCvarTable` by pointer, and the hand table i | fills | The cv pointer is the index `cvIndex`, and the key path reads through `world.storage`. |
| G_RegisterCvars | Raven walks `gameCvarTable` by pointer, and the hand table i | fills | The test reads the row at `cvIndex`. |
| G_UpdateCvars | Raven walks `gameCvarTable` by pointer, and the hand table i | fills | The whole block reads and writes the row at `cvIndex`, and the cvar reads through `world.storage[keyPath:]`. |
| G_InitGame | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| G_InitGame | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| G_InitGame | Raven stores `level.gentities = g_entities`, and Swift holds | blocked | This statement needs a `gentitiesSlots` accessor on `Level`. |
| G_InitGame | The draft of this statement did not compile, and the compile | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| SortRanks | A pointer dereference the draft cannot place. | stands | The read set has no view or shape for this form. |
| SortRanks | A pointer dereference the draft cannot place. | stands | The read set has no view or shape for this form. |
| CalculateRanks | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| SendScoreboardMessageToAllClients | The draft of this statement did not compile, and the compile | fills | `g_entities + i` is `g_entities[i]`, because the parameter takes one record. |
| FindIntermissionPoint | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| DuelLimitHit | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| DuelResetWinsLosses | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| ExitLevel | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| G_LogPrintf | A pointer local `va_list argptr` with no view. | stands | The read set has no view or shape for this form. |
| G_LogPrintf | A read of `argptr`, a local the draft left as a hole. | stands | The read set has no view or shape for this form. |
| G_LogPrintf | A read of `argptr`, a local the draft left as a hole. | stands | The read set has no view or shape for this form. |
| G_LogPrintf | A read of `argptr`, a local the draft left as a hole. | stands | The read set has no view or shape for this form. |
| G_LogPrintf | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| CheckIntermissionExit | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| CheckIntermissionExit | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| CheckIntermissionExit | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| CheckExitRules | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| G_KickAllBots | The draft of this statement did not compile, and the compiler wrote "binary ope | fills | `level.clients + i` is `level.clientsSlots[i]`, the Slots index form. |
| CheckVote | The draft of this statement did not compile, and the compile | stands | The guide gives no shape for this compile error. |
| CheckCvars | A static local `lastMod` a statement reads before it writes, | blocked | This body needs a stored property for `lastMod` on `GameWorld` and a forward in `g_local.swift`. |
| CheckCvars | A read of `lastMod`, a local the draft left as a hole. | blocked | This read needs the stored property for `lastMod` on `GameWorld`. |
| G_GetStringEdString | A static local `text` the function returns, storage that out | blocked | This body needs a stored property for `text` on `GameWorld` and a forward in `g_local.swift`. |
| G_GetStringEdString | A read of `text`, a local the draft left as a hole. | blocked | This read needs the stored property for `text` on `GameWorld`. |
| G_GetStringEdString | A read of `text`, a local the draft left as a hole. | blocked | This read needs the stored property for `text` on `GameWorld`. |

This round ruled 74 Port-notes: 14 fills, 21 stands, and 39 blocked. The file holds 60 Port-notes and 60 lines with `portMissing(` after the round.

## The compile gate

The compile agent restored 0 fills. The compile agent made 0 signature fixes. The four cvar-table fills compiled as the transcriptor wrote them.

`swift build` finished with 0 errors. `swift test --no-parallel` passed 106 tests in four binaries: 78, 14, 13, and 1.

The file holds 60 `Port-note:` lines after the gate.
