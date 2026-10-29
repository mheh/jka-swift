# Discarded pool results: rows D1, D2, D3

All three sites drop the pointer that a pool allocation returns. Each Swift site keeps the call, so the pool keeps Raven's count. Each Swift site also holds the text in a Swift value. No site loses a value that a later line reads. The port guide already states this shape in `docs/transcription.md:713-715`, and `tools/oracle-closure/rulings.py:211` lists `BG_TempAlloc` in `CHARBUF_ALLOCS`.

## D1

Swift, `Sources/JKAMP_GameLogic/g_bot.swift:104-107`:

```swift
        //NOTE: extra space for arena number
        _ = G_Alloc(strlen(info) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1)
        infos[infos.startIndex + count] = String(info)
        count += 1
```

Raven, `oracle/codemp/game/g_bot.c:91-96`, in `G_ParseInfos`:

```c
		//NOTE: extra space for arena number
		infos[count] = (char *) G_Alloc(strlen(info) + strlen("\\num\\") + strlen(va("%d", MAX_ARENAS)) + 1);
		if (infos[count]) {
			strcpy(infos[count], info);
			count++;
		}
```

OpenJK, `~/Developer/Milo/OpenJK/codemp/game/g_bot.c:95-97`, has the same lines.

In C, the allocation receives a copy of the info string. The extra bytes leave room for the `\num\<n>` pair that `G_LoadArenas` appends in place at `oracle/codemp/game/g_bot.c:317`. In Swift, the slot is a `String`, so `infos[...] = String(info)` holds the text. `G_LoadArenas` rebuilds a `CharBuf` of the same size sum at `Sources/JKAMP_GameLogic/g_bot.swift:337-340` and stores the result back as a `String`. The `G_Alloc` call keeps the bump of `allocPoint`, the `g_debugAlloc` print, and the overflow `G_Error`, as `docs/porting-rules.md:23` (rule 9) requires. Raven's NULL test drops because `G_Error` is `-> Never` (rule 22, `docs/porting-rules.md:47`). The Swift `G_Alloc` cannot return NULL, so `count += 1` without the test is the same control flow.

jka-rust, `jka-rust/crates/mp/game/src/g_bot.rs:42-89`: `G_ParseInfos` returns a `Vec<String>` and calls `infos.push(info)`. No `G_Alloc` call exists. The file imports `G_Alloc` at `:19` and never calls it. So the Rust drops Raven's pool accounting, and the Swift keeps it.

Rule: `docs/transcription.md:715` states this exact form, a `G_Alloc` into a `String` slot that Raven fills with `strcpy`. Verdict: faithful. The Swift holds the info text in the `String` slot. Proposed form: no change. The line is the form that `docs/transcription.md:715` prescribes.

## D2

Swift, `Sources/JKAMP_GameLogic/NPC_stats.swift:1671-1686`:

```swift
            if Q_stricmp(token, "saber") == 0 {
                var saberName = CharBuf(4096)
                if COM_ParseString(&p, &value) {
                    continue
                }
                _ = BG_TempAlloc(4096) //G_NewString( value );
                strcpy(&saberName, value)
                WP_SaberParseParms(String(saberName), NPC.client!.saber[0])
                npcSaber1 = G_ModelIndex(va("@%s", saberName))
                BG_TempFree(4096)
                continue
            }
```

Raven, `oracle/codemp/game/NPC_stats.c:2342-2359`:

```c
				saberName = (char *)BG_TempAlloc(4096);//G_NewString( value );
				strcpy(saberName, value);

				WP_SaberParseParms( saberName, &NPC->client->saber[0] );
				npcSaber1 = G_ModelIndex(va("@%s", saberName));

				BG_TempFree(4096);
```

OpenJK, `~/Developer/Milo/OpenJK/codemp/game/NPC_stats.c:2672-2678`, has the same lines.

