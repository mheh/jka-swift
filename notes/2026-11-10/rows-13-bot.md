# Rows B1 to B5, the bot and terrain rows

## B1. BotReplaceSynonyms thunk: NOT SETTLED

- Swift: `Sources/JKAMP_DedLogic/be_interface.swift:825-827`, `portMissing` under Port-note row X2.
- Raven: `botlib/be_ai_chat.cpp:744` `void BotReplaceSynonyms(char *string, unsigned long int context)`. The callee calls `StringReplaceWords` (`:520`), which does `memmove(str + strlen(replacement), ...)` with no bound. No constant in the callee limits the write.
- Callers: the base game has none. `trap_BotReplaceSynonyms` is only declared (`game/g_local.h:1837`) and defined (`game/g_syscalls.c:949`). OpenJK is the same (`openjk/codemp/game/g_syscalls.c:667`, no caller). The one internal caller is `BotExpandChatMessage` with `char temp[MAX_MESSAGE_SIZE]` (`be_ai_chat.cpp:2247`, call `:2293`). Swift does the same (`be_ai_chat.swift:2056`, `:2097`).
- So the only bound is the caller's buffer, and only one caller exists. The callee does not fix it.
- jka-rust: raw `*mut c_char`, written in place with no bound (`jka-rust/crates/mp/engine/botlib/src/be_ai_chat_fns.rs:586`, `:524-550`; arm `server/src/sv_game.rs:2526-2534`). This is Raven's C semantic. It shows no capacity.
- OpenJK: no fix. It passes the text through unchanged (`sv_gameapi.cpp:983-984`, `:2451`).
- Precedents: `PC_SourceFileAndLine` capacity 1024 comes from the callee's own `source_t.filename[1024]` (`be_interface.swift:982-990`). No such field exists here. `UnifyWhiteSpaces` (`:925-928`) writes back `buf.count`, but `CharBuf(text(at:))` has a fixed count of strlen+1, and `memmove` traps past the end (`JKAShared/CString.swift:409`). So candidate B of ledger 11 traps on any growth. The widest-count form `Slots<Int32>(count: Int.max / 4)` (ledger 11 row 2) has no CharBuf twin.
- Candidates: A, capacity `MAX_MESSAGE_SIZE` with an AI line (the bound of the only caller, which is not Raven's write). B, a capacity of strlen+1 (traps where Raven overruns, a rule 19 divergence).

## B2. ROFF ProcessNote game arm: SETTLED (row SV3 form)

- Swift `CROFFSystem.swift:537-539` (Port-note "Row SV3"). Raven `RoffSystem.cpp:929` `char temp[1024]`, `:957` `VM_Call( gvm, GAME_ROFF_NOTETRACK_CALLBACK, roff_ent->mEntID, temp )`.
- The text is a stack local copy, not the ROFF note table. No port site passes text through VM_Call today. The only argument-address form is SV3: `withVectorWords` (`Sources/JKAMP_Ded/VmEntry.swift:75-82`), used at `gameCallbacks.swift:9`, `:17`, `:26`. The word holds the address of a copy that lives for the call. Ledger 9 (`dedicated-open-rows-ledger-9.md:75`) keeps that form and adds no new one.
- jka-rust does the same: `CString::new(temp)` is kept for the call, and `cstr.as_ptr() as isize` is the word (`jka-rust/crates/mp/engine/qcommon/src/roff/roff_system.rs:781-791`).
- Change: in `Sources/JKAMP_Ded/VmEntry.swift`, add a text twin next to `withVectorWords` that gives the address of the CharBuf for the body's life (over `CharBuf.withUnsafeRawPointer`). Then `CROFFSystem.swift:537-539` becomes `withTextWord(temp) { VM_Call(gvm!, GAME_ROFF_NOTETRACK_CALLBACK, roff_ent.mEntID, $0) }` with the SV3 AI line. Cost: one hand view helper with the same standing as `withVectorWords`.

## B3. CleanTextPool: SETTLED (NOT_PORTED-replaced)

- Swift `GenericParser2.swift:141-147` (marker with a rule 20 note). `Clean` drops the call at `:676`. Raven `GenericParser2.cpp:212`, caller `:907`.
- Ruling C3 (`notes/2026-11-03/dedicated-cxx-docket.md:64`, `:121`): `CTextPool` has no Swift type, and the text pool is `String`. The AI lines at `GenericParser2.swift:156`, `:633`, `:657` say so. The function has no work: nothing is freed.
- Precedent: `Cvar_FreeString` (`cvar.swift:56-57`, "Not ported: ... the string pool holds every cvar string"), the NOT_PORTED-replaced form (`docket-12.md:353`, `skeleton.py:1440-1443`). `dead-check.md:248` already finds this.
- Change: replace the rule 20 Port-note at `GenericParser2.swift:143` with `// Not ported: row C3 makes the text pool a String, so the chain it frees does not exist, and CGenericParser2::Clean drops the call.` in the Cvar_FreeString shape. No DEAD row exists to remove. Other pool functions: `CTextPool`'s ctor, dtor, and `AllocText` (`:166`, `:179`) are class members with no Swift type and no stub, so no other row is needed.

## B4. DEAD by a DEDICATED arm that stores 0: SETTLED by jka-rust, with a wording gap in rule 20

- Rule 20 (`docs/porting-rules.md:45`): "A function with zero callers in either tree is left as its generated stub ... dead". The `rulings.py:1507` comment says the same. The wording covers only "no caller".
- Every DEAD proof in `rulings.py:1508-1538` is a caller that does not build or link: `#ifndef DEDICATED` (LoadTGA, bInShadowRange, ProcessAutomapSymbols, CM_DrawDebugSurface via `tr_main.cpp:865`/`:1630`), not linked (GetRefAPI, R_LerpTag), or an undefined macro (WriteIndent, DEBUG_AI_WEAP). No row uses a value that is constant in the build. The nearest in-repo principle is `docs/transcription.md:654` ("dead by the build's own choice", for arms). Ledger 6 W8 (`usingSocks`, "no path") is an arm, not a DEAD row.
- Proof holds: `cm_terrain.cpp:169-171` stores `mRandomTerrain = 0; imageData=NULL` under `#ifdef DEDICATED`. `RM_Manager.cpp:110` returns before `new CRMMission` (`:135`). `s_shaderText` is set only in `ScanAndLoadShaderFiles` (`tr_shader.cpp:3937`), which is under `#ifndef DEDICATED` (`:4273-4282`). So `FindShaderInShaderText` returns NULL and `ParseShader` (`:3477`) never runs.
- jka-rust ruling 25 / RMG-D1, a user ruling (`jka-rust/docs/handoffs/engine-fork-discovery.md:232-240`, `docs/subsystems/rmg-terrain.md:922-945`), makes the same proof at the same site: `CRMMission`, `CRandomTerrain`, `CRMInstance*`, and `CRMPathManager` are dead under DEDICATED and dropped (`crates/mp/engine/rmg/src/lib.rs:1-10`).
- Change: put the 17 RMG names and ParseShader in `DEAD` of `rulings.py` with the arm in each proof text, for example "cm_terrain.cpp:169 stores 0 under `#ifdef DEDICATED`, so the dedicated build never makes a CRMMission". Add one sentence to rule 20 and to the `rulings.py:1507` comment: a caller whose path a DEDICATED arm closes counts as no caller. The rule text changes, so the user may want to see it.

## B5. CRMInstance virtual hierarchy: SETTLED by rule 17, blocks nothing

- Rule 17 (`docs/porting-rules.md:42`): "A closed virtual hierarchy becomes an enum with a switch, or a protocol ... where the set is open."
- The set is closed. `CRMInstanceFile::CreateInstance` makes only BSP, Group, Random, and Void (`RMG/RM_InstanceFile.cpp:160-177`; NPC is commented out at `:164`).
- No multi-class hierarchy is ported yet. Existing forms: virtual methods with no subclass become a final class with plain methods (`ICARUS_Instance.swift:10-11`). An interface with one implementation becomes that class (`Ghoul2InfoArray.swift:9-11`).
- jka-rust has no trait or enum for it. RMG-D1 drops the hierarchy.
- With B4 DEAD, nothing in the dedicated server reaches it. Defer it: the form is a rule 17 enum with a switch, built when a client or fork stage ports the RMG.
