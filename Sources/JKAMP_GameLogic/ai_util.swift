import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/ai_util.c:12
var gBotChatBuffer: [JKAShared.CharBuf] {
    get { world.variables.gBotChatBuffer }
    set { world.variables.gBotChatBuffer = newValue }
}

/// Source: oracle/codemp/game/ai_util.c:14
func B_TempAlloc(_ size: Int32) -> UnsafeMutableRawPointer {
    return BG_TempAlloc(size)
}

/// Source: oracle/codemp/game/ai_util.c:19
func B_TempFree(_ size: Int32) {
    BG_TempFree(size)
}

/// Source: oracle/codemp/game/ai_util.c:25
func B_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    //If this happens we'll have to rely on this chunk being freed manually with B_Free, which it hopefully will be


    return BG_Alloc(size)
}

/// Source: oracle/codemp/game/ai_util.c:82
func B_Free(_ ptr: OpaquePointer?) {
    //Likely because the limit was exceeded and we're now freeing the chunk manually as we hoped would happen
}

/// Source: oracle/codemp/game/ai_util.c:133
func B_InitAlloc() {
    gWPArray.zero()
}

/// Source: oracle/codemp/game/ai_util.c:142
func B_CleanupAlloc() {
}

/// Source: oracle/codemp/game/ai_util.c:160
func GetValueGroup(_ buf: inout JKAShared.CharBuf, _ group: String, _ outbuf: inout JKAShared.CharBuf) -> Int32 {
    // Port-note: A pointer local `char * place` with no view.
    // Raven wrote: char *place;
    portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")
    // Port-note: A pointer local `char * placesecond` with no view.
    // Raven wrote: placesecond;
    portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")
    let iplace: Int32
    var failure: Int32
    var i: Int32
    var startpoint: Int32
    var startletter: Int32
    var subg: Int32 = 0

    i = 0

    iplace = 0

    // Port-note: A store into `place`, a local the draft left as a hole.
    // Raven wrote: place = strstr(buf, group)
    portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")

    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: if (!place) { return 0; }
    portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")

    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: startpoint = place - buf + strlen(group) + 1
    portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")
    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: startletter = (place - buf) - 1
    portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")

    failure = 0

    while buf[startpoint + 1] != Int32(ascii: "{") || buf[startletter] != Int32(ascii: "\n") {
        // Port-note: A store into `placesecond`, a local the draft left as a hole.
        // Raven wrote: placesecond = strstr(place+1, group)
        portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")

        // Port-note: A read of `placesecond`, a local the draft left as a hole.
        // Raven wrote: if (placesecond) { startpoint += (placesecond - place); startletter += (placesecond - place); place = placesecond; } else { failure = 1; break; }
        portMissing("GetValueGroup", source: "oracle/codemp/game/ai_util.c:160")
    }

    if failure != 0 {
        return 0
    }

    //we have found the proper group name if we made it here, so find the opening brace and read into the outbuf
    //until hitting the end brace

    while buf[startpoint] != Int32(ascii: "{") {
        startpoint += 1
    }

    startpoint += 1

    while buf[startpoint] != Int32(ascii: "}") || subg != 0 {
        if buf[startpoint] == Int32(ascii: "{") {
            subg += 1
        } else if buf[startpoint] == Int32(ascii: "}") {
            subg -= 1
        }
        outbuf[i] = buf[startpoint]
        i += 1
        startpoint += 1
    }
    outbuf[i] = 0

    return 1
}

