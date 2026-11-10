# Float semantics of retail `jampded`, and what follows for the port

Investigation of 2026-11-10. Nothing in the repo, its submodules, or `/Users/milohehmsoth/Developer/jka/` was changed. Scratch files are in `/tmp/float-inv/`. No worktree was made and no host variant was built (see section 5).

Words used here:

- Model A: strict `float`, one rounding for each operation. The Swift, and the fork with `-ffp-contract=off`.
- Model B: the fused arm64 code of the usual fork build.
- Model C: retail x87. C53 is x87 with a 53-bit mantissa (Windows, inferred). C64 is x87 with a 64-bit mantissa (Linux, measured).

## 1. What retail computes

### 1.1 There are two retail servers, and only one is on this machine

- Measured: the only retail server binary on this machine is the Linux one, `/Users/milohehmsoth/Developer/jka/jka_server/linuxjampded` (ELF 32-bit i386, stripped, sha1 `e7d084d5e36c16d7334df93a9e52afec1e094339`).
- Measured: no `jampDed.exe`, `jampded.exe`, or `jamp.exe` is under `/Users/milohehmsoth/Developer/jka/` (`find -iname "*.exe"` returns nothing), and Spotlight finds none. The repo notes name no path of one. So every statement about the Windows binary below is an inference from project files, not a measurement.
- The file `jka_server/openjkded.i386` in the same folder is an OpenJK build, not retail.

### 1.2 The Linux retail binary: Intel compiler, x87, 64-bit mantissa (measured)

- The brief says the Linux binary was built by gcc. That is wrong. The `.comment` section holds the compiler command line of each object: `Intel(R) C++ Compiler for 32-bit applications, Version 5.0.1 Build 010730D0 : ..//server/sv_game.cpp : -I/opt/intel/compiler50/ia32/include -tp p6 -long_double -D__int64=long long -DDEDICATED -DC_ONLY -D_JK2 -D_M_IX86 -Kc++ -w -DNDEBUG -O2 -unroll -DFINAL_BUILD -use_msasm`. 79 objects have this flag set and 28 have the botlib set (`strings -a linuxjampded`). The four `GCC: (GNU) 2.95.3` strings are the C runtime start files. Raven's makefile agrees: `oracle/codemp/unix/makefile:106` (`NEWPGCC=/opt/intel/compiler50/ia32/bin/icc`), `:113` (`-O2 -unroll`). The folder also holds Intel's runtime `libcxa.so.1`.
- No SSE scalar code. Mnemonic counts of the `.text` section (`/tmp/float-inv/lx.dis`): `fld` 6726, `fstp` 5289, `fmul` 2603, `fmulp` 477, `fadd` 1173, `faddp` 1324, `fsub` 1022 (plus 597 other subtract forms), `fcom`/`fcomp`/`fcompp` 1474, `mulss` 0, `addss` 0, `movss` 0. One `movaps` is in a library routine.
- The end point line of `CM_Trace` (`oracle/codemp/qcommon/cm_trace.cpp:1819`). `esi` is `trace`, `[esi+0x4]` is `fraction`, `eax` is `start`, `edx` is `end`:

```
 807221c: fld   dword ptr [esi + 0x4]      ; fraction
 807221f: fcom  dword ptr [0x81a0564]      ; == 1 ?
 8072228: je    0x8072285                  ; VectorCopy arm
 8072230: fld   dword ptr [eax]            ; start[0]
 8072232: fld   dword ptr [edx]            ; end[0]
 8072234: fsub  st, st(1)                  ; end - start, in the register
 8072236: fmulp st(2), st                  ; * fraction, in the register
 8072238: faddp st(1), st                  ; + start, in the register
 807223a: fstp  dword ptr [esi + 0x8]      ; the one rounding to float
 807223d: fld   dword ptr [eax + 0x4]
 8072240: fld   dword ptr [edx + 0x4]
 8072243: fsub  st, st(1)
 8072245: fmul  dword ptr [esi + 0x4]
 8072248: faddp st(1), st
 807224a: fstp  dword ptr [esi + 0xc]
```

- A `DotProduct` expansion in the same file's code range (133 windows of this exact eight-instruction shape are in the binary, `/tmp/float-inv/finddot.py`):