The MP file has no `#ifdef` at this site. The `//G_NewString( value );` comment is the only trace of the SP form, which is `char *saberName = G_NewString( value );` at `oracle/code/game/NPC_stats.cpp:3598`. The `#ifdef` arms are in `oracle/codemp/game/bg_misc.c`. The `_XBOX` arm at `:3251` and `:3272` uses `Z_Malloc` and `Z_Free`. The PC arm at `:3356` and `:3371` moves `bg_poolTail` down and up by the aligned size. The Swift transcribes the PC arm at `Sources/JKAMP_BG/bg_misc.swift:1710` and `:1726`.

In Raven's MP arm, the buffer holds a copy of the parsed saber name. `WP_SaberParseParms` reads it, and `G_ModelIndex(va("@%s", ...))` reads it. In Swift, the `CharBuf(4096)` local holds the same copy, and both calls read that local. The TempFree pair exists at `NPC_stats.swift:1684`.

jka-rust, `jka-rust/crates/mp/game/src/NPC_stats.rs:2038-2059`: the Rust keeps the pointer from `BG_TempAlloc(4096, bg)`, copies the value into it with `Q_strncpyzBytes`, reads it with `cstr_to_str(saber_name)` for both calls, and calls `BG_TempFree(4096, ...)` at `:2059`.

Rule: `docs/transcription.md:713-714`. A `char *` local whose every store is a `CHARBUF_ALLOCS` allocator at one constant size is a `CharBuf` of that size. The call stays with its result dropped, and the free stays. Verdict: faithful. The Swift does not lose the value, because the `CharBuf` local holds it. Proposed form: no change.

## D3

Swift, `Sources/JKAMP_GameLogic/NPC_stats.swift:1694-1709`:

```swift
                if !((NPC.client!.saber[0].saberFlags & SFL_TWO_HANDED) != 0) {
                    //can't use a second saber if first one is a two-handed saber...?
                    var saberName = CharBuf(4096)
                    _ = BG_TempAlloc(4096) //G_NewString( value );
                    strcpy(&saberName, value)
                    WP_SaberParseParms(String(saberName), NPC.client!.saber[1])
                    ...
                        npcSaber2 = G_ModelIndex(va("@%s", saberName))
                    }
                    BG_TempFree(4096)
                }
```

Raven, `oracle/codemp/game/NPC_stats.c:2370-2386`:

```c
				if ( !(NPC->client->saber[0].saberFlags&SFL_TWO_HANDED) )
				{//can't use a second saber if first one is a two-handed saber...?
					char *saberName = (char *)BG_TempAlloc(4096);//G_NewString( value );
					strcpy(saberName, value);

					WP_SaberParseParms( saberName, &NPC->client->saber[1] );
					...
						npcSaber2 = G_ModelIndex(va("@%s", saberName));
					}
					BG_TempFree(4096);
				}
```

OpenJK, `~/Developer/Milo/OpenJK/codemp/game/NPC_stats.c:2690-2705`, has the same lines. The SP form is `oracle/code/game/NPC_stats.cpp:3622`, `char *saberName = G_NewString( value );`.

The buffer holds the second saber name. `WP_SaberParseParms` reads it, and `G_ModelIndex` reads it on the one-handed path. The Swift `CharBuf(4096)` local holds it, and the TempFree pair exists at `NPC_stats.swift:1708`. The free runs on both paths, as in Raven.

jka-rust, `jka-rust/crates/mp/game/src/NPC_stats.rs:2078-2108`: the same shape as D2, with the free at `:2108`. Rule: `docs/transcription.md:713-714`, as for D2.

Verdict: faithful. The Swift does not lose the value. Proposed form: no change.

## The ledger

The user walked the three rows on 2026-10-29 and ratified each as proposed: D1 no change, D2 no change, D3 no change. No Sources line moves. The three sites are the form that `docs/transcription.md:713-715` prescribes, and the pool calls go with their pools when the pool rows land.
