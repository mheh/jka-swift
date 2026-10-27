# The guide lines of the frame-path rulings

The 21 items of "Guide lines in `docs/transcription.md`" in `frame-path-walk.md`, written into `docs/transcription.md`. Each line number is the file after the edit, and the rows follow in parentheses.

1. Line 325 gains the cast of a table name as the view cast over slot 0 (A4).
2. Line 552 gives `sizeof(T)` into an `int` as `Int32(View.byteCount)`, beside line 554, the `float` into `int` store (A5).
3. Line 539 gives a `qboolean` operand where C reads an `int` as `(b ? 1 : 0)` (A6, F1).
4. Lines 545 and 546 give the split of an expression into typed `let` locals under one comment (B1).
5. Line 659 gives a `memcpy` of `strlen` bytes at an offset as `strncpy(&dest, String(src), len, at: off)` (B2).
6. Line 654 lists `tolower` and `toupper`, and line 656 gives `(unsigned char) c` as `Int32(UInt8(truncatingIfNeeded: c))` (B3).
7. Line 555 gives `sizeof(t)/sizeof(t[0])` of a Swift array as `t.count`, compared with no cast (B4, C1).
8. Line 179 gives a zero `memset` over the first N bytes of a `CharBuf` as `zero(count:)`, and line 180 keeps the Port-note for any other partial size (B5).
9. Line 419 extends the ring of static buffers to any function that returns it as a `String`, and line 420 follows it (B6).
10. Line 337 adds the address of a local or file-scope array to the never-null list, with no comment (C2, S1).
11. Line 622 extends to a text local whose every read is a byte read, a `CharBuf` or a `CharBuf?`, and to a byte read of a `char *` field (D4, O3, Q1).
12. Lines 623 and 624 give a post-increment as the old value read, then the step on the next statement, with Q4's limits and the `return` case (D5, I4, Q4, T1).
13. Line 540 gives an `int` or `byte` compared with `qfalse` as `== 0` and with `qtrue` as `== 1`, with no comment line (E2, H2, P1, T2).
14. Lines 367 to 369 give a scratch closure over a loop body, with `continue` as `return`, the step after the closure, and `break` as a returned flag (F3, M3, Q3, I3).
15. Line 556 gains an `int` compound store from a `float` as `x = Int32(x op f)` (N1).
16. Line 162 gives a second generated overload of a trap that takes the view (O4).
17. Line 153 joins the trap lines and the `while` rule for a `(Int32, String)` trap in a `while` test (O5).
18. Line 251, the VectorMA row, gains the double-scale form, spelled per component (R1).
19. Lines 339 and 340 give every `String?` that Raven passes to a `%s` as `?? "(null)"` at the argument (R2, C1, U2).
20. Line 557 gains an `int` passed to a `float` parameter as `Float(...)` at the argument (R5).
21. Line 342 gives an early-out whose arm does work as a `guard` with Raven's test negated and his arm in the `else` (R10).

## Unruled

1. Item 15 names line 542, but the `float` into `int` store rule stood at line 543, the line A5 also cites. The compound store went onto that rule, now line 556, and old line 542, the `Double` conversion rule, is unchanged.
2. Items 2 and 7 stand before the `float` into `int` line, so its words "the mirror of the next rule" still point at the `int` into `float` line.
3. Item 21 replaces the sentence "A guard that does other work on the NULL path keeps a Port-note." of line 342, because the new form covers that case. No proof says what, if anything, still keeps the Port-note.
4. Item 19 replaces `?? ""` with `?? "(null)"` for the runtime-test case of `Debug_Printf` as well, and line 340 keeps that case as a reason. The guide line asks for no rule 19 note at the `?? "(null)"` read. The C1 ruling puts a two-line note at the `modNames` read, and the R2 proof shows none at its site.
5. Item 8 joins the old partial-size Port-note sentence into the next line, "A memset over any other partial size ...".
6. Item 9 states that the index drops "with its world property and its forward in the game module", for `index_vtos`, and keeps the one comment line of line 421.
7. Item 11 places the `char *` field form of Q1 on line 622 beside the local form, with the bind on the arm where Raven reads the field.
8. Item 2 gives no sentence on `size` against `stride`, because the two are equal for `gentity_t` and the A5 ruling adds no rule for it.