```
 80727c4: fld   dword ptr [ecx + 0xc]
 80727c7: fmul  st, st(4)
 80727c9: fld   dword ptr [ecx + 0x10]
 80727cc: fmul  st, st(4)
 80727ce: faddp st(1), st
 80727d0: fld   dword ptr [ecx + 0x14]
 80727d3: fmul  st, st(2)
 80727d5: faddp st(1), st
 80727d7: fcomp st(2)                      ; the compare uses the unrounded sum
```

  Two more facts are visible here. The second operand comes from the register stack (`st(4)`, `st(2)`), so an operand can itself be an unrounded value that never went through a `float` store. And the result goes into a compare (`fcomp`) or a subtract (`fsubr dword ptr [edx + 0xc]` at `8070226`, `fsub st, st(1)` at `8071813`) before any store, so branches are taken on unrounded values.
- The precision control. `main` is at `0x80c5914` (the argument pushed at `804a1f7` for `__libc_start_main`), and its first instructions hold no `fldcw`. `Sys_ConfigureFPU` (`oracle/codemp/unix/unix_main.c:1075-1095`) is empty unless `__linux2__` is defined, and with `NDEBUG` it only loads `_FPU_DEFAULT`, which is the same 64-bit setting. Only one object was compiled with `-D__linux2__` (`vm_x86.cpp`, from the `.comment` text). The 196 `fldcw` in the binary are float-to-integer conversions that save and restore the word (for example `814ec52`-`814ec5e`, the routines of `oracle/codemp/unix/ftol.nasm:52-55`). So the effective word is the Linux i386 process default, `0x037F`: round to nearest, 64-bit mantissa. Inference from the kernel default, not read from a running process.
- Spills. In the two quoted sites no value goes to memory mid-expression. In general a spill is the compiler's choice at each site: it depends on the optimization level, on register pressure, and on calls (a call empties the register stack). It is not visible in the source text.

### 1.3 The Windows retail binary: x87 at 53 bits (inferred, not measured)

Read from `oracle/codemp/WinDed.vcproj`:

- `:4` `Version="7.00"`. This is the project format of Visual Studio .NET 2002 (compiler 13.00). The coordinator wrote "MSVC of 2003". The project file says 2002 format. Which compiler made the shipped binary is not verified.
- Two configurations only, `Release|Win32` (`:16`) and `Debug|Win32` (`:81`). There is no `Final` configuration in this project, no property sheet, and no `FileConfiguration` override (count 0).
- Release: `GlobalOptimizations="TRUE"` (`:25`, `/Og`), `InlineFunctionExpansion="2"` (`:26`, `/Ob2`), `EnableIntrinsicFunctions="TRUE"` (`:27`, `/Oi`), `ImproveFloatingPointConsistency="FALSE"` (`:28`, no `/Op`), `FavorSizeOrSpeed="1"` (`:29`, `/Ot`), `OptimizeForProcessor="2"` (`:30`, `/G6`), output `Release/jampDed.exe` (`:51`). No `Optimization` attribute and no `EnableEnhancedInstructionSet` attribute are present. The 7.00 compiler has no `/arch` option at all (it came with 7.10); from memory, not verified here.
- The older `oracle/codemp/WinDed.dsp:45` has `/O2` for Release.
- `oracle/codemp/JKA_mp.sln:94-97`: the WinDed project has `ActiveCfg` lines and no `Build.0` line in any solution configuration, and `Final` maps to `Debug|Win32`. So the solution never builds WinDed, and the shipped `jampDed.exe` came from a manual build of this project. Release is the only optimized configuration, so it is the most likely source. Not verified.
- The game and client projects differ from WinDed: `oracle/codemp/game/JK2_game.vcproj:26` and `:97`, and `oracle/codemp/jk2mp.vcproj:28` and `:161`, set `ImproveFloatingPointConsistency="TRUE"` (`/Op`). The WinDed engine sets it `FALSE`. With `/Op` the compiler stores a value to memory at each assignment (it rounds there); without it, a value can stay in a register across statements.
- Precision control in Raven's source: the only `_controlfp` calls are commented out, `oracle/codemp/null/win_main.cpp:1485` (the file WinDed links) and `oracle/codemp/win32/win_main.cpp:1591`: `//		_controlfp( _PC_24, _MCW_PC );` under the comment "set low precision every frame". No other `_controlfp`, `_control87`, or `fldcw` is in `oracle/codemp` outside `unix/`. The dedicated server links no Direct3D (dependencies at `WinDed.vcproj:50`: `odbc32.lib odbccp32.lib wsock32.lib Winmm.lib`).
- So the effective word is the MSVC runtime default, 53-bit mantissa. This is from memory of the MSVC runtime (`_CW_DEFAULT` holds `_PC_53` on x86), not verified on this machine.
- A point of history that matters: id's line set 24-bit precision each frame. With 24 bits, each x87 add, subtract, multiply, and divide rounds to `float`, which is model A. Raven's tree has that line commented out, so Raven's Windows server does not run in model A.

