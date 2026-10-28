# The three-byte entity box, resume notes

State as of 2026-09-29. Three untracked files sit at the repo root: `solid_encode.c` is the demo of the pack and the decode, `solid_encode.md` is the finding against the oracle, and this file holds the Lugormod findings, the fix design, and the open rulings. Nothing is committed and no fix is written.

## The fault in one paragraph

The engine packs a solid entity's box into `entityState_t.solid` as three bytes at `oracle/codemp/server/sv_world.cpp:211-231`, and `msg.cpp:892` sends the field as 24 bits. The int assignments truncate each float, only `maxs[0]` stands for x and y, and each byte clamps to 1..255. The client rebuilds an integer, square, centered box at `oracle/codemp/cgame/cg_predict.c:254-261`. The server traces the true float box and the client traces the rebuilt one. Every difference between the two is the symptom. The clamp is the server's. The client has no clamp because a byte cannot hold more.

## Lugormod findings

The upstream clone is at `/tmp/Lugormod-v3-develop`, NexiloDev develop at commit b802220 from 2025-11-23, deepened to 400 commits. It vanishes on reboot. Re-clone with `git clone --branch develop https://github.com/NexiloDev/Lugormod-v3 /tmp/Lugormod-v3-develop`. Your own fork at `~/Developer/Milo/Lugormod-v3` is on the fix-documentation branch and was not touched.

The mod ships no engine. The `server` folder holds one header and the only build target is the game library, so the pack is the stock engine's.

Every model entity goes through `SpawnEntModel` in `game/Lmd_Entities_Ents.c`, which has about a dozen callers, among them `misc_model_breakable`, `misc_model`, the property entity, and the mod missile. For an md3 with no `mins` or `maxs` keys it reads the first frame's bounds from the file at `game/g_utils.c:166`, rotates the corners by the entity angles in `FixBox` at line 97, then multiplies both vectors by `modelScale[0]` at lines 202 and 203. The keys and the scale stack. So the box is fractional, non-square, and off-center at scale 1, and the scale only widens the gap. The fallback box for an md3 with no frames at lines 184 and 185 has mins positive and maxs negative, so it is inside out. The glm branch defaults to an integer centered box and does not show the symptom.

The mod sends the scale to the client as a percent in the short `iModelScale`, and the client reads it at `cgame/cg_ents.c:1448` and `cg_ents.c:2972` for rendering only. The drawn model is correct at any scale and never depends on `solid`. The mod's `cgame/cg_predict.c` decode is Raven's text unchanged.

The mod's `trap_LinkEntity` at `game/g_syscalls.c:346` is already a wrapper with mod logic, since logical entities skip the syscall there. That is the home for the snap. The game may also overwrite `s.solid` after a link, because the engine reads the field at snapshot time, and Raven does this with the value 2 for sabers, sentries, and traps. The override chooses the bytes but cannot widen the field.

The NoBounce merge, pull request 110, is a cvar about sliding off player heads and is unrelated. The md3 box code dates from the mod's initial commit in April 2025, so the history does not show what changed for chairs.

## The catwalk numbers

The md3 at `models/map_objects/factory/catw2_b.md3` in `~/Developer/jka/oracle-server/base/assets1.pk3` has one frame with bounds -64 to 63.984375 in x, -64 to 64 in y, and 0 to 8 in z.

| Key | Server box x and y | Server box z | Client box x and y | Client box z |
|---|---|---|---|---|
| no scale | -64.00 to 63.98 | 0 to 8 | -63 to 63 | -1 to 8 |
| modelscale 2 | -128.00 to 127.97 | 0 to 16 | -127 to 127 | -1 to 16 |
| modelscale 9 | -576 to 575.86 | 0 to 72 | -255 to 255 | -1 to 72 |
| modelscale 10 | -640 to 639.84 | 0 to 80 | -255 to 255 | -1 to 80 |

The ceiling is 255 in x and y and downward in z, and 223 upward in z because the pack adds 32 before the clamp. A 1000-unit box goes out as 255 in x and y and 223 upward.

## The symptoms, each with its cause

