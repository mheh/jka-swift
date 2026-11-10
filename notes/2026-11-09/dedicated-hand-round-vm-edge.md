# The hand round of the vm edge of the dedicated host

This record holds the hand round of the three rows at the edge between the dedicated server and the game module: V2, SV3, and FC3 of `dedicated-open-rows-ledger-8.md`. The user delegated the rulings. Each row has its proof at Raven's line and the Swift line, and it takes the nearest form that the codebase already has. The landing is the branch `ded-hand-vm-edge`, off master at `837bc43`, in the worktree `/tmp/jka-vm-edge`. The round changes no generator.

## Row V2, the system call thunk

Proof: Raven passes the C function SV_GameSystemCalls to VM_Create at `server/sv_game.cpp:1750`, and VM_Create stores it in `vm->systemCall` at `qcommon/vm.cpp:506`. Raven's VM_DllSyscall calls `currentVM->systemCall( args )` at `qcommon/vm.cpp:376`. In Swift, VM_Create takes `VmSystemCall?`, a C function over the words (`Sources/JKAMP_Ded/Generated/Views/Callbacks.swift:332`). SV_GameSystemCalls takes `Slots<Int32>` (`Sources/JKAMP_DedLogic/sv_game.swift:408`). The C VM_DllSyscall calls `jka_systemCall` (`Sources/CJKAHost/jka_host.c:25`), and before this round the shell did not set it.

Verdict: ratified, delegated, 2026-11-09. Pattern: `LoadLibrary`, a closure in the view target that the shell installs (`Sources/JKAMP_Ded/VmEntry.swift:110`, at `:72` on master), and the shell form at `Sources/jampded/main.swift:22`.

- `GameSystemCalls` (`VmEntry.swift:87`) is the closure. The shell sets it to SV_GameSystemCalls at `main.swift:26`. SV_GameSystemCalls is public for this, under one rule 24 line.
- `SV_GameSystemCallThunk` (`VmEntry.swift:93`) is the C function. It reads the 16 words of VM_DllSyscall through `Slots(syscallWords:count:)` (`Sources/JKAMP_Ded/GameViews.swift:13`) and calls the closure.
- SV_InitGameProgs passes the thunk to VM_Create at `sv_game.swift:1071`.
- The shell sets `jka_systemCall` to the thunk at `main.swift:29`. Raven calls the systemCall of `currentVM`. The dedicated host loads one module, the game, so the callee is the game thunk, under one rule 24 line.
- `jka_host.h:19` marks the C global `jka_systemCall` with `swift_attr("nonisolated(unsafe)")`. The Swift 6 check rejects a write to a C global from the shell without it. The shell writes it once at its entry, the same posture as `LoadLibrary`.

## Row SV3, the vector arguments of VM_Call

Proof: GNavCallback_NAV_ClearPathToPoint, GNavCallback_NPC_ClearLOS, and GNavCallback_NAVNEW_ClearPathBetweenPoints pass the addresses of `vec3_t` parameters through VM_Call at `server/NPCNav/gameCallbacks.cpp:8`, `:13`, and `:18`. The module arms at `game/g_main.c:672` to `:677` give the words to NAV_ClearPathToPoint, NPC_ClearLOS2, and NAVNEW_ClearPathBetweenPoints. These callees only read the vectors: NAV_ClearPathToPoint copies `pmins` and `pmaxs` into locals at `game/g_nav.c:247` and `:248`, NPC_ClearLOS2 takes `const vec3_t`, and NAVNEW_ClearPathBetweenPoints passes them to trap_InPVS and trap_Trace at `game/g_navnew.c:63` and `:68`. The Swift game shell reads each vector by value with `vector(at:)` (`Sources/jampgame/jampgame.swift:249`).

The three candidates:

- (a) The generated trap thunks make the address with `withUnsafePointer(to:)` around the call, for example trap_Trace at `Sources/JKAMP_Game/Generated/g_syscalls.swift:254` to `:258`. The address lives for the closure. This is the form.
- (b) The `scratch` forms of the generated views exist only for records, for example `Vm.scratch` at `Sources/JKAMP_Ded/Generated/Views/Vm.swift:34`. No view has a vector scratch.
- (c) The `FormatArg` cases are `integer`, `floating`, and `text` (`Sources/JKAShared/Format.swift:13`). An address goes through `integer` as an `Int` word with no new case.

Verdict: ratified, delegated, 2026-11-09. Pattern: (a) with (c), `withUnsafePointer` of `g_syscalls.swift:254` and the `Int` word of `Format.swift:36`.

- `withVectorWords` (`VmEntry.swift:78`) copies the vectors into one array and gives the body the address of each copy as an `Int` word for the life of the body. Rule 11 holds, because the step is in the view target.
- The three callbacks call VM_Call inside the body at `gameCallbacks.swift:9`, `:17`, and `:26`, each under one rule 24 line. ClearPathBetweenPoints narrows the word of VM_Call to its `int` return.
- VM_Call keeps pointer-wide words (`vm.swift:812`), by the PR 82 ruling that VM_Call returns the pointer-wide word. The dll arm hands them whole to `runEntryPoint`, which now takes `[Int]` (`VmEntry.swift:15`). The QVM arms narrow each word to `Int32` at `vm.swift:838` and `:841`.

## Row FC3, the full-width read

Proof: VM_ArgPtr and BotVMShift read `dataBase + intValue` on the dll arm at `qcommon/vm.cpp:649` and `:671`, and VM_ExplicitArgPtr reads it at `:753` and `:756`. A dll module has a NULL `dataBase`, so the sum is the word itself, and an `int` word holds an address only on a 32-bit build. PR 84 gave VM_ArgPtr and BotVMShift the RETURNS kind `optional_raw`.

Verdict: ratified, delegated, 2026-11-09. Pattern: `Vm.shifted` and `Vm.unshifted` of row V6 (`VmEntry.swift:47`, `:54`), the same full-width sum over `dataBase`.

- `Vm.address(at:)` (`VmEntry.swift:62`) gives `UnsafeMutableRawPointer?`, and its overload at `:69` gives the text at the address as `String?` for VM_ExplicitArgPtr, the overload-by-return form of `VMA` in `GameViews.swift`.
- The ten holes are filled: the four NULL returns are `return nil`, and the six arms call `address(at:)` at `vm.swift:687`, `:689`, `:705`, `:707`, `:774`, and `:777`. The QVM arm of VM_ExplicitArgPtr widens the mask to the pointer-wide word under one rule 24 line.

## The checks

- `swift build -j 2`: the first build exited 1 with one error, the concurrency check on the write to `jka_systemCall` in `main.swift`. The header attribute fixed it, and the second build exited 0. The touched files have no warnings.
- `swift test --no-parallel -j 2`: exit 0, 147 tests in 9 runs, 0 failures.
- `.build/debug/jampded < /dev/null`: exit 133. The run stops in Com_Init at the `portMissing` hole of CM_ClearMap (`qcommon/cm_load.cpp:791`), after FS_Startup, before the server reaches SV_InitGameProgs.

## The portMissing count

- `vm.swift`: 10 fewer, 4 left, all dead by rule 20.
- `gameCallbacks.swift`: 3 fewer, 0 left.
- `sv_game.swift`: 1 fewer, 8 left.

## The open rows

None of the three rows stays open. One fact for a later round: SV_GameSystemCalls returns `Int32`, so a trap that returns an address to a dll module, such as TRAP_STRNCPY, loses the high half of the address on a 64-bit host. This is outside the three rows.