### 1.4 How retail evaluates the two expressions

- `x0*y0 + x1*y1 + x2*y2`: each product and each sum is in an x87 register at the control word's precision (64 bits on Linux, measured; 53 bits on Windows, inferred). A product of two `float` values is exact in 53 bits. Each of the two sums rounds once to the register precision. The result rounds to `float` only when a `fstp dword` stores it. If the result goes into a compare or a further operation first, it is never rounded to `float`. The operation order on Linux is left to right (the quote above). The order in the Windows binary is not verified.
- `start + fraction * (end - start)` stored to a `float`: the difference, the product, and the sum stay in the register, and one `fstp dword` rounds (Linux, measured at `8072230`-`807223a`). Windows: the same in kind is expected with no `/Op`; not verified.
- Dependence on optimization: yes. A debug build stores each temporary. An optimized build stores when the compiler decides. Two compilers (MSVC, Intel) decide differently, so the two retail servers can differ from each other at sites where one spills and the other does not, and where 53 and 64 bits differ.

### 1.5 The coordinator's two claims

- Withdrawn claim, first half, "Raven's x86 build had no fused instructions": true for the Linux binary (measured: no FMA instruction; the build targets `-tp p6`). For Windows it is true by the age of the compiler; not measured.
- Withdrawn claim, second half, "so the fork with the flag calculates as Raven's build did": false. Section 2 measures it.
- Corrected claim, "x87 keeps intermediate results at higher precision and rounds to `float` once at the store, a third way that agrees with neither": correct in kind, and now measured for the Linux binary. Two corrections: the project file is the 2002 format, not 2003; and retail is not one model but two (C53 and C64), with compiler-chosen spill points in each.

## 2. The three models, measured

### 2.1 What exactly fuses in model B

From `/tmp/fma-test/usual.dis`:

- `DotProduct` (`0x100036b20`): `fmul s1, s1, s3` (x1*y1, rounded), `fmadd s0, s0, s2, s1` (x0*y0 + that, one rounding), `fmadd s0, s1, s2, s0` (x2*y2 + that, one rounding). So B is `fma(x2, y2, fma(x0, y0, round(x1*y1)))`.
- `CM_Trace` (`0x10000a698`): `fsub s2, s2, s1` (end - start, rounded to `float`), `fmadd s1, s0, s2, s1`. So B is `fma(fraction, round(end - start), start)`.

### 2.2 The program

`/tmp/float-inv/models.c`, built with `clang -O1 -arch x86_64 -ffp-contract=off`, run under Rosetta. Model A is SSE `float` code with a store after each operation. Model B is `fmaf` in the association above. Model C is real x87 code through `long double`, in the Linux binary's operation order, once with the control word `0x027F` (53 bits) and once with `0x037F` (64 bits). A fifth column computes with `double` and one final conversion.

- Check that Rosetta obeys the precision field (`/tmp/float-inv/pc.c`): at `0x027F`, `1 + 2^-60 == 1` is true; at `0x037F` it is false. Measured.
- Is the `double` emulation of C53 exact? Measured: 0 differences from the real x87 C53 code in 80,000,000 samples. In theory it is exact for these expressions: x87 at 53 bits differs from `double` only in the exponent range (overflow and underflow), which map values never reach.
- Do C53 and C64 differ? Measured: 0 differences in 80,000,000 samples. In theory they differ only in a double rounding case, when the 53-bit sum falls exactly on the midpoint between two `float` values and the 64-bit sum does not; the chance is of the order of 2^-28 for each sample. So for these two expressions the Windows and the Linux model give the same bits in practice, when the inputs are the same.

### 2.3 Results (10,000,000 samples for each row, `/tmp/float-inv/models.out`)

`DotProduct`, coordinates uniform in plus or minus 65536:

| Normal | A vs B | A vs C | B vs C |
|---|---|---|---|
| random unit vector | 34.25 % | 42.93 % | 32.85 % |
| axial (one component is 1 or -1) | 0 | 0 | 0 |

