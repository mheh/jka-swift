# The stage 2 names of the MP cgame module

This record holds the ruling on the names stage 2 of the cgame work reads: the package targets, the state prefix, the global state object, the shell, the product, and the tests. Stage 1 chose the first three on `cgame-generators` in the `[targets.mp-cgame]` row of `tools/oracle-closure/project.toml`, and its record `notes/2026-10-29/cgame-stage-1.md` states that they stand until a ruling of stage 2 changes them. The user delegated the rulings to the coordinator on 2026-10-29, and the coordinator proved each row in both trees before the ruling. No Sources, docs, or tools file changed for this record.

## N1. The three cgame unit names

Ratified as proposed on 2026-10-29.

| Role | Game | cgame |
|---|---|---|
| C headers | `CJKAMP_Game` | `CJKAMP_CGame`, declared at `Package.swift:24` |
| Views and typed traps | `JKAMP_Game` | `JKAMP_CGame` |
| Logic, the Raven files | `JKAMP_GameLogic` | `JKAMP_CGameLogic` |
| State prefix | `Game`, so `GameVariables`, `GameStorage`, `GameWorld` | `CGame`, so `CGameVariables`, `CGameStorage`, `CGameWorld` |

The proof. The `[targets.mp-cgame]` row holds `views = "JKAMP_CGame"`, `logic = "JKAMP_CGameLogic"`, and `state = "CGame"`. The skeleton on `cgame-generators` writes the three state names from the one prefix at `skeleton.py:803`, `:1318`, and `:1345`. Each cgame name is the game name with `C` before `Game`, the form `CJKAMP_CGame` already takes in the package.

## N2. The global state object

Ratified as proposed on 2026-10-29.

Both logic targets keep the global `world`. `JKAMP_GameLogic` declares `public nonisolated(unsafe) var world = GameWorld()` at `Sources/JKAMP_GameLogic/g_local.swift:822`, and `JKAMP_CGameLogic` declares the same line with `CGameWorld()`. Each shell resets its own at its entry point, as `Sources/jampgame/jampgame.swift:15` does.

The proof. Only `Sources/jampgame/jampgame.swift` and the three files of `Tests/JKAMP_GameTests/` import `JKAMP_GameLogic`. `Sources/JKAMP_BG` never names the global, and its one `world.` text is Raven's comment at `bg_pmove.swift:7393`. The two logic targets are separate modules, so the two globals clash with nothing, and the skeleton writes `"world"` as the instance name at `skeleton.py:1318`.

## N3. The shell, the product, the loader, and the tests

Ratified as proposed on 2026-10-29.

| Role | Game | cgame |
|---|---|---|
| Shell, `dllEntry` and `vmMain` | `jampgame` | `cgame` |
| Product | `.library(name: "jampgame", type: .dynamic)` | `.library(name: "cgame", type: .dynamic)`, copied as `cgamearm64.dylib` |
| Smoke loader | `jampsmoke` | the same loader with the cgame library |
| Tests | `JKAMP_GameTests`, `jampgameTests` | `JKAMP_CGameTests`, `cgameTests` |

The proof. Raven creates the module as `VM_Create( "cgame", ... )` at `oracle/codemp/client/cl_cgame.cpp:1771`, and the client loads `cgamearm64.dylib` from the mod folder (`notes/2026-10-29/cgame-scout.md:266`). The loader reads the library path from its one argument at `Sources/jampsmoke/main.swift:37` and opens it with `dlopen` at `:39`, so it serves both products. The two test targets mirror `Package.swift:64` and `:66`.

## The ledger

| Row | Verdict | Date |
|---|---|---|
| N1. The three cgame unit names | ratified as proposed | 2026-10-29 |
| N2. The global state object | ratified as proposed | 2026-10-29 |
| N3. The shell, the product, the loader, and the tests | ratified as proposed | 2026-10-29 |
