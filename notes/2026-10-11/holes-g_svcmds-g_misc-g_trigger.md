# Hole round: g_svcmds, g_misc, g_trigger

The docket is the Port-note lines of the three adopted files. The round fills 50 of 64 holes, 10 stand, and 4 are blocked. No hole needs a GameWorld property.

## g_svcmds.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| StringToFilter | `if (*s < '0' \|\| *s > '9')` on a stepped `char *` parameter | filled | The parameter keeps its `inout CharBuf`, and the index local `sIndex` is the byte offset of Raven's `s`. The print reads the suffix, `String(s[sIndex...])`. |
| StringToFilter | `while (*s >= '0' && *s <= '9') num[j++] = *s++` | filled | The byte moves through the generic subscript, then `j` and `sIndex` step. |
| StringToFilter | `if (!*s) break` | filled | `if s[sIndex] == 0 { break }`. |
| StringToFilter | `s++` | filled | `sIndex += 1`. |
| StringToFilter | `f->mask = *(unsigned *)m` | stands | The guide has no form that reads four bytes as one `unsigned`. Docket row 1. |
| StringToFilter | `f->compare = *(unsigned *)b` | stands | Docket row 1. |
| UpdateIPBans | `*iplist = 0` | filled | `iplist[0] = 0`, the dereference of a named buffer at offset 0. |
| UpdateIPBans | `*(unsigned *)b = ipFilters[i].compare` | stands | Docket row 1. |
| UpdateIPBans | `Com_sprintf(iplist + strlen(iplist), ...)` | stands | `Com_sprintf` takes `inout CharBuf` with no `at:` offset. Docket row 2. |
| G_FilterPacket | `char *p` local | filled | A read cursor over the buffer `from`, `var p = TextCursor()`. |
| G_FilterPacket | `p = from` | filled | `p = TextCursor(from)`. |
| G_FilterPacket | the parse loop over `*p` | filled | `p.byte` reads and `p.advance()` steps. The comma statement `i++, p++` is two statements. The local `m` is `[Int32]` in the draft where Raven declared `byte m[4]`, so `m[i]*10 + ...` does not truncate as C does. That declaration is outside this docket. |
| G_FilterPacket | `in = *(unsigned int *)m` | stands | Docket row 1. |
| AddIP | `ipFilters[i].compare = 0xffffffffu` | filled | The literal is a `UInt32` at the store, as the `compare` tests of the file read it. |
| G_ProcessIPBans | `char *s` local | blocked | The write-cursor form gives an `Int32` offset over `g_banIPs.stringBuffer`. The fill needs the `strchr` overload that takes an offset into a buffer and the offset it returns, which `CString.swift` holds outside the read set. |
| G_ProcessIPBans | `char *t` local | blocked | Same fact as the row above. |
| G_ProcessIPBans | the `for` loop over `*t` | blocked | Same fact, and also the way to pass the offset `t` to the `inout CharBuf` of `AddIP`. |
| Svcmd_RemoveIP_f | `ipFilters[i].compare = 0xffffffffu` | filled | As in AddIP. |
| Svcmd_ListIPs_f | `*(unsigned *)b = ipFilters[i].compare` | stands | Docket row 1. |
| G_SaveBanIP | `*(unsigned *)b = ipFilters[i].compare` | stands | Docket row 1. |
| G_LoadIPBans | `ipFilters[i].compare = 0xffffffffu` | filled | As in AddIP. |
| G_LoadIPBans | `StringToFilter(token, &ipFilters[i])` | filled | The caller with a `String` passes `var tokenBuf = CharBuf(token)` and `&tokenBuf`. Raven drops the `qboolean` result, so the build may warn on the line. |
| ClientForString | `s[0] >= '0' && s[0] <= '9'` on a `const char *` parameter | blocked | The form makes `s` a `CharBuf` at the top of the body. Then `Q_stricmp(cl!.pers.netname, s)` takes a `String` and a `CharBuf`, and the overload set of `Q_stricmp` in `q_shared.c.swift` is outside the read set. |
| Svcmd_ForceTeam_f | `SetTeam(&g_entities[cl - level.clients], str)` | filled | `SetTeam(g_entities[level.clientsSlots.index(of: cl!)], String(str))`, the index form for a pointer minus its own table. |

