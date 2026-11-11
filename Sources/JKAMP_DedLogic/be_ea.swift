import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ea.cpp:23
let MAX_USERMOVE = 400 as Int32

/// Source: oracle/codemp/botlib/be_ea.cpp:24
let MAX_COMMANDARGUMENTS = 10 as Int32

/// Source: oracle/codemp/botlib/be_ea.cpp:25
let ACTION_JUMPEDLASTFRAME = 0x0800000 as Int32

/// Source: oracle/codemp/botlib/be_ea.cpp:27
public var botinputs: Slots<BotInput>? {
    get { world.variables.botinputs }
    set { world.variables.botinputs = newValue }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:35
public func EA_Say(_ client: Int32, _ str: String) {
    botimport.runBotClientCommand(client, va("say %s", str))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:45
public func EA_SayTeam(_ client: Int32, _ str: String) {
    botimport.runBotClientCommand(client, va("say_team %s", str))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:55
public func EA_Tell(_ client: Int32, _ clientto: Int32, _ str: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    botimport.runBotClientCommand(client, va("tell %d, %s", clientto, str))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:65
public func EA_UseItem(_ client: Int32, _ it: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    botimport.runBotClientCommand(client, va("use %s", it))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:75
public func EA_DropItem(_ client: Int32, _ it: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    botimport.runBotClientCommand(client, va("drop %s", it))
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:85
public func EA_UseInv(_ client: Int32, _ inv: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    botimport.runBotClientCommand(client, va("invuse %s", inv))
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:95
public func EA_DropInv(_ client: Int32, _ inv: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    botimport.runBotClientCommand(client, va("invdrop %s", inv))
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:105
public func EA_Gesture(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_GESTURE
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:119
public func EA_Command(_ client: Int32, _ command: inout JKAShared.CharBuf) {
    // AI: Raven hands his `char *` buffer to the import. The run method takes a String, so the call hands the text of the CharBuf.
    botimport.runBotClientCommand(client, String(command))
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:129
public func EA_SelectWeapon(_ client: Int32, _ weapon: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.weapon = weapon
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:143
public func EA_Attack(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_ATTACK
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:157
public func EA_Alt_Attack(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_ALT_ATTACK
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:171
public func EA_ForcePower(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_FORCEPOWER
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:185
public func EA_Talk(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_TALK
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:199
public func EA_Use(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_USE
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:213
public func EA_Respawn(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_RESPAWN
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:227
public func EA_Jump(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    if (bi.actionflags & ACTION_JUMPEDLASTFRAME) != 0 {
        bi.actionflags &= ~ACTION_JUMP
    } //end if
    else {
        bi.actionflags |= ACTION_JUMP
    } //end if
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:248
public func EA_DelayedJump(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    if (bi.actionflags & ACTION_JUMPEDLASTFRAME) != 0 {
        bi.actionflags &= ~ACTION_DELAYEDJUMP
    } //end if
    else {
        bi.actionflags |= ACTION_DELAYEDJUMP
    } //end if
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:269
public func EA_Crouch(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_CROUCH
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:283
public func EA_Walk(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_WALK
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:297
public func EA_Action(_ client: Int32, _ action: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= action
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:311
public func EA_MoveUp(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_MOVEUP
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:325
public func EA_MoveDown(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_MOVEDOWN
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:339
public func EA_MoveForward(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_MOVEFORWARD
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:353
public func EA_MoveBack(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_MOVEBACK
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:367
public func EA_MoveLeft(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_MOVELEFT
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:381
public func EA_MoveRight(_ client: Int32) {
    let bi: BotInput

    bi = botinputs![client]
    bi.actionflags |= ACTION_MOVERIGHT
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:395
public func EA_Move(_ client: Int32, _ dir: JKAShared.vec3_t, _ speed: Float) {
    let bi: BotInput
    var speed = speed

    bi = botinputs![client]

    bi.dir = dir
    //cap speed
    if speed > MAX_USERMOVE { speed = Float(MAX_USERMOVE) }
    else if speed < -MAX_USERMOVE { speed = Float(-MAX_USERMOVE) }
    bi.speed = speed
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:413
public func EA_View(_ client: Int32, _ viewangles: JKAShared.vec3_t) {
    let bi: BotInput

    bi = botinputs![client]

    bi.viewangles = viewangles
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:427
public func EA_EndRegular(_ client: Int32, _ thinktime: Float) {
/*
	bot_input_t *bi;
	int jumped = qfalse;

	bi = &botinputs[client];

	bi->actionflags &= ~ACTION_JUMPEDLASTFRAME;

	bi->thinktime = thinktime;
	botimport.BotInput(client, bi);

	bi->thinktime = 0;
	VectorClear(bi->dir);
	bi->speed = 0;
	jumped = bi->actionflags & ACTION_JUMP;
	bi->actionflags = 0;
	if (jumped) bi->actionflags |= ACTION_JUMPEDLASTFRAME;
*/
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:454
public func EA_GetInput(_ client: Int32, _ thinktime: Float, _ input: BotInput) {
    let bi: BotInput
//	int jumped = qfalse;

    bi = botinputs![client]

//	bi->actionflags &= ~ACTION_JUMPEDLASTFRAME;

    bi.thinktime = thinktime
    input.copy(from: bi)
    /*
	bi->thinktime = 0;
	VectorClear(bi->dir);
	bi->speed = 0;
	jumped = bi->actionflags & ACTION_JUMP;
	bi->actionflags = 0;
	if (jumped) bi->actionflags |= ACTION_JUMPEDLASTFRAME;
	*/
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:481
public func EA_ResetInput(_ client: Int32) {
    let bi: BotInput
    var jumped: Int32 = 0

    bi = botinputs![client]
    bi.actionflags &= ~ACTION_JUMPEDLASTFRAME

    bi.thinktime = 0
    bi.dir = vec3_t()
    bi.speed = 0
    jumped = bi.actionflags & ACTION_JUMP
    bi.actionflags = 0
    if jumped != 0 { bi.actionflags |= ACTION_JUMPEDLASTFRAME }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:502
public func EA_Setup() -> Int32 {
    //initialize the bot inputs
    botinputs = Slots<BotInput>(GetClearedHunkMemory(botlibglobals.maxclients * Int32(BotInput.byteCount)), count: botlibglobals.maxclients)
    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:515
public func EA_Shutdown() {
    // AI: Raven hands the `bot_input_t *` to FreeMemory. The call hands the handle of the base of the table.
    FreeMemory(OpaquePointer(botinputs!.base))
    botinputs = nil
}
