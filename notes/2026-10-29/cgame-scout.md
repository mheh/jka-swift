# The cgame scout

This record holds the scout run of the generator pipeline on the next product, the MP cgame module `oracle/codemp/cgame`, 35 `.c` files and 53109 lines of C (`cat oracle/codemp/cgame/*.c | wc -l`). The tree is master at 8cde4f3. No file under `Sources/`, `docs/`, `Package.swift`, or `tools/` changed, and nothing is committed.

## The setup

The generators have no module argument. `[sweep]` of `tools/oracle-closure/project.toml:10-16` names `mp-game` as the unit and `mp-cgame` as the other unit, and `skeleton.py`, `manifest.py`, `traps.py`, `bodies.py`, `channel.py`, and `views.py` read that pair. The `modules/` folder holds only `__pycache__`, because the module specs moved into `project.toml`, and the `mp-cgame` unit is `project.toml:147-166`.

So the scout ran the real generator code through small drivers that swap the unit in memory. `drivers/swap.py` sets the sweep unit to `mp-cgame` and the other unit to `mp-game`, points the output root at a copy of `Sources/` under `tools/oracle-closure/out/cgame-scout/Sources`, and points the store at `out/cgame-scout/table.sqlite`. The working store `tools/oracle-closure/table.sqlite` is not opened. The drivers, the logs, the stub copy, the manifests, and the drafts all stand under `tools/oracle-closure/out/cgame-scout/`, which `.gitignore:10` keeps out of version control. Every count below with no other command comes from one of those drivers.

## 1. The closure and the parse

`mp-cgame` parses as one unity translation unit over `codemp/cgame/*.c`, `codemp/game/bg_*.c`, and `codemp/ui/ui_shared.c` (`project.toml:162-166`), with the overlay of `overlay.py`, in under 1 second (`drivers/parse_counts2.py`).

| Declarations, unique names | cgame `.c` files | cgame headers | bg `.c` files | `ui_shared.c` |
|---|---:|---:|---:|---:|
| Function definitions | 892 | 0 | 344 | 316 |
| File-scope variable definitions | 113 | 2 | 73 | 28 |
| `extern` declarations | 246 | 146 | 22 | 15 |
| Macros | 136 | 116 | 39 | 95 |
| Structs | 6 | 54 | 1 | 22 |
| Enums | 3 | 14 | 1 | 0 |
| Typedefs | 8 | 58 | 3 | 24 |

The 892 functions stand in 34 files. `cg_playeranimate.c` defines no function, and `cg_syscalls.c` holds 219 of the 892.

The parse reports 5442 errors. The game unit reports 6628 errors under the same command (`drivers/errs.py`), so the cgame parse has the shape the game pipeline already accepts. Every error falls in a class the game parse also has:

| Error class | Count |
|---|---:|
| redefinition of an enumerator | 2518 |
| ISO C requires a named parameter before `...`, from the overlay that repeats after each file | 1440 |
| typedef redefinition with different types | 1008 |
| redefinition of a name | 325 |
| conflicting types, for `Q_fabs`, `SnapVector`, `powf`, and `random` only | 145 |
| the MSVC inline assembly at `q_shared.h:1414-1425` | 6 |

3708 of the errors stand in `cg_local.h`, which has no include guard, so the unity parse reads it once per `.c` file. No error outside these classes exists (`drivers/errs2.py`).

## 2. The C target

A fresh `extract.py` ran over the eight modules of `merge.py:44-45`, and `merge.py --out out/merge-scout` wrote the targets beside the package. The commands ran in `tools/oracle-closure`:

1. `for m in mp-game mp-bg mp-cgame mp-ui sp-game sp-bg sp-cgame sp-ui; do .venv/bin/python extract.py $m; done`, 72 seconds.
2. `.venv/bin/python merge.py --out out/merge-scout`
3. `diff -rq ../../Sources/<T> out/merge-scout/<T>` for each of the nine C targets.

The fresh extract writes the same bytes as the trees of the run before it. `diff -rq` against a copy of `out/extract/` reports no difference for any of the eight modules. The `mp-cgame` tree holds 330 files and 2551 layout asserts per triple over 10 triples (`extract-mp-cgame.log`).

`Sources/CJKAMP_CGame` and `out/merge-scout/CJKAMP_CGame` have no difference, so the committed target is the output of today's generators. The merge reports 58 types, 27 constants files, and 1127 asserts for each of 3 ABIs in that target (`merge.log`). The only differences in the other targets are the files the merge does not write: `bg_tables.c`, `bg_tables.h`, `g_tables.c`, and `g_tables.h`, which `tables.py` writes after the merge, and the hand header `g_types.h` of `rulings.py:403-404`.

