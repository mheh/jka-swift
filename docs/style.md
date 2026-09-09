# Style

The style for everything written in this repository: Swift code, comments, doc comments, documentation, commit bodies, and pull request text. Rule 21 of `docs/porting-rules.md` points here. A reviewer holds a change to this page, and a contributor needs nothing outside the repository to follow it.

## Sentences

Prose follows Simplified Technical English in its general form. The rules that matter most:

- One instruction per sentence. Keep an instruction under twenty words and a descriptive sentence under twenty-five.
- Active voice with a named actor. "The parser reads the file", not "the file is read".
- The short common word. Use, not utilize. Start, not initiate. Before, not prior to. Make sure, not ensure.
- One name for one thing. Do not call the same item by two names.
- No contractions. Use the articles a, an, and the.
- No semicolons. Write two sentences.
- No em dashes. The plain hyphen is the only dash.
- No marketing words: seamless, robust, powerful, effortless.
- American spelling.

Headings, labels, `MARK` lines, and the given, when, then narration in a test are headings, not sentences. A terse noun phrase is legal there.

"We" is a legal actor when the team or the codebase acts.

## Line breaks in comments and docs

A line break is a semantic act, never a length fix.

- One sentence per line. Put the break after each sentence.
- A break inside a sentence is legal at one clause boundary, when the sentence reads better in two parts.
- The column limit for a comment line is 150. Below it, length is never a reason to break. A sentence that would pass 150 breaks at a clause boundary, never at the column and never mid-word.

The test: join the broken lines back together. If the break sat under 150 columns and width was its only reason, the break is wrong.

Wrong, the machine tell:

```swift
// The sim thread reads it once at renderer boot, and the pump
// publishes it again on every resize so the carrier stays
// current.
```

Right, one sentence per line:

```swift
// The sim thread reads it once at renderer boot.
// The pump publishes it again on every resize, so the carrier stays current.
```

Prose files such as this one do not hard-wrap. A paragraph is one line in the source file, and the reader's editor wraps it.

## Doc comments

- A method gets one or two lines: what it does, plus the one behavioral fact a caller must know. Never parameter and return ceremony.
- A type gets two or three lines: what it is, why it exists as a type, and how it operates in concrete words.
- An enum carries a glossary in the type's doc after a blank `///` line, one bullet per case, each a noun phrase.
- A constant gets two lines: what it is, then the heuristic behind its value.
- A protocol glosses its small requirements inside the type doc, not per member.
- A conformance never repeats the protocol's doc.
- If a thorough doc feels like four lines, write two.

Single backticks mark inline code. Double-backtick DocC links cross-reference symbols.

## Inline comments

- Never narrate mechanics.
- Write a disposition label on a semantically distinct switch or catch arm: `// The send failed, so this error is permanent.`
- Write a block-intent marker where it matters: `// This block must not throw.`
- Write a guard's meaning, not its condition again: `// We need both values, or the state is wrong.`
- Write a phase label in a long body, imperative: `// Record the reason as a synthetic bounce.`
- If this code is the only home of some knowledge, the comment grows to carry it. Otherwise five words.
- A log line attracts no comment.
- A `TODO` always carries its subject. The porting rules fix the form for unported work: `// TODO: Port <Raven subject>`.

## Raven's comments and source lines

A comment Raven wrote is quoted source. It is kept verbatim, never reflowed, and never linted to these rules. The generators emit the block Raven placed above a function as a `/** */` doc comment above the stub, and a ported body keeps the comments inside the function.

Every generated and every ported item carries a `/// Source:` line directly above its declaration, beneath any Raven block, in the form `oracle/codemp/game/g_mover.c:1226`. Raven's block is `/** */` and ours is `///`, so a reader can tell the two authors apart without reading.

```swift
/**QUAKED func_door (0 .5 .8) ? START_OPEN x CRUSHER
TOGGLE		wait in both the start and end states for a trigger event.
*/
/// Source: oracle/codemp/game/g_mover.c:1226
func SP_func_door(_ ent: Entity) {
```

## Swift syntax

- Explicit `self.` everywhere, no exceptions.
- When a call wraps, every parameter gets its own line. A short call stays inline. This binds test code the same as source code.
- A guard is one line when trivial, expanded when the else has a body.
- An unexpected early-out never returns silently. It logs with the function's name.
- A blank line separates multi-line switch cases and marks effect phases. Related one-liners cluster into blocks.

## Organization

- All variables at the top of the type, stored and computed. A bigger type puts `// MARK: - State` inside the body.
- Big-bodied computed vars go in one extension right after the type. A single-situation computed var goes in its concern's extension.
- One extension per concern, with `// MARK: - <Concern>` above the extension as a header.
- Tests may carry given, when, then narration comments, and `@Test("plain speech scenario name")` display names stay.

## Prose surfaces

READMEs, pull request text, issue text, and commit bodies are unwrapped paragraphs in the sentence form above. A commit subject and a pull request title are headings, so a terse noun phrase is legal there. A commit carries no co-author trailer and no generated-with footer. A quoted code snippet in a document matches the current code, including its comment style. A Mermaid block never contains a semicolon in message or note text, because GitHub's renderer fails on it.

## Banned voice

Old comments in related repositories show these patterns. Do not write them.

- No casual deflation: "All this does is convert", "This is a simple struct that".
- No lowercase sentence starts, missing periods, or fragments.
- No anthropomorphism: "our environment disappeared underneath us".
- No bafflement markers such as `(???)`. Write the sentence: `// We did the correct steps, and this failed anyway.`
- Do not leave an old-voice comment as written. Lint every comment you touch.

## Self-check before returning text

1. Any sentence over twenty words? Split it.
2. Any semicolon or em dash? Replace it with a period, a comma, or a plain hyphen.
3. Any contraction? Expand it.
4. Any passive voice with a known actor? Make it active.
5. Any comment line broken under 150 columns at a width instead of a sentence end? Join the lines and re-break per sentence.
6. Any comment line over 150 columns? Break it at a clause boundary.
7. The same thing named two ways? Pick one name.
