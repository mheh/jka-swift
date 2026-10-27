# Phase 3, group 1: the helpers

This record holds group 1 of phase 3 of the rulings build, the helper items of `notes/2026-10-11/phase-2-walk.md`, section "Helpers in JKAShared, JKAMP_BG, JKAMP, and JKAMP_Game". The tree is `wave-0` on 7828c23 with the changes below, uncommitted. A line number is the line in the changed tree.

## V36. `crandom()` returns `Double`

`Sources/JKAMP_BG/bg_lib.swift:192-195` reads `public func crandom() -> Double { 2.0 * (Double(random()) - 0.5) }` under `/// Source: oracle/codemp/game/q_shared.h:1592`. The old comment line about the narrow on return is gone, because the function no longer narrows.

The change breaks every `Float`-typed site, so the V36 sites of the hand-site group (group 4) are in this group, because the gate must pass. Each site takes the double-math widening of the V36 row: each operand is `Double` where it meets the `Double`, and one `Float(...)` or `Int32(...)` is at the store. A compound assignment is a plain store with the left side widened, by ruling W18.

The compile gate gave 22 sites:

- `Sources/JKAMP_GameLogic/NPC_AI_GalakMech.swift:879`: `target[0] += flrand(-5, 5) + (crandom() * (6 - NPCInfo!.currentAim) * 2)` reads `target[0] = Float(Double(target[0]) + (Double(flrand(-5, 5)) + (crandom() * Double(6 - NPCInfo!.currentAim) * 2)))`.
- `Sources/JKAMP_GameLogic/NPC_AI_GalakMech.swift:880`: `target[1] += flrand(-5, 5) + (crandom() * (6 - NPCInfo!.currentAim) * 2)` reads `target[1] = Float(Double(target[1]) + (Double(flrand(-5, 5)) + (crandom() * Double(6 - NPCInfo!.currentAim) * 2)))`.
- `Sources/JKAMP_GameLogic/NPC_AI_GalakMech.swift:881`: `target[2] += flrand(-5, 5) + (crandom() * (6 - NPCInfo!.currentAim) * 2)` reads `target[2] = Float(Double(target[2]) + (Double(flrand(-5, 5)) + (crandom() * Double(6 - NPCInfo!.currentAim) * 2)))`.
- `Sources/JKAMP_GameLogic/NPC_AI_Seeker.swift:206-208`: `_VectorMA(end, crandom() * 25, dir, &end)` reads one store per component by ruling W16, `end[0] = Float(Double(end[0]) + Double(dir[0]) * (crandom() * 25))` and the same line for components 1 and 2.
- `Sources/JKAMP_GameLogic/g_items.swift:2458`: `respawn = Int32(respawn + crandom() * ent.random)` reads `respawn = Int32(Double(respawn) + crandom() * Double(ent.random))`.
- `Sources/JKAMP_GameLogic/g_items.swift:2604`: `velocity[2] += 200 + crandom() * 50` reads `velocity[2] = Float(Double(velocity[2]) + (200 + crandom() * 50))`.
- `Sources/JKAMP_GameLogic/g_misc.swift:1050`: `deg = crandom() * ent.random` reads `deg = Float(crandom() * Double(ent.random))`.
- `Sources/JKAMP_GameLogic/g_misc.swift:1053`: `deg = crandom() * ent.random` reads `deg = Float(crandom() * Double(ent.random))`.
- `Sources/JKAMP_GameLogic/g_target.swift:117`: `ent.nextthink = Int32(level.time + (ent.wait + ent.random * crandom()) * 1000)` reads `ent.nextthink = Int32(Double(level.time) + (Double(ent.wait) + Double(ent.random) * crandom()) * 1000)`.
- `Sources/JKAMP_GameLogic/g_trigger.swift:85`: `ent.nextthink = Int32(level.time + (ent.wait + ent.random * crandom()) * 1000)` reads `ent.nextthink = Int32(Double(level.time) + (Double(ent.wait) + Double(ent.random) * crandom()) * 1000)`.
- `Sources/JKAMP_GameLogic/g_trigger.swift:492`: `` `self`.nextthink = Int32(level.time + (`self`.wait + `self`.random * crandom()) * 1000) `` reads `` `self`.nextthink = Int32(Double(level.time) + (Double(`self`.wait) + Double(`self`.random) * crandom()) * 1000) ``.
- `Sources/JKAMP_GameLogic/g_trigger.swift:1637`: `` `self`.nextthink = Int32(level.time + 1000 * (`self`.wait + crandom() * `self`.random)) `` reads `` `self`.nextthink = Int32(Double(level.time) + 1000 * (Double(`self`.wait) + crandom() * Double(`self`.random))) ``.
- `Sources/JKAMP_GameLogic/g_weapon.swift:621`: `angs[PITCH] += crandom() * BLASTER_SPREAD` reads `angs[PITCH] = Float(Double(angs[PITCH]) + crandom() * Double(BLASTER_SPREAD))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:622`: `angs[YAW] += crandom() * BLASTER_SPREAD` reads `angs[YAW] = Float(Double(angs[YAW]) + crandom() * Double(BLASTER_SPREAD))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1101`: `vel = BOWCASTER_VELOCITY * (crandom() * BOWCASTER_VEL_RANGE + 1.0)` reads `vel = Float(Double(BOWCASTER_VELOCITY) * (crandom() * Double(BOWCASTER_VEL_RANGE) + 1.0))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1106`: `angs[PITCH] += crandom() * BOWCASTER_ALT_SPREAD * 0.2` reads `angs[PITCH] = Float(Double(angs[PITCH]) + crandom() * Double(BOWCASTER_ALT_SPREAD) * Double(0.2 as Float))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1205`: `angs[PITCH] += crandom() * REPEATER_SPREAD` reads `angs[PITCH] = Float(Double(angs[PITCH]) + crandom() * Double(REPEATER_SPREAD))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1206`: `angs[YAW] += crandom() * REPEATER_SPREAD` reads `angs[YAW] = Float(Double(angs[YAW]) + crandom() * Double(REPEATER_SPREAD))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1493`: `angs[PITCH] += crandom() * FLECHETTE_SPREAD` reads `angs[PITCH] = Float(Double(angs[PITCH]) + crandom() * Double(FLECHETTE_SPREAD))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1494`: `angs[YAW] += crandom() * FLECHETTE_SPREAD` reads `angs[YAW] = Float(Double(angs[YAW]) + crandom() * Double(FLECHETTE_SPREAD))`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1671`: `dir[YAW] += crandom() * 2` reads `dir[YAW] = Float(Double(dir[YAW]) + crandom() * 2)`.
- `Sources/JKAMP_GameLogic/g_weapon.swift:1814`: `newdir[i] += crandom() * ent.random * 0.25` reads `newdir[i] = Float(Double(newdir[i]) + crandom() * Double(ent.random) * 0.25)`.

Five live sites compile unchanged and keep their text, because each literal takes the `Double` type: `NPC_AI_Rancor.swift:103`, `NPC_AI_Wampa.swift:122`, `NPC_AI_MineMonster.swift:78`, and `NPC_AI_Howler.swift:66`, each `Int32(crandom() * 5000 + 5000)`, and `NPC_AI_Droid.swift:507`, `Int32(crandom() * 64)`. With the text at `g_items.swift:2783` inside Raven's block comment, the 27 live sites of the V36 proof are 22 changed and 5 unchanged.

The Seeker site is a W16 site too, and it takes the W16 form here, because the `_VectorMA` call does not compile with a `Double` scale. The other five W16 sites hold `flrand` and stay for group 4.

`g_weapon.swift:1106` holds Raven's `0.2f` in a double expression. C widens the float literal, so the operand is `Double(0.2 as Float)`, the value C reads, and not the double `0.2`. No guide line names this form. The literals `1.0f` at `:1101` and `0.25f` at `:1814` are exact in both types, so they read `1.0` and `0.25`.

## W17. `atof` returns `Double`

`Sources/JKAShared/CString.swift:73` gives `atofCore` the return type `Double`, and its last line is `return Double(text) ?? 0`. `atof(_ s: CharBuf)` at `:121` and `atof(_ s: String)` at `:126` return `Double`. The doc line of `atofCore` at `:72` and the file doc at `:1-4` state the `Double` return.

The VM port of `atof` at `Sources/JKAMP_BG/bg_lib.swift:197-199` drops in the form of the `memmove` entry above it: the `/// Source: oracle/codemp/game/bg_lib.c:774` line, `// Raven wrote: double atof( const char *string )`, and a `// Not ported:` line that names the float math of the VM and the C library `atof` of `JKAShared`. No "VM mark" form exists in the tree, so the drop is the form the ruling allows. `_atof` at `:202` stays.

