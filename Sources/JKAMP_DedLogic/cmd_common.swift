import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cmd_common.cpp:7
let MAX_CMD_BUFFER = 16384 as Int32

/// Source: oracle/codemp/qcommon/cmd_common.cpp:8
let MAX_CMD_LINE = 1024 as Int32

/// Source: oracle/codemp/qcommon/cmd_common.cpp:16
var cmd_wait: Int32 {
    get { world.variables.cmd_wait }
    set { world.variables.cmd_wait = newValue }
}

/// Source: oracle/codemp/qcommon/cmd_common.cpp:17
var cmd_text: Cmd { world.storage.cmd_text }

/// Source: oracle/codemp/qcommon/cmd_common.cpp:18
var cmd_text_buf: Slots<JKAShared.byte> { world.storage.cmd_text_buf }

/// Source: oracle/codemp/qcommon/cmd_common.cpp:290
var cmd_argc: Int32 {
    get { world.variables.cmd_argc }
    set { world.variables.cmd_argc = newValue }
}

/// Source: oracle/codemp/qcommon/cmd_common.cpp:291
var cmd_argv: [String] {
    get { world.variables.cmd_argv }
    set { world.variables.cmd_argv = newValue }
}

/// Source: oracle/codemp/qcommon/cmd_common.cpp:292
// Raven wrote: static char cmd_tokenized[BIG_INFO_STRING+MAX_STRING_TOKENS]
nonisolated(unsafe) var cmd_tokenized: JKAShared.CharBuf = JKAShared.CharBuf(9216)

