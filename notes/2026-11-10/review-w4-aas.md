# Review of the S1 and S4 dead bodies

Scope: the commit 788395b7 in `/tmp/jka-s1` (branch `ded-bodies-s1`) and the commit 1d57c8a9 in `/tmp/jka-s4` (branch `ded-bodies-s4`). I compared each body with Raven's function, line by line.

Grades: DEFECT 0, SUSPECT 0, NOTE 5.

## NOTE 1: AAS_NearestEntity, `abs` on a float

- Swift `/tmp/jka-s1/Sources/JKAMP_DedLogic/be_aas_entity.swift:348`: `if abs(dir[0]) < 40 {`
- Raven `botlib/be_aas_entity.cpp:378`: `if (abs(dir[0]) < 40)`
- Effect: none. If Raven's call took `int abs`, the value is truncated toward zero first. For a finite value in the int range, `trunc(|x|) < 40` and `|x| < 40` give the same result, so the test is the same. The MSVC C++ `math.h` also gives a `float` overload. The two lines agree.

## NOTE 2: AAS_BarrierJumpTravelTime, the conversion from double to unsigned short

- Swift `/tmp/jka-s1/Sources/JKAMP_DedLogic/be_aas_reach.swift:917`: `return Int32(UInt16(truncatingIfNeeded: Int32(Double(aassettings.phys_jumpvel) / (Double(aassettings.phys_gravity) * 0.1))))`
- Raven `botlib/be_aas_reach.cpp:760`: `return aassettings.phys_jumpvel / (aassettings.phys_gravity * 0.1);`
- Effect: The double step is correct, because `0.1` widens the expression. The conversion truncates toward zero and wraps to 16 bits, as MSVC's `_ftol` plus the narrowing does, also for a negative value. The two differ only when the quotient is NaN, infinite (gravity 0), or at least 2^31. There Swift traps and the 32-bit build returns 0. C leaves this conversion undefined. With the default settings (270 / 80), both return 3.

## NOTE 3: The size of a pointer in the define hash table

- Swift `/tmp/jka-s4/Sources/JKAMP_DedLogic/l_precomp.swift:1133` and `:2579`: `GetClearedMemory(DEFINEHASHSIZE * Int32(UInt.byteCount))`
- Raven `botlib/l_precomp.cpp:1337` and `:3097`: `GetClearedMemory(DEFINEHASHSIZE * sizeof(define_t *))`
- Effect: The Swift table holds 8-byte host pointers, so the request is twice Raven's 32-bit size (`DEFINEHASHSIZE * 4`). This is the same text as the existing `LoadSourceFile` at `:2526` and `:2545`. The slots must hold host pointers, so 8 is necessary, not a defect of the new body. The only effect is the byte count that the botlib memory accounting sees. The new `PC_CopyDefine` at `:1248` (`Int32(Define.byteCount)`) follows `PC_Directive_define` at `:1033` in the same way. If the wave's earlier size finding gave a ruling about allocation sizes in general, these four sites come under it.

## NOTE 4: CRC_ProcessByte, the parameter `byte` as `Int32`

- Swift `/tmp/jka-s4/Sources/JKAMP_DedLogic/l_crc.swift:72`: `crcvalue = UInt16(truncatingIfNeeded: (Int32(crcvalue) << 8) ^ Int32(crctable[(Int32(crcvalue) >> 8) ^ data]))`
- Raven `botlib/l_crc.cpp:87`: `*crcvalue = (*crcvalue << 8) ^ crctable[(*crcvalue >> 8) ^ data];`
- Effect: The body is correct. The shift and XOR are done in int and narrowed at the store, and the index is in 0 to 255. The stub's signature (`_ data: Int32`, line 70) does not narrow at the call, as C narrows to `byte`. A caller that passes a value outside 0 to 255 would index out of range or trap. No caller exists. This is a signature matter, not a body matter.

## NOTE 5: AAS_SetMovedir, the NULL outputs