The edge rubber band is the truncation of `maxs[0]`. The client lets the player in by the dropped fraction and the server pushes back.

The bounce when standing on a scaled model is the truncation of the top. The server floor is the true top and the client floor is the truncated top, so the client predicts a fall every frame and each snapshot puts the player back. The decimal scale trick works because it finds a scale where the scaled top lands near a whole number.

The bounce on a catwalk at scale 10 is the clamp. Past 255 units from the origin the client sees no floor at all. Inside that ring everything agrees to within a unit, which is why a test near the middle looks fine.

## The fix design

Tier 1 is a link-time snap inside the mod's `trap_LinkEntity`, ahead of the syscall. It rewrites `r.mins` and `r.maxs` into the exact box the engine will pack and the client will decode, so the server's stored box, the wire bytes, and the client box are the same value by construction. It skips brush models, entities whose contents are not solid or body, and vehicles, which the client already rebuilds itself. It is idempotent, so base entities and repeated links are no-ops. It is server-only, works on the stock engine and any cgame, and needs no change at any spawn site. It covers every box that fits in the bytes, which includes chairs, the scale-2 catwalk, and every fractional top. About fifteen lines in one file.

Tier 2 covers boxes past 255 with proxy tiles. A tile is a bare entity with a general type, a model index of zero, zero contents on the server, and a hand-packed `solid` written after each link, since the engine zeroes the field at link for zero contents. The engine sends every linked entity in the PVS regardless of contents at `sv_snapshot.cpp:342`, the client clips against any entity with a nonzero `solid` at `cg_predict.c:73`, and `CG_General` draws nothing for a model index of zero. The parent keeps its one true box for server traces, damage, and use. Overlapping squares of up to 510 units cover any rectangle exactly. The parent's own packed square needs an override to zero, or to an inner square, so it does not stick out in y. A catwalk at scale 10 is 1280 units wide and needs three tiles per axis, nine in total. The snapshot cap is 256 entities per client and the entity table is 1024 slots.

Tile existence can be lazy. The tiling stays fixed, and a tile is spawned when a player's box comes within a few hundred units of the true box in three dimensions, and freed with hysteresis at a larger distance. The radius must cover the server frame, the snapshot interval, and the network delay at running speed, so 10 units is far too small. Lazy tiles bound the slot cost by player count instead of model count. Start with static tiles and switch to lazy only if a real map runs out of slots.

## Rejected ideas, with the reason

Per-client boundaries are not possible from the game module. One entity state per entity feeds every client's snapshot, built in one pass after the game frame with no per-client hook.

A vertical panel is not representable, because x and y share one byte and every decoded box is a square in the ground plane. Only a horizontal slab is thin, and a square column covers the top too, so the slab buys nothing.

A proxy that moves each frame lags the player by the network delay on the client, and a proxy that jumps to a new edge is interpolated through the interior and sweeps a solid box through the player. Fixed tile positions have neither problem. Send once and let the empty delta carry it.

Temp entities are one-shot events the client never clips against. The breakable class carries health, use, pain, die, and a model, so it must not be the proxy.

An engine change is out of reach for old mods, and even a fork cannot widen the field without a protocol break.

## Open rulings

1. The square choice in the snap. The outer square keeps the whole model inside the box at the cost of blocked space beside the narrow sides. The engine's own `maxs[0]` lets players clip into the long sides visually. Recommendation is the outer square.
2. Static tiles or lazy tiles for tier 2. Recommendation is static first.
3. Whether the fix lands in Lugormod only, or also in the jka-swift port. In the port the trap file is generated by `tools/oracle-closure/traps.py`, so the snap would live in a hand-written link function the generated trap calls.
4. Whether to read skymod's server-side fix if its source is available.

## Test plan for the fix

Place `catw2_b` at scale 2 and walk into its side for the edge case. Place it at scale 2.1 and stand on it for the bounce. Place it at scale 10, walk along the top past 255 units from the origin, then drop off the far end and walk back into the side at ground level for the ring. The command form is `/place misc_model_breakable 0 model,models/map_objects/factory/catw2_b,spawnflags,1,modelscale,2,` and mins must be negative when given by hand.