/**
```
============
Cmd_Wait_f

Causes execution of the remainder of the command buffer to be delayed until
next frame.  This allows commands like:
bind g "cmd use rocket ; +attack ; wait ; -attack ; cmd use blaster"
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:32
func Cmd_Wait_f() {
    if Cmd_Argc() == 2 {
        cmd_wait = atoi(Cmd_Argv(1))
    } else {
        cmd_wait = 1
    }
}

/**
```
============
Cbuf_Init
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:54
func Cbuf_Init() {
    cmd_text.data = cmd_text_buf
    cmd_text.maxsize = MAX_CMD_BUFFER
    cmd_text.cursize = 0
}

/**
```
============
Cbuf_AddText

Adds command text at the end of the buffer, does NOT add a final \n
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:68
func Cbuf_AddText(_ text: String) {
    var l: Int32

    l = strlen(text)

    if cmd_text.cursize + l >= cmd_text.maxsize {
        Com_Printf("Cbuf_AddText: overflow\n")
        return
    }
    // AI: Raven copied the `char *` text to the address of one byte. The text crosses as a CharBuf, and the address is the Slots tail from `suffix(from:)`.
    Com_Memcpy(cmd_text.data!.suffix(from: Int(cmd_text.cursize)), CharBuf(text), l)
    cmd_text.cursize += l
}

/**
```
============
Cbuf_InsertText

Adds command text immediately after the current command
Adds a \n to the text
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:91
func Cbuf_InsertText(_ text: String) {
    var len: Int32
    var i: Int32

    len = strlen(text) + 1
    if len + cmd_text.cursize > cmd_text.maxsize {
        Com_Printf("Cbuf_InsertText overflowed\n")
        return
    }

    // move the existing command text
    i = cmd_text.cursize - 1
    while i >= 0 {
        cmd_text.data![i + len] = cmd_text.data![i]
        i -= 1
    }

    // copy the new text in
    // AI: Raven copied the `char *` text into the byte buffer. The text crosses as a CharBuf.
    Com_Memcpy(cmd_text.data!, CharBuf(text), len - 1)

    // add a \n
    cmd_text.data![len - 1] = JKAShared.byte(ascii: "\n")

    cmd_text.cursize += len
}

/**
```
============
Cbuf_ExecuteText
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:121
func Cbuf_ExecuteText(_ exec_when: Int32, _ text: String) {
    switch exec_when {
    case EXEC_NOW:
        if strlen(text) > 0 {
            Cmd_ExecuteString(text)
        } else {
            Cbuf_Execute()
        }

    case EXEC_INSERT:
        Cbuf_InsertText(text)

    case EXEC_APPEND:
        Cbuf_AddText(text)

    default:
        Com_Error(ERR_FATAL, "Cbuf_ExecuteText: bad exec_when")
    }
}

/**
```
============
Cbuf_Execute
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:148
func Cbuf_Execute() {
    var i: Int32
    var text: Slots<JKAShared.byte>
    var line = CharBuf(MAX_CMD_LINE)
    var quotes: Int32

    while cmd_text.cursize != 0 {
        if cmd_wait != 0 {
            // skip out while text still remains in buffer, leaving it
            // for next frame
            cmd_wait -= 1
            break
        }

        // find a \n or ; line break
        text = cmd_text.data!

        quotes = 0
        i = 0
        while i < cmd_text.cursize {
            if text[i] == Int32(ascii: "\"") {
                quotes += 1
            }
            if (quotes & 1) == 0 && text[i] == Int32(ascii: ";") {
                break  // don't break if inside a quoted string
            }
            if text[i] == Int32(ascii: "\n") || text[i] == Int32(ascii: "\r") {
                break
            }
            i += 1
        }

        if i >= (MAX_CMD_LINE - 1) {
            i = MAX_CMD_LINE - 1
        }

        Com_Memcpy(&line, text, i)
        line[i] = 0

        // delete the text from the command buffer and move remaining commands down
        // this is necessary because commands (exec) can insert data at the
        // beginning of the text buffer

        if i == cmd_text.cursize {
            cmd_text.cursize = 0
        } else {
            i += 1
            cmd_text.cursize -= i
            // AI: Raven moved the bytes from the pointer sum `text+i`. The source is the Slots tail from `suffix(from:)`.
            memmove(text, text.suffix(from: Int(i)), cmd_text.cursize)
        }

        // execute the command line

        Cmd_ExecuteString(String(line))
    }
}

/**
```
===============
Cmd_Exec_f
===============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:219
func Cmd_Exec_f() {
    var f = CharBuf(0)
    var len: Int32
    var filename = CharBuf(MAX_QPATH)

    if Cmd_Argc() != 2 {
        Com_Printf("exec <filename> : execute a script file\n")
        return
    }

    Q_strncpyz(&filename, Cmd_Argv(1), Int32((filename).count))
    COM_DefaultExtension(&filename, Int32((filename).count), ".cfg")
    len = FS_ReadFile(String(filename), &f)
    // AI: Raven tested the buffer for NULL. The CharBuf form gives an empty buffer for a missing file, so the test reads the length.
    if len < 0 {
        Com_Printf("couldn't exec %s\n", Cmd_Argv(1))
        return
    }
    Com_Printf("execing %s\n", Cmd_Argv(1))

    Cbuf_InsertText(String(f))

    FS_FreeFile(f)
}

/**
```
===============
Cmd_Vstr_f

Inserts the current value of a variable as command text
===============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:251
func Cmd_Vstr_f() {
    if Cmd_Argc() != 2 {
        Com_Printf("vstr <variablename> : execute a variable command\n")
        return
    }

    let v = Cvar_VariableString(Cmd_Argv(1))
    Cbuf_InsertText(va("%s\n", v))
}

/**
```
===============
Cmd_Echo_f

Just prints the rest of the line to the console
===============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:271
func Cmd_Echo_f() {
    var i: Int32 = 1
    while i < Cmd_Argc() {
        Com_Printf("%s ", Cmd_Argv(i))
        i += 1
    }
    Com_Printf("\n")
}

/**
```
============
Cmd_Argc
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:300
func Cmd_Argc() -> Int32 {
    return cmd_argc
}

/**
```
============
Cmd_Argv
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:309
func Cmd_Argv(_ arg: Int32) -> String {
    if arg < 0 || arg >= cmd_argc {
        return ""
    }
    return cmd_argv[arg]
}

/**
```
============
Cmd_ArgvBuffer

The interpreted versions use this because
they can't have pointers returned to them
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:324
func Cmd_ArgvBuffer(_ arg: Int32, _ buffer: inout JKAShared.CharBuf, _ bufferLength: Int32) {
    Q_strncpyz(&buffer, Cmd_Argv(arg), bufferLength)
}

/**
```
============
Cmd_Args

Returns a single string containing argv(1) to argv(argc()-1)
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:336
func Cmd_Args() -> String {
    var cmd_args = ""
    var i: Int32 = 1
    while i < cmd_argc {
        cmd_args += cmd_argv[i]
        if i != cmd_argc - 1 {
            cmd_args += " "
        }
        i += 1
    }

    return cmd_args
}

/**
```
============
Cmd_Args

Returns a single string containing argv(arg) to argv(argc()-1)
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:358
func Cmd_ArgsFrom(_ arg: Int32) -> String {
    var arg = arg
    var cmd_args = ""
    if arg < 0 {
        arg = 0
    }
    var i = arg
    while i < cmd_argc {
        cmd_args += cmd_argv[i]
        if i != cmd_argc - 1 {
            cmd_args += " "
        }
        i += 1
    }

    return cmd_args
}

/**
```
============
Cmd_ArgsBuffer

The interpreted versions use this because
they can't have pointers returned to them
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:383
func Cmd_ArgsBuffer(_ buffer: inout JKAShared.CharBuf, _ bufferLength: Int32) {
    Q_strncpyz(&buffer, Cmd_Args(), bufferLength)
}

/**
```
============
Cmd_TokenizeString

Parses the given string into command line tokens.
The text is copied to a seperate buffer and 0 characters
are inserted in the apropriate place, The argv array
will point into this temporary buffer.
============
```
*/
/// Source: oracle/codemp/qcommon/cmd_common.cpp:398
func Cmd_TokenizeString(_ text_in: String) {
    // clear previous args
    cmd_argc = 0

    let text = JKAShared.CharBuf(text_in)
    var t: Int32 = 0
    var textOut: Int32 = 0

    while true {
        if cmd_argc == MAX_STRING_TOKENS {
            return  // this is usually something malicious
        }

        while true {
            // skip whitespace
            while text[t] != 0 && text[t] <= Int32(ascii: " ") {
                t += 1
            }
            if text[t] == 0 {
                return  // all tokens parsed
            }

            // skip // comments
            if text[t] == Int32(ascii: "/") && text[t + 1] == Int32(ascii: "/") {
                return  // all tokens parsed
            }

            // skip /* */ comments
            if text[t] == Int32(ascii: "/") && text[t + 1] == Int32(ascii: "*") {
                while text[t] != 0 && (text[t] != Int32(ascii: "*") || text[t + 1] != Int32(ascii: "/")) {
                    t += 1
                }
                if text[t] == 0 {
                    return  // all tokens parsed
                }
                t += 2
            } else {
                break  // we are ready to parse a token
            }
        }

        // handle quoted strings
        if text[t] == Int32(ascii: "\"") {
            let start = textOut
            cmd_argc += 1
            t += 1
            while text[t] != 0 && text[t] != Int32(ascii: "\"") {
                cmd_tokenized[textOut] = text[t]
                textOut += 1
                t += 1
            }
            cmd_tokenized[textOut] = 0
            textOut += 1
            // AI: Raven pointed cmd_argv at the token in cmd_tokenized. The token is read out of cmd_tokenized as a String at its NUL.
            cmd_argv[cmd_argc - 1] = JKAShared.TextCursor(cmd_tokenized, at: start).text
            if text[t] == 0 {
                return  // all tokens parsed
            }
            t += 1
            continue
        }

        // regular token
        let start = textOut
        cmd_argc += 1

        // skip until whitespace, quote, or command
        while (text[t] as UInt8) > UInt8(ascii: " ") {
            if text[t] == Int32(ascii: "\"") {
                break
            }

            if text[t] == Int32(ascii: "/") && text[t + 1] == Int32(ascii: "/") {
                break
            }

            // skip /* */ comments
            if text[t] == Int32(ascii: "/") && text[t + 1] == Int32(ascii: "*") {
                break
            }

            cmd_tokenized[textOut] = text[t]
            textOut += 1
            t += 1
        }

        cmd_tokenized[textOut] = 0
        textOut += 1
        // AI: Raven pointed cmd_argv at the token in cmd_tokenized. The token is read out of cmd_tokenized as a String at its NUL.
        cmd_argv[cmd_argc - 1] = JKAShared.TextCursor(cmd_tokenized, at: start).text

        if text[t] == 0 {
            return  // all tokens parsed
        }
    }
}

/// Source: oracle/codemp/qcommon/cmd_common.cpp:501
func Cmd_Init() {
    Cmd_AddCommand("cmdlist", Cmd_List_f)
    Cmd_AddCommand("exec", Cmd_Exec_f)
    Cmd_AddCommand("vstr", Cmd_Vstr_f)
    Cmd_AddCommand("echo", Cmd_Echo_f)
    Cmd_AddCommand("wait", Cmd_Wait_f)
}