- Swift `/tmp/jka-s1/Sources/JKAMP_DedLogic/be_aas_move.swift:255`-`257`: `var scratchRight = vec3_t()` ... `AngleVectors(angles, &movedir, &scratchRight, &scratchUp)`
- Raven `botlib/be_aas_move.cpp:229`: `AngleVectors(angles, movedir, NULL, NULL);`
- Effect: none. Raven's AngleVectors skips a NULL output, and the Swift locals are discarded. `movedir` gets the same value.

## Ruled changes checked

- `pw`, `/tmp/jka-s4/Sources/JKAMP_DedLogic/cm_polylib.swift:57` `// AI: Raven called the C printf. The backend writes the bytes of the formatted text to standard output.` against `qcommon/cm_polylib.cpp:22`. This is true: `SysBackend.printf` (`JKAMP_Ded/SysBackend.swift:249`) writes the buffer up to its NUL to `STDOUT_FILENO`.
- `PC_CopyDefine`, `l_precomp.swift:1250` `// AI:` (the name goes in the string pool). This is true against `l_precomp.cpp:1486`-`1487`. It is the same form as `PC_Directive_define` at `:1032`.

## Other checks with no finding

- The `DEFINEHASHING` arm is live (`l_precomp.cpp:83` `#define DEFINEHASHING 1`). `PC_DefineFromString`, `PC_AddDefine`, and `LoadSourceMemory` take the hashing arms. `PC_DefineFromString` takes `#ifdef DEFINEHASHING` (line 1356) as live, which is correct. `PC_RemoveGlobalDefine` returns 0, which is correct because its body is under `#if !DEFINEHASHING`.
- `PC_DefineFromString`: `if (src.defines) PC_FreeDefine(def)` stays as written. `src.defines` is never set in the hashing arm, as in Raven.
- Pointer aliases: `AasCluster`, `AasPortal`, `AasEntity`, `BspEntdata`, `Source`, `Token`, and `Define` are handle views. Writes through `cluster.numareas`, `portal.clusterareanum[n]`, `entdata.*`, `newdefine.*`, `source.*`, and the token chains reach Raven's memory. `clusterareanum` is a `Slots<Int32>` over the record (`AasPortal.swift:82`). In `AAS_NumberClusterPortals`, `cluster.numareas++` is a store after the read, as in C.
- `PC_CheckTokenType`: the scratch `tok` is safe, because `PC_UnreadSourceToken` copies the token (`l_precomp.swift:268`). `token.copy(from:)` is Raven's `Com_Memcpy`.
- `AAS_TestMovementPrediction`: `0.1` goes to a `Float` parameter, the same as `0.1f`. `dir` is `inout`, so the caller sees the normalization and `dir[2] = 0`, as in Raven.
- `AAS_NearbySolidOrGap`: the `VectorMA` scale 48 and 64 are float multiplies in both bodies.
- `AAS_inPVS`: the copies are given to the engine import. Raven passes pointers, and the engine only reads them.

## Functions read

S1: AAS_inPVS, AAS_inPHS, AAS_BoxEntities, AAS_BSPTraceLight, AAS_ClearCluster, AAS_RemovePortalsClusterReference, AAS_NumberClusterPortals, AAS_RemoveAllPortals, AAS_EntityOrigin, AAS_EntitySize, AAS_EntityBSPData, AAS_NearestEntity, AAS_BestReachableEntityArea, AAS_SetMovedir, AAS_AirControl, AAS_TestMovementPrediction, AAS_AreaLiquid, AAS_BarrierJumpTravelTime, AAS_NearbySolidOrGap (19).

S4: PC_PrintDefineHashTable, PC_FindDefine, PC_DefineFromString, PC_AddDefine, PC_RemoveGlobalDefine, PC_CopyDefine, PC_CheckTokenType, PC_SkipUntilString, PC_SetPunctuations, LoadSourceMemory, CRC_ProcessByte, pw (12).

## Functions not read

None of the scope was skipped. I did not read the bodies of the callees that existed before this wave, such as `PC_Directive_define`, `AAS_PredictClientMovement`, `JKAShared.format`, and the `scratch` helpers. I did not read their full bodies again. I checked only their signatures and the parts that the new bodies depend on.
