# The table cache and the generic core, rulings of 2026-10-05

The user asked for a local database under the generator pipeline, a line-by-line map from the C to the destination language, a core that knows nothing of jka, and a design modelled on c2rust. A Fable agent read tools/oracle-closure/ and the c2rust source and proposed the design. The user delegated the open rows to the coordinator, and these are the rulings.

## Measurements

One cold manifest.py run takes 99 seconds. The Clang parse takes under 2, the thirteen sweeps about 71, and the skeleton's own body walk about 20. The sweeps iterate to a fixed point across both translation units, so a per-file cache key is unsound.

## Rulings

| Row | Question | Verdict |
|---|---|---|
| C1 | The order of the work. | Three stages, each with a gate. Stage one: the store, the agnostic schema, the loader, lookup.py from the store, and a project file for the paths and constants the sweeps read, with no behavior change and a byte-for-byte check of every generator's output. Stage two: the syntax rows, the lowering pass that writes statement rows, the per-language printer, the line map with roles, align, and compare. Stage three: the remaining project names behind the config and the plugin hooks, one module per commit. |
| C2 | The cache key. | A whole-input key over every file both units include, the tool modules that feed the facts, and the stub adoption lines, with a per-file hash kept so the tool names what invalidated it. Two generations: the store-sweep facts are keyed with stub adoption, every other fact without it, so a stub edit during transcription costs the store sweep alone. |
| C3 | How a hand-finished body keeps the line map. | A re-alignment pass with difflib against the draft's lines, keyed by the hand file's hash, never a marker in the destination text. |
| C4 | The text-reader set. | The core holds the libc entries, and the plugin adds the project's, as c2rust's known_fn table holds libc alone. |
| C5 | The record roots of the read sweep. | The sweep is core, the root classifier is a plugin hook that returns a root label or none. |
| C6 | The shape rules of spelling.py. | The printer owns the scalar table for its language, the plugin owns the typedef entries, and spelling.py splits along that line. |
| C7 | The hole reasons that name project constructs. | The core detects the construct and asks the plugin for the reason text through a hook keyed by the construct. |
| C8 | Whether lowering and printing are one module. | Two modules. The store's lowered rows are the boundary, and the printer never reads a Clang cursor. |
| C9 | The goto policy. | The named forms per label and the hole stay. No stage reaches for a control-flow graph or a relooper, because the line map depends on the statement as the unit. |

## Adjustments from the c2rust read

The store holds the exported syntax beside the facts, so the printer is Clang-free. A macro-provenance table records the macro Raven wrote beside the call we print. The lifted role means a line that runs before the statement's own line. The eight plugin hooks of the proposal, the unit bridge, the foreign calls, the record form, the rulings, the cite, the reference index, the placement, and the parse prelude, are the project layer.

## Method

An opus agent builds stage one in a red-green loop at the seams the brief names. A Fable agent verifies the result against the proposal before the cache is used. The work runs on a worktree branch and lands after the round of R36 to R58 commits.
