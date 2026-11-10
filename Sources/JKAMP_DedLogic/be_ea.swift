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
var botinputs: Slots<BotInput>? {
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
func EA_Say(_ client: Int32, _ str: String) {
    // Port-note: botimport.BotClientCommand takes the command as an OpaquePointer, so no call can pass the text, row BL1.
    // Raven wrote: botimport.BotClientCommand(client, va("say %s", str))
    portMissing("EA_Say", source: "oracle/codemp/botlib/be_ea.cpp:35")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:45
func EA_SayTeam(_ client: Int32, _ str: String) {
    // Port-note: botimport.BotClientCommand takes the command as an OpaquePointer, so no call can pass the text, row BL1.
    // Raven wrote: botimport.BotClientCommand(client, va("say_team %s", str))
    portMissing("EA_SayTeam", source: "oracle/codemp/botlib/be_ea.cpp:45")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:55
func EA_Tell(_ client: Int32, _ clientto: Int32, _ str: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port EA_Tell
    portMissing("EA_Tell", source: "oracle/codemp/botlib/be_ea.cpp:55")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:65
func EA_UseItem(_ client: Int32, _ it: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port EA_UseItem
    portMissing("EA_UseItem", source: "oracle/codemp/botlib/be_ea.cpp:65")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:75
func EA_DropItem(_ client: Int32, _ it: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port EA_DropItem
    portMissing("EA_DropItem", source: "oracle/codemp/botlib/be_ea.cpp:75")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:85
func EA_UseInv(_ client: Int32, _ inv: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port EA_UseInv
    portMissing("EA_UseInv", source: "oracle/codemp/botlib/be_ea.cpp:85")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:95
func EA_DropInv(_ client: Int32, _ inv: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    // TODO: Port EA_DropInv
    portMissing("EA_DropInv", source: "oracle/codemp/botlib/be_ea.cpp:95")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:105
func EA_Gesture(_ client: Int32) {
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
func EA_Command(_ client: Int32, _ command: inout JKAShared.CharBuf) {
    // Port-note: botimport.BotClientCommand takes the command as an OpaquePointer, so no call can pass the text, row BL1.
    // Raven wrote: botimport.BotClientCommand(client, command)
    portMissing("EA_Command", source: "oracle/codemp/botlib/be_ea.cpp:119")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ea.cpp:129
func EA_SelectWeapon(_ client: Int32, _ weapon: Int32) {
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
func EA_Attack(_ client: Int32) {
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
func EA_Alt_Attack(_ client: Int32) {
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
func EA_ForcePower(_ client: Int32) {
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
func EA_Talk(_ client: Int32) {
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
func EA_Use(_ client: Int32) {
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
func EA_Respawn(_ client: Int32) {
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
func EA_Jump(_ client: Int32) {
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
func EA_DelayedJump(_ client: Int32) {
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
func EA_Crouch(_ client: Int32) {
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
func EA_Walk(_ client: Int32) {
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
func EA_Action(_ client: Int32, _ action: Int32) {
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
func EA_MoveUp(_ client: Int32) {
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
func EA_MoveDown(_ client: Int32) {
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
func EA_MoveForward(_ client: Int32) {
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
func EA_MoveBack(_ client: Int32) {
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
func EA_MoveLeft(_ client: Int32) {
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
func EA_MoveRight(_ client: Int32) {
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
func EA_Move(_ client: Int32, _ dir: JKAShared.vec3_t, _ speed: Float) {
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
func EA_View(_ client: Int32, _ viewangles: JKAShared.vec3_t) {
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
func EA_EndRegular(_ client: Int32, _ thinktime: Float) {
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
func EA_GetInput(_ client: Int32, _ thinktime: Float, _ input: BotInput) {
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
func EA_ResetInput(_ client: Int32) {
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
func EA_Setup() -> Int32 {
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
func EA_Shutdown() {
    // AI: Raven hands the `bot_input_t *` to FreeMemory. The call hands the handle of the base of the table.
    FreeMemory(OpaquePointer(botinputs!.base))
    botinputs = nil
}
