# The vmMain dispatch fill, second pass

This note records the build of the three rulings in `dispatch-fill-walk.md`. Steps 1 and 2 are committed on wave-0. Step 3 is held, because the smoke test in `swift test` fails when `GAME_INIT` calls `G_InitGame`. The brief says a failed gate stops the commit of its step.

| Step | Ruling | Commit | Gate |
| --- | --- | --- | --- |
| 1, the public markers | E1 | `303824b` | passed |
| 2, the six game tables | E2 | `34e7f5b` | passed |
| 3, the fill | rule 11 | none, held in `stash@{0}` | failed, 105 of 106 tests |

## Step 1, the public markers

The 39 internal callees of the dispatch are now `public` in their own files in `Sources/JKAMP_GameLogic/`. `BG_GetItemIndexByTag` and `GetIDForString` were public before, so all 41 callees are public. The globals `g_entities` and `gSharedBuffer` in `g_main.swift` and `world` in `g_local.swift` are public. `GameWorld` is public too, because a public `world` must have a public type. Its members stay internal.

The shell calls the `G_SoundIndex` of `g_utils.swift`, which is Raven's game function. The first pass named the `G_SoundIndex` of `Sources/JKAMP_BG/Generated/bg_callbacks.swift`, which is the bg channel forward. That forward stays internal, so the shell sees one name.

Every callee file is adopted, so skeleton.py writes none of them and each marker is a hand edit. No callee is a generated forward.

## The generator rule

`PUBLIC_NAMES` in `tools/oracle-closure/rulings.py` names the 41 functions and the two generated globals, 43 names. `Skeleton.access` in skeleton.py gives `public` to a game or bg function in the set, and `Skeleton.variable_access` gives `public` to a game variable in the set. A skeleton run and the signature rows therefore keep the marker. `skeleton.py --only g_main` printed `public` on `g_entities`, `gSharedBuffer`, `G_InitGame`, `G_ShutdownGame`, and `G_RunFrame`. `skeleton.py --only g_utils` printed `public` on `G_SoundIndex` and `G_ROFF_NotetrackCallback`. The `--only` mode writes nothing, and `git status --short` showed no file the runs moved.

## Step 2, the six game tables

`BgTables.swift` is hand code over C storage that tables.py writes. The game tables take the same shape in three parts.

- `tools/oracle-closure/tables.py` writes a second file, `Sources/CJKAMP_Game/g_tables.c`, with Raven's rows copied as written. The run left `Sources/CJKAMP/bg_tables.c` byte-identical.
- The hand header `Sources/CJKAMP_Game/include/g_tables.h` declares each table with its bound, and clang checks each bound against the initializer. `HAND_HEADERS` and `HAND_FILES` in rulings.py name the header, and the umbrella `CJKAMP_Game.h` includes it after `g_types.h`, the line a merge writes.
- `Sources/JKAMP_Game/GameTables.swift` binds one public `Slots` over each C array.

| Table | C element type | Bound | Swift element | Raven's text |
| --- | --- | --- | --- | --- |
| `setTable` | `stringID_table_t` | 212 | `StringIDTable` | `g_ICARUScb.c:52-268` |
| `TeamTable` | `stringID_table_t` | 5 | `StringIDTable` | `NPC_stats.c:14-21` |
| `ClassTable` | `stringID_table_t` | 57 | `StringIDTable` | `NPC_stats.c:24-86` |
| `BSTable` | `stringID_table_t` | 11 | `StringIDTable` | `NPC_stats.c:88-102` |
| `BSETTable` | `stringID_table_t` | 19 | `StringIDTable` | `NPC_stats.c:106-126` |
| `fields` | `BG_field_t` | 86 | `BgField` | `g_spawn.c:54-150` |

Each bound counts the end row. `BSETTable` needs Raven's `stringIDExpand` macro at `NPC_stats.c:104`, so the file copies that line as a macro block. `fields` reads `FOFS`, a pointer cast to `int`, so the file carries the same `-Wpointer-to-int-cast` pragma as the vehicle tables.

The six `TODO: Port global` lines in `g_ICARUScb.swift`, `NPC_stats.swift`, and `g_spawn.swift` are now plain comments that point to the storage. The logic target imports `JKAMP_Game`, so a body reads each table by Raven's name and needs no forward.

## Step 3, the fill