Of the differing cases, 75 to 79 % are 1 ULP and 93 % are 4 ULP or less. The maximum is 903,696 ULP (A vs B) and 781,810 ULP (A vs C); these are results near zero after cancellation, and the largest absolute difference is 0.0156. Coordinates on a 1/8 grid give the same rates.

End point line, fraction uniform in 0 to 1:

| Start range, end | A vs B | A vs C | B vs C |
|---|---|---|---|
| plus or minus 65536, end within 64 units | 0.108 % | 0.111 % | 0.015 % |
| plus or minus 4096, end within 64 units | 1.18 % | 1.22 % | 0.24 % |
| plus or minus 512, end within 64 units | 6.07 % | 6.41 % | 1.96 % |
| any range, end anywhere in the range | 30.7 % | 35.0 % | 24.8 % |

For the short traces, 88 to 96 % of the A-C and A-B differences are 1 ULP. B and C are near each other at this line because both keep the product unrounded.

Reading: the three models are three different functions. For a non-axial plane, A and retail's arithmetic give different bits in about 4 of 10 dot products. Axial planes, which are most of a map's brush sides, give the same bits in all three.

### 2.4 Real values

Not done. `ref_trace` records only the integer arguments of each boundary call (`/tmp/referee-run/dump/c.log`: `REF T 1 OUT 40 0 37911201300 ...`, pointer values), so no file on this machine holds the float inputs of a trace. A capture needs a probe in a host, which is a build.

### 2.5 What the frame counts of `/tmp/fma-test` say next to these rates

