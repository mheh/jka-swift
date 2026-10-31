/**
```
================
CG_CustomSound

================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:170
func CG_CustomSound(_ clientNum: Int32, _ soundName: String) -> JKAShared.sfxHandle_t {
    var ci: ClientInfo?
    var i: Int32
    var numCSounds: Int32 = 0
    var numCComSounds: Int32 = 0
    var numCExSounds: Int32 = 0
    var numCJediSounds: Int32 = 0
    var numCSiegeSounds: Int32 = 0
    var numCDuelSounds: Int32 = 0
    var lSoundName = CharBuf(64)
    // Raven assigns his own `clientNum` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var clientNum = clientNum

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Character' to expected argument type 'Int32'".
    // Raven wrote: if ( soundName[0] != '*' ) { return trap_S_RegisterSound( soundName ); }
    portMissing("CG_CustomSound", source: "oracle/codemp/cgame/cg_players.c:170")

    COM_StripExtension(soundName, &lSoundName)

    if clientNum < 0 {
        clientNum = 0
    }

    if clientNum >= MAX_CLIENTS {
        ci = cg_entities[clientNum].npcClient
    } else {
        ci = cgs.clientinfo[clientNum]
    }

    if ci == nil {
        // Port-note: Raven returns NULL, and the function returns a `sfxHandle_t`.
        // Raven wrote: return 0
        portMissing("CG_CustomSound", source: "oracle/codemp/cgame/cg_players.c:170")
    }

    i = 0
    while i < MAX_CUSTOM_SOUNDS {
        if cg_customSoundNames[i] == nil {
            numCSounds = i
            break
        }
        i += 1
    }

    if clientNum >= MAX_CLIENTS {
        //these are only for npc's
        i = 0
        while i < MAX_CUSTOM_SOUNDS {
            if cg_customCombatSoundNames[i] == nil {
                numCComSounds = i
                break
            }
            i += 1
        }

        i = 0
        while i < MAX_CUSTOM_SOUNDS {
            if cg_customExtraSoundNames[i] == nil {
                numCExSounds = i
                break
            }
            i += 1
        }

        i = 0
        while i < MAX_CUSTOM_SOUNDS {
            if cg_customJediSoundNames[i] == nil {
                numCJediSounds = i
                break
            }
            i += 1
        }
    }

    if cgs.gametype >= GT_TEAM || cg_buildScript.integer != 0 {
        //siege only
        i = 0
        while i < MAX_CUSTOM_SOUNDS {
            if bg_customSiegeSoundNames[i] == nil {
                numCSiegeSounds = i
                break
            }
            i += 1
        }
    }

    if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL || cg_buildScript.integer != 0 {
        //Duel only
        i = 0
        while i < MAX_CUSTOM_SOUNDS {
            if cg_customDuelSoundNames[i] == nil {
                numCDuelSounds = i
                break
            }
            i += 1
        }
    }

    i = 0
    while i < MAX_CUSTOM_SOUNDS {
        if i < numCSounds && strcmp(lSoundName, cg_customSoundNames[i]) == 0 {
            return ci!.sounds[i]
        } else if (cgs.gametype >= GT_TEAM || cg_buildScript.integer != 0) && i < numCSiegeSounds && strcmp(lSoundName, bg_customSiegeSoundNames[i]) == 0 {
            //siege only
            return ci!.siegeSounds[i]
        } else if (cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL || cg_buildScript.integer != 0) && i < numCDuelSounds && strcmp(lSoundName, cg_customDuelSoundNames[i]) == 0 {
            //siege only
            return ci!.duelSounds[i]
        } else if clientNum >= MAX_CLIENTS && i < numCComSounds && strcmp(lSoundName, cg_customCombatSoundNames[i]) == 0 {
            //npc only
            return ci!.combatSounds[i]
        } else if clientNum >= MAX_CLIENTS && i < numCExSounds && strcmp(lSoundName, cg_customExtraSoundNames[i]) == 0 {
            //npc only
            return ci!.extraSounds[i]
        } else if clientNum >= MAX_CLIENTS && i < numCJediSounds && strcmp(lSoundName, cg_customJediSoundNames[i]) == 0 {
            //npc only
            return ci!.jediSounds[i]
        }
        i += 1
    }

    //CG_Error( "Unknown custom sound: %s", lSoundName );
    Com_Printf("Unknown custom sound: %s", lSoundName)
    // Port-note: Raven returns NULL, and the function returns a `sfxHandle_t`.
    // Raven wrote: return 0
    portMissing("CG_CustomSound", source: "oracle/codemp/cgame/cg_players.c:170")
}

/// Source: oracle/codemp/cgame/cg_players.c:314
func CG_ParseSurfsFile(_ modelName: String, _ skinName: String, _ surfOff: inout JKAShared.CharBuf, _ surfOn: inout JKAShared.CharBuf) -> Bool {
    var text_p = TextCursor()
    let len: Int32
    var token: String
    var value: String = ""
    var text = CharBuf(20000)
    var sfilename = CharBuf(64)
    var f: fileHandle_t = 0
    var i: Int32 = 0

    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '!=' cannot be applied to operands of type 'Character' and 'Int'".
    // Raven wrote: while (skinName && skinName[i]) { if (skinName[i] == '|') { //this is a multi-part skin, said skins do not support .surf files return qfalse; } i++; }
    portMissing("CG_ParseSurfsFile", source: "oracle/codemp/cgame/cg_players.c:314")


    // Load and parse .surf file
    Com_sprintf(&sfilename, Int32((sfilename).count), "models/players/%s/model_%s.surf", modelName, skinName)

    // load the file
    len = trap_FS_FOpenFile(String(sfilename), &f, FS_READ)
    if len <= 0 {
        //no file
        return false
    }
    if len >= Int32((text).count) - 1 {
        Com_Printf("File %s too long\n", sfilename)
        return false
    }

    trap_FS_Read(&text, len, f)
    text[len] = 0
    trap_FS_FCloseFile(f)

    // parse the text
    text_p = TextCursor(text)

    // Port-note: Raven's `memset( (char *)surfOff, 0, sizeof(surfOff) )` runs over bytes that are not one record with a view.
    // Raven wrote: memset( (char *)surfOff, 0, sizeof(surfOff) )
    portMissing("CG_ParseSurfsFile", source: "oracle/codemp/cgame/cg_players.c:314")
    // Port-note: Raven's `memset( (char *)surfOn, 0, sizeof(surfOn) )` runs over bytes that are not one record with a view.
    // Raven wrote: memset( (char *)surfOn, 0, sizeof(surfOn) )
    portMissing("CG_ParseSurfsFile", source: "oracle/codemp/cgame/cg_players.c:314")

    // read information for surfOff and surfOn
    while 1 != 0 {
        token = COM_ParseExt(&text_p, true)
        if token.isEmpty {
            break
        }

        // surfOff
        if Q_stricmp(token, "surfOff") == 0 {
            if COM_ParseString(&text_p, &value) {
                continue
            }
            if surfOff[0] != 0 {
                Q_strcat(&surfOff, MAX_SURF_LIST_SIZE, ",")
                Q_strcat(&surfOff, MAX_SURF_LIST_SIZE, value)
            } else {
                Q_strncpyz(&surfOff, value, MAX_SURF_LIST_SIZE)
            }
            continue
        }

        // surfOn
        if Q_stricmp(token, "surfOn") == 0 {
            if COM_ParseString(&text_p, &value) {
                continue
            }
            if surfOn[0] != 0 {
                Q_strcat(&surfOn, MAX_SURF_LIST_SIZE, ",")
                Q_strcat(&surfOn, MAX_SURF_LIST_SIZE, value)
            } else {
                Q_strncpyz(&surfOn, value, MAX_SURF_LIST_SIZE)
            }
            continue
        }
    }
    return true
}

/// Source: oracle/codemp/cgame/cg_players.c:421
private func CG_RegisterClientModelname(_ ci: ClientInfo, _ modelName: String, _ skinName: String, _ teamName: String, _ clientNum: Int32) -> Bool {
    let handle: Int32
    var afilename = CharBuf(64)
    // Port-note: A pointer local `char * slash` with no view.
    // Raven wrote: char /**GLAName,*/ *slash;
    portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
    var GLAName = CharBuf(64)
    var tempVec = vec3_t(0, 0, 0)
    var badModel: Bool = false
    var surfOff = CharBuf(1024)
    var surfOn = CharBuf(1024)
    let checkSkin: Int32
    let useSkinName: String

    // Raven steps his own `modelName` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var modelName = TextCursor(CharBuf(modelName))
    // Raven steps his own `skinName` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var skinName = TextCursor(CharBuf(skinName))
    retryModel: while true {
        if badModel {
            if !modelName.isNull && modelName[0] != 0 {
                Com_Printf("WARNING: Attempted to load an unsupported multiplayer model %s! (bad or missing bone, or missing animation sequence)\n", modelName.text)
            }

            modelName = TextCursor("kyle")
            skinName = TextCursor("default")

            badModel = false
        }

        // First things first.  If this is a ghoul2 model, then let's make sure we demolish this first.
        if ci.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci.ghoul2Model) {
            trap_G2API_CleanGhoul2Models(&(ci.ghoul2Model))
        }

        if !BG_IsValidCharacterModel(modelName.text, skinName.text) {
            modelName = TextCursor("kyle")
            skinName = TextCursor("default")
        }

        if cgs.gametype >= GT_TEAM && !cgs.jediVmerc && cgs.gametype != GT_SIEGE {
            //We won't force colors for siege.
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec3_t' (aka 'SIMD3<Float>')".
            // Raven wrote: BG_ValidateSkinForTeam( ci->modelName, ci->skinName, ci->team, ci->colorOverride )
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String' to expected argument type 'CharBuf'".
            // Raven wrote: skinName = ci->skinName
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
        } else {
            ci.colorOverride[2] = 0.0
            ci.colorOverride[1] = ci.colorOverride[2]
            ci.colorOverride[0] = ci.colorOverride[1]
        }

        if strchr(skinName.text, Int32(ascii: "|")) != nil {
            //three part skin
            useSkinName = va("models/players/%s/|%s", modelName.text, skinName.text)
        } else {
            useSkinName = va("models/players/%s/model_%s.skin", modelName.text, skinName.text)
        }

        checkSkin = trap_R_RegisterSkin(useSkinName)

        if checkSkin != 0 {
            ci.torsoSkin = checkSkin
        } else {
            //fallback to the default skin
            ci.torsoSkin = trap_R_RegisterSkin(va("models/players/%s/model_default.skin", modelName.text, skinName.text))
        }
        Com_sprintf(&afilename, Int32((afilename).count), "models/players/%s/model.glm", modelName.text)
        handle = trap_G2API_InitGhoul2Model(&ci.ghoul2Model, String(afilename), 0, ci.torsoSkin, 0, 0, 0)

        if handle < 0 {
            return false
        }

        // The model is now loaded.

        trap_G2API_SetSkin(ci.ghoul2Model, 0, ci.torsoSkin, ci.torsoSkin)

        GLAName[0] = 0

        strcpy(&GLAName, trap_G2API_GetGLAName(ci.ghoul2Model, 0))
        if GLAName[0] != 0 {
            if strstr(GLAName, "players/_humanoid/") == nil {
                //Bad!
                badModel = true
                continue retryModel
            }
        }

        if !BGPAFtextLoaded {
            if GLAName[0] == 0 {
                badModel = true
                continue retryModel
            }
            Q_strncpyz(&afilename, String(GLAName), Int32((afilename).count))
            // Port-note: A store into `slash`, a local the draft left as a hole.
            // Raven wrote: slash = Q_strrchr( afilename, '/' )
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
            // Port-note: A read of `slash`, a local the draft left as a hole.
            // Raven wrote: if ( slash ) { strcpy(slash, "/animation.cfg"); } // Now afilename holds just the path to the animation.cfg else { // Didn't find any slashes, this is a raw filename right in base (whish isn't a good thing) return qfalse; }
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")

            //rww - All player models must use humanoid, no matter what.
            if Q_stricmp(afilename, "models/players/_humanoid/animation.cfg") != 0 {
                Com_Printf("Model does not use supported animation config.\n")
                return false
            } else if BG_ParseAnimationFile("models/players/_humanoid/animation.cfg", bgHumanoidAnimations, true) == -1 {
                Com_Printf("Failed to load animation file models/players/_humanoid/animation.cfg\n")
                return false
            }

            BG_ParseAnimationEvtFile("models/players/_humanoid/", 0, -1) //get the sounds for the humanoid anims
            //		if (cgs.gametype == GT_SIEGE)
            //		{
            //			BG_ParseAnimationEvtFile( "models/players/rockettrooper/", 1, 1 ); //parse rockettrooper too
            //		}
            //For the time being, we're going to have all real players use the generic humanoid soundset and that's it.
            //Only npc's will use model-specific soundsets.

            //	BG_ParseAnimationSndFile(va("models/players/%s/", modelName), 0, -1);
        } else if !bgAllEvents[0].eventsParsed {
            //make sure the player anim sounds are loaded even if the anims already are
            BG_ParseAnimationEvtFile("models/players/_humanoid/", 0, -1)
            //		if (cgs.gametype == GT_SIEGE)
            //		{
            //			BG_ParseAnimationEvtFile( "models/players/rockettrooper/", 1, 1 );
            //		}
        }

        if CG_ParseSurfsFile(modelName.text, skinName.text, &surfOff, &surfOn) {
            //turn on/off any surfs
            var token: String
            // Port-note: A pointer local `const char * p` with no view.
            // Raven wrote: const char *p;
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")

            //Now turn on/off any surfaces
            // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'".
            // Raven wrote: if ( surfOff && surfOff[0] ) { p = surfOff; while ( 1 ) { token = COM_ParseExt( &p, qtrue ); if ( !token[0] ) {//reached end of list break; } //turn off this surf trap_G2API_SetSurfaceOnOff( ci->ghoul2Model, token, 0x00000002/*G2SURFACEFLAG_OFF*/ ); } }
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "referencing operator function '!=' on 'BinaryInteger' requires that 'CharBuf' conform to 'BinaryInteger'".
            // Raven wrote: if ( surfOn && surfOn[0] ) { p = surfOn; while ( 1 ) { token = COM_ParseExt( &p, qtrue ); if ( !token[0] ) {//reached end of list break; } //turn on this surf trap_G2API_SetSurfaceOnOff( ci->ghoul2Model, token, 0 ); } }
            portMissing("CG_RegisterClientModelname", source: "oracle/codemp/cgame/cg_players.c:421")
        }


        ci.bolt_rhand = trap_G2API_AddBolt(ci.ghoul2Model, 0, "*r_hand")

        if !trap_G2API_SetBoneAnim(ci.ghoul2Model, 0, "model_root", 0, 12, BONE_ANIM_OVERRIDE_LOOP, 1.0, cg.time, -1, -1) {
            badModel = true
        }

        if !trap_G2API_SetBoneAngles(ci.ghoul2Model, 0, "upper_lumbar", tempVec, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, nil, 0, cg.time) {
            badModel = true
        }

        if !trap_G2API_SetBoneAngles(ci.ghoul2Model, 0, "cranium", tempVec, BONE_ANGLES_POSTMULT, POSITIVE_Z, NEGATIVE_Y, POSITIVE_X, nil, 0, cg.time) {
            badModel = true
        }

        ci.bolt_lhand = trap_G2API_AddBolt(ci.ghoul2Model, 0, "*l_hand")

        //rhand must always be first bolt. lhand always second. Whichever you want the
        //jetpack bolted to must always be third.
        trap_G2API_AddBolt(ci.ghoul2Model, 0, "*chestg")

        //claw bolts
        trap_G2API_AddBolt(ci.ghoul2Model, 0, "*r_hand_cap_r_arm")
        trap_G2API_AddBolt(ci.ghoul2Model, 0, "*l_hand_cap_l_arm")

        ci.bolt_head = trap_G2API_AddBolt(ci.ghoul2Model, 0, "*head_top")
        if ci.bolt_head == -1 {
            ci.bolt_head = trap_G2API_AddBolt(ci.ghoul2Model, 0, "ceyebrow")
        }

        ci.bolt_motion = trap_G2API_AddBolt(ci.ghoul2Model, 0, "Motion")

        //We need a lower lumbar bolt for footsteps
        ci.bolt_llumbar = trap_G2API_AddBolt(ci.ghoul2Model, 0, "lower_lumbar")

        if ci.bolt_rhand == -1 || ci.bolt_lhand == -1 || ci.bolt_head == -1 || ci.bolt_motion == -1 || ci.bolt_llumbar == -1 {
            badModel = true
        }

        if badModel {
            continue retryModel
        }

        if Q_stricmp(modelName.text, "boba_fett") == 0 {
            //special case, turn off the jetpack surfs
            trap_G2API_SetSurfaceOnOff(ci.ghoul2Model, "torso_rjet", TURN_OFF)
            trap_G2API_SetSurfaceOnOff(ci.ghoul2Model, "torso_cjet", TURN_OFF)
            trap_G2API_SetSurfaceOnOff(ci.ghoul2Model, "torso_ljet", TURN_OFF)
        }

        //	ent->s.radius = 90;

        if clientNum != -1 {
            /*
            if (cg_entities[clientNum].ghoul2 && trap_G2_HaveWeGhoul2Models(cg_entities[clientNum].ghoul2))
            {
            trap_G2API_CleanGhoul2Models(&(cg_entities[clientNum].ghoul2));
            }
            trap_G2API_DuplicateGhoul2Instance(ci->ghoul2Model, &cg_entities[clientNum].ghoul2);
            */

            cg_entities[clientNum].ghoul2weapon = nil
        }

        Q_strncpyz(&ci.teamNameBuffer, teamName, 32)

        // Model icon for drawing the portrait on screen
        ci.modelIcon = trap_R_RegisterShaderNoMip(va("models/players/%s/icon_%s", modelName.text, skinName.text))
        if ci.modelIcon == 0 {
            var i: Int32 = 0
            var j: Int32
            var iconName = CharBuf(1024)
            strcpy(&iconName, "icon_")
            j = strlen(iconName)
            while skinName[i] != 0 && skinName[i] != Int32(ascii: "|") && j < 1024 {
                iconName[j] = skinName[i]
                j += 1
                i += 1
            }
            iconName[j] = 0
            if skinName[i] == Int32(ascii: "|") {
                //looks like it actually may be a custom model skin, let's try getting the icon...
                ci.modelIcon = trap_R_RegisterShaderNoMip(va("models/players/%s/%s", modelName.text, iconName))
            }
        }
        return true
        break
    }
}

/**
```
====================
CG_ColorFromString
====================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:701
private func CG_ColorFromString(_ v: String, _ color: inout JKAShared.vec3_t) {
    let val: Int32

    color = vec3_t()

    val = atoi(v)

    if val < 1 || val > 7 {
        color = vec3_t(1, 1, 1)
        return
    }

    if (val & 1) != 0 {
        color[2] = 1.0
    }
    if (val & 2) != 0 {
        color[1] = 1.0
    }
    if (val & 4) != 0 {
        color[0] = 1.0
    }
}

/**
```
====================
CG_ColorFromInt
====================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:729
private func CG_ColorFromInt(_ val: Int32, _ color: inout JKAShared.vec3_t) {
    color = vec3_t()

    if val < 1 || val > 7 {
        color = vec3_t(1, 1, 1)
        return
    }

    if (val & 1) != 0 {
        color[2] = 1.0
    }
    if (val & 2) != 0 {
        color[1] = 1.0
    }
    if (val & 4) != 0 {
        color[0] = 1.0
    }
}

//load anim info
/// Source: oracle/codemp/cgame/cg_players.c:749
func CG_G2SkelForModel(_ g2: OpaquePointer?) -> Int32 {
    var animIndex: Int32 = -1
    var GLAName = CharBuf(64)
    // Port-note: A pointer local `char * slash` with no view.
    // Raven wrote: char *slash;
    portMissing("CG_G2SkelForModel", source: "oracle/codemp/cgame/cg_players.c:749")

    GLAName[0] = 0
    strcpy(&GLAName, trap_G2API_GetGLAName(g2, 0))

    // Port-note: A store into `slash`, a local the draft left as a hole.
    // Raven wrote: slash = Q_strrchr( GLAName, '/' )
    portMissing("CG_G2SkelForModel", source: "oracle/codemp/cgame/cg_players.c:749")
    // Port-note: A read of `slash`, a local the draft left as a hole.
    // Raven wrote: if ( slash ) { strcpy(slash, "/animation.cfg"); animIndex = BG_ParseAnimationFile(GLAName, NULL, qfalse); }
    portMissing("CG_G2SkelForModel", source: "oracle/codemp/cgame/cg_players.c:749")

    return animIndex
}

//get the appropriate anim events file index
/// Source: oracle/codemp/cgame/cg_players.c:770
func CG_G2EvIndexForModel(_ g2: OpaquePointer?, _ animIndex: Int32) -> Int32 {
    var evtIndex: Int32 = -1
    var GLAName = CharBuf(64)
    // Port-note: A pointer local `char * slash` with no view.
    // Raven wrote: char *slash;
    portMissing("CG_G2EvIndexForModel", source: "oracle/codemp/cgame/cg_players.c:770")

    if animIndex == -1 {
        return -1
    }

    GLAName[0] = 0
    strcpy(&GLAName, trap_G2API_GetGLAName(g2, 0))

    // Port-note: A store into `slash`, a local the draft left as a hole.
    // Raven wrote: slash = Q_strrchr( GLAName, '/' )
    portMissing("CG_G2EvIndexForModel", source: "oracle/codemp/cgame/cg_players.c:770")
    // Port-note: A read of `slash`, a local the draft left as a hole.
    // Raven wrote: if ( slash ) { slash++; *slash = 0; evtIndex = BG_ParseAnimationEvtFile(GLAName, animIndex, bgNumAnimEvents); }
    portMissing("CG_G2EvIndexForModel", source: "oracle/codemp/cgame/cg_players.c:770")

    return evtIndex
}

/// Source: oracle/codemp/cgame/cg_players.c:799
func CG_LoadCISounds(_ ci: ClientInfo, _ modelloaded: Bool) {
    var f: fileHandle_t = 0
    var isFemale: Bool = false
    var i: Int32 = 0
    var fLen: Int32 = 0
    let dir: String
    var soundpath = CharBuf(64)
    var soundName = CharBuf(1024)
    // Port-note: A pointer local `const char * s` with no view.
    // Raven wrote: const char *s;
    portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")

    dir = ci.modelName

    if ci.skinName.isEmpty || Q_stricmp("default", ci.skinName) == 0 {
        //try default sounds.cfg first
        fLen = trap_FS_FOpenFile(va("models/players/%s/sounds.cfg", dir), &f, FS_READ)
        if f == 0 {
            //no?  Look for _default sounds.cfg
            fLen = trap_FS_FOpenFile(va("models/players/%s/sounds_default.cfg", dir), &f, FS_READ)
        }
    } else {
        //use the .skin associated with this skin
        fLen = trap_FS_FOpenFile(va("models/players/%s/sounds_%s.cfg", dir, ci.skinName), &f, FS_READ)
        if f == 0 {
            //fall back to default sounds
            fLen = trap_FS_FOpenFile(va("models/players/%s/sounds.cfg", dir), &f, FS_READ)
        }
    }

    soundpath[0] = 0

    if f != 0 {
        trap_FS_Read(&soundpath, fLen, f)
        soundpath[fLen] = 0

        i = fLen

        while i >= 0 && soundpath[i] != Int32(ascii: "\n") {
            if soundpath[i] == Int32(ascii: "f") {
                isFemale = true
                soundpath[i] = 0
            }

            i -= 1
        }

        i = 0

        while soundpath[i] != 0 && soundpath[i] != Int32(ascii: "\r") && soundpath[i] != Int32(ascii: "\n") {
            i += 1
        }
        soundpath[i] = 0

        trap_FS_FCloseFile(f)
    }

    if isFemale {
        ci.gender = GENDER_FEMALE
    } else {
        ci.gender = GENDER_MALE
    }

    trap_S_ShutUp(true)

    i = 0
    while i < MAX_CUSTOM_SOUNDS {
        // Port-note: A store into `s`, a local the draft left as a hole.
        // Raven wrote: s = cg_customSoundNames[i]
        portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
        // Port-note: A read of `s`, a local the draft left as a hole.
        // Raven wrote: if ( !s ) { break; }
        portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")

        // Port-note: A read of `s`, a local the draft left as a hole.
        // Raven wrote: Com_sprintf(soundName, sizeof(soundName), "%s", s+1)
        portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
        COM_StripExtension(String(soundName), &soundName)
        //strip the extension because we might want .mp3's

        ci.sounds[i] = 0
        // if the model didn't load use the sounds of the default model
        if soundpath[0] != 0 {
            ci.sounds[i] = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", soundpath, soundName))
        } else {
            if modelloaded {
                ci.sounds[i] = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", dir, soundName))
            }
        }

        if ci.sounds[i] == 0 {
            //failed the load, try one out of the generic path
            if isFemale {
                ci.sounds[i] = trap_S_RegisterSound(va("sound/%s/%s", DEFAULT_FEMALE_SOUNDPATH, soundName))
            } else {
                ci.sounds[i] = trap_S_RegisterSound(va("sound/%s/%s", DEFAULT_MALE_SOUNDPATH, soundName))
            }
        }
        i += 1
    }

    if cgs.gametype >= GT_TEAM || cg_buildScript.integer != 0 {
        //load the siege sounds then
        i = 0
        while i < MAX_CUSTOM_SIEGE_SOUNDS {
            // Port-note: A store into `s`, a local the draft left as a hole.
            // Raven wrote: s = bg_customSiegeSoundNames[i]
            portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
            // Port-note: A read of `s`, a local the draft left as a hole.
            // Raven wrote: if ( !s ) { break; }
            portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")

            // Port-note: A read of `s`, a local the draft left as a hole.
            // Raven wrote: Com_sprintf(soundName, sizeof(soundName), "%s", s+1)
            portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
            COM_StripExtension(String(soundName), &soundName)
            //strip the extension because we might want .mp3's

            ci.siegeSounds[i] = 0
            // if the model didn't load use the sounds of the default model
            if soundpath[0] != 0 {
                ci.siegeSounds[i] = trap_S_RegisterSound(va("sound/%s/%s", soundpath, soundName))
            } else {
                if modelloaded {
                    ci.siegeSounds[i] = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", dir, soundName))
                }
            }

            if ci.siegeSounds[i] == 0 {
                //failed the load, try one out of the generic path
                if isFemale {
                    ci.siegeSounds[i] = trap_S_RegisterSound(va("sound/%s/%s", DEFAULT_FEMALE_SOUNDPATH, soundName))
                } else {
                    ci.siegeSounds[i] = trap_S_RegisterSound(va("sound/%s/%s", DEFAULT_MALE_SOUNDPATH, soundName))
                }
            }
            i += 1
        }
    }

    if cgs.gametype == GT_DUEL || cgs.gametype == GT_POWERDUEL || cg_buildScript.integer != 0 {
        //load the Duel sounds then
        i = 0
        while i < MAX_CUSTOM_DUEL_SOUNDS {
            // Port-note: A store into `s`, a local the draft left as a hole.
            // Raven wrote: s = cg_customDuelSoundNames[i]
            portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
            // Port-note: A read of `s`, a local the draft left as a hole.
            // Raven wrote: if ( !s ) { break; }
            portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")

            // Port-note: A read of `s`, a local the draft left as a hole.
            // Raven wrote: Com_sprintf(soundName, sizeof(soundName), "%s", s+1)
            portMissing("CG_LoadCISounds", source: "oracle/codemp/cgame/cg_players.c:799")
            COM_StripExtension(String(soundName), &soundName)
            //strip the extension because we might want .mp3's

            ci.duelSounds[i] = 0
            // if the model didn't load use the sounds of the default model
            if soundpath[0] != 0 {
                ci.duelSounds[i] = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", soundpath, soundName))
            } else {
                if modelloaded {
                    ci.duelSounds[i] = trap_S_RegisterSound(va("sound/chars/%s/misc/%s", dir, soundName))
                }
            }

            if ci.duelSounds[i] == 0 {
                //failed the load, try one out of the generic path
                if isFemale {
                    ci.duelSounds[i] = trap_S_RegisterSound(va("sound/%s/%s", DEFAULT_FEMALE_SOUNDPATH, soundName))
                } else {
                    ci.duelSounds[i] = trap_S_RegisterSound(va("sound/%s/%s", DEFAULT_MALE_SOUNDPATH, soundName))
                }
            }
            i += 1
        }
    }

    trap_S_ShutUp(false)
}

/**
```
===================
CG_LoadClientInfo

Load it now, taking the disk hits.
This will usually be deferred to a safe time
===================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1006
func CG_LoadClientInfo(_ ci: ClientInfo) {
    var modelloaded: Bool = false
    var clientNum: Int32 = 0
    var i: Int32 = 0
    var teamname = CharBuf(64)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to operands of type 'ClientInfo' and 'Slots<ClientInfo>'".
    // Raven wrote: clientNum = ci - cgs.clientinfo
    portMissing("CG_LoadClientInfo", source: "oracle/codemp/cgame/cg_players.c:1006")

    if clientNum < 0 || clientNum >= MAX_CLIENTS {
        clientNum = -1
    }

    ci.deferred = false

    /*
    if (ci->team == TEAM_SPECTATOR)
    {
    // reset any existing players and bodies, because they might be in bad
    // frames for this new model
    clientNum = ci - cgs.clientinfo;
    for ( i = 0 ; i < MAX_GENTITIES ; i++ ) {
    if ( cg_entities[i].currentState.clientNum == clientNum
    && cg_entities[i].currentState.eType == ET_PLAYER ) {
    CG_ResetPlayerEntity( &cg_entities[i] );
    }
    }

    if (ci->ghoul2Model && trap_G2_HaveWeGhoul2Models(ci->ghoul2Model))
    {
    trap_G2API_CleanGhoul2Models(&ci->ghoul2Model);
    }

    return;
    }
    */

    teamname[0] = 0
    if cgs.gametype >= GT_TEAM {
        if ci.team == TEAM_BLUE {
            Q_strncpyz(&teamname, DEFAULT_BLUETEAM_NAME, Int32((teamname).count))
        } else {
            Q_strncpyz(&teamname, DEFAULT_REDTEAM_NAME, Int32((teamname).count))
        }
    }
    if teamname[0] != 0 {
        strcat(&teamname, "/")
    }
    modelloaded = true
    if cgs.gametype == GT_SIEGE && (ci.team == TEAM_SPECTATOR || ci.siegeIndex == -1) {
        //yeah.. kind of a hack I guess. Don't care until they are actually ingame with a valid class.
        if !CG_RegisterClientModelname(ci, DEFAULT_MODEL, "default", String(teamname), -1) {
            CG_Error("DEFAULT_MODEL (%s) failed to register", DEFAULT_MODEL)
        }
    } else {
        if !CG_RegisterClientModelname(ci, ci.modelName, ci.skinName, String(teamname), clientNum) {
            //CG_Error( "CG_RegisterClientModelname( %s, %s, %s, %s %s ) failed", ci->modelName, ci->skinName, ci->headModelName, ci->headSkinName, teamname );
            //rww - DO NOT error out here! Someone could just type in a nonsense model name and crash everyone's client.
            //Give it a chance to load default model for this client instead.

            // fall back to default team name
            if cgs.gametype >= GT_TEAM {
                // keep skin name
                if ci.team == TEAM_BLUE {
                    Q_strncpyz(&teamname, DEFAULT_BLUETEAM_NAME, Int32((teamname).count))
                } else {
                    Q_strncpyz(&teamname, DEFAULT_REDTEAM_NAME, Int32((teamname).count))
                }
                if !CG_RegisterClientModelname(ci, DEFAULT_MODEL, ci.skinName, String(teamname), -1) {
                    CG_Error("DEFAULT_MODEL / skin (%s/%s) failed to register", DEFAULT_MODEL, ci.skinName)
                }
            } else {
                if !CG_RegisterClientModelname(ci, DEFAULT_MODEL, "default", String(teamname), -1) {
                    CG_Error("DEFAULT_MODEL (%s) failed to register", DEFAULT_MODEL)
                }
            }
            modelloaded = false
        }
    }

    if clientNum != -1 {
        trap_G2API_ClearAttachedInstance(clientNum)
    }

    if clientNum != -1 && ci.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci.ghoul2Model) {
        if cg_entities[clientNum].ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cg_entities[clientNum].ghoul2) {
            trap_G2API_CleanGhoul2Models(&cg_entities[clientNum].ghoul2)
        }
        trap_G2API_DuplicateGhoul2Instance(ci.ghoul2Model, &cg_entities[clientNum].ghoul2)

        //Attach the instance to this entity num so we can make use of client-server
        //shared operations if possible.
        trap_G2API_AttachInstanceToEntNum(cg_entities[clientNum].ghoul2, clientNum, false)


        if trap_G2API_AddBolt(cg_entities[clientNum].ghoul2, 0, "face") == -1 {
            //check now to see if we have this bone for setting anims and such
            cg_entities[clientNum].noFace = true
        }

        cg_entities[clientNum].localAnimIndex = CG_G2SkelForModel(cg_entities[clientNum].ghoul2)
        cg_entities[clientNum].eventAnimIndex = CG_G2EvIndexForModel(cg_entities[clientNum].ghoul2, cg_entities[clientNum].localAnimIndex)
    }

    ci.newAnims = false
    if ci.torsoModel != 0 {
        // Raven's record lives to the end of his block, so the block is the closure.
        Orientation.scratch { tag in
            // if the torso model has the "tag_flag"
            if trap_R_LerpTag(tag, ci.torsoModel, 0, 0, 1, "tag_flag") != 0 {
                ci.newAnims = true
            }
        }
    }

    // sounds
    if cgs.gametype == GT_SIEGE && (ci.team == TEAM_SPECTATOR || ci.siegeIndex == -1) {
        //don't need to load sounds
    } else {
        CG_LoadCISounds(ci, modelloaded)
    }

    ci.deferred = false

    // reset any existing players and bodies, because they might be in bad
    // frames for this new model
    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '-' cannot be applied to operands of type 'ClientInfo' and 'Slots<ClientInfo>'".
    // Raven wrote: clientNum = ci - cgs.clientinfo
    portMissing("CG_LoadClientInfo", source: "oracle/codemp/cgame/cg_players.c:1006")
    i = 0
    while i < MAX_GENTITIES {
        if cg_entities[i].currentState.clientNum == clientNum && cg_entities[i].currentState.eType == ET_PLAYER {
            CG_ResetPlayerEntity(cg_entities[i])
        }
        i += 1
    }
}

//Take care of initializing all the ghoul2 saber stuff based on clientinfo data. -rww
/// Source: oracle/codemp/cgame/cg_players.c:1151
private func CG_InitG2SaberData(_ saberNum: Int32, _ ci: ClientInfo) {
    trap_G2API_InitGhoul2Model(&ci.ghoul2Weapons[saberNum], ci.saber[saberNum].model, 0, ci.saber[saberNum].skin, 0, 0, 0)

    if ci.ghoul2Weapons[saberNum] != nil {
        var k: Int32 = 0
        var tagBolt: Int32
        var tagName: String

        if ci.saber[saberNum].skin != 0 {
            trap_G2API_SetSkin(ci.ghoul2Weapons[saberNum], 0, ci.saber[saberNum].skin, ci.saber[saberNum].skin)
        }

        if (ci.saber[saberNum].saberFlags & SFL_BOLT_TO_WRIST) != 0 {
            trap_G2API_SetBoltInfo(ci.ghoul2Weapons[saberNum], 0, 3 + saberNum)
        } else {
            trap_G2API_SetBoltInfo(ci.ghoul2Weapons[saberNum], 0, saberNum)
        }

        while k < ci.saber[saberNum].numBlades {
            tagName = va("*blade%i", k + 1)
            tagBolt = trap_G2API_AddBolt(ci.ghoul2Weapons[saberNum], 0, tagName)

            if tagBolt == -1 {
                if k == 0 {
                    //guess this is an 0ldsk3wl saber
                    tagBolt = trap_G2API_AddBolt(ci.ghoul2Weapons[saberNum], 0, "*flash")

                    if tagBolt == -1 {
                    }
                    break
                }

                if tagBolt == -1 {
                    break
                }
            }

            k += 1
        }
    }
}

/**
```
======================
CG_CopyClientInfoModel
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1211
private func CG_CopyClientInfoModel(_ from: ClientInfo, _ to: ClientInfo) {
    to.headOffset = from.headOffset
    //	to->footsteps = from->footsteps;
    to.gender = from.gender

    to.legsModel = from.legsModel
    to.legsSkin = from.legsSkin
    to.torsoModel = from.torsoModel
    to.torsoSkin = from.torsoSkin
    //to->headModel = from->headModel;
    //to->headSkin = from->headSkin;
    to.modelIcon = from.modelIcon

    to.newAnims = from.newAnims

    //to->ghoul2Model = from->ghoul2Model;
    //rww - Trying to use the same ghoul2 pointer for two seperate clients == DISASTER

    if to.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(to.ghoul2Model) {
        trap_G2API_CleanGhoul2Models(&to.ghoul2Model)
    }
    if from.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(from.ghoul2Model) {
        trap_G2API_DuplicateGhoul2Instance(from.ghoul2Model, &to.ghoul2Model)
    }

    //Don't do this, I guess. Just leave the saber info in the original, so it will be
    //properly initialized.
    /*
    strcpy(to->saberName, from->saberName);
    strcpy(to->saber2Name, from->saber2Name);

    while (i < MAX_SABERS)
    {
    if (to->ghoul2Weapons[i] && trap_G2_HaveWeGhoul2Models(to->ghoul2Weapons[i]))
    {
    trap_G2API_CleanGhoul2Models(&to->ghoul2Weapons[i]);
    }

    WP_SetSaber(to->saber, 0, to->saberName);
    WP_SetSaber(to->saber, 1, to->saber2Name);

    j = 0;

    while (j < MAX_SABERS)
    {
    if (to->saber[j].model[0])
    {
    CG_InitG2SaberData(j, to);
    }
    j++;
    }
    i++;
    }
    */

    to.bolt_head = from.bolt_head
    to.bolt_lhand = from.bolt_lhand
    to.bolt_rhand = from.bolt_rhand
    to.bolt_motion = from.bolt_motion
    to.bolt_llumbar = from.bolt_llumbar

    to.siegeIndex = from.siegeIndex

    // Port-note: Raven's `memcpy( to->sounds, from->sounds, sizeof( to->sounds ) )` runs over bytes that are not one record with a view.
    // Raven wrote: memcpy( to->sounds, from->sounds, sizeof( to->sounds ) )
    portMissing("CG_CopyClientInfoModel", source: "oracle/codemp/cgame/cg_players.c:1211")
    // Port-note: Raven's `memcpy( to->siegeSounds, from->siegeSounds, sizeof( to->siegeSounds ) )` runs over bytes that are not one record with a view.
    // Raven wrote: memcpy( to->siegeSounds, from->siegeSounds, sizeof( to->siegeSounds ) )
    portMissing("CG_CopyClientInfoModel", source: "oracle/codemp/cgame/cg_players.c:1211")
    // Port-note: Raven's `memcpy( to->duelSounds, from->duelSounds, sizeof( to->duelSounds ) )` runs over bytes that are not one record with a view.
    // Raven wrote: memcpy( to->duelSounds, from->duelSounds, sizeof( to->duelSounds ) )
    portMissing("CG_CopyClientInfoModel", source: "oracle/codemp/cgame/cg_players.c:1211")
}

/**
```
======================
CG_ScanForExistingClientInfo
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1288
private func CG_ScanForExistingClientInfo(_ ci: ClientInfo, _ clientNum: Int32) -> Bool {
    var i: Int32
    var match: ClientInfo?

    i = 0
    while i < cgs.maxclients {
        match = cgs.clientinfo[i]
        if !match!.infoValid {
            i += 1
            continue
        }
        if match!.deferred {
            i += 1
            continue
        }
        if Q_stricmp(ci.modelName, match!.modelName) == 0 && Q_stricmp(ci.skinName, match!.skinName) == 0 && Q_stricmp(ci.saberName, match!.saberName) == 0 && Q_stricmp(ci.saber2Name, match!.saber2Name) == 0 && (cgs.gametype < GT_TEAM || ci.team == match!.team) && ci.siegeIndex == match!.siegeIndex && match!.ghoul2Model != nil && match!.bolt_head != 0 {
            // this clientinfo is identical, so use it's handles

            ci.deferred = false

            //rww - Filthy hack. If this is actually the info already belonging to us, just reassign the pointer.
            //Switching instances when not necessary produces small animation glitches.
            //Actually, before, were we even freeing the instance attached to the old clientinfo before copying
            //this new clientinfo over it? Could be a nasty leak possibility. (though this should remedy it in theory)
            if clientNum == i {
                if match!.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(match!.ghoul2Model) {
                    //The match has a valid instance (if it didn't, we'd probably already be fudged (^_^) at this state)
                    if ci.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci.ghoul2Model) {
                        //First kill the copy we have if we have one. (but it should be null)
                        trap_G2API_CleanGhoul2Models(&ci.ghoul2Model)
                    }

                    ci.headOffset = match!.headOffset
                    //					ci->footsteps = match->footsteps;
                    ci.gender = match!.gender

                    ci.legsModel = match!.legsModel
                    ci.legsSkin = match!.legsSkin
                    ci.torsoModel = match!.torsoModel
                    ci.torsoSkin = match!.torsoSkin
                    ci.modelIcon = match!.modelIcon

                    ci.newAnims = match!.newAnims

                    ci.bolt_head = match!.bolt_head
                    ci.bolt_lhand = match!.bolt_lhand
                    ci.bolt_rhand = match!.bolt_rhand
                    ci.bolt_motion = match!.bolt_motion
                    ci.bolt_llumbar = match!.bolt_llumbar
                    ci.siegeIndex = match!.siegeIndex

                    // Port-note: Raven's `memcpy( ci->sounds, match->sounds, sizeof( ci->sounds ) )` runs over bytes that are not one record with a view.
                    // Raven wrote: memcpy( ci->sounds, match->sounds, sizeof( ci->sounds ) )
                    portMissing("CG_ScanForExistingClientInfo", source: "oracle/codemp/cgame/cg_players.c:1288")
                    // Port-note: Raven's `memcpy( ci->siegeSounds, match->siegeSounds, sizeof( ci->siegeSounds ) )` runs over bytes that are not one record with a view.
                    // Raven wrote: memcpy( ci->siegeSounds, match->siegeSounds, sizeof( ci->siegeSounds ) )
                    portMissing("CG_ScanForExistingClientInfo", source: "oracle/codemp/cgame/cg_players.c:1288")
                    // Port-note: Raven's `memcpy( ci->duelSounds, match->duelSounds, sizeof( ci->duelSounds ) )` runs over bytes that are not one record with a view.
                    // Raven wrote: memcpy( ci->duelSounds, match->duelSounds, sizeof( ci->duelSounds ) )
                    portMissing("CG_ScanForExistingClientInfo", source: "oracle/codemp/cgame/cg_players.c:1288")

                    //We can share this pointer, because it already belongs to this client.
                    //The pointer itself and the ghoul2 instance is never actually changed, just passed between
                    //clientinfo structures.
                    ci.ghoul2Model = match!.ghoul2Model

                    //Don't need to do this I guess, whenever this function is called the saber stuff should
                    //already be taken care of in the new info.
                    /*
                    while (k < MAX_SABERS)
                    {
                    if (match->ghoul2Weapons[k] && match->ghoul2Weapons[k] != ci->ghoul2Weapons[k])
                    {
                    if (ci->ghoul2Weapons[k])
                    {
                    trap_G2API_CleanGhoul2Models(&ci->ghoul2Weapons[k]);
                    }
                    ci->ghoul2Weapons[k] = match->ghoul2Weapons[k];
                    }
                    k++;
                    }
                    */
                }
            } else {
                CG_CopyClientInfoModel(match!, ci)
            }

            return true
        }
        i += 1
    }

    // nothing matches, so defer the load
    return false
}

/**
```
======================
CG_SetDeferredClientInfo

We aren't going to load it now, so grab some other
client's info to use until we have some spare time.
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1397
private func CG_SetDeferredClientInfo(_ ci: ClientInfo) {
    var i: Int32
    var match: ClientInfo?

    // if someone else is already the same models and skins we
    // can just load the client info
    i = 0
    while i < cgs.maxclients {
        match = cgs.clientinfo[i]
        if !match!.infoValid || match!.deferred {
            i += 1
            continue
        }
        if Q_stricmp(ci.skinName, match!.skinName) != 0 || Q_stricmp(ci.modelName, match!.modelName) != 0 || (cgs.gametype >= GT_TEAM && ci.team != match!.team && ci.team != TEAM_SPECTATOR) {
            i += 1
            continue
        }

        /*
        if (Q_stricmp(ci->saberName, match->saberName) ||
        Q_stricmp(ci->saber2Name, match->saber2Name))
        {
        continue;
        }
        */

        // just load the real info cause it uses the same models and skins
        CG_LoadClientInfo(ci)
        return
        i += 1
    }

    // if we are in teamplay, only grab a model if the skin is correct
    if cgs.gametype >= GT_TEAM {
        i = 0
        while i < cgs.maxclients {
            match = cgs.clientinfo[i]
            if !match!.infoValid || match!.deferred {
                i += 1
                continue
            }
            if ci.team != TEAM_SPECTATOR && (Q_stricmp(ci.skinName, match!.skinName) != 0 || (cgs.gametype >= GT_TEAM && ci.team != match!.team)) {
                i += 1
                continue
            }

            /*
            if (Q_stricmp(ci->saberName, match->saberName) ||
            Q_stricmp(ci->saber2Name, match->saber2Name))
            {
            continue;
            }
            */

            ci.deferred = true
            CG_CopyClientInfoModel(match!, ci)
            return
            i += 1
        }
        // load the full model, because we don't ever want to show
        // an improper team skin.  This will cause a hitch for the first
        // player, when the second enters.  Combat shouldn't be going on
        // yet, so it shouldn't matter
        CG_LoadClientInfo(ci)
        return
    }

    // find the first valid clientinfo and grab its stuff
    i = 0
    while i < cgs.maxclients {
        match = cgs.clientinfo[i]
        if !match!.infoValid {
            i += 1
            continue
        }

        /*
        if (Q_stricmp(ci->saberName, match->saberName) ||
        Q_stricmp(ci->saber2Name, match->saber2Name))
        {
        continue;
        }
        */

        if match!.deferred {
            //no deferring off of deferred info. Because I said so.
            i += 1
            continue
        }

        ci.deferred = true
        CG_CopyClientInfoModel(match!, ci)
        return
        i += 1
    }

    // we should never get here...
    //CG_Printf( "CG_SetDeferredClientInfo: no valid clients!\n" );
    //Actually it is possible now because of the unique sabers.

    CG_LoadClientInfo(ci)
}

/// Source: oracle/codemp/cgame/cg_players.c:1503
func CG_NewClientInfo(_ clientNum: Int32, _ entitiesInitialized: Bool) {
    var ci: ClientInfo?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = ClientInfo.scratch { newInfo -> Bool in
        var configstring: String
        var v: String
        // Port-note: A pointer local `char * slash` with no view.
        // Raven wrote: char *slash;
        portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
        var oldGhoul2: OpaquePointer? = nil
        // Port-note: A local `void *[2] oldG2Weapons` the table has no type for.
        // Raven wrote: void *oldG2Weapons[MAX_SABERS];
        portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
        var i: Int32 = 0
        var k: Int32 = 0
        var saberUpdate: [Bool] = [Bool](repeating: false, count: 2)

        ci = cgs.clientinfo[clientNum]

        oldGhoul2 = ci!.ghoul2Model

        while k < MAX_SABERS {
            // Port-note: A read of `oldG2Weapons`, a local the draft left as a hole.
            // Raven wrote: oldG2Weapons[k] = ci->ghoul2Weapons[k]
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            k += 1
        }

        configstring = CG_ConfigString(clientNum + CS_PLAYERS)
        if configstring.isEmpty {
            if ci!.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Model) {
                //clean this stuff up first
                trap_G2API_CleanGhoul2Models(&ci!.ghoul2Model)
            }
            k = 0
            while k < MAX_SABERS {
                if ci!.ghoul2Weapons[k] != nil && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Weapons[k]) {
                    trap_G2API_CleanGhoul2Models(&ci!.ghoul2Weapons[k])
                }
                k += 1
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'ClientInfo?' must be unwrapped to refer to member 'clear' of wrapped base type 'ClientInfo'".
            // Raven wrote: memset( ci, 0, sizeof( *ci ) )
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            return true // player just left
        }

        // build into a temp buffer so the defer checks can use
        // the old value
        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        // isolate the player's name
        v = Info_ValueForKey(configstring, "n")
        Q_strncpyz(&newInfo.nameBuffer, v, 64)

        // colors
        v = Info_ValueForKey(configstring, "c1")
        CG_ColorFromString(v, &newInfo.color1)

        newInfo.icolor1 = atoi(v)

        v = Info_ValueForKey(configstring, "c2")
        CG_ColorFromString(v, &newInfo.color2)

        newInfo.icolor2 = atoi(v)

        // bot skill
        v = Info_ValueForKey(configstring, "skill")
        newInfo.botSkill = atoi(v)

        // handicap
        v = Info_ValueForKey(configstring, "hc")
        newInfo.handicap = atoi(v)

        // wins
        v = Info_ValueForKey(configstring, "w")
        newInfo.wins = atoi(v)

        // losses
        v = Info_ValueForKey(configstring, "l")
        newInfo.losses = atoi(v)

        // team
        v = Info_ValueForKey(configstring, "t")
        newInfo.team = atoi(v)

        //copy team info out to menu
        if clientNum == cg.clientNum {
            trap_Cvar_Set("ui_team", v)
        }

        // team task
        v = Info_ValueForKey(configstring, "tt")
        newInfo.teamTask = atoi(v)

        // team leader
        v = Info_ValueForKey(configstring, "tl")
        newInfo.teamLeader = atoi(v) != 0

        //	v = Info_ValueForKey( configstring, "g_redteam" );
        //	Q_strncpyz(newInfo.redTeam, v, MAX_TEAMNAME);

        //	v = Info_ValueForKey( configstring, "g_blueteam" );
        //	Q_strncpyz(newInfo.blueTeam, v, MAX_TEAMNAME);

        // model
        v = Info_ValueForKey(configstring, "model")
        if cg_forceModel.integer != 0 {
            // forcemodel makes everyone use a single model
            // to prevent load hitches
            var modelStr = CharBuf(64)
            // Port-note: A pointer local `char * skin` with no view.
            // Raven wrote: char *skin;
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")

            strcpy(&modelStr, trap_Cvar_VariableStringBuffer("model", Int32((modelStr).count)))
            // Port-note: A store into `skin`, a local the draft left as a hole.
            // Raven wrote: if ( ( skin = strchr( modelStr, '/' ) ) == NULL) { skin = "default"; } else { *skin++ = 0; }
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            // Port-note: A read of `skin`, a local the draft left as a hole.
            // Raven wrote: Q_strncpyz( newInfo.skinName, skin, sizeof( newInfo.skinName ) )
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            Q_strncpyz(&newInfo.modelNameBuffer, String(modelStr), 64)

            if cgs.gametype >= GT_TEAM {
                // keep skin name
                // Port-note: A store into `slash`, a local the draft left as a hole.
                // Raven wrote: slash = strchr( v, '/' )
                portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
                // Port-note: A read of `slash`, a local the draft left as a hole.
                // Raven wrote: if ( slash ) { Q_strncpyz( newInfo.skinName, slash + 1, sizeof( newInfo.skinName ) ); }
                portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            }
        } else {
            Q_strncpyz(&newInfo.modelNameBuffer, v, 64)

            // Port-note: A store into `slash`, a local the draft left as a hole.
            // Raven wrote: slash = strchr( newInfo.modelName, '/' )
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            // Port-note: A read of `slash`, a local the draft left as a hole.
            // Raven wrote: if ( !slash ) { // modelName didn not include a skin name Q_strncpyz( newInfo.skinName, "default", sizeof( newInfo.skinName ) ); } else { Q_strncpyz( newInfo.skinName, slash + 1, sizeof( newInfo.skinName ) ); // truncate modelName *slash = 0; }
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
        }

        if cgs.gametype == GT_SIEGE {
            //entries only sent in siege mode
            //siege desired team
            v = Info_ValueForKey(configstring, "sdt")
            if !v.isEmpty {
                newInfo.siegeDesiredTeam = atoi(v)
            } else {
                newInfo.siegeDesiredTeam = 0
            }

            //siege classname
            v = Info_ValueForKey(configstring, "siegeclass")
            newInfo.siegeIndex = -1

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SiegeFindClassByName' in scope".
            // Raven wrote: siegeClass_t *siegeClass = BG_SiegeFindClassByName(v);
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")

            // Port-note: A read of `siegeClass`, a local the draft left as a hole.
            // Raven wrote: if (siegeClass) { //See if this class forces a model, if so, then use it. Same for skin. newInfo.siegeIndex = BG_SiegeFindClassIndexByName(v); if (siegeClass->forcedModel[0]) { Q_strncpyz( newInfo.modelName, siegeClass->forcedModel, sizeof( newInfo.modelName ) ); } if (siegeClass->forcedSkin[0]) { Q_strncpyz( newInfo.skinName, siegeClass->forcedSkin, sizeof( newInfo.skinName ) ); } if (siegeClass->hasForcedSaberColor) { newInfo.icolor1 = siegeClass->forcedSaberColor; CG_ColorFromInt( newInfo.icolor1, newInfo.color1 ); } if (siegeClass->hasForcedSaber2Color) { newInfo.icolor2 = siegeClass->forcedSaber2Color; CG_ColorFromInt( newInfo.icolor2, newInfo.color2 ); } }
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
        }

        saberUpdate[0] = false
        saberUpdate[1] = false

        //saber being used
        v = Info_ValueForKey(configstring, "st")

        if Q_stricmp(v, ci!.saberName) != 0 {
            Q_strncpyz(&newInfo.saberNameBuffer, v, 64)
            WP_SetSaber(clientNum, newInfo.saber, 0, newInfo.saberName)
            saberUpdate[0] = true
        } else {
            Q_strncpyz(&newInfo.saberNameBuffer, ci!.saberName, 64)
            newInfo.saber[0].copy(from: ci!.saber[0])
            newInfo.ghoul2Weapons[0] = ci!.ghoul2Weapons[0]
        }

        v = Info_ValueForKey(configstring, "st2")

        if Q_stricmp(v, ci!.saber2Name) != 0 {
            Q_strncpyz(&newInfo.saber2NameBuffer, v, 64)
            WP_SetSaber(clientNum, newInfo.saber, 1, newInfo.saber2Name)
            saberUpdate[1] = true
        } else {
            Q_strncpyz(&newInfo.saber2NameBuffer, ci!.saber2Name, 64)
            newInfo.saber[1].copy(from: ci!.saber[1])
            newInfo.ghoul2Weapons[1] = ci!.ghoul2Weapons[1]
        }

        if saberUpdate[0] || saberUpdate[1] {
            var j: Int32 = 0

            while j < MAX_SABERS {
                if saberUpdate[j] {
                    if !newInfo.saber[j].model.isEmpty {
                        // Port-note: A read of `oldG2Weapons`, a local the draft left as a hole.
                        // Raven wrote: if (oldG2Weapons[j]) { //free the old instance(s) trap_G2API_CleanGhoul2Models(&oldG2Weapons[j]); oldG2Weapons[j] = 0; }
                        portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")

                        CG_InitG2SaberData(j, newInfo)
                    } else {
                        // Port-note: A read of `oldG2Weapons`, a local the draft left as a hole.
                        // Raven wrote: if (oldG2Weapons[j]) { //free the old instance(s) trap_G2API_CleanGhoul2Models(&oldG2Weapons[j]); oldG2Weapons[j] = 0; }
                        portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
                    }

                    cg_entities[clientNum].weapon = 0
                    cg_entities[clientNum].ghoul2weapon = nil //force a refresh
                }
                j += 1
            }
        }

        //Check for any sabers that didn't get set again, if they didn't, then reassign the pointers for the new ci
        k = 0
        while k < MAX_SABERS {
            // Port-note: A read of `oldG2Weapons`, a local the draft left as a hole.
            // Raven wrote: if (oldG2Weapons[k]) { newInfo.ghoul2Weapons[k] = oldG2Weapons[k]; }
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
            k += 1
        }

        //duel team
        v = Info_ValueForKey(configstring, "dt")

        newInfo.duelTeam = atoi(v)

        // force powers
        v = Info_ValueForKey(configstring, "forcepowers")
        Q_strncpyz(&newInfo.forcePowersBuffer, v, 64)

        if cgs.gametype >= GT_TEAM && !cgs.jediVmerc && cgs.gametype != GT_SIEGE {
            //We won't force colors for siege.
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec3_t' (aka 'SIMD3<Float>')".
            // Raven wrote: BG_ValidateSkinForTeam( newInfo.modelName, newInfo.skinName, newInfo.team, newInfo.colorOverride )
            portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
        } else {
            newInfo.colorOverride[2] = 0.0
            newInfo.colorOverride[1] = newInfo.colorOverride[2]
            newInfo.colorOverride[0] = newInfo.colorOverride[1]
        }

        // scan for an existing clientinfo that matches this modelname
        // so we can avoid loading checks if possible
        if !CG_ScanForExistingClientInfo(newInfo, clientNum) {
            // if we are defering loads, just have it pick the first valid
            if cg.snap != nil && cg.snap!.ps.clientNum == clientNum {
                //rww - don't defer your own client info ever
                CG_LoadClientInfo(newInfo)
            } else if cg_deferPlayers.integer != 0 && cgs.gametype != GT_SIEGE && cg_buildScript.integer == 0 && !cg.loading {
                // keep whatever they had if it won't violate team skins
                CG_SetDeferredClientInfo(newInfo)
            } else {
                CG_LoadClientInfo(newInfo)
            }
        }

        // replace whatever was there with the new one
        newInfo.infoValid = true
        if ci!.ghoul2Model != nil && ci!.ghoul2Model != newInfo.ghoul2Model && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Model) {
            //We must kill this instance before we remove our only pointer to it from the cgame.
            //Otherwise we will end up with extra instances all over the place, I think.
            trap_G2API_CleanGhoul2Models(&ci!.ghoul2Model)
        }
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: *ci = newInfo
        portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")

        //force a weapon change anyway, for all clients being rendered to the current client
        while i < MAX_CLIENTS {
            cg_entities[i].ghoul2weapon = nil
            i += 1
        }

        if clientNum != -1 {
            //don't want it using an invalid pointer to share
            trap_G2API_ClearAttachedInstance(clientNum)
        }

        // Check if the ghoul2 model changed in any way.  This is safer than assuming we have a legal cent shile loading info.
        if entitiesInitialized && ci!.ghoul2Model != nil && (oldGhoul2 != ci!.ghoul2Model) {
            // Copy the new ghoul2 model to the centity.
            var anim: Animation?
            let cent: Centity? = cg_entities[clientNum]

            anim = bgHumanoidAnimations[(cg_entities[clientNum].currentState.legsAnim)]

            if anim != nil {
                var flags: Int32 = BONE_ANIM_OVERRIDE_FREEZE
                let firstFrame: Int32 = anim!.firstFrame
                var setFrame: Int32 = -1
                let animSpeed: Float = 50.0 / anim!.frameLerp

                if anim!.loopFrames != -1 {
                    flags = BONE_ANIM_OVERRIDE_LOOP
                }

                if cent!.pe.legs.frame >= anim!.firstFrame && cent!.pe.legs.frame <= (anim!.firstFrame + anim!.numFrames) {
                    setFrame = cent!.pe.legs.frame
                }

                //rww - Set the animation again because it just got reset due to the model change
                trap_G2API_SetBoneAnim(ci!.ghoul2Model, 0, "model_root", firstFrame, anim!.firstFrame + anim!.numFrames, flags, animSpeed, cg.time, Float(setFrame), 150)

                cg_entities[clientNum].currentState.legsAnim = 0
            }

            anim = bgHumanoidAnimations[(cg_entities[clientNum].currentState.torsoAnim)]

            if anim != nil {
                var flags: Int32 = BONE_ANIM_OVERRIDE_FREEZE
                let firstFrame: Int32 = anim!.firstFrame
                var setFrame: Int32 = -1
                let animSpeed: Float = 50.0 / anim!.frameLerp

                if anim!.loopFrames != -1 {
                    flags = BONE_ANIM_OVERRIDE_LOOP
                }

                if cent!.pe.torso.frame >= anim!.firstFrame && cent!.pe.torso.frame <= (anim!.firstFrame + anim!.numFrames) {
                    setFrame = cent!.pe.torso.frame
                }

                //rww - Set the animation again because it just got reset due to the model change
                trap_G2API_SetBoneAnim(ci!.ghoul2Model, 0, "lower_lumbar", firstFrame, anim!.firstFrame + anim!.numFrames, flags, animSpeed, cg.time, Float(setFrame), 150)

                cg_entities[clientNum].currentState.torsoAnim = 0
            }

            if cg_entities[clientNum].ghoul2 != nil && trap_G2_HaveWeGhoul2Models(cg_entities[clientNum].ghoul2) {
                trap_G2API_CleanGhoul2Models(&cg_entities[clientNum].ghoul2)
            }
            trap_G2API_DuplicateGhoul2Instance(ci!.ghoul2Model, &cg_entities[clientNum].ghoul2)

            if clientNum != -1 {
                //Attach the instance to this entity num so we can make use of client-server
                //shared operations if possible.
                trap_G2API_AttachInstanceToEntNum(cg_entities[clientNum].ghoul2, clientNum, false)
            }

            if trap_G2API_AddBolt(cg_entities[clientNum].ghoul2, 0, "face") == -1 {
                //check now to see if we have this bone for setting anims and such
                cg_entities[clientNum].noFace = true
            }

            cg_entities[clientNum].localAnimIndex = CG_G2SkelForModel(cg_entities[clientNum].ghoul2)
            cg_entities[clientNum].eventAnimIndex = CG_G2EvIndexForModel(cg_entities[clientNum].ghoul2, cg_entities[clientNum].localAnimIndex)

            if cg_entities[clientNum].currentState.number != cg.predictedPlayerState.clientNum && cg_entities[clientNum].currentState.weapon == WP_SABER {
                cg_entities[clientNum].weapon = cg_entities[clientNum].currentState.weapon
                if cg_entities[clientNum].ghoul2 != nil && ci!.ghoul2Model != nil {
                    CG_CopyG2WeaponInstance(cg_entities[clientNum], cg_entities[clientNum].currentState.weapon, cg_entities[clientNum].ghoul2)
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
                    // Raven wrote: cg_entities[clientNum].ghoul2weapon = CG_G2WeaponInstance(&cg_entities[clientNum], cg_entities[clientNum].currentState.weapon)
                    portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
                }
                if cg_entities[clientNum].currentState.saberHolstered == 0 {
                    //if not holstered set length and desired length for both blades to full right now.
                    var j: Int32 = 0
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                    // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                    portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                    // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                    portMissing("CG_NewClientInfo", source: "oracle/codemp/cgame/cg_players.c:1503")

                    i = 0
                    while i < MAX_SABERS {
                        j = 0
                        while j < ci!.saber[i].numBlades {
                            ci!.saber[i].blade[j].length = ci!.saber[i].blade[j].lengthMax
                            j += 1
                        }
                        i += 1
                    }
                }
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
======================
CG_ActualLoadDeferredPlayers

Called at the beginning of CG_Player if cgQueueLoad is set.
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1953
func CG_ActualLoadDeferredPlayers() {
    var i: Int32
    var ci: ClientInfo?

    // scan for a deferred player to load
    i = 0
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Slots<ClientInfo>' to type 'ClientInfo'".
    // Raven wrote: ci = cgs.clientinfo
    portMissing("CG_ActualLoadDeferredPlayers", source: "oracle/codemp/cgame/cg_players.c:1953")
    while i < cgs.maxclients {
        if ci!.infoValid && ci!.deferred {
            CG_LoadClientInfo(ci!)
            //			break;
        }
        i += 1
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'ClientInfo?' to expected argument type 'Int'".
        // Raven wrote: ci++
        portMissing("CG_ActualLoadDeferredPlayers", source: "oracle/codemp/cgame/cg_players.c:1953")
    }
}

/**
```
======================
CG_LoadDeferredPlayers

Called each frame when a player is dead
and the scoreboard is up
so deferred players can be loaded
======================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:1976
func CG_LoadDeferredPlayers() {
    cgQueueLoad = true
}

/// Source: oracle/codemp/cgame/cg_players.c:1989
private func _PlayerFootStep(_ origin: JKAShared.vec3_t, _ orientation: Float, _ radius: Float, _ cent: Centity, _ footStepType: JKAShared.footstepType_t) {
    var end = vec3_t()
    var mins = vec3_t(-7, -7, 0)
    var maxs = vec3_t(7, 7, 2)
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var soundType: footstep_t = FOOTSTEP_TOTAL
        var bMark: Bool = false
        var footMarkShader: qhandle_t = 0
        var effectID: Int32 = -1
        //float		alpha;

        // send a trace down from the player to the ground
        end = origin
        end[2] -= FOOTSTEP_DISTANCE

        trap_CM_BoxTrace(trace, origin, end, mins, maxs, 0, MASK_PLAYERSOLID)

        // no shadow if too high
        if trace.fraction >= 1.0 {
            return true
        }

        //check for foot-steppable surface flag
        switch trace.surfaceFlags & MATERIAL_MASK {
        case MATERIAL_MUD:
            bMark = true
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_MUDRUN
            } else {
                soundType = FOOTSTEP_MUDWALK
            }
            effectID = cgs.effects.footstepMud

        case MATERIAL_DIRT:
            bMark = true
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_DIRTRUN
            } else {
                soundType = FOOTSTEP_DIRTWALK
            }
            effectID = cgs.effects.footstepSand

        case MATERIAL_SAND:
            bMark = true
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_SANDRUN
            } else {
                soundType = FOOTSTEP_SANDWALK
            }
            effectID = cgs.effects.footstepSand

        case MATERIAL_SNOW:
            bMark = true
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_SNOWRUN
            } else {
                soundType = FOOTSTEP_SNOWWALK
            }
            effectID = cgs.effects.footstepSnow

        case MATERIAL_SHORTGRASS, MATERIAL_LONGGRASS:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_GRASSRUN
            } else {
                soundType = FOOTSTEP_GRASSWALK
            }

        case MATERIAL_SOLIDMETAL:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_METALRUN
            } else {
                soundType = FOOTSTEP_METALWALK
            }

        case MATERIAL_HOLLOWMETAL:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_PIPERUN
            } else {
                soundType = FOOTSTEP_PIPEWALK
            }

        case MATERIAL_GRAVEL:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_GRAVELRUN
            } else {
                soundType = FOOTSTEP_GRAVELWALK
            }
            effectID = cgs.effects.footstepGravel

        case MATERIAL_CARPET, MATERIAL_FABRIC, MATERIAL_CANVAS, MATERIAL_RUBBER, MATERIAL_PLASTIC:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_RUGRUN
            } else {
                soundType = FOOTSTEP_RUGWALK
            }

        case MATERIAL_SOLIDWOOD, MATERIAL_HOLLOWWOOD:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_WOODRUN
            } else {
                soundType = FOOTSTEP_WOODWALK
            }
            //fall through

        default:
            if footStepType == FOOTSTEP_HEAVY_R || footStepType == FOOTSTEP_HEAVY_L {
                soundType = FOOTSTEP_STONERUN
            } else {
                soundType = FOOTSTEP_STONEWALK
            }
        }
        if soundType < FOOTSTEP_TOTAL {
            // Port-note: Raven passes NULL for the `origin` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("_PlayerFootStep", source: "oracle/codemp/cgame/cg_players.c:1989")
            var scratchOrigin = vec3_t()
            // The SDK also declares `rand`, so the call names the bg module.
            trap_S_StartSound(&scratchOrigin, cent.currentState.clientNum, CHAN_BODY, cgs.media.footsteps[soundType][JKAMP_BG.rand() & 3])
        }

        if cg_footsteps.integer < 4 {
            //debugging - 4 always does footstep effect
            if cg_footsteps.integer < 2 {
                return true
            }
        }

        if effectID != -1 {
            trap_FX_PlayEffectID(effectID, &trace.endpos, &trace.plane.normal, -1, -1)
        }

        if cg_footsteps.integer < 4 {
            //debugging - 4 always does footstep effect
            if !bMark || cg_footsteps.integer < 3 {
                return true
            }
        }

        switch footStepType {
        case FOOTSTEP_HEAVY_R:
            footMarkShader = cgs.media.fshrMarkShader

        case FOOTSTEP_HEAVY_L:
            footMarkShader = cgs.media.fshlMarkShader

        case FOOTSTEP_R:
            footMarkShader = cgs.media.fsrMarkShader

        default:
            footMarkShader = cgs.media.fslMarkShader
        }

        // fade the shadow out with height
        //	alpha = 1.0 - trace.fraction;

        // add the mark as a temporary, so it goes directly to the renderer
        // without taking a spot in the cg_marks array
        if trace.plane.normal[0] != 0 || trace.plane.normal[1] != 0 || trace.plane.normal[2] != 0 {
            CG_ImpactMark(footMarkShader, trace.endpos, trace.plane.normal, orientation, 1, 1, 1, 1.0, false, radius, false)
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:2183
private func CG_PlayerFootsteps(_ cent: Centity, _ footStepType: JKAShared.footstepType_t) {
    if cg_footsteps.integer == 0 {
        return
    }

    //FIXME: make this a feature of NPCs in the NPCs.cfg? Specify a footstep shader, if any?
    if cent.currentState.NPC_class != CLASS_ATST && cent.currentState.NPC_class != CLASS_CLAW && cent.currentState.NPC_class != CLASS_FISH && cent.currentState.NPC_class != CLASS_FLIER2 && cent.currentState.NPC_class != CLASS_GLIDER && cent.currentState.NPC_class != CLASS_INTERROGATOR && cent.currentState.NPC_class != CLASS_MURJJ && cent.currentState.NPC_class != CLASS_PROBE && cent.currentState.NPC_class != CLASS_R2D2 && cent.currentState.NPC_class != CLASS_R5D2 && cent.currentState.NPC_class != CLASS_REMOTE && cent.currentState.NPC_class != CLASS_SEEKER && cent.currentState.NPC_class != CLASS_SENTRY && cent.currentState.NPC_class != CLASS_SWAMP {
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var tempAngles = vec3_t()
            var sideOrigin = vec3_t()
            var footBolt: Int32 = -1

            tempAngles[PITCH] = 0
            tempAngles[YAW] = cent.pe.legs.yawAngle
            tempAngles[ROLL] = 0

            switch footStepType {
            case FOOTSTEP_R, FOOTSTEP_HEAVY_R:
                footBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*r_leg_foot") //cent->gent->footRBolt;

            default:
                footBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*l_leg_foot") //cent->gent->footLBolt;
            }


            //FIXME: get yaw orientation of the foot and use on decal
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
            // Raven wrote: trap_G2API_GetBoltMatrix( cent->ghoul2, 0, footBolt, &boltMatrix, tempAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
            portMissing("CG_PlayerFootsteps", source: "oracle/codemp/cgame/cg_players.c:2183")
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &sideOrigin)
            sideOrigin[2] += 15 //fudge up a bit for coplanar
            _PlayerFootStep(sideOrigin, cent.pe.legs.yawAngle, 6, cent, footStepType)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:2237
func CG_PlayerAnimEventDo(_ cent: Centity, _ animEvent: JKAMP.Animevent) {
    var channel: soundChannel_t = CHAN_AUTO
    var client: ClientInfo? = nil
    var swingSound: qhandle_t = 0
    var spinSound: qhandle_t = 0


    // Port-note: The draft of this statement did not compile, and the compiler wrote "'case' label in a 'switch' must have at least one executable statement".
    // Raven wrote: switch ( animEvent->eventType ) { case AEV_SOUNDCHAN: channel = (soundChannel_t)animEvent->eventData[AED_SOUNDCHANNEL]; case AEV_SOUND: { // are there variations on the sound? const int holdSnd = animEvent->eventData[ AED_SOUNDINDEX_START+Q_irand( 0, animEvent->eventData[AED_SOUND_NUMRANDOMSNDS] ) ]; if ( holdSnd > 0 ) { trap_S_StartSound( NULL, cent->currentState.number, channel, holdSnd ); } } break; case AEV_SABER_SWING: if (cent->currentState.eType == ET_NPC) { client = cent->npcClient; assert(client); } else { client = &cgs.clientinfo[cent->currentState.clientNum]; } if ( client && client->infoValid && client->saber[animEvent->eventData[AED_SABER_SWING_SABERNUM]].swingSound[0] ) {//custom swing sound swingSound = client->saber[0].swingSound[Q_irand(0,2)]; } else { int randomSwing = 1; switch ( animEvent->eventData[AED_SABER_SWING_TYPE] ) { default: case 0://SWING_FAST randomSwing = Q_irand( 1, 3 ); break; case 1://SWING_MEDIUM randomSwing = Q_irand( 4, 6 ); break; case 2://SWING_STRONG randomSwing = Q_irand( 7, 9 ); break; } swingSound = trap_S_RegisterSound(va("sound/weapons/saber/saberhup%i.wav", randomSwing)); } trap_S_StartSound(cent->currentState.pos.trBase, cent->currentState.number, CHAN_AUTO, swingSound ); break; case AEV_SABER_SPIN: if (cent->currentState.eType == ET_NPC) { client = cent->npcClient; assert(client); } else { client = &cgs.clientinfo[cent->currentState.clientNum]; } if ( client && client->infoValid && client->saber[AED_SABER_SPIN_SABERNUM].spinSound ) {//use override spinSound = client->saber[AED_SABER_SPIN_SABERNUM].spinSound; } else { switch ( animEvent->eventData[AED_SABER_SPIN_TYPE] ) { case 0://saberspinoff spinSound = trap_S_RegisterSound( "sound/weapons/saber/saberspinoff.wav" ); break; case 1://saberspin spinSound = trap_S_RegisterSound( "sound/weapons/saber/saberspin.wav" ); break; case 2://saberspin1 spinSound = trap_S_RegisterSound( "sound/weapons/saber/saberspin1.wav" ); break; case 3://saberspin2 spinSound = trap_S_RegisterSound( "sound/weapons/saber/saberspin2.wav" ); break; case 4://saberspin3 spinSound = trap_S_RegisterSound( "sound/weapons/saber/saberspin3.wav" ); break; default://random saberspin1-3 spinSound = trap_S_RegisterSound( va( "sound/weapons/saber/saberspin%d.wav", Q_irand(1,3)) ); break; } } if ( spinSound ) { trap_S_StartSound( NULL, cent->currentState.clientNum, CHAN_AUTO, spinSound ); } break; case AEV_FOOTSTEP: CG_PlayerFootsteps( cent, (footstepType_t)animEvent->eventData[AED_FOOTSTEP_TYPE] ); break; case AEV_EFFECT: #if 0 //SP method //add bolt, play effect if ( animEvent->stringData != NULL && cent && cent->gent && cent->gent->ghoul2.size() ) {//have a bolt name we want to use animEvent->eventData[AED_BOLTINDEX] = gi.G2API_AddBolt( &cent->gent->ghoul2[cent->gent->playerModel], animEvent->stringData ); animEvent->stringData = NULL;//so we don't try to do this again } if ( animEvent->eventData[AED_BOLTINDEX] != -1 ) {//have a bolt we want to play the effect on G_PlayEffect( animEvent->eventData[AED_EFFECTINDEX], cent->gent->playerModel, animEvent->eventData[AED_BOLTINDEX], cent->currentState.clientNum ); } else {//play at origin? FIXME: maybe allow a fwd/rt/up offset? theFxScheduler.PlayEffect( animEvent->eventData[AED_EFFECTINDEX], cent->lerpOrigin, qfalse ); } #else //my method if (animEvent->stringData && animEvent->stringData[0] && cent && cent->ghoul2) { animEvent->eventData[AED_MODELINDEX] = 0; if ( ( Q_stricmpn( "*blade", animEvent->stringData, 6 ) == 0 || Q_stricmp( "*flash", animEvent->stringData ) == 0 ) ) {//must be a weapon, try weapon 0? animEvent->eventData[AED_BOLTINDEX] = trap_G2API_AddBolt( cent->ghoul2, 1, animEvent->stringData ); if ( animEvent->eventData[AED_BOLTINDEX] != -1 ) {//found it! animEvent->eventData[AED_MODELINDEX] = 1; } else {//hmm, just try on the player model, then? animEvent->eventData[AED_BOLTINDEX] = trap_G2API_AddBolt( cent->ghoul2, 0, animEvent->stringData ); } } else { animEvent->eventData[AED_BOLTINDEX] = trap_G2API_AddBolt( cent->ghoul2, 0, animEvent->stringData ); } animEvent->stringData[0] = 0; } if ( animEvent->eventData[AED_BOLTINDEX] != -1 ) { vec3_t lAngles; vec3_t bPoint, bAngle; mdxaBone_t matrix; VectorSet(lAngles, 0, cent->lerpAngles[YAW], 0); trap_G2API_GetBoltMatrix(cent->ghoul2, animEvent->eventData[AED_MODELINDEX], animEvent->eventData[AED_BOLTINDEX], &matrix, lAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale); BG_GiveMeVectorFromMatrix(&matrix, ORIGIN, bPoint); VectorSet(bAngle, 0, 1, 0); trap_FX_PlayEffectID(animEvent->eventData[AED_EFFECTINDEX], bPoint, bAngle, -1, -1); } else { vec3_t bAngle; VectorSet(bAngle, 0, 1, 0); trap_FX_PlayEffectID(animEvent->eventData[AED_EFFECTINDEX], cent->lerpOrigin, bAngle, -1, -1); } #endif break; //Would have to keep track of this on server to for these, it's not worth it. case AEV_FIRE: case AEV_MOVE: break; /* case AEV_FIRE: //add fire event if ( animEvent->eventData[AED_FIRE_ALT] ) { G_AddEvent( cent->gent, EV_ALT_FIRE, 0 ); } else { G_AddEvent( cent->gent, EV_FIRE_WEAPON, 0 ); } break; case AEV_MOVE: //make him jump if ( cent && cent->gent && cent->gent->client ) { if ( cent->gent->client->ps.groundEntityNum != ENTITYNUM_NONE ) {//on something vec3_t fwd, rt, up, angles = {0, cent->gent->client->ps.viewangles[YAW], 0}; AngleVectors( angles, fwd, rt, up ); //FIXME: set or add to velocity? VectorScale( fwd, animEvent->eventData[AED_MOVE_FWD], cent->gent->client->ps.velocity ); VectorMA( cent->gent->client->ps.velocity, animEvent->eventData[AED_MOVE_RT], rt, cent->gent->client->ps.velocity ); VectorMA( cent->gent->client->ps.velocity, animEvent->eventData[AED_MOVE_UP], up, cent->gent->client->ps.velocity ); if ( animEvent->eventData[AED_MOVE_UP] > 0 ) {//a jump cent->gent->client->ps.pm_flags |= PMF_JUMPING; G_AddEvent( cent->gent, EV_JUMP, 0 ); //FIXME: if have force jump, do this? or specify sound in the event data? //cent->gent->client->ps.forceJumpZStart = cent->gent->client->ps.origin[2];//so we don't take damage if we land at same height //G_SoundOnEnt( cent->gent, CHAN_BODY, "sound/weapons/force/jump.wav" ); } } } break; */ default: return; break; }
    portMissing("CG_PlayerAnimEventDo", source: "oracle/codemp/cgame/cg_players.c:2237")
}

/**
```
void CG_PlayerAnimEvents( int animFileIndex, int eventFileIndex, qboolean torso, int oldFrame, int frame, const vec3_t org, int entNum )

play any keyframed sounds - only when start a new frame
This func is called once for legs and once for torso
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:2461
func CG_PlayerAnimEvents(_ animFileIndex: Int32, _ eventFileIndex: Int32, _ torso: Bool, _ oldFrame: Int32, _ frame: Int32, _ entNum: Int32) {
    var i: Int32
    var firstFrame: Int32 = 0
    var lastFrame: Int32 = 0
    var doEvent: Bool = false
    var inSameAnim: Bool = false
    var loopAnim: Bool = false
    var match: Bool = false
    var animBackward: Bool = false
    var animEvents: Animevent? = nil

    if torso {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Slots<Animevent>' to type 'Animevent'".
        // Raven wrote: animEvents = bgAllEvents[eventFileIndex].torsoAnimEvents
        portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")
    } else {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Slots<Animevent>' to type 'Animevent'".
        // Raven wrote: animEvents = bgAllEvents[eventFileIndex].legsAnimEvents
        portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")
    }
    if abs(Float((oldFrame - frame))) > 1 {
        //given a range, see if keyFrame falls in that range
        let oldAnim: Int32
        let anim: Int32
        if torso {
            /*
            if ( cg_reliableAnimSounds.integer > 1 )
            {//more precise, slower
            oldAnim = PM_TorsoAnimForFrame( &g_entities[entNum], oldFrame );
            anim = PM_TorsoAnimForFrame( &g_entities[entNum], frame );
            }
            else
            */
            do {
                //less precise, but faster
                oldAnim = cg_entities[entNum].currentState.torsoAnim
                anim = cg_entities[entNum].nextState.torsoAnim
            }
        } else {
            /*
            if ( cg_reliableAnimSounds.integer > 1 )
            {//more precise, slower
            oldAnim = PM_LegsAnimForFrame( &g_entities[entNum], oldFrame );
            anim = PM_TorsoAnimForFrame( &g_entities[entNum], frame );
            }
            else
            */
            do {
                //less precise, but faster
                oldAnim = cg_entities[entNum].currentState.legsAnim
                anim = cg_entities[entNum].nextState.legsAnim
            }
        }
        if anim != oldAnim {
            //not in same anim
            inSameAnim = false
            //FIXME: we *could* see if the oldFrame was *just about* to play the keyframed sound...
        } else {
            //still in same anim, check for looping anim
            var animation: Animation?

            inSameAnim = true
            animation = bgAllAnims[animFileIndex].animsSlots[anim]
            animBackward = (animation!.frameLerp < 0)
            if animation!.loopFrames != -1 {
                //a looping anim!
                loopAnim = true
                firstFrame = animation!.firstFrame
                lastFrame = animation!.firstFrame + animation!.numFrames
            }
        }
    }

    // Check for anim sound
    i = 0
    while i < MAX_ANIM_EVENTS {
        // Port-note: Raven walks `animEvents[i]` as an array through a `animevent_t *` parameter, and the view holds one record. A Slots ruling is due.
        // Raven wrote: if ( animEvents[i].eventType == AEV_NONE ) // No event, end of list { break; }
        portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")

        match = false
        // Port-note: Raven walks `animEvents[i]` as an array through a `animevent_t *` parameter, and the view holds one record. A Slots ruling is due.
        // Raven wrote: if ( animEvents[i].keyFrame == frame ) {//exact match match = qtrue; } else if ( fabs((float)(oldFrame-frame)) > 1 /*&& cg_reliableAnimSounds.integer*/ ) {//given a range, see if keyFrame falls in that range if ( inSameAnim ) {//if changed anims altogether, sorry, the sound is lost if ( fabs((float)(oldFrame-animEvents[i].keyFrame)) <= 3 || fabs((float)(frame-animEvents[i].keyFrame)) <= 3 ) {//must be at least close to the keyframe if ( animBackward ) {//animation plays backwards if ( oldFrame > animEvents[i].keyFrame && frame < animEvents[i].keyFrame ) {//old to new passed through keyframe match = qtrue; } else if ( loopAnim ) {//hmm, didn't pass through it linearally, see if we looped if ( animEvents[i].keyFrame >= firstFrame && animEvents[i].keyFrame < lastFrame ) {//keyframe is in this anim if ( oldFrame > animEvents[i].keyFrame && frame > oldFrame ) {//old to new passed through keyframe match = qtrue; } } } } else {//anim plays forwards if ( oldFrame < animEvents[i].keyFrame && frame > animEvents[i].keyFrame ) {//old to new passed through keyframe match = qtrue; } else if ( loopAnim ) {//hmm, didn't pass through it linearally, see if we looped if ( animEvents[i].keyFrame >= firstFrame && animEvents[i].keyFrame < lastFrame ) {//keyframe is in this anim if ( oldFrame < animEvents[i].keyFrame && frame < oldFrame ) {//old to new passed through keyframe match = qtrue; } } } } } } }
        portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")
        if match {
            // Port-note: Raven walks `animEvents[i]` as an array through a `animevent_t *` parameter, and the view holds one record. A Slots ruling is due.
            // Raven wrote: switch ( animEvents[i].eventType ) { case AEV_SOUND: case AEV_SOUNDCHAN: // Determine probability of playing sound if (!animEvents[i].eventData[AED_SOUND_PROBABILITY]) // 100% { doEvent = qtrue; } else if (animEvents[i].eventData[AED_SOUND_PROBABILITY] > Q_irand(0, 99) ) { doEvent = qtrue; } break; case AEV_SABER_SWING: // Determine probability of playing sound if (!animEvents[i].eventData[AED_SABER_SWING_PROBABILITY]) // 100% { doEvent = qtrue; } else if (animEvents[i].eventData[AED_SABER_SWING_PROBABILITY] > Q_irand(0, 99) ) { doEvent = qtrue; } break; case AEV_SABER_SPIN: // Determine probability of playing sound if (!animEvents[i].eventData[AED_SABER_SPIN_PROBABILITY]) // 100% { doEvent = qtrue; } else if (animEvents[i].eventData[AED_SABER_SPIN_PROBABILITY] > Q_irand(0, 99) ) { doEvent = qtrue; } break; case AEV_FOOTSTEP: // Determine probability of playing sound if (!animEvents[i].eventData[AED_FOOTSTEP_PROBABILITY]) // 100% { doEvent = qtrue; } else if (animEvents[i].eventData[AED_FOOTSTEP_PROBABILITY] > Q_irand(0, 99) ) { doEvent = qtrue; } break; case AEV_EFFECT: // Determine probability of playing sound if (!animEvents[i].eventData[AED_EFFECT_PROBABILITY]) // 100% { doEvent = qtrue; } else if (animEvents[i].eventData[AED_EFFECT_PROBABILITY] > Q_irand(0, 99) ) { doEvent = qtrue; } break; case AEV_FIRE: // Determine probability of playing sound if (!animEvents[i].eventData[AED_FIRE_PROBABILITY]) // 100% { doEvent = qtrue; } else if (animEvents[i].eventData[AED_FIRE_PROBABILITY] > Q_irand(0, 99) ) { doEvent = qtrue; } break; case AEV_MOVE: doEvent = qtrue; break; default: //doEvent = qfalse;//implicit break; }
            portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")
            // do event
            if doEvent {
                // Port-note: Raven walks `animEvents[i]` as an array through a `animevent_t *` parameter, and the view holds one record. A Slots ruling is due.
                // Raven wrote: CG_PlayerAnimEventDo( &cg_entities[entNum], &animEvents[i] )
                portMissing("CG_PlayerAnimEvents", source: "oracle/codemp/cgame/cg_players.c:2461")
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:2676
func CG_TriggerAnimSounds(_ cent: Centity) {
    //this also sets the lerp frames, so I suggest you keep calling it regardless of if you want anim sounds.
    var curFrame: Int32 = 0
    var currentFrame: Float = 0
    let sFileIndex: Int32


    sFileIndex = cent.eventAnimIndex

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
    // Raven wrote: if (trap_G2API_GetBoneFrame(cent->ghoul2, "model_root", cg.time, &currentFrame, cgs.gameModels, 0)) { // the above may have failed, not sure what to do about it, current frame will be zero in that case curFrame = floor( currentFrame ); }
    portMissing("CG_TriggerAnimSounds", source: "oracle/codemp/cgame/cg_players.c:2676")
    if curFrame != cent.pe.legs.frame {
        CG_PlayerAnimEvents(cent.localAnimIndex, sFileIndex, false, cent.pe.legs.frame, curFrame, cent.currentState.number)
    }
    cent.pe.legs.oldFrame = cent.pe.torso.frame
    cent.pe.legs.frame = curFrame

    if cent.noLumbar {
        //probably a droid or something.
        cent.pe.torso.oldFrame = cent.pe.legs.oldFrame
        cent.pe.torso.frame = cent.pe.legs.frame
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
    // Raven wrote: if (trap_G2API_GetBoneFrame(cent->ghoul2, "lower_lumbar", cg.time, &currentFrame, cgs.gameModels, 0)) { curFrame = floor( currentFrame ); }
    portMissing("CG_TriggerAnimSounds", source: "oracle/codemp/cgame/cg_players.c:2676")
    if curFrame != cent.pe.torso.frame {
        CG_PlayerAnimEvents(cent.localAnimIndex, sFileIndex, true, cent.pe.torso.frame, curFrame, cent.currentState.number)
    }
    cent.pe.torso.oldFrame = cent.pe.torso.frame
    cent.pe.torso.frame = curFrame
    cent.pe.torso.backlerp = 1.0 - (currentFrame - Float(curFrame))
}

/// Source: oracle/codemp/cgame/cg_players.c:2721
func CG_InRoll(_ cent: Centity) -> Bool {
    switch (cent.currentState.legsAnim) {
    case BOTH_GETUP_BROLL_B, BOTH_GETUP_BROLL_F, BOTH_GETUP_BROLL_L, BOTH_GETUP_BROLL_R, BOTH_GETUP_FROLL_B, BOTH_GETUP_FROLL_F, BOTH_GETUP_FROLL_L, BOTH_GETUP_FROLL_R, BOTH_ROLL_F, BOTH_ROLL_B, BOTH_ROLL_R, BOTH_ROLL_L:
        if cent.pe.legs.animationTime > cg.time {
            return true
        }

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_players.c:2746
func CG_InRollAnim(_ cent: Centity) -> Bool {
    switch (cent.currentState.legsAnim) {
    case BOTH_ROLL_F, BOTH_ROLL_B, BOTH_ROLL_R, BOTH_ROLL_L:
        return true

    default:
        break
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_players.c:2768
private func CG_SetLerpFrameAnimation(_ cent: Centity, _ ci: ClientInfo, _ lf: LerpFrame, _ newAnimation: Int32, _ animSpeedMult: Float, _ torsoOnly: Bool, _ flipState: Bool) {
    var anim: Animation?
    var animSpeed: Float = 0
    var flags: Int32 = BONE_ANIM_OVERRIDE_FREEZE
    var oldAnim: Int32 = -1
    var blendTime: Int32 = 100
    let oldSpeed: Float = lf.animationSpeed

    if cent.localAnimIndex > 0 {
        //rockettroopers can't have broken arms, nor can anything else but humanoids
        ci.brokenLimbs = cent.currentState.brokenLimbs
    }

    oldAnim = lf.animationNumber

    lf.animationNumber = newAnimation

    if newAnimation < 0 || newAnimation >= MAX_TOTALANIMATIONS {
        CG_Error("Bad animation number: %i", newAnimation)
    }

    anim = bgAllAnims[cent.localAnimIndex].animsSlots[newAnimation]

    lf.animation = anim
    lf.animationTime = lf.frameTime + abs(anim!.frameLerp)

    if cent.localAnimIndex > 1 && anim!.firstFrame == 0 && anim!.numFrames == 0 {
        //We'll allow this for non-humanoids.
        return
    }

    if cg_debugAnim.integer != 0 && (cg_debugAnim.integer < 0 || cg_debugAnim.integer == cent.currentState.clientNum) {
        if lf == cent.pe.legs {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
            // Raven wrote: CG_Printf( "%d: %d TORSO Anim: %i, '%s'\n", cg.time, cent->currentState.clientNum, newAnimation, GetStringForID(animTable, newAnimation))
            portMissing("CG_SetLerpFrameAnimation", source: "oracle/codemp/cgame/cg_players.c:2768")
        } else {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
            // Raven wrote: CG_Printf( "%d: %d LEGS Anim: %i, '%s'\n", cg.time, cent->currentState.clientNum, newAnimation, GetStringForID(animTable, newAnimation))
            portMissing("CG_SetLerpFrameAnimation", source: "oracle/codemp/cgame/cg_players.c:2768")
        }
    }

    if cent.ghoul2 != nil {
        var resumeFrame: Bool = false
        var beginFrame: Int32 = -1
        let firstFrame: Int32
        let lastFrame: Int32

        animSpeed = 50.0 / anim!.frameLerp
        if lf.animation!.loopFrames != -1 {
            flags = BONE_ANIM_OVERRIDE_LOOP
        }

        if animSpeed < 0 {
            lastFrame = anim!.firstFrame
            firstFrame = anim!.firstFrame + anim!.numFrames
        } else {
            firstFrame = anim!.firstFrame
            lastFrame = anim!.firstFrame + anim!.numFrames
        }

        if cg_animBlend.integer != 0 {
            flags |= BONE_ANIM_BLEND
        }

        if BG_InDeathAnim(newAnimation) {
            flags &= ~BONE_ANIM_BLEND
        } else if oldAnim != -1 && BG_InDeathAnim(oldAnim) {
            flags &= ~BONE_ANIM_BLEND
        }

        if (flags & BONE_ANIM_BLEND) != 0 {
            if BG_FlippingAnim(newAnimation) {
                blendTime = 200
            } else if oldAnim != -1 && (BG_FlippingAnim(oldAnim)) {
                blendTime = 200
            }
        }

        animSpeed *= animSpeedMult

        BG_SaberStartTransAnim(cent.currentState.number, cent.currentState.fireflag, cent.currentState.weapon, newAnimation, &animSpeed, cent.currentState.brokenLimbs)

        if torsoOnly {
            if lf.animationTorsoSpeed != animSpeedMult && newAnimation == oldAnim && flipState == lf.lastFlip {
                //same animation, but changing speed, so we will want to resume off the frame we're on.
                resumeFrame = true
            }
            lf.animationTorsoSpeed = animSpeedMult
        } else {
            if lf.animationSpeed != animSpeedMult && newAnimation == oldAnim && flipState == lf.lastFlip {
                //same animation, but changing speed, so we will want to resume off the frame we're on.
                resumeFrame = true
            }
            lf.animationSpeed = animSpeedMult
        }

        //vehicles may have torso etc but we only want to animate the root bone
        if cent.currentState.NPC_class == CLASS_VEHICLE {
            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "model_root", firstFrame, lastFrame, flags, animSpeed, cg.time, Float(beginFrame), blendTime)
            return
        }

        if torsoOnly && !cent.noLumbar {
            //rww - The guesswork based on the lerp frame figures is usually BS, so I've resorted to a call to get the frame of the bone directly.
            var GBAcFrame: Float = 0
            if resumeFrame {
                //we already checked, and this is the same anim, same flip state, but different speed, so we want to resume with the new speed off of the same frame.
                trap_G2API_GetBoneFrame(cent.ghoul2, "lower_lumbar", cg.time, &GBAcFrame, nil, 0)
                beginFrame = Int32(GBAcFrame)
            }

            //even if resuming, also be sure to check if we are running the same frame on the legs. If so, we want to use their frame no matter what.
            trap_G2API_GetBoneFrame(cent.ghoul2, "model_root", cg.time, &GBAcFrame, nil, 0)

            if (cent.currentState.torsoAnim) == (cent.currentState.legsAnim) && GBAcFrame >= anim!.firstFrame && GBAcFrame <= (anim!.firstFrame + anim!.numFrames) {
                //if the legs are already running this anim, pick up on the exact same frame to avoid the "wobbly spine" problem.
                beginFrame = Int32(GBAcFrame)
            }

            if firstFrame > lastFrame || ci.torsoAnim == newAnimation {
                //don't resume on backwards playing animations.. I guess.
                beginFrame = -1
            }

            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "lower_lumbar", firstFrame, lastFrame, flags, animSpeed, cg.time, Float(beginFrame), blendTime)

            // Update the torso frame with the new animation
            cent.pe.torso.frame = firstFrame

            ci.torsoAnim = newAnimation
        } else {
            if resumeFrame {
                //we already checked, and this is the same anim, same flip state, but different speed, so we want to resume with the new speed off of the same frame.
                var GBAcFrame: Float = 0
                trap_G2API_GetBoneFrame(cent.ghoul2, "model_root", cg.time, &GBAcFrame, nil, 0)
                beginFrame = Int32(GBAcFrame)
            }

            if (beginFrame < firstFrame) || (beginFrame > lastFrame) {
                //out of range, don't use it then.
                beginFrame = -1
            }

            if cent.currentState.torsoAnim == cent.currentState.legsAnim && (ci.legsAnim != newAnimation || oldSpeed != animSpeed) {
                //alright, we are starting an anim on the legs, and that same anim is already playing on the toro, so pick up the frame.
                var GBAcFrame: Float = 0
                let oldBeginFrame: Int32 = beginFrame

                trap_G2API_GetBoneFrame(cent.ghoul2, "lower_lumbar", cg.time, &GBAcFrame, nil, 0)
                beginFrame = Int32(GBAcFrame)
                if (beginFrame < firstFrame) || (beginFrame > lastFrame) {
                    //out of range, don't use it then.
                    beginFrame = oldBeginFrame
                }
            }

            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "model_root", firstFrame, lastFrame, flags, animSpeed, cg.time, Float(beginFrame), blendTime)

            ci.legsAnim = newAnimation
        }

        if cent.localAnimIndex <= 1 && (cent.currentState.torsoAnim) == newAnimation && !cent.noLumbar {
            //make sure we're humanoid before we access the motion bone
            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "Motion", firstFrame, lastFrame, flags, animSpeed, cg.time, Float(beginFrame), blendTime)
        }







        //Only put the arm in a broken pose if the anim is such that we
        //want to allow it.


        //armFirstFrame = armAnim->firstFrame;

        /*
        if (cg_animBlend.integer)
        {
        armFlags |= BONE_ANIM_BLEND;
        }
        */
        //No blend on the broken arm


        //Now set the left arm to "support" the right one


        //rwwFIXMEFIXME: brokenLimbs gets stomped sometimes, but it shouldn't.

        //Warning: Don't remove bones that you've added as bolts unless you want to invalidate your bolt index
        //(well, in theory, I haven't actually run into the problem)

        //want to remove the support bone too then

        //Set the flags and stuff to 0, so that the remove will succeed

        //Now remove it
    }
}

/**
```
===============
CG_FirstAnimFrame

Returns true if the lerpframe is on its first frame of animation.
Otherwise false.

This is used to scale an animation into higher-speed without restarting
the animation before it completes at normal speed, in the case of a looping
animation (such as the leg running anim).
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3144
private func CG_FirstAnimFrame(_ lf: LerpFrame, _ torsoOnly: Bool, _ speedScale: Float) -> Bool {
    if torsoOnly {
        if lf.animationTorsoSpeed == speedScale {
            return false
        }
    } else {
        if lf.animationSpeed == speedScale {
            return false
        }
    }

    //I don't care where it is in the anim now, I am going to pick up from the same bone frame.
    /*
    if (lf->animation->numFrames < 2)
    {
    return qtrue;
    }

    if (lf->animation->firstFrame == lf->frame)
    {
    return qtrue;
    }
    */

    return true
}

/**
```
===============
CG_RunLerpFrame

Sets cg.snap, cg.oldFrame, and cg.backlerp
cg.time should be between oldFrameTime and frameTime after exit
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3185
private func CG_RunLerpFrame(_ cent: Centity, _ ci: ClientInfo, _ lf: LerpFrame, _ flipState: Bool, _ newAnimation: Int32, _ speedScale: Float, _ torsoOnly: Bool) {
    // debugging tool to get no animations
    if cg_animSpeed.integer == 0 {
        lf.backlerp = 0
        lf.frame = Int32(lf.backlerp)
        lf.oldFrame = lf.frame
        return
    }

    // see if the animation sequence is switching
    if cent.currentState.forceFrame != 0 {
        if lf.lastForcedFrame != cent.currentState.forceFrame {
            let flags: Int32 = BONE_ANIM_OVERRIDE_FREEZE | BONE_ANIM_BLEND
            let animSpeed: Float = 1.0
            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "lower_lumbar", cent.currentState.forceFrame, cent.currentState.forceFrame + 1, flags, animSpeed, cg.time, -1, 150)
            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "model_root", cent.currentState.forceFrame, cent.currentState.forceFrame + 1, flags, animSpeed, cg.time, -1, 150)
            trap_G2API_SetBoneAnim(cent.ghoul2, 0, "Motion", cent.currentState.forceFrame, cent.currentState.forceFrame + 1, flags, animSpeed, cg.time, -1, 150)
        }

        lf.lastForcedFrame = cent.currentState.forceFrame

        lf.animationNumber = 0
    } else {
        lf.lastForcedFrame = -1

        if (newAnimation != lf.animationNumber || cent.currentState.brokenLimbs != ci.brokenLimbs || lf.lastFlip != flipState || lf.animation == nil) || (CG_FirstAnimFrame(lf, torsoOnly, speedScale)) {
            CG_SetLerpFrameAnimation(cent, ci, lf, newAnimation, speedScale, torsoOnly, flipState)
        }
    }

    lf.lastFlip = flipState

    if lf.frameTime > cg.time + 200 {
        lf.frameTime = cg.time
    }

    if lf.oldFrameTime > cg.time {
        lf.oldFrameTime = cg.time
    }

    // calculate current lerp value
    if lf.frameTime == lf.oldFrameTime {
        lf.backlerp = 0
    } else {
        lf.backlerp = Float(1.0 - Double(Float((cg.time - lf.oldFrameTime)) / (lf.frameTime - lf.oldFrameTime)))
    }
}

/**
```
===============
CG_ClearLerpFrame
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3243
private func CG_ClearLerpFrame(_ cent: Centity, _ ci: ClientInfo, _ lf: LerpFrame, _ animationNumber: Int32, _ torsoOnly: Bool) {
    lf.oldFrameTime = cg.time
    lf.frameTime = lf.oldFrameTime
    CG_SetLerpFrameAnimation(cent, ci, lf, animationNumber, 1, torsoOnly, false)

    if lf.animation!.frameLerp < 0 {
        //Plays backwards
        lf.frame = (lf.animation!.firstFrame + lf.animation!.numFrames)
        lf.oldFrame = lf.frame
    } else {
        lf.frame = lf.animation!.firstFrame
        lf.oldFrame = lf.frame
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:3267
private func CG_PlayerAnimation(_ cent: Centity, _ legsOld: inout Int32, _ legs: inout Int32, _ legsBackLerp: inout Float, _ torsoOld: inout Int32, _ torso: inout Int32, _ torsoBackLerp: inout Float) {
    var ci: ClientInfo?
    let clientNum: Int32
    var speedScale: Float

    clientNum = cent.currentState.clientNum

    if cg_noPlayerAnims.integer != 0 {
        torso = 0
        torsoOld = torso
        legs = torsoOld
        legsOld = legs
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'PM_RunningAnim' in scope".
    // Raven wrote: if (!PM_RunningAnim(cent->currentState.legsAnim) && !PM_WalkingAnim(cent->currentState.legsAnim)) { //if legs are not in a walking/running anim then just animate at standard speed speedScale = 1.0f; } else if (cent->currentState.forcePowersActive & (1 << FP_RAGE)) { speedScale = 1.3f; } else if (cent->currentState.forcePowersActive & (1 << FP_SPEED)) { speedScale = 1.7f; } else { speedScale = 1.0f; }
    portMissing("CG_PlayerAnimation", source: "oracle/codemp/cgame/cg_players.c:3267")

    if cent.currentState.eType == ET_NPC {
        ci = cent.npcClient
    } else {
        ci = cgs.clientinfo[clientNum]
    }

    CG_RunLerpFrame(cent, ci!, cent.pe.legs, cent.currentState.legsFlip, cent.currentState.legsAnim, speedScale, false)

    if !((cent.currentState.forcePowersActive & (1 << FP_RAGE)) != 0) {
        //don't affect torso anim speed unless raged
        speedScale = 1.0
    } else {
        speedScale = 1.7
    }

    legsOld = cent.pe.legs.oldFrame
    legs = cent.pe.legs.frame
    legsBackLerp = cent.pe.legs.backlerp

    // If this is not a vehicle, you may lerm the frame (since vehicles never have a torso anim). -AReis
    if cent.currentState.NPC_class != CLASS_VEHICLE {
        CG_RunLerpFrame(cent, ci!, cent.pe.torso, cent.currentState.torsoFlip, cent.currentState.torsoAnim, speedScale, true)

        torsoOld = cent.pe.torso.oldFrame
        torso = cent.pe.torso.frame
        torsoBackLerp = cent.pe.torso.backlerp
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:3365
func CG_G2SetBoneAngles(_ ghoul2: OpaquePointer?, _ modelIndex: Int32, _ boneName: String, _ angles: JKAShared.vec3_t, _ flags: Int32, _ up: Int32, _ right: Int32, _ forward: Int32, _ modelList: UnsafeMutablePointer<Int32>?, _ blendTime: Int32, _ currentTime: Int32) {
    //we want to hold off on setting the bone angles until the end of the frame, because every time we set
    //them the entire skeleton has to be reconstructed.
    //This function should ONLY be called from CG_Player() or a function that is called only within CG_Player().
    //At the end of the frame we will check to use this information to call SetBoneAngles



    //We don't want to go with the delayed approach, we want out bolt points and everything to be updated in realtime.
    //We'll just take the reconstructs and live with them.
    trap_G2API_SetBoneAngles(ghoul2, modelIndex, boneName, angles, flags, up, right, forward, modelList, blendTime, currentTime)
}

/**
```
================
CG_Rag_Trace

Variant on CG_Trace. Doesn't trace for ents because ragdoll engine trace code has no entity
trace access. Maybe correct this sometime, so bmodel col. at least works with ragdoll.
But I don't want to slow it down..
================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3407
func CG_Rag_Trace(_ result: JKAMP.Trace, _ start: JKAShared.vec3_t, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ end: JKAShared.vec3_t, _ skipNumber: Int32, _ mask: Int32) {
    trap_CM_BoxTrace(result, start, end, mins!, maxs!, 0, mask)
    result.entityNum = Double(result.fraction) != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE
}

//we want to see which way the pelvis is facing to get a relatively oriented base settling frame
//this is to avoid the arms stretching in opposite directions on the body trying to reach the base
//pose if the pelvis is flipped opposite of the base pose or something -rww
/// Source: oracle/codemp/cgame/cg_players.c:3460
private func CG_RagAnimForPositioning(_ cent: Centity) -> Int32 {
    var bolt: Int32 = 0
    var dir = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return MdxaBone.scratch { matrix -> Int32 in

        bolt = trap_G2API_AddBolt(cent.ghoul2, 0, "pelvis")

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
        // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, bolt, &matrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
        portMissing("CG_RagAnimForPositioning", source: "oracle/codemp/cgame/cg_players.c:3460")
        BG_GiveMeVectorFromMatrix(matrix, NEGATIVE_Z, &dir)

        if dir[2] > 0.0 {
            //facing up
            return BOTH_DEADFLOP2
        } else {
            //facing down
            return BOTH_DEADFLOP1
        }
    }
}

//rww - cgame interface for the ragdoll stuff.
//Returns qtrue if the entity is now in a ragdoll state, otherwise qfalse.
/// Source: oracle/codemp/cgame/cg_players.c:3486
func CG_RagDoll(_ cent: Centity, _ forcedAngles: JKAShared.vec3_t) -> Bool {
    var usedOrg = vec3_t()
    var inSomething: Bool = false
    var ragAnim: Int32 = 0

    if cg_ragDoll.integer == 0 {
        return false
    }

    if cent.localAnimIndex != 0 {
        //don't rag non-humanoids
        return false
    }

    usedOrg = cent.lerpOrigin

    if !cent.isRagging {
        //If we're not in a ragdoll state, perform the checks.
        if (cent.currentState.eFlags & EF_RAG) != 0 {
            //want to go into it no matter what then
            inSomething = true
        } else if cent.currentState.groundEntityNum == ENTITYNUM_NONE {
            var cVel = vec3_t()

            cVel = cent.currentState.pos.trDelta

            if VectorNormalize(&cVel) > 400 {
                //if he's flying through the air at a good enough speed, switch into ragdoll
                inSomething = true
            }
        }

        if cent.currentState.eType == ET_BODY {
            //just rag bodies immediately if their own was ragging on respawn
            if cent.ownerRagging {
                cent.isRagging = true
                return false
            }
        }

        if cg_ragDoll.integer > 1 {
            inSomething = true
        }

        if !inSomething {
            let anim: Int32 = (cent.currentState.legsAnim)
            let dur: Int32 = Int32((bgAllAnims[cent.localAnimIndex].animsSlots[anim].numFrames - 1) * abs(Float((bgAllAnims[cent.localAnimIndex].animsSlots[anim].frameLerp))))
            var i: Int32 = 0
            var boltChecks: [Int32] = [Int32](repeating: 0, count: 5)
            var boltPoints = [vec3_t](repeating: vec3_t(), count: 5)
            var trStart = vec3_t()
            var trEnd = vec3_t()
            var tAng = vec3_t()
            var deathDone: Bool = false
            // Raven's record lives to the end of his block, so the block is the closure.
            Trace.scratch { tr in
                // Raven's record lives to the end of his block, so the block is the closure.
                MdxaBone.scratch { boltMatrix in

                    tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

                    if cent.pe.legs.animationTime > 50 && (cg.time - cent.pe.legs.animationTime) > dur {
                        //Looks like the death anim is done playing
                        deathDone = true
                    }

                    if deathDone {
                        //only trace from the hands if the death anim is already done.
                        boltChecks[0] = trap_G2API_AddBolt(cent.ghoul2, 0, "rhand")
                        boltChecks[1] = trap_G2API_AddBolt(cent.ghoul2, 0, "lhand")
                    } else {
                        //otherwise start the trace loop at the cranium.
                        i = 2
                    }
                    boltChecks[2] = trap_G2API_AddBolt(cent.ghoul2, 0, "cranium")
                    //boltChecks[3] = trap_G2API_AddBolt(cent->ghoul2, 0, "rtarsal");
                    //boltChecks[4] = trap_G2API_AddBolt(cent->ghoul2, 0, "ltarsal");
                    boltChecks[3] = trap_G2API_AddBolt(cent.ghoul2, 0, "rtalus")
                    boltChecks[4] = trap_G2API_AddBolt(cent.ghoul2, 0, "ltalus")

                    //This may seem bad, but since we have a bone cache now it should manage to not be too disgustingly slow.
                    //Do the head first, because the hands reference it anyway.
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                    // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, boltChecks[2], &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltPoints[2])

                    while i < 5 {
                        if i < 2 {
                            //when doing hands, trace to the head instead of origin
                            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, boltChecks[i], &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                            portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltPoints[i])
                            trStart = boltPoints[i]
                            trEnd = boltPoints[2]
                        } else {
                            if i > 2 {
                                //2 is the head, which already has the bolt point.
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                                // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, boltChecks[i], &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                                portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltPoints[i])
                            }
                            trStart = boltPoints[i]
                            trEnd = cent.lerpOrigin
                        }

                        //Now that we have all that sorted out, trace between the two points we desire.
                        CG_Rag_Trace(tr, trStart, nil, nil, trEnd, cent.currentState.number, MASK_SOLID)

                        if Double(tr.fraction) != 1.0 || tr.startsolid != 0 || tr.allsolid != 0 {
                            //Hit something or start in solid, so flag it and break.
                            //This is a slight hack, but if we aren't done with the death anim, we don't really want to
                            //go into ragdoll unless our body has a relatively "flat" pitch.

                            //Check the pitch from the head to the right foot (should be reasonable)

                            inSomething = true
                            break
                        }

                        i += 1
                    }
                }
            }
        }

        if inSomething {
            cent.isRagging = true
        }
    }

    if cent.isRagging {
        //We're in a ragdoll state, so make the call to keep our positions updated and whatnot.
        // Raven's record lives to the end of his block, so the block is the closure.
        // Every path of Raven's block returns, so the closure's value is the function's.
        return SharedRagDollParams.scratch { tParms -> Bool in
            // Raven's record lives to the end of his block, so the block is the closure.
            // Every path of Raven's block returns, so the closure's value is the function's.
            return SharedRagDollUpdateParams.scratch { tuParms -> Bool in

                ragAnim = CG_RagAnimForPositioning(cent)

                if cent.ikStatus {
                    //ik must be reset before ragdoll is started, or you'll get some interesting results.
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "'nil' requires a contextual type".
                    // Raven wrote: trap_G2API_SetBoneIKState(cent->ghoul2, cg.time, NULL, IKS_NONE, NULL)
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    cent.ikStatus = false
                }

                //these will be used as "base" frames for the ragoll settling.
                tParms.startFrame = bgAllAnims[cent.localAnimIndex].animsSlots[ragAnim].firstFrame // + bgAllAnims[cent->localAnimIndex].anims[ragAnim].numFrames;
                tParms.endFrame = bgAllAnims[cent.localAnimIndex].animsSlots[ragAnim].firstFrame + bgAllAnims[cent.localAnimIndex].animsSlots[ragAnim].numFrames


                /*
                if (cg_animBlend.integer)
                {
                flags |= BONE_ANIM_BLEND;
                }
                */

                do {
                    var currentFrame: Float = 0
                    var startFrame: Int32 = 0
                    var endFrame: Int32 = 0
                    var flags: Int32 = 0
                    var animSpeed: Float = 0

                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                    // Raven wrote: if (trap_G2API_GetBoneAnim(cent->ghoul2, "model_root", cg.time, &currentFrame, &startFrame, &endFrame, &flags, &animSpeed, cgs.gameModels, 0)) { //lock the anim on the current frame. int blendTime = 500; animation_t *curAnim = &bgAllAnims[cent->localAnimIndex].anims[cent->currentState.legsAnim]; if (currentFrame >= (curAnim->firstFrame + curAnim->numFrames-1)) { //this is sort of silly but it works for now. currentFrame = (curAnim->firstFrame + curAnim->numFrames-2); } trap_G2API_SetBoneAnim(cent->ghoul2, 0, "lower_lumbar", currentFrame, currentFrame+1, flags, animSpeed,cg.time, currentFrame, blendTime); trap_G2API_SetBoneAnim(cent->ghoul2, 0, "model_root", currentFrame, currentFrame+1, flags, animSpeed, cg.time, currentFrame, blendTime); trap_G2API_SetBoneAnim(cent->ghoul2, 0, "Motion", currentFrame, currentFrame+1, flags, animSpeed, cg.time, currentFrame, blendTime); }
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                }
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                // Raven wrote: CG_G2SetBoneAngles(cent->ghoul2, 0, "upper_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, cgs.gameModels, 0, cg.time)
                portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                // Raven wrote: CG_G2SetBoneAngles(cent->ghoul2, 0, "lower_lumbar", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, cgs.gameModels, 0, cg.time)
                portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                // Raven wrote: CG_G2SetBoneAngles(cent->ghoul2, 0, "thoracic", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, cgs.gameModels, 0, cg.time)
                portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                CG_G2SetBoneAngles(cent.ghoul2, 0, "cervical", vec3_origin, BONE_ANGLES_POSTMULT, POSITIVE_X, NEGATIVE_Y, NEGATIVE_Z, &cgs.gameModels, 0, cg.time)

                tParms.angles = forcedAngles
                tParms.position = usedOrg
                tParms.scale = cent.modelScale
                tParms.me = cent.currentState.number

                tParms.collisionType = 1
                tParms.RagPhase = RP_DEATH_COLLISION
                tParms.fShotStrength = 4

                trap_G2API_SetRagDoll(cent.ghoul2, tParms)

                tuParms.angles = forcedAngles
                tuParms.position = usedOrg
                tuParms.scale = cent.modelScale
                tuParms.me = cent.currentState.number
                tuParms.settleFrame = tParms.endFrame - 1

                if cent.currentState.groundEntityNum != ENTITYNUM_NONE {
                    tuParms.velocity = vec3_t()
                } else {
                    tuParms.velocity = cent.currentState.pos.trDelta * 2.0
                }

                trap_G2API_AnimateG2Models(cent.ghoul2, cg.time, tuParms)

                //So if we try to get a bolt point it's still correct
                cent.pe.legs.yawAngle = forcedAngles[YAW]
                cent.pe.torso.yawAngle = cent.pe.legs.yawAngle
                cent.lerpAngles[YAW] = cent.pe.torso.yawAngle
                cent.turAngles[YAW] = cent.lerpAngles[YAW]

                if cent.currentState.ragAttach != 0 && (cent.currentState.eType != ET_NPC || cent.currentState.NPC_class != CLASS_VEHICLE) {
                    var grabEnt: Centity?

                    if cent.currentState.ragAttach == ENTITYNUM_NONE {
                        //switch cl 0 and entitynum_none, so we can operate on the "if non-0" concept
                        grabEnt = cg_entities[0]
                    } else {
                        grabEnt = cg_entities[cent.currentState.ragAttach]
                    }

                    if grabEnt!.ghoul2 != nil {
                        // Raven's record lives to the end of his block, so the block is the closure.
                        MdxaBone.scratch { matrix in
                            var bOrg = vec3_t()
                            var thisHand = vec3_t()
                            var hands = vec3_t()
                            var pcjMin = vec3_t()
                            var pcjMax = vec3_t()
                            var pDif = vec3_t()
                            var thorPoint = vec3_t()
                            var difLen: Float = 0
                            var thorBolt: Int32 = 0

                            //Get the person who is holding our hand's hand location
                            trap_G2API_GetBoltMatrix(grabEnt!.ghoul2, 0, 0, matrix, grabEnt!.turAngles, grabEnt!.lerpOrigin, cg.time, &cgs.gameModels, &grabEnt!.modelScale)
                            BG_GiveMeVectorFromMatrix(matrix, ORIGIN, &bOrg)

                            //Get our hand's location
                            trap_G2API_GetBoltMatrix(cent.ghoul2, 0, 0, matrix, cent.turAngles, cent.lerpOrigin, cg.time, &cgs.gameModels, &cent.modelScale)
                            BG_GiveMeVectorFromMatrix(matrix, ORIGIN, &thisHand)

                            //Get the position of the thoracic bone for hinting its velocity later on
                            thorBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "thoracic")
                            trap_G2API_GetBoltMatrix(cent.ghoul2, 0, thorBolt, matrix, cent.turAngles, cent.lerpOrigin, cg.time, &cgs.gameModels, &cent.modelScale)
                            BG_GiveMeVectorFromMatrix(matrix, ORIGIN, &thorPoint)

                            hands = bOrg - thisHand

                            if VectorLength(hands) < 3.0 {
                                trap_G2API_RagForceSolve(cent.ghoul2, false)
                            } else {
                                trap_G2API_RagForceSolve(cent.ghoul2, true)
                            }

                            //got the hand pos of him, now we want to make our hand go to it
                            trap_G2API_RagEffectorGoal(cent.ghoul2, "rhand", &bOrg)
                            trap_G2API_RagEffectorGoal(cent.ghoul2, "rradius", &bOrg)
                            trap_G2API_RagEffectorGoal(cent.ghoul2, "rradiusX", &bOrg)
                            trap_G2API_RagEffectorGoal(cent.ghoul2, "rhumerusX", &bOrg)
                            trap_G2API_RagEffectorGoal(cent.ghoul2, "rhumerus", &bOrg)

                            //Make these two solve quickly so we can update decently
                            trap_G2API_RagPCJGradientSpeed(cent.ghoul2, "rhumerus", 1.5)
                            trap_G2API_RagPCJGradientSpeed(cent.ghoul2, "rradius", 1.5)

                            //Break the constraints on them I suppose
                            pcjMin = vec3_t(-999, -999, -999)
                            pcjMax = vec3_t(999, 999, 999)
                            trap_G2API_RagPCJConstraint(cent.ghoul2, "rhumerus", &pcjMin, &pcjMax)
                            trap_G2API_RagPCJConstraint(cent.ghoul2, "rradius", &pcjMin, &pcjMax)

                            cent.overridingBones = cg.time + 2000

                            //hit the thoracic velocity to the hand point
                            hands = bOrg - thorPoint
                            VectorNormalize(&hands)
                            hands = hands * 2048.0
                            trap_G2API_RagEffectorKick(cent.ghoul2, "thoracic", &hands)
                            trap_G2API_RagEffectorKick(cent.ghoul2, "ceyebrow", &hands)

                            pDif = cent.ragLastOrigin - cent.lerpOrigin
                            cent.ragLastOrigin = cent.lerpOrigin

                            if cent.ragLastOriginTime >= cg.time && cent.currentState.groundEntityNum != ENTITYNUM_NONE {
                                //make sure it's reasonably updated
                                difLen = VectorLength(pDif)
                                if difLen > 0.0 {
                                    //if we're being dragged, then kick all the bones around a bit
                                    var dVel = vec3_t()
                                    var rVel = vec3_t()
                                    var i: Int32 = 0

                                    if difLen < 12.0 {
                                        pDif = pDif * (12.0 / difLen)
                                        difLen = 12.0
                                    }

                                    while cg_effectorStringTable[i] != nil {
                                        dVel = pDif
                                        dVel[2] = 0

                                        //Factor in a random velocity
                                        rVel = vec3_t(flrand(-0.1, 0.1), flrand(-0.1, 0.1), flrand(0.1, 0.5))
                                        rVel = rVel * 8.0

                                        dVel = dVel + rVel
                                        dVel = dVel * 10.0

                                        trap_G2API_RagEffectorKick(cent.ghoul2, cg_effectorStringTable[i], &dVel)





                                        i += 1
                                    }
                                }
                            }
                            cent.ragLastOriginTime = cg.time + 1000
                        }
                    }
                } else if cent.overridingBones != 0 {
                    //reset things to their normal rag state
                    var pcjMin = vec3_t()
                    var pcjMax = vec3_t()
                    var dVel = vec3_t()

                    //got the hand pos of him, now we want to make our hand go to it
                    // Port-note: Raven passes NULL for the `pos` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    var scratchPos = vec3_t()
                    trap_G2API_RagEffectorGoal(cent.ghoul2, "rhand", &scratchPos)
                    // Port-note: Raven passes NULL for the `pos` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    var scratchPos2 = vec3_t()
                    trap_G2API_RagEffectorGoal(cent.ghoul2, "rradius", &scratchPos2)
                    // Port-note: Raven passes NULL for the `pos` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    var scratchPos3 = vec3_t()
                    trap_G2API_RagEffectorGoal(cent.ghoul2, "rradiusX", &scratchPos3)
                    // Port-note: Raven passes NULL for the `pos` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    var scratchPos4 = vec3_t()
                    trap_G2API_RagEffectorGoal(cent.ghoul2, "rhumerusX", &scratchPos4)
                    // Port-note: Raven passes NULL for the `pos` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_RagDoll", source: "oracle/codemp/cgame/cg_players.c:3486")
                    var scratchPos5 = vec3_t()
                    trap_G2API_RagEffectorGoal(cent.ghoul2, "rhumerus", &scratchPos5)

                    dVel = vec3_t(0.0, 0.0, -64.0)
                    trap_G2API_RagEffectorKick(cent.ghoul2, "rhand", &dVel)

                    trap_G2API_RagPCJGradientSpeed(cent.ghoul2, "rhumerus", 0.0)
                    trap_G2API_RagPCJGradientSpeed(cent.ghoul2, "rradius", 0.0)

                    pcjMin = vec3_t(-100.0, -40.0, -15.0)
                    pcjMax = vec3_t(-15.0, 80.0, 15.0)
                    trap_G2API_RagPCJConstraint(cent.ghoul2, "rhumerus", &pcjMin, &pcjMax)

                    pcjMin = vec3_t(-25.0, -20.0, -20.0)
                    pcjMax = vec3_t(90.0, 20.0, -20.0)
                    trap_G2API_RagPCJConstraint(cent.ghoul2, "rradius", &pcjMin, &pcjMax)

                    if cent.overridingBones < cg.time {
                        trap_G2API_RagForceSolve(cent.ghoul2, false)
                        cent.overridingBones = 0
                    } else {
                        trap_G2API_RagForceSolve(cent.ghoul2, true)
                    }
                }

                return true
            }
        }
    }

    return false
}

//set the bone angles of this client entity based on data from the server -rww
/// Source: oracle/codemp/cgame/cg_players.c:3914
func CG_G2ServerBoneAngles(_ cent: Centity) {
    var i: Int32 = 0
    var bone: Int32 = cent.currentState.boneIndex1
    var flags: Int32
    var up: Int32
    var right: Int32
    var forward: Int32
    var boneAngles = vec3_t()

    boneAngles = cent.currentState.boneAngles1

    while i < 4 {
        //cycle through the 4 bone index values on the entstate
        if bone != 0 {
            //if it's non-0 then it could have something in it.
            let boneName: String = CG_ConfigString(CS_G2BONES + bone)

            if !boneName.isEmpty {
                //got the bone, now set the angles from the corresponding entitystate boneangles value.
                flags = BONE_ANGLES_POSTMULT

                //get the orientation out of our bit field
                forward = (cent.currentState.boneOrient) & 7 //3 bits from bit 0
                right = (cent.currentState.boneOrient >> 3) & 7 //3 bits from bit 3
                up = (cent.currentState.boneOrient >> 6) & 7 //3 bits from bit 6

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                // Raven wrote: trap_G2API_SetBoneAngles(cent->ghoul2, 0, boneName, boneAngles, flags, up, right, forward, cgs.gameModels, 100, cg.time)
                portMissing("CG_G2ServerBoneAngles", source: "oracle/codemp/cgame/cg_players.c:3914")
            }
        }

        switch i {
        case 0:
            bone = cent.currentState.boneIndex2
            boneAngles = cent.currentState.boneAngles2

        case 1:
            bone = cent.currentState.boneIndex3
            boneAngles = cent.currentState.boneAngles3

        case 2:
            bone = cent.currentState.boneIndex4
            boneAngles = cent.currentState.boneAngles4

        default:
            break
        }

        i += 1
    }
}

/**
```
-------------------------
CG_G2SetHeadBlink
-------------------------
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:3969
private func CG_G2SetHeadBlink(_ cent: Centity, _ bStart: Bool) {
    var desiredAngles = vec3_t()
    var blendTime: Int32 = 80
    var bWink: Bool = false
    let hReye: Int32 = trap_G2API_AddBolt(cent.ghoul2, 0, "reye")
    let hLeye: Int32 = trap_G2API_AddBolt(cent.ghoul2, 0, "leye")

    if hLeye == -1 {
        return
    }

    desiredAngles = vec3_t()

    if bStart {
        desiredAngles[YAW] = -50
        // The SDK also declares `random`, so the call names the bg module.
        if JKAMP_BG.random() > 0.95 {
            bWink = true
            blendTime /= 3
        }
    }
    trap_G2API_SetBoneAngles(cent.ghoul2, 0, "leye", desiredAngles, BONE_ANGLES_POSTMULT, POSITIVE_Y, POSITIVE_Z, POSITIVE_X, nil, blendTime, cg.time)

    if hReye == -1 {
        return
    }

    if !bWink {
        trap_G2API_SetBoneAngles(cent.ghoul2, 0, "reye", desiredAngles, BONE_ANGLES_POSTMULT, POSITIVE_Y, POSITIVE_Z, POSITIVE_X, nil, blendTime, cg.time)
    }
}

/**
```
-------------------------
CG_G2SetHeadAnims
-------------------------
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4013
private func CG_G2SetHeadAnim(_ cent: Centity, _ anim: Int32) {
    let blendTime: Int32 = 50
    let animations: Slots<Animation> = bgAllAnims[cent.localAnimIndex].animsSlots
    var animFlags: Int32 = BONE_ANIM_OVERRIDE
    // animSpeed is 1.0 if the frameLerp (ms/frame) is 50 (20 fps).
    //	float		timeScaleMod = (cg_timescale.value&&gent&&gent->s.clientNum==0&&!player_locked&&!MatrixMode&&gent->client->ps.forcePowersActive&(1<<FP_SPEED))?(1.0/cg_timescale.value):1.0;
    let timeScaleMod: Float = Float(Double(cg_timescale.value) != 0 ? (1.0 / Double(cg_timescale.value)) : 1.0)
    let animSpeed: Float = 50.0 / animations[anim].frameLerp * timeScaleMod
    let firstFrame: Int32
    let lastFrame: Int32

    if animations[anim].numFrames <= 0 {
        return
    }
    if anim == FACE_DEAD {
        animFlags |= BONE_ANIM_OVERRIDE_FREEZE
    }
    // animSpeed is 1.0 if the frameLerp (ms/frame) is 50 (20 fps).
    if animSpeed < 0 {
        //play anim backwards

        lastFrame = animations[anim].firstFrame - 1
        firstFrame = (animations[anim].numFrames - 1) + animations[anim].firstFrame
    } else {
        firstFrame = animations[anim].firstFrame
        lastFrame = (animations[anim].numFrames) + animations[anim].firstFrame
    }

    // first decide if we are doing an animation on the head already
    //	int startFrame, endFrame;
    //	const qboolean animatingHead =  gi.G2API_GetAnimRangeIndex(&gent->ghoul2[gent->playerModel], cent->gent->faceBone, &startFrame, &endFrame);

    //	if (!animatingHead || ( animations[anim].firstFrame != startFrame ) )// only set the anim if we aren't going to do the same animation again
    do {
        //	gi.G2API_SetBoneAnimIndex(&gent->ghoul2[gent->playerModel], cent->gent->faceBone,
        //		firstFrame, lastFrame, animFlags, animSpeed, cg.time, -1, blendTime);
        trap_G2API_SetBoneAnim(cent.ghoul2, 0, "face", firstFrame, lastFrame, animFlags, animSpeed, cg.time, -1, blendTime)
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:4059
func CG_G2PlayerHeadAnims(_ cent: Centity) -> Bool {
    var ci: ClientInfo? = nil
    var anim: Int32 = -1
    var voiceVolume: Int32 = 0

    if cent.localAnimIndex > 1 {
        //only do this for humanoids
        return false
    }

    if cent.noFace {
        // i don't have a face
        return false
    }

    if cent.currentState.number < MAX_CLIENTS {
        ci = cgs.clientinfo[cent.currentState.number]
    } else {
        ci = cent.npcClient
    }

    if ci == nil {
        return false
    }

    if (cent.currentState.eFlags & EF_DEAD) != 0 {
        //Dead people close their eyes and don't make faces!
        anim = FACE_DEAD
        ci!.facial_blink = -1
    } else {
        if ci!.facial_blink == 0 {
            // set the timers
            ci!.facial_blink = cg.time + flrand(4000.0, 8000.0)
            ci!.facial_frown = cg.time + flrand(6000.0, 10000.0)
            ci!.facial_aux = cg.time + flrand(6000.0, 10000.0)
        }

        //are we blinking?
        if ci!.facial_blink < 0 {
            // yes, check if we are we done blinking ?
            if -(ci!.facial_blink) < cg.time {
                // yes, so reset blink timer
                ci!.facial_blink = cg.time + flrand(4000.0, 8000.0)
                CG_G2SetHeadBlink(cent, false) //stop the blink
            }
        } else {
            if ci!.facial_blink < cg.time {
                CG_G2SetHeadBlink(cent, true)
                if ci!.facial_blink == 1 {
                    //requested to stay shut by SET_FACEEYESCLOSED
                    ci!.facial_blink = -(cg.time + 99999999.0) // set blink timer
                } else {
                    ci!.facial_blink = -(cg.time + 300.0) // set blink timer
                }
            }
        }

        voiceVolume = trap_S_GetVoiceVolume(cent.currentState.number)

        if voiceVolume > 0 {
            anim = FACE_TALK1 + voiceVolume - 1
        } else if voiceVolume == 0 {
            //not talking
            if ci!.facial_aux < 0 {
                //yes
                if -(ci!.facial_aux) < cg.time {
                    // yes, reset aux timer
                    ci!.facial_aux = cg.time + flrand(7000.0, 10000.0)
                } else {
                    // not yet, so choose aux
                    anim = FACE_ALERT
                }
            } else {
                // but should we start ?
                if ci!.facial_aux < cg.time {
                    //yes
                    anim = FACE_ALERT
                    // set aux timer
                    ci!.facial_aux = Float(-(Double(cg.time) + 2000.0))
                }
            }

            if anim != -1 {
                if ci!.facial_frown < 0 {
                    // yes,
                    if -(ci!.facial_frown) < cg.time {
                        // yes, reset frown timer
                        ci!.facial_frown = cg.time + flrand(7000.0, 10000.0)
                    } else {
                        // not yet, so choose frown
                        anim = FACE_FROWN
                    }
                } else {
                    // but should we start ?
                    if ci!.facial_frown < cg.time {
                        anim = FACE_FROWN
                        // set frown timer
                        ci!.facial_frown = Float(-(Double(cg.time) + 2000.0))
                    }
                }
            }
        }
    }
    if anim != -1 {
        CG_G2SetHeadAnim(cent, anim)
        return true
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_players.c:4192
private func CG_G2PlayerAngles(_ cent: Centity, _ legs: inout [JKAShared.vec3_t], _ legsAngles: inout JKAShared.vec3_t) {
    var ci: ClientInfo?

    //rww - now do ragdoll stuff
    if (cent.currentState.eFlags & EF_DEAD) != 0 || (cent.currentState.eFlags & EF_RAG) != 0 {
        var forcedAngles = vec3_t()

        forcedAngles = vec3_t()
        forcedAngles[YAW] = cent.lerpAngles[YAW]

        if CG_RagDoll(cent, forcedAngles) {
            //if we managed to go into the rag state, give our ent axis the forced angles and return.
            AnglesToAxis(forcedAngles, &legs)
            legsAngles = forcedAngles
            return
        }
    } else if cent.isRagging {
        cent.isRagging = false
        trap_G2API_SetRagDoll(cent.ghoul2, nil) //calling with null parms resets to no ragdoll.
    }

    if cent.currentState.eType == ET_NPC {
        ci = cent.npcClient
    } else {
        ci = cgs.clientinfo[cent.currentState.number]
    }

    //rww - Quite possibly the most arguments for a function ever.
    if cent.localAnimIndex <= 1 {
        //don't do these things on non-humanoids
        var lookAngles = vec3_t()
        var emplaced: EntityState? = nil

        if cent.currentState.hasLookTarget {
            lookAngles = cg_entities[cent.currentState.lookTarget].lerpOrigin - cent.lerpOrigin
            vectoangles(lookAngles, &lookAngles)
            ci!.lookTime = cg.time + 1000
        } else {
            lookAngles = cent.lerpAngles
        }
        lookAngles[PITCH] = 0

        if cent.currentState.otherEntityNum2 != 0 {
            emplaced = cg_entities[cent.currentState.otherEntityNum2].currentState
        }

        BG_G2PlayerAngles(cent.ghoul2, ci!.bolt_motion, cent.currentState, cg.time, &cent.lerpOrigin, &cent.lerpAngles, &legs, &legsAngles, &cent.pe.torso.yawing, &cent.pe.torso.pitching, &cent.pe.legs.yawing, &cent.pe.torso.yawAngle, &cent.pe.torso.pitchAngle, &cent.pe.legs.yawAngle, cg.frametime, &cent.turAngles, &cent.modelScale, ci!.legsAnim, ci!.torsoAnim, &ci!.corrTime, &lookAngles, &ci!.lastHeadAngles, ci!.lookTime, emplaced, &ci!.superSmoothTime)

        if cent.currentState.heldByClient != 0 && cent.currentState.heldByClient <= MAX_CLIENTS {
            //then put our arm in this client's hand
            //is index+1 because index 0 is valid.
            let heldByIndex: Int32 = cent.currentState.heldByClient - 1
            let other: Centity? = cg_entities[heldByIndex]

            if other != nil && other!.ghoul2 != nil && ci!.bolt_lhand != 0 {
                // Raven's record lives to the end of his block, so the block is the closure.
                MdxaBone.scratch { boltMatrix in
                    var boltOrg = vec3_t()

                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                    // Raven wrote: trap_G2API_GetBoltMatrix(other->ghoul2, 0, ci->bolt_lhand, &boltMatrix, other->turAngles, other->lerpOrigin, cg.time, cgs.gameModels, other->modelScale)
                    portMissing("CG_G2PlayerAngles", source: "oracle/codemp/cgame/cg_players.c:4192")
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltOrg)

                    BG_IK_MoveArm(cent.ghoul2, ci!.bolt_lhand, cg.time, cent.currentState, cent.currentState.torsoAnim, &boltOrg, &cent.ikStatus, &cent.lerpOrigin, &cent.lerpAngles, &cent.modelScale, 500, false)
                }
            }
        } else if cent.ikStatus {
            //make sure we aren't IKing if we don't have anyone to hold onto us.
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot pass immutable value as inout argument: 'vec3_origin' is a 'let' constant".
            // Raven wrote: BG_IK_MoveArm(cent->ghoul2, ci->bolt_lhand, cg.time, &cent->currentState, cent->currentState.torsoAnim/*BOTH_DEAD1*/, vec3_origin, &cent->ikStatus, cent->lerpOrigin, cent->lerpAngles, cent->modelScale, 500, qtrue)
            portMissing("CG_G2PlayerAngles", source: "oracle/codemp/cgame/cg_players.c:4192")
        }
    } else if cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo!.type == VH_WALKER {
        var lookAngles = vec3_t()

        legsAngles = cent.lerpAngles
        legsAngles[PITCH] = 0
        AnglesToAxis(legsAngles, &legs)

        lookAngles = cent.lerpAngles
        lookAngles[ROLL] = 0
        lookAngles[YAW] = lookAngles[ROLL]

        BG_G2ATSTAngles(cent.ghoul2, cg.time, &lookAngles)
    } else {
        if cent.currentState.eType == ET_NPC && cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
            //fighters actually want to take pitch and roll into account for the axial angles
            legsAngles = cent.lerpAngles
            AnglesToAxis(legsAngles, &legs)
        } else if cent.currentState.eType == ET_NPC && cent.currentState.m_iVehicleNum != 0 && cent.currentState.NPC_class != CLASS_VEHICLE {
            //an NPC bolted to a vehicle should use the full angles
            legsAngles = cent.lerpAngles
            AnglesToAxis(legsAngles, &legs)
        } else {
            var nhAngles = vec3_t()

            if cent.currentState.eType == ET_NPC && cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo!.type == VH_SPEEDER {
                //yeah, a hack, sorry.
                nhAngles = vec3_t(0, cent.lerpAngles[YAW], cent.lerpAngles[ROLL])
            } else {
                nhAngles = vec3_t(0, cent.lerpAngles[YAW], 0)
            }
            AnglesToAxis(nhAngles, &legs)
        }
    }

    //See if we have any bone angles sent from the server
    CG_G2ServerBoneAngles(cent)
}

/**
```
===============
CG_PlayerFlag
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4367
private func CG_PlayerFlag(_ cent: Centity, _ hModel: JKAShared.qhandle_t) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { ent -> Bool in
        var angles = vec3_t()
        var axis = [vec3_t](repeating: vec3_t(), count: 3)
        var boltOrg = vec3_t()
        var tAng = vec3_t()
        var getAng = vec3_t()
        var right = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = MdxaBone.scratch { boltMatrix -> Bool in
            var ci: ClientInfo?

            if cent.currentState.number == cg.snap!.ps.clientNum && !cg.renderingThirdPerson {
                return true
            }

            if cent.ghoul2 == nil {
                return true
            }

            if cent.currentState.eType == ET_NPC {
                ci = cent.npcClient
            } else {
                ci = cgs.clientinfo[cent.currentState.number]
            }

            tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_llumbar, &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
            portMissing("CG_PlayerFlag", source: "oracle/codemp/cgame/cg_players.c:4367")
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltOrg)

            BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_X, &tAng)
            vectoangles(tAng, &tAng)

            angles = cent.lerpAngles

            boltOrg[2] -= 12
            getAng = vec3_t(0, cent.lerpAngles[1], 0)
            // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("CG_PlayerFlag", source: "oracle/codemp/cgame/cg_players.c:4367")
            var scratchForward = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("CG_PlayerFlag", source: "oracle/codemp/cgame/cg_players.c:4367")
            var scratchUp = vec3_t()
            AngleVectors(getAng, &scratchForward, &right, &scratchUp)
            boltOrg[0] += right[0] * 8
            boltOrg[1] += right[1] * 8
            boltOrg[2] += right[2] * 8

            angles[PITCH] = -cent.lerpAngles[PITCH] / 2 - 30
            angles[YAW] = tAng[YAW] + 270

            AnglesToAxis(angles, &axis)

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
            _VectorMA(boltOrg, 24, axis[0], &ent.origin)

            angles[ROLL] += 20
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
            // Raven wrote: AnglesToAxis( angles, ent.axis )
            portMissing("CG_PlayerFlag", source: "oracle/codemp/cgame/cg_players.c:4367")

            ent.hModel = hModel

            ent.modelScale[0] = 0.5
            ent.modelScale[1] = 0.5
            ent.modelScale[2] = 0.5
            ScaleModelAxis(ent)

            /*
            if (cent->currentState.number == cg.snap->ps.clientNum)
            { //If we're the current client (in third person), render the flag on our back transparently
            ent.renderfx |= RF_FORCE_ENT_ALPHA;
            ent.shaderRGBA[3] = 100;
            }
            */
            //FIXME: Not doing this at the moment because sorting totally messes up

            trap_R_AddRefEntityToScene(ent)
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===============
CG_PlayerPowerups
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4449
private func CG_PlayerPowerups(_ cent: Centity, _ torso: JKAMP.RefEntity) {
    let powerups: Int32
    var ci: ClientInfo?

    powerups = cent.currentState.powerups
    if powerups == 0 {
        return
    }

    // quad gives a dlight
    if (powerups & (1 << PW_QUAD)) != 0 {
        // The SDK also declares `rand`, so the call names the bg module.
        trap_R_AddLightToScene(cent.lerpOrigin, Float(200 + (JKAMP_BG.rand() & 31)), 0.2, 0.2, 1)
    }

    if cent.currentState.eType == ET_NPC {
        ci = cent.npcClient
    } else {
        ci = cgs.clientinfo[cent.currentState.clientNum]
    }
    // redflag
    if (powerups & (1 << PW_REDFLAG)) != 0 {
        CG_PlayerFlag(cent, cgs.media.redFlagModel)
        // The SDK also declares `rand`, so the call names the bg module.
        trap_R_AddLightToScene(cent.lerpOrigin, Float(200 + (JKAMP_BG.rand() & 31)), 1.0, 0.2, 0.2)
    }

    // blueflag
    if (powerups & (1 << PW_BLUEFLAG)) != 0 {
        CG_PlayerFlag(cent, cgs.media.blueFlagModel)
        // The SDK also declares `rand`, so the call names the bg module.
        trap_R_AddLightToScene(cent.lerpOrigin, Float(200 + (JKAMP_BG.rand() & 31)), 0.2, 0.2, 1.0)
    }

    // neutralflag
    if (powerups & (1 << PW_NEUTRALFLAG)) != 0 {
        // The SDK also declares `rand`, so the call names the bg module.
        trap_R_AddLightToScene(cent.lerpOrigin, Float(200 + (JKAMP_BG.rand() & 31)), 1.0, 1.0, 1.0)
    }

    // haste leaves smoke trails
    /*
    if ( powerups & ( 1 << PW_HASTE ) ) {
    CG_HasteTrail( cent );
    }
    */
}

/**
```
===============
CG_PlayerFloatSprite

Float a sprite over the player's head
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4505
private func CG_PlayerFloatSprite(_ cent: Centity, _ shader: JKAShared.qhandle_t) {
    var rf: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    RefEntity.scratch { ent in

        if cent.currentState.number == cg.snap!.ps.clientNum && !cg.renderingThirdPerson {
            rf = RF_THIRD_PERSON // only show in mirrors
        } else {
            rf = 0
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
        ent.origin = cent.lerpOrigin
        ent.origin[2] += 48
        ent.reType = RT_SPRITE
        ent.customShader = shader
        ent.radius = 10
        ent.renderfx = rf
        ent.shaderRGBA[0] = 255
        ent.shaderRGBA[1] = 255
        ent.shaderRGBA[2] = 255
        ent.shaderRGBA[3] = 255
        trap_R_AddRefEntityToScene(ent)
    }
}

/**
```
===============
CG_PlayerSprites

Float sprites over the player's head
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4572
private func CG_PlayerSprites(_ cent: Centity) {
    //	int		team;

    if cg.snap != nil && CG_IsMindTricked(cent.currentState.trickedentindex, cent.currentState.trickedentindex2, cent.currentState.trickedentindex3, cent.currentState.trickedentindex4, cg.snap!.ps.clientNum) != 0 {
        return //this entity is mind-tricking the current client, so don't render it
    }

    if (cent.currentState.eFlags & EF_CONNECTION) != 0 {
        CG_PlayerFloatSprite(cent, cgs.media.connectionShader)
        return
    }

    if cent.vChatTime > cg.time {
        CG_PlayerFloatSprite(cent, cgs.media.vchatShader)
    } else if cent.currentState.eType != ET_NPC && (cent.currentState.eFlags & EF_TALK) != 0 {
        CG_PlayerFloatSprite(cent, cgs.media.balloonShader)
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:4612
private func CG_PlayerShadow(_ cent: Centity, _ shadowPlane: inout Float) -> Bool {
    var end = vec3_t()
    var mins = vec3_t(-15, -15, 0)
    var maxs = vec3_t(15, 15, 2)
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var alpha: Float = 0
        var radius: Float = 24.0

        shadowPlane = 0

        if cg_shadows.integer == 0 {
            return false
        }

        // no shadows when cloaked
        if (cent.currentState.powerups & (1 << PW_CLOAKED)) != 0 {
            return false
        }

        if (cent.currentState.eFlags & EF_DEAD) != 0 {
            return false
        }

        if CG_IsMindTricked(cent.currentState.trickedentindex, cent.currentState.trickedentindex2, cent.currentState.trickedentindex3, cent.currentState.trickedentindex4, cg.snap!.ps.clientNum) != 0 {
            return false //this entity is mind-tricking the current client, so don't render it
        }

        if cg_shadows.integer == 1 {
            //dropshadow
            if cent.currentState.m_iVehicleNum != 0 && cent.currentState.NPC_class != CLASS_VEHICLE {
                //riding a vehicle, no dropshadow
                return false
            }
        }
        // send a trace down from the player to the ground
        end = cent.lerpOrigin
        if cg_shadows.integer == 2 {
            //stencil
            end[2] -= 4096.0

            trap_CM_BoxTrace(trace, cent.lerpOrigin, end, mins, maxs, 0, MASK_PLAYERSOLID)

            if Double(trace.fraction) == 1.0 || trace.startsolid != 0 || trace.allsolid != 0 {
                trace.endpos[2] = cent.lerpOrigin[2] - 25.0
            }
        } else {
            end[2] -= SHADOW_DISTANCE

            trap_CM_BoxTrace(trace, cent.lerpOrigin, end, mins, maxs, 0, MASK_PLAYERSOLID)

            // no shadow if too high
            if Double(trace.fraction) == 1.0 || trace.startsolid != 0 || trace.allsolid != 0 {
                return false
            }
        }

        if cg_shadows.integer == 2 {
            //stencil shadows need plane to be on ground
            shadowPlane = trace.endpos[2]
        } else {
            shadowPlane = trace.endpos[2] + 1
        }

        if cg_shadows.integer != 1 {
            // no mark for stencil or projection shadows
            return true
        }

        // fade the shadow out with height
        alpha = Float(1.0 - Double(trace.fraction))

        // bk0101022 - hack / FPE - bogus planes?
        //assert( DotProduct( trace.plane.normal, trace.plane.normal ) != 0.0f )

        // add the mark as a temporary, so it goes directly to the renderer
        // without taking a spot in the cg_marks array
        if cent.currentState.NPC_class == CLASS_REMOTE || cent.currentState.NPC_class == CLASS_SEEKER {
            radius = 8.0
        }
        CG_ImpactMark(cgs.media.shadowMarkShader, trace.endpos, trace.plane.normal, cent.pe.legs.yawAngle, alpha, alpha, alpha, 1, false, radius, true)

        return true
    }
}

/**
```
===============
CG_PlayerSplash

Draw a mark at the water surface
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:4717
private func CG_PlayerSplash(_ cent: Centity) {
    var start = vec3_t()
    var end = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var contents: Int32 = 0
        // Port-note: A local `polyVert_t[4] verts` the table has no type for.
        // Raven wrote: polyVert_t verts[4];
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")

        if cg_shadows.integer == 0 {
            return true
        }

        end = cent.lerpOrigin
        end[2] -= 24

        // if the feet aren't in liquid, don't make a mark
        // this won't handle moving water brushes, but they wouldn't draw right anyway...
        contents = trap_CM_PointContents(end, 0)
        if !((contents & (CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA)) != 0) {
            return true
        }

        start = cent.lerpOrigin
        start[2] += 32

        // if the head isn't out of liquid, don't make a mark
        contents = trap_CM_PointContents(start, 0)
        if (contents & (CONTENTS_SOLID | CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA)) != 0 {
            return true
        }

        // trace down to find the surface
        // Port-note: Raven passes NULL for `mins`, and the callee reads NULL as the zero vector.
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: Raven passes NULL for `maxs`, and the callee reads NULL as the zero vector.
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        trap_CM_BoxTrace(trace, start, end, vec3_origin, vec3_origin, 0, (CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA))

        if Double(trace.fraction) == 1.0 {
            return true
        }

        // create a mark polygon
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: VectorCopy( trace.endpos, verts[0].xyz )
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].xyz[0] -= 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].xyz[1] -= 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].st[0] = 0
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].st[1] = 0
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].modulate[0] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].modulate[1] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].modulate[2] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[0].modulate[3] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")

        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: VectorCopy( trace.endpos, verts[1].xyz )
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].xyz[0] -= 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].xyz[1] += 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].st[0] = 0
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].st[1] = 1
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].modulate[0] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].modulate[1] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].modulate[2] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[1].modulate[3] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")

        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: VectorCopy( trace.endpos, verts[2].xyz )
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].xyz[0] += 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].xyz[1] += 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].st[0] = 1
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].st[1] = 1
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].modulate[0] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].modulate[1] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].modulate[2] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[2].modulate[3] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")

        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: VectorCopy( trace.endpos, verts[3].xyz )
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].xyz[0] += 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].xyz[1] -= 32
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].st[0] = 1
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].st[1] = 0
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].modulate[0] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].modulate[1] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].modulate[2] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: verts[3].modulate[3] = 255
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")

        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: trap_R_AddPolyToScene( cgs.media.wakeMarkShader, 4, verts )
        portMissing("CG_PlayerSplash", source: "oracle/codemp/cgame/cg_players.c:4717")
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:4798
private func CG_ForcePushBlur(_ org: JKAShared.vec3_t, _ cent: Centity?) {
    if cent == nil || cg_renderToTextureFX.integer == 0 {
        var ex: LocalEntity?

        ex = CG_AllocLocalEntity()
        ex!.leType = LE_PUFF
        ex!.refEntity.reType = RT_SPRITE
        ex!.radius = 2.0
        ex!.startTime = cg.time
        ex!.endTime = ex!.startTime + 120
        ex!.pos.trBase = org
        ex!.pos.trTime = cg.time
        ex!.pos.trType = TR_LINEAR
        ex!.pos.trDelta = cg.refdef.viewaxis[1] * 55

        ex!.color[0] = 24
        ex!.color[1] = 32
        ex!.color[2] = 40
        ex!.refEntity.customShader = trap_R_RegisterShader("gfx/effects/forcePush")

        ex = CG_AllocLocalEntity()
        ex!.leType = LE_PUFF
        ex!.refEntity.reType = RT_SPRITE
        ex!.refEntity.rotation = 180.0
        ex!.radius = 2.0
        ex!.startTime = cg.time
        ex!.endTime = ex!.startTime + 120
        ex!.pos.trBase = org
        ex!.pos.trTime = cg.time
        ex!.pos.trType = TR_LINEAR
        ex!.pos.trDelta = cg.refdef.viewaxis[1] * -55

        ex!.color[0] = 24
        ex!.color[1] = 32
        ex!.color[2] = 40
        ex!.refEntity.customShader = trap_R_RegisterShader("gfx/effects/forcePush")
    } else {
        //superkewl "refraction" (well sort of) effect -rww
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = RefEntity.scratch { ent -> Bool in
            var ang = vec3_t()
            var scale: Float = 0
            var vLen: Float = 0
            var alpha: Float = 0
            var tDif: Int32 = 0

            if cent!.bodyFadeTime == 0 {
                //the duration for the expansion and fade
                cent!.bodyFadeTime = cg.time + REFRACT_EFFECT_DURATION
            }

            //closer tDif is to 0, the closer we are to
            //being "done"
            tDif = (cent!.bodyFadeTime - cg.time)

            if (REFRACT_EFFECT_DURATION - tDif) < 200 {
                //stop following the hand after a little and stay in a fixed spot
                //save the initial spot of the effect
                cent!.pushEffectOrigin = org
            }

            //scale from 1.0f to 0.1f then hold at 0.1 for the rest of the duration
            if (cent!.currentState.powerups & (1 << PW_PULL)) != 0 {
                scale = Float((REFRACT_EFFECT_DURATION - tDif)) * 0.003
            } else {
                scale = Float((tDif)) * 0.003
            }

            if scale > 1.0 {
                scale = 1.0
            } else if scale < 0.2 {
                scale = 0.2
            }

            //start alpha at 244, fade to 10
            alpha = Float(tDif) * 0.488

            if alpha > 244.0 {
                alpha = 244.0
            } else if alpha < 10.0 {
                alpha = 10.0
            }

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.
            ent.shaderTime = (cent!.bodyFadeTime - REFRACT_EFFECT_DURATION) / 1000.0

            ent.origin = cent!.pushEffectOrigin

            ent.axis[0] = ent.origin - cg.refdef.vieworg
            vLen = VectorLength(ent.axis[0])
            if vLen <= 0.1 {
                // Entity is right on vieworg.  quit.
                return true
            }

            vectoangles(ent.axis[0], &ang)
            ang[ROLL] += 180.0
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
            // Raven wrote: AnglesToAxis(ang, ent.axis)
            portMissing("CG_ForcePushBlur", source: "oracle/codemp/cgame/cg_players.c:4798")

            //radius must be a power of 2, and is the actual captured texture size
            if vLen < 128 {
                ent.radius = 256
            } else if vLen < 256 {
                ent.radius = 128
            } else if vLen < 512 {
                ent.radius = 64
            } else {
                ent.radius = 32
            }

            ent.axis[0] = ent.axis[0] * scale
            ent.axis[1] = ent.axis[1] * scale
            ent.axis[2] = ent.axis[2] * scale

            ent.hModel = cgs.media.halfShieldModel
            ent.customShader = cgs.media.refractionShader //cgs.media.cloakedShader;
            ent.nonNormalizedAxes = true

            //make it partially transparent so it blends with the background
            ent.renderfx = (RF_DISTORTION | RF_FORCE_ENT_ALPHA)
            ent.shaderRGBA[0] = 255
            ent.shaderRGBA[1] = 255
            ent.shaderRGBA[2] = 255
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
            // Raven wrote: ent.shaderRGBA[3] = alpha
            portMissing("CG_ForcePushBlur", source: "oracle/codemp/cgame/cg_players.c:4798")

            trap_R_AddRefEntityToScene(ent)
            return false
        }
        if earlyOut {
            return
        }
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:4958
private func CG_ForcePushBodyBlur(_ cent: Centity) {
    var fxOrg = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var bolt: Int32 = 0
        var i: Int32 = 0

        if cent.localAnimIndex > 1 {
            //Sorry, the humanoid IS IN ANOTHER CASTLE.
            return true
        }

        if cg.snap != nil && CG_IsMindTricked(cent.currentState.trickedentindex, cent.currentState.trickedentindex2, cent.currentState.trickedentindex3, cent.currentState.trickedentindex4, cg.snap!.ps.clientNum) != 0 {
            return true //this entity is mind-tricking the current client, so don't render it
        }


        i = 0
        while cg_pushBoneNames[i] != nil {
            //go through all the bones we want to put a blur effect on
            bolt = trap_G2API_AddBolt(cent.ghoul2, 0, cg_pushBoneNames[i])

            if bolt == -1 {
                i += 1
                continue
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, bolt, &boltMatrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
            portMissing("CG_ForcePushBodyBlur", source: "oracle/codemp/cgame/cg_players.c:4958")
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &fxOrg)

            //standard effect, don't be refractive (for now)
            CG_ForcePushBlur(fxOrg, nil)
            i += 1
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5000
private func CG_ForceGripEffect(_ org: JKAShared.vec3_t) {
    var ex: LocalEntity?
    let wv: Float = sin(cg.time * 0.004) * 0.08 + 0.1

    ex = CG_AllocLocalEntity()
    ex!.leType = LE_PUFF
    ex!.refEntity.reType = RT_SPRITE
    ex!.radius = 2.0
    ex!.startTime = cg.time
    ex!.endTime = ex!.startTime + 120
    ex!.pos.trBase = org
    ex!.pos.trTime = cg.time
    ex!.pos.trType = TR_LINEAR
    ex!.pos.trDelta = cg.refdef.viewaxis[1] * 55

    ex!.color[0] = 200 + ((wv * 255))
    if ex!.color[0] > 255 {
        ex!.color[0] = 255
    }
    ex!.color[1] = 0
    ex!.color[2] = 0
    ex!.refEntity.customShader = trap_R_RegisterShader("gfx/effects/forcePush")

    ex = CG_AllocLocalEntity()
    ex!.leType = LE_PUFF
    ex!.refEntity.reType = RT_SPRITE
    ex!.refEntity.rotation = 180.0
    ex!.radius = 2.0
    ex!.startTime = cg.time
    ex!.endTime = ex!.startTime + 120
    ex!.pos.trBase = org
    ex!.pos.trTime = cg.time
    ex!.pos.trType = TR_LINEAR
    ex!.pos.trDelta = cg.refdef.viewaxis[1] * -55

    /*
    ex->color[0] = 200+((wv*255));
    if (ex->color[0] > 255)
    {
    ex->color[0] = 255;
    }
    */
    ex!.color[0] = 255
    ex!.color[1] = 255
    ex!.color[2] = 255
    ex!.refEntity.customShader = cgs.media.redSaberGlowShader //trap_R_RegisterShader( "gfx/effects/forcePush" );
}

/**
```
===============
CG_AddRefEntityWithPowerups

Adds a piece with modifications or duplications for powerups
Also called by CG_Missile for quad rockets, but nobody can tell...
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:5059
func CG_AddRefEntityWithPowerups(_ ent: JKAMP.RefEntity, _ state: JKAMP.EntityState, _ team: Int32) {
    if CG_IsMindTricked(state.trickedentindex, state.trickedentindex2, state.trickedentindex3, state.trickedentindex4, cg.snap!.ps.clientNum) != 0 {
        return //this entity is mind-tricking the current client, so don't render it
    }

    trap_R_AddRefEntityToScene(ent)
}

/// Source: oracle/codemp/cgame/cg_players.c:5077
func CG_PlayerShieldHit(_ entitynum: Int32, _ dir: inout JKAShared.vec3_t, _ amount: Int32) {
    var cent: Centity?
    let time: Int32

    if entitynum < 0 || entitynum >= MAX_ENTITIES {
        return
    }

    cent = cg_entities[entitynum]

    if amount > 100 {
        time = Int32(Double(cg.time) + MAX_SHIELD_TIME) // 2 sec.
    } else {
        time = cg.time + 500 + amount * 15
    }

    if time > cent!.damageTime {
        cent!.damageTime = time
        dir = dir * -1
        vectoangles(dir, &cent!.damageAngles)
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5107
func CG_DrawPlayerShield(_ cent: Centity, _ origin: JKAShared.vec3_t) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { ent -> Bool in
        var alpha: Int32 = 0
        var scale: Float = 0

        // Don't draw the shield when the player is dead.
        if (cent.currentState.eFlags & EF_DEAD) != 0 {
            return true
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        ent.origin = origin
        ent.origin[2] = Float(Double(ent.origin[2]) + 10.0)
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis( cent->damageAngles, ent.axis )
        portMissing("CG_DrawPlayerShield", source: "oracle/codemp/cgame/cg_players.c:5107")

        // The SDK also declares `random`, so the call names the bg module.
        alpha = Int32(255.0 * (Double(cent.damageTime - cg.time) / MIN_SHIELD_TIME) + Double(JKAMP_BG.random() * 16))
        if alpha > 255 {
            alpha = 255
        }

        // Make it bigger, but tighter if more solid
        scale = Float(1.4 - (Double(Float(alpha)) * (0.4 / 255.0))) // Range from 1.0 to 1.4
        ent.axis[0] = ent.axis[0] * scale
        ent.axis[1] = ent.axis[1] * scale
        ent.axis[2] = ent.axis[2] * scale

        ent.hModel = cgs.media.halfShieldModel
        ent.customShader = cgs.media.halfShieldShader
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: ent.shaderRGBA[0] = alpha
        portMissing("CG_DrawPlayerShield", source: "oracle/codemp/cgame/cg_players.c:5107")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: ent.shaderRGBA[1] = alpha
        portMissing("CG_DrawPlayerShield", source: "oracle/codemp/cgame/cg_players.c:5107")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: ent.shaderRGBA[2] = alpha
        portMissing("CG_DrawPlayerShield", source: "oracle/codemp/cgame/cg_players.c:5107")
        ent.shaderRGBA[3] = 255
        trap_R_AddRefEntityToScene(ent)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5145
func CG_PlayerHitFX(_ cent: Centity) {
    // only do the below fx if the cent in question is...uh...me, and it's first person.
    if cent.currentState.clientNum != cg.predictedPlayerState.clientNum || cg.renderingThirdPerson {
        if cent.damageTime > cg.time && cent.currentState.NPC_class != CLASS_VEHICLE {
            CG_DrawPlayerShield(cent, cent.lerpOrigin)
        }

        return
    }
}

/**
```
=================
CG_LightVerts
=================
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:5167
func CG_LightVerts(_ normal: JKAShared.vec3_t, _ numVerts: Int32, _ verts: Slots<JKAMP.PolyVert>) -> Int32 {
    var i: Int32
    var j: Int32
    var incoming: Float
    var ambientLight = vec3_t()
    var lightDir = vec3_t()
    var directedLight = vec3_t()

    trap_R_LightForPoint(&verts[0].xyz, &ambientLight, &directedLight, &lightDir)

    i = 0
    while i < numVerts {
        incoming = _DotProduct(normal, lightDir)
        if incoming <= 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
            // Raven wrote: verts[i].modulate[0] = ambientLight[0]
            portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
            // Raven wrote: verts[i].modulate[1] = ambientLight[1]
            portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
            // Raven wrote: verts[i].modulate[2] = ambientLight[2]
            portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")
            verts[i].modulate[3] = 255
            i += 1
            continue
        }
        j = Int32((ambientLight[0] + incoming * directedLight[0]))
        if j > 255 {
            j = 255
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: verts[i].modulate[0] = j
        portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")

        j = Int32((ambientLight[1] + incoming * directedLight[1]))
        if j > 255 {
            j = 255
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: verts[i].modulate[1] = j
        portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")

        j = Int32((ambientLight[2] + incoming * directedLight[2]))
        if j > 255 {
            j = 255
        }
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: verts[i].modulate[2] = j
        portMissing("CG_LightVerts", source: "oracle/codemp/cgame/cg_players.c:5167")

        verts[i].modulate[3] = 255
        i += 1
    }
    return 1
}

/// Source: oracle/codemp/cgame/cg_players.c:5209
private func CG_RGBForSaberColor(_ color: JKAMP.saber_colors_t, _ rgb: inout JKAShared.vec3_t) {
    switch color {
    case SABER_RED:
        rgb = vec3_t(1.0, 0.2, 0.2)

    case SABER_ORANGE:
        rgb = vec3_t(1.0, 0.5, 0.1)

    case SABER_YELLOW:
        rgb = vec3_t(1.0, 1.0, 0.2)

    case SABER_GREEN:
        rgb = vec3_t(0.2, 1.0, 0.2)

    case SABER_BLUE:
        rgb = vec3_t(0.2, 0.4, 1.0)

    case SABER_PURPLE:
        rgb = vec3_t(0.9, 0.2, 1.0)

    default:
        break
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5234
private func CG_DoSaberLight(_ saber: JKAMP.SaberInfo) {
    var positions = [vec3_t](repeating: vec3_t(), count: 16)
    var mid = vec3_t(0, 0, 0)
    var rgbs = [vec3_t](repeating: vec3_t(), count: 16)
    var rgb = vec3_t(0, 0, 0)
    var lengths: [Float] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var totallength: Float = 0
    var numpositions: Float = 0
    var dist: Float
    var diameter: Float = 0
    var i: Int32
    var j: Int32

    //RGB combine all the colors of the sabers you're using into one averaged color!

    if (saber.saberFlags2 & SFL2_NO_DLIGHT) != 0 {
        //no dlight!
        return
    }

    i = 0
    while i < saber.numBlades {
        if saber.blade[i].length >= 0.5 {
            //FIXME: make RGB sabers
            CG_RGBForSaberColor(saber.blade[i].color, &rgbs[i])
            lengths[i] = saber.blade[i].length
            if saber.blade[i].length * 2.0 > diameter {
                diameter = saber.blade[i].length * 2.0
            }
            totallength += saber.blade[i].length
            _VectorMA(saber.blade[i].muzzlePoint, saber.blade[i].length, saber.blade[i].muzzleDir, &positions[i])
            if numpositions == 0 {
                //first blade, store middle of that as midpoint
                _VectorMA(saber.blade[i].muzzlePoint, Float(Double(saber.blade[i].length) * 0.5), saber.blade[i].muzzleDir, &mid)
                rgb = rgbs[i]
            }
            numpositions += 1
        }
        i += 1
    }

    if totallength != 0 {
        //actually have something to do
        if numpositions == 1 {
            //only 1 blade, midpoint is already set (halfway between the start and end of that blade), rgb is already set, so it diameter
        } else {
            //multiple blades, calc averages
            mid = vec3_t()
            rgb = vec3_t()
            //now go through all the data and get the average RGB and middle position and the radius
            i = 0
            while i < MAX_BLADES * 2 {
                if lengths[i] != 0 {
                    _VectorMA(rgb, lengths[i], rgbs[i], &rgb)
                    mid = mid + positions[i]
                }
                i += 1
            }

            //get middle rgb
            rgb = rgb * (1 / totallength) //get the average, normalized RGB
            //get mid position
            mid = mid * (1 / numpositions)
            //find the farthest distance between the blade tips, this will be our diameter
            i = 0
            while i < MAX_BLADES * 2 {
                if lengths[i] != 0 {
                    j = 0
                    while j < MAX_BLADES * 2 {
                        if lengths[j] != 0 {
                            dist = Distance(positions[i], positions[j])
                            if dist > diameter {
                                diameter = dist
                            }
                        }
                        j += 1
                    }
                }
                i += 1
            }
        }

        // The SDK also declares `random`, so the call names the bg module.
        trap_R_AddLightToScene(mid, diameter + (JKAMP_BG.random() * 8.0), rgb[0], rgb[1], rgb[2])
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5320
func CG_DoSaber(_ origin: JKAShared.vec3_t, _ dir: JKAShared.vec3_t, _ length: Float, _ lengthMax: Float, _ radius: Float, _ color: JKAMP.saber_colors_t, _ rfx: Int32, _ doLight: Bool) {
    var mid = vec3_t()
    var blade: qhandle_t = 0
    var glow: qhandle_t = 0
    // Raven assigns his own `rfx` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var rfx = rfx
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { saber -> Bool in
        var radiusmult: Float = 0
        var radiusRange: Float = 0
        var radiusStart: Float = 0

        if length < 0.5 {
            // if the thing is so short, just forget even adding me.
            return true
        }

        // Find the midpoint of the saber for lighting purposes
        _VectorMA(origin, length * 0.5, dir, &mid)

        switch color {
        case SABER_RED:
            glow = cgs.media.redSaberGlowShader
            blade = cgs.media.redSaberCoreShader

        case SABER_ORANGE:
            glow = cgs.media.orangeSaberGlowShader
            blade = cgs.media.orangeSaberCoreShader

        case SABER_YELLOW:
            glow = cgs.media.yellowSaberGlowShader
            blade = cgs.media.yellowSaberCoreShader

        case SABER_GREEN:
            glow = cgs.media.greenSaberGlowShader
            blade = cgs.media.greenSaberCoreShader

        case SABER_BLUE:
            glow = cgs.media.blueSaberGlowShader
            blade = cgs.media.blueSaberCoreShader

        case SABER_PURPLE:
            glow = cgs.media.purpleSaberGlowShader
            blade = cgs.media.purpleSaberCoreShader

        default:
            glow = cgs.media.blueSaberGlowShader
            blade = cgs.media.blueSaberCoreShader
        }

        if doLight {
            // always add a light because sabers cast a nice glow before they slice you in half!!  or something...
            var rgb = vec3_t(1, 1, 1)
            CG_RGBForSaberColor(color, &rgb)
            // The SDK also declares `random`, so the call names the bg module.
            trap_R_AddLightToScene(mid, (length * 1.4) + (JKAMP_BG.random() * 3.0), rgb[0], rgb[1], rgb[2])
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        // Saber glow is it's own ref type because it uses a ton of sprites, otherwise it would eat up too many
        //	refEnts to do each glow blob individually
        saber.saberLength = length

        // Jeff, I did this because I foolishly wished to have a bright halo as the saber is unleashed.
        // It's not quite what I'd hoped tho.  If you have any ideas, go for it!  --Pat
        if length < lengthMax {
            radiusmult = Float(1.0 + (2.0 / Double(length))) // Note this creates a curve, and length cannot be < 0.5.
        } else {
            radiusmult = 1.0
        }

        if cg_saberTrail.integer == 2 && cg_shadows.integer != 2 && cgs.glconfig.stencilBits >= 4 {
            //draw the blade as a post-render so it doesn't get in the cap...
            rfx |= RF_FORCEPOST
        }

        radiusRange = radius * 0.075
        radiusStart = radius - radiusRange

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
        // Raven wrote: saber.radius = (radiusStart + crandom() * radiusRange)*radiusmult
        portMissing("CG_DoSaber", source: "oracle/codemp/cgame/cg_players.c:5320")
        //saber.radius = (2.8f + crandom() * 0.2f)*radiusmult;

        saber.origin = origin
        saber.axis[0] = dir
        saber.reType = RT_SABER_GLOW
        saber.customShader = glow
        saber.shaderRGBA[3] = 0xff
        saber.shaderRGBA[2] = saber.shaderRGBA[3]
        saber.shaderRGBA[1] = saber.shaderRGBA[2]
        saber.shaderRGBA[0] = saber.shaderRGBA[1]
        saber.renderfx = rfx

        trap_R_AddRefEntityToScene(saber)

        // Do the hot core
        _VectorMA(origin, length, dir, &saber.origin)
        _VectorMA(origin, -1, dir, &saber.oldorigin)


        //	CG_TestLine(saber.origin, saber.oldorigin, 50, 0x000000ff, 3);
        saber.customShader = blade
        saber.reType = RT_LINE
        radiusStart = radius / 3.0
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
        // Raven wrote: saber.radius = (radiusStart + crandom() * radiusRange)*radiusmult
        portMissing("CG_DoSaber", source: "oracle/codemp/cgame/cg_players.c:5320")
        //	saber.radius = (1.0 + crandom() * 0.2f)*radiusmult;

        saber.shaderTexCoord[1] = 1.0
        saber.shaderTexCoord[0] = saber.shaderTexCoord[1]
        saber.shaderRGBA[3] = 0xff
        saber.shaderRGBA[2] = saber.shaderRGBA[3]
        saber.shaderRGBA[1] = saber.shaderRGBA[2]
        saber.shaderRGBA[0] = saber.shaderRGBA[1]

        trap_R_AddRefEntityToScene(saber)
        return false
    }
    if earlyOut {
        return
    }
}

//--------------------------------------------------------------
// CG_GetTagWorldPosition
//
// Can pass in NULL for the axis
//--------------------------------------------------------------
/// Source: oracle/codemp/cgame/cg_players.c:5437
func CG_GetTagWorldPosition(_ model: JKAMP.RefEntity, _ tag: String, _ pos: inout JKAShared.vec3_t, _ axis: inout [JKAShared.vec3_t]) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Orientation.scratch { orientation in
        var i: Int32 = 0

        // Get the requested tag
        trap_R_LerpTag(orientation, model.hModel, model.oldframe, model.frame, 1.0 - model.backlerp, tag)

        pos = model.origin
        i = 0
        while i < 3 {
            _VectorMA(pos, orientation.origin[i], model.axis[i], &pos)
            i += 1
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[[Float]]'".
        // Raven wrote: MatrixMultiply( orientation.axis, model->axis, axis )
        portMissing("CG_GetTagWorldPosition", source: "oracle/codemp/cgame/cg_players.c:5437")
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5462
func CG_CreateSaberMarks(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ normal: JKAShared.vec3_t) {
    //	byte			colors[4];
    var i: Int32 = 0
    var j: Int32 = 0
    var numFragments: Int32 = 0
    var axis = [vec3_t](repeating: vec3_t(), count: 3)
    var originalPoints = [vec3_t](repeating: vec3_t(), count: 4)
    var mid = vec3_t()
    var markPoints = [vec3_t](repeating: vec3_t(), count: 384)
    var projection = vec3_t()
    var v: PolyVert?
    // Port-note: A local `polyVert_t[10] verts` the table has no type for.
    // Raven wrote: verts[MAX_VERTS_ON_POLY];
    portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
    var mark: MarkPoly?
    // Port-note: A local `markFragment_t[128] markFragments` the table has no type for.
    // Raven wrote: markFragment_t markFragments[MAX_MARK_FRAGMENTS];
    portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
    var mf: MarkFragment?

    let radius: Float = 0.65

    if cg_addMarks.integer == 0 {
        return
    }

    axis[1] = end - start
    VectorNormalize(&axis[1])

    // create the texture axis
    axis[0] = normal
    CrossProduct(axis[1], axis[0], &axis[2])

    // create the full polygon that we'll project
    i = 0
    while i < 3 {
        // stretch a bit more in the direction that we are traveling in...  debateable as to whether this makes things better or worse
        originalPoints[0][i] = start[i] - radius * axis[1][i] - radius * axis[2][i]
        originalPoints[1][i] = end[i] + radius * axis[1][i] - radius * axis[2][i]
        originalPoints[2][i] = end[i] + radius * axis[1][i] + radius * axis[2][i]
        originalPoints[3][i] = start[i] - radius * axis[1][i] + radius * axis[2][i]
        i += 1
    }

    projection = normal * -1

    // get the fragments
    // Port-note: A cast to `const float (*)[3]` the draft has no view for.
    // Raven wrote: numFragments = trap_CM_MarkFragments( 4, (const float (*)[3])originalPoints, projection, MAX_MARK_POINTS, markPoints[0], MAX_MARK_FRAGMENTS, markFragments )
    portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")

    i = 0
    // Port-note: A read of `markFragments`, a local the draft left as a hole.
    // Raven wrote: mf = markFragments
    portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
    while i < numFragments {
        // we have an upper limit on the complexity of polygons that we store persistantly
        if mf!.numPoints > MAX_VERTS_ON_POLY {
            mf!.numPoints = MAX_VERTS_ON_POLY
        }

        j = 0
        // Port-note: A read of `verts`, a local the draft left as a hole.
        // Raven wrote: v = verts
        portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
        while j < mf!.numPoints {
            var delta = vec3_t()

            // Set up our texture coords, this may need some work
            v!.xyz = markPoints[mf!.firstPoint + j]
            mid = end + start
            mid = mid * 0.5
            delta = v!.xyz - mid

            // The SDK also declares `random`, so the call names the bg module.
            v!.st[0] = Float(0.5 + Double(_DotProduct(delta, axis[1]) * (0.05 + JKAMP_BG.random() * 0.03)))
            // The SDK also declares `random`, so the call names the bg module.
            v!.st[1] = Float(0.5 + Double(_DotProduct(delta, axis[2]) * (0.15 + JKAMP_BG.random() * 0.05)))
            j += 1
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'PolyVert?' to expected argument type 'Int'".
            // Raven wrote: v++
            portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
        }

        if cg_saberDynamicMarks.integer != 0 {
            var i: Int32 = 0
            var i_2: Int32 = 0
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives true where Raven returns from the function.
            let earlyOut = AddpolyArgStruct.scratch { apArgs -> Bool in
                var x = vec3_t()

                apArgs.clear()

                while i < 4 {
                    while i_2 < 3 {
                        // Port-note: A read of `verts`, a local the draft left as a hole.
                        // Raven wrote: apArgs.p[i][i_2] = verts[i].xyz[i_2]
                        portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")

                        i_2 += 1
                    }

                    i_2 = 0
                    i += 1
                }

                i = 0
                i_2 = 0

                while i < 4 {
                    while i_2 < 2 {
                        // Port-note: A read of `verts`, a local the draft left as a hole.
                        // Raven wrote: apArgs.ev[i][i_2] = verts[i].st[i_2]
                        portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")

                        i_2 += 1
                    }

                    i_2 = 0
                    i += 1
                }

                //When using addpoly, having a situation like this tends to cause bad results.
                //(I assume it doesn't like trying to draw a polygon over two planes and extends
                //the vertex out to some odd value)
                x = apArgs.p[0] - apArgs.p[3]
                if VectorLength(x) > 3.0 {
                    return true
                }

                apArgs.numVerts = mf!.numPoints
                apArgs.vel = vec3_origin
                apArgs.accel = vec3_origin

                apArgs.alpha1 = 1.0
                apArgs.alpha2 = 0.0
                apArgs.alphaParm = 255.0

                apArgs.rgb1 = vec3_t(0.0, 0.0, 0.0)
                apArgs.rgb2 = vec3_t(0.0, 0.0, 0.0)

                apArgs.rgbParm = 0.0

                apArgs.bounce = 0
                apArgs.motionDelay = 0
                apArgs.killTime = cg_saberDynamicMarkTime.integer
                apArgs.shader = cgs.media.rivetMarkShader
                apArgs.flags = 0x08000000 | 0x00000004

                trap_FX_AddPoly(apArgs)

                apArgs.shader = cgs.media.mSaberDamageGlow
                // The SDK also declares `random`, so the call names the bg module.
                apArgs.rgb1[0] = 215 + JKAMP_BG.random() * 40.0
                // The SDK also declares `random`, so the call names the bg module.
                apArgs.rgb1[1] = 96 + JKAMP_BG.random() * 32.0
                // The SDK also declares `random`, so the call names the bg module.
                apArgs.alphaParm = JKAMP_BG.random() * 15.0
                apArgs.rgb1[2] = apArgs.alphaParm

                apArgs.rgb1[0] /= 255
                apArgs.rgb1[1] /= 255
                apArgs.rgb1[2] /= 255
                apArgs.rgb2 = apArgs.rgb1

                apArgs.killTime = 100

                trap_FX_AddPoly(apArgs)
                return false
            }
            if earlyOut {
                return
            }
        } else {
            // save it persistantly, do burn first
            mark = CG_AllocMark()
            mark!.time = cg.time
            mark!.alphaFade = true
            mark!.markShader = cgs.media.rivetMarkShader
            mark!.poly.numVerts = mf!.numPoints
            mark!.color[3] = 255
            mark!.color[2] = mark!.color[3]
            mark!.color[1] = mark!.color[2]
            mark!.color[0] = mark!.color[1]
            // Port-note: Raven's `memcpy( mark->verts, verts, mf->numPoints * sizeof( verts[0] ) )` runs over bytes that are not one record with a view.
            // Raven wrote: memcpy( mark->verts, verts, mf->numPoints * sizeof( verts[0] ) )
            portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")

            // And now do a glow pass
            // by moving the start time back, we can hack it to fade out way before the burn does
            mark = CG_AllocMark()
            mark!.time = cg.time - 8500
            mark!.alphaFade = false
            mark!.markShader = cgs.media.mSaberDamageGlow
            mark!.poly.numVerts = mf!.numPoints
            // The SDK also declares `random`, so the call names the bg module.
            mark!.color[0] = 215 + JKAMP_BG.random() * 40.0
            // The SDK also declares `random`, so the call names the bg module.
            mark!.color[1] = 96 + JKAMP_BG.random() * 32.0
            // The SDK also declares `random`, so the call names the bg module.
            mark!.color[3] = JKAMP_BG.random() * 15.0
            mark!.color[2] = mark!.color[3]
            // Port-note: Raven's `memcpy( mark->verts, verts, mf->numPoints * sizeof( verts[0] ) )` runs over bytes that are not one record with a view.
            // Raven wrote: memcpy( mark->verts, verts, mf->numPoints * sizeof( verts[0] ) )
            portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
        }
        i += 1
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'MarkFragment?' to expected argument type 'Int'".
        // Raven wrote: mf++
        portMissing("CG_CreateSaberMarks", source: "oracle/codemp/cgame/cg_players.c:5462")
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5632
func CG_G2TraceCollide(_ tr: JKAMP.Trace, _ mins: JKAShared.vec3_t?, _ maxs: JKAShared.vec3_t?, _ lastValidStart: JKAShared.vec3_t, _ lastValidEnd: JKAShared.vec3_t) -> Bool {
    // Port-note: A local `G2Trace_t G2Trace` the table has no type for.
    // Raven wrote: G2Trace_t G2Trace;
    portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")
    var g2Hit: Centity?
    var angles = vec3_t()
    var tN: Int32 = 0
    var fRadius: Float = 0.0

    if mins != nil && maxs != nil && (mins![0] != 0 || maxs![0] != 0) {
        fRadius = (maxs![0] - mins![0]) / 2.0
    }

    // Port-note: Raven's `memset (&G2Trace, 0, sizeof(G2Trace))` runs over bytes that are not one record with a view.
    // Raven wrote: memset (&G2Trace, 0, sizeof(G2Trace))
    portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")

    while tN < MAX_G2_COLLISIONS {
        // Port-note: A read of `G2Trace`, a local the draft left as a hole.
        // Raven wrote: G2Trace[tN].mEntityNum = -1
        portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")
        tN += 1
    }
    g2Hit = cg_entities[tr.entityNum]

    if g2Hit != nil && g2Hit!.ghoul2 != nil {
        angles[PITCH] = 0
        angles[ROLL] = angles[PITCH]
        angles[YAW] = g2Hit!.lerpAngles[YAW]

        if cg_optvehtrace.integer != 0 && g2Hit!.currentState.eType == ET_NPC && g2Hit!.currentState.NPC_class == CLASS_VEHICLE && g2Hit!.m_pVehicle != nil {
            // Port-note: A read of `G2Trace`, a local the draft left as a hole.
            // Raven wrote: trap_G2API_CollisionDetectCache ( G2Trace, g2Hit->ghoul2, angles, g2Hit->lerpOrigin, cg.time, g2Hit->currentState.number, lastValidStart, lastValidEnd, g2Hit->modelScale, 0, cg_g2TraceLod.integer, fRadius )
            portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")
        } else {
            // Port-note: A read of `G2Trace`, a local the draft left as a hole.
            // Raven wrote: trap_G2API_CollisionDetect ( G2Trace, g2Hit->ghoul2, angles, g2Hit->lerpOrigin, cg.time, g2Hit->currentState.number, lastValidStart, lastValidEnd, g2Hit->modelScale, 0, cg_g2TraceLod.integer, fRadius )
            portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")
        }

        // Port-note: A read of `G2Trace`, a local the draft left as a hole.
        // Raven wrote: if (G2Trace[0].mEntityNum != g2Hit->currentState.number) { tr->fraction = 1.0f; tr->entityNum = ENTITYNUM_NONE; tr->startsolid = 0; tr->allsolid = 0; return qfalse; } else { //Yay! VectorCopy(G2Trace[0].mCollisionPosition, tr->endpos); VectorCopy(G2Trace[0].mCollisionNormal, tr->plane.normal); return qtrue; }
        portMissing("CG_G2TraceCollide", source: "oracle/codemp/cgame/cg_players.c:5632")
    }

    return false
}

/// Source: oracle/codemp/cgame/cg_players.c:5691
func CG_G2SaberEffects(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ owner: Centity) {
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { trace in
        var startTr = vec3_t()
        var endTr = vec3_t()
        var backWards: Bool = false
        var doneWithTraces: Bool = false

        while !doneWithTraces {
            if !backWards {
                startTr = start
                endTr = end
            } else {
                startTr = end
                endTr = start
            }

            CG_Trace(trace, startTr, nil, nil, endTr, owner.currentState.number, MASK_PLAYERSOLID)

            if trace.entityNum < MAX_CLIENTS {
                //hit a client..
                CG_G2TraceCollide(trace, nil, nil, startTr, endTr)

                if trace.entityNum != ENTITYNUM_NONE {
                    //it succeeded with the ghoul2 trace
                    trap_FX_PlayEffectID(cgs.effects.mSaberBloodSparks, &trace.endpos, &trace.plane.normal, -1, -1)
                    trap_S_StartSound(&trace.endpos, trace.entityNum, CHAN_AUTO, trap_S_RegisterSound(va("sound/weapons/saber/saberhit%i.wav", Q_irand(1, 3))))
                }
            }

            if !backWards {
                backWards = true
            } else {
                doneWithTraces = true
            }
        }
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5738
func CG_AddGhoul2Mark(_ shader: Int32, _ size: Float, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ entnum: Int32, _ entposition: JKAShared.vec3_t, _ entangle: Float, _ ghoul2: OpaquePointer?, _ scale: inout JKAShared.vec3_t, _ lifeTime: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = SkinGoreData.scratch { goreSkin -> Bool in


        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        if trap_G2API_GetNumGoreMarks(ghoul2, 0) >= cg_ghoul2Marks.integer {
            //you've got too many marks already
            return true
        }

        goreSkin.growDuration = -1 // default expandy time
        goreSkin.goreScaleStartFraction = 1.0 // default start scale
        goreSkin.frontFaces = true
        goreSkin.backFaces = true
        goreSkin.lifeTime = lifeTime //last randomly 10-20 seconds
        /*
        if (lifeTime)
        {
        goreSkin.fadeOutTime = lifeTime*0.1; //default fade duration is relative to lifetime.
        }
        goreSkin.fadeRGB = qtrue; //fade on RGB instead of alpha (this depends on the shader really, modify if needed)
        */
        //rwwFIXMEFIXME: fade has sorting issues with other non-fading decals, disabled until fixed

        goreSkin.baseModelOnly = false

        goreSkin.currentTime = cg.time
        goreSkin.entNum = entnum
        goreSkin.SSize = size
        goreSkin.TSize = size
        goreSkin.theta = flrand(0.0, 6.28)
        goreSkin.shader = shader

        if scale[0] == 0 && scale[1] == 0 && scale[2] == 0 {
            goreSkin.scale = vec3_t(1.0, 1.0, 1.0)
        } else {
            scale = goreSkin.scale
        }

        goreSkin.hitLocation = start

        goreSkin.rayDirection = end - start
        if VectorNormalize(&goreSkin.rayDirection) < 0.1 {
            return true
        }

        goreSkin.position = entposition
        goreSkin.angles[YAW] = entangle

        trap_G2API_AddSkinGore(ghoul2, goreSkin)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5798
func CG_SaberCompWork(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ owner: Centity, _ saberNum: Int32, _ bladeNum: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var startTr = vec3_t()
        var endTr = vec3_t()
        let backWards: Bool = false
        var doneWithTraces: Bool = false
        var doEffect: Bool = false
        var client: ClientInfo? = nil

        if (cg.time - owner.serverSaberHitTime) > CG_MAX_SABER_COMP_TIME {
            return true
        }

        if cg.time == owner.serverSaberHitTime {
            //don't want to do it the same frame as the server hit, to avoid burst effect concentrations every x ms.
            return true
        }

        while !doneWithTraces {
            if !backWards {
                startTr = start
                endTr = end
            } else {
                startTr = end
                endTr = start
            }

            CG_Trace(trace, startTr, nil, nil, endTr, owner.currentState.number, MASK_PLAYERSOLID)

            if trace.entityNum == owner.serverSaberHitIndex {
                //this is the guy the server says we last hit, so continue.
                if cg_entities[trace.entityNum].ghoul2 != nil {
                    //If it has a g2 instance, do the proper ghoul2 checks
                    CG_G2TraceCollide(trace, nil, nil, startTr, endTr)

                    if trace.entityNum != ENTITYNUM_NONE {
                        //it succeeded with the ghoul2 trace
                        doEffect = true

                        if cg_ghoul2Marks.integer != 0 {
                            var ePos = vec3_t()
                            let trEnt: Centity? = cg_entities[trace.entityNum]

                            if trEnt!.ghoul2 != nil {
                                if trEnt!.currentState.eType != ET_NPC || trEnt!.currentState.NPC_class != CLASS_VEHICLE || trEnt!.m_pVehicle == nil || trEnt!.m_pVehicle!.m_pVehicleInfo!.type != VH_FIGHTER {
                                    //don't do on fighters cause they have crazy full axial angles
                                    var weaponMarkShader: Int32 = 0
                                    var markShader: Int32 = cgs.media.bdecal_saberglow

                                    ePos = endTr - trace.endpos
                                    VectorNormalize(&ePos)
                                    _VectorMA(trace.endpos, 4.0, ePos, &ePos)

                                    if owner.currentState.eType == ET_NPC {
                                        client = owner.npcClient
                                    } else {
                                        client = cgs.clientinfo[owner.currentState.clientNum]
                                    }
                                    if client != nil && client!.infoValid {
                                        if WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) {
                                            if client!.saber[saberNum].g2MarksShader2 != 0 {
                                                //we have a shader to use instead of the standard mark shader
                                                markShader = client!.saber[saberNum].g2MarksShader2
                                            }
                                            if client!.saber[saberNum].g2WeaponMarkShader2 != 0 {
                                                //we have a shader to use as a splashback onto the weapon model
                                                weaponMarkShader = client!.saber[saberNum].g2WeaponMarkShader2
                                            }
                                        } else {
                                            if client!.saber[saberNum].g2MarksShader != 0 {
                                                //we have a shader to use instead of the standard mark shader
                                                markShader = client!.saber[saberNum].g2MarksShader
                                            }
                                            if client!.saber[saberNum].g2WeaponMarkShader != 0 {
                                                //we have a shader to use as a splashback onto the weapon model
                                                weaponMarkShader = client!.saber[saberNum].g2WeaponMarkShader
                                            }
                                        }
                                    }
                                    CG_AddGhoul2Mark(markShader, flrand(3.0, 4.0), trace.endpos, ePos, trace.entityNum, trEnt!.lerpOrigin, trEnt!.lerpAngles[YAW], trEnt!.ghoul2, &trEnt!.modelScale, Q_irand(5000, 10000))
                                    if weaponMarkShader != 0 {
                                        var splashBackDir = vec3_t()
                                        splashBackDir = ePos * -1
                                        CG_AddGhoul2Mark(weaponMarkShader, flrand(0.5, 2.0), trace.endpos, splashBackDir, owner.currentState.clientNum, owner.lerpOrigin, owner.lerpAngles[YAW], owner.ghoul2, &owner.modelScale, Q_irand(5000, 10000))
                                    }
                                }
                            }
                        }
                    }
                } else {
                    //otherwise, we're all set.
                    doEffect = true
                }

                if doEffect {
                    var hitPersonFxID: Int32 = cgs.effects.mSaberBloodSparks
                    var hitOtherFxID: Int32 = cgs.effects.mSaberCut

                    if owner.currentState.eType == ET_NPC {
                        client = owner.npcClient
                    } else {
                        client = cgs.clientinfo[owner.currentState.clientNum]
                    }
                    if client != nil && client!.infoValid {
                        if WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) {
                            //use second blade style values
                            if client!.saber[saberNum].hitPersonEffect2 != 0 {
                                hitPersonFxID = client!.saber[saberNum].hitPersonEffect2
                            }
                            if client!.saber[saberNum].hitOtherEffect2 != 0 {
                                //custom hit other effect
                                hitOtherFxID = client!.saber[saberNum].hitOtherEffect2
                            }
                        } else {
                            //use first blade style values
                            if client!.saber[saberNum].hitPersonEffect != 0 {
                                hitPersonFxID = client!.saber[saberNum].hitPersonEffect
                            }
                            if client!.saber[saberNum].hitOtherEffect != 0 {
                                //custom hit other effect
                                hitOtherFxID = client!.saber[saberNum].hitOtherEffect
                            }
                        }
                    }
                    if trace.plane.normal[0] == 0 && trace.plane.normal[1] == 0 && trace.plane.normal[2] == 0 {
                        //who cares, just shoot it somewhere.
                        trace.plane.normal[1] = 1
                    }

                    if owner.serverSaberFleshImpact {
                        //do standard player/live ent hit sparks
                        trap_FX_PlayEffectID(hitPersonFxID, &trace.endpos, &trace.plane.normal, -1, -1)
                        //trap_S_StartSound(trace.endpos, trace.entityNum, CHAN_AUTO, trap_S_RegisterSound(va("sound/weapons/saber/saberhit%i.wav", Q_irand(1, 3))));
                    } else {
                        //do the cut effect
                        trap_FX_PlayEffectID(hitOtherFxID, &trace.endpos, &trace.plane.normal, -1, -1)
                    }
                    doEffect = false
                }
            }

            /*
            if (!backWards)
            {
            backWards = qtrue;
            }
            else
            {
            doneWithTraces = qtrue;
            }
            */
            doneWithTraces = true //disabling backwards tr for now, sometimes it just makes too many effects.
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:5993
func CG_AddSaberBlade(_ cent: Centity, _ scent: Centity, _ saber: JKAMP.RefEntity?, _ renderfx: Int32, _ modelIndex: Int32, _ saberNum: Int32, _ bladeNum: Int32, _ origin: JKAShared.vec3_t, _ angles: JKAShared.vec3_t, _ fromSaber: Bool, _ dontDraw: Bool) {
    var org_ = vec3_t()
    var end = vec3_t()
    var v = vec3_t()
    // Port-note: An array of vectors with an initializer.
    // Raven wrote: axis_[3] = {0,0,0, 0,0,0, 0,0,0};
    portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        var i: Int32 = 0
        var trailDur: Int32 = 0
        var saberLen: Float = 0
        var diff: Float = 0
        var client: ClientInfo?
        var saberEnt: Centity?
        var saberTrail: SaberTrail?
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = MdxaBone.scratch { boltMatrix -> Bool in
            var futureAngles = vec3_t()
            // Raven's record lives to the end of his block, so the block is the closure.
            // The closure gives true where Raven returns from the function.
            let earlyOut3 = EffectTrailArgStruct.scratch { fx -> Bool in
                var scolor: Int32 = 0
                var useModelIndex: Int32 = 0

                CheckTrail: do {
                    if cent.currentState.eType == ET_NPC {
                        client = cent.npcClient
                    } else {
                        client = cgs.clientinfo[cent.currentState.number]
                    }

                    saberEnt = cg_entities[cent.currentState.saberEntityNum]
                    saberLen = client!.saber[saberNum].blade[bladeNum].length

                    if saberLen <= 0 && !dontDraw {
                        //don't bother then.
                        return true
                    }

                    futureAngles[YAW] = angles[YAW]
                    futureAngles[PITCH] = angles[PITCH]
                    futureAngles[ROLL] = angles[ROLL]


                    if fromSaber {
                        useModelIndex = 0
                    } else {
                        useModelIndex = saberNum + 1
                    }
                    //Assume bladeNum is equal to the bolt index because bolts should be added in order of the blades.
                    //if there is an effect on this blade, play it
                    if !WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) && client!.saber[saberNum].bladeEffect != 0 {
                        trap_FX_PlayBoltedEffectID(client!.saber[saberNum].bladeEffect, &scent.lerpOrigin, scent.ghoul2, bladeNum, scent.currentState.number, useModelIndex, -1, false)
                    } else if WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) && client!.saber[saberNum].bladeEffect2 != 0 {
                        trap_FX_PlayBoltedEffectID(client!.saber[saberNum].bladeEffect2, &scent.lerpOrigin, scent.ghoul2, bladeNum, scent.currentState.number, useModelIndex, -1, false)
                    }
                    //get the boltMatrix
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                    // Raven wrote: trap_G2API_GetBoltMatrix(scent->ghoul2, useModelIndex, bladeNum, &boltMatrix, futureAngles, origin, cg.time, cgs.gameModels, scent->modelScale)
                    portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")

                    // work the matrix axis stuff into the original axis and origins used.
                    BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &org_)
                    // Port-note: A read of `axis_`, a local the draft left as a hole.
                    // Raven wrote: BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, axis_[0])
                    portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")

                    if !fromSaber && saberEnt != nil && !cent.currentState.saberInFlight {
                        saberEnt!.currentState.pos.trBase = org_

                        // Port-note: A read of `axis_`, a local the draft left as a hole.
                        // Raven wrote: VectorCopy(axis_[0], saberEnt->currentState.apos.trBase)
                        portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")
                    }

                    // Port-note: A read of `axis_`, a local the draft left as a hole.
                    // Raven wrote: VectorMA( org_, saberLen, axis_[0], end )
                    portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")

                    // Port-note: A read of `axis_`, a local the draft left as a hole.
                    // Raven wrote: VectorAdd( end, axis_[0], end )
                    portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")

                    if cent.currentState.eType == ET_NPC {
                        scolor = client!.saber[saberNum].blade[bladeNum].color
                    } else {
                        if saberNum == 0 {
                            scolor = client!.icolor1
                        } else {
                            scolor = client!.icolor2
                        }
                    }

                    if cgs.gametype >= GT_TEAM && cgs.gametype != GT_SIEGE && !cgs.jediVmerc && cent.currentState.eType != ET_NPC {
                        if client!.team == TEAM_RED {
                            scolor = SABER_RED
                        } else if client!.team == TEAM_BLUE {
                            scolor = SABER_BLUE
                        }
                    }

                    if cg_saberContact.integer == 0 {
                        //if we don't have saber contact enabled, just add the blade and don't care what it's touching
                        break CheckTrail
                    }

                    if !dontDraw {
                        if cg_saberModelTraceEffect.integer != 0 {
                            CG_G2SaberEffects(org_, end, cent)
                        } else if cg_saberClientVisualCompensation.integer != 0 {
                            CG_Trace(trace, org_, nil, nil, end, ENTITYNUM_NONE, MASK_SOLID)

                            if trace.fraction != 1 {
                                //nudge the endpos a very small amount from the beginning to the end, so the comp trace hits at the end.
                                //I'm only bothering with this because I want to do a backwards trace too in the comp trace, so if the
                                //blade is sticking through a player or something the standard trace doesn't it, it will make sparks
                                //on each side.
                                var seDif = vec3_t()

                                seDif = trace.endpos - org_
                                VectorNormalize(&seDif)
                                trace.endpos[0] += seDif[0] * 0.1
                                trace.endpos[1] += seDif[1] * 0.1
                                trace.endpos[2] += seDif[2] * 0.1
                            }

                            if client!.saber[saberNum].blade[bladeNum].storageTime < cg.time {
                                //debounce it in case our framerate is absurdly high. Using storageTime since it's not used for anything else in the client.
                                CG_SaberCompWork(org_, trace.endpos, cent, saberNum, bladeNum)

                                client!.saber[saberNum].blade[bladeNum].storageTime = cg.time + 5
                            }
                        }

                        i = 0
                        while i < 1 {
                            if i != 0 {
                                //tracing from end to base
                                CG_Trace(trace, end, nil, nil, org_, ENTITYNUM_NONE, MASK_SOLID)
                            } else {
                                //tracing from base to end
                                CG_Trace(trace, org_, nil, nil, end, ENTITYNUM_NONE, MASK_SOLID)
                            }

                            if trace.fraction < 1.0 {
                                var trDir = vec3_t()
                                trDir = trace.plane.normal
                                if trDir[0] == 0 && trDir[1] == 0 && trDir[2] == 0 {
                                    trDir[1] = 1
                                }

                                if (client!.saber[saberNum].saberFlags2 & SFL2_NO_WALL_MARKS) != 0 {
                                    //don't actually draw the marks/impact effects
                                } else {
                                    if !((trace.surfaceFlags & SURF_NOIMPACT) != 0) {
                                        trap_FX_PlayEffectID(cgs.effects.mSparks, &trace.endpos, &trDir, -1, -1)
                                    }
                                }

                                //Stop saber? (it wouldn't look right if it was stuck through a thin wall and unable to hurt players on the other side)
                                v = org_ - trace.endpos
                                saberLen = VectorLength(v)

                                end = trace.endpos

                                if (client!.saber[saberNum].saberFlags2 & SFL2_NO_WALL_MARKS) != 0 {
                                    //don't actually draw the marks
                                } else {
                                    //draw marks if we hit a wall
                                    // All I need is a bool to mark whether I have a previous point to work with.
                                    //....come up with something better..
                                    if client!.saber[saberNum].blade[bladeNum].trail.haveOldPos[i] {
                                        if trace.entityNum == ENTITYNUM_WORLD || cg_entities[trace.entityNum].currentState.eType == ET_TERRAIN || (cg_entities[trace.entityNum].currentState.eFlags & EF_PERMANENT) != 0 {
                                            //only put marks on architecture
                                            // Let's do some cool burn/glowing mark bits!!!
                                            CG_CreateSaberMarks(client!.saber[saberNum].blade[bladeNum].trail.oldPos[i], trace.endpos, trace.plane.normal)

                                            //make a sound
                                            if cg.time - client!.saber[saberNum].blade[bladeNum].hitWallDebounceTime >= 100 {
                                                //ugh, need to have a real sound debouncer... or do this game-side
                                                client!.saber[saberNum].blade[bladeNum].hitWallDebounceTime = cg.time
                                                trap_S_StartSound(&trace.endpos, -1, CHAN_WEAPON, trap_S_RegisterSound(va("sound/weapons/saber/saberhitwall%i", Q_irand(1, 3))))
                                            }
                                        }
                                    } else {
                                        // if we impact next frame, we'll mark a slash mark
                                        client!.saber[saberNum].blade[bladeNum].trail.haveOldPos[i] = true
                                        //				CG_ImpactMark( cgs.media.rivetMarkShader, client->saber[saberNum].blade[bladeNum].trail.oldPos[i], client->saber[saberNum].blade[bladeNum].trail.oldNormal[i],
                                        //						0.0f, 1.0f, 1.0f, 1.0f, 1.0f, qfalse, 1.1f, qfalse );
                                    }
                                }

                                // stash point so we can connect-the-dots later
                                client!.saber[saberNum].blade[bladeNum].trail.oldPos[i] = trace.endpos
                                client!.saber[saberNum].blade[bladeNum].trail.oldNormal[i] = trace.plane.normal
                            } else {
                                if client!.saber[saberNum].blade[bladeNum].trail.haveOldPos[i] {
                                    // Hmmm, no impact this frame, but we have an old point
                                    // Let's put the mark there, we should use an endcap mark to close the line, but we
                                    //	can probably just get away with a round mark
                                    //					CG_ImpactMark( cgs.media.rivetMarkShader, client->saber[saberNum].blade[bladeNum].trail.oldPos[i], client->saber[saberNum].blade[bladeNum].trail.oldNormal[i],
                                    //							0.0f, 1.0f, 1.0f, 1.0f, 1.0f, qfalse, 1.1f, qfalse );
                                }

                                // we aren't impacting, so turn off our mark tracking mechanism
                                client!.saber[saberNum].blade[bladeNum].trail.haveOldPos[i] = false
                            }
                            i += 1
                        }
                    }
                }

                JustDoIt: do {
                    if cg_saberTrail.integer == 0 {
                        //don't do the trail in this case
                        break JustDoIt
                    }

                    if (!WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) && client!.saber[saberNum].trailStyle > 1) || (WP_SaberBladeUseSecondBladeStyle(client!.saber[saberNum], bladeNum) && client!.saber[saberNum].trailStyle2 > 1) {
                        //don't actually draw the trail at all
                        break JustDoIt
                    }

                    //FIXME: if trailStyle is 1, use the motion blur instead

                    saberTrail = client!.saber[saberNum].blade[bladeNum].trail
                    saberTrail!.duration = (saberMoveData[cent.currentState.saberMove].trailLength ? 1 : 0)

                    trailDur = Int32((saberTrail!.duration / 5.0))
                    if trailDur == 0 {
                        //hmm.. ok, default
                        if BG_SuperBreakWinAnim(cent.currentState.torsoAnim) {
                            trailDur = 150
                        } else {
                            trailDur = Int32(SABER_TRAIL_TIME)
                        }
                    }

                    // if we happen to be timescaled or running in a high framerate situation, we don't want to flood
                    //	the system with very small trail slices...but perhaps doing it by distance would yield better results?
                    if cg.time > saberTrail!.lastTime + 2 || cg_saberTrail.integer == 2 {
                        if !dontDraw {
                            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int'".
                            // Raven wrote: if ( (BG_SuperBreakWinAnim(cent->currentState.torsoAnim) || saberMoveData[cent->currentState.saberMove].trailLength > 0 || ((cent->currentState.powerups & (1 << PW_SPEED) && cg_speedTrail.integer)) || (cent->currentState.saberInFlight && saberNum == 0)) && cg.time < saberTrail->lastTime + 2000 ) // if we have a stale segment, don't draw until we have a fresh one { #if 0 if (cg_saberTrail.integer == 2 && cg_shadows.integer != 2 && cgs.glconfig.stencilBits >= 4) { polyVert_t verts[4]; VectorCopy( org_, verts[0].xyz ); VectorMA( end, 3.0f, axis_[0], verts[1].xyz ); VectorCopy( saberTrail->tip, verts[2].xyz ); VectorCopy( saberTrail->base, verts[3].xyz ); //tc doesn't even matter since we're just gonna stencil an outline, but whatever. verts[0].st[0] = 0; verts[0].st[1] = 0; verts[0].modulate[0] = 255; verts[0].modulate[1] = 255; verts[0].modulate[2] = 255; verts[0].modulate[3] = 255; verts[1].st[0] = 0; verts[1].st[1] = 1; verts[1].modulate[0] = 255; verts[1].modulate[1] = 255; verts[1].modulate[2] = 255; verts[1].modulate[3] = 255; verts[2].st[0] = 1; verts[2].st[1] = 1; verts[2].modulate[0] = 255; verts[2].modulate[1] = 255; verts[2].modulate[2] = 255; verts[2].modulate[3] = 255; verts[3].st[0] = 1; verts[3].st[1] = 0; verts[3].modulate[0] = 255; verts[3].modulate[1] = 255; verts[3].modulate[2] = 255; verts[3].modulate[3] = 255; //don't capture postrender objects (now we'll postrender the saber so it doesn't get in the capture) trap_R_SetRefractProp(1.0f, 0.0f, qtrue, qtrue); //shader 2 is always the crazy refractive shader. trap_R_AddPolyToScene( 2, 4, verts ); } else #endif { vec3_t rgb1={255.0f,255.0f,255.0f}; switch( scolor ) { case SABER_RED: VectorSet( rgb1, 255.0f, 0.0f, 0.0f ); break; case SABER_ORANGE: VectorSet( rgb1, 255.0f, 64.0f, 0.0f ); break; case SABER_YELLOW: VectorSet( rgb1, 255.0f, 255.0f, 0.0f ); break; case SABER_GREEN: VectorSet( rgb1, 0.0f, 255.0f, 0.0f ); break; case SABER_BLUE: VectorSet( rgb1, 0.0f, 64.0f, 255.0f ); break; case SABER_PURPLE: VectorSet( rgb1, 220.0f, 0.0f, 255.0f ); break; default: VectorSet( rgb1, 0.0f, 64.0f, 255.0f ); break; } //Here we will use the happy process of filling a struct in with arguments and passing it to a trap function //so that we can take the struct and fill in an actual CTrail type using the data within it once we get it //into the effects area // Go from new muzzle to new end...then to old end...back down to old muzzle...finally // connect back to the new muzzle...this is our trail quad VectorCopy( org_, fx.mVerts[0].origin ); VectorMA( end, 3.0f, axis_[0], fx.mVerts[1].origin ); VectorCopy( saberTrail->tip, fx.mVerts[2].origin ); VectorCopy( saberTrail->base, fx.mVerts[3].origin ); diff = cg.time - saberTrail->lastTime; // I'm not sure that clipping this is really the best idea //This prevents the trail from showing at all in low framerate situations. //if ( diff <= SABER_TRAIL_TIME * 2 ) if ( diff <= 10000 ) { //don't draw it if the last time is way out of date float oldAlpha = 1.0f - ( diff / trailDur ); if (cg_saberTrail.integer == 2 && cg_shadows.integer != 2 && cgs.glconfig.stencilBits >= 4) {//does other stuff below } else { if ( (!WP_SaberBladeUseSecondBladeStyle( &client->saber[saberNum], bladeNum ) && client->saber[saberNum].trailStyle == 1 ) || ( WP_SaberBladeUseSecondBladeStyle( &client->saber[saberNum], bladeNum ) && client->saber[saberNum].trailStyle2 == 1 ) ) {//motion trail fx.mShader = cgs.media.swordTrailShader; VectorSet( rgb1, 32.0f, 32.0f, 32.0f ); // make the sith sword trail pretty faint trailDur *= 2.0f; // stay around twice as long? } else { fx.mShader = cgs.media.saberBlurShader; } fx.mKillTime = trailDur; fx.mSetFlags = FX_USE_ALPHA; } // New muzzle VectorCopy( rgb1, fx.mVerts[0].rgb ); fx.mVerts[0].alpha = 255.0f; fx.mVerts[0].ST[0] = 0.0f; fx.mVerts[0].ST[1] = 1.0f; fx.mVerts[0].destST[0] = 1.0f; fx.mVerts[0].destST[1] = 1.0f; // new tip VectorCopy( rgb1, fx.mVerts[1].rgb ); fx.mVerts[1].alpha = 255.0f; fx.mVerts[1].ST[0] = 0.0f; fx.mVerts[1].ST[1] = 0.0f; fx.mVerts[1].destST[0] = 1.0f; fx.mVerts[1].destST[1] = 0.0f; // old tip VectorCopy( rgb1, fx.mVerts[2].rgb ); fx.mVerts[2].alpha = 255.0f; fx.mVerts[2].ST[0] = 1.0f - oldAlpha; // NOTE: this just happens to contain the value I want fx.mVerts[2].ST[1] = 0.0f; fx.mVerts[2].destST[0] = 1.0f + fx.mVerts[2].ST[0]; fx.mVerts[2].destST[1] = 0.0f; // old muzzle VectorCopy( rgb1, fx.mVerts[3].rgb ); fx.mVerts[3].alpha = 255.0f; fx.mVerts[3].ST[0] = 1.0f - oldAlpha; // NOTE: this just happens to contain the value I want fx.mVerts[3].ST[1] = 1.0f; fx.mVerts[3].destST[0] = 1.0f + fx.mVerts[2].ST[0]; fx.mVerts[3].destST[1] = 1.0f; if (cg_saberTrail.integer == 2 && cg_shadows.integer != 2 && cgs.glconfig.stencilBits >= 4) { trap_R_SetRefractProp(1.0f, 0.0f, qtrue, qtrue); //don't need to do this every frame.. but.. if (BG_SaberInAttack(cent->currentState.saberMove) ||BG_SuperBreakWinAnim(cent->currentState.torsoAnim)) { //in attack, strong trail fx.mKillTime = 300; } else { //faded trail fx.mKillTime = 40; } fx.mShader = 2; //2 is always refractive shader fx.mSetFlags = FX_USE_ALPHA; } /* else { fx.mShader = cgs.media.saberBlurShader; fx.mKillTime = trailDur; fx.mSetFlags = FX_USE_ALPHA; } */ trap_FX_AddPrimitive(&fx); } } }
                            portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")
                        }

                        // we must always do this, even if we aren't active..otherwise we won't know where to pick up from
                        saberTrail!.base = org_
                        // Port-note: A read of `axis_`, a local the draft left as a hole.
                        // Raven wrote: VectorMA( end, 3.0f, axis_[0], saberTrail->tip )
                        portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")
                        saberTrail!.lastTime = cg.time
                    }

                }

                if dontDraw {
                    return true
                }

                if (client!.saber[saberNum].saberFlags2 & SFL2_NO_BLADE) != 0 {
                    //don't actually draw the blade at all
                    if client!.saber[saberNum].numBlades < 3 && !((client!.saber[saberNum].saberFlags2 & SFL2_NO_DLIGHT) != 0) {
                        //hmm, but still add the dlight
                        CG_DoSaberLight(client!.saber[saberNum])
                    }
                    return true
                }
                // Pass in the renderfx flags attached to the saber weapon model...this is done so that saber glows
                //	will get rendered properly in a mirror...not sure if this is necessary??
                //CG_DoSaber( org_, axis_[0], saberLen, client->saber[saberNum].blade[bladeNum].lengthMax, client->saber[saberNum].blade[bladeNum].radius,
                //	scolor, renderfx, (qboolean)(saberNum==0&&bladeNum==0) );
                // Port-note: A read of `axis_`, a local the draft left as a hole.
                // Raven wrote: CG_DoSaber( org_, axis_[0], saberLen, client->saber[saberNum].blade[bladeNum].lengthMax, client->saber[saberNum].blade[bladeNum].radius, scolor, renderfx, (qboolean)(client->saber[saberNum].numBlades < 3 && !(client->saber[saberNum].saberFlags2&SFL2_NO_DLIGHT)) )
                portMissing("CG_AddSaberBlade", source: "oracle/codemp/cgame/cg_players.c:5993")
                return false
            }
            if earlyOut3 {
                return true
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:6482
func CG_IsMindTricked(_ trickIndex1: Int32, _ trickIndex2: Int32, _ trickIndex3: Int32, _ trickIndex4: Int32, _ client: Int32) -> Int32 {
    var checkIn: Int32
    var sub: Int32 = 0

    if (cg_entities[client].currentState.forcePowersActive & (1 << FP_SEE)) != 0 {
        return 0
    }

    if client > 47 {
        checkIn = trickIndex4
        sub = 48
    } else if client > 31 {
        checkIn = trickIndex3
        sub = 32
    } else if client > 15 {
        checkIn = trickIndex2
        sub = 16
    } else {
        checkIn = trickIndex1
    }

    if (checkIn & (1 << (client - sub))) != 0 {
        return 1
    }

    return 0
}

/// Source: oracle/codemp/cgame/cg_players.c:6522
func CG_DrawPlayerSphere(_ cent: Centity, _ origin: JKAShared.vec3_t, _ scale: Float, _ shader: Int32) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { ent -> Bool in
        var ang = vec3_t()
        var vLen: Float = 0
        var viewDir = vec3_t()

        // Don't draw the shield when the player is dead.
        if (cent.currentState.eFlags & EF_DEAD) != 0 {
            return true
        }

        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

        ent.origin = origin
        ent.origin[2] = Float(Double(ent.origin[2]) + 9.0)

        ent.axis[0] = ent.origin - cg.refdef.vieworg
        vLen = VectorLength(ent.axis[0])
        if vLen <= 0.1 {
            // Entity is right on vieworg.  quit.
            return true
        }

        viewDir = ent.axis[0]
        VectorInverse(&viewDir)
        VectorNormalize(&viewDir)

        vectoangles(ent.axis[0], &ang)
        ang[ROLL] += 180.0
        ang[PITCH] += 180.0
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis(ang, ent.axis)
        portMissing("CG_DrawPlayerSphere", source: "oracle/codemp/cgame/cg_players.c:6522")

        ent.axis[0] = ent.axis[0] * scale
        ent.axis[1] = ent.axis[1] * scale
        ent.axis[2] = ent.axis[2] * scale

        ent.nonNormalizedAxes = true

        ent.hModel = cgs.media.halfShieldModel
        ent.customShader = shader

        trap_R_AddRefEntityToScene(ent)

        if !cg.renderingThirdPerson && cent.currentState.number == cg.predictedPlayerState.clientNum {
            //don't do the rest then
            return true
        }
        if cg_renderToTextureFX.integer == 0 {
            return true
        }

        ang[PITCH] -= 180.0
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>') to expected argument type '[vec3_t]' (aka 'Array<SIMD3<Float>>')".
        // Raven wrote: AnglesToAxis(ang, ent.axis)
        portMissing("CG_DrawPlayerSphere", source: "oracle/codemp/cgame/cg_players.c:6522")

        ent.axis[0] = ent.axis[0] * (scale * 0.5)
        ent.axis[1] = ent.axis[1] * (scale * 0.5)
        ent.axis[2] = ent.axis[2] * (scale * 0.5)

        ent.renderfx = (RF_DISTORTION | RF_FORCE_ENT_ALPHA)
        if shader == cgs.media.invulnerabilityShader {
            //ok, ok, this is a little hacky. sorry!
            ent.shaderRGBA[0] = 0
            ent.shaderRGBA[1] = 255
            ent.shaderRGBA[2] = 0
            ent.shaderRGBA[3] = 100
        } else if shader == cgs.media.ysalimariShader {
            ent.shaderRGBA[0] = 255
            ent.shaderRGBA[1] = 255
            ent.shaderRGBA[2] = 0
            ent.shaderRGBA[3] = 100
        } else if shader == cgs.media.endarkenmentShader {
            ent.shaderRGBA[0] = 100
            ent.shaderRGBA[1] = 0
            ent.shaderRGBA[2] = 0
            ent.shaderRGBA[3] = 20
        } else if shader == cgs.media.enlightenmentShader {
            ent.shaderRGBA[0] = 255
            ent.shaderRGBA[1] = 255
            ent.shaderRGBA[2] = 255
            ent.shaderRGBA[3] = 20
        } else {
            //ysal red/blue, boon
            ent.shaderRGBA[0] = 255
            ent.shaderRGBA[1] = 255
            ent.shaderRGBA[2] = 255
            ent.shaderRGBA[3] = 20
        }

        ent.radius = 256

        _VectorMA(ent.origin, 40.0, viewDir, &ent.origin)

        ent.customShader = trap_R_RegisterShader("effects/refract_2")
        trap_R_AddRefEntityToScene(ent)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:6628
func CG_AddLightningBeam(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    var dir = vec3_t()
    var chaos = vec3_t()
    var c1 = vec3_t()
    var c2 = vec3_t()
    var v1 = vec3_t()
    var v2 = vec3_t()
    var len: Float = 0
    var s1: Float = 0
    var s2: Float = 0
    var s3: Float = 0

    // Raven's record lives to the end of his block, so the block is the closure.
    AddbezierArgStruct.scratch { b in

        b.start = start
        b.end = end

        dir = b.end - b.start
        len = VectorNormalize(&dir)

        // Get the base control points, we'll work from there
        _VectorMA(b.start, 0.3333 * len, dir, &c1)
        _VectorMA(b.start, 0.6666 * len, dir, &c2)

        // get some chaos values that really aren't very chaotic :)
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
        // Raven wrote: s1 = sin( cg.time * 0.005f ) * 2 + crandom() * 0.2f
        portMissing("CG_AddLightningBeam", source: "oracle/codemp/cgame/cg_players.c:6628")
        s2 = sin(cg.time * 0.001)
        s3 = sin(cg.time * 0.011)

        chaos = vec3_t(len * 0.01 * s1, len * 0.02 * s2, len * 0.04 * (s1 + s2 + s3))

        c1 = c1 + chaos
        v1 = chaos * 4.0

        chaos = vec3_t(-len * 0.02 * s3, len * 0.01 * (s1 * s2), -len * 0.02 * (s1 + s2 * s3))

        c2 = c2 + chaos
        v2 = chaos * 2.0

        chaos = vec3_t(1.0, 1.0, 1.0)

        b.control1 = c1
        b.control1Vel = vec3_origin
        b.control2 = c2
        b.control2Vel = vec3_origin

        b.size1 = 6.0
        b.size2 = 6.0
        b.sizeParm = 0.0
        b.alpha1 = 0.0
        b.alpha2 = 0.2
        b.alphaParm = 0.5

        /*
        VectorCopy(WHITE, b.sRGB);
        VectorCopy(WHITE, b.eRGB);
        */

        b.sRGB[0] = 255
        b.sRGB[1] = 255
        b.sRGB[2] = 255
        b.eRGB = b.sRGB

        b.rgbParm = 0.0
        b.killTime = 50
        b.shader = trap_R_RegisterShader("gfx/misc/electric2")
        b.flags = 0x00000001 //FX_ALPHA_LINEAR

        trap_FX_AddBezier(b)
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:6699
func CG_AddRandomLightning(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t) {
    var inOrg = vec3_t()
    var outOrg = vec3_t()

    inOrg = start
    outOrg = end

    // The SDK also declares `rand`, so the call names the bg module.
    if (JKAMP_BG.rand() & 1) != 0 {
        outOrg[0] += Q_irand(0, 24)
        inOrg[0] += Q_irand(0, 8)
    } else {
        outOrg[0] -= Q_irand(0, 24)
        inOrg[0] -= Q_irand(0, 8)
    }

    // The SDK also declares `rand`, so the call names the bg module.
    if (JKAMP_BG.rand() & 1) != 0 {
        outOrg[1] += Q_irand(0, 24)
        inOrg[1] += Q_irand(0, 8)
    } else {
        outOrg[1] -= Q_irand(0, 24)
        inOrg[1] -= Q_irand(0, 8)
    }

    // The SDK also declares `rand`, so the call names the bg module.
    if (JKAMP_BG.rand() & 1) != 0 {
        outOrg[2] += Q_irand(0, 50)
        inOrg[2] += Q_irand(0, 40)
    } else {
        outOrg[2] -= Q_irand(0, 64)
        inOrg[2] -= Q_irand(0, 40)
    }

    CG_AddLightningBeam(inOrg, outOrg)
}

/// Source: oracle/codemp/cgame/cg_players.c:6744
func CG_ThereIsAMaster() -> Bool {
    var i: Int32 = 0
    var cent: Centity?

    while i < MAX_CLIENTS {
        cent = cg_entities[i]

        if cent != nil && cent!.currentState.isJediMaster {
            return true
        }

        i += 1
    }

    return false
}

//Checks to see if the model string has a * appended with a custom skin name after.
//If so, it terminates the model string correctly, parses the skin name out, and returns
//the handle of the registered skin.
/// Source: oracle/codemp/cgame/cg_players.c:6817
func CG_HandleAppendedSkin(_ modelName: String) -> Int32 {
    var skinName = CharBuf(64)
    // Port-note: A pointer local `char * p` with no view.
    // Raven wrote: char *p;
    portMissing("CG_HandleAppendedSkin", source: "oracle/codemp/cgame/cg_players.c:6817")
    var skinID: qhandle_t = 0
    var i: Int32 = 0

    //see if it has a skin name
    // Port-note: A store into `p`, a local the draft left as a hole.
    // Raven wrote: p = Q_strrchr(modelName, '*')
    portMissing("CG_HandleAppendedSkin", source: "oracle/codemp/cgame/cg_players.c:6817")

    // Port-note: A read of `p`, a local the draft left as a hole.
    // Raven wrote: if (p) { //found a *, we should have a model name before it and a skin name after it. *p = 0; //terminate the modelName string at this point, then go ahead and parse to the next 0 for the skin. p++; while (p && *p) { skinName[i] = *p; i++; p++; } skinName[i] = 0; if (skinName[0]) { //got it, register the skin under the model path. char baseFolder[MAX_QPATH]; strcpy(baseFolder, modelName); p = Q_strrchr(baseFolder, '/'); //go back to the first /, should be the path point if (p) { //got it.. terminate at the slash and register. char *useSkinName; *p = 0; if (strchr(skinName, '|')) {//three part skin useSkinName = va("%s/|%s", baseFolder, skinName); } else { useSkinName = va("%s/model_%s.skin", baseFolder, skinName); } skinID = trap_R_RegisterSkin(useSkinName); } } }
    portMissing("CG_HandleAppendedSkin", source: "oracle/codemp/cgame/cg_players.c:6817")

    return skinID
}

/// Source: oracle/codemp/cgame/cg_players.c:6876
func CG_CacheG2AnimInfo(_ modelName: String) {
    var g2: OpaquePointer? = nil
    // Port-note: A pointer local `char * slash` with no view.
    // Raven wrote: char *slash;
    portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")
    var useModel = CharBuf(64)
    var useSkin = CharBuf(64)
    var animIndex: Int32

    strcpy(&useModel, modelName)
    strcpy(&useSkin, modelName)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "binary operator '==' cannot be applied to operands of type 'Character' and 'Int32'".
    // Raven wrote: if (modelName[0] == '$') { //it's a vehicle name actually, let's precache the whole vehicle BG_GetVehicleModelName(useModel); BG_GetVehicleSkinName(useSkin); if ( useSkin[0] ) { //use a custom skin trap_R_RegisterSkin(va("models/players/%s/model_%s.skin", useModel, useSkin)); } else { trap_R_RegisterSkin(va("models/players/%s/model_default.skin", useModel)); } strcpy(useModel, va("models/players/%s/model.glm", useModel)); }
    portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")

    trap_G2API_InitGhoul2Model(&g2, String(useModel), 0, 0, 0, 0, 0)

    if g2 != nil {
        var GLAName = CharBuf(64)
        var originalModelName = CharBuf(64)

        animIndex = -1

        GLAName[0] = 0
        strcpy(&GLAName, trap_G2API_GetGLAName(g2, 0))

        strcpy(&originalModelName, useModel)

        // Port-note: A store into `slash`, a local the draft left as a hole.
        // Raven wrote: slash = Q_strrchr( GLAName, '/' )
        portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")
        // Port-note: A read of `slash`, a local the draft left as a hole.
        // Raven wrote: if ( slash ) { strcpy(slash, "/animation.cfg"); animIndex = BG_ParseAnimationFile(GLAName, NULL, qfalse); }
        portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")

        if animIndex != -1 {
            // Port-note: A store into `slash`, a local the draft left as a hole.
            // Raven wrote: slash = Q_strrchr( originalModelName, '/' )
            portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")
            // Port-note: A read of `slash`, a local the draft left as a hole.
            // Raven wrote: if ( slash ) { slash++; *slash = 0; }
            portMissing("CG_CacheG2AnimInfo", source: "oracle/codemp/cgame/cg_players.c:6876")

            BG_ParseAnimationEvtFile(String(originalModelName), animIndex, bgNumAnimEvents)
        }

        //Now free the temp instance
        trap_G2API_CleanGhoul2Models(&g2)
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:6941
private func CG_RegisterVehicleAssets(_ pVeh: JKAMP.Vehicle) {
    /*
    if ( pVeh->m_pVehicleInfo->exhaustFX )
    {
    pVeh->m_pVehicleInfo->iExhaustFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->exhaustFX );
    }
    if ( pVeh->m_pVehicleInfo->trailFX )
    {
    pVeh->m_pVehicleInfo->iTrailFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->trailFX );
    }
    if ( pVeh->m_pVehicleInfo->impactFX )
    {
    pVeh->m_pVehicleInfo->iImpactFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->impactFX );
    }
    if ( pVeh->m_pVehicleInfo->explodeFX )
    {
    pVeh->m_pVehicleInfo->iExplodeFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->explodeFX );
    }
    if ( pVeh->m_pVehicleInfo->wakeFX )
    {
    pVeh->m_pVehicleInfo->iWakeFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->wakeFX );
    }

    if ( pVeh->m_pVehicleInfo->dmgFX )
    {
    pVeh->m_pVehicleInfo->iDmgFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->dmgFX );
    }
    if ( pVeh->m_pVehicleInfo->wpn1FX )
    {
    pVeh->m_pVehicleInfo->iWpn1FX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->wpn1FX );
    }
    if ( pVeh->m_pVehicleInfo->wpn2FX )
    {
    pVeh->m_pVehicleInfo->iWpn2FX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->wpn2FX );
    }
    if ( pVeh->m_pVehicleInfo->wpn1FireFX )
    {
    pVeh->m_pVehicleInfo->iWpn1FireFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->wpn1FireFX );
    }
    if ( pVeh->m_pVehicleInfo->wpn2FireFX )
    {
    pVeh->m_pVehicleInfo->iWpn2FireFX = trap_FX_RegisterEffect( pVeh->m_pVehicleInfo->wpn2FireFX );
    }
    */
}

/// Source: oracle/codemp/cgame/cg_players.c:6998
func CG_G2AnimEntModelLoad(_ cent: Centity) {
    let cModelName: String = CG_ConfigString(CS_MODELS + cent.currentState.modelindex)

    if cent.npcClient == nil {
        //have not init'd client yet
        return
    }

    if !cModelName.isEmpty {
        var modelName = CharBuf(64)
        var skinID: Int32
        // Port-note: A pointer local `char * slash` with no view.
        // Raven wrote: char *slash;
        portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")

        strcpy(&modelName, cModelName)

        if cent.currentState.NPC_class == CLASS_VEHICLE && modelName[0] == Int32(ascii: "$") {
            //vehicles pass their veh names over as model names, then we get the model name from the veh type
            //create a vehicle object clientside for this type
            let vehType: CharBuf = modelName[(1)...]
            let iVehIndex: Int32 = BG_VehicleGetIndex(String(vehType))

            switch g_vehicleInfo[iVehIndex].type {
            case VH_ANIMAL:
                // Create the animal (making sure all it's data is initialized).
                G_CreateAnimalNPC(&cent.m_pVehicle, String(vehType))

            case VH_SPEEDER:
                // Create the speeder (making sure all it's data is initialized).
                G_CreateSpeederNPC(&cent.m_pVehicle, String(vehType))

            case VH_FIGHTER:
                // Create the fighter (making sure all it's data is initialized).
                G_CreateFighterNPC(&cent.m_pVehicle, String(vehType))

            case VH_WALKER:
                // Create the walker (making sure all it's data is initialized).
                G_CreateWalkerNPC(&cent.m_pVehicle, String(vehType))

            default:
                break
            }

            //set up my happy prediction hack
            // Port-note: Raven stores a pointer into the `float *` field with `cent->m_pVehicle->m_vOrientation = &cgSendPS[cent->currentState.number]->vehOrientation[0]`, and rule 11 keeps a pointer out of a logic target.
            // Raven wrote: cent->m_pVehicle->m_vOrientation = &cgSendPS[cent->currentState.number]->vehOrientation[0]
            portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")

            cent.m_pVehicle!.m_pParentEntity = BgEntity(cent)

            //attach the handles for fx cgame-side
            CG_RegisterVehicleAssets(cent.m_pVehicle!)

            BG_GetVehicleModelName(&modelName)
            if cent.m_pVehicle!.m_pVehicleInfo!.skin != nil && !cent.m_pVehicle!.m_pVehicleInfo!.skin!.isEmpty {
                //use a custom skin
                skinID = trap_R_RegisterSkin(va("models/players/%s/model_%s.skin", modelName, cent.m_pVehicle!.m_pVehicleInfo!.skin!))
            } else {
                skinID = trap_R_RegisterSkin(va("models/players/%s/model_default.skin", modelName))
            }
            strcpy(&modelName, va("models/players/%s/model.glm", modelName))

            //this sound is *only* used for vehicles now
            cgs.media.noAmmoSound = trap_S_RegisterSound("sound/weapons/noammo.wav")
        } else {
            skinID = CG_HandleAppendedSkin(String(modelName)) //get the skin if there is one.
        }

        if cent.ghoul2 != nil {
            //clean it first!
            trap_G2API_CleanGhoul2Models(&cent.ghoul2)
        }

        trap_G2API_InitGhoul2Model(&cent.ghoul2, String(modelName), 0, skinID, 0, 0, 0)

        if cent.ghoul2 != nil {
            var GLAName = CharBuf(64)
            var originalModelName = CharBuf(64)
            // Port-note: A pointer local `char * saber` with no view.
            // Raven wrote: char *saber;
            portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
            var j: Int32 = 0

            if cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil {
                //do special vehicle stuff
                var strTemp = CharBuf(128)
                var i: Int32

                // Setup the default first bolt
                i = trap_G2API_AddBolt(cent.ghoul2, 0, "model_root")

                // Setup the droid unit.
                cent.m_pVehicle!.m_iDroidUnitTag = trap_G2API_AddBolt(cent.ghoul2, 0, "*droidunit")

                // Setup the Exhausts.
                i = 0
                while i < MAX_VEHICLE_EXHAUSTS {
                    Com_sprintf(&strTemp, 128, "*exhaust%i", i + 1)
                    cent.m_pVehicle!.m_iExhaustTag[i] = trap_G2API_AddBolt(cent.ghoul2, 0, String(strTemp))
                    i += 1
                }

                // Setup the Muzzles.
                i = 0
                while i < MAX_VEHICLE_MUZZLES {
                    Com_sprintf(&strTemp, 128, "*muzzle%i", i + 1)
                    cent.m_pVehicle!.m_iMuzzleTag[i] = trap_G2API_AddBolt(cent.ghoul2, 0, String(strTemp))
                    if cent.m_pVehicle!.m_iMuzzleTag[i] == -1 {
                        //ergh, try *flash?
                        Com_sprintf(&strTemp, 128, "*flash%i", i + 1)
                        cent.m_pVehicle!.m_iMuzzleTag[i] = trap_G2API_AddBolt(cent.ghoul2, 0, String(strTemp))
                    }
                    i += 1
                }

                // Setup the Turrets.
                i = 0
                while i < MAX_VEHICLE_TURRETS {
                    if cent.m_pVehicle!.m_pVehicleInfo!.turret[i].gunnerViewTag != nil {
                        cent.m_pVehicle!.m_iGunnerViewTag[i] = trap_G2API_AddBolt(cent.ghoul2, 0, cent.m_pVehicle!.m_pVehicleInfo!.turret[i].gunnerViewTag!)
                    } else {
                        cent.m_pVehicle!.m_iGunnerViewTag[i] = -1
                    }
                    i += 1
                }
            }

            if cent.currentState.npcSaber1 != 0 {
                // Port-note: A store into `saber`, a local the draft left as a hole.
                // Raven wrote: saber = (char *)CG_ConfigString(CS_MODELS+cent->currentState.npcSaber1)
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
                //valid saber names should always start with '@' for NPCs

                // Port-note: A read of `saber`, a local the draft left as a hole.
                // Raven wrote: if (saber && saber[0]) { saber++; //skip over the @ WP_SetSaber(cent->currentState.number, cent->npcClient->saber, 0, saber); }
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
            }
            if cent.currentState.npcSaber2 != 0 {
                // Port-note: A store into `saber`, a local the draft left as a hole.
                // Raven wrote: saber = (char *)CG_ConfigString(CS_MODELS+cent->currentState.npcSaber2)
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
                //valid saber names should always start with '@' for NPCs

                // Port-note: A read of `saber`, a local the draft left as a hole.
                // Raven wrote: if (saber && saber[0]) { saber++; //skip over the @ WP_SetSaber(cent->currentState.number, cent->npcClient->saber, 1, saber); }
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
            }

            // If this is a not vehicle, give it saber stuff...
            if cent.currentState.NPC_class != CLASS_VEHICLE {
                while j < MAX_SABERS {
                    if !cent.npcClient!.saber[j].model.isEmpty {
                        if cent.npcClient!.ghoul2Weapons[j] != nil {
                            //free the old instance(s)
                            trap_G2API_CleanGhoul2Models(&cent.npcClient!.ghoul2Weapons[j])
                            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int' to subscript of type 'OpaquePointer'".
                            // Raven wrote: cent->npcClient->ghoul2Weapons[j] = 0
                            portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
                        }

                        CG_InitG2SaberData(j, cent.npcClient!)
                    }
                    j += 1
                }
            }

            trap_G2API_SetSkin(cent.ghoul2, 0, skinID, skinID)

            cent.localAnimIndex = -1

            GLAName[0] = 0
            strcpy(&GLAName, trap_G2API_GetGLAName(cent.ghoul2, 0))

            strcpy(&originalModelName, modelName)

            if GLAName[0] != 0 && strstr(GLAName, "players/_humanoid/") == nil {
                //it doesn't use humanoid anims.
                // Port-note: A store into `slash`, a local the draft left as a hole.
                // Raven wrote: slash = Q_strrchr( GLAName, '/' )
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
                // Port-note: A read of `slash`, a local the draft left as a hole.
                // Raven wrote: if ( slash ) { strcpy(slash, "/animation.cfg"); cent->localAnimIndex = BG_ParseAnimationFile(GLAName, NULL, qfalse); }
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
            } else {
                //humanoid index.
                trap_G2API_AddBolt(cent.ghoul2, 0, "*r_hand")
                trap_G2API_AddBolt(cent.ghoul2, 0, "*l_hand")

                //rhand must always be first bolt. lhand always second. Whichever you want the
                //jetpack bolted to must always be third.
                trap_G2API_AddBolt(cent.ghoul2, 0, "*chestg")

                //claw bolts
                trap_G2API_AddBolt(cent.ghoul2, 0, "*r_hand_cap_r_arm")
                trap_G2API_AddBolt(cent.ghoul2, 0, "*l_hand_cap_l_arm")

                if strstr(GLAName, "players/rockettrooper/") != nil {
                    cent.localAnimIndex = 1
                } else {
                    cent.localAnimIndex = 0
                }

                if trap_G2API_AddBolt(cent.ghoul2, 0, "*head_top") == -1 {
                    trap_G2API_AddBolt(cent.ghoul2, 0, "ceyebrow")
                }
                trap_G2API_AddBolt(cent.ghoul2, 0, "Motion")
            }

            // If this is a not vehicle...
            if cent.currentState.NPC_class != CLASS_VEHICLE {
                if trap_G2API_AddBolt(cent.ghoul2, 0, "lower_lumbar") == -1 {
                    //check now to see if we have this bone for setting anims and such
                    cent.noLumbar = true
                }

                if trap_G2API_AddBolt(cent.ghoul2, 0, "face") == -1 {
                    //check now to see if we have this bone for setting anims and such
                    cent.noFace = true
                }
            } else {
                cent.noLumbar = true
                cent.noFace = true
            }

            if cent.localAnimIndex != -1 {
                // Port-note: A store into `slash`, a local the draft left as a hole.
                // Raven wrote: slash = Q_strrchr( originalModelName, '/' )
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")
                // Port-note: A read of `slash`, a local the draft left as a hole.
                // Raven wrote: if ( slash ) { slash++; *slash = 0; }
                portMissing("CG_G2AnimEntModelLoad", source: "oracle/codemp/cgame/cg_players.c:6998")

                cent.eventAnimIndex = BG_ParseAnimationEvtFile(String(originalModelName), cent.localAnimIndex, bgNumAnimEvents)
            }
        }
    }

    trap_S_ShutUp(true)
    CG_HandleNPCSounds(cent) //handle sound loading here as well.
    trap_S_ShutUp(false)
}

//for now this is just gonna create a big explosion on the area of the surface,
//because I am lazy.
/// Source: oracle/codemp/cgame/cg_players.c:7266
private func CG_CreateSurfaceDebris(_ cent: Centity, _ surfNum: Int32, _ fxID: Int32, _ throwPart: Bool) {
    var lostPartFX: Int32 = 0
    var b: Int32 = -1
    var v = vec3_t()
    var d = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        // Port-note: A pointer local `const char * surfName` with no view.
        // Raven wrote: const char *surfName = NULL;
        portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")

        if surfNum > 0 {
            // Port-note: A store into `surfName`, a local the draft left as a hole.
            // Raven wrote: surfName = bgToggleableSurfaces[surfNum]
            portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
        }

        if cent.ghoul2 == nil {
            //oh no
            return true
        }

        //let's add the surface as a bolt so we can get the base point of it
        // Port-note: A read of `surfName`, a local the draft left as a hole.
        // Raven wrote: if (bgToggleableSurfaceDebris[surfNum] == 3) { //right wing flame b = trap_G2API_AddBolt(cent->ghoul2, 0, "*r_wingdamage"); if ( throwPart && cent->m_pVehicle && cent->m_pVehicle->m_pVehicleInfo ) { lostPartFX = cent->m_pVehicle->m_pVehicleInfo->iRWingFX; } } else if (bgToggleableSurfaceDebris[surfNum] == 4) { //left wing flame b = trap_G2API_AddBolt(cent->ghoul2, 0, "*l_wingdamage"); if ( throwPart && cent->m_pVehicle && cent->m_pVehicle->m_pVehicleInfo ) { lostPartFX = cent->m_pVehicle->m_pVehicleInfo->iLWingFX; } } else if (bgToggleableSurfaceDebris[surfNum] == 5) { //right wing flame 2 b = trap_G2API_AddBolt(cent->ghoul2, 0, "*r_wingdamage"); if ( throwPart && cent->m_pVehicle && cent->m_pVehicle->m_pVehicleInfo ) { lostPartFX = cent->m_pVehicle->m_pVehicleInfo->iRWingFX; } } else if (bgToggleableSurfaceDebris[surfNum] == 6) { //left wing flame 2 b = trap_G2API_AddBolt(cent->ghoul2, 0, "*l_wingdamage"); if ( throwPart && cent->m_pVehicle && cent->m_pVehicle->m_pVehicleInfo ) { lostPartFX = cent->m_pVehicle->m_pVehicleInfo->iLWingFX; } } else if (bgToggleableSurfaceDebris[surfNum] == 7) { //nose flame b = trap_G2API_AddBolt(cent->ghoul2, 0, "*nosedamage"); if ( cent->m_pVehicle && cent->m_pVehicle->m_pVehicleInfo ) { lostPartFX = cent->m_pVehicle->m_pVehicleInfo->iNoseFX; } } else if ( surfName ) { b = trap_G2API_AddBolt(cent->ghoul2, 0, surfName); }
        portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")

        if b == -1 || surfNum == -1 {
            //couldn't find this surface apparently, so play on origin?
            v = cent.lerpOrigin
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
            var scratchRight = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
            var scratchUp = vec3_t()
            AngleVectors(cent.lerpAngles, &d, &scratchRight, &scratchUp)
            VectorNormalize(&d)
        } else {
            //now let's get the position and direction of this surface and make a big explosion
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, b, &boltMatrix, cent->lerpAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
            portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &v)
            BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &d)
        }

        trap_FX_PlayEffectID(fxID, &v, &d, -1, -1)
        if throwPart && lostPartFX != 0 {
            //throw off a ship part, too
            var fxFwd = vec3_t()
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
            var scratchRight2 = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("CG_CreateSurfaceDebris", source: "oracle/codemp/cgame/cg_players.c:7266")
            var scratchUp2 = vec3_t()
            AngleVectors(cent.lerpAngles, &fxFwd, &scratchRight2, &scratchUp2)
            trap_FX_PlayEffectID(lostPartFX, &v, &fxFwd, -1, -1)
        }
        return false
    }
    if earlyOut {
        return
    }
}

//for now this is just gonna create a big explosion on the area of the surface,
//because I am lazy.
/// Source: oracle/codemp/cgame/cg_players.c:7365
private func CG_CreateSurfaceSmoke(_ cent: Centity, _ shipSurf: Int32, _ fxID: Int32) {
    var b: Int32 = -1
    var v = vec3_t()
    var d = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = MdxaBone.scratch { boltMatrix -> Bool in
        var surfName: String? = nil

        if cent.ghoul2 == nil {
            //oh no
            return true
        }

        //let's add the surface as a bolt so we can get the base point of it
        if shipSurf == SHIPSURF_FRONT {
            //front flame/smoke
            surfName = "*nosedamage"
        } else if shipSurf == SHIPSURF_BACK {
            //back flame/smoke
            surfName = "*exhaust1" //FIXME: random?  Some point in-between?
        } else if shipSurf == SHIPSURF_RIGHT {
            //right wing flame/smoke
            surfName = "*r_wingdamage"
        } else if shipSurf == SHIPSURF_LEFT {
            //left wing flame/smoke
            surfName = "*l_wingdamage"
        } else {
            //unknown surf!
            return true
        }
        b = trap_G2API_AddBolt(cent.ghoul2, 0, surfName!)
        if b == -1 {
            //couldn't find this surface apparently
            return true
        }

        //now let's get the position and direction of this surface and make a big explosion
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
        // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, b, &boltMatrix, cent->lerpAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
        portMissing("CG_CreateSurfaceSmoke", source: "oracle/codemp/cgame/cg_players.c:7365")
        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &v)
        BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_Z, &d)

        trap_FX_PlayEffectID(fxID, &v, &d, -1, -1)
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:7415
func CG_VehicleShouldDrawShields(_ vehCent: Centity) -> Bool {
    if vehCent.damageTime > cg.time && vehCent.currentState.NPC_class == CLASS_VEHICLE && vehCent.m_pVehicle != nil && vehCent.m_pVehicle!.m_pVehicleInfo != nil {
        return true
    }
    return false
}

/**
```
extern	vmCvar_t		cg_showVehBounds;
extern void BG_VehicleAdjustBBoxForOrientation( Vehicle_t *veh, vec3_t origin, vec3_t mins, vec3_t maxs,
										int clientNum, int tracemask,
										void (*localTrace)(trace_t *results, const vec3_t start, const vec3_t mins, const vec3_t maxs, const vec3_t end, int passEntityNum, int contentMask)); // bg_pmove.c
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:7433
func CG_VehicleAttachDroidUnit(_ droidCent: Centity, _ legs: JKAMP.RefEntity) -> Bool {
    if droidCent.currentState.owner != 0 && droidCent.currentState.clientNum >= MAX_CLIENTS {
        //the only NPCs that can ride a vehicle are droids...???
        let vehCent: Centity? = cg_entities[droidCent.currentState.owner]
        if vehCent != nil && vehCent!.m_pVehicle != nil && vehCent!.ghoul2 != nil && vehCent!.m_pVehicle!.m_iDroidUnitTag != -1 {
            // Raven's record lives to the end of his block, so the block is the closure.
            // Every path of Raven's block returns, so the closure's value is the function's.
            return MdxaBone.scratch { boltMatrix -> Bool in
                var fwd = vec3_t()
                var rt = vec3_t()
                var tempAng = vec3_t()

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                // Raven wrote: trap_G2API_GetBoltMatrix(vehCent->ghoul2, 0, vehCent->m_pVehicle->m_iDroidUnitTag, &boltMatrix, vehCent->lerpAngles, vehCent->lerpOrigin, cg.time, cgs.gameModels, vehCent->modelScale)
                portMissing("CG_VehicleAttachDroidUnit", source: "oracle/codemp/cgame/cg_players.c:7433")
                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &droidCent.lerpOrigin)
                BG_GiveMeVectorFromMatrix(boltMatrix, POSITIVE_X, &fwd) //WTF???
                BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &rt) //WTF???
                vectoangles(fwd, &droidCent.lerpAngles)
                vectoangles(rt, &tempAng)
                droidCent.lerpAngles[ROLL] = tempAng[PITCH]

                return true
            }
        }
    }
    return false
}

/// Source: oracle/codemp/cgame/cg_players.c:7463
func CG_G2Animated(_ cent: Centity) {
    let angSmoothFactor: Float = 0.7


    if cent.ghoul2 == nil {
        //Initialize this g2 anim ent, then return (will start rendering next frame)
        CG_G2AnimEntModelLoad(cent)
        cent.npcLocalSurfOff = 0
        cent.npcLocalSurfOn = 0
        return
    }

    if cent.npcLocalSurfOff != cent.currentState.surfacesOff || cent.npcLocalSurfOn != cent.currentState.surfacesOn {
        //looks like it's time for an update.
        var i: Int32 = 0

        while i < BG_NUM_TOGGLEABLE_SURFACES && bgToggleableSurfaces[i] != nil {
            if !((cent.npcLocalSurfOff & (1 << i)) != 0) && (cent.currentState.surfacesOff & (1 << i)) != 0 {
                //it wasn't off before but it's off now, so reflect this change in the g2 instance.
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'bgToggleableSurfaceDebris' in scope".
                // Raven wrote: if (bgToggleableSurfaceDebris[i] > 0) { //make some local debris of this thing? //FIXME: throw off the proper model effect, too CG_CreateSurfaceDebris(cent, i, cgs.effects.mShipDestDestroyed, qtrue); }
                portMissing("CG_G2Animated", source: "oracle/codemp/cgame/cg_players.c:7463")

                trap_G2API_SetSurfaceOnOff(cent.ghoul2, bgToggleableSurfaces[i], TURN_OFF)
            }

            if !((cent.npcLocalSurfOn & (1 << i)) != 0) && (cent.currentState.surfacesOn & (1 << i)) != 0 {
                //same as above, but on instead of off.
                trap_G2API_SetSurfaceOnOff(cent.ghoul2, bgToggleableSurfaces[i], TURN_ON)
            }

            i += 1
        }

        cent.npcLocalSurfOff = cent.currentState.surfacesOff
        cent.npcLocalSurfOn = cent.currentState.surfacesOn
    }


    /*
    if (cent->currentState.weapon &&
    !trap_G2API_HasGhoul2ModelOnIndex(&(cent->ghoul2), 1) &&
    !(cent->currentState.eFlags & EF_DEAD))
    { //if the server says we have a weapon and we haven't copied one onto ourselves yet, then do so.
    trap_G2API_CopySpecificGhoul2Model(g2WeaponInstances[cent->currentState.weapon], 0, cent->ghoul2, 1);

    if (cent->currentState.weapon == WP_SABER)
    {
    trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound( "sound/weapons/saber/saberon.wav" ));
    }
    }
    */

    if cent.torsoBolt != 0 && !((cent.currentState.eFlags & EF_DEAD) != 0) {
        //he's alive and has a limb missing still, reattach it and reset the weapon
        CG_ReattachLimb(cent)
    }

    if ((cent.currentState.eFlags & EF_DEAD) != 0 || (cent.currentState.eFlags & EF_RAG) != 0) && cent.localAnimIndex == 0 {
        var forcedAngles = vec3_t()

        forcedAngles = vec3_t()
        forcedAngles[YAW] = cent.lerpAngles[YAW]

        CG_RagDoll(cent, forcedAngles)
    }

    if (cent.lerpAngles[YAW] > 0 && cent.smoothYaw < 0) || (cent.lerpAngles[YAW] < 0 && cent.smoothYaw > 0) {
        //keep it from snapping around on the threshold
        cent.smoothYaw = -cent.smoothYaw
    }
    cent.lerpAngles[YAW] = cent.smoothYaw + (cent.lerpAngles[YAW] - cent.smoothYaw) * angSmoothFactor
    cent.smoothYaw = cent.lerpAngles[YAW]

    //now just render as a player
    CG_Player(cent)

    /*
    if ( cg_showVehBounds.integer )
    {//show vehicle bboxes
    if ( cent->currentState.clientNum >= MAX_CLIENTS
    && cent->currentState.NPC_class == CLASS_VEHICLE
    && cent->m_pVehicle
    && cent->m_pVehicle->m_pVehicleInfo
    && cent->currentState.clientNum != cg.predictedVehicleState.clientNum )
    {//not the predicted vehicle
    vec3_t NPCDEBUG_RED = {1.0, 0.0, 0.0};
    vec3_t absmin, absmax;
    vec3_t bmins, bmaxs;
    float *old = cent->m_pVehicle->m_vOrientation;
    cent->m_pVehicle->m_vOrientation = &cent->lerpAngles[0];

    BG_VehicleAdjustBBoxForOrientation( cent->m_pVehicle, cent->lerpOrigin, bmins, bmaxs,
    cent->currentState.number, MASK_PLAYERSOLID, NULL );
    cent->m_pVehicle->m_vOrientation = old;

    VectorAdd( cent->lerpOrigin, bmins, absmin );
    VectorAdd( cent->lerpOrigin, bmaxs, absmax );
    CG_Cube( absmin, absmax, NPCDEBUG_RED, 0.25 );
    }
    }
    */
}

//for allocating and freeing npc clientinfo structures.
//Remember to free this before game shutdown no matter what
//and don't stomp over it, as it is dynamic memory from the
//exe.
/// Source: oracle/codemp/cgame/cg_players.c:7695
func CG_CreateNPCClient(_ ci: inout ClientInfo?) {
    //trap_TrueMalloc((void **)ci, sizeof(clientInfo_t));
    ci = ClientInfo(BG_Alloc(Int32(ClientInfo.byteCount)))
}

/// Source: oracle/codemp/cgame/cg_players.c:7701
func CG_DestroyNPCClient(_ ci: inout ClientInfo?) {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'ClientInfo?' must be unwrapped to refer to member 'clear' of wrapped base type 'ClientInfo'".
    // Raven wrote: memset(*ci, 0, sizeof(clientInfo_t))
    portMissing("CG_DestroyNPCClient", source: "oracle/codemp/cgame/cg_players.c:7701")
    //trap_TrueFree((void **)ci);
}

/// Source: oracle/codemp/cgame/cg_players.c:7707
private func CG_ForceElectrocution(_ cent: Centity, _ origin: JKAShared.vec3_t, _ tempAngles: JKAShared.vec3_t, _ shader: JKAShared.qhandle_t, _ alwaysDo: Bool) {
    // Undoing for now, at least this code should compile if I ( or anyone else ) decides to work on this effect
    var found: Bool = false
    var fxOrg = vec3_t()
    var fxOrg2 = vec3_t()
    var dir = vec3_t()
    var rgb = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        // Raven's record lives to the end of his block, so the block is the closure.
        Trace.scratch { tr in
            var bolt: Int32 = -1
            var iter: Int32 = 0
            var torsoBolt: Int32 = -1
            var crotchBolt: Int32 = -1
            var elbowLBolt: Int32 = -1
            var elbowRBolt: Int32 = -1
            var handLBolt: Int32 = -1
            var handRBolt: Int32 = -1
            var kneeLBolt: Int32 = -1
            var kneeRBolt: Int32 = -1
            var footLBolt: Int32 = -1
            var footRBolt: Int32 = -1

            rgb = vec3_t(1, 1, 1)

            if cent.localAnimIndex <= 1 {
                //humanoid
                torsoBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "lower_lumbar")
                crotchBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "pelvis")
                elbowLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*l_arm_elbow")
                elbowRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*r_arm_elbow")
                handLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*l_hand")
                handRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*r_hand")
                kneeLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*hips_l_knee")
                kneeRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*hips_r_knee")
                footLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*l_leg_foot")
                footRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*r_leg_foot")
            } else if cent.currentState.NPC_class == CLASS_PROTOCOL {
                //any others that can use these bolts too?
                torsoBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "lower_lumbar")
                crotchBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "pelvis")
                elbowLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*bicep_lg")
                elbowRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*bicep_rg")
                handLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*hand_l")
                handRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*weapon")
                kneeLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*thigh_lg")
                kneeRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*thigh_rg")
                footLBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*foot_lg")
                footRBolt = trap_G2API_AddBolt(cent.ghoul2, 0, "*foot_rg")
            }

            // Pick a random start point
            while bolt < 0 {
                var test: Int32 = 0
                if iter > 5 {
                    test = iter - 5
                } else {
                    test = Q_irand(0, 6)
                }
                switch test {
                case 0:
                    // Right Elbow
                    bolt = elbowRBolt

                case 1:
                    // Left Hand
                    bolt = handLBolt

                case 2:
                    // Right hand
                    bolt = handRBolt

                case 3:
                    // Left Foot
                    bolt = footLBolt

                case 4:
                    // Right foot
                    bolt = footRBolt

                case 5:
                    // Torso
                    bolt = torsoBolt

                default:
                    // Left Elbow
                    bolt = elbowLBolt
                }
                // Port-note: A ++ inside an expression.
                // Raven wrote: if (++iter==20) break
                portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
            }
            if bolt >= 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                // Raven wrote: found = trap_G2API_GetBoltMatrix( cent->ghoul2, 0, bolt, &boltMatrix, tempAngles, origin, cg.time, cgs.gameModels, cent->modelScale)
                portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
            }

            // Make sure that it's safe to even try and get these values out of the Matrix, otherwise the values could be garbage
            if found {
                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &fxOrg)
                // The SDK also declares `random`, so the call names the bg module.
                if JKAMP_BG.random() > 0.5 {
                    BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_X, &dir)
                } else {
                    BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &dir)
                }

                // Add some fudge, makes us not normalized, but that isn't really important
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
                // Raven wrote: dir[0] += crandom() * 0.4f
                portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
                // Raven wrote: dir[1] += crandom() * 0.4f
                portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
                // Raven wrote: dir[2] += crandom() * 0.4f
                portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
            } else {
                // Just use the lerp Origin and a random direction
                fxOrg = cent.lerpOrigin
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Double' to expected argument type 'Float'".
                // Raven wrote: VectorSet( dir, crandom(), crandom(), crandom() )
                portMissing("CG_ForceElectrocution", source: "oracle/codemp/cgame/cg_players.c:7707")
                switch cent.currentState.NPC_class {
                case CLASS_PROBE:
                    fxOrg[2] += 50

                case CLASS_MARK1:
                    fxOrg[2] += 50

                case CLASS_ATST:
                    fxOrg[2] += 120

                default:
                    break
                }
            }

            // The SDK also declares `random`, so the call names the bg module.
            _VectorMA(fxOrg, JKAMP_BG.random() * 40 + 40, dir, &fxOrg2)

            CG_Trace(tr, fxOrg, nil, nil, fxOrg2, -1, CONTENTS_SOLID)

            // The SDK also declares `random`, so the call names the bg module.
            if tr.fraction < 1.0 || JKAMP_BG.random() > 0.94 || alwaysDo {
                // Raven's record lives to the end of his block, so the block is the closure.
                AddElectricityArgStruct.scratch { p in

                    p.start = fxOrg
                    p.end = tr.endpos
                    p.size1 = 1.5
                    p.size2 = 4.0
                    p.sizeParm = 0.0
                    p.alpha1 = 1.0
                    p.alpha2 = 0.5
                    p.alphaParm = 0.0
                    p.sRGB = rgb
                    p.eRGB = rgb
                    p.rgbParm = 0.0
                    p.chaos = 5.0
                    // The SDK also declares `random`, so the call names the bg module.
                    p.killTime = Int32((JKAMP_BG.random() * 50 + 100))
                    p.shader = shader
                    p.flags = (0x00000001 | 0x00000100 | 0x02000000 | 0x04000000 | 0x01000000)

                    trap_FX_AddElectricity(p)

                    //In other words:
                    /*
                    FX_AddElectricity( fxOrg, tr.endpos,
                    1.5f, 4.0f, 0.0f,
                    1.0f, 0.5f, 0.0f,
                    rgb, rgb, 0.0f,
                    5.5f, random() * 50 + 100, shader, FX_ALPHA_LINEAR | FX_SIZE_LINEAR | FX_BRANCH | FX_GROW | FX_TAPER );
                    */
                }
            }
        }
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:7891
func CG_InitJetpackGhoul2() {
    if cg_g2JetpackInstance != nil {
        return
    }

    trap_G2API_InitGhoul2Model(&cg_g2JetpackInstance, JETPACK_MODEL, 0, 0, 0, 0, 0)


    //Indicate which bolt on the player we will be attached to
    //In this case bolt 0 is rhand, 1 is lhand, and 2 is the bolt
    //for the jetpack (*chestg)
    trap_G2API_SetBoltInfo(cg_g2JetpackInstance, 0, 2)

    //Add the bolts jet effects will be played from
    trap_G2API_AddBolt(cg_g2JetpackInstance, 0, "torso_ljet")
    trap_G2API_AddBolt(cg_g2JetpackInstance, 0, "torso_rjet")
}

/// Source: oracle/codemp/cgame/cg_players.c:7913
func CG_CleanJetpackGhoul2() {
    if cg_g2JetpackInstance != nil {
        trap_G2API_CleanGhoul2Models(&cg_g2JetpackInstance)
        cg_g2JetpackInstance = nil
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:7981
private func CG_VehicleEffects(_ cent: Centity) {
    var pVehNPC: Vehicle?

    if cent.currentState.eType != ET_NPC || cent.currentState.NPC_class != CLASS_VEHICLE || cent.m_pVehicle == nil {
        return
    }

    pVehNPC = cent.m_pVehicle

    if cent.currentState.clientNum == cg.predictedPlayerState.m_iVehicleNum && (cent.currentState.eFlags2 & EF2_HYPERSPACE) != 0 {
        //in hyperspace!
        if cg.predictedVehicleState.hyperSpaceTime != 0 && (cg.time - cg.predictedVehicleState.hyperSpaceTime) < HYPERSPACE_TIME {
            if cg_lastHyperSpaceEffectTime == 0 || (cg.time - cg_lastHyperSpaceEffectTime) > HYPERSPACE_TIME + 500 {
                //can't be from the last time we were in hyperspace, so play the effect!
                trap_FX_PlayBoltedEffectID(cgs.effects.mHyperspaceStars, &cent.lerpOrigin, cent.ghoul2, 0, cent.currentState.number, 0, 0, true)
                cg_lastHyperSpaceEffectTime = cg.time
            }
        }
    }

    //FLYBY sound
    if cent.currentState.clientNum != cg.predictedPlayerState.m_iVehicleNum && (pVehNPC!.m_pVehicleInfo!.soundFlyBy != 0 || pVehNPC!.m_pVehicleInfo!.soundFlyBy2 != 0) {
        //not my vehicle
        if cent.currentState.speed != 0 && cg.predictedPlayerState.speed + cent.currentState.speed > 500 {
            //he's moving and between the two of us, we're moving fast
            var diff = vec3_t()
            diff = cent.lerpOrigin - cg.predictedPlayerState.origin
            if VectorLength(diff) < 2048 {
                //close
                var myFwd = vec3_t()
                var theirFwd = vec3_t()
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
                var scratchRight = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
                var scratchUp = vec3_t()
                AngleVectors(cg.predictedPlayerState.viewangles, &myFwd, &scratchRight, &scratchUp)
                myFwd = myFwd * cg.predictedPlayerState.speed
                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
                var scratchRight2 = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
                var scratchUp2 = vec3_t()
                AngleVectors(cent.lerpAngles, &theirFwd, &scratchRight2, &scratchUp2)
                theirFwd = theirFwd * cent.currentState.speed
                if lastFlyBySound[cent.currentState.clientNum] + FLYBYSOUNDTIME < cg.time {
                    //okay to do a flyby sound on this vehicle
                    if _DotProduct(myFwd, theirFwd) < 500 {
                        var flyBySound: Int32 = 0
                        if pVehNPC!.m_pVehicleInfo!.soundFlyBy != 0 && pVehNPC!.m_pVehicleInfo!.soundFlyBy2 != 0 {
                            flyBySound = Q_irand(0, 1) != 0 ? pVehNPC!.m_pVehicleInfo!.soundFlyBy : pVehNPC!.m_pVehicleInfo!.soundFlyBy2
                        } else if pVehNPC!.m_pVehicleInfo!.soundFlyBy != 0 {
                            flyBySound = pVehNPC!.m_pVehicleInfo!.soundFlyBy
                        } else {
                            flyBySound = pVehNPC!.m_pVehicleInfo!.soundFlyBy2
                        }
                        // Port-note: Raven passes NULL for the `origin` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                        portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
                        var scratchOrigin = vec3_t()
                        trap_S_StartSound(&scratchOrigin, cent.currentState.clientNum, CHAN_LESS_ATTEN, flyBySound)
                        lastFlyBySound[cent.currentState.clientNum] = cg.time
                    }
                }
            }
        }
    }

    if cent.currentState.speed == 0 && cent.nextState.speed > 0 && cent.m_pVehicle!.m_pVehicleInfo!.soundEngineStart != 0 {
        //engines rev up for the first time
        // Port-note: Raven passes NULL for the `origin` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")
        var scratchOrigin2 = vec3_t()
        trap_S_StartSound(&scratchOrigin2, cent.currentState.clientNum, CHAN_LESS_ATTEN, cent.m_pVehicle!.m_pVehicleInfo!.soundEngineStart)
    }
    // Animals don't exude any effects...
    if pVehNPC!.m_pVehicleInfo!.type != VH_ANIMAL {
        var didFireTrail: Bool = false
        if pVehNPC!.m_pVehicleInfo!.surfDestruction != 0 && cent.ghoul2 != nil {
            //see if anything has been blown off
            var i: Int32 = 0
            var surfDmg: Bool = false

            while i < BG_NUM_TOGGLEABLE_SURFACES {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'bgToggleableSurfaceDebris' in scope".
                // Raven wrote: if (bgToggleableSurfaceDebris[i] > 1) { //this is decidedly a destroyable surface, let's check its status int surfTest = trap_G2API_GetSurfaceRenderStatus(cent->ghoul2, 0, bgToggleableSurfaces[i]); if ( surfTest != -1 && (surfTest&TURN_OFF) ) { //it exists, but it's off... surfDmg = qtrue; //create some flames CG_CreateSurfaceDebris(cent, i, cgs.effects.mShipDestBurning, qfalse); didFireTrail = qtrue; } }
                portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")

                i += 1
            }

            if surfDmg {
                //if any surface are damaged, neglect exhaust etc effects (so we don't have exhaust trails coming out of invisible surfaces)
                return
            }
        }
        if !didFireTrail && (cent.currentState.eFlags & EF_DEAD) != 0 {
            //spiralling out of control anyway
            CG_CreateSurfaceDebris(cent, -1, cgs.effects.mShipDestBurning, false)
        }

        if pVehNPC!.m_iLastFXTime <= cg.time {
            //until we attach it, we need to debounce this
            var fwd = vec3_t()
            var rt = vec3_t()
            var up = vec3_t()
            var flat = vec3_t()
            let nextFXDelay: Float = 50
            flat = vec3_t(0, cent.lerpAngles[1], cent.lerpAngles[2])
            AngleVectors(flat, &fwd, &rt, &up)
            if cent.currentState.speed > 0 {
                //FIXME: only do this when accelerator is being pressed! (must have a driver?)
                var org = vec3_t()
                var doExhaust: Bool = false
                _VectorMA(cent.lerpOrigin, -16, up, &org)
                _VectorMA(org, -42, fwd, &org)
                // Play damage effects.
                //if ( pVehNPC->m_iArmor <= 75 )
                if 0 != 0 {
                    //hurt
                    trap_FX_PlayEffectID(cgs.effects.mBlackSmoke, &org, &fwd, -1, -1)
                } else if pVehNPC!.m_pVehicleInfo!.iTrailFX != 0 {
                    //okay, do normal trail
                    trap_FX_PlayEffectID(pVehNPC!.m_pVehicleInfo!.iTrailFX, &org, &fwd, -1, -1)
                }
                //=====================================================================
                //EXHAUST FX
                //=====================================================================
                //do exhaust
                if (cent.currentState.eFlags & EF_JETPACK_ACTIVE) != 0 {
                    //cheap way of telling us the vehicle is in "turbo" mode
                    doExhaust = (pVehNPC!.m_pVehicleInfo!.iTurboFX != 0)
                } else {
                    doExhaust = (pVehNPC!.m_pVehicleInfo!.iExhaustFX != 0)
                }
                if doExhaust && cent.ghoul2 != nil {
                    var i: Int32 = 0
                    var fx: Int32 = 0

                    i = 0
                    while i < MAX_VEHICLE_EXHAUSTS {
                        // We hit an invalid tag, we quit (they should be created in order so tough luck if not).
                        if pVehNPC!.m_iExhaustTag[i] == -1 {
                            break
                        }

                        if (cent.currentState.brokenLimbs & (1 << SHIPSURF_DAMAGE_BACK_HEAVY)) != 0 {
                            //engine has taken heavy damage
                            if Q_irand(0, 1) == 0 {
                                //50% chance of not drawing this engine glow this frame
                                i += 1
                                continue
                            }
                        } else if (cent.currentState.brokenLimbs & (1 << SHIPSURF_DAMAGE_BACK_LIGHT)) != 0 {
                            //engine has taken light damage
                            if Q_irand(0, 4) == 0 {
                                //20% chance of not drawing this engine glow this frame
                                i += 1
                                continue
                            }
                        }

                        if (cent.currentState.eFlags & EF_JETPACK_ACTIVE) != 0 && pVehNPC!.m_pVehicleInfo!.iTurboFX != 0 {
                            fx = pVehNPC!.m_pVehicleInfo!.iTurboFX
                        } else {
                            //play the normal one
                            fx = pVehNPC!.m_pVehicleInfo!.iExhaustFX
                        }

                        if pVehNPC!.m_pVehicleInfo!.type == VH_FIGHTER {
                            trap_FX_PlayBoltedEffectID(fx, &cent.lerpOrigin, cent.ghoul2, pVehNPC!.m_iExhaustTag[i], cent.currentState.number, 0, 0, true)
                        } else {
                            //fixme: bolt these too
                            // Raven's record lives to the end of his block, so the block is the closure.
                            MdxaBone.scratch { boltMatrix in
                                var boltOrg = vec3_t()
                                var boltDir = vec3_t()

                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                                // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, pVehNPC->m_iExhaustTag[i], &boltMatrix, flat, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                                portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")

                                BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltOrg)
                                boltDir = fwd //fixme?

                                trap_FX_PlayEffectID(fx, &boltOrg, &boltDir, -1, -1)
                            }
                        }
                        i += 1
                    }
                }
                //=====================================================================
                //WING TRAIL FX
                //=====================================================================
                //do trail
                //FIXME: not in space!!!
                if pVehNPC!.m_pVehicleInfo!.iTrailFX != 0 && cent.ghoul2 != nil {
                    var i: Int32 = 0
                    var boltOrg = vec3_t()
                    var boltDir = vec3_t()
                    // Raven's record lives to the end of his block, so the block is the closure.
                    MdxaBone.scratch { boltMatrix in
                        var getBoltAngles = vec3_t()

                        getBoltAngles = cent.lerpAngles
                        if pVehNPC!.m_pVehicleInfo!.type != VH_FIGHTER {
                            //only fighters use pitch/roll in refent axis
                            getBoltAngles[ROLL] = 0.0
                            getBoltAngles[PITCH] = getBoltAngles[ROLL]
                        }

                        i = 1
                        while i < 5 {
                            let trailBolt: Int32 = trap_G2API_AddBolt(cent.ghoul2, 0, va("*trail%d", i))
                            // We hit an invalid tag, we quit (they should be created in order so tough luck if not).
                            if trailBolt == -1 {
                                break
                            }

                            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, trailBolt, &boltMatrix, getBoltAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                            portMissing("CG_VehicleEffects", source: "oracle/codemp/cgame/cg_players.c:7981")

                            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &boltOrg)
                            boltDir = fwd //fixme?

                            trap_FX_PlayEffectID(pVehNPC!.m_pVehicleInfo!.iTrailFX, &boltOrg, &boltDir, -1, -1)
                            i += 1
                        }
                    }
                }
            }
            //FIXME armor needs to be sent over network
            do {
                if (cent.currentState.eFlags & EF_DEAD) != 0 {
                    //just plain dead, use flames
                    var up = vec3_t(0, 0, 1)
                    var boltOrg = vec3_t()

                    //if ( pVehNPC->m_iDriverTag == -1 )
                    do {
                        //doh!  no tag
                        boltOrg = cent.lerpOrigin
                    }
                    //else
                    //{
                    //	mdxaBone_t boltMatrix;
                    //	vec3_t getBoltAngles;

                    //	VectorCopy(cent->lerpAngles, getBoltAngles);
                    //	if (pVehNPC->m_pVehicleInfo->type != VH_FIGHTER)
                    //	{ //only fighters use pitch/roll in refent axis
                    //		getBoltAngles[PITCH] = getBoltAngles[ROLL] = 0.0f;
                    //	}

                    //	trap_G2API_GetBoltMatrix(cent->ghoul2, 0, pVehNPC->m_iDriverTag, &boltMatrix, getBoltAngles,
                    //		cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale);

                    //	BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, boltOrg);
                    //}
                    trap_FX_PlayEffectID(cgs.effects.mShipDestBurning, &boltOrg, &up, -1, -1)
                }
            }
            if cent.currentState.brokenLimbs != 0 {
                var i: Int32 = 0
                if Q_irand(0, 5) == 0 {
                    i = SHIPSURF_FRONT
                    while i <= SHIPSURF_LEFT {
                        if (cent.currentState.brokenLimbs & (1 << ((i - SHIPSURF_FRONT) + SHIPSURF_DAMAGE_FRONT_HEAVY))) != 0 {
                            //heavy damage, do both effects
                            if pVehNPC!.m_pVehicleInfo!.iInjureFX != 0 {
                                CG_CreateSurfaceSmoke(cent, i, pVehNPC!.m_pVehicleInfo!.iInjureFX)
                            }
                            if pVehNPC!.m_pVehicleInfo!.iDmgFX != 0 {
                                CG_CreateSurfaceSmoke(cent, i, pVehNPC!.m_pVehicleInfo!.iDmgFX)
                            }
                        } else if (cent.currentState.brokenLimbs & (1 << ((i - SHIPSURF_FRONT) + SHIPSURF_DAMAGE_FRONT_LIGHT))) != 0 {
                            //only light damage
                            if pVehNPC!.m_pVehicleInfo!.iInjureFX != 0 {
                                CG_CreateSurfaceSmoke(cent, i, pVehNPC!.m_pVehicleInfo!.iInjureFX)
                            }
                        }
                        i += 1
                    }
                }
            }
            /*
            if ( pVehNPC->m_iArmor <= 50 )
            {//FIXME: use as a proportion of max armor?
            VectorMA( cent->lerpOrigin, 64, fwd, org );
            VectorScale( fwd, -1, fwd );

            trap_FX_PlayEffectID( cgs.effects.mBlackSmoke, org, fwd, -1, -1 );
            }
            if ( pVehNPC->m_iArmor <= 0 )
            {//FIXME: should use something attached.. but want it to build up over time, so...
            if ( flrand( 0, cg.time - pVehNPC->m_iDieTime ) < 1000 )
            {//flaming!
            VectorMA( cent->lerpOrigin, flrand(-64, 64), fwd, org );
            VectorScale( fwd, -1, fwd );
            trap_FX_PlayEffectID( trap_FX_RegisterEffect("ships/fire"), org, fwd, -1, -1 );
            nextFXDelay = 50;
            }
            }
            */
            pVehNPC!.m_iLastFXTime = Int32(cg.time + nextFXDelay)
        }
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:8316
func CG_RadiusForCent(_ cent: Centity) -> Float {
    if cent.currentState.eType == ET_NPC {
        if cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo!.g2radius != 0 {
            //has override
            return Float(cent.m_pVehicle!.m_pVehicleInfo!.g2radius)
        } else if cent.currentState.g2radius != 0 {
            return Float(cent.currentState.g2radius)
        }
    } else if cent.currentState.g2radius != 0 {
        return Float(cent.currentState.g2radius)
    }
    return 64.0
}

/// Source: oracle/codemp/cgame/cg_players.c:8341
func CG_CheckThirdPersonAlpha(_ cent: Centity, _ legs: JKAMP.RefEntity) {
    var alpha: Float = 1.0
    var setFlags: Int32 = 0

    if cent.m_pVehicle != nil {
        //a vehicle
        if cg.predictedPlayerState.m_iVehicleNum != cent.currentState.clientNum && cent.m_pVehicle!.m_pVehicleInfo != nil && cent.m_pVehicle!.m_pVehicleInfo!.cameraOverride && cent.m_pVehicle!.m_pVehicleInfo!.cameraAlpha != 0 {
            //make sure it's not using any alpha
            legs.renderfx |= RF_FORCE_ENT_ALPHA
            legs.shaderRGBA[3] = 255
            return
        }
    }

    if !cg.renderingThirdPerson {
        return
    }

    if cg.predictedPlayerState.m_iVehicleNum != 0 {
        //in a vehicle
        if cg.predictedPlayerState.m_iVehicleNum == cent.currentState.clientNum {
            //this is my vehicle
            if cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo != nil && cent.m_pVehicle!.m_pVehicleInfo!.cameraOverride && cent.m_pVehicle!.m_pVehicleInfo!.cameraAlpha != 0 {
                //vehicle has auto third-person alpha on
                // Raven's record lives to the end of his block, so the block is the closure.
                Trace.scratch { trace in
                    var dir2Crosshair = vec3_t()
                    var end = vec3_t()
                    dir2Crosshair = cg_crosshairPos - cameraCurLoc
                    VectorNormalize(&dir2Crosshair)
                    _VectorMA(cameraCurLoc, cent.m_pVehicle!.m_pVehicleInfo!.cameraRange * 2.0, dir2Crosshair, &end)
                    CG_G2Trace(trace, cameraCurLoc, vec3_origin, vec3_origin, end, ENTITYNUM_NONE, CONTENTS_BODY)
                    if trace.entityNum == cent.currentState.clientNum || trace.entityNum == cg.predictedPlayerState.clientNum {
                        //hit me or the vehicle I'm in
                        cg_vehThirdPersonAlpha -= 0.1 * cg.frametime / 50.0
                        if cg_vehThirdPersonAlpha < cent.m_pVehicle!.m_pVehicleInfo!.cameraAlpha {
                            cg_vehThirdPersonAlpha = cent.m_pVehicle!.m_pVehicleInfo!.cameraAlpha
                        }
                    } else {
                        cg_vehThirdPersonAlpha += 0.1 * cg.frametime / 50.0
                        if cg_vehThirdPersonAlpha > 1.0 {
                            cg_vehThirdPersonAlpha = 1.0
                        }
                    }
                    alpha = cg_vehThirdPersonAlpha
                }
            } else {
                //use the cvar
                //reset this
                cg_vehThirdPersonAlpha = 1.0
                //use the cvar
                alpha = cg_thirdPersonAlpha.value
            }
        }
    } else if cg.predictedPlayerState.clientNum == cent.currentState.clientNum {
        //it's me
        //reset this
        cg_vehThirdPersonAlpha = 1.0
        //use the cvar
        setFlags = RF_FORCE_ENT_ALPHA
        alpha = cg_thirdPersonAlpha.value
    }

    if alpha < 1.0 {
        legs.renderfx |= setFlags
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to subscript of type 'byte' (aka 'UInt8')".
        // Raven wrote: legs->shaderRGBA[3] = (unsigned char)(alpha * 255.0f)
        portMissing("CG_CheckThirdPersonAlpha", source: "oracle/codemp/cgame/cg_players.c:8341")
    }
}

/// Source: oracle/codemp/cgame/cg_players.c:8423
func CG_Player(_ cent: Centity) {
    var ci: ClientInfo?
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RefEntity.scratch { legs -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = RefEntity.scratch { torso -> Bool in
            var clientNum: Int32 = 0
            var renderfx: Int32 = 0
            var shadow: Bool = false
            var shadowPlane: Float = 0
            var dead: Bool = false
            var rootAngles = vec3_t()
            var angle: Float = 0
            var angles = vec3_t()
            var dir = vec3_t()
            var elevated = vec3_t()
            var enang = vec3_t()
            var seekorg = vec3_t()
            var iwantout: Int32 = 0
            var successchange: Int32 = 0
            var team: Int32 = 0
            // Port-note: A local `mdxaBone_t boltMatrix` the table has no type for.
            // Raven wrote: mdxaBone_t boltMatrix;
            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
            // Port-note: A local `mdxaBone_t lHandMatrix` the table has no type for.
            // Raven wrote: lHandMatrix;
            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
            var doAlpha: Int32 = 0
            var gotLHandMatrix: Bool = false
            var g2HasWeapon: Bool = false
            var drawPlayerSaber: Bool = false
            var checkDroidShields: Bool = false

            //first if we are not an npc and we are using an emplaced gun then make sure our
            //angles are visually capped to the constraints (otherwise it's possible to lerp
            //a little outside and look kind of twitchy)
            stillDoSaber: do {
                if cent.currentState.weapon == WP_EMPLACED_GUN && cent.currentState.otherEntityNum2 != 0 {
                    var empYaw: Float = 0

                    if BG_EmplacedView(&cent.lerpAngles, &cg_entities[cent.currentState.otherEntityNum2].currentState.angles, &empYaw, cg_entities[cent.currentState.otherEntityNum2].currentState.origin2[0]) != 0 {
                        cent.lerpAngles[YAW] = empYaw
                    }
                }

                if cent.currentState.iModelScale != 0 {
                    //if the server says we have a custom scale then set it now.
                    cent.modelScale[2] = cent.currentState.iModelScale / 100.0
                    cent.modelScale[1] = cent.modelScale[2]
                    cent.modelScale[0] = cent.modelScale[1]
                    if cent.currentState.NPC_class != CLASS_VEHICLE {
                        if cent.modelScale[2] != 0 && cent.modelScale[2] != 1.0 {
                            cent.lerpOrigin[2] += 24 * (cent.modelScale[2] - 1)
                        }
                    }
                } else {
                    cent.modelScale = vec3_t()
                }

                if (cg_smoothClients.integer != 0 || cent.currentState.heldByClient != 0) && (cent.currentState.groundEntityNum >= ENTITYNUM_WORLD || cent.currentState.eType == ET_TERRAIN) && !((cent.currentState.eFlags2 & EF2_HYPERSPACE) != 0) && cg.predictedPlayerState.m_iVehicleNum != cent.currentState.number {
                    //always smooth when being thrown
                    var posDif = vec3_t()
                    var smoothFactor: Float = 0
                    var k: Int32 = 0
                    var fTolerance: Float = 20000.0

                    if cent.currentState.heldByClient != 0 {
                        //smooth the origin more when in this state, because movement is origin-based on server.
                        smoothFactor = 0.2
                    } else if (cent.currentState.powerups & (1 << PW_SPEED)) != 0 || (cent.currentState.forcePowersActive & (1 << FP_RAGE)) != 0 {
                        //we're moving fast so don't smooth as much
                        smoothFactor = 0.6
                    } else if cent.currentState.eType == ET_NPC && cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER {
                        //greater smoothing for flying vehicles, since they move so fast
                        fTolerance = 6000000.0 //500000.0f; //yeah, this is so wrong..but..
                        smoothFactor = 0.5
                    } else {
                        smoothFactor = 0.5
                    }

                    if DistanceSquared(cent.beamEnd, cent.lerpOrigin) > smoothFactor * fTolerance {
                        cent.beamEnd = cent.lerpOrigin
                    }

                    posDif = cent.lerpOrigin - cent.beamEnd

                    k = 0
                    while k < 3 {
                        cent.beamEnd[k] = (cent.beamEnd[k] + posDif[k] * smoothFactor)
                        cent.lerpOrigin[k] = cent.beamEnd[k]
                        k += 1
                    }
                } else {
                    cent.beamEnd = cent.lerpOrigin
                }

                if cent.currentState.m_iVehicleNum != 0 && cent.currentState.NPC_class != CLASS_VEHICLE {
                    //this player is riding a vehicle
                    let veh: Centity? = cg_entities[cent.currentState.m_iVehicleNum]

                    cent.lerpAngles[YAW] = veh!.lerpAngles[YAW]

                    //Attach ourself to the vehicle
                    if veh!.m_pVehicle != nil && cent.playerState != nil && veh!.playerState != nil && cent.ghoul2 != nil && veh!.ghoul2 != nil {
                        if veh!.currentState.owner != cent.currentState.clientNum {
                            //FIXME: what about visible passengers?
                            if CG_VehicleAttachDroidUnit(cent, legs) {
                                checkDroidShields = true
                            }
                        } else if veh!.currentState.owner != ENTITYNUM_NONE {
                            //has a pilot...???
                            var oldPSOrg = vec3_t()

                            //make sure it has its pilot and parent set
                            veh!.m_pVehicle!.m_pPilot = BgEntity(cg_entities[veh!.currentState.owner])
                            veh!.m_pVehicle!.m_pParentEntity = veh.map { BgEntity($0) }

                            oldPSOrg = veh!.playerState!.origin

                            //update the veh's playerstate org for getting the bolt
                            veh!.playerState!.origin = veh!.lerpOrigin
                            cent.playerState!.origin = cent.lerpOrigin

                            //Now do the attach
                            veh!.playerState!.viewangles = veh!.lerpAngles
                            veh!.m_pVehicle!.m_pVehicleInfo!.runAttachRiders(veh!.m_pVehicle)

                            //copy the "playerstate origin" to the lerpOrigin since that's what we use to display
                            cent.lerpOrigin = cent.playerState!.origin

                            veh!.playerState!.origin = oldPSOrg
                        }
                    }
                }

                // the client number is stored in clientNum.  It can't be derived
                // from the entity number, because a single client may have
                // multiple corpses on the level using the same clientinfo
                if cent.currentState.eType != ET_NPC {
                    clientNum = cent.currentState.clientNum
                    if clientNum < 0 || clientNum >= MAX_CLIENTS {
                        CG_Error("Bad clientNum on player entity")
                    }
                    ci = cgs.clientinfo[clientNum]
                } else {
                    if cent.npcClient == nil {
                        CG_CreateNPCClient(&cent.npcClient) //allocate memory for it

                        if cent.npcClient == nil {
                            return true
                        }

                        // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'ClientInfo?' must be unwrapped to refer to member 'clear' of wrapped base type 'ClientInfo'".
                        // Raven wrote: memset(cent->npcClient, 0, sizeof(clientInfo_t))
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        cent.npcClient!.ghoul2Model = nil
                    }


                    if cent.npcClient!.ghoul2Model != cent.ghoul2 && cent.ghoul2 != nil {
                        cent.npcClient!.ghoul2Model = cent.ghoul2
                        if cent.localAnimIndex <= 1 {
                            cent.npcClient!.bolt_rhand = trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "*r_hand")
                            cent.npcClient!.bolt_lhand = trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "*l_hand")

                            //rhand must always be first bolt. lhand always second. Whichever you want the
                            //jetpack bolted to must always be third.
                            trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "*chestg")

                            //claw bolts
                            trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "*r_hand_cap_r_arm")
                            trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "*l_hand_cap_l_arm")

                            cent.npcClient!.bolt_head = trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "*head_top")
                            if cent.npcClient!.bolt_head == -1 {
                                cent.npcClient!.bolt_head = trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "ceyebrow")
                            }
                            cent.npcClient!.bolt_motion = trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "Motion")
                            cent.npcClient!.bolt_llumbar = trap_G2API_AddBolt(cent.npcClient!.ghoul2Model, 0, "lower_lumbar")
                        } else {
                            cent.npcClient!.bolt_rhand = -1
                            cent.npcClient!.bolt_lhand = -1
                            cent.npcClient!.bolt_head = -1
                            cent.npcClient!.bolt_motion = -1
                            cent.npcClient!.bolt_llumbar = -1
                        }
                        cent.npcClient!.team = TEAM_FREE
                        cent.npcClient!.infoValid = true
                    }
                    ci = cent.npcClient
                }

                // it is possible to see corpses from disconnected players that may
                // not have valid clientinfo
                if !ci!.infoValid {
                    return true
                }

                // Add the player to the radar if on the same team and its a team game
                if cgs.gametype >= GT_TEAM {
                    if cent.currentState.eType != ET_NPC && cg.snap!.ps.clientNum != cent.currentState.number && ci!.team == cg.snap!.ps.persistant[PERS_TEAM] {
                        CG_AddRadarEnt(cent)
                    }
                }

                if cent.currentState.eType == ET_NPC && cent.currentState.NPC_class == CLASS_VEHICLE {
                    //add vehicles
                    CG_AddRadarEnt(cent)
                    if CG_InFighter() {
                        //this is a vehicle, bracket it
                        if cg.predictedPlayerState.m_iVehicleNum != cent.currentState.clientNum {
                            //don't add the vehicle I'm in... :)
                            CG_AddBracketedEnt(cent)
                        }
                    }
                }

                if cent.ghoul2 == nil {
                    //not ready yet?
                    trap_G2API_ClearAttachedInstance(cent.currentState.number)

                    if ci!.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Model) {
                        trap_G2API_DuplicateGhoul2Instance(ci!.ghoul2Model, &cent.ghoul2)

                        //Attach the instance to this entity num so we can make use of client-server
                        //shared operations if possible.
                        trap_G2API_AttachInstanceToEntNum(cent.ghoul2, cent.currentState.number, false)

                        if trap_G2API_AddBolt(cent.ghoul2, 0, "face") == -1 {
                            //check now to see if we have this bone for setting anims and such
                            cent.noFace = true
                        }

                        cent.localAnimIndex = CG_G2SkelForModel(cent.ghoul2)
                        cent.eventAnimIndex = CG_G2EvIndexForModel(cent.ghoul2, cent.localAnimIndex)
                    }
                    return true
                }

                if ci!.superSmoothTime != 0 {
                    //do crazy smoothing
                    if ci!.superSmoothTime > cg.time {
                        //do it
                        trap_G2API_AbsurdSmoothing(cent.ghoul2, true)
                    } else {
                        //turn it off
                        ci!.superSmoothTime = 0
                        trap_G2API_AbsurdSmoothing(cent.ghoul2, false)
                    }
                }

                if cg.predictedPlayerState.pm_type == PM_INTERMISSION {
                    //don't show all this shit during intermission
                    if cent.currentState.eType == ET_NPC && cent.currentState.NPC_class != CLASS_VEHICLE {
                        //NPC in intermission
                    } else {
                        //don't render players or vehicles in intermissions, allow other NPCs for scripts
                        return true
                    }
                }

                CG_VehicleEffects(cent)

                if (cent.currentState.eFlags & EF_JETPACK) != 0 && !((cent.currentState.eFlags & EF_DEAD) != 0) && cg_g2JetpackInstance != nil {
                    //should have a jetpack attached
                    //1 is rhand weap, 2 is lhand weap (akimbo sabs), 3 is jetpack
                    if !trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 3) {
                        trap_G2API_CopySpecificGhoul2Model(cg_g2JetpackInstance, 0, cent.ghoul2, 3)
                    }

                    if (cent.currentState.eFlags & EF_JETPACK_ACTIVE) != 0 {
                        // Raven's record lives to the end of his block, so the block is the closure.
                        MdxaBone.scratch { mat in
                            var flamePos = vec3_t()
                            var flameDir = vec3_t()
                            var n: Int32 = 0

                            while n < 2 {
                                //Get the position/dir of the flame bolt on the jetpack model bolted to the player
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutablePointer<Slots<qhandle_t>>' (aka 'UnsafeMutablePointer<Slots<Int32>>') to expected argument type 'UnsafeMutablePointer<Int32>'".
                                // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 3, n, &mat, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                                BG_GiveMeVectorFromMatrix(mat, ORIGIN, &flamePos)

                                if n == 0 {
                                    BG_GiveMeVectorFromMatrix(mat, NEGATIVE_Y, &flameDir)
                                    _VectorMA(flamePos, -9.5, flameDir, &flamePos)
                                    BG_GiveMeVectorFromMatrix(mat, POSITIVE_X, &flameDir)
                                    _VectorMA(flamePos, -13.5, flameDir, &flamePos)
                                } else {
                                    BG_GiveMeVectorFromMatrix(mat, POSITIVE_X, &flameDir)
                                    _VectorMA(flamePos, -9.5, flameDir, &flamePos)
                                    BG_GiveMeVectorFromMatrix(mat, NEGATIVE_Y, &flameDir)
                                    _VectorMA(flamePos, -13.5, flameDir, &flamePos)
                                }

                                if (cent.currentState.eFlags & EF_JETPACK_FLAMING) != 0 {
                                    //create effects
                                    //FIXME: Just one big effect
                                    //Play the effect
                                    trap_FX_PlayEffectID(cgs.effects.mBobaJet, &flamePos, &flameDir, -1, -1)
                                    trap_FX_PlayEffectID(cgs.effects.mBobaJet, &flamePos, &flameDir, -1, -1)

                                    //Keep the jet fire sound looping
                                    trap_S_AddLoopingSound(cent.currentState.number, cent.lerpOrigin, vec3_origin, trap_S_RegisterSound("sound/effects/fire_lp"))
                                } else {
                                    //just idling
                                    //FIXME: Different smaller effect for idle
                                    //Play the effect
                                    trap_FX_PlayEffectID(cgs.effects.mBobaJet, &flamePos, &flameDir, -1, -1)
                                }

                                n += 1
                            }

                            trap_S_AddLoopingSound(cent.currentState.number, cent.lerpOrigin, vec3_origin, trap_S_RegisterSound("sound/boba/JETHOVER"))
                        }
                    }
                } else if trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 3) {
                    //fixme: would be good if this could be done not every frame
                    trap_G2API_RemoveGhoul2Model(&(cent.ghoul2), 3)
                }

                g2HasWeapon = trap_G2API_HasGhoul2ModelOnIndex((cent.ghoul2), 1)

                if !g2HasWeapon {
                    //force a redup of the weapon instance onto the client instance
                    cent.ghoul2weapon = nil
                    cent.weapon = 0
                }

                if cent.torsoBolt != 0 && !((cent.currentState.eFlags & EF_DEAD) != 0) {
                    //he's alive and has a limb missing still, reattach it and reset the weapon
                    CG_ReattachLimb(cent)
                }

                if cent.isRagging && !((cent.currentState.eFlags & EF_DEAD) != 0) && !((cent.currentState.eFlags & EF_RAG) != 0) {
                    //make sure we don't ragdoll ever while alive unless directly told to with eFlags
                    cent.isRagging = false
                    trap_G2API_SetRagDoll(cent.ghoul2, nil) //calling with null parms resets to no ragdoll.
                }

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Int'".
                // Raven wrote: if (cent->ghoul2 && cent->torsoBolt && ((cent->torsoBolt & RARMBIT) || (cent->torsoBolt & RHANDBIT) || (cent->torsoBolt & WAISTBIT)) && g2HasWeapon) { //kill the weapon if the limb holding it is no longer on the model trap_G2API_RemoveGhoul2Model(&(cent->ghoul2), 1); g2HasWeapon = qfalse; }
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                if cent.trickAlphaTime == 0 || (cg.time - cent.trickAlphaTime) > 1000 {
                    //things got out of sync, perhaps a new client is trying to fill in this slot
                    cent.trickAlpha = 255
                    cent.trickAlphaTime = cg.time
                }

                if (cent.currentState.eFlags & EF_NODRAW) != 0 {
                    //If nodraw, return here
                    return true
                } else if (cent.currentState.eFlags2 & EF2_SHIP_DEATH) != 0 {
                    //died in ship, don't draw, we were "obliterated"
                    return true
                }

                //If this client has tricked you.
                if CG_IsMindTricked(cent.currentState.trickedentindex, cent.currentState.trickedentindex2, cent.currentState.trickedentindex3, cent.currentState.trickedentindex4, cg.snap!.ps.clientNum) != 0 {
                    if cent.trickAlpha > 1 {
                        cent.trickAlpha = Int32(Double(cent.trickAlpha) - Double(cg.time - cent.trickAlphaTime) * 0.5)
                        cent.trickAlphaTime = cg.time

                        if cent.trickAlpha < 0 {
                            cent.trickAlpha = 0
                        }

                        doAlpha = 1
                    } else {
                        doAlpha = 1
                        cent.trickAlpha = 1
                        cent.trickAlphaTime = cg.time
                        iwantout = 1
                    }
                } else {
                    if cent.trickAlpha < 255 {
                        cent.trickAlpha += (cg.time - cent.trickAlphaTime)
                        cent.trickAlphaTime = cg.time

                        if cent.trickAlpha > 255 {
                            cent.trickAlpha = 255
                        }

                        doAlpha = 1
                    } else {
                        cent.trickAlpha = 255
                        cent.trickAlphaTime = cg.time
                    }
                }

                // get the player model information
                renderfx = 0
                if cent.currentState.number == cg.snap!.ps.clientNum {
                    if !cg.renderingThirdPerson {
                        if cent.currentState.weapon != WP_SABER {
                            renderfx = RF_THIRD_PERSON // only draw in mirrors
                        }
                    } else {
                        if cg_cameraMode.integer != 0 {
                            iwantout = 1


                            // goto minimal_add;

                            // NOTENOTE Temporary
                            return true
                        }
                    }
                }

                // Update the player's client entity information regarding weapons.
                // Explanation:  The entitystate has a weapond defined on it.  The cliententity does as well.
                // The cliententity's weapon tells us what the ghoul2 instance on the cliententity has bolted to it.
                // If the entitystate and cliententity weapons differ, then the state's needs to be copied to the client.
                // Save the old weapon, to verify that it is or is not the same as the new weapon.
                // rww - Make sure weapons don't get set BEFORE cent->ghoul2 is initialized or else we'll have no
                // weapon bolted on
                if cent.currentState.saberInFlight {
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
                    // Raven wrote: cent->ghoul2weapon = CG_G2WeaponInstance(cent, WP_SABER)
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                }

                // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
                // Raven wrote: if (cent->ghoul2 && (cent->currentState.eType != ET_NPC || (cent->currentState.NPC_class != CLASS_VEHICLE&&cent->currentState.NPC_class != CLASS_REMOTE&&cent->currentState.NPC_class != CLASS_SEEKER)) && //don't add weapon models to NPCs that have no bolt for them! cent->ghoul2weapon != CG_G2WeaponInstance(cent, cent->currentState.weapon) && !(cent->currentState.eFlags & EF_DEAD) && !cent->torsoBolt && cg.snap && (cent->currentState.number != cg.snap->ps.clientNum || (cg.snap->ps.pm_flags & PMF_FOLLOW))) { if (ci->team == TEAM_SPECTATOR) { cent->ghoul2weapon = NULL; cent->weapon = 0; } else { CG_CopyG2WeaponInstance(cent, cent->currentState.weapon, cent->ghoul2); if (cent->currentState.eType != ET_NPC) { if (cent->weapon == WP_SABER && cent->weapon != cent->currentState.weapon && !cent->currentState.saberHolstered) { //switching away from the saber //trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound( "sound/weapons/saber/saberoffquick.wav" )); if (ci->saber[0].soundOff && !cent->currentState.saberHolstered) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, ci->saber[0].soundOff); } if (ci->saber[1].soundOff && ci->saber[1].model[0] && !cent->currentState.saberHolstered) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, ci->saber[1].soundOff); } } else if (cent->currentState.weapon == WP_SABER && cent->weapon != cent->currentState.weapon && !cent->saberWasInFlight) { //switching to the saber //trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound( "sound/weapons/saber/saberon.wav" )); if (ci->saber[0].soundOn) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, ci->saber[0].soundOn); } if (ci->saber[1].soundOn) { trap_S_StartSound(cent->lerpOrigin, cent->currentState.number, CHAN_AUTO, ci->saber[1].soundOn); } BG_SI_SetDesiredLength(&ci->saber[0], 0, -1); BG_SI_SetDesiredLength(&ci->saber[1], 0, -1); } } cent->weapon = cent->currentState.weapon; cent->ghoul2weapon = CG_G2WeaponInstance(cent, cent->currentState.weapon); } } else if ((cent->currentState.eFlags & EF_DEAD) || cent->torsoBolt) { cent->ghoul2weapon = NULL; //be sure to update after respawning/getting limb regrown }
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")


                if cent.saberWasInFlight && g2HasWeapon {
                    cent.saberWasInFlight = false
                }

                // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

                CG_SetGhoul2Info(legs, cent)

                legs.modelScale = cent.modelScale
                legs.radius = CG_RadiusForCent(cent)
                legs.angles = vec3_t()

                if ci!.colorOverride[0] != 0.0 || ci!.colorOverride[1] != 0.0 || ci!.colorOverride[2] != 0.0 {
                    legs.shaderRGBA[0] = Int32(ci!.colorOverride[0] * 255.0)
                    legs.shaderRGBA[1] = Int32(ci!.colorOverride[1] * 255.0)
                    legs.shaderRGBA[2] = Int32(ci!.colorOverride[2] * 255.0)
                    legs.shaderRGBA[3] = cent.currentState.customRGBA[3]
                } else {
                    legs.shaderRGBA[0] = cent.currentState.customRGBA[0]
                    legs.shaderRGBA[1] = cent.currentState.customRGBA[1]
                    legs.shaderRGBA[2] = cent.currentState.customRGBA[2]
                    legs.shaderRGBA[3] = cent.currentState.customRGBA[3]
                }

                // minimal_add:

                team = ci!.team

                if cgs.gametype >= GT_TEAM && cg_drawFriend.integer != 0 && cent.currentState.number != cg.snap!.ps.clientNum && cent.currentState.eType != ET_NPC {
                    // If the view is either a spectator or on the same team as this character, show a symbol above their head.
                    if (cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR || cg.snap!.ps.persistant[PERS_TEAM] == team) && !((cent.currentState.eFlags & EF_DEAD) != 0) {
                        if cgs.gametype == GT_SIEGE {
                            //check for per-map team shaders
                            if team == SIEGETEAM_TEAM1 {
                                if cgSiegeTeam1PlShader != 0 {
                                    CG_PlayerFloatSprite(cent, cgSiegeTeam1PlShader)
                                } else {
                                    //if there isn't one fallback to default
                                    CG_PlayerFloatSprite(cent, cgs.media.teamRedShader)
                                }
                            } else {
                                if cgSiegeTeam2PlShader != 0 {
                                    CG_PlayerFloatSprite(cent, cgSiegeTeam2PlShader)
                                } else {
                                    //if there isn't one fallback to default
                                    CG_PlayerFloatSprite(cent, cgs.media.teamBlueShader)
                                }
                            }
                        } else {
                            //generic teamplay
                            if team == TEAM_RED {
                                CG_PlayerFloatSprite(cent, cgs.media.teamRedShader)
                            } else {
                                CG_PlayerFloatSprite(cent, cgs.media.teamBlueShader)
                            }
                        }
                    }
                } else if cgs.gametype == GT_POWERDUEL && cg_drawFriend.integer != 0 && cent.currentState.number != cg.snap!.ps.clientNum {
                    if cg.predictedPlayerState.persistant[PERS_TEAM] != TEAM_SPECTATOR && cent.currentState.number < MAX_CLIENTS && !((cent.currentState.eFlags & EF_DEAD) != 0) && ci != nil && cgs.clientinfo[cg.snap!.ps.clientNum].duelTeam == ci!.duelTeam {
                        //ally in powerduel, so draw the icon
                        CG_PlayerFloatSprite(cent, cgs.media.powerDuelAllyShader)
                    } else if cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_SPECTATOR && cent.currentState.number < MAX_CLIENTS && !((cent.currentState.eFlags & EF_DEAD) != 0) && ci!.duelTeam == DUELTEAM_DOUBLE {
                        CG_PlayerFloatSprite(cent, cgs.media.powerDuelAllyShader)
                    }
                }

                if cgs.gametype == GT_JEDIMASTER && cg_drawFriend.integer != 0 && cent.currentState.number != cg.snap!.ps.clientNum {
                    // If the view is either a spectator or on the same team as this character, show a symbol above their head.
                    if (cg.snap!.ps.persistant[PERS_TEAM] == TEAM_SPECTATOR || cg.snap!.ps.persistant[PERS_TEAM] == team) && !((cent.currentState.eFlags & EF_DEAD) != 0) {
                        if CG_ThereIsAMaster() {
                            if !cg.snap!.ps.isJediMaster {
                                if !cent.currentState.isJediMaster {
                                    CG_PlayerFloatSprite(cent, cgs.media.teamRedShader)
                                }
                            }
                        }
                    }
                }

                // add the shadow
                shadow = CG_PlayerShadow(cent, &shadowPlane)

                if ((cent.currentState.eFlags & EF_SEEKERDRONE) != 0 || cent.currentState.genericenemyindex != -1) && cent.currentState.eType != ET_NPC {
                    // Raven's record lives to the end of his block, so the block is the closure.
                    RefEntity.scratch { seeker in

                        // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

                        elevated = cent.lerpOrigin
                        elevated[2] += 40

                        seeker.lightingOrigin = elevated
                        seeker.shadowPlane = shadowPlane
                        seeker.renderfx = 0 //renderfx;
                        //don't show in first person?

                        angle = Float(Double((cg.time / 12) & 255) * (M_PI * 2) / 255)
                        dir[0] = cos(angle) * 20
                        dir[1] = sin(angle) * 20
                        dir[2] = cos(angle) * 5
                        seeker.origin = elevated + dir

                        seekorg = seeker.origin

                        if cent.currentState.genericenemyindex > MAX_GENTITIES {
                            var prefig: Float = Float((cent.currentState.genericenemyindex - cg.time) / 80)

                            if prefig > 55 {
                                prefig = 55
                            } else if prefig < 1 {
                                prefig = 1
                            }

                            elevated[2] -= 55 - prefig

                            angle = Float(Double((cg.time / 12) & 255) * (M_PI * 2) / 255)
                            dir[0] = cos(angle) * 20
                            dir[1] = sin(angle) * 20
                            dir[2] = cos(angle) * 5
                            seeker.origin = elevated + dir
                        } else if cent.currentState.genericenemyindex != ENTITYNUM_NONE && cent.currentState.genericenemyindex != -1 {
                            let enent: Centity? = cg_entities[cent.currentState.genericenemyindex]

                            if enent != nil {
                                enang = enent!.lerpOrigin - seekorg
                                VectorNormalize(&enang)
                                vectoangles(enang, &angles)
                                successchange = 1
                            }
                        }

                        if successchange == 0 {
                            angles[0] = sin(angle) * 30
                            angles[1] = Float((Double(angle * 180) / M_PI) + 90)
                            if angles[1] > 360 {
                                angles[1] -= 360
                            }
                            angles[2] = 0
                        }

                        AnglesToAxis(angles, &seeker.axis)

                        seeker.hModel = trap_R_RegisterModel("models/items/remote.md3")
                        trap_R_AddRefEntityToScene(seeker)
                    }
                }

                // add a water splash if partially in and out of water
                CG_PlayerSplash(cent)

                if (cg_shadows.integer == 3 || cg_shadows.integer == 2) && shadow {
                    renderfx |= RF_SHADOW_PLANE
                }
                renderfx |= RF_LIGHTING_ORIGIN // use the same origin for all

                // if we've been hit, display proper fullscreen fx
                CG_PlayerHitFX(cent)

                legs.origin = cent.lerpOrigin

                legs.lightingOrigin = cent.lerpOrigin
                legs.shadowPlane = shadowPlane
                legs.renderfx = renderfx
                if cg_shadows.integer == 2 && (renderfx & RF_THIRD_PERSON) != 0 {
                    //can see own shadow
                    legs.renderfx |= RF_SHADOW_ONLY
                }
                legs.oldorigin = legs.origin // don't positionally lerp at all

                CG_G2PlayerAngles(cent, &legs.axis, &rootAngles)
                CG_G2PlayerHeadAnims(cent)

                if (cent.currentState.eFlags2 & EF2_HELD_BY_MONSTER) != 0 && cent.currentState.hasLookTarget {
                    let rancor: Centity? = cg_entities[cent.currentState.lookTarget]
                    if rancor != nil {
                        var out_axis: [vec3_t]? = nil
                        BG_AttachToRancor(rancor!.ghoul2, rancor!.lerpAngles[YAW], &rancor!.lerpOrigin, cg.time, &cgs.gameModels, &rancor!.modelScale, (rancor!.currentState.eFlags2 & EF2_GENERIC_NPC_FLAG) != 0, &legs.origin, &legs.angles, &out_axis)

                        if cent.isRagging {
                            //hack, ragdoll has you way at bottom of bounding box
                            _VectorMA(legs.origin, 32, legs.axis[2], &legs.origin)
                        }
                        legs.oldorigin = legs.origin
                        legs.lightingOrigin = legs.origin

                        cent.lerpAngles = legs.angles
                        rootAngles = cent.lerpAngles //??? tempAngles );//tempAngles is needed a lot below
                        cent.turAngles = cent.lerpAngles
                        cent.lerpOrigin = legs.origin
                    }
                }
                //This call is mainly just to reconstruct the skeleton. But we'll get the left hand matrix while we're at it.
                //If we don't reconstruct the skeleton after setting the bone angles, we will get bad bolt points on the model
                //(e.g. the weapon model bolt will look "lagged") if there's no other GetBoltMatrix call for the rest of the
                //frame. Yes, this is stupid and needs to be fixed properly.
                //The current solution is to force it not to reconstruct the skeleton for the first GBM call in G2PlayerAngles.
                //It works and we end up only reconstructing it once, but it doesn't seem like the best solution.
                // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &lHandMatrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                gotLHandMatrix = true




                /*
                mdxaBone_t 		headMatrix;
                trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_head, &headMatrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale);
                BG_GiveMeVectorFromMatrix(&headMatrix, ORIGIN, cg.refdef.vieworg);
                */

                if (cent.currentState.eFlags & EF_DEAD) != 0 {
                    dead = true
                    //rww - since our angles are fixed when we're dead this shouldn't be an issue anyway
                    //we need to render the dying/dead player because we are now spawning the body on respawn instead of death
                    //return;
                }

                ScaleModelAxis(legs)

                // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

                //rww - force speed "trail" effect
                if !((cent.currentState.powerups & (1 << PW_SPEED)) != 0) || doAlpha != 0 || cg_speedTrail.integer == 0 {
                    cent.frame_minus1_refreshed = 0
                    cent.frame_minus2_refreshed = 0
                }

                if cent.frame_minus1_refreshed != 0 || cent.frame_minus2_refreshed != 0 {
                    var tDir = vec3_t()
                    var distVelBase: Int32 = 0

                    tDir = cent.currentState.pos.trDelta
                    distVelBase = Int32(Double(SPEED_TRAIL_DISTANCE) * (Double(VectorNormalize(&tDir)) * 0.004))

                    if cent.frame_minus1_refreshed != 0 {
                        // Raven's record lives to the end of his block, so the block is the closure.
                        RefEntity.scratch(copying: legs) { reframe_minus1 in
                            reframe_minus1.renderfx |= RF_FORCE_ENT_ALPHA
                            reframe_minus1.shaderRGBA[0] = legs.shaderRGBA[0]
                            reframe_minus1.shaderRGBA[1] = legs.shaderRGBA[1]
                            reframe_minus1.shaderRGBA[2] = legs.shaderRGBA[2]
                            reframe_minus1.shaderRGBA[3] = 100

                            //rww - if the client gets a bad framerate we will only receive frame positions
                            //once per frame anyway, so we might end up with speed trails very spread out.
                            //in order to avoid that, we'll get the direction of the last trail from the player
                            //and place the trail refent a set distance from the player location this frame
                            tDir = cent.frame_minus1 - legs.origin
                            VectorNormalize(&tDir)

                            cent.frame_minus1[0] = legs.origin[0] + tDir[0] * distVelBase
                            cent.frame_minus1[1] = legs.origin[1] + tDir[1] * distVelBase
                            cent.frame_minus1[2] = legs.origin[2] + tDir[2] * distVelBase

                            reframe_minus1.origin = cent.frame_minus1

                            //reframe_minus1.customShader = 2;

                            trap_R_AddRefEntityToScene(reframe_minus1)
                        }
                    }

                    if cent.frame_minus2_refreshed != 0 {
                        // Raven's record lives to the end of his block, so the block is the closure.
                        RefEntity.scratch(copying: legs) { reframe_minus2 in

                            reframe_minus2.renderfx |= RF_FORCE_ENT_ALPHA
                            reframe_minus2.shaderRGBA[0] = legs.shaderRGBA[0]
                            reframe_minus2.shaderRGBA[1] = legs.shaderRGBA[1]
                            reframe_minus2.shaderRGBA[2] = legs.shaderRGBA[2]
                            reframe_minus2.shaderRGBA[3] = 50

                            //Same as above but do it between trail points instead of the player and first trail entry
                            tDir = cent.frame_minus2 - cent.frame_minus1
                            VectorNormalize(&tDir)

                            cent.frame_minus2[0] = cent.frame_minus1[0] + tDir[0] * distVelBase
                            cent.frame_minus2[1] = cent.frame_minus1[1] + tDir[1] * distVelBase
                            cent.frame_minus2[2] = cent.frame_minus1[2] + tDir[2] * distVelBase

                            reframe_minus2.origin = cent.frame_minus2

                            //reframe_minus2.customShader = 2;

                            trap_R_AddRefEntityToScene(reframe_minus2)
                        }
                    }
                }

                //trigger animation-based sounds, done before next lerp frame.
                CG_TriggerAnimSounds(cent)

                // get the animation state (after rotation, to allow feet shuffle)
                CG_PlayerAnimation(cent, &legs.oldframe, &legs.frame, &legs.backlerp, &torso.oldframe, &torso.frame, &torso.backlerp)

                // add the talk baloon or disconnect icon
                CG_PlayerSprites(cent)

                if (cent.currentState.eFlags & EF_DEAD) != 0 {
                    //keep track of death anim frame for when we copy off the bodyqueue
                    ci!.frame = cent.pe.torso.frame
                }

                if cent.currentState.activeForcePass > FORCE_LEVEL_3 && cent.currentState.NPC_class != CLASS_VEHICLE {
                    var axis = [vec3_t](repeating: vec3_t(), count: 3)
                    var tAng = vec3_t()
                    var fAng = vec3_t()
                    var fxDir = vec3_t()
                    var efOrg = vec3_t()

                    let realForceLev: Int32 = (cent.currentState.activeForcePass - FORCE_LEVEL_3)

                    tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

                    fAng = vec3_t(cent.pe.torso.pitchAngle, cent.pe.torso.yawAngle, 0)

                    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    var scratchRight = vec3_t()
                    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    var scratchUp = vec3_t()
                    AngleVectors(fAng, &fxDir, &scratchRight, &scratchUp)

                    if cent.currentState.torsoAnim == BOTH_FORCE_2HANDEDLIGHTNING_HOLD && Q_irand(0, 1) != 0 {
                        //alternate back and forth between left and right
                        // Raven's record lives to the end of his block, so the block is the closure.
                        MdxaBone.scratch { rHandMatrix in
                            trap_G2API_GetBoltMatrix(cent.ghoul2, 0, ci!.bolt_rhand, rHandMatrix, cent.turAngles, cent.lerpOrigin, cg.time, &cgs.gameModels, &cent.modelScale)
                            efOrg[0] = rHandMatrix.matrix[0][3]
                            efOrg[1] = rHandMatrix.matrix[1][3]
                            efOrg[2] = rHandMatrix.matrix[2][3]
                        }
                    } else {
                        //trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale);
                        if !gotLHandMatrix {
                            // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &lHandMatrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            gotLHandMatrix = true
                        }
                        // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                        // Raven wrote: efOrg[0] = lHandMatrix.matrix[0][3]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                        // Raven wrote: efOrg[1] = lHandMatrix.matrix[1][3]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                        // Raven wrote: efOrg[2] = lHandMatrix.matrix[2][3]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    }

                    AnglesToAxis(fAng, &axis)

                    if realForceLev > FORCE_LEVEL_2 {
                        //arc
                        //trap_FX_PlayEffectID( cgs.effects.forceLightningWide, efOrg, fxDir );
                        //trap_FX_PlayEntityEffectID(cgs.effects.forceDrainWide, efOrg, axis, cent->boltInfo, cent->currentState.number, -1, -1);
                        trap_FX_PlayEntityEffectID(cgs.effects.forceDrainWide, efOrg, axis, -1, -1, -1, -1)
                    } else {
                        //line
                        //trap_FX_PlayEffectID( cgs.effects.forceLightning, efOrg, fxDir );
                        //trap_FX_PlayEntityEffectID(cgs.effects.forceDrain, efOrg, axis, cent->boltInfo, cent->currentState.number, -1, -1);
                        trap_FX_PlayEntityEffectID(cgs.effects.forceDrain, efOrg, axis, -1, -1, -1, -1)
                    }

                    /*
                    if (cent->bolt4 < cg.time)
                    {
                    cent->bolt4 = cg.time + 100;
                    trap_S_StartSound(NULL, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound("sound/weapons/force/drain.wav") );
                    }
                    */
                } else if cent.currentState.activeForcePass != 0 && cent.currentState.NPC_class != CLASS_VEHICLE {
                    //doing the electrocuting
                    var axis = [vec3_t](repeating: vec3_t(), count: 3)
                    var tAng = vec3_t()
                    var fAng = vec3_t()
                    var fxDir = vec3_t()
                    var efOrg = vec3_t()

                    tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

                    fAng = vec3_t(cent.pe.torso.pitchAngle, cent.pe.torso.yawAngle, 0)

                    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    var scratchRight2 = vec3_t()
                    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    var scratchUp2 = vec3_t()
                    AngleVectors(fAng, &fxDir, &scratchRight2, &scratchUp2)

                    //trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale);
                    if !gotLHandMatrix {
                        // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                        // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &lHandMatrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        gotLHandMatrix = true
                    }

                    // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                    // Raven wrote: efOrg[0] = lHandMatrix.matrix[0][3]
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                    // Raven wrote: efOrg[1] = lHandMatrix.matrix[1][3]
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                    // Raven wrote: efOrg[2] = lHandMatrix.matrix[2][3]
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                    AnglesToAxis(fAng, &axis)

                    if cent.currentState.activeForcePass > FORCE_LEVEL_2 {
                        //arc
                        //trap_FX_PlayEffectID( cgs.effects.forceLightningWide, efOrg, fxDir );
                        //trap_FX_PlayEntityEffectID(cgs.effects.forceLightningWide, efOrg, axis, cent->boltInfo, cent->currentState.number, -1, -1);
                        trap_FX_PlayEntityEffectID(cgs.effects.forceLightningWide, efOrg, axis, -1, -1, -1, -1)
                    } else {
                        //line
                        //trap_FX_PlayEffectID( cgs.effects.forceLightning, efOrg, fxDir );
                        //trap_FX_PlayEntityEffectID(cgs.effects.forceLightning, efOrg, axis, cent->boltInfo, cent->currentState.number, -1, -1);
                        trap_FX_PlayEntityEffectID(cgs.effects.forceLightning, efOrg, axis, -1, -1, -1, -1)
                    }

                    /*
                    if (cent->bolt4 < cg.time)
                    {
                    cent->bolt4 = cg.time + 100;
                    trap_S_StartSound(NULL, cent->currentState.number, CHAN_AUTO, trap_S_RegisterSound("sound/weapons/force/lightning.wav") );
                    }
                    */
                }

                //fullbody push effect
                if (cent.currentState.eFlags & EF_BODYPUSH) != 0 {
                    CG_ForcePushBodyBlur(cent)
                }

                if (cent.currentState.powerups & (1 << PW_DISINT_4)) != 0 {
                    var tAng = vec3_t()
                    var efOrg = vec3_t()

                    //VectorSet( tAng, 0, cent->pe.torso.yawAngle, 0 );
                    tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

                    //trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale);
                    if !gotLHandMatrix {
                        // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                        // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_lhand, &lHandMatrix, cent->turAngles, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        gotLHandMatrix = true
                    }

                    // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                    // Raven wrote: efOrg[0] = lHandMatrix.matrix[0][3]
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                    // Raven wrote: efOrg[1] = lHandMatrix.matrix[1][3]
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                    // Raven wrote: efOrg[2] = lHandMatrix.matrix[2][3]
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                    if (cent.currentState.forcePowersActive & (1 << FP_GRIP)) != 0 && (cg.renderingThirdPerson || cent.currentState.number != cg.snap!.ps.clientNum) {
                        var boltDir = vec3_t()
                        var origBolt = vec3_t()
                        origBolt = efOrg
                        // Port-note: A read of `lHandMatrix`, a local the draft left as a hole.
                        // Raven wrote: BG_GiveMeVectorFromMatrix( &lHandMatrix, NEGATIVE_Y, boltDir )
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                        CG_ForceGripEffect(efOrg)
                        CG_ForceGripEffect(efOrg)

                        /*
                        //Render a scaled version of the model's hand with a n337 looking shader
                        {
                        const char *rotateBone;
                        char *limbName;
                        char *limbCapName;
                        vec3_t armAng;
                        refEntity_t regrip_arm;
                        float wv = sin( cg.time * 0.003f ) * 0.08f + 0.1f;

                        //rotateBone = "lradius";
                        rotateBone = "lradiusX";
                        limbName = "l_arm";
                        limbCapName = "l_arm_cap_torso";

                        if (cent->grip_arm && trap_G2_HaveWeGhoul2Models(cent->grip_arm))
                        {
                        trap_G2API_CleanGhoul2Models(&(cent->grip_arm));
                        }

                        memset( &regrip_arm, 0, sizeof(regrip_arm) );

                        VectorCopy(origBolt, efOrg);


                        //efOrg[2] += 8;
                        efOrg[2] -= 4;

                        VectorCopy(efOrg, regrip_arm.origin);
                        VectorCopy(regrip_arm.origin, regrip_arm.lightingOrigin);

                        //VectorCopy(cent->lerpAngles, armAng);
                        VectorAdd(vec3_origin, rootAngles, armAng);
                        //armAng[ROLL] = -90;
                        armAng[ROLL] = 0;
                        armAng[PITCH] = 0;
                        AnglesToAxis(armAng, regrip_arm.axis);

                        trap_G2API_DuplicateGhoul2Instance(cent->ghoul2, &cent->grip_arm);

                        //remove all other models
                        if (trap_G2API_HasGhoul2ModelOnIndex(&(cent->grip_arm), 1))
                        { //weapon right
                        trap_G2API_RemoveGhoul2Model(&(cent->grip_arm), 1);
                        }
                        if (trap_G2API_HasGhoul2ModelOnIndex(&(cent->grip_arm), 2))
                        { //weapon left
                        trap_G2API_RemoveGhoul2Model(&(cent->grip_arm), 2);
                        }
                        if (trap_G2API_HasGhoul2ModelOnIndex(&(cent->grip_arm), 3))
                        { //jetpack
                        trap_G2API_RemoveGhoul2Model(&(cent->grip_arm), 3);
                        }

                        trap_G2API_SetRootSurface(cent->grip_arm, 0, limbName);
                        trap_G2API_SetNewOrigin(cent->grip_arm, trap_G2API_AddBolt(cent->grip_arm, 0, rotateBone));
                        trap_G2API_SetSurfaceOnOff(cent->grip_arm, limbCapName, 0);

                        regrip_arm.modelScale[0] = 1;//+(wv*6);
                        regrip_arm.modelScale[1] = 1;//+(wv*6);
                        regrip_arm.modelScale[2] = 1;//+(wv*6);
                        ScaleModelAxis(&regrip_arm);

                        regrip_arm.radius = 64;

                        regrip_arm.customShader = trap_R_RegisterShader( "gfx/misc/red_portashield" );

                        regrip_arm.renderfx |= RF_RGB_TINT;
                        regrip_arm.shaderRGBA[0] = 255 - (wv*900);
                        if (regrip_arm.shaderRGBA[0] < 30)
                        {
                        regrip_arm.shaderRGBA[0] = 30;
                        }
                        if (regrip_arm.shaderRGBA[0] > 255)
                        {
                        regrip_arm.shaderRGBA[0] = 255;
                        }
                        regrip_arm.shaderRGBA[1] = regrip_arm.shaderRGBA[2] = regrip_arm.shaderRGBA[0];

                        regrip_arm.ghoul2 = cent->grip_arm;
                        trap_R_AddRefEntityToScene( &regrip_arm );
                        }
                        */
                    } else if !((cent.currentState.forcePowersActive & (1 << FP_GRIP)) != 0) {
                        //use refractive effect
                        CG_ForcePushBlur(efOrg, cent)
                    }
                } else if cent.bodyFadeTime != 0 {
                    //reset the counter for keeping track of push refraction effect state
                    cent.bodyFadeTime = 0
                }

                if cent.currentState.weapon == WP_STUN_BATON && cent.currentState.number == cg.snap!.ps.clientNum {
                    trap_S_AddLoopingSound(cent.currentState.number, cg.refdef.vieworg, vec3_origin, trap_S_RegisterSound("sound/weapons/baton/idle.wav"))
                }

                //NOTE: All effects that should be visible during mindtrick should go above here

                if iwantout != 0 {
                    break stillDoSaber
                    //return;
                } else if doAlpha != 0 {
                    legs.renderfx |= RF_FORCE_ENT_ALPHA
                    legs.shaderRGBA[3] = cent.trickAlpha

                    if legs.shaderRGBA[3] < 1 {
                        //don't cancel it out even if it's < 1
                        legs.shaderRGBA[3] = 1
                    }
                }

                if cent.teamPowerEffectTime > cg.time {
                    if cent.teamPowerType {
                        //absorb is a somewhat different effect entirely
                        //Guess I'll take care of it where it's always been, just checking these values instead.
                    } else {
                        var preCol: [Float] = [Float](repeating: 0, count: 4)
                        var preRFX: Int32 = 0

                        preRFX = legs.renderfx

                        legs.renderfx |= RF_RGB_TINT
                        legs.renderfx |= RF_FORCE_ENT_ALPHA

                        preCol[0] = Float(legs.shaderRGBA[0])
                        preCol[1] = Float(legs.shaderRGBA[1])
                        preCol[2] = Float(legs.shaderRGBA[2])
                        preCol[3] = Float(legs.shaderRGBA[3])

                        if cent.teamPowerType {
                            //heal
                            legs.shaderRGBA[0] = 0
                            legs.shaderRGBA[1] = 255
                            legs.shaderRGBA[2] = 0
                        } else if !cent.teamPowerType {
                            //regen
                            legs.shaderRGBA[0] = 0
                            legs.shaderRGBA[1] = 0
                            legs.shaderRGBA[2] = 255
                        } else {
                            //drain
                            legs.shaderRGBA[0] = 255
                            legs.shaderRGBA[1] = 0
                            legs.shaderRGBA[2] = 0
                        }

                        legs.shaderRGBA[3] = ((cent.teamPowerEffectTime - cg.time) / 8)

                        legs.customShader = trap_R_RegisterShader("powerups/ysalimarishell")
                        trap_R_AddRefEntityToScene(legs)

                        legs.customShader = 0
                        legs.renderfx = preRFX
                        legs.shaderRGBA[0] = Int32(preCol[0])
                        legs.shaderRGBA[1] = Int32(preCol[1])
                        legs.shaderRGBA[2] = Int32(preCol[2])
                        legs.shaderRGBA[3] = Int32(preCol[3])
                    }
                }

                //If you've tricked this client.
                if CG_IsMindTricked(cg.snap!.ps.fd.forceMindtrickTargetIndex, cg.snap!.ps.fd.forceMindtrickTargetIndex2, cg.snap!.ps.fd.forceMindtrickTargetIndex3, cg.snap!.ps.fd.forceMindtrickTargetIndex4, cent.currentState.number) != 0 {
                    if cent.ghoul2 != nil {
                        var efOrg = vec3_t()
                        var tAng = vec3_t()
                        var fxAng = vec3_t()
                        var axis = [vec3_t](repeating: vec3_t(), count: 3)

                        //VectorSet( tAng, 0, cent->pe.torso.yawAngle, 0 );
                        tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_head, &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: BG_GiveMeVectorFromMatrix(&boltMatrix, ORIGIN, efOrg)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: BG_GiveMeVectorFromMatrix(&boltMatrix, NEGATIVE_Y, fxAng)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[0][0] = boltMatrix.matrix[0][0]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[0][1] = boltMatrix.matrix[1][0]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[0][2] = boltMatrix.matrix[2][0]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[1][0] = boltMatrix.matrix[0][1]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[1][1] = boltMatrix.matrix[1][1]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[1][2] = boltMatrix.matrix[2][1]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[2][0] = boltMatrix.matrix[0][2]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[2][1] = boltMatrix.matrix[1][2]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                        // Raven wrote: axis[2][2] = boltMatrix.matrix[2][2]
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                        //trap_FX_PlayEntityEffectID(trap_FX_RegisterEffect("force/confusion.efx"), efOrg, axis, cent->boltInfo, cent->currentState.number);
                        trap_FX_PlayEntityEffectID(cgs.effects.mForceConfustionOld, efOrg, axis, -1, -1, -1, -1)
                    }
                }

                if cgs.gametype == GT_HOLOCRON && cent.currentState.time2 != 0 && (cg.renderingThirdPerson || cg.snap!.ps.clientNum != cent.currentState.number) {
                    var i: Int32 = 0
                    var renderedHolos: Int32 = 0
                    // Raven's record lives to the end of his block, so the block is the closure.
                    RefEntity.scratch { holoRef in

                        while i < NUM_FORCE_POWERS && renderedHolos < 3 {
                            if (cent.currentState.time2 & (1 << i)) != 0 {
                                holoRef.clear()

                                elevated = cent.lerpOrigin
                                elevated[2] += 8

                                holoRef.lightingOrigin = elevated
                                holoRef.shadowPlane = shadowPlane
                                holoRef.renderfx = 0 //RF_THIRD_PERSON;

                                if renderedHolos == 0 {
                                    angle = Float(Double((cg.time / 8) & 255) * (M_PI * 2) / 255)
                                    dir[0] = cos(angle) * 20
                                    dir[1] = sin(angle) * 20
                                    dir[2] = cos(angle) * 20
                                    holoRef.origin = elevated + dir

                                    angles[0] = sin(angle) * 30
                                    angles[1] = Float((Double(angle * 180) / M_PI) + 90)
                                    if angles[1] > 360 {
                                        angles[1] -= 360
                                    }
                                    angles[2] = 0
                                    AnglesToAxis(angles, &holoRef.axis)
                                } else if renderedHolos == 1 {
                                    angle = Float(Double((cg.time / 8) & 255) * (M_PI * 2) / 255 + M_PI)
                                    if Double(angle) > M_PI * 2 {
                                        angle -= Float(M_PI) * 2
                                    }
                                    dir[0] = sin(angle) * 20
                                    dir[1] = cos(angle) * 20
                                    dir[2] = cos(angle) * 20
                                    holoRef.origin = elevated + dir

                                    angles[0] = Float(cos(Double(angle) - 0.5 * M_PI) * 30)
                                    angles[1] = Float(360 - (Double(angle * 180) / M_PI))
                                    if angles[1] > 360 {
                                        angles[1] -= 360
                                    }
                                    angles[2] = 0
                                    AnglesToAxis(angles, &holoRef.axis)
                                } else {
                                    angle = Float(Double((cg.time / 6) & 255) * (M_PI * 2) / 255 + 0.5 * M_PI)
                                    if Double(angle) > M_PI * 2 {
                                        angle -= Float(M_PI) * 2
                                    }
                                    dir[0] = sin(angle) * 20
                                    dir[1] = cos(angle) * 20
                                    dir[2] = 0
                                    holoRef.origin = elevated + dir

                                    holoRef.axis[1] = dir
                                    VectorNormalize(&holoRef.axis[1])
                                    holoRef.axis[2] = vec3_t(0, 0, 1)
                                    CrossProduct(holoRef.axis[1], holoRef.axis[2], &holoRef.axis[0])
                                }

                                holoRef.modelScale[0] = 0.5
                                holoRef.modelScale[1] = 0.5
                                holoRef.modelScale[2] = 0.5
                                ScaleModelAxis(holoRef)

                                do {
                                    var wv: Float = 0
                                    // Raven's record lives to the end of his block, so the block is the closure.
                                    AddspriteArgStruct.scratch { fxSArgs in
                                        var holoCenter = vec3_t()

                                        holoCenter[0] = holoRef.origin[0] + holoRef.axis[2][0] * 18
                                        holoCenter[1] = holoRef.origin[1] + holoRef.axis[2][1] * 18
                                        holoCenter[2] = holoRef.origin[2] + holoRef.axis[2][2] * 18

                                        wv = sin(cg.time * 0.004) * 0.08 + 0.1

                                        fxSArgs.origin = holoCenter
                                        fxSArgs.vel = vec3_t()
                                        fxSArgs.accel = vec3_t()
                                        fxSArgs.scale = wv * 60
                                        fxSArgs.dscale = wv * 60
                                        fxSArgs.sAlpha = wv * 12
                                        fxSArgs.eAlpha = wv * 12
                                        fxSArgs.rotation = 0.0
                                        fxSArgs.bounce = 0.0
                                        fxSArgs.life = 1

                                        fxSArgs.flags = 0x08000000 | 0x00000001

                                        if forcePowerDarkLight[i] == FORCE_DARKSIDE {
                                            //dark
                                            fxSArgs.sAlpha *= 3
                                            fxSArgs.eAlpha *= 3
                                            fxSArgs.shader = cgs.media.redSaberGlowShader
                                            trap_FX_AddSprite(fxSArgs)
                                        } else if forcePowerDarkLight[i] == FORCE_LIGHTSIDE {
                                            //light
                                            fxSArgs.sAlpha = Float(Double(fxSArgs.sAlpha) * 1.5)
                                            fxSArgs.eAlpha = Float(Double(fxSArgs.eAlpha) * 1.5)
                                            fxSArgs.shader = cgs.media.redSaberGlowShader
                                            trap_FX_AddSprite(fxSArgs)
                                            fxSArgs.shader = cgs.media.greenSaberGlowShader
                                            trap_FX_AddSprite(fxSArgs)
                                            fxSArgs.shader = cgs.media.blueSaberGlowShader
                                            trap_FX_AddSprite(fxSArgs)
                                        } else {
                                            //neutral
                                            if i == FP_SABER_OFFENSE || i == FP_SABER_DEFENSE || i == FP_SABERTHROW {
                                                //saber power
                                                fxSArgs.sAlpha = Float(Double(fxSArgs.sAlpha) * 1.5)
                                                fxSArgs.eAlpha = Float(Double(fxSArgs.eAlpha) * 1.5)
                                                fxSArgs.shader = cgs.media.greenSaberGlowShader
                                                trap_FX_AddSprite(fxSArgs)
                                            } else {
                                                fxSArgs.sAlpha = Float(Double(fxSArgs.sAlpha) * 0.5)
                                                fxSArgs.eAlpha = Float(Double(fxSArgs.eAlpha) * 0.5)
                                                fxSArgs.shader = cgs.media.greenSaberGlowShader
                                                trap_FX_AddSprite(fxSArgs)
                                                fxSArgs.shader = cgs.media.blueSaberGlowShader
                                                trap_FX_AddSprite(fxSArgs)
                                            }
                                        }
                                    }
                                }

                                holoRef.hModel = trap_R_RegisterModel(forceHolocronModels[i])
                                trap_R_AddRefEntityToScene(holoRef)

                                renderedHolos += 1
                            }
                            i += 1
                        }
                    }
                }

                if (cent.currentState.powerups & (1 << PW_YSALAMIRI)) != 0 || (cgs.gametype == GT_CTY && ((cent.currentState.powerups & (1 << PW_REDFLAG)) != 0 || (cent.currentState.powerups & (1 << PW_BLUEFLAG)) != 0)) {
                    if cgs.gametype == GT_CTY && (cent.currentState.powerups & (1 << PW_REDFLAG)) != 0 {
                        CG_DrawPlayerSphere(cent, cent.lerpOrigin, 1.4, cgs.media.ysaliredShader)
                    } else if cgs.gametype == GT_CTY && (cent.currentState.powerups & (1 << PW_BLUEFLAG)) != 0 {
                        CG_DrawPlayerSphere(cent, cent.lerpOrigin, 1.4, cgs.media.ysaliblueShader)
                    } else {
                        CG_DrawPlayerSphere(cent, cent.lerpOrigin, 1.4, cgs.media.ysalimariShader)
                    }
                }

                if (cent.currentState.powerups & (1 << PW_FORCE_BOON)) != 0 {
                    CG_DrawPlayerSphere(cent, cent.lerpOrigin, 2.0, cgs.media.boonShader)
                }

                if (cent.currentState.powerups & (1 << PW_FORCE_ENLIGHTENED_DARK)) != 0 {
                    CG_DrawPlayerSphere(cent, cent.lerpOrigin, 2.0, cgs.media.endarkenmentShader)
                } else if (cent.currentState.powerups & (1 << PW_FORCE_ENLIGHTENED_LIGHT)) != 0 {
                    CG_DrawPlayerSphere(cent, cent.lerpOrigin, 2.0, cgs.media.enlightenmentShader)
                }

                if (cent.currentState.eFlags & EF_INVULNERABLE) != 0 {
                    CG_DrawPlayerSphere(cent, cent.lerpOrigin, 1.0, cgs.media.invulnerabilityShader)
                }
            }
            if (cent.currentState.eFlags & EF_DEAD) != 0 && cent.currentState.weapon == WP_SABER {
                //cent->saberLength = 0;
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                drawPlayerSaber = true
            } else if cent.currentState.weapon == WP_SABER && cent.currentState.saberHolstered < 2 {
                if (!cent.currentState.saberInFlight || ci!.saber[1].soundLoop != 0) && !((cent.currentState.eFlags & EF_DEAD) != 0) {
                    var soundSpot = vec3_t()
                    var didFirstSound: Bool = false

                    if cg.snap!.ps.clientNum == cent.currentState.number {
                        //trap_S_AddLoopingSound( cent->currentState.number, cg.refdef.vieworg, vec3_origin,
                        //	trap_S_RegisterSound( "sound/weapons/saber/saberhum1.wav" ) );
                        soundSpot = cg.refdef.vieworg
                    } else {
                        //trap_S_AddLoopingSound( cent->currentState.number, cent->lerpOrigin, vec3_origin,
                        //	trap_S_RegisterSound( "sound/weapons/saber/saberhum1.wav" ) );
                        soundSpot = cent.lerpOrigin
                    }

                    if !ci!.saber[0].model.isEmpty && ci!.saber[0].soundLoop != 0 && !cent.currentState.saberInFlight {
                        var i: Int32 = 0
                        var hasLen: Bool = false

                        while i < ci!.saber[0].numBlades {
                            if ci!.saber[0].blade[i].length != 0 {
                                hasLen = true
                                break
                            }
                            i += 1
                        }

                        if hasLen {
                            trap_S_AddLoopingSound(cent.currentState.number, soundSpot, vec3_origin, ci!.saber[0].soundLoop)
                            didFirstSound = true
                        }
                    }
                    if !ci!.saber[1].model.isEmpty && ci!.saber[1].soundLoop != 0 && (!didFirstSound || ci!.saber[0].soundLoop != ci!.saber[1].soundLoop) {
                        var i: Int32 = 0
                        var hasLen: Bool = false

                        while i < ci!.saber[1].numBlades {
                            if ci!.saber[1].blade[i].length != 0 {
                                hasLen = true
                                break
                            }
                            i += 1
                        }

                        if hasLen {
                            trap_S_AddLoopingSound(cent.currentState.number, soundSpot, vec3_origin, ci!.saber[1].soundLoop)
                        }
                    }
                }

                if iwantout != 0 && !cent.currentState.saberInFlight {
                    if (cent.currentState.eFlags & EF_DEAD) != 0 {
                        if cent.ghoul2 != nil && cent.currentState.saberInFlight && g2HasWeapon {
                            //special case, kill the saber on a freshly dead player if another source says to.
                            trap_G2API_RemoveGhoul2Model(&(cent.ghoul2), 1)
                            g2HasWeapon = false
                        }
                    }
                    return true
                    //goto endOfCall;
                }

                if g2HasWeapon && cent.currentState.saberInFlight {
                    //keep this set, so we don't re-unholster the thing when we get it back, even if it's knocked away.
                    cent.saberWasInFlight = true
                }

                if cent.currentState.saberInFlight && cent.currentState.saberEntityNum != 0 {
                    var saberEnt: Centity?

                    saberEnt = cg_entities[cent.currentState.saberEntityNum]

                    if g2HasWeapon || cent.bolt3 == 0 || saberEnt!.serverSaberHitIndex != saberEnt!.currentState.modelindex {
                        //saber is in flight, do not have it as a standard weapon model
                        var addBolts: Bool = false
                        // Raven's record lives to the end of his block, so the block is the closure.
                        MdxaBone.scratch { boltMat in

                            if g2HasWeapon {
                                //ah well, just stick it over the right hand right now.
                                trap_G2API_GetBoltMatrix(cent.ghoul2, 0, ci!.bolt_rhand, boltMat, cent.turAngles, cent.lerpOrigin, cg.time, &cgs.gameModels, &cent.modelScale)
                                BG_GiveMeVectorFromMatrix(boltMat, ORIGIN, &saberEnt!.currentState.pos.trBase)

                                trap_G2API_RemoveGhoul2Model(&(cent.ghoul2), 1)
                                g2HasWeapon = false
                            }

                            //cent->bolt4 = 1;

                            saberEnt!.currentState.pos.trTime = cg.time
                            saberEnt!.currentState.apos.trTime = cg.time

                            saberEnt!.lerpOrigin = saberEnt!.currentState.pos.trBase
                            saberEnt!.lerpAngles = saberEnt!.currentState.apos.trBase

                            cent.bolt3 = Int32(saberEnt!.currentState.apos.trBase[0])
                            if cent.bolt3 == 0 {
                                cent.bolt3 = 1
                            }
                            cent.bolt2 = 0

                            saberEnt!.currentState.bolt2 = 123

                            if saberEnt!.ghoul2 != nil && saberEnt!.serverSaberHitIndex == saberEnt!.currentState.modelindex {
                                // now set up the gun bolt on it
                                addBolts = true
                            } else {
                                let saberModel: String = CG_ConfigString(CS_MODELS + saberEnt!.currentState.modelindex)

                                saberEnt!.serverSaberHitIndex = saberEnt!.currentState.modelindex

                                if saberEnt!.ghoul2 != nil {
                                    //clean if we already have one (because server changed model string index)
                                    trap_G2API_CleanGhoul2Models(&(saberEnt!.ghoul2))
                                    saberEnt!.ghoul2 = 0
                                }

                                if !saberModel.isEmpty {
                                    trap_G2API_InitGhoul2Model(&saberEnt!.ghoul2, saberModel, 0, 0, 0, 0, 0)
                                } else if !ci!.saber[0].model.isEmpty {
                                    trap_G2API_InitGhoul2Model(&saberEnt!.ghoul2, ci!.saber[0].model, 0, 0, 0, 0, 0)
                                } else {
                                    trap_G2API_InitGhoul2Model(&saberEnt!.ghoul2, "models/weapons2/saber/saber_w.glm", 0, 0, 0, 0, 0)
                                }
                                //trap_G2API_DuplicateGhoul2Instance(cent->ghoul2, &saberEnt->ghoul2);

                                if saberEnt!.ghoul2 != nil {
                                    addBolts = true
                                    //cent->bolt4 = 2;

                                    saberEnt!.lerpOrigin = saberEnt!.currentState.pos.trBase
                                    saberEnt!.lerpAngles = saberEnt!.currentState.apos.trBase
                                    saberEnt!.currentState.pos.trTime = cg.time
                                    saberEnt!.currentState.apos.trTime = cg.time
                                }
                            }

                            if addBolts {
                                var m: Int32 = 0
                                var tagBolt: Int32 = 0
                                var tagName: String

                                while m < ci!.saber[0].numBlades {
                                    tagName = va("*blade%i", m + 1)
                                    tagBolt = trap_G2API_AddBolt(saberEnt!.ghoul2, 0, tagName)

                                    if tagBolt == -1 {
                                        if m == 0 {
                                            //guess this is an 0ldsk3wl saber
                                            tagBolt = trap_G2API_AddBolt(saberEnt!.ghoul2, 0, "*flash")

                                            if tagBolt == -1 {
                                            }
                                            break
                                        }

                                        if tagBolt == -1 {
                                            break
                                        }
                                    }

                                    m += 1
                                }
                            }
                        }
                    }
                    /*else if (cent->bolt4 != 2)
                    {
                    if (saberEnt->ghoul2)
                    {
                    trap_G2API_AddBolt(saberEnt->ghoul2, 0, "*flash");
                    cent->bolt4 = 2;
                    }
                    }*/

                    if saberEnt != nil && saberEnt!.ghoul2 != nil {
                        var bladeAngles = vec3_t()
                        var tAng = vec3_t()
                        var efOrg = vec3_t()
                        var wv: Float = 0
                        var k: Int32 = 0
                        var l: Int32 = 0
                        // Raven's record lives to the end of his block, so the block is the closure.
                        AddspriteArgStruct.scratch { fxSArgs in

                            if cent.bolt2 == 0 {
                                cent.bolt2 = cg.time
                            }

                            if cent.bolt3 != 90 {
                                if cent.bolt3 < 90 {
                                    cent.bolt3 = Int32(Double(cent.bolt3) + Double(cg.time - cent.bolt2) * 0.5)

                                    if cent.bolt3 > 90 {
                                        cent.bolt3 = 90
                                    }
                                } else if cent.bolt3 > 90 {
                                    cent.bolt3 = Int32(Double(cent.bolt3) - Double(cg.time - cent.bolt2) * 0.5)

                                    if cent.bolt3 < 90 {
                                        cent.bolt3 = 90
                                    }
                                }
                            }

                            cent.bolt2 = cg.time

                            saberEnt!.currentState.apos.trBase[0] = Float(cent.bolt3)
                            saberEnt!.lerpAngles[0] = Float(cent.bolt3)

                            if !saberEnt!.currentState.saberInFlight && saberEnt!.currentState.bolt2 != 123 {
                                //owner is pulling is back
                                if !((ci!.saber[0].saberFlags & SFL_RETURN_DAMAGE) != 0) || cent.currentState.saberHolstered != 0 {
                                    var owndir = vec3_t()

                                    owndir = saberEnt!.lerpOrigin - cent.lerpOrigin
                                    VectorNormalize(&owndir)

                                    vectoangles(owndir, &owndir)

                                    owndir[0] += 90

                                    saberEnt!.currentState.apos.trBase = owndir
                                    saberEnt!.lerpAngles = owndir
                                    saberEnt!.currentState.apos.trDelta = vec3_t()
                                }
                            }

                            //We don't actually want to rely entirely on server updates to render the position of the saber, because we actually know generally where
                            //it's going to be before the first position update even gets here, and it needs to start getting rendered the instant the saber model is
                            //removed from the player hand. So we'll just render it manually and let normal rendering for the entity be ignored.
                            if !saberEnt!.currentState.saberInFlight && saberEnt!.currentState.bolt2 != 123 {
                                //tell it that we're a saber and to render the glow around our handle because we're being pulled back
                                saberEnt!.bolt3 = 999
                            }

                            saberEnt!.currentState.modelGhoul2 = 1
                            CG_ManualEntityRender(saberEnt!)
                            saberEnt!.bolt3 = 0
                            saberEnt!.currentState.modelGhoul2 = 127

                            bladeAngles = saberEnt!.lerpAngles
                            bladeAngles[ROLL] = 0

                            if ci!.saber[0].numBlades > 1 && cent.currentState.saberHolstered == 1 {
                                //only first blade should be on
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], -1, 0)
                                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            } else {
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], -1, -1)
                                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            }
                            if !ci!.saber[1].model.isEmpty && cent.currentState.saberHolstered == 1 {
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            } else {
                                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], -1, -1)
                                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            }

                            //while (l < MAX_SABERS)
                            //Only want to do for the first saber actually, it's the one in flight.
                            while l < 1 {
                                if ci!.saber[l].model.isEmpty {
                                    break
                                }

                                k = 0
                                while k < ci!.saber[l].numBlades {
                                    if l == 0 && cent.currentState.saberHolstered == 1 && k > 0 {
                                        //extra blades off
                                        //don't draw them
                                        CG_AddSaberBlade(cent, saberEnt!, nil, 0, 0, l, k, saberEnt!.lerpOrigin, bladeAngles, true, true)
                                    } else {
                                        CG_AddSaberBlade(cent, saberEnt!, nil, 0, 0, l, k, saberEnt!.lerpOrigin, bladeAngles, true, false)
                                    }

                                    k += 1
                                }
                                if ci!.saber[l].numBlades > 2 {
                                    //add a single glow for the saber based on all the blade colors combined
                                    CG_DoSaberLight(ci!.saber[l])
                                }

                                l += 1
                            }

                            //Make the player's hand glow while guiding the saber
                            tAng = vec3_t(cent.turAngles[PITCH], cent.turAngles[YAW], cent.turAngles[ROLL])

                            // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                            // Raven wrote: trap_G2API_GetBoltMatrix(cent->ghoul2, 0, ci->bolt_rhand, &boltMatrix, tAng, cent->lerpOrigin, cg.time, cgs.gameModels, cent->modelScale)
                            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                            // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                            // Raven wrote: efOrg[0] = boltMatrix.matrix[0][3]
                            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                            // Raven wrote: efOrg[1] = boltMatrix.matrix[1][3]
                            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                            // Port-note: A read of `boltMatrix`, a local the draft left as a hole.
                            // Raven wrote: efOrg[2] = boltMatrix.matrix[2][3]
                            portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                            wv = sin(cg.time * 0.003) * 0.08 + 0.1

                            //trap_FX_AddSprite( NULL, efOrg, NULL, NULL, 8.0f, 8.0f, wv, wv, 0.0f, 0.0f, 1.0f, cgs.media.yellowSaberGlowShader, 0x08000000 );
                            fxSArgs.origin = efOrg
                            fxSArgs.vel = vec3_t()
                            fxSArgs.accel = vec3_t()
                            fxSArgs.scale = 8.0
                            fxSArgs.dscale = 8.0
                            fxSArgs.sAlpha = wv
                            fxSArgs.eAlpha = wv
                            fxSArgs.rotation = 0.0
                            fxSArgs.bounce = 0.0
                            fxSArgs.life = 1
                            fxSArgs.shader = cgs.media.yellowDroppedSaberShader
                            fxSArgs.flags = 0x08000000
                            trap_FX_AddSprite(fxSArgs)
                        }
                    }
                } else {
                    if ci!.saber[0].numBlades > 1 && cent.currentState.saberHolstered == 1 {
                        //only first blade should be on
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                        // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                        // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], -1, 0)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    } else {
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                        // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], -1, -1)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    }
                    if !ci!.saber[1].model.isEmpty && cent.currentState.saberHolstered == 1 {
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                        // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    } else {
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                        // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], -1, -1)
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    }
                }

                //If the arm the saber is in is broken, turn it off.
                /*
                if (cent->currentState.brokenLimbs & (1 << BROKENLIMB_RARM))
                {
                BG_SI_SetDesiredLength(&ci->saber[0], 0, -1);
                }
                */
                //Leaving right arm on, at least for now.
                if (cent.currentState.brokenLimbs & (1 << BROKENLIMB_LARM)) != 0 {
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                    // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                }

                if cent.currentState.saberEntityNum == 0 {
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                    // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                    portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                    //BG_SI_SetDesiredLength(&ci->saber[1], 0, -1);
                }
                /*
                else
                {
                BG_SI_SetDesiredLength(&ci->saber[0], 0, -1);
                BG_SI_SetDesiredLength(&ci->saber[1], 0, -1);
                }
                */
                drawPlayerSaber = true
            } else if cent.currentState.weapon == WP_SABER {
                //cent->saberLength = 0;
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                drawPlayerSaber = true
            } else {
                //cent->saberLength = 0;
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetLength' in scope".
                // Raven wrote: BG_SI_SetLength(&ci->saber[0], 0)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetLength' in scope".
                // Raven wrote: BG_SI_SetLength(&ci->saber[1], 0)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
            }


            if cent.currentState.weapon == WP_SABER {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetLengthGradual' in scope".
                // Raven wrote: BG_SI_SetLengthGradual(&ci->saber[0], cg.time)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetLengthGradual' in scope".
                // Raven wrote: BG_SI_SetLengthGradual(&ci->saber[1], cg.time)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
            }

            if drawPlayerSaber {
                var saberEnt: Centity?
                var k: Int32 = 0
                var l: Int32 = 0

                if cent.currentState.saberEntityNum == 0 {
                    l = 1 //The "primary" saber is missing or in flight or something, so only try to draw in the second one
                } else if !cent.currentState.saberInFlight {
                    saberEnt = cg_entities[cent.currentState.saberEntityNum]

                    if !g2HasWeapon {
                        trap_G2API_CopySpecificGhoul2Model(CG_G2WeaponInstance(cent, WP_SABER), 0, cent.ghoul2, 1)

                        if saberEnt != nil && saberEnt!.ghoul2 != nil {
                            trap_G2API_CleanGhoul2Models(&(saberEnt!.ghoul2))
                        }

                        saberEnt!.currentState.modelindex = 0
                        saberEnt!.ghoul2 = nil
                        saberEnt!.currentState.pos.trBase = vec3_t()
                    }

                    cent.bolt3 = 0
                    cent.bolt2 = 0
                } else {
                    l = 1 //The "primary" saber is missing or in flight or something, so only try to draw in the second one
                }

                while l < MAX_SABERS {
                    k = 0

                    if ci!.saber[l].model.isEmpty {
                        break
                    }

                    if (cent.currentState.eFlags2 & EF2_HELD_BY_MONSTER) != 0 {
                        //vectoangles(legs.axis[0], rootAngles);
                        vectoangles(legs.axis[0], &rootAngles)
                    }

                    while k < ci!.saber[l].numBlades {
                        if cent.currentState.saberHolstered == 1 && k > 0 && ci!.saber[l].blade[k].length <= 0 {
                            //extra blades off
                            //don't draw them
                            CG_AddSaberBlade(cent, cent, nil, 0, 0, l, k, legs.origin, rootAngles, false, true)
                        } else if !ci!.saber[1].model.isEmpty && cent.currentState.saberHolstered == 1 && l > 0 && ci!.saber[l].blade[k].length <= 0 {
                            //second saber is turned off and this blade is done with turning off
                            CG_AddSaberBlade(cent, cent, nil, 0, 0, l, k, legs.origin, rootAngles, false, true)
                        } else {
                            CG_AddSaberBlade(cent, cent, nil, 0, 0, l, k, legs.origin, rootAngles, false, false)
                        }

                        k += 1
                    }
                    if ci!.saber[l].numBlades > 2 {
                        //add a single glow for the saber based on all the blade colors combined
                        CG_DoSaberLight(ci!.saber[l])
                    }

                    l += 1
                }
            }

            if cent.currentState.saberInFlight && cent.currentState.saberEntityNum == 0 {
                //reset the length if the saber is knocked away
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
                // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
                portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")

                if g2HasWeapon {
                    //and remember to kill the bolton model in case we didn't get a thrown saber update first
                    trap_G2API_RemoveGhoul2Model(&(cent.ghoul2), 1)
                    g2HasWeapon = false
                }
                cent.bolt3 = 0
                cent.bolt2 = 0
            }

            if (cent.currentState.eFlags & EF_DEAD) != 0 {
                if cent.ghoul2 != nil && cent.currentState.saberInFlight && g2HasWeapon {
                    //special case, kill the saber on a freshly dead player if another source says to.
                    trap_G2API_RemoveGhoul2Model(&(cent.ghoul2), 1)
                    g2HasWeapon = false
                }
            }

            if iwantout != 0 {
                return true
                //goto endOfCall;
            }

            if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0 && cg.snap!.ps.clientNum != cent.currentState.number {
                legs.shaderRGBA[0] = 255
                legs.shaderRGBA[1] = 255
                legs.shaderRGBA[2] = 0
                legs.renderfx |= RF_MINLIGHT
            }

            if cg.snap!.ps.duelInProgress {
                //I guess go ahead and glow your own client too in a duel
                if cent.currentState.number != cg.snap!.ps.duelIndex && cent.currentState.number != cg.snap!.ps.clientNum {
                    //everyone not involved in the duel is drawn very dark
                    legs.shaderRGBA[0] = Int32(Float(legs.shaderRGBA[0]) / 5.0)
                    legs.shaderRGBA[1] = Int32(Float(legs.shaderRGBA[1]) / 5.0)
                    legs.shaderRGBA[2] = Int32(Float(legs.shaderRGBA[2]) / 5.0)
                    legs.renderfx |= RF_RGB_TINT
                } else {
                    //adjust the glow by how far away you are from your dueling partner
                    var duelEnt: Centity?

                    duelEnt = cg_entities[cg.snap!.ps.duelIndex]

                    if duelEnt != nil {
                        var vecSub = vec3_t()
                        var subLen: Float = 0

                        vecSub = duelEnt!.lerpOrigin - cg.snap!.ps.origin
                        subLen = VectorLength(vecSub)

                        if subLen < 1 {
                            subLen = 1
                        }

                        if subLen > 1020 {
                            subLen = 1020
                        }

                        do {
                            let savRGBA: [UInt8] = [UInt8(truncatingIfNeeded: legs.shaderRGBA[0]), UInt8(truncatingIfNeeded: legs.shaderRGBA[1]), UInt8(truncatingIfNeeded: legs.shaderRGBA[2])]
                            legs.shaderRGBA[0] = Int32(max(255 - subLen / 4, 1))
                            legs.shaderRGBA[1] = Int32(max(255 - subLen / 4, 1))
                            legs.shaderRGBA[2] = Int32(max(255 - subLen / 4, 1))

                            legs.renderfx &= ~RF_RGB_TINT
                            legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                            legs.customShader = cgs.media.forceShell

                            trap_R_AddRefEntityToScene(legs) //draw the shell

                            legs.customShader = 0 //reset to player model

                            legs.shaderRGBA[0] = Int32(max(Int32(savRGBA[0]) - subLen / 8, 1))
                            legs.shaderRGBA[1] = Int32(max(Int32(savRGBA[1]) - subLen / 8, 1))
                            legs.shaderRGBA[2] = Int32(max(Int32(savRGBA[2]) - subLen / 8, 1))
                        }

                        if subLen <= 1024 {
                            legs.renderfx |= RF_RGB_TINT
                        }
                    }
                }
            } else {
                if cent.currentState.bolt1 != 0 && !((cent.currentState.eFlags & EF_DEAD) != 0) && cent.currentState.number != cg.snap!.ps.clientNum && (!cg.snap!.ps.duelInProgress || cg.snap!.ps.duelIndex != cent.currentState.number) {
                    legs.shaderRGBA[0] = 50
                    legs.shaderRGBA[1] = 50
                    legs.shaderRGBA[2] = 50
                    legs.renderfx |= RF_RGB_TINT
                }
            }

            if (cent.currentState.eFlags & EF_DISINTEGRATION) != 0 {
                if cent.dustTrailTime == 0 {
                    cent.dustTrailTime = cg.time
                    cent.miscTime = legs.frame
                }

                if (cg.time - cent.dustTrailTime) > 1500 {
                    //avoid rendering the entity after disintegration has finished anyway
                    //goto endOfCall;
                    return true
                }

                trap_G2API_SetBoneAnim(legs.ghoul2, 0, "model_root", cent.miscTime, cent.miscTime, BONE_ANIM_OVERRIDE_FREEZE, 1.0, cg.time, Float(cent.miscTime), -1)

                if !cent.noLumbar {
                    trap_G2API_SetBoneAnim(legs.ghoul2, 0, "lower_lumbar", cent.miscTime, cent.miscTime, BONE_ANIM_OVERRIDE_FREEZE, 1.0, cg.time, Float(cent.miscTime), -1)

                    if cent.localAnimIndex <= 1 {
                        trap_G2API_SetBoneAnim(legs.ghoul2, 0, "Motion", cent.miscTime, cent.miscTime, BONE_ANIM_OVERRIDE_FREEZE, 1.0, cg.time, Float(cent.miscTime), -1)
                    }
                }

                CG_Disintegration(cent, legs)

                //goto endOfCall;
                return true
            } else {
                cent.dustTrailTime = 0
                cent.miscTime = 0
            }

            if (cent.currentState.powerups & (1 << PW_CLOAKED)) != 0 {
                if !cent.cloaked {
                    cent.cloaked = true
                    cent.uncloaking = cg.time + 2000
                }
            } else if cent.cloaked {
                cent.cloaked = false
                cent.uncloaking = cg.time + 2000
            }

            if cent.uncloaking > cg.time {
                //in the middle of cloaking
                if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0 && cg.snap!.ps.clientNum != cent.currentState.number {
                    //just draw him
                    trap_R_AddRefEntityToScene(legs)
                } else {
                    var perc: Float = Float((cent.uncloaking - cg.time)) / 2000.0
                    if (cent.currentState.powerups & (1 << PW_CLOAKED)) != 0 {
                        //actually cloaking, so reverse it
                        perc = 1.0 - perc
                    }

                    if perc >= 0.0 && perc <= 1.0 {
                        legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                        legs.renderfx |= RF_RGB_TINT
                        legs.shaderRGBA[2] = Int32(255.0 * perc)
                        legs.shaderRGBA[1] = legs.shaderRGBA[2]
                        legs.shaderRGBA[0] = legs.shaderRGBA[1]
                        legs.shaderRGBA[3] = 0
                        legs.customShader = cgs.media.cloakedShader
                        trap_R_AddRefEntityToScene(legs)

                        legs.shaderRGBA[2] = 255
                        legs.shaderRGBA[1] = legs.shaderRGBA[2]
                        legs.shaderRGBA[0] = legs.shaderRGBA[1]
                        legs.shaderRGBA[3] = Int32(255 * (1.0 - perc)) // let model alpha in
                        legs.customShader = 0 // use regular skin
                        legs.renderfx &= ~RF_RGB_TINT
                        legs.renderfx |= RF_FORCE_ENT_ALPHA
                        trap_R_AddRefEntityToScene(legs)
                    }
                }
            } else if (cent.currentState.powerups & (1 << PW_CLOAKED)) != 0 {
                //fully cloaked
                if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0 && cg.snap!.ps.clientNum != cent.currentState.number {
                    //just draw him
                    trap_R_AddRefEntityToScene(legs)
                } else {
                    if cg.renderingThirdPerson || cent.currentState.number != cg.predictedPlayerState.clientNum {
                        /*
                        legs.renderfx = 0;//&= ~(RF_RGB_TINT|RF_ALPHA_FADE);
                        legs.shaderRGBA[0] = legs.shaderRGBA[1] = legs.shaderRGBA[2] = legs.shaderRGBA[3] = 255;
                        legs.customShader = cgs.media.cloakedShader;

                        legs.nonNormalizedAxes = qtrue;

                        legs.modelScale[0] = 1.02f;
                        legs.modelScale[1] = 1.02f;
                        legs.modelScale[2] = 1.02f;
                        VectorScale( legs.axis[0], legs.modelScale[0], legs.axis[0] );
                        VectorScale( legs.axis[1], legs.modelScale[1], legs.axis[1] );
                        VectorScale( legs.axis[2], legs.modelScale[2], legs.axis[2] );

                        ScaleModelAxis(&legs);

                        trap_R_AddRefEntityToScene( &legs );

                        legs.modelScale[0] = 0.98f;
                        legs.modelScale[1] = 0.98f;
                        legs.modelScale[2] = 0.98f;
                        VectorScale( legs.axis[0], legs.modelScale[0], legs.axis[0] );
                        VectorScale( legs.axis[1], legs.modelScale[1], legs.axis[1] );
                        VectorScale( legs.axis[2], legs.modelScale[2], legs.axis[2] );

                        ScaleModelAxis(&legs);
                        */

                        if cg_shadows.integer != 2 && cgs.glconfig.stencilBits >= 4 && cg_renderToTextureFX.integer != 0 {
                            trap_R_SetRefractProp(1.0, 0.0, false, false) //don't need to do this every frame.. but..
                            legs.customShader = 2 //crazy "refractive" shader
                            trap_R_AddRefEntityToScene(legs)
                            legs.customShader = 0
                        } else {
                            //stencil buffer's in use, sorry
                            legs.renderfx = 0 //&= ~(RF_RGB_TINT|RF_ALPHA_FADE);
                            legs.shaderRGBA[3] = 255
                            legs.shaderRGBA[2] = legs.shaderRGBA[3]
                            legs.shaderRGBA[1] = legs.shaderRGBA[2]
                            legs.shaderRGBA[0] = legs.shaderRGBA[1]
                            legs.customShader = cgs.media.cloakedShader
                            trap_R_AddRefEntityToScene(legs)
                            legs.customShader = 0
                        }
                    }
                }
            }

            if !((cent.currentState.powerups & (1 << PW_CLOAKED)) != 0) {
                //don't add the normal model if cloaked
                CG_CheckThirdPersonAlpha(cent, legs)
                trap_R_AddRefEntityToScene(legs)
            }

            //cent->frame_minus2 = cent->frame_minus1;
            cent.frame_minus2 = cent.frame_minus1

            if cent.frame_minus1_refreshed != 0 {
                cent.frame_minus2_refreshed = 1
            }

            //cent->frame_minus1 = legs;
            cent.frame_minus1 = legs.origin

            cent.frame_minus1_refreshed = 1

            if cent.frame_hold_refreshed == 0 && (cent.currentState.powerups & (1 << PW_SPEEDBURST)) != 0 {
                cent.frame_hold_time = cg.time + 254
            }

            if cent.frame_hold_time >= cg.time {
                // Raven's record lives to the end of his block, so the block is the closure.
                RefEntity.scratch { reframe_hold in

                    if cent.frame_hold_refreshed == 0 {
                        //We're taking the ghoul2 instance from the original refent and duplicating it onto our refent alias so that we can then freeze the frame and fade it for the effect
                        if cent.frame_hold != nil && trap_G2_HaveWeGhoul2Models(cent.frame_hold) && cent.frame_hold != cent.ghoul2 {
                            trap_G2API_CleanGhoul2Models(&(cent.frame_hold))
                        }
                        reframe_hold.copy(from: legs)
                        cent.frame_hold_refreshed = 1
                        reframe_hold.ghoul2 = nil

                        trap_G2API_DuplicateGhoul2Instance(cent.ghoul2, &cent.frame_hold)

                        //Set the animation to the current frame and freeze on end
                        //trap_G2API_SetBoneAnim(cent->frame_hold.ghoul2, 0, "model_root", cent->frame_hold.frame, cent->frame_hold.frame, BONE_ANIM_OVERRIDE_FREEZE, 1.0f, cg.time, cent->frame_hold.frame, -1);
                        trap_G2API_SetBoneAnim(cent.frame_hold, 0, "model_root", legs.frame, legs.frame, 0, 1.0, cg.time, Float(legs.frame), -1)
                    } else {
                        reframe_hold.copy(from: legs)
                        reframe_hold.ghoul2 = cent.frame_hold
                    }

                    reframe_hold.renderfx |= RF_FORCE_ENT_ALPHA
                    reframe_hold.shaderRGBA[3] = (cent.frame_hold_time - cg.time)
                    if reframe_hold.shaderRGBA[3] > 254 {
                        reframe_hold.shaderRGBA[3] = 254
                    }
                    if reframe_hold.shaderRGBA[3] < 1 {
                        reframe_hold.shaderRGBA[3] = 1
                    }

                    reframe_hold.ghoul2 = cent.frame_hold
                    trap_R_AddRefEntityToScene(reframe_hold)
                }
            } else {
                cent.frame_hold_refreshed = 0
            }

            //
            // add the gun / barrel / flash
            //
            if cent.currentState.weapon != WP_EMPLACED_GUN {
                CG_AddPlayerWeapon(legs, nil, cent, ci!.team, rootAngles, true)
            }
            // add powerups floating behind the player
            CG_PlayerPowerups(cent, legs)

            if (cent.currentState.forcePowersActive & (1 << FP_RAGE)) != 0 && (cg.renderingThirdPerson || cent.currentState.number != cg.snap!.ps.clientNum) {
                //legs.customShader = cgs.media.rageShader;
                legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                legs.renderfx &= ~RF_MINLIGHT

                legs.renderfx |= RF_RGB_TINT
                legs.shaderRGBA[0] = 255
                legs.shaderRGBA[2] = 0
                legs.shaderRGBA[1] = legs.shaderRGBA[2]
                legs.shaderRGBA[3] = 255

                // The SDK also declares `rand`, so the call names the bg module.
                if (JKAMP_BG.rand() & 1) != 0 {
                    legs.customShader = cgs.media.electricBodyShader
                } else {
                    legs.customShader = cgs.media.electricBody2Shader
                }

                trap_R_AddRefEntityToScene(legs)
            }

            if !cg.snap!.ps.duelInProgress && cent.currentState.bolt1 != 0 && !((cent.currentState.eFlags & EF_DEAD) != 0) && cent.currentState.number != cg.snap!.ps.clientNum && (!cg.snap!.ps.duelInProgress || cg.snap!.ps.duelIndex != cent.currentState.number) {
                legs.shaderRGBA[0] = 50
                legs.shaderRGBA[1] = 50
                legs.shaderRGBA[2] = 255

                legs.renderfx &= ~RF_RGB_TINT
                legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                legs.customShader = cgs.media.forceSightBubble

                trap_R_AddRefEntityToScene(legs)
            }

            if CG_VehicleShouldDrawShields(cent) || (checkDroidShields && CG_VehicleShouldDrawShields(cg_entities[cent.currentState.m_iVehicleNum])) {
                //Vehicles have form-fitting shields
                var pVeh: Vehicle? = cent.m_pVehicle
                if checkDroidShields {
                    pVeh = cg_entities[cent.currentState.m_iVehicleNum].m_pVehicle
                }
                legs.shaderRGBA[0] = 255
                legs.shaderRGBA[1] = 255
                legs.shaderRGBA[2] = 255
                legs.shaderRGBA[3] = Int32(10.0 + (sin(Float((cg.time / 4))) * 128.0)) //112.0 * ((cent->damageTime - cg.time) / MIN_SHIELD_TIME) + random()*16;

                legs.renderfx &= ~RF_RGB_TINT
                legs.renderfx &= ~RF_FORCE_ENT_ALPHA

                if pVeh != nil && pVeh!.m_pVehicleInfo != nil && pVeh!.m_pVehicleInfo!.shieldShaderHandle != 0 {
                    //use the vehicle-specific shader
                    legs.customShader = pVeh!.m_pVehicleInfo!.shieldShaderHandle
                } else {
                    legs.customShader = cgs.media.playerShieldDamage
                }

                trap_R_AddRefEntityToScene(legs)
            }
            //For now, these two are using the old shield shader. This is just so that you
            //can tell it apart from the JM/duel shaders, but it's still very obvious.
            if (cent.currentState.forcePowersActive & (1 << FP_PROTECT)) != 0 {
                //aborb is represented by green..
                // Raven's record lives to the end of his block, so the block is the closure.
                RefEntity.scratch { prot in

                    prot.copy(from: legs)

                    prot.shaderRGBA[0] = 0
                    prot.shaderRGBA[1] = 128
                    prot.shaderRGBA[2] = 0
                    prot.shaderRGBA[3] = 254

                    prot.renderfx &= ~RF_RGB_TINT
                    prot.renderfx &= ~RF_FORCE_ENT_ALPHA
                    prot.customShader = cgs.media.protectShader

                    /*
                    if (!prot.modelScale[0] && !prot.modelScale[1] && !prot.modelScale[2])
                    {
                    prot.modelScale[0] = prot.modelScale[1] = prot.modelScale[2] = 1.0f;
                    }
                    VectorScale(prot.modelScale, 1.1f, prot.modelScale);
                    prot.origin[2] -= 2.0f;
                    ScaleModelAxis(&prot);
                    */

                    trap_R_AddRefEntityToScene(prot)
                }
            }
            //if (cent->currentState.forcePowersActive & (1 << FP_ABSORB))
            //Showing only when the power has been active (absorbed something) recently now, instead of always.
            //AND
            //always show if it is you with the absorb on
            if (cent.currentState.number == cg.predictedPlayerState.clientNum && (cg.predictedPlayerState.fd.forcePowersActive & (1 << FP_ABSORB)) != 0) || (cent.teamPowerEffectTime > cg.time && cent.teamPowerType) {
                //aborb is represented by blue..
                legs.shaderRGBA[0] = 0
                legs.shaderRGBA[1] = 0
                legs.shaderRGBA[2] = 255
                legs.shaderRGBA[3] = 254

                legs.renderfx &= ~RF_RGB_TINT
                legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                legs.customShader = cgs.media.playerShieldDamage

                trap_R_AddRefEntityToScene(legs)
            }

            if cent.currentState.isJediMaster && cg.snap!.ps.clientNum != cent.currentState.number {
                legs.shaderRGBA[0] = 100
                legs.shaderRGBA[1] = 100
                legs.shaderRGBA[2] = 255

                legs.renderfx &= ~RF_RGB_TINT
                legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                legs.renderfx |= RF_NODEPTH
                legs.customShader = cgs.media.forceShell

                trap_R_AddRefEntityToScene(legs)

                legs.renderfx &= ~RF_NODEPTH
            }

            if (cg.snap!.ps.fd.forcePowersActive & (1 << FP_SEE)) != 0 && cg.snap!.ps.clientNum != cent.currentState.number && cg_auraShell.integer != 0 {
                if cgs.gametype == GT_SIEGE {
                    // A team game
                    if ci!.team == TEAM_SPECTATOR || ci!.team == TEAM_FREE {
                        //yellow
                        legs.shaderRGBA[0] = 255
                        legs.shaderRGBA[1] = 255
                        legs.shaderRGBA[2] = 0
                    } else if ci!.team != cgs.clientinfo[cg.snap!.ps.clientNum].team {
                        //red
                        legs.shaderRGBA[0] = 255
                        legs.shaderRGBA[1] = 50
                        legs.shaderRGBA[2] = 50
                    } else {
                        //green
                        legs.shaderRGBA[0] = 50
                        legs.shaderRGBA[1] = 255
                        legs.shaderRGBA[2] = 50
                    }
                } else if cgs.gametype >= GT_TEAM {
                    // A team game
                    switch ci!.team {
                    case TEAM_RED:
                        legs.shaderRGBA[0] = 255
                        legs.shaderRGBA[1] = 50
                        legs.shaderRGBA[2] = 50

                    case TEAM_BLUE:
                        legs.shaderRGBA[0] = 75
                        legs.shaderRGBA[1] = 75
                        legs.shaderRGBA[2] = 255

                    default:
                        legs.shaderRGBA[0] = 255
                        legs.shaderRGBA[1] = 255
                        legs.shaderRGBA[2] = 0
                    }
                } else {
                    // Not a team game
                    legs.shaderRGBA[0] = 255
                    legs.shaderRGBA[1] = 255
                    legs.shaderRGBA[2] = 0
                }

                /*		if (cg.snap->ps.fd.forcePowerLevel[FP_SEE] <= FORCE_LEVEL_1)
                {
                legs.renderfx |= RF_MINLIGHT;
                }
                else
                */
                do {
                    // See through walls.
                    legs.renderfx |= RF_MINLIGHT | RF_NODEPTH

                    if cg.snap!.ps.fd.forcePowerLevel[FP_SEE] < FORCE_LEVEL_2 {
                        //only level 2+ can see players through walls
                        legs.renderfx &= ~RF_NODEPTH
                    }
                }

                legs.renderfx &= ~RF_RGB_TINT
                legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                legs.customShader = cgs.media.sightShell

                trap_R_AddRefEntityToScene(legs)
            }

            // Electricity
            //------------------------------------------------
            if cent.currentState.emplacedOwner > cg.time {
                let dif: Int32 = cent.currentState.emplacedOwner - cg.time
                var tempAngles = vec3_t()

                // The SDK also declares `random`, so the call names the bg module.
                if dif > 0 && JKAMP_BG.random() > 0.4 {
                    // fade out over the last 500 ms
                    var brightness: Int32 = 255

                    if dif < 500 {
                        brightness = Int32(floor((dif - 500.0) / 500.0 * 255.0))
                    }

                    legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                    legs.renderfx &= ~RF_MINLIGHT

                    legs.renderfx |= RF_RGB_TINT
                    legs.shaderRGBA[2] = brightness
                    legs.shaderRGBA[1] = legs.shaderRGBA[2]
                    legs.shaderRGBA[0] = legs.shaderRGBA[1]
                    legs.shaderRGBA[3] = 255

                    // The SDK also declares `rand`, so the call names the bg module.
                    if (JKAMP_BG.rand() & 1) != 0 {
                        legs.customShader = cgs.media.electricBodyShader
                    } else {
                        legs.customShader = cgs.media.electricBody2Shader
                    }

                    trap_R_AddRefEntityToScene(legs)

                    // The SDK also declares `random`, so the call names the bg module.
                    if JKAMP_BG.random() > 0.9 {
                        // Port-note: Raven passes NULL for the `origin` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                        portMissing("CG_Player", source: "oracle/codemp/cgame/cg_players.c:8423")
                        var scratchOrigin = vec3_t()
                        trap_S_StartSound(&scratchOrigin, cent.currentState.number, CHAN_AUTO, cgs.media.crackleSound)
                    }
                }

                tempAngles = vec3_t(0, cent.lerpAngles[YAW], 0)
                CG_ForceElectrocution(cent, legs.origin, tempAngles, cgs.media.boltShader, false)
            }

            if (cent.currentState.powerups & (1 << PW_SHIELDHIT)) != 0 {
                /*
                legs.shaderRGBA[0] = legs.shaderRGBA[1] = legs.shaderRGBA[2] = 255.0f * 0.5f;//t;
                legs.shaderRGBA[3] = 255;
                legs.renderfx &= ~RF_ALPHA_FADE;
                legs.renderfx |= RF_RGB_TINT;
                */

                legs.shaderRGBA[2] = Q_irand(1, 255)
                legs.shaderRGBA[1] = legs.shaderRGBA[2]
                legs.shaderRGBA[0] = legs.shaderRGBA[1]

                legs.renderfx &= ~RF_FORCE_ENT_ALPHA
                legs.renderfx &= ~RF_MINLIGHT
                legs.renderfx &= ~RF_RGB_TINT
                legs.customShader = cgs.media.playerShieldDamage

                trap_R_AddRefEntityToScene(legs)
            }
            return false
        }
        if earlyOut2 {
            return true
        }
        return false
    }
    if earlyOut {
        return
    }
}

/**
```
===============
CG_ResetPlayerEntity

A player just came into view or teleported, so reset all animation info
===============
```
*/
/// Source: oracle/codemp/cgame/cg_players.c:11119
func CG_ResetPlayerEntity(_ cent: Centity) {
    var ci: ClientInfo?
    var i: Int32 = 0
    var j: Int32 = 0

    //	cent->errorTime = -99999;		// guarantee no error decay added
    //	cent->extrapolated = qfalse;

    if cent.currentState.eType == ET_NPC {
        if cent.currentState.NPC_class == CLASS_VEHICLE && cent.m_pVehicle != nil && cent.m_pVehicle!.m_pVehicleInfo!.type == VH_FIGHTER && cg.predictedPlayerState.m_iVehicleNum != 0 && cent.currentState.number == cg.predictedPlayerState.m_iVehicleNum {
            //holy hackery, batman!
            //I don't think this will break anything. But really, do I ever?
            return
        }

        if cent.npcClient == nil {
            CG_CreateNPCClient(&cent.npcClient) //allocate memory for it

            if cent.npcClient == nil {
                return
            }

            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'ClientInfo?' must be unwrapped to refer to member 'clear' of wrapped base type 'ClientInfo'".
            // Raven wrote: memset(cent->npcClient, 0, sizeof(clientInfo_t))
            portMissing("CG_ResetPlayerEntity", source: "oracle/codemp/cgame/cg_players.c:11119")
            cent.npcClient!.ghoul2Model = nil
        }

        ci = cent.npcClient


        //just force these guys to be set again, it won't hurt anything if they're
        //already set.
        cent.npcLocalSurfOff = 0
        cent.npcLocalSurfOn = 0
    } else {
        ci = cgs.clientinfo[cent.currentState.clientNum]
    }

    while i < MAX_SABERS {
        j = 0
        while j < ci!.saber[i].numBlades {
            ci!.saber[i].blade[j].trail.lastTime = -20000
            j += 1
        }
        i += 1
    }

    ci!.facial_blink = -1
    ci!.facial_frown = 0
    ci!.facial_aux = 0
    ci!.superSmoothTime = 0

    //reset lerp origin smooth point
    cent.beamEnd = cent.lerpOrigin

    if cent.currentState.eType != ET_NPC || !((cent.currentState.eFlags & EF_DEAD) != 0) {
        CG_ClearLerpFrame(cent, ci!, cent.pe.legs, cent.currentState.legsAnim, false)
        CG_ClearLerpFrame(cent, ci!, cent.pe.torso, cent.currentState.torsoAnim, true)

        BG_EvaluateTrajectory(cent.currentState.pos, cg.time, &cent.lerpOrigin)
        BG_EvaluateTrajectory(cent.currentState.apos, cg.time, &cent.lerpAngles)

        //		VectorCopy( cent->lerpOrigin, cent->rawOrigin );
        cent.rawAngles = cent.lerpAngles

        cent.pe.legs.clear()
        cent.pe.legs.yawAngle = cent.rawAngles[YAW]
        cent.pe.legs.yawing = false
        cent.pe.legs.pitchAngle = 0
        cent.pe.legs.pitching = false

        // Port-note: Raven's `memset( &cent->pe.torso, 0, sizeof( cent->pe.legs ) )` runs over a size that is not the record's own, and a view's clear() takes the whole record.
        // Raven wrote: memset( &cent->pe.torso, 0, sizeof( cent->pe.legs ) )
        portMissing("CG_ResetPlayerEntity", source: "oracle/codemp/cgame/cg_players.c:11119")
        cent.pe.torso.yawAngle = cent.rawAngles[YAW]
        cent.pe.torso.yawing = false
        cent.pe.torso.pitchAngle = cent.rawAngles[PITCH]
        cent.pe.torso.pitching = false

        if cent.currentState.eType == ET_NPC {
            //just start them off at 0 pitch
            cent.pe.torso.pitchAngle = 0
        }

        if (cent.ghoul2 == nil) && ci!.ghoul2Model != nil && trap_G2_HaveWeGhoul2Models(ci!.ghoul2Model) {
            trap_G2API_DuplicateGhoul2Instance(ci!.ghoul2Model, &cent.ghoul2)
            cent.weapon = 0
            cent.ghoul2weapon = nil

            //Attach the instance to this entity num so we can make use of client-server
            //shared operations if possible.
            trap_G2API_AttachInstanceToEntNum(cent.ghoul2, cent.currentState.number, false)

            if trap_G2API_AddBolt(cent.ghoul2, 0, "face") == -1 {
                //check now to see if we have this bone for setting anims and such
                cent.noFace = true
            }

            cent.localAnimIndex = CG_G2SkelForModel(cent.ghoul2)
            cent.eventAnimIndex = CG_G2EvIndexForModel(cent.ghoul2, cent.localAnimIndex)

            //CG_CopyG2WeaponInstance(cent->currentState.weapon, ci->ghoul2Model);
            //cent->weapon = cent->currentState.weapon;
        }
    }

    //do this to prevent us from making a saber unholster sound the first time we enter the pvs
    if cent.currentState.number != cg.predictedPlayerState.clientNum && cent.currentState.weapon == WP_SABER && cent.weapon != cent.currentState.weapon {
        cent.weapon = cent.currentState.weapon
        if cent.ghoul2 != nil && ci!.ghoul2Model != nil {
            CG_CopyG2WeaponInstance(cent, cent.currentState.weapon, cent.ghoul2)
            // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
            // Raven wrote: cent->ghoul2weapon = CG_G2WeaponInstance(cent, cent->currentState.weapon)
            portMissing("CG_ResetPlayerEntity", source: "oracle/codemp/cgame/cg_players.c:11119")
        }
        if cent.currentState.saberHolstered == 0 {
            //if not holstered set length and desired length for both blades to full right now.
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
            // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[0], 0, -1)
            portMissing("CG_ResetPlayerEntity", source: "oracle/codemp/cgame/cg_players.c:11119")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'BG_SI_SetDesiredLength' in scope".
            // Raven wrote: BG_SI_SetDesiredLength(&ci->saber[1], 0, -1)
            portMissing("CG_ResetPlayerEntity", source: "oracle/codemp/cgame/cg_players.c:11119")

            i = 0
            while i < MAX_SABERS {
                j = 0
                while j < ci!.saber[i].numBlades {
                    ci!.saber[i].blade[j].length = ci!.saber[i].blade[j].lengthMax
                    j += 1
                }
                i += 1
            }
        }
    }


    if cg_debugPosition.integer != 0 {
        CG_Printf("%i ResetPlayerEntity yaw=%i\n", cent.currentState.number, cent.pe.torso.yawAngle)
    }
}

