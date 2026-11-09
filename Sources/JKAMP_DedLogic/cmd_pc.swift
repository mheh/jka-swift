import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// One row of Raven's command list of `cmd_pc.cpp`, the `cmd_function_t` record with the command function as a Swift function value.
/// A nil function is a command for completion only, which the cgame or the game handles.
/// Source: oracle/codemp/qcommon/cmd_pc.cpp:3
// AI: Raven links the record through `next`. The row has no link, because the command list is an Array in Raven's order.
struct CmdFunctionRow {
    var name: String
    var function: (() -> Void)?
}

/// Source: oracle/codemp/qcommon/cmd_pc.cpp:11
var cmd_functions: [CmdFunctionRow] {		// possible commands to execute
    get { world.cmd_functions }
    set { world.cmd_functions = newValue }
}

/**
```
============
Cmd_AddCommand
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_pc.cpp:19
func Cmd_AddCommand(_ cmd_name: String, _ function: (() -> Void)?) {
    // fail if the command already exists
    for cmd in cmd_functions {
        if strcmp(cmd_name, cmd.name) == 0 {
            // allow completion-only commands to be silently doubled
            if function != nil {
                Com_Printf("Cmd_AddCommand: %s already defined\n", cmd_name)
            }
            return
        }
    }

    // use a small malloc to avoid zone fragmentation
    // AI: Raven takes the record from S_Malloc and links it at the head. The row goes in at index 0, and CopyString keeps the zone count of the name.
    let cmd = CmdFunctionRow(name: CopyString(cmd_name), function: function)
    cmd_functions.insert(cmd, at: 0)
}

/**
```
============
Cmd_RemoveCommand
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_pc.cpp:46
func Cmd_RemoveCommand(_ cmd_name: String) {
    // AI: Raven walks the list through the address of each link. The body walks the Array by index.
    var back = 0
    while true {
        if back >= cmd_functions.count {
            // command wasn't active
            return
        }
        let cmd = cmd_functions[back]
        if strcmp(cmd_name, cmd.name) == 0 {
            // AI: Raven unlinks the record and frees the name and the record with Z_Free. The row leaves the Array, and a String needs no free.
            cmd_functions.remove(at: back)
            return
        }
        back += 1
    }
}

/**
```
============
Cmd_CommandCompletion
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_pc.cpp:75
func Cmd_CommandCompletion(_ callback: ((String) -> Void)?) {
    for cmd in cmd_functions {
        callback!(cmd.name)
    }
}

/**
```
============
Cmd_ExecuteString

A complete command line has been parsed, so try to execute it
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_pc.cpp:91
func Cmd_ExecuteString(_ text: String) {
    // execute the command line
    Cmd_TokenizeString(text)
    if Cmd_Argc() == 0 {
        return // no tokens
    }

    // check registered command functions
    // AI: Raven walks the list through the address of each link. The body walks the Array by index.
    var prev = 0
    while prev < cmd_functions.count {
        let cmd = cmd_functions[prev]
        if Q_stricmp(Cmd_Argv(0), cmd.name) == 0 {
            // rearrange the links so that the command will be
            // near the head of the list next time it is used
            // AI: Raven relinks the record at the head. The row moves to index 0.
            cmd_functions.remove(at: prev)
            cmd_functions.insert(cmd, at: 0)

            // perform the action
            if cmd.function == nil {
                // let the cgame or game handle it
                break
            } else {
                cmd.function!()
            }
            return
        }
        prev += 1
    }

    // check cvars
    if Cvar_Command() {
        return
    }

    // check client game commands
    if com_cl_running != nil && com_cl_running!.integer != 0 && CL_GameCommand() {
        return
    }

    // check server game commands
    if com_sv_running != nil && com_sv_running!.integer != 0 && SV_GameCommand() {
        return
    }

    // check ui commands
    if com_cl_running != nil && com_cl_running!.integer != 0 && UI_GameCommand() {
        return
    }

    // send it as a server command if we are connected
    // this will usually result in a chat message
    //CL_ForwardCommandToServer ( text );
    CL_ForwardCommandToServer(text)
}

/**
```
============
Cmd_List_f
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_pc.cpp:153
func Cmd_List_f() {
    var i: Int32
    var match: String?

    if Cmd_Argc() > 1 {
        match = Cmd_Argv(1)
    } else {
        match = nil
    }

    i = 0
    for cmd in cmd_functions {
        if let match {
            var filter = CharBuf(match)
            var name = CharBuf(cmd.name)
            if Com_Filter(&filter, &name, 0) == 0 { continue }
        }

        Com_Printf("%s\n", cmd.name)
        i += 1
    }
    Com_Printf("%i commands\n", i)
}