/// Source: oracle/codemp/game/ai_util.c:236
func GetPairedValue(_ buf: inout JKAShared.CharBuf, _ key: String, _ outbuf: inout JKAShared.CharBuf) -> Int32 {
    // Port-note: A pointer local `char * place` with no view.
    // Raven wrote: char *place;
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")
    // Port-note: A pointer local `char * placesecond` with no view.
    // Raven wrote: placesecond;
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")
    var startpoint: Int32
    var startletter: Int32
    var i: Int32
    var found: Int32


    i = 0

    // Raven tests `buf[i]` and `buf[i] != '\0'`.
    // Both read as the same Swift test, so the draft writes it once.
    while buf[i] != 0 {
        if buf[i] == Int32(ascii: "/") {
            // Raven tests `buf[i+1]` and `buf[i+1] != '\0'`.
            // Both read as the same Swift test, so the draft writes it once.
            if buf[i + 1] != 0 && buf[i + 1] == Int32(ascii: "/") {
                while buf[i] != Int32(ascii: "\n") {
                    buf[i] = Int32(ascii: "/")
                    i += 1
                }
            }
        }
        i += 1
    }

    // Port-note: A store into `place`, a local the draft left as a hole.
    // Raven wrote: place = strstr(buf, key)
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")

    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: if (!place) { return 0; }
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")
    //tab == 9
    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: startpoint = place - buf + strlen(key)
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")
    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: startletter = (place - buf) - 1
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")

    found = 0

    while found == 0 {
        // Raven tests `!buf[startletter]` and `buf[startletter] == '\0'`.
        // Both read as the same Swift test, so the draft writes it once.
        if startletter == 0 || buf[startletter] == 0 || buf[startletter] == 9 || buf[startletter] == Int32(ascii: " ") || buf[startletter] == Int32(ascii: "\n") {
            if buf[startpoint] == 0 || buf[startpoint] == 9 || buf[startpoint] == Int32(ascii: " ") || buf[startpoint] == Int32(ascii: "\n") {
                found = 1
                break
            }
        }

        // Port-note: A store into `placesecond`, a local the draft left as a hole.
        // Raven wrote: placesecond = strstr(place+1, key)
        portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")

        // Port-note: A read of `placesecond`, a local the draft left as a hole.
        // Raven wrote: if (placesecond) { startpoint += placesecond - place; startletter += placesecond - place; place = placesecond; } else { place = NULL; break; }
        portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")
    }

    // Port-note: A read of `place`, a local the draft left as a hole.
    // Raven wrote: if (!found || !place || !buf[startpoint] || buf[startpoint] == '\0') { return 0; }
    portMissing("GetPairedValue", source: "oracle/codemp/game/ai_util.c:236")

    while buf[startpoint] == Int32(ascii: " ") || buf[startpoint] == 9 || buf[startpoint] == Int32(ascii: "\n") {
        startpoint += 1
    }

    i = 0

    // Raven tests `buf[startpoint]` and `buf[startpoint] != '\0'`.
    // Both read as the same Swift test, so the draft writes it once.
    while buf[startpoint] != 0 && buf[startpoint] != Int32(ascii: "\n") {
        outbuf[i] = buf[startpoint]
        i += 1
        startpoint += 1
    }

    outbuf[i] = 0

    return 1
}

