# Guide lines of phase 3, group 3

Each line gives the row, the line in `docs/transcription.md` after all edits, and the sentence as written. The items stand in the order applied.
- W28, line 696: A transcribed C function whose result Raven drops at most of its call sites, such as the `G_Spawn*` family, is `@discardableResult`, and a body writes Raven's line with no `_ =`.
- W17, line 659: `atof` returns `Double` as C's does, so a store into a `float` reads `x = Float(atof(s))`, and an add, a test, or a `%f` argument uses the `Double`, `val = Float(Double(val) + atof(ent!.parms!.parm[parmNum]))`.
- W7, line 633: A search that starts at a pointer into the buffer, `strstr(place+1, group)` or `strchr(s, ' ')`, searches the suffix and adds the offset back, `strstr(buf[(place! + 1)...], group)` plus `place! + 1`, so the result is the offset into the whole buffer.
- W20, line 627: and a `%s` on that arm reads the bound name, `va("cps \"%s\"", message)`.
- W15, line 619: A `default` label that Raven puts first or in the middle is the last arm, the `case` labels that share its arm drop, and the other arms keep Raven's order with no comment, because Swift puts `default` last and gives it no other label, and every such arm of Raven's ends in `break` or `return`.
- V34, line 558: A `float` literal with an integral value stored into an `int` is the integer literal, so `ps.gravity = 1.0f` reads `ps.gravity = 1`. Any other `float` stored into an `int` takes `Int32(...)` at the store, the mirror of the next rule.
- V18, line 556: For `gentity_t` the value is 1832, which `LayoutTests.swift` checks.
- V18, line 555: `byteCount` is `MemoryLayout<T>.size` over the imported C struct, and Swift keeps the C layout of an imported struct, tail padding included, so `size`, `stride`, and C's `sizeof` are equal.
- V36, line 551: A function-like macro whose C type is `double`, `crandom()`, returns `Double`, and its sites take the same widening.
- W18, line 550: so a compound assignment is a plain store with the left side widened, `drop = Float(Double(drop) + Double(speed) * 0.1 * Double(pml.frametime))`
- open point 7, line 550: A `float` literal that meets the `Double` keeps its single-precision value, `Double(0.2 as Float)`, because C promotes the rounded `float` and not the decimal.
- W4, line 512: Raven's store of a trap into a callback field of `pmove_t`, `pm.trace = trap_Trace`, uses the thunk in `Sources/JKAMP_Game/PmoveThunks.swift`, `pm.trace = PmoveThunks.trap_Trace`, because only the view target of the traps can pass the pointer words on.
- W30, line 447: A `char` array initializer takes `CharBuf(bytes: [...])` with Raven's character codes in hex, so the byte count stays Raven's.
- W13, line 341: A text local whose `NULL` initializer an `inout String` call overwrites before any read is a `String` with `""`, the same as one Raven left unset.
- V33, line 338: A caller passes an optional to a parameter that takes the optional as it holds it, with no force unwrap, ``G_Find(t, \.targetname, `self`.target)``.
- V14, line 339: A `String?` that Raven passes to a `%s` takes `?? "(null)"` at the argument in place of the force unwrap, with no comment, the text his `vsprintf` prints for NULL, `g_entities[entNum].script_targetname ?? "(null)"`.
- W16, line 251: Where the scale holds a call, `flrand`, `crandom`, `random`, `Q_irand`, or `Q_flrand`, the macro puts the call into each component, so the body writes one store per component with its own call, in the order 0, 1, 2, `enemy_eyes[0] = enemy_eyes[0] + NPC!.enemy!.client!.ps.velocity[0] * (eDist * flrand(0.95, 1.25))`.
- W2, line 230: A trap parameter that the engine only reads takes the scratch copy with a one-line comment that cites the engine read, and no note and no marker.
- W8, line 211: A pointer into a buffer passed to an `inout CharBuf` parameter that the callee does not write is a copy of the suffix, `var token = g_banIPs.stringBuffer[t...]` and `AddIP(&token)`.
- V15, line 180: A memset over any other partial size keeps its Port-note, and so does a memset with a value the rules above do not give or over a record with no view.
- V9, line 179: A memset of zero over the first N bytes of a `CharBuf` is Raven's `memset` in `JKAShared`, so `memset(buff, 0, MAX_STRING_CHARS)` over the `char buff[MAX_STRING_CHARS*4]` of `BuildShaderStateConfig` is `memset(&buff, 0, MAX_STRING_CHARS)`.
- W2, line 177: A memset of zero over a whole local array of records in the `count` form drops under the same conditions, and otherwise it is `zero()` on the `Slots`.
- W9, line 91: A vector parameter that the body never writes stays by value in a game stub, as `table.py` gives it.
- W19, line 505: The String-to-bytes codec lives only in the two `CharBuf` initializers, one byte for each scalar in both directions, and every other helper and view read works on bytes through `CharBuf`, as its C original does.

Count: 24 edits for 22 plan items (V18 is two lines, and the open point 7 sentence is the extra).

Every anchor text was found. W19 uses the amended codec sentence of the coordinator, not the Latin-1 sentence of the plan. The W18 edit sits inside the line, so its entry shows the changed clause. V34 keeps the compound-store sentence of line 556.
