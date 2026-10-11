# Docket proof of the bone slot conflict, rows F2, J5, and Q2

This record gives one shape for the bone fields of `entityState_t`, where the F2, J5, and Q2 proofs give three. No file under `Sources/`, `docs/`, or `tools/` changed, and no build ran.

### The 21 holes

Each Swift line is the `Raven wrote` line, with `portMissing` on the next line. Each Raven line is under `oracle/codemp/game/`.

| Raven's statement | EWeb_SetBoneAngles (F2) | NPC_SetBoneAngles (J5) | G2Tur_SetBoneAngles (Q2) |
| --- | --- | --- | --- |
| `int *thebone = &ent->s.boneIndex1;` | g_items.swift:1457, g_items.c:1505 | NPC_utils.swift:695, NPC_utils.c:912 | g_turret_G2.swift:41, g_turret_G2.c:30 |
| `int *firstFree = NULL;` | :1460, :1506 | :698, :913 | :44, :31 |
| `vec3_t *boneVector = &ent->s.boneAngles1;` | :1469, :1511 | :707, :918 | :53, :36 |
| `vec3_t *freeBoneVec = NULL;` | :1472, :1512 | :710, :919 | :56, :37 |
| `while (thebone) { ... }` | :1476, :1514-1550 | :714, :921-957 | :60, :39-75 |
| `if (!thebone) { ... }` | :1480, :1552-1565 | :718, :959-972 | :64, :77-90 |
| `VectorCopy(angles, *boneVector)` | :1488, :1570 | :726, :977 | :72, :95 |

### Raven's pointer walk

The three bodies are the same text, and only the warning string and the three orientation values differ. Each body has four pointer locals. `thebone` and `firstFree` point at one of `boneIndex1` to `boneIndex4`, and `boneVector` and `freeBoneVec` point at one of `boneAngles1` to `boneAngles4`. `thebone` and `boneVector` start at field 1. The loop reads `*thebone` three times, as a zero test, a non-zero test, and a compare with `boneIndex`. It copies `thebone` into `firstFree` and `boneVector` into `freeBoneVec` at the first free field. The `switch (i)` then moves `thebone` and `boneVector` together to field 2, 3, or 4, and `default` sets both to NULL. A `break` on a match leaves both at the matched field.

All four locals are read after the loop. `if (!thebone)` tests the pointer. In that arm, `thebone = firstFree`, the one write through a pointer to an index field is `*thebone = boneIndex`, and `boneVector = freeBoneVec`. The one write through a pointer to an angles field is `VectorCopy(angles, *boneVector)` after the arm. While `thebone` is not NULL, it points at field `i + 1`.

### The view

`lookup.py entityState_t` gives `boneIndex1` to `boneIndex4: Int32` and `boneAngles1` to `boneAngles4: JKAShared.vec3_t`, on `JKAMP.EntityState` in `Sources/JKAMP/Generated/Views/EntityState.swift`, with `nonmutating set` (`boneIndex1` at line 511, `boneAngles1` at line 541). The view's `raw` is internal, so an accessor that reaches the C memory lives in the `JKAMP` target. In `q_shared.h`, the four `int` fields are adjacent at lines 2799-2802, and the four `vec3_t` fields are adjacent at lines 2811-2814.

### jka-rust

`jka-rust/crates/mp/game/src/g_items.rs:1940`, `NPC_utils.rs:732`, and `g_turret_G2.rs:69` drop the pointers. Each has a `for i in 0..4` walk with an `Option<usize>` found slot and an `Option<usize>` free slot, 0 to 3, and a `match` on the slot for each field read and write. jka-rust changes the control flow, so it is not a model for the Swift statements.

### The guide

- Line 207 covers a pointer local over a `char *` parameter in the text sweep only.
- Lines 426-434: a pointer walk over a table of records is an index local, and a record pointer local set only to slots of one table is an `Int32` index local.
- Line 327: a field that a body indexes gets a `<name>Slots: Slots<View>` accessor on the view.
- Line 277: a `fileprivate` accessor in an extension on a view is the form of a `#define` alias of one field, not of a walk.
- Lines 370-395, the pointer to a chosen file-scope variable, need every store in one `if` chain, and this walk stores in a loop.

A hand extension on a generated view in its own view target has a precedent in `Sources/JKAShared/Views/Plane.swift`, and a hand `Slots` over C memory has a precedent in `Sources/JKAMP/BgTables.swift`.

### Verdict

The shape is J5's: one shared `Slots` accessor pair on `EntityState`, and four `Int32?` locals. The proposal is J5, with the slot index fixed at 0 to 3.

- The fields form a C array in memory, so the walk is the index local of lines 426-434, and the field set is a `Slots` of line 327. `slots[n]` reads and writes like `*thebone`, so no new verb names appear. The `switch` forms of F2 and Q2 need three verbs, `boneIndex(_:)`, `setBoneIndex(_:_:)`, and `setBoneAngles(_:_:)`, which Raven never wrote.
- The index is the `Slots` index 0 to 3, so `thebone` equals Raven's `i` in the loop. A field suffix 1 to 4 would put an offset on every subscript.
- Four locals keep Raven's four declarations and each of his stores as one Swift line. Q2's two locals drop `freeBoneVec = boneVector` and `boneVector = freeBoneVec`.
- Three bodies in three files use the accessor, and `raw` is internal to `JKAMP`. So the accessor is `public`, in one hand file `Sources/JKAMP/EntityState+Bones.swift`, not in `Generated/`. Three `fileprivate` copies in the logic target cannot reach `raw`.

```swift
extension EntityState {
    /// Raven's `boneIndex1` to `boneIndex4` as one array, slot 0 for `boneIndex1`.
    /// The four `int` fields are adjacent in `entityState_t`, so a pointer local over them is a slot index.
    public var boneIndexSlots: Slots<Int32> {
        let base = UnsafeMutableRawPointer(self.raw) + MemoryLayout<entityState_t>.offset(of: \.boneIndex1)!
        return Slots(scalars: base, count: 4)
    }

    /// Raven's `boneAngles1` to `boneAngles4` as one array, slot 0 for `boneAngles1`.
    public var boneAnglesSlots: Slots<JKAShared.vec3_t> {
        let base = UnsafeMutableRawPointer(self.raw) + MemoryLayout<entityState_t>.offset(of: \.boneAngles1)!
        return Slots(vectors: base, count: 4)
    }
}
```

One hole site per function. The other holes take the same form: `var firstFree: Int32? = nil`, `while thebone != nil {`, `case 0: thebone = 1` with `boneVector = 1`, `default:` with both `nil`, and `if thebone == nil {`.

```swift
var thebone: Int32? = 0                                  // g_items.swift:1457, EWeb_SetBoneAngles
ent.s.boneIndexSlots[thebone!] = boneIndex               // NPC_utils.swift:718 arm, NPC_SetBoneAngles
ent.s.boneAnglesSlots[boneVector!] = angles              // g_turret_G2.swift:72, G2Tur_SetBoneAngles
```

The ledger rows F2, J5, and Q2 of `frame-path-walk.md` name three shapes. This record gives the J5 row for all three rows.
