# Docket proofs, the conflict of rows C2 and S1

Rows C2 and S1 drop a C truth test of an array's address, which is always true. The C2 proof drops the test with no comment, and the S1 proof adds one comment line. This record finds which form is correct. jka-rust is the submodule `jka-rust/` at the repository root, and a "guide" line is a line of `docs/transcription.md`.

## The hole sites

| Row | Swift site | Raven line | Tested name | Kind |
| --- | --- | --- | --- | --- |
| C2 | g_combat.swift:2792, marker :2793 | g_combat.c:3491 | `limbName` | local `char limbName[MAX_QPATH]`, g_combat.c:3440 |
| C2 | g_combat.swift:2894, marker :2895 | g_combat.c:3608 | `limbName`, `stubCapName` | local arrays, g_combat.c:3440 and 3442 |
| S1 | NPC_AI_GalakMech.swift:297, marker :298 | NPC_AI_GalakMech.c:275 | `point` | local `vec3_t point`, NPC_AI_GalakMech.c:240 |

`point` in `NPC_GM_Pain` is not a parameter. The signature at NPC_AI_GalakMech.c:238 is `(gentity_t *self, gentity_t *attacker, int damage)`. The body copies the global `gPainPoint` (g_combat.c:4575) into the local at :245. The one reference to the function is the pain pointer store `func = NPC_GM_Pain` at NPC_spawn.c:172, and a pain call such as `radiusEnt->pain( radiusEnt, NPC, 100 )` at NPC_AI_Rancor.c:266 passes no point. No caller can pass NULL, so the premise that `point` is a parameter is wrong. The `vec3_t point` parameter belongs to `G_Dismember` (g_combat.c:3436), and that function does not test it. The two rows are the same case: a truth test of the address of a local array. C always takes the arm.

## The guide

Line 334 drops a null guard on a view parameter "with no comment and no marker". Line 335 extends the drop to an `inout` parameter, a non-optional text local, and a never-null variable. Line 447 forwards a `NEVER_NULL_VARS` name non-optional. Line 617 covers a truth test of a record's `char name[N]` field, which reads the first byte and is a different test. No guide line asks for a comment at a dropped never-null test. No line names a local array, so the C2 extension of line 335 is necessary for both rows.

## Compiled precedent

A script paired each `/// Source:` function in `Sources/JKAMP_GameLogic/` with its Raven body. It found 93 Raven tests of the form `!name` or `name == NULL` on a parameter that Swift makes non-optional (`Entity`, `GClient`, or `String`), and the Swift body has no test for them. 93 have no comment line and 0 have one. One hit at w_saber.swift:7072 matched on an unrelated comment. A search for "always true", "never null", or "test drops" in the comment lines of `Sources/JKAMP_GameLogic/` finds nothing. The nearest array case is `WP_SaberCanBlock` (w_saber.c:9276, w_saber.swift:8117): Raven tests `!point` on a `vec3_t` parameter, and the Swift drops the term with no comment.

The S1 proof says that R11 and R13 ask for the comment. The ledger `frame-path-walk.md` withdrew both rows, because the fills follow lines 334-335 with no comment.

## jka-rust

In `G_Dismember`, g_combat.rs:3711-3712 and 3844, both terms drop with no comment. In `NPC_GM_Pain`, NPC_AI_GalakMech.rs:318-319, two comment lines name the always-true test. jka-rust drops the whole `if (0)` block and its `else`, and those lines are the only record of that removed code. The Swift keeps `if 0 != 0` and the `else` arm, so the Swift page still shows the code, and the jka-rust reason does not apply.

## Verdict

No comment. C2 is correct, and the S1 form changes to match it. The two sites are the same case, and line 335 adds "the address of a local or file-scope array" to its never-null list for both. The Port-note, the `// Raven wrote:` line, and the `portMissing` line leave the file at each fill.

`G_Dismember`, g_combat.swift:2791-2793:
```swift
if ent.ghoul2 != nil && trap_G2API_GetSurfaceRenderStatus(ent.ghoul2, 0, String(limbName)) != 0 {
    //is it already off? If so there's no reason to be doing it again, so get out of here.
    return
}
```

`G_Dismember`, g_combat.swift:2893-2895 (`trap_G2API_SetSurfaceOnOff` is `@discardableResult`):
```swift
if ent.s.eType == ET_NPC && ent.ghoul2 != nil {
    //if it's an npc remove these surfs on the server too. For players we don't even care cause there's no further dismemberment after death.
    trap_G2API_SetSurfaceOnOff(ent.ghoul2, String(limbName), 0x00000100)
    trap_G2API_SetSurfaceOnOff(ent.ghoul2, String(stubCapName), 0)
}
```

`NPC_GM_Pain`, NPC_AI_GalakMech.swift:294-299. After the fill no line reads `point`, so the compiler can warn that `var point` at :262 is written but never read.
```swift
} else {
    //store the point for shield impact
    //	VectorCopy( point, self->pos4 );
    //	self->client->poisonTime = level.time;
    //rwwFIXMEFIXME: ..do this is as well.
}
```
