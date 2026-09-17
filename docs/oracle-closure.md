# Oracle closure

`tools/oracle-closure/` is the tool suite that carries Raven's C into the Swift port. It is a transpiler with a judgment layer on top of it. Every answer it gives comes from one libclang parse of the oracle, with the compile flags of Raven's own Release configuration, so the tool states what the C compiler states and never a guess. `tools/oracle-closure/README.md` is the per-script reference, and this document holds the shape.

## 1. The pipeline

1. **The parse and the closure.** `closure.py` parses one module, alone or as a unity translation unit over every `.c` file of the module. `modules/<name>.py` holds the flags, the include roots, and the entry headers of that module. It answers three questions about a type or a function: its dependency closure, its by-value or pointer-only class, and its size and field offsets. Every other script reads this parse.
2. **The C targets.** `extract.py` copies each kept declaration out of the oracle as a verbatim slice, one file per struct, union, enum, or typedef, with a constants file per Raven header and `layout_asserts.h` from the oracle's own numbers. `merge.py` compares the trees by code identity and partitions them into the SwiftPM C targets: `CJKAShared` for what MP and SP agree on, the tree targets, and a target per module for the rest. `check.sh` compiles each target for every triple.
3. **The re-exports.** `reexport.py` writes one Swift file per Raven header under a view target's `Generated` directory, so a logic target reaches Raven's macros, enums, and scalar typedefs without an import of C. `--probe` builds, reads the rejected names, and moves each one down a ladder of fallbacks.
4. **The table and the rulings.** `table.py` maps a C parameter or return to its Swift spelling by shape. `rulings.py` maps by name: which struct gets a view, which return is optional, which field is never NULL, which function is not ported and why. A shape rule is code, a name rule is data, and a name rule lands only by a ruling.
5. **The views.** `views.py` walks the closure of each root struct and writes one view per reached type. A view holds a pointer into engine-owned C memory and gives one Swift property per C field. A fact about the C belongs to `table.py`, so `views.py` builds a `Table` over the generator it already holds, runs the sweeps, and reads the subscript sweep's field set from it. The set says which pointer field gets the second accessor of its view.
6. **The skeleton.** `skeleton.py` writes one Swift stub file per Raven `.c` file, in Raven's order, each function with Raven's comment block, a `/// Source:` line, the table's signature, and the marker pair of rule 14 as its body. It also writes the thunk namespaces, so a stored function keeps one address for the life of the module.
7. **The traps and the channel.** `traps.py` writes one typed function per Raven `trap_*`, each one call through `Syscall.call`. `channel.py` writes the bg channel of rule 23: one bare function per strap and per game callback, each forwarding to a closure the consumer installs.
8. **The manifest.** `manifest.py` writes one table per Raven `.c` file under `.claude/manifest/`, one row per function, with the oracle line range, the Swift stub line, the marker state, the jka-rust line range, and the table's current signature. `rosetta.py` writes the C to Swift type stones, and `lookup.py` answers one question against the stones and the manifests with no parse.
9. **The body drafts.** `bodies.py` translates a function body statement by statement from Raven's AST and prints the draft to standard output. It never writes into `Sources/`.
10. **The compile gate.** `draftcheck.py` splices the drafts of one file into a mirror of the package under `.build-draft/` and builds the game product there. The working tree does not change.

## 2. The layers

The analysis layer is language-independent. It holds the parse and the flags of `closure.py`, the dependency closure, the layout table of `extract.py`, the function and symbol sweeps of `fnsweep.py` and `symsweep.py` with their global read and write census, and the C-side reading of each statement in `bodies.py`. Its shape is the Visitor's: a walk over clang's cursor kinds, which rarely change, under operations that are added often. The dispatch is a branch on the kind, with no type of its own. `extract.py`'s `IfResolver` is the Interpreter of this layer. It holds the grammar of Raven's `#if` expressions and evaluates it, and one evaluator stands where the book puts one type per rule.

The emission layer is Swift-specific. `table.py` is its type table, and each `Param` carries the kind that picks the emission. The views and the re-exports are Adapters: the C struct and the C macro are the Adaptee, and the Swift property and the Swift `let` are the interface the caller expects. A generated trap is a Proxy of the book's remote kind, a local stand-in for a service in the engine's address space. A thunk adapts a Swift function onto a C function pointer field. The closures of the bg channel are one-method Strategies, and `installBgChannel()` binds them.

The per-project layer is `rulings.py` and the docket rulings behind it: the names, the signatures, and the exceptions that no C type alone decides.

The seam between analysis and emission is the parse, `closure.py`'s declaration map, and `extract.py`'s tree, none of which carries a Swift word. `table.py` is the first file above that line. A second emitter for another language would replace `table.py` and the writers above it, and would keep everything below. The book's Builder names that shape, one construction path and several representations. The suite holds one emitter, so its own form line reads "none", and the parts below the seam are the parse and the type tree in the estate's words.

`lookup.py` is the Facade over the generated stones and manifests, the one entry a blind transcriptor uses. `merge.py`'s partition to a fixed point, `draftcheck.py`'s mirror build, and `bodies.py`'s registry of `inout` positions match no pattern in the book. They are the partition, the gate, and the index in the estate's own words.

## 3. The judgment layer

The tool marks what it cannot decide instead of inventing an answer. A hole is that mark, and it has three parts: a Port-note that states what is missing, Raven's C text on a `// Raven wrote:` line, and a `portMissing` call that traps at run time. A draft with holes compiles as far as it goes, and one grep lists every hole by its Raven subject.

A cascade is a compile error that follows from a hole, because the hole swallowed the declaration of a local that later lines read. A defect is a compile error that stands on its own, which means the draft translated something wrongly. `draftcheck.py` reports the three counts apart, so the holes measure the work left and the defects measure the tool. The compile gate is the proof. A draft that builds in the mirror carries no defect the Swift compiler can see, and the port's own gate, `swift build`, `swift build -c release`, and `swift test --no-parallel`, is the same proof one level up.

## 4. The invariants

- `oracle/` is read-only. Every script reads it and no script writes into it. A Windows-style include path is shadowed in memory, and the file on disk keeps Raven's text.
- A `Generated/` directory is regenerated whole and is never edited by hand. Each file there carries its note and the rule it serves.
- An adopted stub is left alone. A stub becomes adopted when its generated header line is deleted, and the generator then reports it instead of writing over the port.
- The rulings hold the names. A generator reads `rulings.py` and never invents a name, a shape, or an exception of its own.