The cgame target has no hand header. Six structs stand inside cgame `.c` files and have no home under `Sources/` (`find Sources/CJKA* -name <T>.h`): `cvarTable_t` and `cgSpawnEnt_t` of `cg_main.c`, `cparticle_t` of `cg_marks.c`, `lagometer_t` and `veh_damage_t` of `cg_draw.c`, and `consoleCommand_t` of `cg_consolecmds.c`. The game target holds its six of this kind in `g_types.h`.

## 3. The skeleton and the manifest

`drivers/run_skeleton.py` calls `skeleton.main()` with the unit swapped and `SKIP` set to `cg_syscalls.c`. The first run stops in the base sweep of the store:

```
File "tools/oracle-closure/table.py", line 99, in __init__
    self.lines = path.read_text().splitlines()
UnicodeDecodeError: 'utf-8' codec can't decode byte 0xd7 in position 10241: invalid continuation byte
```

`oracle/codemp/cgame/cg_effects.c:401` holds the Latin-1 byte 0xD7, the multiplication sign, in a comment. `SourceFile` at `table.py:98-99` reads every oracle file as strict UTF-8, and no game or bg file holds such a byte. The extract does not stop on it. The driver reads the file with one replacement character per bad byte, so every column stays where it was, and the second run completes in 50 seconds:

```
skeleton.py: 33 files, 459 stubs, 213 TODO: Port signature markers, 2 thunks in 7 namespaces, 0 thunks over an unmapped signature
  macros: 135 in the stubs, 0 spelled at the site, 0 field aliases, 0 function aliases
  variables: 34 let, 224 state, 58 data by hand, 0 initializers by hand, 260 storage, 2 data tables from tables.py, 54 markers
```

The 33 stems are the 35 `.c` files less `cg_syscalls.c`, which is the trap table, and `cg_playeranimate.c`, which defines no function. The stems hold 673 functions. 460 get a mapped stub, and 213 get a `TODO: Port signature` marker. The skeleton puts every cgame stub into `JKAMP_GameLogic`, because `target_of` at `skeleton.py:76-80` knows only `JKAShared`, `JKAMP_BG`, and `JKAMP_GameLogic`. The same run writes the cgame variables over the game's `GameVariables.swift`, `GameStorage.swift`, `BgVariables.swift`, `BgStorage.swift`, and `Callbacks.swift` in the copy, because those paths are fixed at `skeleton.py:1292`, `:1302-1303`, and `:1330-1331`.

`drivers/run_manifest.py` writes 33 manifests to `out/cgame-scout/manifest/` in 14 seconds: `manifest.py: 33 manifests, 673 functions, 14 with a jka-rust match`. The 14 matches are false. They are `Com_Error`, `Com_Printf`, and the 12 `strap_` functions, and each one names a game file of jka-rust, for example `crates/mp/game/src/g_strap.rs:107-124`. The manifest reads jka-rust only under `game`, `bg`, and `qshared` (`skeleton.py:195`), and the submodule holds `jka-rust/crates/mp/cgame` with 73275 lines of Rust that no manifest row cites.

### The signature markers by C type

| C type with no table row | Markers |
|---|---:|
| `centity_t *`, `const centity_t *`, `centity_t **` | 129 |
| `localEntity_t *`, parameter and return | 24 |
| `clientInfo_t *`, `clientInfo_t **`, and the return | 14 |
| `menuDef_t *`, `const menuDef_t *` | 11 |
| `refEntity_t *` | 9 |
| `cgSpawnEnt_t *` | 5 |
| `snapshot_t *`, parameter and return | 4 |
| `rectDef_t *` | 3 |
| `vec2_t uv[4]`, `char **` | 2 each |
| `float *` return, `markPoly_t *` and its return, `score_t *`, `polyVert_t *`, `lerpFrame_t *`, `itemDef_t *`, `cparticle_t *`, `chatBoxItem_t **`, `impactSound_t` | 1 or 2 each |

`impactSound_t` is a cgame enum of `cg_local.h`. It has no table row because `reexport.py:39-42` re-exports `CJKAShared`, `CJKAMP`, and `CJKAMP_Game` only.

The 54 variable markers are the globals with no view. 27 of them stand in the stubs, among them `cg` and `cgs` at `cg_main.c:691-692`, `cg_entities` at `:693`, `cg_weapons`, `cg_items`, `cgDC`, `cg_localEntities`, and `cg_markPolys`.

### The rulings that need cgame rows

