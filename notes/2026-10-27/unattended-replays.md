# The unattended run over the test recordings

This record holds the unattended run of 2026-10-27 night on the branch `unattended-replays`, after PR 2 merged the wild-replay rows into master at 5227562. The user handed over three tasks: clear the `TODO: Port` labels, clear the `portMissing` calls, and get the game through the test recordings, with the standing word that Raven's code is not adulterated. The rulings here are the coordinator's, in the pattern of the ratified rows of `client-connect.md`, and the user reads them after the fact.

## The labels

The tree held 19 `TODO: Port` lines and no hole behind any of them. Sixteen were the label `skeleton.py` wrote on the stub of a C-stored table, which `tables.py` serves and `BgTables.swift` exposes, so the `storage_data` arm of the skeleton writes the comment line alone now, and the sixteen label lines went from the six bg hand files. One was the initializer line of `bg_poolTail` in `BgVariables.swift`, which the hand line of `BgState.init` holds, so the skeleton writes it as a plain note. Two were the macros `NAV_HEADER_ID` and `NODE_HEADER_ID`, four-character constants of `g_nav.h` that no `.c` file of the module reads, so they take two `NOT_PORTED_MACROS` rows and the reexport writes "Not ported" with the reason.

The reexport run also rewrote twelve other generated declaration files, because the toolchain is Swift 6.4 and its importer takes macros the earlier run spelled as Swift expressions, and one of them, `BSP_IDENT`, it does not take, so the build failed. Those twelve files went back to their committed text, and only `g_nav.swift` kept the run. The importer probe of `reexport.py` depends on the toolchain, which is an open point for a later row.

## The defaults

The 82 `portMissing` calls left in the tree were the default closures of the bg channel callbacks and the engine straps in `bg_callbacks.swift` and `bg_strap.swift`, which the game binds at load. `channel.py` writes each default as `fatalError` with the hook's name and Raven's cite now, so a consumer that installs nothing still fails at the first call and names it, and no `portMissing` call is left in the Sources. `PortMissing.swift` stays, because the skeleton writes it into the stub of a function a future round ports.

## The recordings

Every recording the project holds replays end to end with `g_teamAutoJoin 1` and the stepper:

- The three ffa1 corpora of 2026-07-07, `corpus-ffa1.rec` with 2 kills and 4 pickups, `corpus-ffa1-combat.rec` with 2 kills and 10 pickups, and `corpus-ffa1-human-1.rec` with no kill, as the record session had none. The kills and pickups show that the lost attack button of the jka-rust plan was the spectator parking, not the button.
- The eight wild recordings, which passed under the rows X16 to X21 of `client-connect.md`.
- Five of the eight jka-rust input logs under `jka-rust/tools/referee-oracle/logs/`, converted by `tools/reflog2rec.py` into engine recordings at 20 frames per second: `real-duel1-idle`, `real-duel1-walk`, `force-duel`, and `real-duel1-combat` on `mp/duel1`, and `real-ffa1-items` on `mp/ffa1` with 4 kills and 8 pickups. The three logs on the mock map `arena3`, `idle`, `melee-brawl`, and `solo`, have no BSP in the engine and do not convert. The converted files sit beside the corpora under `~/Developer/jka/seam-test/referee/`.

No recording raised a trap in this run, so no code row was needed beyond the labels and the defaults.
