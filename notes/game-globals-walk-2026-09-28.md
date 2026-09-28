# The game globals walk of 2026-09-28

This walk ruled on the rows the not-in-scope class of the game gate left open. The gate at 2256047 read 1444 "cannot find in scope" defects across the 66 unadopted game stems. An analyst grouped them by cause: bg names internal to JKAMP_BG, icarus enums with no entry header, enums declared in a .c file, locals lost across a goto label, game globals with only a marker, and one compiler macro. The generator families landed as shape work in the same round. The rows below are the rulings. Each row closed on a typed ruling under the ratification-walk shape.

## Ledger

| Row | Subject | Verdict | Commit |
|---|---|---|---|
| 1 | A bg declaration a game body names is public, functions and file-scope globals alike, through the skeleton rule and `skeleton.py --publish` over the adopted files | ratified as proposed | the commit after 2256047 |
| 2 | A `void *` file-scope global of the game module is a state variable on the world, spelled `OpaquePointer?` | ratified as proposed | the commit after 2256047 |
| 3 | `g_siegePersistant` and `spawns` are tables.py pieces in the game C target, read as a Slots. If the copy rule cannot carry the function pointers of `spawns`, it is a hand table on GameWorld, the defaultStyles shape | ratified as proposed, with the delta | the commit after 2256047 |
| 4 | `gameCvarTable` is a hand array on GameWorld with the cvar as a key path or closure, the name, the default, the flags, and the two booleans, and `gameCvarTableSize` is its count | ratified as proposed | the commit after 2256047 |
| 5 | `__DATE__` spells as the hand constant `buildDate` through HAND_MACROS, since Swift has no compile-time date | ratified as proposed | the commit after 2256047 |

## The vet

An opus agent vetted rows 1 to 4 against the oracle after their rulings. Rows 1 and 2 hold. Game code writes `siege_valid` and fills `siege_info` directly, and both already have a setter. `bg_fighterAltControl` is a game cvar, not a bg global, and stays out of the public rule. Every site of the two `void *` globals is a Ghoul2 trap call, an address for InitGhoul2Model or CleanGhoul2Models, or a NULL test. Rows 3 and 4 came back amended, and each amendment closed as a new row on a typed ruling.

| Row | Subject | Verdict | Commit |
|---|---|---|---|
| 3a | `g_siegePersistant` is the plain storage kind, one zeroed `siegePers_t` record on GameStorage, reached as `world.storage.g_siegePersistant` through its `JKAMP.SiegePers` view, which the SiegePers traps take. `spawns` is a hand Swift table on GameWorld, keyed by Raven's name, with a closure per spawn function, a `let` since Raven never writes it. G_CallSpawn looks up the name after the item loop. tables.py writes no game table for either global | ratified as amended | the commit after 2256047 |
| 4a | `gameCvarTable` and `gameCvarTableSize` become a hand Swift array on GameWorld of 140 rows, in Raven's order, for the build defines that closure.py uses. Each row holds an optional key path into GameStorage for the cvar handle, nil for the three NULL rows, plus the name, the default, the flags, a mutable `modificationCount`, `trackChange`, and `teamShader`. The array is a `var` because G_RegisterCvars and G_UpdateCvars write `modificationCount`. `trap_Cvar_Register` gets an overload that takes a nil handle, so the three NULL rows register | ratified as amended | the commit after 2256047 |

The evidence: `g_siegePersistant` is three scalars with a zero initializer, written by field and by memset, and passed by address to `trap_SiegePersGet` and `trap_SiegePersSet`, whose traps take a `JKAMP.SiegePers` view. `spawns` has one reader, G_CallSpawn, which walks it with strcmp, and its 186 names are unique. `cvarTable_t` has seven fields, and `modificationCount` is the one Raven writes. Three rows carry a NULL handle, and every one of the 137 live handles is a world.storage property.

## The round beside the walk

Three families landed as shape rules with no name rule. The bg public rule of skeleton.py covers bg globals, and `--publish` puts `public` on 136 declarations of the adopted bg files. The three icarus headers join the mp-game entry list. extract.py copies an enum a .c file declares into that file's constants header. Three game files gained `import JKAMP_BG` by hand. The game gate reads 1546 defects, from 2656, and the not-in-scope class reads 334, from 1405. The bg gate still reads 97 holes and 0 defects.

Two more rounds landed in the same commit. The labeled() rule of draft_statements.py opens a scratch closure around the whole labeled region when a record local precedes a goto label, which closed the 220 errors of WP_SaberPositionUpdate, and the game gate read 1381 defects and 144 not-in-scope. The build of rows 2, 3a, 4a, and 5 then took four shape rules in skeleton.py, the NIL_OVERLOADS table of traps.py, the HAND_MACROS spelling in the drafter, and the hand spawn and cvar tables on GameWorld in g_local.swift, and the game gate read 1578 holes, 1297 defects, and 68 not-in-scope. The build reads 0 errors and 106 tests pass. The walks over the two hand tables in G_CallSpawn, G_RegisterCvars, and G_UpdateCvars are holes, since the drafter cannot yet turn a pointer walk over a hand table into a loop.

## The LSTATE walk

One row closed on a typed ruling after the three rounds. No header of the MP tree declares an LSTATE name, and every file the gate reports declares the names it uses, so a file-private constant is the C-faithful home.

| Row | Subject | Verdict | Commit |
|---|---|---|---|
| L1 | A .c enum whose enumerator names collide with another .c file of the module is emitted by skeleton.py as `private let` constants at the top of that file's stub, in Raven's order with Raven's values. extract.py keeps reporting it and places nothing. A .c enum with no collision stays in that file's constants header | ratified as proposed | the commit after this one |

## Open after the walk

- Two icarus TYPE_ names depend on an enum g_ICARUScb.c declares before the include, so the header parse drops it, 2 errors.
- SABERINVALID, a .c macro, 4 errors.
- The pointer-walk local of g_mover, `pushed_pIndex`, emitted with no declaration, 1 error.
- A flag-mode scratch closure nested in another emits `if earlyOut2 { return }` where `return true` is due, in Jedi_CheckJumps, TryUse, and UpdateClientRenderinfo.
- A pointer walk over a hand table as a Swift loop, five holes in g_spawn and g_main.