| Table of `rulings.py` | What the cgame needs | Evidence |
|---|---|---|
| `ROOTS`, line 18 | A view for each struct of the markers above, and for `cg_t`, `cgs_t`, `cgMedia_t`, `cgEffects_t`, and `weaponInfo_t` | the marker table, and section 4 |
| `RETURNS`, line 185 | A kind for `float *CG_FadeColor`, which returns a static `vec4_t`. The `vec3` kind covers three floats only | `cg_drawtools.c`, `CG_FadeColor` |
| `PARAMS`, line 229 | `char **args` of `CG_RunMenuScript` and `CG_DeferMenuScript`, `vec2_t uv[4]` of `CG_DoGlassQuad` and `CG_CalcBiLerp`, `centity_t **pTargetVeh` of `CG_CheckTargetVehicle`, `chatBoxItem_t **array`, and `clientInfo_t **ci` of `CG_CreateNPCClient` and `CG_DestroyNPCClient` | the skeleton markers |
| `NOT_PORTED`, line 279 | The reason of `vmMain` at line 282 names `Sources/jampgame/jampgame.swift`, and the cgame stub copies that text | `out/cgame-scout/Sources/JKAMP_GameLogic/cg_main.swift:557-558` |
| `PUBLIC_NAMES`, line 296 | The 32 commands of the cgame `vmMain` at `cg_main.c:190`, which call `CG_Init`, `CG_Shutdown`, `CG_ConsoleCommand`, `CG_DrawActiveFrame`, `CG_CrosshairPlayer`, `CG_LastAttacker`, `CG_KeyEvent`, `CG_MouseEvent`, `CG_EventHandling`, `C_PointContents`, `C_GetLerpOrigin`, `C_GetLerpData`, `C_Trace`, `C_ImpactMark`, `CG_MiscEnt`, `CG_RagCallback`, `CG_ROFF_NotetrackCallback`, and others | `sed -n 190,356p oracle/codemp/cgame/cg_main.c` |
| `HAND_MACROS`, line 148 | No new row. `MAX_POOL_SIZE` is 2048000 under `CGAME` at `bg_misc.c:3314`, and the consumer passes it to `BgState` under rule 23 | `bg_misc.c:3311-3317` |
| `SHARED_STEMS`, line 394 | `cg_syscalls` and `cg_strap`, the twins of `g_syscalls` and `g_strap` | `cg_strap.c:6-58` |
| `HAND_HEADERS` and `HAND_FILES`, lines 403-404 | A `CJKAMP_CGame` entry for the six structs of section 2 | section 2 |
| `HAND_VARS`, line 126 | No row found. No cgame `.c` file declares a pool of its own. `cg_players.c:7698` allocates through `BG_Alloc` | `grep -n "BG_Alloc" oracle/codemp/cgame/*.c` |
| `CHARBUF_ALLOCS`, line 214 | No row found. No cgame file calls `BG_TempAlloc` or `B_TempAlloc` | the same grep |
| `SLOT_BOUNDS`, line 110 | No new row. The only pointer field a cgame body indexes as records is `bgLoadedAnim_t.anims`, which line 111 already bounds. The other indexed pointer fields are text: `classname`, `icon`, `pickup_sound`, `model`, `skin`, and `stringData` | `drivers/slots.py` |
| `NIL_OVERLOADS`, line 387 | No row found. No row of the cgame `cvarTable` passes a NULL handle | `grep -n "{ NULL," oracle/codemp/cgame/cg_main.c` |
| `LIST_TRAPS`, `NEVER_NULL`, `TYPES`, `NULLABLE` | Not measured. These rows come out of a docket over drafted bodies | |

### The syscalls

`cg_syscalls.c` has the shape of `g_syscalls.c`. Both declare `static int (QDECL *syscall)( int arg, ... )` and `dllEntry`, at `cg_syscalls.c:7-12` and `g_syscalls.c:8-16`, and each trap is one `syscall(...)` call. Raven's MP oracle has no `cgame_import_t`. The trap numbers are the `cgameImport_t` enum at `cg_public.h:56-341`, and the commands of `vmMain` are the `cgameExport_t` enum at `cg_public.h:352-440`. OpenJK's `cgameImport_t` struct of function pointers is its own API, and the legacy path does not use it (section 7).

`drivers/run_traps.py` runs `traps.py` with `SOURCE` set to `codemp/cgame/cg_syscalls.c` and writes `out/cgame-scout/Sources/JKAMP_Game/Generated/cg_syscalls.swift`.

