# Docket proof, conflict 6: the `Com_sprintf` arm of H3

## Raven's C

`oracle/codemp/game/g_ICARUScb.c:3651-3690` holds `Q3_SetParm`.
The counter arm runs when `Q3_GameSideCheckStringCounterIncrement` (`:3406-3429`) gives a nonzero value, so `parmValue` starts with `+` or `-` and a number.
It writes `Com_sprintf( ent->parms->parm[parmNum], sizeof(ent->parms->parm), "%f", val )` at `:3677`, with `val` a `float` that holds the increment plus `atof` of the old row.
The format is `"%f"` with one `float` argument, promoted to `double`. The longest text is 47 bytes: 39 integer digits of `FLT_MAX`, the point, six decimals, and a minus sign. `inf` and `nan` are shorter.
With its NUL the text is at most 48 bytes, so it always fits the row. Only the declared size passes 64. `sizeof(ent->parms->parm)` is 1024, the whole field.
`Com_sprintf` (`q_shared.c:985-1005`) calls `Q_strncpyz( dest, bigbuffer, 1024 )`, which calls `strncpy( dest, src, 1023 )` and sets `dest[1023] = 0` (`q_shared.c:826-840`).
`strncpy` pads with NUL to 1023 bytes, so every call writes 1024 bytes from the row start, for any text length.
For `parmNum` 0 this clears rows 1 to 15 inside `parms_t`.
For `parmNum` N above 0 it clears rows N+1 to 15 and writes 64*N bytes past the end of `parms_t` into the `G_Alloc` pool, an overrun.
Raven's readers of `parm` read a row as text: `g_ICARUScb.c:1226` (`atof`), `:1604` (`sscanf "%f %f %f"`), `:1681` (a `char *` out), and `NPC_spawn.c:1679-1681` (a copy to a spawned NPC through `Q3_SetParm`). No reader depends on the clear of the later rows.

## The field

`lookup.py gentity_t parm` reports no such field. The field lives one pointer down.
`lookup.py gentity_t parms`: `parms_t * parms -> parms: Parms?`, declared `g_local.h:148`.
`lookup.py parms_t parm`: `char[16][64] parm -> parm: Slots<String>`, declared `g_public.h:666-670`, with `MAX_PARM_STRING_LENGTH` equal to `MAX_QPATH`, 64.

## jka-rust

`jka-rust/crates/mp/game/src/g_ICARUScb.rs:3011-3020` formats `format!("{:.6}", total as f64)` and writes it with `write_cstr_field(&mut (*parms).parm[parmNum as usize], ...)`.
`write_cstr_field` (`crates/mp/bg/src/cstr_util.rs:49-59`) bounds the write by the row: `let n = bytes.len().min(dest.len() - 1);` and `dest[n] = 0;`.
So jka-rust writes the row only, with no pad, no clear of later rows, and no note.

## Guide and Swift helpers

`docs/transcription.md:164-167` gives the `nameBuffer` accessor and puts `Com_sprintf` on the `Buffer` spelling.
`docs/transcription.md:177` keeps a Port-note on a memset over a partial size. No guide line covers a `Com_sprintf` whose size passes its buffer.
`docs/porting-rules.md:44`, rule 19, allows a divergence on a buffer overrun with a note of at most two lines.
`Sources/JKAShared/CharBuf.swift:36` and `:42` hold `precondition(... index < self.count, "CharBuf write past the end")`, so a write past the buffer traps and never truncates.
`Com_sprintf` (`Sources/JKAShared/q_shared.c.swift:949`) calls `Q_strncpyz`, whose `strncpy(&dest, src, destsize - 1, ...)` pads to `destsize - 1` and whose `dest[destIndex + destsize - 1] = 0` (`:719`) traps at size 1024 on a 64-byte row.
An `at:` form over one 1024-byte `CharBuf` of the whole field does not help: at offset 64*N with size 1024 it traps for every N above 0.

## Verdict

The `Com_sprintf` arm writes into the 64-byte row with size `MAX_PARM_STRING_LENGTH`, under a two-line rule 19 note that names Raven's 1024.
The only drop is the NUL pad past the row, which clears later rows and, for any row above 0, overruns `parms_t`. jka-rust drops it too.
A Port-note does not fit, because the site has one defined form. The whole-field shape traps on 15 of 16 rows.

```swift
val = Q3_GameSideCheckStringCounterIncrement(parmValue)
if val != 0 {
    val += atof(ent!.parms!.parm[parmNum])
    // Raven passes sizeof(parm), 1024, and the NUL pad clears the later rows and overruns parms_t past row 0.
    // The "%f" text is at most 47 bytes, so the row size gives the same row bytes.
    Com_sprintf(&ent!.parms!.parmBuffers[parmNum], MAX_PARM_STRING_LENGTH, "%f", val)
} else {
    strncpy(&ent!.parms!.parmBuffers[parmNum], parmValue, MAX_PARM_STRING_LENGTH)
    if ent!.parms!.parmBuffers[parmNum][MAX_PARM_STRING_LENGTH - 1] != 0 {
        ent!.parms!.parmBuffers[parmNum][MAX_PARM_STRING_LENGTH - 1] = 0
        G_DebugPrint(WL_WARNING, "SET_PARM: parm%d string too long, truncated to '%s'!\n", parmNum, ent!.parms!.parm[parmNum])
    }
}
```

Side finding: Swift `atof` returns `Float` (`Sources/JKAShared/CString.swift:125`), so `val += atof(...)` adds in `float`, and Raven adds in `double` and narrows once. The last bit of the sum can differ. jka-rust keeps the `double` add.