/// Source: oracle/codemp/game/ai_util.c:328
func BotDoChat(_ bs: BotState, _ section: String, _ always: Int32) -> Int32 {
    var chatgroup = CharBuf(MAX_CHAT_BUFFER_SIZE)
    let rVal: Int32
    var inc_1: Int32
    var inc_2: Int32
    var inc_n: Int32
    var lines: Int32
    var checkedline: Int32
    var getthisline: Int32
    var cobject: Entity?

    if bs.canChat == 0 {
        return 0
    }

    if bs.doChat != 0 {
        //already have a chat scheduled
        return 0
    }

    if trap_Cvar_VariableIntegerValue("se_language") != 0 {
        //no chatting unless English.
        return 0
    }

    if Q_irand(1, 10) > bs.chatFrequency && always == 0 {
        return 0
    }

    bs.chatTeam = 0

    _ = B_TempAlloc(MAX_CHAT_BUFFER_SIZE)

    rVal = GetValueGroup(&gBotChatBuffer[bs.client], section, &chatgroup)

    if rVal == 0 {
        B_TempFree(MAX_CHAT_BUFFER_SIZE) //chatgroup
        return 0
    }

    inc_1 = 0
    inc_2 = 2

    // Raven tests `chatgroup[inc_2]` and `chatgroup[inc_2] != '\0'`.
    // Both read as the same Swift test, so the draft writes it once.
    while chatgroup[inc_2] != 0 {
        if chatgroup[inc_2] != 13 && chatgroup[inc_2] != 9 {
            chatgroup[inc_1] = chatgroup[inc_2]
            inc_1 += 1
        }
        inc_2 += 1
    }
    chatgroup[inc_1] = 0

    inc_1 = 0

    lines = 0

    // Raven tests `chatgroup[inc_1]` and `chatgroup[inc_1] != '\0'`.
    // Both read as the same Swift test, so the draft writes it once.
    while chatgroup[inc_1] != 0 {
        if chatgroup[inc_1] == Int32(ascii: "\n") {
            lines += 1
        }
        inc_1 += 1
    }

    if lines == 0 {
        B_TempFree(MAX_CHAT_BUFFER_SIZE) //chatgroup
        return 0
    }

    getthisline = Q_irand(0, (lines + 1))

    if getthisline < 1 {
        getthisline = 1
    }
    if getthisline > lines {
        getthisline = lines
    }

    checkedline = 1

    inc_1 = 0

    while checkedline != getthisline {
        // Raven tests `chatgroup[inc_1]` and `chatgroup[inc_1] != '\0'`.
        // Both read as the same Swift test, so the draft writes it once.
        if chatgroup[inc_1] != 0 {
            if chatgroup[inc_1] == Int32(ascii: "\n") {
                inc_1 += 1
                checkedline += 1
            }
        }

        if checkedline == getthisline {
            break
        }

        inc_1 += 1
    }

    //we're at the starting position of the desired line here
    inc_2 = 0

    while chatgroup[inc_1] != Int32(ascii: "\n") {
        chatgroup[inc_2] = chatgroup[inc_1]
        inc_2 += 1
        inc_1 += 1
    }
    chatgroup[inc_2] = 0

    //trap_EA_Say(bs->client, chatgroup);
    inc_1 = 0
    inc_2 = 0

    if strlen(chatgroup) > MAX_CHAT_LINE_SIZE {
        B_TempFree(MAX_CHAT_BUFFER_SIZE) //chatgroup
        return 0
    }

    while chatgroup[inc_1] != 0 {
        if chatgroup[inc_1] == Int32(ascii: "%") && chatgroup[inc_1 + 1] != Int32(ascii: "%") {
            inc_1 += 1

            if chatgroup[inc_1] == Int32(ascii: "s") && bs.chatObject != nil {
                cobject = bs.chatObject
            } else if chatgroup[inc_1] == Int32(ascii: "a") && bs.chatAltObject != nil {
                cobject = bs.chatAltObject
            } else {
                cobject = nil
            }

            if cobject != nil && cobject!.client != nil {
                inc_n = 0

                // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
                // Raven wrote: while (cobject->client->pers.netname[inc_n]) { bs->currentChat[inc_2] = cobject->client->pers.netname[inc_n]; inc_2++; inc_n++; }
                portMissing("BotDoChat", source: "oracle/codemp/game/ai_util.c:328")
                inc_2 -= 1 //to make up for the auto-increment below
            }
        } else {
            // Port-note: Raven writes `bs->currentChat[inc_2] = chatgroup[inc_1]` into a character buffer the view holds as a String.
            // Raven wrote: bs->currentChat[inc_2] = chatgroup[inc_1]
            portMissing("BotDoChat", source: "oracle/codemp/game/ai_util.c:328")
        }
        inc_2 += 1
        inc_1 += 1
    }
    // Port-note: Raven writes `bs->currentChat[inc_2] = '\0'` into a character buffer the view holds as a String.
    // Raven wrote: bs->currentChat[inc_2] = '\0'
    portMissing("BotDoChat", source: "oracle/codemp/game/ai_util.c:328")

    if strcmp(section, "GeneralGreetings") == 0 {
        bs.doChat = 2
    } else {
        bs.doChat = 1
    }
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UInt' to expected argument type 'Int'".
    // Raven wrote: bs->chatTime_stored = (strlen(bs->currentChat)*45)+Q_irand(1300, 1500)
    portMissing("BotDoChat", source: "oracle/codemp/game/ai_util.c:328")
    bs.chatTime = level.time + bs.chatTime_stored

    B_TempFree(MAX_CHAT_BUFFER_SIZE) //chatgroup

    return 1
}