| | Game, `g_syscalls.c` | cgame, `cg_syscalls.c` |
|---|---:|---:|
| `trap_` definitions (`grep -cE` on the `.c` file) | 313 | 215 |
| Functions the generator reads | not run | 217 |
| Typed traps | 311 unique names in the committed file | 195 |
| `TODO: Port signature` markers | 0 | 22 |

The 22 cgame markers are the record pointers with no view, `refEntity_t`, `polyVert_t`, `refdef_t`, `orientation_t`, `glconfig_t`, `gameState_t`, `snapshot_t`, `SSkinGoreData`, and the five FX argument structs, plus `vec3_t axis[3]` of `trap_S_Respatialize` and the two FX entity effects, `const vec3_t *points` of `trap_CM_MarkFragments`, `color4ub_t`, and `byte *mask` of `trap_R_inPVS`. `traps.py:44-46` fixes the view target, the source file, and the output name, and line 367 writes `internal import CJKAMP_Game`, so the cgame traps need a view target of their own.

## 4. The views

`drivers/views_census.py` walks every function body of the 33 cgame stems and lists the record type behind each field read. An existing view is a file under `Sources/*/Generated/Views/` whose doc line names the C type.

| | Records | Field reads |
|---|---:|---:|
| Read through a field in a cgame body | 94 | 19179 |
| A view exists, in `JKAShared`, `JKAMP`, or `JKAMP_Game` | 31 | |
| New | 63 | |

The views that exist are the bg and shared ones: `entityState_t`, `playerState_t`, `vmCvar_t`, `Vehicle_t`, `trace_t`, `saberInfo_t`, `gitem_t`, `vehicleInfo_t`, `trajectory_t`, `animation_t`, `pmove_t`, `forcedata_t`, `mdxaBone_t`, `bladeInfo_t`, `pc_token_t`, `siegeClass_t`, `weaponData_t`, `vehWeaponInfo_t`, `cplane_t`, `saberTrail_t`, `vehWeaponStats_t`, `usercmd_t`, `bgLoadedAnim_t`, `sharedRagDollParams_t`, `turretStats_t`, `sharedRagDollUpdateParams_t`, `ammoData_t`, `siegeTeam_t`, and `saberMoveData_t`. Two more match by name only. `cvarTable_t` of `JKAMP_Game` is the game's struct of `g_main.c`, and the cgame struct of `cg_main.c` has other fields. `CollisionRecord_t` has its view in `JKAMP_Game`, which a cgame target cannot import.

The new views with the most field reads:

| C type | Field reads | Stems | C target today |
|---|---:|---:|---|
| `centity_t` | 3152 | 23 | `CJKAMP_CGame` |
| `cg_t` | 2680 | 24 | `CJKAMP_CGame` |
| `cgs_t` | 1545 | 30 | `CJKAMP_CGame` |
| `refEntity_t` | 1123 | 10 | `CJKAMP`, from the cgame copy of `tr_types.h` |
| `clientInfo_t` | 854 | 12 | `CJKAMP_CGame` |
| `cparticle_t` | 625 | 1 | none, it stands in `cg_marks.c` |
| `snapshot_t` | 558 | 16 | `CJKAMP_CGame` |
| `cgMedia_t` | 553 | 18 | `CJKAMP_CGame` |
| `localEntity_t` | 418 | 5 | `CJKAMP_CGame` |
| `weaponInfo_t` | 340 | 6 | `CJKAMP_CGame` |
| `polyVert_t` | 300 | 2 | `CJKAMP` |
| `refdef_t` | 241 | 14 | `CJKAMP` |
| `windowDef_t`, `itemDef_t` | 217 each | 1 | `CJKAMP`, and `CJKAMP_CGame` for `itemDef_t` |
| `cgEffects_t` | 208 | 16 | `CJKAMP_CGame` |
| `rectDef_t` | 190 | 2 | `CJKAMP` |

The other 47 new records are `lerpFrame_t`, `displayContextDef_t`, the five FX argument structs, `playerEntity_t`, `markPoly_t`, `score_t`, `animevent_t`, `cachedAssets_t`, `cgSpawnEnt_t`, `cgscreffects_t`, `effectTrailVertStruct_t`, `itemInfo_t`, `clightstyle_t`, `SSkinGoreData`, `chatBoxItem_t`, `lagometer_t`, the eight `TCG*` shared-buffer records of `cg_public.h`, `markFragment_t`, `autoMapInput_t`, `siegeExtended_t`, `glconfig_t`, `cgLoopSound_t`, `poly_t`, four `ragCallback*` records, `orientation_t`, `veh_damage_t`, `consoleCommand_t`, `bgLoadedEvents_t`, `gameState_t`, the cgame `cvarTable_t`, and four unnamed structs and unions at `cg_local.h:551` and `:566` and `tr_types.h:199` and `:206`. The full list is `out/cgame-scout/views_census.txt`.

