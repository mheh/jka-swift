# The game gate at 6bbbb37

`draftcheck.py --game` ran once on 2026-09-29 at 6bbbb37, the commit that carries the colliding .c enums as private stub constants, the nested flag return, and the file-scope walk pointer.

| Measure | 289dc26 | 6bbbb37 |
|---|---|---|
| Holes | 1578 | 1579 |
| Cascade errors | 0 | 0 |
| Defects | 1297 | 1233 |
| Cannot find in scope | 68 | 5 |

The tail of the output shows SABERINVALID with four and SOLID_BBOX with one. The count of five is a tail count, not a proof. TYPE_ORIGIN and TYPE_ANGLES of interpreter.h are still not in scope, since g_ICARUScb.c declares TK_USERDEF before it includes the header and the header parse drops the enum. The review in unity-parse-review.md section 4 proves it.

The agent read only the tail of the output, so this note has no per-stem table and no count per class. The tail shows tri_coll_test at 6 defects, w_force at 13, and w_saber at 25. The classes the tail shows after not-in-scope, without counts:

- Function pointer type mismatches for EntityTouch, EntityThink, EntityPain, and EntityDie across g_weapon.
- The immutable `vec3_origin` constant passed as inout across several stems.
- Optional unwrapping required in w_saber.
- Binary operator mismatches, such as Float against Double and Entity against Slots.

A class table with counts belongs in this folder after the next full read of the output.