/// Source: oracle/codemp/game/ai_util.c:517
func ParseEmotionalAttachments(_ bs: BotState, _ buf: String) {
    let buf = CharBuf(buf)
    var i: Int32 = 0
    var i_c: Int32 = 0
    var tbuf = CharBuf(16)

    while buf[i] != 0 && buf[i] != Int32(ascii: "}") {
        while buf[i] == Int32(ascii: " ") || buf[i] == Int32(ascii: "{") || buf[i] == 9 || buf[i] == 13 || buf[i] == Int32(ascii: "\n") {
            i += 1
        }

        if buf[i] != 0 && buf[i] != Int32(ascii: "}") {
            i_c = 0
            while buf[i] != Int32(ascii: "{") && buf[i] != 9 && buf[i] != 13 && buf[i] != Int32(ascii: "\n") {
                // Port-note: Raven writes `bs->loved[bs->lovednum].name[i_c] = buf[i]` into a character buffer the view holds as a String.
                // Raven wrote: bs->loved[bs->lovednum].name[i_c] = buf[i]
                portMissing("ParseEmotionalAttachments", source: "oracle/codemp/game/ai_util.c:517")
                i_c += 1
                i += 1
            }
            // Port-note: Raven writes `bs->loved[bs->lovednum].name[i_c] = '\0'` into a character buffer the view holds as a String.
            // Raven wrote: bs->loved[bs->lovednum].name[i_c] = '\0'
            portMissing("ParseEmotionalAttachments", source: "oracle/codemp/game/ai_util.c:517")

            while buf[i] == Int32(ascii: " ") || buf[i] == Int32(ascii: "{") || buf[i] == 9 || buf[i] == 13 || buf[i] == Int32(ascii: "\n") {
                i += 1
            }

            i_c = 0

            while buf[i] != Int32(ascii: "{") && buf[i] != 9 && buf[i] != 13 && buf[i] != Int32(ascii: "\n") {
                tbuf[i_c] = buf[i]
                i_c += 1
                i += 1
            }
            tbuf[i_c] = 0

            bs.loved[bs.lovednum].level = atoi(tbuf)

            bs.lovednum += 1
        } else {
            break
        }

        if bs.lovednum >= MAX_LOVED_ONES {
            return
        }

        i += 1
    }
}

