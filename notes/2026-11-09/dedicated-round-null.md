# Dedicated round: the null stems

Branch `dedicated-round-null`, off master at `1cdd22f`, in the worktree `/tmp/jka-ded-null`. The code commit is `0562b1d`. The round ran no generator. The fresh extract of mp-engine-ded is in `tools/oracle-closure/out/extract/`. The stems are null_client, null_snddma, null_glimp, null_renderer, and null_input of `oracle/codemp/null/`, Raven's null implementations for the dedicated build.

## Adoption

null_client.swift, null_snddma.swift, null_glimp.swift, and null_renderer.swift lose the skeleton header in the code commit. null_input.swift had no header on master, so it was adopted before this round. No signature changed, so the calls of the common round reach the client functions by their stub signatures.

## Bodies filled

- null_client: 19 functions. 17 are empty, CL_GameCommand and UI_GameCommand return `false`, and CL_Init reads `cl_shownet = Cvar_Get("cl_shownet", "0", CVAR_TEMP)` as Raven wrote at `null_client.cpp:13`. `cl_cdkey` is `CharBuf(bytes:)` of Raven's 17 bytes, the nine digits and eight zeros, the form of `ctfFlagStatusRemap` of g_team.swift.
- null_snddma: 10 functions. SNDDMA_Init and SND_RegisterAudio_LevelLoadEnd return `false`, SNDDMA_GetDMAPos, S_RegisterSound, and SND_FreeOldestSound return `0`, and the rest are empty. `gbInsideLoadSound` is `let gbInsideLoadSound: Bool = false`, the form of `player_locked` of g_ICARUScb.swift.
- null_glimp: 7 functions. QGL_Init returns `true`, and the rest are empty.
- null_renderer: 5 empty functions.
- null_input: 4 empty functions.

No body returns a pointer to a static, so no static ruling applies. No site changes Raven's form, so the round has no rule 24 line. `grep -c Unsafe` gives 0 on each file.

## Holes open

The six function pointers of `null_glimp.cpp:42` to `:49`, `qwglSwapIntervalEXT`, `qglMultiTexCoord2fARB`, `qglActiveTextureARB`, `qglClientActiveTextureARB`, `qglLockArraysEXT`, and `qglUnlockArraysEXT`, keep the generator's `TODO: Port global` marker. Each takes a Port-note that names row Z6. The table has no row for a C function pointer of these types, and no file of mp-engine-ded reads them. The readers are `tr_shade.cpp` and `tr_init.cpp` of the renderer, which row E5 makes a later stage. These are markers and not `portMissing` calls.

| File | portMissing left | TODO: Port left |
|---|---|---|
| null_client.swift | 0 | 0 |
| null_snddma.swift | 0 | 0 |
| null_glimp.swift | 0 | 6, row Z6 |
| null_renderer.swift | 0 | 0 |
| null_input.swift | 0 | 0 |

## Gate

- `swift build -j 2`: exit 0, 0 errors, and no warning in the five files.
- `swift test --no-parallel -j 2`: exit 0, 146 tests, 0 failures, 1 skipped, the interpreter test.
- `draftcheck.py --unit mp-engine-ded --stem null_client`: exit 0. 19 of 19 hand functions replaced, 0 holes, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass.
- `--stem null_snddma`: exit 0. 9 of 10 replaced, 1 kept, 1 hole, 0 cascade errors, 0 defects, and 0 compile holes over 1 pass.
- `--stem null_glimp`: exit 0. 7 of 7 replaced, 0 holes, 0 defects.
- `--stem null_renderer`: exit 0. 5 of 5 replaced, 0 holes, 0 defects.
- `--stem null_input`: exit 0. 4 of 4 replaced, 0 holes, 0 defects.

## Finding for a later row

The draft of S_RegisterSound reads Raven's `return 0` as a NULL into a `sfxHandle_t` and gives a hole, "Raven returns NULL, and the function returns a `sfxHandle_t`". `sfxHandle_t` is an `int`, so the hand body `return 0` is Raven's form, and draftcheck keeps it. The drafter treats a literal `0` returned as a handle typedef as a NULL.