The fill replaces every `portMissing` stub of the shell's `vmMain` in `Sources/jampgame/jampgame.swift`. `GAME_INIT` calls `G_InitGame` with the three words, and 38 stubbed arms call their bare functions. With `GAME_GETITEMINDEXBYTAG`, all 40 arms call Raven's function, and no stub stays.

- A word that Raven reads as `int` becomes `Int32(truncatingIfNeeded:)` through a private `int32` helper.
- A `qboolean` word becomes `!= 0`, and a `Bool` return becomes 1 or 0.
- The `char *` return of `ClientConnect` goes through `StringPool.shared.pointer(for:)`, and the word is the pointer's bit pattern.
- `&g_entities[arg0]` becomes `g_entities[arg0]`, the `Entity` view.
- A `const char *` word becomes a `String` through `cString(at:)`, and a `float *` word becomes a `vec3_t` through `Slots(vectors:count:)`. Two private helpers, `text(at:)` and `vector(at:)`, hold these reads.
- Each ICARUS arm binds its record view over `gSharedBuffer` with the view's cast initializer, `IcarusSet(gSharedBuffer)`.

The gate of step 3 failed. `swift build` completed with 0 errors. `swift test --no-parallel` passed 105 of 106 tests. The binaries of 78, 13, and 14 tests passed. The smoke test "the loaded module answers GAME_INIT with the init line through G_PRINT" failed with this output:

```
jampsmoke exited with status 5: JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_InitGame, source: oracle/codemp/game/g_main.c:897
```

`swift run jampsmoke .build/debug/libjampgame.dylib` wrote this output and exited with code 133:

```
JKAShared/PortMissing.swift:4: Fatal error: TODO: Port G_InitGame, source: oracle/codemp/game/g_main.c:897
```

`G_InitGame` runs and stops at the hole at `Sources/JKAMP_GameLogic/g_main.swift:1015`, Raven's `srand( randomSeed )`. The draft did not compile there because `srand` takes a `UInt32`. The smoke driver is not a gate, but the smoke test asserts the placeholder init line, and that test is part of the gate.

The fill is in `stash@{0}`, "dispatch fill step 3, held: the smoke test fails", and a copy is at `/tmp/jampgame-step3.swift`. The working tree holds the committed shell, so a concurrent agent's gate stays green. `git stash pop` restores the fill.

## Docket rows

1. The smoke test after the fill. `Tests/jampgameTests/JampgameSmokeTests.swift` expects `GAME_INIT` to print `jka-swift jampgame init`. After the fill, `GAME_INIT` runs `G_InitGame` and stops at the first unported hole. The choices are these: change jampsmoke and the test to send `GAME_GETITEMINDEXBYTAG`, which needs no engine, and assert its answer, or fill the `srand` hole and assert the next stop, or keep the placeholder under `GAME_INIT` until `G_InitGame` runs. The proposed default is the first choice, because it tests the load and the dispatch without a dependency on the port of `G_InitGame`.
2. The `char **` out-parameter that may stay `NULL`. Raven's `GAME_ICARUS_GETSTRING` copies the text only when `Q3_GetString` sets it. The Swift `Q3_GetString` takes `inout String`, so the shell passes the buffer's own text and writes the result back. A call that sets nothing writes the same text again. The guide has no form for this shape. The proposed default is this form, written into `docs/transcription.md` as the form for a `char **` out-parameter with a null start.
3. The decode of a pointer word. Rule 11 lets the shell hold pointer code, but the guide shows no form for a `const char *` or `float *` word. The fill uses two private helpers in the shell. The proposed default is to keep them in the shell and name the form in `docs/transcription.md`.
4. The 16 Port-note holes that pass a game table. Bodies in `g_ICARUScb.swift`, `NPC_utils.swift`, `NPC_stats.swift`, `NPC_spawn.swift`, `g_spawn.swift`, and `g_main.swift` say "A Slots over one record has no form yet" where Raven passes `setTable`, `TeamTable`, `ClassTable`, `BSTable`, `BSETTable`, or `fields`. The tables now exist as `Slots`. The proposed default is to fill these holes in the next hole round of those files.
5. The logic `vmMain` in `Sources/JKAMP_GameLogic/g_main.swift:546`. The shell no longer needs it, and nothing calls it. The proposed default is to remove it when `g_main.swift` is re-spliced.