/// Source: oracle/codemp/game/ai_util.c:574
func ReadChatGroups(_ bs: BotState, _ buf: inout JKAShared.CharBuf) -> Int32 {
    // Port-note: A pointer local `char * cgroupbegin` with no view.
    // Raven wrote: char *cgroupbegin;
    portMissing("ReadChatGroups", source: "oracle/codemp/game/ai_util.c:574")
    var cgbplace: Int32
    var i: Int32

    // Port-note: A store into `cgroupbegin`, a local the draft left as a hole.
    // Raven wrote: cgroupbegin = strstr(buf, "BEGIN_CHAT_GROUPS")
    portMissing("ReadChatGroups", source: "oracle/codemp/game/ai_util.c:574")

    // Port-note: A read of `cgroupbegin`, a local the draft left as a hole.
    // Raven wrote: if (!cgroupbegin) { return 0; }
    portMissing("ReadChatGroups", source: "oracle/codemp/game/ai_util.c:574")

    // Port-note: A read of `cgroupbegin`, a local the draft left as a hole.
    // Raven wrote: if (strlen(cgroupbegin) >= MAX_CHAT_BUFFER_SIZE) { G_Printf(S_COLOR_RED "Error: Personality chat section exceeds max size\n"); return 0; }
    portMissing("ReadChatGroups", source: "oracle/codemp/game/ai_util.c:574")

    // Port-note: A read of `cgroupbegin`, a local the draft left as a hole.
    // Raven wrote: cgbplace = cgroupbegin - buf+1
    portMissing("ReadChatGroups", source: "oracle/codemp/game/ai_util.c:574")

    while buf[cgbplace] != Int32(ascii: "\n") {
        cgbplace += 1
    }

    i = 0

    // Raven tests `buf[cgbplace]` and `buf[cgbplace] != '\0'`.
    // Both read as the same Swift test, so the draft writes it once.
    while buf[cgbplace] != 0 {
        gBotChatBuffer[bs.client][i] = buf[cgbplace]
        i += 1
        cgbplace += 1
    }

    gBotChatBuffer[bs.client][i] = 0

    return 1
}

