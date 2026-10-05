import Foundation
import JKAMP
import JKAShared
import JKAMP_Game
import JKAMP_BG

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:96
private let LSTATE_NONE: Int32 = 0
private let LSTATE_UNDERFIRE: Int32 = 1
private let LSTATE_INVESTIGATE: Int32 = 2

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:21
private let MAX_VIEW_DIST = 2048 as Int32

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:22
private let MAX_VIEW_SPEED = 100 as Int32

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:23
let JEDI_MAX_LIGHT_INTENSITY = 64 as Int32

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:24
let JEDI_MIN_LIGHT_THRESHOLD = 10 as Int32

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:25
let JEDI_MAX_LIGHT_THRESHOLD = 50 as Int32

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:27
private let DISTANCE_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:29
private let SPEED_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:30
private let FOV_SCALE = 0.5 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:31
private let LIGHT_SCALE = 0.25 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:33
private let REALIZE_THRESHOLD = 0.6 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:34
private let CAUTIOUS_THRESHOLD = (REALIZE_THRESHOLD * 0.3)

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:36
private let MAX_CHECK_THRESHOLD = 1 as Int32

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:94
var jediSpeechDebounceTime: [Int32] {
    get { world.variables.jediSpeechDebounceTime }
    set { world.variables.jediSpeechDebounceTime = newValue }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4469
private let APEX_HEIGHT = 200.0 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4470
// Raven wrote: #define PARA_WIDTH ( sqrt ( APEX_HEIGHT ) + sqrt ( APEX_HEIGHT ) )
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4471
private let JUMP_SPEED = 200.0 as Float

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:16
func G_StartMatrixEffect(_ ent: Entity) {
    //perhaps write this at some point?
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:103
func NPC_ShadowTrooper_Precache() {
    RegisterItem(BG_FindItemForAmmo(AMMO_FORCE)!)
    G_SoundIndex("sound/chars/shadowtrooper/cloak.wav")
    G_SoundIndex("sound/chars/shadowtrooper/decloak.wav")
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:110
func Jedi_ClearTimers(_ ent: Entity) {
    TIMER_Set(ent, "roamTime", 0)
    TIMER_Set(ent, "chatter", 0)
    TIMER_Set(ent, "strafeLeft", 0)
    TIMER_Set(ent, "strafeRight", 0)
    TIMER_Set(ent, "noStrafe", 0)
    TIMER_Set(ent, "walking", 0)
    TIMER_Set(ent, "taunting", 0)
    TIMER_Set(ent, "parryTime", 0)
    TIMER_Set(ent, "parryReCalcTime", 0)
    TIMER_Set(ent, "forceJumpChasing", 0)
    TIMER_Set(ent, "jumpChaseDebounce", 0)
    TIMER_Set(ent, "moveforward", 0)
    TIMER_Set(ent, "moveback", 0)
    TIMER_Set(ent, "movenone", 0)
    TIMER_Set(ent, "moveright", 0)
    TIMER_Set(ent, "moveleft", 0)
    TIMER_Set(ent, "movecenter", 0)
    TIMER_Set(ent, "saberLevelDebounce", 0)
    TIMER_Set(ent, "noRetreat", 0)
    TIMER_Set(ent, "holdLightning", 0)
    TIMER_Set(ent, "gripping", 0)
    TIMER_Set(ent, "draining", 0)
    TIMER_Set(ent, "noturn", 0)
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:137
func Jedi_PlayBlockedPushSound(_ `self`: Entity) {
    if `self`.s.number == 0 {
        G_AddVoiceEvent(`self`, EV_PUSHFAIL, 3000)
    } else if `self`.health > 0 && `self`.NPC != nil && `self`.NPC!.blockedSpeechDebounceTime < level.time {
        G_AddVoiceEvent(`self`, EV_PUSHFAIL, 3000)
        `self`.NPC!.blockedSpeechDebounceTime = level.time + 3000
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:150
func Jedi_PlayDeflectSound(_ `self`: Entity) {
    if `self`.s.number == 0 {
        G_AddVoiceEvent(`self`, Q_irand(EV_DEFLECT1, EV_DEFLECT3), 3000)
    } else if `self`.health > 0 && `self`.NPC != nil && `self`.NPC!.blockedSpeechDebounceTime < level.time {
        G_AddVoiceEvent(`self`, Q_irand(EV_DEFLECT1, EV_DEFLECT3), 3000)
        `self`.NPC!.blockedSpeechDebounceTime = level.time + 3000
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:163
func NPC_Jedi_PlayConfusionSound(_ `self`: Entity) {
    if `self`.health > 0 {
        if `self`.client != nil && (`self`.client!.NPC_class == CLASS_TAVION || `self`.client!.NPC_class == CLASS_DESANN) {
            G_AddVoiceEvent(`self`, Q_irand(EV_CONFUSE1, EV_CONFUSE3), 2000)
        } else if Q_irand(0, 1) != 0 {
            G_AddVoiceEvent(`self`, Q_irand(EV_TAUNT1, EV_TAUNT3), 2000)
        } else {
            G_AddVoiceEvent(`self`, Q_irand(EV_GLOAT1, EV_GLOAT3), 2000)
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:182
func Boba_Precache() {
    G_SoundIndex("sound/boba/jeton.wav")
    G_SoundIndex("sound/boba/jethover.wav")
    G_SoundIndex("sound/effects/combustfire.mp3")
    G_EffectIndex("boba/jet")
    G_EffectIndex("boba/fthrw")
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:193
func Boba_ChangeWeapon(_ wp: Int32) {
    if NPC!.s.weapon == wp {
        return
    }
    NPC_ChangeWeapon(wp)
    G_AddEvent(NPC!, EV_GENERAL_SOUND, G_SoundIndex("sound/weapons/change.wav"))
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:203
func WP_ResistForcePush(_ `self`: Entity, _ pusher: Entity, _ noPenalty: Bool) {
    let parts: Int32
    var runningResist: Bool = false

    if `self`.health <= 0 || `self`.client == nil || pusher.client == nil {
        return
    }
    if (`self`.s.number == 0 || `self`.client!.NPC_class == CLASS_DESANN || Q_stricmp("Yoda", `self`.NPC_type!) == 0 || `self`.client!.NPC_class == CLASS_LUKE) && (VectorLengthSquared(`self`.client!.ps.velocity) > 10000 || `self`.client!.ps.fd.forcePowerLevel[FP_PUSH] >= FORCE_LEVEL_3 || `self`.client!.ps.fd.forcePowerLevel[FP_PULL] >= FORCE_LEVEL_3) {
        runningResist = true
    }
    if !runningResist && `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE && !BG_SpinningSaberAnim(`self`.client!.ps.legsAnim) && !BG_FlippingAnim(`self`.client!.ps.legsAnim) && !PM_RollingAnim(`self`.client!.ps.legsAnim) && !PM_InKnockDown(`self`.client!.ps) && !BG_CrouchAnim(`self`.client!.ps.legsAnim) {
        //if on a surface and not in a spin or flip, play full body resist
        parts = SETANIM_BOTH
    } else {
        //play resist just in torso
        parts = SETANIM_TORSO
    }
    NPC_SetAnim(`self`, parts, BOTH_RESISTPUSH, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    if !noPenalty {
        var buf = CharBuf(128)
        var tFVal: Float = 0

        strcpy(&buf, trap_Cvar_VariableStringBuffer("timescale", Int32((buf).count)))

        tFVal = atof(buf)

        if !runningResist {
            `self`.client!.ps.velocity = vec3_t()
            //still stop them from attacking or moving for a bit, though
            //FIXME: maybe push just a little (like, slide)?
            `self`.client!.ps.weaponTime = 1000
            if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
                `self`.client!.ps.weaponTime = Int32(floor(`self`.client!.ps.weaponTime * tFVal))
            }
            `self`.client!.ps.pm_time = `self`.client!.ps.weaponTime
            `self`.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
            //play the full body push effect on me
            //self->forcePushTime = level.time + 600; // let the push effect last for 600 ms
            //rwwFIXMEFIXME: Do this?
        } else {
            `self`.client!.ps.weaponTime = 600
            if (`self`.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 {
                `self`.client!.ps.weaponTime = Int32(floor(`self`.client!.ps.weaponTime * tFVal))
            }
        }
    }
    //play my force push effect on my hand
    `self`.client!.ps.powerups[PW_DISINT_4] = level.time + `self`.client!.ps.torsoTimer + 500
    `self`.client!.ps.powerups[PW_PULL] = 0
    Jedi_PlayBlockedPushSound(`self`)
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:272
func Boba_StopKnockdown(_ `self`: Entity, _ pusher: Entity, _ pushDir: JKAShared.vec3_t, _ forceKnockdown: Bool) -> Bool {
    var pDir = vec3_t()
    var fwd = vec3_t()
    var right = vec3_t()
    var ang = vec3_t()
    var fDot: Float = 0
    var rDot: Float = 0
    var strafeTime: Int32 = 0

    if `self`.client!.NPC_class != CLASS_BOBAFETT {
        return false
    }

    if (`self`.client!.ps.eFlags2 & EF2_FLYING) != 0 {
        //can't knock me down when I'm flying
        return true
    }

    ang = vec3_t(0, `self`.r.currentAngles[YAW], 0)
    strafeTime = Q_irand(1000, 2000)

    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("Boba_StopKnockdown", source: "oracle/codemp/game/NPC_AI_Jedi.c:272")
    var scratchUp = vec3_t()
    AngleVectors(ang, &fwd, &right, &scratchUp)
    VectorNormalize2(pushDir, &pDir)
    fDot = _DotProduct(pDir, fwd)
    rDot = _DotProduct(pDir, right)

    if Q_irand(0, 2) != 0 {
        //flip or roll with it
        // Raven's record lives to the end of his block, so the block is the closure.
        Usercmd.scratch { tempCmd in
            if fDot >= 0.4 {
                tempCmd.forwardmove = 127
                TIMER_Set(`self`, "moveforward", strafeTime)
            } else if fDot <= -0.4 {
                tempCmd.forwardmove = -127
                TIMER_Set(`self`, "moveback", strafeTime)
            } else if rDot > 0 {
                tempCmd.rightmove = 127
                TIMER_Set(`self`, "strafeRight", strafeTime)
                TIMER_Set(`self`, "strafeLeft", -1)
            } else {
                tempCmd.rightmove = -127
                TIMER_Set(`self`, "strafeLeft", strafeTime)
                TIMER_Set(`self`, "strafeRight", -1)
            }
            G_AddEvent(`self`, EV_JUMP, 0)
            if Q_irand(0, 1) == 0 {
                //flip
                `self`.client!.ps.fd.forceJumpCharge = 280 //FIXME: calc this intelligently?
                ForceJump(`self`, tempCmd)
            } else {
                //roll
                TIMER_Set(`self`, "duck", strafeTime)
            }
            `self`.painDebounceTime = 0 //so we do something
        }
    } else if Q_irand(0, 1) == 0 && forceKnockdown {
        //resist
        WP_ResistForcePush(`self`, pusher, true)
    } else {
        //fall down
        return false
    }

    return true
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:345
func Boba_FlyStart(_ `self`: Entity) {
    //switch to seeker AI for a while
    if TIMER_Done(`self`, "jetRecharge") {
        `self`.client!.ps.gravity = 0
        if `self`.NPC != nil {
            `self`.NPC!.aiFlags |= NPCAI_CUSTOM_GRAVITY
        }
        `self`.client!.ps.eFlags2 |= EF2_FLYING //moveType = MT_FLYSWIM;
        `self`.client!.jetPackTime = level.time + Q_irand(3000, 10000)
        //take-off sound
        G_SoundOnEnt(`self`, CHAN_ITEM, "sound/boba/jeton.wav")
        //jet loop sound
        `self`.s.loopSound = G_SoundIndex("sound/boba/jethover.wav")
        if `self`.NPC != nil {
            `self`.count = Q3_INFINITE // SEEKER shot ammo count
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:367
func Boba_FlyStop(_ `self`: Entity) {
    `self`.client!.ps.gravity = Int32(g_gravity.value)
    if `self`.NPC != nil {
        `self`.NPC!.aiFlags &= ~NPCAI_CUSTOM_GRAVITY
    }
    `self`.client!.ps.eFlags2 &= ~EF2_FLYING
    `self`.client!.jetPackTime = 0
    //stop jet loop sound
    `self`.s.loopSound = 0
    if `self`.NPC != nil {
        `self`.count = 0 // SEEKER shot ammo count
        TIMER_Set(`self`, "jetRecharge", Q_irand(1000, 5000))
        TIMER_Set(`self`, "jumpChaseDebounce", Q_irand(500, 2000))
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:386
func Boba_Flying(_ `self`: Entity) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "no exact matches in call to initializer".
    // Raven wrote: return ((qboolean)(self->client->ps.eFlags2&EF2_FLYING))
    portMissing("Boba_Flying", source: "oracle/codemp/game/NPC_AI_Jedi.c:386")
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:391
func Boba_FireFlameThrower(_ `self`: Entity) {
    let damage: Int32 = Q_irand(20, 30)
    // Raven's record lives to the end of his block, so the block is the closure.
    Trace.scratch { tr in
        var traceEnt: Entity? = nil
        // Raven's record lives to the end of his block, so the block is the closure.
        MdxaBone.scratch { boltMatrix in
            var start = vec3_t()
            var end = vec3_t()
            var dir = vec3_t()
            var traceMins = vec3_t(-4, -4, -4)
            var traceMaxs = vec3_t(4, 4, 4)

            trap_G2API_GetBoltMatrix(`self`.ghoul2, 0, `self`.client!.renderInfo.handLBolt, boltMatrix, `self`.r.currentAngles, `self`.r.currentOrigin, level.time, nil, &`self`.modelScale)

            BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &start)
            BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &dir)
            //G_PlayEffect( "boba/fthrw", start, dir );
            _VectorMA(start, 128, dir, &end)

            trap_Trace(tr, start, traceMins, traceMaxs, end, `self`.s.number, MASK_SHOT)

            traceEnt = g_entities[tr.entityNum]
            if tr.entityNum < ENTITYNUM_WORLD && traceEnt!.takedamage {
                G_Damage(traceEnt!, `self`, `self`, &dir, tr.endpos, damage, DAMAGE_NO_ARMOR | DAMAGE_NO_KNOCKBACK | DAMAGE_IGNORE_TEAM, MOD_LAVA)
                //rwwFIXMEFIXME: add DAMAGE_NO_HIT_LOC?
            }
        }
    }
}

//extern void SP_fx_explosion_trail( gentity_t *ent );
/// Source: oracle/codemp/game/NPC_AI_Jedi.c:419
func Boba_StartFlameThrower(_ `self`: Entity) {
    let flameTime: Int32 = 4000
    // Raven's record lives to the end of his block, so the block is the closure.
    MdxaBone.scratch { boltMatrix in
        var org = vec3_t()
        var dir = vec3_t()

        `self`.client!.ps.torsoTimer = flameTime //+1000;
        if `self`.NPC != nil {
            TIMER_Set(`self`, "nextAttackDelay", flameTime)
            TIMER_Set(`self`, "walking", 0)
        }
        TIMER_Set(`self`, "flameTime", flameTime)
        /*
        gentity_t *fire = G_Spawn();
        if ( fire != NULL )
        {
        mdxaBone_t	boltMatrix;
        vec3_t		org, dir, ang;
        gi.G2API_GetBoltMatrix( NPC->ghoul2, NPC->playerModel, NPC->handRBolt,
        &boltMatrix, NPC->r.currentAngles, NPC->r.currentOrigin, (cg.time?cg.time:level.time),
        NULL, NPC->s.modelScale );

        gi.G2API_GiveMeVectorFromMatrix( boltMatrix, ORIGIN, org );
        gi.G2API_GiveMeVectorFromMatrix( boltMatrix, NEGATIVE_Y, dir );
        vectoangles( dir, ang );

        VectorCopy( org, fire->s.origin );
        VectorCopy( ang, fire->s.angles );

        fire->targetname = "bobafire";
        SP_fx_explosion_trail( fire );
        fire->damage = 1;
        fire->radius = 10;
        fire->speed = 200;
        fire->fxID = G_EffectIndex( "boba/fthrw" );//"env/exp_fire_trail" );//"env/small_fire"
        fx_explosion_trail_link( fire );
        fx_explosion_trail_use( fire, NPC, NPC );

        }
        */
        G_SoundOnEnt(`self`, CHAN_WEAPON, "sound/effects/combustfire.mp3")

        trap_G2API_GetBoltMatrix(NPC!.ghoul2, 0, NPC!.client!.renderInfo.handRBolt, boltMatrix, NPC!.r.currentAngles, NPC!.r.currentOrigin, level.time, nil, &NPC!.modelScale)

        BG_GiveMeVectorFromMatrix(boltMatrix, ORIGIN, &org)
        BG_GiveMeVectorFromMatrix(boltMatrix, NEGATIVE_Y, &dir)

        G_PlayEffectID(G_EffectIndex("boba/fthrw"), org, dir)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:471
func Boba_DoFlameThrower(_ `self`: Entity) {
    NPC_SetAnim(`self`, SETANIM_TORSO, BOTH_FORCELIGHTNING_HOLD, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    if TIMER_Done(`self`, "nextAttackDelay") && TIMER_Done(`self`, "flameTime") {
        Boba_StartFlameThrower(`self`)
    }
    Boba_FireFlameThrower(`self`)
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:481
func Boba_FireDecide() {
    var enemyLOS: Bool = false
    var enemyCS: Bool = false
    var enemyInFOV: Bool = false
    //qboolean move = qtrue;
    var faceEnemy: Bool = false
    var shoot: Bool = false
    var hitAlly: Bool = false
    var impactPos = vec3_t()
    var enemyDist: Float = 0
    var dot: Float = 0
    var enemyDir = vec3_t()
    var shootDir = vec3_t()

    if NPC!.client!.ps.groundEntityNum == ENTITYNUM_NONE && NPC!.client!.ps.fd.forceJumpZStart != 0 && !BG_FlippingAnim(NPC!.client!.ps.legsAnim) && Q_irand(0, 10) == 0 {
        //take off
        Boba_FlyStart(NPC!)
    }

    if NPC!.enemy == nil {
        return
    }

    /*
    if ( NPC->enemy->enemy != NPC && NPC->health == NPC->client->pers.maxHealth )
    {
    NPCInfo->scriptFlags |= SCF_ALT_FIRE;
    Boba_ChangeWeapon( WP_DISRUPTOR );
    }
    else */
    if NPC!.enemy!.s.weapon == WP_SABER {
        NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
        Boba_ChangeWeapon(WP_ROCKET_LAUNCHER)
    } else {
        if NPC!.health < NPC!.client!.pers.maxHealth * 0.5 {
            NPCInfo!.scriptFlags |= SCF_ALT_FIRE
            Boba_ChangeWeapon(WP_BLASTER)
            NPCInfo!.burstMin = 3
            NPCInfo!.burstMean = 12
            NPCInfo!.burstMax = 20
            NPCInfo!.burstSpacing = Q_irand(300, 750) //attack debounce
        } else {
            NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
            Boba_ChangeWeapon(WP_BLASTER)
        }
    }

    impactPos = vec3_t()
    enemyDist = DistanceSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin)

    enemyDir = NPC!.enemy!.r.currentOrigin - NPC!.r.currentOrigin
    VectorNormalize(&enemyDir)
    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("Boba_FireDecide", source: "oracle/codemp/game/NPC_AI_Jedi.c:481")
    var scratchRight = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("Boba_FireDecide", source: "oracle/codemp/game/NPC_AI_Jedi.c:481")
    var scratchUp = vec3_t()
    AngleVectors(NPC!.client!.ps.viewangles, &shootDir, &scratchRight, &scratchUp)
    dot = _DotProduct(enemyDir, shootDir)
    if dot > 0.5 || (enemyDist * (1.0 - dot)) < 10000 {
        //enemy is in front of me or they're very close and not behind me
        enemyInFOV = true
    }

    if (enemyDist < (128 * 128) && enemyInFOV) || !TIMER_Done(NPC!, "flameTime") {
        //flamethrower
        Boba_DoFlameThrower(NPC!)
        enemyCS = false
        shoot = false
        NPCInfo!.enemyLastSeenTime = level.time
        faceEnemy = true
        ucmd.buttons &= ~(BUTTON_ATTACK | BUTTON_ALT_ATTACK)
    } else if enemyDist < MIN_ROCKET_DIST_SQUARED {
        //enemy within 128
        if (NPC!.client!.ps.weapon == WP_FLECHETTE || NPC!.client!.ps.weapon == WP_REPEATER) && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
            //shooting an explosive, but enemy too close, switch to primary fire
            NPCInfo!.scriptFlags &= ~SCF_ALT_FIRE
            //FIXME: we can never go back to alt-fire this way since, after this, we don't know if we were initially supposed to use alt-fire or not...
        }
    } else if enemyDist > 65536 {
        if NPC!.client!.ps.weapon == WP_DISRUPTOR {
            //sniping... should be assumed
            if !((NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0) {
                //use primary fire
                NPCInfo!.scriptFlags |= SCF_ALT_FIRE
                //reset fire-timing variables
                NPC_ChangeWeapon(WP_DISRUPTOR)
                NPC_UpdateAngles(true, true)
                return
            }
        }
    }

    //can we see our target?
    if TIMER_Done(NPC!, "nextAttackDelay") && TIMER_Done(NPC!, "flameTime") {
        if NPC_ClearLOS4(NPC!.enemy!) {
            NPCInfo!.enemyLastSeenTime = level.time
            enemyLOS = true

            if NPC!.client!.ps.weapon == WP_NONE {
                enemyCS = false //not true, but should stop us from firing
            } else {
                //can we shoot our target?
                if (NPC!.client!.ps.weapon == WP_ROCKET_LAUNCHER || (NPC!.client!.ps.weapon == WP_FLECHETTE && (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0)) && enemyDist < MIN_ROCKET_DIST_SQUARED {
                    enemyCS = false //not true, but should stop us from firing
                    hitAlly = true //us!
                    //FIXME: if too close, run away!
                } else if enemyInFOV {
                    //if enemy is FOV, go ahead and check for shooting
                    let hit: Int32 = NPC_ShotEntity(NPC!.enemy!, &impactPos)
                    let hitEnt: Entity? = g_entities[hit]

                    if hit == NPC!.enemy!.s.number || (hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.enemyTeam) || (hitEnt != nil && hitEnt!.takedamage && ((hitEnt!.r.svFlags & SVF_GLASS_BRUSH) != 0 || hitEnt!.health < 40 || NPC!.s.weapon == WP_EMPLACED_GUN)) {
                        //can hit enemy or enemy ally or will hit glass or other minor breakable (or in emplaced gun), so shoot anyway
                        enemyCS = true
                        //NPC_AimAdjust( 2 );//adjust aim better longer we have clear shot at enemy
                        NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
                    } else {
                        //Hmm, have to get around this bastard
                        //NPC_AimAdjust( 1 );//adjust aim better longer we can see enemy
                        if hitEnt != nil && hitEnt!.client != nil && hitEnt!.client!.playerTeam == NPC!.client!.playerTeam {
                            //would hit an ally, don't fire!!!
                            hitAlly = true
                        } else {
                            //Check and see where our shot *would* hit... if it's not close to the enemy (within 256?), then don't fire
                        }
                    }
                } else {
                    enemyCS = false //not true, but should stop us from firing
                }
            }
        } else if trap_InPVS(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin) {
            NPCInfo!.enemyLastSeenTime = level.time
            faceEnemy = true
            //NPC_AimAdjust( -1 );//adjust aim worse longer we cannot see enemy
        }

        if NPC!.client!.ps.weapon == WP_NONE {
            faceEnemy = false
            shoot = false
        } else {
            if enemyLOS {
                //FIXME: no need to face enemy if we're moving to some other goal and he's too far away to shoot?
                faceEnemy = true
            }
            if enemyCS {
                shoot = true
            }
        }

        if !enemyCS {
            //if have a clear shot, always try
            //See if we should continue to fire on their last position
            //!TIMER_Done( NPC, "stick" ) ||
            if !hitAlly && enemyInFOV && NPCInfo!.enemyLastSeenTime > 0 {
                if level.time - NPCInfo!.enemyLastSeenTime < 10000 {
                    if Q_irand(0, 10) == 0 {
                        //Fire on the last known position
                        var muzzle = vec3_t()
                        var dir = vec3_t()
                        var angles = vec3_t()
                        var tooClose: Bool = false
                        var tooFar: Bool = false
                        var distThreshold: Float = 0
                        var dist: Float = 0

                        CalcEntitySpot(NPC!, SPOT_HEAD, &muzzle)
                        if VectorCompare(impactPos, vec3_origin) != 0 {
                            //never checked ShotEntity this frame, so must do a trace...
                            // Raven's record lives to the end of his block, so the block is the closure.
                            Trace.scratch { tr in
                                //vec3_t	mins = {-2,-2,-2}, maxs = {2,2,2};
                                var forward = vec3_t()
                                var end = vec3_t()
                                // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                                portMissing("Boba_FireDecide", source: "oracle/codemp/game/NPC_AI_Jedi.c:481")
                                var scratchRight2 = vec3_t()
                                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                                portMissing("Boba_FireDecide", source: "oracle/codemp/game/NPC_AI_Jedi.c:481")
                                var scratchUp2 = vec3_t()
                                AngleVectors(NPC!.client!.ps.viewangles, &forward, &scratchRight2, &scratchUp2)
                                _VectorMA(muzzle, 8192, forward, &end)
                                trap_Trace(tr, muzzle, vec3_origin, vec3_origin, end, NPC!.s.number, MASK_SHOT)
                                impactPos = tr.endpos
                            }
                        }

                        //see if impact would be too close to me
                        distThreshold = 16384
                        switch NPC!.s.weapon {
                        case WP_ROCKET_LAUNCHER, WP_FLECHETTE, WP_THERMAL, WP_TRIP_MINE, WP_DET_PACK:
                            distThreshold = 65536

                        case WP_REPEATER:
                            if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                                distThreshold = 65536
                            }

                        default:
                            break
                        }

                        dist = DistanceSquared(impactPos, muzzle)

                        if dist < distThreshold {
                            //impact would be too close to me
                            tooClose = true
                        } else if level.time - NPCInfo!.enemyLastSeenTime > 5000 || (NPCInfo!.group != nil && level.time - NPCInfo!.group!.lastSeenEnemyTime > 5000) {
                            //we've haven't seen them in the last 5 seconds
                            //see if it's too far from where he is
                            distThreshold = 65536
                            switch NPC!.s.weapon {
                            case WP_ROCKET_LAUNCHER, WP_FLECHETTE, WP_THERMAL, WP_TRIP_MINE, WP_DET_PACK:
                                distThreshold = 262144

                            case WP_REPEATER:
                                if (NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0 {
                                    distThreshold = 262144
                                }

                            default:
                                break
                            }
                            dist = DistanceSquared(impactPos, NPCInfo!.enemyLastSeenLocation)
                            if dist > distThreshold {
                                //impact would be too far from enemy
                                tooFar = true
                            }
                        }

                        if !tooClose && !tooFar {
                            //okay too shoot at last pos
                            dir = NPCInfo!.enemyLastSeenLocation - muzzle
                            VectorNormalize(&dir)
                            vectoangles(dir, &angles)

                            NPCInfo!.desiredYaw = angles[YAW]
                            NPCInfo!.desiredPitch = angles[PITCH]

                            shoot = true
                            faceEnemy = false
                        }
                    }
                }
            }
        }

        //FIXME: don't shoot right away!
        if NPC!.client!.ps.weaponTime > 0 {
            if NPC!.s.weapon == WP_ROCKET_LAUNCHER {
                if !enemyLOS || !enemyCS {
                    //cancel it
                    NPC!.client!.ps.weaponTime = 0
                } else {
                    //delay our next attempt
                    TIMER_Set(NPC!, "nextAttackDelay", Q_irand(500, 1000))
                }
            }
        } else if shoot {
            //try to shoot if it's time
            if TIMER_Done(NPC!, "nextAttackDelay") {
                if !((NPCInfo!.scriptFlags & SCF_FIRE_WEAPON) != 0) {
                    WeaponThink(true)
                }
                //NASTY
                if NPC!.s.weapon == WP_ROCKET_LAUNCHER && (ucmd.buttons & BUTTON_ATTACK) != 0 && Q_irand(0, 3) == 0 {
                    //every now and then, shoot a homing rocket
                    ucmd.buttons &= ~BUTTON_ATTACK
                    ucmd.buttons |= BUTTON_ALT_ATTACK
                    NPC!.client!.ps.weaponTime = Q_irand(500, 1500)
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:799
func Jedi_Cloak(_ `self`: Entity) {
    `self`.flags |= FL_NOTARGET
    if `self`.client != nil {
        if `self`.client!.ps.powerups[PW_CLOAKED] == 0 {
            //cloak
            `self`.client!.ps.powerups[PW_CLOAKED] = Q3_INFINITE

            //FIXME: debounce attacks?
            //FIXME: temp sound
            G_Sound(`self`, CHAN_ITEM, G_SoundIndex("sound/chars/shadowtrooper/cloak.wav"))
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:818
func Jedi_Decloak(_ `self`: Entity) {
    `self`.flags &= ~FL_NOTARGET
    if `self`.client != nil {
        if `self`.client!.ps.powerups[PW_CLOAKED] != 0 {
            //Uncloak
            `self`.client!.ps.powerups[PW_CLOAKED] = 0

            G_Sound(`self`, CHAN_ITEM, G_SoundIndex("sound/chars/shadowtrooper/decloak.wav"))
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:835
func Jedi_CheckCloak() {
    if NPC != nil && NPC!.client != nil && NPC!.client!.NPC_class == CLASS_SHADOWTROOPER {
        if NPC!.client!.ps.saberHolstered == 0 || NPC!.health <= 0 || NPC!.client!.ps.saberInFlight || NPC!.painDebounceTime > level.time {
            //can't be cloaked if saber is on, or dead or saber in flight or taking pain or being gripped
            Jedi_Decloak(NPC!)
        } else if NPC!.health > 0 && !NPC!.client!.ps.saberInFlight && NPC!.painDebounceTime < level.time {
            //still alive, have saber in hand, not taking pain and not being gripped
            Jedi_Cloak(NPC!)
        }
    }
}

/**
```
==========================================================================================
AGGRESSION
==========================================================================================
```
*/
/// Source: oracle/codemp/game/NPC_AI_Jedi.c:863
private func Jedi_Aggression(_ `self`: Entity, _ change: Int32) {
    var upper_threshold: Int32
    var lower_threshold: Int32

    `self`.NPC!.stats.aggression += change

    //FIXME: base this on initial NPC stats
    if `self`.client!.playerTeam == NPCTEAM_PLAYER {
        //good guys are less aggressive
        upper_threshold = 7
        lower_threshold = 1
    } else {
        //bad guys are more aggressive
        if `self`.client!.NPC_class == CLASS_DESANN {
            upper_threshold = 20
            lower_threshold = 5
        } else {
            upper_threshold = 10
            lower_threshold = 3
        }
    }

    if `self`.NPC!.stats.aggression > upper_threshold {
        `self`.NPC!.stats.aggression = upper_threshold
    } else if `self`.NPC!.stats.aggression < lower_threshold {
        `self`.NPC!.stats.aggression = lower_threshold
    }
    //Com_Printf( "(%d) %s agg %d change: %d\n", level.time, self->NPC_type, self->NPC->stats.aggression, change );
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:900
private func Jedi_AggressionErosion(_ amt: Int32) {
    if TIMER_Done(NPC!, "roamTime") {
        //the longer we're not alerted and have no enemy, the more our aggression goes down
        TIMER_Set(NPC!, "roamTime", Q_irand(2000, 5000))
        Jedi_Aggression(NPC!, amt)
    }

    if NPCInfo!.stats.aggression < 4 || (NPCInfo!.stats.aggression < 6 && NPC!.client!.NPC_class == CLASS_DESANN) {
        //turn off the saber
        WP_DeactivateSaber(NPC!, false)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:914
func NPC_Jedi_RateNewEnemy(_ `self`: Entity, _ enemy: Entity) {
    var healthAggression: Float
    var weaponAggression: Float
    let newAggression: Int32

    switch enemy.s.weapon {
    case WP_SABER:
        healthAggression = Float(`self`.health) / 200.0 * 6.0
        weaponAggression = 7 //go after him

    case WP_BLASTER:
        if DistanceSquared(`self`.r.currentOrigin, enemy.r.currentOrigin) < 65536 {
            healthAggression = Float(`self`.health) / 200.0 * 8.0
            weaponAggression = 8 //go after him
        } else {
            healthAggression = 8.0 - (Float(`self`.health) / 200.0 * 8.0)
            weaponAggression = 2 //hang back for a second
        }

    default:
        healthAggression = Float(`self`.health) / 200.0 * 8.0
        weaponAggression = 6 //approach
    }
    //Average these with current aggression
    newAggression = Int32(ceil((healthAggression + weaponAggression + Float(`self`.NPC!.stats.aggression)) / 3.0))
    //Com_Printf( "(%d) new agg %d - new enemy\n", level.time, newAggression );
    Jedi_Aggression(`self`, newAggression - `self`.NPC!.stats.aggression)

    //don't taunt right away
    TIMER_Set(`self`, "chatter", Q_irand(4000, 7000))
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:952
private func Jedi_Rage() {
    Jedi_Aggression(NPC!, 10 - NPCInfo!.stats.aggression + Q_irand(-2, 2))
    TIMER_Set(NPC!, "roamTime", 0)
    TIMER_Set(NPC!, "chatter", 0)
    TIMER_Set(NPC!, "walking", 0)
    TIMER_Set(NPC!, "taunting", 0)
    TIMER_Set(NPC!, "jumpChaseDebounce", 0)
    TIMER_Set(NPC!, "movenone", 0)
    TIMER_Set(NPC!, "movecenter", 0)
    TIMER_Set(NPC!, "noturn", 0)
    ForceRage(NPC!)
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:966
func Jedi_RageStop(_ `self`: Entity) {
    if `self`.NPC != nil {
        //calm down and back off
        TIMER_Set(`self`, "roamTime", 0)
        Jedi_Aggression(`self`, Q_irand(-5, 0))
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:980
private func Jedi_BattleTaunt() -> Bool {
    if TIMER_Done(NPC!, "chatter") && Q_irand(0, 3) == 0 && NPCInfo!.blockedSpeechDebounceTime < level.time && jediSpeechDebounceTime[NPC!.client!.playerTeam] < level.time {
        var event: Int32 = -1
        if NPC!.client!.playerTeam == NPCTEAM_PLAYER && NPC!.enemy != nil && NPC!.enemy!.client != nil && NPC!.enemy!.client!.NPC_class == CLASS_JEDI {
            //a jedi fighting a jedi - training
            if NPC!.client!.NPC_class == CLASS_JEDI && NPCInfo!.rank == RANK_COMMANDER {
                //only trainer taunts
                event = EV_TAUNT1
            }
        } else {
            //reborn or a jedi fighting an enemy
            event = Q_irand(EV_TAUNT1, EV_TAUNT3)
        }
        if event != -1 {
            G_AddVoiceEvent(NPC!, event, 3000)
            NPCInfo!.blockedSpeechDebounceTime = level.time + 6000
            jediSpeechDebounceTime[NPC!.client!.playerTeam] = NPCInfo!.blockedSpeechDebounceTime
            TIMER_Set(NPC!, "chatter", Q_irand(5000, 10000))

            if NPC!.enemy != nil && NPC!.enemy!.NPC != nil && NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.client != nil && NPC!.enemy!.client!.NPC_class == CLASS_JEDI {
                //Have the enemy jedi say something in response when I'm done?
            }
            return true
        }
    }
    return false
}

/**
```
==========================================================================================
MOVEMENT
==========================================================================================
```
*/
/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1020
private func Jedi_ClearPathToSpot(_ dest: JKAShared.vec3_t, _ impactEntNum: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var mins = vec3_t()
        var start = vec3_t()
        var end = vec3_t()
        var dir = vec3_t()
        var dist: Float = 0
        var drop: Float = 0
        var i: Float = 0

        //Offset the step height
        mins = vec3_t(NPC!.r.mins[0], NPC!.r.mins[1], NPC!.r.mins[2] + STEPSIZE)

        trap_Trace(trace, NPC!.r.currentOrigin, mins, NPC!.r.maxs, dest, NPC!.s.number, NPC!.clipmask)

        //Do a simple check
        if trace.allsolid != 0 || trace.startsolid != 0 {
            //inside solid
            return false
        }

        if trace.fraction < 1.0 {
            //hit something
            if impactEntNum != ENTITYNUM_NONE && trace.entityNum == impactEntNum {
                //hit what we're going after
                return true
            } else {
                return false
            }
        }

        //otherwise, clear path in a straight line.
        //Now at intervals of my size, go along the trace and trace down STEPSIZE to make sure there is a solid floor.
        dir = dest - NPC!.r.currentOrigin
        dist = VectorNormalize(&dir)
        if dest[2] > NPC!.r.currentOrigin[2] {
            //going up, check for steps
            drop = Float(STEPSIZE)
        } else {
            //going down or level, check for moderate drops
            drop = 64
        }
        i = NPC!.r.maxs[0] * 2
        while i < dist {
            //FIXME: does this check the last spot, too?  We're assuming that should be okay since the enemy is there?
            _VectorMA(NPC!.r.currentOrigin, i, dir, &start)
            end = start
            end[2] -= drop
            trap_Trace(trace, start, mins, NPC!.r.maxs, end, NPC!.s.number, NPC!.clipmask) //NPC->r.mins?
            if trace.fraction < 1.0 || trace.allsolid != 0 || trace.startsolid != 0 {
                //good to go
                i += NPC!.r.maxs[0] * 2
                continue
            }
            //no floor here! (or a long drop?)
            return false
            i += NPC!.r.maxs[0] * 2
        }
        //we made it!
        return true
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1079
func NPC_MoveDirClear(_ forwardmove: Int32, _ rightmove: Int32, _ reset: Bool) -> Bool {
    var forward = vec3_t()
    var right = vec3_t()
    var testPos = vec3_t()
    var angles = vec3_t()
    var mins = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { trace -> Bool in
        var fwdDist: Float = 0
        var rtDist: Float = 0
        var bottom_max: Float = Float(-STEPSIZE * 4 - 1)

        if forwardmove == 0 && rightmove == 0 {
            //not even moving
            //Com_Printf( "%d skipping walk-cliff check (not moving)\n", level.time );
            return true
        }

        if ucmd.upmove > 0 || NPC!.client!.ps.fd.forceJumpCharge != 0 {
            //Going to jump
            //Com_Printf( "%d skipping walk-cliff check (going to jump)\n", level.time );
            return true
        }

        if NPC!.client!.ps.groundEntityNum == ENTITYNUM_NONE {
            //in the air
            //Com_Printf( "%d skipping walk-cliff check (in air)\n", level.time );
            return true
        }
        /*
        if ( fabs( AngleDelta( NPC->r.currentAngles[YAW], NPCInfo->desiredYaw ) ) < 5.0 )//!ucmd.angles[YAW] )
        {//Not turning much, don't do this
        //NOTE: Should this not happen only if you're not turning AT ALL?
        //	You could be turning slowly but moving fast, so that would
        //	still let you walk right off a cliff...
        //NOTE: Or maybe it is a good idea to ALWAYS do this, regardless
        //	of whether ot not we're turning?  But why would we be walking
        //  straight into a wall or off	a cliff unless we really wanted to?
        return;
        }
        */

        //FIXME: to really do this right, we'd have to actually do a pmove to predict where we're
        //going to be... maybe this should be a flag and pmove handles it and sets a flag so AI knows
        //NEXT frame?  Or just incorporate current velocity, runspeed and possibly friction?
        mins = NPC!.r.mins
        mins[2] += STEPSIZE
        angles[ROLL] = 0
        angles[PITCH] = angles[ROLL]
        angles[YAW] = NPC!.client!.ps.viewangles[YAW] //Add ucmd.angles[YAW]?
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("NPC_MoveDirClear", source: "oracle/codemp/game/NPC_AI_Jedi.c:1079")
        var scratchUp = vec3_t()
        AngleVectors(angles, &forward, &right, &scratchUp)
        fwdDist = (Float(forwardmove)) / 2.0
        rtDist = (Float(rightmove)) / 2.0
        _VectorMA(NPC!.r.currentOrigin, fwdDist, forward, &testPos)
        _VectorMA(testPos, rtDist, right, &testPos)
        trap_Trace(trace, NPC!.r.currentOrigin, mins, NPC!.r.maxs, testPos, NPC!.s.number, NPC!.clipmask | CONTENTS_BOTCLIP)
        if trace.allsolid != 0 || trace.startsolid != 0 {
            //hmm, trace started inside this brush... how do we decide if we should continue?
            //FIXME: what do we do if we start INSIDE a CONTENTS_BOTCLIP? Try the trace again without that in the clipmask?
            if reset {
                trace.fraction = 1.0
            }
            trace.endpos = testPos
            //return qtrue;
        }
        if Double(trace.fraction) < 0.6 {
            //Going to bump into something very close, don't move, just turn
            if (NPC!.enemy != nil && trace.entityNum == NPC!.enemy!.s.number) || (NPCInfo!.goalEntity != nil && trace.entityNum == NPCInfo!.goalEntity!.s.number) {
                //okay to bump into enemy or goal
                //Com_Printf( "%d bump into enemy/goal okay\n", level.time );
                return true
            } else if reset {
                //actually want to screw with the ucmd
                //Com_Printf( "%d avoiding walk into wall (entnum %d)\n", level.time, trace.entityNum );
                ucmd.forwardmove = 0
                ucmd.rightmove = 0
                NPC!.client!.ps.moveDir = vec3_t()
            }
            return false
        }

        if NPCInfo!.goalEntity != nil {
            if NPCInfo!.goalEntity!.r.currentOrigin[2] < NPC!.r.currentOrigin[2] {
                //goal is below me, okay to step off at least that far plus stepheight
                bottom_max += NPCInfo!.goalEntity!.r.currentOrigin[2] - NPC!.r.currentOrigin[2]
            }
        }
        testPos = trace.endpos
        testPos[2] += bottom_max

        trap_Trace(trace, trace.endpos, mins, NPC!.r.maxs, testPos, NPC!.s.number, NPC!.clipmask)

        //FIXME:Should we try to see if we can still get to our goal using the waypoint network from this trace.endpos?
        //OR: just put NPC clip brushes on these edges (still fall through when die)

        if trace.allsolid != 0 || trace.startsolid != 0 {
            //Not going off a cliff
            //Com_Printf( "%d walk off cliff okay (droptrace in solid)\n", level.time );
            return true
        }

        if Double(trace.fraction) < 1.0 {
            //Not going off a cliff
            //FIXME: what if plane.normal is sloped?  We'll slide off, not land... plus this doesn't account for slide-movement...
            //Com_Printf( "%d walk off cliff okay will hit entnum %d at dropdist of %4.2f\n", level.time, trace.entityNum, (trace.fraction*bottom_max) );
            return true
        }

        //going to fall at least bottom_max, don't move, just turn... is this bad, though?  What if we want them to drop off?
        if reset {
            //actually want to screw with the ucmd
            //Com_Printf( "%d avoiding walk off cliff\n", level.time );
            ucmd.forwardmove = Int32(Double(ucmd.forwardmove) * -1.0) //= 0;
            ucmd.rightmove = Int32(Double(ucmd.rightmove) * -1.0) //= 0;
            NPC!.client!.ps.moveDir = NPC!.client!.ps.moveDir * -1
        }
        return false
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1200
private func Jedi_HoldPosition() {
    //NPCInfo->squadState = SQUAD_STAND_AND_SHOOT;
    NPCInfo!.goalEntity = nil

    /*
    if ( TIMER_Done( NPC, "stand" ) )
    {
    TIMER_Set( NPC, "duck", Q_irand( 2000, 4000 ) );
    }
    */
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1219
private func Jedi_Move(_ goal: Entity, _ retreat: Bool) {
    var moved: Bool = false
    // Raven's record lives to the end of his block, so the block is the closure.
    NavInfo.scratch { info in

        NPCInfo!.combatMove = true
        NPCInfo!.goalEntity = goal

        moved = NPC_MoveToGoal(true)

        //FIXME: temp retreat behavior- should really make this toward a safe spot or maybe to outflank enemy
        if retreat {
            //FIXME: should we trace and make sure we can go this way?  Or somehow let NPC_MoveToGoal know we want to retreat and have it handle it?
            ucmd.forwardmove *= -1
            ucmd.rightmove *= -1
            NPC!.client!.ps.moveDir = NPC!.client!.ps.moveDir * -1
        }

        //Get the move info
        NAV_GetLastMove(info)

        //If we hit our target, then stop and fire!
        if (info.flags & NIF_COLLISION) != 0 && (info.blocker == NPC!.enemy) {
            Jedi_HoldPosition()
        }

        //If our move failed, then reset
        if moved == false {
            Jedi_HoldPosition()
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1253
private func Jedi_Hunt() -> Bool {
    //Com_Printf( "Hunting\n" );
    //if we're at all interested in fighting, go after him
    if NPCInfo!.stats.aggression > 1 {
        //approach enemy
        NPCInfo!.combatMove = true
        if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) {
            NPC_UpdateAngles(true, true)
            return true
        } else {
            if NPCInfo!.goalEntity == nil {
                //hunt
                NPCInfo!.goalEntity = NPC!.enemy
            }
            //Jedi_Move( NPC->enemy, qfalse );
            if NPC_MoveToGoal(false) {
                NPC_UpdateAngles(true, true)
                return true
            }
        }
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1300
private func Jedi_Retreat() {
    if !TIMER_Done(NPC!, "noRetreat") {
        //don't actually move
        return
    }
    //FIXME: when retreating, we should probably see if we can retreat
    //in the direction we want.  If not...?  Evade?
    //Com_Printf( "Retreating\n" );
    Jedi_Move(NPC!.enemy!, true)
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1312
private func Jedi_Advance() {
    if !NPC!.client!.ps.saberInFlight {
        //NPC->client->ps.SaberActivate();
        WP_ActivateSaber(NPC!)
    }
    //Com_Printf( "Advancing\n" );
    Jedi_Move(NPC!.enemy!, false)

    //TIMER_Set( NPC, "roamTime", Q_irand( 2000, 4000 ) );
    //TIMER_Set( NPC, "attackDelay", Q_irand( 250, 500 ) );
    //TIMER_Set( NPC, "duck", 0 );
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1327
private func Jedi_AdjustSaberAnimLevel(_ `self`: Entity, _ newLevel: Int32) {
    if `self`.client == nil {
        return
    }
    //FIXME: each NPC shold have a unique pattern of behavior for the order in which they
    if `self`.client!.NPC_class == CLASS_TAVION {
        //special attacks
        `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_5
        return
    } else if `self`.client!.NPC_class == CLASS_DESANN {
        //special attacks
        `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_4
        return
    }
    if `self`.client!.playerTeam == NPCTEAM_ENEMY {
        if `self`.NPC!.rank == RANK_CIVILIAN || `self`.NPC!.rank == RANK_LT_JG {
            //grunt and fencer always uses quick attacks
            `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_1
            return
        }
        if `self`.NPC!.rank == RANK_CREWMAN || `self`.NPC!.rank == RANK_ENSIGN {
            //acrobat & force-users always use medium attacks
            `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_2
            return
        }
        /*
        if ( self->NPC->rank == RANK_LT )
        {//boss always uses strong attacks
        self->client->ps.fd.saberAnimLevel = FORCE_LEVEL_3;
        return;
        }
        */
    }
    //use the different attacks, how often they switch and under what circumstances
    if newLevel > `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE] {
        //cap it
        `self`.client!.ps.fd.saberAnimLevel = `self`.client!.ps.fd.forcePowerLevel[FP_SABER_OFFENSE]
    } else if newLevel < FORCE_LEVEL_1 {
        `self`.client!.ps.fd.saberAnimLevel = FORCE_LEVEL_1
    } else {
        //go ahead and set it
        `self`.client!.ps.fd.saberAnimLevel = newLevel
    }

    if d_JediAI.integer != 0 {
        switch `self`.client!.ps.fd.saberAnimLevel {
        case FORCE_LEVEL_1:
            Com_Printf(S_COLOR_GREEN + "%s Saber Attack Set: fast\n", `self`.NPC_type!)

        case FORCE_LEVEL_2:
            Com_Printf(S_COLOR_YELLOW + "%s Saber Attack Set: medium\n", `self`.NPC_type!)

        case FORCE_LEVEL_3:
            Com_Printf(S_COLOR_RED + "%s Saber Attack Set: strong\n", `self`.NPC_type!)

        default:
            break
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1396
private func Jedi_CheckDecreaseSaberAnimLevel() {
    if NPC!.client!.ps.weaponTime == 0 && !((ucmd.buttons & (BUTTON_ATTACK | BUTTON_ALT_ATTACK)) != 0) {
        //not attacking
        if TIMER_Done(NPC!, "saberLevelDebounce") && Q_irand(0, 10) == 0 {
            //Jedi_AdjustSaberAnimLevel( NPC, (NPC->client->ps.fd.saberAnimLevel-1) );//drop
            Jedi_AdjustSaberAnimLevel(NPC!, Q_irand(FORCE_LEVEL_1, FORCE_LEVEL_3)) //random
            TIMER_Set(NPC!, "saberLevelDebounce", Q_irand(3000, 10000))
        }
    } else {
        TIMER_Set(NPC!, "saberLevelDebounce", Q_irand(1000, 5000))
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1413
private func Jedi_CombatDistance(_ enemy_dist: Int32) {
    //FIXME: for many of these checks, what we really want is horizontal distance to enemy
    if (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 && NPC!.client!.ps.fd.forcePowerLevel[FP_GRIP] > FORCE_LEVEL_1 {
        //when gripping, don't move
        return
    } else if !TIMER_Done(NPC!, "gripping") {
        //stopped gripping, clear timers just in case
        TIMER_Set(NPC!, "gripping", -level.time)
        TIMER_Set(NPC!, "attackDelay", Q_irand(0, 1000))
    }

    if (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_DRAIN)) != 0 && NPC!.client!.ps.fd.forcePowerLevel[FP_DRAIN] > FORCE_LEVEL_1 {
        //when draining, don't move
        return
    } else if !TIMER_Done(NPC!, "draining") {
        //stopped draining, clear timers just in case
        TIMER_Set(NPC!, "draining", -level.time)
        TIMER_Set(NPC!, "attackDelay", Q_irand(0, 1000))
    }

    if NPC!.client!.NPC_class == CLASS_BOBAFETT {
        if !TIMER_Done(NPC!, "flameTime") {
            if enemy_dist > 50 {
                Jedi_Advance()
            } else if enemy_dist <= 0 {
                Jedi_Retreat()
            }
        } else if enemy_dist < 200 {
            Jedi_Retreat()
        } else if enemy_dist > 1024 {
            Jedi_Advance()
        }
    } else if NPC!.client!.ps.saberInFlight && !PM_SaberInBrokenParry(NPC!.client!.ps.saberMove) && NPC!.client!.ps.saberBlocked != BLOCKED_PARRY_BROKEN {
        //maintain distance
        if enemy_dist < NPC!.client!.ps.saberEntityDist {
            Jedi_Retreat()
        } else if enemy_dist > NPC!.client!.ps.saberEntityDist && enemy_dist > 100 {
            Jedi_Advance()
        }
        if NPC!.client!.ps.weapon == WP_SABER && NPC!.client!.ps.saberEntityState == SES_LEAVING && NPC!.client!.ps.fd.forcePowerLevel[FP_SABERTHROW] > FORCE_LEVEL_1 && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0) && !((NPC!.client!.ps.saberEventFlags & SEF_INWATER) != 0) {
            //hold it out there
            ucmd.buttons |= BUTTON_ALT_ATTACK
            //FIXME: time limit?
        }
    } else if !TIMER_Done(NPC!, "taunting") {
        if enemy_dist <= 64 {
            //he's getting too close
            ucmd.buttons |= BUTTON_ATTACK
            if !NPC!.client!.ps.saberInFlight {
                WP_ActivateSaber(NPC!)
            }
            TIMER_Set(NPC!, "taunting", -level.time)
        } else if NPC!.client!.ps.forceHandExtend == HANDEXTEND_JEDITAUNT && (NPC!.client!.ps.forceHandExtendTime - level.time) < 200 {
            //else if ( NPC->client->ps.torsoAnim == BOTH_GESTURE1 && NPC->client->ps.torsoTimer < 2000 )
            //we're almost done with our special taunt
            //FIXME: this doesn't always work, for some reason
            if !NPC!.client!.ps.saberInFlight {
                WP_ActivateSaber(NPC!)
            }
        }
    } else if (NPC!.client!.ps.saberEventFlags & SEF_LOCK_WON) != 0 {
        //we won a saber lock, press the advantage
        if enemy_dist > 0 {
            //get closer so we can hit!
            Jedi_Advance()
        }
        if enemy_dist > 128 {
            //lost 'em
            NPC!.client!.ps.saberEventFlags &= ~SEF_LOCK_WON
        }
        if NPC!.enemy!.painDebounceTime + 2000 < level.time {
            //the window of opportunity is gone
            NPC!.client!.ps.saberEventFlags &= ~SEF_LOCK_WON
        }
        //don't strafe?
        TIMER_Set(NPC!, "strafeLeft", -1)
        TIMER_Set(NPC!, "strafeRight", -1)
    } else if NPC!.enemy!.client != nil && NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.client!.ps.saberLockTime > level.time && NPC!.client!.ps.saberLockTime < level.time {
        //enemy is in a saberLock and we are not
        if enemy_dist < 64 {
            //FIXME: maybe just pick another enemy?
            Jedi_Retreat()
        }
    } else if enemy_dist <= 64 && ((NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 || (Q_stricmp("Yoda", NPC!.NPC_type!) == 0 && Q_irand(0, 10) == 0)) {
        /*
        else if ( NPC->enemy->s.weapon == WP_TURRET
        && !Q_stricmp( "PAS", NPC->enemy->classname )
        && NPC->enemy->s.apos.trType == TR_STATIONARY )
        {
        int	testlevel;
        if ( enemy_dist > forcePushPullRadius[FORCE_LEVEL_1] - 16 )
        {
        Jedi_Advance();
        }
        if ( NPC->client->ps.fd.forcePowerLevel[FP_PUSH] < FORCE_LEVEL_1 )
        {//
        testlevel = FORCE_LEVEL_1;
        }
        else
        {
        testlevel = NPC->client->ps.fd.forcePowerLevel[FP_PUSH];
        }
        if ( enemy_dist < forcePushPullRadius[testlevel] - 16 )
        {//close enough to push
        if ( InFront( NPC->enemy->r.currentOrigin, NPC->client->renderInfo.eyePoint, NPC->client->renderInfo.eyeAngles, 0.6f ) )
        {//knock it down
        WP_KnockdownTurret( NPC, NPC->enemy );
        //do the forcethrow call just for effect
        ForceThrow( NPC, qfalse );
        }
        }
        }
        */
        //rwwFIXMEFIXME: Give them the ability to do this again (turret needs to be fixed up to allow it)
        //can't use saber and they're in striking range
        if Q_irand(0, 5) == 0 && InFront(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 0.2) {
            if ((NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 || NPC!.client!.pers.maxHealth - NPC!.health > NPC!.client!.pers.maxHealth * 0.25) && (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_DRAIN)) != 0 && WP_ForcePowerAvailable(NPC!, FP_DRAIN, 20) && Q_irand(0, 2) == 0 {
                //drain
                TIMER_Set(NPC!, "draining", 3000)
                TIMER_Set(NPC!, "attackDelay", 3000)
                Jedi_Advance()
                return
            } else {
                ForceThrow(NPC!, false)
            }
        }
        Jedi_Retreat()
    } else if enemy_dist <= 64 && NPC!.client!.pers.maxHealth - NPC!.health > NPC!.client!.pers.maxHealth * 0.25 && (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_DRAIN)) != 0 && WP_ForcePowerAvailable(NPC!, FP_DRAIN, 20) && Q_irand(0, 10) == 0 && InFront(NPC!.enemy!.r.currentOrigin, NPC!.r.currentOrigin, NPC!.client!.ps.viewangles, 0.2) {
        TIMER_Set(NPC!, "draining", 3000)
        TIMER_Set(NPC!, "attackDelay", 3000)
        Jedi_Advance()
        return
    } else if enemy_dist <= -16 {
        //we're too damn close!
        Jedi_Retreat()
    } else if enemy_dist <= 0 {
        //we're within striking range
        //if we are attacking, see if we should stop
        if NPCInfo!.stats.aggression < 4 {
            //back off and defend
            Jedi_Retreat()
        }
    } else if enemy_dist > 256 {
        //we're way out of range
        var usedForce: Bool = false
        if NPCInfo!.stats.aggression < Q_irand(0, 20) && NPC!.health < NPC!.client!.pers.maxHealth * 0.75 && Q_irand(0, 2) == 0 {
            if (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_HEAL)) != 0 && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_HEAL)) == 0 && Q_irand(0, 1) != 0 {
                ForceHeal(NPC!)
                usedForce = true
                //FIXME: check level of heal and know not to move or attack when healing
            } else if (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_PROTECT)) != 0 && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_PROTECT)) == 0 && Q_irand(0, 1) != 0 {
                ForceProtect(NPC!)
                usedForce = true
            } else if (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_ABSORB)) != 0 && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_ABSORB)) == 0 && Q_irand(0, 1) != 0 {
                ForceAbsorb(NPC!)
                usedForce = true
            } else if (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_RAGE)) != 0 && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) == 0 && Q_irand(0, 1) != 0 {
                Jedi_Rage()
                usedForce = true
            }
            //FIXME: what about things like mind tricks and force sight?
        }
        if enemy_dist > 384 {
            //FIXME: check for enemy facing away and/or moving away
            if Q_irand(0, 10) == 0 && NPCInfo!.blockedSpeechDebounceTime < level.time && jediSpeechDebounceTime[NPC!.client!.playerTeam] < level.time {
                if NPC_ClearLOS4(NPC!.enemy!) {
                    G_AddVoiceEvent(NPC!, Q_irand(EV_JCHASE1, EV_JCHASE3), 3000)
                }
                NPCInfo!.blockedSpeechDebounceTime = level.time + 3000
                jediSpeechDebounceTime[NPC!.client!.playerTeam] = NPCInfo!.blockedSpeechDebounceTime
            }
        }
        //Unless we're totally hiding, go after him
        if NPCInfo!.stats.aggression > 0 {
            //approach enemy
            if !usedForce {
                Jedi_Advance()
            }
        }
    } else if enemy_dist > 50 {
        /*
        else if ( enemy_dist < 96 && NPC->enemy && NPC->enemy->client && NPC->enemy->client->ps.groundEntityNum == ENTITYNUM_NONE )
        {//too close and in air, so retreat
        Jedi_Retreat();
        }
        */
        //FIXME: enemy_dist calc needs to include all blade lengths, and include distance from hand to start of blade....
        //we're out of striking range and we are allowed to attack
        //first, check some tactical force power decisions
        if NPC!.enemy != nil && NPC!.enemy!.client != nil && (NPC!.enemy!.client!.ps.fd.forceGripBeingGripped > level.time) {
            //They're being gripped, rush them!
            if NPC!.enemy!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                //they're on the ground, so advance
                if TIMER_Done(NPC!, "parryTime") || NPCInfo!.rank > RANK_LT {
                    //not parrying
                    if enemy_dist > 200 || !((NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0) {
                        //far away or allowed to use saber
                        Jedi_Advance()
                    }
                }
            }
            if NPCInfo!.rank >= RANK_LT_JG && Q_irand(0, 5) == 0 && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0) && !((NPC!.client!.ps.saberEventFlags & SEF_INWATER) != 0) {
                //throw saber
                ucmd.buttons |= BUTTON_ALT_ATTACK
            }
        } else if NPC!.enemy != nil && NPC!.enemy!.client != nil && NPC!.enemy!.client!.ps.saberInFlight && NPC!.enemy!.client!.ps.saberEntityNum != 0 && NPC!.client!.ps.weaponTime <= 0 && WP_ForcePowerAvailable(NPC!, FP_GRIP, 0) && Q_irand(0, 10) == 0 && Q_irand(0, 6) < g_spskill.integer && Q_irand(RANK_CIVILIAN, RANK_CAPTAIN) < NPCInfo!.rank {
            //They're throwing their saber, grip them!
            //taunt
            if TIMER_Done(NPC!, "chatter") && jediSpeechDebounceTime[NPC!.client!.playerTeam] < level.time && NPCInfo!.blockedSpeechDebounceTime < level.time {
                G_AddVoiceEvent(NPC!, Q_irand(EV_TAUNT1, EV_TAUNT3), 3000)
                NPCInfo!.blockedSpeechDebounceTime = level.time + 3000
                jediSpeechDebounceTime[NPC!.client!.playerTeam] = NPCInfo!.blockedSpeechDebounceTime
                TIMER_Set(NPC!, "chatter", 3000)
            }

            //grip
            TIMER_Set(NPC!, "gripping", 3000)
            TIMER_Set(NPC!, "attackDelay", 3000)
        } else {
            var chanceScale: Int32

            if NPC!.enemy != nil && NPC!.enemy!.client != nil && (NPC!.enemy!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 {
                //They're choking someone, probably an ally, run at them and do some sort of attack
                if NPC!.enemy!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                    //they're on the ground, so advance
                    if TIMER_Done(NPC!, "parryTime") || NPCInfo!.rank > RANK_LT {
                        //not parrying
                        if enemy_dist > 200 || !((NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0) {
                            //far away or allowed to use saber
                            Jedi_Advance()
                        }
                    }
                }
            }
            chanceScale = 0
            if NPC!.client!.NPC_class == CLASS_DESANN || Q_stricmp("Yoda", NPC!.NPC_type!) == 0 {
                chanceScale = 1
            } else if NPCInfo!.rank == RANK_ENSIGN {
                chanceScale = 2
            } else if NPCInfo!.rank >= RANK_LT_JG {
                chanceScale = 5
            }
            if chanceScale != 0 && (enemy_dist > Q_irand(100, 200) || (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 || (Q_stricmp("Yoda", NPC!.NPC_type!) == 0 && Q_irand(0, 3) == 0)) && enemy_dist < 500 && (Q_irand(0, chanceScale * 10) < 5 || (NPC!.enemy!.client != nil && NPC!.enemy!.client!.ps.weapon != WP_SABER && Q_irand(0, chanceScale) == 0)) {
                //else, randomly try some kind of attack every now and then
                if (NPCInfo!.rank == RANK_ENSIGN || NPCInfo!.rank > RANK_LT_JG) && Q_irand(0, 1) == 0 {
                    if WP_ForcePowerAvailable(NPC!, FP_PULL, 0) && Q_irand(0, 2) == 0 {
                        //force pull the guy to me!
                        //FIXME: check forcePushRadius[NPC->client->ps.fd.forcePowerLevel[FP_PUSH]]
                        ForceThrow(NPC!, true)
                        //maybe strafe too?
                        TIMER_Set(NPC!, "duck", enemy_dist * 3)
                        if Q_irand(0, 1) != 0 {
                            ucmd.buttons |= BUTTON_ATTACK
                        }
                    } else if WP_ForcePowerAvailable(NPC!, FP_LIGHTNING, 0) && Q_irand(0, 1) != 0 {
                        ForceLightning(NPC!)
                        if NPC!.client!.ps.fd.forcePowerLevel[FP_LIGHTNING] > FORCE_LEVEL_1 {
                            NPC!.client!.ps.weaponTime = Q_irand(1000, 3000 + (g_spskill.integer * 500))
                            TIMER_Set(NPC!, "holdLightning", NPC!.client!.ps.weaponTime)
                        }
                        TIMER_Set(NPC!, "attackDelay", NPC!.client!.ps.weaponTime)
                    } else if WP_ForcePowerAvailable(NPC!, FP_GRIP, 0) {
                        /*else if ( NPC->health < NPC->client->pers.maxHealth * 0.75f
                        && Q_irand( FORCE_LEVEL_0, NPC->client->ps.fd.forcePowerLevel[FP_DRAIN] ) > FORCE_LEVEL_1
                        && WP_ForcePowerAvailable( NPC, FP_DRAIN, 0 )
                        && Q_irand( 0, 1 ) )
                        {
                        ForceDrain2( NPC );
                        NPC->client->ps.weaponTime = Q_irand( 1000, 3000+(g_spskill.integer*500) );
                        TIMER_Set( NPC, "draining", NPC->client->ps.weaponTime );
                        TIMER_Set( NPC, "attackDelay", NPC->client->ps.weaponTime );
                        }*/
                        //rwwFIXMEFIXME: After new drain stuff from SP is in re-enable this.
                        //taunt
                        if TIMER_Done(NPC!, "chatter") && jediSpeechDebounceTime[NPC!.client!.playerTeam] < level.time && NPCInfo!.blockedSpeechDebounceTime < level.time {
                            G_AddVoiceEvent(NPC!, Q_irand(EV_TAUNT1, EV_TAUNT3), 3000)
                            NPCInfo!.blockedSpeechDebounceTime = level.time + 3000
                            jediSpeechDebounceTime[NPC!.client!.playerTeam] = NPCInfo!.blockedSpeechDebounceTime
                            TIMER_Set(NPC!, "chatter", 3000)
                        }

                        //grip
                        TIMER_Set(NPC!, "gripping", 3000)
                        TIMER_Set(NPC!, "attackDelay", 3000)
                    } else {
                        if WP_ForcePowerAvailable(NPC!, FP_SABERTHROW, 0) && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0) && !((NPC!.client!.ps.saberEventFlags & SEF_INWATER) != 0) {
                            //throw saber
                            ucmd.buttons |= BUTTON_ALT_ATTACK
                        }
                    }
                } else {
                    if NPCInfo!.rank >= RANK_LT_JG && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0) && !((NPC!.client!.ps.saberEventFlags & SEF_INWATER) != 0) {
                        //throw saber
                        ucmd.buttons |= BUTTON_ALT_ATTACK
                    }
                }
            } else if NPCInfo!.stats.aggression > 5 {
                //see if we should advance now
                //approach enemy
                if TIMER_Done(NPC!, "parryTime") || NPCInfo!.rank > RANK_LT {
                    //not parrying
                    if NPC!.enemy!.client == nil || NPC!.enemy!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                        //they're on the ground, so advance
                        if enemy_dist > 200 || !((NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0) {
                            //far away or allowed to use saber
                            Jedi_Advance()
                        }
                    }
                }
            } else {
                //maintain this distance?
                //walk?
            }
        }
    } else {
        //we're not close enough to attack, but not far enough away to be safe
        if NPCInfo!.stats.aggression < 4 {
            //back off and defend
            Jedi_Retreat()
        } else if NPCInfo!.stats.aggression > 5 {
            //try to get closer
            if enemy_dist > 0 && !((NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0) {
                //we're allowed to use our lightsaber, get closer
                if TIMER_Done(NPC!, "parryTime") || NPCInfo!.rank > RANK_LT {
                    //not parrying
                    if NPC!.enemy!.client == nil || NPC!.enemy!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                        //they're on the ground, so advance
                        Jedi_Advance()
                    }
                }
            }
        } else {
            //agression is 4 or 5... somewhere in the middle
            //what do we do here?  Nothing?
            //Move forward and back?
        }
    }
    //if really really mad, rage!
    if NPCInfo!.stats.aggression > Q_irand(5, 15) && NPC!.health < NPC!.client!.pers.maxHealth * 0.75 && Q_irand(0, 2) == 0 {
        if (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_RAGE)) != 0 && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) == 0 {
            Jedi_Rage()
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1876
private func Jedi_Strafe(_ strafeTimeMin: Int32, _ strafeTimeMax: Int32, _ nextStrafeTimeMin: Int32, _ nextStrafeTimeMax: Int32, _ walking: Bool) -> Bool {
    if (NPC!.client!.ps.saberEventFlags & SEF_LOCK_WON) != 0 && NPC!.enemy != nil && NPC!.enemy!.painDebounceTime > level.time {
        //don't strafe if pressing the advantage of winning a saberLock
        return false
    }
    if TIMER_Done(NPC!, "strafeLeft") && TIMER_Done(NPC!, "strafeRight") {
        var strafed: Bool = false
        //TODO: make left/right choice a tactical decision rather than random:
        //		try to keep own back away from walls and ledges,
        //		try to keep enemy's back to a ledge or wall
        //		Maybe try to strafe toward designer-placed "safe spots" or "goals"?
        let strafeTime: Int32 = Q_irand(strafeTimeMin, strafeTimeMax)

        if Q_irand(0, 1) != 0 {
            if NPC_MoveDirClear(ucmd.forwardmove, -127, false) {
                TIMER_Set(NPC!, "strafeLeft", strafeTime)
                strafed = true
            } else if NPC_MoveDirClear(ucmd.forwardmove, 127, false) {
                TIMER_Set(NPC!, "strafeRight", strafeTime)
                strafed = true
            }
        } else {
            if NPC_MoveDirClear(ucmd.forwardmove, 127, false) {
                TIMER_Set(NPC!, "strafeRight", strafeTime)
                strafed = true
            } else if NPC_MoveDirClear(ucmd.forwardmove, -127, false) {
                TIMER_Set(NPC!, "strafeLeft", strafeTime)
                strafed = true
            }
        }

        if strafed {
            TIMER_Set(NPC!, "noStrafe", strafeTime + Q_irand(nextStrafeTimeMin, nextStrafeTimeMax))
            if walking {
                //should be a slow strafe
                TIMER_Set(NPC!, "walking", strafeTime)
            }
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:1969
func Jedi_CheckFlipEvasions(_ `self`: Entity, _ rightdot: Float, _ zdiff: Float) -> JKAMP.evasionType_t {
    if `self`.NPC != nil && (`self`.NPC!.scriptFlags & SCF_NO_ACROBATICS) != 0 {
        return EVASION_NONE
    }
    if `self`.client != nil && (`self`.client!.ps.fd.forceRageRecoveryTime > level.time || (`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) {
        //no fancy dodges when raging
        return EVASION_NONE
    }
    //Check for:
    //ARIALS/CARTWHEELS
    //WALL-RUNS
    //WALL-FLIPS
    //FIXME: if facing a wall, do forward wall-walk-backflip
    if `self`.client!.ps.legsAnim == BOTH_WALL_RUN_LEFT || `self`.client!.ps.legsAnim == BOTH_WALL_RUN_RIGHT {
        //already running on a wall
        var right = vec3_t()
        var fwdAngles = vec3_t()
        var anim: Int32 = -1
        var animLength: Float = 0

        fwdAngles = vec3_t(0, `self`.client!.ps.viewangles[YAW], 0)

        // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Jedi_CheckFlipEvasions", source: "oracle/codemp/game/NPC_AI_Jedi.c:1969")
        var scratchForward = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Jedi_CheckFlipEvasions", source: "oracle/codemp/game/NPC_AI_Jedi.c:1969")
        var scratchUp = vec3_t()
        AngleVectors(fwdAngles, &scratchForward, &right, &scratchUp)

        animLength = Float(BG_AnimLength(`self`.localAnimIndex, animNumber_t(`self`.client!.ps.legsAnim)))
        if `self`.client!.ps.legsAnim == BOTH_WALL_RUN_LEFT && rightdot < 0 {
            //I'm running on a wall to my left and the attack is on the left
            if animLength - `self`.client!.ps.legsTimer > 400 && `self`.client!.ps.legsTimer > 400 {
                //not at the beginning or end of the anim
                anim = BOTH_WALL_RUN_LEFT_FLIP
            }
        } else if `self`.client!.ps.legsAnim == BOTH_WALL_RUN_RIGHT && rightdot > 0 {
            //I'm running on a wall to my right and the attack is on the right
            if animLength - `self`.client!.ps.legsTimer > 400 && `self`.client!.ps.legsTimer > 400 {
                //not at the beginning or end of the anim
                anim = BOTH_WALL_RUN_RIGHT_FLIP
            }
        }
        if anim != -1 {
            //flip off the wall!
            var parts: Int32 = 0
            //FIXME: check the direction we will flip towards for do-not-enter/walls/drops?
            //NOTE: we presume there is still a wall there!
            if anim == BOTH_WALL_RUN_LEFT_FLIP {
                `self`.client!.ps.velocity[0] *= 0.5
                `self`.client!.ps.velocity[1] *= 0.5
                _VectorMA(`self`.client!.ps.velocity, 150, right, &`self`.client!.ps.velocity)
            } else if anim == BOTH_WALL_RUN_RIGHT_FLIP {
                `self`.client!.ps.velocity[0] *= 0.5
                `self`.client!.ps.velocity[1] *= 0.5
                _VectorMA(`self`.client!.ps.velocity, -150, right, &`self`.client!.ps.velocity)
            }
            parts = SETANIM_LEGS
            if `self`.client!.ps.weaponTime == 0 {
                parts = SETANIM_BOTH
            }
            NPC_SetAnim(`self`, parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            //self->client->ps.pm_flags |= (PMF_JUMPING|PMF_SLOW_MO_FALL);
            //rwwFIXMEFIXME: Add these pm flags?
            G_AddEvent(`self`, EV_JUMP, 0)
            return EVASION_OTHER
        }
    } else if `self`.client!.NPC_class != CLASS_DESANN && (`self`.NPC!.rank == RANK_CREWMAN || `self`.NPC!.rank >= RANK_LT) && Q_irand(0, 1) != 0 && !BG_InRoll(`self`.client!.ps, `self`.client!.ps.legsAnim) && !PM_InKnockDown(`self`.client!.ps) && !BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim) {
        var fwd = vec3_t()
        var right = vec3_t()
        var traceto = vec3_t()
        var mins = vec3_t()
        var maxs = vec3_t()
        var fwdAngles = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives nil where Raven's block falls through to its end.
        let earlyOut = Trace.scratch { trace -> evasionType_t? in
            var parts: Int32 = 0
            var anim: Int32 = 0
            var speed: Float = 0
            var checkDist: Float = 0
            var allowCartWheels: Bool = true
            var allowWallFlips: Bool = true

            if `self`.client!.ps.weapon == WP_SABER {
                // Raven tests `self->client->saber[0].model` and `self->client->saber[0].model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                // Raven tests `self->client->saber[1].model` and `self->client->saber[1].model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                if !`self`.client!.saber[0].model.isEmpty && (`self`.client!.saber[0].saberFlags & SFL_NO_CARTWHEELS) != 0 {
                    allowCartWheels = false
                } else if !`self`.client!.saber[1].model.isEmpty && (`self`.client!.saber[1].saberFlags & SFL_NO_CARTWHEELS) != 0 {
                    allowCartWheels = false
                }
                // Raven tests `self->client->saber[0].model` and `self->client->saber[0].model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                // Raven tests `self->client->saber[1].model` and `self->client->saber[1].model[0]`.
                // Both read as the same Swift test, so the draft writes it once.
                if !`self`.client!.saber[0].model.isEmpty && (`self`.client!.saber[0].saberFlags & SFL_NO_WALL_FLIPS) != 0 {
                    allowWallFlips = false
                } else if !`self`.client!.saber[1].model.isEmpty && (`self`.client!.saber[1].saberFlags & SFL_NO_WALL_FLIPS) != 0 {
                    allowWallFlips = false
                }
            }

            mins = vec3_t(`self`.r.mins[0], `self`.r.mins[1], 0)
            maxs = vec3_t(`self`.r.maxs[0], `self`.r.maxs[1], 24)
            fwdAngles = vec3_t(0, `self`.client!.ps.viewangles[YAW], 0)

            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Jedi_CheckFlipEvasions", source: "oracle/codemp/game/NPC_AI_Jedi.c:1969")
            var scratchUp2 = vec3_t()
            AngleVectors(fwdAngles, &fwd, &right, &scratchUp2)

            parts = SETANIM_BOTH

            if BG_SaberInAttack(`self`.client!.ps.saberMove) || PM_SaberInStart(`self`.client!.ps.saberMove) {
                parts = SETANIM_LEGS
            }
            if rightdot >= 0 {
                if Q_irand(0, 1) != 0 {
                    anim = BOTH_ARIAL_LEFT
                } else {
                    anim = BOTH_CARTWHEEL_LEFT
                }
                checkDist = -128
                speed = -200
            } else {
                if Q_irand(0, 1) != 0 {
                    anim = BOTH_ARIAL_RIGHT
                } else {
                    anim = BOTH_CARTWHEEL_RIGHT
                }
                checkDist = 128
                speed = 200
            }
            //trace in the dir that we want to go
            _VectorMA(`self`.r.currentOrigin, checkDist, right, &traceto)
            trap_Trace(trace, `self`.r.currentOrigin, mins, maxs, traceto, `self`.s.number, CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP)
            if trace.fraction >= 1.0 && allowCartWheels {
                //it's clear, let's do it
                //FIXME: check for drops?
                var fwdAngles = vec3_t()
                var jumpRt = vec3_t()

                NPC_SetAnim(`self`, parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                `self`.client!.ps.weaponTime = `self`.client!.ps.legsTimer //don't attack again until this anim is done
                fwdAngles = `self`.client!.ps.viewangles
                fwdAngles[ROLL] = 0
                fwdAngles[PITCH] = fwdAngles[ROLL]
                //do the flip
                // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Jedi_CheckFlipEvasions", source: "oracle/codemp/game/NPC_AI_Jedi.c:1969")
                var scratchForward2 = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Jedi_CheckFlipEvasions", source: "oracle/codemp/game/NPC_AI_Jedi.c:1969")
                var scratchUp3 = vec3_t()
                AngleVectors(fwdAngles, &scratchForward2, &jumpRt, &scratchUp3)
                `self`.client!.ps.velocity = jumpRt * speed
                `self`.client!.ps.fd.forceJumpCharge = 0 //so we don't play the force flip anim
                `self`.client!.ps.velocity[2] = 200
                `self`.client!.ps.fd.forceJumpZStart = `self`.r.currentOrigin[2] //so we don't take damage if we land at same height
                //self->client->ps.pm_flags |= PMF_JUMPING;
                if `self`.client!.NPC_class == CLASS_BOBAFETT {
                    G_AddEvent(`self`, EV_JUMP, 0)
                } else {
                    G_SoundOnEnt(`self`, CHAN_BODY, "sound/weapons/force/jump.wav")
                }
                //ucmd.upmove = 0;
                return EVASION_CARTWHEEL
            } else if !((trace.contents & CONTENTS_BOTCLIP) != 0) {
                //hit a wall, not a do-not-enter brush
                //FIXME: before we check any of these jump-type evasions, we should check for headroom, right?
                //Okay, see if we can flip *off* the wall and go the other way
                var idealNormal = vec3_t()
                var traceEnt: Entity?

                idealNormal = `self`.r.currentOrigin - traceto
                VectorNormalize(&idealNormal)
                traceEnt = g_entities[trace.entityNum]
                if (trace.entityNum < ENTITYNUM_WORLD && traceEnt != nil && traceEnt!.s.solid != SOLID_BMODEL) || _DotProduct(trace.plane.normal, idealNormal) > 0.7 {
                    //it's a ent of some sort or it's a wall roughly facing us
                    var bestCheckDist: Float = 0
                    //hmm, see if we're moving forward
                    if _DotProduct(`self`.client!.ps.velocity, fwd) < 200 {
                        //not running forward very fast
                        //check to see if it's okay to move the other way
                        if (trace.fraction * checkDist) <= 32 {
                            //wall on that side is close enough to wall-flip off of or wall-run on
                            bestCheckDist = checkDist
                            checkDist *= -1.0
                            _VectorMA(`self`.r.currentOrigin, checkDist, right, &traceto)
                            //trace in the dir that we want to go
                            trap_Trace(trace, `self`.r.currentOrigin, mins, maxs, traceto, `self`.s.number, CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP)
                            if trace.fraction >= 1.0 {
                                //it's clear, let's do it
                                if allowWallFlips {
                                    //okay to do wall-flips with this saber
                                    var parts: Int32 = 0

                                    //FIXME: check for drops?
                                    //turn the cartwheel into a wallflip in the other dir
                                    if rightdot > 0 {
                                        anim = BOTH_WALL_FLIP_LEFT
                                        `self`.client!.ps.velocity[1] = 0
                                        `self`.client!.ps.velocity[0] = `self`.client!.ps.velocity[1]
                                        _VectorMA(`self`.client!.ps.velocity, 150, right, &`self`.client!.ps.velocity)
                                    } else {
                                        anim = BOTH_WALL_FLIP_RIGHT
                                        `self`.client!.ps.velocity[1] = 0
                                        `self`.client!.ps.velocity[0] = `self`.client!.ps.velocity[1]
                                        _VectorMA(`self`.client!.ps.velocity, -150, right, &`self`.client!.ps.velocity)
                                    }
                                    `self`.client!.ps.velocity[2] = forceJumpStrength[FORCE_LEVEL_2] / 2.25
                                    //animate me
                                    parts = SETANIM_LEGS
                                    if `self`.client!.ps.weaponTime == 0 {
                                        parts = SETANIM_BOTH
                                    }
                                    NPC_SetAnim(`self`, parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                                    `self`.client!.ps.fd.forceJumpZStart = `self`.r.currentOrigin[2] //so we don't take damage if we land at same height
                                    //self->client->ps.pm_flags |= (PMF_JUMPING|PMF_SLOW_MO_FALL);
                                    if `self`.client!.NPC_class == CLASS_BOBAFETT {
                                        G_AddEvent(`self`, EV_JUMP, 0)
                                    } else {
                                        G_SoundOnEnt(`self`, CHAN_BODY, "sound/weapons/force/jump.wav")
                                    }
                                    return EVASION_OTHER
                                }
                            } else {
                                //boxed in on both sides
                                if _DotProduct(`self`.client!.ps.velocity, fwd) < 0 {
                                    //moving backwards
                                    return EVASION_NONE
                                }
                                if (trace.fraction * checkDist) <= 32 && (trace.fraction * checkDist) < bestCheckDist {
                                    bestCheckDist = checkDist
                                }
                            }
                        } else {
                            //too far from that wall to flip or run off it, check other side
                            checkDist *= -1.0
                            _VectorMA(`self`.r.currentOrigin, checkDist, right, &traceto)
                            //trace in the dir that we want to go
                            trap_Trace(trace, `self`.r.currentOrigin, mins, maxs, traceto, `self`.s.number, CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_BOTCLIP)
                            if (trace.fraction * checkDist) <= 32 {
                                //wall on this side is close enough
                                bestCheckDist = checkDist
                            } else {
                                //neither side has a wall within 32
                                return EVASION_NONE
                            }
                        }
                    }
                    //Try wall run?
                    if bestCheckDist != 0 {
                        //one of the walls was close enough to wall-run on
                        var allowWallRuns: Bool = true
                        if `self`.client!.ps.weapon == WP_SABER {
                            // Raven tests `self->client->saber[0].model` and `self->client->saber[0].model[0]`.
                            // Both read as the same Swift test, so the draft writes it once.
                            // Raven tests `self->client->saber[1].model` and `self->client->saber[1].model[0]`.
                            // Both read as the same Swift test, so the draft writes it once.
                            if !`self`.client!.saber[0].model.isEmpty && (`self`.client!.saber[0].saberFlags & SFL_NO_WALL_RUNS) != 0 {
                                allowWallRuns = false
                            } else if !`self`.client!.saber[1].model.isEmpty && (`self`.client!.saber[1].saberFlags & SFL_NO_WALL_RUNS) != 0 {
                                allowWallRuns = false
                            }
                        }
                        if allowWallRuns {
                            //okay to do wallruns with this saber
                            var parts: Int32 = 0

                            //FIXME: check for long enough wall and a drop at the end?
                            if bestCheckDist > 0 {
                                //it was to the right
                                anim = BOTH_WALL_RUN_RIGHT
                            } else {
                                //it was to the left
                                anim = BOTH_WALL_RUN_LEFT
                            }
                            `self`.client!.ps.velocity[2] = forceJumpStrength[FORCE_LEVEL_2] / 2.25
                            //animate me
                            parts = SETANIM_LEGS
                            if `self`.client!.ps.weaponTime == 0 {
                                parts = SETANIM_BOTH
                            }
                            NPC_SetAnim(`self`, parts, anim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                            `self`.client!.ps.fd.forceJumpZStart = `self`.r.currentOrigin[2] //so we don't take damage if we land at same height
                            //self->client->ps.pm_flags |= (PMF_JUMPING|PMF_SLOW_MO_FALL);
                            if `self`.client!.NPC_class == CLASS_BOBAFETT {
                                G_AddEvent(`self`, EV_JUMP, 0)
                            } else {
                                G_SoundOnEnt(`self`, CHAN_BODY, "sound/weapons/force/jump.wav")
                            }
                            return EVASION_OTHER
                        }
                    }
                    //else check for wall in front, do backflip off wall
                }
            }
            return nil
        }
        if let earlyOut {
            return earlyOut
        }
    }
    return EVASION_NONE
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:2305
func Jedi_ReCalcParryTime(_ `self`: Entity, _ evasionType: JKAMP.evasionType_t) -> Int32 {
    if `self`.client == nil {
        return 0
    }
    if `self`.s.number == 0 {
        //player
        return bg_parryDebounce[`self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE]]
    } else if `self`.NPC != nil {
        if g_saberRealisticCombat.integer == 0 && (g_spskill.integer == 2 || (g_spskill.integer == 1 && `self`.client!.NPC_class == CLASS_TAVION)) {
            if `self`.client!.NPC_class == CLASS_TAVION {
                return 0
            } else {
                return Q_irand(0, 150)
            }
        } else {
            var baseTime: Int32
            if evasionType == EVASION_DODGE {
                baseTime = `self`.client!.ps.torsoTimer
            } else if evasionType == EVASION_CARTWHEEL {
                baseTime = `self`.client!.ps.torsoTimer
            } else if `self`.client!.ps.saberInFlight {
                baseTime = Q_irand(1, 3) * 50
            } else {
                if g_saberRealisticCombat.integer != 0 {
                    baseTime = 500

                    switch g_spskill.integer {
                    case 0:
                        baseTime = 500

                    case 1:
                        baseTime = 300

                    default:
                        baseTime = 100
                    }
                } else {
                    baseTime = 150 //500;

                    switch g_spskill.integer {
                    case 0:
                        baseTime = 200 //500;

                    case 1:
                        baseTime = 100 //300;

                    default:
                        baseTime = 50 //100;
                    }
                }

                if `self`.client!.NPC_class == CLASS_TAVION {
                    //Tavion is faster
                    baseTime = Int32(ceil(baseTime / 2.0))
                } else if `self`.NPC!.rank >= RANK_LT_JG {
                    //fencers, bosses, shadowtroopers, luke, desann, et al use the norm
                    if Q_irand(0, 2) != 0 {
                        //medium speed parry
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "assigning a variable to itself".
                        // Raven wrote: baseTime = baseTime
                        portMissing("Jedi_ReCalcParryTime", source: "oracle/codemp/game/NPC_AI_Jedi.c:2305")
                    } else {
                        //with the occasional fast parry
                        baseTime = Int32(ceil(baseTime / 2.0))
                    }
                } else if `self`.NPC!.rank == RANK_CIVILIAN {
                    //grunts are slowest
                    baseTime = baseTime * Q_irand(1, 3)
                } else if `self`.NPC!.rank == RANK_CREWMAN {
                    //acrobats aren't so bad
                    if evasionType == EVASION_PARRY || evasionType == EVASION_DUCK_PARRY || evasionType == EVASION_JUMP_PARRY {
                        //slower with parries
                        baseTime = baseTime * Q_irand(1, 2)
                    } else {
                        //faster with acrobatics
                        //baseTime = baseTime;
                    }
                } else {
                    //force users are kinda slow
                    baseTime = baseTime * Q_irand(1, 2)
                }
                if evasionType == EVASION_DUCK || evasionType == EVASION_DUCK_PARRY {
                    baseTime += 100
                } else if evasionType == EVASION_JUMP || evasionType == EVASION_JUMP_PARRY {
                    baseTime += 50
                } else if evasionType == EVASION_OTHER {
                    baseTime += 100
                } else if evasionType == EVASION_FJUMP {
                    baseTime += 100
                }
            }

            return baseTime
        }
    }
    return 0
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:2443
func Jedi_QuickReactions(_ `self`: Entity) -> Bool {
    if (`self`.client!.NPC_class == CLASS_JEDI && NPCInfo!.rank == RANK_COMMANDER) || `self`.client!.NPC_class == CLASS_TAVION || (`self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] > FORCE_LEVEL_1 && g_spskill.integer > 1) || (`self`.client!.ps.fd.forcePowerLevel[FP_SABER_DEFENSE] > FORCE_LEVEL_2 && g_spskill.integer > 0) {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:2455
func Jedi_SaberBusy(_ `self`: Entity) -> Bool {
    if `self`.client!.ps.torsoTimer > 300 && ((BG_SaberInAttack(`self`.client!.ps.saberMove) && `self`.client!.ps.fd.saberAnimLevel == FORCE_LEVEL_3) || BG_SpinningSaberAnim(`self`.client!.ps.torsoAnim) || BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim) || PM_SaberInBrokenParry(`self`.client!.ps.saberMove) || BG_FlippingAnim(`self`.client!.ps.torsoAnim) || PM_RollingAnim(`self`.client!.ps.torsoAnim)) {
        //my saber is not in a parrying position
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:2485
func Jedi_SaberBlockGo(_ `self`: Entity, _ cmd: JKAMP.Usercmd, _ pHitloc: JKAShared.vec3_t?, _ phitDir: JKAShared.vec3_t?, _ incoming: Entity?, _ dist: Float) -> JKAMP.evasionType_t {
    var hitloc = vec3_t()
    var hitdir = vec3_t()
    var diff = vec3_t()
    var fwdangles = vec3_t(0, 0, 0)
    var right = vec3_t()
    let rightdot: Float
    let zdiff: Float
    var duckChance: Int32 = 0
    var dodgeAnim: Int32 = -1
    var saberBusy: Bool = false
    var evaded: Bool = false
    var doDodge: Bool = false
    var evasionType: evasionType_t = EVASION_NONE

    //FIXME: if we don't have our saber in hand, pick the force throw option or a jump or strafe!
    //FIXME: reborn don't block enough anymore
    if incoming == nil {
        hitloc = pHitloc!
        hitdir = phitDir!
        //FIXME: maybe base this on rank some?  And/or g_spskill?
        if `self`.client!.ps.saberInFlight {
            //DOH!  do non-saber evasion!
            saberBusy = true
        } else if Jedi_QuickReactions(`self`) {
            //jedi trainer and tavion are must faster at parrying and can do it whenever they like
            //Also, on medium, all level 3 people can parry any time and on hard, all level 2 or 3 people can parry any time
        } else {
            saberBusy = Jedi_SaberBusy(`self`)
        }
    } else {
        if incoming!.s.weapon == WP_SABER {
            //flying lightsaber, face it!
            //FIXME: for this to actually work, we'd need to call update angles too?
            //Jedi_FaceEntity( self, incoming, qtrue );
        }
        hitloc = incoming!.r.currentOrigin
        VectorNormalize2(incoming!.s.pos.trDelta, &hitdir)
    }
    if `self`.client != nil && `self`.client!.NPC_class == CLASS_BOBAFETT {
        saberBusy = true
    }

    diff = hitloc - `self`.client!.renderInfo.eyePoint
    diff[2] = 0
    //VectorNormalize( diff );
    fwdangles[1] = `self`.client!.ps.viewangles[1]
    // Ultimately we might care if the shot was ahead or behind, but for now, just quadrant is fine.
    // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("Jedi_SaberBlockGo", source: "oracle/codemp/game/NPC_AI_Jedi.c:2485")
    var scratchForward = vec3_t()
    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
    portMissing("Jedi_SaberBlockGo", source: "oracle/codemp/game/NPC_AI_Jedi.c:2485")
    var scratchUp = vec3_t()
    AngleVectors(fwdangles, &scratchForward, &right, &scratchUp)

    rightdot = _DotProduct(right, diff) // + flrand(-0.10f,0.10f);
    //totalHeight = self->client->renderInfo.eyePoint[2] - self->r.absmin[2];
    zdiff = hitloc[2] - `self`.client!.renderInfo.eyePoint[2] // + Q_irand(-6,6);

    //see if we can dodge if need-be
    if (dist > 16 && (Q_irand(0, 2) != 0 || saberBusy)) || `self`.client!.ps.saberInFlight || BG_SabersOff(`self`.client!.ps) || `self`.client!.NPC_class == CLASS_BOBAFETT {
        //either it will miss by a bit (and 25% chance) OR our saber is not in-hand OR saber is off
        if `self`.NPC != nil && (`self`.NPC!.rank == RANK_CREWMAN || `self`.NPC!.rank >= RANK_LT_JG) {
            //acrobat or fencer or above
            if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE && !((`self`.client!.ps.pm_flags & PMF_DUCKED) != 0) && cmd.upmove >= 0 && TIMER_Done(`self`, "duck") && !BG_InRoll(`self`.client!.ps, `self`.client!.ps.legsAnim) && !PM_InKnockDown(`self`.client!.ps) && (`self`.client!.ps.saberInFlight || `self`.client!.NPC_class == CLASS_BOBAFETT || (!BG_SaberInAttack(`self`.client!.ps.saberMove) && !PM_SaberInStart(`self`.client!.ps.saberMove) && !BG_SpinningSaberAnim(`self`.client!.ps.torsoAnim) && !BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim))) {
                //need to check all these because it overrides both torso and legs with the dodge
                doDodge = true
            }
        }
    }
    // Figure out what quadrant the block was in.
    if d_JediAI.integer != 0 {
        Com_Printf("(%d) evading attack from height %4.2f, zdiff: %4.2f, rightdot: %4.2f\n", level.time, hitloc[2] - `self`.r.absmin[2], zdiff, rightdot)
    }

    //UL = > -1//-6
    //UR = > -6//-9
    //TOP = > +6//+4
    //FIXME: take FP_SABER_DEFENSE into account here somehow?
    if zdiff >= -5 {
        if incoming != nil || !saberBusy {
            if rightdot > 12 || (rightdot > 3 && zdiff < 5) || (incoming == nil && abs(hitdir[2]) < 0.25) {
                //coming from right
                if doDodge {
                    if `self`.client!.NPC_class == CLASS_BOBAFETT && Q_irand(0, 2) == 0 {
                        //roll!
                        TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                        TIMER_Start(`self`, "strafeLeft", Q_irand(500, 1500))
                        TIMER_Set(`self`, "strafeRight", 0)
                        evasionType = EVASION_DUCK
                        evaded = true
                    } else if Q_irand(0, 1) != 0 {
                        dodgeAnim = BOTH_DODGE_FL
                    } else {
                        dodgeAnim = BOTH_DODGE_BL
                    }
                } else {
                    `self`.client!.ps.saberBlocked = BLOCKED_UPPER_RIGHT
                    evasionType = EVASION_PARRY
                    if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                        if zdiff > 5 {
                            TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                            evasionType = EVASION_DUCK_PARRY
                            evaded = true
                            if d_JediAI.integer != 0 {
                                Com_Printf("duck ")
                            }
                        } else {
                            duckChance = 6
                        }
                    }
                }
                if d_JediAI.integer != 0 {
                    Com_Printf("UR block\n")
                }
            } else if rightdot < -12 || (rightdot < -3 && zdiff < 5) || (incoming == nil && abs(hitdir[2]) < 0.25) {
                //coming from left
                if doDodge {
                    if `self`.client!.NPC_class == CLASS_BOBAFETT && Q_irand(0, 2) == 0 {
                        //roll!
                        TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                        TIMER_Start(`self`, "strafeRight", Q_irand(500, 1500))
                        TIMER_Set(`self`, "strafeLeft", 0)
                        evasionType = EVASION_DUCK
                        evaded = true
                    } else if Q_irand(0, 1) != 0 {
                        dodgeAnim = BOTH_DODGE_FR
                    } else {
                        dodgeAnim = BOTH_DODGE_BR
                    }
                } else {
                    `self`.client!.ps.saberBlocked = BLOCKED_UPPER_LEFT
                    evasionType = EVASION_PARRY
                    if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                        if zdiff > 5 {
                            TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                            evasionType = EVASION_DUCK_PARRY
                            evaded = true
                            if d_JediAI.integer != 0 {
                                Com_Printf("duck ")
                            }
                        } else {
                            duckChance = 6
                        }
                    }
                }
                if d_JediAI.integer != 0 {
                    Com_Printf("UL block\n")
                }
            } else {
                `self`.client!.ps.saberBlocked = BLOCKED_TOP
                evasionType = EVASION_PARRY
                if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                    duckChance = 4
                }
                if d_JediAI.integer != 0 {
                    Com_Printf("TOP block\n")
                }
            }
            evaded = true
        } else {
            if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                //duckChance = 2;
                TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                evasionType = EVASION_DUCK
                evaded = true
                if d_JediAI.integer != 0 {
                    Com_Printf("duck ")
                }
            }
        }
    } else if zdiff > -22 {
        //LL = -22//= -18 to -39
        //LR = -23//= -20 to -41
        if 1 != 0 {
            //hmm, pretty low, but not low enough to use the low block, so we need to duck
            if `self`.client!.ps.groundEntityNum != ENTITYNUM_NONE {
                //duckChance = 2;
                TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                evasionType = EVASION_DUCK
                evaded = true
                if d_JediAI.integer != 0 {
                    Com_Printf("duck ")
                }
            } else {
                //in air!  Ducking does no good
            }
        }
        if incoming != nil || !saberBusy {
            if rightdot > 8 || (rightdot > 3 && zdiff < -11) {
                if doDodge {
                    if `self`.client!.NPC_class == CLASS_BOBAFETT && Q_irand(0, 2) == 0 {
                        //roll!
                        TIMER_Start(`self`, "strafeLeft", Q_irand(500, 1500))
                        TIMER_Set(`self`, "strafeRight", 0)
                    } else {
                        dodgeAnim = BOTH_DODGE_L
                    }
                } else {
                    `self`.client!.ps.saberBlocked = BLOCKED_UPPER_RIGHT
                    if evasionType == EVASION_DUCK {
                        evasionType = EVASION_DUCK_PARRY
                    } else {
                        evasionType = EVASION_PARRY
                    }
                }
                if d_JediAI.integer != 0 {
                    Com_Printf("mid-UR block\n")
                }
            } else if rightdot < -8 || (rightdot < -3 && zdiff < -11) {
                if doDodge {
                    if `self`.client!.NPC_class == CLASS_BOBAFETT && Q_irand(0, 2) == 0 {
                        //roll!
                        TIMER_Start(`self`, "strafeLeft", Q_irand(500, 1500))
                        TIMER_Set(`self`, "strafeRight", 0)
                    } else {
                        dodgeAnim = BOTH_DODGE_R
                    }
                } else {
                    `self`.client!.ps.saberBlocked = BLOCKED_UPPER_LEFT
                    if evasionType == EVASION_DUCK {
                        evasionType = EVASION_DUCK_PARRY
                    } else {
                        evasionType = EVASION_PARRY
                    }
                }
                if d_JediAI.integer != 0 {
                    Com_Printf("mid-UL block\n")
                }
            } else {
                `self`.client!.ps.saberBlocked = BLOCKED_TOP
                if evasionType == EVASION_DUCK {
                    evasionType = EVASION_DUCK_PARRY
                } else {
                    evasionType = EVASION_PARRY
                }
                if d_JediAI.integer != 0 {
                    Com_Printf("mid-TOP block\n")
                }
            }
            evaded = true
        }
    } else if saberBusy || (zdiff < -36 && (zdiff < -44 || Q_irand(0, 2) == 0)) {
        //jump!
        if `self`.client!.ps.groundEntityNum == ENTITYNUM_NONE {
            //already in air, duck to pull up legs
            TIMER_Start(`self`, "duck", Q_irand(500, 1500))
            evasionType = EVASION_DUCK
            evaded = true
            if d_JediAI.integer != 0 {
                Com_Printf("legs up\n")
            }
            if incoming != nil || !saberBusy {
                //since the jump may be cleared if not safe, set a lower block too
                if rightdot >= 0 {
                    `self`.client!.ps.saberBlocked = BLOCKED_LOWER_RIGHT
                    evasionType = EVASION_DUCK_PARRY
                    if d_JediAI.integer != 0 {
                        Com_Printf("LR block\n")
                    }
                } else {
                    `self`.client!.ps.saberBlocked = BLOCKED_LOWER_LEFT
                    evasionType = EVASION_DUCK_PARRY
                    if d_JediAI.integer != 0 {
                        Com_Printf("LL block\n")
                    }
                }
                evaded = true
            }
        } else {
            //gotta jump!
            if `self`.NPC != nil && (`self`.NPC!.rank == RANK_CREWMAN || `self`.NPC!.rank > RANK_LT_JG) && (Q_irand(0, 10) == 0 || (Q_irand(0, 2) == 0 && (cmd.forwardmove != 0 || cmd.rightmove != 0))) {
                //superjump
                //FIXME: check the jump, if can't, then block
                if `self`.NPC != nil && !((`self`.NPC!.scriptFlags & SCF_NO_ACROBATICS) != 0) && `self`.client!.ps.fd.forceRageRecoveryTime < level.time && !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) && !PM_InKnockDown(`self`.client!.ps) {
                    `self`.client!.ps.fd.forceJumpCharge = 320 //FIXME: calc this intelligently
                    evasionType = EVASION_FJUMP
                    evaded = true
                    if d_JediAI.integer != 0 {
                        Com_Printf("force jump + ")
                    }
                }
            } else {
                //normal jump
                //FIXME: check the jump, if can't, then block
                if `self`.NPC != nil && !((`self`.NPC!.scriptFlags & SCF_NO_ACROBATICS) != 0) && `self`.client!.ps.fd.forceRageRecoveryTime < level.time && !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) {
                    if `self`.client!.NPC_class == CLASS_BOBAFETT && Q_irand(0, 1) == 0 {
                        //roll!
                        if rightdot > 0 {
                            TIMER_Start(`self`, "strafeLeft", Q_irand(500, 1500))
                            TIMER_Set(`self`, "strafeRight", 0)
                            TIMER_Set(`self`, "walking", 0)
                        } else {
                            TIMER_Start(`self`, "strafeRight", Q_irand(500, 1500))
                            TIMER_Set(`self`, "strafeLeft", 0)
                            TIMER_Set(`self`, "walking", 0)
                        }
                    } else {
                        if `self` == NPC {
                            cmd.upmove = 127
                        } else {
                            `self`.client!.ps.velocity[2] = Float(JUMP_VELOCITY)
                        }
                    }
                    evasionType = EVASION_JUMP
                    evaded = true
                    if d_JediAI.integer != 0 {
                        Com_Printf("jump + ")
                    }
                }
                if `self`.client!.NPC_class == CLASS_TAVION {
                    if incoming == nil && `self`.client!.ps.groundEntityNum < ENTITYNUM_NONE && Q_irand(0, 2) == 0 {
                        if !BG_SaberInAttack(`self`.client!.ps.saberMove) && !PM_SaberInStart(`self`.client!.ps.saberMove) && !BG_InRoll(`self`.client!.ps, `self`.client!.ps.legsAnim) && !PM_InKnockDown(`self`.client!.ps) && !BG_SaberInSpecialAttack(`self`.client!.ps.torsoAnim) {
                            //do the butterfly!
                            let butterflyAnim: Int32
                            if Q_irand(0, 1) != 0 {
                                butterflyAnim = BOTH_BUTTERFLY_LEFT
                            } else {
                                butterflyAnim = BOTH_BUTTERFLY_RIGHT
                            }
                            evasionType = EVASION_CARTWHEEL
                            NPC_SetAnim(`self`, SETANIM_BOTH, butterflyAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                            `self`.client!.ps.velocity[2] = 225
                            `self`.client!.ps.fd.forceJumpZStart = `self`.r.currentOrigin[2] //so we don't take damage if we land at same height
                            //	self->client->ps.pm_flags |= PMF_JUMPING|PMF_SLOW_MO_FALL;
                            //	self->client->ps.SaberActivateTrail( 300 );//FIXME: reset this when done!
                            //Ah well. No hacking from the server for now.
                            if `self`.client!.NPC_class == CLASS_BOBAFETT {
                                G_AddEvent(`self`, EV_JUMP, 0)
                            } else {
                                G_Sound(`self`, CHAN_BODY, G_SoundIndex("sound/weapons/force/jump.wav"))
                            }
                            cmd.upmove = 0
                            saberBusy = true
                            evaded = true
                        }
                    }
                }
            }
            // Port-note: An assignment inside an expression.
            // Raven wrote: if ( ((evasionType = Jedi_CheckFlipEvasions( self, rightdot, zdiff ))!=EVASION_NONE) ) { if ( d_slowmodeath.integer > 5 && self->enemy && !self->enemy->s.number ) { G_StartMatrixEffect( self ); } saberBusy = qtrue; evaded = qtrue; } else if ( incoming || !saberBusy ) { //since the jump may be cleared if not safe, set a lower block too if ( rightdot >= 0 ) { self->client->ps.saberBlocked = BLOCKED_LOWER_RIGHT; if ( evasionType == EVASION_JUMP ) { evasionType = EVASION_JUMP_PARRY; } else if ( evasionType == EVASION_NONE ) { evasionType = EVASION_PARRY; } if ( d_JediAI.integer ) { Com_Printf( "LR block\n" ); } } else { self->client->ps.saberBlocked = BLOCKED_LOWER_LEFT; if ( evasionType == EVASION_JUMP ) { evasionType = EVASION_JUMP_PARRY; } else if ( evasionType == EVASION_NONE ) { evasionType = EVASION_PARRY; } if ( d_JediAI.integer ) { Com_Printf( "LL block\n" ); } } evaded = qtrue; }
            portMissing("Jedi_SaberBlockGo", source: "oracle/codemp/game/NPC_AI_Jedi.c:2485")
        }
    } else {
        if incoming != nil || !saberBusy {
            if rightdot >= 0 {
                `self`.client!.ps.saberBlocked = BLOCKED_LOWER_RIGHT
                evasionType = EVASION_PARRY
                if d_JediAI.integer != 0 {
                    Com_Printf("LR block\n")
                }
            } else {
                `self`.client!.ps.saberBlocked = BLOCKED_LOWER_LEFT
                evasionType = EVASION_PARRY
                if d_JediAI.integer != 0 {
                    Com_Printf("LL block\n")
                }
            }
            if incoming != nil && incoming!.s.weapon == WP_SABER {
                //thrown saber!
                if `self`.NPC != nil && (`self`.NPC!.rank == RANK_CREWMAN || `self`.NPC!.rank > RANK_LT_JG) && (Q_irand(0, 10) == 0 || (Q_irand(0, 2) == 0 && (cmd.forwardmove != 0 || cmd.rightmove != 0))) {
                    //superjump
                    //FIXME: check the jump, if can't, then block
                    if `self`.NPC != nil && !((`self`.NPC!.scriptFlags & SCF_NO_ACROBATICS) != 0) && `self`.client!.ps.fd.forceRageRecoveryTime < level.time && !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) && !PM_InKnockDown(`self`.client!.ps) {
                        `self`.client!.ps.fd.forceJumpCharge = 320 //FIXME: calc this intelligently
                        evasionType = EVASION_FJUMP
                        if d_JediAI.integer != 0 {
                            Com_Printf("force jump + ")
                        }
                    }
                } else {
                    //normal jump
                    //FIXME: check the jump, if can't, then block
                    if `self`.NPC != nil && !((`self`.NPC!.scriptFlags & SCF_NO_ACROBATICS) != 0) && `self`.client!.ps.fd.forceRageRecoveryTime < level.time && !((`self`.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) {
                        if `self` == NPC {
                            cmd.upmove = 127
                        } else {
                            `self`.client!.ps.velocity[2] = Float(JUMP_VELOCITY)
                        }
                        evasionType = EVASION_JUMP_PARRY
                        if d_JediAI.integer != 0 {
                            Com_Printf("jump + ")
                        }
                    }
                }
            }
            evaded = true
        }
    }

    if evasionType == EVASION_NONE {
        return EVASION_NONE
    }
    //stop taunting
    TIMER_Set(`self`, "taunting", 0)
    //stop gripping
    TIMER_Set(`self`, "gripping", -level.time)
    WP_ForcePowerStop(`self`, FP_GRIP)
    //stop draining
    TIMER_Set(`self`, "draining", -level.time)
    WP_ForcePowerStop(`self`, FP_DRAIN)

    if dodgeAnim != -1 {
        //dodged
        evasionType = EVASION_DODGE
        NPC_SetAnim(`self`, SETANIM_BOTH, dodgeAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
        `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer
        //force them to stop moving in this case
        `self`.client!.ps.pm_time = `self`.client!.ps.torsoTimer
        //FIXME: maybe make a sound?  Like a grunt?  EV_JUMP?
        `self`.client!.ps.pm_flags |= PMF_TIME_KNOCKBACK
        //dodged, not block
        if d_slowmodeath.integer > 5 && `self`.enemy != nil && `self`.enemy!.s.number == 0 {
            G_StartMatrixEffect(`self`)
        }
    } else {
        if duckChance != 0 {
            if Q_irand(0, duckChance) == 0 {
                TIMER_Start(`self`, "duck", Q_irand(500, 1500))
                if evasionType == EVASION_PARRY {
                    evasionType = EVASION_DUCK_PARRY
                } else {
                    evasionType = EVASION_DUCK
                }
                /*
                if ( d_JediAI.integer )
                {
                Com_Printf( "duck " );
                }
                */
            }
        }

        if incoming != nil {
            `self`.client!.ps.saberBlocked = WP_MissileBlockForBlock(`self`.client!.ps.saberBlocked)
        }
    }
    //if ( self->client->ps.saberBlocked != BLOCKED_NONE )
    do {
        let parryReCalcTime: Int32 = Jedi_ReCalcParryTime(`self`, evasionType)
        if `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] < level.time + parryReCalcTime {
            `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + parryReCalcTime
        }
    }
    return evasionType
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:3143
private func Jedi_SaberBlock(_ saberNum: Int32, _ bladeNum: Int32) -> Bool {
    var hitloc = vec3_t()
    var saberTipOld = vec3_t()
    var saberTip = vec3_t()
    var top = vec3_t()
    var bottom = vec3_t()
    var axisPoint = vec3_t()
    var saberPoint = vec3_t()
    var dir = vec3_t()
    var pointDir = vec3_t()
    var baseDir = vec3_t()
    var tipDir = vec3_t()
    var saberHitPoint = vec3_t()
    var saberMins = vec3_t()
    var saberMaxs = vec3_t()
    var pointDist: Float = 0
    var baseDirPerc: Float = 0
    var dist: Float = 0
    var bladeLen: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Bool in
        var evasionType: evasionType_t = 0

        //FIXME: reborn don't block enough anymore
        /*
        //maybe do this on easy only... or only on grunt-level reborn
        if ( NPC->client->ps.weaponTime )
        {//i'm attacking right now
        return qfalse;
        }
        */

        if !TIMER_Done(NPC!, "parryReCalcTime") {
            //can't do our own re-think of which parry to use yet
            return false
        }

        if NPC!.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] > level.time {
            //can't move the saber to another position yet
            return false
        }

        /*
        if ( NPCInfo->rank < RANK_LT_JG && Q_irand( 0, (2 - g_spskill.integer) ) )
        {//lower rank reborn have a random chance of not doing it at all
        NPC->client->ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + 300;
        return qfalse;
        }
        */

        if NPC!.enemy!.health <= 0 || NPC!.enemy!.client == nil {
            //don't keep blocking him once he's dead (or if not a client)
            return false
        }
        /*
        //VectorMA( NPC->enemy->client->renderInfo.muzzlePoint, NPC->enemy->client->ps.saberLength, NPC->enemy->client->renderInfo.muzzleDir, saberTip );
        //VectorMA( NPC->enemy->client->renderInfo.muzzlePointNext, NPC->enemy->client->ps.saberLength, NPC->enemy->client->renderInfo.muzzleDirNext, saberTipNext );
        VectorMA( NPC->enemy->client->renderInfo.muzzlePointOld, NPC->enemy->client->ps.saberLength, NPC->enemy->client->renderInfo.muzzleDirOld, saberTipOld );
        VectorMA( NPC->enemy->client->renderInfo.muzzlePoint, NPC->enemy->client->ps.saberLength, NPC->enemy->client->renderInfo.muzzleDir, saberTip );

        VectorSubtract( NPC->enemy->client->renderInfo.muzzlePoint, NPC->enemy->client->renderInfo.muzzlePointOld, dir );//get the dir
        VectorAdd( dir, NPC->enemy->client->renderInfo.muzzlePoint, saberBase );//extrapolate

        VectorSubtract( saberTip, saberTipOld, dir );//get the dir
        VectorAdd( dir, saberTip, saberTipOld );//extrapolate

        VectorCopy( NPC->r.currentOrigin, top );
        top[2] = NPC->r.absmax[2];
        VectorCopy( NPC->r.currentOrigin, bottom );
        bottom[2] = NPC->r.absmin[2];

        float dist = ShortestLineSegBewteen2LineSegs( saberBase, saberTipOld, bottom, top, saberPoint, axisPoint );
        if ( 0 )//dist > NPC->r.maxs[0]*4 )//was *3
        {//FIXME: sometimes he reacts when you're too far away to actually hit him
        if ( d_JediAI.integer )
        {
        Com_Printf( "enemy saber dist: %4.2f\n", dist );
        }
        TIMER_Set( NPC, "parryTime", -1 );
        return qfalse;
        }

        //get the actual point of impact
        trace_t	tr;
        trap_Trace( &tr, saberPoint, vec3_origin, vec3_origin, axisPoint, NPC->enemy->s.number, MASK_SHOT, G2_RETURNONHIT, 10 );
        if ( tr.allsolid || tr.startsolid )
        {//estimate
        VectorSubtract( saberPoint, axisPoint, dir );
        VectorNormalize( dir );
        VectorMA( axisPoint, NPC->r.maxs[0]*1.22, dir, hitloc );
        }
        else
        {
        VectorCopy( tr.endpos, hitloc );
        }
        */
        saberMins = vec3_t(-4, -4, -4)
        saberMaxs = vec3_t(4, 4, 4)

        _VectorMA(NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].muzzlePointOld, NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].length, NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].muzzleDirOld, &saberTipOld)
        _VectorMA(NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].muzzlePoint, NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].length, NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].muzzleDir, &saberTip)
        //	VectorCopy(NPC->enemy->client->lastSaberBase_Always, muzzlePoint);
        //	VectorMA(muzzlePoint, GAME_SABER_LENGTH, NPC->enemy->client->lastSaberDir_Always, saberTip);
        //	VectorCopy(saberTip, saberTipOld);

        top = NPC!.r.currentOrigin
        top[2] = NPC!.r.absmax[2]
        bottom = NPC!.r.currentOrigin
        bottom[2] = NPC!.r.absmin[2]

        dist = ShortestLineSegBewteen2LineSegs(NPC!.enemy!.client!.renderInfo.muzzlePoint, saberTip, bottom, top, &saberPoint, &axisPoint)
        if dist > NPC!.r.maxs[0] * 5 {
            //FIXME: sometimes he reacts when you're too far away to actually hit him
            if d_JediAI.integer != 0 {
                Com_Printf(S_COLOR_RED + "enemy saber dist: %4.2f\n", dist)
            }
            /*
            if ( dist < 300 //close
            && !Jedi_QuickReactions( NPC )//quick reaction people can interrupt themselves
            && (PM_SaberInStart( NPC->enemy->client->ps.saberMove ) || BG_SaberInAttack( NPC->enemy->client->ps.saberMove )) )//enemy is swinging at me
            {//he's swinging at me and close enough to be a threat, don't start an attack right now
            TIMER_Set( NPC, "parryTime", 100 );
            }
            else
            */
            do {
                TIMER_Set(NPC!, "parryTime", -1)
            }
            return false
        }
        if d_JediAI.integer != 0 {
            Com_Printf(S_COLOR_GREEN + "enemy saber dist: %4.2f\n", dist)
        }

        pointDir = saberPoint - NPC!.enemy!.client!.renderInfo.muzzlePoint
        pointDist = VectorLength(pointDir)

        bladeLen = NPC!.enemy!.client!.saber[saberNum].blade[bladeNum].length

        if bladeLen <= 0 {
            baseDirPerc = 0.5
        } else {
            baseDirPerc = pointDist / bladeLen
        }
        baseDir = NPC!.enemy!.client!.renderInfo.muzzlePoint - NPC!.enemy!.client!.renderInfo.muzzlePointOld
        tipDir = saberTip - saberTipOld
        baseDir = baseDir * baseDirPerc
        _VectorMA(baseDir, 1.0 - baseDirPerc, tipDir, &dir)
        _VectorMA(saberPoint, 200, dir, &hitloc)

        //get the actual point of impact
        trap_Trace(tr, saberPoint, saberMins, saberMaxs, hitloc, NPC!.enemy!.s.number, CONTENTS_BODY) //, G2_RETURNONHIT, 10 );
        if tr.allsolid != 0 || tr.startsolid != 0 || tr.fraction >= 1.0 {
            //estimate
            var dir2Me = vec3_t()
            dir2Me = axisPoint - saberPoint
            dist = VectorNormalize(&dir2Me)
            if _DotProduct(dir, dir2Me) < 0.2 {
                //saber is not swinging in my direction
                /*
                if ( dist < 300 //close
                && !Jedi_QuickReactions( NPC )//quick reaction people can interrupt themselves
                && (PM_SaberInStart( NPC->enemy->client->ps.saberMove ) || BG_SaberInAttack( NPC->enemy->client->ps.saberMove )) )//enemy is swinging at me
                {//he's swinging at me and close enough to be a threat, don't start an attack right now
                TIMER_Set( NPC, "parryTime", 100 );
                }
                else
                */
                do {
                    TIMER_Set(NPC!, "parryTime", -1)
                }
                return false
            }
            ShortestLineSegBewteen2LineSegs(saberPoint, hitloc, bottom, top, &saberHitPoint, &hitloc)
            /*
            VectorSubtract( saberPoint, axisPoint, dir );
            VectorNormalize( dir );
            VectorMA( axisPoint, NPC->r.maxs[0]*1.22, dir, hitloc );
            */
        } else {
            hitloc = tr.endpos
        }

        if d_JediAI.integer != 0 {
            //G_DebugLine( saberPoint, hitloc, FRAMETIME, WPDEBUG_SaberColor( NPC->enemy->client->ps.saber[saberNum].blade[bladeNum].color ), qtrue );
            G_TestLine(saberPoint, hitloc, 0x0000ff, FRAMETIME)
        }

        //FIXME: if saber is off and/or we have force speed and want to be really cocky,
        //		and the swing misses by some amount, we can use the dodges here... :)
        // Port-note: An assignment inside an expression.
        // Raven wrote: if ( (evasionType=Jedi_SaberBlockGo( NPC, &ucmd, hitloc, dir, NULL, dist )) != EVASION_DODGE ) {//we did block (not dodge) int parryReCalcTime; if ( !NPC->client->ps.saberInFlight ) {//make sure saber is on WP_ActivateSaber(NPC); } //debounce our parry recalc time parryReCalcTime = Jedi_ReCalcParryTime( NPC, evasionType ); TIMER_Set( NPC, "parryReCalcTime", Q_irand( 0, parryReCalcTime ) ); if ( d_JediAI.integer ) { Com_Printf( "Keep parry choice until: %d\n", level.time + parryReCalcTime ); } //determine how long to hold this anim if ( TIMER_Done( NPC, "parryTime" ) ) { if ( NPC->client->NPC_class == CLASS_TAVION ) { TIMER_Set( NPC, "parryTime", Q_irand( parryReCalcTime/2, parryReCalcTime*1.5 ) ); } else if ( NPCInfo->rank >= RANK_LT_JG ) {//fencers and higher hold a parry less TIMER_Set( NPC, "parryTime", parryReCalcTime ); } else {//others hold it longer TIMER_Set( NPC, "parryTime", Q_irand( 1, 2 )*parryReCalcTime ); } } } else { int dodgeTime = NPC->client->ps.torsoTimer; if ( NPCInfo->rank > RANK_LT_COMM && NPC->client->NPC_class != CLASS_DESANN ) {//higher-level guys can dodge faster dodgeTime -= 200; } TIMER_Set( NPC, "parryReCalcTime", dodgeTime ); TIMER_Set( NPC, "parryTime", dodgeTime ); }
        portMissing("Jedi_SaberBlock", source: "oracle/codemp/game/NPC_AI_Jedi.c:3143")
        return true
    }
}

/**
```
-------------------------
Jedi_EvasionSaber

defend if other is using saber and attacking me!
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Jedi.c:3380
private func Jedi_EvasionSaber(_ enemy_movedir: JKAShared.vec3_t, _ enemy_dist: Float, _ enemy_dir: JKAShared.vec3_t) {
    var dirEnemy2Me = vec3_t()
    var evasionChance: Int32 = 30
    var enemy_attacking: Bool = false
    var throwing_saber: Bool = false
    var shooting_lightning: Bool = false

    if NPC!.enemy!.client == nil {
        return
    } else if NPC!.enemy!.client != nil && NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.client!.ps.saberLockTime > level.time {
        //don't try to block/evade an enemy who is in a saberLock
        return
    } else if (NPC!.client!.ps.saberEventFlags & SEF_LOCK_WON) != 0 && NPC!.enemy!.painDebounceTime > level.time {
        //pressing the advantage of winning a saber lock
        return
    }

    if NPC!.enemy!.client!.ps.saberInFlight && !TIMER_Done(NPC!, "taunting") {
        //if he's throwing his saber, stop taunting
        TIMER_Set(NPC!, "taunting", -level.time)
        if !NPC!.client!.ps.saberInFlight {
            WP_ActivateSaber(NPC!)
        }
    }

    if TIMER_Done(NPC!, "parryTime") {
        if NPC!.client!.ps.saberBlocked != BLOCKED_ATK_BOUNCE && NPC!.client!.ps.saberBlocked != BLOCKED_PARRY_BROKEN {
            //wasn't blocked myself
            NPC!.client!.ps.saberBlocked = BLOCKED_NONE
        }
    }

    if NPC!.enemy!.client!.ps.weaponTime != 0 && NPC!.enemy!.client!.ps.weaponstate == WEAPON_FIRING {
        if !NPC!.client!.ps.saberInFlight && Jedi_SaberBlock(0, 0) {
            return
        }
    }

    dirEnemy2Me = NPC!.r.currentOrigin - NPC!.enemy!.r.currentOrigin
    VectorNormalize(&dirEnemy2Me)

    if NPC!.enemy!.client!.ps.weaponTime != 0 && NPC!.enemy!.client!.ps.weaponstate == WEAPON_FIRING {
        //enemy is attacking
        enemy_attacking = true
        evasionChance = 90
    }

    if (NPC!.enemy!.client!.ps.fd.forcePowersActive & (1 << FP_LIGHTNING)) != 0 {
        //enemy is shooting lightning
        enemy_attacking = true
        shooting_lightning = true
        evasionChance = 50
    }

    if NPC!.enemy!.client!.ps.saberInFlight && NPC!.enemy!.client!.ps.saberEntityNum != ENTITYNUM_NONE && NPC!.enemy!.client!.ps.saberEntityState != SES_RETURNING {
        //enemy is shooting lightning
        enemy_attacking = true
        throwing_saber = true
    }

    //FIXME: this needs to take skill and rank(reborn type) into account much more
    if Q_irand(0, 100) < evasionChance {
        //check to see if he's coming at me
        let facingAmt: Float
        if VectorCompare(enemy_movedir, vec3_origin) != 0 || shooting_lightning || throwing_saber {
            //he's not moving (or he's using a ranged attack), see if he's facing me
            var enemy_fwd = vec3_t()
            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Jedi_EvasionSaber", source: "oracle/codemp/game/NPC_AI_Jedi.c:3380")
            var scratchRight = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("Jedi_EvasionSaber", source: "oracle/codemp/game/NPC_AI_Jedi.c:3380")
            var scratchUp = vec3_t()
            AngleVectors(NPC!.enemy!.client!.ps.viewangles, &enemy_fwd, &scratchRight, &scratchUp)
            facingAmt = _DotProduct(enemy_fwd, dirEnemy2Me)
        } else {
            //he's moving
            facingAmt = _DotProduct(enemy_movedir, dirEnemy2Me)
        }

        if flrand(0.25, 1) < facingAmt {
            //coming at/facing me!
            var whichDefense: Int32 = 0
            if NPC!.client!.ps.weaponTime != 0 || NPC!.client!.ps.saberInFlight || NPC!.client!.NPC_class == CLASS_BOBAFETT {
                //I'm attacking or recovering from a parry, can only try to strafe/jump right now
                if Q_irand(0, 10) < NPCInfo!.stats.aggression {
                    return
                }
                whichDefense = 100
            } else {
                if shooting_lightning {
                    //check for lightning attack
                    //only valid defense is strafe and/or jump
                    whichDefense = 100
                } else if throwing_saber {
                    //he's thrown his saber!  See if it's coming at me
                    let saberDist: Float
                    var saberDir2Me = vec3_t()
                    var saberMoveDir = vec3_t()
                    let saber: Entity? = g_entities[NPC!.enemy!.client!.ps.saberEntityNum]
                    saberDir2Me = NPC!.r.currentOrigin - saber!.r.currentOrigin
                    saberDist = VectorNormalize(&saberDir2Me)
                    saberMoveDir = saber!.s.pos.trDelta
                    VectorNormalize(&saberMoveDir)
                    if Q_irand(0, 3) == 0 {
                        //Com_Printf( "(%d) raise agg - enemy threw saber\n", level.time );
                        Jedi_Aggression(NPC!, 1)
                    }
                    if Double(_DotProduct(saberMoveDir, saberDir2Me)) > 0.5 {
                        //it's heading towards me
                        if saberDist < 100 {
                            //it's close
                            whichDefense = Q_irand(3, 6)
                        } else if saberDist < 200 {
                            //got some time, yet, try pushing
                            whichDefense = Q_irand(0, 8)
                        }
                    }
                }
                if whichDefense != 0 {
                    //already chose one
                } else if enemy_dist > 80 || !enemy_attacking {
                    //he's pretty far, or not swinging, just strafe
                    if VectorCompare(enemy_movedir, vec3_origin) != 0 {
                        //if he's not moving, not swinging and far enough away, no evasion necc.
                        return
                    }
                    if Q_irand(0, 10) < NPCInfo!.stats.aggression {
                        return
                    }
                    whichDefense = 100
                } else {
                    //he's getting close and swinging at me
                    var fwd = vec3_t()
                    //see if I'm facing him
                    // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("Jedi_EvasionSaber", source: "oracle/codemp/game/NPC_AI_Jedi.c:3380")
                    var scratchRight2 = vec3_t()
                    // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                    portMissing("Jedi_EvasionSaber", source: "oracle/codemp/game/NPC_AI_Jedi.c:3380")
                    var scratchUp2 = vec3_t()
                    AngleVectors(NPC!.client!.ps.viewangles, &fwd, &scratchRight2, &scratchUp2)
                    if Double(_DotProduct(enemy_dir, fwd)) < 0.5 {
                        //I'm not really facing him, best option is to strafe
                        whichDefense = Q_irand(5, 16)
                    } else if enemy_dist < 56 {
                        //he's very close, maybe we should be more inclined to block or throw
                        whichDefense = Q_irand(NPCInfo!.stats.aggression, 12)
                    } else {
                        whichDefense = Q_irand(2, 16)
                    }
                }
            }

            if whichDefense >= 4 && whichDefense <= 12 {
                //would try to block
                if NPC!.client!.ps.saberInFlight {
                    //can't, saber in not in hand, so fall back to strafe/jump
                    whichDefense = 100
                }
            }

            switch whichDefense {
            case 0, 1, 2, 3:
                //use jedi force push?
                //FIXME: try to do this if health low or enemy back to a cliff?
                if (NPCInfo!.rank == RANK_ENSIGN || NPCInfo!.rank > RANK_LT_JG) && TIMER_Done(NPC!, "parryTime") {
                    //FIXME: check forcePushRadius[NPC->client->ps.fd.forcePowerLevel[FP_PUSH]]
                    ForceThrow(NPC!, false)
                }

            case 4, 5, 6, 7, 8, 9, 10, 11, 12:
                //try to parry the blow
                //Com_Printf( "blocking\n" );
                Jedi_SaberBlock(0, 0)

            default:
                //Evade!
                //start a strafe left/right if not already
                if Q_irand(0, 5) == 0 || !Jedi_Strafe(300, 1000, 0, 1000, false) {
                    //certain chance they will pick an alternative evasion
                    //if couldn't strafe, try a different kind of evasion...
                    if shooting_lightning || throwing_saber || enemy_dist < 80 {
                        //FIXME: force-jump+forward - jump over the guy!
                        if shooting_lightning || (Q_irand(0, 2) == 0 && NPCInfo!.stats.aggression < 4 && TIMER_Done(NPC!, "parryTime")) {
                            if (NPCInfo!.rank == RANK_ENSIGN || NPCInfo!.rank > RANK_LT_JG) && !shooting_lightning && Q_irand(0, 2) != 0 {
                                //FIXME: check forcePushRadius[NPC->client->ps.fd.forcePowerLevel[FP_PUSH]]
                                ForceThrow(NPC!, false)
                            } else if (NPCInfo!.rank == RANK_CREWMAN || NPCInfo!.rank > RANK_LT_JG) && !((NPCInfo!.scriptFlags & SCF_NO_ACROBATICS) != 0) && NPC!.client!.ps.fd.forceRageRecoveryTime < level.time && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) && !PM_InKnockDown(NPC!.client!.ps) {
                                //FIXME: make this a function call?
                                //FIXME: check for clearance, safety of landing spot?
                                NPC!.client!.ps.fd.forceJumpCharge = 480
                                //Don't jump again for another 2 to 5 seconds
                                TIMER_Set(NPC!, "jumpChaseDebounce", Q_irand(2000, 5000))
                                if Q_irand(0, 2) != 0 {
                                    ucmd.forwardmove = 127
                                    NPC!.client!.ps.moveDir = vec3_t()
                                } else {
                                    ucmd.forwardmove = -127
                                    NPC!.client!.ps.moveDir = vec3_t()
                                }
                                //FIXME: if this jump is cleared, we can't block... so pick a random lower block?
                                if Q_irand(0, 1) != 0 {
                                    NPC!.client!.ps.saberBlocked = BLOCKED_LOWER_RIGHT
                                } else {
                                    NPC!.client!.ps.saberBlocked = BLOCKED_LOWER_LEFT
                                }
                            }
                        } else if enemy_attacking {
                            Jedi_SaberBlock(0, 0)
                        }
                    }
                } else {
                    //strafed
                    if d_JediAI.integer != 0 {
                        Com_Printf("def strafe\n")
                    }
                    if !((NPCInfo!.scriptFlags & SCF_NO_ACROBATICS) != 0) && NPC!.client!.ps.fd.forceRageRecoveryTime < level.time && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0) && (NPCInfo!.rank == RANK_CREWMAN || NPCInfo!.rank > RANK_LT_JG) && !PM_InKnockDown(NPC!.client!.ps) && Q_irand(0, 5) == 0 {
                        //FIXME: make this a function call?
                        //FIXME: check for clearance, safety of landing spot?
                        if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                            NPC!.client!.ps.fd.forceJumpCharge = 280 //FIXME: calc this intelligently?
                        } else {
                            NPC!.client!.ps.fd.forceJumpCharge = 320
                        }
                        //Don't jump again for another 2 to 5 seconds
                        TIMER_Set(NPC!, "jumpChaseDebounce", Q_irand(2000, 5000))
                    }
                }
            }

            //turn off slow walking no matter what
            TIMER_Set(NPC!, "walking", -level.time)
            TIMER_Set(NPC!, "taunting", -level.time)
        }
    }
}

/**
```
==========================================================================================
INTERNAL AI ROUTINES
==========================================================================================
```
*/
/// Source: oracle/codemp/game/NPC_AI_Jedi.c:3686
func Jedi_FindEnemyInCone(_ `self`: Entity, _ fallback: Entity, _ minDot: Float) -> Entity? {
    var forward = vec3_t()
    var mins = vec3_t()
    var maxs = vec3_t()
    var dir = vec3_t()
    var dist: Float = 0
    let bestDist: Float = Float(Q3_INFINITE)
    var enemy: Entity? = fallback
    var check: Entity? = nil
    var entityList: [Int32] = [Int32](repeating: 0, count: 1024)
    var e: Int32 = 0
    var numListedEntities: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return Trace.scratch { tr -> Entity? in

        if `self`.client == nil {
            return enemy
        }

        // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Jedi_FindEnemyInCone", source: "oracle/codemp/game/NPC_AI_Jedi.c:3686")
        var scratchRight = vec3_t()
        // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
        portMissing("Jedi_FindEnemyInCone", source: "oracle/codemp/game/NPC_AI_Jedi.c:3686")
        var scratchUp = vec3_t()
        AngleVectors(`self`.client!.ps.viewangles, &forward, &scratchRight, &scratchUp)

        e = 0
        while e < 3 {
            mins[e] = `self`.r.currentOrigin[e] - 1024
            maxs[e] = `self`.r.currentOrigin[e] + 1024
            e += 1
        }
        numListedEntities = trap_EntitiesInBox(mins, maxs, &entityList, MAX_GENTITIES)

        e = 0
        while e < numListedEntities {
            check = g_entities[entityList[e]]
            if check == `self` {
                //me
                e += 1
                continue
            }
            if !(check!.inuse) {
                //freed
                e += 1
                continue
            }
            if check!.client == nil {
                //not a client - FIXME: what about turrets?
                e += 1
                continue
            }
            if check!.client!.playerTeam != `self`.client!.enemyTeam {
                //not an enemy - FIXME: what about turrets?
                e += 1
                continue
            }
            if check!.health <= 0 {
                //dead
                e += 1
                continue
            }

            if !trap_InPVS(check!.r.currentOrigin, `self`.r.currentOrigin) {
                //can't potentially see them
                e += 1
                continue
            }

            dir = check!.r.currentOrigin - `self`.r.currentOrigin
            dist = VectorNormalize(&dir)

            if _DotProduct(dir, forward) < minDot {
                //not in front
                e += 1
                continue
            }

            //really should have a clear LOS to this thing...
            trap_Trace(tr, `self`.r.currentOrigin, vec3_origin, vec3_origin, check!.r.currentOrigin, `self`.s.number, MASK_SHOT)
            if tr.fraction < 1.0 && tr.entityNum != check!.s.number {
                //must have clear shot
                e += 1
                continue
            }

            if dist < bestDist {
                //closer than our last best one
                dist = bestDist
                enemy = check
            }
            e += 1
        }
        return enemy
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:3763
private func Jedi_SetEnemyInfo(_ enemy_dest: inout JKAShared.vec3_t, _ enemy_dir: inout JKAShared.vec3_t, _ enemy_dist: inout Float, _ enemy_movedir: inout JKAShared.vec3_t, _ enemy_movespeed: inout Float, _ prediction: Int32) {
    if NPC == nil || NPC!.enemy == nil {
        //no valid enemy
        return
    }
    if NPC!.enemy!.client == nil {
        enemy_movedir = vec3_t()
        enemy_movespeed = 0
        enemy_dest = NPC!.enemy!.r.currentOrigin
        enemy_dest[2] += NPC!.enemy!.r.mins[2] + 24 //get it's origin to a height I can work with
        enemy_dir = enemy_dest - NPC!.r.currentOrigin
        //FIXME: enemy_dist calc needs to include all blade lengths, and include distance from hand to start of blade....
        enemy_dist = VectorNormalize(&enemy_dir) // - (NPC->client->ps.saberLengthMax + NPC->r.maxs[0]*1.5 + 16);
    } else {
        //see where enemy is headed
        enemy_movedir = NPC!.enemy!.client!.ps.velocity
        enemy_movespeed = VectorNormalize(&enemy_movedir)
        //figure out where he'll be, say, 3 frames from now
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Float' to expected argument type 'Double'".
        // Raven wrote: VectorMA( NPC->enemy->r.currentOrigin, *enemy_movespeed * 0.001 * prediction, enemy_movedir, enemy_dest )
        portMissing("Jedi_SetEnemyInfo", source: "oracle/codemp/game/NPC_AI_Jedi.c:3763")
        //figure out what dir the enemy's estimated position is from me and how far from the tip of my saber he is
        enemy_dir = enemy_dest - NPC!.r.currentOrigin //NPC->client->renderInfo.muzzlePoint
        //FIXME: enemy_dist calc needs to include all blade lengths, and include distance from hand to start of blade....
        enemy_dist = Float(Double(VectorNormalize(&enemy_dir)) - (Double(NPC!.client!.saber[0].blade[0].lengthMax) + Double(NPC!.r.maxs[0]) * 1.5 + 16)) //just use the blade 0 len I guess
        //FIXME: keep a group of enemies around me and use that info to make decisions...
        //		For instance, if there are multiple enemies, evade more, push them away
        //		and use medium attacks.  If enemies are using blasters, switch to fast.
        //		If one jedi enemy, use strong attacks.  Use grip when fighting one or
        //		two enemies, use lightning spread when fighting multiple enemies, etc.
        //		Also, when kill one, check rest of group instead of walking up to victim.
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:3799
private func Jedi_FaceEnemy(_ doPitch: Bool) {
    var enemy_eyes = vec3_t()
    var eyes = vec3_t()
    var angles = vec3_t()

    if NPC == nil {
        return
    }

    if NPC!.enemy == nil {
        return
    }

    if (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0 && NPC!.client!.ps.fd.forcePowerLevel[FP_GRIP] > FORCE_LEVEL_1 {
        //don't update?
        NPCInfo!.desiredPitch = NPC!.client!.ps.viewangles[PITCH]
        NPCInfo!.desiredYaw = NPC!.client!.ps.viewangles[YAW]
        return
    }
    CalcEntitySpot(NPC!, SPOT_HEAD, &eyes)

    CalcEntitySpot(NPC!.enemy!, SPOT_HEAD, &enemy_eyes)

    if NPC!.client!.NPC_class == CLASS_BOBAFETT && TIMER_Done(NPC!, "flameTime") && NPC!.s.weapon != WP_NONE && NPC!.s.weapon != WP_DISRUPTOR && (NPC!.s.weapon != WP_ROCKET_LAUNCHER || !((NPCInfo!.scriptFlags & SCF_ALT_FIRE) != 0)) && NPC!.s.weapon != WP_THERMAL && NPC!.s.weapon != WP_TRIP_MINE && NPC!.s.weapon != WP_DET_PACK && NPC!.s.weapon != WP_STUN_BATON {
        //boba leads his enemy
        if NPC!.health < NPC!.client!.pers.maxHealth * 0.5 {
            //lead
            // Port-note: The draft of this statement did not compile, and the compiler wrote "no exact matches in call to initializer".
            // Raven wrote: float missileSpeed = WP_SpeedOfMissileForWeapon( NPC->s.weapon, ((qboolean)(NPCInfo->scriptFlags&SCF_ALT_FIRE)) );
            portMissing("Jedi_FaceEnemy", source: "oracle/codemp/game/NPC_AI_Jedi.c:3799")
            // Port-note: A read of `missileSpeed`, a local the draft left as a hole.
            // Raven wrote: if ( missileSpeed ) { float eDist = Distance( eyes, enemy_eyes ); eDist /= missileSpeed;//How many seconds it will take to get to the enemy VectorMA( enemy_eyes, eDist*flrand(0.95f,1.25f), NPC->enemy->client->ps.velocity, enemy_eyes ); }
            portMissing("Jedi_FaceEnemy", source: "oracle/codemp/game/NPC_AI_Jedi.c:3799")
        }
    }

    //Find the desired angles
    if !NPC!.client!.ps.saberInFlight && (NPC!.client!.ps.legsAnim == BOTH_A2_STABBACK1 || NPC!.client!.ps.legsAnim == BOTH_CROUCHATTACKBACK1 || NPC!.client!.ps.legsAnim == BOTH_ATTACK_BACK) {
        //point *away*
        GetAnglesForDirection(enemy_eyes, eyes, &angles)
    } else {
        //point towards him
        GetAnglesForDirection(eyes, enemy_eyes, &angles)
    }

    NPCInfo!.desiredYaw = AngleNormalize360(angles[YAW])
    /*
    if ( NPC->client->ps.saberBlocked == BLOCKED_UPPER_LEFT )
    {//temp hack- to make up for poor coverage on left side
    NPCInfo->desiredYaw += 30;
    }
    */

    if doPitch {
        NPCInfo!.desiredPitch = AngleNormalize360(angles[PITCH])
        if NPC!.client!.ps.saberInFlight {
            //tilt down a little
            NPCInfo!.desiredPitch += 10
        }
    }
    //FIXME: else desiredPitch = 0?  Or keep previous?
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:3876
private func Jedi_DebounceDirectionChanges() {
    //FIXME: check these before making fwd/back & right/left decisions?
    //Time-debounce changes in forward/back dir
    if ucmd.forwardmove > 0 {
        if !TIMER_Done(NPC!, "moveback") || !TIMER_Done(NPC!, "movenone") {
            ucmd.forwardmove = 0
            //now we have to normalize the total movement again
            if ucmd.rightmove > 0 {
                ucmd.rightmove = 127
            } else if ucmd.rightmove < 0 {
                ucmd.rightmove = -127
            }
            NPC!.client!.ps.moveDir = vec3_t()
            TIMER_Set(NPC!, "moveback", -level.time)
            if TIMER_Done(NPC!, "movenone") {
                TIMER_Set(NPC!, "movenone", Q_irand(1000, 2000))
            }
        } else if TIMER_Done(NPC!, "moveforward") {
            //FIXME: should be if it's zero?
            TIMER_Set(NPC!, "moveforward", Q_irand(500, 2000))
        }
    } else if ucmd.forwardmove < 0 {
        if !TIMER_Done(NPC!, "moveforward") || !TIMER_Done(NPC!, "movenone") {
            ucmd.forwardmove = 0
            //now we have to normalize the total movement again
            if ucmd.rightmove > 0 {
                ucmd.rightmove = 127
            } else if ucmd.rightmove < 0 {
                ucmd.rightmove = -127
            }
            NPC!.client!.ps.moveDir = vec3_t()
            TIMER_Set(NPC!, "moveforward", -level.time)
            if TIMER_Done(NPC!, "movenone") {
                TIMER_Set(NPC!, "movenone", Q_irand(1000, 2000))
            }
        } else if TIMER_Done(NPC!, "moveback") {
            //FIXME: should be if it's zero?
            TIMER_Set(NPC!, "moveback", Q_irand(250, 1000))
        }
    } else if !TIMER_Done(NPC!, "moveforward") {
        //NOTE: edge checking should stop me if this is bad... but what if it sends us colliding into the enemy?
        ucmd.forwardmove = 127
        NPC!.client!.ps.moveDir = vec3_t()
    } else if !TIMER_Done(NPC!, "moveback") {
        //NOTE: edge checking should stop me if this is bad...
        ucmd.forwardmove = -127
        NPC!.client!.ps.moveDir = vec3_t()
    }
    //Time-debounce changes in right/left dir
    if ucmd.rightmove > 0 {
        if !TIMER_Done(NPC!, "moveleft") || !TIMER_Done(NPC!, "movecenter") {
            ucmd.rightmove = 0
            //now we have to normalize the total movement again
            if ucmd.forwardmove > 0 {
                ucmd.forwardmove = 127
            } else if ucmd.forwardmove < 0 {
                ucmd.forwardmove = -127
            }
            NPC!.client!.ps.moveDir = vec3_t()
            TIMER_Set(NPC!, "moveleft", -level.time)
            if TIMER_Done(NPC!, "movecenter") {
                TIMER_Set(NPC!, "movecenter", Q_irand(1000, 2000))
            }
        } else if TIMER_Done(NPC!, "moveright") {
            //FIXME: should be if it's zero?
            TIMER_Set(NPC!, "moveright", Q_irand(250, 1500))
        }
    } else if ucmd.rightmove < 0 {
        if !TIMER_Done(NPC!, "moveright") || !TIMER_Done(NPC!, "movecenter") {
            ucmd.rightmove = 0
            //now we have to normalize the total movement again
            if ucmd.forwardmove > 0 {
                ucmd.forwardmove = 127
            } else if ucmd.forwardmove < 0 {
                ucmd.forwardmove = -127
            }
            NPC!.client!.ps.moveDir = vec3_t()
            TIMER_Set(NPC!, "moveright", -level.time)
            if TIMER_Done(NPC!, "movecenter") {
                TIMER_Set(NPC!, "movecenter", Q_irand(1000, 2000))
            }
        } else if TIMER_Done(NPC!, "moveleft") {
            //FIXME: should be if it's zero?
            TIMER_Set(NPC!, "moveleft", Q_irand(250, 1500))
        }
    } else if !TIMER_Done(NPC!, "moveright") {
        //NOTE: edge checking should stop me if this is bad...
        ucmd.rightmove = 127
        NPC!.client!.ps.moveDir = vec3_t()
    } else if !TIMER_Done(NPC!, "moveleft") {
        //NOTE: edge checking should stop me if this is bad...
        ucmd.rightmove = -127
        NPC!.client!.ps.moveDir = vec3_t()
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4007
private func Jedi_TimersApply() {
    if ucmd.rightmove == 0 {
        //only if not already strafing
        //FIXME: if enemy behind me and turning to face enemy, don't strafe in that direction, too
        if !TIMER_Done(NPC!, "strafeLeft") {
            if NPCInfo!.desiredYaw > NPC!.client!.ps.viewangles[YAW] + 60 {
                //we want to turn left, don't apply the strafing
            } else {
                //go ahead and strafe left
                ucmd.rightmove = -127
                NPC!.client!.ps.moveDir = vec3_t()
            }
        } else if !TIMER_Done(NPC!, "strafeRight") {
            if NPCInfo!.desiredYaw < NPC!.client!.ps.viewangles[YAW] - 60 {
                //we want to turn right, don't apply the strafing
            } else {
                //go ahead and strafe left
                ucmd.rightmove = 127
                NPC!.client!.ps.moveDir = vec3_t()
            }
        }
    }

    Jedi_DebounceDirectionChanges()

    //use careful anim/slower movement if not already moving
    if ucmd.forwardmove == 0 && !TIMER_Done(NPC!, "walking") {
        ucmd.buttons |= (BUTTON_WALKING)
    }

    if !TIMER_Done(NPC!, "taunting") {
        ucmd.buttons |= (BUTTON_WALKING)
    }

    if !TIMER_Done(NPC!, "gripping") {
        //FIXME: what do we do if we ran out of power?  NPC's can't?
        //FIXME: don't keep turning to face enemy or we'll end up spinning around
        ucmd.buttons |= BUTTON_FORCEGRIP
    }

    if !TIMER_Done(NPC!, "draining") {
        //FIXME: what do we do if we ran out of power?  NPC's can't?
        //FIXME: don't keep turning to face enemy or we'll end up spinning around
        ucmd.buttons |= BUTTON_FORCE_DRAIN
    }

    if !TIMER_Done(NPC!, "holdLightning") {
        //hold down the lightning key
        ucmd.buttons |= BUTTON_FORCE_LIGHTNING
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4067
private func Jedi_CombatTimersUpdate(_ enemy_dist: Int32) {
    if TIMER_Done(NPC!, "roamTime") {
        TIMER_Set(NPC!, "roamTime", Q_irand(2000, 5000))
        //okay, now mess with agression
        if (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 {
            //raging
            Jedi_Aggression(NPC!, Q_irand(0, 3))
        } else if NPC!.client!.ps.fd.forceRageRecoveryTime > level.time {
            //recovering
            Jedi_Aggression(NPC!, Q_irand(0, -2))
        }
        if NPC!.enemy != nil && NPC!.enemy!.client != nil {
            switch NPC!.enemy!.client!.ps.weapon {
            case WP_SABER:
                //If enemy has a lightsaber, always close in
                if BG_SabersOff(NPC!.enemy!.client!.ps) {
                    //fool!  Standing around unarmed, charge!
                    //Com_Printf( "(%d) raise agg - enemy saber off\n", level.time );
                    Jedi_Aggression(NPC!, 2)
                } else {
                    //Com_Printf( "(%d) raise agg - enemy saber\n", level.time );
                    Jedi_Aggression(NPC!, 1)
                }

            case WP_BLASTER, WP_BRYAR_PISTOL, WP_DISRUPTOR, WP_BOWCASTER, WP_REPEATER, WP_DEMP2, WP_FLECHETTE, WP_ROCKET_LAUNCHER:
                //if he has a blaster, move in when:
                //They're not shooting at me
                if NPC!.enemy!.attackDebounceTime < level.time {
                    //does this apply to players?
                    //Com_Printf( "(%d) raise agg - enemy not shooting ranged weap\n", level.time );
                    Jedi_Aggression(NPC!, 1)
                }
                //He's closer than a dist that gives us time to deflect
                if enemy_dist < 256 {
                    //Com_Printf( "(%d) raise agg - enemy ranged weap- too close\n", level.time );
                    Jedi_Aggression(NPC!, 1)
                }

            default:
                break
            }
        }
    }

    if TIMER_Done(NPC!, "noStrafe") && TIMER_Done(NPC!, "strafeLeft") && TIMER_Done(NPC!, "strafeRight") {
        //FIXME: Maybe more likely to do this if aggression higher?  Or some other stat?
        if Q_irand(0, 4) == 0 {
            //start a strafe
            if Jedi_Strafe(1000, 3000, 0, 4000, true) {
                if d_JediAI.integer != 0 {
                    Com_Printf("off strafe\n")
                }
            }
        } else {
            //postpone any strafing for a while
            TIMER_Set(NPC!, "noStrafe", Q_irand(1000, 3000))
        }
    }

    if NPC!.client!.ps.saberEventFlags != 0 {
        //some kind of saber combat event is still pending
        var newFlags: Int32 = NPC!.client!.ps.saberEventFlags
        if (NPC!.client!.ps.saberEventFlags & SEF_PARRIED) != 0 {
            //parried
            TIMER_Set(NPC!, "parryTime", -1)
            /*
            if ( NPCInfo->rank >= RANK_LT_JG )
            {
            NPC->client->ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + 100;
            }
            else
            {
            NPC->client->ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + 500;
            }
            */
            if NPC!.enemy != nil && PM_SaberInKnockaway(NPC!.enemy!.client!.ps.saberMove) {
                //advance!
                Jedi_Aggression(NPC!, 1) //get closer
                Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel - 1)) //use a faster attack
            } else {
                if Q_irand(0, 1) == 0 {
                    //Com_Printf( "(%d) drop agg - we parried\n", level.time );
                    Jedi_Aggression(NPC!, -1)
                }
                if Q_irand(0, 1) == 0 {
                    Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel - 1))
                }
            }
            if d_JediAI.integer != 0 {
                Com_Printf("(%d) PARRY: agg %d, no parry until %d\n", level.time, NPCInfo!.stats.aggression, level.time + 100)
            }
            newFlags &= ~SEF_PARRIED
        }
        if NPC!.client!.ps.weaponTime == 0 && (NPC!.client!.ps.saberEventFlags & SEF_HITENEMY) != 0 {
            //we hit our enemy last time we swung, drop our aggression
            if Q_irand(0, 1) == 0 {
                //Com_Printf( "(%d) drop agg - we hit enemy\n", level.time );
                Jedi_Aggression(NPC!, -1)
                if d_JediAI.integer != 0 {
                    Com_Printf("(%d) HIT: agg %d\n", level.time, NPCInfo!.stats.aggression)
                }
                if Q_irand(0, 3) == 0 && NPCInfo!.blockedSpeechDebounceTime < level.time && jediSpeechDebounceTime[NPC!.client!.playerTeam] < level.time && NPC!.painDebounceTime < level.time - 1000 {
                    G_AddVoiceEvent(NPC!, Q_irand(EV_GLOAT1, EV_GLOAT3), 3000)
                    NPCInfo!.blockedSpeechDebounceTime = level.time + 3000
                    jediSpeechDebounceTime[NPC!.client!.playerTeam] = NPCInfo!.blockedSpeechDebounceTime
                }
            }
            if Q_irand(0, 2) == 0 {
                Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel + 1))
            }
            newFlags &= ~SEF_HITENEMY
        }
        if (NPC!.client!.ps.saberEventFlags & SEF_BLOCKED) != 0 {
            //was blocked whilst attacking
            if PM_SaberInBrokenParry(NPC!.client!.ps.saberMove) || NPC!.client!.ps.saberBlocked == BLOCKED_PARRY_BROKEN {
                //Com_Printf( "(%d) drop agg - we were knock-blocked\n", level.time );
                if NPC!.client!.ps.saberInFlight {
                    //lost our saber, too!!!
                    Jedi_Aggression(NPC!, -5) //really really really should back off!!!
                } else {
                    Jedi_Aggression(NPC!, -2) //really should back off!
                }
                Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel + 1)) //use a stronger attack
                if d_JediAI.integer != 0 {
                    Com_Printf("(%d) KNOCK-BLOCKED: agg %d\n", level.time, NPCInfo!.stats.aggression)
                }
            } else {
                if Q_irand(0, 2) == 0 {
                    //Com_Printf( "(%d) drop agg - we were blocked\n", level.time );
                    Jedi_Aggression(NPC!, -1)
                    if d_JediAI.integer != 0 {
                        Com_Printf("(%d) BLOCKED: agg %d\n", level.time, NPCInfo!.stats.aggression)
                    }
                }
                if Q_irand(0, 1) == 0 {
                    Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel + 1))
                }
            }
            newFlags &= ~SEF_BLOCKED
            //FIXME: based on the type of parry the enemy is doing and my skill,
            //		choose an attack that is likely to get around the parry?
            //		right now that's generic in the saber animation code, auto-picks
            //		a next anim for me, but really should be AI-controlled.
        }
        if (NPC!.client!.ps.saberEventFlags & SEF_DEFLECTED) != 0 {
            //deflected a shot
            newFlags &= ~SEF_DEFLECTED
            if Q_irand(0, 3) == 0 {
                Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel - 1))
            }
        }
        if (NPC!.client!.ps.saberEventFlags & SEF_HITWALL) != 0 {
            //hit a wall
            newFlags &= ~SEF_HITWALL
        }
        if (NPC!.client!.ps.saberEventFlags & SEF_HITOBJECT) != 0 {
            //hit some other damagable object
            if Q_irand(0, 3) == 0 {
                Jedi_AdjustSaberAnimLevel(NPC!, (NPC!.client!.ps.fd.saberAnimLevel - 1))
            }
            newFlags &= ~SEF_HITOBJECT
        }
        NPC!.client!.ps.saberEventFlags = newFlags
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4275
private func Jedi_CombatIdle(_ enemy_dist: Int32) {
    if !TIMER_Done(NPC!, "parryTime") {
        return
    }
    if NPC!.client!.ps.saberInFlight {
        //don't do this idle stuff if throwing saber
        return
    }
    if (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_RAGE)) != 0 || NPC!.client!.ps.fd.forceRageRecoveryTime > level.time {
        //never taunt while raging or recovering from rage
        return
    }
    //FIXME: make these distance numbers defines?
    if enemy_dist >= 64 {
        //FIXME: only do this if standing still?
        //based on aggression, flaunt/taunt
        var chance: Int32 = 20
        if NPC!.client!.NPC_class == CLASS_SHADOWTROOPER {
            chance = 10
        }
        //FIXME: possibly throw local objects at enemy?
        if Q_irand(2, chance) < NPCInfo!.stats.aggression {
            if TIMER_Done(NPC!, "chatter") && NPC!.client!.ps.forceHandExtend == HANDEXTEND_NONE {
                //FIXME: add more taunt behaviors
                //FIXME: sometimes he turns it off, then turns it right back on again???
                if enemy_dist > 200 && NPC!.client!.NPC_class != CLASS_BOBAFETT && NPC!.client!.ps.saberHolstered == 0 && Q_irand(0, 5) == 0 {
                    //taunt even more, turn off the saber
                    //FIXME: don't do this if health low?
                    WP_DeactivateSaber(NPC!, false)
                    //Don't attack for a bit
                    NPCInfo!.stats.aggression = 3
                    //FIXME: maybe start strafing?
                    //debounce this
                    if NPC!.client!.playerTeam != NPCTEAM_PLAYER && Q_irand(0, 1) == 0 {
                        //NPC->client->ps.taunting = level.time + 100;
                        NPC!.client!.ps.forceHandExtend = HANDEXTEND_JEDITAUNT
                        NPC!.client!.ps.forceHandExtendTime = level.time + 5000

                        TIMER_Set(NPC!, "chatter", Q_irand(5000, 10000))
                        TIMER_Set(NPC!, "taunting", 5500)
                    } else {
                        Jedi_BattleTaunt()
                        TIMER_Set(NPC!, "taunting", Q_irand(5000, 10000))
                    }
                } else if Jedi_BattleTaunt() {
                    //FIXME: pick some anims
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4339
private func Jedi_AttackDecide(_ enemy_dist: Int32) -> Bool {
    if NPC!.enemy!.client != nil && NPC!.enemy!.s.weapon == WP_SABER && NPC!.enemy!.client!.ps.saberLockTime > level.time && NPC!.client!.ps.saberLockTime < level.time {
        //enemy is in a saberLock and we are not
        return false
    }

    if (NPC!.client!.ps.saberEventFlags & SEF_LOCK_WON) != 0 {
        //we won a saber lock, press the advantage with an attack!
        var chance: Int32 = 0
        if NPC!.client!.NPC_class == CLASS_DESANN || NPC!.client!.NPC_class == CLASS_LUKE || Q_stricmp("Yoda", NPC!.NPC_type!) == 0 {
            //desann and luke
            chance = 20
        } else if NPC!.client!.NPC_class == CLASS_TAVION {
            //tavion
            chance = 10
        } else if NPC!.client!.NPC_class == CLASS_REBORN && NPCInfo!.rank == RANK_LT_JG {
            //fencer
            chance = 5
        } else {
            chance = NPCInfo!.rank
        }
        if Q_irand(0, 30) < chance {
            //based on skill with some randomness
            NPC!.client!.ps.saberEventFlags &= ~SEF_LOCK_WON //clear this now that we are using the opportunity
            TIMER_Set(NPC!, "noRetreat", Q_irand(500, 2000))
            //FIXME: check enemy_dist?
            NPC!.attackDebounceTime = 0
            NPCInfo!.shotTime = NPC!.attackDebounceTime
            NPC!.client!.ps.weaponTime = NPCInfo!.shotTime
            //NPC->client->ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + 500;
            NPC!.client!.ps.saberBlocked = BLOCKED_NONE
            WeaponThink(true)
            return true
        }
    }

    if NPC!.client!.NPC_class == CLASS_TAVION || (NPC!.client!.NPC_class == CLASS_REBORN && NPCInfo!.rank == RANK_LT_JG) || (NPC!.client!.NPC_class == CLASS_JEDI && NPCInfo!.rank == RANK_COMMANDER) {
        //tavion, fencers, jedi trainer are all good at following up a parry with an attack
        if (PM_SaberInParry(NPC!.client!.ps.saberMove) || PM_SaberInKnockaway(NPC!.client!.ps.saberMove)) && NPC!.client!.ps.saberBlocked != BLOCKED_PARRY_BROKEN {
            //try to attack straight from a parry
            NPC!.attackDebounceTime = 0
            NPCInfo!.shotTime = NPC!.attackDebounceTime
            NPC!.client!.ps.weaponTime = NPCInfo!.shotTime
            //NPC->client->ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + 500;
            NPC!.client!.ps.saberBlocked = BLOCKED_NONE
            Jedi_AdjustSaberAnimLevel(NPC!, FORCE_LEVEL_1) //try to follow-up with a quick attack
            WeaponThink(true)
            return true
        }
    }

    //try to hit them if we can
    if enemy_dist >= 64 {
        return false
    }

    if !TIMER_Done(NPC!, "parryTime") {
        return false
    }

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 {
        //not allowed to attack
        return false
    }

    if !((ucmd.buttons & BUTTON_ATTACK) != 0) && !((ucmd.buttons & BUTTON_ALT_ATTACK) != 0) {
        //not already attacking
        //Try to attack
        WeaponThink(true)
    }

    //FIXME:  Maybe try to push enemy off a ledge?

    //close enough to step forward

    //FIXME: an attack debounce timer other than the phaser debounce time?
    //		or base it on aggression?

    if (ucmd.buttons & BUTTON_ATTACK) != 0 {
        //attacking
        /*
        if ( enemy_dist > 32 && NPCInfo->stats.aggression >= 4 )
        {//move forward if we're too far away and we're chasing him
        ucmd.forwardmove = 127;
        }
        else if ( enemy_dist < 0 )
        {//move back if we're too close
        ucmd.forwardmove = -127;
        }
        */
        //FIXME: based on the type of parry/attack the enemy is doing and my skill,
        //		choose an attack that is likely to get around the parry?
        //		right now that's generic in the saber animation code, auto-picks
        //		a next anim for me, but really should be AI-controlled.
        //FIXME: have this interact with/override above strafing code?
        if ucmd.rightmove == 0 {
            //not already strafing
            if Q_irand(0, 3) == 0 {
                //25% chance of doing this
                var right = vec3_t()
                var dir2enemy = vec3_t()

                // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Jedi_AttackDecide", source: "oracle/codemp/game/NPC_AI_Jedi.c:4339")
                var scratchForward = vec3_t()
                // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                portMissing("Jedi_AttackDecide", source: "oracle/codemp/game/NPC_AI_Jedi.c:4339")
                var scratchUp = vec3_t()
                AngleVectors(NPC!.r.currentAngles, &scratchForward, &right, &scratchUp)
                dir2enemy = NPC!.enemy!.r.currentOrigin - NPC!.r.currentAngles
                if _DotProduct(right, dir2enemy) > 0 {
                    //he's to my right, strafe left
                    ucmd.rightmove = -127
                    NPC!.client!.ps.moveDir = vec3_t()
                } else {
                    //he's to my left, strafe right
                    ucmd.rightmove = 127
                    NPC!.client!.ps.moveDir = vec3_t()
                }
            }
        }
        return true
    }

    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4473
private func Jedi_Jump(_ dest: JKAShared.vec3_t, _ goalEntNum: Int32) -> Bool {
    //FIXME: if land on enemy, knock him down & jump off again
    /*
    if ( dest[2] - NPC->r.currentOrigin[2] < 64 && DistanceHorizontal( NPC->r.currentOrigin, dest ) > 256 )
    {//a pretty horizontal jump, easy to fake:
    vec3_t enemy_diff;

    VectorSubtract( dest, NPC->r.currentOrigin, enemy_diff );
    float enemy_z_diff = enemy_diff[2];
    enemy_diff[2] = 0;
    float enemy_xy_diff = VectorNormalize( enemy_diff );

    VectorScale( enemy_diff, enemy_xy_diff*0.8, NPC->client->ps.velocity );
    if ( enemy_z_diff < 64 )
    {
    NPC->client->ps.velocity[2] = enemy_xy_diff;
    }
    else
    {
    NPC->client->ps.velocity[2] = enemy_z_diff*2+enemy_xy_diff/2;
    }
    }
    else
    */
    if 1 != 0 {
        var targetDist: Float = 0
        var shotSpeed: Float = 300
        var travelTime: Float = 0
        var impactDist: Float = 0
        var bestImpactDist: Float = Float(Q3_INFINITE)
        var targetDir = vec3_t()
        var shotVel = vec3_t()
        var failCase = vec3_t()
        // Raven's record lives to the end of his block, so the block is the closure.
        Trace.scratch { trace in
            // Raven's record lives to the end of his block, so the block is the closure.
            Trajectory.scratch { tr in
                var blocked: Bool = false
                var elapsedTime: Int32 = 0
                let timeStep: Int32 = 500
                var hitCount: Int32 = 0
                let maxHits: Int32 = 7
                var lastPos = vec3_t()
                var testPos = vec3_t()
                var bottom = vec3_t()

                while hitCount < maxHits {
                    targetDir = dest - NPC!.r.currentOrigin
                    targetDist = VectorNormalize(&targetDir)

                    shotVel = targetDir * shotSpeed
                    travelTime = targetDist / shotSpeed
                    shotVel[2] = Float(Double(shotVel[2]) + Double(travelTime) * 0.5 * Double(NPC!.client!.ps.gravity))

                    if hitCount == 0 {
                        //save the first one as the worst case scenario
                        failCase = shotVel
                    }

                    if 1 != 0 {
                        //do a rough trace of the path
                        blocked = false

                        tr.trBase = NPC!.r.currentOrigin
                        tr.trDelta = shotVel
                        tr.trType = TR_GRAVITY
                        tr.trTime = level.time
                        travelTime *= 1000.0
                        lastPos = NPC!.r.currentOrigin

                        //This may be kind of wasteful, especially on long throws... use larger steps?  Divide the travelTime into a certain hard number of slices?  Trace just to apex and down?
                        elapsedTime = timeStep
                        while elapsedTime < floor(travelTime) + timeStep {
                            if Float(elapsedTime) > travelTime {
                                //cap it
                                elapsedTime = Int32(floor(travelTime))
                            }
                            BG_EvaluateTrajectory(tr, level.time + elapsedTime, &testPos)
                            if testPos[2] < lastPos[2] {
                                //going down, ignore botclip
                                trap_Trace(trace, lastPos, NPC!.r.mins, NPC!.r.maxs, testPos, NPC!.s.number, NPC!.clipmask)
                            } else {
                                //going up, check for botclip
                                trap_Trace(trace, lastPos, NPC!.r.mins, NPC!.r.maxs, testPos, NPC!.s.number, NPC!.clipmask | CONTENTS_BOTCLIP)
                            }

                            if trace.allsolid != 0 || trace.startsolid != 0 {
                                blocked = true
                                break
                            }
                            if trace.fraction < 1.0 {
                                //hit something
                                if trace.entityNum == goalEntNum {
                                    //hit the enemy, that's perfect!
                                    //Hmm, don't want to land on him, though...
                                    break
                                } else {
                                    if (trace.contents & CONTENTS_BOTCLIP) != 0 {
                                        //hit a do-not-enter brush
                                        blocked = true
                                        break
                                    }
                                    if Double(trace.plane.normal[2]) > 0.7 && DistanceSquared(trace.endpos, dest) < 4096 {
                                        //close enough!
                                        break
                                    } else {
                                        //FIXME: maybe find the extents of this brush and go above or below it on next try somehow?
                                        impactDist = DistanceSquared(trace.endpos, dest)
                                        if impactDist < bestImpactDist {
                                            bestImpactDist = impactDist
                                            failCase = shotVel
                                        }
                                        blocked = true
                                        break
                                    }
                                }
                            }
                            if elapsedTime == floor(travelTime) {
                                //reached end, all clear
                                if trace.fraction >= 1.0 {
                                    //hmm, make sure we'll land on the ground...
                                    //FIXME: do we care how far below ourselves or our dest we'll land?
                                    bottom = trace.endpos
                                    bottom[2] -= 128
                                    trap_Trace(trace, trace.endpos, NPC!.r.mins, NPC!.r.maxs, bottom, NPC!.s.number, NPC!.clipmask)
                                    if trace.fraction >= 1.0 {
                                        //would fall too far
                                        blocked = true
                                    }
                                }
                                break
                            } else {
                                //all clear, try next slice
                                lastPos = testPos
                            }
                            elapsedTime += timeStep
                        }
                        if blocked {
                            //hit something, adjust speed (which will change arc)
                            hitCount += 1
                            shotSpeed = Float(300 + ((hitCount - 2) * 100)) //from 100 to 900 (skipping 300)
                            if hitCount >= 2 {
                                //skip 300 since that was the first value we tested
                                shotSpeed += 100
                            }
                        } else {
                            //made it!
                            break
                        }
                    } else {
                        //no need to check the path, go with first calc
                        break
                    }
                }

                if hitCount >= maxHits {
                    //NOTE: worst case scenario, use the one that impacted closest to the target (or just use the first try...?)
                    //NOTE: or try failcase?
                    NPC!.client!.ps.velocity = failCase
                }
                NPC!.client!.ps.velocity = shotVel
            }
        }
    } else {
        //a more complicated jump
        var dir = vec3_t()
        var p1 = vec3_t()
        var p2 = vec3_t()
        var apex = vec3_t()
        var time: Float = 0
        var height: Float = 0
        var forward: Float = 0
        var z: Float = 0
        var xy: Float = 0
        var dist: Float = 0
        var apexHeight: Float = 0

        if NPC!.r.currentOrigin[2] > dest[2] {
            p1 = NPC!.r.currentOrigin
            p2 = dest //NPCInfo->goalEntity->r.currentOrigin
        } else if NPC!.r.currentOrigin[2] < dest[2] {
            p1 = dest //NPCInfo->goalEntity->r.currentOrigin
            p2 = NPC!.r.currentOrigin
        } else {
            p1 = NPC!.r.currentOrigin
            p2 = dest //NPCInfo->goalEntity->r.currentOrigin
        }

        //z = xy*xy
        dir = p2 - p1
        dir[2] = 0

        //Get xy and z diffs
        xy = VectorNormalize(&dir)
        z = p1[2] - p2[2]

        apexHeight = APEX_HEIGHT / 2

        //Determine most desirable apex height
        //FIXME: length of xy will change curve of parabola, need to account for this
        //somewhere... PARA_WIDTH
        /*
        apexHeight = (APEX_HEIGHT * PARA_WIDTH/xy) + (APEX_HEIGHT * z/128);
        if ( apexHeight < APEX_HEIGHT * 0.5 )
        {
        apexHeight = APEX_HEIGHT*0.5;
        }
        else if ( apexHeight > APEX_HEIGHT * 2 )
        {
        apexHeight = APEX_HEIGHT*2;
        }
        */

        z = (sqrt(apexHeight + z) - sqrt(apexHeight))


        //		Com_Printf("apex is %4.2f percent from p1: ", (xy-z)*0.5/xy*100.0f);

        xy -= z
        xy = Float(Double(xy) * 0.5)


        _VectorMA(p1, xy, dir, &apex)
        apex[2] += apexHeight

        NPC!.pos1 = apex

        //Now we have the apex, aim for it
        height = apex[2] - NPC!.r.currentOrigin[2]
        time = Float(sqrt(Double(height) / (0.5 * Double(NPC!.client!.ps.gravity)))) //was 0.5, but didn't work well for very long jumps
        if time == 0 {
            //Com_Printf( S_COLOR_RED"ERROR: no time in jump\n" );
            return false
        }

        NPC!.client!.ps.velocity = apex - NPC!.r.currentOrigin
        NPC!.client!.ps.velocity[2] = 0
        dist = VectorNormalize(&NPC!.client!.ps.velocity)

        forward = Float(Double(dist / time) * 1.25) //er... probably bad, but...
        NPC!.client!.ps.velocity = NPC!.client!.ps.velocity * forward

        //FIXME:  Uh.... should we trace/EvaluateTrajectory this to make sure we have clearance and we land where we want?
        NPC!.client!.ps.velocity[2] = time * NPC!.client!.ps.gravity

        //Com_Printf("Jump Velocity: %4.2f, %4.2f, %4.2f\n", NPC->client->ps.velocity[0], NPC->client->ps.velocity[1], NPC->client->ps.velocity[2] );
    }
    return true
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4719
private func Jedi_TryJump(_ goal: Entity) -> Bool {
    //FIXME: never does a simple short, regular jump...
    //FIXME: I need to be on ground too!
    if (NPCInfo!.scriptFlags & SCF_NO_ACROBATICS) != 0 {
        return false
    }
    if TIMER_Done(NPC!, "jumpChaseDebounce") {
        if (goal.client == nil || goal.client!.ps.groundEntityNum != ENTITYNUM_NONE) {
            if !PM_InKnockDown(NPC!.client!.ps) && !BG_InRoll(NPC!.client!.ps, NPC!.client!.ps.legsAnim) {
                //enemy is on terra firma
                var goal_diff = vec3_t()
                var goal_z_diff: Float = 0
                var goal_xy_dist: Float = 0
                goal_diff = goal.r.currentOrigin - NPC!.r.currentOrigin
                goal_z_diff = goal_diff[2]
                goal_diff[2] = 0
                goal_xy_dist = VectorNormalize(&goal_diff)
                if goal_xy_dist < 550 && goal_z_diff > -400 {
                    var debounce: Bool = false
                    if NPC!.health < 150 && ((NPC!.health < 30 && goal_z_diff < 0) || goal_z_diff < -128) {
                        //don't jump, just walk off... doesn't help with ledges, though
                        debounce = true
                    } else if goal_z_diff < 32 && goal_xy_dist < 200 {
                        //what is their ideal jump height?
                        ucmd.upmove = 127
                        debounce = true
                    } else {
                        /*
                        //NO!  All Jedi can jump-navigate now...
                        if ( NPCInfo->rank != RANK_CREWMAN && NPCInfo->rank <= RANK_LT_JG )
                        {//can't do acrobatics
                        return qfalse;
                        }
                        */
                        if goal_z_diff > 0 || goal_xy_dist > 128 {
                            //Fake a force-jump
                            //Screw it, just do my own calc & throw
                            var dest = vec3_t()
                            dest = goal.r.currentOrigin
                            if goal == NPC!.enemy {
                                var sideTry: Int32 = 0
                                // Port-note: Raven's block leaves a loop outside the record's scope, and the closure cannot.
                                // Raven wrote: while( sideTry < 10 ) {//FIXME: make it so it doesn't try the same spot again? trace_t trace; vec3_t bottom; if ( Q_irand( 0, 1 ) ) { dest[0] += NPC->enemy->r.maxs[0]*1.25; } else { dest[0] += NPC->enemy->r.mins[0]*1.25; } if ( Q_irand( 0, 1 ) ) { dest[1] += NPC->enemy->r.maxs[1]*1.25; } else { dest[1] += NPC->enemy->r.mins[1]*1.25; } VectorCopy( dest, bottom ); bottom[2] -= 128; trap_Trace( &trace, dest, NPC->r.mins, NPC->r.maxs, bottom, goal->s.number, NPC->clipmask ); if ( trace.fraction < 1.0f ) {//hit floor, okay to land here break; } sideTry++; }
                                portMissing("Jedi_TryJump", source: "oracle/codemp/game/NPC_AI_Jedi.c:4719")
                                if sideTry >= 10 {
                                    //screw it, just jump right at him?
                                    dest = goal.r.currentOrigin
                                }
                            }
                            if Jedi_Jump(dest, goal.s.number) {
                                //Com_Printf( "(%d) pre-checked force jump\n", level.time );

                                //FIXME: store the dir we;re going in in case something gets in the way of the jump?
                                //? = vectoyaw( NPC->client->ps.velocity );
                                /*
                                if ( NPC->client->ps.velocity[2] < 320 )
                                {
                                NPC->client->ps.velocity[2] = 320;
                                }
                                else
                                */
                                do {
                                    //FIXME: make this a function call
                                    var jumpAnim: Int32 = 0
                                    //FIXME: this should be more intelligent, like the normal force jump anim logic
                                    if NPC!.client!.NPC_class == CLASS_BOBAFETT || (NPCInfo!.rank != RANK_CREWMAN && NPCInfo!.rank <= RANK_LT_JG) {
                                        //can't do acrobatics
                                        jumpAnim = BOTH_FORCEJUMP1
                                    } else {
                                        jumpAnim = BOTH_FLIP_F
                                    }
                                    NPC_SetAnim(NPC!, SETANIM_BOTH, jumpAnim, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
                                }

                                NPC!.client!.ps.fd.forceJumpZStart = NPC!.r.currentOrigin[2]
                                //NPC->client->ps.pm_flags |= PMF_JUMPING;

                                NPC!.client!.ps.weaponTime = NPC!.client!.ps.torsoTimer
                                NPC!.client!.ps.fd.forcePowersActive |= (1 << FP_LEVITATION)
                                if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                                    G_SoundOnEnt(NPC!, CHAN_ITEM, "sound/boba/jeton.wav")
                                    NPC!.client!.jetPackTime = level.time + Q_irand(1000, 3000)
                                } else {
                                    G_SoundOnEnt(NPC!, CHAN_BODY, "sound/weapons/force/jump.wav")
                                }

                                TIMER_Set(NPC!, "forceJumpChasing", Q_irand(2000, 3000))
                                debounce = true
                            }
                        }
                    }
                    if debounce {
                        //Don't jump again for another 2 to 5 seconds
                        TIMER_Set(NPC!, "jumpChaseDebounce", Q_irand(2000, 5000))
                        ucmd.forwardmove = 127
                        NPC!.client!.ps.moveDir = vec3_t()
                        TIMER_Set(NPC!, "duck", -level.time)
                        return true
                    }
                }
            }
        }
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4867
private func Jedi_Jumping(_ goal: Entity) -> Bool {
    if !TIMER_Done(NPC!, "forceJumpChasing") {
        //force-jumping at the enemy
        //		if ( !(NPC->client->ps.pm_flags & PMF_JUMPING )//forceJumpZStart )
        //			&& !(NPC->client->ps.pm_flags&PMF_TRIGGER_PUSHED))
        if NPC!.client!.ps.groundEntityNum != ENTITYNUM_NONE {
            //landed
            TIMER_Set(NPC!, "forceJumpChasing", 0)
        } else {
            NPC_FaceEntity(goal, true)
            //FIXME: push me torward where I was heading
            //FIXME: if hit a ledge as soon as we jumped, we need to push toward our goal... must remember original jump dir and/or original jump dest
            /*
            vec3_t	viewangles_xy={0,0,0}, goal_dir, goal_xy_dir, forward, right;
            float	goal_dist;

            //gert horz dir to goal
            VectorSubtract( goal->r.currentOrigin, NPC->r.currentOrigin, goal_dir );
            VectorCopy( goal_dir, goal_xy_dir );
            goal_dist = VectorNormalize( goal_dir );
            goal_xy_dir[2] = 0;
            VectorNormalize( goal_xy_dir );

            //get horz facing
            viewangles_xy[1] = NPC->client->ps.viewangles[1];
            AngleVectors( viewangles_xy, forward, right, NULL );

            //get movement commands to push me toward enemy
            float fDot = DotProduct( forward, goal_dir ) * 127;
            float rDot = DotProduct( right, goal_dir ) * 127;

            ucmd.forwardmove = floor(fDot);
            ucmd.rightmove = floor(rDot);
            ucmd.upmove = 0;//don't duck
            //Cheat:
            if ( goal_dist < 128 && goal->r.currentOrigin[2] > NPC->r.currentOrigin[2] && NPC->client->ps.velocity[2] <= 0 )
            {
            NPC->client->ps.velocity[2] += 320;
            }
            */
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:4917
private func Jedi_CheckEnemyMovement(_ enemy_dist: Float) {
    if NPC!.enemy == nil || NPC!.enemy!.client == nil {
        return
    }

    if NPC!.client!.NPC_class != CLASS_TAVION && NPC!.client!.NPC_class != CLASS_DESANN && NPC!.client!.NPC_class != CLASS_LUKE && Q_stricmp("Yoda", NPC!.NPC_type!) != 0 {
        if NPC!.enemy!.enemy != nil && NPC!.enemy!.enemy == NPC {
            //enemy is mad at *me*
            if NPC!.enemy!.client!.ps.legsAnim == BOTH_JUMPFLIPSLASHDOWN1 || NPC!.enemy!.client!.ps.legsAnim == BOTH_JUMPFLIPSTABDOWN {
                //enemy is flipping over me
                if Q_irand(0, NPCInfo!.rank) < RANK_LT {
                    //be nice and stand still for him...
                    ucmd.upmove = 0
                    ucmd.rightmove = ucmd.upmove
                    ucmd.forwardmove = ucmd.rightmove
                    NPC!.client!.ps.moveDir = vec3_t()
                    NPC!.client!.ps.fd.forceJumpCharge = 0
                    TIMER_Set(NPC!, "strafeLeft", -1)
                    TIMER_Set(NPC!, "strafeRight", -1)
                    TIMER_Set(NPC!, "noStrafe", Q_irand(500, 1000))
                    TIMER_Set(NPC!, "movenone", Q_irand(500, 1000))
                    TIMER_Set(NPC!, "movecenter", Q_irand(500, 1000))
                }
            } else if NPC!.enemy!.client!.ps.legsAnim == BOTH_WALL_FLIP_BACK1 || NPC!.enemy!.client!.ps.legsAnim == BOTH_WALL_FLIP_RIGHT || NPC!.enemy!.client!.ps.legsAnim == BOTH_WALL_FLIP_LEFT || NPC!.enemy!.client!.ps.legsAnim == BOTH_WALL_RUN_LEFT_FLIP || NPC!.enemy!.client!.ps.legsAnim == BOTH_WALL_RUN_RIGHT_FLIP {
                //he's flipping off a wall
                if NPC!.enemy!.client!.ps.groundEntityNum == ENTITYNUM_NONE {
                    //still in air
                    if enemy_dist < 256 {
                        //close
                        if Q_irand(0, NPCInfo!.rank) < RANK_LT {
                            //be nice and stand still for him...
                            var enemyFwd = vec3_t()
                            var dest = vec3_t()
                            var dir = vec3_t()

                            /*
                            ucmd.forwardmove = ucmd.rightmove = ucmd.upmove = 0;
                            VectorClear( NPC->client->ps.moveDir );
                            NPC->client->ps.fd.forceJumpCharge = 0;
                            TIMER_Set( NPC, "strafeLeft", -1 );
                            TIMER_Set( NPC, "strafeRight", -1 );
                            TIMER_Set( NPC, "noStrafe", Q_irand( 500, 1000 ) );
                            TIMER_Set( NPC, "movenone", Q_irand( 500, 1000 ) );
                            TIMER_Set( NPC, "movecenter", Q_irand( 500, 1000 ) );
                            TIMER_Set( NPC, "noturn", Q_irand( 200, 500 ) );
                            */
                            //stop current movement
                            ucmd.upmove = 0
                            ucmd.rightmove = ucmd.upmove
                            ucmd.forwardmove = ucmd.rightmove
                            NPC!.client!.ps.moveDir = vec3_t()
                            NPC!.client!.ps.fd.forceJumpCharge = 0
                            TIMER_Set(NPC!, "strafeLeft", -1)
                            TIMER_Set(NPC!, "strafeRight", -1)
                            TIMER_Set(NPC!, "noStrafe", Q_irand(500, 1000))
                            TIMER_Set(NPC!, "noturn", Q_irand(250, 500) * (3 - g_spskill.integer))

                            enemyFwd = NPC!.enemy!.client!.ps.velocity
                            VectorNormalize(&enemyFwd)
                            _VectorMA(NPC!.enemy!.r.currentOrigin, -64, enemyFwd, &dest)
                            dir = dest - NPC!.r.currentOrigin
                            if VectorNormalize(&dir) > 32 {
                                G_UcmdMoveForDir(NPC!, ucmd, &dir)
                            } else {
                                TIMER_Set(NPC!, "movenone", Q_irand(500, 1000))
                                TIMER_Set(NPC!, "movecenter", Q_irand(500, 1000))
                            }
                        }
                    }
                }
            } else if NPC!.enemy!.client!.ps.legsAnim == BOTH_A2_STABBACK1 {
                //he's stabbing backwards
                if enemy_dist < 256 && enemy_dist > 64 {
                    //close
                    if !InFront(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin, NPC!.enemy!.r.currentAngles, 0.0) {
                        //behind him
                        if Q_irand(0, NPCInfo!.rank) == 0 {
                            //be nice and stand still for him...
                            var enemyFwd = vec3_t()
                            var dest = vec3_t()
                            var dir = vec3_t()

                            //stop current movement
                            ucmd.upmove = 0
                            ucmd.rightmove = ucmd.upmove
                            ucmd.forwardmove = ucmd.rightmove
                            NPC!.client!.ps.moveDir = vec3_t()
                            NPC!.client!.ps.fd.forceJumpCharge = 0
                            TIMER_Set(NPC!, "strafeLeft", -1)
                            TIMER_Set(NPC!, "strafeRight", -1)
                            TIMER_Set(NPC!, "noStrafe", Q_irand(500, 1000))

                            // Port-note: Raven passes NULL for the `right` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                            portMissing("Jedi_CheckEnemyMovement", source: "oracle/codemp/game/NPC_AI_Jedi.c:4917")
                            var scratchRight = vec3_t()
                            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
                            portMissing("Jedi_CheckEnemyMovement", source: "oracle/codemp/game/NPC_AI_Jedi.c:4917")
                            var scratchUp = vec3_t()
                            AngleVectors(NPC!.enemy!.r.currentAngles, &enemyFwd, &scratchRight, &scratchUp)
                            _VectorMA(NPC!.enemy!.r.currentOrigin, -32, enemyFwd, &dest)
                            dir = dest - NPC!.r.currentOrigin
                            if VectorNormalize(&dir) > 64 {
                                G_UcmdMoveForDir(NPC!, ucmd, &dir)
                            } else {
                                TIMER_Set(NPC!, "movenone", Q_irand(500, 1000))
                                TIMER_Set(NPC!, "movecenter", Q_irand(500, 1000))
                            }
                        }
                    }
                }
            }
        }
    }
    //FIXME: also:
    //		If enemy doing wall flip, keep running forward
    //		If enemy doing back-attack and we're behind him keep running forward toward his back, don't strafe
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5038
private func Jedi_CheckJumps() {
    var jumpVel = vec3_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Trace.scratch { trace -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = Trajectory.scratch { tr -> Bool in
            var lastPos = vec3_t()
            var testPos = vec3_t()
            var bottom = vec3_t()
            var elapsedTime: Int32 = 0

            jump_unsafe: do {
                if (NPCInfo!.scriptFlags & SCF_NO_ACROBATICS) != 0 {
                    NPC!.client!.ps.fd.forceJumpCharge = 0
                    ucmd.upmove = 0
                    return true
                }
                //FIXME: should probably check this before AI decides that best move is to jump?  Otherwise, they may end up just standing there and looking dumb
                //FIXME: all this work and he still jumps off ledges... *sigh*... need CONTENTS_BOTCLIP do-not-enter brushes...?
                jumpVel = vec3_t()

                if NPC!.client!.ps.fd.forceJumpCharge != 0 {
                    //Com_Printf( "(%d) force jump\n", level.time );
                    WP_GetVelocityForForceJump(NPC!, &jumpVel, ucmd)
                } else if ucmd.upmove > 0 {
                    //Com_Printf( "(%d) regular jump\n", level.time );
                    jumpVel = NPC!.client!.ps.velocity
                    jumpVel[2] = Float(JUMP_VELOCITY)
                } else {
                    return true
                }

                //NOTE: for now, we clear ucmd.forwardmove & ucmd.rightmove while in air to avoid jumps going awry...
                if jumpVel[0] == 0 && jumpVel[1] == 0 {
                    //we assume a jump straight up is safe
                    //Com_Printf( "(%d) jump straight up is safe\n", level.time );
                    return true
                }
                //Now predict where this is going
                //in steps, keep evaluating the trajectory until the new z pos is <= than current z pos, trace down from there

                tr.trBase = NPC!.r.currentOrigin
                tr.trDelta = jumpVel
                tr.trType = TR_GRAVITY
                tr.trTime = level.time
                lastPos = NPC!.r.currentOrigin

                trace.endpos = vec3_t() //shut the compiler up

                //This may be kind of wasteful, especially on long throws... use larger steps?  Divide the travelTime into a certain hard number of slices?  Trace just to apex and down?
                elapsedTime = 500
                while elapsedTime <= 4000 {
                    BG_EvaluateTrajectory(tr, level.time + elapsedTime, &testPos)
                    //FIXME: account for PM_AirMove if ucmd.forwardmove and/or ucmd.rightmove is non-zero...
                    if testPos[2] < lastPos[2] {
                        //going down, don't check for BOTCLIP
                        trap_Trace(trace, lastPos, NPC!.r.mins, NPC!.r.maxs, testPos, NPC!.s.number, NPC!.clipmask) //FIXME: include CONTENTS_BOTCLIP?
                    } else {
                        //going up, check for BOTCLIP
                        trap_Trace(trace, lastPos, NPC!.r.mins, NPC!.r.maxs, testPos, NPC!.s.number, NPC!.clipmask | CONTENTS_BOTCLIP)
                    }
                    if trace.allsolid != 0 || trace.startsolid != 0 {
                        //WTF?
                        //FIXME: what do we do when we start INSIDE the CONTENTS_BOTCLIP?  Do the trace again without that clipmask?
                        break jump_unsafe
                        return true
                    }
                    if trace.fraction < 1.0 {
                        //hit something
                        if (trace.contents & CONTENTS_BOTCLIP) != 0 {
                            //hit a do-not-enter brush
                            break jump_unsafe
                            return true
                        }
                        //FIXME: trace through func_glass?
                        break
                    }
                    lastPos = testPos
                    elapsedTime += 500
                }
                //okay, reached end of jump, now trace down from here for a floor
                bottom = trace.endpos
                if bottom[2] > NPC!.r.currentOrigin[2] {
                    //only care about dist down from current height or lower
                    bottom[2] = NPC!.r.currentOrigin[2]
                } else if NPC!.r.currentOrigin[2] - bottom[2] > 400 {
                    //whoa, long drop, don't do it!
                    //probably no floor at end of jump, so don't jump
                    break jump_unsafe
                    return true
                }
                bottom[2] -= 128
                trap_Trace(trace, trace.endpos, NPC!.r.mins, NPC!.r.maxs, bottom, NPC!.s.number, NPC!.clipmask)
                if trace.allsolid != 0 || trace.startsolid != 0 || trace.fraction < 1.0 {
                    //hit ground!
                    if trace.entityNum < ENTITYNUM_WORLD {
                        //landed on an ent
                        let groundEnt: Entity? = g_entities[trace.entityNum]
                        if (groundEnt!.r.svFlags & SVF_GLASS_BRUSH) != 0 {
                            //don't land on breakable glass!
                            break jump_unsafe
                            return true
                        }
                    }
                    //Com_Printf( "(%d) jump is safe\n", level.time );
                    return true
                }
            }
            //probably no floor at end of jump, so don't jump
            //Com_Printf( "(%d) unsafe jump cleared\n", level.time );
            NPC!.client!.ps.fd.forceJumpCharge = 0
            ucmd.upmove = 0
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

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5155
private func Jedi_Combat() {
    var enemy_dir = vec3_t()
    var enemy_movedir = vec3_t()
    var enemy_dest = vec3_t()
    var enemy_dist: Float = 0
    var enemy_movespeed: Float = 0
    var enemy_lost: Bool = false

    //See where enemy will be 300 ms from now
    Jedi_SetEnemyInfo(&enemy_dest, &enemy_dir, &enemy_dist, &enemy_movedir, &enemy_movespeed, 300)

    if Jedi_Jumping(NPC!.enemy!) {
        //I'm in the middle of a jump, so just see if I should attack
        Jedi_AttackDecide(Int32(enemy_dist))
        return
    }

    if !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0) || NPC!.client!.ps.fd.forcePowerLevel[FP_GRIP] < FORCE_LEVEL_2 {
        //not gripping
        //If we can't get straight at him
        if !Jedi_ClearPathToSpot(enemy_dest, NPC!.enemy!.s.number) {
            //hunt him down
            //Com_Printf( "No Clear Path\n" );
            if (NPC_ClearLOS4(NPC!.enemy!) || NPCInfo!.enemyLastSeenTime > level.time - 500) && NPC_FaceEnemy(true) {
                //try to jump to him?
                /*
                vec3_t end;
                VectorCopy( NPC->r.currentOrigin, end );
                end[2] += 36;
                trap_Trace( &trace, NPC->r.currentOrigin, NPC->r.mins, NPC->r.maxs, end, NPC->s.number, NPC->clipmask|CONTENTS_BOTCLIP );
                if ( !trace.allsolid && !trace.startsolid && trace.fraction >= 1.0 )
                {
                vec3_t angles, forward;
                VectorCopy( NPC->client->ps.viewangles, angles );
                angles[0] = 0;
                AngleVectors( angles, forward, NULL, NULL );
                VectorMA( end, 64, forward, end );
                trap_Trace( &trace, NPC->r.currentOrigin, NPC->r.mins, NPC->r.maxs, end, NPC->s.number, NPC->clipmask|CONTENTS_BOTCLIP );
                if ( !trace.allsolid && !trace.startsolid )
                {
                if ( trace.fraction >= 1.0 || trace.plane.normal[2] > 0 )
                {
                ucmd.upmove = 127;
                ucmd.forwardmove = 127;
                return;
                }
                }
                }
                */
                //FIXME: about every 1 second calc a velocity,
                //run a loop of traces with evaluate trajectory
                //for gravity with my size, see if it makes it...
                //this will also catch misacalculations that send you off ledges!
                //Com_Printf( "Considering Jump\n" );
                if Jedi_TryJump(NPC!.enemy!) {
                    //FIXME: what about jumping to his enemyLastSeenLocation?
                    return
                }
            }

            //Check for evasion
            if TIMER_Done(NPC!, "parryTime") {
                //finished parrying
                if NPC!.client!.ps.saberBlocked != BLOCKED_ATK_BOUNCE && NPC!.client!.ps.saberBlocked != BLOCKED_PARRY_BROKEN {
                    //wasn't blocked myself
                    NPC!.client!.ps.saberBlocked = BLOCKED_NONE
                }
            }
            if Jedi_Hunt() && !((NPCInfo!.aiFlags & NPCAI_BLOCKED) != 0) {
                //can macro-navigate to him
                if enemy_dist < 384 && Q_irand(0, 10) == 0 && NPCInfo!.blockedSpeechDebounceTime < level.time && jediSpeechDebounceTime[NPC!.client!.playerTeam] < level.time && !NPC_ClearLOS4(NPC!.enemy!) {
                    G_AddVoiceEvent(NPC!, Q_irand(EV_JLOST1, EV_JLOST3), 3000)
                    NPCInfo!.blockedSpeechDebounceTime = level.time + 3000
                    jediSpeechDebounceTime[NPC!.client!.playerTeam] = NPCInfo!.blockedSpeechDebounceTime
                }

                return
            } else {
                //well, try to head for his last seen location
                /*
                else if ( Jedi_Track() )
                {
                return;
                }
                */
                //FIXME: try to find a waypoint that can see enemy, jump from there
                if (NPCInfo!.aiFlags & NPCAI_BLOCKED) != 0 {
                    //try to jump to the blockedDest
                    let tempGoal: Entity? = G_Spawn()
                    G_SetOrigin(tempGoal!, &NPCInfo!.blockedDest)
                    trap_LinkEntity(tempGoal!)
                    if Jedi_TryJump(tempGoal!) {
                        //going to jump to the dest
                        G_FreeEntity(tempGoal!)
                        return
                    }
                    G_FreeEntity(tempGoal!)
                }

                enemy_lost = true
            }
        }
    }
    //else, we can see him or we can't track him at all

    //every few seconds, decide if we should we advance or retreat?
    Jedi_CombatTimersUpdate(Int32(enemy_dist))

    //We call this even if lost enemy to keep him moving and to update the taunting behavior
    //maintain a distance from enemy appropriate for our aggression level
    Jedi_CombatDistance(Int32(enemy_dist))

    //if ( !enemy_lost )
    do {
        //Update our seen enemy position
        if NPC!.enemy!.client == nil || (NPC!.enemy!.client!.ps.groundEntityNum != ENTITYNUM_NONE && NPC!.client!.ps.groundEntityNum != ENTITYNUM_NONE) {
            NPCInfo!.enemyLastSeenLocation = NPC!.enemy!.r.currentOrigin
        }
        NPCInfo!.enemyLastSeenTime = level.time
    }

    //Turn to face the enemy
    if TIMER_Done(NPC!, "noturn") {
        Jedi_FaceEnemy(true)
    }
    NPC_UpdateAngles(true, true)

    //Check for evasion
    if TIMER_Done(NPC!, "parryTime") {
        //finished parrying
        if NPC!.client!.ps.saberBlocked != BLOCKED_ATK_BOUNCE && NPC!.client!.ps.saberBlocked != BLOCKED_PARRY_BROKEN {
            //wasn't blocked myself
            NPC!.client!.ps.saberBlocked = BLOCKED_NONE
        }
    }
    if NPC!.enemy!.s.weapon == WP_SABER {
        Jedi_EvasionSaber(enemy_movedir, enemy_dist, enemy_dir)
    } else {
        //do we need to do any evasion for other kinds of enemies?
    }

    //apply strafing/walking timers, etc.
    Jedi_TimersApply()

    if !NPC!.client!.ps.saberInFlight && (!((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_GRIP)) != 0) || NPC!.client!.ps.fd.forcePowerLevel[FP_GRIP] < FORCE_LEVEL_2) {
        //not throwing saber or using force grip
        //see if we can attack
        if !Jedi_AttackDecide(Int32(enemy_dist)) {
            //we're not attacking, decide what else to do
            Jedi_CombatIdle(Int32(enemy_dist))
            //FIXME: lower aggression when actually strike offensively?  Or just when do damage?
        } else {
            //we are attacking
            //stop taunting
            TIMER_Set(NPC!, "taunting", -level.time)
        }
    } else {
    }
    if NPC!.client!.NPC_class == CLASS_BOBAFETT {
        Boba_FireDecide()
    }

    //Check for certain enemy special moves
    Jedi_CheckEnemyMovement(enemy_dist)
    //Make sure that we don't jump off ledges over long drops
    Jedi_CheckJumps()
    //Just make sure we don't strafe into walls or off cliffs
    if !NPC_MoveDirClear(ucmd.forwardmove, ucmd.rightmove, true) {
        //uh-oh, we are going to fall or hit something
        // Raven's record lives to the end of his block, so the block is the closure.
        NavInfo.scratch { info in
            //Get the move info
            NAV_GetLastMove(info)
            if !((info.flags & NIF_MACRO_NAV) != 0) {
                //micro-navigation told us to step off a ledge, try using macronav for now
                NPC_MoveToGoal(false)
            }
            //reset the timers.
            TIMER_Set(NPC!, "strafeLeft", 0)
            TIMER_Set(NPC!, "strafeRight", 0)
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5358
func NPC_Jedi_Pain(_ `self`: Entity, _ attacker: Entity, _ damage: Int32) {
    let other: Entity? = attacker
    var point = vec3_t()

    point = gPainPoint

    //FIXME: base the actual aggression add/subtract on health?
    //FIXME: don't do this more than once per frame?
    //FIXME: when take pain, stop force gripping....?
    if other!.s.weapon == WP_SABER {
        //back off
        TIMER_Set(`self`, "parryTime", -1)
        if `self`.client!.NPC_class == CLASS_DESANN || Q_stricmp("Yoda", `self`.NPC_type!) == 0 {
            //less for Desann
            `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + (3 - g_spskill.integer) * 50
        } else if `self`.NPC!.rank >= RANK_LT_JG {
            `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + (3 - g_spskill.integer) * 100 //300
        } else {
            `self`.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + (3 - g_spskill.integer) * 200 //500
        }
        if Q_irand(0, 3) == 0 {
            //ouch... maybe switch up which saber power level we're using
            Jedi_AdjustSaberAnimLevel(`self`, Q_irand(FORCE_LEVEL_1, FORCE_LEVEL_3))
        }
        if Q_irand(0, 1) == 0 {
            //Com_Printf( "(%d) drop agg - hit by saber\n", level.time );
            Jedi_Aggression(`self`, -1)
        }
        if d_JediAI.integer != 0 {
            Com_Printf("(%d) PAIN: agg %d, no parry until %d\n", level.time, `self`.NPC!.stats.aggression, level.time + 500)
        }
        //for testing only
        // Figure out what quadrant the hit was in.
        if d_JediAI.integer != 0 {
            var diff = vec3_t()
            var fwdangles = vec3_t()
            var right = vec3_t()
            let rightdot: Float
            let zdiff: Float

            diff = point - `self`.client!.renderInfo.eyePoint
            diff[2] = 0
            fwdangles[1] = `self`.client!.ps.viewangles[1]
            // Port-note: Raven passes NULL for the `forward` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("NPC_Jedi_Pain", source: "oracle/codemp/game/NPC_AI_Jedi.c:5358")
            var scratchForward = vec3_t()
            // Port-note: Raven passes NULL for the `up` output. The ported function takes it by reference, so the body passes a scratch local it never reads.
            portMissing("NPC_Jedi_Pain", source: "oracle/codemp/game/NPC_AI_Jedi.c:5358")
            var scratchUp = vec3_t()
            AngleVectors(fwdangles, &scratchForward, &right, &scratchUp)
            rightdot = _DotProduct(right, diff)
            zdiff = point[2] - `self`.client!.renderInfo.eyePoint[2]

            Com_Printf("(%d) saber hit at height %4.2f, zdiff: %4.2f, rightdot: %4.2f\n", level.time, point[2] - `self`.r.absmin[2], zdiff, rightdot)
        }
    } else {
        //attack
        //Com_Printf( "(%d) raise agg - hit by ranged\n", level.time );
        Jedi_Aggression(`self`, 1)
    }

    `self`.NPC!.enemyCheckDebounceTime = 0

    WP_ForcePowerStop(`self`, FP_GRIP)

    //NPC_Pain( self, inflictor, other, point, damage, mod );
    NPC_Pain(`self`, attacker, damage)

    if damage == 0 && `self`.health > 0 {
        //FIXME: better way to know I was pushed
        G_AddVoiceEvent(`self`, Q_irand(EV_PUSHED1, EV_PUSHED3), 2000)
    }

    //drop me from the ceiling if I'm on it
    if Jedi_WaitingAmbush(`self`) {
        `self`.client!.noclip = false
    }
    if `self`.client!.ps.legsAnim == BOTH_CEILING_CLING {
        NPC_SetAnim(`self`, SETANIM_LEGS, BOTH_CEILING_DROP, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    }
    if `self`.client!.ps.torsoAnim == BOTH_CEILING_CLING {
        NPC_SetAnim(`self`, SETANIM_TORSO, BOTH_CEILING_DROP, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5446
func Jedi_CheckDanger() -> Bool {
    let alertEvent: Int32 = NPC_CheckAlertEvents(true, true, -1, false, AEL_MINOR)
    if level.alertEvents[alertEvent].level >= AEL_DANGER {
        //run away!
        if level.alertEvents[alertEvent].owner == nil || level.alertEvents[alertEvent].owner!.client == nil || (level.alertEvents[alertEvent].owner != NPC && level.alertEvents[alertEvent].owner!.client!.playerTeam != NPC!.client!.playerTeam) {
            //no owner
            return false
        }
        G_SetEnemy(NPC!, level.alertEvents[alertEvent].owner!)
        NPCInfo!.enemyLastSeenTime = level.time
        TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5465
func Jedi_CheckAmbushPlayer() -> Bool {
    var i: Int32 = 0
    var player: Entity?
    var target_dist: Float
    var zDiff: Float

    i = 0
    while i < MAX_CLIENTS {
        player = g_entities[i]

        if player == nil || player!.client == nil {
            i += 1
            continue
        }

        if !NPC_ValidEnemy(player!) {
            i += 1
            continue
        }

        //		if ( NPC->client->ps.powerups[PW_CLOAKED] || g_crosshairEntNum != NPC->s.number )
        if NPC!.client!.ps.powerups[PW_CLOAKED] != 0 || !NPC_SomeoneLookingAtMe(NPC!) {
            //if I'm not cloaked and the player's crosshair is on me, I will wake up, otherwise do this stuff down here...
            if !trap_InPVS(player!.r.currentOrigin, NPC!.r.currentOrigin) {
                //must be in same room
                i += 1
                continue
            } else {
                if NPC!.client!.ps.powerups[PW_CLOAKED] == 0 {
                    NPC_SetLookTarget(NPC!, 0, 0)
                }
            }
            zDiff = NPC!.r.currentOrigin[2] - player!.r.currentOrigin[2]
            if zDiff <= 0 || zDiff > 512 {
                //never ambush if they're above me or way way below me
                i += 1
                continue
            }

            //If the target is this close, then wake up regardless
            // Port-note: An assignment inside an expression.
            // Raven wrote: if ( (target_dist = DistanceHorizontalSquared( player->r.currentOrigin, NPC->r.currentOrigin )) > 4096 ) {//closer than 64 - always ambush if ( target_dist > 147456 ) {//> 384, not close enough to ambush continue; } //Check FOV first if ( NPC->client->ps.powerups[PW_CLOAKED] ) { if ( InFOV( player, NPC, 30, 90 ) == qfalse ) { continue; } } else { if ( InFOV( player, NPC, 45, 90 ) == qfalse ) { continue; } } }
            portMissing("Jedi_CheckAmbushPlayer", source: "oracle/codemp/game/NPC_AI_Jedi.c:5465")

            if !NPC_ClearLOS4(player!) {
                i += 1
                continue
            }
        }

        //Got him, return true;
        G_SetEnemy(NPC!, player!)
        NPCInfo!.enemyLastSeenTime = level.time
        TIMER_Set(NPC!, "attackDelay", Q_irand(500, 2500))
        return true
        i += 1
    }

    //Didn't get anyone.
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5547
func Jedi_Ambush(_ `self`: Entity) {
    `self`.client!.noclip = false
    //	self->client->ps.pm_flags |= PMF_JUMPING|PMF_SLOW_MO_FALL;
    NPC_SetAnim(`self`, SETANIM_BOTH, BOTH_CEILING_DROP, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
    `self`.client!.ps.weaponTime = `self`.client!.ps.torsoTimer //NPC->client->ps.torsoTimer; //what the?
    if `self`.client!.NPC_class != CLASS_BOBAFETT {
        WP_ActivateSaber(`self`)
    }
    Jedi_Decloak(`self`)
    G_AddVoiceEvent(`self`, Q_irand(EV_ANGER1, EV_ANGER3), 1000)
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5561
func Jedi_WaitingAmbush(_ `self`: Entity) -> Bool {
    if (`self`.spawnflags & JSF_AMBUSH) != 0 && `self`.client!.noclip {
        return true
    }
    return false
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5575
private func Jedi_Patrol() {
    finish: do {
        NPC!.client!.ps.saberBlocked = BLOCKED_NONE

        if Jedi_WaitingAmbush(NPC!) {
            //hiding on the ceiling
            NPC_SetAnim(NPC!, SETANIM_BOTH, BOTH_CEILING_CLING, SETANIM_FLAG_OVERRIDE | SETANIM_FLAG_HOLD)
            if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
                //look for enemies
                if Jedi_CheckAmbushPlayer() || Jedi_CheckDanger() {
                    //found him!
                    Jedi_Ambush(NPC!)
                    NPC_UpdateAngles(true, true)
                    return
                }
            }
        } else if (NPCInfo!.scriptFlags & SCF_LOOK_FOR_ENEMIES) != 0 {
            //look for enemies
            var best_enemy: Entity? = nil
            var best_enemy_dist: Float = Float(Q3_INFINITE)
            var i: Int32
            i = 0
            while i < ENTITYNUM_WORLD {
                let enemy: Entity? = g_entities[i]
                var enemy_dist: Float
                if enemy != nil && enemy!.client != nil && NPC_ValidEnemy(enemy!) && enemy!.client!.playerTeam == NPC!.client!.enemyTeam {
                    if trap_InPVS(NPC!.r.currentOrigin, enemy!.r.currentOrigin) {
                        //we could potentially see him
                        enemy_dist = DistanceSquared(NPC!.r.currentOrigin, enemy!.r.currentOrigin)
                        if enemy!.s.eType == ET_PLAYER || enemy_dist < best_enemy_dist {
                            //if the enemy is close enough, or threw his saber, take him as the enemy
                            //FIXME: what if he throws a thermal detonator?
                            if enemy_dist < (220 * 220) || (NPCInfo!.investigateCount >= 3 && NPC!.client!.ps.saberHolstered == 0) {
                                G_SetEnemy(NPC!, enemy!)
                                //NPCInfo->behaviorState = BS_HUNT_AND_KILL;//should be auto now
                                NPCInfo!.stats.aggression = 3
                                break
                            } else if enemy!.client!.ps.saberInFlight && enemy!.client!.ps.saberHolstered == 0 {
                                //threw his saber, see if it's heading toward me and close enough to consider a threat
                                var saberDist: Float
                                var saberDir2Me = vec3_t()
                                var saberMoveDir = vec3_t()
                                let saber: Entity? = g_entities[enemy!.client!.ps.saberEntityNum]
                                saberDir2Me = NPC!.r.currentOrigin - saber!.r.currentOrigin
                                saberDist = VectorNormalize(&saberDir2Me)
                                saberMoveDir = saber!.s.pos.trDelta
                                VectorNormalize(&saberMoveDir)
                                if Double(_DotProduct(saberMoveDir, saberDir2Me)) > 0.5 {
                                    //it's heading towards me
                                    if saberDist < 200 {
                                        //incoming!
                                        G_SetEnemy(NPC!, enemy!)
                                        //NPCInfo->behaviorState = BS_HUNT_AND_KILL;//should be auto now
                                        NPCInfo!.stats.aggression = 3
                                        break
                                    }
                                }
                            }
                            best_enemy_dist = enemy_dist
                            best_enemy = enemy
                        }
                    }
                }
                i += 1
            }
            if NPC!.enemy == nil {
                //still not mad
                if best_enemy == nil {
                    //Com_Printf( "(%d) drop agg - no enemy (patrol)\n", level.time );
                    Jedi_AggressionErosion(-1)
                    //FIXME: what about alerts?  But not if ignore alerts
                } else {
                    //have one to consider
                    if NPC_ClearLOS4(best_enemy!) {
                        //we have a clear (of architecture) LOS to him
                        if best_enemy!.s.number != 0 {
                            //just attack
                            G_SetEnemy(NPC!, best_enemy!)
                            NPCInfo!.stats.aggression = 3
                        } else if NPC!.client!.NPC_class != CLASS_BOBAFETT {
                            //the player, toy with him
                            //get progressively more interested over time
                            if TIMER_Done(NPC!, "watchTime") {
                                //we want to pick him up in stages
                                if TIMER_Get(NPC!, "watchTime") == -1 {
                                    //this is the first time, we'll ignore him for a couple seconds
                                    TIMER_Set(NPC!, "watchTime", Q_irand(3000, 5000))
                                    break finish
                                } else {
                                    //okay, we've ignored him, now start to notice him
                                    if NPCInfo!.investigateCount == 0 {
                                        G_AddVoiceEvent(NPC!, Q_irand(EV_JDETECTED1, EV_JDETECTED3), 3000)
                                    }
                                    NPCInfo!.investigateCount += 1
                                    TIMER_Set(NPC!, "watchTime", Q_irand(4000, 10000))
                                }
                            }
                            //while we're waiting, do what we need to do
                            if best_enemy_dist < (440 * 440) || NPCInfo!.investigateCount >= 2 {
                                //stage three: keep facing him
                                NPC_FaceEntity(best_enemy!, true)
                                if best_enemy_dist < (330 * 330) {
                                    //stage four: turn on the saber
                                    if !NPC!.client!.ps.saberInFlight {
                                        WP_ActivateSaber(NPC!)
                                    }
                                }
                            } else if best_enemy_dist < (550 * 550) || NPCInfo!.investigateCount == 1 {
                                //stage two: stop and face him every now and then
                                if TIMER_Done(NPC!, "watchTime") {
                                    NPC_FaceEntity(best_enemy!, true)
                                }
                            } else {
                                //stage one: look at him.
                                NPC_SetLookTarget(NPC!, best_enemy!.s.number, 0)
                            }
                        }
                    } else if TIMER_Done(NPC!, "watchTime") {
                        //haven't seen him in a bit, clear the lookTarget
                        NPC_ClearLookTarget(NPC!)
                    }
                }
            }
        }
    }
    //If we have somewhere to go, then do that
    if UpdateGoal() != nil {
        ucmd.buttons |= BUTTON_WALKING
        //Jedi_Move( NPCInfo->goalEntity );
        NPC_MoveToGoal(true)
    }

    NPC_UpdateAngles(true, true)

    if NPC!.enemy != nil {
        //just picked one up
        NPCInfo!.enemyCheckDebounceTime = level.time + Q_irand(3000, 10000)
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5730
func Jedi_CanPullBackSaber(_ `self`: Entity) -> Bool {
    if `self`.client!.ps.saberBlocked == BLOCKED_PARRY_BROKEN && !TIMER_Done(`self`, "parryTime") {
        return false
    }

    if `self`.client!.NPC_class == CLASS_SHADOWTROOPER || `self`.client!.NPC_class == CLASS_TAVION || `self`.client!.NPC_class == CLASS_LUKE || `self`.client!.NPC_class == CLASS_DESANN || Q_stricmp("Yoda", `self`.NPC_type!) == 0 {
        return true
    }

    if `self`.painDebounceTime > level.time {
        return false
    }

    return true
}

/**
```
-------------------------
NPC_BSJedi_FollowLeader
-------------------------
```
*/
/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5758
func NPC_BSJedi_FollowLeader() {
    NPC!.client!.ps.saberBlocked = BLOCKED_NONE
    if NPC!.enemy == nil {
        //Com_Printf( "(%d) drop agg - no enemy (follow)\n", level.time );
        Jedi_AggressionErosion(-1)
    }

    //did we drop our saber?  If so, go after it!
    if NPC!.client!.ps.saberInFlight {
        //saber is not in hand
        if NPC!.client!.ps.saberEntityNum < ENTITYNUM_NONE && NPC!.client!.ps.saberEntityNum > 0 {
            //
            if g_entities[NPC!.client!.ps.saberEntityNum].s.pos.trType == TR_STATIONARY {
                //fell to the ground, try to pick it up...
                if Jedi_CanPullBackSaber(NPC!) {
                    //FIXME: if it's on the ground and we just pulled it back to us, should we
                    //		stand still for a bit to make sure it gets to us...?
                    //		otherwise we could end up running away from it while it's on its
                    //		way back to us and we could lose it again.
                    NPC!.client!.ps.saberBlocked = BLOCKED_NONE
                    NPCInfo!.goalEntity = g_entities[NPC!.client!.ps.saberEntityNum]
                    ucmd.buttons |= BUTTON_ATTACK
                    if NPC!.enemy != nil && NPC!.enemy!.health > 0 {
                        //get our saber back NOW!
                        if !NPC_MoveToGoal(true) {
                            //can't nav to it, try jumping to it
                            NPC_FaceEntity(NPCInfo!.goalEntity!, true)
                            Jedi_TryJump(NPCInfo!.goalEntity!)
                        }
                        NPC_UpdateAngles(true, true)
                        return
                    }
                }
            }
        }
    }

    if NPCInfo!.goalEntity != nil {
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut = Trace.scratch { trace -> Bool in

            if Jedi_Jumping(NPCInfo!.goalEntity!) {
                //in mid-jump
                return true
            }

            if !NAV_CheckAhead(NPC!, NPCInfo!.goalEntity!.r.currentOrigin, trace, (NPC!.clipmask & ~CONTENTS_BODY) | CONTENTS_BOTCLIP) {
                //can't get straight to him
                if NPC_ClearLOS4(NPCInfo!.goalEntity!) && NPC_FaceEntity(NPCInfo!.goalEntity!, true) {
                    //no line of sight
                    if Jedi_TryJump(NPCInfo!.goalEntity!) {
                        //started a jump
                        return true
                    }
                }
            }
            if (NPCInfo!.aiFlags & NPCAI_BLOCKED) != 0 {
                //try to jump to the blockedDest
                if abs(NPCInfo!.blockedDest[2] - NPC!.r.currentOrigin[2]) > 64 {
                    let tempGoal: Entity? = G_Spawn()
                    G_SetOrigin(tempGoal!, &NPCInfo!.blockedDest)
                    trap_LinkEntity(tempGoal!)
                    TIMER_Set(NPC!, "jumpChaseDebounce", -1)
                    if Jedi_TryJump(tempGoal!) {
                        //going to jump to the dest
                        G_FreeEntity(tempGoal!)
                        return true
                    }
                    G_FreeEntity(tempGoal!)
                }
            }
            return false
        }
        if earlyOut {
            return
        }
    }
    //try normal movement
    NPC_BSFollowLeader()
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:5845
private func Jedi_Attack() {
    //Don't do anything if we're in a pain anim
    if NPC!.painDebounceTime > level.time {
        if Q_irand(0, 1) != 0 {
            Jedi_FaceEnemy(true)
        }
        NPC_UpdateAngles(true, true)
        return
    }

    if NPC!.client!.ps.saberLockTime > level.time {
        //FIXME: maybe if I'm losing I should try to force-push out of it?  Very rarely, though...
        if NPC!.client!.ps.fd.forcePowerLevel[FP_PUSH] > FORCE_LEVEL_2 && NPC!.client!.ps.saberLockTime < level.time + 5000 && Q_irand(0, 10) == 0 {
            ForceThrow(NPC!, false)
        } else {
            //based on my skill, hit attack button every other to every several frames in order to push enemy back
            var chance: Float

            if NPC!.client!.NPC_class == CLASS_DESANN || Q_stricmp("Yoda", NPC!.NPC_type!) == 0 {
                if g_spskill.integer != 0 {
                    chance = 4.0 //he pushes *hard*
                } else {
                    chance = 3.0 //he pushes *hard*
                }
            } else if NPC!.client!.NPC_class == CLASS_TAVION {
                chance = 2.0 + g_spskill.value //from 2 to 4
            } else {
                //the escalation in difficulty is nice, here, but cap it so it doesn't get *impossible* on hard
                let maxChance: Float = Float((RANK_LT)) / 2.0 + 3.0
                if g_spskill.value == 0 {
                    chance = Float((NPCInfo!.rank)) / 2.0
                } else {
                    chance = Float((NPCInfo!.rank)) / 2.0 + 1.0
                }
                if chance > maxChance {
                    chance = maxChance
                }
            }
            //	if ( flrand( -4.0f, chance ) >= 0.0f && !(NPC->client->ps.pm_flags&PMF_ATTACK_HELD) )
            //	{
            //		ucmd.buttons |= BUTTON_ATTACK;
            //	}
            if flrand(-4.0, chance) >= 0.0 {
                ucmd.buttons |= BUTTON_ATTACK
            }
            //rwwFIXMEFIXME: support for PMF_ATTACK_HELD
        }
        NPC_UpdateAngles(true, true)
        return
    }
    //did we drop our saber?  If so, go after it!
    if NPC!.client!.ps.saberInFlight {
        //saber is not in hand
        //	if ( NPC->client->ps.saberEntityNum < ENTITYNUM_NONE && NPC->client->ps.saberEntityNum > 0 )//player is 0
        if NPC!.client!.ps.saberEntityNum == 0 && NPC!.client!.saberStoredIndex != 0 {
            //
            //if ( g_entities[NPC->client->ps.saberEntityNum].s.pos.trType == TR_STATIONARY )
            if 1 != 0 {
                //fell to the ground, try to pick it up
                //	if ( Jedi_CanPullBackSaber( NPC ) )
                if 1 != 0 {
                    NPC!.client!.ps.saberBlocked = BLOCKED_NONE
                    NPCInfo!.goalEntity = g_entities[NPC!.client!.saberStoredIndex]
                    ucmd.buttons |= BUTTON_ATTACK
                    if NPC!.enemy != nil && NPC!.enemy!.health > 0 {
                        //get our saber back NOW!
                        Jedi_Move(NPCInfo!.goalEntity!, false)
                        NPC_UpdateAngles(true, true)
                        if NPC!.enemy!.s.weapon == WP_SABER {
                            //be sure to continue evasion
                            var enemy_dir = vec3_t()
                            var enemy_movedir = vec3_t()
                            var enemy_dest = vec3_t()
                            var enemy_dist: Float = 0
                            var enemy_movespeed: Float = 0
                            Jedi_SetEnemyInfo(&enemy_dest, &enemy_dir, &enemy_dist, &enemy_movedir, &enemy_movespeed, 300)
                            Jedi_EvasionSaber(enemy_movedir, enemy_dist, enemy_dir)
                        }
                        return
                    }
                }
            }
        }
    }
    //see if our enemy was killed by us, gloat and turn off saber after cool down.
    //FIXME: don't do this if we have other enemies to fight...?
    if NPC!.enemy != nil {
        if NPC!.enemy!.health <= 0 && NPC!.enemy!.enemy == NPC && NPC!.client!.playerTeam != NPCTEAM_PLAYER {
            //my enemy is dead and I killed him
            NPCInfo!.enemyCheckDebounceTime = 0 //keep looking for others

            if NPC!.client!.NPC_class == CLASS_BOBAFETT {
                if NPCInfo!.walkDebounceTime < level.time && NPCInfo!.walkDebounceTime >= 0 {
                    TIMER_Set(NPC!, "gloatTime", 10000)
                    NPCInfo!.walkDebounceTime = -1
                }
                if !TIMER_Done(NPC!, "gloatTime") {
                    if DistanceHorizontalSquared(NPC!.client!.renderInfo.eyePoint, NPC!.enemy!.r.currentOrigin) > 4096 && (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
                        NPCInfo!.goalEntity = NPC!.enemy
                        Jedi_Move(NPC!.enemy!, false)
                        ucmd.buttons |= BUTTON_WALKING
                    } else {
                        TIMER_Set(NPC!, "gloatTime", 0)
                    }
                } else if NPCInfo!.walkDebounceTime == -1 {
                    NPCInfo!.walkDebounceTime = -2
                    G_AddVoiceEvent(NPC!, Q_irand(EV_VICTORY1, EV_VICTORY3), 3000)
                    jediSpeechDebounceTime[NPC!.client!.playerTeam] = level.time + 3000
                    NPCInfo!.desiredPitch = 0
                    NPCInfo!.goalEntity = nil
                }
                Jedi_FaceEnemy(true)
                NPC_UpdateAngles(true, true)
                return
            } else {
                if !TIMER_Done(NPC!, "parryTime") {
                    TIMER_Set(NPC!, "parryTime", -1)
                    NPC!.client!.ps.fd.forcePowerDebounce[FP_SABER_DEFENSE] = level.time + 500
                }
                NPC!.client!.ps.saberBlocked = BLOCKED_NONE
                if NPC!.client!.ps.saberHolstered == 0 && NPC!.client!.ps.saberInFlight {
                    //saber is still on (or we're trying to pull it back), count down erosion and keep facing the enemy
                    //FIXME: need to stop this from happening over and over again when they're blocking their victim's saber
                    //FIXME: turn off saber sooner so we get cool walk anim?
                    //Com_Printf( "(%d) drop agg - enemy dead\n", level.time );
                    Jedi_AggressionErosion(-3)
                    if BG_SabersOff(NPC!.client!.ps) && !NPC!.client!.ps.saberInFlight {
                        //turned off saber (in hand), gloat
                        G_AddVoiceEvent(NPC!, Q_irand(EV_VICTORY1, EV_VICTORY3), 3000)
                        jediSpeechDebounceTime[NPC!.client!.playerTeam] = level.time + 3000
                        NPCInfo!.desiredPitch = 0
                        NPCInfo!.goalEntity = nil
                    }
                    TIMER_Set(NPC!, "gloatTime", 10000)
                }
                if NPC!.client!.ps.saberHolstered == 0 || NPC!.client!.ps.saberInFlight || !TIMER_Done(NPC!, "gloatTime") {
                    //keep walking
                    if DistanceHorizontalSquared(NPC!.client!.renderInfo.eyePoint, NPC!.enemy!.r.currentOrigin) > 4096 && (NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0 {
                        NPCInfo!.goalEntity = NPC!.enemy
                        Jedi_Move(NPC!.enemy!, false)
                        ucmd.buttons |= BUTTON_WALKING
                    } else {
                        //got there
                        if NPC!.health < NPC!.client!.pers.maxHealth && (NPC!.client!.ps.fd.forcePowersKnown & (1 << FP_HEAL)) != 0 && (NPC!.client!.ps.fd.forcePowersActive & (1 << FP_HEAL)) == 0 {
                            ForceHeal(NPC!)
                        }
                    }
                    Jedi_FaceEnemy(true)
                    NPC_UpdateAngles(true, true)
                    return
                }
            }
        }
    }

    //If we don't have an enemy, just idle
    if NPC!.enemy!.s.weapon == WP_TURRET && Q_stricmp("PAS", NPC!.enemy!.classname!) == 0 {
        if NPC!.enemy!.count <= 0 {
            //it's out of ammo
            if NPC!.enemy!.activator != nil && NPC_ValidEnemy(NPC!.enemy!.activator!) {
                let turretOwner: Entity? = NPC!.enemy!.activator
                G_ClearEnemy(NPC!)
                G_SetEnemy(NPC!, turretOwner!)
            } else {
                G_ClearEnemy(NPC!)
            }
        }
    }
    NPC_CheckEnemy(true, true, true)

    if NPC!.enemy == nil {
        NPC!.client!.ps.saberBlocked = BLOCKED_NONE
        if NPCInfo!.tempBehavior == BS_HUNT_AND_KILL {
            //lost him, go back to what we were doing before
            NPCInfo!.tempBehavior = BS_DEFAULT
            NPC_UpdateAngles(true, true)
            return
        }
        Jedi_Patrol() //was calling Idle... why?
        return
    }

    //always face enemy if have one
    NPCInfo!.combatMove = true

    //Track the player and kill them if possible
    Jedi_Combat()

    if !((NPCInfo!.scriptFlags & SCF_CHASE_ENEMIES) != 0) || ((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_HEAL)) != 0 && NPC!.client!.ps.fd.forcePowerLevel[FP_HEAL] < FORCE_LEVEL_2) {
        //this is really stupid, but okay...
        ucmd.forwardmove = 0
        ucmd.rightmove = 0
        if ucmd.upmove > 0 {
            ucmd.upmove = 0
        }
        NPC!.client!.ps.fd.forceJumpCharge = 0
        NPC!.client!.ps.moveDir = vec3_t()
    }

    //NOTE: for now, we clear ucmd.forwardmove & ucmd.rightmove while in air to avoid jumps going awry...
    if NPC!.client!.ps.groundEntityNum == ENTITYNUM_NONE {
        //don't push while in air, throws off jumps!
        //FIXME: if we are in the air over a drop near a ledge, should we try to push back towards the ledge?
        ucmd.forwardmove = 0
        ucmd.rightmove = 0
        NPC!.client!.ps.moveDir = vec3_t()
    }

    if !TIMER_Done(NPC!, "duck") {
        ucmd.upmove = -127
    }

    if NPC!.client!.NPC_class != CLASS_BOBAFETT {
        if PM_SaberInBrokenParry(NPC!.client!.ps.saberMove) || NPC!.client!.ps.saberBlocked == BLOCKED_PARRY_BROKEN {
            //just make sure they don't pull their saber to them if they're being blocked
            ucmd.buttons &= ~BUTTON_ATTACK
        }
    }

    if (NPCInfo!.scriptFlags & SCF_DONT_FIRE) != 0 || ((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_HEAL)) != 0 && NPC!.client!.ps.fd.forcePowerLevel[FP_HEAL] < FORCE_LEVEL_3) || ((NPC!.client!.ps.saberEventFlags & SEF_INWATER) != 0 && !NPC!.client!.ps.saberInFlight) {
        ucmd.buttons &= ~(BUTTON_ATTACK | BUTTON_ALT_ATTACK)
    }

    if (NPCInfo!.scriptFlags & SCF_NO_ACROBATICS) != 0 {
        ucmd.upmove = 0
        NPC!.client!.ps.fd.forceJumpCharge = 0
    }

    if NPC!.client!.NPC_class != CLASS_BOBAFETT {
        Jedi_CheckDecreaseSaberAnimLevel()
    }

    if (ucmd.buttons & BUTTON_ATTACK) != 0 && NPC!.client!.playerTeam == NPCTEAM_ENEMY {
        if Q_irand(0, NPC!.client!.ps.fd.saberAnimLevel) > 0 && Q_irand(0, NPC!.client!.pers.maxHealth + 10) > NPC!.health && Q_irand(0, 3) == 0 {
            //the more we're hurt and the stronger the attack we're using, the more likely we are to make a anger noise when we swing
            G_AddVoiceEvent(NPC!, Q_irand(EV_COMBAT1, EV_COMBAT3), 1000)
        }
    }

    if NPC!.client!.NPC_class != CLASS_BOBAFETT {
        if NPC!.client!.NPC_class == CLASS_TAVION || (g_spskill.integer != 0 && (NPC!.client!.NPC_class == CLASS_DESANN || NPCInfo!.rank >= Q_irand(RANK_CREWMAN, RANK_CAPTAIN))) {
            //Tavion will kick in force speed if the player does...
            if NPC!.enemy != nil && NPC!.enemy!.s.number == 0 && NPC!.enemy!.client != nil && (NPC!.enemy!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0 && !((NPC!.client!.ps.fd.forcePowersActive & (1 << FP_SPEED)) != 0) {
                var chance: Int32 = 0
                switch g_spskill.integer {
                case 0:
                    chance = 9
                    fallthrough

                case 1:
                    chance = 3
                    fallthrough

                case 2:
                    chance = 1

                default:
                    break
                }
                if Q_irand(0, chance) == 0 {
                    ForceSpeed(NPC!, 0)
                }
            }
        }
    }
}

/// Source: oracle/codemp/game/NPC_AI_Jedi.c:6170
func NPC_BSJedi_Default() {
    Jedi_CheckCloak()
    if NPC!.enemy == nil {
        //don't have an enemy, look for one
        if NPC!.client!.NPC_class == CLASS_BOBAFETT {
            NPC_BSST_Patrol()
        } else {
            Jedi_Patrol()
        }
    } else {
        //have an enemy
        if Jedi_WaitingAmbush(NPC!) {
            //we were still waiting to drop down - must have had enemy set on me outside my AI
            Jedi_Ambush(NPC!)
        }
        if NPC!.client!.NPC_class == CLASS_BOBAFETT {
            if NPC!.enemy!.enemy != NPC && NPC!.health == NPC!.client!.pers.maxHealth && DistanceSquared(NPC!.r.currentOrigin, NPC!.enemy!.r.currentOrigin) > (800 * 800) {
                NPCInfo!.scriptFlags |= SCF_ALT_FIRE
                Boba_ChangeWeapon(WP_DISRUPTOR)
                NPC_BSSniper_Default()
                return
            }
        }
        Jedi_Attack()
        //if we have multiple-jedi combat, probably need to keep checking (at certain debounce intervals) for a better (closer, more active) enemy and switch if needbe...
        if ((ucmd.buttons == 0 && NPC!.client!.ps.fd.forcePowersActive == 0) || (NPC!.enemy != nil && NPC!.enemy!.health <= 0)) && NPCInfo!.enemyCheckDebounceTime < level.time {
            //not doing anything (or walking toward a vanquished enemy - fixme: always taunt the player?), not using force powers and it's time to look again
            //FIXME: build a list of all local enemies (since we have to find best anyway) for other AI factors- like when to use group attacks, determine when to change tactics, when surrounded, when blocked by another in the enemy group, etc.  Should we build this group list or let the enemies maintain their own list and we just access it?
            let sav_enemy: Entity? = NPC!.enemy
            var newEnemy: Entity?

            NPC!.enemy = nil
            newEnemy = NPC_CheckEnemy(NPCInfo!.confusionTime < level.time, false, false)
            NPC!.enemy = sav_enemy
            if newEnemy != nil && newEnemy != sav_enemy {
                //picked up a new enemy!
                NPC!.lastEnemy = NPC!.enemy
                G_SetEnemy(NPC!, newEnemy!)
            }
            NPCInfo!.enemyCheckDebounceTime = level.time + Q_irand(1000, 3000)
        }
    }
}