The change breaks every `Float`-typed site, so the W17 sites of group 4 are in this group. A plain store narrows once, `x = Float(atof(s))`, and the add of `Q3_SetParm` takes the form of the W17 row. The compile gate gave 50 sites:

- `Sources/JKAMP_BG/bg_misc.swift:178`: `b[float: f.ofs] = atof(value)` reads `b[float: f.ofs] = Float(atof(value))`.
- `Sources/JKAMP_BG/bg_misc.swift:180`: `v = atof(value)` reads `v = Float(atof(value))`.
- `Sources/JKAMP_BG/bg_panimate.swift:1135`: `fps = atof(token)` reads `fps = Float(atof(token))`.
- `Sources/JKAMP_BG/bg_saga.swift:763`: `bgSiegeClasses[bgNumSiegeClasses].speed = atof(parseBuf)` reads `bgSiegeClasses[bgNumSiegeClasses].speed = Float(atof(parseBuf))`.
- `Sources/JKAMP_BG/bg_vehicleLoad.swift:85`: `b[float: vehWeaponFields[i].ofs] = atof(value)` reads `b[float: vehWeaponFields[i].ofs] = Float(atof(value))`.
- `Sources/JKAMP_BG/bg_vehicleLoad.swift:443`: `b[float: vehicleFields[i].ofs] = atof(value)` reads `b[float: vehicleFields[i].ofs] = Float(atof(value))`.
- `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:179`: `tFVal = atof(buf)` reads `tFVal = Float(atof(buf))`.
- `Sources/JKAMP_GameLogic/NPC_utils.swift:234`: `tFVal = atof(buf)` reads `tFVal = Float(atof(buf))`.
- `Sources/JKAMP_GameLogic/ai_util.swift:500`: `bs.skills.accuracy = atof(readbuf)` reads `bs.skills.accuracy = Float(atof(readbuf))`.
- `Sources/JKAMP_GameLogic/ai_util.swift:506`: `bs.skills.turnspeed = atof(readbuf)` reads `bs.skills.turnspeed = Float(atof(readbuf))`.
- `Sources/JKAMP_GameLogic/ai_util.swift:512`: `bs.skills.turnspeed_combat = atof(readbuf)` reads `bs.skills.turnspeed_combat = Float(atof(readbuf))`.
- `Sources/JKAMP_GameLogic/ai_util.swift:518`: `bs.skills.maxturn = atof(readbuf)` reads `bs.skills.maxturn = Float(atof(readbuf))`.
- `Sources/JKAMP_GameLogic/ai_wpnav.swift:1899`: `thiswp.weight = atof(currentVar)` reads `thiswp.weight = Float(atof(currentVar))`.
- `Sources/JKAMP_GameLogic/ai_wpnav.swift:1912`: `thiswp.origin[0] = atof(currentVar)` reads `thiswp.origin[0] = Float(atof(currentVar))`.
- `Sources/JKAMP_GameLogic/ai_wpnav.swift:1924`: `thiswp.origin[1] = atof(currentVar)` reads `thiswp.origin[1] = Float(atof(currentVar))`.
- `Sources/JKAMP_GameLogic/ai_wpnav.swift:1936`: `thiswp.origin[2] = atof(currentVar)` reads `thiswp.origin[2] = Float(atof(currentVar))`.
- `Sources/JKAMP_GameLogic/ai_wpnav.swift:1983`: `thiswp.disttonext = atof(currentVar)` reads `thiswp.disttonext = Float(atof(currentVar))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:243`: `tFVal = atof(buf)` reads `tFVal = Float(atof(buf))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:914`: `value = atof(ent!.parms!.parm[toGet - SET_PARM1])` reads `value = Float(atof(ent!.parms!.parm[toGet - SET_PARM1]))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:2938`: `val = atof(numString.text)` reads `val = Float(atof(numString.text))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:2945`: `val = atof(numString.text) * -1` reads `val = Float(atof(numString.text) * -1)`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:3194`: `val += atof(ent!.parms!.parm[parmNum])` reads `val = Float(Double(val) + atof(ent!.parms!.parm[parmNum]))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4645`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4649`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4653`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4657`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4765`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4771`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4816`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4832`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4836`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4840`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4844`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4907`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4914`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4918`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:4922`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:5207`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_ICARUScb.swift:5230`: `float_data = atof(data)` reads `float_data = Float(atof(data))`.
- `Sources/JKAMP_GameLogic/g_bot.swift:51`: `return atof(buf)` reads `return Float(atof(buf))`.
- `Sources/JKAMP_GameLogic/g_bot.swift:849`: `settings.skill = atof(Info_ValueForKey(String(userinfo), "skill"))` reads `settings.skill = Float(atof(Info_ValueForKey(String(userinfo), "skill")))`.
- `Sources/JKAMP_GameLogic/g_bot.swift:1116`: `skill = atof(string)` reads `skill = Float(atof(string))`.
- `Sources/JKAMP_GameLogic/g_cmds.swift:2373`: `origin[i] = atof(buffer)` reads `origin[i] = Float(atof(buffer))`.
- `Sources/JKAMP_GameLogic/g_cmds.swift:2378`: `angles[YAW] = atof(buffer)` reads `angles[YAW] = Float(atof(buffer))`.
- `Sources/JKAMP_GameLogic/g_main.swift:3432`: `tFVal = atof(buf)` reads `tFVal = Float(atof(buf))`.
- `Sources/JKAMP_GameLogic/g_main.swift:3459`: `tFVal = atof(buf)` reads `tFVal = Float(atof(buf))`.
- `Sources/JKAMP_GameLogic/g_misc.swift:714`: `fov_x = atof(fov)` reads `fov_x = Float(atof(fov))`.
- `Sources/JKAMP_GameLogic/g_spawn.swift:66`: `out = atof(s)` reads `out = Float(atof(s))`.
- `Sources/JKAShared/q_shared.c.swift:494`: `f = atof(token)` reads `f = Float(atof(token))`.
- `Sources/JKAShared/q_shared.c.swift:603`: `m[i] = atof(token)` reads `m[i] = Float(atof(token))`.

Three sites compile unchanged and already read the forms of the W17 row: `bg_vehicleLoad.swift:104` and `:462`, `(Bool((atof(value) != 0)) ? 1 : 0)`, and `g_misc.swift:585`, `va("%f", atof(value))`. The tree holds 53 live `atof` calls outside `CString.swift`, 50 changed and 3 unchanged. The text at `g_ICARUScb.swift:4006` is inside a block comment.

## W19. The text codec lives in `CharBuf` alone

The amended ruling of 2026-10-27 puts the codec between `String` and engine bytes in `CharBuf` and nowhere else. `CharBuf(_ string: String)` and `String(_ buf: CharBuf)` are the only two bodies in the repo where a byte meets a Unicode scalar. `g_spawn.swift:231` reads `cString(at: newb)` since group 4, and the two `jampsmoke` sites keep `String(cString:)` by ruling R1a, because that loader links no game code. The decode gives one scalar for each byte, U+0000 to U+00FF, and the encode gives one byte for each scalar with `UInt8(truncatingIfNeeded:)`. Every other helper works on bytes, as its C original does. The reason is one layer: each helper body reads like its C, and the codec has one home. The word Latin-1 appears once, in the doc comment of `CharBuf(_ string:)`, and each of the two bodies carries a one-line comment that gives the byte-to-scalar rule.

- `Sources/JKAShared/CharBuf.swift:17` and `:97`: the two codec bodies. The doc line of `CharBuf(_ string:)` names the Latin-1 codec, and the doc line of `String(_ buf:)` calls it the decode half.
- `Sources/JKAShared/CString.swift:65` and `:126`: `atoi(String)` and `atof(String)` read `atoi(CharBuf(s))` and `atof(CharBuf(s))`.
- `Sources/JKAShared/CString.swift:144`: `strlen(String)` reads `strlen(CharBuf(s))`, so it counts the bytes up to the first NUL.
- `Sources/JKAShared/CString.swift:171` and `:205`: the `strcpy` forms into a `CharBuf` and into raw memory call their `CharBuf` source overloads with `CharBuf(source)`.
- `Sources/JKAShared/CString.swift:177`: the `at:` form of `strcpy` takes `CharBuf(source)` and copies its bytes up to and including the NUL.
- `Sources/JKAShared/CString.swift:263` and `:268`: the two `String` `strcat` forms call the `CharBuf` `strcat` forms with `CharBuf(source)`.
- `Sources/JKAShared/CString.swift:312`: `strncpy(_:_:_:)` over a `String` calls the `CharBuf` overload with `CharBuf(source)`.
- `Sources/JKAShared/CString.swift:318`: the `at:` form of `strncpy` takes `CharBuf(source)`, and the copy count is `min(n, strlen(source))`.
- `Sources/JKAShared/CString.swift:482`: `withCString(_:_:)` hands the body the bytes of `CharBuf(string)`, so a trap that calls it passes engine bytes. The file doc line says a `String` argument reaches its bytes through `CharBuf(_ string:)`.
- `Sources/JKAShared/Scan.swift:166`, `:182`, and `:198`: the three `String` `sscanf` overloads pass `scanBytes(of: CharBuf(s))`. The `%s` arm at `:242` decodes the token through `String(CharBuf(bytes:))`.
- `Sources/JKAShared/Views/CStrings.swift:2`: `cString(at:)` takes an `UnsafeRawPointer`, counts the bytes to the NUL, and decodes through `String(CharBuf(bytes:))`. Every typed `char` pointer converts to its parameter.
- `Sources/JKAShared/Views/CStrings.swift:13`: `store(_:at:capacity:)` encodes through `CharBuf(string)`, takes the length from `strlen` of that buffer, and copies through `withUnsafeRawPointer`.
- `Sources/JKAShared/Views/String+NulTerminated.swift`: `String(nulTerminated:)` reads `self.init(CharBuf(bytes: buffer))`.
- `Sources/JKAShared/Views/StringPool.swift:25-26`: `intern(_:)` allocates `strlen(string) + 1` bytes and fills them with `strcpy`.
- `Sources/JKAShared/Views/PooledString.swift:9`, `Views/Slots.swift:117`, and `Views/RawField.swift:55`: the `char *` reads call `cString(at:)`.
- `Sources/JKAShared/Views/PooledString.swift:25`: `literal.utf8Start` stays. It is the pointer of a `StaticString` literal in the binary, a pointer identity and not a codec.
- `tools/oracle-closure/views.py:231`: the `char *` getter template emits `{pointee}.map { cString(at: $0) }`. The regenerated views differ from the old views at those 58 getter lines alone, in 15 files of `JKAMP`, `JKAMP_Game`, and `JKAShared`, `Generated/Views/StringIDTable.swift:65` among them.

`Q_stricmp` stays byte-based, because its `String` forms convert through `CharBuf(String)`. The digit text that `atofCore`, `readScanFloat`, and `Format.swift` build for a `Double` parse or a printed number holds ASCII digits only, and it is not engine text.

## V1. The `at:` overload of `RemoveColorEscapeSequences`

The overload at `Sources/JKAMP_GameLogic/ai_main.swift:771-779` is removed. The O5 site in `BotAI` at `:812-813` reads `var argsText = buf[args!...]` and `RemoveColorEscapeSequences(&argsText)`.

## V2. The `at:` overload of `Com_sprintf`

The overload and its two comment lines at `Sources/JKAShared/q_shared.c.swift:972-983` are removed. The `UpdateIPBans` site at `Sources/JKAMP_GameLogic/g_svcmds.swift:97-99` reads `var ip = CharBuf(Int32(iplist.count) - strlen(iplist))`, `Com_sprintf(&ip, Int32(iplist.count) - strlen(iplist), "%i.%i.%i.%i ", Int32(b[0]), Int32(b[1]), Int32(b[2]), Int32(b[3]))`, and `strcat(&iplist, ip)`.

## V6. `Bool.init(_ value: Int32)`

The file `Sources/JKAShared/Bool+Int32.swift` is deleted. The four sites read `x != 0`:

- `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:316`: ``return (`self`.client!.ps.eFlags2 & EF2_FLYING) != 0``.
- `Sources/JKAMP_GameLogic/NPC_AI_Jedi.swift:3163`: the second argument of `WP_SpeedOfMissileForWeapon` is `(NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0`.
- `Sources/JKAMP_GameLogic/g_session.swift:134`: `client.sess.setForce = ints[7] != 0`.
- `Sources/JKAMP_GameLogic/g_session.swift:171`: `client.sess.teamLeader = teamLeader != 0`.

## V9. `CharBuf.zero(count:)` and `memset`

`CharBuf.zero(count:)` at `Sources/JKAShared/CharBuf.swift:75-83` is removed. `CharBuf.zero()` stays. `Sources/JKAShared/CString.swift:338-349` adds the `memset` section: `public func memset(_ buf: inout CharBuf, _ value: Int32, _ count: Int32)`, which sets the first `count` bytes to `value` truncated to one byte, and traps with `memset: count past the end of the buffer` for a `count` below 0 or past `buf.count`. The file doc at `:1` names `memset`. The B5 site at `Sources/JKAMP_GameLogic/g_utils.swift:109` reads `memset(&buff, 0, MAX_STRING_CHARS)`. The Darwin `memset` takes an `Int` count, so the `Int32` count of the call binds to the `JKAShared` function alone.

## W11. `ColorIndex` takes `Int32`

`Sources/JKAShared/q_shared.h.swift:38-41` reads `public func ColorIndex(_ c: Int32) -> Int32 { (c - Int32(UInt8(ascii: "0"))) & 7 }`. The test `Tests/JKASharedTests/HeaderMacroTests.swift:47-48` passed a `CChar`, so it passes `Int32(ascii: "3")` and `Int32(ascii: ";")`. The hole at `g_client.swift:1404-1409` stays for group 4.

## W4. `PmoveThunks`

The new hand file `Sources/JKAMP_Game/PmoveThunks.swift` holds `public enum PmoveThunks` as the W4 proof writes it: `static let trap_Trace: PmoveTrace`, which passes the words to `Syscall.call(G_TRACE, results, start, mins, maxs, end, passEntityNum, contentmask, 0, 10)`, and `static let trap_PointContents: PmovePointcontents`, which returns `Int32(truncatingIfNeeded: Syscall.call(G_POINT_CONTENTS, point, passEntityNum))`. Each member carries the `Source:` line of its trap in `g_syscalls.c`. The four `pm` stores of `g_active.swift` stay for group 4.

## V10. Two duplicate `Source:` lines

The `Q_stricmp(String?, String?)` overload at `Sources/JKAShared/q_shared.c.swift:817-821` has no `Source:` line, and its doc line reads "Raven's `Q_stricmp` returns -1 for a NULL argument at `q_shared.c:901` and compares nothing." The D7 forward of `G_RadiusList` at `Sources/JKAMP_GameLogic/g_utils.swift:370-372` has no `Source:` line, so the key of Raven line 252 stays on the base at `:305`.

## W28. `@discardableResult` on `G_Spawn*`

`Sources/JKAMP_GameLogic/g_spawn.swift` adds `@discardableResult` between the `Source:` line and the `func` line of `G_SpawnString` at `:38`, `G_SpawnFloat` at `:61`, `G_SpawnInt` at `:72`, and `G_SpawnVector` at `:83`.

## Blocked items

No item is blocked. No changed file has a "generated" header.

## Open points for the review leg

1. The trap template of group 2 still encodes with `String.withCString` at 98 sites of `Sources/JKAMP_Game/Generated/g_syscalls.swift`, and the drafter line `tools/oracle-closure/draft_statements.py:488` still emits `String(cString:)`. `withCString(_:_:)` of `JKAShared` is the encode through `CharBuf` that the trap template can call.
2. The `atof` entry of `NOT_PORTED` in `tools/oracle-closure/rulings.py` landed in group 2. The `memset` half is void, because `UNDEFINED` in `overlay.py` names the C fortify macros for the parse and does not name Swift functions.
3. The form `Double(0.2 as Float)` at `g_weapon.swift:1106` has no guide line.
4. The `@discardableResult` line of W28 sits between the `Source:` line and the `func` line, so a draft splice of `g_spawn.swift` must keep it.

## Gate

The gate ran in one call: `swift build`, `swift test --no-parallel`, and `tools/load-test.sh`.

- `swift build`: 0 errors, "Build complete!".
- `swift test --no-parallel`: 112 tests in four binaries, 84, 14, 13, and 1, all passed.
- `tools/load-test.sh`: exit 0. The server loaded `mp/ffa1`, ran `InitGame`, and shut down with `ShutdownGame`.

The gate of the W19 amendment gives the same counts: 0 errors, 112 tests (84, 14, 13, and 1) all passed, and `tools/load-test.sh` exit 0.

Draftcheck and the snapshot did not run, because they are the gate of group 2.