## g_misc.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| TeleportPlayer | NULL `right` into `AngleVectors` | filled | The sig keeps a plain `inout`, so the call site carries a plain comment that names the NULL outputs and keeps the scratch local. |
| TeleportPlayer | NULL `up` into `AngleVectors` | filled | Same comment as the row above. |
| SP_misc_skyportal | `isfog += G_SpawnVector(...)` | stands | The guide has no form for a `qboolean` as an `int` operand. Docket row 3. The sig table also gives `G_SpawnVector` an `inout Float` output where Raven passes a `vec3_t`. |
| SP_misc_skyportal | `isfog += G_SpawnInt("fognear", ...)` | stands | Docket row 3. |
| SP_misc_skyportal | `isfog += G_SpawnInt("fogfar", ...)` | stands | Docket row 3. |
| ammo_power_converter_use | `int add = 0.0f;` | filled | `var add: Int32 = Int32(0.0)`, the float-into-int store. Raven's `//,highest;` stays. |
| ammo_power_converter_use | `add = ammoData[i].max*0.1` | filled | `Int32(Double(ammoData[i].max) * 0.1)`, the double widening and the store into `int`. |
| ammo_power_converter_use | `if (add < 1) add = 1` | filled | |
| ammo_power_converter_use | `activator->client->ps.ammo[i] += add` | filled | |
| ammo_power_converter_use | `self->count -= add` | filled | |
| fx_runner_link | `G_Find(target, FOFS(targetname), ent->target)` | filled | `\.targetname` for `FOFS(targetname)`. |
| fx_runner_link | `G_Find(target, FOFS(targetname), ent->target2)` | filled | |
| maglock_link | NULL `right` into `AngleVectors` | filled | Plain comment, as in TeleportPlayer. |
| maglock_link | NULL `up` into `AngleVectors` | filled | |
| TAG_Add | `Q_strncpyz((char *) tagOwner->name, owner, MAX_REFNAME)` | filled | `Q_strncpyz(&tagOwner!.nameBuffer, owner!, MAX_REFNAME)`, through the field's `nameBuffer` accessor. |
| TAG_Add | `Q_strlwr((char *) tagOwner->name)` | filled | `tagOwner!.name = Q_strlwr(tagOwner!.name)`, the value form through the setter. Raven's `//NOTENOTE` comment stays. |
| TAG_Add | `Q_strncpyz((char *) tag->name, name, MAX_REFNAME)` | filled | As for `tagOwner`. |
| TAG_Add | `Q_strlwr((char *) tag->name)` | filled | As for `tagOwner`. |
| ref_link | `gentity_t *target = G_Find(NULL, ...)` | filled | |
| ref_link | the `if (target)` block | filled | Raven's comments stay. The print force-unwraps `ent.targetname`. |
| misc_weapon_shooter_aim | `gentity_t *targ = G_Find(NULL, ...)` | filled | |
| misc_weapon_shooter_aim | the `if (targ)` block | filled | Raven's `//FIXME` comment stays. |
| SP_misc_weapon_shooter | NULL `right` into `AngleVectors` | filled | Plain comment, as in TeleportPlayer. |
| SP_misc_weapon_shooter | NULL `up` into `AngleVectors` | filled | |

## g_trigger.swift

| Function | Reason | Verdict | Note |
|---|---|---|---|
| Touch_Multi | NULL `right` into `AngleVectors` | filled | Plain comment that names the NULL outputs. |
| Touch_Multi | NULL `up` into `AngleVectors` | filled | |
| Do_Strike | NULL `mins` into `trap_Trace` | filled | The call already passes `vec3_origin`. The note goes, with no comment. |
| Do_Strike | NULL `maxs` into `trap_Trace` | filled | Same as the row above. |
| Do_Strike | NULL `dir` into `G_Damage` | filled | `var dir: vec3_t? = nil` and `&dir`, the optional inout of `G_Damage`. |
| hurt_touch | NULL `dir` into `G_Damage`, activator arm | filled | Same form. |
| hurt_touch | NULL `dir` into `G_Damage`, self arm | filled | Same form. |
| shipboundary_touch | `ent = G_Find(NULL, FOFS(targetname), self->target)` | filled | |
| shipboundary_touch | NULL `dir` into `G_Damage` | filled | |
| hyperspace_touch | `ent = G_Find(..., self->target)`, first arm | filled | |
| hyperspace_touch | `ent = G_Find(..., self->target2)` | filled | |
| hyperspace_touch | `ent = G_Find(..., self->target)`, else arm | filled | |
| hyperspace_touch | NULL `dir` into `G_Damage` | filled | |
| asteroid_pick_random_asteroid | first `while ((t = G_Find(...)) != NULL)` | filled | `while let next`, then `t = next`. The test `t != self` compares the entity numbers, the form for two pointers into one table. The line `t = nil` follows the loop, because the second loop reads `t`. |
| asteroid_pick_random_asteroid | `return (G_Find(NULL, ...))` | filled | |
| asteroid_pick_random_asteroid | second `while ((t = G_Find(...)) != NULL)` | filled | Same form. The `continue` reruns the search from `t`, as Raven's test does. Nothing after the loop reads `t`. |

## GameWorld properties

None. No hole in the three files is a static local or a file-scope static.

## Docket rows

1. A byte array read as one `unsigned`, `*(unsigned *)m`, and the reverse store, `*(unsigned *)b = x`. Six holes in g_svcmds: StringToFilter (2), UpdateIPBans, G_FilterPacket, Svcmd_ListIPs_f, and G_SaveBanIP. The guide gives no form for a reinterpret of four bytes. Proposed form: two hand helpers in `JKAShared`, one that packs four bytes in little-endian order into a `UInt32` and one that unpacks a `UInt32` into four bytes of an array. The `byte b[4]` and `byte m[4]` locals also need their narrow storage, `[UInt8]`, under the narrow-local rule, because the draft holds them as `[Int32]`.
2. `Com_sprintf` into an offset of a buffer, `Com_sprintf(iplist + strlen(iplist), sizeof(iplist) - strlen(iplist), ...)` of UpdateIPBans. `Com_sprintf` takes `inout CharBuf` with no offset. Proposed form: an `at:` overload of `Com_sprintf`, as `strcpy` and `Q_strcat` have, so the body reads `Com_sprintf(&iplist, Int32(iplist.count) - strlen(iplist), "...", ..., at: strlen(iplist))`.
3. A `qboolean` as an `int` operand, `isfog += G_SpawnVector(...)` of SP_misc_skyportal, three holes. Swift adds no `Bool` to an `Int32`. Proposed form: a `+=` between `Int32` and `Bool` in `Promotion.swift` that adds 1 or 0, as C does. The same row should check the `inout Float` output that the sig table gives `G_SpawnVector`, because Raven passes a `vec3_t`.