`views.py` cannot write them today. Its roots are the four game structs (`views.py:7`, `rulings.py:18-21`), and `Parse.headers` reads the umbrella of `CJKAMP_Game` alone (`closure.py:328`, `reexport.py:39`).

## 5. The drafter

`drivers/run_bodies.py` drafts every function of the 33 stems through `bodies.Lowering`, in 71 seconds, and writes one file per stem to `out/cgame-scout/drafts/`. No function raised an exception. A function with a signature marker keeps its stub, so the drafted bodies are the 460 mapped functions.

The last column counts the code lines of a draft that name one of the 27 marker globals, such as `cgs.effects.blasterWallImpactEffect` in `FX_BlasterWeaponHitWall`. No declaration of those names exists, so each such line fails to compile. The drafter does not mark them as holes.

| Stem | Functions | Signature markers | Bodies drafted | Holes | Lines on a marker global |
|---|---:|---:|---:|---:|---:|
| `cg_consolecmds` | 18 | 0 | 18 | 2 | 26 |
| `cg_draw` | 100 | 24 | 76 | 196 | 445 |
| `cg_drawtools` | 24 | 1 | 23 | 8 | 28 |
| `cg_effects` | 22 | 4 | 18 | 159 | 28 |
| `cg_ents` | 40 | 31 | 9 | 59 | 24 |
| `cg_event` | 20 | 10 | 10 | 85 | 28 |
| `cg_info` | 5 | 0 | 5 | 0 | 18 |
| `cg_light` | 3 | 0 | 3 | 2 | 17 |
| `cg_localents` | 21 | 19 | 2 | 5 | 3 |
| `cg_main` | 82 | 7 | 75 | 183 | 501 |
| `cg_marks` | 28 | 13 | 15 | 244 | 25 |
| `cg_newDraw` | 24 | 5 | 19 | 22 | 73 |
| `cg_players` | 85 | 56 | 29 | 258 | 40 |
| `cg_playerstate` | 7 | 0 | 7 | 18 | 77 |
| `cg_predict` | 14 | 2 | 12 | 84 | 112 |
| `cg_saga` | 13 | 2 | 11 | 15 | 9 |
| `cg_scoreboard` | 6 | 1 | 5 | 25 | 32 |
| `cg_servercmds` | 21 | 4 | 17 | 69 | 121 |
| `cg_snapshot` | 7 | 5 | 2 | 16 | 31 |
| `cg_strap` | 12 | 0 | 12 | 0 | 0 |
| `cg_turret` | 2 | 1 | 1 | 0 | 0 |
| `cg_view` | 42 | 1 | 41 | 90 | 349 |
| `cg_weaponinit` | 1 | 0 | 1 | 268 | 53 |
| `cg_weapons` | 28 | 11 | 17 | 60 | 246 |
| `fx_blaster` | 4 | 2 | 2 | 0 | 3 |
| `fx_bowcaster` | 4 | 2 | 2 | 0 | 2 |
| `fx_bryarpistol` | 13 | 4 | 9 | 0 | 13 |
| `fx_demp2` | 5 | 1 | 4 | 12 | 16 |
| `fx_disruptor` | 6 | 0 | 6 | 20 | 4 |
| `fx_flechette` | 4 | 2 | 2 | 0 | 2 |
| `fx_force` | 1 | 0 | 1 | 0 | 1 |
| `fx_heavyrepeater` | 7 | 3 | 4 | 0 | 4 |
| `fx_rocketlauncher` | 4 | 2 | 2 | 0 | 2 |
| total | 673 | 213 | 460 | 1900 | 2333 |

The cascade errors and the defects are not measured. `draftcheck.py` builds the game product in a mirror of the package (`docs/oracle-closure.md:16`), and its stem flags are `--stem`, `--all`, `--game`, and `--every` (`draftcheck.py:345-348`). No package target holds a cgame stem, and the copy of `Sources/` cannot build, because the swapped skeleton wrote the cgame state over the game's state files. For scale, the first game gate gave 1484 holes, 0 cascade errors, and 2108 defects over 66 stems (`notes/game-gate-2026-09-27.md:3`).

### The first ten hole reasons

By class, with the name in backticks folded:

| Holes | Reason |
|---:|---|
| 1240 | A read of a local the draft left as a hole |
| 242 | A store into a local the draft left as a hole |
| 211 | A pointer local with no view |
| 44 | Raven's text runs over bytes that are not one record with a view |
| 29 | A pointer dereference the draft cannot place |
| 29 | A local the table has no type for |
| 28 | NULL for a `JKAMP.VmCvar` parameter |
| 17 | Raven passes NULL for an output, so the body passes a scratch local |
| 13 | No operator between the operands |
| 12 | A cast the draft has no view for |

By raw text, the first ten are reads of the locals `weaponInfo` (259), `p` (184), `cent` (104), `le` (70), a store into `message` (63), and reads of `apArgs` (47), `ex` (46), `b` (43), `ci` (38), and `re` (38). The 211 pointer locals with no view are `centity_t` 69, `clientInfo_t` 26, `char` 22, `localEntity_t` 12, `cparticle_t` 12, `float` 8, `snapshot_t` 7, `refEntity_t` 7, and others. The first three classes, 1693 of 1900 holes, follow from the missing views of section 4.

## 6. The bg channel

`drivers/bg_channel.py` reads both unity parses. The cgame compile of bg defines 344 bg functions and the game compile 343. Three stand in the cgame compile alone, under `#ifndef QAGAME` at `bg_panimate.c:1756-2328`: `CheckAnimFrameForEventType` at `:1782`, `ParseAnimationEvtBlock`, and `BG_ParseAnimationEvtFile` at `:2169`. `JKAMP_BG` holds none of the three, because the bg skeleton reads the game parse. Two stand in the game compile alone, `PM_ClientImpact` and `PM_CrashLandEffect`.

The committed channel holds 30 closures on `BgStraps` and 51 on `BgCallbacks` (`Sources/JKAMP_BG/Generated/bg_strap.swift:8`, `bg_callbacks.swift:8`). The game installs them in `Sources/JKAMP_GameLogic/Generated/BgChannel.swift`, which `channel.py:422` writes into the game logic target. The bg bodies of the cgame compile call 28 functions that a cgame `.c` file defines, and a cgame install must point these closures at them:

| Closure group | Names | cgame definition |
|---|---|---|
| Own hooks, `bg.error` and `bg.print` | `Com_Error`, `Com_Printf` | `cg_main.c:1234`, `:1245` |
| Callbacks | `BG_GetTime`, `CG_GetVehicleCamPos`, `CG_NewString` | `cg_main.c:1276`, `cg_view.c:797`, `cg_main.c:3344` |
| `strap_` | `strap_G2API_GetBoltMatrix`, `_NoRecNoRot`, `SetBoneAngles`, `SetBoneAnim`, `GetBoneAnim`, `AnimateG2Models`, `SetBoneIKState`, `IKMove` | `cg_strap.c:6-58` |
| Traps | `trap_FS_FOpenFile`, `trap_FS_Read`, `trap_FS_FCloseFile`, `trap_FS_GetFileList`, `trap_FX_RegisterEffect`, `trap_FX_PlayEffectID`, `trap_G2API_AddBolt`, `trap_G2API_GetBoltMatrix`, `trap_G2API_GetSurfaceRenderStatus`, `trap_R_RegisterModel`, `trap_R_RegisterShader`, `trap_R_RegisterShaderNoMip`, `trap_R_RegisterSkin`, `trap_S_RegisterSound`, `trap_SnapVector` | `cg_syscalls.c`, for example `:83`, `:229`, `:579`, `:637` |

The channel already shapes the six traps that only `cg_syscalls.c` defines, for example `trap_FX_PlayEffectID` at `bg_strap.swift:57-58`. The 23 `bg*` read closures, such as `bgEntityAtInuse` and `bgClientSaber`, read the game's entities on Raven's `QAGAME` arms. A cgame install needs its own reads over `cg_entities` and `cgs.clientinfo`, or the cgame arms in the bodies. For example, Raven's `BG_MySaber` has a `#elif defined CGAME` arm at `bg_saber.c:4113-4138`, and the Swift body at `Sources/JKAMP_BG/bg_saber.swift:3155-3168` holds the game arm alone. The bg `.c` files hold 129 consumer conditionals (`grep -cE` over `#ifdef`, `#ifndef`, and `#elif defined` of `QAGAME` and `CGAME`), and the Swift bg files hold 12 `bg.consumer` tests.

The cgame bodies call 66 bg functions, and the game bodies call 125. Twelve of the 66 have no game caller:

