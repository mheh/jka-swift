# Docket proof of conflict 5, the bound of row B4

This record proves the open choice of row B4: Raven's `>` in `Cmd_GameCommand_f`, or jka-rust's `>=`.
"Guide" means `docs/transcription.md`, and "rules" means `docs/porting-rules.md`.

### Raven
**Table.** `oracle/codemp/game/g_cmds.c:1812-1820` declares `static char *gc_orders[]` with seven rows, index 0 "hold your position" to index 6 "report".

**Test.** `g_cmds.c:1835` reads `if ( order < 0 || order > sizeof(gc_orders)/sizeof(char *) ) { return; }`, and the quotient is 7.
The test lets `order` 0 to 7 through, so `order == 7` reaches `G_Say( ent, &g_entities[player], SAY_TELL, gc_orders[order] )` at `:1838` and again at `:1839`.

**C memory.** `gc_orders[7]` is the first pointer-sized word after the end of the object.
The source does not decide what that word is. The next static in the file is `gameNames` at `:1851`, but it is `static const char *[]`, so the compiler can put it in a different section from the non-const `gc_orders`.
The read is undefined behavior: `G_Say` gets an unknown `char *` and formats it with `%s`, so the server either says a neighbor's string or reads a bad address and crashes.

### Swift side
`gc_orders` is a `[String]` of seven rows at `Sources/JKAMP_GameLogic/g_local.swift:115`, and `gc_orders.count` is 7.
With the ruled form `order > gc_orders.count`, `order == 7` passes the test, and `gc_orders[order]` at `g_cmds.swift:1758` stops with "Index out of range".
The trap ends the process that holds the module, which is the server.

### jka-rust
`jka-rust/crates/mp/game/src/g_cmds.rs:2008-2013`:
```rust
        // C's guard `order > sizeof(gc_orders)/sizeof(char*)` is off by one and
        // lets order == 7 index a 7-element array (UB read). Bound at `>=` so the
        // out-of-range case is a deterministic no-op instead of a panic.
        if order < 0 || order as usize >= gc_orders.len() {
```

`jka-rust/docs/audits/quirk-ledger.md:228`, Q-32, records it as class UB-divergence, "PROPOSED keep. §19 requires one defined behavior and the no-op is it."

### The guide
Rules line 8, rule 2: "If Raven's behavior is unclear, port it faithfully first, even if ugly."
Rules line 44, rule 19: "Diverge only where Raven's behavior is undefined ... Pick the one defined behavior, note it in at most two lines at the site ... A Swift trap on an out-of-range index is a divergence of this kind when Raven read past the end, and the note says what Raven read."
Guide line 13: "The port carries Raven's behavior, not jka-rust's."
No line uses the words "bug" or "defect". Rule 19 is the rule, and it names the Swift trap as the defined behavior for a read past the end.

### Precedents
No `JKAMP_GameLogic` site carries such a note. The `k += 1` loop of `AI_SortGroupByPathCostToEnemy` at `NPC_AI_Utils.swift:191` keeps Raven's defect with no comment, and `SelectRandomTeamSpawnPoint` in `g_team.swift:924` carries none.
Two compiled sites in `JKAShared` carry the rule 19 note in one line.
- `Sources/JKAShared/q_shared.c.swift:127`: `// Raven reads the byte before the buffer for an empty path, and the Swift subscript traps there.`
- `Sources/JKAShared/q_shared.c.swift:953`: `// Raven's vsprintf overruns \`bigbuffer\` past 32000 bytes, and strcpy traps there.`

### Reach from a client
`ClientCommand` at `g_cmds.c:3433-3434` sends `gc` to `Cmd_GameCommand_f`, and the intermission gate at `:3341` is the only filter.
`CG_TargetCommand_f` at `cg_consolecmds.c:13-23`, console command `tcmd` at `:283`, sends `gc <crosshair player> <atoi(arg)>` with no range test.
Any client can type `tcmd 7` at a crosshair player, or send `gc 0 7` direct. The read is reachable, and in Swift one client stops the server.

### Verdict
Keep `>` under a one-line rule 19 note, in the form of the two `q_shared` precedents.
Rule 19 names the Swift trap as the defined behavior, guide line 13 rejects jka-rust as a source, and the two compiled precedents keep Raven's test the same way.
The remote stop of the server is the one reason to rule `>=` in its place. That choice is a user ruling outside the guide, and it needs a rules line.
The site removes the `Port-note`, the `Raven wrote` line, and `portMissing`:
```swift
    // Raven's `>` lets `order` 7 read one past the seven rows of `gc_orders`, and the Swift subscript traps there.
    if order < 0 || order > gc_orders.count {
        return
    }
```
