# The q_shared hole round walk

The walk of the nine docket rows in `q_shared-holes.md`, one row per message under the ratification-walk skill. The rows are D1 to D9 in the record and Q1 to Q9 here, because the g_main walk of the same day holds rows D1 to D4. Every row was ratified as proposed.

| Row | Verdict | What the ruling orders |
|---|---|---|
| Q1 | ratified as proposed | The reexport writes `errorParm_t` into JKAShared, with `--probe` so the probed spellings stay. A re-splice of q_shared then takes the nine `Com_Error` calls. |
| Q2 | ratified as proposed | The guide form for `vsprintf` into a buffer is `strcpy(&buf, JKAShared.format(fmt, args))`, with `len = strlen(buf)` where Raven reads the return. |
| Q3 | ratified as proposed | `CString.swift` gets `strncpy(_:_:_:at:)`. |
| Q4 | ratified as proposed | A hand `Q_strncpyz(_:_:_:at:)` in the shape of `Q_strcat(_:_:_:at:)`. |
| Q5 | ratified as proposed | `Int32Indexing.swift` gets a subscript over an `Int32` range and an `Int32` count. |
| Q6 | ratified as proposed | `Q_IsColorString(_:at:)` takes any integer offset. |
| Q7 | ratified as proposed | `CString.swift` gets `tolower` and `toupper`. |
| Q8 | ratified as proposed | `Info_ValueForKey` takes the form of `va`: a local buffer, and the index drops. |
| Q9 | ratified as proposed | The two NULL-guard notes on `Q_stricmp`, `Q_stricmpn`, and `Q_strncmp` go. The two `char` sign notes become plain comments in STE form. |

## The work the rulings order

1. The helpers of Q3, Q5, Q6, and Q7 in JKAShared, each with its `/// Source:` line where one applies.
2. The reexport of Q1 with `--probe`, and the guide forms of Q2 and Q8 in `docs/transcription.md`.
3. One re-splice of q_shared, then the hand fills of Q2, Q4, Q8, and Q9, and the holes the new helpers unblock.