| Function | Raven | Swift today |
|---|---|---|
| `BG_ProperForceIndex` | `bg_misc.c:1997` | `bg_misc.swift:711`, internal |
| `BG_CycleForce` | `bg_misc.c:2014` | `bg_misc.swift:726`, internal |
| `BG_GetVehicleSkinName` | `bg_vehicleLoad.c:1613` | `bg_vehicleLoad.swift:960`, internal |
| `BG_ParseAnimationEvtFile` | `bg_panimate.c:2169` | absent |
| `BG_SI_SetLength` | `bg_saberLoad.c:2863` | `bg_saberLoad.swift:2262`, internal |
| `BG_SI_SetDesiredLength` | `bg_saberLoad.c:2874` | `bg_saberLoad.swift:2274`, internal |
| `BG_SI_SetLengthGradual` | `bg_saberLoad.c:2890` | `bg_saberLoad.swift:2293`, internal |
| `BG_SiegeFindClassByName` | `bg_saga.c:1219` | `bg_saga.swift:977`, internal |
| `BG_VehicleAdjustBBoxForOrientation` | `bg_pmove.c:9993` | `bg_pmove.swift:8476`, internal |
| `PM_WalkingAnim` | `bg_pmove.c:4579` | `bg_pmove.swift:4229`, internal |
| `PM_RunningAnim` | `bg_pmove.c:4600` | `bg_pmove.swift:4250`, internal |
| `PM_UpdateViewAngles` | `bg_pmove.c:7813` | `bg_pmove.swift:6798`, internal |

Of the 66, 54 are `public` today, 11 are internal, and 1 is absent. `skeleton.py --publish` gives `public` only to the names a game file reads.

## 7. The host

The cgame runs in the client. The dedicated server `openjkded.arm64` does not load it.

The client loads the cgame in `CL_BindCGame` at `openjk/codemp/client/cl_cgameapi.cpp:1698`. It tries `VM_Create( VM_CGAME )` first, at `:1706`, which looks for OpenJK's `GetModuleAPI` export. When the library has no such export, it falls back to `VM_CreateLegacy( VM_CGAME, CL_CgameSystemCalls )` at `:1928`. The legacy path loads `dllEntry` and `vmMain` at `openjk/shared/sys/sys_main.cpp:534-535`, the two exports the Swift game has at `Sources/jampgame/jampgame.swift:11` and `:27`. The file name is `"cgame" ARCH_STRING DLL_EXT` (`cl_cgameapi.cpp:1702`, `vm.cpp:33-37`), and `ARCH_STRING` is `arm64` (`openjk/shared/qcommon/q_platform.h:111-112`), so the library is `cgamearm64.dylib` in the mod folder of the homepath. The fork's build already writes OpenJK's own C cgame as `.build/openjk/codemp/cgame/cgamearm64.dylib`.

`vm_cgame 0` has no effect in OpenJK. `vm_cgame` and `vm_game` appear only in the `legacyCvars` list at `openjk/codemp/qcommon/cvar.cpp:752-764`, which lets a server set them. The one cvar that picks a load path is `vm_legacy`, and only a `_DEBUG` build reads it (`vm.cpp:159`). The `vm_game 0` of `tools/load-test.sh:38` and `notes/2026-10-29/human-recordings.md:7` is inert for the same reason.

The referee of the fork, `sv_referee` of commit f6d2875e, does not cover the cgame:

- `VM_Call` traces a call only when `vm->slot == VM_GAME` (`openjk/codemp/qcommon/vm.cpp:291`), so no cgame command reaches the trace.
- The syscall trace wraps `SV_GameSystemCalls` alone (`sv_referee.h:31-33`). `CL_CgameSystemCalls` has no wrapper.
- `SVRef_FrameGate` gates `SV_Frame` (`sv_main.cpp:1162`). No gate holds the client frame, so `sv_stepper` and `ref_step` step the server and not the cgame.
- The stepper replays run on `openjkded.arm64`, which has no client, so no replay loads a cgame.
- `SVRef_ForceLegacy` forces the legacy ABI of the game only (`sv_referee.h:36`, `sv_gameapi.cpp:2812`).

The gate a cgame build can run today:

1. `swift build`, `swift build -c release`, and `swift test --no-parallel`, with a dlopen smoke of `dllEntry` and `vmMain` in the shape of `jampsmoke`.
2. The listen server of `notes/2026-10-29/human-recordings.md:7`, with the Swift library copied to `/tmp/jka-client/home/swift/cgamearm64.dylib` beside `jampgamearm64.dylib`. The gate reads the client log for a `portMissing` trap. It needs a person at the keyboard, and it compares nothing against a reference.
3. The fork's client-side instrumentation. The `SEAM` and `RSEAM` lines of `openjk/codemp/qcommon/msg.cpp:2120-2121` and `:2539-2540` print the player state the server writes and the client reads, and they are engine code, so they print with any cgame. The `RSTART`, `MISSVEC`, and `RSTEP` probes of `openjk/codemp/cgame/cg_predict.c:1103`, `:1219`, and `:1293` live in OpenJK's own C cgame. A Swift cgame replaces that library, so those lines stop unless the Swift prediction prints them. Commit 35e4184f calls these probes temporary.