The fused `DotProduct` alone changes only 3 of 2400 frame checksums, and the end point line alone starts a difference at frame 27 (the brief's numbers). The per-call difference rates above are much higher than the per-frame rates, because most planes on `mp/ffa1` are axial and because a 1 ULP change usually disappears in a later rounding or a snap. A model C host was not run, so the number of frames that model C changes is not measured.

## 3. What follows for the port

### P1: strict `float` is the faithful form, and bit-equality with retail is not a goal

The evidence supports P1 as the description of what the project already does. It was not, as far as the documents show, a ruling made with x87 in view.

- Every oracle the project has used is model A, by a flag chosen for that purpose. jka-rust's golden harness compiles Raven's C with `-ffp-contract=off` (`jka-rust/tools/jampgame-oracle/run.sh:92`, `:106`, `:125`, `:143`; `run_qshared.sh:42`), on a 64-bit host. Its referee oracle states "FP regime flags (this defines parity)": `-fno-fast-math -ffp-contract=off -O2` (`jka-rust/tools/referee-oracle/README.md:65-77`), with the reason that rustc does not contract. `notes/2026-11-03/dedicated-scout.md:320` records the same.
- Rule 18 says the goldens come from those harnesses unchanged and "Every float compares as its bit pattern" (`docs/porting-rules.md:43`). Rule 16 names them as the proof of a `bg` or `q_math` step (`:36`). So the committed goldens are the output of Raven's source compiled natively in model A. They did not come from retail and not from a 32-bit run. The Swift port reproduces them byte for byte, so the port is already bit-equal to "Raven's source under strict IEEE types", and that is a different thing from retail's binary.
- Rule 16 itself says retail cannot be the engine of a proof (`docs/porting-rules.md:36`: "retail `jamp` cannot load a 64-bit module").
- `docs/transcription.md:633-636` fixes the evaluation model at the type C gives each operand: "`(150 + pml.frametime) * 0.003` is `Double(150 + pml.frametime) * 0.003`, because C adds in float". That is `FLT_EVAL_METHOD` 0. Under x87, that add is not in `float`. So the guide's rule and retail's arithmetic already differ in the game module, and the whole game, cgame, and bg port follows the guide.
- No document under `docs/` or `notes/` rules on x87 excess precision. The only x87 rows are the `fistp` rounding of `SnapVector` (`notes/2026-11-09/dedicated-open-rows-ledger-6.md:206`, `notes/2026-11-09/dedicated-round-wave6-hand.md:61`), where the port does follow the x87 instruction because Raven wrote it as inline assembly, that is, as source text.
- Rules 19 and 20 do not cover this. Rule 19 allows a divergence only where Raven's behaviour is undefined; excess precision is not undefined behaviour, it is implementation-defined evaluation. Rule 20 preserves "emergent per-mode quirks"; one can argue that x87 results are such a quirk, but the rule's text is about MP against SP source, not about compilers.
- "Can reach": bit-equality with retail is not reachable from the source text. The spill points and the unrounded compares are compiler decisions at each site (section 1.2), the two retail servers use two compilers and two precisions, and no rule in the source says which value is rounded where. A port could reach it only by transcribing a disassembly, function by function, for one chosen binary.

### P2: emulate retail (double intermediates, one rounding at each store) at engine sites

- It would not reproduce retail. "Double intermediates within one expression, rounding at each store" is the model of a debug build or of `/Op`. The measured Linux binary keeps unrounded values across statements, passes them as operands of the next `DotProduct` (`fmul st, st(4)`), and compares them unrounded (`fcomp st(2)` at `80727d7`). The Windows engine has no `/Op` (`WinDed.vcproj:28`), so the same is expected there. An emulation by expression is a fourth model, not model C.
- Size. The retail Linux engine holds about 3,080 x87 multiplies, 2,497 adds, 1,619 subtracts, and 1,474 compares (section 1.2). The Swift engine target has 178 `DotProduct(` call sites (`Sources/JKAMP_DedLogic`), the game logic 120, bg 30, cgame logic 19, and each other multi-operation `float` expression is a site too. The number of such expressions was not counted.
- Rules and legibility. Each site becomes `Float(Double(a) * Double(b) + ...)`. This is the cast form that the "no casts in bodies" memory and the legibility goal work to remove, and `docs/transcription.md:633` reserves the `Double(...)` widening for places where C's own types are `double`. A helper such as a `Double` `DotProduct` has no Raven counterpart, which the "no new helper litter" rule forbids. `Sources/JKAShared/q_math.swift:929` would no longer read as Raven's line.
- The game module has the same question. Retail's game module is the same C under the same compilers, with `/Op` on Windows (`JK2_game.vcproj:26`, `:97`), so its expressions are also evaluated above `float` precision. The game, cgame, and bg are ported in model A and their goldens are model A. An engine-only emulation would make the engine follow one model and the game another, and the bg goldens would have to be made again from a different oracle build to stay a proof.
- No proof exists for it. No reference on this machine runs model C with the referee's commands: the fork is the only host with `ref_step`, and it is 64-bit. So a model C port would have no green run to claim.

The evidence does not support P2 as a way to reach retail equality. It could be chosen as an approximation; its cost is every `float` expression in the engine and no available proof.

### P3: the reference choice

- `-ffp-contract=off` on the fork is the right reference for the question the referee can answer: "does the Swift engine compute what the C source says, under the same evaluation model as the Swift". It is the same flag by which every earlier oracle of this project was defined (P1). The usual fork build is not a better reference: model B is an arm64 clang default, it matches no Raven build, and it is as far from retail as model A is (section 2.3).
- The reason on record for the ratified choice should change. "It calculates as Raven's build did" is false. The reason the evidence supports is: "it removes a compiler transformation that neither Raven's source nor Raven's builds have, and leaves both hosts in the one model that the port's rules and goldens already use".
- The claim a green run supports, in one sentence: for the 2400 recorded frames of `corpus-ffa1.rec` with one Swift game module in both hosts, the Swift engine and the OpenJK engine at `35e4184f`, both evaluating each `float` operation with one IEEE rounding and no contraction, produce the same entity and player state checksum after each frame.
- What it does not prove: equality with retail `jampDed.exe` or `linuxjampded` in any frame; equality with Raven's engine where OpenJK changed the source (row H9 covers that by a row for each traced difference); anything about code paths the corpus does not run; anything about the game module, because both hosts share it.
- H14's text ("the binary serves as it is") is changed by the ratified choice; `notes/2026-11-10/rows-13-eng.md:50` gives the candidate with the false reason "matches Raven's MSVC build, which did not fuse". That line is the one to correct if the record is to be exact.

### How the other projects treat this

- jka-rust: no `mul_add` and no emulation of x87 arithmetic anywhere under `jka-rust/crates` (search for `mul_add`, `fma`, `x87`, `excess precision`: the only x87 hits are the `fistp` rounding notes, `crates/mp/game/src/g_weapon.rs:4330`, `crates/mp/renderer/src/tr_shade_calc.rs:507`). Its ruling is the README text quoted in P1: parity is defined against Raven's C compiled without contraction and without fast math. It does not mention x87. It follows the unix build in other points (`notes/2026-11-10/rows-13-eng.md:39`, the `f64` `M_PI`).
- OpenJK: its own x86 builds leave x87. `openjk/CMakeLists.txt:228` and `:231` set `/arch:SSE2` for MSVC, `:266-267` set `-msse2`, and `:286` and `:309` set `-mfpmath=sse` for GNU on x86. It sets no `-ffast-math`, no `-ffp-contract`, and no `/fp:` option. So an OpenJK x86 server is model A (SSE2 has no fused instruction), and OpenJK on arm64 clang is model B by the compiler default, not by a decision in the build files. OpenJK servers and clients of both kinds interoperate with retail clients; the protocol sends state, and prediction error is corrected, so bit-equality between builds was never a requirement of the game.
- Documented desync or physics differences between x87 and SSE builds in ioquake3 or OpenJK: nothing was found in the trees (`openjk/CMakeLists.txt` carries only the ioquake3 comment on `-mstackrealign`, `:281-284`). No web search was done. Not verified.

## 4. Ground truth from retail: what is possible and what it costs

Nothing here was set up.

- The retail game module is irrelevant to the referee question, because both referee hosts load the Swift module. It is relevant to P2 only as the reminder that the game has the same x87 question.
- Retail cannot replay the corpus. `ref_step` and the replayer are fork code (`openjk/codemp/server/sv_referee.cpp`), and retail cannot load the 64-bit Swift module. So no retail run gives a frame checksum to compare. Ground truth from retail is available only at the level of single expressions or single functions.
- The x87 arithmetic of the two expressions is already measured by `/tmp/float-inv/models.c`: real x87 instructions under Rosetta, in the operation order read from the Linux binary. A 32-bit build would add nothing for these two expressions.
- Running `linuxjampded` itself: Docker is installed and its daemon runs (server 29.8.2, aarch64), with amd64 images present (`debian:trixie`, others) and a `Dockerfile` for exactly this server in `/Users/milohehmsoth/Developer/jka/jka_server/Dockerfile` (ubuntu 20.04, `libc6:i386`, `libcxa.so.1`, `gdb-multiarch`). No built image of it is in `docker images`. Cost: one image build with network access, then a server run under emulation, then `gdb` breakpoints at `0x807223a` and at a `DotProduct` site to print operands and results. That gives real retail values for chosen functions on a live map. It is some hours of work, and it depends on the emulator's x87 being exact (Rosetta obeyed the precision field in the one test here; qemu was not tested).
- The Windows binary: not on this machine. If the user supplies `jampDed.exe`, a static disassembly answers section 1.3 in minutes (the reverse-engineering tools of this session open PE files; not tried). An image named `nfshp2-wine:trixie-amd64` is in `docker images`, so a Wine run is possibly available; not tried, and 32-bit Wine under emulation is not verified.
- No `wine`, `qemu-i386`, `box86`, or `dosbox` is on the host path.
- A Swift host variant with model C at the two sites, in a worktree, would measure how many of the 2400 frames change against the contract-off reference. The coordinator opened this option during the run. It was not done: it measures a fourth model (section 3, P2), not retail, and the three-model rates already answer question 2. Cost: one worktree, one host build with at most `-j 3`, one replay of about 25 seconds.

## 5. Options for the user, with cost

No option here is a ruling.

1. Keep model A as the port's definition and the contract-off fork as the reference, and correct the recorded reason (section 3, P3). Cost: one sentence in the record and, if wanted, one sentence in rule 16 or 18 that says the oracle is Raven's source under strict IEEE evaluation, not the retail binary. Unknown that stays: how far retail's state is from the port's after N frames.
2. As 1, plus measure retail at chosen functions through the Linux binary in Docker (section 4). Cost: hours. Result: real numbers for the distance from retail, no change to the port.
3. Emulate x87 by expression at engine sites (P2). Cost: every multi-operation `float` expression in the engine, casts in bodies, a second model beside the game's, no proof available, and it is still not retail.
4. Obtain the Windows `jampDed.exe` and read it. Cost: the user supplies the file; minutes of reading. Result: section 1.3 moves from inferred to measured.

## 6. What stays unknown

- The instructions of the Windows retail server: compiler version, operation order, spill points, and the effective precision word. All inferred.
- Whether the Linux process really runs with `0x037F`: inferred from the absence of a `fldcw` at start and the kernel default, not read from a live process.
- The number of referee frames that a model C engine would change.
- The real float inputs of the traces of the corpus, and so the real share of non-axial planes on `mp/ffa1`.
- The number of multi-operation `float` expressions in the Swift engine.
- Whether ioquake3 or OpenJK documents x87 against SSE differences outside the trees.
