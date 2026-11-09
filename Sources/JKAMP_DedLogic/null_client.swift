import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/null_client.cpp:5
// Raven wrote: char cl_cdkey[17] = "123456789"
nonisolated(unsafe) let cl_cdkey: JKAShared.CharBuf = CharBuf(bytes: [0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

/// Source: oracle/codemp/null/null_client.cpp:7
var cl_shownet: JKAMP.Cvar? {
    get { world.variables.cl_shownet }
    set { world.variables.cl_shownet = newValue }
}

/// Source: oracle/codemp/null/null_client.cpp:9
func CL_Shutdown() {
}

/// Source: oracle/codemp/null/null_client.cpp:12
func CL_Init() {
    cl_shownet = Cvar_Get("cl_shownet", "0", CVAR_TEMP)
}

/// Source: oracle/codemp/null/null_client.cpp:16
func CL_MouseEvent(_ dx: Int32, _ dy: Int32, _ time: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:19
func Key_WriteBindings(_ f: JKAShared.fileHandle_t) {
}

/// Source: oracle/codemp/null/null_client.cpp:22
func CL_Frame(_ msec: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:25
func CL_PacketEvent(_ from: Netadr, _ msg: Msg) {
}

/// Source: oracle/codemp/null/null_client.cpp:28
func CL_CharEvent(_ key: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:31
func CL_Disconnect(_ showMainMenu: Bool) {
}

/// Source: oracle/codemp/null/null_client.cpp:34
func CL_MapLoading() {
}

/// Source: oracle/codemp/null/null_client.cpp:37
func CL_GameCommand() -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_client.cpp:41
func CL_KeyEvent(_ key: Int32, _ down: Bool, _ time: UInt32) {
}

/// Source: oracle/codemp/null/null_client.cpp:44
func UI_GameCommand() -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_client.cpp:48
func CL_ForwardCommandToServer(_ string: String) {
}

/// Source: oracle/codemp/null/null_client.cpp:51
func CL_ConsolePrint(_ txt: String, _ silent: Bool) {
}

/// Source: oracle/codemp/null/null_client.cpp:54
func CL_JoystickEvent(_ axis: Int32, _ value: Int32, _ time: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:57
func CL_InitKeyCommands() {
}

/// Source: oracle/codemp/null/null_client.cpp:60
func CL_CDDialog(_ msg: String) {
}

/// Source: oracle/codemp/null/null_client.cpp:63
func CL_FlushMemory() {
}

/// Source: oracle/codemp/null/null_client.cpp:66
func CL_StartHunkUsers() {
}
