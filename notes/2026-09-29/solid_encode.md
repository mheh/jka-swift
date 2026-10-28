# The three-byte entity box

## Symptom

A mod places a `misc_model_breakable` with a `modelscale` key. On the client, a player can walk a short distance into the box. The next snapshot pushes the player back out. The client box is smaller than the server box.

## Cause

The server packs the entity box into `entityState_t.solid` for client prediction. The field goes over the wire as 24 bits, at `codemp/qcommon/msg.cpp:892`. Three bytes carry the whole box, and the pack loses data in three ways.

`SV_LinkEntity` in `codemp/server/sv_world.cpp:194-231` does the pack. It declares `int i, j, k` and assigns the float box into them:

```c
i = gEnt->r.maxs[0];
j = (-gEnt->r.mins[2]);
k = (gEnt->r.maxs[2]+32);
gEnt->s.solid = (k<<16) | (j<<8) | i;
```

1. The int assignment truncates each float. A half-width of 20.8 becomes 20. The cast drops the fraction and does not round.
2. Only `maxs[0]` stands for x and y. The pack never reads `maxs[1]`, so a box that is not square gets the wrong y extent.
3. The pack never reads `mins[0]` or `mins[1]`. A box that is not centered on its origin gets a centered client box.

`CG_ClipMoveToEntities` in `codemp/cgame/cg_predict.c:218-260` unpacks the bytes into `int x, zd, zu`. It builds a box of plus and minus `x` in both x and y, and traces against it with `trap_CM_TempBoxModel`. The server traces against the true float box in `r.mins` and `r.maxs`. Every difference between the two boxes shows as the symptom.

## Why old mods show it

Base MP has no `misc_model_breakable` in its spawn table. A mod ports the SP spawn from `code/game/g_breakable.cpp`. Its scale block at lines 1210 to 1220 multiplies each axis of the float box by `s.modelScale`. A scale that is not an integer, or a `modelscale_vec` with different x and y factors, gives a box the three bytes cannot carry. Base entities have integer, square, centered boxes, so base play does not show it.

## Demo

`solid_encode.c` beside this note holds both functions with minimal types. Build and run it with `cc -o solid_encode solid_encode.c && ./solid_encode` from `notes/2026-09-29/`. The gap column is the distance the client lets a player into the box.

```
ok      scale 1.50  server maxs[0] 24.00  client 24.00  gap 0.00
chopped scale 1.30  server maxs[0] 20.80  client 20.00  gap 0.80
chopped scale 2.10  server maxs[0] 33.60  client 33.00  gap 0.60
```

## Fix direction

The wire format cannot change without a protocol break. The game or mod side can round the scaled box to integers, and keep it square and centered in x and y, before it links the entity. Then the server box and the client box agree.
