import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/null/null_client.cpp:5
// Raven wrote: char cl_cdkey[17] = "123456789"
public nonisolated(unsafe) let cl_cdkey: JKAShared.CharBuf = CharBuf(bytes: [0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

/// Source: oracle/codemp/null/null_client.cpp:7
public var cl_shownet: JKAMP.Cvar? {
    get { world.variables.cl_shownet }
    set { world.variables.cl_shownet = newValue }
}

/// Source: oracle/codemp/null/null_client.cpp:9
public func CL_Shutdown() {
}

/// Source: oracle/codemp/null/null_client.cpp:12
public func CL_Init() {
    cl_shownet = Cvar_Get("cl_shownet", "0", CVAR_TEMP)
}

/// Source: oracle/codemp/null/null_client.cpp:16
public func CL_MouseEvent(_ dx: Int32, _ dy: Int32, _ time: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:19
public func Key_WriteBindings(_ f: JKAShared.fileHandle_t) {
}

/// Source: oracle/codemp/null/null_client.cpp:22
public func CL_Frame(_ msec: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:25
public func CL_PacketEvent(_ from: Netadr, _ msg: Msg) {
}

/// Source: oracle/codemp/null/null_client.cpp:28
public func CL_CharEvent(_ key: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:31
public func CL_Disconnect(_ showMainMenu: Bool) {
}

/// Source: oracle/codemp/null/null_client.cpp:34
public func CL_MapLoading() {
}

/// Source: oracle/codemp/null/null_client.cpp:37
public func CL_GameCommand() -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_client.cpp:41
public func CL_KeyEvent(_ key: Int32, _ down: Bool, _ time: UInt32) {
}

/// Source: oracle/codemp/null/null_client.cpp:44
public func UI_GameCommand() -> Bool {
    return false
}

/// Source: oracle/codemp/null/null_client.cpp:48
public func CL_ForwardCommandToServer(_ string: String) {
}

/// Source: oracle/codemp/null/null_client.cpp:51
public func CL_ConsolePrint(_ txt: String, _ silent: Bool) {
}

/// Source: oracle/codemp/null/null_client.cpp:54
public func CL_JoystickEvent(_ axis: Int32, _ value: Int32, _ time: Int32) {
}

/// Source: oracle/codemp/null/null_client.cpp:57
public func CL_InitKeyCommands() {
}

/// Source: oracle/codemp/null/null_client.cpp:60
public func CL_CDDialog(_ msg: String) {
}

/// Source: oracle/codemp/null/null_client.cpp:63
public func CL_FlushMemory() {
}

/// Source: oracle/codemp/null/null_client.cpp:66
public func CL_StartHunkUsers() {
}