No harness compares a Swift cgame with a C cgame frame by frame. OpenJK's C cgame is not Raven's: it uses `GetModuleAPI` and the `trap->` table, and its body has OpenJK's fixes.

## 8. The package

The game module needed these targets (`Package.swift:9-10`, `:23`, `:38`, `:44`, `:48`, `:50`, `:64-66`):

| Role | Game | cgame mirror |
|---|---|---|
| C headers | `CJKAMP_Game` | `CJKAMP_CGame`, declared at `Package.swift:24` |
| Views and typed traps | `JKAMP_Game` | `JKAMP_CGame` |
| Logic, the Raven files | `JKAMP_GameLogic` | `JKAMP_CGameLogic` |
| Shell, `dllEntry` and `vmMain` | `jampgame` | `cgame` |
| Product | `.library(name: "jampgame", type: .dynamic)` | `.library(name: "cgame", type: .dynamic)`, copied as `cgamearm64.dylib` |
| Smoke loader | `jampsmoke` | the same loader with the cgame library |
| Tests | `JKAMP_GameTests`, `jampgameTests` | `JKAMP_CGameTests`, `cgameTests` |

The cgame compiles 316 functions of `ui_shared.c` (section 1), and the UI module compiles the same file, so the package also needs one home for them, in the shape of `JKAMP_BG`. The C side has nine `ui_shared` types that the cgame and the UI define differently (`merge.log`: `itemDef_t`, `menuDef_t`, `displayContextDef_t`, and six more), so the two consumers do not share one C type for these.

## What blocks the first stage

The stops in pipeline order, each with its cause:

1. The generators have no module argument. `[sweep]` of `project.toml:10-16` fixes `mp-game` as the unit, and `skeleton.py:56-62`, `traps.py:44-46`, `channel.py:38-39`, and `manifest.py:25` fix the game folders and paths at import.
2. The store sweep stops on `cg_effects.c:401`. `SourceFile` at `table.py:98-99` reads strict UTF-8, and the file holds the Latin-1 byte 0xD7.
3. The skeleton has no cgame target. `target_of` at `skeleton.py:76-80` sends every cgame stem to `JKAMP_GameLogic`, and the state files at `skeleton.py:1292`, `:1302-1303`, and `:1330-1331` take the cgame variables in place of the game's. `[output] stubs` at `project.toml:22` lists no cgame folder.
4. The re-exports and the views stop at the game target. `reexport.py:39-42` re-exports three C targets and not `CJKAMP_CGame`, so the cgame enums such as `impactSound_t` have no spelling. `views.py` walks the four game roots of `rulings.py:18-21`, so 63 records have no view, and they cause 213 signature markers, 54 variable markers, and 1693 of the 1900 holes.
5. The cgame hand header does not exist. Six structs of cgame `.c` files have no C home, and `HAND_HEADERS` at `rulings.py:403` has no `CJKAMP_CGame` entry.
6. The traps write to the game. `traps.py:44-46` and `:367` fix the view target `JKAMP_Game`, the source `g_syscalls.c`, and the import of `CJKAMP_Game`. 22 of 217 cgame traps keep a marker until the views exist.
7. The manifest cites no cgame Rust. `skeleton.py:195` reads jka-rust under `game`, `bg`, and `qshared`, so the 14 matches are game namesakes and `jka-rust/crates/mp/cgame` is never cited.
8. The bg channel has one consumer. `channel.py:418-422` writes the install into the game logic target. Three `#ifndef QAGAME` bg functions are absent from `JKAMP_BG`, 11 bg functions the cgame calls are internal, and the cgame arms of the bg bodies stand on 12 `bg.consumer` tests against Raven's 129 conditionals.
9. The compile gate has no cgame flag. `draftcheck.py:345-348` gates the bg, game, and shared stems in a mirror of the game product, and no package target holds a cgame stem, so the cascade errors and the defects are not measured.
10. The package has no cgame Swift targets. `Package.swift` declares `CJKAMP_CGame` alone, so no view, logic, shell, or product target exists.
11. The host gate has no referee. The fork traces and steps the game only (`vm.cpp:291`, `sv_main.cpp:1162`), and the stepper runs the dedicated server, which loads no cgame. The listen server with a person at the keyboard is the only run that loads a Swift cgame today.