/// Source: oracle/codemp/game/ai_util.c:614
func BotUtilizePersonality(_ bs: BotState) {
    var f: fileHandle_t = 0
    var len: Int32
    let rlen: Int32
    var failed: Int32
    var i: Int32
    //char buf[131072];
    var buf = CharBuf(131072)
    _ = B_TempAlloc(131072)
    var readbuf = CharBuf(1024)
    var group = CharBuf(65536)

    len = trap_FS_FOpenFile(bs.settings.personalityfile, &f, FS_READ)

    failed = 0

    if f == 0 {
        G_Printf(S_COLOR_RED + "Error: Specified personality not found\n")
        B_TempFree(131072) //buf
        return
    }

    if len >= 131072 {
        G_Printf(S_COLOR_RED + "Personality file exceeds maximum length\n")
        B_TempFree(131072) //buf
        return
    }

    trap_FS_Read(&buf, len, f)

    rlen = len

    while len < 131072 {
        //kill all characters after the file length, since sometimes FS_Read doesn't do that entirely (or so it seems)
        buf[len] = 0
        len += 1
    }

    len = rlen

    _ = B_TempAlloc(1024)
    _ = B_TempAlloc(65536)

    if GetValueGroup(&buf, "GeneralBotInfo", &group) == 0 {
        G_Printf(S_COLOR_RED + "Personality file contains no GeneralBotInfo group\n")
        failed = 1 //set failed so we know to set everything to default values
    }

    if failed == 0 && GetPairedValue(&group, "reflex", &readbuf) != 0 {
        bs.skills.reflex = atoi(readbuf)
    } else {
        bs.skills.reflex = 100 //default
    }

    if failed == 0 && GetPairedValue(&group, "accuracy", &readbuf) != 0 {
        bs.skills.accuracy = atof(readbuf)
    } else {
        bs.skills.accuracy = 10 //default
    }

    if failed == 0 && GetPairedValue(&group, "turnspeed", &readbuf) != 0 {
        bs.skills.turnspeed = atof(readbuf)
    } else {
        bs.skills.turnspeed = 0.01 //default
    }

    if failed == 0 && GetPairedValue(&group, "turnspeed_combat", &readbuf) != 0 {
        bs.skills.turnspeed_combat = atof(readbuf)
    } else {
        bs.skills.turnspeed_combat = 0.05 //default
    }

    if failed == 0 && GetPairedValue(&group, "maxturn", &readbuf) != 0 {
        bs.skills.maxturn = atof(readbuf)
    } else {
        bs.skills.maxturn = 360 //default
    }

    if failed == 0 && GetPairedValue(&group, "perfectaim", &readbuf) != 0 {
        bs.skills.perfectaim = atoi(readbuf)
    } else {
        bs.skills.perfectaim = 0 //default
    }

    if failed == 0 && GetPairedValue(&group, "chatability", &readbuf) != 0 {
        bs.canChat = atoi(readbuf)
    } else {
        bs.canChat = 0 //default
    }

    if failed == 0 && GetPairedValue(&group, "chatfrequency", &readbuf) != 0 {
        bs.chatFrequency = atoi(readbuf)
    } else {
        bs.chatFrequency = 5 //default
    }

    if failed == 0 && GetPairedValue(&group, "hatelevel", &readbuf) != 0 {
        bs.loved_death_thresh = atoi(readbuf)
    } else {
        bs.loved_death_thresh = 3 //default
    }

    if failed == 0 && GetPairedValue(&group, "camper", &readbuf) != 0 {
        bs.isCamper = atoi(readbuf)
    } else {
        bs.isCamper = 0 //default
    }

    if failed == 0 && GetPairedValue(&group, "saberspecialist", &readbuf) != 0 {
        bs.saberSpecialist = atoi(readbuf)
    } else {
        bs.saberSpecialist = 0 //default
    }

    if failed == 0 && GetPairedValue(&group, "forceinfo", &readbuf) != 0 {
        Com_sprintf(&bs.forceinfoBuffer, 2048, "%s\0", readbuf)
    } else {
        Com_sprintf(&bs.forceinfoBuffer, 2048, "%s\0", DEFAULT_FORCEPOWERS)
    }

    i = 0

    while i < MAX_CHAT_BUFFER_SIZE {
        //clear out the chat buffer for this bot
        gBotChatBuffer[bs.client][i] = 0
        i += 1
    }

    if bs.canChat != 0 {
        if ReadChatGroups(bs, &buf) == 0 {
            bs.canChat = 0
        }
    }

    if GetValueGroup(&buf, "BotWeaponWeights", &group) != 0 {
        if GetPairedValue(&group, "WP_STUN_BATON", &readbuf) != 0 {
            bs.botWeaponWeights[WP_STUN_BATON] = Float(atoi(readbuf))
            bs.botWeaponWeights[WP_MELEE] = bs.botWeaponWeights[WP_STUN_BATON]
        }

        if GetPairedValue(&group, "WP_SABER", &readbuf) != 0 {
            bs.botWeaponWeights[WP_SABER] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_BRYAR_PISTOL", &readbuf) != 0 {
            bs.botWeaponWeights[WP_BRYAR_PISTOL] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_BLASTER", &readbuf) != 0 {
            bs.botWeaponWeights[WP_BLASTER] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_DISRUPTOR", &readbuf) != 0 {
            bs.botWeaponWeights[WP_DISRUPTOR] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_BOWCASTER", &readbuf) != 0 {
            bs.botWeaponWeights[WP_BOWCASTER] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_REPEATER", &readbuf) != 0 {
            bs.botWeaponWeights[WP_REPEATER] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_DEMP2", &readbuf) != 0 {
            bs.botWeaponWeights[WP_DEMP2] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_FLECHETTE", &readbuf) != 0 {
            bs.botWeaponWeights[WP_FLECHETTE] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_ROCKET_LAUNCHER", &readbuf) != 0 {
            bs.botWeaponWeights[WP_ROCKET_LAUNCHER] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_THERMAL", &readbuf) != 0 {
            bs.botWeaponWeights[WP_THERMAL] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_TRIP_MINE", &readbuf) != 0 {
            bs.botWeaponWeights[WP_TRIP_MINE] = Float(atoi(readbuf))
        }

        if GetPairedValue(&group, "WP_DET_PACK", &readbuf) != 0 {
            bs.botWeaponWeights[WP_DET_PACK] = Float(atoi(readbuf))
        }
    }

    bs.lovednum = 0

    if GetValueGroup(&buf, "EmotionalAttachments", &group) != 0 {
        ParseEmotionalAttachments(bs, String(group))
    }

    B_TempFree(131072) //buf
    B_TempFree(1024) //readbuf
    B_TempFree(65536) //group
    trap_FS_FCloseFile(f)
}
